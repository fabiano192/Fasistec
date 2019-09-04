#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LPFIN ³ Autor ³ Alexandro da Silva       ³ Data ³ 29/03/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada no Financeiro                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LPFIN01(_cLanc)

	Local _aAliOri    := GetArea()
	Local _aAliSE5    := SE5->(GetArea())

	Local _cBanco     := SE5->E5_BANCO
	Local _cAgencia   := SE5->E5_AGENCIA
	Local _cConta     := SE5->E5_CONTA
	Local _cNumCheq   := SE5->E5_NUMCHEQ
	Local _cTpDoc     := "CH"
	Local _nValor     := 0
	Local _cChav      := _cBanco + _cAgencia + _cConta + _cNumCheq
	Local _lConc      := .F.

	If SE5->E5_TIPODOC = "MT"
		_Aqui := .t.
	Endif

	If _cLanc == "530007"
		_cQ := " SELECT E5_RECONC FROM "+RetSqlName("SE5")+" A WHERE A.D_E_L_E_T_ = '' "
		_cQ += " AND E5_BANCO = '"+_cBanco+"' AND E5_AGENCIA = '"+_cAgencia+"' AND E5_CONTA = '"+_cConta+"' AND E5_NUMCHEQ = '"+_cNumCheq+"' "
		_cQ += " AND E5_TIPODOC = 'CH' "

		TCQUERY _cQ NEW ALIAS "ZZ"

		ZZ->(dbGotop())

		While ZZ->(!Eof())

			If ZZ->E5_RECONC = 'x'
				_lConc := .T.
			Endif

			ZZ->(dbSkip())
		EndDo

		ZZ->(dbCloseArea())

		If _lConc
			_nValor := SE5->E5_VALOR+SE5->E5_VLDESCO-SE5->E5_VLJUROS-SE5->E5_VLMULTA
		Endif
	ElseIf _cLanc == "530008"
		/*
		_cQ := " SELECT E5_RECONC FROM "+RetSqlName("SE5")+" A WHERE A.D_E_L_E_T_ = '' "
		_cQ += " AND E5_BANCO = '"+_cBanco+"' AND E5_AGENCIA = '"+_cAgencia+"' AND E5_CONTA = '"+_cConta+"' AND E5_NUMCHEQ = '"+_cNumCheq+"' "
		_cQ += " AND E5_TIPODOC = 'CH' "

		TCQUERY _cQ NEW ALIAS "ZZ"

		If ZZ->E5_RECONC = 'x'
		_lConc := .T.
		Endif

		ZZ->(dbCloseArea())

		If _lConc
		dbSelectArea("SE5")
		dbOrderNickName("INDSE51")
		If dbSeek(xFilial("SE5")+ _cBanco + _cAgencia + _cConta + _cNumCheq )

		While SE5->(!Eof()) .And. _cChav == SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA + SE5->E5_NUMCHEQ

		_nValor+= SE5->E5_VALOR-SE5->E5_VLJUROS-SE5->E5_VLMULTA+SE5->E5_VLDESCO

		SE5->(RecLock("SE5",.F.))
		SE5->E5_LA := Substr(SE5->E5_LA,1,1)+"S"
		SE5->(MsUnlock())

		SE5->(dbSkip())
		EndDo
		Endif
		Endif
		*/
		_cQ := " SELECT E5_RECONC FROM "+RetSqlName("SE5")+" A WHERE A.D_E_L_E_T_ = '' "
		_cQ += " AND E5_BANCO = '"+_cBanco+"' AND E5_AGENCIA = '"+_cAgencia+"' AND E5_CONTA = '"+_cConta+"' AND E5_NUMCHEQ = '"+_cNumCheq+"' "
		_cQ += " AND E5_TIPODOC = 'CH' "

		TCQUERY _cQ NEW ALIAS "ZZ"

		ZZ->(dbGotop())

		While ZZ->(!Eof())

			If ZZ->E5_RECONC = 'x'
				_lConc := .T.
			Endif

			ZZ->(dbSkip())
		EndDo

		ZZ->(dbCloseArea())

		If _lConc
			_nValor := SE5->E5_VALOR
		Endif


	ElseIf _cLanc == "530009"
		_cQ := " SELECT E5_RECONC FROM "+RetSqlName("SE5")+" A WHERE A.D_E_L_E_T_ = '' "
		_cQ += " AND E5_BANCO = '"+_cBanco+"' AND E5_AGENCIA = '"+_cAgencia+"' AND E5_CONTA = '"+_cConta+"' AND E5_NUMCHEQ = '"+_cNumCheq+"' "
		_cQ += " AND E5_TIPODOC = 'CH' "

		TCQUERY _cQ NEW ALIAS "ZZ"

		ZZ->(dbGotop())

		While ZZ->(!Eof())

			If ZZ->E5_RECONC = 'x'
				_lConc := .T.
			Endif

			ZZ->(dbSkip())
		EndDo

		ZZ->(dbCloseArea())

		If _lConc
			_nValor := SE5->E5_VLJUROS+SE5->E5_VLMULTA
		Endif
	ElseIf _cLanc == "530010"
		_cQ := " SELECT E5_RECONC FROM "+RetSqlName("SE5")+" A WHERE A.D_E_L_E_T_ = '' "
		_cQ += " AND E5_BANCO = '"+_cBanco+"' AND E5_AGENCIA = '"+_cAgencia+"' AND E5_CONTA = '"+_cConta+"' AND E5_NUMCHEQ = '"+_cNumCheq+"' "
		_cQ += " AND E5_TIPODOC = 'CH' "

		TCQUERY _cQ NEW ALIAS "ZZ"

		ZZ->(dbGotop())

		While ZZ->(!Eof())

			If ZZ->E5_RECONC = 'x'
				_lConc := .T.
			Endif

			ZZ->(dbSkip())
		EndDo

		ZZ->(dbCloseArea())

		If _lConc
			_nValor := SE5->E5_VLDESCO
		Endif
	Endif

	RestArea(_aAliSE5)
	RestArea(_aAliOri)

Return(_nValor)

User Function LPFIN02()

	_aAliOri:= GetArea()
	_aAlise5:= SE5->(GetArea())

	_cConta   := "11230001"

	_cPrefixo := Substr(SE5->E5_DOCUMEN,1,3)
	_cNumero  := Substr(SE5->E5_DOCUMEN,4,9)
	_cParcela := Substr(SE5->E5_DOCUMEN,13,1)
	_cTipo    := Substr(SE5->E5_DOCUMEN,14,3)
	_cFornece := Substr(SE5->E5_DOCUMEN,17,6)
	_cLoja    := Substr(SE5->E5_DOCUMEN,23,2)

	SE5->(dbSetOrder(7))
	If SE5->(dbSeek(xFilial("SE5")+_cPrefixo + _cNumero + _cParcela + _cTipo + _cFornece + _cLoja + SE5->E5_SEQ))
		If Left(SE5->E5_NATUREZ,2) == "N9"
			_cConta := "11230007"
		Endif
	Endif

	RestArea(_aAliSE5)
	RestArea(_aAliORI)

Return(_cConta)

User Function LPFIND01(RECPAG,DC)

	_aAliOri := GetArea()
	_aAliSE5 := SE5->(GetArea())

	_cConta  := Space(20)

	If RECPAG == "R"
		If DC == "D"
			If Alltrim(SE5->E5_TIPO) $ "NF/DP/FT"
				_cConta := "33410003"  // JUROS PAGOS
			Else
				_cConta := SA1->A1_CONTA
			Endif
		ElseIf DC == "C"
			If Alltrim(SE5->E5_TIPO) $ "NF/DP/FT"
				_cConta := SA1->A1_CONTA  // CLIENTES
			Else
				If SE5->E5_TIPO $ "RA"
					_cConta := "21130001"  // ADIANTAMENTO DE CLIENTES
				Else
					_cConta := "33410004"  // DESCONTO CONCEDIDO
				Endif
			Endif
		Endif
	ElseIf RECPAG == "P"
		If DC == "D"
			If Alltrim(SE5->E5_TIPO) $ "NF/DP/FT"
				_cConta := "33420001"   // DESCONTO OBTIDO
			Else
				If SE5->E5_TIPO $ "PA"
					_cConta := "11230001"  // ADIANTAMENTO DE FORNECEDORES
				Else
					_cConta := SA2->A2_CONTA // FORNECEDORES OU NATUREZA
				Endif
			Endif
		ElseIf DC == "C"
			If Alltrim(SE5->E5_TIPO) $ "NF/DP/FT"
				_cConta := SA2->A2_CONTA
			Else
				_cConta := "33420001"  // DESCONTO OBTIDOS
			Endif
		Endif
	Endif

	RestArea(_aAliSE5)
	RestArea(_aAliOri)

Return(_cConta)


//	Marcus Vinicius - 20/09/2016
//	Utilizado no LP 572001 para utilizar a conta crédito conforme cadastro do caixinha na tabela SET.
User Function LPFIN03(cCodCaixa,cTipo)

	Local cRet := Space(8)

	If cTipo == "02"
		cRet := "11230003"
	Else
		SET->(DbSetOrder(1))
		IF SET->(DbSeek(XFilial("SET")+cCodCaixa))
			cRet := SET->ET_CONTA
		EndIf
	EndIf

Return cRet

User Function LPFIN04(cPrefixo,cFatura)

	_aAliOri:= GetArea()
	_aAliSe2:= SE2->(GetArea())

	SE2->(dbSetOrder(1))
	If SE2->(dbSeek(xFilial("SE2")+cPrefixo+cFatura))
		cClVlr := SE2->E2_FORNECE+SE2->E2_LOJA
	Endif

	RestArea(_aAliSe2)
	RestArea(_aAliORI)

Return(cClVlr)