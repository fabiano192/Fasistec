#include "TOTVS.ch"
#include "TOPCONN.ch"

/*/
Funçao    	³ CR0109
Autor 		³ Fabiano da Silva
Data 		³ 10.09.18
Descricao 	³ Programação Entrega John Deere (000063)
/*/

User Function CR0110()

	LOCAL _oDlg := NIL

	PRIVATE _cTitulo    	:= "Programação Entrega John Deere"
	PRIVATE _aCabec 	:= {}
	PRIVATE _aItens 	:= {}
	PRIVATE lMsErroAuto := .F.
	PRIVATE _cNum
	Private _cJDeFold	:= GetMV("CR_JDEFOLD")

	_nOpc := 0

	DEFINE MSDIALOG _oDlg FROM 264,182 TO 441,613 TITLE _cTitulo OF _oDlg PIXEL

	@ 004,010 TO 060,157 LABEL "" OF _oDlg PIXEL

	@ 010,017 SAY "Esta rotina tem por objetivo importar as Programções" 	OF _oDlg PIXEL Size 150,010
	@ 020,017 SAY "de Entrega da John Deere."			 					OF _oDlg PIXEL Size 150,010
	@ 050,017 SAY "Programa CR0109.PRW" 									OF _oDlg PIXEL Size 150,010

	@ 15,165 BUTTON "OK" 		 SIZE 036,012 ACTION (_nOpc := 1,_oDlg:End())OF _oDlg PIXEL
	@ 40,165 BUTTON "Sair"       SIZE 036,012 ACTION ( _oDlg:End()) 		OF _oDlg PIXEL

	ACTIVATE MSDIALOG _oDlg CENTERED

	If _nOpc = 1
		Private _lFim      := .F.
		Private _cMsg01    := ''
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| CR109A(@_lFim) }
		Private __cTitulo01 := 'Processando'
		Processa( _bAcao01, __cTitulo01, _cMsg01, _lAborta01 )

		_bAcao01   := {|_lFim| CR109B(@_lFim) }
		__cTitulo01 := 'Integrando os Pedidos...'
		Processa( _bAcao01, __cTitulo01, _cMsg01, _lAborta01 )

		If !Empty(_aItens)
			MATA410(_aCabec,_aItens,3)
		Endif

		If lMsErroAuto
			MostraErro()
		EndIf

		_bAcao01   := {|_lFim| CR109C(@_lFim) }
		__cTitulo01 := 'Gerando relatório de inconsistências...'
		Processa( _bAcao01, __cTitulo01, _cMsg01, _lAborta01 )
	Endif


Return(Nil)



Static Function CR109A(_lFim)

	Private _cItem,_lAchou,_nPrcVen, _cPedido

	aStru := {}
	AADD(aStru,{"INDICE"   , "C" , 01, 0 })
	AADD(aStru,{"PRODCLI"  , "C" , 15, 0 })
	AADD(aStru,{"CLIENTE"  , "C" , 06, 0 })
	AADD(aStru,{"LOJA"     , "C" , 02, 0 })
	AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
	AADD(aStru,{"PEDCLI"   , "C" , 20, 0 })

	cArqLOG := CriaTrab(aStru,.T.)
	cIndLOG := "INDICE+PRODUTO+PRODCLI"
	dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

	dbSelectArea("TRB")
	IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

	_cCont     := ""
	_cUM       := ""
	_dDtMov    := Ctod("")
	_cCliente  := ""
	_cLoja     := ""
	_cSemAtu   := ""
	_cSemAtu2  := ""
	_dDtAtu    := Ctod("")
	_cSemAnt   := ""
	_cPrdCliente  := ""
	_cProdCron := ""
	_cLocDest  := ""
	_cContato  := ""
	_cTipo     := ""
	_cUltNf    := ""
	_cSerNf    := ""
	_dDtUltNf  := Ctod("")
	_dDtEnt    := Ctod("")
	_nQtEnt    := ""
	_aDtEnt    := {}
	_cPedido   := ""
	_aPedido   := {}
	_cDesenho  := ""

	_cData2    := GravaData(dDataBase,.f.,8)
	_cHora2    := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
	_dDt       := dDataBase - 20

	ProcRegua(20)

	IncProc()

	_aArqTxt:=ARRAY(ADIR(_cJDeFold+"ENTRADA\*.TXT"))
	ADIR(_cJDeFold+"ENTRADA\*.TXT",_aArqTxt)

	For I:= 1 to Len(_aArqTxt)

		_lAchou    := .t.
		_cArq2    := _cJDeFold+"ENTRADA\BKP\BKP_EM"+_cData2+_cHora2+"_"+Alltrim(_aArqTxt[i])
		_cArq3    := _cJDeFold+"ENTRADA\"+Alltrim(_aArqTxt[i])

		_cArqNovo := fCreate(Alltrim(_cArq2),0)
		_cArq     := FOpen(_cArq3,0)
		_cQtArq    := 1

		While .T.

			_cLine := fReadStr(_cArq,130)

			If Len(_cLine) == 0
				Exit
			Endif

			If Substr(_cLine,1,3) == "ITP"
				_cCont   := Subst(_cLine,9,5)
				//				_dDTMov  := Ctod(Subst(_cLine,18,2)+"/"+Subst(_cLine,16,2)+"/20"+Subst(_cLine,14,2))
				_dDTMov  := Stod("20"+Substr(_cLine,14,6))

				SA1->(dbSetOrder(3))
				If SA1->(dbSeek(xFilial("SA1")+Subst(_cLine,26,14)))
					_cCliente := SA1->A1_COD
					_cLoja    := SA1->A1_LOJA
				Endif
			ElseIf Substr(_cLine,1,3) == "PP1"
				//				_dDtEmis    := Ctod(Subst(_cLine,20,2)+"/"+Subst(_cLine,18,2)+"/20"+Subst(_cLine,16,2))
				_nDecimal	:= Val(Substr(_cLine,8,1))
				_cPedCli	:= Alltrim(Substr(_cLine,9,12))
				_dDtEmis	:= Stod("20"+Substr(_cLine,16,6))
			ElseIf Substr(_cLine,1,3) == "PP2"
				_cPrdCli	:= Alltrim(Substr(_cLine,4,30))
				_nQtdPed	:= Val(If(_nDecimal > 0,Alltrim(Substr(_cLine,34,9-_nDecimal))+'.'+Alltrim(Substr(_cLine,42-_nDecimal,_nDecimal)),;
				Alltrim(Substr(_cLine,34,9-_nDecimal))))
				_cDescPr	:= Alltrim(Substr(_cLine,43,25))
				_nVlrPrd	:= Val(Alltrim(Substr(_cLine,68,7))+"."+Alltrim(Substr(_cLine,74,5)))
				_cItPedi	:= Alltrim(Substr(_cLine,86,4))
				_dDtEnt		:= Stod("20"+Substr(_cLine,90,6))

				SZ2->(dbSetOrder(8))
				If SZ2->(dbSeek(xFilial("SZ2")+_cCliente + _cLOja + Padr(_cPrdCli,15) + Padr(_cPedCli,20) + "1"))
					_cPrdCro := SZ2->Z2_PRODUTO
					_cTpPed    := '1'

					SZ4->(RecLock("SZ4",.T.))
					SZ4->Z4_FILIAL  := xFilial("SZ4")
					SZ4->Z4_CODCLI  := _cCliente
					SZ4->Z4_LOJA    := _cLoja
					SZ4->Z4_PRODPAS := _cPrdCro
					SZ4->Z4_PRODCLI := _cPrdCli
					SZ4->Z4_DTMOV   := _dDtEmis
					SZ4->Z4_CONTROL := _cCont
					SZ4->Z4_DTATU   := _dDtEmis
					SZ4->Z4_DTENT   := _dDtEnt
					SZ4->Z4_QTENT   := _aQuant[B][2]
					SZ4->Z4_PEDIDO  := _nQtdPed
					SZ4->Z4_TPPED   := _cTpPed
					SZ4->Z4_DTDIGIT := dDataBase
					SZ4->Z4_NOMARQ  := UPPER(Alltrim(_aArqTxt[i]))
					SZ4->(MsUnlock())
				Else
					TRB->(RecLock("TRB",.T.))
					TRB->INDICE  := "1"
					TRB->PRODCLI := _cPrdCli
					TRB->CLIENTE := _cCliente
					TRB->LOJA    := _cLoja
					TRB->PEDCLI  := _cPedCli
					TRB->(MsUnlock())
				Endif

			Endif

			FWrite(_cArqNovo,_cLine)
		EndDo

		fClose(_cArq2)

		If File(_cArq3)
			FClose(_cArq)
			FErase(_cArq3)
		Endif
	Next I

Return (Nil)




Static Function CR109B(_lFim)

	SZ4->(dbSetOrder(1))

	Private _lNAchou   := .F.
	_lFim      := .F.

	_lNAchou := .F.

	_cq  := "UPDATE "+RetSqlName("SD2")+" SET D2_PROGENT = 0 WHERE D2_CLIENTE = '000063' AND D_E_L_E_T_ = ''"

	TCSQLEXEC(_cq)
	_cq1  := "UPDATE "+RetSqlName("SC6")+" SET C6_LA = '' WHERE C6_CLI = '000063' AND D_E_L_E_T_ = '' "

	TCSQLEXEC(_cq1)

	_lEntr := .F.

	SZ4->(dbSetOrder(4))
	If SZ4->(dbSeek(xFilial("SZ4")+DTOS(dDataBase),.F.))

		ProcRegua(RecCount())

		While SZ4->(!Eof()) .And. SZ4->Z4_DTDIGIT == dDataBase

			_cItem     := "00"
			_cClieLoja := SZ4->Z4_CODCLI + SZ4->Z4_LOJA

			While SZ4->(!Eof()) .And.	_cClieLoja == SZ4->Z4_CODCLI + SZ4->Z4_LOJA .And. SZ4->Z4_DTDIGIT == dDataBase

				IncProc()

				If SZ4->Z4_CODCLI != "000063"
					SZ4->(dbSkip())
					Loop
				Endif

				If SZ4->Z4_INTEGR = "S"
					SZ4->(dbSkip())
					Loop
				Endif

				If Empty(SZ4->Z4_PRODPAS)
					SZ4->(dbSkip())
					Loop
				Endif

				SZ2->(dbSetOrder(1))
				If SZ2->(!dbSeek(xFilial("SZ2")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA+SZ4->Z4_PRODPAS+SZ4->Z4_PRODCLI+"1"))
					SZ4->(dbSkip())
					Loop
				Endif

				dDataRef := SZ2->Z2_DTREF01
				nValor   := SZ2->Z2_PRECO01
				For i := 2 to 12
					If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= dDataRef
						dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
						nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
					Endif
				Next i

				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+SZ4->Z4_PRODPAS))

				If SB1->B1_MSBLQL = '1'
					TRB->(RecLock("TRB",.T.))
					TRB->INDICE  := "2"
					TRB->PRODUTO := SZ4->Z4_PRODPAS
					TRB->(MsUnlock())
				Endif

				_nPrcVen := nValor

				_cPrdCli := SZ4->Z4_PRODCLI

				While SZ4->(!Eof()) .And. _cPrdCli == SZ4->Z4_PRODCLI

					If _lFim
						Alert("Cancelado Pelo Usuario!!!!!!")
						Return
					Endif

					DadosPedido()

					SZ4->(RecLock("SZ4",.F.))
					SZ4->Z4_INTEGR := "S"
					SZ4->Z4_IMPRES := "S"
					SZ4->(MsUnlock())

					_lEntr := .T.

					SZ4->(dbSkip())
				EndDo

			EndDo
		EndDo
	Endif

	//Inicio da Eliminação de Resíduo
/*	If _lEntr
		_cq3  := " UPDATE "+RetSqlName("SC6")+" SET C6_BLQ = 'R', C6_XDTELIM = '"+DTOS(dDataBase)+"', C6_LOCALIZ = 'CR0109' "
		_cq3  += " WHERE C6_LA <> 'OK' AND D_E_L_E_T_ = '' AND C6_PEDAMOS IN ('N','Z','M','I') AND C6_QTDENT < C6_QTDVEN AND C6_CLI = '000063' "
		_cq3  += " AND C6_BLQ = '' AND C6_CPROCLI <> '' "

		TCSQLEXEC(_cq3)
	Endif*/
	// Fim da eliminação de resíduo

Return (Nil)



//Relatório de Inconsistências
Static Function CR109C()

	Local oFwMsEx 		:= NIL
	Local cArq 			:= ""
	Local cDir 			:= GetSrvProfString("Startpath","")
	Local cWorkSheet	:= ""
	Local cTable 		:= ""
	Local cDirTmp 		:= GetTempPath()

	/*
	Indice		Descrição
	1			Cliente não Cadastrado
	2			Produto Não cadastrado
	*/

	oFwMsEx := FWMsExcel():New()

	TRB->(dbGotop())

	While !TRB->(Eof())

		_cInd := TRB->INDICE

		If _cInd = '1'
			cWorkSheet 	:= 	"Produto não Cadastrado"
			cTable 		:= 	"Produto não Cadastrado"

			oFwMsEx:AddWorkSheet( cWorkSheet )
			oFwMsEx:AddTable( cWorkSheet, cTable )

			oFwMsEx:AddColumn( cWorkSheet, cTable , "Cliente"   		, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Loja"   			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto Cliente"	, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Pedido Cliente"    , 1,1,.F.)
		Else
			cWorkSheet 	:= 	"Produto Bloqueado"
			cTable 		:= 	"Produto Bloqueado"

			oFwMsEx:AddWorkSheet( cWorkSheet )
			oFwMsEx:AddTable( cWorkSheet, cTable )

			oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto"   		, 1,1,.F.)
		Endif

		While !TRB->(Eof()) .And. _cInd == TRB->INDICE

			If _cInd = '1'
				oFwMsEx:AddRow( cWorkSheet, cTable,{;
				TRB->CLIENTE	,;
				TRB->LOJA    	,;
				TRB->PRODCLI    ,;
				TRB->PEDCLI    	})
			Else
				oFwMsEx:AddRow( cWorkSheet, cTable,{;
				TRB->PRODUTO	})

			Endif

			TRB->(dbSkip())
		EndDo
	EndDo

	TRB->(dbCloseArea())

	oFwMsEx:Activate()

	cArq := CriaTrab( NIL, .F. ) + ".xml"

	LjMsgRun( "Gerando o arquivo, aguarde...", "Programação_Iveco", {|| oFwMsEx:GetXMLFile( cArq ) } )

	If __CopyFile( cArq, cDirTmp + cArq )
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDirTmp + cArq )
		oExcelApp:SetVisible(.T.)
	Else
		MsgInfo( "Arquivo não copiado para temporário do usuário." )

		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( _cDir + cArq )
		oExcelApp:SetVisible(.T.)
	Endif

Return



Static Function DadosPedido()

	Local _aLinha
	Local nX     := 0
	Local nY     := 0

	_cItem 	:= SomaIt(_cItem)

	If _cItem  = 'Z0'

		MATA410(_aCabec,_aItens,3)

		If lMsErroAuto
			MostraErro()
		EndIf
		_cItem  = '01'

		_aCabec 	:= {}
		_aItens 	:= {}
		lMsErroAuto := .F.

	Endif

	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA))

	If _cItem = '01'
		_cNum := GetSxeNum("SC5","C5_NUM")

		RollBAckSx8()

		aadd(_aCabec,{"C5_NUM"     	, _cNum				,Nil})
		aadd(_aCabec,{"C5_TIPO"    	, "N"				,Nil})
		aadd(_aCabec,{"C5_CLIENTE"	, SZ4->Z4_CODCLI	,Nil})
		aadd(_aCabec,{"C5_CLIENT"  	, SZ4->Z4_CODCLI	,Nil})
		aadd(_aCabec,{"C5_LOJAENT" 	, SZ4->Z4_LOJA		,Nil})
		aadd(_aCabec,{"C5_LOJACLI" 	, SZ4->Z4_LOJA		,Nil})
		aadd(_aCabec,{"C5_TRANSP"  	, SA1->A1_TRANSP	,Nil})
		aadd(_aCabec,{"C5_TIPOCLI" 	, SA1->A1_TIPO		,Nil})
		aadd(_aCabec,{"C5_CONDPAG" 	, SA1->A1_COND		,Nil})
		aadd(_aCabec,{"C5_TIPLIB"  	, "1"				,Nil})
		aadd(_aCabec,{"C5_VEND1"   	, SA1->A1_VEND		,Nil})
		aadd(_aCabec,{"C5_COMIS1"  	, SA1->A1_COMIS		,Nil})
		aadd(_aCabec,{"C5_EMISSAO" 	, dDataBase			,Nil})
		aadd(_aCabec,{"C5_PESOL"   	, 1					,Nil})
		aadd(_aCabec,{"C5_MOEDA"   	, 1					,Nil})
		aadd(_aCabec,{"C5_TXMOEDA" 	, 1					,Nil})
		aadd(_aCabec,{"C5_TPCARGA" 	, "2"				,Nil})
	Endif

	SF4->(dbSetOrder(1))
	SF4->(dbSeek(xFilial("SF4")+SZ2->Z2_TES))

	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+SZ4->Z4_PRODPAS))

	_aLinha := {}

	aadd(_aLinha,{"C6_NUM"     , _cNUm						,Nil})
	aadd(_aLinha,{"C6_ITEM"    , _cItem						,Nil})
	aadd(_aLinha,{"C6_CPROCLI" , SZ4->Z4_PRODCLI			,Nil})
	aadd(_aLinha,{"C6_PRODUTO" , SZ4->Z4_PRODPAS			,Nil})
	aadd(_aLinha,{"C6_REVPED"  , SZ4->Z4_ALTTEC				,Nil})
	aadd(_aLinha,{"C6_QTDVEN"  , SZ4->Z4_QTENT				,Nil})
	aadd(_aLinha,{"C6_PRCVEN"  , _nPrcVen					,Nil})
	aadd(_aLinha,{"C6_VALOR"   , Round(( SZ4->Z4_QTENT * _nPrcVen ),2)		,Nil})
	aadd(_aLinha,{"C6_ENTREG"  , SZ4->Z4_DTENT				,Nil})
	If SZ4->Z4_TPPED == "1"
		aadd(_aLinha,{"C6_PEDAMOS" , "N"					,Nil})
	ElseIf SZ4->Z4_TPPED == "2"
		aadd(_aLinha,{"C6_PEDAMOS" , "I"					,Nil})
	ElseIf SZ4->Z4_TPPED == "3"
		aadd(_aLinha,{"C6_PEDAMOS" , "M"					,Nil})
	ElseIf SZ4->Z4_TPPED == "4"
		aadd(_aLinha,{"C6_PEDAMOS" , "Z"					,Nil})
	Endif

	If SZ4->Z4_TIPO == "A"
		aadd(_aLinha,{"C6_PEDAMOS" , "A"					,Nil})
	Endif

	aadd(_aLinha,{"C6_TES"     , SZ2->Z2_TES				,Nil})

	If SA1->A1_EST == "SP"
		_cCf        := "5"
	ElseIf SA1->A1_EST == "EX"
		_cCf        := "7"
	Else
		_cCF        := "6"
	Endif
	aadd(_aLinha,{"C6_CF"      , _cCf + Substr(SF4->F4_CF,2,3)		,Nil})
	aadd(_aLinha,{"C6_UM"      , SB1->B1_UM				,Nil})
	aadd(_aLinha,{"C6_PEDCLI"  , SZ4->Z4_PEDIDO			,Nil})
	aadd(_aLinha,{"C6_POLINE"  , "1"					,Nil})
	aadd(_aLinha,{"C6_DESCRI"  , SB1->B1_DESC			,Nil})
	aadd(_aLinha,{"C6_LOCAL"   , SB1->B1_LOCPAD			,Nil})
	aadd(_aLinha,{"C6_CLI"     , SZ4->Z4_CODCLI			,Nil})
	aadd(_aLinha,{"C6_LOJA"    , SZ4->Z4_LOJA			,Nil})
	aadd(_aLinha,{"C6_PRUNIT"  , _nPrcVen				,Nil})
	aadd(_aLinha,{"C6_TPOP"    , "F"					,Nil})
	aadd(_aLinha,{"C6_IDENCAT" , SZ4->Z4_SEMATU			,Nil})
	aadd(_aLinha,{"C6_LA" 		, "OK"					,Nil})
	aadd(_aLinha,{"C6_CLASFIS" , SUBSTR(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB		,Nil})
	aadd(_aLinha,{"C6_LOCDEST" , SZ4->Z4_LOCDEST			,Nil})
	SA3->(dbSetOrder(1))
	If SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND))
		aadd(_aLinha,{"C6_COMIS1"   , SA3->A3_COMIS		,Nil})
	Endif

	aadd(_aItens,_aLinha)

Return(.T.)
