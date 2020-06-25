#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LPGPE    ³ Autor ³ Alexandro Silva       ³ Data ³ 04/10/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Lançamento Padronizado do GESTAO PESSOAL                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FOLHA                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LPGPEV01()

_aAliOri := GetArea()
_aAliSZ9 := SZ9->(GetArea())

_nValor  := SRZ->RZ_VAL   
/*                                 
SZ9->(dbSetOrder(1))
If SZ9->(dbSeek(xFilial("SZ9")+SRZ->RZ_PD + SRZ->RZ_CC))
	If !Empty(SZ9->Z9_CONTAD) .And. Empty(SZ9->Z9_CONTAC)
		_nValor := SRZ->RZ_VAL   
	ElseIf Empty(SZ9->Z9_CONTAD) .And. !Empty(SZ9->Z9_CONTAC)
		_nValor := SRZ->RZ_VAL   
	ElseIf !Empty(SZ9->Z9_CONTAD) .And. !Empty(SZ9->Z9_CONTAC)
		_nValor := SRZ->RZ_VAL   
	Endif
Else
	SZ9->(dbSetOrder(1))
	If SZ9->(dbSeek(xFilial("SZ9")+SRZ->RZ_PD+Space(09)))
		If !Empty(SZ9->Z9_CONTAD) .And. Empty(SZ9->Z9_CONTAC)
			_nValor := SRZ->RZ_VAL   
		ElseIf Empty(SZ9->Z9_CONTAD) .And. !Empty(SZ9->Z9_CONTAC)
			_nValor := SRZ->RZ_VAL   
		ElseIf !Empty(SZ9->Z9_CONTAD) .And. !Empty(SZ9->Z9_CONTAC)
			_nValor := SRZ->RZ_VAL   
		Endif
	Endif
Endif
*/
RestArea(_aAliSZ9)
RestArea(_aAliOri)

Return(_nValor)


User Function LPGPED01(_cCC)

_aAliOri := GetArea()
_aAliCT1 := CT1->(GetArea())  
_aAliCTT := CTT->(GetArea()) 
_aAliSRA := SRA->(GetArea()) 
_aAliSZ9 := SZ9->(GetArea())
                           
If !Empty(_cCC)
	_cRetorno:= Space(09)               
Else
	_cRetorno:= Space(20)                
Endif

If cEmpAnt == "06" 
	_cFil := "085"
Else		      
	_cFil := Left(cFilAnt,3)
Endif

If Alltrim(FunName()) $ "PXH015"
	_cCC2    := FOL->RD_CC
	_cVerba  := FOL->RD_PD
Else
	_cCC2    := SRZ->RZ_CC   
	_cVerba  := SRZ->RZ_PD
Endif

SRA->(dbSetOrder(1))
SRA->(dbSeek(xFilial("SRA")+SRZ->RZ_MAT))                                         
                      
CTT->(dbSetOrder(1))
If CTT->(dbSeek(xFilial("CTT")+_cCC2))                                         
	SZ9->(dbSetOrder(4))
	If SZ9->(!dbSeek(xFilial("SZ9")+cEmpAnt + _cFil + _cVerba + CTT->CTT_YTPCUS))
   		If SZ9->(!dbSeek(xFilial("SZ9") + cEmpAnt + _cFil + _cVerba))
			_cRetorno:= SZ9->Z9_CONTAD
			
			If !Empty(_cCC)
				CT1->(dbSetOrder(1))
				CT1->(dbSeek(xFilial("CT1")+_cRetorno))
				
				If CT1->CT1_ACCUST == "1"
					_cRetorno := _cCC2
				Else
					_cRetorno := Space(09)
				Endif
			Endif
			
   		Else
   		 	MSGINFO("Verba Nao Cadastrada! "+_cVerba)	 	
		Endif
	Else
		_cRetorno:= SZ9->Z9_CONTAD
			
		If !Empty(_cCC)
			CT1->(dbSetOrder(1))
			CT1->(dbSeek(xFilial("CT1")+_cRetorno))
			
			If CT1->CT1_ACCUST == "1"
				_cRetorno := _cCC2
			Else
				_cRetorno := Space(09)
			Endif
		Endif	
	Endif		
Endif       

RestArea(_aAliCT1)   
RestArea(_aAliCTT)  
RestArea(_aAliSRA)
RestArea(_aAliSZ9)
RestArea(_aAliOri)

Return(_cRetorno)


User Function LPGPEC01(_cCC)

_aAliOri := GetArea()
_aAliCT1 := CT1->(GetArea())  
_aAliCTT := CTT->(GetArea()) 
_aAliSZ9 := SZ9->(GetArea())

If !Empty(_cCC)
	_cRetorno:= Space(09)               
Else
	_cRetorno:= Space(20)                
Endif

If cEmpAnt == "06" 
	_cFil := "085"
Else		      
	_cFil := Left(cFilAnt,3)
Endif
                     
If Alltrim(FunName()) $ "PXH015"
	_cCC2    := FOL->RD_CC
	_cVerba  := FOL->RD_PD
Else
	_cCC2    := SRZ->RZ_CC   
	_cVerba  := SRZ->RZ_PD
Endif

SRA->(dbSetOrder(1))
SRA->(dbSeek(xFilial("SRA")+SRZ->RZ_MAT))                                         

CTT->(dbSetOrder(1))
If CTT->(dbSeek(xFilial("CTT")+_cCC2))                                         
	SZ9->(dbSetOrder(4))
	If SZ9->(!dbSeek(xFilial("SZ9")+cEmpAnt + _cFil + _cVerba + CTT->CTT_YTPCUS))
   		If SZ9->(!dbSeek(xFilial("SZ9") + cEmpAnt + _cFil + _cVerba))
			_cRetorno := SZ9->Z9_CONTAC
			
			If !Empty(_cCC)
				CT1->(dbSetOrder(1))
				CT1->(dbSeek(xFilial("CT1") + _cRetorno))
				
				If CT1->CT1_ACCUST == "1"
					_cRetorno := _cCC2
				Else
					_cRetorno := Space(09)
				Endif
			Endif			
		Else
   		 	MSGINFO("Verba Nao Cadastrada! "+_cVerba)	 	
  		Endif
 	Else
		_cRetorno := SZ9->Z9_CONTAC
		If !Empty(_cCC)
			CT1->(dbSetOrder(1))
			CT1->(dbSeek(xFilial("CT1") + _cRetorno))
			
			If CT1->CT1_ACCUST == "1"
				_cRetorno := _cCC2
			Else
				_cRetorno := Space(09)
			Endif
		Endif
    Endif
Endif

RestArea(_aAliCT1)  
RestArea(_aAliCTT) 
RestArea(_aAliSZ9)
RestArea(_aAliOri)

Return(_cRetorno)