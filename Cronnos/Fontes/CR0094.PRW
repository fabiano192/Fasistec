#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CR0094   ³ Autor ³ Fabiano da Silva      ³ Data ³ 15.02.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grafico de prensas por Valor                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaEst                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ-±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CR0094()
	
	AtuSX1()
	
	_aAliOri := GetArea()
	_lAchou  := .F.
	_nOpc    := 0
	
	@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Graficos de Produtividade ")
	@ 02,10 TO 080,220
	@ 10,18 SAY "Graficos de Produtividade                        "    SIZE 160,7
	@ 18,18 SAY "Conforme parametros informados                   "    SIZE 160,7
	@ 26,18 SAY "                                                 "    SIZE 160,7
	@ 34,18 SAY "Programa CR0094.PRW                              "    SIZE 160,7
	
	@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("CR0094")
	@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
	@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()
	
	ACTIVATE DIALOG oDlg Centered
	
	If _nOpc == 1
		CR094A()
	Endif
	
Return


Static Function CR094A()
	
	_cMod   := cModulo
	cModulo := "EEC"
	
	_lRet := E_ARQCRW()
	
	Pergunte("CR0094",.F.)
	
	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| CR094B(@_lFim) }
	Private _cTitulo01 := 'Processando'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
	_cArqNe1 := "\SPOOL\CR0094.DBF"
	dbSelectArea("TRB")
	COPY ALL TO &_cArqNe1
	dbCloseArea()
	
	_cArqNew := "\CRYSTAL\PA0153.DBF"
	dbSelectArea("TMP")
	COPY ALL TO &_cArqNew
	dbCloseArea()
	
	
	Private cSeqRel := ""
	
	AVGCRW32("PA0153.RPT","Grafico de Produtividade")
	
	cModulo := _cMod
	
Return


Static Function CR094B(_lFim)
	
	aStru := {}
	AADD(aStru,{"CODIGO"   , "C" , 15, 0 })    // PRODUTO
	AADD(aStru,{"PRENSA"   , "C" , 06, 0 })    // PRENSA
	AADD(aStru,{"VALOR"    , "N" , 14, 2 })    // Valor
	AADD(aStru,{"QTE"      , "N" , 14, 2 })    // Valor
	
	cArqLOG := CriaTrab(aStru,.T.)
	cIndLOG := "CODIGO+PRENSA"
	
	dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)
	
	dbSelectArea("TRB")
	IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")
	
	dbSelectarea("SD3")
	dbSetOrder(6)
	dbSeek(xFilial("SD3")+DTOS(MV_PAR01),.T.)
	
	ProcRegua(LastRec())
	
	While !Eof() .And. !_lFim .And. SD3->D3_EMISSAO <= MV_PAR02
		
		IncProc("Processando Movimento Interno!!")
		
		If _lFim
			Return
		Endif
		
		If SD3->D3_ESTORNO == "S"
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		If SD3->D3_YRECURS < MV_PAR03  .Or. SD3->D3_YRECURS  > MV_PAR04 .Or. !SD3->D3_LOCAL $ "20/25"
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SD3->D3_COD)
		
		If Substr(SD3->D3_CF,1,2) != "PR"
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		_nPrVen  := 0
		_cCod    := Substr(SD3->D3_COD,1,6)+Space(9)
		_cCodSG1 := ""
		
		dbSelectArea("SG1")
		dbSetOrder(2)
		If dbSeek(xFilial("SG1")+SD3->D3_COD)
			
			If Substr(SG1->G1_COD,1,2) != "PP" .And. Len(Alltrim(SG1->G1_COD)) != 6
				_cCodEs := SG1->G1_COD
				dbSelectArea("SG1")
				dbSetOrder(2)
				dbSeek(xFilial("SG1")+_cCodEs)
			Endif
			
			_lEstrPP := .F.
			_nPrcVD := 0
			If 	Substr(SG1->G1_COD,1,2) == "PP"
				_cPP := SG1->G1_COD
				dbSelectArea("SG1")
				dbSetOrder(2)
				If dbSeek(xFilial("SG1")+_cPP)
					While !EOF() .And. _cPP == SG1->G1_COMP
						
						_cCodSG1 := SG1->G1_COD
						
						dbSelectArea("SD2")
						dbSetOrder(6)
						dbSeek(xFilial("SD2")+_cCodSG1+"99"+"99999999",.T.)
						dbSkip(-1)
						
						dbSelectArea("SC6")
						dbSetOrder(1)
						If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
							If SC6->C6_PEDAMOS == "D" .Or. SD2->D2_TIPO == "C"
								dbSelectArea("SD2")
								dbSetOrder(6)
								dbSeek(xFilial("SD2")+_cCodSG1+"99"+"99999999",.T.)
								dbSkip(-2)
								
								dbSelectArea("SC6")
								dbSetOrder(1)
								If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
									If SC6->C6_PEDAMOS == "D" .Or. SD2->D2_TIPO == "C"
										
										dbSelectArea("SD2")
										dbSetOrder(6)
										dbSeek(xFilial("SD2")+_cCodSG1+"99"+"99999999",.T.)
										dbSkip(-3)
									Endif
								Endif
							Endif
						Endif
						
						If _nPrcVD < SD2->D2_PRCVEN
							_nPrcVD := SD2->D2_PRCVEN
						Endif
						
						dbSelectArea("SG1")
						dbSkip()
					EndDo
					
					_lEstrPP := .T.
				Endif
			Endif
			
			If !_lEstrPP
				If Alltrim(SG1->G1_COD) == "007150"
					_cCodSG1 := "007151"+Space(9)
				Else
					_cCodSG1 := SG1->G1_COD
				Endif
				
				dbSelectArea("SD2")
				dbSetOrder(6)
				dbSeek(xFilial("SD2")+_cCodSG1+"99"+"99999999",.T.)
				dbSkip(-1)
				
				dbSelectArea("SC6")
				dbSetOrder(1)
				If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
					If SC6->C6_PEDAMOS == "D" .Or. SD2->D2_TIPO == "C"
						dbSelectArea("SD2")
						dbSetOrder(6)
						dbSeek(xFilial("SD2")+_cCodSG1+"99"+"99999999",.T.)
						dbSkip(-2)
						
						dbSelectArea("SC6")
						dbSetOrder(1)
						If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
							If SC6->C6_PEDAMOS == "D" .Or. SD2->D2_TIPO == "C"
								
								dbSelectArea("SD2")
								dbSetOrder(6)
								dbSeek(xFilial("SD2")+_cCodSG1+"99"+"99999999",.T.)
								dbSkip(-3)
							Endif
						Endif
					Endif
				Endif
				_nPrcVD := SD2->D2_PRCVEN
			Endif
			
			If SD2->D2_COD == _cCodSG1
				_nPrVen := _nPrcVD
			Else
				_nPrVen := 0
			Endif
			
		Endif
		
		dbSelectArea("TRB")
		If dbSeek(SD3->D3_COD+SD3->D3_YRECURS)
			RecLock("TRB",.F.)
			TRB->QTE      += SD3->D3_QUANT
			TRB->VALOR    := TRB->QTE * _nPrVen
			MsUnLock()
		Else
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->CODIGO   := SD3->D3_COD
			TRB->PRENSA   := SD3->D3_YRECURS
			TRB->VALOR    := SD3->D3_QUANT * _nPrVen
			TRB->QTE      := SD3->D3_QUANT
			MsUnLock()
		Endif
		
		dbSelectArea("SD3")
		dbSkip()
	EndDo
	
	aStru := {}
	AADD(aStru,{"PRENSA"   , "C" , 06, 0 })    // PRENSA
	AADD(aStru,{"VALOR"    , "N" , 14, 2 })    // Valor
	
	cArqLOG := CriaTrab(aStru,.T.)
	cIndLOG := "PRENSA"
	
	dbUseArea(.T.,,cArqLOG,"TMP",.F.,.F.)
	
	dbSelectArea("TMP")
	IndRegua("TMP",cArqLog,cIndLog,,,"Criando Trabalho...")
	
	
	dbSelectArea("TRB")
	dbGotop()
	
	ProcRegua(LastRec())
	
	While !Eof()
		
		IncProc("TMP")
		
		If _lFim
			Return
		Endif
		
		dbSelectArea("TMP")
		If dbSeek(TRB->PRENSA)
			RecLock("TMP",.F.)
			TMP->VALOR    += TRB->VALOR
			MsUnLock()
		Else
			dbSelectArea("TMP")
			RecLock("TMP",.T.)
			TMP->PRENSA   := TRB->PRENSA
			TMP->VALOR    := TRB->VALOR
			MsUnLock()
		Endif
		
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
Return


Static Function AtuSX1()
	
	cPerg := "CR0094"
	aRegs :={}
	
	///////////////////////////////////////////////
	///////////////////////////////////////////////
	/////  Grupo de Pergunta PA0149          //////
	/////  MV_PAR01 : Data         De ?      //////
	/////  MV_PAR02 : Data        Ate ?      //////
	/////  MV_PAR03 : Prensa       De ?      //////
	/////  MV_PAR04 : Prensa      Ate ?      //////
	///////////////////////////////////////////////
	///////////////////////////////////////////////
	
	//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01        /defspa1/defeng1/Cnt01/Var02/Def02  /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(cPerg,"01","Data    De            ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR01",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"02","Data    Ate           ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"03","Prensa  De            ?",""       ,""      ,"mv_ch3","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR03",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SH1")
	U_CRIASX1(cPerg,"04","Prensa  Ate           ?",""       ,""      ,"mv_ch4","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR04",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SH1")
	
Return
