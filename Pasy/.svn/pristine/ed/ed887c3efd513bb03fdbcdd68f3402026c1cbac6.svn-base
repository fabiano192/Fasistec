User Function LPCOMD01(_cTp)

_aAliOri := GetArea()
_aAliSA1 := SA1->(GetArea())
_aAliSA2 := SA2->(GetArea())
_aAliSB1 := SB1->(GetArea())
_aAliSZI := SZI->(GetArea())

_CCTAICM := _CCTAIPI := _CCTAPIS := _CCTACOF := _CCTAMER := _cConta := ""

SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))

If !SD1->D1_TIPO $ "D/B"
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA))
Else
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA))
Endif

SZI->(dbSetOrder(1))
If SZI->(dbSeek(xFilial("SZI")+SD1->D1_CF + _cTp))
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


User Function LPCOMC01(_cTp)

_aAliOri := GetArea()
_aAliSA1 := SA1->(GetArea())
_aAliSB1 := SB1->(GetArea())
_aAliSZI := SZI->(GetArea())

_CCTAICM := _CCTAIPI := _CCTAPIS := _CCTACOF := _CCTAMER := _cConta := ""

SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))

If !SD1->D1_TIPO $ "D/B"
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA))
Else
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA))
Endif

SZI->(dbSetOrder(1))
If SZI->(dbSeek(xFilial("SZI")+SD1->D1_CF + _cTp))
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


User Function LPCOMH01(_cTp)

_aAliOri := GetArea()
_aAliSA1 := SA1->(GetArea())
_aAliSA2 := SA2->(GetArea())
_aAliSZI := SZI->(GetArea())
_cHistor := _cNReduz := ""

_cTp := Substr(Alltrim(_cTp)+Space(10),1,6)

If !SD1->D1_TIPO $ "B/D"
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA))
	_cNReduz := SA2->A2_NREDUZ
Else
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA))
	_cNReduz := SA1->A1_NREDUZ
Endif

SZI->(dbSetOrder(1))
If SZI->(dbSeek(xFilial("SZI")+SD1->D1_CF + _cTp))
	_cHistor := LEFT(ALLTRIM(SZI->ZI_HIST)+" "+ALLTRIM(SD1->D1_DOC)+" - "+ALLTRIM(_cNReduz),40)
Endif

RestArea(_aAliSA1)
RestArea(_aAliSA2)
RestArea(_aAliSZI)
RestArea(_aAliOri)

Return(_cHistor)


User Function LPCOMV01(_cTp)

_aAliOri  := GetArea()
_aAliSZI := SZI->(GetArea())

_nValor   := 0
_NVALICM  := SD1->D1_VALICM  // ICMS
_NVALCOF  := SD1->D1_VALIMP5 // COFINS
_NVALPIS  := SD1->D1_VALIMP6 // PIS
_NVALIPI  := SD1->D1_VALIPI  // IPI
If SD1->D1_TIPO != "I" // Complemento de ICMS
	_NVALMER  := SD1->D1_TOTAL + SD1->D1_VALIPI + SD1->D1_VALFRE // MERCADORIA + IPI + FRETE
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
Endif

RestArea(_aAliSZI)
RestArea(_aAliOri)

Return(_nValor)