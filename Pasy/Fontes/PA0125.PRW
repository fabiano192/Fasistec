#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � PA0125   � Autor � Alexandro da Silva    � Data � 22.01.02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Pedidos nao entregues                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Sigafat                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
/*/

User Function PA0125()

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������

CbTxt  := ""
titulo := "Relacao de Pedidos nao entregues"
cDesc1 := "Este programa ira emitir a relacao dos Pedidos Pendentes,"
cDesc2 := "imprimindo o numero do Pedido, Cliente, Data da Entrega, "
cDesc3 := "Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso."
tamanho:= "M"
limite := 132
cString:= "SC6"

Private CbCont,cabec1,cabec2,wnrel 
PRIVATE aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
PRIVATE nomeprog := "PA0125"
PRIVATE aLinha   := { },nLastKey := 0
PRIVATE cPerg    := "PA0125"
PRIVATE cNumPed  := cNumCli := "", dData:=CtoD("  /  /  ")
PRIVATE cMascara := GetMv("MV_MASCGRD")
PRIVATE nTamRef  := Val(Substr(cMascara,1,2))
Private cCond2,_cArq,cArqLog

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������

pergunte("PA0125",.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01            // Do Pedido                             �
//� mv_par02            // Ate o Pedido                          �
//� mv_par03            // Do Produto                            �
//� mv_par04            // Ate o Produto                         �
//� mv_par05            // Do Cliente                            �
//� mv_par06            // Ate o cliente                         �
//  mv_par07            // Loja     De                           �
//  mv_par08            // Loja     Ate                          �
//� mv_par09            // Da entrega de entrega                 �
//� mv_par10            // Ate a data de entrega                 �
//� mv_par11            // Situacao do Pedido                    �
//� mv_par12            // C/ Geracao Duplicata                  �
//� mv_par13            // Grupo De                              �
//� mv_par14            // Grupo Ate                             �
//� mv_par15            // SubGrupo De                           �
//� mv_par16            // SubGrupo Ate                          �
//� mv_par17            // Quais Pedidos                         �
//����������������������������������������������������������������

wnrel:="PA0125"
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

nOrdem := aReturn[8]
Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim|PA0125A(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

IF nOrdem = 1
	RptStatus({|lEnd| ImpOrd_1(@lEnd,wnRel,cString)},Titulo)
Else
	RptStatus({|lEnd| ImpRel(@lEnd,wnRel,cString)},Titulo)
Endif

dbselectArea("TMP")
dbCloseArea()

Ferase(_cArq+".DBF")    // Elimina arquivos de Trabalho
Ferase(_cArq+OrdBagExt())	  // Elimina arquivos de Trabalho

Ferase(cArqLog+".DBF")    // Elimina arquivos de Trabalho
Ferase(cArqLog+OrdBagExt())	  // Elimina arquivos de Trabalho


Return


Static Function PA0125A(_lEnd)

aStru    := {}
AADD(aStru,{"PRODUTO"   , "C" , 15, 0 })
AADD(aStru,{"DESCRIC"   , "C" , 30, 0 })

cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "PRODUTO"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

aStr2 := {}
AADD(aStr2,{"PEDIDO"   , "C" , 06, 0 })
AADD(aStr2,{"ITEM"     , "C" , 02, 0 })
AADD(aStr2,{"DTEMIS"   , "D" , 08, 0 })
AADD(aStr2,{"DTENT"    , "D" , 08, 0 })
AADD(aStr2,{"CLIENTE"  , "C" , 06, 0 })
AADD(aStr2,{"LOJA"     , "C" , 02, 0 })
AADD(aStr2,{"NOME"     , "C" , 07, 0 })
AADD(aStr2,{"PRODUTO"  , "C" , 15, 0 })
AADD(aStr2,{"PRODCLI"  , "C" , 15, 0 })
AADD(aStr2,{"PEDCLI"   , "C" , 10, 0 })
AADD(aStr2,{"DESTIPO"  , "C" , 13, 0 })
AADD(aStr2,{"QTDVEN"   , "N" , 14, 2 })
AADD(aStr2,{"QTDENT"   , "N" , 14, 2 })
AADD(aStr2,{"QTDSDO"   , "N" , 14, 2 })

_cArq := CriaTrab(aStr2,.T.)
dbUseArea(.T.,,_cArq,"TMP",.F.,.F.)

IF nOrdem = 1
	cCond2 := "TMP->PEDIDO = cNum"
	_cInd  := "PEDIDO+PRODUTO"
ElseIf nOrdem = 2
	cCond2 := "TMP->PRODUTO = cProduto"
	_cInd  := "PRODUTO+PEDIDO+ITEM"
ElseIf nOrdem = 3
	cCond2 := "TMP->CLIENTE + TMP->LOJA = cCli"
	_cInd  := "CLIENTE+LOJA+PEDIDO+ITEM+PRODUTO"
Else
	cCond2 := "TMP->DTENT = dEntreg"
	_cInd  := "DTOS(DTENT)+PRODUTO+PEDIDO+ITEM"
Endif

dbSelectArea("TMP")
IndRegua("TMP",_cArq,_cInd,,,"Criando Trabalho...")

_cPed := "("
For Ax:= 1 To Len(MV_PAR17)
	If Substr(MV_PAR17,AX,1) != "*"
		If _cPed == "("
			_cPed += "'"+Substr(MV_PAR17,AX,1)
		Else
			_cPed += "','"+Substr(MV_PAR17,AX,1)
		Endif
	Endif
Next AX

_cPed += "')"

_cQ   := " SELECT C6_PEDAMOS,C6_NUM,C6_ITEM,C5_EMISSAO,C6_ENTREG,C6_CLI,C6_LOJA,A1_NOME,C6_QTDVEN,C6_QTDENT, "
_cQ   += " C6_PRODUTO,C6_CPROCLI,C6_PEDCLI FROM "+RetSqlName("SC6")+" C6 "
_cQ   += " INNER JOIN "+RetSqlName("SA1")+" A1 ON A1_COD+A1_LOJA=C6_CLI+C6_LOJA "
_cQ   += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD=C6_PRODUTO "
_cQ   += " INNER JOIN "+RetSqlName("SF4")+" F4 ON C6_TES=F4_CODIGO "
_cQ   += " INNER JOIN "+RetSqlName("SC5")+" C5 ON C6_NUM=C5_NUM    "
_cQ   += " WHERE A1.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' AND C5.D_E_L_E_T_ = '' AND C6.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' "
_cQ   += " AND C6_NUM     BETWEEN '"+MV_PAR01+"'       AND '"+MV_PAR02+"' "
_cQ   += " AND C6_PRODUTO BETWEEN '"+MV_PAR03+"'       AND '"+MV_PAR04+"' "
_cQ   += " AND C6_CLI     BETWEEN '"+MV_PAR05+"'       AND '"+MV_PAR06+"' "
_cQ   += " AND C6_LOJA    BETWEEN '"+MV_PAR07+"'       AND '"+MV_PAR08+"' "
_cQ   += " AND C6_ENTREG  BETWEEN '"+DTOS(MV_PAR09)+"' AND '"+DTOS(MV_PAR10)+"' "
_cQ   += " AND B1_GRUPO   BETWEEN '"+MV_PAR13+"'       AND '"+MV_PAR14+"' "
_cQ   += " AND B1_SUBGR   BETWEEN '"+MV_PAR15+"'       AND '"+MV_PAR16+"' "
_cQ   += " AND C6_DESCRI  BETWEEN '"+MV_PAR18+"'       AND '"+MV_PAR19+"' "
_cQ   += " AND C6_PEDAMOS IN "+_cPed+" "
_cQ   += " AND C6_BLQ = '' AND C5_TIPO NOT IN ('B','D') "
If MV_PAR11 == 1
	_cQ += " AND C6_QTDVEN > C6_QTDENT "
Endif
If MV_PAR12 == 1
	_cQ += " AND F4_DUPLIC  = 'S' "
ElseIf MV_PAR12 == 2
	_cQ += " AND F4_DUPLIC <> 'S' "
Endif
If !Empty(aReturn[7])
	_cQ += " AND "+U_FILUSER(aReturn[7])
Endif

_cQ += " ORDER BY C6_NUM,C6_ENTREG"

TCQUERY _cQ NEW ALIAS "ZC6"

TCSETFIELD("ZC6","C5_EMISSAO","D")
TCSETFIELD("ZC6","C6_ENTREG","D")

ZC6->(dbGotop())

ProcRegua(ZC6->(U_CONTREG()))

While ZC6->(!Eof()) .And. !_lEnd
	
	IncProc()
	
	IF lEnd
		@Prow()+1,001 Psay "CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	Endif
	
	If ZC6->C6_PEDAMOS == "N"
		_cDesTipo := "NORMAL"
	ElseIf ZC6->C6_PEDAMOS == "A"
		_cDesTipo := "AMOSTRA"
	ElseIf ZC6->C6_PEDAMOS == "D"
		_cDesTipo := "DESPES.ACESS."
	ElseIf ZC6->C6_PEDAMOS == "M"
		_cDesTipo := "AQUIS.MATER."
	ElseIf ZC6->C6_PEDAMOS == "Z"
		_cDesTipo := "PREVISAO"
	ElseIf ZC6->C6_PEDAMOS == "I"
		_cDesTipo := "INDUSTRIALIZ."
	Endif
	
	_nSaldo  := ZC6->C6_QTDVEN-ZC6->C6_QTDENT
	_cNome   := ZC6->A1_NOME
	
	TMP->(RecLock("TMP",.T.))
	TMP->PEDIDO   := ZC6->C6_NUM
	TMP->ITEM     := ZC6->C6_ITEM
	TMP->DTEMIS   := ZC6->C5_EMISSAO
	TMP->DTENT    := ZC6->C6_ENTREG
	TMP->CLIENTE  := ZC6->C6_CLI
	TMP->LOJA     := ZC6->C6_LOJA
	TMP->NOME     := _cNome
	TMP->PRODUTO  := ZC6->C6_PRODUTO
	TMP->PRODCLI  := ZC6->C6_CPROCLI
	TMP->PEDCLI   := ZC6->C6_PEDCLI 
	TMP->DESTIPO  := _cDestipo
	TMP->QTDVEN   := ZC6->C6_QTDVEN
	TMP->QTDENT   := ZC6->C6_QTDENT
	TMP->QTDSDO   := _nSaldo
	TMP->(MsUnlock() )
	
	ZC6->(dbSkip())
EndDo

ZC6->(dbCloseArea())

Return


Static Function ImpRel(lEnd,WnRel,cString)

LOCAL CbTxt
LOCAL titulo :=OemToAnsi("Relacao de Pedidos nao entregues")
LOCAL cDesc1 :=OemToAnsi("Este programa ira emitir a relacao dos Pedidos Pendentes,")
LOCAL cDesc2 :=OemToAnsi("imprimindo o numero do Pedido, Cliente, Data da Entrega, ")
LOCAL cDesc3 :=OemToAnsi("Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso.")
LOCAL CbCont,cabec1,cabec2
LOCAL tamanho:=" "
LOCAL limite :=132
LOCAL nTotVen:=0,nTotEnt:=0,nTotSal:=0
LOCAL lContinua := .T.
LOCAL nFirst, nSaldo:=nCont:=0, lImpTot := .F.

cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1
nTipo    := IIF(aReturn[4]==1,15,18)
nOrdem   := aReturn[8]

IF nOrdem = 2
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
Endif

TMP->(dbGotop())

SetRegua(TMP->(U_CONTREG()))

While TMP->(!Eof() )
	
	IF lEnd
		@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IncRegua()
	
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	
	nFirst := 0
	
	IF nOrdem = 2
		cProduto := TMP->PRODUTO
	ElseIF nOrdem = 3
		cCli     := TMP->CLIENTE + TMP->LOJA
	Else
		dEntreg  := TMP->DTENT
	EndIF
	
	While !Eof() .And. &cCond2
		
		IncRegua()
		
		IF lEnd
			@Prow()+1,001 Psay "CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		Endif
		
		nTotSal += TMP->QTDSDO
		nTotVen += TMP->QTDVEN
		nTotEnt += TMP->QTDENT
		
		If nTotVen > TMP->QTDVEN .Or. nTotEnt > TMP->QTDENT
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
		
		dbSelectarea("TMP")
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


Static Function ImpOrd_1(lEnd,WnRel,cString)

cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1
nTipo    := IIF(aReturn[4]==1,15,18)
nOrdem   := aReturn[8]

titulo := titulo +" - Por Pedido"
cabec1 := "NUMERO IT DATA     CODIGO LJ NOME    PRODUTO         PRODUTO         TIPO DE  PEDIDO DO   DATA     QUANT.     QUANT.     QUANT."
cabec2 := "PEDIDO    EMISSAO  CLIENT    CLIENTE PASY            CLIENTE         PEDIDO   CLIENTE     ENTREGA  PEDIDA     ENTREGUE   PENDENTE"

/*
NUMERO IT DATA     CODIGO LJ NOME    PRODUTO         PRODUTO         TIPO DE  PEDIDO DO   DATA     QUANT.     QUANT.     QUANT.
999999 99 99999999 999999 99 9999999 999999999999999 999999999999999 9999999  99999999999 999999999999999999999999999999999999999999
0      7  10       19     26 29      37              53              69       78          90       99         110        121       132

PEDIDO    EMISSAO  CLIENT    CLIENTE PASY            CLIENTE         PEDIDO   CLIENTE     ENTREGA  PEDIDA     ENTREGUE   PENDENTE
99999999999999999999999999999999999999999999999999999999999999999999999999999 99999999999 999999999999999999999999999999999999999999
0      7        16        26         37              53              69       78          90       99         110        121       132                     132
*/

TMP->(dbGotop())

SetRegua(TMP->(U_CONTREG()))

While TMP->(!Eof() ) .And. !lEnd
		
	_cNum   := TMP->PEDIDO
	
	While TMP->(!Eof()) .And. _cNum  == TMP->PEDIDO
		
		SB1->(dbSetOrder(1))
		SB1->(dbSeek( xFilial("SB1") + TMP->PRODUTO ))
		
		If SB1->B1_TIPO == "PA"
			SG1->(dbSetOrder(1))
			If SG1->(!dbseek(xFilial("SG1")+ TMP->PRODUTO))
				If TRB->(!dbSeek(TMP->PRODUTO))
					TRB->(RecLock("TRB",.T.))
					TRB->PRODUTO := TMP->PRODUTO
					TRB->DESCRIC := SB1->B1_DESC
					TRB->(MsUnlock())
				Endif
			Endif
		Endif
		
		nTotSal := nTotVen := nTotEnt := 0
		_cChav  := TMP->PEDIDO + TMP->PRODUTO
		
		While TMP->(!Eof()) .And. _cChav == TMP->PEDIDO + TMP->PRODUTO
			
			IncRegua()
			
			IF lEnd
				@Prow()+1,001 Psay "CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
			Endif
			
			IF li > 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
				nFirst := 0
			EndIF
			
			@li,000 Psay TMP->PEDIDO
			@li,007 Psay TMP->ITEM
			@li,010 Psay TMP->DTEMIS
			@li,019 Psay TMP->CLIENTE
			@li,026 Psay TMP->LOJA
			@li,029 Psay TMP->NOME
			@li,037 Psay TMP->PRODUTO
			@li,053 Psay TMP->PRODCLI
			@li,069 Psay Substr(TMP->DESTIPO,1,7)
			@li,078 Psay TMP->PEDCLI 
			@li,090 Psay TMP->DTENT  	PICTURE "@D"
			@li,099 Psay TMP->QTDVEN  	PICTURE PesqPictQt("C6_QTDVEN",10)
			@li,110 Psay TMP->QTDENT	PICTURE PesqPictQt("C6_QTDENT",10)
			@li,121 Psay TMP->QTDSDO  	PICTURE PesqPictQt("C6_QTDVEN",10)
			
			nTotSal += TMP->QTDSDO
			nTotVen += TMP->QTDVEN
			nTotEnt += TMP->QTDENT
			
			li++
			
			TMP->(dbSkip())
		EndDo
		
		@Li,000 Psay "TOTAL ---->"
		@Li,100 Psay nTotVen PICTURE PesqPictQt("C6_QTDVEN",10)
		@Li,110 Psay nTotEnt PICTURE PesqPictQt("C6_QTDENT",10)
		@Li,121 Psay nTotSal PICTURE PesqPictQt("C6_QTDVEN",10)
		
		Li++
		@li,  0 Psay Replicate("-",limite)
		li++
	EndDo
EndDo

If li != 80
	Roda(cbcont,cbtxt)
Endif

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
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � PrintCab  � Autor � Claudinei M. Benzi    � Data � 05.09.91 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao da linha unica, dependendo da ordem escolhida     ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

Static Function PrintCab(nOrdem)

li++
dbSelectArea("TMP")

IF nOrdem = 2
	@li,  0 Psay  TMP->PRODUTO
ElseIF nOrdem = 3
	@li,  0 Psay  TMP->CLIENTE
	@li,  7 Psay  TMP->LOJA
	@li, 10 Psay  TMP->NOME
Else
	If cNumPed+cNumCli+DtoS(dData) != TMP->PEDIDO+TMP->CLIENTE+TMP->LOJA+DTOS(TMP->DTENT)
		@li,  0 Psay TMP->DTENT
		@li, 09 Psay TMP->PEDIDO
		@li, 17 Psay TMP->DTEMIS
		@li, 25 Psay TMP->CLIENTE
		@li, 32 Psay TMP->LOJA
		@li, 35 Psay TMP->NOME
		cNumPed := TMP->PEDIDO
		cNumCli := TMP->CLIENTE+TMP->LOJA
	Else
		li--
	EndIf
	dData := TMP->DTENT
EndIF

Return .t.

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � PrintLinha� Autor � Claudinei M. Benzi    � Data � 05.09.91 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao da linha de detalhe, dependendo da ordem escolhida���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

Static Function PrintLinha(nOrdem,nSaldo)

LOCAL cAliasAnt:=Alias()

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek( xFilial("SB1") + TMP->PRODUTO )

If SB1->B1_TIPO == "PA"
	dbSelectArea("SG1")
	dbSetOrder(1)
	If !dbseek(xFilial("SG1")+ TMP->PRODUTO)
		dbSelectArea("TRB")
		If !dbSeek(TMP->PRODUTO)
			RecLock("TRB",.T.)
			TRB->PRODUTO := TMP->PRODUTO
			TRB->DESCRIC := SB1->B1_DESC
			MsUnlock()
		Endif
	Endif
Endif

IF nOrdem = 2
	@li, 16 Psay  TMP->PRODCLI
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial("SB1")+TMP->PRODUTO )
	@li, 32 Psay TMP->DESTIPO
	@li, 53 Psay TMP->PEDIDO
	@li, 61 Psay TMP->ITEM
	@li, 64 Psay TMP->DTEMIS
	@li, 73 Psay TMP->DTENT
	@li, 82 Psay TMP->CLIENTE
	@li, 89 Psay TMP->LOJA
	@li, 92 Psay TMP->NOME
	@li,100 Psay TMP->QTDVEN	 PICTURE PesqPictQt("C6_QTDVEN",10)
	@li,111 Psay TMP->QTDENT     PICTURE PesqPictQt("C6_QTDENT",10)
	@li,122 Psay TMP->QTDSDO     PICTURE PesqPictQt("C6_QTDVEN",10)
ElseIF nOrdem = 3
	@li, 20 Psay TMP->PEDIDO
	@li, 27 Psay TMP->ITEM
	@li, 31 Psay TMP->DTEMIS
	@li, 40 Psay TMP->PRODUTO
	@li, 56 Psay TMP->PRODCLI
	@li, 72 Psay TMP->DESTIPO
	@li,093 Psay TMP->DTENT         PICTURE "@D"
	@li,102 Psay TMP->QTDVEN    	PICTURE PesqPictQt("C6_QTDVEN",10)
	@li,112 Psay TMP->QTDENT    	PICTURE PesqPictQt("C6_QTDENT",10)
	@li,122 Psay TMP->QTDSDO        PICTURE PesqPictQt("C6_QTDVEN",10)
Else
	@li, 44  Psay TMP->ITEM
	@li, 47  Psay TMP->PRODUTO
	@li, 63  Psay TMP->PRODCLI
	@li, 79  Psay TMP->DESTIPO
	@li, 100 Psay TMP->QTDVEN 	PICTURE PesqPictQt("C6_QTDVEN",10)
	@li, 110 Psay TMP->QTDENT	PICTURE PesqPictQt("C6_QTDENT",10)
	@li, 122 Psay TMP->QTDSDO   PICTURE PesqPictQt("C6_QTDVEN",10)
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