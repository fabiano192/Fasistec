#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GAT001     º Autor ³ Alexandro da Silvaº Data ³  17/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gatilhos de Compras                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GCOM001()

_aAliOri  := GetArea()
_aAliSD1  := SD1->(GetArea())

_cProduto := SD1->D1_COD
_cDoc     := SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA

dbSelectArea("SD1")
dbOrderNickName("INDSD11")
dbSeek(xFilial()+ _cProduto + "999999",.t.)
dbSkip(-1)

If _cProduto == SD1->D1_COD
   	If _cDoc == SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
        If Empty(SD1->D1_LOTECTL)
			_cLote := StrZero(Val(SD1->D1_LOTECTL)+1,6)
        Else
			_cLote := SD1->D1_LOTECTL
		Endif
	Else
		_cLote := StrZero(Val(SD1->D1_LOTECTL)+1,6)
	Endif
Else
    _cLote := "000001"
Endif

RestArea(_aAliSD1)
RestArea(_aAliOri)

Return(_cLote)


User Function GCOM002()  // Nota Fiscal de Entrada

_aAliOri := GetArea()
_aAliSC7 := SC7->(GetArea())
_aAliSD1 := SD1->(GetArea())

_nPosP    := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "D1_COD" } )
_nPosLote := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "D1_LOTECTL" } )

_cLote    := Acols[n][_nPosLote]
_cProduto := Acols[n][_nPosP]
_lLote    := .F.

For I:= 1 To Len(aCols)
	_cProd := Acols[I][_nPosP]

	If I != N .And. _cProduto == _cProd
		_cLote := Acols[I][_nPosLote]
		_lLote := .T.
	Endif
Next I

_cLote := StrZero(Val(_cLote)+1,6)

If !_lLote
	dbSelectArea("SD1")
	dbOrderNickName("INDSD11")
	dbSeek(xFilial()+ _cProduto + "999999",.t.)
	dbSkip(-1)

	dbSelectArea("SC7")
	dbOrderNickName("INDSC73")
	dbSeek(xFilial()+ _cProduto + "999999",.t.)
	dbSkip(-1)

	If SD1->D1_LOTECTL > SC7->C7_LOTE
		_cLote := StrZero(Val(SD1->D1_LOTECTL)+1,6)
	Else
		_cLote := StrZero(Val(SC7->C7_LOTE)+1,6)
	Endif
Endif

RestArea(_aAliSC7)
RestArea(_aAliSD1)
RestArea(_aAliOri)

Return(_cLote)


User Function GCOM003()  // Pedido de Compras

_aAliOri := GetArea()
//_aAliSC7 := SC7->(GetArea())
_aAliSD1 := SD1->(GetArea())
/*
_nPosP    := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C7_PRODUTO" } )
_nPosLote := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C7_LOTE" } )

_cLote    := Acols[n][_nPosLote]
_cProduto := Acols[n][_nPosP]
_lLote    := .F.

For I:= 1 To Len(aCols)
	_cProd := Acols[I][_nPosP]

	If I != N .And. _cProduto == _cProd
		_cLote := Acols[I][_nPosLote]
		_lLote := .T.
	Endif
Next I

_cLote := StrZero(Val(_cLote)+1,6)
*/
//If !_lLote

// Os Grupos MPVZ / PIVZ e o Almoxarifado 01   serão controlados por lote

	dbSelectArea("SD1")
	dbOrderNickName("INDSD11")
	dbSeek(xFilial()+ _cProduto + "999999",.t.)
	dbSkip(-1)
/*
	dbSelectArea("SC7")
	dbOrderNickName("INDSC73")
	dbSeek(xFilial()+ _cProduto + "999999",.t.)
	dbSkip(-1)
*/
 //	If SD1->D1_LOTECTL > SC7->C7_LOTE
		_cLote := StrZero(Val(SD1->D1_LOTECTL)+1,6)
 //	Else
 //		_cLote := StrZero(Val(SC7->C7_LOTE)+1,6)
 //	Endif
//Endif

//RestArea(_aAliSC7)
RestArea(_aAliSD1)
RestArea(_aAliOri)

Return(_cLote)



USER FUNCTION GCOM004()

_aAliOri := GetArea()
_aAliSC7 := SC7->(GetArea())

_nPQuant := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C7_QUANT" } )
_nPProd  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C7_PRODUTO" } )

_nQuant := aCols[n][_nPQuant]

SB1->(dbSetOrder(1))
SB1->(msSeek(xFilial('SB1')+aCols[n][_nPProd]))


_nDif := aCols[n][_nPQuant] % SB1->B1_LE
If _nDif > 0
	If !MsgYesNo('Quantidade digitada não é multiplo de: '+Alltrim(Str(SB1->B1_LE))+'! Confirma?')
		_nQuant := 0
	Endif
Endif

RestArea(_aAliSC7)
RestArea(_aAliOri)

RETURN(_nQuant)