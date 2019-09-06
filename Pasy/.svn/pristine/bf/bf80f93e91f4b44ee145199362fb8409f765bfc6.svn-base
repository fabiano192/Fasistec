#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"

/*
Programa PA0215
Autor 		: Fabiano da Silva	-	17/08/10
Uso 		: SIGAFAT - FAT
Descrição 	: Pedidos não Entregues c/ Estoque
*/

USER FUNCTION PA0215()

LOCAL oDlg := NIL

PRIVATE cTitulo    	:= "Pedidos não Entregues"
PRIVATE oPrn       	:= NIL
PRIVATE oFont1     	:= NIL
PRIVATE oFont2     	:= NIL
PRIVATE oFont3     	:= NIL
PRIVATE oFont4     	:= NIL
PRIVATE oFont5     	:= NIL
PRIVATE oFont6     	:= NIL
PRIVATE _nCont     	:= 0
Private nTotVen:=0,nTotEnt:=0,nTotSal:=0,_nLinha:=0,_nEstoq:=0,_nCount := 0
Private lContinua := .T.
Private nFirst, nSaldo := nCont:=0, lImpTot := .F.
Private _cProduto := _cProd := ""

DEFINE FONT oFont1 NAME "Arial" SIZE 0,08 OF oPrn BOLD
DEFINE FONT oFont2 NAME "Arial" SIZE 0,13 OF oPrn BOLD
DEFINE FONT oFont3 NAME "Arial" SIZE 0,14 OF oPrn BOLD
DEFINE FONT oFont4 NAME "Arial" SIZE 0,08 OF oPrn
DEFINE FONT oFont5 NAME "Arial" SIZE 0,10 OF oPrn BOLD
DEFINE FONT oFont6 NAME "Courier New" BOLD

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

@ 004,010 TO 060,157 LABEL "" OF oDlg PIXEL

@ 010,017 SAY "Esta rotina tem por objetivo gerar o Relatório" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 020,017 SAY "de Pedidos não entreguesconforme os parâmetros" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 030,017 SAY "informados pelo usuário.                      " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 050,017 SAY "Programa PA0215.PRW                           " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED

@ 70,020 BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("PA0009"))	OF oDlg PIXEL
@ 70,090 BUTTON "OK" 		 SIZE 036,012 ACTION (PA215A(),oDlg:End()) 	OF oDlg PIXEL
@ 70,160 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)


Static Function PA215A()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA215B(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return(Nil)


Static Function PA215B(_lSair)

Pergunte("PA0009",.F.)

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

_cQ    += " ORDER BY C6_PRODUTO,C6_NUM,C6_ITEM"
cCond2 := "QC6->C6_PRODUTO = cProduto"
_cCond3:= "QC6->C6_PRODUTO = cProduto"

TCQUERY _cQ NEW ALIAS "QC6"

TCSETFIELD("QC6","C6_ENTREG","D")

oPrn 	:= TMSPrinter():New(cTitulo)
oPrn:SetPortrait()

_nLin  	:= 3000
_lEnt  	:= .F.
_nCon   := 0
_cQuebra:= _cQueb1 := ""

dbSelectArea("QC6")
ProcRegua(LastRec())

While !Eof() .And. !_lSair
	
	IF _lSair
		@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	
	If _nLin > 2900
		If _lEnt
			oPrn:EndPage()
		Endif
		oPrn:StartPage()
		Cabec(_nCont)
		_nLin    := 285
	Endif
	
	nFirst := 0
	
	cProduto := QC6->C6_PRODUTO
		
	_lProx := .T.
	While !Eof() .And. !_lSair .And. &cCond2
		
		cProduto := QC6->C6_PRODUTO
		While !Eof() .And. !_lSair .And. &cCond2 .And. &_cCond3
			
			IncProc()
			
			IF _lSair
				@Prow()+1,001 Psay "CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
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
			
			If _nLin > 2900
				If _lEnt
					oPrn:EndPage()
				Endif
				oPrn:StartPage()
				Cabec(_nCont)
				_nLin    := 285
				nFirst := 1
			Endif
			
			IF nFirst = 0
				PrintCab()
				nFirst := 1
			Endif
			
			PrintLinha(nSaldo)
			nCont++
			
			_lProx := .F.
			
			dbSelectArea("QC6")
			dbSkip()
		EndDo
		
	EndDo
	
	If _nLin > 2900
		If _lEnt
			oPrn:EndPage()
		Endif
		oPrn:StartPage()
		Cabec(_nCont)
		_nLin    := 285
	Endif
	
	If cProduto = '001356'
		_lPare := .T.
	Endif		
	
	If nSaldo > 0 .Or. lImpTot
		If (_nLin < _nLinha) .And.( _nLin <> 285)
			_nLin := _nLinha
		Endif	

		If nCont > 1 .Or. _nCount > 1
			
			oPrn:Say(_nLin,0090, "TOTAL ---->"	,oFont1)
			oPrn:Say(_nLin,1490, TRANS(nTotVen,"@E 9,999,999.99")	,oFont1)
			oPrn:Say(_nLin,1650, TRANS(nTotSal,"@E 9,999,999.99")	,oFont1)
			oPrn:Say(_nLin,1840, TRANS(_nEstoq,"@E 9,999,999.99")	,oFont1)
			
			_nLin += 40
		Endif
		
		If nTotVen > 0
			oPrn:Line(_nLin,0080,_nLin,2250)
			_nLin += 40
		EndIf
	Else
		If nTotVen > 0
			oPrn:Line(_nLin,0080,_nLin,2250)
			_nLin += 40
		EndIf
	Endif
	
	nTotVen := 0
	nTotEnt := 0
	nTotSal := 0
	nCont   := 0
	_nEstoq := 0
	_nCount := 0
	lImpTot := .F.
	
	dbSelectArea("QC6")
EndDo

Ms_Flush()
oPrn:EndPage()
oPrn:End()

oPrn:Preview()

TRB->(dbClosearea())
QC6->(dbClosearea())

Return



Static Function PrintCab()

dbSelectArea("SC5")
dbSetOrder(1)
dbSeek( xFilial("SC5")+QC6->C6_NUM )

dbSelectArea("QC6")

oPrn:Say(_nLin,0090, QC6->C6_PRODUTO	,oFont4)
oPrn:Say(_nLin,0230, QC6->C6_CPROCLI	,oFont4)

dbSelectArea("QC6")

Return .t.



Static Function PrintLinha(nSaldo)

LOCAL cAliasAnt:=Alias()

dbSelectArea("SC5")
dbSetOrder(1)
dbSeek( xFilial("SC5")+QC6->C6_NUM )
dbSelectArea(cAliasAnt)

If _lProx
	VerEstrut()
Endif

dbSelectArea("QC6")

_nCont2 := 0

If _nLin > 2900
	If _lEnt
		oPrn:EndPage()
	Endif
	oPrn:StartPage()
	Cabec(_nCont)
	_nLin    := 285
Endif

_lPrim := .T.

dbSelectArea("TRB")
If dbSeek(QC6->C6_NUM+QC6->C6_ITEM+QC6->C6_PRODUTO)
	
	_cChavtrb := TRB->PEDIDO + TRB->ITEM  + TRB->PRODUTO
	
	While !Eof() .And.	_cChavtrb == TRB->PEDIDO + TRB->ITEM  + TRB->PRODUTO
		
		If _nLin > 2900
			If _lEnt
				oPrn:EndPage()
			Endif
			oPrn:StartPage()
			Cabec(_nCont)
			_nLin    := 285
		Endif
		
		_nCont2++
		oPrn:Say(_nLin,0400, TRB->PRODUTIL				,oFont4)
		oPrn:Say(_nLin,0530, TRB->PRODVUL				,oFont4)
		oPrn:Say(_nLin,0670, TRB->QTDCAV				,oFont4)
		oPrn:Say(_nLin,0770, Substr(TRB->PRODINS,1,14)	,oFont4)
		
		If _lPrim
			oPrn:Say(_nLin,0920, QC6->C6_NUM	,oFont4)
			oPrn:Say(_nLin,1070, QC6->C6_ITEM	,oFont4)
			oPrn:Say(_nLin,1140, DTOC(QC6->C6_ENTREG)	,oFont4)
			oPrn:Say(_nLin,1270, QC6->C6_CLI	,oFont4)
			oPrn:Say(_nLin,1430, QC6->C6_LOJA	,oFont4)
			oPrn:Say(_nLin,1490, TRANS(QC6->C6_QTDVEN,"@E 9,999,999.99")	,oFont4)
			oPrn:Say(_nLin,1650, TRANS(nSaldo,"@E 9,999,999.99")	,oFont4)
			
			_lPrim := .F.
		Endif
		
		VerEstoque(TRB->PRODUTO)
		
		_nLin += 40
		
		_lEnt := .T.
		_nCon ++
		
		dbSelectArea("TRB")
		dbSkip()
	EndDo
Else
	
	_lEnt := .T.
	
	oPrn:Say(_nLin,0920, QC6->C6_NUM	,oFont4)
	oPrn:Say(_nLin,1070, QC6->C6_ITEM	,oFont4)
	oPrn:Say(_nLin,1140, DTOC(QC6->C6_ENTREG)	,oFont4)
	oPrn:Say(_nLin,1270, QC6->C6_CLI	,oFont4)
	oPrn:Say(_nLin,1430, QC6->C6_LOJA	,oFont4)
	oPrn:Say(_nLin,1490, TRANS(QC6->C6_QTDVEN,"@E 9,999,999.99")	,oFont4)
	oPrn:Say(_nLin,1650, TRANS(nSaldo,"@E 9,999,999.99")	,oFont4)
	
	VerEstoque(TRB->PRODUTO)
	
	_nLin += 40
	
Endif

Return .T.


Static Function VerEstoque(_cProd)

_nLinha := _nLin

If _cProduto != _cProd
	SBF->(dbOrderNickName("INDSBF1"))
	If SBF->(dbseek(xFilial("SBF")+_cProd+"99"))
		
		_cChav  := SBF->BF_PRODUTO
		_nCount := 0
		_nEstoq := 0
		
		While SBF->(!EOF()) .And. _cChav == SBF->BF_PRODUTO
			
			oPrn:Say(_nLinha,1840, TRANS(SBF->BF_QUANT,"@E 9,999,999.99")	,oFont4)
			oPrn:Say(_nLinha,2020, SBF->BF_LOCALIZ	,oFont4)

			_nEstoq += SBF->BF_QUANT
			_nLinha += 40
			_nCount ++

			SBF->(dbSkip())
		EndDo
		If _nCount > 1
			lImpTot := .T.
		Endif
	Endif
Endif

_cProduto := _cProd

Return



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


STATIC FUNCTION Cabec() //Cabeçalho

oPen	:= TPen():New(10,100,CLR_HRED,oPrn)

Define brush oBr color CLR_HRED

oPrn:SayBitmap(0095,0090,"lgrl01.bmp",0250,0070)

oPrn:Box(0080,0080,3000,2250, oPen)

oPrn:Line(0180,0080,0180,2250)
oPrn:Line(0190,0080,0190,2250)

oPrn:Say(0105,0820,cTitulo,oFont3,,CLR_BLUE)
oPrn:Say(0090,2080,dtoc(dDataBase),oFont5)
oPrn:Say(0130,2080,Time(),oFont5)

oPrn:Say(0196,0090,"PROD.",oFont1)
oPrn:Say(0235,0090,"PASY",oFont1)
oPrn:Line(0190,0220,2950,0220) //Vertical
oPrn:Say(0196,0230,"PROD.",oFont1)
oPrn:Say(0235,0230,"CLIENTE",oFont1)
oPrn:Line(0190,0390,2950,0390) //Vertical
oPrn:Say(0196,0400,"MAT.",oFont1)
oPrn:Line(0190,0520,2950,0520) //Vertical
oPrn:Say(0196,0530,"MOLDE",oFont1)
oPrn:Line(0190,0660,2950,0660) //Vertical
oPrn:Say(0196,0670,"QTDE.",oFont1)
oPrn:Say(0235,0670,"CAV.",oFont1)
oPrn:Line(0190,0760,2950,0760) //Vertical
oPrn:Say(0196,0770,"PRÉ-FOR.",oFont1)
oPrn:Say(0235,0770,"INSERTO",oFont1)
oPrn:Line(0190,0910,2950,0910) //Vertical
oPrn:Say(0196,0920,"PEDIDO",oFont1)
oPrn:Line(0190,1060,2950,1060) //Vertical
oPrn:Say(0196,1070,"IT",oFont1)
oPrn:Line(0190,1130,2950,1130) //Vertical
oPrn:Say(0196,1140,"DATA",oFont1)
oPrn:Say(0235,1140,"ENTR.",oFont1)
oPrn:Line(0190,1260,2950,1260) //Vertical
oPrn:Say(0196,1270,"CODIGO",oFont1)
oPrn:Say(0235,1270,"CLIENTE",oFont1)
oPrn:Line(0190,1420,2950,1420) //Vertical
oPrn:Say(0196,1430,"LJ",oFont1)
oPrn:Line(0190,1480,2950,1480) //Vertical
oPrn:Say(0196,1510,"QTDE.",oFont1)
oPrn:Say(0235,1510,"PEDIDA",oFont1)
oPrn:Line(0190,1655,2950,1655) //Vertical
oPrn:Say(0196,1680,"QTDE.",oFont1)
oPrn:Say(0235,1680,"SALDO",oFont1)
oPrn:Line(0190,1840,2950,1840) //Vertical
oPrn:Say(0196,1860,"QTDE",oFont1)
oPrn:Say(0235,1860,"ESTOQUE",oFont1)
oPrn:Line(0190,2010,2950,2010) //Vertical
oPrn:Say(0196,2020,"LOCALIZAÇÃO",oFont1)

oPrn:Line(0275,0080,0275,2250)

_nCont ++

//Rodapé
oPrn:Line(2950,0080,2950,2250)
oPrn:Say(2955,0090,"PA0215.PRW",oFont5)
oPrn:Say(2955,2050,"Página "+STRZERO(_nCont,3),oFont5)

Return()
