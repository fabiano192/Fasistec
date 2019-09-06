#INCLUDE "TOTVS.ch"

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

	Local _nPerDes    := 0
	Local _aListBox   := {}

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
	Local cRetorno    := aCols[n][nPosProduto]

	_aAliOri  := GetArea()
	_aAliSZ2  := SZ2->(GetArea())
	_aAliSC5  := SC5->(GetArea())
	_aAliSC6  := SC6->(GetArea())
	_aAliSF4  := SF4->(GetArea())
	_aAliSA1  := SA1->(GetArea())
	_aAliSB1  := SB1->(GetArea())

	SZ2->(dbSetOrder(6))
	If SZ2->(dbSeek(xFilial("SZ2")+M->C5_CLIENTE+M->C5_LOJACLI + aCols[n][nPosCodCli]+"1" ))

		_nCont := 0

		_cChave := M->C5_CLIENTE+C5_LOJACLI+aCols[n][nPosCodCli]+"1"

		While !SZ2->(EOF()) .And. _cChave = 	SZ2->Z2_CLIENTE+SZ2->Z2_LOJA+SZ2->Z2_CODCLI+SZ2->Z2_ATIVO

			_nCont ++

			SB1->(dbSetOrder(1))
			SB1->(msSeek(xFilial("SB1")+SZ2->Z2_PRODUTO))

			dDataRef := SZ2->Z2_DTREF01
			_nValor   := SZ2->Z2_PRECO01
			For i := 2 to 12
				If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= dDataRef
					dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
					_nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
				Endif
			Next i

		 	_nPerDes := 0
		 	If M->C5_CLIENTE == "000017" .And. Substr(SZ2->Z2_PEDCLI,1,4) $ "QAPC/QAPP/QHPP"
				If SB1->B1_PICM == 12
					_nPerDes := Val(Tabela("Z8","12"))
				Else
					_nPerDes := Val(Tabela("Z8","18"))
				Endif
			Endif

			_nValor := _nValor - (_nValor * (_nPerDes/100))

			SA1->(dbSetOrder(1))
			SA1->(msSeek(xFilial("SA1")+SZ2->Z2_CLIENTE+SZ2->Z2_LOJA))

			_cCF := ''
			SF4->(dbSetOrder(1))
			If SF4->(msSeek(xFilial("SF4")+aCols[n][nPosTES]))
				If SA1->A1_EST == GetMV("MV_ESTADO") .And. SA1->A1_TIPO # "X"
					_cCF := "5" + SubStr(SF4->F4_CF, 2, 3)
				ElseIf SA1->A1_TIPO # "X"
					_cCF := "6" + SubStr(SF4->F4_CF, 2, 3)
				Else
					_cCF := "7" + SubStr(SF4->F4_CF, 2, 3)
				EndIf
			Endif

			AADD(_aListBox,{If(_nCont = 1, .T.,.F.)		,; //01
			SZ2->Z2_PRODUTO								,; //02
			SZ2->Z2_REVISAO								,; //03
			SZ2->Z2_TES									,; //04
			SB1->B1_UM									,; //05
			_nValor										,; //06
			SB1->B1_SEGUM								,; //07
			SB1->B1_LOCPAD								,; //08
			SZ2->Z2_DESCCLI								,; //09
			SZ2->Z2_PEDCLI								,; //10
			Left(SB1->B1_ORIGEM,1)+SB1->B1_CLASFIS		,; //11
			_cCF										,; //12
			SB1->B1_CODISS								}) //13

			SZ2->(dbSkip())
		EndDo

		If _nCont > 1 .And. !IsInCallStack("u_CR0003")
			_oOk   := LoadBitmap(GetResources(), "LBOK")
			_oNo   := LoadBitmap(GetResources(), "LBNO")

			_oDlg := _oListBox := Nil

			DEFINE DIALOG _oDlg TITLE "Produto X Cliente" FROM 0,0 TO 200,800	OF _oDlg PIXEL Style DS_MODALFRAME

			@ 005,005 TO 075,395 LABEL "" OF _oDlg PIXEL

			_oDlg:lEscClose := .F. //Não permite fechar a janela pelo botão "ESC"

			//			_oSay:= TSay():New(10,10,{||'Escolha abaixo qual o tipo de CTE que deseja Integrar:'},_oDlg1,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)

			_oListbox := TWBrowse():New( 10,10,380,060,,{'','Produto','UM','Revisão','Pedido','Valor','TES','Descrição'},,_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

			_oListbox:SetArray(_aListBox)
			_oListbox:bLine := {||{If(_aListBox[_oListbox:nAt,1],_oOk,_oNo ),;
			_aListBox[_oListbox:nAt,2],;
			_aListBox[_oListbox:nAt,5],;
			_aListBox[_oListbox:nAt,3],;
			_aListBox[_oListbox:nAt,10],;
			Transform(_aListBox[_oListbox:nAt,6],"@E 9,999,999.9999"),;
			_aListBox[_oListbox:nAt,4],;
			_aListBox[_oListbox:nAt,9] } }

			_oListbox:bLDblClick := {|| CheckBox(_aListBox,_oListbox)}

			_oTButOk	:= TButton():New( 080, 010, "OK"	,_oDlg,{||_oDlg:End()}	, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

			ACTIVATE MSDIALOG _oDlg CENTERED

		Endif

	Endif

	If !Empty(_aListBox) .And. !IsInCallStack("u_CR0003")
		For F := 1 To Len(_aListBox)
			If _aListBox[F][1]
				cRetorno               	:= _aListBox[F][2]
				aCols[n][nPosRev]      	:= _aListBox[F][3]
				aCols[n][nPosProduto]  	:= _aListBox[F][2]
				aCols[n][nPosTes]  		:= _aListBox[F][4]

				a410Produto(aCols[n][nPosProduto])

				aCols[n][nPosUM] 		:= _aListBox[F][5]
				aCols[n][nPosPrcVen]	:= _aListBox[F][6]
				aCols[n][nPosPrcUni]	:= _aListBox[F][6]
				aCols[n][nPosSegUM] 	:= _aListBox[F][7]
				aCols[n][nPosLocal] 	:= _aListBox[F][8]
				aCols[n][nPosDescri] 	:= _aListBox[F][9]
				aCols[n][nPosPedCli] 	:= _aListBox[F][10]
				aCols[n][nPosClasFis] 	:= _aListBox[F][11]
				aCols[n][nPosCF] 		:= _aListBox[F][12]
				If nPosCodISS > 0
					aCols[n][nPosCodISS]:= _aListBox[F][13]
				Endif
			Endif
		Next F
	Endif

	RestArea(_aAliSB1)
	RestArea(_aAliSA1)
	RestArea(_aAliSF4)
	RestArea(_aAliSC6)
	RestArea(_aAliSC5)
	RestArea(_aAliSZ2)
	RestArea(_aAliOri)

Return(cRetorno)


Static Function CheckBox(_aListBox,_oListbox)

	_aListBox[_oListbox:nAt][1] := !_aListBox[_oListbox:nAt][1]

	For F:=1 To Len(_aListBox)


		If F <> _oListbox:nAt
			_aListBox[F][1] := .F.
		Endif
//		_aListBox[F][1] := !_aListBox[F][1]

	Next F

	_oListbox:Refresh()

Return
