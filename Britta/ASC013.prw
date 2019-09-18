#Include "TOTVS.Ch"

Static lIsRedStor := FindFunction("IsRedStor") .and. IsRedStor()
STATIC lFWCodFil 	:= FindFunction("FWCodFil")
Static _oTempTable
Static _oTempTbPLRef
Static __IsCtbJob	:= IIf( IsCtbJob(), .T., .F. )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ ASC013  ³ Autor ³ Eduardo Nunes Cirqueira ³ Data ³ 06/09/06 ³±±
±±ðÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Comparativo de Saldos de Contas com Filiais	   ³±±
±±ðÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ASC013()                               			 		   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ASC013()

	Local cMensagem
	Local lAtSlBase	   		:= Iif(	GETMV("MV_ATUSAL")=="S", .T., .F.	)
	Local lRet				:= .T.
	Local nDivide			:= 1
	Local aRetVld			:= {}
	Local lExclCT1	 		:= IIF(FindFunction("ADMTabExc"), ADMTabExc("CT1") , !Empty(xFilial("CT1") ))
	Local lExclCT2	 		:= IIF(FindFunction("ADMTabExc"), ADMTabExc("CT2") , !Empty(xFilial("CT2") ))

	Private cPerg			:= "ASC013"
	Private NomeProg		:= "ASC013"
	Private nTamValor		:= TAMSX3("CT2_VALOR")[1]

// Acesso somente pelo SIGACTB
	If lRet .And. (!AMIIn(34))
		lRet:=.F.
	EndIf

//³ Mostra tela de aviso - processar exclusivo
	cMensagem := OemToAnsi("Caso nao atualize os saldos  basicos  na")+chr(13)  		//"Caso nao atualize os saldos  basicos  na"
	cMensagem += OemToAnsi("digitacao dos lancamentos (MV_ATUSAL='N'),")+chr(13)  		//"digitacao dos lancamentos (MV_ATUSAL='N'),"
	cMensagem += OemToAnsi("rodar a rotina de atualizacao de saldos ")+chr(13)  		//"rodar a rotina de atualizacao de saldos "
	cMensagem += OemToAnsi("para todas as filiais solicitadas nesse ")+chr(13)  		//"para todas as filiais solicitadas nesse "
	cMensagem += OemToAnsi("relatorio.")+chr(13)  		//"relatorio."

	IF lRet .And. !lAtSlBase
		If !MsgYesNo(cMensagem,OemToAnsi(" ATENCAO " ))	//"ATEN€ŽO"
			lRet:=.F.
		EndIf
	Endif

	If lRet
		AtuSX1()
		Pergunte(cPerg,.T.)
	EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o plano de contas eh compartilhado.POR DEFINICAO, ³
//³ nao sera possivel emitir o relatorio com plano de contas      ³
//³ EXCLUSIVO !!!!                                   			 	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet .And. !lExclCT2
		Help("  ",1,"ASC013CT2",,"Relatório apenas pode ser executado com os lançamentos contábeis exclusivos. Por favor, verifique." ,1,0) //"Relatório apenas pode ser executado com os lançamentos contábeis exclusivos. Por favor, verifique."
		lRet := .F.
	EndIf
	If lRet
		aRetVld   := ASC013Vld()
		lRet      := aRetVld[1]
		nDivide   := aRetVld[2]
		aCtbMoeda := aRetVld[3]
	EndIf

	If lRet
		oReport := ReportDef(aCtbMoeda,nDivide)
		If !Empty( oReport:uParam )
			Pergunte( oReport:uParam, .F. )
		EndIf
		oReport:PrintDialog()
	EndIf

//Limpa os arquivos temporários
	CTBGerClean()

Return(Nil)



/*
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ReportDef º Autor ³ Eduardo Nunes      º Data ³  06/09/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ aCtbMoeda = Matriz ref. a moeda                            º±±
±±º          ³ nDivide   = Indice para divisao do valor (100,1000,1000000)º±±
±±º          ³ nPos      = Indica a posicao do digito na entidade         º±±
±±º          ³ nDigitos  = Indica quantos digitos serao filtrados         º±±
±±º          ³ lSchedule = Indica se esta executando em Schedule          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportDef(aCtbMoeda,nDivide)

Local oReport
Local oSection1
Local aTamConta	    := TAMSX3("CT1_CONTA")
Local nTamDescCta   := Len(CriaVar("CT1->CT1_DESC"+'01'))
// Local nTamDescCta := Len(CriaVar("CT1->CT1_DESC"+mv_par14))
Local aSetOfBook	:= CTBSetOf(Space(3))
// Local aSetOfBook	:= CTBSetOf(mv_par12)
Local cDesc1 		:= OemToAnsi("Este programa ira imprimir o Comparativo de Contas Contabeis de 2 ate ")	//"Este programa ira imprimir o Comparativo de Contas Contabeis de 2 ate "
Local cDesc2 		:= OemToansi(" 16 filiais. Os valores sao ref. a movimentacao do periodo solicitado. ")  //" 6 filiais. Os valores sao ref. a movimentacao do periodo solicitado. "
Local cDesc3		:= ""
Local cDescMoeda
Local cString		:= "CT1"
Local cSeparador	:= ""
Local lPrintZero	:= .T.
// Local lPrintZero	:= Iif(mv_par23==1,.T.,.F.)
Local lNormal		:= .T.
// Local lNormal	:= Iif(mv_par24==1,.T.,.F.)
Local cMascara      := ''

	If Empty(aSetOfBook[2])
	    cMascara	:= GetMv("MV_MASCARA")
	Else
	    cMascara	:= RetMasCtb(aSetOfBook[2],@cSeparador)
	EndIf

    cDescMoeda 	:= Alltrim(aCtbMoeda[2])
	If !Empty(aCtbMoeda[6])
	    cDescMoeda += OemToAnsi(" EM ") + aCtbMoeda[6]			// Indica o divisor
	EndIf

//"Comparativo  de Contas Contabeiscom Filiais"
oReport := TReport():New(NomeProg,OemToAnsi("Comparativo de Contas Contabeis com Filiais"),cPerg,{|oReport| ReportPrint(oReport,aSetOfBook,cDescMoeda,nDivide,cMascara)},cDesc1+cDesc2+cDesc3)
oReport:ParamReadOnly()
oReport:SetTotalInLine(.F.)
oReport:SetLandScape(.T.)

// Secao 1
oSection1 := TRSection():New(oReport,"Plano de Contas",{"cArqTmp","CT1"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/)	//"C O N T A"
oSection1:SetTotalInLine(.F.)

TRCell():New(oSection1,"CONTA    "	,"cArqTmp",,/*Picture*/, aTamConta[1]	,/*lPixel*/,{||	EntidadeCTB( If(lNormal .Or. cArqTmp->TIPOCONTA=="1",cArqTmp->CONTA,cArqTmp->CTARES),0,0,20,.F.,cMascara,cSeparador,,,,,.F.) })	// Codigo da Conta
TRCell():New(oSection1,"DESCRICAO"	,"cArqTmp",,/*Picture*/, nTamDescCta	,/*lPixel*/,{||	Substr(cArqTmp->DESCCTA,1,31) })	//	Descricao da Conta
TRCell():New(oSection1,"FILIAL_01"	,"cArqTmp",,/*Picture*/, nTamValor+2	,/*lPixel*/,/*{|| bloco-de-impressao }*/,"RIGHT",,"RIGHT")	//	Movimento da Filial 01
TRCell():New(oSection1,"FILIAL_02"	,"cArqTmp",,/*Picture*/, nTamValor+2	,/*lPixel*/,/*{|| bloco-de-impressao }*/,"RIGHT",,"RIGHT")	//	Movimento da Filial 02
TRCell():New(oSection1,"FILIAL_03"	,"cArqTmp",,/*Picture*/, nTamValor+2	,/*lPixel*/,/*{|| bloco-de-impressao }*/,"RIGHT",,"RIGHT")	//	Movimento da Filial 03
TRCell():New(oSection1,"FILIAL_04"	,"cArqTmp",,/*Picture*/, nTamValor+2	,/*lPixel*/,/*{|| bloco-de-impressao }*/,"RIGHT",,"RIGHT")	//	Movimento da Filial 04
TRCell():New(oSection1,"FILIAL_05"	,"cArqTmp",,/*Picture*/, nTamValor+2	,/*lPixel*/,/*{|| bloco-de-impressao }*/,"RIGHT",,"RIGHT")	//	Movimento da Filial 05
TRCell():New(oSection1,"FILIAL_06"	,"cArqTmp",,/*Picture*/, nTamValor+2	,/*lPixel*/,/*{|| bloco-de-impressao }*/,"RIGHT",,"RIGHT")	//	Movimento da Filial 06
TRCell():New(oSection1,"FILIAL_07"	,"cArqTmp",,/*Picture*/, nTamValor+2	,/*lPixel*/,/*{|| bloco-de-impressao }*/,"RIGHT",,"RIGHT")	//	Movimento da Filial 06
TRCell():New(oSection1,"FILIAL_08"	,"cArqTmp",,/*Picture*/, nTamValor+2	,/*lPixel*/,/*{|| bloco-de-impressao }*/,"RIGHT",,"RIGHT")	//	Movimento da Filial 06
TRCell():New(oSection1,"FILIAL_09"	,"cArqTmp",,/*Picture*/, nTamValor+2	,/*lPixel*/,/*{|| bloco-de-impressao }*/,"RIGHT",,"RIGHT")	//	Movimento da Filial 06
TRCell():New(oSection1,"FILIAL_10"	,"cArqTmp",,/*Picture*/, nTamValor+2	,/*lPixel*/,/*{|| bloco-de-impressao }*/,"RIGHT",,"RIGHT")	//	Movimento da Filial 06
TRCell():New(oSection1,"FILIAL_11"	,"cArqTmp",,/*Picture*/, nTamValor+2	,/*lPixel*/,/*{|| bloco-de-impressao }*/,"RIGHT",,"RIGHT")	//	Movimento da Filial 06
TRCell():New(oSection1,"FILIAL_12"	,"cArqTmp",,/*Picture*/, nTamValor+2	,/*lPixel*/,/*{|| bloco-de-impressao }*/,"RIGHT",,"RIGHT")	//	Movimento da Filial 06
TRCell():New(oSection1,"FILIAL_13"	,"cArqTmp",,/*Picture*/, nTamValor+2	,/*lPixel*/,/*{|| bloco-de-impressao }*/,"RIGHT",,"RIGHT")	//	Movimento da Filial 06
TRCell():New(oSection1,"FILIAL_14"	,"cArqTmp",,/*Picture*/, nTamValor+2	,/*lPixel*/,/*{|| bloco-de-impressao }*/,"RIGHT",,"RIGHT")	//	Movimento da Filial 06
TRCell():New(oSection1,"FILIAL_15"	,"cArqTmp",,/*Picture*/, nTamValor+2	,/*lPixel*/,/*{|| bloco-de-impressao }*/,"RIGHT",,"RIGHT")	//	Movimento da Filial 06
TRCell():New(oSection1,"FILIAL_16"	,"cArqTmp",,/*Picture*/, nTamValor+2	,/*lPixel*/,/*{|| bloco-de-impressao }*/,"RIGHT",,"RIGHT")	//	Movimento da Filial 06
TRCell():New(oSection1,"TOTAL"	  	,"cArqTmp",,/*Picture*/, nTamValor+2	,/*lPixel*/,/*{|| bloco-de-impressao }*/,"RIGHT",,"RIGHT")	//	Total da Linha

oSection1:SetHeaderPage()

Return oReport



Static Function F250Soma(nColuna,cSegAte)

    Local cCampo 	:= "COLUNA"+Str(nColuna,1)
    Local nRetorno	:= 0
    Local nPosCpo 	:= cArqTmp->(FieldPos(cCampo))

	If nPosCpo > 0
        // If mv_par11 == 1					// So imprime Sinteticas - Soma Sinteticas
        //     If cArqTmp->TIPOCONTA == "1" .And. cArqTmp->NIVEL1
        //         nRetorno := cArqTmp->(FieldGet(nPosCpo))
        //     EndIf
        // Else									// Soma Analiticas
		If Empty(cSegAte)			//	Se nao tiver filtragem ate o nivel
			If cArqTmp->TIPOCONTA == "2"
                    nRetorno := cArqTmp->(FieldGet(nPosCpo))
			EndIf
		Else							//Se tiver filtragem, somo somente as sinteticas
			If cArqTmp->TIPOCONTA == "1" .And. cArqTmp->NIVEL1
                    nRetorno := cArqTmp->(FieldGet(nPosCpo))
			EndIf
		Endif
        // EndIf
	EndIf

Return nRetorno



// Faz a filtragem para impressao, validando o registro
Static Function F250Fil(cSegAte,nDigitAte)
    Local lDeixa	:= .T.

    // If mv_par11 == 1					// So imprime Sinteticas
    //     If cArqTmp->TIPOCONTA == "2"
    //         lDeixa	:= .F.
    //     EndIf
    // ElseIf mv_par11 == 2				// So imprime Analiticas
    //     If cArqTmp->TIPOCONTA == "1"
    //         lDeixa	:= .F.
    //     EndIf
    // EndIf

    //Filtragem ate o Segmento ( antigo nivel do SIGACON)
	If lDeixa .And. !Empty(cSegAte)
		If Len(Alltrim(cArqTmp->CONTA)) > nDigitAte
            lDeixa	:= .F.
		Endif
	EndIf

	If lDeixa .And. (	Abs(cArqTmp->COLUNA1)+Abs(cArqTmp->COLUNA2)+Abs(cArqTmp->COLUNA3)+Abs(cArqTmp->COLUNA4)+Abs(cArqTmp->COLUNA5)+Abs(cArqTmp->COLUNA6)	+;
    Abs(cArqTmp->COLUNA7)+Abs(cArqTmp->COLUNA8)+Abs(cArqTmp->COLUNA9)+Abs(cArqTmp->COLUNA10)+Abs(cArqTmp->COLUNA11)+Abs(cArqTmp->COLUNA12)+Abs(cArqTmp->COLUNA13)+;
    Abs(cArqTmp->COLUNA14)+Abs(cArqTmp->COLUNA15)+Abs(cArqTmp->COLUNA16)) == 0
    // If lDeixa .And. (	Abs(cArqTmp->COLUNA1)+Abs(cArqTmp->COLUNA2)+Abs(cArqTmp->COLUNA3)+Abs(cArqTmp->COLUNA4)+Abs(cArqTmp->COLUNA5)+Abs(cArqTmp->COLUNA6)	) == 0

		If mv_par05 == 2					// Saldos Zerados nao serao impressos
        // If mv_par13 == 2					// Saldos Zerados nao serao impressos
			lDeixa	:= .F.
		ElseIf mv_par05 == 1				//	Se imprime saldos zerados, verificar a data de existencia da entidade
        // ElseIf mv_par13 == 1				//	Se imprime saldos zerados, verificar a data de existencia da entidade
			If CtbExDtFim("CT1")
                dbSelectArea("CT1")
                dbSetOrder(1)
				If MsSeek(xFilial()+cArqTmp->CONTA)
					If !CtbVlDtFim("CT1",mv_par01)
                        lDeixa	:= .F.
					EndIf
				EndIf
                dbSelectArea("cArqTmp")
                dbSetOrder(1)
			EndIf
		EndIf

	EndIf

Return lDeixa



// Definicao do objeto do relatorio personalizavel e das secoes que serao utilizadas
Static Function ReportPrint(oReport,aSetOfBook,cDescMoeda,nDivide,cMascara)

    Local oSection1 	:= oReport:Section(1)
    Local cFiltro		:= oSection1:GetAdvplExp()  /*aReturn[7]*/
    Local oBreakGrupo
    Local oBreak

    Local oTotFil1, oTotFil2, oTotFil3, oTotFil4, oTotFil5, oTotFil6, oTotFil7, oTotFil8, oTotFil9, oTotFil10, oTotFil11, oTotFil12, oTotFil13, oTotFil14, oTotFil15, oTotFil16, oTotGeral
    Local nTotFil1, nTotFil2, nTotFil3, nTotFil4, nTotFil5, nTotFil6, nTotFil7, nTotFil8, nTotFil9, nTotFil10, nTotFil11, nTotFil12, nTotFil13, nTotFil14, nTotFil15, nTotFil16, nTotGeral

    Local oTotGrp1, oTotGrp2, oTotGrp3, oTotGrp4, oTotGrp5, oTotGrp6, oTotGrp7, oTotGrp8, oTotGrp9, oTotGrp10, oTotGrp11, oTotGrp12, oTotGrp13, oTotGrp14, oTotGrp15, oTotGrp16, oTotGrpGeral
    Local nTotGrp1, nTotGrp2, nTotGrp3, nTotGrp4, nTotGrp5, nTotGrp6, nTotGrp7, nTotGrp8, nTotGrp9, nTotGrp10, nTotGrp11, nTotGrp12, nTotGrp13, nTotGrp14, nTotGrp15, nTotGrp16, nTotGrpGeral

    Local bLineCond
    Local lImprime

    Local cArqTmp
    Local cGrupo		:= ""
    Local cGrupoAnt		:= ""
    Local cTipoAnt		:= ""

    Local lPula			:= .T.
    // Local lPula			:= Iif(mv_par22==1,.T.,.F.)
    Local lPrintZero	:= .T.
    // Local lPrintZero	:= Iif(mv_par23==1,.T.,.F.)
    Local cSegAte 	   := Space(2)		// Imprimir ate o Segmento?
    // Local cSegAte 	   := mv_par26		// Imprimir ate o Segmento?
    Local nDigitAte	:= 0
    Local lImpAntLP	:= .F.
    // Local lImpAntLP	:= Iif(mv_par27 == 1,.T.,.F.)
    Local dDataLP		:= ctod('')
    // Local dDataLP		:= mv_par28
    Local cPicture		:= aSetOfBook[4]
    Local nDecimais 	:= DecimalCTB(aSetOfBook,'01')
    // Local nDecimais 	:= DecimalCTB(aSetOfBook,mv_par14)

    Local nCont
    Local cPergFil
    Local nPergFil		:= 4 //Definido com 4, porque a primeira perg. de filial eh o mv_par05
    Local aFiliais		:= {}
    Local aDescFil		:= {}
    Local Titulo		:= ""
    Local lRet        := .T.
    Local aRetVld     := {}
    Local cDescFil		:= ""
    Local aAreaSM0		:= SM0->(GetArea())
    Local aFilAux     := {}
    Local iX          := 1
    Local cFilantAux  := ""

//³Controle de numeraçðo de pagina para o relatorio personalizado³

    Private nPagIni		:= 0 // parametro da pagina inicial
    // Private nPagIni		:= MV_PAR15 // parametro da pagina inicial
    Private nPagFim		:= 999999 	// parametro da pagina final
    Private nReinicia	:= 0    	// parametro de reinicio de pagina
    Private l1StQb		:= .T.		// primeira quebra
    Private lNewVars	:= .T.		// inicializa as variaveis
    Private m_pag		:= 0 // controle de numeraçðo de pagina
    // Private m_pag		:= MV_PAR15 // controle de numeraçðo de pagina
    Private nBloco      := 1		// controle do bloco a ser impresso
    Private nBlCount	:= 0		// contador do bloco impresso

	If lRet
        aRetVld   := ASC013Vld()
        lRet      := aRetVld[1]
        nDivide   := aRetVld[2]
        aCtbMoeda := aRetVld[3]
	EndIf

	If lRet
        cDescMoeda 	:= Alltrim(aCtbMoeda[2])
		If !Empty(aCtbMoeda[6])
            cDescMoeda += OemToAnsi(" EM ") + aCtbMoeda[6]			// Indica o divisor
		EndIf
	EndIf

	If !lRet
        oReport:CancelPrint()
        Return
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If OREPORT:CTITLE != OemToAnsi("Comparativo de Contas Contabeis com Filiais")
        Titulo:= oReport:cTitle    + " "
    // ElseIf mv_par11 == 1
    //     Titulo:=	OemToAnsi("COMPARATIVO DE FILIAIS SINTETICO DE ")	//"COMPARATIVO DE FILIAIS SINTETICO DE "
    // ElseIf mv_par11 == 2
    //     Titulo:=	OemToAnsi("COMPARATIVO DE FILIAIS ANALITICO DE ")	//"COMPARATIVO DE FILIAIS ANALITICO DE "
    // ElseIf mv_par11 == 3
	Else
        Titulo:=	OemToAnsi("COMPARATIVO DE ")	//"COMPARATIVO DE "
	EndIf

    Titulo += 	DTOC(mv_par01) + OemToAnsi(" ATE ") + Dtoc(mv_par02) + OemToAnsi(" EM ") + cDescMoeda

    oReport:SetPageNumber( 0 )
    // oReport:SetPageNumber( MV_PAR15 )
    oReport:SetCustomText( {|| CtCGCCabTR(,,,,,dDatabase,titulo,,,,,oReport) } )

    // If mv_par16 > "1"
        // Titulo += " (" + Tabela("SL", mv_par16, .F.) + ")"
    // Endif

    aFiliais   := {"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16"}
    cFilAntAux := cFilAnt

	For nCont := 1 to Len(aFiliais)
		If (!Empty(aFiliais[nCont]))
			If FindFunction("FWFilialName")
                cDescFil := FWFilialName(cEmpAnt, aFiliais[nCont], 1)
			Else
                SM0->(MsSeek(cEmpAnt+Subs(aFiliais[nCont],1,2)))
                cDescFil := SM0->M0_FILIAL
			EndIf
			If !Empty(cDescFil)
                AADD(aDescFil,cDescFil)
			Else
                AADD(aDescFil,Space(15))
			EndIf
            cFilAnt := aFiliais[nCont]
            AADD(aFilAux, xFilial("CT7"))
		Else
            AADD(aDescFil,Space(15))
            AADD(aFilAux, Space(Len(xFilial("CT7"))))
		EndIf
	Next

    cFilAnt := cFilantAux

    bLineCond	:= {|| F250Fil( cSegAte,nDigitAte ) }

// Setando os titulos das celulas
    oSection1:Cell("CONTA    "):SetTitle("CODIGO")
    oSection1:Cell("DESCRICAO"):SetTitle("DESCRICAO")
    oSection1:Cell("FILIAL_01"):SetTitle("     "+"DESCRICAO"+" 01"	+Iif(!Empty(aDescFil[1]),CRLF+aDescFil[1],""))
    oSection1:Cell("FILIAL_02"):SetTitle("     "+"DESCRICAO"+" 02"	+Iif(!Empty(aDescFil[2]),CRLF+aDescFil[2],""))
    oSection1:Cell("FILIAL_03"):SetTitle("     "+"DESCRICAO"+" 03"	+Iif(!Empty(aDescFil[3]),CRLF+aDescFil[3],""))
    oSection1:Cell("FILIAL_04"):SetTitle("     "+"DESCRICAO"+" 04"	+Iif(!Empty(aDescFil[4]),CRLF+aDescFil[4],""))
    oSection1:Cell("FILIAL_05"):SetTitle("     "+"DESCRICAO"+" 05"	+Iif(!Empty(aDescFil[5]),CRLF+aDescFil[5],""))
    oSection1:Cell("FILIAL_06"):SetTitle("     "+"DESCRICAO"+" 06"	+Iif(!Empty(aDescFil[6]),CRLF+aDescFil[6],""))
    oSection1:Cell("FILIAL_07"):SetTitle("     "+"DESCRICAO"+" 07"	+Iif(!Empty(aDescFil[7]),CRLF+aDescFil[7],""))
    oSection1:Cell("FILIAL_08"):SetTitle("     "+"DESCRICAO"+" 08"	+Iif(!Empty(aDescFil[8]),CRLF+aDescFil[8],""))
    oSection1:Cell("FILIAL_09"):SetTitle("     "+"DESCRICAO"+" 09"	+Iif(!Empty(aDescFil[9]),CRLF+aDescFil[9],""))
    oSection1:Cell("FILIAL_10"):SetTitle("     "+"DESCRICAO"+" 10"	+Iif(!Empty(aDescFil[10]),CRLF+aDescFil[10],""))
    oSection1:Cell("FILIAL_11"):SetTitle("     "+"DESCRICAO"+" 11"	+Iif(!Empty(aDescFil[11]),CRLF+aDescFil[11],""))
    oSection1:Cell("FILIAL_12"):SetTitle("     "+"DESCRICAO"+" 12"	+Iif(!Empty(aDescFil[12]),CRLF+aDescFil[12],""))
    oSection1:Cell("FILIAL_13"):SetTitle("     "+"DESCRICAO"+" 13"	+Iif(!Empty(aDescFil[13]),CRLF+aDescFil[13],""))
    oSection1:Cell("FILIAL_14"):SetTitle("     "+"DESCRICAO"+" 14"	+Iif(!Empty(aDescFil[14]),CRLF+aDescFil[14],""))
    oSection1:Cell("FILIAL_15"):SetTitle("     "+"DESCRICAO"+" 15"	+Iif(!Empty(aDescFil[15]),CRLF+aDescFil[15],""))
    oSection1:Cell("FILIAL_16"):SetTitle("     "+"DESCRICAO"+" 16"	+Iif(!Empty(aDescFil[16]),CRLF+aDescFil[16],""))

    oSection1:Cell("TOTAL"):SetTitle("     "+"TOTAL GERAL")

    oSection1:Cell("FILIAL_01"):SetBlock({|| ValorCTB(cArqTmp->COLUNA1,,,nTamValor,nDecimais,CtbSinalMov(),cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)})	//	Movimento da Filial 01
    oSection1:Cell("FILIAL_02"):SetBlock({|| ValorCTB(cArqTmp->COLUNA2,,,nTamValor,nDecimais,CtbSinalMov(),cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)})	//	Movimento da Filial 02
    oSection1:Cell("FILIAL_03"):SetBlock({|| ValorCTB(cArqTmp->COLUNA3,,,nTamValor,nDecimais,CtbSinalMov(),cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)})	//	Movimento da Filial 03
    oSection1:Cell("FILIAL_04"):SetBlock({|| ValorCTB(cArqTmp->COLUNA4,,,nTamValor,nDecimais,CtbSinalMov(),cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)})	//	Movimento da Filial 04
    oSection1:Cell("FILIAL_05"):SetBlock({|| ValorCTB(cArqTmp->COLUNA5,,,nTamValor,nDecimais,CtbSinalMov(),cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)})	//	Movimento da Filial 05
    oSection1:Cell("FILIAL_06"):SetBlock({|| ValorCTB(cArqTmp->COLUNA6,,,nTamValor,nDecimais,CtbSinalMov(),cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)})	//	Movimento da Filial 06
    oSection1:Cell("FILIAL_07"):SetBlock({|| ValorCTB(cArqTmp->COLUNA7,,,nTamValor,nDecimais,CtbSinalMov(),cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)})	//	Movimento da Filial 07
    oSection1:Cell("FILIAL_08"):SetBlock({|| ValorCTB(cArqTmp->COLUNA8,,,nTamValor,nDecimais,CtbSinalMov(),cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)})	//	Movimento da Filial 08
    oSection1:Cell("FILIAL_09"):SetBlock({|| ValorCTB(cArqTmp->COLUNA9,,,nTamValor,nDecimais,CtbSinalMov(),cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)})	//	Movimento da Filial 09
    oSection1:Cell("FILIAL_10"):SetBlock({|| ValorCTB(cArqTmp->COLUNA10,,,nTamValor,nDecimais,CtbSinalMov(),cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)})	//	Movimento da Filial 10
    oSection1:Cell("FILIAL_11"):SetBlock({|| ValorCTB(cArqTmp->COLUNA11,,,nTamValor,nDecimais,CtbSinalMov(),cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)})	//	Movimento da Filial 11
    oSection1:Cell("FILIAL_12"):SetBlock({|| ValorCTB(cArqTmp->COLUNA12,,,nTamValor,nDecimais,CtbSinalMov(),cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)})	//	Movimento da Filial 12
    oSection1:Cell("FILIAL_13"):SetBlock({|| ValorCTB(cArqTmp->COLUNA13,,,nTamValor,nDecimais,CtbSinalMov(),cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)})	//	Movimento da Filial 13
    oSection1:Cell("FILIAL_14"):SetBlock({|| ValorCTB(cArqTmp->COLUNA14,,,nTamValor,nDecimais,CtbSinalMov(),cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)})	//	Movimento da Filial 14
    oSection1:Cell("FILIAL_15"):SetBlock({|| ValorCTB(cArqTmp->COLUNA15,,,nTamValor,nDecimais,CtbSinalMov(),cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)})	//	Movimento da Filial 15
    oSection1:Cell("FILIAL_16"):SetBlock({|| ValorCTB(cArqTmp->COLUNA16,,,nTamValor,nDecimais,CtbSinalMov(),cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)})	//	Movimento da Filial 16

    oSection1:Cell("TOTAL"):SetBlock({|| ValorCTB(cArqTmp->(COLUNA1 + COLUNA2 + COLUNA3 + COLUNA4 + COLUNA5 + COLUNA6 + COLUNA7 + COLUNA8 + COLUNA9 + COLUNA10 + COLUNA11 + COLUNA12 + COLUNA13 + COLUNA14 + COLUNA15 + COLUNA16 ),,,nTamValor,nDecimais,CtbSinalMov(),cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)})	//	Total da Linha

    oSection1:OnPrintLine( {|| ( IIf(lPula .And. cTipoAnt == "1" ,oReport:SkipLine(),NIL) ) } )

    oBreak:= TRBreak():New(oReport, {|| .T. }, "T O T A I S  D O  P E R I O D O: " )  //"T O T A I S  D O  P E R I O D O: "

    // If mv_par17 == 1				// Grupo Diferente
        oBreakGrupo := TRBreak():New(oSection1, {|| cArqTMP->GRUPO },{||"Grupo "+": "+cGrupoAnt })  //"Grupo "
        oBreakGrupo:SetPageBreak()
    // EndIf

// Total da Filial 1
    oTotFil1 :=	TRFunction():New(oSection1:Cell("FILIAL_01"),nil,"SUM"		,oBreak,/*Titulo*/,/*cPicture*/,{ || F250Soma(1,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_01"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil1 := oTotFil1:GetValue(),StrTran(ValorCTB(nTotFil1,,,nTamValor+Iif(nTotFil1==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_01"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil1 := oTotFil1:GetValue(),ValorCTB(nTotFil1,,,nTamValor+Iif(nTotFil1==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	Endif
    oTotFil1:Disable()

// Total da Filial 2
    oTotFil2 :=	TRFunction():New(oSection1:Cell("FILIAL_02"),nil,"SUM"		,oBreak,/*Titulo*/,/*cPicture*/,{ || F250Soma(2,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_02"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil2 := oTotFil2:GetValue(), StrTran(ValorCTB(nTotFil2,,,nTamValor+Iif(nTotFil2==0,2,0),nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_02"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil2 := oTotFil2:GetValue(), ValorCTB(nTotFil2,,,nTamValor+Iif(nTotFil2==0,2,0),nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotFil2:Disable()

// Total da Filial 3
    oTotFil3 :=	TRFunction():New(oSection1:Cell("FILIAL_03"),nil,"SUM"		,oBreak,/*Titulo*/,/*cPicture*/,{ || F250Soma(3,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_03"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil3 := oTotFil3:GetValue(),StrTran(ValorCTB(nTotFil3,,,nTamValor+Iif(nTotFil3==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_03"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil3 := oTotFil3:GetValue(),ValorCTB(nTotFil3,,,nTamValor+Iif(nTotFil3==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF

    oTotFil3:Disable()

// Total da Filial 4
    oTotFil4 :=	TRFunction():New(oSection1:Cell("FILIAL_04"),nil,"SUM"		,oBreak,/*Titulo*/,/*cPicture*/,{ || F250Soma(4,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_04"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil4 := oTotFil4:GetValue(),StrTran(ValorCTB(nTotFil4,,,nTamValor+Iif(nTotFil4==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_04"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil4 := oTotFil4:GetValue(),ValorCTB(nTotFil4,,,nTamValor+Iif(nTotFil4==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotFil4:Disable()

// Total da Filial 5
    oTotFil5 :=	TRFunction():New(oSection1:Cell("FILIAL_05"),nil,"SUM"		,oBreak,/*Titulo*/,/*cPicture*/,{ || F250Soma(5,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_05"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil5 := oTotFil5:GetValue(),StrTran(ValorCTB(nTotFil5,,,nTamValor+Iif(nTotFil5==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_05"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil5 := oTotFil5:GetValue(),ValorCTB(nTotFil5,,,nTamValor+Iif(nTotFil5==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF

    oTotFil5:Disable()

// Total da Filial 6
    oTotFil6 :=	TRFunction():New(oSection1:Cell("FILIAL_06"),nil,"SUM"		,oBreak,/*Titulo*/,/*cPicture*/,{ || F250Soma(6,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_06"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil6 := oTotFil6:GetValue(),StrTran(ValorCTB(nTotFil6,,,nTamValor+Iif(nTotFil6==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_06"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil6 := oTotFil6:GetValue(),ValorCTB(nTotFil6,,,nTamValor+Iif(nTotFil6==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotFil6:Disable()

// Total da Filial 7
    oTotFil7 :=	TRFunction():New(oSection1:Cell("FILIAL_07"),nil,"SUM"		,oBreak,/*Titulo*/,/*cPicture*/,{ || F250Soma(7,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_07"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil7 := oTotFil6:GetValue(),StrTran(ValorCTB(nTotFil7,,,nTamValor+Iif(nTotFil7==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_07"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil7 := oTotFil7:GetValue(),ValorCTB(nTotFil7,,,nTamValor+Iif(nTotFil7==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotFil7:Disable()

// Total da Filial 8
    oTotFil8 :=	TRFunction():New(oSection1:Cell("FILIAL_08"),nil,"SUM"		,oBreak,/*Titulo*/,/*cPicture*/,{ || F250Soma(8,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_08"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil8 := oTotFil8:GetValue(),StrTran(ValorCTB(nTotFil8,,,nTamValor+Iif(nTotFil8==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_08"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil8 := oTotFil6:GetValue(),ValorCTB(nTotFil8,,,nTamValor+Iif(nTotFil8==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotFil8:Disable()

// Total da Filial 9
    oTotFil9 :=	TRFunction():New(oSection1:Cell("FILIAL_09"),nil,"SUM"		,oBreak,/*Titulo*/,/*cPicture*/,{ || F250Soma(9,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_09"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil9 := oTotFil9:GetValue(),StrTran(ValorCTB(nTotFil9,,,nTamValor+Iif(nTotFil9==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_09"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil9 := oTotFil6:GetValue(),ValorCTB(nTotFil9,,,nTamValor+Iif(nTotFil9==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotFil9:Disable()

// Total da Filial 10
    oTotFil10 :=	TRFunction():New(oSection1:Cell("FILIAL_10"),nil,"SUM"		,oBreak,/*Titulo*/,/*cPicture*/,{ || F250Soma(10,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_10"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil10 := oTotFil10:GetValue(),StrTran(ValorCTB(nTotFil10,,,nTamValor+Iif(nTotFil10==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_10"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil10 := oTotFil6:GetValue(),ValorCTB(nTotFil10,,,nTamValor+Iif(nTotFil10==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotFil10:Disable()

// Total da Filial 11
    oTotFil11 :=	TRFunction():New(oSection1:Cell("FILIAL_11"),nil,"SUM"		,oBreak,/*Titulo*/,/*cPicture*/,{ || F250Soma(11,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_11"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil11 := oTotFil11:GetValue(),StrTran(ValorCTB(nTotFil11,,,nTamValor+Iif(nTotFil11==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_11"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil11 := oTotFil6:GetValue(),ValorCTB(nTotFil11,,,nTamValor+Iif(nTotFil11==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotFil11:Disable()

// Total da Filial 12
    oTotFil12 :=	TRFunction():New(oSection1:Cell("FILIAL_12"),nil,"SUM"		,oBreak,/*Titulo*/,/*cPicture*/,{ || F250Soma(12,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_12"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil12 := oTotFil12:GetValue(),StrTran(ValorCTB(nTotFil12,,,nTamValor+Iif(nTotFil12==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_12"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil12 := oTotFil6:GetValue(),ValorCTB(nTotFil12,,,nTamValor+Iif(nTotFil12==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotFil12:Disable()

// Total da Filial 13
    oTotFil13 :=	TRFunction():New(oSection1:Cell("FILIAL_13"),nil,"SUM"		,oBreak,/*Titulo*/,/*cPicture*/,{ || F250Soma(13,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_13"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil13 := oTotFil13:GetValue(),StrTran(ValorCTB(nTotFil13,,,nTamValor+Iif(nTotFil13==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_13"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil13 := oTotFil6:GetValue(),ValorCTB(nTotFil13,,,nTamValor+Iif(nTotFil13==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotFil13:Disable()

// Total da Filial 14
    oTotFil14 :=	TRFunction():New(oSection1:Cell("FILIAL_14"),nil,"SUM"		,oBreak,/*Titulo*/,/*cPicture*/,{ || F250Soma(14,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_14"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil14 := oTotFil14:GetValue(),StrTran(ValorCTB(nTotFil14,,,nTamValor+Iif(nTotFil14==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_14"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil14 := oTotFil6:GetValue(),ValorCTB(nTotFil14,,,nTamValor+Iif(nTotFil14==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotFil14:Disable()

// Total da Filial 15
    oTotFil15 :=	TRFunction():New(oSection1:Cell("FILIAL_15"),nil,"SUM"		,oBreak,/*Titulo*/,/*cPicture*/,{ || F250Soma(15,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_15"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil15 := oTotFil15:GetValue(),StrTran(ValorCTB(nTotFil15,,,nTamValor+Iif(nTotFil15==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_15"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
            { || (nTotFil15 := oTotFil6:GetValue(),ValorCTB(nTotFil15,,,nTamValor+Iif(nTotFil15==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotFil15:Disable()

// Total da Filial 16
    // oTotFil16 :=	TRFunction():New(oSection1:Cell("FILIAL_016"),nil,"SUM"		,oBreak,/*Titulo*/,/*cPicture*/,{ || F250Soma(16,cSegAte) },.F.,.F.,.F.,oSection1)
    // If lIsRedStor
    //     TRFunction():New(oSection1:Cell("FILIAL_16"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
    //         { || (nTotFil16 := oTotFil16:GetValue(),StrTran(ValorCTB(nTotFil16,,,nTamValor+Iif(nTotFil16==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
    // Else
    //     TRFunction():New(oSection1:Cell("FILIAL_16"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,;
    //         { || (nTotFil16 := oTotFil6:GetValue(),ValorCTB(nTotFil16,,,nTamValor+Iif(nTotFil16==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
    // EndIF
    // oTotFil16:Disable()

// Total Geral
    oTotGeral := TRFunction():New(oSection1:Cell("TOTAL"),nil,"SUM"		,oBreak,/*Titulo*/,/*cPicture*/,{ ||F250Soma(1,cSegAte) + F250Soma(2,cSegAte) + F250Soma(3,cSegAte) + F250Soma(4,cSegAte) + F250Soma(5,cSegAte) + F250Soma(6,cSegAte)+ F250Soma(7,cSegAte)+ F250Soma(8,cSegAte)+ F250Soma(9,cSegAte)+ F250Soma(10,cSegAte)+ F250Soma(11,cSegAte)+ F250Soma(12,cSegAte)+ F250Soma(13,cSegAte)+ F250Soma(14,cSegAte)+ F250Soma(15,cSegAte)+ F250Soma(16,cSegAte)},.F.,.F.,.F.,oSection1)

	If lIsRedStor
        TRFunction():New(oSection1:Cell("TOTAL"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,{ || (nTotGeral := oTotGeral:GetValue(),;
            StrTran(ValorCTB(nTotGeral,,,nTamValor+Iif(nTotGeral==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("TOTAL"),nil,"ONPRINT"	,oBreak,/*Titulo*/,/*cPicture*/,{ || (nTotGeral := oTotGeral:GetValue(),;
            ValorCTB(nTotGeral,,,nTamValor+Iif(nTotGeral==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF

// Desabilitando, pois a quebra sera feita pelo oBreak

    oTotGeral:Disable()

// Total Grupo Filial 01
    oTotGrp1	:=	TRFunction():New(oSection1:Cell("FILIAL_01"),nil,"SUM"		,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || F250Soma(1,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_01"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp1 := iif(oTotGrp1:GetValue()==nil,0,oTotGrp1:GetValue()),StrTran(ValorCTB(nTotGrp1,,,nTamValor+Iif(nTotGrp1==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_01"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp1 := iif(oTotGrp1:GetValue()==nil,0,oTotGrp1:GetValue()),ValorCTB(nTotGrp1,,,nTamValor+Iif(nTotGrp1==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotGrp1:Disable()

// Total Grupo Filial 02
    oTotGrp2 :=	TRFunction():New(oSection1:Cell("FILIAL_02"),nil,"SUM"		,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || F250Soma(2,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_02"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp2 := iif(oTotGrp2:GetValue()==nil,0,oTotGrp2:GetValue()),StrTran(ValorCTB(nTotGrp2,,,nTamValor+Iif(nTotGrp2==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_02"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp2 := iif(oTotGrp2:GetValue()==nil,0,oTotGrp2:GetValue()),ValorCTB(nTotGrp2,,,nTamValor+Iif(nTotGrp2==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotGrp2:Disable()

// Total Grupo Filial 03
    oTotGrp3 :=	TRFunction():New(oSection1:Cell("FILIAL_03"),nil,"SUM"		,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || F250Soma(3,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_03"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp3 := iif(oTotGrp3:GetValue()==nil,0,oTotGrp3:GetValue()),StrTran(ValorCTB(nTotGrp3,,,nTamValor+Iif(nTotGrp3==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_03"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp3 := iif(oTotGrp3:GetValue()==nil,0,oTotGrp3:GetValue()),ValorCTB(nTotGrp3,,,nTamValor+Iif(nTotGrp3==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotGrp3:Disable()

// Total Grupo Filial 04
    oTotGrp4 :=	TRFunction():New(oSection1:Cell("FILIAL_04"),nil,"SUM"		,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || F250Soma(4,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_04"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp4 := iif(oTotGrp4:GetValue()==nil,0,oTotGrp4:GetValue()),StrTran(ValorCTB(nTotGrp4,,,nTamValor+Iif(nTotGrp4==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_04"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp4 := iif(oTotGrp4:GetValue()==nil,0,oTotGrp4:GetValue()),ValorCTB(nTotGrp4,,,nTamValor+Iif(nTotGrp4==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotGrp4:Disable()

// Total Grupo Filial 05
    oTotGrp5 :=	TRFunction():New(oSection1:Cell("FILIAL_05"),nil,"SUM"		,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || F250Soma(5,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_05"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp5 := iif(oTotGrp5:GetValue()==nil,0,oTotGrp5:GetValue()),StrTran(ValorCTB(nTotGrp5,,,nTamValor+Iif(nTotGrp5==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_05"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp5 := iif(oTotGrp5:GetValue()==nil,0,oTotGrp5:GetValue()),ValorCTB(nTotGrp5,,,nTamValor+Iif(nTotGrp5==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotGrp5:Disable()

// Total Grupo Filial 06
    oTotGrp6 :=	TRFunction():New(oSection1:Cell("FILIAL_06"),nil,"SUM"		,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || F250Soma(6,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_06"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp6 := iif(oTotGrp6:GetValue()==nil,0,oTotGrp6:GetValue()),StrTran(ValorCTB(nTotGrp6,,,nTamValor+Iif(nTotGrp6==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_06"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp6 := iif(oTotGrp6:GetValue()==nil,0,oTotGrp6:GetValue()),ValorCTB(nTotGrp6,,,nTamValor+Iif(nTotGrp6==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotGrp6:Disable()

// Total Grupo Filial 07
    oTotGrp7 :=	TRFunction():New(oSection1:Cell("FILIAL_07"),nil,"SUM"		,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || F250Soma(7,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_07"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp7 := iif(oTotGrp7:GetValue()==nil,0,oTotGrp7:GetValue()),StrTran(ValorCTB(nTotGrp7,,,nTamValor+Iif(nTotGrp7==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_07"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp7 := iif(oTotGrp7:GetValue()==nil,0,oTotGrp7:GetValue()),ValorCTB(nTotGrp7,,,nTamValor+Iif(nTotGrp7==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotGrp7:Disable()

// Total Grupo Filial 08
    oTotGrp8 :=	TRFunction():New(oSection1:Cell("FILIAL_08"),nil,"SUM"		,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || F250Soma(8,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_08"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp8 := iif(oTotGrp8:GetValue()==nil,0,oTotGrp8:GetValue()),StrTran(ValorCTB(nTotGrp8,,,nTamValor+Iif(nTotGrp8==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_08"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp8 := iif(oTotGrp8:GetValue()==nil,0,oTotGrp8:GetValue()),ValorCTB(nTotGrp8,,,nTamValor+Iif(nTotGrp8==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotGrp8:Disable()

// Total Grupo Filial 09
    oTotGrp9 :=	TRFunction():New(oSection1:Cell("FILIAL_09"),nil,"SUM"		,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || F250Soma(9,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_09"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp9 := iif(oTotGrp9:GetValue()==nil,0,oTotGrp9:GetValue()),StrTran(ValorCTB(nTotGrp9,,,nTamValor+Iif(nTotGrp9==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_09"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp9 := iif(oTotGrp9:GetValue()==nil,0,oTotGrp9:GetValue()),ValorCTB(nTotGrp9,,,nTamValor+Iif(nTotGrp9==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotGrp9:Disable()

// Total Grupo Filial 10
    oTotGrp10 :=	TRFunction():New(oSection1:Cell("FILIAL_10"),nil,"SUM"		,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || F250Soma(10,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_10"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp10 := iif(oTotGrp10:GetValue()==nil,0,oTotGrp10:GetValue()),StrTran(ValorCTB(nTotGrp10,,,nTamValor+Iif(nTotGrp10==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_10"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp10 := iif(oTotGrp10:GetValue()==nil,0,oTotGrp10:GetValue()),ValorCTB(nTotGrp10,,,nTamValor+Iif(nTotGrp10==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotGrp10:Disable()

// Total Grupo Filial 11
    oTotGrp11 :=	TRFunction():New(oSection1:Cell("FILIAL_11"),nil,"SUM"		,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || F250Soma(11,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_11"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp11 := iif(oTotGrp11:GetValue()==nil,0,oTotGrp11:GetValue()),StrTran(ValorCTB(nTotGrp11,,,nTamValor+Iif(nTotGrp11==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_11"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp11 := iif(oTotGrp11:GetValue()==nil,0,oTotGrp11:GetValue()),ValorCTB(nTotGrp11,,,nTamValor+Iif(nTotGrp11==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotGrp11:Disable()

// Total Grupo Filial 12
    oTotGrp12 :=	TRFunction():New(oSection1:Cell("FILIAL_12"),nil,"SUM"		,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || F250Soma(12,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_12"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp12 := iif(oTotGrp12:GetValue()==nil,0,oTotGrp12:GetValue()),StrTran(ValorCTB(nTotGrp12,,,nTamValor+Iif(nTotGrp12==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_12"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp12 := iif(oTotGrp12:GetValue()==nil,0,oTotGrp12:GetValue()),ValorCTB(nTotGrp12,,,nTamValor+Iif(nTotGrp12==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotGrp12:Disable()


// Total Grupo Filial 13
    oTotGrp13 :=	TRFunction():New(oSection1:Cell("FILIAL_13"),nil,"SUM"		,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || F250Soma(13,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_13"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp13 := iif(oTotGrp13:GetValue()==nil,0,oTotGrp13:GetValue()),StrTran(ValorCTB(nTotGrp13,,,nTamValor+Iif(nTotGrp13==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_13"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp13 := iif(oTotGrp13:GetValue()==nil,0,oTotGrp13:GetValue()),ValorCTB(nTotGrp13,,,nTamValor+Iif(nTotGrp13==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotGrp13:Disable()

// Total Grupo Filial 14
    oTotGrp14 :=	TRFunction():New(oSection1:Cell("FILIAL_14"),nil,"SUM"		,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || F250Soma(14,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_14"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp14 := iif(oTotGrp14:GetValue()==nil,0,oTotGrp14:GetValue()),StrTran(ValorCTB(nTotGrp14,,,nTamValor+Iif(nTotGrp14==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_14"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp14 := iif(oTotGrp14:GetValue()==nil,0,oTotGrp14:GetValue()),ValorCTB(nTotGrp14,,,nTamValor+Iif(nTotGrp14==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotGrp14:Disable()

// Total Grupo Filial 15
    oTotGrp15 :=	TRFunction():New(oSection1:Cell("FILIAL_15"),nil,"SUM"		,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || F250Soma(15,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_15"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp15 := iif(oTotGrp15:GetValue()==nil,0,oTotGrp15:GetValue()),StrTran(ValorCTB(nTotGrp15,,,nTamValor+Iif(nTotGrp15==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_15"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp15 := iif(oTotGrp15:GetValue()==nil,0,oTotGrp15:GetValue()),ValorCTB(nTotGrp15,,,nTamValor+Iif(nTotGrp15==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotGrp15:Disable()

// Total Grupo Filial 16
    oTotGrp16 :=	TRFunction():New(oSection1:Cell("FILIAL_16"),nil,"SUM"		,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || F250Soma(16,cSegAte) },.F.,.F.,.F.,oSection1)
	If lIsRedStor
        TRFunction():New(oSection1:Cell("FILIAL_16"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp16 := iif(oTotGrp16:GetValue()==nil,0,oTotGrp16:GetValue()),StrTran(ValorCTB(nTotGrp16,,,nTamValor+Iif(nTotGrp16==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("FILIAL_16"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,{ || (nTotGrp16 := iif(oTotGrp16:GetValue()==nil,0,oTotGrp16:GetValue()),ValorCTB(nTotGrp16,,,nTamValor+Iif(nTotGrp16==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF
    oTotGrp16:Disable()

// Total Geral por Grupo
    oTotGrpGeral :=	TRFunction():New(oSection1:Cell("TOTAL"),nil,"SUM"		,oBreakGrupo,/*Titulo*/,/*cPicture*/,;
        { ||	F250Soma(1,cSegAte) + F250Soma(2,cSegAte) + F250Soma(3,cSegAte) + F250Soma(4,cSegAte) + F250Soma(5,cSegAte) + F250Soma(6,cSegAte) + F250Soma(7,cSegAte) + F250Soma(8,cSegAte) + F250Soma(9,cSegAte)+ F250Soma(10,cSegAte) + F250Soma(11,cSegAte) + F250Soma(12,cSegAte) + F250Soma(13,cSegAte) + F250Soma(14,cSegAte) + F250Soma(15,cSegAte) + F250Soma(16,cSegAte)  },.F.,.F.,.F.,oSection1)

	If lIsRedStor
        TRFunction():New(oSection1:Cell("TOTAL"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,;
            { || (nTotGrpGeral := iif(oTotGrpGeral:GetValue()==nil,0,oTotGrpGeral:GetValue()),StrTran(ValorCTB(nTotGrpGeral,,,nTamValor+Iif(nTotGrpGeral==0,2,0),nDecimais,CtbSinalMov(),cPicture,"1",,,,,,lPrintZero,.F.),"D","")) },.F.,.F.,.F.,oSection1)
	Else
        TRFunction():New(oSection1:Cell("TOTAL"),nil,"ONPRINT"	,oBreakGrupo,/*Titulo*/,/*cPicture*/,;
            { || (nTotGrpGeral := iif(oTotGrpGeral:GetValue()==nil,0,oTotGrpGeral:GetValue()),ValorCTB(nTotGrpGeral,,,nTamValor+Iif(nTotGrpGeral==0,2,0),nDecimais,CtbSinalMov(),cPicture,"2",,,,,,lPrintZero,.F.)) },.F.,.F.,.F.,oSection1)
	EndIF

// Desabilitando, pois a quebra sera feita pelo oBreakGrupo
    oTotGrpGeral:Disable()

    MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
    ASC013Comp(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
        mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,/*mv_par14*/'01',;
        /*mv_par16*/'1',aSetOfBook,/*mv_par18*/Space(2),/*mv_par19*/Space(20),/*mv_par20*/Space(20),/*mv_par21*/Space(30),;
        .F.,.F.,/*mv_par11*/3,,lImpAntLP,dDataLP,nDivide,"M",.T.,aFilAux/*aFiliais*/,,,,,,.T.,,cFiltro)},;
        OemToAnsi(OemToAnsi("Criando Arquivo Temporario...")),;  //"Criando Arquivo Tempor rio..."
    OemToAnsi("Comparativo de Contas Contabeis com Filiais"))	//"Comparativo de Contas Contabeis com Filiais"

	If Select("cArqTmp") == 0
        oReport:CancelPrint()
        Return
	EndIf

// Desabilita processamento do filtro pelo objeto, pois o arquivo temporario jah vem filtrado
    oReport:NoUserFilter()

    dbSelectArea("cArqTmp")
    dbSetOrder(1)
    dbGoTop()

//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial
//nao esta disponivel e sai da rotina.
	If RecCount() == 0 .And. !Empty(aSetOfBook[5])
        dbCloseArea()
        FErase(cArqTmp+GetDBExtension())
        FErase("cArqInd"+OrdBagExt())
        oReport:CancelPrint()
        Return
	Endif

    oReport:SetMeter(RecCount())

    dbSelectArea("cArqTmp")
	cGrupo    := cArqTmp->GRUPO
	cGrupoAnt := cArqTmp->GRUPO

    oSection1:Init()

	While !Eof()

		If oReport:Cancel()
            Exit
		EndIF

        oReport:IncMeter()

        lImprime := Eval(bLineCond)
		If lImprime

            cGrupoAnt	:= If(	cGrupo <> cArqTmp->GRUPO .Or. EOF(),	cGrupo,	cGrupoAnt	)
            cGrupo 		:= If(	!EOF(),	cArqTmp->GRUPO,	cGrupo	)
            cTipoAnt	:= cArqTmp->TIPOCONTA

            // If mv_par17 != 1 .And. cArqTmp->NIVEL1
            // oReport:EndPage()
            // EndIf

            oSection1:PrintLine()

		EndIf

        dbSelectArea("cArqTmp")
        dbSkip()

	EndDo

    // If mv_par17 == 1
        oBreakGrupo:SetPageBreak(.F.)
    // EndIf

    cGrupoAnt := cGrupo

    dbSelectArea("cArqTmp")
    Set Filter To
    dbCloseArea()
	If Select("cArqTmp") == 0
        FErase(cArqTmp+GetDBExtension())
        FErase(cArqTmp+OrdBagExt())
	EndIF
    dbselectArea("CT2")

    RestArea(aAreaSM0)

Return(Nil)



// Responsavel pela validacao de alguns parametros
Static Function ASC013VLD()

    Local lRet      := .T.
    Local lLoop     := .T.
    Local nDivide   :=  1
    Local aCtbMoeda := {}

	Do While lLoop
		If lRet .And. !Ct040Valid(Space(3))
        // If lRet .And. !Ct040Valid(mv_par12)
            lRet := .F.
		EndIf

		If lRet
            // If mv_par25 == 2			// Divide por cem
            //     nDivide := 100
            // ElseIf mv_par25 == 3		// Divide por mil
            //     nDivide := 1000
            // ElseIf mv_par25 == 4		// Divide por milhao
            //     nDivide := 1000000
            // EndIf

            aCtbMoeda := CtbMoeda('01',nDivide)
            // aCtbMoeda := CtbMoeda(mv_par14,nDivide)
			If Empty(aCtbMoeda[1])
                Help(" ",1,"NOMOEDA")
                lRet := .F.
			Endif
		Endif
		If lRet
            lLoop := .F.
		Else
            lLoop := Pergunte("ASC013",.T.)
            lRet := lLoop
		EndIf
	EndDo

Return({lRet,nDivide,aCtbMoeda})



Static Function AtuSX1()

    cPerg := "ASC013"
    aRegs := {}

//    	   Grupo/Ordem/Pergunta                    /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
    U_CRIASX1(cPerg,"01","Data De?                ",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""       ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
    U_CRIASX1(cPerg,"02","Data Ate ?              ",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""       ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
    U_CRIASX1(cPerg,"03","Conta De?               ",""       ,""      ,"mv_ch3","C" ,20     ,0      ,0     ,"G",""            ,"MV_PAR03",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""       ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CT1")
    U_CRIASX1(cPerg,"04","Conta Ate ?             ",""       ,""      ,"mv_ch4","C" ,20     ,0      ,0     ,"G",""            ,"MV_PAR04",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""       ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CT1")
    U_CRIASX1(cPerg,"05","Saldos Zerados?         ",""       ,""      ,"mv_ch5","N" ,01     ,0      ,0     ,"C",""            ,"MV_PAR05","Sim"            ,""     ,""     ,""   ,""   ,"Nao"            ,""     ,""     ,""   ,""   ,""       ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros								     ³
//³ mv_par01				// Data Inicial                  	  		  ³
//³ mv_par02				// Data Final                        		  ³
//³ mv_par03				// Conta Inicial                         	  ³
//³ mv_par04				// Conta Final  							        ³
//³ mv_par05				// Filial 01?                            	  ³
//³ mv_par06				// Filial 02?                            	  ³
//³ mv_par07				// Filial 03?                            	  ³
//³ mv_par08				// Filial 04?                            	  ³
//³ mv_par09				// Filial 05?                            	  ³
//³ mv_par10				// Filial 06?                            	  ³
//³ mv_par11				// Imprime Contas: Sintet/Analit/Ambas   	  ³
//³ mv_par12				// Set Of Books				    		        ³
//³ mv_par13				// Saldos Zerados?			     		        ³
//³ mv_par14				// Moeda?          			     		        ³
//³ mv_par15				// Pagina Inicial  		     		    	     ³
//³ mv_par16				// Saldos? Reais / Orcados	/Gerenciais   	  ³
//³ mv_par17				// Quebra por Grupo Contabil?		    	     ³
//³ mv_par18				// Filtra Segmento?					    	     ³
//³ mv_par19				// Conteudo Inicial Segmento?		   		  ³
//³ mv_par20				// Conteudo Final Segmento?		    		  ³
//³ mv_par21				// Conteudo Contido em?				    	     ³
//³ mv_par22				// Salta linha sintetica ?			    	     ³
//³ mv_par23				// Imprime valor 0.00    ?			    	     ³
//³ mv_par24				// Imprimir Codigo? Normal / Reduzido  	  ³
//³ mv_par25				// Divide por ?                   			  ³
//³ mv_par26				// Imprimir Ate o segmento?			   	  ³
//³ mv_par27				// Posicao Ant. L/P? Sim / Nao         	  ³
//³ mv_par28				// Data Lucros/Perdas?                 	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Return (Nil)




//-------------------------------------------------------------------
/*{Protheus.doc} ASC013Comp
Gerar Arquivo Temporario para Comparativos (6 colunas)

@author Alvaro Camillo Neto

@param oMeter	    Objeto oMeter
@param oText	    Objeto oText
@param oDlg	    Objeto oDlg
@param lEnd	    lEnd
@param dDataIni	     Data Inicial
@param dDataFim	     Data Final
@param cAlias	     Alias do Arquivo
@param cContaIni     Conta Inicial
@param cContaFim     Conta Final
@param cCCIni	     Centro de Custo Inicial
@param cCCFim	     Centro de Custo Final
@param cItemIni	      Item Inicial
@param cItemFim	      Item Final
@param cClvlIni	      Classe de Valor Inicial
@param cClVlFim	      Classe de Valor Final
@param cMoeda	      Moeda
@param cSaldos	      Saldo
@param aSetOfBook     Set Of Book
@param cSegmento      Ate qual segmento sera impresso (nivel)
@param cSegIni	       Segmento Inicial
@param cSegFim	       Segmento Final
@param cFiltSegm       Segmento Contido em
@param lNImpMov	       Se Imprime Entidade sem movimento
@param lImpConta       Se Imprime Conta
@param nGrupo	       Grupo

@version P12
@since   20/02/2014
@return  Nil
@obs
*/
//-------------------------------------------------------------------

Static Function ASC013Comp(oMeter,oText,oDlg,lEnd,cArqtmp,;
		dDataIni,dDataFim,cAlias,cIdent,cContaIni,;
		cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,	cClVlFim,cMoeda,;
		cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
		lNImpMov,lImpConta,nGrupo,cHeader,lImpAntLP,dDataLP,nDivide,cTpVlr,;
		lFiliais,aFiliais,lMeses,aMeses,lVlrZerado,lEntid,aEntid,lImpSint,cString,;
		cFilUSU,lImpTotS,lImp4Ent,c1aEnt,c2aEnt,c3aEnt,c4aEnt,lAtSlBase,lValMed,lSalAcum,aSelFil,lTodasFil,cNomeTab)

	Local aTamConta		:= TAMSX3("CT1_CONTA")
	Local aTamCtaRes	:= TAMSX3("CT1_RES")
	Local aTamCC        := TAMSX3("CTT_CUSTO")
	Local aTamCCRes 	:= TAMSX3("CTT_RES")
	Local aTamItem  	:= TAMSX3("CTD_ITEM")
	Local aTamItRes 	:= TAMSX3("CTD_RES")
	Local aTamClVl  	:= TAMSX3("CTH_CLVL")
	Local aTamCvRes 	:= TAMSX3("CTH_RES")
	Local aTamVal		:= TAMSX3("CT2_VALOR")
	Local aCtbMoeda		:= {}
	Local aSaveArea 	:= GetArea()
	Local aCampos
	Local aStruTMP		:= {}
	Local cChave
	Local cCodMasc		:= ""
	Local nTamCta 		:= Len(CriaVar("CT1->CT1_DESC"+cMoeda))
	Local nTamItem		:= Len(CriaVar("CTD->CTD_DESC"+cMoeda))
	Local nTamCC  		:= Len(CriaVar("CTT->CTT_DESC"+cMoeda))
	Local nTamClVl		:= Len(CriaVar("CTH->CTH_DESC"+cMoeda))
	Local nTamGrupo		:= Len(CriaVar("CT1->CT1_GRUPO"))
	Local nPos			:= 0
	Local nDigitos		:= 0
	Local nDecimais		:= 0
	Local cCodigo		:= ""
	Local cEntidIni		:= ""
	Local cEntidFim		:= ""
	Local cEntidIni1	:= ""
	Local cEntidFim1	:= ""
	Local cEntidIni2	:= ""
	Local cEntidFim2	:= ""
	Local cArqTmp1		:= ""
	Local lCusto		:= CtbMovSaldo("CTT")//Define se utiliza C.Custo
	Local lItem 		:= CtbMovSaldo("CTD")//Define se utiliza Item
	Local lClVl			:= CtbMovSaldo("CTH")//Define se utiliza Cl.Valor
	Local lAtSldBase	:= Iif(GetMV("MV_ATUSAL")== "S",.T.,.F.)
	Local lAtSldCmp		:= Iif(GetMV("MV_SLDCOMP")== "S",.T.,.F.)
	Local nInicio		:= Val(cMoeda)
	Local nFinal		:= Val(cMoeda)
	Local cFilDe		:= xFilial(cAlias)
	Local cFilate		:= xFilial(cAlias)
	Local cMensagem		:= ""
	Local nMeter		:= 0
	Local lTemQry		:= .F.							/// SE UTILIZOU AS QUERYS PARA OBTER O SALDO DAS ANALITICAS
	Local nTRB			:= 1
	Local nCont			:= 0
	Local dDataAnt		:= CTOD("  /  /  ")
	Local cFilXAnt		:= ""
	Local nTamFilial 	:= IIf( lFWCodFil, FWGETTAMFILIAL, TamSx3( "CT2_FILIAL" )[1] )
	Local nMin	:= 0
	Local nMax	:= 0

	Local aChave		:= {}
	Local nTamCt	:= aTamConta[1]
	Local cTableNam1 	:= ""

	Local cMvPar01Ant	:= mv_par01

	Private cPlanoRef	:= aSetOfBook[11]
	Private cVersao		:= aSetOfBook[12]


	cIdent		:=	Iif(cIdent == Nil,'',cIdent)
	nGrupo		:=	Iif(nGrupo == Nil,2,nGrupo)
	cHeader		:= Iif(cHeader == Nil,'',cHeader)

	DEFAULT lImpSint	:= .F.
	DEFAULT cMoeda		:= "01"		//// SE NAO FOR INFORMADA A MOEDA ASSUME O PADRAO 01
	DEFAULT lEntid		:= .F.
	DEFAULT lMeses		:= .F.
	DEFAULT lImpTotS	:= .F.
	DEFAULT lImp4Ent	:= .F.
	DEFAULT c1aEnt		:= ""
	DEFAULT c2aEnt		:= ""
	DEFAULT c3aEnt		:= ""
	DEFAULT c4aEnt		:= ""
	DEFAULT lAtSlBase	:= .T.
	DEFAULT lValMed		:= .F.
	DEFAULT lSalAcum	:= .F.
	DEFAULT lTodasFil   := .F.
	DEFAULT cArqTmp		:= ""
	dMinData := CTOD("")

// Retorna Decimais
	aCtbMoeda := CTbMoeda(cMoeda)
	nDecimais := aCtbMoeda[5]

//Se utiliza o plano referencial, desconsidera os filtros das entidades dos relatórios.
	If !Empty(cPlanoRef) .And. !Empty(cVersao)
		//Se o relatório não possuir conta, o plano referencial e a versão serão desconsiderados.
		//Será considerado cód. config. livros em branco.
		If cAlias $ "CTU/CTV/CTW/CTX/CVY"
			Help("  ",1,"CTBNOPLREF",,"Plano referencial não disponível nesse relatório. O relatório será processado desconsiderando a configuração de livros.",1,0) //"
			cPlanoRef		:= ""
			cVersao			:= ""
			//aSetOfBook[1]	:= ""
			aSetOfBook		:= CTBSetOf("")
		Else
			cContaIni	:= Space(aTamConta[1])
			cContaFim	:= Replicate("Z",aTamConta[1])
			nTamCt	:= 70
		EndIf
	Endif

	aCampos := {{ "CONTA"		, "C", nTamCt, 0 },;  			// Codigo da Conta
	{ "NORMAL"		, "C", 01			, 0 },;			// Situacao
	{ "CTARES"		, "C", aTamCtaRes[1], 0 },;  			// Codigo Reduzido da Conta
	{ "DESCCTA"	, "C", nTamCta		, 0 },;  			// Descricao da Conta
	{ "CUSTO"		, "C", aTamCC[1]	, 0 },; 	 		// Codigo do Centro de Custo
	{ "CCRES"		, "C", aTamCCRes[1], 0 },;  			// Codigo Reduzido do Centro de Custo
	{ "DESCCC" 	, "C", nTamCC		, 0 },;  			// Descricao do Centro de Custo
	{ "ITEM"		, "C", aTamItem[1]	, 0 },; 	 		// Codigo do Item
	{ "ITEMRES" 	, "C", aTamItRes[1], 0 },;  			// Codigo Reduzido do Item
	{ "DESCITEM" 	, "C", nTamItem		, 0 },;  			// Descricao do Item
	{ "CLVL"		, "C", aTamClVl[1]	, 0 },; 	 		// Codigo da Classe de Valor
	{ "CLVLRES"	, "C", aTamCVRes[1], 0 },; 		 	// Cod. Red. Classe de Valor
	{ "DESCCLVL"   , "C", nTamClVl		, 0 },;  			// Descricao da Classe de Valor
	{ "COLUNA1"	, "N", aTamVal[1]+2, nDecimais},; 	// Saldo Anterior
	{ "COLUNA2"   	, "N", aTamVal[1]+2	, nDecimais},; 	// Saldo Anterior Debito
	{ "COLUNA3"   	, "N", aTamVal[1]+2	, nDecimais},; 	// Saldo Anterior Credito
	{ "COLUNA4" 	, "N", aTamVal[1]+2	, nDecimais},;  	// Debito
	{ "COLUNA5" 	, "N", aTamVal[1]+2	, nDecimais},;  	// Credito
	{ "COLUNA6"  	, "N", aTamVal[1]+2	, nDecimais},;  	// Saldo Atual
	{ "COLUNA7"	, "N", aTamVal[1]+2	, nDecimais},; 	// Saldo Anterior
	{ "COLUNA8"   	, "N", aTamVal[1]+2	, nDecimais},; 	// Saldo Anterior Debito
	{ "COLUNA9"   	, "N", aTamVal[1]+2	, nDecimais},; 	// Saldo Anterior Credito
	{ "COLUNA10" 	, "N", aTamVal[1]+2	, nDecimais},;  	// Debito
	{ "COLUNA11" 	, "N", aTamVal[1]+2	, nDecimais},;  	// Credito
	{ "COLUNA12"  	, "N", aTamVal[1]+2	, nDecimais},;  	// Saldo Atual
	{ "COLUNA13"  	, "N", aTamVal[1]+2	, nDecimais},;  	// Saldo Atual
	{ "COLUNA14"  	, "N", aTamVal[1]+2	, nDecimais},;  	// Saldo Atual
	{ "COLUNA15"  	, "N", aTamVal[1]+2	, nDecimais},;  	// Saldo Atual
	{ "COLUNA16"  	, "N", aTamVal[1]+2	, nDecimais},;  	// Saldo Atual
	{ "TIPOCONTA"	, "C", 01			, 0 },;			// Conta Analitica / Sintetica
	{ "TIPOCC"  	, "C", 01			, 0 },;			// Centro de Custo Analitico / Sintetico
	{ "TIPOITEM"	, "C", 01			, 0 },;			// Item Analitica / Sintetica
	{ "TIPOCLVL"	, "C", 01			, 0 },;			// Classe de Valor Analitica / Sintetica
	{ "CTASUP"		, "C", nTamCt, 0 },;			// Codigo do Centro de Custo Superior
	{ "CCSUP"		, "C", aTamCC[1]	, 0 },;			// Codigo do Centro de Custo Superior
	{ "ITSUP"		, "C", aTamItem[1]	, 0 },;			// Codigo do Item Superior
	{ "CLSUP"	    , "C", aTamClVl[1] , 0 },;			// Codigo da Classe de Valor Superior
	{ "ORDEM"		, "C", 10			, 0 },;			// Ordem
	{ "GRUPO"		, "C", nTamGrupo	, 0 },;			// Grupo Contabil
	{ "TOTVIS"		, "C", 01			, 0 },;
		{ "SLDENT"		, "C", 01			, 0 },;
		{ "FATSLD"		, "C", 01			, 0 },;
		{ "VISENT"		, "C", 01			, 0 },;
		{ "IDENTIFI"	, "C", 01			, 0 },;
		{ "ESTOUR"  	, "C", 01			, 0 },;			//Define se eh conta estourada
	{ "NIVEL1"		, "L", 01			, 0 },;				// Logico para identificar se
	{ "COLVISAO"	, "N", 01			, 0 },;				// Logico para identificar se 																	// eh de nivel 1 -> usado como
	{ "FILIAL"		, "C", nTamFilial	, 0 }}				// Filial
// eh de nivel 1 -> usado como
// totalizador do relatorio

///// TRATAMENTO PARA ATUALIZAÇÃO DE SALDO BASE
//Se os saldos basicos nao foram atualizados na dig. lancamentos
	If !lAtSldBase .And. !__IsCtbJob
		dIniRep := ctod("")
		If Need2Reproc(dDataFim,cMoeda,cSaldos,@dIniRep)
			//Chama Rotina de Atualizacao de Saldos Basicos.
			oProcess := MsNewProcess():New({|lEnd|	CTBA190(.T.,dIniRep,dDataFim,cFilAnt,cFilAnt,cSaldos,.T.,cMoeda) },"","",.F.)
			oProcess:Activate()
		EndIf
	Endif


/// TRATAMENTO PARA OBTENÇÃO DO SALDO DAS CONTAS ANALITICAS
	Do Case
	Case cAlias  == "CT7"
		//Se for Comparativo de Conta por 6 meses/12 meses
		cEntidIni	:= cContaIni
		cEntidFim	:= cContaFim
		cCodMasc	:= aSetOfBook[2]
		If nGrupo == 2
			cChave 	:= "CONTA"
			aChave	:= {"CONTA"}
		Else									// Indice por Grupo -> Totaliza por grupo
			cChave 	:= "CONTA+GRUPO"
			aChave	:= {"CONTA","GRUPO"}
		EndIf

		If  Empty(aSetOfBook[5])				/// SÓ HÁ QUERY SEM O PLANO GERENCIAL
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif
			If lMeses
				If cTpVlr == "S"			/// COMPARATIVO DE SALDO ACUMULADO
					CT7CompQry(dDataIni,dDataFim,cSaldos,cMoeda,cContaIni,cContaFim,aSetOfBook,lVlrZerado,lMeses,aMeses,cString,cFILUSU,lImpAntLP,dDataLP,.T.)
				Else						/// COMPARATIVO DE MOVIMENTO DO PERIODO
					CT7CompQry(dDataIni,dDataFim,cSaldos,cMoeda,cContaIni,cContaFim,aSetOfBook,lVlrZerado,lMeses,aMeses,cString,cFILUSU,lImpAntLP,dDataLP,.F.)
				Endif
			EndIf
		EndIf
	Case cAlias == "CTU"
		If cIdent == "CTT"
			cEntidIni	:= cCCIni
			cEntidFim	:= cCCFim
			cChave		:= "CUSTO"
			aChave		:= {"CUSTO"}
		EndIf
	Case cAlias == "CT3"

		If !Empty(aSetOfBook[5])
			cMensagem	:= OemToAnsi("O plano gerencial ainda nao esta disponivel nesse relatorio.")//
			MsgInfo(cMensagem)
			RestArea(aSaveArea)
			Return
		Endif

		If cHeader == "CTT"
			cChave		:= "CUSTO+CONTA"
			aChave		:= {"CUSTO","CONTA"}
			cEntidIni1	:= cCCIni
			cEntidFim1	:= cCCFim
			cEntidIni2	:= cContaIni
			cEntidFim2	:= cContaFim
			cCodMasc	:= aSetOfBook[2]
		ElseIf cHeader == "CT1"
			cChave		:= "CONTA+CUSTO"
			aChave		:= {"CONTA","CUSTO"}
			cEntidIni1	:= cContaIni
			cEntidFim1	:= cContaFim
			cEntidIni2	:= cCCIni
			cEntidFim2	:= cCCFim
			cCodMasc	:= aSetOfBook[6]
		EndIf


		CT3CompQry(dDataIni,dDataFim,cCCIni,cCCFim,cContaIni,cContaFim,cMoeda,cSaldos,aSetOfBook,lImpAntLP,dDataLP,lMeses,aMeses,lVlrZerado,lEntid,aEntid,cHeader,cString,cFILUSU,cTpVlr=="S")
		If Empty(cFilUSU)
			cFILUSU := ".T."
		Endif


	Case cAlias == "CTI"
		If lImp4Ent	//Se for Comparativo de 4 entidades

			CTICmp4Ent(dDataIni,dDataFim,cContaIni,cContafim,cCCIni,cCCFim,cItemIni,cItemFim,cClVlIni,cClVlFim,;
				cMoeda,cSaldos,aSetOfBook,lImpAntLP,dDataLP,cTpVlr,aMeses,cString,cFilUSU)
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif

		EndIf
		cChave	:= c1aEnt+"+"+c2aEnt+"+"+c3aEnt+"+"+c4aEnt
	Case cAlias == "CTV"

		If !Empty(aSetOfBook[5])
			cMensagem	:= OemToAnsi("O plano gerencial ainda nao esta disponivel nesse relatorio.")//
			MsgInfo(cMensagem)
			RestArea(aSaveArea)
			Return
		Endif

		If cHeader == "CTT"
			cChave	:=	"CUSTO+ITEM"
			aChave	:= {"CUSTO","ITEM"}
			cEntidIni1	:=	cCCIni
			cEntidFim1	:=	cCCFim
			cEntidIni2	:=	cItemIni
			cEntidFim2	:=	cItemFim
		ElseIf cHeader == "CTD"
			cChave		:=	"ITEM+CUSTO"
			aChave		:= {"ITEM","CUSTO"}
			cEntidIni1	:=	cItemIni
			cEntidFim1	:=	cItemFim
			cEntidIni2	:=	cCCIni
			cEntidFim2	:=	cCCFim
		EndIf

		CTVCompQry(dDataIni,dDataFim,cCCIni,cCCFim,cItemIni,cItemFim,cMoeda,cSaldos,aSetOfBook,lImpAntLP,dDataLP,lMeses,aMeses,lVlrZerado,lEntid,aEntid,cHeader,cString,cFILUSU)
		If Empty(cFilUSU)
			cFILUSU := ".T."
		Endif

	Case cAlias == "CTX"
		If cHeader == "CTH"
			cChave		:= "CLVL+ITEM"
			aChave		:= {"CLVL","ITEM"}
			cEntidIni1	:=	cClVlIni
			cEntidFim1	:=	cClVlFim
			cEntidIni2	:=	cItemIni
			cEntidFim2	:= cItemFim
			cCodMasc	:= aSetOfBook[7]
		ElseIf cHeader == "CTD"
			cChave		:= "ITEM+CLVL"
			aChave		:= {"ITEM","CLVL"}
			cEntidIni1	:=	cItemIni
			cEntidFim1	:=	cItemFim
			cEntidIni2	:=	cClVlIni
			cEntidFim2	:= 	cClVlFim
		EndIf

		CTXCompQry(dDataIni,dDataFim,cItemIni,cItemFim,cClVlIni,cClVlFim,cMoeda,cSaldos,aSetOfBook,lImpAntLP,dDataLP,lMeses,aMeses,lVlrZerado,lEntid,aEntid,cHeader,cString,cFILUSU,lImpAntLP,dDataLP)
		If Empty(cFilUSU)
			cFILUSU := ".T."
		Endif

	EndCase

	If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
		cChave	:= "CONTA"
		aChave	:= {"CONTA"}
	Endif


	If ( Select ( "cArqTmp" ) <> 0 )
		dbSelectArea ( "cArqTmp" )
		dbCloseArea ()
	Endif

	If _oTempTable <> Nil
		_oTempTable:Delete()
	EndIf

//-------------------
//Criação do objeto
//-------------------
	_oTempTable := FWTemporaryTable():New("cArqTmp")
	_oTempTable:SetFields( aCampos )
	lCriaInd := .T.
	_oTempTable:AddIndex("1", aChave)
	If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
		_oTempTable:AddIndex("2", {"ORDEM"})
	Endif

//------------------
//Criação da tabela
//------------------
	_oTempTable:Create()

	cTableNam1	:= _oTempTable:GetRealName()
	cNomeTab	:= cTableNam1

	dbSelectArea("cArqTmp")

	If !Empty(cPlanoRef) .Or. !Empty(cVersao)
		If !VldPlRef(aSetOfBook[1],cPlanoRef, cVersao)
			Return(cArqTmp)
		EndIf
	Endif

	If !Empty(cSegmento)
		If Len(aSetOfBook) == 0 .or. Empty(aSetOfBook[1])
			Help("CTN_CODIGO")
			Return(cArqTmp)
		Endif
		dbSelectArea("CTM")
		dbSetOrder(1)
		If MsSeek(xFilial()+cCodMasc)
			While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cCodMasc
				nPos += Val(CTM->CTM_DIGITO)
				If CTM->CTM_SEGMEN == strzero(val(cSegmento),2)
					nPos -= Val(CTM->CTM_DIGITO)
					nPos ++
					nDigitos := Val(CTM->CTM_DIGITO)
					Exit
				EndIf
				dbSkip()
			EndDo
		Else
			Help("CTM_CODIGO")
			Return(cArqTmp)
		EndIf
	EndIf

	If Empty(aSetOfBook[5])				/// SÓ HÁ QUERY SEM O PLANO GERENCIAL
		//// SE FOR DEFINIÇÃO TOP
		If Select("TRBTMP") > 0		/// E O ALIAS TRBTMP ESTIVER ABERTO (INDICANDO QUE A QUERY FOI EXECUTADA)
			dbSelectArea("TRBTMP")
			aStruTMP := dbStruct()			/// OBTEM A ESTRUTURA DO TMP

			dbSelectArea("TRBTMP")
			If ValType(oMeter) == "O"
				oMeter:SetTotal((cAlias)->(RecCount()))
				oMeter:Set(0)
			EndIf
			dbGoTop()						/// POSICIONA NO 1º REGISTRO DO TMP

			While TRBTMP->(!Eof())			/// REPLICA OS DADOS DA QUERY (TRBTMP) PARA P/ O TEMPORARIO EM DISCO
				nMeter++
				If nMeter%1000 = 0
					If ValType(oMeter) == "O"
						oMeter:Set(nMeter)
					EndIf
				EndIf

				If cAlias == "CT7"
					cCodigo	:= TRBTMP->CONTA
				ElseIf cAlias == "CT3"
					If cHeader == "CTT"
						cCodigo	:= TRBTMP->CONTA
					Endif
				ElseIf cAlias =="CTX"
					If cHeader == "CTH"
						cCodigo	:= TRBTMP->ITEM
					Endif
				EndIf

				If Empty(cPlanoRef) .Or. Empty(cVersao)	//Verifica o segmento somente se nao for com plano referencial.
					If !Empty(cSegmento)
						If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
							If  !(Substr(cCodigo,nPos,nDigitos) $ (cFiltSegm) )
								dbSkip()
								Loop
							EndIf
						Else
							If Substr(cCodigo,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
									Substr(cCodigo,nPos,nDigitos) > Alltrim(cSegFim)
								dbSkip()
								Loop
							EndIf
						Endif
					EndIf
				EndIf

				If &("TRBTMP->("+cFILUSU+")")
					RecLock("cArqTMP",.T.)
					For nTRB := 1 to Len(aStruTMP)
						If Subs(aStruTmp[nTRB][1],1,6) == "COLUNA" .And. nDivide > 1
							Field->&(aStruTMP[nTRB,1])	:=((TRBTMP->&(aStruTMP[nTRB,1])))/ndivide
						Else
							Field->&(aStruTMP[nTRB,1]) := TRBTMP->&(aStruTMP[nTRB,1])
						EndIf
					Next
					cArqTMP->FILIAL	:= cFilAnt
					cArqTMP->(MsUnlock())
				Endif
				dbSelectArea("TRBTMP")
				dbSkip()
			Enddo

			dbSelectArea("TRBTMP")
			dbCloseArea()					/// FECHA O TRBTMP (RETORNADO DA QUERY)
			lTemQry := .T.
		Endif
	EndIf


	dbSelectArea("cArqTmp")
	dbSetOrder(1)

	If !Empty(aSetOfBook[5])				// Se houve Indicacao de Plano Gerencial Anexado
		// Monta Arquivo Lendo Plano Gerencial
		// Neste caso a filtragem de entidades contabeis é desprezada!
		// Por enquanto a opcao de emitir o relatorio com Plano Gerencial ainda
		// nao esta disponivel para esse relatorio.
		If cAlias $ "CT7"					// Se for Entidade x Conta
			CtbPlGerCm(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,;
				cAlias,cIdent,lImpAntLP,dDataLP,lVlrZerado,lFiliais,aFiliais,lMeses,aMeses,lImpSint,cTpVlr,,,cSaldos,lValMed,lSalAcum)
			dbSetOrder(2)
		Else
			cMensagem	:= OemToAnsi("O plano gerencial ainda nao esta disponivel nesse relatorio.")//
			MsgInfo(cMensagem)
		EndIf
	Else
		If cAlias $ 'CT7/CTU'		//So Imprime Entidade
			If lMeses
				//So ira gravar as contas sinteticas se mandar imprimir as contas sinteticas ou ambas.
				If lImpSint
					//Gravacao das contas superiores.
					SupCompCt7(oMeter,lMeses,aMeses,cMoeda,cTpVlr)
				Endif
			Else
				CtCmpSoEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni,cEntidFim,cMoeda,;
					cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cIdent,;
					lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,lImpAntLP,dDataLP,nDivide,;
					cTpVlr,lFiliais,aFiliais,lMeses,aMeses,cFilUsu)
			EndIf
		ElseIf cAlias == "CT3"

			If lMeses
				If lImpSint .Or. lImpTotS
					SupCompMes(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
						cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
						lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
						cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado)
				EndIf

			EndIf
		ElseIf cAlias $ "CTV/CTX"				//// SE FOR ENTIDADE x ITEM CONTABIL
			If lEntid	//Relatorio Comparativo de 1 Entidade por 6 Entidades
				If lImpSint  // SE DEVE IMPRIMIR AS SINTETICAS
					/// Usa cHeader x cAlias invertidas para compor as entidades sintéticas (neste caso sintetica do CTD ao invés do CTT)
					SupCompEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
						cEntidFim2,cAlias,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
						lNImpMov,cHeader,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
						cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado,lEntid,aEntid)
				Endif
			Else
				If lImpSint  // SE DEVE IMPRIMIR AS SINTETICAS
					SupCompEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
						cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
						lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
						cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado)
				Endif

			EndIf
		Endif

		//Se utiliza plano referencial
		If !Empty(cPlanoRef) .And. !Empty(cVersao)
			If IsBlind()
				mv_par01	:= ""
			Else
				Pergunte("CTBPLREF2",.T.)
				MakeSqlExpr("CTBPLREF2")
			EndIf
			cArqTmp	:= CtCompPlRf(cTableNam1,cPlanoRef,cVersao,"cArqTmp",cChave,aChave,aCampos,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
				cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,nPos,nDigitos,;
				lNImpMov,cAlias,lCusto,lItem,lClvl,lAtSldBase,lAtSldCmp,nInicio,nFinal,cFilDe,;
				cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado,lEntid,aEntid,lImpSint,@_oTempTbPLRef )
			mv_par01	:= cMvPar01Ant
		EndIF

	EndIf

	RestArea(aSaveArea)

Return cArqTmp
