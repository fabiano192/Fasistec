#include "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PXH018   º Autor ³ Felipe Zago        º Data ³  18/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo MP8 IDE.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Geracao do arquivo ZZD - EXPORTA PARA BI                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PXH018()

dbSelectArea("SF2")
dbSetOrder(1)
dbSeek(xFilial("SF2")+cDoc+cSERIE+cCliente+cLoja,.t.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Buscar produto no pedido                  								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SC6")
DbSetOrder(4)


xDoc:= SF2->F2_DOC

//If !DbSeek(xFilial("SC6") + xDoc + SF2->F2_SERIE)
//	DbSeek(xFilial("SC6") + xDoc )
//EndIf

//if UPPER(alltrim(funname()))=='PXH017' .AND. empty(sc5->(c5_filial+c5_nota+c5_serie) )  .and. valtype(aLogErr)=='A'
//	aAdd(aLogErr, "Documento nao localizado em PEDIDOS DE VENDA! [ Filial:"+xFilial("SC5") +'/ Doc: '+ xDoc +'/ Serie: '+ SF2->F2_SERIE+" ]" )
//endif

If !DbSeek(xFilial("SC6") + xDoc + SF2->F2_SERIE)
	DbSeek(xFilial("SC6") + xDoc )
EndIf


SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
Private aCliente	 := fPesqSA1()
Private naliqext     := 0
Private _esticm	     := alltrim(getmv("MV_ESTICM"))
Private _estado      := GetMV("MV_ESTADO")
Private _picmest     := Val(Subs(_esticm,at(_estado,_esticm)+2,2))
Private naliqext     := 0
Private ndifaliq     := 0
Private wPIRCSL      := 0//GETMV("MV_YIRCSSL") / 100
Private nBaseIcmsG   := 0
Private aNota		 := fPesqSD2()
Private nCusTran	 := aNota[7]
Private nCustSac	 := aNota[10]
Private aProduto	 := fPesqSB1()
Private nQtdTB		 := iif(aProduto[6] $ 'BB/TB/UN/CT',aNota[3],0)
Private cTipCar		 := aProduto[4]
Private cDescCarga	 := fPesqDB0()

If aProduto[6] <> "KG"
	If aProduto[13]=='M'
		nQtdeGra		:= Round(aNota[3] * aProduto[7],2)
	Else
		nQtdeGra		:= Round(aNota[3] / aProduto[7],2)
	Endif
Else
	nQtdeGra		:= aNota[3]
Endif

Private cPrefixo	:= "FAT"
Private aPedido		:= fPesqSC6()
Private cGrupo		:= aNota[15] //GRUPO
Private cCampo2		:= fPesqZZA(xFilial('ZZA') + "02             ")
Private cCampo3		:= fPesqZZA(xFilial('ZZA') + "03             ")
Private cCampo4		:= fPesqZZA(xFilial('ZZA') + "04             ")
Private cCampo5		:= fPesqZZA(xFilial('ZZA') + "05             ")
Private aCReceb 	:= fPesqSE1(xFilial('SE1') + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_SERIE + SF2->F2_DOC)
Private nValor14	:= fPesqSE4()
Private nValor16	:= aPedido[8]  // Peso real
Private nValor17	:= aPedido[10] // Peso NF
Private cTes		:= aNota[5]
Private cAtividade	:= fPesqSX5() // Busca a partir da Atividade Gerencial SX5('YI') Se Ativ.Real nao preenchida, entao retornara Atividade
Private cRegiao		:= fPesqSZ4()
Private cDescRegiao	:= fPesqSZO() // Cadastro de Regioes ZO_DESC
Private wTES		:= ""
Private nICMSRetG	:= 0
Private nProdG		:= 0
Private	cPrefixo    := SF2->F2_PREFIXO //GetnewPar("MV_YPREF","FAT") 	// Traz o prefixo padrao do parametro conforme a filial atual

Private nMedia		:=  fPesqSE4()
Private nAliqICM	:= aNota[6]
Private nFRE3Tot	:= 0 // Frete NF + Custo Transporte Total
Private nFRE3Un		:= 0 // Frete NF + Custo Transporte Unitário
Private	nPisNF      := 0 // PIS na NFS
Private nCOFNF      := 0 // COFINS na NFS
Private nPISGER     := 0 // PIS gerencial
Private nCOFGER     := 0 // COFINS gerencial
Private cDESTES		:= fPesqSF4() // Descrição da TES

If !aProduto[1]
	if UPPER(alltrim(funname()))=='PXH017' .AND. valType( aLogErr )=='A'
		aAdd(aLogErr, 'Produto nao e PA ! '+aproduto[8] )
	endif
	
	Return ('loop')
EndIf

nTotNF	:= QRYSF2->D2_VALBRUT
nTotNFG	:= QRYSF2->D2_VALBRUT

nPrecoUn := Round(nTotNF / nQtdeGra,2)

If aNota[8] == 0 // Preco Gerencial nulo
	
Else
	//If (aProduto[6]= "TB")
	If (aProduto[6] $  "BB/TB/CT")     // ALTERADO EM 03/09/12 POR ALEXANDRO
		nTotNFG := aNota[8] * nQtdTB			    // Preco gerencial * quantidade em tons
	ElseIf (aProduto[6]= "KG")
		nTotNFG := aNota[8] * nQtdeGra			    // Preco gerencial * quantidade em tons
	EndIf
EndIf

naliqext := 12
nD2Aliq  := 1+ ( ( _picmest - naliqext ) / 100 )

If SF2->F2_ICMSRET > 0 .And. aNota[8] <> 0 //Preco Gerencial
	
	nProdG := ROUND(      ((nTotnfg  /  nDifAliq )    -   (QRYSF2->D2_VALFRE * 1.04) ) / 1.04 , 2 )
	
	nIcmsRetG :=  ( ( nProdG + SF2->F2_FRETE )  * 1.04) * ( ndifaliq  - 1 )
	
Else // produto gerencial sem ICMS RETIDO
	nProdG := ROUND(  (nTotNFG  /  1.04 ) -  QRYSF2->D2_VALFRE,2 )
EndIf

if SF2->F2_VALIPI = 0
	nIpiG:= 0
Else
	nIpiG	:= Round((((nTotNFG - QRYSF2->D2_VALFRE*1.04)-nICMSRETG)/1.04+QRYSF2->D2_VALFRE)*0.04,2)
EndIf

nFrbUn	:= iif(cTipCar='S',QRYSF2->D2_VALFRE / nQtdTB, QRYSF2->D2_VALFRE / nQtdeGra)

If SF2->F2_ICMSRET > 0 .And. aNota[8] <> 0 //Preco Gerencial
	naliqext := 12
	nProduto := nTotNFG - ( 1.05 * QRYSF2->D2_VALFRE ) - ( 1.05 * nIpiG )
	
	nProduto := Round(nProduto / 1.05,2)
	ndifaliq := ( _picmest - naliqext ) / 100
	nIcmsRetG :=  ( nProduto + SF2->F2_FRETE + nIpiG ) * ndifaliq
EndIf

If aNota[8] == 0 //Preco Gerencial
	nIcmsG	  := QRYSF2->D2_VALICM
	nICMSRetG := QRYSF2->D2_ICMSRET
	nIPIG     := QRYSF2->D2_VALIPI
Else
	nBaseIcmsG := nTotNFG - QRYSF2->D2_VALFRE-iif(aCliente[2] $ ("1/2"),nIpiG,0) + If(aCliente[6] == "S",QRYSF2->D2_VALFRE,0)
	nIcmsG	  := Round((nBaseIcmsG-iif(aCliente[2] $ ("1/2"),nIpiG,0)-nIcmsRetG) * (aNota[6] / 100) ,2)
EndIf

nPisco	:= 0
nPiscoG	:= 0

//If AllTrim(aNota[1]) $ GetMV('MV_YBONIF') .Or. AllTrim(aNota[5]) $ GetMV('MV_YTESCEB')

//Else

If xFilial("SF2") <> "98"
	If !(cTES $ "621#523#521") // se nao for um dos TES expecificados ao lado
		nPisco  := aNota[11]+aNota[12]	//SF2->(F2_VALIMP5 + F2_VALIMP6) Não grava SF2. Somente SD2
		nPisNF  := aNota[11]
		nCOFNF  := aNota[12]
	EndIf
	
	nPiscoG	:= Round((nTotNFG - nIpiG - nIcmsRetG) * 0.0925,2)
EndIf

If aNota[8] == 0 //Preco Gerencial
	nPiscoG := nPisco
	nPISGER := nPisNF
	nCOFGER := nCOFNF
Else
	nPISGER := Round((nTotNFG - nIpiG - nIcmsRetG) * 0.0760,2)
	nCOFGER := Round((nTotNFG - nIpiG - nIcmsRetG) * 0.0165,2)
EndIf

nFrtUni:= nFrbUn
nFrtUni:= nFrtUni - Round((nFrbUn * 0.2125 ),4)

if aPedido[14]$'C/S' //CIF- O FRETE POR CONTA DA MAX
	nFrtTot	:= Round(iif(cTipCar='S', nFrtUni * nQtdTB, nFrtUni * nQtdeGra),4)
endif

nFRE3Tot := aPedido[15] // c5_yfrete - frete real

//If nFRE3Tot > 0
//	nFRE3Un	:= round( nFRE3Tot / nQtdeGra, 2)
//Endif

nMARGEG	:= Round((nTotNFG - nIpiG - nIcmsG - nIcmsRetG - nPiscoG - QRYSF2->D2_VALFRE - 0) / nQtdeGra,2)   -  aNota[9]	   // Margem de Lucro
nIRCSLG := IF(nMARGEG > 0 ,(nQtdeGra * nMARGEG * wPIRCSL),0)

wwTotNFG:= 0
//wwTotNFG:= IIf( AllTrim(aNota[1]) $ GetMV('MV_YBONIF') .Or. AllTrim(aNota[5]) $ GetMV('MV_YTESCEB') , 0 , nTotNFG )
wwTotNFG:=  nTotNFG

DbSelectArea("ZZD")
DbSetOrder(10) //ZZD_FILIAL+ZZD_CODEMP+ZZD_CODFIL+ZZD_DOC+ZZD_SERIE+ZZD_CLIE+ZZD_LOJA+ZZD_PROD
aZZD				:= GetArea("ZZD")

If dbSeek(xFilial("ZZD")+cEmpAnt+cFilAnt+QRYSF2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_ITEM))
	
	RecLock("ZZD",.f.)
Else
	RecLock("ZZD",.t.)
EndIf

dbSelectArea("SF2")
ZZD->ZZD_FILIAL		:= xFilial("ZZD") //SF2->F2_FILIAL
ZZD->ZZD_EMIS		:= SF2->F2_EMISSAO
ZZD->ZZD_EMIS		:= SF2->F2_EMISSAO
ZZD->ZZD_ANOMES	    := Left(DtoS(SF2->F2_EMISSAO),6)	 //Ano Mes
ZZD->ZZD_HRSAID	    := SF2->F2_HORA             // HORA DE SAIDA DA NF
ZZD->ZZD_PROD		:= aNota[1]					// Cod. produto
ZZD->ZZD_DESCPR	    := aProduto[8]				// Descricao do Produto
ZZD->ZZD_DESCRE	    := aProduto[9]				// Descricao Resumida do Produto
ZZD->ZZD_DESGR 	    := aProduto[10]				// Descricao do Produto
ZZD->ZZD_DESSGR	    := aProduto[11]				// Descricao Resumida do Produto
ZZD->ZZD_CLIE		:= SF2->F2_CLIENTE			// Cod. cliente
ZZD->ZZD_LOJA		:= SF2->F2_LOJA				// Loja
ZZD->ZZD_NOME		:= aCliente[1]				// Nome cliente
ZZD->ZZD_SERIE		:= SF2->F2_SERIE			// Serie documento
ZZD->ZZD_DOC		:= SF2->F2_DOC				// Num. documento
ZZD->ZZD_ITEM       := QRYSF2->D2_ITEM
ZZD->ZZD_QTBRUT     := QRYSF2->D2_QUANT
ZZD->ZZD_QTLIQ		:= QRYSF2->D2_QTSEGUM
ZZD->ZZD_PRECO		:= nPrecoUn					// Buscar no SD2
ZZD->ZZD_PRECOG	    := nTotNFG / ZZD->ZZD_QTLIQ
If SF2->F2_TIPO = "D"
	ZZD->ZZD_TOTNF	:= nTotNF * -1		// Valor total da NF
Else
	ZZD->ZZD_TOTNF	:= nTotNF		// Valor total da NF
Endif
//ZZD->ZZD_TOTNFG	:= nTotNFG				// Valor total Gerencial da NF
//ZZD->ZZD_TOTNFG	:= IIf( AllTrim(aNota[1]) $ GetMV('MV_YBONIF') .Or. AllTrim(aNota[5]) $ GetMV('MV_YTESCEB') , 0 , ZZD->ZZD_TOTNFG )

If SF2->F2_TIPO = "D"
	ZZD->ZZD_IPI	:= QRYSF2->D2_VALIPI	* -1		// IPI
	ZZD->ZZD_TOTLIQ := (ZZD->ZZD_TOTNF - ZZD->ZZD_IPI) * -1
	ZZD->ZZD_ICMS	:= QRYSF2->D2_VALICM	* -1		// ICMS
Else
	ZZD->ZZD_IPI	:= QRYSF2->D2_VALIPI			// IPI
	ZZD->ZZD_TOTLIQ := ZZD->ZZD_TOTNF - ZZD->ZZD_IPI
	ZZD->ZZD_ICMS	:= QRYSF2->D2_VALICM			// ICMS
Endif
ZZD->ZZD_PRCLIQ     := ZZD->ZZD_TOTLIQ / ZZD->ZZD_QTLIQ

If SF2->F2_TIPO = "D"
	If aNota[8] <> 0 //Preco Gerencial
		ZZD->ZZD_TOTNFG	:= (ZZD->ZZD_QTLIQ * ZZD->ZZD_PRECOG) *-1
	Else
		ZZD->ZZD_TOTNFG	:= ZZD->ZZD_TOTLIQ
	Endif
Else
	If aNota[8] <> 0 //Preco Gerencial
		ZZD->ZZD_TOTLIG   := ZZD->ZZD_QTLIQ  * ZZD->ZZD_PRECOG
		ZZD->ZZD_IPIG	  := ZZD->ZZD_TOTLIG * (QRYSF2->D2_IPI /100)	   // IPI Gerencial
		ZZD->ZZD_TOTNFG	  := ZZD->ZZD_TOTLIG + ZZD->ZZD_IPIG
		ZZD->ZZD_ICMSG	  := Round((ZZD->ZZD_TOTLIG + ZZD->ZZD_IPIG) * (QRYSF2->D2_PICM/100),2)	// ICMS (gerencial)
		ZZD->ZZD_PISGER   := ZZD->ZZD_TOTLIG * (1.65/100)
		ZZD->ZZD_COFGER   := ZZD->ZZD_TOTLIG * (7.60/100)
		ZZD->ZZD_DEICDC   := ((ZZD->ZZD_IPIG - ZZD->ZZD_IPI + ZZD->ZZD_ICMSG - ZZD->ZZD_ICMS)/2)
		
		//Se tiver preço gerencial ((ZZD_TOTNFG + ZZD_IPI  * Aliquota do ICMS da NF))
	Else
		ZZD->ZZD_TOTLIG   := ZZD->ZZD_TOTLIQ
		ZZD->ZZD_IPIG	  := ZZD->ZZD_TOTLIG * (QRYSF2->D2_IPI /100)	   // IPI Gerencial
		ZZD->ZZD_TOTNFG	  := ZZD->ZZD_TOTLIG + 	ZZD->ZZD_IPIG
		ZZD->ZZD_ICMSG	  := ZZD->ZZD_TOTNFG * (QRYSF2->D2_PICM / 100)	// ICMS (gerencial)
		ZZD->ZZD_PISGER   := ZZD->ZZD_TOTLIG * (1.65/100)
		ZZD->ZZD_COFGER   := ZZD->ZZD_TOTLIG * (7.60/100)
		
	Endif
Endif

ZZD->ZZD_RET		:= QRYSF2->D2_ICMSRET			// ICMS Retido
ZZD->ZZD_RETG		:= nICMSRetg // Inluido por Gustav conf solicitação Marciane em 17/07/06
ZZD->ZZD_PISCO		:= nPisco					// Pis/Cofins
ZZD->ZZD_PISCOG	    := nPiscoG					// Pis/Cofins (gerencial)
ZZD->ZZD_PIS		:= aNota[11]	//SF2->F2_VALIMP6
ZZD->ZZD_COFINS	    := aNota[12]	//SF2->F2_VALIMP5
ZZD->ZZD_FRETOT	    := nFrtTot					// Frete liquido
ZZD->ZZD_FREUNI	    := nFrtUni					// Frete liquido unitario (gerencial)
//ZZD->ZZD_FRFIXU	    := SF2->F2_FRFIXO					// Frete Fixo unitario
//ZZD->ZZD_FRFIXT	    := IIF( cTipCar='S', SF2->F2_FRFIXO * nQtdTB, SF2->F2_FRFIXO * nQtdeGra) // FRETE FIXO - TABELA DE ESTADOS E MUNICIPIOS ( SZG )
ZZD->ZZD_MUNEND	    := acliente[9] //SF2->F2_YMUNE			// Municipio de entrega
ZZD->ZZD_UF			:= acliente[5]				// Estado destino
ZZD->ZZD_COND		:= SF2->F2_COND				// Condicao de pagamento
ZZD->ZZD_PM			:= nMedia					// Prazo medio
ZZD->ZZD_VEND		:= SF2->F2_VEND1 			// Vendedor
ZZD->ZZD_NMVEND	    := POSICIONE("SA3",1,XFILIAL("SA3")+SF2->F2_VEND1,"A3_NOME")
ZZD->ZZD_ATIVI		:= aCliente[2]				// Atividade do cliente
ZZD->ZZD_ATIVG		:= aCliente[3]				// Atividade 'real' do cliente
ZZD->ZZD_FRBR		:= QRYSF2->D2_VALFRE    	// Frete bruto
ZZD->ZZD_FRBRUN	    := nFrbUn					// Frete bruto unitario (Gerencial)
ZZD->ZZD_TPFRE		:= aPedido[14]
ZZD->ZZD_KM			:= 0//SF2->F2_YDIST			// Distancia da Matriz ao cliente em Km
ZZD->ZZD_KMR		:= 0						// Raio em Km -- ??
ZZD->ZZD_TRANS		:= SF2->F2_TRANSP			// Transportadora
ZZD->ZZD_NOMTRA	    := POSICIONE("SA4",1,XFILIAL("SA4")+SF2->F2_TRANSP,"A4_NOME")			// Transportadora
ZZD->ZZD_CARRE		:= ""//SF2->F2_YPLCAR			// Placa da carreta
ZZD->ZZD_CARRO		:= "" //SF2->F2_YPLACA			// Placa do veiculo
ZZD->ZZD_MOTOR      := "" //SF2->F2_YMOTOR			// Motorista
ZZD->ZZD_PREF		:= cPrefixo					// Prefixo padrao do parametro conforme a filial atual
ZZD->ZZD_YTPCAR	    := cTipCar					// Tipo de Carga
ZZD->ZZD_YDEV		:= "" //SF2->F2_YDEV				// Tipo da Nota "S"-Substituta ou "C"-Cancelada
ZZD->ZZD_YNFSUB	    := ""//SF2->F2_YORIG			// NF de substituicao
ZZD->ZZD_TES		:= aNota[5]					// TES em SD2
ZZD->ZZD_UM		    := aNota[14]					// UM
ZZD->ZZD_TEMPO		:= cTempo					// Tempo entre entrada na balanca e saida do faturamento
ZZD->ZZD_GRUPO		:= cGrupo					// Grupo
ZZD->ZZD_CPO2		:= cCampo2					// Segmento
ZZD->ZZD_CPO3		:= cCampo3					// Empresas
ZZD->ZZD_CPO4		:= cCampo4					// Regional
ZZD->ZZD_CPO5		:= cCampo5					// Filial
ZZD->ZZD_CPO7		:= cDescCarga				// Embalagem
ZZD->ZZD_CPO8		:= cAtividade				// Atividade
ZZD->ZZD_CPO12		:= cDescRegiao				// Regiao de Entrega
If aNota[8] <> 0 //Preco Gerencial
	ZZD->ZZD_DEVCDC	:= nTotNFG - ZZD->ZZD_TOTLIQ
Else
	ZZD->ZZD_DEVCDC	:= 0
Endif
/*
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
*/
ZZD->ZZD_CPO17		:= If(Empty(SF2->F2_TRANSP),'N/CADASTRADO',SF2->F2_TRANSP)  // Transportadora
ZZD->ZZD_CPO20		:= aPedido[13] //If(SF2->F2_YFRETE=='C',"CIF","FOB")	// Tipo de Frete
ZZD->ZZD_CPO21		:= If(Empty(cTes),'N/CADASTRADO',cTes)	// Tes
ZZD->ZZD_CPO22		:= aCliente[4]				            // Data primeiro faturamento
ZZD->ZZD_VLR16		:= aPedido[11]				                            // Peso Saida da Ordem de Carregamento - Marciane pediu em 11/07/05
ZZD->ZZD_VLR17		:= If(aProduto[6] $ "BB/TB",aOrdem[3]*aProduto[7],aOrdem[3])// Peso NF
ZZD->ZZD_YDIAST	:= aOrdem[5]-IIf(Empty(aOrdem[9]),aOrdem[5],aOrdem[9])   // Z8_DTSAIDA - Z1_YDTLIB
ZZD->ZZD_YHORAT   := ElapTime(aOrdem[10]+":00",aOrdem[8]+":00") // Z1_HLIB + Hora da Saida (Z8_HSAIDA)
ZZD->ZZD_YOC      := aOrdem[6]
If Val(Subs(ZZD->ZZD_YHORAT,1,2)) > 0 .or. Val(Subs(ZZD->ZZD_YHORAT,4,2)) > 0
	ZZD->ZZD_YTOTDT  := ((ZZD->ZZD_YDIAST*24)+Val(Subs(ZZD->ZZD_YHORAT,1,2)))/24
Else
	ZZD->ZZD_YTOTDT  := 0
Endif

ZZD->ZZD_TPROD   := SF2->F2_VALMERC
ZZD->ZZD_TPRODG := IIf( ZZD->ZZD_TOTNFG > 0, nProdG, 0 )

If aProduto[6]$("BB/TB/UN")
	ZZD->ZZD_YPESTB	:= aProduto[7]
EndIf

//ZZE->(DbSetOrder(1))
//ZZE->(DbSeek(xFilial("ZZE")+dtos(SF2->F2_EMISSAO)))
//ZZD->ZZD_YDUTIL	:= ZZE->ZZE_DUTIL
//ZZD->ZZD_YDCORR	:= ZZE->ZZE_DCORR
ZZD->ZZD_CODEMP	:= cEmpAnt
ZZD->ZZD_CODFIL	:= cFilAnt
ZZD->ZZD_NOMFIL := POSICIONE("SM0",1,cEmpAnt+cFilAnt,"M0_FILIAL")

cSigla:=   getNewPar('MV_SIGLAMZ','01-PXHOL ')
if UPPER(alltrim(funname()))=='REPROZZD' .AND. left(cSigla,2) <> cEmpAnt  .and. valType(aLogErr)=='A' //.and. !MsgBox("O conteudo do parametro MV_SIGLAMZ, nao correponde a esta empresa! Continuar gravacao ?","Atencao","YESNO")
	aAdd(aLogErr, "O conteudo do parametro MV_SIGLAMZ, nao correponde a esta empresa!" )
endif

ZZD->ZZD_SIGLA := substr(cSigla,4,4)

nPoG	:=  fCalcPoG(cTipCar, nTotNFG, nIpig, nIcmsg, nPiscoG, nFrtTot, nQtdeGra, nCustSac, nIRCSLG)
ZZD->ZZD_PO			:= nPoG						// Po
ZZD->ZZD_MASSAG	:= ( ZZD->ZZD_TOTNF - ZZD->ZZD_IPI - ZZD->ZZD_ICMS - ZZD->ZZD_RET - ZZD->ZZD_PIS - ZZD->ZZD_COFINS - nFrtTot)    // MASSA R$ - Solicitado pelo Sr. Josi

nPo	:= nPoG
ZZD->ZZD_MASSA := ( ZZD->ZZD_TOTNF - ZZD->ZZD_IPI - ZZD->ZZD_ICMS - ZZD->ZZD_RET - ZZD->ZZD_PIS - ZZD->ZZD_COFINS - nFrtTot)
ZZD->ZZD_CUSTO	:= aNota[9]					       // D2_YCUSTO
ZZD->ZZD_MARGEM	:= Round((nTotNF - QRYSF2->D2_VALIPI - QRYSF2->D2_VALICM - QRYSF2->D2_ICMSRET - nPisco - ZZD->ZZD_FreTot - 0) / nQtdeGra,2)    - aNota[9]	   // Margem de Lucro
ZZD->ZZD_MARGEG	:= Round((nTotNFG - nIpiG - nIcmsG - nIcmsRetG - nPiscoG - ZZD->ZZD_FreTot - 0) / nQtdeGra,2)   -  aNota[9]	   // Margem de Lucro

nPO := Round((nTotNFG - nIpiG - nIcmsG - nIcmsRetG - nPiscoG - nFrtTot - 0) / nQtdeGra,2)
nPO -= If(cTipCar = "S",nCustSac,0)
ZZD->ZZD_YPEDAG := 0//SF2->F2_YPEDAG
ZZD->ZZD_YCTR  	:= ""//SF2->F2_YCTR
ZZD->ZZD_YSERCT := ""//SF2->F2_YSERCTR
ZZD->ZZD_IRCSL  := IF(ZZD->ZZD_MARGEM > 0 ,(nQtdeGra * ZZD->ZZD_MARGEM * wPIRCSL),0)
ZZD->ZZD_IRCSLG := IF(ZZD->ZZD_MARGEG > 0 ,(nQtdeGra * ZZD->ZZD_MARGEG * wPIRCSL),0)
aZZD				:= GetArea("ZZD")

If Alltrim(cTipCar) $ "CDC*G"
	ZZD->ZZD_PERFIL := "GRANEL"
ELSEIF cTipCar = "S"
	ZZD->ZZD_PERFIL := "TAMBOR"
Endif

ZZD->ZZD_CFOP   := aNota[13]       //COGIGO FISCAL DA NF
ZZD->ZZD_TIPONF := SF2->F2_TIPO
ZZD->ZZD_TIPOMT := aProduto[12]
ZZD->ZZD_DESTES := cDESTES[2]
ZZD->ZZD_QTCIF  := iif(  ZZD->ZZD_TPFRE=='C', ZZD->ZZD_QTLIQ , 0 )
ZZD->ZZD_MARTOT := (ZZD->ZZD_MARGEG*ZZD->ZZD_QTLIQ)+ZZD->ZZD_DEICDC
ZZD->ZZD_FRE3U  := nFRE3Un
ZZD->ZZD_YMUN   := SA1->A1_MUN
ZZD->ZZD_YEST   := SA1->A1_EST

IF ZZD->(FieldPos("ZZD_NREDUZ")) > 0
	ZZD->ZZD_NREDUZ:= SA1->A1_NREDUZ
ENDIF

IF SF2->F2_TIPO <> 'D'
	ZZD->ZZD_GRPVEN  := POSICIONE("SA1",1,XFILIAL("SA1")+SF2->F2_CLIENTE,"A1_GRPVEN")
ENDIF

ZZD->ZZD_DESGRU  := POSICIONE("SBM",1,XFILIAL("SBM")+cGrupo,"BM_DESC")
/*
DO CASE
CASE ZZD->ZZD_GRUPO == '0020'
ZZD->ZZD_YCC := '010101'
CASE ZZD->ZZD_GRUPO == '0021'
ZZD->ZZD_YCC := '010102'
CASE ZZD->ZZD_GRUPO == '0022'
ZZD->ZZD_YCC := '010103'
CASE ZZD->ZZD_GRUPO == '0023'
ZZD->ZZD_YCC := '010104'
CASE ZZD->ZZD_GRUPO == '0024'
ZZD->ZZD_YCC := '010105'
ENDCASE
*/
ZZD->ZZD_YCC    := aNota[17]  // CENTRO DE CUSTO
ZZD->ZZD_DESCCC := POSICIONE('CTT',1,XFILIAL('CTT')+ZZD->ZZD_YCC,"CTT_DESC01" )
ZZD->ZZD_QTLIQ  := aNota[18]  // QTDE OURO FUNDIDO
zzd->zzd_itemct:= posicione('SB1',1,xfilial('SB1')+aNota[1],'B1_ITEMCC')

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
//endif
zzd->zzd_desite:= posicione('CTD',1,xfilial('CTD')+zzd->zzd_itemct,'CTD_DESC01')

If SF2->F2_TIPO = "D"
	ZZD->ZZD_PISNF  := nPisNF * -1
	ZZD->ZZD_COFNF  := nCOFNF * -1
Else
	ZZD->ZZD_PISNF  := nPisNF
	ZZD->ZZD_COFNF  := nCOFNF
Endif

DbSelectArea("ZZD")
MsUnlock()
RestArea(aZZD)



Return 'fim'

// PESQUISA "CADASTRO DE CLIENTES" - SA1
Static Function fPesqSA1()
DbSelectArea("SA1")
aArea := GetArea()
DbSetOrder(1)
If DbSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA)
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
		aAdd(aCliente, "")
		aAdd(aCliente, "")
		RestArea(aArea)
	EndIf
EndIf

Return aCliente

// PESQUISA "CADASTRO DE PRODUTOS" - SB1
Static Function fPesqSB1()

DbSelectArea("SB1")
aArea := GetArea()
DbSetOrder(1)
DbSeek(xFilial('SB1') + aNota[1])
Private aProduto:= {}
//aAdd(aProduto, iif( (SB1->B1_TIPO $ "PA*MP*EM") .AND. SB1->B1_YFAT =='S' ,.T.,.F.))   // 1 Produto Acabado?
aAdd(aProduto, iif( (SB1->B1_TIPO $ "PA*MP*EM*PV*ME") ,.T.,.F.))   // 1 Produto Acabado?
aAdd(aProduto, SB1->B1_TIPO)					   // 2 Tipo de produto
aAdd(aProduto, SB1->B1_PRV1)					   // 3 Preco de venda
aAdd(aProduto, alltrim(SB1->B1_TIPCAR)) 					   // 4 Tipo de carga
aAdd(aProduto, 0)						//5 Preco gerencial

dbSelectArea("SB1")
aAdd(aProduto, SB1->B1_UM)						//6 1a Unidade de Medida
aAdd(aProduto, SB1->B1_CONV)					//7 Fator de Conversao
aAdd(aProduto, LEFT(SB1->B1_DESC,20))			//8 Descricao
//aAdd(aProduto, LEFT(SB1->B1_YDESCRE,20))		//9 Descricao Resumida
aAdd(aProduto, LEFT("",20))						//9 Descricao Resumida

//cQuery:= "SELECT * FROM "+RETSQLNAME('ZZG')+" WHERE  ZZG_GRUPO = '"+SB1->B1_GRUPO+"' AND ZZG_COD = '"+SB1->B1_SUBGRUP+"' AND D_E_L_E_T_  <> '*' "

//If Select('TRB')>0
//	dbSelectArea("TRB")
//	DbCloseArea()
//Endif
//TCQuery cQuery NEW ALIAS "TRB"

aAdd(aProduto, Posicione('SBM',1,xFilial('SBM')+SB1->B1_GRUPO,'BM_DESC')  )        // 10 Descricao do Grupo
//aAdd(aProduto, Alltrim(TRB->ZZG_DESC))	// 11 Descricao do SubGrupo
aAdd(aProduto, "")							// 11 Descricao do SubGrupo
aAdd(aProduto, Alltrim(SB1->B1_TIPO))   	// 12 TIPO DA NF
aAdd(aProduto, Alltrim(SB1->B1_TIPCONV))    // 13 TIPO DE CONVERSAO M / D

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
DbSetOrder(4)

If DbSeek(xFilial("SC6") + SF2->F2_DOC + SF2->F2_SERIE)
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
	If SF2->F2_TPFRETE=="C"
		cModFrete := "CIF"
	ElseIf SF2->F2_TPFRETE=="F"
		cModFrete := "FOB"
	ElseIf SF2->F2_TPFRETE=="T"
		cModFrete := "TER"
	ElseIf SF2->F2_TPFRETE=="S"
		//cModFrete := "SEM"
		cModFrete := "CIF"
	endif
	
	ctpFrete:= SF2->F2_TPFRETE
	
	sc5->(dbseek(xfilial('SC5')+sf2->(f2_doc+f2_serie)))
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

DbSelectArea("SD2")
aArea := GetArea()
DbSetOrder(3)
DbSeek(xFilial('SD2') + SF2->F2_DOC + SF2->F2_SERIE)
Private aNota:= {}
aAdd(aNota, QRYSF2->D2_COD)		    // 1 Codigo produto
aAdd(aNota, QRYSF2->D2_PRCVEN)		// 2 Preco unitario
aAdd(aNota, QRYSF2->D2_QUANT)		// 3 Quantidade na nota
aAdd(aNota, "")					    // 4 Placa
aAdd(aNota, QRYSF2->D2_TES)		    // 5 TES
aAdd(aNota, QRYSF2->D2_PICM)		// 6 Aliquota ICMS
//aAdd(aNota, QRYSF2->D2_YCUSTRA)	// 7 Custo de transferencia (unitario)
//aAdd(aNota, QRYSF2->D2_YCUSTO)		// 9 Custo (R$/T)
//aAdd(aNota, QRYSF2->D2_YCSTSAC)	// 10 Custo Sacaria

aAdd(aNota, 0)	                    // 7 Custo de transferencia (unitario)
aAdd(aNota, QRYSF2->D2_YPRG)    	// 8 Preco Gerencial
aAdd(aNota, 0)						// 9 Custo (R$/T)
aAdd(aNota, 0)						// 10 Custo Sacaria
aAdd(aNota, QRYSF2->D2_VALIMP5)	    // 11 PIS
aAdd(aNota, QRYSF2->D2_VALIMP6)	    // 12 COFINS
aAdd(aNota, QRYSF2->D2_CF)			// 13 CFOP
aAdd(aNota, QRYSF2->D2_UM)			// 14 UM
aAdd(aNota, QRYSF2->D2_GRUPO)		// 15 UM
aAdd(aNota, QRYSF2->D2_VALFRE)		// 16 VALOR DO FRETE - RATEADO PELA QUANTIDADE
aAdd(aNota, QRYSF2->D2_YCR)		    // 17 CENTRO DE CUSTO

If Alltrim(cEmpAnt) == "06"
	aAdd(aNota, QRYSF2->D2_YQTDFUN)	    // 18 QTDE OURO FUNDIDO
Else
	aAdd(aNota, 0  )
Endif

RestArea(aArea)
Return aNota

Static Function fPesqSE4()

DbSelectArea("SE4")
aArea := GetArea()
DbSetOrder(1)
DbSeek(xFilial("SE2") + SF2->F2_COND)
Private nResposta:= 0//SE4->E4_YMEDIA

RestArea(aArea)

Return nResposta

Static Function fPesqSF4()

DbSelectArea("SF4")
aArea := GetArea()
DbSetOrder(1)
DbSeek(xFilial('SF4') + aNota[5])

cResposta:= "" //SF4->F4_YINFEX
Private cResposta2:= SF4->F4_TEXTO

RestArea(aArea)

Return ({cResposta,cResposta2})

Static  Function fPesqZZA(cChave)

//DbSelectArea("ZZA")
aArea := GetArea()

//DbSetOrder(1)
//DbSeek(cChave)
Private cResposta:= ""//ZZA->ZZA_CONTEU
RestArea(aArea)

Return cResposta

Static  Function fPesqSX5()

DbSelectArea("SX5")
aArea := GetArea()
DbSetOrder(1)
DbSeek(xFilial('SX5') + "YI"+ iif(!Empty(aCliente[3]),aCliente[3],aCliente[2]))
Private cResposta:= SX5->X5_DESCRI
RestArea(aArea)
Return cResposta

Static  Function fPesqSZ8()

//DbSelectArea("SZ8")
aArea := GetArea()
//DbSetOrder(1)
//DbSeek(xFilial('SZ8')+SF2->F2_YOC)
Private aOrdem:= {}
Private cTempo:= "  :  "
//If SZ8->Z8_HORPES <> cTempo .And. SZ8->Z8_HSAIDA <> cTempo
//	cTempo:= ElapTime(SZ8->Z8_HORPES+":00",SZ8->Z8_HSAIDA+":00")
//Else
cTempo:= "00:00"
//EndIf
aAdd(aOrdem, cTempo) 			// 1 Tempo decorrido entre a hora do peso e a hora da saida do caminhao
//aAdd(aOrdem, SZ8->Z8_PSSAI)		// 2 Peso de saida do caminhao
aAdd(aOrdem, 0)		// 2 Peso de saida do caminhao

//aAdd(aOrdem, SZ8->Z8_QUANT)     // 3 Quantidade da Orderm de Carregamento
aAdd(aOrdem, 0)

//aAdd(aOrdem, SZ8->Z8_YDTLIB)    // 4 Data Liberacao
aAdd(aOrdem, ctod(""))

//aAdd(aOrdem, SZ8->Z8_DTSAIDA)   // 5 Data Saida
aAdd(aOrdem, ctod(""))

//aAdd(aOrdem, SZ8->Z8_OC)        // 6 Numero da Ordem de Carregamento
aAdd(aOrdem, "")

//aAdd(aOrdem, SZ8->Z8_HORPES)    // 7 Hora da Pesagem
aAdd(aOrdem, "00:00")

//aAdd(aOrdem, SZ8->Z8_HSAIDA)    // 8 Hora da Saida
aAdd(aOrdem, "00:00")

//dbSelectArea("SZ1")
//aAdd(aOrdem, SZ1->Z1_YDTLIB) // 9 Data Liberacao Pedido
aAdd(aOrdem, ctod("//"))

//aAdd(aOrdem, SZ1->Z1_HLIB) // 10 Hora Liberação Pedido
aAdd(aOrdem, "00:00")

//DbSelectArea("SZ8")

RestArea(aArea)
Return aOrdem

// PESQUISA "CADASTRO DE REGIOES" - SZO
Static  Function fPesqSZO()

//DbSelectArea("SZO")
aArea := GetArea()

//DbSetOrder(1)
//DbSeek(xFilial('SZO') + cRegiao)
Private cResposta:= "" //SZO->ZO_DESC

RestArea(aArea)

Return cResposta

// PESQUISA "TABELA DE ESTADOS/CIDADES" - SZ4
Static  Function fPesqSZ4()

//DbSelectArea("SZ4")
aArea := GetArea()
//DbSetOrder(1)
//DbSeek(SF2->F2_FILIAL + SF2->F2_EST + SF2->F2_YMUNE)
Private cResposta:= "" //SZ4->Z4_REGIAO

RestArea(aArea)

Return cResposta

Static  Function fCalcPoG(cTipCar, nTotNFG, nIpig, nIcmsg, nPiscoG, nFrtTot, nQtdeGra, nCustSac, nIRCSLG)

Private nCalcPoG:= 0

nCalcPoG:= (ZZD->ZZD_TOTNF - ZZD->ZZD_IPI - ZZD->ZZD_ICMS - ZZD->ZZD_RET - ZZD->ZZD_PIS - ZZD->ZZD_COFINS - nFrtTot  )/nQtdeGra

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

Restarea(warea)

Return
