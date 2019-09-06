#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ CR0086   ³ Autor ³ Fabiano da silva      ³ Data ³ 13.01.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio  Rejeitos da produção                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaEst                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CR0086()
	
	titulo 	 := "Relatorio de Rejeito"
	cDesc1 	 := "Relatorio Rejeito por Categoria ou Por Operador"
	cDesc2 	 := ""
	cDesc3 	 := ""
	cabec1	 := ""
	cabec2   := ""
	tamanho	 := "M"
	limite 	 := 132
	cString	 := "SD3"
	nOrdem 	 := 0
	
	Private nTipo    := 18
	PRIVATE aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
	PRIVATE nomeprog := "CR0086"
	PRIVATE aLinha   := { },nLastKey := 0
	PRIVATE cPerg    := "CR0086"
	Private lAbortPrint  := .F.
	
	cbtxt    		 := SPACE(10)
	cbcont   		 := 0
	li       		 :=80
	m_pag    		 :=1
	
	pergunte("CR0086",.F.)
	
	///////////////////////////////////////
	///// MV_PAR01 : Data De ?         ////
	///// MV_PAR02 : Data Ate ?        ////
	///// MV_PAR03 : Produto de ?      ////
	///// MV_PAR04 : Produto ate ?     ////
	///// MV_PAR05 : Operador de ?     ////
	///// MV_PAR06 : Operador ate ?    ////
	///// MV_PAR07 : Tipo rejeito de ? ////
	///// MV_PAR08 : Tipo rejeito ate ?////
	///////////////////////////////////////
	
	wnrel:="CR0086"
	aOrd :={"Por Data","Por Produto","Por Operador","Por Tipo de Rejeito"}
	
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)
	
	If nLastKey==27
		Set Filter to
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey==27
		Set Filter to
		Return
	Endif
	
	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| Proc1(@_lFim) }
	Private _cTitulo01 := 'Processando'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
	dbSelectArea("TMP")
	dbCloseArea()
	
	dbSelectArea("TRB")
	dbCloseArea()
	
Return


Static Function Proc1(_lFim)
	
	nOrdem    := aReturn[8]
	_cTpReje  := ""
	_cNomrej  := ""
	_cMotRej  := ""
	_nQtRej   := 0
	
	aCampos := {}
	AADD(aCampos,{ "DATAE"    ,"D", 08, 0 } )
	AADD(aCampos,{ "PRODUTO"  ,"C", 15, 0 } )
	AADD(aCampos,{ "CODOP"    ,"C", 06, 0 } )
	AADD(aCampos,{ "NOMOP"    ,"C", 40, 0 } )
	AADD(aCampos,{ "QTPROD"   ,"N", 14, 2 } )
	
	cArqLOG := CriaTrab(aCampos,.T.)
	cIndLOG := "DTOS(DATAE)+PRODUTO+CODOP"
	dbUseArea(.T.,,cArqLOG,"TMP",.F.,.F.)
	
	dbSelectArea("TMP")
	IndRegua("TMP",cArqLog,cIndLog,,,"Criando Trabalho...")
	
	dbSelectArea("SD3")
	dbSetOrder(6)
	dbSeek(xFilial("SD3")+Dtos(MV_PAR01),.T.)
	
	ProcRegua(LastRec())
	
	While !Eof() .And. SD3->D3_EMISSAO  <= MV_PAR02
		
		IncProc()
		
		If  SD3->D3_COD < MV_PAR03 .Or. SD3->D3_COD > MV_PAR04 .Or.;
				SD3->D3_YOPPRENA < MV_PAR05 .Or. SD3->D3_YOPPRENA > MV_PAR06
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		If SD3->D3_ESTORNO == "S"
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		If Empty(SD3->D3_YOPPREN)
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		If SD3->D3_CF != "PR0" .And. SD3->D3_TM == "102"
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		If SD3->D3_TIPO != "PA"
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		If !Empty(SD3->D3_YTURNO)
			dbSelectArea("SZA")
			dbSetOrder(1)
			dbSeek(xFilial("SZA")+SD3->D3_YTURNO)
			
			If SZA->ZA_ATIVO != "1"
				dbSelectArea("SD3")
				dbSkip()
				Loop
			Endif
			
			If (MV_PAR09 = 1 .And. SZA->ZA_LOCAL = "2") .Or.;
					(MV_PAR09 = 2 .And. SZA->ZA_LOCAL = "1")
				dbSelectArea("SD3")
				dbSkip()
				Loop
			Endif
		Endif
		
		dbSelectArea("SZ6")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ6")+SD3->D3_YOPPREN)
			
/*			If SZ6->Z6_ATIVO != "1"
				dbSelectArea("SD3")
				dbSkip()
				Loop
			Endif
	*/		
			If (MV_PAR09 = 1 .And. SZ6->Z6_LOCAL = "2") .Or.;
					(MV_PAR09 = 2 .And. SZ6->Z6_LOCAL = "1")
				dbSelectArea("SD3")
				dbSkip()
				Loop
			Endif
			
			If SZ6->Z6_TURNO < MV_PAR10 .Or. SZ6->Z6_TURNO > MV_PAR11
				dbSelectArea("SD3")
				dbSkip()
				Loop
			Endif
			
			dbSelectArea("TMP")
			If !dbSeek(DTOS(SD3->D3_EMISSAO)+SD3->D3_COD+SD3->D3_YOPPRENA)
				RecLock("TMP",.T.)
				TMP->DATAE    := SD3->D3_EMISSAO
				TMP->PRODUTO  := SD3->D3_COD
				TMP->CODOP    := SD3->D3_YOPPREN
				TMP->NOMOP    := SZ6->Z6_NOME
				TMP->QTPROD   := SD3->D3_QUANT
				MsUnlock()
			Else
				RecLock("TMP",.F.)
				TMP->QTPROD   += SD3->D3_QUANT
				MsUnlock()
			Endif
		Endif
		
		dbselectArea("SD3")
		dbSkip()
	EndDo
	
	aCampo := {}
	AADD(aCampo,{ "DATAE"   ,"D", 08, 0 } )
	//AADD(aCampo,{ "PRODUTO" ,"C", 15, 0 } )
	AADD(aCampo,{ "PRODUTO" ,"C", 06, 0 } )
	AADD(aCampo,{ "CODOP"   ,"C", 06, 0 } )
	AADD(aCampo,{ "NOMOP"   ,"C", 40, 0 } )
	AADD(aCampo,{ "TPREJ"   ,"C", 02, 0 } )
	AADD(aCampo,{ "DESREJ"  ,"C", 25, 0 } )
	AADD(aCampo,{ "QTREJ"   ,"N", 14, 2 } )
	AADD(aCampo,{ "OK"      ,"C", 02, 0 } )
	AADD(aCampo,{ "REJOPER" ,"C", 01, 0 } )
	AADD(aCampo,{ "TOTAL"   ,"N", 14, 2 } )
	
	cArqLO1 := CriaTrab(aCampo,.T.)
	cIndLO1 := "DTOS(DATAE)+PRODUTO+CODOP+TPREJ+REJOPER"
	dbUseArea(.T.,,cArqLO1,"TRB",.F.,.F.)
	
	dbSelectArea("TRB")
	IndRegua("TRB",cArqLo1,cIndLo1,,,"Criando Trabalho...")
	
	dbSelectArea("SBC")
	dbSetOrder(2)
	dbSeek(xFilial("SBC")+Dtos(MV_PAR01),.T.)
	
	ProcRegua(LastRec())
	
	While !Eof() .And. SBC->BC_DATA  <= MV_PAR02
		
		IncProc()
		
		If SBC->BC_MOTIVO < MV_PAR07 .Or. SBC->BC_MOTIVO > MV_PAR08
			dbselectarea("SBC")
			dbSkip()
			Loop
		Endif
		
		If SBC->BC_PRODUTO < MV_PAR03 .Or. SBC->BC_PRODUTO > MV_PAR04 .Or.;
				SBC->BC_APONTAD < MV_PAR05 .Or. SBC->BC_APONTAD > MV_PAR06
			dbSelectArea("SBC")
			dbSkip()
			Loop
		Endif
		
		If Empty(SBC->BC_APONTAD)
			dbSelectArea("SBC")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SBC->BC_PRODUTO)
		
		If SB1->B1_TIPO != "PA"
			dbSelectArea("SBC")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("TMP")
		If dbSeek(DTOS(SBC->BC_DATA)+SBC->BC_PRODUTO+SBC->BC_APONTAD)
			RecLock("TMP",.F.)
			TMP->QTPROD   += SBC->BC_QUANT
			MsUnlock()
		Endif
		
		dbSelectArea("SZ6")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ6")+SBC->BC_APONTAD)
			
/*			If SZ6->Z6_ATIVO != "1"
				dbSelectArea("SBC")
				dbSkip()
				Loop
			Endif
	*/		
			If (MV_PAR09 = 1 .And. SZ6->Z6_LOCAL = "2") .Or.;
					(MV_PAR09 = 2 .And. SZ6->Z6_LOCAL = "1")
				dbSelectArea("SBC")
				dbSkip()
				Loop
			Endif
			
			If SZ6->Z6_TURNO < MV_PAR10 .Or. SZ6->Z6_TURNO > MV_PAR11
				dbSelectArea("SBC")
				dbSkip()
				Loop
			Endif
			_cMotRej := TABELA("43",SBC->BC_MOTIVO,.F.)
			
			If !SBC->BC_MOTIVO $ "AC\FD\MP\MC\QN\EA\DI\MI\MD\DE\CA\FM\MF"
				
				dbSelectArea("TRB")
				If !dbSeek(DTOS(SBC->BC_DATA)+SBC->BC_PRODUTO+SBC->BC_APONTAD+SBC->BC_MOTIVO+"S")
					RecLock("TRB",.T.)
					TRB->DATAE    := SBC->BC_DATA
					TRB->PRODUTO  := SBC->BC_PRODUTO
					TRB->CODOP    := SBC->BC_APONTAD
					TRB->NOMOP    := SZ6->Z6_NOME
					TRB->TPREJ    := SBC->BC_MOTIVO
					TRB->DESREJ   := _cMotRej
					TRB->QTREJ    := SBC->BC_QUANT
					TRB->REJOPER  := "S"
					MsUnLock()
				Else
					RecLock("TRB",.F.)
					TRB->QTREJ    += SBC->BC_QUANT
					MsUnLock()
				Endif
			Else
				dbSelectArea("TRB")
				If !dbSeek(DTOS(SBC->BC_DATA)+SBC->BC_PRODUTO+SBC->BC_APONTAD+SBC->BC_MOTIVO+"N")
					RecLock("TRB",.T.)
					TRB->DATAE    := SBC->BC_DATA
					TRB->PRODUTO  := SBC->BC_PRODUTO
					TRB->CODOP    := SBC->BC_APONTAD
					TRB->NOMOP    := SZ6->Z6_NOME
					TRB->TPREJ    := SBC->BC_MOTIVO
					TRB->DESREJ   := _cMotRej
					TRB->QTREJ    := SBC->BC_QUANT
					TRB->REJOPER  := "N"
					MsUnLock()
				Else
					RecLock("TRB",.F.)
					TRB->QTREJ    += SBC->BC_QUANT
					MsUnLock()
				Endif
			Endif
			
		Endif
		
		dbSelectArea("SBC")
		dbSkip()
	EndDo
	
	dbSelectArea("SD7")
	dbSetOrder(4)
	dbSeek(xFilial("SD7")+Dtos(MV_PAR01),.T.)
	
	ProcRegua(LastRec())
	
	While !Eof() .And. SD7->D7_DATA  <= MV_PAR02
		
		IncProc()
		
		If SD7->D7_MOTREJE < MV_PAR07 .Or. SD7->D7_MOTREJE > MV_PAR08
			dbselectarea("SD7")
			dbSkip()
			Loop
		Endif
		
		If SD7->D7_PRODUTO < MV_PAR03 .Or. SD7->D7_PRODUTO > MV_PAR04 .Or.;
				SD7->D7_APONTAD < MV_PAR05 .Or. SD7->D7_APONTAD > MV_PAR06
			dbSelectArea("SD7")
			dbSkip()
			Loop
		Endif
		
		If SD7->D7_ESTORNO == "S"
			dbSelectArea("SD7")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SD7->D7_PRODUTO)
		
		If SB1->B1_TIPO != "PA"
			dbSelectArea("SD7")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SZ6")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ6")+SD7->D7_APONTAD)
			
			/*If SZ6->Z6_ATIVO != "1"
				dbSelectArea("SD7")
				dbSkip()
				Loop
			Endif*/
			
			If (MV_PAR09 = 1 .And. SZ6->Z6_LOCAL = "2") .Or.;
					(MV_PAR09 = 2 .And. SZ6->Z6_LOCAL = "1")
				dbSelectArea("SD7")
				dbSkip()
				Loop
			Endif
			
			If SZ6->Z6_TURNO < MV_PAR10 .Or. SZ6->Z6_TURNO > MV_PAR11
				dbSelectArea("SD7")
				dbSkip()
				Loop
			Endif
			
			_cNumseq := SD7->D7_NUMSEQ
			_cProd   := SD7->D7_PRODUTO
			
			_cMotRej := TABELA("43",SD7->D7_MOTREJE,.F.)
			
			If !SD7->D7_MOTREJE $ "AC\FD\MP\MC\QN\EA\DI\MI\MD\DE\CA\FM\MF"
				
				If SD7->D7_TIPO = 2
					dbSelectArea("TRB")
					If !dbSeek(DTOS(SD7->D7_DATA)+SD7->D7_PRODUTO+SD7->D7_APONTAD+SD7->D7_MOTREJE+"S")
						RecLock("TRB",.T.)
						TRB->DATAE    := SD7->D7_DATA
						TRB->PRODUTO  := SD7->D7_PRODUTO
						TRB->CODOP    := SD7->D7_APONTAD
						TRB->NOMOP    := SZ6->Z6_NOME
						TRB->TPREJ    := SD7->D7_MOTREJE
						TRB->DESREJ   := _cMotRej
						TRB->QTREJ    := SD7->D7_QTDE
						TRB->REJOPER  := "S"
						MsUnLock()
					Else
						RecLock("TRB",.F.)
						TRB->QTREJ    += SD7->D7_QTDE
						MsUnLock()
					Endif
				Endif
			Else
				If SD7->D7_TIPO = 2
					dbSelectArea("TRB")
					If !dbSeek(DTOS(SD7->D7_DATA)+SD7->D7_PRODUTO+SD7->D7_APONTAD+SD7->D7_MOTREJE+"N")
						RecLock("TRB",.T.)
						TRB->DATAE    := SD7->D7_DATA
						TRB->PRODUTO  := SD7->D7_PRODUTO
						TRB->CODOP    := SD7->D7_APONTAD
						TRB->NOMOP    := SZ6->Z6_NOME
						TRB->TPREJ    := SD7->D7_MOTREJE
						TRB->DESREJ   := _cMotRej
						TRB->QTREJ    := SD7->D7_QTDE
						TRB->REJOPER  := "N"
						MsUnLock()
					Else
						RecLock("TRB",.F.)
						TRB->QTREJ    += SD7->D7_QTDE
						MsUnLock()
					Endif
				Endif
			Endif
			
		Endif
		
		dbSelectArea("SD7")
		dbSkip()
		
	EndDo
	
	nLin := 80
	
	If nOrdem == 1
		OrdData()
	ElseIf nOrdem == 2
		OrdProd()
	ElseIf nOrdem == 3
		OrdOper()
	ElseIf nOrdem == 4
		
		dbSelectArea("TRB")
		dbGoTop()
		
		_nTotal := 0
		
		While !EOF()
			
			_nTotal += TRB->QTREJ
			
			dbSelectArea("TRB")
			dbSkip()
			
		EndDo
		
		OrdReje()
	Endif
	
	SET DEVICE TO SCREEN
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	
Return


Static Function OrdData()
	
	/*
	Ordem := DATA
	PRODUTO           OPERADOR                                      QTE PRODUZIDA       QTE REJEITO   DESCRICAO REJEITO                %
	999999999999999   9999999999999999999999999999999999999999     99999999999999    99999999999999   9999999999999999999999999   999999
	0                 18                                           63                81               98
	*/
	
	cabec1 := "PRODUTO           OPERADOR                                      QTE PRODUZIDA       QTE REJEITO   DESCRICAO REJEITO               %"
	cabec2 := ""
	
	dbSelectArea("TMP")
	dbGoTop()
	
	ProcRegua(LastRec())
	
	_dData  := ""
	_lDia   := .F.
	_nQtPDi := 0
	_nQtRDi := 0
	_nToPDi := 0
	_nToRDi := 0
	
	While !EOF()
		
		IncProc()
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 53
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			If _lDia
				@nLin,000 PSAY "DATA :" + dToc(TMP->DATAE)
				nLin++
			Endif
		Endif
		
		If _dData <> dToc(TMP->DATAE)
			If _lDia
				
				nLin++
				
				@nLin,000 PSAY "TOTAL DIA "+_dData+"    ---------->"
				@nLin,063 PSAY _nQtPDi      Picture TM(_nQtPDi,14,2)
				@nLin,081 PSAY _nQtRDi      Picture TM(_nQtRDi,14,2)
				@nLin,125 PSAY (_nQtRDi / _nQtPDi) * 100    Picture ("@E 999.99")
				nLin += 2
				
				_nToPDi  += _nQtPDi
				_nToRDi  += _nQtRDi
				_nQtPDi := 0
				_nQtRDi := 0
			Endif
			
			nLin++
			@nLin,000 PSAY "DATA :" + dToc(TMP->DATAE)
			nLin++
			_dData :=	dToc(TMP->DATAE)
		Endif
		
		_lDia := .T.
		
		@nLin,000 PSAY TMP->PRODUTO
		@nLin,018 PSAY TMP->NOMOP
		@nLin,063 PSAY TMP->QTPROD		Picture TM(TMP->QTPROD,14,2)
		
		_nQtPDi += TMP->QTPROD
		
		_lEntr := .F.
		dbSelectarea("TRB")
		If dbSeek(dTos(TMP->DATAE)+Substr(TMP->PRODUTO,1,6)+TMP->CODOP)
			_nQtRej  := 0
			_nCont   := 0
			
			_cChav := DTOS(TRB->DATAE)+TRB->PRODUTO+TRB->CODOP
			
			While !EOF() .And. _cChav == DTOS(TRB->DATAE)+TRB->PRODUTO+TRB->CODOP
				
				If TRB->REJOPER  == "N"
					dbSelectArea("TRB")
					dbSkip()
					Loop
				Endif
				
				If _nCont > 0
					nLin++
				Endif
				
				@nLin,081 PSAY TRB->QTREJ    Picture TM(TRB->QTREJ,14,2)
				@nLin,098 PSAY TRB->DESREJ
				
				dbSelectArea("TRB")
				RecLock("TRB",.F.)
				TRB->OK   := "OK"
				MsUnLock()
				
				_nCont ++
				_nQtRej += TRB->QTREJ
				_lEntr := .T.
				
				dbSelectArea("TRB")
				dbSkip()
			EndDo
			
			If _nCont > 1
				nLin++
				@nLin,081 PSAY " --------------"
				nLin++
				@nLin,081 PSAY _nQtRej        					Picture TM(_nQtRej,14,2)
			Endif
			@nLin,125 PSAY (_nQtRej / TMP->QTPROD) * 100    Picture ("@E 999.99")
			nLin ++
			_nQtRDi += _nQtRej
			
		Endif
		
		nLin ++
		
		dbSelectArea("TMP")
		dbSkip()
		
	EndDo
	
	nLin++
	
	@nLin,000 PSAY "TOTAL DIA "+_dData+"    ---------->"
	@nLin,063 PSAY _nQtPDi      Picture TM(_nQtPDi,14,2)
	@nLin,081 PSAY _nQtRDi      Picture TM(_nQtRDi,14,2)
	@nLin,125 PSAY (_nQtRDi / _nQtPDi) * 100    Picture ("@E 999.99")
	
	_nToPDi  += _nQtPDi
	_nToRDi  += _nQtRDi
	
	nLin += 2
	@nLin,00 PSAY Replicate("-",limite)
	nLin += 2
	@nLin,065 PSAY "REJEITOS DIVEROS"
	nLin += 2
	
	dbSelectArea("TRB")
	dbGoTop()
	
	_dData  := ""
	_lDia   := .F.
	_nQtRDi := 0
	_nProdu := 0
	
	While !EOF()
		
		If !Empty(TRB->OK)
			dbSelectArea("TRB")
			dbSkip()
			Loop
		Endif
		
		If nLin > 53
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			If _lDia
				@nLin,000 PSAY "DATA :" + dToc(TRB->DATAE)
				nLin++
			Endif
		Endif
		
		_cChav := dTos(TRB->DATAE)+TRB->PRODUTO+Space(9)+TRB->CODOP
		_nProd := 0
		dbSelectArea("TMP")
		If dbSeek(_cChav)
			
			While !EOF() .And. _cChav == dTos(TMP->DATAE)+TMP->PRODUTO+TMP->CODOP
				
				_nProd += TMP->QTPROD
				
				dbSelectArea("TMP")
				dbSkip()
			EndDo
		Endif
		
		If _dData <> dToc(TRB->DATAE)
			If _lDia
				
				nLin++
				
				@nLin,000 PSAY "TOTAL DIA "+_dData+"    ---------->"
				@nLin,081 PSAY _nQtRDi      Picture TM(_nQtRDi,14,2)
				@nLin,125 PSAY (_nQtRDi / _nProdu) * 100    Picture ("@E 999.99")
				nLin += 2
				
				_nToRDi  += _nQtRDi
				_nQtRDi  := _nProdu  := 0
			Endif
			
			nLin++
			@nLin,000 PSAY "DATA :" + dToc(TRB->DATAE)
			nLin++
			_dData :=	dToc(TRB->DATAE)
		Endif
		
		_lDia := .T.
		
		@nLin,000 PSAY TRB->PRODUTO
		@nLin,018 PSAY TRB->NOMOP
		@nLin,081 PSAY TRB->QTREJ    Picture TM(TRB->QTREJ,14,2)
		@nLin,098 PSAY TRB->DESREJ
		@nLin,125 PSAY (TRB->QTREJ / _nProd) * 100    Picture ("@E 999.99")
		
		nLin++
		_nQtRDi += TRB->QTREJ
		_nProdu += _nProd
		
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	nLin++
	
	@nLin,000 PSAY "TOTAL DIA "+_dData+"    ---------->"
	@nLin,081 PSAY _nQtRDi      Picture TM(_nQtRDi,14,2)
	@nLin,125 PSAY (_nQtRDi / _nProdu) * 100    Picture ("@E 999.99")
	_nToRDi  += _nQtRDi
	
	nLin += 2
	@nLin,00 PSAY Replicate("-",limite)
	nLin += 2
	
	@nLin,000 PSAY "TOTAL GERAL   -------------------->"
	@nLin,063 PSAY _nToPDi      			Picture TM(_nToPDi,14,2)
	@nLin,081 PSAY _nToRDi      			Picture TM(_nToRDi,14,2)
	@nLin,125 PSAY (_nToRDi/_nToPDi)*100   	Picture ("@E 999.99")
	
Return


Static Function OrdProd()
	
	/*
	Ordem := PRODUTO
	DATA              OPERADOR                                      QTE PRODUZIDA       QTE REJEITO   DESCRICAO REJEITO                 %
	99999999          9999999999999999999999999999999999999999     99999999999999    99999999999999   9999999999999999999999999    999999
	0                 18                                           63                81               98
	*/
	
	cabec1 := "DATA              OPERADOR                                      QTE PRODUZIDA       QTE REJEITO   DESCRICAO REJEITO             %"
	cabec2 := ""
	
	dbSelectArea("TMP")
	cIndTMP    := CriaTrab(NIL,.F.)
	IndRegua("TMP",cIndTMP,"PRODUTO+DTOS(DATAE)+CODOP",,,"Selecionando Registros...")
	
	dbGoTop()
	
	ProcRegua(LastRec())
	
	_cProd  := ""
	_lDia   := .F.
	_nQtPDi := 0
	_nQtRDi := 0
	_nToPDi := 0
	_nToRDi := 0
	
	While !EOF()
		
		IncProc()
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 53
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		If _cProd <> TMP->PRODUTO
			If _lDia
				
				nLin++
				
				@nLin,000 PSAY "TOTAL PRODUTO "+_cProd+"    ---------->"
				@nLin,063 PSAY _nQtPDi      Picture TM(_nQtPDi,14,2)
				@nLin,081 PSAY _nQtRDi      Picture TM(_nQtRDi,14,2)
				@nLin,125 PSAY (_nQtRDi / _nQtPDi) * 100    Picture ("@E 999.99")
				nLin += 2
				
				_nToPDi  += _nQtPDi
				_nToRDi  += _nQtRDi
				_nQtPDi := 0
				_nQtRDi := 0
			Endif
			
			nLin++
			@nLin,000 PSAY "PRODUTO :" +TMP->PRODUTO
			nLin++
			_cProd := TMP->PRODUTO
		Endif
		
		_lDia := .T.
		
		@nLin,000 PSAY dToc(TMP->DATAE)
		@nLin,018 PSAY TMP->NOMOP
		@nLin,063 PSAY TMP->QTPROD		Picture TM(TMP->QTPROD,14,2)
		
		_nQtPDi += TMP->QTPROD
		
		_lEntr := .F.
		dbSelectarea("TRB")
		If dbSeek(dTos(TMP->DATAE)+Substr(TMP->PRODUTO,1,6)+TMP->CODOP)
			_nQtRej  := 0
			_nCont   := 0
			
			_cChav := DTOS(TRB->DATAE)+TRB->PRODUTO+TRB->CODOP
			
			While !EOF() .And. _cChav == DTOS(TRB->DATAE)+TRB->PRODUTO+TRB->CODOP
				
				If TRB->REJOPER  == "N"
					dbSelectArea("TRB")
					dbSkip()
					Loop
				Endif
				
				If _nCont > 0
					nLin++
				Endif
				
				@nLin,081 PSAY TRB->QTREJ    Picture TM(TRB->QTREJ,14,2)
				@nLin,098 PSAY TRB->DESREJ
				
				dbSelectArea("TRB")
				RecLock("TRB",.F.)
				TRB->OK   := "OK"
				MsUnLock()
				
				_nCont ++
				_nQtRej += TRB->QTREJ
				_lEntr := .T.
				
				dbSelectArea("TRB")
				dbSkip()
			EndDo
			
			If _nCont > 1
				nLin++
				@nLin,081 PSAY " --------------"
				nLin++
				@nLin,081 PSAY _nQtRej      Picture TM(_nQtRej,14,2)
			Endif
			@nLin,125 PSAY (_nQtRej / TMP->QTPROD) * 100    Picture ("@E 999.99")
			nLin ++
			_nQtRDi += _nQtRej
			
		Endif
		
		nLin ++
		
		dbSelectArea("TMP")
		dbSkip()
		
	EndDo
	
	nLin++
	
	@nLin,000 PSAY "TOTAL PRODUTO "+_cProd+"    ---------->"
	@nLin,063 PSAY _nQtPDi      Picture TM(_nQtPDi,14,2)
	@nLin,081 PSAY _nQtRDi      Picture TM(_nQtRDi,14,2)
	@nLin,125 PSAY (_nQtRDi / _nQtPDi) * 100    Picture ("@E 999.99")
	
	_nToPDi  += _nQtPDi
	_nToRDi  += _nQtRDi
	
	nLin += 2
	@nLin,00 PSAY Replicate("-",limite)
	nLin += 2
	
	dbSelectArea("TRB")
	dbGoTop()
	
	_cProd  := ""
	_lDia   := .F.
	_nQtRDi := _nProdu := 0
	
	While !EOF()
		
		If !Empty(TRB->OK)
			dbSelectArea("TRB")
			dbSkip()
			Loop
		Endif
		
		If nLin > 53
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			If _lDia
				@nLin,000 PSAY "PRODUTO "+TRB->PRODUTO
				nLin++
			Endif
		Endif
		
		_cChav := TRB->PRODUTO+Space(9)+dTos(TRB->DATAE)+TRB->CODOP
		_nProd := 0
		dbSelectArea("TMP")
		If dbSeek(_cChav)
			
			While !EOF() .And. _cChav == TMP->PRODUTO+dTos(TMP->DATAE)+TMP->CODOP
				
				_nProd += TMP->QTPROD
				
				dbSelectArea("TMP")
				dbSkip()
			EndDo
		Endif
		
		If _cProd <> TRB->PRODUTO
			If _lDia
				
				nLin++
				
				@nLin,000 PSAY "TOTAL PRODUTO "+_cProd+"    ---------->"
				@nLin,081 PSAY _nQtRDi      			  Picture TM(_nQtRDi,14,2)
				@nLin,125 PSAY (_nQtRDi / _nProdu)* 100    Picture ("@E 999.99")
				
				nLin += 2
				
				_nToRDi  += _nQtRDi
				_nQtRDi  := _nProdu := 0
			Endif
			
			nLin++
			@nLin,000 PSAY "PRODUTO :" +TRB->PRODUTO
			nLin++
			_cProd := TRB->PRODUTO
		Endif
		
		_lDia := .T.
		
		@nLin,000 PSAY dToc(TRB->DATAE)
		@nLin,018 PSAY TRB->NOMOP
		@nLin,081 PSAY TRB->QTREJ    Picture TM(TRB->QTREJ,14,2)
		@nLin,098 PSAY TRB->DESREJ
		@nLin,125 PSAY (TRB->QTREJ / _nProd)* 100    Picture ("@E 999.99")
		
		_nCont  ++
		nLin++
		_nQtRDi += TRB->QTREJ
		_nProdu += _nProd
		
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	nLin++
	
	@nLin,000 PSAY "TOTAL PRODUTO "+_cProd+"    ---------->"
	@nLin,081 PSAY _nQtRDi      			   Picture TM(_nQtRDi,14,2)
	@nLin,125 PSAY (_nQtRDi / _nProdu)* 100    Picture ("@E 999.99")
	_nToRDi  += _nQtRDi
	
	nLin += 2
	
	@nLin,000 PSAY "TOTAL GERAL   -------------------->"
	@nLin,063 PSAY _nToPDi      Picture TM(_nToPDi,14,2)
	@nLin,081 PSAY _nToRDi      Picture TM(_nToRDi,14,2)
	@nLin,125 PSAY (_nToRDi / _nToPDi) * 100    Picture ("@E 999.99")
	
Return


Static Function OrdOper()
	
	/*
	Ordem := OPERADOR
	DATA              PRODUTO                                       QTE PRODUZIDA       QTE REJEITO   DESCRICAO REJEITO
	99999999          999999999999999                              99999999999999    99999999999999   99999999999999999999999999999999999
	0                 18                                           63                81               98
	*/
	
	cabec1 := "DATA              PRODUTO                                       QTE PRODUZIDA       QTE REJEITO   DESCRICAO REJEITO           %"
	cabec2 := ""
	
	dbSelectArea("TMP")
	cIndTMP    := CriaTrab(NIL,.F.)
	IndRegua("TMP",cIndTMP,"NOMOP+DTOS(DATAE)+PRODUTO",,,"Selecionando Registros...")
	//IndRegua("TMP",cIndTMP,"CODOP+DTOS(DATAE)+PRODUTO",,,"Selecionando Registros...")
	
	dbGoTop()
	
	ProcRegua(LastRec())
	
	_cCodOp := ""
	_cNomOP := ""
	_lDia   := .F.
	_nQtPDi := 0
	_nQtRDi := 0
	_nToPDi := 0
	_nToRDi := 0
	
	While !EOF()
		
		IncProc()
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		/*	If TMP->CODOP == "999999"
		dbSelectArea("TMP")
		dbSkip()
		Loop
	Endif
	*/
	If nLin > 53
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	If _cCodOp <> (TMP->CODOP)
		If _lDia
			
			nLin++
			
			@nLin,000 PSAY "TOTAL OPERADOR "+_cCodOp+ " - " + Substr(_cNomOP,1,30)
			@nLin,063 PSAY _nQtPDi      Picture TM(_nQtPDi,14,2)
			@nLin,081 PSAY _nQtRDi      Picture TM(_nQtRDi,14,2)
			@nLin,125 PSAY (_nQtRDi / _nQtPDi) * 100    Picture ("@E 999.99")
			nLin += 2
			
			_nToPDi  += _nQtPDi
			_nToRDi  += _nQtRDi
			_nQtPDi := 0
			_nQtRDi := 0
		Endif
		
		nLin++
		@nLin,000 PSAY "OPERADOR :" + TMP->CODOP + " - " + TMP->NOMOP
		nLin++
		_cCodOp := TMP->CODOP
		_cNomOP := TMP->NOMOP
	Endif
	
	_lDia := .T.
	
	@nLin,000 PSAY dtoc(TMP->DATAE)
	@nLin,018 PSAY TMP->PRODUTO
	@nLin,063 PSAY TMP->QTPROD		Picture TM(TMP->QTPROD,14,2)
	
	_nQtPDi += TMP->QTPROD
	
	_lEntr := .F.
	dbSelectarea("TRB")
	If dbSeek(dTos(TMP->DATAE)+Substr(TMP->PRODUTO,1,6)+TMP->CODOP)
		_nQtRej  := 0
		_nCont   := 0
		
		_cChav := DTOS(TRB->DATAE)+TRB->PRODUTO+TRB->CODOP
		
		While !EOF() .And. _cChav == DTOS(TRB->DATAE)+TRB->PRODUTO+TRB->CODOP
			
			If TRB->REJOPER  == "N"
				dbSelectArea("TRB")
				dbSkip()
				Loop
			Endif
			
			If nLin > 53
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			@nLin,081 PSAY TRB->QTREJ    Picture TM(TRB->QTREJ,14,2)
			@nLin,098 PSAY TRB->DESREJ
			
			dbSelectArea("TRB")
			RecLock("TRB",.F.)
			TRB->OK   := "OK"
			MsUnLock()
			
			_nQtRej += TRB->QTREJ
			nLin  ++
			_nCont ++
			_lEntr := .T.
			
			dbSelectArea("TRB")
			dbSkip()
		EndDo
		
		If _nCont > 1
			_nCont ++
			@nLin,081 PSAY " --------------"
			nLin++
			@nLin,081 PSAY _nQtRej      Picture TM(_nQtRej,14,2)
			//			nLin += 1
		ElseIf _lEntr
			nLin -= 1
		Endif
		@nLin,125 PSAY (_nQtRej / TMP->QTPROD) * 100    Picture ("@E 999.99")
		nLin ++
		
		_nQtRDi += _nQtRej
		
	Endif
	
	nLin ++
	
	dbSelectArea("TMP")
	dbSkip()
	
EndDo

nLin++

@nLin,000 PSAY "TOTAL OPERADOR "+_cCodOp+ " - " + Substr(_cNomOP,1,30)
@nLin,063 PSAY _nQtPDi      Picture TM(_nQtPDi,14,2)
@nLin,081 PSAY _nQtRDi      Picture TM(_nQtRDi,14,2)
@nLin,125 PSAY (_nQtRDi / _nQtPDi) * 100    Picture ("@E 999.99")

_nToPDi  += _nQtPDi
_nToRDi  += _nQtRDi

nLin += 2
@nLin,00 PSAY Replicate("-",limite)
nLin += 2

dbSelectArea("TRB")
cIndTMP    := CriaTrab(NIL,.F.)
IndRegua("TRB",cIndTMP,"NOMOP+DTOS(DATAE)+PRODUTO",,,"Selecionando Registros...")

dbGoTop()

_cCodOp := ""
_lDia   := .F.
_nQtRDi := _nProdu := 0

While !EOF()
	
	If !Empty(TRB->OK)
		dbSelectArea("TRB")
		dbSkip()
		Loop
	Endif
	
	If TRB->CODOP == "999999"
		_lPare := .T.
	Endif
	
	If nLin > 53
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
		If _lDia
			@nLin,000 PSAY "OPERADOR :" + TRB->CODOP + " - " + TRB->NOMOP
			nLin++
		Endif
	Endif
	
	If _cCodOp <> (TRB->CODOP)
		If _lDia
			
			nLin++
			
			@nLin,000 PSAY "TOTAL OPERADOR "+_cCodOp+ " - " + Substr(_cNomOP,1,30)
			@nLin,081 PSAY _nQtRDi      			 Picture TM(_nQtRDi,14,2)
			@nLin,125 PSAY (_nQtRDi/_nProdu) *100     Picture ("@E 999.99")
			
			nLin += 2
			
			_nToRDi  += _nQtRDi
			_nQtRDi  := _nProdu := 0
		Endif
		
		nLin++
		@nLin,000 PSAY "OPERADOR :" + TRB->CODOP + " - " + TRB->NOMOP
		nLin++
		_cCodOp := TRB->CODOP
		_cNomOP := TRB->NOMOP
	Endif
	
	_cChav := TRB->NOMOP+dTos(TRB->DATAE)+TRB->PRODUTO+Space(9)
	_nProd := 0
	dbSelectArea("TMP")
	If dbSeek(_cChav)
		
		While !EOF() .And. _cChav == TMP->NOMOP+dTos(TMP->DATAE)+TMP->PRODUTO
			
			_nProd += TMP->QTPROD
			
			dbSelectArea("TMP")
			dbSkip()
		EndDo
	Endif
	
	_lDia := .T.
	
	@nLin,000 PSAY dToc(TRB->DATAE)
	@nLin,018 PSAY TRB->PRODUTO
	@nLin,081 PSAY TRB->QTREJ    			   Picture TM(TRB->QTREJ,14,2)
	@nLin,098 PSAY TRB->DESREJ
	@nLin,125 PSAY (TRB->QTREJ/_nProd)*100     Picture ("@E 999.99")
	
	nLin++
	_nQtRDi += TRB->QTREJ
	_nProdu += _nProd
	
	dbSelectArea("TRB")
	dbSkip()
EndDo

If _lDia
	nLin++
	
	@nLin,000 PSAY "TOTAL OPERADOR "+_cCodOp+ " - " + Substr(_cNomOP,1,30)
	@nLin,081 PSAY _nQtRDi      Picture TM(_nQtRDi,14,2)
	@nLin,125 PSAY (_nQtRDi/_nProdu)*100     Picture ("@E 999.99")
	_nToRDi  += _nQtRDi
	
Endif

nLin += 2

@nLin,000 PSAY "TOTAL GERAL   -------------------->"
@nLin,063 PSAY _nToPDi      Picture TM(_nToPDi,14,2)
@nLin,081 PSAY _nToRDi      Picture TM(_nToRDi,14,2)
@nLin,125 PSAY (_nToRDi / _nToPDi) * 100    Picture ("@E 999.99")

Return


Static Function OrdReje()
	
	/*
	Ordem := TIPO REJEITO
	DATA              OPERADOR                                     PRODUTO            QTE PRODUZIDA      QTE REJEITO       PORC.
	9999999           9999999999999999999999999999999999999999     999999999999999   99999999999999   99999999999999     9999.99
	0                 18                                           63                81               98                 117
	*/
	
	cabec1 := "DATA              OPERADOR                                     PRODUTO            QTE PRODUZIDA      QTE REJEITO       PORC."
	cabec2 := ""
	
	dbSelectArea("TRB")
	cIndTRB    := CriaTrab(NIL,.F.)
	IndRegua("TRB",cIndTRB,"TPREJ+DTOS(DATAE)+NOMOP+PRODUTO",,,"Selecionando Registros...")
	
	dbGoTop()
	
	ProcRegua(LastRec())
	
	_cReje  := ""
	_cDeRe  := ""
	_lDia   := .F.
	_nQtPDi := 0
	_nQtRDi := 0
	_nToPDi := 0
	_nToRDi := 0
	
	While !EOF()
		
		IncProc()
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 53
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		_cProd := TRB->PRODUTO +"Y        "
		
		If _cReje <> TRB->TPREJ
			If _lDia
				
				nLin++
				
				@nLin,000 PSAY "TOTAL TIPO "+_cReje+" - "+Substr(_cDeRe,1,25)
				@nLin,098 PSAY _nQtRDi      				   Picture TM(_nQtRDi,14,2)
				@nLin,117 PSAY (_nQtRDi / _nTotal)*100         Picture ("@E 9999.99")
				
				nLin += 2
				
				_nToPDi  += _nQtPDi
				_nToRDi  += _nQtRDi
				_nQtPDi  := 0
				_nQtRDi  := 0
			Endif
			
			nLin++
			@nLin,000 PSAY "TIPO REJEITO :" + TRB->TPREJ + " - " + TRB->DESREJ
			nLin++
			_cReje := TRB->TPREJ
			_cDeRe := TRB->DESREJ
		Endif
		
		@nLin,000 PSAY dToc(TRB->DATAE)
		@nLin,018 PSAY TRB->NOMOP
		@nLin,063 PSAY TRB->PRODUTO
		
		@nLin,098 PSAY TRB->QTREJ    Picture TM(TRB->QTREJ,14,2)
		@nLin,117 PSAY (TRB->QTREJ / _nTotal)*100       	Picture ("@E 9999.99")
		
		//	_nQtPDi += _nQtProd
		_nQtRDi += TRB->QTREJ
		
		nLin ++
		_lDia := .T.
		//	Endif
		
		dbSelectArea("TRB")
		dbSkip()
		
	EndDo
	
	nLin++
	
	@nLin,000 PSAY "TOTAL TIPO "+_cReje+" - " +Substr(_cDeRe,1,25)
	@nLin,098 PSAY _nQtRDi      					Picture TM(_nQtRDi,14,2)
	@nLin,117 PSAY (_nQtRDi / _nTotal)*100       	Picture ("@E 9999.99")
	
	_nToPDi  += _nQtPDi
	_nToRDi  += _nQtRDi
	
	nLin += 3
	
	@nLin,000 PSAY "TOTAL GERAL   -------------------->"
	@nLin,098 PSAY _nToRDi      			Picture TM(_nToRDi,14,2)
	@nLin,117 PSAY (_nToRDi / _nTotal)*100  Picture ("@E 9999.99")
	
Return
