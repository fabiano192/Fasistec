#Include "CTBA211.CH"
#Include "PROTHEUS.CH"               
#DEFINE D_PRELAN	"9"

STATIC lGravouLan	:= .F.
STATIC nTamCta	:= TAMSX3("CT1_CONTA")[1]
STATIC nTamCC	:= TAMSX3("CTT_CUSTO")[1]
STATIC nTamItem	:= TAMSX3("CTD_ITEM")[1]
STATIC nTamClVl	:= TAMSX3("CTH_CLVL")[1]

STATIC cSpacCt	:= REPLICATE(" ",nTamCta)
STATIC cSpacCC	:= REPLICATE(" ",nTamCC)
STATIC cSpacIt	:= REPLICATE(" ",nTamItem)
STATIC cSpacCl  := REPLICATE(" ",nTamClVl)


STATIC cArqTrb	:= ""
STATIC cArqIND1	:= ""
STATIC cArqIND2	:= ""
STATIC nMAX_LINHA := CtbLinMax(GetMv("MV_NUMLIN"))

STATIC __cKeyCTZATU := ""
STATIC __cSeqLICTZ 	:= ""

STATIC __aJaFlag := {}
STATIC __aDocsLP := {}
STATIC __IsCtbJob:= IIF( FindFunction( "IsCtbJob") , IsCtbJob() , .F. )
STATIC _lCtbIsCube  := FindFunction("CtbIsCube")

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥CTBA211   ≥ Autor ≥ Marcos S. Lobo        ≥ Data ≥ 26.09.06 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Apuracao de Resultados -Lucros/Perdas	                  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ Ctba211()                                                  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ Ctba211                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
User Function CTBA211AST()

/*
Ctb211Fil - AST001
Ctb211Proc- AST002  

*/

Local lTrbProc      := .T.
Local aSays 		:= {}
Local aButtons		:= {}
LOCAL nOpca    		:= 0
Local cMens			:= ""
Local oProcess
Local cFunction		:= "CTBA211"
Local cPerg			:= "CTB211"
Local cTitle		:= STR0001	// "Apuracao de Lucros / Perdas"
Local cDescription	:= 	STR0002 + CRLF + CRLF +;	//"Esta rotina ir† gerar os lancamentos contabeis de lucros e perdas."
						STR0015 + CRLF +;	//"Recomenda-se a verificaÁ„o prÈvia ou reprocessamento de saldos antes "
						STR0016 + CRLF +;	//"de executar esta rotina."
						STR0017 + CRLF +;	//"Visualizar, para o Log de processamento"
						STR0018 // "Ordem, para sequencia de apuraÁıes ja processadas"
Local aInfoCustom	:= {}						

Local bProcess		:= { }
Local lRpo1_1		:= Iif(AdmGetRpo("R1.1") == .T.,.T.,.F.) 
Private cCadastro 	:= OemToAnsi(STR0001)  //"Apuracao de Lucros / Perdas"
PRIVATE cString   	:= "CT2"
PRIVATE cDesc1    	:= OemToAnsi(STR0002)  //"Esta rotina ir† gerar os lancamentos contabeis de lucros e perdas."
PRIVATE cDesc2    	:= ""
PRIVATE cDesc3    	:= ""
PRIVATE titulo    	:= OemToAnsi(STR0003)  //"Simulacao da Apuracao"
PRIVATE cCancel   	:= OemToAnsi(STR0004)  //"***** CANCELADO PELO OPERADOR *****"
PRIVATE nomeprog  	:= "CTBA211"
PRIVATE aLinha    	:= { },nLastKey := 0

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf         

//Atualizar o arquivo SX5 com o flag de apuracao
Ct210UpdX5()

// ajusta o sx1
CtAjustSx1( 'CTB211' )

If GetNewPar("MV_ATUSAL","S") == "N"
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Mostra tela de aviso - Verificar se os saldos foram atualizados.≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	cMens := OemToAnsi(STR0011)+chr(13)  //"CASO A ATUALIZACAO DOS  SALDOS BASICOS  NAO  SEJA  FEITA  NA "
	cMens += OemToAnsi(STR0012)+chr(13)  //"DIGITACAO DOS LANCAMENTOS (MV_ATUSAL = 'N'), FAVOR VERIFICAR "
	cMens += OemToAnsi(STR0013)+chr(13)  //"SE OS SALDOS ESTAO ATUALIZADOS !!!!"
	
	MsgInfo(cMens,OemToAnsi(STR0014))  //"ATENÄéO"
EndIf

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Variaveis utilizadas para parametros                         ≥
//≥ mv_par01 // Data Inicial de Apuracao                         ≥
//≥ mv_par02 // Data de Apuracao                                 ≥
//≥ mv_par03 // Numero do Lote			                         ≥
//≥ mv_par04 // Numero do SubLote		                         ≥
//≥ mv_par05 // Numero do Documento                              ≥
//≥ mv_par06 // Cod. Historico Padrao                            ≥
//≥ mv_par07 // Da Conta  		        						 ≥
//≥ mv_par08 // Ate a Conta                             		 ≥
//≥ mv_par09 // Moedas        			                         ≥
//≥ mv_par10 // Qual Moeda?                                      ≥
//≥ mv_par11 // Considera Entidades Pontes                       ≥
//≥ mv_par12 // Tipo de Saldo 				                     ≥
//≥ mv_par13 // Considera Entidades de Apuracao?Cadastro/Rotina  ≥
//≥ mv_par14 // Conta Ponte   				                     ≥
//≥ mv_par15 // Conta de Apuracao de Resultados                  ≥
//≥ mv_par16 // C.Custo Ponte 				                     ≥
//≥ mv_par17 // C.Custo de Apuracao de Resultados                ≥
//≥ mv_par18 // Item Ponte    				                     ≥
//≥ mv_par19 // Item de Apuracao de Resultados                   ≥
//≥ mv_par20 // Cl. Valor Ponte				                     ≥
//≥ mv_par21 // Cl. Valor de Apuracao de Resultados              ≥
//≥ mv_par22 // Do C.Custo		        						 ≥
//≥ mv_par23 // Ate o C.Custo                           		 ≥
//≥ mv_par24 // Do Item Contabil	    						 ≥
//≥ mv_par25 // Ate o Item Contabil                     		 ≥
//≥ mv_par26 // Da Classe de Valor	    						 ≥
//≥ mv_par27 // Ate a Classe de Valor                     		 ≥
//≥ mv_par28 //Reproces. Saldos   ?
//≥ mv_par29 // Seleciona Filiais?	                     		 ≥
//≥ mv_par30 // Filial De	                     		 ≥
//≥ mv_par31 // Filial Ate	                     		 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
Pergunte("CTB211",.F.)

If lRpo1_1
	Aadd( aInfoCustom, { "Ordem", { |oCenterPanel| A211Ordem(oCenterPanel) }, "PROCESSA", { {} , {} } } )
	bProcess := { |oSelf| If(MV_PAR29==1 .And. !Empty(xFilial("CT2")), ;// Seleciona filiais
								AST001(Nil,oSelf,MV_PAR30,MV_PAR31);
								, ;//Else
								AST002(oProcess,oSelf) ;
							) }
	tNewProcess():New( cFunction, cTitle, bProcess, cDescription, cPerg, aInfoCustom )	
Else	
	AADD(aSays,OemToAnsi( STR0002 ) )	//"Esta rotina ir† gerar os lancamentos contabeis de lucros e perdas."
	AADD(aSays,"" )	//""
	AADD(aSays,OemToAnsi( STR0015 ) )	//"Recomenda-se a verificaÁ„o prÈvia ou reprocessamento de saldos antes "
	AADD(aSays,OemToAnsi( STR0016 ) )	//"de executar esta rotina."
	AADD(aSays,STR0017) //"Visualizar, para o Log de processamento"
	AADD(aSays,STR0018)	//"Ordem, para sequencia de apuraÁıes ja processadas"
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Inicializa o log de processamento                            ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	ProcLogIni( aButtons )
	
	AADD(aButtons, { 9,.T.,{|| MostraSX5LP() } } )		/// MOSTRA APURACOES JA EFETUADAS.
	AADD(aButtons, { 5,.T.,{|| Pergunte("CTB211",.T. ) } } )
	AADD(aButtons, { 1,.T.,{|| nOpca:= 1, If( CtbOk(), FechaBatch(), nOpca:=0 ) }} )
	AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )
	
	FormBatch( cCadastro, aSays, aButtons )
		                                    
	If nOpca == 1
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Atualiza o log de processamento   ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		ProcLogAtu("INICIO")
	   
		If MV_PAR29 == 1 .And. !Empty(xFilial("CT2")) // Seleciona filiais
			oProcess := MsNewProcess():New({|lEnd| AST001(oProcess,Nil,MV_PAR30,MV_PAR31)},"","",.F.)
		Else
			oProcess := MsNewProcess():New({|lEnd| AST002(oProcess)},"","",.F.)
		EndIf
		
		oProcess:Activate()		
	
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Atualiza o log de processamento   ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		ProcLogAtu("FIM")
	
	Endif
EndIf

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥AST001 ∫Autor  ≥Alvaro Camillo Neto ∫ Data ≥  21/09/09   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Executa o processamento para cada filial                    ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ CTBA211                                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function AST001(oProcess,oSelF,cFilDe,cFilAte)

Local cFilIni 	:= cFIlAnt
Local aArea		:= GetArea()
Local lRpo1_1	:= Iif(AdmGetRpo("R1.1") == .T.,.T.,.F.) 
Local aSM0 		:= Iif( FindFunction( "AdmAbreSM0" ) , AdmAbreSM0() , {} )
Local nContFil := 0

If Len( aSM0 ) > 0
	For nContFil := 1 to Len(aSM0)
		If aSM0[nContFil][SM0_CODFIL] < cFilDe .Or. aSM0[nContFil][SM0_CODFIL] > cFilAte .Or. aSM0[nContFil][SM0_GRPEMP] != cEmpAnt
			Loop
		EndIf

		cFilAnt := aSM0[nContFil][SM0_CODFIL]

		If lRpo1_1
			oSelf:SaveLog( "MENSAGEM: EXECUTANDO A APURACAO DA FILIAL " + cFilAnt)//
		Else
			ProcLogAtu("MENSAGEM"," EXECUTANDO A APURACAO DA FILIAL "+ cFilAnt)//
		EndIf

		AST002(oProcess,oSelf)
	Next nContFil

	cFIlAnt := cFilIni
Else
	ProcLogAtu("ERRO","AtenÁ„o!","Nenhuma empresa/filial encontrada. Verique se est· utilizando a ultima vers„o do ADMXFUN (MAR/2010)" )
Endif

RestArea(aArea)

Return

	
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥AST002    ≥ Autor ≥ Marcos S. Lobo        ≥ Data ≥ 26.09.06 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥Zeramento de Lucros/Perdas.                                 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ AST002    ()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ Ctba211                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/    

Static FUNCTION AST002(oObj,oSelf)

Local nx
Local dLastProc
Local dDataILP		:= mv_par01		//Data Inicial de ApuraÁ„o
Local dDataFLP		:= mv_par02		//Data Final de Apuracao
Local cLote 		:= mv_par03		//Num. do lote que sera gerado os lancamentos
Local cSubLote		:= mv_par04		//Num. do sublote que sera gerado os lancamentos
Local cDoc			:= mv_par05		//Num. do doc. que sera gerado os lancamentos
Local nLinha		:= 0
Local cLinha		:= '000'
Local cLinhaLan		:= '001'
Local cSeqLan		:= "001"

Local lFirst 		:= .T.
Local cLoteAtu 		:= cLote
Local cSubAtu		:= cSubLote
Local cDocAtu		:= cDoc

Local cKeyEntAtu	:= ""
Local nRecLanAtu	:= 0
Local nRecLan		:= 0
Local nOpcGRV 		:= 3			/// 3 = INCLUI LANCAMENTO / 4 = ALTERA
Local cKeyDocLP		:= ""			/// CHAVE DO DOCUMENTO ATUAL DE APURACAO
Local nRecLinha		:= 0		
Local nVlrCTZ		:= 0			/// VALOR DO LANCAMENTO NO CTZ (VALOR DO CT2 PODE SER SOMADO X vezes)
Local cHP			:= mv_par06		//Historico Padrao utilizado nos lancamentos
Local cContaIni		:= mv_par07		//Conta Inicial
Local cContaFim		:= mv_par08		//Conta Final
Local cCustoIni		:= mv_par22		//C.Custo Inicial
Local cCustoFim		:= mv_par23		//C.Custo Final
Local cItemIni		:= mv_par24		//Item Inicial
Local cItemFim		:= mv_par25		//Item Final
Local cClVlIni		:= mv_par26		//Classe Inicial
Local cClVlFim		:= mv_par27		//Classe Final
Local lMoedaEsp		:= Iif(mv_par09==2,.T.,.F.)	//Moedas
Local cMoeda		:= StrZero(Val(mv_par10),2)			//Define qual a moeda especifica
Local lPontes		:= Iif(mv_par11 == 1,.T.,.F.) //Considera Entidades Pontes
Local lCadastro		:= Iif(mv_par13 == 1,.T.,.F.)	//Consdera Endidades Pontes/Lp dos Cadastros
Local cTpSaldo		:= mv_par12		//Tipo de Saldo.
Local lPergOk		:= .T.
Local lClVl			:=	CtbMovSaldo("CTH")
Local lItem			:=	CtbMovSaldo("CTD")
Local lCusto		:= 	CtbMovSaldo("CTT")
Local aCtbMoeda 	:= {}
Local nInicio		:= 0
Local nFinal		:= 0
Local cDescHP		:= ""                                        
Local dDataAILP		:= dDataILP-1	/// DATA ANTERIOR ¿ INICIAL DE LUCROS E PERDAS
Local dDataIRep		:= dDataFLP		/// DATA INI REPROC. IGUAL DATA FINAL DE APURACAO (ENQUANTO AINDA ESTA SEM A FUNCAO CTBGRAVSALDO)
Local dDataFRep		:= dDataFLP		/// REPROCESSAMENTO DE SALDOS DEVE SER SEMPRE AT… A DATA DE APURACAO -> POSTERIOR … APENAS ACUMULADO
Local cCampo		:= ""
Local lJaExec := .F.
Local lSlbase		:= Iif(GETMV("MV_ATUSAL")=="N",.F.,.T.)
Local nIndTmp		:= 0
Local lCtbCCLP	:= Iif(ExistBlock("CTB211CC"),.T.,.F.)
Local lCtbItLP 	:= Iif(ExistBlock("CTB211IT"),.T.,.F.)
Local lCtbCVLP 	:= Iif(ExistBlock("CTB211CV"),.T.,.F.)

#IFDEF TOP
	Local lRetSaldo		:= .T.
#ENDIF	

////////////////////////////////////////////////////////////////////////////////////////
Local lObj		:= ValType(oObj) == "O"
Local cExerc	:= alltrim(str(Year(dDataFLP),4))
Local cFilCTG	:= ""

Local nMoed		:= 1
Local cMoed		:= "01"

Local nTpSld	:= 1

Local lJaProc 	:= .F.			/// SE A ROTINA J¡ COMECOU A TRANSFERIR REGISTROS P/ CV6 OU N√O
Local lCriaTRB	:= .T.			/// SE DEVE OU NAO CRIAR UM TRB NOVO
Local lNovoTRB	:= .T.			/// SE FOI CRIA

Local cTpSldAnt	:= ""

Local cMoedAnt	:= ""
Local CTF_LOCK	:= 0

Local nForaCols	:= 0

Local cClVlPon	:= cSpacCL
Local cItemPon	:= cSpacIT
Local cCCPon	:= cSpacCC
Local cCtaPon	:= cSpacCT
Local cClVlLP	:= cSpacCL
Local cItemLP	:= cSpacIT
Local cCCLP		:= cSpacCC
Local cCtaLP	:= cSpacCT
Local lClVlOk	:= .T.
Local lItemOk	:= .T.
Local lCCOk		:= .T.
Local lCtaOk	:= .T.
Local cDigPon	:= ""
Local cDigLP	:= ""
Local aCriter	:= {}         		/// CRITERIO DE CONVERSAO DA CONTA DE ORIGEM (FORA DE USO)
Local aCritLP	:= {}				/// CRITERIO DE CONVERSAO DA CONTA DE APURACAO (FORA DE USO)
Local aCritPon	:= {}               /// CRITERIO DE CONVERSAO DA CONTA PONTE (FORA DE USO)   

Local aFilters	:= {}

Local lSaldo	:= .F.		/// INDICA SE APURACAO SERA PELO .F.->MOVIMENTO/.T. ->SALDO
Local lCTZDeb 	:= .F.

Local lGrvCT7		:= IIf(ExistBlock("GRVCT7"),.T.,.F.)
Local lGrvCT3		:= IIf(ExistBlock("GRVCT3"),.T.,.F.)
Local lGrvCT4		:= IIf(ExistBlock("GRVCT4"),.T.,.F.)
Local lGrvCTI		:= IIf(ExistBlock("GRVCTI"),.T.,.F.)
Local lAtuSldCT7	:= .T.
Local lAtuSldCT3	:= .T.
Local lAtuSldCT4	:= .T.
Local lAtuSldCTI	:= .T.
Local lRpo1_1		:= Iif(AdmGetRpo("R1.1") == .T.,.T.,.F.) 
Local nK		:= 0
Local aOutrEntid
Local aEntid
Local lFiltra	:= .F.
Local lFilCT	:= .F.
Local lFilCC	:= .F.
Local lFilIT	:= .F.
Local lFilCL	:= .F.

If lGrvCT7
	lAtuSldCT7	:= ExecBlock("GRVCT7",.F.,.F.)
Endif
If lGrvCT3
	lAtuSldCT3	:= ExecBlock("GRVCT3",.F.,.F.)
Endif
If lGrvCT4
	lAtuSldCT4	:= ExecBlock("GRVCT4",.F.,.F.)
Endif
If lGrvCTI
	lAtuSldCTI	:= ExecBlock("GRVCTI",.F.,.F.)
Endif

PRIVATE aCols 		:= {} // Utilizada na conversao das moedas
Private cSeqCorr  := ""

If cPaisLoc == 'CHI' .and. Val(cLinha) < 2  // a partir da segunda linha do lanc., o correlativo eh o mesmo
	cSeqCorr := CTBSqCor( CTBSubToPad(cSubLote) )
EndIf

If MV_PAR29 == 1 .And. Empty(xFilial("CT2"))
	If lRpo1_1
		oSelf:SaveLog("TRATAMENTO MULTI FILIAL DESABILITADO: CT2 COMPARTILHADO")
	Else
		ProcLogAtu("MENSAGEM","TRATAMENTO MULTI FILIAL DESABILITADO: CT2 COMPARTILHADO")
	EndIf 
EndIf

////////////////////////////////////////////////////////////////////////////////////////

// Sub-Lote somente eh informado se estiver em branco
mv_par04 := If(Empty(GetMV("MV_SUBLOTE")), mv_par04, GetMV("MV_SUBLOTE"))

If lMoedaEsp					// Moeda especifica
	cMoeda	:= mv_par10
	aCtbMoeda := CtbMoeda(cMoeda)
	If Empty(aCtbMoeda[1])
		Help(" ",1,"NOMOEDA")
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Atualiza o log de processamento com o erro  ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		If lRpo1_1
			oSelf:SaveLog(Ap5GetHelp("NOMOEDA"))
		Else
			ProcLogAtu("ERRO","NOMOEDA",Ap5GetHelp("NOMOEDA"))
		EndIf
		Return
	EndIf                  
	nInicio := val(cMoeda)
	nFinal	:= val(cMoeda)
Else
	nInicio	:= 1
	nFinal	:= __nQuantas
EndIf

If Empty(mv_par01)
	mv_par01 := CTOD("01/01/80")
EndIf

Do Case 
Case __LANGUAGE == "PORTUGUESE"
	cCampo	:= "SX5->X5_DESCRI"
Case __LANGUAGE == "SPANISH"
	cCampo	:= "SX5->X5_DESCSPA"
Case __LANGUAGE ="ENGLISH"
	cCampo	:= "SX5->X5_DESCENG"
EndCase



//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ ANTES DE INICIAR O PROCESSAMENTO, VERIFICO OS PARAMETROS.	 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
//Data de Apuracao nao preenchida.
If Empty(dDataFLP)                              
	Help(" ",1,"NOCTBDTLP")

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Atualiza o log de processamento com o erro  ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If lRpo1_1
		oSelf:SaveLog(Ap5GetHelp("NOCTBDTLP"))
	Else
		ProcLogAtu("ERRO","NOCTBDTLP",Ap5GetHelp("NOCTBDTLP"))
    EndIf
	Return(.F.)
Else //Se a data estiver preenchida, verifica se ja foi rodado nessa data.
	dbSelectarea("SX5")
	dbSetOrder(1)
	If MsSeek(xFilial()+"LP"+cEmpAnt+cFilAnt)			
		While !Eof() .and. SX5->X5_TABELA == "LP"
			If Subs(&(cCampo),1,8) == Dtos(dDataFLP) 
				If (!lMoedaEsp .Or. (lMoedaEsp .And. Subs(&(cCampo),9,2) == cMoeda)) .And.;
						Subs(&(cCampo),11,1) == cTpSaldo 
					If ! MsgYesNo(STR0008,OemToAnsi(STR0014+"Filial "+cFilAnt))
						Return(.F.)
					Else
						lJaExec := .T.
						Exit
					Endif
				EndIf
			Endif
			dbSkip() 
		End			
	EndIf
	//Verificar se o calendario da data solicitada esta encerrado
	lPergOk	:= CtbValiDt(1,dDataFLP)
Endif                            
	
//Historico Padrao nao preenchido.
If Empty(cHP)	
	Help(" ",1,"CTHPVAZIO")

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Atualiza o log de processamento com o erro  ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If lRpo1_1
		oSelf:SaveLog(Ap5GetHelp("CTHPVAZIO"))
	Else
		ProcLogAtu("ERRO","CTHPVAZIO",Ap5GetHelp("CTHPVAZIO"))
	EndIf
	lPergOk := .F.
Else
	dbSelectArea("CT8")
	dbSetOrder(1)
	MsSeek(xFilial("CT8")+cHP)
	If found()
		cDescHP 	:= CT8->CT8_DESC
	Else            
		//Historico Padrao nao existe no cadastro.
		PutSX1Help("SCT210NOHP",{"Preencha com um codigo de historico","padr„o v·lido."},{"Llene con un codigo de historial","estandar valido."},{"Fill in the field with a valid standard","history code"})
	   	Help(" ",1,"CT210NOHP",,"FILIAL "+cFilAnt,2,0)
					
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Atualiza o log de processamento com o erro  ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		If lRpo1_1
			oSelf:SaveLog(Ap5GetHelp("CT210NOHP"))
		Else
			ProcLogAtu("ERRO","CT210NOHP",Ap5GetHelp("CT210NOHP"))
		EndIf	
	
		lPergOk := .F.
	Endif
Endif                             
	
//Lote nao preenchido.
If Empty(cLote)
	Help(" ",1,"NOCT210LOT")

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Atualiza o log de processamento com o erro  ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If lRpo1_1
		oSelf:SaveLog(Ap5GetHelp("NOCT210LOT"))
	Else
		ProcLogAtu("ERRO","NOCT210LOT",Ap5GetHelp("NOCT210LOT"))
	EndIf
	lPergOk := .F.
Endif
	
//Sub Lote nao preenchido.
If Empty(cSubLote)
	Help(" ",1,"NOCTSUBLOT")

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Atualiza o log de processamento com o erro  ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If lRpo1_1
		oSelf:SaveLog(Ap5GetHelp("NOCTSUBLOT"))
	Else
		ProcLogAtu("ERRO","NOCTSUBLOT",Ap5GetHelp("NOCTSUBLOT"))
	EndIf
	lPergOk := .F.
Endif
	
//Documento nao preenchido.
If Empty(cDoc)
	Help(" ",1,"NOCT210DOC")

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Atualiza o log de processamento com o erro  ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If lRpo1_1
		oSelf:SaveLog(Ap5GetHelp("NOCT210DOC"))
	Else
		ProcLogAtu("ERRO","NOCT210DOC",Ap5GetHelp("NOCT210DOC"))
	EndIf
	lPergOk := .F.
Else	//Se o documento estiver preenchido, verifico se existe lancamento com mesmo numero
		//de lote, sublote, documento e data
	dbSelectArea("CT2")
	dbSetOrder(1)

//	If ! lJaExec .And. MsSeek(xFilial()+dtos(dDataFLP)+cLote+cSubLote+cDoc)	
	
	If MsSeek(xFilial()+dtos(dDataFLP)+cLote+cSubLote+cDoc)	
		lPergOk := .F.		
		MsgAlert(OemtoAnsi(STR0009))//Data+Lote+Sublote+documento ja existe. 		
    Endif
Endif
	
//Conta Inicial e Conta Final nao preenchidos. 	
If Empty(cContaIni) .And. Empty(cContaFim)
	Help(" ",1,"NOCT210CT")

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Atualiza o log de processamento com o erro  ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If lRpo1_1
		oSelf:SaveLog(Ap5GetHelp("NOCT210CT"))
	Else
		ProcLogAtu("ERRO","NOCT210CT",Ap5GetHelp("NOCT210CT"))
	EndIf
	lPergOk := .F.
Endif                                          
	
//Se for moeda especifica, verificar se a moeda esta preenchida
If lMoedaEsp
	If Empty(cMoeda)
		Help(" ",1,"NOCTMOEDA")

		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Atualiza o log de processamento com o erro  ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		If lRpo1_1
			oSelf:SaveLog(Ap5GetHelp("NOCTMOEDA"))
		Else
			ProcLogAtu("ERRO","NOCTMOEDA",Ap5GetHelp("NOCTMOEDA"))
		EndIf	

		lPergOk := .F.
	Endif
EndIf	
	     
//Tipo de saldo nao preenchido
If Empty(cTpSaldo)
	Help(" ",1,"NO210TPSLD")

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Atualiza o log de processamento com o erro  ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If lRpo1_1
		oSelf:SaveLog(Ap5GetHelp("NO210TPSLD"))
	Else
		proclogatu("ERRO","NO210TPSLD",Ap5GetHelp("NO210TPSLD"))
    EndIf
	lPergOk := .F.
Endif	       

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥VALIDACAO DAS ENTIDADES PONTE E DE APURACAO - ENTIDADES PELA ROTINA≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
//Se utiliza as entidades ponte/LP da Rotina, verificar se os parametros estao preenchidos
If !lCadastro
	If lPontes .And. (Empty(mv_par14) .Or. Empty(mv_par15))
		Help(" ",1,"NOCT210CT")

		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Atualiza o log de processamento com o erro  ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		If lRpo1_1
			oSelf:SaveLog(Ap5GetHelp("NOCT210CT"))
		Else
			ProcLogAtu("ERRO","NOCT210CT",Ap5GetHelp("NOCT210CT"))
		EndIf	
	
		lPergOk	:= .F.	
	ElseIf	!lPontes .And. Empty(mv_par15)
		Help(" ",1,"NOCT210CT")

		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Atualiza o log de processamento com o erro  ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		If lRpo1_1
			oSelf:SaveLog(Ap5GetHelp("NOCT210CT"))
		Else
			ProcLogAtu("ERRO","NOCT210CT",Ap5GetHelp("NOCT210CT"))
		EndIf
		lPergOk	:= .F.		
	EndIf 

	cCtaPon	:= mv_par14
	cCtaLP	:= mv_par15	
	ct211valct(cCtaLP,@cCtaPon,@cDigPon,@cCtaLP,@cDigLP,lPontes,@lCtaOk,@aCriter,@aCritPon,@aCritLP,lCadastro)

	If(!lCtaOk, lPergOk := .F., )

	If lCusto .and. lPergOk
		If Empty(mv_par17) 
			If IsBlind()
				lCCOk := .T.
			Else
				If MsgYesNo(STR0043+CRLF+STR0044,ALLTRIM(RetTitle("CTT_CUSTO"))+STR0045 ) //"Entidade em uso, porÈm n„o indicado codigo para apuraÁ„o."#"Entidade n„o ser· considerada para os lanÁamentos. Continuar ?"#" de apuraÁ„o vazio."
					lCCOk := .T.
				Else
					lCCOk := .F.
				EnDif			
			EndIf
		Else
			cCCPon	:= mv_par16
			cCCLP	:= mv_par17		
			Ct211ValCC(cCCLP,@cCCPon,@cCCLP,lPontes,@lCCOk,lCadastro)											
		EndIf
		If(!lCCOk, lPergOk := .F., )
	EndIf

	If lItem .and. lPergOk
	    If Empty(mv_par19)
			If IsBlind()
				lItemOk := .T.
			Else
				If MsgYesNo(STR0043+CRLF+STR0044,ALLTRIM(RetTitle("CTD_ITEM"))+STR0045 ) //"Entidade em uso, porÈm n„o indicado codigo para apuraÁ„o."#"Entidade n„o ser· considerada para os lanÁamentos. Continuar ?"#" de apuraÁ„o vazio."
					lItemOk := .T.
				Else       
					lItemOk := .F.
				EnDif			
			EndIf
		Else
			cItemPon	:= mv_par18
			cItemLP		:= mv_par19
			Ct211ValIt(cItemLP,@cItemPon,@cItemLP,lPontes,@lItemOk,lCadastro)						
		Endif
		If(!lItemOk, lPergOk := .F., )
	EndIf

	If lClvl .and. lPergOk
		If Empty(mv_par21)
			If IsBlind()
				lCLVLOk := .T.
			Else
				If MsgYesNo(STR0043+CRLF+STR0044,ALLTRIM(RetTitle("CTH_CLVL"))+STR0045 ) //"Entidade em uso, porÈm n„o indicado codigo para apuraÁ„o."#"Entidade n„o ser· considerada para os lanÁamentos. Continuar ?"#" de apuraÁ„o vazio."
					lCLVLOk := .T.
				Else       
					lCLVLOk := .F.
				EnDif			
			EndIf
		Else
			cClVlPon	:= mv_par20
			cClVlLP		:= mv_par21 	
			Ct211ValCV(cClVlLP,@cClVlPon,@cClVlLP,lPontes,@lClVlOk,lCadastro) 
		EndIf
		If(!lCLVLOk, lPergOk := .F., )
	EndIf

EndIf

//Verifica se tem algum saldo basico desatualizado. Definido que essa verificacao so sera 
//feita em top connect, pois se fosse fazer em codebase iria degradar muito a performance
//do sistema. 
If !lSlBase //So ira fazer a verificacao, caso o parametro MV_ATUSAL esteja com "N"
	For nx := nInicio to nFinal
		dLastProc := GetCv7Date(cTpSaldo,StrZero(nx,2))
		If dDataFLP > dLastProc
			lPergOk := .F.
			MsgAlert(OemToAnsi(STR0010)+"Saldo : "+ cTpSaldo+" Moeda : "+StrZero(nx,2))//"Ha saldos basicos desatualizados. Favor atualizar os saldos."	
			Exit
		EndIf
	Next
EndIf

//SE OS PARAMETROS NAO ESTIVEREM DEVIDAMENTE PREENCHIDOS               
If !lPergOk	
	Return
Endif		
////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////
/// CRIA ARQUIVO DE TRABALHO PARA GUARDAR OS SALDOS A SEREM ZERADOS
////////////////////////////////////////////////////////////////////////////////////////
aTpSaldos	:= {cTpSaldo}
cArqTRB := "LP" + cEmpAnt + cFilAnt + Right( cExerc, 2)

/// CRIACAO DE ARQUIVO TEMPORARIO.
If ! Ct211CrTrb(cArqTRB,lJaProc,lCriaTRB,@lNovoTRB)
	Return
EndIf

If Empty(cContaFim)
	cContaFim := Replicate("Z",nTamCta)
Endif

aAdd(aFilters,{"CT", cContaIni,cContaFim} ) //Da Conta | a Conta

If lCusto
	If Empty(cCustoIni).And. Empty(cCustoFim)
		lCusto := .F.
	ElseIf Empty(cCustoFim)
		cCustoFim := Replicate("Z",nTamCC)	
	Endif
	aAdd(aFilters,{"CC", cCustoIni,cCustoFim} ) //Do C.Custo| ao C.Custo
EndIf
If lItem
	If Empty(cItemIni).And. Empty(cItemFim)
		lItem := .F.
	ElseIf Empty(cItemFim)
		cItemFim := Replicate("Z",nTamItem)	
	Endif
	aAdd(aFilters,{"IT", cItemIni,cItemFim} ) //Do Item | ao Item
EndIf
If lClVL
	If Empty(cClVlIni).And. Empty(cClVlFim)
		lClVL := .F.
	ElseIf Empty(cClVlFim)
		cClVlFim := Replicate("Z",nTamClVl)	
	Endif
	aAdd(aFilters,{"CL", cClVlIni,cClVlFim} ) //Da Classe | a Classe
EndIf

////////////////////////////////////////////////////////////////////
/// LE OS SALDOS DAS ENTIDADES E GUARDA NO ARQUIVO DE TRABALHO
////////////////////////////////////////////////////////////////////
If lNovoTRB
	/// VERIFICO OS SALDOS DA CLASSE DE VALOR (CTI) GRAVANDO NO TRB.
	If lClvl
		If lRpo1_1
			oSelf:SaveLog("MENSAGEM: OBTENDO SALDOS DO CTI")
		Else	
			ProcLogAtu("MENSAGEM","OBTENDO SALDOS DO CTI")
		EndIf	
		CTB211GTRB('CTI',dDataAILP,dDataFLP,aTpSaldos,oObj,lCusto,lItem,lClvl,aFilters,lSaldo,lMoedaEsp,cMoeda,oSelf)
		If lRpo1_1
			oSelf:SaveLog("MENSAGEM: FIM OBTENDO SALDOS CTI")
		Else	
			ProcLogAtu("MENSAGEM","FIM OBTENDO SALDOS CTI")
		EndIf	
	EndIf
	/// VERIFICO OS SALDOS DO ITEM CONTABIL (CT4) GRAVANDO NO TRB.
	If lItem
		If lRpo1_1
			oSelf:SaveLog("MENSAGEM: OBTENDO SALDOS DO CT4")
		Else
			ProcLogAtu("MENSAGEM","OBTENDO SALDOS DO CT4")
		EndIf	
		CTB211GTRB('CT4',dDataAILP,dDataFLP,aTpSaldos,oObj,lCusto,lItem,lClvl,aFilters,lSaldo,lMoedaEsp,cMoeda,oSelf)
		If lRpo1_1
			oSelf:SaveLog("MENSAGEM: FIM OBTENDO SALDOS DO CT4")
		Else
			ProcLogAtu("MENSAGEM","FIM OBTENDO SALDOS DO CT4")
		EndIf	
	EndIf
	/// VERIFICO OS SALDOS DO CENTRO DE CUSTO(CT3) GRAVANDO NO TRB.
	If lCusto
		If lRpo1_1
			oSelf:SaveLog("MENSAGEM: OBTENDO SALDOS DO CT3")
		Else
			ProcLogAtu("MENSAGEM","OBTENDO SALDOS DO CT3")
		EndIf	
		CTB211GTRB('CT3',dDataAILP,dDataFLP,aTpSaldos,oObj,lCusto,lItem,lClvl,aFilters,lSaldo,lMoedaEsp,cMoeda,oSelf)
		If lRpo1_1
			oSelf:SaveLog("MENSAGEM: FIM OBTENDO SALDOS DO CT3")
		Else
			ProcLogAtu("MENSAGEM","FIM OBTENDO SALDOS DO CT3")
		EndIf	
	EndIf

	/// VERIFICO OS SALDOS DA CONTA.(CT7) GRAVANDO NO TRB.
	If lRpo1_1
		oSelf:SaveLog("MENSAGEM: OBTENDO SALDOS DO CT7")
	Else	
		ProcLogAtu("MENSAGEM","OBTENDO SALDOS DO CT7")
	EndIf	
	CTB211GTRB('CT7',dDataAILP,dDataFLP,aTpSaldos,oObj,lCusto,lItem,lClvl,aFilters,lSaldo,lMoedaEsp,cMoeda,oSelf)
	If lRpo1_1
		oSelf:SaveLog("MENSAGEM: FIM OBTENDO SALDOS DO CT7")
    Else
		ProcLogAtu("MENSAGEM","FIM OBTENDO SALDOS DO CT7")
	EndIf	
EndIf

////////////////////////////////////////////////////////////////////////////////////////
/// LE O ARQUIVO DE TRABALHO E GRAVA OS LAN«AMENTOS DE APURACAO
////////////////////////////////////////////////////////////////////////////////////////
If lRpo1_1
	oSelf:SaveLog("MENSAGEM: INCIANDO A LEITURA/GRAVA«√O DOS LAN«AMENTOS" )
Else
	ProcLogAtu("MENSAGEM","INCIANDO A LEITURA/GRAVA«√O DOS LAN«AMENTOS" )
EndIf

dbSelectArea("TRB")
dbSetOrder(1)
dbGoTop()

If lObj
	oObj:SetRegua2(TRB->(RecCount()))			 				
ElseIf lRpo1_1
	oSelf:SetRegua2(TRB->(RecCount()))
EndIf 

nExecLin := 0

lFiltra := ValType(aFilters) == "A"

If lFiltra
	lFilCT := Len(aFilters) >= 1 .and. Len(aFilters[1]) >= 3 .and. (!Empty(aFilters[1][2]) .or. !Empty(aFilters[1][3]) )
	lFilCC := Len(aFilters) >= 2 .and. Len(aFilters[2]) >= 3 .and. (!Empty(aFilters[2][2]) .or. !Empty(aFilters[2][3]) )
	lFilIT := Len(aFilters) >= 3 .and. Len(aFilters[3]) >= 3 .and. (!Empty(aFilters[3][2]) .or. !Empty(aFilters[3][3]) )
	lFilCL := Len(aFilters) >= 4 .and. Len(aFilters[3]) >= 3 .and. (!Empty(aFilters[4][2]) .or. !Empty(aFilters[4][3]) )
EndIf


While TRB->(!Eof())  

	If lFilCT
		If TRB->CONTA < aFilters[1][2] .or. TRB->CONTA > aFilters[1][3]
			TRB->(dbSkip())
			Loop
		EndIf
	EndIf
	If lFilCC
		If TRB->CUSTO < aFilters[2][2] .or. TRB->CUSTO > aFilters[2][3]
			TRB->(dbSkip())
			Loop
		EndIf
	EndIf
	If lFilIT
		If TRB->ITEM < aFilters[3][2] .or. TRB->ITEM > aFilters[3][3]
			TRB->(dbSkip())
			Loop
		EndIf
	EndIf
	If lFilCL
		If TRB->CLVL < aFilters[4][2] .or. TRB->CLVL > aFilters[4][3]
			TRB->(dbSkip())
			Loop
		EndIf
	EndIf

	If lObj
		oObj:IncRegua2(OemToAnsi(STR0021+TRB->MOEDA+STR0022+TRB->TPSALDO))//"Passo 2 -> Gravando lanÁamentos Moeda "//" Saldo "
	ElseIf lRpo1_1
		oSelf:IncRegua2(OemToAnsi(STR0021+TRB->MOEDA+STR0022+TRB->TPSALDO))//"Passo 2 -> Gravando lanÁamentos Moeda "//" Saldo "
	EndIf

	If lJaProc
		If TRB->JAPROC == "S"
			TRB->(dbSkip())
			Loop			
		EndIf
	EndIf
    
   	nSaldo := TRB->SALDOC - TRB->SALDOD
	
	nExecLin++
	If nExecLin == 1
		nSaldo := TRB->SALDOC
	ElseIf nExecLin == 2
		nSaldo := TRB->SALDOD * -1
	EndIf

    If nSaldo <> 0	    
		nLinha := DecodSoma1( cLinha )   // a funcao esta no fonte ctbxfuna.prx

		If lFirst .or. nLinha > nMAX_LINHA .or. TRB->TPSALDO <> cTpSldAnt .or. TRB->MOEDA <> cMoedAnt
			cMoedAnt	:= TRB->MOEDA
			cTpSldAnt	:= TRB->TPSALDO
		
			Do While ! ProxDoc(dDataFLP,cLote,cSubLote,@cDoc,@CTF_LOCK)
				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥ Caso o Nß do Doc estourou, incrementa o lote         ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				cLote := Soma1(cLote)
				DbSelectArea("SX5")

				If MsSeek( xFilial("SX5" )+ "09CTB" , .F.)
					RecLock("SX5")
					SX5->X5_DESCRI := Substr(cLote,3,4)
					MsUnlock()
				EndIf

			Enddo
	
			If cPaisLoc == 'CHI' .and. Val(cLinha) < 2  // a partir da segunda linha do lanc., o correlativo eh o mesmo
				cSeqCorr := CTBSqCor( CTBSubToPad(cSubLote) )
			EndIf
	
			lFirst := .F.
			cLinha := "001"
			nLinha := 1
			cSeqLan:= "001"
		EndIf
	
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥VALIDACAO DAS ENTIDADES PONTE E DE APURACAO - ENTIDADES PELO CAD.  ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		If lCadastro
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥SE UTILIZAR ENTIDADES DO CADASTRO ≥
			//≥SUBSTITUI VARIAVEIS DAS           ≥
			//≥- ENTIDADES PONTE                 ≥
			//≥- ENTIDADES DE APURACAO           ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		
			lPergOk := .T.
			cCtaPon	:= cSpacCT
			cCtaLP	:= cSpacCT
			
			Ct211ValCt(TRB->CONTA,@cCtaPon,@cDigPon,@cCtaLP,@cDigLP,lPontes,@lCtaOk,@aCriter,@aCritPon,@aCritLP,lCadastro)  				
			
			If lPontes .And. (Empty(cCtaPon) .Or. Empty(cCtaLP))		
				lPergOk	:= .F.	
			ElseIf !lPontes .And. Empty(cCtaLP)	
				lPergOk	:= .F.		
			EndIf 
		
			cCCPon	:= cSpacCC
			cCCLP	:= cSpacCC
			If lPergOk .and. lCusto .and. !Empty(TRB->CUSTO)
				Ct211ValCC(TRB->CUSTO,@cCCPon,@cCCLP,lPontes,@lPergOk,lCadastro)											
			EndIf
		
			cItemPon	:= cSpacIT
			cItemLP		:= cSpacIT
			If lPergOk .and. lItem .and. !Empty(TRB->ITEM)
				Ct211ValIt(TRB->ITEM,@cItemPon,@cItemLP,lPontes,@lPergOk,lCadastro)						
			EndIf
		
			cClVlPon	:= cSpacCL
			cClVlLP		:= cSpacCL
			If lPergOk .and. lClvl .and. !Empty(TRB->CLVL)
				Ct211ValCV(TRB->CLVL,@cClVlPon,@cClVlLP,lPontes,@lPergOk,lCadastro) 
			EndIf
		
			/// SE HOUVER ALGUM PROBLEMA COM AS ENTIDADES PONTE/APURACAO DO CADASTRO
			If !lPergOk                                              	
				/// PASSA PARA O PROXIMO DO TRB SEM MARCAR COMO "J¡ PROCESSADO"
				/// AVALIAR CORRE«√O NO CADASTRO E PROCESSAMENTO S” DOS PENDENTES PELO TRB
				TRB->(dbSkip())
				Loop
			EndIf
		
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥Se as entidades ponte/apuraÁ„o est„o Ok        ≥
		//≥                                               ≥
		//≥AVALIA SALDO OBTIDO PARA LAN«AMENTO DE APURACAO≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ	
		EndIf
		
		cTipo		:= "3"		
		
		If nSaldo > 0					/// SE O SALDO FOR A CREDITO / CREDOR
			If !lPontes
				cDebito		:= TRB->CONTA	/// LANCAMENTO A DEBITO NA CONTA ORIGEM (PARA ZERAR)
				cCustoDeb	:= TRB->CUSTO
				cItemDeb	:= TRB->ITEM
				cClVlDeb	:= TRB->CLVL
			Else
				cDebito		:= cCtaPon	/// LANCAMENTO A DEBITO NA CONTA PONTE (PARA N√O ZERAR ORIGEM)
				If !Empty(TRB->CUSTO)
					cCustoDeb	:= cCCPon
				Else
					cCustoDeb	:= cSpacCC
				EnDif
				If !Empty(TRB->ITEM)
					cItemDeb	:= cItemPon
				Else
					cItemDeb	:= cSpacIT
				EndIf
				If !Empty(TRB->CLVL)
					cClVlDeb	:= cClVlPon
				Else
					cClVlDeb	:= cSpacCL
				EndIf
			EndIf
	
			cCredito	:= cCtaLP		/// LANCAMENTO A CREDITO NA CONTA DE APURACAO
			If !Empty(TRB->CUSTO)
				cCustoCrd	:= cCCLP
			Else
				cCustoCrd	:= cSpacCC
			EndIf
			If !Empty(TRB->ITEM)
				cItemCrd	:= cItemLP
			Else
				cItemCrd	:= cSpacIT
			EndIf
			If !Empty(TRB->CLVL)
				cClVlCrd	:= cClVlLP
			Else
				cClVlCrd	:= cSpacCL
			EndIf
	
			lCTZDeb := .T.	
		Else                        	/// SE O SALDO FOR A DEBITO / DEVEDOR
			cDebito		:= cCtaLP		/// LANCAMENTO A DEBITO NA CONTA DE APURACAO
			If !Empty(TRB->CUSTO)
				cCustoDeb	:= cCCLP
			Else
				cCustoDeb	:= cSpacCC
			EndIf
			If !Empty(TRB->ITEM)
				cItemDeb	:= cItemLP
			Else
				cItemDeb	:= cSpacIT
			EndIf
			If !Empty(TRB->CLVL)
				cClVlDeb	:= cClVlLP
			Else
				cClVlDeb	:= cSpacCL
			EndIf
			
			If !lPontes
				cCredito	:= TRB->CONTA	/// LANCAMENTO A CREDITO NA CONTA ORIGEM (PARA ZERAR)
				cCustoCrd	:= TRB->CUSTO
				cItemCrd	:= TRB->ITEM	
				cClVlCrd	:= TRB->CLVL
			Else
				cCredito	:= cCtaPon	/// LANCAMENTO A DEBITO NA CONTA PONTE (PARA N√O ZERAR ORIGEM)
				If !Empty(TRB->CUSTO)
					cCustoCrd	:= cCCPon
				Else
					cCustoCrd	:= cSpacCC
				EndIf
				If !Empty(TRB->ITEM)
					cItemCrd	:= cItemPon
				Else
					cItemCrd	:= cSpacIT
				EndIf
				If !Empty(TRB->CLVL)
					cClVlCrd	:= cClVlPon
				Else
					cClVlCrd	:= cSpacCL			
				EndIf
			EndIf  
	
			lCTZDeb := .F.
		EndIf 
		
		//Grava lancamento na moeda 01
		nSaldo 		:= ABS(nSaldo)	
		nMoedAtu	:= VAL(TRB->MOEDA)
	    
	    //////////////////////////////////////////////////////////////////////////////////////////
	    //////////////////////////////////////////////////////////////////////////////////////////
		If TRB->MOEDA == "01"     
			If lRpo1_1
				oSelf:SaveLog("MENSAGEM: INICIANDO A GRAVA«√O DOS SALDOS (MOEDA 01)" )
			Else	
				ProcLogAtu("MENSAGEM","INICIANDO A GRAVA«√O DOS SALDOS (MOEDA 01)" )
			EndIf	

			aOutrEntid 	:= CtbOutrEnt(.F., "TRB")
			aEntid 		:= aOutrEntid[1]

			//////////////////////////////////////////////////////////////////////////////////////////
			/// FUNCAO GRAVACTx AINDA ESTA GRAVANDO SALDO ANTERIOR INCORRETO QDO J¡ EXISTE LANC. NO DIA DE LP
			/// CHAMA A GRAVSALDO PARA ATUALIZAR OS ACUMULADOS CORRETAMENTE E 
			/// CHAMA REPROCESSAMENTO DO DIA DE APURACAO AO FINAL DO PROCESSAMENTO PARA ACERTAR SLD.ANTERIOR DO DIA.
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥	/// GRAVA SALDO RELATIVO AO LAN«AMENTO DE LUCROS E PERDAS (CTx_LP = 'Z')≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			CtbGravSaldo(cLote,cSubLote,cDoc,dDataFLP,cTipo,"01",;
				cDebito,cCredito,;
				cCustoDeb,cCustoCrd,;
				cItemDeb,cItemCrd,;
				cClVlDeb,cClVlCrd,;
				nSaldo,TRB->TPSALDO,3,;
				cDebito,cCredito,;
				cCustoDeb,cCustoCrd,;
				cItemDeb,cItemCrd,;
				cClVlDeb,cClVlCrd,;			
				0,cTipo,TRB->TPSALDO,"01",;			
				lCusto,lItem,lClVL,;
				,.T.,.F.,dDataFLP,;
				lGrvCT7,lGrvCT3,lGrvCT4,lGrvCTI,;
				lAtuSldCT7,lAtuSldCT3,lAtuSldCT4,lAtuSldCTI, aEntid)

			If lRpo1_1
				oSelf:SaveLog("MENSAGEM: FINALIZANDO A GRAVA«√O DOS SALDOS" )
			Else	
				ProcLogAtu("MENSAGEM","FINALIZANDO A GRAVA«√O DOS SALDOS" )
			EndIf	

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥PREPARA VARIAVEIS PARA INCLUSAO/ALTERACAO DE LANCAMENTO NO CT2≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ	
			If lRpo1_1
				oSelf:SaveLog("MENSAGEM: INICIANDO A INCLUSAO/ALTERACAO DOS LANCAMENTOS NO CT2 (01)" )
			Else	
				ProcLogAtu("MENSAGEM","INICIANDO A INCLUSAO/ALTERACAO DOS LANCAMENTOS NO CT2 (01)" )
			EndIf	

			nOpcGRV := 3
			If lPontes
				/// SE FOR APURACAO COM CONTA PONTE
				cLoteBak := cLote
				cSubBak	 := cSubLote
				cDocBak	 := cDoc
				cLinBak	 := cLinha
				cSeqLBak := cSeqLan
				
				nVlrCTZ := nSaldo
				If cKeyEntAtu <> '01'+TRB->TPSALDO+cDebito+cCredito+cCustoDeb+cCustoCrd+cItemDeb+cItemCrd+cClVlDeb+cClVlCrd
	
					cKeyDocLP := DTOS(dDataFLP)+cLote+cSubLote+cDoc			
					If Len(__aDocsLP) <= 0 .or. Ascan(__aDocsLP, {|x| x[1] == cKeyDocLP }) <= 0
						aAdd(__aDocsLP, { cKeyDocLP , dDataFLP , cLote, cSubLote, cDoc } )
					EndIf
					/// VERIFICA DENTRO DOS LOTES/DOCS J¡ GERADOS NA APURACAO SE EXISTE LANCAMENTO IGUAL
					nRecLinha := Ct211Seek(__aDocsLP,'01',TRB->TPSALDO,;
							cDebito,cCredito,cCustoDeb,cCustoCrd,cItemDeb,cItemCrd,cClVlDeb,cClVlCrd)
										   
					nRecLanAtu := nRecLinha
					cKeyEntAtu := '01'+TRB->TPSALDO+cDebito+cCredito+cCustoDeb+cCustoCrd+cItemDeb+cItemCrd+cClVlDeb+cClVlCrd							
				
				Else		/// ENQUANTO FOR A MESMA CHAVE DE ENTIDADES N√O PRECISA MODIFICAR LOTE, DOC, LINHA ETC.
					nRecLinha := nRecLanAtu				
				EndIf			
				
				If nRecLinha > 0
					/// SE JA EXISTE LAN«AMENTO IGUAL ALTERA A MESMA LINHA SOMANDO O VALOR.
					CT2->(dbGoTo(nRecLinha))
					nSaldo 		:= nSaldo + CT2->CT2_VALOR
					cLote		:= CT2->CT2_LOTE
					cSubLote	:= CT2->CT2_SBLOTE
					cDoc		:= CT2->CT2_DOC
					cLinha 		:= CT2->CT2_LINHA
					cSeqLan		:= CT2->CT2_SEQLAN
					nOpcGrv := 4
				EnDif	
			EndIf		
		
			cLinhaLan := cLinha ///SE HOUVER CONT. DE HISTORICO GRAVA CTZ NA LINHA DE LAN«AMENTO
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥GRAVA LANCAMENTO DE APURACAO NO CT2≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			aCols := { { "01", " ", nSaldo, "2", .F., nSaldo } }

			If lRpo1_1
				oSelf:SaveLog("MENSAGEM: GRAVA«√O DO LAN«AMENTO (01)" )
			Else		
				ProcLogAtu("MENSAGEM","GRAVA«√O DO LAN«AMENTO (01)" )
			EndIf	

			BEGIN TRANSACTION
			
			GravaLanc(dDataFLP,cLote,cSubLote,cDoc,@cLinha,cTipo,'01',cHP,cDebito,cCredito,;
					cCustoDeb,cCustoCrd,cItemDeb,cItemCrd,cClVlDeb,cClVlCrd,nSaldo,cDescHP,;
					TRB->TPSALDO,@cSeqLan,nOpcGrv,.F.,aCols,cEmpAnt,cFilAnt,,,,,,"CTBA211",.F., , ,dDataFLP,@nRecLan)
	
		 	lGravouLan := .T.
		 				
			If lRpo1_1
				oSelf:SaveLog("MENSAGEM: FIM DA GRAVA«√O DO LAN«AMENTO (01)")
			Else		
				ProcLogAtu("MENSAGEM","FIM DA GRAVA«√O DO LAN«AMENTO (01)" )
			EndIF	

			If lPontes		
				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥SE UTILIZAR CONTA PONTE ATUALIZA TABELA CTZ COM AS CONTAS DE ORIGEM≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				If lRpo1_1
					oSelf:SaveLog("MENSAGEM: GRAVA«√O DO CTZ (01)" )
				Else		
					ProcLogAtu("MENSAGEM","GRAVA«√O DO CTZ (01)" )
				EndIf	

				Ct211GrCTZ(dDataFLP,cLote,cSubLote,cDoc,cLinhaLan,"01",TRB->TPSALDO,;
					If(lCTZDeb,"1","2"),nVlrCTZ,TRB->CONTA,TRB->CUSTO,TRB->ITEM,TRB->CLVL)
					
				If nOpcGrv == 4	/// SE FOI ALTERACAO DE LANCAMENTO, RESTAURA PROXIMO "ORIGINAL"
					cLote		:= cLoteBak
					cSubLote	:= cSubBak
					cDoc		:= cDocBak
					cLinha		:= cLinBak
					cSeqLan		:= cSeqLBak
				Else			/// SE FOI INCLUSAO, GUARDA O REC. ATUAL P/ ALT. SE O PROX. FOR MESMA CHAVE
					nRecLanAtu	:= nRecLan
					cKeyEntAtu := '01'+TRB->TPSALDO+cDebito+cCredito+cCustoDeb+cCustoCrd+cItemDeb+cItemCrd+cClVlDeb+cClVlCrd							
				EndIf
				If lRpo1_1
					oSelf:SaveLog("MENSAGEM: FIM DA GRAVA«√O DO CTZ (01)" )
				Else		
					ProcLogAtu("MENSAGEM","FIM DA GRAVA«√O DO CTZ (01)" )
				EndIf	
			EndIf
			
			END TRANSACTION
			
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥ATUALIZA FLAG DE LUCROS E PERDAS (CTx_LP e CTx_DTLP)≥
			//≥NOS REGISTROS DE SALDO NO PERIODO.                  ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			If lRpo1_1
				oSelf:SaveLog("MENSAGEM: GRAVA«√O DA FLGLP (01)" )
			Else
				ProcLogAtu("MENSAGEM","GRAVA«√O DA FLGLP (01)" )
			EndIf	
			Ct211FlgLP(TRB->CONTA,TRB->CUSTO,TRB->ITEM,TRB->CLVL, dDataILP, TRB->TPSALDO, dDataFLP, TRB->MOEDA)
			If lRpo1_1
				oSelf:SaveLog("MENSAGEM: FIM DA GRAVA«√O DA FLGLP (01)" )
			Else	
				ProcLogAtu("MENSAGEM","FIM DA GRAVA«√O DA FLGLP (01)" )
			EndIf	

			If lRpo1_1
				oSelf:SaveLog("MENSAGEM: FINALIZANDO A INCLUSAO/ALTERACAO DOS LANCAMENTOS NO CT2 (01)")
			Else	
				ProcLogAtu("MENSAGEM","FINALIZANDO A INCLUSAO/ALTERACAO DOS LANCAMENTOS NO CT2 (01)" )
			EndIf	
				//////////////////////////////////////////////////////////////////////////////////////////
		Else	/// Grava Lancamento na moeda 0X com valor zerado na moeda 01
				//////////////////////////////////////////////////////////////////////////////////////////
			If lRpo1_1
				oSelf:SaveLog("MENSAGEM: INICIANDO A INCLUSAO/ALTERACAO DOS LANCAMENTOS NO CT2 ("+TRB->MOEDA+")" )
			Else	
				ProcLogAtu("MENSAGEM","INICIANDO A INCLUSAO/ALTERACAO DOS LANCAMENTOS NO CT2 ("+TRB->MOEDA+")" )
    		EndIf
    		
			If val(TRB->MOEDA) > 2
				nForaCols	:= VAL(TRB->MOEDA)-2
			Else                
				nForaCols	:= 0
			EndIf		
			
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥PREPARA VARIAVEIS PARA INCLUSAO/ALTERACAO DE LANCAMENTO NO CT2≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ	
		    nOpcGRV := 3
			If lPontes
				/// SE FOR APURACAO COM CONTA PONTE
				cLoteBak := cLote
				cSubBak	 := cSubLote
				cDocBak	 := cDoc
				cLinBak	 := cLinha
				cSeqLBak := cSeqLan			
	
				nVlrCTZ := nSaldo  							
				If cKeyEntAtu <> TRB->MOEDA+TRB->TPSALDO+cDebito+cCredito+cCustoDeb+cCustoCrd+cItemDeb+cItemCrd+cClVlDeb+cClVlCrd
	
					cKeyDocLP := DTOS(dDataFLP)+cLote+cSubLote+cDoc			
					If Len(__aDocsLP) <= 0 .or. Ascan(__aDocsLP, {|x| x[1] == cKeyDocLP }) <= 0
						aAdd(__aDocsLP, { cKeyDocLP , dDataFLP , cLote, cSubLote, cDoc } )
					EndIf
					/// VERIFICA DENTRO DOS LOTES/DOCS J¡ GERADOS NA APURACAO SE EXISTE LANCAMENTO IGUAL
					nRecLinha := Ct211Seek(__aDocsLP,TRB->MOEDA,TRB->TPSALDO,;
							cDebito,cCredito,cCustoDeb,cCustoCrd,cItemDeb,cItemCrd,cClVlDeb,cClVlCrd)
										   
					nRecLanAtu := nRecLinha
					cKeyEntAtu := TRB->MOEDA+TRB->TPSALDO+cDebito+cCredito+cCustoDeb+cCustoCrd+cItemDeb+cItemCrd+cClVlDeb+cClVlCrd							
				
				Else		/// ENQUANTO FOR A MESMA CHAVE DE ENTIDADES N√O PRECISA MODIFICAR LOTE, DOC, LINHA ETC.
					nRecLinha := nRecLanAtu				
				EndIf			
				
				If nRecLinha > 0
					/// SE JA EXISTE LAN«AMENTO IGUAL ALTERA A MESMA LINHA SOMANDO O VALOR.
					CT2->(dbGoTo(nRecLinha))
					nSaldo 		:= nSaldo + CT2->CT2_VALOR
					cLote		:= CT2->CT2_LOTE
					cSubLote	:= CT2->CT2_SBLOTE
					cDoc		:= CT2->CT2_DOC
					cLinha 		:= CT2->CT2_LINHA
					cSeqLan		:= CT2->CT2_SEQLAN
					nOpcGrv := 4
				EnDif	
			EndIf		
			
			cLinhaLan := cLinha ///SE HOUVER CONT. DE HISTORICO GRAVA CTZ NA LINHA DE LAN«AMENTO		
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥GRAVA LANCAMENTO DE APURACAO - RELATIVO A MOEDA 01 COM VALOR ZERADO≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ	
			aCols := { { "01", " ", 0.00, "2", .F., 0 },{ TRB->MOEDA, "4", nSaldo, "2", .F., nSaldo } }
	        
			BEGIN TRANSACTION
	
			If nOpcGrv <> 4	/// NAO PRECISA ALTERAR SE O VALOR NA MOEDA 01 … ZERO
				GravaLanc(dDataFLP,cLote,cSubLote,cDoc,@cLinha,cTipo,'01',cHP,cDebito,cCredito,;
					  cCustoDeb,cCustoCrd,cItemDeb,cItemCrd,cClVlDeb,cClVlCrd,0,cDescHP,;
					  TRB->TPSALDO,@cSeqLan,nOpcGrv,.F.,aCols,cEmpAnt,cFilAnt,0,,,,,"CTBA211",.F., , ,dDataFLP)
			EndIf
	        
			/// FUNCAO GRAVACTx AINDA ESTA GRAVANDO SALDO ANTERIOR INCORRETO QDO J¡ EXISTE LANC. NO DIA DE LP
			/// CHAMA A GRAVSALDO PARA ATUALIZAR OS ACUMULADOS CORRETAMENTE E 
			/// CHAMA REPROCESSAMENTO DO DIA DE APURACAO AO FINAL DO PROCESSAMENTO PARA ACERTAR SLD.ANTERIOR DO DIA.
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥	/// GRAVA SALDO RELATIVO AO LAN«AMENTO DE LUCROS E PERDAS (CTx_LP = 'Z')≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			CtbGravSaldo(cLote,cSubLote,cDoc,dDataFLP,cTipo,TRB->MOEDA,;
				cDebito,cCredito,;
				cCustoDeb,cCustoCrd,;
				cItemDeb,cItemCrd,;
				cClVlDeb,cClVlCrd,;
				nSaldo,TRB->TPSALDO,3,;
				cDebito,cCredito,;
				cCustoDeb,cCustoCrd,;
				cItemDeb,cItemCrd,;
				cClVlDeb,cClVlCrd,;			
				0,cTipo,TRB->TPSALDO,TRB->MOEDA,;			
				lCusto,lItem,lClVL,;
				,.T.,.F.,dDataFLP,;
				lGrvCT7,lGrvCT3,lGrvCT4,lGrvCTI,;
				lAtuSldCT7,lAtuSldCT3,lAtuSldCT4,lAtuSldCTI)
				  
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥GRAVA LANCAMENTO DE APURACAO NO CT2≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			cLinha := cLinhaLan			/// GRAVA LANCAMENTO DA MOEDA 0X NA MESMA LINHA DA MOEDA 01
			GravaLanc(dDataFLP,cLote,cSubLote,cDoc,@cLinha,cTipo,TRB->MOEDA,cHP,cDebito,cCredito,;
				  cCustoDeb,cCustoCrd,cItemDeb,cItemCrd,cClVlDeb,cClVlCrd,0,cDescHP,;
				  TRB->TPSALDO,@cSeqLan,nOpcGrv,.F.,aCols,cEmpAnt,cFilAnt,nForaCols,,,,,"CTBA211",.F.,,,dDataFLP,@nRecLan)
	
			If lPontes
				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥SE UTILIZAR CONTA PONTE ATUALIZA TABELA CTZ COM AS CONTAS DE ORIGEM≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				Ct211GrCTZ(dDataFLP,cLote,cSubLote,cDoc,cLinhaLan,TRB->MOEDA,TRB->TPSALDO,;
					If(lCTZDeb,"1","2"),nVlrCTZ,TRB->CONTA,TRB->CUSTO,TRB->ITEM,TRB->CLVL)
	
				If nOpcGrv == 4	/// SE FOI ALTERACAO DE LANCAMENTO, RESTAURA PROXIMO "ORIGINAL"
					cLote		:= cLoteBak
					cSubLote	:= cSubBak
					cDoc		:= cDocBak
					cLinha		:= cLinBak
					cSeqLan		:= cSeqLBak
				Else			/// SE FOI INCLUSAO, GUARDA O REC. ATUAL P/ ALT. SE O PROX. FOR MESMA CHAVE
					nRecLanAtu	:= nRecLan
									cKeyEntAtu := TRB->MOEDA+TRB->TPSALDO+cDebito+cCredito+cCustoDeb+cCustoCrd+cItemDeb+cItemCrd+cClVlDeb+cClVlCrd							
				EndIf
			EndIf
	
			END TRANSACTION
			
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥ATUALIZA FLAG DE LUCROS E PERDAS (CTx_LP e CTx_DTLP)≥
			//≥NOS REGISTROS DE SALDO NO PERIODO.                  ≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			Ct211FlgLP(TRB->CONTA,TRB->CUSTO,TRB->ITEM,TRB->CLVL, dDataILP, TRB->TPSALDO, dDataFLP, TRB->MOEDA)

			If lRpo1_1				  
				oSelf:SaveLog("MENSAGEM: FINALIZANDO A INCLUSAO/ALTERACAO DOS LANCAMENTOS NO CT2 ("+TRB->MOEDA+")" )
			Else	
				ProcLogAtu("MENSAGEM","FINALIZANDO A INCLUSAO/ALTERACAO DOS LANCAMENTOS NO CT2 ("+TRB->MOEDA+")" )
			EndIf	
				  
			lGravouLan := .T.			  
		EndIf
	EndIf

	If nExecLin <= 0 .or. nExecLin >= 2	/// Se houve quebra em 2 linhas (pois Deb e Cred estavam iguais) vai manter na mesma conta.
		If lRpo1_1
			oSelf:SaveLog("MENSAGEM: GRAVANDO FLAG DO PROCESSAMENTO" )
		Else	
			ProcLogAtu("MENSAGEM","GRAVANDO FLAG DO PROCESSAMENTO" )
		EndIf	

		RecLock("TRB",.F.)
		Field->JAPROC := "S"
		TRB->(MsUnlock())
	 
		TRB->(dbSkip())
		nExecLin := 0

		If lRpo1_1
			oSelf:SaveLog("MENSAGEM: FINALIZANDO A GRAVA«√O DO FLAG DO PROCESSAMENTO" )
		Else
			ProcLogAtu("MENSAGEM","FINALIZANDO A GRAVA«√O DO FLAG DO PROCESSAMENTO" )
		EndIf	
	EndIf		
EndDo
If lRpo1_1
	oSelf:SaveLog("MENSAGEM: FINAL DA LEITURA/GRAVA«√O DOS LAN«AMENTOS" )
Else
	ProcLogAtu("MENSAGEM","FINAL DA LEITURA/GRAVA«√O DOS LAN«AMENTOS" )
EndIf	

////////////////////////////////////////////////////////////////////////////////////////
//Atualiza tabela do SX5 com a data de apuracao, mesmo antes de reprocessar pois
//reprocessamento pode ser rodado posteriormente para ajuste dos saldos
//observaÁ„o, tem influencia no retorno da data de lucros e perdas anterior
//(para o intervalo de datas na marcaÁ„o dos flags _LP no reprocessamento).
Ct211AtSx5(dDataFLP,lMoedaEsp,cMoeda,nInicio,nFinal,cTpSaldo,lPontes)

If lGravouLan
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ ATUALIZA OS SALDOS COM DATA POSTERIOR AO L/P -REPROCESSAMENTO≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	//Verifico qual a data final a ser passada para o Reprocessamento.
	/// MANTIDA DATA DA APURACAO PARA N√O REPROCESSAR PERIODOS POSTERIORES
	//Ct211MaxDt(dDataFLP,@dDataFRep,cContaIni,cContaFim, cCustoIni, cCustoFim, cItemIni, cItemFim, cClVlIni, cClVlFim)
	
	//Caso exista algum ponto de entrada, o reprocessamento sera rodado a partir da data de apuracao para 
	//atualizar os saldos de todas as tabelas
	If lCtbCCLP .Or. lCtbItLP .Or. lCtbCVLP
		dDataIRep	:= dDataFLP
		If Empty(dDataFRep)
			dDataFRep	:= dDataIRep
		EndIf
	EndIf
	
	//Chamo o Reprocessamento, se tiver saldos com data posterior ao zeramento.
	//Somente atualizo os saldos basicos
	If ( mv_par28 == 1 ) .AND. (!Empty(dDataFRep) .Or. (lCtbCCLP .Or. lCtbItLP .Or. lCtbCVLP))
		If lRpo1_1
			oSelf:SaveLog("MENSAGEM: REPROCESSANDO OS SALDOS" )
		Else	
			ProcLogAtu("MENSAGEM","REPROCESSANDO OS SALDOS" )
		EndIf	
		CTBA190(.T.,dDataIRep,dDataFRep,cFilAnt,cFilAnt,cTpSaldo,lMoedaEsp,cMoeda)
		If lRpo1_1
			oSelf:SaveLog("MENSAGEM: FINALIZANDO O REPROCESSANDO OS SALDOS"  )
        Else
			ProcLogAtu("MENSAGEM","FINALIZANDO O REPROCESSANDO OS SALDOS" )
		EndIf	
	EndIf
EndIf

If lRpo1_1
	oSelf:SaveLog("MENSAGEM: APAGANDO O ARQUIVO DE TRABALHO" )
Else	
	ProcLogAtu("MENSAGEM","APAGANDO O ARQUIVO DE TRABALHO" )
EndIf	
///	APAGA O ARQUIVO DE TRABALHO
dbSelectArea("TRB")
dbCloseArea()
FErase(cArqIND1+OrdBagExt())
FErase(cArqIND2+OrdBagExt())
FErase(cArqTrb+GetDbExtension())
If lRpo1_1
	oSelf:SaveLog("MENSAGEM: FINALIZANDO - APAGANDO O ARQUIVO DE TRABALHO" )
Else
	ProcLogAtu("MENSAGEM","FINALIZANDO - APAGANDO O ARQUIVO DE TRABALHO" )
EndIf

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥Ct211CrTrb≥ Autor ≥ Marcos S. Lobo        ≥ Data ≥ 26.09.06 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥Cria arquivo de trabalho									  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥Ct211CrTrb()                                                ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥Ct211CrTrb()                                                ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/    

Static Function Ct211CrTrb(cNomeArq,lJaProc,lCriaTRB,lNovoTRB)

Local cTrb		:= ""
Local aCampos	:=  {}
Local aTamVlr	:= {}

Local cTitMsg 	:= ""
Local cMsg	  	:= ""

Local cCpoDeb 	:= ""
Local cCpoCrd 	:= ""
Local nInc		:= 0
Local nQtdEntid	:= If(FindFunction("CtbQtdEntd"),CtbQtdEntd(),4) //sao 4 entidades padroes -> conta /centro custo /item contabil/ classe de valor

aTamVlr := TamSX3("CT7_DEBITO")

aCampos := {{"IDENT"	,"C",3			,0},;
 		    {"CONTA" 	,"C",nTamCta	,0},;
 		    {"CUSTO" 	,"C",nTamCC		,0},;
 			{"ITEM"  	,"C",nTamItem	,0},;
 			{"CLVL" 	,"C",nTamClvl	,0},;
   			{"SALDOD"	,"N",aTamVlr[1]+2,aTamVlr[2]},;
   			{"SALDOC"	,"N",aTamVlr[1]+2,aTamVlr[2]},;
   			{"TPSALDO"	,"C",1			,0},;
			{"MOEDA"	,"C",2			,0},;
			{"JAPROC"	,"C",1			,0}}					 					 

// Inclui as novas entidades
For nInc := 1 To ( nQtdEntid - 4 )
    cCpoDeb := CtbCposCrDb("", "D", StrZero(nInc + 4,2)) 
	cCpoCrd := CtbCposCrDb("", "C", StrZero(nInc + 4,2))  

	aAdd( aCampos, { cCpoDeb, "C", 200, 0 } )
	aAdd( aCampos, { cCpoCrd, "C", 200, 0 } )
Next

If Empty(cArqTRB)
	cArqTRB := cNomeArq
EndIf
				
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
Endif

cArqIND1 := Left(cArqTRB,5)+Right(cArqTRB,2)+"A"
cArqIND2 := Left(cArqTRB,5)+Right(cArqTRB,2)+"B"

If lCriaTRB
	If File(cArqTrb+GetDbExtension())		/// SE ENCONTROU O ARQUIVO DE SALDOS FINAIS 
		cTitMsg := STR0023//"Arquivo de saldos finais j· existe."
		cMsg	:= STR0024+cArqTRB+GetDbExtension()+CHR(13)+CHR(10)         ///"Arquivo encontrado: "
		cMsg	+= STR0025//"Carregar novamente saldos ? "

		nRetMsg := Aviso(cTitMsg,cMsg, { STR0026,STR0027,STR0028 } )//"Sim"//"N„o"//"Sair"

		If nRetMsg == 1
			/// CASO A TRANSFER NCIA DE LANCAMENTOS J¡ TENHA SIDO INICIADA
			If lJaProc .and. !MsgNoYes(STR0029+chr(13)+chr(10)+STR0030,STR0031)//"Recalcular os saldos pode afetar os valores de apuracao, caso j· existam lanÁamentos de apuracao."//"Deseja Realmente continuar ?"//"A T E N C ƒ O !!!"
				Return .F.
			EndIf

			If FErase(cArqTrb+GetDbExtension()) < 0
				MsgAlert(STR0032+cArqTRB+GetDbExtension(),STR0033)//"N„o foi possÌvel excluir o arquivo: "//"Erro - Arquivo em uso ou travado."
				Return .F.
			EndIf			
			
			lNovoTRB := .T.					/// UTILIZA O ARQUIVO DE SALDOS J¡ CALCULADO (RECOMENDADO SE N√O TRANSFERIU LANCAMENTOS)
		ElseIf nRetMsg == 2	
			lNovoTRB := .F.
		Else 
			Return .F.
		EndIf
	EndIf
Else	
	If !File(cArqTrb+GetDbExtension())	
        
		cMsg := STR0034+cArqTRB+GetDbExtension()+STR0035+CHR(13)+CHR(10)+STR0036//"Arquivo de Saldos "//" n„o encontrado ! "//"Recalcular saldos e continuar ?"
		
		If lJaProc
			cMsg += CHR(13)+CHR(10)+STR0037//"(Recalcular os saldos finais podera afetar o valor de apuracao se j· foram movidos lanÁamentos)."
		EndIf

		nRetMsg := Aviso(STR0031,cMsg, { STR0026,STR0027 } )//"AtenÁ„o!!!"//"Sim"//"N„o"
		
		If nRetMsg == 1
			lNovoTRB := .T.
		Else
			Return .F.
		EndIf
	Else
		lNovoTRB := .F.
	EndIf
EndIf

If File(cArqIND1+OrdBagExt())
	FErase(cArqIND1+OrdBagExt())
EndIf
If File(cArqIND2+OrdBagExt())
	FErase(cArqIND2+OrdBagExt())
EndIf

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ11ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Crio arq. de trab. p/ gravar as inconsistencias.           ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ                                        
If lNovoTRB
	cTrb	:= CriaTrab(aCampos,.T.)
	
	While FRename(cTrb+GetDbExtension(),cArqTRB+GetDbExtension()) < 0
		If !MsgNoYes(STR0038+cArqTRB+GetDbExtension()+CHR(13)+STR0039,STR0040)//"N„o foi possivel criar o arquivo: "// " Tentar novamente ?"//"Erro - Arquivo em uso ou travado."
			Return .F.
		EndIf
	EndDo
EndIf

dbUseArea(.T.,,cArqTrb,"TRB",.T.,.F.)

IndRegua("TRB", cArqIND1, "TPSALDO+MOEDA+CONTA+CUSTO+ITEM+CLVL+IDENT",,, "Index...")
IndRegua("TRB", cArqIND2, "TPSALDO+MOEDA+IDENT+CONTA+CUSTO+ITEM+CLVL",,, "Index...")
dbClearIndex()
dbSetIndex(cArqIND1+OrdBagExt())
dbSetIndex(cArqIND2+OrdBagExt())

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥CTB211GTRB≥ Autor ≥ Marcos S. Lobo        ≥ Data ≥ 26.09.06 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥Verifico os Saldos e Grava no Arquivo de Trabalho			  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥CTB211GTRB()                                                ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ CTBA211                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static FUNCTION CTB211GTRB(cAlias,dDataILP,dDataFLP,aTpSaldos,oObj,lCusto,lItem,lClvl,aFilters,lSaldo,lMoedaEsp,cMoedaEsp,oSelf)

Local lObj := ValType(oObj) == "O"

Local nRecno	:=	0
Local nTotRegua	:= ((cAlias)->(Reccount()))
Local cConta 	:= SPACE(nTamCta)
Local cCusto 	:= SPACE(nTamCC)
Local cItem  	:= SPACE(nTamItem)
Local cClVl		:= SPACE(nTamClVl)

Local nMoedAtu	:= 1
Local cMoedAtu	:= "01"
Local nTpSldAtu	:= 1
Local cTpSldAtu	:= "1"

Local aSldAnt	:= {}
Local aSldAtu	:= {}
Local nDebTrb	:= 0 
Local nCrdTrb	:= 0
Local nTrbSlD	:= 0
Local nTrbSlC	:= 0
Local cKeyAtu	:= ""

Local lFiltra	:= ValType(aFilters) == "A"
Local lFilCT	:= .F.
Local lFilCC	:= .F.
Local lFilIT	:= .F.
Local lFilCL	:= .F.
Local lRpo1_1		:= Iif(AdmGetRpo("R1.1") == .T.,.T.,.F.) 
Local lVai		:= .F.
Local lApZero	:= GetNewPar( "MV_CTAPMVZ" , .T. )

DEFAULT lSaldo  := .F.			/// PADRAO .F. OBTEM MOVIMENTO / .T. OBTEM SALDO
DEFAULT dDataILP:= CTOD("01/01/80")-1

If lFiltra
	lFilCT := Len(aFilters) >= 1 .and. Len(aFilters[1]) >= 3 .and. (!Empty(aFilters[1][2]) .or. !Empty(aFilters[1][3]) )
	lFilCC := Len(aFilters) >= 2 .and. Len(aFilters[2]) >= 3 .and. (!Empty(aFilters[2][2]) .or. !Empty(aFilters[2][3]) )
	lFilIT := Len(aFilters) >= 3 .and. Len(aFilters[3]) >= 3 .and. (!Empty(aFilters[3][2]) .or. !Empty(aFilters[3][3]) )
	lFilCL := Len(aFilters) >= 4 .and. Len(aFilters[3]) >= 3 .and. (!Empty(aFilters[4][2]) .or. !Empty(aFilters[4][3]) )
EndIf

dbSelectArea(cAlias)
dbSetOrder(2)
cFilAlias := xFilial(cAlias)



If !lMoedaEsp
	//// FAZ O PROCESSAMENTO PARA TODAS AS MOEDAS
	nMoedaIni := 1
Else
	/// SE FOR MOEDA ESPECÕFICA INICIA PELA MOEDA INDICADA
	nMoedaIni := Val(cMoedaEsp)
EndIf

For nMoedAtu := nMoedaIni to __nQuantas
	cMoedAtu := STRZERO(nMoedAtu,2)

	//// FAZ O PROCESSAMENTO PARA TODOS OS TIPOS DE SALDOS
	For nTpSldAtu := 1 to Len(aTpSaldos)
		// cTpSldAtu := STRZERO(nTpSldAtu,1)
		//
		cTpSldAtu := aTpSaldos[nTpSldAtu]

		If lObj
			oObj:SetRegua2(nTotRegua)			 				
		ElseIf lRpo1_1
			oSelf:SetRegua1(nTotRegua)	
		EndIf
		
		If lFilCT
			MsSeek(cFilAlias+aFilters[1][2],.T.) //Procuro pela primeira conta a ser zerada
		Else
			MsSeek(cFilAlias,.T.) //Procuro pela primeira conta a ser zerada		
		EndIf
		
		While (cAlias)->(!Eof()) .And. (cAlias)->&(cAlias+"_FILIAL") == cFilAlias .and. (If(lFilCT,(cAlias)->&(cAlias+"_CONTA") <= aFilters[1][3],.T.))

			If lObj
				oObj:IncRegua2(OemToAnsi(STR0019+cMoedAtu+STR0020+cTpSldAtu))//#"Passo 1 -> Obtendo Saldos... Moeda "//" Saldo " 
			ElseIf lRpo1_1
				oSelf:IncRegua1(OemToAnsi(STR0019+cMoedAtu+STR0020+cTpSldAtu))//#"Passo 1 -> Obtendo Saldos... Moeda "//" Saldo " 
			EndIf
				
			If cAlias == 'CTI'			
				cChave := CTI->(CTI_CONTA+CTI_CUSTO+CTI_ITEM+CTI_CLVL)
				cConta := CTI->CTI_CONTA
				cCusto := CTI->CTI_CUSTO
				cItem  := CTI->CTI_ITEM
				cClVl  := CTI->CTI_CLVL
			ElseIf cAlias == 'CT4'
				cChave := CT4->(CT4_CONTA+CT4_CUSTO+CT4_ITEM)
				cConta := CT4->CT4_CONTA
				cCusto := CT4->CT4_CUSTO
				cItem  := CT4->CT4_ITEM
			ElseIf cAlias == 'CT3'       
				cChave := CT3->(CT3_CONTA+CT3_CUSTO)
				cConta := CT3->CT3_CONTA
				cCusto := CT3->CT3_CUSTO
			ElseIf cAlias == 'CT7'
				cChave := CT7->CT7_CONTA
				cConta := CT7->CT7_CONTA
			EndIf

			cNxtChav:= IncLast(cChave)		/// DETERMINA A PROXIMA CHAVE DE PESQUISA COM O CODIGO DAS ENTIDADES
			
			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//≥Avalia filtro das entidades para apuracao≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ			
			If cAlias == 'CTI'
				If lFilCT
					If CTI->CTI_CONTA < aFilters[1][2] .or. CTI->CTI_CONTA > aFilters[1][3]
						dbSelectArea(cAlias)
						(cAlias)->(MsSeek(cFilAlias+cNxtChav,.T.))		
						Loop
					EndIf
				EndIf
				If lFilCC
					If CTI->CTI_CUSTO < aFilters[2][2] .or. CTI->CTI_CUSTO > aFilters[2][3]
						dbSelectArea(cAlias)
						(cAlias)->(MsSeek(cFilAlias+cNxtChav,.T.))		
						Loop
					EndIf
				EndIf
				If lFilIT
					If CTI->CTI_ITEM < aFilters[3][2] .or. CTI->CTI_ITEM > aFilters[3][3]
						dbSelectArea(cAlias)
						(cAlias)->(MsSeek(cFilAlias+cNxtChav,.T.))		
						Loop
					EndIf
				EndIf
				If lFilCL
					If CTI->CTI_CLVL < aFilters[4][2] .or. CTI->CTI_CLVL > aFilters[4][3]
						dbSelectArea(cAlias)
						(cAlias)->(MsSeek(cFilAlias+cNxtChav,.T.))		
						Loop
					EndIf
				EndIf
				
			ElseIf cAlias == 'CT4'
				If lFilCT
					If CT4->CT4_CONTA < aFilters[1][2] .or. CT4->CT4_CONTA > aFilters[1][3]
						dbSelectArea(cAlias)
						(cAlias)->(MsSeek(cFilAlias+cNxtChav,.T.))		
						Loop
					EndIf
				EndIf
				If lFilCC
					If CT4->CT4_CUSTO < aFilters[2][2] .or. CT4->CT4_CUSTO > aFilters[2][3]
						dbSelectArea(cAlias)
						(cAlias)->(MsSeek(cFilAlias+cNxtChav,.T.))		
						Loop
					EndIf
				EndIf
				If lFilIT
					If CT4->CT4_ITEM < aFilters[3][2] .or. CT4->CT4_ITEM > aFilters[3][3]
						dbSelectArea(cAlias)
						(cAlias)->(MsSeek(cFilAlias+cNxtChav,.T.))		
						Loop
					EndIf
				EndIf

			ElseIf cAlias == 'CT3'
				If lFilCT
					If CT3->CT3_CONTA < aFilters[1][2] .or. CT3->CT3_CONTA > aFilters[1][3]
						dbSelectArea(cAlias)
						(cAlias)->(MsSeek(cFilAlias+cNxtChav,.T.))		
						Loop
					EndIf
				EndIf
				If lFilCC
					If CT3->CT3_CUSTO < aFilters[2][2] .or. CT3->CT3_CUSTO > aFilters[2][3]
						dbSelectArea(cAlias)
						(cAlias)->(MsSeek(cFilAlias+cNxtChav,.T.))		
						Loop
					EndIf
				EndIf

			ElseIf cAlias == 'CT7'
				If lFilCT
					If CT7->CT7_CONTA < aFilters[1][2] .or. CT7->CT7_CONTA > aFilters[1][3]
						dbSelectArea(cAlias)
						(cAlias)->(MsSeek(cFilAlias+cNxtChav,.T.))		
						Loop
					EndIf
				EndIf

			EndIf			

			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒT‚
			//≥Apos filtragem , obtem saldos ate a data.≥
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒT‚
			If cAlias == 'CTI'
				If !lSaldo
					aSldAnt	:= SaldoCTI(cConta,cCusto,cItem,cClVL,dDataILP,cMoedAtu,cTpSldAtu,'CTBXFUN',.F.)	
				EndIf
				aSldAtu	:= SaldoCTI(cConta,cCusto,cItem,cClVL,dDataFLP,cMoedAtu,cTpSldAtu,'CTBXFUN',.F.)	
			ElseIf cAlias == 'CT4'
				If !lSaldo
					aSldAnt	:= SaldoCT4(cConta,cCusto,cItem,dDataILP,cMoedAtu,cTpSldAtu,'CTBXFUN',.F.)	
				EndIf
				aSldAtu	:= SaldoCT4(cConta,cCusto,cItem,dDataFLP,cMoedAtu,cTpSldAtu,'CTBXFUN',.F.)	
			ElseIf cAlias == 'CT3'
				If !lSaldo
					aSldAnt	:= SaldoCT3(cConta,cCusto,dDataILP,cMoedAtu,cTpSldAtu,'CTBXFUN',.F.)		
				EndIf
				aSldAtu	:= SaldoCT3(cConta,cCusto,dDataFLP,cMoedAtu,cTpSldAtu,'CTBXFUN',.F.)		
			ElseIf cAlias == 'CT7'
				If !lSaldo
					aSldAnt	:= SaldoCT7(cConta,dDataILP,cMoedAtu,cTpSldAtu,'CTBXFUN',.F.)		
				EndIf
				aSldAtu	:= SaldoCT7(cConta,dDataFLP,cMoedAtu,cTpSldAtu,'CTBXFUN',.F.)		
			EndIf			
		
			nTrbSlD := 0
			nTrbSlC := 0
			dbSelectArea("TRB")
			dbSetOrder(2)

			lVai := .F.
			If lSaldo								/// SE FOR APURACAO PELO SALDO
				If aSldAtu[1] <> 0 					/// SE HOUVER SALDO
					lVai := .T.
				EndIf
			Else
				If ( aSldAtu[4] - aSldAnt[4]) <> 0 .or. (aSldAtu[5] - aSldAnt[5] <> 0  )     /// SE HOUVER MOVIMENTO
					IF !lApZero 
						lVai := ( (( aSldAtu[4] - aSldAnt[4]) - (aSldAtu[5] - aSldAnt[5] ) ) <> 0 )
					Else
					    lVai := .T.
					Endif
				EndIf
			EndIf

			If lVai
				If cAlias == "CT4" //.or. (cAlias == "CT3" .and. !lItem)
					If lClvl
						cKeyAtu := cTpSldAtu+cMoedAtu+"CTI"+cConta+cCusto+cItem
						If dbSeek(cKeyAtu,.F.)
							While TRB->(!Eof()) .and. cKeyAtu == TRB->(TPSALDO+MOEDA+IDENT+CONTA+CUSTO+ITEM)
								nTrbSlD += TRB->SALDOD
								nTrbSlC += TRB->SALDOC
								TRB->(dbSkip())
							EndDo					
						EndIf					
					EndIf
				ElseIf cAlias == "CT3" //.or. (cAlias == "CT7" .and. !lCusto)
					If lItem
						cKeyAtu := cTpSldAtu+cMoedAtu+"CT4"+cConta+cCusto
						If dbSeek(cKeyAtu,.F.)
							While TRB->(!Eof()) .and. cKeyAtu == TRB->(TPSALDO+MOEDA+IDENT+CONTA+CUSTO)
								nTrbSlD += TRB->SALDOD
								nTrbSlC += TRB->SALDOC
								TRB->(dbSkip())
							EndDo					
						EndIf
					EndIf

					/// SE N√O LOCALIZOU CHAVE NO CT4 VERIFICA SE H¡ NO CTI
					If lClvl
						cKeyAtu := cTpSldAtu+cMoedAtu+"CTI"+cConta+cCusto
						If dbSeek(cKeyAtu,.F.)
							While TRB->(!Eof()) .and. cKeyAtu == TRB->(TPSALDO+MOEDA+IDENT+CONTA+CUSTO)
								nTrbSlD += TRB->SALDOD
								nTrbSlC += TRB->SALDOC
								TRB->(dbSkip())
							EndDo					
						EndIf										
					EndIf
				ElseIf cAlias == "CT7"				
					If lCusto
						cKeyAtu := cTpSldAtu+cMoedAtu+"CT3"+cConta
						If dbSeek(cKeyAtu,.F.)
							While TRB->(!Eof()) .and. cKeyAtu == TRB->(TPSALDO+MOEDA+IDENT+CONTA)
								nTrbSlD += TRB->SALDOD
								nTrbSlC += TRB->SALDOC
								TRB->(dbSkip())
							EndDo					
						EndIf
					EndIf
					/// SE N√O LOCALIZOU CHAVE NO CT3 VERIFICA SE H¡ NO CT4
					If lItem
						cKeyAtu := cTpSldAtu+cMoedAtu+"CT4"+cConta
						If dbSeek(cKeyAtu,.F.)
							While TRB->(!Eof()) .and. cKeyAtu == TRB->(TPSALDO+MOEDA+IDENT+CONTA)
								nTrbSlD += TRB->SALDOD
								nTrbSlC += TRB->SALDOC
								TRB->(dbSkip())
							EndDo					
						EndIf
					EndIf
					
					/// SE N√O LOCALIZOU CHAVE NO CT4 VERIFICA SE H¡ NO CTI
					If lClvl
						cKeyAtu := cTpSldAtu+cMoedAtu+"CTI"+cConta
						If dbSeek(cKeyAtu,.F.)
							While TRB->(!Eof()) .and. cKeyAtu == TRB->(TPSALDO+MOEDA+IDENT+CONTA)
								nTrbSlD += TRB->SALDOD
								nTrbSlC += TRB->SALDOC
								TRB->(dbSkip())
							EndDo					
						EndIf					
					EndIf
				EndIf

				/// CALCULA OS VALORES A DEBITO E A CREDITO PARA LANCAMENTO
				/// ABATENDO OS VALORES J¡ LAN«ADOS COM OUTRAS ENTIDADES
				If lSaldo
					nDebTrb := ABS(aSldAtu[4]) - nTrbSlD
					nCrdTrb := ABS(aSldAtu[5]) - nTrbSlC
				Else
					nDebTrb := (ABS(aSldAtu[4]) - ABS(aSldAnt[4])) - nTrbSlD
					nCrdTrb := (ABS(aSldAtu[5]) - ABS(aSldAnt[5])) - nTrbSlC				
				EndIf

				dbSelectArea("TRB")
				dbSetOrder(1)
				If (nDebTrb <> 0 .or. nCrdTrb <> 0) .and. !dbSeek(cTpSldAtu+cMoedAtu+cConta+cCusto+cItem+cClvl+cAlias,.F.)
					dbSetOrder(2)
					RecLock("TRB",.T.)
					Field->TPSALDO	:= cTpSldAtu
					Field->MOEDA	:= cMoedAtu
					Field->CONTA	:= cConta
					Field->CUSTO	:= cCusto
					Field->ITEM		:= cItem
					Field->CLVL		:= cClVL
					Field->IDENT	:= cAlias
					Field->SALDOD	:= ABS(nDebTrb)
					Field->SALDOC	:= ABS(nCrdTrb)
					TRB->(MsUnlock())
				EndIf
			EndIf
	
			dbSelectArea(cAlias)
			(cAlias)->(MsSeek(cFilAlias+cNxtChav,.T.))		
		EndDo
	Next nTpSldAtu
	If lMoedaEsp		/// SE FOR MOEDA ESPECÕFICA ENCERRA AO FINAL DA 1™ PASSAGEM (FOR NEXT)
		nMoedAtu := __nQuantas
		Exit
	Endif
Next nMoedAtu

Return
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥Ct211ValIt≥ Autor ≥ Simone Mie Sato       ≥ Data ≥ 22.01.02 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥Verifica se o item ponte e item L/P estao preenchidos.      ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥Ct211ValIt()                                                ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ Ct211ValIt()                                               ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static FUNCTION Ct211ValIt(cItem,cItemPon,cItemLp,lPontes,lItemOk,lCadastro)  

Local aSaveArea	:= GetArea()

dbSelectArea("CTD")
dbSetOrder(1)
If lCadastro	//Se utiliza item ponte/LP do Cadastro de Item.
	MsSeek(xFilial("CTD")+cItem)
	If Found()
		If	lPontes .And. Empty(CTD->CTD_ITPON)
			lItemOk 	:= .F.
		ElseIf Empty(CTD->CTD_ITLP)
			lItemOk 	:= .T.
			cItemPon	:= CTD->CTD_ITPON
			cItemLP		:= cItem
		Else
			lItemOk 	:= .T.
			cItemPon	:= CTD->CTD_ITPON
			cItemLP		:= CTD->CTD_ITLP
		Endif		
	Endif
Else
	If lPontes
		If Subs(CTD->CTD_ITPON,1,1) = "*"
			lItemOk	:= .F.
		EndIf
		MsSeek(xFilial("CTD")+cItemPon)	
	Else
		If Subs(CTD->CTD_ITLP,1,1) = "*"
			lItemOk	:= .F.    
		EndIf	
		MsSeek(xFilial("CTD")+cItemLP)			
	EndIf

	If lItemOk .And. !Found() 
		lItemOk		:= .F.    
	EndIf	
EndIf

RestArea(aSaveArea)

Return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥Ct211ValCC≥ Autor ≥ Simone Mie Sato       ≥ Data ≥ 02.01.02 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥Verifica se o C.C. ponte e C.C. L/P estao preenchidos.      ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥Ct211ValCC()                                                ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ Ct211ValCC()                                               ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static FUNCTION Ct211ValCC(cCusto,cCCPon,cCCLp,lPontes,lCCOk,lCadastro)  

Local aSaveArea	:= GetArea()

dbSelectArea("CTT")
dbSetOrder(1)
If lCadastro//Se utiliza c.cust Ponte/LP do Cadastro de Centro de Custo
	MsSeek(xFilial("CTT")+cCusto)
	If Found()
		If lPontes .And. Empty(CTT->CTT_CCPON)
			lCCOk 		:= .F.
		ElseIf Empty(CTT->CTT_CCLP)
			lCCOk		:= .T.
			cCCPon 		:= CTT->CTT_CCPON
			cCCLP		:= cCusto		
		Else
			lCCOk		:= .T.
			cCCPon 		:= CTT->CTT_CCPON
			cCCLP		:= CTT->CTT_CCLP
		Endif
	Endif
Else
	If lPontes
		If Subs(CTT->CTT_CCPON,1,1) = "*"
			lCCOk		:= .F.
		EndIf
		MsSeek(xFilial("CTT")+cCCPon)
	Else
		If Subs(CTT->CTT_CCLP,1,1) = "*"
			lCCOk		:= .F.
		EndIf
		MsSeek(xFilial("CTT")+cCCLP)
	EndIf
	If lCCOk .And. !Found()
		lCCOk	:= .F.        
	EndIf
EndIf

RestArea(aSaveArea)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥Ct211ValCV≥ Autor ≥ Simone Mie Sato       ≥ Data ≥ 02.01.02 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥Verifica se a Cl.Vlr Ponte e Cl.Vlr LP estao preenchidos.   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥Ct211ValCV()                                                ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ Ct211ValCV()                                               ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static FUNCTION Ct211ValCV(cClVl,cClVlPon,cClVlLP,lPontes,lClVlOk,lCadastro)  

Local aSaveArea	:= GetArea()

dbSelectArea("CTH")
dbsetOrder(1)
MsSeek(xFilial("CTH")+cClVl)

If lCadastro//Se utiliza Cl.Valor Ponte/LP do Cadastro de Cl.Valor
	If Found()
		If	lPontes .And. Empty(CTH->CTH_CLPON)
			lClVlOk 	:= .F.
		ElseIf Empty(CTH->CTH_CLVLLP)
			lClVlOk 	:= .T.
			cClVlPon	:= CTH->CTH_CLPON
			cClVlLP		:= cClVl
		Else
			lClVlOk 	:= .T.
			cClVlPon	:= CTH->CTH_CLPON
			cClVlLP		:= CTH->CTH_CLVLLP
		Endif
	Endif
Else
	If lPontes                		
		If Subs(CTH->CTH_CLPON,1,1) = "*" 
			lClVlOk		:= .F.					
		EndIf
		MsSeek(xFilial("CTH")+cClVlPon)		
	Else                                   
		If Subs(CTH->CTH_CLVLLP,1,1) = "*" 
			lClVlOk		:= .F.					
		EndIf	
		MsSeek(xFilial("CTH")+cClVlLP)	
	EndIf            
	If lClVlOk .And. !Found()
		lClVlOk	:= .F.        
	EndIf
EndIf

RestArea(aSaveArea)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥Ct211ValCt≥ Autor ≥ Simone Mie Sato       ≥ Data ≥ 02.01.02 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥Verifica se a Conta Ponte e Conta LP estao preenchidas.     ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥Ct211ValCt()                                                ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ Ct211ValCt()                                               ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static FUNCTION Ct211ValCt(cConta,cCtaPon,cDigPon,cCtaLP,cDigLP,lPontes,lCtaOk,aCriter,aCritPon,aCritLP,lCadastro)  

Local aSaveArea	:= GetArea()
Local nMoedas	:= __nQuantas
Local nCont

dbSelectArea("CT1")
dbsetOrder(1)
MsSeek(xFilial("CT1")+cConta)
If lCadastro	//Se utiliza Conta Ponte/LP do Cadastro de Plano de Contas
	If Found()
		If	(Empty(CT1->CT1_CTALP)  .Or. ;
			(lPontes .And. Empty(CT1->CT1_CTAPON)))
			lCtaOk 	:= .F.
		Else
			lCtaOk 	:= .T.
			cCtaPon	:= CT1->CT1_CTAPON
			cCtaLP 	:= CT1->CT1_CTALP
		Endif
	Endif
Else 
	If lPontes
		If Subs(CT1->CT1_CTAPON,1,1) == "*"
			lCtaOk	:= .F.                 
		EndIf		
		MsSeek(xFilial("CT1")+cCtaPon)			
	Else
		If Subs(CT1->CT1_CTALP,1,1) == "*"
			lCtaOk	:= .F.
		EndIf			
		MsSeek(xFilial("CT1")+cCtaLP)
	EndIf    
	
	If lCtaOk .And. !Found()
		lCtaOk	:= .F.    
	EndIF
	
EndIf
	
If lCtaOk
	For nCont := 1 to (nMoedas-1)        
		AADD(aCriter,&("CT1->CT1_CVD"+StrZero(nCont+1,2)))
	Next
			
	MsSeek(xFilial("CT1")+cCtaPon)		
	cDigPon := CT1->CT1_DC
	For nCont := 1 to (nMoedas-1)
		AADD(aCritPon,&("CT1->CT1_CVD"+StrZero(nCont+1,2)))
	Next
		
	MsSeek(xFilial("CT1")+cCtaLP)
	cDigLP	:= CT1->CT1_DC          
	For nCont := 1 to (nMoedas-1)
		AADD(aCritLP,&("CT1->CT1_CVD"+StrZero(nCont+1,2)))
	Next		
EndIf		

RestArea(aSaveArea)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥Ct211AtSX5≥ Autor ≥ Simone Mie Sato       ≥ Data ≥ 11.01.02 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥Atualizo a tabela do SX5.                                   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥Ct211AtSX5(dDataFLP)                                         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥Ct211AtSX5()                                                ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static FUNCTION Ct211AtSX5(dDataFLP,lMoedaEsp,cMoeda,nInicio,nFinal,cTpSaldo,lPontes)

Local aSaveArea	:= GetArea()
Local cChave	:= cEmpAnt+cFilant
Local cCampo	:= ""
Local lExiste	:= .F.                                        
Local nContad
Local cChar		:= ""

Do Case 
Case __LANGUAGE == "PORTUGUESE"
	cCampo	:= "SX5->X5_DESCRI"
Case __LANGUAGE == "SPANISH"
	cCampo	:= "SX5->X5_DESCSPA"
Case __LANGUAGE ="ENGLISH"
	cCampo	:= "SX5->X5_DESCENG"
EndCase

If lPontes
	cChar	:= "P"
Else
	cChar	:= "Z"
EndIf

dbSelectArea("SX5")
dbSetOrder(1)

For nContad	:= nInicio to nFinal             

	If !MsSeek(xFilial()+'LP'+cChave)	
		Reclock("SX5",.T.)
		SX5->X5_FILIAL := xFilial()
		SX5->X5_TABELA	:= 'LP'
		SX5->X5_CHAVE	:= cChave 
		&(cCampo)		:= Dtos(dDataFLP)+StrZero(nContad,2)+cTpSaldo+cChar
		MsUnlock()	                             		
	Else
		While !Eof() .And. SX5->X5_FILIAL == xFilial() .And. SX5->X5_TABELA = 'LP' .And. ;
			Subs(SX5->X5_CHAVE,1,4) == cChave				

   			If Subs(&(cCampo),1,8) == Dtos(dDataFLP)
				If lMoedaEsp .And. (Subs(&(cCampo),9,2) == cMoeda) .And. Subs(&(cCampo),11,1) = cTpSaldo .And. Subs(&(cCampo),12,1) == cChar
					lExiste	:= .T.                               
				ElseIf !lMoedaEsp .And. (Subs(&(cCampo),9,2) == StrZero(nContad,2)).And. Subs(&(cCampo),11,1) = cTpSaldo  .And. Subs(&(cCampo),12,1) == cChar
					lExiste	:= .T.				
				EndIf
			EndIf  			   			
			
			If !lExiste		
				Reclock("SX5",.T.)	
				SX5->X5_FILIAL := xFilial()
				SX5->X5_TABELA	:= 'LP'
				SX5->X5_CHAVE	:= cChave 			
				If lMoedaEsp                                                    
					&(cCampo)	:= Dtos(dDataFLP)+cMoeda+cTpSaldo+cChar
				Else
					&(cCampo)	:= Dtos(dDataFLP)+StrZero(nContad,2)+cTpSaldo+cChar			
				EndIf
				MsUnlock()    		
			EndIf    													
			dbSkip()	 
		End	    
	EndIf
Next

RestArea(aSaveArea)

Return

/*/      	
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥Ct211UpdX5≥ Autor ≥ Simone Mie Sato       ≥ Data ≥ 05.04.05 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥Atualiza o SX5 indicando se eh zeram. c/cta ponte ou nao.   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ Ct211UpdX5()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ SIGACTB                                                    ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function Ct211UpdX5()

Local aSaveArea	:= GetArea()

Local cQuery	:= ""
Local Ct211UpdX5:= ""
Local cChar		:= ""           
Local cCampo	:= ""

Local dDataFLP	:= CTOD("  /  /  ")

Local cLote		:= ""
Local cSubLote	:= ""
Local cDoc		:= ""
Local cTpSald	:= ""
Local cEmpOri	:= ""
Local cFilOri	:= ""
Local cMoeda	:= ""           

Do Case 
Case __LANGUAGE == "PORTUGUESE"
	cCampo	:= "SX5->X5_DESCRI"
Case __LANGUAGE == "SPANISH"
	cCampo	:= "SX5->X5_DESCSPA"
Case __LANGUAGE ="ENGLISH"
	cCampo	:= "SX5->X5_DESCENG"
EndCase              
          
dbSelectArea("SX5")
dbSetOrder(1)
If MsSeek(xFilial()+"LP")
	cChar	:= Subs(&(cCampo),12,1)	
	If cChar $ "P/Z"	
		Return	
	EndIf
EndIf

#IFDEF TOP
	If ( TcSrvType()!="AS/400" )
	                               
		//DATAS DE APURACAO COM CONTA PONTE
		 
		Ct211UpdX5	:= "Ct211UpdX5"

		cQuery := "SELECT DISTINCT CT2_FILIAL, CT2_DTLP, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_TPSALD, "
		cQuery += " CT2_EMPORI, CT2_FILORI, CT2_MOEDLC "
		cQuery += " FROM "+RetSqlName("CT2")
		cQuery += " WHERE D_E_L_E_T_ = ' ' "
		cQuery += " AND CT2_FILIAL = '"+xFilial("CT2")+"' "
		cQuery += " AND CT2_DTLP <> ' ' "
		cQuery += " ORDER BY CT2_FILIAL, CT2_DTLP, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_TPSALD, CT2_EMPORI, CT2_FILORI, CT2_MOEDLC "
		cQuery := ChangeQuery(cQuery)		   		
		
			
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),Ct211UpdX5,.T.,.F.)
					
		TCSetField(Ct211UpdX5,"CT2_DTLP", "D",8,0)				  		
		
		dbSelectArea("Ct211UpdX5")			
		While !Eof()             
			dDataFLp	:= (Ct211UpdX5)->CT2_DTLP
			cLote	:= (Ct211UpdX5)->CT2_LOTE
			cSubLote:= (Ct211UpdX5)->CT2_SBLOTE
			cDoc	:= (Ct211UpdX5)->CT2_DOC
			cTpSald	:= (Ct211UpdX5)->CT2_TPSALD
			cEmpOri	:= (Ct211UpdX5)->CT2_EMPORI
			cFilOri	:= (Ct211UpdX5)->CT2_FILORI			
			cMoeda	:= (Ct211UpdX5)->CT2_MOEDLC
		                
		    dbSelectArea("CTZ")
		    dbSetOrder(1)
		    If MsSeek(xFilial()+DTOS(dDataFLP)+cLote+cSubLote+cDoc+cTpSald+cEmpOri+cFilOri+cMoeda)
		    	cChar	:= "P"	//Indica que eh apuracao com conta ponte
		    Else
		    	cChar	:= "Z"	//Indica que eh apuracao com zeramento de receita/despesa
			EndIf		    
		    
			BEGIN TRANSACTION
			dbSelectArea("SX5")
			dbSetOrder(1)
			If MsSeek(xFilial()+"LP"+cEmpAnt+cFilAnt)	//FILIAL+TABELA+CHAVE
				While !Eof() .And. SX5->X5_TABELA == "LP" .And. Subs(SX5->X5_CHAVE,1,2) == cEmpAnt ;
					.And. Subs(SX5->X5_CHAVE,3,2) == cFilAnt
					If Subs(&(cCampo),1,8) == DTOS(dDataFLP) .And. Subs(&(cCampo),9,2) == cMoeda .And. ;
						Subs(&(cCampo),11,1) == cTpSald 
						If Subs(&(cCampo),12,1) == " "  						
							RecLock("SX5",.F.)
							&(cCampo)	:= DTOS(dDataFLP)+cMoeda+cTpSald+cChar
            	            MsUnlock()
       					ElseIf Subs(&(cCampo),12,1) <> "" .And. Subs(&(cCampo),12,1) <> cChar
       						RecLock("SX5",.T.)
							SX5->X5_FILIAL 	:= xFilial()
							SX5->X5_TABELA	:= 'LP'
							SX5->X5_CHAVE	:= cEmpAnt+cFilAnt
							&(cCampo)		:= DTOS(dDataFLP)+cMoeda+cTpSald+cChar
							MsUnlock()
						EndIf       						
   					Endif         
   					dbSelectArea("SX5")					
					dbSkip()
				End			
		    EndIf
		    END TRANSACTION
		    dbSelectarea("Ct211UpdX5")
			dbSkip()
		End		
		dbSelectArea ( "Ct211UpdX5" )
		dbCloseArea ()
	Else
#ENDIF
		dbSelectArea("SX5")
		dbSetOrder(1)
		If MsSeek(xFilial()+"LP"+cEmpAnt+cFilAnt)
			While !Eof() .And. SX5->X5_FILIAL == xFilial() .And. SX5->X5_TABELA == "LP" .And. ;
				Subs(SX5->X5_CHAVE,1,2)== cEmpAnt .And. Subs(SX5->X5_CHAVE,3,2) == cFilAnt
				
				dDataFLP	:= STOD(Subs(&(cCampo),1,8))
				cMoeda	:= Subs(&(cCampo),9,2)
				cTpSald	:= Subs(&(cCampo),11,1)	
				
				//Procurar no CTZ para verificar se foi zeramento com conta ponte
				dbSelectArea("CTZ")
				dbSetOrder(1)                     
				cChar	:= "Z"
				
				If MsSeek(xFilial()+dtos(dDataFLP))
					While !Eof() .And. CTZ->CTZ_FILIAL == xFilial() .And. ;
						DTOS(CTZ->CTZ_DATA) == DTOS(dDataFLP)
						
						If CTZ->CTZ_MOEDLC == cMoeda .And. CTZ->CTZ_TPSALD == cTpSald
							cChar	:= "P"
							Exit
						EndIf					
						dbSkip()
					End								
				EndIf								
				dbSelectArea("SX5")
				Reclock("SX5",.F.)
				&(cCampo) := DTOS(dDataFLP)+cMoeda+cTpSald+cChar				
				MsUnlock()
				dbSkip()
			End		
		EndIf			
#IFDEF TOP 
	EndIf
#ENDIF

Restarea(aSaveArea)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥Ct211GrCTZ≥ Autor ≥ Marcos S. Lobo        ≥ Data ≥ 26.09.06 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥Grava Registros ref. o arquivo CTZ.                         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥Ct211GrCTZ(aGrvLan)                                         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥Ct211GrCTZ()                                                ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function Ct211GrCTZ(dDataFLP,cLote,cSubLote,cDoc,cLinha,cMoedLC,cTpSald,	cTipo,nValorLC,cConta,cCusto,cItem,cCLVL)

Local aSaveArea		:= GetArea()         
Local cSeqLiCTZ		:= ""
Local nLCTZSeqLin	:= 0
Local cFilCTZ		:= ""
Local cLastSeqLin	:= ""

dbSelectArea("CTZ")
dbSetOrder(1)	//DATA+LOTE+SUBLOTE+DOC+TP SALDO+EMPORI+FILORI+MOEDA+LINHA+SEQLIN
cFilCTZ	:= xFilial("CTZ")
nLCTZSeqLin := Len(CTZ->CTZ_SEQLIN)				/// TAMANHO DO CTZ_SEQLIN
cSeqLiCTZ	:= StrZero(0,nLCTZSeqLin)			/// INICIALIZA CTZ_SEQLIN
cLastSeqLin	:= Replicate("z",nLCTZSeqLin)		/// ULTIMO CTZ_SEQLIN POSSÕVEL

/// CASO MUDE A LINHA DE LAN«AMENTO OU DOCUMENTO 
/// FAZ VERIFICA«’ES DE EXISTENCIA DA LINHA NO CTZ
If __cKeyCTZATU <> cFilCTZ+dtos(dDataFLP)+cLote+cSubLote+cDoc+cTpSald+cEmpAnt+cFilAnt+cMoedLC+cLinha
	/// SE ENCONTRAR MESMA LINHA DO CT2 NO CTZ -> INCREMENTA SEQUENCIAL DO CTZ
	If MsSeek(cFilCTZ+dtos(dDataFLP)+cLote+cSubLote+cDoc+cTpSald+cEmpAnt+cFilAnt+cMoedLC+cLinha,.F.)
		/// LOCALIZA ⁄LTIMA SEQUENCIA DE CTZ UTILIZADA PARA A LINHA
		MsSeek(cFilCTZ+dtos(dDataFLP)+cLote+cSubLote+cDoc+cTpSald+cEmpAnt+cFilAnt+cMoedLC+cLinha+cLastSeqLin,.T.)
		dbSkip(-1)
		/// DETERMINA A PR”XIMA SEQUECIA DE CTZ
		cSeqLiCTZ := Soma1(CTZ->CTZ_SEQLIN)
	Else
		/// SE N√O ENCONTRAR A MESMA LINHA DO CT2 NO CTZ
	    cSeqLiCTZ := StrZero(1,nLCTZSeqLin)
	EndIf
	
	__cKeyCTZATU := cFilCTZ+dtos(dDataFLP)+cLote+cSubLote+cDoc+cTpSald+cEmpAnt+cFilAnt+cMoedLC+cLinha
Else
	cSeqLICTZ := Soma1(__cSeqLICTZ)
EndIf

/// VERIFICA SE A PROXIMA SEQUENCIA DE CTZ N√O EXISTE
While MsSeek(cFilCTZ+dtos(dDataFLP)+cLote+cSubLote+cDoc+cTpSald+cEmpAnt+cFilAnt+cMoedLC+cLinha+cSeqLiCTZ,.F.)
	If cSeqLiCTZ >= cLastSeqLin
		/// SE HOUVER ESTOURO DA QUANTIDADE DE SEQUENCIAS PARA 1 LINHA
		If !IsBlind()
			MsgAlert("Contact the Administrator. "+CRLF+;
			"The CTZ_SEQLIN Field Length it¥s too short, try to increase field length."+CRLF+;
			"The next sequences of this line will be recorded with line 'zzz',"+;
			 "duplicate key errors can happen.","CTBA211 Alert")			
		EndIf
		CONOUT("CTBA211 ALERT!"+CRLF+"Contact the Administrator."+CRLF+"The CTZ_SEQLIN Field Length it¥s too short, try to increase field length.")
		cLinha := Replicate("z",Len(CTZ->CTZ_LINHA))
		cSeqLiCTZ := StrZero(0,nLCTZSeqLin)
	EndIf
	cSeqLiCTZ := Soma1(cSeqLiCTZ)
EndDo

__cSeqLICTZ := cSeqLiCTZ

dbSelectArea("CTZ")   
//Sempre sera incluido um novo registro no CTZ
Reclock("CTZ",.T.)
CTZ_FILIAL	:= cFilCTZ
CTZ_DATA	:= dDataFLP
CTZ_LOTE	:= cLote
CTZ_SBLOTE	:= cSubLote
CTZ_DOC		:= cDoc
CTZ_LINHA	:= cLinha
CTZ_SEQLIN	:= cSeqLiCTZ
CTZ_TPSALD	:= cTPSald
CTZ_CONTA	:= cConta
CTZ_CUSTO	:= cCusto
CTZ_ITEM	:= cItem
CTZ_CLVL	:= cCLVL
CTZ_MOEDLC	:= cMoedLC
CTZ_EMPORI	:= cEmpAnt
CTZ_FILORI	:= cFilAnt
If cTipo == "1"
	CTZ_VLRDEB	:= nValorLC
ElseIf cTipo == "2"
	CTZ_VLRCRD	:= nValorLC
EndIf	        
MsUnlock()    

RestArea(aSaveArea)

Return						


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥CTBA211   ∫Autor  ≥Marcos S. Lobo      ∫ Data ≥  26.09.06   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function Ct211FlgLP(cConta,cCusto,cItem,cCLVL, dDataILP, cTpSald, dDataFLP, cMoeda)

Local cKeyFlag := alltrim(cFilAnt+cMoeda+cTpSald+cConta+cCusto+cItem+cClVL)
Local nLenKey	  := Len(alltrim(cKeyFlag))

If AsCan(__aJaFlag,{|x| Substr(x,1,nLenKey) == cKeyFlag }) <= 0
	If !Empty(cCLVL)
		Ct190FlgLP(cFilAnt, "CTI", cConta,cCusto,cItem,cCLVL, dDataILP, cTpSald, dDataFLP, cMoeda,,"S")
	EndIf
	If !Empty(cITEM)
		Ct190FlgLP(cFilAnt, "CT4", cConta,cCusto,cItem,"", dDataILP, cTpSald, dDataFLP, cMoeda,,"S")
	EndIf
	If !Empty(cCUSTO)
		Ct190FlgLP(cFilAnt, "CT3", cConta,cCusto,"","", dDataILP, cTpSald, dDataFLP, cMoeda,,"S")
	EndIf
	If !Empty(cConta)
		Ct190FlgLP(cFilAnt, "CT7", cConta,"","","", dDataILP, cTpSald, dDataFLP, cMoeda,,"S")
	EndIf

	/// MARCA FLAG NAS TABELAS DE SALDOS COMPOSTOS
	If !Empty(cCLVL)
		Ct190FlgLP(cFilAnt, "CTU", "","","",cCLVL, dDataILP, cTpSald, dDataFLP, cMoeda,,"S")
	EndIf
	If !Empty(cITEM)
		Ct190FlgLP(cFilAnt, "CTU", "","",cITEM,"", dDataILP, cTpSald, dDataFLP, cMoeda,,"S")
	EndIf
	If !Empty(cCUSTO)
		Ct190FlgLP(cFilAnt, "CTU", "",cCUSTO,"","", dDataILP, cTpSald, dDataFLP, cMoeda,,"S")
	EndIf
	If !Empty(cItem) .and. !Empty(cCUSTO)
		Ct190FlgLP(cFilAnt, "CTV", "",cCUSTO,cITEM,"", dDataILP, cTpSald, dDataFLP, cMoeda,,"S")
    EndIf
  	If !Empty(cCLVL) .and. !Empty(cCUSTO)
		Ct190FlgLP(cFilAnt, "CTW", "",cCUSTO,"",cCLVL, dDataILP, cTpSald, dDataFLP, cMoeda,,"S")
    EndIf
   	If !Empty(cCLVL) .and. !Empty(cITEM)
		Ct190FlgLP(cFilAnt, "CTW", "","",cITEM,cCLVL, dDataILP, cTpSald, dDataFLP, cMoeda,,"S")
    EndIf
   	If !Empty(cCLVL) .and. !Empty(cITEM) .and. !Empty(cCUSTO)
		Ct190FlgLP(cFilAnt, "CTY", "",cCUSTO,cITEM,cCLVL, dDataILP, cTpSald, dDataFLP, cMoeda,,"S")
    EndIf
    
	AAdd(__aJaFlag,cKeyFlag)
EndIf

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥CTBA211   ∫Autor  ≥Marcos S. Lobo      ∫ Data ≥  26/09/06   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function MostraSX5LP()

Local a
Local b
Local c
Local aAreaOri := GetArea()
Local aAreaX5  := {}


dbSelectArea("SX5")
aAreax5 := GetArea()
dbSetOrder(1)
If !MsSeek(xFilial("SX5")+"LP",.F.)
	MsgInfo(STR0041,STR0042)//"N„o existem apuraÁıes registradas."//"Tabela LP - ApuraÁıes de resultado"
Else
	ConPad1(a,b,c,"CTZ",,,.F.)
EndIf

RestArea(aAreaX5)
RestArea(aAreaOri)

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥CTBA211   ∫Autor  ≥Microsiga           ∫ Data ≥  09/27/06   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
static Function Ct211Seek(aDocsLP,cMoeda,cTpSald,cDebito,cCredito,cCustoDeb,cCustoCrd,cItemDeb,cItemCrd,cClVlDeb,cClVlCrd)

Local nRecFound := 0
Local _nD		:= 1
Local cFilCT2	:= ""

DEFAULT  aDocsLP := {}

If Len(aDocsLP) == 0 .or. ValType(aDocsLP) <> "A"
	Return(nRecFound)
EndIf

For _nD := 1 to Len(aDocsLP)			/// RODA TODOS OS DOCUMENTOS GERADOS PELA APURACAO
	dbSelectArea("CT2")
	dbSetOrder(1)
	cFilCT2 := xFilial("CT2")
	If MsSeek(cFilCT2+DTOS(aDocsLP[_nD][2])+aDocsLP[_nD][3]+aDocsLP[_nD][4]+aDocsLP[_nD][5],.F.)
		While CT2->(!Eof()) .and. CT2->CT2_FILIAL == cFilCT2 .and. CT2->CT2_DATA == aDocsLP[_nD][2] .and.;
			CT2->CT2_LOTE == aDocsLP[_nD][3] .and. CT2->CT2_SBLOTE == aDocsLP[_nD][4] .and.;
			CT2->CT2_DOC == aDocsLP[_nD][5]
			// LE ENQUANTO FOR O DOCUMENTO DE APURACAO
			If CT2->CT2_MOEDLC == cMoeda .and. CT2->CT2_TPSALD == cTpSald
				// SE FOR A MESMA MOEDA E TIPO DE SALDO A SER GERADO
				If CT2->CT2_DEBITO == cDebito .and. CT2->CT2_CREDITO == cCredito .and.;
				   CT2->CT2_CCD == cCustoDeb .and. CT2->CT2_CCC == cCustoCrd .and.;
				   CT2->CT2_ITEMD == cItemDeb .and. CT2->CT2_ITEMC == cItemCrd .and.;
				   CT2->CT2_CLVLDB == cClVlDeb .and. CT2->CT2_CLVLCR == cClVlCrd
					/// E POSSUIR A MESMA COMBINA«√O DE ENTIDADES PARA O LANCAMENTO (DEB E CRED).				   	
				   nRecFound := CT2->(Recno())	 /// RETORNA O RECNO PARA SOMAR NO MESMO.
				EndIf
			EndIf			
		
			dbSkip()
		EndDo	
	EndIf
Next

Return(nRecFound)


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ A211Ordem∫Autor  ≥ Gustavo Henrique   ∫ Data ≥  14/12/07   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Funcao customizada para apresentar consulta de apuracoes   ∫±±
±±∫          ≥ jah realizadas no objeto tNewProcess                       ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Contabilidade Gerencial                                    ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function A211Ordem(oCenterPanel)

MsAguarde( { || MostraSX5LP() },,STR0005)	//Selecionando Registros...

Return


Static Function CtbGravSaldo(cLote,cSubLote,cDoc,dData,cTipo,cMoeda,cDebito,;
					  cCredito,cCustoDeb,cCustoCrd,cItemDeb,cItemCrd,;
					  cClVlDeb,cClVlCrd,nValor,cTpSald,nOpc,cDebitoAnt,;
					  cCreditoAnt,cCustoDAnt,cCustoCAnt,cItemDAnt,;
					  cItemCAnt,cCLVLDAnt,cCLVLCAnt,nValorAnt,;
					  cTipoAnt,cTpSaldAnt,cMoedaAnt,lCusto,lItem,lClVL,nTotInf,;
					  lAtSldBase,lReproc,dDataLP,lGrvCT7,lGrvCT3,lGrvCT4,lGrvCTI,;
					  lAtuSldCT7,lAtuSldCT3,lAtuSldCT4,lAtuSldCTI, lTrbProc, cOperacao,aEntid,aEntidAnt,;
					  cHistLote,cMoedDoc,cCritDoc,dDatTaxDoc,cTipSldDoc,cLivDia,cNroDia)

Local lAltDeb		:= .F.
Local lAltCrd		:= .F.
Local lAltValor  	:= .F.
Local lAltTpSald	:= .F.
Local lAltMoeda		:= .F.
Local lAltDC		:= .F.
Local lPartDob 		:= .F.
Local lMudouSld 	:= .F.
Local lCtDeb 		:= .F.
Local lCCDeb 		:= .F.
Local lITDeb 		:= .F.
Local lCLDeb 		:= .F.
		
Local lCtCrd 		:= .F.
Local lCCCrd 		:= .F.
Local lITCrd 		:= .F.
Local lCLCrd 		:= .F.
lReproc 			:= Iif(lReproc==Nil,.F.,lReproc)
lAtSldBase 			:= Iif(lAtSldBase==Nil,(If(GetMv("MV_ATUSAL")=="S",.T.,.F.)),lAtSldBase) 
dDataLP				:= Iif(dDataLP==Nil,CTOD("  /  /  "),dDataLP)

DEFAULT lGrvCT7		:= .F.
DEFAULT lGrvCT3		:= .F.
DEFAULT lGrvCT4		:= .F.
DEFAULT lGrvCTI		:= .F.
DEFAULT lAtuSldCT7	:= .T.
DEFAULT lAtuSLdCT3	:= .T.
DEFAULT lAtuSldCT4	:= .T.
DEFAULT lAtuSldCTI	:= .T.
DEFAULT cOperacao	:= "+"
DEFAULT lTrbProc	:= .F.
DEFAULT aEntid		:= {}
DEFAULT aEntidAnt	:= {}

DEFAULT cHistLote	:= ""
DEFAULT cMoedDoc	:= ""
DEFAULT cCritDoc	:= ""
DEFAULT dDatTaxDoc	:= STOD("")
DEFAULT cTipSldDoc	:= ""
DEFAULT cLivDia		:= ""
DEFAULT cNroDia		:= ""


// SE FOR CONTINUACAO DE HISTORICO NAO ATUALIZA OS SALDOS
// E SE FOR ATUALIZACAO DE SALDOS VIA JOB NAO ATUALIZA OS SALDOS
/*
If ( cOperacao == "+" .And. cTipo == "4" .OR. __IsCtbJob ) .OR. ;
	( cOperacao == "-" .And. cTipoAnt == "4".OR. __IsCtbJob ) 
	Return
EndIf
*/

If ( cOperacao == "+" .And. cTipo == "4" .OR. .F. ) .OR. ;
	( cOperacao == "-" .And. cTipoAnt == "4".OR. .F. ) 
	Return
EndIf

// Verifica o que ira Recalcular/Descalcular - comparando variaveis que ir„o afetar a gravaÁ„o do
// saldo -> Tipo Lcto, Valor, Tipo do Saldo, Moeda do Lcto. Se n„o houve alteraÁ„o
// N√O PODER¡ REGRAVAR!!!!!
If cOperacao == "+"
	lCtDeb := !Empty(cDebito)
	lCCDeb := !Empty(cCustoDeb)
	lITDeb := !Empty(cItemDeb) 
	lCLDeb := !Empty(cCLVLDeb) 

	lCtCrd := !Empty(cCredito)
	lCCCrd := !Empty(cCustoCrd) 
	lITCrd := !Empty(cItemCrd) 
	lCLCrd := !Empty(cCLVLCrd)

	If cTipo == "3"    
		lPartDob := .T.
	Endif

ElseIf cOperacao == "-"
	lCtDeb := !Empty(cDebitoAnt)
	lCCDeb := !Empty(cCustoDAnt)
	lITDeb := !Empty(cItemDAnt) 
	lCLDeb := !Empty(cCLVLDAnt) 

	lCtCrd := !Empty(cCreditoAnt)
	lCCCrd := !Empty(cCustoCAnt) 
	lITCrd := !Empty(cItemCAnt) 
	lCLCrd := !Empty(cCLVLCAnt)

	If cTipoAnt == "3"
		lPartDob	:= .T.
	EndIf	

EndIf
	
If nOpc == 5			/// SE FOR EXCLUSAO SEMPRE VAI ATUALIZAR OS SALDOS (APAGAR)

	If cTipoAnt $ "1/3"
		lAltDeb := .T.
	EnDif
	If cTipoAnt $ "2/3"
		lAltCrd := .T.
	EndIf
	
ElseIf nOpc == 3 .Or. nOpc == 6 .Or. nOpc == 7		/// SE FOR INCLUSAO OU COPIA SEMPRE VAI ATUALIZAR OS SALDOS (ADICIONAR)

	If cTipo $ "1/3"
		lAltDeb := .T.
	EnDif
	If cTipo $ "2/3"
		lAltCrd := .T.
	EndIf
	
ElseIf nOpc == 4						/// SE FOR ALTERACAO VERIFICA AS CONDICOES PARA ATUALIZAR (ADICIONAR)

	lAltValor 	:= nValor <> nValorAnt
	lAltTpSald	:= cTpSald <> cTpSaldAnt
	lAltMoeda	:= cMoeda <> cMoedaAnt
	lAltDC		:= cTipo <> cTipoAnt
	
	If lAltValor .or. lAltTpSald .or. lAltMoeda .or. lAltDC

		If cOperacao == "+"

			If cTipo $ "1/3"
				lAltDeb := .T.
			EnDif
			If cTipo $ "2/3"
				lAltCrd := .T.
			EndIf

		ElseIf cOperacao == "-"

			If cTipoAnt $ "1/3"
				lAltDeb := .T.
			EndIf
			If cTipoAnt $ "2/3"
				lAltCrd := .T.
			EndIf

		EndIf
	
	Else	

		lCtDeb := lCtDeb .and. cDebito	 	<> cDebitoAnt
		lCCDeb := lCCDeb .and. cCustoDeb 	<> cCustoDAnt
		lITDeb := lITDeb .and. cItemDeb	 	<> cItemDAnt
		lCLDeb := lCLDeb .and. cClVlDeb 	<> cCLVLDAnt
	
	    lCtCrd := lCtCrd .and. cCredito		<> cCreditoAnt
		lCCCrd := lCCCrd .and. cCustoCrd 	<> cCustoCAnt	
		lITCrd := lITCrd .and. cItemCrd		<> cItemCAnt
		lCLCrd := lCLCrd .and. cClVlCrd		<> cCLVLCAnt

		If cOperacao == "+"

			If cTipo $ "1/3" .and. (lCtDeb .or. lCcDeb .or. lItDeb .or. lClDeb )
				lAltDeb := .T.
			EndIf
			If cTipo $ "2/3" .and. (lCtCrd .or. lCcCrd .or. lItCrd .or. lClCrd )
				lAltCrd := .T.
			EndIf

		ElseIf cOperacao == "-"

			If cTipoAnt $ "1/3" .and. (lCtDeb .or. lCcDeb .or. lItDeb .or. lClDeb )
				lAltDeb := .T.
			EndIf
			If cTipoAnt $ "2/3" .and. (lCtCrd .or. lCcCrd .or. lItCrd .or. lClCrd )
				lAltCrd := .T.
			EndIf

		EndIf

	EndIf

EndIf

// Saldos de Lote
If lAtSldBase .And. cOperacao == "+"
	BEGIN TRANSACTION
	IF cTipo $ "1/3"
		GravaCT6(cLote,cSubLote,"1",dData,cMoeda,nValor,cTpSald,lPartDob,cOperacao)
	Endif
	
	IF cTipo $ "2/3"
		GravaCT6(cLote,cSubLote,"2",dData,cMoeda,nValor,cTpSald,lPartDob,cOperacao)
	Endif
	
	// Saldos de Documento
	IF cTipo $ "1/3"
		GravaCTC(cLote,cSubLote,cDoc,"1",dData,cMoeda,nValor,cTpSald,lPartDob,cOperacao,,,cHistLote,cMoedDoc,cCritDoc,dDatTaxDoc,cTipSldDoc,cLivDia,cNroDia)
	Endif
	
	IF cTipo $ "2/3"
		GravaCTC(cLote,cSubLote,cDoc,"2",dData,cMoeda,nValor,cTpSald,lPartDob,cOperacao,,,cHistLote,cMoedDoc,cCritDoc,dDatTaxDoc,cTipSldDoc,cLivDia,cNroDia)
	Endif

	END TRANSACTION
	
ElseIf lAtSldBase .And. cOperacao == "-"

	// Desgravacao de Saldos de Lote
	BEGIN TRANSACTION

	// subtrai o saldo atual da conta no ct6
	If cTipoAnt $ '1/3'
		//DsGravaCT6(cLote,cSubLote,"1",dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lPartDob)
		GravaCT6(cLote,cSubLote,"1",dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lPartDob, cOperacao)
	Endif
	If cTipoAnt $ '2/3'
		//DsGravaCT6(cLote,cSubLote,"2",dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lPartDob)
		GravaCT6(cLote,cSubLote,"2",dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lPartDob,cOperacao)
	Endif

	// subtrai o saldo atual da conta no ctc
	If cTipoAnt $ '1/3'
		//DsGravaCTC(cLote,cSubLote,cDoc,"1",dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lPartDob)
		GravaCTC(cLote,cSubLote,cDoc,"1",dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lPartDob,cOperacao,,,cHistLote,cMoedDoc,cCritDoc,dDatTaxDoc,cTipSldDoc,cLivDia,cNroDia)
	Endif
	If cTipoAnt $ '2/3'
		//DsGravaCTC(cLote,cSubLote,cDoc,"2",dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lPartDob)
		GravaCTC(cLote,cSubLote,cDoc,"2",dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lPartDob,cOperacao,,,cHistLote,cMoedDoc,cCritDoc,dDatTaxDoc,cTipSldDoc,cLivDia,cNroDia)
	Endif

	END TRANSACTION


EndIF	   

If	!__IsCtbJob .And. cOperacao == "+"

	If lPartDob .And. lAltDeb .And. lAltCrd .And. cTpSald != D_PRELAN
	
		If lAtuSldCT7 .And. lCtDeb .And. lCtCrd
			If lAtSldBase
				GRAVACT7(nOpc,cDebito,cCredito,cTipo,dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,/*lZera*/,dDataLP,lTrbProc,cOperacao)
			Else
				lMudouSld	:= .T.
			EndIf		
		EndIf		
	
		// Saldos de Centro de Custo
		If lCusto .And. lAtuSldCT3 .And. ( lCtDeb .or. lCCDeb )
			If lAtSldBase
				//GravaCT3(cDebito,cCustoDeb,"1",dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,,dDataLP,lTrbProc)
				GRAVACT3(cDebito,cCustoDeb,cCredito,cCustoCrd,cTipo,dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,,dDataLP,nOpc,lTrbProc,cOperacao)
		 		//Se nao existir nenhum dos pontos de entrada de atualizacao de saldos.
				If !lGrvCT7 .And. !lGrvCT3 .And. !lGrvCT4 .And. !lGrvCTI
					//Atualiza Flag de Saldos Compostos							
					AtuFlgCmp(dData,"CTT",cCustoDeb,cMoeda,cTpSald)
				Endif					
			Else
				lMudouSld	:= .T.
			EndIf
		EndIf	
				// Saldos de Itens Contabeis
				If lItem .And. lAtuSldCT4
					If lCtDeb .or. lCCDeb .or. lItDeb
						If lAtSldBase
							//GravaCT4(cDebito,cCustoDeb,cItemDeb,"1",dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,,dDataLP,lTrbProc)
							GRAVACT4(cDebito,cCustoDeb,cItemDeb,cCredito,cCustoCrd,cItemCrd,cTipo,dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,,dDataLP,nOpc,lTrbProc,cOperacao)
			   				//Se nao existir nenhum dos pontos de entrada de atualizacao de saldos.
							If !lGrvCT7 .And. !lGrvCT3 .And. !lGrvCT4 .And. !lGrvCTI					
								//Atualiza Flag de Saldos Compostos			
								AtuFlgCmp(dData,"CTD",cItemDeb,cMoeda,cTpSald)					
							EndIf	
					Else
							lMudouSld	:= .T.
						EndIf
					EndIf
				EndIf	
				// Saldos Classe de Valor
				If lClvl .And. lAtuSldCTI
					If lCtDeb .or. lCCDeb .or. lItDeb .or. lClDeb
						If lAtSldBase
							//GravaCTI(cDebito,cCustoDeb,cItemDeb,cCLVLDeb,"1",dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,,dDataLP,lTrbProc)
							GRAVACTI(cDebito,cCustoDeb,cItemDeb,cClVlDeb,cCredito,cCustoCrd,cItemCrd,cClVlCrd,cTipo,dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,,dDataLP,nOpc,lTrbProc,cOperacao)		
			   				//Se nao existir nenhum dos pontos de entrada de atualizacao de saldos.
							If !lGrvCT7 .And. !lGrvCT3 .And. !lGrvCT4 .And. !lGrvCTI					
								//Atualiza Flag de Saldos Compostos		
								AtuFlgCmp(dData,"CTH",cCLVLDeb,cMoeda,cTpSald)					
							EndIf	
						Else				
							lMudouSld	:= .T.
						EndIf
					EndIf
				EndIf		

	Else
	
		If lAltDeb
			If cTpSald != D_PRELAN		// Pre-Lancamento nao controla saldos
				// Saldos de Conta
				If lAtuSldCT7 .and. lCtDeb
					If lAtSldBase
						//GravaCT7(nOpc,cDebito,"1",dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,,dDataLP,lTrbProc)
						GRAVACT7(nOpc,cDebito,""/*cContaCrd*/,"1"/*cTipo*/,dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,/*lZera*/,dDataLP,lTrbProc,cOperacao)					
					Else
						lMudouSld	:= .T.
					EndIf
				EndIf
				// Saldos de Centro de Custo
				If lCusto .And. lAtuSldCT3
					If lCtDeb .or. lCCDeb
						If lAtSldBase
							//GravaCT3(cDebito,cCustoDeb,"1",dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,,dDataLP,lTrbProc)
							GRAVACT3(cDebito,cCustoDeb,""/*cContaCrd*/,""/*cCustoCrd*/,"1"/*cTipo*/,dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,,dDataLP,nOpc,lTrbProc,cOperacao)
			
		   					//Se nao existir nenhum dos pontos de entrada de atualizacao de saldos.
							If !lGrvCT7 .And. !lGrvCT3 .And. !lGrvCT4 .And. !lGrvCTI
								//Atualiza Flag de Saldos Compostos							
								AtuFlgCmp(dData,"CTT",cCustoDeb,cMoeda,cTpSald)
							Endif					
						Else
							lMudouSld	:= .T.
						EndIf
					EndIf
				EndIf	
				// Saldos de Itens Contabeis
				If lItem .And. lAtuSldCT4
					If lCtDeb .or. lCCDeb .or. lItDeb
						If lAtSldBase
							//GravaCT4(cDebito,cCustoDeb,cItemDeb,"1",dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,,dDataLP,lTrbProc)
							GRAVACT4(cDebito,cCustoDeb,cItemDeb,""/*cContaCrd*/,""/*cCustoCrd*/,""/*cItemCrd*/,"1"/*cTipo*/,dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,,dDataLP,nOpc,lTrbProc,cOperacao)
			   				//Se nao existir nenhum dos pontos de entrada de atualizacao de saldos.
							If !lGrvCT7 .And. !lGrvCT3 .And. !lGrvCT4 .And. !lGrvCTI					
								//Atualiza Flag de Saldos Compostos			
								AtuFlgCmp(dData,"CTD",cItemDeb,cMoeda,cTpSald)					
							EndIf	
					Else
							lMudouSld	:= .T.
						EndIf
					EndIf
				EndIf	
				// Saldos Classe de Valor
				If lClvl .And. lAtuSldCTI
					If lCtDeb .or. lCCDeb .or. lItDeb .or. lClDeb
						If lAtSldBase
							//GravaCTI(cDebito,cCustoDeb,cItemDeb,cCLVLDeb,"1",dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,,dDataLP,lTrbProc)
							GRAVACTI(cDebito,cCustoDeb,cItemDeb,cClVlDeb,""/*cCredito*/,""/*cCustoCrd*/,""/*cItemCrd*/,""/*cClVlCrd*/,"1"/*cTipo*/,dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,,dDataLP,nOpc,lTrbProc,cOperacao)		

			   				//Se nao existir nenhum dos pontos de entrada de atualizacao de saldos.
							If !lGrvCT7 .And. !lGrvCT3 .And. !lGrvCT4 .And. !lGrvCTI					
								//Atualiza Flag de Saldos Compostos		
								AtuFlgCmp(dData,"CTH",cCLVLDeb,cMoeda,cTpSald)					
							EndIf	
						Else				
							lMudouSld	:= .T.
						EndIf
					EndIf
				EndIf		
			EndIf   
		EndIf                     
		
		// Grava Saldos CREDORES
		If lAltCrd .And. cTpSald != D_PRELAN		// Pre-Lancamento nao controla saldos
			// Saldos de Conta       
			If lAtuSldCT7 .and. lCtCrd 
				If lAtSldBase			
					//GravaCT7(cCredito,"2",dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,,dDataLP,lTrbProc)
					GRAVACT7(nOpc,""/*cContaDeb*/,cCredito,"2"/*cTipo*/,dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,/*lZera*/,dDataLP,lTrbProc,cOperacao)
				Else		
					lMudouSld	:= .T.
				EndIf
			EndIf
			// Saldos de Centro de Custo
			If lCusto .And. lAtuSldCT3
				If lCtCrd .or. lCCCrd
					If lAtSldBase			
						//GravaCT3(cCredito,cCustoCrd,"2",dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,,dDataLP,lTrbProc)
						GRAVACT3(""/*cContaDeb*/,""/*cCustoDeb*/,cCredito,cCustoCrd,"2"/*cTipo*/,dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,,dDataLP,nOpc,lTrbProc,cOperacao)
						
		   				//Se nao existir nenhum dos pontos de entrada de atualizacao de saldos.
						If !lGrvCT7 .And. !lGrvCT3 .And. !lGrvCT4 .And. !lGrvCTI					
							//Atualiza Flag de Saldos Compostos		
							AtuFlgCmp(dData,"CTT",cCustoCrd,cMoeda,cTpSald)	
						EndIf				
					Else
						lMudouSld	:= .T.
					EndIf
				EndIf
			EndIf
			// Saldos de Item Contabil
			If lItem .And. lAtuSldCT4
				If lCtCrd .or. lCCCrd .or. lItCrd 
					If lAtSldBase
						//GravaCT4(cCredito,cCustoCrd,cItemCrd,"2",dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,,dDataLP,lTrbProc)
						GRAVACT4(""/*cContaDeb*/,""/*cCustoDeb*/,""/*cItemDeb*/,cCredito,cCustoCrd,cItemCrd,"2"/*cTipo*/,dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,,dDataLP,nOpc,lTrbProc,cOperacao)	
		   				//Se nao existir nenhum dos pontos de entrada de atualizacao de saldos.
						If !lGrvCT7 .And. !lGrvCT3 .And. !lGrvCT4 .And. !lGrvCTI					
							//Atualiza Flag de Saldos Compostos		
							AtuFlgCmp(dData,"CTD",cItemCrd,cMoeda,cTpSald)					
						EndIf
					Else
						lMudouSld	:= .T.
					EndIf
				EndIf
			EndIf
			// Saldos de Classe de Valor
			If lCLVL .And. lAtuSldCTI
				If lCtCrd .or. lCCCrd .or. lItCrd .or. lClCrd
					If lAtSldBase
						//GravaCTI(cCredito,cCustoCrd,cItemCrd,cCLVLCrd,"2",dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,,dDataLP,lTrbProc)
						GRAVACTI(""/*cDebito*/,""/*cCustoDeb*/,""/*cItemDeb*/,""/*cClVlDeb*/,cCredito,cCustoCrd,cItemCrd,cClVlCrd,"2"/*cTipo*/,dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,,dDataLP,nOpc,lTrbProc,cOperacao)		

		   				//Se nao existir nenhum dos pontos de entrada de atualizacao de saldos.
						If !lGrvCT7 .And. !lGrvCT3 .And. !lGrvCT4 .And. !lGrvCTI					
							//Atualiza Flag de Saldos Compostos		
							AtuFlgCmp(dData,"CTH",cCLVLCrd,cMoeda,cTpSald)					
						EndIf
		
					Else
						lMudouSld	:= .T.
					EndIf
				EndIf
			EndIf                             
		EndIf
	Endif
	
	If lAtSldBase
		//Grava saldo do cubo
		If _lCtbIsCube .And. CtbIsCube() .And. (lAtuSldCT7 .or.lAtuSldCT3 .or. lAtuSldCT4 .or. lAtuSldCTI)
			CtbGravCub( nValor, cTipo, cTpSald, cMoeda, dData, cDebito, cCredito, cCustoDeb, cCustoCrd, cItemDeb, cItemCrd, cClVlDeb, cClVlCrd, aEntid)
		EndIf
	Else
		lMudouSld	:= .T.		
	EndIf			    	

ElseIf 	!__IsCtbJob .And. cOperacao == "-"

	// DesGravacao de Saldos de Contas
	If lAtuSldCT7
		If lAltDeb .and. lCtDeb 
			If lAtSldBase
				//DSGravaCT7(cDebitoAnt,"1",dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lReproc,lAtSldBase,dDataLP,nOpc)
				GRAVACT7(nOpc,cDebitoAnt,""/*cContaCrd*/,"1"/*cTipo*/,dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lReproc,lAtSldBase,.F./*lZera*/,dDataLP,lTrbProc,"-"/*cOperacao*/)
			Else		
				lMudouSld	:= .T.
			EndIf
		EndIf
		If lAltCrd .and. lCtCrd
			If lAtSldBase
				//DSGravaCT7(cCreditoAnt,"2",dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lReproc,lAtSldBase,dDataLP,nOpc)
				GRAVACT7(nOpc,""/*cContaDeb"*/,cCreditoAnt,"2"/*cTipo*/,dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lReproc,lAtSldBase,.F./*lZera*/,dDataLP,lTrbProc,"-"/*cOperacao*/)
			Else		
				lMudouSld	:= .T.
			EndIf
		EndIf
	EndIf
	
	// DesGravacao de Saldos de Centro de Custo
	If lCusto .And. lAtuSldCT3
	
		If lAltDeb .and. (lCtDeb .or. lCCDeb)
			If lAtSldBase
				//DSGravaCT3(cDebitoAnt,cCustoDAnt,"1",dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lReproc,lAtSldBase,dDataLP,nOpc)
				GRAVACT3(cDebitoAnt,cCustoDAnt,""/*cContaCrd*/,""/*cCustoCrd*/,"1"/*cTipo*/,dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lReproc,lAtSldBase,,dDataLP,nOpc,lTrbProc,"-"/*cOperacao*/)	
		    	//Se nao existir nenhum dos pontos de entrada de atualizacao de saldos.
				If !lGrvCT7 .And. !lGrvCT3 .And. !lGrvCT4 .And. !lGrvCTI		
					If lCCDeb
						//Atualiza Flag de Saldos Compostos do Centro de Custo Debito                       		
						cChave	:= "CTT"+cMoedaAnt+cTpSaldAnt+cCustoDant+DTOS(dData)
						FlgSldComp("CTU",cChave)		
						#IFNDEF TOP	//Se for codebase atualiza o flag do CT2
							AtuFlgCmp(dData,"CTT",cCustoDAnt,cMoedaAnt,cTpSaldAnt)
						#ENDIF
					EndIf
				EndIf		
			Else		
				lMudouSld	:= .T.		
			EndIf
		EndIf
			
		If lAltCrd .and. (lCtCrd .or. lCCCrd)
			If lAtSldBase
				//DSGravaCT3(cCreditoAnt,cCustoCAnt,"2",dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lReproc,lAtSldBase,dDataLP,nOpc)
				GRAVACT3(""/*cContaDeb*/,""/*cCustoDeb*/,cCreditoAnt,cCustoCAnt,"2"/*cTipo*/,dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lReproc,lAtSldBase,,dDataLP,nOpc,lTrbProc,"-"/*cOperacao*/)
		    	//Se nao existir nenhum dos pontos de entrada de atualizacao de saldos.
				If !lGrvCT7 .And. !lGrvCT3 .And. !lGrvCT4 .And. !lGrvCTI		
					//Atualiza Flag de Saldos Compostos do Centro de Custo Credito		
					If lCCCrd
						cChave	:= "CTT"+cMoedaAnt+cTpSaldAnt+cCustoCant+DTOS(dData)
						FlgSldComp("CTU",cChave)				
						#IFNDEF TOP	//Se for codebase atualiza o flag do CT2
							AtuFlgCmp(dData,"CTT",cCustoCAnt,cMoedaAnt,cTpSaldAnt)
						#ENDIF
					EndIf
				EndIf
		    Else
				lMudouSld	:= .T.
			EndIf		
		EndIf              	
	EndIf
	
	// DesGravacao de Saldos de Item Contabil
	If lItem .And. lAtuSldCT4
		If lAltDeb .and. (lCtDeb .or. lCCDeb .or. lItDeb) 
			If lAtSldBase
				//DSGravaCT4(cDebitoAnt,cCustoDAnt,cItemDAnt,"1",dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lReproc,lAtSldBase,dDataLP,nOpc)
				GRAVACT4(cDebitoAnt,cCustoDAnt,cItemDAnt,""/*cContaCrd*/,""/*cCustoCrd*/,""/*cItemCrd*/,"1"/*cTipo*/,dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lReproc,lAtSldBase,,dDataLP,nOpc,lTrbProc,"-"/*cOperacao*/)
		    	//Se nao existir nenhum dos pontos de entrada de atualizacao de saldos.
				If !lGrvCT7 .And. !lGrvCT3 .And. !lGrvCT4 .And. !lGrvCTI			
					//Atualiza Flag de Saldos Compostos do Item Debito
					If lItDeb
						cChave	:= "CTD"+cMoedaAnt+cTpSaldAnt+cItemDAnt+DTOS(dData)
						FlgSldComp("CTU",cChave)		   
						#IFNDEF TOP	//Se for codebase atualiza o flag do CT2
							AtuFlgCmp(dData,"CTD",cItemDAnt,cMoedaAnt,cTpSaldAnt)						
						#ENDIF
					EndIf
					
					//Atualiza Flag de Saldos Compostos Item/C.Custo Debito
					If lItDeb .or. lCCDeb
						cChave	:= cMoedaAnt+cTpSaldAnt+cItemDAnt+cCustoDAnt+DTOS(dData)
						FlgSldComp("CTV",cChave)				
					EndIf													
				EndIf               		
			Else
				lMudouSld	:= .T.			
			EndIf
		EndIf
			
		If lAltCrd .and. (lCtCrd .or. lCCCrd .or. lItCrd) 
			If lAtSldBase	
				//DSGravaCT4(cCreditoAnt,cCustoCAnt,cItemCAnt,"2",dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lReproc,lAtSldBase,dDataLP,nOpc)
				GRAVACT4(""/*cContaDeb*/,""/*cCustoDeb*/,""/*cItemDeb*/,cCredito,cCustoCAnt,cItemCAnt,"2"/*cTipo*/,dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lReproc,lAtSldBase,,dDataLP,nOpc,lTrbProc,"-"/*cOperacao*/)
		
		    	//Se nao existir nenhum dos pontos de entrada de atualizacao de saldos.
				If !lGrvCT7 .And. !lGrvCT3 .And. !lGrvCT4 .And. !lGrvCTI			
					//Atualiza Flag de Saldos Compostos do Item Credito			
					If lItCrd
						cChave	:= "CTD"+cMoedaAnt+cTpSaldAnt+cItemCAnt+DTOS(dData)
						FlgSldComp("CTU",cChave)				            
						#IFNDEF TOP		//Se for codebase atualiza o flag do CT2
							AtuFlgCmp(dData,"CTD",cItemCAnt,cMoedaAnt,cTpSaldAnt)										
						#ENDIF
					EndIf			
						//Atualiza Flag de Saldos Compostos Item/C.Custo Credito			
					If lItCrd .or. lCCCrd
						cChave	:= cMoedaAnt+cTpSaldAnt+cItemCAnt+cCustoCAnt+DTOS(dData)
						FlgSldComp("CTV",cChave)				
					EndIf		
				EndIf
			Else
				lMudouSld	:= .T.
			EndIf
		EndIf		
	EndIf
	
	// Desgravacao dos Saldos da Classe de Valor
	If lCLVL .And. lAtuSldCTI
		If lAltDeb .and. (lCtDeb .or. lCCDeb .or. lItDeb .or. lClDeb) 
			If lAtSldBase
				//DSGravaCTI(cDebitoAnt,cCustoDAnt,cItemDAnt,cCLVLDAnt,"1",dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lReproc,lAtSldBase,dDataLP,nOpc)
				GRAVACTI(cDebitoAnt,cCustoDAnt,cItemDAnt,cCLVLDAnt,""/*cContaCrd*/,""/*cCustoCrd*/,""/*cItemCrd*/,""/*cClVlrCrd*/,"1"/*cTipo*/,dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lReproc,lAtSldBase,,dDataLP,nOpc,lTrbProc,"-"/*cOperacao*/)	
		    	//Se nao existir nenhum dos pontos de entrada de atualizacao de saldos.
				If !lGrvCT7 .And. !lGrvCT3 .And. !lGrvCT4 .And. !lGrvCTI
					//Atualiza Flag de Saldos Compostos da Clsse de Valor Debito
					If lClDeb
						cChave	:= "CTH"+cMoedaAnt+cTpSaldAnt+cCLVLDAnt+DTOS(dData)
						FlgSldComp("CTU",cChave)		
						#IFNDEF TOP
							AtuFlgCmp(dData,"CTH",cCLVLDAnt,cMoedaAnt,cTpSaldAnt)											
						#ENDIF
					EndIf
					
					//Atualiza Flag de Saldos Compostos CL.Valor/C.Custo Debito
					If lClDeb .or. lCCDeb
						cChave	:= cMoedaAnt+cTpSaldAnt+cCLVLDAnt+cCustoDAnt+DTOS(dData)
						FlgSldComp("CTW",cChave)				
					EndIf						
				
					//Atualiza Flag de Saldos Compostos CL.Valor/Item Debito
					If lClDeb .or. lItDeb
						cChave	:= cMoedaAnt+cTpSaldAnt+cItemDAnt+cCLVLDAnt+DTOS(dData)
						FlgSldComp("CTX",cChave)				
					EndIf										
				
					//Atualiza Flag de Saldos Compostos CL.Valor/Item/C.Custo Debito
					If lClDeb .or. lItDeb .or. lCCDeb
						cChave	:= cMoedaAnt+cTpSaldAnt+cCLVLDAnt+cItemDAnt+cCustoDAnt+DTOS(dData)
						FlgSldComp("CTY",cChave)				
					EndIf									
				EndIf
			Else
				lMudouSld	:= .T.
			EndIf
		EndIf		
	
		If lAltCrd .and. (lCtCrd .or. lCCCrd .or. lItCrd .or. lClCrd) 
			If lAtSldBase
				GRAVACTI(""/*cContaDeb*/,""/*cCustoDeb*/,""/*cItemDeb*/,""/*cClVlrDeb*/,cCreditoAnt,cCustoCAnt,cItemCAnt,cCLVLCAnt,"2"/*cTipo*/,dData,cMoedaAnt,nValorAnt,cTpSaldAnt,lReproc,lAtSldBase,,dDataLP,nOpc,lTrbProc,"-"/*cOperacao*/)
				
	   			//Se nao existir nenhum dos pontos de entrada de atualizacao de saldos.
				If !lGrvCT7 .And. !lGrvCT3 .And. !lGrvCT4 .And. !lGrvCTI
					//Atualiza Flag de Saldos Compostos da Clsse de Valor Credito
					If lClCrd
						cChave	:= "CTH"+cMoedaAnt+cTpSaldAnt+cCLVLCAnt+DTOS(dData)
						FlgSldComp("CTU",cChave)  
						#IFNDEF TOP
							AtuFlgCmp(dData,"CTH",cCLVLCAnt,cMoedaAnt,cTpSaldAnt)													
						#ENDIF
					EndIf
					
					//Atualiza Flag de Saldos Compostos CL.Valor/C.Custo Credito
					If lClCrd .or. lCCCrd			
						cChave	:= cMoedaAnt+cTpSaldAnt+cCLVLCAnt+cCustoCAnt+DTOS(dData)
						FlgSldComp("CTW",cChave)				
					EndIf								
				
					//Atualiza Flag de Saldos Compostos CL.Valor/Item Credito
					If lClCrd .or. lItCrd							
						cChave	:= cMoedaAnt+cTpSaldAnt+cItemCAnt+cCLVLCAnt+DTOS(dData)
						FlgSldComp("CTX",cChave)				
					EndIf								
				
					//Atualiza Flag de Saldos Compostos CL.Valor/Item./C.Custo Credito
					If lClCrd .or. lItCrd .or. lCCCrd
						cChave	:= cMoedaAnt+cTpSaldAnt+cCLVLCAnt+cItemCAnt+cCustoCAnt+DTOS(dData)
						FlgSldComp("CTY",cChave)				
					EndIf			
				EndIf
			Else
				lMudouSld	:= .T.		
			EndIf			    	
		EndIf
	EndIf	

	If lAtSldBase
		//desgrava saldo do cubo
		If _lCtbIsCube .And. CtbIsCube() .And. (lAtuSldCT7 .or.lAtuSldCT3 .or. lAtuSldCT4 .or. lAtuSldCTI)
			CtbDsGrCub( nValorAnt, cTipoAnt, cTpSaldAnt, cMoedaAnt, dData, cDebitoAnt, cCreditoAnt, cCustoDAnt, cCustoCAnt, cItemDAnt, cItemCAnt, cCLVLDAnt, cCLVLCAnt, aEntidAnt)
		EndIf
	Else
		lMudouSld	:= .T.		
	EndIf			    	

Endif

If  ( cOperacao == "+" .And. nTotInf <> Nil ) .OR. ;
	( cOperacao == "-" .And. nTotInf <> Nil .And. nOpc = 5 )
	BEGIN TRANSACTION
	CtbGrvlInf(dData,cLote,cSubLote,cDoc,cMoeda,nTotInf,nOpc)
	END TRANSACTION
Endif

//Atualiza a ultima data de atualizaÁ„o do saldo
If lMudouSld .And. !lAtSldBase .And. !__IsCtbJob
	If cOperacao == "+"
		AtuCv7Date(cTpSald,cMoeda,dData)
	ElseIf cOperacao == "-"
		AtuCv7Date(cTpSaldAnt,cMoedaAnt,dData)
	EndIf	
EndIf

Return

Static Function GRAVACT7(nOpc,cContaDeb,cContaCrd,cTipo,dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,lZera,dDataLP,lTrbProc,cOperacao)

Local aSaveArea	:= GetArea()
Local lInclui	:= .F.
Local nAntDeb	:= 0
Local nAntCrd	:= 0
Local aSldAntCT7:= {}
Local cChave	:= ""
Local aResult	:= {}
Local nX
Local cConta
Local cTipoAux
Local lDeletSald:= .F.
Local nRecCT7   := 0
Local lCposUsuCT7 := ExistBlock("CTBCT7USU")

Default cOperacao := "+"
Default lTrbProc  := .F.

lReproc 		:= Iif(lReproc==Nil,.F.,lReproc)
lAtSldBase 		:= Iif(lAtSldBase==Nil,.T.,lAtSldBase)                                                                               
lZera			:= Iif(lZera == Nil,.F.,lZera)
dDataLP		    := Iif(dDataLP == Nil, CTOD("  /  /  "), dDataLP)

If Empty(cContaDeb+cContaCrd) .Or. nValor <= 0
	Return
EndIf

DbSelectArea( "CT7" )
DbSetOrder( 1 )  

//If lTrbProc .And. ExistProc("CTB180") 
If .t. .And. ExistProc("CTB180")

	aResult := TCSPEXEC( xProcedures("CTB180"), xFilial("CT7")/*cFilAux*/, cOperacao, cTipo, cContaDeb, cContaCrd, cMoeda,;
		          DTOS(dData), cTpSald, DTOS(dDataLP), nValor, IIf( _lFKInUse, '1' , '0' ) )
   	If Empty(aResult)
		MsgAlert(STR0007+"CTB180") //"Falha na chamada do processo - Gravacao de Saldos - Stored Procedure CTB180"
	Endif

Else

	For nX := 1 TO If(cTipo=='3', 2, 1)
	
		If cTipo == '3'
		
			If nX == 1
				cConta := cContaDeb
				cTipoAux := '1'
			Else
				cConta := cContaCrd
				cTipoAux := '2'
			EndIf
			
		Else 
		
			If cTipo == '1'
				cConta := cContaDeb
				cTipoAux := '1'
			Else
				cConta := cContaCrd
				cTipoAux := '2'
			EndIf
				
		EndIf			

		If Empty(cConta)
			Loop
		EndIf

		If Empty(dDataLP)
			cChave	:= xFilial("CT7")+cMoeda+cTpSald+cConta+Dtos(dData)
		Else
			cChave	:= xFilial("CT7")+cMoeda+cTpSald+cConta+Dtos(dData)+"Z"	
		EndIf
			
		If !MsSeek(cChave,.T.)
			lInclui	:= .T.
		Else
			lInclui := .F.
			//Se nao for lancamento de zeramento e posicionar no saldo de zeramento.
			//Devera ser incluido um novo registro. 		
			If Empty(dDataLP) .And. CT7->CT7_LP == 'Z'
				lInclui := .T.			
			EndIf
		EndIf
		
		//Rotina para recuperar saldo anterior                  
		If !lInclui .And. lZera 	//Se for CTBA360.
			aSldAntCT7 := SldAntCT7(cConta,dData,cMoeda,cTpSald,,.T.)
		Else
			aSldAntCT7 := SldAntCT7(cConta,dData,cMoeda,cTpSald,,lInclui)
		EndIf                                                                 
		
		BEGIN TRANSACTION
			// Nao ha registro para o dia -> cria!!
			If lInclui
				RecLock( "CT7", .t. )
				CT7->CT7_FILIAL 	:= xFilial("CT7")
				CT7->CT7_CONTA		:= cConta
				CT7->CT7_MOEDA		:= cMoeda
				CT7->CT7_DATA		:= dData
				CT7->CT7_TPSALD		:= cTpSald					// Real / Orcado / Gerencial
				CT7->CT7_STATUS		:= "1"						// Periodo Aberto
				If !Empty(dDataLP)
					CT7->CT7_LP 	:= 'Z'						//Se for lancamento de zeramento
					CT7->CT7_DTLP	:= dDataLP
				Else
					CT7->CT7_LP			:= "N"					// Flag indicando que ainda nao foi zerado
				EndIf
			Else			
				RecLock( "CT7", .f. )
				//Se o programa for CTBA360, devo zerar os movimentos
				If lZera
					If cTipoAux == "1"
						CT7->CT7_DEBITO	:= 0
					ElseIf cTipoAux == "2"
						CT7->CT7_CREDIT	:= 0			
					EndIf
				EndIf
			Endif
			
			nRecCT7 := CT7->(Recno())

			nAntDeb	:= aSldAntCT7[1]
			nAntCrd	:= aSldAntCT7[2]
		
			// Grava valores atuais
			// Soma valores aos ja existentes
			If cTipoAux == "1"
				If cOperacao == "-" .And. CT7->CT7_DEBITO < nValor    //se for tirar e o resultado for negativo zera
					CT7->CT7_DEBITO := 0
				Else
					CT7->CT7_DEBITO	:= (CT7->CT7_DEBITO + If(cOperacao=="+",nValor,nValor*-1) )
				EndIf
				CT7->CT7_ANTDEB	:= nAntDeb
				CT7->CT7_ATUDEB	:= CT7->CT7_ANTDEB+CT7->CT7_DEBITO
				CT7->CT7_ANTCRD	:= nAntCrd
				CT7->CT7_ATUCRD	:= CT7->CT7_ANTCRD+CT7->CT7_CREDIT

			ElseIf cTipoAux == "2"
				If cOperacao == "-" .And. CT7->CT7_CREDIT < nValor    //se for tirar e o resultado for negativo zera
					CT7->CT7_CREDIT := 0
				Else	
					CT7->CT7_CREDIT	:= (CT7->CT7_CREDIT + If(cOperacao=="+",nValor,nValor*-1) )
				EndIf	
				CT7->CT7_ANTCRD	:= nAntCrd
				CT7->CT7_ATUCRD	:= CT7->CT7_ANTCRD+CT7->CT7_CREDIT
				CT7->CT7_ANTDEB	:= nAntDeb
				CT7->CT7_ATUDEB	:= CT7->CT7_ANTDEB+CT7->CT7_DEBITO
			EndIf	            	
			
			CT7->CT7_SLBASE	:= "S"
			MsUnlock()
			If cOperacao == '-'
				CT7->(dbCommit())

				//Se na exclusao, zerar os valores de mov. debito e credito, deleta o registro no 
				//arquivo de saldos, pois no reprocessamento nao refaz os saldos que nao tenham 
				//lancamentos no CT2, e da diferenca no balancete.
				If CT7->CT7_CREDIT == 0  .And. CT7->CT7_DEBITO == 0
					RecLock("CT7",.F.,.T.)
					CT7->(dbDelete())
					CT7->(MsUnlock())
					dbSelectArea("CT7")
					dbSkip()
					lDeletSald := .T.
				EndIf
			EndIf
			
		END TRANSACTION
		

		//Chama funcao que grava o saldo anterior e o saldo atual nas datas futuras
		If 		cOperacao == "+"
				GRVSLDCT7(cTipoAux,cConta,cMoeda,cTpSald,dData,nValor,nAntDeb,nAntCrd,lReproc,lAtSldBase,,lZera,cOperacao)
				
		ElseIf 	cOperacao == "-"
							//A variavel latSldBase esta sendo passado como .T. para atualizar o flag		                               		
			If nOpc == 5	//No parametro lReproc esta sendo passado como .F. para atualizar os saldos da data para frente.
				GRVSLDCT7(cTipoAux,cConta,cMoeda,cTpSald,dData,nValor,nAntDeb,nAntCrd,.F.,.T.,,,cOperacao)                       
			Else
				If lDeletSald
					GRVSLDCT7(cTipoAux,cConta,cMoeda,cTpSald,dData,nValor,nAntDeb,nAntCrd,lReproc,.T.,,,cOperacao)                       		
		        Else
					GRVSLDCT7(cTipoAux,cConta,cMoeda,cTpSald,dData,nValor,nAntDeb,nAntCrd,lReproc,lAtSldBase,,,cOperacao)                   		
		        EndIf
			EndIf
				
		EndIf
		
		If lCposUsuCT7 .And. nRecCT7 != 0
			dbSelectArea("CT7")
			dbGoto(nRecCT7)
		Endif

	Next //nX
	
EndIf

RestArea(aSaveArea)
Return

Static Function GRAVACT3(cContaDeb,cCustoDeb,cContaCrd,cCustoCrd,cTipo,dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,lZera,dDataLP,nOpc,lTrbProc,cOperacao)

Local aSaveArea	:= GetArea()
Local lInclui		:= .F.
Local nAntDeb		:= 0
Local nAntCrd		:= 0                                                    
Local aSldAntCT3	:= {}
Local cChave		:= ""
Local aResult 		:= {}
Local nX
Local cConta
Local cCusto
Local cTipoAux
Local lDeletSald:= .F.

Default cOperacao   := "+"
Default lTrbProc    := .F.

lReproc				:= Iif(lReproc == Nil,.F.,lReproc)
lAtSldBase 			:= Iif(lAtSldBase == Nil,.T.,lAtSldBase)
lZera				:= Iif(lZera == Nil,.F.,lZera)
dDataLP				:= Iif(dDataLp == Nil, CTOD("  /  /  "),dDAtaLP)

If Empty(cCustoDeb+cCustoCrd) .Or. nValor <= 0
	Return
EndIf	

DbSelectArea("CT3")
DbSetOrder(1)

If .t. .And. ExistProc("CTB181")

	aResult := TCSPEXEC( xProcedures('CTB181'), xFilial("CT3")/*cFilAux*/, cOperacao, cTipo ,cContaDeb, cContaCrd, ;
						cCustoDeb, cCustoCrd, cMoeda, DTOS(dData), cTpSald, DTOS(dDataLP), nValor, IIf( _lFKInUse, '1' , '0' ) )

   	If Empty(aResult)
		MsgAlert(STR0007+"CTB181") //"Falha na chamada do processo - Gravacao de Saldos - Stored Procedure CTB181"
	Endif

Else

	For nX := 1 TO If(cTipo == "3", 2, 1)

		If cTipo == '3'
		
			If nX == 1
				cConta := cContaDeb
				cCusto := cCustoDeb
				cTipoAux := '1'
			Else
				cConta := cContaCrd
				cCusto := cCustoCrd
				cTipoAux := '2'
			EndIf
			
		Else 
		
			If cTipo == '1'
				cConta := cContaDeb
				cCusto := cCustoDeb
				cTipoAux := '1'
			Else
				cConta := cContaCrd
				cCusto := cCustoCrd				
				cTipoAux := '2'
			EndIf
				
		EndIf			

		If Empty(cCusto)
			Loop
		EndIf
	
		If Empty(dDataLP)
			cChave	:= xFilial("CT3")+cMoeda+cTpSald+cConta+cCusto+Dtos(dData)
		Else
			cChave	:= xFilial("CT3")+cMoeda+cTpSald+cConta+cCusto+Dtos(dData)+"Z"	
		EndIf
		
		If !MsSeek(cChave)
			If cOperacao == "-"
				Return
			EndIf
			lInclui 	:= .T.
		Else
			lInclui		:= .F.
			//Se nao for lancamento de zeramento e posicionar no saldo de zeramento.
			//Devera ser incluido um novo registro. 		
			If Empty(dDataLP) .And. CT3->CT3_LP == 'Z'
				If cOperacao == "-"
					Return
				EndIf
				lInclui := .T.			
			EndIf		
		EndIf	
		
		If cOperacao == "-"
			//Rotina para recuperar saldo anterior
			aSldAntCT3 := SldAntCT3(cConta,cCusto,dData,cMoeda,cTpSald)
		Else
			//Rotina para recuperar saldo anterior
			If !lInclui .And. lZera 	//Se for CTBA360.
				aSldAntCT3 := SldAntCT3(cConta,cCusto,dData,cMoeda,cTpSald,,.T.)
			Else
				aSldAntCT3 := SldAntCT3(cConta,cCusto,dData,cMoeda,cTpSald,,lInclui)
			EndIf
		EndIf
	
		nAntDeb	:= aSldAntCT3[1]
		nAntCrd	:= aSldAntCT3[2]
		
		BEGIN TRANSACTION
			If cOperacao == "+"
				// Nao ha registro para o dia -> cria!!
				If lInclui
					RecLock("CT3",.t.)
					CT3->CT3_FILIAL	:= xFilial("CT3")
					CT3->CT3_CONTA		:= cConta
					CT3->CT3_CUSTO		:= cCusto
					CT3->CT3_MOEDA		:= cMoeda
					CT3->CT3_DATA		:= dData
					CT3->CT3_TPSALD		:= cTpSald                               
					CT3->CT3_STATUS		:= "1"					// Periodo Aberto
					If !Empty(dDataLP)
						CT3->CT3_LP			:= 'Z'				//Indica que eh saldo de zeramento
						CT3->CT3_DTLP		:= dDataLP			
					Else
						CT3->CT3_LP			:= 'N'				//Flag indicando que o saldo ainda nao foi zerado
					EndIf
				Else
					RecLock( "CT3", .f. )
					//Se for rotina de atualizacao de saldos compostos, ira zerar os saldos 
					If lZera
						If 		cTipoAux == "1"
							CT3->CT3_DEBITO	:= 0
						ElseIf 	cTipoAux == "2"
							CT3->CT3_CREDIT	:= 0			
						EndIf
					EndIf		
				EndIf
			Else
				RecLock( "CT3", .f. )
			EndIf
			
			// Grava valores atuais
			If cTipoAux == "1"
				If cOperacao == "-" .And. CT3->CT3_DEBITO < nValor
					CT3->CT3_DEBITO := 0
				Else
					CT3->CT3_DEBITO	:= CT3->CT3_DEBITO + If(cOperacao=="+", nValor, nValor*-1)
					#IFDEF TOP
					CT3->CT3_ANTDEB	:= nAntDeb
					CT3->CT3_ATUDEB	:= CT3->CT3_ANTDEB+CT3->CT3_DEBITO
					CT3->CT3_ANTCRD	:= nAntCrd
					CT3->CT3_ATUCRD	:= CT3->CT3_ANTCRD+CT3->CT3_CREDIT
					#ENDIF				
				EndIf	
	
			ElseIf cTipoAux == "2"
				If cOperacao == "-" .And. CT3->CT3_CREDIT < nValor
					CT3->CT3_CREDIT := 0
				Else
					CT3->CT3_CREDIT	:= CT3->CT3_CREDIT + If(cOperacao=="+", nValor, nValor*-1) 
					#IFDEF TOP
						CT3->CT3_ANTDEB	:= nAntDeb
						CT3->CT3_ATUDEB	:= CT3->CT3_ANTDEB+CT3->CT3_DEBITO
						CT3->CT3_ANTCRD	:= nAntCrd
						CT3->CT3_ATUCRD	:= CT3->CT3_ANTCRD+CT3->CT3_CREDIT
					#ENDIF				
				EndIf	
			EndIf
			
			If cOperacao == "+"	
				//Atualiza flag de saldo basico.	
				#IFDEF TOP
					CT3->CT3_SLBASE	:= "S"
				#ENDIF
				MsUnlock()        			
			ElseIf cOperacao == "-"
				//Se na exclusao, zerar os valores de mov. debito e credito, deleta o registro no 
				//arquivo de saldos, pois no reprocessamento nao refaz os saldos que nao tenham 
				//lancamentos no CT2, e da diferenca no balancete.
				If CT3->CT3_CREDIT == 0  .And. CT3->CT3_DEBITO == 0
					RecLock("CT3",.F.,.T.)
					CT3->(dbDelete())
					CT3->(MsUnlock())
					CT3->(dbCommit())
					dbSelectArea("CT3")
					dbSkip()
					lDeletSald	:= .T.
				Endif
			
			EndIf	
		
		END TRANSACTION
		
		If cOperacao == "+"
			//Chama funcao que grava o saldo anterior e o saldo atual          
			GRVSLDCT3(cTipoAux,cConta,cCusto,cMoeda,cTpSald,dData,nValor,nAntDeb,nAntCrd,lReproc,lAtSldBase,,lZera,"+")
		ElseIf cOperacao == "-"  
			//Chama funcao que grava o saldo anterior e o saldo atual		
			//A variavel lAtSldBase esta sendo passada como .T. para atualizar o flag
			If nOpc == 5 //Se for exclusao de lancamento contabil, atualiza os saldos da data para frente.
				GRVSLDCT3(cTipoAux,cConta,cCusto,cMoeda,cTpSald,dData,nValor,nAntDeb,nAntCrd,.F.,.T.,,,"-")		
			Else
				If lDeletSald
					GRVSLDCT3(cTipoAux,cConta,cCusto,cMoeda,cTpSald,dData,nValor,nAntDeb,nAntCrd,lReproc,.T.,,,"-")				
		        Else
					GRVSLDCT3(cTipoAux,cConta,cCusto,cMoeda,cTpSald,dData,nValor,nAntDeb,nAntCrd,lReproc,lAtSldBase,,,"-")
				EndIf
			EndIf
		EndIf
    
	Next //nX
	
EndIf

RestArea(aSaveArea)

Return 

Static Function GRAVACT4(cContaDeb,cCustoDeb,cItemDeb,cContaCrd,cCustoCrd,cItemCrd,cTipo,dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,lZera,dDataLP,nOpc,lTrbProc,cOperacao)

Local aSaveArea		:= GetArea()
Local lInclui		:= .F.
Local nAntDeb		 := 0
Local nAntCrd	 	:= 0
Local aSldAntCT4	:= {}		
Local cChave		:= ""
Local aResult 		:= {}
Local nX
Local cConta
Local cCusto
Local cItem
Local cTipoAux
Local lDeletSald:= .F.

Default cOperacao   := "+"
Default lTrbProc    := .F.

lReproc 			:= Iif(lReproc==Nil,.F.,lReproc)
lAtSldBase			:= Iif(lAtSldBase==Nil,.T.,lAtSldBase) 
lZera				:= Iif(lZera == Nil,.F.,lZera)
dDataLP				:= Iif(dDataLP == Nil,CTOD("  /  /  "),dDataLP)

If Empty(cItemDeb+cItemCrd) .Or. nValor <= 0
	Return
EndIf	

DbSelectArea("CT4")
DbSetOrder(1)

If .T. .And. ExistProc("CTB182")

	aResult := TCSPEXEC( xProcedures('CTB182'), xFilial("CT4")/*cFilAux*/, cOperacao, cTipo ,cContaDeb, cContaCrd, ;
						cCustoDeb, cCustoCrd, cItemDeb, cItemCrd, cMoeda, DTOS(dData), cTpSald, DTOS(dDataLP), ;
						nValor, IIf( _lFKInUse, '1' , '0' ) )

   	If Empty(aResult)
		MsgAlert(STR0007+"CTB182") //"Falha na chamada do processo - Gravacao de Saldos - Stored Procedure CTB182"		
	Endif

Else

	FOR nX := 1 TO If(cTipo=="3", 2, 1)

		If cTipo == '3'
		
			If nX == 1
				cConta := cContaDeb
				cCusto := cCustoDeb
				cItem  := cItemDeb
				cTipoAux := '1'
			Else
				cConta := cContaCrd
				cCusto := cCustoCrd
				cItem  := cItemCrd				
				cTipoAux := '2'
			EndIf
			
		Else 
		
			If cTipo == '1'
				cConta := cContaDeb
				cCusto := cCustoDeb
				cItem  := cItemDeb				
				cTipoAux := '1'
			Else
				cConta := cContaCrd
				cCusto := cCustoCrd
				cItem  := cItemCrd				
				cTipoAux := '2'
			EndIf
				
		EndIf			

		If Empty(cItem)
			Loop
		EndIf

		If Empty(dDataLP)
			cChave	:= xFilial("CT4")+cMoeda+cTpSald+cConta+cCusto+cItem+Dtos(dData)
		Else
			cChave	:= xFilial("CT4")+cMoeda+cTpSald+cConta+cCusto+cItem+Dtos(dData)+"Z"	
		EndIf
		
		If !MsSeek(cChave)
			If cOperacao == "-"
				Return
			EndIf
			lInclui	:= .T.
		Else
			lInclui	:= .F.
			//Se nao for lancamento de zeramento e posicionar no saldo de zeramento.
			//Devera ser incluido um novo registro. 		
			If Empty(dDataLP) .And. CT4->CT4_LP == 'Z'
				If cOperacao == "-"
					Return
				EndIf
				lInclui := .T.			
			EndIf				
		EndIf

		If 		cOperacao == "-"
				//Rotina para recuperar saldo anterior
				aSldAntCT4 := SldAntCT4(cConta,cCusto,cItem,dData,cMoeda,cTpSald)
		ElseIf 	cOperacao == "+"
			//Rotina para recuperar saldo anterior
			If !lInclui .And. lZera 	//Se for CTBA360.
				aSldAntCT4 := SldAntCT4(cConta,cCusto,cItem,dData,cMoeda,cTpSald,,.T.)
			Else	
				aSldAntCT4 := SldAntCT4(cConta,cCusto,cItem,dData,cMoeda,cTpSald,,lInclui)
			EndIf
		EndIf
                                                                 
		nAntDeb	:= aSldAntCT4[1]
		nAntCrd	:= aSldAntCT4[2]

		BEGIN TRANSACTION

			If cOperacao == "+"		
				// Nao ha registro para o dia -> cria!!
				If lInclui
					RecLock( "CT4", .t. )
					CT4->CT4_FILIAL 	:= xFilial("CT4")
					CT4->CT4_CONTA		:= cConta
					CT4->CT4_CUSTO		:= cCusto
					CT4->CT4_ITEM		:= cItem
					CT4->CT4_MOEDA		:= cMoeda
					CT4->CT4_DATA		:= dData
					CT4->CT4_TPSALD		:= cTpSald
					CT4->CT4_STATUS		:= "1"					// Periodo Aberto
					If !Empty(dDataLP)
						CT4->CT4_LP 	:= 'Z'						//Se for lancamento de zeramento
						CT4->CT4_DTLP	:= dDataLP			
					Else
						CT4->CT4_LP		:= "N"					// Flag indicando que ainda nao foi zerado
					EndIf
				Else
					RecLock( "CT4", .f. )
					//Se for rotina de atualizacao de saldos compostos (CTBA360),
					// deve zerar os movimentos
					If lZera 
						If cTipo == "1"
							CT4->CT4_DEBITO	:= 0
						ElseIf cTipo == "2"
							CT4->CT4_CREDIT	:= 0			
						EndIf
					EndIf		
				Endif
			ElseIf cOperacao == "-"
				RecLock( "CT4", .f. )
			EndIf
				
			// Grava valores atuais
			If cTipoAux == "1"
				If cOperacao == "-" .And. CT4->CT4_DEBITO < nValor
					CT4->CT4_DEBITO := 0
				Else
					CT4->CT4_DEBITO	:= CT4->CT4_DEBITO + If(cOperacao == "+", nValor, nValor*-1)
					#IFDEF TOP
						CT4->CT4_ANTDEB	:= nAntDeb
						CT4->CT4_ATUDEB	:= CT4->CT4_ANTDEB+CT4->CT4_DEBITO
						CT4->CT4_ANTCRD	:= nAntCrd
						CT4->CT4_ATUCRD	:= CT4->CT4_ANTCRD+CT4->CT4_CREDIT
					#ENDIF
				EndIf
			ElseIf cTipoAux == "2"
				If cOperacao == "-" .And. CT4->CT4_CREDIT < nValor
					CT4->CT4_DEBITO := 0
				Else
					CT4->CT4_CREDIT	:= CT4->CT4_CREDIT + If(cOperacao=="+", nValor, nValor*-1)
					#IFDEF TOP
						CT4->CT4_ANTDEB	:= nAntDeb
						CT4->CT4_ATUDEB	:= CT4->CT4_ANTDEB+CT4->CT4_DEBITO
						CT4->CT4_ANTCRD	:= nAntCrd
						CT4->CT4_ATUCRD	:= CT4->CT4_ANTCRD+CT4->CT4_CREDIT
					#ENDIF				
				EndIf
			EndIf

			If cOperacao == "+"	
				//Atualiza flag de saldo basico.	
				#IFDEF TOP
					CT4->CT4_SLBASE	:= "S"
				#ENDIF	
				MsUnlock()
			ElseIf cOperacao == "-"
				//Se na exclusao, zerar os valores de mov. debito e credito, deleta o registro no 
				//arquivo de saldos, pois no reprocessamento nao refaz os saldos que nao tenham 
				//lancamentos no CT2, e da diferenca no balancete.
				If CT4->CT4_CREDIT == 0  .And. CT4->CT4_DEBITO == 0
					RecLock("CT4",.F.,.T.)
					CT4->(dbDelete())
					CT4->(MsUnlock())
					CT4->(dbCommit())
					dbSelectArea("CT4")
					dbSkip()
					lDeletSald	:= .T.
				EndIf
			EndIf

		END TRANSACTION

		If cOperacao == "+"
			//Chama funcao que grava o saldo anterior e o saldo atual
			GRVSLDCT4(cTipoAux,cConta,cCusto,cItem,cMoeda,cTpSald,dData,nValor,nAntDeb,nAntCrd,lReproc,lAtSldBase,,lZera,"+")
		ElseIf cOperacao == "-" 
			//Chama funcao que grava o saldo anterior e o saldo atual		
			//A variavel lAtSldBase esta sendo passada como .T. para atualizar o flag
			If nOpc == 5
				GRVSLDCT4(cTipo,cConta,cCusto,cItem,cMoeda,cTpSald,dData,nvAlor,nAntDeb,nAntCrd,.F.,.T.,,,"-")
			Else
				If lDeletSald
					GRVSLDCT4(cTipo,cConta,cCusto,cItem,cMoeda,cTpSald,dData,nvAlor,nAntDeb,nAntCrd,lReproc,.T.,,,"-")		
		    	Else
					GRVSLDCT4(cTipo,cConta,cCusto,cItem,cMoeda,cTpSald,dData,nValor,nAntDeb,nAntCrd,lReproc,lAtSldBase,,,"-")		
				Endif
			EndIf
		EndIf
		
	Next  //nX

EndIf

RestArea(aSaveArea)

Return                                    


Static Function GRAVACTI(cContaDeb,cCustoDeb,cItemDeb,cClVlrDeb,cContaCrd,cCustoCrd,cItemCrd,cClVlrCrd,cTipo,dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,lZera,dDataLP,nOpc,lTrbProc,cOperacao)

Local aSaveArea		:= GetArea()
Local lInclui		:= .F.
Local nAntDeb		:= 0
Local nAntCrd		:= 0                     
Local aSldAntCTI 	:= {}
Local cChave		:= ""
Local aResult 		:= {}
Local nX
Local cConta
Local cCusto
Local cItem
Local cClasseVlr
Local cTipoAux
Local lDeletSald:= .F.

Default cOperacao   := "+"
Default lTrbProc    := .F.

lReproc 			:= Iif(lReproc==Nil,.F.,lReproc)
lAtSldBase			:= Iif(lAtSldBase==Nil,.T.,lAtSldBase) 
lZera				:= Iif(lZera == Nil,.F.,lZera)
dDataLP				:= Iif(dDataLP == Nil,CTOD("  /  /  "),dDataLP)

If Empty(cClVlrDeb+cClVlrCrd) .Or. nValor <= 0
	Return
EndIf	

DbSelectArea("CTI")
DbSetOrder(1)

If .t. .And. ExistProc("CTB183")

	aResult := TCSPEXEC( xProcedures('CTB183'), xFilial("CTI")/*cFilAux*/, cOperacao, cTipo ,cContaDeb, cContaCrd, ;
						cCustoDeb, cCustoCrd, cItemDeb, cItemCrd, cClVlrDeb, cClVlrCrd, cMoeda, DTOS(dData), cTpSald, ;
						DTOS(dDataLP), nValor, IIf( _lFKInUse, '1' , '0' ) )

   	If Empty(aResult)
		MsgAlert(STR0007+"CTB183") //"Falha na chamada do processo - Gravacao de Saldos - Stored Procedure CTB183"		
	Endif

Else

	FOR nX := 1 TO If(cTipo=="3", 2, 1)

		If cTipo == '3'
		
			If nX == 1
				cConta 		:= cContaDeb
				cCusto 		:= cCustoDeb
				cItem  		:= cItemDeb
				cClasseVlr 	:= cClVlrDeb
				cTipoAux 	:= '1'
			Else
				cConta 		:= cContaCrd
				cCusto 		:= cCustoCrd
				cItem  		:= cItemCrd				
				cClasseVlr 	:= cClVlrCrd
				cTipoAux 	:= '2'
			EndIf
			
		Else 
		
			If cTipo == '1'
				cConta 		:= cContaDeb
				cCusto 		:= cCustoDeb
				cItem  		:= cItemDeb				
				cClasseVlr 	:= cClVlrDeb
				cTipoAux 	:= '1'
			Else
				cConta 		:= cContaCrd
				cCusto 		:= cCustoCrd
				cItem  		:= cItemCrd				
				cClasseVlr 	:= cClVlrCrd
				cTipoAux 	:= '2'
			EndIf
				
		EndIf			

		If Empty(cClasseVlr)
			Loop
		EndIf
	
		If Empty(dDataLP)
			cChave	:= xFilial("CTI")+cMoeda+cTpSald+cConta+cCusto+cItem+cClasseVlr+Dtos(dData)
		Else
			cChave	:= xFilial("CTI")+cMoeda+cTpSald+cConta+cCusto+cItem+cClasseVlr+Dtos(dData)+"Z"	
		EndIf
		
		If !MsSeek(cChave)
			If cOperacao == "-"
				Return
			EndIf
			lInclui := .T.
		Else
			lInclui	:= .F.
			//Se nao for lancamento de zeramento e posicionar no saldo de zeramento.
			//Devera ser incluido um novo registro. 		
			If Empty(dDataLP) .And. CTI->CTI_LP == 'Z'
				If cOperacao == "-"
					Return
				EndIf
				lInclui := .T.			
			EndIf
		EndIf

		If 		cOperacao == "-"
			//Rotina para recuperar saldo anterior
			aSldAntCTI := SldAntCTI(cConta,cCusto,cItem,cClasseVlr,dData,cMoeda,cTpSald)
		ElseIf 	cOperacao == "+"
			//Rotina para recuperar saldo anterior
			If !lInclui .And. lZera 	//Se for CTBA360.
				aSldAntCTI := SldAntCTI(cConta,cCusto,cItem,cClasseVlr,dData,cMoeda,cTpSald,,.T.)
			Else	
				aSldAntCTI := SldAntCTI(cConta,cCusto,cItem,cClasseVlr,dData,cMoeda,cTpSald,,lInclui)
			EndIf
		EndIf
                                                                 
		nAntDeb	:= aSldAntCTI[1]
		nAntCrd	:= aSldAntCTI[2]
		
		
		BEGIN TRANSACTION
			If cOperacao == "+"		
				// Nao ha registro para o dia -> cria!!
				If lInclui
					RecLock( "CTI", .t. )
					CTI->CTI_FILIAL 	:= xFilial("CTI")
					CTI->CTI_CLVL		:= cClasseVlr
					CTI->CTI_CONTA		:= cConta
					CTI->CTI_CUSTO		:= cCusto
					CTI->CTI_ITEM		:= cItem
					CTI->CTI_MOEDA		:= cMoeda
					CTI->CTI_DATA		:= dData
					CTI->CTI_TPSALD	:= cTpSald
					CTI->CTI_STATUS	:= "1"					// Periodo Aberto
					If !Empty(dDataLP)
						CTI->CTI_LP 	:= 'Z'						//Se for lancamento de zeramento
						CTI->CTI_DTLP	:= dDataLP			
					Else
						CTI->CTI_LP		:= "N"					// Flag indicando que ainda nao foi zerado
					EndIf
			
				Else
					RecLock( "CTI", .f. )
					//Se for chamado pela rotina de Atualizacao de Saldos Compostos, 
					// os movimentos devem ser zerados.
					If lZera      
						If cTipoAux == "1"
							CTI->CTI_DEBITO	:= 0
						ElseIf cTipoAux == "2"				
							CTI->CTI_CREDIT	:= 0			
						EndIf
					EndIf		
				Endif
			ElseIf cOperacao == "-"
				RecLock( "CTI", .f. )
			Endif
				
			// Grava valores atuais
			If cTipoAux == "1"
				If cOperacao == "-" .And. CTI->CTI_DEBITO < nValor
					CTI->CTI_DEBITO := 0
				Else
					CTI->CTI_DEBITO	:= CTI->CTI_DEBITO + If(cOperacao=="+", nValor, nValor*-1)
					#IFDEF TOP
					CTI->CTI_ANTDEB	:= nAntDeb	
					CTI->CTI_ATUDEB	:= CTI->CTI_ANTDEB+CTI->CTI_DEBITO		
					CTI->CTI_ANTCRD	:= nAntCrd		
					CTI->CTI_ATUCRD	:= CTI->CTI_ANTCRD+CTI->CTI_CREDIT
					#ENDIF	
				EndIf
			ElseIf cTipoAux == "2"
				If cOperacao == "-" .And. CTI->CTI_CREDIT < nValor
					CTI->CTI_CREDIT := 0
				Else			                                   
					CTI->CTI_CREDIT	:= CTI->CTI_CREDIT + If(cOperacao=="+", nValor, nValor*-1)
					#IFDEF TOP
					CTI->CTI_ANTCRD	:= nAntCrd	
					CTI->CTI_ATUCRD	:= CTI->CTI_ANTCRD+CTI->CTI_CREDIT		
					CTI->CTI_ANTDEB	:= nAntDeb		
					CTI->CTI_ATUDEB	:= CTI->CTI_ANTDEB+CTI->CTI_DEBITO		
					#ENDIF	
				EndIf	
			EndIf
			
			If cOperacao == "+"		
				//Atualiza flag de saldo basico.	
				#IFDEF TOP
					CTI->CTI_SLBASE	:= "S"
				#ENDIF	
				MsUnlock()
			ElseIf cOperacao == "-"
				//Se na exclusao, zerar os valores de mov. debito e credito, deleta o registro no 
				//arquivo de saldos, pois no reprocessamento nao refaz os saldos que nao tenham 
				//lancamentos no CT2, e da diferenca no balancete.
				If CTI->CTI_CREDIT == 0  .And. CTI->CTI_DEBITO == 0
					RecLock("CTI",.F.,.T.)
					CTI->(dbDelete())
					CTI->(MsUnlock())
					CTI->(dbCommit())
					dbSelectArea("CTI")
					dbSkip()
					lDeletSald	:= .T.
				EndIf
			EndIf

		END TRANSACTION
		
		If cOperacao == "+"
			//Chama funcao que grava o saldo anterior e o saldo atual
			GRVSLDCTI(cTipoAux,cConta,cCusto,cItem,cClasseVlr,cMoeda,cTpSald,dData,nValor,nAntDeb,nAntCrd,lReproc,lAtSldBase,,lZera,"+")
		ElseIf cOperacao == "-"
			//Chama funcao que grava o saldo anterior e o saldo atual			
			//A variavel lAtSldBase esta sendo passada como .T. para atualizar o flag
			If nOpc == 5
				GRVSLDCTI(cTipo,cConta,cCusto,cItem,cClasseVlr,cMoeda,cTpSald,dData,nValor,nAntDeb,nAntCrd,.F.,.T.,,,"-")	
			Else
				If lDeletSald
					GRVSLDCTI(cTipo,cConta,cCusto,cItem,cClasseVlr,cMoeda,cTpSald,dData,nValor,nAntDeb,nAntCrd,lReproc,.T.,,,"-")	
				Else
					GRVSLDCTI(cTipo,cConta,cCusto,cItem,cClasseVlr,cMoeda,cTpSald,dData,nValor,nAntDeb,nAntCrd,lReproc,lAtSldBase,,,"-")
				EndIf
			EndIf
		EndIf
		
	Next //nX
			
EndIf

RestArea(aSaveArea)

Return                                    