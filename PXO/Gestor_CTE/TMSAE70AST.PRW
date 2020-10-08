#INCLUDE "Tmsae70.ch"
#INCLUDE "Protheus.ch"
#Include "FWMVCDEF.ch" 

#DEFINE CTMARCA  1
#DEFINE CTCORBRW 2
#DEFINE CTDATEMI 3
#DEFINE CTHOREMI 4
#DEFINE CTLOTNFC 5
#DEFINE CTFILDOC 6
#DEFINE CTDOC    7
#DEFINE CTSERIE  8
#DEFINE CTTIPDOC 9
#DEFINE CTRETCTE 10
#DEFINE CTSITCTE 11
#DEFINE CTNOMREM 12
#DEFINE CTFIMP   13
#DEFINE CTFIMPDS 14
#DEFINE CTDT6REC 15
#DEFINE CTTIPO   16
#DEFINE NROCPOS  16 //-- Numero de campos no monitor CTE (padrao)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TMSAE70   ³ Autor ³Andre Godoi            ³ Data ³23.03.2010|±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de monitoramento do Ct-e, painel contendo os doc. de ³±±
±±³          ³acordo com os parametros selecionados.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Param[1] - Numero, origem da funcao                         ³±±
±±³          ³            1 - Tmsa200                                     ³±±
±±³          ³            2 - Tmsa500                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TMSAE70AST(nOrigem,cFilOri,cLotNfc,cFilDoc,cDoc,cSerie,nSttDoc,lMonitor)

Local cIdEnt    := ""
Local cLine     := ""
Local aPerg     := {}
Local aSize     := {}
Local aObjects  := {}
Local aListBox  := {}
Local aInfo     := {}
Local aPosObj   := {}
Local aRetPE    := {}
Local nDif      := 0
Local nDif2     := 0
Local nI        := 0
Local lBtnUser  := ExistBlock("TME70BUT") //Ponto de Entrada para criação de botões adicionais no Painel do Ct-e
Local lInutili  := SuperGetMv("MV_INUTILI", .F., .F.)
Local cTitRem   := RetTitle("DT6_NOMREM")
Local oVerde    := LoadBitmap( GetResources(),'BR_VERDE'	)
Local oAmarelo  := LoadBitmap( GetResources(),'BR_AMARELO'	)
Local oVermelho := LoadBitmap( GetResources(),'BR_VERMELHO'	)
Local oAzul     := LoadBitmap( GetResources(),'BR_AZUL'		)
Local oPreto    := LoadBitmap( GetResources(),'BR_PRETO'	)
Local oOk       := LoadBitMap(GetResources(),"LBOK")
Local oNo       := LoadBitMap(GetResources(),"LBNO")
Local cPerg     := ""
Local oSay 
Local oWS
Local oBtn01 
Local oBtn02
Local oBtn03
Local oBtn04
Local oBtn05
Local oBtn06
Local oBtn07
Local oBtn08
Local oBtn09
Local oBtn10
Local oBtn11
Local oBtn12
Local oBtn13
Local aoBtnUser := {}
Local aoUsrMenu := {}
Local aUMItens  := {}
Local nUItem    := 1
Local nBtnUsr   := 1
Local oDlg     	:= Nil
Local lCTECan	:= SuperGetMv( "MV_CTECAN", .F., .F. ) //-- Cancelamento CTE - .F.-Padrao .T.-Apos autorizacao
Local lRtCTeId	:= SuperGetMv( "MV_RTCTEID", .F., .F. ) //-- Habilita o botão Retorno de Status

Private oListBox  := Nil
Private oQtdDoc   := Nil
Private oQtdMrk   := Nil
Private nQtdDoc   := 0
Private nQtdMrk   := 0
Private lExecAuto := .F.
Private lUsaColab := .F.

//-- Checkbox
Private lAllMark := .F.	// Usado para o controle da marca de todos os documentos
Private aDocMark := {}	//-- Doctos Marcados
Default cFilOri  := ''
Default cLotNfc  := ''
Default cFilDoc  := ''
Default cDoc     := ''
Default cSerie   := ''
Default nSttDoc  := 1 //-- Não Autorizado
Default lMonitor := .F.
Default nOrigem  := 1
If Type('aPanAgeTms') <> "U" .And. IsInCallStack("TMSAF76") .And. !Empty(aPanAgeTms)
	If FunName() == 'TMSA500'
		nOrigem := 2
	Else
		nOrigem := 1	
	EndIF	
	cLotNfc := ""          
	nSttDoc := ""
EndIf
cPerg := If(nOrigem==1, 'TM200C','TM500C')

lExecAuto := !Empty(cLotNfc)

//-- Verifica se está com transação aberta
 If InTransact()
	bErrorBkp := ErrorBlock({|e| TMSAE70ERR(e)})
	Begin Sequence
		UserException(	" * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *" +CRLF+;
						" * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *" +CRLF+;
						" * * ATENÇÃO!!! HÁ UMA TRANSAÇÃO EM ABERTO !!!!  * * * * * *" +CRLF+;
						" * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *" +CRLF+;
						" * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *" +CRLF)
	End Sequence
	ErrorBlock(bErrorBkp)
	MsgStop("STR0069")
	Return Nil
 EndIf

//-- Verifica se a rotina foi chamado pelo TMSA200
If nOrigem == 1
	If lExecAuto
		Pergunte(cPerg,.F.)
		DTP->(dbSetOrder(2))
		DTP->(dbSeek(xFilial('DTP')+cFilOri+cLotNfc))
		DT6->(dbSetOrder(2))
		DT6->(dbSeek(xFilial('DT6')+cFilOri+cLotNfc))
		lPergunte := .T.
		mv_par01  := cLotNfc
		mv_par02  := cLotNfc
		mv_par03  := nSttDoc
		mv_par04  := ' ' 
		mv_par05  := DT6->DT6_DATEMI
		mv_par06  := DT6->DT6_DATEMI
	Else
		lPergunte := Pergunte(cPerg,.T.)
	EndIf
	If lPergunte
		//-- Array dinamico, com informacoes passadas pelo pergunte do TM200C(nOrigem, Lote De, Lote Ate, Status, Tipo Doc., Data de, Data Ate)
		Aadd(aPerg,{nOrigem, Mv_Par01, Mv_Par02, Mv_Par03, Mv_Par04, Dtos(Mv_Par05), Dtos(Mv_Par06)})
	Else
		Return( Nil )
	EndIf
//-- Verifica se a rotina foi chamado pelo TMSA500
ElseIf nOrigem == 2
	If lExecAuto
		Pergunte(cPerg,.F.)
		DT6->(dbSetOrder(2))
		DT6->(dbSeek(xFilial('DT6')+cFilOri+cLotNfc+cFilDoc+cDoc+cSerie))
		lPergunte := .T.
		mv_par01  := cDoc
		mv_par02  := cDoc
		mv_par03  := cSerie
		mv_par04  := cSerie
		mv_par05  := DT6->DT6_DATEMI
		mv_par06  := DT6->DT6_DATEMI
		mv_par07  := 1 //-- Não Autorizado
		mv_par08  := ' '
	Else
		lPergunte := Pergunte(cPerg,.T.)
	EndIf
	If lPergunte
	//-- Array dinamico, com informacoes passadas pelo pergunte do 
	//-- TM500C(nOrigem, Doc De, Doc Ate, Serie de, Serie Ate, Dt Emissao De, Dt Emissao Ate, Status, Tipo Doc.)
		Aadd(aPerg,{nOrigem, Mv_Par01, Mv_Par02, Mv_Par03, Mv_Par04, Dtos(Mv_Par05), Dtos(Mv_Par06), Mv_Par07, Mv_Par08})
	Else
		Return( Nil )
	EndIf
EndIf

lUsaColab := UsaColaboracao("2")
If lUsaColab
	//-- TOTVS Colaboracao 2.0
	lUsaColab := ColCheckUpd()
	If !lUsaColab
		MsgInfo("UPDATE do TOTVS Colaboração 2.0 não aplicado. Desativado o uso do TOTVS Colaboração 2.0")
	EndIf
EndIf
//-- Carrega o @aListBox com os registros da tela do monitor.
If lExecAuto .And. !lMonitor
	TMS70LIST(@aListBox, aPerg)
	TMS70ENV(aListBox, aPerg, .F.)	
Else
	CursorWait()
	TMS70LIST(@aListBox, aPerg)
	CursorArrow()

	//--- Monta dinamicamente o CodeBlock do bLine
	cLine := " { Iif( aListBox[oListBox:nAT," + AllTrim(Str(CTMARCA )) + "] == '1',oOk,oNo)"
	cLine += ", aListBox[oListBox:nAT," + AllTrim(Str(CTCORBRW)) + "]"
	cLine += ", aListBox[oListBox:nAT," + AllTrim(Str(CTFIMPDS)) + "]"
	cLine += ", aListBox[oListBox:nAT," + AllTrim(Str(CTTIPO  )) + "]"
	cLine += ", aListBox[oListBox:nAT," + AllTrim(Str(CTDATEMI)) + "]"
	cLine += ", aListBox[oListBox:nAT," + AllTrim(Str(CTHOREMI)) + "]"
	cLine += ", aListBox[oListBox:nAT," + AllTrim(Str(CTLOTNFC)) + "]"
	cLine += ", aListBox[oListBox:nAT," + AllTrim(Str(CTFILDOC)) + "]"
	cLine += ", aListBox[oListBox:nAT," + AllTrim(Str(CTDOC   )) + "]"
	cLine += ", aListBox[oListBox:nAT," + AllTrim(Str(CTSERIE )) + "]"
	cLine += ", aListBox[oListBox:nAT," + AllTrim(Str(CTTIPDOC)) + "]"
	cLine += ", aListBox[oListBox:nAT," + AllTrim(Str(CTRETCTE)) + "]"
	cLine += ", aListBox[oListBox:nAT," + AllTrim(Str(CTNOMREM)) + "]"
	aHeaders := {"","","DACTE","Tipo",STR0029,STR0030,STR0031,STR0032,STR0033,STR0034,STR0035,STR0016,cTitRem} //--Dt Emissao//--Hora Emissao//--Lote//--Filial Doc//--Documento
	//-- Ponto de entrada para incluir itens no cabecalho do monitor do CTE.
	If ExistBlock("TME70CAB")
		aRetPE := ExecBlock("TME70CAB",.F.,.F.)
		If	ValType(aRetPE) == "A"
			For nI:= 1 To Len(aRetPE)
				aAdd(aHeaders, aRetPE[nI])
				cLine += ", aListBox[oListBox:nAT," + AllTrim(Str(NROCPOS+nI)) + "]"
			Next nI
		EndIf
	EndIf
	cLine += " } "
	bLine := &( "{ || " + cLine + " }" )

	aSize    := MsAdvSize(.F. )
	aObjects := {}
	AAdd( aObjects, { 100, 020, .T., .F., .T.  } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 100, 020, .F., .F. } )
	If lBtnUser
		AAdd( aObjects, { 100, 020, .F., .F. } )
	EndIf

	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3, .T. }
	aPosObj := MsObjSize( aInfo, aObjects, .T. )

	DEFINE MSDIALOG oDlg TITLE STR0001 From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL	//-- "Monitor - (CT-e) Conhecimento de Transporte Eletrônico"

		oPanel := TPanel():New(aPosObj[1,1],aPosObj[1,2],"",oDlg,,,,,CLR_WHITE,(aPosObj[1,3]), (aPosObj[1,4]), .T.,.T.)

		@ 005,005 CHECKBOX oAllMark VAR lAllMark PROMPT STR0041 SIZE 168, 08 ON CLICK(TMS70All(aListBox)) OF oPanel PIXEL //-- Marca/Desmarca Todos
		@ 007,090 SAY "Qtde. Total de Documentos: " OF oPanel PIXEL
		If !Empty(aListBox[1,CTDOC])
			nQtdDoc := Len(aListBox)
		EndIf
		@ 005,157 MSGET oQtdDoc VAR nQtdDoc OF oPanel PIXEL PICTURE '@E 999,999,999'
		@ 007,230 SAY "Qtde. de Documentos Marcados: "  OF oPanel PIXEL
		@ 005,311 MSGET oQtdMrk VAR nQtdMrk OF oPanel PIXEL PICTURE '@E 999,999,999'

		//-- Cabecalho dos campos do Monitor.
		@ aPosObj[2,1],aPosObj[2,2] LISTBOX oListBox Fields SIZE aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1] PIXEL //--Serie//--Tipo Doc.//--Retorno Sefaz
		oListBox:aHeaders := aHeaders
		oListBox:SetArray( aListBox )
		oListBox:bLDblClick := { || TMS70Mrk(aListBox) }
		oListBox:bLine := bLine

		//-- Botoes da tela do monitor.
		@ aPosObj[3,1],aPosObj[3,4] - 100 BUTTON oBtn01 PROMPT STR0009	ACTION TMSE70LEG()									OF oDlg PIXEL SIZE 035,011	//-- "Legenda"
		@ aPosObj[3,1],aPosObj[3,4] - 060 BUTTON oBtn02 PROMPT STR0010	ACTION TMSE70Mon(aListBox,aPerg)	  				OF oDlg PIXEL SIZE 035,011	//-- "Monitor"
		If FindFunction("TmsVerCTe")
			@ aPosObj[3,1],aPosObj[3,4] - 020 BUTTON oBtn03 PROMPT STR0011	ACTION TmsVerCTe()									OF oDlg PIXEL SIZE 035,011	//-- "Dacte"
		Else
			@ aPosObj[3,1],aPosObj[3,4] - 020 BUTTON oBtn03 PROMPT STR0011	ACTION If(ExistBlock("RTMSR27",,.T.),ExecBlock("RTMSR27",.F.,.F.),)	OF oDlg PIXEL SIZE 035,011	//-- "Dacte"
		EndIf		
		@ aPosObj[3,1],aPosObj[3,4] + 020 BUTTON oBtn04 PROMPT STR0012 ACTION TMSR625()										OF oDlg PIXEL SIZE 035,011	//-- "Log Rejeição"
		@ aPosObj[3,1],aPosObj[3,4] + 060 BUTTON oBtn05 PROMPT STR0013 ACTION TMS70ENV(aListBox, aPerg,,lUsaColab)		OF oDlg PIXEL SIZE 035,011	//-- "Transmitir"
		@ aPosObj[3,1],aPosObj[3,4] + 100 BUTTON oBtn06 PROMPT STR0014 ACTION TMS70STA(aListBox, aPerg)				OF oDlg PIXEL SIZE 035,011	//-- "Status"
		@ aPosObj[3,1],aPosObj[3,4] + 140 BUTTON oBtn07 PROMPT STR0048 ACTION TMS70Rfs(@aListBox,aPerg)				OF oDlg PIXEL SIZE 035,011	//-- "Refresh"
		@ aPosObj[3,1],aPosObj[3,4] + 180 BUTTON oBtn08 PROMPT STR0042 ACTION TMS70Psq(aListBox)						OF oDlg PIXEL SIZE 035,011	//-- "Pesquisar"
		@ aPosObj[3,1],aPosObj[3,4] + 220 BUTTON oBtn09 PROMPT STR0043 ACTION TMS70Vis(aListBox)						OF oDlg PIXEL SIZE 035,011	//-- "Visualizar" 

	    oMenu := TMenu():New(0,0,0,0,.T.)    
		oTMenuIte1 := TMenuItem():New(oDlg,"CTE",,,,{||SpedNFePar()},,,,,,,,,.T.)
		oTMenuIte2 := TMenuItem():New(oDlg,"Eventos",,,,{||SpedEpecPar()} ,,,,,,,,,.T.)
		oMenu:Add(oTMenuIte1)
		oMenu:Add(oTMenuIte2)
		// Cria botão que sera usado no Menu
		oBtn10 := TButton():New( @ aPosObj[3,1],aPosObj[3,4] + 260, STR0050,oDlg, , 036,11,,,.F.,.T.,.F.,,.F.,,,.F. )
		// Define botão no Menu
		oBtn10:SetPopupMenu(oMenu)

		@ aPosObj[3,1],aPosObj[3,4] + 300 BUTTON oBtn11 PROMPT STR0051 ACTION SpedExport(1)								OF oDlg PIXEL SIZE 035,011	//-- "Exportar"

		If lInutili
			@ aPosObj[3,1],aPosObj[3,4] + 340 BUTTON oBtn12 PROMPT STR0052 ACTION SpedNFeInut()		OF oDlg PIXEL SIZE 035,011	//-- "Inutilização"
			nDif += 40
		EndIf
		
		If lRtCTeId .And. lCTECan
			@ aPosObj[3,1],aPosObj[3,4] + 380 BUTTON oBtn14 PROMPT "Ret. Status" ACTION retStaSef(aListBox,aPerg)		OF oDlg PIXEL SIZE 035,011	//-- "Retorna Status de Autorizado"
		EndIf
		
		//+----------------------------------------------------------------------------------------------
		//| Botao de Usuario Customizado
		//+----------------------------------------------------------------------------------------------
		If lBtnUser
			@ aPosObj[4,1],aPosObj[4,4] - 100 BUTTON oBtn13 PROMPT STR0015 ACTION oDlg:End()			OF oDlg PIXEL SIZE 035,011	//-- "Sair"
			nDif2 += 40
			
			aBtnUser := ExecBlock("TME70BUT",.F.,.F.)
			If	ValType(aBtnUser) == "A" .And. Len(aBtnUser) > 0

				For nBtnUsr:=1 To Len(aBtnUser)
					AADD(aoBtnUser,NIL)
					//+-----------------------------------------------------------
					//| Se botão com apenas 1 ação, insere apenas botão.
					//+-----------------------------------------------------------
					If ValType(aBtnUser[nBtnUsr][2]) == "B"
						aoBtnUser[nBtnUsr] := TButton():New(aPosObj[4,1],aPosObj[4,4]-100 + nDif2,aBtnUser[nBtnUsr][1],oDlg,,055,11,,,.F.,.T.,.F.,,.F.,,,.F.)
						aoBtnUser[nBtnUsr]:bAction := aBtnUser[nBtnUsr][2]
						nDif2 += 58

					//+-----------------------------------------------------------
					//| Se botão com mais de 1 ação, adiciona Objeto TMenu
					//+-----------------------------------------------------------
					ElseIf Len(aBtnUser[nBtnUsr][2]) > 1
						aoBtnUser[nBtnUsr] := TButton():New(aPosObj[4,1],aPosObj[4,4]-100+nDif2,aBtnUser[nBtnUsr][1],oDlg,,055,11,,,.F.,.T.,.F.,,.F.,,,.F.)
						nDif2 += 58
						AADD(aoUsrMenu, TMENU():NEW(0,0,0,0,.T.) )
						For nUItem := 1 To Len(aBtnUser[nBtnUsr][2])
							AADD(aUMItens, TMenuItem():New(oDlg,aBtnUser[nBtnUsr][2][nUItem][1],,,,aBtnUser[nBtnUsr][2][nUItem][2],,,,,,,,,.T.) )
							aoUsrMenu[Len(aoUsrMenu)]:Add(aUMItens[Len(aUMItens)])
						Next nUItem
						aoBtnUser[nBtnUsr]:SetPopupMenu(aoUsrMenu[Len(aoUsrMenu)])
					EndIf

				Next nBtnUsr

			EndIf
		Else
			If lRtCTeId .And. lCTECan
				@ aPosObj[3,1],aPosObj[3,4] + 380 + nDif BUTTON oBtn13 PROMPT STR0015 ACTION oDlg:End()	OF oDlg PIXEL SIZE 035,011	//-- "Sair"
			Else
				@ aPosObj[3,1],aPosObj[3,4] + 340 + nDif BUTTON oBtn13 PROMPT STR0015 ACTION oDlg:End()	OF oDlg PIXEL SIZE 035,011	//-- "Sair"
			EndIf
		EndIf
	//Verifica a validade do certificado digital.	
	CtIsReady(,2,,lUsaColab)
	ACTIVATE MSDIALOG oDlg
EndIf

Return( Nil )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TMS70INUT ³ Autor ³Felipe Barbieri        ³ Data ³28.04.2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina responsavel atualizar tabela SF3 na inutilização CT-e³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Param[1] - Array que carrega os documentos e serie          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/  
Static Function TMS70INUT(aParam)
Local cURL      := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local lOk       := .F.
Local oWS
Local oRetorno
Local nX		:= 0
Local cIdEnt 	:= ""
Local lUsaColab	:= UsaColaboracao("2")

If !lUsaColab
	cIdEnt := RetIdEnti()
	
	oWS:= WSNFeSBRA():New()
	oWS:cUSERTOKEN    := "TOTVS"
	oWS:cID_ENT       := cIdEnt 
	oWS:_URL          := AllTrim(cURL)+"/NFeSBRA.apw"
	oWS:cIdInicial    := aParam[1] + aParam[2]
	oWS:cIdFinal      := aParam[1] + aParam[3]
	lOk := oWS:MONITORFAIXA()
	oRetorno := oWS:oWsMonitorFaixaResult
	
	dbSelectArea("SF3")
	dbSetOrder(6)
	For nX := 1 To Len(oRetorno:oWSMONITORNFE)
		If SF3->(MsSeek(xFilial("SF3") + SubStr(oRetorno:OWSMONITORNFE[nX]:CID, 4, 9) + SubStr(oRetorno:OWSMONITORNFE[nX]:CID, 1, 3)));
			.And. oRetorno:OWSMONITORNFE[nX]:OWSERRO:OWSLOTENFE[1]:CCODRETNFE == "102"
			RecLock("SF3",.F.)
			SF3->F3_CODRSEF := oRetorno:OWSMONITORNFE[nX]:OWSERRO:OWSLOTENFE[1]:CCODRETNFE
			MsUnLock()
		EndIf
	Next nX
EndIf
	
Return (Nil)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TMS70LIST ³ Autor ³Andre Godoi            ³ Data ³25.03.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina responsavel por selecionar os doc's do monitor       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Logico                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Param[1] - Array que carrega os doc. da tela.               ³±±
±±³          ³Param[2] - Numero, origem da funcao                         ³±±
±±³          ³            1 - Tmsa200                                     ³±±
±±³          ³            2 - Tmsa500                                     ³±±
±±³          ³            3 - Objeto Time, atualiza a tela.               ³±±
±±³          ³Param[3] - Nome do Pergunte de acordo com programa chamdor  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/            
Static Function TMS70LIST(aListBox, aPerg)
Local cQuery    := ''
Local cAlias    := GetNextAlias()
Local lRetorno  := .T.
Local oVerde    := LoadBitmap( GetResources(),'BR_VERDE'	)
Local oAmarelo  := LoadBitmap( GetResources(),'BR_AMARELO'	)
Local oVermelho := LoadBitmap( GetResources(),'BR_VERMELHO'	)
Local oAzul     := LoadBitmap( GetResources(),'BR_AZUL'		)
Local oPreto    := LoadBitmap( GetResources(),'BR_PRETO'	)
Local lTME70CPO := ExistBlock("TME70CPO")
Local cMvTmsDoc := GetMv("MV_TMSDOC",,"")
Local cTipDoc   := ""
Local lTms500   := .F.
Local lFiltLote	:= .F.
Local oCor      := {}
Local aRetPE    := {}
Local nPosMrk   := 0
Local nPosIni   := 0
Local nTamIni   := 0
Local nI        := 0
Local cTME70QRY := ""
Local lCTECan	:= SuperGetMv( "MV_CTECAN", .F., .F. ) //-- Cancelamento CTE - .F.-Padrao .T.-Apos autorizacao
Local lRtCTeId	:= SuperGetMv( "MV_RTCTEID", .F., .F. ) //-- Habilita o botão Retorno de Status

nQtdMrk := 0

//Se for == 1, chamada do Tmsa200
//Se for == 2, chamada do Tmsa500
If aPerg[1,1] == 1 //-- Chamada do Tmsa200
	cTipDoc := aPerg[1,5]
ElseIf aPerg[1,1] == 2 //-- Chamada do Tmsa500
	cTipDoc := aPerg[1,9]
	lTms500 := .T.
EndIf

If !lTms500
	// Verifica se existe filtro por lote especifico
	lFiltLote := ! Empty(aPerg[1,2]) .Or. aPerg[1,3] <> 'ZZZZZZ' 
ElseIf cTipDoc <> 'M' //--Tratamento para filtro de documento de Anulação.
	lFiltLote := .T.
EndIf

//-- Select para lista todos os Doc. do Painel.
cQuery := " SELECT "
cQuery += "   DT6_FILIAL, DT6_FILDOC, DT6_DOC   , DT6_SERIE  , "
cQuery += "   DT6_SITCTE, DT6_RETCTE, DT6_DATEMI, DT6_HOREMI , "
cQuery += "   DT6_LOTNFC, DT6_DOCTMS, DT6.R_E_C_N_O_ DT6RECNO, "
cQuery += "   DT6_FIMP  , A1_NREDUZ   DT6_NOMREM, '' F1_FIMP, 'S' TIPO, DT6_IDRCTE"
cQuery += " FROM " + RetSqlName('DT6') + " DT6 "
//-- Lote de Entrada Notas Fiscais
cQuery += " INNER JOIN " + RetSqlName('DTP') + " DTP ON "
cQuery += "       DTP.DTP_FILIAL = '"+ xFilial("DTP") +"'"
cQuery += "   AND DTP.DTP_FILORI = DT6.DT6_FILORI "
cQuery += "   AND DTP.DTP_LOTNFC = DT6.DT6_LOTNFC "
cQuery += "   AND DTP.DTP_TIPLOT IN ('" + StrZero(3,Len(DTP->DTP_TIPLOT)) + "', '" + StrZero(4,Len(DTP->DTP_TIPLOT)) + "') "  //-- 3 - Eletronico -- 4 CTe Unico
cQuery += "   AND DT6.DT6_DOCTMS NOT IN ('" +	StrZero( 5, Len( DT6->DT6_DOCTMS ) ) + "', '" +;    //--Nota Fiscal de Serv. de Transp.
												Replicate('D', Len( DT6->DT6_DOCTMS ) ) + "', '" +; //--Nota Fiscal de Reentrega
												Replicate('F', Len( DT6->DT6_DOCTMS ) ) + "', '" +; //--Nota Fiscal de Armazenagem
												Replicate('G', Len( DT6->DT6_DOCTMS ) ) + "') "     //--Nota Fiscal de Complemento
cQuery += "   AND DTP.D_E_L_E_T_ = ' '"
//-- So utiliza quando vier do Tmsa200 ou do Time.
If !lTms500
	cQuery += "AND DTP.DTP_LOTNFC BETWEEN '" + (aPerg[1,2]) + "' AND '" + (aPerg[1,3]) + "' "
EndIf
//-- Cadastro de Clientes
cQuery += " INNER JOIN " + RetSqlName('SA1') + " SA1 ON "
cQuery += "       SA1.A1_FILIAL  = '"+ xFilial("SA1") +"' "
cQuery += "   AND SA1.A1_COD     = DT6.DT6_CLIREM "
cQuery += "   AND SA1.A1_LOJA    = DT6.DT6_LOJREM "
cQuery += "   AND SA1.D_E_L_E_T_ = ' '"
//-- Condicoes
cQuery += " WHERE DT6.DT6_FILIAL = '" + xFilial('DT6') + "'"
cQuery += "   AND DT6.DT6_FILDOC = '" + cFilAnt + "' "
//-- documentos com serie PED não são apresentados no monitor por serem provenientes de um bloqueio que gera Pedido de Venda.
cQuery += "   AND DT6.DT6_SERIE <> 'PED' " 
//-- Pergunte do Tipo de Documento Preenchido. Senao, seleciona todos os tipo de de Doc.
If !Empty(cTipDoc)
	cQuery += "AND DT6.DT6_DOCTMS = '" + cTipDoc + "' "
EndIf
//-- Pergunte do Status do Documento preenchido, senao seleciona todos os Status de Doc..
If lTms500
	If aPerg[1,8] == 1
		cQuery += "AND DT6.DT6_SITCTE <> '2' "
	ElseIf aPerg[1,8] == 2
		cQuery += "AND DT6.DT6_SITCTE =  '2' "
	EndIf
Else
	If aPerg[1,4] == 1
		cQuery += "AND DT6.DT6_SITCTE <> '2' "
	ElseIf aPerg[1,4] == 2
		cQuery += "AND DT6.DT6_SITCTE =  '2' "
	EndIf
EndIf
//-- Carrega este grupo de pergunta quando for da rotina Tmsa500
If lTms500
	cQuery += "AND DT6.DT6_DOC    BETWEEN '" + aPerg[1,2] + "' AND '" + aPerg[1,3] + "' "
	cQuery += "AND DT6.DT6_SERIE  BETWEEN '" + aPerg[1,4] + "' AND '" + aPerg[1,5] + "' "
	cQuery += "AND DT6.DT6_DATEMI BETWEEN '" + aPerg[1,6] + "' AND '" + aPerg[1,7] + "' "
Else
	cQuery += "AND DT6.DT6_DATEMI BETWEEN '" + aPerg[1,6] + "' AND '" + aPerg[1,7] + "' "
EndIf
cQuery += "   AND DT6.D_E_L_E_T_ = ' '"
If ExistBlock("TME70QRY")
	cTME70QRY = ExecBlock("TME70QRY",.F.,.F.)
	If Valtype(cTME70QRY) == "C"
		cQuery += cTME70QRY
	EndIf
EndIf

// Se o lote é filtrado não exibe Docs de entrada pois nao possuem Lote
If !lFiltLote	

	cQuery += "UNION ALL"
	//-- Retorna Documentos de Devolucao	
	cQuery += " SELECT DISTINCT D1_FILIAL DT6_FILIAL,D1_FILIAL DT6_FILDOC,D1_DOC DT6_DOC,D1_SERIE DT6_SERIE,'' DT6_SITCTE, F3_CODRSEF || ' - ' || F3_DESCRET DT6_RETCTE,D1_EMISSAO DT6_DATEMI,F1_HORA DT6_HOREMI,"
	cQuery += "        'N/A' DT6_LOTNFC,'' DT6_DOCTMS,SF1.R_E_C_N_O_ DT6RECNO,' ' DT6_FIMP,A1_NREDUZ DT6_NOMREM,F1_FIMP,'E' TIPO, ' ' IDRCTE"
	cQuery += "  FROM " + RetSqlName('SD1') + " SD1 "
	//-- Cadastro de Documentos de Entrada
	cQuery += "	INNER JOIN " + RetSqlName('SF1') + " SF1 ON "
	cQuery += "       SF1.F1_FILIAL  = '" + xFilial('SF1') + "'" 
	cQuery += "   AND SF1.F1_DOC     = SD1.D1_DOC AND SF1.F1_SERIE = SD1.D1_SERIE"
	cQuery += "   AND SF1.F1_TIPO    = 'D' "   // Somente CTE Devolucao
	cQuery += "   AND SF1.F1_TPCTE   = 'A' "   // Somente CTE Anulacao
	cQuery += "   AND SF1.F1_ESPECIE = 'CTE' " // Somente CTE
	cQuery += "   AND SF1.F1_FORMUL  = 'S' "  // Somente formulário proprio 
	cQuery += "   AND SF1.D_E_L_E_T_ = '' " 
	
	If lTms500
		If aPerg[1,8] == 1
			cQuery += "AND SF1.F1_FIMP <> 'S' "
		ElseIf aPerg[1,8] == 2
			cQuery += "AND SF1.F1_FIMP =  'S' "
		EndIf
	Else
		If aPerg[1,4] == 1
			cQuery += "AND SF1.F1_FIMP <> 'S' "
		ElseIf aPerg[1,4] == 2
			cQuery += "AND SF1.F1_FIMP =  'S' "
		EndIf
	EndIf
	
	//-- Cadastro de Clientes
	cQuery += "	INNER JOIN " + RetSqlName('SA1') + " SA1 ON "
	cQuery += "       SA1.A1_FILIAL  = '" + xFilial('SA1') + "'" 
	cQuery += "   AND SA1.A1_COD = SF1.F1_FORNECE AND SA1.A1_LOJA = SF1.F1_LOJA"
	cQuery += "   AND SA1.D_E_L_E_T_ = '' " 
	//-- Livros Fiscais
	cQuery += "	 LEFT JOIN " + RetSqlName('SF3') + " SF3 ON "
	cQuery += "       SF3.F3_FILIAL  = '" + xFilial('SF3') + "'"
	cQuery += "   AND SF3.F3_NFISCAL = SF1.F1_DOC AND SF3.F3_SERIE = SF1.F1_SERIE " 
	cQuery += "   AND SF3.F3_CLIEFOR = SF1.F1_FORNECE AND SF3.F3_LOJA = SF1.F1_LOJA"
	cQuery += "   AND SF3.F3_FORMUL  = 'S' AND SF3.F3_DTCANC  = ''
	cQuery += "   AND SF3.F3_TIPO    = 'D' "   // Somente CTE Devolucao
	cQuery += "   AND SF3.F3_ESPECIE = 'CTE' " // Somente CTE 
	cQuery += "   AND SF3.D_E_L_E_T_ = '' "
	
	//-- Condicoes
	cQuery += " WHERE SD1.D1_FILIAL = '" + xFilial('SD1') + "'"
	//-- Carrega este grupo de pergunta quando for da rotina Tmsa500
	If lTms500
		cQuery += "		AND SD1.D1_DOC     BETWEEN '" + aPerg[1,2] + "' AND '" + aPerg[1,3] + "' "
		cQuery += "		AND SD1.D1_SERIE   BETWEEN '" + aPerg[1,4] + "' AND '" + aPerg[1,5] + "' "
		cQuery += "		AND SD1.D1_EMISSAO BETWEEN '" + aPerg[1,6] + "' AND '" + aPerg[1,7] + "' "
	Else
		cQuery += "		AND SD1.D1_EMISSAO BETWEEN '" + aPerg[1,6] + "' AND '" + aPerg[1,7] + "' "
	EndIf
	cQuery += "	AND SD1.D_E_L_E_T_ = ' '"
EndIf

cQuery += " ORDER BY DT6_DATEMI ,DT6_DOC, DT6_SERIE ,DT6_FILIAL, DT6_FILDOC "
cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T.)
TcSetField(cAlias,"DT6_DATEMI", "D", 8, 0)

If !(cAlias)->(Eof())
	While (!(cAlias)->(Eof()))

		//-- De acordo com a situacao do documento de saida, seleciona uma determinada cor p/ o Objeto.
		If (cAlias)->TIPO = "S"
			DT6->(dbGoTo((cAlias)->DT6RECNO))
			Do Case
				Case (cAlias)->DT6_SITCTE == StrZero(1,Len(DT6->DT6_SITCTE))	//-- 1 Doc Aguardando
					oCor	:= oVerde
				Case (cAlias)->DT6_SITCTE == StrZero(0,Len(DT6->DT6_SITCTE))	//-- 0 Nao Transmitido
					oCor	:= oAmarelo
				Case (cAlias)->DT6_SITCTE == StrZero(3,Len(DT6->DT6_SITCTE))	//-- 3 Doc Nao Autorizado
					oCor	:= oVermelho
				Case (cAlias)->DT6_SITCTE == StrZero(2,Len(DT6->DT6_SITCTE))	//-- 2 Doc Autorizado
					oCor	:= oAzul
				Case (cAlias)->DT6_SITCTE == StrZero(5,Len(DT6->DT6_SITCTE))	//-- 5 Doc com Falha na Comunicacao
					oCor	:= oPreto
				OtherWise
					oCor	:= oAmarelo
			EndCase
			
		Else
			SF1->(dbGoTo((cAlias)->DT6RECNO))
			Do Case
				Case (SubStr(Alltrim((cAlias)->DT6_RETCTE),1,3) = "100")	//-- S NF Autorizada
					oCor	:= oAzul 
				Case (cAlias)->F1_FIMP == " "	//-- N NF Nao Transmitida
					oCor	:= oAmarelo
				Case (cAlias)->F1_FIMP == "T"	//-- T NF Transmitida
					oCor	:= oVerde
				Case (cAlias)->F1_FIMP == "N"	//-- N NF Nao Autorizada
					oCor	:= oVermelho
				OtherWise
					oCor	:= oAmarelo
			EndCase
		EndIf

		cTipDoc := ""
		Do Case
			Case (cAlias)->DT6_DOCTMS == StrZero(1,Len(DT6->DT6_DOCTMS))
				cTipDoc := STR0017	// -- Ordem de Coleta
			Case (cAlias)->DT6_DOCTMS == StrZero(2,Len(DT6->DT6_DOCTMS))
				cTipDoc := STR0018	// -- CTRC
			Case (cAlias)->DT6_DOCTMS == StrZero(3,Len(DT6->DT6_DOCTMS))
				cTipDoc := STR0019	// -- AWB
			Case (cAlias)->DT6_DOCTMS == StrZero(4,Len(DT6->DT6_DOCTMS))
				cTipDoc := STR0020	// -- Docto.Bx.Estoque
			Case (cAlias)->DT6_DOCTMS == StrZero(5,Len(DT6->DT6_DOCTMS))
				cTipDoc := STR0021	// -- Nota Fiscal
			Case (cAlias)->DT6_DOCTMS == StrZero(6,Len(DT6->DT6_DOCTMS))
				cTipDoc := STR0022	// -- CTRC Devolucao
			Case (cAlias)->DT6_DOCTMS == StrZero(7,Len(DT6->DT6_DOCTMS))
				cTipDoc := STR0023	// -- CTRC Reentrega
			Case (cAlias)->DT6_DOCTMS == StrZero(8,Len(DT6->DT6_DOCTMS))
				cTipDoc := STR0024	// -- CTRC Complemento
			Case (cAlias)->DT6_DOCTMS == StrZero(9,Len(DT6->DT6_DOCTMS))
				cTipDoc := STR0025	// -- CTRC Retorno
			Case (cAlias)->DT6_DOCTMS == 'A'
				cTipDoc := STR0026	// -- CTRC Cortesia
			Case (cAlias)->DT6_DOCTMS == 'E'
				cTipDoc := STR0028	// -- CTRC Armazenagem
			Case (cAlias)->DT6_DOCTMS == 'P'
				cTipDoc := "CTRC SUBSTITUICAO"             
			Case (cAlias)->DT6_DOCTMS == ' '
				cTipDoc := STR0018	// -- CTRC
			Case (cAlias)->DT6_DOCTMS $ 'BCHINO'
				If ( nPosIni := At((cAlias)->DT6_DOCTMS+"=",cMvTmsDoc)) <> 0
					nPosIni += 2
					nTamIni := At(";",Substr(cMvTmsDoc,nPosIni)) - 1
					If nTamIni <= 0
				   		nTamIni := Len(Alltrim(Substr(cMvTmsDoc,nPosIni))) + 1
					EndIf
					cTipDoc := Substr(cMvTmsDoc,nPosIni,nTamIni)
				Else
					cTipDoc := STR0027	// -- ACT
				EndIf
		EndCase

		Aadd(aListBox,Array(NROCPOS))
		nPosMrk := Ascan(aDocMark,{ | e | e[1]+e[2] == (cAlias)->DT6_DOC+(cAlias)->DT6_SERIE })  
		If nPosMrk > 0 .and. AllTrim((cAlias)->DT6_SITCTE) <> "2" 
			If AllTrim(aDocMark[nPosMrk,3]) == "1"
				nQtdMrk++
			EndIf
		EndIf
		If lExecAuto
			aListBox[Len(aListBox),CTMARCA ] := '1'
		Else
			If (cAlias)->TIPO = "S" 
				aListBox[Len(aListBox),CTMARCA ] := Iif(nPosMrk == 0 .Or. AllTrim((cAlias)->DT6_SITCTE) == "2" ,'2',aDocMark[nPosMrk,3])
			Else
				aListBox[Len(aListBox),CTMARCA ] := Iif(nPosMrk == 0 .Or. (SubStr(Alltrim((cAlias)->DT6_RETCTE),1,3) = "100") ,'2',aDocMark[nPosMrk,3])
			EndIf
		EndIf
		aListBox[Len(aListBox),CTCORBRW] := oCor
		aListBox[Len(aListBox),CTDATEMI] := (cAlias)->DT6_DATEMI
		aListBox[Len(aListBox),CTHOREMI] := Transform((cAlias)->DT6_HOREMI,X3Picture("DT6_HOREMI"))
		aListBox[Len(aListBox),CTLOTNFC] := (cAlias)->DT6_LOTNFC
		aListBox[Len(aListBox),CTFILDOC] := (cAlias)->DT6_FILDOC
		aListBox[Len(aListBox),CTDOC   ] := (cAlias)->DT6_DOC
		aListBox[Len(aListBox),CTSERIE ] := (cAlias)->DT6_SERIE
		aListBox[Len(aListBox),CTTIPDOC] := cTipDoc
		aListBox[Len(aListBox),CTRETCTE] := AllTrim((cAlias)->DT6_RETCTE)
		aListBox[Len(aListBox),CTSITCTE] := Iif((cAlias)->TIPO = "S", AllTrim((cAlias)->DT6_SITCTE), Iif((SubStr(Alltrim((cAlias)->DT6_RETCTE),1,3) = "100") ,'2', ' '))
		aListBox[Len(aListBox),CTNOMREM] := (cAlias)->DT6_NOMREM
		aListBox[Len(aListBox),CTFIMP  ] := (cAlias)->DT6_FIMP
		aListBox[Len(aListBox),CTFIMPDS] := Iif((cAlias)->DT6_FIMP == '1','Impresso', Iif((cAlias)->DT6_FIMP == '0', 'Não Impresso', 'Não Se Aplica'))
		aListBox[Len(aListBox),CTDT6REC] := (cAlias)->DT6RECNO
		aListBox[Len(aListBox),CTTIPO  ] := (cAlias)->TIPO

		//-- Ponto de entrada para incluir campos do monitor do CTE.
		If lTME70CPO
			aRetPE := ExecBlock("TME70CPO",.F.,.F.)
			If	ValType(aRetPE) == "A"
				For nI := 1 To Len(aRetPE)
					aAdd(aListBox[Len(aListBox)],aRetPE[nI])
				Next nI
			EndIf
		EndIf

		(cAlias)->(DbSkip())

		If Len(aListBox) >= 32600
			MsgAlert (STR0049)
			Exit
		EndIf

	EndDo
Else
	Aadd(aListBox,Array(NROCPOS))
	aListBox[Len(aListBox),CTMARCA ] := '2'
	aListBox[Len(aListBox),CTCORBRW] := ''
	aListBox[Len(aListBox),CTDATEMI] := ''
	aListBox[Len(aListBox),CTHOREMI] := ''
	aListBox[Len(aListBox),CTLOTNFC] := ''
	aListBox[Len(aListBox),CTFILDOC] := ''
	aListBox[Len(aListBox),CTDOC   ] := ''
	aListBox[Len(aListBox),CTSERIE ] := ''
	aListBox[Len(aListBox),CTTIPDOC] := ''
	aListBox[Len(aListBox),CTRETCTE] := ''
	aListBox[Len(aListBox),CTSITCTE] := ''
	aListBox[Len(aListBox),CTNOMREM] := ''
	aListBox[Len(aListBox),CTFIMP  ] := ''
	aListBox[Len(aListBox),CTFIMPDS] := ''
	aListBox[Len(aListBox),CTDT6REC] := 0
	aListBox[Len(aListBox),CTTIPO  ] := ''
	//-- Ponto de entrada para incluir campos do monitor do CTE.
	If lTME70CPO
		aRetPE := ExecBlock("TME70CPO",.F.,.F.)
		If	ValType(aRetPE) == "A"
			For nI := 1 To Len(aRetPE)
				aAdd(aListBox[Len(aListBox)],aRetPE[nI])
			Next nI
		EndIf
	EndIf
EndIf
(cAlias)->(dbCloseArea())

Return( lRetorno )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TMS70ENV  ³ Autor ³Andre Godoi            ³ Data ³25.03.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina responsavel por Retransmitir os doc ao TSS           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Logico                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Param[1] - Array contendo os doc. da tela.                  ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function TMS70ENV(aListBox,aPerg,lRefresh)
Local aDoctosTra  := {}
Local lEnd        := .F.
Local cModalidade := ""
Local cVersaoCTE  := ""
Local lUsacolab   := UsaColaboracao("2")
Local cIdEnt 	  := RetIdEnti(lUsaColab)
Local cURL        := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cAmbiente	  := ""
Local lRetr		  := .F.
Local nI		  := 0
Local aAreaDT6    := {}
Local aParam      := {"","",""}

Default aListBox  := {}
Default aPerg     := {}
Default lRefresh  := .T.

//-- Verifica se está com transação aberta
If InTransact()
	bErrorBkp := ErrorBlock({|e| TMSAE70ERR(e)})
	Begin Sequence
	UserException(	" * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *" +CRLF+;
					" * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *" +CRLF+;
					" * * ATENÇÃO!!! HÁ UMA TRANSAÇÃO EM ABERTO !!!!  * * * * * *" +CRLF+;
					" * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *" +CRLF+;
					" * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *" +CRLF)
	End Sequence
	ErrorBlock(bErrorBkp)
	MsgStop("STR0069")
	Return Nil
EndIf

If ExistFunc('TMSMonSEF') .And. !TMSMonSEF('57',@cModalidade)
	Return()
EndIf

If !lExecAuto
	If Ascan( aListBox, { | e | e[CTMARCA] == '1' } ) == 0
		If	!lUsaColab .And. !TMSSpedNFe(@cIdEnt,@cModalidade,@cVersaoCTE,@cAmbiente)
			Return()
		EndIf
		If MsgYesNo(STR0044+CRLF+"Transmite documentos cancelados?",STR0046)	// -- "Não existem documentos marcados para transmitir!" , "ATENÇÃO"
			dbSelectArea("DT6")
			//-- Rotina de cancelamento da NFe para o Totvs Services SPED
			If !lUsaColab
				SpedNFeCan(/*cEmpAnt*/,/*cFilAnt*/,cIdEnt,cAmbiente,cModalidade,cVersaoCTE,{"","",""}/*aInfnota*/,.T./*lCTe*/)
				//--Filtra tabela SF3 para atualizar as inutilizações
				FiltroSF3(@aParam)	
				Sleep(5000)
				//--Rotina responsavel atualizar tabela SF3 na inutilização CT-e
				TMS70INUT(aParam)			
			Else
				cAmbiente		:= ColGetPar("MV_AMBCTE","")							
				cVersaoCte		:= ColGetPar("MV_VERCTE","")
				cModalidade		:= ColGetPar("MV_MODCTE","")
				SpedNFeCan(/*cEmpAnt*/,/*cFilAnt*/,cIdEnt,cAmbiente,cModalidade,cVersaoCTE,{"","",""}/*aInfnota*/,.T./*lCTe*/)
			EndIf
			//--Se for Documento de Reentrega	
			If DT6->DT6_DOCTMS == StrZero(7,Len(DT6->DT6_DOCTMS)).And. DT6->DT6_STATUS <> "C"	//--  C- Cancelamento SEFAZ Autorizado
				aAreaDT6 := DT6->(GetArea())
				DT6->(dbSetOrder(1))
				If DT6->(MsSeek(xFilial('DT6')+ DT6->DT6_FILDCO + DT6->DT6_DOCDCO + DT6->DT6_SERDCO)) .And. DT6->DT6_REENTR > 0
					RecLock("DT6",.F.)
					DT6->DT6_REENTR := DT6->DT6_REENTR - 1
					DT6->(MsUnLock())
				EndIf
				RestArea(aAreaDT6)
			EndIf
		EndIf		
		Return
	Else	
		If !MsgYesNo(STR0045)	// -- "Confirma transmissão dos documentos marcados?"
			Return
		EndIf
	EndIf
EndIf

//-- Obtem documentos para transmissao junto com a ação ( 1 = Transmitir; 2 = Solicitar Status)
aDoctosTra := TMS70Doc( aListBox, '1' )

//-- Tratamento incluido para modalidade EPEC tratamento para o erro 697 conforme manual da SEFAZ
If Substr(AllTrim(cModalidade), 1, 1) $ "5" 
	
	aAreaDT6 := DT6->(GetArea())
	dbSelectArea("DT6")
	DT6->(dbGoTop())
	DT6->(dbSetOrder(1)) //DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE
	
	For nI := 1 To Len(aDoctosTra)
		If DT6->(dbSeek(xFilial("DT6")+cFilAnt+aDoctosTra[nI,2]+aDoctosTra[nI,1 ]))
			If DT6->DT6_DATEMI <> dDataBase
				Help("",1,"TMSAE70001",,aDoctosTra[nI,2] + " / " + aDoctosTra[nI,1 ],4,0) //Modalidade 5-EPEC, com a data de geração ","do CTe, diferente da data de ","transmissão!! 				 
				Return()
			EndIf
		EndIf
	Next nI

	RestArea(aAreaDT6)
EndIf

//-- Tratamento incluido para modalidade SVC tratamento não transmitir CT-e diferente de normal, quando a opção SVC estiver habilitada. SVC-SP e SVC-RS só aceita CT-e normal. Rejeitando com as rejeição 517 / 227.
If Substr(AllTrim(cModalidade), 1, 1) $ "8/9" 
	
	CheckHLP('PTMSAE70002', {'Modalidade SVC-RS e SVC-SP, não aceita',' CT-e de complemento, somente CT-e do',' tipo normal, para transmissão.'},{''},{''},.T.)
	CheckHLP('STMSAE70002', {'Aguarde o retorno do ambiente para',' normal, e retransmita o CT-e de', 'complemento.'},{''},{''},.T.)
	
	aAreaDT6 := DT6->(GetArea())
	dbSelectArea("DT6")
	DT6->(dbGoTop())
	DT6->(dbSetOrder(1)) //DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE
	
	For nI := 1 To Len(aDoctosTra)
		If DT6->(dbSeek(xFilial("DT6")+cFilAnt+aDoctosTra[nI,2]+aDoctosTra[nI,1 ]))
			If DT6->DT6_DOCTMS $ "8/P/M"
				Help("",1,"TMSAE70002",,aDoctosTra[nI,2] + " / " + aDoctosTra[nI,1 ],4,0) //Modalidade 7/8-SVC, não aceita CT-e de complemento ","somente CT-e do tipo normal","para transmissão!! 				 
				Return()
			EndIf
		EndIf
	Next nI

	RestArea(aAreaDT6)
EndIf

If Ascan( aDoctosTra, { | e | e[5] = '1'} ) <> 0
	lRetr := MsgNoYes("Existem documentos que ainda estão aguardando transmissão." +CRLF+ "Deseja retransmití-los?",STR0046, "NOYES")
EndIf

Processa( { |lEnd| TMS70PrEnv(aDoctosTra,@lEnd, lRetr) }, , 'Transmitindo documentos...', .T. )


If lRefresh
	//-- Retira marca dos documentos autorizados
	TMS70Ret(aListBox)
	//-- Realiza refresh no BROWSE
	TMS70Rfs(@aListBox, aPerg)
EndIf

Return( Nil )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TMSAE70ERR³ Autor ³ Daniel Leme           ³ Data ³01.08.2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Grava Log em caso de erro de transação                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Logico                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function TMSAE70ERR(e)
Local lbreakPoint

If ExistFunc("TmsRepTrac")
	TmsRepTrac(e:ErrorStack,.T.)
	TmsRepTrac(e:Description,.T.)
	TmsRepTrac(e:ErrorEnv,.T.)
	break
EndIf

Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TMS70PrEnv³ Autor ³ Richard Anderson      ³ Data ³24.08.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de Processamento do Envio dos Doctos para o TSS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Logico                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Param[1] - Array contendo os doc. da tela.                  ³±±
±±³          ³lExp1    - Controle para interromper o processamento        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function TMS70PrEnv(aDoctosTra,lEnd, lRetr)

Local   lRetorno   := .T.
Local   cDocIni    := ''
Local   cDocFin    := ''
Local   cSerie     := ''
Local   nI         := 0
Local   cDesc      := ''

Private aPChvCtg    := {} //-- private para resgatar a chave de contingencia

Default aDoctosTra := {}
Default lRetr		  := .F.

ProcRegua(Len(aDoctosTra))

For nI := 1 To Len(aDoctosTra)
	IncProc()
	If lEnd
		If MsgYesNo('Deseja interromper o processamento?')
			Exit
		EndIf
		lEnd := .F.
	EndIf
	If !lRetr .And. aDoctosTra[nI,5] == '1'
		Loop
	EndIf
	
	cSerie  := aDoctosTra[nI,1]
	cDocIni := aDoctosTra[nI,2]
	cDocFin := aDoctosTra[nI,3]
	//-- Funcao responsavel por enviar os Doc. para o TSS.
	SpedNFeRe2(cSerie, cDocIni, cDocFin, .T., @lRetorno)
	aDoctosTra[nI,4] := lRetorno
	If !lRetorno
		//-- Rotina responsavel por gravar o status e descricao do doc. " Nao Transmitido, falha de comunicacao."
		cDesc := STR0036 	// -- "Documento com Falha na Comunicação"
		TMS70AtuSt(cFilAnt, cSerie, cDocIni, cDocFin,"5",cDesc)
	EndIf
Next nI

If !lUsaColab
	If Len(aDoctosTra) < 100
		If (TMSExp() .And. IsInCallStack("TMSA144")).Or. lExecAuto 
			Sleep(30000)
		Else
			Sleep(10000)
		EndIf			
	EndIf

	For nI := 1 To Len(aDoctosTra)
		IncProc()
		If aDoctosTra[nI,4]
			cSerie  := aDoctosTra[nI,1]
			cDocIni := aDoctosTra[nI,2]
			cDocFin := aDoctosTra[nI,3]
			WsCteMnt(cSerie, cDocIni, cDocFin)
		EndIf
	Next nI
EndIf

Return( Nil )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TMS70Doc  ³ Autor ³ Richard Anderson      ³ Data ³18.08.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Preparar documentos para transmissao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Array dos documentos                                       ³±±
±±³          ³ [1] - Serie                                                ³±±
±±³          ³ [2] - Documento Inicial                                    ³±±
±±³          ³ [3] - Documento Final                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function TMS70Doc(aListBox,cAcao)

Local   nI         := 0
Local   aDoctos    := {}
Local   aDoctosTra := {}
Local   aDoctosCnt := {}
Local   nQtdDoc    := 1
Local   aAreaDT6   := {}
Local 	 aVisErr    := {}
Local   cDocCTG    := ''

Default cAcao      := '1'

//-- Fil.Docto + Docto + Serie
aDoctos := AClone(aListBox)
ASort( aDoctos,,,{|x,y| x[ CTMARCA ] + x[ CTDOC ] + x[ CTSERIE ] < y[ CTMARCA] + y[ CTDOC ] + y[ CTSERIE ] })
For nI := 1 To Len(aDoctos)
	If aDoctos[nI,CTMARCA] == '2'
		Exit
	EndIf
	If cAcao == '2' .And. aDoctos[nI,CTSITCTE] == '0' //-- Tentativa de Solicitar Status para Documentos ainda não transmitidos
		Loop
	EndIf
	If cAcao == '1'	//--> Caso o documento tenha sido transmitido em contingência ou em modalidade(8;9), não será possível transmitir novamente. 
		aAreaDT6 := DT6->(GetArea())
		dbSelectArea("DT6")
		DT6->(dbGoTop())
		DT6->(dbSetOrder(1)) //DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE
		If DT6->(dbSeek(xFilial("DT6")+aDoctos[nI,CTFILDOC ]+aDoctos[nI,CTDOC   ]+aDoctos[nI,CTSERIE ]))
			If (!Empty(DT6->DT6_CHVCTG)) .Or. (!Empty(DT6->DT6_CHVCTE) .And. (Substr(DT6->DT6_CHVCTE,35,1) $ '8/9'))
				cDocCTG := aDoctos[nI,CTFILDOC ] + " - " + aDoctos[nI,CTDOC   ] + " - " + aDoctos[nI,CTSERIE ]								
				
				If !Empty(DT6->DT6_CHVCTG) 
				 cDocCTG += "-" + "Documento transmitido em contingencia"
				 
				ElseIF !Empty(DT6->DT6_CHVCTE) .And. (Substr(DT6->DT6_CHVCTE,35,1) $ '8/9')
				 cDocCTG += "-" + "Documento enviado anteriormente na modalidade de contingencia 8/9-SVC"				 
				EndIf
				Aadd(aVisErr,{cDocCTG})
			EndIf			
		EndIf
		RestArea(aAreaDT6)
	EndIf
	If !Empty(aDoctosCnt)
		If aDoctos[nI,CTSERIE]+AllTrim(aDoctos[nI,CTDOC]) <> aDoctosCnt[1]+Soma1(AllTrim(aDoctosCnt[2])) .Or. nQtdDoc > 50
			aDoctosTra[Len(aDoctosTra),3] := Padr(aDoctosCnt[2],Len(DT6->DT6_DOC))
			aDoctosCnt    := {}
			nQtdDoc       := 1
		Else
			aDoctosCnt[2] := Soma1(AllTrim(aDoctosCnt[2]))
			nQtdDoc       += 1
		EndIf
	EndIf
	If Empty(aDoctosCnt)
		Aadd(aDoctosTra,Array(5))
		aDoctosTra[Len(aDoctosTra),1] := aDoctos[nI,CTSERIE ]
		aDoctosTra[Len(aDoctosTra),2] := aDoctos[nI,CTDOC   ]
		aDoctosTra[Len(aDoctosTra),3] := ''
		aDoctosTra[Len(aDoctosTra),4] := .F.
		aDoctosTra[Len(aDoctosTra),5] := aDoctos[nI,CTSITCTE]
		aDoctosCnt 		:= Array(2)
		aDoctosCnt[1] 	:= aDoctos[nI,CTSERIE ]
		aDoctosCnt[2] 	:= aDoctos[nI,CTDOC   ]
		nQtdDoc        += 1
	EndIf
Next nI
If Len(aDoctosTra) > 0 .And. Empty(aDoctosTra[Len(aDoctosTra),3])
	aDoctosTra[Len(aDoctosTra),3] := Padr(aDoctosCnt[2],Len(DT6->DT6_DOC))
EndIf

If Len(aVisErr) > 0
	TmsMsgErr (aVisErr, "Documentos não enviados ao TSS") //--
EndIf

Return( aDoctosTra )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TMS70STA  ³ Autor ³Andre Godoi            ³ Data ³25.03.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina responsavel por solicitar o Status dos Doc's.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Logico                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Param[1] - Array contendo os doc. da tela.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function TMS70STA(aListBox,aPerg)

Local aDoctosTra := {}
Local lEnd       := .F.
Default aListBox := {}

If lUsaColab
	Aviso("TOTVS Colaboração","Utilizar opção Monitor para TOTVS Colaboração.",{"Ok"},3)
	Return Nil
EndIf

If Ascan( aListBox, { | e | e[CTMARCA] == '1' } ) == 0
	MsgAlert(STR0037,STR0046)	// -- "Não existem documentos marcados para solicitar status!", "ATENÇÃO"
	Return
ElseIf Ascan( aListBox, { | e | e[CTSITCTE] <>  '0'} ) == 0
	MsgAlert(STR0038,STR0046)	// -- "Nenhum documento marcado foi transmitido!", "ATENÇÃO"
	Return
Else
	If !MsgYesNo(STR0039)		// -- ""Confirma solicitação de status dos documentos marcados?"
		Return
	EndIf
EndIf

//-- Obtem documentos para transmissao
aDoctosTra := TMS70Doc( aListBox, '2' )

Processa( { |lEnd| TMS70PrSta(aDoctosTra,lEnd) }, , 'Solicitando status dos documentos...', .T. ) 

//-- Retira marca dos documentos autorizados
TMS70Ret(@aListBox)

//-- Realiza refresh no BROWSE
TMS70Rfs(@aListBox, aPerg)

Return( Nil )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TMS70PrSta³ Autor ³ Richard Anderson      ³ Data ³24.08.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de Processamento do status dos Doctos para o TSS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Logico                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Param[1] - Array contendo os doc. da tela.                  ³±±
±±³          ³lExp1    - Controle para interromper o processamento        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/            
Static Function TMS70PrSta(aDoctosTra,lEnd)

Local cDocIni    := ''
Local cDocFin    := ''
Local cSerie     := ''
Local nI         := 0

ProcRegua(Len(aDoctosTra))

For nI := 1 To Len(aDoctosTra)
	IncProc()
	If lEnd
		If MsgYesNo('Deseja interromper o processamento?')
			Exit
		EndIf			
		lEnd := .F.
	EndIf
	cSerie  := aDoctosTra[nI,1]
	cDocIni := aDoctosTra[nI,2]
	cDocFin := aDoctosTra[nI,3]
	//-- Funcao responsavel por solicitar o Status do Doc ao TSS
	Sleep(5000)
	WsCteMnt(cSerie, cDocIni, cDocFin)
Next nI

Return( Nil )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TMSE70LEG ³ Autor ³Andre Godoi            ³ Data ³23.03.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina das Legendas dos Status dos Documentos, no monitor	  ³±±
±±³          ³do Cte                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function TMSE70Leg()

BrwLegenda( STR0002, STR0003,;						//--	"Status do Doc." # "Status"
			 {{'BR_AMARELO'    , STR0004 },;  		//-- Não Transmitido
			  {'BR_VERDE'      , STR0005 },;  		//-- Documento Aguardando
			  {'BR_AZUL'       , STR0006 },;  		//-- Doc. Autorizado
			  {'BR_VERMELHO'   , STR0007 },;  		//-- Doc. Não Autorizado
			  {'BR_PRETO'      , STR0008 }})			//-- Doc. com Falha na Comunicação

Return( Nil )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³TMSATUSTAT ³ Autor ³ Andre Godoi          ³ Data ³18/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualizar Situacao do CTe na tabela de documentos  e a     ³±±
±±³          ³ descricao Campo: (DT6_SITCTE, DT6_RETCTE)                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³TMSJOBSTAT {cFilDoc,cDocMin,cDocMax,cSerie,cStatus}         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Filial do Documento                                  ³±±
±±³          ³ExpC2: Numero do Documento Inicial                          ³±±
±±³          ³ExpC3: Numero do Documento Final                            ³±±
±±³          ³ExpC4: Serie do Documento                                   ³±±
±±³          ³ExpC5: Situacao do Documento                                ³±±
±±³          ³        0 - Nao Transmitido                                 ³±±
±±³          ³        1 - Doc Aguardando                                  ³±±
±±³          ³        2 - Doc Autorizado                                  ³±±
±±³          ³        3 - Doc Nao Autorizado                              ³±±
±±³          ³        4 - Doc em Contingencia                             ³±±
±±³          ³        5 - Doc com Falha na Comunicacao                    ³±±
±±³          ³ExpC6: Descricao do Codigo                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function TMS70AtuSt(cFilDoc,cSerie,cDocMin,cDocMax,cStatus,cDesc)
Local cQuery := ''

Default cDesc := ''

cQuery := " UPDATE " + RetSqlName("DT6") + " SET DT6_SITCTE = '" + cStatus + "' "
If !Empty(cDesc)
	cQuery += " ,DT6_RETCTE = '" + cDesc + "' "
EndIf
cQuery += " WHERE DT6_FILIAL = '" + xFilial("DT6") + "'"
cQuery += "   AND DT6_FILDOC = '" + cFilDoc + "' "
cQuery += "   AND DT6_DOC BETWEEN '" + cDocMin + "' AND '" + cDocMax + "' "
cQuery += "   AND DT6_SERIE  =  '" + cSerie + "' "
cQuery += "   AND DT6_SITCTE <> '2'" 
cQuery += "   AND D_E_L_E_T_ =  ' '"

TCSqlExec( cQuery )
			
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TMS70Psq³  Autor ³ Richard Anderson      ³ Data ³17.08.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Pesquisa documentos no monitor                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TMS70Psq()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TMSAE70                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function TMS70Psq(aListBox)

Local aCbx		:= {}
Local cCampo	:= ''
Local cOrd
Local cData		:= ''
Local lSeek		:= .F.
Local nOrdem	:= 1
Local nSeek		:= 0
Local oCbx
Local oDlg
Local oPsqGet

cCampo := AllTrim(FWX3Titulo('DUD_FILDOC')) + ' + ' + AllTrim(FWX3Titulo('DUD_DOC')) + ' + ' + AllTrim(FWX3Titulo('DUD_SERIE'))
Aadd( aCbx, cCampo )

cCampo := AllTrim(FWX3Titulo('DT6_DATEMI')) 
Aadd( aCbx, cCampo )

cCampo := AllTrim(FWX3Titulo('DTP_LOTNFC')) 
Aadd( aCbx, cCampo )

Aadd( aCbx, 'Marca/Desmarca Doctos.' )

cCampo := AllTrim(FWX3Titulo('DT6_NOMREM')) 
Aadd( aCbx, cCampo )

Aadd( aCbx, 'Impressão do DACTE' )

cCampo := Space( 40 )

DEFINE MSDIALOG oDlg FROM 00,00 TO 100,490 PIXEL TITLE STR0047	// -- "Pesquisa"

@ 05,05 COMBOBOX oCbx VAR cOrd ITEMS aCbx SIZE 206,36 PIXEL OF oDlg ON CHANGE nOrdem := oCbx:nAt

@ 22,05 MSGET oPsqGet VAR cCampo SIZE 206,10 PIXEL 

DEFINE SBUTTON FROM 05,215 TYPE 1 OF oDlg ENABLE ACTION (lSeek := .T.,oDlg:End())
DEFINE SBUTTON FROM 20,215 TYPE 2 OF oDlg ENABLE ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTERED

If lSeek
	cCampo := AllTrim( cCampo )
	If nOrdem == 1
		//-- Fil.Docto + Docto + Serie
		ASort( aListBox,,,{|x,y| x[ CTFILDOC ] + x[ CTDOC ] + x[ CTSERIE ] < y[ CTFILDOC ] + y[ CTDOC ] + y[ CTSERIE ] })
		nSeek := Ascan( aListBox,{ | x | PadR( x[ CTFILDOC ] + x[ CTDOC ] + x[ CTSERIE ], Len( cCampo ) ) == cCampo } )
	ElseIf nOrdem == 2
		//-- Data de Emissao
		ASort( aListBox,,,{|x,y| DtoS(x[ CTDATEMI ]) < DtoS(y[ CTDATEMI ]) } )

		cData := Left( cCampo, 6 )
		cData := DtoS( CtoD(Left(cData,2)+'/'+Subs(cData,3,2)+'/'+Right(cData,2)) )
		
		If Len( cCampo ) > 6
			cCampo := cData + Subs( cCampo, 7, Len( cCampo ) )
		Else
			cCampo := cData
		EndIf
		
		nSeek := Ascan( aListBox,{ | x | PadR( DtoS( x[ CTDATEMI ] ), Len( cCampo ) ) == cCampo  } )
	ElseIf nOrdem == 3
		//-- No.Lote
		ASort( aListBox,,,{|x,y| x[CTLOTNFC] < y[CTLOTNFC] } )
		nSeek := Ascan( aListBox,{ | x | PadR( x[ CTLOTNFC ], Len( cCampo ) ) == cCampo } )

	ElseIf nOrdem == 4
		//-- Marca/Desmarca
		ASort( aListBox,,,{|x,y| x[CTMARCA] < y[CTMARCA] } )
		nSeek := Ascan( aListBox,{ | x | PadR( x[ CTMARCA ], Len( cCampo ) ) == cCampo } )

	ElseIf nOrdem == 5
		//-- Nome do Remetente
		ASort( aListBox,,,{|x,y| x[CTNOMREM] < y[CTNOMREM] } )
		nSeek := Ascan( aListBox,{ | x | PadR( x[ CTNOMREM ], Len( cCampo ) ) == cCampo } )

	ElseIf nOrdem == 6
		//-- Impressao do DACTE
		ASort( aListBox,,,{|x,y| x[CTFIMP  ] < y[CTFIMP  ] } )
		nSeek := Ascan( aListBox,{ | x | PadR( x[ CTFIMP ], Len( cCampo ) ) == cCampo } )

	EndIf
EndIf

If nSeek > 0
	oListBox:nAT := nSeek
	oListBox:Refresh()
EndIf
oListBox:SetFocus()

Return( Nil )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TMS70Vis³  Autor ³ Richard Anderson      ³ Data ³17.08.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Visualiza documentos no monitor                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TMS70Vis()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TMSAE70                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function TMS70Vis(aListBox)

Local aArea := {}

If aListBox[oListBox:nAt,CTDT6REC] > 0 .And. aListBox[oListBox:nAt,CTTIPO] <> 'E'
	aArea := GetArea()
	dbSelectArea('DT6')
	dbGoTo(aListBox[oListBox:nAt,CTDT6REC])
	TMSA500Mnt('DT6',DT6->(Recno()),2)
	RestArea(aArea)
	oListBox:SetFocus()
EndIf	

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TMS70Mrk³  Autor ³ Richard Anderson      ³ Data ³17.08.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marca documentos no listbox                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TMS70Mrk()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TMSAE70                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function TMS70Mrk(aListBox,nItem,lRefresh,lUmItem,lRetMark)

Local nPosMrk := 0
Local nDocMrk := 0

Default nItem   := oListBox:nAt
Default lRefresh:= .T.
Default lUmItem := .T.
Default lRetMark:= .F.

If aListBox[nItem,CTDT6REC] > 0 .And. Iif(lRetMark,.T.,aListBox[nItem,CTSITCTE] <> '2') //-- Doc. Autorizado
	If lUmItem
		aListBox[nItem,CTMARCA] := Iif(aListBox[nItem,CTMARCA] == '1','2','1')
		If(aListBox[nItem,CTMARCA]) == '1'
			nQtdMrk += 1
		ElseIf(aListBox[nItem,CTMARCA]) == '2'
			nQtdMrk -= 1
		EndIf
	Else
		If lAllMark
			aListBox[nItem,CTMARCA] := '1'
			nQtdMrk += 1
		Else
			aListBox[nItem,CTMARCA] := '2'
			nQtdMrk := 0
		EndIf
	EndIf
	nPosMrk := Ascan(aDocMark,{ | e | e[1]+e[2] == aListBox[nItem,CTDOC]+aListBox[nItem,CTSERIE] })
	If nPosMrk == 0
		Aadd(aDocMark,{ aListBox[nItem,CTDOC], aListBox[nItem,CTSERIE], '' })
		nPosMrk := Len(aDocMark)
	EndIf
	aDocMark[nPosMrk,3] := aListBox[nItem,CTMARCA]
	If lRefresh
		oListBox:Refresh()
		oQtdMrk:Refresh()
	EndIf
EndIf

Return( Nil )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TMS70All ³ Autor ³ Richard Anderson      ³ Data ³17.08.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marca/Desmarca todos os documentos                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TMS70All()                                                 ³±±           		
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TMSAE70                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function TMS70All(aListBox)

Local nI      := 0
Local lRefresh:= .T.
Local lUmItem := .F.

CursorWait()
nQtdMrk := 0

For nI := 1 To Len(aListBox)
	TMS70Mrk(aListBox,nI,lRefresh,lUmItem)
Next nI

CursorArrow()

oListBox:Refresh()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TMS70Rfs³  Autor ³ Richard Anderson      ³ Data ³17.08.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Realiza refresh do BROWSE independente do TIMER            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TMS70Rfs()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TMSAE70                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function TMS70Rfs(aListBox, aPerg)

Local bLineBkp := oListBox:bLine

aListBox := {}

TMS70LIST(@aListBox, aPerg)

oListBox:SetArray( aListBox )
oListBox:bLine := bLineBkp
oListBox:Refresh()

	If !Empty(aListBox[1,CTDOC])
		nQtdDoc := Len(aListBox)
	Else
		nQtdDoc := 0
	EndIf
oQtdDoc :Refresh()
oListBox:SetFocus()

Return( Nil )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TMS70Ret³  Autor ³ Richard Anderson      ³ Data ³17.08.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retira marca dos documentos                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TMS70Ret()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TMSAE70                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function TMS70Ret(aListBox)

Local nI       := 0
Local aDoctos  := {}
Local lRefresh := .T.

//-- Retira a marca dos doctos autorizados
aDoctos:= ASort( aListBox,,,{|x,y| x[ CTMARCA ] + x[ CTDOC ] + x[ CTSERIE ] < y[ CTMARCA] + y[ CTDOC ] + y[ CTSERIE ] })
For nI := 1 To Len(aDoctos)
	If aDoctos[nI,CTMARCA] == '2'
		Exit
	EndIf
	If aDoctos[nI,CTSITCTE] == '2' //-- Doc.Autorizado
		TMS70Mrk(aListBox,nI,lRefresh,,.T.)
	EndIf
Next nI

oListBox:Refresh()
oQtdDoc:Refresh()
oQtdMrk:Refresh()

Return( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TMSE70Mon ³ Autor ³Felipe Cunha           ³ Data ³06.08.2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Chama Rotina Monitor e Realiza Refresh no BROWSE            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function TMSE70Mon(aListBox,aPerg)
Local   cDocIni    := ''
Local   cDocFin    := ''
Local   cSerie     := ''
Default aListBox   := {}
Default aPerg      := {}

SpedNFe6Mnt(@cSerie,@cDocIni,@cDocFin,.T.)	//-- "Monitor"
If !lUsaColab
	WsCteMnt(cSerie, cDocIni, cDocFin)		//-- Funcao responsavel por solicitar o Status do Doc ao TSS
EndIf
TMS70Rfs(@aListBox, aPerg) 					//-- "Refresh"

Return Nil
Static Function UsaColaboracao(cModelo)
Local lUsa := .F.

If FindFunction("ColUsaColab")
	lUsa := ColUsaColab(cModelo)
endif
return (lUsa)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ IntegDef ³ Autor ³ Valdemar Roberto   ³ Data ³ 09/12/2016  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Integração via Mensagem Única                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ IntegDef(cExp01,nExp01,cExp02)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Variavel com conteudo xml para envio/recebimento  ³±±
±±³          ³ nExp01 - Tipo de transacao (Envio/Recebimento)             ³±±
±±³          ³ cExp02 - Tipo de mensagem (Business Type, WhoIs, Etc)      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TMSAE70                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IntegDef(cXML,nTypeTrans,cTypeMessage)
Local aRet := {}

aRet := TMSIE70(cXML,nTypeTrans,cTypeMessage)

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ModelDef   ³ Autor ³ Valdemar Roberto  ³ Data ³ 06.01.2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Define modelo para visualizar envio EAI em MVC             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ModelDef()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ModelDef()
Local oModel   := Nil
Local oStruCab := MkStrMdCab()
Local oStruDJQ := MkStrMdDJQ()

oModel := MPFormModel():New("TMSAE70",/*bPre*/,/*bPos*/,{|| CommitDJQ()},/*bCancel*/)
oModel:SetDescription("Lista de Documentos") //-- "Lista de Documentos"

//-- Campos dos documentos
oModel:AddFields("MdFieldCab",/*cOwner*/,oStruCab,/*bPre*/,/*bPost*/,{||})
oModel:GetModel("MdFieldCab"):SetDescription("Lista de Documentos") //-- "Lista de Documentos"
oModel:SetPrimaryKey({"DJQ_FILIAL","DJQ_ALIAS","DJQ_INDICE","DJQ_CONTEU","DJQ_CODOPE","DTOS(DJQ_DATENV)","DJQ_HORENV"})

oModel:AddGrid("MdGridDJQ","MdFieldCab",oStruDJQ, /* bLinePre */,/* nLinePost */,/*bPre*/,/*bPos*/,{|x| LoadDJQ(x)}/*BLoad*/)
oModel:GetModel("MdGridDJQ"):SetDescription("Lista de Documentos") //-- 
oModel:GetModel("MdGridDJQ"):SetUseOldGrid(.F.)

oModel:SetRelation("MdGridDJQ",{{"DJQ_FILIAL","xFilial('DJQ')"},{"DJQ_ALIAS","'SF3'"}},DJQ->(IndexKey(1)))
oModel:GetModel("MdGridDJQ"):SetNoInsertLine(.T.)
oModel:GetModel("MdGridDJQ"):SetNoDeleteLine(.T.)

Return oModel

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ViewDef    ³ Autor ³ Valdemar Roberto  ³ Data ³ 06.01.2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Define tela para visualizar envio EAI em MVC               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ViewDef()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ViewDef()
Local oModel   := FwLoadModel("TMSAE70")
Local oView    := Nil
Local oStruCab := MkStrVwCab()
Local oStruDJQ := MkStrVwDJQ()

oStruDJQ:SetProperty("*",MVC_VIEW_CANCHANGE,.F.)

oView := FwFormView():New()
oView:SetModel(oModel)

oView:CreateHorizontalBox("Superior",15)
oView:CreateHorizontalBox("Inferior",85)

oView:AddField("VwFieldCab",oStruCab,"MdFieldCab")

oView:AddGrid("VwGridDJQ",oStruDJQ,"MdGridDJQ")

oView:SetOwnerView("VwFieldCab","Superior")

oView:SetOwnerView("VwGridDJQ","Inferior")

oView:SetViewAction("ASKONCANCELSHOW",{|| .F.})
oView:ShowUpdateMsg(.F.)
oView:ShowInsertMsg(.F.)
oView:SetViewAction("BUTTONOK",{|oView| Envia(oView)})

//-- Define rotina de ação do botão marca/desmarca todos
oView:SetFieldAction("MRK_DES",{|oView,cIdForm,cIdCampo,cValue| MarcaTudo(oView,cIdForm,cIdCampo,cValue)})

//-- Define ação no duplo click
oView:SetViewProperty("VwGridDJQ","GRIDDOUBLECLICK",{{|oGrdView,cFieldName,nLineGrid,nLineModel| MarcaReg(oGrdView,cFieldName,nLineGrid,nLineModel)}})

Return oView

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MkStrMdCab ³ Autor ³ Valdemar Roberto  ³ Data ³ 06.01.2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Define estrutura do cabeçalho para a model                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MkStrMdCab()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MkStrMdCab()
Local oRet := FWFormModelStruct():New()

oRet:AddField("STR0067","STR0067","MRK_DES","L",1,0,,,{},.F.,{|| .F.},,,.T.)

Return oRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MkStrMdDJQ ³ Autor ³ Valdemar Roberto  ³ Data ³ 06.01.2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Define estrutura da tabela de DJQ para a model             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MkStrMdDJQ()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MkStrMdDJQ()
Local oRet := FWFormModelStruct():New()

oRet:AddTable("DJQ",{"DJQ_FILIAL","DJQ_ALIAS","DJQ_INDICE","DJQ_CONTEU","DJR_CODOPE"},"Lista de Documentos")	//-- "Lista de Documentos"

oRet:AddField(""     ,""     ,"MRKDOC"    ,"L",1,0,,,{},.F.,{|| .F.},,,.T.)
oRet:AddField("STR0060","STR0060","FILDOC"    ,"C",TamSX3("DT6_FILDOC")[1],0,,,,,,,,.T.,)
oRet:AddField("STR0061","STR0061","DOC"       ,"C",TamSX3("DT6_DOC")[1]   ,0,,,,,,,,.T.,)
oRet:AddField("STR0062","STR0062","SERIE"     ,"C",TamSX3("DT6_SERIE")[1] ,0,,,,,,,,.T.,)
oRet:AddField("STR0063","STR0063","DJR_DATENV","D",TamSX3("DJR_DATENV")[1],0,,,,,,,,,)
oRet:AddField("STR0064","STR0064","DJR_HORENV","C",TamSX3("DJR_HORENV")[1],0,,,,,,,,,)
oRet:AddField("STR0065","STR0065","DJR_CODOPE","C",TamSX3("DJR_CODOPE")[1],0,,,,,,,,,)
oRet:AddField("STR0068","STR0068","DJR_CODSEF","C",TamSX3("DJR_CODSEF")[1],0,,,,,,,,,)
oRet:AddField("STR0066","STR0066","NOMUSU"    ,"C",TamSX3("A1_NOME")[1]   ,0,,,,,,,,.T.,)

oRet:AddIndex(1,;																					//-- [01] Ordem do indice
			  "1",;																					//-- [02] ID
			  "DJQ_FILIAL+DJQ_ALIAS+DJQ_INDICE+DJQ_CONTEU+DJR_CODOPE+DTOS(DJR_DATENV)+DJR_HORENV",;	//-- [03] Chave do indice
			  "Filial+Alias+Indice+Conteudo+Cod Ope+Dat Env+Hor Env",;								//-- [04] Descrição do indice
			  "",;																					//-- [05] Expressão de lookUp dos campos de indice
			  "",;																					//-- [06] Nickname do indice
			  .T.)																					//-- [07] Indica se o indice pode ser utilizado pela interface   

Return oRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MkStrVwCab ³ Autor ³ Valdemar Roberto  ³ Data ³ 06.01.2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Define estrutura do cabeçalho para a view                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MkStrVwCab()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MkStrVwCab()
Local oRet := FWFormViewStruct():New()

oRet:AddField("MRK_DES","01","STR0067","STR0067",{" "},"L","",,"",.T.,,,{ },,,.T.,)

Return oRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MkStrVwDJQ ³ Autor ³ Valdemar Roberto  ³ Data ³ 06.01.2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Define estrutura da tabela DJQ para a view                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MkStrVwDJQ()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MkStrVwDJQ()
Local oRet := FWFormViewStruct():New()

oRet:AddField("MRKDOC"    ,"01","","",{" "},"L","",,"",.T.,,,{ },,,.T.,)
oRet:AddField("FILDOC"    ,"02","STR0060","STR0060",,'G',,,,,,,,,,)
oRet:AddField("DOC"       ,"03","STR0061","STR0061",,'G',,,,,,,,,,)
oRet:AddField("SERIE"     ,"04","STR0062","STR0062",,'G',,,,,,,,,,)
oRet:AddField("DJR_DATENV","05","STR0063","STR0063",,'G',,,,,,,,,,)
oRet:AddField("DJR_HORENV","06","STR0064","STR0064",,'G',"99:99:99",,,,,,,,,)
oRet:AddField("DJR_CODOPE","07","STR0065","STR0065",,'G',,,,,,,,,,)
oRet:AddField("DJR_CODSEF","07","STR0068","STR0068",,'G',,,,,,,,,,)
oRet:AddField("NOMUSU"    ,"08","STR0066","STR0066",,'G',,,,,,,,,,)

Return oRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ LoadDJQ    ³ Autor ³ Valdemar Roberto  ³ Data ³ 09.01.2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Carrega grid dos documentos                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ LoadDJQ()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function LoadDJQ()
Local aAreas    := {GetArea()}
Local aInfoUser := {}
Local aRet      := {}
Local cQuery    := ""
Local cAliasDJR := ""
Local cOperac   := ""
Local cComando  := ""
Local cDbType   := TCGetDB()
Local cRegAnt   := ""
Local nLinha    := 0

If MV_PAR09 == 1
	cOperac := "Autenticacao"
ElseIf MV_PAR09 == 2
	cOperac := "Inutilizacao"
ElseIf MV_PAR09 == 3
	cOperac := "Cancelamento"
EndIf

If cDbType $ "MSSQL|MSSQL7|POSTGRES"
	cComando := "SUBSTRING"
ElseIf cDbType $ "ORACLE|DB2|INFORMIX"
	cComando := "SUBSTR"
EndIf

cAliasDJR := GetNextAlias()
cQuery := "SELECT DJR_CONTEU,DJR_CODOPE,DJR_DATENV,DJR_HORENV,DJR_CODSEF,DJR_USUENV "
cQuery += "  FROM " + RetSqlName("DJR") + " DJR "

cQuery += " WHERE DJR_FILIAL = '" + FwxFilial("DJR") + "' "
cQuery += "   AND DJR_ALIAS  = 'SF3' "
cQuery += "   AND DJR_INDICE = '6' "
cQuery += "   AND " + cComando + "(DJR_CONTEU,1," + AllTrim(Str(TamSX3("DT6_FILDOC")[1])) + ") BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
cQuery += "   AND " + cComando + "(DJR_CONTEU," + AllTrim(Str(TamSX3("DT6_FILDOC")[1] + 1)) + "," + AllTrim(Str(TamSX3("DT6_DOC")[1])) + ") BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
cQuery += "   AND " + cComando + "(DJR_CONTEU," + AllTrim(Str(TamSX3("DT6_FILDOC")[1] + TamSX3("DT6_DOC")[1] + 1)) + "," + AllTrim(Str(TamSX3("DT6_SERIE")[1])) + ") BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
cQuery += "   AND DJR_DATENV BETWEEN '" + DToS(MV_PAR01) + "' AND '" + DToS(MV_PAR02) + "' "
If MV_PAR09 != 4
	cQuery += "   AND DJR_CODOPE  = '" + cOperac + "' "
EndIf
cQuery += "   AND DJR.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY DJR_CONTEU,DJR_CODOPE,DJR_DATENV,DJR_HORENV"

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasDJR,.T.,.T.)

TCSetField(cAliasDJR,"DJR_DATENV","D",TamSx3("DJR_DATENV")[1],TamSx3("DJR_DATENV")[2])

PswOrder(1)

While (cAliasDJR)->(!Eof())
	cRegAnt := (cAliasDJR)->DJR_CONTEU + (cAliasDJR)->DJR_CODOPE

	nLinha ++
	Aadd(aRet,{nLinha,Array(9)})
	aRet[nLinha,2,1] := .F.
	aRet[nLinha,2,2] := SubStr((cAliasDJR)->DJR_CONTEU,1,Len(DT6->DT6_FILDOC))
	aRet[nLinha,2,3] := SubStr((cAliasDJR)->DJR_CONTEU,Len(DT6->DT6_FILDOC) + 1,Len(DT6->DT6_DOC))
	aRet[nLinha,2,4] := SubStr((cAliasDJR)->DJR_CONTEU,Len(DT6->DT6_FILDOC) + Len(DT6->DT6_DOC) + 1,Len(DT6->DT6_SERIE))
	
	While (cAliasDJR)->(!Eof()) .And. (cAliasDJR)->DJR_CONTEU + (cAliasDJR)->DJR_CODOPE == cRegAnt
		aRet[nLinha,2,5] := (cAliasDJR)->DJR_DATENV
		aRet[nLinha,2,6] := (cAliasDJR)->DJR_HORENV
		aRet[nLinha,2,7] := (cAliasDJR)->DJR_CODOPE
		aRet[nLinha,2,8] := (cAliasDJR)->DJR_CODSEF
		aRet[nLinha,2,9] := UsrRetName((cAliasDJR)->DJR_USUENV)
	
		(cAliasDJR)->(DbSkip())
	EndDo
EndDo

(cAliasDJR)->(DbCloseArea())

AEval(aAreas,{|x,y| RestArea(x)})

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MarcaReg  ³ Autor ³ Valdemar Roberto     ³ Data ³ 10.01.2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Marca/Desmarca um registro                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MarcaReg(oExp01,cExp01,nExp01,nExp02)                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 := Grid view                                          ³±±
±±³          ³ cExp01 := Nome do campo                                      ³±±
±±³          ³ nExp01 := Linha do grid                                      ³±±
±±³          ³ nExp02 := Linha da model                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MarcaReg(oGrdView,cFieldName,nLineGrid,nLineModel)
Local oModel  := FwModelActive()
Local oView   := FwViewActive()
Local oMdlDJQ := oView:GetModel("MdGridDJQ")
Local lMarca  := .T.

DEFAULT oGrdView   := Nil
DEFAULT cFieldName := ""
DEFAULT nLineGrid  := 0
DEFAULT nLineModel := 0

lMarca := oMdlDJQ:GetValue("MRKDOC")

oMdlDJQ:LoadValue("MRKDOC",Iif(lMarca,.F.,.T.))

oView:Refresh("VwGridDJQ")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MarcaTudo ³ Autor ³ Valdemar Roberto     ³ Data ³ 10.01.2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Marca/Desmarca todos os registros                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MarcaTudo(oExp01,cExp01,cExp02,cExp03)                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 := Objeto view                                        ³±±
±±³          ³ cExp01 := Nome do formulário                                 ³±±
±±³          ³ cExp02 := Nome do campo                                      ³±±
±±³          ³ cExp03 := Conteúdo do campo                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MarcaTudo(oView,cIdForm,cIdCampo,cValue)
Local oModel   := FwModelActive()
Local oView    := FwViewActive()
Local oMdlDJQ  := oView:GetModel("MdGridDJQ")
Local nCntFor1 := 0
Local nQtdLin  := 0

DEFAULT oView    := Nil
DEFAULT cIdForm  := ""
DEFAULT cIdCampo := ""
DEFAULT cValue   := ""

nQtdLin := oMdlDJQ:Length()

For nCntFor1 := 1 To nQtdLin
	oMdlDJQ:GoLine(nCntFor1)
	oMdlDJQ:LoadValue("MRKDOC",cValue)
Next nCntFor1

oMdlDJQ:GoLine(1)

oView:Refresh("VwGridDJQ")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Envia     ³ Autor ³ Valdemar Roberto     ³ Data ³ 10.01.2017 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envia os documentos ao EAI                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Envia(oExp01)                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oExp01 := Objeto view                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Envia(oView)
Local aAreas   := {SF3->(GetArea()),GetArea()}
Local nCntFor1 := 0
Local nQtdLin  := 0
Local cFilDoc  := ""
Local cDoc     := ""
Local cSerie   := ""
Local cCodRSEF := ""
Local oModel   := FwModelActive()
Local oViewTst := FwViewActive()
Local oMdlDJQ

DEFAULT oView := Nil

oMdlDJQ := oView:GetModel("MdGridDJQ")

SF3->(dbSetOrder(5))

nQtdLin := oMdlDJQ:Length()

For nCntFor1 := 1 To nQtdLin
	oMdlDJQ:GoLine(nCntFor1)
	If oMdlDJQ:GetValue("MRKDOC")
		cFilDoc  := oMdlDJQ:GetValue("FILDOC")
		cDoc     := oMdlDJQ:GetValue("DOC")
		cSerie   := oMdlDJQ:GetValue("SERIE")
		cCodRSEF := oMdlDJQ:GetValue("DJR_CODSEF")
		If SF3->(MsSeek(cFilDoc + cSerie + cDoc,.T.))
			TMSAE76(.T.,cCodRSEF)
		EndIf
	EndIf
Next nCntFor1

AEval(aAreas,{|x,y| RestArea(x)})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CommitDJQ  ³ Autor ³ Valdemar Roberto ³ Data ³ 03/02/2017  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gravação do registro                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CommitDJQ()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TMSAE77                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CommitDJQ()
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ retStaSef  ³ Fabio Marchiori Sampaio³ Data ³ 03/02/2017  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gravação do registro                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ retStaSef()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TMSAE77                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function retStaSef(aListBox,aPerg)

Local aDoctos		:= {}
Local aAreaDT6		:= {}
Local aAreaSF3		:= {}
Local nI			:= 0
Local lUsaColab		:= UsaColaboracao("2")
Local aRejCanc		:= {}
Local nX			:= {}
//Rejeição para os eventos de cancelamento do CT-e. Descrição das rejeições disponíveis no manual da SEFAZ CTe 3.0 páginas 107/108
aadd(aRejCanc, {"249","636","203","240","205","218","220","698","222","219","564","574","575","576","660","523","528"})

aAreaSF3 := SF3->(GetArea())
aAreaDT6 := DT6->(GetArea())

//-- Fil.Docto + Docto + Serie
aDoctos := AClone(aListBox)
ASort( aDoctos,,,{|x,y| x[ CTMARCA ] + x[ CTDOC ] + x[ CTSERIE ] < y[ CTMARCA] + y[ CTDOC ] + y[ CTSERIE ] })
For nI := 1 To Len(aDoctos)
	If aDoctos[nI,CTMARCA] == '2'
		Exit
	EndIf

	dbSelectArea("DT6")
	DT6->(dbSetOrder(1)) //DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE
	If DT6->(dbSeek(xFilial("DT6")+aDoctos[nI,CTFILDOC ]+aDoctos[nI,CTDOC]+aDoctos[nI,CTSERIE ]))
		If !Empty(DT6->DT6_IDRCTE)
			For nX := 1 To Len(aRejCanc[1])
				If DT6->DT6_IDRCTE = aRejCanc[1][nX]
					If MsgYesNo("Você tem certeza? Isso poderá afetar cobranças e processos fiscais de sua empresa, retornar o status do CT-e para autorizado?") // 
						RecLock("DT6",.F.)
						//Volta Status CT-e
						DT6->DT6_IDRCTE := '100'
						If !lUsaColab
							DT6->DT6_RETCTE := '100 - Autorizado o uso do CT-e'
							DT6_SITCTE  	:= '2'
							DT6->DT6_STATUS := '1'
						Else
							DT6->DT6_RETCTE := '001 - Emissão de DACTE autorizada'
							DT6_SITCTE  	:= '2'
							DT6->DT6_STATUS := '1'
						EndIf
						DT6->(MsUnLock())
						//Volta Status Livro Fiscal
						dbSelectArea("SF3")
						SF3->(DbSetOrder(4)) //F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE
						If	SF3->(DbSeek(xFilial("SF3")+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV+DT6->DT6_DOC+DT6->DT6_SERIE))
							RecLock("SF3",.F.)
							SF3->F3_DTCANC  := stod('')
							SF3->F3_DESCRET := 'Autorizado o uso do CT-e'
							SF3->F3_CODRSEF := '100'
							MsUnlock()
						EndIf
					TMS70Rfs(@aListBox,aPerg)
					EndIf
					Exit
				EndIf
			Next nX
		Else
			MsgAlert('Essa rejeição não pode ser retornada, verifique o CT-e, e o retransmita !!') //
		EndIf
	EndIf

Next nI

RestArea(aAreaSF3)
RestArea(aAreaDT6)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ GetFiltroF3  ³ Alex Amaral            ³ Data ³ 02/05/2019  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Filtra tabela SF3 para atualizar as inutilizações          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FiltroF3()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TMSAE70                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FiltroSF3(aParam)

Local cAliasQry	:=	""
Local cQuery  	:= 	""

Default aParam   := {"","",""}

cQuery := "SELECT MIN(F3_NFISCAL || F3_SERIE) AS MINIMO, MAX(F3_NFISCAL || F3_SERIE) AS MAXIMO FROM " + RetSqlName("SF3") + " SF3 "
cQuery += " WHERE SF3.D_E_L_E_T_= ' ' AND SF3.F3_EMISSAO = '"+ DtoS(dDataBase) + "' AND "
cQuery += " SF3.F3_FILIAL  = '" + xFilial("SF3") + "'"
cQuery += " AND ( SF3.F3_ESPECIE <> 'SPED' AND SF3.F3_CODRSEF NOT IN ( '101','102','151','155', '220') "
cQuery += " OR (SF3.F3_ESPECIE = 'SPED'  AND SF3.F3_CODRSEF NOT IN ( '110','205','301','302')) )" 
		
cAliasQry := GetNextAlias()
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .T.)

If (cAliasQry)->(!Eof())
	aParam[01] := Substr((cAliasQry)->MINIMO, TamSX3("F3_NFISCAL")[1]+ 1, TamSX3("F3_SERIE")[1]) //Serie
	aParam[02] := Substr((cAliasQry)->MINIMO, 1, TamSX3("F3_NFISCAL")[1]) //Numero NF	
	aParam[03] := Substr((cAliasQry)->MAXIMO, 1, TamSX3("F3_NFISCAL")[1])
EndIf

(cAliasQry)->( DbCloseArea() )

Return (aParam)
