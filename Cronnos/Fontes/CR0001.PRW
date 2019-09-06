#include "rwmake.ch"

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦  CR0001  ¦ Autor ¦   Alexandro da Silva  ¦ Data ¦ 14/08/06 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Nota Fiscal de Entrada/Saida                               ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Faturamento                                                ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function CR0001()


Private _aValZFR, _nValDEsc,_nPag,_nPagTot

//+--------------------------------------------------------------+
//¦ Define Variaveis Ambientais                                  ¦
//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01             // Da Nota Fiscal                       ¦
//¦ mv_par02             // Ate a Nota Fiscal                    ¦
//¦ mv_par03             // Da Serie                             ¦
//¦ mv_par04             // Nota Fiscal de Entrada/Saida         ¦
//+--------------------------------------------------------------+

CbTxt  		:= ""
CbCont 		:= ""
nOrdem 		:= 0
Alfa   		:= 0
Z      		:= 0
M      		:= 0
tamanho		:= "G"
limite 		:= 220
titulo 		:= PADC("Nota Fiscal - Nfiscal",74)
cDesc1 		:= PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida",74)
cDesc2 		:= ""
cDesc3 		:= PADC("da Nfiscal",74)
cNatureza	:= ""
aReturn     := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog    := "CR0001"
cPerg       := "NFSIGW"
nLastKey    := 0
lContinua   := .T.
nLin        := 0
wnrel       := "CR0001"
WIMPL       := ""
WBASE18     := 0
WBASE12     := 0
WBASE7      := 0
WRED18      := 0
WRED12      := 0
WRED7       := 0
WREDPROD    := "N"
WMENREDALIQ := ""
Private xPCM
Private	xAFM
Private	xAEM

nTamNf:=72

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SF2"

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

VerImp()

RptStatus({|| RptDetail()})

Return


Static Function RptDetail()

If mv_par04 == 2
	dbSelectArea("SF2")                // * Cabecalho da Nota Fiscal Saida
	dbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
	dbSetOrder(3)
	dbSeek(xFilial()+mv_par01+mv_par03)
	cPedant := SD2->D2_PEDIDO
Else
	dbSelectArea("SF1")                // * Cabecalho da Nota Fiscal Entrada
	DbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD1")                // * Itens da Nota Fiscal de Entrada
	dbSetOrder(3)
Endif

SetRegua(Val(mv_par02)-Val(mv_par01))

If mv_par04 == 2
	dbSelectArea("SF2")
	While !eof() .and. SF2->F2_DOC    <= mv_par02 .and. lContinua
		
		IncRegua()
		
		If SF2->F2_SERIE #mv_par03
			DbSkip()
			Loop
		Endif
		
		IF lAbortPrint
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
		
		nLinIni		:=nLin                         // Linha Inicial da Impressao
		
		_lCart := .F.                         // Linha Inicial da Impressao
		
		xNUM_NF     :=SF2->F2_DOC             // Numero
		xSERIE      :=SF2->F2_SERIE           // Serie
		xEMISSAO    :=SF2->F2_EMISSAO         // Data de Emissao
		xTOT_FAT    :=SF2->F2_VALFAT          // Valor Total da Fatura
		
		If xTOT_FAT == 0
			xTOT_FAT := SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE
		Endif
		xLOJA       :=SF2->F2_LOJA            // Loja do Cliente
		xFRETE      :=SF2->F2_FRETE           // Frete
		xSEGURO     :=SF2->F2_SEGURO          // Seguro
		xBASE_ICMS  :=SF2->F2_BASEICM         // Base   do ICMS
		xBASE_IPI   :=SF2->F2_BASEIPI         // Base   do IPI
		xVALOR_ICMS :=SF2->F2_VALICM          // Valor  do ICMS
		xICMS_RET   :=SF2->F2_ICMSRET         // Valor  do ICMS Retido
		xVALOR_IPI  :=SF2->F2_VALIPI          // Valor  do IPI
		xVALOR_MERC :=SF2->F2_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC :=SF2->F2_DUPL            // Numero da Duplicata
		xCOND_PAG   :=SF2->F2_COND            // Condicao de Pagamento
		xPBRUTO     :=SF2->F2_PBRUTO          // Peso Bruto
		XPVIDE      :=SF2->F2_REDESP          //APROVEITADO PARA NF C/MAIS DE 1 PEDIDO (PE MTASF2.PRW)
		xPLIQUI     :=SF2->F2_PLIQUI          // Peso Liquido
		xTIPO       :=SF2->F2_TIPO            // Tipo do Cliente
		xESPECIE    :=SF2->F2_ESPECI1         // Especie 1 no Pedido
		xVOLUME     :=SF2->F2_VOLUME1         // Volume 1 no Pedido
		
		dbSelectArea("SD2")                   // * Itens de Venda da N.F.
		dbSetOrder(3)
		dbSeek(xFilial()+xNUM_NF+xSERIE)
		
		cPedAtu 	:= SD2->D2_PEDIDO
		cItemAtu 	:= SD2->D2_ITEMPV
		
		xPED_VEND	:={}                         // Numero do Pedido de Venda
		xITEM_PED	:={}                         // Numero do Item do Pedido de Venda
		xNUM_NFDV	:={}                         // nUMERO QUANDO HOUVER DEVOLUCAO
		xPREF_DV 	:={}                         // Serie  quando houver devolucao
		xICMS    	:={}                         // Porcentagem do ICMS
		xCOD_PRO 	:={}                         // Codigo  do Produto
		xQTD_PRO 	:={}                         // Peso/Quantidade do Produto
		xPRE_UNI 	:={}                         // Preco Unitario de Venda
		xPRE_TAB 	:={}                         // Preco Unitario de Tabela
		xIPI     	:={}                         // Porcentagem do IPI
		xVAL_IPI 	:={}                         // Valor do IPI
		xDESC    	:={}                         // Desconto por Item
		xVAL_DESC	:={}                         // Valor do Desconto
		xVAL_MERC	:={}                         // Valor da Mercadoria
		//		_aValZFR 	:={}                         // Desconto Zona Franca de Manaus
		xTES     	:={}                         // TES
		xCF      	:={}                         // Classificacao quanto natureza da Operacao
		xICMSOL  	:={}                         // Base do ICMS Solidario
		xICM_PROD	:={}                         // ICMS do Produto
		XBASE_ICM	:= {}                         // BASE DO ICMS DO ITEM
		XFORMULA    :={}
		_nPagTot := 1
		_nContIt := 0

		While !eof() .and. SD2->D2_DOC==xNUM_NF .and. SD2->D2_SERIE==xSERIE
			
			If SD2->D2_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
				DbSkip()                   // do Parametro Informado !!!
				Loop
			Endif
			
			/*
			If SD2->D2_CLIENTE == "000008"
				dbSelectArea("SC6")
				dbSeek(xFilial()+SD2->D2_PEDIDO + SD2->D2_ITEMPV)
				
				dbSelectArea("SZ2")
				dbSetOrder(6)
				If dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_PROCLI)
					_nVal    := 0
					_nPerDes := 0
					If Substr(SC6->C6_PEDCLI,1,4) $ "QAPC/QAPP/QHPP"
						_lCart := .T.
						dDataRef := SZ2->Z2_DTREF01
						_nVal    := SZ2->Z2_PRECO01
						For A := 2 to 12
							If &("SZ2->Z2_DTREF"+StrZero(A,2)) >= dDataRef
								dDataRef := &("SZ2->Z2_DTREF"+StrZero(A,2))
								_nVal   := &("SZ2->Z2_PRECO"+StrZero(A,2))
							Endif
						Next A
						
						dbSelectArea("SB1")
						dbSetOrder(1)
						dbSeek(xFilial()+SD2->D2_COD)
						
						If SB1->B1_PICM > 0
							_nPerDes := SB1->B1_PICM
						Else
							_nPerDes := 18
						Endif
					Endif
					
					_nValICM += (_nVal * SD2->D2_QUANT)  * (_nPerDes/100)
				Endif
			ElseIf SD2->D2_CLIENTE == "000026" .And. SD2->D2_LOJA == "02"
				dbSelectArea("SC6")
				dbSeek(xFilial()+SD2->D2_PEDIDO + SD2->D2_ITEMPV)
				
				dbSelectArea("SZ2")
				dbSetOrder(6)
				If dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_PROCLI)
					_nVal    := 0
					_nPerDes := 0
					_lCart := .T.
					dDataRef := SZ2->Z2_DTREF01
					_nVal    := SZ2->Z2_PRECO01
					For A := 2 to 12
						If &("SZ2->Z2_DTREF"+StrZero(A,2)) >= dDataRef
							dDataRef := &("SZ2->Z2_DTREF"+StrZero(A,2))
							_nVal   := &("SZ2->Z2_PRECO"+StrZero(A,2))
						Endif
					Next A
					
					dbSelectArea("SB1")
					dbSetOrder(1)
					dbSeek(xFilial()+SD2->D2_COD)
					
					If SB1->B1_PICM > 0
						_nPerDes := SB1->B1_PICM
					Else
						_nPerDes := 18
					Endif
					_nValICM += (_nVal * SD2->D2_QUANT)  * (_nPerDes/100)
				Endif
			Endif
			  */
			_nContIt++
			AADD(xPED_VEND ,SD2->D2_PEDIDO)
			AADD(xITEM_PED ,SD2->D2_ITEMPV)
			AADD(xNUM_NFDV ,IIF(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI))
			AADD(xPREF_DV  ,SD2->D2_SERIORI)
			AADD(xICMS     ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
			AADD(xCOD_PRO  ,SD2->D2_COD)
			AADD(xQTD_PRO  ,SD2->D2_QUANT)     // Guarda as quant. da NF
			AADD(xPRE_UNI  ,SD2->D2_PRCVEN)
			AADD(xPRE_TAB  ,SD2->D2_PRUNIT)
			AADD(xIPI      ,IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI))
			AADD(xVAL_IPI  ,SD2->D2_VALIPI)
			AADD(xDESC     ,SD2->D2_DESC)
			AADD(xVAL_MERC ,SD2->D2_TOTAL)
			//			AADD(_aValZFR  ,SD2->D2_DESCZFR)
			AADD(xTES      ,SD2->D2_TES)
			AADD(xCF       ,SD2->D2_CF)
			AADD(xICM_PROD ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
			AADD(xBASE_ICM ,SD2->D2_BASEICM)
			//			_nValDesc += SD2->D2_DESCZFR
			//			xDescZFR:= xDescZFR + SD2->D2_DESCZFR
							
			If _nContIt > 09
				_nPagTot++
				_nContIt := 1
			Endif
			
			dbSelectArea("SD2")
			dbskip()
		EndDo
		
		dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
		DbSetOrder(1)
		dbSeek(xFilial()+xTES[1])
		xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
		
		dbSelectArea("SB1")                     // * Desc. Generica do Produto
		dbSetOrder(1)
		xPESO_PRO	:= {}                           // Peso Liquido
		xPESO_UNIT	:= {}                         // Peso Unitario do Produto
		xDESCRICAO 	:= {}                         // Descricao do Produto
		xUNID_PRO	:= {}                           // Unidade do Produto
		xCOD_TRIB	:= {}                           // Codigo de Tributacao
		xMEN_TRIB	:= {}                           // Mensagens de Tributacao
		xCOD_FIS 	:= {}                           // Cogigo Fiscal
		xCLAS_FIS	:= {}                           // Classificacao Fiscal
		xMEN_POS 	:= {}                           // Mensagem da Posicao IPI
		xISS     	:= {}                           // Aliquota de ISS
		xTIPO_PRO	:= {}                           // Tipo do Produto
		xLUCRO   	:= {}                           // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL   := {}
		xPESO_LIQ 	:= 0
		I			:= 1
		
		For I:=1 to Len(xCOD_PRO)
			
			dbSeek(xFilial()+xCOD_PRO[I])
			AADD(xPESO_PRO ,SB1->B1_PESO * xQTD_PRO[I])
			xPESO_LIQ  := xPESO_LIQ + xPESO_PRO[I]
			AADD(xPESO_UNIT , SB1->B1_PESO)
			AADD(xUNID_PRO ,SB1->B1_UM)
			AADD(xDESCRICAO ,SB1->B1_DESC)
			AADD(xCOD_TRIB ,SB1->B1_ORIGEM+SF4->F4_SITTRIB)
			If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
				AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
			Endif
			
			npElem 			:= ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
			if npElem == 0
				AADD(xCLAS_FIS  ,SB1->B1_POSIPI)
			endif
			
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
			If Empty(SB1->B1_POSIPI)
				_CLASFIS := "84149020"
			Else
				_CLASFIS := Alltrim(SB1->B1_POSIPI)
			Endif
			nPteste := Ascan(xCLFISCAL,_CLASFIS)
			If nPteste == 0
				AADD(xCLFISCAL,_CLASFIS)
			Endif
			
			AADD(xCOD_FIS ,_CLASFIS)
			If SB1->B1_ALIQISS > 0
				AADD(xISS ,SB1->B1_ALIQISS)
			Endif
			AADD(xTIPO_PRO ,SB1->B1_TIPO)
			AADD(xLUCRO    ,SB1->B1_PICMRET)
			
			xPESO_LIQUID:=0                                 // Peso Liquido da Nota Fiscal
			For j:=1 to Len(xPESO_PRO)
				xPESO_LIQUID:=xPESO_LIQUID+xPESO_PRO[j]
			Next J
		Next
		
		dbSelectArea("SC5")                            // * Pedidos de Venda
		dbSetOrder(1)
		
		xPED        := {}
		xPESO_BRUTO := 0
		xP_LIQ_PED  := 0
		xPCM        := ""
		xAFM        := ""
		xAEM        := ""
		_aPedExp    := {}
		
		For I:=1 to Len(xPED_VEND)
			
			dbSeek(xFilial()+xPED_VEND[I])
			
			If ASCAN(xPED,xPED_VEND[I])==0
				dbSeek(xFilial()+xPED_VEND[I])
				xCLIENTE    :=SC5->C5_CLIENTE            // Codigo do Cliente
				_cPedExp    := SC5->C5_PEDEXP
				xPCM        := SC5->C5_PCM
				xAFM        := SC5->C5_AFM
				xAEM        := SC5->C5_AEM
				xTIPO_CLI   :=SC5->C5_TIPOCLI            // Tipo de Cliente
				xCOD_MENS   :=SC5->C5_MENPAD             // Codigo da Mensagem Padrao
				xMENSAGEM   :=SC5->C5_MENNOTA            // Mensagem para a Nota Fiscal
				xTPFRETE    :=SC5->C5_TPFRETE            // Tipo de Entrega
				xCONDPAG    :=SC5->C5_CONDPAG            // Condicao de Pagamento
				xPESO_BRUTO :=SC5->C5_PBRUTO             // Peso Bruto
				xP_LIQ_PED  :=xP_LIQ_PED + SC5->C5_PESOL // Peso Liquido
				xPESO_LIQUI :=SC5->C5_PESOL              // Peso Liquido digitado no pedido
				xCOD_VEND:= {SC5->C5_VEND1,;             // Codigo do Vendedor 1
				SC5->C5_VEND2,;             // Codigo do Vendedor 2
				SC5->C5_VEND3,;             // Codigo do Vendedor 3
				SC5->C5_VEND4,;             // Codigo do Vendedor 4
				SC5->C5_VEND5}              // Codigo do Vendedor 5
				xDESC_NF := {SC5->C5_DESC1,;             // Desconto Global 1
				SC5->C5_DESC2,;             // Desconto Global 2
				SC5->C5_DESC3,;             // Desconto Global 3
				SC5->C5_DESC4}              // Desconto Global 4
				AADD(xPED,xPED_VEND[I])
			Endif
			
			If xP_LIQ_PED >0
				xPESO_LIQ := xP_LIQ_PED
			Endif
		Next
		
		dbSelectArea("SE4")                    // Condicao de Pagamento
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+xCONDPAG)
		xDESC_PAG := SE4->E4_DESCRI
		
		dbSelectArea("SC6")                    // * Itens de Pedido de Venda
		dbSetOrder(1)
		xPED_CLI :={}                          // Numero de Pedido
		xDESC_PRO:={}                          // Descricao aux do produto
		xPROD_CLI:={}                          // Codigo da Peça Cliente
		
		J:=Len(xPED_VEND)
		For I:=1 to J
			dbSeek(xFilial()+xPED_VEND[I]+xITEM_PED[I])
			AADD(xPED_CLI ,SC6->C6_PEDCLI)
			AADD(xDESC_PRO,SC6->C6_DESCRI)
			AADD(xVAL_DESC,SC6->C6_VALDESC)
			AADD(xPROD_CLI,SC6->C6_CPROCLI)
		Next
		
		If xTIPO=='N' .OR. xTIPO=='C' .OR. xTIPO=='P' .OR. xTIPO=='I' .OR. xTIPO=='S' .OR. xTIPO=='T' .OR. xTIPO=='O'
			
			dbSelectArea("SA1")                // * Cadastro de Clientes
			dbSetOrder(1)
			dbSeek(xFilial()+xCLIENTE+xLOJA)
			xCOD_CLI 	:=SA1->A1_COD             // Codigo do Cliente
			xNOME_CLI	:=SA1->A1_NOME            // Nome
			xEND_CLI 	:=SA1->A1_END             // Endereco
			xBAIRRO  	:=SA1->A1_BAIRRO          // Bairro
			xCEP_CLI 	:=SA1->A1_CEP             // CEP
			xCOB_CLI 	:=SA1->A1_ENDCOB          // Endereco de Cobranca
			xREC_CLI 	:=SA1->A1_ENDENT          // Endereco de Entrega
			xMUN_CLI 	:=SA1->A1_MUN             // Municipio
			xEST_CLI 	:=SA1->A1_EST             // Estado
			xCGC_CLI 	:=SA1->A1_CGC             // CGC
			xINSC_CLI	:=SA1->A1_INSCR           // Inscricao estadual
			xTRAN_CLI	:=SA1->A1_TRANSP          // Transportadora
			xTEL_CLI 	:=SA1->A1_TEL             // Telefone
			xFAX_CLI 	:=SA1->A1_FAX             // Fax
		Else
			zFranca:=.F.
			dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial()+xCLIENTE+xLOJA)
			xCOD_CLI 	:= SA2->A2_COD             // Codigo do Fornecedor
			xNOME_CLI	:= SA2->A2_NOME            // Nome Fornecedor
			xEND_CLI 	:= SA2->A2_END             // Endereco
			xBAIRRO  	:= SA2->A2_BAIRRO          // Bairro
			xCEP_CLI 	:= SA2->A2_CEP             // CEP
			xCOB_CLI 	:= ""                      // Endereco de Cobranca
			xREC_CLI 	:= ""                      // Endereco de Entrega
			xMUN_CLI 	:= SA2->A2_MUN             // Municipio
			xEST_CLI 	:= SA2->A2_EST             // Estado
			xCGC_CLI 	:= SA2->A2_CGC             // CGC
			xINSC_CLI	:= SA2->A2_INSCR           // Inscricao estadual
			xTRAN_CLI	:= SA2->A2_TRANSP          // Transportadora
			xTEL_CLI 	:= SA2->A2_TEL             // Telefone
			xFAX_CLI 	:= SA2->A2_FAX             // Fax
		Endif
		dbSelectArea("SA3")                   // * Cadastro de Vendedores
		dbSetOrder(1)
		xVENDEDOR:={}                         // Nome do Vendedor
		I:=1
		J:=Len(xCOD_VEND)
		For I:=1 to J
			dbSeek(xFilial()+xCOD_VEND[I])
			Aadd(xVENDEDOR,SA3->A3_NREDUZ)
		Next
		
		If xICMS_RET >0                          // Apenas se ICMS Retido > 0
			dbSelectArea("SF3")                   // * Cadastro de Livros Fiscais
			dbSetOrder(4)
			dbSeek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
			If Found()
				xBSICMRET	:= F3_VALOBSE
			Else
				xBSICMRET	:= 0
			Endif
		Else
			xBSICMRET:=0
		Endif
		dbSelectArea("SA4")                   // * Transportadoras
		dbSetOrder(1)
		dbSeek(xFilial()+SF2->F2_TRANSP)
		xNOME_TRANSP 	:= SA4->A4_NOME           // Nome Transportadora
		xEND_TRANSP  	:= SA4->A4_END            // Endereco
		xMUN_TRANSP  	:= SA4->A4_MUN            // Municipio
		xEST_TRANSP  	:= SA4->A4_EST            // Estado
		xVIA_TRANSP  	:= SA4->A4_VIA            // Via de Transporte
		xCGC_TRANSP  	:= SA4->A4_CGC            // CGC
		xIE_TRANSP   	:= SA4->A4_INSEST         // Inscrição Estadual
		xTEL_TRANSP  	:= SA4->A4_TEL            // Fone
		
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		xPARC_DUP  	:= {}                       // Parcela
		xVENC_DUP  	:= {}                       // Vencimento
		xVALOR_DUP 	:= {}                       // Valor
		xDUPLICATAS:=IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
		While !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			If !("NF" $ SE1->E1_TIPO)
				dbSkip()
				Loop
			Endif
			AADD(xPARC_DUP ,SE1->E1_PARCELA)
			AADD(xVENC_DUP ,SE1->E1_VENCTO)
			AADD(xVALOR_DUP,SE1->E1_VALOR)
			dbSkip()
		EndDo
		
		_lImpr := .T.
		_nPag := 0
		ImpCab()
		ImpDet()
		nLin:=0
		
		dbSelectArea("SF2")
		dbSkip()                      // passa para a proxima Nota Fiscal
	EndDo
Else
	dbSelectArea("SF1")              // * Cabecalho da Nota Fiscal Entrada
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	While !eof() .and. SF1->F1_DOC <= mv_par02 .and. SF1->F1_SERIE == mv_par03 .and. lContinua
		
		IncRegua()
		
		If SF1->F1_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
			DbSkip()                    // do Parametro Informado !!!
			Loop
		Endif
		
		IF lAbortPrint
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
		
		nLinIni:=nLin                         // Linha Inicial da Impressao
		
		xNUM_NF     := SF1->F1_DOC             // Numero
		xSERIE      := SF1->F1_SERIE           // Serie
		xFORNECE    := SF1->F1_FORNECE         // Cliente/Fornecedor
		xEMISSAO    := SF1->F1_EMISSAO         // Data de Emissao
		xTOT_FAT    := SF1->F1_VALBRUT         // Valor Bruto da Compra
		xLOJA       := SF1->F1_LOJA            // Loja do Cliente
		xFRETE      := SF1->F1_FRETE           // Frete
		xSEGURO     := SF1->F1_DESPESA         // Despesa
		xBASE_ICMS  := SF1->F1_BASEICM         // Base   do ICMS
		xBASE_IPI   := SF1->F1_BASEIPI         // Base   do IPI
		xBSICMRET   := SF1->F1_BRICMS          // Base do ICMS Retido
		xVALOR_ICMS := SF1->F1_VALICM          // Valor  do ICMS
		xICMS_RET   := SF1->F1_ICMSRET         // Valor  do ICMS Retido
		xVALOR_IPI  := SF1->F1_VALIPI          // Valor  do IPI
		xVALOR_MERC := SF1->F1_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC := SF1->F1_DUPL            // Numero da Duplicata
		xCOND_PAG   := SF1->F1_COND            // Condicao de Pagamento
		xTIPO       := SF1->F1_TIPO            // Tipo do Cliente
		xNFORI      := SF1->F1_NFORIG          // NF Original
		xPREF_DV    := SF1->F1_SERORIG         // Serie Original
		xPBRUTO     := 0                      // Peso Bruto
		XPVIDE      := ""                      //APROVEITADO PARA NF C/MAIS DE 1 PEDIDO (PE MTASF2.PRW)
		xPLIQUI     := SF1->F1_PeSOL           // Peso Liquido
		xESPECIE    := ""                      // Especie 1 no Pedido
		xVOLUME     := 0                       // Volume 1 no Pedido
		XFORMULA    :={}
		
		dbSelectArea("SD1")                   // * Itens da N.F. de Compra
		dbSetOrder(1)
		dbSeek(xFilial()+xNUM_NF+xSERIE+xFORNECE+xLOJA)
		
		cPedAtu  	:= SD1->D1_PEDIDO
		cItemAtu 	:= SD1->D1_ITEMPC
		xPEDIDO  	:= {}                         // Numero do Pedido de Compra
		xITEM_PED	:= {}                         // Numero do Item do Pedido de Compra
		xNUM_NFDV	:= {}                         // Numero quando houver devolucao
		xPREF_DV 	:= {}                         // Serie  quando houver devolucao
		xICMS    	:= {}                         // Porcentagem do ICMS
		xCOD_PRO 	:= {}                         // Codigo  do Produto
		xQTD_PRO 	:= {}                         // Peso/Quantidade do Produto
		xPRE_UNI 	:= {}                         // Preco Unitario de Compra
		xIPI     	:= {}                         // Porcentagem do IPI
		xPESOPROD	:= {}                         // Peso do Produto
		xVAL_IPI 	:= {}                         // Valor do IPI
		xDESC    	:= {}                         // Desconto por Item
		xVAL_DESC	:= {}                         // Valor do Desconto
		xVAL_MERC	:= {}                         // Valor da Mercadoria
		xTES     	:= {}                         // TES
		xCF      	:= {}                         // Classificacao quanto natureza da Operacao
		xICMSOL  	:= {}                         // Base do ICMS Solidario
		xICM_PROD	:= {}                         // ICMS do Produto
		XBASE_ICM	:= {}                         // BASE DO ICMS DO ITEM
		_nValDesc	:= 0
		
		dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
		dbSetOrder(1)
		dbSeek(xFilial()+SD1->D1_TES)
		xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
		
		dbSelectArea("SD1")                   // * Itens da N.F. de Compra
		
		_nPagTot := 1
		_nContIt := 0
		
		While !eof() .and. SD1->D1_DOC==xNUM_NF
			
			If SD1->D1_SERIE # mv_par03        // Se a Serie do Arquivo for Diferente
				DbSkip()                       // do Parametro Informado !!!
				Loop
			Endif
			
			_nContIt++
			AADD(xPEDIDO ,SD1->D1_PEDIDO)           // Ordem de Compra
			AADD(xITEM_PED ,SD1->D1_ITEMPC)         // Item da O.C.
			AADD(xNUM_NFDV ,IIF(Empty(SD1->D1_NFORI),"",SD1->D1_NFORI))
			AADD(xPREF_DV  ,SD1->D1_SERIORI)        // Serie Original
			AADD(xICMS     ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			AADD(xCOD_PRO  ,SD1->D1_COD)            // Produto
			AADD(xQTD_PRO  ,SD1->D1_QUANT)          // Guarda as quant. da NF
			AADD(xPRE_UNI  ,SD1->D1_VUNIT)          // Valor Unitario
			AADD(xIPI      ,SD1->D1_IPI)            // % IPI
			AADD(xVAL_IPI  ,SD1->D1_VALIPI)         // Valor do IPI
			AADD(xPESOPROD ,SD1->D1_PESO)           // Peso do Produto
			AADD(xDESC     ,SD1->D1_DESC)           // % Desconto
			AADD(xVAL_MERC ,SD1->D1_TOTAL)          // Valor Total
			AADD(xTES      ,SD1->D1_TES)            // Tipo de Entrada/Saida
			AADD(xCF       ,SD1->D1_CF)             // Codigo Fiscal
			AADD(xICM_PROD ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			AADD(XBASE_ICM ,SD1->D1_BASEICM)
			
			If _nContIt > 09
				_nPagTot++
				_nContIt := 1
			Endif
			
			dbskip()
		EndDo
		
		dbSelectArea("SB1")                     	// * Desc. Generica do Produto
		dbSetOrder(1)
		xUNID_PRO	:= {}                           // Unidade do Produto
		xDESC_PRO	:= {}                           // Descricao do Produto
		xMEN_POS 	:= {}                           // Mensagem da Posicao IPI
		xDESCRICAO  := {}                           // Descricao do Produto
		xCOD_TRIB	:= {}                           // Codigo de Tributacao
		xIMPLAGRICOLA:={}					        // Implemento Agricola (se é ou não é)
		xMEN_TRIB	:= {}                           // Mensagens de Tributacao
		xCOD_FIS 	:= {}                           // Cogigo Fiscal
		xCLAS_FIS	:= {}                           // Classificacao Fiscal
		xISS     	:= {}                           // Aliquota de ISS
		xTIPO_PRO	:= {}                           // Tipo do Produto
		xLUCRO   	:= {}                           // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL   := {}
		xSUFRAMA 	:= ""
		xCALCSUF 	:= ""
		
		I:=1
		For I:=1 to Len(xCOD_PRO)
			dbSelectArea("SB1")
			dbsetorder(1)
			dbSeek(xFilial()+xCOD_PRO[I])
			AADD(xDESC_PRO ,SB1->B1_DESC)
			AADD(xUNID_PRO ,SB1->B1_UM)
			AADD(xCOD_TRIB ,SB1->B1_ORIGEM+SF4->F4_SITTRIB)
			If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
				AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
			Endif
			AADD(xDESCRICAO ,SB1->B1_DESC)
			AADD(xMEN_POS  ,SB1->B1_POSIPI)
			If SB1->B1_ALIQISS > 0
				AADD(xISS,SB1->B1_ALIQISS)
			Endif
			AADD(xTIPO_PRO ,SB1->B1_TIPO)
			AADD(xLUCRO    ,SB1->B1_PICMRET)
			
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
			if len(alltrim(SB1->B1_POSIPI)) <> 0
				AADD(xCLAS_FIS  ,SB1->B1_POSIPI)
			else
				AADD(xCLAS_FIS  ,"          ")
			endif
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
			DO CASE
				CASE npElem == 1
					_CLASFIS := "A"
					
				CASE npElem == 2
					_CLASFIS := "B"
					
				CASE npElem == 3
					_CLASFIS := "C"
					
				CASE npElem == 4
					_CLASFIS := "D"
					
				CASE npElem == 5
					_CLASFIS := "E"
					
				CASE npElem == 6
					_CLASFIS := "F"
			EndCase
			nPteste := Ascan(xCLFISCAL,_CLASFIS)
			If nPteste == 0
				AADD(xCLFISCAL,_CLASFIS)
			Endif
			AADD(xCOD_FIS ,_CLASFIS)
		Next
		
		dbSelectArea("SE4")
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+xCOND_PAG)
		xDESC_PAG := SE4->E4_DESCRI
		
		If xTIPO == "D"
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial()+xFORNECE)
			xCOD_CLI 	:= SA1->A1_COD             // Codigo do Cliente
			xNOME_CLI	:= SA1->A1_NOME            // Nome
			xEND_CLI 	:= SA1->A1_END             // Endereco
			xBAIRRO  	:= SA1->A1_BAIRRO          // Bairro
			xCEP_CLI 	:= SA1->A1_CEP             // CEP
			xCOB_CLI 	:= SA1->A1_ENDCOB          // Endereco de Cobranca
			xREC_CLI 	:= SA1->A1_ENDENT          // Endereco de Entrega
			xMUN_CLI 	:= SA1->A1_MUN             // Municipio
			xEST_CLI 	:= SA1->A1_EST             // Estado
			xCGC_CLI 	:= SA1->A1_CGC             // CGC
			xINSC_CLI	:= SA1->A1_INSCR           // Inscricao estadual
			xTRAN_CLI	:= SA1->A1_TRANSP          // Transportadora
			xTEL_CLI 	:= SA1->A1_TEL             // Telefone
			xFAX_CLI 	:= SA1->A1_FAX             // Fax
		Else
			dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial()+xFORNECE+xLOJA)
			xCOD_CLI 	:= SA2->A2_COD                // Codigo do Cliente
			xNOME_CLI	:= SA2->A2_NOME               // Nome
			xEND_CLI 	:= SA2->A2_END                // Endereco
			xBAIRRO  	:= SA2->A2_BAIRRO             // Bairro
			xCEP_CLI 	:= SA2->A2_CEP                // CEP
			xCOB_CLI 	:= ""                         // Endereco de Cobranca
			xREC_CLI 	:= ""                         // Endereco de Entrega
			xMUN_CLI 	:= SA2->A2_MUN                // Municipio
			xEST_CLI 	:= SA2->A2_EST                // Estado
			xCGC_CLI 	:= SA2->A2_CGC                // CGC
			xINSC_CLI	:= SA2->A2_INSCR              // Inscricao estadual
			xTRAN_CLI	:= SA2->A2_TRANSP             // Transportadora
			xTEL_CLI 	:= SA2->A2_TEL                // Telefone
			xFAX     	:= SA2->A2_FAX                // Fax
		EndIf
		
		dbSelectArea("SE2")                   // * Contas a Receber SE2 **** TALVEZ
		dbSetOrder(1)
		xPARC_DUP  	:= {}                       // Parcela
		xVENC_DUP  	:= {}                       // Vencimento
		xVALOR_DUP 	:= {}                       // Valor
		xDUPLICATAS	:= IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
		While !eof() .and. SE2->E2_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			AADD(xPARC_DUP ,SE2->E2_PARCELA)
			AADD(xVENC_DUP ,SE2->E2_VENCTO)
			AADD(xVALOR_DUP,SE2->E2_VALOR)
			dbSkip()
		EndDo
		
		xNOME_TRANSP := " "           // Nome Transportadora
		xEND_TRANSP  := " "           // Endereco
		xMUN_TRANSP  := " "           // Municipio
		xEST_TRANSP  := " "           // Estado
		xIE_TRANSP   := " "           // Inscrição Estadual
		xVIA_TRANSP  := " "           // Via de Transporte
		xCGC_TRANSP  := " "           // CGC
		xTEL_TRANSP  := " "           // Fone
		xTPFRETE     := " "           // Tipo de Frete
		xVOLUME      := 0            // Volume
		xESPECIE     := " "           // Especie
		xPESO_LIQ    := 0            // Peso Liquido
		xPESO_BRUTO  := 0            // Peso Bruto
		xCOD_MENS    := " "           // Codigo da Mensagem
		xMENSAGEM    := " "           // Mensagem da Nota
		xPESO_LIQUID := " "
		
		_nPag := 0
		ImpCab()
		ImpDet()
		nLin:=0
		dbSelectArea("SF1")
		dbSkip()
	EndDo
Endif

Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return


Static Function VerImp()

nLin	:= 0                // Contador de Linhas
nLinIni := 0
If aReturn[5]==2
	
	nOpc := 1
	
	While .T.
		SetPrc(0,0)
		dbCommitAll()
		
		@ nLin ,000 PSAY " "
		@ nLin ,004 PSAY "*"
		@ nLin ,022 PSAY "."
		IF MsgYesNo("Fomulario esta posicionado ? ")
			nOpc := 1
		ElseIF MsgYesNo("Tenta Novamente ? ")
			nOpc := 2
		Else
			nOpc := 3
		Endif
		
		Do Case
			Case nOpc==1
				lContinua:=.T.
				Exit
			Case nOpc==2
				Loop
			Case nOpc==3
				lContinua:=.F.
				Return
		EndCase
	End
Endif

Return


Static Function ImpCab()

_nPag++
@ 00, 000 PSAY Chr(15)                // Compressao de Impressao
@ 01, 127 PSAY xNUM_NF               // Numero da Nota Fiscal

If mv_par04 == 1
	@ 02, 109 PSAY "XX"
Else
	@ 02, 95 PSAY "XX"
Endif

@ 04, 127 PSAY "FL.: "+StrZero(_nPag,2)+"/"+StrZero(_nPagTot,2)
@ 06, 004 PSAY xNATUREZA

If mv_par04 == 1
	@ 06, 050 PSAY xCF[1] Picture PESQPICT("SD1","D1_CF") // Codigo da Natureza de Operacao
Else
	@ 06, 050 PSAY xCF[1] Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
EndIf

@ 09, 004 PSAY xNOME_CLI              //Nome do Cliente

If !EMPTY(xCGC_CLI)                   // Se o C.G.C. do Cli/Forn nao for Vazio
	@ 09, 093 PSAY xCGC_CLI Picture"@R 99.999.999/9999-99"
Else
	@ 09, 093 PSAY " "                // Caso seja vazio
Endif

@ 09, 127 PSAY xEMISSAO              // Data da Emissao do Documento
@ 11, 004 PSAY xEND_CLI                                 // Endereco
@ 11, 079 PSAY xBAIRRO                                  // Bairro
@ 11, 109 PSAY xCEP_CLI Picture"@R 99999-999"           // CEP
@ 11, 127 PSAY " "                                      // Reservado  p/Data Saida/Entrada

@ 13, 004 PSAY xMUN_CLI                               // Municipio
@ 13, 048 PSAY SUBSTR(xTEL_CLI,1,35)                  // Telefone/FAX
@ 13, 084 PSAY xEST_CLI                               // U.F.
@ 13, 093 PSAY xINSC_CLI                              // Insc. Estadual
@ 13, 127 PSAY " "                                    // Reservado p/Hora da Saida

If mv_par04 == 2
	@ 16, 004      PSAY xEMISSAO
	@ 16, 030      PSAY XNUM_NF
	@ 16, 055      PSAY xTOT_FAT    Picture("@E 9,999,999.99")
	@ 16, 077      PSAY "VIDE DESDOBRAMENTO ABAIXO"
Endif

@ 20, 004 PSAY xCOB_CLI          // Endereco de Cobrança

_cExtenso := Extenso(xTot_Fat,.F.,)

If xTipo != "I"
	@ 22, 004 PSAY _cExtenso         // Valor Por Extenso
Endif

Return


Static Function IMPDET()

@ 25, 000 PSAY Chr(15)                // Compressao de Impressao
nLin	   := 25
I		   := 1
J		   := 1
_nCont     := 0
_lImpRod   := .F.

If xTipo == "N" .And. MV_PAR04 == 2
	For I:=1 to Len(xCOD_PRO)
		_nCont+=2
		
		/*
		003826          PED.CLIENTE: 123456789 PED.PASY+IT :12345689
		123456789012345678901234567-901234567890123
		9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
		1               17                                    55   60       69 72           85                  105           119 123
		*/
		
		If xTIPO_PRO[I] != "FR"
			@ nLin,  004  PSAY "PED.CLIENTE: "+Alltrim(xPED_CLI[I])+" PED.PASY+IT :"+xPED_VEND[I]+xITEM_PED[I]
			nLin:= nLin+1
			@ nLin,  004  PSAY Alltrim(xCOD_PRO[I])
			@ nLin,  019  PSAY RTrim(Substr(xDESC_PRO[I],1,22))+"-"+RTrim(xPROD_CLI[I])
			@ nLin,  056  PSAY xCOD_FIS[I]
			@ nLin,  066  PSAY xCOD_TRIB[I]
			@ nLin,  071  PSAY xUNID_PRO[I]
			@ nLin,  075  PSAY xQTD_PRO[I]               Picture TM(xQTD_PRO[I],10,2) // "@E 999,999.99"
			@ nLin,  087  PSAY xPRE_UNI[I]               Picture TM(xPRE_UNI[I],13,4) //"@E 999,999.99999"
			@ nLin,  103  PSAY xVAL_MERC[I]              Picture "@E 99,999,999.99"
			@ nLin,  119  PSAY xICM_PROD[I]              Picture "99"
			@ nLin,  122  PSAY xIPI[I]                   Picture "@E 99.99"
			@ nLin,  127  PSAY xVAL_IPI[I]               Picture "@E 9,999,999.99"
		Else
			@ nLin,  04  PSAY "PED.CLIENTE: "+Alltrim(xPED_CLI[I])+" PED.PASY+IT :"+xPED_VEND[I]+xITEM_PED[I]
			nLin:= nLin+1
			@ nLin,  04  PSAY Alltrim(xCOD_PRO[I])
			@ nLin,  19  PSAY RTrim(Substr(xDESC_PRO[I],1,30))
			@ nLin,  56  PSAY xCOD_FIS[I]
			@ nLin,  66  PSAY xCOD_TRIB[I]
			@ nLin,  71  PSAY xUNID_PRO[I]
			@ nLin,  75  PSAY xQTD_PRO[I]               Picture TM(xQTD_PRO[I],10,2) // "@E 999,999.99"
			@ nLin,  87  PSAY xPRE_UNI[I]               Picture TM(xPRE_UNI[I],13,4) //"@E 999,999.99999"
			@ nLin, 103  PSAY xVAL_MERC[I]              Picture "@E 99,999,999.99"
			@ nLin, 119  PSAY xICM_PROD[I]              Picture "99"
			@ nLin, 122  PSAY xIPI[I]                   Picture "@E 99.99"
			@ nLin, 127  PSAY xVAL_IPI[I]               Picture "@E 9,999,999.99"
		Endif
		
		_lEntr := .F.
		If _nCont == 18  .And. Len(xCOD_PRO) >= 15 .And.  Len(xCOD_PRO) <= 16
//		If _nCont == 14  .And. Len(xCOD_PRO) >= 15 .And.  Len(xCOD_PRO) <= 16
			ImpRod1()
			ImpCab()
			nLin   := 25
			_nCont := 0
			_lEntr := .T.
			//		ElseIf _nCont == 18  .And. I != Len(xCOD_PRO)
		ElseIf _nCont == 18  .And. I != Len(xCOD_PRO) //.Or. (I+1 ==Len(xCOD_PRO))
			ImpRod1()
			ImpCab()
			nLin   := 25
			_nCont := 0
			_lEntr := .T.
		Endif
		If !_lEntr
			nLin :=nLin+1
		Endif
	Next I
ElseIf !xTipo $ "I/P"
	For I:=1 to Len(xCOD_PRO)
		_nCont+=2
		/*
		003826          PED.CLIENTE: 123456789 PED.PASY+IT :12345689
		123456789012345678901234567-901234567890123
		9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
		1               17                                    55   60       69 72           85                  105           119 123
		*/
		
		@ nLin,  04  PSAY Alltrim(xCOD_PRO[I])
		@ nLin,  19  PSAY RTrim(Substr(xDESCRICAO[I],1,22))
		@ nLin,  56  PSAY xCOD_FIS[I]
		@ nLin,  66  PSAY xCOD_TRIB[I]
		@ nLin,  71  PSAY xUNID_PRO[I]
		@ nLin,  75  PSAY xQTD_PRO[I]               Picture TM(xQTD_PRO[I],10,2) // "@E 999,999.99"
		@ nLin,  87  PSAY xPRE_UNI[I]               Picture TM(xPRE_UNI[I],13,4) //"@E 999,999.99999"
		@ nLin, 103  PSAY xVAL_MERC[I]              Picture "@E 99,999,999.99"
		@ nLin, 119  PSAY xICM_PROD[I]              Picture "99"
		@ nLin, 122  PSAY xIPI[I]                   Picture "@E 99.99"
		@ nLin, 127  PSAY xVAL_IPI[I]               Picture "@E 9,999,999.99"
		
		If _nCont == 14  .And. Len(xCOD_PRO) >= 15 .And.  Len(xCOD_PRO) <= 16
			ImpRod1()
			ImpCab()
			nLin   := 25
			_nCont := 0
		ElseIf _nCont == 18  .And. I != Len(xCOD_PRO)
			ImpRod1()
			ImpCab()
			nLin   := 25
			_nCont := 0
		Endif
		nLin++
	Next
Endif

If _lImpr
	If !Empty(xPCM)
		nLin+=2
		@ nLin,  04  PSAY "Ped. : PCM "+Alltrim(xPCM)+" / AFM "+Alltrim(xAFM)+" / AEM "+Alltrim(xAEM)
	Endif
	_lImpr := .F.
Endif

If !_lImpRod
	ImpRod2()
Endif

Return


Static Function ImpRod1()


@ 43, 000 PSAY Chr(15)

@ 43, 120  PSAY "Continua..."
@ 45, 004  PSAY "**************"  // Base do ICMS
@ 45, 029  PSAY "**************"  // Valor do ICMS
@ 45, 056  PSAY "**************"
@ 45, 088  PSAY "**************"
@ 45, 115  PSAY "**************"

@ 47, 004  PSAY "**************"
@ 47, 029  PSAY "**************"
@ 47, 056  PSAY "**************"
@ 47, 088  PSAY "**************"  // Valor do IPI
@ 47, 115  PSAY "**************"  // Valor Total NF + Desconto Zona Franca de Manaus

@ 50, 004  PSAY xNOME_TRANSP                       // Nome da Transport.

If xTPFRETE=='C'                                   // Frete por conta do
	@ 50, 086 PSAY "1"                              // Emitente (1)
Else                                               //     ou
	@ 50, 086 PSAY "2"                              // Destinatario (2)
Endif

@ 50, 082 PSAY " "                                  // Res. p/Placa do Veiculo
@ 50, 098 PSAY " "                                  // Res. p/xEST_TRANSP                          // U.F.

If !EMPTY(xCGC_TRANSP)                              // Se C.G.C. Transportador nao for Vazio
	@ 50, 112 PSAY xCGC_TRANSP Picture"@R 99.999.999/9999-99"
Else
	@ 50, 112 PSAY " "                               // Caso seja vazio
Endif

@ 52, 004 PSAY xEND_TRANSP                          // Endereco Transp.
@ 52, 074 PSAY xMUN_TRANSP                          // Municipio
@ 52, 106 PSAY xEST_TRANSP                          // U.F.
@ 52, 112 PSAY xIE_TRANSP                           // Insc. Estad.

@ 54, 004 PSAY "*******"
@ 54, 024 PSAY "*******"
@ 54, 100 PSAY "*******"
@ 54, 122 PSAY "*******"

@ 67, 127 PSAY xNUM_NF
@ 72, 000 PSAY chr(18)                   // Descompressao de Impressao

SetPrc(0,0)                              // (Zera o Formulario)

Return .t.


Static Function ImpRod2()

If mv_par04 == 2 .and. Len(xISS) == 0
	nLin := 41
	ImpMenp()
	nLin := 42
	MensObs()
Endif

@ 45, 000 PSAY Chr(15)
@ 45, 004  PSAY xBASE_ICMS              Picture "@E@Z 999,999,999.99"  // Base do ICMS
@ 45, 029  PSAY xVALOR_ICMS             Picture "@E@Z 999,999,999.99"  // Valor do ICMS
@ 45, 056  PSAY xBSICMRET               Picture "@E@Z 999,999,999.99"  // Base ICMS Ret.
@ 45, 088  PSAY xICMS_RET               Picture "@E@Z 999,999,999.99"  // Valor  ICMS Ret.
@ 45, 115  PSAY xVALOR_MERC				Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.
//@ 40, 104  PSAY xVALOR_MERC + _nValDesc Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.

@ 47, 004  PSAY xFRETE                  Picture "@E@Z 999,999,999.99"  // Valor do Frete
@ 47, 029  PSAY xSEGURO                 Picture "@E@Z 999,999,999.99"  // Valor Seguro
@ 47, 088  PSAY xVALOR_IPI              Picture "@E@Z 999,999,999.99"  // Valor do IPI
@ 47, 115  PSAY xTOT_FAT                Picture "@E@Z 999,999,999.99"  // Valor Total NF + Desconto Zona Franca de Manaus

@ 50, 004  PSAY xNOME_TRANSP                       // Nome da Transport.

If xTPFRETE=='C'                                   // Frete por conta do
	@ 50, 086 PSAY "1"                              // Emitente (1)
Else                                               //     ou
	@ 50, 086 PSAY "2"                              // Destinatario (2)
Endif

@ 50, 082 PSAY " "                                  // Res. p/Placa do Veiculo
@ 50, 098 PSAY " "                                  // Res. p/xEST_TRANSP                          // U.F.

If !EMPTY(xCGC_TRANSP)                              // Se C.G.C. Transportador nao for Vazio
	@ 50, 112 PSAY xCGC_TRANSP Picture"@R 99.999.999/9999-99"
Else
	@ 50, 112 PSAY " "                               // Caso seja vazio
Endif

@ 52, 004 PSAY xEND_TRANSP                          // Endereco Transp.
@ 52, 074 PSAY xMUN_TRANSP                          // Municipio
@ 52, 106 PSAY xEST_TRANSP                          // U.F.
@ 52, 112 PSAY xIE_TRANSP                           // Insc. Estad.

@ 54, 004 PSAY xVOLUME  Picture"@E@Z 999,999.99"                  // Quant. Volumes
@ 54, 024 PSAY xESPECIE Picture"@!"                          	  // Especie
@ 54, 100 PSAY xPESO_BRUTO         Picture"@E@Z 999,999.999"      // Res para Peso Bruto
@ 54, 122 PSAY xPESO_LIQUI         Picture"@E@Z 999,999.999"      // Res para Peso Liquido

ImpDup()

If !Empty(xNUM_NFDV[1])
	ImpRet()
Endif

@ 67, 127 PSAY xNUM_NF

@ 72, 000 PSAY chr(18)                   // Descompressao de Impressao

SetPrc(0,0)                              // (Zera o Formulario)

Return .t.


Static Function DUPLIC2()

nCol	 := 7
nAjuste  := 0
For BB:= 1 to Len(xVALOR_DUP)
	if bb <= 6
		if bb > 3 .and. bb <=6
			nlin++
			najuste:=0
		endif
		If xDUPLICATAS==.T. .and. BB<=Len(xVALOR_DUP)
			@ nLin, nCol + nAjuste      PSAY xNUM_DUPLIC + " " + xPARC_DUP[BB]
			@ nLin, nCol + 24 + nAjuste      PSAY xVENC_DUP[BB]
			@ nLin, nCol + 42 + nAjuste PSAY xVALOR_DUP[BB] Picture("@E 9,999,999.99")
			nAjuste := nAjuste + 58
		Endif
	endif
Next

Return


Static Function IMPMENP()

nCol:= 04
XCOD_MENS2 := ""

dbSelectArea("SF4")
_aAliSF4 := GetArea()
Z          := 1
_lMens     := .T.

For Z:=1 to Len(xTes)
	dbSelectArea("SF4")
	dbSetOrder(1)
	If dbSeek(xFilial()+xTes[Z])
		AADD(xFormula,SF4->F4_FORMULA)
	Endif
Next Z

If !Empty(xCOD_MENS)
	_cMens := FORMULA(xCOD_MENS)
	@ nLin, NCol PSAY Substr(_cMens,1,147)
	nLin++
	If !Empty( Substr(_cMens,148,147) )
		@ nLin, NCol PSAY Substr(_cMens,148,147)
		nLin++
	Endif
	
	If !Empty( Substr(FORMULA(xCOD_MENS),295,147))
		@ nLin, NCol PSAY Substr(FORMULA(xCOD_MENS),295,147)
		nLin++
	Endif
Endif

T:=1
For T:=1 to Len(xFormula)
	If Empty(XCOD_MENS2)
		XCOD_MENS2 := xFormula[T]
	Endif
Next T

If !Empty(xCOD_MENS2)
	_cMens2 := FORMULA(xCOD_MENS2)
	
	If !Empty(_cMens2)
		@ nLin, NCol PSAY Substr(_cMens2,1,147)
		nlin++
	Endif
	
	If !Empty( Substr(_cMens2,148,147) )
		@ nLin, NCol PSAY Substr(_cMens2,148,147)
		nLin++
	Endif
	
	If !Empty( Substr(_cMens2,295,147))
		@ nLin, NCol PSAY Substr(_cMens2,295,147)
		nLin++
	Endif
Endif

If _lCart
	@ nLin, NCol PSAY "ICMS DIFERIDO : "+Transform(_nValICM,"@E 999,999,999.99")
Endif
nlin++

Return


Static Function MENSOBS()

nTamObs:=150
nCol:=04
@ nLin, nCol PSAY UPPER(xMENSAGEM)
nLin++

Return


Static Function ImpDup()

nLin := 56
@ nLin, 004   PSAY "PARC.        VALOR   VENCIMENTO |  PARC.        VALOR   VENCIMENTO"
nLin++

For _nCont := 1 to Len(xVALOR_DUP)
	@ nLin, 005   PSAY xParc_Dup[_nCont]
	@ nLin, 008   PSAY xValor_dup[_nCont]     Picture "@E 999,999,999.99"
	@ nLin, 027   PSAY xVenc_Dup[_nCont]
	@ nLin, 036   PSAY "|"
	_nCont2 := _nCont + 3
	If Len(xValor_DUP) >= _nCont2
		@ nLin, 040   PSAY xParc_Dup[_nCont2]
		@ nLin, 043   PSAY xValor_dup[_nCont2]   Picture "@E 999,999,999.99"
		@ nLin, 062   PSAY xVenc_Dup[_nCont2]
	Endif
	If _nCont == 3
		_nCont := Len(xVALOR_DUP)
	Endif
	nLin++
Next

Return


Static Function ImpRet()

nLin := 61

_cNfOri := "Nota Fiscal Original No."
For B:= 1 To Len(xCod_Pro)
	If B > 1
		If xNUM_NFDV[B] != xNUM_NFDV[B-1]
			_cNfOri += "/"+xNUM_NFDV[B]
		Endif
	Else
		_cNfOri += xNUM_NFDV[B]
	Endif
Next B

If !Empty(Substr(_cNfOri,1,70))
	@ nLin, 004 PSAY Substr(_cNfOri,1,70)
Endif

nLin++
If !Empty(Substr(_cNfOri,71,70))
	@ nLin, 004 PSAY Substr(_cNfOri,71,70)
Endif

nLin++
If !Empty(Substr(_cNfOri,141,70))
	@ nLin, 004 PSAY Substr(_cNfOri,141,70)
Endif

Return