#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0084   ³ Autor ³ Alexandro da Silva    ³ Data ³ 03.04.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Faturamento por Cliente                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Faturamento                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0084()

LOCAL CbTxt
LOCAL wnrel
LOCAL titulo     := "Faturamento por Cliente"
LOCAL cDesc1     := "Este relatorio emite a relacao de faturamento. Podera ser"
LOCAL cDesc2     := "emitido por ordem de Cliente ou por Valor (Ranking).     "
LOCAL cString    := "SF2"
LOCAL tamanho    := "M"
LOCAL limite     := 132

PRIVATE aReturn  := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 2, 1, "",1 }
PRIVATE aCodCli  := {}
PRIVATE aLinha   := {}
PRIVATE nomeprog := "PA0084"
PRIVATE cPerg    := "MTR590"
PRIVATE nLastKey := 0

cbtxt    := SPACE(10)
li       := 80
m_pag    := 01

pergunte("MTR590",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        // Data de                  		         ³
//³ mv_par02        // Data ate  					       		 ³
//³ mv_par03        // Cliente de                                ³
//³ mv_par04 	    // Cliente ate                               ³
//³ mv_par05	    // Estado de                                 ³
//³ mv_par06	    // Estado ate                                ³
//³ mv_par07	    // Cliente  Valor  Estado                    ³
//³ mv_par08	    // Moeda                                     ³
//³ mv_par09        // Devolucao				                 ³
//³ mv_par10        // Duplicatas  			                     ³
//³ mv_par11        // Estoque   				                 ³
//³ mv_par12        // Abatimento  				                 ³
//³ mv_par13        // Converte a moeda da devolucao             ³
//³ mv_par14        // Desconsidera adicionais ?                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel  := "PA0084"
wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,"",.F.,"",,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C590Imp(@lEnd,wnRel,cString)},Titulo)
Return


Static Function C590Imp(lEnd,WnRel,cString)

LOCAL cEstoq   := If( (MV_PAR11== 1),"S",If( (MV_PAR11== 2),"N","SN" ) )
LOCAL cDupli   := If( (MV_PAR10== 1),"S",If( (MV_PAR10== 2),"N","SN" ) )
LOCAL nAbto    := MV_PAR12
LOCAL cPict	   := ""
LOCAL CbTxt    := ""
LOCAL CbCont   := ""
LOCAL cabec1   := ""
LOCAL cabec2   := ""
LOCAL cCliente := ""
LOCAL cLoja    := ""
LOCAL cEst     := ""
LOCAL cMoeda   := ""
LOCAL tamanho  := "M"
LOCAL limite   := 132
LOCAL nRank    := 0
LOCAL nMoeda   := 0
LOCAL nAg1     := 0
LOCAL nAg2     := 0
LOCAL nAg3     := 0
LOCAL nAg4     := 0
LOCAL nAg5     := 0
LOCAL nAg6     := 0
LOCAL nAg7     := 0
LOCAL nValor1  := 0
LOCAL nValor2  := 0
LOCAL nValor3  := 0
LOCAL nValor4  := 0
LOCAL nValor5  := 0
LOCAL nValor6  := 0
LOCAL nValor7  := 0
LOCAL nEstV1   := 0
LOCAL nEstV2   := 0
LOCAL nEstV3   := 0
LOCAL nEstV4   := 0
LOCAL nEstV5   := 0
LOCAL nEstV6   := 0
LOCAL nEstV7   := 0
LOCAL aCampos  := {}
LOCAL aTam	   := {}

PRIVATE nDecs:=msdecimais(mv_par08)

cPict	:= "@E) 99,999,999,999" + IIf(nDecs > 0,"."+replicate("9",nDecs),"")

nTipo:=IIF(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM"))

cbtxt    := SPACE(10)
cbcont   := 00
li       := 80
m_pag    := 01

nMoeda := mv_par08
cMoeda := GetMv("MV_MOEDA"+Ltrim(STR(nMoeda)))

IF mv_par07 = 1
	titulo := "FATURAMENTO POR CLIENTE  (CODIGO) - "
ElseIf mv_par07 == 2
	titulo := "FATURAMENTO POR CLIENTE  (RANKING) - "
Else
	titulo := "FATURAMENTO POR CLIENTE  (ESTADO) - "
EndIF

cabec1 := "CODIGO/LOJA  RAZAO SOCIAL                               FATURAMENTO       VALOR DA          VALOR    FATUR. SEM  RANKING"
cabec2 := "                                                            SEM ICM     MERCADORIA          TOTAL  ICMS + DIFER.        "

/*
CODIGO/LOJA  RAZAO SOCIAL                               FATURAMENTO       VALOR DA          VALOR    FATUR. SEM  RANKING
                                                            SEM ICM     MERCADORIA          TOTAL  ICMS + DIFER.
99999999999  9999999999999999999999999999999999999999 9999999999999 99999999999999 99999999999999 99999999999999 9999999
0            13                                       54            68             83             98             113
*/

aTam:=TamSX3("F2_CLIENTE")
AADD(aCampos,{ "TB_CLI"    ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("F2_LOJA")
AADD(aCampos,{ "TB_LOJA"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A1_EST")
AADD(aCampos,{ "TB_EST"    ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("F2_EMISSAO")
AADD(aCampos,{ "TB_EMISSAO","D",aTam[1],aTam[2] } )
AADD(aCampos,{ "TB_VALOR1 ","N",18,nDecs } )		// Valores de Faturamento
AADD(aCampos,{ "TB_VALOR2 ","N",18,nDecs } )
AADD(aCampos,{ "TB_VALOR3 ","N",18,nDecs } )
AADD(aCampos,{ "TB_VALOR4 ","N",18,nDecs } )		// Valores para devolucao
AADD(aCampos,{ "TB_VALOR5 ","N",18,nDecs } )
AADD(aCampos,{ "TB_VALOR6 ","N",18,nDecs } )
AADD(aCampos,{ "TB_VALOR7 ","N",18,nDecs } )
AADD(aCampos,{ "TB_RANKIN ","N",18 } )        // Ranking conforme Valor faturamento

cNomArq := CriaTrab(aCampos)
dbUseArea( .T.,, cNomArq,cNomArq, if(.T. .OR. .F., !.F., NIL), .F. )
cNomArq1 := SubStr(cNomArq,1,7)+"1"
cNomArq2 := SubStr(cNomArq,1,7)+"2"
cNomArq3 := SubStr(cNomArq,1,7)+"3"

IndRegua(cNomArq,cNomArq1,"TB_CLI+TB_LOJA",,,OemToAnsi("Selecionando Registros..."))

dbSelectArea("SF2")
dbSetOrder(2)

SetRegua(RecCount())		// Total de Elementos da regua

if mv_par09 == 3
	cKey:="D1_FILIAL+D1_SERIORI+D1_NFORI+D1_FORNECE+D1_LOJA"
	cFiltro :="D1_FILIAL=='"+xFilial("SD1")+"'.And.!Empty(D1_NFORI)"
	cFiltro += ".And. !("+IsRemito(2,"SD1->D1_TIPODOC")+")"
	cFiltro += '.And. D1_CANCEL <> "S"'
	IndRegua("SD1",cNomArq3,cKey,,cFiltro,OemToAnsi("Selecionando Registros..."))
	nIndex:=RetIndex("SD1")
	dbSetIndex(cNomArq3+OrdBagExt())
	dbSetOrder(nIndex+1)
	dbGotop()
Endif

GeraTrab(cEstoq,cDupli,nMoeda)

If mv_par09 == 1
	dbSelectArea("SF1")
	dbSetOrder(2)
	IncRegua()

	GeraTrab1(cEstoq,cDupli,nMoeda)
Endif

dbSelectArea(cNomArq)
dbCommit()
dbClearIndex()

If mv_par07 == 1
	
	IndRegua(cNomArq,cNomArq2,"StrZero(1000000000000 - TB_VALOR3 + TB_VALOR6,18,"+Str(nDecs)+")",,,OemToAnsi("Selecionando.."))
	dbGoTop()
	nRank:=1
	While !Eof()
		RecLock(cNomArq,.F.)
		Replace TB_RANKIN With nRank
		MsUnlock()
		nRank++
		dbSkip()
	Enddo
	nRank:=0
	
	dbClearIndex()
	IndRegua(cNomArq,cNomArq1,"TB_CLI+TB_LOJA",,,OemToAnsi("Selecionando..."))
ElseIf mv_par07 == 2
	IndRegua(cNomArq,cNomArq2,"StrZero(1000000000000 - TB_VALOR3 + TB_VALOR6,18,"+Str(nDecs)+")",,,OemToAnsi("Selecionando..."))
Else
	IndRegua(cNomArq,cNomArq1,"TB_EST+TB_CLI+TB_LOJA",,,OemToAnsi("Selecionando..."))
Endif

dbSelectArea(cNomArq)
dbGoTop()

While !Eof()
	IncRegua()
	
	If lEnd
		@Prow()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
		Exit
	Endif
	
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	
	If mv_par07 == 3
		If Empty(cEst)
			cEst := TB_EST
		ElseIf cEst != TB_EST
			li++
			@li, 00 PSAY OemToAnsi("Total do Estado de ") + cEst + "--->"
			@li, 54 PSAY nEstV1		PicTure Tm(nEstV1,13)
			@li, 68 PSAY nEstV2		PicTure Tm(nEstV2,14)
			@li, 83 PSAY nEstV3		PicTure Tm(nEstV3,14)
			@li, 98 PSAY nEstV7		PicTure Tm(nEstV7,14)
						
			If nEstv4+nEstv5+nEstv6!=0
				li++
				@li, 54 PSAY nEstV4		PicTure Tm(nEstV4,13)
				@li, 68 PSAY nEstV5		PicTure Tm(nEstV5,14)
				@li, 84 PSAY nEstV6		PicTure Tm(nEstV6,14)
				@li,113 PSAY "DEV"
				If nAbto == 1
					li++
					@li, 54 PSAY nEstV1+nEstV4  PICTURE Tm(nEstV1,13)
					@li, 68 PSAY nEstV2+nEstV5  PICTURE Tm(nEstV2,13)
					@li, 84 PSAY nEstV3+nEstV6  PICTURE Tm(nEstV3,13)
					@li,113 PSAY "ABT"
				Endif
			Endif
			cEst := TB_EST
			li++
			nEstV1:=0
			nEstV2:=0
			nEstV3:=0
			nEstV4:=0
			nEstV5:=0
			nEstV6:=0
			li++
		EndIf
		@ li,00 PSAY OemToAnsi("Estado: ") + cEst
		li++
	EndIf
	
	cCliente := TB_CLI
	cLoja    := TB_LOJA
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+cCliente+cLoja)
	
	@li,00 PSAY SA1->A1_COD + "/"+ SA1->A1_LOJA
	@li,13 PSAY Substr(SA1->A1_NOME,1,40)
	
	dbSelectArea(cNomArq)
	
	nValor1:= TB_VALOR1
	nValor2:= TB_VALOR2
	nValor3:= TB_VALOR3
	nValor4:= TB_VALOR4
	nValor5:= TB_VALOR5
	nValor6:= TB_VALOR6
	nValor7:= TB_VALOR7
	
	nValor4*=(-1)
	nValor5*=(-1)
	nValor6*=(-1)
	
	@li, 54 PSAY nValor1  PICTURE Tm(nValor1,13)
	@li, 68 PSAY nValor2  PICTURE Tm(nValor2,14)
	@li, 83 PSAY nValor3  PICTURE Tm(nValor3,14)
	@li, 98 PSAY nValor7  PICTURE Tm(nValor7,14)
		
	IF mv_par07 = 1
		nRank:=TB_RANKIN
		@li,113 PSAY nRank	PICTURE "9999"
	ELSEIF mv_par07 = 2
		nRank++
		@li,113 PSAY nRank	PICTURE "9999"
	EndIF
	
	If nValor4+nValor5+nValor6!=0
		li++
		@li, 54 PSAY nValor4  PICTURE Tm(nValor1,13)
		@li, 68 PSAY nValor5  PICTURE Tm(nValor1,14)
		@li, 83 PSAY nValor6  PICTURE Tm(nValor1,14)
		@li,113 PSAY "DEV"
		If nAbto == 1
			li++
			@li, 54 PSAY nValor1+nValor4  PICTURE Tm(nValor1,13)
			@li, 68 PSAY nValor2+nValor5  PICTURE Tm(nValor2,14)
			@li, 83 PSAY nValor3+nValor6  PICTURE Tm(nValor3,14)
			@li,113 PSAY "ABT"
		Endif
	Endif
	nEstV1+= nValor1
	nEstV2+= nValor2
	nEstV3+= nValor3
	nEstV4+= nValor4
	nEstV5+= nValor5
	nEstV6+= nValor6
	nEstV7+= nValor7
	
	li++
	
	nAg1 += nValor1
	nAg2 += nValor2
	nAg3 += nValor3
	nAg4 += nValor4
	nAg5 += nValor5
	nAg6 += nValor6
	nAg7 += nValor7
		
	dbSkip()
EndDo

IF li != 80
	
	If li > 54
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	
	If mv_par07 == 3
		li++
		@li, 00 PSAY OemToAnsi("Estado: ") + cEst + "--->"
		@li, 54 PSAY nEstV1		PicTure Tm(nEstV1,13)
		@li, 68 PSAY nEstV2		PicTure Tm(nEstV2,14)
		@li, 83 PSAY nEstV3		PicTure Tm(nEstV3,14)
		@li, 98 PSAY nEstV7		PicTure Tm(nEstV7,14)
		
		If (nEstV4+nEstV5+nEstV6)!=0
			li++
			@li, 54 PSAY nEstV4		PicTure Tm(nEstV4,13)
			@li, 68 PSAY nEstV5		PicTure Tm(nEstV5,14)
			@li, 83 PSAY nEstV6		PicTure Tm(nEstV6,14)
			@li,113 PSAY "DEV"
			If nAbto == 1
				li++
				@li, 54 PSAY nEstV1+nEstV4  PICTURE Tm(nEstV1,13)
				@li, 68 PSAY nEstV2+nEstV5  PICTURE Tm(nEstV2,14)
				@li, 83 PSAY nEstV3+nEstV6  PICTURE Tm(nEstV3,14)
				@li,113 PSAY "ABT"
			Endif
		Endif
		
		li:=li + 2
	EndIf
	li++
	@li, 00 PSAY OemToAnsi("T O T A L --->")
	@li, 54 PSAY nAg1		PicTure Tm(nAg1,13)
	@li, 68 PSAY nAg2		PicTure Tm(nAg2,14)
	@li, 83 PSAY nAg3		PicTure Tm(nAg3,14)
	@li, 98 PSAY nAg7		PicTure Tm(nAg7,14)
	
	If (nAg4+nAg5+nAg6)!=0
		li++
		@li, 54 PSAY nAg4		PicTure Tm(nAg4,13)
		@li, 68 PSAY nAg5		PicTure Tm(nAg5,14)
		@li, 83 PSAY nAg6		PicTure Tm(nAg6,14)
		@li,113 PSAY "DEV"
		If nAbto == 1
			li++
			@li, 54 PSAY nAg1+nAg4  PICTURE Tm(nAg1,13)
			@li, 68 PSAY nAg2+nAg5  PICTURE Tm(nAg2,14)
			@li, 83 PSAY nAg3+nAg6  PICTURE Tm(nAg3,14)
			@li,113 PSAY "ABT"
		Endif
	Endif
	
	roda(cbcont,cbtxt)
EndIF

dbSelectArea(cNomArq)
dbCloseArea()

cDelArq := cNomArq+GetDBExtension()

If File(cDelArq)
	fErase(cDelArq)
Endif
fErase(cNomArq1+OrdBagExt())
If mv_par07 <> 3
	Ferase(cNomarq2+OrdBagExt())
EndIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade dos dados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par09 == 3
	dbSelectArea("SD1")
	dbClearFilter()
	RetIndex()
	fErase(cNomArq3+OrdBagExt())
	dbSetOrder(1)
Endif

dbSelectArea("SF2")
dbClearFilter()
dbSetOrder(1)
dbSelectArea("SD2")
dbSetOrder(1)

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
Return


Static FuncTion GeraTrab(cEstoq,cDupli,nMoeda)

Local cChaven    := ""
Local nTOTAL     := 0
Local nVALICM    := 0
Local nVALIPI    := 0
Local ImpNoInc   := 0
Local nImpInc    := 0
Local nTB_VALOR1 := 0
Local nTB_VALOR2 := 0
Local nTB_VALOR3 := 0
Local nY         := 0
Local nTotSD2    := 0
Local nTotSD1    := 0
Local aImpostos  := {}
Local lAvalTes   := .F.
Local lProcessa  := .T.

Private cCampImp

dbSelectArea("SF2")
dbOrderNickName("INDSF21")
dbSeek(xFilial("SF2")+DTOS(MV_PAR01)+MV_PAR03,.T.)

While !Eof() .And. SF2->F2_EMISSAO <= MV_PAR02 
	
	lProcessa := .T.
	
	If SF2->F2_CLIENTE < MV_PAR03 .Or. SF2->F2_CLIENTE > MV_PAR04
		dbSelectArea("SF2")	
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1") + SF2->F2_CLIENTE+SF2->F2_LOJA )
	dbSelectArea("SF2")
	
	IF SA1->A1_EST 	 < mv_par05 .Or. SA1->A1_EST     > mv_par06
		lProcessa := .F.
	EndIF
	
	If At(SF2->F2_TIPO,"DB") != 0
		lProcessa := .F.
	Endif
	
	If lProcessa
		
		IncRegua()
		
		dbSelectArea("SD2")
		dbSetOrder(3)
		dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)
		nTOTAL 		:=0         
		_nTotDif    :=0
		nVALICM		:=0
		nVALIPI		:=0
		nImpNoInc	:=0
		nImpInc  	:=0
		lAvalTes    := .F.
		While !Eof() .And. xFilial("SD2")==SD2->D2_FILIAL .And.;
			SD2->D2_DOC+SD2->D2_SERIE == SF2->F2_DOC+SF2->F2_SERIE
			
			dbSelectArea("SF4")
			dbSeek(xFilial("SF4")+SD2->D2_TES)
			        			
			dbSelectArea("SD2")
			
			If AvalTes(D2_TES,cEstoq,cDupli)
				
				lAvalTes := .T.
			                           
				If SD2->D2_CLIENTE $ "000008/000026"
					dbSelectArea("SZ2")
					dbSetOrder(1)
					If dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD + SD2->D2_PROCLI+"1")
						dDataRef := SZ2->Z2_DTREF01
						nValor   := SZ2->Z2_PRECO01
						For Z := 2 to 12
							If &("SZ2->Z2_DTREF"+StrZero(Z,2)) >= dDataRef
								dDataRef := &("SZ2->Z2_DTREF"+StrZero(Z,2))
								nValor   := &("SZ2->Z2_PRECO"+StrZero(Z,2))
							Endif
						Next Z

		//				If SD2->D2_CLIENTE == "000008" .And. Substr(SZ2->Z2_PEDCLI,1,4) $ "QAPC/QAPP/QHPP"
						If SD2->D2_CLIENTE == "000008" .And. Substr(SD2->D2_PEDCLI,1,4) $ "QAPC/QAPP/QHPP"
							_nTotDif += (SD2->D2_QUANT * nValor)
						ElseIf SD2->D2_CLIENTE == "000026" .And. SD2->D2_LOJA == "02" // Alterado Conforme Silvana 270406
							_nTotDif += (SD2->D2_QUANT * nValor)
						Else
						    _nTotDif += SD2->D2_TOTAL     						
						Endif
			        Else
					    _nTotDif += SD2->D2_TOTAL     									        
			        Endif                                                   
				Else
				    _nTotDif += SD2->D2_TOTAL     						
				Endif	
                
			    nTOTAL  += SD2->D2_TOTAL
				nVALICM += SD2->D2_VALICM
				nVALIPI += SD2->D2_VALIPI
			Endif
			
			dbSelectArea("SD2")
			dbSkip()
		EndDo
		
		dbSelectArea("SF2")
		
		If lAvalTes .And. MV_PAR14 == 1
			nTOTAL   += SF2->F2_FRETE+SF2->F2_SEGURO+SF2->F2_DESPESA
			_nTotDif += SF2->F2_FRETE+SF2->F2_SEGURO+SF2->F2_DESPESA
		Endif
		
		If nTOTAL > 0
			dbSelectArea(cNomArq)
			If dbSeek(SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
				RecLock(cNomArq,.F.)
			Else
				RecLock(cNomArq,.T.)
				Replace TB_CLI     With SF2->F2_CLIENTE
				Replace TB_LOJA    With SF2->F2_LOJA
			EndIF
			Replace TB_EST     With SA1->A1_EST
			Replace TB_EMISSAO With SF2->F2_EMISSAO
			
			nTB_VALOR2 := IIF(SF2->F2_TIPO == "P",0,nTOTAL)
			nTB_VALOR7 := IIF(SF2->F2_TIPO == "P",0,_nTOTDIF)
			nTB_VALOR1 := nTOTAL-nVALICM
			nTB_VALOR3 := IIF(SF2->F2_TIPO == "P",0,nTOTAL)+ nVALIPI+SF2->F2_ICMSRET+SF2->F2_FRETAUT
			
			Replace TB_VALOR1  With TB_VALOR1+ nTB_VALOR1
			Replace TB_VALOR2  With TB_VALOR2+ nTB_VALOR2
			Replace TB_VALOR3  With TB_VALOR3+ nTB_VALOR3
			Replace TB_VALOR7  With TB_VALOR7+ nTB_VALOR7			

			If Ascan( aCodCli, SF2->F2_CLIENTE+SF2->F2_LOJA ) == 0
				Aadd( aCodCli, SF2->F2_CLIENTE+SF2->F2_LOJA )
			Endif
			
			MsUnlock()
			
			If mv_par09 == 3
				GravaDev(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,nMoeda,cEstoq,cDupli)
			Endif
		Endif
		
	Endif
	
	dbSelectArea("SF2")
	dbSkip()
EndDo

Return .T.

Static FuncTion GeraTrab1(cEstoq,cDupli,nMoeda)

Local nTOTAL     := 0
Local nVALICM    := 0
Local nVALIPI    := 0
Local nImpNoInc  := 0
Local nImpInc    := 0
Local nTB_VALOR4 := 0
Local nTB_VALOR5 := 0
Local nTB_VALOR6 := 0
Local nY         := 0
Local aImpostos	 := {}
Local lAvalTes   := .F.
Local DtMoedaDev := SF1->F1_DTDIGIT

dbSeek(xFilial("SF1")+mv_par03,.T.)

While !Eof() .And.  F1_FORNECE <= mv_par04
	
	IncRegua()
	
	If SF1->F1_TIPO != "D"
		Dbskip()
		Loop
	Endif
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek( xFilial("SA1") + SF1->F1_FORNECE + SF1->F1_LOJA)
	dbSelectArea("SF1")
	
	If SF1->F1_DTDIGIT  < mv_par01 .Or. SF1->F1_DTDIGIT > mv_par02 .Or.;
		SA1->A1_EST     < mv_par05 .Or. SA1->A1_EST     > mv_par06
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("SD1")
	dbSetOrder(1)
	dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
	nTOTAL 		:=0.00
	nVALICM		:=0.00
	nVALIPI		:=0.00
	nImpNoInc	:=0.00
	nImpInc 	:=0.00
	lAvalTes    := .F.
	
	dbSelectArea("SF4")
	dbSeek(xFilial("SF4")+SD1->D1_TES)
	dbSelectArea("SD1")
	
	While !Eof() .and. xFilial("SD1")==SD1->D1_FILIAL .And.;
		SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA ==;
		SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
		
		If SD1->D1_TIPO != "D"
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SF4")
		dbSeek(xFilial("SF4")+SD1->D1_TES)
		dbSelectArea("SD1")
		
		If AvalTes(D1_TES,cEstoq,cDupli)
			
			dbSelectArea("SD1")
			
			lAvalTes := .T.
			
			nTotSD1 := SD1->D1_TOTAL-SD1->D1_VALDESC
			
			nTOTAL  +=nTotSD1
			
			nVALICM += SD1->D1_VALICM
			nVALIPI += SD1->D1_VALIPI
		Endif
		
		dbSelectArea("SD1")
		dbSkip()
	EndDo
	
	dbSelectArea("SF1")
	
	If lAvalTes .And. MV_PAR14 == 1
		nTOTAL  += SF1->F1_FRETE + SF1->F1_SEGURO + SF1->F1_DESPESA
	Endif
	
	If nTOTAL > 0
		dbSelectArea(cNomArq)
		If dbSeek(SF1->F1_FORNECE+SF1->F1_LOJA,.F.)
			RecLock(cNomArq,.F.)
		Else
			RecLock(cNomArq,.T.)
			Replace TB_CLI     With SF1->F1_FORNECE
			Replace TB_LOJA	   With SF1->F1_LOJA
		EndIf
		Replace TB_EST     With SA1->A1_EST
		Replace TB_EMISSAO With SF1->F1_EMISSAO
		
		nTB_VALOR5 := nTOTAL
		
		nTB_VALOR4 := nTOTAL-nVALICM
		nTB_VALOR6 := nTOTAL+nVALIPI+SF1->F1_ICMSRET
		
		Replace TB_VALOR4  With TB_VALOR4+nTB_VALOR4
		Replace TB_VALOR5  With TB_VALOR5+nTB_VALOR5
		Replace TB_VALOR6  With TB_VALOR6+nTB_VALOR6
	Endif
	
	dbSelectArea("SF1")
	dbSkip()	
Enddo

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GravaDev  ³Revisor³Alexandre Inacio Lemes ³ Data ³ 27/11/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Grava item da devolucao ref a nota fiscal posicionada.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GravaDev                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static FuncTion GravaDev(cNumOri,cSerieOri,cClienteOri,cLojaOri,nMoeda,cEstoq,cDupli)
Local cNum        := ""
Local cSerie      := ""
Local cFornece    := ""
Local cLoja       := ""
Local cNumDocNfe  := ""
Local nX          := 0
Local nTOTAL      := 0
Local nVALICM     := 0
Local nVALIPI     := 0
Local nImpNoInc   := 0
Local nImpInc     := 0
Local nTB_VALOR4  := 0
Local nTB_VALOR5  := 0
Local nTB_VALOR6  := 0
Local nY          := 0
Local aImpostos   := {}
Local aNotDev     := {}
Local lAvalTes    := .F.
Local DtMoedaDev  := SF2->F2_EMISSAO

dbSelectArea("SD1")
dbSetOrder(nIndex+1)
If dbseek(xFilial("SD1")+cSerieOri+cNumOri+cClienteOri+cLojaOri,.F.)
	
	cNumDocNfe := SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
	
	Aadd( aNotDev, cNumDocNfe )
	
	Do While !Eof() .And. xFilial("SD1")==SD1->D1_FILIAL .And. cSerieOri+cNumOri+cClienteOri+cLojaOri;
		== SD1->D1_SERIORI+SD1->D1_NFORI+SD1->D1_FORNECE+SD1->D1_LOJA
		
		If cNumDocNfe <> SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
			If Ascan( aCodCli, SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA) == 0
				Aadd( aNotDev, SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
				cNumDocNfe := SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
			Endif
		Endif
		
		dbSelectArea("SD1")
		dbSkip()
	Enddo
	
	dbSelectArea("SD1")
	dbSetOrder(nIndex+1)
	dbseek(xFilial("SD1")+cSerieOri+cNumOri+cClienteOri+cLojaOri,.F.)
	
	For nX :=1 to Len(aNotDev)
		
		dbSelectArea("SD1")
		cNum		:=D1_DOC
		cSerie	    :=D1_SERIE
		cFornece	:=D1_FORNECE
		cLoja		:=D1_LOJA
		
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek( xFilial("SA1") + cFornece + cLoja)
		dbSelectArea("SF1")
		dbSetOrder(1)
		
		If dbSeek(aNotDev[nX])
			
			dbSelectArea("SD1")
			dbSetOrder(1)
			dbSeek(aNotDev[nX])
			
			dbSelectArea("SF1")
			dbSetOrder(1)
			If SF1->F1_DTDIGIT < mv_par01 .Or. SF1->F1_DTDIGIT > mv_par02 .Or.;
				SA1->A1_EST < mv_par05 .Or. SA1->A1_EST > mv_par06 .Or. SF1->F1_TIPO != "D"
				SD1->(dbSkip())
				Loop
			EndIf
			
			nTOTAL 		:=0.00
			nVALICM		:=0.00
			nVALIPI		:=0.00
			nImpNoInc	:=0.00
			nImpInc 	:=0.00
			lAvalTes    := .F.
			
			DtMoedaDev  := IIF(MV_PAR13 == 1,SF1->F1_DTDIGIT,SF2->F2_EMISSAO)
			
			dbSelectArea("SF4")
			dbSeek(xFilial("SF4")+SD1->D1_TES)
			dbSelectArea("SD1")
			
			While !Eof() .and. xFilial("SD1")==SD1->D1_FILIAL .And.SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA ==SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
				
				If SD1->D1_TIPO != "D"
					dbSkip()
					Loop
				Endif
				
				dbSelectArea("SF4")
				dbSeek(xFilial("SF4")+SD1->D1_TES)
				
				If AvalTes(SD1->D1_TES,cEstoq,cDupli) .and. cSerieOri+cNumOri == SD1->D1_SERIORI+SD1->D1_NFORI
					
					lAvalTes := .T.
					
					dbSelectArea(cNomArq)
										
					nTotSD1 := SD1->D1_TOTAL-SD1->D1_VALDESC
					nTOTAL  += nTotSD1
					nVALICM += SD1->D1_VALICM
					nVALIPI += SD1->D1_VALIPI
				Endif
				
				dbSelectArea("SD1")
				dbSkip()
			EndDo
			
			dbSelectArea("SF1")
			If lAvalTes .And. MV_PAR14 == 1
				nTOTAL  += SF1->F1_FRETE+SF1->F1_SEGURO+SF1->F1_DESPESA
			Endif
			
			If nTOTAL > 0
				dbSelectArea(cNomArq)
				If dbSeek(SF1->F1_FORNECE+SF1->F1_LOJA,.F.)
					RecLock(cNomArq,.F.)
				Else
					RecLock(cNomArq,.T.)
					Replace TB_CLI     With SF1->F1_FORNECE
					Replace TB_LOJA	 With SF1->F1_LOJA
				EndIf
				
				Replace TB_EST     With SA1->A1_EST
				Replace TB_EMISSAO With DtMoedaDev
				
				nTB_VALOR5 := nTOTAL
				If ( cPaisLoc=="BRA" )
					nTB_VALOR4 := nTOTAL-nVALICM
					nTB_VALOR6 := nTOTAL+nVALIPI+SF1->F1_ICMSRET
				Else
					nTB_VALOR4 := nTOTAL-nImpInc
					nTB_VALOR6 := nTotal+nImpInc
				Endif
				
				Replace TB_VALOR4  With TB_VALOR4+nTB_VALOR4
				Replace TB_VALOR5  With TB_VALOR5+nTB_VALOR5
				Replace TB_VALOR6  With TB_VALOR6+nTB_VALOR6
			EndIf
		Endif
	Next nX
Endif

Return