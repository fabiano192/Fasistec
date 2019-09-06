User Function LPFIND01()

_aAliOri := GetArea()
_aAliSA2 := SA2->(GetArea())

_cConta  := SED->ED_CONTA

If Substr(STRLCTPAD,11,3)  != "VCP"
	SA2->(dbSetOrder(1))
	If SA2->(dbSeek(xFilial("SA2")+Substr(STRLCTPAD,14,8)))
		_cConta := SA2->A2_CONTA
	Endif
Endif


RestArea(_aAliOri)
RestArea(_aAliSA2)


Return(_cConta)


User Function LPFINV01()


If Alltrim(SE2->E2_NATUREZ) $ "213010002/213010003/213010004/213010005" .Or. SE2->E2_TIPO == "ADI" .Or. Alltrim(SE2->E2_ORIGEM ) = "GPEM670"
	_nValor := 0
Else
	_nValor := SE2->E2_VALOR+SE2->E2_IRRF+SE2->E2_PIS+SE2->E2_COFINS+SE2->E2_CSLL
Endif

Return(_nValor)


User Function LPFINV02()

If Alltrim(SE2->E2_NATUREZ) $ "213010002/213010003/213010004/213010005" .Or. SE2->E2_TIPO == "ADI".Or. Alltrim(SE2->E2_ORIGEM ) = "GPEM670"
	_nValor := 0
Else
	_nValor := SE2->E2_VALOR-SE2->E2_DECRESC
Endif

Return(_nValor)


User Function LPFIND02()

_aAliOri := GetArea()

IF SE2->E2_TIPO=="NCF"
	_cConta := "215010006"
ElseIf SE5->E5_MOTBX= "VCA"
	_cConta := "511240001"      
ElseIf Alltrim(SE2->E2_TIPO) == "PA"
	_cConta := SA6->A6_CONTA
Else
	_cConta := SA2->A2_CONTA
Endif	

RestArea(_aAliOri)


Return(_cConta)


User Function  LPFINC02()

_aAliOri := GetArea()

IF SE5->E5_MOTBX == "VCA"
	_cConta := "113010002"
ElseIf Alltrim(SE2->E2_TIPO) == "PA"
	_cConta := SED->ED_CONTA
Else	
	_cConta := SA6->A6_CONTA
Endif

Return(_cConta)	