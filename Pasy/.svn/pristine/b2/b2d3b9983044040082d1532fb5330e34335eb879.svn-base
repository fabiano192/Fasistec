#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0009A  ³ Autor ³ Alexandro da Silva    ³ Data ³ 16.09.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Pedidos nao entregues                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄAÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0009A()

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
PRIVATE nomeprog := "Pa0009A"
PRIVATE aLinha   := { },nLastKey := 0
PRIVATE cPerg    := "PA0009"
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
wnrel:="PA0009A"
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

If nOrdem == 3 .Or. nOrdem == 4
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNomArq := CriaTrab("",.F.)
EndIf

IF nOrdem = 1
	dbSetOrder(1)
	dbSeek(xFilial("SC6")+mv_par01,.T.)
	cCond1 := "SC6->C6_NUM >= mv_par01 .And. SC6->C6_NUM <= mv_par02"
	cCond2 := "SC6->C6_NUM = cNum"
	titulo := titulo +" - Por Pedido"
	cabec1 := "NUMERO DATA     CODIGO NOME DO    IT PRODUTO         PRODUTO         DESCRICAO            DATA     QUANT.     QUANT.     QUANT.  "
	cabec2 := "PEDIDO EMISSAO  CLIENT CLIENTE       PASY            CLIENTE         MATERIAL             ENTREGA  PEDIDA     ENTREGUE   PENDENTE"	

    /*
	NUMERO DATA     CODIGO NOME DO    IT PRODUTO         PRODUTO         DESCRICAO            DATA     QUANT.     QUANT.     QUANT.
	999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
	0      7        16     23         34 37              53              69                   90       99         110        121       132
	
	PEDIDO EMISSAO  CLIENT CLIENTE       PASY            CLIENTE         MATERIAL             ENTREGA  PEDIDA     ENTREGUE   PENDENTE
	999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
	0      7        16     23            37              53              69                   90       99         110        121       132                     132
    */

ElseIF nOrdem = 2
	dbSetOrder(2)
	dbSeek(xFilial("SC6")+mv_par03,.T.)
	cCond1 := "SC6->C6_PRODUTO >= mv_par03 .And. SC6->C6_PRODUTO <= mv_par04"
	cCond2 := "SC6->C6_PRODUTO = cProduto"
	titulo := titulo + " - Por Produto"
	cabec1 := "PRODUTO         PRODUTO         DESCRICAO            NUMERO  IT DATA     DATA     CODIGO NOME DO    QUANTIDADE QUANTIDADE QUANTIDADE"
	cabec2 := "PASY            CLIENTE                              PEDIDO     EMISSAO  ENTREGA  CLIENT CLIENTE    PEDIDA     ENTREGUE   PENDENTE  "
	/*
	PRODUTO         PRODUTO         DESCRICAO            NUMERO  IT DATA     DATA     CODIGO NOME DO    QUANTIDADE QUANTIDADE QUANTIDADE
	999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
	0               16              32                   53      61 64       73       82     89         100        111        122
	PASY            CLIENTE                              PEDIDO     EMISSAO  ENTREGA  CLIENT CLIENTE    PEDIDA     ENTREGUE   PENDENTE
	999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
	0               16              32                   53      61 64       73       82     89         100        111        122
	*/
ElseIF nOrdem = 3
	
	IndRegua("SC6",cNomArq,"C6_FILIAL+C6_CLI+C6_LOJA+C6_NUM+C6_ITEM",,,"Selecionando Registros...")
	dbSeek(xFilial("SC6")+mv_par05,.T.)
	
	cCond1 := "SC6->C6_CLI >= mv_par05 .And. SC6->C6_CLI <= mv_par06 .And. SC6->C6_LOJA >= MV_PAR07 .AND. SC6->C6_LOJA <= MV_PAR08"
	cCond2 := "SC6->C6_CLI+SC6->C6_LOJA = cCli"
	
	titulo := titulo + " - Por Cliente"
	cabec1 := "CODIGO    NOME DO   NUMERO IT  DATA     PRODUTO         PRODUTO         DESCRICAO            DATA     QUANT.    QUANT.    QUANT.   "
	cabec2 := "CLIENTE   CLIENTE   PEDIDO     EMISSAO  PASY            CLIENTE         MATERIAL             ENTREGA  PEDIDA    ENTREGUE  PENDENTE "
	/*
	CODIGO    NOME DO   NUMERO IT  DATA     PRODUTO         PRODUTO         DESCRICAO            DATA     QUANT.    QUANT.    QUANT.
	999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
	0         10        20     27  31       40              56              72                   93       102       112       122
	CLIENTE   CLIENTE   PEDIDO     EMISSAO  PASY            CLIENTE         MATERIAL             ENTREGA  PEDIDA    ENTREGUE  PENDENTE"
	999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
	0         10        20         31       40              56              72                   93       102       112       122
	
	*/
Else	
	IndRegua("SC6",cNomArq,"C6_FILIAL+DTOS(C6_ENTREG)+C6_NUM+C6_ITEM",,,"Selecionando Registros...")
	
	dbSeek(xFilial("SC6")+DTOS(mv_par09),.T.)
	
	cCond1 := "DTOS(SC6->C6_ENTREG) >= Dtos(mv_par09) .And. Dtos(SC6->C6_ENTREG) <= Dtos(mv_par10)"
	cCond2 := "SC6->C6_ENTREG = dEntreg"
	titulo := titulo + " - Por Data de Entrega"
	cabec1 := "DATA     NUMERO DATA     CODIGO   IT PRODUTO         PRODUTO               QUANT.       QUANT.       QUANT.       QUANT."
	cabec2 := "ENTREGA  PEDIDO EMISSAO  CLIENTE     PASY            CLIENTE             ANTERIOR     ATUAL        ENTREGUE     PENDENTE"
	/*
	DATA     NUMERO DATA     CODIGO   IT PRODUTO         PRODUTO               QUANT.       QUANT.       QUANT.       QUANT.
	99999999 999999 99999999 99999999 99 999999999999999 999999999999999 999999999999 999999999999 999999999999 999999999999
	0        9      16       25       34 37              53              69           82           95           108
	ENTREGA  PEDIDO EMISSAO  CLIENTE     PASY            CLIENTE             ANTERIOR     ATUAL        ENTREGUE     PENDENTE
	999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
	0        9      16       25       34           47              63     79        80
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
		
		dbSkip()
	End
	
	If nSaldo > 0 .Or. lImpTot
		If nOrdem == 2 .And. nCont > 1
			@Li,000 Psay "TOTAL ---->"
			@Li,082 Psay nTotVen PICTURE PesqPictQt("C6_QTDVEN",10)
			@Li,095 Psay nTotEnt PICTURE PesqPictQt("C6_QTDENT",10)
			@Li,108 Psay nTotSal PICTURE PesqPictQt("C6_QTDVEN",10)
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
End

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
set device to screen
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
	@li, 23 Psay  Subs(SA1->A1_NOME, 1,10)
ElseIF nOrdem = 2
	@li,  0 Psay  IIF(C6_GRADE=="S" .And. MV_PAR14 == 1,Substr(C6_PRODUTO,1,nTamref),C6_PRODUTO)
	/*
	@li, 16 Psay  C6_CPROCLI
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial("SB1")+SC6->C6_PRODUTO )
	@li, 32 Psay Substr(B1_DESC,1,20)
	*/
	dbSelectArea("SC6")
ElseIF nOrdem = 3
	@li,  0 Psay C6_CLI
	@li,  10 Psay Subs(SA1->A1_NOME, 1,10)
Else
	If cNumPed+cNumCli+DtoS(dData) != C6_NUM+C6_CLI+C6_LOJA+DtoS(C6_ENTREG)
		@li,  0 Psay C6_ENTREG
		@li, 09 Psay C6_NUM
		@li, 16 Psay SC5->C5_EMISSAO
		@li, 25 Psay C6_CLI
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
	@li, 34 Psay C6_ITEM
	@li, 37 Psay C6_PRODUTO
	@li, 53 Psay C6_CPROCLI	
	@li, 90 Psay C6_ENTREG 	PICTURE "@D"
	@li, 99 Psay IIF(C6_GRADE=="S" .And. MV_PAR14 == 1,nTotVen,C6_QTDVEN)	PICTURE PesqPictQt("C6_QTDVEN",10)
	@li,110 Psay IIF(C6_GRADE=="S" .And. MV_PAR14 == 1,nTotEnt,C6_QTDENT)	PICTURE PesqPictQt("C6_QTDENT",10)
	@li,121 Psay nSaldo	PICTURE PesqPictQt("C6_QTDVEN",10)
ElseIF nOrdem = 2
	@li, 16 Psay  C6_CPROCLI
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial("SB1")+SC6->C6_PRODUTO )
	@li, 32 Psay Substr(B1_DESC,1,20)
	dbSelectArea("SC6")
	@li, 53 Psay C6_NUM
	@li, 61 Psay C6_ITEM
	@li, 64 Psay SC5->C5_EMISSAO
	@li, 73 Psay C6_ENTREG
	@li, 82 Psay C6_CLI
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek( xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA )
	@li, 89 Psay SUBSTR(A1_NOME, 1,10)
	dbSelectArea("SC6")
	IF SC6->C6_GRADE == "S" .And. MV_PAR14 == 1
		cProdRef:=Substr(SC6->C6_PRODUTO,1,nTamRef)
		nSaldo  := 0
		nTotSal := 0
		nTotVen := 0
		nTotEnt := 0
		nReg    := 0
		While !Eof() .And. cFilial == C6_FILIAL .And. cProdRef == Substr(C6_PRODUTO,1,nTamRef);
			.And. SC6->C6_GRADE == "S"
			nReg   := Recno()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se esta dentro dos parametros                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			IF C6_NUM     < mv_par01 .OR. C6_NUM     > mv_par02 .OR. ;
				C6_PRODUTO < mv_par03 .OR. C6_PRODUTO > mv_par04 .OR. ;
				C6_CLI     < mv_par05 .OR. C6_CLI     > mv_par06 .OR. ;
				C6_LOJA    < mv_par07 .OR. C6_LOJA    > mv_par08 .OR. ;
				Dtos(C6_ENTREG)  < Dtos(mv_par09) .OR. Dtos(C6_ENTREG)  > Dtos(mv_par10)
				dbSkip()
				LOOP
			Endif
			IF C6_QTDENT >= C6_QTDVEN .And. mv_par11 == 1
				dbSkip()
				Loop
			EndIF
			
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial("SF4") +SC6->C6_TES)
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
			IF Alltrim(C6_BLQ) == "R" .and. mv_par15 == 2				// Se Foi Eliminado Residuos
				nSaldo += 0
			Else
				nSaldo += C6_QTDVEN-C6_QTDENT
			Endif
			nTotVen+= C6_QTDVEN
			nTotEnt+= C6_QTDENT
			dbSkip()
		End
		nTotSal += nSaldo
		If nReg > 0
			dbGoto(nReg)
			nReg :=0
		Endif
	Endif
	@li,100 Psay IIF(C6_GRADE=="S" .And. MV_PAR14 == 1,nTotVen,C6_QTDVEN)	PICTURE PesqPictQt("C6_QTDVEN",10)
	@li,111 Psay IIF(C6_GRADE=="S" .And. MV_PAR14 == 1,nTotEnt,C6_QTDENT)	PICTURE PesqPictQt("C6_QTDENT",10)
	@li,122 Psay nSaldo	PICTURE PesqPictQt("C6_QTDVEN",10)
ElseIF nOrdem = 3
	@li, 20 Psay C6_NUM
	@li, 27 Psay C6_ITEM
	@li, 31 Psay SC5->C5_EMISSAO
	@li, 40 Psay IIF(C6_GRADE == "S" .And. MV_PAR14==1,Substr(C6_PRODUTO,1,nTamref),C6_PRODUTO)
	@li, 56 Psay C6_CPROCLI
	dbSelectArea("SB1")
	dbSeek( cFilial+SC6->C6_PRODUTO )
	@li, 72 Psay Substr(B1_DESC,1,20)
	dbSelectArea("SC6")
	IF SC6->C6_GRADE == "S" .And. MV_PAR14 == 1
		cProdRef:=Substr(SC6->C6_PRODUTO,1,nTamRef)
		nSaldo  := 0
		nTotSal := 0
		nTotVen := 0
		nTotEnt := 0
		nReg    := 0
		While !Eof() .And. cFilial == C6_FILIAL .And. cProdRef == Substr(C6_PRODUTO,1,nTamRef);
			.And. SC6->C6_GRADE == "S" .And. &cCond2
			nReg   := Recno()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se esta dentro dos parametros                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF C6_NUM     < mv_par01 .OR. C6_NUM     > mv_par02 .OR. ;
				C6_PRODUTO < mv_par03 .OR. C6_PRODUTO > mv_par04 .OR. ;
				C6_CLI     < mv_par05 .OR. C6_CLI     > mv_par06 .OR. ;
				C6_LOJA    < mv_par07 .OR. C6_LOJA    > mv_par08 .OR. ;
				Dtos(C6_ENTREG)  < Dtos(mv_par09) .OR. Dtos(C6_ENTREG)  > Dtos(mv_par10)
				dbSkip()
				LOOP
			Endif
			
			IF C6_QTDENT >= C6_QTDVEN .And. mv_par11 == 1
				dbSkip()
				Loop
			EndIF
			
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial("SF4") +SC6->C6_TES)
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
			
			IF Alltrim(C6_BLQ) == "R" .and. mv_par15 == 2				// Se Foi Eliminado Residuos
				nSaldo += 0
			Else
				nSaldo += C6_QTDVEN-C6_QTDENT
			Endif
			nTotVen+= C6_QTDVEN
			nTotEnt+= C6_QTDENT
			dbSkip()
		EndDo
		nTotSal += nSaldo
		If nReg > 0
			dbGoto(nReg)
			nReg :=0
		Endif
	Endif
	
	@li,093 Psay C6_ENTREG PICTURE "@D"
	@li,102 Psay IIF(C6_GRADE=="S" .And. MV_PAR14 == 1,nTotVen,C6_QTDVEN)	PICTURE PesqPictQt("C6_QTDVEN",10)
	@li,112 Psay IIF(C6_GRADE=="S" .And. MV_PAR14 == 1,nTotEnt,C6_QTDENT)	PICTURE PesqPictQt("C6_QTDENT",10)
	@li,122 Psay nSaldo	PICTURE PesqPictQt("C6_QTDVEN",10)
Else
	@li, 34  Psay C6_ITEM
	@li, 37  Psay C6_PRODUTO
	@li, 53  Psay C6_CPROCLI
	@li, 69  Psay C6_QTORI	  Picture TM(C6_QTORI,12)
	@li, 82  Psay C6_QTDVEN	  Picture TM(C6_QTDVEN,12)
	@li, 95  Psay C6_QTDENT	  Picture TM(C6_QTDENT,12)
	@li, 108 Psay nSaldo	  Picture TM(C6_QTDVEN,12)
EndIF

Return .T.
