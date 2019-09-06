#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#DEFINE _ENTER CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ PA0201   ³ Autor ³ Alexandro da Silva    ³ Data ³ 15/02/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Aglutinacao de Ordens de Producao                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Estoque / PCP                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PA0201()

Local oDlg
Local oUsado
Local cSavAlias   := Alias()
Local nPeriodo    := 6
Local aStru       := {}
Local aTam        := {}
Local cPerg       := "PA0201"
Local cTexto      := ""
Local aInfoProc   := {}
Private cCadastro := OemToAnsi("Aglutina OPs")
Private nRegiao   := 1
Private aTipo     := {}
Private aGrupo    := {}
Private aOpcoes[5][6]
Private nNivel    := 1
Private aPeriodos := {}
Private cMarca    := GetMark()
Private nUsado    := 1
nTipo             := 6

ATUSX1()

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                            ³
//³ mv_par01        	// Da OP                                    ³
//³ mv_par02        	// Ate a OP                                 ³
//³ mv_par03        	// Entrega De                               ³
//³ mv_par04        	// Entrega At                               ³
//³ mv_par05        	// Emissao De                               ³
//³ mv_par06        	// Emissao Ate                              ³
//³ mv_par07        	// De Produto                               ³
//³ mv_par08        	// Ate Produto                              ³
//³ mv_par09        	// De Almoxarifado                          ³
//³ mv_par10        	// Ate Almoxarifado                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_nOpc := 0

@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Aglutina OPs")
@ 02,10 TO 080,220

@ 10,18 SAY "Este programa permite que as ordens de produ‡„o de"  SIZE 130,7
@ 18,18 SAY "um mesmo produto sejam aglutinadas conforme os"      SIZE 130,7
@ 26,18 SAY "per¡odos definidos ao lado."                         SIZE 130,7
@ 34,18 SAY "                                               "     SIZE 130,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0201")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	Private _cMsg01    := ''
	Private _lFim      := .F.
	Private _lAborta01 := .T.
	Private _bAcao01       := {|_lFim| PA201_01(@_lFim) }
	Private _cTitulo01 := 'Processando!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PA201_02  ³ Autor ³ Ary Medeiros          ³ Data ³ 02/06/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa a aglutinacao das Ordens de Producao              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA720                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PA201_02(nTipo)

Local cProduto  := ""
Local cRoteiro  := ""
Local cOpcional := ""
Local dData     := CtoD('  /  /  ')
Local cIndex    := ""
Local cKey      := ""
Local cCond     := ""
Local cTpOP     := ""
Local lAglut    := .T.
Local nOrdem    := 0
Local nRec      := 0
Local nIndex    := 0
Local dDataIni  := CtoD('  /  /  ')
Local dDataFim  := CtoD('  /  /  ')
Local cSeqPai   := ""
Local cCompara  := ""
Local cCampos   := ""
Local nRecSC2   := 0
Local nOrderSC2 := 0
Local nRecTRB   := 0
Local cProdPai  := ""
Local cNumOp    := ""
Local cDescric  := ""
Local cFil720   := ""

dbSelectArea("SD4")
dbSetOrder(4)

cIndex := CriaTrab(nil,.f.)
dbSelectArea("SC2")
cKey :="C2_FILIAL+C2_TPOP+C2_PRODUTO+C2_ROTEIRO+C2_OPC+DTOS(C2_DATPRF)"

cCond:= 'DTOS(C2_DATRF) == "        " .and. C2_QUJE == 0 .and. C2_PERDA == 0 .and. '
cCond+= 'DTOS(C2_DATPRF) >= "'+DtoS(mv_par03)+ '" .and. DTOS(C2_DATPRF)  <= "'+DtoS(mv_par04)+'" .and. '
cCond+= 'DTOS(C2_EMISSAO)>= "'+DtoS(mv_par05)+ '" .and. DTOS(C2_EMISSAO) <= "'+DtoS(mv_par06)+'" .and. '
cCond+= 'C2_LOCAL  >="'+mv_par09+'".and.C2_LOCAL   <="'+mv_par10+'" .and. '
cCond+= 'C2_PRODUTO>="'+mv_par07+'".and.C2_PRODUTO<="'+mv_par08+'"'

IndRegua("SC2",cIndex,cKey,,cCond,"Selecionando Registros...")
nIndex := RetIndex("SC2")

dbSetOrder(nIndex+1)
dbSeek(xFilial("SC2"))

ProcRegua(SC2->(LastRec()))

lSkip := .F.

While !Eof() .And. SC2->C2_FILIAL == xFilial("SC2")
	cProduto := SC2->C2_PRODUTO
	cRoteiro := SC2->C2_ROTEIRO
	cOpcional:= SC2->C2_OPC
	cTpOp    := SC2->C2_TPOP
	cSeqPai	 := SC2->C2_SEQPAI
	dDataIni := CtoD('  /  /  ')
	dDataFim := CtoD('  /  /  ')
	cDescric := ""
	cCampos  := "C2_FILIAL+C2_TPOP+C2_PRODUTO+C2_ROTEIRO+C2_OPC"
	cCompara := xFilial("SC2")+cTpOp+cProduto+cRoteiro+cOpcional
	
	While SC2->(!Eof()) .And. cCompara == &(cCampos)
		
		IncProc()
		
		If SC2->C2_NUM = "008499"
			_lParar := .T.
		Endif
		
		SB1->(dbSetorder(1))
		If SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
			If !Alltrim(SB1->B1_GRUPO) $ "PIC"
				dbSelectArea("SC2")
				dbSkip()
				Loop
			Endif
		Endif
		
		lAglut:=.T.
		
		dbSelectArea("SD3")
		dbSetOrder(1)
		dbSeek(xFilial("SD3")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
		While !Eof() .And. SD3->(D3_FILIAL+D3_OP) == xFilial("SD3")+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)
			If SD3->D3_ESTORNO <> "S"
				lAglut:=.F.
				Exit
			EndIf
			dbSkip()
		EndDo
		
		If lAglut
			dbSelectArea("SH6")
			dbSetOrder(1)
			If dbSeek(xFilial("SH6")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
				lAglut:=.F.
			EndIf
		EndIf
		dbSelectArea("SC2")
		If !lAglut
			dbSkip()
			Loop
		EndIf
		dData    := SC2->C2_DATPRF
		nOrdem   := 1
		dDataIni := CtoD('  /  /  ')
		dDataFim := CtoD('  /  /  ')
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se existe outra OP a ser aglutinada, para nao      ³
		//³ aglutinar OP de 1 para 1                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nRec := SC2->( RecNo() )
		SC2->( dbSkip() )
		If !(A720Periodo(dData,SC2->C2_DATPRF,nTipo) .And. cCompara == &(cCampos) .And. SC2->C2_AGLUT $ "S " .And.;
			(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD >= mv_par01 .And. SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD <= mv_par02))
			Loop
		EndIf
		lAglut:=.T.
		dbSelectArea("SD3")
		dbSetOrder(1)
		dbSeek(xFilial("SD3")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
		While !Eof() .And. D3_FILIAL+D3_OP == xFilial("SD3")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
			If SD3->D3_ESTORNO <> "S"
				lAglut:=.F.
				Exit
			EndIf
			dbSkip()
		End
		If lAglut
			dbSelectArea("SH6")
			dbSetOrder(1)
			If dbSeek(xFilial("SH6")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
				lAglut:=.F.
			EndIf
		EndIf
		dbSelectArea("SC2")
		If !lAglut
			dbSkip()
			Loop
		Else
			dbGoto(nRec)
		EndIf
		While A720Periodo(dData,SC2->C2_DATPRF,nTipo) .And. SC2->C2_FILIAL == xFilial("SC2") .And. SC2->C2_AGLUT $ "S "
			
			lAglut:=.T.
			dbSelectArea("SD3")
			dbSetOrder(1)
			dbSeek(xFilial("SD3")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
			While !Eof() .And. D3_FILIAL+D3_OP == xFilial("SD3")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
				If SD3->D3_ESTORNO <> "S"
					lAglut:=.F.
					Exit
				EndIf
				dbSkip()
			End
			If lAglut
				dbSelectArea("SH6")
				dbSetOrder(1)
				If dbSeek(xFilial("SH6")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
					lAglut:=.F.
				EndIf
			EndIf
			dbSelectArea("SC2")
			If !lAglut
				dbSkip()
				Loop
			EndIf
			// Menor data prevista de inicio
			If Empty(dDataIni)
				dDataIni := SC2->C2_DATPRI
			ElseIf !Empty(dDataIni) .And. SC2->C2_DATPRI < dDataIni
				dDataIni := SC2->C2_DATPRI
			EndIf
			// Maior data prevista de fim
			If Empty(dDataFim)
				dDataFim := SC2->C2_DATPRF
			ElseIf !Empty(dDataFim) .And. SC2->C2_DATPRF > dDataFim
				dDataFim := SC2->C2_DATPRF
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Filtro das Ops (De ... Ate)                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD) >= mv_par01 .And. SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD) <= mv_par02
				If SB1->(dbSeek(xFilial("SB1")+cProduto))
					cDescric := Left(SB1->B1_DESC,30)
				EndIf
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				Replace MARK      With cMarca
				Replace NUMOP     With SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD
				Replace PRODUTO   With SC2->C2_PRODUTO
				Replace DESCRICAO With cDescric
				Replace QUANT     With SC2->C2_QUANT
				Replace INICIO    With dDataIni
				Replace ENTREGA   With dDataFim
				Replace ORDEM     With nOrdem++
				Replace ROTEIRO   With cRoteiro
				Replace GRADE     With SC2->C2_GRADE
				Replace ITEMGRD   With SC2->C2_ITEMGRD
				Replace OPCIONAL  With cOpcional
				Replace TPOP      With cTpOp
				Replace SEQPAI    With If(Val(SC2->C2_SEQPAI)==0,"",SC2->C2_SEQPAI)
				Replace REFGRD	  With SB1->B1_GRADE
				MsUnlock()
			EndIf
			dbSelectArea("SC2")
			dbSkip()
			lSkip := .T.
			If !(cCompara == &(cCampos))
				Exit
			EndIf
		End
		If !lSkip
			dbSkip()
		EndIf
		lSkip := .f.
	End
End

dbSelectArea("SC2")
RetIndex("SC2")
dbClearFilter()
Ferase(cIndex+OrdBagExt())

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A720Periodo³ Autor ³ Ary Medeiros          ³ Data ³ 02/06/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se as OPS estao no periodo p/ aglutinacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA720                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function A720Periodo(dDatRef,dData,nTipo)
LOCAL lRet := .f., nMes
Do Case
	Case nTipo == 1 // Diario
		If dDatRef == dData
			lRet := .T.
		EndIf
	Case nTipo == 2 // Semanal
		While Dow(dDatRef) != 2
			dDatRef--
		End
		If dData < dDatRef + 7
			lRet := .T.
		EndIf
	Case nTipo == 3 // Quinzenal
		If Month(dDatRef) == Month(dData)
			If Day(dDatRef) <=15
				If Day(dData) <= 15
					lRet := .T.
				EndIf
			Else
				If Day(dData) > 15
					lRet := .T.
				EndIf
			EndIf
		EndIf
	Case nTipo == 4 // Mensal
		If Month(dDatRef) == Month(dData)
			lRet := .T.
		EndIf
	Case nTipo == 5 // Trimestral
		nRef := Month(dDatRef)
		nMes := Month(dData)
		If Year(dData)-Year(dDatRef)==1
			If nRef >=11 .And. nMes <= 2
				lRet := .T.
			EndIf
		ElseIf nRef >=1 .and. nRef <= 3
			If nMes >= 1 .and. nMes <= 3
				lRet := .T.
			EndIf
		ElseIf nRef >=4 .and. nRef <= 6
			If nMes >=4 .and. nMes <= 6
				lRet := .T.
			EndIf
		ElseIf nRef >=7 .and. nRef <= 9
			If nMes >=7 .and. nMes <= 9
				lRet := .T.
			EndIf
		ElseIf nRef >=10 .and. nRef <= 12
			If nMes >=10 .and. nMes <= 12
				lRet := .T.
			EndIf
		EndIf
	Case nTipo == 6 // Semestral
		If Year(dData)-Year(dDatRef)==1
			If Month(dData)<=6 .And. Month(dDatRef) >=6
				lRet := .t.
			EndIf
		ElseIf Month(dDatRef) <= 6
			If Month(dData) <= 6
				lRet := .t.
			EndIf
		Else
			If Month(dData) > 6
				lRet := .t.
			EndIf
		EndIf
EndCase
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PA201_03   ³ Autor ³ Ary Medeiros          ³ Data ³ 02/06/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Mostra o Browse para marcacao das OPs                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³oTNewProc = Objeto tNewProcess()                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA720                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PA201_03(oTNewProc)

Local oDlg
Local lCont    := .T.
Local lInverte := .F.
Local nOpca    := 0
Private inclui := .T.

dbSelectArea("TRB")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Redefinicao do aCampos para utilisar no MarkBrow             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos := { 	{"MARK"     ,"A720Marca","Ok"},;
{"NUMOP"    ,"A720Marca","Ordem de Producao"},;
{"PRODUTO"  ,"A720Marca","Produto"},;
{"DESCRICAO","A720Marca","Descricao do Produto"},;
{"QUANT"    ,"A720Marca","Quantidade"}}

dbGotop()
If Bof() .and. Eof()
	Help(" ",1,"RECNO")
	lCont := .F.
Else
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Sele‡„o das OPs") From 9,0 To 28,80 OF oMainWnd
	cAlias:=Alias()
	oMark := MsSelect():New(cAlias,"MARK",,aCampos,@linverte,cMarca,{35,1,143,315})
	oMark:oBrowse:lCanAllMark:=.T.
	oMark:oBrowse:lHasMark	 :=.T.
	oMark:bMark 			 := {| | A720ESCOL(cMarca,@lInverte,@oDlg)}
	oMark:oBrowse:bAllMark	 := {| | A720MarkAll(cMarca,@oDlg)}
	oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nopca:=1,If(MTA720OK(),oDlg:End(),)},{||nopca:=0,oDlg:End()})
EndIf
If lCont .And. nOpca == 1
	PA201_04(oTNewProc)
	Processa({|| A720Make()},cCadastro,OemToAnsi("Aglutinando OPs Selecionadas..."),.F.)
EndIf

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PA201_04      ³ Autor ³ Larson Zordan     ³ Data ³ 10/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera NumOPs das OPs Selecionadas                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³oTNewProc = Objeto tNewProcess()                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA720                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PA201_04(oTNewProc)

Local cNovaOpPai := ""
Local cNovaSeq   := ""
Local cRefGrd    := ""
Local lNovoItem  := .F.
Local nx         := 0
Local nIG        := 0
Local lNumOpIni  := .F.
Local nOrd       := 0
Local nAglutItem := 1
Local nAglutIGrd := 1
Local cAglutSeq  := "001"
Local cAglutIGrd := StrZero(nAglutIGrd,Len(SC2->C2_ITEMGRD))
Local lComp      := .F.
Local cAglutNum  := ""

nx  := Val(Left(GETMV("MV_MASCGRD",.F.),2))
nIG := Len(TRB->ITEMGRD)

dbSelectArea("TRB")
dbSetOrder(2)
dbGoTop()

ProcRegua(TRB->(LastRec()))


While !Eof()
	
	IncProc()
	
	SC2->( dbSetOrder(1) )
	SC2->( MsSeek(xFilial("SC2")+cAglutNum) )
	If Empty(cAglutNum) .Or. SC2->( Found() )
		nAglutItem := 1
		cAglutNum  := GetNumSc2(.T.)
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso tenha atingido o item 99, troca a numeracao da OP       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nAglutItem > 99
			If !SC2->( MsSeek(xFilial("SC2")+Soma1(cAglutNum)) )
				cAglutNum := Soma1(cAglutNum)
			Else
				cAglutNum  := GetNumSc2(.T.)
			EndIf
			nAglutItem := 1
		Else
			lNumOpIni := .T.
		EndIf
	EndIf
	
	nOrd       := 0
	While nOrd < TRB->ORDEM
		
		IncProc("Incrementando Arquivo de Trabalho...")
		
		nOrd := TRB->ORDEM
		If Empty(TRB->MARK)
			dbSkip()
			Loop
		EndIf
		
		cProd1 := If(REFGRD=="S",Left(TRB->PRODUTO,nx),TRB->PRODUTO)
		cProd2 := TRB->PRODUTO
		
		If TRB->REFGRD #"S" .And. TRB->GRADE # "S"
			cAglutIGrd := ""
			lNovoItem  := .F.
		EndIf
		
		cAglutIGrd := ""
		
		
		If !Empty(TRB->SEQPAI)
			cAglutIgrd := ""
		EndIf
		RecLock("TRB",.F.)
		Replace TRB->AGLUT   With cAglutNum+StrZero(nAglutItem,2)+cAglutSeq+cAglutIGrd
		Replace TRB->ITEMGRD With cAglutIGrd
		Replace TRB->GRADE   With If(Empty(TRB->ITEMGRD),"","S")
		
		TRB->(MsUnlock())
		TRB->(dbSkip())
		
		lComp := (cProd2 #TRB->PRODUTO)
		
		If lComp
			nAglutItem++
			If nAglutItem > 99
				If lNumOpIni
					cAglutNum := Soma1(cAglutNum)
				Else
					cAglutNum := GetNumSc2(.T.)
				Endif
				nAglutItem := 1
				cAglutSeq  := "001"
			Endif
		Else
			If cProd2 #TRB->PRODUTO .And. TRB->REFGRD == "S"
				lNovoItem  := .T.
			Endif
		EndIf
		
		If lNovoItem
			nAglutIGrd++
			If nAglutIGrd > 99
				cAglutNum  := GetNumSc2(.T.)
				nAglutIGrd := 1
			Endif
			cAglutIGrd := StrZero(nAglutIGrd,nIG)
			lNovoItem  := .F.
		EndIf
		
	End
End
dbSetOrder(1)
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A720Make  ³ Autor ³ Ary Medeiros          ³ Data ³ 02/06/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava as OPs aglutinadas, acerta os empenhos e remove as OPs³±±
±±³          ³ antigas do SC2.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³oTNewProc = Objeto tNewProcess()                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA720                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function A720Make(oTNewProc)
Local nQuantD4,dDtValid,nRecno
Local cOpOrig   := "",cProduto:="",cLocal:="",cTRT:="",cLote:="",cLoteCtl:=""
Local cFiltroC6 := ''
Local cIndC6    := ''
Local cNomArqC6 := ''
Local nIndC6    := 0
Local cSeekC6   := ''
Local aRecnoC6  := {}
Local nX        := 0
Local cFilSD3   := xFilial('SD3')
Local cSeekSD3  := ''
Local lMTA720A  := ExistBlock("MTA720A")
Local lTA720OP	:= ExistTemplate("A720OP")
Local lA720OP	:= ExistBlock("A720OP")

Local cSeekDC   := ""
Local bWhileDC  := Nil
Local aArraySDC := {}
Local nForSDC   := 0

Local nTamOP    := Len(SC2->C2_NUM)
Local nTamIt    := Len(SC2->C2_ITEM)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Checa se o carga maquina nao esta sendo executado³
//³se nao estiver efetua lock para permitir delecao.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If OpenSemSH8()
	//-- Indexa SC6 por Filial + NumOP + ItemOP
	
	dbSelectArea("SC2")
	dbSetOrder(1)
	dbSelectArea("TRB")
	
	ProcRegua(LastRec(),15,6)
	
	dbGoTop()
	
	While !Eof()
		
		IncProc()
		
		cAglut  := AGLUT
		lGera   := .f.
		Begin Transaction
		While !Eof() .And. AGLUT == cAGLUT
			If (oTNewProc<>Nil) .And. oTNewProc:lEnd
				Exit
			EndIf
			
			IncProc()
			
			If !Empty(GERADO) .Or. Empty(MARK)
				dbSkip()
				Loop
			EndIf
			lGera   := .t.
			nQuant  := QUANT
			RecLock("TRB")
			Replace GERADO with "û"
			MsUnlock()
			
			DbSelectArea("SB1")
			DbSeek(xFilial("SB1")+TRB->PRODUTO)
			nPrazo := CalcPrazo(TRB->PRODUTO,nQuant)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Esta funcao cria Ordem de Producao ou soma quantidade no SC2 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SC2")
			If dbSeek(xFilial("SC2")+cAglut)
				RecLock("SC2",.F.)
			Else
				RecLock("SC2",.T.)
				Replace  C2_PRODUTO With TRB->PRODUTO,	C2_FILIAL  With xFilial("SC2"),;
				C2_NUM  	With Substr(cAglut,1,6), 	C2_ITEM    With Substr(cAglut,7,2),;
				C2_EMISSAO 	With dDataBase,		 		C2_LOCAL   With RetFldProd(SB1->B1_COD,"B1_LOCPAD"),;
				C2_CC      	With SB1->B1_CC, 			C2_UM 	   With SB1->B1_UM,;
				C2_OPC      With TRB->OPCIONAL, 		C2_DATPRF  With TRB->ENTREGA,;
				C2_DESTINA 	With "E", 					C2_PRIOR   With "500",;
				C2_SEQUEN  	With Substr(cAglut,9,3), 	C2_GRADE   With If(!Empty(TRB->ITEMGRD),"S"," "),;
				C2_DATPRI  	With TRB->INICIO,			C2_ITEMGRD With TRB->ITEMGRD,;
				C2_AGLUT	With "S",					C2_SEGUM   With SB1->B1_SEGUM,;
				C2_ROTEIRO	With TRB->ROTEIRO,;
				C2_TPOP     With TRB->TPOP
			EndIf
			Replace	C2_QUANT   	With C2_QUANT+nQuant
			Replace	C2_QTSEGUM  With C2_QTSEGUM+ConvUm(TRB->PRODUTO,nQuant,0,2)
			Replace C2_DATPRF   With TRB->ENTREGA
			
			SC2->(FKCommit())
			
			dbSelectArea("SC1")
			dbSetOrder(4)
			dbSeek(xFilial("SC1")+TRB->NUMOP)
			If Found()
				While !Eof() .And. xFilial("SC1")+TRB->NUMOP == C1_FILIAL+C1_OP
					dbSkip()
					If xFilial("SC1")+TRB->NUMOP == C1_FILIAL+C1_OP
						nRecno:=Recno()
						dbSkip(-1)
						RecLock("SC1",.F.)
						Replace C1_OP With TRB->AGLUT
						MsUnlock()
						dbGoto(nRecno)
					Else
						dbSkip(-1)
						RecLock("SC1",.F.)
						Replace C1_OP With TRB->AGLUT
						MsUnlock()
					EndIf
				End
			EndIf
			dbSetOrder(1)
			
			dbSelectArea('SD3')
			dbSetOrder(1)
			If dbSeek(cSeekSD3 := cFilSD3 + TRB->NUMOP)
				Do While !Eof() .And. cSeekSD3 == D3_FILIAL + D3_OP
					If Empty(D3_ESTORNO)
						RecLock('SD3', .F.)
						Replace D3_OP With TRB->AGLUT
						MsUnlock()
					EndIf
					dbSkip()
				EndDo
			EndIf
			
			dbSelectArea("SD4")
			dbSetOrder(4)
			dbSeek(xFilial("SD4")+TRB->NUMOP)
			Do While !Eof() .And. xFilial("SD4")+TRB->NUMOP == D4_FILIAL+D4_OPORIG
				Reclock("SD4",.F.)
				Replace D4_OPORIG With TRB->AGLUT
				Replace D4_ORDEM  With StrZero(TRB->ORDEM, Len(D4_ORDEM)) //-- Evita chave duplicada (A Chave Unica no SD4 eh D4_FILIAL+D4_COD+D4_OP+D4_TRT+D4_LOTECTL+D4_NUMLOTE+D4_LOCAL+D4_ORDEM+D4_OPORIG)
				MsUnlock()
				dbSkip()
			EndDo
			
			dbSelectArea("SD4")
			dbSetOrder(2)
			dbSeek(xFilial("SD4")+TRB->NUMOP)
			While !Eof() .And. SD4->D4_FILIAL+SD4->D4_OP == xFilial("SD4")+TRB->NUMOP
				nRecSD4  := RecNo()
				nQuantD4 := SD4->D4_QUANT
				cProduto := SD4->D4_COD
				cLOCAL   := SD4->D4_LOCAL
				cTRT     := SD4->D4_TRT
				cLote 	 := SD4->D4_NUMLOTE
				cLoteCtl := SD4->D4_LOTECTL
				dDtValid := SD4->D4_DTVALID
				cOpOrig  :=	SD4->D4_OPORIG
				dbSetOrder(1)
				dbSeek(xFilial("SD4")+cProduto+TRB->AGLUT+cTRT+cLoteCtl+cLote)
				If Found()
					RecLock("SD4",.F.)
					Replace D4_QUANT    With D4_QUANT + nQuantD4
					Replace D4_QTDEORI  With D4_QUANT
					Replace D4_QTSEGUM  With ConvUm(cProduto,D4_QUANT,0,2)
				Else
					RecLock("SD4",.T.)
					Replace	D4_FILIAL 	With xFilial("SD4")	,D4_DATA    With TRB->ENTREGA,;
					D4_COD    	With cProduto  	,D4_LOCAL   With cLOCAL,;
					D4_QUANT  	With nQuantD4  	,D4_QTDEORI With nQuantD4,;
					D4_OP     	With TRB->AGLUT	,D4_TRT     With cTRT,;
					D4_NUMLOTE	With cLote		,D4_LOTECTL With cLoteCtl,;
					D4_DTVALID	With dDtValid  	,D4_QTSEGUM With ConvUm(cProduto,nQuantD4,0,2),;
					D4_OPORIG	With cOpOrig
				EndIf
				MsUnlock() // para nao dar excesso de locks na estacao
				dbSetOrder(2)
				dbGoto(nRecSD4)
				
				dbSelectArea("SDC")
				dbSetOrder(2)
				// Procura por empenho sem lotes
				If !(Rastro(SD4->D4_COD)) .Or. (Rastro(SD4->D4_COD) .And. Empty(SD4->D4_LOTECTL))
					cSeekDC  := xFilial("SDC")+SD4->D4_COD+SD4->D4_LOCAL+SD4->D4_OP+SD4->D4_TRT
					bWhileDC := {|| DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT}
				Else
					If Rastro(SD4->D4_COD,"L")
						// Procura por empenho com lote
						cSeekDC   := xFilial("SDC")+SD4->D4_COD+SD4->D4_LOCAL+SD4->D4_OP+SD4->D4_TRT+SD4->D4_LOTECTL
						bWhileDC  := {|| DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL}
					Else
						// Procura por empenho com lote+sub-lote
						cSeekDC  := xFilial("SDC")+SD4->D4_COD+SD4->D4_LOCAL+SD4->D4_OP+SD4->D4_TRT+SD4->D4_LOTECTL+SD4->D4_NUMLOTE
						bWhileDC := {|| DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE}
					EndIf
				EndIf
				
				dbSeek(cSeekDC)
				aArraySDC := {}
				Do While ! Eof() .And. cSeekDC == Eval(bWhileDC)
					Aadd(aArraySDC, SDC->(RecNo()))
					dbSkip()
				Enddo
				
				For nForSDC := 1 to Len(aArraySDC)
					dbGoto(aArraySDC[nForSDC])
					RecLock("SDC", .F.)
					SDC->DC_OP  := TRB->AGLUT
					SDC->DC_TRT := cTRT
					MsUnlock()
				Next
				
				RecLock("SD4",.f.,.t.)
				dbDelete()
				MsUnlock() // para nao dar excesso de locks na estacao
				dbSkip()
			End
			
			dbSelectArea("SH8")
			dbSetOrder(1)
			If dbSeek(xFilial("SH8")+TRB->NUMOP)
				RecLock("SH8",.F.,.T.)
				dbDelete()
				MsUnlock()
			EndIf
			
			dbSelectArea("SC2")
			If dbSeek(xFilial("SC2")+TRB->NUMOP)
				RecLock("SC2",.F.,.T.)
				dbDelete()
			EndIf
			dbSetOrder(1)
			dbSelectArea("TRB")
			dbSkip()
		End
		End Transaction
	End
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Devolve as ordens originais dos arquivos                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RetIndex('SC6')
	dbClearFilter()
	If File(cNomArqC6 += OrdBagExt())
		fErase(cNomArqC6)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Fecha semaforo desbloqueando o SH8 para a filial³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ClosSemSH8()
	
EndIf
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PA201_01  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 04/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa montagem do arquivo de trabalho e do markbrowse    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³oTNewProc = Objeto tNewProcess()                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA720                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PA201_01(oTNewProc)

Local aStru     := {}
Local aTam      := {}
Local cArqTrab1 := cArqTrab2 := ""
Local nPeriodo  := 6

//A710GrvTm(oTNewProc, "Inicio Processamento")

If nPeriodo > 0
	AADD(aStru,{ "MARK"   ,  "C",02,0})
	aTam:=TamSX3("D4_OP")
	AADD(aStru,{ "AGLUT"  ,  "C",aTam[1],0})
	AADD(aStru,{ "NUMOP"  ,  "C",aTam[1],0})
	AADD(aStru,{ "PRODUTO",  "C",15,0})
	AADD(aStru,{ "DESCRICAO","C",30,0})
	AADD(aStru,{ "QUANT"  ,  "N",16,4})
	AADD(aStru,{ "INICIO" ,  "D",08,0})
	AADD(aStru,{ "ENTREGA",  "D",08,0})
	AADD(aStru,{ "ORDEM"  ,  "N",04,0})
	AADD(aStru,{ "GERADO" ,  "C",01,0})
	AADD(aStru,{ "ROTEIRO" , "C",02,0})
	AADD(aStru,{ "GRADE"   , "C",01,0})
	aTam:=TamSX3("C2_ITEMGRD")
	AADD(aStru,{ "ITEMGRD" , "C",aTam[1],0})
	aTam:=TamSX3("C2_OPC")
	AADD(aStru,{ "OPCIONAL", "C",aTam[1],0})
	aTam:=TamSX3("C2_TPOP")
	AADD(aStru,{ "TPOP","C",aTam[1],0})
	aTam:=TamSX3("C2_SEQPAI")
	AADD(aStru,{ "SEQPAI",   "C",aTam[1],0})
	AADD(aStru,{ "PRODPAI",  "C",15,0})
	AADD(aStru,{ "REFGRD",   "C",01,0})
	cSavAlias := Alias()
	cArqTrab1 := CriaTrab(aStru)
	cArqTrab2 := CriaTrab(Nil,.F.)
	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf
	cKey1 := "NUMOP"
	cKey2 :="MARK+TPOP+PRODUTO+ROTEIRO+OPCIONAL+DTOS(ENTREGA)"
	
	USE &cArqTrab1 ALIAS TRB NEW
	IndRegua("TRB",Left(cArqTrab1,7)+"I",cKey1,,,"Selecionando Registros...")
	IndRegua("TRB",cArqTrab2,cKey2,,,"Selecionando Registros...")
	dbClearIndex()
	dbSetIndex(Left(cArqTrab1,7)+"I"+OrdBagExt())
	dbSetIndex(cArqTrab2+OrdBagExt())
	
	Processa( {|| PA201_02(nPeriodo) } )
	Processa( {|| PA201_03(oTNewProc) } )
	
	dbSelectArea('TRB')
	dbCloseArea()
	Ferase(cArqTrab1+GetDBExtension())
	Ferase(Left(cArqTrab1,7)+"I"+OrdBagExt())
	Ferase(cArqTrab2+OrdBagExt())
	dbSelectArea(cSavAlias)
	
EndIf
//A710GrvTm(oTNewProc, "Fim Processamento")
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³MTA720OK  ³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 04/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Confirmacao antes de executar a Aglutinacao.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MTA720OK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MTA720OK()
Local cText := OemToAnsi("Esta rotina ir  aglutinar as Ordens de Produ‡„o")+CHR(13)
cText += OemToAnsi("conforme os parƒmetros selecionados.")+CHR(13)
cText += OemToAnsi("Confirma a aglutina‡„o das OPs ?")
Return (MsgYesNo(cText,OemToAnsi("Aten‡„o")))

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A720Escol  ³ Autor ³Rodrigo de A.Sartorio³ Data ³ 04/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Escolhe as Ops para Aglutinar                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA720                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function A720Escol(cMarca,lInverte,oDlg)

If IsMark("MARK",cMarca,lInverte)
	RecLock("TRB",.F.)
	If !lInverte
		Replace TRB->MARK With cMarca
	Else
		Replace TRB->MARK With "  "
	Endif
	MsUnlock()
Else
	RecLock("TRB",.F.)
	If !lInverte
		Replace TRB->MARK With "  "
	Else
		Replace TRB->MARK With cMarca
	Endif
	MsUnlock()
Endif
oDlg:Refresh()
Return .T.

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A720MarkAll³ Autor ³Rodrigo de A.Sartorio³ Data ³ 04/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inverte as OPs Marcadas/Desmarcadas                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA720                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function A720MarkAll(cMarca,oDlg)
Local nRecno := Recno()
dbGotop()
Do While !Eof()
	RecLock("TRB",.F.)
	If Empty(TRB->MARK)
		Replace TRB->MARK With cMarca
	Else
		Replace TRB->MARK With "  "
	Endif
	MsUnlock()
	dbSkip()
EndDo
dbGoto(nRecno)
oDlg:Refresh()
Return .T.

Static Function AtuSX1()

cPerg := "PA0201"
aRegs := {}

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Ordem Producao De     ?",""       ,""      ,"mv_ch1","C" ,13     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SC2")
U_CRIASX1(cPerg,"02","Ordem Producao Ate    ?",""       ,""      ,"mv_ch2","C" ,13     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SC2")
U_CRIASX1(cPerg,"03","Entrega De            ?",""       ,""      ,"mv_ch3","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR03",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"04","Entrega Ate           ?",""       ,""      ,"mv_ch4","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR04",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"05","Emissao De            ?",""       ,""      ,"mv_ch5","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR05",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"06","Emissao Ate           ?",""       ,""      ,"mv_ch6","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR06",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"07","Produto De            ?",""       ,""      ,"mv_ch7","C" ,15     ,0      ,0     ,"G",""            ,"MV_PAR07",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
U_CRIASX1(cPerg,"08","Produto Ate           ?",""       ,""      ,"mv_ch8","C" ,15     ,0      ,0     ,"G",""            ,"MV_PAR08",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
U_CRIASX1(cPerg,"09","Almoxarifado De       ?",""       ,""      ,"mv_ch9","C" ,02     ,0      ,0     ,"G",""            ,"MV_PAR09",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"10","Almoxarifado Ate      ?",""       ,""      ,"mv_cha","C" ,02     ,0      ,0     ,"G",""            ,"MV_PAR10",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return (Nil)