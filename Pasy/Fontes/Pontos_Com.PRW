#Include 'Totvs.ch'

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
	_nPTotal  := aScan(aHeader	,{ |x| Upper(Alltrim(x[2])) == "D1_TOTAL"	} )

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

				_nPos := aScan(_aItem,{|x| x[1] = SB1->B1_XNATURE})
				//				_nPos := aScan(_aItem,{|x| x[1] = aCols[A][_nPCusto]})

				If _nPos > 0
					_aItem[_nPos][2] += aCols[A][_nPTotal]
				Else
					If !Empty(_aItem[1][1])
						AADD(_aItem,{SB1->B1_XNATURE,aCols[A][_nPTotal],0})
					Else
						_aItem[1][1] := SB1->B1_XNATURE
						_aItem[1][2] := aCols[A][_nPTotal]
						_aItem[1][3] := 0
					Endif
				Endif
			Endif
		Endif

	Next A

	If _nValor > 0 .And. _nPNatur > 0
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
	Endif

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
