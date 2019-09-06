#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"

/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AS0002  ³ Autor ³ Fabiano da Silva              ³ Data ³ 29.10.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Liquidos (GPER020)                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gestão de Pessoal                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/

User Function AS0002()

Local oReport 

Private nPgQuant	:= 0
Private nPgValor	:= 0

If FindFunction("TRepInUse") .And. TRepInUse()

	Pergunte("GP020R",.F.)
   	oReport := AS002A()
   	oReport:PrintDialog()
Else
	AjustaSx1()
	U_AS002B()
EndIF    

Return




Static Function AS002A()

Local oReport 
Local oSection
Local oTransp

Local	cDesc		:=	"Relacao de Liquidos. Sera impresso de acordo com os parametros solicitados pelo usuario."
Local aOrd	  	:=	{"Filial+Bco/Ag.+Mat",;
			 			 "Filial+Bco/Ag.+Cc+Mat",;
						 "Filial+Bco/Ag.+Nome",;
						 "Filial+Bco/Ag.+Cta",;
						 "Filial+Bco/Ag.+Cc+Nome",;
						 "Bco/Ag.+Mat",;
						 "Bco/Ag.+Cc+Mat",;
						 "Bco/Ag.+Nome",;
						 "Bco/Ag.+Cta",;
						 "Bco/Ag.+Cc+Nome"}

	DEFINE REPORT oReport NAME "AS0002" TITLE OemToAnsi("RELAÇÄO DE LIQUIDOS") PARAMETER "GP020R" ACTION {|oReport| R020Imp(oReport)} DESCRIPTION cDesc TOTAL IN COLUMN PAGE TOTAL IN COLUMN

	DEFINE SECTION oSection OF oReport TABLES "SRA","TRB" ORDERS aOrd TOTAL IN COLUMN TITLE "Dados da relação bancária de líquidos"
		oSection:SetHeaderBreak(.T.)
		
			DEFINE CELL NAME "FILIAL" 		OF oSection ALIAS "TRB" TITLE "FILIAL" SIZE FWGETTAMFILIAL
			DEFINE CELL NAME "BANCO" 		OF oSection ALIAS "TRB" TITLE "BANCO" SIZE 3
			DEFINE CELL NAME "AGENCIA"		OF oSection ALIAS "TRB" TITLE "AGENCIA" SIZE 5
			DEFINE CELL NAME "CCUSTO"		OF oSection ALIAS "TRB" TITLE "CENTRO DE CUSTO" SIZE 9
			DEFINE CELL NAME "MAT" 			OF oSection ALIAS "TRB" TITLE "MATRICULA" SIZE 6
			DEFINE CELL NAME "NOME" 		OF oSection ALIAS "TRB" TITLE "NOME" SIZE 30
			DEFINE CELL NAME "CPF" 			OF oSection ALIAS "TRB" TITLE "CPF" SIZE 11
			DEFINE CELL NAME "CONTA" 		OF oSection ALIAS "TRB" TITLE "CONTA" SIZE 12
			DEFINE CELL NAME "TIPO"  	 	OF oSection ALIAS "TRB" TITLE "TIPO" SIZE 15
			DEFINE CELL NAME "FUNCBENEF" 	OF oSection ALIAS "TRB" TITLE "Func/Benef" SIZE 15
			DEFINE CELL NAME "VALOR" 		OF oSection ALIAS "TRB" TITLE "Valor" PICTURE "@E  99,999,999,999.99" SIZE 17
		
			TRPosition():New(oSection,"SRA",1,{|| TRB->FILIAL+TRB->MAT},.T.)


Return oReport


Static Function R020Imp(oReport)

Local oSection 	:= oReport:Section(1)    
Local oBreakCc
Local oBreakAg
Local oBreakBc
Local oBreakFil

//-- Array
Local aOrdBagRI	:= {}
Local aOrdBag    	:= {}
Local aValBenef  	:= {}
Local aCodFol     := {}          
Local aTam    		:= TAMSX3("RA_CC")

//-- String
Local cAliasRI	 	:= ""
Local cArqMovRI	:=	""
Local cArqMov 		:= ""
Local cAliasMov 	:= ""
Local cSitQuery	:= ""
Local cCatQuery	:= ""  
Local cFiltro		:= ""
Local cTitulo		:= ""
Local cCabec		:= ""   
Local cCabec2		:= "                                     |-------  F U N C I O N A R I O  -------|                                   "
Local cMesArqRef 	:= ""
Local cIndCond		:= ""
Local cFor			:= ""   
Local cOrdem		:= ""
Local cSRCExist		:= ""
Local cSRIExist		:= ""
Local cSRHExist		:= ""
Local cSR1Exist		:= ""
Local cSRGExist		:= ""
Local cExists		:= ""
Local cRCName
Local cRIName

//-- Numerico
Local nReg			:= 0   
Local nCntP			:= 0  
Local nOrdem		:= oSection:GetOrder()
Local nTPgQuant	:= 0
Local nTPgValor	:= 0
Local cAliasX		:= ""
Local nS			:= 0   

//-- Logicas
Local lDtItens		:= .F.

//-- Private Array
Private aInfo		:= {}

//-- Private String
Private cBcoUlt 	:= ""
Private cUltAg  	:= ""
Private cTitFil		:= ""
Private cTitCC		:= ""

//-- Variaveis de Acesso do Usuario                               
Private cAcessaSR1	:= &( " { || " + ChkRH( "AS0002" , "SR1" , "2" ) + " } " )
Private cAcessaSRA	:= &( " { || " + ChkRH( "AS0002" , "SRA" , "2" ) + " } " )
Private cAcessaSRC	:= &( " { || " + ChkRH( "AS0002" , "SRC" , "2" ) + " } " )
Private cAcessaSRG	:= &( " { || " + ChkRH( "AS0002" , "SRG" , "2" ) + " } " )
Private cAcessaSRH	:= &( " { || " + ChkRH( "AS0002" , "SRH" , "2" ) + " } " )
Private cAcessaSRI	:= &( " { || " + ChkRH( "AS0002" , "SRI" , "2" ) + " } " )
Private cAcessaSRR	:= &( " { || " + ChkRH( "AS0002" , "SRR" , "2" ) + " } " )
                                
//-- Private Logico
Private lImprBenef 

DbSelectArea("SRA")
DbSetOrder(1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Carrega parametros da pergunte                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lAdianta	:= If( mv_par01 == 1, .T., .F.)								  			// Adiantamento 
	lFolha		:= If( mv_par02 == 1, .T., .F.)								  			// Folha    
	lPrimeira	:= If( mv_par03 == 1, .T., .F.)								  			// 1¦Parc. 13§ Sal rio
	lSegunda	:= If( mv_par04 == 1, .T., .F.)								  			// 2¦Parc. 13§ Sal rio
	lFerias		:= If( mv_par05 == 1, .T., .F.)											// F‚rias
	lExtras		:= If( mv_par06 == 1, .T., .F.)											// Extras
	Semana		:= mv_par07     				 										// Numero da Semana
	ComConta	:= If( mv_par08 == 1, "C", ( If( mv_par08 == 2, "S", "A")))	            // Qto. a Conta Corrente 
	cSituacao	:= mv_par15													 			// Situacao
	Quebloc		:= If( mv_par16 == 1, .T., .F.)						 					// Totalizar por Filial
	cSalta		:= If( mv_par17 == 1, "S", "N")											// Imprime Filial em Outra Pagina 
	LstNome		:= If( mv_par18 == 1, "S", "N")									 	    // Mostrar Nomes dos Funcionarios
	dDataDe		:= mv_par19																// Data Pagamento De
	dDataAte	:= mv_par20																// Data Pagamento Ate
	cSaltaAg	:= If( mv_par21 == 1, "S", "N")											// Quebra Pagina p/Agencia   Sim,Nao 
	cTotAgen	:= If( mv_par22 == 1, "S", "N")						 					// Totaliza por Agencia 
	cTipoRel	:= If( mv_par23 == 1, "A", "S")					  						// Tipo de Relacao:1-Analitica, 2-Sintetica 
	nFunBenAmb  := mv_par24  															// Imprimir : 1-Funcionarios  2-Beneficiarias  3-Ambos
	cCategoria	:= mv_par25 												  			// Categorias
	lRescisao   := If( mv_par26 == 1, .T., .F.)						  					// Rescisao
	dDtRef    	:= If(Empty(mv_par27), dDataBase, mv_par27)		  			   	        // Data de referencia 
	cBanco    	:= mv_par11 														    // Banco
	cConta 		:= mv_par14 														    // Conta

	cMesArqRef 	:= StrZero(Month(dDtRef),2) + StrZero(Year(dDtRef),4) 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Quebra de pagina                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//------------------------------------------------------------
	//-- Totalizadores de Pagina e Transportado da Pagina Anterior
	//------------------------------------------------------------

	 If cTipoRel = "A"
		//-- Total de Pagina                                       
		DEFINE FUNCTION NAME "PAGQUANT" FROM oSection:Cell("CONTA") 	FUNCTION COUNT PRINT WHEN {|| oSection:GetFunction("PAGQUANT"):PageValue() > 0 } NO END SECTION NO END REPORT END PAGE
		DEFINE FUNCTION NAME "PAGVALOR" FROM oSection:Cell("VALOR")		FUNCTION SUM PRINT WHEN {|| oSection:GetFunction("PAGVALOR"):PageValue() > 0 } PICTURE "@E  99,999,999,999.99" NO END SECTION NO END REPORT END PAGE
	EndIf

	//-- Total Centro de Custo
	If (nOrdem = 2 .or. nOrdem = 5 .or. nOrdem = 7 .or. nOrdem = 10)
		oBreakCc 	:= TRBreak():New(oSection, oSection:Cell("CCUSTO"),{|| "TOTAL DO C.CUSTO  " + fDescTot(3)}, .F.)
		TRFunction():New(oSection:Cell("CONTA"),,"COUNT",oBreakCc,"Quantidade",,,.F.,.F.,.F.)
		TRFunction():New(oSection:Cell("VALOR"),,"SUM",oBreakCc,,,,.F.,.F.,.F.)
	EndIf

	//-- Total Agencia
	//-- Verifica se deseja totalizar por Agencia
	If cTotAgen == "S"
		oBreakAg 	:= TRBreak():New(oSection, oSection:Cell("AGENCIA"), {|| "TOTAL  AGENCIA  " + fDescTot(1)},.F.)
		TRFunction():New(oSection:Cell("CONTA"),,"COUNT",oBreakAg,"Quantidade",,,.F.,.F.,.F.)
		TRFunction():New(oSection:Cell("VALOR"),,"SUM",oBreakAg,,,,.F.,.F.,.F.)

		If cSaltaAg == "S"
			oBreakAg:SetPageBreak(.T.)
		EndIf
	EndIf
	
	//-- Total Banco
	oBreakBc 	:= TRBreak():New(oSection, oSection:Cell("BANCO"), {|| "TOTAL DO BANCO  " + fDescTot(2)},.F.)
	TRFunction():New(oSection:Cell("CONTA"),,"COUNT",oBreakBc,"Quantidade",,,.F.,.T.,.F.)
	TRFunction():New(oSection:Cell("VALOR"),,"SUM",oBreakBc,,,,.F.,.T.,.F.)
	If cSaltaAg == "S"
		oBreakBc:SetPageBreak(.T.)
	EndIf
                
	//-- Total Filial
	//-- Verifica se deseja totalizar por Filial
	If Quebloc .and. (nOrdem <= 5)
		oBreakFil 	:= TRBreak():New(oSection, oSection:Cell("FILIAL"), {|| "TOTAL DA FILIAL " + fDescTot(4)}, .F.)
		TRFunction():New(oSection:Cell("CONTA"),,"COUNT",oBreakFil,"Quantidade",,,.F.,.F.,.F.)
		TRFunction():New(oSection:Cell("VALOR"),,"SUM",oBreakFil,,,,.F.,.F.,.F.)
		
		If cSalta == "S"
			oBreakFil:SetPageBreak(.T.)
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Altera o Titulo do Relatorio conforme os parametros selecionados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do Case
		Case lAdianta
			cTitulo := "RELACAO DE LIQUIDOS DO ADIANTAMENTO"
		Case lFolha       
			cTitulo := "RELACAO DE LIQUIDOS DA FOLHA"
		Case lPrimeira     
			cTitulo := "RELACAO DE LIQUIDOS DA 1a PARCELA DO 13o SALARIO  "
		Case lSegunda      
			cTitulo := "RELACAO DE LIQUIDOS DA 2a PARCELA DO 13o SALARIO  "
		Case lFerias      
			cTitulo := "RELACAO DE LIQUIDOS DAS FERIAS  "
		Case lExtras      
			cTitulo := "RELACAO DE LIQUIDOS DE VAL.EXTRAS "
		OtherWise
		   cTitulo := ""
	EndCase
	                        
	//-- Pega descricao da semana                                    ³
	cCabec := If( Semana # Space(2), fRetPer( Semana, dDtRef ), " " )

	cTitulo += If(!Empty(cCabec), " - " + cCabec ,"" ) + If(cTipoRel = "A", "Analitica" , "Sintetica" )  + " / " + Upper(MesExtenso(Month(dDtRef)))+" de "+STR(YEAR(dDtRef),4)
	If !(AllTrim(oReport:Title())==AllTrim("RELAÇÄO DE LIQUIDOS"))
		cTitulo	:= oReport:Title()
	Endif
   
	//-- Altera o titulo do relatorio
	oReport:SetTitle(cTitulo)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define se devera ser impresso Funcionarios ou Beneficiarios  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "SRQ" )
	lImprFunci  := ( nFunBenAmb # 2 )
	lImprBenef  := ( nFunBenAmb # 1 .And. FieldPos( "RQ_BCDEPBE" ) # 0 .And. FieldPos( "RQ_CTDEPBE" ) # 0 )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Informa a nao existencia dos campos de bco/age/conta corrente³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nFunBenAmb # 1 .And. !lImprBenef
		fAvisoBC()
		Return .F.
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Muda cabecalho se impressao sintetico ou impressao de beneficiarios ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cTipoRel == "S"
		cCabec2 := ""
	Else
		If lImprBenef
			If nFunBenAmb == 2
				cCabec2 := "                                     -------  B E N E F I C I A R I O  -------                                   "
			Else
				cCabec2 := "                         -------  F U N C I O N A R I O / B E N E F I C I A R I O  -------                       "
			EndIf
		EndIf
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre o SRI                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lSegunda
		If !OpenSrc( "13"+Substr(cMesArqRef,3,4), @cAliasRI, @aOrdBagRI, @cArqMovRI, dDtRef,.F., .F. )
			Return .f.
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre o SRC                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !OpenSrc( cMesArqRef, @cAliasMov, @aOrdBag, @cArqMov, dDtRef )
		Return .f.
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca os valores de Liquido e beneficios                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFDEF TOP
		cRCName := If( Empty(cAliasMov)	, retSqlName("SRC"), cArqMov	)
		cRIName := If( Empty(cAliasRI)	, retSqlName("SRI"), cArqMovRI)
	#ELSE
		cRCName := If( Empty(cAliasMov)	, Nil , cArqMov	)
		cRIName := If( Empty(cAliasRI)	, Nil , cArqMovRI)	
	#ENDIF
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz filtro no arquivo...                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lFerias .and. ("F" $ cSituacao .and. !("A"$cSituacao) )
		cSituacao += "A"
	EndIf    
	
	#IFDEF TOP
	
		//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
		MakeSqlExpr("GP020R")

		//Neste caso foi utilizado o alias fixo com o mesmo nome da tabela (e nao GetNextAlias, conforme o 
		// padrao de programacao), pois neste relatorio existe chamadas para outras funcoes e essas funcoes 
		//utilizam sempre "SRA".
		cAliasX := "SRA"
		//-- Modifica variaveis para a Query
		For nReg:=1 to Len(cSituacao)
			cSitQuery += "'"+Subs(cSituacao,nReg,1)+"'"
			If ( nReg+1 ) <= Len(cSituacao)
				cSitQuery += "," 
			Endif
		Next nReg     
		cSitQuery := "%" + cSitQuery + "%"
		
		cCatQuery := ""
		For nReg:=1 to Len(cCategoria)
			cCatQuery += "'"+Subs(cCategoria,nReg,1)+"'"
			If ( nReg+1 ) <= Len(cCategoria)
				cCatQuery += "," 
			Endif
		Next nReg
		cCatQuery := "%" + cCatQuery + "%"
		
		If lFerias
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica existencia do campo RH_DTITENS                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea( "SRH" )
			lDtItens := SRH->(FieldPos( "RH_DTITENS" )) # 0
		EndIf		
	
		If lAdianta .Or. lFolha .Or. ( lPrimeira .And. !(cPaisLoc $ "URU|ARG") )
			cSRCExist += "EXISTS ( SELECT RC_FILIAL, RC_MAT, RC_PD, RC_VALOR, RC_DATA "
			cSRCExist += "FROM " + cRcName + " QSRC "
			cSRCExist += "WHERE RC_FILIAL = SRA.RA_FILIAL "
			cSRCExist += "AND RC_MAT = SRA.RA_MAT "
			cSRCExist += "AND RC_DATA BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "

			If lAdianta .Or. lPrimeira
				cSRCExist += "AND RC_SEMANA	= '" + Semana + "' "
			EndIf
			
			cSRCExist += "AND QSRC.D_E_L_E_T_= ' ' ) "
		EndIf
		
		If lSegunda .or. If(cPaisLoc $ "URU|ARG",lPrimeira,.F.)
			If !Empty(cSRCExist)
				cSRIExist += "OR "
			EndIf
			
			cSRIExist += "EXISTS ( SELECT RI_FILIAL, RI_MAT, RI_PD, RI_VALOR, RI_DATA "
			cSRIExist += "FROM " + cRiName + " QSRI "
			cSRIExist += "WHERE RI_FILIAL = SRA.RA_FILIAL "
			cSRIExist += "AND RI_MAT = SRA.RA_MAT "
			cSRIExist += "AND RI_DATA BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
			cSRIExist += "AND QSRI.D_E_L_E_T_= ' ' ) "
		EndIf		
		
		If lFerias
			
			fDtItens(.T.) //Retirar em futuras versoes - P/release 4 enviar como .T.,pois neste caso nao temos as 
			                                             // as variaves cFilDe\cFilAte e cMatDe\cMatAte

			If !Empty(cSRCExist) .Or. !Empty(cSRIExist)
				cSRHExist += "OR "
			EndIf
			
			cSRHExist += "EXISTS ( SELECT SRR1.RR_FILIAL, SRR1.RR_MAT, SRR1.RR_PD, SRR1.RR_VALOR, SRR1.RR_DATA, QSRH.RH_DTRECIB "
			cSRHExist += "FROM "+ RetSqlName("SRR") + " SRR1 "
			cSRHExist += "INNER JOIN "+ RetSqlName("SRH") + " QSRH "
			cSRHExist += "ON ( SRR1.RR_FILIAL = RH_FILIAL "
			cSRHExist += "AND SRR1.RR_MAT = RH_MAT "
			
			If lDtItens
				cSRHExist 		+= "AND SRR1.RR_DATA = RH_DTITENS "
			Else
				cSRHExist 		+= "AND SRR1.RR_DATA = RH_DTRECIB "
			EndIf
			
			cSRHExist += "AND SRR1.D_E_L_E_T_ = QSRH.D_E_L_E_T_) "
			cSRHExist += "WHERE RH_FILIAL = SRA.RA_FILIAL "
			cSRHExist += "AND RH_MAT = SRA.RA_MAT "
			cSRHExist += "AND RH_DTRECIB BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
			cSRHExist += "AND QSRH.D_E_L_E_T_= ' ' )  "
		EndIf
		
		If lExtras
			If !Empty(cSRCExist) .Or. !Empty(cSRIExist) .Or. !Empty(cSRHExist)
				cSR1Exist += "OR "
			EndIf
			
			cSR1Exist += "EXISTS ( SELECT R1_FILIAL, R1_MAT, R1_PD, R1_VALOR, R1_DATA "
			cSR1Exist += "FROM " + RetSqlName("SR1") + " QSR1 "
			cSR1Exist += "WHERE R1_FILIAL = SRA.RA_FILIAL "
			cSR1Exist += "AND R1_MAT = SRA.RA_MAT "
			cSR1Exist += "AND R1_DATA BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
			cSR1Exist += "AND R1_SEMANA	= '" + Semana + "' "
			cSR1Exist += "AND QSR1.D_E_L_E_T_= ' ' )  "
		EndIf
		
		If lRescisao
			If !Empty(cSRCExist) .Or. !Empty(cSRIExist) .Or. !Empty(cSRHExist) .Or. !Empty(cSR1Exist)
				cSRGExist += "OR "
			EndIf
			
			cSRGExist += "EXISTS ( SELECT SRR2.RR_FILIAL, SRR2.RR_MAT, SRR2.RR_PD, SRR2.RR_VALOR, SRR2.RR_DATA, RG_DATAHOM "
			cSRGExist += "FROM "+ RetSqlName("SRR") + " SRR2 "
			cSRGExist += "INNER JOIN "+ RetSqlName("SRG") + " QSRG "
			cSRGExist += "ON ( SRR2.RR_FILIAL = RG_FILIAL "
			cSRGExist += "AND SRR2.RR_MAT = RG_MAT "
			cSRGExist += "AND SRR2.RR_DATAPAG = RG_DATAHOM "
			cSRGExist += "AND SRR2.D_E_L_E_T_ = QSRG.D_E_L_E_T_) "
			cSRGExist += "WHERE RG_FILIAL = SRA.RA_FILIAL "
			cSRGExist += "AND RG_MAT = SRA.RA_MAT "
			cSRGExist += "AND RG_DATAHOM BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
			cSRGExist += "AND QSRG.D_E_L_E_T_= ' ' )  "
		EndIf
		
		If !Empty(cSRCExist) .Or. !Empty(cSRIExist) .Or. !Empty(cSRHExist) .Or. !Empty(cSR1Exist) .Or. !Empty(cSRGExist)
			cExists := "(" + cSRCExist + cSRIExist + cSRHExist + cSR1Exist + cSRGExist +")" 
			//cExists := cSRCExist + cSRIExist + cSRHExist + cSR1Exist + cSRGExist 
		EndIf
		
		cExists := "%" + cExists + "%"

		If nOrdem == 1
			cOrdem += "%SRA.RA_FILIAL, SRA.RA_BCDEPSA,SRA.RA_MAT%"
			cIndTRB	:= "FILIAL + BANCO + AGENCIA + MAT"
		ElseIf nOrdem == 2
			cOrdem += "%SRA.RA_FILIAL, SRA.RA_BCDEPSA, SRA.RA_CC, SRA.RA_MAT%"
			cIndTRB	:= "FILIAL + BANCO + AGENCIA + CCUSTO + MAT"
		ElseIf nOrdem == 3
			cOrdem += "%SRA.RA_FILIAL, SRA.RA_BCDEPSA, SRA.RA_NOME%"
			cIndTRB	:= "FILIAL + BANCO + AGENCIA + NOME"
		Elseif nOrdem == 4
			cOrdem += "%SRA.RA_FILIAl, SRA.RA_BCDEPSA, SRA.RA_CTDEPSA%"
			cIndTRB	:= "FILIAL + BANCO + AGENCIA + CONTA"
		ElseIf nOrdem == 5
			cOrdem += "%SRA.RA_FILIAL, SRA.RA_BCDEPSA, SRA.RA_CC, SRA.RA_NOME%"
			cIndTRB	:= "FILIAL + BANCO + AGENCIA + CCUSTO + NOME"
		ElseIf nOrdem == 6
			cOrdem += "%SRA.RA_BCDEPSA, SRA.RA_MAT%"
			cIndTRB	:= "BANCO + AGENCIA + MAT"
		ElseIf nOrdem == 7
			cOrdem += "%SRA.RA_BCDEPSA, SRA.RA_CC, SRA.RA_MAT%"
			cIndTRB	:= "BANCO + AGENCIA + CCUSTO + MAT"
		Elseif nOrdem == 8
			cOrdem += "%SRA.RA_BCDEPSA, SRA.RA_NOME%"
			cIndTRB	:= "BANCO + AGENCIA + NOME"
		ElseIf nOrdem == 9
			cOrdem += "%SRA.RA_BCDEPSA, SRA.RA_CTDEPSA%"
			cIndTRB	:= "BANCO + AGENCIA + CONTA"
		ElseIf nOrdem == 10
			cOrdem += "%SRA.RA_BCDEPSA, SRA.RA_CC, SRA.RA_NOME%"
			cIndTRB	:= "BANCO + AGENCIA + CCUSTO + NOME"
		Endif

		//-- Adiciona no filtro o parametro tipo Range
		//-- Filial
		If !Empty(mv_par09)
			cFiltro += mv_par09 
		EndIf
		
		//-- Centro de Custo
		If !Empty(mv_par10)
			cFiltro += Iif(!Empty(cFiltro)," AND ","")
			cFiltro += mv_par10 
		EndIf

		//-- Matricula
		If !Empty(mv_par12)    
			cFiltro += Iif(!Empty(cFiltro)," AND ","")
			cFiltro += mv_par12
		EndIf

		//-- Nome
		If !Empty(mv_par13)   
			cFiltro += Iif(!Empty(cFiltro)," AND ","")
			cFiltro += mv_par13 
		EndIf

		cFiltro:= If(Empty(cFiltro),"%%","%AND "+cFiltro+"%") 

		//NAO RETIRAR ESTA LINHA
		//Este relatório abre a query abaixo com o nome de "SRA" e
		//como a tabela "SRA" eh utilizada em vários outros programas,
		//foi preciso fechar primeiro a area para depois poder utiliza-la.
        SRA->( dbCloseArea() )
			
		BeginSql alias cAliasX
			SELECT SRA.*
			FROM %table:SRA% SRA
			WHERE SRA.%notDel% 
				   %Exp:cFiltro% AND				   
		  		   SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%) AND
				   SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%) AND
  				   %Exp:cExists%  
			ORDER BY %exp:cOrdem%
		EndSql
	
		/*
		Prepara relatorio para executar a query gerada pelo Embedded SQL passando como 
		parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados 
		pela funcao MakeSqlExpr para serem adicionados a query. 	*/

		END REPORT QUERY oSection 
	
		TcSetField(cAliasX,"RA_DEMISSA","D",8,0)
	
	#ELSE             
                                
		cAliasX := "SRA"
		//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
		MakeAdvplExpr("GP020R")
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica a ordem selecionada                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nOrdem == 1
			cIndCond:= "RA_FILIAL + RA_BCDEPSA + RA_MAT"
			cIndTRB	:= "FILIAL + BANCO + AGENCIA + MAT"
		ElseIf nOrdem == 2
			cIndCond:= "RA_FILIAL + RA_BCDEPSA + RA_CC + RA_MAT"
			cIndTRB	:= "FILIAL + BANCO + AGENCIA + CCUSTO + MAT"
		ElseIf nOrdem == 3
			cIndCond:= "RA_FILIAL + RA_BCDEPSA + RA_NOME"
			cIndTRB	:= "FILIAL + BANCO + AGENCIA + NOME"
		Elseif nOrdem == 4
			cIndCond:= "RA_FILIAL + RA_BCDEPSA + RA_CTDEPSA"
			cIndTRB	:= "FILIAL + BANCO + AGENCIA + CONTA"
		ElseIf nOrdem == 5
			cIndCond:= "RA_FILIAL + RA_BCDEPSA + RA_CC + RA_NOME"
			cIndTRB	:= "FILIAL + BANCO + AGENCIA + CCUSTO + NOME"
		ElseIf nOrdem == 6
			cIndCond:= "RA_BCDEPSA + RA_MAT"
			cIndTRB	:= "BANCO + AGENCIA + MAT"
		ElseIf nOrdem == 7
			cIndCond:= "RA_BCDEPSA + RA_CC + RA_Mat"
			cIndTRB	:= "BANCO + AGENCIA + CCUSTO + MAT"
		Elseif nOrdem == 8
			cIndCond:= "RA_BCDEPSA + RA_NOME"
			cIndTRB	:= "BANCO + AGENCIA + NOME"
		ElseIf nOrdem == 9
			cIndCond:= "RA_BCDEPSA + RA_CTDEPSA"
			cIndTRB	:= "BANCO + AGENCIA + CONTA"
		ElseIf nOrdem == 10
			cIndCond:= "RA_BCDEPSA + RA_CC + RA_NOME"
			cIndTRB	:= "BANCO + AGENCIA + CCUSTO + NOME"
		Endif
		
		//cArqNtx  := CriaTrab(NIL,.F.) 
		//IndRegua("SRA",cArqNtx,cIndCond,,,"Selecionando Registros...")
		(cAliasX)->( DbGoTop() )

		//-- Adiciona no filtro o parametro tipo Range
		//-- Filial
		If !Empty(mv_par09)
			cFiltro += mv_par09 
		EndIf
		
		//-- Centro de Custo
		If !Empty(mv_par10)
			cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
			cFiltro += mv_par10 
		EndIf

		//-- Matricula
		If !Empty(mv_par12)    
			cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
			cFiltro += mv_par12
		EndIf

		//-- Nome
		If !Empty(mv_par13)   
			cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
			cFiltro += mv_par13 
		EndIf

		If !Empty(cSituacao)
			cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
			cFiltro += '(SRA->RA_SITFOLH  $ "' + cSituacao  + '")'
		EndIf
		
		IF !Empty(cCategoria)
			cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
			cFiltro += '(SRA->RA_CATFUNC  $ "' + cCategoria + '") '
		EndIf
		
	  	oSection:SetFilter(cFiltro, cIndCond, , "SRA") 
	#ENDIF	
	
	// Temporario para armazenar os dados para a impressao
	aCampos := {{  "FILIAL" 	,"C"	,002	,0 	} ,;	// FILIAL DA EMPRESA DO FUNCIONARIO
	             { "BANCO"  	,"C"	,003	,0 	} ,;	// codigo do Banco
	             { "AGENCIA"	,"C"	,005	,0 	} ,;	// codigo da agencia
	             { "CCUSTO" 	,"C"	,aTam[1],0 	} ,;	// codigo do centro de custo
	             { "MAT"    	,"C"	,006	,0  } ,;   	// codigo da matricula
	             { "NOME"  		,"C"	,040	,0 	} ,;	// nome
	             { "CPF"		,"C"	,011	,0 	} ,;  	// cpf 
	             { "CONTA" 		,"C"	,012	,0 	} ,;	// conta do funcionario/benef.
	             { "TIPO"		,"C"	,015	,0 	} ,;	// Tipo conta do funcionario/benef.
	             { "VALOR"		,"N"	,012	,2 	} ,;	// valor 
	             { "BENEF" 		,"C"	,001	,0 	} } 	// Beneficiario
	
	cArqTemp := CriaTrab(aCampos)
	dbUseArea(.T.,,cArqTemp,"TRB",.T.,.F.)	
	IndRegua("TRB",cArqTemp,cIndTRB,,,"Selecionando Registros...")
	oSection:SetFilter(".T.",cIndTRB,,"TRB")
	
	FilAnt := "!!"

	//-- Define o total da regua da tela de processamento do relatorio
	oReport:SetMeter((cAliasX)->( RecCount() ))  

	If cTipoRel = "A"
		oReport:OnPageBreak({|| oReport:SkipLine(),oReport:PrintText(cCabec2),oSection:GetFunction("PAGQUANT"):ResetReport(),oSection:GetFunction("PAGVALOR"):ResetReport() })
	Endif
				
	While (cAliasX)->( !EOF() )                   
                   
		//-- Incrementa a régua da tela de processamento do relatório
  		oReport:IncMeter()
                                
		//-- Verifica se o usuário cancelou a impressão do relatorio
		If oReport:Cancel()
			Exit
		EndIf               
		
		nValor    := 0
		aValBenef := {}

		If (cAliasX)->RA_FILIAL # FilAnt
			If !Fp_CodFol(@aCodFol,(cAliasX)->RA_FILIAL) .Or. !fInfo(@aInfo,(cAliasX)->RA_FILIAL)
				Exit
			Endif
			FilAnt := (cAliasX)->RA_FILIAL
		Endif
                            
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste controle de acessos e filiais validas               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !((cAliasX)->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
			// Incluir atualizacao TESTATOTAL
			(cAliasX)->( dbSkip() )
			Loop
		EndIf

		fBuscaLiq(@nValor,@aValBenef,aCodFol,,,dDtRef, cRCName, cRIName)
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de Entrada para despresar funcionario caso retorne .F. ³
		//³ Identico ao ponto de entrada GP450DES de geracao dos liquidos³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("GP020DES")
			If !(ExecBlock("GP020DES",.F.,.F.))
				dbSelectArea( "SRA" )
				SRA->(dbSkip())
				Loop
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste parametros de banco e conta do funcionario			  ³
		//³ Se nFunBenAmb=2, apenas sera testado a Bco e conta do Benefic³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nFunBenAmb # 2 	.and.  ;									//-- Se nao for Beneficiario, testa Bco e Conta do Funcionario 
		   (( ComConta = "C" .And. (cAliasX)->RA_CTDEPSA == SPACE(LEN((cAliasX)->RA_CTDEPSA)) .and. nFunBenAmb # 2) .Or.;
			 ( ComConta = "S" .And. (cAliasX)->RA_CTDEPSA #  SPACE(LEN((cAliasX)->RA_CTDEPSA)) .and. nFunBenAmb # 2))
			nValor := 0
		EndIf
		#IFDEF TOP
			mv_par11 := cBanco
			mv_par14 := cConta
			MakeAdvplExpr("GP020R")
		#ENDIF
	   //-- Valida o banco/agencia
	   If !Empty(mv_par11)
			If !(cAliasX)->(&(mv_par11))
				nValor := 0
			Endif
	   Endif
	   //-- Valida a conta corrente
	   If !Empty(mv_par14)
			If !(cAliasX)->(&(mv_par14))
				nValor := 0
			Endif
	   Endif
	   
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste parametros de banco e conta do beneficiario 	      ³
		//³ aValBenef: 1-Nome  2-Banco  3-Conta  4-Verba  5-Valor  6-CPF ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aValBenef) > 0 
			aBenefCop  := aClone(aValBenef) 
			aValBenef  := {} 
					
			If ( nFunBenAmb == 2 .or. nFunBenAmb == 3)   
                                   
				cParBanco := ""
				cParConta := ""
				                   
				cParBanco := StrTran(mv_par11, "RA_BCDEPSA","X[2]") 
				cParConta := StrTran(mv_par14, "RA_CTDEPSA","X[3]") 
				
				If ComConta="C" 					//-- Beneficiario e  com Conta, testo a Conta 
					If !Empty(cParBanco) .and. !Empty(cParConta)
						&('Aeval(aBenefCop, { |X| If(	( ' + cParBanco + ' ) .And. ( ' + cParConta + ' .and. !Empty(X[3]) ) , AADD(aValBenef,X ), "" ) })')
					ElseIf !Empty(cParBanco)
						&('Aeval(aBenefCop, { |X| If(	( ' + cParBanco + ' ) .And. ( !Empty(X[3]) ) , AADD(aValBenef,X ), "" ) })')
					ElseIf !Empty(cParConta)
						&('Aeval(aBenefCop, { |X| If(	( ' + cParConta + ' .and. !Empty(X[3]) ) , AADD(aValBenef,X ), "" ) })')
					ElseIf Empty(cParBanco) .and. Empty(cParConta)
						aValBenef	:= aClone(aBenefCop)
					EndIf
	        
				ElseIf ComConta="S"				//-- Se for beneficiario,  sem  Conta 
					If !Empty(cParBanco)
						&('Aeval(aBenefCop, { |X| If(	( ' + cParBanco + ' ) .And.  ( X[3] = Space( TamSX3("RQ_CTDEPBE")[1] )) , AADD(aValBenef,X ), ""  )  })')
					ElseIf Empty(cParBanco) .and. Empty(cParConta)
						aValBenef	:= aClone(aBenefCop)
					Else
						&('Aeval(aBenefCop, { |X| If(	( X[3] = Space( TamSX3("RQ_CTDEPBE")[1] )) , AADD(aValBenef,X ), ""  )  })')
					EndIf
					
				ElseIf ComConta = "A" 
					If !Empty(cParBanco) .and. !Empty(cParConta)
						&('Aeval(aBenefCop, { |X| If(	( 	( ' + cParBanco + ' ) .And. ( ' + cParConta + ' ) ) .or. ( 	( ' + cParBanco + ' ) .And.  ( X[3] = Space( TamSX3("RQ_CTDEPBE")[1] )) ), AADD(aValBenef,X ), ""  )  })')
					ElseIf !Empty(cParBanco)
						&('Aeval(aBenefCop, { |X| If(	( 	( ' + cParBanco + ' ) ) .or. ( 	( ' + cParBanco + ' ) .And.  ( X[3] = Space( TamSX3("RQ_CTDEPBE")[1] )) ), AADD(aValBenef,X ), ""  )  })')
					ElseIf !Empty(cParConta)
						&('Aeval(aBenefCop, { |X| If(	( 	( ' + cParConta + ' ) ) .or. ( 	( X[3] = Space( TamSX3("RQ_CTDEPBE")[1] )) ), AADD(aValBenef,X ), ""  )  })')
					ElseIf Empty(cParBanco) .and. Empty(cParConta)
						aValBenef	:= aClone(aBenefCop)
					EndIf
					
				EndIf 
			Endif	
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ 1- Testa Situacao do Funcionario na Folha					 ³
	   //³ 1- Testa Categoria do Funcionario na Folha					 ³
		//³ 2- Testa Com Conta											 ³
		//³ 3- Testa Sem Conta											 ³
		//³ 4- Testa se Valor == 0										 ³
		//³ 5- Testa se beneficiario e           		     			 ³	
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If	( nValor == 0 .And. Len(aValBenef) == 0 ) .or. ;
			( nFunBenAmb == 2 .And. Len(aValBenef) == 0) 
			(cAliasX)->( dbSkip() )
			Loop
		Endif
	
		nValBenef := 0

		_cTpCt := "123456789012345"//Space(15)
		/*
		If SRA->RA_YTPCTA == "1"
			_cTpCt := "Salario"
		ElseIf SRA->RA_YTPCTA == "2"
			_cTpCt := "Conta Corrente"
		ElseIf SRA->RA_YTPCTA == "3"
			_cTpCt := "Poupanca"
		Endif
              */
			                      
		// gravar no arquivo temporario
		If nValor > 0
			RecLock("TRB",.T.)    
    		TRB->FILIAL		:= SRA->RA_FILIAL				// FILIAL DA EMPRESA DO FUNCIONARIO
	    	TRB->BANCO		:= Substr(SRA->RA_BCDEPSA,1,3)	// codigo do Banco
	    	TRB->AGENCIA	:= Substr(SRA->RA_BCDEPSA,4,5)	// codigo da agencia
	    	TRB->CONTA		:= SRA->RA_CTDEPSA				// conta do funcionario/benef.
	    	TRB->CCUSTO		:= SRA->RA_CC					// codigo do centro de custo
	    	TRB->MAT		:= SRA->RA_MAT					// codigo da matricula
	    	TRB->NOME		:= SRA->RA_NOME					// nome
	    	TRB->CPF		:= SRA->RA_CIC					// cpf 
	    	TRB->TIPO		:= _cTpCt						// Tipo
	    	TRB->VALOR		:= nValor						// valor 
			MsUnLock()
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao dos Beneficiarios                          		 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nCntP := 1 To Len(aValBenef) 
			If !Empty(aValBenef[nCntP,1]) .And. aValBenef[nCntP,5] > 0 
					RecLock("TRB",.T.)    
				    	TRB->FILIAL		:= SRA->RA_FILIAL					// FILIAL DA EMPRESA DO FUNCIONARIO
					    TRB->BANCO		:= Substr(aValBenef[nCntP,2],1,3)	// codigo do Banco
					    TRB->AGENCIA	:= Substr(aValBenef[nCntP,2],4,5)	// codigo da agencia
					    TRB->CONTA		:= aValBenef[nCntP,3]				// conta do funcionario/benef.
					    TRB->CCUSTO	:= SRA->RA_CC						// codigo do centro de custo
					    TRB->MAT		:= SRA->RA_MAT						// codigo da matricula
					    TRB->NOME		:= SUBS(aValBenef[nCntP,1],1,30)	// nome
					    TRB->CPF		:= aValBenef[nCntP,6]				// cpf 
					    TRB->VALOR		:= aValBenef[nCntP,5]				// valor 
					    TRB->BENEF		:= "S"								// benef.
				    	TRB->TIPO		:= _cTpCt						// Tipo
					MsUnLock()
			Endif	
		Next nCntP
	
		dbSelectArea("SRA")
		(cAliasX)->( dbSkip() )	
	EndDo
	
	// Montagem do Loop a gravação do arquivo Temporario.
	#IFDEF TOP
		(cAliasX)->(DbCloseArea())
	#ENDIF
	dbSelectArea("SRA")
	SRA->( DbGoTop() )

	dbSelectArea("TRB")
	dbGotop()

	//-- Define o total da regua da tela de processamento do relatorio
	oReport:SetMeter(TRB->( RecCount() ))  
	
	//-- Incializa impressão   
	oSection:Init(.F.)                              
	                
	//Inicializacao das variaveis para impressao em cada quebra por totais.
	cUltAg 	:= TRB->AGENCIA
	cBcoUlt	:= TRB->BANCO
	cTitFil	:= TRB->FILIAL
	cTitCc	:= TRB->CCUSTO

	While !Eof() 

		//-- Incrementa a régua da tela de processamento do relatório
  		oReport:IncMeter()
                                
		//-- Verifica se o usuário cancelou a impressão do relatorio
		If oReport:Cancel()
			Exit
		EndIf               

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Alteracao do conteudo das colunas                    		  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//-- Verifica o conteudo que sera impresso na coluna nome conforme parametro.
		If LstNome <> "S"
			//-- Atualiza campo nome
			oSection:Cell("NOME"):SetValue("***  N o m e   Oculto   ***   ")
		EndIf

	   	oSection:Cell("FUNCBENEF"):SetValue(If(TRB->BENEF == "S", "Benef.", ""))

		If cTipoRel == "S"	// So Imprime Dados dos Funcionarios quando Relacao For Analitica.
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Habilita a impressao das colunas                      		  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			oSection:cell("FILIAL"):Hide()
			oSection:cell("BANCO"):Hide()
			oSection:cell("AGENCIA"):Hide()
			oSection:cell("CCUSTO"):Hide()
			oSection:cell("MAT"):Hide()
			oSection:cell("NOME"):Hide()
			oSection:cell("CPF"):Hide()
			oSection:cell("CONTA"):Hide()
			oSection:cell("TIPO"):Hide()
			oSection:cell("FUNCBENEF"):Hide()
			oSection:cell("VALOR"):Hide()
		EndIf			
		                    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime a linha                                        		  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		oSection:PrintLine()
		
		cUltAg 	:= TRB->AGENCIA
		cBcoUlt  := TRB->BANCO

		TRB->( dbSkip() )
	End

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza impressao inicializada pelo metodo Init             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection:Finish()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona arq. defaut do Siga caso Imp. Mov. Anteriores      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty( cAliasMov )
		fFimArqMov( cAliasMov , aOrdBag , cArqMov )
	EndIf
	
	If !Empty( cAliasRI )
		fFimArqMov( cAliasRI , aOrdBagRI , cArqMovRI )
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Eliminando o arquivo temporario.    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TRB")
	TRB->( dbCloseArea() )
	fErase( cArqTemp + OrdBagExt() )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Termino do relatorio                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "SRI" )
	dbSetOrder(1)
	#IFnDEF TOP 
		Set Filter to
		RetIndex("SRA")
		dbSetOrder(1)	
		//fErase( cArqNtx + OrdBagExt() )
	#Else
		SRA->( dbCloseArea() ) 		//Fecha o SRA de uso da Query
	
		dbSelectArea("SRA")
		RetIndex("SRA")	
	#Endif	
	
Return NIL

/*
Desc.     ³Retorna a descricao do banco, agencia, centro de custos e   º±±
          ³filial para o total impresso nas quebas.                    º±±
*/

Static Function fDescTot(nTipo)

Local cRet	:= ""

If nTipo == 1	// Agencia
	cRet	:= cUltAg+ " " + DescBco(TRB->(cBcoUlt+cUltAg),cTitFil,40,.T.)
	cUltAg 	:= TRB->AGENCIA
ElseIf nTipo == 2	// Banco
	cRet	:= cBcoUlt  + " " + DescBco(cBcoUlt,cTitFil)
	cBcoUlt	:= TRB->BANCO
ElseIf nTipo == 3	// Centro de Custo
	cRet	:= cTitCc + " " + Left(fDesc("SI3",cTitCc,"SI3->I3_DESC",,cTitFil)  + Space(15),15)
	cTitCc	:= TRB->CCUSTO
ElseIf nTipo == 4	// Filial
	fInfo(@aInfo,cTitFil)
	cRet	:= cTitFil + " " + aInfo[1]
	cTitFil	:= TRB->FILIAL
Endif

Return(cRet)


User Function AS002B()

Local cSavCur1,cSavRow1,cSavCol1,cSavCor1,cSavScr1,cSavScr2,CbTxt // Ambiente
Local aRegs	   	:= {}
Local cString :="SRA"        // alias do arquivo principal (Base)
Local aOrd	  :=	{	"Filial+Bco/Ag.+Mat",;	//
			 			"Filial+Bco/Ag.+Cc+Mat",;	//
						"Filial+Bco/Ag.+Nome",;	//
						"Filial+Bco/Ag.+Cta",;	//
						"Filial+Bco/Ag.+Cc+Nome",;	//
						"Bco/Ag.+Mat",;	//
						"Bco/Ag.+Cc+Mat",;	//
						"Bco/Ag.+Nome",;	//
						"Bco/Ag.+Cta",;	//
						"Bco/Ag.+Cc+Nome"}	//
Local	cDesc1	:=		"Relacao de Liquidos."		//
Local	cDesc2	:=		"Ser  impresso de acordo com os parametros solicitados pelo"		//
Local	cDesc3	:=		"usuario."		//

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aCodigosAdt:={}
Local aHelpPor	:= {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
Private nomeprog:="AS0002"
Private aLinha  := { },nLastKey := 0
Private cPerg   :="GPR020"
Private nExtra, AgeAnt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
private Quebloc := Quebloc1 := .T.
Private cIndCond
Private cIndTRB	:= ""
Private cFor
Private nOrdem
Private aInfo:={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Titulo
Private AT_PRG  := "AS0002"
Private cCabec
Private wCabec0 := 3
Private wCabec1:="                                                                                                                     "
Private wCabec2:="                                     |-------  F U N C I O N A R I O  -------|                                   "
//Private wCabec3:=Stuff("FIL. BANCO      1234      MATRIC. NOME                            C.P.F.     C O N T A          V A L O R",At("C.P.F.","FIL. BANCO      1234                 MATRIC.  NOME                             C.P.F.        C O N T A           V A L O R"),6,PadR(RetTitle("RA_CIC"),6))
Private wCabec3:="FIL. BANCO      CCUSTO      MATRIC. NOME                             C.P.F.        C O N T A    TIPO                    V A L O R"
Private CONTFL:=1
Private LI:=0
Private nTamanho:="M"      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("GPR020",.F.)

cTit := "RELA€O DE LIQUIDOS"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="AS0002"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem		:= aReturn[8]
lAdianta	:= If(mv_par01 == 1,.T.,.F.)		// Adiantamento 
lFolha		:= If(mv_par02 == 1,.T.,.F.)		// Folha    
lPrimeira	:= If(mv_par03 == 1,.T.,.F.)		// 1¦Parc. 13§ Sal rio
lSegunda	:= If(mv_par04 == 1,.T.,.F.)		// 2¦Parc. 13§ Sal rio
lFerias		:= If(mv_par05 == 1,.T.,.F.)		// F‚rias
lExtras		:= If(mv_par06 == 1,.T.,.F.)		// Extras
lRescisao   := If(mv_par32 == 1,.T.,.F.)		// Rescisao
Semana		:= mv_par07     				 	// Numero da Semana
ComConta	:= If(mv_par08 == 1,"C",(If(mv_par08 == 2,"S","A")))	//  Qto. a Conta Corrente 
cFilDe		:= mv_par09							// Filial  De  
cFilAte		:= mv_par10							// Filial  Ate
CcDe		:= mv_par11							// Centro de Custo De
CcAte		:= mv_par12							// Centro de Custo Ate
BcoDe		:= mv_par13							// Banco /Agencia De
BcoAte		:= mv_par14							// Banco /Agencia Ate
cMatDe		:= mv_par15							// Matricula De 
cMatAte		:= mv_par16							// Matricula Ate
NomDe		:= mv_par17							// Nome De
NomAte		:= mv_par18							// Nome Ate
CtaDe		:= mv_par19							// Conta Corrente De
CtaAte		:= mv_par20							// Conta Corrente Ate
cSituacao	:= mv_par21							// Situacao
Quebloc		:= If(mv_par22 == 1,.T.,.F.)		// Totalizar por Filial
cSalta		:= If(mv_par23 == 1,"S","N")		// Imprime Filial em Outra Pagina 
LstNome		:= If(mv_par24 == 1,"S","N")		// Mostrar Nomes dos Funcionarios
dDataDe		:= mv_par25							// Data Pagamento De
dDataAte	:= mv_par26							// Data Pagamento Ate
cSaltaAg	:= If(mv_par27 == 1,"S","N")		// Quebra Pagina p/Agencia   Sim,Nao 
cTotAgen	:= If(mv_par28 == 1,"S","N")		// Totaliza por Agencia 
cTipoRel	:= If(mv_par29 == 1, "A" , "S" )	// Tipo de Relacao:1-Analitica, 2-Sintetica 
nFunBenAmb  := mv_par30  						// Imprimir : 1-Funcionarios  2-Beneficiarias  3-Ambos
cCategoria	:= mv_par31 						// Categorias
dDtRef    	:= If(empty(mv_par33), dDataBase,mv_par33)	// Data de referencia 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Pega descricao da semana                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCabec := If(Semana # Space(2),fRetPer( Semana,dDtRef )," ")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nao imprime Quando Relacao Sintetica.                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF cTipoRel == "S"
	wCabec2 := ""
EndIF	

If lAdianta
	Titulo := "RELACAO DE LIQUIDOS DO ADIANTAMENTO"
Elseif lFolha       
	Titulo := "RELACAO DE LIQUIDOS DA FOLHA"
Elseif lPrimeira     
	Titulo := "RELACAO DE LIQUIDOS DA 1a PARCELA DO 13o SALARIO  "
Elseif lSegunda      
	Titulo := "RELACAO DE LIQUIDOS DA 2a PARCELA DO 13o SALARIO  "
Elseif lFerias      
	Titulo := "RELACAO DE LIQUIDOS DAS FERIAS  "
Elseif lExtras      
	Titulo := "RELACAO DE LIQUIDOS DE VAL.EXTRAS "
Else 
   Titulo := ""
Endif

Titulo += " ("+StrZero( aReturn[8] , 2 )+")"+If(!Empty(cCabec)," - "+cCabec,"") + IF(cTipoRel="A"," ANALITICA "," SINTETICA ") + " / " + Upper(MesExtenso(Month(dDtRef)))+" de "+STR(YEAR(dDtRef),4)

If LastKey() = 27 .Or. nLastKey = 27
	Return
Endif

SetDefault(aReturn,cString)

If LastKey() = 27 .OR. nLastKey = 27
	Return
Endif

RptStatus({|lEnd| R020ImpR3(@lEnd,wnRel,cString)},cTit)  // Chamada do Relatorio

Return

*------------------------------------------*
Static Function R020ImpR3(lEnd,WnRel,cString)
*------------------------------------------*
Local nTotregs,nMult,nPosAnt,nPosAtu,nPosCnt,cSav20,cSav7 //Regua
Local tamanho:="P"
Local limite := 80
Local aOrdBag    := {}
Local aOrdBagRI	 := {}
Local aValBenef  := {}
Local aBenefCop  := {}
Local cArqMov := cAliasMov := ""
Local cArqMovRI	 :=	""
Local cAliasRI	 := ""
Local cMesArqRef := StrZero(Month(dDtRef),2) + StrZero(Year(dDtRef),4)
Local cFilter	:= aReturn[7]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Query                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cSQL 			:= ""
Local cCatQuery 	:= ""
Local cSitQuery 	:= ""
Local nS			:= 0
Local aStruSRA		:= {} 
Local lQuery		:= .F. 
Local cSRCExist 	:= ""
Local cSRIExist 	:= ""
Local cSRHExist 	:= ""
Local cSR1Exist 	:= ""
Local cSRGExist 	:= ""
Local cRCName
Local cRIName
Local lDtItens	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aCodigosAdt := {}
Local aCodFol     := {}
Local nCntP
Local aCampos	:= {}
Local aTam    	:= TAMSX3("RA_CC")


Private cPict1	:=	TM(99999999999,17,MsDecimais(1))// "@E  99,999,999,999.99"
Private cPict2	:=	TM(999999999999,18,MsDecimais(1))//"@E 999,999,999,999.99"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis de Acesso do Usuario                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cAcessaSR1	:= &( " { || " + ChkRH( "AS0002" , "SR1" , "2" ) + " } " )
If AllTrim(cFilter) != ""
	Private cAcessaSRA	:= &( " { || " + ChkRH( "AS0002" , "SRA" , "2" ) +  " .And. " + cFilter + " } " ) 
Else
	Private cAcessaSRA	:= &( " { || " + ChkRH( "AS0002" , "SRA" , "2" ) +  " } " ) 
Endif	
Private cAcessaSRC	:= &( " { || " + ChkRH( "AS0002" , "SRC" , "2" ) + " } " )
Private cAcessaSRG	:= &( " { || " + ChkRH( "AS0002" , "SRG" , "2" ) + " } " )
Private cAcessaSRH	:= &( " { || " + ChkRH( "AS0002" , "SRH" , "2" ) + " } " )
Private cAcessaSRI	:= &( " { || " + ChkRH( "AS0002" , "SRI" , "2" ) + " } " )
Private cAcessaSRR	:= &( " { || " + ChkRH( "AS0002" , "SRR" , "2" ) + " } " )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define se devera ser impresso Funcionarios ou Beneficiarios  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRQ" )
lImprFunci  := ( nFunBenAmb # 2 )
lImprBenef  := ( nFunBenAmb # 1 .And. FieldPos( "RQ_BCDEPBE" ) # 0 .And. FieldPos( "RQ_CTDEPBE" ) # 0 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Informa a nao existencia dos campos de bco/age/conta corrente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nFunBenAmb # 1 .And. !lImprBenef
	fAvisoBC()
	Return .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Muda cabecalho se impressao de beneficiarias                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lImprBenef
	If nFunBenAmb == 2
		wCabec2 := "                                     -------  B E N E F I C I A R I O  -------                                   "
	Else
		wCabec2 := "                         -------  F U N C I O N A R I O / B E N E F I C I A R I O  -------                       "
	EndIf
EndIF	

//-- Abre o SRI
If lSegunda
	If !OpenSrc( "13"+Substr(cMesArqRef,3,4), @cAliasRI, @aOrdBagRI, @cArqMovRI, dDtRef,.F., .F. )
		Return .f.
	EndIf
EndIf

//-- Abre o SRC
If !OpenSrc( cMesArqRef, @cAliasMov, @aOrdBag, @cArqMov, dDtRef )
	Return .f.
Endif

#IFDEF TOP
	cRCName := If( Empty(cAliasMov)	, retSqlName("SRC"), cArqMov	)
	cRIName := If( Empty(cAliasRI)	, retSqlName("SRI"), cArqMovRI)
#ELSE
	cRCName := If( Empty(cAliasMov)	, Nil , cArqMov	)
	cRIName := If( Empty(cAliasRI)	, Nil , cArqMovRI)	
#ENDIF
         
dbSelectArea("SRA")
If nOrdem == 1
	cIndCond:= "RA_FILIAL + RA_BCDEPSA + RA_MAT"
	cIndTRB	:= "FILIAL + BANCO + AGENCIA + MAT"
	cFor:= '(RA_FILIAL+RA_MAT >= "'+cFilDe+cMatDe+'")'
	cFor+= '.And. (RA_FILIAL+RA_MAT <= "'+cFilAte+cMatAte+'")'
ElseIf nOrdem == 2
	cIndCond:= "RA_FILIAL + RA_BCDEPSA + RA_CC + RA_MAT"
	cIndTRB	:= "FILIAL + BANCO + AGENCIA + CCUSTO + MAT"
	cFor:='(RA_FILIAL+RA_CC+RA_MAT >= "'+cFilDe+CcDe+cMatDe+'")'
	cFor+=' .And. (RA_FILIAL+RA_CC+RA_MAT <= "'+cFilAte+CcAte+cMatAte+'")'
ElseIf nOrdem == 3
	cIndCond:= "RA_FILIAL + RA_BCDEPSA + RA_NOME"
	cIndTRB	:= "FILIAL + BANCO + AGENCIA + NOME"
	cFor:='(RA_FILIAL+RA_NOME >= "'+cFilDe+NomDe+'")'
	cFor+=' .And. (RA_FILIAL+RA_NOME <= "'+cFilAte+NomAte+'")'
Elseif nOrdem == 4
	cIndCond:= "RA_FILIAl + RA_BCDEPSA + RA_CTDEPSA"
	cIndTRB	:= "FILIAL + BANCO + AGENCIA + CONTA"
	cFor:='(RA_FILIAL+RA_CTDEPSA >= "'+cFilDe+CtaDe+'")'
	cFor+=' .And. (RA_FILIAL+RA_CTDEPSA <= "'+cFilAte+CtaAte+'")'
ElseIf nOrdem == 5
	cIndCond:= "RA_FILIAL + RA_BCDEPSA + RA_CC + RA_NOME"
	cIndTRB	:= "FILIAL + BANCO + AGENCIA + CCUSTO + NOME"
	cFor:='(RA_FILIAL+RA_CC+RA_NOME >= "'+cFilDe+CcDe+NomDe+'")'
	cFor+=' .And. (RA_FILIAL+RA_CC+RA_NOME <= "'+cFilAte+CcAte+NomAte+'")'
ElseIf nOrdem == 6
	cIndCond:= "RA_BCDEPSA + RA_MAT"
	cIndTRB	:= "BANCO + AGENCIA + MAT"
	cFor:='(RA_MAT >= "'+cMatDe+'")'
	cFor+=' .And. (RA_MAT <= "'+cMatAte+'")'
ElseIf nOrdem == 7
	cIndCond:= "RA_BCDEPSA + RA_CC + RA_Mat"
	cIndTRB	:= "BANCO + AGENCIA + CCUSTO + MAT"
	cFor:='(RA_CC+RA_Mat >= "'+CcDe+cMatDe+'")'
	cFor+=' .And. (RA_CC+RA_Mat <= "'+CcAte+cMatAte+'")'
Elseif nOrdem == 8
	cIndCond:= "RA_BCDEPSA + RA_NOME"
	cIndTRB	:= "BANCO + AGENCIA + NOME"
	cFor:='(RA_NOME >= "'+NomDe+'")'
	cFor+=' .And. (RA_NOME <= "'+NomAte+'")'
ElseIf nOrdem == 9
	cIndCond:= "RA_BCDEPSA + RA_CTDEPSA"
	cIndTRB	:= "BANCO + AGENCIA + CONTA"
	cFor := ''
ElseIf nOrdem == 10
	cIndCond:= "RA_BCDEPSA + RA_CC + RA_NOME"
	cIndTRB	:= "BANCO + AGENCIA + CCUSTO + NOME"
	cFor:='(RA_CC+RA_NOME >= "'+CcDe+NomDe+'")'
	cFor+=' .And. (RA_CC+RA_NOME <= "'+CcAte+NomAte+'")'
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz filtro no arquivo...                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lFerias .and. ("F" $ cSituacao .and. !("A"$cSituacao) )
	cSituacao += "A"
EndIf    

#IFDEF TOP 
	lQuery	:= .T. 
	//-- Modifica variaveis para a Query
	For nS:=1 to Len(cSituacao)
		cSitQuery += "'"+Subs(cSituacao,nS,1)+"'"
		If ( nS+1) <= Len(cSituacao)
			cSitQuery += "," 
		Endif
	Next nS     
	
	cCatQuery := ""
	For nS:=1 to Len(cCategoria)
		cCatQuery += "'"+Subs(cCategoria,nS,1)+"'"
		If ( nS+1) <= Len(cCategoria)
			cCatQuery += "," 
		Endif
	Next nS
	
	If lFerias
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica existencia do campo RH_DTITENS                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea( "SRH" )
		lDtItens := SRH->(FieldPos( "RH_DTITENS" )) # 0
	EndIf	

	cSQL := "SELECT * "
	cSQL += "FROM " + RetSqlName("SRA") + " QSRA "
	cSQL += "WHERE RA_FILIAL	BETWEEN '" + cFilDe		+ "' AND '" + cFilAte	+ "' "
	cSQL += "AND RA_MAT			BETWEEN '" + cMatDe		+ "' AND '" + cMatAte	+ "' "
	cSQL += "AND RA_NOME		BETWEEN '" + NomDe		+ "' AND '" + NomAte	+ "' "
	cSQL += "AND RA_CC			BETWEEN '" + CcDe		+ "' AND '" + CcAte		+ "' "
 	
	If nFunBenAmb == 1
		cSQL += "AND RA_BCDEPSA	BETWEEN '" + BcoDe	+ "' AND '" + BcoAte	+ "' "
		cSQL += "AND RA_CTDEPSA	BETWEEN '" + CtaDe	+ "' AND '" + CtaAte	+ "' "
	EndIf
	
	cSQL += "AND RA_CATFUNC	IN (" + Upper(cCatQuery) + ") " 
	cSQL += "AND RA_SITFOLH	IN (" + Upper(cSitQuery) + ") " 

	If TcSrvType() != "AS/400"
		cSQL += "AND QSRA.D_E_L_E_T_ <> '*' "
	Else
		cSQL += "AND QSRA.@DELETED@  <> '*' "	
	Endif

	If lAdianta .Or. lFolha .Or. ( lPrimeira .And. !(cPaisLoc $ "URU|ARG") )
		cSRCExist += "EXISTS ( SELECT RC_FILIAL, RC_MAT, RC_PD, RC_VALOR, RC_DATA "
		cSRCExist += "FROM " + cRcName + " QSRC "
		cSRCExist += "WHERE QSRC.RC_FILIAL = QSRA.RA_FILIAL "
		cSRCExist += "AND QSRC.RC_MAT = QSRA.RA_MAT "
		cSRCExist += "AND QSRC.RC_DATA BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "

		If lAdianta .Or. lPrimeira
			cSRCExist += "AND QSRC.RC_SEMANA	= '" + Semana + "' "
		EndIf
		
		cSRCExist += "AND QSRC.D_E_L_E_T_= ' ' )  "
	EndIf
	
	If lSegunda .or. If(cPaisLoc $ "URU|ARG",lPrimeira,.F.)
		If !Empty(cSRCExist)
			cSRIExist += "OR "
		EndIf
		
		cSRIExist += "EXISTS ( SELECT RI_FILIAL, RI_MAT, RI_PD, RI_VALOR, RI_DATA "
		cSRIExist += "FROM " + cRiName + " QSRI "
		cSRIExist += "WHERE QSRI.RI_FILIAL = QSRA.RA_FILIAL "
		cSRIExist += "AND QSRI.RI_MAT = QSRA.RA_MAT "
		cSRIExist += "AND QSRI.RI_DATA BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
		cSRIExist += "AND QSRI.D_E_L_E_T_= ' ' )  "
	EndIf		
	
	If lFerias
		
		fDtItens(.F.) //Retirar em futuras versoes
		
		If !Empty(cSRCExist) .Or. !Empty(cSRIExist)
			cSRHExist += "OR "
		EndIf
		
		cSRHExist += "EXISTS ( SELECT SRR1.RR_FILIAL, SRR1.RR_MAT, SRR1.RR_PD, SRR1.RR_VALOR, SRR1.RR_DATA, QSRH.RH_DTRECIB "
		cSRHExist += "FROM "+ RetSqlName("SRR") + " SRR1 "
		cSRHExist += "INNER JOIN "+ RetSqlName("SRH") + " QSRH "
		cSRHExist += "ON ( SRR1.RR_FILIAL = QSRH.RH_FILIAL "
		cSRHExist += "AND SRR1.RR_MAT = QSRH.RH_MAT "
		
		If lDtItens
			cSRHExist 		+= "AND SRR1.RR_DATA = QSRH.RH_DTITENS "
		Else
			cSRHExist 		+= "AND SRR1.RR_DATA = QSRH.RH_DTRECIB "
		EndIf
		
		cSRHExist += "AND SRR1.D_E_L_E_T_ = QSRH.D_E_L_E_T_) "
		cSRHExist += "WHERE QSRH.RH_FILIAL = QSRA.RA_FILIAL "
		cSRHExist += "AND QSRH.RH_MAT = QSRA.RA_MAT "
		cSRHExist += "AND QSRH.RH_DTRECIB BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
		cSRHExist += "AND QSRH.D_E_L_E_T_= ' ' )  "
	EndIf
	
	If lExtras
		If !Empty(cSRCExist) .Or. !Empty(cSRIExist) .Or. !Empty(cSRHExist)
			cSR1Exist += "OR "
		EndIf
		
		cSR1Exist += "EXISTS ( SELECT R1_FILIAL, R1_MAT, R1_PD, R1_VALOR, R1_DATA "
		cSR1Exist += "FROM " + RetSqlName("SR1") + " QSR1 "
		cSR1Exist += "WHERE QSR1.R1_FILIAL = QSRA.RA_FILIAL "
		cSR1Exist += "AND QSR1.R1_MAT = QSRA.RA_MAT "
		cSR1Exist += "AND QSR1.R1_DATA BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
		cSR1Exist += "AND QSR1.R1_SEMANA	= '" + Semana + "' "
		cSR1Exist += "AND QSR1.D_E_L_E_T_= ' ' )  "
	EndIf

	If lRescisao
		If !Empty(cSRCExist) .Or. !Empty(cSRIExist) .Or. !Empty(cSRHExist) .Or. !Empty(cSR1Exist)
			cSRGExist += "OR "
		EndIf
		
		cSRGExist += "EXISTS ( SELECT SRR2.RR_FILIAL, SRR2.RR_MAT, SRR2.RR_PD, SRR2.RR_VALOR, SRR2.RR_DATA, QSRG.RG_DATAHOM "
		cSRGExist += "FROM "+ RetSqlName("SRR") + " SRR2 "
		cSRGExist += "INNER JOIN "+ RetSqlName("SRG") + " QSRG "
		cSRGExist += "ON ( SRR2.RR_FILIAL = QSRG.RG_FILIAL "
		cSRGExist += "AND SRR2.RR_MAT = QSRG.RG_MAT "
		cSRGExist += "AND SRR2.RR_DATAPAG = QSRG.RG_DATAHOM "
		cSRGExist += "AND SRR2.D_E_L_E_T_ = QSRG.D_E_L_E_T_) "
		cSRGExist += "WHERE QSRG.RG_FILIAL = QSRA.RA_FILIAL "
		cSRGExist += "AND QSRG.RG_MAT = QSRA.RA_MAT "
		cSRGExist += "AND QSRG.RG_DATAHOM BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
		cSRGExist += "AND QSRG.D_E_L_E_T_= ' ' )  "
	EndIf
	
	If !Empty(cSRCExist) .Or. !Empty(cSRIExist) .Or. !Empty(cSRHExist) .Or. !Empty(cSR1Exist) .Or. !Empty(cSRGExist)
		cSQL += "AND (" + cSRCExist + cSRIExist + cSRHExist + cSR1Exist + cSRGExist +")"
		//cSQL += "AND " + cSRCExist + cSRIExist + cSRHExist + cSR1Exist + cSRGExist 
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define order by de acordo com a ordem...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If nOrdem == 1
//		cSQL += " ORDER BY RA_FILIAL, RA_BCDEPSA,RA_MAT " 
		cSQL += "ORDER BY QSRA.RA_FILIAL, QSRA.RA_BCDEPSA,QSRA.RA_MAT "
	ElseIf nOrdem == 2
		cSQL += " ORDER BY QSRA.RA_FILIAL, QSRA.RA_BCDEPSA, QSRA.RA_CC, QSRA.RA_MAT "
	ElseIf nOrdem == 3
		cSQL += " ORDER BY QSRA.RA_FILIAL, QSRA.RA_BCDEPSA, QSRA.RA_NOME "
	Elseif nOrdem == 4
		cSQL += " ORDER BY QSRA.RA_FILIAL, QSRA.RA_BCDEPSA, QSRA.RA_CTDEPSA "
	ElseIf nOrdem == 5
		cSQL += " ORDER BY QSRA.RA_FILIAL, QSRA.RA_BCDEPSA, QSRA.RA_CC, QSRA.RA_NOME "
	ElseIf nOrdem == 6
		cSQL += " ORDER BY QSRA.RA_BCDEPSA, QSRA.RA_MAT "
	ElseIf nOrdem == 7
		cSQL += " ORDER BY QSRA.RA_BCDEPSA, QSRA.RA_CC, QSRA.RA_MAT "
	Elseif nOrdem == 8
		cSQL += " ORDER BY QSRA.RA_BCDEPSA, QSRA.RA_NOME "
	ElseIf nOrdem == 9
		cSQL += " ORDER BY QSRA.RA_BCDEPSA, QSRA.RA_CTDEPSA "
	ElseIf nOrdem == 10
		cSQL += " ORDER BY QSRA.RA_BCDEPSA, QSRA.RA_CC, QSRA.RA_NOME "
	Endif
	cSQL     	:= ChangeQuery(cSQL)
	aStruSRA 	:= SRA->(dbStruct())
	SRA->( dbCloseArea() ) //Fecha o SRA para uso da Query
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"SRA",.F.,.T.)
	For nS := 1 To Len(aStruSRA)
		If ( aStruSRA[nS][2] <> "C" )
			TcSetField("SRA",aStruSRA[nS][1],aStruSRA[nS][2],aStruSRA[nS][3],aStruSRA[nS][4])
		EndIf
	Next nS
#Else	

	cArqNtx  := CriaTrab(NIL,.F.) 
	IndRegua("SRA",cArqNtx,cIndCond,,cFor,"Selecionando Registros..." )
	DbGoTop()
#ENDIF

// Temporario para armazenar os dados para a impressao
aCampos := {{  "FILIAL" 	,"C"	,002	,0 	} ,;	// FILIAL DA EMPRESA DO FUNCIONARIO
             { "BANCO"  	,"C"	,003	,0 	} ,;	// codigo do Banco
             { "AGENCIA"	,"C"	,005	,0 	} ,;	// codigo da agencia
             { "CCUSTO" 	,"C"	,aTam[1],0 	} ,;	// codigo do centro de custo
             { "MAT"    	,"C"	,006	,0  } ,;   	// codigo da matricula
             { "NOME"  		,"C"	,040	,0 	} ,;	// nome
             { "CPF"		,"C"	,011	,0 	} ,;  	// cpf 
             { "TIPO" 		,"C"	,015	,0 	} ,;	// Tipo da conta do funcionario/benef.
             { "CONTA" 		,"C"	,012	,0 	} ,;	// conta do funcionario/benef.
             { "VALOR"		,"N"	,012	,2 	} ,;	// valor 
             { "BENEF" 		,"C"	,001	,0 	} } 	// Beneficiario

cArqTemp := CriaTrab(aCampos)
dbUseArea(.T.,,cArqTemp,"TRB",.T.,.F.)	
IndRegua("TRB",cArqTemp,cIndTRB,,,"Selecionando Registros..." )

FilAnt := "!!"
AgeAnt := Space(08)
BcoAnt := Space(03)
CcAnt  := Space(09)
CtaAnt := Space(12)
_cTpCt := Space(15)
NomAnt := Space(30)

tEmpresa := tPAGINA  := tFilial := tBanco  := tAgencia := tCc := 0
tFunEmp  := tFunPag  := tFunFil := TFunAge := tFunBan  := tFunTcc := 0
nTransval:= nTransFun:= nFlag := 0
cPula :=" "

dbSelectArea( "SRA" )
SetRegua(RecCount())   // Total de elementos da regua

While !EOF()
	IncRegua()  // Anda a regua

	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif
	
	nValor    := 0
	aValBenef := {}

	If SRA->RA_FILIAL # FilAnt
		If !Fp_CodFol(@aCodFol,SRA->RA_FILIAL) .Or. !fInfo(@aInfo,SRA->RA_FILIAL)
			Exit
		Endif
		FilAnt := SRA->RA_FILIAL
	Endif
	
	If !lQuery 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste Parametrizacao do Intervalo de Impressao            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (SRA->RA_NOME    < NomDe) .Or. (SRA->RA_NOME    > NomAte) .Or. ;
	 	   (SRA->RA_MAT     < cMatDe) .Or.(SRA->RA_MAT     > cMatAte) .Or. ;
		   (SRA->RA_FILIAL  < cFilDe) .Or. (SRA->RA_FILIAL> cFilAte) .Or. ;
		   (SRA->RA_CC      < CcDe ) .Or. (SRA->RA_CC      > CcAte )
       		dbSelectArea("SRA")
			SRA->(dbSkip())
		   	Loop
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste Filtro da setprint						             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ! Empty(cFilter) .And. ! &(cFilter)
			dbSelectArea("SRA")
			SRA->(dbSkip())
			Loop
		EndIf
    Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste controle de acessos e filiais validas               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
		dbSelectArea("SRA")
		SRA->(dbSkip())
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca os valores de Liquido e beneficios                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fBuscaLiq(@nValor,@aValBenef,aCodFol,,, dDtRef, cRCName, cRIName)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de Entrada para despresar funcionario caso retorne .F. ³
	//³ Identico ao ponto de entrada GP450DES de geracao dos liquidos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("GP020DES")
		If !(ExecBlock("GP020DES",.F.,.F.))
			dbSelectArea( "SRA" )
			SRA->(dbSkip())
			Loop
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste parametros de banco e conta do funcionario			 ³
	//³ Se nFunBenAmb=2, apenas sera testado a Bco e conta do Benefic³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nFunBenAmb # 2 	.and.  ;										//-- Se nao for Beneficiario, testa Bco e Conta do Funcionario 
	   ((SRA->RA_BCDEPSA < BcoDe) .Or. (SRA->RA_BCDEPSA > BcoAte) .Or. ;
	    ( ComConta ="C" .and. ( SRA->RA_CTDEPSA < CtaDe) .Or. (SRA->RA_CTDEPSA > CtaAte)  ) .Or.;
		( COMCONTA = "C" .And. SRA->RA_CTDEPSA == SPACE(LEN(SRA->RA_CTDEPSA)) .and. nFunBenAmb # 2) .Or.;
		( COMCONTA = "S" .And. SRA->RA_CTDEPSA #  SPACE(LEN(SRA->RA_CTDEPSA)) .and. nFunBenAmb # 2) )
		nValor := 0
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste parametros de banco e conta do beneficiario 		 ³
	//³ aValBenef: 1-Nome  2-Banco  3-Conta  4-Verba  5-Valor  6-CPF ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aValBenef) > 0 
		aBenefCop  := ACLONE(aValBenef) 
		aValBenef  := {} 
				
		If ( nFunBenAmb == 2 .or. nFunBenAmb == 3) 
			If ComConta="C" 					//-- Beneficiario e  com Conta, testo a Conta 
				Aeval(aBenefCop, { |X| If( ( X[2] >= BcoDe .And. X[2] <= BcoAte ) .And. ;
							           ( X[3] >= CtaDe .And. X[3] <= CtaAte .and.;
							            !Empty(X[3]) ) ,  ;        
						                AADD(aValBenef,X ), "" ) })                   
        
			ElseIf ComConta="S"				//-- Se for beneficiario,  sem  Conta 
				Aeval(aBenefCop, { |X| If(( X[2] >= BcoDe .And. X[2] <= BcoAte    ) .And.  ;
							           ( X[3] = Space( TamSX3("RQ_CTDEPBE")[1] )) ,;
										 AADD(aValBenef,X ), ""  )  })		
			ElseIf ComConta = "A" 
				Aeval(aBenefCop, { |X| If( ( ( X[2] >= BcoDe .And. X[2] <= BcoAte ) .And. ;
							             ( X[3] >= CtaDe .And. X[3] <= CtaAte  ) ) .or. ;
				                       ( ( X[2] >= BcoDe .And. X[2] <= BcoAte  ) .And.  ;
							              ( X[3] = Space( TamSX3("RQ_CTDEPBE")[1] )) ), ;
										 AADD(aValBenef,X ), ""  )  })
			EndIf 
		Endif	
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ 1- Testa Situacao do Funcionario na Folha					 ³
    //³ 1- Testa Categoria do Funcionario na Folha					 ³
	//³ 2- Testa Com Conta											 ³
	//³ 3- Testa Sem Conta											 ³
	//³ 4- Testa se Valor == 0										 ³
	//³ 5- Testa se beneficiario e               					 ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !( SRA->RA_SITFOLH $ cSituacao ) .Or. !(SRA->RA_CATFUNC $ cCategoria) .Or.;
		( nValor == 0 .And. Len(aValBenef) == 0 ) .or. ;
		( nFunBenAmb == 2 .And. Len(aValBenef) == 0) 
		dbSelectArea("SRA")
		SRA->(dbSkip())
		Loop
	Endif
	
	_cTpCt := "123456789012345"//Space(15)
	/*
	If SRA->RA_YTPCTA == "1"
		_cTpCt := "Salario"
	ElseIf SRA->RA_YTPCTA == "2"
		_cTpCt := "Conta Corrente"
	ElseIf SRA->RA_YTPCTA == "3"
		_cTpCt := "Poupanca"
	Endif
              */
    // gravar no arquivo temporario
	If nValor > 0
		RecLock("TRB",.T.)    
    	TRB->FILIAL		:= SRA->RA_FILIAL				// FILIAL DA EMPRESA DO FUNCIONARIO
	    TRB->BANCO		:= Substr(SRA->RA_BCDEPSA,1,3)	// codigo do Banco
	    TRB->AGENCIA	:= Substr(SRA->RA_BCDEPSA,4,5)	// codigo da agencia
	    TRB->CONTA		:= SRA->RA_CTDEPSA				// conta do funcionario/benef.
	    TRB->CCUSTO		:= SRA->RA_CC					// codigo do centro de custo
	    TRB->MAT		:= SRA->RA_MAT					// codigo da matricula
	    TRB->NOME		:= SRA->RA_NOME					// nome
	    TRB->CPF		:= SRA->RA_CIC					// cpf 
	    TRB->VALOR		:= nValor						// valor 
	    TRB->TIPO		:= _cTpCt						// Tipo
		MsUnLock()
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao dos Beneficiarios                          		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nCntP := 1 To Len(aValBenef) 
		If !Empty(aValBenef[nCntP,1]) .And. aValBenef[nCntP,5] > 0 
				RecLock("TRB",.T.)    
			    	TRB->FILIAL		:= SRA->RA_FILIAL					// FILIAL DA EMPRESA DO FUNCIONARIO
				    TRB->BANCO		:= Substr(aValBenef[nCntP,2],1,3)	// codigo do Banco
				    TRB->AGENCIA	:= Substr(aValBenef[nCntP,2],4,5)	// codigo da agencia
				    TRB->CONTA		:= aValBenef[nCntP,3]				// conta do funcionario/benef.
				    TRB->CCUSTO		:= SRA->RA_CC						// codigo do centro de custo
				    TRB->MAT		:= SRA->RA_MAT						// codigo da matricula
				    TRB->NOME		:= SUBS(aValBenef[nCntP,1],1,30)	// nome
				    TRB->CPF		:= aValBenef[nCntP,6]				// cpf 
				    TRB->VALOR		:= aValBenef[nCntP,5]				// valor 
				    TRB->BENEF		:= "S"								// benef.
				    TRB->TIPO		:= _cTpCt						// Tipo
				MsUnLock()
		Endif	
	Next nCntP

	dbSelectArea("SRA")
	SRA->(dbSkip())
EndDo


// Montagem do Loop a gravação do arquivo Temporario.
dbSelectArea("TRB")
dbGotop()
SetRegua(RecCount())   // Total de elementos da regua

While !Eof() 

	IncRegua()  // Anda a regua 
	
	If cPula == "S"				// Imprime quebra de Pagina quando
		Impr(" ","P")			// existe mais um funcionario a ser
		cPula := " "			// impresso.
	ElseIf cPula == "N"			// Imprime uma linha em branco apos
		If cSaltaAg =="S"		// os totais.
			IMPR("","C")    
		Endif
		cPula := " " 
	Endif               

	nContador := If(nValor > 0, 1, 0)
	nValBenef := 0
	IF cTipoRel == "A"	// So Imprime Dados dos Funcionarios quando Relacao For Analitica.
		
		If (Li + 3) >= 58
			Impr("","P")
		Endif

//		Det := TRB->FILIAL+"   "+TRB->BANCO+TRB->AGENCIA+"   "+SUBS(TRB->CCUSTO+SPACE(20),1,20)+"   "+TRB->MAT+"   "
		Det := TRB->FILIAL+"   "+TRB->BANCO+TRB->AGENCIA+"   "+SUBS(TRB->CCUSTO+SPACE(20),1,09)+"   "+TRB->MAT+"  "
		Det += Iif(lstnome="S",SUBS(TRB->NOME,1,30),"***  N o m e   Oculto   ***   ") +"   "+TRB->CPF+"   "		
		Det += TRB->CONTA+" "+TRB->TIPO+" "+Transform(TRB->VALOR,cPict1) + If(TRB->BENEF == "S", "-" + "Benef.", "") //## "Funcionario"
		IMPR(DET,"C")
	Endif	

	TfunPag   += 1              // Adicionando Funcionarios
	TfunFil   += 1        		// Aos Contadores
	TfunAge   += 1
	TfunBan   += 1
	TfunTcc   += 1
	TfunEmp   += 1
	
	Tpagina   += TRB->VALOR 	 // Adicionando Valor aos
	Tfilial   += TRB->VALOR		 // Acumuladores
	TAgencia  += TRB->VALOR
	Tbanco    += TRB->VALOR
	Tcc       += TRB->VALOR
	Tempresa  += TRB->VALOR
	
	If Li >= 53
		TotalPag()     // Quebra Pagina quando excede numero de linhas
		nFlag:=1
	Endif	
	TestaTotal()	
Enddo

If tFunEmp > 0
	TotalEmp()
	IMPR(" ","F")
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona arq. defaut do Siga caso Imp. Mov. Anteriores      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty( cAliasMov )
	fFimArqMov( cAliasMov , aOrdBag , cArqMov )
EndIf
If !Empty( cAliasRI )
	fFimArqMov( cAliasRI , aOrdBagRI , cArqMovRI )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Eliminando o arquivo temporario.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
TRB->( dbCloseArea() )
fErase( cArqTemp + OrdBagExt() )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRI" )
dbSetOrder(1)
#IFnDEF TOP 
	Set Filter to
	RetIndex("SRA")
	dbSetOrder(1)	
	fErase( cArqNtx + OrdBagExt() )
#Else
	SRA->( dbCloseArea() ) 		//Fecha o SRA de uso da Query

	dbSelectArea("SRA")
	RetIndex("SRA")	
#Endif	
Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()
Return

*-------------------------*
Static Function TestaTotal  // Teste para totalizacao
*-------------------------*
dbSelectArea ( "TRB" )
FilAnt := TRB->FILIAL    // Iguala Variaveis
AgeAnt := TRB->AGENCIA
BcoAnt := TRB->BANCO
CcAnt  := TRB->CCUSTO
NomAnt := TRB->NOME

TRB->( dbSkip() ) 
	
If (TRB->FILIAL # FilAnt .Or. Eof()) .And. (nOrdem <= 5) 
	TotalPag()
	TotalCc()
	If cTotAgen == "S"
		TotalAge()
	EndIf		
	TotalBan()	
	If Quebloc	
		TotalFil()
	Endif        

	IF cSALTA == "S" .And. !( TRB->(Eof()) )
		cPula :=  "S"
	ENDIF
	
Elseif (TRB->CCUSTO # CcAnt .Or. Eof()) .And. (nOrdem == 2 .Or. nOrdem == 5 .Or. nOrdem == 7 .Or. nOrdem == 10 )
	TotalPag()
	TotalCc()
	If cTotAgen == "S"
		TotalAge()		
    EndIf		
	If TRB->BANCO # BcoAnt
		TotalBan()	
	Endif		
	cPula :=  "S"
ElseIf (TRB->BANCO # BcoAnt .Or. Eof())
	TotalPag()
	TotalCc()
	If cTotAgen == "S"
		TotalAge()
    EndIf 
	TotalBan()
	cPula	:=	Iif(cPula=="S",cPula,cSaltaAg)  // -- "S" OU "N" 
ElseIf (TRB->AGENCIA # AgeAnt  ) .Or. Eof() 
	
	If cSaltaAg == "S"
		TotalPag() 
		TotalCc()      
		If cTotAgen == "S" 
			TotalAge() 	
		Endif
	Else
		If cTotAgen == "S" 
			TotalPag() 
			TotalCc()      
			TotalAge() 	
		Endif
	Endif 
	cPula	:=	Iif(cPula=="S",cPula,cSaltaAg)  // -- "S" OU "N" 
Endif 

If nFlag == 0
	nTransFun:=nTransVal:=0      	// Zera total a transportar
Endif                           	// apenas quando houver uma quebra
Return 
	
*-----------------------*
Static Function TotalPag		// Totalizador por Pagina
*-----------------------*
If tFunPag == 0
	Return Nil
Endif

IF cTipoRel == "S"				//Nao Imprime Total da Pagina Quando a Relacao for Sintetica.
	Return NIL
EndIF
	
DET = REPLICATE("-",132)
IMPR(DET,"C") 
DET := SPACE(5)+"TOTAL DA PAGINA"+SPACE(72)+"QTDE. FUNC.:"+TRANSFORM(TFUNPAG,"99999")
DET += SPACE(02)+TRANSFORM(TPAGINA,cPict2)
IMPR(DET,"C")
If nFlag == 1
	IF nTRANSVAL # 0
		DET = REPLICATE("-",132)
		IMPR(DET,"C")
		DET := SPACE(5)+"TRANSPORTADO PAGINA ANTERIOR"+SPACE(58)+"QTDE. FUNC.:"+TRANSFORM(nTRANSFUN,"99999")
		DET += SPACE(02)+TRANSFORM(nTRANSVAL,cPict2)
		IMPR(DET,"C")
		nFlag	:= 0
	ENDIF
Endif
IMPR("","C")
nTransfun 	+= tFunPag
nTransVal 	+= tPagina
tFunPag 	:= tPagina := 0
	
Return
*----------------------*
Static Function TotalCc  // Totalizador Por Centro de Custo
*----------------------*
Local Desc_Cc:=Space(40)

If (nOrdem # 2 .And. nOrdem # 5 .And. nOrdem # 7 .And. nOrdem # 10) .Or. tFunTcc == 0
	Return Nil                                     // Consistencia de Opcoes
Endif
		
If (li + 2) >= 58 
	Impr("","P")
Endif
		
Desc_Cc :=fDesc("SI3",CcAnt, "SI3->I3_DESC")  + Space(15)   // Procura Descricao do Centro de Custo
		
DET = REPLICATE("-",132)
IMPR(DET,"C")
DET := SPACE(5)+"TOTAL DO C.CUSTO  "+substr(DESC_CC+space(68),1,68)+" QTDE. FUNC.:"+TRANSFORM(TFUNTCC,"99999")
DET += SPACE(02)+TRANSFORM(TCC,cPict2)
IMPR(DET,"C")
IMPR("","C")
tFunTCC := Tcc := 0
Return


Static Function TotalAge  // Totalizador por Banco

Local DESC_AGE := Space(40)

If tFunAge == 0 
	Return Nil
Endif

IF (li + 2) >= 58
	IMPR("","P")
ENDIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao Para Buscar Nome do Banco ( SA6 )                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Desc_Age :=AgeAnt + " " + DescBco(BcoAnt+AgeAnt,FilAnt,40,.T.) 

DET = REPLICATE("-",132)
IMPR(DET,"C")
DET := SPACE(5)+"TOTAL  AGENCIA  "+DESC_AGE+SPACE(22)+"   QTDE. FUNC.:"+TRANSFORM(TFUNAGE,"99999")	//###
DET += SPACE(02)+TRANSFORM(TAGENCIA,cPict2)
IMPR(DET,"C")
IMPR("","C")
tFunAge 	:= tAgencia 	:= 0
tFunPag 	:= tPagina 		:= 0
nTransval	:= nTransFun	:= 0  

If (li + 3) >= 58
	Impr("","P")
Endif
	
Return
		
*-----------------------*
Static Function TotalBan  // Totalizador por Banco
*-----------------------*
Local DESC_BCO := Space(40)

If tFunBan == 0
	Return Nil
Endif

If (li + 2) >= 58
	Impr("","P")
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao Para Buscar Nome do Banco ( SA6 )                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Desc_Bco := BcoAnt + " " + DescBco(BcoAnt,FilAnt)

DET = REPLICATE("-",132)
IMPR(DET,"C")
DET := SPACE(5)+"TOTAL DO BANCO  "+DESC_BCO+SPACE(24)+"   QTDE. FUNC.:"+TRANSFORM(TFUNBAN,"99999")
DET += SPACE(02)+TRANSFORM(TBANCO,cPict2)
IMPR(DET,"C")
IMPR("","C")
tFunBan := tBanco := 0

Return 
*-----------------------*
Static Function TotalFil  // Totalizador por Empresa
*-----------------------*
Local cDesc_Fil := FilAnt+ "*** Nao Encontrada *** "
                        
If fInfo(@aInfo,FilAnt)
	cDesc_Fil := FilAnt+ " "+ aInfo[1] + Space(22)
EndIf	

If tFunFil == 0 .Or. (nOrdem >= 6)
	Return Nil 
Endif

IF (li + 2) >= 58
	IMPR("","P")
ENDIF
	
DET = REPLICATE("-",132)
IMPR(DET,"C")

DET := SPACE(5)+"TOTAL DA FILIAL "+cDesc_Fil+SPACE(28)+"   QTDE. FUNC.:"+TRANSFORM(tFunFil,"99999")
DET += SPACE(02)+TRANSFORM(TFilial ,cPict2)
IMPR(DET,"C")
DET = REPLICATE("-",132)
IMPR(DET,"C")
IMPR("","C")
		
//-- Reinicializa valores para a proxima Filial 
tFunFil	:= TFilial 	:= 0
tFunPag	:= Tpagina 	:= 0 
TFunAge := TAgencia	:= 0 
tFunBan := Tbanco  	:= 0 
tFunTcc := Tcc		:= 0

Return 
*-----------------------*
Static Function TotalEmp  // Totalizador Geral
*-----------------------*
Local cDesc_Emp 	:= aInfo[3]

If tEmpresa == 0 
	Return Nil 
Endif 
    
If (li + 2) >= 58
	IMPR("","P")
ENDIF 

DET := REPLICATE("-",132) 
IMPR(DET,"C") 

DET := SPACE(5)+"TOTAL DA EMPRESA "+cDesc_Emp+SPACE(8)+"  QTDE. FUNC.:"+TRANSFORM(tFunEmp,"99999")
DET += SPACE(02)+TRANSFORM(tEmpresa ,cPict2)

IMPR(DET,"C")
DET := REPLICATE("-",132)
IMPR(DET,"C")
tFunEmp := tEmpresa:= 0

Return


/*
Desc.     ³Valida o campo de Conta Corrente (Func/Benef) de acordo com º±±
          ³mv_par08 (Com Conta/Sem Conta)                              º±±
*/ 
User Function fChkConta( cConteudo )

If mv_par08 == 1 .and. Empty(cConteudo) 			//-- Com  conta Corrente, nao permite q cpo de Conta Corrente fique em  branco 
	Alert(oemToAnsi("Este Campo deve ser informado. Foi selecionado a opcao de impressao 'Com Conta Corrente' ") )
	Return(.F.)	
Endif 

Return(.T.)


Static Function AjustaSx1()

Local aHelp, aHelpE, aHelpI
Local aRegs	:= {}
Local cHelp
Local cPerg	:= "GPR020    "

aHelp := {	"Informe se deseja gerar os valores de ",;
			"rescisao.                             " }
aHelpE := {	"Informe si desea generar los valores ",;
			"de rescisión.	                      " }
aHelpI := {	"Enter whether you want to generate the",;
			"termination values.                   " }

cHelp := ".GPR02032."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol   Pergunta Ingles Variavel Tipo Tamanho  Decimal Presel  GSC   Valid   Var01      Def01 DefSPA1  DefEng1  Cnt01   Var02  Def02  DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3  GrgSxg  cPyme aHelpPor aHelpEng aHelpSpa cHelp  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{cPerg,"32","Rescisao  ?"        ,"¨Liquidacion Final ?","Termination?","MV_CHW","N",1    ,0      ,2     ,"C"  ,""    ,"MV_PAR32" ,"Sim","Si"   ,"Yes"  ,""     ,""    ,"Nao" ,"No"  ,"No"  ,""   ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""    ,""     ,""    ,""    ,""   ,""      ,""     ,""   ,""   ,""    ,""   ,""     ,""       ,""     ,cHelp})

ValidPerg(aRegs,cPerg,.T.)

Return
