#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2460I   º Autor ³ Alexandro da Silva º Data ³  17/04/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Geração do Arquivo Texto Padrao anfavea p/ Caterpillar     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SF2460I()

	Begin Transaction

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

		If SF2->F2_CLIENTE == "000008"
			GeraCat()
		ElseIf SF2->F2_CLIENTE == "000001" .Or. SF2->F2_CLIENTE == "000053"
			//	GeraAGCO()
		ElseIf SF2->F2_CLIENTE == "000361" //.And. SF2->F2_LOJA $ ('11|13')
//		ElseIf SF2->F2_CLIENTE == "000071" //.And. SF2->F2_LOJA $ ('11|13')
			U_CNHMai()
		Endif

		Private _lOk := .T.

		U_CheckEstoq("R_",SF2->F2_DOC,SF2->F2_SERIE)

		If !_lOk
			DisarmTransaction()		
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

	End Transaction 

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

	Private _cLin, _cCpo, _cCGCPasy,_cCGCCli,_cUM, _cIdenti,_cTpForn,_cIdent
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

	_lAchouV   := .F.
	_lAchouR   := .F.
	_nContLiV  := 0
	_nContLiR  := 0
	_nSomaTot  := 0

	_lEncontV  := .t.
	_lEncontR  := .t.

	//dbSelectArea("SF2")
	//RecLock("SF2",.F.)
	//SF2->F2_FIMP := "S"
	//MsUnlock()

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
		Private _cArqTxtV := "\\SERVER2\ERP\EDI\WIDESOFT\CATER\SAIDA\61064911000177_RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT"
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

		__CopyFile("\\SERVER2\ERP\EDI\WIDESOFT\CATER\SAIDA\61064911000177_RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT", "\\SERVER2\ERP\EDI\WIDESOFT\CATER\SAIDA\BKP\61064911000177_RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT")
	Else
		// - Notas Fiscais de Retorno

		Private _cCgc2    := SM0->M0_CGC
		Private _cData2   := GravaData(dDataBase,.f.,8)
		Private _cHora2   := Substr(Time(),1,2) + Substr(Time(),4,2) + strzero(Val(Substr(Time(),7,2))+1,2)
		//	Private _cArqTxtR := "F:\EDI\WIDESOFT\CATER\SAIDA\61064911000177_RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT"
		Private _cArqTxtR := "\\SERVER2\ERP\EDI\WIDESOFT\CATER\SAIDA\61064911000177_RND00415_"+_cCGC2+"_"+_cData2+_cHora2+".TXT"

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
		_cCgcPasy  := SM0->M0_CGC
		_cNomPasy  := Substr(SM0->M0_NOMECOM,1,25)

		dbSelectArea("SA1")
		dbSetOrder(1)
		If dbseek(xFilial("SA1")+ SF2->F2_CLIENTE + SF2->F2_LOJA)
			_cCGCCli  := SA1->A1_CGC
			_cNomCli  := Substr(SA1->A1_NOME,1,25)
		Endif

		_cCodCli := Space(8) //SF2->F2_CLIENTE+SF2->F2_LOJA
		//                              (5)     (6)      (6)      (14)        (14)         (8)         (8)         (25)        (25)
		_cCpo    := "ITP00415" + _cSeqv + _dData + _cHora + _cCgcPasy + _cCGCCli + "Q1675X0 " + _cCodCli + _cNomPasy + _cNomCli + space(9)
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
	_cNf      := STRZERO(val(SF2->F2_DOC),6)                                        // Numero da nota Fiscal        (6) M
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

	_cEspecie := "02" //Substr(SF2->F2_ESPECIE,1,2)                         // Especie                      (2) M
	_cVlIPI   := StrZero(Int(SF2->F2_VALIPI*100),17)                 // Valor Total do IPI           (17)M
	_cCodFab  := "028"                                          // Codigo da Fabrica Destino    (3) O
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

			_cTpForn  := "P"

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
			//                 97      106      (1)

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
		_cCgcPasy  := SM0->M0_CGC
		_cNomPasy  := Substr(SM0->M0_NOMECOM,1,25)

		dbSelectArea("SA1")
		dbSetOrder(1)
		If dbseek(xFilial("SA1")+ SF2->F2_CLIENTE + SF2->F2_LOJA)
			_cCGCCli  := SA1->A1_CGC
			_cNomCli  := Substr(SA1->A1_NOME,1,25)
		Endif

		_cCodCli := Space(8) //SF2->F2_CLIENTE+SF2->F2_LOJA
		//                              (5)     (6)      (6)      (14)        (14)         (8)         (8)         (25)        (25)
		_cCpo    := "ITP00415" + _cSeqR + _dData + _cHora + _cCgcPasy + _cCGCCli + "Q1675X0 " + _cCodCli + _cNomPasy + _cNomCli + space(9)
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

	_cCodFab  := "028"                                          // Codigo da Fabrica Destino    (3) O

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
			_cTpForn  := "P"
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




//////////////    AGCO / Valtra

Static Function GeraAGCO()

	Private _cQtdItem
	Private _cCfo


	// Notas Fiscais de Venda

	_cCgc2  := SM0->M0_CGC
	_cData2 := GravaData(dDataBase,.f.,8)
	_cHora2 := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

	If SF2->F2_CLIENTE == "000001"
		Private _cArqTxtV := "\\SERVER2\ERP\PROTHEUS10\MP_DATA\AGCO\Saida\AGCO_"+_cData2+"_"+_cHora2+"_00000.TXT"
	Else
		Private _cArqTxtV := "\\SERVER2\ERP\PROTHEUS10\MP_DATA\VALTRA\SAIDA\VALTRA_"+_cData2+"_"+_cHora2+"_00000.TXT"
	Endif

	Private _nHdlV    := MSfCreate(_cArqTxtV)

	If _nHdlV == -1
		MsgAlert("O arquivo de nome "+_cArqTxtV+" 1 nao pode ser executado!","Atencao!")
		fClose(_nHdlV)
		Return
	Endif

	// - Notas Fiscais de Retorno

	_cCgc2  := SM0->M0_CGC
	_cData2 := GravaData(dDataBase,.f.,8)
	_cHora2 := Substr(Time(),1,2) + Substr(Time(),4,2) + strzero(Val(Substr(Time(),7,2))+1,2)

	If SF2->F2_CLIENTE == "000001"
		Private _cArqTxtR  := "\\SERVER2\ERP\PROTHEUS10\MP_DATA\AGCO\Saida\AGCO_"+_cData2+"_"+_cHora2+"_00000.TXT"
	Else
		Private _cArqTxtR  := "\\SERVER2\ERP\PROTHEUS10\MP_DATA\VALTRA\SAIDA\VALTRA_"+_cData2+"_"+_cHora2+"_00000.TXT"
	Endif

	Private _nHdlR     := MSfCreate(_cArqTxtR)
	Private _lEncontV  := .t.
	Private _lEncontR  := .t.

	If _nHdlR == -1
		MsgAlert("O arquivo de nome "+_cArqTxtR+" 2 nao pode ser executado!","Atencao!")
		fClose(_nHdlR)
		Return
	Endif


	Private _cEOL    := "CHR(13)+CHR(10)"
	If Empty(_cEOL)
		_cEOL := CHR(13)+CHR(10)
	Else
		_cEOL := Trim(_cEOL)
		_cEOL := &_cEOL
	Endif

	_cLin    := Space(128) + _cEOL

	Private _cLin, _cCpo, _cCGCPasy,_cCGCCli,_cUM, _cIdenti,_cTpForn,_cIdent,_lFerr
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

	_lAchouV  := .F.
	_lAchouR  := .F.
	_nContLiV := 0
	_nContLiR := 0
	_nSomaTot := 0

	_lFerr := .F.

	dbSelectArea("SD2")
	dbOrderNickName("INDSD24")
	If dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		_cChavSD2    := SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
		_nQtdItem    := 0
		_lRetorno    := .F.
		_lVenda      := .F.
		While !Eof() .And. _cChavSD2 == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA

			_nQtdItem ++
			_cCfo     := SD2->D2_CF                           // Codigo de Operaçao           (5) M

			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+SD2->D2_COD)
				If SB1->B1_TIPO == "FR"
					_lFerr := .T.
				Endif
			Endif

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
			dbSelectArea("SD2")
			dbSkip()
		EndDo
	Endif
	_cQtdItem    := strZero(_nQtdItem,3)                             // Qtde de itens a N.F.         (3) M

	If !_lFerr
		If _lVenda
			GeraVenda2()
		Else
			GeraRet2()
		Endif
	Endif

	If _lAchouV
		_nContLiV++
		_cContLI  := StrZero(_nContLiV,9)                           // Numero de Controle             (9)  M
		_cSomaTot := StrZero(Int(_nSomaTot *100),17)                // Soma Total das N.Fiscais       (12) M
		_cCpo     := "FTP"+ _cSeqv + _cContLi + _cSomaTot + "D" + sPace(93)

		_cLin     := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo FTP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif
	Else
		fClose(_nHdlV)
		FErase(_cArqTxtV)
	Endif

	If _lAchouR
		_nContLiR++
		_cContLI  := StrZero(_nContLiR,9)                           // Numero de Controle             (9)  M
		_cSomaTot := StrZero(Int(_nSomaTot *100),17)               // Soma Total das N.Fiscais       (12) M
		_cCpo     := "FTP"+ _cSeqR + _cContLi + _cSomaTot + "D" + sPace(93)

		_cLin     := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo FTP). Continua?","Atencao!")
				fClose(_nHdlR)
				Return
			Endif
		Endif
	Else
		fClose(_nHdlR)
		FErase(_cArqTxtR)
	Endif

	fClose(_nHdlV)
	fClose(_nHdlR)

Return


Static Function GeraVenda2()

	If _lEncontV
		_lEncontV := .F.
		_cLin     := Space(128) + _cEOL

		If SF2->F2_CLIENTE == "000001"
			_cSeqv    := GetMv("MV_NUMAGCO")
		Else
			_cSeqv    := GetMv("MV_NUMVALT")
		Endif

		dbSelectArea("SX6")
		RecLock("SX6",.F.)
		SX6->X6_CONTEUD := StrZero((Val(_cSeqv)+1),5)
		MsUnlock()

		_cData := GravaData(dDataBase,.f.,4)
		_cHora := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
		_cCgcPasy  := SM0->M0_CGC
		_cNomPasy  := Substr(SM0->M0_NOMECOM,1,25)

		dbSelectArea("SA1")
		dbSetOrder(1)
		If dbseek(xFilial("SA1")+ SF2->F2_CLIENTE + SF2->F2_LOJA)
			_cCGCCli  := SA1->A1_CGC
			_cNomCli  := Substr(SA1->A1_NOME,1,25)
		Endif

		_cIdent    := "ITP00415"           // Tipo Processo/Identif/Versao           08 - (01 a 08)
		_cSeqv     := _cSeqv               // Numero de Controle da Transação        05 - (09 a 13)
		_cDtHora   := _cData + _cHora      // Identificacao da Geração do Movimento  12 - (14 a 25)
		_cCgcPasy  := _cCgcPasy            // Ident. Transmissor na Comunicação      14 - (26 a 39)
		_cCGCCli   := _cCGCCli             // Ident. Receptor na Comunicação         14 - (40 a 53)
		_cCodTra   := "00013456"           // Codigo Interno do Transmissor          08 - (54 a 61)
		_cCodRec   := Space(8)             // Codigo Interno do Receptor             08 - (62 a 69)
		_cNomPasy  := _cNomPasy            // Nome do Transmissor                    25 - (70 a 94)
		_cNomCli   := _cNomCli             // Nome do Receptor                       25 - (95 a 119)
		_cEspaco   := Space(9)             // Espaço em branco                       09 - (120 a 128)

		_cCpo      := _cIdent + _cSeqv + _cDtHora + _cCgcPasy + _cCGCCli +_cCodTra + _cCodRec + _cNomPasy + _cNomCli + _cEspaco
		_cLin      := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
		_nContLiV++
		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif
	Endif

	_cLin     := Space(128)+_cEOL
	_cNf      := STRZERO(val(SF2->F2_DOC),6)
	_cSer     := SF2->F2_SERIE + SPACE(1)
	_dDataNf  := GravaData(SF2->F2_EMISSAO,.f.,4)
	_cVlTotal := StrZero(Int(SF2->F2_VALBRUT*100),17)
	_nSomaTot += SF2->F2_VALBRUT
	_cVlICMS  := StrZero(Int(SF2->F2_VALICM*100),17)

	dbSelectArea("SE1")
	dbSetOrder(1)
	If dbSeek(xFilial("SE1")+ SF2->F2_SERIE + SF2->F2_DOC + " NF ")
		_dVencto := GravaData(SE1->E1_VENCREA,.f.,4)
	Endif

	_cEspecie := "02"
	_cVlIPI   := StrZero(Int(SF2->F2_VALIPI*100),17)

	dbSelectArea("SX5")
	dbSetOrder(1)
	If dbSeek(xFilial("SX5")+"13"+ _cCFO + sPace(1))
		_cDescCFO := SUBSTR(SX5->X5_DESCRI,1,15)
	Endif

	_dDtEmb   := GravaData(SF2->F2_EMISSAO,.f.,4)
	_cHora    := Substr(SF2->F2_HORA,1,2)+ Substr(SF2->F2_HORA,4,2)

	_cTpReg   := "AE1"                  // Tipo de Registro          03 - (01 a 03)
	_cNf      := _cNf                   // Numero da Nota Fiscal     06 - (04 a 09)
	_cSer     := _cSer                  // Serie  da Nota Fiscal     03 - (10 a 13)
	_cDataNf  := _dDataNf               // Data   da Nota Fiscal     06 - (14 a 19)
	_cQtdItem := _cQtdItem              // Quantidade de Item da NF  03 - (20 a 22)
	_cVlTotal := _cVlTotal              // Valor Total da N.Fiscal   17 - (23 a 39)
	_cQtdCd   := "0"                    // Qtde Casas Decimais       01 - (40 a 40)
	_cCfo     := StrZero(Val(_cCfo),5)  // Codigo Fiscal de Operacao 05 - (41 a 45)
	_cVlICMS  := _cVlICMS               // Valor total ICMS Aplicado 17 - (46 a 62)
	_cVencto  := _dVencto               // Data do Vencimento        06 - (63 a 68)
	_cEspecie := _cEspecie              // Especie da Nota Fiscal    02 - (69 a 70)
	_cVLIPI   := _cVlIPI                // Valor Total do IPI        17 - (71 a 87)
	_cCodFab  := Space(3)               // Codigo da Fabrica         03 - (88 a 90)
	_cDtPrev  := "000000"               // Data Previsao Entrega     06 - (91 a 96)
	_cPerEnt  := space(4)               // Periodo da Entrega        04 - (97 a 100)
	_cDescCfo := _cDescCfo              // Descricao da Nat.Operacao 15 - (101 a 115)
	_cDtEmb   := _dDtEmb                // Data do Embarque          06 - (116 a 121)
	_cHora    := _cHora                 // Hora do Embarque          04 - (122 a 125)
	_cEspaco  := Space(3)               // Espaco em Branco          03 - (126 a 128)

	_cCpo    := _cTpReg + _cNf + _cSer + _cDataNF + _cQtdItem + _cVlTotal + _cQtdCD + _cCfo + _cVlICMS + _cVencto + _cEspecie + _cVlIPI + ;
	_cCodFab + _cDtPrev + _cPerEnt + _cDescCFO + _cDtEmb + _cHora + _cEspaco

	_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	_nContLiV++

	If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE1).  Continua?","Atencao!")
			fClose(_nHdlV)
			Return
		Endif
	Endif

	// - NF2

	_cTpReg   := "NF2"
	_cDespAce := StrZero(Int(SF2->F2_DESPESA*100),12)
	_cFrete   := StrZero(Int(SF2->F2_FRETE*100),12)
	_cSeguro  := StrZero(Int(SF2->F2_SEGURO*100),12)
	_cDescon  := StrZero(Int(SF2->F2_DESCONT*100),12)
	_cBaseICMS:= StrZero(Int(SF2->F2_BASEICM*100),12)
	_cICMS    := StrZero(Int(SF2->F2_VALICM*100),12)

	_cTpReg    := _cTpReg                         // Tipo de Registro           03 - (01 a 03)
	_cDespAce  := _cDespAce                       // Valor Despesas Acessorias  12 - (04 a 15)
	_cFrete    := _cFrete                         // Valor do Frete             12 - (16 a 27)
	_cSeguro   := _cSeguro                        // Valor do Seguro            12 - (28 a 39)
	_cDescon   := _cDescon                        // Valor do Desconto          12 - (40 a 51)
	_cBaseICMS := _cBaseICMS                      // Base de Calculo do ICMS    12 - (52 a 63)
	_cICMS     := _cICMS                          // Valor do ICMS              12 - (64 a 75)
	_cZero     := "000000000000"                  // Numero,Data                06 - (76 a 87)
	_cBranco   := Space(7)                        // Serie,Codigo da Fabrica    36 - (88 a 94)
	_cCfo2     := StrZero(VaL(_cCFO),5)           // Codigo Fiscal Operacao     05 - (95 a 99)
	_cBranco2  := Space(29)                       // Espaco em Branco           29 - (100 a 128)

	_cCpo := _cTpReg+ _cDespAce + _cFrete + _cSeguro + _cDescon + _cBaseICMS + _cICMS + _cZero + _cBranco + _cCfo2 + _cBranco2

	_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
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
			_cItem  := "0"+ SD2->D2_ITEM

			_cProdCli := SD2->D2_PROCLI + Space(15)
			If Empty(_cProdCli)
				_cProdCli := "S/CODIGO"+ Space(22)
			Endif

			_cDest   := space(03)
			dbSelectArea("SC6")
			dbSetOrder(1)
			If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
				_cPedCli := SUBSTR(SC6->C6_PEDCLI,1,12)
				_cDest   := SC6->C6_LOCDEST
			Endif

			dbSelectArea("SZ2")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE+ SD2->D2_LOJA+ SD2->D2_COD + SD2->D2_PROCLI+"1")
				If Empty(_cPedcli)
					_cPedCli := Substr(SZ2->Z2_PEDCLI,1,12)
				Endif
				_cRev    := ALLTRIM(SZ2->Z2_REVISAO)
			Endif

			_cQtde    := StrZero(Int(SD2->D2_QUANT),9)

			dbSelectArea("SAH")
			dbSetOrder(1)
			If dbSeek(xFilial("SAH")+ SD2->D2_UM)
				_cUm := "PC"//SAH->AH_CODANFA
			Endif

			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+SD2->D2_COD)
				_cClasFis := STRZERO(VAL(SB1->B1_POSIPI),10)
			Endif

			_cAliIPI := StrZero(Int(SD2->D2_IPI*100),4)
			_cVlItem := StrZero(Int(SD2->D2_PRCVEN*100000),12)

			If Len(_cRev) == 2
				_cRev := Space(2)+_cRev
			Else
				_cRev := Substr(_cRev,1,4)
			Endif

			_cTpReg    := "AE2"                               // Tipo de Registro           03 - (01 a 03)
			_cItem     := _cItem                              // NUmero do Item da N.Fiscal 03 - (04 a 06)
			_cPedCli   := _cPedCli                            // NUmero do Pedido de Compra 12 - (07 a 18)
			_cProdCli  := _cProdCli                           // Codigo do Item             30 - (19 a 48)
			_cQtde     := _cQtde                              // Qtde do Item na Nota Fiscal09 - (49 a 57)
			_cUM       := _cUm                                // Unidade Medida             02 - (58 a 59)
			_cClasFis  := _cClasFis                           // Classificacao Fiscal       10 - (60 a 69)
			_cAliIPI   := _cAliIPi                            // Aliq. do IPI               04 - (70 a 73)
			_cVlItem   := _cVlItem                            // Valor do Item              12 - (74 a 85)
			_cQtde     := _cQtde                              // Qtde do Item em Estoque    09 - (86 a 94)
			_cUM       := _cUm                                // Unidade Medida Estoque     02 - (95 a 96)
			_cQtde     := _cQtde                              // Qtde do Unidade de Compra  09 - (97 a 105)
			_cUM       := _cUm                                // Unidade Medida de Compra   02 - (106 a 107)
			_cTpForn   := "P"                                 // Tipo de Fornecimento       01 - (108 a 108)
			_cPerDesc  := StrZero(Int(SD2->D2_DESC*100),4)    // Percentual de Desconto     04 - (109 a 112)
			_cValDesc  := StrZero(Int(SD2->D2_DESCON*100),11) // Valor do Desconto          11 - (113 a 123)
			_cRev      := _cRev                               // Alteracao Tecnica do Item  04 - (124 a 127)
			_cBranco   := Space(1)                            // Espaco em branco           01 - (128 a 128)

			_cCpo := _cTpReg + _cItem + _cPedCli + _cProdCli + _cQtde + _cUM + _cClasFis + _cAliIPI + _cVlItem + _cQtde + _cUM + ;
			_cQtde + _cUM + _cTpForn + _cPerDesc + _cValDesc + _cRev + _cBranco

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

			_cCpo := "AE4"+ _cAliICMS + _cBaseICMS + _cVlICMS + _cVlIPI + "00" + sPace(30) +"000000"+space(13)+ space(5) + "1" +_cVlTotal +sPace(1)

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


	_cZeros    := Repl('0',28)
	_cLocEnt   := ""

	If SF2->F2_CLIENTE == "000001"
		If SF2->F2_LOJA == "01"
			_cLocEnt := "CAN"
		ElseIf SF2->F2_LOJA == "02"
			_cLocEnt := "SRO"
		ElseIf SF2->F2_LOJA == "03"
			_cLocEnt := "SUM"
		Endif
	Else
		//	_cLocEnt := "MOG"
		_cLocEnt := _cDest
	Endif

	_cLocEnt := _cLocEnt +Space(11)

	_cCpo := "AE3"+ _cZeros + _cLocEnt + Space(83)

	_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	_nContLiV++

	If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE3). Continua?","Atencao!")
			fClose(_nHdlV)
			Return
		Endif
	Endif

Return



Static Function GeraRet2()

	If _lEncontR
		_lEncontR := .F.
		_cLin    := Space(128) + _cEOL

		If SF2->F2_CLIENTE == "000001"
			_cSeqv    := GetMv("MV_NUMAGCO")
		Else
			_cSeqv    := GetMv("MV_NUMVALT")
		Endif

		dbSelectArea("SX6")
		RecLock("SX6",.F.)
		SX6->X6_CONTEUD := StrZero((Val(_cSeqR)+1),5)
		MsUnlock()

		_cData := GravaData(dDataBase,.f.,4)
		_cHora := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
		_cCgcPasy  := SM0->M0_CGC
		_cNomPasy  := Substr(SM0->M0_NOMECOM,1,25)

		dbSelectArea("SA1")
		dbSetOrder(1)
		If dbseek(xFilial("SA1")+ SF2->F2_CLIENTE + SF2->F2_LOJA)
			_cCGCCli  := SA1->A1_CGC
			_cNomCli  := Substr(SA1->A1_NOME,1,25)
		Endif

		_cCodCli := SF2->F2_CLIENTE+SF2->F2_LOJA

		_cIdent    := "ITP00415"           // Tipo Processo/Identif/Versao           08 - (01 a 08)
		_cSeqv     := _cSeqv               // Numero de Controle da Transação        05 - (09 a 13)
		_cDtHora   := _cData + _cHora      // Identificacao da Geração do Movimento  12 - (14 a 25)
		_cCgcPasy  := _cCgcPasy            // Ident. Transmissor na Comunicação      14 - (26 a 39)
		_cCGCCli   := _cCGCCli             // Ident. Receptor na Comunicação         14 - (40 a 53)
		_cCodTra   := "00013456"           // Codigo Interno do Transmissor          08 - (54 a 61)
		_cCodRec   := Space(8)             // Codigo Interno do Receptor             08 - (62 a 69)
		_cNomPasy  := _cNomPasy            // Nome do Transmissor                    25 - (70 a 94)
		_cNomCli   := _cNomCli             // Nome do Receptor                       25 - (95 a 119)
		_cEspaco   := Space(9)             // Espaço em branco                       09 - (120 a 128)

		_cCpo    := _cIdent + _cSeqv + _cDtHora + _cCgcPasy + _cCGCCli +_cCodTra + _cCodRec + _cNomPasy + _cNomCli + _cEspaco
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
	_cNf      := STRZERO(val(SF2->F2_DOC),6)
	_cSer     := SF2->F2_SERIE + SPACE(1)
	_dDataNf  := GravaData(SF2->F2_EMISSAO,.f.,4)
	_cVlTotal := StrZero(Int(SF2->F2_VALBRUT*100),17)
	_nQtdCD   := "0"
	_nSomaTot += SF2->F2_VALBRUT
	_cVlICMS  := StrZero(Int(SF2->F2_VALICM*100),17)

	dbSelectArea("SE1")
	dbSetOrder(1)
	If dbSeek(xFilial("SE1")+ SF2->F2_SERIE + SF2->F2_DOC + " NF ")
		_dVencto := GravaData(SE1->E1_VENCREA,.f.,4)
	Endif

	_cVlIPI   := StrZero(Int(SF2->F2_VALIPI*100),17)

	dbSelectArea("SX5")
	dbSetOrder(1)
	If dbSeek(xFilial("SX5")+"13"+ _cCFO + sPace(1))
		_cDescCFO := SUBSTR(SX5->X5_DESCRI,1,15)
	Endif

	_dDtEmb   := GravaData(SF2->F2_EMISSAO,.f.,4)
	_cHora    := Substr(SF2->F2_HORA,1,2)+ Substr(SF2->F2_HORA,4,2)


	_cTpReg   := "AE1"                  // Tipo de Registro          03 - (01 a 03)
	_cNf      := _cNf                   // Numero da Nota Fiscal     06 - (04 a 09)
	_cSer     := _cSer                  // Serie  da Nota Fiscal     03 - (10 a 13)
	_cDataNf  := _dDataNf               // Data   da Nota Fiscal     06 - (14 a 19)
	_cQtdItem := _cQtdItem              // Quantidade de Item da NF  03 - (20 a 22)
	_cVlTotal := _cVlTotal              // Valor Total da N.Fiscal   17 - (23 a 39)
	_cQtdCd   := "0"                    // Qtde Casas Decimais       01 - (40 a 40)
	_cCfo     := StrZero(Val(_cCfo),5)  // Codigo Fiscal de Operacao 05 - (41 a 45)
	_cVlICMS  := _cVlICMS               // Valor total ICMS Aplicado 17 - (46 a 62)
	_cVencto  := _dVencto               // Data do Vencimento        06 - (63 a 68)
	_cEspecie := "01"                   // Especie da Nota Fiscal    02 - (69 a 70)
	_cVLIPI   := _cVlIPI                // Valor Total do IPI        17 - (71 a 87)
	_cCodFab  := Space(3)               // Codigo da Fabrica         03 - (88 a 90)
	_cDtPrev  := "000000"               // Data Previsao Entrega     06 - (91 a 96)
	_cPerEnt  := space(4)               // Periodo da Entrega        04 - (97 a 100)
	_cDescCfo := _cDescCfo              // Descricao da Nat.Operacao 15 - (101 a 115)
	_cDtEmb   := _dDtEmb                // Data do Embarque          06 - (116 a 121)
	_cHora    := _cHora                 // Hora do Embarque          04 - (122 a 125)
	_cEspaco  := Space(3)               // Espaco em Branco          03 - (126 a 128)

	_cCpo    := _cTpReg + _cNf + _cSer + _cDataNF + _cQtdItem + _cVlTotal + _cQtdCD + _cCfo + _cVlICMS + _cVencto + _cEspecie + _cVlIPI + ;
	_cCodFab + _cDtPrev + _cPerEnt + _cDescCFO + _cDtEmb + _cHora + _cEspaco

	_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	_nContLiR++

	If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE1).  Continua?","Atencao!")
			fClose(_nHdlR)
			Return
		Endif
	Endif

	// - NF2

	_cTpReg   := "NF2"
	_cDespAce := StrZero(Int(SF2->F2_DESPESA*100),12)
	_cFrete   := StrZero(Int(SF2->F2_FRETE*100),12)
	_cSeguro  := StrZero(Int(SF2->F2_SEGURO*100),12)
	_cDescon  := StrZero(Int(SF2->F2_DESCONT*100),12)
	_cBaseICMS:= StrZero(Int(SF2->F2_BASEICM*100),12)
	_cICMS    := StrZero(Int(SF2->F2_VALICM*100),12)

	_cTpReg    := _cTpReg                         // Tipo de Registro           03 - (01 a 03)
	_cDespAce  := _cDespAce                       // Valor Despesas Acessorias  12 - (04 a 15)
	_cFrete    := _cFrete                         // Valor do Frete             12 - (16 a 27)
	_cSeguro   := _cSeguro                        // Valor do Seguro            12 - (28 a 39)
	_cDescon   := _cDescon                        // Valor do Desconto          12 - (40 a 51)
	_cBaseICMS := _cBaseICMS                      // Base de Calculo do ICMS    12 - (52 a 63)
	_cICMS     := _cICMS                          // Valor do ICMS              12 - (64 a 75)
	_cZero     := "000000000000"                  // Numero,Data                06 - (76 a 87)
	_cBranco   := Space(7)                        // Serie,Codigo da Fabrica    36 - (88 a 94)
	_cCfo2     := StrZero(VaL(_cCFO),5)           // Codigo Fiscal Operacao     05 - (95 a 99)
	_cBranco2  := Space(29)                       // Espaco em Branco           29 - (100 a 128)

	_cCpo := _cTpReg+ _cDespAce + _cFrete + _cSeguro + _cDescon + _cBaseICMS + _cICMS + _cZero + _cBranco + _cCfo2 + _cBranco2

	_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	_nContLiR++

	If fWrite(_nHdlR,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo NF2). Continua?","Atencao!")
			fClose(_nHdlR)
			Return
		Endif
	Endif

	_cPedCli := ""

	dbSelectArea("SD2")
	dbOrderNickName("INDSD24")
	If dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		_cChavSD2 :=SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA

		While !Eof() .And. _cChavSD2 == SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA

			_cLin    := Space(128) + _cEOL                         // Tipo de Registro             (3)  M
			_cItem   := "0"+ SD2->D2_ITEM                     // Numero do Item               (3)  M
			_cPedCli := Space(12)
			_cDest   := Space(03)
			dbSelectArea("SC6")
			dbSetOrder(1)
			If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
				_cPedCli := Substr(SC6->C6_PEDCLI,1,12)
				_cDest   := SC6->C6_LOCDEST
			Endif

			dbSelectArea("SZ2")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE+ SD2->D2_LOJA+ SD2->D2_COD + SD2->D2_PROCLI+"1")
				If Empty(_cPedCli)
					_cPedCli := Substr(SZ2->Z2_PEDCLI,1,12)               // Pedido de Compra do Cliente  (12) M
				Endif
				_cRev    := Substr(SZ2->Z2_REVISAO,1,4)
			Endif

			_cProdCli := SD2->D2_PROCLI + Space(15)                  // Codigo do Produto do Cliente (30) M
			_cQtde    := StrZero(Int(SD2->D2_QUANT),9)               // Qtde do Item                 (9)  M

			If Empty(_cProdCli)
				_cProdCli := "S/CODIGO"+ Space(22)
			Endif

			dbSelectArea("SAH")
			dbSetOrder(1)
			If dbSeek(xFilial("SAH")+ SD2->D2_UM)
				_cUm := "PC" //SAH->AH_CODANFA                                // Unidade de medida Anfavea    (2)  M
			Endif

			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+SD2->D2_COD)
				_cClasFis := STRZERO(VAL(SB1->B1_POSIPI),10)           // Classificacao Fiscal  Produto (10) M
			Endif

			_cAliIPI := StrZero(Int(SD2->D2_IPI*100),4)               // Aliquota do IPI                (4)  M
			_cVlItem := StrZero(Int(SD2->D2_PRCVEN*100000),12)        // Valor do Item                  (12) M

			If Len(Alltrim(_cRev)) == 2
				_cRev := Space(2)+Alltrim(_cRev)
			Else
				_cRev := Substr(_cRev,1,4)
			Endif

			_cTpReg    := "AE2"                               // Tipo de Registro           03 - (01 a 03)
			_cItem     := _cItem                              // NUmero do Item da N.Fiscal 03 - (04 a 06)
			_cPedCli   := _cPedCli                            // NUmero do Pedido de Compra 12 - (07 a 18)
			_cProdCli  := _cProdCli                           // Codigo do Item             30 - (19 a 48)
			_cQtde     := _cQtde                              // Qtde do Item na Nota Fiscal09 - (49 a 57)
			_cUM       := _cUm                                // Unidade Medida             02 - (58 a 59)
			_cClasFis  := _cClasFis                           // Classificacao Fiscal       10 - (60 a 69)
			_cAliIPI   := _cAliIPi                            // Aliq. do IPI               04 - (70 a 73)
			_cVlItem   := _cVlItem                            // Valor do Item              12 - (74 a 85)
			_cQtde     := _cQtde                              // Qtde do Item em Estoque    09 - (86 a 94)
			_cUM       := _cUm                                // Unidade Medida Estoque     02 - (95 a 96)
			_cQtde     := _cQtde                              // Qtde do Unidade de Compra  09 - (97 a 105)
			_cUM       := _cUm                                // Unidade Medida de Compra   02 - (106 a 107)
			_cTpForn   := "P"                                 // Tipo de Fornecimento       01 - (108 a 108)
			_cPerDesc  := StrZero(Int(SD2->D2_DESC*100),4)    // Percentual de Desconto     04 - (109 a 112)
			_cValDesc  := StrZero(Int(SD2->D2_DESCON*100),11) // Valor do Desconto          11 - (113 a 123)
			_cRev      := _cRev                               // Alteracao Tecnica do Item  04 - (124 a 127)
			_cBranco   := Space(1)                            // Espaco em branco           01 - (128 a 128)

			_cCpo := _cTpReg + _cItem + _cPedCli + _cProdCli + _cQtde + _cUM + _cClasFis + _cAliIPI + _cVlItem + _cQtde + _cUM + ;
			_cQtde + _cUM + _cTpForn + _cPerDesc + _cValDesc + _cRev + _cBranco

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
			_cCpo := "AE8" + _cNfOri + _cSerOri + _cDtOri + _cItemOri + _cCorrida + _cChassi + _cAutor + space(63)

			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
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

	_cZeros    := Repl('0',28)
	_cLocEnt   := ""

	If SF2->F2_LOJA == "01"
		_cLocEnt := "CAN"
	ElseIf SF2->F2_LOJA == "02"
		_cLocEnt := "SRO"
	ElseIf SF2->F2_LOJA == "03"
		_cLocEnt := "SUM"
	Endif
	_cLocEnt := _cLocEnt +Space(11)

	_cCpo := "AE3"+ _cZeros + _cLocEnt + Space(83)

	_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
	_nContLiV++

	If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo AE3). Continua?","Atencao!")
			fClose(_nHdlV)
			Return
		Endif
	Endif

Return


User Function CNHMai()

	Private _lEnvia    := .F.

	aStru := {}
	AADD(aStru,{"CODPAS"   , "C" , 15, 0 })
	AADD(aStru,{"CODCLI"   , "C" , 15, 0 })
	AADD(aStru,{"PEDIDO"   , "C" , 20, 0 })
	AADD(aStru,{"QTDE"     , "N" , 12, 4 })
	AADD(aStru,{"UNIT"     , "N" , 12, 4 })
	AADD(aStru,{"TOTAL"    , "N" , 12, 4 })

	_cArqTrb := CriaTrab(aStru,.T.)
	_cIndTrb := "CODPAS"

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
		TRB->CODPAS  := ZD2->D2_COD
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
		CNH_M()
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

		AADD( (oHtml:ValByName( "TB.CODPASY"   	)), TRB->CODPAS)
		AADD( (oHtml:ValByName( "TB.CODCLI"     )), TRB->CODCLI)
		AADD( (oHtml:ValByName( "TB.PEDIDO"     )), TRB->PEDIDO)
		AADD( (oHtml:ValByName( "TB.QTDE"       )), TRANSFORM( TRB->QTDE ,   '@E 999,999,999.99' ))
		AADD( (oHtml:ValByName( "TB.UNIT"       )), TRANSFORM( TRB->UNIT ,   '@E 9,999,999.9999' ))
		AADD( (oHtml:ValByName( "TB.TOTAL"      )), TRANSFORM( TRB->TOTAL,   '@E 999,999,999.99' ))

		oProcess:fDesc := "E-mail CNH - Loja "+SF2->F2_LOJA

		TRB->(dbSkip())
	EndDo

	//_cTo := "fabiano@assystem.com.br"
	_cTo := GetMV("PA_WFCNH"+SF2->F2_LOJA)
	_cCc := USRRETMAIL(RETCODUSR())

	oProcess:cTo := _cTo
	oProcess:cCC := _cCC

	oProcess:Start()

	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Envio Email para CNH iniciado!' )

	oProcess:Finish()

Return


User Function CheckEstoq(_cTp,_cNF,_cSerie)

	Local _cData   := DTOS(dDataBase)
	Local _cHora   := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
	Local _cDir    := "\CHECK_ESTOQUE\"
	Local _cArq    := _cTp+_cNF+'_'+_cData+"_"+_cHora+".txt"
	Local _nHandle := FCreate(_cDir+_cArq)

	_cData   := DTOS(dDataBase)
	_cHora   := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

	If _nHandle < 0
		MsgAlert("Erro durante criação do arquivo.")
	Else
		_cQuery := " SELECT SUM(D2_QUANT) AS QUANT, D2_COD,D2_CLIENTE,D2_LOJA,D2_TIPO "
		_cQuery += " FROM "+RetSqlName("SD2")+" D2 "
		_cQuery += " INNER JOIN "+RetSqlName("SF4")+" F4 ON F4_CODIGO = D2_TES "
		_cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 ON D2_COD = B1_COD "
		_cQuery += " WHERE D2.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' "
		_cQuery += " AND F4_ESTOQUE = 'S' AND B1_TIPO = 'PA' "   
		_cQuery += " AND D2_TIPO NOT IN ('C','I','P') "
		_cQuery += " AND D2_DOC+D2_SERIE = '"+_cNF+_cSerie+"' "   
		_cQuery += " GROUP BY D2_COD,D2_CLIENTE,D2_LOJA,D2_TIPO "		
		_cQuery += " ORDER BY D2_COD "

		TCQUERY _cQuery New ALIAS "ZD2"

		Count To _nRec

		If _nRec > 0

			_cLinha := 'NF;PRODUTO;QUANTIDADE;CLIENTE;TIPO'

			FWrite(_nHandle, _cLinha + CRLF)

			ZD2->(dbGoTop())

			While ZD2->(!Eof())

				_cLinha := _cSerie+'-'+_cNF+';'+ZD2->D2_COD+';'+Alltrim(STR(ZD2->QUANT))+';'+ZD2->D2_CLIENTE+'-'+ZD2->D2_LOJA+';'+ZD2->D2_TIPO

				FWrite(_nHandle, _cLinha + CRLF)
                                                                                                                                                                                                                                        				ZD2->(dbSkip())
			EndDo
		
			FClose(_nHandle)

			_cLocRem := Alltrim(GetMV('PA_ESTCRON'))		
			_cLocPas 	:= "\\server2\ERP\Protheus11\Protheus_data\Check_Estoque\"
			
			_aListFile	:= Directory( _cDir + '*.txt' )

			For nI:=1 To Len( _aListFile )

				If CpyS2T(_cDir+AllTrim(_aListFile[nI][1]), _cLocRem,.F. )      
//				If __CopyFile(_cLocPas+AllTrim(_aListFile[nI][1]), _cLocRem+AllTrim(_aListFile[nI][1]))
					FErase(_cDir+AllTrim(_aListFile[nI][1]))
				Endif
			Next nI

		EndIf
		
		ZD2->(dbCloseArea())

	EndIf


Return()