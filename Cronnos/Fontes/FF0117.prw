#include "rwmake.ch"

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦  Nfiscal ¦ Autor ¦   Alexandro da Silva  ¦ Data ¦ 21/02/06 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Nota Fiscal de Entrada/Saida                               ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico para Clientes Microsiga                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function FF0117()

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,NTAMNF,CSTRING,CPEDANT,NLININI")
SetPrvt("XNUM_NF,XSERIE,XEMISSAO,XTOT_FAT,XLOJA,XFRETE")
SetPrvt("XSEGURO,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XVALOR_IPI")
SetPrvt("XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO,XPLIQUI,XTIPO")
SetPrvt("XESPECIE,XVOLUME,CPEDATU,CITEMATU,XPED_VEND,XITEM_PED")
SetPrvt("XNUM_NFDV,XPREF_DV,XICMS,XCOD_PRO,XQTD_PRO,XPRE_UNI")
SetPrvt("XPRE_TAB,XIPI,XVAL_IPI,XDESC,XVAL_DESC,XVAL_MERC")
SetPrvt("XTES,XCF,XICMSOL,XICM_PROD,xDescZFR,XPESO_PRO,XPESO_UNIT")
SetPrvt("XDESCRICAO,XUNID_PRO,XCOD_TRIB,XMEN_TRIB,XCOD_FIS,XCLAS_FIS")
SetPrvt("XMEN_POS,XISS,XTIPO_PRO,XLUCRO,XCLFISCAL,XPESO_LIQ")
SetPrvt("I,NPELEM,_CLASFIS,NPTESTE,XPESO_LIQUID,XPED")
SetPrvt("XPESO_BRUTO,XP_LIQ_PED,XCLIENTE,XTIPO_CLI,XCOD_MENS,XMENSAGEM,xCHAVE")
SetPrvt("XTPFRETE,XCONDPAG,XCOD_VEND,XDESC_NF,XDESC_PAG,XPED_CLI")
SetPrvt("XDESC_PRO,J,XCOD_CLI,XNOME_CLI,XEND_CLI,XBAIRRO")
SetPrvt("XCEP_CLI,XCOB_CLI,XREC_CLI,XMUN_CLI,XEST_CLI,XCGC_CLI")
SetPrvt("XINSC_CLI,XTRAN_CLI,XTEL_CLI,XFAX_CLI,XSUFRAMA,XCALCSUF")
SetPrvt("ZFRANCA,XVENDEDOR,XBSICMRET,XNOME_TRANSP,XEND_TRANSP,XMUN_TRANSP")
SetPrvt("XEST_TRANSP,XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP,XPARC_DUP,XVENC_DUP")
SetPrvt("XVALOR_DUP,XDUPLICATAS,XNATUREZA,XFORNECE,XNFORI,XPEDIDO")
SetPrvt("XPESOPROD,XFAX,NOPC,CCOR,NTAMDET,XB_ICMS_SOL")
SetPrvt("XV_ICMS_SOL,NCONT,NCOL,NTAMOBS,NAJUSTE,BB")

Private _aValZFR, _nValDEsc,_nPag,_nPagTot
Private _cCfoRet := _cCfoVen := _cTESRET := _cTESVEN := ""
_nICM_PROP := 0

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
nomeprog    := "FF0117"
cPerg       := "NFSIGW"
nLastKey    := 0
lContinua   := .T.
nLin        := 0
wnrel       := "FF0117"
WIMPL       := ""
WBASE18     := 0
WBASE12     := 0
WBASE7      := 0
WRED18      := 0
WRED12      := 0
WRED7       := 0
WREDPROD    := "N"
WMENREDALIQ := ""

nTamNf:=72     // Apenas Informativo

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
		
		WMENSIMPL:=""
		
		If SF2->F2_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
			DbSkip()                    // do Parametro Informado !!!
			Loop
		Endif
		
		WBASE18 :=0
		WBASE12 :=0
		WBASE7  :=0
		WRED18  :=0
		WRED12  :=0
		WRED7   :=0
		
		IF lAbortPrint
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
		
		nLinIni		:=nLin                         // Linha Inicial da Impressao
		xNUM_NF     :=SF2->F2_DOC             // Numero
		xSERIE      :=SF2->F2_SERIE           // Serie
		xEMISSAO    :=SF2->F2_EMISSAO         // Data de Emissao
		xTOT_FAT    :=SF2->F2_VALFAT          // Valor Total da Fatura
		if xTOT_FAT == 0
			xTOT_FAT := SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE
		endif
		xLOJA       := SF2->F2_LOJA            // Loja do Cliente
		xFRETE      := SF2->F2_FRETE           // Frete
		xSEGURO     := SF2->F2_SEGURO          // Seguro
		xBASE_ICMS  := SF2->F2_BASEICM         // Base   do ICMS
		xBASE_IPI   := SF2->F2_BASEIPI         // Base   do IPI
		xVALOR_ICMS := SF2->F2_VALICM          // Valor  do ICMS
		xICMS_RET   := SF2->F2_ICMSRET         // Valor  do ICMS Retido
		xBSICMRET	:= SF2->F2_BRICMS
		xVALOR_IPI  := SF2->F2_VALIPI          // Valor  do IPI
		xVALOR_MERC := SF2->F2_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC := SF2->F2_DUPL            // Numero da Duplicata
		xCOND_PAG   := SF2->F2_COND            // Condicao de Pagamento
		xPBRUTO     := SF2->F2_PBRUTO          // Peso Bruto
		XPVIDE      := SF2->F2_REDESP          //APROVEITADO PARA NF C/MAIS DE 1 PEDIDO (PE MTASF2.PRW)
		xPLIQUI     := SF2->F2_PLIQUI          // Peso Liquido
		xTIPO       := SF2->F2_TIPO            // Tipo do Cliente
		xESPECIE    := SF2->F2_ESPECI1         // Especie 1 no Pedido
		xVOLUME     := SF2->F2_VOLUME1         // Volume 1 no Pedido      
		_nICM_PROP  := 0
		
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
		_aValZFR 	:={}                         // Desconto Zona Franca de Manaus
		xTES     	:={}                         // TES
		xCF      	:={}                         // Classificacao quanto natureza da Operacao
		xICMSOL  	:={}                         // Base do ICMS Solidario
		xICM_PROD	:={}                         // ICMS do Produto
		xBASE_ICM	:= {}                         // BASE DO ICMS DO ITEM
		xSUBTRIB	:= {}                         // Substituição tributária
		_nValDesc	:= 0
		xDescZFR := 0                         // Desconto Zona Franca de Manaus
		
		_nPagTot := 1
		_nContIt := 0
		_nICMS   := 0
		_nBICM   := 0   
		_cCfoRet := ""          
		_cCfoVen := ""
		_cTESRET := _cTESVEN := ""
		
		While !eof() .and. SD2->D2_DOC==xNUM_NF .and. SD2->D2_SERIE==xSERIE
			
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
			AADD(_aValZFR  ,SD2->D2_DESCZFR)
			AADD(xTES      ,SD2->D2_TES)
			
			If SD2->D2_ICMSRET >  0
				_nICM_PROP += SD2->D2_VALICM
				_cCfoRet   := " \ "+SD2->D2_CF   
				_cTESRET   := SD2->D2_TES 
			Else
				_cCfoVen := SD2->D2_CF 
				_cTESVEN := SD2->D2_TES 				
			Endif
			_cForm := ""
			dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
			DbSetOrder(1)
			dbSeek(xFilial()+SD2->D2_TES)
/*	
			If SF4->F4_AGREG == "D"
				If _cForm = ""
					_cForm := SF4->F4_FORMULA
				Endif
				_nICMS += SD2->D2_VALICM
				_nBICM += SD2->D2_TOTAL
			Endif
*/	
			If SD2->D2_BRICMS > 0   
//				If _cForm = ""
//					_cForm := SF4->F4_FORMULA
//				Endif
				_nICMS += SD2->D2_VALICM
				_nBICM += SD2->D2_BASEICM
			Endif

			If _cForm = ""
				_cForm := SF4->F4_FORMULA
			Endif

			AADD(xSUBTRIB  ,SF4->F4_SITTRIB)

			AADD(xCF       ,SD2->D2_CF)
			AADD(xICM_PROD ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
			AADD(xBASE_ICM ,SD2->D2_BASEICM)
			_nValDesc += SD2->D2_DESCZFR
			xDescZFR:= xDescZFR + SD2->D2_DESCZFR
			If _nContIt > 20
				_nPagTot++
				_nContIt := 1
			Endif
			
			dbSelectArea("SD2")
			dbskip()
		EndDo
		
		If Empty(_CTESVEN)
			_cTes2 := _CTESRET
		Else	
			_cTes2 := _CTESVEN
		Endif
				
		dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
		DbSetOrder(1)
		dbSeek(xFilial()+_cTes2) 
		
		xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
		WTEMIPI 	:=IIF(SF4->F4_IPI=="S",.T.,.F.)
		WTEMICMS	:=IIF(SF4->F4_ICM=="S",.T.,.F.)
		
		dbSelectArea("SB1")                     // * Desc. Generica do Produto
		dbSetOrder(1)
		xPESO_PRO	:= {}                           // Peso Liquido
		xPESO_UNIT	:= {}                         // Peso Unitario do Produto
		xDESCRICAO 	:= {}                         // Descricao do Produto
		xUNID_PRO	:= {}                           // Unidade do Produto
		xCOD_TRIB	:= {}                           // Codigo de Tributacao
		xIMPLAGRICOLA:={}					  // Implemento Agricola (se é ou não é)
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
			If SB1->B1_IMPLAGR == "S"
				AADD(xCOD_TRIB ,SB1->B1_ORIGEM+"20")
			Else
				AADD(xCOD_TRIB ,SB1->B1_ORIGEM+xSUBTRIB[I])
			Endif
			AADD(xIMPLAGRICOLA, SB1->B1_IMPLAGR)
			If WREDPROD == "N"
				WREDPROD	:= IIF(SB1->B1_PICM<>0,"S","N")
			Endif
			XMARCA  		:= SB1->B1_FABRIC
			If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
				AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
			Endif
			
			npElem 			:= ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
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
					
			ENDCASE
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
		
		For I:=1 to Len(xPED_VEND)
			
			dbSeek(xFilial()+xPED_VEND[I])
			
			If ASCAN(xPED,xPED_VEND[I])==0
				dbSeek(xFilial()+xPED_VEND[I])
				xCLIENTE    :=SC5->C5_CLIENTE            // Codigo do Cliente
				xTIPO_CLI   :=SC5->C5_TIPOCLI            // Tipo de Cliente
				xCOD_MENS   :=SC5->C5_MENPAD             // Codigo da Mensagem Padrao
				xMENSAGEM   :=SC5->C5_MENNOTA            // Mensagem para a Nota Fiscal
				xCHAVE      :=SC5->C5_CHAVESP            // Nr Pedido referente à cópia
				xTPFRETE    :=SC5->C5_TPFRETE            // Tipo de Entrega
				xCONDPAG    :=SC5->C5_CONDPAG            // Condicao de Pagamento
				XPCLI       :=SC5->C5_PEDCLI             // Pedido do cliente
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
		J:=Len(xPED_VEND)
		For I:=1 to J
			dbSeek(xFilial()+xPED_VEND[I]+xITEM_PED[I])
			_lEntr := .F.
			If	xTIPO_CLI = "X"		
				dbSelectArea("SA7")
				dbSetorder(1)
				If dbSeek(xFilial("SA7")+xCLIENTE+xLOJA+SC6->C6_PRODUTO)
					AADD(xDESC_PRO,SA7->A7_DESCCLI)
					_lEntr := .T.
				Endif
			Endif
			AADD(xPED_CLI ,SC6->C6_PEDCLI)
			AADD(xVAL_DESC,SC6->C6_VALDESC)
			If !_lEntr
				AADD(xDESC_PRO,SC6->C6_DESCRI)
			Endif
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
			xSUFRAMA 	:=SA1->A1_SUFRAMA            // Codigo Suframa
			xCALCSUF 	:=SA1->A1_CALCSUF            // Calcula Suframa
			if !empty(xSUFRAMA) .and. xCALCSUF =="S"
				IF XTIPO == 'D' .OR. XTIPO == 'B'
					zFranca := .F.
				else
					zFranca := .T.
				endif
			Else
				zfranca:= .F.
			endif
			
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
/*		
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
*/
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
		xDUPLICATAS :=IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
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
		
		_nPag := 0
		ImpCab()
		If !xTipo $ "P/I"
			ImpDet()
			nLin:=0
		Else
			ImpIPI()
			ImpRod2()
		Endif
		
		dbSelectArea("SF2")
		dbSkip()                      // passa para a proxima Nota Fiscal
	EndDo
Else
	dbSelectArea("SF1")              // * Cabecalho da Nota Fiscal Entrada
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	While !eof() .and. SF1->F1_DOC <= mv_par02 .and. SF1->F1_SERIE == mv_par03 .and. lContinua
		
		IncRegua()
		
		WMENSIMPL:=""
		
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
		
		dbSelectArea("SD1")                   // * Itens da N.F. de Compra
		dbSetOrder(1)
		dbSeek(xFilial()+xNUM_NF+xSERIE+xFORNECE+xLOJA)

		_nBICM		:= 0
		_nICMS      := 0
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
		_aValZFR 	:= {}                         // Desconto Zona Franca de Manaus
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

		_cForm   := ""		
		_nPagTot := 1
		_nContIt := 0
		
		While !eof() .and. SD1->D1_DOC==xNUM_NF
			If SD1->D1_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
				DbSkip()                      // do Parametro Informado !!!
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
			AADD(_aValZFR  ,0)          // Valor Total
			AADD(xTES      ,SD1->D1_TES)            // Tipo de Entrada/Saida
			AADD(xCF       ,SD1->D1_CF)             // Codigo Fiscal
			AADD(xICM_PROD ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			AADD(XBASE_ICM ,SD1->D1_BASEICM)
			
			If _nContIt > 20
				_nPagTot++
				_nContIt := 1
			Endif
			
			dbskip()
		EndDo
		
		dbSelectArea("SB1")                     // * Desc. Generica do Produto
		dbSetOrder(1)
		xUNID_PRO	:= {}                           // Unidade do Produto
		xDESC_PRO	:= {}                           // Descricao do Produto
		xMEN_POS 	:= {}                           // Mensagem da Posicao IPI
		xDESCRICAO  := {}                         // Descricao do Produto
		xCOD_TRIB	:= {}                           // Codigo de Tributacao
		xIMPLAGRICOLA:={}					  // Implemento Agricola (se é ou não é)
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
			If SB1->B1_IMPLAGR == "S"
				AADD(xCOD_TRIB ,SB1->B1_ORIGEM+"20")
			Else
				AADD(xCOD_TRIB ,SB1->B1_ORIGEM+SF4->F4_SITTRIB)
			Endif
			AADD(xIMPLAGRICOLA, SB1->B1_IMPLAGR)
			XMARCA := SB1->B1_FABRIC
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
		
		while !eof() .and. SE2->E2_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
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
//		xCHAVE       :=" "           // Nr Pedido referente à cópia
		xPESO_LIQUID :=" "
		
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
@ 01, 160 PSAY xNUM_NF               // Numero da Nota Fiscal

@ 05, 42  PSAY "NOVO ENDERECO: RUA OLINDA, 288 - CAPELA DO SOCORRO - SANTO AMARO"

@ 06, 81  PSAY "  =========================== "
@ 06, 166 PSAY xNUM_NF               // Numero da Nota Fiscal
@ 07, 81  PSAY " |   NOVO PREFIXO TELEFONE   |"

If mv_par04 == 1
	@ 07, 131 PSAY "XX"
Else
	@ 07, 119 PSAY "XX"
Endif

@ 07, 164 PSAY "FL.: "+StrZero(_nPag,2)+"/"+StrZero(_nPagTot,2)

@ 08, 81 PSAY " |         5683-5166         |"
@ 09, 81 PSAY "  =========================== "

@ 12, 006 PSAY xNATUREZA               // Texto da Natureza de Operacao
If mv_par04 == 1
	@ 12, 058 PSAY _cCfoVen + _cCfoRet  Picture PESQPICT("SD1","D1_CF") // Codigo da Natureza de Operacao
Else
	@ 12, 058 PSAY _cCfoVen + _cCfoRet Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
EndIf

@ 15, 006 PSAY xNOME_CLI              //Nome do Cliente

If !EMPTY(xCGC_CLI)                   // Se o C.G.C. do Cli/Forn nao for Vazio
	@ 15, 121 PSAY xCGC_CLI Picture"@R 99.999.999/9999-99"
Else
	@ 15, 121 PSAY " "                // Caso seja vazio
Endif

@ 15, 163 PSAY xEMISSAO              // Data da Emissao do Documento
@ 17, 006 PSAY xEND_CLI                                 // Endereco
@ 17, 098 PSAY xBAIRRO                                  // Bairro
@ 17, 139 PSAY xCEP_CLI Picture"@R 99999-999"           // CEP
@ 17, 148 PSAY " "                                      // Reservado  p/Data Saida/Entrada

@ 19, 006 PSAY xMUN_CLI                               // Municipio
@ 19, 075 PSAY SUBSTR(xTEL_CLI,1,35)                  // Telefone/FAX
@ 19, 111 PSAY xEST_CLI                               // U.F.
@ 19, 125 PSAY xINSC_CLI                              // Insc. Estadual
@ 19, 148 PSAY " "                                    // Reservado p/Hora da Saida

If mv_par04 == 2 .AND. ALLTRIM(MV_PAR03) == "1"
	nLin	:= 22
	BB		:= 1
	nCol 	:= 05             //  duplicatas
	DUPLIC()
Endif

Return


Static Function IMPDET()

nLin	   := 26
nTamDet    := GETMV("MV_NUMITEN") // 2000
I		   := 1
J		   := 1
xB_ICMS_SOL:= 0          // Base  do ICMS Solidario
xV_ICMS_SOL:= 0          // Valor do ICMS Solidario
_nCont      := 0
_lImpRod    := .F.
_lMens1     := .F.
_lMens2     := .F.
_lMens3     := .F.
_lMens4     := .F.
_lSufr 		:= .F.	

WMENSIMPL   := ""
WMENREDALIQ := ""
	
For A:=1 to Len(xCOD_PRO)
	_nCont++
	IF XIMPLAGRICOLA[A]=="S"
		WIMPL:="*"
		IF XTES[A] == "609" .OR. XTES[A] == "610"
			WMENSIMPL:=""
		ELSE
			If XICM_PROD[A] == 12 .AND. XEST_CLI == "SP"
				_lMens2 := .T.
			Endif
			_lMens1:= .T.
		ENDIF
		IF XICM_PROD[A] == 18
			WRED18:=WRED18+(XVAL_MERC[A]*VAL(TABELA("ZA",XEST_CLI))/100)
		ELSEIF XICM_PROD[A] == 12
			IF XEST_CLI == "SP"
				WRED12:=WRED12+(XVAL_MERC[A]*VAL(TABELA("ZA",XEST_CLI+"12"))/100)
			Else
				WRED12:=WRED12+(XVAL_MERC[A]*VAL(TABELA("ZA",XEST_CLI))/100)
			ENDIF
		ELSEIF XICM_PROD[A] == 7
			WRED7 :=WRED7 +(XVAL_MERC[A]*VAL(TABELA("ZA",XEST_CLI))/100)
		ENDIF
	ELSE
		WIMPL:=""
	ENDIF
	
	If Substr(xCLAS_FIS[A],1,4) == "9403"
		_lMens3 := .T.
	Endif
	
	If Alltrim(xCLAS_FIS[A]) == "72169900"
		_lMens4 := .T.
	Endif
	
	@ nLin, 005  PSAY ALLTRIM(xCOD_PRO[A])+WIMPL
	@ nLin, 026  PSAY SUBSTR(xDESC_PRO[A],1,65)
	@ nLin, 092  PSAY xCLAS_FIS[A]
	@ nLin, 106  PSAY xCOD_TRIB[A]
	@ nLin, 112  PSAY xUNID_PRO[A]
	@ nLin, 115  PSAY xQTD_PRO[A]               Picture "@E 999,999.999"
	@ nLin, 126  PSAY xPRE_UNI[A]               Picture TM(xPRE_UNI[A],12,3)//"@E 9999,999.999"
	@ nLin, 144  PSAY xVAL_MERC[A]+_aValZFR[A]  Picture "@E 99,999,999.99"
	@ nLin, 160  PSAY xICM_PROD[A]              Picture "99"
	@ nLin, 164  PSAY xIPI[A]                   Picture "@E 99.9"     //alterado de 99 para 99.9
	@ nLin, 168  PSAY xVAL_IPI[A]               Picture "@E 9,999,999.99"  //alterado posicao de 167 para 168
	
	If XIMPLAGRICOLA[A]=="S"
		IF XICM_PROD[A] == 18
			WBASE18:=WBASE18+XVAL_MERC[A]
		ELSEIF XICM_PROD[A] == 12
			WBASE12:=WBASE12+XVAL_MERC[A]
		ELSEIF XICM_PROD[A] == 7
			WBASE7 :=WBASE7 +XVAL_MERC[A]
		ENDIF
	Endif
	
	J:=J+1	

	IF !Empty(xSUFRAMA) .AND. (xDESCZFR != 0)	
		_lSufr := .T.
   		If _nCont == 17  .And. A != Len(xCOD_PRO)
   			ImpRod1()
   			ImpCab()
   			nLin   := 25
   			_nCont := 0
   		Elseif _nCont == 17 .And. _nCont = Len(xCOD_PRO)		
			_lImpRod := .T.
			ImpRod2()
		Endif	
	Else	
		If _nCont == 20  .And. A != Len(xCOD_PRO)
			ImpRod1()
			ImpCab()
			nLin   := 25
			_nCont := 0
		Elseif _nCont == 20 .And. _nCont = Len(xCOD_PRO)
			If _lMens1
				WMENSIMPL :="(*)=REDUCAO BASE CALC.ICMS CONF.ART.12 ANEXO II DO RICMS/00-DEC.45490 "
			Endif         	
		
			If _lMens2
				WMENSIMPL +="RED.ALIQ.P/12% CFE. RESOL.SF.04 DE 16/01/98. "
			Endif
		
			If _lMens3
				If Substr(_cCfoVen,1,1) = "5" // Fabiano 11/09/08
					WMENSIMPL +="RED.ALIQ.P/12%CFE.LEI 10532/00. "
				Endif	
			Endif
		
			If _lMens4
				WMENSIMPL +="IPI REDUZIDO A 0% CONF. DECRETO 6.024 DE 22/01/07"
			Endif
			
			_lImpRod := .T.
			ImpRod2()
		Endif	
	Endif
	
	nLin++
Next A

IF !_lSufr

	If _lMens1
		WMENSIMPL :="(*)=REDUCAO BASE CALC.ICMS CONF.ART.12 ANEXO II DO RICMS/00-DEC.45490 "
	Endif

	If _lMens2
		WMENSIMPL +="RED.ALIQ.P/12% CFE. RESOL.SF.04 DE 16/01/98. "
	Endif

	If _lMens3
		If Substr(_cCfoVen,1,1) = "5" // Fabiano 11/09/08
			WMENSIMPL +="RED.ALIQ.P/12%CFE.LEI 10532/00. "
		Endif	
	Endif

	If _lMens4
		WMENSIMPL +="IPI REDUZIDO A 0% CONF. DECRETO 6.024 DE 22/01/07"
	Endif

Endif

If !_lImpRod
	ImpRod2()
Endif

Return


Static Function ImpRod1()

@ 46, 169  PSAY "Continua..."
@ 48, 011  PSAY "**************"  // Base do ICMS
@ 48, 041  PSAY "**************"  // Valor do ICMS
@ 48, 143  PSAY "**************"  // Valor Tot. Prod.
@ 50, 109  PSAY "**************"  // Valor do IPI
@ 50, 143  PSAY "**************"  // Valor Total NF + Desconto Zona Franca de Manaus

@ 53, 005  PSAY xNOME_TRANSP                       // Nome da Transport.

If xTPFRETE=='C'                                   // Frete por conta do
	@ 53, 103 PSAY "1"                              // Emitente (1)
Else                                               //     ou
	@ 53, 103 PSAY "2"                              // Destinatario (2)
Endif

@ 53, 102 PSAY " "                                  // Res. p/Placa do Veiculo
@ 53, 102 PSAY " "                                  // Res. p/xEST_TRANSP                          // U.F.

If !EMPTY(xCGC_TRANSP)                              // Se C.G.C. Transportador nao for Vazio
	@ 53, 140 PSAY xCGC_TRANSP Picture"@R 99.999.999/9999-99"
Else
	@ 53, 138 PSAY " "                               // Caso seja vazio
Endif

@ 55, 005 PSAY xEND_TRANSP                          // Endereco Transp.
@ 55, 086 PSAY xMUN_TRANSP                          // Municipio
@ 55, 132 PSAY xEST_TRANSP                          // U.F.
@ 55, 140 PSAY xIE_TRANSP                           // Insc. Estad.

@ 57, 006 PSAY "**************"
@ 57, 036 PSAY xESPECIE Picture"@!"                          // Especie
@ 57, 060 PSAY XMARCA                                        // Res para Marca
IF MV_PAR04 == 2
	@ 57, 095 PSAY XPED_VEND[1]                                  // Res para Numero do pedido
	FOR I = 2 TO LEN(XPED_VEND)
		IF XPED_VEND[I] <> XPED_VEND[I-1]
			ALERT("ATENCAO !!! NF "+xnum_nf+" gerada com mais de um pedido. Verifique impressao no formulario...")
		ENDIF
	NEXT
endif                //xPESO_BRUTO

@ 57, 119 PSAY "**************"
@ 57, 156 PSAY "**************"

if mv_par04 == 2
	@ 60, 085 PSAY XPCLI
	@ 62, 084 PSAY XCOD_VEND[1]  // Picture"@R 99-999" //IMPRESSAO DO VENDEDOR PRINCIPAL
	@ 62, 101 PSAY XPED_VEND[1]
endif

@ 72, 000 PSAY chr(18)                   // Descompressao de Impressao

SetPrc(0,0)                              // (Zera o Formulario)

Return .t.


Static Function ImpRod2()
                
_lSuf := .F.
IF !Empty(xSUFRAMA) .AND. (xDESCZFR != 0)

	@ 43, 026  PSAY "VALOR DA MERCADORIA C/ ICMS R$ " + CVALTOCHAR(xVALOR_MERC + _nValDesc)
	@ 44, 026  PSAY "VALOR DA MERCADORIA S/ ICMS R$ " + CVALTOCHAR(xVALOR_MERC)
	@ 45, 026  PSAY "VALOR DO ICMS (ALIQ.7%) = R$ " + CVALTOCHAR(_nValDesc)
	@ 46, 026  PSAY "VALOR DO DESCONTO = R$ " + CVALTOCHAR(_nValDesc)
	_lSuf := .T.
Endif	

If _cForm != "" .And. !_lSuf
	@ 46, 005  PSAY FORMULA(_cForm)
Endif

If xTipo $ "P"
	@ 50, 104  PSAY xVALOR_IPI              Picture "@E@Z 999,999,999.99"  // Valor do IPI
	@ 50, 136  PSAY xVALOR_IPI              Picture "@E@Z 999,999,999.99"  // Valor Total NF
ElseIf xTipo $ "I"
	@ 48, 036  PSAY xVALOR_ICMS             Picture "@E@Z 999,999,999.99"  // Valor do ICMS
Else
	IF !Empty(xSUFRAMA) .AND. (xDESCZFR != 0)
//		@ 46, 026  PSAY "DESCONTO ISENCAO ICMS - 7% "
//		@ 46, 065  PSAY xDESCZFR PICTURE"@E 9,999,999.99"
	Endif
	If Len(xISS) > 0
		nLin := 30
		Impmenp()
		nLin := 33
		MensObs()
		@ 37, 150  PSAY xTOT_FAT  Picture"@E@Z 999,999,999.99"   // Valor do Servico
	Endif
	
	@ 48, 006  PSAY xBASE_ICMS 		                Picture "@E@Z 999,999,999.99"  // Base do ICMS
//	@ 48, 006  PSAY xBASE_ICMS - _nBICM             Picture "@E@Z 999,999,999.99"  // Base do ICMS
	@ 48, 036  PSAY xVALOR_ICMS			            Picture "@E@Z 999,999,999.99"  // Valor do ICMS
//	@ 48, 036  PSAY xVALOR_ICMS - _nICMS            Picture "@E@Z 999,999,999.99"  // Valor do ICMS
	
	@ 48, 072  PSAY xBSICMRET               Picture "@E@Z 999,999,999.99"  // Base ICMS Ret.
	@ 48, 104  PSAY xICMS_RET               Picture "@E@Z 999,999,999.99"  // Valor  ICMS Ret.
	@ 48, 136  PSAY xVALOR_MERC + _nValDesc Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.
	
	@ 50, 006  PSAY xFRETE                  Picture "@E@Z 999,999,999.99"  // Valor do Frete
	@ 50, 030  PSAY xSEGURO                 Picture "@E@Z 999,999,999.99"  // Valor Seguro
	@ 50, 104  PSAY xVALOR_IPI              Picture "@E@Z 999,999,999.99"  // Valor do IPI
	@ 50, 136  PSAY xTOT_FAT                Picture "@E@Z 999,999,999.99"  // Valor Total NF + Desconto Zona Franca de Manaus
Endif

@ 53, 004  PSAY xNOME_TRANSP                       // Nome da Transport.

If xTPFRETE=='C'                                   // Frete por conta do
	@ 53, 103 PSAY "1"                              // Emitente (1)
Else                                               //     ou
	@ 53, 103 PSAY "2"                              // Destinatario (2)
Endif

@ 53, 102 PSAY " "                                  // Res. p/Placa do Veiculo
@ 53, 102 PSAY " "                                  // Res. p/xEST_TRANSP                          // U.F.

If !EMPTY(xCGC_TRANSP)                              // Se C.G.C. Transportador nao for Vazio
	@ 53, 140 PSAY xCGC_TRANSP Picture"@R 99.999.999/9999-99"
Else
	@ 53, 138 PSAY " "                               // Caso seja vazio
Endif

@ 55, 004 PSAY xEND_TRANSP                          // Endereco Transp.
@ 55, 086 PSAY xMUN_TRANSP                          // Municipio
@ 55, 132 PSAY xEST_TRANSP                          // U.F.
@ 55, 140 PSAY xIE_TRANSP                           // Insc. Estad.

IF ALLTRIM(XPVIDE) == ""
	@ 57, 006 PSAY xVOLUME  Picture"@E@Z 999,999.99"             // Quant. Volumes
ELSE
	@ 57, 006 PSAY "VIDE NF."+XPVIDE
ENDIF
@ 57, 036 PSAY xESPECIE Picture"@!"                          // Especie
@ 57, 060 PSAY XMARCA                                        // Res para Marca
IF MV_PAR04 == 2
	@ 57, 095 PSAY XPED_VEND[1]                                  // Res para Numero do pedido
	For I = 2 TO LEN(XPED_VEND)
		If XPED_VEND[I] <> XPED_VEND[I-1]
			ALERT("ATENCAO !!! NF "+xnum_nf+" gerada com mais de um pedido. Verifique impressao no formulario...")
		Endif
	Next
Endif
IF ALLTRIM(XPVIDE) == ""
	@ 57, 119 PSAY xPBRUTO         Picture"@E@Z 999,999.999"      // Res para Peso Bruto
ELSE
	@ 57, 119 PSAY "VIDE NF."+XPVIDE
ENDIF

@ 57, 156 PSAY xPESO_LIQ       Picture"@E@Z 999,999.999"      // Res para Peso Liquido

if mv_par04 == 2
	@ 60, 085 PSAY XPCLI
	@ 62, 084 PSAY XCOD_VEND[1] //  Picture"@R 99-999" //IMPRESSAO DO VENDEDOR PRINCIPAL
	@ 62, 101 PSAY XPED_VEND[1]
endif

If mv_par04 == 2 .and. Len(xISS) == 0
	nLin	:=63
	ImpMenp()
	nLin	:=65
	MensObs()
Endif

If Len(xNUM_NFDV) > 0  .and. !Empty(xNUM_NFDV[1])
	//	@ 68, 006 PSAY "Nota Fiscal Original No." + "  " + xNUM_NFDV[1] + "  " + xPREF_DV[1]
Endif

@ 72, 000 PSAY chr(18)

SetPrc(0,0)

Return .t.


Static Function DUPLIC()

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

nCol    := 05
_cNfOri := ""

If !xTipo $ "I/P"
	@ nLin, NCol+12 PSAY "** FAVOR CONFERIR A MERCADORIA NO ATO DO RECEBIMENTO. NAO ACEITAREMOS RECLAMACOES POSTERIORES"
	nLin := nLin+1
	
	If !Empty(xCOD_MENS)
		@ nLin, NCol PSAY FORMULA(xCOD_MENS)+" : "+TRANSFORM(_nValDesc,"@E 9,999,999.99")
	ElseIf WREDPROD == "S"
		If Substr(_cCfoVen,1,1) = "5" // Fabiano 11/09/08
			@ nLin, NCol PSAY "REDUCAO NA ALIQUOTA DE ICMS CF. LEI 10.532/00 DE 30/03/00. DOE SP. 31/03/00"
		Endif	
		WREDPROD:="N"
	Endif
Endif

Return


Static Function MENSOBS()

nTamObs	:=150
nCol	:=05
If xTipo != "P"
	If !Empty(xMENSAGEM)
		@ nLin, nCol PSAY UPPER(SUBSTR(xMENSAGEM,1,nTamObs))
		nLin	:=nlin+1
	Endif
	IF EMPTY(WMENSIMPL) .AND. !WTEMIPI .AND. !Empty(xSuframa) //ZFRANCA
		@ nLin, nCol PSAY FORMULA("052") 
		nLin++
		@ nLin, nCol PSAY FORMULA("053")
		nLin++
		@ nLin, nCol PSAY "NR DE INSCRICAO DO DESTINATARIO NA SUFRAMA : "+xSuframa
//		@ nLin, nCol PSAY FORMULA("051")+"      SUFRAMA : "+xSuframa
	ELSE
		//		@ nLin, nCol PSAY Substr(WMENSIMPL,1,70)
		@ nLin, nCol PSAY Substr(WMENSIMPL,1,110)
		If !Empty(Substr(WMENSIMPL,111,110))
			nLin++
			//			@ nLin, nCol PSAY Substr(WMENSIMPL,71,159)
			@ nLin, nCol PSAY Substr(WMENSIMPL,111,110)
		Endif
	ENDIF
	
//	IF !WTEMICMS .AND. !Empty(xSuframa) //ZFRANCA
//		nlin++
//		@ nLin, nCol PSAY FORMULA("052")
//	ENDIF
	
	IF Wred18 <> 0 .AND. WMENSIMPL <> ""
		nLin:=nlin+1
		@ nLin, nCol PSAY "BASE CALC.ICMS A 18% R$ "+TRANSFORM(WBASE18,"@E 99,999.99");
		+" REDUCAO "+IIF(WRED18<>0,TRANSFORM(TABELA("ZA",xEST_CLI),"@E 99.99"),"0,00");
		+"% R$ "+TRANSFORM(WRED18,"@E 99999.99")+" NOVA BASE R$ ";
		+TRANSFORM(WBASE18-WRED18,"@E 99999.99") +" E ICMS R$ ";
		+TRANSFORM((WBASE18-WRED18)*18/100,"@E 99,999.99")
		WBASE18:=0
		WRED18:=0
	ENDIF
	IF Wred12 <> 0 .AND. WMENSIMPL <> ""
		nLin	:=nlin+1
		IF XEST_CLI == "SP"
			@ nLin, nCol PSAY "BASE CALC.ICMS A 12% R$ "+TRANSFORM(WBASE12,"@E 99,999.99");
			+" REDUCAO "+IIF(WRED12<>0,"53,33","0,00");
			+"% R$ "+TRANSFORM(WRED12,"@E 99999.99")+" NOVA BASE R$ ";
			+TRANSFORM(WBASE12-WRED12,"@E 99999.99") +" E ICMS R$ ";
			+TRANSFORM((WBASE12-WRED12)*12/100,"@E 99,999.99")
		ELSE
			@ nLin, nCol PSAY "BASE CALC.ICMS A 12% R$ "+TRANSFORM(WBASE12,"@E 99,999.99");
			+" REDUCAO "+IIF(WRED12<>0,TRANSFORM(TABELA("ZA",xEST_CLI),"@E 99.99"),"0,00");
			+"% R$ "+TRANSFORM(WRED12,"@E 99999.99")+" NOVA BASE R$ ";
			+TRANSFORM(WBASE12-WRED12,"@E 99999.99") +" E ICMS R$ ";
			+TRANSFORM((WBASE12-WRED12)*12/100,"@E 99,999.99")
		ENDIF
		WBASE12:=0
		WRED12 :=0
	ENDIF
	IF Wred7 <> 0 .AND. WMENSIMPL <> ""
		nLin:=nlin+1
		@ nLin, nCol PSAY "BASE CALC.ICMS A 7% R$ "+TRANSFORM(WBASE7,"@E 99,999.99");
		+" REDUCAO "+IIF(WRED7<>0,TRANSFORM(TABELA("ZA",xEST_CLI),"@E 99.99"),"0,00");
		+"% R$ "+TRANSFORM(WRED7,"@E 99999.99")+" NOVA BASE R$ ";
		+TRANSFORM(WBASE7-WRED7,"@E 99999.99") +" E ICMS R$ ";
		+TRANSFORM((WBASE7-WRED7)*7/100,"@E 99,999.99")
		WBASE7:=0
		WRED7:=0
	ENDIF
ENDIF

If !Empty(xCHAVE)
	nLin:=nlin+1
	@ nLin, nCol PSAY "NUMERO VOLUME DO PEDIDO ANTERIOR : " + xCHAVE
Endif        

/*
If xICMS_RET > 0
	nLin++
	@ nLin, nCol PSAY "ICMS DA OPERACAO PROPRIA : "+TRANSFORM(_nICM_PROP,"@E 99999.99")
Endif
  */
Return


Static Function ImpIPI()

nLin	   := 30
_cNfOri := ""

For B:= 1 To Len(xCod_Pro)
	If B > 1
		If xNUM_NFDV[B] != xNUM_NFDV[B-1]
			_cNfOri += "/"+xNUM_NFDV[B]
		Endif
	Else
		_cNfOri += xNUM_NFDV[B]
	Endif
Next B

If xTipo = "P"
	@ nLin, 026 PSAY "COMPLEMENTO DE IPI REF. NOTA FISCAL No."+" "+Alltrim(_cNFori)+" DE "+DTOC(SF2->F2_EMISSAO)
ElseIf xTipo = "I"
	@ nLin, 026 PSAY "COMPLEMENTO DE ICMS REF. NOTA FISCAL No."+" "+Alltrim(_cNFori)+" DE "+DTOC(SF2->F2_EMISSAO)
Endif

Return
