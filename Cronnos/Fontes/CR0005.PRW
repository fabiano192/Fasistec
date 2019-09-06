#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CR0005   ³ Autor ³ Alexandro da Silva    ³ Data ³ 22.01.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Pedidos nao entregues                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ-±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CR0005()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

LOCAL CbTxt
LOCAL titulo := "Relacao de Pedidos nao entregues"
LOCAL cDesc1 := "Este programa ira emitir a relacao dos Pedidos Pendentes,"
LOCAL cDesc2 := "imprimindo o numero do Pedido, Cliente, Data da Entrega, "
LOCAL cDesc3 := "Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso."
LOCAL CbCont,cabec1,cabec2,wnrel
LOCAL tamanho:= "M"
LOCAL limite := 132
LOCAL cString:= "SC6"

PRIVATE aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
PRIVATE nomeprog := "CR0005"
PRIVATE aLinha   := { },nLastKey := 0
PRIVATE cPerg    := "CR0005"
PRIVATE cNumPed  := cNumCli := "", dData:=CtoD("  /  /  ")
PRIVATE cMascara := GetMv("MV_MASCGRD")
PRIVATE nTamRef  := Val(Substr(cMascara,1,2))

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

pergunte("CR0005",.F.)
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
wnrel:="CR0005"
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
LOCAL nOrdem,nTotVen:=0,nTotEnt:=0,nTotSal:=0
LOCAL lContinua := .T.
LOCAL nFirst, nSaldo:=nCont:=0, lImpTot := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1

nTipo:=IIF(aReturn[4]==1,15,18)

nOrdem := aReturn[8]

aStru := {}
AADD(aStru,{"PRODUTO"   , "C" , 15, 0 })
AADD(aStru,{"DESCRIC"   , "C" , 30, 0 })

cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "PRODUTO"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

dbSelectArea("SC6")

If nOrdem == 3 .Or. nOrdem == 4
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNomArq := CriaTrab("",.F.)
EndIf


IF nOrdem = 1
	dbSetOrder(1)
	dbSeek(xFilial()+mv_par01,.T.)
	cCond1 := "SC6->C6_NUM >= mv_par01 .And. SC6->C6_NUM <= mv_par02"
	cCond2 := "SC6->C6_NUM = cNum"
	titulo := titulo +" - Por Pedido"
	cabec1 := "NUMERO DATA     CODIGO LJ NOME    IT PRODUTO         PRODUTO         TIPO DE              DATA     QUANT.     QUANT.     QUANT."
	cabec2 := "PEDIDO EMISSAO  CLIENT    CLIENTE    PASY            CLIENTE         PEDIDO               ENTREGA  PEDIDA     ENTREGUE   PENDENTE"
	
	/*
	NUMERO DATA     CODIGO LJ NOME    IT PRODUTO         PRODUTO         TIPO DE              DATA     QUANT.     QUANT.     QUANT.
	9999999999999999999999 99 9999999 99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
	0      7        16     23 26      34 37              53              69                   90       99         110        121       132
	
	PEDIDO EMISSAO  CLIENT    CLIENTE    PASY            CLIENTE         PEDIDO               ENTREGA  PEDIDA     ENTREGUE   PENDENTE
	999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
	0      7        16        26         37              53              69                   90       99         110        121       132                     132
	*/
	
ElseIF nOrdem = 2
	dbSetOrder(2)
	dbSeek(xFilial()+mv_par03,.T.)
	cCond1 := "SC6->C6_PRODUTO >= mv_par03 .And. SC6->C6_PRODUTO <= mv_par04"
	cCond2 := "SC6->C6_PRODUTO = cProduto"
	titulo := titulo + " - Por Produto"
	cabec1 := "PRODUTO         PRODUTO         DESCRICAO            NUMERO  IT DATA     DATA     CODIGO LJ NOME    QUANTIDADE QUANTIDADE QUANTIDADE"
	cabec2 := "PASY            CLIENTE                              PEDIDO     EMISSAO  ENTREGA  CLIENT    CLIENTE PEDIDA     ENTREGUE   PENDENTE"
	/*
	PRODUTO         PRODUTO         TIPO DE              NUMERO  IT DATA     DATA     CODIGO LJ NOME    QUANTIDADE QUANTIDADE QUANTIDADE
	9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999 99 9999999 99999999999999999999999999999999
	0               16              32                   53      61 64       73       82     89 92      100        111        122
	PASY            CLIENTE         PEDIDO               PEDIDO     EMISSAO  ENTREGA  CLIENT    CLIENTE PEDIDA     ENTREGUE   PENDENTE
	9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999 99 9999999 99999999999999999999999999999999
	0               16              32                   53      61 64       73       82     89         100        111        122
	*/
ElseIF nOrdem = 3
	
	IndRegua("SC6",cNomArq,"C6_FILIAL+C6_CLI+C6_LOJA+C6_NUM+C6_ITEM",,,"Selecionando Registros...")
	dbSeek(xFilial()+mv_par05,.T.)
	
//	cCond1 := "SC6->C6_CLI >= mv_par05 .And. SC6->C6_CLI <= mv_par06 .And. SC6->C6_LOJA >= MV_PAR07 .AND. SC6->C6_LOJA <= MV_PAR08"
	cCond1 := "SC6->C6_CLI >= mv_par05 .And. SC6->C6_CLI <= mv_par06 "
	cCond2 := "SC6->C6_CLI+SC6->C6_LOJA = cCli"
	
	titulo := titulo + " - Por Cliente"
	cabec1 := "CODIGO LJ NOME DO   NUMERO IT  DATA     PRODUTO         PRODUTO         TIPO DE              DATA     QUANT.    QUANT.    QUANT.   "
	cabec2 := "CLIENTE   CLIENTE   PEDIDO     EMISSAO  PASY            CLIENTE         PEDIDO               ENTREGA  PEDIDA    ENTREGUE  PENDENTE "
	/*
	CODIGO LJ NOME DO   NUMERO IT  DATA     PRODUTO         PRODUTO         TIPO DE              DATA     QUANT.    QUANT.    QUANT.
	999999 99 99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
	0      7  10        20     27  31       40              56              72                   93       102       112       122
	CLIENTE   CLIENTE   PEDIDO     EMISSAO  PASY            CLIENTE         PEDIDO               ENTREGA  PEDIDA    ENTREGUE  PENDENTE"
	999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
	0         10        20         31       40              56              72                   93       102       112       122
	
	*/
Else
//    IndRegua("SC6",cNomArq,"C6_FILIAL+DTOS(C6_ENTREG)+C6_NUM+C6_ITEM",,,"Selecionando Registros...")
    IndRegua("SC6",cNomArq,"C6_FILIAL+DTOS(C6_ENTREG)+C6_PRODUTO+C6_NUM+C6_ITEM",,,"Selecionando Registros...")
	
	dbSeek(xFilial()+DTOS(mv_par09),.T.)
	
	cCond1 := "Dtos(SC6->C6_ENTREG) >= Dtos(mv_par09) .And. Dtos(SC6->C6_ENTREG) <= Dtos(mv_par10)"
	cCond2 := "SC6->C6_ENTREG = dEntreg"
	titulo := titulo + " - Por Data de Entrega"
	cabec1 := "  DATA   NUMERO  DATA    CODIGO LJ NOME DO  IT PRODUTO         PRODUTO         TIPO DE              QUANTIDADE QUANTIDADE QUANTIDADE"
	cabec2 := "ENTREGA  PEDIDO EMISSAO  CLIENTE  CLIENTE      PASY            CLIENTE         PEDIDO                   PEDIDA   ENTREGUE   PENDENTE"
	/*
  DATA   NUMERO  DATA    CODIGO LJ NOME DO  IT PRODUTO         PRODUTO         TIPO DE              QUANTIDADE QUANTIDADE QUANTIDADE
9999999999999999999999999999999999 9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
0        9       17      25     32 35       44 47              63              79                   100        111        122
ENTREGA  PEDIDO EMISSAO  CLIENTE   CLIENTE     PASY            CLIENTE         PEDIDO                   PEDIDA   ENTREGUE   PENDENTE
999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
	0        9      16       25       34           47              63              79                       104      113        124
	*/
EndIF


SetRegua(RecCount())		// Total de Elementos da regua

While !Eof() .And. &cCond1 .And. lContinua 
	
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
	
	While !Eof() .And. &cCond2
		
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
		
		If MV_PAR21 == 1
			_cPed := "N"    // Normal
		ElseIf MV_PAR21 == 2
			_cPed := "A"      // Amostra
		ElseIf MV_PAR21 == 3
			_cPed := "Z"      // Previsao
	    ElseIf MV_PAR21 == 4 
    	    _cPed := "D"   
	    Else               	    
            _cPed := " /3/D/N/A/Z"
		Endif
		
		If !SC6->C6_PEDAMOS $ _cPed
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		                                 
		If SC6->C6_PEDAMOS == "N"
		   _cDesTipo := "NORMAL"
		ElseIf SC6->C6_PEDAMOS == "A"
		   _cDesTipo := "AMOSTRA"
		ElseIf SC6->C6_PEDAMOS == "D"
		   _cDesTipo := "DESPES.ACESS."				   
		ElseIf SC6->C6_PEDAMOS == "Z"
		   _cDesTipo := "PREVISAO"
		Endif

		IF SC6->C6_QTDENT >= SC6->C6_QTDVEN .And. mv_par11 == 1
			dbSkip()
			Loop
		EndIF
		
		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek (xFilial()+SC6->C6_TES)
		dbSelectArea("SC6")
		If ( SF4->F4_DUPLIC == "S" .And. mv_par12 == 2 ) .Or. ( SF4->F4_DUPLIC != "S" .And. mv_par12 == 1 )
			dbSkip()
			Loop
		Endif
/*		
		lRet:=ValidMasc(SC6->C6_PRODUTO,MV_PAR13)
		If !lRet
			dbSkip()
			Loop
		Endif
*/		
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
		If dbSeek( xFilial()+SC6->C6_PRODUTO )
			If  SB1->B1_GRUPO < MV_PAR17  .Or. SB1->B1_GRUPO > MV_PAR18 .Or.;
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
		          
		dbSelectarea("SC6")
		dbSkip()
	EndDo
	
	If nSaldo > 0 .Or. lImpTot
		If nOrdem == 2 .And. nCont > 1
			@Li,000 Psay "TOTAL ---->"
			@Li,100 Psay nTotVen PICTURE PesqPictQt("C6_QTDVEN",10)
			@Li,111 Psay nTotEnt PICTURE PesqPictQt("C6_QTDENT",10)
			@Li,122 Psay nTotSal PICTURE PesqPictQt("C6_QTDVEN",10)
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


dbSelectArea("TRB")
dbGotop()

If !Empty(TRB->PRODUTO)
	RptStatus({|lEnd| ImpEst(@lEnd,wnRel,cString)},Titulo)
Endif

dbSelectArea("TRB")
dbCloseArea()

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
dbSeek( xFilial()+SC6->C6_NUM )

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek( xFilial()+SC6->C6_CLI+SC6->C6_LOJA )

dbSelectArea("SC6")
IF nOrdem = 1
	@li,  0 Psay  SC6->C6_NUM
	@li,  7 Psay  SC5->C5_EMISSAO
	@li, 16 Psay  SC6->C6_CLI
	@li, 23 Psay  SC6->C6_LOJA
	@li, 26 Psay  Subs(SA1->A1_NOME, 1,08)
ElseIF nOrdem = 2
	@li,  0 Psay  IIF(SC6->C6_GRADE=="S" .And. MV_PAR14 == 1,Substr(SC6->C6_PRODUTO,1,nTamref),SC6->C6_PRODUTO)
	dbSelectArea("SC6")
ElseIF nOrdem = 3
	@li,  0 Psay SC6->C6_CLI
	@li,  7 Psay SC6->C6_LOJA
	@li,  10 Psay Subs(SA1->A1_NOME, 1,08)
Else
	If cNumPed+cNumCli+DtoS(dData) != SC6->C6_NUM+SC6->C6_CLI+SC6->C6_LOJA+DtoS(SC6->C6_ENTREG)
		@li,  0 Psay SC6->C6_ENTREG
		@li, 09 Psay SC6->C6_NUM
		@li, 17 Psay SC5->C5_EMISSAO
		@li, 25 Psay SC6->C6_CLI
		@li, 32 Psay SC6->C6_LOJA
		@li, 35 Psay Subs(SA1->A1_NOME, 1,08)
		cNumPed := SC6->C6_NUM
		cNumCli := SC6->C6_CLI+SC6->C6_LOJA
	Else
		li--
	EndIf
	dData := SC6->C6_ENTREG
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
dbSeek( xFilial()+SC6->C6_NUM )
dbSelectArea(cAliasAnt)

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek( xFilial() + SC6->C6_PRODUTO )
     
If SB1->B1_TIPO == "PA"
	dbSelectArea("SG1")
	dbSetOrder(1)
	If !dbseek(xFilial()+ SC6->C6_PRODUTO)
		dbSelectArea("TRB")
		If !dbSeek(SC6->C6_PRODUTO)
			RecLock("TRB",.T.)
			TRB->PRODUTO := SC6->C6_PRODUTO
			TRB->DESCRIC := SB1->B1_DESC
			MsUnlock()
		Endif
	Endif
Endif

IF nOrdem = 1
	@li, 34 Psay SC6->C6_ITEM
	@li, 37 Psay IIF(SC6->C6_GRADE=="S" .And. MV_PAR14 == 1,Substr(SC6->C6_PRODUTO,1,nTamref),SC6->C6_PRODUTO)
	@li, 53 Psay SC6->C6_CPROCLI
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial() + SC6->C6_PRODUTO )
///	@li, 69 Psay Substr(B1_DESC,1,20)
	@li, 69 Psay _cDesTipo
	dbSelectArea("SC6")
	
	IF SC6->C6_GRADE == "S" .And. MV_PAR14 == 1
		cProdRef:=Substr(SC6->C6_PRODUTO,1,nTamRef)
		nSaldo  := 0
		nTotVen := 0
		nTotEnt := 0
		nTotSal := 0
		nReg    := 0
		While !Eof() .And. cFilial == SC6->C6_FILIAL .And. cProdRef == Substr(SC6->C6_PRODUTO,1,nTamRef);
			.And. SC6->C6_GRADE == "S" .And. &cCond2
			nReg   := Recno()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se esta dentro dos parametros                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF  SC6->C6_NUM     < mv_par01 .OR. SC6->C6_NUM     > mv_par02 .OR. ;
				SC6->C6_PRODUTO < mv_par03 .OR. SC6->C6_PRODUTO > mv_par04 .OR. ;
				SC6->C6_CLI     < mv_par05 .OR. SC6->C6_CLI     > mv_par06 .OR. ;
				SC6->C6_LOJA    < mv_par07 .OR. SC6->C6_LOJA    > mv_par08 .OR. ;
				Dtos(SC6->C6_ENTREG)  < Dtos(mv_par09) .OR. Dtos(SC6->C6_ENTREG)  > Dtos(mv_par10)
				dbSkip()
				LOOP
			Endif
			
			IF SC6->C6_QTDENT >= SC6->C6_QTDVEN .And. mv_par11 == 1
				dbSkip()
				Loop
			EndIF
			
			If mv_par15 == 2 .and. Alltrim(SC6->C6_BLQ) == "R"
				dbSkip()
				Loop
			Endif
			
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek (xFilial() +SC6->C6_TES)
			dbSelectArea("SC6")
			If ( SF4->F4_DUPLIC == "S" .And. mv_par12 == 2 ) .Or. ( SF4->F4_DUPLIC != "S" .And. mv_par12 == 1 )
				dbSkip()
				Loop
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Valida o produto conforme a mascara         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lRet:=ValidMasc(SC6->C6_PRODUTO,MV_PAR13)
			If !lRet
				dbSkip()
				Loop
			Endif
			IF Alltrim(SC6->C6_BLQ) == "R" .and. mv_par15 == 2	// Se Foi Eliminado Residuos
				nSaldo += 0
			Else
				nSaldo  += SC6->C6_QTDVEN-SC6->C6_QTDENT
			Endif
			nTotVen+= SC6->C6_QTDVEN
			nTotEnt+= SC6->C6_QTDENT
			dbSkip()
		End
		nTotSal += nSaldo
		If nReg > 0
			dbGoto(nReg)
			nReg :=0
		Endif
	Endif
	@li,90  Psay SC6->C6_ENTREG 	PICTURE "@D"
	@li,99  Psay IIF(SC6->C6_GRADE=="S" .And. MV_PAR14 == 1,nTotVen,SC6->C6_QTDVEN)	PICTURE PesqPictQt("C6_QTDVEN",10)
	@li,110 Psay IIF(SC6->C6_GRADE=="S" .And. MV_PAR14 == 1,nTotEnt,SC6->C6_QTDENT)	PICTURE PesqPictQt("C6_QTDENT",10)
	@li,121 Psay nSaldo	PICTURE PesqPictQt("C6_QTDVEN",10)
ElseIF nOrdem = 2
	@li, 16 Psay  SC6->C6_CPROCLI
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial()+SC6->C6_PRODUTO )
//	@li, 32 Psay Substr(B1_DESC,1,20)
	@li, 32 Psay _cDesTipo
	dbSelectArea("SC6")
	@li, 53 Psay SC6->C6_NUM
	@li, 61 Psay SC6->C6_ITEM
	@li, 64 Psay SC5->C5_EMISSAO
	@li, 73 Psay SC6->C6_ENTREG
	@li, 82 Psay SC6->C6_CLI
	@li, 89 Psay SC6->C6_LOJA
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek( xFilial()+SC6->C6_CLI+SC6->C6_LOJA )
	@li, 92 Psay SUBSTR(A1_NOME, 1,08)
	dbSelectArea("SC6")
	IF SC6->C6_GRADE == "S" .And. MV_PAR14 == 1
		cProdRef:=Substr(SC6->C6_PRODUTO,1,nTamRef)
		nSaldo  := 0
		nTotSal := 0
		nTotVen := 0
		nTotEnt := 0
		nReg    := 0
		While !Eof() .And. cFilial == SC6->C6_FILIAL .And. cProdRef == Substr(SC6->C6_PRODUTO,1,nTamRef);
			.And. SC6->C6_GRADE == "S"
			nReg   := Recno()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se esta dentro dos parametros                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			IF  SC6->C6_NUM     < mv_par01 .OR. SC6->C6_NUM     > mv_par02 .OR. ;
				SC6->C6_PRODUTO < mv_par03 .OR. SC6->C6_PRODUTO > mv_par04 .OR. ;
				SC6->C6_CLI     < mv_par05 .OR. SC6->C6_CLI     > mv_par06 .OR. ;
				SC6->C6_LOJA    < mv_par07 .OR. SC6->C6_LOJA    > mv_par08 .OR. ;
				Dtos(SC6->C6_ENTREG)  < Dtos(mv_par09) .OR. Dtos(SC6->C6_ENTREG)  > Dtos(mv_par10)
				dbSkip()
				LOOP
			Endif
			IF SC6->C6_QTDENT >= SC6->C6_QTDVEN .And. mv_par11 == 1
				dbSkip()
				Loop
			EndIF
			
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial() +SC6->C6_TES)
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
			IF Alltrim(SC6->C6_BLQ) == "R" .and. mv_par15 == 2				// Se Foi Eliminado Residuos
				nSaldo += 0
			Else
				nSaldo += SC6->C6_QTDVEN-SC6->C6_QTDENT
			Endif
			nTotVen+= SC6->C6_QTDVEN
			nTotEnt+= SC6->C6_QTDENT
			dbSkip()
		End
		nTotSal += nSaldo
		If nReg > 0
			dbGoto(nReg)
			nReg :=0
		Endif
	Endif
	@li,100 Psay IIF(SC6->C6_GRADE=="S" .And. MV_PAR14 == 1,nTotVen,SC6->C6_QTDVEN)	PICTURE PesqPictQt("C6_QTDVEN",10)
	@li,111 Psay IIF(SC6->C6_GRADE=="S" .And. MV_PAR14 == 1,nTotEnt,SC6->C6_QTDENT)	PICTURE PesqPictQt("C6_QTDENT",10)
	@li,122 Psay nSaldo	PICTURE PesqPictQt("C6_QTDVEN",10)
ElseIF nOrdem = 3
	@li, 20 Psay SC6->C6_NUM
	@li, 27 Psay SC6->C6_ITEM
	@li, 31 Psay SC5->C5_EMISSAO
	@li, 40 Psay IIF(SC6->C6_GRADE == "S" .And. MV_PAR14==1,Substr(SC6->C6_PRODUTO,1,nTamref),SC6->C6_PRODUTO)
	@li, 56 Psay SC6->C6_CPROCLI
	dbSelectArea("SB1")
	dbSeek( cFilial+SC6->C6_PRODUTO )
//	@li, 72 Psay Substr(B1_DESC,1,20)
	@li, 72 Psay _cDesTipo
	dbSelectArea("SC6")
	IF SC6->C6_GRADE == "S" .And. MV_PAR14 == 1
		cProdRef:=Substr(SC6->C6_PRODUTO,1,nTamRef)
		nSaldo  := 0
		nTotSal := 0
		nTotVen := 0
		nTotEnt := 0
		nReg    := 0
		While !Eof() .And. cFilial == SC6->C6_FILIAL .And. cProdRef == Substr(SC6->C6_PRODUTO,1,nTamRef);
			.And. SC6->C6_GRADE == "S" .And. &cCond2
			nReg   := Recno()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se esta dentro dos parametros                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF  SC6->C6_NUM     < mv_par01 .OR. SC6->C6_NUM     > mv_par02 .OR. ;
				SC6->C6_PRODUTO < mv_par03 .OR. SC6->C6_PRODUTO > mv_par04 .OR. ;
				SC6->C6_CLI     < mv_par05 .OR. SC6->C6_CLI     > mv_par06 .OR. ;
				SC6->C6_LOJA    < mv_par07 .OR. SC6->C6_LOJA    > mv_par08 .OR. ;
				Dtos(SC6->C6_ENTREG)  < Dtos(mv_par09) .OR. Dtos(SC6->C6_ENTREG)  > Dtos(mv_par10)
				dbSkip()
				LOOP
			Endif
			
			IF SC6->C6_QTDENT >= SC6->C6_QTDVEN .And. mv_par11 == 1
				dbSkip()
				Loop
			EndIF
			
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial() +SC6->C6_TES)
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
			
			IF Alltrim(SC6->C6_BLQ) == "R" .and. mv_par15 == 2				// Se Foi Eliminado Residuos
				nSaldo += 0
			Else
				nSaldo += SC6->C6_QTDVEN-SC6->C6_QTDENT
			Endif
			nTotVen+= SC6->C6_QTDVEN
			nTotEnt+= SC6->C6_QTDENT
			dbSkip()
		EndDo
		nTotSal += nSaldo
		If nReg > 0
			dbGoto(nReg)
			nReg :=0
		Endif
	Endif
	
	@li,093 Psay SC6->C6_ENTREG PICTURE "@D"
	@li,102 Psay IIF(SC6->C6_GRADE=="S" .And. MV_PAR14 == 1,nTotVen,SC6->C6_QTDVEN)	PICTURE PesqPictQt("C6_QTDVEN",10)
	@li,112 Psay IIF(SC6->C6_GRADE=="S" .And. MV_PAR14 == 1,nTotEnt,SC6->C6_QTDENT)	PICTURE PesqPictQt("C6_QTDENT",10)
	@li,122 Psay nSaldo	PICTURE PesqPictQt("C6_QTDVEN",10)
Else
	@li, 44 Psay SC6->C6_ITEM
	@li, 47 Psay IIF(SC6->C6_GRADE=="S" .And. MV_PAR14 == 1,Substr(SC6->C6_PRODUTO,1,nTamRef),SC6->C6_PRODUTO)
	@li, 63 Psay SC6->C6_CPROCLI
	dbSelectArea("SB1")
	dbSeek( cFilial+SC6->C6_PRODUTO )
//	@li, 79 Psay Substr(B1_DESC,1,20)
	@li, 79 Psay _cDesTipo
	dbSelectArea("SC6")
	IF SC6->C6_GRADE == "S" .And. MV_PAR14 == 1
		cProdRef:=Substr(SC6->C6_PRODUTO,1,nTamRef)
		nSaldo  := 0
		nTotSal := 0
		nTotVen := 0
		nTotEnt := 0
		nReg    := 0
		While !Eof() .And. cFilial == SC6->C6_FILIAL .And. cProdRef == Substr(SC6->C6_PRODUTO,1,nTamRef);
			.And. SC6->C6_GRADE == "S" .And. &cCond2
			nReg   := Recno()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se esta dentro dos parametros                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF  SC6->C6_NUM     < mv_par01 .OR. SC6->C6_NUM     > mv_par02 .OR. ;
				SC6->C6_PRODUTO < mv_par03 .OR. SC6->C6_PRODUTO > mv_par04 .OR. ;
				SC6->C6_CLI     < mv_par05 .OR. SC6->C6_CLI     > mv_par06 .OR. ;
				SC6->C6_LOJA    < mv_par07 .OR. SC6->C6_LOJA    > mv_par08 .OR. ;
				Dtos(SC6->C6_ENTREG)  < Dtos(mv_par09) .OR. Dtos(SC6->C6_ENTREG)  > Dtos(mv_par10)
				dbSkip()
				LOOP
			Endif
			IF SC6->C6_QTDENT >= SC6->C6_QTDVEN .And. mv_par11 == 1
				dbSkip()
				Loop
			EndIF
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek (xFilial()+SC6->C6_TES)
			dbSelectArea("SC6")
			If ( SF4->F4_DUPLIC == "S" .And. mv_par12 == 2 ) .Or. ( SF4->F4_DUPLIC != "S" .And. mv_par12 == 1 )
				dbSkip()
				Loop
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Valida o produto conforme a mascara         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lRet:=ValidMasc(SC6->C6_PRODUTO,MV_PAR13)
			If !lRet
				dbSkip()
				Loop
			Endif
			IF Alltrim(SC6->C6_BLQ) == "R" .and. mv_par15 == 2				// Se Foi Eliminado Residuos
				nSaldo += 0
			Else
				nSaldo  += SC6->C6_QTDVEN-SC6->C6_QTDENT
			Endif
			nTotVen+= SC6->C6_QTDVEN
			nTotEnt+= SC6->C6_QTDENT
			dbSkip()
		End
		nTotSal+= nSaldo
		If nReg > 0
			dbGoto(nReg)
			nReg :=0
		Endif
	Endif
	@li, 100 Psay IIF(SC6->C6_GRADE=="S" .And. MV_PAR14 == 1,nTotVen,SC6->C6_QTDVEN)	PICTURE PesqPictQt("C6_QTDVEN",10)
	@li, 110 Psay IIF(SC6->C6_GRADE=="S" .And. MV_PAR14 == 1,nTotEnt,SC6->C6_QTDENT)	PICTURE PesqPictQt("C6_QTDENT",10)
	@li, 122 Psay nSaldo	PICTURE PesqPictQt("C6_QTDVEN",10)
EndIF

Return .T.

Static Function ImpEst()

           
/*
Produto         Descricao                      Observacao
999999999999999 999999999999999999999999999999 999999999999999999999
0               16                             47
*/


li := 80
Cabec1 := "Produto         Descricao                      Observacao"
Cabec2 := ""
Tamanho:= "M"
Titulo := "Produtos Sem Estrutura"

dbSelectArea("TRB")
dbGotop()

SetRegua(LastRec())

While !Eof()

	IncRegua()
	
	IF li > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	
	@li, 00 Psay TRB->PRODUTO
	@li, 16 Psay TRB->DESCRIC
	@li, 47 Psay "PRODUTO SEM ESTRUTURA"
	
	LI++
	
	dbSkip()
EndDo

Return