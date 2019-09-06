#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT440GR ³ Autor ³Alexandro da Silva     ³ Data ³ 23/06/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Filtra a Liberação dos Pedidos                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Sigafat                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

/*/

User Function MT440GR()

_aAliOri  := GETAREA()
_aAliSZ2  := SZ2->(GETAREA())

_nPProd   := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRODUTO" } )
_nPProdC  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_CPROCLI" } )
_nPitem   := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_ITEM" } )
_lRet     := .T.

If SC5->C5_TIPO == "N"
	For AX:= 1 To Len(Acols)
		_cProd  := ACOLS[AX,_nPProd]
		_cProdC := ACOLS[AX,_nPProdC]
		_cItem  := ACOLS[AX,_nPItem]
		
		SZ2->(dbSetOrder(1))
		If SZ2->(dbSeek(xFilial("SZ2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI + _cProd + _cProdC+"1"))
			If SZ2->Z2_TPAPROV == "4"
				MSGINFO("ITEM SEM APROVACAO. FAVOR CONTACTAR C.Q. !!")
				_lRet:= .F.
			Endif
		Endif
	Next AX
Endif

RestArea(_aAliSZ2)
RestArea(_aAliOri)

Return(_lRet)