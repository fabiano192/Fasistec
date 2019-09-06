#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function LPFATD01(_cTp)

_aAliOri := GetArea()
_aAliSA1 := SA1->(GetArea())
_aAliSA2 := SA2->(GetArea())
_aAliSB1 := SB1->(GetArea())
_aAliSZI := SZI->(GetArea())

_CCTAICM := _CCTAIPI := _CCTAPIS := _CCTACOF := _CCTAMER := _cConta := ""

SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD))                   

_cTpVenda := ""

_cTp := Substr(Alltrim(_cTp)+Space(10),1,6)

If !SD2->D2_TIPO $ "D/B"
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA))
	_cTpVenda := SA1->A1_TPVENDA
	If Alltrim(_cTp) == "MER"
		If Empty(_cTpVenda)
			_cTpVenda := "R"
		Endif	
	Endif
Else
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA))
Endif

SZI->(dbSetOrder(1))
If SZI->(dbSeek(xFilial("SZI")+SD2->D2_CF + _cTp + _cTpVenda))
	If ALLTRIM(SZI->ZI_DEBITO) == "CLIENTE"
		_cConta := SA1->A1_CONTA
	ElseIf ALLTRIM(SZI->ZI_DEBITO) == "PRODUTO"
		_cConta := SB1->B1_CONTA
	ElseIf ALLTRIM(SZI->ZI_DEBITO) == "FORNECEDOR"
		_cConta := SA2->A2_CONTA
	Else
		_cConta := SZI->ZI_DEBITO
	Endif
Endif


RestArea(_aAliSZI)
RestArea(_aAliSA1)
RestArea(_aAliSA2)
RestArea(_aAliSB1)
RestArea(_aAliOri)

Return(_cConta)


User Function LPFATC01(_cTp)

_aAliOri := GetArea()
_aAliSA1 := SA1->(GetArea())
_aAliSB1 := SB1->(GetArea())
_aAliSZI := SZI->(GetArea())

_CCTAICM := _CCTAIPI := _CCTAPIS := _CCTACOF := _CCTAMER := _cConta := ""

SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD))

_cTpVenda := ""
_cTp := Substr(Alltrim(_cTp)+Space(10),1,6)

If !SD2->D2_TIPO $ "D/B"
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA))
	_cTpVenda := SA1->A1_TPVENDA
	If Alltrim(_cTp) == "MER"
		If Empty(_cTpVenda)
			_cTpVenda := "R"
		Endif	
	Endif

Else
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA))
Endif

SZI->(dbSetOrder(1))
If SZI->(dbSeek(xFilial("SZI")+SD2->D2_CF + _cTp + _cTpVenda))
	If ALLTRIM(SZI->ZI_CREDITO) == "CLIENTE"
		_cConta := SA1->A1_CONTA
	ElseIf ALLTRIM(SZI->ZI_CREDITO) == "PRODUTO"
		_cConta := SB1->B1_CONTA
	ElseIf ALLTRIM(SZI->ZI_CREDITO) == "FORNECEDOR"
		_cConta := SA2->A2_CONTA
	Else
		_cConta := SZI->ZI_CREDITO
	Endif
Endif

RestArea(_aAliSA1)
RestArea(_aAliSB1)
RestArea(_aAliSZI)
RestArea(_aAliORI)

Return(_cConta)


User Function LPFATH01(_cTp)

_aAliOri := GetArea()
_aAliSA1 := SA1->(GetArea())
_aAliSA2 := SA2->(GetArea())
_aAliSZI := SZI->(GetArea())
_cHistor := _cNReduz := ""

_cTp := Substr(Alltrim(_cTp)+Space(10),1,6)

If !SD2->D2_TIPO $ "B/D"
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA))
	_cNReduz := SA1->A1_NREDUZ
Else
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA))
	_cNReduz := SA2->A2_NREDUZ
Endif

SZI->(dbSetOrder(1))
If SZI->(dbSeek(xFilial("SZI")+SD2->D2_CF + _cTp))
	_cHistor := LEFT(ALLTRIM(SZI->ZI_HIST)+" "+ALLTRIM(SD2->D2_DOC)+" - "+ALLTRIM(_cNReduz),40)
Endif

/*
If _cTp = "MER"
	_cHistor:= LEFT("VENDA CONF. NF "+SD2->D2_DOC+" - "+ALLTRIM(SA1->A1_NREDUZ),40)
ElseIf _cTp = "ICM"
	_cHistor:= LEFT("ICMS S/VENDA CONF. NF "+SD2->D2_DOC+" - "+ALLTRIM(SA1->A1_NREDUZ),40)
ElseIf _cTp = "IPI"
	_cHistor:= LEFT("IPI S/VENDA CONF. NF "+SD2->D2_DOC+" - "+ALLTRIM(SA1->A1_NREDUZ),40)
ElseIf _cTp = "COF"
	_cHistor:= LEFT("COFINS S/VENDA CONF. NF "+SD2->D2_DOC+" - "+ALLTRIM(SA1->A1_NREDUZ),40)
ElseIf _cTp = "PIS"
	_cHistor:= LEFT("PIS S/VENDA CONF. NF "+SD2->D2_DOC+" - "+ALLTRIM(SA1->A1_NREDUZ),40)
Endif
*/
RestArea(_aAliSA1)
RestArea(_aAliSA2)
RestArea(_aAliSZI)
RestArea(_aAliOri)

Return(_cHistor)


User Function LPFATV01(_cTp)

_aAliOri  := GetArea()
_aAliSF4  := SF4->(GetArea())
_aAliSZI  := SZI->(GetArea())

_nValor   := _NVALMER := 0
_NVALICM  := SD2->D2_VALICM  // ICMS
_NVALCOF  := SD2->D2_VALIMP5 // COFINS
_NVALPIS  := SD2->D2_VALIMP6 // PIS
_NVALIPI  := SD2->D2_VALIPI  // IPI
If SD2->D2_TIPO != "I"
	_NVALMER  := SD2->D2_TOTAL + SD2->D2_VALIPI + SD2->D2_VALFRE // MERCADORIA + IPI + FRETE
Endif	

If _cTp ==  "MER"
	_nValor := _NVALMER
ElseIf  _cTp ==  "ICM"
	_nValor := _NVALICM
ElseIf 	_cTp ==  "COF"
	_nValor := _NVALCOF
ElseIf 	_cTp ==  "PIS"
	_nValor := _NVALPIS
ElseIf 	_cTp ==  "IPI"
	_nValor := _NVALIPI
ElseIf 	_cTp ==  "FRE"
	_nValor := _NVALFRE
ElseIf 	_cTp ==  "ZFM"
	_nValor := _NVALZFM
ElseIf 	_cTp ==  "DES"
	_nValor := _NVALDES
Endif

RestArea(_aAliSZI)
RestArea(_aAliSF4)
RestArea(_aAliOri)

Return(_nValor)