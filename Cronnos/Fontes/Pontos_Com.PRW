#Include 'Totvs.ch'

/*
Autor		:	Fabiano da Silva
Data		:	05/08/13
Descrição	:	Pontos de Entrada do módulo Compras (SIGACOM)

MT100TOK()	:	Esse Ponto de Entrada é chamado 2 vezes dentro da rotina A103Tudok().
Para o controle do número de vezes em que ele é chamado foi criada a variável lógica lMT100TOK,
que quando for definida como (.F.) o ponto de entrada será chamado somente uma vez.
*/

User Function MT100TOK()

	_aAliOri  := GetArea()
	_aAliSD1  := SD1->(GetArea())
	_aAliSB1  := SB1->(GetArea())

	lMT100TOK := .F.
	_lRet      := .T.

	If UPPER(FunName()) == "MATA103"

		If cTipo = 'N'
			SA2->(dbsetorder(1))
			If SA2->(msSeek(xFilial('SA2')+CA100FOR))

				If SA2->A2_HOMOLOG = '1' .And. (SA2->A2_DTVALHO < dDataBase .Or. SA2->A2_PONENOK = '2')
					_lRet := .F.
					MSGiNFO("Fornecedor não Homologado!")
					RestArea(_aAliSB1)
					RestArea(_aAliSD1)
					RestArea(_aAliOri)
					Return(_lRet)
				Endif
			Endif

		Endif

		_nPoProd  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "D1_COD" } )

		For I:= 1 to Len(Acols)
			_cFim := (Len(aHeader)+1)

			_cProduto := ACols[I][_nPoProd]

			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(xFilial("SB1")+_cProduto))
				If RTrim(SB1->B1_TIPO) <> 'SE'
					If Empty(SB1->B1_POSIPI)
						Alert("Produto "+Alltrim(SB1->B1_COD)+" está sem o NCM no cadastro de Produtos!")
						_lRet := .F.
					Else
						SYD->(dbSetOrder(1))
						If !SYD->(dbSeek(xFilial("SYD")+SB1->B1_POSIPI))
							Alert("Produto "+Alltrim(SB1->B1_COD)+" está com o NCM cadastrado erroneamente!")
							_lRet := .F.
						Endif
					Endif
				Endif
			Endif
		Next I

	Endif

	RestArea(_aAliSB1)
	RestArea(_aAliSD1)
	RestArea(_aAliOri)

Return(_lRet)



/*
Autor		:	Fabiano da Silva
Data		:	15/06/15
Descrição	:	Pontos de Entrada do módulo Compras (SIGACOM)
SF1100I()	:	Após a gravação da Nf de Entrada
*/
User Function SF1100I()

	If SF1->F1_TIPO $ "B/N"
		U_CR0073()
	Endif

Return


User Function MT103MNT()

	Local _aHeadSEV := PARAMIXB[1]
	Local _aColsSEV := PARAMIXB[2]

	Local _aAliOri := GetArea()
	Local _aAliSF4 := SF4->(GetArea())

	_nPNatur  := aScan(_aHeadSEV,{ |x| Upper(Alltrim(x[2])) == "EV_NATUREZ"	} )
	_nPPerc   := aScan(_aHeadSEV,{ |x| Upper(Alltrim(x[2])) == "EV_PERC"	} )
	_nPData   := aScan(_aHeadSEV,{ |x| Upper(Alltrim(x[2])) == "EV_XDATA"	} )

	_nPTES    := aScan(aHeader	,{ |x| Upper(Alltrim(x[2])) == "D1_TES"		} )
	_nPProd   := aScan(aHeader	,{ |x| Upper(Alltrim(x[2])) == "D1_COD"		} )

	_nValor := 0
	_aItem  := {{'',0,0}}
	For A := 1 To Len(aCols)
		If !aCols[A][len(aHeader)+1] //Não está deletado.

			dbSelectArea("SB1")
			SB1->(dbsetOrder(1))
			SB1->(msSeek(xFilial("SB1")+aCols[A][_nPProd]))

			SF4->(dbSetOrder(1))
			SF4->(msSeek(xFilial("SF4")+aCols[A][_nPTES]))

			If SF4->F4_DUPLIC = 'S'

				_nValor += aCols[A][_nPTotal]

				_nPos := aScan(_aItem,{|x| x[1] = aCols[A][_nPCusto]})

				If _nPos > 0
					_aItem[_nPos][2] += aCols[A][_nPTotal]
				Else
					If !Empty(_aItem[1][1])
						AADD(_aItem,{aCols[A][_nPCusto],aCols[A][_nPTotal],0})
					Else
						_aItem[1][1] := aCols[A][_nPCusto]
						_aItem[1][2] := aCols[A][_nPTotal]
						_aItem[1][3] := 0
					Endif
				Endif
			Endif
		Endif

	Next A

	For B:= 1 To Len(_aItem) //Calculo de percentual
		_aItem[B][3] := _aItem[B][2] / _nValor * 100
	Next B

	_aColsSEV := {}
	For F:= 1 To Len(_aItem)
		AADD(_aColsSEV,Array(Len(_aHeadSEV)+1))

		_aColsSEV[Len(_aColsSEV)][len(_aHeadSEV)+1]	:= .F.
		_aColsSEV[Len(_aColsSEV)][_nPNatur]			:= _aItem[F][1]
		_aColsSEV[Len(_aColsSEV)][_nPPerc]			:= _aItem[F][3]
		_aColsSEV[Len(_aColsSEV)][_nPData]			:= dDataBase
	Next F

	RestArea(_aAliSF4)
	RestArea(_aAliOri)

Return _aColsSEV



User Function MT120LOK()

	Local _lRet := .T.
	Local _aAliOri := GetArea()
	Local _aAliSC7 := SC7->(GetArea())
	Local _nPProd  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C7_PRODUTO" } )

	SB1->(dbSetOrder(1))
	SB1->(msSeek(xFilial('SB1')+aCols[n][_nPProd]))

	If Empty(SB1->B1_XNATURE)
		Alert("Não está cadastrado Natureza para o Produto "+Alltrim(SB1->B1_COD))
		_lRet := .F.
	Else
		SED->(dbSetOrder(1))
		If SED->(msSeek(xFilial("SED")+SB1->B1_XNATURE))
			If SED->ED_MSBLQL = '1'
				Alert("Natureza vinculada no Produto "+Alltrim(SB1->B1_COD)+" está bloqueada!")
				_lRet := .F.
			Endif
		Else
			Alert("Natureza vinculada no Produto "+Alltrim(SB1->B1_COD)+" não está no cadastro de Naturezas!")
			_lRet := .F.
		Endif
	Endif

	RestArea(_aAliSC7)
	RestArea(_aAliOri)

Return(_lRet)

