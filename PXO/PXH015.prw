#include "Protheus.ch"
#include "TOPCONN.ch"

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Funá∆o    ≥  PXH015  ≥ Autor ≥ NILTON CESAR          ≥ Data ≥ 19.11.02 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descriá∆o ≥ Arquivo de Resumo  de CC                                   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ SIGAFIN - Menu atualizaá‰es                                ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function PXH015(_cDoc,_cSerie,_cFornece,_cLoja, nMovmnto)

Local aMiz871    := GetArea()
Local aSF1       := {'SF1',SF1->(INDEXORD()),SF1->(RECNO())}
Local lperg
/*
PXH15_01-fProcSD1

*/

If cEmpAnt == "16"
	U_PXH071(_cDoc,_cSerie,_cFornece,_cLoja, nMovmnto)
	Return
Endif

Private dta_ini  := dta_fin := CTOD("")
Private cDoc     := ""
Private cSerie   := ""
Private cFornece := ""
Private cLoja    := ""
Private wRegs    := 0

Private _cVisao  := Alltrim(GetMv("PXH_VISAO2"))  // VISAO 002

Default nMovmnto :=0

If _cDoc == Nil
	lperg := Pergunte("PXH015",.T.)
	If lperg == .F.
		Return
	EndIf
	dta_ini  := mv_par01
	dta_fin  := mv_par02
	cDoc     := ""
	nMovmnto :=mv_par03
Else
	cDoc     := _cDoc
	cSerie   := _cSerie
	cFornece := _cFornece
	cLoja    := _cLoja
EndIf

Processa( {|| flimpa(nMovmnto) } , "Aguarde!", "Organizando arquivos...")

If nMovmnto ==1 .Or. nMovmnto ==5   //Compra / Venda ou Todos
	
	If Empty( cDoc )
		Processa( {|| PXH15_01() } ,"Aguarde!", "Proc.Compras / Vendas...")
	Else
		PXH15_01()
	Endif
	
Endif

If nMovmnto ==2 .Or. nMovmnto ==5   //saida ou todos
	
	IF Empty( cDoc )
		Processa( {|| fprocSD3() } , "Aguarde!", "Processando REQUISICOES...")
	ELSE
		fprocSD3()
	ENDIF
	
Endif

If nMovmnto ==3 .Or. nMovmnto ==5   //folha ou todos
	//If cFilAnt == "01"
	IF Empty( cDoc )
		Processa( {|| fProcFOL() } , "Aguarde!", "Processando FOLHA PAGTO/EXTRAS/RATEIO...")
	ELSE
		fProcFOL()
	ENDIF
	//EndIf
Endif

If ( Empty(cDoc) ) .And. (nMovmnto ==4 .or. nMovmnto ==5)
	Processa( {|| U_fprocSE5() } , "Aguarde!", "Processando MOV.BANCARIA...")
EndIf

If Empty(cDoc)
	Processa( {|| PXH15A() } , "Aguarde!", "Atualizando VISAO Gerencial...") // VERIFICA A VISAO GERENCIAL
Else
	PXH15A()
Endif

If Empty(cDoc)
	Alert("Processamento encerrado")
EndIf

RestArea(aMiz871)
dbSelectArea(aSF1[1])
dbSetOrder(aSF1[2])
dbgoto(aSF1[3])

Return
*-----------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Funá∆o    ≥flimpa    ≥ Autor ≥ NILTON CESAR          ≥ Data ≥ 19.11.02 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descriá∆o ≥ Arquivo de Resumo  de CC                                   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ SIGAFIN - Menu atualizaá‰es                                ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function flimpa(WORIGEM)

cORIGEM:= IIF( worigem == 1 ,"SD1", IIF( worigem == 2 , "SD3" , IIF( worigem == 3 , "FOL" , IIF( worigem == 4 , "SE5", "ALL" ) ) ) )

DbSelectArea("SZQ")
ProcRegua(RecCount())
If Empty(cDoc)
	DbSetOrder(4)
	
	DbSeek(xFilial("SZQ")+cEmpAnt+cFilAnt+Dtos(dta_ini),.t.)
	Do while .not. eof() .and. SZQ->ZQ_FILIAL == xFilial("SZQ") ;
		.and. SZQ->ZQ_CODEMP == cEmpAnt+Left(cFilAnt,3);
		.and. SZQ->ZQ_CODFIL == Right(cFilAnt,2) ;
		.and. SZQ->ZQ_DTDIGIT <= dta_fin
		
		IncProc("Limpando  - Data: "+Dtoc(ZQ_DTDIGIT))
		
		IF SZQ->ZQ_ORIG $ 'XXX*INC'
			SZQ->(DbSkip())
			LOOP
		ENDIF
		IF ( SZQ->ZQ_ORIG == cORIGEM ).OR. cORIGEM == 'ALL'
			nRec := SZQ->(Recno())
			szq->(Reclock("SZQ",.F.))
			Delete
			szq->(MsUnlock())
		ENDIF
		SZQ->(DbSkip())
	EndDo
Else
	DbSetOrder(6)
	DbSeek(xFilial("SZQ")+cEmpAnt+cFilAnt+cSerie+cDoc+cFornece+cLoja)
	While ! eof()  .and. SZQ->ZQ_FILIAL == xFilial("SZQ") ;
		.and. SZQ->ZQ_CODEMP == cEmpAnt+Left(cFilAnt,3);
		.and. SZQ->ZQ_CODFIL == Right(cFilAnt,2);
		.and. cSerie+cDoc+cFornece+cLoja == SZQ->(ZQ_PREFIXO+ZQ_NUM+ZQ_FORNECE+ZQ_LOJA)
		IncProc("Limpando  - Documento: "+SZQ->ZQ_PREFIXO+" "+SZQ->ZQ_NUM+" "+SZQ->ZQ_FORNECE+" "+SZQ->ZQ_LOJA)
		
		IF SZQ->ZQ_ORIG $ 'XXX*INC'
			SZQ->(DbSkip())
			LOOP
		ENDIF
		nRec := SZQ->(Recno())
		szq->(Reclock("SZQ",.F.))
		Delete
		szq->(MsUnlock())
		
		SZQ->(DbSkip())
	End
EndIf
Return
*-----------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Funá∆o    ≥PXH15_01  ≥ Autor ≥ NILTON CESAR          ≥ Data ≥ 19.11.02 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descriá∆o ≥ Arquivo de Resumo  de CC                                   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ SIGAFIN - Menu atualizaá‰es                                ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

Static Function PXH15_01()

local wArea:= getArea()
Private dbaixa := ctod(space(8))
Private wNat	 := ""
Private wFilial

DbSelectArea("SD1")
ProcRegua(RecCount())

If Empty(cDoc)
	
	DbSetOrder(6)
	DbSeek(xFilial("SD1")+Dtos(dta_ini),.t.)
	wFilial := xFilial("SD1")
	
	While SD1->(!Eof()) .And. SD1->D1_FILIAL == wFilial .And. SD1->D1_DTDIGIT <= dta_fin
		dbaixa := ctod(space(8))
		IncProc("NF entrada - Data: "+Dtoc(D1_DTDIGIT))
		DbSelectArea("SZQ")
		fGrava('SD1')
		DbSelectArea("SD1")
		SD1->(DbSkip())
	EndDo
Else
	DbSetOrder(1)
	DbSeek(xFilial("SD1")+padr(cDoc,9)+padr(cSerie,3)+cFornece+cLoja)
	While ! Eof() .and. xFilial("SD1")+padr(cDoc,9)+padr(cSerie,3)+cFornece+cLoja == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
		dbaixa := ctod(space(8))
		IncProc("Documento: "+SZQ->ZQ_PREFIXO+" "+SZQ->ZQ_NUM+" "+SZQ->ZQ_FORNECE+" "+SZQ->ZQ_LOJA)
		DbSelectArea("SZQ")
		fGrava('SD1')
		DbSelectArea("SD1")
		SD1->(DbSkip())
	End
EndIf

RestArea(wArea)

Return
*-----------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Funá∆o    ≥fprocSE2  ≥ Autor ≥ NILTON CESAR          ≥ Data ≥ 19.11.02 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descriá∆o ≥ Arquivo de Resumo  de CC                                   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ SIGAFIN - Menu atualizaá‰es                                ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function fprocSE2()

Local cQuery

cQuery:= " SELECT E2_YCC,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_NATUREZ,E2_FORNECE, "
cQuery+= " E2_LOJA,E2_EMISSAO,E2_VENCTO,E2_VENCREA,E2_BAIXA,E2_DESCONT,E2_MULTA, "
cQuery+= " E2_JUROS,E2_CORREC,E2_VALOR,E2_VALOR,E2_INSS,E2_IRRF "
cQuery+= " FROM "+RetSqlName('SE2')+" A WHERE A.D_E_L_E_T_ =  '' AND E2_ORIGEM NOT IN ('MATA100','MATA460','GPEM670') "

If Select('TRB')>0
	TRB->(dbCloseArea())
Endif

TCQuery cQuery NEW ALIAS "TRB"

dbSelectArea("TRB")
TRB->(dbGoTop())
While !TRB->(EOF())
	IncProc("Titulo  - Data: "+Dtoc( STOD( TRB->E2_EMISSAO ) ))
	
	SZQ->(RecLock("SZQ",.T.))
	SZQ->ZQ_FILIAL   	:= xFilial("SZQ")
	SZQ->ZQ_YCC			:= TRB->E2_YCC
	SZQ->ZQ_PREFIXO		:= TRB->E2_PREFIXO
	SZQ->ZQ_NUM 		:= TRB->E2_NUM
	SZQ->ZQ_PARCELA   	:= TRB->E2_PARCELA
	SZQ->ZQ_TIPO      	:= TRB->E2_TIPO
	SZQ->ZQ_NATUREZ   	:= TRB->E2_NATUREZ
	SZQ->ZQ_NATSYS      := posicione('SED',1,xfilial('SED')+szq->zq_naturez,'ED_YCOD')
	SZQ->ZQ_FORNECE  	:= TRB->E2_FORNECE
	SZQ->ZQ_LOJA      	:= TRB->E2_LOJA
	SZQ->ZQ_EMISSAO  	:= STOD(TRB->E2_EMISSAO)
	SZQ->ZQ_DTDIGIT  	:= STOD(TRB->E2_EMISSAO)
	SZQ->ZQ_VENCTO      := STOD(TRB->E2_VENCTO)
	SZQ->ZQ_VENCREA    	:= STOD(TRB->E2_VENCREA)
	
	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2")+TRB->E2_FORNECE+TRB->E2_LOJA))
	
	SZQ->ZQ_NOME        := SA2->A2_NOME
	SZQ->ZQ_BAIXA      	:= STOD(TRB->E2_BAIXA)
	SZQ->ZQ_DESCONT     := TRB->E2_DESCONT
	SZQ->ZQ_MULTA     	:= TRB->E2_MULTA
	SZQ->ZQ_JUROS      	:= TRB->E2_JUROS
	SZQ->ZQ_CORREC     	:= TRB->E2_CORREC
	SZQ->ZQ_VALLIQ    	:= TRB->E2_VALOR
	SZQ->ZQ_VALIPI     	:= 0
	SZQ->ZQ_VALICM     	:= 0
	SZQ->ZQ_RATEIO	    := 0
	SZQ->ZQ_TOTAL		:= TRB->E2_VALOR
	SZQ->ZQ_CUSCTB		:= TRB->E2_VALOR
	SZQ->ZQ_INSS    	:= TRB->E2_INSS
	SZQ->ZQ_IRRF   		:= TRB->E2_IRRF
	SZQ->ZQ_CLIENTE     := ""
	SZQ->ZQ_QUANT       := 0
	SZQ->ZQ_PRODUTO    	:= ""
	SZQ->ZQ_ORIG        := "SE2"
	SZQ->ZQ_DESCORI	    := "PAGAR"
	
	SM0->(dbSetOrder(1))
	SM0->(dbSeek(cEmpAnt+cFilAnt))
	
	SZQ->ZQ_CODEMP	:= cEmpAnt+Left(cFilAnt,3)	//Codg Empresa
	SZQ->ZQ_CODFIL	:= Right(cFilAnt,2) //Codg Filial
	SZQ->ZQ_NOMEMP	:= ALLTRIM(SM0->M0_FILIAL) //Nome Empresa
	SZQ->ZQ_NOMFIL	:= SM0->M0_FILIAL //Nome Filial
	
	CTT->(dbSetOrder(1))
	CTT->(dbSeek(xFilial("CTT")+SZQ->ZQ_YCC))
	/*
	DbSelectArea("SZQ")
	SZQ->ZQ_YGRCC		:= CTT->CTT_YGRCC	//Grupo CCusto
	SZQ->ZQ_YSBCC		:= CTT->CTT_YSBCC	//Sb Grupo CC
	SZQ->ZQ_YITCC		:= CTT->CTT_YITCC	//Sb Gr It CC
	SZQ->ZQ_YDESP		:= CTT->CTT_YDESP	//Despesa
	SZQ->ZQ_YGRDE		:= CTT->CTT_YGRDE	//Grupo Desp
	SZQ->ZQ_YSBDE		:= CTT->CTT_YSBDE	//Sb Gr Desp
	SZQ->ZQ_YITDE		:= CTT->CTT_YITDE	//Sb Item Desp
	*/
	SZQ->ZQ_DCUSTO		:= CTT->CTT_DESC01//DescriÁ„o do CENTRO DE CUSTO
	SZQ->ZQ_DITEMC		:= Posicione("CTD",1,xFilial("CTD")+SZQ->ZQ_ITEMCTA,"CTD_DESC01")//DescriÁ„o do ITEM CONT¡BIL
	SZQ->ZQ_DCLASSV	    := Posicione("CTH",1,xFilial("CTH")+SZQ->ZQ_CLVL   ,"CTH_DESC01")//DescriÁ„o da CLASSE DE VALOR
	SZQ->ZQ_DCONTA 	    := Posicione("CT1",1,xFilial("CT1")+SZQ->ZQ_CONTA  ,"CT1_DESC01")//DescriÁ„o do CONTA CONT¡BIL
	SZQ->(MsUnlock())
	
	TRB->(DbSkip())
EndDo

Return
*-----------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Funá∆o    ≥fprocSE5  ≥ Autor ≥ NILTON CESAR          ≥ Data ≥ 19.11.02 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descriá∆o ≥ Arquivo de Resumo  de CC                                   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ SIGAFIN - Menu atualizaá‰es                                ≥±±
±±≥------------------------ ALTERADO POR SERGIO EM 22-08-06 -----------------------------------
±±≥ Alterado para possibilitar chamada apartir do P.Entrada FA100PAG e FA100REC na rotina de movimento bancario
±±≥Parametros:
±±≥ wOrigem: nome da funcao ou ponto de entrada indicando se È - ( receber ou pagar )
±±≥ Pontos de Entrada envolvidos:
±±≥ FA100REC / FA100PAG / SE5FI080 / SACI008 / FA080CAN / FA070CAN
±±≥
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function fprocSE5(wOrigem,wTpLancto)

Local wAlias := 'SE5'

//If xFilial("SZQ") != cFilAnt .and. Right(cFilAnt,2) <> "01"
//	Return()
//Endif

If wOrigem == Nil
	Processa( {|| fprocSQL() } , "Aguarde!", "Montando filtro  no SE5")
	wAlias := 'TRB'
Endif

dbSelectArea(wAlias)
If ! (wAlias)->(Eof()) .And. !  (wAlias)->(Bof())
	ProcRegua(IIf(wAlias=='TRB',wregs,1))
	While !  (wAlias)->(Eof())
		
		IncProc()
		If  wAlias=='TRB'
			IncProc("Financeiro - Data: "+dtoc(stod( (wAlias)->E5_DATA)))
		Endif
		
		SED->(dbSetorder(1))
		SED->(dbSeek(xFilial("SED")+(wAlias)->E5_NATUREZ))
		
		If (wAlias)->E5_VALOR == 13.15
			_lparar := .T.
		Endif
		
		dbSelectArea("SZQ")
		Reclock("SZQ",.T.)
		SZQ->ZQ_FILIAL    := xFilial("SZQ")
		SZQ->ZQ_PREFIXO	  :=  (wAlias)->E5_PREFIXO
		SZQ->ZQ_NUM 	  :=  (wAlias)->E5_NUMERO
		SZQ->ZQ_PARCELA   :=  (wAlias)->E5_PARCELA
		SZQ->ZQ_TIPO      :=  (wAlias)->E5_TIPO
		SZQ->ZQ_NATUREZ   :=  (wAlias)->E5_NATUREZ
		SZQ->ZQ_NATSYS    := posicione('SED',1,xfilial('SED')+szq->zq_naturez,'ED_YCOD')
		SZQ->ZQ_FORNECE	  :=  (wAlias)->E5_CLIFOR
		SZQ->ZQ_LOJA      :=  (wAlias)->E5_LOJA
		SZQ->ZQ_DESCORI   := "MOV BCO"
		wData:=IIf(wAlias=='TRB',stod( (wAlias)->E5_DATA), (wAlias)->E5_DATA)
		
		SZQ->ZQ_EMISSAO 	:= wData
		SZQ->ZQ_ANOMES		:= SubStr( IIf(wAlias=='TRB', DToS(wData), dtos((wAlias)->E5_DATA)),1,6  )
		SZQ->ZQ_DTDIGIT	    := wData
		SZQ->ZQ_VENCTO  	:= wData
		SZQ->ZQ_VENCREA 	:= wData
		IF (wAlias)->E5_RECPAG == 'P'
			SA2->(dbSetorder(1))
			SA2->(dbSeek(xFilial("SA2")+(wAlias)->E5_CLIFOR+(wAlias)->E5_LOJA))
			
			SZQ->ZQ_NOME    := IIF( !EMPTY((wAlias)->E5_CLIFOR) ,POSICIONE('SA2',1,XFILIAL('SA2')+(wAlias)->E5_CLIFOR+(wAlias)->E5_LOJA,"A2_NOME"),   (wAlias)->E5_BENEF )
		ELSE
			SA1->(dbSetorder(1))
			SA1->(dbSeek(xFilial("SA1")+(wAlias)->E5_CLIFOR+(wAlias)->E5_LOJA))
			
			SZQ->ZQ_NOME    :=   IIF( !EMPTY((wAlias)->E5_CLIFOR) ,POSICIONE('SA1',1,XFILIAL('SA1')+(wAlias)->E5_CLIFOR+(wAlias)->E5_LOJA,"A1_NOME"),   (wAlias)->E5_BENEF )
		ENDIF
		SZQ->ZQ_BAIXA   	:= wData
		SZQ->ZQ_DESCONT 	:=  (wAlias)->E5_VLDESCO
		SZQ->ZQ_MULTA       :=  (wAlias)->E5_VLMULTA
		SZQ->ZQ_JUROS       :=  (wAlias)->E5_VLJUROS
		SZQ->ZQ_CORREC      :=  (wAlias)->E5_VLCORREC
		SZQ->ZQ_VALIPI      := 0
		SZQ->ZQ_VALICM      := 0
		SZQ->ZQ_RATEIO	    := 0
		SZQ->ZQ_INSS    	:= 0
		SZQ->ZQ_IRRF   	    := 0
		SZQ->ZQ_CLIENTE     := ""
		SZQ->ZQ_QUANT       := 0
		SZQ->ZQ_PRODUTO 	:= ""
		SZQ->ZQ_YCC		 	:=  (wAlias)->E5_YCC
		
		DO CASE
			CASE wORIGEM == 'BXCP'  // BAIXA DO CONTAS A PAGAR
				IF  wTpLancto == 'DESPESA'
					SZQ->ZQ_YCC	    :=  IIF( (wAlias)->E5_TIPODOC ==  'JR' ,GetMV('MV_CCJRCP'),GetMV('MV_CCMTCP') )
					SZQ->ZQ_VALLIQ  :=  (wAlias)->E5_VALOR
					SZQ->ZQ_TOTAL	:=  (wAlias)->E5_VALOR
					SZQ->ZQ_CUSCTB	:= (wAlias)->E5_VALOR
				ELSE
					SZQ->ZQ_YCC		:=  GetMV('MV_CCDCCP')
					SZQ->ZQ_VALLIQ  :=  (wAlias)->E5_VALOR * -1
					SZQ->ZQ_TOTAL	:= (wAlias)->E5_VALOR * -1
					SZQ->ZQ_CUSCTB	:= (wAlias)->E5_VALOR * -1
				ENDIF
			CASE wORIGEM == 'BXCR'  // BAIXA DO CONTAS A RECEBER
				IF wTpLancto == 'RECEITA'
					SZQ->ZQ_YCC		:= IIF( (wAlias)->E5_TIPODOC ==  'JR' ,GetMV('MV_CCJRCR'),GetMV('MV_CCMTCR') )
					SZQ->ZQ_VALLIQ  := (wAlias)->E5_VALOR
					SZQ->ZQ_TOTAL	:= (wAlias)->E5_VALOR
					SZQ->ZQ_CUSCTB	:= (wAlias)->E5_VALOR
				ELSE
					SZQ->ZQ_YCC		:= GetMV('MV_CCDCCR')
					SZQ->ZQ_VALLIQ  := (wAlias)->E5_VALOR * -1
					SZQ->ZQ_TOTAL	:= (wAlias)->E5_VALOR * -1
					SZQ->ZQ_CUSCTB	:= (wAlias)->E5_VALOR * -1
				ENDIF
			CASE wORIGEM == 'MVBCOR'  // MOVIMENTACAO BANCARIA RECEBER
				SZQ->ZQ_VALLIQ  := IIF( wTpLancto == 'RECEITA'  , (wAlias)->E5_VALOR, (wAlias)->E5_VALOR * -1 )
				SZQ->ZQ_TOTAL	:= IIF( wTpLancto == 'RECEITA'  , (wAlias)->E5_VALOR, (wAlias)->E5_VALOR * -1 )
				SZQ->ZQ_CUSCTB	:= IIF( wTpLancto == 'RECEITA'  , (wAlias)->E5_VALOR, (wAlias)->E5_VALOR * -1 )
			CASE wORIGEM == 'MVBCOP'  // MOVIMENTACAO BANCARIA PAGAR
				SZQ->ZQ_VALLIQ  := IIF( wTpLancto == 'DESPESA'  , (wAlias)->E5_VALOR, (wAlias)->E5_VALOR * -1 )
				SZQ->ZQ_TOTAL	:= IIF( wTpLancto == 'DESPESA'  , (wAlias)->E5_VALOR, (wAlias)->E5_VALOR * -1 )
				SZQ->ZQ_CUSCTB	:= IIF( wTpLancto == 'DESPESA'  , (wAlias)->E5_VALOR, (wAlias)->E5_VALOR * -1 )
			OTHERWISE
				SZQ->ZQ_VALLIQ  := (wAlias)->E5_VALOR
				SZQ->ZQ_TOTAL	:= (wAlias)->E5_VALOR
				SZQ->ZQ_CUSCTB	:= (wAlias)->E5_VALOR
		ENDCASE
		
		SM0->(dbSetOrder(1))
		SM0->(dbSeek(cEmpAnt+cFilAnt))
		DbSelectArea("SZQ")
		SZQ->ZQ_CODEMP	:= cEmpAnt+Left(cFilAnt,3)	//Codg Empresa
		SZQ->ZQ_CODFIL	:= Right(cFilAnt,2)		//Codg Filial
		//SZQ->ZQ_NOMEMP:= ALLTRIM(SM0->M0_NOME) //Nome Empresa
		SZQ->ZQ_NOMEMP	:= ALLTRIM(SM0->M0_FILIAL) //Nome Empresa
		SZQ->ZQ_NOMFIL	:= SM0->M0_FILIAL //Nome Filial
		
		CTT->(dbSetOrder(1)) //CTT_FILIAL+CTT_CUSTO
		CTT->(dbSeek(xFilial("CTT")+SZQ->ZQ_YCC))
		DbSelectArea("SZQ")
		/*
		SZ1->(dbSetOrder(2))
		If SZ1->(dbSeek(xFilial("SZ1")+ (wAlias)->E5_NATUREZ + cEmpAnt + cFilAnt))
		SZQ->ZQ_CONTA		:= SZ1->Z1_CONTA
		Endif
		*/
		SZQ->ZQ_CONTA		:= fContaCtb(wAlias)
		
		SZQ->ZQ_DCUSTO		:= CTT->CTT_DESC01//DescriÁ„o do CENTRO DE CUSTO
		SZQ->ZQ_DITEMC		:= Posicione("CTD",1,xFilial("CTD")+SZQ->ZQ_ITEMCTA,"CTD_DESC01")//DescriÁ„o do ITEM CONT¡BIL
		SZQ->ZQ_DCLASSV	    := Posicione("CTH",1,xFilial("CTH")+SZQ->ZQ_CLVL,"CTH_DESC01")//DescriÁ„o da CLASSE DE VALOR
		SZQ->ZQ_DCONTA 	    := Posicione("CT1",1,xFilial("CT1")+SZQ->ZQ_CONTA ,"CT1_DESC01")//DescriÁ„o do CONTA CONT¡BIL
		IF wAlias=='SE5'
			SZQ->ZQ_ORIG        :=  "SE5"
		ELSE
			SZQ->ZQ_ORIG        :=  IIF(  (wAlias)->ESTORNO == -1, "SE2", "SE5")
		ENDIF
		
		SZQ->ZQ_OBS := (wAlias)->E5_HISTOR
		
		SZQ->(MsUnlock())
		DbSelectArea( (wAlias))
		(wAlias)->(DbSkip())
		
		If wAlias=='SE5' ; Exit ; Endif
	End
EndIf

Return

STATIC FUNCTION fContaCtb(wAlias)

local warea:= getArea()
Local cCodCtb := ""
Local cLC520002 := '520003'//LANCAMENTO PADR√O DE BAIXAS A RECEBER DESCONTO CONCEDIDO (DEBITO)
Local cLC520003 := '520004'//LANCAMENTO PADR√O DE BAIXAS A RECEBER MULTA OBTIDAS (CREDITO)
Local cLC520004 := '520004'//LANCAMENTO PADR√O DE BAIXAS A RECEBER JUROS OBTIDOS (CREDITO)
Local cLC530003 := '530003'//LANCAMENTO PADR√O DE BAIXAS A PAGAR JUROS E MULTA (DEBITO)
Local cLC530005 := '530005'//LANCAMENTO PADR√O DE BAIXAS A PAGAR DESCONTO OBTIDOS (CREDITO)
Local cLC562001 := '562001'//DESPESAS BANCARIAS - PAGAR (DEBITO)
Local cLC563001 := '563001'//DESPESAS BANCARIAS - RECEBER (CREDITO)
Local cLC501001 := '501001'//RECEBIMENTO ANTECIPADO - CREDITO
Local cLC513001 := '513001'//PAGAMENTO ANTECIPADO - DEBITO
local cErr:=''

_aAliSE5 := SE5->(GetArea())

SE5->(dbGoto((wAlias)->NUMRECNO))

IF 	(wAlias)->(Rtrim(E5_TIPO) == "PA" .AND. E5_RECPAG == "P")	//PAGAMENTO ANTECIPADO
	cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC513001,"CT5_DEBITO")
	cCodCtb := IIF(EMPTY(cCodCtb), "11230001"  ,cCodCtb)
	cErr:='err'+cLC513001
ELSEIF (wAlias)->(Rtrim(E5_TIPO) == "RA" .AND. E5_RECPAG == "R")	//RECEBIMENTO ANTECIPADO
	cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC501001,"CT5_CREDIT")
	cErr:='err'+cLC501001
ELSEIF (wAlias)->(Rtrim(E5_TIPODOC) == "JR" .AND. E5_RECPAG == "R") //CONTA CONTABIL DE JUROS OBTIDOS
	cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC520004,"CT5_CREDIT")
	cErr:='err'+cLC520004
ELSEIF (wAlias)->(Rtrim(E5_TIPODOC) == "JR" .AND. E5_RECPAG == "P") //CONTA CONTABIL DE JUROS PAGOS
	cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC530003,"CT5_DEBITO")
	cErr:='err'+cLC530003
ELSEIF (wAlias)->(Rtrim(E5_TIPODOC) == "MT" .AND. E5_RECPAG == "P") //CONTA CONTABIL DE MULTAS PAGAS
	cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC530003,"CT5_DEBITO")
	cErr:='err'+cLC530003
ELSEIF (wAlias)->(Rtrim(E5_TIPODOC) == "MT" .AND. E5_RECPAG == "R") //CONTA CONTABIL DE MULTAS OBTIDAS
	cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC520003,"CT5_CREDIT")
	cErr:='err'+cLC520003
ELSEIF (wAlias)->(Rtrim(E5_TIPODOC) == "DC" .AND. E5_RECPAG == "P") //CONTA CONTABIL DE DESCONTOS OBTIDOS
	cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC530005,"CT5_CREDIT")
	cErr:='err'+cLC530005
ELSEIF (wAlias)->(Rtrim(E5_TIPODOC) == "DC" .AND. E5_RECPAG == "R") //CONTA CONTABIL DE DESCONTOS CONCEDIDOS
	cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC520002,"CT5_DEBITO")
	cErr:='err'+cLC520002
ELSEIF (wAlias)->E5_RECPAG == "R" .AND. (Rtrim((wAlias)->E5_NATUREZ) $ GetMV('MV_SZQNAT1') .OR. Rtrim((wAlias)->E5_NATUREZ) $ GetMV('MV_SZQNAT2') .OR. Rtrim((wAlias)->E5_NATUREZ) $ GetMV('MV_SZQNAT3'))
	cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC563001,"CT5_CREDIT")
	cErr:='err'+cLC563001
ELSEIF (wAlias)->E5_RECPAG == "P" .AND. (Rtrim((wAlias)->E5_NATUREZ) $ GetMV('MV_SZQNAT1') .OR. Rtrim((wAlias)->E5_NATUREZ) $ GetMV('MV_SZQNAT2'))	//CONTA CONTABIL DA CPMF PAGAS OU CONTA CONTABIL DA TARIFAS BANCARIAS PAGAS
	cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC562001,"CT5_DEBITO")
	cErr:='err'+cLC562001
ENDIF

IF !EMPTY(cCodCtb)  //.OR. !Posicione("CT1",1,xFilial("CT1")+alltrim(cCodCtb),"Found()")
	cCodCtb := &(cCodCtb)
else
	cCodCtb := cErr
ENDIF

do case
	case valtype(cCodCtb)=='N'
		cCodCtb:= alltrim( str(cCodCtb, TamSX3("CT1_CONTA")[1] ) )
	case valtype(cCodCtb)<>'C'
		cCodCbb:=''
endcase

RestArea(_aAliSE5)

restArea(wArea)

RETURN( cCodCtb )



*-----------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function fGrava(wOrigem)

Local _nPos, aDescOri := {{"SD1","COMPRAS"},{"FOL","FOLHA"},{"RAT","RATEIOS"},{"EXT","EXTRAS"},{"SE2","RECEBER"},{"SE5","MOV BCO"},{"SD3","ESTOQUE"} }
local warea:= getarea()
Local cLC650001 := '650001'//COMPRAS

private cSigla:=''

IF wOrigem == "SD1"
	SF4->(dbSetOrder(1))
	SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
	
	SF1->(dbsetorder(1))
	SF1->(dbseek( xfilial('SF1')+ sd1->(d1_doc + d1_serie + d1_fornece + d1_loja ) ) )
ENDIF

wAlias    := wOrigem
wD3Emissao:= IIf(wOrigem=='SD1',(wAlias)->D1_EMISSAO, IIf( wOrigem=='FOL', (wAlias)->D3_EMISSAO,  (wAlias)->D3_EMISSAO ) )

cCodCtb := ""

dbSelectArea("SRV")
dbSelectArea(wAlias)

IF wOrigem=='SD1'
	cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC650001,"CT5_DEBITO")
	
	If !Empty(cCodCtb)
		cCodCtb := &(cCodCtb)
	Endif
Endif

SZQ->(Reclock("SZQ",.T.))
SZQ->ZQ_FILIAL   	:= xFilial("SZQ")	//Filial

IF wOrigem=='SD1'
	//SZQ->ZQ_CONTA	:= SD1->D1_CONTA
	SZQ->ZQ_CONTA	:= cCodCtb
	SZQ->ZQ_YCC		:= IIf( SF4->F4_DUPLIC=="S", SD1->D1_CC,	CriaVar("ZQ_YCC" ))		//C. Custo
ELSEIF wOrigem=='FOL'
	SZQ->ZQ_CONTA	:= (wAlias)->D3_CONTA 	//Conta Contabil
	SZQ->ZQ_YCC     := (wAlias)->D3_CC
ELSEIF wOrigem=='SD3'
	SZQ->ZQ_CONTA	:= (wAlias)->( IIF( D3_TM <= '499',Posicione("SB1",1,xFilial("SB1")+D3_COD,"B1_YCONTA"), D3_CONTA ) ) 	//Conta Contabil
	SZQ->ZQ_YCC     := (wAlias)->D3_CC
ELSE
	SZQ->ZQ_CONTA	:= (wAlias)->( IIF( D3_TM <= '499',Posicione("SB1",1,xFilial("SB1")+D3_COD,"B1_YCONTA"), D3_CONTA ) ) 	//Conta Contabil
	SZQ->ZQ_YCC     := (wAlias)->D3_CC
ENDIF

SZQ->ZQ_CLVL   	    := IIf(wOrigem=='SD1',	SD1->D1_CLVL		,	(wAlias)->D3_CLVL )	   		//Classe de Valor

If wOrigem=='SD1'
	SZQ->ZQ_ITEMCTA   := IIF(SF4->F4_DUPLIC=="S", SD1->D1_ITEMCTA, CriaVar("ZQ_ITEMCTA",.F.) )
Else
	SZQ->ZQ_ITEMCTA   := (wAlias)->D3_ITEMCTA
EndIf

SZQ->ZQ_DCUSTO		:= Posicione("CTT",1,xFilial("CTT")+SZQ->ZQ_YCC,"CTT_DESC01")//DescriÁ„o do CENTRO DE CUSTO
SZQ->ZQ_DITEMC		:= Posicione("CTD",1,xFilial("CTD")+SZQ->ZQ_ITEMCTA,"CTD_DESC01")//DescriÁ„o do ITEM CONT¡BIL
SZQ->ZQ_DCLASSV	    := Posicione("CTH",1,xFilial("CTH")+SZQ->ZQ_CLVL,"CTH_DESC01")//DescriÁ„o da CLASSE DE VALOR
SZQ->ZQ_DCONTA 	    := Posicione("CT1",1,xFilial("CT1")+SZQ->ZQ_CONTA ,"CT1_DESC01")//DescriÁ„o do CONTA CONT¡BIL
SZQ->ZQ_PREFIXO	    := IIf(wOrigem=='SD1',	SD1->D1_SERIE		, 	"" )		//Prefixo
SZQ->ZQ_NUM 		:= IIf(wOrigem=='SD1',	SD1->D1_DOC			, 	(wAlias)->D3_DOC )			//Numero
SZQ->ZQ_PARCELA     := ""				//Parcela
SZQ->ZQ_TIPO        := IIf(wOrigem=='SD1',SD1->D1_TIPO,"")
SZQ->ZQ_FORNECE  	:= IIf(wOrigem=='SD1',	SD1->D1_FORNECE		, 	(wAlias)->D3_CC )		//Fornecedor
SZQ->ZQ_LOJA        := IIf(wOrigem=='SD1',	SD1->D1_LOJA		, 	"" )			//Loja
SZQ->ZQ_EMISSAO    	:= IIf(wOrigem=='SD1',	SD1->D1_EMISSAO		, 	wD3Emissao )		//Emissao
SZQ->ZQ_CONHEC  	:= IIf(wOrigem=='SD1',	SD1->D1_CONHEC		, 	"" )		//Dados do conhecimento de frete

IF SZQ->(FieldPos("ZQ_DESCORI")) > 0
	_nPos := aScan( aDescOri, { | x | Alltrim(x[1]) = Alltrim(wOrigem) } )
	SZQ->ZQ_DESCORI := IIF(_nPos > 0,aDescOri[ _nPos ][2],"N√O PREVISTO")
ENDIF

If wOrigem=='SD1'
	SZQ->ZQ_DESCRIC := SD1->D1_YDESPRO
Else
	SZQ->ZQ_DESCRIC := Posicione("SB1",1,xFilial("SB1")+(wAlias)->D3_COD , "B1_DESC" )
Endif

If wOrigem=='SD1'
	SA2->(DbSetOrder(1))					//A2_FILIAL+A2_COD+A2_LOJA
	SA2->(DbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA))
	SZQ->ZQ_NOME := SA2->A2_NOME
	
	IF SZQ->(FieldPos("ZQ_EST")) > 0
		SZQ->ZQ_EST := SA2->A2_EST
	ENDIF
	
	IF SZQ->(FieldPos("ZQ_MUN")) > 0
		SZQ->ZQ_MUN := SA2->A2_MUN
	ENDIF
	
	wVencto	:= SD1->D1_EMISSAO
	wVencrea	:= SD1->D1_EMISSAO
	
	DbSelectArea("SE2")						//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
	DbSetOrder(6)
	DbSeek(xFilial("SE2")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_SERIE+SD1->D1_DOC)
	Do while .not. eof() .and. SE2->E2_FILIAL == xFilial("SE2") .and. ;
		SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM == SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_SERIE+SD1->D1_DOC
		dbaixa		:= SE2->E2_BAIXA
		wNat  		:= SE2->E2_NATUREZ
		wVencto	    := SE2->E2_VENCTO
		wVencrea	:= SE2->E2_VENCREA
		DbSkip()
		Exit
	EndDo
	
Else
	SZQ->ZQ_NOME  := (wAlias)->D3_OBS
Endif

SZQ->ZQ_VENCTO    := IIf(wOrigem=='SD1',	wVencto				, 	wD3Emissao )			//Vencto
SZQ->ZQ_VENCREA   := IIf(wOrigem=='SD1',	wVencrea			, 	wD3Emissao )			//Vencto Real

DbSelectArea("SZQ")
SZQ->ZQ_NATUREZ   	:= IIf(wOrigem=='SD1',	wNat				, 	"" )					//Natureza
SZQ->ZQ_NATSYS   	   := posicione('SED',1,xfilial('SED')+szq->zq_naturez,'ED_YCOD')

SZQ->ZQ_BAIXA      	:= IIf(wOrigem=='SD1',	dbaixa				, 	wD3Emissao )				//Baixa
SZQ->ZQ_DESCONT     := IIf(wOrigem=='SD1',	SD1->D1_VALDESC		, 	0 )		//Desconto
SZQ->ZQ_MULTA     	:= 0				//Multa
SZQ->ZQ_JUROS      	:= 0				//Juros
SZQ->ZQ_CORREC     	:= 0				//Correcao
SZQ->ZQ_VALLIQ    	:= IIf(wOrigem=='SD1',	SD1->D1_CUSTO		, 	(wAlias)->D3_CUSTO1 	* IIF(wOrigem=='SD3'.AND.(wAlias)->D3_TM<='499',-1 ,1))		//Vr. Liquid

if posicione('SF4',1,xfilial('SF4')+sd1->d1_tes,"F4_CREDIPI")=="S"
	SZQ->ZQ_VALIPI     	:= IIf(wOrigem=='SD1',	SD1->D1_VALIPI		, 	0 )		//Valor IPI
endif

if posicione('SF4',1,xfilial('SF4')+sd1->d1_tes,"F4_CREDICM")=="S"
	SZQ->ZQ_VALICM     	:= IIf(wOrigem=='SD1',	SD1->D1_VALICM		, 	0 )		//Vr. ICM
endif

SZQ->ZQ_RATEIO	    := 0				//Rateio
SZQ->ZQ_TOTAL		:= IIf( wOrigem=='SD1',	SD1->(D1_TOTAL+D1_VALIPI+D1_DESPESA+D1_SEGURO+D1_VALFRE-D1_VALDESC), (wAlias)->D3_CUSTO1 * IIF(wOrigem=='SD3'.AND.(wAlias)->D3_TM <= '499',-1 ,1))		//Total
//SZQ->ZQ_TOTAL		:= IIf( wOrigem=='SD1',	SD1->(D1_TOTAL), (wAlias)->D3_CUSTO1 * IIF(wOrigem=='SD3'.AND.(wAlias)->D3_TM <= '499',-1 ,1))		//Total
IF wOrigem == 'SD1'
	SZQ->ZQ_CUSCTB		:= SD1->D1_CUSTO // SD1->(D1_CUSTO+IIF(D1_TES$'161',D1_VALICM,0))  //FOI COLOCADO TOTAL PROPOSITALMENTE PARA ATUALIZAR O CUSTO
ELSEIF wOrigem == 'SD3'
	IF SD3->D3_TM <= '499'
		SZQ->ZQ_CUSCTB		:= - SD3->D3_CUSTO1 //FOI COLOCADO TOTAL PROPOSITALMENTE PARA ATUALIZAR O CUSTO
	ELSE
		SZQ->ZQ_CUSCTB		:= SD3->D3_CUSTO1 //FOI COLOCADO TOTAL PROPOSITALMENTE PARA ATUALIZAR O CUSTO
	ENDIF
	SZQ->ZQ_OP     	:= SD3->D3_OP
ELSEIF wOrigem == 'FOL'
	SZQ->ZQ_CUSCTB  := FOL->D3_CUSTO1 //FOI COLOCADO TOTAL PROPOSITALMENTE PARA ATUALIZAR O CUSTO
ENDIF
SZQ->ZQ_CLIENTE     := ""				//Cliente
SZQ->ZQ_PRODUTO    	:= IIf(wOrigem=='SD1',	SD1->D1_COD			, 	(wAlias)->D3_COD )			//Produto
SZQ->ZQ_ORIG		:= IIf(wOrigem $'SD1/SD3',wOrigem	, 	(wAlias)->D3_ORIGEM )			//Origem

IF wOrigem == "FOL"
	SZQ->ZQ_DESCRIC := Posicione("SRV",1,xFilial("SRV")+RTRIM(SZQ->ZQ_NUM),"RV_DESC")
	_nPos := aScan( aDescOri, { | x | Alltrim(x[1]) = SZQ->ZQ_ORIG } )
	
	SZQ->ZQ_DESCORI := aDescOri[ _nPos , 2]
ENDIF

SZQ->ZQ_TPPROD := POSICIONE("SB1",1,xFilial("SB1")+SZQ->ZQ_PRODUTO,"SB1->B1_TIPO")

SZQ->ZQ_ANOMES		:= Left(DtoS(IIf(wOrigem=='SD1',	SD1->D1_DTDIGIT, 	(wAlias)->D3_EMISSAO)),6)	 //Ano Mes
SZQ->ZQ_DTDIGIT		:= IIf(wOrigem=='SD1',	SD1->D1_DTDIGIT		, 	wD3Emissao )		//DT Digitacao
SZQ->ZQ_QUANT       := IIf(wOrigem=='SD1',	SD1->D1_QUANT		, 	(wAlias)->D3_QUANT	* IIF(wOrigem=='SD3'.AND.(wAlias)->D3_TM <= '499',-1 ,1) )		//Quant.
SZQ->ZQ_VUNIT       := IIf(wOrigem=='SD1',	SD1->D1_VUNIT		, 	(wAlias)->D3_CUSTO1	* IIF(wOrigem=='SD3'.AND.(wAlias)->D3_TM <= '499',-1 ,1) )		//Quant.
SZQ->ZQ_VALISS		:= IIf(wOrigem=='SD1',	SD1->D1_VALISS		, 	0 )		//Valor do ISS
SZQ->ZQ_DESPESA		:= IIf(wOrigem=='SD1',	SD1->D1_DESPESA		, 	0 )		//Vlr. Despesa
SZQ->ZQ_SEGURO		:= IIf(wOrigem=='SD1',	SD1->D1_SEGURO		, 	0 )		//Vlr. Seguro
SZQ->ZQ_VALDESC		:= IIf(wOrigem=='SD1',	SD1->D1_VALDESC		, 	0 )		//Desconto
SZQ->ZQ_VALFRE		:= IIf(wOrigem=='SD1',	SD1->D1_VALFRE		, 	0 )		//Vlr. Frete
SZQ->ZQ_VRETPIS		:= IIf(wOrigem=='SD1',	SF1->F1_VALPIS		, 	0 )			//Vlr Ret PIS
SZQ->ZQ_VRETCOF		:= IIf(wOrigem=='SD1',	SF1->F1_VALCOFI		, 	0 )		//Vlr Ret COF
SZQ->ZQ_VRETCSL		:= IIf(wOrigem=='SD1',	SF1->F1_VALCSLL		, 	0 )		//Vlr Ret CSLL
SZQ->ZQ_INSS    	:= IIf(wOrigem=='SD1',	SD1->D1_VALINS      , 	0 )		//INSS
SZQ->ZQ_IRRF   		:= IIf(wOrigem=='SD1',	SD1->D1_VALIRR		, 	0 )		//IRRF POR ITEM
SZQ->ZQ_VCRDPIS		:= IIf(wOrigem=='SD1',	SD1->D1_VALIMP6		, 	0 )		//Vlr Crd PIS (ApuraÁ„o)
SZQ->ZQ_VCRDCOF		:= IIf(wOrigem=='SD1',	SD1->D1_VALIMP5		, 	0 )		//Vlr Crd COFINS (ApuraÁ„o)
SZQ->ZQ_VCRDCSL		:= IIf(wOrigem=='SD1',	SD1->D1_VALIMP4		, 	0 )		//Vl Cred CSLL (ApuraÁ„o)
SZQ->ZQ_ICMSRET		:= IIf(wOrigem=='SD1',	SD1->D1_ICMSRET		, 	0 )		//ICMS Solid.
SZQ->ZQ_TES			:= IIf(wOrigem=='SD1',	SD1->D1_TES			, 	(wAlias)->D3_TM )			//Tipo Entrada
IF wOrigem $ 'SD1*SD3*SE2*SE5'
	SZQ->ZQ_CF			:= IIf(wOrigem=='SD1',	SD1->D1_CF			,(wAlias)->D3_CF )			//Cod. Fiscal
EndIf
SZQ->ZQ_NFORI		:= IIf(wOrigem=='SD1',	SD1->D1_NFORI		, 	"" )		//N.F.Original
SZQ->ZQ_SERIORI	    := IIf(wOrigem=='SD1',	SD1->D1_SERIORI		, 	"" )		//Serie Orig.
SZQ->ZQ_ITEMORI	    := IIf(wOrigem=='SD1',	SD1->D1_ITEMORI		, 	"" )		//Item NF Orig
SZQ->ZQ_DATORI		:= IIf(wOrigem=='SD1',	SD1->D1_DATORI		, 	CTOD("") )		//Data NF Orig
SZQ->ZQ_PEDIDO		:= IIf(wOrigem=='SD1',	SD1->D1_PEDIDO		, 	"" )		//No do Pedido
SZQ->ZQ_ITEMPC		:= IIf(wOrigem=='SD1',	SD1->D1_ITEMPC		, 	"" )		//Item do Ped.
SZQ->ZQ_FORTRAN	    := IIf(wOrigem=='SD1',	SD1->D1_LOTEFOR		, 	"" )
SZQ->ZQ_LJFRTRA	    := IIf(wOrigem=='SD1',	'01'				, 	"" )
SZQ->ZQ_PLACA		:= IIf(wOrigem=='SD1',	SD1->D1_PLACA		, 	"" )

IF wOrigem== 'FOL'
	//SZQ->ZQ_VISAO   := GetNewPar('MV_CDVIFOL','205')
	//SZQ->ZQ_DESCVI  := POSICIONE('ZZ8',1,xfilial('ZZ8')+szq->zq_visao,'ZZ8_DESPES')
	//SZQ->ZQ_VISAOCD := GetNewPar('MV_CDVIFOL','205')
	//SZQ->ZQ_DSCVICD := SZQ->ZQ_DESCVI
else
	//SZQ->ZQ_VISAO   := IIf(wOrigem=='SD1',	SD1->D1_VISAO		, 	IIf(wOrigem=='SD3',	SD3->D3_VISAO		, 	"" ) )
	//SZQ->ZQ_DESCVI  := IIf(wOrigem=='SD1',	SD1->D1_DESCVI		, 	IIf(wOrigem=='SD3',	SD3->D3_DESCVI		, 	"" ) )
	//SZQ->ZQ_VISAOCD := IIf(wOrigem=='SD1',	SD1->D1_VISAO		, 	IIf(wOrigem=='SD3',	SD3->D3_VISAO		, 	"" ) )
	//SZQ->ZQ_DSCVICD := IIf(wOrigem=='SD1',	SD1->D1_DESCVI		, 	IIf(wOrigem=='SD3',	SD3->D3_DESCVI		, 	"" ) )
endif

If wOrigem=='SD1'
	dbselectarea('SF4')
	SF4->(dbSetOrder(1)) //F4_FILIAL+F4_CODIGO
	SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
	
	dbselectarea('SC7')
	SC7->(dbSetOrder(1)) //C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
	SC7->(dbSeek(xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC))
	
	dbselectarea('SF1')
	SF1->(dbSetOrder(1)) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
	SF1->(dbSeek(SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_TIPO)))
	
	dbselectarea('SE4')
	SE4->(dbSetOrder(1)) //E4_FILIAL+E4_CODIGO
	SE4->(dbSeek(xFilial("SE4")+SF1->F1_COND))
	
	dbselectarea('SZQ')
	
	SZQ->ZQ_TEXTO		:= SF4->F4_TEXTO	//Txt Padrao
	SZQ->ZQ_DUPLIC		:= SF4->F4_DUPLIC	//Gera Dupl. ?
	
	SZQ->ZQ_OBS			:= SC7->C7_OBS		//Observacoes
	SZQ->ZQ_QTDTRA 	:= SC7->C7_QUANT    //Qtd. Transportada
	
	SZQ->ZQ_COND	:= SF1->F1_COND		//Cond. Pagto ## Alterado por Gustavo Hand Strey em 07/12/2009
	SZQ->ZQ_ESPECIE	:= SF1->F1_ESPECIE	//Espec.Docum.
	
	// VISAO GERENCIAL
	
	
Else
	if wOrigem == 'SD3'
		SZQ->ZQ_TEXTO	:= POSICIONE('SF5',1,XFILIAL('SF5')+SD3->D3_TM,"F5_TEXTO")	//Txt Padrao
	else
		SZQ->ZQ_TEXTO	:= POSICIONE('SRV',1,XFILIAL('SRV')+RTRIM(SZQ->ZQ_NUM),"RV_DESC")	//Txt Padrao
	endif
	
	SZQ->ZQ_OBS			:= (wAlias)->D3_OBS		//Observacoes
Endif
xCodFil := iif(wOrigem=='SD1',	Right(SD1->D1_FILIAL,2), Right((wAlias)->D3_FILIAL,2) )
xCodFil := iif(Empty(xCodFil), Right(cFilAnt,2), xCodFil)

SM0->(dbSetOrder(1))
SM0->(dbSeek(cEmpAnt+cFilAnt))

DbSelectArea("SZQ")
SZQ->ZQ_CODEMP	:= cEmpAnt+Left(cFilAnt,3)			//Codg Empresa
SZQ->ZQ_CODFIL	:= xCodFil
SZQ->ZQ_NOMFIL	:= SM0->M0_FILIAL //Nome Filial
SZQ->ZQ_NOMEMP	:= ALLTRIM(SM0->M0_FILIAL) //Nome Empresa

CTT->(dbSetOrder(1)) //CTT_FILIAL+CTT_CUSTO
CTT->(dbSeek(xFilial("CTT")+IIf(wOrigem=='SD1',	SD1->D1_CC,  (wAlias)->D3_CC) ))
DbSelectArea("SZQ")
DbSelectArea("SZQ")

aSA2 := SA2->(GetArea())
If Left(SZQ->ZQ_ESPECIE,3) == 'CTR' //.and. cTipoProd == "MP"
	SZQ->ZQ_FORMP   := POSICIONE("SF8",3,xFilial("SF8")+PADR(SZQ->ZQ_NUM,TamSx3("F2_DOC")[1])+SZQ->ZQ_PREFIXO+SZQ->ZQ_FORNECE+SZQ->ZQ_LOJA,"F8_FORNECE")
	SZQ->ZQ_YDESFOR := POSICIONE("SA2",1,xFilial("SA2")+SF8->(F8_FORNECE+F8_LOJA),"A2_NREDUZ")
ELSEIF Left(SZQ->ZQ_ESPECIE,2) == 'NF'
	SZQ->ZQ_FORMP   := SZQ->ZQ_FORNECE
	SZQ->ZQ_YDESFOR := POSICIONE("SA2",1,xFilial("SA2")+SZQ->(ZQ_FORNECE+ZQ_LOJA),"A2_NREDUZ")
ENDIF

szq->(MsUnlock())

SA2->(RestArea(aSA2))

restarea(warea)

Return
*-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//###########################
//## FILTRA TABELA   S  E  5
//###########################

Static Function fprocSQL(wRecPag,wAcao,wTpLancto)

Local cQuery := ""
ProcRegua(2)
IncProc("Monta Query")

//CPMF  - PAGAMENTO
//###########################
cQuery := "SELECT E5_TIPODOC, E5_PREFIXO AS E5_PREFIXO, E5_NUMERO AS E5_NUMERO, E5_PARCELA AS E5_PARCELA, "+CRLF
cQuery+= "E5_TIPO AS E5_TIPO, E5_NATUREZ AS E5_NATUREZ, E5_CLIFOR AS E5_CLIFOR, E5_LOJA AS E5_LOJA, "+CRLF
cQuery+= "E5_DATA AS E5_DATA, E5_BENEF AS E5_BENEF, E5_VLDESCO AS E5_VLDESCO , "+CRLF
cQuery+= "E5_VLMULTA AS E5_VLMULTA , E5_VLJUROS AS E5_VLJUROS, E5_VLCORRE AS E5_VLCORRE, "
cQuery+= "E5_RECPAG AS E5_RECPAG, E5_VALOR AS E5_VALOR,0 AS ESTORNO,'OP008001' AS E5_YCC, E5_HISTOR,R_E_C_N_O_ AS NUMRECNO "+CRLF
cQuery+= " FROM "+RetSQLName("SE5")+CRLF
cQuery+= " WHERE D_E_L_E_T_ = ' '  "+CRLF
cQuery+= "AND E5_FILIAL = "+xFilial("SE5")+" "+CRLF
cQuery+= "AND E5_DATA BETWEEN '"+dtos(dta_ini)+"' AND '"+dtos(dta_fin)+"'  "+CRLF
cQuery+= "AND E5_NATUREZ  IN ( "+GetMV('MV_SZQNAT1')+ " )  "+CRLF // PARAMATRO P/ NAT. DE CPMF
cQuery+= "AND E5_RECPAG = 'P' "+CRLF
cQuery+= "AND E5_PREFIXO = ' ' "+CRLF
cQuery+= "AND E5_NUMERO = ' '  "+CRLF
cQuery+= "AND E5_PARCELA = ' '  "+CRLF
cQuery+= "AND E5_SITUACA = ' '  "+CRLF

//TARIFAS BANCARIAS - PAGAMENTO
//#################################
cQuery+= " UNION ALL "+CRLF
cQuery+= "SELECT  E5_TIPODOC, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_NATUREZ, E5_CLIFOR, "+CRLF
cQuery+= "E5_LOJA, E5_DATA, E5_BENEF, E5_VLDESCO, E5_VLMULTA, E5_VLJUROS, "+CRLF
cQuery+= "E5_VLCORRE, E5_RECPAG, E5_VALOR,0 AS ESTORNO,'OP009001', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO "+CRLF
cQuery+= " FROM "+RetSQLName("SE5")+CRLF
cQuery+= "WHERE D_E_L_E_T_ = ' '  "+CRLF
cQuery+= "AND E5_FILIAL = "+xFilial("SE5")+" "+CRLF
cQuery+= "AND E5_DATA BETWEEN '"+dtos(dta_ini)+"' AND '"+dtos(dta_fin)+"'  "+CRLF
cQuery+= "AND E5_NATUREZ IN ( "+GetMV('MV_SZQNAT2')+ " )  "+CRLF   // PARAMETRO PARA NATUREZA DE TARIFAS BANCARIAS
cQuery+= "AND E5_RECPAG = 'P'  "+CRLF
cQuery+= "AND E5_PREFIXO = ' ' "+CRLF
cQuery+= "AND E5_NUMERO = ' '  "+CRLF
cQuery+= "AND E5_PARCELA = ' '  "+CRLF
cQuery+= "AND E5_SITUACA = ' '  "+CRLF

// ESTORNO TARIFAS BANCARIAS
//#################################
cQuery+= " UNION ALL "+CRLF
cQuery+= "SELECT  E5_TIPODOC, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_NATUREZ, E5_CLIFOR, "+CRLF
cQuery+= "E5_LOJA, E5_DATA, E5_BENEF, E5_VLDESCO, E5_VLMULTA, E5_VLJUROS, "+CRLF
cQuery+= "E5_VLCORRE, E5_RECPAG, (E5_VALOR * -1) AS E5_VALOR,0 AS ESTORNO,'OP009001', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO "+CRLF
cQuery+= " FROM "+RetSQLName("SE5")+CRLF
cQuery+= "WHERE D_E_L_E_T_ = ' '  "+CRLF
cQuery+= "AND E5_FILIAL = "+xFilial("SE5")+" "+CRLF
cQuery+= "AND E5_DATA BETWEEN '"+dtos(dta_ini)+"' AND '"+dtos(dta_fin)+"'  "+CRLF
cQuery+= "AND E5_NATUREZ IN ( "+GetMV('MV_SZQNAT2')+ " )  "+CRLF   // PARAMETRO PARA NATUREZA DE TARIFAS BANCARIAS
cQuery+= "AND E5_RECPAG = 'R'  "+CRLF
cQuery+= "AND E5_PREFIXO = ' ' "+CRLF
cQuery+= "AND E5_NUMERO = ' '  "+CRLF
cQuery+= "AND E5_PARCELA = ' '  "+CRLF
cQuery+= "AND E5_SITUACA = ' '  "+CRLF

//RECEITA - Juros recebidos
//##########################
cQuery+= " UNION ALL "+CRLF
cQuery+= "SELECT  E5_TIPODOC, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_NATUREZ, E5_CLIFOR, "+CRLF
cQuery+= "E5_LOJA, E5_DATA, E5_BENEF, E5_VLDESCO, E5_VLMULTA, E5_VLJUROS, "+CRLF
cQuery+= "E5_VLCORRE, E5_RECPAG, ( E5_VALOR * -1 ),0 AS ESTORNO,'OU302001', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO"+CRLF
cQuery+= " FROM "+RetSQLName("SE5") + CRLF
cQuery+= "WHERE D_E_L_E_T_ = ' ' "+CRLF
cQuery+= "AND E5_FILIAL = "+xFilial("SE5")+" "+CRLF
cQuery+= "AND E5_TIPODOC = 'JR' "+CRLF
cQuery+= "AND (E5_PREFIXO <> '   ' OR E5_NUMERO <> '      ' OR E5_PARCELA <> ' ') "+CRLF
cQuery+= "AND E5_TIPO <> '  ' "+CRLF
cQuery+= "AND E5_SITUACA = ' ' "+CRLF
cQuery+= "AND E5_RECPAG = 'R' "+CRLF
cQuery+= "AND E5_DATA BETWEEN '"+dtos(dta_ini)+"' AND '"+dtos(dta_fin)+"'  "+CRLF

//RECEITA - Multas Recebidas
//##########################
cQuery+= " UNION ALL "+CRLF
cQuery+= "SELECT  E5_TIPODOC, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_NATUREZ, E5_CLIFOR, "+CRLF
cQuery+= "E5_LOJA, E5_DATA, E5_BENEF, E5_VLDESCO, E5_VLMULTA, E5_VLJUROS, "+CRLF
cQuery+= "E5_VLCORRE, E5_RECPAG, ( E5_VALOR * -1 ),0 AS ESTORNO,'OU302001', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO "+CRLF
cQuery+= " FROM "+RetSQLName("SE5") + CRLF
cQuery+= "WHERE D_E_L_E_T_ = ' ' "+CRLF
cQuery+= "AND E5_FILIAL = "+xFilial("SE5")+" "+CRLF
cQuery+= "AND E5_TIPODOC = 'MT' "+CRLF
cQuery+= "AND (E5_PREFIXO <> '   ' OR E5_NUMERO <> '      ' OR E5_PARCELA <> ' ') "+CRLF
cQuery+= "AND E5_TIPO <> '  ' "+CRLF
cQuery+= "AND E5_SITUACA = ' ' "+CRLF
cQuery+= "AND E5_RECPAG = 'R' "+CRLF
cQuery+= "AND E5_DATA BETWEEN '"+dtos(dta_ini)+"' AND '"+dtos(dta_fin)+"'  "+CRLF

//RECEITA - Descontos Recebidos
//#############################
cQuery+= " UNION ALL "+CRLF
cQuery+= "SELECT E5_TIPODOC,  E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_NATUREZ, E5_CLIFOR, "+CRLF
cQuery+= "E5_LOJA, E5_DATA, E5_BENEF, E5_VLDESCO, E5_VLMULTA, E5_VLJUROS, "+CRLF
cQuery+= "E5_VLCORRE, E5_RECPAG,( E5_VALOR * -1 ) AS E5_VALOR, 0 AS ESTORNO,'OU302001', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO "+CRLF
cQuery+= "FROM "+RetSQLName("SE5") + CRLF
cQuery+= "WHERE D_E_L_E_T_ = ' '  "+CRLF
cQuery+= "AND E5_FILIAL = "+xFilial("SE5")+" "+CRLF
cQuery+= "AND E5_TIPODOC = 'DC' "+CRLF
cQuery+= "AND (E5_PREFIXO <> '   ' OR E5_NUMERO <> '      ' OR E5_PARCELA <> ' ') "+CRLF
cQuery+= "AND E5_TIPO <> '  ' "+CRLF
cQuery+= "AND E5_SITUACA = ' ' "+CRLF
cQuery+= "AND E5_RECPAG = 'P' "+CRLF
cQuery+= "AND E5_DATA BETWEEN '"+dtos(dta_ini)+"' AND '"+dtos(dta_fin)+"'  "+CRLF


//DESPESA - Juros Pagos
//#########################
cQuery+= " UNION ALL "+CRLF
cQuery+= "SELECT  E5_TIPODOC, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_NATUREZ, E5_CLIFOR, "+CRLF
cQuery+= "E5_LOJA, E5_DATA, E5_BENEF, E5_VLDESCO, E5_VLMULTA, E5_VLJUROS, "+CRLF
cQuery+= "E5_VLCORRE, E5_RECPAG,E5_VALOR,0 AS ESTORNO,'OU302002', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO "+CRLF
cQuery+= "FROM "+RetSQLName("SE5") + CRLF
cQuery+= "WHERE D_E_L_E_T_ = ' '  "+CRLF
cQuery+= "AND E5_FILIAL = "+xFilial("SE5")+" "+CRLF
cQuery+= "AND E5_TIPODOC = 'JR' "+CRLF
cQuery+= "AND (E5_PREFIXO <> '   ' OR E5_NUMERO <> '      ' OR E5_PARCELA <> ' ') "+CRLF
cQuery+= "AND E5_TIPO <> '  ' "+CRLF
cQuery+= "AND E5_SITUACA = ' ' "+CRLF
cQuery+= "AND E5_RECPAG = 'P' "+CRLF
cQuery+= "AND E5_DATA BETWEEN '"+dtos(dta_ini)+"' AND '"+dtos(dta_fin)+"'  "+CRLF

//DESPESA - Multas Pagas
//#########################
cQuery+= " UNION ALL "+CRLF
cQuery+= "SELECT  E5_TIPODOC, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_NATUREZ, E5_CLIFOR, "+CRLF
cQuery+= "E5_LOJA, E5_DATA, E5_BENEF, E5_VLDESCO, E5_VLMULTA, E5_VLJUROS, "+CRLF
cQuery+= "E5_VLCORRE, E5_RECPAG,E5_VALOR,0 AS ESTORNO,'OU302002', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO "+CRLF
cQuery+= "FROM "+RetSQLName("SE5") + CRLF
cQuery+= "WHERE D_E_L_E_T_ = ' '  "+CRLF
cQuery+= "AND E5_FILIAL = "+xFilial("SE5")+" "+CRLF
cQuery+= "AND E5_TIPODOC = 'MT' "+CRLF
cQuery+= "AND (E5_PREFIXO <> '   ' OR E5_NUMERO <> '      ' OR E5_PARCELA <> ' ') "+CRLF
cQuery+= "AND E5_TIPO <> '  ' "+CRLF
cQuery+= "AND E5_SITUACA = ' ' "+CRLF
cQuery+= "AND E5_RECPAG = 'P' "+CRLF
cQuery+= "AND E5_DATA BETWEEN '"+dtos(dta_ini)+"' AND '"+dtos(dta_fin)+"'  "+CRLF



//DESPESA - Descontos concedidos
//###############################
cQuery+= " UNION ALL "+CRLF
cQuery+= "SELECT  E5_TIPODOC, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_NATUREZ, E5_CLIFOR, "+CRLF
cQuery+= "E5_LOJA, E5_DATA, E5_BENEF, E5_VLDESCO, E5_VLMULTA, E5_VLJUROS, "+CRLF
cQuery+= "E5_VLCORRE, E5_RECPAG,E5_VALOR,0 AS ESTORNO,'OU302002', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO "+CRLF
cQuery+= "FROM "+RetSQLName("SE5") + CRLF
cQuery+= "WHERE D_E_L_E_T_ = ' '  "+CRLF
cQuery+= "AND E5_FILIAL = "+xFilial("SE5")+" "+CRLF
cQuery+= "AND E5_TIPODOC = 'DC' "+CRLF
cQuery+= "AND (E5_PREFIXO <> '   ' OR E5_NUMERO <> '      ' OR E5_PARCELA <> ' ') "+CRLF
cQuery+= "AND E5_TIPO <> '  ' "+CRLF
cQuery+= "AND E5_SITUACA = ' ' "+CRLF
cQuery+= "AND E5_RECPAG = 'R' "+CRLF
cQuery+= "AND E5_DATA BETWEEN '"+dtos(dta_ini)+"' AND '"+dtos(dta_fin)+"'  "+CRLF


//APLICA«√O FINANCEIRA
//#########################
cQuery+= " UNION ALL "+CRLF
cQuery+= "SELECT  E5_TIPODOC, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_NATUREZ, E5_CLIFOR, "+CRLF
cQuery+= "E5_LOJA, E5_DATA, E5_BENEF, E5_VLDESCO, E5_VLMULTA, E5_VLJUROS, "+CRLF
cQuery+= "E5_VLCORRE, E5_RECPAG,E5_VALOR, 0 AS ESTORNO,'OUAPLICA', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO "+CRLF
cQuery+= "FROM "+RetSQLName("SE5") + CRLF
cQuery+= "WHERE D_E_L_E_T_ =' '  "+CRLF
cQuery+= "AND E5_FILIAL = "+xFilial("SE5")+" "+CRLF
wNatRApl := GetMV("MV_NATRAPL")
If Subs(wNatRApl,1,1) == '"'
	wNatRApl := 	Right(wNatRApl,Len(wNatRApl)-1)
	wNatRApl := 	Left(wNatRApl,Len(wNatRApl)-1)
EndIf
cQuery+= "AND E5_NATUREZ = '"+wNatRApl+"' "+CRLF
cQuery+= "AND E5_PREFIXO = ' ' "+CRLF
cQuery+= "AND E5_NUMERO = ' ' "+CRLF
cQuery+= "AND E5_PARCELA = ' ' "+CRLF
cQuery+= "AND E5_DATA BETWEEN '"+dtos(dta_ini)+"' AND '"+dtos(dta_fin)+"'  "+CRLF


//RENDIMENTOS
//#########################
cQuery+= " UNION ALL "+CRLF
cQuery+= "SELECT  E5_TIPODOC, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_NATUREZ, E5_CLIFOR, "+CRLF
cQuery+= "E5_LOJA, E5_DATA, E5_BENEF, E5_VLDESCO, E5_VLMULTA, E5_VLJUROS, "+CRLF
cQuery+= "E5_VLCORRE, E5_RECPAG, E5_VALOR,0 AS ESTORNO,'OP009001', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO "+CRLF
cQuery+= " FROM "+RetSQLName("SE5")+CRLF
cQuery+= "WHERE D_E_L_E_T_ = ' '  "+CRLF
cQuery+= "AND E5_FILIAL = "+xFilial("SE5")+" "+CRLF
cQuery+= "AND E5_DATA BETWEEN '"+dtos(dta_ini)+"' AND '"+dtos(dta_fin)+"'  "+CRLF
cQuery+= "AND E5_NATUREZ IN ( "+GetMV('MV_SZQNAT3')+ " )  "+CRLF   // PARAMETRO PARA NATUREZA PARA RENDIMENTOS
cQuery+= "AND E5_RECPAG = 'R'  "+CRLF
cQuery+= "AND E5_PREFIXO = ' ' "+CRLF
cQuery+= "AND E5_NUMERO = ' '  "+CRLF
cQuery+= "AND E5_PARCELA = ' '  "+CRLF
cQuery+= "AND E5_SITUACA = ' '  "+CRLF

MemoWrit("MOV_BCO.SQL",cQuery)


If Select('TRB')>0
	dbSelectArea("TRB")
	DbCloseArea()
Endif
TCQuery cQuery NEW ALIAS "TRB"
IncProc("Monta cQuery")
dbSelectArea("TRB")
TRB->(dbGoTop())
If ! Eof() .and. ! Bof()
	While ! TRB->(EOf())
		wRegs ++
		TRB->(dbSkip())
	End
	TRB->(dbGoTop())
EndIf

Return
*-----------------------------------------------------------------------------------------------------------------------------------------------------------------

Static Function fprocSD3()

Private dbaixa := ctod(space(8))
Private wFilial

DbSelectArea("SD3")
ProcRegua(RecCount())

If Empty(cDoc)
	
	DbSetOrder(6) //D3_FILIAL+DTOS(D3_EMISSAO)+D3_NUMSEQ+D3_CHAVE+D3_COD
	DbSeek(xFilial("SD3")+Dtos(dta_ini),.t.)
	
	wFilial := xFilial("SD3")
	
	While .not. eof() .and. SD3->D3_FILIAL == wFilial .And. SD3->D3_EMISSAO <= dta_fin
		dbaixa := ctod(space(8))
		IncProc("Movimentos Internos - Data: "+Dtoc(D3_EMISSAO))
		DbSelectArea("SZQ")
		fGrava('SD3')
		DbSelectArea("SD3")
		SD3->(DbSkip())
	EndDo
	
Else
	
	fGrava('SD3')
	
EndIf

Return
*-----------------------------------------------------------------------------------------------------------------------------------------------------------------

Static Function fProcFOL()

Local cAlias:=""
Processa( {|| cAlias:=fProcSQLFOL() } , "Aguarde!", "Montando filtro da FOLHA PAGTO")
if cAlias<>""
	Processa( {|| fProcGrvFol(cAlias) } , "Aguarde!", "Gravando registros da FOLHA PAGTO")
endif
Return
*-----------------------------------------------------------------------------------------------------------------------------------------------------------------

Static Function fProcGrvFol(cAlias)

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())
While !(cAlias)->(EOf())
	IncProc('Aguarde... Gravando '+ Str( (cAlias)->(Recno()),7) )
	fGrava(cAlias)
	(cAlias)->(dbSkip())
End

Return

Static Function fProcSQLFOL()

Local cQuery := ""
Local lRet   := .T.
Local cCT2   := RetSqlName("CT2")

ProcRegua(2)
IncProc("Monta Query")

If cEmpAnt == "10"
	
	cQuery +="SELECT (CASE LEFT(CT2_DEBITO,1) WHEN '6'	  THEN CT2_DEBITO ELSE CT2_CREDIT END) D3_CONTA, "+CRLF
	cQuery +="	     (CASE LEFT(CT2_DEBITO,1) WHEN '6'    THEN CT2_CCD    ELSE CT2_CCC    END) D3_CC, "+CRLF
	cQuery +="	     (CASE LEFT(CT2_DEBITO,1) WHEN '6'	  THEN CT2_ITEMD  ELSE CT2_ITEMC  END) D3_ITEMCTA, "+CRLF
	cQuery +="	     (CASE LEFT(CT2_DEBITO,1) WHEN '6'	  THEN CT2_CLVLDB ELSE CT2_CLVLCR END) D3_CLVL, "+CRLF
	cQuery +="	   (CASE CT2_LOTE           WHEN '008890' THEN 'FOL'	 WHEN '008891' THEN 'FOL'  WHEN '000002' THEN 'RAT' ELSE 'EXT' END) D3_ORIGEM, "+CRLF
	cQuery +="	   "+ValToSql(cFilAnt)+" D3_FILIAL,  "+CRLF
	cQuery +="     CT2_DATA D3_EMISSAO,  "+CRLF
	cQuery +="     CT2_DOC D3_DOC,  "+CRLF
	cQuery +="	   ' ' PREF,  "+CRLF
	cQuery +="     1 D3_QUANT, "+CRLF
	cQuery +="     ' ' D3_COD, "+CRLF
	cQuery +="     ' ' D3_TM, "+CRLF
	cQuery +="     CT2_HIST D3_OBS,  "+CRLF
	cQuery +="	   ((CASE LEFT(CT2_DEBITO,1) WHEN '6' THEN 1 ELSE -1 END) * CT2_VALOR ) D3_CUSTO1 "+CRLF
	cQuery +=" FROM "+cCT2+CRLF
	cQuery +="WHERE D_E_L_E_T_ = '' "+CRLF
	cQuery +="  AND CT2_FILIAL = "+ValToSql(xFilial("CT2"))+CRLF
	cQuery +="  AND CT2_DATA BETWEEN "+ValToSql(dta_ini)+" AND "+ValToSql(dta_fin)+CRLF
	cQuery +="  AND CT2_LOTE IN ('000001','000002','008890','008891') "+CRLF // Lotes "EXTRA", "RATEIOS" e "FOLHA" respectivamente
	cQuery +="  AND '6' IN (LEFT(CT2_DEBITO,1), LEFT(CT2_CREDIT,1))"
Else
	cQuery +="SELECT (CASE LEFT(CT2_DEBITO,1) WHEN '3'	  THEN CT2_DEBITO ELSE CT2_CREDIT END) D3_CONTA, "+CRLF
	cQuery +="	     (CASE LEFT(CT2_DEBITO,1) WHEN '3'    THEN CT2_CCD    ELSE CT2_CCC    END) D3_CC, "+CRLF
	cQuery +="	     (CASE LEFT(CT2_DEBITO,1) WHEN '3'	  THEN CT2_ITEMD  ELSE CT2_ITEMC  END) D3_ITEMCTA, "+CRLF
	cQuery +="	     (CASE LEFT(CT2_DEBITO,1) WHEN '3'	  THEN CT2_CLVLDB ELSE CT2_CLVLCR END) D3_CLVL, "+CRLF
	cQuery +="	   (CASE CT2_LOTE           WHEN '008890' THEN 'FOL'	 WHEN '008891' THEN 'FOL'  WHEN '000002' THEN 'RAT' ELSE 'EXT' END) D3_ORIGEM, "+CRLF
	cQuery +="	   "+ValToSql(cFilAnt)+" D3_FILIAL,  "+CRLF
	cQuery +="     CT2_DATA D3_EMISSAO,  "+CRLF
	cQuery +="     CT2_DOC D3_DOC,  "+CRLF
	cQuery +="	   ' ' PREF,  "+CRLF
	cQuery +="     1 D3_QUANT, "+CRLF
	cQuery +="     ' ' D3_COD, "+CRLF
	cQuery +="     ' ' D3_TM, "+CRLF
	cQuery +="     CT2_HIST D3_OBS,  "+CRLF
	cQuery +="	   ((CASE LEFT(CT2_DEBITO,1) WHEN '3' THEN 1 ELSE -1 END) * CT2_VALOR ) D3_CUSTO1 "+CRLF
	cQuery +=" FROM "+cCT2+CRLF
	cQuery +="WHERE D_E_L_E_T_ = '' "+CRLF
	cQuery +="  AND CT2_FILIAL = "+ValToSql(xFilial("CT2"))+CRLF
	cQuery +="  AND CT2_DATA BETWEEN "+ValToSql(dta_ini)+" AND "+ValToSql(dta_fin)+CRLF
	cQuery +="  AND CT2_LOTE IN ('000001','000002','008890','008891') "+CRLF // Lotes "EXTRA", "RATEIOS" e "FOLHA" respectivamente
	cQuery +="  AND '3' IN (LEFT(CT2_DEBITO,1), LEFT(CT2_CREDIT,1))"
Endif


MemoWrit("szqfolha.sql",cQuery)

If Select('FOL') > 0
	dbSelectArea("FOL")
	DbCloseArea()
Endif

TCQuery cQuery NEW ALIAS "FOL"

IncProc(" FIM Monta cQuery")

TcSetField("FOL","D3_EMISSAO","D")

Return "FOL"


Static Function PXH15A()

_cVisao := "'"+GETMV("PXH_VISAO2")+"'"

aStru	:= CTS->(DbStruct())
// Obtem os registros a serem processados

cQuery := " SELECT * FROM "+RetSqlName("CTS")+" CTS "
cQuery += " WHERE CTS.D_E_L_E_T_ = '' AND CTS_CODPLA = "+_cVisao+" "
cQuery += " AND CTS_CT1INI <> '' AND CTS_FILIAL = '"+xFilial("CTS")+"' "
cQuery += " ORDER BY CTS_CODPLA,CTS_ORDEM "

TCQUERY cQuery NEW ALIAS "NEWCTS"

For nI := 1 TO LEN(aStru)
	If aStru[nI][2] != "C"
		TCSetField("NEWCTS", aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
	EndIf
Next

cNomeArq := CriaTrab(Nil,.F.)
IndRegua("NEWCTS",cNomeArq,"CTS_FILIAL+CTS_CODPLA+CTS_ORDEM",,,"Selecionando Registros...")

NEWCTS->(dbGoTop())

ProcRegua(NEWCTS->(LASTREC()))

While NEWCTS->(!Eof())
	
	IncProc()
	
	If NEWCTS->CTS_SLDENT <> "3"
		//Verifica CrÈdito
		cQuer1 := " SELECT R_E_C_N_O_ AS NUMREG FROM "+RetSqlName("SZQ")+" A " +CRLF
		cQuer1 += " WHERE A.D_E_L_E_T_ = '' AND ZQ_FILIAL = '"+xFilial("SZQ")+" ' " +CRLF
		cQuer1 += " AND ZQ_DTDIGIT 	BETWEEN '"+DTOS(dta_ini)    +"' " +CRLF
		cQuer1 += " AND  '"+DTOS(dta_fin)+"' " +CRLF
		cQuer1 += " AND ZQ_CONTA    BETWEEN '"+NEWCTS->CTS_CT1INI+"' AND  '"+NEWCTS->CTS_CT1FIM+"' " +CRLF
		cQuer1 += " AND ZQ_YCC  	BETWEEN '"+NEWCTS->CTS_CTTINI+"' AND  '"+NEWCTS->CTS_CTTFIM+"' " +CRLF
		cQuer1 += " AND ZQ_ITEMCTA 	BETWEEN '"+NEWCTS->CTS_CTDINI+"' AND  '"+NEWCTS->CTS_CTDFIM+"' " +CRLF
		cQuer1 += " AND ZQ_CLVL     BETWEEN '"+NEWCTS->CTS_CTHINI+"' AND  '"+NEWCTS->CTS_CTHFIM+"' " +CRLF
		cQuer1 += " ORDER BY ZQ_DTDIGIT "
		
		MemoWrit("c:\relprotheus\relprotheus.txt",cQuer1)
		
		TCQUERY cQuer1 NEW ALIAS "ZZ"
		
		ZZ->(dbGoTop())
		
		While ZZ->(!Eof())
			
			_cDesSup := Space(40)
			CTS->(dbSetorder(2))
			If CTS->(dbSeek(xfilial("CTS")+NEWCTS->CTS_CODPLA + NEWCTS->CTS_CTASUP))
				_cDesSup := CTS->CTS_DESCCG
			Endif
			
			SZQ->(dbGoto(ZZ->NUMREG))
			SZQ->(RecLock("SZQ",.F.))
			SZQ->ZQ_CODVISA := NEWCTS->CTS_CODPLA
			SZQ->ZQ_DESVISA := NEWCTS->CTS_DESCCG
			SZQ->ZQ_CODVISS := NEWCTS->CTS_CTASUP
			SZQ->ZQ_DESVISS := _cDesSup
			SZQ->ZQ_CONTVIS := NEWCTS->CTS_CONTAG
			SZQ->(MsUnlock())
			
			ZZ->(dbSkip())
		EndDo
		
		ZZ->(dbCloseArea())
	Endif
	
	NEWCTS->(dbSKIP())
EndDo

NEWCTS->(dbCloseArea())

Return
