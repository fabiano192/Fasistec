#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PA0186    ºAutor  ³Fabiano da Silva    º Data ³  26/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressão de Duplicatas                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento / Financeiro                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PA0186()

//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01             // Da Nota Fiscal                       ¦
//¦ mv_par02             // Ate a Nota Fiscal                    ¦
//¦ mv_par03             // Da Serie                             ¦
//+--------------------------------------------------------------+

CbTxt    := ""
CbCont   := ""
nOrdem   := 0
Alfa     := 0
Z        := 0
M        := 0
tamanho  := "G"
limite   := 220
titulo   := PADC("DUPLICATAS - PA0186",74)
cDesc1   := PADC("Este programa ira emitir a Duplicata da Nota Fiscal Saida",74)
cDesc2   := ""
cDesc3   := PADC("Duplicata",74)
cNatureza:= ""
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog := "PA0186"
cPerg    := "PA0186"
nLastKey :=  0
lContinua:= .T.
wnrel    := "PA0186"

nTamNf   :=32 

Pergunte(cPerg,.F.)

cString  :="SE1"

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,TAMANHO)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|| RptDetail()})

Return


Static Function RptDetail()

dbSelectArea("SE1")
dbSetOrder(1)
dbSeek(xFilial("SE1")+mv_par03+mv_par01+mv_par04,.t.)

SetRegua(Val(mv_par02)-Val(mv_par01))

While !eof() .and. SE1->E1_NUM    <= mv_par02 .and. lContinua
	
	IncRegua()

	IF lAbortPrint
		@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
		lContinua := .F.
		Exit
	Endif
	
	If SE1->E1_PREFIXO != mv_par03 .Or. SE1->E1_TIPO != "NF " .Or.;
	 	SE1->E1_PARCELA != mv_par04
//	 	SE1->E1_PARCELA < mv_par04 .Or. SE1->E1_PARCELA > mv_par05
		dbSelectArea("SE1")
		DbSkip()
		Loop
	Endif
		
	xTOT_FAT    :=SE1->E1_VALOR 
	xNUM_NF     :=SE1->E1_NUM   
	xSERIE      :=SE1->E1_PREFIXO  
	xEMISSAO    :=SE1->E1_EMISSAO  
	XCLIENTE    :=SE1->E1_CLIENTE
	xLOJA       :=SE1->E1_LOJA     
	xNUM_DUPLIC :=SE1->E1_NUM      
	
	dbSelectArea("SD2")            
	dbSetOrder(3)
	dbSeek(xFilial("SD2")+xNUM_NF+xSERIE)
	
	xTES        :={}               
	xCF         :={}               
	
	While !eof() .and. SD2->D2_DOC+SD2->D2_SERIE == xNUM_NF +xSERIE
		AADD(xTES      ,SD2->D2_TES)
		AADD(xCF       ,SD2->D2_CF)
		dbSelectArea("SD2")
		dbskip()
	EndDo
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+xCLIENTE+xLOJA)
	xCOD_CLI := SA1->A1_COD
	xNOME_CLI:= SA1->A1_NOME
	xEND_CLI := SA1->A1_END
	xBAIRRO  := SA1->A1_BAIRRO
	xCEP_CLI := SA1->A1_CEP
	xCOB_CLI := SA1->A1_ENDCOB
	_cEndCob := SA1->A1_ENDCOB
	_cBaiCob := SA1->A1_BAIRROC
	_cMunCob := SA1->A1_MUNC
	_cCepCob := SA1->A1_CEPC
	_cEstCob := SA1->A1_ESTC
	xREC_CLI := SA1->A1_ENDENT
	xMUN_CLI := SA1->A1_MUN
	xEST_CLI := SA1->A1_EST
	xCGC_CLI := SA1->A1_CGC
	xINSC_CLI:= SA1->A1_INSCR
	xTRAN_CLI:= SA1->A1_TRANSP
	xTEL_CLI := SA1->A1_TEL
	xFAX_CLI := SA1->A1_FAX
	
	_cDup    := SE1->E1_NUM     
	_cParc   := SE1->E1_PARCELA
	_dVencto := SE1->E1_VENCTO
	_nValor  := SE1->E1_VALOR
	
	dbSelectArea("SF4")
	DbSetOrder(1)
	dbSeek(xFilial("SF4")+xTES[1])
	xNATUREZA:=SF4->F4_TEXTO
	
	@ 00, 000 PSAY Chr(15)

	@ 00,05  PSay REPLICATE("-",138)
	@ 01,04  PSay "|PASY INDUSTRIA E COMERCIO DE BORRACHA E PLÁSTICO LTDA."
	@ 01,63  PSay "|                D  U  P  L  I  C  A  T  A"
	@ 01,120 PSay "|"
	@ 01,143 PSay "|"

	@ 02,04  PSay "|AV. RAIMUNDO PEREIRA DE MAGALHAES, 4100"
	@ 02,63  PSay "|                   DE VENDA MERCANTIL"
	@ 02,120 PSay "|   APOS VENCIMENTO"
	@ 02,143 PSay "|"

	@ 03,04  PSay "|CEP 05145-200 - PIRITUBA - SAO PAULO - SP"
	@ 03,63  PSay "|"
	@ 03,64  PSay Replicate("-",56)
	@ 03,120 PSay "|    COBRAR JUROS E "
	@ 03,143 PSay "|"

	@ 04,04  PSay "|FONE: (11) 3904-7055 - FAX (11)3904-6423
	@ 04,63  PSay "|C.N.P.J. (M.F.)    : 60.675.048/0001-21"
	@ 04,120 PSay "| ENCARGOS FINANCEIROS"
	@ 04,143 PSay "|"

	@ 05,04  PSay "|www.pasy.com.br  -  e-mail: pasy@pasy.com.br"
	@ 05,63  PSay "|INSCRICAO ESTADUAL : 105.128.112.114"
	@ 05,120 PSay "|"
	@ 05,143 PSay "|"

	@ 06,04  PSay "|"
	@ 06,05  PSay REPLICATE("-",138)
	@ 06,143 PSay "|"

	@ 07,04  PSay "|NATUREZA DA OPERACAO:"
	@ 07,27  PSAY xNATUREZA
	@ 07,80  PSay "C.F.O.P. :"
	@ 07,91  PSAY xCF[1] Picture"@R 9.999"
	@ 07,143 PSay "|"

	@ 08,05  PSay REPLICATE("-",138)

	@ 09,05  PSay "DESTINATARIO/REMETENTE"

	@ 10,05  PSay REPLICATE("-",138)

	@ 11,04  PSay "|NOME        :"
	@ 11,19  PSAY Alltrim(xNOME_CLI)
	@ 11,80  PSay "C.N.P.J. (M.F.)    :"
	If !EMPTY(xCGC_CLI)
		@ 11,101 PSAY Alltrim(xCGC_CLI) Picture "@R 99.999.999/9999-99"
	Else
		@ 11,101 PSAY " "
	Endif
	@ 11,120 PSay "|     PARA USO DA"
	@ 11,143 PSay "|"
	
	@ 12,04  PSay "|ENDERECO    :"
	@ 12,19  PSAY Alltrim(Substr(xEND_CLI,1,60))
	@ 12,80  PSay "INSCRICAO ESTADUAL :"
	@ 12,101 PSAY Alltrim(xINSC_CLI)
	@ 12,120 PSay "|INSTITUICAO FINANCEIRA"
	@ 12,143 PSay "|"
	
	@ 13,04  PSay "|BAIRRO/DIST.:"
	@ 13,19  PSAY Alltrim(xBAIRRO)
	@ 13,80  PSay "CEP :"
	@ 13,87  PSAY xCEP_CLI Picture"@R 99999-999"
	@ 13,120 PSay "|"
	@ 13,143 PSay "|"
	
	@ 14,04  PSay "|MUNICIPIO   :"
	@ 14,19  PSAY Alltrim(xMUN_CLI)
	@ 14,80  PSay "UF  :"
	@ 14,87  PSAY Alltrim(xEST_CLI)
	@ 14,120 PSay "|"
	@ 14,143 PSay "|"
	
	@ 15,04  PSay "|FONE/FAX    :"
	@ 15,19  PSAY Alltrim(xTEL_CLI)
	@ 15,120 PSay "|"
	@ 15,143 PSay "|"
	
	@ 16,05  PSay REPLICATE("-",138)

	@ 17,05  PSay "FATURA"
	
	@ 18,05  PSay REPLICATE("-",138)

	@ 19,04  PSay "|DATA EMISSAO        :"
	@ 19,27  PSay xEMISSAO
	@ 19,56  PSay "|NR FATURA    :"
	@ 19,75  PSay Alltrim(XNUM_NF)
	@ 19,110 PSay "|VALOR :"
	@ 19,122 PSay _nValor    Picture("@E 9,999,999.99")
	@ 19,143 PSay "|"
	
	@ 20,04  PSay "|DATA VENCIMENTO     :"
	@ 20,27  PSay _dVencto
	@ 20,56  PSay "|DUPLICATA NR :"
	@ 20,75  PSay Alltrim(_cDup+"-"+_cParc)
	@ 20,110 PSay "|"
	@ 20,143 PSay "|"

	@ 21,04  PSay "|"
	@ 21,05  PSay REPLICATE("-",138)
	@ 21,143 PSay "|"

	@ 22,04  PSay "|ENDERECO DE COBRANCA:"
	@ 22,27  PSay Alltrim(_cEndCob) +" - CEP "+ Alltrim(_cCepCob) +" - "+ Alltrim(_cBaiCob) +" - " + Alltrim(_cMunCob) + " - " +_cEstCob
	@ 22,143 PSay "|"

	@ 23,04  PSay "|"
	@ 23,05  PSay REPLICATE("-",138)
	@ 23,143 PSay "|"

	_cExtenso := Extenso(xTot_Fat,.F.,)

	@ 24,04  PSay "|VALOR POR EXTENSO   :"
	@ 24,27  PSay Alltrim(_cExtenso)
	@ 24,143 PSay "|"
             
	@ 25,05  PSay REPLICATE("-",138)

	@ 26,41  PSay REPLICATE("-",102)

	@ 27,40  PSay "|Reconhecemos a exatidao desta duplicata de venda mercantil na importancia acima que pagaremos a"
	@ 27,143 PSay "|"

	@ 28,05  PSay "________________________________"
	@ 28,40  PSay "|PASY INDUSTRIA E COMERCIO DE BORRACHA E PLASTICO LTDA, ou a sua ordem na praca e vencimento indicado."
	@ 28,143 PSay "|"

	@ 29,05  PSay "     Assinatura do Emitente"
	@ 29,41  PSay REPLICATE("-",102)

	@ 29,00 PSAY chr(18)
	SetPrc(0,0)                              // (Zera o Formulario)
	
	dbSelectArea("SE1")
	dbSkip()
EndDo

Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return