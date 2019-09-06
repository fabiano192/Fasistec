#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CodProd   ºAutor  ³Alexandro da Silva  º Data ³  22/03/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Com base na amarracao Produto x Cliente este programa      º±±
±±º          ³ atraves do codigo do Produto no cliente localiza o cod. do º±±
±±º          ³ produto na Pasy                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Itens do Pedido de Venda                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CodProd()

Local nRegSZ2, nOrderSZ2, cAlias, nReg, nOrder, nOrderSB1, nRegSB1
Local nRegSA1, nOrderSA1, nRegSF4, nOrderSF4
Local cRetorno := ""

Local nPosProduto := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRODUTO" } )
Local nPosUM      := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_UM"      } )
Local nPosPrcVen  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRCVEN"  } )
Local nPosTES     := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_TES"     } )
Local nPosRev     := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_REVPED"  } )
Local nPosCF      := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_CF"      } )
Local nPosSegUM   := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_SEGUM"   } )
Local nPosLocal   := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_LOCAL"   } )
Local nPosDescri  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_DESCRI"  } )
Local nPosPrcUni  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRUNIT"  } )
Local nPosClasFis := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_CLASFIS" } )
Local nPosCodISS  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_CODISS"  } )
Local nPosPedCli  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PEDCLI"  } )
Local nPosCodCli  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_CPROCLI" } )

_nPerDes := 0
cAlias   := Select()
nOrder   := IndexOrd()
nreg     := RecNo()

dbSelectArea("SZ2")
nOrderSZ2 := IndexOrd()
nRegSZ2   := RecNo()
dbSetOrder(6)
If dbSeek(xFilial("SZ2")+M->C5_CLIENTE+M->C5_LOJACLI + aCols[n][nPosCodCli]+"1" )
	
	cRetorno               := SZ2->Z2_PRODUTO
	aCols[n][nPosRev]      := SZ2->Z2_REVISAO
	aCols[n][nPosProduto]  := SZ2->Z2_PRODUTO
	If nPosTES > 0
		aCols[n][nPosTes]  := SZ2->Z2_TES
	Endif
	
	a410Produto(aCols[n][nPosProduto])
	
	dbSelectArea("SA1")
	nOrderSA1 := IndexOrd()
	nRegSA1   := RecNo()
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI)
	
	dbSelectArea("SB1")
	nOrderSB1 := IndexOrd()
	nRegSB1   := RecNo()
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+aCols[n][nPosProduto])
		If nPosUM > 0
			aCols[n][nPosUM] := SB1->B1_UM
		Endif
		
		If nPosPrcVen > 0
			dDataRef := SZ2->Z2_DTREF01
			nValor   := SZ2->Z2_PRECO01
			For i := 2 to 12
				If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= dDataRef
					dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
					nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
				Endif
			Next i
			
			If M->C5_CLIENTE == "000008" .And. Substr(SZ2->Z2_PEDCLI,1,4) $ "QAPC/QAPP/QHPP"
				If SB1->B1_PICM == 12
					_nPerDes := Val(Tabela("Z8","12"))
				Else
					_nPerDes := Val(Tabela("Z8","18"))
				Endif
//			ElseIf M->C5_CLIENTE == "000026" .And. M->C5_LOJACLI == "02"
//  				If SB1->B1_PICM == 12
//					_nPerDes := Val(Tabela("Z8","12"))
//				Else
//					_nPerDes := Val(Tabela("Z8","18"))
//				Endif
			Endif
			nValor := nValor - (nValor * (_nPerDes/100))
						
			aCols[n][nPosPrcVen]  := nValor
			aCols[n][nPosPrcUni] :=  nValor
		Endif
		
		If nPosCF > 0
			If nPosTES > 0
				dbSelectArea("SF4")
				nOrderSF4 := IndexOrd()
				nRegSF4   := RecNo()
				dbSetOrder(1)
				If dbSeek(xFilial("SF4")+aCols[n][nPosTES])
					If SA1->A1_EST == GetMV("MV_ESTADO") .And. SA1->A1_TIPO # "X"
						aCols[n][nPosCF] := "5" + SubStr(SF4->F4_CF, 2, 3)
					ElseIf SA1->A1_TIPO # "X"
						aCols[n][nPosCF] := "6" + SubStr(SF4->F4_CF, 2, 3)
					Else
						aCols[n][nPosCF] := "7" + SubStr(SF4->F4_CF, 2, 3)
					EndIf
				Endif
				dbSetOrder(nOrderSF4)
				dbGoTo(nRegSF4)
			Endif
		Endif
		
		If nPosSegUM > 0
			aCols[n][nPosSegUM] := SB1->B1_SEGUM
		Endif
		
		If nPosLocal > 0
			aCols[n][nPosLocal] := SB1->B1_LOCPAD
		Endif
		
		If nPosDescri > 0
			aCols[n][nPosDescri] := SZ2->Z2_DESCCLI
		Endif
		
		If nPosPedCli > 0
			aCols[n][nPosPedCli] := SZ2->Z2_PEDCLI
		Endif
		
		If nPosClasFis > 0
			aCols[n][nPosClasFis] := Subs(SB1->B1_ORIGEM,1,1)+SB1->B1_CLASFIS
		Endif
		
		If nPosCodISS > 0
			aCols[n][nPosCodISS] := SB1->B1_CODISS
		Endif
	Endif
	
	dbSelectArea("SA1")
	dbSetOrder(nOrderSA1)
	dbGoTo(nRegSA1)
	
	dbSelectArea("SB1")
	dbSetOrder(nOrderSB1)
	dbGoTo(nRegSB1)
Endif

dbSelectArea("SZ2")
dbSetOrder(nOrderSZ2)
dbGoTo(nRegSZ2)

dbSelectArea(cAlias)
dbSetOrder(nOrder)
dbgoTo(nreg)

Return(cRetorno)