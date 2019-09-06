#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0114   ³ Autor ³ Alexandro da Silva    ³ Data ³ 26.12.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descriçao ³ Relacao das Solicitacoes de Compras                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigacom                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/

User Function PA0114()


LOCAL wnrel
LOCAL cDesc1    := "Emite um relacao para controle das solicitacoes cadastradas ,"
LOCAL cDesc2    := "seus respectivos pedidos e prazos de entrega."
LOCAL cDesc3    := ""
LOCAL cString   := "SC1"
LOCAL aOrd      := {" Por Solicitacao    "," Por Produto        "}

PRIVATE Tamanho	:= "G"
PRIVATE Titulo	:= "Relacao de Solicitacoes de Compras"
PRIVATE NomeProg:= "PA0114"
PRIVATE aReturn	:= { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
PRIVATE nLastKey:= 0
PRIVATE cPerg 	:= "MTR100"
PRIVATE aInd	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//³mv_par01             // a partir do numero                    ³
//³mv_par02             // ate o numero                          ³
//³mv_par03             // Tudo, em Aberto ou Canc. pelo Sistema ³
//³mv_par04             // Data emissao inicial                  ³
//³mv_par05             // Data emissao final                    ³
//³mv_par06             // Mostra Pedido Compra p/ cotacoes      ³
//³mv_par07             // Impr. SC's Firmes, Previstas ou Ambas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| C100Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C100IMP  ³ Autor ³ Cristina M. Ogura     ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR100                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function C100Imp(lEnd,WnRel,cString)

LOCAL nCntImpr	:= 0
LOCAL nEntregue	:= 0
LOCAL nSldProd	:= 0
LOCAL nTotSC	:= 0
Local nIndex	:= 0
LOCAL nOrdem	:= aReturn[8]
LOCAL aSoma		:= {}
Local aIndex	:= {}
LOCAL Cabec1,Cabec2,nX,n
Local lQuery    := .F.
Local cQuery    := ""

Local cProduto	:= ''
Local cNumSol   := ''
li    := 80
m_pag := 1

Titulo := "RELACAO DE SOLICITACOES DE COMPRAS"	+Iif(MV_PAR06 == 1, " (Incluindo Pedidos de Compra)", " ")

//If MV_PAR06 == 1
//	Cabec1 := "NUMERO ITEM PRODUTO         D E S C R I C A O              TP GRUP   QUANTIDADE UM   CENTRO  EMISSAO  ENTREGA SOLICITANTE           DT.LIMITE          SALDO N.PED/ CODIGO LJ RAZAO SOCIAL                          DATA DE "
//	Cabec2 := "                                                                     SOLICITADA       CUSTO           DA S.C.                       DE COMPRA        DA S.C. N.COT. FORNEC                                          EMISSAO "
//Else                                                                                                                                                                                                                                     
	Cabec1 := "NUMERO ITEM PRODUTO         D E S C R I C A O              TP GRUP   QUANTIDADE UM CENTRO    EMISSAO  ENTREGA  SOLICITANTE   DT.LIMITE           SALDO  OBSERVACAO                                               "
	Cabec2 := ""//"                                                                     SOLICITADA       CUSTO           DA S.C.                       DE COMPRA        DA S.C.        FORNEC                                                  "
//Endif

/*
NUMERO ITEM PRODUTO         D E S C R I C A O              TP GRUP   QUANTIDADE UM CENTRO    EMISSAO  ENTREGA  SOLICITANTE   DT.LIMITE           SALDO  OBSERVACAO                                               
999999 9999 999999999999999 999999999999999999999999999999 99 9999 999999999999 99 999999999 99999999 99999999 999999999999  999999999   9999999999999  99999999999999999999999999999999999999999999999999999999 
0      7    12              28                             59 62   67           80 83        93       102      111           125         137            152
*/


If MV_PAR06 == 1
	
	ChkFile('SC7',.F.,'TMP')
	aADD(aIndex,CriaTrab(NIL,.F.))
	IndRegua("TMP",aIndex[Len(aIndex)],"C7_FILIAL+C7_NUMCOT+C7_PRODUTO")
	dbSelectArea("SC7")
	aADD(aIndex,CriaTrab(NIL,.F.))
	IndRegua("SC7",aIndex[Len(aIndex)],"C7_FILIAL+C7_NUMSC+C7_ITEMSC+C7_PRODUTO")
	nIndex := RetIndex("SC7")
	dbSetIndex(aIndex[2]+OrdbagExt())
	dbSetOrder(nIndex+1)
	
EndIf

dbSelectArea("SC1")
If nOrdem == 1
	dbSetOrder(1)
	dbSeek(xFilial("SC1")+MV_PAR01,.T.)
Else
	dbSetOrder(2)
	dbSeek(xFilial("SC1"))
EndIf
SetRegua(LastRec())

While !Eof() .And. IIf(nOrdem==1,C1_NUM <= MV_PAR02,.T.)
	If nOrdem == 2
		cValAnt		:= xFilial("SC1")+SC1->C1_PRODUTO
		cProduto    := SC1->C1_PRODUTO
		cQuebra		:= 'cValAnt==xFilial("SC1")+SC1->C1_PRODUTO'
	Else
		cValAnt		:= xFilial("SC1")+SC1->C1_NUM
		cNumSol     := SC1->C1_NUM
		cQuebra 	:= 'cValAnt==xFilial("SC1")+SC1->C1_NUM'
	EndIf
	
	While !Eof() .And. &(cQuebra)
		
		If lEnd
			@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
			Exit
		Endif
		
		IncRegua()
		
		If SC1->C1_NUM < mv_par01 .Or. C1_NUM > mv_par02
			dbSkip()
			Loop
		Endif
		
		If mv_par03 == 2 .And. (SC1->C1_QUANT <= SC1->C1_QUJE .Or. !Empty(SC1->C1_COTACAO))
			dbSkip()
			Loop
		Endif
		
		If (SC1->C1_EMISSAO < mv_par04 .Or. SC1->C1_EMISSAO > mv_par05)
			dbSkip()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra as solicitacoes nao entregue                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par03 == 4
			If !Empty(SC1->C1_COTACAO) .And. SC1->C1_COTACAO <> "XXXXXX"
				aSoma    := SomaSC7(1,SC1->C1_PRODUTO,SC1->C1_COTACAO)
				If Empty(aSoma[1])                              // Nao foi entregue nada
					nEntregue       := SC1->C1_QUANT
				Elseif aSoma[2] == SC1->C1_QUANT                        // 1 SC ---> n PC
					nEntregue       := aSoma[2] - aSoma[1]
				Else                                                    // n SC ---> n PC
					nEntregue       := (aSoma[1] / aSoma[2]) * SC1->C1_QUANT
				Endif
			Else
				aSoma     := SomaSC7(2,SC1->C1_PRODUTO,SC1->C1_NUM)
				nEntregue := SC1->C1_QUANT - aSoma[1]
			Endif
			
			dbSelectArea("SC1")
			
			If nEntregue <= 0
				dbSkip()
				Loop
			Endif
		Else
			nEntregue       := SC1->C1_QUANT
		Endif
		
		If !MtrAValOP(mv_par07, 'SC1')
			dbSkip()
			Loop
		EndIf
		
		If li > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,IIF(aReturn[4]==1,15,18))
		Endif
		
		nCntImpr++

/*
NUMERO ITEM PRODUTO         D E S C R I C A O              TP GRUP   QUANTIDADE UM CENTRO    EMISSAO  ENTREGA  SOLICITANTE   DT.LIMITE           SALDO  OBSERVACAO                                               
999999 9999 999999999999999 999999999999999999999999999999 99 9999 999999999999 99 999999999 99999999 99999999 999999999999  999999999   9999999999999  99999999999999999999999999999999999999999999999999999999 
0      7    12              28                             59 62   67           80 83        93       102      111           125         137            152
*/
		@ li,000 PSAY C1_NUM
		@ li,007 PSAY C1_ITEM
		@ li,012 PSAY C1_PRODUTO
		
		@ li,028 PSAY SubStr(C1_DESCRI,1,30)
		For nX := 31 To Len(Trim(C1_DESCRI)) Step 30
			li++
			@ li,028 PSAY SubStr(C1_DESCRI,nX,30)
		Next nX
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SC1->C1_PRODUTO)
		
		@ li,059 PSAY B1_TIPO
		@ li,062 PSAY B1_GRUPO
		
		dbSelectArea("SC1")
		@ li,067 PSAY C1_QUANT          Picture PesqPictQt("C1_QUANT",12)
		@ li,080 PSAY C1_UM
		@ li,083 PSAY C1_CC
		@ li,093 PSAY C1_EMISSAO        Picture PesqPict("SC1","C1_EMISSAO")
		@ li,102 PSAY C1_DATPRF         Picture PesqPict("SC1","C1_DATPRF")
		@ li,111 PSAY Substr(C1_SOLICIT,1,12)
		@ li,125 PSAY SC1->C1_DATPRF - CalcPrazo(SC1->C1_PRODUTO,SC1->C1_QUANT)
		@ li,137 PSAY SC1->C1_QUANT-SC1->C1_QUJE  Picture PesqPictQt("C1_QUANT",13)
		@ li,152 PSAY SC1->C1_OBS            		
		
		nSldProd += ( C1_QUANT - C1_QUJE )
		nTotSc   += C1_QUANT
		
		li++

		dbSelectArea("SC1")
		dbSkip()
	EndDo
	If nOrdem == 2 .And. nTotSC > 0
		li++
		@li, 00 PSay "Total  -  " + Rtrim(cProduto) + " ----> "
		@li, 67 PSay nTotSC   Picture PesqPictQt("C1_QUANT",12)
		@li,137 PSay nSldProd Picture PesqPictQt("C1_QUANT",13)
		li++
		@li, 00 PSay __PrtThinLine()
		nTotSc   := 0
		nSldProd := 0
		li++
	ElseIf nOrdem == 1 .And. nTotSC > 0
		li++
		@li, 00 PSay "Total  -  " + Rtrim(cNumSol) + " ----> "
		@li, 67 PSay nTotSC   Picture PesqPictQt("C1_QUANT",12)
		@li,137 PSay nSldProd Picture PesqPictQt("C1_QUANT",13)
		li++
		@li, 00 PSay __PrtThinLine()
		nTotSc   := 0
		nSldProd := 0
		li++
	EndIf
EndDo
//
//If MV_PAR03 == 3
//	SET DELE ON
//EndIf

dbSelectArea("SC7")
RetIndex("SC7")
dbSelectArea("SC1")
Set Filter To
RetIndex("SC1")
dbSetOrder(1)
If ( Select("TMP")<>0 )
	dbSelectArea("TMP")
	dbCloseArea()
	dbSelectArea("SC7")
EndIf

For nI:=1 to Len(aIndex)
	If File(aIndex[nI]+OrdBagExt())
		Ferase(aIndex[nI]+OrdBagExt())
	Endif
Next


Set Device to Screen

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function SomaSC7(nPar,cProd,cNum)

LOCAL aArea		:= GetArea()
LOCAL aAreaSC7	:= SC7->(GetArea())
LOCAL aSoma		:= Array(2)

Afill(aSoma,0)
dbSelectArea("SC7")
dbSetOrder(2)
dbSeek(cFilial+cProd)
While !Eof() .And. cFilial+cProd == C7_FILIAL+C7_PRODUTO
	If nPar == 1
		If C7_NUMCOT <> cNum
			dbSkip()
			Loop
		Endif
	Else
		If C7_NUMSC <> cNum
			dbSkip()
			Loop
		Endif
	Endif
	aSoma[1]  +=C7_QUJE
	aSoma[2]  +=C7_QUANT
	dbSkip()
End

RestArea(aAreaSC7)
RestArea(aArea)

Return (aSoma)
