#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
Funçao    	³ SF2460I - Ponto de Entrada para envio de ASN
Autor 		³ Fabiano da Silva
Data 		³ 04.07.12
Descricao 	³ ASN Caterpillar Brasil(000017)
*/

User Function SF2460I()

	Private _cCATFold	:= GetMV("CR_CATFOLD")

	_aAliori := GetArea()
	_aAliSD2 := SD2->(GetArea())
	_aAliSF4 := SF4->(GetArea())
	_aAliSX6 := SX6->(GetArea())
	_aAliSA1 := SA1->(GetArea())
	_aAliSE1 := SE1->(GetArea())
	_aAliSX5 := SX5->(GetArea())
	_aAliSZ2 := SZ2->(GetArea())
	_aAliSAH := SAH->(GetArea())
	_aAliSC6 := SC6->(GetArea())
	_aAliSB1 := SB1->(GetArea())

	If SF2->F2_CLIENTE == "000017"
		//GeraCat()
	ElseIf SF2->F2_CLIENTE $ ("000051|000021") //CNH e Iveco
		//	ElseIf SF2->F2_CLIENTE $ ("000025|000021") //CNH e Iveco
		GERATRB(1)
	Endif

	If SF2->F2_TIPO = 'N'
		SA1->(dbSetOrder(1))
		If SA1->(MsSeek(xFilial("SA1")+SF2->F2_CLIENTE + SF2->F2_LOJA))
			If SA1->A1_XCERTIF = 'S'
				GERATRB(2)
			Endif
		Endif
	Endif

Return


Static Function GeraCat()

	Private _cEOL    := "CHR(13)+CHR(10)"

	If Empty(_cEOL)
		_cEOL := CHR(13)+CHR(10)
	Else
		_cEOL := Trim(_cEOL)
		_cEOL := &_cEOL
	Endif

	_cLin    := Space(128) + _cEOL

	Private _cLin, _cCpo, _cCGCCron,_cCGCCli,_cUM, _cIdenti,_cTpForn,_cIdent
	Private _cIdenti    := "000"
	Private _cSeqv      := "00000"
	Private _cSeqR      := "00000"
	Private _dVencto    := "000000"
	Private _cDescCFO   := space(15)
	Private _cClasFis   := space(10)
	Private _nTamLin    := 128
	Private _nItem, _cDescCFO,_cRev,_nContLiV, _nContLiR, _nSomaTot
	Private _cRev       := "0000"
	Private _cItemOri   := space(3)
	Private _cDtori     := space(6)
	Private _cCodFab    := space(3)
	Private _cPO        := Space(4)

	_lAchouV   := .F.
	_lAchouR   := .F.
	_nContLiV  := 0
	_nContLiR  := 0
	_nSomaTot  := 0

	_lEncontV  := .t.
	_lEncontR  := .t.

	dbSelectArea("SD2")
	dbOrderNickName("INDSD24")
	If dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)

		_cChavSD2    := SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
		_nQtdItem    := 0
		_lRetorno    := .F.
		_lVenda      := .F.
		While !Eof() .And. _cChavSD2 == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA

			_nQtdItem ++
			_cCfo  := SD2->D2_CF                           // Codigo de Operaçao           (5) M

			If SD2->D2_TIPO == "D"
				_lRetorno := .T.
				_lAchouR  := .T.
			Else
				dbSelectArea("SF4")
				dbSetOrder(1)
				If dbSeek(xFilial("SF4")+SD2->D2_TES)
					If SF4->F4_PODER3 == "D"
						_lRetorno := .T.
						_lAchouR  := .T.
					Else
						_lVenda  := .T.
						_lAchouV := .T.
					Endif
				Endif
			Endif
			_cCfo1 := SD2->D2_CF                           // Codigo de Operaçao           (4) M

			_cPO   := SD2->D2_PEDCLI                        // PO           (4) M

			dbSelectArea("SD2")
			dbSkip()
		EndDo
	Endif
	_cQtdItem    := strZero(_nQtdItem,3)                             // Qtde de itens a N.F.         (3) M

	If _lVenda
		// Notas Fiscais de Venda

		Private _cCgc2    := SM0->M0_CGC
		Private _cData2   := GravaData(dDataBase,.f.,8)

		_NN:= 0
		For ZZ:= 1 to 100
			_NN++
		Next ZZ

		Private _cHora2   := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
		//	Private _cArqTxtV := "F:\EDI\WIDESOFT\CATER\SAIDA\61064911000177_RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT"
		Private _cArqTxtV := _cCATFold+"Brasil\SAIDA\61064911000177_RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT"
		Private _nHdlV    := MSFCreate(_cArqTxtV)

		If _nHdlV == -1
			MsgAlert("O arquivo de nome "+_cArqTxtV+" nao pode ser executado!","Atencao!")
			fClose(_nHdlV)
			Return
		Endif

		GeraVenda()

		If _lAchouV
			_nContLiV++
			_cContLI  := StrZero(_nContLiV,9)                           // Numero de Controle             (9)  M
			_cSomaTot := StrZero(Int(_nSomaTot *100),17)               // Soma Total das N.Fiscais       (12) M
			_cCpo := "FTP"+ _cSeqv + _cContLi + _cSomaTot + "D" + sPace(93)

			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo FTP). Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif
		Endif

		fClose(_nHdlV)

		__CopyFile(_cCATFold+"BRASIL\SAIDA\61064911000177_RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT", _cCATFold+"Brasil\SAIDA\BKP\61064911000177_RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT")
	Else
		// - Notas Fiscais de Retorno

		Private _cCgc2    := SM0->M0_CGC
		Private _cData2   := GravaData(dDataBase,.f.,8)
		Private _cHora2   := Substr(Time(),1,2) + Substr(Time(),4,2) + strzero(Val(Substr(Time(),7,2))+1,2)
		//	Private _cArqTxtR := "F:\EDI\WIDESOFT\CATER\SAIDA\61064911000177_RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT"
		Private _cArqTxtR := _cCATFold+"BRASIL\SAIDA\61064911000177_RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT"

		Private _nHdlR    := MSfCreate(_cArqTxtR)

		If _nHdlR == -1
			MsgAlert("O arquivo de nome "+_cArqTxtR+" 2 nao pode ser executado!","Atencao!")
			fClose(_nHdlR)
			Return
		Endif

		GeraRet()

		If _lAchouR
			_nContLiR++
			_cContLI  := StrZero(_nContLiR,9)                           // Numero de Controle             (9)  M
			_cSomaTot := StrZero(Int(_nSomaTot *100),17)               // Soma Total das N.Fiscais       (12) M
			_cCpo := "FTP"+ _cSeqR + _cContLi + _cSomaTot + "D" + sPace(93)

			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

			If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo FTP). Continua?","Atencao!")
					fClose(_nHdlR)
					Return
				Endif
			Endif
		Endif

		fClose(_nHdlR)
	Endif

	RestArea(_aAliSD2)
	RestArea(_aAliSF4)
	RestArea(_aAliSX6)
	RestArea(_aAliSA1)
	RestArea(_aAliSE1)
	RestArea(_aAliSX5)
	RestArea(_aAliSZ2)
	RestArea(_aAliSAH)
	RestArea(_aAliSB1)
	RestArea(_aAliSC6)
	RestArea(_aAliori)

Return


Static Function GeraVenda()

	If _lEncontV
		_lEncontV := .F.
		_cLin    := Space(128) + _cEOL
		_cSeqv    := GetMv("MV_NUMCAT")
		dbSelectArea("SX6")
		RecLock("SX6",.F.)
		SX6->X6_CONTEUD := StrZero((Val(_cSeqv)+1),5)
		MsUnlock()

		_dData := GravaData(dDataBase,.f.,4)
		_cHora := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
		_cCgcCron  := SM0->M0_CGC
		_cNomCron  := Substr(SM0->M0_NOMECOM,1,25)

		dbSelectArea("SA1")
		dbSetOrder(1)
		If dbseek(xFilial("SA1")+ SF2->F2_CLIENTE + SF2->F2_LOJA)
			_cCGCCli  := SA1->A1_CGC
			_cNomCli  := Substr(SA1->A1_NOME,1,25)
		Endif

		_cCodCli := Space(8) //SF2->F2_CLIENTE+SF2->F2_LOJA
		//                              (5)     (6)      (6)      (14)        (14)         (8)         (8)         (25)        (25)
		_cCpo    := "ITP00418" + _cSeqv + _dData + _cHora + _cCgcCron + _cCGCCli + "Q3820C0 " + _cCodCli + _cNomCron + _cNomCli + space(9)
		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
		_nContLiV++
		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif
	Endif

	_cLin     := Space(128)+_cEOL
	_cNf      := STRZERO(val(SF2->F2_DOC),6)                            // Numero da nota Fiscal        (6) M
	_cSer     := SF2->F2_SERIE + SPACE(1)                            	// Serie da Nota Fiscal         (4) M
	_dDataNf  := GravaData(SF2->F2_EMISSAO,.f.,4)                   	// Data De Emissao da N.F.      (6) M
	_cVlTotal := StrZero(Int(SF2->F2_VALBRUT*100),17)                	// Valor Total                  (17)M
	_nQtdCD   := "0"                                                 	// Quantidade de Casas Decimais (1) M
	_nSomaTot += SF2->F2_VALBRUT
	_cVlICMS  := StrZero(Int(SF2->F2_VALICM*100),17)                 	// Valor Total do ICMS          (17)M

	dbSelectArea("SE1")
	dbSetOrder(1)
	If dbSeek(xFilial("SE1")+ SF2->F2_SERIE + SF2->F2_DOC + " NF ")
		_dVencto := GravaData(SE1->E1_VENCREA,.f.,4)                 	// Data do Vencimento           (6) M
	Endif

	_cEspecie := "02" //Substr(SF2->F2_ESPECIE,1,2)                 	// Especie                      (2) M
	_cVlIPI   := StrZero(Int(SF2->F2_VALIPI*100),17)                 	// Valor Total do IPI           (17)M

	If Left(_cPO,4) = 'QAPC'
		_cCodFab  := "010"                                          		// Codigo da Fabrica Destino    (3) O
	ElseIf Left(_cPO,4) = 'QEST'
		_cCodFab  := "081"                                          		// Codigo da Fabrica Destino    (3) O
	ElseIf Left(_cPO,4) = 'HETZ'
		_cCodFab  := "081"                                          		// Codigo da Fabrica Destino    (3) O
	Else
		_cCodFab  := "028"                                          		// Codigo da Fabrica Destino    (3) O
	Endif

	If SF2->F2_LOJA = '03'
		_cCodFab  := "050"                                          		// Codigo da Fabrica Destino    (3) O
	Endif

	_dDtPrev  := GravaData(SF2->F2_EMISSAO,.f.,4)                   	// Data De Previsao de Entrega  (6) O
	_cPerEnt  := space(4)                                            	// Periodo da Entrega           (4) O

	dbSelectArea("SX5")
	dbSetOrder(1)
	If dbSeek(xFilial("SX5")+"13"+ _cCFO + sPace(1))
		_cDescCFO := SUBSTR(SX5->X5_DESCRI,1,15)                      	// Descricao do CFOP            (15)O
	Endif

	//	_dDtPrev  := GravaData(SF2->F2_EMISSAO,.f.,4)                   	// Data Do Embarque             (6) M
	_dDtPrev  := GravaData(dDataBase,.f.,4)
	_cHora    := Substr(SF2->F2_HORA,1,2)+ Substr(SF2->F2_HORA,4,2)  	// Hora / Minuto do Embarque    (4) M

	_cCpo    := "AE1" + _cNf + _cSer + _dDataNF + _cQtdItem + _cVlTotal + _nQtdCD + STRZERO(VAL(_cCFO),5) + _cVlICMS + _dVencto + _cEspecie + _cVlIPI + ;
	_cCodFab + _dDtPrev + _cPerEnt + _cDescCFO + _dDtPrev + _cHora + SPACE(3)
	_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	_nContLiV++

	If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE1).  Continua?","Atencao!")
			fClose(_nHdlV)
			Return
		Endif
	Endif

	// - NF2

	_cDespAce := StrZero(Int(SF2->F2_DESPESA*100),12)             // Valor das Despesas Acessoriais  (12)  O
	_cFrete   := StrZero(Int(SF2->F2_FRETE*100),12)               // Valor do Frete                  (12)  O
	_cSeguro  := StrZero(Int(SF2->F2_SEGURO*100),12)              // Valor do Seguro                 (12)  O
	_cDescon  := StrZero(Int(SF2->F2_DESCONT*100),12)             // Valor do Desconto da N.F.       (12)  O
	_cBaseICMS:= StrZero(Int(SF2->F2_BASEICM*100),12)             // Valor do Desconto da N.F.       (12)  O
	_cICMS    := StrZero(Int(SF2->F2_VALICM*100),12)              // Valor do Desconto da N.F.       (12)  O
	_cNumero  := "000000" //SF2->F2_DOC                           // NUmero da N.Fiscal de Venda     (6)   O
	_cDtEmis  := "000000" //GravaData(SF2->F2_EMISSAO,.f.,4)      // Data de Emissao                 (6)   O
	_cSerie   := space(4) //SF2->F2_SERIE+" "                     // Serie da N.Fiscal               (4)   O
	_cCodFab  := space(3)

	_cCpo := "NF2"+ _cDespAce + _cFrete + _cSeguro + _cDescon + _cBaseICMS + _cICMS + _cNumero + _cDtEmis + _cSerie + _cCodFab + STRZERO(VAL(_cCFO),5) + space(29)

	_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	_nContLiV++

	If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo NF2). Continua?","Atencao!")
			fClose(_nHdlV)
			Return
		Endif
	Endif


	// - NF5

	_cAliIRRF:= Repl("0",4)                                       // Aliquota do IRRF                (17)  O
	_cBaseIRRF:= Repl("0",17)                                     // Valor Base IRRF                 (17)  O
	_cIRRF    := Repl("0",17)                                     // Valor Base IRRF                 (17)  O
	_cAliISS  := Repl("0",4)                                      // Aliquota Do ISS                 (17)  O
	_cBaseISS := StrZero(Int(SF2->F2_BASEISS*100),17)             // Valor Base ISS                  (17)  O
	_cISS     := StrZero(Int(SF2->F2_VALISS*100),17)              // Valor ISS                       (17)  O
	_cBaseINSS:= StrZero(Int(SF2->F2_BASEINS*100),17)             // Valor Base INSS                  (17)  O
	_cINSS    := StrZero(Int(SF2->F2_VALINSS*100),17)             // Valor INSS                       (17)  O

	_cFrete   := StrZero(Int(SF2->F2_FRETE*100),17)               // Valor do Frete                  (17)  O
	_cSeguro  := StrZero(Int(SF2->F2_SEGURO*100),17)              // Valor do Seguro                 (17)  O
	_cDescon  := StrZero(Int(SF2->F2_DESCONT*100),17)             // Valor do Desconto da N.F.       (17)  O
	_cBaseICMS:= StrZero(Int(SF2->F2_BASEICM*100),17)             // Valor do Desconto da N.F.       (17)  O
	_cNumero  := SF2->F2_DOC                                      // NUmero da N.Fiscal de Venda     (6)   O
	_dDtEmis  := GravaData(SF2->F2_EMISSAO,.f.,4)                 // Data de Emissao                 (6)   O
	_cSerie   := SF2->F2_SERIE+" "                                // Serie da N.Fiscal               (4)   O
	_cCodFab  := space(3)

	_cCpo     := "NF5"+ STRZERO(VAL(_cCFO),5) + Space(5) + _cAliIRRF + _cBaseIRRF + _cIRRF + _cAliISS + _cBaseISS  + _cISS + _cBaseINSS + _cINSS + space(5)

	_cLin     := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	_nContLiV++

	If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo NF2). Continua?","Atencao!")
			fClose(_nHdlV)
			Return
		Endif
	Endif

	_cPedCli := space(12)
	_cProdCli:= space(30)

	dbSelectArea("SD2")
	dbOrderNickName("INDSD24")
	If dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		_cChavSD2 :=SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA

		While !Eof() .And. _cChavSD2 == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA

			_cLin   := Space(128) + _cEOL                         // Tipo de Registro             (3)  M
			_cItem  := "0"+ SD2->D2_ITEM                          // Numero do Item               (3)  M

			_cPedCli  := Space(12)
			_cDest   := space(03)
			dbSelectArea("SC6")
			dbSetOrder(1)
			If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO + SD2->D2_ITEMPV + SD2->D2_COD)
				_cPedCli := Substr(SC6->C6_PEDCLI,1,12)           // Pedido de Compra do Cliente  (12) M
				_cDest   := SC6->C6_LOCDEST
			Endif

			dbSelectArea("SZ2")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE+ SD2->D2_LOJA+ SD2->D2_COD + SD2->D2_PROCLI+"1")
				If Empty(_cPedCli)
					_cPedCli := Substr(SZ2->Z2_PEDCLI,1,12)           // Pedido de Compra do Cliente  (12) M
				Endif
				_cRev    := ALLTRIM(SZ2->Z2_REVISAO)
				_cUm     := SZ2->Z2_UM
			Endif

			_cProdCli := SD2->D2_PROCLI + Space(15)               // Codigo do Produto do Cliente (30) M
			If Empty(_cProdCli)
				_cProdCli := "S/CODIGO"+ Space(22)
			Endif

			_cQtde    := StrZero(Int(SD2->D2_QUANT),9)            // Qtde do Item                 (9)  M

			If Empty(_cUm)
				dbSelectArea("SAH")
				dbSetOrder(1)
				If dbSeek(xFilial("SAH")+ SD2->D2_UM)
					_cUm := SAH->AH_CODANFA                           // Unidade de medida Anfavea    (2)  M
				Endif
			Endif

			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+SD2->D2_COD)
				_cClasFis := STRZERO(VAL(SB1->B1_POSIPI),10)      // Classificacao Fiscal  Produto (10) M
			Endif

			_cAliIPI  := StrZero(Int(SD2->D2_IPI*100),4)           // Aliquota do IPI                (4)  M
			_cVlItem  := StrZero(Int(SD2->D2_PRCVEN*100000),12)    // Valor do Item                  (12) M

			//			_cTpForn  := "P"
			If Left(_cPedCli,4) = "HETZ"
				_cTpForn  := "R"
			Else
				_cTpForn  := "P"
			Endif

			_cPerDesc := StrZero(Int(SD2->D2_DESC*100),4)         // Percentual de Desconto         (4)  O
			_cValDesc := StrZero(Int(SD2->D2_DESCON*100),11)      // Valor do Desconto              (13) O

			If Len(_cRev) == 2                                    // Alteraçao Técnica do Item      (4)
				_cRev := Space(2)+_cRev
			Else
				_cRev := Substr(_cRev,1,4)
			Endif
			//                                                                                                          86       95
			_cCpo := "AE2"+ _cItem + _cPedCli + _cProdCli + _cQtde + _cUM + _cClasFis + _cAliIPI + _cVlItem + _cQtde + _cUM + ;
			_cQtde + _cUM + _cTpForn + _cPerDesc + _cValDesc + _cRev + space(1)


			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
			_nContLiV++

			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE2). Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif

			_cAliICMS  := StrZero(Int(SD2->D2_PICM   *100),4)           // Percentual ICMS                (4)  O
			_cBaseICMS := StrZero(Int(SD2->D2_BASEICM*100),17)          // Base ICMS                      (17) O
			_cVlICMS   := StrZero(Int(SD2->D2_VALICM *100),17)          // Valor do ICMS                  (17) O
			_cVlIPI    := StrZero(Int(SD2->D2_VALIPI *100),17)          // Valor do ICMS                  (17) O
			_cVlTotal  := StrZero(Int(SD2->D2_TOTAL  *100),12)          // Valor Total do Item            (12) M

			_cCpo := "AE4"+ _cAliICMS + _cBaseICMS + _cVlICMS + _cVlIPI + "00" + sPace(30) +"000000"+space(13)+ space(6) + _cVlTotal +sPace(1)

			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
			_nContLiV++

			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE4). Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif

			dbSelectArea("SD2")
			dbSkip()
		EndDo
	Endif

Return



Static Function GeraRet()

	If _lEncontR
		_lEncontR := .F.
		_cLin    := Space(128) + _cEOL
		_cSeqR    := GetMv("MV_NUMCAT")
		dbSelectArea("SX6")
		RecLock("SX6",.F.)
		SX6->X6_CONTEUD := StrZero((Val(_cSeqR)+1),5)
		MsUnlock()

		_dData := GravaData(dDataBase,.f.,4)
		_cHora := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
		_cCgcCron  := SM0->M0_CGC
		_cNomCron  := Substr(SM0->M0_NOMECOM,1,25)

		dbSelectArea("SA1")
		dbSetOrder(1)
		If dbseek(xFilial("SA1")+ SF2->F2_CLIENTE + SF2->F2_LOJA)
			_cCGCCli  := SA1->A1_CGC
			_cNomCli  := Substr(SA1->A1_NOME,1,25)
		Endif

		_cCodCli := Space(8) //SF2->F2_CLIENTE+SF2->F2_LOJA
		//                              (5)     (6)      (6)      (14)        (14)         (8)         (8)         (25)        (25)
		_cCpo    := "ITP00415" + _cSeqR + _dData + _cHora + _cCgcCron + _cCGCCli + "Q3820C0 " + _cCodCli + _cNomCron + _cNomCli + space(9)
		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
		_nContLiR++
		If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlR)
				Return
			Endif
		Endif
	Endif

	_cLin     := Space(128)+_cEOL
	_cNf      := STRZERO(val(SF2->F2_DOC),6)                                   // Numero da nota Fiscal        (6) M
	_cSer     := SF2->F2_SERIE + SPACE(1)                            // Serie da Nota Fiscal         (4) M
	_dDataNf  := GravaData(SF2->F2_EMISSAO,.f.,4)                   // Data De Emissao da N.F.      (6) M
	_cVlTotal := StrZero(Int(SF2->F2_VALBRUT*100),17)                // Valor Total                  (17)M
	_nQtdCD   := "0"                                                 // Quantidade de Casas Decimais (1) M
	_nSomaTot += SF2->F2_VALBRUT
	_cVlICMS  := StrZero(Int(SF2->F2_VALICM*100),17)                 // Valor Total do ICMS          (17)M

	dbSelectArea("SE1")
	dbSetOrder(1)
	If dbSeek(xFilial("SE1")+ SF2->F2_SERIE + SF2->F2_DOC + " NF ")
		_dVencto := GravaData(SE1->E1_VENCREA,.f.,4)                 // Data do Vencimento           (6) M
	Endif

	_cEspecie := "01" //Substr(SF2->F2_ESPECIE,1,2)                         // Especie                      (2) M
	_cVlIPI   := StrZero(Int(SF2->F2_VALIPI*100),17)                 // Valor Total do IPI           (17)M

	_cCodFab  := "028"                                          		// Codigo da Fabrica Destino    (3) O

	_dDtPrev  := GravaData(SF2->F2_EMISSAO,.f.,4)                   // Data De Previsao de Entrega  (6) O
	_cPerEnt  := space(4)                                            // Periodo da Entrega           (4) O

	dbSelectArea("SX5")
	dbSetOrder(1)
	If dbSeek(xFilial("SX5")+"13"+ _cCFO + sPace(1))
		_cDescCFO := SUBSTR(SX5->X5_DESCRI,1,15)                      // Descricao do CFOP            (15)O
	Endif

	_dDtPrev  := GravaData(SF2->F2_EMISSAO,.f.,4)                   // Data Do Embarque             (6) M
	_cHora    := Substr(SF2->F2_HORA,1,2)+ Substr(SF2->F2_HORA,4,2)  // Hora / Minuto do Embarque    (4) M

	_cCpo    := "AE1" + _cNf + _cSer + _dDataNF + _cQtdItem + _cVlTotal + _nQtdCD + STRZERO(VAL(_cCFO),5) + _cVlICMS + _dVencto + _cEspecie + _cVlIPI + ;
	_cCodFab +  _dDtPrev + _cPerEnt + _cDescCFO + _dDtPrev + _cHora + SPACE(3)
	_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	_nContLiR++

	If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE1).  Continua?","Atencao!")
			fClose(_nHdlR)
			Return
		Endif
	Endif

	// - NF2

	_cDespAce := StrZero(Int(SF2->F2_DESPESA*100),12)             // Valor das Despesas Acessoriais  (12)  O
	_cFrete   := StrZero(Int(SF2->F2_FRETE*100),12)               // Valor do Frete                  (12)  O
	_cSeguro  := StrZero(Int(SF2->F2_SEGURO*100),12)              // Valor do Seguro                 (12)  O
	_cDescon  := StrZero(Int(SF2->F2_DESCONT*100),12)             // Valor do Desconto da N.F.       (12)  O
	_cBaseICMS:= StrZero(Int(SF2->F2_BASEICM*100),12)             // Valor do Desconto da N.F.       (12)  O
	_cICMS    := StrZero(Int(SF2->F2_VALICM*100),12)             // Valor do Desconto da N.F.       (12)  O
	_cNumero  := "000000" //SF2->F2_DOC                                      // NUmero da N.Fiscal de Venda     (6)   O
	_cDtEmis  := "000000" //GravaData(SF2->F2_EMISSAO,.f.,4)                 // Data de Emissao                 (6)   O
	_cSerie   := space(4) //SF2->F2_SERIE+" "                                // Serie da N.Fiscal               (4)   O
	_cCodFab  := space(3)

	_cCpo := "NF2"+ _cDespAce + _cFrete + _cSeguro + _cDescon + _cBaseICMS + _cICMS + _cNumero + _cDtEmis + _cSerie + _cCodFab + STRZERO(VAL(_cCFO),5) + space(29)

	_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	_nContLiR++

	If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo NF2). Continua?","Atencao!")
			fClose(_nHdlR)
			Return
		Endif
	Endif

	// - NF5

	_cAliIRRF:= Repl("0",4)                                     // Aliquota do IRRF                (17)  O
	_cBaseIRRF:= Repl("0",17)                                     // Valor Base IRRF                 (17)  O
	_cIRRF    := Repl("0",17)                                     // Valor Base IRRF                 (17)  O
	_cAliISS  := Repl("0",4)                                     // Aliquota Do ISS                 (17)  O
	_cBaseISS := StrZero(Int(SF2->F2_BASEISS*100),17)             // Valor Base ISS                  (17)  O
	_cISS     := StrZero(Int(SF2->F2_VALISS*100),17)              // Valor ISS                       (17)  O
	_cBaseINSS:= StrZero(Int(SF2->F2_BASEINS*100),17)             // Valor Base INSS                  (17)  O
	_cINSS    := StrZero(Int(SF2->F2_VALINSS*100),17)              // Valor INSS                       (17)  O

	_cFrete   := StrZero(Int(SF2->F2_FRETE*100),17)               // Valor do Frete                  (17)  O
	_cSeguro  := StrZero(Int(SF2->F2_SEGURO*100),17)              // Valor do Seguro                 (17)  O
	_cDescon  := StrZero(Int(SF2->F2_DESCONT*100),17)             // Valor do Desconto da N.F.       (17)  O
	_cBaseICMS:= StrZero(Int(SF2->F2_BASEICM*100),17)             // Valor do Desconto da N.F.       (17)  O
	_cNumero  := SF2->F2_DOC                                      // NUmero da N.Fiscal de Venda     (6)   O
	_dDtEmis  := GravaData(SF2->F2_EMISSAO,.f.,4)                 // Data de Emissao                 (6)   O
	_cSerie   := SF2->F2_SERIE+" "                                // Serie da N.Fiscal               (4)   O
	_cCodFab  := space(3)

	_cCpo := "NF5"+ STRZERO(VAL(_cCFO),5) + Space(5) + _cAliIRRF + _cBaseIRRF + _cIRRF + _cAliISS + _cBaseISS  + _cISS + _cBaseINSS + _cINSS + space(5)

	_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	_nContLiR++

	If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo NF2). Continua?","Atencao!")
			fClose(_nHdlR)
			Return
		Endif
	Endif

	_cPedCli := Space(12)

	dbSelectArea("SD2")
	dbOrderNickName("INDSD24")
	If dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		_cChavSD2 :=SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA

		While !Eof() .And. _cChavSD2 == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA

			_cLin    := Space(128) + _cEOL                         // Tipo de Registro             (3)  M
			_cItem   := "0"+ SD2->D2_ITEM                     // Numero do Item               (3)  M
			_cPedCli := Space(12)
			_cDest   := space(03)
			dbSelectArea("SC6")
			dbSetOrder(1)
			If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO + SD2->D2_ITEMPV + SD2->D2_COD)
				_cPedCli := Substr(SC6->C6_PEDCLI,1,12)           // Pedido de Compra do Cliente  (12) M
				_cDest   := SC6->C6_LOCDEST
			Endif

			_cUm :=  Space(2)

			dbSelectArea("SZ2")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE+ SD2->D2_LOJA+ SD2->D2_COD + SD2->D2_PROCLI+"1")
				If Empty(_cPedcli)
					_cPedCli := Substr(SZ2->Z2_PEDCLI,1,12)               // Pedido de Compra do Cliente  (12) M
				Endif
				_cRev    := Substr(SZ2->Z2_REVISAO,1,4)
				_cUm     := SZ2->Z2_UM
			Endif

			_cProdCli := SD2->D2_PROCLI + Space(15)                  // Codigo do Produto do Cliente (30) M
			_cQtde    := StrZero(Int(SD2->D2_QUANT),9)               // Qtde do Item                 (9)  M

			If Empty(_cProdCli)
				_cProdCli := "S/CODIGO"+ Space(22)
			Endif

			If Empty(_cUm)
				dbSelectArea("SAH")
				dbSetOrder(1)
				If dbSeek(xFilial("SAH")+ SD2->D2_UM)
					_cUm := SAH->AH_CODANFA                                // Unidade de medida Anfavea    (2)  M
				Endif
			Endif

			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+SD2->D2_COD)
				_cClasFis := STRZERO(VAL(SB1->B1_POSIPI),10)           // Classificacao Fiscal  Produto (10) M
			Endif

			_cAliIPI  := StrZero(Int(SD2->D2_IPI*100),4)               // Aliquota do IPI                (4)  M
			_cVlItem  := StrZero(Int(SD2->D2_PRCVEN*100000),12)        // Valor do Item                  (12) M
			If Left(_cPedCli,4) = "HETZ"
				_cTpForn  := "R"
			Else
				_cTpForn  := "P"
			Endif
			_cPerDesc := StrZero(Int(SD2->D2_DESC*100),4)             // Percentual de Desconto         (4)  O
			_cValDesc := StrZero(Int(SD2->D2_DESCON*100),11)          // Valor do Desconto              (13) O

			If Len(Alltrim(_cRev)) == 2                                        // Alteraçao Técnica do Item      (4)
				_cRev := Space(2)+Alltrim(_cRev)
			Else
				_cRev := Substr(_cRev,1,4)
			Endif
			//                                                                                                          86       95
			_cCpo := "AE2"+ _cItem + _cPedCli + _cProdCli + _cQtde + _cUM + _cClasFis + _cAliIPI + _cVlItem + _cQtde + _cUM + ;
			_cQtde + _cUM + _cTpForn + _cPerDesc + _cValDesc + _cRev + space(1)
			//                 97      106      (1)

			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
			_nContLiR++

			If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE2). Continua?","Atencao!")
					fClose(_nHdlR)
					Return
				Endif
			Endif

			_cAliICMS  := StrZero(Int(SD2->D2_PICM   *100),4)           // Percentual ICMS                (4)  O
			_cBaseICMS := StrZero(Int(SD2->D2_BASEICM*100),17)          // Base ICMS                      (17) O
			_cVlICMS   := StrZero(Int(SD2->D2_VALICM *100),17)          // Valor do ICMS                  (17) O
			_cVlIPI    := StrZero(Int(SD2->D2_VALIPI *100),17)          // Valor do ICMS                  (17) O
			_cVlTotal  := StrZero(Int(SD2->D2_TOTAL  *100),12)          // Valor Total do Item            (12) M

			_cCpo := "AE4"+ _cAliICMS + _cBaseICMS + _cVlICMS + _cVlIPI + "00" + sPace(30) +"000000"+space(13)+ space(6) + _cVlTotal +sPace(1)

			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
			_nContLiR++

			If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE4). Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif

			_cPO       := SD2->D2_PEDCLI                        // PO           (4) M
			_cVlICMS   := StrZero(Int(SD2->D2_VALICM *100),12)          // Valor do ICMS                   (17) O
			_cCfo      := SD2->D2_CF                        // Codigo de Operaçao              (3)  M
			_cVlBaTrib := Repl("0",17)                                  // Valor Base do ICMS Tributario   (17) M
			_cVlICMTri := Repl("0",17)                                  // Valor do ICMS Tributario        (17) M
			_cQtdeEmb  := Repl("0",14)                                   // Quantidade Entregue             (9)  O
			_cCpo := "AE7"+ _cVlICMS + STRZERO(VAL(_cCFO),5) + _cVlBaTrib + _cVlICMTRI + _cQtdeEmb + Space(60)

			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
			_nContLiR++

			If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE7). Continua?","Atencao!")
					fClose(_nHdlR)
					Return
				Endif
			Endif

			_cNfOri    := STRZERO(val(SD2->D2_NFORI),6)                 // Nota Fiscal Original            (6)  M
			_cSerOri   := SD2->D2_SERIORI + space(1)                     // Serie Nota Fiscal Original      (4)  M

			dbSelectArea("SD1")
			dbSetOrder(4)
			If dbSeek(xFilial("SD2")+SD2->D2_IDENTB6)
				_cItemOri := STRZERO(val(SD1->D1_ITEM),3)                // Numero do Item Nota Fiscal Original (3)  M
				_cDtOri   := GravaData(SD1->D1_EMISSAO,.f.,4)            // Data Original                       (6)  M
			Endif

			_cCorrida := sPace(16)
			_cChassi  := Space(17)
			_cAutor   := Space(10)
			_cCpo     := "AE8" + _cNfOri + _cSerOri + _cDtOri + _cItemOri + _cCorrida + _cChassi + _cAutor + space(63)

			_cLin     := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
			_nContLiR++

			If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE8). Continua?","Atencao!")
					fClose(_nHdlR)
					Return
				Endif
			Endif

			dbSelectArea("SD2")
			dbSkip()
		EndDo
	Endif

Return


Static Function GeraTRB(_nOpc)

	Private _lEnvia    := .F.

	aStru := {}
	AADD(aStru,{"CODCRO"   , "C" , 15, 0 })
	AADD(aStru,{"CODCLI"   , "C" , 15, 0 })
	AADD(aStru,{"PEDIDO"   , "C" , 20, 0 })
	AADD(aStru,{"QTDE"     , "N" , 12, 4 })
	AADD(aStru,{"UNIT"     , "N" , 12, 4 })
	AADD(aStru,{"TOTAL"    , "N" , 12, 4 })

	_cArqTrb := CriaTrab(aStru,.T.)
	_cIndTrb := "CODCRO"

	dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)
	dbSelectArea("TRB")
	IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

	_cQuery := " SELECT D2_COD,D2_PROCLI,D2_PEDCLI,D2_QUANT,D2_PRCVEN,D2_TOTAL "
	_cQuery += " FROM "+RetSqlName("SD2")+" D2 (NOLOCK) "
	_cQuery += " WHERE D2.D_E_L_E_T_ = '' "
	_cQuery += " AND D2_DOC+D2_SERIE = '"+SF2->F2_DOC+SF2->F2_SERIE+"' "
	_cQuery += " ORDER BY D2_COD "

	TCQUERY _cQuery New ALIAS "ZD2"

	ZD2->(dbGoTop())

	While ZD2->(!Eof())

		TRB->(RecLock("TRB",.T.))
		TRB->CODCRO  := ZD2->D2_COD
		TRB->CODCLI  := ZD2->D2_PROCLI
		TRB->PEDIDO  := ZD2->D2_PEDCLI
		TRB->QTDE    := ZD2->D2_QUANT
		TRB->UNIT    := ZD2->D2_PRCVEN
		TRB->TOTAL   := ZD2->D2_TOTAL
		TRB->(MsUnlock())

		_lEnvia := .T.

		ZD2->(dbSkip())
	EndDo

	ZD2->(dbCloseArea())

	If _lEnvia
		If _nOpc = 1
			CNH_M()
		ElseIf _nOpc = 2
			SendMail()
		Endif
	Endif

	TRB->(dbCloseArea())

Return



Static Function CNH_M()

	Private _lRet

	nOpcao := 0

	ConOut("Enviando E-Mail para CNH:")

	oProcess := TWFProcess():New( "ENVCNH1", "CNH" )
	aCond    :={}
	_nTotal  := 0

	oProcess:NewTask( "Cliente", "\WORKFLOW\ENV_CNH.HTM" )
	oProcess:bReturn  := ""
	oProcess:bTimeOut := ""

	oHTML := oProcess:oHTML

	oProcess:cSubject := "Romaneio de Entrega - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

	SA1->(dbSelectArea(1))
	SA1->(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))

	oHtml:ValByName( "NUMERO" , SF2->F2_DOC)
	oHtml:ValByName( "EMISSAO", DTOC(SF2->F2_EMISSAO))
	oHtml:ValByName( "CLIENTE", Alltrim(SA1->A1_NOME))

	TRB->(dbGoTop())

	While TRB->(!Eof())

		AADD( (oHtml:ValByName( "TB.CODPASY"   	)), TRB->CODCRO)
		AADD( (oHtml:ValByName( "TB.CODCLI"     )), TRB->CODCLI)
		AADD( (oHtml:ValByName( "TB.PEDIDO"     )), TRB->PEDIDO)
		AADD( (oHtml:ValByName( "TB.QTDE"       )), TRANSFORM( TRB->QTDE ,   '@E 999,999,999.99' ))
		AADD( (oHtml:ValByName( "TB.UNIT"       )), TRANSFORM( TRB->UNIT ,   '@E 9,999,999.9999' ))
		AADD( (oHtml:ValByName( "TB.TOTAL"      )), TRANSFORM( TRB->TOTAL,   '@E 999,999,999.99' ))

		oProcess:fDesc := "E-mail CNH - Cliente "+SF2->F2_CLIENTE+" Loja "+SF2->F2_LOJA

		TRB->(dbSkip())
	EndDo

	If SF2->F2_CLIENTE = '000051'
		_cTo := GetMV("CR_WFCNH"+SF2->F2_LOJA)
	ElseIf SF2->F2_CLIENTE = '000021'
		_cTo := GetMV("CR_WFIVE"+SF2->F2_LOJA)
	Endif

	_cCc := USRRETMAIL(RETCODUSR())

	oProcess:cTo := _cTo
	oProcess:cCC := _cCC

	oProcess:Start()

	oProcess:Finish()

Return



Static Function SendMail()

	Local _cTo := ""
	Local _cCC := ""

	ConOut("Enviando E-Mail Cliente com Certificação:")

	_oProcess := TWFProcess():New( "ENVCERT", "CERTIFICACAO" )

	_oProcess:NewTask( "CERTIFICACAO", "\WORKFLOW\CERTIF.HTM" )
	_oProcess:bReturn  := ""
	_oProcess:bTimeOut := ""

	_oHTML := _oProcess:oHTML

	_oProcess:cSubject := "NF Cliente com Certificação ("+Alltrim(SA1->A1_NREDUZ)+") - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

	_oHtml:ValByName( "NUMERO" 	, Alltrim(SF2->F2_SERIE)+'-'+SF2->F2_DOC)
	_oHtml:ValByName( "EMISSAO"	, DTOC(SF2->F2_EMISSAO))
	_oHtml:ValByName( "CLIENTE"	, SF2->F2_CLIENTE+'-'+SF2->F2_LOJA)
	_oHtml:ValByName( "NOME"	, Alltrim(SA1->A1_NOME))

	TRB->(dbGoTop())

	While TRB->(!Eof())

		AADD( (_oHtml:ValByName( "TB.CODCRO"   )), TRB->CODCRO)
		AADD( (_oHtml:ValByName( "TB.CODCLI"   )), TRB->CODCLI)
		AADD( (_oHtml:ValByName( "TB.PEDIDO"   )), TRB->PEDIDO)
		AADD( (_oHtml:ValByName( "TB.QTDE"     )), TRANSFORM( TRB->QTDE ,   '@E 999,999,999.99' ))
		AADD( (_oHtml:ValByName( "TB.UNIT"     )), TRANSFORM( TRB->UNIT ,   '@E 9,999,999.9999' ))
		AADD( (_oHtml:ValByName( "TB.TOTAL"    )), TRANSFORM( TRB->TOTAL,   '@E 999,999,999.99' ))

		_oProcess:fDesc := "NF Cliente com Certificação "+SF2->F2_CLIENTE+" - Loja "+SF2->F2_LOJA

		TRB->(dbSkip())
	EndDo

	SZG->(dbsetOrder(1))
	SZG->(dbGotop())

	While SZG->(!EOF())

		If 'U1' $ SZG->ZG_ROTINA
			_cTo += If(Empty(_cTo),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
		ElseIf 'U2' $ SZG->ZG_ROTINA
			_cCC += If(Empty(_cCC),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
		Endif

		SZG->(dbSkip())
	Enddo

//	_oProcess:AttachFile(_cAnexo)

	_cCc += If(Empty(_cCc),USRRETMAIL(RETCODUSR()),';'+USRRETMAIL(RETCODUSR()))

	_oProcess:cTo := _cTo
	_oProcess:cCC := _cCC

	_oProcess:Start()
	_oProcess:Finish()

Return
