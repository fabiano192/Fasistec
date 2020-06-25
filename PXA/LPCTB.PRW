
#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Rotina   ³LPCTB                                    ³ Data ³ 22/04/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gatilhos do Modulo Gerencial                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Módulo   ³ SIGACFG                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LPGER01(_cCampo,_cCampo2)

_aAliOri := GetArea()
_aAliCT1 := CT1->(GetArea())
_aAliSZ2 := SZ2->(GetArea())

_cTipo  := Space(03)
_cConta := Space(20)

_cCampo2 := If(Valtype(_cCampo2) <> 'C',"",_cCampo2)

_cCpo   := &_cCampo

If cEmpAnt == "06"
	_cFil := "085"
Else
	_cFil := Left(cFilAnt,3)
Endif

If Empty(_cCampo2)
	If Left(_cCAmpo,3) $ "SA1/SA2"
		If Left(_cCAmpo,3) == "SA1"
			_cTipo := "001"
		ElseIf Left(_cCAmpo,3) == "SA2"
			_cTipo := "002"
		Endif
		
		SZ2->(dbSetOrder(1))
		If SZ2->(dbSeek(xFilial("SZ2")+ _cTipo + cEmpAnt + _cFil))
			_cConta := SZ2->Z2_CONTA
		Endif
	ElseIf Left(_cCAmpo,3) $ "SED/SE2"
		
		SZ1->(dbSetOrder(2))
		If SZ1->(dbSeek(xFilial("SZ1")+ _cCpo + cEmpAnt + _cFil))
			_cConta := SZ1->Z1_CONTA
		Endif
	Else
		//SZ2->(dbSetOrder(1))
		//If SZ2->(dbSeek(xFilial("SZ2")+_cCampo))
		//	_cConta := SZ2->Z2_CONTA
		//Endif
		SZ2->(dbSetOrder(1))
		If SZ2->(dbSeek(xFilial("SZ2")+ _cCampo + cEmpAnt + _cFil))
			_cConta := SZ2->Z2_CONTA
		Endif
		
	Endif
Else
	_cCpo   := &_cCampo2
	If Left(_cCAmpo2,3) $ "SED/SE2"
		SZ1->(dbSetOrder(2))
		If SZ1->(dbSeek(xFilial("SZ1")+ _cCpo + cEmpAnt + _cFil))
			_cConta := SZ1->Z1_JUROPAG
		Endif
	Endif
	
	If Empty(_cConta)
		SZ2->(dbSetOrder(1))
		If SZ2->(dbSeek(xFilial("SZ2")+ _cCampo + cEmpAnt + _cFil))
			_cConta := SZ2->Z2_CONTA
		Endif
	Endif
Endif

RestArea(_aAliCT1)
RestArea(_aAliSZ2)
RestArea(_aAliOri)

Return(_cConta)


User Function LPGER02(_cTes,_CDC,_cTipo)

_aAliOri := GetArea()
_aAliSB1 := SB1->(GetArea())
_aAliSBZ := SBZ->(GetArea())
_aAliSZ2 := SZ2->(GetArea())
_aAliSZ3 := SZ3->(GetArea())
_aAliSZ4 := SZ4->(GetArea())
_cConta  := Space(20)

If Alltrim(FunName()) $ "PXH015"
	_cTes := _CTESLP
Endif

_cGrEmp   := cEmpAnt
If cEmpAnt == "06"
	_cEmpresa := "092"
Else
	_cEmpresa := Left(cFilAnt,3)
Endif

SZ4->(dbSetOrder(1))
If SZ4->(dbSeek(xFilial("SZ4") + _cTes + _cTipo ))
	If _cDC == "D"
		If LEFT(SZ4->Z4_CTADEB,3) == "010"			
			SBZ->(dbSetorder(1))
			If SBZ->(dbSeek(xFilial("SBZ")+ SB1->B1_COD))
				_cConta := SBZ->BZ_YCONTA
			Endif
		ElseIf LEFT(SZ4->Z4_CTADEB,3) == "018"
			_cConta := SD1->D1_CONTA
		Else
			SZ2->(dbSetOrder(2))
			If SZ2->(dbSeek(xFilial("SZ2") + _cGrEmp + _cEmpresa + LEFT(SZ4->Z4_CTADEB,3)))
				_cConta := SZ2->Z2_CONTA
			Endif
		Endif
	Else
		If LEFT(SZ4->Z4_CTACRD,3) == "010"
			SBZ->(dbSetOrder(1))
			If SBZ->(dbSeek(xFilial("SBZ")+ SB1->B1_COD))
				_cConta := SBZ->BZ_YCONTA
			Endif
		ElseIf LEFT(SZ4->Z4_CTACRD,3) == "018"
			_cConta := SD1->D1_CONTA
		Else
			SZ2->(dbSetOrder(2))
			If SZ2->(dbSeek(xFilial("SZ2") + _cGrEmp + _cEmpresa + LEFT(SZ4->Z4_CTACRD,3)))
				_cConta := SZ2->Z2_CONTA
			Endif
		Endif
	Endif
Endif

RestArea(_aAliSB1)
RestArea(_aAliSBZ)
RestArea(_aAliSZ2)
RestArea(_aAliSZ3)
RestArea(_aAliSZ4)
RestArea(_aAliORI)

Return(_cConta)


User Function LPGER03(_cTes,_cDC,_cTipo,_cTpVal)

_aAliOri := GetArea()
_aAliSZ4 := SZ4->(GetArea())
_aAliCTT := CTT->(GetArea())
_nValor  := 0
_lCont   := .T.

If _cTes < "500"
	CTT->(dbSetOrder(1))
	If CTT->(dbseek(xFilial("CTT")+SD1->D1_CC))
		If CTT->CTT_XCONT == "2"
			_lCont  := .F.
		Endif
	Endif
Else
Endif

SZ4->(dbSetOrder(1))
If SZ4->(dbSeek(xFilial("SZ4") + _cTes + _cTipo ))
	If _cDc == "D"
		If _cTes < "500"
			If Left(SZ4->Z4_VALDEB,3)     == "001" // MERCADORIA
				_nValor := SD1->D1_TOTAL
			ElseIf Left(SZ4->Z4_VALDEB,3) == "002" // RECEITA
				_nValor := SD1->D1_TOTAL + SD1->D1_SEGURO + SD1->D1_VALIPI + SD1->D1_VALFRE + SD1->D1_DESPESA + SD1->D1_ICMSRET - SD1->D1_VALDESC
			ElseIf Left(SZ4->Z4_VALDEB,3) == "003" // VALOR ICMS
				_nValor := SD1->D1_VALICM
			ElseIf Left(SZ4->Z4_VALDEB,3) == "004" // VALOR IPI
				_nValor := SD1->D1_VALIPI
			ElseIf Left(SZ4->Z4_VALDEB,3) == "005" // VALOR FRETE
				_nValor := SD1->D1_VALFRE
			ElseIf Left(SZ4->Z4_VALDEB,3) == "006" // VALOR DESPESA
				_nValor := SD1->D1_DESPESA
			ElseIf Left(SZ4->Z4_VALDEB,3) == "007" // ICMS RETIDO
				_nValor := SD1->D1_ICMSRET
			ElseIf Left(SZ4->Z4_VALDEB,3) == "008" // PIS APURACAO
				_nValor := SD1->D1_VALIMP6
			ElseIf Left(SZ4->Z4_VALDEB,3) == "009" // COFINS APURACAO
				_nValor := SD1->D1_VALIMP5
			ElseIf Left(SZ4->Z4_VALDEB,3) == "010" // PIS RETIDO
				_nValor := SD1->D1_VALPIS
			ElseIf Left(SZ4->Z4_VALDEB,3) == "011" // COFINS RETIDO
				_nValor := SD1->D1_VALCOF
			ElseIf Left(SZ4->Z4_VALDEB,3) == "012" // CSLL   RETIDO
				_nValor := SD1->D1_VALCSLL
			ElseIf Left(SZ4->Z4_VALDEB,3) == "013" // VALOR INSS
				_nValor := SD1->D1_VALINS
			ElseIf Left(SZ4->Z4_VALDEB,3) == "014" // VALOR ISS
				_nValor := SD1->D1_VALISS
			ElseIf Left(SZ4->Z4_VALDEB,3) == "015" // TOTAL RECEITA
				_nValor := SD1->D1_TOTAL + SD1->D1_VALICM + SD1->D1_VALIPI + SD1->D1_VALIMP5 + SD1->D1_VALIMP6 + SD1->D1_VALFRE + SD1->D1_DESPESA + SD1->D1_SEGURO
			ElseIf Left(SZ4->Z4_VALDEB,3) == "016" // MERCADORIA MENOS RETIDOS
				_nValor := SD1->D1_TOTAL + SF1->F1_VALCOFI - SF1->F1_VALPIS - SF1->F1_VALCSLL
			Endif
		ElseIf _cTes >= "500"
			If Left(SZ4->Z4_VALDEB,3)     == "001" // MERCADORIA
				_nValor := SD2->D2_TOTAL + SD2->D2_VALFRE
			ElseIf Left(SZ4->Z4_VALDEB,3) == "002" // RECEITA TOTAL
				_nValor := SD2->D2_TOTAL + SD2->D2_VALIPI + SD2->D2_VALFRE + SD2->D2_DESPESA + SD2->D2_ICMSRET - SD2->D2_DESC
			ElseIf Left(SZ4->Z4_VALDEB,3) == "003" // VALOR ICMS
				_nValor := SD2->D2_VALICM
			ElseIf Left(SZ4->Z4_VALDEB,3) == "004" // VALOR IPI
				_nValor := SD2->D2_VALIPI
			ElseIf Left(SZ4->Z4_VALDEB,3) == "005" // VALOR FRETE
				_nValor := SD2->D2_VALFRE
			ElseIf Left(SZ4->Z4_VALDEB,3) == "006" // VALOR DESPESA
				_nValor := SD2->D2_DESPESA
			ElseIf Left(SZ4->Z4_VALDEB,3) == "007" // ICMS RETIDO
				_nValor := SD2->D2_ICMSRET
			ElseIf Left(SZ4->Z4_VALDEB,3) == "008" // PIS APURACAO
				//_nValor := SD2->D2_VALIMP5
				_nValor := SD2->D2_VALIMP6
			ElseIf Left(SZ4->Z4_VALDEB,3) == "009" // COFINS APURACAO
				//_nValor := SD2->D2_VALIMP6
				_nValor := SD2->D2_VALIMP5
			ElseIf Left(SZ4->Z4_VALDEB,3) == "010" // PIS RETIDO
				_nValor := SD2->D2_VALPIS
			ElseIf Left(SZ4->Z4_VALDEB,3) == "011" // COFINS RETIDO
				_nValor := SD2->D2_VALCOF
			ElseIf Left(SZ4->Z4_VALDEB,3) == "012" // CSLL   RETIDO
				_nValor := SD2->D2_VALCSLL
			ElseIf Left(SZ4->Z4_VALDEB,3) == "013" // VALOR INSS
				_nValor := SD2->D2_VALINS
			ElseIf Left(SZ4->Z4_VALDEB,3) == "014" // VALOR ISS
				_nValor := SD2->D2_VALISS
			ElseIf Left(SZ4->Z4_VALDEB,3) == "015" // TOTAL RECEITA
				_nValor := SD2->D2_TOTAL + SD2->D2_VALICM + SD2->D2_VALIPI + SD2->D2_VALIMP5 + SD2->D2_VALIMP6 + SD2->D2_VALFRE + SD2->D2_DESPESA
			Endif
		Endif
	ElseIf _cDc == "C"
		If _cTes < "500"
			If Left(SZ4->Z4_VALCRD,3)     == "001" // MERCADORIA
				_nValor := SD1->D1_TOTAL
			ElseIf Left(SZ4->Z4_VALCRD,3) == "002" // RECEITA TOTAL
				_nValor := SD1->D1_TOTAL + SD1->D1_VALIPI + SD1->D1_VALFRE + SD1->D1_DESPESA + SD1->D1_ICMSRET - SD1->D1_VALDESC + SD1->D1_SEGURO
			ElseIf Left(SZ4->Z4_VALCRD,3) == "003" // VALOR ICMS
				_nValor := SD1->D1_VALICM
			ElseIf Left(SZ4->Z4_VALCRD,3) == "004" // VALOR IPI
				_nValor := SD1->D1_VALIPI
			ElseIf Left(SZ4->Z4_VALCRD,3) == "005" // VALOR FRETE
				_nValor := SD1->D1_VALFRE
			ElseIf Left(SZ4->Z4_VALCRD,3) == "006" // VALOR DESPESA
				_nValor := SD1->D1_DESPESA
			ElseIf Left(SZ4->Z4_VALCRD,3) == "007" // ICMS RETIDO
				_nValor := SD1->D1_ICMSRET
			ElseIf Left(SZ4->Z4_VALCRD,3) == "008" // PIS APURACAO
				_nValor := SD1->D1_VALIMP6
			ElseIf Left(SZ4->Z4_VALCRD,3) == "009" // COFINS APURACAO
				_nValor := SD1->D1_VALIMP5
			ElseIf Left(SZ4->Z4_VALCRD,3) == "010" // PIS RETIDO
				_nValor := SD1->D1_VALPIS
			ElseIf Left(SZ4->Z4_VALCRD,3) == "011" // COFINS RETIDO
				_nValor := SD1->D1_VALCOF
			ElseIf Left(SZ4->Z4_VALCRD,3) == "012" // CSLL   RETIDO
				_nValor := SD1->D1_VALCSLL
			ElseIf Left(SZ4->Z4_VALCRD,3) == "013" // VALOR INSS
				_nValor := SD1->D1_VALINS
			ElseIf Left(SZ4->Z4_VALCRD,3) == "014" // VALOR ISS
				_nValor := SD1->D1_VALISS
			ElseIf Left(SZ4->Z4_VALCRD,3) == "015" // RECEITA TOTAL
				_nValor := SD1->D1_TOTAL + SD1->D1_VALICM + SD1->D1_VALIPI + SD1->D1_VALIMP5 + SD1->D1_VALIMP6 + SD1->D1_VALFRE + SD1->D1_DESPESA + SD1->D1_SEGURO
			ElseIf Left(SZ4->Z4_VALCRD,3) == "016" // MERCADORIA MENOS RETIDOS
				_nValor := SD1->D1_TOTAL + SF1->F1_VALCOFI - SF1->F1_VALPIS - SF1->F1_VALCSLL
			Endif
		ElseIf _cTes >= "500"
			If Left(SZ4->Z4_VALDEB,3)     == "001" // MERCADORIA
				_nValor := SD2->D2_TOTAL
			ElseIf Left(SZ4->Z4_VALDEB,3) == "002" // RECEITA
				_nValor := SD2->D2_TOTAL + SD2->D2_VALIPI + SD2->D2_VALFRE + SD2->D2_DESPESA + SD2->D2_ICMSRET - SD2->D2_DESC
			ElseIf Left(SZ4->Z4_VALDEB,3) == "003" // VALOR ICMS
				_nValor := SD2->D2_VALICM
			ElseIf Left(SZ4->Z4_VALDEB,3) == "004" // VALOR IPI
				_nValor := SD2->D2_VALIPI
			ElseIf Left(SZ4->Z4_VALDEB,3) == "005" // VALOR FRETE
				_nValor := SD2->D2_VALFRE
			ElseIf Left(SZ4->Z4_VALDEB,3) == "006" // VALOR DESPESA
				_nValor := SD2->D2_DESPESA
			ElseIf Left(SZ4->Z4_VALDEB,3) == "007" // ICMS RETIDO
				_nValor := SD2->D2_ICMSRET
			ElseIf Left(SZ4->Z4_VALDEB,3) == "008" // PIS APURACAO
				//_nValor := SD2->D2_VALIMP5
				_nValor := SD2->D2_VALIMP6
			ElseIf Left(SZ4->Z4_VALDEB,3) == "009" // COFINS APURACAO
				//_nValor := SD2->D2_VALIMP6
				_nValor := SD2->D2_VALIMP5
			ElseIf Left(SZ4->Z4_VALDEB,3) == "010" // PIS RETIDO
				_nValor := SD2->D2_VALPIS
			ElseIf Left(SZ4->Z4_VALDEB,3) == "011" // COFINS RETIDO
				_nValor := SD2->D2_VALCOF
			ElseIf Left(SZ4->Z4_VALDEB,3) == "012" // CSLL   RETIDO
				_nValor := SD2->D2_VALCSLL
			ElseIf Left(SZ4->Z4_VALDEB,3) == "013" // VALOR INSS
				_nValor := SD2->D2_VALINS
			ElseIf Left(SZ4->Z4_VALDEB,3) == "014" // VALOR ISS
				_nValor := SD2->D2_VALISS
			ElseIf Left(SZ4->Z4_VALDEB,3) == "015" // TOTAL RECEITA
				_nValor := SD2->D2_TOTAL + SD2->D2_VALICM + SD2->D2_VALIPI + SD2->D2_VALIMP5 + SD2->D2_VALIMP6 + SD2->D2_VALFRE + SD2->D2_DESPESA
			Endif
		Endif
	Endif
Endif

RestArea(_aAliCTT)
RestArea(_aAliSZ4)
RestArea(_aAliOri)

If !_lCont
	_nValor := 0
Endif

Return(_nValor)


User Function LPGER04(_cTes,_cTipo)

_aAliOri := GetArea()
_aAliSZ4 := SZ4->(GetArea())
_cHist   := 0

SZ4->(dbSetOrder(1))
If SZ4->(dbSeek(xFilial("SZ4") + _cTes + _cTipo ))
	_cHist := &(SZ4->Z4_HIST)
Endif

RestArea(_aAliSZ4)
RestArea(_aAliOri)

Return(_cHist)


User Function LPGER05(_cTipo)

_aAliOri := GetArea()
_aAliSZ4 := SZ4->(GetArea())
_cHist   := 0

SZ4->(dbSetOrder(1))
If SZ4->(dbSeek(xFilial("SZ4") + _cTes + _cTipo ))
	_cHist := &(SZ4->Z4_HIST)
Endif

RestArea(_aAliSZ4)
RestArea(_aAliOri)

Return


User Function LPGER06(_cTes,_cDC,_cTipo,_cTpVal)

_aAliOri := GetArea()
_aAliSZ4 := SZ4->(GetArea())
_aAliCTT := CTT->(GetArea())
_nValor  := 0
_lCont   := .T.

SZ4->(dbSetOrder(1))
If SZ4->(dbSeek(xFilial("SZ4") + _cTes + _cTipo ))
	If _cTes < "500"
		If Left(SZ4->Z4_VALDEB,3)     == "001" // MERCADORIA
			_nValor := SD1->D1_QUANT
		Endif
	ElseIf _cTes >= "500"
		If Left(SZ4->Z4_VALDEB,3)     == "001" // MERCADORIA
			_nValor := SD2->D2_QUANT
		Endif
	Endif
Endif

RestArea(_aAliCTT)
RestArea(_aAliSZ4)
RestArea(_aAliOri)

Return(_nValor)