#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Rotina   ³ GATCTB                                   ³ Data ³ 22/04/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gatilhos do Modulo Gerencial                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Módulo   ³ SIGACFG                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GCTB001(_cCampo)

_aAliOri := GetArea()
_aAliCT1 := CT1->(GetArea())
_cCodigo := Alltrim(M->CT1_XCOD) + Alltrim(M->CT1_XEMP)
_cEmp    := M->CT1_XEMP

CT1->(dbSetOrder(1))
CT1->(dbSeek(xFilial("CT1")+_cCodigo+"999",.T.))

CT1->(dbSkip(-1))

If _cCodigo == Left(CT1->CT1_CONTA,8)
	_cComp := Soma1(Right(Alltrim(CT1->CT1_CONTA),3))
Else
	_cComp := "001"
Endif

If Empty(_cEmp)
	M->CT1_CONTA := Alltrim(M->CT1_XCOD)
	M->CT1_CTLALU:= Alltrim(M->CT1_XCOD)	
Else
	M->CT1_CONTA := _cCodigo  + _cComp
	M->CT1_CTLALU:= _cCodigo  + _cComp
Endif


If _cCampo = "CT1_CLASSE"
	
	_cRetorno := M->CT1_CLASSE
	
	If M->CT1_CLASSE == "2"
		
		If Len(Alltrim(M->CT1_CONTA)) < 11
			MSGINFO("Favor Verificar Se a Conta Foi Digitada Corretamente!!")
			M->CT1_CONTA := Space(20)
			M->CT1_CTLALU:= Space(20)
		Endif
	Else
		M->CT1_CONTA := Alltrim(M->CT1_XCOD)
		M->CT1_CTLALU:= Alltrim(M->CT1_XCOD)
		M->CT1_XEMP  := Space(03)
	Endif
ElseIf _cCampo = "CT1_XCOD"
	_cRetorno     := M->CT1_XCOD
	
	M->CT1_CLASSE := ""
	
ElseIf _cCampo = "CT1_XEMP"
	_cRetorno     := M->CT1_XEMP

	CT1->(dbOrderNickName("INDCT11"))
	If CT1->(dbSeek(xFilial("CT1")+M->CT1_XCOD + _cComp))
		M->CT1_DESC01 := CT1->CT1_DESC01
	Endif
	
	M->CT1_CLASSE := ""
	
ElseIf _cCampo = "CT1_XCTAF"
	_cRetorno     := M->CT1_XCTAF

	CT1->(dbSetOrder(1))
	If CT1->(dbSeek(xFilial("CT1")+M->CT1_XCOD + M->CT1_XEMP + M->CT1_XCTAF))
		M->CT1_CLASSE := ""
	Else
		M->CT1_CONTA := M->CT1_XCOD + M->CT1_XEMP + M->CT1_XCTAF
		M->CT1_CTLALU:= M->CT1_XCOD + M->CT1_XEMP + M->CT1_XCTAF
	Endif
	
	_cComp := M->CT1_XCTAF	
Endif

M->CT1_CTASUP	:= CtbCtaSup(M->CT1_CONTA)
M->CT1_XCTAF    := _cComp

RestArea(_aAliCT1)
RestArea(_aAliOri)

Return(_cRetorno)

User Function GCTB002()

_aAliOri := GetArea()
                   
_lRet := .F. 

/// CT1_XEMP == LEFT(CFILANT,3) .OR. EMPTY(CT1_XEMP) .OR. LEFT(CFILANT,3) $ "085/066/088/089/090"

If Empty(CT1_XEMP)
	_lRet := .T.
Else
	If cEmpAnt == "06"
		If CT1_XEMP == "085"
	       _lRet := .T.
	 	Endif        
	Else 
		If CT1_XEMP == Left(cFilAnt,3)
			_lRet := .T.
		Endif
	Endif
Endif

RestArea(_aAliORI)

Return(_lRet)