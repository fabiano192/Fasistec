#INCLUDE "rwmake.ch"

/*
Programa  	³ GAT001     
Autor 		³ Alexandro da Silva
Data 		³ 07/12/01  
Descricao 	³ Consistir a Data De Entrega
*/

User Function GAT001()

_cAliOri := Alias()
_nOrdOri := IndexOrd()
_nRecOri := Recno()


_nPosNum  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_NUM" } )
_nPosIt   := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_ITEM" } )
_nPosNumOp:= aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_NUMOP" } )
_nPosDtEnt:= aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_ENTREG" } )
_dDtEnt := Acols[n][_nPosDtEnt]


If !Empty(Acols[n][_nPosNumOp])
	dbSelectArea("SC6")
	_cAliSC6 := Alias()
	_nOrdSC6 := IndexOrd()
	_nRecSc6 := Recno()
	dbSetOrder(1)
	If dbseek(xFilial()+M->C5_NUM+Acols[n][_nPosIt])
		_dDtEnt := SC6->C6_ENTREG
	Endif
	
	dbSelectArea(_cAliSC6)
	dbSetOrder(_nOrdSC6)
	dbGoto(_nRecSC6)
	
	MsgBox("O.P Ja gerada, nao e possivel alterar a Dt de Entrega","INFORMACAO","ERRO")
Endif

dbSelectArea(_cAliOri)
dbSetOrder(_nOrdOri)
dbGoto(_nRecOri)


Return(_dDtEnt)



User Function GAT002()

_aAliOri  := GetArea()
_aAliSA1  := SA1->(GetArea())
_aAliSB1  := SB1->(GetArea())
_aAliSF4  := SF4->(GetArea())
_aAliSZ2  := SZ2->(GetArea())
_aAliSZ5  := SZ5->(GetArea())

_nPItem   := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_ITEM"    } )
_nProd    := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRODUTO" } )
_nProdC   := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_CPROCLI" } )
_nRevPed  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_REVPED"  } )
_nQtdVen  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_QTDVEN"  } )
_nPrcVen  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRCVEN"  } )
_nValor   := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_VALOR"   } )
_nEntreg  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_ENTREG"  } )
_nTES     := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_TES"     } )
_nUM      := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_UM"      } )
_nCF      := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_CF"      } )
_nSegUM   := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_SEGUM"   } )
_nLocal   := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_LOCAL"   } )
_nDescri  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_DESCRI"  } )
_nPrcUni  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRUNIT"  } )
_nClasFis := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_CLASFIS" } )
_nCodISS  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_CODISS"  } )
_nPedCli  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PEDCLI"  } )
_nCodCli  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_CPROCLI" } )

_nQuant   := ACols[N][_nQtdVen]
_nQuant2  := ACols[N][_nQtdVen]
_cProduto := ACols[N][_nProd]
_cProdCli := ACols[N][_nProdC]
_cCliente := M->C5_CLIENTE
_cLoja    := M->C5_LOJACLI

dbSelectArea("SZ5")
dbSetOrder(1)
If dbSeek(xFilial()+_cCliente+_cLoja+_cProduto+_cProdCli)
	
	_aLinha   := aClone(aCols[n])
	_lPass    := .F.
	_cCod     := SZ5->Z5_CODIGO	
	If Len(Acols) > 1
		For B:= 1 To Len(Acols)
			_cProd2    := ACols[B][_nProd]
			_cProdCli2 := ACols[B][_nProdC]
			dbSelectArea("SZ5")
			dbSetOrder(1)
			If dbSeek(xFilial()+_cCliente+_cLoja+_cProd2+_cProdCli2+_cCod)
				aCols[B,Len(aHeader)+1] := .T.
			Endif
		Next B
		AADD(aCols,aClone(_aLinha))
		N := Len(Acols)
		_lPass := .T.
	Endif
	
	_cCont := SZ5->Z5_CODIGO
	
	dbSelectArea("SZ5")
	dbSetOrder(2)
	If dbSeek(xFilial()+_cCont)
		
		_cCont := SZ5->Z5_CODIGO
		_nCli  := N
		
		While !Eof() .And. _cCont == SZ5->Z5_CODIGO
			
			//			If !_lPass
			If SZ5->Z5_PRODCLI == 	_cProdCli
				dbSelectArea("SZ5")
				dbSkip()
				Loop
			Endif
			//			Endif
			
			_aLinha    := aClone(aCols[n])
			AADD(aCols,aClone(_aLinha))
			N++
			
			If SZ5->Z5_TPCONV == "1" // Multiplicador
				//				_nQuant := Round( ( (_nQuant2 / SZ5->Z5_QTCAV) * SZ5->Z5_FATOR),0)
				_nQuant := Round( ( (_nQuant2 / SZ5->Z5_FATOR) * SZ5->Z5_QTCAV),0)
				If Int(_nQuant) < _nQuant
					_nQuant := Int(_nQuant)+1
				Else
					_nQuant := Int(_nQuant)
				Endif
			Else
				//				_nQuant := (_nQuant2 / SZ5->Z5_QTCAV) / SZ5->Z5_FATOR
				_nQuant := (_nQuant2 / SZ5->Z5_FATOR) / SZ5->Z5_QTCAV
				If Int(_nQuant) < _nQuant
					_nQuant := Int(_nQuant)+1
				Else
					_nQuant := Int(_nQuant)
				Endif
			Endif
			
			dbSelectArea("SZ2")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ2")+M->C5_CLIENTE+M->C5_LOJACLI + SZ5->Z5_PRODUTO + SZ5->Z5_PRODCLI+"1")
				
				Acols[N][_nPItem]  := StrZero(N,2)
				Acols[N][_nProd]   := SZ5->Z5_PRODUTO
				Acols[N][_nProdC]  := SZ5->Z5_PRODCLI
				aCols[n][_nRevPed] := SZ2->Z2_REVISAO
				aCols[n][_nQtdVen] := _nQuant
				aCols[n][_nTES]    := SZ2->Z2_TES
				
				dbSelectArea("SB1")
				dbSetOrder(1)
				If dbSeek(xFilial("SB1")+aCols[n][_nProd])
					aCols[n][_nUM] := SB1->B1_UM
				Endif
				
				If _nPrcVen > 0
					_dDataRef := SZ2->Z2_DTREF01
					_nVl      := SZ2->Z2_PRECO01
					For i := 2 to 12
						If  &("SZ2->Z2_DTREF"+StrZero(i,2)) >= _dDataRef
							_dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
							_nVl   := &("SZ2->Z2_PRECO"+StrZero(i,2))
						Endif
					Next i
					aCols[n][_nPrcVen]  := _nVl
				Endif
				
				aCols[n][_nValor]  := _nQuant * _nVl
				//				a410Produto(aCols[n][_nProd])
				
				dbSelectArea("SA1")
				dbSetOrder(1)
				dbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI)
				
				If _nCF > 0
					If _nTES > 0
						dbSelectArea("SF4")
						dbSetOrder(1)
						If dbSeek(xFilial("SF4")+aCols[n][_nTES])
							If SA1->A1_EST == GetMV("MV_ESTADO") .And. SA1->A1_TIPO # "X"
								aCols[n][_nCF] := "5" + SubStr(SF4->F4_CF, 2, 3)
							ElseIf SA1->A1_TIPO # "X"
								aCols[n][_nCF] := "6" + SubStr(SF4->F4_CF, 2, 3)
							Else
								aCols[n][_nCF] := "7" + SubStr(SF4->F4_CF, 2, 3)
							EndIf
						Endif
					Endif
				Endif
				
				If _nSegUM > 0
					aCols[n][_nSegUM] := SB1->B1_SEGUM
				Endif
				
				If _nLocal > 0
					aCols[n][_nLocal] := SB1->B1_LOCPAD
				Endif
				
				If _nDescri > 0
					aCols[n][_nDescri] := SZ2->Z2_DESCCLI
				Endif
				
				If _nPedCli > 0
					aCols[n][_nPedCli] := SZ2->Z2_PEDCLI
				Endif
				
				If _nPrcUni > 0
					_dDataRef := SZ2->Z2_DTREF01
					_nVl   := SZ2->Z2_PRECO01
					For i := 2 to 12
						If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= _dDataRef
							_dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
							_nVl     := &("SZ2->Z2_PRECO"+StrZero(i,2))
						Endif
					Next i
					
					aCols[n][_nPrcUni] :=  _nVl
				Endif
			Endif
			
			If _nClasFis > 0
				aCols[n][_nClasFis] := Subs(SB1->B1_ORIGEM,1,1)+SB1->B1_CLASFIS
			Endif
			
			If _nCodISS > 0
				aCols[n][_nCodISS] := SB1->B1_CODISS
			Endif
			
			dbSelectArea("SZ5")
			dbSkip()
		EndDo
	Endif
	
	N := _nCli
	
	For A:= 1 To Len(Acols)
		Acols[A][_nPItem]  := StrZero(A,2)
	Next A

	_cItem := "00"
	For A:= 1 To Len(Acols)
		_cItem := SomaIt(_cItem)
		Acols[A][_nPItem]  := _cItem
	Next A
Else
	dbSelectArea("SZ2")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ2")+M->C5_CLIENTE+M->C5_LOJACLI + _cProduto + _cProdCli+"1")
		If _nQuant < SZ2->Z2_LOTEMIN
//			Alert("Quantidade Informada Inferior ao Lote Minimo !! CONFIRMA? ")
			If (MsgYesNo("Quantidade Informada Inferior ao Lote Minimo !!","Atencao"))
			   nOpca := 1
			Else
			   nOpca := 0
			Endif

			If nOpca == 0
				_nQuant2 := 0
			Endif			
		Endif
	Endif
Endif 
	
RestArea(_aAliSA1)
RestArea(_aAliSB1)
RestArea(_aAliSF4)
RestArea(_aAliSZ2)
RestArea(_aAliSZ5)
RestArea(_aAliOri)

Return(_nQuant2)



User Function GAT003()

_aAliOri  := GetArea()
_aAliSZ2  := SZ2->(GetArea())

_nPoProd      := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRODUTO" } )
_nPoProdC     := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_CPROCLI" } )
_nPOQtdVen    := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_QTDVEN"  } )
_nPoPrcVen    := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRCVEN"  } )
_nPoLocal     := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_LOCAL"   } )
_nPoPrcUni    := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRUNIT"  } )

_nPrcVen      := ACols[N][_nPoPrcVen]
_nQuant       := ACols[N][_nPoQtdVen]

If M->C5_TIPO == "N"
	
	_cProduto := ACols[N][_nPoProd]
	_cProdCli := ACols[N][_nPoProdC]
	_cCliente := M->C5_CLIENTE
	_cLoja    := M->C5_LOJACLI
	
	dbSelectArea("SZ2")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ2")+M->C5_CLIENTE+M->C5_LOJACLI + _cProduto + _cProdCli+"1")
		
		If _nPrcVen > 0
			_dDataRef := SZ2->Z2_DTREF01
			_nVl      := SZ2->Z2_PRECO01
			For i := 2 to 12
				If  &("SZ2->Z2_DTREF"+StrZero(i,2)) >= _dDataRef
					_dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
					_nVl      := &("SZ2->Z2_PRECO"+StrZero(i,2))
				Endif
			Next i
			aCols[n][_nPoPrcVen]  := _nVl
		Endif
			
		If _nPrcVen != _nVl
			MsgBox ("O Preco Informado Esta Diferente do Preco de Tabela!!!","Atencao","ALERT")
		Endif
	Endif
	
Endif

RestArea(_aAliSZ2)
RestArea(_aAliOri)

Return(_nPrcVen)


User Function GATFAT001()

_aAliOri := GetArea()
_cTipo   := M->B1_TIPO

If _cTipo $ "FR/MP/PI/ME/PA"
	If Empty(M->B1_POSIPI) .Or. Empty(M->B1_POSIPI)
	   Alert("Preencher os Campos POS IPI e ALIQ IPI na Pasta 'IMPOSTOS' ")
	   _cTipo := ""
	Endif   
Endif

RestArea(_aAliOri)


Return(_cTipo)                



User Function GFAT004()

_aAliOri  := GetArea()
_aAliSZJ  := SZJ->(GetArea())

_nPoSerie     := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "ZJ_SERIE" 	} )
_nPoNF		  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "ZJ_NF" 		} )
_nPoEmiss	  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "ZJ_EMISSAO" 	} )
_nPoCodCli	  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "ZJ_CLIENTE" 	} )
_nPoLoja	  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "ZJ_LOJACLI"	} )
_nPoNomCli	  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "ZJ_NOMECLI" 	} )
_nPoValor	  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "ZJ_VALORNF" 	} )

_cSerie       := ACols[N][_nPoSerie]
_cNF	      := ACols[N][_nPoNF]

If SF2->(dbSeek(xFilial("SF2")+_cNF+_cSerie ))

	_cNome := ""
	SZJ->(dbSetOrder(1))
	If !SZJ->(dbSeek(xFilial("SZJ")+_cNF+_cSerie ))

		If !SF2->F2_TIPO $ "D/B"
			IF SA1->(dbseek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
				_cNome := SA1->A1_NOME
			Endif
		Else
			IF SA2->(dbseek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA))
				_cNome := SA2->A2_NOME
			Endif
		Endif
	
		aCols[n][_nPoEmiss]  := SF2->F2_EMISSAO
		aCols[n][_nPoCodCli] := SF2->F2_CLIENTE
		aCols[n][_nPoLoja]   := SF2->F2_LOJA
		aCols[n][_nPoNomCli] := _cNome
		aCols[n][_nPoValor]  := SF2->F2_VALBRUT
	Else
		Alert("Nota Fiscal já enviada no Romaneio: "+SZJ->ZJ_NUMERO)
		ACols[N][_nPoSerie]  := ""
		ACols[N][_nPoNF]     := ""
	Endif
	
Endif

RestArea(_aAliSZJ)
RestArea(_aAliOri)

Return(_cNome)


User Function GFAT001()

_aAliOri2 := GetArea()
_aAliSC6  := SC6->(GetArea())
_aAliSD2  := SD2->(GetArea())
_cProdCli := M->Z2_CODCLI

dbSelectArea("SC6")
dbOrderNickname("INDSC61")
If dbSeek(xFilial()+M->Z2_CLIENTE+M->Z2_LOJA+M->Z2_PRODUTO+M->Z2_CODCLI)
   MSGBOX("Cadastro ja Possui Movimento e nao Pode ser Alterado/Excluido!!!","Informacao","INFO")
   _cProdCli := SZ2->Z2_CODCLI
Endif

dbSelectArea("SD2")
dbOrderNickname("INDSD21")
If dbSeek(xFilial() + M->Z2_CLIENTE + M->Z2_LOJA + M->Z2_PRODUTO + M->Z2_CODCLI)
   MSGBOX("Cadastro ja Possui Movimento e nao Pode ser Alterado/Excluido!!!","Informacao","INFO")
   _cProdCli := SZ2->Z2_CODCLI   
Endif

RestArea(_aAliSC6)
RestArea(_aAliSD2)
RestArea(_aAliOri2)

Return(_cProdCli)   