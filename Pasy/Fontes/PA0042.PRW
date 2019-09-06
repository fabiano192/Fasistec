#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0042   ³ Autor ³ Alexandro da Silva    ³ Data ³ 18.10.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Pedidos nao entregues                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ-±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0042()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

LOCAL CbTxt
LOCAL titulo := "Relacao de Pedidos nao entregues"
LOCAL cDesc1 := "Este programa ira emitir a relacao dos Pedidos Pendentes,"
LOCAL cDesc2 := "imprimindo o numero do Pedido, Cliente, Data da Entrega, "
LOCAL cDesc3 := "Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso."
LOCAL CbCont,cabec1,cabec2,wnrel
LOCAL tamanho:= " "
LOCAL limite := 132
LOCAL cString:= "SC6"

PRIVATE aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
PRIVATE nomeprog := "PA0042"
PRIVATE aLinha   := { },nLastKey := 0
PRIVATE cPerg    := "PA0009"
PRIVATE cNumPed  := cNumCli := "", dData:=CtoD("  /  /  ")
Private _nQtAcab := _nQtOP := _nQtPul := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte("PA0009",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Do Pedido                             ³
//³ mv_par02            // Ate o Pedido                          ³
//³ mv_par03            // Do Produto                            ³
//³ mv_par04            // Ate o Produto                         ³
//³ mv_par05            // Do Cliente                            ³
//³ mv_par06            // Ate o cliente                         ³
//  mv_par07            // Loja     De                           ³
//  mv_par08            // Loja     Ate                          ³
//³ mv_par09            // Da entrega de entrega                 ³
//³ mv_par10            // Ate a data de entrega                 ³
//³ mv_par11            // Em Aberto , Todos                     ³
//³ mv_par12            // C/Fatur.,S/Fatur.,Todos               ³
//³ mv_par13            // Mascara                               ³
//³ mv_par14            // Aglutina itens grade                  ³
//³ mv_par15            // Considera Residuos (Sim/Nao)          ³
//³ mv_par16            // Lista Residuos                        ³
//³ mv_par17            // Grupo De                              ³
//³ mv_par18            // Grupo Ate                             ³
//³ mv_par19            // SubGrupo De                           ³
//³ mv_par20            // SubGrupo Ate                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="PA0042"
aOrd :={"Por Pedido","Por Produto","Por Cliente","Por Dt.Entrega"}

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

If nLastKey==27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| ImpRel(@lEnd,wnRel,cString)},Titulo)

Return

Static Function ImpRel(lEnd,WnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL CbTxt
LOCAL titulo :=OemToAnsi("Relacao de Pedidos nao entregues")
LOCAL cDesc1 :=OemToAnsi("Este programa ira emitir a relacao dos Pedidos Pendentes,")
LOCAL cDesc2 :=OemToAnsi("imprimindo o numero do Pedido, Cliente, Data da Entrega, ")
LOCAL cDesc3 :=OemToAnsi("Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso.")
LOCAL CbCont,cabec1,cabec2
LOCAL tamanho:=" "
LOCAL limite :=132
Private nOrdem,nTotVen:=0,nTotEnt:=0,nTotSal:=0
Private lContinua := .T.
Private nFirst, nSaldo:=nCont:=0, lImpTot := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1

nTipo:=IIF(aReturn[4]==1,15,18)

nOrdem := aReturn[8]

If nOrdem == 3 .Or. nOrdem == 4
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNomArq := CriaTrab("",.F.)
EndIf

dbSelectArea("SC6")

IF nOrdem = 1
	dbSetOrder(1)
	dbSeek(xFilial("SC6")+mv_par01,.T.)
	cCond1 := "SC6->C6_NUM >= mv_par01 .And. SC6->C6_NUM <= mv_par02"
	cCond2 := "SC6->C6_NUM = cNum"
	titulo := titulo +" - Por Pedido"
	cabec1 := "NUMERO DATA     CODIGO IT PRODUTO         DATA         QUANT.     QUANT.     QUANT.     QUANT.     QUANT.     QUANT.     QUANT."
	cabec2 := "PEDIDO EMISSAO  CLIENT    PASY            ENTREGA      PEDIDA   ENTREGUE   PENDENTE   LIBERADA     PULMAO ACABAMENTO       C.Q."
	
//	cabec1 := "NUMERO DATA     CODIGO IT PRODUTO         DATA         QUANT.     QUANT.     QUANT.     QUANT.     QUANT.     QUANT.     QUANT."
//	cabec2 := "PEDIDO EMISSAO  CLIENT    PASY            ENTREGA      PEDIDA   ENTREGUE   PENDENTE ACABAMENTO       C.Q.    REJEITO  EXPEDICAO"
/*
NUMERO DATA     CODIGO IT PRODUTO         DATA         QUANT.     QUANT.     QUANT.     QUANT.     QUANT.     QUANT.     QUANT.
999999 99999999 999999 99 999999999999999 99999999 9999999999 9999999999 9999999999 9999999999 9999999999 9999999999 9999999999
0      7        16     23 26              42       51         62         73         84         95         106        117
	
PEDIDO EMISSAO  CLIENT    PASY            ENTREGA      PEDIDA   ENTREGUE   PENDENTE ACABAMENTO       C.Q.    REJEITO  EXPEDICAO
999999 99999999 999999 99 999999999999999 99999999 9999999999 9999999999 9999999999 9999999999 9999999999 9999999999 9999999999
0      7        16     23 26              42       51         62         73         84         95         106        117
*/
	
ElseIF nOrdem = 2
	dbSetOrder(2)
	dbSeek(xFilial("SC6")+mv_par03,.T.)
	cCond1 := "SC6->C6_PRODUTO >= mv_par03 .And. SC6->C6_PRODUTO <= mv_par04"
	cCond2 := "SC6->C6_PRODUTO = cProduto"
	titulo := titulo + " - Por Produto"
	cabec1 := "PRODUTO         NUMERO IT DATA     DATA     CODIGO     QUANT.     QUANT.     QUANT.     QUANT.    QUANT.      QUANT.     QUANT."
	cabec2 := "PASY            PEDIDO    EMISSAO  ENTREGA  CLIENT     PEDIDA   ENTREGUE   PENDENTE   LIBERADA    PULMAO  ACABAMENTO       C.Q."

//	cabec1 := "PRODUTO         NUMERO IT DATA     DATA     CODIGO     QUANT.     QUANT.     QUANT.     QUANT.    QUANT.      QUANT.     QUANT."
//	cabec2 := "PASY            PEDIDO    EMISSAO  ENTREGA  CLIENT     PEDIDA   ENTREGUE   PENDENTE ACABAMENTO      C.Q.     REJEITO  EXPEDICAO"
/*
PRODUTO         NUMERO IT DATA     DATA     CODIGO     QUANT.     QUANT.     QUANT.     QUANT.    QUANT.      QUANT.     QUANT.
999999999999999 999999 99 99999999 99999999 999999 9999999999 9999999999 9999999999 9999999999 9999999999 9999999999 9999999999
0               16     23 26       35       44     51         62         73         84         95         106        117
PASY            PEDIDO    EMISSAO  ENTREGA  CLIENT PEDIDA       ENTREGUE   PENDENTE ACABAMENTO       C.Q.    REJEITO  EXPEDICAO
999999999999999 999999 99 99999999 99999999 999999 9999999999 9999999999 9999999999 9999999999 9999999999 9999999999 9999999999
0               16     23 26       35       44     51         62         73         84         95         106        117
*/
ElseIF nOrdem = 3
	
	IndRegua("SC6",cNomArq,"C6_FILIAL+C6_CLI+C6_LOJA+C6_NUM+C6_ITEM",,,"Selecionando Registros...")
	dbSeek(xFilial("SC6")+mv_par05,.T.)
	
	cCond1 := "SC6->C6_CLI >= mv_par05 .And. SC6->C6_CLI <= mv_par06 .And. SC6->C6_LOJA >= MV_PAR07 .AND. SC6->C6_LOJA <= MV_PAR08"
	cCond2 := "SC6->C6_CLI+SC6->C6_LOJA = cCli"
	
	titulo := titulo + " - Por Cliente"
	cabec1 := "CODIGO NUMERO IT  DATA     PRODUTO         DATA         QUANT.    QUANT.     QUANT.     QUANT.     QUANT.     QUANT.     QUANT."
	cabec2 := "CLIENT PEDIDO     EMISSAO  PASY            ENTREGA     PEDIDA   ENTREGUE   PENDENTE   LIBERADA     PULMAO ACABAMENTO       C.Q."

//	cabec1 := "CODIGO NUMERO IT  DATA     PRODUTO         DATA         QUANT.    QUANT.     QUANT.     QUANT.     QUANT.     QUANT.     QUANT."
//	cabec2 := "CLIENT PEDIDO     EMISSAO  PASY            ENTREGA     PEDIDA   ENTREGUE   PENDENTE ACABAMENTO       C.Q.    REJEITO  EXPEDICAO"
/*                                                      09
CODIGO NUMERO IT  DATA     PRODUTO         DATA         QUANT.    QUANT.     QUANT.     QUANT.     QUANT.     QUANT.     QUANT.
999999 999999 999 99999999 999999999999999 99999999 999999999 9999999999 9999999999 9999999999 9999999999 9999999999 9999999999
0      7      14  18       27              43       52        62         73         84         95         106        117
CLIENT PEDIDO     EMISSAO  PASY            ENTREGA     PEDIDA   ENTREGUE   PENDENTE ACABAMENTO       C.Q.    REJEITO  EXPEDICAO
999999 999999 999 99999999 999999999999999 99999999 999999999 9999999999 9999999999 9999999999 9999999999 9999999999 9999999999
0      7          18       27              43       52        62         73         84         95         106        117     
*/
Else
	IndRegua("SC6",cNomArq,"C6_FILIAL+DTOS(C6_ENTREG)+C6_NUM+C6_ITEM",,,"Selecionando Registros...")
	
	dbSeek(xFilial("SC6")+DTOS(mv_par09),.T.)
	
	cCond1 := "Dtos(SC6->C6_ENTREG) >= Dtos(mv_par09) .And. Dtos(SC6->C6_ENTREG) <= Dtos(mv_par10)"
	cCond2 := "SC6->C6_ENTREG = dEntreg"
	titulo := titulo + " - Por Data de Entrega"
	cabec1 := "DATA     NUMERO  DATA    CODIGO IT PRODUTO             QUANT.     QUANT.     QUANT.     QUANT.     QUANT.     QUANT.     QUANT."
	cabec2 := "ENTREGA  PEDIDO EMISSAO  CLIENT    PASY                PEDIDA   ENTREGUE   PENDENTE   LIBERADA     PULMAO ACABAMENTO       C.Q."

//	cabec1 := "DATA     NUMERO  DATA    CODIGO IT PRODUTO             QUANT.     QUANT.     QUANT.     QUANT.     QUANT.     QUANT.     QUANT."
//	cabec2 := "ENTREGA  PEDIDO EMISSAO  CLIENT    PASY                PEDIDA   ENTREGUE   PENDENTE ACABAMENTO      C.Q.     REJEITO  EXPEDICAO"
/*
DATA     NUMERO  DATA    CODIGO IT PRODUTO             QUANT.     QUANT.     QUANT.     QUANT.     QUANT.     QUANT.     QUANT.
99999999 999999 99999999 999999 99 999999999999999 9999999999 9999999999 9999999999 9999999999 9999999999 9999999999 9999999999
0        9      16       25     32 35              51         62         73         84         95         106        117
ENTREGA  PEDIDO EMISSAO  CLIENT    PASY                PEDIDA   ENTREGUE   PENDENTE ACABAMENTO      C.Q.     REJEITO  EXPEDICAO
99999999 999999 99999999 999999 99 999999999999999 9999999999 9999999999 9999999999 9999999999 9999999999 9999999999 9999999999
0        9      16       25     32 35              51         62         73         84         95         106        117
*/
EndIF

SetRegua(RecCount())		// Total de Elementos da regua

While !Eof() .And. &cCond1 .And. lContinua .And. C6_FILIAL == xFilial("SC6")
	
	IF lEnd
		@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IncRegua()
	
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	
	nFirst := 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica campo para quebra                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF nOrdem == 1
		cNum     := SC6->C6_NUM
	ElseIF nOrdem = 2
		cProduto := SC6->C6_PRODUTO
	ElseIF nOrdem = 3
		cCli     := SC6->C6_CLI+SC6->C6_LOJA
	Else
		dEntreg  := SC6->C6_ENTREG
	EndIF
	
	While !Eof() .And. xFilial("SC6") = SC6->C6_FILIAL .And. &cCond2
		
		IncRegua()
		
		IF lEnd
			@Prow()+1,001 Psay "CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se esta dentro dos parametros                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		IF SC6->C6_NUM     < mv_par01 .OR. SC6->C6_NUM     > mv_par02 .OR. ;
			SC6->C6_PRODUTO < mv_par03 .OR. SC6->C6_PRODUTO > mv_par04 .OR. ;
			SC6->C6_CLI     < mv_par05 .OR. SC6->C6_CLI     > mv_par06 .OR. ;
			SC6->C6_LOJA    < mv_par07 .OR. SC6->C6_LOJA    > mv_par08 .OR. ;
			Dtos(SC6->C6_ENTREG)  < Dtos(mv_par09) .OR. Dtos(SC6->C6_ENTREG)  > Dtos(mv_par10)
			dbSkip()
			LOOP
		Endif
/*		
		If MV_PAR21 == 1
			_cPed := "N"
		ElseIf MV_PAR21 == 2
			_cPed := "A"
		ElseIf MV_PAR21 == 3
			_cPed := "Z"
		ElseIf MV_PAR21 == 4
			_cPed := "D"			
        Else
			_cPed := " /3/D/N/A/Z"
		Endif
*/
		_cPed := ""
		For Ax:= 1 To Len(MV_PAR21)
			If Substr(MV_PAR21,AX,1) != "*"
			   _cPed += Substr(MV_PAR21,AX,1)+ "/"
		    Endif
		Next AX         
		
		If !SC6->C6_PEDAMOS $ _cPed
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		                                 
		IF SC6->C6_QTDENT >= SC6->C6_QTDVEN .And. mv_par11 == 1
			dbSkip()
			Loop
		EndIF
		
		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek (xFilial("SF4")+SC6->C6_TES)
		dbSelectArea("SC6")
		If ( SF4->F4_DUPLIC == "S" .And. mv_par12 == 2 ) .Or. ( SF4->F4_DUPLIC != "S" .And. mv_par12 == 1 )
			dbSkip()
			Loop
		Endif
		
		lRet:=ValidMasc(SC6->C6_PRODUTO,MV_PAR13)
		If !lRet
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek( xFilial("SC6")+SC6->C6_NUM )
		
		dbSelectArea("SC6")
		If ( SC6->C6_QTDENT >= SC6->C6_QTDVEN .And. mv_par11 == 1 ) .Or. At(SC5->C5_TIPO,"DB") != 0
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea("SC6")
		IF Alltrim(SC6->C6_BLQ) == "R" .and. mv_par16 == 2				// Se Foi Eliminado Residuos
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek( xFilial("SB1")+SC6->C6_PRODUTO )
			If SB1->B1_GRUPO < MV_PAR17  .Or. SB1->B1_GRUPO > MV_PAR18 .Or.;
				SB1->B1_SUBGR < MV_PAR19  .Or. SB1->B1_SUBGR > MV_PAR20
				dbSelectArea("SC6")
				dbSkip()
				Loop
			EndIf
		Endif
		
		dbSelectArea("SC6")
		IF Alltrim(SC6->C6_BLQ) == "R" .and. mv_par15 == 2				// Se Foi Eliminado Residuos
			nSaldo := 0
		Else
			nSaldo  := SC6->C6_QTDVEN-SC6->C6_QTDENT
		Endif
		nTotSal += nSaldo
		nTotVen += C6_QTDVEN
		nTotEnt += C6_QTDENT
		
		If nTotVen > SC6->C6_QTDVEN .Or. nTotEnt > SC6->C6_QTDENT
			lImpTot := .T.
		Else
			lImpTot := .F.
		EndIf
		
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			nFirst := 0
		EndIF
		
		IF nFirst = 0 .And. nOrdem != 4
			PrintCab(nOrdem)
			nFirst := 1
		ElseIf nOrdem == 4
			PrintCab(nOrdem)
		EndIf
		
		PrintLinha(nOrdem,nSaldo)
		nCont++
		
		li++
		
		dbSelectArea("SC6")
		dbSkip()
	EndDo
	
	If nSaldo > 0 .Or. lImpTot
		If nOrdem == 2 .And. nCont > 1
			@Li,000 Psay "TOTAL ---->"
			@Li,051 Psay nTotVen PICTURE Tm(nTotVen,10)
			@Li,062 Psay nTotEnt PICTURE Tm(nTotEnt,10)
			@Li,073 Psay nTotSal PICTURE tm(nTotSal,10)
			Li++
		Endif
		If nTotVen > 0 .And. nOrdem != 1
			@li,  0 Psay Replicate("-",limite)
			li++
		EndIf
	Else
		If nTotVen > 0 .And. (nOrdem == 2 .Or. nOrdem == 3)
			@li,  0 Psay Replicate("-",limite)
			li++
		EndIf
	Endif
	
	nTotVen := 0
	nTotEnt := 0
	nTotSal := 0
	nCont := 0
	dbSelectArea("SC6")
EndDo

If li != 80
	Roda(cbcont,cbtxt)
Endif

dbSelectArea("SC6")
RetIndex("SC6")

If nOrdem == 3 .Or. nOrdem == 4
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga indice de trabalho e devolve a ordem original do arq.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNomArq += OrdBagExt()
	If File(cNomArq)
		FERASE(cNomArq)
	Endif
EndIf

Set Filter To
set devi to screen
If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PrintCab  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao da linha unica, dependendo da ordem escolhida     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function PrintCab(nOrdem)

li++
dbSelectArea("SC5")
dbSetOrder(1)
dbSeek( xFilial("SC5")+SC6->C6_NUM )

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek( xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA )

dbSelectArea("SC6")
IF nOrdem = 1
	@li,  0 Psay  C6_NUM
	@li,  7 Psay  SC5->C5_EMISSAO
	@li, 16 Psay  C6_CLI
//  @li, 23 Psay  Subs(SA1->A1_NOME, 1,10)
ElseIF nOrdem = 2
	@li,  0 Psay  C6_PRODUTO
	dbSelectArea("SC6")
ElseIF nOrdem = 3
	@li,  0 Psay C6_CLI
//	@li, 10 Psay Subs(SA1->A1_NOME, 1,10)
Else
	If cNumPed+cNumCli+DtoS(dData) != C6_NUM+C6_CLI+C6_LOJA+DtoS(C6_ENTREG)
		@li,  0 Psay C6_ENTREG
		@li, 09 Psay C6_NUM
		@li, 16 Psay SC5->C5_EMISSAO
		@li, 25 Psay C6_CLI
//      @li, 34 Psay Subs(SA1->A1_NOME, 1,10)
		cNumPed := C6_NUM
		cNumCli := C6_CLI+C6_LOJA
	Else
		li--
	EndIf
	dData := C6_ENTREG
EndIF

Return .t.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PrintLinha³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao da linha de detalhe, dependendo da ordem escolhida³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function PrintLinha(nOrdem,nSaldo)

LOCAL cAliasAnt:=Alias()

dbSelectArea("SC5")
dbSetOrder(1)
dbSeek( xFilial("SC5")+SC6->C6_NUM )
dbSelectArea(cAliasAnt)

IF nOrdem = 1
	@li, 23 Psay C6_ITEM
	@li, 26 Psay C6_PRODUTO
	@li, 42 Psay C6_ENTREG 	//PICTURE "@D"
	@li, 51 Psay C6_QTDVEN 	PICTURE TM(C6_QTDVEN,10)
	@li, 62 Psay C6_QTDENT 	PICTURE TM(C6_QTDENT,10)
	@li, 73 Psay nSaldo  	PICTURE TM(nSaldo,10)
ElseIF nOrdem = 2
	@li, 16 Psay C6_NUM
	@li, 23 Psay C6_ITEM
	@li, 26 Psay SC5->C5_EMISSAO
	@li, 35 Psay C6_ENTREG
	@li, 44 Psay C6_CLI
	@li, 51 Psay C6_QTDVEN 	PICTURE TM(C6_QTDVEN,10)
	@li, 62 Psay C6_QTDENT 	PICTURE TM(C6_QTDENT,09)
	@li, 73 Psay nSaldo	    PICTURE TM(nSaldo,10)	
ElseIF nOrdem = 3
	@li, 07 Psay C6_NUM
	@li, 14 Psay C6_ITEM
	@li, 18 Psay SC5->C5_EMISSAO
	@li, 27 Psay C6_PRODUTO
	@li, 43 Psay C6_ENTREG PICTURE "@D"
	@li, 52 Psay C6_QTDVEN PICTURE TM(C6_QTDVEN,09)
	@li, 62 Psay C6_QTDENT PICTURE TM(C6_QTDENT,10)
	@li, 73 Psay nSaldo    PICTURE TM(nSaldo,10)
Else
	@li, 32 Psay C6_ITEM
	@li, 35 Psay C6_PRODUTO
	@li, 51 Psay C6_QTDVEN	PICTURE TM(C6_QTDVEN,10)
	@li, 62 Psay C6_QTDENT	PICTURE TM(C6_QTDENT,10)
	@li, 73 Psay nSaldo	    PICTURE TM(nSaldo,10)
EndIF

//@li, 084 Psay _nQtAcab    PICTURE TM(SB2->B2_QATU,10)
//@li, 095 Psay _nQTCQ    PICTURE TM(SB2->B2_QATU,10)

_aAliSB1 := SB1->(GetArea())

_nQtAcab := _nQtPulm := 0

VerEstrut()

RestArea(_aAliSB1)

@li, 84  Psay _nQtOP      PICTURE TM(SB2->B2_QATU,10)

@li, 95  Psay _nQtPulm    PICTURE TM(SB2->B2_QATU,10)

@li, 106 Psay _nQtAcab    PICTURE TM(SB2->B2_QATU,10)

_nQtOP := 0
_nQtCq := 0
dbSelectArea("SB2")
dbSetOrder(1)
If dbSeek(xFilial("SB2")+SB1->B1_COD+"98")
    _nQtCQ := SB2->B2_QATU
Endif
    
@li, 117 Psay _nQTCQ    PICTURE TM(SB2->B2_QATU,10)

/*
_nQtSuc := 0
dbSelectArea("SB2")
dbSetOrder(1)
If dbSeek(xFilial("SB2")+SB1->B1_COD+"80")
    _nQtSuc := SB2->B2_QATU
Endif

@li, 106 Psay _nQtSuc   PICTURE TM(SB2->B2_QATU,10)

_nQtExp := 0
dbSelectArea("SB2")
dbSetOrder(1)
If dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD)
    _nQtExp := SB2->B2_QATU
Endif
    
@li, 117 Psay _nQtExp    PICTURE TM(SB2->B2_QATU,10)
  */

Return .T.


Static Function VerEstrut()

dbSelectArea("SG1")
dbSetOrder(1)
If dbSeek(xFilial("SG1")+SC6->C6_PRODUTO)
	
	_cProd   := SG1->G1_COD
	nNivel   := 2
	
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+_cProd)
	
	NECESC6(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
	
Endif

Return


Static Function NECESC6(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev)

Local _nReg := 0
Local _nRegTrb := 0
dbSelectArea("SG1")
dbSetOrder(1)
While !Eof() .And. SG1->G1_FILIAL + SG1->G1_COD == xFilial("SG1") + _cProd
	
	_nReg := Recno()
	
	nQuantItem := ExplEstr(_nQtPai,,_cOpc,_cRev)
	dbSelectArea("SG1")
	dbSetOrder(1)
	
	If nQuantItem > 0
		
		dbSelectArea("SB1")
		aAreaSB1:=GetArea()
		dbSeek(xFilial("SB1")+SG1->G1_COMP)
		
		_nRegTRb := Recno()
		
		If SB1->B1_LOCPAD $ "20" //Acabamento
			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD)
                _nQtAcab += SB2->B2_QATU
			Endif                
		ElseIf SB1->B1_LOCPAD $ "15" .and. SB1->B1_GRUPO = "PIPF"//Vulcanização (Preparação)
			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD)
                _nQtPulm += SB2->B2_QATU
			Endif
			
			_cQuery  := " SELECT C2_PRODUTO, SUM(C2_QUANT - C2_QUJE) AS QUANT FROM SC2010 C2 WHERE C2.D_E_L_E_T_ = '' AND C2_LOCAL = '15' "
			_cQuery  += " AND C2_QUANT > C2_QUJE AND C2_PRODUTO = '"+SB1->B1_COD+"' AND C2_TPOP = 'F' "
			_cQuery  += " GROUP BY C2_PRODUTO "
            
			TCQUERY _cQuery NEW ALIAS "ZC2"

			TCSetField("ZC2","C2_QUANT","N",12,4)
			TCSetField("ZC2","C2_QUJE","N",12,4)
			
			ZC2->(dbGotop())

			_nQtOP := 0
        
			While ZC2->(!Eof())
	
				_nQtOP := ZC2->QUANT

				ZC2->(dbSkip())			
			EndDo
			
			ZC2->(dbCloseArea())	
		Endif
				
		RestArea(aAreaSB1)
		
		dbSelectArea("SG1")
		dbSetOrder(1)
		dbSeek(xFilial("SG1")+SG1->G1_COMP)
		IF Found()
			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+SG1->G1_COD)
			
			NECESC6(SG1->G1_COD,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
		EndIf
		
		dbSelectArea("SG1")
		dbGoto(_nReg)
		
		dbSelectArea("SG1")
	Endif
	dbSkip()
EndDo

Return