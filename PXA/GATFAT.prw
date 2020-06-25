#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Gatilho		: GFAT001
Autor		: Newton Macedo
Data		: 29/05/2015
Descrição	: Atualizar o campo Preço de venda no pedido de venda (C6_PRCVEN)
*/

User Function GFAT001()
	
	_aAliOri   := GetArea()
	_aAliSA1   := SA1->(GetArea())
	_aAliSC5   := SC5->(GetArea())
	_aAliSC6   := SC6->(GetArea())
	_aAliDA1   := DA1->(GETAREA())
	_cCliente  := M->C5_CLIENTE
	_cLoja     := M->C5_LOJACLI
	
	_nPProd    := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRODUTO" 	} )
	_nPrcVen   := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRCVEN" 	} )
	_nPrList   := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRUNIT" 	} )
	_nPValor   := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_VALOR" 	} )
	_nPQuant   := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_QTDVEN" 	} )
	
	
	_nQuant    :=Acols[n][_nPQuant]
	_cProduto  :=Acols[n][_nPProd]
	
	_cTabela := Posicione("SA1",1,xFilial("SA1")+_cCliente+_cLoja,"A1_TABELA")
	
	DA1->(DbSetOrder(1))
	If	DA1->(DbSeek(xFilial("DA1")+_cTabela+Acols[n,_nPProd]))
		Acols[n][_nPrcVen] 	:= DA1->DA1_PRCVEN
		Acols[n][_nPrList] 	:= DA1->DA1_PRCVEN
		
		_nDesItem          	:= 0
		
	Else
		Alert("Produto não encontrado na Tabela de Preço!")
		Acols[n][_nPrcVen] := 0
		Acols[n][_nPrList] := 0
		_nPrVen 		   := 0
		aCols[N][_nPProd]   := Space(15)
	EndIf
	
	Acols[n][_nPValor] := Round(_nQuant * Acols[n][_nPrcVen],2)
	
	RestArea(_aAliSA1)
	RestArea(_aAliSC5)
	RestArea(_aAliSC6)
	RestArea(_aAliDA1)
	
Return(_cProduto)



/*
Gatilho		: GFAT002
Autor		: Fabiano
Data		: 12/06/2015
Descrição	: Análise quantidade a faturar
*/
User Function GFAT002()
	
	_aAliOri   := GetArea()
	_aAliSC5   := SC5->(GetArea())
	_aAliSC6   := SC6->(GetArea())
	
	_nPITEM    := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_ITEM" 	} )
	_nPQTDVEN  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_QTDVEN" 	} )
	_nPQTDLIB  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_QTDLIB" 	} )
	_nPPESO    := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_YPESLIQ" 	} )
	
	_nQtVen    :=Acols[n][_nPQTDVEN]
	_nQtLib    :=Acols[n][_nPQTDLIB]
	_nPeso     :=Acols[n][_nPPESO]
	_cItem     :=Acols[n][_nPITEM]
	
	SC6->(dbSetOrder(1))
	If SC6->(msSeek(xFilial('SC6')+SC5->C5_NUM+_cItem))
		If !Empty(SC6->C6_NUMORC)
			IF _nQtLib > 0 .And. _nQtLib < _nQtVen
				MsgAlert("Quantidade liberada menor que a quantidade do Pedido, Liberação não permitida!")
				_nQtLib := 0
			Endif
			
			If _nQtLib > 0 .and. _nPeso = 0
				If MsgAlert("Produto sem Pesagem, Liberação não permitida!")
					_nQtLib := 0
				Endif
			Endif
		Endif
		
	Endif
	
	RestArea(_aAliSC5)
	RestArea(_aAliSC6)
	RestArea(_aAliOri)
	
Return(_nQtLib)



/*
Gatilho		: GFAT003
Autor		: Fabiano
Data		: 18/06/2015
Descrição	: Alteração dos campos C6_PRODUTO, C6_QUANT e C6_PRCVEN
*/
User Function GFAT003(_cField)
	
	_aAliOri   	:= GetArea()
	_aAliSC5   	:= SC5->(GetArea())
	_aAliSC6   	:= SC6->(GetArea())
	
	_nPField  	:= aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == _cField 		} )
	_nPItem  	:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_ITEM"  	} )
	_nPProd  	:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRODUTO"	} )
	_nPUM  		:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_UM"  	} )
	_nPPrcV  	:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRCVEN" 	} )
	_nPQtdV  	:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_QTDVEN"	} )
	_nPValo  	:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_VALOR"	} )
	_nPTES  	:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_TES"		} )
	_nPOPER  	:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_OPER"	} )
	
	_cRet    	:= aCols[n][_nPField]
	_cTes       := aCols[n][_nPTES]
	_cProd      := aCols[n][_nPProd]
	_cOper		:= "01"
	
	SFM->(dbSetOrder(1))
	If SFM->(msSeek(xFilial("SFM") + _cOper + _cProd + M->C5_CLIENTE + M->C5_LOJACLI ))
		If !Empty(SFM->FM_TS)
			aCols[n][_nPTES]	:= SFM->FM_TS
			aCols[n][_nPOPER]	:= _cOper
		Endif
	Endif
	
	/*
	If Empty(_cTes)
		_cOper		:= "01"
		_cTES 		:= MaTesInt(2,_cOper,M->C5_CLIENTE,M->C5_LOJACLI,"C",_cProd,Nil)
		
		aCols[n][_nPTES] 	:= _cTES
		aCols[n][_nPOPER] 	:= _cOper
	Endif
	*/
	If Inclui
		_cPedido := M->C5_NUM
	Else
		_cPedido := SC5->C5_NUM
	Endif
	
	SC6->(dbSetOrder(1))
	If SC6->(msSeek(xFilial('SC6')+_cPedido+aCols[n][_nPItem]))
		If !Empty(SC6->C6_NUMORC)
			MsgAlert('Este campo não pode ser alterado, pois está vinculado à um Orçamento!')
			_cRet := &("SC6->"+_cField)
			aCols[n][_nPProd] 	:= SC6->C6_PRODUTO
			aCols[n][_nPUM] 	:= SC6->C6_UM
			aCols[n][_nPPrcV] 	:= SC6->C6_PRCVEN
			aCols[n][_nPQtdV] 	:= SC6->C6_QTDVEN
			aCols[n][_nPValo] 	:= SC6->C6_VALOR
			aCols[n][_nPTES] 	:= SC6->C6_TES
		Endif
	Endif
	
	If _cField == 'C6_PRODUTO'
		If SC6->(msSeek(xFilial('SC6')+_cPedido+aCols[1][_nPItem]))
			If !Empty(SC6->C6_NUMORC)
				MsgAlert('Não é possível adicionar novas linnhas neste Pedido, pois o mesmo está vinculado à um Orçamento!')
				_cRet := Space(15)
			Endif
		Endif
		
		SA1->(dbSetOrder(1))
		If SA1->(msSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))
			
			_cEst    := SA1->A1_EST
			_cCodMun := SA1->A1_COD_MUN
			
			If !Empty(SA1->A1_YUFENT) .And. !Empty(SA1->A1_YMUNENT)
				_cEst    := SA1->A1_YUFENT
				_cCodMun := SA1->A1_YMUNENT
			Endif
			
			SZL->(dbSetOrder(1))
			If SZL->(msSeek(xFilial("SZL")+_cEst+_cCodMun+M->C5_YTPCAR+M->C5_TRANSP+Left(Acols[N][_nPProd],4)))
				If M->C5_YFRETE <> SZL->ZL_VALFRET
					M->C5_YFRETE := SZL->ZL_VALFRET
					M->C5_FRETE  := SZL->ZL_VALFRET
					MsgInfo('Valor do Frete Atualizado, conforme a tabela de Frete.!')
				Endif
			Endif
		Endif
	Endif
	
	RestArea(_aAliSC5)
	RestArea(_aAliSC6)
	RestArea(_aAliOri)
	
Return(_cRet)



/*
Gatilho		: GFAT004
Autor		: Fabiano
Data		: 20/06/2015
Descrição	: Preenchimento CK_OPER e CK_TES
*/
User Function GFAT004()
	
	_aAliOri   	:= GetArea()
	_aAliSCK   	:= SCK->(GetArea())
	_aAliSCJ   	:= SCJ->(GetArea())
	
	_cOper		:= "01"
	_cProd		:= TMP1->CK_PRODUTO
	_cTES 		:= MaTesInt(2,_cOper,M->CJ_CLIENTE,M->CJ_LOJA,"C",_cProd,Nil)
	
	If !Empty(_cTes)
		//		aCols[n][_nPTES] := _cTES
		TMP1->CK_TES := _cTES
	ELSE
		_cOper := Space(2)
	Endif
	
	RestArea(_aAliSCJ)
	RestArea(_aAliSCK)
	RestArea(_aAliOri)
	
Return(_cOper)



/*
Gatilho		: GFAT005
Autor		: Fabiano
Data		: 26/06/2015
Descrição	: Checagem Cliente
*/
User Function GFAT005()
	
	_aAliOri   	:= GetArea()
	_aAliSUS   	:= SUS->(GetArea())
	_aAliSA1   	:= SA1->(GetArea())
	
	If Inclui
		_cAlias := 'M'
	Else
		_cAlias := 'SUS'
	Endif
	
	_cCGC := M->US_CGC
	
	If !Empty(_cCGC)
		M->US_STATUS  := "6"
		M->US_CODCLI  := SA1->A1_COD
		M->US_LOJACLI := SA1->A1_LOJA
		M->US_DTCONV  := dDatabase //database do sistema
	Else
		M->US_STATUS  := "1"
		M->US_CODCLI  := Space(6)
		M->US_LOJACLI := Space(2)
		M->US_DTCONV  := ctod('')
	Endif
	
	RestArea(_aAliSA1)
	RestArea(_aAliSUS)
	RestArea(_aAliOri)
	
Return(_cCGC)



/*
Gatilho		: GFAT005
Autor		: Fabiano
Data		: 01/07/2015
Descrição	: Inclusão de Pedido de Vendas
*/
User Function GFAT006(_cField)
	
	_aAliOri   	:= GetArea()
	_aAliSC5   	:= SC5->(GetArea())
	
	_cRet := &("M->"+_cField)
	
	_lRet2 := .T.
	If M->C5_TIPO = 'N'
		_lRet2 := U_PXH042("C5_CLIENTE",6,.F.)
	Endif
	
	If !_lRet2
		MsgAlert("Usuário não pode incluir pedido do tipo 'N'(Normal)!"+CRLF+CRLF+"Utilize a rotina de Orçamento!")
		If _cField = "C5_CLIENTE"
			M->C5_LOJACLI := Space(2)
		Endif
		RestArea(_aAliSC5)
		RestArea(_aAliOri)
		Return(Space(TamSx3(_cField)[1]))
	Endif
	
	If M->C5_TIPO = 'N'
		ZA6->(dbSetOrder(1))
		If !ZA6->(dbSeek(xFilial("ZA6") + M->C5_CLIENTE + M->C5_LOJACLI + "L"))
			MsgAlert('Cliente sem Limite de Crédito cadastrado!'+CRLF+CRLF+;
				'Contate o setor Financeiro!')
			If _cField = "C5_CLIENTE"
				M->C5_LOJACLI := Space(2)
			Endif
			RestArea(_aAliSC5)
			RestArea(_aAliOri)
			Return(Space(TamSx3(_cField)[1]))
		EndIf
		
		SA1->(dbSetOrder(1))
		SA1->(msSeek(xFilial("SA1")+M->C5_CLIENTE + M->C5_LOJACLI))
		
		If _cField = "C5_CLIENTE"
			M->C5_LOJACLI := Space(2)
		ElseIf _cField = "C5_LOJACLI"
			Private _n2PProd	:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRODUTO"	} )
			
			_n2OpEf   := 0
			
			Private _o2Efet     := _o2CodCli := _o2NomCli := _o2CodTra := _o2NomTra := _o2TpCar := _o2NTpCar := _o2VlFret := _o2Combo := Nil
			Private _c2CodCli   := M->C5_CLIENTE+'/'+M->C5_LOJACLI
			Private _c2NomCli   := SA1->A1_NOME
			Private _c2PECodTra := Space(TamSX3("A4_COD")[1])
			Private _c2NomTra   := Space(TamSX3("A4_NOME")[1])
			Private _c2NTpCar   := Space(TamSX3("X5_DESCRI")[1])
			Private _c2PETpCar  := Space(TamSX3("ZL_TPCAR")[1])
			Private _n2PEVlFret := 0
			Private _c2Combo    := ''
			Private _l2When     := .T.
			
			_a2Combo := {"C=CIF","F=FOB"}
			
			DEFINE MSDIALOG _o2Efet FROM 00, 00 TO 220,440 TITLE "Dados Orçamento" Of _o2Efet PIXEL Style DS_MODALFRAME
			
			_o2Efet:lEscClose := .F.
			
			@ 005,005 TO 088,215 LABEL "" OF _o2Efet PIXEL
			
			@ 07,010 Say "Preencha abaixo as informações necessárias referente ao Frete:" 						OF _o2Efet PIXEL
			
			@ 20,010 Say "Tipo Frete:" OF _o2Efet PIXEL
			@ 20,055 MSCOMBOBOX _o2Combo VAR _c2Combo ITEMS _a2Combo	Valid(CheckEfet("F"))	SIZE 050, 007 	OF _o2Efet PIXEL
			
			@ 33,010 Say "Cliente: "															Size 050, 007 	OF _o2Efet PIXEL
			@ 33,055 MsGet _o2CodCli VAR _c2CodCli   When .F.									Size 050, 007 	OF _o2Efet PIXEL
			@ 33,110 MsGet _o2NomCli VAR _c2NomCli   When .F.									Size 100, 007 	OF _o2Efet PIXEL
			
			@ 46,010 Say "Transportadora: "														Size 050, 007 	OF _o2Efet PIXEL
			@ 46,055 MsGet _o2CodTra VAR _c2PECodTra   When _l2When F3 "SA4" Valid(CheckEfet("T"))Size 050, 007 	OF _o2Efet PIXEL
			@ 46,110 MsGet _o2NomTra VAR _c2NomTra   When .F.									Size 100, 007 	OF _o2Efet PIXEL
			
			@ 59,010 Say "Tipo Carro: "															Size 050, 007 	OF _o2Efet PIXEL
			@ 59,055 MsGet _o2TpCar  VAR _c2PETpCar  When _l2When F3 "MU" Valid(CheckEfet("C"))	Size 050, 007 	OF _o2Efet PIXEL
			@ 59,110 MsGet _o2NTpCar VAR _c2NTpCar   When .F.									Size 050, 007 	OF _o2Efet PIXEL
			
			@ 72,010 Say "Valor Frete: "														Size 050, 007 	OF _o2Efet PIXEL
			@ 72,055 MsGet _o2VlFret VAR _n2PEVlFret  When .F.	Picture "@e 9,999,999.999"		Size 050, 007 	OF _o2Efet PIXEL
			
			@ 93,010 BUTTON "OK" 			SIZE 036,012 ACTION ;
				(If((Left(_c2Combo,1) = 'F') .Or. (_n2PEVlFret > 0 .And. Left(_c2Combo,1) = 'C'),(_n2OpEf:=1,_o2Efet:END()),;
				MsgAlert("Valor do Frete zerado, favor verificar a tabela de Frete!"))) OF _o2Efet PIXEL
			
			@ 93,070 BUTTON "Cancelar"		SIZE 036,012 ACTION  (_n2OpEf:=2,_o2Efet:END()) OF _o2Efet PIXEL
			
			ACTIVATE DIALOG _o2Efet CENTERED
			
			If _n2OpEf <> 1
				MsgAlert("Não é possível inclusão do Pedido sem o valor do frete.")
				RestArea(_aAliSC5)
				RestArea(_aAliOri)
				If _cField = "C5_CLIENTE"
					M->C5_LOJACLI := Space(2)
				Endif
				Return(Space(TamSx3(_cField)[1]))
			Else
				M->C5_YTPCAR  := _c2PETpCar
				M->C5_YFRETE  := _n2PEVlFret
				M->C5_FRETE   := _n2PEVlFret
				M->C5_TRANSP  := _c2PECodTra
				M->C5_TPFRETE := Left(_c2Combo,1)
				
			Endif
		Endif
	Endif
	
	RestArea(_aAliSC5)
	RestArea(_aAliOri)
	
Return(_cRet)



Static Function CheckEfet(_cOpc)
	
	Local _lRet 	:= .T.
	
	If _cOpc $ ("T|C")
		If _cOpc = ("T")
			If !Empty(_c2PECodTra)
				SA4->(dbSetOrder(1))
				If SA4->(msSeek(xFilial("SA4")+_c2PECodTra))
					_c2NomTra := SA4->A4_NOME
				Else
					MsgAlert("Transportadora não encontrada!")
					_c2NomTra := Space(TamSX3("A4_NOME")[1])
					_lRet := .F.
				Endif
			Endif
		ElseIf _cOpc = "C"
			If !Empty(_c2PETpCar)
				SX5->(dbSetOrder(1))
				If SX5->(msSeek(xFilial("SX5")+"MU"+_c2PETpCar))
					_c2NTpCar := Alltrim(SX5->X5_DESCRI)
				Else
					MsgAlert("Tipo de Veículo não encontrado!")
					_c2NTpCar := Space(TamSX3("X5_DESCRI")[1])
					_lRet := .F.
				Endif
			Endif
		Endif
		
		_n2PEVlFret := 0
		
		_cEst    := SA1->A1_EST
		_cCodMun := SA1->A1_COD_MUN
		
		If !Empty(SA1->A1_YUFENT) .And. !Empty(SA1->A1_YMUNENT)
			_cEst    := SA1->A1_YUFENT
			_cCodMun := SA1->A1_YMUNENT
		Endif
		
		SZL->(dbSetOrder(1))
		If SZL->(msSeek(xFilial("SZL")+_cEst+_cCodMun+_c2PETpCar+_c2PECodTra+Left(Acols[1][_n2PProd],4)))
			_n2PEVlFret := SZL->ZL_VALFRET
		Else
			SZL->(dbSetOrder(1))
			If SZL->(msSeek(xFilial("SZL")+_cEst+_cCodMun+_c2PETpCar+_c2PECodTra))
				_n2PEVlFret := SZL->ZL_VALFRET
			Endif
		Endif
		
	ElseIf _cOpc = "F"
		
		If Left(_c2Combo,1) = 'C'
			_l2When := .T.
		Else
			_c2PECodTra := Space(TamSX3("A4_COD")[1])
			_c2NomTra   := Space(TamSX3("A4_NOME")[1])
			_c2NTpCar   := Space(TamSX3("X5_DESCRI")[1])
			_c2PETpCar  := Space(TamSX3("ZL_TPCAR")[1])
			_n2PEVlFret := 0
			_l2When := .F.
		Endif
		
	Endif
	
	_o2Combo:Refresh()
	_o2CodTra:Refresh()
	_o2NomTra:Refresh()
	_o2TpCar:Refresh()
	_o2NTpCar:Refresh()
	_o2VlFret:Refresh()
	
Return(_lRet)
