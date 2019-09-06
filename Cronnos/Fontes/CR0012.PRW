#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"

/*/
Funçao    	³ CR0012
Data 		³ 19.03.12
Descricao 	³ Programacao de entrega Caterpillar Brasil(000017)
/*/

User Function CR0012()

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

	PRIVATE cTitulo    	:= "Programacao Entrega"
	Private _cAnexo
	Private _cCATFold	:= GetMV("CR_CATFOLD")

	Private _nPula,_lPrim,_cItem,_lAchou,_nPrcVen,_cNum,_lVerFat, _lIncSC6, _cPedido

	Private _lIncSC6 		:= .F.
	Private _nTotQt  		:= 0

	SZ4->(dbSetOrder(1))

	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| CR12A(@_lFim) }
	Private _cTitulo01 := 'Processando'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

	_bAcao01   := {|_lFim| CR12B(@_lFim) }
	_cTitulo01 := 'Integrando os Pedidos...'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

	CR012C()

	_cq3  := " UPDATE SC6010 SET C6_BLQ = 'R', C6_XDTELIM = '"+DTOS(dDataBase)+"', C6_LOCALIZ = 'CR0012' "
	_cq3  += " WHERE D_E_L_E_T_ = '' AND C6_PEDAMOS IN ('Z','M','I') AND C6_QTDENT < C6_QTDVEN AND C6_CLI = '000017' "
	_cq3  += " AND C6_BLQ = '' AND C6_ENTREG < '"+DTOS(dDataBase)+"' "
	If SC6->(FieldPos("C6_XRESIDU")) > 0
		_cq3  += " AND C6_XRESIDU <> 'N' "
	Endif


	TCSQLEXEC(_cq3)

	CONOUT("Final da integração CBL - CR0012")

Return



Static Function CR12A(_lFim)

	Pergunte("",.F.)

	aStru := {}
	AADD(aStru,{"INDICE"   , "C" , 01, 0 })
	AADD(aStru,{"PRODCLI"  , "C" , 15, 0 })
	AADD(aStru,{"CLIENTE"  , "C" , 06, 0 })
	AADD(aStru,{"LOJA"     , "C" , 02, 0 })
	AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
	AADD(aStru,{"PEDCLI"   , "C" , 20, 0 })

	cArqLOG := CriaTrab(aStru,.T.)
	cIndLOG := "INDICE+PRODUTO+PRODCLI"
	dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

	dbSelectArea("TRB")
	IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

	_cCont     := ""
	_cUM       := ""
	_dDtMov    := Ctod("")
	_cCliente  := ""
	_cLoja     := ""
	_cSemAtu   := ""
	_cSemAtu2  := ""
	_dDtAtu    := Ctod("")
	_cSemAnt   := ""
	_cProdCli  := ""
	_cProdCron := ""
	_cLocDest  := ""
	_cContato  := ""
	_cTipo     := ""
	_cUltNf    := ""
	_cSerNf    := ""
	_dDtUltNf  := Ctod("")
	_dDtEnt    := Ctod("")
	_nQtEnt    := ""
	_aDtEnt    := {}
	_cPedido   := ""
	_aPedido   := {}
	_cDesenho  := ""

	_cData2    := GravaData(dDataBase,.f.,8)
	_cHora2    := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
	_dDt       := dDataBase - 20

	ProcRegua(20)

	For Z:= _dDt TO dDataBase

		IncProc()
		_cDir := _cCATFold+"Brasil\Entrada\"+DTOS(_dDt)+"\Cronnos.????.000001.RND001*.TXT"

		_aArqTxt= ARRAY(ADIR(_cDir))
		ADIR(_cCATFold+"Brasil\Entrada\"+DTOS(_dDt)+"\Cronnos.????.000001.RND001*.TXT",_aArqTxt)

		For I:= 1 to Len(_aArqTxt)

			_lAchou    := .t.
			_lProx     := .F.
			_cArq2     := _cCATFold+"Brasil\Entrada\"+DTOS(_dDt)+"\BKP_"+Alltrim(_aArqTxt[I])
			_cArq3     := _cCATFold+"Brasil\Entrada\"+DTOS(_dDt)+"\"+Alltrim(_aArqTxt[i])

			_cArqNovo  := fCreate(Alltrim(_cArq2),0)
			_cArq      := FOpen(_cArq3,0)
			_cQtArq    := 1

			While .T.

				cLinha := fReadStr(_cArq,130)

				If Len(cLinha) == 0
					Exit
				Endif

				If Subs(cLinha,1,3) == "ITP"
					_cCont   := Subst(cLinha,9,5)
					_dDTMov  := Ctod(Subst(cLinha,18,2)+"/"+Subst(cLinha,16,2)+"/20"+Subst(cLinha,14,2))

					SA1->(dbSetOrder(3))
					If SA1->(dbSeek(xFilial("SA1")+Subst(cLinha,26,14)))
						_cCliente := SA1->A1_COD
						_cLoja    := SA1->A1_LOJA
					Endif
				ElseIf Subs(cLinha,1,3) == "PE1"
					_nQt       := 0
					_lProx     := .T.
					_cSemAtu   := Subs(cLinha,7,9)
					_cSemAtu2  := Subs(cLinha,7,9)
					_dDtAtu    := Ctod(Subst(cLinha,20,2)+"/"+Subst(cLinha,18,2)+"/20"+Subst(cLinha,16,2))
					_cSemAnt   := Subs(cLinha,22,9)
					_cProdCli  := Subs(cLinha,37,15)
					_cPedido   := Subs(cLinha,97,11)
					//				_cPedido   := Subs(cLinha,97,12)
					_cProdCron := ""
					_cUm       := Subs(cLinha,125,2)

					If Left(_cPedido,4) $ "QEST/HETZ"
						_cLoja = "02"
					ElseIf Left(_cPedido,4) $ "QHPD/QAPD/QYPD"
						_cLoja = "03"
					Endif

					dbSelectArea("SZ2")
					dbSetOrder(8)
					If dbSeek(xFilial("SZ2")+_cCliente + _cLOja + _cProdCli + Left(_cPedido+Space(20),20) + "1")
						_cProdCron := SZ2->Z2_PRODUTO
						dbSelectArea("SZ2")
						RecLock("SZ2",.F.)
						SZ2->Z2_UM  := _cUm
						MsUnlock()
					Else
						TRB->(RecLock("TRB",.T.))
						TRB->INDICE  := "1"
						TRB->PRODCLI := _cProdCli
						TRB->CLIENTE := _cCliente
						TRB->LOJA    := _cLoja
						TRB->PEDCLI  := _cPedido
						TRB->(MsUnlock())
					Endif

					_cLocDest := Subs(cLinha,109,5)
					_cContato := Subs(cLinha,114,11)
					_cTipo    := Subs(cLinha,128,1)
				ElseIf Subs(cLinha,1,3) == "PE2"
					_cUltNf   := Subs(cLinha,10,6)
					_cSerNf   := Subs(cLinha,16,4)
					_dDtUltNf := Ctod(Subst(cLinha,24,2)+"/"+Subst(cLinha,22,2)+"/20"+Subst(cLinha,20,2))
				ElseIf Subs(cLinha,1,3) == "PE3"
					_nQt   := 12
					_nQtAb := 4

					_aQuant := {}
					For A:= 1 to 7
						_nQtEnt := Val(Subs(cLinha,_nQt,9))

						_dDtFech := Ctod(Subst(cLinha,_nQtAb+4,2)+"/"+Subst(cLinha,_nQtAb+2,2)+"/20"+Subst(cLinha,_nQtAb,2))

						If !Empty(_nQtEnt)
							AADD(_aQuant,{_nQtEnt,_dDtFech})
							_nQt   += 17
							_nQtAb += 17
						Else
							A:= 7
						Endif

					Next A
				ElseIf Subs(cLinha,1,3) == "PE5"

					_nQtDt := 4

					_aDtEnt := {}
					For A:= 1 to 7
						_dDtEnt := Ctod(Subst(cLinha,_nQtDt+4,2)+"/"+Subst(cLinha,_nQtDt+2,2)+"/20"+Subst(cLinha,_nQtDt,2))
						If !Empty(_dDtEnt)
							AADD(_aDtEnt,{_dDtEnt})
							_nQtDt += 16
						Else
							A:= 7
						Endif
					Next A

					_aTpPed  := {}
					_nPed    := 10

					If !Empty(_cProdCron)
						SZ4->(dbSetOrder(4))
						If SZ4->(dbSeek(xFilial("SZ4")+Dtos(dDataBase)+ _cCliente + _cLoja + _cProdCron))
							_cChavProg := Dtos(SZ4->Z4_DTDIGIT) +SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS

							While SZ4->(!Eof()) .And. _cChavProg == DTOS(SZ4->Z4_DTDIGIT) +SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS

								If _cSemAtu == _cSemAtu2 .And. UPPER(SZ4->Z4_NOMARQ)  != DTOS(_dDt)+"\"+UPPER(Alltrim(_aArqTxt[i]))
									SZ4->(RecLock("SZ4",.F.))
									SZ4->(dbDelete())
									SZ4->(MsUnlock())
								Endif

								SZ4->(dbSkip())
							EndDo
						Else
							_lProx := .F.
						Endif
					Endif

					For B:= 1 To Len(_aDtEnt)

						If !Empty(_cProdCron)
							SZ4->(dbSetOrder(4))
							If SZ4->(dbSeek(xFilial("SZ4")+Dtos(dDataBase)+ _cCliente + _cLoja + _cProdCron +Dtos(_aDTEnt[B,1]) ))
								_cChavProg := Dtos(SZ4->Z4_DTDIGIT) +SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + DTOS(SZ4->Z4_DTENT)

								While SZ4->(!Eof()) .And. _cChavProg == DTOS(SZ4->Z4_DTDIGIT) +SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + DTOS(SZ4->Z4_DTENT)

									If _cSemAtu == _cSemAtu2 .And. UPPER(SZ4->Z4_NOMARQ)  != DTOS(_dDt)+"\"+UPPER(Alltrim(_aArqTxt[i]))
										SZ4->(RecLock("SZ4",.F.))
										SZ4->(dbDelete())
										SZ4->(MsUnlock())
									Endif

									SZ4->(dbSkip())
								EndDo
							Else
								_lProx := .F.
							Endif
						Endif

						_cTpPed    := Subs(cLinha,_nPed,1)

						_nPed += 16
						SZ4->(RecLock("SZ4",.T.))
						SZ4->Z4_FILIAL  := xFilial("SZ4")
						SZ4->Z4_CODCLI  := _cCliente
						SZ4->Z4_LOJA    := _cLoja
						SZ4->Z4_PRODPAS := _cProdCron
						SZ4->Z4_PRODCLI := _cProdCli
						SZ4->Z4_DTMOV   := _dDtMov
						SZ4->Z4_CONTROL := _cCont
						SZ4->Z4_SEMATU  := _cSemAtu
						SZ4->Z4_DTATU   := _dDtAtu
						SZ4->Z4_SEMANT  := _cSemAnt
						SZ4->Z4_LOCDEST := _cLocDest
						SZ4->Z4_TIPO    := _cTipo
						SZ4->Z4_ULTNF   := "000"+_cUltNf
						SZ4->Z4_SERIE   := _cSerNf
						SZ4->Z4_DTULTNF := _dDtUltNf
						SZ4->Z4_DTENT   := _aDTEnt[B,1]
						SZ4->Z4_QTENT   := _aQuant[B,1]
						SZ4->Z4_DTFECH  := _aQuant[B,2]
						SZ4->Z4_PEDIDO  := _cPedido
						SZ4->Z4_TPPED   := _cTpPed
						SZ4->Z4_CONTATO := _cContato
						SZ4->Z4_DTDIGIT := dDataBase
						SZ4->Z4_NOMARQ  := DTOS(_dDt)+"\"+UPPER(Alltrim(_aArqTxt[i]))
						SZ4->(MsUnlock())
					Next B

					_cSemAtu2 := ""
				ElseIf Subs(cLinha,1,3) == "PE6"
					_cDesenho := Subs(cLinha,14,4)
					If SZ4->(dbSeek(xFilial("SZ4") + _cCont + _cCliente + _cLoja + _cProdCli))
						_cChavSZ4 :=  SZ4->Z4_CONTROL + SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODCLI
						While SZ4->(!Eof()) .And.  _cChavSZ4 ==  SZ4->Z4_CONTROL + SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODCLI
							SZ4->(RecLock("SZ4",.F.))
							SZ4->Z4_ALTTEC  := _cDesenho
							SZ4->(MsUnlock())

							SZ4->(dbSkip())
						EndDo
					Endif

				ElseIf Subs(cLinha,1,3) == "PE4"
					_cCaixa := Alltrim(Subs(cLinha,34,30))
					_cQtCai := Val(Subs(cLinha,64,12))/1000

					SZ2->(dbSetOrder(4))
					If SZ2->(msSeek(xFilial('SZ2')+Left(_cCaixa+Space(15),15)+_cCliente))

						_cCodCai := SZ2->Z2_PRODUTO

						SZ2->(dbSetOrder(8))
						If SZ2->(dbSeek(xFilial("SZ2")+_cCliente + _cLoja + _cProdCli+Left(_cPedido+Space(20),20)+"1"))

							SZ2->(RecLock('SZ2',.F.))
							SZ2->Z2_CODEMB	:= _cCodCai
							SZ2->Z2_QTPEMB	:= _cQtCai
							SZ2->(MsUnlock())

						Endif
					Endif

				Endif

				FWrite(_cArqNovo,cLinha)
			EndDo

			fClose(_cArq2)

			If File(_cArq3)
				FClose(_cArq)
				FErase(_cArq3)
			Endif
		Next I

		_dDt++

	Next Z

Return


Static Function CR12B(_lFim)

	Private _lPrim,_cItem,_cItemExp,_lAchou,_nPrcVen,_cNum,_lVerFat, _lIncSC6, _cPedido
	Private _lIncSC6 := .F.
	Private _nTotQt  := 0

	SZ4->(dbSetOrder(1))

	Private _lNAchou   	:= .F.
	_lFim      			:= .F.

	_lNAchou := .F.

	_cq  := "UPDATE SD2010 SET D2_PROGENT = 0 WHERE D2_CLIENTE = '000017'"

	TCSQLEXEC(_cq)

	SZ4->(dbSetOrder(4))
	If SZ4->(dbSeek(xFilial("SZ4")+DTOS(dDataBase),.F.))

		ProcRegua(RecCount())

		While SZ4->(!Eof()) .And. SZ4->Z4_DTDIGIT == dDataBase

			_lPrim     := .F.
			_nTotQt    := 0
			_cItem     := "00"
			_cClieLoja := SZ4->Z4_CODCLI + SZ4->Z4_LOJA

			While SZ4->(!Eof()) .And.	_cClieLoja == SZ4->Z4_CODCLI + SZ4->Z4_LOJA .And. SZ4->Z4_DTDIGIT == dDataBase

				If SZ4->Z4_CODCLI != "000017"
					SZ4->(dbSkip())
					Loop
				Endif

				If SZ4->Z4_INTEGR = "S"
					SZ4->(dbSkip())
					Loop
				Endif

				IncProc()

				_cProdCli := SZ4->Z4_PRODCLI
				_nSubQt   := 0

				SZ2->(dbSetOrder(8))
				If SZ2->(!dbSeek(xFilial("SZ2")+SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODCLI+SZ4->Z4_PEDIDO+"1"))
					TRB->(RecLock("TRB",.T.))
					TRB->INDICE  := "2"
					TRB->PRODCLI := _cProdCli
					TRB->PRODUTO := SZ4->Z4_PRODPAS
					TRB->CLIENTE := SZ4->Z4_CODCLI
					TRB->LOJA    := SZ4->Z4_LOJA
					TRB->PEDCLI  := SZ4->Z4_PEDIDO
					TRB->(MsUnlock())

					SZ4->(dbSkip())
					Loop
				Endif

				dDataRef := SZ2->Z2_DTREF01
				nValor   := SZ2->Z2_PRECO01
				For i := 2 to 12
					If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= dDataRef
						dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
						nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
					Endif
				Next i

				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+SZ4->Z4_PRODPAS))

				ZERAPED()

				_nPerDes := 0

				If Substr(SZ4->Z4_PEDIDO,1,4) $ "QAPC/QAPP/QHPP"
					If SB1->B1_PICM == 12
						_nPerDes := Val(Tabela("Z8","12"))
					Else
						_nPerDes := Val(Tabela("Z8","18"))
					Endif
				Endif

				nValor   := nValor - (nValor * (_nPerDes/100))
				_nPrcVen := Round(nValor,5)

				_lVerFat := .t.

				While SZ4->(!Eof()) .And. _cProdCli == SZ4->Z4_PRODCLI

					If _lFim
						Alert("Cancelado Pelo Usuario!!!!!!")
						Return
					Endif

					INTSC6C()

					SZ4->(RecLock("SZ4",.F.))
					SZ4->Z4_INTEGR := "S"
					SZ4->Z4_IMPRES := "S"
					SZ4->(MsUnlock())

					_nRecSz4 := SZ4->(Recno())
					SZ4->(dbSkip())
				EndDo

				SZ4->(dbGoto(_nRecSZ4))

				ELIMR()

				SZ4->(dbSkip())
			EndDo
		EndDo
	Endif

Return


Static Function IntSC6C()

	_nFatur := 0

	_cNF := SZ4->Z4_ULTNF
	_lOk := .F.
	SF2->(dbSetOrder(1))
	If SF2->(dbSeek(xFilial("SF2")+SZ4->Z4_ULTNF+SZ4->Z4_SERIE))
		_cNF := SZ4->Z4_ULTNF
		_lOk := .T.
	Endif

	If !_lOk
		SF2->(dbSetOrder(1))
		If SF2->(dbSeek(xFilial("SF2")+Substr(SZ4->Z4_ULTNF,4,6)+"   "+SZ4->Z4_SERIE))
			_cNF := Substr(SZ4->Z4_ULTNF,4,6)+"   "
		Endif
	Endif

	If VAL(_cNF) > 0
		_cUltNf := _cNF + "01"
	Else
		_cUltNf := "000000001"
	Endif

	SD2->(dbOrderNickName("INDSD23"))
	SD2->(dbSeek(xFilial("SD2")+ SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + SZ4->Z4_SERIE + _cUltNf,.T.))

	_cChav  := SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS

	While SD2->(!Eof()) .And. _cChav == SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD

		If SD2->D2_DOC <= _cNF .And. SD2->D2_EMISSAO <= SZ4->Z4_DTULTNF
			SD2->(dbSkip())
			Loop
		Endif

		If SD2->D2_EMISSAO < SZ4->Z4_DTULTNF
			SD2->(dbSkip())
			Loop
		Endif

		If SD2->D2_QUANT == SD2->D2_PROGENT
			SD2->(dbSkip())
			Loop
		Endif

		If SD2->D2_VALDEV == SD2->D2_TOTAL
			SD2->(dbSkip())
			Loop
		Endif

		SC6->(dbSetOrder(1))
		If SC6->(dbSeek(xFilial("SC6")+SD2->D2_PEDIDO + SD2->D2_ITEMPV))
			If Alltrim(SC6->C6_PEDCLI) != Alltrim(SZ4->Z4_PEDIDO)
				SD2->(dbSkip())
				Loop
			Endif
		Endif

		_nFatur2 := _nFatur
		_nFatur  += SD2->D2_QUANT - SD2->D2_PROGENT

		If _nFatur >= SZ4->Z4_QTENT
			_nDif  := SZ4->Z4_QTENT - _nFatur2
		Else
			_nDif  := SD2->D2_QUANT - SD2->D2_PROGENT
		Endif

		SD2->(RecLock("SD2",.F.))
		SD2->D2_PROGENT += _nDif
		SD2->(MsUnlock())

		If _nFatur >= SZ4->Z4_QTENT
			Return
		Endif

		SD2->(dbSkip())
	EndDo

	_lAchou   := .F.

	SC6->(dbOrderNickName("INDSC61"))
	If SC6->(dbSeek(xFilial("SC6")+ SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + SZ4->Z4_PRODCLI + SZ4->Z4_PEDIDO + DTOS(SZ4->Z4_DTENT)))

		_cChavSC62 := SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + SC6->C6_PEDCLI + DTOS(SC6->C6_ENTREG)

		While SC6->(!Eof()) .And. 	_cChavSC62 == SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + SC6->C6_PEDCLI +DTOS(SC6->C6_ENTREG)

			If (SC6->C6_QTDVEN == SC6->C6_QTDENT) .Or. !Empty(SC6->C6_BLQ)
				SC6->(dbSkip())
				Loop
			Endif

			If (SC6->C6_QTDVEN - SC6->C6_QTDENT) != SZ4->Z4_QTENT - _nFatur
				SC6->(dbSkip())
				Loop
			Endif

			SC6->(RecLock("SC6",.F.))
			SC6->C6_IDENCAT := SZ4->Z4_SEMATU
			If SZ4->Z4_TPPED = "1"
				SC6->C6_PEDAMOS := "N"
			Endif
			SC6->(MsUnlock())

			_lAchou := .T.

			SC6->(dbSkip())
		EndDo
	Endif

	If !_lAchou

		_lVerFat := .F.
		_cItem   := SomaIt(_cItem)

		If !_lPrim .Or. _cItem == "ZZ"
			_cItem  := "01"
			_cNum  := GETSXENUM("SC5","C5_NUM")
			CONFIRMSX8()
			_lPrim := .T.

			_cPedido := _cNum
			_lIncSC6 := .F.

			SA1->(dbSetOrder(1))
			SA1->(dbSeek(xFilial("SA1")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA))

			SC5->(RecLock("SC5",.T.))
			SC5->C5_FILIAL  := xFilial("SC5")
			SC5->C5_NUM     := _cNum
			SC5->C5_TIPO    := "N"
			SC5->C5_CLIENTE := SZ4->Z4_CODCLI
			SC5->C5_CLIENT  := SZ4->Z4_CODCLI
			SC5->C5_LOJAENT := SZ4->Z4_LOJA
			SC5->C5_LOJACLI := SZ4->Z4_LOJA
			SC5->C5_TRANSP  := SA1->A1_TRANSP
			SC5->C5_TIPOCLI := SA1->A1_TIPO
			SC5->C5_CONDPAG := SA1->A1_COND
			SC5->C5_TIPLIB  := "1"
			SC5->C5_VEND1   := SA1->A1_VEND
			SC5->C5_COMIS1  := SA1->A1_COMIS
			SC5->C5_EMISSAO := dDataBase
			SC5->C5_PESOL   := 1
			SC5->C5_MOEDA   := 1
			SC5->C5_TXMOEDA := 1
			SC5->C5_TPCARGA := "2"
			SC5->(MsUnlock())
		Endif

		SF4->(dbSetOrder(1))
		SF4->(dbSeek(xFilial("SF4")+SZ2->Z2_TES))

		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+SZ4->Z4_PRODPAS))

		SC6->(RecLock("SC6",.T.))
		SC6->C6_FILIAL  := xFilial("SC6")
		SC6->C6_NUM     := _cNUm
		SC6->C6_ITEM    := _cItem
		SC6->C6_CPROCLI := SZ4->Z4_PRODCLI
		SC6->C6_PRODUTO := SZ4->Z4_PRODPAS
		SC6->C6_REVPED  := SZ4->Z4_ALTTEC
		SC6->C6_QTDVEN  := SZ4->Z4_QTENT - _nFatur
		SC6->C6_PRCVEN  := _nPrcVen
		SC6->C6_VALOR   := Round(( (SZ4->Z4_QTENT - _nFatur) * _nPrcVen ),2)
		SC6->C6_ENTREG  := SZ4->Z4_DTENT
		SC6->C6_YDTFECH := SZ4->Z4_DTFECH
		If SZ4->Z4_TPPED == "1"
			SC6->C6_PEDAMOS := "N"
		ElseIf SZ4->Z4_TPPED == "2"
			SC6->C6_PEDAMOS := "I"
		ElseIf SZ4->Z4_TPPED == "3"
			SC6->C6_PEDAMOS := "M"
		ElseIf SZ4->Z4_TPPED == "4"
			SC6->C6_PEDAMOS := "Z"
		Endif

		If SZ4->Z4_TIPO == "A"
			SC6->C6_PEDAMOS := "A"
		Endif

		SC6->C6_TES     := SZ2->Z2_TES

		If SA1->A1_EST == "SP"
			_cCf        := "5"
		ElseIf SA1->A1_EST == "EX"
			_cCf        := "7"
		Else
			_cCF        := "6"
		Endif
		SC6->C6_CF      := _cCf + Substr(SF4->F4_CF,2,3)
		SC6->C6_UM      := SB1->B1_UM
		SC6->C6_PEDCLI  := SZ4->Z4_PEDIDO
		SC6->C6_DESCRI  := SB1->B1_DESC
		SC6->C6_LOCAL   := SB1->B1_LOCPAD
		SC6->C6_CLI     := SZ4->Z4_CODCLI
		SC6->C6_LOJA    := SZ4->Z4_LOJA
		SC6->C6_PRUNIT  := _nPrcVen
		SC6->C6_TPOP    := "F"
		SC6->C6_IDENCAT := SZ4->Z4_SEMATU
		SC6->C6_CLASFIS := SUBSTR(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB
		SC6->(MsUnlock())
	Endif


Return


Static Function ELIMR()

	_cIdenCat := StrZero(Val(SZ4->Z4_SEMATU)-1,9)

	SC6->(dbOrderNickName("INDSC61"))
	If SC6->(dbSeek(xFilial("SC6")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA+SZ4->Z4_PRODPAS + SZ4->Z4_PRODCLI + SZ4->Z4_PEDIDO))

		_cChavSC6 := SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + SC6->C6_PEDCLI

		ProcRegua(SC6->(LastRec()))

		While SC6->(!Eof()) .And. _cChavSC6 == SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + SC6->C6_PEDCLI//+ DTOS(SC6->C6_ENTREG)

			If !Empty(SC6->C6_BLQ) .Or. SC6->C6_PEDAMOS == "D"
				SC6->(dbSkip())
				Loop
			Endif

			If SC6->C6_QTDVEN == SC6->C6_QTDENT
				SC6->(dbSkip())
				Loop
			Endif

			If	SC6->C6_IDENCAT == SZ4->Z4_SEMATU
				SC6->(dbSkip())
				Loop
			Endif

			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+SC6->C6_PRODUTO))

			If SB1->B1_TIPO == "FR"
				SC6->(dbSkip())
				Loop
			Endif

			If Alltrim(SC6->C6_PEDCLI) != Alltrim(SZ4->Z4_PEDIDO)
				SC6->(dbSkip())
				Loop
			Endif

			If SC6->C6_XRESIDU = 'N'
				SC6->(dbSkip())
				Loop
			Endif

			SC6->(RecLock("SC6",.F.))
			SC6->C6_BLQ     := "R"
			SC6->C6_XDTELIM := dDataBase
			SC6->C6_LOCALIZ := "PA0058"
			SC6->(MsUnLock())

			SC6->(dbSkip())
		EndDo
	Endif

Return


Static Function ZeraPed()

	SC6->(dbOrderNickName("INDSC61"))
	If SC6->(dbSeek(xFilial("SC6")+ SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + SZ4->Z4_PRODCLI + SZ4->Z4_PEDIDO))

		_cChavSC6 := SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + SC6->C6_PEDCLI
		While SC6->(!Eof()) .And. 	_cChavSC6 == SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + SC6->C6_PEDCLI

			If (SC6->C6_QTDVEN == SC6->C6_QTDENT) .Or. !Empty(SC6->C6_BLQ)
				SC6->(dbSkip())
				Loop
			Endif

			SC6->(RecLock("SC6",.F.))
			SC6->C6_IDENCAT := ""
			SC6->(MsUnlock())

			SC6->(dbSkip())
		EndDo
	Endif

Return



Static Function CR012C()

	Local oFwMsEx 		:= NIL
	Local cArq 			:= ""
	Local cWorkSheet	:= ""
	Local cTable 		:= ""
	Local _lEnt 		:= .F.

	oFwMsEx := FWMsExcel():New()

	TRB->(dbGotop())

	_lFirst := .T.

	While !TRB->(Eof())

		If _lFirst
			_lEnt    := .T.

			cWorkSheet 	:= 	"Inconsistencia CBL"
			cTable 		:= 	"Inconsistencia CBL"

			oFwMsEx:AddWorkSheet( cWorkSheet )
			oFwMsEx:AddTable( cWorkSheet, cTable )

			oFwMsEx:AddColumn( cWorkSheet, cTable , "Cliente"   		, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Loja"   			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto Cronnos"	, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto Cliente"	, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Pedido Cliente"   	, 1,1,.F.)

			_lFirst := .F.
		Endif

		oFwMsEx:AddRow( cWorkSheet, cTable,{;
			TRB->CLIENTE	,;
			TRB->LOJA    	,;
			TRB->PRODUTO   	,;
			TRB->PRODCLI    ,;
			TRB->PEDCLI    	})

		TRB->(dbSkip())
	EndDo

	TRB->(dbCloseArea())

	oFwMsEx:Activate()

	_cDat1    := GravaData(dDataBase,.f.,8)
	_cHor1    := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

	cArq := 'INCONSISTENCIA_CBL'+_cDat1+'_'+_cHor1 + ".xls"
	_cAnexo := "\WORKFLOW\RELATORIOS\"+cArq

	oFwMsEx:GetXMLFile( _cAnexo )

	If _lEnt
		CR012D() 	//Envia e-mail
	Endif

Return




Static Function CR012D()

	Private _lRet

	nOpcao := 0

	CONOUT("Enviando E-Mail de Inconsistencia - CBL")

	CONOUT('{'+ _cAnexo+'}')

	oProcess := TWFProcess():New( "Inconsistencia", "PO_CBL" )
	aCond    :={}
	_nTotal  := 0

	oProcess:NewTask( "INCONSISTENCIA_CBL", "\WORKFLOW\CR0012.HTM" )
	oProcess:bReturn  := ""
	oProcess:bTimeOut := ""

	oHTML := oProcess:oHTML

	oProcess:cSubject := "Inconsistencia Programação - CBL - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

	oProcess:fDesc := "Inconsistencia Programação - CBL"

	Private _cTo := _cCC := ""

	SZG->(dbsetOrder(1))
	SZG->(dbGotop())

	While SZG->(!EOF())

		If 'K1' $ SZG->ZG_ROTINA
			_cTo += If(Empty(_cTo),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
		ElseIf 'K2' $ SZG->ZG_ROTINA
			_cCC += If(Empty(_cCC),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
		Endif

		SZG->(dbSkip())
	Enddo

	oProcess:AttachFile(_cAnexo)

	oProcess:cTo := _cTo
	oProcess:cCC := _cCC

	oProcess:Start()

	oProcess:Finish()

Return
