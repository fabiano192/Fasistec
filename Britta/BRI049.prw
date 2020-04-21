#include "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BRI049   º Autor ³ Alexandro          º Data ³  18/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Geracao do arquivo ZZD - Planilha Vendas                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BRI049(_cfilial,cDoc,cSERIE,cCliente,cLoja,_cProduto)

	_aAliOri := GetArea()
	_aAliSA1 := SA1->(GetArea())
	_aAliSA2 := SA2->(GetArea())
	_aAliSF4 := SF4->(GetArea())

	If cTipo == "SF2"
		GERAMOVS()
	ElseIf cTipo == "SC5"
		GERAMOVR()
	Else
		GERAMOVE()
	Endif

Return


Static Function GERAMOVS()

	DbSelectArea("SC6")
	DbSetOrder(1)
	SC6->(MsSeek(QRYSF2->D2_FILIAL + QRYSF2->D2_PEDIDO + QRYSF2->D2_ITEMPV))

	SA1->(dbSetOrder(1))
	SA1->(MsSeek(xFilial("SA1")+ QRYSF2->F2_CLIENTE + QRYSF2->F2_LOJA))

	SB1->(MsSeek(xFilial("SB1")+ QRYSF2->D2_COD))

	_lMargem := .F.
	If !Empty(SB1->B1_GRUPO)
		SBM->(dbSetOrder(1))
		If SBM->(MsSeek(xFilial("SBM")+SB1->B1_GRUPO))
			If SBM->BM_TIPGRU == "11"
				_lMargem := .T.
			Endif
		Endif
	Endif

	Private nPrecoUn	 := 0
	Private nTotNF		 := 0
	Private nTotNFG		 := 0
	Private nIpiG		 := 0
	Private nFrbUn		 := 0
	Private nIcmsG		 := 0
	Private nPisco		 := 0
	Private nPiscoG		 := 0
	Private nFrtUni		 := 0
	Private nFrtTot		 := 0
	Private nPoG		 := 0
	Private nPo 		 := 0
	Private wOrdSZ1		 := 0
	Private wRecSZ1		 := 0
	Private aOrdem		 := fPesqSZ8()
	Private cTempo		 := "  :  "
	Private aCliente	 := fPesqSA1(cTipo)
	Private naliqext     := 0
	Private _esticm	     := alltrim(getmv("MV_ESTICM"))
	Private _estado      := GetMV("MV_ESTADO")
	Private _picmest     := Val(Subs(_esticm,at(_estado,_esticm)+2,2))
	Private naliqext     := 0
	Private ndifaliq     := 0
	Private wPIRCSL      := 0
	Private nBaseIcmsG   := 0
	Private _lGerenc     := .T.
	Private aNota		 := fPesqSD2()

	Private nCusTran	 := aNota[7]
	Private nCustSac	 := aNota[10]
	Private aProduto	 := fPesqSB1()
	Private nQtdTB		 := aNota[3]
	Private cTipCar		 := aProduto[4]
	Private cDescCarga	 := fPesqDB0()

	nQtdeGra		:= aNota[3]

	Private cPrefixo	:= "FAT"
	Private aPedido		:= fPesqSC6()
	Private cGrupo		:= aNota[15] //GRUPO
	Private cCampo2		:= fPesqZZA(xFilial('ZZA') + "02             ")
	Private cCampo3		:= fPesqZZA(xFilial('ZZA') + "03             ")
	Private cCampo4		:= fPesqZZA(xFilial('ZZA') + "04             ")
	Private cCampo5		:= fPesqZZA(xFilial('ZZA') + "05             ")

	If Empty(Filial('SE1') )
		_cFilSE1 := Space(02)
	Else
		_cFilSE1 := QRYSF2->F2_FILIAL
	Endif

	Private aCReceb 	:= fPesqSE1(_cFilSE1 + QRYSF2->F2_CLIENTE + QRYSF2->F2_LOJA + QRYSF2->F2_SERIE + QRYSF2->F2_DOC)
	Private nValor14	:= fPesqSE4()
	Private nValor16	:= aPedido[8]  // Peso real
	Private nValor17	:= aPedido[10] // Peso NF
	Private cTes		:= aNota[5]
	Private cAtividade	:= ""//fPesqSX5() // Busca a partir da Atividade Gerencial SX5('YI') Se Ativ.Real nao preenchida, entao retornara Atividade
	Private cRegiao		:= fPesqSZ4()
	Private cDescRegiao	:= fPesqSZO() // Cadastro de Regioes ZO_DESC
	Private wTES		:= ""
	Private nICMSRetG	:= 0
	Private nProdG		:= 0
	Private	cPrefixo    := QRYSF2->F2_PREFIXO

	Private nMedia		:=  fPesqSE4()
	Private nAliqICM	:= aNota[6]
	Private nFRE3Tot	:= 0 // Frete NF + Custo Transporte Total
	Private nFRE3Un		:= 0 // Frete NF + Custo Transporte Unitário
	Private	nPisNF      := 0 // PIS na NFS
	Private nCOFNF      := 0 // COFINS na NFS
	Private nPISGER     := 0 // PIS gerencial
	Private nCOFGER     := 0 // COFINS gerencial
	Private cDESTES		:= fPesqSF4() // Descrição da TES

	nTotNF	:= QRYSF2->D2_VALBRUT
	nTotNFG	:= QRYSF2->D2_VALBRUT

	nPrecoUn := Round(nTotNF / nQtdeGra,2)

	If _lGerenc
		nTotNFG := aNota[8] * nQtdTB			    // Preco gerencial * quantidade em tons
	EndIf

	naliqext := 12
	nD2Aliq  := 1+ ( ( _picmest - naliqext ) / 100 )

	If QRYSF2->F2_ICMSRET > 0 .And. _lGerenc //aNota[8] <> 0 //Preco Gerencial

		nProdG := ROUND(      ((nTotnfg  /  nDifAliq )    -   (QRYSF2->D2_VALFRE * 1.04) ) / 1.04 , 2 )

		nIcmsRetG :=  ( ( nProdG + QRYSF2->F2_FRETE )  * 1.04) * ( ndifaliq  - 1 )

	Else // produto gerencial sem ICMS RETIDO
		nProdG := ROUND(  (nTotNFG  /  1.04 ) -  QRYSF2->D2_VALFRE,2 )
	EndIf

	if QRYSF2->F2_VALIPI = 0
		nIpiG:= 0
	Else
		nIpiG	:= Round((((nTotNFG - QRYSF2->D2_VALFRE*1.04)-nICMSRETG)/1.04+QRYSF2->D2_VALFRE)*0.04,2)
	EndIf

	nFrbUn	:= QRYSF2->D2_VALFRE / nQtdTB

//If QRYSF2->F2_ICMSRET > 0 .And. aNota[8] <> 0 //Preco Gerencial
	If QRYSF2->F2_ICMSRET > 0 .And. _lGerenc //aNota[8] <> 0 //Preco Gerencial
		naliqext := 12
		nProduto := nTotNFG - ( 1.05 * QRYSF2->D2_VALFRE ) - ( 1.05 * nIpiG )

		nProduto  := Round(nProduto / 1.05,2)
		ndifaliq  := ( _picmest - naliqext ) / 100
		nIcmsRetG := ( nProduto + QRYSF2->F2_FRETE + nIpiG ) * ndifaliq
	EndIf

	If cEmpAnt + cFilAnt $ "0209/5010"
		nBaseIcmsG := 0
		nIcmsG	   := 0
		nICMSRetG  := 0
	Else
		If !_lGerenc
			nIcmsG	  := QRYSF2->D2_VALICM
			nICMSRetG := QRYSF2->D2_ICMSRET
			nIPIG     := QRYSF2->D2_VALIPI
		Else
			_nAliq := aNota[6]
			If Empty(aNota[6])
				_nAliq := GETMV("MV_ICMPAD")
			Endif

			nBaseIcmsG := nTotNFG
			nIcmsG	   := Round(nBaseIcmsG  * (_nAliq / 100) ,2)
		EndIf
	Endif

	nPisco	:= 0
	nPiscoG	:= 0

	nPisco  := aNota[11] + aNota[12]
	nPisNF  := aNota[11]
	nCOFNF  := aNota[12]
	_nISSNF := aNota[17]

	_nTxPIS	:= SuperGetMV("MV_TXPIS")
	_nTxCOF	:= SuperGetMV("MV_TXCOFIN")
	_nPerc  := (_nTxPIS + _nTxCOF ) / 100
	_nTxISS := SB1->B1_ALIQISS / 100

	nPiscoG	:= Round(nTotNFG  * _nPerc,2)

	If !_lGerenc
		nPiscoG  := nPisco
		nPISGER  := nPisNF
		nCOFGER  := nCOFNF

		If cEmpAnt == "04"
			_nISSGER := _nISSNF
		Endif
	Else
		nPISGER := Round(nTotNFG * (_nTxPIS / 100) ,2)
		nCOFGER := Round(nTotNFG * (_nTxCOF / 100) ,2)

		If cEmpAnt == "04"
			_nISSGER := Round(nTotNFG * _nTxISS,2)
		Endif

	EndIf

	nFrtUni  := nFrbUn
	nFrtUni  := nFrtUni

// ALTERADO EM 30/03/20

	If cEmpAnt + cFilAnt $ "5001/5002/5004/5005/5006/5007/5008/5013/5016" .AND. SA1->A1_YTPCLI = "2"
	nFrtTot	 := Round(QRYSF2->D2_QUANT * QRYSF2->D2_YFREGER,2)
		nFrtUni  := QRYSF2->D2_YFREGER
	Else
		nFrtTot	 := 0 // QRYSF2->D2_VALFRE  alterado em 16/04/20
	ENDIF

	nFRE3Tot := aPedido[15]
	nMARGEG  := Round((nTotNFG - nIpiG - nIcmsG - nIcmsRetG - nPiscoG - QRYSF2->D2_VALFRE - 0) / nQtdeGra,2)   -  aNota[9]	   // Margem de Lucro
	nIRCSLG  := IF(nMARGEG > 0 ,(nQtdeGra * nMARGEG * wPIRCSL),0)
	wwTotNFG := 0
	wwTotNFG := nTotNFG

	DbSelectArea("ZZD")
	DbSetOrder(10)

	SF4->(dbSetOrder(1))
	SF4->(MsSeek(xFilial("SF4") + QRYSF2->D2_TES))

	SE4->(dbSetOrder(1))
	SE4->(MsSeek(xFilial("SE4") + QRYSF2->F2_COND))

	aZZD	:= GetArea("ZZD")

	_nCusto := 0
	Z05->(dbSetOrder(1))
	If Z05->(MsSeek(xFilial("Z05") + cEmpAnt + cFilAnt + DTOS(FIRSTDAY(QRYSF2->F2_EMISSAO))))
		_nCusto := Z05->Z05_CUSTO
	Endif

	If MsSeek(xFilial("ZZD")+cEmpAnt+cFilAnt+QRYSF2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_ITEM))
		RecLock("ZZD",.F.)
	Else
		RecLock("ZZD",.T.)
	EndIf

	If Empty(xFilial("ZZD"))
		ZZD->ZZD_FILIAL	:= xFilial("ZZD")
	Else
		ZZD->ZZD_FILIAL	:= QRYSF2->F2_FILIAL
	Endif

	_aSA1Box := RetSx3Box( Posicione("SX3", 2, "A1_YTPCLI", "X3CBox()" ),,, 1 )
	nAscan   := Ascan( _aSA1Box, { |e| e[2] = SA1->A1_YTPCLI } )

	If nAscan > 0
		If ZZD->(FieldPos("ZZD_TPCLI")) > 0
			ZZD->ZZD_TPCLI := AllTrim( _aSA1Box[nAscan][3] )
		Endif
	Endif

	_aSF4Box := RetSx3Box( Posicione("SX3", 2, "F4_YTPVEND", "X3CBox()" ),,, 1 )
	nAscan   := Ascan( _aSF4Box, { |e| e[2] = SF4->F4_YTPVEND } )

	If nAscan > 0
		If ZZD->(FieldPos("ZZD_TPVEND")) > 0
			ZZD->ZZD_TPVEND  := AllTrim( _aSF4Box[nAscan][3] )
		Endif
	Endif

	ZZD->ZZD_EMIS		:= QRYSF2->F2_EMISSAO
	ZZD->ZZD_ANOMES	    := Left(DtoS(QRYSF2->F2_EMISSAO),6)	 //Ano Mes
	ZZD->ZZD_HRSAID	    := QRYSF2->F2_HORA             // HORA DE SAIDA DA NF
	ZZD->ZZD_PROD		:= aNota[1]					// Cod. produto
	ZZD->ZZD_DESCPR	    := aProduto[8]				// Descricao do Produto
	ZZD->ZZD_DESCRE	    := aProduto[9]				// Descricao Resumida do Produto
	ZZD->ZZD_DESGR 	    := aProduto[10]				// Descricao do Produto
	ZZD->ZZD_DESSGR	    := aProduto[11]				// Descricao Resumida do Produto
	ZZD->ZZD_CLIE		:= QRYSF2->F2_CLIENTE			// Cod. cliente
	ZZD->ZZD_LOJA		:= QRYSF2->F2_LOJA				// Loja
	ZZD->ZZD_NOME		:= aCliente[1]				// Nome cliente
	ZZD->ZZD_SERIE		:= QRYSF2->F2_SERIE			// Serie documento
	ZZD->ZZD_DOC		:= QRYSF2->F2_DOC				// Num. documento
	ZZD->ZZD_ITEM       := QRYSF2->D2_ITEM
//ZZD->ZZD_QTBRUT     := QRYSF2->D2_QUANT
//ZZD->ZZD_QTLIQ	  := QRYSF2->D2_QUANT
	ZZD->ZZD_QTBRUT     := aNota[3]
	ZZD->ZZD_QTLIQ		:= aNota[3]
	ZZD->ZZD_PRECO		:= nPrecoUn					// Buscar no SD2
	ZZD->ZZD_PRECOG	    := nTotNFG / ZZD->ZZD_QTLIQ
	If QRYSF2->F2_TIPO = "D"
		ZZD->ZZD_TOTNF	:= nTotNF * -1		// Valor total da NF
	Else
		ZZD->ZZD_TOTNF	:= nTotNF		// Valor total da NF
	Endif

	If QRYSF2->F2_TIPO = "D"
		ZZD->ZZD_IPI	:= QRYSF2->D2_VALIPI	* -1		// IPI
		ZZD->ZZD_TOTLIQ := (ZZD->ZZD_TOTNF - ZZD->ZZD_IPI) * -1
		ZZD->ZZD_ICMS	:= IF (QRYSF2->D2_VALISS > 0, 0, QRYSF2->D2_VALICM	* -1)
		If ZZD->(FieldPos("ZZD_VALISS")) > 0
			ZZD->ZZD_VALISS := QRYSF2->D2_VALISS	* -1
		Endif
	Else
		ZZD->ZZD_IPI	:= QRYSF2->D2_VALIPI			                    // IPI
		ZZD->ZZD_TOTLIQ := ZZD->ZZD_TOTNF - ZZD->ZZD_IPI
		ZZD->ZZD_ICMS	:= IIF(QRYSF2->D2_VALISS > 0, 0, QRYSF2->D2_VALICM)	// ICMS
		If ZZD->(FieldPos("ZZD_VALISS")) > 0
			ZZD->ZZD_VALISS := QRYSF2->D2_VALISS	                            // ISS
		Endif
	Endif

	If QRYSF2->F2_TIPO = "I"
		ZZD->ZZD_ALQICM     := QRYSF2->D2_PICM
	Else
		ZZD->ZZD_ALQICM     := (ZZD->ZZD_ICMS / ZZD->ZZD_TOTNF ) * 100
	Endif

	ZZD->ZZD_PRCLIQ     := ZZD->ZZD_TOTLIQ / ZZD->ZZD_QTLIQ

	If QRYSF2->F2_TIPO = "D"
		If _lGerenc
			ZZD->ZZD_TOTNFG	:= (ZZD->ZZD_QTLIQ * ZZD->ZZD_PRECOG) *-1
		Else
			ZZD->ZZD_TOTNFG	:= ZZD->ZZD_TOTLIQ
		Endif
	Else
		If _lGerenc
			ZZD->ZZD_TOTLIG   := nTotNFG
			ZZD->ZZD_IPIG	  := ZZD->ZZD_TOTLIG * (QRYSF2->D2_IPI /100)	   // IPI Gerencial
			ZZD->ZZD_TOTNFG	  := nTotNFG
			ZZD->ZZD_ICMSG	  := nIcmsG
			ZZD->ZZD_PISGER   := nPISGER
			ZZD->ZZD_COFGER   := nCOFGER
			ZZD->ZZD_RETG	  := nICMSRetg
			ZZD->ZZD_PISCOG	  := nPiscoG					// Pis/Cofins (gerencial)
			ZZD->ZZD_DEICDC   := ((ZZD->ZZD_IPIG - ZZD->ZZD_IPI + ZZD->ZZD_ICMSG - ZZD->ZZD_ICMS)/2)
		Else
			ZZD->ZZD_TOTLIG   := ZZD->ZZD_TOTLIQ
			ZZD->ZZD_IPIG	  := ZZD->ZZD_TOTLIG * (QRYSF2->D2_IPI /100)	   // IPI Gerencial
			ZZD->ZZD_TOTNFG	  := ZZD->ZZD_TOTLIG + 	ZZD->ZZD_IPIG
			ZZD->ZZD_ICMSG	  := IF (QRYSF2->D2_VALISS > 0, 0, QRYSF2->D2_VALICM)	// ICMS
			ZZD->ZZD_PISGER   := aNota[11]
			ZZD->ZZD_COFGER   := aNota[12]
			ZZD->ZZD_RETG	  := nICMSRetg
			ZZD->ZZD_PISCOG	  := nPisco					// Pis/Cofins (gerencial
		Endif
	Endif

	If cEmpAnt + QRYSF2->F2_FILIAL $  "5001/5002/5005/5006/5007" .And. SA1->A1_YTPCLI == "2"
		ZZD->ZZD_ICMSG  := 0
		ZZD->ZZD_PISGER := 0
		ZZD->ZZD_COFGER := 0
	Endif

	ZZD->ZZD_RET		:= QRYSF2->D2_ICMSRET		// ICMS Retido
	ZZD->ZZD_PISCO		:= nPisco					// Pis/Cofins
	ZZD->ZZD_PIS		:= aNota[11] 				//SF2->F2_VALIMP6
	ZZD->ZZD_COFINS	    := aNota[12]				//SF2->F2_VALIMP5
	ZZD->ZZD_FRETOT	    := nFrtTot					// Frete total
	ZZD->ZZD_FREUNI	    := nFrtUni					// Frete liquido unitario (gerencial)
	ZZD->ZZD_MUNEND	    := acliente[9]
	ZZD->ZZD_UF			:= acliente[5]				// Estado destino
	ZZD->ZZD_COND		:= QRYSF2->F2_COND				// Condicao de pagamento
	If SE4->(FieldPos("E4_YMEDIA")) > 0
		ZZD->ZZD_PM			:= SE4->E4_YMEDIA			// Prazo medio
	Endif
	ZZD->ZZD_VEND		:= QRYSF2->F2_VEND1 			// Vendedor
	ZZD->ZZD_NMVEND	    := POSICIONE("SA3",1,XFILIAL("SA3")+QRYSF2->F2_VEND1,"A3_NOME")
	ZZD->ZZD_ATIVI		:= aCliente[2]				// Atividade do cliente
	ZZD->ZZD_ATIVG		:= aCliente[3]				// Atividade 'real' do cliente
	ZZD->ZZD_FRBR		:= QRYSF2->D2_VALFRE    	// Frete bruto
	ZZD->ZZD_FRBRUN	    := nFrbUn					// Frete bruto unitario (Gerencial)
	ZZD->ZZD_KM			:= 0						// Distancia da Matriz ao cliente em Km
	ZZD->ZZD_KMR		:= 0						// Raio em Km -- ??
	ZZD->ZZD_TRANS		:= QRYSF2->F2_TRANSP			// Transportadora
	ZZD->ZZD_NOMTRA	    := POSICIONE("SA4",1,XFILIAL("SA4")+QRYSF2->F2_TRANSP,"A4_NOME")			// Transportadora
	ZZD->ZZD_CARRE		:= QRYSF2->F2_PLACA
	ZZD->ZZD_CARRO		:= ""
	ZZD->ZZD_MOTOR      := ""
	ZZD->ZZD_PREF		:= cPrefixo					// Prefixo padrao do parametro conforme a filial atual
	ZZD->ZZD_YTPCAR	    := cTipCar					// Tipo de Carga
	ZZD->ZZD_YDEV		:= ""
	ZZD->ZZD_YNFSUB	    := ""
	ZZD->ZZD_TES		:= aNota[5]					// TES em SD2
	ZZD->ZZD_UM		    := aNota[14]				// UM

	If QRYSF2->F2_DOC = '000041892'
		_lPare := .T.
	Endif

	_AreaSZA := SZA->(GetArea())
	SZA->(dbsetorder(4))
	If SZA->(msSeek(QRYSF2->F2_FILIAL+QRYSF2->F2_DOC+QRYSF2->F2_SERIE))
		If SZA->(FieldPos("ZA_HORA04")) > 0
			If !Empty(SZA->ZA_HORA01)
			/*If Empty(SZA->ZA_HORA04)
				If !Empty(SZA->ZA_HORA03)
					cTempo := SetHora(SubHoras(SZA->ZA_HORA03,SZA->ZA_HORA01),'S')
				Endif
			Else
				cTempo := SetHora(SubHoras(SZA->ZA_HORA04,SZA->ZA_HORA01),'S')
			Endif*/
			
			If Empty(SZA->ZA_HORA03) //.OR. SZA->ZA_HORA03 < '0'
				If !Empty(SZA->ZA_HORA04)
					cTempo := SetHora(SubHoras(SZA->ZA_HORA04,SZA->ZA_HORA01),'S')
				Endif
			Else
				cTempo := SetHora(SubHoras(SZA->ZA_HORA03,SZA->ZA_HORA01),'S')
			Endif
		Endif
	Endif
Endif
RestArea(_AreaSZA)

ZZD->ZZD_TEMPO		:= cTempo					// Tempo entre entrada na balanca e saida do faturamento
ZZD->ZZD_GRUPO		:= cGrupo					// Grupo
ZZD->ZZD_CPO2		:= cCampo2					// Segmento
ZZD->ZZD_CPO3		:= cCampo3					// Empresas
ZZD->ZZD_CPO4		:= cCampo4					// Regional
ZZD->ZZD_CPO5		:= cCampo5					// Filial
ZZD->ZZD_CPO7		:= cDescCarga				// Embalagem
ZZD->ZZD_CPO8		:= cAtividade				// Atividade
ZZD->ZZD_CPO12		:= cDescRegiao				// Regiao de Entrega
//If aNota[8] <> 0 								// Preco Gerencial
If _lGerenc
	ZZD->ZZD_DEVCDC	:= nTotNFG - ZZD->ZZD_TOTLIQ
Else
	ZZD->ZZD_DEVCDC	:= 0
Endif
ZZD->ZZD_CPO17		:= If(Empty(QRYSF2->F2_TRANSP),'N/CADASTRADO',QRYSF2->F2_TRANSP)  // Transportadora
ZZD->ZZD_CPO21		:= If(Empty(cTes),'N/CADASTRADO',cTes)	// Tes
ZZD->ZZD_CPO22		:= aCliente[4]				            // Data primeiro faturamento
ZZD->ZZD_VLR16		:= aPedido[11]				                            // Peso Saida da Ordem de Carregamento - Marciane pediu em 11/07/05
ZZD->ZZD_VLR17		:= If(aProduto[6] $ "BB/TB",aOrdem[3]*aProduto[7],aOrdem[3])// Peso NF
ZZD->ZZD_YDIAST	    := aOrdem[5]-IIf(Empty(aOrdem[9]),aOrdem[5],aOrdem[9])   // Z8_DTSAIDA - Z1_YDTLIB
ZZD->ZZD_YHORAT     := ElapTime(aOrdem[10]+":00",aOrdem[8]+":00") // Z1_HLIB + Hora da Saida (Z8_HSAIDA)
ZZD->ZZD_YOC        := aOrdem[6]

If Val(Subs(ZZD->ZZD_YHORAT,1,2)) > 0 .or. Val(Subs(ZZD->ZZD_YHORAT,4,2)) > 0
	ZZD->ZZD_YTOTDT  := ((ZZD->ZZD_YDIAST*24)+Val(Subs(ZZD->ZZD_YHORAT,1,2)))/24
Else
	ZZD->ZZD_YTOTDT  := 0
Endif

ZZD->ZZD_TPROD      := QRYSF2->F2_VALMERC
ZZD->ZZD_TPRODG     := IIf( ZZD->ZZD_TOTNFG > 0, nProdG, 0 )

If aProduto[6]$("BB/TB/UN")
	ZZD->ZZD_YPESTB	:= aProduto[7]
EndIf

ZZD->ZZD_CODEMP	:= cEmpAnt
ZZD->ZZD_CODFIL	:= QRYSF2->F2_FILIAL
ZZD->ZZD_NOMFIL := POSICIONE("SM0",1,cEmpAnt + QRYSF2->F2_FILIAL,"M0_FILIAL")

_cSigl := ""
If ZZD->(FieldPos("ZZD_SIGLA2")) > 0
	If cEmpAnt == "02"
		If QRYSF2->F2_FILIAL == "01"
			_cSigl := "PX-IBA"
		ElseIf QRYSF2->F2_FILIAL == "02"
			_cSigl := "PX-IDC"
		ElseIf QRYSF2->F2_FILIAL $ "03/04"
			_cSigl := "  "
		ElseIf QRYSF2->F2_FILIAL == "05"
			_cSigl := "PX-IJB"
		ElseIf QRYSF2->F2_FILIAL == "06"
			_cSigl := "PX-IFT"
		ElseIf QRYSF2->F2_FILIAL == "07"
			_cSigl := "PX-IMC"
		ElseIf QRYSF2->F2_FILIAL == "08"
			_cSigl := "PX-INT"
		ElseIf QRYSF2->F2_FILIAL == "09"
			_cSigl := "PX-ISV"
		ElseIf QRYSF2->F2_FILIAL == "10"
			_cSigl := "PX-IBA"
		ElseIf QRYSF2->F2_FILIAL == "11"
			_cSigl := "PX-IPT"
		ElseIf QRYSF2->F2_FILIAL == "12"
			_cSigl := "PX-IGU"
		ElseIf QRYSF2->F2_FILIAL == "13"
			_cSigl := "PX-ICC"
		ElseIf QRYSF2->F2_FILIAL == "14"
			_cSigl := "PX-ISL"
		Endif
	ElseIf cEmpAnt == "04"
		If QRYSF2->F2_FILIAL $ "01"
			If ZZD->ZZD_PRECO > SUPERGETMV("BRI_VALCAP",.F.,180)
				_cSigl := "MSP C/CAP"
			Else
				_cSigl := "MSP S/CAP"
			Endif
			
			//SZ2->(dbSetOrder(4))
			//If SZ2->(MsSeek(QRYSF2->F2_FILIAL + QRYSF2->F2_CLIENTE + QRYSF2->F2_LOJA + QRYSF2->D2_COD ))
			//	If SZ2->Z2_VENDCAP == "1"
			//		_cSigl := "MSP S/CAP"
			//	Else
			//		_cSigl := "MSP C/CAP"
			//	Endif
			//Else
			//	_cSigl := "MSP C/CAP"
			//Endif
			
		ElseIf QRYSF2->F2_FILIAL == "02"
			_cSigl := "MRE"
		Endif
	ElseIf cEmpAnt == "05"
		_cSigl := "MRE"
	ElseIf cEmpAnt == "09"
		_cSigl := "PX-IMC"
	ElseIf cEmpAnt == "13"
		If QRYSF2->F2_FILIAL     $ "01"
			_cSigl := "PX-IRO"
		ElseIf QRYSF2->F2_FILIAL $ "04"
			_cSigl := "PX-IBA"
		ElseIf QRYSF2->F2_FILIAL == "06"
			_cSigl := "PX-IRO"
		ElseIf QRYSF2->F2_FILIAL == "07"
			_cSigl := "PX-IBA"
		Endif
	ElseIf cEmpAnt == "16"
		_cSigl := "PX-IPT"
	ElseIf cEmpAnt == "50"
		If QRYSF2->F2_FILIAL == "01"
			_cSigl := "PX-IBA"
		ElseIf QRYSF2->F2_FILIAL == "02"
			_cSigl := "PX-IRO"
		ElseIf QRYSF2->F2_FILIAL == "03"
			_cSigl := "PX-IFT"
		ElseIf QRYSF2->F2_FILIAL == "04"
			_cSigl := "PX-INT"
		ElseIf QRYSF2->F2_FILIAL == "05"
			_cSigl := "PX-IDC"
		ElseIf QRYSF2->F2_FILIAL == "06"
			_cSigl := "PX-IGU"
		ElseIf QRYSF2->F2_FILIAL == "07"
			_cSigl := "PX-ICC"
		ElseIf QRYSF2->F2_FILIAL == "08"
			_cSigl := "PX-ISL"
		ElseIf QRYSF2->F2_FILIAL == "09"
			_cSigl := "PX-IJB"
		ElseIf QRYSF2->F2_FILIAL == "10"
			_cSigl := "PX-ISV"
		ElseIf QRYSF2->F2_FILIAL == "11"
			_cSigl := "PX-IRB"
		ElseIf QRYSF2->F2_FILIAL == "12"
			_cSigl := "PX-AE "
		ElseIf QRYSF2->F2_FILIAL == "13"
			_cSigl := "PX-IPT"
		ElseIf QRYSF2->F2_FILIAL == "14"
			_cSigl := "PX-MT"
		ElseIf QRYSF2->F2_FILIAL == "15"
			_cSigl := "PX-IMC"
		ElseIf QRYSF2->F2_FILIAL == "16"
			_cSigl := "PX-INH"
		Endif
	Endif
	
	ZZD->ZZD_SIGLA2 := _cSigl
Endif

cSigla:= SuperGetMv( "BRI_SIGLA" , .F. , , QRYSF2->F2_FILIAL ) //  getNewPar('BRI_SIGLA','BRI ')

ZZD->ZZD_SIGLA  := cSigla

//If ZZD->ZZD_CODEMP + ZZD->ZZD_CODFIL $ "5001/5002/5004/5005/5006/5007/5008/5013/5016" .And. SA1->A1_YTPCLI = "2"
//	nCalcPoG:= 0
//Else	
//	nCalcPoG:= (ZZD->ZZD_TOTNFG - ZZD->ZZD_ICMSG - ZZD->ZZD_PISGER - ZZD->ZZD_COFGER ) / ZZD->ZZD_QTLIQ
//Endif

If QRYSF2->F2_TIPO $ "C/I"
	_nFOBL := 0
	_nCIFL := 0
	_ 
ElseIf SA1->A1_YTPCLI == "2"
	_nFOBL := (ZZD->ZZD_TOTNFG - ZZD->ZZD_ICMSG - ZZD->ZZD_PISGER - ZZD->ZZD_COFGER ) / ZZD->ZZD_QTLIQ
	_nCIFL := (ZZD->ZZD_TOTNFG + ZZD->ZZD_FRETOT                                    ) / ZZD->ZZD_QTLIQ
Else
	_nFOBL := (ZZD->ZZD_TOTNFG - ZZD->ZZD_ICMSG - ZZD->ZZD_PISGER - ZZD->ZZD_COFGER - ZZD->ZZD_FRETOT ) / ZZD->ZZD_QTLIQ
	_nCIFL := ZZD->ZZD_TOTNFG + ZZD->ZZD_FRETOT
Endif

nCalcPoG:= iif( nCalcPoG <0 , 0 , nCalcPoG )

nPoG            := nCalcPoG
ZZD->ZZD_PO		:= If (_nFOBL < 0,0, _nFOBL)
ZZD->ZZD_FOBL	:= If (_nFOBL < 0,0, _nFOBL)
ZZD->ZZD_CIFL   := If (_nCIFL < 0,0, _nCIFL)
 
ZZD->ZZD_MASSAG	:= ( ZZD->ZZD_TOTNF - ZZD->ZZD_IPI - ZZD->ZZD_ICMS - ZZD->ZZD_RET - ZZD->ZZD_PIS - ZZD->ZZD_COFINS - nFrtTot)

nPo	            := nPoG
ZZD->ZZD_MASSA  := ( ZZD->ZZD_TOTNF - ZZD->ZZD_IPI - ZZD->ZZD_ICMS - ZZD->ZZD_RET - ZZD->ZZD_PIS - ZZD->ZZD_COFINS - nFrtTot)

ZZD->ZZD_CUSTO	:= _nCusto

//If _lMargem
//	If ZZD->ZZD_CODEMP + ZZD->ZZD_CODFIL $ "5001/5002/5004/5005/5006/5007/5008/5013/5016" .And. SA1->A1_YTPCLI = "2"
//		ZZD->ZZD_MARGEM	:= 0
//		ZZD->ZZD_MARGEG	:= 0
//    Else
//		ZZD->ZZD_MARGEM	:= ZZD->ZZD_PO - ZZD->ZZD_CUSTO
//		ZZD->ZZD_MARGEG	:= ZZD->ZZD_PO - ZZD->ZZD_CUSTO
//	Endif
//Endif

If _lMargem
	ZZD->ZZD_MARGEM	:= ZZD->ZZD_FOBL - ZZD->ZZD_CUSTO
	ZZD->ZZD_MARGEG	:= ZZD->ZZD_FOBL - ZZD->ZZD_CUSTO
Endif

nPO := Round((nTotNFG - nIpiG - nIcmsG - nIcmsRetG - nPiscoG - nFrtTot - 0) / nQtdeGra,2)
nPO -= If(cTipCar = "S",nCustSac,0)
ZZD->ZZD_YPEDAG := 0
ZZD->ZZD_YCTR  	:= ""
ZZD->ZZD_YSERCT := ""
ZZD->ZZD_IRCSL  := IF(ZZD->ZZD_MARGEM > 0 ,(nQtdeGra * ZZD->ZZD_MARGEM * wPIRCSL),0)
ZZD->ZZD_IRCSLG := IF(ZZD->ZZD_MARGEG > 0 ,(nQtdeGra * ZZD->ZZD_MARGEG * wPIRCSL),0)
aZZD			:= GetArea("ZZD")

If Alltrim(cTipCar) $ "CDC*G"
	ZZD->ZZD_PERFIL := "GRANEL"
ELSEIF cTipCar = "S"
	ZZD->ZZD_PERFIL := "TAMBOR"
Endif

ZZD->ZZD_CFOP   := aNota[13]
ZZD->ZZD_TIPONF := QRYSF2->F2_TIPO
ZZD->ZZD_TIPOMT := aProduto[12]
ZZD->ZZD_DESTES := cDESTES[2]

//If QRYSF2->D2_VALFRE > 0
//	ZZD->ZZD_QTCIF  := ZZD->ZZD_QTLIQ
//	ZZD->ZZD_TPFRE	:= "C"
//Else
//	ZZD->ZZD_TPFRE	:= "F"
//	ZZD->ZZD_QTCIF  := 0
//Endif

If ZZD->ZZD_FRETOT > 0
	ZZD->ZZD_QTCIF  := ZZD->ZZD_QTLIQ
	ZZD->ZZD_TPFRE	:= "C"
Else
	ZZD->ZZD_TPFRE	:= "F"
	ZZD->ZZD_QTCIF  := 0
Endif


//ZZD->ZZD_QTCIF  := iif(  ZZD->ZZD_TPFRE=='C', ZZD->ZZD_QTLIQ , 0 )
ZZD->ZZD_MARTOT := (ZZD->ZZD_MARGEG*ZZD->ZZD_QTLIQ)+ZZD->ZZD_DEICDC
ZZD->ZZD_FRE3U  := nFRE3Un
ZZD->ZZD_YMUN   := SA1->A1_MUN
ZZD->ZZD_YEST   := SA1->A1_EST

If ZZD->(FieldPos("ZZD_NREDUZ")) > 0
	ZZD->ZZD_NREDUZ:= SA1->A1_NREDUZ
Endif

If QRYSF2->F2_TIPO <> 'D'
	ZZD->ZZD_GRPVEN  := SA1->A1_GRPVEN
Endif

ZZD->ZZD_DESGRU  := POSICIONE("SBM",1,XFILIAL("SBM")+cGrupo,"BM_DESC")
zzd->zzd_itemct  := posicione('SB1',1,xfilial('SB1')+aNota[1],'B1_ITEMCC')

do case
case anota[14] $ 'BB/TB' //unidade de medida
	if aCliente[8] =='S' // a1_yfilpol - filial polimix
			zzd->zzd_itemct := '010104'
	else
			zzd->zzd_itemct := '010102'
	endif
case anota[14] == 'KG'
	if aCliente[8] =='S'
			zzd->zzd_itemct := '010103'
	else
			zzd->zzd_itemct := '010101'
	endif
endcase

ZZD->ZZD_DESITE:= posicione('CTD',1,xfilial('CTD')+zzd->zzd_itemct,'CTD_DESC01')

If QRYSF2->F2_TIPO = "D"
	ZZD->ZZD_PISNF  := nPisNF * -1
	ZZD->ZZD_COFNF  := nCOFNF * -1
Else
	ZZD->ZZD_PISNF  := nPisNF
	ZZD->ZZD_COFNF  := nCOFNF
Endif

ZZD->ZZD_FATURA := aCReceb[2]
ZZD->ZZD_DTFAT  := aCReceb[3]
ZZD->ZZD_NFORI  := QRYSF2->D2_NFORI
ZZD->ZZD_SERORI := QRYSF2->D2_SERIORI

If !Empty(QRYSF2->D2_NFORI)
	SD1->(dbSetOrder(1))
	If SD1->(MsSeek(QRYSF2->D2_FILIAL+ QRYSF2->D2_NFORI + QRYSF2->D2_SERIORI + QRYSF2->D2_CLIENTE + QRYSF2->D2_LOJA + QRYSF2->D2_COD + QRYSF2->D2_ITEMORI))
		ZZD->ZZD_TESORI := SD1->D1_TES
	Endif
Endif

If QRYSF2->F2_FRETE > 0
	_nValfrete:= QRYSF2->F2_FRETE
Else
	_nValfrete:= QRYSF2->D2_PDFRETT
Endif

ZZD->ZZD_QTDIES := QRYSF2->F2_PDLITQT
ZZD->ZZD_UNIDIE := QRYSF2->F2_pdlitun
ZZD->ZZD_VALDIE := QRYSF2->F2_pdlitto
ZZD->ZZD_FRECTE := _nValfrete
ZZD->ZZD_SDOCTE :=  ZZD->ZZD_FRECTE - ZZD->ZZD_VALDIE

DbSelectArea("ZZD")
MsUnlock()
RestArea(aZZD)

RestArea(_aAliSA1)
RestArea(_aAliSA2)
RestArea(_aAliSF4)
RestArea(_aAliOri)

Return 'fim'

Static Function fPesqSA1(cTipo)

	If cTipo $ "SF2|SC5"
	// If cTipo == "SF2"
		If cTipo == "SF2"
			_cType		:= QRYSF2->F2_TIPO
			_cCustomer	:= QRYSF2->F2_CLIENTE
			_cBranch	:= QRYSF2->F2_LOJA
		ElseIf cTipo == "SC5"
			_cType		:= QRYSC5->C5_TIPO
			_cCustomer	:= QRYSC5->C5_CLIENTE
			_cBranch	:= QRYSC5->C5_LOJACLI
		Endif
		
		If !_cType $ "B/D"
		
			DbSelectArea("SA1")
			aArea := GetArea()
			DbSetOrder(1)
			If MsSeek(xFilial("SA1") + _cCustomer + _cBranch)
			
				Private aCliente:= {}
				Private cPriCom:= Substr(DTOS(SA1->A1_PRICOM),5,2)+"/"+Substr(DTOS(SA1->A1_PRICOM),1,4)
				aAdd(aCliente, SA1->A1_NOME) 		// 1 Nome
				aAdd(aCliente, SA1->A1_ATIVIDA) 	// 2 Atividade
				aAdd(aCliente, "")		            // 3 Atividade "real"
				aAdd(aCliente, cPriCom)				// 4 Data do primeiro faturamento
				aAdd(aCliente, SA1->A1_EST)	        // 5 Estado
				aAdd(aCliente, "" )	    			// 6 Frete base ICM
				aAdd(aCliente, SA1->A1_GRPVEN)	    // 7 Frete base ICM
				aAdd(aCliente, "" )                 // 8 filial plimix
				aAdd(aCliente, SA1->A1_MUN)	        // 9 municipio
			Endif
			RestArea(aArea)
		Else
			dbSelectArea("SA2")
			aArea := GetArea()
			dbSetOrder(1)
			If MsSeek(xFilial("SA2") + _cCustomer + _cBranch)
				Private aCliente:= {}
				Private cPriCom:= ""//Substr(DTOS(SA1->A1_PRICOM),5,2)+"/"+Substr(DTOS(SA1->A1_PRICOM),1,4)
				aAdd(aCliente, SA2->A2_NOME) 		// 1 Nome
				aAdd(aCliente, "")                	// 2 Atividade
				aAdd(aCliente, "")		            // 3 Atividade "real"
				aAdd(aCliente, "")					// 4 Data do primeiro faturamento
				aAdd(aCliente, SA2->A2_EST)	        // 5 Estado
				aAdd(aCliente, "" )	    			// 6 Frete base ICM
				aAdd(aCliente, "" )           	    // 7 Frete base ICM
				aAdd(aCliente, "" )                 // 8 filial plimix
				aAdd(aCliente, SA2->A2_MUN)	        // 9 municipio
			Endif
			RestArea(aArea)
		Endif
	Else
		DbSelectArea("SA1")
		aArea := GetArea()
		DbSetOrder(1)
		If MsSeek(xFilial("SA1") + ZZ->D1_FORNECE + ZZ->D1_LOJA)
			Private aCliente:= {}
			Private cPriCom:= Substr(DTOS(SA1->A1_PRICOM),5,2)+"/"+Substr(DTOS(SA1->A1_PRICOM),1,4)
			aAdd(aCliente, SA1->A1_NOME) 		// 1 Nome
			aAdd(aCliente, SA1->A1_ATIVIDA) 	// 2 Atividade
			aAdd(aCliente, "")		            // 3 Atividade "real"
			aAdd(aCliente, cPriCom)				// 4 Data do primeiro faturamento
			aAdd(aCliente, SA1->A1_EST)	        // 5 Estado
			aAdd(aCliente, "" )	    			// 6 Frete base ICM
			aAdd(aCliente, SA1->A1_GRPVEN)	    // 7 Frete base ICM
			aAdd(aCliente, "" )                 // 8 filial plimix
			aAdd(aCliente, SA1->A1_MUN)	        // 9 municipio
		Endif
		RestArea(aArea)
	EndIf

Return aCliente


Static Function fPesqSB1()

DbSelectArea("SB1")
aArea := GetArea()
DbSetOrder(1)
MsSeek(xFilial('SB1') + aNota[1])
Private aProduto:= {}

aAdd(aProduto, .T.)  							   // 1 Produto Acabado?
aAdd(aProduto, SB1->B1_TIPO)					   // 2 Tipo de produto
aAdd(aProduto, SB1->B1_PRV1)					   // 3 Preco de venda
aAdd(aProduto, alltrim(SB1->B1_TIPCAR)) 					   // 4 Tipo de carga
aAdd(aProduto, 0)						//5 Preco gerencial

dbSelectArea("SB1")
aAdd(aProduto, SB1->B1_UM)						//6 1a Unidade de Medida
aAdd(aProduto, SB1->B1_CONV)					//7 Fator de Conversao
aAdd(aProduto, LEFT(SB1->B1_DESC,20))			//8 Descricao
aAdd(aProduto, LEFT("",20))						//9 Descricao Resumida
aAdd(aProduto, Posicione('SBM',1,xFilial('SBM')+SB1->B1_GRUPO,'BM_DESC')  )        // 10 Descricao do Grupo
aAdd(aProduto, "")							// 11 Descricao do SubGrupo
aAdd(aProduto, Alltrim(SB1->B1_TIPO))   	// 12 TIPO DA NF
aAdd(aProduto, Alltrim(SB1->B1_TIPCONV))    // 13 TIPO DE CONVERSAO M / D

RestArea(aArea)
Return aProduto


STATIC Function fPesqDB0()

DbSelectArea("DB0")
aArea := GetArea()
DbSetOrder(1)
MsSeek(xFilial('DB0') + cTipCar)
cResposta:= DB0->DB0_DESMOD
RestArea(aArea)

Return cResposta


Static Function fPesqSE1(cChave)

DbSelectArea("SE1")
aArea := GetArea()
DbSetOrder(2)
MsSeek(cChave)
Private aCReceb:= {}

aAdd(aCReceb, SE1->E1_VENCREA)	// 1 Vencimento
aAdd(aCReceb, SE1->E1_FATURA)	// 2-Numero da Fatura
aAdd(aCReceb, SE1->E1_DTFATUR)	// 3-Data da Fatura

RestArea(aArea)

Return aCReceb


Static Function fPesqSC6()

Private aPedido:= {}

aAdd(aPedido, '' )
aAdd(aPedido, 0  )
aAdd(aPedido, 0  )
aAdd(aPedido, "" )
aAdd(aPedido, "" )
aAdd(aPedido, ":")
aAdd(aPedido, ":")     	// 7  Hora saida
aAdd(aPedido, 0  )		// 8  Peso Real
aAdd(aPedido, "" )			// 9  Tipo carregamento
aAdd(aPedido, 0  )    	// 10 Quantidade
aAdd(aPedido, 0  )    	// 11 Peso de saida
aAdd(aPedido, ctod("//"))    	// 12 Data da Liberacao
aAdd(aPedido, '' )    	// 13 modalidade de frete
aAdd(aPedido, '' )    	// 14 tipo de frete
aAdd(aPedido, 0  )    	// 15 frete real

DbSelectArea("SC6")
aArea := GetArea()
DbSetOrder(1)
	If MsSeek(QRYSF2->F2_FILIAL + QRYSF2->D2_PEDIDO + QRYSF2->D2_ITEMPV)
	aPedido:={}
	
	aAdd(aPedido, SC6->C6_PRODUTO)		// 1  Codigo produto
	
	//aAdd(aPedido, SC6->C6_PCOREF)		// 2  Valor da nota
	aAdd(aPedido, 0)		// 2  Valor da nota
	
	aAdd(aPedido, SC6->C6_QTDVEN)		// 3  Quantidade entregue
	
	//aAdd(aPedido, SC6->C6_PLACA)		// 4  Placa do veiculo motor
	aAdd(aPedido, "" )		// 4  Placa do veiculo motor
	
	aAdd(aPedido, SC6->C6_TES)       	// 5  TES
	
	//aAdd(aPedido, SC6->C6_HORENT)     	// 6  Hora entrada
	aAdd(aPedido, ":")     	// 6  Hora entrada
	
	//aAdd(aPedido, SC6->C6_HORSAI)     	// 7  Hora saida
	aAdd(aPedido, ":")     	// 7  Hora saida
	
	//aAdd(aPedido, SC6->C6_PSENT)		// 8  Peso Real
	aAdd(aPedido, 0)		// 8  Peso Real
	
	//aAdd(aPedido, SC6->C6_YPM)			// 9  Tipo carregamento
	aAdd(aPedido, "")			// 9  Tipo carregamento
	
	aAdd(aPedido, SC6->C6_Qtdven)    	// 10 Quantidade
	
	//aAdd(aPedido, SC6->C6_PSSAI)    	// 11 Peso de saida
	aAdd(aPedido, 0)    	// 11 Peso de saida
	
	//aAdd(aPedido, SC6->C6_YDTLIB)    	// 12 Data da Liberacao
	aAdd(aPedido, ctod("//"))    	// 12 Data da Liberacao
	
	
	cTpFrete := ''
	cModFrete := ''
		If QRYSF2->F2_TPFRETE=="C"
		cModFrete := "CIF"
		ElseIf QRYSF2->F2_TPFRETE=="F"
		cModFrete := "FOB"
		ElseIf QRYSF2->F2_TPFRETE=="T"
		cModFrete := "TER"
		ElseIf QRYSF2->F2_TPFRETE=="S"
		//cModFrete := "SEM"
		cModFrete := "CIF"
		endif
	
	ctpFrete:= QRYSF2->F2_TPFRETE
	
	sc5->(MsSeek(QRYSF2->F2_FILIAL + QRYSF2->D2_PEDIDO))
		If Empty(cModFrete)
			If SC5->C5_TPFRETE=="C"
			cModFrete := "CIF"
			ElseIf SC5->C5_TPFRETE=="F"
			cModFrete := "FOB"
			ElseIf SC5->C5_TPFRETE=="T"
			cModFrete := "TER"
			ElseIf SC5->C5_TPFRETE=="S"
			//cModFrete := "SEM"
			cModFrete := "CIF"
			EndIf
		EndIf
	
		If Empty(cTpFrete)
		ctpFrete:= SC5->C5_TPFRETE
		endif
	
	aAdd(aPedido, cModFrete )    	// 13 modalidade do frete
	aAdd(aPedido, ctpFrete )    	// 14 Data da Liberacao
	aAdd(aPedido, ""       )    	// 15 frete real - cif que nao sai na nota fiscal
	
	Endif
RestArea(aArea)
Return aPedido

Static Function fPesqSD2()

Private aNota    := {}
_lGerenc := .T.

aAdd(aNota, QRYSF2->D2_COD)		    	// 1 Codigo produto
aAdd(aNota, QRYSF2->D2_PRCVEN)			// 2 Preco unitario
aAdd(aNota, QRYSF2->D2_QUANT)			// 3 Quantidade na nota
aAdd(aNota, "")					    	// 4 Placa
aAdd(aNota, QRYSF2->D2_TES)		    	// 5 TES
aAdd(aNota, QRYSF2->D2_PICM)			// 6 Aliquota ICMS
aAdd(aNota, 0)	                	    // 7 Custo de transferencia (unitario)

	If QRYSF2->D2_YPRG > 0
		If cEmpant == "02" .And. cFilAnt == "11" .And. QRYSF2->F2_EMISSAO < CTOD("01/08/2017")
		_nPrc := QRYSF2->D2_YPRG / SuperGetMV("BRI_FATCON")
		aAdd(aNota, _nPrc)			    	// 8 Preco Gerencial
		Else
		aAdd(aNota, QRYSF2->D2_YPRG)    	// 8 Preco Gerencial
		Endif
	Else
	_lGerenc := .F.
	aAdd(aNota, QRYSF2->D2_PRCVEN)      	// 8 Preco Gerencial -->ALTERADO EM 14/02/17
	Endif

aAdd(aNota, 0)						// 9 Custo (R$/T)
aAdd(aNota, 0)						// 10 Custo Sacaria
aAdd(aNota, QRYSF2->D2_VALIMP6)	    // 11 PIS
aAdd(aNota, QRYSF2->D2_VALIMP5)	    // 12 COFINS
aAdd(aNota, QRYSF2->D2_CF)			// 13 CFOP
aAdd(aNota, QRYSF2->D2_UM)			// 14 UM
aAdd(aNota, QRYSF2->D2_GRUPO)		// 15 UM
aAdd(aNota, QRYSF2->D2_VALFRE)		// 16 VALOR DO FRETE - RATEADO PELA QUANTIDADE
aAdd(aNota, QRYSF2->D2_VALISS)		// 17 VALOR DO ISS

Return aNota


Static Function fPesqSE4()

Private nResposta:= ""

DbSelectArea("SE4")
aArea := GetArea()
DbSetOrder(1)
MsSeek(xFilial("SE4") + QRYSF2->F2_COND)
	If SE4->(FieldPos("E4_YMEDIA")) > 0
	Private nResposta:= SE4->E4_YMEDIA
	Endif

RestArea(aArea)

Return nResposta

Static Function fPesqSF4()

DbSelectArea("SF4")
aArea := GetArea()
DbSetOrder(1)
MsSeek(xFilial('SF4') + aNota[5])

cResposta:= "" //SF4->F4_YINFEX
Private cResposta2:= SF4->F4_TEXTO

RestArea(aArea)

Return ({cResposta,cResposta2})

Static  Function fPesqZZA(cChave)

//DbSelectArea("ZZA")
aArea := GetArea()

//DbSetOrder(1)
//MsSeek(cChave)
Private cResposta:= ""//ZZA->ZZA_CONTEU
RestArea(aArea)

Return cResposta

Static  Function fPesqSX5()

DbSelectArea("SX5")
aArea := GetArea()
DbSetOrder(1)
MsSeek(xFilial('SX5') + "YI"+ iif(!Empty(aCliente[3]),aCliente[3],aCliente[2]))
Private cResposta:= SX5->X5_DESCRI
RestArea(aArea)
Return cResposta


Static  Function fPesqSZ8()

aArea := GetArea()
Private aOrdem:= {}
Private cTempo:= "  :  "
cTempo:= "00:00"

aAdd(aOrdem, cTempo) 			// 1 Tempo decorrido entre a hora do peso e a hora da saida do caminhao
aAdd(aOrdem, 0)		// 2 Peso de saida do caminhao
aAdd(aOrdem, 0)
aAdd(aOrdem, ctod(""))
aAdd(aOrdem, ctod(""))
aAdd(aOrdem, "")
aAdd(aOrdem, "00:00")
aAdd(aOrdem, "00:00")
aAdd(aOrdem, ctod("//"))
aAdd(aOrdem, "00:00")

RestArea(aArea)

Return aOrdem


Static  Function fPesqSZO()

aArea := GetArea()
Private cResposta:= "" //SZO->ZO_DESC

RestArea(aArea)

Return cResposta


Static  Function fPesqSZ4()

aArea := GetArea()
Private cResposta:= "" //SZ4->Z4_REGIAO

RestArea(aArea)

Return cResposta



Static Function SetHora(_nValor,_cHex)

Local _cHora		:= ""
Local _cMinutos		:= ""
Local _cSepar		:= ":"

	If ValType( _cHex ) == 'U'
	_cHex := "N"
	Endif

_cHora := StrZero(_nValor,5,2)

_cMinutos := SubStr(_cHora, At('.', _cHora)+1, 2)
	If _cHex = 'N'
	_cMinutos := StrZero((Val(_cMinutos)*60)/100, 2)
	Endif

_cHora := SubStr(_cHora, 1, At('.', _cHora))+_cMinutos
_cHora := StrTran(_cHora, '.', _cSepar)

Return(_cHora)





Static Function GERAMOVE()

SA1->(dbSetOrder(1))
SA1->(MsSeek(xFilial("SA1")+ ZZ->D1_FORNECE + ZZ->D1_LOJA))

SB1->(MsSeek(xFilial("SB1")+ ZZ->D1_COD))

_lMargem := .F.
	If !Empty(SB1->B1_GRUPO)
	SBM->(dbSetOrder(1))
		If SBM->(MsSeek(xFilial("SBM")+SB1->B1_GRUPO))
			If SBM->BM_TIPGRU == "11"
			_lMargem := .T.
			Endif
		Endif
	Endif

SF1->(dbSetOrder(1))
SF1->(MsSeek(ZZ->D1_FILIAL + ZZ->D1_DOC + ZZ->D1_SERIE + ZZ->D1_FORNECE + ZZ->D1_LOJA + ZZ->D1_TIPO))

Private nPrecoUn	 := 0
Private nTotNF		 := 0
Private nTotNFG		 := 0
Private nIpiG		 := 0
Private nFrbUn		 := 0
Private nIcmsG		 := 0
Private nPisco		 := 0
Private nPiscoG		 := 0
Private nFrtUni		 := 0
Private nFrtTot		 := 0
Private nPoG		 := 0
Private nPo 		 := 0
Private wOrdSZ1		 := 0
Private wRecSZ1		 := 0
Private cTempo		 := "  :  "
Private aCliente	 := fPesqSA1(cTipo)
Private naliqext     := 0
Private _esticm	     := alltrim(getmv("MV_ESTICM"))
Private _estado      := GetMV("MV_ESTADO")
Private _picmest     := Val(Subs(_esticm,at(_estado,_esticm)+2,2))
Private naliqext     := 0
Private ndifaliq     := 0
Private wPIRCSL      := 0
Private nBaseIcmsG   := 0
Private _lGerenc     := .T.
Private aNota		 := fPesqSD1()
Private nCusTran	 := aNota[7]
Private nCustSac	 := aNota[10]
Private aProduto	 := fPesqSB1()
Private nQtdTB		 := aNota[3]
Private cTipCar		 := aProduto[4]

nQtdeGra		     := aNota[3]

Private cPrefixo	 := "FAT"
Private cGrupo		 := aNota[15]
Private cTes		 := aNota[5]
Private wTES		 := ""
Private nICMSRetG	 := 0
Private nProdG		 := 0
Private	cPrefixo     := ZZ->D1_SERIE
Private nAliqICM	 := aNota[6]
Private nFRE3Tot	 := 0 // Frete NF + Custo Transporte Total
Private nFRE3Un		 := 0 // Frete NF + Custo Transporte Unitário
Private	nPisNF       := 0 // PIS na NFS
Private nCOFNF       := 0 // COFINS na NFS
Private nPISGER      := 0 // PIS gerencial
Private nCOFGER      := 0 // COFINS gerencial
Private cDESTES		 := fPesqSF4() // Descrição da TES

nTotNF	 := (ZZ->D1_TOTAL + ZZ->D1_VALFRE) * -1
nTotNFG	 := (ZZ->D1_TOTAL + ZZ->D1_VALFRE) * -1
nPrecoUn := Round(nTotNF / nQtdeGra,2)

	If _lGerenc
	nTotNFG := (aNota[8] * nQtdTB) * -1		    // Preco gerencial * quantidade em tons
	EndIf

naliqext := 12
nD2Aliq  := 1+ ( ( _picmest - naliqext ) / 100 )

	If ZZ->D1_ICMSRET > 0 .And. _lGerenc
	
	nProdG := ROUND(      ((nTotnfg  /  nDifAliq )    -   (ZZ->D1_VALFRE * 1.04) ) / 1.04 , 2 )
	
	nIcmsRetG :=  ( ( nProdG + ZZ->D1_FRETE )  * 1.04) * ( ndifaliq  - 1 )
	
	Else // produto gerencial sem ICMS RETIDO
	nProdG := ROUND(  (nTotNFG  /  1.04 ) -  ZZ->D1_VALFRE,2 )
	EndIf

	if ZZ->D1_VALIPI = 0
	nIpiG:= 0
	Else
	nIpiG	:= Round((((nTotNFG - ZZ->D1_VALFRE*1.04)-nICMSRETG)/1.04+ZZ->D1_VALFRE)*0.04,2)
	EndIf

nFrbUn	:= ZZ->D1_VALFRE / nQtdTB

	If ZZ->D1_ICMSRET > 0 .And. _lGerenc
	naliqext := 12
	nProduto := nTotNFG - ( 1.05 * ZZ->D1_VALFRE ) - ( 1.05 * nIpiG )
	
	nProduto  := Round(nProduto / 1.05,2)
	ndifaliq  := ( _picmest - naliqext ) / 100
	nIcmsRetG := ( nProduto + ZZ->D1_VALFRE + nIpiG ) * ndifaliq
	EndIf

	If cEmpAnt + cFilAnt $ "0209/5010"
	nBaseIcmsG := 0
	nIcmsG	   := 0
	nICMSRetG  := 0
	Else
		If !_lGerenc
		nIcmsG	  := ZZ->D1_VALICM * -1
		nICMSRetG := ZZ->D1_ICMSRET  * -1
		nIPIG     := ZZ->D1_VALIPI   * -1
		Else
		_nAliq := aNota[6]
			If Empty(aNota[6])
			_nAliq := GETMV("MV_ICMPAD")
			Endif
		
		nBaseIcmsG := nTotNFG
		nIcmsG	   := (Round(nBaseIcmsG  * (_nAliq / 100) ,2) ) * -1
		EndIf
	Endif

nPisco	:= 0
nPiscoG	:= 0

nPisco  := (aNota[11] + aNota[12] ) * -1
nPisNF  := aNota[11] * -1
nCOFNF  := aNota[12] * -1
_nISSNF := aNota[17] * -1

_nTxPIS	:= SuperGetMV("MV_TXPIS")
_nTxCOF	:= SuperGetMV("MV_TXCOFIN")
_nPerc  := (_nTxPIS + _nTxCOF ) / 100
_nTxISS := SB1->B1_ALIQISS / 100

nPiscoG	:= Round(nTotNFG  * _nPerc,2)

	If !_lGerenc
	nPiscoG  := nPisco
	nPISGER  := nPisNF
	nCOFGER  := nCOFNF
	
		If cEmpAnt == "04"
		_nISSGER := _nISSNF
		Endif
	Else
	nPISGER := Round(nTotNFG * (_nTxPIS / 100) ,2)
	nCOFGER := Round(nTotNFG * (_nTxCOF / 100) ,2)
	
		If cEmpAnt == "04"
		_nISSGER := Round(nTotNFG * _nTxISS,2)
		Endif
	
	EndIf

nFrtUni  := nFrbUn
nFrtUni  := nFrtUni * - 1
nFrtTot	 := ZZ->D1_VALFRE * - 1

	If cEmpAnt + cFilAnt $ "5001/5002/5004/5005/5006/5007/5008/5013/5016" .AND. SA1->A1_YTPCLI = "2"
	
	SZ2->(dbSetOrder(4))
		If SZ2->(dbSeek(ZZ->D1_FILIAL + ZZ->D1_FORNECE + ZZ->D1_LOJA + ZZ->D1_COD))
		nFrtTot	 := Round((ZZ->D1_QUANT * SZ2->Z2_FRETGER ),2) * -1
		nFrtUni  := SZ2->Z2_FRETGER * -1
		Endif
	ENDIF

nFRE3Tot := 0
nMARGEG  := Round((nTotNFG - nIpiG - nIcmsG - nIcmsRetG - nPiscoG - ZZ->D1_VALFRE - 0) / nQtdeGra,2)   -  aNota[9]	   // Margem de Lucro
nIRCSLG  := IF(nMARGEG > 0 ,(nQtdeGra * nMARGEG * wPIRCSL),0)
wwTotNFG := 0
wwTotNFG := nTotNFG

DbSelectArea("ZZD")
DbSetOrder(10)

SF4->(dbSetOrder(1))
SF4->(MsSeek(xFilial("SF4") + ZZ->D1_TES))

SE4->(dbSetOrder(1))
SE4->(MsSeek(xFilial("SE4") + SF1->F1_COND))   // CONTINUAR

aZZD	:= GetArea("ZZD")

_nCusto := 0
Z05->(dbSetOrder(1))
	If Z05->(MsSeek(xFilial("Z05") + cEmpAnt + cFilAnt + DTOS(FIRSTDAY(ZZ->D1_DTDIGIT))))
	_nCusto := Z05->Z05_CUSTO
	Endif

	If MsSeek(xFilial("ZZD")+cEmpAnt+cFilAnt+ZZ->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM))
	RecLock("ZZD",.F.)
	Else
	RecLock("ZZD",.T.)
	EndIf

	If Empty(xFilial("ZZD"))
	ZZD->ZZD_FILIAL	:= xFilial("ZZD")
	Else
	ZZD->ZZD_FILIAL	:= ZZ->D1_FILIAL
	Endif

_aSA1Box := RetSx3Box( Posicione("SX3", 2, "A1_YTPCLI", "X3CBox()" ),,, 1 )
nAscan   := Ascan( _aSA1Box, { |e| e[2] = SA1->A1_YTPCLI } )

	If nAscan > 0
		If ZZD->(FieldPos("ZZD_TPCLI")) > 0
		ZZD->ZZD_TPCLI := AllTrim( _aSA1Box[nAscan][3] )
		Endif
	Endif

_aSF4Box := RetSx3Box( Posicione("SX3", 2, "F4_YTPVEND", "X3CBox()" ),,, 1 )
nAscan   := Ascan( _aSF4Box, { |e| e[2] = SF4->F4_YTPVEND } )

	If nAscan > 0
		If ZZD->(FieldPos("ZZD_TPVEND")) > 0
		ZZD->ZZD_TPVEND  := AllTrim( _aSF4Box[nAscan][3] )
		Endif
	Endif

ZZD->ZZD_EMIS		:= ZZ->D1_EMISSAO
ZZD->ZZD_ANOMES	    := Left(DtoS(ZZ->D1_EMISSAO),6)	 //Ano Mes
ZZD->ZZD_HRSAID	    := SF1->F1_HORA             // HORA DE SAIDA DA NF
ZZD->ZZD_PROD		:= aNota[1]					// Cod. produto
ZZD->ZZD_DESCPR	    := aProduto[8]				// Descricao do Produto
ZZD->ZZD_DESCRE	    := aProduto[9]				// Descricao Resumida do Produto
ZZD->ZZD_DESGR 	    := aProduto[10]				// Descricao do Produto
ZZD->ZZD_DESSGR	    := aProduto[11]				// Descricao Resumida do Produto
ZZD->ZZD_CLIE		:= ZZ->D1_FORNECE			// Cod. cliente
ZZD->ZZD_LOJA		:= ZZ->D1_LOJA				// Loja
ZZD->ZZD_NOME		:= aCliente[1]				// Nome cliente
ZZD->ZZD_SERIE		:= ZZ->D1_SERIE		   	    // Serie documento
ZZD->ZZD_DOC		:= ZZ->D1_DOC				// Num. documento
ZZD->ZZD_ITEM       := ZZ->D1_ITEM
ZZD->ZZD_QTBRUT     := aNota[3] * -1
ZZD->ZZD_QTLIQ		:= aNota[3] * -1
ZZD->ZZD_PRECO		:= nPrecoUn					// Buscar no SD2
ZZD->ZZD_PRECOG	    := (nTotNFG / aNota[3] )
ZZD->ZZD_TOTNF	    := nTotNF     		// Valor total da NF
ZZD->ZZD_IPI	    := ZZ->D1_VALIPI	    		// IPI
ZZD->ZZD_TOTLIQ     := (ZZD->ZZD_TOTNF - ZZD->ZZD_IPI)
ZZD->ZZD_ICMS	    := IF (ZZ->D1_VALISS > 0, 0, ZZ->D1_VALICM	* -1)
ZZD->ZZD_ALQICM     := (ZZD->ZZD_ICMS / ZZD->ZZD_TOTNF ) * 100
ZZD->ZZD_PRCLIQ     := ZZD->ZZD_TOTLIQ / ZZD->ZZD_QTLIQ

	If _lGerenc
	ZZD->ZZD_TOTLIG   := nTotNFG
	ZZD->ZZD_IPIG	  := ZZD->ZZD_TOTLIG * (ZZ->D1_IPI /100)	   // IPI Gerencial
	ZZD->ZZD_TOTNFG	  := nTotNFG
	ZZD->ZZD_ICMSG	  := nIcmsG
	ZZD->ZZD_PISGER   := nPISGER
	ZZD->ZZD_COFGER   := nCOFGER
	ZZD->ZZD_RETG	  := nICMSRetg
	ZZD->ZZD_PISCOG	  := nPiscoG					// Pis/Cofins (gerencial)
	ZZD->ZZD_DEICDC   := ((ZZD->ZZD_IPIG - ZZD->ZZD_IPI + ZZD->ZZD_ICMSG - ZZD->ZZD_ICMS)/2)
	Else
	ZZD->ZZD_TOTLIG   := nTotNFG
	ZZD->ZZD_IPIG	  := ZZD->ZZD_TOTLIG * (ZZ->D1_IPI /100)	   // IPI Gerencial
	ZZD->ZZD_TOTNFG	  := ZZD->ZZD_TOTLIG + 	ZZD->ZZD_IPIG
	ZZD->ZZD_ICMSG	  := IF (ZZ->D1_VALISS > 0, 0, ZZ->D1_VALICM * -1)	// ICMS
	ZZD->ZZD_PISGER   := aNota[11] * -1
	ZZD->ZZD_COFGER   := aNota[12] * -1
	ZZD->ZZD_RETG	  := nICMSRetg
	ZZD->ZZD_PISCOG	  := nPisco					// Pis/Cofins (gerencial
	Endif

	If cEmpAnt + ZZ->D1_FILIAL $  "5001/5002/5005/5006/5007" .And. SA1->A1_YTPCLI == "2"
	ZZD->ZZD_ICMSG  := 0
	ZZD->ZZD_PISGER := 0
	ZZD->ZZD_COFGER := 0
	Endif

ZZD->ZZD_RET		:= ZZ->D1_ICMSRET * -1 		// ICMS Retido
ZZD->ZZD_PISCO		:= nPisco	     			// Pis/Cofins
ZZD->ZZD_PIS		:= aNota[11] * -1			//SF2->F2_VALIMP6
ZZD->ZZD_COFINS	    := aNota[12] * -1			//SF2->F2_VALIMP5
ZZD->ZZD_FRETOT	    := nFrtTot	     			// Frete total
ZZD->ZZD_FREUNI	    := nFrtUni					// Frete liquido unitario (gerencial)
ZZD->ZZD_MUNEND	    := acliente[9]
ZZD->ZZD_UF			:= acliente[5]				// Estado destino
ZZD->ZZD_COND		:= SF1->F1_COND				// Condicao de pagamento

	If SE4->(FieldPos("E4_YMEDIA")) > 0
	ZZD->ZZD_PM			:= SE4->E4_YMEDIA			// Prazo medio
	Endif
ZZD->ZZD_ATIVI		:= aCliente[2]				// Atividade do cliente
ZZD->ZZD_ATIVG		:= aCliente[3]				// Atividade 'real' do cliente
ZZD->ZZD_FRBR		:= ZZ->D1_VALFRE * -1       // Frete bruto
ZZD->ZZD_FRBRUN	    := nFrbUn					// Frete bruto unitario (Gerencial)
ZZD->ZZD_KM			:= 0						// Distancia da Matriz ao cliente em Km
ZZD->ZZD_KMR		:= 0						// Raio em Km -- ??
ZZD->ZZD_CARRO		:= ""
ZZD->ZZD_MOTOR      := ""
ZZD->ZZD_PREF		:= ZZ->D1_SERIE				// Prefixo padrao do parametro conforme a filial atual
ZZD->ZZD_YTPCAR	    := cTipCar					// Tipo de Carga
ZZD->ZZD_YDEV		:= ""
ZZD->ZZD_YNFSUB	    := ""
ZZD->ZZD_TES		:= aNota[5]					// TES em SD2
ZZD->ZZD_UM		    := aNota[14]				// UM
ZZD->ZZD_GRUPO		:= cGrupo					// Grupo

	If _lGerenc
	ZZD->ZZD_DEVCDC	:= nTotNFG - ZZD->ZZD_TOTLIQ
	Else
	ZZD->ZZD_DEVCDC	:= 0
	Endif
ZZD->ZZD_CPO21		:= If(Empty(cTes),'N/CADASTRADO',cTes)	// Tes
ZZD->ZZD_CPO22		:= aCliente[4]				            // Data primeiro faturamento
ZZD->ZZD_TPROD      := ZZ->D1_TOTAL  * -1
ZZD->ZZD_TPRODG     := nProdG

	If aProduto[6]$("BB/TB/UN")
	ZZD->ZZD_YPESTB	:= aProduto[7]
	EndIf

ZZD->ZZD_CODEMP	:= cEmpAnt
ZZD->ZZD_CODFIL	:= ZZ->D1_FILIAL
ZZD->ZZD_NOMFIL := POSICIONE("SM0",1,cEmpAnt + ZZ->D1_FILIAL,"M0_FILIAL")

_cSigl := ""
	If ZZD->(FieldPos("ZZD_SIGLA2")) > 0
		If cEmpAnt == "02"
			If ZZ->D1_FILIAL == "01"
			_cSigl := "PX-IBA"
			ElseIf ZZ->D1_FILIAL == "02"
			_cSigl := "PX-IDC"
			ElseIf ZZ->D1_FILIAL $ "03/04"
			_cSigl := "  "
			ElseIf ZZ->D1_FILIAL == "05"
			_cSigl := "PX-IJB"
			ElseIf ZZ->D1_FILIAL == "06"
			_cSigl := "PX-IFT"
			ElseIf ZZ->D1_FILIAL == "07"
			_cSigl := "PX-IMC"
			ElseIf ZZ->D1_FILIAL == "08"
			_cSigl := "PX-INT"
			ElseIf ZZ->D1_FILIAL == "09"
			_cSigl := "PX-ISV"
			ElseIf ZZ->D1_FILIAL == "10"
			_cSigl := "PX-IBA"
			ElseIf ZZ->D1_FILIAL == "11"
			_cSigl := "PX-IPT"
			ElseIf ZZ->D1_FILIAL == "12"
			_cSigl := "PX-IGU"
			ElseIf ZZ->D1_FILIAL == "13"
			_cSigl := "PX-ICC"
			ElseIf ZZ->D1_FILIAL == "14"
			_cSigl := "PX-ISL"
			Endif
		ElseIf cEmpAnt == "04"
			If ZZ->D1_FILIAL $ "01"
			_cSigl := "MSP"
			ElseIf ZZ->D1_FILIAL == "02"
			_cSigl := "MRE"
			Endif
		ElseIf cEmpAnt == "05"
		_cSigl := "MRE"
		ElseIf cEmpAnt == "09"
		_cSigl := "PX-IMC"
		ElseIf cEmpAnt == "13"
			If ZZ->D1_FILIAL     $ "01"
			_cSigl := "PX-IRO"
			ElseIf ZZ->D1_FILIAL $ "04"
			_cSigl := "PX-IBA"
			ElseIf ZZ->D1_FILIAL == "06"
			_cSigl := "PX-IRO"
			ElseIf ZZ->D1_FILIAL == "07"
			_cSigl := "PX-IBA"
			Endif
		ElseIf cEmpAnt == "16"
		_cSigl := "PX-IPT"
		ElseIf cEmpAnt == "50"
			If ZZ->D1_FILIAL == "01"
			_cSigl := "PX-IBA"
			ElseIf ZZ->D1_FILIAL == "02"
			_cSigl := "PX-IRO"
			ElseIf ZZ->D1_FILIAL == "03"
			_cSigl := "PX-IFT"
			ElseIf ZZ->D1_FILIAL == "04"
			_cSigl := "PX-INT"
			ElseIf ZZ->D1_FILIAL == "05"
			_cSigl := "PX-IDC"
			ElseIf ZZ->D1_FILIAL == "06"
			_cSigl := "PX-IGU"
			ElseIf ZZ->D1_FILIAL == "07"
			_cSigl := "PX-ICC"
			ElseIf ZZ->D1_FILIAL == "08"
			_cSigl := "PX-ISL"
			ElseIf ZZ->D1_FILIAL == "09"
			_cSigl := "PX-IJB"
			ElseIf ZZ->D1_FILIAL == "10"
			_cSigl := "PX-ISV"
			ElseIf ZZ->D1_FILIAL == "11"
			_cSigl := "PX-IRB"
			ElseIf ZZ->D1_FILIAL == "12"
			_cSigl := "PX-AE "
			ElseIf ZZ->D1_FILIAL == "13"
			_cSigl := "PX-IPT"
			ElseIf ZZ->D1_FILIAL == "14"
			_cSigl := "PX-MT"
			ElseIf ZZ->D1_FILIAL == "15"
			_cSigl := "PX-IMC"
			ElseIf ZZ->D1_FILIAL == "16"
			_cSigl := "PX-INH"
			Endif
		Endif
	
	ZZD->ZZD_SIGLA2 := _cSigl
	Endif

cSigla:= SuperGetMv( "BRI_SIGLA" , .F. , , ZZ->D1_FILIAL )

ZZD->ZZD_SIGLA  := cSigla

//nCalcPoG:= (ZZD->ZZD_TOTNFG - ZZD->ZZD_IPIG - ZZD->ZZD_ICMSG - ZZD->ZZD_RETG - ZZD->ZZD_PISGER - ZZD->ZZD_COFGER - nFrtTot  ) / nQtdeGra
//nCalcPoG:= iif( nCalcPoG <0 , 0 , nCalcPoG )


	If ZZ->D1_TIPO $ "C/I"
	_nFOBL := 0
	_nCIFL := 0
	_ 
	ElseIf SA1->A1_YTPCLI == "2"
	_nFOBL := (ZZD->ZZD_TOTNFG - ZZD->ZZD_ICMSG - ZZD->ZZD_PISGER - ZZD->ZZD_COFGER ) / ZZD->ZZD_QTLIQ
	_nCIFL := (ZZD->ZZD_TOTNFG + ZZD->ZZD_FRETOT                                    ) / ZZD->ZZD_QTLIQ
	Else
	_nFOBL := (ZZD->ZZD_TOTNFG - ZZD->ZZD_ICMSG - ZZD->ZZD_PISGER - ZZD->ZZD_COFGER - ZZD->ZZD_FRETOT ) / ZZD->ZZD_QTLIQ
	_nCIFL := ZZD->ZZD_TOTNFG + ZZD->ZZD_FRETOT
	Endif

nCalcPoG:= iif( nCalcPoG <0 , 0 , nCalcPoG )

nPoG            := nCalcPoG
ZZD->ZZD_PO		:= If (_nFOBL < 0,0, _nFOBL)
ZZD->ZZD_FOBL	:= (_nFOBL * -1)
ZZD->ZZD_CIFL   := (_nCIFL * -1)

ZZD->ZZD_MASSAG	:= ( ZZD->ZZD_TOTNF - ZZD->ZZD_IPI - ZZD->ZZD_ICMS - ZZD->ZZD_RET - ZZD->ZZD_PIS - ZZD->ZZD_COFINS - nFrtTot)    // MASSA R$ - Solicitado pelo Sr. Josi

nPo	            := nPoG
ZZD->ZZD_MASSA  := ( ZZD->ZZD_TOTNF - ZZD->ZZD_IPI - ZZD->ZZD_ICMS - ZZD->ZZD_RET - ZZD->ZZD_PIS - ZZD->ZZD_COFINS - nFrtTot)
ZZD->ZZD_CUSTO	:= _nCusto // aNota[9] // D2_YCUSTO

//If _lMargem        
//	If ZZD->ZZD_CODEMP + ZZD->ZZD_CODFIL $ "5001/5002/5004/5005/5006/5007/5008/5013/5016" .And. SA1->A1_YTPCLI = "2"
//		ZZD->ZZD_MARGEM	:= 0
//		ZZD->ZZD_MARGEG	:= 0
//    Else
//		ZZD->ZZD_MARGEM	:= ZZD->ZZD_PO - _nCusto	   // Margem de Lucro
//		ZZD->ZZD_MARGEG	:= ZZD->ZZD_PO - _nCusto	   // Margem de Lucro
//	Endif
//Endif

	If _lMargem
	ZZD->ZZD_MARGEM	:= ZZD->ZZD_FOBL + _nCusto	   // Margem de Lucro
	ZZD->ZZD_MARGEG	:= ZZD->ZZD_FOBL + _nCusto	   // Margem de Lucro
	Endif

nPO := Round((nTotNFG - nIpiG - nIcmsG - nIcmsRetG - nPiscoG - nFrtTot - 0) / nQtdeGra,2)
nPO -= If(cTipCar = "S",nCustSac,0)
ZZD->ZZD_YPEDAG := 0
ZZD->ZZD_YCTR  	:= ""
ZZD->ZZD_YSERCT := ""
ZZD->ZZD_IRCSL  := IF(ZZD->ZZD_MARGEM > 0 ,(nQtdeGra * ZZD->ZZD_MARGEM * wPIRCSL),0)
ZZD->ZZD_IRCSLG := IF(ZZD->ZZD_MARGEG > 0 ,(nQtdeGra * ZZD->ZZD_MARGEG * wPIRCSL),0)
aZZD			:= GetArea("ZZD")

	If Alltrim(cTipCar) $ "CDC*G"
	ZZD->ZZD_PERFIL := "GRANEL"
	ELSEIF cTipCar = "S"
	ZZD->ZZD_PERFIL := "TAMBOR"
	Endif

ZZD->ZZD_CFOP   := aNota[13]
ZZD->ZZD_TIPONF := ZZ->D1_TIPO
ZZD->ZZD_TIPOMT := aProduto[12]
ZZD->ZZD_DESTES := cDESTES[2]

	If ZZ->D1_VALFRE > 0
	ZZD->ZZD_QTCIF  := ZZD->ZZD_QTLIQ
	ZZD->ZZD_TPFRE	:= "C"
	Else
	ZZD->ZZD_TPFRE	:= "F"
	ZZD->ZZD_QTCIF  := 0
	Endif

ZZD->ZZD_QTCIF  := iif(  ZZD->ZZD_TPFRE=='C', ZZD->ZZD_QTLIQ , 0 )
ZZD->ZZD_MARTOT := (ZZD->ZZD_MARGEG * ZZD->ZZD_QTLIQ)+ ZZD->ZZD_DEICDC
ZZD->ZZD_FRE3U  := nFRE3Un
ZZD->ZZD_YMUN   := SA1->A1_MUN
ZZD->ZZD_YEST   := SA1->A1_EST

	If ZZD->(FieldPos("ZZD_NREDUZ")) > 0
	ZZD->ZZD_NREDUZ:= SA1->A1_NREDUZ
	Endif

	If ZZ->D1_TIPO <> 'D'
	ZZD->ZZD_GRPVEN  := SA1->A1_GRPVEN
	Endif

ZZD->ZZD_DESGRU  := POSICIONE("SBM",1,XFILIAL("SBM")+cGrupo,"BM_DESC")
zzd->zzd_itemct  := posicione('SB1',1,xfilial('SB1')+aNota[1],'B1_ITEMCC')

	do case
	case anota[14] $ 'BB/TB' //unidade de medida
		if aCliente[8] =='S' // a1_yfilpol - filial polimix
			zzd->zzd_itemct := '010104'
		else
			zzd->zzd_itemct := '010102'
		endif
	case anota[14] == 'KG'
		if aCliente[8] =='S'
			zzd->zzd_itemct := '010103'
		else
			zzd->zzd_itemct := '010101'
		endif
	endcase

ZZD->ZZD_DESITE:= posicione('CTD',1,xfilial('CTD')+zzd->zzd_itemct,'CTD_DESC01')

ZZD->ZZD_PISNF  := nPisNF
ZZD->ZZD_COFNF  := nCOFNF

DbSelectArea("ZZD")
MsUnlock()
RestArea(aZZD)

RestArea(_aAliSA1)
RestArea(_aAliSA2)
RestArea(_aAliSF4)
RestArea(_aAliOri)

Return



Static Function fPesqSD1()

Private aNota    := {}
_lGerenc := .T.

SD2->(dbSetOrder(1))
SD2->(MsSeek(ZZ->D1_FILIAL + ZZ->D1_NFORI + ZZ->D1_SERIORI + ZZ->D1_FORNECE + ZZ->D1_LOJA + ZZ->D1_COD ))

aAdd(aNota, ZZ->D1_COD)		    // 1 Codigo produto
aAdd(aNota, ZZ->D1_VUNIT)		// 2 Preco unitario
aAdd(aNota, ZZ->D1_QUANT)		// 3 Quantidade na nota
aAdd(aNota, "")					// 4 Placa
aAdd(aNota, SD2->D2_TES)		// 5 TES
aAdd(aNota, SD2->D2_PICM)		// 6 Aliquota ICMS
aAdd(aNota, 0)	                // 7 Custo de transferencia (unitario)

	If SD2->D2_YPRG > 0
		If cEmpant == "02" .And. cFilAnt == "11" .And. ZZ->D1_DTDIGIT < CTOD("01/08/2017")
		_nPrc := SD2->D2_YPRG / SuperGetMV("BRI_FATCON")
		aAdd(aNota, _nPrc)		    	// 8 Preco Gerencial
		Else
		aAdd(aNota, SD2->D2_YPRG)    	// 8 Preco Gerencial
		Endif
	Else
	_lGerenc := .F.
	aAdd(aNota, SD2->D2_PRCVEN)      	// 8 Preco Gerencial
	Endif

aAdd(aNota, 0)					// 09 Custo (R$/T)
aAdd(aNota, 0)					// 10 Custo Sacaria
aAdd(aNota, ZZ->D1_VALIMP6)	    // 11 PIS
aAdd(aNota, ZZ->D1_VALIMP5)	    // 12 COFINS
aAdd(aNota, ZZ->D1_CF)			// 13 CFOP
aAdd(aNota, ZZ->D1_UM)			// 14 UM
aAdd(aNota, ZZ->D1_GRUPO)		// 15 UM
aAdd(aNota, ZZ->D1_VALFRE)		// 16 VALOR DO FRETE - RATEADO PELA QUANTIDADE
aAdd(aNota, ZZ->D1_VALISS)		// 17 VALOR DO ISS

Return aNota





Static Function GERAMOVR()

	Private aNota    := {}

	SA1->(dbSetOrder(1))
	SA1->(MsSeek(xFilial("SA1")+ QRYSC5->C5_CLIENTE + QRYSC5->C5_LOJACLI))

	SB1->(MsSeek(xFilial("SB1")+ QRYSC5->C6_PRODUTO))

	_lMargem := .F.
	If !Empty(SB1->B1_GRUPO)
		SBM->(dbSetOrder(1))
		If SBM->(MsSeek(xFilial("SBM")+SB1->B1_GRUPO))
			If SBM->BM_TIPGRU == "11"
				_lMargem := .T.
			Endif
		Endif
	Endif

	_lGerenc := .T.

	aAdd(aNota, QRYSC5->C6_PRODUTO)		    // 1 Codigo produto
	aAdd(aNota, QRYSC5->C6_PRCVEN)			// 2 Preco unitario
	aAdd(aNota, QRYSC5->C6_QTDVEN)			// 3 Quantidade na nota
	aAdd(aNota, "")					    	// 4 Placa
	aAdd(aNota, QRYSC5->C6_TES)		    	// 5 TES
	aAdd(aNota, 0)							// 6 Aliquota ICMS
	aAdd(aNota, 0)	                	    // 7 Custo de transferencia (unitario)

	_lGerenc := .F.
	aAdd(aNota, QRYSC5->C6_PRCVEN)      	// 8 Preco Gerencial -->ALTERADO EM 14/02/17

	aAdd(aNota, 0)						// 9 Custo (R$/T)
	aAdd(aNota, 0)						// 10 Custo Sacaria
	aAdd(aNota, 0)					    // 11 PIS
	aAdd(aNota, 0)					    // 12 COFINS
	aAdd(aNota, QRYSC5->C6_CF)			// 13 CFOP
	aAdd(aNota, QRYSC5->C6_UM)			// 14 UM
	aAdd(aNota, SB1->B1_GRUPO)		// 15 UM
	aAdd(aNota, 0)		// 16 VALOR DO FRETE - RATEADO PELA QUANTIDADE
	aAdd(aNota, 0)		// 17 VALOR DO ISS

	Private nCusTran	 := aNota[7]
	Private nCustSac	 := aNota[10]
	Private aProduto	 := fPesqSB1()
	Private nQtdTB		 := aNota[3]
	Private cTipCar		 := aProduto[4]
	Private cDescCarga	 := fPesqDB0()
	Private nAliqICM	:= aNota[6]
	Private nFRE3Tot	:= 0 // Frete NF + Custo Transporte Total
	Private nFRE3Un		:= 0 // Frete NF + Custo Transporte Unitário
	Private	nPisNF      := 0 // PIS na NFS
	Private nCOFNF      := 0 // COFINS na NFS
	Private nPISGER     := 0 // PIS gerencial
	Private nCOFGER     := 0 // COFINS gerencial
	Private cDESTES		:= fPesqSF4() // Descrição da TES
	Private aCliente	:= fPesqSA1(cTipo)
	Private cTempo		 := "  :  "
	Private nICMSRetG	:= 0


	Private nPrecoUn	 := 0
	Private nTotNF		 := 0
	Private nTotNFG		 := 0
	Private nIpiG		 := 0
	Private nFrbUn		 := 0
	Private nIcmsG		 := 0
	Private nPisco		 := 0
	Private nPiscoG		 := 0
	Private nFrtUni		 := 0
	Private nFrtTot		 := 0
	Private nPoG		 := 0
	Private nPo 		 := 0
	Private naliqext     := 0
	Private _esticm	     := alltrim(getmv("MV_ESTICM"))
	Private _estado      := GetMV("MV_ESTADO")
	Private _picmest     := Val(Subs(_esticm,at(_estado,_esticm)+2,2))
	Private ndifaliq     := 0
	Private wPIRCSL      := 0
	Private nBaseIcmsG   := 0
	Private _lGerenc     := .T.
	Private cGrupo		:= aNota[15] //GRUPO
	Private cCampo2		:= fPesqZZA(xFilial('ZZA') + "02             ")
	Private cCampo3		:= fPesqZZA(xFilial('ZZA') + "03             ")
	Private cCampo4		:= fPesqZZA(xFilial('ZZA') + "04             ")
	Private cCampo5		:= fPesqZZA(xFilial('ZZA') + "05             ")
	Private cAtividade	:= ""
	Private cDescRegiao	:= ''
	Private cTes		:= aNota[5]
	Private wTES		:= ""
	Private nICMSRetG	:= 0
	Private nProdG		:= 0
	Private	cPrefixo    := "ROM"
	Private aOrdem		 := fPesqSZ8()
	Private _nCusto		:= 0





	nPisco  := (aNota[11] + aNota[12] ) * -1
	nPisNF  := aNota[11] * -1
	nCOFNF  := aNota[12] * -1
	_nISSNF := aNota[17] * -1

	_nTxPIS	:= SuperGetMV("MV_TXPIS")
	_nTxCOF	:= SuperGetMV("MV_TXCOFIN")
	_nPerc  := (_nTxPIS + _nTxCOF ) / 100
	_nTxISS := SB1->B1_ALIQISS / 100

	nPiscoG	:= Round(nTotNFG  * _nPerc,2)
	nQtdeGra			:= aNota[3]

	nTotNF				:= QRYSC5->C6_VALOR
	nTotNFG				:= QRYSC5->C6_VALOR

	nPrecoUn := Round(nTotNF / nQtdeGra,2)


	DbSelectArea("SE4")
	DbSetOrder(1)
	MsSeek(xFilial("SE4") + QRYSC5->C5_CONDPAG)

	If MsSeek(xFilial("ZZD")+cEmpAnt+cFilAnt+QRYSC5->(C5_NUM+'ROM'+C5_CLIENTE+C5_LOJACLI+C6_ITEM))
		RecLock("ZZD",.F.)
	Else
		RecLock("ZZD",.T.)
	EndIf

	If Empty(xFilial("ZZD"))
		ZZD->ZZD_FILIAL	:= xFilial("ZZD")
	Else
		ZZD->ZZD_FILIAL	:= QRYSC5->C5_FILIAL
	Endif

	_aSA1Box := RetSx3Box( Posicione("SX3", 2, "A1_YTPCLI", "X3CBox()" ),,, 1 )
	nAscan   := Ascan( _aSA1Box, { |e| e[2] = SA1->A1_YTPCLI } )

	If nAscan > 0
		If ZZD->(FieldPos("ZZD_TPCLI")) > 0
			ZZD->ZZD_TPCLI := AllTrim( _aSA1Box[nAscan][3] )
		Endif
	Endif

	_aSF4Box := RetSx3Box( Posicione("SX3", 2, "F4_YTPVEND", "X3CBox()" ),,, 1 )
	nAscan   := Ascan( _aSF4Box, { |e| e[2] = SF4->F4_YTPVEND } )

	If nAscan > 0
		If ZZD->(FieldPos("ZZD_TPVEND")) > 0
			ZZD->ZZD_TPVEND  := AllTrim( _aSF4Box[nAscan][3] )
		Endif
	Endif

	ZZD->ZZD_EMIS		:= QRYSC5->C5_EMISSAO
	ZZD->ZZD_ANOMES	    := Left(DtoS(QRYSC5->C5_EMISSAO),6)	 //Ano Mes
	// ZZD->ZZD_HRSAID	    := QRYSF2->F2_HORA             // HORA DE SAIDA DA NF
	ZZD->ZZD_PROD		:= QRYSC5->C6_PRODUTO		// Cod. produto
	ZZD->ZZD_DESCPR	    := aProduto[8]				// Descricao do Produto
	ZZD->ZZD_DESCRE	    := aProduto[9]				// Descricao Resumida do Produto
	ZZD->ZZD_DESGR 	    := aProduto[10]				// Descricao do Produto
	ZZD->ZZD_DESSGR	    := aProduto[11]				// Descricao Resumida do Produto
	ZZD->ZZD_CLIE		:= QRYSC5->C5_CLIENTE			// Cod. cliente
	ZZD->ZZD_LOJA		:= QRYSC5->C5_LOJACLI			// Loja
	ZZD->ZZD_NOME		:= aCliente[1]				// Nome cliente
	ZZD->ZZD_SERIE		:= 'ROM'					// Serie documento
	ZZD->ZZD_DOC		:= QRYSC5->C5_NUM				// Num. documento
	ZZD->ZZD_ITEM       := QRYSC5->C6_ITEM
	ZZD->ZZD_QTBRUT     := aNota[3]
	ZZD->ZZD_QTLIQ		:= aNota[3]
	ZZD->ZZD_PRECO		:= nPrecoUn					// Buscar no SD2
	ZZD->ZZD_PRECOG	    := nTotNFG / ZZD->ZZD_QTLIQ
	If QRYSC5->C5_TIPO = "D"
		ZZD->ZZD_TOTNF	:= nTotNF * -1		// Valor total da NF
	Else
		ZZD->ZZD_TOTNF	:= nTotNF		// Valor total da NF
	Endif
	If QRYSC5->C5_TIPO = "D"
		ZZD->ZZD_IPI	:= 0		// IPI
		ZZD->ZZD_TOTLIQ := ZZD->ZZD_TOTNF * -1
		ZZD->ZZD_ICMS	:=  0
		If ZZD->(FieldPos("ZZD_VALISS")) > 0
			ZZD->ZZD_VALISS :=0
		Endif
	Else
		ZZD->ZZD_IPI	:= 0			                    // IPI
		ZZD->ZZD_TOTLIQ := ZZD->ZZD_TOTNF - ZZD->ZZD_IPI
		ZZD->ZZD_ICMS	:= 0	// ICMS
		If ZZD->(FieldPos("ZZD_VALISS")) > 0
			ZZD->ZZD_VALISS := 0	                            // ISS
		Endif
	Endif

	If QRYSC5->C5_TIPO = "I"
		ZZD->ZZD_ALQICM     := 0
	Else
		ZZD->ZZD_ALQICM     := 0
	Endif

	ZZD->ZZD_PRCLIQ     := ZZD->ZZD_TOTLIQ / ZZD->ZZD_QTLIQ

	If QRYSC5->C5_TIPO = "D"
		If _lGerenc
			ZZD->ZZD_TOTNFG	:= (ZZD->ZZD_QTLIQ * ZZD->ZZD_PRECOG) *-1
		Else
			ZZD->ZZD_TOTNFG	:= ZZD->ZZD_TOTLIQ
		Endif
	Else
		If _lGerenc
			ZZD->ZZD_TOTLIG   := nTotNFG
			ZZD->ZZD_IPIG	  := 0	   // IPI Gerencial
			ZZD->ZZD_TOTNFG	  := nTotNFG
			ZZD->ZZD_ICMSG	  := nIcmsG
			ZZD->ZZD_PISGER   := nPISGER
			ZZD->ZZD_COFGER   := nCOFGER
			ZZD->ZZD_RETG	  := nICMSRetg
			ZZD->ZZD_PISCOG	  := nPiscoG					// Pis/Cofins (gerencial)
			ZZD->ZZD_DEICDC   := ((ZZD->ZZD_IPIG - ZZD->ZZD_IPI + ZZD->ZZD_ICMSG - ZZD->ZZD_ICMS)/2)
		Else
			ZZD->ZZD_TOTLIG   := ZZD->ZZD_TOTLIQ
			ZZD->ZZD_IPIG	  := 0	   // IPI Gerencial
			ZZD->ZZD_TOTNFG	  := ZZD->ZZD_TOTLIG + 	ZZD->ZZD_IPIG
			ZZD->ZZD_ICMSG	  := 0	// ICMS
			ZZD->ZZD_PISGER   := aNota[11]
			ZZD->ZZD_COFGER   := aNota[12]
			ZZD->ZZD_RETG	  := nICMSRetg
			ZZD->ZZD_PISCOG	  := nPisco					// Pis/Cofins (gerencial
		Endif
	Endif

	If cEmpAnt + QRYSC5->C5_FILIAL $  "5001/5002/5005/5006/5007" .And. SA1->A1_YTPCLI == "2"
		ZZD->ZZD_ICMSG  := 0
		ZZD->ZZD_PISGER := 0
		ZZD->ZZD_COFGER := 0
	Endif

	ZZD->ZZD_RET		:= 0					// ICMS Retido
	ZZD->ZZD_PISCO		:= nPisco					// Pis/Cofins
	ZZD->ZZD_PIS		:= aNota[11] 				//SF2->F2_VALIMP6
	ZZD->ZZD_COFINS	    := aNota[12]				//SF2->F2_VALIMP5
	ZZD->ZZD_FRETOT	    := nFrtTot					// Frete total
	ZZD->ZZD_FREUNI	    := nFrtUni					// Frete liquido unitario (gerencial)
	ZZD->ZZD_MUNEND	    := acliente[9]
	ZZD->ZZD_UF			:= acliente[5]				// Estado destino
	ZZD->ZZD_COND		:= QRYSC5->C5_CONDPAG			// Condicao de pagamento
	If SE4->(FieldPos("E4_YMEDIA")) > 0
		ZZD->ZZD_PM			:= SE4->E4_YMEDIA			// Prazo medio
	Endif
	ZZD->ZZD_VEND		:= QRYSC5->C5_VEND1 			// Vendedor
	ZZD->ZZD_NMVEND	    := POSICIONE("SA3",1,XFILIAL("SA3")+QRYSC5->C5_VEND1 ,"A3_NOME")
	ZZD->ZZD_ATIVI		:= aCliente[2]				// Atividade do cliente
	ZZD->ZZD_ATIVG		:= aCliente[3]				// Atividade 'real' do cliente
	ZZD->ZZD_FRBR		:= 0				    	// Frete bruto
	ZZD->ZZD_FRBRUN	    := nFrbUn					// Frete bruto unitario (Gerencial)
	ZZD->ZZD_KM			:= 0						// Distancia da Matriz ao cliente em Km
	ZZD->ZZD_KMR		:= 0						// Raio em Km -- ??
	ZZD->ZZD_TRANS		:= QRYSC5->C5_TRANSP			// Transportadora
	ZZD->ZZD_NOMTRA	    := POSICIONE("SA4",1,XFILIAL("SA4")+QRYSC5->C5_TRANSP,"A4_NOME")			// Transportadora
	ZZD->ZZD_CARRE		:= QRYSC5->C5_PLACA
	ZZD->ZZD_CARRO		:= ""
	ZZD->ZZD_MOTOR      := ""
	ZZD->ZZD_PREF		:= "ROM"					// Prefixo padrao do parametro conforme a filial atual
	ZZD->ZZD_YTPCAR	    := cTipCar					// Tipo de Carga
	ZZD->ZZD_YDEV		:= ""
	ZZD->ZZD_YNFSUB	    := ""
	ZZD->ZZD_TES		:= aNota[5]					// TES em SD2	
	ZZD->ZZD_UM		    := aNota[14]				// UM
	ZZD->ZZD_TEMPO		:= cTempo					// Tempo entre entrada na balanca e saida do faturamento
	ZZD->ZZD_GRUPO		:= cGrupo					// Grupo
	ZZD->ZZD_CPO2		:= cCampo2					// Segmento
	ZZD->ZZD_CPO3		:= cCampo3					// Empresas
	ZZD->ZZD_CPO4		:= cCampo4					// Regional
	ZZD->ZZD_CPO5		:= cCampo5					// Filial
	ZZD->ZZD_CPO7		:= cDescCarga				// Embalagem
	ZZD->ZZD_CPO8		:= cAtividade				// Atividade
	ZZD->ZZD_CPO12		:= cDescRegiao				// Regiao de Entrega
//If aNota[8] <> 0 								// Preco Gerencial
	If _lGerenc
		ZZD->ZZD_DEVCDC	:= nTotNFG - ZZD->ZZD_TOTLIQ
	Else
		ZZD->ZZD_DEVCDC	:= 0
	Endif
	ZZD->ZZD_CPO17		:= IIf(Empty(QRYSC5->C5_TRANSP),'N/CADASTRADO',QRYSC5->C5_TRANSP)  // Transportadora
	ZZD->ZZD_CPO21		:= IIf(Empty(cTes),'N/CADASTRADO',cTes)	// Tes
	ZZD->ZZD_CPO22		:= aCliente[4]				            // Data primeiro faturamento
	// ZZD->ZZD_VLR16		:= aPedido[11]				                            // Peso Saida da Ordem de Carregamento - Marciane pediu em 11/07/05
	ZZD->ZZD_VLR17		:= IIf(aProduto[6] $ "BB/TB",aOrdem[3]*aProduto[7],aOrdem[3])// Peso NF
	ZZD->ZZD_YDIAST	    := aOrdem[5]-IIf(Empty(aOrdem[9]),aOrdem[5],aOrdem[9])   // Z8_DTSAIDA - Z1_YDTLIB
	ZZD->ZZD_YHORAT     := ElapTime(aOrdem[10]+":00",aOrdem[8]+":00") // Z1_HLIB + Hora da Saida (Z8_HSAIDA)
	ZZD->ZZD_YOC        := aOrdem[6]

	If Val(Subs(ZZD->ZZD_YHORAT,1,2)) > 0 .or. Val(Subs(ZZD->ZZD_YHORAT,4,2)) > 0
		ZZD->ZZD_YTOTDT  := ((ZZD->ZZD_YDIAST*24)+Val(Subs(ZZD->ZZD_YHORAT,1,2)))/24
	Else
		ZZD->ZZD_YTOTDT  := 0
	Endif

	ZZD->ZZD_TPROD      := QRYSC5->C6_VALOR
	ZZD->ZZD_TPRODG     := IIf( ZZD->ZZD_TOTNFG > 0, nProdG, 0 )

	If aProduto[6]$("BB/TB/UN")
		ZZD->ZZD_YPESTB	:= aProduto[7]
	EndIf

	ZZD->ZZD_CODEMP	:= cEmpAnt
	ZZD->ZZD_CODFIL	:= QRYSC5->C5_FILIAL
	ZZD->ZZD_NOMFIL := POSICIONE("SM0",1,cEmpAnt + QRYSC5->C5_FILIAL,"M0_FILIAL")

	_cSigl := ""
	If ZZD->(FieldPos("ZZD_SIGLA2")) > 0
		If cEmpAnt == "02"
			If QRYSC5->C5_FILIAL == "01"
				_cSigl := "PX-IBA"
			ElseIf QRYSC5->C5_FILIAL == "02"
				_cSigl := "PX-IDC"
			ElseIf QRYSC5->C5_FILIAL $ "03/04"
				_cSigl := "  "
			ElseIf QRYSC5->C5_FILIAL == "05"
				_cSigl := "PX-IJB"
			ElseIf QRYSC5->C5_FILIAL == "06"
				_cSigl := "PX-IFT"
			ElseIf QRYSC5->C5_FILIAL == "07"
				_cSigl := "PX-IMC"
			ElseIf QRYSC5->C5_FILIAL == "08"
				_cSigl := "PX-INT"
			ElseIf QRYSC5->C5_FILIAL == "09"
				_cSigl := "PX-ISV"
			ElseIf QRYSC5->C5_FILIAL == "10"
				_cSigl := "PX-IBA"
			ElseIf QRYSC5->C5_FILIAL == "11"
				_cSigl := "PX-IPT"
			ElseIf QRYSC5->C5_FILIAL == "12"
				_cSigl := "PX-IGU"
			ElseIf QRYSC5->C5_FILIAL == "13"
				_cSigl := "PX-ICC"
			ElseIf QRYSC5->C5_FILIAL == "14"
				_cSigl := "PX-ISL"
			Endif
		ElseIf cEmpAnt == "04"
			If QRYSC5->C5_FILIAL $ "01"
				If ZZD->ZZD_PRECO > SUPERGETMV("BRI_VALCAP",.F.,180)
					_cSigl := "MSP C/CAP"
				Else
					_cSigl := "MSP S/CAP"
				Endif
			ElseIf QRYSC5->C5_FILIAL == "02"
				_cSigl := "MRE"
			Endif
		ElseIf cEmpAnt == "05"
			_cSigl := "MRE"
		ElseIf cEmpAnt == "09"
			_cSigl := "PX-IMC"
		ElseIf cEmpAnt == "13"
			If QRYSC5->C5_FILIAL     $ "01"
				_cSigl := "PX-IRO"
			ElseIf QRYSC5->C5_FILIAL $ "04"
				_cSigl := "PX-IBA"
			ElseIf QRYSC5->C5_FILIAL == "06"
				_cSigl := "PX-IRO"
			ElseIf QRYSC5->C5_FILIAL == "07"
				_cSigl := "PX-IBA"
			Endif
		ElseIf cEmpAnt == "16"
			_cSigl := "PX-IPT"
		ElseIf cEmpAnt == "50"
			If QRYSC5->C5_FILIAL == "01"
				_cSigl := "PX-IBA"
			ElseIf QRYSC5->C5_FILIAL == "02"
				_cSigl := "PX-IRO"
			ElseIf QRYSC5->C5_FILIAL == "03"
				_cSigl := "PX-IFT"
			ElseIf QRYSC5->C5_FILIAL == "04"
				_cSigl := "PX-INT"
			ElseIf QRYSC5->C5_FILIAL == "05"
				_cSigl := "PX-IDC"
			ElseIf QRYSC5->C5_FILIAL == "06"
				_cSigl := "PX-IGU"
			ElseIf QRYSC5->C5_FILIAL == "07"
				_cSigl := "PX-ICC"
			ElseIf QRYSC5->C5_FILIAL == "08"
				_cSigl := "PX-ISL"
			ElseIf QRYSC5->C5_FILIAL == "09"
				_cSigl := "PX-IJB"
			ElseIf QRYSC5->C5_FILIAL == "10"
				_cSigl := "PX-ISV"
			ElseIf QRYSC5->C5_FILIAL == "11"
				_cSigl := "PX-IRB"
			ElseIf QRYSC5->C5_FILIAL == "12"
				_cSigl := "PX-AE "
			ElseIf QRYSC5->C5_FILIAL == "13"
				_cSigl := "PX-IPT"
			ElseIf QRYSC5->C5_FILIAL == "14"
				_cSigl := "PX-MT"
			ElseIf QRYSC5->C5_FILIAL == "15"
				_cSigl := "PX-IMC"
			ElseIf QRYSC5->C5_FILIAL == "16"
				_cSigl := "PX-INH"
			Endif
		Endif
		ZZD->ZZD_SIGLA2 := _cSigl
	Endif

	cSigla:= SuperGetMv( "BRI_SIGLA" , .F. , , QRYSC5->C5_FILIAL ) //  getNewPar('BRI_SIGLA','BRI ')

	ZZD->ZZD_SIGLA  := cSigla

	If QRYSC5->C5_TIPO $ "C/I"
		_nFOBL := 0
		_nCIFL := 0
	ElseIf SA1->A1_YTPCLI == "2"
		_nFOBL := (ZZD->ZZD_TOTNFG - ZZD->ZZD_ICMSG - ZZD->ZZD_PISGER - ZZD->ZZD_COFGER ) / ZZD->ZZD_QTLIQ
		_nCIFL := (ZZD->ZZD_TOTNFG + ZZD->ZZD_FRETOT                                    ) / ZZD->ZZD_QTLIQ
	Else
		_nFOBL := (ZZD->ZZD_TOTNFG - ZZD->ZZD_ICMSG - ZZD->ZZD_PISGER - ZZD->ZZD_COFGER - ZZD->ZZD_FRETOT ) / ZZD->ZZD_QTLIQ
		_nCIFL := ZZD->ZZD_TOTNFG + ZZD->ZZD_FRETOT
	Endif

	nCalcPoG:= iif( nCalcPoG <0 , 0 , nCalcPoG )

	nPoG            := nCalcPoG
	ZZD->ZZD_PO		:= If (_nFOBL < 0,0, _nFOBL)
	ZZD->ZZD_FOBL	:= If (_nFOBL < 0,0, _nFOBL)
	ZZD->ZZD_CIFL   := If (_nCIFL < 0,0, _nCIFL)
 
	ZZD->ZZD_MASSAG	:= ( ZZD->ZZD_TOTNF - ZZD->ZZD_IPI - ZZD->ZZD_ICMS - ZZD->ZZD_RET - ZZD->ZZD_PIS - ZZD->ZZD_COFINS - nFrtTot)

	nPo	            := nPoG
	ZZD->ZZD_MASSA  := ( ZZD->ZZD_TOTNF - ZZD->ZZD_IPI - ZZD->ZZD_ICMS - ZZD->ZZD_RET - ZZD->ZZD_PIS - ZZD->ZZD_COFINS - nFrtTot)

	ZZD->ZZD_CUSTO	:= _nCusto

	If _lMargem
		ZZD->ZZD_MARGEM	:= ZZD->ZZD_FOBL - ZZD->ZZD_CUSTO
		ZZD->ZZD_MARGEG	:= ZZD->ZZD_FOBL - ZZD->ZZD_CUSTO
	Endif

	nPO := Round((nTotNFG - nIpiG - nIcmsG - nIcmsRetG - nPiscoG - nFrtTot - 0) / nQtdeGra,2)
	nPO -= If(cTipCar = "S",nCustSac,0)
	ZZD->ZZD_YPEDAG := 0
	ZZD->ZZD_YCTR  	:= ""
	ZZD->ZZD_YSERCT := ""
	ZZD->ZZD_IRCSL  := IF(ZZD->ZZD_MARGEM > 0 ,(nQtdeGra * ZZD->ZZD_MARGEM * wPIRCSL),0)
	ZZD->ZZD_IRCSLG := IF(ZZD->ZZD_MARGEG > 0 ,(nQtdeGra * ZZD->ZZD_MARGEG * wPIRCSL),0)
	aZZD			:= GetArea("ZZD")

	If Alltrim(cTipCar) $ "CDC*G"
		ZZD->ZZD_PERFIL := "GRANEL"
	ELSEIF cTipCar = "S"
		ZZD->ZZD_PERFIL := "TAMBOR"
	Endif

	ZZD->ZZD_CFOP   := aNota[13]
	ZZD->ZZD_TIPONF := "R"
	ZZD->ZZD_TIPOMT := aProduto[12]
	ZZD->ZZD_DESTES := cDESTES[2]

	If ZZD->ZZD_FRETOT > 0
		ZZD->ZZD_QTCIF  := ZZD->ZZD_QTLIQ
		ZZD->ZZD_TPFRE	:= "C"
	Else
		ZZD->ZZD_TPFRE	:= "F"
		ZZD->ZZD_QTCIF  := 0
	Endif

	ZZD->ZZD_MARTOT := (ZZD->ZZD_MARGEG*ZZD->ZZD_QTLIQ)+ZZD->ZZD_DEICDC
	ZZD->ZZD_FRE3U  := nFRE3Un
	ZZD->ZZD_YMUN   := SA1->A1_MUN
	ZZD->ZZD_YEST   := SA1->A1_EST

	If ZZD->(FieldPos("ZZD_NREDUZ")) > 0
		ZZD->ZZD_NREDUZ:= SA1->A1_NREDUZ
	Endif

	If QRYSC5->C5_TIPO <> 'D'
		ZZD->ZZD_GRPVEN  := SA1->A1_GRPVEN
	Endif

	ZZD->ZZD_DESGRU  := POSICIONE("SBM",1,XFILIAL("SBM")+cGrupo,"BM_DESC")
	zzd->zzd_itemct  := posicione('SB1',1,xfilial('SB1')+aNota[1],'B1_ITEMCC')

	do case
	case anota[14] $ 'BB/TB' //unidade de medida
		if aCliente[8] =='S' // a1_yfilpol - filial polimix
			zzd->zzd_itemct := '010104'
		else
			zzd->zzd_itemct := '010102'
		endif
	case anota[14] == 'KG'
		if aCliente[8] =='S'
			zzd->zzd_itemct := '010103'
		else
			zzd->zzd_itemct := '010101'
		endif
	endcase

	ZZD->ZZD_DESITE:= posicione('CTD',1,xfilial('CTD')+zzd->zzd_itemct,'CTD_DESC01')

	If QRYSC5->C5_TIPO = "D"
		ZZD->ZZD_PISNF  := nPisNF * -1
		ZZD->ZZD_COFNF  := nCOFNF * -1
	Else
		ZZD->ZZD_PISNF  := nPisNF
		ZZD->ZZD_COFNF  := nCOFNF
	Endif

	ZZD->ZZD_FATURA := ''
	ZZD->ZZD_DTFAT  := ctod('')
	ZZD->ZZD_NFORI  := ''
	ZZD->ZZD_SERORI := ''

	ZZD->ZZD_TESORI := ''

	_nValfrete:= 0

	// ZZD->ZZD_QTDIES := QRYSF2->F2_PDLITQT
	// ZZD->ZZD_UNIDIE := QRYSF2->F2_pdlitun
	// ZZD->ZZD_VALDIE := QRYSF2->F2_pdlitto
	// ZZD->ZZD_FRECTE := _nValfrete
	// ZZD->ZZD_SDOCTE :=  ZZD->ZZD_FRECTE - ZZD->ZZD_VALDIE

	DbSelectArea("ZZD")
	MsUnlock()
	RestArea(aZZD)

	RestArea(_aAliSA1)
	RestArea(_aAliSA2)
	RestArea(_aAliSF4)
	RestArea(_aAliOri)

Return('fim')
