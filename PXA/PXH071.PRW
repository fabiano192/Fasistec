#include "Protheus.ch"
#include "TOPCONN.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³  PXH071  ³ Autor ³ Alexandro             ³ Data ³ 19.11.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³  Arquivo de Resumo  de CC                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³  SIGACTB - Menu atualiza‡äes                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PXH071(_cDoc,_cSerie,_cFornece,_cLoja, nMovmnto)

	Local aMiz871    := GetArea()
	Local aSF1       := {'SF1',SF1->(INDEXORD()),SF1->(RECNO())}
	Local lperg
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
		nMovmnto := mv_par03
	Else
		cDoc     := _cDoc
		cSerie   := _cSerie
		cFornece := _cFornece
		cLoja    := _cLoja
	EndIf

	Processa( {|| FLIMPA(nMovmnto) } , "Aguarde!", "Organizando arquivos...")

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
		If Empty( cDoc )
			Processa( {|| fProcFOL() } , "Aguarde!", "Processando FOLHA PAGTO...")
		Else
			fProcFOL()
		Endif
	Endif

	If ( Empty(cDoc) ) .And. (nMovmnto ==4 .or. nMovmnto ==5)
		Processa( {|| FPROCFIN5() } , "Aguarde!", "Processando Mov.Bancaria........")
		Processa( {|| FPROCFIN1() } , "Aguarde!", "Processando Contas Receber......")
		Processa( {|| FPROCFIN2() } , "Aguarde!", "Processando Contas Pagar........")
		Processa( {|| FPROCFIN3() } , "Aguarde!", "Processando Baixas a Receber....")
		Processa( {|| FPROCFIN4() } , "Aguarde!", "Processando Baixas a Pagar......")
	EndIf

	If Empty(cDoc)
		Processa( {|| PXH15A() } , "Aguarde!", "Atualizando VISAO Gerencial...") // VERIFICA A VISAO GERENCIAL
	Else
		PXH15A()
	Endif

	If Empty(cDoc)
		MsgInfo("Processamento encerrado")
	EndIf

	RestArea(aMiz871)
	dbSelectArea(aSF1[1])
	dbSetOrder(aSF1[2])
	dbgoto(aSF1[3])

	Return
	*-----------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³flimpa    ³ Autor ³ NILTON CESAR          ³ Data ³ 19.11.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Arquivo de Resumo  de CC                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN - Menu atualiza‡äes                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function FLIMPA(WORIGEM)

	cORIGEM:= IIF( worigem == 1 ,"SD1", IIF( worigem == 2 , "SD3" , IIF( worigem == 3 , "FOL" , IIF( worigem == 4 , "SE5", "ALL" ) ) ) )

	DbSelectArea("SZQ")
	ProcRegua(RecCount())
	If Empty(cDoc)
		DbSetOrder(4)

		DbSeek(xFilial("SZQ")+cEmpAnt+cFilAnt+Dtos(dta_ini),.t.)

		While SZQ->(!Eof()) .And. SZQ->ZQ_FILIAL == xFilial("SZQ") .And. SZQ->ZQ_CODEMP == cEmpAnt+Left(cFilAnt,3);
		.and. SZQ->ZQ_CODFIL == Right(cFilAnt,2) .And. SZQ->ZQ_DTDIGIT <= dta_fin

			IncProc("Limpando  - Data: "+Dtoc(SZQ->ZQ_DTDIGIT))

			IF SZQ->ZQ_NUM == '000011111'
				_lPare := .T.
			Endif

			If     worigem == 1 .And. !SZQ->ZQ_ORIG $ "SD1/SD2"
				SZQ->(DbSkip())
				Loop
			ElseIf worigem == 2 .And. !SZQ->ZQ_ORIG $ "SD3"
				SZQ->(DbSkip())
				Loop
			ElseIf worigem == 3 .And. !SZQ->ZQ_ORIG $ "FOL/EXT"
				SZQ->(DbSkip())
				Loop
			ElseIf worigem == 4 .And. !SZQ->ZQ_ORIG $ "SE1/SE2/SE5"
				SZQ->(DbSkip())
				Loop
			Endif

			SZQ->(RecLock("SZQ",.F.))
			SZQ->(DBDELETE())
			SZQ->(MsUnlock())

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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³PXH15_01  ³ Autor ³ NILTON CESAR          ³ Data ³ 19.11.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Arquivo de Resumo  de CC                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN - Menu atualiza‡äes                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function PXH15_01()

	Local wArea    := getArea()
	Private dbaixa := ctod(space(8))
	Private wNat   := ""
	Private wFilial

	DbSelectArea("SD1")
	ProcRegua(RecCount())

	If Empty(cDoc)

		_cq := " SELECT * FROM "+RetSqlName("SD1")+" A WHERE D1_FILIAL = '"+xFilial("SD1")+"' "
		_cq += " AND D1_DTDIGIT BETWEEN '"+DTOS(dta_ini)+"' AND '"+DTOS(dta_fin)+"' AND D_E_L_E_T_  = '' "
		_cQ += " ORDER BY D1_DTDIGIT,D1_DOC,D1_SERIE "

		TCQUERY _cQ NEW ALIAS "ZD1"

		TCSETFIELD("ZD1","D1_EMISSAO","D")
		TCSETFIELD("ZD1","D1_DTDIGIT","D")
		TCSETFIELD("ZD1","D1_DATORI","D")

		ZD1->(dbGotop())

		While ZD1->(!Eof())

			dbaixa := ctod(space(8))
			IncProc("NF entrada - Data: "+Dtoc(ZD1->D1_DTDIGIT))

			IF ZD1->D1_DOC == '000011111'
				_lPare := .T.
			Endif

			SD1->(DbSetOrder(1))
			SD1->(msSeek(xFilial("SD1")+ZD1->D1_DOC+ZD1->D1_SERIE+ZD1->D1_FORNECE+ZD1->D1_LOJA))

			fGrava('ZD1')

			If ZD1->D1_VALICM > 0
				fGrava("ZD1","ICMS")
			Endif

			If ZD1->D1_VALIPI > 0
				fGrava("ZD1","IPI")
			Endif

			If ZD1->D1_VALIMP5 > 0
				fGrava("ZD1","COFINS")
			Endif

			If ZD1->D1_VALIMP6 > 0
				fGrava("ZD1","PIS")
			Endif

			If ZD1->D1_ICMSRET > 0
				fGrava("ZD1","ST")
			Endif

			ZD1->(DbSkip())
		EndDo

		ZD1->(dbCloseArea())

		_cq := " SELECT * FROM "+RetSqlName("SD2")+" A WHERE D2_FILIAL = '"+xFilial("SD2")+"' "
		_cq += " AND D2_EMISSAO BETWEEN '"+DTOS(dta_ini)+"' AND '"+DTOS(dta_fin)+"' AND D_E_L_E_T_  = '' "
		_cQ += " ORDER BY D2_EMISSAO,D2_DOC,D2_SERIE "

		TCQUERY _cQ NEW ALIAS "ZD2"

		TCSETFIELD("ZD2","D2_EMISSAO","D")

		ZD2->(dbGotop())

		While ZD2->(!Eof())

			dbaixa := ctod(space(8))
			IncProc("NF Saida - Data: "+Dtoc(ZD2->D2_EMISSAO))

			fGrava('SD2')

			If ZD2->D2_VALICM > 0
				fGrava("SD2","ICMS")
			Endif

			If ZD2->D2_VALIPI > 0
				fGrava("SD2","IPI")
			Endif

			If ZD2->D2_VALIMP5 > 0
				fGrava("SD2","COFINS")
			Endif

			If ZD2->D2_VALIMP6 > 0
				fGrava("SD2","PIS")
			Endif

			If ZD2->D2_ICMSRET > 0
				fGrava("SD2","ST")
			Endif

			ZD2->(DbSkip())
		EndDo

		ZD2->(dbCloseArea())

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


Static Function FPROCFIN1(wOrigem,wTpLancto)

	_cQ := " SELECT * FROM "+RetSqlName("SE1")+" A WHERE A.D_E_L_E_T_ = '' "
	_cQ += " AND LEFT(E1_ORIGEM,4) <>  'MATA' AND E1_EMISSAO BETWEEN '"+DTOS(dta_ini)+"' AND '"+DTOS(dta_fin)+"' AND E1_TIPO NOT IN ('RA','NCC')"
	_cQ += " ORDER BY E1_EMISSAO,E1_NUM,E1_PARCELA "

	TCQUERY _cQ NEW ALIAS "ZE1"

	TCSETFIELD("ZE1","E1_EMISSAO","D")
	TCSETFIELD("ZE1","E1_VENCTO" ,"D")
	TCSETFIELD("ZE1","E1_VENCREA","D")
	TCSETFIELD("ZE1","E1_BAIXA"  ,"D")

	ZE1->(dbGotop())

	ProcRegua(ZE1->(U_CONTREG()))

	While ZE1->(!Eof())

		IncProc("Contas a Receber - Data: "+DTOC(ZE1->E1_EMISSAO))

		SED->(dbSetorder(1))
		SED->(dbSeek(xFilial("SED")+ZE1->E1_NATUREZ))

		SA1->(dbSetorder(1))
		SA1->(dbSeek(xFilial("SA1")+ ZE1->E1_CLIENTE + ZE1->E1_LOJA))

		SM0->(dbSetOrder(1))
		SM0->(dbSeek(cEmpAnt+cFilAnt))

		dbSelectArea("SZQ")
		SZQ->(Reclock("SZQ",.T.))
		SZQ->ZQ_FILIAL    := xFilial("SZQ")
		SZQ->ZQ_PREFIXO	  := ZE1->E1_PREFIXO
		SZQ->ZQ_NUM 	  := ZE1->E1_NUM
		SZQ->ZQ_PARCELA   := ZE1->E1_PARCELA
		SZQ->ZQ_TIPO      := ZE1->E1_TIPO
		SZQ->ZQ_NATUREZ   := ZE1->E1_NATUREZ
		SZQ->ZQ_NATSYS    := POSICIONE('SED',1,XFILIAL('SED')+SZQ->ZQ_NATUREZ,'ED_YCOD')
		SZQ->ZQ_CLIENTE   := ZE1->E1_CLIENTE
		SZQ->ZQ_LOJA      := ZE1->E1_LOJA
		SZQ->ZQ_DESCORI   := "CONTAS A RECEBER"
		SZQ->ZQ_EMISSAO   := ZE1->E1_EMISSAO
		SZQ->ZQ_ANOMES	  := LEFT(DTOS(ZE1->E1_EMISSAO),6)
		SZQ->ZQ_DTDIGIT	  := ZE1->E1_EMISSAO
		SZQ->ZQ_VENCTO    := ZE1->E1_VENCTO
		SZQ->ZQ_VENCREA   := ZE1->E1_VENCREA
		SZQ->ZQ_NOME      := SA1->A1_NOME
		SZQ->ZQ_BAIXA     := ZE1->E1_BAIXA
		SZQ->ZQ_YCC	      := ZE1->E1_CCC
		SZQ->ZQ_VALLIQ    := ZE1->E1_VALLIQ
		SZQ->ZQ_TOTAL	  := ZE1->E1_VALOR
		SZQ->ZQ_CUSCTB	  := ZE1->E1_VALOR
		SZQ->ZQ_CODEMP	  := cEmpAnt+Left(cFilAnt,3)
		SZQ->ZQ_CODFIL	  := Right(cFilAnt,2)
		SZQ->ZQ_NOMEMP	  := ALLTRIM(SM0->M0_FILIAL)
		SZQ->ZQ_NOMFIL	  := SM0->M0_FILIAL

		CTT->(dbSetOrder(1))
		CTT->(dbSeek(xFilial("CTT")+SZQ->ZQ_YCC))

		SZQ->ZQ_CONTA		:= fContaCtb("SE1")
		SZQ->ZQ_DCUSTO		:= CTT->CTT_DESC01
		SZQ->ZQ_DITEMC		:= Posicione("CTD",1,xFilial("CTD")+SZQ->ZQ_ITEMCTA,"CTD_DESC01")
		SZQ->ZQ_DCLASSV	    := Posicione("CTH",1,xFilial("CTH")+SZQ->ZQ_CLVL,"CTH_DESC01")
		SZQ->ZQ_DCONTA 	    := Posicione("CT1",1,xFilial("CT1")+SZQ->ZQ_CONTA ,"CT1_DESC01")
		SZQ->ZQ_ORIG        :=  "SE1"
		SZQ->ZQ_OBS 		:= ZE1->E1_HIST
		SZQ->(MsUnlock())

		ZE1->(dbSkip())
	EndDo

	ZE1->(dbCloseArea())

Return


Static Function FPROCFIN2(wOrigem,wTpLancto)

	_cQ := " SELECT * FROM "+RetSqlName("SE2")+" A WHERE A.D_E_L_E_T_ = '' "
	_cQ += " AND LEFT(E2_ORIGEM,4) NOT IN ('MATA','GPEM') AND E2_EMIS1 BETWEEN '"+DTOS(dta_ini)+"' AND '"+DTOS(dta_fin)+"' AND E2_TIPO NOT IN ('PA','NDF')"
	_cQ += " ORDER BY E2_EMIS1 ,E2_NUM,E2_PARCELA "

	TCQUERY _cQ NEW ALIAS "ZE2"

	TCSETFIELD("ZE2","E2_EMIS1"  ,"D")
	TCSETFIELD("ZE2","E2_EMISSAO","D")
	TCSETFIELD("ZE2","E2_VENCTO" ,"D")
	TCSETFIELD("ZE2","E2_VENCREA","D")
	TCSETFIELD("ZE2","E2_BAIXA"  ,"D")

	ZE2->(dbGotop())

	ProcRegua(ZE2->(U_CONTREG()))

	While ZE2->(!Eof())

		IncProc("Contas a Pagar - Data: "+DTOC(ZE2->E2_EMIS1))

		SED->(dbSetorder(1))
		SED->(dbSeek(xFilial("SED")+ ZE2->E2_NATUREZ))

		SA2->(dbSetorder(1))
		SA2->(dbSeek(xFilial("SA2")+ ZE2->E2_FORNECE + ZE2->E2_LOJA))

		SM0->(dbSetOrder(1))
		SM0->(dbSeek(cEmpAnt + cFilAnt))

		dbSelectArea("SZQ")
		SZQ->(Reclock("SZQ",.T.))
		SZQ->ZQ_FILIAL    := xFilial("SZQ")
		SZQ->ZQ_PREFIXO	  := ZE2->E2_PREFIXO
		SZQ->ZQ_NUM 	  := ZE2->E2_NUM
		SZQ->ZQ_PARCELA   := ZE2->E2_PARCELA
		SZQ->ZQ_TIPO      := ZE2->E2_TIPO
		SZQ->ZQ_NATUREZ   := ZE2->E2_NATUREZ
		SZQ->ZQ_NATSYS    := POSICIONE('SED',1,XFILIAL('SED')+SZQ->ZQ_NATUREZ,'ED_YCOD')
		SZQ->ZQ_LOJA      := ZE2->E2_LOJA
		SZQ->ZQ_DESCORI   := "CONTAS A PAGAR"
		SZQ->ZQ_EMISSAO   := ZE2->E2_EMISSAO
		SZQ->ZQ_ANOMES	  := LEFT(DTOS(ZE2->E2_EMIS1),6)
		SZQ->ZQ_DTDIGIT	  := ZE2->E2_EMIS1
		SZQ->ZQ_VENCTO    := ZE2->E2_VENCTO
		SZQ->ZQ_VENCREA   := ZE2->E2_VENCREA
		SZQ->ZQ_NOME      := SA2->A2_NOME
		SZQ->ZQ_BAIXA     := ZE2->E2_BAIXA
		SZQ->ZQ_YCC	      := ZE2->E2_CCD
		SZQ->ZQ_VALLIQ    := ZE2->E2_VALLIQ
		SZQ->ZQ_TOTAL	  := ZE2->E2_VALOR
		SZQ->ZQ_CUSCTB	  := ZE2->E2_VALOR
		SZQ->ZQ_CODEMP	  := cEmpAnt+Left(cFilAnt,3)
		SZQ->ZQ_CODFIL	  := Right(cFilAnt,2)
		SZQ->ZQ_NOMEMP	  := ALLTRIM(SM0->M0_FILIAL)
		SZQ->ZQ_NOMFIL	  := SM0->M0_FILIAL

		CTT->(dbSetOrder(1))
		CTT->(dbSeek(xFilial("CTT")+SZQ->ZQ_YCC))

		SZQ->ZQ_CONTA		:= fContaCtb("SE2")
		SZQ->ZQ_DCUSTO		:= CTT->CTT_DESC01
		SZQ->ZQ_DITEMC		:= Posicione("CTD",1,xFilial("CTD")+SZQ->ZQ_ITEMCTA,"CTD_DESC01")
		SZQ->ZQ_DCLASSV	    := Posicione("CTH",1,xFilial("CTH")+SZQ->ZQ_CLVL,"CTH_DESC01")
		SZQ->ZQ_DCONTA 	    := Posicione("CT1",1,xFilial("CT1")+SZQ->ZQ_CONTA ,"CT1_DESC01")
		SZQ->ZQ_ORIG        := "SE2"
		SZQ->ZQ_OBS 		:= ZE2->E2_HIST
		SZQ->(MsUnlock())

		ZE2->(dbSkip())
	EndDo

	ZE2->(dbCloseArea())

Return

Static Function FPROCFIN3(wOrigem,wTpLancto)

	_cQ := " SELECT * FROM "+RetSqlName("SE5")+" A WHERE A.D_E_L_E_T_ = '' "
	_cQ += " AND E5_DTDISPO BETWEEN '"+DTOS(dta_ini)+"' AND '"+DTOS(dta_fin)+"' AND E5_CLIENTE <> '' AND E5_SITUACA = ''"
	_cQ += " AND E5_TIPODOC IN ('VL','BA','ES','RA') AND E5_MOTBX <> 'CMP' "
	_cQ += " ORDER BY E5_DTDISPO,E5_NUMERO,E5_PARCELA "

	TCQUERY _cQ NEW ALIAS "ZE5"

	TCSETFIELD("ZE5","E5_DTDISPO","D")
	TCSETFIELD("ZE5","E5_DTDIGIT","D")
	TCSETFIELD("ZE5","E5_DATA","D")

	ZE5->(dbGotop())

	ProcRegua(ZE5->(U_CONTREG()))

	While ZE5->(!Eof())

		IncProc("Baixas a Receber - Data: "+DTOC(ZE5->E5_DTDISPO))

		SED->(dbSetorder(1))
		SED->(dbSeek(xFilial("SED")+ZE5->E5_NATUREZ))

		SA1->(dbSetorder(1))
		SA1->(dbSeek(xFilial("SA1")+ ZE5->E5_CLIENTE + ZE5->E5_LOJA))

		SM0->(dbSetOrder(1))
		SM0->(dbSeek(cEmpAnt+cFilAnt))

		If ZE5->E5_TIPODOC = "ES"
			_nValor := (ZE5->E5_VALOR - ZE5->E5_VLMULTA - ZE5->E5_VLJUROS + ZE5->E5_VLDESCO) * -1
		Else
			_nValor := ZE5->E5_VALOR - ZE5->E5_VLMULTA - ZE5->E5_VLJUROS + ZE5->E5_VLDESCO
		Endif

		dbSelectArea("SZQ")
		SZQ->(Reclock("SZQ",.T.))
		SZQ->ZQ_FILIAL    := xFilial("SZQ")
		SZQ->ZQ_PREFIXO	  := ZE5->E5_PREFIXO
		SZQ->ZQ_NUM 	  := ZE5->E5_NUMERO
		SZQ->ZQ_PARCELA   := ZE5->E5_PARCELA
		SZQ->ZQ_TIPO      := ZE5->E5_TIPO
		SZQ->ZQ_NATUREZ   := ZE5->E5_NATUREZ
		SZQ->ZQ_NATSYS    := SED->ED_YCOD
		SZQ->ZQ_CLIENTE   := ZE5->E5_CLIENTE
		SZQ->ZQ_LOJA      := ZE5->E5_LOJA
		SZQ->ZQ_DESCORI   := "BAIXAS A RECEBER"
		SZQ->ZQ_TES       := ZE5->E5_TIPODOC
		SZQ->ZQ_EMISSAO   := ZE5->E5_DTDISPO
		SZQ->ZQ_ANOMES	  := LEFT(DTOS(ZE5->E5_DTDISPO),6)
		SZQ->ZQ_DTDIGIT	  := ZE5->E5_DTDIGIT
		SZQ->ZQ_NOME      := SA1->A1_NOME
		SZQ->ZQ_BAIXA     := ZE5->E5_DATA
		SZQ->ZQ_VALLIQ    := _nValor
		SZQ->ZQ_TOTAL	  := _nValor
		SZQ->ZQ_CUSCTB	  := 0
		SZQ->ZQ_CODEMP	  := cEmpAnt+Left(cFilAnt,3)
		SZQ->ZQ_CODFIL	  := Right(cFilAnt,2)
		SZQ->ZQ_NOMEMP	  := ALLTRIM(SM0->M0_FILIAL)
		SZQ->ZQ_NOMFIL	  := SM0->M0_FILIAL

		SZQ->ZQ_CONTA		:= fContaCtb("SE5","BXREC")
		SZQ->ZQ_DCUSTO		:= CTT->CTT_DESC01
		SZQ->ZQ_DITEMC		:= Posicione("CTD",1,xFilial("CTD")+SZQ->ZQ_ITEMCTA,"CTD_DESC01")
		SZQ->ZQ_DCLASSV	    := Posicione("CTH",1,xFilial("CTH")+SZQ->ZQ_CLVL   ,"CTH_DESC01")
		SZQ->ZQ_DCONTA 	    := Posicione("CT1",1,xFilial("CT1")+SZQ->ZQ_CONTA  ,"CT1_DESC01")
		SZQ->ZQ_ORIG        := "SE5"
		SZQ->ZQ_ORIG2       := "BXREC"
		SZQ->ZQ_OBS 		:= ZE5->E5_HISTOR
		SZQ->ZQ_DESCONT     := ZE5->E5_VLDESCO
		SZQ->ZQ_MULTA       := ZE5->E5_VLMULTA
		SZQ->ZQ_JUROS       := ZE5->E5_VLJUROS
		SZQ->ZQ_CORREC      := ZE5->E5_VLCORREC

		SZQ->(MsUnlock())

		ZE5->(dbSkip())
	EndDo

	ZE5->(dbCloseArea())

Return

Static Function FPROCFIN4(wOrigem,wTpLancto)

	_cQ := " SELECT * FROM "+RetSqlName("SE5")+" A WHERE A.D_E_L_E_T_ = '' "
	_cQ += " AND E5_DTDISPO BETWEEN '"+DTOS(dta_ini)+"' AND '"+DTOS(dta_fin)+"' AND E5_FORNECE <> '' AND E5_SITUACA = ''"
	_cQ += " AND E5_TIPODOC IN ('VL','BA','ES','PA') AND E5_MOTBX <> 'CMP' "
	_cQ += " ORDER BY E5_DTDISPO,E5_NUMERO,E5_PARCELA "

	TCQUERY _cQ NEW ALIAS "ZE5"

	TCSETFIELD("ZE5","E5_DTDISPO","D")
	TCSETFIELD("ZE5","E5_DTDIGIT","D")
	TCSETFIELD("ZE5","E5_DATA","D")

	ZE5->(dbGotop())

	ProcRegua(ZE5->(U_CONTREG()))

	While ZE5->(!Eof())

		IncProc("Baixas a Pagar - Data: "+DTOC(ZE5->E5_DTDISPO))

		SED->(dbSetorder(1))
		SED->(dbSeek(xFilial("SED")+ZE5->E5_NATUREZ))

		SA2->(dbSetorder(1))
		SA2->(dbSeek(xFilial("SA2")+ ZE5->E5_FORNECE + ZE5->E5_LOJA))

		SM0->(dbSetOrder(1))
		SM0->(dbSeek(cEmpAnt+cFilAnt))

		If ZE5->E5_TIPODOC = "ES"
			_nValor := (ZE5->E5_VALOR - ZE5->E5_VLMULTA - ZE5->E5_VLJUROS + ZE5->E5_VLDESCO) * -1
		Else
			_nValor := ZE5->E5_VALOR - ZE5->E5_VLMULTA - ZE5->E5_VLJUROS + ZE5->E5_VLDESCO
		Endif

		dbSelectArea("SZQ")
		SZQ->(Reclock("SZQ",.T.))
		SZQ->ZQ_FILIAL    := xFilial("SZQ")
		SZQ->ZQ_PREFIXO	  := ZE5->E5_PREFIXO
		SZQ->ZQ_NUM 	  := ZE5->E5_NUMERO
		SZQ->ZQ_PARCELA   := ZE5->E5_PARCELA
		SZQ->ZQ_TIPO      := ZE5->E5_TIPO
		SZQ->ZQ_NATUREZ   := ZE5->E5_NATUREZ
		SZQ->ZQ_NATSYS    := SED->ED_YCOD
		SZQ->ZQ_FORNECE   := ZE5->E5_FORNECE
		SZQ->ZQ_LOJA      := ZE5->E5_LOJA
		SZQ->ZQ_DESCORI   := "BAIXAS A PAGAR"
		SZQ->ZQ_TES       := ZE5->E5_TIPODOC
		SZQ->ZQ_EMISSAO   := ZE5->E5_DTDISPO
		SZQ->ZQ_ANOMES	  := LEFT(DTOS(ZE5->E5_DTDISPO),6)
		SZQ->ZQ_DTDIGIT	  := ZE5->E5_DTDIGIT
		SZQ->ZQ_NOME      := SA2->A2_NOME
		SZQ->ZQ_BAIXA     := ZE5->E5_DATA
		SZQ->ZQ_VALLIQ    := _nValor
		SZQ->ZQ_TOTAL	  := _nValor
		SZQ->ZQ_CUSCTB	  := 0
		SZQ->ZQ_CODEMP	  := cEmpAnt+Left(cFilAnt,3)
		SZQ->ZQ_CODFIL	  := Right(cFilAnt,2)
		SZQ->ZQ_NOMEMP	  := ALLTRIM(SM0->M0_FILIAL)
		SZQ->ZQ_NOMFIL	  := SM0->M0_FILIAL
		SZQ->ZQ_CONTA	  := fContaCtb("SE5","BXPAG")
		SZQ->ZQ_DCUSTO	  := CTT->CTT_DESC01
		SZQ->ZQ_DITEMC	  := Posicione("CTD",1,xFilial("CTD")+SZQ->ZQ_ITEMCTA,"CTD_DESC01")
		SZQ->ZQ_DCLASSV	  := Posicione("CTH",1,xFilial("CTH")+SZQ->ZQ_CLVL   ,"CTH_DESC01")
		SZQ->ZQ_DCONTA 	  := Posicione("CT1",1,xFilial("CT1")+SZQ->ZQ_CONTA  ,"CT1_DESC01")
		SZQ->ZQ_ORIG      := "SE5"
		SZQ->ZQ_ORIG2     := "BXPAG"
		SZQ->ZQ_OBS 	  := ZE5->E5_HISTOR
		SZQ->ZQ_DESCONT   := ZE5->E5_VLDESCO
		SZQ->ZQ_MULTA     := ZE5->E5_VLMULTA
		SZQ->ZQ_JUROS     := ZE5->E5_VLJUROS
		SZQ->ZQ_CORREC    := ZE5->E5_VLCORREC

		SZQ->(MsUnlock())

		ZE5->(dbSkip())
	EndDo

	ZE5->(dbCloseArea())

Return


Static Function FPROCFIN5(wOrigem,wTpLancto)

	Local wAlias := 'SE5'

	If xFilial("SZQ") != cFilAnt .and. Right(cFilAnt,2) <> "01"
		Return()
	Endif

	If wOrigem == Nil
		Processa( {|| FPROCSQL() } , "Aguarde!", "Montando filtro  no SE5")
		//wAlias := 'TRB'
	Endif

	dbSelectArea("TRB")
	If ! TRB->(Eof()) .And. !  TRB->(Bof())
		ProcRegua(IIf(wAlias=='TRB',wregs,1))
		While !  TRB->(Eof())

			IncProc()
			If  wAlias=='TRB'
				IncProc("Financeiro - Data: "+dtoc(stod( TRB->E5_DATA)))
			Endif

			SED->(dbSetorder(1))
			SED->(dbSeek(xFilial("SED")+TRB->E5_NATUREZ))

			dbSelectArea("SZQ")
			Reclock("SZQ",.T.)
			SZQ->ZQ_FILIAL    := xFilial("SZQ")
			SZQ->ZQ_PREFIXO	  :=  TRB->E5_PREFIXO
			SZQ->ZQ_NUM 	  :=  TRB->E5_NUMERO
			SZQ->ZQ_PARCELA   :=  TRB->E5_PARCELA
			SZQ->ZQ_TIPO      :=  TRB->E5_TIPO
			SZQ->ZQ_NATUREZ   :=  TRB->E5_NATUREZ
			SZQ->ZQ_NATSYS    := posicione('SED',1,xfilial('SED')+szq->zq_naturez,'ED_YCOD')
			SZQ->ZQ_FORNECE	  :=  TRB->E5_CLIFOR
			SZQ->ZQ_LOJA      :=  TRB->E5_LOJA
			SZQ->ZQ_DESCORI   := "MOV BCO"
			//wData:=IIf(wAlias=='TRB',stod( TRB->E5_DATA), TRB->E5_DATA)

			SZQ->ZQ_EMISSAO 	:= TRB->E5_DATA
			SZQ->ZQ_ANOMES		:= LEFT(DTOS(TRB->E5_DATA),6 )
			SZQ->ZQ_DTDIGIT	    := TRB->E5_DATA
			SZQ->ZQ_VENCTO  	:= TRB->E5_DATA
			SZQ->ZQ_VENCREA 	:= TRB->E5_DATA
			If TRB->E5_RECPAG == 'P'
				SA2->(dbSetorder(1))
				SA2->(dbSeek(xFilial("SA2")+TRB->E5_CLIFOR+TRB->E5_LOJA))

				SZQ->ZQ_NOME    := IIF( !EMPTY(TRB->E5_CLIFOR) ,POSICIONE('SA2',1,XFILIAL('SA2')+TRB->E5_CLIFOR+TRB->E5_LOJA,"A2_NOME"),   TRB->E5_BENEF )
				SZQ->ZQ_ORIG2   := "MOVPAG"
				_cImp           := "MOVPAG"
			Else
				SA1->(dbSetorder(1))
				SA1->(dbSeek(xFilial("SA1")+TRB->E5_CLIFOR+TRB->E5_LOJA))

				SZQ->ZQ_NOME    := IIF( !EMPTY(TRB->E5_CLIFOR) ,POSICIONE('SA1',1,XFILIAL('SA1')+TRB->E5_CLIFOR+TRB->E5_LOJA,"A1_NOME"),   TRB->E5_BENEF )
				SZQ->ZQ_ORIG2   := "MOVREC"
				_cImp           := "MOVREC"
			Endif

			SZQ->ZQ_BAIXA   	:= TRB->E5_DATA
			SZQ->ZQ_DESCONT 	:= TRB->E5_VLDESCO
			SZQ->ZQ_MULTA       := TRB->E5_VLMULTA
			SZQ->ZQ_JUROS       := TRB->E5_VLJUROS
			SZQ->ZQ_CORREC      := TRB->E5_VLCORREC
			SZQ->ZQ_VALIPI      := 0
			SZQ->ZQ_VALICM      := 0
			SZQ->ZQ_RATEIO	    := 0
			SZQ->ZQ_INSS    	:= 0
			SZQ->ZQ_IRRF   	    := 0
			SZQ->ZQ_CLIENTE     := ""
			SZQ->ZQ_QUANT       := 0
			SZQ->ZQ_PRODUTO 	:= ""
			SZQ->ZQ_VALLIQ  	:= TRB->E5_VALOR
			SZQ->ZQ_TOTAL		:= TRB->E5_VALOR
			SZQ->ZQ_CUSCTB		:= TRB->E5_VALOR

			SM0->(dbSetOrder(1))
			SM0->(dbSeek(cEmpAnt+cFilAnt))
			DbSelectArea("SZQ")
			SZQ->ZQ_CODEMP		:= cEmpAnt+Left(cFilAnt,3)	//Codg Empresa
			SZQ->ZQ_CODFIL		:= Right(cFilAnt,2)		//Codg Filial
			SZQ->ZQ_NOMEMP		:= ALLTRIM(SM0->M0_FILIAL) //Nome Empresa
			SZQ->ZQ_NOMFIL		:= SM0->M0_FILIAL //Nome Filial

			CTT->(dbSetOrder(1))
			CTT->(dbSeek(xFilial("CTT")+SZQ->ZQ_YCC))
			DbSelectArea("SZQ")

			SZQ->ZQ_CONTA		:= fContaCtb("SE5",_cImp)

			SZQ->ZQ_DCUSTO		:= CTT->CTT_DESC01//Descrição do CENTRO DE CUSTO
			SZQ->ZQ_DITEMC		:= Posicione("CTD",1,xFilial("CTD")+SZQ->ZQ_ITEMCTA,"CTD_DESC01")//Descrição do ITEM CONTÁBIL
			SZQ->ZQ_DCLASSV	    := Posicione("CTH",1,xFilial("CTH")+SZQ->ZQ_CLVL,"CTH_DESC01")//Descrição da CLASSE DE VALOR
			SZQ->ZQ_DCONTA 	    := Posicione("CT1",1,xFilial("CT1")+SZQ->ZQ_CONTA ,"CT1_DESC01")//Descrição do CONTA CONTÁBIL
			IF wAlias=='SE5'
				SZQ->ZQ_ORIG        :=  "SE5"
			ELSE
				SZQ->ZQ_ORIG        :=  IIF(  TRB->ESTORNO == -1, "SE2", "SE5")
			ENDIF

			SZQ->ZQ_OBS := TRB->E5_HISTOR
			SZQ->(MsUnlock())

			DbSelectArea( (wAlias))

			TRB->(DbSkip())

		EndDo
	EndIf

Return

Static Function fContaCtb(wAlias,_cIMP)

	local warea:= getArea()
	Local cCodCtb := ""
	Local cLC520002 := '520003'//LANCAMENTO PADRÃO DE BAIXAS A RECEBER DESCONTO CONCEDIDO (DEBITO)
	Local cLC520003 := '520004'//LANCAMENTO PADRÃO DE BAIXAS A RECEBER MULTA OBTIDAS (CREDITO)
	Local cLC520004 := '520004'//LANCAMENTO PADRÃO DE BAIXAS A RECEBER JUROS OBTIDOS (CREDITO)
	Local cLC530003 := '530003'//LANCAMENTO PADRÃO DE BAIXAS A PAGAR JUROS E MULTA (DEBITO)
	Local cLC530005 := '530005'//LANCAMENTO PADRÃO DE BAIXAS A PAGAR DESCONTO OBTIDOS (CREDITO)
	Local cLC562001 := '562001'//DESPESAS BANCARIAS - PAGAR (DEBITO)
	Local cLC563001 := '563001'//DESPESAS BANCARIAS - RECEBER (CREDITO)
	Local cLC501001 := '501001'//RECEBIMENTO ANTECIPADO - CREDITO
	Local cLC513001 := '513001'//PAGAMENTO ANTECIPADO - DEBITO
	Local cLC610001 := '610001'//ITEM DA NOTA FISCAL
	Local cLCA03001 := 'A03001'//FOLHA DE PAGAMENTO
	local cErr:=''

	CTADEB := CTACRED := SPACE(20)

	If wAlias == "SD2"
		Private _CTESLP := ZD2->D2_TES
		If _cIMP 	 == "ICMS"
			_cLP    := "610006"
			cCodCtb := Posicione("CT5",1,xFilial("CT5")+_cLP,"CT5_DEBITO")
			cCodCtb := IIF(EMPTY(cCodCtb), ""  ,cCodCtb)
			cErr:='err'+_cLP
		ElseIf _cIMP == "IPI"
			_cLP    := ""
			cCodCtb := Posicione("CT5",1,xFilial("CT5")+_cLP,"CT5_DEBITO")
			cCodCtb := IIF(EMPTY(cCodCtb), ""  ,cCodCtb)
			cErr:='err'+_cLP
		ElseIf _cIMP == "PIS"
			_cLP    := "610004"
			cCodCtb := Posicione("CT5",1,xFilial("CT5")+_cLP,"CT5_DEBITO")
			cCodCtb := IIF(EMPTY(cCodCtb), ""  ,cCodCtb)
			cErr:='err'+_cLP
		ElseIf _cIMP == "COFINS"
			_cLP    := "610005"
			cCodCtb := Posicione("CT5",1,xFilial("CT5")+_cLP,"CT5_DEBITO")
			cCodCtb := IIF(EMPTY(cCodCtb), ""  ,cCodCtb)
			cErr:='err'+_cLP
		ElseIf _cIMP == "ST"
			_cLP    := ""
			cCodCtb := Posicione("CT5",1,xFilial("CT5")+_cLP,"CT5_DEBITO")
			cCodCtb := IIF(EMPTY(cCodCtb), ""  ,cCodCtb)
			cErr:='err'+_cLP
		Else
			cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC610001,"CT5_CREDIT")
			cCodCtb := IIF(EMPTY(cCodCtb), "31101092001"  ,cCodCtb)
			cErr:='err'+cLC610001
		Endif
	ElseIf wAlias $ "SD1/ZD1"
		Private _CTESLP := (wAlias)->D1_TES
		If _cIMP 	 == "ICMS"
			_cLP    := "650002"
			cCodCtb := Posicione("CT5",1,xFilial("CT5")+_cLP,"CT5_CREDIT")
			cCodCtb := IIF(EMPTY(cCodCtb), ""  ,cCodCtb)
			cErr:='err'+_cLP
		ElseIf _cIMP == "IPI"
			_cLP    := "650003"
			cCodCtb := Posicione("CT5",1,xFilial("CT5")+_cLP,"CT5_CREDIT")
			cCodCtb := IIF(EMPTY(cCodCtb), ""  ,cCodCtb)
			cErr:='err'+_cLP
		ElseIf _cIMP == "PIS"
			_cLP    := "650004"
			cCodCtb := Posicione("CT5",1,xFilial("CT5")+_cLP,"CT5_CREDIT")
			cCodCtb := IIF(EMPTY(cCodCtb), ""  ,cCodCtb)
			cErr:='err'+_cLP
		ElseIf _cIMP == "COFINS"
			_cLP    := "650005"
			cCodCtb := Posicione("CT5",1,xFilial("CT5")+_cLP,"CT5_CREDIT")
			cCodCtb := IIF(EMPTY(cCodCtb), ""  ,cCodCtb)
			cErr:='err'+_cLP
		ElseIf _cIMP == "ST"
			_cLP    := ""
		//	cCodCtb := Posicione("CT5",1,xFilial("CT5")+_cLP,"CT5_CREDIT")
		//	cCodCtb := IIF(EMPTY(cCodCtb), ""  ,cCodCtb)
			cErr:='err'+_cLP
		Else
			//cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC610001,"CT5_CREDITO")
			cCodCtb := (wAlias)->D1_CONTA
			cErr:='err'+cLC610001
		Endif

	ElseIf wAlias == "SE1"
		_cLp    := "500001"
		cCodCtb := Posicione("CT5",1,xFilial("CT5")+_cLP,"CT5_CREDIT")
		cCodCtb := Iif(EMPTY(cCodCtb), SPACE(20),cCodCtb)
		cErr:='err'+_cLp
	ElseIf wAlias == "SE2"
		_cLp    := "510001"
		cCodCtb := Posicione("CT5",1,xFilial("CT5")+_cLP,"CT5_DEBITO")
		cCodCtb := Iif(EMPTY(cCodCtb), SPACE(20),cCodCtb)
		cErr:='err'+_cLp
	ElseIf wAlias == "FOL"
		If FOL->RV_TIPOCOD $ "1/3"
			cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLCA03001,"CT5_DEBITO")
		Else
			cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLCA03001,"CT5_CREDIT")
		Endif
		cCodCtb := IIF(EMPTY(cCodCtb), ""  ,cCodCtb)
		cErr:='err'+cLCA03001
	ElseIf wAlias == "SE5"

		If _cIMP == "BXREC"
			_cLp    := "520002" // CREDITO
			cCodCtb := Posicione("CT5",1,xFilial("CT5")+_cLP,"CT5_CREDIT")
			cCodCtb := Iif(EMPTY(cCodCtb), SPACE(20),cCodCtb)
			cErr:='err'+_cLp
		ElseIf _cIMP == "BXPAG"
			_cLp    := "530002" // DEBITO
			cCodCtb := Posicione("CT5",1,xFilial("CT5")+_cLP,"CT5_DEBITO")
			cCodCtb := Iif(EMPTY(cCodCtb), SPACE(20),cCodCtb)
			cErr:='err'+_cLp
		Else
			_aAliSE5 := SE5->(GetArea())

			SE5->(dbGoto(TRB->NUMRECNO))

			IF 	TRB->(Rtrim(E5_TIPO) == "PA" .AND. E5_RECPAG == "P")	//PAGAMENTO ANTECIPADO
				cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC513001,"CT5_DEBITO")
				cCodCtb := IIF(EMPTY(cCodCtb), "11230001"  ,cCodCtb)
				cErr:='err'+cLC513001
			ELSEIF TRB->(Rtrim(E5_TIPO) == "RA" .AND. E5_RECPAG == "R")	//RECEBIMENTO ANTECIPADO
				cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC501001,"CT5_CREDIT")
				cErr:='err'+cLC501001
			ELSEIF TRB->(Rtrim(E5_TIPODOC) == "JR" .AND. E5_RECPAG == "R") //CONTA CONTABIL DE JUROS OBTIDOS
				cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC520004,"CT5_CREDIT")
				cErr:='err'+cLC520004
			ELSEIF TRB->(Rtrim(E5_TIPODOC) == "JR" .AND. E5_RECPAG == "P") //CONTA CONTABIL DE JUROS PAGOS
				cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC530003,"CT5_DEBITO")
				cErr:='err'+cLC530003
			ELSEIF TRB->(Rtrim(E5_TIPODOC) == "MT" .AND. E5_RECPAG == "P") //CONTA CONTABIL DE MULTAS PAGAS
				cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC530003,"CT5_DEBITO")
				cErr:='err'+cLC530003
			ELSEIF TRB->(Rtrim(E5_TIPODOC) == "MT" .AND. E5_RECPAG == "R") //CONTA CONTABIL DE MULTAS OBTIDAS
				cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC520003,"CT5_CREDIT")
				cErr:='err'+cLC520003
			ELSEIF TRB->(Rtrim(E5_TIPODOC) == "DC" .AND. E5_RECPAG == "P") //CONTA CONTABIL DE DESCONTOS OBTIDOS
				cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC530005,"CT5_CREDIT")
				cErr:='err'+cLC530005
			ELSEIF TRB->(Rtrim(E5_TIPODOC) == "DC" .AND. E5_RECPAG == "R") //CONTA CONTABIL DE DESCONTOS CONCEDIDOS
				cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC520002,"CT5_DEBITO")
				cErr:='err'+cLC520002
			ELSEIF TRB->E5_RECPAG == "R" .AND. (Rtrim(TRB->E5_NATUREZ) $ GetMV('MV_SZQNAT1') .OR. Rtrim(TRB->E5_NATUREZ) $ GetMV('MV_SZQNAT2') .OR. Rtrim(TRB->E5_NATUREZ) $ GetMV('MV_SZQNAT3')).OR. Rtrim(TRB->E5_NATUREZ) $ GetMV('MV_SZQNAT4')
				cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC563001,"CT5_CREDIT")
				cErr:='err'+cLC563001
			ELSEIF TRB->E5_RECPAG == "P" .AND. (Rtrim(TRB->E5_NATUREZ) $ GetMV('MV_SZQNAT1') .OR. Rtrim(TRB->E5_NATUREZ) $ GetMV('MV_SZQNAT2'))	//CONTA CONTABIL DA CPMF PAGAS OU CONTA CONTABIL DA TARIFAS BANCARIAS PAGAS
				cCodCtb := Posicione("CT5",1,xFilial("CT5")+cLC562001,"CT5_DEBITO")
				cErr:='err'+cLC562001
			ENDIF
		Endif
	Endif

	If !EMPTY(cCodCtb)
		cCodCtb := &(cCodCtb)
	Else
		cCodCtb := cErr
	Endif

	do case
		case valtype(cCodCtb)=='N'
		cCodCtb:= alltrim( str(cCodCtb, TamSX3("CT1_CONTA")[1] ) )
		case valtype(cCodCtb)<>'C'
		cCodCbb:=''
	endcase

Return( cCodCtb )



Static Function fGrava(wOrigem,_cIMP)

	private cSigla:=''

	xCodFil := ""

	SZQ->(Reclock("SZQ",.T.))
	SZQ->ZQ_FILIAL   	:= xFilial("SZQ")

	If wOrigem $ 'SD1/ZD1'
		SF4->(dbSetOrder(1))
		SF4->(dbSeek(xFilial("SF4")+(wOrigem)->D1_TES))

		SF1->(dbsetorder(1))
		SF1->(dbseek( xfilial('SF1')+ (wOrigem)->(d1_doc + d1_serie + d1_fornece + d1_loja ) ) )

		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+(wOrigem)->D1_COD))

		SA2->(DbSetOrder(1))
		SA2->(DbSeek(xFilial("SA2")+(wOrigem)->D1_FORNECE+(wOrigem)->D1_LOJA))

		SC7->(dbSetOrder(1))
		SC7->(dbSeek(xFilial("SC7")+(wOrigem)->D1_PEDIDO +(wOrigem)->D1_ITEMPC))

		CTT->(dbSetOrder(1))
		CTT->(dbSeek(xFilial("CTT")+(wOrigem)->D1_CC ))

		SZQ->ZQ_CONTA	:= fContaCtb(wOrigem,_cIMP)
		SZQ->ZQ_YCC		:= (wOrigem)->D1_CC
		SZQ->ZQ_CLVL   	:= (wOrigem)->D1_CLVL
		SZQ->ZQ_ITEMCTA := IIF(SF4->F4_DUPLIC=="S", (wOrigem)->D1_ITEMCTA, CriaVar("ZQ_ITEMCTA",.F.) )
		SZQ->ZQ_PREFIXO	:= (wOrigem)->D1_SERIE
		SZQ->ZQ_NUM 	:= (wOrigem)->D1_DOC
		SZQ->ZQ_TIPO    := (wOrigem)->D1_TIPO
		SZQ->ZQ_FORNECE := (wOrigem)->D1_FORNECE
		SZQ->ZQ_LOJA    := (wOrigem)->D1_LOJA
		SZQ->ZQ_EMISSAO := (wOrigem)->D1_EMISSAO
		SZQ->ZQ_CONHEC  := (wOrigem)->D1_CONHEC
		SZQ->ZQ_DESCORI := "COMPRAS"
		SZQ->ZQ_DESCRIC := (wOrigem)->D1_YDESPRO
		SZQ->ZQ_NOME    := SA2->A2_NOME
		SZQ->ZQ_EST     := SA2->A2_EST
		SZQ->ZQ_MUN     := SA2->A2_MUN

		wVencto		    := (wOrigem)->D1_EMISSAO
		wVencrea	    := (wOrigem)->D1_EMISSAO
		_dbaixa		    := CTOD("")
		_cNat  		    := ""

		SE2->(dbSetOrder(6))
		If SE2->(dbSeek(xFilial("SE2") + (wOrigem)->D1_FORNECE + (wOrigem)->D1_LOJA + (wOrigem)->D1_SERIE + (wOrigem)->D1_DOC))

			_cChavSE2 := SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM

			While SE2->(!Eof()) .And. _cChavSE2 == SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM

				_dbaixa		:= SE2->E2_BAIXA
				_cNat  		:= SE2->E2_NATUREZ
				wVencto	    := SE2->E2_VENCTO
				wVencrea	:= SE2->E2_VENCREA
				SE2->(dbSkip())
			EndDo
		Endif

		SZQ->ZQ_VENCTO    := wVencto
		SZQ->ZQ_VENCREA   := wVencrea
		SZQ->ZQ_NATUREZ   := _cNat
		SZQ->ZQ_NATSYS    := Posicione('SED',1,xfilial('SED')+SZQ->ZQ_NATUREZ,'ED_YCOD')
		SZQ->ZQ_BAIXA     := _dbaixa
		SZQ->ZQ_DESCONT   := (wOrigem)->D1_VALDESC
		SZQ->ZQ_MULTA     := 0				//Multa
		SZQ->ZQ_JUROS     := 0				//Juros
		SZQ->ZQ_CORREC    := 0				//Correcao

		SZQ->ZQ_PRODUTO   := (wOrigem)->D1_COD
		SZQ->ZQ_ORIG	  := "SD1"
		SZQ->ZQ_ORIG2 	  := _cImp
		SZQ->ZQ_ANOMES	  := Left(DtoS((wOrigem)->D1_DTDIGIT),6)
		SZQ->ZQ_DTDIGIT	  := (wOrigem)->D1_DTDIGIT
		SZQ->ZQ_QUANT     := (wOrigem)->D1_QUANT
		SZQ->ZQ_VUNIT     := (wOrigem)->D1_VUNIT
		SZQ->ZQ_VALISS	  := (wOrigem)->D1_VALISS
		SZQ->ZQ_DESPESA	  := (wOrigem)->D1_DESPESA
		SZQ->ZQ_SEGURO	  := (wOrigem)->D1_SEGURO
		SZQ->ZQ_VALDESC	  := (wOrigem)->D1_VALDESC
		SZQ->ZQ_VALFRE	  := (wOrigem)->D1_VALFRE
		SZQ->ZQ_VRETPIS	  := SF1->F1_VALPIS
		SZQ->ZQ_VRETCOF	  := SF1->F1_VALCOFI
		SZQ->ZQ_VRETCSL	  := SF1->F1_VALCSLL
		SZQ->ZQ_INSS      := (wOrigem)->D1_VALINS
		SZQ->ZQ_IRRF   	  := (wOrigem)->D1_VALIRR
		SZQ->ZQ_VCRDPIS	  := (wOrigem)->D1_VALIMP6
		SZQ->ZQ_VCRDCOF	  := (wOrigem)->D1_VALIMP5
		SZQ->ZQ_VCRDCSL	  := (wOrigem)->D1_VALIMP4
		SZQ->ZQ_ICMSRET	  := (wOrigem)->D1_ICMSRET
		SZQ->ZQ_TES		  := (wOrigem)->D1_TES
		SZQ->ZQ_CF		  := (wOrigem)->D1_CF
		SZQ->ZQ_NFORI	  := (wOrigem)->D1_NFORI
		SZQ->ZQ_SERIORI	  := (wOrigem)->D1_SERIORI
		SZQ->ZQ_ITEMORI	  := (wOrigem)->D1_ITEMORI
		SZQ->ZQ_DATORI	  := (wOrigem)->D1_DATORI
		SZQ->ZQ_PEDIDO    := (wOrigem)->D1_PEDIDO
		SZQ->ZQ_ITEMPC	  := (wOrigem)->D1_ITEMPC
		SZQ->ZQ_FORTRAN	  := (wOrigem)->D1_LOTEFOR
		SZQ->ZQ_LJFRTRA	  := '01'
		SZQ->ZQ_PLACA	  := (wOrigem)->D1_PLACA
		SZQ->ZQ_TEXTO	  := SF4->F4_TEXTO
		SZQ->ZQ_DUPLIC	  := SF4->F4_DUPLIC
		SZQ->ZQ_OBS		  := SC7->C7_OBS
		SZQ->ZQ_QTDTRA 	  := SC7->C7_QUANT
		SZQ->ZQ_COND	  := SF1->F1_COND
		SZQ->ZQ_ESPECIE	  := SF1->F1_ESPECIE

		If (wOrigem)->D1_TIPO <> "D"
			If     _cImp == "ICMS"
				SZQ->ZQ_DESCORI := "COMPRAS-ICMS"
				SZQ->ZQ_VALLIQ  := (wOrigem)->D1_VALICM
				SZQ->ZQ_TOTAL	:= (wOrigem)->D1_VALICM
				SZQ->ZQ_CUSCTB	:= 0

			ElseIf _cImp == "IPI"
				SZQ->ZQ_DESCORI := "COMPRAS-IPI"
				SZQ->ZQ_VALLIQ  := (wOrigem)->D1_VALIPI
				SZQ->ZQ_TOTAL	:= (wOrigem)->D1_VALIPI
				SZQ->ZQ_CUSCTB	:= 0

			ElseIf _cImp == "PIS"
				SZQ->ZQ_DESCORI := "COMPRAS-PIS"
				SZQ->ZQ_VALLIQ  := (wOrigem)->D1_VALIMP6
				SZQ->ZQ_TOTAL	:= (wOrigem)->D1_VALIMP6
				SZQ->ZQ_CUSCTB	:= 0

			ElseIf _cImp == "COFINS"
				SZQ->ZQ_DESCORI := "COMPRAS-COFINS"
				SZQ->ZQ_VALLIQ  := (wOrigem)->D1_VALIMP5
				SZQ->ZQ_TOTAL	:= (wOrigem)->D1_VALIMP5
				SZQ->ZQ_CUSCTB	:= 0

			ElseIf _cImp == "ST"
				SZQ->ZQ_DESCORI := "COMPRAS-ST"
				SZQ->ZQ_VALLIQ  := (wOrigem)->D1_ICMSRET
				SZQ->ZQ_TOTAL	:= (wOrigem)->D1_ICMSRET
				SZQ->ZQ_CUSCTB	:= 0
				SZQ->ZQ_ICMSRET	:= 0
			Else
				SZQ->ZQ_VALLIQ    := (wOrigem)->D1_CUSTO
				SZQ->ZQ_TOTAL	  := ((wOrigem)->(D1_TOTAL+D1_VALIPI+D1_DESPESA+D1_SEGURO+D1_VALFRE-D1_VALDESC))
				SZQ->ZQ_CUSCTB	  := (wOrigem)->D1_CUSTO
				SZQ->ZQ_VALIPI    := (wOrigem)->D1_VALIPI
				SZQ->ZQ_VALICM    := (wOrigem)->D1_VALICM
			Endif
		Else
			If     _cImp == "ICMS"
				SZQ->ZQ_DESCORI := "COMPRAS-ICMS"
				SZQ->ZQ_VALLIQ  := (wOrigem)->D1_VALICM * -1
				SZQ->ZQ_TOTAL	:= (wOrigem)->D1_VALICM * -1
				SZQ->ZQ_CUSCTB	:= 0

			ElseIf _cImp == "IPI"
				SZQ->ZQ_DESCORI := "COMPRAS-IPI"
				SZQ->ZQ_VALLIQ  := (wOrigem)->D1_VALIPI * -1
				SZQ->ZQ_TOTAL	:= (wOrigem)->D1_VALIPI * -1
				SZQ->ZQ_CUSCTB	:= 0

			ElseIf _cImp == "PIS"
				SZQ->ZQ_DESCORI := "COMPRAS-PIS"
				SZQ->ZQ_VALLIQ  := (wOrigem)->D1_VALIMP6 * -1
				SZQ->ZQ_TOTAL	:= (wOrigem)->D1_VALIMP6 * -1
				SZQ->ZQ_CUSCTB	:= 0

			ElseIf _cImp == "COFINS"
				SZQ->ZQ_DESCORI := "COMPRAS-COFINS"
				SZQ->ZQ_VALLIQ  := (wOrigem)->D1_VALIMP5 * -1
				SZQ->ZQ_TOTAL	:= (wOrigem)->D1_VALIMP5 * -1
				SZQ->ZQ_CUSCTB	:= 0

			ElseIf _cImp == "ST"
				SZQ->ZQ_DESCORI := "COMPRAS-ST"
				SZQ->ZQ_VALLIQ  := (wOrigem)->D1_ICMSRET * -1
				SZQ->ZQ_TOTAL	:= (wOrigem)->D1_ICMSRET * -1
				SZQ->ZQ_CUSCTB	:= 0
				SZQ->ZQ_ICMSRET	:= 0
			Else
				SZQ->ZQ_VALLIQ    := (wOrigem)->D1_CUSTO * -1
				SZQ->ZQ_TOTAL	  := ((wOrigem)->(D1_TOTAL+D1_VALIPI+D1_DESPESA+D1_SEGURO+D1_VALFRE-D1_VALDESC)) * -1
				SZQ->ZQ_CUSCTB	  := (wOrigem)->D1_CUSTO * -1
				SZQ->ZQ_VALIPI    := (wOrigem)->D1_VALIPI * -1
				SZQ->ZQ_VALICM    := (wOrigem)->D1_VALICM * -1
			Endif
		Endif

		xCodFil := Right((wOrigem)->D1_FILIAL,2)

	Elseif wOrigem=='SD2'
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+ ZD2->D2_COD))

		SF4->(dbSetOrder(1))
		SF4->(dbSeek(xFilial("SF4")+ZD2->D2_TES))

		SF2->(dbsetorder(1))
		SF2->(dbseek( xfilial('SF2')+ ZD2->D2_DOC + ZD2->D2_SERIE + ZD2->D2_CLIENTE + ZD2->D2_LOJA ) )

		_cConta := ""
		_cCR    := ""
		SBZ->(dbSetorder(1))
		If SBZ->(dbSeek(xFilial("SBZ")+ SB1->B1_COD))
			_cConta := SBZ->BZ_YCONTA
			_cCR    := SB1->B1_CC
		Endif

		SZQ->ZQ_CONTA	:= fContaCtb("SD2",_cIMP)

		SZQ->ZQ_YCC		:= _cCR
		SZQ->ZQ_CLVL   	:= ZD2->D2_CLVL
		SZQ->ZQ_PREFIXO	:= ZD2->D2_SERIE
		SZQ->ZQ_NUM 	:= ZD2->D2_DOC
		SZQ->ZQ_TIPO    := ZD2->D2_TIPO
		SZQ->ZQ_LOJA    := ZD2->D2_LOJA
		SZQ->ZQ_EMISSAO := ZD2->D2_EMISSAO
		SZQ->ZQ_DESCRIC := SB1->B1_DESC

		_dVencto := ZD2->D2_EMISSAO
		_dVencRea:= ZD2->D2_EMISSAO
		_dBaixa  := CTOD("")
		_cNat    := ""

		SE1->(dbSetOrder(2))
		If SE1->(dbSeek(xFilial("SE1")+ SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_SERIE + SF2->F2_DOC))
			_dBaixa  := SE1->E1_BAIXA
			_dVencto := SE1->E1_VENCTO
			_dVencRea:= SE1->E1_VENCREA
			_cNat    := SE1->E1_NATUREZ
		Endif

		SZQ->ZQ_VENCTO    := _dVencto
		SZQ->ZQ_VENCREA   := _dVencRea
		SZQ->ZQ_NATUREZ   := _cNat
		SZQ->ZQ_NATSYS    := Posicione('SED',1,xfilial('SED')+SZQ->ZQ_NATUREZ,'ED_YCOD')
		SZQ->ZQ_BAIXA     := _dBaixa
		SZQ->ZQ_DESCONT   := ZD2->D2_DESCON
		SZQ->ZQ_MULTA     := 0
		SZQ->ZQ_JUROS     := 0
		SZQ->ZQ_CORREC    := 0
		SZQ->ZQ_CLIENTE   := ZD2->D2_CLIENTE
		SZQ->ZQ_PRODUTO   := ZD2->D2_COD
		SZQ->ZQ_ORIG	  := "SD2"
		SZQ->ZQ_ORIG2 	  := _cImp

		SZQ->ZQ_ANOMES	  := Left(DTOS(ZD2->D2_EMISSAO),6)
		SZQ->ZQ_DTDIGIT	  := ZD2->D2_EMISSAO
		SZQ->ZQ_QUANT     := ZD2->D2_QUANT
		SZQ->ZQ_VUNIT     := ZD2->D2_PRCVEN
		SZQ->ZQ_VALISS	  := 0 //ZD2->D2_VALISS
		SZQ->ZQ_DESPESA	  := 0 //ZD2->D2_DESPESA
		SZQ->ZQ_SEGURO	  := 0 //ZD2->D2_SEGURO
		SZQ->ZQ_VALDESC	  := 0 //ZD2->D2_DESCON
		SZQ->ZQ_VALFRE	  := 0 //ZD2->D2_VALFRE
		SZQ->ZQ_VRETPIS	  := 0 //SF2->F2_VALPIS
		SZQ->ZQ_VRETCOF	  := 0 //SF2->F2_VALCOFI
		SZQ->ZQ_VRETCSL	  := 0 //SF2->F2_VALCSLL
		SZQ->ZQ_INSS      := 0 //ZD2->D2_VALINS
		SZQ->ZQ_IRRF   	  := 0 //ZD2->D2_VALIRRF
		SZQ->ZQ_VCRDPIS	  := 0 //ZD2->D2_VALIMP6
		SZQ->ZQ_VCRDCOF	  := 0 //ZD2->D2_VALIMP5
		SZQ->ZQ_VCRDCSL	  := 0 //ZD2->D2_VALIMP4
		SZQ->ZQ_TES		  := ZD2->D2_TES
		SZQ->ZQ_CF		  := ZD2->D2_CF
		SZQ->ZQ_NFORI	  := ZD2->D2_NFORI
		SZQ->ZQ_SERIORI	  := ZD2->D2_SERIORI
		SZQ->ZQ_ITEMORI	  := ZD2->D2_ITEMORI
		SZQ->ZQ_PEDIDO    := ZD2->D2_PEDIDO
		SZQ->ZQ_LJFRTRA	  := '01'
		SZQ->ZQ_TEXTO	  := SF4->F4_TEXTO
		SZQ->ZQ_DUPLIC	  := SF4->F4_DUPLIC
		SZQ->ZQ_QTDTRA 	  := ZD2->D2_QUANT
		SZQ->ZQ_COND	  := SF2->F2_COND
		SZQ->ZQ_ESPECIE	  := SF2->F2_ESPECIE

		If     _cImp == "ICMS"
			SZQ->ZQ_DESCORI := "FATURAMENTO-ICMS"
			SZQ->ZQ_VALLIQ  := ZD2->D2_VALICM
			SZQ->ZQ_TOTAL	:= ZD2->D2_VALICM
			SZQ->ZQ_CUSCTB	:= 0

		ElseIf _cImp == "IPI"
			SZQ->ZQ_DESCORI := "FATURAMENTO-IPI"
			SZQ->ZQ_VALLIQ  := ZD2->D2_VALIPI
			SZQ->ZQ_TOTAL	:= ZD2->D2_VALIPI
			SZQ->ZQ_CUSCTB	:= 0

		ElseIf _cImp == "PIS"
			SZQ->ZQ_DESCORI := "FATURAMENTO-PIS"
			SZQ->ZQ_VALLIQ  := ZD2->D2_VALIMP6
			SZQ->ZQ_TOTAL	:= ZD2->D2_VALIMP6
			SZQ->ZQ_CUSCTB	:= 0

		ElseIf _cImp == "COFINS"
			SZQ->ZQ_DESCORI := "FATURAMENTO-COFINS"
			SZQ->ZQ_VALLIQ  := ZD2->D2_VALIMP5
			SZQ->ZQ_TOTAL	:= ZD2->D2_VALIMP5
			SZQ->ZQ_CUSCTB	:= 0

		ElseIf _cImp == "ST"
			SZQ->ZQ_DESCORI := "FATURAMENTO-ICMS ST"
			SZQ->ZQ_VALLIQ  := ZD2->D2_ICMSRET
			SZQ->ZQ_TOTAL	:= ZD2->D2_ICMSRET
			SZQ->ZQ_CUSCTB	:= 0
			SZQ->ZQ_ICMSRET	:= 0
		Else
			SZQ->ZQ_DESCORI := "FATURAMENTO"
			SZQ->ZQ_VALLIQ  := ZD2->D2_CUSTO1
			SZQ->ZQ_TOTAL	:= ZD2->(D2_TOTAL+D2_VALIPI+D2_DESPESA+D2_SEGURO+D2_VALFRE-D2_DESCON )
			SZQ->ZQ_CUSCTB	:= ZD2->D2_TOTAL - ZD2->D2_VALICM - ZD2->D2_VALIMP5 - ZD2->D2_VALIMP6
			SZQ->ZQ_ICMSRET	:= ZD2->D2_ICMSRET
		Endif

		xCodFil           := Right(ZD2->D2_FILIAL,2)

	ElseIf wOrigem=='FOL'

		SZQ->ZQ_CONTA	:= FOL->CONTA
		SZQ->ZQ_YCC     := FOL->CC
		SZQ->ZQ_CLVL   	:= FOL->CLVL
		SZQ->ZQ_NOME    := FOL->OBS
		SZQ->ZQ_DESCORI := "FOLHA"
		SZQ->ZQ_CUSCTB  := FOL->VALOR
		SZQ->ZQ_NUM 	:= FOL->DOC
		SZQ->ZQ_DESCRIC := Posicione("SRV",1,xFilial("SRV") + FOL->TM,"RV_DESC")
		SZQ->ZQ_TEXTO	:= POSICIONE('SRV',1,XFILIAL('SRV') + FOL->TM,"RV_DESC")
		SZQ->ZQ_EMISSAO := FOL->EMISSAO
		SZQ->ZQ_DESCORI := "FOLHA"
		SZQ->ZQ_VALLIQ  := FOL->VALOR
		SZQ->ZQ_TOTAL	:= FOL->VALOR
		SZQ->ZQ_CUSCTB	:= FOL->VALOR
		SZQ->ZQ_ORIG	:= "FOL"
		SZQ->ZQ_ANOMES	:= LEFT(DTOS(FOL->EMISSAO),6)
		SZQ->ZQ_DTDIGIT	:= FOL->EMISSAO
		SZQ->ZQ_QUANT   := 1
		SZQ->ZQ_VUNIT   := FOL->VALOR
		SZQ->ZQ_TES		:= FOL->TM

		xCodFil           := Right(FOL->FILIAL,2)

	Elseif wOrigem=='SD3'
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+ZD3->D3_COD))

		CTT->(dbSetOrder(1))
		CTT->(dbSeek(xFilial("CTT") + ZD3->D3_CC ))

		SZQ->ZQ_CONTA	:= Posicione("SBZ",1,xFilial("SB1")+ZD3->D3_COD,"BZ_YCONTA")
		SZQ->ZQ_YCC     := ZD3->D3_CC
		SZQ->ZQ_CLVL   	:= ZD3->D3_CLVL
		SZQ->ZQ_ITEMCTA := ZD3->D3_ITEMCTA
		SZQ->ZQ_NUM 	:= ZD3->D3_DOC
		SZQ->ZQ_FORNECE := ZD3->D3_CC
		SZQ->ZQ_EMISSAO := ZD3->D3_EMISSAO
		SZQ->ZQ_DESCORI := "ESTOQUE"
		SZQ->ZQ_ORIG	:= "SD3"
		SZQ->ZQ_PRODUTO := ZD3->D3_COD
		SZQ->ZQ_DESCRIC := SB1->B1_DESC
		SZQ->ZQ_CUSCTB	:= ZD3->D3_CUSTO1
		SZQ->ZQ_TOTAL	:= ZD3->D3_CUSTO1 * IIF( ZD3->D3_TM <= '499',-1 ,1)
		SZQ->ZQ_ANOMES	:= Left(DtoS(ZD3->D3_EMISSAO),6)
		SZQ->ZQ_DTDIGIT	:= ZD3->D3_EMISSAO
		SZQ->ZQ_QUANT   := ZD3->D3_QUANT	* IIF(ZD3->D3_TM <= '499',-1 ,1)
		SZQ->ZQ_VUNIT   := ZD3->D3_CUSTO1	* IIF(ZD3->D3_TM <= '499',-1 ,1)
		SZQ->ZQ_TES		:= ZD3->D3_TM
		SZQ->ZQ_CF		:= ZD3->D3_CF
		SZQ->ZQ_TEXTO	:= POSICIONE('SF5',1,XFILIAL('SF5')+ZD3->D3_TM,"F5_TEXTO")
		SZQ->ZQ_OBS		:= ZD3->D3_OBS
		xCodFil 		:= Right(ZD3->D3_FILIAL,2)

	Elseif wOrigem=='SE1'
		SZQ->ZQ_DESCORI := "CONTAS A RECEBER"
		SZQ->ZQ_ORIG2   := "CRECEB"
	Elseif wOrigem=='SE2'
		SZQ->ZQ_ORIG2   := "CPAGAR"
		SZQ->ZQ_DESCORI := "CONTAS A PAGAR"
	Elseif wOrigem=='SE5'
		SZQ->ZQ_DESCORI := "MOVIMENTACAO BANCARIA"
		SZQ->ZQ_ORIG2   := "MOVBCO"
	Endif

	SZQ->ZQ_DCUSTO		:= Posicione("CTT",1,xFilial("CTT")+SZQ->ZQ_YCC    ,"CTT_DESC01")//Descrição do CENTRO DE CUSTO
	SZQ->ZQ_DITEMC		:= Posicione("CTD",1,xFilial("CTD")+SZQ->ZQ_ITEMCTA,"CTD_DESC01")//Descrição do ITEM CONTÁBIL
	SZQ->ZQ_DCLASSV	    := Posicione("CTH",1,xFilial("CTH")+SZQ->ZQ_CLVL   ,"CTH_DESC01")//Descrição da CLASSE DE VALOR
	SZQ->ZQ_DCONTA 	    := Posicione("CT1",1,xFilial("CT1")+SZQ->ZQ_CONTA  ,"CT1_DESC01")//Descrição do CONTA CONTÁBIL
	SZQ->ZQ_RATEIO	    := 0
	SZQ->ZQ_TPPROD      := POSICIONE("SB1",1,xFilial("SB1")+SZQ->ZQ_PRODUTO,"SB1->B1_TIPO")

	xCodFil := iif(Empty(xCodFil), Right(cFilAnt,2), xCodFil)

	SM0->(dbSetOrder(1))
	SM0->(dbSeek(cEmpAnt+cFilAnt))

	SZQ->ZQ_CODEMP	:= cEmpAnt+Left(cFilAnt,3)
	SZQ->ZQ_CODFIL	:= xCodFil
	SZQ->ZQ_NOMFIL	:= SM0->M0_FILIAL
	SZQ->ZQ_NOMEMP	:= ALLTRIM(SM0->M0_FILIAL)
	SZQ->(MsUnLock())

Return

Static Function fprocSQL(wRecPag,wAcao,wTpLancto)

	Local cQuery := ""
	ProcRegua(2)
	IncProc("Monta Query")

	//TARIFAS BANCARIAS - PAGAMENTO
	//#################################
	cQuery+= "SELECT  E5_TIPODOC, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_NATUREZ, E5_CLIFOR, "+CRLF
	cQuery+= "E5_LOJA, E5_DATA, E5_BENEF, E5_VLDESCO, E5_VLMULTA, E5_VLJUROS, "+CRLF
	cQuery+= "E5_VLCORRE, E5_RECPAG, E5_VALOR,0 AS ESTORNO,'', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO "+CRLF
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
	cQuery+= "E5_VLCORRE, E5_RECPAG, (E5_VALOR * -1 ) AS E5_VALOR,0 AS ESTORNO,'', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO "+CRLF
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

	// APORTE FINANCEIRO
	//#################################
	cQuery+= " UNION ALL "+CRLF
	cQuery+= "SELECT  E5_TIPODOC, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_NATUREZ, E5_CLIFOR, "+CRLF
	cQuery+= "E5_LOJA, E5_DATA, E5_BENEF, E5_VLDESCO, E5_VLMULTA, E5_VLJUROS, "+CRLF
	cQuery+= "E5_VLCORRE, E5_RECPAG, E5_VALOR  AS E5_VALOR,0 AS ESTORNO,'', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO "+CRLF
	cQuery+= " FROM "+RetSQLName("SE5")+CRLF
	cQuery+= "WHERE D_E_L_E_T_ = ' '  "+CRLF
	cQuery+= "AND E5_FILIAL = "+xFilial("SE5")+" "+CRLF
	cQuery+= "AND E5_DATA BETWEEN '"+dtos(dta_ini)+"' AND '"+dtos(dta_fin)+"'  "+CRLF
	cQuery+= "AND E5_NATUREZ IN ( "+GetMV('MV_SZQNAT4')+ " )  "+CRLF   // PARAMETRO PARA NATUREZA DE APORTE FINANCEIRO
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
	cQuery+= "E5_VLCORRE, E5_RECPAG, ( E5_VALOR  ),0 AS ESTORNO,'', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO"+CRLF
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
	cQuery+= "E5_VLCORRE, E5_RECPAG, ( E5_VALOR ),0 AS ESTORNO,'', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO "+CRLF
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
	cQuery+= "E5_VLCORRE, E5_RECPAG,( E5_VALOR ) AS E5_VALOR, 0 AS ESTORNO,'', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO "+CRLF
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
	cQuery+= "E5_VLCORRE, E5_RECPAG,E5_VALOR,0 AS ESTORNO,'', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO "+CRLF
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
	cQuery+= "E5_VLCORRE, E5_RECPAG,E5_VALOR,0 AS ESTORNO,'', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO "+CRLF
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
	cQuery+= "E5_VLCORRE, E5_RECPAG,E5_VALOR,0 AS ESTORNO,'', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO "+CRLF
	cQuery+= "FROM "+RetSQLName("SE5") + CRLF
	cQuery+= "WHERE D_E_L_E_T_ = ' '  "+CRLF
	cQuery+= "AND E5_FILIAL = "+xFilial("SE5")+" "+CRLF
	cQuery+= "AND E5_TIPODOC = 'DC' "+CRLF
	cQuery+= "AND (E5_PREFIXO <> '   ' OR E5_NUMERO <> '      ' OR E5_PARCELA <> ' ') "+CRLF
	cQuery+= "AND E5_TIPO <> '  ' "+CRLF
	cQuery+= "AND E5_SITUACA = ' ' "+CRLF
	cQuery+= "AND E5_RECPAG = 'R' "+CRLF
	cQuery+= "AND E5_DATA BETWEEN '"+dtos(dta_ini)+"' AND '"+dtos(dta_fin)+"'  "+CRLF


	//APLICAÇÃO FINANCEIRA
	//#########################
	cQuery+= " UNION ALL "+CRLF
	cQuery+= "SELECT  E5_TIPODOC, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_NATUREZ, E5_CLIFOR, "+CRLF
	cQuery+= "E5_LOJA, E5_DATA, E5_BENEF, E5_VLDESCO, E5_VLMULTA, E5_VLJUROS, "+CRLF
	cQuery+= "E5_VLCORRE, E5_RECPAG,E5_VALOR, 0 AS ESTORNO,'', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO "+CRLF
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
	cQuery+= "E5_VLCORRE, E5_RECPAG, E5_VALOR,0 AS ESTORNO,'', E5_HISTOR,R_E_C_N_O_ AS NUMRECNO "+CRLF
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

	TCSETFIELD("TRB","E5_DATA","D")

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

		_cq := " SELECT * FROM "+RetSqlName("SD3")+" A WHERE D3_FILIAL = '"+xFilial("SD3")+"' "
		_cq += " AND D3_EMISSAO BETWEEN '"+DTOS(dta_ini)+"' AND '"+DTOS(dta_fin)+"' AND D_E_L_E_T_  = '' "
		_cQ += " ORDER BY D3_EMISSAO,D3_DOC "

		TCQUERY _cQ NEW ALIAS "ZD3"

		TCSETFIELD("ZD3","D3_EMISSAO","D")

		ZD3->(dbGotop())

		While ZD3->(!Eof())

			dbaixa := ctod(space(8))
			IncProc("Movimentos Internos - Data: "+Dtoc(ZD3->D3_EMISSAO))

			DbSelectArea("SZQ")

			FGrava('SD3')

			ZD3->(DbSkip())
		EndDo

		ZD3->(dbCloseArea())
	Else

		fGrava('SD3')

	EndIf

Return


Static Function fProcFOL()

	cQuery :=" SELECT (CASE LEFT(CT2_DEBITO,1) WHEN '3'	  THEN CT2_DEBITO ELSE CT2_CREDIT END) CONTA, "+CRLF
	cQuery +="	     (CASE LEFT(CT2_DEBITO,1) WHEN '3'    THEN CT2_CCD    ELSE CT2_CCC    END) CC, "+CRLF
	cQuery +="	     (CASE LEFT(CT2_DEBITO,1) WHEN '3'	  THEN CT2_ITEMD  ELSE CT2_ITEMC  END) ITEMCTA, "+CRLF
	cQuery +="	     (CASE LEFT(CT2_DEBITO,1) WHEN '3'	  THEN CT2_CLVLDB ELSE CT2_CLVLCR END) CLVL, "+CRLF
	cQuery +="	   (CASE CT2_LOTE           WHEN '008890' THEN 'FOL'	 WHEN '008891' THEN 'FOL'  WHEN '000002' THEN 'RAT' ELSE 'EXT' END) ORIGEM, "+CRLF
	cQuery +="	   "+ValToSql(cFilAnt)+" FILIAL,  "+CRLF
	cQuery +="     CT2_DATA EMISSAO,  "+CRLF
	cQuery +="     CT2_DOC DOC,  "+CRLF
	cQuery +="	   ' ' PREF,  "+CRLF
	cQuery +="     1 QUANT, "+CRLF
	cQuery +="     ' ' COD, "+CRLF
	cQuery +="     LEFT(CT2_HIST,3) AS TM, "+CRLF
	cQuery +="     CT2_HIST OBS,  "+CRLF
	cQuery +="	   ((CASE LEFT(CT2_DEBITO,1) WHEN '3' THEN 1 ELSE -1 END) * CT2_VALOR ) VALOR FROM "+RetSqlName("CT2")+CRLF
	cQuery +="  WHERE D_E_L_E_T_ = '' "+CRLF
	cQuery +="  AND CT2_FILIAL = "+ValToSql(xFilial("CT2"))+CRLF
	cQuery +="  AND CT2_DATA BETWEEN "+ValToSql(dta_ini)+" AND "+ValToSql(dta_fin)+CRLF
	cQuery +="  AND CT2_LOTE IN ('000001','000002','008890','008891') "+CRLF
	cQuery +="  AND '3' IN (LEFT(CT2_DEBITO,1), LEFT(CT2_CREDIT,1))"

	MemoWrit("szqfolha.sql",cQuery)

	If Select('FOL') > 0
		dbSelectArea("FOL")
		DbCloseArea()
	Endif

	TCQuery cQuery NEW ALIAS "FOL"

	TcSetField("FOL","EMISSAO","D")

	FOL->(dbGotop())

	While FOL->(!Eof())

		IncProc("Folha Pagamento - Data: "+Dtoc(FOL->EMISSAO))

		FGrava('FOL')

		FOL->(DbSkip())
	EndDo

	FOL->(dbCloseArea())

Return


Static Function PXH15A()

	_cVis1 := Alltrim(GetMv("PXH_VISAO2")) 

	_cVisao := "('"
	For Ax:= 1 To Len(_cVis1)
		If Substr(_cVis1,AX,1) != "*"
			_cVisao += Substr(_cVis1,AX,1)
		Else
			_cVisao += "','"
		Endif
	Next AX

	_cVisao += "')"

	aStru	:= CTS->(DbStruct())
	// Obtem os registros a serem processados

	cQuery := " SELECT * FROM "+RetSqlName("CTS")+" CTS "
	cQuery += " WHERE CTS.D_E_L_E_T_ = '' AND CTS_CODPLA IN "+_cVisao+" "
	cQuery += " AND CTS_CT1INI <> '' AND CTS_FILIAL = '"+xFilial("CTS")+"' "
	cQuery += " ORDER BY CTS_CODPLA,CTS_ORDEM "

	TCQUERY cQuery NEW ALIAS "NEWCTS"

	MemoWrit("CTSQRY.sql",cQuery)
	
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
			//Verifica Crédito
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