#include "rwmake.ch"                       
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ PA0132   ³ Autor ³ Fabiano da silva      ³ Data ³ 18.05.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio  Produtividade dda Acabamento                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaEst                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0132()

titulo 	 := "Relatorio de Produtividade"
cDesc1 	 := "Relatorio Produtivide Acabamento"
cDesc2 	 := ""
cDesc3 	 := ""
cabec1	 := ""
cabec2   := ""
tamanho	 := "P"
limite 	 := 80
cString	 := "SD3"
nOrdem 	 := 0

Private nTipo    := 18
PRIVATE aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
PRIVATE nomeprog := "PA0132"
PRIVATE aLinha   := { },nLastKey := 0
PRIVATE cPerg    := "PA0132"
Private lAbortPrint  := .F.

cbtxt    		 := SPACE(10)
cbcont   		 := 0
li       		 :=80
m_pag    		 :=1

pergunte("PA0132",.F.)

///////////////////////////////////////
///// MV_PAR01 : Data De ?         ////
///// MV_PAR02 : Data Ate ?        ////
///// MV_PAR03 : Produto de ?      ////
///// MV_PAR04 : Produto ate ?     ////
///// MV_PAR05 : Operador de ?     ////
///// MV_PAR06 : Operador ate ?    ////
///////////////////////////////////////

wnrel:="PA0132"
aOrd :={"Por Data","Por Operador","Por Produto"}

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

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| Proc1(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

dbSelectArea("TMP")
dbCloseArea()

dbSelectArea("QD3A")
dbCloseArea()

Return

                                          
Static Function Proc1(_lFim)

nOrdem    := aReturn[8]
_cTpReje  := ""
_cNomrej  := ""
_cMotRej  := ""
_nQtRej   := 0

aCampos := {}
AADD(aCampos,{ "DATAE"    ,"D", 08, 0 } )
AADD(aCampos,{ "PRODUTO"  ,"C", 15, 0 } )
AADD(aCampos,{ "CODOP"    ,"C", 06, 0 } )
AADD(aCampos,{ "NOMOP"    ,"C", 40, 0 } )
AADD(aCampos,{ "QTPROD"   ,"N", 14, 2 } )

cArqLOG := CriaTrab(aCampos,.T.)
cIndLOG := "DTOS(DATAE)+NOMOP+PRODUTO"
dbUseArea(.T.,,cArqLOG,"TMP",.F.,.F.)

dbSelectArea("TMP")
IndRegua("TMP",cArqLog,cIndLog,,,"Criando Trabalho...")

_cQ := " SELECT * FROM "+RetSqlName("SD3")+" D3 INNER JOIN "+RetSqlName("SB1")+" B1 ON D3_COD=B1_COD "
_cQ += " INNER JOIN "+RetSqlName("SZ6")+" Z6 ON D3_OPERACA=Z6_CODIGO "
_cQ += " WHERE D3.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' AND Z6.D_E_L_E_T_ = '' "
_cQ += " AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQ += " AND D3_OPERACA BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_cQ += " AND D3_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' " 
_cQ += " AND D3_ESTORNO <> 'S' "
_cQ += " AND D3_OPERACA <> '      ' "
_cQ += " ORDER BY D3_EMISSAO,Z6_NOME,D3_COD "

TCQUERY _cQ NEW ALIAS "QD3A"

TCSETFIELD("QD3A","D3_EMISSAO","D")

dbSelectArea("QD3A")

ProcRegua(U_CONTREG())

While !Eof()
	
	IncProc()
		
	dbSelectArea("TMP")
	If !dbSeek(DTOS(QD3A->D3_EMISSAO)+SZ6->Z6_NOME+QD3A->D3_COD)
		RecLock("TMP",.T.)
		TMP->DATAE    := QD3A->D3_EMISSAO
		TMP->PRODUTO  := QD3A->D3_COD
		TMP->CODOP    := QD3A->D3_OPERACA
		TMP->NOMOP    := QD3A->Z6_NOME
		TMP->QTPROD   := QD3A->D3_QUANT
		MsUnlock()
	Else
		RecLock("TMP",.F.)
		TMP->QTPROD   += QD3A->D3_QUANT
		MsUnlock()
	Endif
		
	dbselectArea("QD3A")
	dbSkip()
EndDo

nLin := 80
	
If nOrdem == 1
	/*
	OPERADOR(A)                               PRODUTO                 QUANTIDADE
	9999999999999999999999999999999999999999  999999999999999    999999999999999
	0                                         42                 61
	*/
	cabec1 := "OPERADOR(A)                               PRODUTO                 QUANTIDADE"
	cabec2 := ""
	titulo := titulo +" - Por Data"
	
	OrdData()
ElseIf nOrdem == 2
	/*
	DATA               PRODUTO                                          QUANTIDADE
	99999999           9999999999999999                             99999999999999
	0	               19                                           65
	*/
	cabec1 := "	DATA               PRODUTO                                          QUANTIDADE"
	cabec2 := ""
	titulo := titulo + " - Por Operador(a)"
	
	OrdOper()
ElseIf nOrdem == 3
	/*
	DATA        OPERADOR(A)                                     QUANTIDADE
	99999999    999999999999999999999999999999999999999    999999999999999
	0           12                                         55
	*/
	cabec1 := "DATA        OPERADOR(A)                                     QUANTIDADE"
	cabec2 := ""
	titulo := titulo + " - Por Produto"
	
	OrdProd()
Endif

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Static Function OrdData()

dbSelectArea("TMP")
dbGoTop()

ProcRegua(LastRec())

_dData  := ""
_lDia   := .F.
_nQtPDi := 0
_nToPDi := 0

While !EOF()
	
	IncProc()
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
		If _lDia
			@nLin,000 PSAY "DATA :" + dToc(TMP->DATAE)
			nLin++
		Endif
	Endif
	
	If _dData <> dToc(TMP->DATAE)
		If _lDia
			
			nLin++
			
			@nLin,000 PSAY "TOTAL DIA "+_dData+"    ---------->"
			@nLin,061 PSAY _nQtPDi      Picture TM(_nQtPDi,15,6)

			nLin += 2
			
			_nToPDi  += _nQtPDi
			_nQtPDi := 0
		Endif
		
		nLin++
		@nLin,000 PSAY "DATA :" + dToc(TMP->DATAE)
		nLin++
		_dData :=	dToc(TMP->DATAE)
	Endif
	
	_lDia := .T.
	
	@nLin,000 PSAY TMP->NOMOP
	@nLin,042 PSAY TMP->PRODUTO	
	@nLin,061 PSAY TMP->QTPROD		Picture TM(TMP->QTPROD,15,6)
	
	_nQtPDi += TMP->QTPROD
	
	nLin ++
	
	dbSelectArea("TMP")
	dbSkip()
	
EndDo

nLin++

@nLin,000 PSAY "TOTAL DIA "+_dData+"    ---------->"
@nLin,061 PSAY _nQtPDi      Picture TM(_nQtPDi,15,6)

_nToPDi  += _nQtPDi

nLin += 2
@nLin,00 PSAY Replicate("-",limite)
nLin += 2

@nLin,000 PSAY "TOTAL GERAL   -------------------->"
@nLin,061 PSAY _nToPDi      Picture TM(_nToPDi,15,6)

Return


Static Function OrdOper()

dbSelectArea("TMP")
cIndTMP    := CriaTrab(NIL,.F.)
IndRegua("TMP",cIndTMP,"NOMOP+DTOS(DATAE)+PRODUTO",,,"Selecionando Registros...")

dbGoTop()

ProcRegua(LastRec())

_cCodOp := ""
_cNomOP := ""
_lDia   := .F.
_nQtPDi := 0
_nToPDi := 0

While !EOF()
	
	IncProc()
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	                                     
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	If _cCodOp <> (TMP->CODOP)
		If _lDia
			
			nLin++
			
			@nLin,000 PSAY "TOTAL OPERADOR "+_cCodOp+ " - " + Substr(_cNomOP,1,30)
			@nLin,065 PSAY _nQtPDi      Picture TM(_nQtPDi,15,6)
			nLin += 2
			
			_nToPDi  += _nQtPDi
			_nQtPDi := 0
		Endif
		
		nLin++
		@nLin,000 PSAY "OPERADOR :" + TMP->CODOP + " - " + TMP->NOMOP
		nLin++
		_cCodOp := TMP->CODOP
		_cNomOP := TMP->NOMOP
	Endif
	
	_lDia := .T.
	
	@nLin,000 PSAY dtoc(TMP->DATAE)
	@nLin,019 PSAY TMP->PRODUTO
	@nLin,065 PSAY TMP->QTPROD		Picture TM(TMP->QTPROD,15,6)
	
	_nQtPDi += TMP->QTPROD
	
	nLin ++
	
	dbSelectArea("TMP")
	dbSkip()
	
EndDo

nLin++

@nLin,000 PSAY "TOTAL OPERADOR "+ Substr(_cNomOP,1,25)
@nLin,065 PSAY _nQtPDi      Picture TM(_nQtPDi,15,6)

_nToPDi  += _nQtPDi

nLin += 2
@nLin,00 PSAY Replicate("-",limite)

nLin += 2	

@nLin,000 PSAY "TOTAL GERAL   -------------------->"
@nLin,065 PSAY _nToPDi      Picture TM(_nToPDi,15,6)

Return


Static Function OrdProd()

dbSelectArea("TMP")
cIndTMP    := CriaTrab(NIL,.F.)
IndRegua("TMP",cIndTMP,"PRODUTO+DTOS(DATAE)+NOMOP",,,"Selecionando Registros...")

dbGoTop()

ProcRegua(LastRec())

_cProd  := ""
_lDia   := .F.
_nQtPDi := 0
_nToPDi := 0

While !EOF()
	
	IncProc()
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	If _cProd <> TMP->PRODUTO
		If _lDia
			
			nLin++
			
			@nLin,000 PSAY "TOTAL PRODUTO "+_cProd+"    ---------->"
			@nLin,055 PSAY _nQtPDi      Picture TM(_nQtPDi,15,6)
			nLin += 2
			
			_nToPDi  += _nQtPDi
			_nQtPDi := 0
		Endif
		
		nLin++
		@nLin,000 PSAY "PRODUTO :" +TMP->PRODUTO
		nLin++
		_cProd := TMP->PRODUTO
	Endif
	
	_lDia := .T.
	
	@nLin,000 PSAY dToc(TMP->DATAE)
	@nLin,012 PSAY TMP->NOMOP
	@nLin,055 PSAY TMP->QTPROD		Picture TM(TMP->QTPROD,15,6)
	
	_nQtPDi += TMP->QTPROD	
	nLin ++
	
	dbSelectArea("TMP")
	dbSkip()
	
EndDo

nLin++

@nLin,000 PSAY "TOTAL PRODUTO "+_cProd+"    ---------->"
@nLin,055 PSAY _nQtPDi      Picture TM(_nQtPDi,15,6)

_nToPDi  += _nQtPDi

nLin += 2
@nLin,00 PSAY Replicate("-",limite)
nLin += 2

@nLin,000 PSAY "TOTAL GERAL   -------------------->"
@nLin,055 PSAY _nToPDi      Picture TM(_nToPDi,15,6)

Return
