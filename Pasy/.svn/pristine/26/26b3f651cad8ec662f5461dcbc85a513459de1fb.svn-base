#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0129   ³ Autor ³ Alexandro da Silva    ³ Data ³ 14.05.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Pedidos nao entregues                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ-±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0129()

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
PRIVATE nomeprog := "PA0129"
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

wnrel := "PA0129"
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

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
_bAcao01   := {|_lFim| PA129A(@_lFim) }
_cTitulo01 := 'Processando'

RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

dbSelectArea("QC6")
dbCloseArea()


dbSelectArea("TRB")
dbCloseArea()

Return

Static Function PA129A(_lSair)

titulo :=OemToAnsi("Relacao de Pedidos nao entregues")
cDesc1 :=OemToAnsi("Este programa ira emitir a relacao dos Pedidos Pendentes,")
cDesc2 :=OemToAnsi("imprimindo o numero do Pedido, Cliente, Data da Entrega, ")
cDesc3 :=OemToAnsi("Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso.")
tamanho:=" "
limite :=132
Private nOrdem,nTotVen:=0,nTotEnt:=0,nTotSal:=0
Private lContinua := .T.
Private nFirst, nSaldo:=nCont:=0, lImpTot := .F.

cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1

nTipo  := IIF(aReturn[4]==1,15,18)
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
_cPed := "("
For Ax:= 1 To Len(MV_PAR21)
	If Substr(MV_PAR21,AX,1) != "*"
//		If AX == 1		
		If _cPed == "("
		   _cPed += "'"+Substr(MV_PAR21,AX,1)
		Else
   		   _cPed += "','"+Substr(MV_PAR21,AX,1)
  		Endif
    Endif
Next AX         
            
_cPed += "')"              

_cQ := " SELECT * FROM "+RetSqlName("SC6")+" C6 INNER JOIN "+RetSqlName("SB1")+" B1 ON C6_PRODUTO=B1_COD "
_cQ += " INNER JOIN "+RetSqlName("SF4")+" F4 ON C6_TES=F4_CODIGO "
_cQ += " INNER JOIN "+RetSqlName("SA1")+" A1 ON C6_CLI+C6_LOJA=A1_COD+A1_LOJA "
_cQ += " WHERE A1.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' AND C6.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' "
_cQ += " AND C6_NUM BETWEEN '"+MV_PAR01+"'    AND '"+MV_PAR02+"' AND C6_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_cQ += " AND C6_CLI BETWEEN '"+MV_PAR05+"'    AND '"+MV_PAR06+"' AND C6_LOJA    BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
_cQ += " AND C6_ENTREG BETWEEN '"+DTOS(MV_PAR09)+"' AND '"+DTOS(MV_PAR10)+"' AND B1_GRUPO   BETWEEN '"+MV_PAR17+"' AND '"+MV_PAR18+"' "
_cQ += " AND B1_SUBGR  BETWEEN '"+MV_PAR19+"' AND '"+MV_PAR20+"' "
/*
If MV_PAR21 == 1
	_cQ += " AND C6_PEDAMOS = 'N' "
ElseIf MV_PAR21 == 2
	_cQ += " AND C6_PEDAMOS = 'A' "
ElseIf MV_PAR21 == 3
	_cQ += " AND C6_PEDAMOS = 'Z' "
ElseIf MV_PAR21 == 4
	_cQ += " AND C6_PEDAMOS = 'D' "
Endif
*/
_cQ += " AND C6_PEDAMOS IN "+_cPed+" "

If MV_PAR11 == 1   // Só em Aberto
	_cQ += " AND C6_QTDVEN > C6_QTDENT "
Endif

If MV_PAR12 == 1
	_cQ += " AND F4_DUPLIC = 'S' "
Elseif MV_PAR12 == 2
	_cQ += " AND F4_DUPLIC <> 'S' "
Endif

If MV_PAR16 == 2
	_cQ += " AND C6_BLQ <> 'R' "
Endif

IF nOrdem = 1
	_cQ    += " ORDER BY C6_NUM,C6_ITEM,C6_PRODUTO "
	cCond2 := "QC6->C6_NUM = cNum"
	_cCond3:= "QC6->C6_PRODUTO = cProduto"
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
	_cQ    += " ORDER BY C6_PRODUTO,C6_NUM,C6_ITEM"
	cCond2 := "QC6->C6_PRODUTO = cProduto"
	_cCond3:= "QC6->C6_PRODUTO = cProduto"
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
	_cQ    += " ORDER BY C6_CLI,C6_LOJA,C6_PRODUTO,C6_CPROCLI,C6_ENTREG"
	titulo := titulo + " - Por Cliente"
	cCond2 := "QC6->C6_CLI+QC6->C6_LOJA = cCli"
	_cCond3:= "QC6->C6_PRODUTO = cProduto"
	
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
	_cQ += " ORDER BY C6_ENTREG,C6_NUM,C6_ITEM "
	titulo := titulo + " - Por Data de Entrega"
	cCond2 := "QC6->C6_ENTREG = dEntreg"
	_cCond3:= "QC6->C6_ENTREG = dEntreg"
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
                  
TCQUERY _cQ NEW ALIAS "QC6"

TCSETFIELD("QC6","C6_ENTREG","D")

cFilterUser:=aReturn[7]
Set Softseek Off

dbSelectArea("QC6")

SetRegua(U_CONTREG())

While !Eof() .And. !_lSair
	
	IF _lSair
		@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	
	nFirst := 0
	
	IF nOrdem == 1
		cNum     := QC6->C6_NUM
	ElseIF nOrdem = 2
		cProduto := QC6->C6_PRODUTO
	ElseIF nOrdem = 3
		cCli     := QC6->C6_CLI+QC6->C6_LOJA
	Else
		dEntreg  := QC6->C6_ENTREG
	EndIF
	
	_lProx := .T.
	While !Eof() .And. !_lSair .And. &cCond2
		
		IF nOrdem == 1
			cNum     := QC6->C6_NUM
			cProduto := QC6->C6_PRODUTO
			_lProx := .T.
		ElseIF nOrdem = 2
			cProduto := QC6->C6_PRODUTO
		ElseIF nOrdem = 3
			cProduto := QC6->C6_PRODUTO
			_lProx := .T.
		Else
			dEntreg  := QC6->C6_ENTREG
		EndIF
		
		While !Eof() .And. !_lSair .And. &cCond2 .And. &_cCond3
			
			IncRegua()
			
			IF _lSair
				@Prow()+1,001 Psay "CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
			Endif
			
			If !Empty(cFilterUser) .and. !(&cFilterUser)
				dbSelectArea("QC6")
				dbSkip()
				Loop
			Endif

			dbSelectArea("SC5")
			dbSetOrder(1)
			dbSeek( xFilial("SC6")+QC6->C6_NUM )
			
			If At(SC5->C5_TIPO,"DB") != 0
				dbSelectArea("QC6")
				dbSkip()
				Loop
			EndIf
			
			dbSelectArea("QC6")
			IF Alltrim(QC6->C6_BLQ) == "R" .and. mv_par15 == 2				// Se Foi Eliminado Residuos
				nSaldo := 0
			Else
				nSaldo  := QC6->C6_QTDVEN-QC6->C6_QTDENT
			Endif
			nTotSal += nSaldo
			nTotVen += QC6->C6_QTDVEN
			nTotEnt += QC6->C6_QTDENT
			
			If nTotVen > QC6->C6_QTDVEN .Or. nTotEnt > QC6->C6_QTDENT
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
			
			dbSelectArea("QC6")
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
	dbSelectArea("QC6")
EndDo

If li != 80
	Roda(cbcont,cbtxt)
Endif

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
dbSeek( xFilial("SC5")+QC6->C6_NUM )

dbSelectArea("QC6")
IF nOrdem = 1
	li++
	@li,  0 Psay  QC6->C6_NUM
	@li, 07 Psay  QC6->C6_CLI
	@li, 14 Psay  QC6->C6_LOJA
ElseIF nOrdem = 2
	@li,  0 Psay  QC6->C6_PRODUTO
	dbSelectArea("QC6")
ElseIF nOrdem = 3
	li++
	@li,  0 Psay QC6->C6_CLI
	@li,  7 Psay QC6->C6_LOJA
Else
	li++
	If cNumPed+cNumCli+DtoS(dData) != QC6->C6_NUM + QC6->C6_CLI + QC6->C6_LOJA + DtoS(QC6->C6_ENTREG)
		@li,  0 Psay QC6->C6_ENTREG
		@li, 09 Psay QC6->C6_CLI
		@li, 16 Psay QC6->C6_LOJA
		@li, 19 Psay QC6->C6_NUM
		cNumPed := QC6->C6_NUM
		cNumCli := QC6->C6_CLI+QC6->C6_LOJA
	Else
		li--
	EndIf
	dData := QC6->C6_ENTREG
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
dbSeek( xFilial("SC5")+QC6->C6_NUM )
dbSelectArea(cAliasAnt)

_nLiMU := Li
_nLiMV := Li
_nLiPF := Li
_nLISvo:= Li

If _lProx
	VerEstrut()
Endif

dbSelectArea("QC6")

_nCont2 := 0
IF nOrdem = 1
	
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	
	@li, 17 Psay QC6->C6_ITEM
	@li, 20 Psay QC6->C6_PRODUTO
	@li, 35 Psay QC6->C6_CPROCLI
	
	_lPrim := .T.
	dbSelectArea("TRB")
	If dbSeek(QC6->C6_NUM+QC6->C6_ITEM+QC6->C6_PRODUTO)
		
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
				@li,102 Psay QC6->C6_ENTREG
				@li,111 Psay QC6->C6_QTDVEN     		PICTURE TM(SC6->C6_QTDVEN,10)
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
		@li,102 Psay QC6->C6_ENTREG
		@li,111 Psay QC6->C6_QTDVEN     PICTURE TM(SC6->C6_QTDVEN,10)
		@Li,122 Psay nSaldo  	    	PICTURE TM(nSaldo,10)
		Li++
	Endif
ElseIF nOrdem = 2
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	
	@li, 16 Psay  QC6->C6_CPROCLI
	
	_lPrim := .T.
	
	dbSelectArea("TRB")
	If dbSeek(QC6->C6_NUM+QC6->C6_ITEM+QC6->C6_PRODUTO)
		
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
				@li, 82 Psay QC6->C6_NUM
				@li, 89 Psay QC6->C6_ITEM
				@li, 92 Psay QC6->C6_ENTREG
				@li,101 Psay QC6->C6_CLI
				@li,108 Psay QC6->C6_LOJA
				@li,111 Psay QC6->C6_QTDVEN     PICTURE TM(SC6->C6_QTDVEN,10)
				@li,122 Psay nSaldo	            PICTURE TM(nSaldo,10)
				_lPrim := .F.
			Endif
			
			Li++
			dbSelectArea("TRB")
			dbSkip()
		EndDo
	Else
		@li, 82 Psay QC6->C6_NUM
		@li, 89 Psay QC6->C6_ITEM
		@li, 92 Psay QC6->C6_ENTREG
		@li,101 Psay QC6->C6_CLI
		@li,108 Psay QC6->C6_LOJA
		@li,111 Psay QC6->C6_QTDVEN     PICTURE TM(SC6->C6_QTDVEN,10)
		@li,122 Psay nSaldo	            PICTURE TM(nSaldo,10)
		Li++
	Endif
ElseIF nOrdem = 3
	@li, 10 Psay QC6->C6_NUM
	@li, 17 Psay QC6->C6_ITEM
	@li, 20 Psay QC6->C6_PRODUTO
	@li, 36 Psay QC6->C6_CPROCLI
	
	_lPrim := .T.
	dbSelectArea("TRB")
	If dbSeek(QC6->C6_NUM+QC6->C6_ITEM+QC6->C6_PRODUTO)
		
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
				@li,102 Psay QC6->C6_ENTREG
				@li,111 Psay QC6->C6_QTDVEN      		PICTURE TM(SC6->C6_QTDVEN,10)
				@li,122 Psay nSaldo              		PICTURE TM(nSaldo,10)
				_lPrim := .F.
			Endif
			
			Li++
			dbSelectArea("TRB")
			dbSkip()
		EndDo
	Else
		@li,102 Psay QC6->C6_ENTREG
		@li,111 Psay QC6->C6_QTDVEN      PICTURE TM(SC6->C6_QTDVEN,10)
		@li,122 Psay nSaldo              PICTURE TM(nSaldo,10)
		Li++
	Endif
Else
	@li, 26  Psay QC6->C6_ITEM
	@li, 29  Psay QC6->C6_PRODUTO
	@li, 45  Psay QC6->C6_CPROCLI
	
	_lPrim := .T.
	dbSelectArea("TRB")
	If dbSeek(QC6->C6_NUM+QC6->C6_ITEM+QC6->C6_PRODUTO)
		
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
				@li, 111 Psay QC6->C6_QTDVEN 	PICTURE TM(SC6->C6_QTDVEN,10)
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
		@li, 111 Psay QC6->C6_QTDVEN 	PICTURE TM(SC6->C6_QTDVEN,10)
		@li, 122 Psay nSaldo	        PICTURE TM(nSaldo,10)
		Li++
	Endif
EndIF

Return .T.


Static Function VerEstrut()

dbSelectArea("SG1")
dbSetOrder(1)
If dbSeek(xFilial("SG1")+QC6->C6_PRODUTO)
	
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
			If !dbseek(QC6->C6_NUM+QC6->C6_ITEM + QC6->C6_PRODUTO)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PEDIDO   := QC6->C6_NUM
				TRB->ITEM     := QC6->C6_ITEM
				TRB->TIPO     := "A"
				TRB->PRODUTO  := QC6->C6_PRODUTO
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
					TRB->PEDIDO   := QC6->C6_NUM
					TRB->ITEM     := QC6->C6_ITEM
					TRB->TIPO     := "A"
					TRB->PRODUTO  := QC6->C6_PRODUTO
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
			If !dbseek(QC6->C6_NUM+QC6->C6_ITEM + QC6->C6_PRODUTO)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PEDIDO  := QC6->C6_NUM
				TRB->ITEM    := QC6->C6_ITEM
				TRB->TIPO    := "B"
				TRB->PRODUTO := QC6->C6_PRODUTO
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
					TRB->PEDIDO   := QC6->C6_NUM
					TRB->ITEM     := QC6->C6_ITEM
					TRB->TIPO     := "B"
					TRB->PRODUTO  := QC6->C6_PRODUTO
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
			If !dbseek(QC6->C6_NUM + QC6->C6_ITEM + QC6->C6_PRODUTO)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PEDIDO  := QC6->C6_NUM
				TRB->ITEM    := QC6->C6_ITEM
				TRB->TIPO    := "C"
				TRB->PRODUTO := QC6->C6_PRODUTO
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
					TRB->PEDIDO   := QC6->C6_NUM
					TRB->ITEM     := QC6->C6_ITEM
					TRB->TIPO     := "C"
					TRB->PRODUTO  := QC6->C6_PRODUTO
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