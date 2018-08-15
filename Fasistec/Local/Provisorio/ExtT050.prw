#INCLUDE "SPEDFISCAL.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWCOMMAND.CH"
#INCLUDE "SPEDXDEF.CH"

//------------------------------------------------------------------------
// Chamada das funcoes de cache do dicionario na inicializacao do SPEDXFUN
//------------------------------------------------------------------------
Static aSPDSX2 	  := SpedLoadX2()
Static aSPDSX3    := SpedLoadX3()
Static aSPDSX6    := SpedLoadX6()
Static aExistBloc := SPDFRetPEs()


//--------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} BlocoG

Função responsável pelo processamento das informações de movimentação CIAP, sendo
utilizada tanto para geração do Bloco G do Sped Fiscal quanto o registro T050
do extrator fiscal

Registros Gerados:
	Registro G110 ( Sped ) / T050   ( Extrator ) - ICMS Ativo Permanente - CIAP
	Registro G125 ( Sped ) / T050AA ( Extrator ) - Movimentação de Bem ou Componente do Ativo Imobilizado
	Registro G126 ( Sped ) / T050AB ( Extrator ) - Outros Créditos do CIAP
	Registro G130 ( Sped ) / T050AC ( Extrator ) - Identificação do Documento de Entrada do Bem/Ativo
	Registro G140 ( Sped ) / T050AD ( Extrator ) - Identificação do Item do Documento de Entrada do Bem/Ativo

@Param:
cAlias      -> Alias do TRB
lTop        -> Flag para identificar ambiente TOP
aWizard     -> Informacoes do assistente da rotina
aReg0200    -> Estrutura do registro de produtos
aReg0190    -> Estrutura do registro de unidades de medida
aReg0220    -> Estrutura do registro 0220
aReg0150    -> Array cadastral com as informacoes do participante
cFilDe      -> Filial inicial para processament multifilial
cFilAte     -> Filial final para processament multifilial
aLisFil     -> Listas das filiais validas para processament multifilial
bWhileSM0   -> Condicao padrao para o while do SM0
lEnd        -> Flag de cancelamento de execucao
nCtdFil     -> Quantidade de registros da tabela SM0 que serao processados
nCountTot   -> Total de registros a serem processados no periodo
nRegsProc   -> Registros jah processados antes da chamada desta funca
oProcess    -> Objeto da nova barra de progressao
lExtratTAF  -> Indica se a chamada foi via extrator fiscal
aRegT050    -> Array para geração do registro T050 do extrator fiscal
aRegT050AA  -> Array para geração do registro T050AA do extrator fiscal
aRegT050AB  -> Array para geração do registro T050AB do extrator fiscal
aRegT050AC  -> Array para geração do registro T050AC do extrator fiscal
aRegT050AD  -> Array para geração do registro T050AD do extrator fiscal
aRegT008    -> Array para geração do registro T008 que somente é gerado quando existe movimentação do CIAP
aRegT008Aux -> Array auxiliar para geração dos registros referentes ao 0305 do Sped Fiscal no extrator

@Author Gustavo G. Rueda
@since  17/03/2011
@version 1.0

@Altered By:
Rodrigo Aguilar ( 09/12/2016 ): Implementando a geração dos registros da familia T050
do extrator fiscal do Protheus

@Return ( Nil )

/*/
//--------------------------------------------------------------------------------------------------------------
Function BlocoG( cAlias,lTop,aWizard,aReg0200,aReg0190,aReg0220,aReg0150,cFilDe,cFilAte,aLisFil,bWhileSM0,;
			     lEnd,nCtdFil,nCountTot,nRegsProc,oProcess,lExtratTAF,aRegT050,aRegT050AA,aRegT050AB,;
			     aRegT050AC,aRegT050AD, aRegT008, aRegT008Aux )
Local 	nPos     	:= 	0
Local 	aCoef		:=	{}
Local 	nFator		:=  0
Local 	nTotSai	:=  0
Local 	nTotTrib	:=  0
Local	cAliasSFA	:=	"SFA"
Local	cAliasSF9	:=	"SF9"
Local	dDataDe	:=	''
Local	dDataAte	:=	''
Local 	aRegG125 	:= 	{}
Local	aRegG126	:=	{}
Local	aRegG130	:=	{}
Local	aRegG140	:=	{}
Local	aReg0300	:=	{}
Local	aReg0305	:=	{}
Local	aReg0500	:=	{}
Local	aReg0600	:=	{}
Local	cCodCiap	:=	""
Local	nQtdPSFA	:=	0
Local 	dLei102 	:= 	aSPDSX6[MV_DATCIAP]
Local	nPLC102		:=	aSPDSX6[MV_LC102]
Local	nLimParc		:=	0
Local	lGeraBA		:=	.F.
Local	lGeraSI		:=	.F.
Local	nTo			:=	1
Local	lFTDESPICM	:=	aSPDSX3[FP_FT_DESPICM]
Local	cMVCIAPDAC	:=	aSPDSX6[MV_CIAPDAC]
Local	cDespAcICM	:=	cMVCIAPDAC
Local	nQtdSF9		:=	1
Local	lAchouSA2	:=	.F.
Local	lAchouSB1	:=	.F.
Local 	cSf9Item	:=	aSPDSX6[MV_F9ITEM]
Local 	cSf9Prod	:=	aSPDSX6[MV_F9PROD]
Local 	cSf9Esp		:=	aSPDSX6[MV_F9ESP]
Local 	cF9ChvNfe	:=	aSPDSX6[MV_F9CHVNF]
Local	nPosg130	:=	0
Local	aParFil		:=	{ '', '' }
Local	aInfRegs	:=	{}
Local	nI			:=	0
Local	nX			:=	0
Local   nA          :=  0
Local	nC04G110	:=	0
Local	nC05G110	:=	0
Local	nC10G110	:=	0
Local	nRecnoSD1	:=	Nil
Local	nRecnoSB1	:=	Nil
Local	nRecnoSFT	:=	Nil
Local	nRecnoSA2	:=	Nil
Local	nRecnoSN1	:=	Nil
Local	nRecnoSN3	:=	Nil
Local	nRecnoSF9	:=	Nil
Local 	cSf9CC		:=	aSPDSX6[MV_F9CC]
Local 	cSf9PL		:=	aSPDSX6[MV_F9PL]
Local	lCtbInUse	:=	CtbInUse()
Local	cMVF9CTBCC	:=	aSPDSX6[MV_F9CTBCC]
Local	aAreaSM0	:=	{}

Local	nFilial		:=	0
Local	cTimeDocs	:=	""
Local	nDocsXTime	:=	1
Local	nEmpProc	:=	0
Local 	cSF9FRT		:=	aSPDSX6[MV_F9FRT]
Local 	cSF9ICMST	:=	aSPDSX6[MV_F9ICMST]
Local 	cSF9DIF		:=	aSPDSX6[MV_F9DIF]
Local 	lF9SKPNF	:=	aSPDSX6[MV_F9SKPNF]
Local	cMVF9FUNC	:=	aSPDSX6[MV_F9FUNC]
Local   cMVSF9PDes  :=  aSPDSX6[MV_SF9PDES]
Local	nSv1Progress:=	0
Local	nSv2Progress:=	0
Local	cAliasAux	:=	""
Local	cMVF9GENCC	:=	aSPDSX6[MV_F9GENCC]
Local	cMVF9GENCT	:=	aSPDSX6[MV_F9GENCT]
Local 	cF9VLLEG	:=	aSPDSX6[MV_F9VLLEG]
Local	nVLLEG		:=	0
Local	lRndCiap	:=	aSPDSX6[MV_RNDCIAP]			// Parametro para arredondamento da apropriacao
Local	dDataBem	:=	CToD("  /  /  ")
Local	cTpMovBem	:=	"  "
Local 	cDaCiap   	:= 	AllTrim(aSPDSX6[MV_DACIAP]) //Utilizado para calc. ICMS no CIAP. Se S= Considera valor de dif. aliquota se N= Nao considera dif. aliquota
Local	lMVF9CDATF	:=	aSPDSX6[MV_F9CDATF]			//Parametro utilizado para alterar o codigo do bem gerado no arquivo para utilizar o codigo do SN1
Local	lAchouSN3	:=	.F.

Local	aCmpsSF9	:=	{"","","","","","","","","",0,"","","","","",0,"",0,"",0,"",0,"",0,"","","",""}
Local	nVlrBxPSFA	:=	0
Local 	lMVAprComp	:= aSPDSX6[MV_APRCOMP]
Local 	lMVBemEnt	:= aSPDSX6[MV_ESTADO] $ aSPDSX6[MV_BEMENT]
Local 	lSpedG126 	:= aExistBloc[15]
Local	nGera125IM	:= 0
Local  nX126		:= 0
Local  lSTCIAP	:= aSPDSX6[MV_STCIAP]
Local 	cMVEstado 	:= aSPDSX6[MV_ESTADO]
Local	aAreaSF9	:=	{}
Local nQtdComp		:= 0
Local cDataComp		:= ""
Local lSomaBem		:= .F.
Local lMvSomaBem	:= aSPDSX6[MV_SOMABEM]
Local aRegG125Co	:= {}
Local aRegG125St	:= {}
Local aRegG125Fr	:= {}
Local aRegG125Cm	:= {}
Local nPosComp		:= 0
Local nPosG125		:= 0
Local nTotD1FT		:= 0
Local nTotD1FT       := 0
Local nA             := 0
Local aInfRegCom     :=  {}

Local nX3codBem		:= TamSx3("F9_CODIGO")[1]
Local cPerG126 		:= ''
Local ProdG126 		:= .F.

Local nX3codBem		:= TamSx3("F9_CODIGO")[1]
Local cPerG126 		:= ''
Local ProdG126 		:= .F.

Default lExtratTAF    := .F.
Default aRegT050      := {}
Default aRegT050AA    := {}
Default aRegT050AB    := {}
Default aRegT050AC    := {}
Default aRegT050AD    := {}
Default aRegT008      := {}
Default aRegT008Aux   := {}

//---------------------------------------------------------
//Tratamento para quando a chamada seja via extrator fiscal
//---------------------------------------------------------
if !lExtratTAF
	dDataDe  := SToD( aWizard[1][1] )
	dDataAte := STod( aWizard[1][2] )
else
	dDataDe  := aWizard[1][3]
	dDataAte := aWizard[1][4]
endif

If aSPDSX2[AI_F0W]  //verifica existencia de dados para periodo apurado
	cPerG126 		:= cvaltochar(strzero(month(dDataDe),2)) + cvaltochar(year(dDataAte ))
	DbSelectArea("F0W")
	F0W->(DbSetOrder(3))
	IF F0W->(MsSeek(xFilial("F0W")+cPerG126))
		ProdG126  :=  .T.
	Else
		ProdG126  :=  .F.
	Endif
	F0W->(dbCloseArea())
Endif

aAreaSM0 := SM0->(GetArea())
aParFil  := { DToS( dDataDe ), DToS( dDataAte ) }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montando array com os campos opcionais para geracao do arquivo caso³
//³ nao tenha integracao com o documento fiscal                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SF9->(FieldPos(cSf9Esp))>0
	aCmpsSF9[1]	:=	cSf9Esp
EndIf

If SF9->(FieldPos(cF9ChvNfe))>0
	aCmpsSF9[3]	:=	cF9ChvNfe
EndIf

If SF9->(FieldPos(cSf9Item))>0
	aCmpsSF9[5]	:=	cSf9Item
EndIf

If SF9->(FieldPos(cSf9Prod))>0
	aCmpsSF9[7]	:=	cSf9Prod
EndIf

If SF9->(FieldPos(cMVF9FUNC))>0
	aCmpsSF9[9]	:=	cMVF9FUNC
EndIf

If SF9->(FieldPos(cSf9CC))>0
	aCmpsSF9[11]	:=	cSf9CC
EndIf

If SF9->(FieldPos(cSf9PL))>0
	aCmpsSF9[13]	:=	cSf9PL
EndIf

aCmpsSF9[15]	:=	"F9_VIDUTIL"

If SF9->(FieldPos(cSF9FRT))>0
	aCmpsSF9[17]	:=	cSF9FRT
EndIf

If SF9->(FieldPos(cSF9ICMST))>0
	aCmpsSF9[19]	:=	cSF9ICMST
EndIf

If SF9->(FieldPos(cSF9DIF))>0
	aCmpsSF9[21]	:=	cSF9DIF
EndIf

If SF9->(FieldPos(cF9VLLEG))>0
	aCmpsSF9[23]	:=	cF9VLLEG
EndIf

If SF9->(FieldPos(cMVSF9PDes))>0
	aCmpsSF9[25]    :=  cMVSF9PDes
EndIf

aCmpsSF9[27] := "F9_CODIGO"

//--------------------------------------------------------------------
//No caso de o objeto oProcess existir, significa que a nova barra
//de processamento (CLASSE Fiscal) estah em uso pela rotina,
//portanto deve ser efetuado os controles para demonstrar o
//resultado do processamento.

//Já que estah rotina efetua o processamento multi-filiais, preciso
//corrigir a posicao da regua, pois no while principal da SFT
//deixou a barra no final, pois processou todas as filiais.
//--------------------------------------------------------------------
If Type( "oProcess" ) == "O"
	oProcess:Set1Progress( nCtdFil )
EndIf

//-------------------------------
//Processamento de multifiliais
//-------------------------------
DbSelectArea ("SM0")
SM0->(DbGoTop ())
SM0->(MsSeek ( cEmpAnt + cFilDe, .T.) )	//Pego a filial mais proxima

//-----------------------------------------------------------------------------
//Quando a opcao de seleciona filiais estiver configurada como sim, serah
//considerado as filiais selecionadas no browse. Caso contrario, valera o
//que estiver configurado na pergunta 'Filial DE/ATE'
//-----------------------------------------------------------------------------
Do While Eval( bWhileSM0 )

	//--------------------------------------------------------------------------------------------------
	//Quando a chamada for via extrator não realizo o tratamento de filiais, pois sempre será processada
	//apenas para a filial corrente do sistema ( cFilAnt )
	//--------------------------------------------------------------------------------------------------
	cFilAnt	:= 	FWGETCODFILIAL

	If Len( aLisFil ) > 0 .And. cFilAnt <= cFilAte

       nFilial := Ascan( aLisFil,{ |x| x[2] == cFilAnt } )

	   If nFilial == 0 .Or. !( aLisFil[ nFilial,1 ] )  //Filial não marcada, vai para proxima
			SM0->(dbSkip())
			Loop
		EndIf
	Else
		If (!lExtratTAF .and. "1" $ aWizard[1][12]) .or. (lExtratTAF .and. "1" $ aWizard[1][5])  //Somente faz skip se a opção de selecionar filiais estiver como Sim.
			 SM0->( dbSkip())
			 Loop
		EndIf
	EndIf

	nEmpProc +=	1
	lConcFil := aSPDSX6[MV_COFLSPD]

	//--------------------------------------------------------------------
	//No caso de o objeto oProcess existir, significa que a nova barra
	// de processamento (CLASSE Fiscal) estah em uso pela rotina,
	// portanto deve ser efetuado os controles para demonstrar o
	// resultado do processamento.
	//Definicao o primeiro incremento da regua
	//--------------------------------------------------------------------
	If Type( "oProcess" ) == "O"
		oProcess:Inc1Progress( STR0023 + cEmpAnt + "/" + cFilAnt, StrZero( nEmpProc, 3 ) + "/" + StrZero( nCtdFil, 3) )	//"Processando empresa :"
		oProcess:Inc2Progress( "Processando movimentos de CIAP...", StrZero( nRegsProc, 6 ) + "/" + StrZero( nCountTot, 6 ) )

		//------------------------------------
		//Controle do cancelamento da rotina
		//------------------------------------
		If oProcess:Cancel()
			Exit
		EndIf

	Else

		//------------------------------------
		//Controle do cancelamento da rotina
		//------------------------------------
		If Interrupcao( @lEnd )
			Exit
		EndIf
	EndIf
	//-----------------------------------------------------------
	//Filtro na tabela SFA com JOIN na tabela SF9 caso seja TOP
	// Alterado conforme chamado: TQDD21
	//-----------------------------------------------------------
	If nCountTot > 0 .And. SPEDFFiltro( 1, "SF92", @cAliasSF9, aParFil ) .And. cMVEstado <> "PE"

		//------------------------------------------------------------------
		//Para ambiente TOP, crio uma copia da tabela SFA para ler algumas
		//informacoes de outros registros fora do periodo. Para TOP, as
		//informacoes jah estao no SELECT
		//------------------------------------------------------------------

		If !lTop
			If Select("__SFA")<>0
				__SF9->(DbCloseArea ())
			EndIf
			ChkFile ("SFA", .F., "__SFA")

			SPEDFFiltro(1,"SFA5",@cAliasSFA,aParFil)
			//EXECUTO PARA BUSCA DAS INFORMAÇÕES DA SFA
		else
			//adiciono o mesmo nome, para não trocar os alias abaixo
			cAliasSFA := cAliasSF9
		EndIf

		//---------------------------------------
		//Processando a tabela SFA jah filtrada
		//---------------------------------------
		While (cAliasSF9)->( !Eof() )

			nRegsProc	+=	1

			//--------------------------------------------------------------------
			//No caso de o objeto oProcess existir, significa que a nova barra
			//de processamento (CLASSE Fiscal) estah em uso pela rotina,
			//portanto deve ser efetuado os controles para demonstrar o
			//resultado do processamento.

			//Efetuando o incremento da segunda regua com as informacoes
			//atualizadas e atualizando os detalhes do processamento
			//--------------------------------------------------------------------
			If Type( "oProcess" ) == "O"

				oProcess:Inc2Progress( "Processando movimentos de CIAP...", StrZero( nRegsProc, 6 ) + "/" + StrZero( nCountTot, 6 ) )
				//--------------------------------------------------------------------
				//Condicao implementada para controlar os numeros apresentadas na tela
				//de processamento da rotina, os detalhes.
				//--------------------------------------------------------------------
				If cTimeDocs <> Time() .and. !lExtratTAF
					oProcess:SetDetProgress(STR0026,nCountTot,;					//"Total de registros do periodo solicitado"
							STR0027,nDocsXTime,;								//"Total de registros processados por segundo"
							STR0028,nCountTot-nRegsProc,;      				    //"Total de registros pendentes para processamento"
							STR0029,Round((nCountTot-nRegsProc)/nDocsXTime,0))	//"Tempo estimado para termino do processamento (Seg.)"

					cTimeDocs	:=	Time()
					nDocsXTime	:=	1
				Else

					nDocsXTime	+=	1
				EndIf

				//------------------------------------
				//Controle do cancelamento da rotina
				//------------------------------------
				If oProcess:Cancel()
					Exit
				EndIf
			Else

				IncProc("Processando movimentos de CIAP...")

				//------------------------------------
				//Controle do cancelamento da rotina
				//------------------------------------
				If Interrupcao(@lEnd)
					Exit
				EndIf

			EndIf


			If !lTop
				//SE NAO DEU ENTRADA DENTRO DO PERIODO NAO TRAZ O ITEM, PORÉM CASO HAJA UTILIZAÇÃO MANTEM O PROCESSAMENTO
				If ((cAliasSF9)->F9_DTENTNE < dDataDe .OR. (cAliasSF9)->F9_DTENTNE > dDataAte)
					If !SPEDSeek(cAliasSFA,,xFilial("SFA")+(cAliasSF9)->F9_CODIGO)
						(cAliasSF9)->(DBSKIP())
				 		loop
				 	EndIf
				EndIf
			EndIf

			If lTop
		       nRecnoSF9	:=	(cAliasSF9)->SF9RECNO
				nRecnoSFT	:=	(cAliasSF9)->SFTRECNO
				nRecnoSD1	:=	(cAliasSF9)->SD1RECNO
				nRecnoSA2	:=	(cAliasSF9)->SA2RECNO
				nRecnoSB1	:=	(cAliasSF9)->SB1RECNO
				nRecnoSN1	:=	(cAliasSF9)->SN1RECNO
				nRecnoSN3	:=	(cAliasSF9)->SN3RECNO
				nRecnoSFA	:=	(cAliasSF9)->SFARECNO
			Else
				//POSICIONO CASO TENHA SFA
				SPEDSeek(cAliasSFA,,xFilial("SFA")+(cAliasSF9)->F9_CODIGO)
			EndIf
			//POSICIONO PARA NÃO SE PERDER NA SF9 PARA DBF JÁ UTILIZA SF9 NO WHILE
			If lTop
				SPEDSeek("SF9",,xFilial("SF9")+(cAliasSF9)->F9_CODIGO,nRecnoSF9)
			EndIF


			nQtdPSFA	:=	0
			nQtdSF9		:=	1
			cCodCiap	:=	SF9->F9_CODIGO+Iif(lConcFil,xFilial("SF9"),"")
			nFator  	:=	(cAliasSFA)->FA_FATOR
			nLimParc  	:=	nPLC102
			lGeraBA		:=	.F.
			lGeraSI		:=	.F.
			nTo			:=	1
			lAchouSD1	:=	.F.
			lAchouSFT	:=	.F.
			lAchouSA2	:=	.F.
			lAchouSB1	:=	.F.
			lAchouSN3	:=	.F.
			aInfRegs	:=	{}
			nVLLEG		:=	0
			cDespAcICM	:=	cMVCIAPDAC
			nVlrBxPSFA	:=	0
			nTotSai 	:=	(cAliasSFA)->FA_TOTSAI
			nTotTrib	:=	(cAliasSFA)->FA_TOTTRIB

			//-----------------------------------------------
			//Se NAO for TOP tenho que posicioar a tabela SF9
			//-----------------------------------------------
			If !lTop
				nQtdSF9		:=	SpedBGQf9( SF9->F9_DOCNFE,SF9->F9_DTENTNE,SF9->F9_SERNFE,SF9->F9_FORNECE,SF9->F9_LOJAFOR,SF9->F9_ITEMNFE )

			Else
				cAliasAux	:=	"SF9"
				nQtdSF9		:=	0
				aParFil		:=	{}

				aAdd( aParFil, DToS( SF9->F9_DTENTNE ) )
				aAdd( aParFil, SF9->F9_DOCNFE  )
				aAdd( aParFil, SF9->F9_SERNFE  )
				aAdd( aParFil, SF9->F9_FORNECE )
				aAdd( aParFil, SF9->F9_LOJAFOR )
				aAdd( aParFil, SF9->F9_ITEMNFE )

				If SPEDFFiltro( 1, "SF9", @cAliasAux, aParFil )
					nQtdSF9	:=	(cAliasAux)->QTDSF9
					SPEDFFiltro( 2, , cAliasAux )
				EndIf

			EndIf

   			//-----------------------------------------------------------------------------------------------------
        	//Se for baixa pela rotina do ativo fixo, se for baixa total, ter quantidade de parcelas, não ter saldo
   			//-----------------------------------------------------------------------------------------------------
        	IF (cAliasSFA)->FA_ROTINA == "ATFA030" .AND. (cAliasSFA)->FA_BAIXAPR == "0" .AND. (cAliasSFA)->FA_TIPO == "2";
        		.AND. SF9->F9_QTDPARC > 0 .AND. SF9->F9_SLDPARC == 0

        		(cAliasSFA)->(DBSKIP())
        		Loop
        	EndIF

   			//-----------------------------------------------------------------------------------------------------------------
			//Condicao utilizada para avaliar o parametro utilizado para nao considerar o documento mesmo que exista na base
			//Será considerado o valor dos campos incluidos no SF9 para as respectivas colunas do SPED Fiscal
   			//-----------------------------------------------------------------------------------------------------------------
			If lF9SKPNF
				lAchouSFT	:=	.F.
				nRecnoSFT	:=	Nil
				nRecnoSD1	:=	Nil
				nRecnoSB1	:=	Nil
				nRecnoSN1	:=	Nil
				nRecnoSN3	:=	Nil

			Else

	   			//-----------------------------------------------------------------------
				//Posicionando o SFT para utilizar algumas informacoes do documento
	   			//-----------------------------------------------------------------------
				lAchouSFT := SPEDSeek("SFT",,xFilial("SFT")+"E"+SF9->(F9_SERNFE+F9_DOCNFE+F9_FORNECE+F9_LOJAFOR+F9_ITEMNFE),nRecnoSFT)
			EndIf

   			//-----------------------------------------------------------------
			//Posicionando a SA2 para utilizar algumas informacoes do documento
   			//-----------------------------------------------------------------
			lAchouSA2 := SPEDSeek( "SA2",, xFilial( "SA2" ) + SF9->( F9_FORNECE + F9_LOJAFOR ), nRecnoSA2 )

   			//-----------------------------------------------------------------------
			//Tratamento para verificar se a despesa acessoria compoe a base
			//de calculo do ICMS, pois o registro exige a informacao separada
   			//-----------------------------------------------------------------------

			If lAchouSFT

	   			//-----------------------------------------------------------------------
				//Posicionando o SD1 para utilizar algumas informacoes do documento
	   			//-----------------------------------------------------------------------
				lAchouSD1 := SPEDSeek("SD1",1,xFilial("SD1")+SFT->(FT_NFISCAL+FT_SERIE+FT_CLIEFOR+FT_LOJA+FT_PRODUTO+FT_ITEM),nRecnoSD1)

				If lFTDESPICM .And. !Empty( SFT->FT_DESPICM )
					cDespAcICM	:=	SFT->FT_DESPICM
				Else
					If lAchouSD1
						If SPEDSeek( "SF4", 1, xFilial( "SF4" ) + SD1->D1_TES )
							cDespAcICM	:=	SF4->F4_DESPICM
						EndIf
					EndIf
				EndIf
			EndIf

   			//-----------------------------------------------------------------------------------------------
			//Verifico existencia da integracao com o ATF, pois utilizo algumas informacoes para gerar os
			//registros posteriores. Neste momento, caso exista esta integracao, tambem tem-se a opcao de
			//alterar o codigo do bem a ser gerado nos registros para utilizar o codigo gerado no ATF.
   			//-----------------------------------------------------------------------------------------------
			If ( lAchouSN3 := !lF9SKPNF .And. SPEDSeek( "SN1", 4, xFilial( "SN1" ) + SF9->F9_CODIGO, nRecnoSN1 ) .And.;
				SPEDSeek( "SN3", 1, xFilial( "SN3" ) + SN1->N1_CBASE + SN1->N1_ITEM, nRecnoSN3 ) )

				If AllTrim( SN3->N3_CCONTAB ) == "" .Or. AllTrim( SN3->N3_CUSTBEM ) == ""
					lAchouSN3 := .F.
				EndIf

	   			//-------------------------------------------------------------------------------------------------
				//Parametro utilizado para alterar o codigo do bem gerado no arquivo para utilizar o codigo do SN1
	   			//-------------------------------------------------------------------------------------------------
				If lMVF9CDATF
					cCodCiap :=	SN1->N1_CBASE + SN1->N1_ITEM + Iif( lConcFil, xFilial( "SN1" ) , "" )
				EndIf
			EndIf

   			//--------------------------------------------------------------------------------------------------------------------
			//Paegando os valores dos campos customizados, se encontrar o documento fiscal, utilizarah dos respectivos documentos
   			//--------------------------------------------------------------------------------------------------------------------
			For nI := 1 To Len( aCmpsSF9 ) Step 2
				If !Empty( aCmpsSF9[nI] )
					aCmpsSF9[ nI + 1 ]	:=	SF9->( & ( aCmpsSF9[ nI ] ) )
				EndIf
			Next nI

   			//-----------------------------------------------------------
			//Se nao encontrar a NF, utilizarah o produto amarrado ao SF9
   			//-----------------------------------------------------------
			If !lAchouSFT

	   			//-----------------------------------------------------------------
				//Posicionando a SA2 para utilizar algumas informacoes do documento
	   			//-----------------------------------------------------------------
				If !Empty( aCmpsSF9[ 8 ] )
					lAchouSB1 := SPEDSeek( "SB1" , , xFilial( "SB1" ) + aCmpsSF9[8] )
				Endif
			Else

	   			//-----------------------------------------------------------------
				//Posicionando a SA2 para utilizar algumas informacoes do documento
	   			//-----------------------------------------------------------------
				lAchouSB1 := SPEDSeek( "SB1", , xFilial( "SB1" ) + SFT->FT_PRODUTO, nRecnoSB1 )



			EndIf

	   		//-------------------------------------------------------------------------
			//Calculo a quantidade de parcelas do sistema conforme Lei Complementar 102
	   		//-------------------------------------------------------------------------
			If !SF9->F9_DTENTNE >= dLei102
				nLimParc  	:= 	60
			Endif

	   		//----------------------------------------------------------------------------------------------------------------
			//Tratamento para que o valor a ser deduzido nas parcelas nao seja considerado pelo parametro MV_LC102. 			³
			//Por exemplo no caso de parcelas reduzidas (Decreto 1980 de 21.12.2007), o usuario ira alterar o cadastro do	³
			//bem e indicara no campo F9_QTDPARC o valor fixo de parcelas a ser consideradas. Por exemplo, se o numero de	³
			//parcelas for 42 ao inves de 48, apenas ira calcular a quantidade fixa menos o saldo, pois se considerar o 	³
			//valor contido no MV_LC102, as informacoes no SPEDFiscal ficarao divergentes.
	   		//----------------------------------------------------------------------------------------------------------------
			If SF9->F9_PARCRED == "1"
				nLimParc :=	SF9->F9_QTDPARC
			Endif

	   		//-------------------------------------------------------------------------
			//Se o ativo possuir este campo preenchido, faco o calculo por ele, pois
			//pode ser que a origem foi outro sistema e houve uma migracao para
			//o Protheus, ficando uma parte no sistema legado e outr no ERP
	   		//-------------------------------------------------------------------------
			If SF9->F9_QTDPARC > 0

				nQtdPSFA :=	SF9->( ( F9_QTDPARC - F9_SLDPARC ) + ( nLimParc - F9_QTDPARC ) )

		   		//---------------------------------------------------------------------------------------------
				//Tratamento para quando não for informado o valor o valor apropriado no sistema legado.
				//Este valor eh utilizado para compor o total de credito CIAP.

				//Ex: Ao incluir o CIAP, o F9_VALICMS eh 300, o QTDPARC eh 30 e o SLDPARC eh 30,
				//     portanto o credito CIAP para as 30 parcelas restante eh +/- 10, porem NAO se tem
				//     o valor total do CIAP, o que se refere as 18 parcelas jah apropriadas no outro sistema.
				//     Este campo a ser informado no parametro MV_F9VLLEG deve representar o restante,
				//     que neste caso eh 180, dando um total de credito de 480 em 48 parcelas.
		   		//---------------------------------------------------------------------------------------------
				If Empty( aCmpsSF9[ 24 ] )
					nVLLEG	:=	SF9->( ( F9_VALICMS / F9_QTDPARC ) * ( nLimParc - F9_QTDPARC ) )
					nVLLEG	:=  If( lRndCiap, Round( nVLLEG, 2 ), NoRound( nVLLEG, 2 ) )

				Else
					nVLLEG	:=	aCmpsSF9[ 24 ]

				EndIf

		   		//--------------------------------------------------------------------------------------------------------
				//Tratamento para considerar a quantidade de parcelas correta quando estah sendo gerado um SPED Fiscal
				//retroativo. Como o campo SLDPARC vai conter somente a quantidade de parcelas restante, preciso somar
				//a quantidade de parcelas que realmente NAO CABEM no periodo, como se ainda estivesse pendente. Ex:
				//F9_QTDPARC=48, F9_SLDPARC=18, nQtdPSFA = 30,  QTDAPRPOST = 4, entao o total seria 34 e nao 30 como
				//informa no nQtdPSFA, pois 4 se referem aos meses posteriores ao processamento do SPED
		   		//--------------------------------------------------------------------------------------------------------
				If lTop

					cAliasAux	:=	"SFA"
					aParFil		:=	{}

					aAdd( aParFil,(cAliasSFA)->FA_CODIGO)
					aAdd( aParFil,DToS(dDataAte))

					If SPEDFFiltro(1,"SFA3",@cAliasAux,aParFil)
						nQtdPSFA -=	(cAliasAux)->QTDAPRPOST
						SPEDFFiltro(2,,cAliasAux)
					EndIf
				Else

			   		//----------------------------------------------------------------
					//Tratamento para ambiente DBF/ADS para retornar a quantidade de
					//parcelas já apropriadas
			   		//----------------------------------------------------------------
					__SFA->(MsSeek(xFilial("SFA") + (cAliasSFA)->FA_CODIGO))
					While !__SFA->(Eof()) .And. __SFA->FA_CODIGO == (cAliasSFA)->FA_CODIGO

						If  __SFA->FA_DATA > dDataAte
							nQtdPSFA	-=	1
						EndIf

						//---------------------------------------------------------------------------------------
						//Condicao implementada para se obter o valor das baixas parciais do periodo para
						//abater no valor total do CIAP (campo 05-VL_IMOB_ICMS_OP do registro G125).
						//Apesar do layout nao prever baixa parcial, estamos implementando o tratamento
						//desta forma para enviar o valor correto de apropriacao e nao acusar erro no
						//validador quando efetuar as multipiocacoes. Nossa consultoria esta providenciando
						//uma consulta formal para termos a posicao final do Fisco para o tratamento correto.
						//---------------------------------------------------------------------------------------
						If __SFA->FA_TIPO=="2	" .And. __SFA->FA_BAIXAPR=="1"
							nVlrBxPSFA	+=	__SFA->FA_VALOR
						EndIf

						__SFA->(dbSkip())
					End
				EndIf
			Else
				//---------------------------------------------------------------------------------------
				//Tratamento para armazenar a quantidade de parcelas de um bem ate a data de final
				//de periodo de processamento do spedfiscal
				//---------------------------------------------------------------------------------------
				If !lTop

					//--------------------------------------------------------------
					//Tratamento para ambiente DBF/ADS para retornar a quantidade de
					//parcelas jah apropriadas
					//--------------------------------------------------------------
					__SFA->( MsSeek( xFilial( "SFA" ) + (cAliasSFA)->FA_CODIGO ) )

					While !__SFA->(Eof()) .And. __SFA->FA_CODIGO==(cAliasSFA)->FA_CODIGO .And. __SFA->FA_DATA<=dDataAte

						nQtdPSFA	+=	1

						//---------------------------------------------------------------------------------------
						//Condicao implementada para se obter o valor das baixas parciais do periodo para
						//abater no valor total do CIAP (campo 05-VL_IMOB_ICMS_OP do registro G125).
						//Apesar do layout nao prever baixa parcial, estamos implementando o tratamento
						//desta forma para enviar o valor correto de apropriacao e nao acusar erro no
						//validador quando efetuar as multipiocacoes. Nossa consultoria esta providenciando
						//uma consulta formal para termos a posicao final do Fisco para o tratamento correto
						//---------------------------------------------------------------------------------------
						If __SFA->FA_TIPO=="2	" .And. __SFA->FA_BAIXAPR=="1"
							nVlrBxPSFA	+=	__SFA->FA_VALOR
						EndIf

						__SFA->(dbSkip())
					End
				Else
					cAliasAux	:=	"SFA"
					aParFil		:=	{}
					aAdd(aParFil,(cAliasSF9)->F9_CODIGO)
					aAdd(aParFil,DToS(dDataAte))

					If SPEDFFiltro(1,"SFA2",@cAliasAux,aParFil)
						nQtdPSFA	:=	(cAliasAux)->QTDAPR
						SPEDFFiltro(2,,cAliasAux)
					EndIf
				EndIf
			EndIf

			//---------------------------------------------------------------------------------------
			//Condicao implementada para se obter o valor das baixas parciais do periodo para
			//abater no valor total do CIAP (campo 05-VL_IMOB_ICMS_OP do registro G125).
			//Apesar do layout nao prever baixa parcial, estamos implementando o tratamento
			//desta forma para enviar o valor correto de apropriacao e nao acusar erro no
			//validador quando efetuar as multipiocacoes. Nossa consultoria esta providenciando
			//uma consulta formal para termos a posicao final do Fisco para o tratamento correto.
			//---------------------------------------------------------------------------------------
			If lTop
				cAliasAux	:=	"SFA"
				aParFil		:=	{}

				aAdd( aParFil,(cAliasSFA)->FA_CODIGO )
				aAdd( aParFil,DToS( dDataAte ) )

				If SPEDFFiltro(1,"SFA4",@cAliasAux,aParFil)
					nVlrBxPSFA	:=	(cAliasAux)->VLRBAIXA
					SPEDFFiltro(2,,cAliasAux)
				EndIf
			EndIf

			//---------------------------------------------------------------------------------------
			//REGISTRO G125 - MOVIMENTACAO DE BEM OU COMPONENTE DO ATIVO IMOBILIZADO                                                                                                         |
			//A gravacao do array aRegG125 deverah ser efetua da no final do processamento, pois esta
			//funcao somente o alimenta
			//---------------------------------------------------------------------------------------
			nX := 1
			While nX <= nTo

			  	IF (!lMVAprComp .And.(SF9 -> (F9_VALICMS==0) .And. SF9 -> (F9_SLDPARC==0) .And. SF9 -> (F9_CODBAIX == 'BFINAL')));
            			.Or. (SF9 -> (F9_VALICMS==0) .And. SF9 -> (F9_SLDPARC==0) .And. SF9 -> (F9_CODBAIX == 'BFINAL'))
					Exit
			  	Endif

				If lMvSomaBem
					If SF9->F9_TIPO == "03"

						cDataComp 	:= Iif(!Empty(SF9->F9_DTEMINE),Mes(SF9->F9_DTEMINE),"")+ AllTrim(Str(Year(SF9->F9_DTEMINE)))
						aAreaSF9	:=	SF9->(GetArea())

						If SF9->(MsSeek(xFilial("SF9")+SF9->F9_CODBAIX))
							If cDataComp == Iif(!Empty(SF9->F9_DTEMINE),Mes(SF9->F9_DTEMINE),"") + AllTrim(Str(Year(SF9->F9_DTEMINE)))
								lSomaBem := .T.
							EndIf
						EndIf
						RestArea(aAreaSF9)
					EndIF
				EndIf


				dDataBem	:=	CToD("  /  /  ")						//03-DT_MOV
				cTpMovBem	:=	"  "  									//04-TIPO_MOV

				//--------------------------------
				//IM - Entrada do bem no periodo
				//--------------------------------
				If SF9->(F9_DTENTNE>=dDataDe .And. F9_DTENTNE<=dDataAte .And. F9_TIPO <> "03" ) ;
				  .And. !lGeraSI	.And. ( (lMVBemEnt .And. (Empty((cAliasSFA)->FA_CODIGO) .Or. !((cAliasSFA)->(FA_TIPO=="2" .And. FA_MOTIVO$"/1/2/3/4/5")) )) ;
				  .OR.( !lMVBemEnt .And. !((cAliasSFA)->(FA_TIPO=="2" .And. FA_MOTIVO$"/1/2/3/4/5")))  )

					dDataBem	:=	SF9->F9_DTENTNE						//03-DT_MOV
					cTpMovBem	:=	"IM"				  				//04-TIPO_MOV

					//Depois que gerou, retorno o status para .F.
					//lGeraSI	:=	.T.		//VERIFICAR TRATAMENTO, POIS PARA O SPED FISCAL, NO MES QUE ENTRA O BEM NAO TEM APROPRIACAO E NO MES DE BAIXA SIM, TRATAMENTO CONTRARIO DO SISTEMA

				//------------------
				//SI - Apropriacao
				//------------------
				ElseIf ( (!lMVBemEnt .And. !lGeraBA .And. (cAliasSFA)->FA_TIPO=="1" .And. SF9->F9_DTENTNE<dDataDe);
				.Or.  (lMVBemEnt .And. !lGeraBA .And. (cAliasSFA)->FA_TIPO=="1") ) .Or. lGeraSI

					dDataBem	:=	dDataDe				 			//03-DT_MOV
					cTpMovBem	:=	"SI"				   				//04-TIPO_MOV

					//----------------------------------------------------------------------
					//Quando se tratar de baixa por vencimento de periodo de apropriacao,
					//devo gerar tambem um BA
					//----------------------------------------------------------------------
					If nQtdPSFA == nLimParc
						lGeraBA	:=	.T.
					EndIf

					//Depois que gerou, retorno o status para .F.
					lGeraSI	:=	.F.

				//---------------------------------------------------
				//PE - Baixa por perecimento/extravio/deterioracao
				//---------------------------------------------------
				ElseIf (cAliasSFA)->(FA_TIPO=="2" .And. FA_MOTIVO=="1")

					dDataBem	:=	(cAliasSFA)->FA_DATA	 			//03-DT_MOV
					cTpMovBem	:=	"PE"				   				//04-TIPO_MOV

					//-----------------------------------------------------------------------
					//Layout determina que para uma baixa por venda/transferencia/perecimento
					//devo tambem gerar um SI
					//-----------------------------------------------------------------------
					lGeraSI	:=	.T.

				//-----------------------------------------
				//AT - Baixa por alienacao ou transferencia
				//-----------------------------------------
				ElseIf (cAliasSFA)->(FA_TIPO=="2" .And. FA_MOTIVO$"/3/")

					dDataBem	:=	(cAliasSFA)->FA_DATA				//03-DT_MOV
					cTpMovBem	:=	"AT"					 			//04-TIPO_MOV

					//-----------------------------------------------------------------------
					//Layout determina que para uma baixa por venda/transferencia/perecimento
					//devo tambem gerar um SI
					//-----------------------------------------------------------------------
					lGeraSI	:=	.T.

				//---------------------------------------------
				//OT - Baixa por outras saidas do imobilizado
				//---------------------------------------------
				ElseIf (cAliasSFA)->(FA_TIPO=="2" .And. FA_MOTIVO$"/2/4/5/")

					dDataBem	:=	(cAliasSFA)->FA_DATA	 	 		//03-DT_MOV
					cTpMovBem	:=	"OT"					 	 		//04-TIPO_MOV

					//-----------------------------------------------------------------------
					//Layout determina que para uma baixa por venda/transferencia/perecimento
					//devo tambem gerar um SI
					//-----------------------------------------------------------------------
					lGeraSI	:=	.T.

				//----------------------------------
				//BA - Baixa por fim de apropriacao
				//----------------------------------
				ElseIf lGeraBA

					dDataBem	:=	(cAliasSFA)->FA_DATA  		 		//03-DT_MOV
					cTpMovBem	:=	"BA"				  	   			//04-TIPO_MOV

					//Depois que gerou, retorno o status para .F.
					lGeraBA	:=	.F.

				EndIf

				//--------------------------------------------
				//IA = Imobilização em Andamento - Componente.
				//--------------------------------------------
				If SPEDValC()

					If SF9->F9_TIPO == "03" .And. SF9->F9_DTENTNE >= dDataDe .And. SF9->F9_DTENTNE <= dDataAte
				   		cTpMovBem	:=	"IA"
					    dDataBem	:=  SF9->F9_DTENTNE

					ElseIf SF9->F9_TIPO == "03" .And. (SF9->F9_DTENTNE < dDataDe .Or. SF9->F9_DTENTNE > dDataAte) .And. (cAliasSFA)->FA_MOTIVO == "2"
						cTpMovBem	:=	"SI"
						dDataBem	:=  dDataDe

					ElseIf SF9->F9_TIPO == "03" .And. (SF9->F9_DTENTNE < dDataDe .Or. SF9->F9_DTENTNE > dDataAte) .And. lMVAprComp
				   		cTpMovBem	:=	"IA"
					    dDataBem	:=  SF9->F9_DTENTNE

					EndIf

					//---------------------------------------------------------------
					//CI = Conclusão de Imobilização em Andamento -  Bem Resultante.
					//---------------------------------------------------------------
					If !lMVAprComp .And. SF9->F9_TIPO == "01" .And. SF9->F9_CODBAIX = "BFINAL" .And. SF9->F9_VALICMS > 0 .And.;
							SF9->F9_DTENTNE >= dDataDe .And. SF9->F9_DTENTNE <= dDataAte

				   		cTpMovBem	:=	"CI"
					    dDataBem	:=  (cAliasSFA)->FA_DATA

					ElseIf !lMVAprComp .And. SF9->F9_TIPO == "01" .And. SF9->F9_CODBAIX = "BFINAL" .And. SF9->F9_VALICMS > 0 .And.;
							(SF9->F9_DTENTNE < dDataDe .Or. SF9->F9_DTENTNE > dDataAte)

						cTpMovBem	:=	"SI"
						dDataBem	:=  dDataDe

	                EndIf

				EndIf

				//----------------------------------------------
				//Tratamento para evitar duplicidade no registro
				//----------------------------------------------
				If aScan( aRegG125,{ |aX| aX[2] == cCodCiap .And. aX[4] == cTpMovBem } ) == 0

					//-------------------------------------------------------------------------------------
					//Na Inclusao do Movimento tipo SI verifica se existe um outro registro do mesmo bem
					//no mesmo periodo do tipo IM, se exister apaga o tipo IM do array.
					//-------------------------------------------------------------------------------------
				    nGera125IM := aScan(aRegG125,{|aX| aX[2]==cCodCiap .And. aX[4]=="IM" .And.;
				    MES(aX[3]) == MES(dDataBem)})

					If cTpMovBem == "SI" .And. nGera125IM > 0
						Loop
					EndIf

					aAdd( aRegG125, {} )
					nPos :=	Len (aRegG125)
					aAdd ( aRegG125[nPos], "G125") 				 			//01-REG
					aAdd ( aRegG125[nPos], cCodCiap)				  		//02-COD_IND_BEM
					aAdd ( aRegG125[nPos], dDataBem) 				 		//03-DT_MOV
					aAdd ( aRegG125[nPos], cTpMovBem)				  		//04-TIPO_MOV
					aAdd ( aRegG125[nPos], 0)	 							//05-VL_IMOB_ICMS_OP
					aAdd ( aRegG125[nPos], 0) 								//06-VL_IMOB_ICMS_ST
					aAdd ( aRegG125[nPos], 0) 								//07-VL_IMOB_ICMS_FRT
					aAdd ( aRegG125[nPos], 0) 								//08-VL_IMOB_ICMS_DIF
					aAdd ( aRegG125[nPos], 0)								//09-NUM_PARC
					aAdd ( aRegG125[nPos], 0) 								//10-VL_PARC_PASS

					//---------------------------------------------------------------
					//Segundo o manual, para os motivos "BA/AT/PE/OT" os campos nao
					//devem ser informados
					//---------------------------------------------------------------
					If aRegG125[ nPos,4 ] $ "SI/IM/IA/MC/CI"
						//---------------------------------------------------------------------------------------
						//Condicao implementada para se obter o valor das baixas parciais do periodo para
						//abater no valor total do CIAP (campo 05-VL_IMOB_ICMS_OP do registro G125).
						//Apesar do layout nao prever baixa parcial, estamos implementando o tratamento
						//desta forma para enviar o valor correto de apropriacao e nao acusar erro no
						//validador quando efetuar as multipiocacoes. Nossa consultoria esta providenciando
						//uma consulta formal para termos a posicao final do Fisco para o tratamento correto.
						//Observacao:
						//A opcao de zerar os valores dos campos 6, 7 e 8 foi conforme orientacao de nossa
						//consultoria ateh obtermos a resposta formal do fisco.
						//---------------------------------------------------------------------------------------
						If nVlrBxPSFA>0
							aRegG125[nPos,5]	:=	SF9->F9_VALICMS-nVlrBxPSFA									//05-VL_IMOB_ICMS_OP

						Else

							//---------------------------------------------------------
							//³ICMS  da operacao propria calculado no documento fiscal
					 		//---------------------------------------------------------
							If lAchouSD1 .Or. lAchouSFT

								If lAchouSD1
									//--------------------------------------------------------------------------------------------------------------------------------------------
									//Somo o VALICM+ICMSCOM para ficar igual como se tivesse pegando do SF9, para depois fazer o tratamento de subtracao abaixo de uma unica forma
									//--------------------------------------------------------------------------------------------------------------------------------------------
									nTotD1FT	:=	SD1->(D1_VALICM+Iif(cDaCiap=="S",D1_ICMSCOM,0))//05-VL_IMOB_ICMS_OP

									//--------------------------------------------------------------------------------------------------------------------------------------------
									//Somo o VALICM+ICMRET para ficar igual como se tivesse pegando do SF9, para depois fazer o tratamento de subtracao abaixo de uma unica forma
									//--------------------------------------------------------------------------------------------------------------------------------------------
									nTotD1FT	+=	Iif(lSTCIAP == "S", SD1->D1_ICMSRET, 0) //05-VL_IMOB_ICMS_OP

								Else

									//--------------------------------------------------------------------------------------------------------------------------------------------
									//Somo o VALICM+ICMSCOM para ficar igual como se tivesse pegando do SF9, para depois fazer o tratamento de subtracao abaixo de uma unica forma
									//--------------------------------------------------------------------------------------------------------------------------------------------
									nTotD1FT	:=	SFT->(FT_VALICM+Iif(cDaCiap=="S",FT_ICMSCOM,0))//05-VL_IMOB_ICMS_OP

									//--------------------------------------------------------------------------------------------------------------------------------------------
									//Somo o VALICM+ICMRET para ficar igual como se tivesse pegando do SF9, para depois fazer o tratamento de subtracao abaixo de uma unica forma
									//--------------------------------------------------------------------------------------------------------------------------------------------
									nTotD1FT	+=	Iif(lSTCIAP == "S", SFT->FT_ICMSRET, 0) //05-VL_IMOB_ICMS_OP

								EndIf

								If lSomaBem .And. SF9->F9_TIPO == "03"

									//--------------------------------------------------------------------------------------------------------------------------------------------
									//Fazer um aScan no aRegG125, pois se ja gerou o bem principal, aglutino a informacao deste componente
									//--------------------------------------------------------------------------------------------------------------------------------------------
									nPosG125 := aScan( aRegG125, {|aX| aX[2]==SF9->F9_CODBAIX})

									If nPosG125 > 0
										aRegG125[nPosG125,5]+= nTotD1FT/nQtdSF9							//05-VL_IMOB_ICMS_OP
									Else

										nPosComp := aScan(aRegG125Co, {|aX| aX[2]==SF9->F9_CODBAIX})
										If nPosComp > 0
											//olhar se ja nao tem informacao gravada
											aRegG125Co[nPosComp,1] += nTotD1FT/nQtdSF9		   			//05-VL_IMOB_ICMS_OP

										Else
											aAdd(aRegG125Co,{})
											nPosComp	:=	Len (aRegG125Co)
											aAdd (aRegG125Co[nPosComp], nTotD1FT/nQtdSF9) 				//01 - Valor do ICMS
											aAdd (aRegG125Co[nPosComp], SF9->F9_CODBAIX) 				//02 - Codigo do bem principal

										EndIf
									EndIf

								EndIf

								If SF9->F9_TIPO == "01"

									If lMVSomaBem
										nPosComp := aScan(aRegG125Co, {|aX| aX[2]== SF9->F9_CODIGO})

										If nPosComp > 0
											aRegG125[nPos,5]	:=	nTotD1FT + aRegG125Co[nPosComp,1]	//05-VL_IMOB_ICMS_OP
											aRegG125Co[nPosComp,1] := 0
										Else
											aRegG125[nPos,5]	:=	nTotD1FT/nQtdSF9					//05-VL_IMOB_ICMS_OP

										EndIf

									Else
										aRegG125[nPos,5]	:=	nTotD1FT/nQtdSF9						//05-VL_IMOB_ICMS_OP
									EndIf
								Else

									//--------------------------------------------------------------------------------------------------------------------------------------------
									//somo o VALICM+ICMSCOM para ficar igual como se tivesse pegando do SF9, para depois fazer o tratamento de subtracao abaixo de uma unica forma
									//--------------------------------------------------------------------------------------------------------------------------------------------
									aRegG125[nPos,5]	:=	nTotD1FT/nQtdSF9 //05-VL_IMOB_ICMS_OP

								EndIf

								//------------------------------------------------------------------------
								//No caso de desmembramento do ativo, o valor da nota eh dividido entre
								//e gerado varios SF9
								//------------------------------------------------------------------------

							Else

								If lSomaBem .And. SF9->F9_TIPO == "03"

									//----------------------------------------------------------------------------------------------------
									//Fazer um aScan no aRegG125, pois se ja gerou o bem principal, aglutino a informacao deste componente
									//----------------------------------------------------------------------------------------------------
									nPosG125 := aScan( aRegG125, {|aX| aX[2] == SF9->F9_CODBAIX } )

									If nPosG125 > 0
										aRegG125[nPosG125,5]	+= SF9->F9_VALICMS+nVLLEG						//05-VL_IMOB_ICMS_OP

									Else
										nPosComp := aScan(aRegG125Co, {|aX| aX[2]==SF9->F9_CODBAIX})

										If nPosComp > 0
											//olhar se ja nao tem informacao gravada
											aRegG125Co[nPosComp,1] += SF9->F9_VALICMS+nVLLEG		   			//05-VL_IMOB_ICMS_OP

										Else
											aAdd(aRegG125Co,{})
											nPosComp	:=	Len (aRegG125Co)
											aAdd (aRegG125Co[nPosComp], SF9->F9_VALICMS+nVLLEG) 				//01 - Valor do ICMS
											aAdd (aRegG125Co[nPosComp], SF9->F9_CODBAIX) 				 		//02 - Codigo do bem principal

										EndIf
									EndIf
								EndIf

								If SF9->F9_TIPO == "01"

									If lMVSomaBem

										nPosComp := aScan(aRegG125Co, {|aX| aX[2]== SF9->F9_CODIGO})

										If nPosComp > 0
											aRegG125[nPos,5]	:=	SF9->F9_VALICMS+nVLLEG + aRegG125Co[nPosComp,1]		//05-VL_IMOB_ICMS_OP
											aRegG125Co[nPosComp,1] := 0

										Else
											aRegG125[nPos,5]	:=	SF9->F9_VALICMS+nVLLEG								//05-VL_IMOB_ICMS_OP

										EndIf

									Else
										aRegG125[nPos,5]	:=	SF9->F9_VALICMS+nVLLEG									//05-VL_IMOB_ICMS_OP

									EndIf
								Else
									aRegG125[nPos,5]	:=	SF9->F9_VALICMS+nVLLEG										//05-VL_IMOB_ICMS_OP

								EndIF
							EndIf

							//----------------------------------------------------------------------------------------------------
							//Tratamento para quando obter o valor atraves do documento fiscal, onde o valor estah cheio
							//----------------------------------------------------------------------------------------------------
							If lAchouSD1 .Or. lAchouSFT

								//--------------------------------------
								//ICMS ST calculado no documento fiscal
								//--------------------------------------
								If lAchouSD1
									nTotD1FT	:=	Iif(lSTCIAP == "S", SD1->D1_ICMSRET, 0)	//06-VL_IMOB_ICMS_ST

								Else
									nTotD1FT	:=	Iif(lSTCIAP == "S", SFT->FT_ICMSRET, 0)	//06-VL_IMOB_ICMS_ST

								EndIf

								If lSomaBem .And. SF9->F9_TIPO == "03"

									If lMvSomaBem

										//----------------------------------------------------------------------------------------------------
										//Fazer um aScan no aRegG125, pois se ja gerou o bem principal, aglutino a informacao deste componente
										//----------------------------------------------------------------------------------------------------
										nPosG125 := aScan( aRegG125, { |aX| aX[2] == SF9->F9_CODBAIX } )

										If nPosG125 > 0
											aRegG125[nPosG125,6] +=	nTotD1FT / nQtdSF9			 		//06-VL_IMOB_ICMS_ST
											aRegG125[nPosG125,5] -= nTotD1FT / nQtdSF9					//05-VL_IMOB_ICMS_OP

										Else
											nPosComp := aScan(aRegG125St, {|aX| aX[2]==SF9->F9_CODBAIX})

											If nPosComp > 0

												//olhar se ja nao tem informacao gravada
												aRegG125St[nPosComp,1] += nTotD1FT/nQtdSF9				//06-VL_IMOB_ICMS_ST
											Else
												aAdd(aRegG125St,{})
												nPosComp	:=	Len (aRegG125St)
												aAdd (aRegG125St[nPosComp], nTotD1FT/nQtdSF9	) 		//01 - Valor do ICMS ST
												aAdd (aRegG125St[nPosComp], SF9->F9_CODBAIX) 			//02 - Codigo do bem principal

											EndIf

										EndIf

									EndIf
								EndIf

								If SF9->F9_TIPO == "01"

									If lMVSomaBem
										nPosComp := aScan(aRegG125St, {|aX| aX[2]== SF9->F9_CODIGO})

										If nPosComp > 0
											aRegG125[nPos,6]	+=	aRegG125St[nPosComp,1]		//06-VL_IMOB_ICMS_ST
											aRegG125[nPos,5]	-=	aRegG125St[nPosComp,1]		//05-VL_IMOB_ICMS_OP
											aRegG125St[nPosComp,1] := 0

										Else
											aRegG125[nPos,6]	:=	nTotD1FT / nQtdSF9			//06-VL_IMOB_ICMS_ST
											aRegG125[nPos,5]	-=	nTotD1FT / nQtdSF9			//05-VL_IMOB_ICMS_OP

										EndIf
									Else
										aRegG125[nPos,6]	:=	nTotD1FT / nQtdSF9				//06-VL_IMOB_ICMS_ST
										aRegG125[nPos,5]	-=	nTotD1FT / nQtdSF9				//05-VL_IMOB_ICMS_OP

									EndIf
								Else
									aRegG125[nPos,6]	:=	nTotD1FT / nQtdSF9					//06-VL_IMOB_ICMS_ST
									aRegG125[nPos,5]	-=	nTotD1FT / nQtdSF9					//05-VL_IMOB_ICMS_OP

								EndIf

							Else

								If lSomaBem .And. SF9->F9_TIPO == "03"

									If lMvSomaBem

										//----------------------------------------------------------------------------------------------------
										//Fazer um aScan no aRegG125, pois se ja gerou o bem principal, aglutino a informacao deste componente
										//----------------------------------------------------------------------------------------------------
										nPosG125 := aScan(aRegG125, {|aX| aX[2]==SF9->F9_CODBAIX})

										If nPosG125 > 0
											aRegG125[nPosG125,6]	+=	aCmpsSF9[20]				 	//06-VL_IMOB_ICMS_ST
											aRegG125[nPosG125,5]	-= aCmpsSF9[20]						//05-VL_IMOB_ICMS_OP
										Else
											nPosComp := aScan(aRegG125St, {|aX| aX[2]==SF9->F9_CODBAIX})

											If nPosComp > 0
												//olhar se ja nao tem informacao gravada
												aRegG125St[nPosComp,1] += aCmpsSF9[20]				 	//06-VL_IMOB_ICMS_ST

											Else
												aAdd(aRegG125St,{})
												nPosComp	:=	Len (aRegG125St)
												aAdd (aRegG125St[nPosComp], aCmpsSF9[20]	) 			//01 - Valor do ICMS ST
												aAdd (aRegG125St[nPosComp], SF9->F9_CODBAIX) 			//02 - Codigo do bem principal

											EndIf
										EndIf

									EndIf
								EndIf

								If SF9->F9_TIPO == "01"

									If lMVSomaBem

										nPosComp := aScan(aRegG125St, {|aX| aX[2]== SF9->F9_CODIGO})
										If nPosComp > 0
											aRegG125[nPos,6]	+=	aRegG125St[nPosComp,1]		//06-VL_IMOB_ICMS_ST
											aRegG125[nPos,5]	-=	aRegG125St[nPosComp,1]		//05-VL_IMOB_ICMS_OP
											aRegG125St[nPosComp,1] := 0

										Else
											aRegG125[nPos,6]	:=	aCmpsSF9[20]				//06-VL_IMOB_ICMS_ST
											aRegG125[nPos,5]	-=	aCmpsSF9[20]				//05-VL_IMOB_ICMS_OP
										EndIf
									Else
										aRegG125[nPos,6]	:=	aCmpsSF9[20]					//06-VL_IMOB_ICMS_ST
										aRegG125[nPos,5]	-=	aCmpsSF9[20]					//05-VL_IMOB_ICMS_OP
									EndIf
								Else
									aRegG125[nPos,6]	:=	aCmpsSF9[20]						//06-VL_IMOB_ICMS_ST
									aRegG125[nPos,5]	-=	aCmpsSF9[20]						//05-VL_IMOB_ICMS_OP
								EndIf

							EndIf

							//----------------------------------------------------------
							//ICMS sobre o frete calculado no documento fiscal
							//
							//Tratamento para verificar se o frete estah compondo a
							//base de calculo do ICMS para poder separar neste
							//registro.
							//----------------------------------------------------------
							If cDespAcICM $ "S/1/5"

								//-------------------------------------------------------------------------------------------
								//Tratamento para quando obter o valor atraves do documento fiscal, onde o valor estah cheio
								//-------------------------------------------------------------------------------------------
								If lAchouSD1 .Or. lAchouSFT

									If lAchouSD1
										nTotD1FT	:=	SD1->(D1_VALFRE*D1_PICM/100)	//07-VL_IMOB_ICMS_FRT
									Else
										nTotD1FT	:=	SFT->(FT_FRETE*FT_ALIQICM/100)	//07-VL_IMOB_ICMS_FRT
									EndIf

									If lSomaBem .And. SF9->F9_TIPO == "03"
										If lMvSomaBem

											//-------------------------------------------------------------------------------------------
											//Fazer um aScan no aRegG125, pois se ja gerou o bem principal, aglutino a informacao deste componente
											//-------------------------------------------------------------------------------------------
											nPosG125 := aScan(aRegG125, {|aX| aX[2]==SF9->F9_CODBAIX})

											If nPosG125 > 0
												aRegG125[nPosG125,7]	+= nTotD1FT/nQtdSF9			 			//07-VL_IMOB_ICMS_FRT
												aRegG125[nPosG125,5]	-= nTotD1FT/nQtdSF9						//05-VL_IMOB_ICMS_OP

											Else
												nPosComp := aScan(aRegG125Fr, {|aX| aX[2]==SF9->F9_CODBAIX})

												If nPosComp > 0
													//olhar se ja nao tem informacao gravada
													aRegG125Fr[nPosComp,1] += nTotD1FT/nQtdSF9				 	//07-VL_IMOB_ICMS_FRT

												Else
													aAdd(aRegG125Fr,{})
													nPosComp	:=	Len (aRegG125Fr)
													aAdd (aRegG125Fr[nPosComp], nTotD1FT/nQtdSF9	) 			//01 - Valor do ICMS ST
													aAdd (aRegG125Fr[nPosComp], SF9->F9_CODBAIX) 				//02 - Codigo do bem principal

												EndIf
											EndIf
										EndIf
									EndIf

									If SF9->F9_TIPO == "01"

										If lMVSomaBem

											nPosComp := aScan(aRegG125Fr, {|aX| aX[2]== SF9->F9_CODIGO})
											If nPosComp > 0
												aRegG125[nPos,7]	+=	aRegG125Fr[nPosComp,1]		//07-VL_IMOB_ICMS_FRT
												aRegG125[nPos,5]	-=	aRegG125Fr[nPosComp,1]		//05-VL_IMOB_ICMS_OP
												aRegG125St[nPosComp,1] := 0

											Else
												aRegG125[nPos,7]	:=	nTotD1FT / nQtdSF9			//07-VL_IMOB_ICMS_FRT
												aRegG125[nPos,5]	-=	nTotD1FT / nQtdSF9			//05-VL_IMOB_ICMS_OP

											EndIf
										Else
											aRegG125[nPos,7]	:=	nTotD1FT / nQtdSF9				//07-VL_IMOB_ICMS_FRT
											aRegG125[nPos,5]	-=	nTotD1FT / nQtdSF9				//05-VL_IMOB_ICMS_OP

										EndIf
									Else
										aRegG125[nPos,7]	:=	nTotD1FT / nQtdSF9					//07-VL_IMOB_ICMS_FRT
										aRegG125[nPos,5]	-=	nTotD1FT / nQtdSF9					//05-VL_IMOB_ICMS_OP

									EndIf

								Else

									If lSomaBem .And. SF9->F9_TIPO == "03"

										If lMvSomaBem

											//-------------------------------------------------------------------------------------------
											//Fazer um aScan no aRegG125, pois se ja gerou o bem principal, aglutino a informacao deste componente
											//-------------------------------------------------------------------------------------------
											nPosG125 := aScan(aRegG125, {|aX| aX[2]==SF9->F9_CODBAIX})

											If nPosG125 > 0

												aRegG125[nPosG125,7]	+=	aCmpsSF9[18]				 		//07-VL_IMOB_ICMS_FRT

												//-------------------------------------------------------------------------------------------
												//Retiro o valor do frete do ICMS proprio do campo 05. Pois quando lancado manualmente   ³
												//ou por nota o valor jah estah embutido no F9_VALICMS
												//-------------------------------------------------------------------------------------------
												aRegG125[nPosG125,5]	-= aCmpsSF9[18]							//07-VL_IMOB_ICMS_FRT
											Else
												nPosComp := aScan(aRegG125Fr, {|aX| aX[2]==SF9->F9_CODBAIX})
												If nPosComp > 0
													//olhar se ja nao tem informacao gravada
													aRegG125Fr[nPosComp,1] += aCmpsSF9[18]				 		//07-VL_IMOB_ICMS_FRT
												Else
													aAdd(aRegG125Fr,{})
													nPosComp	:=	Len (aRegG125Fr)
													aAdd (aRegG125Fr[nPosComp], aCmpsSF9[18]	) 				//01 - Valor do Frete
													aAdd (aRegG125Fr[nPosComp], SF9->F9_CODBAIX) 				//02 - Codigo do bem principal
												EndIf
											EndIf

										EndIf
									EndIf

									If SF9->F9_TIPO == "01"
										If lMVSomaBem
											nPosComp := aScan(aRegG125Fr, {|aX| aX[2]== SF9->F9_CODIGO})
											If nPosComp > 0
												aRegG125[nPos,7]	+=	aRegG125Fr[nPosComp,1]		//06-VL_IMOB_ICMS_ST
												aRegG125[nPos,5]	-=	aRegG125Fr[nPosComp,1]		//05-VL_IMOB_ICMS_OP
												aRegG125Fr[nPosComp,1] := 0
											Else
												aRegG125[nPos,7]	:=	aCmpsSF9[18]				//06-VL_IMOB_ICMS_ST
												aRegG125[nPos,5]	-=	aCmpsSF9[18]				//05-VL_IMOB_ICMS_OP
											EndIf
										Else
											aRegG125[nPos,7]	:=	aCmpsSF9[18]					//06-VL_IMOB_ICMS_ST
											aRegG125[nPos,5]	-=	aCmpsSF9[18]					//05-VL_IMOB_ICMS_OP
										EndIf
									Else
										aRegG125[nPos,7]	:=	aCmpsSF9[18]						//06-VL_IMOB_ICMS_ST
										aRegG125[nPos,5]	-=	aCmpsSF9[18]						//05-VL_IMOB_ICMS_OP
									EndIf
								EndIF
							EndIf

							//-------------------------------------------------------------------------------------------
							//Tratamento para quando obter o valor atraves do documento fiscal, onde o valor estah cheio
							//-------------------------------------------------------------------------------------------
							If lAchouSD1 .Or. lAchouSFT

								//-------------------------------------------------
								//ICMS Complementar calculado no documento fiscal
								//-------------------------------------------------
								If lAchouSD1
									nTotD1FT	:=	Iif(cDaCiap=="S",SD1->D1_ICMSCOM,0)//08-VL_IMOB_ICMS_DIF

								Else
									nTotD1FT	:=	Iif(cDaCiap=="S",SFT->FT_ICMSCOM,0)//08-VL_IMOB_ICMS_DIF
								EndIf

								If lSomaBem .And. SF9->F9_TIPO == "03"

									If lMvSomaBem

										//----------------------------------------------------------------------------------------------------
										//Fazer um aScan no aRegG125, pois se ja gerou o bem principal, aglutino a informacao deste componente
										//----------------------------------------------------------------------------------------------------
										nPosG125 := aScan(aRegG125, {|aX| aX[2]==SF9->F9_CODBAIX})
										If nPosG125 > 0
											aRegG125[nPosG125,8]	+=	nTotD1FT/nQtdSF9				 	//08-VL_IMOB_ICMS_DIF
											aRegG125[nPosG125,5]	-= nTotD1FT/nQtdSF9						//05-VL_IMOB_ICMS_OP

										Else
											nPosComp := aScan(aRegG125Cm, {|aX| aX[2]==SF9->F9_CODBAIX})
											If nPosComp > 0
												//olhar se ja nao tem informacao gravada
												aRegG125Cm[nPosComp,1] += nTotD1FT/nQtdSF9		 			//08-VL_IMOB_ICMS_DIF

											Else
												aAdd(aRegG125Cm,{})
												nPosComp	:=	Len (aRegG125Cm)
												aAdd (aRegG125Cm[nPosComp], nTotD1FT/nQtdSF9	)			//01 - Valor do ICMS ST
												aAdd (aRegG125Cm[nPosComp], SF9->F9_CODBAIX) 				//02 - Codigo do bem principal

											EndIf
										EndIf
									EndIf
								EndIf

								If SF9->F9_TIPO == "01"

									If lMVSomaBem
										nPosComp := aScan(aRegG125Cm, {|aX| aX[2]== SF9->F9_CODIGO})
										If nPosComp > 0
											aRegG125[nPos,8]	+=	aRegG125Cm[nPosComp,1]		//08-VL_IMOB_ICMS_DIF
											aRegG125[nPos,5]	-=	aRegG125Cm[nPosComp,1]		//05-VL_IMOB_ICMS_OP
											aRegG125St[nPosComp,1] := 0
										Else
											aRegG125[nPos,8]	:=	nTotD1FT/nQtdSF9			//08-VL_IMOB_ICMS_DIF
											aRegG125[nPos,5]	-=	nTotD1FT/nQtdSF9			//05-VL_IMOB_ICMS_OP
										EndIf
									Else
										aRegG125[nPos,8]	:=	nTotD1FT/nQtdSF9				//08-VL_IMOB_ICMS_DIF
										aRegG125[nPos,5]	-=	nTotD1FT/nQtdSF9				//05-VL_IMOB_ICMS_OP
									EndIf
								Else
									aRegG125[nPos,8]	:=	nTotD1FT/nQtdSF9					//08-VL_IMOB_ICMS_DIF
									aRegG125[nPos,5]	-=	nTotD1FT/nQtdSF9					//05-VL_IMOB_ICMS_OP
								EndIf

							Else

								If lSomaBem .And. SF9->F9_TIPO == "03"

									If lMvSomaBem

										//----------------------------------------------------------------------------------------------------
										//Fazer um aScan no aRegG125, pois se ja gerou o bem principal, aglutino a informacao deste componente
										//----------------------------------------------------------------------------------------------------
										nPosG125 := aScan(aRegG125, {|aX| aX[2]==SF9->F9_CODBAIX})

										If nPosG125 > 0
											aRegG125[nPosG125,8]	+=	Iif(cDaCiap=="S",aCmpsSF9[22],0)	//08-VL_IMOB_ICMS_DIF
											aRegG125[nPosG125,5]	-= Iif(cDaCiap=="S",aCmpsSF9[22],0)		//08-VL_IMOB_ICMS_DIF
										Else
											nPosComp := aScan(aRegG125Cm, {|aX| aX[2]==SF9->F9_CODBAIX})
											If nPosComp > 0

												//olhar se ja nao tem informacao gravada
												aRegG125Cm[nPosComp,1] += Iif(cDaCiap=="S",aCmpsSF9[22],0)	//08-VL_IMOB_ICMS_DIF
											Else
												aAdd(aRegG125Cm,{})
												nPosComp	:=	Len (aRegG125Cm)
												aAdd (aRegG125Cm[nPosComp], Iif(cDaCiap=="S",aCmpsSF9[22],0)) //01 - Valor do ICMS Complementar
												aAdd (aRegG125Cm[nPosComp], SF9->F9_CODBAIX) 				 //02 - Codigo do bem principal

											EndIf
										EndIf
									EndIf
								EndIf

								If SF9->F9_TIPO == "01"
									If lMVSomaBem
										nPosComp := aScan(aRegG125Cm, {|aX| aX[2]== SF9->F9_CODIGO})
										If nPosComp > 0
											aRegG125[nPos,8]	+=	aRegG125Cm[nPosComp,1]		//08-VL_IMOB_ICMS_DIF
											aRegG125[nPos,5]	-=	aRegG125Cm[nPosComp,1]		//05-VL_IMOB_ICMS_OP
											aRegG125Cm[nPosComp,1] := 0

										Else
											aRegG125[nPos,8]	:=	Iif(cDaCiap=="S",aCmpsSF9[22],0)									//08-VL_IMOB_ICMS_DIF
											aRegG125[nPos,5]	-=	Iif(cDaCiap=="S",aCmpsSF9[22],0)									//05-VL_IMOB_ICMS_OP
										EndIf

									Else
										aRegG125[nPos,8]	:=	Iif(cDaCiap=="S",aCmpsSF9[22],0)									//08-VL_IMOB_ICMS_DIF
										aRegG125[nPos,5]	-=	Iif(cDaCiap=="S",aCmpsSF9[22],0)									//05-VL_IMOB_ICMS_OP

									EndIf
								Else
									aRegG125[nPos,8]	:=	Iif(cDaCiap=="S",aCmpsSF9[22],0)									//08-VL_IMOB_ICMS_DIF
									aRegG125[nPos,5]	-=	Iif(cDaCiap=="S",aCmpsSF9[22],0)									//05-VL_IMOB_ICMS_OP

								EndIf
							EndIF
	               		EndIf

	                	lSomaBem := .F.

						//----------------------------------------------------------------------------------------------------
						//Quando manda gerar um novo SI mudando o nTo para dois, nao devo pegar os valores, devo enviar ZERADO
						//Tratamento atende o item4 dos requisitos do registro G125 do SPED Fiscal, Campos 05, 06, 07 e 08
						//----------------------------------------------------------------------------------------------------
						If nTo==1
							//----------------------------------------------------------------------------------------------------
							//Quando entrada ou consumo de componente de um bem que está sendo construído no estabelecimento do
							//contribuinte deverá ser informado com o tipo de movimentação "IA", no período de ocorrência do fato.
							//Os campos NUM_PARC e VL_PARC_PASS não podem ser informados (*Guia Prático EFD - Versão 2.0.9)
							//----------------------------------------------------------------------------------------------------
							If !lMVAprComp .And. cTpMovBem == "IA"
								//SE O PARAMETRO ESTIVER FALSO NÃO GEREI SFA E CONSEQUENTEMENTE DEVO GERAR OS VALORES IGUAIS A 0
								//APENAS SE FOR COMPONENTE
								If SF9->F9_TIPO == "03"
									nQtdPSFA  := 0
									nLimParc  := 0
								EndIf
							EndIf

							aRegG125[nPos,9]	:= AllTrim(Str(nQtdPSFA))					//09-NUM_PARC
							//-------------------------------------------------------------------------
							//Valor passivel de apropriacao eh o valor bruto dividido pela quantidade
							//de parcelas prevista em legislação, sem a aplicacao do percentual correto
							//-------------------------------------------------------------------------
							aRegG125[nPos,10] := aRegG125[nPos,5]+aRegG125[nPos,6]+aRegG125[nPos,7]+aRegG125[nPos,8]
							aRegG125[nPos,10] := IIf(nQtdPSFA > 0,aRegG125[nPos,10]/nLimParc,0)		//10-VL_PARC_PASS
							aRegG125[nPos,10] := If(lRndCiap,Round(aRegG125[nPos,10],2),NoRound(aRegG125[nPos,10],2))
						EndIf

						//-------------------------------------------------------------------------
						//Somatorio de todos os SIs do periodo para compor o campo 04 do registro
						//G110 - SALDO_IN_ICMS
						//-------------------------------------------------------------------------
						If aRegG125[nPos,4]=="SI"
							nC04G110	+=	aRegG125[nPos,5]+aRegG125[nPos,6]+aRegG125[nPos,7]+aRegG125[nPos,8]
						EndIf

						//-------------------------------------------------------------------------
						//Somatorio de todas as parcelas de ICMS passivel de apropriacao para
						//compor o campo 05 do registro G110 - SOM_PARC
						//-------------------------------------------------------------------------
						nC05G110	+=	aRegG125[nPos,10]
					EndIf

					//---------------------------------------------------------------
					//Tratamento para gerar mais de um registro G125 para o mesmo SFA
					//---------------------------------------------------------------
					If lGeraBA .Or. lGeraSI
						nTo	:=	2
					EndIf

					if lExtratTAF
						aadd( aRegT050AA, aRegG125[nPos] )
					endif

					//----------------------------------------------------------------------------------
					//Funcao que monta e retorna as informacoes dos documentos fiscais para geracao dos
					//registros G130 e G140
					//----------------------------------------------------------------------------------
				   aInfRegs := SPDG130140(lTop,cAliasSFA,aRegG125[nPos,4],lAchouSFT,lAchouSA2,aCmpsSF9,@aReg0150,cAlias,aWizard,lAchouSB1,@aReg0200,@aReg0190,@aReg0220,nRecnoSFT,lF9SKPNF,aExistBloc,lExtratTAF,lConcFil)
                 If Len(aInfRegs[1])>0

                        If aInfRegs[1][10]=="BFINAL"
                            aInfRegCom :=   SpedCompAtf(SubStr(aInfRegs[1][9],1,TamSX3("F9_CODIGO")[01]),dDataDe,dDataAte)  //mauro
                            If Len(aInfRegCom[1]) > 0
                                aInfRegs := aClone(aInfRegCom)
                            Endif
                        Endif
                        For nA:=1 to Len(aInfRegs)
                            If lSpedG126 .Or. ProdG126
								IF lSpedG126
									aRegG126 	:= 	Execblock("SPEDG126", .F., .F.,{nPos,cAliasSFA,aRegG126,aRegG125[nPos,2]})
								ElseIF ProdG126
									/*REGISTRO G126: OUTROS CRÉDITOS CIAP*/
									aRegG126 := RegG126(nPos,aRegG126,aRegG125[nPos,2],dDataDe,dDataAte,nX3codBem,cPerG126)
								Endif

								If Len(aRegG126)>0
									For nX126	:= 1 to Len(aRegG126)
										IF aRegG126[nX126,1] == nPos //Somente considera registro filgo G126 do mesmo pai G125.
											nC10G110 	+= 	aRegG126[nX126,10]
										EndIF
									Next nX126
								EndIF
							EndIf
                            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                            //|REGISTRO G130 - IDENTIFICACAO DO DOCUMENTO                                              |
                            //|A gravacao do array aRegG130 deverah ser efetua da no final do processamento, pois esta |
                            //|  funcao somente o alimenta                                                             |
                            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                            nPosG130    :=  RegG130(nPos,@aRegG130,aInfRegs[nA],lExtratTAF, aRegT050AC )
                            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                            //|REGISTRO G140 - IDENTIFICACAO DO ITEM DO DOCUMENTO                                      |
                            //|A gravacao do array aRegG140 deverah ser efetua da no final do processamento, pois esta |
                            //|  funcao somente o alimenta                                                             |
                            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                            RegG140(nPosG130,@aRegG140,aInfRegs[nA],lExtratTAF, aRegT050AD)
                            IF !lExtratTAF
                                If aScan(aReg0200, {|aX| aX[2] == aInfRegs[nA][9]}) == 0
                                    lAchouSB1 := SPEDSeek("SB1",,xFilial("SB1")+aInfRegs[nA][9])
                                    SFRG0200(cAlias, @aReg0200, @aReg0190, dDataDe, dDataAte, ,aInfRegs[nA][9], @aReg0220,,,,,,,,,,,,,,,,,,,aWizard)
                                EndIf
                            EndIf

                        Next
                    EndIf
					//----------------------------------------------------------------------------------------
					//Funcao que retorna informacoes da classificacao do ativo, utilizado para montar os
					//registros 0300, 0305, 0500 e 0600
					//----------------------------------------------------------------------------------------
					aClasCIAP := SpedBGCIAP(lAchouSB1,lAchouSN3,lAchouSD1,cMVF9CTBCC,aCmpsSF9,lCtbInUse,cMVF9GENCC,cMVF9GENCT,lF9SKPNF,lConcFil)
					If Len( aClasCIAP ) > 0
						//---------------------------------------------------------------------
						//REGISTRO 0300 - CADASTRO DE BENS OU COMPONENTES DO ATIVO IMOBILIZADO
						//REGISTRO 0305 - INFORMACAO SOBRE A UTILIZACAO DO BEM
						//Funcao independente, gera a estrutura e efetua a gravacao no TRB
						//---------------------------------------------------------------------
						R03000305(cAlias,aClasCIAP,nLimParc,cCodCiap,aCmpsSF9,@aReg0300,@aReg0305,cAliasSFA,lExtratTaf,aRegT008)
						//----------------------------------------------------------------
						//REGISTRO 0500 - PLANO DE CONTAS CONTABEIS                                                                                                                                       |
						//Funcao independente, gera a estrutura e efetua a gravacao no TRB
						//----------------------------------------------------------------
						Reg0500(cAlias,aClasCIAP,lCtbInUse,@aReg0500,lExtratTAF)
						//----------------------------------------------------------------
						//REGISTRO 0600 - CENTRO DE CUSTO
						//Funcao independente, gera a estrutura e efetua a gravacao no TRB
						//----------------------------------------------------------------
						Reg0600(cAlias,aClasCIAP,lCtbInUse,@aReg0600,lExtratTAF)

					EndIf
				EndIf

				nX++
			End
			//----------------------------------------------------------------
			//No caso de o objeto oProcess existir, significa que a nova barra
			//de processamento (CLASSE Fiscal) estah em uso pela rotina,
			//portanto deve ser efetuado os controles para demonstrar o
			//resultado do processamento.
			//Tratamento para o cancelamento de execucao da rotina
			//----------------------------------------------------------------
			If Type( "oProcess" ) == "O"
				//-----------------------------------
				//Controle do cancelamento da rotina
				//-----------------------------------
				If oProcess:Cancel()
					Exit
				EndIf

			Else
				//-----------------------------------
				//Controle do cancelamento da rotina
				//-----------------------------------
				If Interrupcao( @lEnd )
					Exit
				EndIf
			EndIf
			(cAliasSF9)->( dbSkip() )
		End

		//--------------------------------
		//³Fecho query ou indregua criada³
		//--------------------------------
		SPEDFFiltro(2,,cAliasSFA)
		SPEDFFiltro(2,,cAliasSF9)
		//------------------------
		//³Fecho copia criada³
		//------------------------
		If !lTop
			__SFA->(DbCloseArea ())
		EndIf
	EndIf

	SM0->(dbSkip())
End
//-----------------------
//Restauro a area do SM0
//-----------------------
RestArea(aAreaSM0)

cFilAnt := FWGETCODFILIAL

//--------------------------------------------------------------------
//No caso de o objeto oProcess existir, significa que a nova barra
//de processamento (CLASSE Fiscal) estah em uso pela rotina,
//portanto deve ser efetuado os controles para demonstrar o
//resultado do processamento.

//Tratamento para o cancelamento de execucao da rotina
//--------------------------------------------------------------------
If Type( "oProcess" ) == "O" .and. !lExtratTAF
	nSv1Progress	:=	oProcess:Ret1Progress()
	nSv2Progress	:=	oProcess:Ret2Progress()
	//-------------------------------------
	//Controle do cancelamento da rotina
	//-------------------------------------
	If oProcess:Cancel()
		Return
	EndIf
Else
	//-------------------------------------
	//Controle do cancelamento da rotina
	//-------------------------------------
	If Interrupcao(@lEnd)
		Return
	EndIf

EndIf

//-------------------------------------------------------------------------------------------------------------------
//Se NAO houve movimento de ativo no periodo ou for processamento do extrator, nao preciso nem passar pelos registros
//-------------------------------------------------------------------------------------------------------------------
If Len( aRegG125 ) > 0
	if !lExtratTAF
		//----------------------------------------------------------------------------------
		//GRAVACAO DO REGISTRO 0300 - CADASTRO DE BENS OU COMPONENTES DO ATIVO IMOBILIZADO
		//REGISTRO 0305 - INFORMACAO SOBRE A UTILIZACAO DO BEM
		//----------------------------------------------------------------------------------
		GrRegDep(cAlias,aReg0300,aReg0305,,,,,,"0300/0305")
	else
		aRegT008    := aReg0300
		aRegT008Aux := aReg0305
	endif
	//----------------------------------------------------------------------------------
	//REGISTRO G110 - ICMS ATIVO PERMANENTE - CIAP
	//
	//Funcao independente, gera a estrutura e efetua a gravacao no TRB
	//----------------------------------------------------------------------------------
	RegG110( cAlias, nFator, nTotTrib, nTotSai, nC04G110, nC05G110, nC10G110, aWizard, lRndCiap, lExtratTAF, @aRegT050 )
	//------------------------------------------------------------------------------------
	//GRAVACAO DO REGISTRO G125 - MOVIMENTACAO DE BEM OU COMPONENTE DO ATIVO IMOBILIZADO
	//GRAVACAO DO REGISTRO G130 - IDENTIFICACAO DO DOCUMENTO
	//GRAVACAO DO REGISTRO G140 - IDENTIFICACAO DO ITEM DO DOCUMENTO
	//------------------------------------------------------------------------------------
	If lSpedG126 .Or. ProdG126
		If Len(aRegG126) > 0
			if  !lExtratTAF
				SPEDRegs(cAlias,{aRegG125,aRegG130,aRegG140,{aRegG126,1}},"G125/G126/G130/G140")
			else
				aRegT050AB := aRegG126
			endif
       Else
			SPEDRegs(cAlias,{aRegG125,aRegG130,aRegG140},"G125/G130/G140")
       EndIf
    Else
    	if !lExtratTAF
	    	SPEDRegs(cAlias,{aRegG125,aRegG130,aRegG140},"G125/G130/G140")
	    endif

    EndIF
EndIf

//-------------------------------------------------------------------
//No caso de o objeto oProcess existir, significa que a nova barra
//de processamento (CLASSE Fiscal) estah em uso pela rotina,
//portanto deve ser efetuado os controles para demonstrar o
//resultado do processamento.
//Tratamento para retornar a posicao da barra salva anteriormente
//-------------------------------------------------------------------
If Type( "oProcess" ) == "O"

	oProcess:Set1Progress(nCtdFil,nSv1Progress)
	oProcess:Set2Progress(nCountTot,nSv2Progress)
EndIf

Return

//--------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} RegG110

G110 - ICMS ATIVO PERMANENTE - CIAP
Funcao utilizada para montar a estrutura do registro G110 do CIAP

@Param:
cAlias     -> Alias do TRB
nFator     -> Coeficiente gravado no SFA
nTotTrib   -> Total das saidas tributadas gravadas no SFA
nTotSai    -> Tota de todas as saidas gravadas no SFA
nC04G110   -> Somatorio dos valores de apropriacao calculado no G125
nC05G110   -> Somatorio dos valores passiveis de apropriacao calculado no G125                                                 ³±±
nC10G110   -> Somatorio dos valores passiveis de apropriacao calculado no G126                                                 ³±±
aWizard    -> Informacoes do assistente da rotina
lRndCiap   -> Conteudo do parametro MV_RNDCIAP que determina o arredondamento conforme
		      configurado na rotina de estorno Aqui precisar ter o mesmo tratamento para o
		      valor ficar igual
lExtratTAF -> Indica se o processamento é pelo extrator do TAF
aRegT050   -> Array de retorno para o extrator fiscal

@Author Gustavo G. Rueda
@since  17/03/2011
@version 1.0

@Return nPos

/*/
//--------------------------------------------------------------------------------------------------------------
Static Function RegG110( cAlias,nFator,nTotTrib,nTotSai,nC04G110,nC05G110,nC10G110,aWizard,lRndCiap,;
                        lExtratTAF,aRegT050 )

Local	aCoef  	:=	{}
Local	dDataDe	:=	''
Local	dDataAte	:=	''
Local	aRegG110	:=	{}
Local	cFator		:=	""

if !lExtratTAF
	dDataDe		:=	SToD(aWizard[1,1])
	dDataAte	:=	SToD(aWizard[1,2])
else
	dDataDe		:=	aWizard[1,3]
	dDataAte	:=	aWizard[1,4]
endif

//------------------------------------------------------
//Tem que processar a apropriacao nos seguintes casos:
//1)Se nao tiver o fator;
//2)ou se os valores de saidas estiverem zerados porem
//o Fator tiver preenchido.
//------------------------------------------------------
If nFator==0 .Or. (nTotTrib==0 .And. nTotSai==0 .And. nFator>0)

	//---------------------------------------------------------------------------------
	//busca total de saídas, saídas tributadas e coeficiente. CoefApr esta no MATA906
	//caso nao tenha os valores do mesmo gravado na tabela
	//---------------------------------------------------------------------------------
	RptStatus ( {|| aCoef := CoefApr (dDataDe, dDataAte)}, "Aguarde...", "Obtendo o coeficiente de apropriação...")

	If Len(aCoef)>0
		nTotTrib	:=	aCoef[1][2]
		nTotSai		:=	aCoef[1][3]
		nFator		:=	aCoef[1][4]
	EndIf
EndIf
cFator		:=	AllTrim(Transform(nFator,"@E 999999.99999999"))

//---------------------------------------------------------------
//Arredondamento conforme configurado na rotina de estorno
//Aqui precisa ter o mesmo tratamento para o valor ficar  igual.

//Arredondo a soma das parcelas passíveis de apropriacao(nC05G110)
//seguindo o mesmo critério do valor a ser apropriado(nVlIcmApro)
//para que nao ocorram divergencias entre os dois campos.
//---------------------------------------------------------------

nC05G110   := If(lRndCiap,Round(nC05G110,2),NoRound(nC05G110,2))
nVlIcmApro :=	If(lRndCiap,Round(nFator*nC05G110,2),NoRound(nFator*nC05G110,2))

//---------------------------------------------------------------------------------------------------------------------------
//Encontramos a mesma questão mencionada pelo cliente em outros blogs juntamente com a resposta do SEFAZ MG:
//"FICHA CIAP: PERÍODO DE APURAÇÃO SEM SAÍDAS/PRESTAÇÕES - CASO PRÁTICO - REGISTRO G110 - 16/02/2011
//
//Dúvida do contribuinte:
//"Temos um estabelecimento que em determinado mês teve o total de saídas igual zero. Porém, tem fichas do CIAP e
//calculou o fator igual a zero. O PVA emite uma crítica informando que o valor total de saídas informado - G110 - tem
//que ser maior do que zero. Assim, solicitamos informar que se eventualmente o total de saídas no mês for zero, não
//devemos escriturar o CIAP, e no mês seguinte em que o total de saídas for maior que zero voltamos a escriturar?"
//
//Resposta:
//Trata-se de período de apuração sem saídas/prestações, cuja hipótese pode suscitar uma das interpretações
//  abaixo por parte de cada UF:
//a) não se apropria a parcela de ICMS do período, perdendo o direito sobre ela;
//b) a apropriação da parcela fica suspensa, voltando a apropriar quando ocorrer saídas/prestações (não se
//perde o direito, apenas o difere);
//c) considera-se o índice de participação igual a 1, apropriando 100% da parcela.
//
//Atualmente, o entendimento do RN é pela opção referida na alínea "a".
//
//Entretanto, o PVA deve estar preparado para todos os entendimentos.
//
//Considerando que o PVA exige que o valor total das saídas (campo 7 do Registro G110) seja maior que
//  zero, deve-se proceder da seguinte forma:
//1) caso o entendimento da UF seja o das alíneas "a" ou "b", o contribuinte deverá informar o Bloco G
//  apenas com os registros de abertura, G001, sem informação; e de encerramento,G990;
//2) se o entendimento da UF for o da alínea "c", o contribuinte deverá preencher os campos 6 e 7 do
//  Registro G110 com o valor 1.
//
//Fonte: SEFAZ/MG, produzido por Luiz Augusto Dutra da Silva, Representante do RN no GT48 -
//  SPED Fiscal, SET/RN."
//
//fontes:
//http://www.robertodiasduarte.com.br/sped-efd-icmsipi-caso-pratico-registro-g110-periodo-de-apuracao-sem-saidasprestacoes/
//http://www.joseadriano.com.br/profiles/blogs/sped-efd-caso-pratico
//http://www.apicecontabilidade.com.br/contabilidade/noticias.php?id=175
//---------------------------------------------------------------------------------------------------------------------------
nTotTrib	:=	Iif(nTotTrib==0 .And. nTotSai==0,1,nTotTrib)
nTotSai		:=	Iif(nTotSai==0,1,nTotSai)
cFator		:=	IIf (nFator > 0,cFator,AllTrim(Transform((nTotTrib/nTotSai),"@E 999999.99999999")))


aAdd(aRegG110, {})
nPos	:=	Len (aRegG110)
aAdd (aRegG110[nPos], "G110")												//01-REG
aAdd (aRegG110[nPos], dDataDe)												//02-DT_INI
aAdd (aRegG110[nPos], dDataAte)												//03-DT_FIN
aAdd (aRegG110[nPos], nC04G110)												//04-SALDO_IN_ICMS
aAdd (aRegG110[nPos], nC05G110) 											//05-SOM_PARC
aAdd (aRegG110[nPos], nTotTrib)  											//06-VL_TRIB_EXO
aAdd (aRegG110[nPos], nTotSai)		   										//07-VL_TOTAL
aAdd (aRegG110[nPos], cFator)												//08-IND_PER_SAI
aAdd (aRegG110[nPos], nVlIcmApro) 											//09-ICMS_APROP
aAdd (aRegG110[nPos], nC10G110) 											//10-SOM_ICMS_OC

//---------------------------
//Gravacao do registro G110
//---------------------------
if !lExtratTAF
	GrvRegTrS(cAlias,,aRegG110)
else
	aRegT050 := aRegG110
endif

Return


/*Funcao  RegG126 Autor ³Rafael Santos Oliveira  Data 15.07.2016
REGISTRO G126: OUTROS CRÉDITOS CIAP
*/
Static Function RegG126(nPosG125,aRegG126,cCodBem,dDataDe,dDataAte,nX3codBem,cPerG126)
Local nPos		:=	0
Local cBem		:= SubStr(cCodBem,1,nX3codBem)

DbSelectArea("F0W")
F0W->(DbSetOrder(2))
F0W->(DbGoTop ())

If F0W->(MsSeek(xFilial("F0W")+cBem+cPerG126))
	Do While !F0W->(Eof ()) .And. F0W->F0W_CODIGO == cBem .And. F0W_PERIOD == cPerG126
		nPos := aScan(aRegG126,{|aX|aX[1]==nPosG125 .And. aX[3]==F0W->F0W_DTINI .And. aX[4]==F0W->F0W_DTFIM})
		If nPos == 0
			aAdd(aRegG126, {})
			nPos	:=	Len (aRegG126)
			aAdd (aRegG126[nPos], nPosG125)			//00 - Relacionamento com o registro PAI
			aAdd (aRegG126[nPos], "G126") 			//01-REG
			aAdd (aRegG126[nPos], F0W->F0W_DTINI)	//02-DT_INI
			aAdd (aRegG126[nPos], F0W->F0W_DTFIM)	//03-DT_FIM
			aAdd (aRegG126[nPos], AllTrim(Str(F0W->F0W_PARCEL)))	//04-NUM_PARC
			aAdd (aRegG126[nPos], F0W->F0W_VLPARC)	//05-VL_PARC_PASS
			aAdd (aRegG126[nPos], F0W->F0W_VLTRIB)	//06-VL_TRIB_OC
			aAdd (aRegG126[nPos], F0W->F0W_VTOTAL)	//07-VL_TOTAL
			aAdd (aRegG126[nPos], F0W->F0W_INDPAR)	//08-IND_PER_SAI
			aAdd (aRegG126[nPos], F0W->F0W_VLRAPR)	//09-VL_PARC_APROP
		EndIf

		F0W->(DbSkip ())

	EndDo
Endif

dbSelectArea("F0W")
F0W->(dbCloseArea())

Return aRegG126

//--------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} RegG130

Funcao utilizada para montar a estrutura do registro G130 do CIAP
Esta funcao estah preparada tanto para utilizar informacoes do
documento de entrada caso exista (prioridade 1), como para
utilizar as informacoes atraves de parametros caso nao exista o
documento original.

@Param:
nPosG125   -> Posicao de relacionamento com o registro PAI - C125
aRegG130   -> Array que retorna a estrutura do registro C130
aInfRegs   -> Array com as informacoes dos documentos jah processadas conforme o tipo de movimento CIAP                       ³±±
lExtratTAF -> Indica se a chamada é via extrator fiscal
aRegT050AC -> Array de retorno do extator fiscal

@Author Gustavo G. Rueda
@since  17/03/2011
@version 1.0

@Return nPos

/*/
//--------------------------------------------------------------------------------------------------------------
Static Function RegG130( nPosG125,aRegG130,aInfRegs,lExtratTAF,aRegT050AC )

Local   nPos    :=  0
Local   cSerie  := aInfRegs[4]


//-------------------------------------------
//Tratamento para nao duplicar os registros
//-------------------------------------------
nPos := aScan(aRegG130,{|aX|aX[1]==nPosG125 .And. aX[3]==aInfRegs[1] .And. aX[4]==aInfRegs[2] .And. aX[5]==aInfRegs[3] .And. aX[6]==cSerie .And. aX[7]==aInfRegs[5] .And. aX[8]==aInfRegs[6]})
If nPos == 0
    aAdd(aRegG130, {})
    nPos    :=  Len (aRegG130)
    aAdd (aRegG130[nPos], nPosG125)                     //00 - Relacionamento com o registro PAI
    aAdd (aRegG130[nPos], "G130")                       //01-REG
    aAdd (aRegG130[nPos], aInfRegs[1])                  //02-IND_EMIT
    aAdd (aRegG130[nPos], aInfRegs[2])                  //03-COD_PART
    aAdd (aRegG130[nPos], aInfRegs[3])                  //04-COD_MOD
    aAdd (aRegG130[nPos], aInfRegs[4])                  //05-SERIE
    aAdd (aRegG130[nPos], aInfRegs[5])                  //06-NUM_DOC
    aAdd (aRegG130[nPos], aInfRegs[6])                  //07-CHV_NFE_CTE
    aAdd (aRegG130[nPos], aInfRegs[7])                  //08-DT_DOC
EndIf

If lExtratTAF
    aadd( aRegT050AC, aRegG130[nPos] )
endif

Return nPos



//--------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} RegG140

Funcao utilizada para montar a estrutura do registro G140 do CIAP
Esta funcao estah preparada tanto para utilizar informacoes do
documento de entrada caso exista (prioridade 1), como para
utilizar as informacoes atraves de parametros caso nao exista o
documento original.

@Param:
nPosG130   -> Posicao de relacionamento com o registro PAI - C130
aRegG140   -> Array que retorna a estrutura do registro C140
aInfRegs   -> Array com as informacoes dos documentos jah processadas conforme o tipo de movimento CIAP                       ³±±
lExtratTAF -> Indica se a chamada é via extrator fiscal
aRegT050AD -> Array de retorno do extator fiscal

@Author Gustavo G. Rueda
@since  17/03/2011
@version 1.0

@Return ( Nil )

/*/
//--------------------------------------------------------------------------------------------------------------
Static Function RegG140( nPosG130,aRegG140,aInfRegs,lExtratTAF,aRegT050AD )

Local	nPos	:=	0

//------------------------------------------------
//Tratamento para evitar duplicidade no registro
//------------------------------------------------
If aScan(aRegG140,{|aX|aX[1]==nPosG130 .And. aX[3]==aInfRegs[8] .And. aX[4]==aInfRegs[9]})==0
	aAdd(aRegG140, {})
	nPos	:=	Len (aRegG140)
	aAdd (aRegG140[nPos], nPosG130)						//00 - Relacionamento com o registro C125
	aAdd (aRegG140[nPos], "G140") 	 		 			//01-REG
	aAdd (aRegG140[nPos], aInfRegs[8])			 		//02-NUM_ITEM
	aAdd (aRegG140[nPos], aInfRegs[9]) 					//03-COD_ITEM
EndIf

if lExtratTAF
	aadd( aRegT050AD, aRegG140[nPos] )
endif

Return

//--------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} R03000305

REGISTRO 0300 - CADASTRO DE BENS OU COMPONENTES DO ATIVO IMOBILIZADO
REGISTRO 0305 - INFORMACAO SOBRE A UTILIZACAO DO BEM
Geracao e gravacao dos Registros 0300 e 0305

@Param:
cAlias    -> Alias do TRB que recebera as informacoes
aClasCIAP -> Informacoes da classificacao do ativo
nLimParc  -> Numero de parcelas aprovadas por Lei para aprop.
cCodCiap  -> Codigo do ativo montado pela rotina
aCmpsSF9  -> Campos customizados da tabela SF9
aReg0300  -> Array para controle da duplicidade

@Author Gustavo G. Rueda
@since  18/03/2011
@version 1.0

@Return ( Nil )
/*/
//--------------------------------------------------------------------------------------------------------------
Static Function R03000305( cAlias,aClasCIAP,nLimParc,cCodCiap,aCmpsSF9,aReg0300,aReg0305, cAliasSFA )

Local	nPos		:=	0
Local	nPos2		:=	0
Local 	nPosB		:=	0
Local	nPos2B		:=	0
Local 	nVal		:= 	0
Local 	lFlag		:= .F.
Local	aAreaSF9	:=	SF9->(GetArea ())
Local	cContCtb	:= RetCOD_CTA(cAliasSFA, "0300")

If !Empty(cContCtb)
   aClasCIAP[1] := cContCtb
EndIf

//--------------------------------------------------
//|Tratamento para evitar duplicidade de informacoes
//--------------------------------------------------
If (nPos := aScan(aReg0300,{|aX| aX[2]==cCodCiap}))==0

	//--------------------------------------------------------------------
	//REGISTRO 0300 - CADASTRO DE BENS OU COMPONENTES DO ATIVO IMOBILIZADO
	//--------------------------------------------------------------------
	aAdd(aReg0300, {})
	nPos	:=	Len(aReg0300)
	aAdd(aReg0300[nPos], "0300") 	  														//01-REG
	aAdd(aReg0300[nPos], cCodCiap) 															//02-COD_IND_BEM
	aAdd(aReg0300[nPos], Iif(SF9->F9_TIPO=="03","2","1"))									//03-IDENT_MERC
	aAdd(aReg0300[nPos], aCmpsSF9[26])														//04-DESCR_ITEM
	aAdd(aReg0300[nPos], Iif(!EMPTY(SF9->F9_CODBAIX) .And. SF9->F9_CODBAIX <> "BFINAL",SF9->F9_CODBAIX+xFilial("SF9")," "))	//05-COD_PRNC
	aAdd(aReg0300[nPos], aClasCIAP[1])														//06-COD_CTA
	aAdd(aReg0300[nPos], AllTrim(Str(nLimParc)))											//07-NR_PARC

	//--------------------------------------------------------------------
	//|REGISTRO 0305 - INFORMACAO SOBRE A UTILIZACAO DO BEM
	//--------------------------------------------------------------------
	If aReg0300[nPos][3] == "1"
		aAdd(aReg0305, {})
		nPos2	:=	Len(aReg0305)
		aAdd (aReg0305[nPos2], nPos)						 	  	//00-Relacionamento com o PAI
		aAdd (aReg0305[nPos2], "0305") 	  							//01-REG
		aAdd (aReg0305[nPos2], aClasCIAP[2]) 						//02-COD_CCUS
		aAdd (aReg0305[nPos2], aClasCIAP[3])						//03-FUNC
		aAdd (aReg0305[nPos2], AllTrim(Str(aCmpsSF9[16])))			//04-VIDA_UTIL
	EndIf

	//-------------------------------------------------
	//|REGISTRO 0300 - GERACAO DO REGISTRO DO BEM FINAL
	//-------------------------------------------------
	If !Empty(aReg0300[nPos][5]) .And. (nVal:=aScan(aReg0300,{|aX| aX[2]==aReg0300[nPos][5]}))==0
		dbSelectArea("SF9")
		dbSetOrder(1)
		If SF9->(msSeek(xFilial("SF9")+SF9->F9_CODBAIX))
			aAdd(aReg0300, {})
			nPosB	:=	Len(aReg0300)
			aAdd(aReg0300[nPosB], "0300") 	  								   			//01-REG
			aAdd(aReg0300[nPosB], aReg0300[nPos][5])		   				   			//02-COD_IND_BEM
			aAdd(aReg0300[nPosB], "1")										   			//03-IDENT_MERC
			aAdd(aReg0300[nPosB], SF9->F9_DESCRI)										//04-DESCR_ITEM
			aAdd(aReg0300[nPosB], " ")													//05-COD_PRNC
			aAdd(aReg0300[nPosB], aClasCIAP[1])											//06-COD_CTA
			aAdd(aReg0300[nPosB], Iif(EMPTY(SF9->F9_QTDPARC),AllTrim(Str(nLimParc)),;
										AllTrim(Str(SF9->F9_QTDPARC))))					//07-NR_PARC

			//-------------------------------------------------
			//|REGISTRO 0305 - GERACAO DO REGISTRO DO BEM FINAL
			//-------------------------------------------------
			aAdd(aReg0305, {})
			nPos2B :=	Len(aReg0305)
			aAdd (aReg0305[nPos2B], nPosB)						 		//00-Relacionamento com o PAI
			aAdd (aReg0305[nPos2B], "0305") 	  						//01-REG
			aAdd (aReg0305[nPos2B], aClasCIAP[2]) 						//02-COD_CCUS
			aAdd (aReg0305[nPos2B], aClasCIAP[3])						//03-FUNC
			aAdd (aReg0305[nPos2B], AllTrim(Str(SF9->F9_VIDUTIL)))		//04-VIDA_UTIL

		EndIf
	EndIf

EndIf

RestArea(aAreaSF9)

Return

//--------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Reg0500

REGISTRO 0500 - PLANO DE CONTAS CONTABEIS
Geracao e gravacao dos Registros 0500

@Param:
cAlias    -> Alias do TRB que recebera as informacoes
aClasCIAP -> Informacoes da classificacao do ativo
lCtbInUse -> Flag que determina se eh CTB ou SIGACON
aReg0500  -> Array com a estrutura do registro 0500

@Author Gustavo G. Rueda
@since  18/03/2011
@version 1.0

@Return ( Nil )
/*/
//--------------------------------------------------------------------------------------------------------------
Static Function Reg0500( cAlias,aClasCIAP,lCtbInUse,aReg0500,lExtratTAF)
Local	nPos		:=	0
Local	cConta		:=	""

//---------------------------------------
//Tratamento para CTB ou o antigo SIGACON
//---------------------------------------
If lCtbInUse
	cConta		:=	SubStr(aClasCIAP[1],1,TamSx3("CT1_CONTA")[1])

	//------------------------------------------------
	//Tratamento para evitar duplicidade de informacao
	//------------------------------------------------
	If CT1->(MsSeek(xFilial("CT1")+cConta)) .And.;
		aScan(aReg0500,{|aX| aX[6]==aClasCIAP[1] .And. aX[2]==CT1->CT1_DTEXIS})==0

		aAdd(aReg0500, {})
		nPos	:=	Len (aReg0500)
		aAdd (aReg0500[nPos], "0500") 								//01-REG
		aAdd (aReg0500[nPos], CT1->CT1_DTEXIS) 						//02-DT_ALT

		//----------------------------------------
		//Campo criado para atender o SPED Fiscal
		//----------------------------------------
		aAdd (aReg0500[nPos], CT1->CT1_NTSPED)						 //03-COD_NAT_CC
		aAdd (aReg0500[nPos], IIF(CT1->CT1_CLASSE=="1","S","A")) 	 //04-IND_CTA
		aAdd (aReg0500[nPos], AllTrim(Str(CtbNivCta(aClasCIAP[1])))) //05-NIVEL
		aAdd (aReg0500[nPos], aClasCIAP[1])							 //06-COD_CTA
		aAdd (aReg0500[nPos], CT1->CT1_DESC01) 						 //07-NOME_CTA

   	EndIf
Else
	cConta		:=	SubStr(aClasCIAP[1],1,TamSx3("I1_CODIGO")[1])

	If SI1->(MsSeek(xFilial("SI1")+cConta)) .And.;
		aScan(aReg0500,{|aX| aX[6]==aClasCIAP[1] .And. aX[2]==""})==0

		aAdd(aReg0500, {})
		nPos	:=	Len (aReg0500)
		aAdd (aReg0500[nPos], "0500") 								//01-REG
		aAdd (aReg0500[nPos], "")			 						//02-DT_ALT
		aAdd (aReg0500[nPos], "")									//03-COD_NAT_CC
		aAdd (aReg0500[nPos], SI1->I1_CLASSE)					 	//04-IND_CTA
		aAdd (aReg0500[nPos], SI1->I1_NIVEL)		 				//05-NIVEL
		aAdd (aReg0500[nPos], aClasCIAP[1]) 						//06-COD_CTA
		aAdd (aReg0500[nPos], SI1->I1_DESC) 						//07-NOME_CTA
	EndIf
EndIf

If nPos>0 .and. !lExtratTAF
	GrvRegTrS(cAlias,,{aReg0500[nPos]})
EndIf

Return

//--------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Reg0600

REGISTRO 0600 - CENTRO DE CUSTOS
Geracao e gravacao dos Registros 0600

@Param:
cAlias -> Alias do TRB que recebera as informacoes
aClasCIAP -> Informacoes da classificacao do ativo
lCtbInUse -> Flag que determina se eh CTB ou SIGACON
aReg0600  -> Array com a estrutura do registro 0600

@Author Gustavo G. Rueda
@since  18/03/2011
@version 1.0

@Return ( Nil )
/*/
//--------------------------------------------------------------------------------------------------------------
Static Function Reg0600( cAlias,aClasCIAP,lCtbInUse,aReg0600,lExtratTAF)

Local	nPos	:=	0
Local	cCC		:=	""

//--------------------------------------------------
//Tratamento para evitar duplicidade de informacao
//--------------------------------------------------
If aScan(aReg0600,{|aX| aX[3]==aClasCIAP[2]})==0

	//----------------------------------------
	//Tratamento para CTB ou o antigo SIGACON
	//----------------------------------------
	If lCtbInUse
		cCC		:=	SubStr(aClasCIAP[2],1,TamSx3("CTT_CUSTO")[1])

	 	If CTT->(MsSeek(xFilial("CTT")+cCC))
			aAdd(aReg0600, {})
			nPos	:=	Len (aReg0600)
			aAdd (aReg0600[nPos], "0600")						//01-REG
			aAdd (aReg0600[nPos], CTT->CTT_DTEXIS)				//02-DT_ALT
			aAdd (aReg0600[nPos], aClasCIAP[2])					//03-COD_CCUS
			aAdd (aReg0600[nPos], CTT->CTT_DESC01) 				//04-CCUS
	 	EndIf
	Else
		cCC		:=	SubStr(aClasCIAP[2],1,TamSx3("I3_CUSTO")[1])

		If SI3->(MsSeek(xFilial("SI3")+cCC))
			aAdd(aReg0600, {})
			nPos	:=	Len (aReg0600)
			aAdd (aReg0600[nPos], "0600")						//01-REG
			aAdd (aReg0600[nPos], "")							//02-DT_ALT
			aAdd (aReg0600[nPos], aClasCIAP[2])					//03-COD_CCUS
			aAdd (aReg0600[nPos], SI3->I3_DESC) 				//04-CCUS
		EndIf
	EndIf

	If nPos>0 .and. !lExtratTAF
		GrvRegTrS(cAlias,,{aReg0600[nPos]})
	EndIf
EndIf

Return

//--------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} ExtGeraCIAP
Função responsável pela geração dos registros de Movimentação CIAP do Extrator Fiscal

@Param:  cTpSaida   -> Tipo de saída escolhida pelo cliente no extrator
		  cTxtSys    -> Nome do arquivo a ser gerado
		  aWizard    -> Informaçoes da Wizard do extrator fiscal
		  lDefLayout -> Indica se o usuário deseja realizar a geração de todos os layouts
		  aLaySel    -> Layouts selecionados para processamento
		  lJob       -> Indica se o processamento foi executado via Job
		  aArqGer    -> Array com os arquivos gerados no extrator
		  aLisFil    -> Array de seleção de filiais no formato padrão da rotina BlocoG

@Author Rodrigo Aguilar
@since  13/12/2016
@version 1.0

@Return ( Nil )
/*/
//--------------------------------------------------------------------------------------------------------------
Function ExtGeraCIAP( cTpSaida, cTxtSys, aWizard, lDefLayout, aLaySel, lJob, aArqGer, aLisFil )

local cAlias   as Character //variável não é utilizado na função BlocoG, declarado apenas para melhor entendimento do código
local cFilDe   as Character //variável não é utilizado na função BlocoG, declarado apenas para melhor entendimento do código
local cFilAte  as Character //variável não é utilizado na função BlocoG, declarado apenas para melhor entendimento do código

local lTop	    as Logical    //Para utilizar o TAF deve possuir ambiente TOP
local lEnd     as Logical   //Para controlar se o usuário cancelou o processamento

local nCtdFil   as Number   //Define a quantidade de filiais que serão processadas no BLOCO G
local nRegsProc as Number
local nI        as Number
local nIniReg   as Number
local nY        as Number
local nZ        as Number

local aReg0200   as Array   //variável não é utilizado na função BlocoG, declarado apenas para melhor entendimento do código
local aReg0190   as Array   //variável não é utilizado na função BlocoG, declarado apenas para melhor entendimento do código
local aReg0220   as Array   //variável não é utilizado na função BlocoG, declarado apenas para melhor entendimento do código
local aReg0150   as Array   //variável não é utilizado na função BlocoG, declarado apenas para melhor entendimento do código

local aRegT050    as Array
local aRegT050AA  as Array
local aRegT050AB  as Array
local aRegT050AC  as Array
local aRegT050AD  as Array
local aRegT008    as Array
local aRegT008Aux as Array

local bWhileSM0 as ExecBlock

//-------------------------------------------------------
//Definindo os valores de variaveis para o processamento
//-------------------------------------------------------
cAlias     := ''  ; cFilAte    := ''
nCtdFil    := 1   ; nRegsProc  := 0 ; nI := 0 ; nIniReg := 0 ; nY := 0 ; nZ := 0
lTop       := .T. ; lEnd 	   := .F.
aReg0200   := {}  ; aReg0190   := {}; aReg0220   := {}; aReg0150   := {}; aRegT050 := {}
aRegT050AA := {}  ; aRegT050AB := {}; aRegT050AC := {}; aRegT050AD := {}; aRegT008 := {}
aRegT008Aux:= {}

//----------------------------------------------------------------------------------------------------
//Executo somente para a filial que esta sendo processada dentro do laço, cada filial terá seus dados
//de movimentação CIAP individualizado
//----------------------------------------------------------------------------------------------------
bWhileSM0	:= {|| !SM0->(Eof ()) .and. ( ( !"1" $ aWizard[1][5] .and. cEmpAnt == SM0->M0_CODIGO .And. cFilAnt == cFilAte ) .Or. ( "1" $ aWizard[1][5] .and. len( aLisFil ) > 0 .And. cEmpAnt == SM0->M0_CODIGO ) ) }

//-----------------------------------------------------------------------------------------------
//se o usuário selecionou as filiais de processamento eu preciso setar de "" a "zz" as filiais de
//processamento, visto que o controle de qual filial será processada ficara a cargo do aLisFil
//-----------------------------------------------------------------------------------------------
if !empty( aLisFil )
	cFilDe	:=	PadR("",FWGETTAMFILIAL)
	cFilAte	:=	Repl("Z",FWGETTAMFILIAL)

//-------------------------------------------------------------------------------
//Caso contrário considero apenas a filial corrente para processamento do Bloco G
//-------------------------------------------------------------------------------
else
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
endif

BlocoG( cAlias, lTop, aWizard, @aReg0200, @aReg0190, @aReg0220, @aReg0150, cFilDe,;
	    cFilAte, aLisFil, bWhileSM0, @lEnd, nCtdFil, 1, @nRegsProc, @oProcess, .T.,;
	    @aRegT050, @aRegT050AA, @aRegT050AB, @aRegT050AC, @aRegT050AD, @aRegT008, @aRegT008Aux )


//-------------------------------------------------------------------------------------
//INICO DA GERAÇÃO DAS INFORMAÇÕES REFERENTES A CADASTRO DE BENS OU COMPONENTES DO ATIVO
//IMOBILIZADO ( T008 )
//-------------------------------------------------------------------------------------
If !lDefLayout .Or. aScan( aLaySel, { |x| x == "T008" } ) > 0

	If lJob
		MsgJobExt( "Gerando Registro " + "T008 - Bens e Ativos..." )

	Else
		oProcess:Inc1Progress()
		oProcess:Inc2Progress( "Gerando Registro " + "T008 - Bens e Ativos..." )

	EndIf

    if len( aRegT008 ) > 0

    	nHdlTxt := IIf( cTpSaida == "1" , MsFCreate( cTxtSys + "T008.TXT" ) , 0 )
    	Aadd(aArqGer, ( cTxtSys + "T008.TXT" ) )

		RegT008( nHdlTxt, aRegT008, aRegT008Aux,cTpSaida )

		if cTpSaida == "1"
			FClose( nHdlTxt )
		endif

    endif

endif

//-------------------------------------------------------------------------------------
//INICO DA GERAÇÃO DAS INFORMAÇÕES REFERENTES A MOVIMENTAÇÃO CIAP ( T050 )

//Realizar a emissão dos registros T050 ( Movimentação CIAP ) e seus respectivos filhos
//-------------------------------------------------------------------------------------
If !lDefLayout .Or. aScan( aLaySel, { |x| x == "T050" } ) > 0

	If lJob
		MsgJobExt( "Gerando Registro " + "T050 - Movimentação CIAP..." )

	Else
		oProcess:Inc1Progress()
		oProcess:Inc2Progress( "Gerando Registro " + "T050 - Movimentação CIAP..." )

	EndIf

    if len( aRegT050 ) > 0

    	nHdlTxt := IIf( cTpSaida == "1" , MsFCreate( cTxtSys + "T050.TXT" ) , 0 )
    	Aadd(aArqGer, ( cTxtSys + "T050.TXT" ) )

		RegT050( nHdlTxt, aWizard, aRegT050 )

		for nI := 1 to len( aRegT050AA )

			//--------------------------
			//Geração do registro T050AA
			//--------------------------
			RegT050AA( nHdlTxt, aRegT050AA[nI] )

			//-------------------------------------
			//Laço para Geração do registro T050AB
			//-------------------------------------
			nIniReg := aScan( aRegT050AB, {|x| x[1] == nI })
			if nIniReg > 0
				for nY := nIniReg to len( aRegT050AB )
					if aRegT050AB[ny][1] == nI
						RegT050AB( nHdlTxt, aRegT050AB[nY] )
					else
						exit
					endif
				next
			endif

			//-------------------------------------
			//Laço para Geração do registro T050AC
			//-------------------------------------
			nIniReg := aScan( aRegT050AC, {|x| x[1] == nI })
			if nIniReg > 0
				for nY := nIniReg to len( aRegT050AC )
					if aRegT050AC[ny][1] == nI

						RegT050AC( nHdlTxt, aRegT050AC[nY] )

						//-------------------------------------
						//Laço para Geração do registro T050AD
						//-------------------------------------
						nIniReg := aScan( aRegT050AD, {|x| x[1] == nY })
						if nIniReg > 0

							for nZ := nIniReg to len( aRegT050AD )
								if aRegT050AD[nZ][1] == nY
									RegT050AD( nHdlTxt, aRegT050AD[nZ] )

								else
									exit
								endif
							next
						endif
					else
						exit

					endif
				next
			endif

		next

		//-----------------------------------
		//Grava o registro na TABELA TAFST1
		//-----------------------------------
		if cTpSaida == "2"
			FConcST1()
		endif

		if cTpSaida == "1"
			FClose( nHdlTxt )
		endif

    endif
endif

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} RegT008
Realiza a geracao do registro T008 do TAF

@Param nHdlTxt     -> Handle de geracao do Arquivo
		aRegT008    -> Array com informacoes do registro T008
		aRegT008Aux -> Array com informacoes do registro T008Aux

@Return ( Nil )

@author Rodrigo Aguilar
@since  13/12/2016
@version 1.0

/*/
//-------------------------------------------------------------------
Static Function RegT008( nHdlTxt, aRegT008, aRegT008Aux, cTpSaida )

local aRegs as Array

local nZ as Number
local nK as Number

aRegs := {}
nZ := 0; nL := 0

for nZ := 1 to len( aRegT008 )
	aRegs := {}

	Aadd( aRegs, {  'T008',;
					  aRegT008[ nZ, 2],;
					  aRegT008[ nZ, 3],;
					  aRegT008[ nZ, 4],;
					  aRegT008[ nZ, 5],;
					  aRegT008[ nZ, 6],;
					  aRegT008[ nZ, 7],;
					  '',;
					  '',;
					  '' } )

	nPos:= aScan( aRegT008Aux, { |x| x[1] == nZ } )
	for nK := nPos to len( aRegT008Aux )
		if aRegT008Aux[ nK, 1 ] == nPos

			aRegs[ len(aRegs), 8 ] := aRegT008Aux[ nK, 3 ]
			aRegs[ len(aRegs), 9 ] := aRegT008Aux[ nK, 4 ]
			aRegs[ len(aRegs), 10] := aRegT008Aux[ nK, 5 ]
		else
			exit
		endif
	next

	FConcTxt( aRegs, nHdlTxt )
	//-----------------------------------
	//Grava o registro na TABELA TAFST1
	//-----------------------------------
	if cTpSaida == "2"
		FConcST1()
	endif

next

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} RegT050
Realiza a geracao do registro T050 do TAF

@Param nHdlTxt    -> Handle de geracao do Arquivo
		aWizard    -> Wizard com as informações escohidas pelo usuário
		aRegT050 -> Array com informacoes do registro T050

@Return ( Nil )

@author Rodrigo Aguilar
@since  12/12/2016
@version 1.0

/*/
//-------------------------------------------------------------------
Static Function RegT050( nHdlTxt, aWizard, aRegT050 )

local aRegs as Array

aRegs := {}

Aadd( aRegs, {  'T050',;
				  dTos( aRegT050[1,2] ),;
				  dToS( aRegT050[1,3] ),;
				  Val2Str( aRegT050[1,4], 16, 2  ),;
				  Val2Str( aRegT050[1,5], 16, 2  ),;
				  Val2Str( aRegT050[1,6], 16, 2  ),;
				  Val2Str( aRegT050[1,7], 16, 2  ),;
				  aRegT050[1,8],;
				  Val2Str( aRegT050[1,9], 16, 2  ),;
				  Val2Str( aRegT050[1,10], 16, 2  ) } )

FConcTxt( aRegs, nHdlTxt )

Return ( Nil )

//-------------------------------------------------------------------
/*/{Protheus.doc} RegT050AA
Realiza a geracao do registro T050AA do TAF

@Param nHdlTxt    -> Handle de geracao do Arquivo
		aRegT050AA -> Array com informacoes do registro T050AA

@Return ( Nil )

@author Rodrigo Aguilar
@since  12/12/2016
@version 1.0

/*/
//-------------------------------------------------------------------
Static Function RegT050AA( nHdlTxt, aRegT050AA )

local aRegs := {}

aRegs := {}
Aadd( aRegs, {  'T050AA',;
				  aRegT050AA[02],;
				  dToS(aRegT050AA[03]),;
				  aRegT050AA[04],;
			  	  Val2Str( aRegT050AA[05], 16, 2  ),;
			  	  Val2Str( aRegT050AA[06], 16, 2  ),;
			  	  Val2Str( aRegT050AA[07], 16, 2  ),;
			  	  Val2Str( aRegT050AA[08], 16, 2  ),;
				  aRegT050AA[09],;
			  	  Val2Str( aRegT050AA[10], 16, 2  ) } )

FConcTxt( aRegs, nHdlTxt )

Return ( Nil )

//-------------------------------------------------------------------
/*/{Protheus.doc} RegT050AB
Realiza a geracao do registro T050AB do TAF

@Param nHdlTxt    -> Handle de geracao do Arquivo
		aRegT020AB -> Array com informacoes do registro T050AB

@Return ( Nil )

@author Rodrigo Aguilar
@since  12/12/2016
@version 1.0

/*/
//-------------------------------------------------------------------
Static Function RegT050AB( nHdlTxt, aRegT050AB )

local cDataIni := iif( valtype( aRegT050AB[3] ) == 'D', dTos( aRegT050AB[3] ), aRegT050AB[3] )
local cDataFin := iif( valtype( aRegT050AB[4] ) == 'D', dTos( aRegT050AB[4] ), aRegT050AB[4] )
local cIndPart := iif( valtype( aRegT050AB[9] ) == 'N', Val2Str( aRegT050AB[09], 16, 8 ), aRegT050AB[9] )
local aRegs := {}

Aadd( aRegs, {  'T050AB',;
				  cDataIni,;
				  cDataFin,;
				  aRegT050AB[5],;
				  Val2Str( aRegT050AB[06], 16, 2  ),;
				  Val2Str( aRegT050AB[07], 16, 2  ),;
				  Val2Str( aRegT050AB[08], 16, 2  ),;
				  cIndPart,;
				  Val2Str( aRegT050AB[10], 16, 2  ) } )

FConcTxt( aRegs, nHdlTxt )

Return ( Nil )

//-------------------------------------------------------------------
/*/{Protheus.doc} RegT050AC
Realiza a geracao do registro T050AC do TAF

@Param nHdlTxt    -> Handle de geracao do Arquivo
		aRegT020AC -> Array com informacoes do registro T050AC

@Return ( Nil )

@author Rodrigo Aguilar
@since  12/12/2016
@version 1.0

/*/
//-------------------------------------------------------------------
Static Function RegT050AC( nHdlTxt, aRegT050AC )

local aRegs := {}

Aadd( aRegs, {  'T050AC',;
				  aRegT050AC[3],;
				  aRegT050AC[4],;
				  aRegT050AC[5],;
				  aRegT050AC[6],;
				  aRegT050AC[7],;
				  aRegT050AC[8],;
				  dToS( aRegT050AC[9] ) } )

FConcTxt( aRegs, nHdlTxt )

Return ( Nil )

//-------------------------------------------------------------------
/*/{Protheus.doc} RegT050AD
Realiza a geracao do registro T050AD do TAF

@Param nHdlTxt    -> Handle de geracao do Arquivo
		aRegT050AD -> Array com informacoes do registro T050AD

@Return ( Nil )

@author Rodrigo Aguilar
@since  12/12/2016
@version 1.0

/*/
//-------------------------------------------------------------------
Static Function RegT050AD( nHdlTxt, aRegT050AD )

local aRegs := {}

Aadd( aRegs, {  'T050AD',;
				  aRegT050AD[3],;
				  aRegT050AD[4] } )

FConcTxt( aRegs, nHdlTxt )

Return ( Nil )
