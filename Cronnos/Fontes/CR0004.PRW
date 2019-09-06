#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CR0004    º                             Data ³  08/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Consulta Faturamento                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CR0004()


	LOCAL aAlias      :={},cSavRegua
	Private _lAchou   := .F.
	Private _cCliente := ""
	Private _cLoja    := ""

	PRIVATE aRotina := { {"Pesquisar","AxPesqui", 0 , 1},;
		{"Consulta","U_CR004A()", 0 , 2} }

	cCadastro := OemToAnsi("Consulta Geral do Faturamento")

	mBrowse( 6, 1,22,75,"SZ2")

	dbSelectArea("SZ2")
	dbSetOrder(1)

Return .T.


User Function CR004A()

	If !Pergunte("CR0004",.T.)
		Return
	Endif

	Private _aCampos, _cNomArq

	_aAliOri := GetArea()
	_aAliSC5 := SC5->(GetArea())
	_aAliSC6 := SC6->(GetArea())
	_aAliSF4 := SF4->(GetArea())
	_aAliSD2 := SD2->(GetArea())


	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.

	SA1->(dbsetOrder(1))
	SA1->(msSeek(xFilial("SA1")+SZ2->Z2_CLIENTE+SZ2->Z2_LOJA))

	If SA1->A1_XCONTPO = 'S'
//	If SZ2->Z2_CLIENTE $ "000017|000018|000021|000025"
		Private _bAcao01   := {|_lFim| RunProc(@_lFim) }
	Else
		Private _bAcao01   := {|_lFim| RunProc1(@_lFim) }
	Endif
	Private _cTitulo01 := 'Processando'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

	If _lAchou
		MontaBrow()
	Else
		MsgBox("Nao Existe Informacoes Para Essa Consulta ","ERRO!!!","STOP")
	Endif

	dbSelectArea("TRB")
	dbCloseArea("TRB")

	RestArea(_aAliSF4)
	RestArea(_aAliSC5)
	RestArea(_aAliSC6)
	RestArea(_aAliSD2)
	RestArea(_aAliOri)

Return


Static Function RunProc(_lFim)  // Para utilizar com os Clientes que não mudam o Pedido cliente como a Caterpillar Exportação

	Private _nTam := 110
	Private _cFimBloc:= CHR(192)+Repli(CHR(196),(_nTam-2))+CHR(217)
	Private _cBrancBl:= "³"+Repli(" ",(_nTam-2))+"³"

	_aCampos := {}
	AADD(_aCampos,{"LINHA","C",120,0 } )

	_cNomArq := CriaTrab(_aCampos)
	USE &_cNomArq Alias TRB ExClusive NEW VIA __LocalDriver

	Private _cCliente := SZ2->Z2_CLIENTE
	Private _cLoja    := SZ2->Z2_LOJA
	Private _cProd    := SZ2->Z2_PRODUTO
	Private _cProdCli := SZ2->Z2_CODCLI
	Private _cPedCli  := SZ2->Z2_PEDCLI

	_lAchou  := .F.

	dbSelectArea("SC6")
	dbOrderNickname("INDSC61")
	If dbSeek(xFilial("SC6")+ _cCliente + _cLoja + _cProd + _cProdCli + _cPedCli)

		_lAchou := .T.
		_cChavSC6 :=  SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_PRODUTO+SC6->C6_CPROCLI+SC6->C6_PEDCLI

		_cString:= "Movimentos em Aberto: "
		U_CR004B(CHR(218)+_cString+Repli(CHR(196),((_nTam-2)-Len(_cString)))+CHR(191),Alias())
		U_CR004B("³"+Space((_nTam-2))+"³")

		_cString:= "Pedido de Venda"
		U_CR004B(CHR(218)+_cString+Repli(CHR(196),((_nTam-2)-Len(_cString)))+CHR(191),Alias())
		U_CR004B("³"+Space((_nTam-2))+"³")

	/*
	³Produto         Pedido It Emissao  Entrega     Qtde.Pedido  Qtde.Entregue          Saldo
	999999999999999	999999 99 99999999 99999999 99999999999999 99999999999999 99999999999999
	0               16     23 26       35       44             59             74
	*/
		_cString:= "³Produto         Pedido It Emissao  Entrega     Tipo Qtde.Pedido  Qtde.Entregue        Saldo     Ped.Cliente       Release³"
		U_CR004B(CHR(218)+_cString+Repli(CHR(196),((_nTam-2)-Len(_cString)))+CHR(191),Alias())
		U_CR004B("³"+Space((_nTam-2))+"³")

		_nQtdeTot  := 0
		_nSaldotot := 0

		dbSelectArea("SC6")
		_nRec      := LastRec()
		ProcRegua(_nRec)

		While !Eof() .And. _cChavSC6 ==  SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_PRODUTO+SC6->C6_CPROCLI+SC6->C6_PEDCLI

			IncProc("Selecionando os Pedidos em Aberto")

			If _lFim
				Alert("cancelado pelo Operador!!")
				Return
			EndIf

			_dEmissao := CTOD("  /  /  ")
			dbSelectArea("SC5")
			dbSetOrder(1)
			If dbSeek(SC6->C6_FILIAL+SC6->C6_NUM)
				_dEmissao := SC5->C5_EMISSAO
			Endif

			If  (SC6->C6_QTDVEN == SC6->C6_QTDENT)  .Or. Alltrim(SC6->C6_BLQ) == "R"
				dbSelectarea("SC6")
				dbSkip()
				Loop
			Endif

			If MV_PAR03 == 2
				dbSelectArea("SF4")
				dbSetOrder(1)
				If dbSeek(xFilial("SF4")+SC6->C6_TES)
					If SF4->F4_TPNFISC == "S"
						dbSelectarea("SC6")
						dbSkip()
						Loop
					Endif
				Endif
			Endif
			_nSaldoTot := _nSaldoTot +  (SC6->C6_QTDVEN - SC6->C6_QTDENT)
			_nQtdeTot  := _nQtdeTot  + SC6->C6_QTDVEN
			_cPedCli   := SC6->C6_PEDCLI
			_cRevPed   := SC6->C6_REVPED

			EE9->(dbSetOrder(1))
			If EE9->(dbSeek(xFilial("EE9")+SC6->C6_NUM+Space(14)+Str(Val(SC6->C6_ITEM),6) ))
				_cPedCli := EE9->EE9_REFCLI
			Endif

			_cString := "³ "+SC6->C6_CPROCLI+" "+SC6->C6_NUM+" "+SC6->C6_ITEM+" "+DTOC(_dEmissao)+" "+;
				DTOC(SC6->C6_ENTREG)+" "+SC6->C6_PEDAMOS+" "+TRANSFORM(SC6->C6_QTDVEN,"@E 999,999,999.99")+" "+;
				TRANSFORM(SC6->C6_QTDENT,"@E 999,999,999.99")+" "+TRANSFORM(SC6->C6_QTDVEN - SC6->C6_QTDENT,"@E 999,999,999.99")+"        "+Alltrim(_cPedCli)+"     "+_cRevPed
			_cString += Space( ( ( _nTam-Len(_cString) ) - 1 ) )+"³"
			U_CR004B(_cString,Alias())

			dbSelectArea("SC6")
			dbSkip()
		EndDo
		U_CR004B(_cFimBloc,Alias())
		U_CR004B("³"+Space((_nTam-2))+"³")

		_cString:= "³Qtde.Total : "+Transform(_nQtdeTot,"@E 999,999,999.99")+" Saldo Total : "+Transform(_nSaldoTot,"@E 999,999,999.99")
		_cString += Space( ( ( _nTam-Len(_cString) ) - 1 ) )+"³"
		U_CR004B(_cString,Alias())
		U_CR004B("³"+Space((_nTam-2))+"³")
	Endif

	_nQtdeNf := 0
	_nValNf  := 0
	_lEnt    := .F.

	dbSelectArea("SD2")
	dbOrderNickname("INDSD21")
	dbSeek(xFilial("SD2")+ _cCliente + _cLoja + _cProd + _cProdCli + _cPedCli + Dtos(MV_PAR01),.T.)

	_cChavSD2 :=  SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SD2->D2_PROCLI+SD2->D2_PEDCLI

	If _cChavSD2 == _cCliente + _cLoja + _cProd + _cProdCli + _cPedCli

		_cString:= "³Lancamentos de Saida: ³"
		U_CR004B(CHR(218)+_cString+Repli(CHR(196),((_nTam-2)-Len(_cString)))+CHR(191),Alias())
		U_CR004B("³"+Space((_nTam-2))+"³")

	/*
	³Tp N.Fisc Ser Emissao   Qtde.Entregue    Valor Total³
	99 999999 999 99999999 99999999999999 99999999999999
	0  3      10  14       23             38
	*/
		_cString:= "³Tp N.Fisc Ser Emissao   Qtde.Entregue    Valor Total   Numero Invoice    Ped.Cliente      Release      Dt. Saída  Via³"
		U_CR004B(CHR(218)+_cString+Repli(CHR(196),((_nTam-2)-Len(_cString)))+CHR(191),Alias())
		U_CR004B("³"+Space((_nTam-2))+"³")

		_lAchou := .T.
		dbSelectArea("SD2")
		_nRec := LastRec()
		ProcRegua(_nRec)

		While !Eof().And. (_cChavSD2 ==  SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SD2->D2_PROCLI+SD2->D2_PEDCLI) .And. SD2->D2_EMISSAO <= MV_PAR02

			IncProc("Selecionando as N.Fiscais de Venda")

			If _lFim
				Alert("cancelado pelo Operador!!")
				Return
			EndIf


			If MV_PAR03 == 2
				dbSelectArea("SF4")
				dbSetOrder(1)
				If dbSeek(xFilial("SF4")+SD2->D2_TES)
					If SF4->F4_TPNFISC == "S"
						dbSelectarea("SD2")
						dbSkip()
						Loop
					Endif
				Endif
			Endif
			_nQtdeNf   := _nQtdeNf +  SD2->D2_QUANT
			_nValNF    := _nValNf  +  SD2->D2_TOTAL

			_cPedCli   := SD2->D2_PEDCLI
			_cRevPed2  := SD2->D2_REVPED

			EE9->(dbSetOrder(1))
			If EE9->(dbSeek(xFilial("EE9")+SD2->D2_PEDIDO+Space(14)+Str(Val(SD2->D2_ITEMPV),6) ))
				_cPedCli := EE9->EE9_REFCLI
			Endif

			_cVia := ""
			_dSaida := ctod("  /  /  ")

			EEC->(dbSetOrder(1))
			If EEC->(dbSeek(xFilial("EEC")+SD2->D2_PREEMB))
				_cVia   := EEC->EEC_VIA
				_dSaida := EEC->EEC_DTEMBA
			Endif


			If SD2->D2_CLIENTE = "000017"
				If SF2->(dbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE))
					_dSaida := SF2->F2_DTENTR
				Endif
			Endif

			_cString :="³ "+SD2->D2_TIPO+" "+SD2->D2_DOC+" "+SD2->D2_SERIE+" "+DTOC(SD2->D2_EMISSAO)+" "+TRANSFORM(SD2->D2_QUANT,"@E 999,999,999.99")+" "+TRANSFORM(SD2->D2_TOTAL,"@E 999,999,999.99")+" "+SD2->D2_PREEMB+" "+Alltrim(_cPedCli)+"   "+_cRevPed2+" "+DTOC(_dSaida)+" "+_cVia
			_cString += Space( ( ( _nTam-Len(_cString) ) - 1 ) )+"³"
			U_CR004B(_cString,Alias())

			_lEnt    := .T.

			dbSelectArea("SD2")
			dbSkip()
		EndDo

	Endif

	_cQuery := " SELECT * FROM "+RETSQLNAME("SD1")+" D1 "
	_cQuery += " WHERE D1.D_E_L_E_T_ = '' "
	_cQuery += " AND D1_TIPO = 'D' AND D1_NFORI <> '' "
	_cQuery += " AND D1_FORNECE+D1_LOJA+D1_COD = '"+_cCliente + _cLoja + _cProd+"' "
	_cQuery += " AND D1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	_cQuery += " ORDER BY D1_DOC "

	TCQUERY _cQuery NEW ALIAS "ZZ"

	TCSETFIELD("ZZ","D1_EMISSAO","D")

	dbSelectArea("ZZ")
	dbGotop()

	While ZZ->(!EOF())

		SD2->(dbsetOrder(3))
		If SD2->(dbSeeK(xFilial("SD2")+ZZ->D1_NFORI+ZZ->D1_SERIORI+ZZ->D1_FORNECE+ZZ->D1_LOJA+ZZ->D1_COD+ZZ->D1_ITEMORI))

			If SD2->D2_PEDCLI != _cPedCli
				ZZ->(dbSkip())
				Loop
			Endif

			_cRevPed2  := SD2->D2_REVPED
			_nQtde    := ZZ->D1_QUANT * -1
			_nTot     := ZZ->D1_TOTAL * -1

			_nQtdeNf   := _nQtdeNf + _nQtde
			_nValNF    := _nValNf  +  _nTot

			_cString :="³ "+ZZ->D1_TIPO+ " "+ZZ->D1_DOC+ " "+ZZ->D1_SERIE+ " "+DTOC(ZZ->D1_EMISSAO)+ " "+TRANSFORM(_nQtde,"@E 999,999,999.99")+       " "+TRANSFORM(_nTot,"@E 999,999,999.99")+" (NF ORIGINAL: "+ZZ->D1_NFORI+")  " +Alltrim(_cPedCli)

			_cString += Space( ( ( _nTam-Len(_cString) ) - 1 ) )+"³"
			U_CR004B(_cString,Alias())

			_lEnt := .T.
		Endif

		ZZ->(dbSkip())
	EndDO

	ZZ->(dbCloseArea())

	dbSelectArea("SZD")
	dbSetOrder(1)
	dbSeek(xFilial("SZD")+_cCliente + _cLoja + _cProd + _cProdCli+Dtos(MV_PAR01),.T.)

	_cChavSZD := _cCliente + _cLoja + _cProd + _cProdCli + _cPedCli

	ProcRegua(LastRec())

//While !Eof().And. (_cChavSD2 ==  SZD->ZD_CLIENTE+SZD->ZD_LOJA+SZD->ZD_PRODUTO+SZD->ZD_CODCLI+SZD->ZD_PEDCLI) .And. SZD->ZD_DATA <= MV_PAR02
	While !Eof().And. (_cChavSZD ==  SZD->ZD_CLIENTE+SZD->ZD_LOJA+SZD->ZD_PRODUTO+SZD->ZD_CODCLI+SZD->ZD_PEDCLI) .And. SZD->ZD_DATA <= MV_PAR02

		IncProc("Selecionando Acertos Caterpillar!!")

		If _lFim
			Alert("cancelado pelo Operador!!")
			Return
		EndIf

		If Empty(SZD->ZD_MOTCONS)
			_cAcerto := "ACERTO DE LANCAMENTO"
		Else
			_cAcerto := SZD->ZD_MOTCONS
		Endif

		If SZD->ZD_TIPO == "1"
			_nQtdeNf   +=  SZD->ZD_QUANT
			_nQte      := SZD->ZD_QUANT
		Else
			_nQtdeNf   -=  SZD->ZD_QUANT
			_nQte      := SZD->ZD_QUANT * -1
		Endif

//	_cString :="³ "+SZD->ZD_TIPO+" "+SZD->ZD_DOC+" "+"000"+" "+DTOC(SZD->ZD_DATA)+" "+TRANSFORM(SZD->ZD_QUANT,"@E 999,999,999.99")+" "+TRANSFORM(0,"@E 999,999,999.99")+"      "+_cAcerto+"  "+SZD->ZD_PEDCLI
		_cString :="³ "+SZD->ZD_TIPO+" "+SZD->ZD_DOC+" "+"000"+" "+DTOC(SZD->ZD_DATA)+" "+TRANSFORM(_nQte,"@E 999,999,999.99")+" "+TRANSFORM(0,"@E 999,999,999.99")+"      "+_cAcerto+"  "+SZD->ZD_PEDCLI
		_cString += Space( ( ( _nTam-Len(_cString) ) - 1 ) )+"³"
		U_CR004B(_cString,Alias())

		_lEnt := .T.

		dbSelectArea("SZD")
		dbSkip()
	EndDo

	If _lEnt
		U_CR004B(_cFimBloc,Alias())
		U_CR004B("³"+Space((_nTam-2))+"³")

		_cString:= "³Qtde.Total : "+Transform(_nQtdeNf,"@E 999,999,999.99")+" Valor Total : "+Transform(_nValNf,"@E 999,999,999.99")
		_cString += Space( ( ( _nTam-Len(_cString) ) - 1 ) )+"³"
		U_CR004B(_cString,Alias())
		U_CR004B("³"+Space((_nTam-2))+"³")
	Endif

Return



Static Function RunProc1(_lFim) // Para utilizar com os Clientes que mudam o Pedido cliente

//Private _nTam := 90
	Private _nTam := 110
	Private _cFimBloc:= CHR(192)+Repli(CHR(196),(_nTam-2))+CHR(217)
	Private _cBrancBl:= "³"+Repli(" ",(_nTam-2))+"³"

	_aCampos := {}
	AADD(_aCampos,{"LINHA","C",120,0 } )

	_cNomArq := CriaTrab(_aCampos)
	USE &_cNomArq Alias TRB ExClusive NEW VIA __LocalDriver


	Private _cCliente := SZ2->Z2_CLIENTE
	Private _cLoja    := SZ2->Z2_LOJA
	Private _cProd    := SZ2->Z2_PRODUTO
	Private _cProdCli := SZ2->Z2_CODCLI

	_lAchou  := .F.

	dbSelectArea("SC6")
	dbOrderNickname("INDSC61")
	If dbSeek(xFilial("SC6")+ _cCliente + _cLoja + _cProd + _cProdCli )

		_lAchou := .T.
		_cChavSC6 :=  SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_PRODUTO+SC6->C6_CPROCLI

		_cString:= "Movimentos em Aberto: "
		U_CR004B(CHR(218)+_cString+Repli(CHR(196),((_nTam-2)-Len(_cString)))+CHR(191),Alias())
		U_CR004B("³"+Space((_nTam-2))+"³")

		_cString:= "Pedido de Venda"
		U_CR004B(CHR(218)+_cString+Repli(CHR(196),((_nTam-2)-Len(_cString)))+CHR(191),Alias())
		U_CR004B("³"+Space((_nTam-2))+"³")

	/*
	³Produto         Pedido It Emissao  Entrega     Qtde.Pedido  Qtde.Entregue          Saldo
	999999999999999	999999 99 99999999 99999999 99999999999999 99999999999999 99999999999999
	0               16     23 26       35       44             59             74
	*/
		_cString:= "³Produto         Pedido It Emissao  Entrega     Tipo Qtde.Pedido  Qtde.Entregue        Saldo    Ped.Cliente    ³"
		U_CR004B(CHR(218)+_cString+Repli(CHR(196),((_nTam-2)-Len(_cString)))+CHR(191),Alias())
		U_CR004B("³"+Space((_nTam-2))+"³")

		_nQtdeTot  := 0
		_nSaldotot := 0

		dbSelectArea("SC6")
		_nRec      := LastRec()
		ProcRegua(_nRec)

		While !Eof() .And. _cChavSC6 ==  SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_PRODUTO+SC6->C6_CPROCLI

			IncProc("Selecionando os Pedidos em Aberto")

			If _lFim
				Alert("cancelado pelo Operador!!")
				Return
			EndIf

			_dEmissao := CTOD("  /  /  ")
			dbSelectArea("SC5")
			dbSetOrder(1)
			If dbSeek(SC6->C6_FILIAL+SC6->C6_NUM)
				_dEmissao := SC5->C5_EMISSAO
			Endif

			If (SC6->C6_QTDVEN == SC6->C6_QTDENT)  .Or. Alltrim(SC6->C6_BLQ) == "R"
				dbSelectarea("SC6")
				dbSkip()
				Loop
			Endif

			If MV_PAR03 == 2
				dbSelectArea("SF4")
				dbSetOrder(1)
				If dbSeek(xFilial("SF4")+SC6->C6_TES)
					If SF4->F4_TPNFISC == "S"
						dbSelectarea("SC6")
						dbSkip()
						Loop
					Endif
				Endif
			Endif
			_nSaldoTot := _nSaldoTot +  (SC6->C6_QTDVEN - SC6->C6_QTDENT)
			_nQtdeTot  := _nQtdeTot  + SC6->C6_QTDVEN
			_cPedCli   := SC6->C6_PEDCLI

			EE9->(dbSetOrder(1))
			If EE9->(dbSeek(xFilial("EE9")+SC6->C6_NUM+Space(14)+Str(Val(SC6->C6_ITEM),6) ))
				_cPedCli := EE9->EE9_REFCLI
			Endif

			_cString := "³ "+SC6->C6_CPROCLI+" "+SC6->C6_NUM+" "+SC6->C6_ITEM+" "+DTOC(_dEmissao)+" "+;
				DTOC(SC6->C6_ENTREG)+" "+SC6->C6_PEDAMOS+" "+TRANSFORM(SC6->C6_QTDVEN,"@E 999,999,999.99")+" "+;
				TRANSFORM(SC6->C6_QTDENT,"@E 999,999,999.99")+" "+TRANSFORM(SC6->C6_QTDVEN - SC6->C6_QTDENT,"@E 999,999,999.99")+"  "+_cPedCli
			_cString += Space( ( ( _nTam-Len(_cString) ) - 1 ) )+"³"
			U_CR004B(_cString,Alias())

			dbSelectArea("SC6")
			dbSkip()
		EndDo
		U_CR004B(_cFimBloc,Alias())
		U_CR004B("³"+Space((_nTam-2))+"³")

		_cString:= "³Qtde.Total : "+Transform(_nQtdeTot,"@E 999,999,999.99")+" Saldo Total : "+Transform(_nSaldoTot,"@E 999,999,999.99")
		_cString += Space( ( ( _nTam-Len(_cString) ) - 1 ) )+"³"
		U_CR004B(_cString,Alias())
		U_CR004B("³"+Space((_nTam-2))+"³")
	Endif

	_nQtdeNf := 0
	_nValNf  := 0
	_lEnt    := .F.

	dbSelectArea("SD2")
	dbOrderNickname("INDSD22")
	dbSeek(xFilial("SD2")+ _cCliente + _cLoja +_cProdCli + _cProd + Dtos(MV_PAR01),.T.)

	_cChavSD2 :=  SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SD2->D2_PROCLI

	If _cChavSD2 == _cCliente + _cLoja + _cProd + _cProdCli

		_cString:= "³Lancamentos de Saida: ³"
		U_CR004B(CHR(218)+_cString+Repli(CHR(196),((_nTam-2)-Len(_cString)))+CHR(191),Alias())
		U_CR004B("³"+Space((_nTam-2))+"³")

	/*
	³Tp N.Fisc Ser Emissao   Qtde.Entregue    Valor Total³
	99 999999 999 99999999 99999999999999 99999999999999
	0  3      10  14       23             38
	*/

		_cString:= "³Tp N.Fisc Ser Emissao   Qtde.Entregue    Valor Total   Numero Invoice   Ped.Cliente        Dt. Saída³"
		U_CR004B(CHR(218)+_cString+Repli(CHR(196),((_nTam-2)-Len(_cString)))+CHR(191),Alias())
		U_CR004B("³"+Space((_nTam-2))+"³")

		_lAchou := .T.
		dbSelectArea("SD2")
		_nRec := LastRec()
		ProcRegua(_nRec)

		While !Eof().And. (_cChavSD2 ==  SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SD2->D2_PROCLI) .And. SD2->D2_EMISSAO <= MV_PAR02

			IncProc("Selecionando as N.Fiscais de Venda")

			If _lFim
				Alert("cancelado pelo Operador!!")
				Return
			EndIf


			If MV_PAR03 == 2
				dbSelectArea("SF4")
				dbSetOrder(1)
				If dbSeek(xFilial("SF4")+SD2->D2_TES)
					If SF4->F4_TPNFISC == "S"
						dbSelectarea("SD2")
						dbSkip()
						Loop
					Endif
				Endif
			Endif
			_nQtdeNf   := _nQtdeNf +  SD2->D2_QUANT
			_nValNF    := _nValNf  +  SD2->D2_TOTAL

			_cPedCli   := SD2->D2_PEDCLI

			EE9->(dbSetOrder(1))
			If EE9->(dbSeek(xFilial("EE9")+SD2->D2_PEDIDO+Space(14)+Str(Val(SD2->D2_ITEMPV),6) ))
				_cPedCli := EE9->EE9_REFCLI
			Endif

			_dSaida := ctod("  /  /  ")
			If SF2->(dbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE))
				_dSaida := SF2->F2_DTENTR
			Endif

			_cString :="³ "+SD2->D2_TIPO+" "+SD2->D2_DOC+" "+SD2->D2_SERIE+" "+DTOC(SD2->D2_EMISSAO)+" "+TRANSFORM(SD2->D2_QUANT,"@E 999,999,999.99")+" "+TRANSFORM(SD2->D2_TOTAL,"@E 999,999,999.99")+" "+SD2->D2_PREEMB+" "+Alltrim(_cPedCli)+" "+DTOC(_dSaida)
			_cString += Space( ( ( _nTam-Len(_cString) ) - 1 ) )+"³"
			U_CR004B(_cString,Alias())

			_lEnt := .T.

			dbSelectArea("SD2")
			dbSkip()
		EndDo
	Endif

	_cQuery := " SELECT * FROM "+RETSQLNAME("SD1")+" D1 "
	_cQuery += " WHERE D1.D_E_L_E_T_ = '' "
	_cQuery += " AND D1_TIPO = 'D' AND D1_NFORI <> '' "
	_cQuery += " AND D1_FORNECE+D1_LOJA+D1_COD = '"+_cCliente + _cLoja + _cProd+"' "
	_cQuery += " AND D1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	_cQuery += " ORDER BY D1_DOC "

	TCQUERY _cQuery NEW ALIAS "ZZ"

	TCSETFIELD("ZZ","D1_EMISSAO","D")

	dbSelectArea("ZZ")
	dbGotop()

	While ZZ->(!EOF())

		SD2->(dbsetOrder(3))
		If SD2->(dbSeeK(xFilial("SD2")+ZZ->D1_NFORI+ZZ->D1_SERIORI+ZZ->D1_FORNECE+ZZ->D1_LOJA+ZZ->D1_COD+ZZ->D1_ITEMORI))
//		If SD2->D2_PEDCLI != _cPedCli
//			ZZ->(dbSkip())
//			Loop
//		Endif

			_cRevPed2  := SD2->D2_REVPED
			_nQtde    := ZZ->D1_QUANT * -1
			_nTot     := ZZ->D1_TOTAL * -1

			_nQtdeNf   := _nQtdeNf + _nQtde
			_nValNF    := _nValNf  +  _nTot

			_cString :="³ "+ZZ->D1_TIPO+ " "+ZZ->D1_DOC+ " "+ZZ->D1_SERIE+ " "+DTOC(ZZ->D1_EMISSAO)+ " "+TRANSFORM(_nQtde,"@E 999,999,999.99")+       " "+TRANSFORM(_nTot,"@E 999,999,999.99")+" (NF ORIGINAL: "+ZZ->D1_NFORI+")  "// +Alltrim(_cPedCli)

			_cString += Space( ( ( _nTam-Len(_cString) ) - 1 ) )+"³"
			U_CR004B(_cString,Alias())

			_lEnt := .T.
		Endif

		ZZ->(dbSkip())
	EndDO

	ZZ->(dbCloseArea())

	dbSelectArea("SZD")
	dbSetOrder(1)
	dbSeek(xFilial("SZD")+_cCliente + _cLoja + _cProd + _cProdCli+Dtos(MV_PAR01),.T.)

	ProcRegua(LastRec())

	While !Eof().And. (_cChavSD2 ==  SZD->ZD_CLIENTE+SZD->ZD_LOJA+SZD->ZD_PRODUTO+SZD->ZD_CODCLI+SZD->ZD_PEDCLI) .And. SZD->ZD_DATA <= MV_PAR02

		IncProc("Selecionando Acertos Caterpillar!!")

		If _lFim
			Alert("cancelado pelo Operador!!")
			Return
		EndIf

		If Empty(SZD->ZD_MOTCONS)
			_cAcerto := "ACERTO DE LANCAMENTO"
		Else
			_cAcerto := SZD->ZD_MOTCONS
		Endif

		If SZD->ZD_TIPO == "1"
			_nQtdeNf   +=  SZD->ZD_QUANT
		Else
			_nQtdeNf   -=  SZD->ZD_QUANT
		Endif

		_cString :="³ "+SZD->ZD_TIPO+" "+SZD->ZD_DOC+" "+"000"+" "+DTOC(SZD->ZD_DATA)+" "+TRANSFORM(SZD->ZD_QUANT,"@E 999,999,999.99")+" "+TRANSFORM(0,"@E 999,999,999.99")+"      "+_cAcerto+"  "+SZD->ZD_PEDCLI
		_cString += Space( ( ( _nTam-Len(_cString) ) - 1 ) )+"³"
		U_CR004B(_cString,Alias())

		_lEnt := .T.

		dbSelectArea("SZD")
		dbSkip()
	EndDo

	If _lEnt
		U_CR004B(_cFimBloc,Alias())
		U_CR004B("³"+Space((_nTam-2))+"³")

		_cString:= "³Qtde.Total : "+Transform(_nQtdeNf,"@E 999,999,999.99")+" Valor Total : "+Transform(_nValNf,"@E 999,999,999.99")
		_cString += Space( ( ( _nTam-Len(_cString) ) - 1 ) )+"³"
		U_CR004B(_cString,Alias())
		U_CR004B("³"+Space((_nTam-2))+"³")
	Endif

Return


Static Function Fecha()

	aHeader := AClone(_aHeadOri)
	aCols   := AClone(_aAColOri)
	n       := _nOri

	dbselectArea(_cAliSX3)
	dbSetOrder(_nOrdSX3)
	DbGoto(_nRecSX3)

	Close(odlg3)

Return


User Function CR004B(cVar,cAlias)

	cVar := StrTran(cVar,Chr(179)," ")
	cVar := StrTran(cVar,Chr(191)," ")
	cVar := StrTran(cVar,Chr(192)," ")
	cVar := StrTran(cVar,Chr(196)," ")
	cVar := StrTran(cVar,Chr(217)," ")
	cVar := StrTran(cVar,Chr(218)," ")

	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->LINHA :=  OemToAnsi(cVar)
	MsUnLock()

//dbSelectArea(cAlias)

Return

Static Function MontaBrow()

	Local oDlg, oQual
	Local cCadastro := "Analise do Produto"
	Local oFont:=TFont():New( "Mono AS", 6, 15 )

	dbSelectArea("TRB")
	dbGotop()

//DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 25,95 OF oMainWnd
	DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 35,115 OF oMainWnd

//@ 5,10 LISTBOX oQual FIELDS TRB->LINHA HEADER "" SIZE 305,120  FONT oFont PIXEL
	@ 5,10 LISTBOX oQual FIELDS TRB->LINHA HEADER "" SIZE 390,180  FONT oFont PIXEL

	DEFINE SBUTTON FROM 14,410  TYPE 1 ACTION (oDlg:End()) 				ENABLE OF oDlg
	DEFINE SBUTTON FROM 27,410  TYPE 6 ACTION (ImpCons(),oDlg:End())	ENABLE OF oDlg

	ACTIVATE MSDIALOG oDlg CENTERED

	oFont:End()

Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCons  ³ Autor ³ Alexandro da Silva    ³ Data ³ 15/05/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envia para funcao que faz a impressao da consulta.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PA0002                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpCons()

	LOCAL cTitulo   := "POSICAO ATUAL DE CLIENTE X PRODUTO"
	LOCAL cDesc1 	:= "Este programa ira imprimir a Consulta do Produto selecionado,"
	LOCAL cDesc2 	:= "informando os dados cadastrais, Movimentacoes em Aberto,"
	LOCAL cDesc3 	:= "Historico de Movimentacoes."
	LOCAL cString   := "TRB"
	LOCAL wnrel     := "PA0002"

	PRIVATE cPerg   := "      "
	PRIVATE aReturn := {"Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
	PRIVATE nLastKey:=0
	nOpc:=2
	nOpcA:=2
	wnRel:= SetPrint(cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3,.F.,"",,,,.F.)

	If nLastKey = 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey = 27
		Return
	Endif

	RptStatus({|lEnd| RelImp(@lEnd,ctitulo,wnRel)},ctitulo)
Return .T.


Static Function RelImp(lEnd,ctitulo,wnRel)

	Local cCabec1  := "Consulta Geral ao Produto"
	Local cCabec2  := ""
	Local cTamanho := "P"
	Local cNomeProg:= "PA0002"
	Local cbtxt    := SPACE(10)
	Local cbcont   := 0

	li       := 80
	m_pag    := 1

	dbSelectArea("TRB")
	dbGoTop()
	SetRegua(RecCount())            // Total de Elementos da Regua

	While !EOF()

		IncRegua()

		IF li > 62
			cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
			Li:= 9
		EndIF

		cCampo:=""
		For x:=1 to Len(TRB->LINHA)
			If Subs(TRB->LINHA,x,1) $ "Ú¿ÀÙ"
				cCampo += "+"
			ElseIf Subs(TRB->LINHA,x,1) == "Ä"
				cCampo += "-"
			ElseIf Subs(TRB->LINHA,x,1) == "„"
				cCampo += "a"
			ElseIf Subs(TRB->LINHA,x,1) == "‡"
				cCampo += "c"
			ElseIf Subs(TRB->LINHA,x,1) == "³"
				cCampo += "|"
			Else
				cCampo += Subs(TRB->LINHA,x,1)
			Endif
		Next

		@ li++,00 PSay cCampo
		dbSkip()

	EndDO

	IF li != 80
		li++
		roda(cbcont,cbtxt,"P")
	EndIF

	If aReturn[5] = 1
		Set Printer TO
		dbCommitAll()
		ourspool(wnrel)
	Endif

Return (.T.)
