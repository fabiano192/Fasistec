#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0009B  ³ Autor ³ Alexandro da Silva    ³ Data ³ 22.01.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Pedidos nao entregues                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ-±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0009B()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

LOCAL CbTxt
LOCAL cDesc1     := "Este programa ira emitir a relacao dos Pedidos Pendentes,"
LOCAL cDesc2     := "imprimindo o numero do Pedido, Cliente, Data da Entrega, "
LOCAL cDesc3     := "Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso."
LOCAL cString    := "SC6"           
Private titulo   := "Relacao de Pedidos nao entregues"
Private CbCont,cabec1,cabec2,wnrel
Private tamanho  := " "
Private limite   := 132
PRIVATE aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
PRIVATE nomeprog := "PA0009B"
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

wnrel := "PA0009B"
aOrd  := {"Por Pedido","Por Produto","Por Cliente","Por Dt.Entrega"}
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

If nLastKey==27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

private _nLiMU := _nLiMV := _nLiPF := 0
Private _lProx := .T.

RptStatus({|lEnd| ImpRel(@lEnd,wnRel,cString)},Titulo)

dbSelectArea("TRB")
dbCloseArea()

Return

Static Function ImpRel(lEnd,WnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo :=OemToAnsi("Relacao de Pedidos nao entregues")
cDesc1 :=OemToAnsi("Este programa ira emitir a relacao dos Pedidos Pendentes,")
cDesc2 :=OemToAnsi("imprimindo o numero do Pedido, Cliente, Data da Entrega, ")
cDesc3 :=OemToAnsi("Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso.")
tamanho:=" "
limite :=132
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

aStru := {}
AADD(aStru,{"PEDIDO"   , "C" ,  6, 0 })
AADD(aStru,{"ITEM"     , "C" ,  2, 0 })
AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
AADD(aStru,{"PRODUTIL" , "C" , 15, 0 })
AADD(aStru,{"PRODVUL"  , "C" , 10, 0 })
AADD(aStru,{"QTDCAV"   , "C" , 05, 0 })
AADD(aStru,{"PRODINS"  , "C" , 15, 0 })
AADD(aStru,{"TIPO"     , "C" , 01, 0 })

cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "PEDIDO+ITEM+PRODUTO"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

If nOrdem == 4
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNomArq := CriaTrab("",.F.)
EndIf

dbSelectArea("SC6")

IF nOrdem = 1
	dbOrderNickName("INDSC65")
	dbSeek(xFilial("SC6")+mv_par01,.T.)
	cCond1 := "SC6->C6_NUM >= mv_par01 .And. SC6->C6_NUM <= mv_par02"
	cCond2 := "SC6->C6_NUM = cNum"
	_cCond3:= "SC6->C6_PRODUTO = cProduto"
	titulo := titulo +" - Por Pedido"
	cabec1 := "NUMERO CODIGO LJ IT PRODUTO        PRODUTO         MATERIAL        MOLDE DE   QTDE DE PRE FORMADO     DATA     QUANT.     QUANT."
	cabec2 := "PEDIDO CLIENT       PASY           CLIENTE         UTILIZADO       VULCANIZAC CAVIDAD INSERTO METALIC ENTREGA  PEDIDA     PENDENTE"
	
	/*
	NUMERO CODIGO LJ IT PRODUTO        PRODUTO         MATERIAL        MOLDE DE   QTDE DE PRE FORMADO     DATA     QUANT.     QUANT.
	999999 999999 99 99 99999999999999 999999999999999 999999999999999 9999999999 9999999 999999999999999 99999999 9999999999 9999999999
	0      7      14 17 20             35              51              67         78      86              102      111        122
	
	PEDIDO CLIENT       PASY           CLIENTE         UTILIZADO       VULCANIZAC CAVIDAD INSERTO METALIC ENTREGA  PEDIDA     PENDENTE
	999999 999999 99 99 99999999999999 999999999999999 999999999999999 9999999999 9999999 999999999999999 99999999 9999999999 9999999999
	0      7      14 17 20             35              51              67         78      86              102      111        122                              132
	*/	
ElseIF nOrdem = 2
	dbSetOrder(2)
	dbSeek(xFilial("SC6")+mv_par03,.T.)
	cCond1 := "SC6->C6_PRODUTO >= mv_par03 .And. SC6->C6_PRODUTO <= mv_par04"
	cCond2 := "SC6->C6_PRODUTO = cProduto"
	_cCond3:= "SC6->C6_PRODUTO = cProduto"	
	titulo := titulo + " - Por Produto"                                                                                              
	cabec1 := "PRODUTO         PRODUTO         MATERIAL        MOLDE DE   QTDE DE PRE FORMADO    NUMERO IT DATA     CODIGO LJ QUANTIDADE QUANTIDADE"
	cabec2 := "PASY            CLIENTE         UTILIZADO       VULCANIZAC CAVIDAD INSERTO METAL  PEDIDO    ENTREGA  CLIENT    PEDIDA     PENDENTE  "
	/*                                                                  14
	PRODUTO         PRODUTO         MATERIAL        MOLDE DE   QTDE DE PRE FORMADO    NUMERO IT DATA     CODIGO LJ QUANTIDADE QUANTIDADE
	999999999999999 999999999999999 999999999999999 9999999999 9999999 99999999999999 999999 99 99999999 999999 99 9999999999 9999999999
	0               16              32              48         59      67             82     89 92       101    108111        122  
	PASY            CLIENTE         UTILIZADO       VULCANIZAC CAVIDAD INSERTO METAL  PEDIDO    ENTREGA  CLIENT    PEDIDA     PENDENTE
	999999999999999 999999999999999 999999999999999 9999999999 9999999 99999999999999 999999 99 99999999 999999 99 9999999999 9999999999
	0               16              32              48         59      67      75     82     89 92       101    108111        122
	*/
ElseIF nOrdem = 3
    dbOrderNickName("INDSC61")
	dbSeek(xFilial("SC6")+mv_par05 + MV_PAR07+ MV_PAR03,.T.)
	
	cCond1 := "SC6->C6_CLI >= mv_par05 .And. SC6->C6_CLI <= mv_par06 .And. SC6->C6_LOJA >= MV_PAR07 .AND. SC6->C6_LOJA <= MV_PAR08"
	cCond2 := "SC6->C6_CLI+SC6->C6_LOJA = cCli"	                                           
	_cCond3:= "SC6->C6_PRODUTO = cProduto"	
	titulo := titulo + " - Por Cliente"
	cabec1 := "CODIGO LJ NUMERO IT PRODUTO         PRODUTO         MATERIAL        MOLDE DE   QTDE DE PRE FORMADO    DATA     QUANTIDADE QUANTIDADE"
	cabec2 := "CLIENT    PEDIDO    PASY            CLIENTE         UTILIZADO       VULCANIZAC CAVIDAD INSERTO METAL  ENTREGA  PEDIDA     PENDENTE  "
	/*                                                                                        14
	CODIGO LJ NUMERO IT PRODUTO         PRODUTO         MATERIAL        MOLDE DE   QTDE DE PRE FORMADO    DATA     QUANTIDADE QUANTIDADE
	999999 99 999999 99 999999999999999 999999999999999 999999999999999 9999999999 9999999 99999999999999 99999999 9999999999 9999999999
	0      7  10     17 20              36              52              68         79      87             102      111        122
	CLIENT    PEDIDO    PASY            CLIENTE         UTILIZADO       VULCANIZAC CAVIDAD INSERTO METAL  ENTREGA  PEDIDA     PENDENTE
	999999 99 999999 99 999999999999999 999999999999999 999999999999999 9999999999 9999999 99999999999999 99999999 9999999999 9999999999
	0      7  10     17 20              36              52              68         79      87             102      111        122         
	*/
Else
	IndRegua("SC6",cNomArq,"C6_FILIAL+DTOS(C6_ENTREG)+C6_NUM+C6_ITEM",,,"Selecionando Registros...")
	
	dbSeek(xFilial("SC6")+DTOS(mv_par09),.T.)
	
	cCond1 := "Dtos(SC6->C6_ENTREG) >= Dtos(mv_par09) .And. Dtos(SC6->C6_ENTREG) <= Dtos(mv_par10)"
	cCond2 := "SC6->C6_ENTREG = dEntreg"
	_cCond3:= "SC6->C6_ENTREG = dEntreg"	
	titulo := titulo + " - Por Data de Entrega"
	cabec1 := "DATA     CODIGO LJ NUMERO IT PRODUTO         PRODUTO         MATERIAL        MOLDE DE   QTDE DE PRE FORMADO    QUANTIDADE QUANTIDADE"
	cabec2 := "ENTREGA  CLIENT    PEDIDO    PASY            CLIENTE         UTILIZADO       VULCANIZAC CAVIDAD INSERTO METAL      PEDIDA   PENDENTE"
	/*
DATA     CODIGO LJ NUMERO IT PRODUTO         PRODUTO         MATERIAL        MOLDE DE   QTDE DE PRE FORMADO    QUANTIDADE QUANTIDADE
99999999 999999 99 999999 99 999999999999999 999999999999999 999999999999999 9999999999 9999999 99999999999999 9999999999 9999999999
0        9      16 19     26 29              45              61              77         88      96             111        122
ENTREGA  CLIENT    PEDIDO    PASY            CLIENTE         UTILIZADO       VULCANIZAC CAVIDAD INSERTO METAL      PEDIDA PENDENTE
99999999 999999 99 999999 99 999999999999999 999999999999999 999999999999999 9999999999 9999999 99999999999999 9999999999 9999999999
0        9      16 19     26 29              45              61              77    83   88      96             111        122
	*/
EndIF

dbSelectArea("SC6")

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
	
	_lProx := .T.
	While !Eof() .And. xFilial("SC6") = SC6->C6_FILIAL .And. &cCond2
		
		IF nOrdem == 1
			cNum     := SC6->C6_NUM    
			cProduto := SC6->C6_PRODUTO
			_lProx := .T.			
		ElseIF nOrdem = 2
			cProduto := SC6->C6_PRODUTO
		ElseIF nOrdem = 3
//			cCli     := SC6->C6_CLI+SC6->C6_LOJA 
			cProduto := SC6->C6_PRODUTO
			_lProx := .T.			
		Else
			dEntreg  := SC6->C6_ENTREG
		EndIF
		
		While !Eof() .And. &cCond2 .And. &_cCond3		
		
			IncRegua()
		
			IF lEnd
				@Prow()+1,001 Psay "CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se esta dentro dos parametros                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
			IF SC6->C6_NUM            < mv_par01 .OR. SC6->C6_NUM     > mv_par02 .OR. ;
				SC6->C6_PRODUTO       < mv_par03 .OR. SC6->C6_PRODUTO > mv_par04 .OR. ;
				SC6->C6_CLI           < mv_par05 .OR. SC6->C6_CLI     > mv_par06 .OR. ;
				SC6->C6_LOJA          < mv_par07 .OR. SC6->C6_LOJA    > mv_par08 .OR. ;
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
			
			_lProx := .F.
			
			dbSelectArea("SC6")
			dbSkip()
		EndDo
		
		If nOrdem == 3 .And. !_lProx
			@li,  10 Psay Replicate("-",limite-7)		
			Li++
		Endif		
		
	EndDo
	                  	
	If nSaldo > 0 .Or. lImpTot
		If nOrdem == 2 .And. nCont > 1
			@Li,000 Psay "TOTAL ---->"
			@Li,111 Psay nTotVen PICTURE PesqPictQt("C6_QTDVEN",10)
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
	dbSelectArea("SC6")
EndDo

If li != 80
	Roda(cbcont,cbtxt)
Endif

dbSelectArea("SC6")
RetIndex("SC6")

If nOrdem == 4
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


dbSelectArea("SC5")
dbSetOrder(1)
dbSeek( xFilial("SC5")+SC6->C6_NUM )

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek( xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA )

dbSelectArea("SC6")
IF nOrdem = 1
	li++
	@li,  0 Psay  SC6->C6_NUM
	@li, 07 Psay  SC6->C6_CLI
	@li, 14 Psay  SC6->C6_LOJA
ElseIF nOrdem = 2
	@li,  0 Psay  SC6->C6_PRODUTO
	dbSelectArea("SC6")
ElseIF nOrdem = 3
	li++
	@li,  0 Psay SC6->C6_CLI
	@li,  7 Psay SC6->C6_LOJA
Else
	li++
	If cNumPed+cNumCli+DtoS(dData) != SC6->C6_NUM + SC6->C6_CLI + SC6->C6_LOJA + DtoS(SC6->C6_ENTREG)
		@li,  0 Psay SC6->C6_ENTREG
		@li, 09 Psay SC6->C6_CLI
		@li, 16 Psay SC6->C6_LOJA
		@li, 19 Psay SC6->C6_NUM
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
dbSeek( xFilial("SC5")+SC6->C6_NUM )
dbSelectArea(cAliasAnt)

_nLiMU := Li
_nLiMV := Li
_nLiPF := Li
_nLISvo:= Li

If _lProx
	VerEstrut()
Endif

dbSelectArea("SC6")

_nCont2 := 0
IF nOrdem = 1

	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF

	@li, 17 Psay SC6->C6_ITEM
	@li, 20 Psay SC6->C6_PRODUTO
	@li, 35 Psay SC6->C6_CPROCLI
	
	_lPrim := .T.
	dbSelectArea("TRB")
	If dbSeek(SC6->C6_NUM+SC6->C6_ITEM+SC6->C6_PRODUTO)
		
		_cChavtrb := TRB->PEDIDO + TRB->ITEM  + TRB->PRODUTO
		
		While !Eof().And.	_cChavtrb == TRB->PEDIDO + TRB->ITEM  + TRB->PRODUTO
			
			If li > 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			Endif

			_nCont2++
			@LI, 051 Psay TRB->PRODUTIL
			@LI, 067 Psay TRB->PRODVUL
			@LI, 078 Psay TRB->QTDCAV   
			@LI, 086 Psay Substr(TRB->PRODINS,1,14)
			If _lPrim
				@li,102 Psay SC6->C6_ENTREG
				@li,111 Psay SC6->C6_QTDVEN     		PICTURE TM(SC6->C6_QTDVEN,10)
				@Li,122 Psay nSaldo  	    			PICTURE TM(nSaldo,10)
				_lPrim := .F.
			Endif
			
			Li++
			dbSelectArea("TRB")
			dbSkip()
		EndDo
		
		If _nCont2 > 1
			@li,  17 Psay Replicate("-",limite-17)
			Li++
		Endif
	Else
		@li,102 Psay SC6->C6_ENTREG
		@li,111 Psay SC6->C6_QTDVEN     PICTURE TM(SC6->C6_QTDVEN,10)
		@Li,122 Psay nSaldo  	    	PICTURE TM(nSaldo,10)
		Li++
	Endif
ElseIF nOrdem = 2
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF

	@li, 16 Psay  SC6->C6_CPROCLI
	
	_lPrim := .T.
	
	dbSelectArea("TRB")
	If dbSeek(SC6->C6_NUM+SC6->C6_ITEM+SC6->C6_PRODUTO)
		
		_cChavtrb := TRB->PEDIDO + TRB->ITEM  + TRB->PRODUTO
		
		While !Eof() .And.	_cChavtrb == TRB->PEDIDO + TRB->ITEM  + TRB->PRODUTO
			     
			IF li > 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			EndIF
		
			_nCont2++	
			@LI, 032 Psay TRB->PRODUTIL
			@LI, 048 Psay TRB->PRODVUL
			@LI, 059 Psay TRB->QTDCAV 
			@LI, 067 Psay Substr(TRB->PRODINS,1,14)
			If _lPrim
				@li, 82 Psay SC6->C6_NUM
				@li, 89 Psay SC6->C6_ITEM
				@li, 92 Psay SC6->C6_ENTREG
				@li,101 Psay SC6->C6_CLI
				@li,108 Psay SC6->C6_LOJA			
				@li,111 Psay SC6->C6_QTDVEN     PICTURE TM(SC6->C6_QTDVEN,10)
				@li,122 Psay nSaldo	            PICTURE TM(nSaldo,10)
				_lPrim := .F.
			Endif
			
			Li++
			dbSelectArea("TRB")
			dbSkip()
		EndDo
	Else
		@li, 82 Psay SC6->C6_NUM
		@li, 89 Psay SC6->C6_ITEM
		@li, 92 Psay SC6->C6_ENTREG
		@li,101 Psay SC6->C6_CLI
		@li,108 Psay SC6->C6_LOJA			
		@li,111 Psay SC6->C6_QTDVEN     PICTURE TM(SC6->C6_QTDVEN,10)
		@li,122 Psay nSaldo	            PICTURE TM(nSaldo,10)
		Li++
	Endif
ElseIF nOrdem = 3
	@li, 10 Psay SC6->C6_NUM
	@li, 17 Psay SC6->C6_ITEM
	@li, 20 Psay SC6->C6_PRODUTO
	@li, 36 Psay SC6->C6_CPROCLI
	
	_lPrim := .T.
	dbSelectArea("TRB")
	If dbSeek(SC6->C6_NUM+SC6->C6_ITEM+SC6->C6_PRODUTO)
		
		_cChavtrb := TRB->PEDIDO + TRB->ITEM  + TRB->PRODUTO
		
		While !Eof() .And.	_cChavtrb == TRB->PEDIDO + TRB->ITEM  + TRB->PRODUTO
	
			If li > 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			Endif
			
			_nCont2++
			@LI, 052 Psay TRB->PRODUTIL
			@LI, 068 Psay TRB->PRODVUL
			@LI, 079 Psay TRB->QTDCAV 
			@LI, 087 Psay Substr(TRB->PRODINS,1,14)
			If _lPrim
				@li,102 Psay SC6->C6_ENTREG
				@li,111 Psay SC6->C6_QTDVEN      		PICTURE TM(SC6->C6_QTDVEN,10)
				@li,122 Psay nSaldo              		PICTURE TM(nSaldo,10)
				_lPrim := .F.
			Endif
			
			Li++
			dbSelectArea("TRB")
			dbSkip()
		EndDo
//		If _nCont2 > 1
//			@li,  7 Psay Replicate("-",limite-7)		
//			Li++
//		Endif		
	Else
		@li,102 Psay SC6->C6_ENTREG
		@li,111 Psay SC6->C6_QTDVEN      PICTURE TM(SC6->C6_QTDVEN,10)
		@li,122 Psay nSaldo              PICTURE TM(nSaldo,10)
		Li++		
	Endif
Else
	@li, 26  Psay SC6->C6_ITEM
	@li, 29  Psay SC6->C6_PRODUTO
	@li, 45  Psay SC6->C6_CPROCLI
	
	_lPrim := .T.
	dbSelectArea("TRB")
	If dbSeek(SC6->C6_NUM+SC6->C6_ITEM+SC6->C6_PRODUTO)
		
		_cChavtrb := TRB->PEDIDO + TRB->ITEM  + TRB->PRODUTO
		
		While !Eof() .And.	_cChavtrb == TRB->PEDIDO + TRB->ITEM  + TRB->PRODUTO

			If li > 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			Endif
			
			_nCont2++
			@LI, 061 Psay TRB->PRODUTIL
			@LI, 077 Psay TRB->PRODVUL             
			@LI, 088 Psay TRB->QTDCAV 
			@LI, 096 Psay Substr(TRB->PRODINS,1,14)
			
			If _lPrim
				@li, 111 Psay SC6->C6_QTDVEN 	PICTURE TM(SC6->C6_QTDVEN,10)
				@li, 122 Psay nSaldo	        PICTURE TM(nSaldo,10)
				_lPrim := .F.
			Endif
			
			Li++
			dbSelectArea("TRB")
			dbSkip()
		EndDo        
		If _nCont2 > 1
			@li, 32 Psay Replicate("-",limite-32)		
			Li++
		Endif		
	Else
		@li, 111 Psay SC6->C6_QTDVEN 	PICTURE TM(SC6->C6_QTDVEN,10)
		@li, 122 Psay nSaldo	        PICTURE TM(nSaldo,10)
		Li++		
	Endif	
EndIF

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
		
		If SB1->B1_GRUPO $ "PIC /MPVZ/MPC /MPL "   // Material Utilizado
			dbSelectArea("TRB")
			If !dbseek(SC6->C6_NUM+SC6->C6_ITEM + SC6->C6_PRODUTO)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PEDIDO   := SC6->C6_NUM
				TRB->ITEM     := SC6->C6_ITEM
				TRB->TIPO     := "A"
				TRB->PRODUTO  := SC6->C6_PRODUTO
				TRB->PRODUTIL := SG1->G1_COMP
				MsUnlock()
			Else
				_cChavTRB := TRB->PEDIDO + TRB->ITEM + TRB->PRODUTO
				While !Eof() .And. _cChavTRB == TRB->PEDIDO + TRB->ITEM + TRB->PRODUTO .And. !Empty(TRB->PRODUTIL)
					dbSelectArea("TRB")
					dbSkip()
				EndDo
				
				If _cChavTRB != TRB->PEDIDO + TRB->ITEM + TRB->PRODUTO
					dbSelectArea("TRB")
					RecLock("TRB",.T.)
					TRB->PEDIDO   := SC6->C6_NUM
					TRB->ITEM     := SC6->C6_ITEM
					TRB->TIPO     := "A"
					TRB->PRODUTO  := SC6->C6_PRODUTO
					TRB->PRODUTIL := SG1->G1_COMP
					MsUnlock()
				Else
					dbSelectArea("TRB")
					RecLock("TRB",.F.)
					TRB->PRODUTIL := SG1->G1_COMP
					MsUnlock()
				Endif
			Endif
		ElseIf SB1->B1_GRUPO $ "FRVC/FRVI/FRVT"   // Molde de Vulcanização / Ferramenta
			dbSelectArea("TRB")
			If !dbseek(SC6->C6_NUM+SC6->C6_ITEM + SC6->C6_PRODUTO)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PEDIDO  := SC6->C6_NUM
				TRB->ITEM    := SC6->C6_ITEM
				TRB->TIPO    := "B"
				TRB->PRODUTO := SC6->C6_PRODUTO
				TRB->QTDCAV  := SB1->B1_CAV
				TRB->PRODVUL := SG1->G1_COMP
				MsUnlock()
			Else
				_cChavTRB := TRB->PEDIDO + TRB->ITEM + TRB->PRODUTO
				
				While !Eof() .And. _cChavTRB == TRB->PEDIDO + TRB->ITEM + TRB->PRODUTO .And. !Empty(TRB->PRODVUL)
					dbSelectArea("TRB")
					dbSkip()
				EndDo
				
				If _cChavTRB != TRB->PEDIDO + TRB->ITEM + TRB->PRODUTO
					dbSelectArea("TRB")
					RecLock("TRB",.T.)
					TRB->PEDIDO   := SC6->C6_NUM
					TRB->ITEM     := SC6->C6_ITEM
					TRB->TIPO     := "B"
					TRB->PRODUTO  := SC6->C6_PRODUTO
					TRB->PRODVUL  := SG1->G1_COMP
					TRB->QTDCAV   := SB1->B1_CAV
					MsUnlock()
				Else
					dbSelectArea("TRB")
					RecLock("TRB",.F.)
					TRB->PRODVUL  := SG1->G1_COMP
					TRB->QTDCAV   := SB1->B1_CAV	
					MsUnlock()
				Endif
			Endif
		ElseIf SB1->B1_GRUPO $  "MPIM/PIPM"   // PRE FORMADO / INSERTO  METALICO
			dbSelectArea("TRB")
			If !dbseek(SC6->C6_NUM + SC6->C6_ITEM + SC6->C6_PRODUTO)
				dbSelectArea("TRB") 
				RecLock("TRB",.T.)
				TRB->PEDIDO  := SC6->C6_NUM
				TRB->ITEM    := SC6->C6_ITEM
				TRB->TIPO    := "C"
				TRB->PRODUTO := SC6->C6_PRODUTO
				TRB->PRODINS := SG1->G1_COMP
				MsUnlock()
			Else
				_cChavTRB := TRB->PEDIDO + TRB->ITEM + TRB->PRODUTO
				
				While !Eof() .And. _cChavTRB == TRB->PEDIDO + TRB->ITEM + TRB->PRODUTO .And. !Empty(TRB->PRODINS)
					dbSelectArea("TRB")
					dbSkip()
				EndDo
				
				If _cChavTRB != TRB->PEDIDO + TRB->ITEM + TRB->PRODUTO
					dbSelectArea("TRB")
					RecLock("TRB",.T.)
					TRB->PEDIDO   := SC6->C6_NUM
					TRB->ITEM     := SC6->C6_ITEM
					TRB->TIPO     := "C"
					TRB->PRODUTO  := SC6->C6_PRODUTO
					TRB->PRODINS  := SG1->G1_COMP
					MsUnlock()
				Else
					dbSelectArea("TRB")
					RecLock("TRB",.F.)
					TRB->PRODINS  := SG1->G1_COMP
					MsUnlock()
				Endif
			Endif
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