#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PA0018A   �Autor  �Alexandro da Silva  � Data �  21/07/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Impress�o de Duplicatas                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Faturamento / Financeiro                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PA0018A()

//+--------------------------------------------------------------+
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Da Nota Fiscal                       �
//� mv_par02             // Ate a Nota Fiscal                    �
//� mv_par03             // Da Serie                             �
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
nomeprog := "PA0018A"
cPerg    := "PA0018"
nLastKey :=  0
lContinua:= .T.
nLin     := 0
wnrel    := "PA0018A"

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
dbSeek(xFilial("SE1")+mv_par03+mv_par01,.t.)

SetRegua(Val(mv_par02)-Val(mv_par01))

While !eof() .and. SE1->E1_NUM    <= mv_par02 .and. lContinua
	
	IncRegua()

	IF lAbortPrint
		@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
		lContinua := .F.
		Exit
	Endif
	
	If SE1->E1_PREFIXO != mv_par03 .Or. SE1->E1_TIPO != "NF "
		dbSelectArea("SE1")
		DbSkip()
		Loop
	Endif
		
	nLinIni:=nLin        
	
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
//	_dVencto := SE1->E1_VENCTO
	_dVencto := SE1->E1_VENCREA
	_nValor  := SE1->E1_VALOR
	
	dbSelectArea("SF4")
	DbSetOrder(1)
	dbSeek(xFilial("SF4")+xTES[1])
	xNATUREZA:=SF4->F4_TEXTO
	
	@ 02, 000 PSAY Chr(15)
	@ 09, 006 PSAY xNATUREZA
	@ 09, 032 PSAY xCF[1] Picture"@R 9.999"
	
	@ 11, 006 PSAY xNOME_CLI
	@ 12, 124 PSAY xEMISSAO
	If !EMPTY(xCGC_CLI)
		@ 12, 95 PSAY xCGC_CLI Picture"@R 99.999.999/9999-99"
	Else
		@ 12, 95 PSAY " "
	Endif
	
	@ 13, 006 PSAY xEND_CLI
	@ 14, 006 PSAY xBAIRRO
	@ 14, 77  PSAY xCEP_CLI Picture"@R 99999-999"
	@ 15, 006 PSAY xMUN_CLI
	@ 15, 080 PSAY xEST_CLI
	@ 16, 006 PSAY xTEL_CLI
	@ 16, 095 PSAY xINSC_CLI
	
	nLin    := 19
	BB      := 1
	nCol    := 7
	nAjuste := 0
	
	nlin++
	@ nLin, 07      PSAY xEMISSAO
	@ nLin, 27      PSAY XNUM_NF
	@ nLin, 58      PSAY _nValor    Picture("@E 9,999,999.99")
	@ nLin, 78      PSAY _cDup+"-"+_cParc
//	@ nLin, 102     PSAY IIF (XCLIENTE == "000008","C/ APRESENT.",_dVencto)
	@ nLin, 102     PSAY _dVencto
		
	@ 23, 006 PSAY _cEndCob +" - CEP "+ _cCepCob +" - "+ _cBaiCob +" - " + _cMunCob + " - " +_cEstCob
	
	_cExtenso := Extenso(xTot_Fat,.F.,)
	@ 25, 012 PSAY _cExtenso
	
	@ 26, 000 PSAY chr(18)
	
	nLin:=0
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