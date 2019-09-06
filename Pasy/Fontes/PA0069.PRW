#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PA0069     º Autor ³ Alexandro da Silvaº Data ³  01/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Consulta COMPRAS                                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0069()

Private _lAchou   := .F.
Private _nTam := 90
Private _cFimBloc , _cBrancBl
Private _nQtEstr := _nQtPc := _nQtSc := _nQtSaldo := 0

_nPosP    := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C1_PRODUTO" } )
_nPosQtde := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C1_QUANT" } )
_nPosStat := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C1_POSCOM" } )
_cStatus  := Acols[n][_nPosStat]

_cProduto := Acols[n][_nPosP]
_cCons    := Acols[n][_nPosStat]

Private _aCampos, _cNomArq, _cNomArq2

_aAliOri := GetArea()
_aAliSB1 := SB1->(GetArea())
_aAliSB2 := SB2->(GetArea())
_aAliSC1 := SC1->(GetArea())
_aAliSC5 := SC5->(GetArea())
_aAliSC6 := SC6->(GetArea())
_aAliSC7 := SC7->(GetArea())
_aAliSF4 := SF4->(GetArea())

If !Pergunte("PA0069",.T.)
	Return(_cStatus)
Endif

////////////////////////////////////////
/////// Grupo de Perguntas - PA0069 ////
//// MV_PAR01 : Data De  ?          ////
//// MV_PAR02 : Data Ate ?          ////
////                                ////
////////////////////////////////////////

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| RunProc1(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_bAcao01   := {|_lFim| AtuTmp("1","Pedido de Vendas",@_lFim) }
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_bAcao01   := {|_lFim| AtuTmp("2","Pedido de Compras",@_lFim) }
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_bAcao01   := {|_lFim| AtuTmp("3","Soliciticao de Compras",@_lFim) }
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

If _lAchou
	MontaBrow()
Else
	MsgBox("Nao Existe Informacoes Para Essa Consulta ","ERRO!!!","STOP")
Endif

Pergunte("MTA110",.F.)

dbSelectArea("TRB")
dbCloseArea("TRB")

FErase(_cNomArq+".DBF")

dbSelectArea("TRB2")
dbCloseArea("TRB2")

FErase(_cNomArq2+".DBF")

_cArqNew :="ESTPROD.DBF"

dbSelectArea("TMP")
Copy all to &_cArqNew

dbSelectArea("TMP")
dbCloseArea("TMP")

RestArea(_aAliSB1)
RestArea(_aAliSB2)
RestArea(_aAliSC1)
RestArea(_aAliSC5)
RestArea(_aAliSC6)
RestArea(_aAliSC7)
RestArea(_aAliSF4)
RestArea(_aAliOri)


Return(_cStatus)



Static Function RunProc1(_lFim)

_nTam := 90
_cFimBloc:= CHR(192)+Repli(CHR(196),(_nTam-2))+CHR(217)
_cBrancBl:= "³"+Repli(" ",(_nTam-2))+"³"

_aCampos := {}
AADD(_aCampos,{"LINHA","C",92,0 } )

_cNomArq := CriaTrab(_aCampos)
USE &_cNomArq Alias TRB ExClusive NEW VIA __LocalDriver

_aCampos := {}
AADD(_aCampos,{"LINHA","C",92,0 } )

_cNomArq2 := CriaTrab(_aCampos)
_cIndTrb  := "LINHA"
dbUseArea(.T.,,_cNomArq2,"TRB2",.F.,.F.)
dbSelectArea("TRB2")
IndRegua("TRB2",_cNomArq2,_cIndTrb,,,"Criando Trabalho...")

aStru := {}
AADD(aStru,{"PRODUTO"   , "C" , 15, 0 })
AADD(aStru,{"COMP"      , "C" , 15, 0 })
AADD(aStru,{"QTEST"     , "N" , 14, 6 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "COMP+PRODUTO"

dbUseArea(.T.,,_cArqTrb,"TMP",.F.,.F.)
dbSelectArea("TMP")
IndRegua("TMP",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

VerEst(_lFim)
VerPed(_lFim)
VerPC(_lFim)
VerSC(_lFim)

Return


Static Function VerEst(_lFim)


SB1->(dbSetOrder(1))
If SB1->(dbSeek(xFilial("SB1")+_cProduto))
	If SB1->B1_TIPO != "PA"
		dbSelectArea("SG1")
		dbSetOrder(2)
		If dbSeek(xFilial("SG1")+_cProduto)
			
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+_cProduto)
			
			_cProd   := SG1->G1_COMP
			nNivel   := 2
			_nNiv    := 0
			
			_nQtAnt  :=  1
			
			VerEst2(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
		Endif
	Else
		dbSelectArea("TMP")
		If !dbSeek(_cProduto + _cProduto)
			dbSelectArea("TMP")
			RecLock("TMP",.T.)
			TMP->PRODUTO := _cProduto
			TMP->COMP    := _cProduto
			TMP->QTEST   := 1
			MsUnlock()
		Endif
	Endif
Endif

Return


Static Function VerEst2(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev)

Local _nReg   := 0

_nQtPa   := 0
dbSelectArea("SG1")
dbSetOrder(2)
While !Eof() .And. !_lFim .And.  SG1->G1_COMP ==  _cProd
	
	_nReg := Recno()
	
	_nQtSG1 := ExplEstr(_nQtPai,,_cOpc,_cRev)
	dbSelectArea("SG1")
	
	If _nQtSG1 > 0
		
		_nNiv++
		
		dbSelectArea("SB1")
		_aAliSB1 := GetArea()
		dbSeek(xFilial("SB1")+SG1->G1_COD)
		
		If SB1->B1_TIPO == "PA"
			dbSelectArea("TMP")
			If !dbSeek(_cProduto + SG1->G1_COD)
				dbSelectArea("TMP")
				RecLock("TMP",.T.)
				TMP->PRODUTO := SG1->G1_COD
				TMP->COMP    := _cProduto
				TMP->QTEST   := _nQtSG1
				MsUnlock()
			Endif
		Endif
		
		dbSelectArea("SB1")
		RestArea(_aALiSB1)
		
		dbSelectArea("SG1")
		dbSetOrder(2)
		dbSeek(xFilial("SG1")+SG1->G1_COD)
		IF Found()
			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+SG1->G1_COD)
			VerEst2(SG1->G1_COMP,_nQtSG1,nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
		EndIf
		
		dbSelectArea("SG1")
		dbGoto(_nReg)
	Endif
	dbSkip()
EndDo

Return


Static Function VerPed(_lFim)

dbSelecTarea("TMP")
If dbSeek(_cProduto)
	
	_nSaldotot := 0
	_nQtEstr   := 0
	_cChavTrb  := TMP->COMP
	
	While !eof() .And. !_lFim .And. _cChavTrb == TMP->COMP
		
		dbSelectArea("SC6")
		dbOrderNickname("INDSC64")
		dbSeek(xFilial("SC6")+ TMP->PRODUTO + DTOS(MV_PAR01),.T. )
		
		_lAchou   := .T.
		_cChavSC6 :=  TMP->PRODUTO
		_nTot     := 0
		
		dbSelectArea("SC6")
		
		ProcRegua(LastRec())
		
		While !Eof() .And. !_lFim .And. _cChavSC6 ==  SC6->C6_PRODUTO .And.;
			SC6->C6_ENTREG >= MV_PAR01 .And. SC6->C6_ENTREG <= MV_PAR02
			
			IncProc("Selecionando os Pedidos em Aberto")
			
			If _lFim
				Alert("cancelado pelo Operador!!")
				Return
			EndIf
			
			If Alltrim(SC6->C6_PRODUTO) = "005066"
				_lParar := .T.
			Endif
			
			_dEmissao := CTOD("  /  /  ")
			dbSelectArea("SC5")
			dbSetOrder(1)
			If dbSeek(SC6->C6_FILIAL+SC6->C6_NUM)
				_dEmissao := SC5->C5_EMISSAO
			Endif
			
			If  (SC6->C6_QTDVEN == SC6->C6_QTDENT) .Or. Alltrim(SC6->C6_BLQ) == "R" .Or. SC6->C6_PEDAMOS == "D"
				dbSelectarea("SC6")
				dbSkip()
				Loop
			Endif
			
			dbSelectArea("SF4")
			dbSetOrder(1)
			If dbSeek(xFilial("SF4")+SC6->C6_TES)
				If SF4->F4_DUPLIC  != "S"
					dbSelectarea("SC6")
					dbSkip()
					Loop
				Endif
			Endif
			
			_nQtLiq     := SC6->C6_QTDVEN - SC6->C6_QTDENT
			_nQtEstLiq  := (_nQtLiq * TMP->QTEST)
			
			_nSaldoTot  += _nQtLiq
			_nQtEstr    += (_nQtLiq * TMP->QTEST)
			
			dbSelectArea("TRB2")
			RecLock("TRB2",.T.)
			TRB2->LINHA   := "1"+SC6->C6_NUM+Space(2)+SC6->C6_ITEM+Space(2)+SC6->C6_CLI+Space(2)+SC6->C6_LOJA+Space(2)+;
			DTOC(SC6->C6_ENTREG)+Space(2)+TRANSFORM(_nQtLiq,"@E 999,999.99")+Space(2)+;
			TRANSFORM(_nQtEstLiq,"@E 999,999.99")+Space(02)+SC6->C6_PEDAMOS
			MsUnlock()
			
			dbSelectArea("SC6")
			dbSkip()
		EndDo
		
		_nTot += (SC6->C6_QTDVEN - SC6->C6_QTDENT)
		dbSelectArea("TMP")
		dbSkip()
	EndDo
	
	_cString:= "Movimentos em Aberto: "
	PAGRAVA(CHR(218)+_cString+Repli(CHR(196),((_nTam-2)-Len(_cString)))+CHR(191),Alias())
	PAGRAVA("³"+Space((_nTam-2))+"³")
	
	_cString:= "Pedido de Venda.: "+TRANSFORM(_nSaldoTot,"@E 999,999,999.99")+" "
	PAGRAVA(CHR(218)+_cString+Repli(CHR(196),((_nTam-2)-Len(_cString)))+CHR(191),Alias())
	PAGRAVA(_cFimBloc,Alias())
	
	_cString:= "Qtde de M.Prima p/ os Pedidos de Venda Acima.: "+TRANSFORM(_nQtEstr,"@E 999,999,999.99")+" "
	PAGRAVA(CHR(218)+_cString+Repli(CHR(196),((_nTam-2)-Len(_cString)))+CHR(191),Alias())
	PAGRAVA(_cFimBloc,Alias())
	
Endif


Return

Static Function VerPc(_lFim)

_nQtPc := 0

dbSelectArea("SC7")
dbOrderNickName("INDSC71")
dbSeek(xFilial("SC7") + _cProduto + Dtos(MV_PAR01),.T.)

ProcRegua(LastRec())

While !Eof() .And. !_lFim .And.	_cProduto == SC7->C7_PRODUTO .And. SC7->C7_EMISSAO <= MV_PAR02
	
	IncProc()
	
	If !Empty(SC7->C7_RESIDUO)
		dbSelectArea("SC7")
		dbSkip()
		Loop
	Endif
	
	If SC7->C7_QUJE == SC7->C7_QUANT
		dbSelectArea("SC7")
		dbSkip()
		Loop
	Endif
	
	_nQtPcUnit := SC7->C7_QUANT - SC7->C7_QUJE
	_nQtPc     += SC7->C7_QUANT - SC7->C7_QUJE
	
	dbSelectArea("TRB2")
	RecLock("TRB2",.T.)
	TRB2->LINHA   := "2"+SC7->C7_NUM+Space(2)+SC7->C7_ITEM+Space(2)+SC7->C7_FORNECE+Space(2)+SC7->C7_LOJA+Space(2)+;
	DTOC(SC7->C7_DATPRF)+Space(2)+TRANSFORM(_nQtPcUnit,"@E 999,999.99")
	MsUnlock()
	
	dbSelectArea("SC7")
	dbSkip()
EndDo

_cString:= "Pedido de Compra.: "+TRANSFORM(_nQtPc,"@E 999,999,999.99")+" "
PAGRAVA(CHR(218)+_cString+Repli(CHR(196),((_nTam-2)-Len(_cString)))+CHR(191),Alias())
PAGRAVA(_cFimBloc,Alias())

Return

Static Function VerSc(_lFim)

_nQtSc := 0

dbSelectArea("SC1")
dbOrderNickName("INDSC11")
dbSeek(xFilial("SC1") + _cProduto + Dtos(MV_PAR01),.T.)

_cChavSC1 := SC1->C1_PRODUTO

ProcRegua(LastRec())

While !Eof() .And. !_lFim .And.	_cProduto == SC1->C1_PRODUTO .And. SC1->C1_EMISSAO <= MV_PAR02
	
	IncProc()
	
	If SC1->C1_QUJE == SC1->C1_QUANT
		dbSelectArea("SC1")
		dbSkip()
		Loop
	Endif
	
	_nQtSc     += SC1->C1_QUANT - SC1->C1_QUJE
	_nQtScUnit := SC1->C1_QUANT - SC1->C1_QUJE
	
	dbSelectArea("TRB2")
	RecLock("TRB2",.T.)
	TRB2->LINHA   := "3"+SC1->C1_NUM+Space(2)+SC1->C1_ITEM+Space(2)+SC1->C1_FORNECE+Space(2)+SC1->C1_LOJA+Space(2)+;
	DTOC(SC1->C1_DATPRF)+Space(2)+TRANSFORM(_nQtScUnit,"@E 999,999.99")
	MsUnlock()
	
	dbSelectArea("SC1")
	dbSkip()
EndDo

_cString:= "Solicitacao de Compra.: "+TRANSFORM(_nQtSc,"@E 999,999,999.99")+" "
PAGRAVA(CHR(218)+_cString+Repli(CHR(196),((_nTam-2)-Len(_cString)))+CHR(191),Alias())
PAGRAVA(_cFimBloc,Alias())

_nQtSaldo := 0
dbSelectArea("SB2")
dbSetorder(1)
If dbSeek(xFilial("SB2") + _cProduto +"01")
	_nQtSaldo := SB2->B2_QATU
endif

_cString:= "Saldo em Estoque Almox.01.: "+TRANSFORM(_nQtSaldo,"@E 999,999,999.99")+" "
PAGRAVA(CHR(218)+_cString+Repli(CHR(196),((_nTam-2)-Len(_cString)))+CHR(191),Alias())
PAGRAVA(_cFimBloc,Alias())

_nQtSal98 := 0
dbSelectArea("SB2")
dbSetorder(1)
If dbSeek(xFilial("SB2") + _cProduto +"98")
	_nQtSal98 := SB2->B2_QATU
Endif

_cString:= "Saldo em Estoque Almox.98.: "+TRANSFORM(_nQtSal98,"@E 999,999,999.99")+" "
PAGRAVA(CHR(218)+_cString+Repli(CHR(196),((_nTam-2)-Len(_cString)))+CHR(191),Alias())
PAGRAVA(_cFimBloc,Alias())

_nQtSol := _nQtEstr - _nQtPc - _nQtSc - _nQtSaldo - _nQtSal98

_cString:= "Abrir Solicitacao de Compra.: "+TRANSFORM(_nQtSol,"@E 999,999,999.99")+" "
PAGRAVA(CHR(218)+_cString+Repli(CHR(196),((_nTam-2)-Len(_cString)))+CHR(191),Alias())
PAGRAVA(_cFimBloc,Alias())

Return


Static Function Fecha()

aHeader := AClone(_aHeadOri)
aCols   := AClone(_aAColOri)
n       := _nOri

dbselectArea(_cAliSX3)
dbSetOrder(_nOrdSX3)
DbGoto(_nRecSX3)

Close(odlg3)

Return


Static Function PAGRAVA(cVar,cAlias)

cVar := StrTran(cVar,Chr(179)," ")
cVar := StrTran(cVar,Chr(191)," ")
cVar := StrTran(cVar,Chr(192)," ")
cVar := StrTran(cVar,Chr(196)," ")
cVar := StrTran(cVar,Chr(217)," ")
cVar := StrTran(cVar,Chr(218)," ")

dbSelectArea("TRB")
RecLock("TRB",.T.)
TRB->LINHA :=  OemToAnsi(cVar)
MsUnLock()

//dbSelectArea(cAlias)

Return

Static Function MontaBrow()

Local oDlg, oQual
Local cCadastro := "Analise do Produto"
Local oFont:=TFont():New( "Mono AS", 6, 15 )

dbSelectArea("TRB")
dbGotop()

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 25,95 OF oMainWnd

@ 5,10 LISTBOX oQual FIELDS TRB->LINHA HEADER "" SIZE 305,120  FONT oFont PIXEL

DEFINE SBUTTON FROM 14,320  TYPE 1 ACTION (oDlg:End()) 				ENABLE OF oDlg
DEFINE SBUTTON FROM 27,320  TYPE 6 ACTION (ImpCons(),oDlg:End())	ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

oFont:End()

Return(.T.)



Static Function ImpCons()

LOCAL cTitulo   := "POSICAO ATUAL DE PRODUTO "
LOCAL cDesc1 	:= "Este programa ira imprimir a Consulta do Produto selecionado,"
LOCAL cDesc2 	:= "informando os dados cadastrais, Movimentacoes em Aberto,"
LOCAL cDesc3 	:= "Historico de Movimentacoes."
LOCAL cString   := "TRB"
LOCAL wnrel     := "PA0069"

PRIVATE cPerg   := "      "
PRIVATE aReturn := {"Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
PRIVATE nLastKey:=0
nOpc:=2
nOpcA:=2
wnRel:= SetPrint(cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3,.F.,"",,,,.F.)

If nLastKey = 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
Endif

RptStatus({|lEnd| RelImp(@lEnd,ctitulo,wnRel)},ctitulo)

Return .T.


Static Function RelImp(lEnd,ctitulo,wnRel)

Local cCabec1  := "Consulta Geral ao Produto"
Local cCabec2  := ""
Local cTamanho := "P"
Local cNomeProg:= "PA0069"
Local cbtxt    := SPACE(10)
Local cbcont   := 0

li       := 80
m_pag    := 1

IF li > 62
	cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
	Li:= 9
EndIF

@ li++,00 PSay "P R O D U T O: "+_cProduto

Li+=2

dbSelectArea("TRB")
dbGoTop()

SetRegua(RecCount())

While !EOF() .And. !_lFim
	
	IncRegua()
	
	IF li > 62
		cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
		Li:= 9
	EndIF
	
	cCampo:=""
	For x:=1 to Len(TRB->LINHA)
		If Subs(TRB->LINHA,x,1) $ "Ú¿ÀÙ"
			cCampo += "+"
		ElseIf Subs(TRB->LINHA,x,1) == "Ä"
			cCampo += "-"
		ElseIf Subs(TRB->LINHA,x,1) == "„"
			cCampo += "a"
		ElseIf Subs(TRB->LINHA,x,1) == "‡"
			cCampo += "c"
		ElseIf Subs(TRB->LINHA,x,1) == "³"
			cCampo += "|"
		Else
			cCampo += Subs(TRB->LINHA,x,1)
		Endif
	Next
	
	@ li++,00 PSay cCampo
	dbSkip()
	
EndDO

IF li != 80
	li++
	roda(cbcont,cbtxt,"P")
EndIF

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

Return (.T.)




Static Function AtuTmp(_cTp,_cTitulo,_lEnd)

dbSelectArea("TRB")
RecLock("TRB",.T.)
TRB->LINHA := Space(50)
MsUnlock()

dbSelectArea("TRB")
RecLock("TRB",.T.)
TRB->LINHA := _cTitulo
MsUnlock()

dbSelectArea("TRB")
RecLock("TRB",.T.)
TRB->LINHA := Space(50)
MsUnlock()

dbSelectArea("TRB2")
dbSeek(_cTp)

ProcRegua(LastRec())

While !Eof() .And. !_lEnd .And. Substr(TRB2->LINHA,1,1) == _cTp
	
	IncProc()
	
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->LINHA := Substr(TRB2->LINHA,2,91)
	MsUnlock()
	
	dbSelectArea("TRB2")
	dbSkip()
EndDo

Return