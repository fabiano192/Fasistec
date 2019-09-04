#include "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MIZ1100   º Autor ³ Felipe Zago        º Data ³  18/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo MP8 IDE.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Geracao do arquivo ZZD - EXPORTA PARA BI                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MIZ1100()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Buscar no cabecalho da nota as informacoes								 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If cTipo == "SF2"
		GERAMOVS()
	Else
		GERAMOVE()
	Endif


Return



Static Function GeraMovS()

	dbSelectArea("SF2")
	dbSetOrder(1)
	dbSeek(xFilial("SF2")+cDoc+cSERIE+cCliente+cLoja,.t.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Buscar produto no pedido                  								 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SZ7")
	DbSetOrder(4)

	xDoc:= left(SF2->F2_DOC,9)

	If !DbSeek(xFilial("SZ7") + xDoc + SF2->F2_SERIE)
		DbSeek(xFilial("SZ7") + xDoc )
	EndIf

	if UPPER(alltrim(funname()))=='REPROZZD' .AND. empty(sz7->(z7_filial+z7_numnf+z7_serie) )  .and. valtype(aLogErr)=='A' //.and. !MsgBox("Documento nao localizado em PEDIDOS FATURADOS(SZ7) ! [ "+xFilial("SZ7") +'/'+ SF2->F2_DOC +'/'+ SF2->F2_SERIE+" ] Continuar gravacao ?","Atencao","YESNO")
		aAdd(aLogErr, "Documento nao localizado em PEDIDOS FATURADOS(SZ7) ! [ Filial:"+xFilial("SZ7") +'/ Doc: '+ xDoc +'/ Serie: '+ SF2->F2_SERIE+" ]" )
	endif


	SB1->(DbSeek(xFilial("SB1")+SZ7->Z7_PRODUTO))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private nPrecoUn		:= 0
	Private nTotNF			:= 0
	Private nTotNFG			:= 0
	Private nIpiG			:= 0
	Private nFrbUn			:= 0
	Private nIcmsG			:= 0
	Private nPisco			:= 0
	Private nPiscoG			:= 0
	Private nFrtUni			:= 0
	Private nFrtTot			:= 0
	Private nPoG			:= 0
	Private nPo 			:= 0
	Private wOrdSZ1			:= 0
	Private wRecSZ1			:= 0
	Private aOrdem			:= fPesqSZ8()
	Private cTempo			:= aOrdem[1]
	Private aCliente		:= fPesqSA1()
	Private naliqext 		:= 0
	Private _esticm	 		:= alltrim(getmv("MV_ESTICM"))
	Private _estado  		:= GetMV("MV_ESTADO")
	Private _picmest		:= Val(Subs(_esticm,at(_estado,_esticm)+2,2))
	Private naliqext 		:= 0
	Private ndifaliq 		:= 0
	Private wPIRCSL 		:= GETMV("MV_YIRCSSL") / 100
	Private nBaseIcmsG 		:= 0
	Private aNota			:= fPesqSD2()
	Private nCusTran		:= aNota[7]
	Private nCustSac		:= aNota[10]
	Private aProduto		:= fPesqSB1()
	Private nQtdeEns		:= iif(aProduto[6]='SC',aNota[3],0)
	Private cTipCar			:= aProduto[4]
	Private cDescCarga		:= fPesqDB0() // Descricao do tipo de carga - DB0_DESMOD
	Private nQtdeGra		:= Round(If(aProduto[6]$("SA/SC"),aNota[3]/(1000/aProduto[7]),aNota[3]),2)
	Private cPrefixo		:= "FAT"
	Private aPedido			:=  fPesqSZ7()
	Private cCampo1			:=  fPesqZZA(xFilial('ZZA') + "01             ")
	Private cCampo2			:=  fPesqZZA(xFilial('ZZA') + "02             ")
	Private cCampo3			:=  fPesqZZA(xFilial('ZZA') + "03             ")
	Private cCampo4			:=  fPesqZZA(xFilial('ZZA') + "04             ")
	Private cCampo5			:=  fPesqZZA(xFilial('ZZA') + "05             ")
	Private aCReceb 		:=  fPesqSE1(xFilial('SE1') + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_SERIE + SF2->F2_DOC)
	Private nValor14		:=  fPesqSE4()
	Private nValor16		:=  aPedido[8]  // Peso real
	Private nValor17		:=  aPedido[10] // Peso NF
	Private cTes			:=  aNota[5]
	Private cAtividade		:=  fPesqSX5() // Busca a partir da Atividade Gerencial SX5('YI') Se Ativ.Real nao preenchida, entao retornara Atividade
	Private cRegiao			:=  fPesqSZ4()
	Private cDescRegiao		:=  fPesqSZO() // Cadastro de Regioes ZO_DESC
	Private wTES			:= ""
	Private nICMSRetG		:= 0
	Private nProdG			:= 0

	if xFilial("SF2")<>"98"
		cPrefixo := AllTrim(Getmv("MV_YPREF")) 	// Traz o prefixo padrao do parametro conforme a filial atual
	EndIf
	Private nMedia			:=  fPesqSE4()
	Private nAliqICM		:= aNota[6]
	Private nFRE3Tot		:= 0 // Frete NF + Custo Transporte Total
	Private nFRE3Un			:= 0 // Frete NF + Custo Transporte Unitário
	Private	nPisNF          := 0 // PIS na NFS
	Private nCOFNF          := 0 // COFINS na NFS
	Private nPISGER         := 0 // PIS gerencial
	Private nCOFGER         := 0 // COFINS gerencial
	Private cDESTES			:= fPesqSF4() // Descrição da TES


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Continua apenas se o Tipo de Produto for "PA", Produto Acabado           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !aProduto[1]
		if UPPER(alltrim(funname()))=='REPROZZD' .AND. valType( aLogErr )=='A'
			aAdd(aLogErr, 'Produto nao e PA ! '+aproduto[8] )
		endif

		// Abandona o programa
		Return ('loop')
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe preco gerencial. Caso positivo, calcula o valor       ³
	//³ total da NF e baseia todos os calculos neste valor.                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	nTotNF	:= SF2->F2_VALBRUT
	nTotNFG	:= SF2->F2_VALBRUT
	If(aProduto[6]= "SA")
		nPrecoUn := Round(nTotNF / aNota[3],2)			// Valor bruto da nota / quantidade em sacos
	ElseIf (aProduto[6]= "SC")
		nPrecoUn := Round(nTotNF / nQtdeEns,2)			// Valor bruto da nota / quantidade em sacos
	ElseIf (aProduto[6]= "TL")
		nPrecoUn := Round(nTotNF / nQtdeGra,2)
	EndIf

	If aNota[8] == 0 // Preco Gerencial nulo
	Else // Existe preco gerencial
		If (aProduto[6]= "SC")
			nTotNFG := aNota[8] * nQtdeEns			    // Preco gerencial * quantidade em tons
		ElseIf (aProduto[6]= "TL")
			nTotNFG := aNota[8] * nQtdeGra			    // Preco gerencial * quantidade em tons
		EndIf
	EndIf

	naliqext := 12

	nD2Aliq :=  1+( ( _picmest - naliqext ) / 100 )

	If SF2->F2_ICMSRET > 0 .And. aNota[8] <> 0 //Preco Gerencial

		nProdG := ROUND(      ((nTotnfg  /  nDifAliq )    -   (If(SF2->F2_YVALFRE > 0,SF2->F2_YVALFRE,SF2->F2_FRETE) * 1.04) ) / 1.04 , 2 )

		nIcmsRetG :=  ( ( nProdG + If(SF2->F2_YVALFRE > 0,SF2->F2_YVALFRE,SF2->F2_FRETE) )  * 1.04) * ( ndifaliq  - 1 )

	Else // produto gerencial sem ICMS RETIDO
		nProdG := ROUND(  (nTotNFG  /  1.04 ) - If(SF2->F2_YVALFRE > 0,SF2->F2_YVALFRE,SF2->F2_FRETE),2 )
	EndIf

	if SF2->F2_VALIPI = 0
		nIpiG:= 0
	Else
		If SF2->F2_YVALFRE > 0
			nIpiG	:= Round((((nTotNFG - SF2->F2_YVALFRE*1.04)-nICMSRETG)/1.04+SF2->F2_YVALFRE)*0.04,2)
		Else
			nIpiG	:= Round((((nTotNFG - SF2->F2_FRETE*1.04)-nICMSRETG)/1.04+SF2->F2_FRETE)*0.04,2)
		EndIf
	EndIf

	If SF2->F2_YVALFRE > 0
		nFrbUn	:= iif(cTipCar='S',SF2->F2_YVALFRE / nQtdeEns, SF2->F2_YVALFRE / nQtdeGra)
	Else
		nFrbUn	:= iif(cTipCar='S',SF2->F2_FRETE / nQtdeEns, SF2->F2_FRETE / nQtdeGra)
	EndIf

	If SF2->F2_ICMSRET > 0 .And. aNota[8] <> 0 //Preco Gerencial
		naliqext := 12
		If SF2->F2_YVALFRE > 0
			nProduto := nTotNFG - ( 1.05 * SF2->F2_YVALFRE ) - ( 1.05 * nIpiG )
		Else
			nProduto := nTotNFG - ( 1.05 * SF2->F2_FRETE ) - ( 1.05 * nIpiG )
		EndIf
		nProduto  := Round(nProduto / 1.05,2)
		ndifaliq  := ( _picmest - naliqext ) / 100
		nIcmsRetG :=  ( nProduto + If(SF2->F2_YVALFRE > 0,SF2->F2_YVALFRE,SF2->F2_FRETE) + nIpiG ) * ndifaliq
	EndIf

	If aNota[8] == 0 //Preco Gerencial
		nIcmsG	  := SF2->F2_VALICM
		//nIcmsG	  := SF2->F2_VALICM + aNota[17] + aNota[18]
		nICMSRetG := SF2->F2_ICMSRET
		nIPIG     := SF2->F2_VALIPI
	Else
		_nAliq := aNota[6]
		If Empty(aNota[6]) .And. cEmpAnt == "10"
			_nAliq := GETMV("MV_ICMPAD")
		Endif

		If SF2->F2_YVALFRE > 0
			nBaseIcmsG := nTotNFG - SF2->F2_YVALFRE-iif(aCliente[2] $ ("1/2"),nIpiG,0) + If(aCliente[6] == "N",SF2->F2_YVALFRE,0)
			nIcmsG	:= Round((nTotNFG - SF2->F2_YVALFRE-iif(aCliente[2] $ ("1/2"),nIpiG,0)-nIcmsRetG) * (_nAliq / 100) ,2)
		Else
			nBaseIcmsG := nTotNFG - SF2->F2_FRETE-iif(aCliente[2] $ ("1/2"),nIpiG,0) + If(aCliente[6] == "S",SF2->F2_FRETE,0)
			nIcmsG	:= Round((nBaseIcmsG-iif(aCliente[2] $ ("1/2"),nIpiG,0)-nIcmsRetG) * (_nAliq / 100) ,2)
		EndIf
	EndIf

	nPisco	:= 0
	nPiscoG	:= 0

	nAlqPisGer := 0.0165
	nAlqCofGer := 0.0760

	If AllTrim(aNota[1]) $ GetMV('MV_YBONIF') .Or. AllTrim(aNota[5]) $ GetMV('MV_YTESCEB')
		// Nao Calcula o nPISCO nem o nPISCOG quando for bonificacao
	Else
		If xFilial("SF2") <> "98"
			If !(cTES $ "621#523#521") // se nao for um dos TES expecificados ao lado
				nPisco  := aNota[11]+aNota[12]	//SF2->(F2_VALIMP5 + F2_VALIMP6) Não grava SF2. Somente SD2
				nPisNF  := aNota[11]
				nCOFNF  := aNota[12]
			EndIf

			nPiscoG	:= Round((nTotNFG - nIpiG - nIcmsRetG) * (nAlqPisGer+nAlqCofGer),2)

		EndIf

		If aNota[8] == 0 //Preco Gerencial
			nPiscoG := nPisco
			nPISGER := nPisNF
			nCOFGER := nCOFNF
		Else// Marcus Vinicius - 23/11/16
			fAlqPisCOfGer(@nAlqPisGer,@nAlqCofGer)

			If SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0203|4001" .AND. aProduto[4] $ "CDC"
				nPiscoG	:= Round((nTotNFG - nIpiG - nIcmsRetG) * (nAlqPisGer+nAlqCofGer),2)
			EndIf

			nPISGER := Round((nTotNFG - nIpiG - nIcmsRetG) * nAlqPisGer,2)
			nCOFGER := Round((nTotNFG - nIpiG - nIcmsRetG) * nAlqCofGer,2)
		EndIf

	Endif

	nFrtUni:= nFrbUn

	If ! Empty(SF2->F2_TRANSP)
		If _estado == aCliente[5]  //Verifica o estado do cliente para definir o tipo da TES
			wTES  := GetMV("MV_YTESFRD") //TES Frete para Dentro do Estado
		Else
			wTES  := GetMV("MV_YTESFRF") //TES Frete para Fora do Estado
		EndIf

		_nIcmFrtUn  := 0

		IF wTES <> "163"

			SA1->(dbSetorder(1))

			_nAliqIcm := 12//AliqIcms("N","S","C" )

			//		If cEmpAnt $ "01/10"
			If cEmpAnt $ "01/10" .Or. cEmpAnt+cFilAnt $ '0201|0215|0218|0220|0221'
				_nIcmFrtUn  := Round((nFrbUn * (_nAliqICM /100) ),4)
			Else
				If _estado <> aCliente[5]
					_nIcmFrtUn  := Round((nFrbUn * (_nAliqICM /100) ),4)
				Endif
			Endif
		Endif

		nFrtUni:= nFrbUn - _nIcmFrtUn - Round((nFrbUn * 0.0925 ),4)

	EndIf

	nFrFixDifT	:= 0

	if SF2->F2_YFRETE=='C' //CIF- O FRETE POR CONTA DA MIZU
		nFrtTot	:= Round(iif(cTipCar='S', nFrtUni * nQtdeEns, nFrtUni * nQtdeGra),4)
	endif

	//Calculo Frete + Custo Transporte
	If SF2->F2_YVALFRE > 0
		nFRE3Un	:= iif(cTipCar='S',SF2->F2_YVALFRE / nQtdeEns, SF2->F2_YVALFRE / nQtdeGra)
	Else
		nFRE3Un	:= iif(cTipCar='S',SF2->F2_FRETE / nQtdeEns, SF2->F2_FRETE / nQtdeGra)
	EndIf
	nFRE3Un	 += iif(cTipCar="S",nCusTran/(1000/aProduto[7]),nCusTran)    // COMENTADO POR GUSTAVO EM 28/04/15
	nFRE3Un  += Round( iif(cTipCar='S', SF2->F2_YPEDAG / nQtdeEns, SF2->F2_YPEDAG /  nQtdeGra) ,2)// COMENTADO POR GUSTAVO EM 28/04/15

	//soma diferenca entre frete da nota e frete fixo da tabela de estados e municipios
	nFRE3Un  += nFrFixDifT //Round( IIF( cTipCar='S', nFrFixDifT / nQtdeEns, nFrFixDifT / nQtdeGra)  ,2)

	if SF2->F2_YFRETE=='C' //CIF- O FRETE POR CONTA DA MIZU
		nFRE3Tot := Round( iif(cTipCar='S', nFRE3Un * nQtdeEns, nFRE3Un * nQtdeGra) ,2)
	endif

	//Calculo Imp. Renda e CSLL
	nMARGEG	:= Round((nTotNFG - nIpiG - nIcmsG - nIcmsRetG - nPiscoG - If(SF2->F2_YVALFRE > 0,SF2->F2_YVALFRE,SF2->F2_FRETE) - SF2->F2_YPEDAG) / nQtdeGra,2)   -  aNota[9]	   // Margem de Lucro
	nIRCSLG := IF(nMARGEG > 0 ,(nQtdeGra * nMARGEG * wPIRCSL),0)

	// Calculo do Po
	wwTotNFG:= 0
	wwTotNFG:= IIf( AllTrim(aNota[1]) $ GetMV('MV_YBONIF') .Or. AllTrim(aNota[5]) $ GetMV('MV_YTESCEB') , 0 , nTotNFG )
	nPoG	:=  fCalcPoG(cTipCar, wwTotNFG, nIpiG, nIcmsG, nPiscoG, nFrtTot, nQtdeGra, nCustSac,nIRCSLG, nCusTran)

	DbSelectArea("ZZD")
	DbSetOrder(8)
	aZZD				:= GetArea("ZZD")

	If dbSeek(xFilial("ZZD")+cEmpAnt+cFilAnt+SF2->F2_SERIE+SF2->F2_DOC)
		RecLock("ZZD",.f.)
	Else
		RecLock("ZZD",.t.)
	EndIf

	dbSelectArea("SF2")
	ZZD->ZZD_FILIAL		:= xFilial("ZZD") //SF2->F2_FILIAL
	ZZD->ZZD_EMIS		:= SF2->F2_EMISSAO
	ZZD->ZZD_HRSAID		:= SF2->F2_HORA             // HORA DE SAIDA DA NF
	ZZD->ZZD_PROD		:= aNota[1]					// Cod. produto
	ZZD->ZZD_DESCPR		:= aProduto[8]				// Descricao do Produto
	ZZD->ZZD_DESCRE		:= aProduto[9]				// Descricao Resumida do Produto
	ZZD->ZZD_DESGR 		:= aProduto[10]				// Descricao do Produto
	ZZD->ZZD_DESSGR		:= aProduto[11]				// Descricao Resumida do Produto
	ZZD->ZZD_CLIE		:= SF2->F2_CLIENTE			// Cod. cliente
	ZZD->ZZD_LOJA		:= SF2->F2_LOJA				// Loja
	ZZD->ZZD_NOME		:= aCliente[1]				// Nome cliente
	ZZD->ZZD_SERIE		:= SF2->F2_SERIE			// Serie documento
	ZZD->ZZD_DOC		:= SF2->F2_DOC				// Num. documento
	ZZD->ZZD_QTENS		:= nQtdeEns					// Quantidade ensacado
	ZZD->ZZD_QTGRA		:= nQtdeGra					// Quantidade granel
	ZZD->ZZD_PRECO		:= nPrecoUn					// Buscar no SD2
	IIF (ZZD->(FieldPos("ZZD_PICM"	 )) > 0, ZZD->ZZD_PICM := nAliqICM , 0) // Marcus Vinicius - 16/11/2016 - Alíquota ICMS
	IIF (ZZD->(FieldPos("ZZD_ALQIPI" )) > 0, ZZD->ZZD_IPI  := aNota[14], 0) // Marcus Vinicius - 16/11/2016 - Alíquota IPI

	ZZD->ZZD_PRECOG		:= iif(aNota[8]=0,ZZD->ZZD_PRECO,aNota[8])

	If xFilial("SF2") <> "98"
		ZZD->ZZD_TOTNF		:= nTotNF					// Valor total da NF
		If aNota[5] == "542"
			ZZD->ZZD_TOTNFG		:= 0     				// Valor total Gerencial da NF
		Else
			ZZD->ZZD_TOTNFG		:= nTotNFG				// Valor total Gerencial da NF
		Endif
	Else
		ZZD->ZZD_TOTNF		:= aNota[2]*aNota[3]	// Valor total da NF
		ZZD->ZZD_TOTNFG		:= aNota[2]*aNota[3]	// Valor total Gerencial da NF
	EndIf
	// Corrige o valor da NFGerencial caso seja produto de bonificaçao
	ZZD->ZZD_TOTNFG		:= IIf( AllTrim(aNota[1]) $ GetMV('MV_YBONIF') .Or. AllTrim(aNota[5]) $ GetMV('MV_YTESCEB') , 0 , ZZD->ZZD_TOTNFG )

	ZZD->ZZD_IPI		:= SF2->F2_VALIPI			// IPI
	ZZD->ZZD_IPIG		:= nIpiG					// IPI Gerencial
	ZZD->ZZD_ICMS		:= SF2->F2_VALICM 			//  + aNota[17] + aNota[18]	// ICMS
	ZZD->ZZD_ICMSG		:= nIcmsG					// ICMS (gerencial)
	ZZD->ZZD_ICMCOM     := aNota[17]                // D2_ICMSCOM
	ZZD->ZZD_DIFAL      := aNota[18]                // D2_DIFAL

	ZZD->ZZD_RET		:= SF2->F2_ICMSRET			// ICMS Retido
	ZZD->ZZD_RETG		:= nICMSRetg

	ZZD->ZZD_PISCO	:= nPisco					// Pis/Cofins
	ZZD->ZZD_PISCOG	:= nPiscoG					// Pis/Cofins (gerencial)
	ZZD->ZZD_PIS	:= aNota[12]	//SF2->F2_VALIMP6
	ZZD->ZZD_COFINS	:= aNota[11]	//SF2->F2_VALIMP5

	ZZD->ZZD_FRETOT		:= nFrtTot					// Frete liquido
	ZZD->ZZD_FREUNI		:= nFrtUni					// Frete liquido unitario (gerencial)
	ZZD->ZZD_FRFIXU		:= SF2->F2_FRFIXO					// Frete Fixo unitario
	ZZD->ZZD_FRFIXT		:= IIF( cTipCar='S', SF2->F2_FRFIXO * nQtdeEns, SF2->F2_FRFIXO * nQtdeGra) // FRETE FIXO - TABELA DE ESTADOS E MUNICIPIOS ( SZG )

	If cEmpAnt + cFilAnt $ '0210|3001
		ZZD->ZZD_MUNEND		:= aCliente[9]				// Municipio de entrega
	else
		ZZD->ZZD_MUNEND		:= SF2->F2_YMUNE			// Municipio de entrega
	endif
	ZZD->ZZD_UF			:= SF2->F2_YUFE				// Estado destino
	ZZD->ZZD_COND		:= SF1->F1_COND				// Condicao de pagamento
	ZZD->ZZD_PM			:= nMedia     				// Prazo medio
	ZZD->ZZD_VEND		:= SF2->F2_VEND1 			// Vendedor
	ZZD->ZZD_NMVEND		:= POSICIONE("SA3",1,XFILIAL("SA3")+SF2->F2_VEND1,"A3_NOME")
	ZZD->ZZD_PO			:= nPoG						// Po
	ZZD->ZZD_ATIVI		:= aCliente[2]				// Atividade do cliente
	ZZD->ZZD_ATIVG		:= aCliente[3]				// Atividade 'real' do cliente
	ZZD->ZZD_FRBR		:= IIF(SF2->F2_YVALFRE > 0,SF2->F2_YVALFRE,SF2->F2_FRETE)	// Frete bruto
	ZZD->ZZD_FRBRUN		:= nFrbUn					// Frete bruto unitario (Gerencial)
	ZZD->ZZD_TPFRE		:= SF2->F2_YFRETE			// Tipo de frete
	ZZD->ZZD_KM			:= SF2->F2_YDIST			// Distancia da Matriz ao cliente em Km
	ZZD->ZZD_KMR		:= 0						// Raio em Km -- ??
	ZZD->ZZD_TRANS		:= SF2->F2_TRANSP			// Transportadora

	IF SF2->F2_YLIQUI = 0  // Liquido a pagar via RPA -- Inserido por Gustavo Hand Strey em 04/02/2011
		ZZD->ZZD_NOMTRA		:= POSICIONE("SA2",1,XFILIAL("SA2")+SF2->F2_TRANSP,"A2_NOME")			// Transportadora
	ELSE
		ZZD->ZZD_NOMTRA		:= 'PESSOA FISICA'
	ENDIF
	ZZD->ZZD_CARRE		:= SF2->F2_YPLCAR			// Placa da carreta
	ZZD->ZZD_CARRO		:= SF2->F2_YPLACA			// Placa do veiculo
	ZZD->ZZD_MOTOR      := SF2->F2_YMOTOR			// Motorista
	ZZD->ZZD_PREF		:= cPrefixo					// Prefixo padrao do parametro conforme a filial atual
	ZZD->ZZD_YTPCAR		:= cTipCar					// Tipo de Carga
	ZZD->ZZD_YDEV		:= SF2->F2_YDEV				// Tipo da Nota "S"-Substituta ou "C"-Cancelada
	ZZD->ZZD_YNFSUB		:= SF2->F2_YORIG			// NF de substituicao
	ZZD->ZZD_TES		:= aNota[5]					// TES em SD2
	ZZD->ZZD_TEMPO		:= cTempo					// Tempo entre entrada na balanca e saida do faturamento
	ZZD->ZZD_CPO1		:= cCampo1					// Grupo
	ZZD->ZZD_CPO2		:= cCampo2					// Segmento
	ZZD->ZZD_CPO3		:= cCampo3					// Empresas
	ZZD->ZZD_CPO4		:= cCampo4					// Regional
	ZZD->ZZD_CPO5		:= cCampo5					// Filial
	ZZD->ZZD_CPO7		:= cDescCarga				// Embalagem
	ZZD->ZZD_CPO8		:= cAtividade				// Atividade
	ZZD->ZZD_CPO12		:= cDescRegiao				// Regiao de Entrega

	//// Devolucao do VALOR de CDC
	If (Alltrim(cTipCar) == "CDC") .OR. (Alltrim(cTipCar) == "G3")
		If AllTrim(aNota[5]) $ (GetMV('MV_CDCTES1'))  // TES Usado para devoluçao do valor de CDC com o mesmo valor da NF Gerencial
			ZZD->ZZD_DEVCDC		:= nTotNFG
		ElseIf AllTrim(aNota[5]) $ GetMV('MV_CDCTES2') // TES Usado para devoluçao do valor de CDC com a diferenc entre NF GERENCIAL E NF
			ZZD->ZZD_DEVCDC		:=  nTotNFG - nTotNF
		Endif
	Endif

	Do Case											// KM Faixa
		Case SF2->F2_YDIST >= 0  .And. SF2->F2_YDIST <= 300
		ZZD->ZZD_CPO16:= 'de   0 a 300 km'
		Case SF2->F2_YDIST > 300 .And. SF2->F2_YDIST <= 450
		ZZD->ZZD_CPO16:= 'de 301 a 450 km'
		Case SF2->F2_YDIST > 450 .And. SF2->F2_YDIST <= 600
		ZZD->ZZD_CPO16:= 'de 451 a 600 km'
		Case SF2->F2_YDIST > 600 .And. SF2->F2_YDIST <= 900
		ZZD->ZZD_CPO16:= 'de 601 a 900 km'
		Case SF2->F2_YDIST > 900 .And. SF2->F2_YDIST <= 1200
		ZZD->ZZD_CPO16:= 'de 900 a 1200km'
		Case SF2->F2_YDIST > 1200
		ZZD->ZZD_CPO16:= 'acima de 1200km'
	EndCase

	ZZD->ZZD_CPO17		:= If(Empty(SF2->F2_TRANSP),'N/CADASTRADO',SF2->F2_TRANSP)  // Transportadora
	ZZD->ZZD_CPO20		:= If(SF2->F2_YFRETE=='C',"CIF","FOB")	// Tipo de Frete
	ZZD->ZZD_CPO21		:= If(Empty(cTes),'N/CADASTRADO',cTes)	// Tes
	ZZD->ZZD_CPO22		:= aCliente[4]				            // Data primeiro faturamento
	ZZD->ZZD_CPO23      := aPedido[9]
	ZZD->ZZD_VLR4		:= nCusTran  //nValor4                  // Custo de transferencia
	ZZD->ZZD_VLR16		:= aPedido[11]				                            // Peso Saida da Ordem de Carregamento - Marciane pediu em 11/07/05
	ZZD->ZZD_VLR17		:= If(aProduto[6]=="SC",aOrdem[3]*aProduto[7],aOrdem[3])// Peso NF
	ZZD->ZZD_YDIAST	    := aOrdem[5]-IIf(Empty(aOrdem[9]),aOrdem[5],aOrdem[9])   // Z8_DTSAIDA - Z1_YDTLIB
	ZZD->ZZD_YHORAT     := ElapTime(aOrdem[10]+":00",aOrdem[8]+":00") // Z1_HLIB + Hora da Saida (Z8_HSAIDA)
	ZZD->ZZD_YOC        := aOrdem[6]
	If Val(Subs(ZZD->ZZD_YHORAT,1,2)) > 0 .or. Val(Subs(ZZD->ZZD_YHORAT,4,2)) > 0
		ZZD->ZZD_YTOTDT  := ((ZZD->ZZD_YDIAST*24)+Val(Subs(ZZD->ZZD_YHORAT,1,2)))/24
	Else
		ZZD->ZZD_YTOTDT  := 0
	Endif

	ZZD->ZZD_TPROD   := SF2->F2_VALMERC
	ZZD->ZZD_TPRODG := IIf( ZZD->ZZD_TOTNFG > 0, nProdG, 0 )

	If aProduto[6]$("SA/SC")
		ZZD->ZZD_YPESAC	:= aProduto[7]
	EndIf

	ZZE->(DbSetOrder(1))
	ZZE->(DbSeek(xFilial("ZZE")+dtos(SF2->F2_EMISSAO)))
	ZZD->ZZD_YDUTIL	:= ZZE->ZZE_DUTIL
	ZZD->ZZD_YDCORR	:= ZZE->ZZE_DCORR
	ZZD->ZZD_CODEMP	:= cEmpAnt
	ZZD->ZZD_CODFIL	:= cFilAnt
	ZZD->ZZD_NOMFIL := POSICIONE("SM0",1,cEmpAnt+cFilAnt,"M0_FILIAL")

	cSigla := Space(7)

	If SM0->M0_CODIGO == "01"
		cSigla := "01-MZVI"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0201"
		cSigla := "01-MZAE"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0203"
		cSigla := "03-MZMN"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0208"
		cSigla := "08-MZFT"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0210"
		cSigla := "10-MZBA"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0211"
		cSigla := "11-MZPQ"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0213"
		cSigla := "13-MZPA"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0214"
		cSigla := "14-MZAJ"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0215"
		cSigla := "15-MZEU"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0216"
		cSigla := "16-MZIB"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0218"
		cSigla := "18-MZVI"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0220"
		cSigla := "20-MZGV"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0221"
		cSigla := "21-MZCP"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0222"
		cSigla := "22-MZCF"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0223"
		cSigla := "23-MZAB"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0225"
		cSigla := "25-MZDQ"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0226"
		cSigla := "26-MZMO"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0231"
		cSigla := "31-MZST"
	ElseIf SM0->M0_CODIGO == "10"
		cSigla := "10-MZMO"
	ElseIf SM0->M0_CODIGO == "11"
		cSigla := "11-MZPA"
	ElseIf SM0->M0_CODIGO == "12"
		cSigla := "12-MZIB"
	ElseIf SM0->M0_CODIGO == "20"
		cSigla := "20-MZAB"
	ElseIf SM0->M0_CODIGO == "30"
		cSigla := "30-MZBA"
	ElseIf SM0->M0_CODIGO == "40"
		cSigla := "40-MZMN"
	ElseIf SM0->M0_CODIGO == "50"
		cSigla := "50-IBEC"
	Endif
	//-------------------------------------------------

	if UPPER(alltrim(funname()))=='REPROZZD' .AND. left(cSigla,2) <> cEmpAnt  .and. valType(aLogErr)=='A' //.and. !MsgBox("O conteudo do parametro MV_SIGLAMZ, nao correponde a esta empresa! Continuar gravacao ?","Atencao","YESNO")
		aAdd(aLogErr, "O conteudo do parametro MV_SIGLAMZ, nao correponde a esta empresa!" )
	endif

	ZZD->ZZD_SIGLA  := substr(cSigla,4,4)
	ZZD->ZZD_MASSAG	:= nQtdeGra * nPOG
	nPO := Round((nTotNF - SF2->F2_VALIPI - SF2->F2_VALICM - SF2->F2_ICMSRET - nPisco - nFrtTot - SF2->F2_YPEDAG) / nQtdeGra,2)
	nPO -= If(cTipCar = "S",nCustSac,0)
	ZZD->ZZD_MASSA  := nQtdeGra * nPO
	ZZD->ZZD_CUSTO	:= aNota[9]
	ZZD->ZZD_MARGEM	:= Round((nTotNF - SF2->F2_VALIPI - SF2->F2_VALICM - SF2->F2_ICMSRET - nPisco - ZZD->ZZD_FreTot - SF2->F2_YPEDAG) / nQtdeGra,2)    - aNota[9]	   // Margem de Lucro
	ZZD->ZZD_MARGEG	:= Round((nTotNFG - nIpiG - nIcmsG - nIcmsRetG - nPiscoG - ZZD->ZZD_FreTot - SF2->F2_YPEDAG) / nQtdeGra,2)   -  aNota[9]	   // Margem de Lucro

	nPO := Round((nTotNFG - nIpiG - nIcmsG - nIcmsRetG - nPiscoG - nFrtTot - SF2->F2_YPEDAG) / nQtdeGra,2)
	nPO -= If(cTipCar = "S",nCustSac,0)
	ZZD->ZZD_YPEDAG := SF2->F2_YPEDAG
	ZZD->ZZD_YCTR  	:= SF2->F2_YCTR
	ZZD->ZZD_YSERCT := SF2->F2_YSERCTR
	ZZD->ZZD_IRCSL  := IF(ZZD->ZZD_MARGEM > 0 ,(nQtdeGra * ZZD->ZZD_MARGEM * wPIRCSL),0)
	ZZD->ZZD_IRCSLG := IF(ZZD->ZZD_MARGEG > 0 ,(nQtdeGra * ZZD->ZZD_MARGEG * wPIRCSL),0)
	aZZD				:= GetArea("ZZD")

	// CALCULO DA DEVOLUCAO DE CDC
	If (Alltrim(cTipCar) == "CDC") .OR. (Alltrim(cTipCar) == "G3")
		ZZD->ZZD_DEICDC	:= (((ZZD->ZZD_IPIG + ZZD->ZZD_ICMSG + ZZD->ZZD_RETG + ZZD->ZZD_PISCOG) - (ZZD->ZZD_IPI + ZZD->ZZD_ICMS + ZZD->ZZD_RET + ZZD->ZZD_PISCO))-(((ZZD->ZZD_TOTNFG - SF2->F2_VALBRUT) * 0.01) +IIF(cTES $ "612#512#509" ,((ZZD->ZZD_TOTNFG - SF2->F2_VALBRUT) * (nAlqPisGer+nAlqCofGer)),(ZZD->ZZD_TOTNFG * (nAlqPisGer+nAlqCofGer)))))/2
	Endif

	If Alltrim(cTipCar) $ "CDC*G"
		ZZD->ZZD_PERFIL := "GRANEL"
	ELSEIF cTipCar = "S"
		ZZD->ZZD_PERFIL := "SACOS"
	Endif

	if len (aCliente) >= 8
		//	ZZD->ZZD_CLASVC := TABELA("Z6",aCliente[8]) //TIPO DE CLIENTE PARA A VOTORANTIN,
	endif
	ZZD->ZZD_CFOP := aNota[13]       //COGIGO FISCAL DA NF
	ZZD->ZZD_TIPONF := SF2->F2_TIPO
	ZZD->ZZD_TIPOMT := aProduto[12]
	ZZD->ZZD_DESTES := cDESTES[2] // INCLUIDO POR GUSTAVO EM 25/03/2009
	ZZD->ZZD_TIPCAR := POSICIONE("SZ7",4,XFILIAL("SZ7")+PADR(SF2->F2_DOC,9)+SF2->F2_SERIE,"Z7_YPM")
	ZZD->ZZD_QTCIF  := IIF(ZZD->ZZD_FRETOT>0,ZZD->ZZD_QTGRA,0)
	ZZD->ZZD_MARTOT := (ZZD->ZZD_MARGEG*ZZD->ZZD_QTGRA)+ZZD->ZZD_DEICDC
	ZZD->ZZD_FRE3   := nFRE3Tot
	ZZD->ZZD_FRE3U  := nFRE3Un
	ZZD->ZZD_YMUN   := SA1->A1_MUN
	//ZZD->ZZD_YEST   := SA1->A1_EST
	ZZD->ZZD_YEST   := aCliente[5]    // Marcus Vinicius - 16/11/16 - Adicionado para pegar de acordo com o filtro utilizado na função PesqSA1

	IF ZZD->(FieldPos("ZZD_NREDUZ")) > 0
		ZZD->ZZD_NREDUZ:= SA1->A1_NREDUZ
	ENDIF

	IF ZZD->(FieldPos("ZZD_UFFATU")) > 0
		ZZD->ZZD_UFFATU := SM0->M0_ESTCOB
	ENDIF

	IF SF2->F2_TIPO <> 'D'
		//ZZD->ZZD_GRPVEN  := POSICIONE("SA1",1,XFILIAL("SA1")+SF2->F2_CLIENTE,"A1_GRPVEN")
		ZZD->ZZD_GRPVEN := aCliente[7]
		ZZD->ZZD_YDGRUP  := POSICIONE("ACY",1,XFILIAL("ACY")+ZZD->ZZD_GRPVEN,"ACY_DESCRI")
	ENDIF

	ZZD->ZZD_PISNF  := nPisNF
	ZZD->ZZD_COFNF  := nCOFNF
	ZZD->ZZD_PISGER := nPISGER
	ZZD->ZZD_COFGER := nCOFGER

	//sergio(semar) - 26/10/2016
	if zzd->(fieldpos("ZZD_DSMESO"))>0
		ZZD->ZZD_DSREGI 		:= aCliente[10]				// regiao da meso
		ZZD->ZZD_DSMESO 		:= aCliente[11]				// mesoregiao
		ZZD->ZZD_DSMICR  		:= aCliente[12]				// microregiao
	endif

	IF ZZD->(FieldPos("ZZD_GRPPRC")) > 0
		ZZD->ZZD_GRPPRC := aProduto[14]
	Endif

	DbSelectArea("ZZD")
	MsUnlock()
	RestArea(aZZD)

Return 'fim'




Static Function fPesqSA1()

	DbSelectArea("SA1")
	aArea := GetArea()
	DbSetOrder(1)
	If DbSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA)
		Private aCliente:= {}
		Private cPriCom:= Substr(DTOS(SA1->A1_PRICOM),5,2)+"/"+Substr(DTOS(SA1->A1_PRICOM),1,4)
		aAdd(aCliente, SA1->A1_NOME) 		// 1 Nome
		aAdd(aCliente, SA1->A1_ATIVIDA) 	// 2 Atividade
		aAdd(aCliente, SA1->A1_YATIVID)	// 3 Atividade "real"
		aAdd(aCliente, cPriCom)				// 4 Data do primeiro faturamento
		aAdd(aCliente, SA1->A1_EST)	   // 5 Estado
		aAdd(aCliente, SA1->A1_YFICMS)	// 6 Frete base ICM
		aAdd(aCliente, SA1->A1_GRPVEN)	// 7 Grupo de Venda
		aAdd(aCliente, SA1->A1_YCLASVC)  // 8 cliente votoran
		aAdd(aCliente, SA1->A1_MUN)  // 9 municipio do cadastro do cliente

		//sergio(SEMAR)  - 26/10/2016
		aAdd(aCliente, UPPER(POSICIONE('SX5', 1,xFilial('SX5') +'A2'+SA1->A1_YREGIA, "X5_DESCRI")))	// 10 regiao da meso
		aAdd(aCliente, UPPER(POSICIONE('SX5', 1,xFilial('SX5') +'C1'+SA1->A1_YMESCR, "X5_DESCRI"))) // 11 mesoregiao
		aAdd(aCliente, UPPER(POSICIONE('SX5', 1,xFilial('SX5') +'C2'+SA1->A1_YMICRE, "X5_DESCRI"))) // 12 microregiao

		// Marcus Vinicius - 23/11/2016
		aAdd(aCliente, SA1->A1_GRPTRIB)  // 13 Grupo tibutário do cliente na excessão fiscal

		RestArea(aArea)
	Else
		DbSelectArea("SA2")
		aArea := GetArea()
		DbSetOrder(1)
		If DbSeek(xFilial("SA2") + SF2->F2_CLIENTE + SF2->F2_LOJA)
			Private aCliente:= {}
			Private cPriCom:= Substr(DTOS(SA2->A2_PRICOM),5,2)+"/"+Substr(DTOS(SA2->A2_PRICOM),1,4)
			aAdd(aCliente, SA2->A2_NOME) 		// 1 Nome
			aAdd(aCliente, SA2->A2_ATIVIDA) 	// 2 Atividade
			aAdd(aCliente, "")		// 3 Atividade "real"
			aAdd(aCliente, cPriCom)				// 4 Data do primeiro faturamento
			aAdd(aCliente, SA2->A2_EST)	// 5 Estado
			aAdd(aCliente, "N")	// 6 Frete base ICM
			aAdd(aCliente, "")
			RestArea(aArea)
		EndIf
	EndIf

Return aCliente


Static Function fPesqSB1()
	DbSelectArea("SB1")
	aArea := GetArea()
	DbSetOrder(1)
	DbSeek(xFilial('SB1') + aNota[1])
	Private aProduto:= {}
	aAdd(aProduto, iif( (SB1->B1_TIPO $ "PA*MP*EM") .AND. SB1->B1_YFAT =='S' ,.T.,.F.))   // 1 Produto Acabado?
	aAdd(aProduto, SB1->B1_TIPO)					   // 2 Tipo de produto
	aAdd(aProduto, SB1->B1_PRV1)					   // 3 Preco de venda
	IF (SF2->F2_DOC+SF2->F2_SERIE == '0116231  '  .AND. SF2->F2_CLIENTE+SF2->F2_LOJA == '000007501' ) .OR.;
	(SF2->F2_DOC+SF2->F2_SERIE == '0122651  '  .AND. SF2->F2_CLIENTE+SF2->F2_LOJA == '000007001' )
		aAdd(aProduto, 'CDC') 					   // Solicitado por Marciane devido a lancamento excepcional em Mogi
	ELSE
		aAdd(aProduto, alltrim(SB1->B1_TIPCAR)) 					   // 4 Tipo de carga
	ENDIF

	_cGrpPrc := ''
	If SF2->F2_EMISSAO <= ctod("01/06/05")
		dbSelectArea("SZI")
		dbSetOrder(1) //ZI_FILIAL+ZI_CLIENTE+ZI_LOJA+ZI_PRODUTO
		//	If dbSeek(xFilial("SZI")+cCliente+cLoja+aNota[1])
		If dbSeek(xFilial("SZI")+cCliente+cLoja+aNota[1]+"L") //Ajuste para buscar a tabela de preço "Liberada"
			aAdd(aProduto, SZI->ZI_PGER)			//5 Preco gerencial
			_cGrpPrc := SZI->ZI_YGRPPRC
		Else
			aAdd(aProduto, 0)						//5 Preco gerencial
		EndIf
	Else
		aAdd(aProduto, 0)						//5 Preco gerencial
	EndIf
	dbSelectArea("SB1")
	aAdd(aProduto, SB1->B1_UM)						//6 1a Unidade de Medida
	aAdd(aProduto, SB1->B1_CONV)					//7 Fator de Conversao
	aAdd(aProduto, LEFT(SB1->B1_DESC,20))			//8 Descricao
	aAdd(aProduto, LEFT(SB1->B1_YDESCRE,20))		//9 Descricao Resumida

	cQuery:= "SELECT * FROM "+RETSQLNAME('ZZG')+" WHERE  ZZG_GRUPO = '"+SB1->B1_GRUPO+"' AND ZZG_COD = '"+SB1->B1_SUBGRUP+"' AND D_E_L_E_T_  <> '*' "

	If Select('TRB')>0
		dbSelectArea("TRB")
		DbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "TRB"

	aAdd(aProduto, Posicione('SBM',1,xFilial('SBM')+SB1->B1_GRUPO,'BM_DESC')  )        // 10 Descricao do Grupo
	aAdd(aProduto, Alltrim(TRB->ZZG_DESC))	// 11 Descricao do SubGrupo
	aAdd(aProduto, Alltrim(SB1->B1_TIPO))   // 12 TIPO DA NF

	// Marcus Vinicius - 23/11/2016
	aAdd(aProduto, SB1->B1_GRTRIB)  // 13 Grupo tibutário do produto na excessão fiscal

	aAdd(aProduto, _cGrpPrc)  // 14 Grupo Preço

	RestArea(aArea)

Return aProduto




// PESQUISA "MODELOS DE CARGA" - DB0
STATIC Function fPesqDB0()
	DbSelectArea("DB0")
	aArea := GetArea()
	DbSetOrder(1)
	DbSeek(xFilial('DB0') + cTipCar)
	cResposta:= DB0->DB0_DESMOD
	RestArea(aArea)
Return cResposta

// PESQUISA "CONTAS A RECEBER" - SE1
Static Function fPesqSE1(cChave)
	DbSelectArea("SE1")
	aArea := GetArea()
	DbSetOrder(2)
	DbSeek(cChave)
	Private aCReceb:= {}
	aAdd(aCReceb, SE1->E1_VENCREA)	// 1 Vencimento\
	RestArea(aArea)
Return aCReceb

// PESQUISA "PEDIDOS FATURADOS" - SZ7
Static Function fPesqSZ7()
	DbSelectArea("SZ7")
	aArea := GetArea()
	DbSetOrder(4)
	If DbSeek(xFilial("SZ7") + SF2->F2_DOC + SF2->F2_SERIE)
		Private aPedido:= {}
		aAdd(aPedido, SZ7->Z7_PRODUTO)		// 1  Codigo produto
		aAdd(aPedido, SZ7->Z7_PCOREF)		// 2  Valor da nota
		aAdd(aPedido, SZ7->Z7_QUANT)		// 3  Quantidade entregue
		aAdd(aPedido, SZ7->Z7_PLACA)		// 4  Placa do veiculo motor
		aAdd(aPedido, SZ7->Z7_TES)       	// 5  TES
		aAdd(aPedido, SZ7->Z7_HORENT)     	// 6  Hora entrada
		aAdd(aPedido, SZ7->Z7_HORSAI)     	// 7  Hora saida
		aAdd(aPedido, SZ7->Z7_PSENT)		// 8  Peso Real
		aAdd(aPedido, SZ7->Z7_YPM)			// 9  Tipo carregamento
		aAdd(aPedido, SZ7->Z7_QUANT)    	// 10 Quantidade
		aAdd(aPedido, SZ7->Z7_PSSAI)    	// 11 Peso de saida
		aAdd(aPedido, SZ7->Z7_YDTLIB)    	// 12 Data da Liberacao
	Else
		DbSelectArea("SZ7")
		DbSetOrder(9)
		DbSeek(xFilial("SZ7") + SF2->F2_DOC )
		Private aPedido:= {}
		aAdd(aPedido, SZ7->Z7_PRODUTO)		// 1  Codigo produto
		aAdd(aPedido, SZ7->Z7_PCOREF)		// 2  Valor da nota
		aAdd(aPedido, SZ7->Z7_QUANT)		// 3  Quantidade entregue
		aAdd(aPedido, SZ7->Z7_PLACA)		// 4  Placa do veiculo motor
		aAdd(aPedido, SZ7->Z7_TES)       	// 5  TES
		aAdd(aPedido, SZ7->Z7_HORENT)     	// 6  Hora entrada
		aAdd(aPedido, SZ7->Z7_HORSAI)     	// 7  Hora saida
		aAdd(aPedido, SZ7->Z7_PSENT)		// 8  Peso Real
		aAdd(aPedido, SZ7->Z7_YPM)			// 9  Tipo carregamento
		aAdd(aPedido, SZ7->Z7_QUANT)    	// 10 Quantidade
		aAdd(aPedido, SZ7->Z7_PSSAI)    	// 11 Peso de saida
		aAdd(aPedido, SZ7->Z7_YDTLIB)    	// 12 Data da Liberacao
	Endif
	RestArea(aArea)
Return aPedido


Static Function fPesqSD2()

	DbSelectArea("SD2")
	aArea := GetArea()
	DbSetOrder(3)
	DbSeek(xFilial('SD2') + SF2->F2_DOC + SF2->F2_SERIE)

	Private aNota:= {}

	aAdd(aNota, SD2->D2_COD)		// 1 Codigo produto
	aAdd(aNota, SD2->D2_PRCVEN)		// 2 Preco unitario
	aAdd(aNota, SD2->D2_QUANT)		// 3 Quantidade na nota
	aAdd(aNota, "")					// 4 Placa
	aAdd(aNota, SD2->D2_TES)		// 5 TES
	aAdd(aNota, SD2->D2_PICM)		// 6 Aliquota ICMS
	aAdd(aNota, SD2->D2_YCUSTRA)	// 7 Custo de transferencia (unitario)
	aAdd(aNota, SD2->D2_YPRG)    	// 8 Preco Gerencial
	aAdd(aNota, SD2->D2_YCUSTO)		// 9 Custo (R$/T)
	aAdd(aNota, SD2->D2_YCSTSAC)	// 10 Custo Sacaria
	aAdd(aNota, SD2->D2_VALIMP6)	// 11 PIS
	aAdd(aNota, SD2->D2_VALIMP5)	// 12 COFINS
	aAdd(aNota, SD2->D2_CF)			// 13 CFOP
	aAdd(aNota, SD2->D2_IPI)		// 14 Aliquota IPI
	aAdd(aNota, SD2->D2_ALQIMP6)	// 15 Aliquota PIS
	aAdd(aNota, SD2->D2_ALQIMP5)	// 16 Aliquota COFINS
	///  INCLUIDO EM 13/09/17
	aAdd(aNota, SD2->D2_ICMSCOM)	// 17 Partilha do ICMS - Estado Origem
	aAdd(aNota, SD2->D2_DIFAL)	    // 18 Partilha do ICMS - Estado Destino

	RestArea(aArea)

Return aNota

Static Function fAlqPisCOfGer(nAlqPisGer,nAlqCofGer)

	IF SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0203|4001" .AND. aProduto[4] $ "CDC"
		SF7->(dbSetOrder(3))
		If SF7->(dbSeek(xFilial("SF7") + aProduto[13] + aCliente[13] + aCliente[5]))
			nAlqPisGer	:= SF7->F7_ALIQPIS/100
			nAlqCofGer	:= SF7->F7_ALIQCOF/100
		EndIf
	EndIf

Return
// Até aqui

// PESQUISA "CONDICOES DE PAGAMENTO" - SE4
Static Function fPesqSE4()
	DbSelectArea("SE4")
	aArea := GetArea()
	DbSetOrder(1)
	//DbSeek(xFilial("SE2") + SF2->F2_COND)
	DbSeek(xFilial("SE4") + SF2->F2_COND) // Marcus Vinicius - 29/09/16 - Ajustado xfilial para consultar a tabela SE4
	Private nResposta:= SE4->E4_YMEDIA
	RestArea(aArea)
Return nResposta

// PESQUISA "TIPOS DE ENTRADA E SAIDA" - SF4
Static Function fPesqSF4()

	DbSelectArea("SF4")
	aArea := GetArea()
	DbSetOrder(1)
	DbSeek(xFilial('SF4') + aNota[5])
	cResposta:= SF4->F4_YINFEX
	Private cResposta2:= SF4->F4_TEXTO   // INCLUIDO POR GUSTAVO HAND STREY EM 25/03/2009
	RestArea(aArea)
Return ({cResposta,cResposta2})

// PESQUISA "PARAMETROS EXECPLAN" - ZZA
Static  Function fPesqZZA(cChave)

	DbSelectArea("ZZA")
	aArea := GetArea()
	DbSetOrder(1)
	DbSeek(cChave)
	Private cResposta:= ZZA->ZZA_CONTEU
	RestArea(aArea)
Return cResposta

// PESQUISA "CADASTRO DE TABELAS" - SX5
Static  Function fPesqSX5()

	DbSelectArea("SX5")
	aArea := GetArea()
	DbSetOrder(1)
	DbSeek(xFilial('SX5') + "YI"+ iif(!Empty(aCliente[3]),aCliente[3],aCliente[2]))
	Private cResposta:= SX5->X5_DESCRI
	RestArea(aArea)
Return cResposta

// PESQUISA "ORDEM DE CARREGAMENTO" - SZ8
Static  Function fPesqSZ8()

	DbSelectArea("SZ8")
	aArea := GetArea()
	DbSetOrder(1)
	DbSeek(xFilial('SZ8')+SF2->F2_YOC)
	Private aOrdem:= {}
	Private cTempo:= "  :  "
	If SZ8->Z8_HORPES <> cTempo .And. SZ8->Z8_HSAIDA <> cTempo
		cTempo:= ElapTime(SZ8->Z8_HORPES+":00",SZ8->Z8_HSAIDA+":00")
	Else
		cTempo:= "00:00"
	EndIf
	aAdd(aOrdem, cTempo) 			// 1 Tempo decorrido entre a hora do peso e a hora da saida do caminhao
	aAdd(aOrdem, SZ8->Z8_PSSAI)		// 2 Peso de saida do caminhao
	aAdd(aOrdem, SZ8->Z8_QUANT)     // 3 Quantidade da Orderm de Carregamento
	aAdd(aOrdem, SZ8->Z8_YDTLIB)    // 4 Data Liberacao
	aAdd(aOrdem, SZ8->Z8_DTSAIDA)   // 5 Data Saida
	aAdd(aOrdem, SZ8->Z8_OC)        // 6 Numero da Ordem de Carregamento
	aAdd(aOrdem, SZ8->Z8_HORPES)    // 7 Hora da Pesagem
	aAdd(aOrdem, SZ8->Z8_HSAIDA)    // 8 Hora da Saida

	dbSelectArea("SZ1")
	aAdd(aOrdem, SZ1->Z1_YDTLIB) // 9 Data Liberacao Pedido
	aAdd(aOrdem, SZ1->Z1_HLIB) // 10 Hora Liberação Pedido
	DbSelectArea("SZ8")

	RestArea(aArea)
Return aOrdem

// PESQUISA "CADASTRO DE REGIOES" - SZO
Static  Function fPesqSZO()

	DbSelectArea("SZO")
	aArea := GetArea()
	DbSetOrder(1)
	DbSeek(xFilial('SZO') + cRegiao)
	Private cResposta:= SZO->ZO_DESC
	RestArea(aArea)
Return cResposta

// PESQUISA "TABELA DE ESTADOS/CIDADES" - SZ4
Static  Function fPesqSZ4()
	DbSelectArea("SZ4")
	aArea := GetArea()
	DbSetOrder(1)
	DbSeek(SF2->F2_FILIAL + SF2->F2_EST + SF2->F2_YMUNE)
	Private cResposta:= SZ4->Z4_REGIAO
	RestArea(aArea)
Return cResposta

Static  Function fCalcPoG(cTipCar, nTotNFG, nIpig, nIcmsg, nPiscoG, nFrtTot, nQtdeGra, nCustSac, nIRCSLG, nCusTran)

	Private nCalcPoG:= 0

	nCalcPoG:= (nTotNFG - nIpiG - nIcmsG - nIcmsRetG - nPiscoG - nFrtTot - SF2->F2_YPEDAG )/nQtdeGra
	//if cFilAnt <> '01'
	//nCalcPoG -= If(cTipCar = "S",nCusTran,0)
	//nCalcPoG -= If(cTipCar = "S",49,0)
	//endif
	nCalcPoG:= iif( nCalcPoG <0 , 0 , nCalcPoG )

Return Round(nCalcPoG,2)


User function setLogErr(aLinha)

	local warea:= getArea()
	local cArqDest:= ''
	local chrFim := chr(13)+chr(10)

	carqDest:=  '\cfglog\zzd_erros.txt'

	_nHD := fCreate(cArqDest)
	If _nHD == -1
		MsgAlert("Erro na criacao de "+cFile)
		return
	Endif

	if len(aLinha)>0
		For jx:=1 To Len(aLinha)
			_cLinha := aLinha[jx]  + chrFim
			If fWrite(_nHd,_cLinha,Len(_cLinha)) <> Len(_cLinha)
				MsgAlert("Erro durante a gravacao registro "+_cArqDest+" -> "+StrZero(recno()))
				Return
			Endif
		Next

		If !FClose(_nHD)
			MsgAlert("Erro no fechamento do arquivo "+_cArqDest)
		Endif
	Endif

	restarea(warea)
return




Static Function GeraMovE()

	SF1->(dbSetOrder(1))
	If SF1->(dbSeek(xFilial("SF1")+cDoc+cSERIE+cCliente+cLoja))

		SD1->(dbSetOrder(1))
		If SD1->(dbSeek(xFilial("SD1")+ SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))

			SD2->(dbSetOrder(3))
			If SD2->(!dbSeek(xFilial("SD2")+SD1->D1_NFORI + SD1->D1_SERIORI + SD1->D1_FORNECE + SD1->D1_LOJA))
				Return
			Endif

			SF2->(dbSetOrder(1))
			SF2->(dbSeek(xFilial("SF2")+SD2->D2_DOC + SD2->D2_SERIE   + SD2->D2_CLIENTE + SD2->D2_LOJA))

		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Buscar produto no pedido                  								 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SZ7")
	DbSetOrder(4)

	xDoc:= left(SF2->F2_DOC,9)

	If !DbSeek(xFilial("SZ7") + xDoc + SF2->F2_SERIE)
		DbSeek(xFilial("SZ7") + xDoc )
	EndIf

	if UPPER(alltrim(funname()))=='REPROZZD' .AND. empty(sz7->(z7_filial+z7_numnf+z7_serie) )  .and. valtype(aLogErr)=='A' //.and. !MsgBox("Documento nao localizado em PEDIDOS FATURADOS(SZ7) ! [ "+xFilial("SZ7") +'/'+ SF2->F2_DOC +'/'+ SF2->F2_SERIE+" ] Continuar gravacao ?","Atencao","YESNO")
		aAdd(aLogErr, "Documento nao localizado em PEDIDOS FATURADOS(SZ7) ! [ Filial:"+xFilial("SZ7") +'/ Doc: '+ xDoc +'/ Serie: '+ SF2->F2_SERIE+" ]" )
	endif


	SB1->(DbSeek(xFilial("SB1")+SZ7->Z7_PRODUTO))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private nPrecoUn		:= 0
	Private nTotNF			:= 0
	Private nTotNFG			:= 0
	Private nIpiG			:= 0
	Private nFrbUn			:= 0
	Private nIcmsG			:= 0
	Private nPisco			:= 0
	Private nPiscoG			:= 0
	Private nFrtUni			:= 0
	Private nFrtTot			:= 0
	Private nPoG			:= 0
	Private nPo 			:= 0
	Private wOrdSZ1			:= 0
	Private wRecSZ1			:= 0
	Private aOrdem			:= fPesqSZ8()
	Private cTempo			:= aOrdem[1]
	Private aCliente		:= fPesqSA1()
	Private naliqext := 0     // Incluido conf. solicitacao por Marciane em 01/11/05
	Private _esticm	 := alltrim(getmv("MV_ESTICM"))
	Private _estado  := GetMV("MV_ESTADO")
	Private _picmest:= Val(Subs(_esticm,at(_estado,_esticm)+2,2))
	Private naliqext := 0
	Private ndifaliq := 0
	Private wPIRCSL := GETMV("MV_YIRCSSL") / 100
	Private nBaseIcmsG := 0
	Private aNota			:=  fPesqSD2()
	Private nCusTran		:= aNota[7]
	Private nCustSac		:= aNota[10]
	Private aProduto		:=  fPesqSB1()
	Private nQtdeEns		:= iif(aProduto[6]='SC',aNota[3],0)
	Private cTipCar			:= aProduto[4]
	Private cDescCarga		:=  fPesqDB0() // Descricao do tipo de carga - DB0_DESMOD
	Private nQtdeGra		:= Round(If(aProduto[6]$("SA/SC"),aNota[3]/(1000/aProduto[7]),aNota[3]),2)
	Private cPrefixo		:= "FAT"
	Private aPedido			:=  fPesqSZ7()
	Private cCampo1			:=  fPesqZZA(xFilial('ZZA') + "01             ")
	Private cCampo2			:=  fPesqZZA(xFilial('ZZA') + "02             ")
	Private cCampo3			:=  fPesqZZA(xFilial('ZZA') + "03             ")
	Private cCampo4			:=  fPesqZZA(xFilial('ZZA') + "04             ")
	Private cCampo5			:=  fPesqZZA(xFilial('ZZA') + "05             ")
	Private aCReceb 		:=  fPesqSE1(xFilial('SE1') + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_SERIE + SF2->F2_DOC)
	Private nValor14		:=  fPesqSE4()
	Private nValor16		:=  aPedido[8]  // Peso real
	Private nValor17		:=  aPedido[10] // Peso NF
	Private cTes			:=  aNota[5]
	Private cAtividade		:=  fPesqSX5() // Busca a partir da Atividade Gerencial SX5('YI') Se Ativ.Real nao preenchida, entao retornara Atividade
	Private cRegiao			:=  fPesqSZ4()
	Private cDescRegiao		:=  fPesqSZO() // Cadastro de Regioes ZO_DESC
	Private wTES			:= ""
	Private nICMSRetG		:= 0
	Private nProdG			:= 0

	if xFilial("SF2")<>"98"
		cPrefixo := AllTrim(Getmv("MV_YPREF")) 	// Traz o prefixo padrao do parametro conforme a filial atual
	EndIf
	Private nMedia			:=  fPesqSE4()
	Private nAliqICM		:= aNota[6]
	Private nFRE3Tot		:= 0 // Frete NF + Custo Transporte Total
	Private nFRE3Un			:= 0 // Frete NF + Custo Transporte Unitário
	Private	nPisNF          := 0 // PIS na NFS
	Private nCOFNF          := 0 // COFINS na NFS
	Private nPISGER         := 0 // PIS gerencial
	Private nCOFGER         := 0 // COFINS gerencial
	Private cDESTES			:= fPesqSF4() // Descrição da TES

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Continua apenas se o Tipo de Produto for "PA", Produto Acabado           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !aProduto[1]
		if UPPER(alltrim(funname()))=='REPROZZD' .AND. valType( aLogErr )=='A'
			aAdd(aLogErr, 'Produto nao e PA ! '+aproduto[8] )
		endif

		// Abandona o programa
		Return ('loop')
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe preco gerencial. Caso positivo, calcula o valor       ³
	//³ total da NF e baseia todos os calculos neste valor.                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	nTotNF	:= SF2->F2_VALBRUT
	nTotNFG	:= SF2->F2_VALBRUT
	If(aProduto[6]= "SA")
		nPrecoUn := Round(nTotNF / aNota[3],2)			// Valor bruto da nota / quantidade em sacos
	ElseIf (aProduto[6]= "SC")
		nPrecoUn := Round(nTotNF / nQtdeEns,2)			// Valor bruto da nota / quantidade em sacos
	ElseIf (aProduto[6]= "TL")
		nPrecoUn := Round(nTotNF / nQtdeGra,2)
	EndIf

	If SF2->F2_EMISSAO <= ctod("01/06/05")
		If aProduto[5] == 0 // Preco Gerencial nulo
		Else // Existe preco gerencial
			If (aProduto[6]= "SC")
				2 := aProduto[5] * nQtdeEns			// Preco gerencial * quantidade em tons
			ElseIf (aProduto[6]= "TL")
				nTotNFG := aProduto[5] * nQtdeGra			// Preco gerencial * quantidade em tons
			EndIf
		EndIf
	Else
		If aNota[8] == 0 // Preco Gerencial nulo
		Else // Existe preco gerencial
			If (aProduto[6]= "SC")
				nTotNFG := aNota[8] * nQtdeEns			    // Preco gerencial * quantidade em tons
			ElseIf (aProduto[6]= "TL")
				nTotNFG := aNota[8] * nQtdeGra			    // Preco gerencial * quantidade em tons
			EndIf
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicio formulas           												 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	naliqext := 12

	nD2Aliq :=  1+( ( _picmest - naliqext ) / 100 )

	If SF2->F2_ICMSRET > 0 .And. aNota[8] <> 0 //Preco Gerencial

		nProdG := ROUND(      ((nTotnfg  /  nDifAliq )    -   (If(SF2->F2_YVALFRE > 0,SF2->F2_YVALFRE,SF2->F2_FRETE) * 1.04) ) / 1.04 , 2 )

		nIcmsRetG :=  ( ( nProdG + If(SF2->F2_YVALFRE > 0,SF2->F2_YVALFRE,SF2->F2_FRETE) )  * 1.04) * ( ndifaliq  - 1 )

	Else // produto gerencial sem ICMS RETIDO
		nProdG := ROUND(  (nTotNFG  /  1.04 ) - If(SF2->F2_YVALFRE > 0,SF2->F2_YVALFRE,SF2->F2_FRETE),2 )
	EndIf

	// IPI Gerencial
	IF SF2->F2_EMISSAO >= ctod("01/04/09") .AND. SF2->F2_EMISSAO <= ctod("30/06/09")// REDUCAO DO IPI CONFORME LEI FEDERAL
		nIpiG:=0                                                                       // INCLUIDO POR GUSTAVO HAND STREY (09/04/09)
	ELSE

		if SF2->F2_VALIPI = 0
			nIpiG:= 0
		Else
			If SF2->F2_YVALFRE > 0
				nIpiG	:= Round((((nTotNFG - SF2->F2_YVALFRE*1.04)-nICMSRETG)/1.04+SF2->F2_YVALFRE)*0.04,2)
			Else
				nIpiG	:= Round((((nTotNFG - SF2->F2_FRETE*1.04)-nICMSRETG)/1.04+SF2->F2_FRETE)*0.04,2)
			EndIf
		EndIf
	EndIf

	If SF2->F2_YVALFRE > 0
		nFrbUn	:= iif(cTipCar='S',SF2->F2_YVALFRE / nQtdeEns, SF2->F2_YVALFRE / nQtdeGra)
	Else
		nFrbUn	:= iif(cTipCar='S',SF2->F2_FRETE / nQtdeEns, SF2->F2_FRETE / nQtdeGra)
	EndIf

	If SF2->F2_ICMSRET > 0 .And. aNota[8] <> 0 //Preco Gerencial
		naliqext := 12
		If SF2->F2_YVALFRE > 0
			nProduto := nTotNFG - ( 1.05 * SF2->F2_YVALFRE ) - ( 1.05 * nIpiG )
		Else
			nProduto := nTotNFG - ( 1.05 * SF2->F2_FRETE ) - ( 1.05 * nIpiG )
		EndIf
		nProduto := Round(nProduto / 1.05,2)
		ndifaliq := ( _picmest - naliqext ) / 100
		nIcmsRetG :=  ( nProduto + If(SF2->F2_YVALFRE > 0,SF2->F2_YVALFRE,SF2->F2_FRETE) + nIpiG ) * ndifaliq
		//nIcmsRetG := Round(( nBaseIcmsG * ndifaliq) / 100,2)
	EndIf

	If aNota[8] == 0 //Preco Gerencial
		nIcmsG	:= SF2->F2_VALICM
		nICMSRetG := SF2->F2_ICMSRET
		nIPIG    := SF2->F2_VALIPI
	Else
		If SF2->F2_YVALFRE > 0
			nBaseIcmsG := nTotNFG - SF2->F2_YVALFRE-iif(aCliente[2] $ ("1/2"),nIpiG,0) + If(aCliente[6] == "N",SF2->F2_YVALFRE,0)
			nIcmsG	:= Round((nTotNFG - SF2->F2_YVALFRE-iif(aCliente[2] $ ("1/2"),nIpiG,0)-nIcmsRetG) * (aNota[6] / 100) ,2)
		Else
			nBaseIcmsG := nTotNFG - SF2->F2_FRETE-iif(aCliente[2] $ ("1/2"),nIpiG,0) + If(aCliente[6] == "S",SF2->F2_FRETE,0)
			nIcmsG	:= Round((nBaseIcmsG-iif(aCliente[2] $ ("1/2"),nIpiG,0)-nIcmsRetG) * (aNota[6] / 100) ,2)
		EndIf
	EndIf

	nPisco	:= 0
	nPiscoG	:= 0

	nAlqPisGer := 0.0165
	nAlqCofGer := 0.0760


	//NÃO CALCULA O PISCO SE O PRODUTO OU O TES FOR DE BONIFICAÇÃO
	If AllTrim(aNota[1]) $ GetMV('MV_YBONIF') .Or. AllTrim(aNota[5]) $ GetMV('MV_YTESCEB')
		// Nao Calcula o nPISCO nem o nPISCOG quando for bonificacao
	Else
		If xFilial("SF2") <> "98"
			If !(cTES $ "621#523#521") // se nao for um dos TES expecificados ao lado
				nPisco  := aNota[11]+aNota[12]	//SF2->(F2_VALIMP5 + F2_VALIMP6) Não grava SF2. Somente SD2
				nPisNF  := aNota[11]
				nCOFNF  := aNota[12]
			EndIf

			//		nPiscoG	:= Round((nTotNFG - nIpiG - nIcmsRetG) * 0.0925,2)
			nPiscoG	:= Round((nTotNFG - nIpiG - nIcmsRetG) * (nAlqPisGer+nAlqCofGer),2)

		EndIf

		If aNota[8] == 0 //Preco Gerencial
			nPiscoG := nPisco
			nPISGER := nPisNF
			nCOFGER := nCOFNF
		Else// Marcus Vinicius - 23/11/16
			fAlqPisCOfGer(@nAlqPisGer,@nAlqCofGer)

			If SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0203|4001" .AND. aProduto[4] $ "CDC"
				nPiscoG	:= Round((nTotNFG - nIpiG - nIcmsRetG) * (nAlqPisGer+nAlqCofGer),2)
			EndIf

			nPISGER := Round((nTotNFG - nIpiG - nIcmsRetG) * nAlqPisGer,2)
			nCOFGER := Round((nTotNFG - nIpiG - nIcmsRetG) * nAlqCofGer,2)
			// Até Aqui

			//		nPISGER := Round((nTotNFG - nIpiG - nIcmsRetG) * 0.0760,2)
			//		nCOFGER := Round((nTotNFG - nIpiG - nIcmsRetG) * 0.0165,2)
		EndIf

	Endif

	nFrtUni:= nFrbUn
	If ! Empty(SF2->F2_TRANSP)
		If _estado == aCliente[5]  //Verifica o estado do cliente para definir o tipo da TES
			wTES  := GetMV("MV_YTESFRD") //TES Frete para Dentro do Estado
		Else
			wTES  := GetMV("MV_YTESFRF") //TES Frete para Fora do Estado
		EndIf
		If wTES <> "163"
			nFrtUni:= Round((nFrbUn * 0.88),4)
		EndIf
		//Alterado por Gustav em 26/06/06
		nFrtUni:= nFrtUni - Round((nFrbUn * 0.0925 ),4)
	EndIf

	nFrtUni	+= iif(cTipCar="S",nCusTran/(1000/aProduto[7]),nCusTran)

	If ! Empty(SF2->F2_TRANSP)
		nFrtUni := nFrtUni * IIf(POSICIONE("SA2",1,xFilial("SA2")+SF2->F2_TRANSP,"A2_YCOOPER" )== "S",1.03,1)
	EndIf

	if SF2->F2_YFRETE=='C' //CIF- O FRETE POR CONTA DA MIZU
		nFrtTot	:= Round(iif(cTipCar='S', nFrtUni * nQtdeEns, nFrtUni * nQtdeGra),4)
	endif

	nFrFixDifT	:= 0
	If aProduto[6]= "TL"
		nFrFixDifT	:= IIf (SF2->F2_FRFIXO	< nFrbUn , nFrbUn - SF2->F2_FRFIXO , SF2->F2_FRFIXO - nFrbUn)
	Endif


	nFrtUni+= nFrFixDifT //IIF( cTipCar='S', nFrFixDifT / nQtdeEns, nFrFixDifT / nQtdeGra)

	if SF2->F2_YFRETE=='C' //CIF- O FRETE POR CONTA DA MIZU
		nFrtTot	:= Round(iif(cTipCar='S', nFrtUni * nQtdeEns, nFrtUni * nQtdeGra),4)
	endif

	//Calculo Frete + Custo Transporte
	If SF2->F2_YVALFRE > 0
		nFRE3Un	:= iif(cTipCar='S',SF2->F2_YVALFRE / nQtdeEns, SF2->F2_YVALFRE / nQtdeGra)
	Else
		nFRE3Un	:= iif(cTipCar='S',SF2->F2_FRETE / nQtdeEns, SF2->F2_FRETE / nQtdeGra)
	EndIf
	nFRE3Un	 += iif(cTipCar="S",nCusTran/(1000/aProduto[7]),nCusTran)
	nFRE3Un  += Round( iif(cTipCar='S', SF2->F2_YPEDAG / nQtdeEns, SF2->F2_YPEDAG /  nQtdeGra) ,2)

	//soma diferenca entre frete da nota e frete fixo da tabela de estados e municipios
	nFRE3Un  += nFrFixDifT //Round( IIF( cTipCar='S', nFrFixDifT / nQtdeEns, nFrFixDifT / nQtdeGra)  ,2)

	if SF2->F2_YFRETE=='C' //CIF- O FRETE POR CONTA DA MIZU
		nFRE3Tot := Round( iif(cTipCar='S', nFRE3Un * nQtdeEns, nFRE3Un * nQtdeGra) ,2)
	endif

	//Calculo Imp. Renda e CSLL
	nMARGEG	:= Round((nTotNFG - nIpiG - nIcmsG - nIcmsRetG - nPiscoG - If(SF2->F2_YVALFRE > 0,SF2->F2_YVALFRE,SF2->F2_FRETE) - SF2->F2_YPEDAG) / nQtdeGra,2)   -  aNota[9]	   // Margem de Lucro
	nIRCSLG := IF(nMARGEG > 0 ,(nQtdeGra * nMARGEG * wPIRCSL),0)

	// Calculo do Po
	wwTotNFG:= 0
	wwTotNFG:= IIf( AllTrim(aNota[1]) $ GetMV('MV_YBONIF') .Or. AllTrim(aNota[5]) $ GetMV('MV_YTESCEB') , 0 , nTotNFG )
	// SERGIO
	nPoG	:=  fCalcPoG(cTipCar, wwTotNFG, nIpiG, nIcmsG, nPiscoG, nFrtTot, nQtdeGra, nCustSac,nIRCSLG, nCusTran)

	DbSelectArea("ZZD")
	DbSetOrder(8)
	aZZD				:= GetArea("ZZD")

	If dbSeek(xFilial("ZZD")+cEmpAnt+cFilAnt+SF1->F1_SERIE+SF1->F1_DOC)
		RecLock("ZZD",.f.)
	Else
		RecLock("ZZD",.t.)
	EndIf

	dbSelectArea("SF2")
	ZZD->ZZD_FILIAL		:= xFilial("ZZD") //SF2->F2_FILIAL
	ZZD->ZZD_EMIS		:= SF1->F1_DTDIGIT
	ZZD->ZZD_HRSAID		:= SF1->F1_HORA             // HORA DE SAIDA DA NF
	ZZD->ZZD_PROD		:= aNota[1]					// Cod. produto
	ZZD->ZZD_DESCPR		:= aProduto[8]				// Descricao do Produto
	ZZD->ZZD_DESCRE		:= aProduto[9]				// Descricao Resumida do Produto
	ZZD->ZZD_DESGR 		:= aProduto[10]				// Descricao do Produto
	ZZD->ZZD_DESSGR		:= aProduto[11]				// Descricao Resumida do Produto
	ZZD->ZZD_CLIE		:= SF2->F2_CLIENTE			// Cod. cliente
	ZZD->ZZD_LOJA		:= SF2->F2_LOJA				// Loja
	ZZD->ZZD_NOME		:= aCliente[1]				// Nome cliente
	ZZD->ZZD_SERIE		:= SF1->F1_SERIE			// Serie documento
	ZZD->ZZD_DOC		:= SF1->F1_DOC				// Num. documento
	ZZD->ZZD_QTENS		:= nQtdeEns * -1            // Quantidade ensacado
	ZZD->ZZD_QTGRA		:= nQtdeGra	* -1			// Quantidade granel
	ZZD->ZZD_PRECO		:= nPrecoUn	* -1				// Buscar no SD2

	If SF2->F2_EMISSAO <= ctod("30/06/05")
		ZZD->ZZD_PRECOG		:= iif(aProduto[5]=0,ZZD->ZZD_PRECO * -1,aProduto[5]*-1 )
	Else
		ZZD->ZZD_PRECOG		:= iif(aNota[8]=0,ZZD->ZZD_PRECO * -1,aNota[8] * -1)
	EndIf

	If xFilial("SF1") <> "98"
		ZZD->ZZD_TOTNF		:= (nTotNF)*-1		// Valor total da NF
		ZZD->ZZD_TOTNFG		:= nTotNFG * -1				// Valor total Gerencial da NF
	Else
		ZZD->ZZD_TOTNF		:= (aNota[2]*aNota[3] ) * -1	// Valor total da NF
		ZZD->ZZD_TOTNFG		:= (aNota[2]*aNota[3] ) * -1	// Valor total Gerencial da NF
	EndIf
	// Corrige o valor da NFGerencial caso seja produto de bonificaçao
	ZZD->ZZD_TOTNFG		:= (IIf( AllTrim(aNota[1]) $ GetMV('MV_YBONIF') .Or. AllTrim(aNota[5]) $ GetMV('MV_YTESCEB') , 0 , ZZD->ZZD_TOTNFG ))

	ZZD->ZZD_IPI		:= SF2->F2_VALIPI * -1		// IPI
	ZZD->ZZD_IPIG		:= nIpiG * -1				// IPI Gerencial
	//ZZD->ZZD_ICMS		:= (SF2->F2_VALICM  + aNota[17] + aNota[18] )* -1		// ICMS
	ZZD->ZZD_ICMS		:= (SF2->F2_VALICM )* -1		// ICMS
	ZZD->ZZD_ICMSG		:= nIcmsG * -1				// ICMS (gerencial)
	ZZD->ZZD_RET		:= SF2->F2_ICMSRET * -1		// ICMS Retido
	ZZD->ZZD_RETG		:= nICMSRetg  * -1          // Inluido por Gustav conf solicitação Marciane em 17/07/06
	If xFilial("SF2") <> "98"
		ZZD->ZZD_PISCO	:=  nPisco * -1				// Pis/Cofins
		ZZD->ZZD_PISCOG	:=  nPiscoG	* -1			// Pis/Cofins (gerencial)
		ZZD->ZZD_PIS	:= aNota[12] * -1      	    //SF2->F2_VALIMP6
		ZZD->ZZD_COFINS	:= aNota[11] * -1      	    //SF2->F2_VALIMP5
	Else
		ZZD->ZZD_PISCO	:= 0					// Pis/Cofins
		ZZD->ZZD_PISCOG	:= 0					// Pis/Cofins (gerencial)
		ZZD->ZZD_PIS	:= 0
		ZZD->ZZD_COFINS	:= 0
	EndIf
	ZZD->ZZD_FRETOT		:= nFrtTot * -1					// Frete liquido
	ZZD->ZZD_FREUNI		:= nFrtUni * -1 				// Frete liquido unitario (gerencial)
	ZZD->ZZD_FRFIXU		:= SF2->F2_FRFIXO * -1 			// Frete Fixo unitario
	ZZD->ZZD_FRFIXT		:= IIF( cTipCar='S', SF2->F2_FRFIXO * nQtdeEns, SF2->F2_FRFIXO * nQtdeGra) * -1
	ZZD->ZZD_MUNEND		:= SF2->F2_YMUNE			// Municipio de entrega
	ZZD->ZZD_UF			:= SF2->F2_YUFE				// Estado destino
	ZZD->ZZD_COND		:= SF1->F1_COND				// Condicao de pagamento
	ZZD->ZZD_PM			:= nMedia * -1				// Prazo medio
	ZZD->ZZD_VEND		:= SF2->F2_VEND1 			// Vendedor
	ZZD->ZZD_NMVEND		:= POSICIONE("SA3",1,XFILIAL("SA3")+SF2->F2_VEND1,"A3_NOME")
	ZZD->ZZD_PO			:= nPoG	* -1				// Po
	ZZD->ZZD_ATIVI		:= aCliente[2]				// Atividade do cliente
	ZZD->ZZD_ATIVG		:= aCliente[3]				// Atividade 'real' do cliente
	ZZD->ZZD_FRBR		:= IIF(SF2->F2_YVALFRE > 0,SF2->F2_YVALFRE,SF2->F2_FRETE) * -1
	ZZD->ZZD_FRBRUN		:= nFrbUn * -1					// Frete bruto unitario (Gerencial)
	ZZD->ZZD_TPFRE		:= SF2->F2_YFRETE     			// Tipo de frete
	ZZD->ZZD_KM			:= SF2->F2_YDIST * -1  	 		// Distancia da Matriz ao cliente em Km
	ZZD->ZZD_KMR		:= 0						// Raio em Km -- ??
	ZZD->ZZD_TRANS		:= SF2->F2_TRANSP			// Transportadora

	IF SF2->F2_YLIQUI = 0  // Liquido a pagar via RPA -- Inserido por Gustavo Hand Strey em 04/02/2011
		ZZD->ZZD_NOMTRA		:= POSICIONE("SA2",1,XFILIAL("SA2")+SF2->F2_TRANSP,"A2_NOME")			// Transportadora
	ELSE
		ZZD->ZZD_NOMTRA		:= 'PESSOA FISICA'
	ENDIF
	ZZD->ZZD_CARRE		:= SF2->F2_YPLCAR			// Placa da carreta
	ZZD->ZZD_CARRO		:= SF2->F2_YPLACA			// Placa do veiculo
	ZZD->ZZD_MOTOR      := SF2->F2_YMOTOR			// Motorista
	ZZD->ZZD_PREF		:= cPrefixo					// Prefixo padrao do parametro conforme a filial atual
	ZZD->ZZD_YTPCAR		:= cTipCar					// Tipo de Carga
	ZZD->ZZD_YDEV		:= SF2->F2_YDEV				// Tipo da Nota "S"-Substituta ou "C"-Cancelada
	ZZD->ZZD_YNFSUB		:= SF2->F2_YORIG			// NF de substituicao
	ZZD->ZZD_TES		:= aNota[5]					// TES em SD2
	ZZD->ZZD_TEMPO		:= cTempo					// Tempo entre entrada na balanca e saida do faturamento
	ZZD->ZZD_CPO1		:= cCampo1					// Grupo
	ZZD->ZZD_CPO2		:= cCampo2					// Segmento
	ZZD->ZZD_CPO3		:= cCampo3					// Empresas
	ZZD->ZZD_CPO4		:= cCampo4					// Regional
	ZZD->ZZD_CPO5		:= cCampo5					// Filial
	ZZD->ZZD_CPO7		:= cDescCarga				// Embalagem
	ZZD->ZZD_CPO8		:= cAtividade				// Atividade
	ZZD->ZZD_CPO12		:= cDescRegiao				// Regiao de Entrega

	//// Devolucao do VALOR de CDC
	If (Alltrim(cTipCar) == "CDC") .OR. (Alltrim(cTipCar) == "G3")
		If AllTrim(aNota[5]) $ (GetMV('MV_CDCTES1'))  // TES Usado para devoluçao do valor de CDC com o mesmo valor da NF Gerencial
			ZZD->ZZD_DEVCDC		:= nTotNFG * -1
		ElseIf AllTrim(aNota[5]) $ GetMV('MV_CDCTES2') // TES Usado para devoluçao do valor de CDC com a diferenc entre NF GERENCIAL E NF
			ZZD->ZZD_DEVCDC		:=  (nTotNFG - nTotNF) * -1
		Endif
	Endif

	Do Case											// KM Faixa
		Case SF2->F2_YDIST >= 0  .And. SF2->F2_YDIST <= 300
		ZZD->ZZD_CPO16:= 'de   0 a 300 km'
		Case SF2->F2_YDIST > 300 .And. SF2->F2_YDIST <= 450
		ZZD->ZZD_CPO16:= 'de 301 a 450 km'
		Case SF2->F2_YDIST > 450 .And. SF2->F2_YDIST <= 600
		ZZD->ZZD_CPO16:= 'de 451 a 600 km'
		Case SF2->F2_YDIST > 600 .And. SF2->F2_YDIST <= 900
		ZZD->ZZD_CPO16:= 'de 601 a 900 km'
		Case SF2->F2_YDIST > 900 .And. SF2->F2_YDIST <= 1200
		ZZD->ZZD_CPO16:= 'de 900 a 1200km'
		Case SF2->F2_YDIST > 1200
		ZZD->ZZD_CPO16:= 'acima de 1200km'
	EndCase

	ZZD->ZZD_CPO17		:= If(Empty(SF2->F2_TRANSP),'N/CADASTRADO',SF2->F2_TRANSP)  // Transportadora
	ZZD->ZZD_CPO20		:= If(SF2->F2_YFRETE=='C',"CIF","FOB")	// Tipo de Frete
	ZZD->ZZD_CPO21		:= If(Empty(cTes),'N/CADASTRADO',cTes)	// Tes
	ZZD->ZZD_CPO22		:= aCliente[4]				            // Data primeiro faturamento
	ZZD->ZZD_CPO23      := aPedido[9]
	ZZD->ZZD_VLR4		:= nCusTran  //nValor4                  // Custo de transferencia
	ZZD->ZZD_VLR16		:= aPedido[11]				                            // Peso Saida da Ordem de Carregamento - Marciane pediu em 11/07/05
	ZZD->ZZD_VLR17		:= If(aProduto[6]=="SC",(aOrdem[3]*aProduto[7])*-1,aOrdem[3]*-1)// Peso NF
	ZZD->ZZD_YDIAST	    := aOrdem[5]-IIf(Empty(aOrdem[9]),aOrdem[5],aOrdem[9])
	ZZD->ZZD_YHORAT     := ElapTime(aOrdem[10]+":00",aOrdem[8]+":00") // Z1_HLIB + Hora da Saida (Z8_HSAIDA)
	ZZD->ZZD_YOC        := aOrdem[6]
	If Val(Subs(ZZD->ZZD_YHORAT,1,2)) > 0 .or. Val(Subs(ZZD->ZZD_YHORAT,4,2)) > 0
		ZZD->ZZD_YTOTDT  := ((ZZD->ZZD_YDIAST*24)+Val(Subs(ZZD->ZZD_YHORAT,1,2)))/24
	Else
		ZZD->ZZD_YTOTDT  := 0
	Endif

	ZZD->ZZD_TPROD   := SF2->F2_VALMERC * -1
	ZZD->ZZD_TPRODG  := IIf( nTotNFG > 0, nProdG * -1, 0 )

	If aProduto[6]$("SA/SC")
		ZZD->ZZD_YPESAC	:= aProduto[7]
	EndIf

	ZZE->(DbSetOrder(1))
	ZZE->(DbSeek(xFilial("ZZE")+dtos(SF2->F2_EMISSAO)))
	ZZD->ZZD_YDUTIL	:= ZZE->ZZE_DUTIL
	ZZD->ZZD_YDCORR	:= ZZE->ZZE_DCORR
	ZZD->ZZD_CODEMP	:= cEmpAnt
	ZZD->ZZD_CODFIL	:= cFilAnt
	ZZD->ZZD_NOMFIL := POSICIONE("SM0",1,cEmpAnt+cFilAnt,"M0_FILIAL")

	//cSigla:=   getNewPar('MV_SIGLAMZ','01-MZVI')

	/*
	If cEmpAnt == "01"
	cSigla := "01-MZVI"
	ElseIf cEmpAnt + cFilAnt $ "0222"		//	EMPRESA 02
	cSigla := "22-MZCF"
	ElseIf cEmpAnt + cFilAnt $ "0223"		//	EMPRESA 02
	cSigla := "23-MZAB"
	//ElseIf cEmpAnt + cFilAnt $ "0222|0223"		//	EMPRESA 02
	//	cSigla := "0223-MZAB"
	ElseIf cEmpAnt == "10"
	cSigla := "10-MZMO"
	ElseIf cEmpAnt == "11"
	cSigla := "11-MZPA"
	ElseIf cEmpAnt + cFilAnt $ "0213"
	cSigla := "13-MZPA"
	ElseIf cEmpAnt == "12"
	cSigla := "12-MZIB"
	ElseIf cEmpAnt == "20"
	cSigla := "20-MZAB"
	ElseIf cEmpAnt == "30"
	cSigla := "30-MZBA"
	ElseIf cEmpAnt + cFilAnt $ "0210"		//Incluso por Alison - 22/07/2016
	cSigla := "10-MZBA"
	ElseIf cEmpAnt == "40"
	cSigla := "40-MZMN"
	ElseIf cEmpAnt == "50"
	cSigla := "50-MZ-IBEC"
	Endif*/ //	Marcus Vinicius - 15/08/2016


	//-------------------------------------------------
	//		Marcus Vinicius - 15/08/2016
	//	Ajustado para buscar a filial do sigamat
	//-------------------------------------------------
	cSigla := Space(7)									//Incluso por Fabiano - 20/10/2016
	If SM0->M0_CODIGO == "01"
		cSigla := "01-MZVI"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0201"
		cSigla := "01-MZAE"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0203"		//Incluso por Alison - 12/09/2016
		cSigla := "03-MZMN"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0208"		//Incluso por Fabiano - 20/10/2016
		cSigla := "08-MZFT"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0210"
		cSigla := "10-MZBA"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0211"
		cSigla := "11-MZPQ"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0213"
		cSigla := "13-MZPA"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0214"
		cSigla := "14-MZAJ"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0215"
		cSigla := "15-MZEU"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0216"
		cSigla := "16-MZIB"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0218"
		cSigla := "18-MZVI"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0220"
		cSigla := "20-MZGV"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0221"
		cSigla := "21-MZCP"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0222"
		cSigla := "22-MZCF"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0223"
		cSigla := "23-MZAB"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0225"
		cSigla := "25-MZDQ"
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0226"
		cSigla := "26-MZMO"
		/*ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0227"
		cSigla := "27-MZSANT"	 */
	ElseIf SM0->M0_CODIGO + LEFT(SM0->M0_CODFIL,2) $ "0231"
		cSigla := "31-MZST"		//Santana de Parnaíba
	ElseIf SM0->M0_CODIGO == "10"
		cSigla := "10-MZMO"
	ElseIf SM0->M0_CODIGO == "11"
		cSigla := "11-MZPA"
	ElseIf SM0->M0_CODIGO == "12"
		cSigla := "12-MZIB"
	ElseIf SM0->M0_CODIGO == "20"
		cSigla := "20-MZAB"
	ElseIf SM0->M0_CODIGO == "30"
		cSigla := "30-MZBA"
	ElseIf SM0->M0_CODIGO == "40"
		cSigla := "40-MZMN"
	ElseIf SM0->M0_CODIGO == "50"
		cSigla := "50-IBEC"
	Endif
	//-------------------------------------------------


	if UPPER(alltrim(funname()))=='REPROZZD' .AND. left(cSigla,2) <> cEmpAnt  .and. valType(aLogErr)=='A' //.and. !MsgBox("O conteudo do parametro MV_SIGLAMZ, nao correponde a esta empresa! Continuar gravacao ?","Atencao","YESNO")
		aAdd(aLogErr, "O conteudo do parametro MV_SIGLAMZ, nao correponde a esta empresa!" )
	endif

	ZZD->ZZD_SIGLA  := substr(cSigla,4,4)
	ZZD->ZZD_MASSAG	:= (nQtdeGra * nPOG) * -1
	nPO := Round((nTotNF - SF2->F2_VALIPI - SF2->F2_VALICM - SF2->F2_ICMSRET - nPisco - nFrtTot - SF2->F2_YPEDAG) / nQtdeGra,2)
	nPO -= If(cTipCar = "S",nCustSac,0)

	_nMarge         := (Round((nTotNF - SF2->F2_VALIPI - SF2->F2_VALICM - SF2->F2_ICMSRET - nPisco - nFrtTot - SF2->F2_YPEDAG) / nQtdeGra,2)    - aNota[9])
	_nMargeG        := (Round((nTotNFG - nIpiG - nIcmsG - nIcmsRetG - nPiscoG - nFrtTot - SF2->F2_YPEDAG) / nQtdeGra,2)   -  aNota[9] )

	ZZD->ZZD_MASSA  := (nQtdeGra * nPO) * -1
	ZZD->ZZD_CUSTO	:= aNota[9]  * -1
	ZZD->ZZD_MARGEM	:= _nMarge   * -1
	ZZD->ZZD_MARGEG	:= _nMargeG  * -1

	nPO := Round((nTotNFG - nIpiG - nIcmsG - nIcmsRetG - nPiscoG - nFrtTot - SF2->F2_YPEDAG) / nQtdeGra,2)
	nPO -= If(cTipCar = "S",nCustSac,0)
	ZZD->ZZD_YPEDAG := SF2->F2_YPEDAG * -1	// Marcus Vinicius - 21/07/2015
	ZZD->ZZD_YCTR  	:= SF2->F2_YCTR
	ZZD->ZZD_YSERCT := SF2->F2_YSERCTR
	ZZD->ZZD_IRCSL  := IF(_nMarge  > 0 ,(nQtdeGra * _nMarge  * wPIRCSL)*-1,0)
	ZZD->ZZD_IRCSLG := IF(_nMargeG > 0 ,(nQtdeGra * _nMargeG * wPIRCSL)*-1,0)
	aZZD				:= GetArea("ZZD")

	// CALCULO DA DEVOLUCAO DE CDC
	If (Alltrim(cTipCar) == "CDC") .OR. (Alltrim(cTipCar) == "G3")
		ZZD->ZZD_DEICDC	:= ( (((nIpiG        +nIcmsG        +nICMSRetg    +nPiscoG        ) - (SF2->F2_VALIPI+SF2->F2_VALICM+SF2->F2_ICMSRET+nPisco        ))-(((nTotNFG - SF2->F2_VALBRUT) * 0.01) +IIF(cTES $ "612#512#509" ,((nTotNFG         - SF2->F2_VALBRUT) * (nAlqPisGer+nAlqCofGer)),(nTotNFG         * (nAlqPisGer+nAlqCofGer)))))/2 ) * -1
	Endif

	If Alltrim(cTipCar) $ "CDC*G"
		ZZD->ZZD_PERFIL := "GRANEL"
	ELSEIF cTipCar = "S"
		ZZD->ZZD_PERFIL := "SACOS"
	Endif

	if len (aCliente) >= 8
		//ZZD->ZZD_CLASVC := TABELA("Z6",aCliente[8]) //TIPO DE CLIENTE PARA A VOTORANTIN,
	endif
	ZZD->ZZD_CFOP   := SD1->D1_CF
	ZZD->ZZD_TIPONF := SF1->F1_TIPO
	ZZD->ZZD_TIPOMT := aProduto[12]
	ZZD->ZZD_DESTES := cDESTES[2] // INCLUIDO POR GUSTAVO EM 25/03/2009
	ZZD->ZZD_TIPCAR := POSICIONE("SZ7",4,XFILIAL("SZ7")+PADR(SF2->F2_DOC,9)+SF2->F2_SERIE,"Z7_YPM")
	ZZD->ZZD_QTCIF  := IIF(nFrtTot>0,nQtdeGra * -1,0)

	//_nDeicDc  := ( (((nIpiG        +nIcmsG        +nICMSRetg    +nPiscoG        ) - (SF2->F2_VALIPI+SF2->F2_VALICM+SF2->F2_ICMSRET+nPisco        ))-(((nTotNFG - SF2->F2_VALBRUT) * 0.01) +IIF(cTES $ "612#512" ,((nTotNFG         - SF2->F2_VALBRUT) * 0.0925),(nTotNFG         * 0.0925))))/2 )
	//_nDeicDc  := ( (((nIpiG        +nIcmsG        +nICMSRetg    +nPiscoG        ) - (SF2->F2_VALIPI+SF2->F2_VALICM+SF2->F2_ICMSRET+nPisco        ))-(((nTotNFG - SF2->F2_VALBRUT) * 0.01) +IIF(cTES $ "612#512#509" ,((nTotNFG         - SF2->F2_VALBRUT) * 0.0925),(nTotNFG         * 0.0925))))/2 )// Desabilitado por Marcus Vinicius - 23/11/16

	// Marcus Vinicius - 23/11/2016 - Alterado para buscar a alíquota das variáveis nAlqPisGer e nAlqCofGer
	_nDeicDc  := ( (((nIpiG        +nIcmsG        +nICMSRetg    +nPiscoG        ) - (SF2->F2_VALIPI+SF2->F2_VALICM+SF2->F2_ICMSRET+nPisco        ))-(((nTotNFG - SF2->F2_VALBRUT) * 0.01) +IIF(cTES $ "612#512#509" ,((nTotNFG         - SF2->F2_VALBRUT) * 0.0925),(nTotNFG         * (nAlqPisGer+nAlqCofGer)))))/2 )

	ZZD->ZZD_MARTOT := ((_nMargeG*nQtdeGra)+_nDeicDc) * -1
	ZZD->ZZD_FRE3   := nFRE3Tot * -1
	ZZD->ZZD_FRE3U  := nFRE3Un  * -1
	ZZD->ZZD_YMUN   := SA1->A1_MUN
	//ZZD->ZZD_YEST   := SA1->A1_EST
	ZZD->ZZD_YEST   := aCliente[5]    // Marcus Vinicius - 16/11/16 - Adicionado para pegar de acordo com o filtro utilizado na função PesqSA1

	IF ZZD->(FieldPos("ZZD_NREDUZ")) > 0
		ZZD->ZZD_NREDUZ:= SA1->A1_NREDUZ
	ENDIF

	IF ZZD->(FieldPos("ZZD_UFFATU")) > 0
		ZZD->ZZD_UFFATU := SM0->M0_ESTCOB
	ENDIF

	IF SF2->F2_TIPO <> 'D'
		//ZZD->ZZD_GRPVEN  := POSICIONE("SA1",1,XFILIAL("SA1")+SF2->F2_CLIENTE,"A1_GRPVEN")
		ZZD->ZZD_GRPVEN := aCliente[7]
		ZZD->ZZD_YDGRUP  := POSICIONE("ACY",1,XFILIAL("ACY")+ZZD->ZZD_GRPVEN,"ACY_DESCRI")
	ENDIF

	ZZD->ZZD_PISNF  := nPisNF * -1
	ZZD->ZZD_COFNF  := nCOFNF* -1
	ZZD->ZZD_PISGER := nPISGER* -1
	ZZD->ZZD_COFGER := nCOFGER* -1

	IF ZZD->(FieldPos("ZZD_GRPPRC")) > 0
		ZZD->ZZD_GRPPRC := aProduto[14]
	Endif

	DbSelectArea("ZZD")
	MsUnlock()
	RestArea(aZZD)

Return 'fim'