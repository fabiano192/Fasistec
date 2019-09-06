#include "rwmake.ch"


User Function PA0018()

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
SetPrvt("XV_ICMS_SOL,NCONT,NCOL,NTAMOBS,NAJUSTE,BB")


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
titulo   := PADC("DUPLICATAS - PA0018",74)
cDesc1   := PADC("Este programa ira emitir a Duplicata da Nota Fiscal Saida",74)
cDesc2   := ""
cDesc3   := PADC("Duplicata",74)
cNatureza:= ""
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog := "PA0018"
cPerg    := "NFSIGW"
nLastKey :=  0
lContinua:= .T.
nLin     := 0
wnrel    := "PA0018"

//+-----------------------------------------------------------+
//¦ Tamanho do Formulario de Nota Fiscal (em Linhas)          ¦
//+-----------------------------------------------------------+

nTamNf   :=32     // Apenas Informativo 

//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ¦
//+-------------------------------------------------------------------------+

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString  :="SF2"

//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,TAMANHO)

If nLastKey == 27
   Return
Endif

//+--------------------------------------------------------------+
//¦ Verifica Posicao do Formulario na Impressora                 ¦          
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

//+--------------------------------------------------------------+
//¦                                                              ¦
//¦ Inicio do Processamento da Nota Fiscal                       ¦
//¦                                                              ¦
//+--------------------------------------------------------------+

RptStatus({|| RptDetail()})

Return



Static Function RptDetail()

dbSelectArea("SF2")                // * Cabecalho da Nota Fiscal Saida
dbSetOrder(1)
dbSeek(xFilial("SF2")+mv_par01+mv_par03,.t.)
dbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
dbSetOrder(3)
dbSeek(xFilial("SD2")+mv_par01+mv_par03)


//@ 0,0 Psay AvalImp(limite)

//+-----------------------------------------------------------+
//¦ Inicializa  regua de impressao                            ¦
//+-----------------------------------------------------------+
SetRegua(Val(mv_par02)-Val(mv_par01))

dbSelectArea("SF2")
While !eof() .and. SF2->F2_DOC    <= mv_par02 .and. lContinua

   If SF2->F2_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
      DbSkip()                    // do Parametro Informado !!!
      Loop
   Endif

   If Empty(SF2->F2_DUPL)
      DbSkip()                    // do Parametro Informado !!!
      Loop
   Endif
     
   IF lAbortPrint
      @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
      lContinua := .F.
      Exit
   Endif

   nLinIni:=nLin                         // Linha Inicial da Impressao

   xTOT_FAT    :=SF2->F2_VALFAT          // Valor Total da Fatura
   xNUM_NF     :=SF2->F2_DOC             // Numero
   xSERIE      :=SF2->F2_SERIE           // Serie
   xEMISSAO    :=SF2->F2_EMISSAO         // Data de Emissao
   XCLIENTE    :=SF2->F2_CLIENTE
   xLOJA       :=SF2->F2_LOJA            // Loja do Cliente
   xNUM_DUPLIC :=SF2->F2_DUPL            // Numero da Duplicata
   xCOND_PAG   :=SF2->F2_COND            // Condicao de Pagamento

   dbSelectArea("SD2")                   // * Itens de Venda da N.F.
   dbSetOrder(3)
   dbSeek(xFilial("SD2")+xNUM_NF+xSERIE)

   xTES        :={}                         // TES
   xCF         :={}                         // Classificacao quanto natureza da Operacao
 
   While !eof() .and. SD2->D2_DOC==xNUM_NF .and. SD2->D2_SERIE==xSERIE
      If SD2->D2_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
         DbSkip()                   // do Parametro Informado !!!
         Loop
      Endif     
      AADD(xTES      ,SD2->D2_TES)
      AADD(xCF       ,SD2->D2_CF)          
      dbSelectArea("SD2")
      dbskip()
   EndDo

   dbSelectArea("SA1")                // * Cadastro de Clientes
   dbSetOrder(1)
   dbSeek(xFilial("SA1")+xCLIENTE+xLOJA)
   xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
   xNOME_CLI:=SA1->A1_NOME            // Nome
   xEND_CLI :=SA1->A1_END             // Endereco
   xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
   xCEP_CLI :=SA1->A1_CEP             // CEP
   xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
   _cEndCob := SA1->A1_ENDCOB          // Endereco de Cobranca
   _cBaiCob := SA1->A1_BAIRROC
   _cMunCob := SA1->A1_MUNC
   _cCepCob := SA1->A1_CEPC
   _cEstCob := SA1->A1_ESTC
   xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
   xMUN_CLI :=SA1->A1_MUN             // Municipio
   xEST_CLI :=SA1->A1_EST             // Estado
   xCGC_CLI :=SA1->A1_CGC             // CGC
   xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
   xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
   xTEL_CLI :=SA1->A1_TEL             // Telefone
   xFAX_CLI :=SA1->A1_FAX             // Fax

   dbSelectArea("SE1")                   // * Contas a Receber
   dbSetOrder(1)
   xPARC_DUP  :={}                       // Parcela
   xVENC_DUP  :={}                       // Vencimento
   xVALOR_DUP :={}                       // Valor
   xDUPLICATAS:=IIF(dbSeek(xFilial("SE1")+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
      
   _nValor   := 0
   _cDup     := ""
   _dVencto := CTOD("")
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

   IncRegua()                    // Termometro de Impressao

   nLin:=0
   dbSelectArea("SF2")     
   dbSkip()                      // passa para a proxima Nota Fiscal

EndDo

dbSelectArea("SF2")
Retindex("SF2")
dbSelectArea("SD2")
Retindex("SD2")
Set Device To Screen

If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()

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
@ 09, 006 PSAY xNATUREZA               // Texto da Natureza de Operacao
@ 09, 032 PSAY xCF[1] Picture"@R 9.999" // Codigo da Natureza de Operacao

//+-------------------------------------+
//¦ Impressao dos Dados do Cliente      ¦
//+-------------------------------------+

@ 11, 006 PSAY xNOME_CLI              //Nome do Cliente
//11
@ 12, 124 PSAY xEMISSAO              // Data da Emissao do Documento
If !EMPTY(xCGC_CLI)                   // Se o C.G.C. do Cli/Forn nao for Vazio
   @ 12, 95 PSAY xCGC_CLI Picture"@R 99.999.999/9999-99"
Else
   @ 12, 95 PSAY " "                // Caso seja vazio
Endif

@ 13, 006 PSAY xEND_CLI                                 // Endereco
@ 14, 006 PSAY xBAIRRO                                  // Bairro
@ 14, 77  PSAY xCEP_CLI Picture"@R 99999-999"           // CEP
@ 15, 006 PSAY xMUN_CLI                               // Municipio
@ 15, 080 PSAY xEST_CLI                               // U.F.
@ 16, 006 PSAY xTEL_CLI                               // Telefone/FAX
@ 16, 095 PSAY xINSC_CLI                              // Insc. Estadual

nLin:=19
BB:=1
nCol := 10             //  duplicatas
DUPLIC()

//+-------------------------------------+
//¦ Impressao do Endereço de entrega    ¦
//+-------------------------------------+
@ 23, 006 PSAY _cEndCob +" - CEP "+ _cCepCob +" - "+ _cBaiCob +" - " + _cMunCob + " - " +_cEstCob

_cExtenso := Extenso(xTot_Fat,.F.,)
@ 25, 012 PSAY _cExtenso         // Valor Por Extenso

@ 26, 000 PSAY chr(18)                   // Descompressao de Impressao

//SetPrc(0,0)                              // (Zera o Formulario)

Return .t.


Static Function DUPLIC()
nCol := 7
nAjuste := 0
nlin++
@ nLin, 07      PSAY xEMISSAO
@ nLin, 27      PSAY XNUM_NF
@ nLin, 58      PSAY _nValor    Picture("@E 9,999,999.99")
@ nLin, 78      PSAY _cDup
@ nLin, 102     PSAY IIF (XCLIENTE == "000008","C/ APRESENT.",_dVencto)

Return