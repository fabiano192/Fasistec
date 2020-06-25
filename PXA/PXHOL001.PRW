#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Rotina   ³ PXHOL001                                 ³ Data ³ 22/04/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina para Compartilhamento das Tabelas Principais        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Módulo   ³ SIGACFG                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PXHOL001()

ATUSX1()

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Rotina Para Compartilhamento ")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina Para Compatilhamento das principais tabelas- "     SIZE 160,7
@ 18,18 SAY "Cadastros conforme Empresa 01.                      "     SIZE 160,7
@ 26,18 SAY "                                                    "     SIZE 160,7
@ 34,18 SAY "                                                    "     SIZE 160,7

//@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("MAX003")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

Activate Dialog oDlg Centered

If _nOpc == 1
	Pergunte("PXHOL001",.F.)
	
	///////////////////////////////////////
	//// MV_PAR01 : Data De             ///
	//// MV_PAR02 : Data Ate            ///
	///////////////////////////////////////
	
	Private _cMsg01    := ''
	Private _lFim      := .F.
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| PXHOL001A(@_lFim) }
	Private _cTitulo01 := 'Atualizando!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
	
Endif

Return


Static Function PXHOL001A(_lFim)


//_aTabela := {"CT0","CT1","CT5","CT8","CTD","CTH","CTT","CTS","CVC","CVD","CVE","CVF","CVN","SA1","SA2","SA3","SA4","SAH","SB1","SE4","SEB","SED","SET","SF4","SF5","SFC","SRJ","SRN","SRV"}
_aTabela := {"CT0","CT1","CT5","CT8","CTD","CTH","CTS","CVC","CVD","CVE","CVF","CVN","SA1","SA2","SA3","SA4","SAH","SB1","SE4","SEB","SED","SET","SF4","SF5","SFC","SRJ","SRN","SRV"}

SM0->(dbSetOrder(1))
SM0->(dbSeek(cEmpAnt))

ProcRegua(SM0->(RECCOUNT()))

While SM0->(!Eof()) .And. !_lFim
	
	IncProc()
	
	If _lFim
		Alert("Cancelado pelo Usuario!!!!")
	Endif
	
	//If SM0->M0_CODIGO == "01"
	//	SM0->(dbSkip())
	//	Loop
	//Endif
	
	_cArq  := "SX2" + SM0->M0_CODIGO + "0"
	dbUseArea( .T.,, _cArq, "ZX2", .T., .F. )
	dbSetIndex(_cArq)
	
	For AX:= 1 To Len(_aTabela)
		
		ZX2->(dbSetOrder(1))
		If ZX2->(dbSeek(_aTabela[AX]))
			ZX2->(RecLock("ZX2",.F.))
			ZX2->X2_ARQUIVO := ZX2->X2_CHAVE+"010"
			ZX2->X2_MODO    := "C"
			ZX2->X2_MODOEMP := "C"
			ZX2->(MsUnLock())
		Endif
	Next AX
	
	ZX2->(dbCloseArea())
	
	_cMatEmp := SM0->M0_CODIGO
	
	While SM0->(!Eof()) .And. _cMatEmp == SM0->M0_CODIGO
		SM0->(dbSkip())
	EndDo
EndDo

Return


Static Function MAX003_02(_lFim)

SM0->(dbSetOrder(1))
SM0->(dbSeek(cEmpAnt))

While SM0->(!Eof()) .And. SM0->M0_CODIGO == cEmpAnt
	
	SD1->(dbSetOrder(6))
	SD1->(dbSeek(SM0->M0_CODFIL+DTOS(MV_PAR01),.T.))
	
	ProcRegua(SD1->(RECCOUNT()))
	
	While SD1->(!Eof()) .And. SD1->D1_DTDIGIT <= MV_PAR02 .And. SD1->D1_FILIAL == SM0->M0_CODFIL
		
		_cNota    := SD1->D1_DOC + SD1->D1_SERIE
		_cFornece := SD1->D1_FORNECE + SD1->D1_LOJA
		
		_nTotBase := _nTotCof  := _nTotPis  := 0
		
		While SD1->(!Eof()) .And. _cNota == SD1->D1_DOC + SD1->D1_SERIE
			
			IncProc()
			
			If _lFim
				Alert("Cancelado pelo Usuario!!!!")
			Endif
			
			_nBase := 0
			_nCof  := 0
			_nPis  := 0
			
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
			
			//		_nAliPIS := SB1->B1_PPIS
			//		_nAliCOF := SB1->B1_PCOFINS
			
			_nAliPIS := 1.65
			_nAliCOF := 7.60
			
			SF4->(dbSetOrder(1))
			If SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
				If SF4->F4_PISCOF == "4"
					_nBase   := 0
					_nCof    := 0
					_nPis    := 0
					_nAliCof := 0
					_nAliPis := 0
				Else
					_nBase := SD1->D1_TOTAL + SD1->D1_VALFRE + SD1->D1_DESPESA - SD1->D1_VALDESC
					_nCof  := Round((_nBase * (_nAliCof / 100)),2)
					_nPis  := Round((_nBase * (_nAliPis / 100)),2)
				Endif
			Endif
			
			_nTotBase += _nBase
			_nTotCof  += _nCof
			_nTotPis  += _nPis
			
			SD1->(RecLock("SD1",.F.))
			SD1->D1_BASIMP5 := _nBase
			SD1->D1_BASIMP6 := _nBase
			SD1->D1_VALIMP5 := _nCof
			SD1->D1_VALIMP6 := _nPis
			SD1->D1_ALQIMP5 := _nAliCof
			SD1->D1_ALQIMP6 := _nAliPis
			SD1->(MsUnlock())
			
			_nRecSD1 := SD1->(RecNo())
			
			SD1->(dbSkip())
			
		EndDo
		
		_nPisCalc := Round((_nTotBase * (_nAliPis / 100)),2)
		_nDifPis  := _nTotPis - _nPisCalc
		
		_nCofCalc := Round((_nTotBase * (_nAliCof / 100)),2)
		_nDifCof  := _nTotCof - _nCofCalc
		
		If _nDifPis <> 0
			SD1->(dbGoto(_nRecSD1))
			SD1->(RecLock("SD1",.F.))
			SD1->D1_VALIMP6 -= _nDifPis
			SD1->(MsUnlock())
		Endif
		
		If _nDifCof <> 0
			SD1->(dbGoto(_nRecSD1))
			SD1->(RecLock("SD1",.F.))
			SD1->D1_VALIMP5 -= _nDifCof
			SD1->(MsUnlock())
		Endif
		
		SF1->(dbSetOrder(1))
		If SF1->(dbSeek(xFilial("SF1")+_cNota + _cFornece))
			SF1->(RecLock("SF1",.F.))
			SF1->F1_BASIMP5 := _nTotBase
			SF1->F1_BASIMP6 := _nTotBase
			SF1->F1_VALIMP5 := _nTotCof
			SF1->F1_VALIMP6 := _nTotPis
			SF1->(MsUnLock())
		Endif
	EndDo
	
	SM0->(dbSkip())
EndDo

Return



Static Function ATUSX1()

cPerg := "MAX003"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 -> Data De                                                 ³
//³ mv_par02 -> Data Ate                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01     /defspa1/defeng1/Cnt01/Var02/Def02     /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Data De              	   ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR01","       "   ,""     ,""     ,""   ,""   ,"     "   ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"02","Data Ate             	   ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02","       "   ,""     ,""     ,""   ,""   ,"     "   ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"03","Entrada / Saida      	   ?",""       ,""      ,"mv_ch3","N" ,01     ,0      ,0     ,"C",""        ,"MV_PAR03","Entrada"   ,""     ,""     ,""   ,""   ,"Saida"   ,""     ,""     ,""   ,""   ,"Ambos",""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")

Return