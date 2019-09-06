
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦  PA0000  ¦ Autor ¦ Alexandro da Silva    ¦ Data ¦ 02/03/06 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Nota Fiscal de Entrada/Saida                               ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico para Clientes Microsiga                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function PA0000()

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,NTAMNF,CSTRING,CPEDANT,NLININI")
SetPrvt("XNUM_NF,XSERIE,XEMISSAO,XTOT_FAT,XLOJA,XFRETE,XFRET")
SetPrvt("XSEGURO,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XVALOR_IPI")
SetPrvt("XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO,XPLIQUI,XTIPO")
SetPrvt("XESPECIE,XVOLUME,CPEDATU,CITEMATU,XPED_VEND,XITEM_PED")
SetPrvt("XNUM_NFDV,XPREF_DV,XICMS,XCOD_PRO,XQTD_PRO,XPRE_UNI")
SetPrvt("XPRE_TAB,XIPI,XVAL_IPI,XDESC,XVAL_DESC,XVAL_MERC")
SetPrvt("XTES,XCF,XICMSOL,XICM_PROD,XPESO_PRO,XPESO_UNIT")
SetPrvt("XDESCRICAO,XUNID_PRO,XCOD_TRIB,XMEN_TRIB,XCOD_FIS,XCLAS_FIS")
SetPrvt("XMEN_POS,XISS,XTIPO_PRO,XLUCRO,XCLFISCAL,XPESO_LIQ")
SetPrvt("I,NPELEM,_CLASFIS,NPTESTE,XPESO_LIQUID,XPED")
SetPrvt("XPESO_BRUTO,XP_LIQ_PED,XCLIENTE,XTIPO_CLI,XCOD_MENS,XMENSAGEM")
SetPrvt("XTPFRETE,XCONDPAG,XCOD_VEND,XDESC_NF,XDESC_PAG,XPED_CLI")
SetPrvt("XDESC_PRO,J,XCOD_CLI,XNOME_CLI,XEND_CLI,XBAIRRO")
SetPrvt("XCEP_CLI,XCOB_CLI,XREC_CLI,XMUN_CLI,XEST_CLI,XCGC_CLI")
SetPrvt("XINSC_CLI,XTRAN_CLI,XTEL_CLI,XFAX_CLI,XSUFRAMA,XCALCSUF")
SetPrvt("ZFRANCA,XVENDEDOR,XBSICMRET,XNOME_TRANSP,XEND_TRANSP,XMUN_TRANSP")
SetPrvt("XEST_TRANSP,XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP,XPARC_DUP,XVENC_DUP")
SetPrvt("XVALOR_DUP,XDUPLICATAS,XNATUREZA,XFORNECE,XNFORI,XPEDIDO")
SetPrvt("XPESOPROD,XFAX,NOPC,CCOR,NTAMDET,XB_ICMS_SOL")
SetPrvt("XV_ICMS_SOL,NCONT,NCOL,NTAMOBS,NAJUSTE,BB,xINC_TRANSP")

Private _cPedEXp,_lExport,_lCart
Private _lImpr,_aMens
Private	xPCM
Private _nValICM := 0
Private	xAFM
Private	xAEM,_nMOeda := _nVlTot := _nVlOut := 0
Private _cTpCond := ""
Private _nContDup
Private xDespAce := xSeguro := xFrete := xFret := 0

//+--------------------------------------------------------------+
//¦ Define Variaveis Ambientais                                  ¦
//+--------------------------------------------------------------+
//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01             // Da Nota Fiscal                       ¦
//¦ mv_par02             // Ate a Nota Fiscal                    ¦
//¦ mv_par03             // Da Serie                             ¦
//¦ mv_par04             // Nota Fiscal de Entrada/Saida         ¦
//+--------------------------------------------------------------+

CbTxt    := ""
CbCont   := ""
nOrdem   := 0
Alfa     := 0
Z        := 0
M        := 0
tamanho  := "G"
limite   := 220
titulo   := PADC("Nota Fiscal - Nfiscal",74)
cDesc1   := PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida",74)
cDesc2   := ""
cDesc3   := PADC("da Nfiscal",74)
cNatureza:= ""
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog := "PA0000"
cPerg    := "NFSIGW"
nLastKey :=  0
lContinua:= .T.
nLin     := 0
wnrel    := "PA0000"


nTamNf   :=72     // Apenas Informativo


Pergunte(cPerg,.F.)               // Pergunta no SX1

cString  :="SF2"


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
	dbSeek(xFilial("SF2")+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
	dbSetOrder(3)
	dbSeek(xFilial("SD2")+mv_par01+mv_par03)
	cPedant := SD2->D2_PEDIDO
Else
	dbSelectArea("SF1")                // * Cabecalho da Nota Fiscal Entrada
	DbSetOrder(1)
	dbSeek(xFilial("SF1")+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD1")                // * Itens da Nota Fiscal de Entrada
	dbSetOrder(3)
Endif

@ 0,0 Psay AvalImp(limite)

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
		
		xNOME_TRANSP := ""
		xEND_TRANSP  := ""
		xMUN_TRANSP  := ""
		xEST_TRANSP  := ""
		xVIA_TRANSP  := ""
		xCGC_TRANSP  := ""
		xTEL_TRANSP  := ""
		xINC_TRANSP  := ""
		XPESO_BRUTO  := 0
		xPeso_Liq    := 0
		xVolume      := 0
		xDespAce     := 0
		_nVlTot      := 0
		_nVlOut      := 0
		
		nLinIni:= nLin
		_lCart := .F.                         // Linha Inicial da Impressao
		
		// * Cabecalho da Nota Fiscal
		
		xNUM_NF     :=SF2->F2_DOC             // Numero
		xSERIE      :=SF2->F2_SERIE           // Serie
		xEMISSAO    :=SF2->F2_EMISSAO         // Data de Emissao
		xTOT_FAT    :=SF2->F2_VALFAT          // Valor Total da Fatura
		if xTOT_FAT == 0
			xTOT_FAT := SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE
		endif
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
		xPLIQUI     :=SF2->F2_PLIQUI          // Peso Liquido
		xTIPO       :=SF2->F2_TIPO            // Tipo do Cliente
		xESPECIE    :=SF2->F2_ESPECI1         // Especie 1 no Pedido
		
		If SF2->F2_EST == "EX"
			_lExport := .T.
		Else
			xVOLUME     :=SF2->F2_VOLUME1         // Volume 1 no Pedido
			_lExport     := .F.
		Endif
		
		dbSelectArea("SD2")                   // * Itens de Venda da N.F.
		dbOrderNickName("INDSD24")
		dbSeek(xFilial("SD2")+xNUM_NF+xSERIE)
		
		cPedAtu     := SD2->D2_PEDIDO
		cItemAtu    := SD2->D2_ITEMPV
		
		xPED_VEND   :={}       
		_aDESCSZ2   :={}                         // DESCRICAO PRODUTO X CLIENTE
		xITEM_PED   :={}                         // Numero do Item do Pedido de Venda
		xNUM_NFDV   :={}                         // nUMERO QUANDO HOUVER DEVOLUCAO
		xPREF_DV    :={}                         // Serie  quando houver devolucao
		xItemOri    :={}
		xICMS       :={}                         // Porcentagem do ICMS
		xCOD_PRO    :={}                         // Codigo  do Produto
		xQTD_PRO    :={}                         // Peso/Quantidade do Produto
		xPRE_UNI    :={}                         // Preco Unitario de Venda
		xPRE_TAB    :={}                         // Preco Unitario de Tabela
		xIPI        :={}                         // Porcentagem do IPI
		xVAL_IPI    :={}                         // Valor do IPI
		xDESC       :={}                         // Desconto por Item
		xVAL_DESC   :={}                         // Valor do Desconto
		xVAL_MERC   :={}                         // Valor da Mercadoria
		xTES        :={}                         // TES
		xCF         :={}                         // Classificacao quanto natureza da Operacao
		xICMSOL     :={}                         // Base do ICMS Solidario
		xICM_PROD   :={}                         // ICMS do Produto
		XFORMULA    :={}
		_nValICM    := 0
		
		While !eof() .and. SD2->D2_DOC==xNUM_NF .and. SD2->D2_SERIE==xSERIE
			If SD2->D2_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
				DbSkip()                   // do Parametro Informado !!!
				Loop
			Endif
			
			_cDescSZ2 := ""
			If SD2->D2_CLIENTE == "000008"
				dbSelectArea("SC6")
				dbSeek(xFilial("SC6")+SD2->D2_PEDIDO + SD2->D2_ITEMPV)
				
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
						dbSeek(xFilial("SB1")+SD2->D2_COD)
						
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
				dbSeek(xFilial("SC6")+SD2->D2_PEDIDO + SD2->D2_ITEMPV)
				
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
					dbSeek(xFilial("SB1")+SD2->D2_COD)
					
					If SB1->B1_PICM > 0
						_nPerDes := SB1->B1_PICM
					Else
						_nPerDes := 18
					Endif
					_nValICM += (_nVal * SD2->D2_QUANT)  * (_nPerDes/100)
				Endif
			Endif
			
			AADD(xPED_VEND ,SD2->D2_PEDIDO)
			AADD(xITEM_PED ,SD2->D2_ITEMPV)        
			If xTipo = "C"
				AADD(xNUM_NFDV,SD2->D2_NFORI)
			Else	
				If !Empty(SD2->D2_NFORI)
					If Ascan(xNUM_NFDV,SD2->D2_NFORI)==0
						AADD(xNUM_NFDV,SD2->D2_NFORI)
					Endif
				Endif
  			Endif
			AADD(xPREF_DV  ,SD2->D2_SERIORI)
			AADD(xItemOri  ,SD2->D2_ITEMORI)
			AADD(xICMS     ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
			AADD(xCOD_PRO  ,SD2->D2_COD)
			AADD(xQTD_PRO  ,SD2->D2_QUANT)     // Guarda as quant. da NF
			AADD(xPRE_UNI  ,SD2->D2_PRCVEN)
			AADD(xPRE_TAB  ,SD2->D2_PRUNIT)
			AADD(xIPI      ,IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI))
			AADD(xVAL_IPI  ,SD2->D2_VALIPI)
			AADD(xDESC     ,SD2->D2_DESC)
			AADD(xVAL_MERC ,SD2->D2_TOTAL)
			AADD(xTES      ,SD2->D2_TES)
			AADD(xCF       ,SD2->D2_CF)
			AADD(xICM_PROD ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
			
			dbSelectArea("SD2")
			dbskip()
		End
		
		dbSelectArea("SB1")                     // * Desc. Generica do Produto
		dbSetOrder(1)
		xPESO_PRO  :={}                           // Peso Liquido
		xPESO_UNIT :={}                         // Peso Unitario do Produto
		xDESCRICAO :={}                         // Descricao do Produto
		xUNID_PRO  :={}                           // Unidade do Produto
		xCOD_TRIB  :={}                           // Codigo de Tributacao
		xMEN_TRIB  :={}                           // Mensagens de Tributacao
		xCOD_FIS   :={}                           // Cogigo Fiscal
		xCLAS_FIS  :={}                           // Classificacao Fiscal
		xMEN_POS   :={}                           // Mensagem da Posicao IPI
		xISS       :={}                           // Aliquota de ISS
		xTIPO_PRO  :={}                           // Tipo do Produto
		xLUCRO     :={}                           // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL  :={}
		xPESO_LIQ  := 0
		_aCompIPI  := {}
		_CLASFIS   := ""
		I:=1
		
		For I:=1 to Len(xCOD_PRO)
			
			dbSelectArea("SB1")                     // * Desc. Generica do Produto
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+xCOD_PRO[I])
			AADD(xPESO_PRO ,SB1->B1_PESO * xQTD_PRO[I])
			
			If !_lExport
				xPESO_LIQ  := xPESO_LIQ + xPESO_PRO[I]
			Endif
			AADD(xPESO_UNIT , SB1->B1_PESO)
			AADD(_aCompIPI , SB1->B1_IPI)
			AADD(xUNID_PRO ,SB1->B1_UM)
			AADD(xDESCRICAO ,SB1->B1_DESC)
			AADD(xCOD_TRIB ,SB1->B1_ORIGEM)
			If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
				AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
			Endif
			
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
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
			Next
			
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
			
			dbSeek(xFilial("SC5")+xPED_VEND[I])
			
			If ASCAN(xPED,xPED_VEND[I])==0
				dbSeek(xFilial("SC5")+xPED_VEND[I])
				xCLIENTE    := SC5->C5_CLIENTE            // Codigo do Cliente
				_cPedExp    := SC5->C5_PEDEXP
				xTIPO_CLI   := SC5->C5_TIPOCLI            // Tipo de Cliente
				xPCM        := SC5->C5_PCM
				xAFM        := SC5->C5_AFM
				xAEM        := SC5->C5_AEM
				If Empty(xCOD_MENS)
					xCOD_MENS   :=SC5->C5_MENPAD             // Codigo da Mensagem Padrao
				Endif
				xMENSAGEM   :=SC5->C5_MENNOTA            // Mensagem para a Nota Fiscal

				If SC5->C5_TPFRETE = "C"
  					xTPFRETE    := "1"
  				ElseIf 	SC5->C5_TPFRETE = "F"
  					xTPFRETE    := "2"
  				Else
  					xTPFRETE    := " "
  				Endif	
  				
//				xTPFRETE    :=SC5->C5_TPFRETE            // Tipo de Entrega
				xCONDPAG    :=SC5->C5_CONDPAG            // Condicao de Pagamento
				If !_lExport
					xPESO_BRUTO :=SC5->C5_PBRUTO             // Peso Bruto
					xP_LIQ_PED  :=xP_LIQ_PED + SC5->C5_PESOL // Peso Liquido
				Endif
				
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
			
			AADD(_aPedExp,SC5->C5_PEDEXP)
			If xP_LIQ_PED >0
				xPESO_LIQ := xP_LIQ_PED
			Endif
		Next
		
		dbSelectArea("SE4")                    // Condicao de Pagamento
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+xCONDPAG)
		xDESC_PAG := SE4->E4_DESCRI
		_cTpCond  := SE4->E4_TIPO
		
		dbSelectArea("SC6")                    // * Itens de Pedido de Venda
		dbSetOrder(1)
		xPED_CLI :={}                          // Numero de Pedido
		xDESC_PRO:={}                          // Descricao aux do produto
		xPROD_CLI:={}                          // Codigo da Peça Cliente
		
		J:=Len(xPED_VEND)
		For I:=1 to J			
			dbSelectArea("SC6")                    // * Itens de Pedido de Venda
			dbSeek(xFilial("SC6")+xPED_VEND[I]+xITEM_PED[I])
			_cDESCSZ2 := SC6->C6_DESCRI
			
			If _lExport
				
				_cItemPv := SC6->C6_ITEM
				
				If SC6->C6_CLI  == "000171"
					dbSelectArea("SZ2")
					dbSetOrder(6)
					If dbSeek(xFilial("SZ2")+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_CPROCLI)
						_cDESCSZ2 := SZ2->Z2_DESCCLI
					Endif			
				Endif
				dbSelectArea("EE7")
				dbSetOrder(1)
				If dbSeek(xFilial("EE7")+_aPedExp[I])
					dbSelectArea("EE8")
					dbOrderNickName("INDEE81")
					If dbSeek(xFilial("EE8")+_aPedExp[I] + _cItemPv )
						xPESO_BRUTO += EE8->EE8_PSBRTO
						xPESO_LIQ   += EE8->EE8_PSLQTO
						xVolume     += EE8->EE8_QTDEM1
						//
						If EE7->EE7_INCOTE $ "CIF/CIP"
							dbSelectArea("SM2")
							dbSetOrder(1)
							If dbSeek(SF2->F2_EMISSAO)
								_nMoeda := SM2->M2_MOEDA2
							Endif
							xFret    := Round(EE7->EE7_FREHIS * _nMoeda,2)
							xFrete   := Round(EE7->EE7_FRPREV * _nMoeda,2)
							xSeguro  := Round(EE7->EE7_SEGPRE * _nMoeda,2)
							xDespAce := Round(EE7->EE7_DESPIN * _nMoeda,2)
							_nVlOut  := (xFrete + xSeguro + xDespAce)
						Endif
						//
					Else
						xPESO_BRUTO := SF2->F2_PBRUTO           // Peso Bruto
						xPESO_LIQ   := SF2->F2_PLIQUI
						xVOLUME     := SF2->F2_VOLUME1         // Volume 1 no Pedido
					Endif
				Else
					xPESO_BRUTO := SF2->F2_PBRUTO           // Peso Bruto
					xPESO_LIQ   := SF2->F2_PLIQUI
					xVOLUME     := SF2->F2_VOLUME1
				Endif
				dbSelectArea("EEC")
				dbOrderNickName("INDEEC3")
				If dbSeek(xFilial("EEC")+_aPedExp[I] )
					If EEC->EEC_INCOTE $ "CIF/CIP"
						/*
						dbSelectArea("SM2")
						dbSetOrder(1)
						If dbSeek(SF2->F2_EMISSAO)
							_nMoeda := SM2->M2_MOEDA2
						Endif
						xFret  := Round(EEC->EEC_FREHIS * _nMoeda,2)						
						
						xSeguro := Round(EEC->EEC_SEGPRE * _nMoeda,2)
						xDespAce:= Round(EEC->EEC_DESPIN * _nMoeda,2)
						_nVlOut := (xFrete + xSeguro + xDespAce)
						*/
					Endif
				Endif
			Endif
			
			AADD(xPED_CLI ,SC6->C6_PEDCLI)
			AADD(xDESC_PRO,_cDESCSZ2)
			AADD(xVAL_DESC,SC6->C6_VALDESC)
			AADD(xPROD_CLI,SC6->C6_CPROCLI)
		Next
		
		If xTIPO=='N' .OR. xTIPO=='C' .OR. xTIPO=='P' .OR. xTIPO=='I' .OR. xTIPO=='S' .OR. xTIPO=='T' .OR. xTIPO=='O'
			
			dbSelectArea("SA1")                // * Cadastro de Clientes
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+xCLIENTE+xLOJA)
			xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
			xNOME_CLI:=SA1->A1_NOME            // Nome
			xEND_CLI :=SA1->A1_END             // Endereco
			xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
			xCEP_CLI :=SA1->A1_CEP             // CEP
			xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
			xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
			xMUN_CLI :=SA1->A1_MUN             // Municipio
			xEST_CLI :=SA1->A1_EST             // Estado
			xCGC_CLI :=SA1->A1_CGC             // CGC
			xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
			xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
			xTEL_CLI :=SA1->A1_TEL             // Telefone
			xFAX_CLI :=SA1->A1_FAX             // Fax
			xSUFRAMA :=SA1->A1_SUFRAMA            // Codigo Suframa
			xCALCSUF :=SA1->A1_CALCSUF            // Calcula Suframa
			// Alteracao p/ Calculo de Suframa
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
			dbSeek(xFilial("SA2")+xCLIENTE+xLOJA)
			xCOD_CLI :=SA2->A2_COD             // Codigo do Fornecedor
			xNOME_CLI:=SA2->A2_NOME            // Nome Fornecedor
			xEND_CLI :=SA2->A2_END             // Endereco
			xBAIRRO  :=SA2->A2_BAIRRO          // Bairro
			xCEP_CLI :=SA2->A2_CEP             // CEP
			xCOB_CLI :=""                      // Endereco de Cobranca
			xREC_CLI :=""                      // Endereco de Entrega
			xMUN_CLI :=SA2->A2_MUN             // Municipio
			xEST_CLI :=SA2->A2_EST             // Estado
			xCGC_CLI :=SA2->A2_CGC             // CGC
			xINSC_CLI:=SA2->A2_INSCR           // Inscricao estadual
			xTRAN_CLI:=SA2->A2_TRANSP          // Transportadora
			xTEL_CLI :=SA2->A2_TEL             // Telefone
			xFAX_CLI :=SA2->A2_FAX             // Fax
		Endif
		dbSelectArea("SA3")                   // * Cadastro de Vendedores
		dbSetOrder(1)
		xVENDEDOR:={}                         // Nome do Vendedor
		I:=1
		J:=Len(xCOD_VEND)
		For I:=1 to J
			dbSeek(xFilial("SA3")+xCOD_VEND[I])
			Aadd(xVENDEDOR,SA3->A3_NREDUZ)
		Next
		
		If xICMS_RET >0                          // Apenas se ICMS Retido > 0
			dbSelectArea("SF3")                   // * Cadastro de Livros Fiscais
			dbSetOrder(4)
			dbSeek(xFilial("SF3")+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
			If Found()
				xBSICMRET:=F3_VALOBSE
			Else
				xBSICMRET:=0
			Endif
		Else
			xBSICMRET:=0
		Endif
		dbSelectArea("SA4")                   // * Transportadoras
		dbSetOrder(1)
		If dbSeek(xFilial("SA4")+SF2->F2_TRANSP)
			xNOME_TRANSP :=SA4->A4_NOME           // Nome Transportadora
			xEND_TRANSP  :=SA4->A4_END            // Endereco
			xMUN_TRANSP  :=SA4->A4_MUN            // Municipio
			xEST_TRANSP  :=SA4->A4_EST            // Estado
			xVIA_TRANSP  :=SA4->A4_VIA            // Via de Transporte
			xCGC_TRANSP  :=SA4->A4_CGC            // CGC
			xTEL_TRANSP  :=SA4->A4_TEL            // Fone
			xINC_TRANSP  :=SA4->A4_INSEST         // Inscrição Estadual
		Endif
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		xPARC_DUP  :={}                       // Parcela
		xVENC_DUP  :={}                       // Vencimento
		xVALOR_DUP :={}                       // Valor
		xDUPLICATAS:=IIF(dbSeek(xFilial("SE1")+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
		_nValor   := 0
		_cDup     := ""
		_dVencto  := CTOD("")
		while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			If !("NF" $ SE1->E1_TIPO)
				dbSkip()
				Loop
			Endif
			AADD(xPARC_DUP ,SE1->E1_PARCELA)
			AADD(xVENC_DUP ,SE1->E1_VENCTO)
			AADD(xVALOR_DUP,SE1->E1_VALOR)
			_cDup    := SE1->E1_NUM
			_dVencto := SE1->E1_VENCTO
			_nValor  += SE1->E1_VALOR
			dbSkip()
		EndDo
		
		dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
		DbSetOrder(1)
		dbSeek(xFilial("SF4")+xTES[1])
		xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
		
		
		Imprime()
		
		nLin:=0
		dbSelectArea("SF2")
		dbSkip()                      // passa para a proxima Nota Fiscal
		
	EndDo
Else
	
	xPED_CLI  := {}                          // Numero de Pedido
	xPED_VEND := {}
	xITEM_PED := {}
	
	dbSelectArea("SF1")              // * Cabecalho da Nota Fiscal Entrada
	
	dbSeek(xFilial("SF1")+mv_par01+mv_par03,.t.)
	
	While !eof() .and. SF1->F1_DOC <= mv_par02 .and. SF1->F1_SERIE == mv_par03 .and. lContinua
		
		If SF1->F1_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
			DbSkip()                    // do Parametro Informado !!!
			Loop
		Endif
		//+-----------------------------------------------------------+
		//¦ Inicializa  regua de impressao                            ¦
		//+-----------------------------------------------------------+
		SetRegua(Val(mv_par02)-Val(mv_par01))
		
		IF lAbortPrint
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
		
		nLinIni:=nLin                         // Linha Inicial da Impressao
		
		xNUM_NF     :=SF1->F1_DOC             // Numero
		xSERIE      :=SF1->F1_SERIE           // Serie
		xFORNECE    :=SF1->F1_FORNECE         // Cliente/Fornecedor
		xEMISSAO    :=SF1->F1_EMISSAO         // Data de Emissao
		xTOT_FAT    :=SF1->F1_VALBRUT         // Valor Bruto da Compra
		xLOJA       :=SF1->F1_LOJA            // Loja do Cliente
		xFRETE      :=SF1->F1_FRETE           // Frete
		xSEGURO     :=SF1->F1_DESPESA         // Despesa
		xBASE_ICMS  :=SF1->F1_BASEICM         // Base   do ICMS
		xBASE_IPI   :=SF1->F1_BASEIPI         // Base   do IPI
		xBSICMRET   :=SF1->F1_BRICMS          // Base do ICMS Retido
		xVALOR_ICMS :=SF1->F1_VALICM          // Valor  do ICMS
		xICMS_RET   :=SF1->F1_ICMSRET         // Valor  do ICMS Retido
		xVALOR_IPI  :=SF1->F1_VALIPI          // Valor  do IPI
		xVALOR_MERC :=SF1->F1_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC :=SF1->F1_DUPL            // Numero da Duplicata
		xCOND_PAG   :=SF1->F1_COND            // Condicao de Pagamento
		xTIPO       :=SF1->F1_TIPO            // Tipo do Cliente
		xNFORI      :=SF1->F1_NFORI           // NF Original
		xPREF_DV    :=SF1->F1_SERIORI         // Serie Original
		XFORMULA    :={}
		
		dbSelectArea("SD1")                   // * Itens da N.F. de Compra
		dbSetOrder(1)
		dbSeek(xFilial("SD1")+xNUM_NF+xSERIE+xFORNECE+xLOJA)
		
		cPedAtu := SD1->D1_PEDIDO
		cItemAtu:= SD1->D1_ITEMPC
		
		xPEDIDO  :={}                         // Numero do Pedido de Compra
		xITEM_PED:={}                         // Numero do Item do Pedido de Compra
		xNUM_NFDV:={}                         // Numero quando houver devolucao
		xPREF_DV :={}                         // Serie  quando houver devolucao
		xICMS    :={}                         // Porcentagem do ICMS
		xCOD_PRO :={}                         // Codigo  do Produto
		xQTD_PRO :={}                         // Peso/Quantidade do Produto
		xPRE_UNI :={}                         // Preco Unitario de Compra
		xIPI     :={}                         // Porcentagem do IPI
		xPESOPROD:={}                         // Peso do Produto
		xVAL_IPI :={}                         // Valor do IPI
		xDESC    :={}                         // Desconto por Item
		xVAL_DESC:={}                         // Valor do Desconto
		xVAL_MERC:={}                         // Valor da Mercadoria
		xTES     :={}                         // TES
		xCF      :={}                         // Classificacao quanto natureza da Operacao
		xICMSOL  :={}                         // Base do ICMS Solidario
		xICM_PROD:={}                         // ICMS do Produto
		_aMens   :={}
		
		while !eof() .and. SD1->D1_DOC==xNUM_NF
			If SD1->D1_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
				DbSkip()                      // do Parametro Informado !!!
				Loop
			Endif
			
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
			AADD(_aMens    ,ALLTRIM(SD1->D1_MENNOTA)) // Mensagem do Item P/ Nota
			dbskip()
		End
		
		dbSelectArea("SB1")                             // * Desc. Generica do Produto
		dbSetOrder(1)
		xUNID_PRO  := {}                                // Unidade do Produto
		xDESC_PRO  := {}                                // Descricao do Produto
		xMEN_POS   := {}                                // Mensagem da Posicao IPI
		xDESCRICAO := {}                                // Descricao do Produto
		xCOD_TRIB  := {}                                // Codigo de Tributacao
		xMEN_TRIB  := {}                                // Mensagens de Tributacao
		xCOD_FIS   := {}                                // Cogigo Fiscal
		xCLAS_FIS  := {}                                // Classificacao Fiscal
		xISS       := {}                                // Aliquota de ISS
		xTIPO_PRO  := {}                                // Tipo do Produto
		xLUCRO     := {}                                // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL  := {}
		xSUFRAMA   := ""
		xCALCSUF   := ""
		_CLASFIS   := ""
		I:=1
		For I:=1 to Len(xCOD_PRO)
			
			dbSeek(xFilial("SB1")+xCOD_PRO[I])
			dbSelectArea("SB1")
			
			AADD(xDESC_PRO ,SB1->B1_DESC)
			AADD(xUNID_PRO ,SB1->B1_UM)
			AADD(xCOD_TRIB ,SB1->B1_ORIGEM)
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
			
			if npElem == 0
				AADD(xCLAS_FIS  ,SB1->B1_POSIPI)
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
		
		dbSelectArea("SE4")                             // Condicao de Pagamento
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+xCOND_PAG)
		xDESC_PAG := SE4->E4_DESCRI
		
		If xTIPO $ "B/D"
			
			dbSelectArea("SA1")                // * Cadastro de Clientes
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+xFORNECE+xLoja)
			xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
			xNOME_CLI:=SA1->A1_NOME            // Nome
			xEND_CLI :=SA1->A1_END             // Endereco
			xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
			xCEP_CLI :=SA1->A1_CEP             // CEP
			xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
			xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
			xMUN_CLI :=SA1->A1_MUN             // Municipio
			xEST_CLI :=SA1->A1_EST             // Estado
			xCGC_CLI :=SA1->A1_CGC             // CGC
			xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
			xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
			xTEL_CLI :=SA1->A1_TEL             // Telefone
			xFAX_CLI :=SA1->A1_FAX             // Fax
			
		Else
			
			dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial("SA2")+xFORNECE+xLOJA)
			xCOD_CLI :=SA2->A2_COD                // Codigo do Cliente
			xNOME_CLI:=SA2->A2_NOME               // Nome
			xEND_CLI :=SA2->A2_END                // Endereco
			xBAIRRO  :=SA2->A2_BAIRRO             // Bairro
			xCEP_CLI :=SA2->A2_CEP                // CEP
			xCOB_CLI :=""                         // Endereco de Cobranca
			xREC_CLI :=""                         // Endereco de Entrega
			xMUN_CLI :=SA2->A2_MUN                // Municipio
			xEST_CLI :=SA2->A2_EST                // Estado
			xCGC_CLI :=SA2->A2_CGC                // CGC
			xINSC_CLI:=SA2->A2_INSCR              // Inscricao estadual
			xTRAN_CLI:=SA2->A2_TRANSP             // Transportadora
			xTEL_CLI :=SA2->A2_TEL                // Telefone
			xFAX     :=SA2->A2_FAX                // Fax
			
		EndIf
		
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		xPARC_DUP  :={}                       // Parcela
		xVENC_DUP  :={}                       // Vencimento
		xVALOR_DUP :={}                       // Valor
		xDUPLICATAS:=IIF(dbSeek(xFilial("SE1")+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
		_nContDup := 0
		while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			_nContDup++
			AADD(xPARC_DUP ,SE1->E1_PARCELA)
			AADD(xVENC_DUP ,SE1->E1_VENCTO)
			AADD(xVALOR_DUP,SE1->E1_VALOR)
			dbSkip()
		EndDo
		
		dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
		dbSetOrder(1)
		dbSeek(xFilial("SF4")+xTes[1])
		xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
		
		xNOME_TRANSP :=" "           // Nome Transportadora
		xEND_TRANSP  :=" "           // Endereco
		xMUN_TRANSP  :=" "           // Municipio
		xEST_TRANSP  :=" "           // Estado
		xVIA_TRANSP  :=" "           // Via de Transporte
		xCGC_TRANSP  :=" "           // CGC
		xTEL_TRANSP  :=" "           // Fone
		xTPFRETE     :=" "           // Tipo de Frete
		xVOLUME      := 0            // Volume
		xESPECIE     :=" "           // Especie
		xPESO_LIQ    := 0            // Peso Liquido
		xPESO_BRUTO  := 0            // Peso Bruto
		xCOD_MENS    :=" "           // Codigo da Mensagem
		xMENSAGEM    :=" "           // Mensagem da Nota
		xPESO_LIQUID :=" "
		
		
		Imprime()
		
		IncRegua()                    // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF1")
		dbSkip()                     // e passa para a proxima Nota Fiscal
		
	EndDo
Endif

dbSelectArea("SF2")
Retindex("SF2")
dbSelectArea("SF1")
Retindex("SF1")
dbSelectArea("SD2")
Retindex("SD2")
dbSelectArea("SD1")
Retindex("SD1")
Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ VERIMP   ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Verifica posicionamento de papel na Impressora             ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

//+---------------------+
//¦ Inicio da Funcao    ¦
//+---------------------+

Static Function VerImp()

nLin   := 0                // Contador de Linhas
nLinIni:=0
If aReturn[5]==2
	
	nOpc:= 1
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

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ CLASFIS  ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 16/11/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao de Array com as Classificacoes Fiscais           ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

//+---------------------+
//¦ Inicio da Funcao    ¦
//+---------------------+

Static Function CLASFIS()

Local nLen := Len(xCLFISCAL)

@ nLin,006 PSAY "Classificacao Fiscal"
nLin := nLin + 1

If nLen > 12
	nLen := 12
Endif

For nCont := 1 to nLen
	nCol := If(Mod(nCont,2) != 0, 06, 33)
	@ nLin, nCol   PSAY xCLFISCAL[nCont] + "-"
	@ nLin, nCol+ 05 PSAY Transform(xCLAS_FIS[nCont],"@r 99.99.99.99.99")
	nLin := nLin + If(Mod(nCont,2) != 0, 0, 1)
Next

Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPRIME  ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Imprime a Nota Fiscal de Entrada e de Saida                ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Generico RDMAKE                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function Imprime()

@ 02, 000 PSAY Chr(15)                // Compressao de Impressao


If mv_par04 == 1
	@ 03, 114 PSAY "X"
Else
	@ 03, 103 PSAY "X"
Endif


@ 09, 014 PSAY xNATUREZA               // Texto da Natureza de Operacao
@ 09, 040 PSAY xCF[1] Picture "@R 9.999" // Codigo da Natureza de Operacao

@ 11, 014 PSAY xNOME_CLI              //Nome do Cliente

If !EMPTY(xCGC_CLI)                   // Se o C.G.C. do Cli/Forn nao for Vazio
	@ 12,103 PSAY xCGC_CLI Picture"@R 99.999.999/9999-99"
Else
	@ 12,103 PSAY " "                // Caso seja vazio
Endif
@ 12, 132 PSAY xEMISSAO              // Data da Emissao do Documento
@ 13, 014 PSAY xEND_CLI                                 // Endereco
@ 14, 014 PSAY xBAIRRO                                  // Bairro
@ 14, 085 PSAY xCEP_CLI Picture"@R 99999-999"           // CEP
@ 15, 014 PSAY xMUN_CLI                               // Municipio
@ 15, 088 PSAY xEST_CLI                               // U.F.
@ 16, 014 PSAY xTEL_CLI                               // Telefone/FAX
@ 16, 103 PSAY xINSC_CLI                              // Insc. Estadual

If mv_par04 == 2
	nLin:=19
	BB:=1
	nCol := 10             //  duplicatas
	DUPLIC()
	
Endif

@ 23, 025 PSAY xCOB_CLI          // Endereco de Cobrança
//@ 23, 014 PSAY xCOB_CLI          // Endereco de Cobrança

_cExtenso := Extenso(xTot_Fat,.F.,)

If xTipo != "I"
	@ 25, 025 PSAY _cExtenso         // Valor Por Extenso
//	@ 24, 020 PSAY _cExtenso         // Valor Por Extenso
Endif

nLin := 29
_lImpr := .T.
ImpDet()                 // Detalhe da NF

If MV_PAR04 == 1
	// Começa na Linha 29
	
	//	nlin := 43 Posição Anterior
	nLin := 29+Len(xCod_Pro)
	
	nLin+=4
	For I:= 1 To Len(_aMens)
		If !Empty(_aMens[i])
			_nPosM := At(";",_aMens[I])-1
			If _nPosM <> 0
				For A:= 1 To Len(_aMens[I])
					If !Empty(Substr(_aMens[I],A,_nPosM))
						@ nLin, 002 PSAY Substr(_aMens[I],A,_nPosM)
					Endif
					If _nPosM > 2
						A +=_nPosM
					Endif
					
					If _nPosM == -1
						@ nLin, 002 PSAY Substr(_aMens[I],A,200)
						A:= Len(_aMens[I])
					Endif
					_nPosM := At(";",Substr(_aMens[I],A+1,200))-1
					nLin++
				Next A
			Else
				@ nLin, 002 PSAY _aMens[I]
				nLin++
			Endif
		Endif
	Next
	nLin := 44
	ImpMenp()             // Imprime Mensagem Padrao da Nota Fiscal
ElseIf mv_par04 == 2 .and. Len(xISS) == 0
	_cCliente := SF2->F2_CLIENTE
	_cLoja    := SF2->F2_LOJA
	If xTipo == "I"
		dbSelectArea("SF2")
		_aAliSF2 := GetArea()
		dbSetOrder(1)
		If dbSeek(xFilial("SF2")+xNUM_NFDV[1]+"1  "+_cCliente+_cLoja)
//		If dbSeek(xFilial("SF2")+xNUM_NFDV[1]+"UNI"+_cCliente+_cLoja)
			nLin := 44
			@ 43, 014 PSAY "COMPLEMENTO REF. A NOTA FISCAL No."+" "+xNUM_NFDV[1]+" DE "+DTOC(SF2->F2_EMISSAO)
			@ 44, 014 PSAY "ONDE O ICMS FOI DESTACADO A MENOR."
			nLin++
		Endif
		RestArea(_aAliSF2)
		nLin++
	ElseIf xTipo == "P"
		dbSelectArea("SF2")
		_aAliSF2 := GetArea()
		dbSetOrder(1)
		If dbSeek(xFilial("SF2")+xNUM_NFDV[1]+"1  " + _cCliente + _cLoja)
//		If dbSeek(xFilial("SF2")+xNUM_NFDV[1]+"UNI" + _cCliente + _cLoja)
			nLin := 44
			@ 43, 014 PSAY "COMPLEMENTO REF. ITEM DA NOTA FISCAL No."+" "+xNUM_NFDV[1]+" DE "+DTOC(SF2->F2_EMISSAO)
			@ 43, 137  PSAY _aCompIPI[1]               Picture "@E 9.99"
			@ 43, 142  PSAY xVAL_Merc[1]               Picture "@E 9,999,999.99"
			@ 44, 014 PSAY "ONDE O IPI FOI DESTACADO A MENOR."
			nLin++
		Endif
		RestArea(_aAliSF2)
		nLin++
	ElseIf xTipo == "C"
		nLin := 45
		ImpMenp()
		_cNfOri := ""
		For AZ:= 1 To Len(xNUM_NFDV)
			If AZ != Len(xNUM_NFDV)
				_cNfOri += xNUM_NFDV[AZ]+" / "
			Else
				_cNfOri += xNUM_NFDV[AZ]
			Endif
		Next AZ
		
		@ nLin, 002 PSAY "REF. N.FISCAL ORIGINAL No. "+_cNfOri
	Else
		If !Empty(xMENSAGEM)
			MensObs()             // Imprime Mensagem de Observacao
		Endif
		ImpMenp()                 // Imprime Mensagem Padrao da Nota Fiscal
	Endif
	
Endif

If xTipo == "I"
	@ 50, 046  PSAY xVALOR_ICMS Picture"@E@Z 999,999,999.99"  // Valor do ICMS
ElseIf xTipo == "P"
	@ 52, 104  PSAY xTOT_FAT    Picture"@E@Z 999,999,999.99"  // Valor do IPI
	@ 52, 136  PSAY xTOT_FAT    Picture"@E@Z 999,999,999.99"  // Valor Total NF
Else
	@ 50, 016  PSAY xBASE_ICMS             Picture"@E@Z 999,999,999.99"  // Base do ICMS
	@ 50, 046  PSAY xVALOR_ICMS            Picture"@E@Z 999,999,999.99"  // Valor do ICMS
	@ 50, 075  PSAY xBSICMRET              Picture"@E@Z 999,999,999.99"  // Base ICMS Ret.
	@ 50, 104  PSAY xICMS_RET              Picture"@E@Z 999,999,999.99"  // Valor  ICMS Ret.
	_nDif  := (_nVlTot + _nVlOut) - xVALOR_MERC
	@ 50, 136  PSAY (xVALOR_MERC - _nVlOut) Picture"@E@Z 999,999,999.99"  // Valor Tot. Prod.
	
	@ 52, 018  PSAY xFRETE                 Picture"@E@Z 999,999,999.99"  // Valor do Frete
	@ 52, 046  PSAY xSEGURO                Picture"@E@Z 999,999,999.99"  // Valor Seguro
	If _nMoeda > 0
		@ 52, 070  PSAY xDespAce + _nDif       Picture"@E@Z 999,999,999.99"  // Valor Seguro
	Endif
	@ 52, 104  PSAY xVALOR_IPI             Picture"@E@Z 999,999,999.99"  // Valor do IPI
	@ 52, 136  PSAY xTOT_FAT               Picture"@E@Z 999,999,999.99"  // Valor Total NF
Endif

@ 56, 005  PSAY xNOME_TRANSP                       // Nome da Transport.
//@ 56, 014  PSAY xNOME_TRANSP                       // Nome da Transport.
@ 56, 058  PSAY "["+xTPFRETE+"]"

@ 56,103 PSAY xCGC_TRANSP Picture"@R 99.999.999/9999-99"
//@ 58, 10 PSAY Substr(xEND_TRANSP,1,35)
@ 58, 05 PSAY Substr(xEND_TRANSP,1,35)
@ 58, 48 PSAY xMUN_TRANSP
@ 58, 97 PSAY xEST_TRANSP
@ 58,103 PSAY xINC_TRANSP  // Picture "@R 99.999.999/9999-99"
@ 60, 016 PSAY xVOLUME  Picture "@E@Z 999,999.99"             // Quant. Volumes
@ 60, 040 PSAY "CAIXAS"                                      // Res para Marca
@ 60, 060 PSAY "PASY "                                       // Res para Numero
@ 60, 118 PSAY xPESO_BRUTO     Picture "@E@Z 999,999.99"      // Res para Peso Bruto
@ 60, 145 PSAY xPESO_LIQ       Picture "@E@Z 999,999.99"      // Res para Peso Liquido

ImpDup()

If mv_par04 == 2
	nLin := 59
Endif

@ 75, 000 PSAY chr(18)                   // Descompressao de Impressao
//@ 78, 000 PSAY chr(18)                   // Descompressao de Impressao

SetPrc(0,0)                              // (Zera o Formulario)

Return .t.

//+---------------------+
//¦ Inicio da Funcao    ¦
//+---------------------+

Static Function DUPLIC()

nCol := 7
nAjuste := 0

If _nValor > 0
	If XCLIENTE == "000008" .Or. _cTpCond == "9"
		_cVencto := "C/ APRESENT."
	Else
		_cVencto := _dVencto
	Endif
Else
	_cVencto := _dVencto
Endif

@ nLin, 15      PSAY xEMISSAO
@ nLin, 35      PSAY XNUM_NF
@ nLin, 64      PSAY _nValor    Picture("@E 9,999,999.99")
//@ nLin, 66      PSAY _nValor    Picture("@E 9,999,999.99")

If _nContDup == 1
	@ nLin, 86      PSAY _cDup
	@ nLin, 110     PSAY _cVencto
Else
	//	If XCLIENTE == "000001"
	@ nLin, 80      PSAY "VIDE DESDOBRAMENTO ABAIXO"
//	@ nLin, 86      PSAY "VIDE DESDOBRAMENTO ABAIXO"
	//	Endif
Endif

Return
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPDET   ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao de Linhas de Detalhe da Nota Fiscal              ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function IMPDET()


If xTipo == "N" .And. MV_PAR04 == 2
	nTamDet :=8            // Tamanho da Area de Detalhe
	I:=1
	J:=1
	
	xB_ICMS_SOL:=0          // Base  do ICMS Solidario
	xV_ICMS_SOL:=0          // Valor do ICMS Solidario
	
	For I:=1 to nTamDet
		/*
		003826          PED.CLIENTE: 123456789 PED.PASY+IT :12345689
		123456789012345678901234567-901234567890123
		9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
		1               17                                    55   60       69 72           85                  105           119 123
		
		*/
		If I<= Len(xCOD_PRO)
			If xTIPO_PRO[I] != "FR"
				@ nLin,02  PSAY "PED.CLIENTE: "+Alltrim(xPED_CLI[I])+" PED.PASY+IT :"+xPED_VEND[I]+xITEM_PED[I]
				nLin:= nLin+1
				@ nLin,  02  PSAY Alltrim(xCOD_PRO[I])
				@ nLin,  17  PSAY RTrim(Substr(xDESC_PRO[I],1,22))+"-"+RTrim(xPROD_CLI[I])
				@ nLin,  55  PSAY xCOD_FIS[I]
				@ nLin,  72  PSAY xCOD_TRIB[I]
				@ nLin, 077  PSAY xUNID_PRO[I]
				@ nLin, 080  PSAY xQTD_PRO[I]               Picture "@E 999,999.9999"
				If _nMoeda > 0
					//				    _nPrTot := xVAL_MERC[I] - _nVlOut
					_nPrTot := ((xVALOR_MERC - _nVlOut) * xVAL_MERC[I]) / xVALOR_MERC
					_nPrUni := _nPrTot / xQTD_PRO[I]
					_nVlTot += _nPrTot
					@ nLin, 093  PSAY _nPrUni                  Picture "@E 99,999,999.99999"
					@ nLin, 113  PSAY _nPrTot                   Picture "@E 99,999,999.99"
				Else
					@ nLin, 093  PSAY xPRE_UNI[I]               Picture "@E 99,999,999.99999"
					@ nLin, 113  PSAY xVAL_MERC[I]              Picture "@E 99,999,999.99"
				Endif
				@ nLin, 131  PSAY xICM_PROD[I]              Picture "99"
				@ nLin, 137  PSAY xIPI[I]                   Picture "@E 99.99"
				@ nLin, 141  PSAY xVAL_IPI[I]               Picture "@E 9,999,999.99"
			Else
				@ nLin,02  PSAY "PED.CLIENTE: "+Alltrim(xPED_CLI[I])+" PED.PASY+IT :"+xPED_VEND[I]+xITEM_PED[I]
				nLin:= nLin+1
				@ nLin,  02  PSAY Alltrim(xCOD_PRO[I])
				@ nLin,  17  PSAY RTrim(Substr(xDESC_PRO[I],1,30))
				nLin++
				@ nLin,  02  PSAY RTrim(xPROD_CLI[I])
				@ nLin,  55  PSAY xCOD_FIS[I]
				@ nLin,  72  PSAY xCOD_TRIB[I]
				@ nLin,  77  PSAY xUNID_PRO[I]
				@ nLin,  80  PSAY xQTD_PRO[I]               Picture "@E 999,999.9999"
				@ nLin,  93  PSAY xPRE_UNI[I]               Picture "@E 99,999,999.99999"
				@ nLin, 113  PSAY xVAL_MERC[I]              Picture "@E 99,999,999.99"
				@ nLin, 131  PSAY xICM_PROD[I]              Picture "99"
				@ nLin, 137  PSAY xIPI[I]                   Picture "@E 99.99"
				@ nLin, 141  PSAY xVAL_IPI[I]               Picture "@E 9,999,999.99"
			Endif
			J:=J+1
		Else
			If _lImpr
				If !Empty(xPCM)
					nLin+=2
					@ nLin,  02  PSAY "Ped. : PCM "+Alltrim(xPCM)+" / AFM "+Alltrim(xAFM)+" / AEM "+Alltrim(xAEM)
				Endif
				_lImpr := .F.
			Endif
		Endif
		nLin :=nLin+1
	Next
ElseIf !xTipo $ "I/P"
	nTamDet := 16            // Tamanho da Area de Detalhe
	I:=1
	J:=1
	xB_ICMS_SOL:=0          // Base  do ICMS Solidario
	xV_ICMS_SOL:=0          // Valor do ICMS Solidario
	
	For I:=1 to nTamDet
		/*
		003826          PED.CLIENTE: 123456789 PED.PASY+IT :12345689
		123456789012345678901234567-901234567890123
		9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
		1               17                                    55   60       69 72           85                  105           119 123
		
		*/
		If I<= Len(xCOD_PRO)
			@ nLin,  02  PSAY Alltrim(xCOD_PRO[I])
			If MV_PAR04 == 2
				@ nLin,  17  PSAY Substr(xDESCRICAO[I],1,22) +" "+RTrim(xPROD_CLI[I])
			Else
				@ nLin,  17  PSAY Substr(xDESCRICAO[I],1,22)
			Endif	
			@ nLin,  55  PSAY Alltrim(xCOD_FIS[I])
			@ nLin,  72  PSAY Alltrim(xCOD_TRIB[I])
			@ nLin,  77  PSAY Alltrim(xUNID_PRO[I])
//			If xTipo = "C"
//				@ nLin,  80  PSAY Alltrim(xNUM_NFDV[I])
//			Else	
				@ nLin,  80  PSAY xQTD_PRO[I]               Picture "@E 999,999.9999"
//			Endif	
			@ nLin,  93  PSAY xPRE_UNI[I]               Picture "@E 99,999,999.99999"
			@ nLin, 113  PSAY xVAL_MERC[I]              Picture "@E 99,999,999.99"
			@ nLin, 131  PSAY xICM_PROD[I]              Picture "99"
			@ nLin, 137  PSAY xIPI[I]                   Picture "@E 99.99"
			@ nLin, 141  PSAY xVAL_IPI[I]               Picture "@E 9,999,999.99"
			J:=J+1
		Endif
		nLin :=nLin+1
	Next
Endif

Return
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ MENSOBS  ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao Mensagem no Campo Observacao                     ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function MENSOBS()

nTamObs:=150
nCol:=02
@ nLin, nCol PSAY UPPER(xMENSAGEM)
nLin++

Return
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPMENP  ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao Mensagem Padrao da Nota Fiscal                   ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function IMPMENP()

nCol:= 02
XCOD_MENS2 := ""

dbSelectArea("SF4")
_aAliSF4 := GetArea()
Z          := 1
_lMens     := .T.

For Z:=1 to Len(xTes)
	dbSelectArea("SF4")
	dbSetOrder(1)
	If dbSeek(xFilial("SF4")+xTes[Z])
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
		@ nLin, NCol PSAY\ Substr(_cMens2,148,147)
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

Static Function ImpDup()

_nLin := 71
_nCol := 67
For _nCont := 1 to Len(xVALOR_DUP)
	@ _nLin, 010   PSAY xValor_dup[_nCont]     Picture "@E 999,999,999.99"
	@ _nLin, 026   PSAY "-"+xParc_Dup[_nCont]
	@ _nLin, 033   PSAY xVenc_Dup[_nCont]
	_nCont2 := _nCont + 3
	If Len(xValor_DUP) >= _nCont2
		@ _nLin, 054   PSAY xValor_dup[_nCont2]   Picture "@E 999,999,999.99"
		@ _nLin, 072   PSAY "-"+xParc_Dup[_nCont2]
		@ _nLin, 076   PSAY xVenc_Dup[_nCont2]
	Endif
	If _nCont == 3
		_nCont := Len(xVALOR_DUP)
	Endif
	_nLin++
Next

Return
