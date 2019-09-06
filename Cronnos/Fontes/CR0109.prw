#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#include "TopConn.ch"


/*/
Funçao    	³ CR0109
Autor 		³ Fabiano da Silva
Data 		³ 10.09.18
Descricao 	³ Programacao de entrega John Deere(000063)
/*/

User Function CR0109(_aParam)

	Local _cq3 := ''

	If ValType(_aParam) <> 'U'
		PREPARE ENVIRONMENT EMPRESA _aParam[1] FILIAL _aParam[2]
	Endif

	Private _cAnexo
	Private _cJDeFold	:= GetMV("CR_JDEFOLD")
	PRIVATE _aCabec 	:= {}
	PRIVATE _aItens 	:= {}
	PRIVATE lMsErroAuto := .F.

	Private _lPrim,_cItem,_lAchou,_nPrcVen,_cNum, _cPedido

	Private _nTotQt  		:= 0

	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| CR109A(@_lFim) }
	Private _cTitulo01 := 'Processando'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

	_bAcao01   := {|_lFim| CR109B(@_lFim) }
	_cTitulo01 := 'Integrando os Pedidos...'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

	//	If !Empty(_aItens)
	//		CONOUT("Gerando Pedido de Vendas - John Deere - "+TIME())
	//		MSExecAuto({|x,y,z|mata410(x,y,z)},_aCabec,_aItens,3)
	//		If lMsErroAuto
	//			MostraErro()
	//		EndIf
	//	Endif

	_bAcao01   := {|_lFim| CR109C(@_lFim) }
	_cTitulo01 := 'Gerando relatório de inconsistências...'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

	_cq3  := " UPDATE "+RetSqlName("SC6")+" SET C6_BLQ = 'R', C6_XDTELIM = '"+DTOS(dDataBase)+"', C6_LOCALIZ = 'CR0109' "
	_cq3  += " WHERE D_E_L_E_T_ = '' AND C6_PEDAMOS IN ('Z','M','I') AND C6_QTDENT < C6_QTDVEN AND C6_CLI = '000063' "
	_cq3  += " AND C6_BLQ = '' AND C6_ENTREG < '"+DTOS(dDataBase)+"' "
	If SC6->(FieldPos("C6_XRESIDU")) > 0
		_cq3  += " AND C6_XRESIDU <> 'N' "
	Endif

	TCSQLEXEC(_cq3)

	CONOUT("Final da integração John Deere - CR0109 - "+TIME())

Return



Static Function CR109A(_lFim)

	Local _cCont     := ""
	Local _cUM       := ""
	Local _dDtMov    := Ctod("")
	Local _cCliente  := ""
	Local _cLoja     := ""
	Local _cSemAtu   := ""
	Local _cSemAtu2  := ""
	Local _dDtAtu    := Ctod("")
	Local _cSemAnt   := ""
	Local _cProdCli  := ""
	Local _cProdCron := ""
	Local _cLocDest  := ""
	Local _cContato  := ""
	Local _cTipo     := ""
	Local _cUltNf    := ""
	Local _cSerNf    := ""
	Local _dDtUltNf  := Ctod("")
	Local _dDtEnt    := Ctod("")
	Local _nQtEnt    := 0
	Local _aDtEnt    := {}
	Local _cPedido   := ""
	Local _cDesenho  := ""
	Local _dDt       := dDataBase - 20
	Local _cLine     := 0
	Local _nQt       := 0
	Local _cChavProg := ''
	Local aStru      := {}
	Local cArqLOG    := ''
	Local cIndLOG    := "INDICE+PRODUTO+PRODCLI"
	Local _lProx     := .F.
	Local _lExit     := .F.
	Local _lRelease  := .F.

	Pergunte("",.F.)

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


	ProcRegua(20)

	IncProc()
	_cDir := _cJDeFold+"Brasil\Entrada\*.TXT"

	_aArqTxt= ARRAY(ADIR(_cDir))
	ADIR(_cJDeFold+"Brasil\Entrada\*.TXT",_aArqTxt)

	For I:= 1 to Len(_aArqTxt)

		_lProx     := .F.
		_cArqBkp   := _cJDeFold+"Brasil\Entrada\Programacao\"+Alltrim(_aArqTxt[I])
		_cArq      := _cJDeFold+"Brasil\Entrada\"+Alltrim(_aArqTxt[i])

		_lExit     := .F.

		FT_FUSE( _cArq )
		FT_FGOTOP()

		While !FT_FEOF()

			_cLine := FT_FREADLN()

			If Len(_cLine) == 0
				_lExit := .T.
				Exit
			Endif

			If Substr(_cLine,1,3) == "ITP"
				If Subst(_cLine,4,3) <> '001'
					_lExit := .T.
					Exit
				Endif

				_cArqNew  := fCreate(Alltrim(_cArqBkp),0)

				_cCont   := Subst(_cLine,9,5)
				_dDTMov  := Stod("20"+Subst(_cLine,14,6))

				SA1->(dbSetOrder(3))
				If SA1->(msSeek(xFilial("SA1")+Subst(_cLine,26,14)))
					_cCliente := SA1->A1_COD
					_cLoja    := SA1->A1_LOJA
				Endif
			ElseIf Substr(_cLine,1,3) == "PE1"
				_nQt       := 0
				_lProx     := .T.
				_cLocDest  := Substr(_cLine,4,3)
				_cSemAtu   := Substr(_cLine,7,9)
				_cSemAtu2  := Substr(_cLine,7,9)
				_dDtAtu    := Stod("20"+Subst(_cLine,16,6))
				_cSemAnt   := Substr(_cLine,22,9)
				_cProdCli  := Substr(_cLine,37,15)
				_cPedido   := Substr(_cLine,97,12)
				_cProdCron := ""
				_cUm       := Substr(_cLine,125,2)

				_lGrava		:= .F.

				SZ2->(dbSetOrder(8))
				//				If SZ2->(msSeek(xFilial("SZ2")+_cCliente + _cLoja + Padr(_cProdCli,15) + Padr(_cPedido,20) + "1"))
				If SZ2->(msSeek(xFilial("SZ2")+_cCliente + _cLoja + Padr(_cProdCli,15) + Padr(_cPedido,20)))

					If Val(Alltrim(SZ2->Z2_RELEASE)) < Val(_cSemAtu)
						SZ2->(RecLock("SZ2",.F.))
						SZ2->Z2_RELEASE  := _cSemAtu
						SZ2->(MsUnlock())
						_lRelease := .T.
					Else
						_lRelease := .F.
					Endif

					If SZ2->Z2_ATIVO = '1'
						_cProdCron := SZ2->Z2_PRODUTO
					Else
						If !Empty(SZ2->Z2_PRODUTO)
							_lGrava		:= .T.
						Endif
					Endif

				Else
					_lGrava		:= .T.
				Endif

				If _lGrava .And. _lRelease

					If !Empty(_cCliente)
						SZ2->(RecLock("SZ2",.T.))
						SZ2->Z2_FILIAL	:= xFilial('SZ2')
						SZ2->Z2_CLIENTE	:= _cCliente
						SZ2->Z2_LOJA	:= _cLoja
						SZ2->Z2_CODCLI	:= Padr(_cProdCli,15)
						SZ2->Z2_PEDCLI	:= Padr(_cPedido,20)
						SZ2->Z2_UM		:= _cUm
						//					SZ2->Z2_DESCCLI	:= Alltrim(aLin[4])
						SZ2->Z2_ATIVO	:= "2"
						SZ2->Z2_TES		:= If(_cLoja = '05','512','511')
						SZ2->(MsUnlock())
					Else
						_lExit := .T.
					Endif

					TRB->(RecLock("TRB",.T.))
					TRB->INDICE  := "1"
					TRB->PRODCLI := _cProdCli
					TRB->CLIENTE := _cCliente
					TRB->LOJA    := _cLoja
					TRB->PEDCLI  := _cPedido
					TRB->(MsUnlock())
				Endif

				_cContato := Alltrim(Substr(_cLine,114,11))
				_cTipo    := Substr(_cLine,128,1)
			ElseIf Substr(_cLine,1,3) == "PE2" .And. _lRelease
				_cUltNf   := Substr(_cLine,10,6)
				_cSerNf   := Substr(_cLine,16,4)
				_dDtUltNf := Ctod(Subst(_cLine,24,2)+"/"+Subst(_cLine,22,2)+"/20"+Subst(_cLine,20,2))
			ElseIf Substr(_cLine,1,3) == "PE3" .And. _lRelease
				_nQt   := 12
				_nQtAb := 4

				_aQuant := {}
				For A:= 1 to 7
					_nQtEnt := Val(Substr(_cLine,_nQt,9))/100

					_dDtFech := Ctod(Subst(_cLine,_nQtAb+4,2)+"/"+Subst(_cLine,_nQtAb+2,2)+"/20"+Subst(_cLine,_nQtAb,2))

					AADD(_aQuant,{_nQtEnt,_dDtFech})
					_nQt   += 17
					_nQtAb += 17
				Next A
			ElseIf Substr(_cLine,1,3) == "PE5" .And. _lRelease

				_nQtDt := 4

				_aDtEnt := {}
				For A:= 1 to 7
					_dDtEnt := Ctod(Subst(_cLine,_nQtDt+4,2)+"/"+Subst(_cLine,_nQtDt+2,2)+"/20"+Subst(_cLine,_nQtDt,2))
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
					If SZ4->(msSeek(xFilial("SZ4")+Dtos(dDataBase)+ _cCliente + _cLoja + _cProdCron))
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

					If _aQuant[B,1] > 0
						If !Empty(_cProdCron)
							SZ4->(dbSetOrder(4))
							If SZ4->(msSeek(xFilial("SZ4")+Dtos(dDataBase)+ _cCliente + _cLoja + _cProdCron +Dtos(_aDTEnt[B,1]) ))
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

						_cTpPed    := Substr(_cLine,_nPed,1)

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
						SZ4->Z4_ALTTEC  := _cSemAtu
						SZ4->Z4_INTEGR  := 'N'
						SZ4->(MsUnlock())
					Endif
				Next B

				_cSemAtu2 := ""
			ElseIf Substr(_cLine,1,3) == "PE6" .And. _lRelease
				//				_cDesenho := Substr(_cLine,14,4)
				//				If SZ4->(msSeek(xFilial("SZ4") + _cCont + _cCliente + _cLoja + _cProdCli))
				//					_cChavSZ4 :=  SZ4->Z4_CONTROL + SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODCLI
				//					While SZ4->(!Eof()) .And.  _cChavSZ4 ==  SZ4->Z4_CONTROL + SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODCLI
				//						SZ4->(RecLock("SZ4",.F.))
				//						SZ4->Z4_ALTTEC  := _cDesenho
				//						SZ4->(MsUnlock())
				//
				//						SZ4->(dbSkip())
				//					EndDo
				//				Endif

			ElseIf Substr(_cLine,1,3) == "PE4" .And. _lRelease
				/*				_cCaixa := Alltrim(Substr(_cLine,34,30))
				_cQtCai := Val(Substr(_cLine,64,12))/1000

				SZ2->(dbSetOrder(4))
				If SZ2->(msSeek(xFilial('SZ2')+Left(_cCaixa+Space(15),15)+_cCliente))

				_cCodCai := SZ2->Z2_PRODUTO

				SZ2->(dbSetOrder(8))
				If SZ2->(msSeek(xFilial("SZ2")+_cCliente + _cLoja + _cProdCli+Left(_cPedido+Space(20),20)+"1"))

				SZ2->(RecLock('SZ2',.F.))
				SZ2->Z2_CODEMB	:= _cCodCai
				SZ2->Z2_QTPEMB	:= _cQtCai
				SZ2->(MsUnlock())
				Endif
				Endif*/
			Endif

			FWrite(_cArqNew,(_cLine+CRLF))

			FT_FSkip()
		EndDo

		FT_FUSE()

		If File(_cArq) .And. !_lExit
			FErase(_cArq)
		Endif
	Next I

Return



Static Function CR109B(_lFim)

	Local dDataRef	:= ctod('')
	Local nValor	:= 0
	Local i			:= 0

	Private _lPrim,_cItem,_lAchou,_nPrcVen,_cNum,_cPedido
	Private _nTotQt		:= 0

	Private _lNAchou	:= .F.
	_lFim				:= .F.

	_lNAchou := .F.

	_cQuery  := "UPDATE "+RetSqlName("SD2")+" SET D2_PROGENT = 0 WHERE D2_CLIENTE = '000063' "

	TCSQLEXEC(_cQuery)


	_cq  := " SELECT R_E_C_N_O_ AS Z4RECNO,* FROM "+RetSqlName("SZ4")+" Z4 "
	_cq  += " WHERE Z4.D_E_L_E_T_= '' AND Z4_CODCLI = '000063' "
	_cq  += " AND Z4_INTEGR = 'N' AND Z4_DTDIGIT = '"+dTos(dDatabase)+"' "
	_cq  += " ORDER BY Z4_CODCLI,Z4_LOJA,Z4_PRODCLI,Z4_PEDIDO,Z4_ALTENG,Z4_ALTTEC,Z4_DTENT "

	TCQUERY _cq NEW ALIAS "TSZ4"

	TCSETFIELD("TSZ4","Z4_DTDIGIT","D")
	TCSETFIELD("TSZ4","Z4_DTENT","D")
	TCSETFIELD("TSZ4","Z4_DTFECH","D")
	TCSETFIELD("TSZ4","Z4_DTULTNF","D")

	TSZ4->(dbGotop())

	While !TSZ4->(EOF())

		_lPrim     := .F.
		_nTotQt    := 0
		_cItem     := "00"
		_cClieLoja := TSZ4->Z4_CODCLI + TSZ4->Z4_LOJA

		While !TSZ4->(Eof()) .And. _cClieLoja == TSZ4->Z4_CODCLI + TSZ4->Z4_LOJA 

			IncProc()

			_cProdCli := TSZ4->Z4_PRODCLI

			SZ2->(dbSetOrder(8))
			If !SZ2->(msSeek(xFilial("SZ2")+TSZ4->Z4_CODCLI + TSZ4->Z4_LOJA + TSZ4->Z4_PRODCLI+TSZ4->Z4_PEDIDO+"1"))
				TRB->(RecLock("TRB",.T.))
				TRB->INDICE  := "2"
				TRB->PRODCLI := _cProdCli
				TRB->PRODUTO := TSZ4->Z4_PRODPAS
				TRB->CLIENTE := TSZ4->Z4_CODCLI
				TRB->LOJA    := TSZ4->Z4_LOJA
				TRB->PEDCLI  := TSZ4->Z4_PEDIDO
				TRB->(MsUnlock())

				TSZ4->(dbSkip())
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
			SB1->(msSeek(xFilial("SB1")+TSZ4->Z4_PRODPAS))

			//				_cZeraPed := " UPDATE "+RetSQLName("SC6")+" " +CRLF
			//				_cZeraPed += " SET C6_IDENCAT = '' " +CRLF
			//				_cZeraPed += " WHERE D_E_L_E_T_ = '' AND C6_FILIAL = '"+xFilial("SC6")+"' " +CRLF
			//				_cZeraPed += " AND C6_CLI		= '"+TSZ4->Z4_CODCLI+"' " +CRLF
			//				_cZeraPed += " AND C6_LOJA		= '"+TSZ4->Z4_LOJA+"' " +CRLF
			//				_cZeraPed += " AND C6_PRODUTO	= '"+TSZ4->Z4_PRODPAS+"' " +CRLF
			//				_cZeraPed += " AND C6_CPROCLI	= '"+TSZ4->Z4_PRODCLI+"' " +CRLF
			//				_cZeraPed += " AND C6_PEDCLI	= '"+TSZ4->Z4_PEDIDO+"' " +CRLF
			//				_cZeraPed += " AND C6_QTDVEN > C6_QTDENT " +CRLF
			//				_cZeraPed += " AND C6_BLQ = '' " +CRLF
			//
			//				TCSQLEXEC(_cZeraPed)


			_cElimRes := " UPDATE "+RetSqlName("SC6")+" SET C6_BLQ = 'R', C6_XDTELIM = '"+DTOS(dDataBase)+"', C6_LOCALIZ = 'CR0109' "+CRLF
			_cElimRes += " WHERE D_E_L_E_T_ = '' AND C6_FILIAL = '"+xFilial("SC6")+"' " +CRLF
			_cElimRes += " AND C6_CLI		= '"+TSZ4->Z4_CODCLI+"' " +CRLF
			_cElimRes += " AND C6_LOJA		= '"+TSZ4->Z4_LOJA+"' " +CRLF
			_cElimRes += " AND C6_PRODUTO	= '"+TSZ4->Z4_PRODPAS+"' " +CRLF
			_cElimRes += " AND C6_CPROCLI	= '"+TSZ4->Z4_PRODCLI+"' " +CRLF
			_cElimRes += " AND C6_PEDCLI	= '"+TSZ4->Z4_PEDIDO+"' " +CRLF
			//				_cElimRes += " AND C6_IDENCAT <> '"+TSZ4->Z4_SEMATU+"' " +CRLF
			_cElimRes += " AND C6_QTDVEN > C6_QTDENT " +CRLF
			_cElimRes += " AND C6_XRESIDU <> 'N' " +CRLF
			_cElimRes += " AND C6_BLQ = '' " +CRLF
			_cElimRes += " AND C6_PEDAMOS IN ('N','Z','M','I')" +CRLF
			//				_cElimRes += " AND C6_LA <> 'OK' " +CRLF

			TCSQLEXEC(_cElimRes)

			_nPrcVen := Round(nValor,5)

			While TSZ4->(!Eof()) .And. _cClieLoja == TSZ4->Z4_CODCLI + TSZ4->Z4_LOJA .And. _cProdCli == TSZ4->Z4_PRODCLI

				If _lFim
					Alert("Cancelado Pelo Usuario!!!!!!")
					Return
				Endif

				INTSC6C()

				//					TSZ4->(RecLock("SZ4",.F.))
				//					TSZ4->Z4_INTEGR := "S"
				//					TSZ4->Z4_IMPRES := "S"
				//					TSZ4->(MsUnlock())

				_cUPDZ4 := " UPDATE "+RetSqlName("SZ4")+" SET Z4_INTEGR = 'S' " +CRLF
				_cUPDZ4 += " WHERE R_E_C_N_O_ = "+CVALTOCHAR(TSZ4->Z4RECNO)+" " +CRLF

				TCSQLEXEC(_cUPDZ4)

				TSZ4->(dbSkip())
			EndDo
		EndDo

		If !Empty(_aItens)

			_Area := GetArea()

			lMsErroAuto := .F.

			MSExecAuto({|x,y,z|mata410(x,y,z)},_aCabec,_aItens,3)

			If lMsErroAuto
				MostraErro()
			EndIf

			RestArea(_Area)

		Endif

		_cItem  = '00'

		_aCabec 	:= {}
		_aItens 	:= {}
		lMsErroAuto := .F.
		
	EndDo

Return(Nil)



Static Function IntSC6C()

	_nFatur := 0

	_cNF := TSZ4->Z4_ULTNF
	_lOk := .F.
	SF2->(dbSetOrder(1))
	If SF2->(msSeek(xFilial("SF2")+TSZ4->Z4_ULTNF+TSZ4->Z4_SERIE))
		_cNF := TSZ4->Z4_ULTNF
		_lOk := .T.
	Endif

	If !_lOk
		SF2->(dbSetOrder(1))
		If SF2->(msSeek(xFilial("SF2")+Substr(TSZ4->Z4_ULTNF,4,6)+"   "+TSZ4->Z4_SERIE))
			_cNF := Substr(TSZ4->Z4_ULTNF,4,6)+"   "
		Endif
	Endif

	If VAL(_cNF) > 0
		_cUltNf := _cNF + "01"
	Else
		_cUltNf := "000000001"
	Endif

	SD2->(dbOrderNickName("INDSD23"))
	SD2->(msSeek(xFilial("SD2")+ TSZ4->Z4_CODCLI + TSZ4->Z4_LOJA + TSZ4->Z4_PRODPAS + TSZ4->Z4_SERIE + _cUltNf,.T.))

	_cChav  := TSZ4->Z4_CODCLI + TSZ4->Z4_LOJA + TSZ4->Z4_PRODPAS

	While SD2->(!Eof()) .And. _cChav == SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD

		If SD2->D2_DOC <= _cNF .And. SD2->D2_EMISSAO <= TSZ4->Z4_DTULTNF
			SD2->(dbSkip())
			Loop
		Endif

		If SD2->D2_EMISSAO < TSZ4->Z4_DTULTNF
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
		If SC6->(msSeek(xFilial("SC6")+SD2->D2_PEDIDO + SD2->D2_ITEMPV))
			If Alltrim(SC6->C6_PEDCLI) != Alltrim(TSZ4->Z4_PEDIDO)
				SD2->(dbSkip())
				Loop
			Endif
		Endif

		_nFatur2 := _nFatur
		_nFatur  += SD2->D2_QUANT - SD2->D2_PROGENT

		If _nFatur >= TSZ4->Z4_QTENT
			_nDif  := TSZ4->Z4_QTENT - _nFatur2
		Else
			_nDif  := SD2->D2_QUANT - SD2->D2_PROGENT
		Endif

		SD2->(RecLock("SD2",.F.))
		SD2->D2_PROGENT += _nDif
		SD2->(MsUnlock())

		If _nFatur >= TSZ4->Z4_QTENT
			Return
		Endif

		SD2->(dbSkip())
	EndDo

	/*	_lAchou   := .F.

	SC6->(dbOrderNickName("INDSC61"))
	If SC6->(msSeek(xFilial("SC6")+ TSZ4->Z4_CODCLI + TSZ4->Z4_LOJA + TSZ4->Z4_PRODPAS + TSZ4->Z4_PRODCLI + TSZ4->Z4_PEDIDO + DTOS(TSZ4->Z4_DTENT)))

	_cChavSC62 := SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + SC6->C6_PEDCLI + DTOS(SC6->C6_ENTREG)

	While SC6->(!Eof()) .And. 	_cChavSC62 == SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + SC6->C6_PEDCLI +DTOS(SC6->C6_ENTREG)

	If (SC6->C6_QTDVEN == SC6->C6_QTDENT) .Or. !Empty(SC6->C6_BLQ)
	SC6->(dbSkip())
	Loop
	Endif

	If (SC6->C6_QTDVEN - SC6->C6_QTDENT) != TSZ4->Z4_QTENT - _nFatur
	SC6->(dbSkip())
	Loop
	Endif

	SC6->(RecLock("SC6",.F.))
	SC6->C6_IDENCAT := TSZ4->Z4_SEMATU
	If TSZ4->Z4_TPPED = "1"
	SC6->C6_PEDAMOS := "N"
	Endif
	SC6->(MsUnlock())

	_lAchou := .T.

	SC6->(dbSkip())
	EndDo
	Endif
	*/
	//	If !_lAchou
	Dadospedido()
	//	Endif

Return




Static Function DadosPedido()

	Local _aLinha

	_cItem 	:= SomaIt(_cItem)

	If _cItem  = 'Z0'

		//		MATA410(_aCabec,_aItens,3)

		lMsErroAuto := .F.

		MSExecAuto({|x,y,z|mata410(x,y,z)},_aCabec,_aItens,3)
		If lMsErroAuto
			MostraErro()
		EndIf

		_cItem  = '01'

		_aCabec 	:= {}
		_aItens 	:= {}
		lMsErroAuto := .F.
	Endif

	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+TSZ4->Z4_CODCLI+TSZ4->Z4_LOJA))

	If _cItem = '01'
		_cNum := GetSxeNum("SC5","C5_NUM")

		RollBAckSx8()

		aadd(_aCabec,{"C5_NUM"     	, _cNum				,Nil})
		aadd(_aCabec,{"C5_TIPO"    	, "N"				,Nil})
		aadd(_aCabec,{"C5_CLIENTE"	, TSZ4->Z4_CODCLI	,Nil})
		aadd(_aCabec,{"C5_CLIENT"  	, TSZ4->Z4_CODCLI	,Nil})
		aadd(_aCabec,{"C5_LOJAENT" 	, TSZ4->Z4_LOJA		,Nil})
		aadd(_aCabec,{"C5_LOJACLI" 	, TSZ4->Z4_LOJA		,Nil})
		aadd(_aCabec,{"C5_TRANSP"  	, SA1->A1_TRANSP	,Nil})
		aadd(_aCabec,{"C5_TIPOCLI" 	, SA1->A1_TIPO		,Nil})
		aadd(_aCabec,{"C5_CONDPAG" 	, SA1->A1_COND		,Nil})
		aadd(_aCabec,{"C5_TIPLIB"  	, "1"				,Nil})
		aadd(_aCabec,{"C5_VEND1"   	, SA1->A1_VEND		,Nil})
		aadd(_aCabec,{"C5_COMIS1"  	, SA1->A1_COMIS		,Nil})
		aadd(_aCabec,{"C5_EMISSAO" 	, dDataBase			,Nil})
		aadd(_aCabec,{"C5_PESOL"   	, 1					,Nil})
		aadd(_aCabec,{"C5_MOEDA"   	, 1					,Nil})
		aadd(_aCabec,{"C5_TXMOEDA" 	, 1					,Nil})
		aadd(_aCabec,{"C5_TPCARGA" 	, "2"				,Nil})
	Endif

	SF4->(dbSetOrder(1))
	SF4->(msSeek(xFilial("SF4")+SZ2->Z2_TES))

	SB1->(dbSetOrder(1))
	SB1->(msSeek(xFilial("SB1")+TSZ4->Z4_PRODPAS))

	_aLinha := {}
	//	aadd(_aLinha,{"C6_NUM"     , _cNUm						,Nil})
	aadd(_aLinha,{"C6_ITEM"    , _cItem						,Nil})
	aadd(_aLinha,{"C6_CPROCLI" , Alltrim(TSZ4->Z4_PRODCLI)	,Nil})
	aadd(_aLinha,{"C6_PRODUTO" , TSZ4->Z4_PRODPAS			,Nil})
	aadd(_aLinha,{"C6_REVPED"  , TSZ4->Z4_ALTTEC				,Nil})
	aadd(_aLinha,{"C6_QTDVEN"  , TSZ4->Z4_QTENT - _nFatur	,Nil})
	aadd(_aLinha,{"C6_PRCVEN"  , _nPrcVen					,Nil})
	aadd(_aLinha,{"C6_VALOR"   , Round(( (TSZ4->Z4_QTENT - _nFatur) * _nPrcVen ),2)		,Nil})
	aadd(_aLinha,{"C6_ENTREG"  , TSZ4->Z4_DTENT				,Nil})
	aadd(_aLinha,{"C6_YDTFECH" , TSZ4->Z4_DTFECH				,Nil})
	If TSZ4->Z4_TPPED == "1"
		aadd(_aLinha,{"C6_PEDAMOS" , "N"					,Nil})
	ElseIf TSZ4->Z4_TPPED == "2"
		aadd(_aLinha,{"C6_PEDAMOS" , "I"					,Nil})
	ElseIf TSZ4->Z4_TPPED == "3"
		aadd(_aLinha,{"C6_PEDAMOS" , "M"					,Nil})
	ElseIf TSZ4->Z4_TPPED == "4"
		aadd(_aLinha,{"C6_PEDAMOS" , "Z"					,Nil})
	Endif
	If TSZ4->Z4_TIPO == "A"
		aadd(_aLinha,{"C6_PEDAMOS" , "A"					,Nil})
	Endif

	aadd(_aLinha,{"C6_TES"     , SZ2->Z2_TES				,Nil})

	If SA1->A1_EST == "SP"
		_cCf        := "5"
	ElseIf SA1->A1_EST == "EX"
		_cCf        := "7"
	Else
		_cCF        := "6"
	Endif
	aadd(_aLinha,{"C6_CF"      , _cCf + Substr(SF4->F4_CF,2,3)		,Nil})
	aadd(_aLinha,{"C6_UM"      , SB1->B1_UM				,Nil})
	aadd(_aLinha,{"C6_PEDCLI"  , TSZ4->Z4_PEDIDO			,Nil})
	aadd(_aLinha,{"C6_POLINE"  , "1"					,Nil})
	aadd(_aLinha,{"C6_DESCRI"  , SB1->B1_DESC			,Nil})
	aadd(_aLinha,{"C6_LOCAL"   , SB1->B1_LOCPAD			,Nil})
	aadd(_aLinha,{"C6_CLI"     , TSZ4->Z4_CODCLI			,Nil})
	aadd(_aLinha,{"C6_LOJA"    , TSZ4->Z4_LOJA			,Nil})
	aadd(_aLinha,{"C6_PRUNIT"  , _nPrcVen				,Nil})
	aadd(_aLinha,{"C6_TPOP"    , "F"					,Nil})
	aadd(_aLinha,{"C6_IDENCAT" , TSZ4->Z4_SEMATU			,Nil})
	aadd(_aLinha,{"C6_LA" 		, "OK"					,Nil})
	aadd(_aLinha,{"C6_CLASFIS" , SUBSTR(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB		,Nil})
	aadd(_aLinha,{"C6_LOCDEST" , TSZ4->Z4_LOCDEST			,Nil})
	SA3->(dbSetOrder(1))
	If SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND))
		aadd(_aLinha,{"C6_COMIS1"   , SA3->A3_COMIS		,Nil})
	Endif

	aadd(_aItens,_aLinha)

Return(Nil)





Static Function CR109C()

	Local oFwMsEx 		:= NIL
	Local _cArqExcel	:= ""
	Local cWorkSheet	:= ""
	Local cTable 		:= ""
	Local _lEnt 		:= .F.

	oFwMsEx := FWMsExcel():New()

	TRB->(dbGotop())

	_lFirst := .T.

	While !TRB->(Eof())

		If _lFirst
			_lEnt    := .T.

			cWorkSheet 	:= 	"Inconsistencia John Deere"
			cTable 		:= 	"Inconsistencia John Deere"

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

	_cArqExcel := 'INCONSISTENCIA_John_Deere_'+_cDat1+'_'+_cHor1 + ".xls"
	_cAnexo := "\WORKFLOW\RELATORIOS\"+_cArqExcel

	oFwMsEx:GetXMLFile( _cAnexo )

	If _lEnt
		CR109D() 	//Envia e-mail
	Endif

Return




Static Function CR109D()

	Local _oProcess := Nil

	CONOUT("Enviando E-Mail de Inconsistencia - John Deere - "+TIME())

	CONOUT('{'+ _cAnexo+'}')

	_oProcess := TWFProcess():New( "Inconsistencia", "PO_John Deere" )

	_oProcess:NewTask( "INCONSISTENCIA_John_Deere", "\WORKFLOW\CR0109.HTM" )
	_oProcess:bReturn  := ""
	_oProcess:bTimeOut := ""
	_oHTML := _oProcess:oHTML

	_oProcess:cSubject := "Inconsistencia Programação - John Deere - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

	_oProcess:fDesc := "Inconsistencia Programação - John Deere"

	Private _cTo := _cCC := ""

	SZG->(dbsetOrder(1))
	SZG->(dbGotop())

	While SZG->(!EOF())

		If 'S1' $ SZG->ZG_ROTINA
			_cTo += If(Empty(_cTo),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
		ElseIf 'S2' $ SZG->ZG_ROTINA
			_cCC += If(Empty(_cCC),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
		Endif

		SZG->(dbSkip())
	Enddo

	_oProcess:AttachFile(_cAnexo)

	//	_oProcess:cTo := 'fabiano.silva@cronnos.com.br'
	_oProcess:cTo := _cTo
	_oProcess:cCC := _cCC

	_oProcess:Start()

	_oProcess:Finish()

Return