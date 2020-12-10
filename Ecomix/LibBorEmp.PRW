#Include "PROTHEUS.CH"
#Include "DBTREE.CH"
#include "topconn.ch"
#include "rwmake.ch"

//--------------------------------------------------------------
/*/{Protheus.doc} LibBorEmp
Description
Libera os borderos para pagamentos por Empresa

@param xParam Parameter Description
@return xRet Return Description
@author Washington Aquino
@since 19/05/2010 
Alteraçoes
opçao "Todos"na pergunta inicial
aCores + legenda com o status da liberação
Parametro master com varios usuários
Obs: Liberados é quando possui as duas liberações

/*/
//--------------------------------------------------------------
User Function LibBorEmp()
	Local cBmp1 := "FOLDER5" //"PMSDOC" //"FOLDER5" //"PMSMAIS" //"SHORTCUTPLUS"
	Local cBmp2 := "FOLDER6" //"PMSEDT3" //"FOLDER6" //"PMSMENOS" //"SHORTCUTMINUS"
	Static oDlg
	Static oDBTree2
	Private aBotoes := _aHdr := {}
	Private oGroup1
	Private oGroup3
	Private oGroup4
	Private oGroup5
	Private oSay10
	Private oSay11
	Private oSay12
	Private oSay13
	Private oSay2
	Private oSay7
	Private oSay8
	Private oSay9
	Private cPrompAnt
	Private cPrompt
	Private oOk     := LoadBitmap( GetResources(), "LBOK")
	Private oNo     := LoadBitmap( GetResources(), "LBNO")
	Private oVerde  := LoadBitmap( GetResources(), "BR_VERDE")
	Private oAzul 	 := LoadBitmap( GetResources(), "BR_AZUL")
	Private oCinza  := LoadBitmap( GetResources(), "BR_CINZA")
	Private oVerm   := LoadBitmap( GetResources(), "BR_VERMELHO")
	Private oWBrowse2
	Private aWBrowse2 := {}
	Private nTotGer := nQtd := 0

	Private nPosFil := nPosDat := nPosBor := nPosPor := nPosAge := nPosCon := nPosTot := nPosMen := nPosMai := nPosQtd := nPosEmp := nPos1Lb := nPos2Lb := nPosRej := 0

/*_aHdr := {"","","Filial","Data","Borderô","Portador","Agencia","Conta","Total","Menor Vencimento","Maior Vencimento","Qtd.Titulos","Empresa","1o Liberação","2o Liberação","Rejeitado"}
nPosFil := aScan(_aHdr,{|x| upper(x[1])="FILIAL"})
nPosDat := aScan(_aHdr,{|x| upper(x[1])="DATA"} )
nPosBor := aScan(_aHdr,{|x| upper(x[1])="BORDERÔ"})
nPosPor := aScan(_aHdr,{|x| upper(x[1])="PORTADOR"})
nPosAge := aScan(_aHdr,{|x| upper(x[1])="AGENCIA"} )
nPosCon := aScan(_aHdr,{|x| upper(x[1])="CONTA"}  )
nPosTot := aScan(_aHdr,{|x| upper(x[1])="TOTAL"}  )
nPosMen := aScan(_aHdr,{|x| upper(x[1])="MENOR VENCIMENTO"})
nPosMai := aScan(_aHdr,{|x| upper(x[1])="MAIOR VENCIMENTO"})
nPosQtd := aScan(_aHdr,{|x| upper(x[1])="QTD.TITULOS"}  )
nPosEmp := aScan(_aHdr,{|x| upper(x[1])="EMPRESA"}  )
nPos1Lb := aScan(_aHdr,{|x| upper(x[1])="1O LIBERAÇÃO"} )
nPos2Lb := aScan(_aHdr,{|x| upper(x[1])="2O LIBERAÇÃO"} )
nPosRej := aScan(_aHdr,{|x| upper(x[1])="REJEITADO"} )
*/
//-------------------------------------------------
// Cria grupo de perguntas
//-------------------------------------------------
	Private cPerg := "LiBorEmp" + "2"

// 1-Somente nao liberados   2- Somente com uma liberacao   3- Reavaliar
	PutSx1(cPerg,"01","Tipo","Tipo","Tipo","mv_ch1","N",01,00,01,"C","",""  ,"","","mv_par01","Nao liberados","Nao liberados","Nao liberados", "Uma liberacao","Uma liberacao","Uma liberacao","Todos","Todos","Todos","","","", "", "", "", "", "", "", "", "")
	PutSx1(cPerg,"02","Da Data","Da Data","Da Data", "mv_ch2", "D", 8, 0, 0,"G", "", ""/*F3*/, "", "","mv_par02","","","", "","","","", "", "", "", "", "", "", "", "", "", "", "", "", "")
	RecLock("SX1",.F.)
// Sugere o periodo de acordo com os parametros
	SX1->X1_CNT01 := GetNewPar('MV_MIZU01I',SX1->X1_CNT01)

	PutSx1(cPerg,"03","Ate Data","Ate Data","Ate Data", "mv_ch3", "D", 8, 0, 0,"G", "", ""/*F3*/, "", "","mv_par03","","","", "","","","", "", "", "", "", "", "", "", "", "", "", "", "", "")
	SX1->X1_CNT01 := GetNewPar('MV_MIZU01F',SX1->X1_CNT01)
	MsUnlock()
//---------------------------------------------------
// testa o parametro se vai ter nivel de filiais na arvore
	Private lfilial := .f.

	lfilial :=GetNewPar("MV_XLBORFIL",.F.)

// pega o usuário master
	Private libmaster := Upper(Alltrim(GetNewPar("MV_YLIBM","xxxxxx")))

// Trata e prepara o parametro para ser usado na query
	Private cInmaster
	cInmaster := libmaster
	cInmaster := StrTran(cInmaster,",",";")
	cInmaster := StrTran(cInmaster,"/",";")
	cInmaster := StrTran(cInmaster,":",";")
	cInmaster := StrTran(cInmaster,"\",";")
	cInmaster := StrTran(cInmaster,"|",";")
	cInmaster := StrTran(cInmaster,"-",";")
	cInmaster := StrTran(cInmaster,"#",";")
	cInmaster := FormatIn(cInmaster,";")

	If Upper(Alltrim(Substr(cUsuario,7,15))) $ Upper(Alltrim(libmaster))
		Pergunte(cPerg,.F.)
		mv_par01 := 1
		mv_par02 := GetNewPar('MV_MIZU01I',dDataBase-365)
		mv_par03 := GetNewPar('MV_MIZU01F',dDataBase)
	Else
		If !Pergunte(cPerg,.T.)
			Return
		Endif
	Endif

// Prepara o titulo
	Private cTitulo := "Liberação de Borderôs"
	If Mv_par01 == 1
		cTitulo += " - Somente nao liberados"
	ElseIf Mv_par01 == 2
		cTitulo += " - Somente com uma liberacao"
	ElseIf Mv_par01 == 3
		cTitulo += " - Todos "
	EndIf
// Inclui os botoes
	AADD(aBotoes,{"SELECTALL"	,{|| If(Len(aWBrowse2)>0,MarkTd(aWBrowse2,.T.),nil)} 							,"Marca"		,Nil})
	AADD(aBotoes,{"UNSELECTALL"	,{|| If(Len(aWBrowse2)>0,MarkTd(aWBrowse2,.F.),nil)} 							,"Desmarca"		,Nil})
	AADD(aBotoes,{"PENDENTE"	,{|| If(Len(aWBrowse2)>0,Inverte(aWBrowse2),nil)} 								,"Inverte"		,Nil})
	AADD(aBotoes,{"PMSPESQ"		,{|| If(Len(aWBrowse2)>0,Pesquisar(aWBrowse2),nil)} 							,"Pesquisar"	,Nil})
	AADD(aBotoes,{"ALTERA"		,{|| If(Len(aWBrowse2)>0,fListTit(Left(aWBrowse2[oWBrowse2:nAt,13],2);
		+aWBrowse2[oWBrowse2:nAt,03],  ;
		aWBrowse2[oWBrowse2:nAt,05]),nil)} 							,"Visualizar"	,Nil})
	AADD(aBotoes,{"EXCLUIR"		,{|| If(Len(aWBrowse2)>0,fLimpaSel(aWBrowse2[oWBrowse2:nAt,13]),nil)}			,"Limpar"		,Nil})
	AADD(aBotoes,{"DEVOLNF"		,{|| fWbrReav(oDBTree2:GetPrompt())} 											,"Reavaliar"	,Nil})
	AADD(aBotoes,{"OBJETIVO"	,{|| LegCh()} 																	,"Legenda"	,Nil})



// Ler as coordenadas da janela principal
	oMainWnd:ReadClientCoords()
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000, 000  TO oMainWnd:nBottom-50, oMainWnd:nRight-30 COLORS 0, 16777215 PIXEL

	EnchoiceBar(oDlg, {||Processa({||fGrava(),oDlg:End()})}, {||oDlg:End()},,aBotoes)
	@ 014, 000 GROUP oGroup3 TO 330, 120 PROMPT "Selecione a Empresa" OF oDlg COLOR 0, 16777215 PIXEL

//------------------------------------------------
// define a arvore
//------------------------------------------------
	DEFINE DBTREE oDBTree2 FROM 020, 001 TO c(oMainWnd:nBottom-15)/3, 119 OF oGroup3 //ON CHANGE FAlteraDBTree() CARGO

	cCodAnt := ""
	DbSelectArea("SM0")
	cRecnoAnt := Recno()
	DbGoTop()
	Do While !Eof()
		If cCodAnt != SM0->M0_CODIGO
			If !Empty(cCodAnt)
				DBENDTREE oDBTree2
			Endif

			DBADDTREE oDBTree2 PROMPT SM0->M0_CODIGO+"00-"+SM0->M0_FILIAL CARGO SM0->M0_FILIAL  RESOURCE cBmp1 // item
			cCodAnt := M0_CODIGO
			Private &("aWBrw"+SM0->M0_CODIGO+"00") := {}
		Endif
		If lfilial
			DBADDITEM oDBTree2 PROMPT SM0->M0_CODIGO+SM0->M0_CODFIL+"-"+SM0->M0_FILIAL CARGO SM0->M0_FILIAL RESOURCE cBmp2 // "SubItem"
		endif
		// Declara e inicializa variaveis de todas as empresas
		Private &("aWBrw"+SM0->M0_CODIGO+SM0->M0_CODFIL) := {}
		DbSkip()
	EndDo
	DBENDTREE oDBTree2
// define o duplo click somente no subitem 
	oDBTree2:bLDblClick := {|| If(IsDigit(Left(oDBTree2:GetPrompt(),2)),Processa({|lEnd| FAlteraDBTree(oDBTree2:GetPrompt())},"Selecionando Borderôs...",,.T.),nil)}

	DbSelectArea("SM0")
	DbGoTo(cRecnoAnt)

	@ 014, 093 GROUP oGroup4 TO 230, c(450) PROMPT "Marque os Borderôs" OF oDlg COLOR 0, 16777215 PIXEL
	fWBrowse2()
	@ 330, 000 GROUP oGroup1 TO 360, 512 PROMPT "Total Selecionado" OF oDlg COLOR 0, 16777215 PIXEL
	oGroup1:ReadClientCoords()

	@ c(oMainWnd:nBottom/3)+10 /*(310)*/, c(020) SAY oSay2 PROMPT "Borderôs selecionados:" SIZE 056, 010 OF oGroup1 COLORS 0, 16777215 PIXEL
	@ c(oMainWnd:nBottom/3)+10, c(071) SAY oSay7 Var nQtd SIZE 105, 010 OF oGroup1 PICTURE '@E 999,999,999' COLORS 0, 16777215 PIXEL
	@ c(oMainWnd:nBottom/3)+10, c(247) SAY oSay8 PROMPT "Valor Total Selecionado:" SIZE 082, 010 OF oGroup1 COLORS 0, 16777215 PIXEL
	@ c(oMainWnd:nBottom/3)+10, c(341) SAY oSay9 Var nTotGer SIZE 105, 010 OF oGroup1 PICTURE '@E 999,999,999.99' COLORS 0, 16777215 PIXEL

// Don't change the Align Order
	oGroup1:Align := CONTROL_ALIGN_BOTTOM
	oGroup3:Align := CONTROL_ALIGN_LEFT
	oGroup4:Align := CONTROL_ALIGN_RIGHT

	oWBrowse2:Align := CONTROL_ALIGN_ALLCLIENT

	ACTIVATE MSDIALOG oDlg CENTERED


Return

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                         ³
//³Cria o browse para o mark³
//³                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
//------------------------------------------------
Static Function fWBrowse2()
//------------------------------------------------

// Insert items here
//    Aadd(aWBrowse2,{.F.,"Data","Borderô","Portador","Agencia","Conta","Total","Menor Vencimento","Maior Vencimento","Qtd.Titulos"})
Aadd(aWBrowse2,{"",.F.,"","","","","","","","","","","","","",""})
//	aWBrowse2 := {}
oGroup4:ReadClientCoords()
//oMainWnd:nTop+25,oMainWnd:nLeft+5 TO oMainWnd:nBottom-25,oMainWnd:nRight-10

@ 020, 135 LISTBOX oWBrowse2 Fields HEADER "","","Filial","Data","Borderô","Portador","Agencia","Conta","Total","Menor Vencimento","Maior Vencimento","Qtd.Titulos","Empresa","1o Liberação","2o Liberação","Rejeitado" SIZE 474,c(oMainWnd:nBottom-60)/3/*c(230)*/ OF oGroup4 PIXEL ColSizes 50,50
oWBrowse2:SetArray(aWBrowse2)

oWBrowse2:bLine := {|| {;
	If(!Empty(aWBrowse2[oWBrowse2:nAT,16]),oCinza,;
			If(Empty(aWBrowse2[oWBrowse2:nAT,14]) .and. Empty(aWBrowse2[oWBrowse2:nAT,15]),oVerde,;
				If(Empty(aWBrowse2[oWBrowse2:nAT,14]) .or.  Empty(aWBrowse2[oWBrowse2:nAT,15]),oAzul,;
					If(!Empty(aWBrowse2[oWBrowse2:nAT,14]) .and. !Empty(aWBrowse2[oWBrowse2:nAT,15]),oVerm,;
oCinza)))),;
						If(aWBrowse2[oWBrowse2:nAT,2],oOk,oNo),;
	aWBrowse2[oWBrowse2:nAt,3],;
	aWBrowse2[oWBrowse2:nAt,4],;
	aWBrowse2[oWBrowse2:nAt,5],;
	aWBrowse2[oWBrowse2:nAt,6],;
	aWBrowse2[oWBrowse2:nAt,7],;
	aWBrowse2[oWBrowse2:nAt,8],;
	aWBrowse2[oWBrowse2:nAt,9],;
	aWBrowse2[oWBrowse2:nAt,10],;
	aWBrowse2[oWBrowse2:nAt,11],;
	aWBrowse2[oWBrowse2:nAt,12],;
	aWBrowse2[oWBrowse2:nAt,13],;
	aWBrowse2[oWBrowse2:nAt,14],;
	aWBrowse2[oWBrowse2:nAt,15],;
	aWBrowse2[oWBrowse2:nAt,16];
	}}

oWBrowse2:bLDblClick := {|| aWBrowse2[oWBrowse2:nAt,2] := !aWBrowse2[oWBrowse2:nAt,2],;
oWBrowse2:DrawSelect(),VldMarca()}
oWBrowse2:Refresh()


Return

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄlic$¿
//³                     ³
//³Funçao do duplo click³
//³                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄlic$Ù
						ENDDOC*/
//------------------------------------------------
Static Function FAlteraDBTree(cPrompt)
//------------------------------------------------
Default cPrompt := ""

// Testa se o subitem é valido
	If !IsDigit(Substr(cPrompt,1,4))
	Return
	Endif

// se for igual nao precisa mudar
	If cPrompAnt == cPrompt .and. Len(aWBrowse2) > 0
	Return
	Endif

// Testa se o a Seleção é na filial
	If IsDigit(Substr(cPrompt,3,2)) .And. Substr(cPrompt,3,2) <> "00" .and. Len(&("aWBrw"+Substr(cPrompt,1,2)+"00")) > 0
    MsgInfo("A Empresa desta Filial já foi Selecionada! Favor selecionar a Empresa.")
	Return	
	Endif

// Testa se o a Seleção é na empresa e se já existe alguma filial selecionada
	If IsDigit(Substr(cPrompt,3,2)) .And. Substr(cPrompt,3,2) == "00" .and. Len(&("aWBrw"+Substr(cPrompt,1,2)+"00")) = 0
	DbSelectArea("SM0")
	cRecnoAnt := Recno()
	DbGoTop()
	SM0->(DbSeek( Substr(cPrompt,1,2) ))
		Do While !Eof() .and. Substr(cPrompt,1,2) == SM0->M0_CODIGO
			If Len(&("aWBrw"+SM0->M0_CODIGO+SM0->M0_CODFIL)) > 0
			DbSelectArea("SM0")
			DbGoTo(cRecnoAnt)
		    MsgInfo("Filial: "+SM0->M0_CODFIL+" desta Empresa já foi Selecionada! Favor Selecione a filial.")
			Return	
			Endif
		DbSkip()
		EndDo
	DbSelectArea("SM0")
	DbGoTo(cRecnoAnt)
	Endif
	
// guarda a array anterior de acordo com o browse
	If Len(aWBrowse2) > 0 .and. !Empty(aWBrowse2[1][4]) .and. !Empty(cPrompAnt)
	&("aWBrw"+Substr(cPrompAnt,1,4)) := {}
	&("aWBrw"+Substr(cPrompAnt,1,4)) := aClone(aWBrowse2)
	Endif
//verifica se a filial já tem array e carrega no browse
	If Len(&("aWBrw"+Substr(cPrompt,1,4))) > 0
	aWBrowse2 := {}
	aWBrowse2 := aClone(&("aWBrw"+Substr(cPrompt,1,4)) )
	Else

	// monta a array 
	
	&("aWBrw"+Substr(cPrompt,1,4)) := {}
	aWBrowse2 := {}
	
	DbSelectArea("SEA")
	DbSelectArea("SE2")
	cQuery  := "SELECT EA_FILIAL,EA_DATABOR,EA_NUMBOR,EA_PORTADO,EA_AGEDEP AGENCIA,EA_NUMCON CONTA,SUM(E2_SALDO) TOTAL,MIN(E2_VENCREA) MENORVENC,MAX(E2_VENCREA) MAIORVENC,COUNT(EA_DATABOR) AS QTDTIT,EA_YLIB01,EA_YLIB02,EA_YREJEIT "
	cQuery  += "FROM SEA"+Substr(cPrompt,1,2)+"0 EA, SE2"+Substr(cPrompt,1,2)+"0 E2 WHERE EA.D_E_L_E_T_<>'*' AND E2.D_E_L_E_T_<>'*' AND EA_CART = 'P' "
	cQuery  += "AND E2_FILIAL = EA_FILIAL AND E2_PREFIXO = EA_PREFIXO AND E2_NUM = EA_NUM AND E2_TIPO = EA_TIPO AND E2_PARCELA = EA_PARCELA AND E2_FORNECE = EA_FORNECE AND E2_LOJA = EA_LOJA "
		If IsDigit(Substr(cPrompt,3,2)) .And. Substr(cPrompt,3,2) <> "00" .and. Len(&("aWBrw"+Substr(cPrompt,1,2)+"00")) > 0
		cQuery  += "AND (EA_FILIAL = '"+Substr(cPrompt,3,2)+"' OR EA_FILIAL = '' )"
		Endif
	
	DbSelectArea("SEA")
		If FieldPos('EA_YLIB01') > 0 .and.  FieldPos('EA_YLIB02') > 0 .and.  FieldPos('EA_YREJEIT') > 0
        // se for o master não traz o que ele já liberou
/*		If Upper(Alltrim(Substr(cUsuario,7,15))) $ Upper(Alltrim(libmaster))
			cQuery += " AND (EA_YLIB01 = '' OR UPPER(EA_YLIB01) NOT IN "+cInMaster+")" 
		end
*/
		// somente nao liberados
		If mv_par01 == 1
			cQuery += " AND (EA_YLIB01 = '' OR EA_YLIB02 = '') AND EA_YREJEIT <> 'X'"
			// com uma liberacao
		ElseIf mv_par01 == 2
			cQuery += " AND (EA_YLIB01 <> '' AND EA_YLIB02 = '') AND EA_YREJEIT <> 'X'"
		EndIf
	Endif
	IF !Empty(mv_par03)
		cQuery += " AND EA_DATABOR BETWEEN '"+DTOS(mv_par02)+"' AND '"+DTOS(mv_par03)+"'"
	ENDIF

	cQuery  += "GROUP BY EA_FILIAL,EA_DATABOR,EA_NUMBOR,EA_PORTADO,EA_AGEDEP,EA_NUMCON,EA_YLIB01,EA_YLIB02,EA_YREJEIT "
	//cQuery  += "Order By EA_FILIAL,EA_DATABOR,EA_NUMBOR,EA_PORTADO "
	cQuery  += "Order By EA_NUMBOR,EA_PORTADO "

	If Select("TRB") >0
		DbSelectArea("TRB")
		DbCloseArea()
	ENDIF
	MemoWrite(FunName()+".sql",cQuery)
	TCQUERY cQuery ALIAS "TRB" NEW
	TcSetField("TRB","EA_DATABOR","D")
	TcSetField("TRB","MENORVENC","D")
	TcSetField("TRB","MAIORVENC","D")
	ProcRegua(TRB->(LastRec()))
	DbSelectArea("TRB")
	DbGoTop()
	Do While !Eof()
		IncProc("Borderô:"+EA_NUMBOR)
		Aadd(aWBrowse2,{"",.F.,EA_FILIAL,EA_DATABOR,EA_NUMBOR,EA_PORTADO,AGENCIA,CONTA,Transform(TOTAL,"@E 999,999,999.99"),MENORVENC,MAIORVENC,QTDTIT,cPrompt,EA_YLIB01,EA_YLIB02,EA_YREJEIT})
		DbSkip()
	Enddo
	aCopy(aWBrowse2,&("aWBrw"+Substr(cPrompt,1,4)) )
EndIf
// guarda a array selecionada de acordo com a arvore
If Len(aWBrowse2) > 0 .and. !Empty(aWBrowse2[1][3])
	&("aWBrw"+Substr(cPrompt,1,4)) := {}
	&("aWBrw"+Substr(cPrompt,1,4)) := aClone(aWBrowse2)
Endif
// grava a seleção atual
cPrompAnt := cPrompt

oWBrowse2:SetArray(aWBrowse2)

oWBrowse2:bLine := {|| {;
	If(!Empty(aWBrowse2[oWBrowse2:nAT,16]),oCinza,;
		If(Empty(aWBrowse2[oWBrowse2:nAT,14]) .and. Empty(aWBrowse2[oWBrowse2:nAT,15]),oVerde,;
			If(Empty(aWBrowse2[oWBrowse2:nAT,14]) .or.  Empty(aWBrowse2[oWBrowse2:nAT,15]),oAzul,;
				If(!Empty(aWBrowse2[oWBrowse2:nAT,14]) .and. !Empty(aWBrowse2[oWBrowse2:nAT,15]),oVerm,;
					oCinza)))),;
					If(aWBrowse2[oWBrowse2:nAT,2],oOk,oNo),;
						aWBrowse2[oWBrowse2:nAt,3],;
						aWBrowse2[oWBrowse2:nAt,4],;
						aWBrowse2[oWBrowse2:nAt,5],;
						aWBrowse2[oWBrowse2:nAt,6],;
						aWBrowse2[oWBrowse2:nAt,7],;
						aWBrowse2[oWBrowse2:nAt,8],;
						aWBrowse2[oWBrowse2:nAt,9],;
						aWBrowse2[oWBrowse2:nAt,10],;
						aWBrowse2[oWBrowse2:nAt,11],;
						aWBrowse2[oWBrowse2:nAt,12],;
						aWBrowse2[oWBrowse2:nAt,13],;
						aWBrowse2[oWBrowse2:nAt,14],;
						aWBrowse2[oWBrowse2:nAt,15],;
						aWBrowse2[oWBrowse2:nAt,16],;
						}}

// DoubleClick event
					oWBrowse2:bLDblClick := {|| aWBrowse2[oWBrowse2:nAt,2] := !aWBrowse2[oWBrowse2:nAt,2],;
						oWBrowse2:DrawSelect(),VldMarca()}


					oWBrowse2:Refresh()

					Return

//------------------------------------------------
Static Function Pesquisar(aWBrowse2)
//------------------------------------------------
	Local nPosSeek
// valida a consulta
	ValidSXB()

	If CONPAD1( , , , "SEA",, , .F. )
		nPosSeek := aScan(aWBrowse2,{|x| x[5]==SEA->EA_NUMBOR	})
		If nPosSeek > 1
			oWBrowse2:nAt := nPosSeek
			oWBrowse2:Refresh()
		Endif
	Endif
Return

//------------------------------------------------
Static Function MarkTd(aWBrowse2,lFlag)
//------------------------------------------------

	local q
	For q := 1 To Len(aWBrowse2)
		If aWBrowse2[q][2] != lFlag

			If Empty(aWBrowse2[q,4])
				Return .f.
			Endif
			If !Empty(aWBrowse2[q,14]) .AND. !Empty(aWBrowse2[q,15])
				//Msgalert("Este bordero ja foi liberado!")
				aWBrowse2[q,2] := .F.
				Loop
			EndIf
			If !Empty(aWBrowse2[q,15]) .and. Upper(Alltrim(SUBS(CUSUARIO,7,14))) != Upper(Alltrim(libmaster))
				//Msgalert("Este bordero ja possui a 2a liberacao!")
				aWBrowse2[q,2] := .F.
				Loop
			EndIf
			If !Empty(aWBrowse2[q,14]) .and. Upper(Alltrim(SUBS(CUSUARIO,7,14))) == Upper(Alltrim(libmaster))
				//Msgalert("Este bordero ja foi liberado pelo Sr. " + Alltrim(aWBrowse2[nPos,14]))
				aWBrowse2[q,2] := .F.
				Loop
			EndIf
			If !Empty(aWBrowse2[q,16])
				//Msgalert("Este bordero foi Rejeitado!")
				aWBrowse2[q,2] := .F.
				Loop
			EndIf

			aWBrowse2[q][2] := lFlag
			//VldMarca(q)
			If  aWBrowse2[q,2]
				nTotGer += Val(aWBrowse2[q,9])
				nQtd++
			Else
				nTotGer -= Val(aWBrowse2[q,9])
				nQtd--
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza objetos                                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oSay7:Refresh()
			oSay9:Refresh()
		Endif
	Next
Return
//------------------------------------------------
Static Function Inverte(aWBrowse2)
//------------------------------------------------
	local j

	For j := 1 To Len(aWBrowse2)

		If Empty(aWBrowse2[j,4])
			Return .f.
		Endif
		If !Empty(aWBrowse2[j,14]) .AND. !Empty(aWBrowse2[j,15])
			//Msgalert("Este bordero ja foi liberado!")
			aWBrowse2[j,2] := .F.
			Loop
		EndIf
		If !Empty(aWBrowse2[j,15]) .and. Upper(Alltrim(SUBS(CUSUARIO,7,14))) != Upper(Alltrim(libmaster))
			//Msgalert("Este bordero ja possui a 2a liberacao!")
			aWBrowse2[j,2] := .F.
			Loop
		EndIf
		If !Empty(aWBrowse2[j,14]) .and. Upper(Alltrim(SUBS(CUSUARIO,7,14))) == Upper(Alltrim(libmaster))
			//Msgalert("Este bordero ja foi liberado pelo Sr. " + Alltrim(aWBrowse2[nPos,14]))
			aWBrowse2[j,2] := .F.
			Loop
		EndIf
		If !Empty(aWBrowse2[j,16])
			//Msgalert("Este bordero foi Rejeitado!")
			aWBrowse2[j,2] := .F.
			Loop
		EndIf

		aWBrowse2[j][2] := !aWBrowse2[j][2]
		//VldMarca(j)

		If  aWBrowse2[j,2]
			nTotGer += Val(aWBrowse2[j,9])
			nQtd++
		Else
			nTotGer -= Val(aWBrowse2[j,9])
			nQtd--
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza objetos                                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oSay7:Refresh()
		oSay9:Refresh()
	Next
Return



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
	Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If "MP8" $ oApp:cVersion
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
		EndIf
	EndIf
Return Int(nTam)

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ‡¿
//³                                         ³
//³Atualiza o saldo dos titulos selecionados³
//³                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ‡Ù
ENDDOC*/
Static Function VldMarca(nPos)
Default nPos := oWBrowse2:nAt

	If Empty(aWBrowse2[nPos,4])
	Return .f.
	Endif
	If !Empty(aWBrowse2[nPos,14]) .AND. !Empty(aWBrowse2[nPos,15])
	Msgalert("Este bordero ja foi liberado!") 
	aWBrowse2[nPos,2] := .F.
	Return .f.
	EndIf
	If !Empty(aWBrowse2[nPos,15]) .and. Upper(Alltrim(SUBS(CUSUARIO,7,14))) != Upper(Alltrim(libmaster))
	Msgalert("Este bordero ja possui a 2a liberacao!")
	aWBrowse2[nPos,2] := .F.
	Return .f.
	EndIf
	If !Empty(aWBrowse2[nPos,14]) .and. Upper(Alltrim(SUBS(CUSUARIO,7,14))) == Upper(Alltrim(libmaster))
	Msgalert("Este bordero ja foi liberado pelo Sr. " + Alltrim(aWBrowse2[nPos,14]))
	aWBrowse2[nPos,2] := .F.
	Return .f.
	EndIf
	If !Empty(aWBrowse2[nPos,16])
	Msgalert("Este bordero foi Rejeitado!")
	aWBrowse2[nPos,2] := .F.
	Return .f.
	EndIf

	If  aWBrowse2[nPos,2]
	nTotGer += Val(aWBrowse2[nPos,9])
	nQtd++
	Else
	nTotGer -= Val(aWBrowse2[nPos,9])
	nQtd--
	Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza objetos                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSay7:Refresh()
oSay9:Refresh()
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ fListTit   ³ Autor ³ Washington Aquino     ³ Data ³23/05/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Montagem da ListBox Titulos                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fListTit(_cEmpresa, _cBordero)
Local _aListTit := {}

// valida os parametros caso seja clicado num browse vazio 
	If Empty(_cEmpresa) .or. Empty(_cBordero)
	Return
	Endif

_cQuery := " SELECT E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_NATUREZ, E2_EMISSAO, E2_VENCTO, E2_VALOR, E2_PORTADO, '' AS E2_AGEDEP, "
_cQuery += " E2_FORNECE, E2_LOJA, E2_NOMFOR, E2_BAIXA, E2_NUMBOR, E2_ORIGEM, E2_FILIAL, E2_HIST,E2_SALDO,E2_VENCREA "
_cQuery += " FROM SE2" + Left(_cEmpresa,2) + "0 E2 "
_cQuery += " WHERE (E2_FILIAL = '"+Substr(_cEmpresa,3,2)+"' ) AND"
_cQuery += " E2_NUMBOR = '" + _cBordero + "' AND "
_cQuery += " E2.D_E_L_E_T_ = '' "

	If Select("TRBTIT") > 0
	TRBTIT->(DbCloseArea())
	EndIf

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRBTIT",.F.,.T.)
TcSetField("TRBTIT","E2_EMISSAO"	,"D")
TcSetField("TRBTIT","E2_VENCTO"		,"D")
TcSetField("TRBTIT","E2_BAIXA"		,"D")
TCSetField("TRBTIT","E2_VALOR"  	,"N",12,2)
TCSetField("TRBTIT","E2_SALDO"  	,"N",12,2)

DbSelectArea("TRBTIT")
TRBTIT->(DbGoTop())
	If EOF()
	MsgInfo("Não foi encontrado títulos para este borderô")
	Return
	Endif

	While !TRBTIT->(Eof())
	aAdd( _aListTit, { 	TRBTIT->E2_HIST, TRBTIT->E2_PREFIXO, TRBTIT->E2_NUM, TRBTIT->E2_PARCELA, TRBTIT->E2_TIPO, TRBTIT->E2_NATUREZ,;
	TRBTIT->E2_EMISSAO, TRBTIT->E2_VENCREA, TRANSFORM(TRBTIT->E2_VALOR, "@E 9,999,999,999.99"), TRBTIT->E2_PORTADO, TRBTIT->E2_AGEDEP,;
	TRBTIT->E2_FORNECE, TRBTIT->E2_LOJA, TRBTIT->E2_NOMFOR, TRBTIT->E2_BAIXA, TRBTIT->E2_NUMBOR, TRANSFORM(TRBTIT->E2_SALDO, "@E 9,999,999,999.99")} )
	TRBTIT->(DbSkip())
	EndDo

DEFINE MSDIALOG _oDlgBor TITLE "Seguem abaixo as informações que compõe o bordero:"+_cBordero FROM C(178),C(181) TO C(578),C(897) PIXEL

EnchoiceBar(_oDlgBor, {||_oDlgBor:End()}, {||_oDlgBor:End()})
@ C(117),C(010) ListBox _oListTit Fields HEADER "HIST", "PREF.", "TITULO", "PARCELA", "TIPO", "NATUREZ",;
"EMISSAO", "VENCTO", "VALOR", "PORTADO", "AGEDEP",;
"FORNECEDOR", "LOJA", "NOME", "BAIXA", "BORDERO", "SALDO" Size C(340),C(077) Of _oDlgBor Pixel ColSizes 50

_oListTit:SetArray(_aListTit)
_oListTit:bLine := {|| {	_aListTit[_oListTit:nAT,1],;
_aListTit[_oListTit:nAt,2],;
_aListTit[_oListTit:nAt,3],;
_aListTit[_oListTit:nAt,4],;
_aListTit[_oListTit:nAt,5],;
_aListTit[_oListTit:nAt,6],;
_aListTit[_oListTit:nAt,7],;
_aListTit[_oListTit:nAt,8],;
_aListTit[_oListTit:nAt,9],;
_aListTit[_oListTit:nAt,10],;
_aListTit[_oListTit:nAt,11],;
_aListTit[_oListTit:nAt,12],;
_aListTit[_oListTit:nAt,13],;
_aListTit[_oListTit:nAt,14],;
_aListTit[_oListTit:nAt,15],;
_aListTit[_oListTit:nAt,16]}}

_oListTit:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG _oDlgBor CENTERED


Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ fGrava     ³ Autor ³ Washington Aquino     ³ Data ³23/05/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Gravaçao dos dados                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGrava()

// Salva a ultima seleção
	If Len(aWBrowse2) > 0 .and. !Empty(aWBrowse2[1][4])
		&("aWBrw"+Substr(aWBrowse2[1][13],1,4)) := {}
		&("aWBrw"+Substr(aWBrowse2[1][13],1,4)) := aClone(aWBrowse2)
	Endif

	ProcRegua(SM0->(LastRec()))

	DbSelectArea("SM0")
	cRecnoAnt := Recno()
	DbGoTop()
	
	While !Eof()
	
		IncProc("Processando Empresa: "+SM0->M0_CODIGO+SM0->M0_CODFIL)
	// testa se tem array e processa em outra empresa com job
		If Len(&("aWBrw"+SM0->M0_CODIGO+"00")) > 0
			StartJob("U_fGrvLibBor",GetEnvServer(), .T.,SM0->M0_CODIGO,SM0->M0_CODFIL,&("aWBrw"+SM0->M0_CODIGO+"00"),Substr(cUsuario,7,15),__cUserID,mv_par01,libmaster)
		ElseIf Len(&("aWBrw"+SM0->M0_CODIGO+SM0->M0_CODFIL)) > 0
			StartJob("U_fGrvLibBor",GetEnvServer(), .T.,SM0->M0_CODIGO,SM0->M0_CODFIL,&("aWBrw"+SM0->M0_CODIGO+SM0->M0_CODFIL),Substr(cUsuario,7,15),__cUserID,mv_par01,libmaster)
		Endif
	
		DbSkip()
	EndDo

	DbSelectArea("SM0")
	DbGoTo(cRecnoAnt)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ fGrvLibBor ³ Autor ³ Washington Aquino     ³ Data ³23/05/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Grava os dados na empresa/filial                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function fGrvLibBor(cEmp,cFil,a_par1,_cNomUsr, __cUserID,_nOpc,libmaster)

	local i
	
	// prepara o ambiente
	RpcSetType(3)
	RpcSetEnv(cEmp,cFil,"","","","",{"SX3","SX2","SX5","SX6"})

	Begin Transaction

		dbSelectArea("SEA")
		dbSetOrder(2) //EA_FILIAL, EA_NUMBOR, EA_CART, EA_PREFIXO, EA_NUM, EA_PARCELA, EA_TIPO, EA_FORNECE, EA_LOJA, R_E_C_N_O_, D_E_L_E_T_
		dbGoTop()

		// ler a array
		For i:= 1 to Len(a_par1)
			//    Aadd(aWBrowse2,{.F.,"Data","Borderô","Portador","Agencia","Conta","Total","Menor Vencimento","Maior Vencimento","Qtd.Titulos"})
			If  dbSeek(Padr(a_par1[i][3],2)+ Padr(a_par1[i][5],6) + "P")
		
				// Testa se já foi liberado pelo master
				If !Empty(SEA->EA_YLIB01) .and. Upper(Alltrim(SEA->EA_YLIB01)) == Upper(Alltrim(libmaster))
					Loop
				Endif
			
				// Testa se já possui duas liberações
				If !Empty(SEA->EA_YLIB01) .and. !Empty(SEA->EA_YLIB02)
					Loop
				Endif
		
				// Testa se foi rejeitado
				If !Empty(SEA->EA_YREJEIT)
					Loop
				Endif
		
				// grava em todos os titulos do bordero
				While !EOF() .and. Alltrim(EA_NUMBOR) == Alltrim(a_par1[i][5]) .AND. EA_CART == "P"

					While !RecLock("SEA",.f.,,,.T.)
						_lPare := .T.
					Enddo
					// While !RecLock("SEA",.f.);enddo
					If !a_par1[i][2]
						//SEA->EA_YREJEIT := "X"
						SEA->EA_YREJEIT := " " 
					Else
						// se for o usuário master
						If Upper(Alltrim(_cNomUsr)) == Upper(Alltrim(libmaster))
							SEA->EA_YLIB01 := _cNomUsr
						Else
							SEA->EA_YLIB02 := _cNomUsr
						Endif
							SEA->EA_YREJEIT:= Space(1)
					Endif
					MsUnlock()

					DbSkip()
				EndDo
			Endif
		Next

	End Transaction

	RpcClearEnv()

Return


/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                 ³
//³Valida a consulta³
//³                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ENDDOC*/

*---------------------------------*
Static Function ValidSXB
*---------------------------------*
	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j
	DBSelectArea("SXB") ; DBSetOrder(1)
	If dbSeek("SEA")
		Return
	Endif
	
	aAdd(aRegs,{'SEA','1','01','DB','Borderos','Borderos','Borderos','SEA',''})
	aAdd(aRegs,{'SEA','2','01','01','Bordero+Prefixo+Num','Bordero+Prefixo+Num','Bordero+Prefixo+Num'})
	aAdd(aRegs,{'SEA','4','01','01','Filial','Sucursal','Branch','EA_FILIAL',''})
	aAdd(aRegs,{'SEA','4','01','02','Bordero','Bordero','Bordero','EA_NUMBOR',''})
	aAdd(aRegs,{'SEA','4','01','03','Prefixo','Prefijo','Prefix','EA_PREFIXO',''})
	aAdd(aRegs,{'SEA','4','01','04','No. Titulo','Num. Titulo','Bill Number','EA_NUM',''})
	aAdd(aRegs,{'SEA','4','01','05','Parcela','Cuota','Installment','EA_PARCELA',''})
	aAdd(aRegs,{'SEA','4','01','06','Tipo','Tipo','Type','EA_TIPO',''})
	aAdd(aRegs,{'SEA','4','01','07','DT Bordero','Fch Bordero','Bordero Date','EA_DATABOR',''})
	aAdd(aRegs,{'SEA','4','01','08','Portador','Portador','Bearer','EA_PORTADO',''})
	aAdd(aRegs,{'SEA','4','01','09','Depositaria','Depositaria','Depositary','EA_AGEDEP',''})
	aAdd(aRegs,{'SEA','4','01','10','Fornecedor','Proveedor','Supplier','EA_FORNECE',''})
	aAdd(aRegs,{'SEA','4','01','11','Loja','Tienda','Unit','EA_LOJA',''})
	aAdd(aRegs,{'SEA','5','01','','','','','SEA->EA_NUMBOR',''})
	aAdd(aRegs,{'SEA','6','01','','','','','SEA->EA_CART="P"',''})
			

	For i:=1 to Len(aRegs)
		RecLock("SXB",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
	Next
	DBSelectArea(_sAlias)
	
		
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fLimpaSel ºAutor  ³Washington Aquino   º Data ³  26/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Limpa o browse                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Empresa do Browse                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIBOREMP                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

	*---------------------------------*
Static Function fLimpaSel(cDelPrompt)
	*---------------------------------*

	If AVISO("Atencao!","Deseja Limpar a seleção de registros da  Empresa: "+cDelPrompt+" ? ",{"Sim","Nao"}) == 1
		&("aWBrw"+Substr(cDelPrompt,1,4)) := {}
		aWBrowse2 := {}

		oWBrowse2:SetArray(aWBrowse2)

		oWBrowse2:bLine := {|| {;
			If(!Empty(aWBrowse2[oWBrowse2:nAT,16]),oCinza,;
				If(Empty(aWBrowse2[oWBrowse2:nAT,14]) .and. Empty(aWBrowse2[oWBrowse2:nAT,15]),oVerde,;
					If(Empty(aWBrowse2[oWBrowse2:nAT,14]) .or.  Empty(aWBrowse2[oWBrowse2:nAT,15]),oAzul,;
						If(!Empty(aWBrowse2[oWBrowse2:nAT,14]) .and. !Empty(aWBrowse2[oWBrowse2:nAT,15]),oVerm,;
							oCinza)))),;
							If(aWBrowse2[oWBrowse2:nAT,2],oOk,oNo),;
								aWBrowse2[oWBrowse2:nAt,3],;
								aWBrowse2[oWBrowse2:nAt,4],;
								aWBrowse2[oWBrowse2:nAt,5],;
								aWBrowse2[oWBrowse2:nAt,6],;
								aWBrowse2[oWBrowse2:nAt,7],;
								aWBrowse2[oWBrowse2:nAt,8],;
								aWBrowse2[oWBrowse2:nAt,9],;
								aWBrowse2[oWBrowse2:nAt,10],;
								aWBrowse2[oWBrowse2:nAt,11],;
								aWBrowse2[oWBrowse2:nAt,12],;
								aWBrowse2[oWBrowse2:nAt,13];
								}}
							// DoubleClick event
							oWBrowse2:bLDblClick := {|| aWBrowse2[oWBrowse2:nAt,2] := !aWBrowse2[oWBrowse2:nAt,2],;
								oWBrowse2:DrawSelect(),VldMarca()}

							oWBrowse2:Refresh()

						Endif

						Return



//***************************************************/*<-->*<-->*/*******************************************************************************//



//------------------------------------------------
Static Function fWbrReav(cPrompt)
//------------------------------------------------
	Local cPerg2 := "ReaBorEmp" + "1"
	Local aWBrowse3 := {}
	Local aBtn  := {}

	Default cPrompt := ""

// Cria grupo de perguntas

	PutSx1(cPerg2,"01","Da Data","Da Data","Da Data", "mv_ch1", "D", 8, 0, 0,"G", "", ""/*F3*/, "", "","mv_par01","","","", "","","","", "", "", "", "", "", "", "", "", "", "", "", "", "")
	PutSx1(cPerg2,"02","Ate Data","Ate Data","Ate Data", "mv_ch2", "D", 8, 0, 0,"G", "", ""/*F3*/, "", "","mv_par02","","","", "","","","", "", "", "", "", "", "", "", "", "", "", "", "", "")

	If !Pergunte(cPerg2,.T.)
		Return
	Endif


	DbSelectArea("SEA")
	DbSelectArea("SE2")
	cQuery  := "SELECT EA_FILIAL,EA_DATABOR,EA_NUMBOR,EA_PORTADO,EA_AGEDEP AGENCIA,EA_NUMCON CONTA,SUM(E2_SALDO) TOTAL,MIN(E2_VENCREA) MENORVENC,MAX(E2_VENCREA) MAIORVENC,COUNT(EA_DATABOR) AS QTDTIT,EA_YLIB01,EA_YLIB02,EA_YREJEIT "
	cQuery  += "FROM SEA"+Substr(cPrompt,1,2)+"0 EA, SE2"+Substr(cPrompt,1,2)+"0 E2 WHERE EA.D_E_L_E_T_<>'*' AND E2.D_E_L_E_T_<>'*' AND EA_CART = 'P' "
	cQuery  += "AND E2_FILIAL = EA_FILIAL AND E2_PREFIXO = EA_PREFIXO AND E2_NUM = EA_NUM AND E2_TIPO = EA_TIPO AND E2_PARCELA = EA_PARCELA AND E2_FORNECE = EA_FORNECE AND E2_LOJA = EA_LOJA "
	If IsDigit(Substr(cPrompt,3,2)) .And. Substr(cPrompt,3,2) <> "00" .and. Len(&("aWBrw"+Substr(cPrompt,1,2)+"00")) > 0
		cQuery  += "AND (EA_FILIAL = '"+Substr(cPrompt,3,2)+"' OR EA_FILIAL = '' )"
	Endif

	DbSelectArea("SEA")
	If FieldPos('EA_YLIB01') > 0 .and.  FieldPos('EA_YLIB02') > 0 .and.  FieldPos('EA_YREJEIT') > 0
		cQuery += " AND (EA_YLIB01 <> '' OR EA_YLIB02 <> '' OR EA_YREJEIT <> '')"
	Endif
	IF !Empty(mv_par02)
		cQuery += " AND EA_DATABOR BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
	ENDIF

	cQuery  += "GROUP BY EA_FILIAL,EA_DATABOR,EA_NUMBOR,EA_PORTADO,EA_AGEDEP,EA_NUMCON,EA_YLIB01,EA_YLIB02,EA_YREJEIT "
	cQuery  += "Order By EA_FILIAL,EA_DATABOR,EA_NUMBOR,EA_PORTADO "

	If Select("TRB") >0
		DbSelectArea("TRB")
		DbCloseArea()
	ENDIF
	TCQUERY cQuery ALIAS "TRB" NEW
	TcSetField("TRB","EA_DATABOR","D")
	TcSetField("TRB","MENORVENC","D")
	TcSetField("TRB","MAIORVENC","D")
	ProcRegua(TRB->(LastRec()))
	DbSelectArea("TRB")
	DbGoTop()
	If EOF()
		MsgInfo("Não registro encontrado")
		Return
	Endif
	aWBrowse3 := {}
	Do While !Eof()
		IncProc("Borderô:"+EA_NUMBOR)
		Aadd(aWBrowse3,{"",.F.,EA_FILIAL,EA_DATABOR,EA_NUMBOR,EA_PORTADO,AGENCIA,CONTA,Transform(TOTAL,"@E 999,999,999.99"),MENORVENC,MAIORVENC,QTDTIT,cPrompt,EA_YLIB01,EA_YLIB02,EA_YREJEIT})
		DbSkip()
	Enddo

	Pergunte(cPerg,.F.)

//****************** Chama a Tela *************************//

// Inclui os botoes
	AADD(aBtn,{"SELECTALL"	,{|| MarkTd2(aWBrowse3,.T.)} 					   		,"Marca"		,Nil})
	AADD(aBtn,{"UNSELECTALL"	,{|| MarkTd2(aWBrowse3,.F.)} 				   		,"Desmarca"		,Nil})
	AADD(aBtn,{"PENDENTE"	,{|| Inver2(aWBrowse3)} 						   		,"Inverte"		,Nil})
	AADD(aBtn,{"PMSPESQ"		,{|| Pesq2(aWBrowse3)} 								,"Pesquisar"	,Nil})
	AADD(aBtn,{"ALTERA"		,{|| fListTit(Left(aWBrowse3[oWBrowse3:nAt,13],2);
		+aWBrowse3[oWBrowse3:nAt,03],  ;
		aWBrowse3[oWBrowse3:nAt,05])} 	,"Visualizar"	,Nil})
	AADD(aBtn,{"OBJETIVO"	,{|| LegCh()} 										,"Legenda"	,Nil})


	DEFINE MSDIALOG _oDlgReav TITLE ("Reavaliar - "+cPrompt) FROM C(178),C(181) TO C(578),C(897) PIXEL
//EnchoiceBar(oDlg, {||Processa({||fGrava(),oDlg:End()})}, {||oDlg:End()},,aBotoes)
	EnchoiceBar(_oDlgReav, {||Processa({||fReavalia(aWBrowse3),_oDlgReav:End()})}, {||_oDlgReav:End()},,aBtn)

// Insert items here
//Aadd(aWBrowse3,{.F.,"","","","","","","","","","",""})

	@ C(117),C(010) LISTBOX oWBrowse3 Fields HEADER "","","Filial","Data","Borderô","Portador","Agencia","Conta","Total","Menor Vencimento","Maior Vencimento","Qtd.Titulos","Empresa","1o Liberação","2o Liberação","Rejeitado" Size C(340),C(077) /*c(230)*/ OF _oDlgReav PIXEL ColSizes 50,50
	oWBrowse3:SetArray(aWBrowse3)

	oWBrowse3:bLine := {|| {;
		If(!Empty(aWBrowse3[oWBrowse3:nAT,16]),oCinza,;
			If(Empty(aWBrowse3[oWBrowse3:nAT,14]) .and. Empty(aWBrowse3[oWBrowse3:nAT,15]),oVerde,;
				If(Empty(aWBrowse3[oWBrowse3:nAT,14]) .or.  Empty(aWBrowse3[oWBrowse3:nAT,15]),oAzul,;
					If(!Empty(aWBrowse3[oWBrowse3:nAT,14]) .and. !Empty(aWBrowse3[oWBrowse2:nAT,15]),oVerm,;
						oCinza)))),;
						If(aWBrowse3[oWBrowse3:nAT,2],oOk,oNo),;
							aWBrowse3[oWBrowse3:nAt,3],;
							aWBrowse3[oWBrowse3:nAt,4],;
							aWBrowse3[oWBrowse3:nAt,5],;
							aWBrowse3[oWBrowse3:nAt,6],;
							aWBrowse3[oWBrowse3:nAt,7],;
							aWBrowse3[oWBrowse3:nAt,8],;
							aWBrowse3[oWBrowse3:nAt,9],;
							aWBrowse3[oWBrowse3:nAt,10],;
							aWBrowse3[oWBrowse3:nAt,11],;
							aWBrowse3[oWBrowse3:nAt,12],;
							aWBrowse3[oWBrowse3:nAt,13],;
							aWBrowse3[oWBrowse3:nAt,14],;
							aWBrowse3[oWBrowse3:nAt,15],;
							aWBrowse3[oWBrowse3:nAt,16];
							}}

						oWBrowse3:bLDblClick := {|| aWBrowse3[oWBrowse3:nAt,2] := !aWBrowse3[oWBrowse3:nAt,2],;
							oWBrowse3:DrawSelect()}
						oWBrowse3:Refresh()

						oWBrowse3:Align := CONTROL_ALIGN_ALLCLIENT

						ACTIVATE MSDIALOG _oDlgReav CENTERED

						Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ fGrvReav   ³ Autor ³ Washington Aquino     ³ Data ³23/05/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Reavalia os borderos                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fReavalia(aWbrowse3)

	If !MsgBox("Essa rotina ira limpar todas as liberacoes existentes para os borderôs selecionados. Confirmar operacao?","Escolha","YESNO")
	Return
	EndIf

//StartJob("U_fGrvReav",GetEnvServer(), .T.,Substr(aWbrowse3[1][13],1,2),"01",aWBrowse3,Substr(cUsuario,7,15),__cUserID,03,libmaster) 
StartJob("U_fGrvReav",GetEnvServer(), .T.,Substr(aWbrowse3[1][13],1,2),"01",aWBrowse3,cUsername,__cUserID,03,libmaster)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ fGrvReav   ³ Autor ³ Washington Aquino     ³ Data ³23/05/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Reavalia os borderos                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function fGrvReav(cEmp,cFil,a_par1,_cNomUsr, __cUserID,_nOpc,libmaster)

local i
// prepara o ambiente
RpcSetType(3)
RpcSetEnv(cEmp,cFil,"","","","",{"SX3","SX2","SX5","SX6"})

	Begin Transaction

dbSelectArea("SEA")
dbSetOrder(2) //EA_FILIAL, EA_NUMBOR, EA_CART, EA_PREFIXO, EA_NUM, EA_PARCELA, EA_TIPO, EA_FORNECE, EA_LOJA, R_E_C_N_O_, D_E_L_E_T_
dbGoTop()
// ler a array
		For i:= 1 to Len(a_par1)
	//    Aadd(aWBrowse2,{.F.,"Data","Borderô","Portador","Agencia","Conta","Total","Menor Vencimento","Maior Vencimento","Qtd.Titulos"})
			If !a_par1[i][2]
		Loop
			ElseIf  dbSeek(Padr(a_par1[i][3],2)+ Padr(a_par1[i][5],6) + "P")
				Do While !EOF() .and. Alltrim(EA_NUMBOR) == Alltrim(a_par1[i][5]) .AND. EA_CART == "P"
			RecLock("SEA",.f.)
			SEA->EA_YLIB01 := Space(15)
			SEA->EA_YLIB02 := Space(15)
			SEA->EA_YREJEIT:= Space(1)
			MsUnlock()
			DbSkip()
				EndDo
			Endif
		Next

	End Transaction

RpcClearEnv()

Return

// botoes da enchoice de reavaliar

//------------------------------------------------
Static Function Pesq2(aWBrowse2)
//------------------------------------------------
Local nPosSeek
// valida a consulta
ValidSXB()

	If CONPAD1( , , , "SEA",, , .F. )
	nPosSeek := aScan(aWBrowse2,{|x| x[5]==SEA->EA_NUMBOR	})
		If nPosSeek > 1
		oWBrowse2:nAt := nPosSeek
		oWBrowse2:Refresh()
		Endif
	Endif
Return

//------------------------------------------------
Static Function MarkTd2(aWBrowse2,lFlag)

local q
//------------------------------------------------
	For q := 1 To Len(aWBrowse2)
		If aWBrowse2[q][2] != lFlag
		aWBrowse2[q][2] := lFlag
		Endif
	Next
Return
//------------------------------------------------
Static Function Inver2(aWBrowse2)

local j
//------------------------------------------------
	For j := 1 To Len(aWBrowse2)
	aWBrowse2[j][2] := !aWBrowse2[j][1]
	Next
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ >> INSERINDO LEGENDA NO MENU PRICIPAL <<                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*-----------------------------------*
Static Function LegCh()
*-----------------------------------*

Local aLegenda := { ;	
{"BR_VERDE"		, "Liberado" },; 
{"BR_AZUL"		, "Com uma liberação" },;
{"BR_VERMELHO"	, "Nao Liberado" },; 
{"BR_CINZA"	, "Rejeitado" } } 
Local uRetorno := .T.

BrwLegenda(cTitulo,"Legenda",aLegenda) //"Legenda"

Return .T.


aCores := {{ "_cTrab->COR == '42'",'ENABLE'       },;
            { "_cTrab->COR == '43'",'DISABLE'     },;
            { "_cTrab->COR == '44'",'BR_AMARELO'  }}
