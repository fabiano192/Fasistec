#include "Protheus.ch"
#include "TOPCONN.ch"
#INCLUDE "TBICONN.CH"

/*/
Funçao    	³ CR0030
Autor 		³ Fabiano da Silva
Data 		³ 20.05.13
Descricao 	³ Pedido de Compra - Caterpillar Brasil(000017)
/*/

User Function CR0030()

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

//	LOCAL oDlg := NIL

	PRIVATE cTitulo    	:= "Pedido de Compra"
	PRIVATE oPrn       	:= NIL
	PRIVATE _nData     	:= '30'
	Private _cAnexo
	Private _cCATFold	:= GetMV("CR_CATFOLD")
/*
	_nOpc := 0

	DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
	@ 004,010 TO 060,157 LABEL "" OF oDlg PIXEL

	@ 010,017 SAY "Esta rotina tem por objetivo importar os Pedidos" 			OF oDlg PIXEL Size 150,010
	@ 020,017 SAY "de Compra da Caterpillar - Brasil" 							OF oDlg PIXEL Size 150,010
	@ 050,017 SAY "Programa CR0030.PRW                           " 				OF oDlg PIXEL Size 150,010

	@ 065,017 SAY "Dias a Retroagir:" 											OF oDlg PIXEL Size 080,010
	@ 065,075 MsGet _nData														OF oDlg PIXEL Size 030,010

	@ 15,165 BUTTON "OK" 		 SIZE 036,012 ACTION (_nOpc := 1,oDlg:End()) 	OF oDlg PIXEL
	@ 40,165 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 				OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED
	If _nOpc = 1
		If Val(_nData) > 0
		*/
	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| CR030A(@_lFim) }
	Private _cTitulo01 := 'Processando'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

	CR030C()
			/*
		Else
			Alert("Quantidade de Dias à retroagir n ão preenchido!")
		Endif
	Endif
*/

Return(Nil)



Static Function CR030A(_lFim)

	Private _cSeg
	Private _cCliente
	Private _cLjCli
	Private	_cPedido
	Private _dDtEmis
	Private _dDtFim
	Private _cContato
	Private _cFrete
	Private	_cProdCli
	Private _cDescri
	Private _nPreco
	Private _nLote
	Private _cNCM
	Private _nIPI
	Private	_cUM
	Private _cMoeda
	Private	_cTexto	  := ""
	Private	_cObs	  := ""
	Private	_cRevisao := ""
	Private _cArq2

	aStru := {}
	AADD(aStru,{"INDICE"   , "C" , 01 , 0 })
	AADD(aStru,{"PRODCLI"  , "C" , 15 , 0 })
	AADD(aStru,{"CLIENTE"  , "C" , 06 , 0 })
	AADD(aStru,{"LOJA"     , "C" , 02 , 0 })
	AADD(aStru,{"PRODUTO"  , "C" , 15 , 0 })
	AADD(aStru,{"PEDCLI"   , "C" , 20 , 0 })
	AADD(aStru,{"PRECOAT"  , "N" , 12 , 5 })
	AADD(aStru,{"REVISAO"  , "C" , 15 , 0 })
	AADD(aStru,{"PCDTEMI"  , "D" , 08 , 0 })
	AADD(aStru,{"PRECOPO"  , "N" , 12 , 5 })
	AADD(aStru,{"CONTATO"  , "C" , 11 , 0 })
	AADD(aStru,{"FRETE"    , "C" , 03 , 0 })
	AADD(aStru,{"DESCRIC"  , "C" , 25 , 0 })
	AADD(aStru,{"LOTE_MIN" , "N" , 12 , 3 })
	AADD(aStru,{"NCM" 	   , "C" , 10 , 0 })
	AADD(aStru,{"IPI" 	   , "N" , 5  , 2 })
	AADD(aStru,{"UM" 	   , "C" , 2  , 0 })
	AADD(aStru,{"MOEDA"    , "C" , 3  , 0 })
	AADD(aStru,{"ARQUIVO"  , "C" , 100, 0 })

	cArqLOG := CriaTrab(aStru,.T.)
	cIndLOG := "INDICE+PRODUTO+PRODCLI"
	dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

	dbSelectArea("TRB")
	IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

	_cData2    := GravaData(dDataBase,.f.,8)
	_cHora2    := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
	//_dDt       := ctod('17/10/2012')
	_dDt       := dDataBase - Val(_nData)
//	_dDt       := dDataBase - 300

	ProcRegua(20)

	For Z:= _dDt TO dDataBase
//	For Z:= _dDt TO _dDt

		IncProc()
		_cDir := _cCATFold+"Brasil\Entrada\"+DTOS(_dDt)+"\Cronnos.????.000001.RND007*.TXT"

		_aArqTxt= ARRAY(ADIR(_cDir))
		ADIR(_cCATFold+"Brasil\Entrada\"+DTOS(_dDt)+"\Cronnos.????.000001.RND007*.TXT",_aArqTxt)

		For I:= 1 to Len(_aArqTxt)

			_lAchou    := .t.
			_lProx     := .F.
			_cArq2     := _cCATFold+"Brasil\Entrada\"+DTOS(_dDt)+"\BKP_"+Alltrim(_aArqTxt[I])
			_cArq3     := _cCATFold+"Brasil\Entrada\"+DTOS(_dDt)+"\"+Alltrim(_aArqTxt[i])

			_cArqNovo  := fCreate(Alltrim(_cArq2),0)
			_cArq      := FOpen(_cArq3,0)
			_cQtArq    := 1
			_cSeg      := ""
			_cTexto	   := ""
			_cObs	   := ""
			_cRevisao  := ""

			While .T.

				cLinha := fReadStr(_cArq,130)

				If Len(cLinha) == 0
					Exit
				Endif

				If Subs(cLinha,1,3) == "ITP"

					SA1->(dbSetOrder(3))
					If SA1->(dbSeek(xFilial("SA1")+Subst(cLinha,26,14)))
						_cCliente := SA1->A1_COD
						_cLjCli   := SA1->A1_LOJA
					Endif
					_cSeg := "ITP"
				ElseIf Subs(cLinha,1,3) == "PM1"

					If _cSeg == "PM5"
						CR030B()
						_cSeg 		:= _cContato 	:= _cFrete 	:= _cProdCli 	:= _cDescri := _cNCM := _cUM := _cMoeda := ""
						_dDtEmis 	:= _dDtFim 		:= CToD("  /  /  ")
						_nPreco		:= _nLote 		:= _nIPI 	:= 0
						_cTexto	  	:= ""
						_cObs	  	:= ""
						_cRevisao   := ""
					Endif

					_cPedido    := Subs(cLinha,20,9)
					_dDtEmis    := Ctod(Subst(cLinha,36,2)+"/"+Subst(cLinha,34,2)+"/20"+Subst(cLinha,32,2))
					_dDtFim     := Ctod(Subst(cLinha,48,2)+"/"+Subst(cLinha,46,2)+"/20"+Subst(cLinha,44,2))
					_cContato   := Subs(cLinha,50,11)
					_cFrete     := Subs(cLinha,89,3)
					
					If Left(_cPedido,4) $ "QAPC/QAPP/QXPP"
						_cLjCli := "01"
					ElseIf Left(_cPedido,4) $ "QEST/HETZ"
						_cLjCli := "02"
					ElseIf Left(_cPedido,4) $ "QHPD/QAPD/QYPD/QXPD"
						_cLjCli := "03"
					Endif

					_cSeg := "PM1"
				ElseIf Subs(cLinha,1,3) == "TE1"
					If _cSeg == "PM1"
						_cTexto += Subs(cLinha,4,100) + CRLF
					Else
						_cObs   += Subs(cLinha,4,100) + CRLF
					Endif
				ElseIf Subs(cLinha,1,3) == "PM2"

					_cProdCli  := Subs(cLinha,4,15)
					_cDescri   := Subs(cLinha,34,25)
					_nPreco    := Val(Subs(cLinha,59,7)+"."+Subs(cLinha,66,5))
					_cUM	   := Subs(cLinha,71,2)
					_nLote     := Val(Subs(cLinha,79,9)+"."+Subs(cLinha,88,3))

					_cSeg := "PM2"
				ElseIf Subs(cLinha,1,3) == "PM3"

					_cNCM		:= Subs(cLinha,64,10)
					_nIPI		:= Val(Subs(cLinha,74,2)+"."+Subs(cLinha,76,2))

					_cSeg := "PM3"
				ElseIf Subs(cLinha,1,3) == "PM5"

					_cMoeda		:= Subs(cLinha,6,3)
					_cRevisao   := Alltrim(Subs(cLinha,41,4))

					_cSeg := "PM5"
				ElseIf Subs(cLinha,1,3) == "FTP"
					CR030B()
					_cSeg 		:= _cContato 	:= _cFrete 	:= _cProdCli 	:= _cDescri := _cNCM := _cUM := _cMoeda := ""
					_dDtEmis 	:= _dDtFim 		:= CToD("  /  /  ")
					_nPreco		:= _nLote 		:= _nIPI 	:= 0
					_cTexto	  	:= ""
					_cObs	  	:= ""
					_cRevisao   := ""
				Endif

				FWrite(_cArqNovo,cLinha)
			EndDo

			fClose(_cArq2)

			If File(_cArq3)
				FClose(_cArq)
				FErase(_cArq2)
				FErase(_cArq3)
			Endif
		Next I

		_dDt++

	Next Z

Return



Static Function CR030B()

	SZ2->(dbSetOrder(8))
	If SZ2->(dbSeek(xFilial("SZ2")+_cCliente + _cLjCli + Left(_cProdCli+Space(15),15) + Left(_cPedido+Space(20),20) + "1"))

		If Alltrim(_cRevisao) == Alltrim(SZ2->Z2_REVISAO)

			_dDataRef := SZ2->Z2_DTREF01
			_nValor   := SZ2->Z2_PRECO01
			For i := 2 to 12
				_nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
				If _nValor = 0
					_nValor := &("SZ2->Z2_PRECO"+StrZero(i-1,2))
					i:= 12
				Endif
			Next i

			If _nValor = _nPreco
				SZ2->(RecLock("SZ2",.F.))
				SZ2->Z2_PCDTEMI := _dDtEmis
				SZ2->Z2_PCDTFIM := _dDtFim
				SZ2->Z2_PCCONTA := _cContato
				SZ2->Z2_PCFRETE := _cFrete
				SZ2->Z2_PCDESCR := _cDescri
				SZ2->Z2_PCPRECO := _nPreco
				SZ2->Z2_PCLOTEM := _nLote
				SZ2->Z2_PCNCM   := _cNCM
				SZ2->Z2_PCIPI   := _nIPI
				SZ2->Z2_PCUM    := _cUM
				SZ2->Z2_PCMOEDA := _cMoeda
				SZ2->Z2_PCARQUI := Right(_cArq2,95)
				SZ2->Z2_PCOBS01 := _cTexto
				SZ2->Z2_PCOBS02 := _cObs
				SZ2->(MsUnlock())

				TRB->(RecLock("TRB",.T.))
				TRB->INDICE  := "1"  //PO atualizado
				TRB->PRODCLI := _cProdCli
				TRB->CLIENTE := _cCliente
				TRB->LOJA    := _cLjCli
				TRB->PEDCLI  := _cPedido
				TRB->REVISAO := _cRevisao
				TRB->PRECOAT := _nValor
				TRB->PCDTEMI := _dDtEmis
				TRB->PRECOPO := _nPreco
				TRB->ARQUIVO := Right(_cArq2,95)
				TRB->(MsUnlock())
			Else

				SZ2->(RecLock("SZ2",.F.))
//				SZ2->Z2_ATIVO	:= "2"
				SZ2->Z2_PCDTEMI := _dDtEmis
				SZ2->Z2_PCDTFIM := _dDtFim
				SZ2->Z2_PCCONTA := _cContato
				SZ2->Z2_PCFRETE := _cFrete
				SZ2->Z2_PCDESCR := _cDescri
				SZ2->Z2_PCPRECO := _nPreco
				SZ2->Z2_PCLOTEM := _nLote
				SZ2->Z2_PCNCM   := _cNCM
				SZ2->Z2_PCIPI   := _nIPI
				SZ2->Z2_PCUM    := _cUM
				SZ2->Z2_PCMOEDA := _cMoeda
				SZ2->Z2_PCARQUI := Right(_cArq2,95)
				SZ2->Z2_PCOBS01 := _cTexto
				SZ2->Z2_PCOBS02 := _cObs
				If _nValor < _nPreco
					For I:=2 To 12
						_nValor1 :=  &("SZ2->Z2_PRECO"+StrZero(i,2))

						If _nValor1 = 0
							_nPrec1   := "SZ2->Z2_PRECO"+strZero(I,2)
							_dDtRe1   := "SZ2->Z2_DTREF"+strZero(I,2)
							_dDtBa1   := "SZ2->Z2_DTBAS"+strZero(I,2)
							&_nPrec1  := _nPreco
							&_dDtRe1  := dDataBase
							&_dDtBa1  := &("SZ2->Z2_DTBAS"+strZero(I-1,2))
							I:= 12
						Endif
					Next I

				Endif
				SZ2->(MsUnlock())

				TRB->(RecLock("TRB",.T.))
				TRB->INDICE  := "2" //PO Atualizado c/ preço divergente
				TRB->PRODCLI := _cProdCli
				TRB->CLIENTE := _cCliente
				TRB->LOJA    := _cLjCli
				TRB->PEDCLI  := _cPedido
				TRB->REVISAO := _cRevisao
				TRB->PRECOAT := _nValor
				TRB->PCDTEMI := _dDtEmis
				TRB->PRECOPO := _nPreco
				TRB->ARQUIVO := Right(_cArq2,95)
				TRB->(MsUnlock())
			Endif
		Else
			SZ2->(RecLock("SZ2",.T.))
			SZ2->Z2_FILIAL	:= xFilial('SZ2')
			SZ2->Z2_CLIENTE	:= _cCliente
			SZ2->Z2_LOJA	:= _cLjCli
//			SZ2->Z2_PRODUTO	:=
			SZ2->Z2_CODCLI	:= _cProdCli
			SZ2->Z2_UM		:= _cUM
			SZ2->Z2_DESCCLI	:= _cDescri
			SZ2->Z2_REVISAO	:= _cRevisao
			SZ2->Z2_PEDCLI	:= _cPedido
			SZ2->Z2_TES		:= If(Left(_cPedido,4) $ "QAPC/QAPP/QHPP",'523','507')
//			SZ2->Z2_TES		:= If(_cLjCli = '01','523','507')
			SZ2->Z2_LOTEMIN	:= _nLote
//			SZ2->Z2_DNP		:=
			SZ2->Z2_PRECO01	:= _nPreco
			SZ2->Z2_DTREF01	:= _dDtEmis
			SZ2->Z2_ATIVO	:= "2"
			SZ2->Z2_PCDTEMI := _dDtEmis
			SZ2->Z2_PCDTFIM := _dDtFim
			SZ2->Z2_PCCONTA := _cContato
			SZ2->Z2_PCDESCR := _cDescri
			SZ2->Z2_PCPRECO := _nPreco
			SZ2->Z2_PCLOTEM := _nLote
			SZ2->Z2_PCUM    := _cUM
			SZ2->Z2_PCMOEDA := _cMoeda
			SZ2->Z2_PCFRETE := _cFrete
			SZ2->Z2_PCNCM   := _cNCM
			SZ2->Z2_PCIPI   := _nIPI
			SZ2->Z2_PCARQUI := Right(_cArq2,95)
			SZ2->Z2_PCOBS01 := _cTexto
			SZ2->Z2_PCOBS02 := _cObs
			SZ2->(MsUnlock())

			TRB->(RecLock("TRB",.T.))
			TRB->INDICE  	:= "3" //PO Integrado e Bloqueado
			TRB->PRODCLI 	:= _cProdCli
			TRB->CLIENTE 	:= _cCliente
			TRB->LOJA    	:= _cLjCli
			TRB->PEDCLI  	:= _cPedido
			TRB->REVISAO    := _cRevisao
			TRB->PCDTEMI 	:= _dDtEmis
			TRB->PRECOPO 	:= _nPreco
			TRB->ARQUIVO 	:= Right(_cArq2,95)
			TRB->CONTATO 	:= _cContato
			TRB->FRETE 		:= _cFrete
			TRB->DESCRIC 	:= _cDescri
			TRB->LOTE_MIN 	:= _nLote
			TRB->NCM 		:= _cNCM
			TRB->IPI 		:= _nIPI
			TRB->UM 		:= _cUM
			TRB->MOEDA 		:= _cMoeda
			TRB->(MsUnlock())

		Endif

	Else

		SZ2->(RecLock("SZ2",.T.))
		SZ2->Z2_FILIAL	:= xFilial('SZ2')
		SZ2->Z2_CLIENTE	:= _cCliente
		SZ2->Z2_LOJA	:= _cLjCli
//			SZ2->Z2_PRODUTO	:=
		SZ2->Z2_CODCLI	:= _cProdCli
		SZ2->Z2_UM		:= _cUM
		SZ2->Z2_DESCCLI	:= _cDescri
		SZ2->Z2_REVISAO	:= _cRevisao
		SZ2->Z2_PEDCLI	:= _cPedido
		SZ2->Z2_TES		:= If(Left(_cPedido,4) $ "QAPC/QAPP/QHPP",'523','507')
//		SZ2->Z2_TES		:= If(_cLjCli = '01','523','507')
		SZ2->Z2_LOTEMIN	:= _nLote
//			SZ2->Z2_DNP		:=
		SZ2->Z2_PRECO01	:= _nPreco
		SZ2->Z2_DTREF01	:= _dDtEmis
		SZ2->Z2_ATIVO	:= "2"
		SZ2->Z2_PCDTEMI := _dDtEmis
		SZ2->Z2_PCDTFIM := _dDtFim
		SZ2->Z2_PCCONTA := _cContato
		SZ2->Z2_PCDESCR := _cDescri
		SZ2->Z2_PCPRECO := _nPreco
		SZ2->Z2_PCLOTEM := _nLote
		SZ2->Z2_PCUM    := _cUM
		SZ2->Z2_PCMOEDA := _cMoeda
		SZ2->Z2_PCFRETE := _cFrete
		SZ2->Z2_PCNCM   := _cNCM
		SZ2->Z2_PCIPI   := _nIPI
		SZ2->Z2_PCARQUI := Right(_cArq2,95)
		SZ2->Z2_PCOBS01 := _cTexto
		SZ2->Z2_PCOBS02 := _cObs
		SZ2->(MsUnlock())

		TRB->(RecLock("TRB",.T.))
		TRB->INDICE  	:= "3" //PO Integrado e Bloqueado
		TRB->PRODCLI 	:= _cProdCli
		TRB->CLIENTE 	:= _cCliente
		TRB->LOJA    	:= _cLjCli
		TRB->PEDCLI  	:= _cPedido
		TRB->REVISAO    := _cRevisao
		TRB->PCDTEMI 	:= _dDtEmis
		TRB->PRECOPO 	:= _nPreco
		TRB->ARQUIVO 	:= Right(_cArq2,95)
		TRB->CONTATO 	:= _cContato
		TRB->FRETE 		:= _cFrete
		TRB->DESCRIC 	:= _cDescri
		TRB->LOTE_MIN 	:= _nLote
		TRB->NCM 		:= _cNCM
		TRB->IPI 		:= _nIPI
		TRB->UM 		:= _cUM
		TRB->MOEDA 		:= _cMoeda
		TRB->(MsUnlock())
	Endif

Return


Static Function CR030C()

	Local oFwMsEx 		:= NIL
	Local cArq 			:= ""
//	Local cDir 			:= GetSrvProfString("Startpath","")
	Local cWorkSheet	:= ""
	Local cTable 		:= ""
//	Local cDirTmp 		:= GetTempPath()
	Local _lEnt 		:= .F.

	oFwMsEx := FWMsExcel():New()

	TRB->(dbGotop())

	While !TRB->(Eof())

		_cIndice := TRB->INDICE
	 	_lEnt    := .T.

		If _cIndice = "3"

			cWorkSheet 	:= 	"PO Integrado e Bloqueado"
			cTable 		:= 	"PO Integrado e Bloqueado"

			oFwMsEx:AddWorkSheet( cWorkSheet )
			oFwMsEx:AddTable( cWorkSheet, cTable )

			oFwMsEx:AddColumn( cWorkSheet, cTable , "Cliente"   		, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Loja"   			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Emissão"   		, 1,4,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto Cliente"	, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Descrição"   		, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Pedido Cliente"   	, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Revisão"  			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Preço PO"  		, 3,2,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Moeda"   			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "UM"   				, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Lote"   			, 3,2,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Frete"   			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "NCM"   			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "IPI"   			, 3,2,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Contato"			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Data Arquivo"   	, 1,1,.F.)

		Else
			If _cIndice = "2"
				cWorkSheet 	:= 	"PO Atualizado - Preço Divergente"
				cTable 		:= 	"PO Atualizado - Preço Divergente"
			Else
				cWorkSheet 	:= 	"PO Atualizado"
				cTable 		:= 	"PO Atualizado"
			Endif

			oFwMsEx:AddWorkSheet( cWorkSheet )
			oFwMsEx:AddTable( cWorkSheet, cTable )

			oFwMsEx:AddColumn( cWorkSheet, cTable , "Cliente"   		, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Loja"   			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Emissão"   		, 1,4,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto Cliente"	, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Pedido Cliente"   	, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Revisão"  			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Preço PO"  		, 3,2,.F.)
			If _cIndice = "2"
				oFwMsEx:AddColumn( cWorkSheet, cTable , "Preço Venda(Atual)"  	, 3,2,.F.)
				oFwMsEx:AddColumn( cWorkSheet, cTable , "Diferença"  	, 3,2,.F.)
			Endif
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Data Arquivo"   	, 1,1,.F.)

		Endif


		While !TRB->(Eof()) .And. _cIndice == TRB->INDICE

			If _cIndice = "3"

				oFwMsEx:AddRow( cWorkSheet, cTable,{;
					TRB->CLIENTE	,;
					TRB->LOJA    	,;
					TRB->PCDTEMI   	,;
					TRB->PRODCLI    ,;
					TRB->DESCRIC    ,;
					TRB->PEDCLI    	,;
					TRB->REVISAO   	,;
					TRB->PRECOPO	,;
					TRB->MOEDA   	,;
					TRB->UM   		,;
					TRB->LOTE_MIN  	,;
					TRB->FRETE		,;
					TRB->NCM	    ,;
					TRB->IPI	    ,;
					TRB->CONTATO   	,;
					Substr(TRB->ARQUIVO,16,10)	})
			Else

				If _cIndice = "1"

					oFwMsEx:AddRow( cWorkSheet, cTable,{;
						TRB->CLIENTE	,;
						TRB->LOJA    	,;
						TRB->PCDTEMI   	,;
						TRB->PRODCLI    ,;
						TRB->PEDCLI    	,;
						TRB->REVISAO   	,;
						TRB->PRECOPO	,;
						Substr(TRB->ARQUIVO,16,10)	})
				Else

					_nDif := TRB->PRECOPO - TRB->PRECOAT

					oFwMsEx:AddRow( cWorkSheet, cTable,{;
						TRB->CLIENTE	,;
						TRB->LOJA    	,;
						TRB->PCDTEMI   	,;
						TRB->PRODCLI    ,;
						TRB->PEDCLI    	,;
						TRB->REVISAO   	,;
						TRB->PRECOPO	,;
						TRB->PRECOAT	,;
						_nDif 			,;
						Substr(TRB->ARQUIVO,16,10)	})
				Endif
			Endif

			TRB->(dbSkip())
		EndDo
	EndDo

	TRB->(dbCloseArea())

	oFwMsEx:Activate()

//	cArq := CriaTrab( NIL, .F. ) + ".xls"

	_cDat1    := GravaData(dDataBase,.f.,8)
	_cHor1    := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

	cArq := 'PO_CBL'+_cDat1+'_'+_cHor1 + ".xls"
	_cAnexo := "\WORKFLOW\RELATORIOS\"+cArq

	oFwMsEx:GetXMLFile( _cAnexo )

	If _lEnt
		CR030D() 	//Envia e-mail
	Endif

/*
	If __CopyFile( cArq, cDirTmp + cArq )
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDirTmp + cArq )
		oExcelApp:SetVisible(.T.)
	Else
		MsgInfo( "Arquivo não copiado para temporário do usuário." )

		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDir + cArq )
		oExcelApp:SetVisible(.T.)
	Endif
*/
Return


Static Function CR030D()

	Private _lRet

	nOpcao := 0

	CONOUT("Enviando E-Mail de PO - CBL")

	CONOUT('{'+ _cAnexo+'}')

	oProcess := TWFProcess():New( "PO_CBL", "PO_CBL" )
	aCond    :={}
	_nTotal  := 0

	oProcess:NewTask( "PO_CBL", "\WORKFLOW\CR0030.HTM" )
	oProcess:bReturn  := ""
	oProcess:bTimeOut := ""

	oHTML := oProcess:oHTML

	oProcess:cSubject := "Relatório de PO - CBL - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

	oProcess:fDesc := "Relatório de PO - CBL"

	Private _cTo := _cCC := ""

	SZG->(dbsetOrder(1))
	SZG->(dbGotop())

	While SZG->(!EOF())

		If 'I1' $ SZG->ZG_ROTINA
			_cTo += If(Empty(_cTo),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
		ElseIf 'I2' $ SZG->ZG_ROTINA
			_cCC += If(Empty(_cCC),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
		Endif

		SZG->(dbSkip())
	Enddo

	oProcess:AttachFile(_cAnexo)

	oProcess:cTo := _cTo
	oProcess:cCC := _cCC

	oProcess:Start()

	oProcess:Finish()

//	FErase(_cAnexo)

Return
