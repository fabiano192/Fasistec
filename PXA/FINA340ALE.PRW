#include "rwmake.ch"
#INCLUDE "FINA340.CH"
#INCLUDE "PROTHEUS.CH"

                          
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Fina340	³ Autor ³ Valter G. Nogueira Jr.³ Data ³ 18/03/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Compensa‡„o entre t¡tulos e adiantamentos 		          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Fina340()	   					                    	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	     ³ Gen‚rico 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			ATUALIZACOES SOFRIDAS                     					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Claudio    ³13/07/00³xxxxxx³ Retirar todas as chamadas a WriteSx2     ³±±
±±³Paulo August³12/09/01³Melhor³Permitir que a compensacao seja feita     ³±±
±±³            ³        ³      ³atraves dos titulos compensaveis(RA,NCC,..³±±
±±³Marcel      ³14/10/07³Melhor³PA com valor Bruto                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function FINA340ALE()


Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
Local nVlMoeda	:= 0
Local nSavInd := IndexOrd()
LOCAL nSavRec	:= RecNO()
Local nA, cMoedaTx

lFWCodFil := FindFunction("FWCodFil")
__lBlind  := IsBlind()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vetor com Condicoes para a legenda da mBrowse ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private  aCores :={	{ 'E2_SALDO = E2_VALOR .AND. E2_ACRESC = E2_SDACRES'  , 'ENABLE' },;   // Titulo nao Compensado
					{ 'E2_SALDO =  0'         , 'DISABLE'},;	// Titulo Compensado Totalmente 
					{ 'E2_SALDO <> 0'         , 'BR_AZUL'} }	// Titulo Compensado Parcialmente

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis 		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aRotina := MenuDef()    
Private cCodDiario	:= ""
Private cSavArea := alias()
Private nSavOrd	:= IndexOrd()
Private nRecNo	:= RecNo()


CODFORCP  	:= ""	//para contabilizar o Codigo do Fornecedor da Compensacao
LOJFORCP 	:= ""	//para contabilizar a Loja do Fornecedor da Compensacao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                PARAMETROS  	                     ³
//³                              	                 ³
//³ MV_PAR01 : Considera Loja  Sim/Nao               ³
//³ MV_PAR02 : Considera Fornecedor  Original/Outros ³
//³ MV_PAR03 : Do Fornecedor                         ³
//³ MV_PAR04 : Ate Fornecedor                        ³
//³ MV_PAR05 : Considera filiais abaixo              ³
//³ MV_PAR06 : Da Filial                             ³
//³ MV_PAR07 : Ate a Filial                          ³
//³ MV_PAR08 : Aglutina Lancto?                      ³
//³ MV_PAR09 : Mostra Lancamentos Cont beis          ³
//³ MV_PAR10 : Compensa Normais ou Impostos          ³
//³ MV_PAR11 : Contabiliza On-Line                   ³
//³ MV_PAR12 : Compensa Transferidos (em bordero)    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega fun‡„o Pergunte                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey (VK_F12,{|a,b| AcessaPerg("AFI340",.T.)})
Pergunte("AFI340",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabe‡alho da tela de baixas				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := OemToAnsi(STR0025)  //"Compensa‡„o de Titulos"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o numero do Lote 							³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cLote
LoteCont( "FIN" )

PRIVATE	VALOR 	:= 0
PRIVATE VALOR4	:= 0
PRIVATE VLRINSTR := 0
PRIVATE	cMarca	:= GetMark()
PRIVATE	lFina340 := ExistBlock("FA340FILT")
PRIVATE	cCpoNum

PRIVATE nTamTit := TamSX3("E2_PREFIXO")[1]+TamSX3("E2_NUM")[1]+TamSX3("E2_PARCELA")[1]
PRIVATE nTamTip := TamSX3("E2_TIPO")[1]
Private aTxMoedas	:=	{}

Private nPosArotina := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura aTxMoedas         ³
//³ [1] -> Nome Moeda          	³
//³ [2] -> Taxa a Ser Utilizada	³
//³ [3] -> Picture          	³
//³ [4] -> Taxa do dia atual    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
Aadd(aTxMoedas,{"",1,PesqPict("SM2","M2_MOEDA1"),1})
For nA := 2	To MoedFin()
	cMoedaTx :=	Str(nA,IIf(nA <= 9,1,2))
	If !Empty(GetMv("MV_MOEDA"+cMoedaTx))
		nVlMoeda := RecMoeda(dDataBase,nA)
		Aadd(aTxMoedas,{GetMv("MV_MOEDA"+cMoedaTx),nVlMoeda,PesqPict("SM2","M2_MOEDA"+cMoedaTx),nVlMoeda })
	Else
		Exit
	Endif
Next

If nPosArotina > 0 // Sera executada uma opcao diretamento de aRotina, sem passar pela mBrowse
	dbSelectArea("SE2")
	bBlock := &( "{ |a,b,c,d,e| " + aRotina[ nPosArotina,2 ] + "(a,b,c,d,e) }" )
	Eval( bBlock, Alias(), (Alias())->(Recno()),nPosArotina)
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de entrada para ser utilizado antes do Browse          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea("SE2")
	dbSetOrder(1)
	dbGoTop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endere‡a a Fun‡„o de BROWSE				³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mBrowse( 6, 1,22,75,"SE2",,,,,,Fa340Leg())
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SE2->(DbClearFilter())
dbSelectArea("SE2")
dbSetOrder(nSavInd)
dbGoTo(nSavRec)

Return(nil) 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Fa340Comp³ Autor ³ Valter G. Nogueira Jr.³ Data ³ 18/04/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marca‡„o dos titulos para compensa‡„o							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fa340Comp() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F340C(cAlias,cCampo,nOpcE)


Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
Local cVarQ 		:= "  "
LOCAL lContabil	:= .f.
LOCAL lPadrao
LOCAL nPosCnt	   :=0
LOCAL nOpca			:=0
LOCAL nTotal		:=0
LOCAL nValorComp	:=0
LOCAL nValorDec		:=0
LOCAL nValorAcre	:=0

LOCAL cAdiantamento
LOCAL cArquivo
LOCAL cPadrao	:="597"
Local nValBX	:= 0			// Valor da baixa na moeda 1
Local nValBX2	:= 0			// Valor da baixa na moeda do tit principal
LOCAL nOrdem	:= SE2->(IndexOrd())
LOCAL nTitIni	:= SE2->(Recno())
LOCAL lF340_PA := ExistBlock("F340_PA")
Local lAglutina:= Iif(mv_par08==1,.T.,.F.)
Local lDigita  := iif(mv_par09==1,.T.,.F.)
Local nDecs   := 2
Local nSalTit := 0 
Local nDecs1  := MsDecimais(1)
LOCAL oTitulo
LOCAL oDlg
LOCAL oOk   := LoadBitmap( GetResources(), "LBOK" )
LOCAL oNo   := LoadBitmap( GetResources(), "LBNO" )
Local nSldReal := 0
LOCAL lF340NAT := ExistBlock("F340NAT")
LOCAL oGet01
LOCAL oValorCp
Local nTotAbat		:= 0
Local nValPadrao  := 0
Local nTit := 0
Local nAcresc := 0
Local nDecres := 0
Local cSetFilter := SE2->(DBFILTER()) // Salva o filtro
Local nX          := 0
Local nValImp     := 0
Local nValImpPa   := 0
Local aImp10925   := {}
Local aImp10925pa := {}
Local lVerLibTit := .T.
// Controla retencao de impostos da lei 10925.
Local lContrRet   := !Empty( SE2->( FieldPos( "E2_VRETPIS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE2->( FieldPos( "E2_VRETCSL" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETPIS" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_PRETCOF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETCSL" ) ) )

//Controla o Pis Cofins e Csll na baixa
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

Local	lIRPFBaixa := IIf( ! Empty( SA2->( FieldPos( "A2_CALCIRF" ) ) ), SA2->A2_CALCIRF == "2", .F.) .And. ;
				 !Empty( SE2->( FieldPos( "E2_VRETIRF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETIRF" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_VRETIRF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETIRF" ) ) ) 				 

Local aSize := {}
Local oPanel
Local oPanel2
Local lPaBruto		:= GetNewPar("MV_PABRUTO","2") == "1"  //Indica se o PA terá o valor dos impostos descontados do seu valor
Local lBaixaImp   := .F.
Local lPa := .F.
Local lGeraNDF := .F.
Local lGeraTx  := .F.
Local nPisTx   := 0
Local nCofTx   := 0
Local nCslTx   := 0
Local cLa
Local aButtonTxt := {}
Local aDiario :={}
Local lVldDtFin  := .T.
Local lChequeLib := .T.
Local cCondic
Local aAreaSE5   

Local aHelpPor	:= {}
Local aHelpSpa	:= {}
Local aHelpEng	:= {}
Local aTitAux   := {}

Local cChvSE2	:=	SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)

PRIVATE	aTitulos :={}
PRIVATE	aRecNo	:= {}
PRIVATE	aRegSE2	:= {}
PRIVATE	aBaixaSE5	:= {}
PRIVATE	cPrefixo := SE2->E2_PREFIXO
PRIVATE	cNum		:= SE2->E2_NUM
PRIVATE	cTipoTit := SE2->E2_TIPO
PRIVATE	cFornece := SE2->E2_FORNECE
PRIVATE	cLoja 	:= SE2->E2_LOJA
PRIVATE	cSaldo	:= CriaVar("E2_SALDO")
PRIVATE	nValor	:= CriaVar("E2_SALDO")
PRIVATE	cParcela := SE2->E2_PARCELA
PRIVATE	nMoeda	:= SE2->E2_MOEDA
PRIVATE	dBaixa	:= dDataBase  
PRIVATE dEmiss	:= SE2->E2_EMIS1
PRIVATE	nValTot	:= 0,nPosSaldo:=0,nPosValor:=0
PRIVATE	cBanco	:= Criavar("E2_PORTADO")
PRIVATE nHdlPrv	:=0
Private lDebito:=.F.
PRIVATE	nTxMoeda	:= SE2->E2_TXMOEDA
PRIVATE aFlagCTB	:= {}
PRIVATE lUsaFlag	:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
PRIVATE nValCorCM	:= 0

If !LockCmpCP( cChvSE2 )
	Return
Endif
		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ N„o permitir compensa‡ao de titulos de abatimento.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipoTit $ MVABATIM

	//ÚÄÄÄÄÄÄ¿
	//³HELP'S³
	//ÀÄÄÄÄÄÄÙ
	// Portugues
 	Aadd(aHelpPor,"Nao e permitida a compensacao a partir" )
 	Aadd(aHelpPor,"de um titulo de abatimento." )
	// Espanhol
 	Aadd(aHelpSpa,"No se permite hacer la compensacion" )
 	Aadd(aHelpSpa,"a partir de un titulo de descoento" )
	// Ingles
 	Aadd(aHelpEng,"It is not possible to execute the" )
 	Aadd(aHelpEng,"clearance based on a discounted bill" )

	PutHelp("PNOCMPABT",aHelpPor,aHelpEng,aHelpSpa,.F.)
	aHelpPor := {} ; 	aHelpSpa := {} ; 	aHelpEng := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Soluction's³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
	// Portugues
 	Aadd(aHelpPor,"Utilize um titulo de tipo" )
 	Aadd(aHelpPor,"diferente de abatimento." )
	// Espanhol
 	Aadd(aHelpSpa,"Utiliza un titulo de diverso" )
 	Aadd(aHelpSpa,"tipo de descontar." )
	// Ingles
 	Aadd(aHelpEng,"It uses a bill of different" )
 	Aadd(aHelpEng,"type of discounting." )

	PutHelp("SNOCMPABT",aHelpPor,aHelpEng,aHelpSpa,.F.)
	aHelpPor := {} ; 	aHelpSpa := {} ; aHelpEng := {}

	Help(" ",1,"NOCMPABT")

	Return (.T.)
Endif

If cTipoTit $ MV_CPNEG .or. Alltrim(cTipoTit) $ MVPAGANT
	lDebito:=.T.
Endif   

IF lFina340 				// EMBRAER
	dbSelectArea("SX3")
	dbSetOrder(2)
	If	dbSeek("E2_PO_NUM")
		If X3USO(X3_USADO)
			cCpoNum	:= SE2->E2_PO_NUM
		EndIf
	EndIf
	dbSelectArea(cAlias)
Endif                                                          

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ N„o permite compensa‡Æo de titulos nao liberados. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lVerLibTit
	If (!Empty(GetMv("MV_APRPAG")) .and. Empty(SE2->E2_DATALIB)).or.;
	   !( SE2->E2_TIPO $ MVPAGANT ) .And. ;
	   (GetMv("MV_CTLIPAG").and.Empty(SE2->E2_DATALIB).and.(SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE)>GetMV("MV_VLMINPG"))
		Help(" " , 1 , "FA080NAOLIB") // NÆo permite baixar t¡tulos nÆo liberados
		Return .F.
	Endif
EndIf

IF FindFunction( "CN062ValDocs" ) .AND. AliasIndic("FRD") .AND. SE2->(FieldPos("E2_TEMDOCS")) > 0
	If !CN062ValDocs("07",.F.)
		Help(" ",1, "FA340VLD",, "Existe(m) documento(s) não apresentado(s) para este titulo", 4,0)  
		Return .F. 
	EndIf
EndIf			 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ N„o permite compensa‡Æo de impostos possam ser acessados. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If GetMv("MV_IMPADT") != "S" .and. mv_par10 == 2
	Help(" ",1,"NOADTIMP")
	DeleteObject(oOk)
	DeleteObject(oNo)
	Return (.T.)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ N„o permite que t¡tulos j  baixados possam ser acessados. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SE2->E2_SALDO == 0
	Help(" ",1,"FA330JABAI")
	DeleteObject(oOk)
	DeleteObject(oNo)
	Return (.T.)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se data do movimento n„o ‚ menor que data limite de ³
//³ movimentacao no financeiro    								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lVldDtFin .and. !DtMovFin()
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso esteja ligado o controle de solicitacao de notas de credito e exista alguma ³
//³ pendencia para este titulo                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cPaisLoc	<> "BRA"
	SCU->(DbSetOrder(2))
Endif
If cPaisloc <> "BRA" .And. GetMv('MV_SOLNCP') .And. SE2->E2_TIPO == MVNOTAFIS ;
		.And. SCU->(MsSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_NUM+SE2->E2_PREFIXO)).And. Empty(SCU->CU_NCRED)
	HELP(" ",1,"SOLNCPAB")
	Return
Endif  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulos de adiantamento nÆo sÆo compensaveis como titulo principal. No ³
//³ caso doa tipos TX, quando for ISS (gerado via C.Receber) s¢ compenso c/³
//³ adiantamentos ao municipio. Quando gerados via C.Pagar, apenas com titu³
//³ los de adiantamento de impostos (TXA)                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (((cTipoTit $ MVTAXA .and. Alltrim(cFornece) == GetMv("MV_MUNIC")) .or. ;
		 !(cTipoTit $ MVTAXA)).and. mv_par10 == 2)  // Compensa‡Æo de impostos
	Help(" ",1,"NOTITCOMP")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recupera a Integridade dos dados     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE2")
	dbSetOrder(1)
	DeleteObject(oOk)
	DeleteObject(oNo)
	Return (.T.)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ A Data de Emissao(EMIS1) do Titulo posicionado não podera ser maior que|
//| a DataBase do Sistema.                                                 |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ         
If dEmiss > dDatabase 
	
	Help(" ",1,"NOTITSEL")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recupera a Integridade dos dados     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE2")
	dbSetOrder(1)
	DeleteObject(oOk)
	DeleteObject(oNo)
	Return (.T.)
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulos provisorios nao sao compensaveis como titulo principal.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipoTit $ MVPROVIS
	Help(" ",1,"NOCMPPROV",,STR0028+chr(13)+STR0029,1,0 )   //"Nao é permitida a compensacao a partir de"###"um titulo provisorio"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recupera a Integridade dos dados     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE2")
	dbSetOrder(1)
	DeleteObject(oOk)
	DeleteObject(oNo)
	Return (.T.)
Endif

If mv_par12 == 2 .and. !Empty(SE2->E2_NUMBOR)
	Help(" ",1,"NOCMPTRF")
	dbSelectArea("SE2")
	dbSetOrder(1)
	DeleteObject(oOk)
	DeleteObject(oNo)
	Return (.T.)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o titulo esta bloqueado - Gestao de Contratos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(SE2->(FieldPos("E2_MSBLQL"))) .And. SE2->E2_MSBLQL == "1"
	Help(" ",1,"SE2BLOQ")
	Return .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ AAF - Titulos originados no SIGAEFF não devem ser alterados   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "SIGAEFF" $ SE2->E2_ORIGEM
   Help(" ",1,"FAORIEFF")
   Return .F.
EndIf

If Empty(GetHelp("NOCHQADT"))
	//ÚÄÄÄÄÄÄ¿
	//³HELP'S³
	//ÀÄÄÄÄÄÄÙ
	// Portugues
	aHelpPor := {} ; 	aHelpSpa := {} ; 	aHelpEng := {}
 	Aadd(aHelpPor,"Operação não permitida, pois ainda não ")
 	Aadd(aHelpPor,"foi liberado o cheque desse pagamento, ")
 	Aadd(aHelpPor,"ou o cheque ainda não existe.")
	// Espanhol
 	Aadd(aHelpSpa,"Operación no permitida porque todavía ")
 	Aadd(aHelpSpa,"no se liberó el cheque de dicho pago o")
 	Aadd(aHelpSpa,"el cheque todavía no existe.")
	// Ingles
 	Aadd(aHelpEng,"Transaction not allowed because check ")
 	Aadd(aHelpEng,"for such payment has not been released," )
 	Aadd(aHelpEng,"yet or check does not still exist." )

	PutHelp("PNOCHQADT",aHelpPor,aHelpEng,aHelpSpa,.F.)
	aHelpPor := {} ; 	aHelpSpa := {} ; 	aHelpEng := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Soluction's³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
	// Portugues
 	Aadd(aHelpPor,"Gere o cheque do adiantamento e/ou" )
 	Aadd(aHelpPor,"Verifique a liberação do cheque." )
	// Espanhol
 	Aadd(aHelpSpa,"Genere cheque de anticipo y/o ")
 	Aadd(aHelpSpa,"Verifique liberación del cheque." )
	// Ingles
 	Aadd(aHelpEng,"Generate advance check and/or " )
 	Aadd(aHelpEng,"Verify check release." )

	PutHelp("SNOCHQADT",aHelpPor,aHelpEng,aHelpSpa,.F.)
	aHelpPor := {} ; 	aHelpSpa := {} ; aHelpEng := {}
Endif

// Se for um titulo de adiantamento, verifica se existem cheques nao liberados, pois se existir, nao permitir a baixa
// Isso ocorre quando o parametro MV_LIBCHEQ esta igual a N, foi gerado um cheque para o adiantamento e este
// ainda nao foi liberado
If Alltrim(cTipoTit) $ MVPAGANT 
	If mv_par01 = 1 .And. mv_par02 = 1
		//Considera Loja e Fornecedor Original.
		cCondic := 'SE2->E2_FORNECE == SEF->EF_FORNECE .And. SE2->E2_LOJA == SEF->EF_LOJA .And. SEF->EF_LIBER == "N"'
	Elseif (mv_par01 = 2 .And. mv_par02 = 1) .Or. (mv_par02 = 2)
		//Não considera Loja e considera o Fornecedor Original ou então apenas considera Outros Fornecedores.
		cCondic := 'SE2->E2_FORNECE == SEF->EF_FORNECE .And. SEF->EF_LIBER == "N"'
	Else
		cCondic := 'SEF->EF_LIBER == "N"'
	Endif
	
	SEF->(DbSetOrder(3))
	SEF->(MsSeek(xFilial("SEF")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+Pad(E2_NUMBCO,Len(SEF->EF_NUM)))))

	While SEF->(EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO+EF_NUM)==SE2->( E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+Pad(E2_NUMBCO,Len(SEF->EF_NUM)) ) .and. !SEF->(Eof())
		
		//Verifica se ha cheques nao liberados de acordo com a condicao.
		If &cCondic
			lChequeLib := .F. // Cheque nao esta liberado
			Exit 
		Endif
		
		SEF->(dbSkip())
	EndDo
	
	//Caso haja algum cheque nao liberado, a compensacao nao sera executada. Validação apenas para Brasil
		If cPaisLoc == "BRA"
			If !lChequeLib .Or. !FA340VerPA()
				Help(" ",1,"NOCHQADT")	
				dbSelectArea("SE2")
				dbSetOrder(1)
				DeleteObject(oOk)
				DeleteObject(oNo)
				Return (.T.)
			Endif
		EndIf
  
	//ANGOLA|BRASIL - Nao permitir compensar titulos de adiantamento relacionado a pedido
	#IFDEF TOP
		If cPaisLoc $ "ANG|BRA|MEX" .and. AliasInDic("FIE")
			FIE->(dbSetOrder(3))
			If FIE->(MsSeek(xFilial("FIE")+"P"+SE2->(E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)))
				Help(" ",1,"ADTXPED",,"STR0047",1,0)  //"Adiantamento relacionado a um pedido somente poderá ser utilizado no relacionamento com pedidos"
				dbSelectArea("SE2")
				dbSetOrder(1)
				DeleteObject(oOk)
				DeleteObject(oNo)
				Return (.T.)		
			Endif
		Endif
	#ENDIF	
		      
Endif   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a gravacao dos lancamentos do SIGAPCO          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PcoIniLan("000017")

While .T.

	//Se o titulo possuir taxa contratada, inicializo a moeda do titulo com a cotação contratada.
	If SE2->E2_MOEDA<1
		nTxMoeda	 := If(SE2->E2_TXMOEDA > 0 .and. Empty(SE2->E2_DTVARIA), SE2->E2_TXMOEDA,RecMoeda(dDatabase,1))
		aTxMoedas[1,2] := nTxMoeda
	Else
		nTxMoeda	 := If(SE2->E2_MOEDA > 1,If(SE2->E2_TXMOEDA > 0 .and. Empty(SE2->E2_DTVARIA), SE2->E2_TXMOEDA,RecMoeda(dDatabase,SE2->E2_MOEDA)),0)
		aTxMoedas[SE2->E2_MOEDA,2] := nTxMoeda
	EndIf

	nSaldo := SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Somente  verifica Abatimentos quando compensar titulos normais  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par10 == 1 
		nValImp := 0
		// Verifica os valores dos Txs (lei 10925) para subtrair do saldo do PA.
		If (lContrRet .Or. lIRPFBaixa) .And. SE2->E2_TIPO $ MVPAGANT			
			
			If lIRPFBaixa 				
				/*BEGINDOC
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Busca os TXs de IRPF na Baixa e configura a variável ³
				//³aImp10925 para tratamento na compensação.            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//ENDDOC*/
				aImp10925 := BuscaTxs(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCIR)
				
			Else	      
			
				aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL)			
				
			EndIf	

			For nX := 1 To Len(aImp10925)
				nValImp += aImp10925[nX][6]
			Next
			
		Endif
		If !lDebito
			nTotAbat := SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,,SE2->E2_FORNECE)
			nSaldo -= nTotAbat                                                                                    
		Endif

		//Para Pa Bruto NAO reconsituo a base somando os impostos
		IF !lPaBruto
			nSaldo += nValImp
		Endif
	Endif
	cSaldo := TRANSFORM( nSaldo, "@E 9999,999,999.99" )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Titulo a ser compensado			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	aSize := MSADVSIZE()
	If lPanelFin  //Chamado pelo Painel Financeiro			
		//Espacamento := 45
		dbSelectArea(cAlias)
		oPanelDados := FinWindow:GetVisPanel()
		oPanelDados:FreeChildren()
		aDim := DLGinPANEL(oPanelDados)
		DEFINE MSDIALOG oDlg OF oPanelDados:oWnd FROM 0,0 To 0,0 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )							
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Observacao Importante quanto as coordenadas calculadas abaixo: ³ 
		//³ -------------------------------------------------------------- ³ 		
		//³ a funcao DlgWidthPanel() retorna o dobro do valor da area do	 ³
		//³ painel, sendo assim este deve ser dividido por 2 antes da sub- ³
		//³ tracao e redivisao por 2 para a centralizacao. 					 ³		
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		nEspLarg := ((DlgWidthPanel(oPanelDados)/2) - 225) /2		 					
		nEspLin  := 20
		
   Else   
   	nEspLarg := 0 
   	nEspLin  := 2  
		DEFINE MSDIALOG oDlg FROM 88,31 TO 275,525 TITLE OemToAnsi(STR0005) PIXEL  //"Compensa‡„o de Titulos a Pagar"
	Endif	
	
	oDlg:lMaximized := .F.
	oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT    		
   
   @ 000+nEspLin, 002+nEspLarg TO 030+nEspLin, 245+nEspLarg OF oPanel	PIXEL
	@ 031+nEspLin, 002+nEspLarg TO 062+nEspLin, 245+nEspLarg OF oPanel	PIXEL		  	 		

	@ 15+nEspLin, 006+nEspLarg MSGET cPrefixo							SIZE 19, 10 OF oPanel PIXEL
	@ 15+nEspLin, 032+nEspLarg MSGET cNum 	 VALID !EMPTY(cNum)	SIZE 70, 10 OF oPanel PIXEL
	@ 15+nEspLin, 105+nEspLarg MSGET cParcela							SIZE 20, 10 OF oPanel PIXEL
    If lDebito
    	@ 15+nEspLin, 129+nEspLarg MSGET cTipoTit Picture "@!"  Valid !Empty(cTipoTit) .AND.;
		!cTipoTit $ MVABATIM .AND. cTipoTit $ MVPAGANT+"/"+MV_CPNEG;
		.AND. Fa340Tit1() SIZE 12, 10 OF oPanel PIXEL
    else
		@ 15+nEspLin, 129+nEspLarg MSGET cTipoTit Picture "@!"  Valid !Empty(cTipoTit) .AND.;
		!cTipoTit $ MVABATIM .AND. !cTipoTit $ MVPAGANT+"/"+MV_CPNEG;
		.AND. Fa340Tit1() SIZE 12, 10 OF oPanel PIXEL
	Endif
	@ 15+nEspLin, 155+nEspLarg	MSGET cFornece Valid fa340For(cFornece) SIZE 70, 10 OF oPanel PIXEL
	@ 15+nEspLin, 226+nEspLarg	MSGET cLoja  							Valid Fa340For(cFornece,cLoja) ;
		SIZE 16, 10 OF oPanel PIXEL

	@ 47+nEspLin, 006+nEspLarg	MSGET cSaldo WHEN .F.   			SIZE 41, 10 OF oPanel PIXEL
	@ 47+nEspLin, 060+nEspLarg	MSGET nMoeda  WHEN .F.	 SIZE 18, 10 OF oPanel PIXEL
	@ 47+nEspLin, 085+nEspLarg	MSGET oValorCp VAR nValor  Picture	"@E 9999,999,999.99";
		Valid nValor >= 0 .AND. nValor <= nSaldo;
		SIZE 52, 10 OF oPanel PIXEL HASBUTTON
	oValorCp:cReadvar:= "NLIM450"
	@ 47+nEspLin, 142+nEspLarg	MSGET dBaixa   Valid dBaixa >= SE2->E2_EMISSAO .and. ;
						If(ExistBlock("F340DTFIN") .and. ExecBlock("F340DTFIN",.F.,.F.),DtMovFin(dBaixa),) SIZE 41, 10 OF oPanel PIXEL  HASBUTTON
	@ 07+nEspLin, 006+nEspLarg SAY OemToAnsi(STR0006)  SIZE 21, 7 OF oPanel PIXEL  //"Prefixo"
	@ 07+nEspLin, 032+nEspLarg SAY OemToAnsi(STR0007)  SIZE 22, 7 OF oPanel PIXEL  //"N£mero"
	@ 06+nEspLin, 105+nEspLarg SAY OemToAnsi(STR0008)  SIZE 23, 7 OF oPanel PIXEL  //"Parcela"
	@ 06+nEspLin, 129+nEspLarg SAY OemToAnsi(STR0009)  SIZE 14, 7 OF oPanel PIXEL  //"Tipo"
	@ 06+nEspLin, 155+nEspLarg SAY OemToAnsi(STR0010)  SIZE 34, 7 OF oPanel PIXEL  //"Fornecedor"
	@ 06+nEspLin, 226+nEspLarg SAY OemToAnsi(STR0011)  SIZE 14, 7 OF oPanel PIXEL  //"Loja"

	@ 38+nEspLin, 006+nEspLarg SAY OemToAnsi(STR0012)  SIZE 34, 7 OF oPanel PIXEL  //"Saldo"
	@ 38+nEspLin, 060+nEspLarg SAY OemToAnsi(STR0013)  SIZE 21, 7 OF oPanel PIXEL  //"Moeda"
	@ 38+nEspLin, 085+nEspLarg SAY OemToAnsi(STR0014)  SIZE 55, 7 OF oPanel PIXEL  //"Valor a compensar"
	@ 38+nEspLin, 142+nEspLarg SAY OemToAnsi(STR0015)  SIZE 45, 7 OF oPanel PIXEL  //"Data da Baixa"


	If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
		SX3->(DbSetorder(2))
		SX3->(DbSeek("E5_DIACTB"))
		cCodDiario  := Criavar("E5_DIACTB",.T.)          
		cTitDiar :=  AllTrim(X3TITULO())
		SX3->(DbSetorder(1))
		@ 038+nEspLin, 192+nEspLarg SAY cTitDiar SIZE 45, 7 OF oPanel PIXEL  
		@ 047+nEspLin, 192+nEspLarg MSGET cCodDiario F3 "CVL" SIZE 20, 10 OF oPanel Valid VldCodSeq( cCodDiario ) When CtbWdia() PIXEL HASBUTTON
	Endif
   
	If lPanelFin  //Chamado pelo Painel Financeiro			
		aButtonTxt := {} 	// esse array deve ser reiniciado do zero pois uma vez com conteudo e o processo 
							  	// for reiniciado, seu conteudo sera adicionado quantas vezes se reiniciar, e assim
						   	// sera exibido varios botoes na barra de ferramentas
						   	
		AADD(aButtonTxt,{STR0026,STR0026, {||Fa340SetMo()}})       
		
		oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])			
		ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
		{||nOpca:=1,If(fa340Tudok(oDlg),oDLg:End(),nOpca:=2)},;
		{||nOpca:=0,oDlg:End()},,aButtonTxt)
		
		FinVisual(cAlias,FinWindow,(cAlias)->(Recno()),.T.)

   Else	
	
		@ 68, 05 BUTTON OemToAnsi(STR0026) SIZE 50,18 ACTION (Fa340SetMo()) OF oPanel PIXEL //Taxas Moedas			
	
		DEFINE SBUTTON FROM 68, 190 TYPE 1 ENABLE ACTION (nOpca:=1,If(fa340Tudok(oDlg),oDLg:End(),nOpca:=2)) OF oPanel
		DEFINE SBUTTON FROM 68, 218 TYPE 2 ENABLE ACTION (nOpca:=0,oDlg:End()) OF oPanel
		ACTIVATE MSDIALOG oDlg CENTERED
	
	Endif

	IF nOpca == 0
		DbSelectArea(cAlias)
		dbSetOrder(nOrdem)
		Exit
	EndIF

	If nOpca == 2  //Dados Invalidos	validados no botao OK
		Loop
	Endif

	dbSelectArea(cAlias)
	nRecNo	:= RecNo()
	Fa340Tit() //Gera Tabela com os titulos - aTitulos
	If Len(aTitulos) == 0
		Help(" ",1,"NOTITSEL")
		Exit
	EndIf

	aTitAux := AClone(aTitulos)      
	
	nQtdTit := 0	 // quantidade de titulos,mostrado no rodape do browse

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Titulos a compensar         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOpca   := 0

	aSize := MsAdvSize(,.F.,400)
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	oDLg:lMaximized := .T.
	oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_TOP

	@003,005 Say STR0042 + Pad(Getmv("MV_SIMB"+Alltrim(STR(SE2->E2_MOEDA))),4)  PIXEL Of oPanel  // "Compensaçäo de Titulos - Valores expressos em " 

	If cPaisLoc == "BRA"			
	   @ 1.0, 1.0 LISTBOX oTitulo   VAR cVarQ Fields;
		  HEADER "",OemToAnsi(STR0006),;  //"Prefixo"
		  OemToAnsi(STR0007),;  //"N£mero"
		  OemToAnsi(STR0008),;  //"Parcela"
		  OemToAnsi(STR0009),;  //"Tipo"
		  OemToAnsi(STR0016),;  //"Saldo do t¡tulo"
		  OemToAnsi(STR0017),;   //"Valor compensado"
		STR0038,; //"Acréscimos"
		STR0039,; //"Decréscimos"
		  OemToAnsi(STR0010),;   //"Fornecedor"			
 		  OemToAnsi(STR0027),;   //"Emissao"						  			  		  
 		  OemToAnsi(STR0043);
		  COLSIZES 12, GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBBBBBBBB"),;
		  GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBB"),;
		GetTextWidth(0,"BBBBBBBBBB"),GetTextWidth(0,"BBBBBBBBBB"),;
		GetTextWidth(0,"BBBBBBBBB"),GetTextWidth(0,"BBBBBBBBB"),;
		GetTextWidth(0,"BBBBBBBBBB");
		  SIZE 293,54.5 ON DBLCLICK (aTitulos:=FA340Troca(oTitulo:nAt,aTitulos,oGet01),oTitulo:Refresh()) NOSCROLL

	   oTitulo:SetArray(aTitulos)
	   oTitulo:bLine := { || {If(aTitulos[oTitulo:nAt,8],oOk,oNo),;
			aTitulos[oTitulo:nAt,1],aTitulos[oTitulo:nAt,2],;
			aTitulos[oTitulo:nAt,3],aTitulos[oTitulo:nAt,4],;
			aTitulos[oTitulo:nAt,5],aTitulos[oTitulo:nAt,6],;
			aTitulos[oTitulo:nAt,10],aTitulos[oTitulo:nAt,11],;
			aTitulos[oTitulo:nAt,7],aTitulos[oTitulo:nAt,12],;
			aTitulos[oTitulo:nAt,13]}}
	Else
	   @ 1.0, 1.0 LISTBOX oTitulo   VAR cVarQ Fields;
		  HEADER "",OemToAnsi(STR0006),;  //"Prefixo"
		  OemToAnsi(STR0007),;  //"N£mero"
		  OemToAnsi(STR0008),;  //"Parcela"
		  OemToAnsi(STR0009),;  //"Tipo"
		  OemToAnsi(STR0016),;  //"Saldo do t¡tulo"
		  OemToAnsi(STR0017),;   //"Valor compensado"
		  STR0038,; //"Acréscimos"
		  STR0039,; //"Decréscimos"
		  OemToAnsi(STR0010),;   //"Fornecedor"			
		  OemToAnsi(STR0013),;   //"Moeda"						  
		  OemToAnsi(STR0027);   //"Emissao"						  			  		  
		  COLSIZES 12, GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBBBBBBBB"),;
			GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBB"),;
			GetTextWidth(0,"BBBBBBBBBB"),GetTextWidth(0,"BBBBBBBBBB"),;
			GetTextWidth(0,"BBBBBBBBBB"),GetTextWidth(0,"BBBBBBBBBB"),;
			GetTextWidth(0,"BBBBBBBBBB"),;
	      GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBBBBBBB");			  		  
		  SIZE 293,54.5 ON DBLCLICK (aTitulos:=FA340Troca(oTitulo:nAt,aTitulos,oGet01),oTitulo:Refresh()) NOSCROLL

	   oTitulo:SetArray(aTitulos)
	   oTitulo:bLine := { || {If(aTitulos[oTitulo:nAt,8],oOk,oNo),;
			aTitulos[oTitulo:nAt,1],aTitulos[oTitulo:nAt,2],;
			aTitulos[oTitulo:nAt,3],aTitulos[oTitulo:nAt,4],;
			aTitulos[oTitulo:nAt,5],aTitulos[oTitulo:nAt,6],;
			aTitulos[oTitulo:nAt,11],aTitulos[oTitulo:nAt,12],;
			aTitulos[oTitulo:nAt,7],aTitulos[oTitulo:nAt,9],;
			aTitulos[oTitulo:nAt,10]}}
	EndIf	  
	//////////////////////////
	// Marca ou desmarca todos
	oTitulo:bHeaderClick := {|oObj,nCol| If( nCol==1, fMarkAll(@aTitulos, @nValTot),Nil), oTitulo:Refresh(),oGet01:Refresh()}
	oTitulo:Align := CONTROL_ALIGN_ALLCLIENT
	//---
   	@  4, 353 SAY STR0031 PIXEL OF oPanel SIZE 70,7
	@	4, 403 MSGET oGet01 VAR nValTot PICTURE "@E 999,999,999.99" WHEN .F. PIXEL OF oPanel SIZE 70,7   
   
   If !lPanelFin  //Chamado pelo Painel Financeiro			
   		oPanel2 := TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,20,20,.T.,.T. )
		oPanel2:Align := CONTROL_ALIGN_BOTTOM   
   	
   		@  4, 008 BUTTON STR0030 SIZE 50,11 ACTION ( Fa340Inver(@aTitulos,@oTitulo,@oGet01) ) OF oPanel2 PIXEL 
		@  4, 065 BUTTON STR0001 SIZE 50,11 ACTION PesqListBox(@oTitulo,aTitulos) OF oPanel2 PIXEL 	
   Else
   	aButtonTxt := {}	
		AADD(aButtonTxt,{"STR0045",STR0030, {||Fa340Inver(@aTitulos,@oTitulo,@oGet01)}})        
		AADD(aButtonTxt,{STR0001,STR0001, {||PesqListBox(@oTitulo,aTitulos)}})       
   Endif
   
	If lPanelFin  //Chamado pelo Painel Financeiro			
	   ACTIVATE MSDIALOG oDlg ON INIT (oTitulo:Refresh(), FaMyBar(oDlg,;
	   	{|| nOpca := 1,IF(Fa340OK(),oDlg:End(),nOpca:=0)},;   					
			{|| oDlg:End()},,aButtonTxt))     
	Else
		DEFINE SBUTTON FROM 4 ,325 TYPE 1 ACTION (nOpca := 1,IF(Fa340OK(),oDlg:End(),nOpca:=0)) ENABLE OF oPanel2
		DEFINE SBUTTON FROM 4 ,360 TYPE 2 ACTION oDlg:End() ENABLE OF oPanel2
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT (oTitulo:Refresh())
	Endif	

	If nOpcA == 2
		Loop
	ElseIf nOpcA == 0 .or. nOpca == 3
		F340Semaforo(aTitulos,.F.,0)
		Exit
	Else
		If Str(nValtot,17,2) != Str(nValor,17,2) .and. nValor != 0 .and. nOpca == 1
			Help(" ",1,"FA330COMP")
			Loop
		Endif
		nValor := (Int(nValTot*100)/100)
		If Str(nValor,17,2) > Str(nSaldo,17,2)
			Help(" ",1,"FA330IVAL")
			Loop
		EndIf

		DbSelectArea("SE2")
		nOrdSE2	:= IndexOrd()
		dbGotop()

		lPadrao:=VerPadrao(cPadrao)
		VALOR  	:= 0
		VLRINSTR	:= 0
		ABATIMENTO := 0
		aRegSE2 := {}
		aBaixaSE5 := {}
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicio da prote‡„o via TTS								  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Begin Transaction
		For nTit := 1 to Len(aTitulos)
			nPosCnt++
			// Zero a variavel que soma os impostos (lei 10925) do titulo.
			nValImp := 0
			nValImpPa := 0
			nPixTx    := 0
			nCofTx    := 0
			nCslTx    := 0
			lBaixaImp := .F.
			lGeraNdf  := .F.
			lGeraTx   := .F.

			IF aTitulos[nTit,8]
				IF lPadrao .and. !lContabil .and. mv_par11 == 1
					nTotal := 0
					lContabil := .t.
					nHdlPrv := HeadProva( cLote,;
					                      "FINA340",;
					                      Substr( cUsuario, 7, 6 ),;
					                      @cArquivo )
				EndIf
				// Posiciona no PA/NDF				
				dbSelectArea("SE2")
				dbGoTo(aRecNo[nTit])
				aAdd(aRegSE2, aRecNo[nTit])
				cAdiantamento := E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
				cChave := "SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO"
				//Identifica se uma compensacao partiu de um PA
				If !(SE2->E2_TIPO $ MVPAGANT)
					lPa := .T.
					If !Empty(E2_BASEPIS) .and. E2_PIS > 0 // Posicionado no principal
						lGeraTx := .T.
						nPisTx := SE2->E2_PIS
						nCofTx := SE2->E2_COFINS
						nCslTx := SE2->E2_CSLL
					EndIf
					If lPaBruto .and. (lContrRet .Or. lIRPFBaixa) .and. Empty(SE2->E2_TITADT) //Verifico se os impostos deste PA ja foram retidos
						dbGoTo(nRecno) //Posiciona no PA para calcular impostos
						
						If Empty(SE2->E2_TITADT) //Verifico se os impostos deste PA ja foram retidos
						
							If lIRPFBaixa
								aImp10925pa := BuscaTXs(E2_PREFIXO,E2_NUM,E2_PARCELA,E2_PARCIR)
							Else								
								aImp10925pa := TxLei10925(E2_PREFIXO,E2_NUM,E2_PARCELA,E2_PARCPIS,E2_PARCCOF,E2_PARCSLL)
							EndIf	
							
							For nX := 1 To Len(aImp10925pa)
							
								nValImpPa += aImp10925pa[nX][6]
								
							Next
							If Len(aImp10925pa) > 0 .And. ! lIRPFBaixa
								nPisTx -= aImp10925pa[1][6]
								nCofTx -= aImp10925pa[2][6]
								nCslTx -= aImp10925pa[3][6]
							EndIf
							
						EndIf
						
						dbGoTo(aRecNo[nTit]) //Volta no título principal
					EndIf
				EndIf
				// Verifica os valores dos Txs (lei 10925) para subtrair do saldo do PA.
				If lContrRet .Or. lIRPFBaixa
				
					If lIRPFBaixa                                                      
						aImp10925 := BuscaTxs(E2_PREFIXO,E2_NUM,E2_PARCELA,E2_PARCIR)
					Else
						aImp10925 := TxLei10925(E2_PREFIXO,E2_NUM,E2_PARCELA,E2_PARCPIS,E2_PARCCOF,E2_PARCSLL)
					EndIf
																		
					For nX := 1 To Len(aImp10925)
						nValImp += aImp10925[nX][6]
					Next
					
					//Se for PABruto e já tiver retido os impostos em outra compensacao zera o valor dos impostos
					If lPaBruto .and. SE2->E2_TIPO $ MVPAGANT .and. !empty(SE2->E2_TITADT)
						nValImp := 0
					EndIf
					
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se Considera Fornecedor Original  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cAdiantamento += SE2->E2_FORNECE
				cChave +="+SE5->E5_CLIFOR"
				cAdiantamento += SE2->E2_LOJA
				cChave += "+SE5->E5_LOJA"
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valor da baixa na moeda 1 							  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If cPaisLoc == "BRA"
					nValBx := aTitulos[nTit,9]
					nAcresc := Fa340VTit(aTitulos[nTit,10])
					nDecres := Fa340VTit(aTitulos[nTit,11])
				Else
					nValBx := Fa340VTit(aTitulos[nTit,6])
					nAcresc := Fa340VTit(aTitulos[nTit,11])
					nDecres := Fa340VTit(aTitulos[nTit,12])
				Endif
				
				IF lPadrao
				   If cPaisLoc == "BRA"								
					  nValorComp += Round(NoRound(xMoeda(nValBx,nMoeda,1,,3,Fa340TxMd(nMoeda,nTxMoeda)),3),2)
				   Else
				      nValorComp += xMoeda(nValBX,nMoeda,1,aTitulos[nTit,10],,aTxMoedas[aTitulos[nTit,9]][2])										   
				   EndIf	   										  
				EndIf
				
				dbSelectArea("SE2")
				dbGoTo(nRecNo)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Guardo dados do titulo principal para utilizar   ³
				//³ no historico da contabiliza‡Æo                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				STRLCTPAD := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+;
								 SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA

				CODFORCP := SE2->E2_FORNECE
				LOJFORCP := SE2->E2_LOJA
				
				//Controle de PABruto
				If !Empty(E2_BASEPIS) .and. E2_PIS > 0 .and. !lPA
					nPisTx := SE2->E2_PIS
					nCofTx := SE2->E2_COFINS
					nCslTx := SE2->E2_CSLL
				EndIf				
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valor da Baixa na moeda do titulo principal 	  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If cPaisLoc == "BRA"
					nValBx2 := aTitulos[nTit,9]
					nAcresc := Fa340VTit(aTitulos[nTit,10])
					nDecres := Fa340VTit(aTitulos[nTit,11])
					
					//Tratamento PA Bruto
					If lPaBruto .and. !lPa	//Compensacao partiu do titulo principal
						If SE2->E2_SALDO >= (nValBx2 + nValImp)
							lBaixaImp := .T.
						ElseIf SE2->E2_SALDO == (Fa340VTit(aTitulos[nTit,5]) - nValImp)
							lGeraNDF := .T.
							If !Empty(E2_BASEPIS) .and. E2_PIS > 0
								lGeraTX := .T.
								nPisTx  -= aImp10925[1][6]
								nCofTx  -= aImp10925[2][6]
								nCslTx  -= aImp10925[3][6]
							EndIf
						ElseIf SE2->E2_SALDO < nValBx2
							nValBx  := SE2->E2_SALDO
							nValBx2 := SE2->E2_SALDO
						EndIf
					ElseIf lPaBruto .and. lPa	//Compensação partiu do PA
						If Fa340VTit(aTitulos[nTit,5]) >= (nValBx2 + nValImpPa)
							lBaixaImp := .T.
						ElseIf Fa340VTit(aTitulos[nTit,5]) == SE2->E2_SALDO
							lGeraNDF := .T.
						EndIf
					EndIf
				Else
					nValBx2 := Fa340VTit(aTitulos[nTit,6])
					nAcresc := Fa340VTit(aTitulos[nTit,11])
					nDecres := Fa340VTit(aTitulos[nTit,12])
				Endif
				
				If cPaisLoc == "BRA"
					nValorDec	+= Round(NoRound(xMoeda(nDecres,nMoeda,1,,3,Fa340TxMd(nMoeda,nTxMoeda)),3),2)
					nValorAcre 	+= Round(NoRound(xMoeda(nAcresc,nMoeda,1,,3,Fa340TxMd(nMoeda,nTxMoeda)),3),2)
				Else
					nValorDec  += xMoeda(nDecres,nMoeda,1,aTitulos[nTit,10],,aTxMoedas[aTitulos[nTit,9]][2])										   
					nValorAcre += xMoeda(nAcresc,nMoeda,1,aTitulos[nTit,10],,aTxMoedas[aTitulos[nTit,9]][2])										   
				EndIf

				//Verifica se o valor do acrescimo e maior que o da baixa.
				If nAcresc > nValBx2                                
					nAcresc := nValBx2	
				Endif
				
				Fa340Grv(lPadrao,nValBx2,cAdiantamento,,aRecno[nTit],lDebito,mv_par11,Fa340TxMd(nMoeda,nTxMoeda),nAcresc,nDecres,aBaixaSE5,If(lPaBruto .and. lBaixaImp,If(lPA,nValImpPa,nValImp),0))
				
				//Ponto de entrada 
				
				//Se a compensacao partiu do titulo principal
				If !lPa
					If lBaixaImp
						//"Parti do princ, baixa imp"
						Fa340BxTxPa(aRecNo[nTit])
					ElseIf lGeraNDF
						//"Parti do princ, gera NDF"
						FA340GeraNDF(nRecno,nValImp+If(lGeraTx,nPisTx+nCofTx+nCslTx,0),cAdiantamento,lGeraTx)
						//Vou Gerar Tx com os impostos que não foram retidos no PA
						If lGeraTx
							SE2->(dbGoTo(nRecno))
							cLa := SE2->E2_LA
							RecLock("SE2")
							SE2->E2_LA := " " //Limpo flag de contabilização para gerar TX 
							MsUnlock()
							FGrvImpPcc(nPisTx,nCofTx,nCslTx,nRecno,.F.,,,"FINA340",nMoeda)

							SE2->(dbGoTo(nRecno))
							If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
								aAdd( aFlagCTB, {"E2_LA", "S", "SE2", SE2->( Recno() ), 0, 0, 0} )
							Else
								RecLock("SE2")
								SE2->E2_LA := cLa
								MsUnlock()
							EndIf
						EndIf
					EndIf
				Else //Se partiu de PA
					If lBaixaImp
						//"Parti do PA, baixa imp"
						Fa340BxTxPa(nRecno)
					ElseIf lGeraNDF
						//"Parti do PA, gera NDF"
						FA340GeraNDF(aRecNo[nTit],nValImpPa+If(lGeraTx,nPisTx+nCofTx+nCslTx,0),SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),lGeraTx)
						//Vou Gerar Tx com os impostos que não foram retidos no PA
						If lGeraTx
							SE2->(dbGoTo(aRecNo[nTit]))
							cLa := SE2->E2_LA
							RecLock("SE2")
							SE2->E2_LA := " " //Limpo flag de contabilização para gerar TX 
							MsUnlock()
							FGrvImpPcc(nPisTx,nCofTx,nCslTx,aRecNo[nTit],.F.,,,"FINA340",nMoeda)

							SE2->(dbGoTo(aRecNo[nTit]))
							If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
								aAdd( aFlagCTB, {"E2_LA", "S", "SE2", SE2->( Recno() ), 0, 0, 0} )
							Else
								RecLock("SE2")
								SE2->E2_LA := cLa
								MsUnlock()
							EndIf
						EndIf						
					EndIf
				EndIf

				//Verifica se existe solicitacao de NCP e caso exista atualiza o campo CU_DTBAIXA...			
				If cPaisLoc <> "BRA"				   				   
					A055AtuDtBx("1",SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_NUM,SE2->E2_PREFIXO,SE2->E2_BAIXA)
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona no adiantamento para contabiliza‡„o    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SE2")
				dbGoTo(aRecNo[nTit])
				DbSelectArea("SED")
				DbSetOrder(1)
				DbSeek(xFilial("SED")+SE2->E2_NATUREZ)
				dbSelectArea("SE2")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de Entrada				     		  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lF340NAT
					Execblock("F340NAT",.F.,.F.,nRecno)
				Endif
				dbSelectArea("SE2")
				dbGoTo(aRecNo[nTit])
				// Nao somo abatimentos, se o titulo for de debito
				If !(SE2->E2_TIPO $ MV_CPNEG + "/" + MVPAGANT)
					nTotAbat := SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,,SE2->E2_FORNECE)
				Else
					nTotAbat := 0	
				Endif	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza saldo do PA/NDF                      	  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Reclock("SE2")
				If cPaisLoc == "BRA"				
					//Atualiza a data de vencimento dos titulos de impostos
					If lDebito
						AltVencImp(dDataBase)
					Endif
					// Se estiver baixando tudo, zera o saldo
					If nValBx == Fa340VTit(aTitulos[nTit,5])
						SE2->E2_SALDO := 0
						SE2->E2_SDACRES := 0
						SE2->E2_SDDECRE := 0						
					Else   
						If lPccBaixa
							SE2->E2_SALDO	-= Round(NoRound(xMoeda(nValBx-nAcresc-nValImp+nDecres,nMoeda,SE2->E2_MOEDA,,3,If(nMoeda >= 1 ,Fa340TxMd(nMoeda,nTxMoeda),0),If(SE2->E2_MOEDA == 1,0,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA))),3),2)
							If lPaBruto
								SE2->E2_SALDO	-= Round(NoRound(xMoeda(If(lPa,nValImpPa,nValImp),nMoeda,SE2->E2_MOEDA,,3,If(nMoeda >= 1 ,Fa340TxMd(nMoeda,nTxMoeda),0),If(SE2->E2_MOEDA == 1,0,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA))),3),2)
							EndIf
						Else
							SE2->E2_SALDO	-= Round(NoRound(xMoeda(nValBx-nAcresc+nDecres,nMoeda,SE2->E2_MOEDA,,3,If(nMoeda >= 1 ,Fa340TxMd(nMoeda,nTxMoeda),0),If(SE2->E2_MOEDA == 1,0,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA))),3),2)
						EndIf                                                                                        
						SE2->E2_SDACRES	-= Round(Noround(xMoeda(nAcresc,nMoeda,SE2->E2_MOEDA,,3,If(nMoeda >= 1 ,Fa340TxMd(nMoeda,nTxMoeda),0),If(SE2->E2_MOEDA == 1,0,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA))),3),2)
						SE2->E2_SDDECRE	-= Round(Noround(xMoeda(nDecres,nMoeda,SE2->E2_MOEDA,,3,If(nMoeda >= 1 ,Fa340TxMd(nMoeda,nTxMoeda),0),If(SE2->E2_MOEDA == 1,0,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA))),3),2)
					Endif   
					SE2->E2_VALLIQ:= Round(NoRound(xMoeda(nValBx,nMoeda,SE2->E2_MOEDA,,3,If(nMoeda >= 1 ,Fa340TxMd(nMoeda,nTxMoeda),0),If(SE2->E2_MOEDA == 1,0,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA))),3),2)
					SE2->E2_MOVIMEN:= dBaixa					
				Else
					If nValBx == Fa340VTit(aTitulos[nTit,5]) 
						SE2->E2_SALDO := 0
						SE2->E2_SDACRES := 0
						SE2->E2_SDDECRE := 0						
					Else
						nDecs := MsDecimais(SE2->E2_MOEDA)
						nSalTit := SE2->E2_SALDO - Round(xMoeda(nValBx-nAcresc+nDecres,nMoeda,SE2->E2_MOEDA,dDatabase,nDecs+1,aTxMoedas[nMoeda][2],aTxMoedas[SE2->E2_MOEDA][2]),nDecs)				
						SE2->E2_SALDO   := Iif(nSalTit <= 0,0,nSalTit)
					EndIf   
					SE2->E2_MOVIMEN := dDatabase				
					SE2->E2_VALLIQ  += Round(xMoeda(nValBx,nMoeda,1,dDatabase,nDecs1+1,aTxMoedas[nMoeda][2]),nDecs1)				
				EndIf   				
				SE2->E2_BAIXA := dDataBase				   				   
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona no registro de natureza		³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SED->(MsSeek(xFilial("SED")+SE2->E2_NATUREZ))
				// Efetua a baixa dos titulos de abatimento
				If !( E2_TIPO $ MVPAGANT+"/"+MV_CPNEG )
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Baixar titulos de abatimento se for baixa total				  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SE2")
					nSalvRec := Recno()
					If (E2_SALDO-nTotabat) <= 0
						dbSetOrder(1)
						dbSeek(xFilial("SE2")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA))
						cPrefixo := SE2->E2_PREFIXO
						cNum := SE2->E2_NUM
						cParcela := SE2->E2_PARCELA
						While !EOF() .And. E2_FILIAL==xFilial("SE2") .And. E2_PREFIXO=cPrefixo 		.And.;
												E2_NUM==cNum 			.And. E2_PARCELA==cParcela
				
							IF E2_FORNECE==cFornece	.And. E2_LOJA == cLoja
								IF E2_TIPO $ MVABATIM
									RecLock("SE2")
									Replace E2_SALDO	  With 0
									Replace E2_BAIXA	  With Iif(E2_BAIXA<=dBaixa,dBaixa,E2_BAIXA)
									Replace E2_LOTE	  With cLote
									Replace E2_MOVIMEN  With dBaixa
									Replace E2_PORTADO  With cBanco
									MsUnlock( )
								EndIF
							Endif
							dbSelectArea( "SE2" )
							dbSkip( )
						Enddo
					Endif
					dbGoto(nSalvRec)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza campo de maior atraso no Cadastro de Fornecedores		³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nAtraso:=dBaixa-SE2->E2_VENCTO
					If nAtraso > 1
						IF Dow(SE2->E2_VENCTO) == 1 .Or. Dow(SE2->E2_VENCTO) == 7
							IF Dow(dBaixa) == 2 .and. nAtraso <= 2
								nAtraso := 0
							EndIF
						EndIF
						nAtraso:=IIF(nAtraso<0,0,nAtraso)
						If SA2->A2_MATR < nAtraso
							dbSelectArea( "SA2" )
							dbSetOrder( 1 )
							If SA2->( MsSeek( xFilial( "SA2" ) + SE2->E2_FORNECE + SE2->E2_LOJA ) )
								RecLock( "SA2" )
								Replace A2_MATR With nAtraso
								MsUnlock()
							EndIf
						Endif
					Endif
	            Endif

				MsUnlock()

				//Atualiza dados do fornecedor
				If SE2->E2_MOEDA > 1
					nValPadrao := Round(NoRound(xMoeda(nValBx - nValImp,nMoeda,SE2->E2_MOEDA,,3,,If(cPaisLoc=="BRA",Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),0)),3),2)
					nValPadrao := Round(NoRound(xMoeda(nValBx - nValImp,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3,If(cPaisLoc=="BRA",Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),0)),3),2)
				Else
					nValPadrao := Round(NoRound(xMoeda(nValBx - nValImp,nMoeda,SE2->E2_MOEDA,,3,Fa340TxMd(nMoeda,nTxMoeda),Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA)),3),2)
				Endif

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Posicionar novamente no titulo posicionado antes de pressionar o botao Compensar³
				//³e posicionar na natureza correspondente                                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SE2")
				nSalvRec := Recno()
				
				dbGoTo(nRecNo)
				DbSelectArea("SED")
				DbSetOrder(1)
				DbSeek(xFilial("SED")+SE2->E2_NATUREZ)  //Posicionar na natureza antes de contabilizar
				dbSelectArea("SE2")
				dbGoto(nSalvRec)
		
				If lPadrao .and. mv_par11 == 1
					nTotal += DetProva( nHdlPrv,;
					                    cPadrao,;
					                    "FINA340",;
					                    cLote,;
					                    /*nLinha*/,;
					                    /*lExecuta*/,;
					                    /*cCriterio*/,;
					                    /*lRateio*/,;
					                    /*cChaveBusca*/,;
					                    /*aCT5*/,;
					                    /*lPosiciona*/,;
					                    @aFlagCTB,;
					                    /*aTabRecOri*/,;
					                    /*aDadosProva*/ )
				Endif

				dbSelectArea("SE2")
				dbGoTo(nRecNo)
				F340Semaforo(aTitulos[nTit],.F.,aRecno[nTit]) // LIBERA REGISTRO NO SEMAFORO
			Endif
			
		Next
		nRegSE5 := SE5->(Recno())
		nRegSE2 := SE2->(Recno())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posicionar novamente no titulo posicionado antes de pressionar o botao Compensar³
		//³e posicionar na natureza correspondente                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE2")
		dbGoTo(nRecNo)
		DbSelectArea("SED")
		DbSetOrder(1)
		DbSeek(xFilial("SED")+SE2->E2_NATUREZ)  //Posicionar na natureza antes de contabilizar
		dbSelectArea("SE2")
		
		If nValorComp > 0 .And. lPadrao .And. mv_par11 == 1
			SE5->(dbGoBottom())
			SE5->(dbSkip())
			SE2->(dbGoBottom())
			SE2->(dbSkip())
			VALOR    := nValorComp
			VALOR2	 := nValorAcre			
			VALOR3 	 := nValorDec
			VALOR4	 := nValCorCM
			
			VLRINSTR := nValorComp
			nSldReal := Round(NoRound(xMoeda(nSaldo,nMoeda,1,,3,If(cPaisLoc=="BRA",Fa340TxMd(nMoeda,nTxMoeda),0)),3),2)
			ABATIMENTO := IIF(STR(nSldReal,17,2) == STR(nValorComp,17,2),nTotAbat,0)
			REGVALOR := nRecNo    // usado para a contabiliza‡„o
			nTotal += DetProva( nHdlPrv,;
			                    cPadrao,;
			                    "FINA340",;
			                    cLote,;
			                    0,;
			                    .F.,;
			                    "FINA340",;
			                    /*lRateio*/,;
			                    /*cChaveBusca*/,;
			                    /*aCT5*/,;
			                    /*lPosiciona*/,;
			                    @aFlagCTB,;
			                    /*aTabRecOri*/,;
			                    /*aDadosProva*/ )
	
			For nX := 1 To Len(aBaixaSE5)

			If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
					AAdd(aDiario,{"SE5",aBaixaSE5[nX],cCodDiario,"E5_NODIA","E5_DIACTB"})
				EndIf	                
			Next nX

			RodaProva(  nHdlPrv,;
						nTotal)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia para Lan‡amento Contabil							  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cA100Incl( @cArquivo,;
			           nHdlPrv,;
			           3,;
			           cLote,;
			           lDigita,;
			           lAglutina,;
			           /*cOnLine*/,;
			           /*dData*/,;
			           /*dReproc*/,;
			           @aFlagCTB,;
			           /*aDadosProva*/,;
			           aDiario )
			aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento

		EndIf
		SE5->(dbGoTo(nRegSE5))
		SE2->(dbGoTo(nRegSE2))

		//integracao com modulo PCO
		Fa340IntPco(nRecno, aRegSE2, aClone(aBaixaSE5))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Final  da protecao via TTS							³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		End Transaction
	Endif
	Exit
Enddo

cPrefixo := CriaVar("E2_PREFIXO")
cNum		:= CriaVar("E2_NUM")
cTipoTit := CriaVar("E2_TIPO")
cFornece := CriaVar("E2_FORNECE")
cLoja 	:= CriaVar("E2_LOJA")
cSaldo	:= CriaVar("E2_SALDO")
nValor	:= CriaVar("E2_SALDO")
cParcela := CriaVar("E2_PARCELA")
nMoeda	:= 1
nValor	:= 0
nValTot	:= 0
VALOR4 	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a gravacao dos lancamentos do SIGAPCO            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PcoFinLan("000017")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE2")
dbSetOrder(nOrdem)
dbGoto(nTitIni)
DeleteObject(oOk)
DeleteObject(oNo)  
                                 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura o filtro, para que o usuario que utilizar filtro atraves do   ³ 
//³ PE FA340BROW nao perca este filtro.                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Filter to &cSetFilter.

UnLockCmpCP( cChvSE2 )

Return (.T.)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FA340For ³ Autor ³ Mauricio Pequim Jr 	  ³ Data ³ 05/01/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica validade do Fornecedor									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fa340For()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA340																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fa340For( cFornecedor, cLoja )

Local cAlias:=Alias()
Local lRet := .T.
Local nRecSe2
Local nOrdSe2

If Empty(cFornecedor)
	lRet := .F.
Else
	cAlias:=Alias()
	dbSelectArea("SA2")
	dbSetOrder(1)
	cLoja:=Iif(cLoja == Nil .or. (Empty(cLoja) .and. Empty(SE2->E2_LOJA)),"",cLoja)
	If !(dbSeek(xFilial("SA2")+cFornecedor+cLoja))
		lRet := .f.
	Else 
		dbSelectArea("SE2")
		nOrdSe2 := IndexOrd()
		nRecSe2 := Recno()
		dbSetOrder(1)
		If !MsSeek(xFilial("SE2")+cPrefixo+cNum+cParcela+cTipoTit+cFornecedor+cLoja)
			Help(" ",1,"NOTIT")
			lRet := .F.
		Endif
		dbSetOrder(nOrdSe2)
		DbGoto(nRecSe2)
	EndIf
Endif	
dbSelectArea(cAlias)
Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FA340Desc³ Autor ³ Wagner Xavier 		  ³ Data ³ 01/09/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cancelar a Compensa‡„o de Adiantamentos.						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FA340Desc() 						  									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA340				                          					  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FA340Desc( cAlias, nReg, nOpc )

Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
Local nOpcA 	 := 0
Local lCancelou := .F.
Local cNatureza
Local aRegistros:= {}
Local cChaveSE2
LOCAL cArquivo,nTotal:=0,lPadrao,cPadrao:="589"
LOCAL nRecSe2,nRecSe5
Local lFirst		:= .F.
Local nMoeda
Local nValorBaix:=0, nValBaix2:=0
Local nTotAbat    := 0
Local cDocumento
Local cCondic
Local lAglutina:= Iif(mv_par08==1,.t.,.f.)
Local lDigita  := iif(mv_par09==1,.T.,.F.)
Local oOk := LoadBitmap( GetResources(), "LBOK" )
Local oNo := LoadBitmap( GetResources(), "LBNO" )
Local cVarQ := "  "
Local oTitulo
LOCAL oDlg
Local lF340Can 	:= ExistBlock("F340CAN")
Local lF340ACan := ExistBlock("F340ACAN")
Local lF340FCan := ExistBlock("F340FCAN")
Local nDecs       := 2
Local nTxMoeda    := 0
Local nDecs1      := MsDecimais(1)
Local nLiq        := 0
Local lAchou
Local cFornAdt
Local	nLen
Local cChaveAdt
Local nLaco := 0 
Local nAcresc := 0		//Acrescimo do titulo de adiantamento
Local nDecres := 0		//Decrescimo do titulo de adiantamento
Local nTitAcres := 0		//Acrescimo do titulo principal
Local nTitDecre := 0		//Decrescimo do titulo principal
local nSE2Rec := 0
Local aSE5 := {}
Local nX := 0
Local	nValSaldo	:=	0
#IFDEF TOP
	Local nSE5  		:= 0
	Local cQuery	  	:= ""
	Local aStruSE5	  	:= {}
	Local lFa340Qry	:= Existblock("FA340QRY")
	Local cQueryADD	
#ENDIF
Local nValImp     := 0
Local aImp10925   := {}
// Controla retencao de impostos da lei 10925.
Local lContrRet   := !Empty( SE2->( FieldPos( "E2_VRETPIS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE2->( FieldPos( "E2_VRETCSL" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETPIS" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_PRETCOF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETCSL" ) ) )

Local lIRPFBaixa := IIf( ! Empty( SA2->( FieldPos( "A2_CALCIRF" ) ) ), SA2->A2_CALCIRF == "2", .F.) .And. ;
				 !Empty( SE2->( FieldPos( "E2_VRETIRF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETIRF" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_VRETIRF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETIRF" ) ) ) 

Local aSize	:= {}
Local oPanel
Local lPaBruto		:= GetNewPar("MV_PABRUTO","2") == "1"  //Indica se o PA terá o valor dos impostos descontados do seu valor
Local lNDF        := .F. //Identifica se o titulo tem NDF
Local aRecPa      := {}
Local nRecNDF
Local nRecAnt     := 0    
Local aDiario := {}
Local lVldDtFin := .T.
Local lAchouCli	:= .F.
Local aAreaAnt
Local cChaveE2Adt := ""
Local cChaveE5Adt := ""
Local aAreaE5Adt
Local aAreaE2Adt
Local cChvSemaf	:=	SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)

PRIVATE	aTitulos :={}
PRIVATE	cPrefixo := SE2->E2_PREFIXO
PRIVATE	cNum		:= SE2->E2_NUM
PRIVATE	cTipoTit := SE2->E2_TIPO
PRIVATE	cFornece := SE2->E2_FORNECE
PRIVATE	cLoja 	:= SE2->E2_LOJA
PRIVATE	cParcela := SE2->E2_PARCELA
PRIVATE lDebito := .F.
PRIVATE	cTipodoc := " "
PRIVATE cTipodc:=" "
PRIVATE nHdlPrv  := 0
PRIVATE aFlagCTB	:= {}
PRIVATE lUsaFlag	:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)

If !LockCmpCP( cChvSemaf )
	Return
Endif

nRegSE2 := SE2->( Recno() )

If cTipoTit $ MV_CPNEG .or. Alltrim(cTipoTit) $ MVPAGANT
	lDebito:=.T.   
	cTipodoc := "BA"
	cTipodc	 := "CP"
Else
	cTipodoc := "CP"
	cTipodc	 := "BA"
Endif              

If SE2->E2_TIPO $ MVABATIM
	Help(" ",1,"FA030INVAL")
	Return .T.
Endif
If lVldDtFin .and. !DtMovFin()
	Return
Endif	

While .T.
	aTitulos   := {}
	aRegistros := {}

	If lF340aCan 
		Return
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa a gravacao dos lancamentos do SIGAPCO          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoIniLan("000017")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Titulo a ser compensado          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aSize := MSADVSIZE()
	If lPanelFin  //Chamado pelo Painel Financeiro			
		dbSelectArea(cAlias)
		oPanelDados := FinWindow:GetVisPanel()
		oPanelDados:FreeChildren()
		aDim := DLGinPANEL(oPanelDados)
		DEFINE MSDIALOG oDlg OF oPanelDados:oWnd FROM 0,0 To 0,0 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )							
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Observacao Importante quanto as coordenadas calculadas abaixo: ³ 
		//³ -------------------------------------------------------------- ³ 		
		//³ a funcao DlgWidthPanel() retorna o dobro do valor da area do	 ³
		//³ painel, sendo assim este deve ser dividido por 2 antes da sub- ³
		//³ tracao e redivisao por 2 para a centralizacao. 					 ³		
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		nEspLarg := ((DlgWidthPanel(oPanelDados)/2) - 225) /2		 					
		nEspLin  := 20				
		
   Else   
   	nEspLarg := 0 
   	nEspLin  := 2
	DEFINE MSDIALOG oDlg FROM	88,31 TO 187,490 TITLE OemToAnsi(STR0005) PIXEL  //"Compensa‡„o de Titulos a Pagar"
	Endif
	
	oDlg:lMaximized := .F.
	oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT    		
	
	@ 00+nEspLin, 003+nEspLarg TO 29+nEspLin, 228+nEspLarg OF oPanel  PIXEL		

	@ 14+nEspLin, 006+nEspLarg MSGET cPrefixo                           SIZE 19, 10 OF oPanel PIXEL
	@ 14+nEspLin, 032+nEspLarg MSGET cNum     Valid !Empty(cNum)        SIZE 70, 10 OF oPanel PIXEL
	@ 14+nEspLin, 105+nEspLarg MSGET cParcela                           SIZE 20, 10 OF oPanel PIXEL
	@ 14+nEspLin, 129+nEspLarg MSGET cTipoTit Picture "@!"  Valid  !Empty(cTipoTit) .and.;
		!cTipoTit $ MVABATIM										SIZE 16, 10 OF oPanel PIXEL
	@ 14+nEspLin, 155+nEspLarg MSGET cFornece Valid fa340FOR(cFornece)  SIZE 52, 10 OF oPanel PIXEL
	@ 14+nEspLin, 210+nEspLarg MSGET cLoja Valid Fa340For(cFornece,cLoja)        SIZE 16, 10 OF oPanel PIXEL

	@ 06+nEspLin, 006+nEspLarg SAY OemToAnsi(STR0006)    SIZE 21, 7 OF oPanel PIXEL  //"Prefixo"
	@ 06+nEspLin, 032+nEspLarg SAY OemToAnsi(STR0007)    SIZE 22, 7 OF oPanel PIXEL  //"N£mero"
	@ 05+nEspLin, 105+nEspLarg SAY OemToAnsi(STR0008)    SIZE 23, 7 OF oPanel PIXEL  //"Parcela"
	@ 05+nEspLin, 129+nEspLarg SAY OemToAnsi(STR0009)    SIZE 14, 7 OF oPanel PIXEL  //"Tipo"
	@ 05+nEspLin, 155+nEspLarg SAY OemToAnsi(STR0010)    SIZE 34, 7 OF oPanel PIXEL  //"Fornecedor"
	@ 05+nEspLin, 210+nEspLarg SAY OemToAnsi(STR0011)    SIZE 14, 7 OF oPanel PIXEL  //"Loja"
  
	If lPanelFin  //Chamado pelo Painel Financeiro			
		oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])			
		ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
		{||nOpca:=1,oDLg:End()},;
		{||oDlg:End()})
		
		FinVisual(cAlias,FinWindow,(cAlias)->(Recno()),.T.)

   Else	
	DEFINE SBUTTON FROM 34, 168 TYPE 1 ENABLE ACTION (nOpca:=1,oDLg:End()) OF oDlg
	DEFINE SBUTTON FROM 34, 196 TYPE 2 ENABLE ACTION oDlg:End() OF oDlg
	ACTIVATE MSDIALOG oDlg CENTERED
	Endif	

	If nOpca==0
		UnLockCmpCP(cChvSemaf)
		Return
	EndIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o t¡tulo existe. 	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE2")
	dbSetOrder(6)
	dbSeek(cFilial+cFornece+cLoja+cPrefixo+cNum+cParcela+cTipoTit)
	If !Found()
		Help(" ",1,"NOTIT")
		dbSetOrder(1)
		DbGoto(nReg)
		UnLockCmpCP(cChvSemaf)
		Return
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o t¡tulo j  foi compensado.	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (SE2->E2_SALDO == SE2->E2_VALOR ) .and. ;
		(SE2->E2_ACRESC == SE2->E2_SDACRES) .and. ;
		(SE2->E2_DECRESC == SE2->E2_SDDECRE)		

		Help(" ",1,"A330NAOCOMP")
		dbSetOrder(1)
		DbGoto(nReg)
		UnLockCmpCP(cChvSemaf)
		Return
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o t¡tulo tem NDF baixada - PABruto ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lPaBruto .and. !lDebito .and. Fa340VerNDF(@lNDF)
		MsgAlert("STR0044")
		dbSetOrder(1)
		DbGoto(nReg)
		UnLockCmpCP(cChvSemaf)
		Return		
	EndIf

	STRLCTPAD := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
	CODFORCP := SE2->E2_FORNECE
	LOJFORCP := SE2->E2_LOJA

	cNatureza 	:= SE2->E2_NATUREZA
	nMoeda		:= SE2->E2_MOEDA
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Procura adiantamentos do titulo original.			³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTitulos := {}

	#IFDEF	TOP
	
		If TcSrvType() != "AS/400"

			cQuery := "SELECT SE5.E5_FILIAL, SE5.E5_TIPODOC, SE5.E5_PREFIXO, SE5.E5_NUMERO, SE5.E5_PARCELA, "
			cQuery += "SE5.E5_TIPO, SE5.E5_DATA, SE5.E5_CLIFOR, SE5.E5_LOJA, SE5.E5_SEQ, "
			cQuery += "SE5.E5_DOCUMEN, SE5.E5_SEQ, SE5.E5_FILORIG, SE5.E5_VLMOED2, SE5.R_E_C_N_O_ E5_RECNO, "
			cQuery += "SE2.E2_VALOR "			
			cQuery += ", SE5.E5_FORNADT, SE5.E5_LOJAADT, SE2.E2_FORNECE, SE2.E2_LOJA"
			cQuery += "FROM "+RetSqlName("SE5") + " SE5, "
			cQuery += RetSqlName("SE2") + " SE2 "			
			cQuery += "WHERE "
			cQuery += "SE5.E5_FILIAL = '"+xFilial("SE5")+"' AND "
			cQuery += "SE2.E2_FILIAL = '"+xFilial("SE2")+"' AND "
			cQuery += "SE5.E5_PREFIXO = SE2.E2_PREFIXO AND "
			cQuery += "SE5.E5_NUMERO = SE2.E2_NUM AND "
			cQuery += "SE5.E5_PARCELA = SE2.E2_PARCELA AND "
			cQuery += "SE5.E5_TIPO = SE2.E2_TIPO AND "

			If mv_par02==1 
				cQuery += "SE5.E5_CLIFOR = SE2.E2_FORNECE AND "
			EndIf	 
			If (mv_par01==1 .and. mv_par02==1)
				cQuery += "SE5.E5_LOJA = SE2.E2_LOJA AND "
     		Endif
			cQuery += "SE5.E5_TIPODOC = '"+cTipoDoc+"' AND "
			cQuery += "SE5.E5_MOTBX = 'CMP' AND "
			cQuery += "SE5.E5_RECPAG = 'P' AND "			
			cQuery += "SE5.E5_PREFIXO ='"+cPrefixo+"' AND "
			cQuery += "SE5.E5_NUMERO ='"+cNum+"' AND "	
			cQuery += "SE5.E5_PARCELA ='"+cParcela+"' AND "
			cQuery += "SE5.E5_TIPO = '"+cTipoTit+"' AND "
			cQuery += "SE5.E5_CLIFOR = '"+cFornece+"' AND "
			cQuery += "SE5.E5_LOJA = '"+cLoja+"' AND "
			
			cQuery += "SE5.D_E_L_E_T_ = ' ' AND "
			cQuery += "SE2.D_E_L_E_T_ = ' ' "			
			cQuery += "ORDER BY "
			cQuery += "SE5.E5_FILIAL, SE5.E5_TIPODOC, SE5.E5_PREFIXO, SE5.E5_NUMERO, SE5.E5_PARCELA, "
			cQuery += "SE5.E5_TIPO, SE5.E5_DATA, SE5.E5_SEQ"
			
			cQuery := ChangeQuery(cQuery)
						
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)		

			aStruSE5:= SE5->(dbStruct())

			For nSE5 := 1 To Len(aStruSE5)
				If aStruSE5[nSE5][2] <> "C" .and.  FieldPos(aStruSE5[nSE5][1]) > 0
					TcSetField("TRB",aStruSE5[nSE5][1],aStruSE5[nSE5][2],aStruSE5[nSE5][3],aStruSE5[nSE5][4])
				EndIf
			Next nSE5	
		
			While TRB->(!EOF())
				// Verifica o fornecedor do Adto. apenas se estiver posicionado do
				// titulo de PA ao fazer a exclusao.
				If cTipoTit $ MVPAGANT .And.;
					SE5->(FieldPos("E5_FORNADT")) > 0 .And.;
					TRB->(E5_FORNADT+E5_LOJAADT)	!= SE2->(E2_FORNECE+E2_LOJA) .And.;
					TRB->(E5_CLIFOR+E5_LOJA) 		!= SE2->(E2_FORNECE+E2_LOJA)
					DbSkip()
					Loop
				Endif
					
				//Verifica se a data base do sistema eh menor que a data de compensacao dos titulos
				If DTOS(dDataBase) < DTOS(TRB->E5_DATA) 
					dbSkip()
  					Loop
	 			EndIf														
				
				//Verifica se tem baixa cancelada
				If TemBxCanc(TRB->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ),.T.)
					TRB->( dbskip())
					loop
				EndIf

				If cPaisLoc $ "BRA|MEX" .and. AliasInDic("FR3") .and. AliasInDic("FIE")
					// se estorno da compensacao nao estah partindo do titulo de debito
					If !lDebito
						If SE2->E2_ORIGEM = "MATA100" .and. SE2->E2_TIPO = MVNOTAFIS
							// checa se condicao de pagamento eh relacionado com adiantamento
							If FaNfsRAdt(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_EMISSAO)
								// checa se eh a primeira baixa para o titulo principal, pois a primeira baixa eh realizada no momento da geracao do documento de entrada, quando hah adiantamento relacionado ao documento.
								If FaBxEmisDoc(TRB->E5_FILIAL,TRB->E5_PREFIXO,TRB->E5_NUMERO,TRB->E5_PARCELA,TRB->E5_CLIFOR,TRB->E5_LOJA,TRB->E5_TIPO,TRB->E5_DATA,TRB->E5_SEQ,"P",TRB->E5_DOCUMEN)
									dbSelectArea("TRB")
									dbSkip()
									Loop
								Endif
							Endif
						Endif       
					// se estorno da compensacao estah partindo do titulo de credito
					Else	
						// posiciona no titulo principal e na baixa principal para checar se eh adiantamento e se esta baixa foi gerada no momento da emissao do documento de saida.
						aAreaAnt := GetArea()
						aAreaE5Adt := SE5->(GetArea())
						cChaveE5Adt := TRB->E5_FILIAL+cTipoDc+Subs(TRB->E5_DOCUMEN,1,nTamTit+nTamTip)+dTos(TRB->E5_DATA)+TRB->(E5_CLIFOR+E5_LOJA+E5_SEQ)
						aAreaE2Adt := SE2->(GetArea())					
						cChaveE2Adt := TRB->E5_FILIAL+TRB->(E5_CLIFOR+E5_LOJA)+Subs(TRB->E5_DOCUMEN,1,nTamTit+nTamTip)
						// posiciona no titulo principal
						SE2->(dbSetOrder(6))
						If SE2->(dbSeek(cChaveE2Adt))
							// posiciona na baixa principal					
							SE5->(dbSetOrder(2))
							If SE5->(dbSeek(cChaveE5Adt))
								If SE2->E2_ORIGEM = "MATA100" .and. SE2->E2_TIPO = MVNOTAFIS
									// checa se condicao de pagamento eh relacionado com adiantamento
									If FaNfsRAdt(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_EMISSAO)
										// checa se eh a primeira baixa para o titulo principal, pois a primeira baixa eh realizada no momento da geracao do documento de saida, quando hah adiantamento relacionado ao documento.
										If FaBxEmisDoc(SE5->E5_FILIAL,SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_CLIFOR,SE5->E5_LOJA,SE5->E5_TIPO,SE5->E5_DATA,SE5->E5_SEQ,"P",SE5->E5_DOCUMEN)
											RestArea(aAreaE2Adt)
											RestArea(aAreaE5Adt)
											RestArea(aAreaAnt)
											dbSelectArea("TRB")
											dbSkip()
											Loop
										Endif
									Endif
								Endif       
							Endif	
						Endif	
						RestArea(aAreaE2Adt)
						RestArea(aAreaE5Adt)
						RestArea(aAreaAnt)
						dbSelectArea("TRB")
					Endif
				Endif		

				If TRB->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E2_FORNECE+E2_LOJA) == ;
					SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)

					Aadd( aTitulos,{TRB->E5_PREFIXO, TRB->E5_NUMERO    , TRB->E5_PARCELA,;
						  TRB->E5_TIPO   , DtoC(TRB->E5_DATA),;
						  SubStr(TRB->E5_DOCUMEN,1,nTamTit+nTamTip),;
						  TRB->E5_SEQ, Transform(TRB->E2_VALOR,"@E 9999,999,999.99"),;
			              Transform(TRB->E5_VLMOED2,"@E 9999,999,999.99"),.T.})
					
					AADD( aRegistros, TRB->E5_RECNO)
						
					If !Empty(TRB->E5_FILORIG) .and. !Empty( xFilial( "SE2" ) )
						cChaveSe2 := TRB->E5_FILORIG+SubStr( TRB->E5_DOCUMEN ,1,nTamTit+nTamTip )+TRB->(E5_FORNADT+E5_LOJAADT)
					Else
						cChaveSe2 := xFilial("SE2")+SubStr( TRB->E5_DOCUMEN ,1,nTamTit+nTamTip )+TRB->(E5_FORNADT+E5_LOJAADT)
					Endif					
				
					If !(F340Semaforo({},.T.,aRegistros[Len(aRegistros)], cChaveSe2,{},.F.)) // se conseguirmos travar o registro do SE2	
							aTitulos[Len(aTitulos)] := .F.
					Endif
					
				Endif	
				TRB->(DbSkip())
			EndDo			
      Else
	#ENDIF 
			dbSelectArea("SE5")
			dbSetOrder(2)
			dbSeek( xFilial("SE5")+cTipoDoc )
			While !Eof() .and. cFilial == SE5->E5_FILIAL .and. SE5->E5_TIPODOC == cTipoDoc
	
				If SE5->E5_MOTBX != "CMP" .or. E5_RECPAG != "P"
					dbSkip( )
					Loop
				Endif

				//Verifica se tem baixa cancelada
				If TemBxCanc(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
					SE5->( dbskip())
					loop
				EndIf             
				
				//Verifica se a data base do sistema eh menor que a data de compensacao dos titulos
				If DTOS(dDataBase) < DTOS(SE5->E5_DATA) 
					dbSkip()
  					Loop
	 			EndIf	
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica Fornecedor se considerar Fornecedor Original   ³
				//³ na selecao de titulos 									³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (mv_par02 == 1 .Or. !cTipoTit $ MVPAGANT) .and.  SE5->E5_CLIFOR != SE2->E2_FORNECE
					dbSkip( )
					Loop
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica loja caso considere loja na selecao de titulos	  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ((mv_par01 == 1 .and. mv_par02 == 1) .Or. !cTipoTit $ MVPAGANT) .and.  SE5->E5_LOJA != SE2->E2_LOJA
					dbSkip( )
					Loop
				EndIf
				// Verifica o fornecedor do Adto. apenas se estiver posicionado do
				// titulo de PA ao fazer a exclusao.
				If cTipoTit $ MVPAGANT .And.;
					SE5->(E5_FORNADT+E5_LOJAADT)	!= SE2->(E2_FORNECE+E2_LOJA) .And.;
					SE5->(E5_CLIFOR+E5_LOJA) 		!= SE2->(E2_FORNECE+E2_LOJA)
					dbSkip( )
					Loop
				Endif
	
				If SE5->E5_PREFIXO #cPrefixo .Or. SE5->E5_NUMERO # cNum .Or. ;
					SE5->E5_PARCELA #cParcela .Or. SE5->E5_TIPO # cTipoTit
					dbSkip()
					Loop
				Endif
				Aadd( aTitulos,{SE5->E5_PREFIXO, SE5->E5_NUMERO    , SE5->E5_PARCELA,;
				SE5->E5_TIPO   , DtoC(SE5->E5_DATA),;
				SubStr(SE5->E5_DOCUMEN,1,nTamTit+nTamTip),;
				SE5->E5_SEQ, Transform(SE2->E2_VALOR,"@E 9999,999,999.99"),;
				Transform(SE5->E5_VLMOED2,"@E 9999,999,999.99"),.T.})
				AADD( aRegistros, SE5->(Recno()))
				dbSelectArea( "SE5" )
				dbSkip()
			Enddo
	#IFDEF TOP
		Endif			
	#ENDIF

	If Len(aTitulos) == 0
		Help(" ",1,"NOTITSEL")
		#IFDEF TOP
			If TcSrvType() != "AS/400"
				dbSelectArea( "TRB")
				dbCloseArea()
			Endif
		#ENDIF	
		dbSelectArea( "SE2" )
		dbSetOrder( 1 )
		dbSelectArea( "SE5" )
		dbSetOrder( 1 )
		dbGoTo( nReg )
		UnLockCmpCP(cChvSemaf)
		Return
	Endif

	nOpca   := 0

	aSize := MsAdvSize(,.F.,400)
	DEFINE MSDIALOG oDlg TITLE STR0041 From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	oDLg:lMaximized := .T.

	@ 00.5,0 TO 5.4, 32.0 LABEL cCadastro OF oDlg
	@ 01.0,.5 LISTBOX oTitulo VAR cVarQ Fields;
		HEADER "", OemToAnsi(STR0006),;  //"Prefixo"
		OemToAnsi(STR0007),;  //"N£mero"
		OemToAnsi(STR0008),;  //"Parcela"
		OemToAnsi(STR0009),;  //"Tipo"
		OemToAnsi(STR0020),;  //"Data"
		OemToAnsi(STR0021),;  //"Documento"
		OemToAnsi(STR0022),;  //"Seq"
		OemToAnsi(STR0023),;  //"Valor do t¡tulo"
		OemToAnsi(STR0017) ;   //"Valor compensado"
		COLSIZES 12, GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBBBBBBBBB"),;
		GetTextWidth(0,"BBBBB"),GetTextWidth(0,"BBB"),;
		GetTextWidth(0,"BBBBBB"),GetTextWidth(0,"BBBBBBBBBB"),;
		GetTextWidth(0,"BBB"),GetTextWidth(0,"BBBBBBBBBB"),;
		GetTextWidth(0,"BBBBBBBBBB");
		SIZE 250,54.5 ON DBLCLICK (aTitulos := FA340marca(oTitulo:nAt,aTitulos,aRegistros),oTitulo:Refresh()) NOSCROLL

	oTitulo:SetArray(aTitulos)
	oTitulo:bLine := { || {If(aTitulos[oTitulo:nAt,10],oOk,oNo),;
		aTitulos[oTitulo:nAt,1],aTitulos[oTitulo:nAt,2],;
		aTitulos[oTitulo:nAt,3],aTitulos[oTitulo:nAt,4],;
		aTitulos[oTitulo:nAt,5],aTitulos[oTitulo:nAt,6],;
		aTitulos[oTitulo:nAt,7],aTitulos[oTitulo:nAt,8],;
		aTitulos[oTitulo:nAt,9]}}

	oTitulo:Align := CONTROL_ALIGN_ALLCLIENT
	//---
	
	
	If lPanelFin  //Chamado pelo Painel Financeiro			
		ACTIVATE MSDIALOG oDlg ON INIT (oTitulo:Refresh(), FaMyBar(oDlg,;
	   	{|| nOpca := 1,oDlg:End()},;   					
			{|| nOpca := 0,oDlg:End()}))    
			 	
	Else
		oPanel := TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,20,20,.T.,.T. )
		oPanel:Align := CONTROL_ALIGN_BOTTOM
		DEFINE SBUTTON FROM 4,325 TYPE 1 ACTION (nOpca := 1,oDlg:End())  ENABLE OF oPanel PIXEL
		DEFINE SBUTTON FROM 4,360 TYPE 2 ACTION (nOpca := 0,oDlg:End())  ENABLE OF oPanel PIXEL

		ACTIVATE MSDIALOG oDlg CENTERED ON INIT (oTitulo:Refresh())
	Endif

	If nOpca == 2   // somente no DOS - Redigita
		Loop
	ElseIf nOpcA == 0
		F340Semaforo(aTitulos,.F.,0,,aRegistros,.F.)
	Elseif nOpcA == 1

		dbSelectArea("SE5")
		dbSetOrder(2)
		nValorBaix := 0
		lPadrao := VerPadrao(cPadrao)

		If lPadrao
			lFirst := .T.
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicio da prote‡„o via TTS							³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Begin Transaction
		For nLaco := 1 to Len(aRegistros)
			cCondic := "(aTitulos["+STR(nLaco)+",10])"
			If &cCondic
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ So monta o cabecalho do LP se acha pelo menos um³
				//³ registro marcado 										 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lFirst
					nHdlPrv := HeadProva( cLote,;
					                      "FINA340",;
					                      Substr( cUsuario, 7, 6 ),;
					                      @cArquivo )

					VALOR 	:= 0
					VLRINSTR := 0
					lFirst:= .F.
				Endif
				dbSelectArea("SE5")
				dbGoTo(aRegistros[nLaco])
				cDocumento := Substr(SE5->E5_DOCUMEN,1,nTamTit+nTamTip)+;
					IIF(mv_par02==1,SE5->E5_CLIFOR,"")+;
					IIf(mv_par01==1 .and. mv_par02==1,SE5->E5_LOJA,"")

				cSeq		  := SE5->E5_SEQ
				cChaveAdt  := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)

				//Acrescimos e Decrescimos do titulo principal
				If SE5->E5_VLJUROS > 0
					nTitAcres	+= Round(NoRound(xMoeda(SE5->E5_VLJUROS,1,nMoeda,SE5->E5_DATA,3,,Fa340TxMd(nMoeda,nTxMoeda)),3),2)
				Endif
				If SE5->E5_VLDESCO > 0
					nTitDecre	+= Round(NoRound(xMoeda(SE5->E5_VLDESCO,1,nMoeda,SE5->E5_DATA,3,,Fa340TxMd(nMoeda,nTxMoeda)),3),2)
				Endif
                
                //Cancela TX Geradas
				If !Empty(SE2->E2_BASEPIS) .and. !lDebito
					nRecAnt := SE2->(Recno())
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Localiza o t¡tulo PA/NDF correspondente … baixa ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inicializa a chave de pesquisa com  ³
				//³ a filial padrÆo. Caso seja utilizada³
				//³ compensa‡Æo em outras filiais, ir   ³
				//³ utilizar-se do campo E5_FILORIG.    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cChaveSe2 := xFilial("SE2")+SubStr( SE5->E5_DOCUMEN ,1,nTamTit+nTamTip )+;
					If(!Empty(SE5->E5_FORNADT),SE5->(E5_FORNADT+E5_LOJAADT),IIF(mv_par02==1,SE5->E5_CLIFOR,"")+;
					IIf(mv_par01==1 .and. mv_par02==1,SE5->E5_LOJA,""))
					
				If !Empty(SE5->E5_FILORIG) .and. !Empty( xFilial( "SE2" ) )
					cChaveSe2 := SE5->E5_FILORIG+SubStr( SE5->E5_DOCUMEN ,1,nTamTit+nTamTip )+;
							If(!Empty(SE5->E5_FORNADT),SE5->(E5_FORNADT+E5_LOJAADT),IIF(mv_par02==1,SE5->E5_CLIFOR,"")+;
							IIf(mv_par01==1 .and. mv_par02==1,SE5->E5_LOJA,""))
				Endif

				dbSelectArea("SE2")
				dbSetOrder(1)
				If (cTipoTit $ MV_CPNEG .or. Alltrim(cTipoTit) $ MVPAGANT)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Volta valor do abatimento se existir ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nTotAbat := 0
					dbSelectArea("SE2")
					dbSeek(Left(cChaveSe2,Len(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA)))
					While !Eof() .And.;
							E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA==Left(cChaveSe2,Len(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA))
						If SE2->E2_TIPO $ MVABATIM
							nTotAbat += SE2->E2_VALOR-SE2->E2_SALDO
							RecLock("SE2",.F.)
							SE2->E2_SALDO := SE2->E2_VALOR
							SE2->E2_BAIXA := Ctod("")
							MsUnLock()
						EndIf
						dbSelectArea("SE2")
						dbSkip()
					EndDo
				Endif	
				
				If !lDebito
					Fa340VerNDF(@lNDF,@nRecNDF) //Baixa NDF
				EndIf
			
				If dbSeek(cChaveSe2)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o t¡tulo tem NDF baixada - PABruto ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lPaBruto .and. lDebito .and. Fa340VerNDF(@lNDF,@nRecNDF)
						MsgAlert("STR0044")						
						dbSelectArea( "TRB")
						dbCloseArea()
												
						dbSelectArea( "SE2" )
						dbSetOrder( 1 )
						dbSelectArea( "SE5" )
						dbSetOrder( 1 )
						dbGoTo( nReg )
						Return		
					EndIf
				   
				   	If !lDebito
				   		AAdd( aRecPa, SE2->( Recno() ) )
				   	Else				   		
				   		If !Empty(SE2->E2_BASEPIS)
							nRecAnt := SE2->(Recno())
						EndIf				   		
				   	EndIf
			   
				   
					cAdiantamento := Substr(SE5->E5_DOCUMEN,1,nTamTit+nTamTip)
					While !Eof().and.E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO==Substr(cAdiantamento,1,nTamtit+nTamTip).and.;
							E2_FILIAL == Substr(cChaveSe2,1,IIf( lFWCodFil, FWGETTAMFILIAL, 2 ))
						// Zero a variavel que soma os impostos (lei 10925)do titulo.
						nValImp := 0
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica Fornecedor. Verifica Loja (Se considera Loja)	³
						//³ Se n„o considera Fornecedor Original, verifica se perten³
						//³ ce a faixa selecionada (mv_par03 a mv_par04)            ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   					If !Empty(SE5->E5_FORNADT)
							lAchou := SE5->(E5_FORNADT+E5_LOJAADT) == SE2->(E2_FORNECE+E2_LOJA)
						Else
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica Fornecedor. Verifica Loja (Se considera Loja)	³
							//³ Se n„o considera Fornecedor Original, verifica se perten³
							//³ ce a faixa selecionada (mv_par03 a mv_par04)            ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							lAchou := (SE2->E2_FORNECE == SE5->E5_CLIFOR .and. ;
										IIf (mv_par01 == 1 , SE2->E2_LOJA == SE5->E5_LOJA,.T.)) .OR. ;
										(mv_par02 == 2 .and. SE2->E2_FORNECE >= mv_par03 .and. ;
										SE2->E2_FORNECE <= mv_par04 )
						Endif
						If lAchou
							If (lContrRet .Or. lIRPFBaixa) .and. SE2->E2_TIPO $ MVPAGANT .and. !lPaBruto //.or. SE5->E5_PRETPIS != '5') )
								
								// Verifica os valores dos Txs (lei 10925) para subtrair do saldo do PA.
								If lIRPFBaixa                                                                                                          
									aImp10925 := BuscaTXs(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCIR)
								Else																		
									aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL)
								EndIf
									
								For nX := 1 To Len(aImp10925)
									nValImp += aImp10925[nX][6]
								Next							
							Elseif lContrRet .And. SE2->E2_TIPO $ MVPAGANT .AND. lPaBruto .and. (!(SE5->E5_PRETPIS == '5') .and.;
							 !Empty(SE2->E2_TITADT) .Or. lIRPFBaixa)
								
								If lIRPFBaixa                                                                                                          
									aImp10925 := BuscaTXs(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCIR)
								Else																										
									aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL)
								EndIf
									
								For nX := 1 To Len(aImp10925)
									nValImp += aImp10925[nX][6]
								Next							
							Endif
							
							RecLock("SE2")
							If cPaisLoc == "BRA"														
								If lDebito
									AltvencImp(SE2->E2_VENCREA)
								Endif
							   nTxMoeda := IIf(!Empty(SE5->E5_TXMOEDA),SE5->E5_TXMOEDA,RecMoeda(SE5->E5_DATA,SE2->E2_MOEDA))
								If (SE2->E2_MOEDA > 1 .AND. nMoeda == 1) .or. (SE2->E2_MOEDA == 1 .AND. nMoeda > 1) 
									SE2->E2_SALDO += Round(NoRound(xMoeda(SE5->E5_VALOR - Iif(SE5->E5_VALOR-nValImp == SE2->E2_VALOR-SE2->E2_SALDO .Or. lPaBruto,nValImp,0),1,SE2->E2_MOEDA,SE5->E5_DATA,3,,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA)),3),2)
								Else
									SE2->E2_SALDO += Round(NoRound(xMoeda(SE5->E5_VLMOED2 - Iif(SE5->E5_VLMOED2-nValImp == SE2->E2_VALOR-SE2->E2_SALDO .Or. lPaBruto,nValImp,0),nMoeda,SE2->E2_MOEDA,SE5->E5_DATA,3	, If(SE2->E2_MOEDA == 1, Fa340TxMd(nMoeda,nTxMoeda),Fa340TxMd(nMoeda,SE2->E2_TXMOEDA));
																																, If(nMoeda        == 1, Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),Fa340TxMd(SE2->E2_MOEDA,nTxMoeda        ))),3),2)
								Endif
		   					//QUESTAO DE ARREDONDAMENTO
								If ABS(SE2->E2_VALOR - SE2->E2_SALDO) <= 0.009999
									SE2->E2_SALDO := SE2->E2_VALOR
								Endif
							   SE2->E2_VALLIQ:= 0                                                  
								nValorBaix+= SE5->E5_VALOR + nTitDecre - nTitAcres
								If SE2->E2_MOEDA == 1 .AND. nMoeda > 1 .And. lDebito
                                    If STR(SE5->E5_VALOR,17,2) != STR(SE5->E5_VLMOED2,17,2)
                                    	nValBaix2 += SE5->E5_VLMOED2
                                    Else	
										nValBaix2 += Round(NoRound(xMoeda(SE5->E5_VLMOED2,SE2->E2_MOEDA,nMoeda,SE5->E5_DATA,3	,If(lDebito,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),Fa340TxMd(SE2->E2_MOEDA,nTxMoeda        ));
																																,If(lDebito,Fa340TxMd(nMoeda       ,nTxMoeda       ),Fa340TxMd(nMoeda        ,SE2->E2_TXMOEDA))),3),2)
									Endif
								Else
                                    If STR(SE5->E5_VALOR,17,2) != STR(SE5->E5_VLMOED2,17,2)
                                    	nValBaix2 += SE5->E5_VLMOED2
                                    Else	
										nValBaix2 += Round(NoRound(xMoeda(SE5->E5_VALOR,1,nMoeda,SE5->E5_DATA,3,,If(lDebito,Fa340TxMd(nMoeda,SE2->E2_TXMOEDA),Fa340TxMd(nMoeda,nTxMoeda))),3),2)
									Endif									
								Endif	
								nValBaix2+= Round(NoRound(xMoeda(SE5->E5_VLDESCO-SE5->E5_VLJUROS,1,nMoeda,SE5->E5_DATA,3	,If(lDebito,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),Fa340TxMd(SE2->E2_MOEDA,nTxMoeda        ));
																															,If(lDebito,Fa340TxMd(nMoeda       ,nTxMoeda       ),Fa340TxMd(nMoeda        ,SE2->E2_TXMOEDA))),3),2)
								nSe2Rec := SE2->(RECNO())
							Else
         					//Procurar o registro da baixa, ao inves de utilizatr o da compensacao, para poder pegar  
         					//diretamente os valores utilizados para a baixa.
							   nDecs 	:= MsDecimais(nMoeda)
								nRecBkpSE5	:=	SE5->(Recno())
								nOrdBkpSE5	:=	SE5->(IndexOrd())
							   	nTxMoeda	:=	SE5->E5_VALOR/SE5->E5_VLMOED2
								nValBaix2 	+= SE5->E5_VLMOED2+Round(xMoeda(SE5->E5_VLDESCO - SE5->E5_VLJUROS,1,nMoeda,SE5->E5_DATA,nDecs1+1,Fa340TxMd(nMoeda,nTxMoeda)),nDecs1)
							   nLiq  		+= Round(xMoeda(SE5->E5_VLMOED2+nTotAbat,nMoeda,1,SE5->E5_DATA,nDecs1+1,Fa340TxMd(nMoeda,nTxMoeda)),nDecs1)
	
								SE5->(DbSetOrder(7))
								If SE5->(FieldPos("E5_FORNADT"))>0 .and. !Empty(SE5->E5_FORNADT)
									SE5->(MsSeek(xFilial()+SubStr(SE5->E5_DOCUMEN,1,nTamTit+nTamTip)+SE5->(E5_FORNADT+E5_LOJAADT)+SE5->E5_SEQ))							
								Else
									SE5->(MsSeek(xFilial()+SubStr(SE5->E5_DOCUMEN,1,nTamTit+nTamTip)+SE2->(E2_FORNECE+E2_LOJA)+SE5->E5_SEQ))							
		                        Endif 
        		                If SE5->(Found())
									nValorBaix	+=	SE5->E5_VALOR + nTitDecre - nTitAcres
									nValSaldo 	:=	SE5->E5_VLMOED2+nTotAbat
									nVlLiqBx		:=	SE5->E5_VALOR+Round(xMoeda(nTotAbat,nMoeda,1,SE5->E5_DATA,nDecs1+1,Fa340TxMd(nMoeda,SE5->E5_VALOR/SE5->E5_VLMOED2)),nDecs1)														
								Else
									SE5->(DbSetOrder(nOrdBkpSE5))
									SE5->(dBGoTo(nRecBkpSE5))
									nValorBaix	+= SE5->E5_VALOR + nTitDecre - nTitAcres
									nValSaldo	:=	xMoeda(SE5->E5_VLMOED2+nTotAbat,nMoeda,SE2->E2_MOEDA,SE5->E5_DATA,nDecs+3,Fa340TxMd(nMoeda,nTxMoeda))
									nVlLiqBx		:=	Round(xMoeda(SE5->E5_VLMOED2+nTotAbat,nMoeda,1,SE5->E5_DATA,nDecs1+1,Fa340TxMd(nMoeda,nTxMoeda)),nDecs1)														
								Endif   
								//QUESTAO DE ARREDONDAMENTO
								If ABS(SE2->E2_VALOR - (SE2->E2_SALDO+nValSaldo)) <= 0.9999/(10**MsDecimais(SE2->E2_MOEDA)).Or.;
									SE2->E2_VALOR < (SE2->E2_SALDO+nValSaldo)
									SE2->E2_SALDO := SE2->E2_VALOR               
								Else
									SE2->E2_SALDO += nValSaldo									
								Endif

							   	SE2->E2_VALLIQ -= nVlLiqBx
								nSe2Rec := SE2->(RECNO())      
								SE5->(DbSetOrder(nOrdBkpSE5))
								SE5->(dBgOTO(nRecBkpSE5))
							EndIf   							   
							If NoRound( SE2->E2_VALOR, 2 ) == NoRound( SE2->E2_SALDO, 2 )
								SE2->E2_BAIXA := CtoD("  /  /  ")
					            //Caso exista solicitacao de NCP eh necessario atualizar o campo CU_DTBAIXA... 
            					If cPaisLoc <> "BRA"
            						A055AtuDtBx("2",SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_NUM,SE2->E2_PREFIXO,SE2->E2_BAIXA)
								EndIf
							EndIf
							MsUnlock()

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza dados no Cadastro de Fornecedores              		³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							dbSelectArea("SA2")
							lAchouCli := MsSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
							If !lAchouCli
								// Pesquisa com a filial origem do titulo, para casos de SA2 exclusivo
								lAchouCli := MsSeek(SE2->E2_FILORIG+SE2->E2_FORNECE+SE2->E2_LOJA)
							EndIf								
							If lAchouCli
								RecLock("SA2")
								If SE2->E2_MOEDA > 1
									nValPadrao := Round(NoRound(xMoeda(SE5->E5_VALOR - nValImp,1,SE2->E2_MOEDA,SE5->E5_DATA,3,,If(lDebito,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),Fa340TxMd(SE2->E2_MOEDA,nTxMoeda))),3),2)
								Else
									nValPadrao := SE5->E5_VALOR - nValImp
								Endif
								IF SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
									SA2->A2_SALDUP	-= nValPadrao
									SA2->A2_SALDUPM	-= xMoeda(nValPadrao,nMoeda,Val(GetMv("MV_MCUSTO")),SE2->E2_EMISSAO,,If(cPaisLoc=="BRA",Fa340TxMd(nMoeda,SE2->E2_TXMOEDA),0))
								Else
									SA2->A2_SALDUP		+= nValPadrao
									SA2->A2_SALDUPM	+= xMoeda(nValPadrao,nMoeda,Val(GetMv("MV_MCUSTO")),SE2->E2_EMISSAO,,If(cPaisLoc=="BRA",Fa340TxMd(nMoeda,SE2->E2_TXMOEDA),0))
								Endif
								SA2->(MsUnlock())
							EndIf
						Endif
						dbSelectArea("SE2")
						dbSkip()
					Enddo
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Deleta a baixa do SE5					 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SE5")
					dbSetOrder(2)
					cFornAdt := ""
					nLen := Len(SE5->E5_PREFIXO+SE5->E5_NUMERO+;
									SE5->E5_PARCELA+SE5->E5_TIPO+;
									If(!Empty(SE5->E5_FORNADT),"",;
									IIF(mv_par02==1,SE5->E5_CLIFOR,"")+;
									IIf(mv_par01==1 .And. mv_par02==1,SE5->E5_LOJA,"")))
					If !Empty(SE5->E5_FORNADT)
						cFornAdt		:= SE5->(E5_FORNADT+E5_LOJAADT)
					Endif	
					If (dbSeek(xFilial()+cTipodc+SubStr(Trim(cDocumento),1,nTamTit+nTamTip)))
						While !Eof() .And. SE5->E5_FILIAL == xFilial("SE5") .And. ;
								Left(cDocumento,nLen) ==	SE5->E5_PREFIXO+SE5->E5_NUMERO+;
																	SE5->E5_PARCELA+SE5->E5_TIPO+;
																	If(!Empty(SE5->E5_FORNADT),"",;
																	IIF(mv_par02==1,SE5->E5_CLIFOR,"")+;
																	IIf(mv_par01==1 .And. mv_par02==1,SE5->E5_LOJA,""))
							If cSeq == SE5->E5_SEQ .And. ;
								(Empty(E5_FORNADT+E5_LOJAADT)		 .Or.;
								 SE5->(E5_FORNADT+E5_LOJAADT)	== SE5->(E5_CLIFOR+E5_LOJA) .Or.;
								 SE5->(E5_CLIFOR+E5_LOJA)		== cFornAdt .Or.;
								 SE5->(E5_FORNADT+E5_LOJAADT)	== cFornAdt) .And.;
								SubStr(Trim(SE5->E5_DOCUMEN),1,nTamTit+nTamTip) == cChaveAdt

								//Dados do titulo de adiantamento
								dbSelectArea("SE2")
								dbGoto(nSE2Rec)
								RecLock("SE2")
								nAcresc := Round(NoRound(xMoeda(SE5->E5_VLJUROS,1,SE2->E2_MOEDA,SE5->E5_DATA,3),3),2)
								nDecres := Round(NoRound(xMoeda(SE5->E5_VLDESCO,1,SE2->E2_MOEDA,SE5->E5_DATA,3),3),2)
								SE2->E2_SALDO += nDecres - nAcresc
								//QUESTAO DE ARREDONDAMENTO
								If ABS(SE2->E2_VALOR - xMoeda(SE5->E5_VLMOED2+If(lPaBruto,nValImp,0),nMoeda,SE2->E2_MOEDA,SE5->E5_DATA,3) - (nTotAbat + nDecres - nAcresc)) <= 0.0099999
									SE2->E2_SALDO := SE2->E2_VALOR
								Endif
								SE2->E2_SDACRES += nAcresc
								SE2->E2_SDDECRE += nDecres					
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ So limpa a data da baixa se nao houver mais 	 ³
								//³ nenhum movimento para este titulo					 ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If NoRound( SE2->E2_VALOR, 2 ) == NoRound( SE2->E2_SALDO, 2 )
									SE2->E2_BAIXA := CtoD("  /  /  ")
								EndIf
								MsUnlock()			

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Grava lançamento no PCO ref  titulo compensado apos cancelamento    ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								PCODetLan("000017","02","FINA340")
								
								If nOpc == 4 .and. SE5->E5_LA <> "S " //Exclusao
									Reclock("SE5")
									dbDelete()
									MsUnlock()
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Grava lançamento no PCO ref baixa titulo compensado apos a cancelamento    ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									PCODetLan("000017","06","FINA340",.T.)
								Else
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Obtem os dados do registro tipo RA para gerar um	  ³
									//³ registro de estorno 										  ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									aSE5 := {}
									dbSetOrder( 1 )
									For nX := 1 to SE5->( Fcount() )
										AAdd( aSE5, SE5->( FieldGet(nX) ) )
									NEXT
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Grava o registro de estorno                     	  ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									RecLock("SE5" ,.T.)
									For nX := 1 to SE5->(Fcount())
										SE5->( FieldPut( nX,aSE5[nX]))
									Next
									SE5->E5_TIPODOC	:= "ES"
									SE5->E5_RECPAG	:= "R"
									SE5->E5_HISTOR	:= STR0041 //"Cancel. de Compensacao"
									SE5->E5_DATA	:= dDatabase
									SE5->E5_DTDIGIT	:= dDataBase
									SE5->E5_DTDISPO	:= dDataBase
									SE5->E5_LA		:= "N"
									
									If mv_par11 == 2 .And. lUsaFlag
										aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
									EndIf

									If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
 					  					SE5->E5_NODIA := ""
  				   					EndIf	
									MsUnlock()

									If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
 										AAdd(aDiario,{"SE5",SE5->(Recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"})
  									EndIf	  
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Grava lançamento no PCO ref baixa titulo compensado apos a cancelamento    ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									PCODetLan("000017","06","FINA340")
								Endif
							Endif
							dbSkip()
						EndDo
					EndIF
					dbSetOrder(1)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³  Apaga registro da movimenta‡„o  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SE5")
					dbGoTo(aRegistros[nLaco])

					If lPadrao .and. mv_par11 == 1
						nTotal += DetProva( nHdlPrv,;
						                    cPadrao,;
						                    "FINA340",;
						                    cLote,;
						                    /*nLinha*/,;
						                    /*lExecuta*/,;
						                    /*cCriterio*/,;
						                    /*lRateio*/,;
						                    /*cChaveBusca*/,;
						                    /*aCT5*/,;
						                    /*lPosiciona*/,;
						                    @aFlagCTB,;
						                    /*aTabRecOri*/,;
						                    /*aDadosProva*/ )
					EndIF

					F340Semaforo({},.F.,aRegistros[nLaco], "", {}, .F.) // LIBERA REGISTRO NO SEMAFORO

					If nOpc == 4 .and. SE5->E5_LA <> "S "  //Exclusao				
						Reclock("SE5",.F.,.T.)
						dbDelete()
						MsUnlock()
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Grava lançamento no PCO ref baixa titulo principal apos a canc.compensacao ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						PCODetLan("000017","05","FINA340",.T.)
	    	     	Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Obtem os dados do registro tipo RA para gerar um	³
						//³ registro de estorno 							    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aSE5 := {}
						dbSetOrder( 1 )
						For nX := 1 to SE5->( Fcount() )
							AAdd( aSE5, SE5->( FieldGet(nX) ) )
						NEXT
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Grava o registro de estorno                         ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						RecLock("SE5" ,.T.)
						For nX := 1 to SE5->(Fcount())
							SE5->( FieldPut( nX,aSE5[nX]))
						Next
						SE5->E5_TIPODOC	:= "ES"
						SE5->E5_RECPAG	:= "R"
						SE5->E5_HISTOR	:= STR0041 //"Cancel. de Compensacao"
						SE5->E5_DATA	:= dDatabase
						SE5->E5_DTDIGIT	:= dDataBase
						SE5->E5_DTDISPO	:= dDataBase                        
						SE5->E5_LA		:= "N"
						If mv_par11 == 2 .And. lUsaFlag
							aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
						EndIf
						
						If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
 							SE5->E5_NODIA := ""
	  					EndIf	
						MsUnlock()

						If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
 							AAdd(aDiario,{"SE5",SE5->(Recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"})
  						EndIf	  
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Grava lançamento no PCO ref baixa titulo principal apos a canc.compensacao ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						PCODetLan("000017","05","FINA340")
					Endif
					lCancelou := .T.
					
					If !(nRecAnt == 0)
						fa340DelTx(nRecAnt)
					EndIf
					
				Endif
			Endif
		Next

		If lPadrao .and. lCancelou .and. !lFirst .and. mv_par11 == 1
			VALOR 	:= nValorBaix
			VLRINSTR := nValorBaix
			dbSelectArea("SE2")
			nRecSe2 := RecNo()
			dbGoBottom()
			dbSkip()
			dbSelectArea("SE5")
			nRecSe5 := RecNo()
			dbGoBottom()
			dbSkip()
			nTotal += DetProva( nHdlPrv,;
			                    cPadrao,;
			                    "FINA340",;
			                    cLote,;
			                    0,;
			                    .F.,;
			                    "FINA340",;
			                    /*lRateio*/,;
			                    /*cChaveBusca*/,;
			                    /*aCT5*/,;
			                    /*lPosiciona*/,;
			                    @aFlagCTB,;
			                    /*aTabRecOri*/,;
			                    /*aDadosProva*/ )

			RodaProva(  nHdlPrv,;
						nTotal)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia para Lan‡amento Cont bil	                	³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cA100Incl( @cArquivo,;
			           nHdlPrv,;
			           3,;
			           cLote,;
			           lDigita,;
			           lAglutina,;
			           /*cOnLine*/,;
			           /*dData*/,;
			           /*dReproc*/,;
			           @aFlagCTB,;
			           /*aDadosProva*/,;
			           aDiario )
			aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento

			dbSelectArea("SE2")
			dbGoTo(nRecSe2)
			dbSelectArea("SE5")
			dbGoTo(nRecSe5)
		EndIF
		If !(cTipoTit $ MV_CPNEG .or. Alltrim(cTipoTit) $ MVPAGANT)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Volta valor do abatimento se existir ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotAbat := 0
			dbSelectArea("SE2")
			dbSetOrder(6)
			dbSeek(xFilial("SE2")+cFornece+cLoja+cPrefixo+cNum+cParcela,.F.)
			While ( !Eof() .And. xFilial("SE2") == SE2->E2_FILIAL 	.And.;
					cFornece       == SE2->E2_FORNECE 	.And.;
					cLoja          == SE2->E2_LOJA		.And.;
					cPrefixo       == SE2->E2_PREFIXO	.And.;
					cNum				== SE2->E2_NUM			.And.;
					cParcela    	== SE2->E2_PARCELA )
				If SE2->E2_TIPO $ MVABATIM .And. (nValBaix2 != 0 .Or. nValorBaix != 0)
					nTotAbat += SE2->E2_VALOR-SE2->E2_SALDO
					RecLock("SE2",.F.)
					SE2->E2_SALDO := SE2->E2_VALOR
					SE2->E2_BAIXA := Ctod("")
					MsUnLock()
				EndIf
				dbSelectArea("SE2")
				dbSkip()
			EndDo
		Endif	
		dbSelectArea("SE2")
		dbSetOrder(1)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Volta valor do titulo.  	     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nValBaix2 #0 .Or. nValorBaix # 0 .Or. nTitDecre # 0 .Or. nTitAcres # 0 
			SE2->(dbGoTo(nRegSE2))
			nValImp := 0
			// Verifica os valores dos Txs (lei 10925) para subtrair do saldo do PA.
			If (lContrRet .Or. lIRPFBaixa) .And. SE2->E2_TIPO $ MVPAGANT .AND. !lPaBruto //.or. (Fa340BxTx(SE2->(recno())) .and. SE5->E5_PRETPIS != '5') )
				If lIRPFBaixa
					aImp10925 := BuscaTXs(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCIR)
				Else	
					aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL)
				EndIf	
				
				For nX := 1 To Len(aImp10925)
					nValImp += aImp10925[nX][6]
				Next
			ElseIf (lContrRet .Or. lIRPFBaixa) .And. SE2->E2_TIPO $ MVPAGANT .AND. lPaBruto .and. !Empty(SE2->E2_TITADT)
				If lIRPFBaixa
					aImp10925 := BuscaTXs(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCIR)
				Else
					aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL)
				EndIf							
				For nX := 1 To Len(aImp10925)
					nValImp += aImp10925[nX][6]
				Next
			Endif
			
			If ! lDebito
				AltvencImp(SE2->E2_VENCREA)
			Endif
			
			Reclock( "SE2")
			SE2->E2_SALDO	+= nValBaix2 - Iif(nValBaix2-nValImp == SE2->E2_VALOR-SE2->E2_SALDO .Or. lPaBruto,nValImp,0)
			SE2->E2_SDDECRE += nTitDecre
			SE2->E2_SDACRES += nTitAcres
			If !(cTipoTit $ MV_CPNEG .or. Alltrim(cTipoTit) $ MVPAGANT)
				SE2->E2_SALDO  += nTotAbat
			Endif	
			If cPaisLoc == "BRA"			
			   SE2->E2_VALLIQ := 0
			Else 
			   SE2->E2_VALLIQ -= nLiq
			EndIf   			   
			If NoRound( SE2->E2_VALOR, 2 ) == NoRound( SE2->E2_SALDO, 2 )
				SE2->E2_BAIXA := CtoD(" /  /  ")
	            //Caso exista solicitacao de NCP eh necessario atualizar o campo CU_DTBAIXA... 
				If cPaisLoc <> "BRA"
					A055AtuDtBx("2",SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_NUM,SE2->E2_PREFIXO,SE2->E2_BAIXA)
				EndIf				
			EndIF
			MsUnlock()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava lançamento no PCO ref titulo principal apos a canc.compensacao    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PCODetLan("000017","01","FINA340")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza dados no Cadastro de Fornecedores					  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SA2")
			dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
			RecLock("SA2")
			If SE2->E2_MOEDA > 1
				nValPadrao := Round(NoRound(xMoeda(SE5->E5_VALOR - Iif(nValBaix2-nValImp == SE2->E2_VALOR-SE2->E2_SALDO .Or. lPaBruto,nValImp,0),1,nMoeda,SE5->E5_DATA,3,,If(cPaisLoc=="BRA",Fa340TxMd(nMoeda,SE2->E2_TXMOEDA),0)),3),2)
			Else
				nValPadrao := nValBaix2+nTotAbat-Iif(nValBaix2-nValImp == SE2->E2_VALOR-SE2->E2_SALDO .Or. lPaBruto,nValImp,0)  
			Endif
			IF SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
				SA2->A2_SALDUP		-= nValPadrao
				SA2->A2_SALDUPM	-= xMoeda(nValPadrao,nMoeda,Val(GetMv("MV_MCUSTO")),SE2->E2_EMISSAO,,If(cPaisLoc=="BRA",Fa340TxMd(nMoeda,SE2->E2_TXMOEDA),0))
			Else
				SA2->A2_SALDUP		+= nValPadrao
				SA2->A2_SALDUPM	+= xMoeda(nValPadrao,nMoeda,Val(GetMv("MV_MCUSTO")),SE2->E2_EMISSAO,,If(cPaisLoc=="BRA",Fa340TxMd(nMoeda,SE2->E2_TXMOEDA),0))
			Endif
			SA2->(MsUnlock())
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Final  da protecao via TTS								  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		End Transaction
		
		//Baixa Impostos e NDF - PABRUTO
		If lPABruto .and. !lNDF
			If lDebito
				Fa340BxTxPa(nReg,.T.)
			Else
				For nX := 1 to len(aRecPA)
					Fa340BxTxPa(aRecPA[nX],.T.)
				Next
			EndIf
		ElseIf lPaBruto .and. lNDF
			FA340GeraNDF(nRecNDF,,,.T.) // exclui NDF
		EndIf
		
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a gravacao dos lancamentos do SIGAPCO            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoFinLan("000017")
	
	Exit
	
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	If TcSrvType() != "AS/400"
		dbSelectArea( "TRB")
		dbCloseArea()
	Endif
#ENDIF

UnLockCmpCP(cChvSemaf)
dbSelectArea( "SE2" )
dbSetOrder( 1 )
dbSelectArea( "SE5" )
dbSetOrder( 1 )
dbGoTo( nReg )

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa340Tit	³ Autor ³ Valter G. Nogueira Jr.³ Data ³ 18/03/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera Tabela com os titulos 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fina340																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC Function Fa340Tit()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a Integridade dos dados de Entrada 						  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL nTotComp :=0
LOCAL lMarca	:=.F.
LOCAL nRecEmp  := SM0->(RecNo())
LOCAL cEmpAnt  := SM0->M0_CODIGO
LOCAL cFilDe
LOCAL cFilAte
Local nDecs := MsDecimais(nMoeda)
Local cCondicao

Local lQuery := .F.
Local cCPNEG	:=	MV_CPNEG
Local nX := 0
Local nTotAbat := 0
Local nSaldo	:=	0
Local nValmin:= 0
Local lVerLibTit := .T.
Local lAdiciona := .T.
Local lPaBruto		:= GetNewPar("MV_PABRUTO","2") == "1"  //Indica se o PA terá o valor dos impostos descontados do seu valor
Local cCondic

#IFDEF TOP
	Local aStru := SE2->(dbStruct())
	
#ELSE
	Local cIndexSe2
	Local nIndexSE2 
#ENDIF
Local aImp10925 := {}
Local nValImp   := 0

// Controla retencao de impostos da lei 10925.
Local lContrRet := !Empty( SE2->( FieldPos( "E2_VRETPIS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE2->( FieldPos( "E2_VRETCSL" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETPIS" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_PRETCOF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETCSL" ) ) )

Local lIRPFBaixa := IIf( ! Empty( SA2->( FieldPos( "A2_CALCIRF" ) ) ), SA2->A2_CALCIRF == "2", .F.) .And. ;
				 !Empty( SE2->( FieldPos( "E2_VRETIRF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETIRF" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_VRETIRF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETIRF" ) ) ) 

Private cOrder := SE2->(IndexKey(nSavOrd)) //Considerara a ordem do browse de entrada da rotina.

If "|" $ cCPNEG
	cCPNEG	:=	StrTran(MV_CPNEG,"|","")
ElseIf "," $ cCPNEG
	cCPNEG	:=	StrTran(MV_CPNEG,",","")
Endif    
If Mod(Len(cCPNEG),3) > 0
	cCPNEG	+=	Replicate(" ",3-Mod(Len(cCPNEG),3))
Endif	
If mv_par05 == 2
	cFilDe := cFilAnt
	cFilAte:= cFilAnt
Else
	cFilDe := mv_par06
	cFilAte:= mv_par07
Endif

If cPaisLoc <> "BRA"
	SCU->(DbSetOrder(2))
Endif
dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

aTitulos := {}
aRecNo   := {}
Pergunte("AFI340",.F.)


While !Eof() .and. M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) <= cFilAte

	cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

	#IFDEF TOP
		lQuery := .T.

		cOrder	 := SqlOrder(cOrder)
		cCondicao := "SELECT "
		For nX:= 1 to Len(aStru)
			cCondicao += aStru[nX,1]+", "
		Next
		cCondicao += "R_E_C_N_O_ E2_RECNO "
		cCondicao += "  FROM "+	RetSqlName("SE2")
		cCondicao += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'"

		IF MV_PAR02 == 1
			cCondicao += " AND E2_FORNECE = '" + cFornece + "'"
		Else
			cCondicao += " AND E2_FORNECE >='" + mv_par03 + "'"	
			cCondicao += " AND E2_FORNECE <='" + mv_par04 + "'"
		ENDIF	

		IF MV_PAR01 == 1 .And. MV_PAR02 == 1
			cCondicao += " AND E2_LOJA = '" + cLoja + "'"
		ENDIF

		cCondicao += " AND E2_SALDO <> 0"
		cCondicao += " AND E2_EMIS1 <= '" + DTOS(dDatabase) + "'"	
		cCondicao += " AND E2_TIPO <> 'PR'"
				
		If cPaisLoc <> "ANG"
			cCondicao += " AND E2_ORIGEM <> 'FINA085A' "
		EndIf

		If lDebito			
			If lVerLibTit
				// controla Liberacao do titulo
				If !Empty(GetMv("MV_APRPAG"))  
					cCondicao +=  " AND E2_DATALIB <> ' '"
				EndIf
	
				If !Empty(GetMv("MV_CTLIPAG") )
					nValmin:= GetMV("MV_VLMINPG")	
				 	cCondicao += "AND (E2_DATALIB <> ' ' OR  (E2_SALDO+E2_SDACRES-E2_SDDECRE)< " + str(nValmin)+ " )"
				EndIf
			EndIf
			
			cCondicao += " AND E2_TIPO NOT IN " + FORMATIN(cCPNEG+MVPAGANT,,3)
			cCondicao += " AND E2_TIPO NOT IN " + FORMATIN(MVABATIM,'|')
		Else
			If mv_par10 == 1	
				cCondicao += " AND E2_TIPO IN " + FORMATIN(cCPNEG+MVPAGANT,,3)
			Else  // Compensar titulos imposto
				cCondicao += " AND E2_TIPO IN " + FORMATIN(MVTXA,,3)
			Endif
		Endif  

		// Nao compensa titulos enviados ao banco (em bordero)
		If mv_par12 == 2
			cCondicao += " And  E2_NUMBOR = '" + SPACE( TamSX3("E2_NUMBOR")[1] ) + "'"	
		Endif
		cCondicao += " AND D_E_L_E_T_ <> '*' "	

		cCondicao += " ORDER BY "+ SqlOrder(cOrder)
				
		cCondicao := ChangeQuery(cCondicao)
		
		dbSelectArea("SE2")
		dbCloseArea()
		dbSelectArea("SA2")
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cCondicao), 'SE2', .F., .T.)
		
		For nX := 1 to Len(aStru)
			If aStru[nX,2] != 'C'
				TCSetField('SE2', aStru[nX,1], aStru[nX,2],aStru[nX,3],aStru[nX,4])
			Endif
		Next
   #ELSE
		lQuery := .F.

		cCondicao := 'E2_FILIAL=="' + xFilial('SE2') + '"'
		IF MV_PAR02 == 1
			cCondicao += '.And.E2_FORNECE=="' + cFornece + '"'
		ElseIf MV_PAR02 == 2
			cCondicao += '.And.E2_FORNECE>="' + Mv_Par03 + '"'	
			cCondicao += '.And.E2_FORNECE<="' + Mv_Par04 + '"'
		ENDIF	
		IF MV_PAR01 == 1 .And. MV_PAR02 == 1
			cCondicao += '.And.E2_LOJA=="' + cLoja + '"'
		ENDIF
		cCondicao += '.And.E2_SALDO<>0'
		cCondicao += '.And.DTOS(E2_EMIS1)<="' + DTOS(dDatabase) + '"'		
		cCondicao += '.And.E2_TIPO<>"PR"'

		If lDebito
			If lVerLibTit
				// controla Liberacao do titulo
				If !Empty(GetMv("MV_APRPAG"))  
					cCondicao += '.AND. !(Empty(E2_DATALIB))'
				EndIf
				If !Empty(GetMv("MV_CTLIPAG") )
					nValmin:= GetMV("MV_VLMINPG")	
				 	cCondicao += '.And. (!Empty(E2_DATALIB).Or. (E2_SALDO+E2_SDACRES-E2_SDDECRE)> ' + str(nValmin) + ')'
				EndIf
			EndIf
			
			cCondicao += '.And.!(E2_TIPO$"' + MV_CPNEG + '/' + MVPAGANT + '/' + MVABATIM + '")'
		Else
			If mv_par10 == 1
				cCondicao += '.And.(E2_TIPO$"'+ MV_CPNEG + '/' + MVPAGANT + '")'
			Else	// Compensar titulos imposto
				cCondicao += '.And.(E2_TIPO$"' + MVTXA + '")'	
			Endif
		Endif
		
		// Nao compensa titulos enviados ao banco (em bordero)
		If mv_par12 == 2 .and. !Empty(SE2->E2_NUMBOR)
			cCondicao += ' .And. E2_NUMBOR == "' + SPACE( TamSX3("E2_NUMBOR")[1] ) + '"'	
		Endif  
		
		DBSelectArea("SE2")
		cIndexSe2 := CriaTrab(nil,.f.)
		IndRegua("SE2",cIndexSe2,cOrder,,cCondicao,STR0033) // "Selecionanto Registros..."
		nIndexSE2 := RetIndex("SE2")
		dbSetIndex(cIndexSe2+OrdBagExt())
		dbSetOrder(nIndexSe2+1)

	#ENDIF
	SE2->( DBGoTop() )

	WHILE SE2->( !Eof() ) .and. SE2->E2_FILIAL == xFilial("SE2")

		// Zero a variavel que soma os impostos (lei 10925)do titulo.
		nValImp := 0
	
		//ANGOLA|BRASIL - Nao permitir compensar titulos de adiantamento relacionados a pedido
		#IFDEF TOP
			If cPaisLoc $ "ANG|BRA|MEX" .and. AliasInDic("FIE")
				FIE->(dbSetOrder(3))
				If FIE->(MsSeek(xFilial("FIE")+"P"+SE2->(E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)))
					dbSkip()
					Loop
				Endif
				// se for o titulo pricipal, procura na tabela FR3
				If cPaisLoc $ "BRA|MEX" .and. AliasInDic("FR3") .and. SE2->E2_TIPO = MVNOTAFIS
					FR3->(dbSetOrder(3))
					If FR3->(MsSeek(xFilial("FR3")+"P"+SE2->(E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)))
						dbSkip()
						Loop
					Endif	
				Endif
			Endif	
		#ENDIF	

		// Caso controle retencao de impostos da lei 10925 e caso seja PA, efetua
		// varredura dos impostos para compor o valor principal a ser usado na compensacao.
		If (lContrRet .Or. lIRPFBaixa) .And. SE2->E2_TIPO $ MVPAGANT        
		
			If lIRPFBaixa
				aImp10925 := BuscaTXs(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCIR)
			Else
				aImp10925 := TxLei10925(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_PARCPIS,SE2->E2_PARCCOF,SE2->E2_PARCSLL)					
			EndIf
				
			For nX := 1 To Len(aImp10925)
				nValImp += aImp10925[nX][6]
			Next
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso esteja ligado o controle de solicitacao de notas de credito e exista alguma ³
		//³ pendencia para este titulo                                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If cPaisLoc	<> "BRA"
			SCU->(DbSetOrder(2))
		EndIf
		
		If cPaisLoc	<> "BRA" .and. GetMv('MV_SOLNCP') .And. SE2->E2_TIPO == MVNOTAFIS ;
					.And. SCU->(MsSeek( xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_NUM+SE2->E2_PREFIXO )).And. Empty(SCU->CU_NCRED)
				//HELP(" ",1,"SOLNCPAB")
				lMarca   := .F.
				nValComp := 0
		ElseIf nTotComp < nValor .or. nValor == 0

			lMarca   := .T.

			
			If cPaisLoc == "BRA"			
				nSaldo	:=	xMoeda(E2_SALDO+E2_SDACRES-E2_SDDECRE,SE2->E2_MOEDA,nMoeda,,5	,If(nMoeda        == 1,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),Fa340TxMd(SE2->E2_MOEDA,nTxMoeda        ));
																							,If(SE2->E2_MOEDA == 1,Fa340TxMd(nMoeda       ,nTxMoeda       ),Fa340TxMd(nMoeda        ,SE2->E2_TXMOEDA)))
			   nValComp := IIF (nValor-nTotComp > nSaldo .or. nValor == 0,nSaldo + nValImp,nValor-nTotComp)
			Else 			
				nSaldo	:=	Round(xMoeda(E2_SALDO+E2_SDACRES-E2_SDDECRE ,SE2->E2_MOEDA,nMoeda,dDatabase,nDecs+1,aTxMoedas[E2_MOEDA][2],aTxMoedas[nMoeda][2]),nDecs)
			   nValComp := IIF (nValor-nTotComp > nSaldo .or. nValor == 0,nSaldo,nValor-nTotComp)			
			EndIf			   			   

			//Pa Bruto nao resoma impostos
			If nValor-nTotComp > nSaldo .or. nValor == 0 .and. lPaBruto
				nValComp -= nValImp
			Endif

			nTotComp += nValComp
		Else
			lMarca   := .F.
			nValComp := 0
		EndIf
		If cPaisLoc == "BRA"		
			lAdiciona := .T.
			// Nao somo abatimentos, se o titulo for de debito
			If !(SE2->E2_TIPO $ MV_CPNEG + "/" + MVPAGANT)
				nTotAbat := SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,,SE2->E2_FORNECE)
			Else
				nTotAbat := 0	
				SEF->(DbSetOrder(3))
				SEF->(MsSeek(xFilial("SEF")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+Pad(E2_NUMBCO,Len(SEF->EF_NUM)))))
				
				If mv_par01 = 1 .And. mv_par02 = 1
					//Considera Loja e Fornecedor Original.
					cCondic := 'SE2->E2_FORNECE == SEF->EF_FORNECE .And. SE2->E2_LOJA == SEF->EF_LOJA .And. SEF->EF_LIBER == "N"'
				Elseif (mv_par01 = 2 .And. mv_par02 = 1) .Or. (mv_par02 = 2)
					//Não considera Loja e considera o Fornecedor Original ou então apenas considera Outros Fornecedores.
					cCondic := 'SE2->E2_FORNECE == SEF->EF_FORNECE .And. SEF->EF_LIBER == "N"'
				Else
					cCondic := 'SEF->EF_LIBER == "N"'
				Endif
				
				While SEF->(EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO+EF_NUM)==SE2->( E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+Pad(E2_NUMBCO,Len(SEF->EF_NUM)) ) .and. !SEF->(Eof())
					//Verifica se ha cheques nao liberados.
					If &cCondic
						lAdiciona := .F.
						Exit 
					Endif					
					SEF->(dbSkip())
				EndDo
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica PA se tem movimento no SE5 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (SE2->E2_TIPO $ MVPAGANT)					
					lAdiciona := FA340VerPA()
				Endif
			Endif

			If lAdiciona
				Aadd(aTitulos,{E2_PREFIXO,;
			   					E2_NUM,;
			   					E2_PARCELA,;
			   					E2_TIPO,;
			   					Transform(Round(NoRound(xMoeda(E2_SALDO+nValImp+E2_SDACRES-E2_SDDECRE-nTotAbat,SE2->E2_MOEDA,nMoeda,,nDecs+1	,If(nMoeda        == 1,Fa340TxMd(SE2->E2_MOEDA,SE2->E2_TXMOEDA),Fa340TxMd(SE2->E2_MOEDA,nTxMoeda        ));
			   																															,If(SE2->E2_MOEDA == 1,Fa340TxMd(nMoeda       ,nTxMoeda       ),Fa340TxMd(nMoeda        ,SE2->E2_TXMOEDA))),nDecs+1),nDecs),"@E 9999,999,999.99"),;
			   					Transform(nValComp-If(nValor<=0,nTotAbat,0),"@E 9999,999,999.99"),;
			   					E2_NOMFOR,;
			   					lMarca,;
			   					nValComp-If(nValor<=0,nTotAbat,0),;
								   Transform(xMoeda(E2_SDACRES,E2_MOEDA,nMoeda,,5),"@E 9999,999,999.99"),;
								   Transform(xMoeda(E2_SDDECRE,E2_MOEDA,nMoeda,,5),"@E 9999,999,999.99"),;
	  		   			      E2_EMISSAO,;
	  		   			      E2_VENCREA})
				Aadd(aRecNo,If(lQuery,SE2->E2_RECNO , SE2->(RecNo())))
			Endif
		Else
			Aadd(aTitulos,{E2_PREFIXO,;
		   					E2_NUM,;
		   					E2_PARCELA,;
		   					E2_TIPO,;
		   					Transform(Round(xMoeda(E2_SALDO+E2_SDACRES-E2_SDDECRE,SE2->E2_MOEDA,nMoeda,E2_EMISSAO,nDecs+1,aTxMoedas[E2_MOEDA][2],aTxMoedas[nMoeda][2]),nDecs),"@E 9999,999,999.99"),;
		   					Transform(nValComp,"@E 9999,999,999.99"),;
		   					E2_NOMFOR,;
		   					lMarca,;
		   					E2_MOEDA,;
		   					E2_EMISSAO,;
							   Transform(xMoeda(E2_SDACRES,E2_MOEDA,nMoeda,,5),"@E 9999,999,999.99"),;
							   Transform(xMoeda(E2_SDDECRE,E2_MOEDA,nMoeda,,5),"@E 9999,999,999.99") })
			Aadd(aRecNo,If(lQuery,SE2->E2_RECNO , SE2->(RecNo())))
		EndIf	  		   
		
		SE2->( DBSkip() )
		
	EndDo
	#IFNDEF TOP
		dbSelectArea("SE2")
		dbClearFil()
		RetIndex( "SE2" )
		If !Empty(cIndexSE2)
			FErase (cIndexSE2+OrdBagExt())
		Endif
		dbSetOrder(1)
	#ELSE
		dbSelectArea("SE2")
		dbCloseArea()
		ChKFile("SE2")
		dbSelectArea("SE2")
		dbSetOrder(1)
	#ENDIF
	
	dbSelectArea("SM0")
	dbSkip()
	If Empty(xFilial("SE2"))
		EXIT
	Endif
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SM0")
dbGoto(nRecEmp)
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza valor total dos t¡tulos - Windows	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nValTot := 0
For nX := 1 to Len(aTitulos)
	If aTitulos[nX,8]
		If F340Semaforo(aTitulos[nX],.T.,aRecno[nX],,,,.F.)
			nValtot += Fa340VTit(aTitulos[nX,6])
		Else
			aTitulos[nX,8] := .F.
		Endif
	Endif
Next

dbSelectArea(cSavArea)
dbSetOrder(nSavOrd)
dbgoto(nRecNo)

Return aTitulos

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa340VTit ³ Autor ³ Mauricio Pequim Jr.   ³ Data ³ 14/01/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna o saldo ou valor do titulo a ser compensado		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fina340																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

STATIC Function Fa340VTit(aTitulo,cTipoTit,cValor)

LOCAL nValor
cValor := IIF (cValor == NIL,aTitulo,cValor)
nValor := DesTrans(cValor)
Return nValor

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa340Tit1 ³ Autor ³ Marcos Patricio		  ³ Data ³ 19/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna o saldo ou valor do titulo a ser compensado		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa340Tit1																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FA340Tit1()
Local lRet :=.T. 
Local aArea 

dbSelectArea("SE2")
aArea := GetArea()
dbSetOrder( 6 )

If !dbSeek(cFilial+cFornece+cLoja+cPrefixo+cNum+cParcela+cTipoTit)
	DbSetOrder(1)
	Help(" ",1,"NOTIT")
	lRet :=.F.
EndIf

DbSelectArea("SE2")
RestArea(aArea) 

Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa340OK	³ Autor ³ Marcos Patricio		  ³ Data ³ 19/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Confirma a marcacao dos titulos para compensacao.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa340OK																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FA340OK()

If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
	If !CTBvldDiario(cCodDiario,dDataBase)
		Return(.f.)
	EndIf
EndIf

Return (MsgYesNo(OemToAnsi(STR0024),OemToAnsi(STR0018)))  //"Confirma marca‡„o de T¡tulos ?"###"Aten‡„o"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa340Troca³ Autor ³ Marcos Patricio		  ³ Data ³ 19/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Troca o flag para marcado ou nao,aceitando valor.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa340Troca																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FA340Troca(nIt,aArray,oGet)

Local oDlg
Local nOpca := 0
Local nI := 0
Local nAcresc := 0
Local lOk		:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso esteja ligado o controle de solicitacao de notas de credito e exista alguma ³
//³ pendencia para este titulo                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If cPaisLoc	<> "BRA" .and. !aArray[nIt,8]
	SCU->(DbSetOrder(2))
	If GetMv('MV_SOLNCP') .And. aTitulos[nIt,4] == MVNOTAFIS ;
			.And. SCU->(MsSeek( xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA+aTitulos[nIt,2]+aTitulos[nIt,1] )).And. Empty(SCU->CU_NCRED)
		HELP(" ",1,"SOLNCPAB")
		Return aArray
	Endif
Endif


cValor  := Fa340VTit(aTitulos[nIt,6])
cSaldo  := Fa340VTit(aTitulos[nIt,5])

nValtot := 0

aArray[nIt,8] := !aArray[nIt,8]

If aArray[nIt,8]

	DEFINE MSDIALOG oDlg FROM 069,070 TO 160,330 TITLE OemToAnsi(STR0005) PIXEL  //"Compensa‡„o de Titulos a Pagar"

	@ 001, 002 TO 027, 128 OF oDlg  PIXEL
	@ 010, 068 MSGET cValor Picture "@E 9999,999,999.99" SIZE 54, 10 OF oDlg Hasbutton PIXEL
	@ 011, 009 SAY OemToAnsi(STR0014)  SIZE 54, 7 OF oDlg PIXEL  //"Valor a compensar"
	DEFINE SBUTTON FROM 29, 71 TYPE 1 ENABLE ACTION (nOpca:=1,If((cValor <= cSaldo .AND. cValor > 0),oDLg:End(),nOpca:=0)) OF oDlg
	DEFINE SBUTTON FROM 29, 99 TYPE 2 ENABLE ACTION (aArray[nIt,8]:=.F.,oDlg:End()) OF oDlg

	ACTIVATE MSDIALOG oDlg

	IF nOpca == 1
		If !F340Semaforo(aArray[nIt],.T.,aRecno[nIt]) // se conseguirmos travar o registro do SE2
			lOk := .F.
			aArray[nIt,8] := .F.
		Endif
		
		If lOk
			If Fa340CSld(aRecno[nIt], cValor)
				aArray[nIt,6]:=Transf(cValor,"@E 9999,999,999.99")
				If cPaisLoc == "BRA"
					aArray[nIt,9]:= cValor
				Endif
				For nI := 1 to Len(aArray)
				   If aArray[nI,8]
				      nValtot += Fa340VTit(aArray[nI,6])
				   Endif
				Next
			Else
				aArray[nIt,8] := !aArray[nIt,8]
			Endif
		Endif
	
	Else
		aArray[nIt,8] := !aArray[nIt,8]
	Endif
Else
	If !aArray[nIt,8]
		aArray[nIt,6]:=Transf(0,"@E 9999,999,999.99")
		If cPaisLoc == "BRA"
			aArray[nIt,9]:= 0
		Endif
	Endif
	For nI:=1 to Len(aArray)
	   If aArray[nI,8]
	      nValtot+=Fa340VTit(aArray[nI,6])
	   Endif
	Next
	F340Semaforo(aArray[nIt],.F.,aRecno[nIt])
EndIf
If oGet != Nil
	oGet:Refresh()
Endif
Return aArray

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa340Marca³ Autor ³ Alice Y Yamamoto 	  ³ Data ³ 08/04/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marca os itens a serem excluidos 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa340descr																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fa340Marca(nIt,aArray,aRegistros)

If (aArray[nIt,10] )
	F340Semaforo( {} , .F. /*TRAVA*/ , aRegistros[nIt] /*Recno*/ , "" /*chave para trava*/, {} ,.F. /*estorno*/)
	aArray[nIt,10] := .F.
Else
	If F340Semaforo( {} , .T. /*TRAVA*/ , aRegistros[nIt] /*Recno*/ , "" /*chave para trava*/, {} ,.F. /*estorno*/)
		aArray[nIt,10] := .T.
	Endif
Endif

Return aArray

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa340SetMo³ Autor ³ Fernando Machima      ³ Data ³ 19/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Tela de taxas de moedas                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa340SetMo																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Fa340SetMo()

Local oDlg 
Local nLenMoedas	:= Len(aTxMoedas)
Local nI            := 1
Local nLinTelaF  							//altura da tela de fora
Local nLinTelaD								// altura da tela de dentro	     
Local nLinButton
Local aSay := {}
Local aGet := {}
Local cBlKMoeda    

nLinTelaD	:=  05 + ((nLenMoedas-1) * 14)			// altura da tela de dentro	-> 14-tamanho de cada linha -> 5-sobra em cima e em baixo    
nLinTelaF  	:= 200 + ((nLenMoedas-1) * 30.5) + 35	// altura da tela de fora -> 200-onde comecou a tela -> 30,5-equivalente por linha -> 35-botao e sobras da tela 

nLinButton  :=  03 + nLinTelaD

If nLenMoedas > 1

	DEFINE MSDIALOG oDlg From 200,0 TO nLinTelaF,230 TITLE OemToAnsi(STR0026) PIXEL  //Taxas Moedas			

		@ 005,005  To nLinTelaD,110 OF oDlg PIXEL

		For nI := 1 To nLenMoedas-1              
			cBlKMoeda := "{|| aTxMoedas["+AllTrim(Str(ni+1))+",1]}"
			aAdd(aSay, TSay():New(1+(ni*12),010,&cBlKMoeda,oDlg,,, .F., .F., .T.,.T.,,,,, .F., .F., .F., .F.)) 
		    aAdd(aGet, TGet():New((ni*12)-2,060,&("{|x| If(x <> NIL,aTxMoedas["+AllTRim(Str(ni+1))+",2] := x,aTxMoedas["+Str(ni+1)+",2])}"),oDlg,45,,aTxMoedas[nI,3],,,,,,,.T.,,,,.F.,.T.,,.F.,.F.,,,,.F.,,.T.))
		Next nI
				
	DEFINE  SButton FROM nLinButton,80 TYPE 1 Action (oDlg:End() ) ENABLE OF oDlg  PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED
Else
	Help("",1,"NoMoneda")
Endif
Return
           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³Fa340TudOkºAutor  ³Mauricio`Pequim Jr  º Data ³  24/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validar os campos informados na compensacao                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Fina340                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Fa340TudOk(oDlg)

Local nX
Local lRet := .T.

For nX := 1 To Len(oDlg:aControls)
	If ValType(oDlg:aControls[nX]) == "O" .And.;
		!Empty(oDlg:aControls[nX]:bValid)
		
		lRet:=Eval(oDlg:aControls[nX]:bValid)
		If ValType(lRet) != "L"
			lRet := .T.
		Endif	
		If !lRet
			Help(" ",1,"F340Erro")	
			Exit // Sai no primeiro campo invalido
		Endif	
	Endif
Next

Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fa340Leg   ³ Autor ³ Nilton Pereira       ³ Data ³ 17.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria uma janela contendo a legenda da mBrowse              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA340                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Fa340Leg(nReg)

Local uRetorno := .T.
Local aLegenda := {	{"ENABLE"		, 	STR0034	},;	// "Titulo nao Compensado"
				   	{"DISABLE"		, 	STR0035	},;	// "Titulo Compensado Totalmente"
				   	{"BR_AZUL"		,   STR0036	}} 	// "Titulo Compensado Parcialmente"


If nReg = Nil	// Chamada direta da funcao onde nao passa, via menu Recno eh passado
	uRetorno := {}
	Aadd(uRetorno, {'E2_SALDO =  E2_VALOR .AND. E2_ACRESC = E2_SDACRES', aLegenda[1][1]}) // Titulo nao Compensado
	Aadd(uRetorno, {'E2_SALDO =  0', aLegenda[2][1]})			// Titulo Compensado Totalmente 
	Aadd(uRetorno, {'E2_SALDO <> 0', aLegenda[3][1]})			// Titulo Compensado Parcialmente
Else
	BrwLegenda(cCadastro,STR0037,aLegenda) 
Endif


Return uRetorno

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fa340TxMd  ³ Autor ³ Cristiano Denardi    ³ Data ³ 05.04.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Busca Taxa em aTxMoedas e verifica se foi trocada          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA340                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Fa340TxMd( nMoeda, nTx )

Local lExistTxMd	:= Type("aTxMoedas")#"U" .And. Len(aTxMoedas) > 0  

Default nTx			:= 0
Default nMoeda 		:= 0

If nMoeda > 0 .And. lExistTxMd
	If aTxMoedas[nMoeda][2] <> aTxMoedas[nMoeda][4]
		nTx := aTxMoedas[nMoeda][2]
	Elseif nTx <> aTxMoedas[nMoeda][4]
		nTx := aTxMoedas[nMoeda][2]
	Endif
Endif

Return( nTx )
 

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fa340Inver ³ Autor ³ Cristiano Denardi    ³ Data ³ 05.04.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inverte a selecao da relacao de Titulos a Compensar        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA340                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Fa340Inver( aTit, oTit, oGet )

Local nA := 0

nValTot  := 0 

For nA := 1 To Len(aTit)
	aTit[nA][08] := !aTit[nA][08]
	If aTit[nA][08]
		If ( Fa340VTit(aTit[nA][6]) = 0 )
	 		aTit[nA][6] := aTit[nA][5]
	 		If cPaisLoc == "BRA"
		 		aTit[nA][9] := DesTrans(aTit[nA][5])
	 		EndIf
		Endif
		nValTot += Fa340VTit(aTit[nA][6])
	Else
		aTit[nA][6] := Transform(0,"@E 9999,999,999.99")
		If cPaisLoc == "BRA"
			aTit[nA][9] := aTit[nA][6]
		EndIf	
	Endif
Next nA

oTit:Refresh()
oGet:Refresh()

Return Nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fMarkAll   ³ Autor ³ Cristiano Denardi    ³ Data ³ 05.04.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Marca ou Desmarca todos os titulos				          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA340                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fMarkAll( aTit )

Local nA 		:= 0
Local nI 		:= 0
Local lReturn 	:= .T.

If Len(aTit) > 0
	For nI := 1 to Len(aTit)
		If !aTit[nI][8]
			lReturn := .F.
		EndIf
	Next nI
	
	nValTot  := 0 
	For nA := 1 To Len(aTit)
		If !lReturn

			If F340Semaforo(aTit[nA],.T.,aRecno[nA])

				aTit[nA][08]	:= .T.
				aTit[nA][6]		:= aTit[nA][5]
				If cPaisLoc == "BRA"
					aTit[nA][9]		:= DesTrans(aTit[nA][5])
					nValTot			+= Fa340VTit(aTit[nA][6])
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Caso esteja ligado o controle de solicitacao de notas de credito e exista alguma ³
				//³ pendencia para este titulo                                                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
				ElseIf cPaisLoc	<> "BRA"
					SCU->(DbSetOrder(2))
					If GetMv('MV_SOLNCP') .And. aTit[nA,4] == MVNOTAFIS ;
							.And. SCU->(MsSeek( xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA+aTit[nA,2]+aTit[nA,1] )).And. Empty(SCU->CU_NCRED)
						//HELP(" ",1,"SOLNCPAB")
						aTit[nA][08]	:= .F. 
						aTit[nA][6]		:= Transform(0,"@E 9999,999,999.99")
					Else
						nValTot			+= Fa340VTit(aTit[nA][6])
					Endif
				EndIf
			Endif
		Else
			F340Semaforo(aTit[nA],.F.,aRecno[nA])
			aTit[nA][08]	:= .F.
			aTit[nA][6]		:= Transform(0,"@E 9999,999,999.99")
			If cPaisLoc == "BRA"
				aTit[nA][9]		:= DesTrans(aTit[nA][6])
		    EndIf
		Endif
	Next nA
EndIf

Return lReturn


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fa340IntPco ºAutor ³Paulo Carnelossi    º Data ³  22/11/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³funcao que gera os lancamentos no sigapco (PcoDetLan())     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function Fa340IntPco(nRecSE2, aRecnoSE2, aBaixaSE5)

Local aArea := GetArea()
Local aAreaSE2 := SE2->(GetArea())
Local aAreaSE5 := SE5->(GetArea())
Local nX

If SuperGetMV("MV_PCOINTE",.F.,"2")=="1"

	dbSelectArea("SE2")
	dbGoto(nRecSE2) //titulo principal apos a compensacao
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava lançamento no PCO ref titulo principal apos a compensacao    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PCODetLan("000017","01","FINA340")
	
	For nX := 1 TO Len(aRecnoSE2) // ARRAY COM REGISTROS TITULOS COMPENSADOS
	
		//grava lcto ref. titulo compensado
		dbSelectArea("SE2")	
		dbGoto(aRecnoSE2[nX])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava lançamento no PCO ref titulo compensado apos a compensacao   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PCODetLan("000017","02","FINA340")
	
		//grava lctos das baixas referente titulo principal e titulo compensado
		dbSelectArea("SE5")
		
		dbGoto(aBaixaSE5[(nX*2)-1])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava lançamento no PCO ref baixa (Mov.Bancaria-SE5) do titulo principal apos a compensacao   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PCODetLan("000017","03","FINA340")
	
		dbGoto(aBaixaSE5[(nX*2)])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava lançamento no PCO ref baixa do titulo compensado (Mov.Bancaria-SE5)  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PCODetLan("000017","04","FINA340")
	
	Next
	
EndIf

RestArea(aAreaSE5)
RestArea(aAreaSE2)
RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Ana Paula N. Silva     ³ Data ³23/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados     ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MenuDef()

Local aRotina := { { STR0001,"AxPesqui"  , 0 , 1,,.F. },;  //"Pesquisar"
	{ STR0002,"AxVisual"  , 0 , 2 },;  //"Visualizar"
	{ STR0003,"U_F340C()" , 0 , 4 },;  //"Compensar"
	{ STR0004,"Fa340Desc" , 0 , 4 },;  //"Excluir"
	{ STR0040,"Fa340Desc" , 0 , 4 },;  //"Estornar"
	{ STR0037,"Fa340Leg"  ,0,2, ,.F.} }      //"Legenda"
Return(aRotina)
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fa340VerNDF³ Autor ³ Marcel Borges        ³ Data ³ 15.09.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se o título tem NDF e se sofreu baixas            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA340                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Fa340VerNDF(lNDF,nRecNDF)

	Local aArea    := GetArea()
	Local nRecno
	
	DEFAULT lNDF    := .F.
	DEFAULT nRecNDF := 0
	
	DbSelectArea("SE2")
	DbSetOrder(1)
	nRecno := SE2->(recno())
	If MsSeek(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+MV_CPNEG+SE2->E2_FORNECE+SE2->E2_LOJA)
		lNDF := .T.
		nRecNDF := SE2->(recno())
		If SE2->E2_SALDO < SE2->E2_VALOR
			RestArea(aArea)
			Return .T.
		EndIf
	EndIf		
	dbGoTo(nRecno)
	RestArea(aArea)
Return .F.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fa340DelTx ³ Autor ³ Marcel Borges        ³ Data ³ 22.11.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cancela TX geradas pela compensacao           	          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA340                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fa340DelTx(nRecAnt)

	Local aArea     := GetArea()
    Local cQuery
    Local nSE2
    Local aStruSE2 
    //Controla o Pis Cofins e Csll na baixa
	Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
					 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
					 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
					 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

	Local	lIRPFBaixa := IIf( ! Empty( SA2->( FieldPos( "A2_CALCIRF" ) ) ), SA2->A2_CALCIRF == "2", .F.) .And. ;
					    !Empty( SE2->( FieldPos( "E2_VRETIRF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETIRF" ) ) ) .And. ;
					   	!Empty( SE5->( FieldPos( "E5_VRETIRF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETIRF" ) ) ) 				 

    
    SE2->(DbGoTo(nRecAnt))           
    
	#IFDEF	TOP
		cQuery := "SELECT E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO, "
		cQuery += "SE2.E2_FORNECE, SE2.E2_LOJA, SE2.E2_TITPAI, SE2.R_E_C_N_O_ RECNO"
		cQuery += "FROM "+RetSqlName("SE2")+" SE2 "
		cQuery += "WHERE "
		cQuery += "E2_FILIAL = '"+xFilial("SE2")+"' AND "		
		cQuery += "SE2.E2_PREFIXO = '"+SE2->E2_PREFIXO+"' AND "		
		cQuery += "SE2.E2_NUM ='"+SE2->E2_NUM+"' AND "
		cQuery += "SE2.E2_TIPO = '"+MVTAXA+"' AND "	
		cQuery += "SE2.E2_TITPAI = '"+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)+"' AND "
		cQuery += "SE2.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY "
		cQuery += "SE2.E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO"
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)
		
		aStruSE2:= SE2->(dbStruct())

		For nSE2 := 1 To Len(aStruSE2)
			If aStruSE2[nSE2][2] <> "C" .and.  FieldPos(aStruSE2[nSE2][1]) > 0
				TcSetField("QRY",aStruSE2[nSE2][1],aStruSE2[nSE2][2],aStruSE2[nSE2][3],aStruSE2[nSE2][4])
			EndIf
		Next nSE2
		
		While QRY->(!EOF())
			SE2->(dbGoTo(QRY->RECNO))
			IF (lIRPFBaixa .And. Alltrim(SE2->E2_NATUREZ)$(GetMv("MV_IRF"))) .Or.;
			   (lPCCBaixa .And. Alltrim(SE2->E2_NATUREZ)$(GetMv("MV_COFINS"))) .aND. ;
			   (Alltrim(SE2->E2_NATUREZ)$(GetMv("MV_CSLL"))	.AND.  Alltrim(SE2->E2_NATUREZ)$(GetMv("MV_PISNAT")))	
				Reclock("SE2")
				SE2->(DbDelete())
				MsUnlock()    
			EndIf	
			QRY->(DbSkip())
		EndDo
		
		If TcSrvType() != "AS/400"
			dbSelectArea( "QRY")
		dbCloseArea()
	Endif
		
	#ENDIF	
		RestArea(aArea)
		
Return .T.

   

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FinA340T   ³ Autor ³ Marcelo Celi Marques ³ Data ³ 26.03.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada semi-automatica utilizado pelo gestor financeiro   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA340                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function FinA340T(aParam)

	cRotinaExec := "FINA340"
	ReCreateBrow("SE2",FinWindow)      	
	FinA340(aParam[1])
	ReCreateBrow("SE2",FinWindow)      	
	dbSelectArea("SE2")
	
	INCLUI := .F.
	ALTERA := .F.
	
Return .T.	



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA340VerPa ºAutor  ³ Gustavo Henrique º Data ³  20/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica se houve movimento de liberacao de cheque para PA º±±
±±º          ³ quando informado "sim" para pergunta "Gera Chq Adt?" no    º±±
±±º          ³ momento da inclusao do titulo de PA.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro - Compensacao CP                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FA340VerPA()

Local aAreaSE5	:= GetArea('SE5')           
Local cChavePA	:= ""
Local lCheqLib	:= .F.
Local lRet		:= .T.
                
cChavePA := xFilial("SE5")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)

// Caso não tenha achado movimento para o PA ou
// Achou movimento, mas nao possui cheque gerado, nao permite a compensacao (Gera Chq Adt = Sim, Gera mov s/ chq = Nao)
SE5->( dbSetOrder( 7 ) )
lRet := SE5->( dbSeek( cChavePA ) )
If lRet .And. SE5->E5_TIPODOC $ "BA/CH"	// Baixa ou Cheque
    Do While SE5->( ! EoF() .And. E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA == cChavePA )
		If SE5->E5_TIPODOC $ "BA/CH" .And. !Empty(SE5->E5_NUMCHEQ) .And. SubStr(SE5->E5_NUMCHEQ,1,1) <> "*"
			lCheqLib := .T.
			Exit		
		EndIf    
    	SE5->( dbSkip() )
	EndDo          	 
	lRet := lCheqLib
EndIf

RestArea(aAreaSE5)

Return lRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FaNfsRAdt   ³ Autor ³Totvs                ³ Data ³10.05.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Checa se condicao de pagamento do documento de entrada usa  ³±±
±±³          ³adiantamento.                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica se Condicao de Pagamento gera Adiantamento    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Prefixo do titulo                                    ³±±
±±³          ³ExpC2: Numero do titulo                                     ³±±
±±³          ³ExpC3: Codigo do fornecedor                                 ³±±
±±³          ³ExpC4: Loja do fornecedor                                   ³±±
±±³          ³ExpD5: Data de Emissao do Documento                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function FaNfsRAdt(cPrefixo,cNum,cFornece,cLoja,dDataEmis)

Local aArea := GetArea()
Local cQ := ""
Local lRet := .F.

cQ	:= "SELECT F1_COND "
cQ += "FROM "+RetSqlName("SF1")+" "
cQ += "WHERE F1_FILIAL = '"+xFilial("SF1")+"' "
cQ += "AND F1_PREFIXO = '"+cPrefixo+"' "
cQ += "AND F1_DUPL = '"+cNum+"' "
cQ += "AND F1_FORNECE = '"+cFornece+"' "
cQ += "AND F1_LOJA = '"+cLoja+"' "
cQ += "AND F1_DTDIGIT = '"+dTos(dDataEmis)+"' "
cQ += "AND D_E_L_E_T_= ' ' "

cQ := ChangeQuery(cQ)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"TRBSF1",.T.,.T.)

If !Eof()
	If A120UsaAdi(TRBSF1->F1_COND)
		lRet := .T.
	Endif
Endif

TRBSF1->(dbCloseArea())

RestArea(aArea)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LockcCmpCp  ºAutor  ³Clovis Magenta      º Data ³  22/10/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que bloqueia os registros selecionados na rotina de  º±±
±±º          ³ compensacao para manter integridade dos dados               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA340                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function LockCmpCP( cChave , lMsg)

Local lRet := .T.
DEFAULT lMsg := .T.

While lRet .And. !LockByName( "F340" + cChave + cEmpAnt ,.T., .F., .T. )
	If !__lBlind
		If lMsg // quando carregamos a tela para seleção de titulos, simplesmente não deixamos o titulo marcado.
			If Aviso("Registro em uso","Este registro está sendo manipulado por outro usuário e se encontra travado. Deseja tentar usá-lo novamente?",{"Sim", "Não"},2)==1
//			+CHR(13)+CHR(10)+"Chave do título (Filial+Pref+Num+Parc+Tipo+Fornec+Loja: "+ cChave 
				Loop
			Else
				lRet:=.F.
			Endif
		Else
			lRet:=.F.
		Endif
	Else
		Sleep( 5000 )
	EndIf
EndDo

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UnLockCmpCpºAutor  ³Clovis Magenta      º Data ³  22/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para liberar registro em lock na rotina de compensa- º±±
±±º          ³ cao.                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA340                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function UnLockCmpCP( cChave )

Return ( UnLockByName( "F340" + cChave + cEmpAnt , .T. , .F., .T. ), nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F340Semaforo ºAutor  ³Clovis Magenta      º Data ³ 22/10/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que realiza o bloqueio do registro SE2 selecionado   º±±
±±º          ³ no momento da compensacao, para nao haver conflito de dados º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA340                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC Function F340Semaforo( aDados , lTrava , nRecno , cChvSE2 , aRegs ,lCompensa ,lMsg )

Local lCancel	:= (nRecno == 0) // quando igual a zero, a tela de seleção dos títulos fora cancelada Ou iniciada)
Local lRet 		:= .T.
Local aArea		:= GetArea()
Local aAreaSE2	:= SE2->(GetArea())
Local nX			:= 0

DEFAULT  aRegs		:= {}
DEFAULT  cChvSE2	:= ""
DEFAULT lCompensa := .T.
DEFAULT lMsg		:= .T.

If lCompensa
	If !lCancel
	
		dbSelectArea("SE2")
		SE2->(dbGoTo(nRecno))
		cChvSE2 := xFilial("SE2")+aDados[1]+aDados[2]+aDados[3]+aDados[4]+SE2->(E2_FORNECE+E2_LOJA)
		If lTrava
			If !LockCmpCP(cChvSE2,lMsg)
				lRet := .F.
			Endif
		Else
			UnLockCmpCP(cChvSE2)
		Endif
	
	Else /* --> Abandono da tela de seleção: destravar todos os travados <-- */

		dbSelectArea("SE2")
		For nX := 1 to Len(aDados)

			If aDados[nX,8] // verifica se está selecionado para liberar registro
				SE2->(dbGoTo(aRecno[nX]))
				cChvSE2 := xFilial("SE2")+aDados[nX,1]+aDados[nX,2]+aDados[nX,3]+aDados[nX,4]+SE2->(E2_FORNECE+E2_LOJA)
				UnLockCmpCP(cChvSE2)
			Endif

		Next nX
			
	Endif


Else /* --> Estorno da compensação <-- */


	If !lCancel 	// Se estiver na tela de seleção dos titulos no estorno

	//***********************************************************************************************************//		
	// Pega chave do titulo selecionado no estorno/exclusao da Compensacao baseando-se no recno do mesmo no SE5  //
	//***********************************************************************************************************//
	
		If Empty(cChvSE2)
			SE5->(dbGoTo(nRecno))

			If !Empty(SE5->E5_FILORIG) .and. !Empty( xFilial( "SE2" ) )
				cChvSE2 := SE5->E5_FILORIG+SubStr( SE5->E5_DOCUMEN ,1,nTamTit+nTamTip )+SE5->(E5_FORNADT+E5_LOJAADT)
			Else
				cChvSE2 := xFilial("SE2")+SubStr( SE5->E5_DOCUMEN ,1,nTamTit+nTamTip )+SE5->(E5_FORNADT+E5_LOJAADT)
			Endif
		Endif
	
	//***********************************************************************************************************//		
	
		If lTrava
			If !LockCmpCP(cChvSE2,lMsg)
				lRet := .F.
			Endif
		Else
			UnLockCmpCP(cChvSE2)
		Endif

	Else  /* --> Abandono da tela de seleção no estorno: destravar todos os travados <-- */
	             
		dbSelectArea("SE5")
		For nX := 1 to Len(aDados)

			If aDados[nX,10] // verifica se está selecionado para liberar registro

				SE5->(dbGoTo(aRegs[nX]))
			
				If !Empty(SE5->E5_FILORIG) .and. !Empty( xFilial( "SE2" ) )
					cChvSE2 := SE5->E5_FILORIG+SubStr( SE5->E5_DOCUMEN ,1,nTamTit+nTamTip )+SE5->(E5_FORNADT+E5_LOJAADT)
				Else
					cChvSE2 := xFilial("SE2")+SubStr( SE5->E5_DOCUMEN ,1,nTamTit+nTamTip )+SE5->(E5_FORNADT+E5_LOJAADT)
				Endif					
				
				UnLockCmpCP(cChvSE2)
			Endif

		Next nX
		
	Endif
	
Endif

RestArea(aArea)
RestArea(aAreaSE2)

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fa340CSld ºAutor  ³Clovis Magenta	     º Data ³  23/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que valida o valor digitado para compensação na telaº±±
±±º          ³ de Mark. Validação necessária para integridade dos valores.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Fa340CSld(nRecnoSE2, nValor)

Local lGoodSld := .T.
Local aArea		:= GetArea()
Local aAreaSE2	:= SE2->(GetArea())

dbselectArea("SE2")
SE2->(dbGoTo(nRecnoSE2))

If SE2->E2_SALDO < nValor
	lGoodSld := .F.
	MsgAlert("Este título não possui mais o saldo que se apresenta. Possivelmente outro usuário manipulou este mesmo título. Favor verificar.","Saldo insuficiente!")
Endif

RestArea(aArea)
RestArea(aAreaSE2)

Return lGoodSld
