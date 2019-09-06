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
_aAliSD3  := SD3->(GetArea())
_aAliSF4  := SF4->(GetArea())
                      
_cLote    := ""


If Alltrim(FunName()) == "MATA103"
	dbSelectArea("SF4")
	dbSetOrder(1)
	If dbSeek(xFilial("SF4")+SD1->D1_TES)
//		If SF4->F4_PODER3 != "N" .And. SD1->D1_TIPO == "B"      
		If SF4->F4_PODER3 == "D" .And. !SD1->D1_TIPO $ "N/B"      // Alterado em 30/11/06 devido material fornecido pelo Cliente 
			RestArea(_aAliSD1)                                    // utilizar numero do lote
			RestArea(_aAliSF4)
			RestArea(_aAliOri)
			Return(_cLote)
		Endif
	Endif		
                       
	_cProduto := SD1->D1_COD
	_cDoc     := SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA

	dbSelectArea("SD1")
	dbOrderNickName("INDSD11")
	dbSeek(xFilial("SD1")+ _cProduto + "999999",.t.)
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
Else
	_cProduto := SD3->D3_COD
	_cNumSeq  := SD3->D3_NUMSEQ

	dbSelectArea("SD3")
	dbOrderNickName("INDSD32")
	dbSeek(xFilial("SD3")+ _cProduto + "999999",.T.)
	dbSkip(-1)
                             
	If _cProduto == SD3->D3_COD  	
	   	If _cNumSeq == SD3->D3_NUMSEQ
		    If Empty(SD3->D3_LOTECTL)
				_cLote := StrZero(Val(SD3->D3_LOTECTL)+1,6)        
	   		Else
				_cLote := SD3->D3_LOTECTL
			Endif
		Else
			_cLote := StrZero(Val(SD3->D3_LOTECTL)+1,6)
		Endif
	Else
	    _cLote := "000001"
	Endif                 	
Endif
                  
RestArea(_aAliSF4)
RestArea(_aAliSD1)
RestArea(_aAliSD3)
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
	dbSeek(xFilial("SD1")+ _cProduto + "999999",.t.)
	dbSkip(-1)
	         
	dbSelectArea("SC7")
	dbOrderNickName("INDSC73")
	dbSeek(xFilial("SC7")+ _cProduto + "999999",.t.)
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
	dbSeek(xFilial("SD1")+ _cProduto + "999999",.t.)
	dbSkip(-1)
/*         
	dbSelectArea("SC7")
	dbOrderNickName("INDSC73")
	dbSeek(xFilial("SC7")+ _cProduto + "999999",.t.)
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


User Function GCOM004()  // Solicitacao de Compra

_aAliOri := GetArea()
_aAliSB1 := SB1->(GetArea())
               
_nPosP    := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C1_PRODUTO" } )
_nPosQt   := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C1_QUANT" } )
       
_cProduto := Acols[n][_nPosP]
_nQuant   := Acols[n][_nPosQt]

dbSelectArea("SB1")                                                      
dbSetOrder(1)
dbSeek(xFilial("SB1")+_cProduto)

If SB1->B1_LM > 0
	If M->C1_QUANT < SB1->B1_LM
		Alert("QUANTIDADE SOLIC. MENOR QUE LOTE MINIMO DO PRODUTO! :"+STR(SB1->B1_LM))
		_nQuant := SB1->B1_LM
	Endif
Endif		

RestArea(_aAliSB1)
RestArea(_aAliOri)

Return(_nQuant)
                     

User Function GCOM005()  // Solicitacao de Compra

_aAliOri := GetArea()
_aAliSB1 := SB1->(GetArea())

_nPosP    := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C1_PRODUTO" } )
_nPosDt   := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C1_DATPRF" } )
       
_cProduto := Acols[n][_nPosP]
_dEnt     := Acols[n][_nPosDt]
              
dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+_cProduto)

If !Empty(_dEnt)
	If (_dEnt - DA110DATA) < SB1->B1_PE
		_dDtCor := DA110DATA + SB1->B1_PE
		Alert("DATA DE ENTREGA MENOR QUE LEAD TIME!! DATA CORRETA : "+DTOC(_dDtCor))
//		_dEnt := _dDtCor
	Endif
Endif		

RestArea(_aAliSB1)
RestArea(_aAliOri)

Return(_dEnt)

User Function GCOM006()  // Solicitacao de Compra

_aAliOri := GetArea()
_aAliSB1 := SB1->(GetArea())

_nPosP    := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C1_PRODUTO" } )
_nPosDt   := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C1_DATPRF" } )
       
_cProduto := Acols[n][_nPosP]
_dEnt     := Acols[n][_nPosDt]
              
dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+_cProduto)

If !Empty(_dEnt)
	If (_dEnt - DA110DATA) < SB1->B1_PE
		_dEnt := DA110DATA + SB1->B1_PE
	Endif
Endif		

RestArea(_aAliSB1)
RestArea(_aAliOri)

Return(_dEnt)