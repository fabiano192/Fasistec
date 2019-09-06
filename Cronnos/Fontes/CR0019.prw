#INCLUDE "TOTVS.CH"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
Função    	³ CR0019
Data 		³ 03.08.12
Descrição 	³ Pedidos com Estrutura

Alterações:
1) Alterado os campos de Quantidade de Composto e Um Composto para serem utilizados para os produtos do tipo Vazados
Data: 21/05/18
/*/

User Function CR0019()

	_aAliOri := GetArea()

	Private _cDescPa := ""
	Private _cLocPad   := _cQtCav := ""
	Private _nSdoAca   := 0
	Private _nSdoCQ    := 0
	Private _nSdoPA    := 0
	Private _nMedida   := 0
	Private _cComposto := _cMolde := _cInserto := _cPF := _cComp := _cUMPF := _cUMComp := _cCodVaza := _cUMVaz := ""
	Private _nOpc      := 0
	Private _nQtPa     := _nQtPI1 :=_nQtPI2 := _nQtBK := _nQtC1 := _nQtC2 := _nQtK1 := _nQtK2 := _nCont := _nCont1 := _nCont2 := _nQTPF := _nQTComp := _nQtdVaza := 0

	@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Gerando Tabela de Vendas")
	@ 02,10 TO 080,220
	@ 10,18 SAY "Rotina criado para Gerar tabela de Vendas 		"     SIZE 160,7
	@ 18,18 SAY "com dados necessarios para controle PCP.  		"     SIZE 160,7
	@ 26,18 SAY "Conforme Relacionamento com a Estrutura.  		"     SIZE 160,7
	@ 34,18 SAY "Programa CR0019 - Arquivo PED_CRONNOS.XLS  	"     SIZE 160,7

	@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("CR0019")
	@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
	@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

	ACTIVATE DIALOG oDlg Centered

	If _nOpc == 1
		Proces()
	Endif

Return


Static Function Proces()

	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| Proc1(@_lFim) }
	Private _cTitulo01 := 'Processando'

	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

	ZC6->(dbCloseArea())

	_bAcao01   := {|_lFim| CR019A(@_lFim) }
	_cTitulo01 := 'Gerando Excel'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return



Static Function Proc1(_lFim)

	Pergunte("CR0019",.F.)

	///////////////////////////////////////////
	////// GRUPO DE PERGUNTAS /////////////////
	///// MV_PAR01 - Emissao De  ?         ////
	///// MV_PAR02 - Emissao Ate ?         ////
	///// MV_PAR03 - Grupo De              ////
	///// MV_PAR04 - Grupo Ate           . ////
	///// MV_PAR05 - Produto De ?          ////
	///// MV_PAR06 - produto Ate ?         ////
	///// MV_PAR07 - Cliente De ?          ////
	///// MV_PAR08 - Cliente Ate ?         ////
	///// MV_PAR09 - Loja    De ?          ////
	///// MV_PAR10 - Loja    Ate ?         ////
	///// MV_PAR11 - Data Entrega De  ?    ////
	///// MV_PAR12 - Data Entrega Ate ?    ////
	///// MV_PAR13 - Pedido de        ?    ////
	///// MV_PAR14 - Pedido Ate       ?    ////
	///// MV_PAR15 - Em Aberto , Todos     ////
	///// MV_PAR16 - Quais Pedidos    ?    ////
	///////////////////////////////////////////

	Private _nNiv := 0
	Private _lGravou := .F.
	Private _dDtPlan


	aStru := {}
	AADD(aStru,{"EMISSAO"     , "D" , 08, 0 })
	AADD(aStru,{"CLIENTE"     , "C" , 06, 0 })
	AADD(aStru,{"LOJA"        , "C" , 02, 0 })
	AADD(aStru,{"NOMECLI"     , "C" , 40, 0 })
	AADD(aStru,{"PRODCLI"     , "C" , 15, 0 })
	AADD(aStru,{"NOMPROD"     , "C" , 50, 0 })
	AADD(aStru,{"PRODUTO"     , "C" , 15, 0 })
	AADD(aStru,{"DTENTR"      , "D" , 08, 0 })
	AADD(aStru,{"DTPLAN"      , "D" , 08, 0 })
	AADD(aStru,{"PEDIDO"      , "C" , 06, 0 })
	AADD(aStru,{"ITEMPV"      , "C" , 02, 0 })
	AADD(aStru,{"PRUNIT"      , "N" , 12, 2 })
	AADD(aStru,{"TIPOPV"      , "C" , 20, 0 })
	AADD(aStru,{"QTDPED"      , "N" , 12, 2 })
	AADD(aStru,{"QTDENT"      , "N" , 12, 2 })
	AADD(aStru,{"QTDSDO"      , "N" , 12, 2 })
	AADD(aStru,{"EST_ACA"     , "N" , 14, 2 })
	AADD(aStru,{"EST_CQ"      , "N" , 14, 2 })
	AADD(aStru,{"EST_EXP"     , "N" , 14, 2 })
	AADD(aStru,{"MOLDE"       , "C" , 45, 0 })
	AADD(aStru,{"INSERTO"     , "C" , 45, 0 })
	AADD(aStru,{"CODVAZA"     , "C" , 45, 0 })
	AADD(aStru,{"QTDVAZA"     , "N" , 14, 6 })

	AADD(aStru,{"PF"          , "C" , 15, 0 })
	AADD(aStru,{"COMPOST"     , "C" , 15, 0 })
	AADD(aStru,{"QTCOMP"      , "N" , 14, 4 })
	AADD(aStru,{"UMCOMP"      , "C" , 02, 0 })
	AADD(aStru,{"RECURSO"     , "C" , 25, 0 })

	_cArqTrb := CriaTrab(aStru,.T.)
	_cIndTrb := "PRODUTO+PEDIDO"

	dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

	dbSelectArea("TRB")
	IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

	aStru := {}
	AADD(aStru,{"PRODUTO"     , "C" , 15, 0 })
	AADD(aStru,{"MOLDE"       , "C" , 45, 0 })
	AADD(aStru,{"INSERTO"     , "C" , 45, 0 })
	AADD(aStru,{"CODVAZA"     , "C" , 45, 0 })
	AADD(aStru,{"QTDVAZA"     , "N" , 14, 6 })
	AADD(aStru,{"UMVAZA"      , "C" , 02, 6 })

	_cArqTrb := CriaTrab(aStru,.T.)
	_cIndTrb := "PRODUTO"

	dbUseArea(.T.,,_cArqTrb,"TMP",.F.,.F.)

	dbSelectArea("TMP")
	IndRegua("TMP",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

	_cPed := "("
	For Ax:= 1 To Len(MV_PAR16)
		If Substr(MV_PAR16,AX,1) != "*"
			If _cPed == "("
				_cPed += "'"+Substr(MV_PAR16,AX,1)
			Else
				_cPed += "','"+Substr(MV_PAR16,AX,1)
			Endif
		Endif
	Next AX

	_cPed += "')"

	_cQ := " SELECT * FROM SC6010 C6 INNER JOIN SC5010 C5 ON C6_NUM=C5_NUM " +CRLF
	_cQ += " INNER JOIN SB1010 B1 ON C6_PRODUTO=B1_COD INNER JOIN SF4010 F4 ON C6_TES=F4_CODIGO  " +CRLF
	_cQ += " WHERE B1.D_E_L_E_T_ = '' AND C5.D_E_L_E_T_ = '' AND C6.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' " +CRLF
	_cQ += " AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " +CRLF
	_cQ += " AND B1_GRUPO   BETWEEN '"+MV_PAR03+"'       AND '"+MV_PAR04+"' " +CRLF
	_cQ += " AND B1_COD     BETWEEN '"+MV_PAR05+"'       AND '"+MV_PAR06+"' AND F4_DUPLIC = 'S' " +CRLF
	_cQ += " AND C6_CLI     BETWEEN '"+MV_PAR07+"'       AND '"+MV_PAR08+"' AND C6_BLQ = '' " +CRLF
	_cQ += " AND C6_LOJA    BETWEEN '"+MV_PAR09+"'       AND '"+MV_PAR10+"' AND C5_TIPO = 'N' " +CRLF
	_cQ += " AND C6_ENTREG  BETWEEN '"+DTOS(MV_PAR11)+"' AND '"+DTOS(MV_PAR12)+"' " +CRLF
	_cQ += " AND C6_NUM     BETWEEN '"+MV_PAR13+"'       AND '"+MV_PAR14+"' " +CRLF
	If MV_PAR15 == 1
		_cQ += " AND C6_QTDVEN > C6_QTDENT " +CRLF
	Endif
	_cQ += " AND C6_PEDAMOS IN "+_cPed+" " +CRLF
	_cQ += " ORDER BY C6_PRODUTO " +CRLF

	Memowrite("D:\CR0019.TXT",_cQ)

	TCQUERY _cQ NEW ALIAS "ZC6"

	TCSETFIELD("ZC6","C6_ENTREG","D")
	TCSETFIELD("ZC6","C5_EMISSAO","D")

	ZC6->(dbGotop())
	ProcRegua(ZC6->(U_CONTREG()))

	While ZC6->(!Eof()) .And. !_lFim

		If _lFim
			Alert("Cancelado Pelo Usuario!!!!")
			Return
		Endif

		IncProc()

		SA1->(dbSetOrder(1))
		SA1->(dbseek(xFilial("SA1")+ZC6->C6_CLI+ZC6->C6_LOJA))

		_dDtPlan	:= If(SA1->A1_YDTPLAN = 0,ZC6->C6_ENTREG,SubDiaUt(ZC6->C6_ENTREG,SA1->A1_YDTPLAN))

		If _dDtPlan < MV_PAR17 .Or. _dDtPlan > MV_PAR18
			ZC6->(dbSkip())
			Loop
		Endif

		SB1->(dbSeek(xFilial("SB1")+ZC6->C6_PRODUTO))

		_cComposto := _cMolde := _cInserto := _cC := _cCodVaza := ""
		_cPF	   := _cUMPF  := _cComp    := _cUMComp := _cUMVaz := ""
		_nQTPF	   := _nQTComp := _nQtdVaza := 0

		SG1->(dbSetOrder(1))
		If SG1->(dbSeek(xFilial("SG1")+ZC6->C6_PRODUTO))
			_cProd   := SG1->G1_COD
			nNivel   := 2
			_nQtAnt  := ZC6->C6_QTDVEN

			SB1->(dbSeek(xFilial("SB1")+_cProd))

			_cDescPa   := SB1->B1_DESC
			_cLocPad   := SB1->B1_LOCPAD
			_nMedida   := SB1->B1_AREAPEC
			_cQtCav    := SB1->B1_CAV

			If TMP->(!dbSeek(_cProd))

				_nSdoAca   := 0
				_nQtPa     := _nQtPI1 := _nQtPI2 := _nQtBK := _nQtC1 := _nQtC2 := _nQtK1 := _nQtK2 := _nCont := _nCont1 := _nCont2 := 0

				NECES(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
				TMP->(RecLock("TMP",.T.))
				TMP->PRODUTO  := _cProd
				TMP->MOLDE    := _cMolde
				TMP->INSERTO  := _cInserto
				TMP->CODVAZA  := _cCodVaza
				TMP->QTDVAZA  := _nQtdVaza
				TMP->UMVAZA   := _cUmVaz

				TMP->(MsUNlock())
			Else
				_cMolde		:= TMP->MOLDE
				_cInserto	:= TMP->INSERTO
				_cCodVaza	:= TMP->CODVAZA
				_nQtdVaza	:= TMP->QTDVAZA
				_cUmVaz     := TMP->UMVAZA
			Endif
		Endif

		_nSdoPa := 0
		SB2->(dbSetOrder(1))
		If SB2->(dbSeek(xFilial("SB2")+ZC6->C6_PRODUTO + "99"))
			_nSdoPa := SB2->B2_QATU
		Endif

		_nSdoCQ := 0
		SB2->(dbSetOrder(1))
		If SB2->(dbSeek(xFilial("SB2")+ZC6->C6_PRODUTO + "98"))
			_nSdoCQ := SB2->B2_QATU
		Endif

		If _nSdoAca > 0
			_lPare := .T.
		Endif

		TRB->(RecLock("TRB",.T.))
		TRB->EMISSAO  := ZC6->C5_EMISSAO
		TRB->CLIENTE  := ZC6->C6_CLI
		TRB->LOJA     := ZC6->C6_LOJA
		TRB->NOMECLI  := SA1->A1_NOME
		TRB->PRODUTO  := ZC6->C6_PRODUTO
		TRB->NOMPROD  := ZC6->B1_DESC
		TRB->PRODCLI  := ZC6->C6_CPROCLI
		TRB->DTENTR   := ZC6->C6_ENTREG
		TRB->DTPLAN	  := _dDtPlan
		TRB->MOLDE    := _cMolde
		TRB->INSERTO  := _cInserto
		TRB->PEDIDO   := ZC6->C6_NUM
		TRB->ITEMPV   := ZC6->C6_ITEM
		TRB->PRUNIT   := ZC6->C6_PRCVEN
		_cDesTipo := ""
		If ZC6->C6_PEDAMOS == "N"
			_cDesTipo := "NORMAL"
		ElseIf ZC6->C6_PEDAMOS == "A"
			_cDesTipo := "AMOSTRA"
		ElseIf ZC6->C6_PEDAMOS == "D"
			_cDesTipo := "DESPES.ACESS."
		ElseIf ZC6->C6_PEDAMOS == "M"
			_cDesTipo := "AQUIS.MAT."
		ElseIf ZC6->C6_PEDAMOS == "Z"
			_cDesTipo := "PREVISAO"
		ElseIf ZC6->C6_PEDAMOS == "I"
			_cDesTipo := "INDUSTRIALIZ."
		Endif
		TRB->TIPOPV   := _cDesTipo
		TRB->QTDPED   := ZC6->C6_QTDVEN
		TRB->QTDENT   := ZC6->C6_QTDENT
		TRB->QTDSDO   := ZC6->C6_QTDVEN - ZC6->C6_QTDENT
		TRB->EST_ACA  := _nSdoAca
		TRB->EST_CQ   := _nSdoCQ
		TRB->EST_EXP  := _nSdoPa
		TRB->PF	  	  := _cPF
		TRB->COMPOST  := _cComp
		TRB->QTCOMP	  := _nQTComp
		//		TRB->UMCOMP	  := _cUMComp
		TRB->UMCOMP	  := _cUMVaz
		TRB->RECURSO  := Alltrim(Posicione("SX5",1,xFilial("SX5")+'ZA'+ZC6->B1_9RECURS,"X5_DESCRI"))

		TRB->CODVAZA  := _cCodVaza
		TRB->QTDVAZA  := _nQtdVaza
		TRB->(MsUNlock())

		ZC6->(dbSkip())
	EndDo

Return


Static Function NECES(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev)

	Local _nReg := 0
	Local _nRegTrb := 0

	SG1->(dbSetOrder(1))

	While SG1->(!Eof()) .And. SG1->G1_COD == _cProd  .And. !_lFim

		_nReg := SG1->(Recno())

		nQuantItem := ExplEstr(_nQtPai,,_cOpc,_cRev)
		dbSelectArea("SG1")
		dbSetOrder(1)

		aAreaSB1:=SB1->(GetArea())
		SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))

		_nRegTRb := SB1->(Recno())

		If SB1->B1_GRUPO $ "PIC /MPC "   // Material Utilizado

			If SB1->B1_COD != 'B45'
				_cComposto += ALLTRIM(SG1->G1_COMP)+ " "
			Endif
		ElseIf SB1->B1_GRUPO $ "FRVC/FRVI/FRVT"   // Molde de Vulcanização / Ferramenta
			_cMolde    += ALLTRIM(SG1->G1_COMP)+ " "
		ElseIf SB1->B1_GRUPO $  "MPIM/PIPM/MPOU/MPCP"   // PRE FORMADO / INSERTO  METALICO / MP COMPRADO PRONTO
			_cInserto  += ALLTRIM(SG1->G1_COMP)+ " "
		ElseIf SB1->B1_GRUPO $  "PPPF"   // PRE FORMADO
			_nCont1 ++
			If _nCont1 = 1
				//				_nQtPI1 := SG1->G1_QUANT
				_cPF    := SG1->G1_COMP
				//				_nQTPF  := SG1->G1_QUANT
				//				_cUMPF  := SB1->B1_UM
			ElseIf _nCont1 = 2
				//				_nQtPI2 := SG1->G1_QUANT
			Endif
		ElseIf SB1->B1_GRUPO $  "PPCO"   //Composto
			_cComp   := SG1->G1_COMP
			_nQTComp := SG1->G1_QUANT
			_cUMComp := SB1->B1_UM
		ElseIf SB1->B1_GRUPO $  "PPBK"   // Blank Vazados
			//			_nQtBK := SG1->G1_QUANT
		ElseIf SB1->B1_GRUPO $  "MPVZ|PPVZ"   // Mat. Prima Vazados
			_cCodVaza := ALLTRIM(SG1->G1_COMP)
			_nQtdVaza := SG1->G1_QUANT
			_cUMVaz   := SB1->B1_UM
		Endif

		If SB1->B1_LOCPAD == "20"
			SB2->(dbSetOrder(1))
			If SB2->(dbSeek(xFilial("SB2")+SG1->G1_COMP + SB1->B1_LOCPAD))
				_nSdoAca := SB2->B2_QATU
			Endif
		Endif

		RestArea(aAreaSB1)

		SG1->(dbSetOrder(1))
		If SG1->(dbSeek(xFilial("SG1")+SG1->G1_COMP))
			SB1->(dbSeek(xFilial("SB1")+SG1->G1_COD))
			NECES(SG1->G1_COD,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
		EndIf

		SG1->(dbGoto(_nReg))

		SG1->(dbSkip())
	EndDo

Return



Static Function CR019A()

	Local oFwMsEx 		:= NIL
	Local cArq 			:= ""
	Local cDir 			:= GetSrvProfString("Startpath","")
	Local cWorkSheet	:= ""
	Local cTable 		:= ""
	Local _cDir			:= "C:\TOTVS\"

	oFwMsEx := FWMsExcel():New()

	cWorkSheet 	:= 	"Carteira"
	cTable 		:= 	"Carteira"

	oFwMsEx:AddWorkSheet( cWorkSheet )
	oFwMsEx:AddTable( cWorkSheet, cTable )

	oFwMsEx:AddColumn( cWorkSheet, cTable , "EMISSAO"  	, 1,4,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "CLIENTE"  	, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "LOJA"   	, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "NOMECLI"	, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "PRODCLI"	, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "NOMPROD"  	, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "PRODUTO"	, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "DTENTR" 	, 1,4,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "DTPLAN" 	, 1,4,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "PEDIDO" 	, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "ITEMPV" 	, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "PRUNIT" 	, 3,2,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "TIPOPV"   	, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "QTDPED"   	, 3,2,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "QTDENT"   	, 3,2,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "QTDSDO"	, 3,2,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "EST_ACA"   , 3,2,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "EST_CQ"   	, 3,2,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "EST_EXP"   , 3,2,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "MOLDE"   	, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "INSERTO"   		, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Cod. MP Vazados"   , 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "QTDE MP Vazados" 	, 3,2,.F.)

	//	oFwMsEx:AddColumn( cWorkSheet, cTable , "PESO_PF1"  , 3,2,.F.)
	//	oFwMsEx:AddColumn( cWorkSheet, cTable , "PESO_PF2"  , 3,2,.F.)
	//	oFwMsEx:AddColumn( cWorkSheet, cTable , "AREA_VZ1"  , 3,2,.F.)
	//	oFwMsEx:AddColumn( cWorkSheet, cTable , "AREA_VZ2"  , 3,2,.F.)

	oFwMsEx:AddColumn( cWorkSheet, cTable , "Cod Pre-Formado (Não Usado)"  		, 1,1,.F.)
	//	oFwMsEx:AddColumn( cWorkSheet, cTable , "QTDE Pre-Formado"  , 3,2,.F.)
	//	oFwMsEx:AddColumn( cWorkSheet, cTable , "UM Pré-Formado"  	, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Composto (Não Usado)" 		, 1,1,.F.)
	//	oFwMsEx:AddColumn( cWorkSheet, cTable , "QTDE Composto"  	, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "QTDE MP Vazados"  	, 1,1,.F.)
	//	oFwMsEx:AddColumn( cWorkSheet, cTable , "UM Composto"  		, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "UM Vazados"  		, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Recurso"  			, 1,1,.F.)

	TRB->(dbGotop())

	While !TRB->(Eof())

		oFwMsEx:AddRow( cWorkSheet, cTable,{;
		TRB->EMISSAO	,;
		TRB->CLIENTE   	,;
		TRB->LOJA   	,;
		TRB->NOMECLI    ,;
		TRB->PRODCLI    ,;
		TRB->NOMPROD   	,;
		TRB->PRODUTO   	,;
		TRB->DTENTR 	,;
		TRB->DTPLAN 	,;
		TRB->PEDIDO  	,;
		TRB->ITEMPV		,;
		TRB->PRUNIT    	,;
		TRB->TIPOPV		,;
		TRB->QTDPED  	,;
		TRB->QTDENT  	,;
		TRB->QTDSDO  	,;
		TRB->EST_ACA  	,;
		TRB->EST_CQ   	,;
		TRB->EST_EXP  	,;
		TRB->MOLDE    	,;
		TRB->INSERTO  	,;
		TRB->CODVAZA  	,;
		TRB->QTDVAZA	,;
		TRB->PF	  	  	,;
		TRB->COMPOST  	,;
		TRB->QTDSDO * TRB->QTDVAZA ,;//TRB->QTCOMP  	,;
		TRB->UMCOMP	  	,;
		TRB->RECURSO  	})

		//		TRB->PESO_PF1 	,;
		//		TRB->PESO_PF2 	,;
		//		TRB->AREA_VZ1 	,;
		//		TRB->AREA_VZ2	,;
		//		TRB->QTPF	  	,;
		//		TRB->UMPF	  	,;
		TRB->(dbSkip())
	EndDo

	TRB->(dbCloseArea())

	cWorkSheet2 	:= 	"Dados"
	cTable2 		:= 	"Dados"

	oFwMsEx:AddWorkSheet( cWorkSheet2 )
	oFwMsEx:AddTable( cWorkSheet2, cTable2 )

	oFwMsEx:AddColumn( cWorkSheet2, cTable2 , "Produto"  	, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet2, cTable2 , "Recurso"  	, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet2, cTable2 , "PPH"  		, 3,2,.F.)

	_cQuery := " SELECT * FROM "+RetSQLName("SB1")+" B1 " +CRLF
	_cQuery += " WHERE B1.D_E_L_E_T_ = '' AND B1_TIPO = 'PA' AND B1_9RECURS <> '' " +CRLF
	_cQuery += " AND B1_MSBLQL <> '1' " +CRLF

	Memowrite("D:\CR0019A.TXT",_cQuery)

	TCQUERY _cQuery NEW ALIAS "TSB1"

	TSB1->(dbGoTop())

	While !TSB1->(EOF())

		_cRecu := Alltrim(Posicione("SX5",1,xFilial("SX5")+'ZA'+TSB1->B1_9RECURS,"X5_DESCRI"))

		oFwMsEx:AddRow( cWorkSheet2, cTable2,{;
		TSB1->B1_COD		,;
		_cRecu				,;
		TSB1->B1_9PPH  		})

		TSB1->(dbSkip())
	EndDo

	TSB1->(dbCloseArea())

	oFwMsEx:Activate()

	cArq := CriaTrab( NIL, .F. ) + ".xls"

	LjMsgRun( "Gerando o arquivo, aguarde...", "Pedido de Compras", {|| oFwMsEx:GetXMLFile( cArq ) } )

	If !ExistDir( _cDir )
		If MakeDir( _cDir ) <> 0
			MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
			Return
		EndIf
	EndIf

	_cData   := DTOS(dDataBase)
	_cHora   := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

	_cNomArq := "PED_CRONNOS_"+_cData+"_"+_cHora+".XLS"

	If __CopyFile(cArq, _cDir + _cNomArq)

		If ! ApOleClient( 'MsExcel' )
			MsgStop('MsExcel nao instalado')
			Return
		EndIf

		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( _cDir + _cNomArq )
		oExcelApp:SetVisible(.T.)

	Else
		MSGAlert("O arquivo não foi copiado!", "AQUIVO NÃO COPIADO!")
	Endif

Return


Static Function SubDiaUt(_dData,_nDias)

	For _nCont:=1 to _nDias
		_dData := DataValida(_dData-1,.F.)
	Next _nCont

Return _dData