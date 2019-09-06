#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³           º Autor ³ Fabiano da Silva  º Data ³  15/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gatilhos do Modulo Financeiro                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFin                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GFIN001() // Movimentação Bancária

_aAliOri  := GetArea()
_aAliSE5  := SE5->(GetArea())
_aAliSA6  := SA6->(GetArea())

_cAgencia :=""// M->A6_AGENCIA
_lVai := .F.

dbSelectArea("SA6")
dbSetOrder(1)
If dbSeek(xFilial("SA6")+M->E5_BANCO)
	If SA6->A6_TPBANCO != "3"
		_cAgencia := SA6->A6_AGENCIA
	Else
		_lVai := .T.
	Endif
Endif

If _lVai	
	_cBanco := SA6->A6_COD
	_lRet := .T.
	While !EOF() .And. _cBanco == SA6->A6_COD .And. _lRet
			
		If SA6->A6_TPBANCO != "3"
			_cAgencia := SA6->A6_AGENCIA
			_lRet := .F.
			_lVai := .F.
		Endif
			
		dbSelectArea("SA6")
		dbSkip()
	EndDo	
Endif
	
RestArea(_aAliSA6)
RestArea(_aAliSE5)
RestArea(_aAliOri)

Return(_cAgencia)
