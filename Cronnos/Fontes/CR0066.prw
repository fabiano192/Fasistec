#INCLUDE "TOTVS.ch"
#INCLUDE "TOPCONN.ch"

/*/
Função    	: 	CR0066
Autor 		: 	Fabiano da Silva
Data 		: 	10.09.14
Descricao 	: 	Nova tela de Consulta Faturamento
/*/

User Function CR0066()

	Local aCores := {}

	PRIVATE aRotina := { {"Pesquisar","AxPesqui", 0 , 1},;
		{"Consulta","U_CR066A()", 0 , 2} ,;
		{"Legenda" ,"U_BLegenda" ,0 , 3} }

	cCadastro := OemToAnsi("Consulta Geral do Faturamento")

	AADD(aCores,{"Z2_ATIVO == '1'" ,"BR_VERDE" })
	AADD(aCores,{"Z2_ATIVO == '2' .AND. Empty(Z2_PRODUTO)" ,"BR_AMARELO" })
	AADD(aCores,{"Z2_ATIVO == '2' .AND. !Empty(Z2_PRODUTO)" ,"BR_VERMELHO" })

	mBrowse( 6,1,22,75,"SZ2",,,,,,aCores)

	SZ2->(dbSetOrder(1))

Return .T.


User Function CR066A()

	If !Pergunte("CR0004",.T.)
		Return
	Endif

	Private _lAchou   	:= .F.
	Private _cCliente 	:= _cLoja 	:= _cProd := _cProdCli := _cPedCli := ""
	Private _nQtdeNf 	:= _nValNf  := 0
	Private oGetDad1, oGetDad2, oGetDad3
	Private aHead1 		:= {}
	Private aCols1 		:= {}
	Private aHead2 		:= {}
	Private aCols2 		:= {}
	Private aHead3 		:= {}
	Private aCols3 		:= {}
	Private aHead4 		:= {}
	Private aCols4 		:= {}
	Private aHead5 		:= {}
	Private aCols5 		:= {}
	Private _lTRB1		:= _lTRB2 := _lTRB3 := _lTRB4 := _lTRB5 := .F.
	Private _lPO		:= .F.

	_aAliOri := GetArea()
	_aAliSC5 := SC5->(GetArea())
	_aAliSC6 := SC6->(GetArea())
	_aAliSF4 := SF4->(GetArea())
	_aAliSD2 := SD2->(GetArea())
	_aAliSZ4 := SZ4->(GetArea())

	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| CR066B(@_lFim) }
	Private _cTitulo01 := 'Processando'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

	If _lAchou
		MontaBrow()
	Else
		MsgAlert("Não existem informações para essa consulta!")
	Endif

	TRB1->(dbCloseArea())
	TRB2->(dbCloseArea())
	TRB3->(dbCloseArea())
	If _cCliente = '000018'
		TRB4->(dbCloseArea())
	Endif
	TRB5->(dbCloseArea())

	RestArea(_aAliSF4)
	RestArea(_aAliSC5)
	RestArea(_aAliSC6)
	RestArea(_aAliSD2)
	RestArea(_aAliOri)

Return


Static Function CR066B(_lFim)  // Para utilizar com os Clientes que nï¿½o mudam o Pedido cliente como a Caterpillar Exportaï¿½ï¿½o

	_cCliente := SZ2->Z2_CLIENTE
	_cLoja    := SZ2->Z2_LOJA
	_cProd    := SZ2->Z2_PRODUTO
	_cProdCli := SZ2->Z2_CODCLI
	_cPedCli  := SZ2->Z2_PEDCLI

	SA1->(dbsetOrder(1))
	SA1->(msSeek(xFilial("SA1")+SZ2->Z2_CLIENTE+SZ2->Z2_LOJA))

	If SA1->A1_XCONTPO = 'S'
		_lPO := .T.
	Endif

	_lAchou  := .F.

	GeraTRB1()//Pedidos de Vendas em Aberto
	GeraTRB2()//NF de Saída
	GeraTRB3()//NF de Entrada
	If _cCliente = '000018'
		GeraTRB4()//Acumulado
	Endif
	GeraTRB5()//Programações

Return



Static Function GeraTRB1() //Pedidos de Vendas em Aberto

	Private nUsad1 := 0

//	If !_cCliente $ '000017|000018'
	If !_lPO
		_aCamp1 := {'C6_NUM','C6_ITEM','C5_EMISSAO','C6_ENTREG','C6_YDTFECH','C6_PEDAMOS','C6_QTDVEN','C6_QTDENT','C6_REVPED','C6_PEDCLI'}
	Else
		_aCamp1 := {'C6_NUM','C6_ITEM','C5_EMISSAO','C6_ENTREG','C6_YDTFECH','C6_PEDAMOS','C6_QTDVEN','C6_QTDENT','C6_REVPED'}
	Endif

	For C := 1 To Len(_aCamp1)
		SX3->(dbsetOrder(2))
		If SX3->(dbSeek(_aCamp1[C]))
			nUsad1++

			aAdd(aHead1, {AllTrim(	X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )
			If Alltrim(SX3->X3_CAMPO) = 'C6_QTDENT'
				aAdd(aHead1, {'Saldo','SALDO',SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )
				nUsad1++
			Endif
		Endif
	Next C

	nPosNum := aScan(aHead1,{|x| Alltrim(x[2]) == "C6_NUM"})
	nPosIte := aScan(aHead1,{|x| Alltrim(x[2]) == "C6_ITEM"})
	nPosEmi := aScan(aHead1,{|x| Alltrim(x[2]) == "C5_EMISSAO"})
	nPosEnt := aScan(aHead1,{|x| Alltrim(x[2]) == "C6_ENTREG"})
	nPosFec := aScan(aHead1,{|x| Alltrim(x[2]) == "C6_YDTFECH"})
	nPosPed := aScan(aHead1,{|x| Alltrim(x[2]) == "C6_PEDAMOS"})
	nPosQVe := aScan(aHead1,{|x| Alltrim(x[2]) == "C6_QTDVEN"})
	nPosQEn := aScan(aHead1,{|x| Alltrim(x[2]) == "C6_QTDENT"})
	nPosSld := aScan(aHead1,{|x| Alltrim(x[2]) == "SALDO"})
	nPosRev := aScan(aHead1,{|x| Alltrim(x[2]) == "C6_REVPED"})
	nPosPCl := aScan(aHead1,{|x| Alltrim(x[2]) == "C6_PEDCLI"})

	_cQrPed := " SELECT * FROM "+RetSqlName('SC6')+" C6 " +CRLF
	_cQrPed += " INNER JOIN "+RetSqlName('SC5')+" C5 ON C6_NUM = C5_NUM " +CRLF
	_cQrPed += " INNER JOIN "+RetSqlName('SF4')+" F4 ON C6_TES = F4_CODIGO " +CRLF
	_cQrPed += " WHERE C6.D_E_L_E_T_ = '' AND C5.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' " +CRLF
	_cQrPed += " AND C6_BLQ = '' " +CRLF
	_cQrPed += " AND C6_QTDVEN > C6_QTDENT " +CRLF
	_cQrPed += " AND C6_CLI = '"+_cCliente+"' " +CRLF
	_cQrPed += " AND C6_LOJA = '"+_cLoja+"' " +CRLF
	_cQrPed += " AND C6_PRODUTO = '"+_cProd+"' " +CRLF
	_cQrPed += " AND C6_CPROCLI = '"+_cProdCli+"' " +CRLF
//	If _cCliente $ '000017|000018'
	If _lPO
		_cQrPed += " AND C6_PEDCLI = '"+_cPedCli+"' " +CRLF
	Endif
	If MV_PAR03 = 2
		_cQrPed += " AND F4_TPNFISC <> 'S' " +CRLF
	Endif
	_cQrPed += " ORDER BY C6_ENTREG,C6_NUM,C6_ITEM " +CRLF

	//	MemoWrite("D:\CR0066.TXT",_cQrPed)

	TCQUERY _cQrPed New Alias "TRB1"

	TCSETFIELD("TRB1","C5_EMISSAO","D")
	TCSETFIELD("TRB1","C6_ENTREG","D")
	TCSETFIELD("TRB1","C6_YDTFECH","D")

	TRB1->(dbGoTop())

	_nQtdeTot  := 0
	_nSaldotot := 0

	While TRB1->(!EOF())

		_lAchou    	:= .T.

		AADD(aCols1,Array(nUsad1+1))

		aCols1[Len(aCols1),nPosNum]:= TRB1->C6_NUM
		aCols1[Len(aCols1),nPosIte]:= TRB1->C6_ITEM
		aCols1[Len(aCols1),nPosEmi]:= TRB1->C5_EMISSAO
		aCols1[Len(aCols1),nPosEnt]:= TRB1->C6_ENTREG
		aCols1[Len(aCols1),nPosFec]:= If(Empty(TRB1->C6_YDTFECH),TRB1->C6_ENTREG,TRB1->C6_YDTFECH)
		aCols1[Len(aCols1),nPosPed]:= TRB1->C6_PEDAMOS
		aCols1[Len(aCols1),nPosQVe]:= TRB1->C6_QTDVEN
		aCols1[Len(aCols1),nPosQEn]:= TRB1->C6_QTDENT
		aCols1[Len(aCols1),nPosSld]:= TRB1->C6_QTDVEN - TRB1->C6_QTDENT
		aCols1[Len(aCols1),nPosRev]:= TRB1->C6_REVPED
//		If !_cCliente $ '000017|000018'
		If !_lPO
			aCols1[Len(aCols1),nPosPCl]:= TRB1->C6_PEDCLI
		Endif

		aCols1[Len(aCols1),nUsad1+1]:=.F.

		_nSaldoTot += TRB1->C6_QTDVEN - TRB1->C6_QTDENT
		_nQtdeTot  += TRB1->C6_QTDVEN
		_lTRB1		:= .T.

		TRB1->(dbSkip())
	EndDo
Return


Static Function GeraTRB2() //NF Saída

	Private nUsad2 := 0

//	If !_cCliente $ '000017|000018'
	If !_lPO
		_aCamp2 := {'D2_TIPO','D2_DOC','D2_SERIE','D2_EMISSAO','D2_QUANT','D2_TOTAL','D2_PREEMB','D2_REVPED','EEC_DTEMBA','EEC_VIA','D2_PEDCLI'}
	ElseIf _cCliente = '000018'
		_aCamp2 := {'D2_TIPO','D2_DOC','D2_SERIE','D2_EMISSAO','D2_QUANT','D2_TOTAL','D2_PREEMB','D2_REVPED','EEC_DTEMBA','EEC_VIA','EEC_STATUS'}
	Else
		_aCamp2 := {'D2_TIPO','D2_DOC','D2_SERIE','D2_EMISSAO','D2_QUANT','D2_TOTAL','D2_PREEMB','D2_REVPED','EEC_DTEMBA','EEC_VIA'}
	Endif

	For C := 1 To Len(_aCamp2)
		SX3->(dbsetOrder(2))
		If SX3->(dbSeek(_aCamp2[C]))
			nUsad2++

			aAdd(aHead2, {AllTrim(	X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )
		Endif
	Next C

	nPosTip := aScan(aHead2,{|x| Alltrim(x[2]) == "D2_TIPO"})
	nPosDoc := aScan(aHead2,{|x| Alltrim(x[2]) == "D2_DOC"})
	nPosSer := aScan(aHead2,{|x| Alltrim(x[2]) == "D2_SERIE"})
	nPosEmi := aScan(aHead2,{|x| Alltrim(x[2]) == "D2_EMISSAO"})
	nPosQtd := aScan(aHead2,{|x| Alltrim(x[2]) == "D2_QUANT"})
	nPosTot := aScan(aHead2,{|x| Alltrim(x[2]) == "D2_TOTAL"})
	nPosPre := aScan(aHead2,{|x| Alltrim(x[2]) == "D2_PREEMB"})
	nPosRev := aScan(aHead2,{|x| Alltrim(x[2]) == "D2_REVPED"})
	nPosDEm := aScan(aHead2,{|x| Alltrim(x[2]) == "EEC_DTEMBA"})
	nPosVia := aScan(aHead2,{|x| Alltrim(x[2]) == "EEC_VIA"})
	nPosPCl := aScan(aHead2,{|x| Alltrim(x[2]) == "D2_PEDCLI"})
	nPosSta := aScan(aHead2,{|x| Alltrim(x[2]) == "EEC_STATUS"})

	_cQrDoc := " SELECT * FROM "+RetSqlName('SD2')+" D2 " +CRLF
	_cQrDoc += " INNER JOIN "+RetSqlName('SF2')+" F2 ON D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE " +CRLF
	_cQrDoc += " INNER JOIN "+RetSqlName('SF4')+" F4 ON D2_TES = F4_CODIGO " +CRLF
	_cQrDoc += " WHERE D2.D_E_L_E_T_ = '' AND F2.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' " +CRLF
	_cQrDoc += " AND D2_CLIENTE = '"+_cCliente+"' " +CRLF
	_cQrDoc += " AND D2_LOJA = '"+_cLoja+"' " +CRLF
	_cQrDoc += " AND D2_COD = '"+_cProd+"' " +CRLF
	_cQrDoc += " AND D2_PROCLI = '"+_cProdCli+"' " +CRLF
//	If _cCliente $ '000017|000018'
	If _lPO
		_cQrDoc += " AND D2_PEDCLI = '"+_cPedCli+"' " +CRLF
	Endif
	If MV_PAR03 = 2
		_cQrDoc += " AND F4_TPNFISC <> 'S' " +CRLF
	Endif
	_cQrDoc += " ORDER BY D2_EMISSAO DESC " +CRLF

	//	MemoWrite("D:\CR0066.TXT",_cQrDoc)

	TCQUERY _cQrDoc New Alias "TRB2"

	TCSETFIELD("TRB2","D2_EMISSAO","D")

	TRB2->(dbGoTop())

	While TRB2->(!EOF())

		_lAchou    := .T.

		_cVia 	:= ""
		_dSaida := ctod("  /  /  ")
		_cStat  := ''

		EEC->(dbSetOrder(1))
		If EEC->(dbSeek(xFilial("EEC")+TRB2->D2_PREEMB))
			_cVia   := EEC->EEC_VIA
			_dSaida := EEC->EEC_DTEMBA
			_cStat  := AvTabela("YC",EEC->EEC_STATUS)

			SYQ->(dbSetOrder(1))
			SYQ->(dbSeek(xFilial("SYQ")+EEC->EEC_VIA))

			If Left(SYQ->YQ_COD_DI,1) = "4"
				_cVia := "Aereo"
			ElseIf Left(SYQ->YQ_COD_DI,1) = "1"
				_cVia := "Maritimo"
			Endif

		Endif

		If TRB2->D2_CLIENTE = "000017"
			If SF2->(dbSeek(xFilial("SF2")+TRB2->D2_DOC+TRB2->D2_SERIE))
				_dSaida := SF2->F2_DTENTR
			Endif
		Endif

		AADD(aCols2,Array(nUsad2+1))

		aCols2[Len(aCols2),nPosTip]:= TRB2->D2_TIPO
		aCols2[Len(aCols2),nPosDoc]:= TRB2->D2_DOC
		aCols2[Len(aCols2),nPosSer]:= TRB2->D2_SERIE
		aCols2[Len(aCols2),nPosEmi]:= TRB2->D2_EMISSAO
		aCols2[Len(aCols2),nPosQtd]:= TRB2->D2_QUANT
		aCols2[Len(aCols2),nPosTot]:= TRB2->D2_TOTAL
		aCols2[Len(aCols2),nPosPre]:= TRB2->D2_PREEMB
		aCols2[Len(aCols2),nPosRev]:= TRB2->D2_REVPED
		aCols2[Len(aCols2),nPosDEm]:= _dSaida
		aCols2[Len(aCols2),nPosVia]:= _cVia
//		If !_cCliente $ '000017|000018'
		If !_lPO
			aCols2[Len(aCols2),nPosPCl]:= TRB2->D2_PEDCLI
		ElseIf _cCliente = '000018'
			aCols2[Len(aCols2),nPosSta]:= _cStat
		Endif
		aCols2[Len(aCols2),nUsad2+1]:=.F.

		_nQtdeNf   +=  TRB2->D2_QUANT
		_nValNF    +=  TRB2->D2_TOTAL

		_lTRB2		:= .T.

		TRB2->(dbSkip())
	EndDo

Return


Static Function GeraTRB3() //NF de Entrada

	Private nUsad3 := 0

//	If !_cCliente $ '000017|000018'
	If !_lPO
		_aCamp3 := {'D1_TIPO','D1_DOC','D1_SERIE','D1_EMISSAO','D1_QUANT','D1_TOTAL','D1_NFORI','D2_PEDCLI'}
	Else
		_aCamp3 := {'D1_TIPO','D1_DOC','D1_SERIE','D1_EMISSAO','D1_QUANT','D1_TOTAL','D1_NFORI'}
	Endif

	For C := 1 To Len(_aCamp3)
		SX3->(dbsetOrder(2))
		If SX3->(dbSeek(_aCamp3[C]))
			nUsad3++

			aAdd(aHead3, {AllTrim(	X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )
		Endif
	Next C

	nPosTip := aScan(aHead3,{|x| Alltrim(x[2]) == "D1_TIPO"})
	nPosDoc := aScan(aHead3,{|x| Alltrim(x[2]) == "D1_DOC"})
	nPosSer := aScan(aHead3,{|x| Alltrim(x[2]) == "D1_SERIE"})
	nPosEmi := aScan(aHead3,{|x| Alltrim(x[2]) == "D1_EMISSAO"})
	nPosQtd := aScan(aHead3,{|x| Alltrim(x[2]) == "D1_QUANT"})
	nPosTot := aScan(aHead3,{|x| Alltrim(x[2]) == "D1_TOTAL"})
	nPosNFO := aScan(aHead3,{|x| Alltrim(x[2]) == "D1_NFORI"})
	nPosPCl := aScan(aHead3,{|x| Alltrim(x[2]) == "D2_PEDCLI"})

	_cQuery := " SELECT * FROM "+RETSQLNAME("SD1")+" D1 "
	_cQuery += " WHERE D1.D_E_L_E_T_ = '' "
	_cQuery += " AND D1_TIPO = 'D' AND D1_NFORI <> '' "
	_cQuery += " AND D1_FORNECE+D1_LOJA+D1_COD = '"+_cCliente + _cLoja + _cProd+"' "
	_cQuery += " AND D1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	_cQuery += " ORDER BY D1_DOC DESC"

	TCQUERY _cQuery NEW ALIAS "TRB3"

	TCSETFIELD("TRB3","D1_EMISSAO","D")

	TRB3->(dbGotop())

	aCols3 := {}
	While TRB3->(!EOF())

		SD2->(dbsetOrder(3))
		If SD2->(dbSeeK(xFilial("SD2")+TRB3->D1_NFORI+TRB3->D1_SERIORI+TRB3->D1_FORNECE+TRB3->D1_LOJA+TRB3->D1_COD+TRB3->D1_ITEMORI))

			If SD2->D2_PEDCLI != _cPedCli
//				If _cCliente $ '000017|000018'
				If _lPO
					TRB3->(dbSkip())
					Loop
				Endif
			Endif

			_nQtde    	:= TRB3->D1_QUANT * -1
			_nTot     	:= TRB3->D1_TOTAL * -1

			AADD(aCols3,Array(nUsad3+1))

			aCols3[Len(aCols3),nPosTip]:= TRB3->D1_TIPO
			aCols3[Len(aCols3),nPosDoc]:= TRB3->D1_DOC
			aCols3[Len(aCols3),nPosSer]:= TRB3->D1_SERIE
			aCols3[Len(aCols3),nPosEmi]:= TRB3->D1_EMISSAO
			aCols3[Len(aCols3),nPosQtd]:= TRB3->D1_QUANT
			aCols3[Len(aCols3),nPosTot]:= TRB3->D1_TOTAL
			aCols3[Len(aCols3),nPosNFO]:= TRB3->D1_NFORI
//			If !_cCliente $ '000017|000018'
			If !_lPO
				aCols3[Len(aCols3),nPosPCl]:= SD2->D2_PEDCLI
			Endif

			aCols3[Len(aCols3),nUsad3+1]:=.F.

			_nQtdeNf   	+=  _nQtde
			_nValNF    	+=  _nTot
			_lTRB3		:= .T.
		Endif

		TRB3->(dbSkip())
	EndDO

Return


Static Function GeraTRB4() //Acumulado

	Private nUsad4 := 0

	_aCamp4 := {'ZD_TIPO','ZD_DOC','ZD_DATA','ZD_QUANT','ZD_MOTIVO'}

	For C := 1 To Len(_aCamp4)
		SX3->(dbsetOrder(2))
		If SX3->(dbSeek(_aCamp4[C]))
			nUsad4++

			aAdd(aHead4, {AllTrim(	X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )
		Endif
	Next C

	nPosTip := aScan(aHead4,{|x| Alltrim(x[2]) == "ZD_TIPO"})
	nPosDoc := aScan(aHead4,{|x| Alltrim(x[2]) == "ZD_DOC"})
	nPosDat := aScan(aHead4,{|x| Alltrim(x[2]) == "ZD_DATA"})
	nPosQtd := aScan(aHead4,{|x| Alltrim(x[2]) == "ZD_QUANT"})
	nPosMot := aScan(aHead4,{|x| Alltrim(x[2]) == "ZD_MOTIVO"})

	_cQuery := " SELECT * FROM "+RETSQLNAME("SZD")+" ZD "
	_cQuery += " WHERE ZD.D_E_L_E_T_ = '' "
	_cQuery += " AND ZD_CLIENTE = '"+_cCliente+"' "
	_cQuery += " AND ZD_LOJA 	= '"+_cLoja+"' "
	_cQuery += " AND ZD_PRODUTO = '"+_cProd+"' "
//	If _cCliente $ '000017|000018'
	If _lPO
		_cQuery += " AND ZD_PEDCLI 	= '"+_cPedCli+"' "
	Endif
	_cQuery += " AND ZD_DATA 	<= '"+Dtos(MV_PAR02)+"' "
	_cQuery += " ORDER BY ZD_DATA DESC"

	TCQUERY _cQuery NEW ALIAS "TRB4"

	TCSETFIELD("TRB4","ZD_DATA","D")

	TRB4->(dbGotop())

	aCols4 := {}
	While TRB4->(!EOF())

		If Empty(TRB4->ZD_MOTIVO)
			_cAcerto := "ACERTO DE LANCAMENTO"
		Else
			_cAcerto := TRB4->ZD_MOTIVO
		Endif

		If TRB4->ZD_TIPO == "1"
			_nQtdeNf   += TRB4->ZD_QUANT
		Else
			_nQtdeNf   -= TRB4->ZD_QUANT
		Endif

		AADD(aCols4,Array(nUsad4+1))

		aCols4[Len(aCols4),nPosTip]:= TRB4->ZD_TIPO
		aCols4[Len(aCols4),nPosDoc]:= TRB4->ZD_DOC
		aCols4[Len(aCols4),nPosDat]:= TRB4->ZD_DATA
		aCols4[Len(aCols4),nPosQtd]:= TRB4->ZD_QUANT
		aCols4[Len(aCols4),nPosMot]:= _cAcerto

		aCols4[Len(aCols4),nUsad4+1]:=.F.
		_lTRB4		:= .T.

		TRB4->(dbSkip())
	EndDO

Return


Static Function GeraTRB5() //Programações

	Private nUsad5 := 0

	_aCamp5 := {'Z4_DTDIGIT','Z4_POLINE','Z4_TPPED','Z4_ULTNF','Z4_SERIE','Z4_DTULTNF','Z4_ULQTENF','Z4_DTENT','Z4_DTFECH','Z4_QTENT','Z4_QTACUM','Z4_NOMARQ'}

	For C := 1 To Len(_aCamp5)
		SX3->(dbsetOrder(2))
		If SX3->(dbSeek(_aCamp5[C]))
			nUsad5++

			aAdd(aHead5, {AllTrim(	X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )
		Endif
	Next C

	nPosDtD := aScan(aHead5,{|x| Alltrim(x[2]) == "Z4_DTDIGIT"})
	nPosPOL := aScan(aHead5,{|x| Alltrim(x[2]) == "Z4_POLINE"})
	nPosTip := aScan(aHead5,{|x| Alltrim(x[2]) == "Z4_TPPED"})
	nPosNF  := aScan(aHead5,{|x| Alltrim(x[2]) == "Z4_ULTNF"})
	nPosSer := aScan(aHead5,{|x| Alltrim(x[2]) == "Z4_SERIE"})
	nPosDtN := aScan(aHead5,{|x| Alltrim(x[2]) == "Z4_DTULTNF"})
	nPosUQN := aScan(aHead5,{|x| Alltrim(x[2]) == "Z4_ULQTENF"})
	nPosDtE := aScan(aHead5,{|x| Alltrim(x[2]) == "Z4_DTENT"})
	nPosDtF := aScan(aHead5,{|x| Alltrim(x[2]) == "Z4_DTFECH"})
	nPosQtE := aScan(aHead5,{|x| Alltrim(x[2]) == "Z4_QTENT"})
	nPosQtA := aScan(aHead5,{|x| Alltrim(x[2]) == "Z4_QTACUM"})
	nPosNoA := aScan(aHead5,{|x| Alltrim(x[2]) == "Z4_NOMARQ"})

	_cQuery := " SELECT * FROM "+RETSQLNAME("SZ4")+" Z4 "
	_cQuery += " WHERE Z4.D_E_L_E_T_ = '' "
	_cQuery += " AND Z4_INTEGR  = 'S'  "
	_cQuery += " AND Z4_CODCLI  = '"+_cCliente+"' "
	_cQuery += " AND Z4_LOJA    = '"+_cLoja+"' "
	_cQuery += " AND Z4_PRODPAS = '"+_cProd+"' "
//	If _cCliente $ '000017|000018'
	If _lPO
		_cQuery += " AND Z4_PEDIDO 	= '"+_cPedCli+"' "
	Endif
	_cQuery += " AND Z4_DTDIGIT BETWEEN '"+DTOS(dDataBase-200)+"' AND '"+DTOS(dDataBase)+"' "
	//	_cQuery += " AND Z4_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	_cQuery += " ORDER BY Z4_DTDIGIT DESC,Z4_DTENT"

//	MemoWrite("D:\CR0066.TXT",_cQuery)

	TCQUERY _cQuery NEW ALIAS "TRB5"

	TCSETFIELD("TRB5","Z4_DTDIGIT","D")
	TCSETFIELD("TRB5","Z4_DTULTNF","D")
	TCSETFIELD("TRB5","Z4_DTENT","D")
	TCSETFIELD("TRB5","Z4_DTFECH","D")

	TRB5->(dbGotop())

	aCols5 := {}
	While TRB5->(!EOF())

		AADD(aCols5,Array(nUsad5+1))

		aCols5[Len(aCols5),nPosDtD]:= TRB5->Z4_DTDIGIT
		aCols5[Len(aCols5),nPosPOL]:= TRB5->Z4_POLINE
		aCols5[Len(aCols5),nPosTip]:= TRB5->Z4_TPPED
		aCols5[Len(aCols5),nPosNF] := TRB5->Z4_ULTNF
		aCols5[Len(aCols5),nPosSer]:= TRB5->Z4_SERIE
		aCols5[Len(aCols5),nPosDtN]:= TRB5->Z4_DTULTNF
		aCols5[Len(aCols5),nPosUQN]:= TRB5->Z4_ULQTENF
		aCols5[Len(aCols5),nPosDtE]:= TRB5->Z4_DTENT
		aCols5[Len(aCols5),nPosDtF]:= If(!Empty(TRB5->Z4_DTFECH),TRB5->Z4_DTFECH,TRB5->Z4_DTENT)
		aCols5[Len(aCols5),nPosQtE]:= TRB5->Z4_QTENT
		aCols5[Len(aCols5),nPosQtA]:= TRB5->Z4_QTACUM
		aCols5[Len(aCols5),nPosNoA]:= TRB5->Z4_NOMARQ

		aCols5[Len(aCols5),nUsad5+1]:=.F.
		_lTRB5		:= .T.

		TRB5->(dbSkip())
	EndDO

Return



Static Function MontaBrow()

	Local oDlg, oQual
	Local cCadastro := "Análise do Produto"

	DEFINE DIALOG oDlg TITLE cCadastro FROM 0,0 TO 550,1200 PIXEL

	oTBar := TBar():New( oDlg,25,32,.T.,,,,.F. )

	oTBtnBmp1  := TBtnBmp2():New( 00, 00, 35, 25, 'PMSEXCEL',,,,{||GeraExcel()}	, oTBar, 'Exportar para Excel'	,,.F.,.F.)
	oTBtnBmp2  := TBtnBmp2():New( 00, 00, 35, 25, 'FINAL'	,,,,{||oDlg:end()}	, oTBar, 'Fechar'				,,.F.,.F.)

	// 	oTBar:SetButtonAlign( CONTROL_ALIGN_RIGHT )

	@ 015, 002 to 032,580  OF oDlg PIXEL

	@ 018, 010 SAY "Cliente" 							SIZE 040, 007 OF oDlg PIXEL
	@ 018, 050 MSGET (_cCliente+'/'+_cLoja)	When .F.	SIZE 060, 010 OF oDlg PIXEL

	@ 018, 150 SAY "Produto" 							SIZE 040, 007 OF oDlg PIXEL
	@ 018, 190 MSGET _cProd 	When .F.				SIZE 060, 010 OF oDlg PIXEL

	@ 018, 270 SAY "Prod.Cliente" 						SIZE 040, 007 OF oDlg PIXEL
	@ 018, 310 MSGET _cProdCli 	When .F.				SIZE 060, 010 OF oDlg PIXEL

	@ 018, 400 SAY "Ped.Cliente" 						SIZE 040, 007 OF oDlg PIXEL
	@ 018, 440 MSGET _cPedCli 	When .F.				SIZE 060, 010 OF oDlg PIXEL

	aTFolder := { 'Pedidos_Vendas', 'NF_Saida', 'Ajustes','Programações' }
	oTFolder := TFolder():New( 33,02,aTFolder,,oDlg,,,,.T.,,575,215 )

	oGetDad1 := MsNewGetDados():New(005,010,200,570, 0,"AllwaysTrue()", "AllwaysTrue()",,,,,,,,oTFolder:aDialogs[1],aHead1,aCols1)
	If Empty(aCols1)
		oGetDad1:acols := {}
	Endif

	oGetDad2 := MsNewGetDados():New(005,010,200,570, 0,"AllwaysTrue()", "AllwaysTrue()",,,,,,,,oTFolder:aDialogs[2],aHead2,aCols2)
	If Empty(aCols2)
		oGetDad2:acols := {}
	Endif

	@ 003, 010 SAY "Notas Fiscais de Entrada"			SIZE 080, 007 OF oTFolder:aDialogs[3] PIXEL
	oGetDad3 := MsNewGetDados():New(013,010,100,570, 0,"AllwaysTrue()", "AllwaysTrue()",,,,,,,,oTFolder:aDialogs[3],aHead3,aCols3)
	If Empty(aCols3)
		oGetDad3:acols := {}
	Endif

	If _cCliente = '000018'
		@ 105, 010 SAY "Ajuste Acumulado"					SIZE 080, 007 OF oTFolder:aDialogs[3] PIXEL
		oGetDad4 := MsNewGetDados():New(115,010,200,570, 0,"AllwaysTrue()", "AllwaysTrue()",,,,,,,,oTFolder:aDialogs[3],aHead4,aCols4)
		If Empty(aCols4)
			oGetDad4:acols := {}
		Endif
	Endif

	oGetDad5 := MsNewGetDados():New(005,010,200,570, 0,"AllwaysTrue()", "AllwaysTrue()",,,,,,,,oTFolder:aDialogs[4],aHead5,aCols5)
	If Empty(aCols5)
		oGetDad5:acols := {}
	Endif

	@ 260, 010 SAY "Total Acumulado Saída:" 								SIZE 080, 007 OF oDlg PIXEL
	@ 260, 080 MSGET Transform(_nQtdeNf,'@e 999,999,999.99')  	When .F.	SIZE 060, 010 OF oDlg PIXEL

	ACTIVATE DIALOG oDlg CENTERED

Return(.T.)


Static Function GeraExcel()

	Local _lClick1 		:= _lClick2 := _lClick3 := _lClick4	:= _lClick5 := .F.
	Local _oFwMsEx 		:= NIL
	Local _cWorkSheet	:= ""
	Local _cTable 		:= ""
	Local _lGera 		:= .F.
	Local cDirTmp 		:= GetTempPath()
	Local cDir 			:= GetSrvProfString("Startpath","")

	DEFINE DIALOG _oDlg1 TITLE "" FROM 0,0 TO 120,160 PIXEL

	_oTBar1 := TBar():New( _oDlg1,25,32,.T.,,,,.F. )

	oTBtnBmp2  := TBtnBmp2():New( 00, 00, 35, 25, 'FINAL'	,,,,{||_oDlg1:end()}				, _oTBar1, 'Fechar'	,,.F.,.F.)
	oTBtnBmp1  := TBtnBmp2():New( 00, 00, 35, 25, 'OK'		,,,,{||_lGera := .T.,_oDlg1:end() }	, _oTBar1, 'Gerar'	,,.F.,.F.)

	_nLin := 15
	If _lTRB1
		_lClick1 := .T.
		@ _nLin,01 CHECKBOX _oTRB1 VAR _lClick1 PROMPT "Pedidos em Aberto" 	SIZE 100,007 PIXEL OF _oDlg1
		_nLin += 10
	Endif
	If _lTRB2
		_lClick2 := .T.
		@ _nLin,01 CHECKBOX _oTRB2 VAR _lClick2 PROMPT "NF Saída" 			SIZE 100,007 PIXEL OF _oDlg1
		_nLin += 10
	Endif
	If _lTRB3
		_lClick3 := .T.
		@ _nLin,01 CHECKBOX _oTRB3 VAR _lClick3 PROMPT "NF Entrada" 		SIZE 100,007 PIXEL OF _oDlg1
		_nLin += 10
	Endif
	If _lTRB4
		_lClick4 := .T.
		@ _nLin,01 CHECKBOX _oTRB4 VAR _lClick4 PROMPT "Ajuste Acumulado" 	SIZE 100,007 PIXEL OF _oDlg1
		_nLin += 10
	Endif

	If _lTRB5
		_lClick5 := .T.
		@ _nLin,01 CHECKBOX _oTRB5 VAR _lClick5 PROMPT "Programações" 	SIZE 100,007 PIXEL OF _oDlg1
		_nLin += 10
	Endif

	ACTIVATE DIALOG _oDlg1 CENTERED

	If _lGera
		If _lClick1 .Or. _lClick2 .Or. _lClick3 .Or. _lClick4 .Or. _lClick5

			_oFwMsEx := FWMsExcel():New()

			If _lClick1
				_cWorkSheet 	:= 	"Pedidos em Aberto"
				_cTable 		:= 	"Pedidos em Aberto"

				_oFwMsEx:AddWorkSheet( _cWorkSheet )
				_oFwMsEx:AddTable( _cWorkSheet, _cTable )

				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Num. Pedido"   	, 1,1,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Item"  			, 1,1,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Dt. Emissão"  	, 1,4,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Dt. Entrega"  	, 1,4,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Dt. Fechamento"	, 1,4,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Tipo Pedido"  	, 1,1,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Quantidade"  	, 3,2,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Qtde. Entregue" , 3,2,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Saldo"  		, 3,2,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Revisão"  		, 1,1,.F.)

				TRB1->(dbGoTop())

				While TRB1->(!EOF())

					_oFwMsEx:AddRow( _cWorkSheet, _cTable,{;
						TRB1->C6_NUM   						,;
						TRB1->C6_ITEM						,;
						TRB1->C5_EMISSAO					,;
						TRB1->C6_ENTREG						,;
						If(Empty(TRB1->C6_YDTFECH),TRB1->C6_ENTREG,TRB1->C6_YDTFECH)		,;
						TRB1->C6_PEDAMOS					,;
						TRB1->C6_QTDVEN						,;
						TRB1->C6_QTDENT						,;
						TRB1->C6_QTDVEN - TRB1->C6_QTDENT	,;
						TRB1->C6_REVPED						})

					TRB1->(dbSkip())
				EndDo
			Endif


			If _lClick2
				_cWorkSheet 	:= 	"NF Saida"
				_cTable 		:= 	"NF Saida"

				_oFwMsEx:AddWorkSheet( _cWorkSheet )
				_oFwMsEx:AddTable( _cWorkSheet, _cTable )

				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Tipo NF"   		, 1,1,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "NF"  			, 1,1,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Serie"  		, 1,1,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Emissão"  		, 1,4,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Quantidade"  	, 3,2,.T.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Vlr. Total"  	, 3,2,.T.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Proc. Embarque" , 1,1,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Revisão"  		, 1,1,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Dt. Embarque"  	, 1,1,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Via Transporte" , 1,1,.F.)
//				If !_cCliente $ '000017|000018'
				If !_lPO
					_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Ped. Cliente" 	, 1,1,.F.)
				ElseIf _cCliente = '000018'
					_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Status" 	, 1,1,.F.)
				Endif

				TRB2->(dbGoTop())

				While TRB2->(!EOF())

					_cVia 	:= ""
					_dSaida := ''
					_cStat  := ''

					EEC->(dbSetOrder(1))
					If EEC->(dbSeek(xFilial("EEC")+TRB2->D2_PREEMB))
						_cVia   := EEC->EEC_VIA
						_dSaida := DTOC(EEC->EEC_DTEMBA)
						_cStat  := AvTabela("YC",EEC->EEC_STATUS)

						SYQ->(dbSetOrder(1))
						SYQ->(dbSeek(xFilial("SYQ")+EEC->EEC_VIA))

						If Left(SYQ->YQ_COD_DI,1) = "4"
							_cVia := "Aereo"
						ElseIf Left(SYQ->YQ_COD_DI,1) = "1"
							_cVia := "Maritimo"
						Endif

					Endif

					If TRB2->D2_CLIENTE = "000017"
						If SF2->(dbSeek(xFilial("SF2")+TRB2->D2_DOC+TRB2->D2_SERIE))
							_dSaida := DTOC(SF2->F2_DTENTR)
						Endif
					Endif

//					If !_cCliente $ '000017|000018'
					If !_lPO
						_oFwMsEx:AddRow( _cWorkSheet, _cTable,{;
							TRB2->D2_TIPO   	,;
							TRB2->D2_DOC		,;
							TRB2->D2_SERIE		,;
							TRB2->D2_EMISSAO	,;
							TRB2->D2_QUANT		,;
							TRB2->D2_TOTAL		,;
							TRB2->D2_PREEMB		,;
							TRB2->D2_REVPED		,;
							_dSaida				,;
							_cVia				,;
							TRB2->D2_PEDCLI		})

					ElseIf _cCliente = '000018'

						_oFwMsEx:AddRow( _cWorkSheet, _cTable,{;
							TRB2->D2_TIPO   	,;
							TRB2->D2_DOC		,;
							TRB2->D2_SERIE		,;
							TRB2->D2_EMISSAO	,;
							TRB2->D2_QUANT		,;
							TRB2->D2_TOTAL		,;
							TRB2->D2_PREEMB		,;
							TRB2->D2_REVPED		,;
							_dSaida				,;
							_cVia				,;
							_cStat				})
					Else

						_oFwMsEx:AddRow( _cWorkSheet, _cTable,{;
							TRB2->D2_TIPO   	,;
							TRB2->D2_DOC		,;
							TRB2->D2_SERIE		,;
							TRB2->D2_EMISSAO	,;
							TRB2->D2_QUANT		,;
							TRB2->D2_TOTAL		,;
							TRB2->D2_PREEMB		,;
							TRB2->D2_REVPED		,;
							_dSaida				,;
							_cVia				})

					Endif

					TRB2->(dbSkip())
				EndDo
			Endif

			If _lClick3
				_cWorkSheet 	:= 	"NF Entrada"
				_cTable 		:= 	"NF Entrada"

				_oFwMsEx:AddWorkSheet( _cWorkSheet )
				_oFwMsEx:AddTable( _cWorkSheet, _cTable )

				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Tipo Docto."   	, 1,1,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "NF"  			, 1,1,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Serie"  		, 1,1,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Dt. Emissão"  	, 1,4,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Quantidade"  	, 3,2,.T.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Valor Total" 	, 3,2,.T.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "NF Original" 	, 1,1,.F.)
//				If !_cCliente $ '000017|000018'
				If !_lPO
					_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Ped. Cliente" 	, 1,1,.F.)
				Endif
				TRB3->(dbGoTop())

				While TRB3->(!EOF())

//					If !_cCliente $ '000017|000018'
					If !_lPO
						SD2->(dbsetOrder(3))
						SD2->(dbSeeK(xFilial("SD2")+TRB3->D1_NFORI+TRB3->D1_SERIORI+TRB3->D1_FORNECE+TRB3->D1_LOJA+TRB3->D1_COD+TRB3->D1_ITEMORI))

						_oFwMsEx:AddRow( _cWorkSheet, _cTable,{	TRB3->D1_TIPO,;
							TRB3->D1_DOC		,;
							TRB3->D1_SERIE		,;
							TRB3->D1_EMISSAO	,;
							TRB3->D1_QUANT * -1	,;
							TRB3->D1_TOTAL		,;
							TRB3->D1_NFORI		,;
							SD2->D2_PEDCLI		})
					Else
						_oFwMsEx:AddRow( _cWorkSheet, _cTable,{	TRB3->D1_TIPO,;
							TRB3->D1_DOC		,;
							TRB3->D1_SERIE		,;
							TRB3->D1_EMISSAO	,;
							TRB3->D1_QUANT * -1	,;
							TRB3->D1_TOTAL		,;
							TRB3->D1_NFORI		})

					Endif

					TRB3->(dbSkip())
				EndDo
			Endif


			If _lClick4
				_cWorkSheet 	:= 	"Ajuste Acumulado"
				_cTable 		:= 	"Ajuste Acumulado"

				_oFwMsEx:AddWorkSheet( _cWorkSheet )
				_oFwMsEx:AddTable( _cWorkSheet, _cTable )

				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Tipo Movimento" , 1,1,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "NF"  			, 1,1,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Dt. Ajuste"  	, 1,4,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Quantidade"  	, 3,2,.T.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Motivo" 		, 1,1,.F.)

				TRB4->(dbGoTop())

				While TRB4->(!EOF())

					If Empty(TRB4->ZD_MOTIVO)
						_cAcerto := "ACERTO DE LANCAMENTO"
					Else
						_cAcerto := TRB4->ZD_MOTIVO
					Endif

					_cTpAj := ''
					_nQuan := 0
					If TRB4->ZD_TIPO = '1'
						_cTpAj := 'Soma'
						_nQuan := TRB4->ZD_QUANT
					ElseIf  TRB4->ZD_TIPO = '2'
						_cTpAj := 'Subtrai'
						_nQuan := TRB4->ZD_QUANT * -1
					Endif

					_oFwMsEx:AddRow( _cWorkSheet, _cTable,{;
						_cTpAj			   	,;
						TRB4->ZD_DOC		,;
						TRB4->ZD_DATA		,;
						_nQuan				,;
						_cAcerto			})

					TRB4->(dbSkip())
				EndDo
			Endif

			If _lClick5
				_cWorkSheet 	:= 	"Programacoes"
				_cTable 		:= 	"Programacoes"

				_oFwMsEx:AddWorkSheet( _cWorkSheet )
				_oFwMsEx:AddTable( _cWorkSheet, _cTable )

				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Data Pedido" 	, 1,4,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Tipo"  			, 1,1,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "NF" 			, 1,1,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Serie NF"  		, 1,1,.T.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "DT. Ult. NF"  	, 1,4,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Qtde NF"  		, 3,2,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "DT. Entrega"  	, 1,4,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "DT. Fechamento" , 1,4,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Qtde Entrega"  	, 3,2,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Acumulado"  	, 3,2,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Arquivo"		, 1,1,.F.)

				TRB5->(dbGoTop())

				While TRB5->(!EOF())

					_oFwMsEx:AddRow( _cWorkSheet, _cTable,{;
						TRB5->Z4_DTDIGIT	,;
						TRB5->Z4_TPPED		,;
						TRB5->Z4_ULTNF		,;
						TRB5->Z4_SERIE		,;
						TRB5->Z4_DTULTNF	,;
						TRB5->Z4_ULQTENF	,;
						TRB5->Z4_DTENT		,;
						If(!Empty(TRB5->Z4_DTFECH),TRB5->Z4_DTFECH,TRB5->Z4_DTENT)	,;
						TRB5->Z4_QTENT		,;
						TRB5->Z4_QTACUM		,;
						TRB5->Z4_NOMARQ		})

					TRB5->(dbSkip())
				EndDo
			Endif

			_oFwMsEx:Activate()

			cArq := CriaTrab( NIL, .F. ) + ".xls"

			LjMsgRun( "Gerando o arquivo, aguarde...", "Pedido de Compras", {|| _oFwMsEx:GetXMLFile( cArq ) } )

			If __CopyFile( cArq, cDirTmp + cArq )
				oExcelApp := MsExcel():New()
				oExcelApp:WorkBooks:Open( cDirTmp + cArq )
				oExcelApp:SetVisible(.T.)
			Else
				MsgInfo( "Arquivo não copiado para temporário do usuário." )

				oExcelApp := MsExcel():New()
				oExcelApp:WorkBooks:Open( cDir + cArq )
				oExcelApp:SetVisible(.T.)
			Endif

		Else
			MsgAlert('Nenhuma informação selecionada!')
		Endif
	Endif
Return
