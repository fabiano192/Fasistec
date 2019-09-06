#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Rotina   ³ CR0029                                   ³ Data ³ 13/05/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina para Correção dos Movimentos de Saida, referente    ³±±
±±³          ³ aos Impostos PIS / COFINS.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Módulo   ³ SIGAFIS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CR0029()

ATUSX1()

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Rotina Para Acerto da Mov. Fiscal ")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina Para Corrigir os Movimentos Fiscais em rela- "     SIZE 160,7
@ 18,18 SAY "çao aos Impostos PIS / COFINS que não foram lançados"     SIZE 160,7
@ 26,18 SAY "corretmante.                                        "     SIZE 160,7
@ 34,18 SAY "Programa CR0029.PRW                                 "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("CR0029")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

Activate Dialog oDlg Centered

If _nOpc == 1
	Pergunte("CR0029",.F.)
	
	///////////////////////////////////////
	//// MV_PAR01 : Data De             ///
	//// MV_PAR02 : Data Ate            ///
	///////////////////////////////////////
	
	Private _cMsg01    := ''
	Private _lFim      := .F.
	Private _lAborta01 := .T.
	
	If MV_PAR03 == 1
		Private _bAcao01   := {|_lFim| NS46_A(@_lFim) }
		Private _cTitulo01 := 'Gerando Movimentacao !!!!'
	ElseIf MV_PAR03 == 2
		Private _bAcao01   := {|_lFim| NS46_B(@_lFim) }
		Private _cTitulo01 := 'Gerando Movimentacao !!!!'
	Else
		Private _bAcao01   := {|_lFim| NS46_A(@_lFim) }
		Private _cTitulo01 := 'Gerando Movimentacao !!!!'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
		
		Private _bAcao01   := {|_lFim| NS46_B(@_lFim) }
		Private _cTitulo01 := 'Gerando Movimentacao !!!!'
	Endif
	
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
Endif

Return


Static Function NS46_A(_lFim)

SD2->(dbSetOrder(5))
SD2->(dbSeek(xfilial("SD2")+DTOS(MV_PAR01),.T.))

ProcRegua(SD2->(RECCOUNT()))

While SD2->(!Eof()) .And. SD2->D2_EMISSAO <= MV_PAR02
	
	_cNota    := SD2->D2_DOC + SD2->D2_SERIE
	_cCliente := SD2->D2_CLIENTE + SD2->D2_LOJA
	
	_nTotBase := _nTotCof  := _nTotPis  := 0
	
	While SD2->(!Eof()) .And. _cNota == SD2->D2_DOC + SD2->D2_SERIE
		
		IncProc()
		
		If _lFim
			Alert("Cancelado pelo Usuario!!!!")
		Endif
		
		_nBase := 0
		_nCof  := 0
		_nPis  := 0
		
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD))
		
		_nAliPIS := 1.65//SB1->B1_PPIS
		_nAliCOF := 7.60//SB1->B1_PCOFINS
		
		SF4->(dbSetOrder(1))
		If SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
			If SF4->F4_PISCOF == "4"
				_nBase := 0
				_nCof  := 0
				_nPis  := 0
				_nAliPIS := 0
				_nAliCOF := 0
			Else
				_nBase := SD2->D2_TOTAL + SD2->D2_VALFRE
				_nCof  := Round((_nBase * (_nAliCof / 100)),2)
				_nPis  := Round((_nBase * (_nAliPis / 100)),2)
			Endif
		Endif
		
		_nTotBase += _nBase
		_nTotCof  += _nCof
		_nTotPis  += _nPis
		
		SD2->(RecLock("SD2",.F.))
		SD2->D2_BASIMP5 := _nBase
		SD2->D2_BASIMP6 := _nBase
		SD2->D2_VALIMP5 := _nCof
		SD2->D2_VALIMP6 := _nPis
		SD2->D2_ALQIMP5 := _nAliCof
		SD2->D2_ALQIMP6 := _nAliPis
		SD2->(MsUnlock())
		
		SFT->(dbSetorder(1))
		If SFT->(dbSeek(SD2->D2_FILIAL + "S" + SD2->D2_SERIE + SD2->D2_DOC + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_ITEM))
			SFT->(RecLock("SFT",.F.))
			SFT->FT_BASEPIS := SD2->D2_BASIMP6
			SFT->FT_ALIQPIS := SD2->D2_ALQIMP6
			SFT->FT_VALPIS  := SD2->D2_VALIMP6
			SFT->FT_CSTPIS  := SF4->F4_CSTPIS
			SFT->FT_BASECOF := SD2->D2_BASIMP5
			SFT->FT_ALIQCOF := SD2->D2_ALQIMP5
			SFT->FT_VALCOF  := SD2->D2_VALIMP5
			SFT->FT_CSTCOF  := SF4->F4_CSTPIS
			SFT->(MsUnlock())
		Endif
		
		SD2->(dbSkip())
		
	EndDo
	
	SF2->(dbSetOrder(1))
	If SF2->(dbSeek(xFilial("SF2")+_cNota + _cCliente))
		SF2->(RecLock("SF2",.F.))
		SF2->F2_BASIMP5 := _nTotBase
		SF2->F2_BASIMP6 := _nTotBase
		SF2->F2_VALIMP5 := _nTotCof
		SF2->F2_VALIMP6 := _nTotPis
		SF2->(MsUnLock())
	Endif
		
EndDo

Return


Static Function NS46_B(_lFim)

SD1->(dbSetOrder(6))
SD1->(dbSeek(xfilial("SD1")+DTOS(MV_PAR01),.T.))

ProcRegua(SD1->(RECCOUNT()))

While SD1->(!Eof()) .And. SD1->D1_DTDIGIT <= MV_PAR02
	
	_cNota    := SD1->D1_DOC + SD1->D1_SERIE
	_cFornece := SD1->D1_FORNECE + SD1->D1_LOJA
	
	SF1->(dbSetOrder(1))
	SF1->(dbSeek(xFilial("SF1")+ _cNota + _cFornece))
	/*
	If SF1->F1_EST == "EX"
		SD1->(dbSkip())
		Loop
	Endif
	*/
	_nTotBase := _nTotCof  := _nTotPis  := 0
	
	While SD1->(!Eof()) .And. _cNota == SD1->D1_DOC + SD1->D1_SERIE
		
		IncProc()
		
		If _lFim
			Alert("Cancelado pelo Usuario!!!!")
		Endif
		
		_nBase := 0
		_nCof  := 0
		_nPis  := 0
		_nAliPIS := 1.65//SB1->B1_PPIS
		_nAliCOF := 7.60//SB1->B1_PCOFINS
				
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
		
		SF4->(dbSetOrder(1))
		If SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
			If SF4->F4_PISCOF == "4"
				_nBase := 0
				_nCof  := 0
				_nPis  := 0
				_nAliPIS := 0
				_nAliCOF := 0
			Else
				If Left(SD1->D1_CF,1) == "3"
					_nBase := SD1->D1_BASIMP5
					_nCof  := Round((_nBase * (_nAliCof / 100)),2)
					_nPis  := Round((_nBase * (_nAliPis / 100)),2)
				Else
					_nBase := SD1->D1_TOTAL + SD1->D1_VALFRE
					_nCof  := Round((_nBase * (_nAliCof / 100)),2)
					_nPis  := Round((_nBase * (_nAliPis / 100)),2)
				Endif
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
		
		SFT->(dbSetorder(1))
		If SFT->(dbSeek(SD1->D1_FILIAL + "E" + SD1->D1_SERIE + SD1->D1_DOC + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_ITEM))
			SFT->(RecLock("SFT",.F.))
			SFT->FT_BASEPIS := SD1->D1_BASIMP6
			SFT->FT_ALIQPIS := SD1->D1_ALQIMP6
			SFT->FT_VALPIS  := SD1->D1_VALIMP6
			SFT->FT_CSTPIS  := SF4->F4_CSTPIS
			SFT->FT_BASECOF := SD1->D1_BASIMP5
			SFT->FT_ALIQCOF := SD1->D1_ALQIMP5
			SFT->FT_VALCOF  := SD1->D1_VALIMP5
			SFT->FT_CSTCOF  := SF4->F4_CSTPIS
			SFT->(MsUnlock())
		Endif
		
		SD1->(dbSkip())
		
	EndDo
	
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

Return


Static Function ATUSX1()

cPerg := "CR0029"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 -> Data De                                                 ³
//³ mv_par02 -> Data Ate                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01     /defspa1/defeng1/Cnt01/Var02/Def02     /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Data De              	   ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR01","       "   ,""     ,""     ,""   ,""   ,"        ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"02","Data Ate             	   ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02","       "   ,""     ,""     ,""   ,""   ,"        ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"03","Tipo?                	   ?",""       ,""      ,"mv_ch3","N" ,01     ,0      ,0     ,"C",""        ,"MV_PAR03","Saida  "   ,""     ,""     ,""   ,""   ,"Entrada ",""     ,""     ,""   ,""   ,"Ambos",""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")

Return