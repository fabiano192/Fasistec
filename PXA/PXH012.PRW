#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Rotina   ³ PXH012                                   ³ Data ³ 07/04/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina para Correção dos Movimentos de Saida, referente    ³±±
±±³          ³ aos Impostos PIS / COFINS.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Módulo   ³ SIGAFAT                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PXH012()

ATUSX1()

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Rotina Para Acerto da Mov. Fiscal ")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina Para Corrigir os Movimentos Fiscais em rela- "     SIZE 160,7
@ 18,18 SAY "çao aos Impostos PIS / COFINS que não foram lançados"     SIZE 160,7
@ 26,18 SAY "corretamente                                        "     SIZE 160,7
@ 34,18 SAY "                                                    "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PXH012")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

Activate Dialog oDlg Centered

If _nOpc == 1
	Pergunte("PXH012",.F.)
	
	///////////////////////////////////////
	//// MV_PAR01 : Data De             ///
	//// MV_PAR02 : Data Ate            ///
	///////////////////////////////////////
	
	Private _cMsg01    := ''
	Private _lFim      := .F.
	Private _lAborta01 := .T.
	
	If MV_PAR03 == 1
		Private _bAcao01   := {|_lFim| MAX02_A(@_lFim) }
		Private _cTitulo01 := 'Gerando Movimentacao Saida!!!!'
	ElseIf MV_PAR03 == 2
		Private _bAcao01   := {|_lFim| MAX02_B(@_lFim) }
		Private _cTitulo01 := 'Gerando Movimentacao Entrada!!!!'
	Else
		Private _bAcao01   := {|_lFim| MAX02_A(@_lFim) }
		Private _cTitulo01 := 'Gerando Movimentacao Saida!!!!'
                                                        
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
		Private _bAcao01   := {|_lFim| MAX02_B(@_lFim) }
		Private _cTitulo01 := 'Gerando Movimentacao Entrada!!!!'
	
	Endif
	
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
Endif

Return


Static Function MAX02_A(_lFim)

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
				
		If SD2->D2_EMISSAO <= CTOD("31/12/13") .AND. SD2->D2_FILIAL <> '09001'
			_nAliPIS := 0.65
			_nAliCOF := 3.00
		Else
			_nAliPIS := GETMV("MV_TXPIS")  //SB1->B1_PPIS
			_nAliCOF := GETMV("MV_TXCOFIN")//7.60//SB1->B1_PCOFINS		
		Endif

        _lBaseFret   := GETMV("MV_FRTBASE")
        		
		SF4->(dbSetOrder(1))
		If SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
			If SF4->F4_PISCOF == "4"
				_nBase := 0
				_nCof  := 0
				_nPis  := 0
			Else
				If _lBaseFret 
					_nBase := SD2->D2_TOTAL + SD2->D2_VALFRE
				Else
					_nBase := SD2->D2_TOTAL
				Endif
			
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


Static Function MAX02_B(_lFim)

SD1->(dbSetOrder(6))
SD1->(dbSeek(xfilial("SD1")+DTOS(MV_PAR01),.T.))

ProcRegua(SD1->(RECCOUNT()))

While SD1->(!Eof()) .And. SD1->D1_DTDIGIT <= MV_PAR02
	
	_cNota    := SD1->D1_DOC + SD1->D1_SERIE
	_cFornece := SD1->D1_FORNECE + SD1->D1_LOJA
	
	SF1->(dbSetOrder(1))
	SF1->(dbSeek(xFilial("SF1")+ _cNota + _cFornece))
	
	If SF1->F1_EST == "EX"
		SD1->(dbSkip())
		Loop
	Endif
	
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

		If SD1->D1_DTDIGIT <= CTOD("31/12/13") .AND. SD1->D1_FILIAL <> '09001'
			_nAliPIS := 0.65
			_nAliCOF := 3.00
		Else
			_nAliPIS := GETMV("MV_TXPIS")  //SB1->B1_PPIS
			_nAliCOF := GETMV("MV_TXCOFIN")//7.60//SB1->B1_PCOFINS		
		Endif
		
		//_nAliPIS := SB1->B1_PPIS
		//_nAliCOF := SB1->B1_PCOFINS
		
		SF4->(dbSetOrder(1))
		If SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
			If SF4->F4_PISCOF == "4"
				_nBase := 0
				_nCof  := 0
				_nPis  := 0
			Else
				_nBase := SD1->D1_TOTAL + SD1->D1_VALFRE
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
		SD1->D1_CUSTO   := SD1->D1_TOTAL - SD1->D1_VALIPI - SD1->D1_VALICM - SD1->D1_VALIMP5 - SD1->D1_VALIMP6 + SD1->D1_ICMSRET - SD1->D1_VALFRE + SD1->D1_VALDESC - SD1->D1_DESPESA
		SD1->(MsUnlock())
		
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

cPerg := "PXH012"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 -> Data De                                                 ³
//³ mv_par02 -> Data Ate                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01     /defspa1/defeng1/Cnt01/Var02/Def02     /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Data De              	   ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR01","       "   ,""     ,""     ,""   ,""   ,"        ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"02","Data Ate             	   ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02","       "   ,""     ,""     ,""   ,""   ,"        ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"03","Tipo?                	   ?",""       ,""      ,"mv_ch3","N" ,01     ,0      ,0     ,"C",""        ,"MV_PAR03","Saida  "   ,""     ,""     ,""   ,""   ,"Entrada ",""     ,""     ,""   ,""   ,"Ambos",""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")

Return