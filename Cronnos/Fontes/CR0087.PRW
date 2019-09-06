#INCLUDE "TOTVS.CH"

/*/
Programa	: CR0087
Autor		: Fabiano da Silva
Data		: 16.05.16
Descrição 	: Grafico  Rejeitos da produção
/*/

User Function CR0087()
	
	Local _oDlg1		:= Nil

	_aAliOri := GetArea()
	_lAchou  := .F.
	_nOpc    := 0
	
	Private _nGanhProj := _nAnteProj := _nPerImp   := _nPerIrpj  := 0
		
	
	DEFINE MSDIALOG _oDlg1 FROM 0,0 TO 380,450 TITLE "Graficos de Rejeito" PIXEL OF _oDlg1
	
	@ 02,10 TO 080,220 Label "" PIXEL OF _oDlg1
	
	@ 10,18 SAY "Graficos de Rejeito por Categoria ou Por Operador"    SIZE 160,7 PIXEL OF _oDlg1
	@ 18,18 SAY "Conforme parametros informados                   "    SIZE 160,7 PIXEL OF _oDlg1
	@ 26,18 SAY "                                                 "    SIZE 160,7 PIXEL OF _oDlg1
	@ 34,18 SAY "Programa CR0087.PRW                              "    SIZE 160,7 PIXEL OF _oDlg1
	
	@ 55,128 BUTTON "Parâmetros"	SIZE 036,012 ACTION (Pergunte("CR0087"))	PIXEL OF _oDlg 
	@ 85,158 BUTTON "Ok"			SIZE 036,012 ACTION (_nOpc:=1,oDlg:END())	PIXEL OF _oDlg
	@ 85,188 BUTTON "Sair"			SIZE 036,012 ACTION ( _oDlg:End())			PIXEL OF _oDlg

	ACTIVATE MSDIALOG _oDlg1 CENTERED
	
	If _nOpc == 1
		Proces()
	Endif
	
Return


Static Function Proces()
	
	Pergunte("CR0087",.F.)
	
	///////////////////////////////////////
	///// MV_PAR01 : Data De ?         ////
	///// MV_PAR02 : Data Ate ?        ////
	///// MV_PAR02 : Tipo de Grafico?  ////  1 = Por Tipo de Perda 2 = Por Operador
	///////////////////////////////////////
	
	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	If MV_PAR03 == 1
		Private _bAcao01   := {|_lFim| Proc1(@_lFim) }
	Else
		Private _bAcao01   := {|_lFim| Proc2(@_lFim) }
	Endif
	
	Private _cTitulo01 := 'Processando'
	
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
	If MV_PAR03 == 1
		_cArqNew := "\CRYSTAL\PA0099.DBF"
	Else
		_cArqNew := "\CRYSTAL\PA0099B.DBF"
	Endif
	
	dbSelectArea("TRB")
	COPY ALL TO &_cArqNew
	
	dbSelectArea("TRB")
	dbCloseArea()
	
	Private cSeqRel := ""
	
	If MV_PAR03 == 1
		AVGCRW32("PA0099A.RPT","Grafico Por Tipo de Rejeito")
	Else
		AVGCRW32("PA0099B.RPT","Grafico Por Operador")
	Endif
	
	cModulo := _cMod
	
Return


Static Function Proc1(_lFim)
	
	aCampos := {}
	AADD(aCampos,{ "TPREJ"   ,"C", 02, 0 } )
	AADD(aCampos,{ "DESREJ"  ,"C", 50, 0 } )
	AADD(aCampos,{ "QTREJ"   ,"N", 14, 2 } )
	AADD(aCampos,{ "DATADE"  ,"D", 08, 0 } )
	AADD(aCampos,{ "DATAATE" ,"D", 08, 0 } )
	
	cArqLOG := CriaTrab(aCampos,.T.)
	cIndLOG := "TPREJ"
	dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)
	
	dbSelectArea("TRB")
	IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")
	
	dbSelectArea("SBC")
	dbSetOrder(2)
	dbSeek(xFilial("SBC")+Dtos(MV_PAR01),.T.)
	
	ProcRegua(LastRec())
	
	_nTot := 0
	While !Eof() .And. SBC->BC_DATA  <= MV_PAR02
		
		IncProc()
		
		dbSelectArea("SZ6")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ6")+SBC->BC_APONTAD)
			
			If SZ6->Z6_ATIVO != "1"
				dbSelectArea("SBC")
				dbSkip()
				Loop
			Endif
			
			If (MV_PAR05 = 1 .And. SZ6->Z6_LOCAL = "2") .Or.;
					(MV_PAR05 = 2 .And. SZ6->Z6_LOCAL = "1")
				dbSelectArea("SBC")
				dbSkip()
				Loop
			Endif
			
			If SZ6->Z6_TURNO < MV_PAR06 .Or. SZ6->Z6_TURNO > MV_PAR07
				dbSelectArea("SBC")
				dbSkip()
				Loop
			Endif
			
			_nTot += SBC->BC_QUANT
			
		Endif
		
		dbSelectArea("SBC")
		dbSkip()
	EndDo
	
	dbSelectArea("SBC")
	dbSetOrder(2)
	dbSeek(xFilial("SBC")+Dtos(MV_PAR01),.T.)
	
	ProcRegua(LastRec())
	
	While !Eof() .And. SBC->BC_DATA  <= MV_PAR02
		
		IncProc()
		
		dbSelectArea("SZ6")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ6")+SBC->BC_APONTAD)
			
/*
			If SZ6->Z6_ATIVO != "1"
				dbSelectArea("SBC")
				dbSkip()
				Loop
			Endif
	*/		
			If (MV_PAR05 = 1 .And. SZ6->Z6_LOCAL = "2") .Or.;
					(MV_PAR05 = 2 .And. SZ6->Z6_LOCAL = "1")
				dbSelectArea("SBC")
				dbSkip()
				Loop
			Endif
			
			If SZ6->Z6_TURNO < MV_PAR06 .Or. SZ6->Z6_TURNO > MV_PAR07
				dbSelectArea("SBC")
				dbSkip()
				Loop
			Endif
			
			dbSelectArea("TRB")
			If dbSeek(SBC->BC_MOTIVO)
				dbSelectArea("TRB")
				RecLock("TRB",.F.)
				TRB->QTREJ  += SBC->BC_QUANT
				MsUnLock()
			Else
				_cMotRej := TABELA("43",SBC->BC_MOTIVO,.F.)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->TPREJ    := SBC->BC_MOTIVO
				TRB->DESREJ   := _cMotRej
				TRB->QTREJ    := SBC->BC_QUANT
				TRB->DATADE   := MV_PAR01
				TRB->DATAATE  := MV_PAR02
				MsUnLock()
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
		
		dbSelectArea("SZ6")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ6")+SD7->D7_APONTAD)
			
			If SZ6->Z6_ATIVO != "1"
				dbSelectArea("SD7")
				dbSkip()
				Loop
			Endif
			
			If (MV_PAR05 = 1 .And. SZ6->Z6_LOCAL = "2") .Or.;
					(MV_PAR05 = 2 .And. SZ6->Z6_LOCAL = "1")
				dbSelectArea("SD7")
				dbSkip()
				Loop
			Endif
			
			If SZ6->Z6_TURNO < MV_PAR06 .Or. SZ6->Z6_TURNO > MV_PAR07
				dbSelectArea("SD7")
				dbSkip()
				Loop
			Endif
			
		Endif
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SD7->D7_PRODUTO)
		
		If SB1->B1_TIPO != "PA"
			dbSelectArea("SD7")
			dbSkip()
			Loop
		Endif
		
		If SD7->D7_ESTORNO == "S"
			dbSelectArea("SD7")
			dbSkip()
			Loop
		Endif
		
		If SD7->D7_TIPO = 2
			_nTot += SD7->D7_QTDE
		Endif
		
		dbSelectArea("SD7")
		dbSkip()
	EndDo
	
	dbSelectArea("SD7")
	dbSetOrder(4)
	dbSeek(xFilial("SD7")+Dtos(MV_PAR01),.T.)
	
	ProcRegua(LastRec())
	
	While !Eof() .And. SD7->D7_DATA  <= MV_PAR02
		
		IncProc()
		
		If SD7->D7_TIPO = 2
			dbSelectArea("SZ6")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ6")+SD7->D7_APONTAD)
				
				If SZ6->Z6_ATIVO != "1"
					dbSelectArea("SD3")
					dbSkip()
					Loop
				Endif
				
				If (MV_PAR05 = 1 .And. SZ6->Z6_LOCAL = "2") .Or.;
						(MV_PAR05 = 2 .And. SZ6->Z6_LOCAL = "1")
					dbSelectArea("SD3")
					dbSkip()
					Loop
				Endif
				
				If SZ6->Z6_TURNO < MV_PAR06 .Or. SZ6->Z6_TURNO > MV_PAR07
					dbSelectArea("SD3")
					dbSkip()
					Loop
				Endif
				
				If SD7->D7_ESTORNO == "S"
					dbSelectArea("SD7")
					dbSkip()
					Loop
				Endif
				
				dbSelectArea("TRB")
				If dbSeek(SD7->D7_MOTREJE)
					dbSelectArea("TRB")
					RecLock("TRB",.F.)
					TRB->QTREJ  += SD7->D7_QTDE
					MsUnLock()
				Else
					_cMotRej := TABELA("43",SD7->D7_MOTREJE,.F.)
					dbSelectArea("TRB")
					RecLock("TRB",.T.)
					TRB->TPREJ    := SD7->D7_MOTREJE
					TRB->DESREJ   := _cMotRej
					TRB->QTREJ    := SD7->D7_QTDE
					TRB->DATADE   := MV_PAR01
					TRB->DATAATE  := MV_PAR02
					MsUnLock()
				Endif
			Endif
		Endif
		
		dbSelectArea("SD7")
		dbSkip()
	EndDo
	
	dbSelectArea("TRB")
	dbGotop()
	
	_nQtRej := 0
	While !Eof()
		
		_nQtRej := 	TRB->QTREJ
		RecLock("TRB",.F.)
		TRB->QTREJ    :=  (_nQtRej / _nTot) * 100
		MsUnLock()
		
		dbSelectArea("TRB")
		dbSkip()
		
	EndDo
	
Return


Static Function Proc2(_lFim)            //aLMO.: 80
	
	aCampos := {}
	AADD(aCampos,{ "CODOP"   ,"C", 06, 0 } )
	AADD(aCampos,{ "NOMOP"   ,"C", 20, 0 } )
	AADD(aCampos,{ "QTPROD"  ,"N", 14, 2 } )
	AADD(aCampos,{ "QTREJ"   ,"N", 14, 2 } )
	AADD(aCampos,{ "PERCENT" ,"N", 14, 2 } )
	AADD(aCampos,{ "DATADE"  ,"D", 08, 0 } )
	AADD(aCampos,{ "DATAATE" ,"D", 08, 0 } )
	AADD(aCampos,{ "OBJETIV" ,"N", 06, 2 } )
	
	cArqLOG := CriaTrab(aCampos,.T.)
	cIndLOG := "CODOP"
	dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)
	
	dbSelectArea("TRB")
	IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")
	
	aCampos := {}
	AADD(aCampos,{ "CODOP"   ,"C", 06, 0 } )
	AADD(aCampos,{ "NOMOP"   ,"C", 20, 0 } )
	AADD(aCampos,{ "QTPROD"  ,"N", 14, 2 } )
	AADD(aCampos,{ "QTREJ"   ,"N", 14, 2 } )
	
	cArqLOG := CriaTrab(aCampos,.T.)
	cIndLOG := "CODOP"
	dbUseArea(.T.,,cArqLOG,"TMP",.F.,.F.)
	
	dbSelectArea("TMP")
	IndRegua("TMP",cArqLog,cIndLog,,,"Criando Trabalho...")
	
	dbSelectArea("SD3")
	dbSetOrder(6)
	dbSeek(xFilial("SD3")+Dtos(MV_PAR01),.T.)
	
	ProcRegua(LastRec())
	
	While !Eof() .And. SD3->D3_EMISSAO  <= MV_PAR02
		
		IncProc()
		
		If SD3->D3_ESTORNO == "S"
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		If Empty(SD3->D3_OPPRENS)
			If SD3->D3_CF != "DE1"
				dbSelectArea("SD3")
				dbSkip()
				Loop
			Endif
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
		
		If SD3->D3_OPPRENSA == "999999"    //Produção
			_lPare := .T.
		Endif
		
		If !Empty(SD3->D3_TURNO)
			dbSelectArea("SZA")
			dbSetOrder(1)
			dbSeek(xFilial("SZA")+SD3->D3_TURNO)
			
			If SZA->ZA_ATIVO != "1"
				dbSelectArea("SD3")
				dbSkip()
				Loop
			Endif
			
			If (MV_PAR05 = 1 .And. SZA->ZA_LOCAL = "2") .Or.;
					(MV_PAR05 = 2 .And. SZA->ZA_LOCAL = "1")
				dbSelectArea("SD3")
				dbSkip()
				Loop
			Endif
		Endif
		
		
		dbSelectArea("SZ6")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ6")+SD3->D3_OPPRENSA)
			
			If SZ6->Z6_ATIVO != "1"
				dbSelectArea("SD3")
				dbSkip()
				Loop
			Endif
			
			If (MV_PAR05 = 1 .And. SZ6->Z6_LOCAL = "2") .Or.;
					(MV_PAR05 = 2 .And. SZ6->Z6_LOCAL = "1")
				dbSelectArea("SD3")
				dbSkip()
				Loop
			Endif
			
			If SZ6->Z6_TURNO < MV_PAR06 .Or. SZ6->Z6_TURNO > MV_PAR07
				dbSelectArea("SD3")
				dbSkip()
				Loop
			Endif
			
			_cOperad := SD3->D3_OPPRENSA
			_cNomOpe := SZ6->Z6_NOME
			
			If Empty(_cOperad)
				_lStop := .T.
			Endif
			
			dbSelectArea("TMP")
			If dbSeek(SZ6->Z6_CODIGO)
				dbSelectArea("TMP")
				RecLock("TMP",.F.)
				TMP->QTPROD += SD3->D3_QUANT
				MsUnLock()
			Else
				dbSelectArea("TMP")
				RecLock("TMP",.T.)
				TMP->CODOP    := SD3->D3_OPPRENSA
				TMP->NOMOP    := SZ6->Z6_NOME
				TMP->QTPROD   := SD3->D3_QUANT
				MsUnLock()
			Endif
			
		ElseIf SD3->D3_CF == "DE1"
			
			dbSelectArea("SBC")
			dbSetOrder(3)
			If dbSeek(xFilial("SBC")+SD3->D3_NUMSEQ)
				_cNumSeq := SBC->BC_SEQSD3
				
				While !EOF() .And. _cNumSeq == SBC->BC_SEQSD3
					
					If SBC->BC_DATA < MV_PAR01 .Or. SBC->BC_DATA > MV_PAR02
						dbSelectArea("SBC")
						dbSkip()
						Loop
					Endif
					
					dbSelectArea("SZ6")
					dbSetOrder(1)
					If dbSeek(xFilial("SZ6")+SBC->BC_APONTAD)
						
						If SZ6->Z6_ATIVO != "1"
							dbSelectArea("SBC")
							dbSkip()
							Loop
						Endif
						
						If (MV_PAR05 = 1 .And. SZ6->Z6_LOCAL = "2") .Or.;
								(MV_PAR05 = 2 .And. SZ6->Z6_LOCAL = "1")
							dbSelectArea("SBC")
							dbSkip()
							Loop
						Endif
						
						If SZ6->Z6_TURNO < MV_PAR06 .Or. SZ6->Z6_TURNO > MV_PAR07
							dbSelectArea("SBC")
							dbSkip()
							Loop
						Endif
						
					Endif
					
					If SBC->BC_PRODUTO != SD3->D3_COD
						dbSelectArea("SBC")
						dbSkip()
						Loop
					Endif
					
					If Empty(SBC->BC_APONTAD)
						_lStop := .T.
					Endif
					
					If !SBC->BC_MOTIVO $ "AC\FD\MP\MC\QN\EA\DI\MI\MD\DE\CA\FM\MF"
						
						dbSelectArea("TMP")
						If dbSeek(SBC->BC_APONTAD)
							dbSelectArea("TMP")
							RecLock("TMP",.F.)
							TMP->QTREJ  += SBC->BC_QUANT
							TMP->QTPROD += SBC->BC_QUANT
							MsUnLock()
						Else
							dbSelectArea("SZ6")
							dbSetOrder(1)
							dbSeek(xFilial("SZ6")+SBC->BC_APONTAD)
							
							If SZ6->Z6_TIPO != "1"
								dbSelectArea("SBC")
								dbSkip()
								Loop
							Endif
							
							dbSelectArea("TMP")
							RecLock("TMP",.T.)
							TMP->CODOP    := SBC->BC_APONTAD
							TMP->NOMOP    := SZ6->Z6_NOME
							TMP->QTREJ    := SBC->BC_QUANT
							TMP->QTPROD   := SBC->BC_QUANT
							MsUnLock()
						Endif
					Else
						dbSelectArea("TMP")
						If dbSeek(SBC->BC_APONTAD)
							dbSelectArea("TMP")
							RecLock("TMP",.F.)
							TMP->QTPROD += SBC->BC_QUANT
							MsUnLock()
						Else
							dbSelectArea("SZ6")
							dbSetOrder(1)
							dbSeek(xFilial("SZ6")+SBC->BC_APONTAD)
							
							dbSelectArea("TMP")
							RecLock("TMP",.T.)
							TMP->CODOP    := SBC->BC_APONTAD
							TMP->NOMOP    := SZ6->Z6_NOME
							TMP->QTPROD   := SBC->BC_QUANT
							MsUnLock()
						Endif
					Endif
					
					dbSelectArea("SBC")
					dbSkip()
				EndDo
				
			Endif
			
			_cOperad := ""
			_cNomOpe := ""
			
		Endif
		
		dbSelectArea("SD3")
		dbSkip()
		
	EndDo
	
	dbSelectArea("SD7")
	dbSetOrder(4)
	dbSeek(xFilial("SD7")+Dtos(MV_PAR01),.T.)
	
	ProcRegua(LastRec())
	
	While !Eof() .And. SD7->D7_DATA  <= MV_PAR02
		
		IncProc()
		
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
			
			If SZ6->Z6_TIPO != "1"
				dbSelectArea("SD7")
				dbSkip()
				Loop
			Endif
			
			If SZ6->Z6_ATIVO != "1"
				dbSelectArea("SD7")
				dbSkip()
				Loop
			Endif
			
			If (MV_PAR05 = 1 .And. SZ6->Z6_LOCAL = "2") .Or.;
					(MV_PAR05 = 2 .And. SZ6->Z6_LOCAL = "1")
				dbSelectArea("SD7")
				dbSkip()
				Loop
			Endif
			
			If SZ6->Z6_TURNO < MV_PAR06 .Or. SZ6->Z6_TURNO > MV_PAR07
				dbSelectArea("SD7")
				dbSkip()
				Loop
			Endif
			
		Endif
		
		_cNumseq := SD7->D7_NUMSEQ
		_cProd   := SD7->D7_PRODUTO
		_lEst    := .F.
		
		_aAliSD7 := SD7->(GETAREA())
		
		dbSelectArea("SD7")
		dbOrderNickName("INDSD74")
		If dbSeek(xFilial("SD7")+_cNumseq+_cProd)
			
			While !EOF() .And. SD7->D7_NUMSEQ ==_cNumSeq
				
				If SD7->D7_DATA < MV_PAR01 .Or. SD7->D7_DATA > MV_PAR02
					dbSelectArea("SD7")
					dbSkip()
					Loop
				Endif
				
				If SD7->D7_TIPO = 7
					_lEst := .T.
				Endif
				
				dbSelectArea("SD7")
				dbSkip()
			EndDo
		Endif
		
		dbSelectArea("SD7")
		RestArea(_aAliSD7)
		
		If SD7->D7_TIPO = 2
			
			If Empty(SD7->D7_APONTAD)
				_lStop := .T.
			Endif
			
			If !SD7->D7_MOTREJE $ "AC\FD\MP\MC\QN\EA\DI\MI\MD\DE\CA\FM\MF"
				dbSelectArea("TMP")
				If dbSeek(SD7->D7_APONTAD)
					dbSelectArea("TMP")
					RecLock("TMP",.F.)
					TMP->QTREJ  += SD7->D7_QTDE
					MsUnLock()
				Else
					dbSelectArea("TMP")
					RecLock("TMP",.T.)
					TMP->CODOP    := SD7->D7_APONTAD
					TMP->NOMOP    := SZ6->Z6_NOME
					TMP->QTREJ    := SD7->D7_QTDE
					MsUnLock()
				Endif
			Endif
		Endif
		
		dbSelectArea("SD7")
		dbSkip()
	EndDo
	
	dbSelectArea("TMP")
	dbGotop()
	
	ProcRegua(LastRec())
	
	_nPorce := 0
	
	While !Eof()
		
		IncProc()
		
		_nPorce := (TMP->QTREJ / TMP->QTPROD) * 100
		
		If _nPorce <> 0
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->CODOP    := TMP->CODOP
			TRB->NOMOP    := TMP->NOMOP
			TRB->QTPROD   := TMP->QTPROD
			TRB->QTREJ    := TMP->QTREJ
			TRB->PERCENT  := _nPorce
			TRB->DATADE   := MV_PAR01
			TRB->DATAATE  := MV_PAR02
			TRB->OBJETIV  := MV_PAR04
			MsUnLock()
		Endif
		
		dbSelectArea("TMP")
		dbSkip()
	EndDo
	
	cArqNew1 := "/relato/grafico.dbf"
	dbSelectArea("TMP")
	Copy All To &cArqNew1
	dbCloseArea()
	
Return
