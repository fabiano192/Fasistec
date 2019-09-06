#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA006A   ³ Autor ³ Alexandro da Silva    ³ Data ³ 29.01.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao Das Ordens de Producao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaPcp / Sigaest                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function Pa006A()

Private _lPrim     := .T.
Private _lPassou   := .T.
Private _lPorta
Private _cCond     := ""
Private _cCav      := ""
Private _nPeso     := _nTmp := _nQuantOp := 0
Private _cMedida   := "",_cTempo := "",_cQtBll := "",_cQtBlR := "", _cMed2 := "",_cDesc := "",_cDesc2 := ""
private wnrel      := "PA006A"
private aOrd       := {"Por Numero","Por Produto","Por Centro de Custo","Por Prazo de Entrega"}
private cDesc      := "Este programa ira imprimir a Rela‡„o das Ordens de Produ‡„o"
private cDesc1     := ""
private cDesc2     := ""
private cString    := "SC2"
Private limite     := 80
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private tamanho    := "G"
Private titulo     := "Ordem de Producao"
Private _cProdPa   := ""
cPerg      := "MTR820"
lEnd       := .F.
nLastKey   := 0

pergunte("MTR820",.F.)

If !ChkFile("SH8",.F.)
	Help(" ",1,"SH8EmUso")
	Return
Endif

wnrel := "PA006A"
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc,cDesc1,cDesc2,.F.,aOrd,,Tamanho)

If nLastKey == 27
	dbSelectArea("SH8")
	Set Filter To
	dbCloseArea()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retira o SH8 da variavel cFopened ref. a abertura no MNU     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ClosFile("SH8")
	dbSelectArea("SC2")
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	dbSelectArea("SH8")
	Set Filter To
	dbCloseArea()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retira o SH8 da variavel cFopened ref. a abertura no MNU     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ClosFile("SH8")
	dbSelectArea("SC2")
	Return
Endif

_lPorta := .F.

If aReturn[5]==3
	_lPorta := .T.
Endif

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| R820imp(@_lFim) }
Private _cTitulo01 := 'Processando'
RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

//RptStatus({|lEnd| R820Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R820Imp  ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 13.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function R820Imp(_lFim)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
private CbCont,cabec1,cabec2
private nQuant     := 1
private nomeprog   := "MATR820"
private cProduto   := SPACE(LEN(SC2->C2_PRODUTO))
private cQtd
private cIndSC2    := CriaTrab(NIL,.F.), nIndSC2
Private aArray   := {}
Private li       := 80
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt            := SPACE(10)
cbcont           := 0
m_pag            := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1           := ""
cabec2           := ""

_cCond2          := ".T."
dbSelectArea("SC2")
If aReturn[8] == 4
	#IFDEF TOP
		IndRegua("SC2",cIndSC2,"C2_FILIAL+C2_DATPRF",,,"Selecionando Registros...")
	#ELSE
		IndRegua("SC2",cIndSC2,"C2_FILIAL+DTOS(C2_DATPRF)",,,"Selecionando Registros...")
	#ENDIF
	dbGoTop()
ElseIf aReturn[8] == 1
	dbSetOrder(1)
	dbSeek(xFilial("SC2")+MV_PAR01,.T.)
	_cCond := "C2_NUM+C2_ITEM+C2_SEQUEN <= MV_PAR02"
EndIf

_cPedido := "000000"
_dDtEnt  := CTOD("  /  /  ")
_cCodCli := ""
_cPedCli := 0

SetRegua(LastRec())

@ 0,0 PSAY AvalImp(Limite)
_lVazados := .F.
_lVazad   := .F.

While !Eof() .And. !_lFim  .And. &_cCond
	
	IF _lFim
		@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
		Exit
	EndIF
	
	IncRegua()
	
	_cOp := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD
	
	If _cOP < mv_par01 .Or. _cOp > mv_par02
		dbSkip()
		Loop
	EndIf
	
	If SC2->C2_DATPRF < mv_par03 .Or. SC2->C2_DATPRF > mv_par04
		dbSkip()
		Loop
	Endif
	
	If !(Empty(SC2->C2_DATRF)) .And. mv_par08 == 2
		dbSkip()
		Loop
	Endif
	
	If !MtrAValOP(mv_par10, 'SC2')
		dbSkip()
		Loop
	EndIf
	
	cProduto  := SC2->C2_PRODUTO
	nQuant    := aSC2Sld()
	
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+cProduto)
	
	If SB1->B1_TIPO == "PA" .And. SB1->B1_GRUPO == "PAV " .And. _lPrim
		_lVazados := .t.
		_lVazad   := .T.
	Endif
	
	If SB1->B1_GRUPO $ "PIC "
		dbSelectArea("SC2")
		dbSkip()
		Loop
	EndIf
	
	If SB1->B1_GRUPO == "PIPB" .And. !_lVazados
		dbSelectArea("SC2")
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("SC2")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona o primeiro elemento da estrutura , ou seja , o Pai  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AddAr820(nQuant)
	
	MontStruc(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD,nQuant)
	
	If mv_par09 == 1
		aSort( aArray,2,, { |x, y| (x[1]+x[8]) < (y[1]+y[8]) } )
	Else
		aSort( aArray,2,, { |x, y| (x[8]+x[1]) < (y[8]+y[1]) } )
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime cabecalho                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cabecOp()
	
	_nQuantOP := SC2->C2_QUANT - SC2->C2_QUJE
	
	For I := 2 TO Len(aArray)
		                                       
		_cMater := aArray[I][1]
		@Li ,   0 PSay aArray[I][1]    	 				   // CODIGO PRODUTO
		For nBegin := 1 To Len(Alltrim(aArray[I][2])) Step 31
			@li,016 PSay Substr(aArray[I][2],nBegin,31)
			li++
		Next nBegin
		Li--
		cQtd := Alltrim(Transform(aArray[I][5],PesqPictQt("D4_QUANT",14)))
		@Li , (46+11-Len(cQtd)) PSay cQtd					 // QUANTIDADE
		@Li ,  57 PSay "|"+aArray[I][4]+"|"			 	    // UNIDADE DE MEDIDA
		@li ,  61 PSay aArray[I][6]+"|"                  // ALMOXARIFADO
		@li ,  64 PSay Substr(aArray[I][7],1,12)         // LOCALIZACAO
		@li ,  76 PSay "|"+alltrim(aArray[I][8])                  // SEQUENCIA
		@li ,  79 PSay "|"
		Li++
		If _lPorta
			@Li,00 PSay REPLICATE("-",80)
		Else
			@Li ,   0 PSay __prtfatline()
		Endif
		Li++
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se nao couber, salta para proxima folha                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF li > 57 //63
			Li := 0
			cabecOp()		// imprime cabecalho da OP
		EndIF
	Next I
	
	If mv_par05 == 1
		RotOper()   	// IMPRIME ROTEIRO DAS OPERACOES
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimir Relacao de medidas para Cliente == HUNTER DOUGLAS.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SMX")
	If Found() .And. SC2->C2_DESTINA == "P"
		R820Medidas()
	EndIf
	
	ImpHist()
	
	m_pag++
	Li := 0					// linha inicial - ejeta automatico
	aArray:={}
	
	// - Alteração efetuada abaixo para poder imprimir duas vias do produto peça bruta.
	If  !_lVazad
		dbSelectArea("SC2")
		dbSkip()
	Else
		dbSelectArea("SC2")
		_lPrim  := .F.
		_lVazad := .F.
	Endif
EndDO

dbSelectArea("SH8")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retira o SH8 da variavel cFopened ref. a abertura no MNU     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ClosFile("SH8")

dbSelectArea("SC2")
If aReturn[8] == 4
	RetIndex("SC2")
	Ferase(cIndSC2+OrdBagExt())
EndIf
Set Filter To
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return NIL

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ AddAr820 ³ Autor ³ Paulo Boschetti       ³ Data ³ 07/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Adiciona um elemento ao Array                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ AddAr820(ExpN1)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Quantidade da estrutura                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function AddAr820(nQuantItem)

private cDesc := SB1->B1_DESC
private cRoteiro:=""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se imprime nome cientifico do produto. Se Sim    ³
//³ verifica se existe registro no SB5 e se nao esta vazio    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par07 == 1
	dbSelectArea("SB5")
	dbSeek(xFilial("SB5")+SB1->B1_COD)
	If Found() .and. !Empty(B5_CEME)
		cDesc := B5_CEME
	EndIf
ElseIf mv_par07 == 2
	cDesc := SB1->B1_DESC
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se imprime descricao digitada ped.venda, se sim  ³
	//³ verifica se existe registro no SC6 e se nao esta vazio    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//	If SC2->C2_DESTINA == "P"
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEM)
	If Found() .and. !Empty(C6_DESCRI) .and. C6_PRODUTO==SB1->B1_COD
		cDesc := C6_DESCRI
	ElseIf C6_PRODUTO #SB1->B1_COD
		dbSelectArea("SB5")
		dbSeek(xFilial("SB5")+SB1->B1_COD)
		If Found() .and. !Empty(B5_CEME)
			cDesc := B5_CEME
		EndIf
	EndIf
	//	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se imprime ROTEIRO da OP ou PADRAO do produto    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(SC2->C2_ROTEIRO)
	cRoteiro:=SC2->C2_ROTEIRO
Else
	If !Empty(SB1->B1_OPERPAD)
		cRoteiro:=SB1->B1_OPERPAD
	Else
		dbSelectArea("SG2")
		If dbSeek(xFilial("SG2")+SC2->C2_PRODUTO+"01")
			RecLock("SB1",.F.)
			Replace B1_OPERPAD With "01"
			MsUnLock()
			cRoteiro:="01"
		EndIf
	EndIf
EndIf

dbSelectArea("SB2")
dbSeek(xFilial("SB2")+SB1->B1_COD+SD4->D4_LOCAL)
dbSelectArea("SD4")
AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,D4_LOCAL,SB2->B2_LOCALIZ,D4_TRT,cRoteiro } )

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ MontStruc³ Autor ³ Ary Medeiros          ³ Data ³ 19/10/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Monta um array com a estrutura do produto                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ MontStruc(ExpC1,ExpN1,ExpN2)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpN1 = Quantidade base a ser explodida                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

Static Function MontStruc(cOp,nQuant)

dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial("SD4")+cOp)

While !Eof() .And. D4_FILIAL+D4_OP == xFilial("SD4")+cOp
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no produto desejado                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If (SC2->C2_DATPRI > SD4->D4_DATA)
		dbSelectArea("SD4")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+SD4->D4_COD)
	If SD4->D4_QUANT > 0
		AddAr820(SD4->D4_QUANT)
	EndIf
	dbSelectArea("SD4")
	dbSkip()
Enddo

dbSetOrder(1)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ CabecOp  ³ Autor ³ Paulo Boschetti       ³ Data ³ 07/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Monta o cabecalho da Ordem de Producao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ CabecOp()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

Static Function CabecOp()

private cCabec1 := SM0->M0_NOME+"        O R D E M   D E   P R O D U C A O       NRO :"
private cCabec2 := "  C O M P O N E N T E S                                  |  |  |            |   "
private cCabec3 := "CODIGO          DESCRICAO                      QUANTIDADE|UM|AL|LOCALIZACAO |SEQ"
//                12345678901234567890123456789012345678901234567890123456789012345678901234567890
//                1         2         3         4         5         6         7         8
private nBegin

If li #5
	li := 0
Endif

@Li,00 PSay REPLICATE("-",80)

Li++
@Li,00  PSay cCabec1
@Li,69  PSay SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD
Li++

@Li,00 PSay REPLICATE("-",80)

Li++
IF (mv_par06 == 1)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o codigo de barras do numero da OP              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPr := ReturnPrtObj()
	cCode := (SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD)
	MSBAR("CODE128",2.5,1.5,cCode,oPr,Nil,Nil,Nil,nil ,1.5 ,Nil,Nil,Nil)
	Li += 6
ENDIF
@Li,00 PSay "Produto: "+aArray[1][1]+ " " +Substr(aArray[1][2],1,25)

If SC2->C2_DESTINA == "P"
	dbSelectArea("SC6")
	_cAliSC6 := Alias()
	_nOrdSc6 := IndexOrd()
	_nRecSC6 := Recno()
	dbSetorder(1)
	If dbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV+SC2->C2_PRODUTO)
		_dDtEnt  := SC6->C6_ENTREG
		_cCodCli := SC6->C6_CPROCLI
		_cPedCli := SC6->C6_PEDCLI
		_cPedido := SC6->C6_NUM
	Endif
	
	dbSelectArea(_cAliSC6)
	dbSetOrder(_nOrdSC6)
	dbGoto(_nRecSC6)
	
Endif

@Li,52 PSay "Cod.Cliente: " + _cCodCli
Li++

/*
Produto: 999999999999999 9999999999999999999999999 Cod.Cliente: 999999999999999
012345678901234567890123456789012345678901234567890123456789012345678901234567890
0        1         2         3         4         5         6         7         8
10              26                        52


Emissao: 99/99/99  Dt.de Entrega : 99/99/99  O.C.Cliente : 99999999999 Fol:999
012345678901234567890123456789012345678901234567890123456789012345678901234567890
0        1         2         3         4         5         6         7         8
0                  19                        45
*/


@Li,00 PSay "Emissao:"+DTOC(dDatabase)
@Li,19 PSay "Dt.De Entrega : "+DTOC(_dDtEnt)
@Li,45 PSay "O.C. Cliente: "+Alltrim(_cPedCli)
@Li,73 PSay "Fol:"+TRANSFORM(m_pag,'999')
Li++

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime nome do cliente quando OP for gerada            ³
//³ por pedidos de venda                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//If !Empty(SC2->C2_PEDIDO)
//	_cPedido := SC2->C2_PEDIDO
//Endif

dbSelectArea("SC5")
dbSetOrder(1)
If dbSeek(xFilial("SC5")+ _cPedido,.F.)
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	@Li,00 PSay "Cliente :"
	@Li,10 PSay SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI+" "+A1_NOME
	dbSelectArea("SG1")
	Li++
EndIf
//EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime a quantidade original quando a quantidade da    ³
//³ Op for diferente da quantidade ja entregue              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SC2->C2_QUJE + SC2->C2_PERDA > 0
	@Li,00 PSay "Qtde Prod.:"
	@Li,11 PSay aSC2Sld()		PICTURE PesqPictQt("C2_QUANT",14)
	@Li,26 PSay "Qtde Orig.:"
	@Li,37 PSay SC2->C2_QUANT	PICTURE PesqPictQt("C2_QUANT",14)
Else
	@Li,00 PSay "Quantidade :"
	@Li,15 PSay SC2->C2_QUANT - SC2->C2_QUJE	PICTURE PesqPictQt("C2_QUANT",14)
Endif

@Li,56 PSay "INICIO             F I M"
Li++
@Li,00 PSay "Unid. Medida : "+aArray[1][4]
@Li,42 PSay "Prev. : "+DTOC(SC2->C2_DATPRI)
@Li,62 PSay "Prev. : "+DTOC(SC2->C2_DATPRF)
Li++
@Li,00 PSay "C.Custo: "+SC2->C2_CC
@Li,42 PSay "Ajuste: " +DTOC(SC2->C2_DATAJI)
@Li,62 PSay "Ajuste: " +DTOC(SC2->C2_DATAJF)
Li++
If SC2->C2_STATUS == "S"
	@Li,00 PSay "Status: OP Sacramentada"
ElseIf SC2->C2_STATUS == "U"
	@Li,00 PSay "Status: OP Suspensa"
ElseIf SC2->C2_STATUS $ " N"
	@Li,00 PSay "Status: OP Normal"
EndIf
@Li,42 PSay "Real  :____:____    Real  :____:___"
Li++

If !(Empty(SC2->C2_OBS))
	@Li,00 PSay "Observacao: "
	For nBegin := 1 To Len(Alltrim(SC2->C2_OBS)) Step 65
		@li,012 PSay Substr(SC2->C2_OBS,nBegin,65)
		li++
	Next nBegin
EndIf

If _lPorta
	@Li,00 PSay REPLICATE("-",80)
Else
	@Li ,   0 PSay __prtfatline()
Endif

Li++
@Li,00 PSay cCabec2
Li++
@Li,00 PSay cCabec3
Li++
If _lPorta
	@Li,00 PSay REPLICATE("-",80)
Else
	@Li ,   0 PSay __prtfatline()
Endif

Li++

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ RotOper  ³ Autor ³ Paulo Boschetti       ³ Data ³ 18/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Imprime Roteiro de Operacoes                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ RotOper()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function RotOper()

private cCabec1 := SM0->M0_NOME+"              ROTEIRO DE OPERACOES              NRO :"
private cCabec2 := "RECURSO                FERRAMENTA             OPERACAO"
private nBegin, lSH8

dbSelectArea("SG2")
If dbSeek(xFilial("SG2")+aArray[1][1]+aArray[1][9],.F.)
	
	cRotOper()
	
	While !Eof() .And. G2_FILIAL+G2_PRODUTO+G2_CODIGO = xFilial("SG2")+aArray[1][1]+aArray[1][9]
		
		dbSelectArea("SH4")
		dbSeek(xFilial("SH4")+SG2->G2_FERRAM)
		
		ImpRot(lSH8)
		
		dbSelectArea("SG2")
		dbSkip()
	EndDo
	
Endif

Return Li

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ ImpRot   ³ Autor ³ Marcos Bregantim      ³ Data ³ 10/07/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Imprime Roteiro de Operacoes                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ ImpRot()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function ImpRot(lSH8)
private nBegin

dbSelectArea("SH1")
dbSeek(xFilial("SH1")+SG2->G2_RECURSO)

Verilim()

/*
RECURSO                FERRAMENTA             OPERACAO
999999 999999999999999 999999 999999999999999 99999999999999999999999999999999
0      7               23     30              46
*/
@Li,00 PSay SG2->G2_RECURSO
@Li,07 PSay SUBSTR(SH1->H1_DESCRI,1,15)
@Li,23 PSay SG2->G2_FERRAM
@Li,30 PSay SUBSTR(SH4->H4_DESCRI,1,15)
@Li,46 PSay SG2->G2_OPERAC+" "+Substr(SG2->G2_DESCRI,1,30)

Li++

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ RotOper  ³ Autor ³ Paulo Boschetti       ³ Data ³ 18/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Imprime Roteiro de Operacoes                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ RotOper()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function cRotOper()

private cCabec1 := SM0->M0_NOME+"              ROTEIRO DE OPERACOES              NRO :"
private cCabec2 := "RECURSO                       FERRAMENTA               OPERACAO"

Li++
If _lPorta
	@Li,00 PSay REPLICATE("-",80)
Else
	@Li ,   0 PSay __prtfatline()
Endif

Li++
@Li,00 PSay cCabec1
@Li,69 PSay SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD
Li++
If _lPorta
	@Li,00 PSay REPLICATE("-",80)
Else
	@Li ,   0 PSay __prtfatline()
Endif

Li++
@Li,00 PSay "Produto: "+aArray[1][1]
ImpDescr(aArray[1][2])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime a quantidade original quando a quantidade da    ³
//³ Op for diferente da quantidade ja entregue              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SC2->C2_QUJE + SC2->C2_PERDA > 0
	@Li,00 PSay "Qtde Prod.:"
	@Li,11 PSay aSC2Sld()		PICTURE PesqPictQt("C2_QUANT",14)
	@Li,26 PSay "Qtde Orig.:"
	@Li,37 PSay SC2->C2_QUANT	PICTURE PesqPictQt("C2_QUANT",14)
Else
	@Li,00 PSay "Quantidade :"
	@Li,15 PSay aSC2Sld()	PICTURE PesqPictQt("C2_QUANT",14)
Endif

Li++
@Li,00 PSay "C.Custo: "+SC2->C2_CC
Li++
If _lPorta
	@Li,00 PSay REPLICATE("-",80)
Else
	@Li ,   0 PSay __prtfatline()
Endif

Li++
@Li,00 PSay cCabec2
Li++
If _lPorta
	@Li,00 PSay REPLICATE("-",80)
Else
	@Li ,   0 PSay __prtfatline()
Endif

Li++
Return Li

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ Verilim  ³ Autor ³ Paulo Boschetti       ³ Data ³ 18/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ Verilim()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 			                                          		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


Static Function Verilim()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a possibilidade de impressao da proxima operacao alocada na ³
//³ mesma folha.																			 ³
//³ 7 linhas por operacao => (total da folha) 66 - 7 = 59					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF Li > 59						// Li > 55
	Li := 0
	cRotOper(0)					// Imprime cabecalho roteiro de operacoes
Endif
Return Li

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BARCODE  ³ Autor ³ Ricardo Dutra          ³ Data ³ 16/08/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa para imprimir codigo de barras                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CodBar(ExpC1)								                ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function BarCode(cCodigo)
private nLargura := 40	// largura de impressao do codigo
private i, j, l, k, nCarac, cTexto, cEsc, cCode, nLimite, nImp, nBorda, nLin
private aV0 := { Replicate(Chr(0),7), Chr(0) + Chr(0) + Chr(0) }
private aV1 := { Replicate(Chr(127),6), Chr(127) + Chr(127) }
private aImp [50]

nLin := 0							// imprime codigo comeco formulario
cEsc := Chr(ESC)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Reseta a impressora na posicao atual - comeco formulario           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 0,0 PSay cEsc + "@"				// reseta a impressora nesta posicao

cTexto := cCodigo
cTexto := "*" + cTexto + "*"		// caracteres de inicio e fim

nImp := 1
aImp [nImp] := ""
nLimite := Len(cTexto)

FOR i := 1 TO nLimite
	nCarac := Asc (Substr (cTexto, i, 1))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atribui um codigo a cada caracter                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	IF nCarac == 42					// *
		cCode := "2122121222"
	ELSEIF nCarac == 32				// branco
		cCode := "2112221222"
	ELSEIF nCarac == 48				// 0
		cCode := "2221121222"
	ELSEIF nCarac == 49				// 1
		cCode := "1221222212"
	ELSEIF nCarac == 50				// 2
		cCode := "2211222212"
	ELSEIF nCarac == 51				// 3
		cCode := "1211222222"
	ELSEIF nCarac == 52				// 4
		cCode := "2221122212"
	ELSEIF nCarac == 53				// 5
		cCode := "1221122222"
	ELSEIF nCarac == 54				// 6
		cCode := "2211122222"
	ELSEIF nCarac == 55				// 7
		cCode := "2221221212"
	ELSEIF nCarac == 56				// 8
		cCode := "1221221222"
	ELSEIF nCarac == 57				// 9
		cCode := "2211221222"
	ELSEIF nCarac == 65				// A
		cCode := "1222212212"
	ELSEIF nCarac == 66				// B
		cCode := "2212212212"
	ELSEIF nCarac == 67				// C
		cCode := "1212212222"
	ELSEIF nCarac == 68				// D
		cCode := "2222112212"
	ELSEIF nCarac == 69				// E
		cCode := "1222112222"
	ELSEIF nCarac == 70				// F
		cCode := "2212112222"
	ELSEIF nCarac == 71				// G
		cCode := "2222211212"
	ELSEIF nCarac == 72				// H
		cCode := "1222211222"
	ELSEIF nCarac == 73				// I
		cCode := "2212211222"
	ELSEIF nCarac == 74				// J
		cCode := "2222111222"
	ELSEIF nCarac == 75				// K
		cCode := "1222222112"
	ELSEIF nCarac == 76				// L
		cCode := "2212222112"
	ELSEIF nCarac == 77				// M
		cCode := "1212222122"
	ELSEIF nCarac == 78				// N
		cCode := "2222122112"
	ELSEIF nCarac == 79				// O
		cCode := "1222122122"
	ELSEIF nCarac == 80				// P
		cCode := "2212122122"
	ELSEIF nCarac == 81				// Q
		cCode := "2222221112"
	ELSEIF nCarac == 82				// R
		cCode := "1222221122"
	ELSEIF nCarac == 83				// S
		cCode := "2212221122"
	ELSEIF nCarac == 84				// T
		cCode := "2222121122"
	ELSEIF nCarac == 85				// U
		cCode := "1122222212"
	ELSEIF nCarac == 86				// V
		cCode := "2112222212"
	ELSEIF nCarac == 87				// W
		cCode := "1112222222"
	ELSEIF nCarac == 88				// X
		cCode := "2122122212"
	ELSEIF nCarac == 89				// Y
		cCode := "1122122222"
	ELSEIF nCarac == 90				// Z
		cCode := "2112122222"
	ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona barras ou espacos ao array de impressao, sendo :     ³
	//³ - barra grossa  = 6 * Chr(127)                				  ³
	//³ - barra fina    = 2 * Chr(127)								  ³
	//³ - espaco grosso = 7 * Chr(0)                                  ³
	//³ - espaco fino   = 3 * Chr(0) 								  ³
	//³																  ³
	//³ As barras e espacos sao alocados de acordo com os caracteres  ³
	//³ de cCode, tomados 2 a 2, sendo que o primeiro designa as bar- ³
	//³ ras e o segundo, os espacos. 								  ³
	//³ Se o caracter for 1 => barra/espaco grosso					  ³
	//³ Se o caracter for 2 => barra/espaco fino					  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FOR j := 1 to 9 STEP 2
		aImp[nImp] := aImp[nImp] + aV1 [val(substr(cCode,j,1))] + ;
		aV0 [val(substr(cCode,j + 1,1))]
	NEXT
	
	l := len(aImp[nImp])
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se tamanho do string atual de impressao for maior que 120,	     	 ³
	//³copia o que ultrapassou para o proximo string						 ³
	//³Limita o string atual para 120 + caracteres de controle de imp grafica³
	//³Incrementa contador de strings								         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF l > 120
		aImp[nImp+1] := Right(aImp[nImp],l -120)
		aImp[nImp] := cEsc + "L" + Chr(120) + Chr(0) + Left(aImp[nImp],120)
		nImp++
	ENDIF
NEXT

j := Len(aImp[nImp])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Borda esquerda da etiqueta para centrar o codigo   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nBorda := (nLargura - (j + (nImp - 1) * 120 ) / Len(cTexto)) / 2

IF nBorda < 0
	return -2		// Codigo muito grande p/largura especificada
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acrescenta caracteres de controle grafico ao ultimo string   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aImp[nImp] := cEsc + "L" + Chr(j)+Chr(0) + aImp[nImp] + cEsc + "3" + Chr(1)

FOR l := 1 to 4					// imprime quatro linhas
	FOR k := 1 to 3				// imprime tres vezes
		FOR i := 1 to nImp		// contador de strings
			@ nLin,nBorda+(i-1)*10 PSay aImp[i]
		NEXT
		nLin++
	NEXT
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seta tamanho de linha para posicionar para a proxima         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ nLin,1 PSay cEsc + "3" + Chr(18)
	nLin++
NEXT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seta tamanho de linha p/ posicionar cursor proxima coluna de texto ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ nLin,1 PSay  cEsc + "3" + Chr(24)
nLin++

@ nLin,1 PSay cEsc + "2"			// cancela espacamentos de linha progrados

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime o numero da OP expandido e centralizado, embaixo do codigo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNumOp := Replicate(" ",3) + cTexto		// para centralizar
@ nLin,nBorda PSay Chr(14) + cNumOp	    // imprime expandido
nLin++
@ nLin,0 PSay Chr(20)					// volta ao normal

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpDescr ³ Autor ³ Marcos Bregantim      ³ Data ³ 31.08.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir descricao do Produto.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpProd(Void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpDescr(cDescri)

For nBegin := 1 To Len(Alltrim(cDescri)) Step 50
	@li,025 PSay Substr(cDescri,nBegin,50)
	li++
Next nBegin

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R820Medidas³ Autor ³ Jose Lucas           ³ Data ³ 25.01.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o registros referentes as medidas do Pedido Filho. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R820Medidas(Void)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function R820Medidas()
private aArrayPro := {}, lImpItem := .T.
private nCntArray := 0,a01 := "",a02 := ""
private nX:=0,nI:=0,nL:=0,nY:=0
private cNum:="", cItem:="",lImpCab := .T.
private nBegin, cProduto:="", cDesc, cDescri, cDescri1, cDescri2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Relacao de Medidas do cliente quando OP for gerada ³
//³ por pedidos de vendas.                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC5")
dbSetOrder(1)
If dbSeek(xFilial("SC5")+SC2->C2_PEDIDO,.F.)
	cNum := SC2->C2_NUM
	cItem := SC2->C2_ITEM
	cProduto := SC2->C2_PRODUTO
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimir somente se houver Observacoes.                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !Empty(SC5->C5_OBSERVA)
		IF li > 53
			@ 03,001 PSay "HUNTER DOUGLAS DO BRASIL LTDA"
			@ 05,008 PSay "CONFIRMACAO DE PEDIDOS  -  "+IIF( SC5->C5_VENDA=="01","ASSESSORIA","DISTRIBUICAO")
			@ 05,055 PSay "No. RMP    : "+SC5->C5_NUM+"-"+SC5->C5_VENDA
			@ 06,055 PSay "DATA IMPRES: "+DTOC(dDataBase)
			li := 07
		EndIF
		li++
		@ li,001 PSay "--------------------------------------------------------------------------------"
		li++
		cDescri := SC5->C5_OBSERVA
		@ li,001 PSay " OBSERVACAO: "
		@ li,018 PSay SubStr(cDescri,1,60)
		For nBegin := 61 To Len(Trim(cDescri)) Step 60
			li++
			cDesc:=Substr(cDescri,nBegin,60)
			@ li,018 PSay cDesc
		Next nBegin
		li++
		cDescri1 := SC5->C5_OBSERV1
		@ li,018 PSay SubStr(cDescri1,1,60)
		For nBegin := 61 To Len(Trim(cDescri1)) Step 60
			li++
			cDesc:=Substr(cDescri1,nBegin,60)
			@ li,018 PSay cDesc
		Next nBegin
		Li++
		cDescri2 := SC5->C5_OBSERV2
		@ li,018 PSay SubStr(cDescri2,1,60)
		For nBegin := 61 To Len(Trim(cDescri2)) Step 60
			li++
			cDesc:=Substr(cDescri2,nBegin,60)
			@ li,018 PSay cDesc
		Next nBegin
		li++
		@ li,001 PSay "--------------------------------------------------------------------------------"
		li++
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carregar as medidas em array para impressao.                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SMX")
	dbSetOrder(2)
	dbSeek(xFilial("SMX")+cNum+cProduto)
	While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial("SMX")+cNum+cProduto
		IF M6_ITEM == cItem
			AADD(aArrayPro,M6_ITEM+" - "+M6_PRODUTO)
			nCntArray++
			cCnt := StrZero(nCntArray,2)
			aArray&cCnt := {}
			While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial("SMX")+cNum+cProduto
				If M6_ITEM == cItem
					AADD(aArray&cCnt,{ Str(M6_QUANT,9,2)," PECAS COM ",M6_COMPTO})
				EndIf
				dbSkip()
			End
		Else
			dbSkip()
		EndIF
	End
	cCnt := StrZero(nCntArray+1,2)
	aArray&cCnt := {}
	
	For nX := 1 TO Len(aArrayPro)
		If li > 58
			R820CabMed()
		EndIF
		@ li,009 PSay aArrayPro[nx]
		Li++
		Li++
		dbSelectArea("SMX")
		dbSetOrder(2)
		dbSeek( xFilial("SMX")+cNum+Subs(aArrayPro[nX],06,15) )
		While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial("SMX")+cNum+Subs(aArrayPro[nX],06,15)
			If li > 58
				R820CabMed()
			EndIF
			IF M6_ITEM == Subs(aArrayPro[nX],1,2)
				@ li,002 PSay M6_QUANT
				@ li,013 PSay "PECAS COM"
				@ li,023 PSay M6_COMPTO
				@ li,035 PSay M6_OBS
				li ++
			EndIF
			dbSkip()
		End
		li++
	Next nX
	@ li,001 PSay "--------------------------------------------------------------------------------"
EndIf
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R820CabMed ³ Autor ³ Jose Lucas           ³ Data ³ 25.01.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o cabecalho referentes as medidas do Pedido Filho. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R820CabMed(Void)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R820CabMed()

private cCabec1 := SM0->M0_NOME+"               RELACAO DE MEDIDAS             NRO :"
private cCabec2 := "MAQUINA                       FERRAMENTA               OPERACAO"

Li := 0

Li++
@Li,00 PSay REPLICATE("-",80)
Li++
@Li,00 PSay cCabec1
@Li,69 PSay SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
Li++
@Li,00 PSay REPLICATE("-",80)
Li++
Li++
Return Nil


Static Function ImpHist()



/*                                    -
Ferramentas
34
------------------------------------------------------------------------------
|Cod.Molde      |Descrição                      |Numero Cavidade              |
----------------|-------------------------------|-----------------------------|
|###############|###############################|#############################|
------------------------------------------------------------------------------
0               16                              48
9999999999999999999999999999999999999999999999999999999999999999999999999999999
1               17                              49                            79

-
Composto Utilizado
31
-------------------------------------------------------------------------------
|Codigo         |Descricao                     |Quantidade                    |
|###############|##############################|##############################|
------------------------------------------------------------------------------|
12345678901234567890123456789012345678901234567890123456789012345678901234567890
1         2         3         4         5         6         7         8
1               17                             48

-
Historico
-------------------------------------------------------------------------------
|Data      |            Posicao              |     Quantidade|           Saldo|
-----------|---------------------------------|---------------|-----------------
|##########|#################################|###############|################|
-------------------------------------------------------------------------------
9999999999999999999999999999999999999999999999999999999999999999999999999999999
1          12                                46              62


*/
dbSelectArea("SB1")
dbSetOrder(1)
dBseek(xFilial("SB1")+SC2->C2_PRODUTO)
_aAliSB1 := GetArea()
                           

//_cProdPa := SB1->B1_COD

If SB1->B1_TIPO == "PA"    // Primeira Via - Produto Acabado
	
	//	_lPrim   := .F.
	_lPassou := .T.
	_cProdPa := SB1->B1_COD
	_cMater  := ""
	_cSobra  := ""
	_cMed    := ""
	_cMed2   := ""
	_cHor    := ""
	_cVert   := ""
	_cFerr   := ""
	
	_cTipoFer := ""
	_cEspExt  := ""
	_cTmEst   := ""
	_cPosFaca := ""
	_cQtBat   := ""
	
	nEstru := 0
	aEstru := Estrut(SB1->B1_COD)
	
	dbSelectarea("SB1")
	RestArea(_aAliSB1)
	_cAliSB1 := Alias()
	_nOrdSB1 := IndexOrd()
	_nRecSB1 := Recno()
	
	For E:= 1 To Len(aEstru)
		
		dbSelectarea("SB1")
		dbSetOrder(1)
		If dbseek(xFilial("SB1")+aEstru[E,3])
			If SB1->B1_TIPO == "FR"
				_cFerr   := SB1->B1_COD
			ElseIf Alltrim(SB1->B1_GRUPO) == "MPVZ" .And. SB1->B1_LOCPAD == "25"
				_cMater := Substr(SB1->B1_COD,1,11)
			ElseIf SB1->B1_LOCPAD == "26"
				_cSobra := Substr(SB1->B1_COD,1,11)
			ElseIf Alltrim(SB1->B1_GRUPO) == "PIBK"
				_nTmp     := 0
				
				dbSelectArea("SG2")
				dbSetOrder(1)
				If dbSeek(xFilial("SG2")+SB1->B1_COD)
					
					_cChavSG2 := SG2->G2_PRODUTO
					While !Eof() .And. _cChavSG2 == SG2->G2_PRODUTO
						
						_cDesc := ""
						dbSelectArea("SZ9")
						dbSetOrder(1)
						If dbSeek(xFilial("SZ9")+SG2->G2_CODOPER)
							dbSelectArea("SYP")
							dbSetOrder(1)
							If dbSeek(xFilial("SYP")+SZ9->Z9_CODMEMO)
								_cChav := SZ9->Z9_CODMEMO
								
								_cDesc := ""
								nTam    := Len(SYP->YP_TEXTO)
								While !Eof() .And. _cChav == SYP->YP_CHAVE
									
									nPos := At("\13\10",Subs(SYP->YP_TEXTO,1,nTam+6))
									If ( nPos == 0 )
										_cDesc += RTrim(Subs(SYP->YP_TEXTO,1,nTam))
									Else
										_cDesc += Subs(SYP->YP_TEXTO,1,nPos-1)
									EndIf
									dbSkip()
								EndDo
							Endif
						Endif
						
						_nTmp += (SG2->G2_TEMPUNI * _nQuantOP)
						
						dbSelectArea("SG2")
						dbSkip()
					EndDo
					
					_cTempo :=  Transform(_nTmp,"@E 9,999.99")
					
					dbSelectArea("SG1")
					dbSetOrder(2)
					dbSeek(xFilial("SG1")+SB1->B1_COD)
					
					If SG1->G1_CORBLAN  == "V"
						_cVert   := "X"
						_cHor    := " "
					ElseIf SG1->G1_CORBLAN  == "H"
						_cVert   := " "
						_cHor    := "X"
					Else
						_cVert   := " "
						_cHor    := " "
					Endif
					
					_nQtBLL  := 1 / SG1->G1_QUANT
					_nQtBLL  := _nQtBLL * SG1->G1_QUANT
					_cQtBLL  := Transform(_nQtBLL,"@E 999")
					_cQtBLR  := Transform(SG1->G1_QTBLROL,"@E 999")
					_cMedRolC:= Alltrim(Transform(SG1->G1_MEDROLC,"@E 99.99"))
					_cMedRolL:= Alltrim(Transform(SG1->G1_MEDROLL,"@E 99.99"))
					_cMed    := SubSTR(_cMedRolC+" X "+_cMedRolL,1,15)
					_cMedBlC := Alltrim(Transform(SG1->G1_MEDBLAC,"@E 99.99"))
					_cMedBlL := Alltrim(Transform(SG1->G1_MEDBLAL,"@E 99.99"))
					_cMed2   := Substr(_cMedBlC+" X "+_cMedBlL,1,15)
				Endif
			Endif
		Endif
	Next E
	
	li++
	
	RestArea(_aAliSB1)
	If ALLTRIM(SB1->B1_GRUPO) == "PAV"
		_nTmp2 := 0
		dbSelectArea("SG2")
		dbSetOrder(1)
		If dbSeek(xFilial("SG2")+SB1->B1_COD)
			
			_cChavSG2 := SG2->G2_PRODUTO
			While !Eof() .And. _cChavSG2 == SG2->G2_PRODUTO
				
				dbSelectArea("SH4")
				dbSetOrder(1)
				If dbSeek(xFilial("SH4")+SG2->G2_FERRAM)
					If SH4->H4_TIPOFER == "S"
						_cTipoFer := "SIM"
					Else
						_cTipoFer := "NAO"
					Endif
					_cFerr   := SG2->G2_FERRAM
					_cEspExt := Alltrim(Transform(SH4->H4_ESPEXTR,"@E 999.99"))
					_cPosFaca:= Substr(SH4->H4_POSFACA,1,11)
					_cQtBat  := Alltrim(Transform(SH4->H4_QTBATID,"@E 99.99"))
				Endif
				
				_cDesc2 := ""
				dbSelectArea("SZ9")
				dbSetOrder(1)
				If dbSeek(xFilial("SZ9")+SG2->G2_CODOPER)
					dbSelectArea("SYP")
					dbSetOrder(1)
					If dbSeek(xFilial("SYP")+SZ9->Z9_CODMEMO)
						_cChav := SZ9->Z9_CODMEMO
						
						_cDesc2 := ""
						nTam    := Len(SYP->YP_TEXTO)
						While !Eof() .And. _cChav == SYP->YP_CHAVE
							
							nPos := At("\13\10",Subs(SYP->YP_TEXTO,1,nTam+6))
							If ( nPos == 0 )
								_cDesc2 += RTrim(Subs(SYP->YP_TEXTO,1,nTam))
							Else
								_cDesc2 += Subs(SYP->YP_TEXTO,1,nPos-1)
							EndIf
							dbSkip()
						EndDo
					Endif
				Endif
				
				_nTmp2 += (SG2->G2_TEMPUNI * _nQuantOP)
				
				dbSelectArea("SG2")
				dbSkip()
			EndDo
		Endif
		_cTempo2 :=  Transform(_nTmp2,"@E 9,999.99")
		_nCol    := 41
		
		/*
		|________________________________________|
		999999999999999999999999999999999999999999
		0		                                 41
		*/
		//		@Li,00 PSay " ________________________________________   ______________     _______________ "
		//		LI++
		//		@Li,00 PSay "|         FICHA TECNICA DO CORTE         | |  |  |  |  |  |   |_______|_______|"
		//		LI++
		//		@Li,00 PSay "|________________________________________| |  |  |  |  |  |   |_______|_______|"
		//		LI++
		//		@Li,00 PSay " ________________________________________  |__|__|__|__|__|   |_______|_______|"
		
		@Li,00 PSay " ________________________________________              ______________ "
		LI++
		@Li,00 PSay "|         FICHA TECNICA DO CORTE         |            (______________) "
		LI++
		@Li,00 PSay "|________________________________________|            |              | "
		LI++
		@Li,00 PSay " ________________________________________"
		@Li,_nCol PSay IIF (_cVert == "X","             |       |      | ","             |              | ")
		LI++
		@Li,00    PSay "| MATERIAL ................:"+_cMater
		@Li,_nCol PSay IIF (_cVert == "X","|            |       |      | ","|            |              | ")
		LI++
		@Li,00    PSay "| SOBRA LATERAL ...........:"+_cSobra
		@Li,_nCol PSay IIF (_cVert == "X","|            |       |      | ","|            |   ------->   | ")
		LI++
		@Li,00    PSay "| SOBRA FINAL DO ROLO......:"+_cMater
		@Li,_nCol PSay IIF (_cVert == "X","|            |      \ /     | ","|            |              | ")
		LI++
		@Li,00    PSay "| TEMPO MINIMO PARA CORTE..:"+_cTempo
		@Li,_nCol PSay IIF (_cVert == "X","|            |       V      | ","|            |              | ")
		LI++
		@Li,00    PSay "| QTDE BLANK NA LARGURA ...:"+_cQtBll
		@Li,_nCol PSay "|            |______________| "
		LI++
		@Li,00    PSay "| QTDE BLANK POR ROLO .....:"+_cQtBlR
		@Li,_nCol PSay "|     CORTAR O BLANK NESTA POSICAO    "
		LI++
		@Li,00    PSay "| MEDIDA DO BLANK .........:"+_cMed2
		@Li,_nCol PSay "|"
		LI++
		@Li,00    PSay "|                                        | "
		LI++
		@Li,00    PSay "|________________________________________| "
		LI++
		
		If _lPorta
			@Li,00 PSay REPLICATE("-",80)
		Else
			@Li ,   0 PSay __prtfatline()
		Endif
		
		li++
		@Li,00 PSay "|INSTRUCAO DE PROCESSO DE CORTE:"
		@Li,79 PSAY "|"
		Li++
		For I:= 1 to Len(_cDesc) Step 75
			@Li,00 PSay "|"+Substr(_cDesc,I,75)
			@Li,79 PSay "|"
			lI++
		Next I
		
		//@Li,00    PSAY "|"
		If _lPorta
			@Li,00 PSay REPLICATE("-",80)
		Else
			@Li ,   0 PSay __prtfatline()
		Endif
		
		//@Li,79    PSAY "|"
		
		Li++
		
		IF li > 57 //63
			Li := 0
			cabecOp()		// imprime cabecalho da OP
		EndIF
		
		@Li,00    PSay " ________________________________________"
		LI++
		@Li,00    PSay "|       FICHA TECNICA DO BALANCIM        |"
		LI++
		@Li,00    PSay "|________________________________________|"
		LI++
		@Li,00    PSay " ________________________________________"
		LI++
		@Li,00    PSay "| CODIGO DA FERRAMENTA.....:"+_cFerr
		@Li,_nCol PSay "|"
		LI++
		@Li,00    PSay "| FERRAMENTA C/EXTRATOR ?..:"+_cTipoFer
		@Li,_nCol PSay "|"
		LI++
		@Li,00    PSay "| ESPESSURA DO EXTRATOR....:"+_cEspExt
		@Li,_nCol PSay "|"
		LI++
		@Li,00    PSay "| TEMPO MIN.PARA ESTAMPAGEM:"+_cTempo2
		@Li,_nCol PSay "|"
		LI++
		@Li,00    PSay "| POSICAO DA M.P. NA FACA..:"+_cPosFaca
		@Li,_nCol PSay "|"
		LI++
		@Li,00    PSay "| QUANTIDADE DE BATIDAS  ..:"+_cQtBlR
		@Li,_nCol PSay "|"
		LI++
		@Li,00    PSay "|________________________________________| "
		LI++
		If _lPorta
			@Li,00 PSay REPLICATE("-",80)
		Else
			@Li ,   0 PSay __prtfatline()
		Endif
		
		li++
		@Li,00    PSay "|INSTRUCAO DE PROCESSO BALANCIM:"
		@Li,79    PSAY "|"
		Li++
		
		IF li > 57 //63
			Li := 0
			cabecOp()		// imprime cabecalho da OP
		EndIF
		
		For I:= 1 to Len(_cDesc2) Step 75
			@Li,00 PSay "|"+Substr(_cDesc2,I,75)
			@Li,79 PSay "|"
			lI++
		Next I
		
		//@Li,00 PSAY "|"
		If _lPorta
			@Li,00 PSay REPLICATE("-",80)
		Else
			@Li ,   0 PSay __prtfatline()
		Endif
		
		//@Li,79 PSAY "|"
		
		////
		IF li > 58 //63
			Li := 0
			cabecOp()		// imprime cabecalho da OP
		EndIF
		/*
		|Data       |            No. NF               |     Quantidade|           Saldo|
		999999999999 999999999999999999999999999999999 999999999999999 99999999999999999
		0           12                                46              62               79
		*/
		
		/*
		|Data       |           No. Lote              |     Quantidade|            Saldo|
		999999999999 999999999999999999999999999999999 999999999999999 99999999999999999
		0           12                                46              62               79
		*/
		
		
		Li+=2
		@Li,35 PSay "Historico"
		Li++
		
		If _lPrim
			If _lPorta
				@Li,00 PSay REPLICATE("-",80)
			Else
				@Li ,   0 PSay __prtfatline()
			Endif
			
			Li++
			@Li,00 PSay "|Data       |            No. NF               |     Quantidade|           Saldo|"
			Li++
			If _lPorta
				@Li,00 PSay REPLICATE("-",80)
			Else
				@Li ,   0 PSay __prtfatline()
			Endif
			
			Li++
			@Li,00 PSay "|"
			@Li,12 PSay "|"
			@Li,46 PSay "|"
			@Li,62 PSay "|"
			@Li,79 PSay "|"
			Li++
			If _lPorta
				@Li,00 PSay REPLICATE("-",80)
			Else
				@Li ,   0 PSay __prtfatline()
			Endif
			Li++
			@Li,00 PSay "|"
			@Li,12 PSay "|"
			@Li,46 PSay "|"
			@Li,62 PSay "|"
			@Li,79 PSay "|"
			Li++
			If _lPorta
				@Li,00 PSay REPLICATE("-",80)
			Else
				@Li ,   0 PSay __prtfatline()
			Endif
			
		Else
			If _lPorta
				@Li,00 PSay REPLICATE("-",80)
			Else
				@Li ,   0 PSay __prtfatline()
			Endif
			
			Li++
			@Li,00 PSay "|Data       |           No. Lote              |     Quantidade|           Saldo|"
			Li++
			//@Li,00 PSay REPLICATE("-",80)
			If _lPorta
				@Li,00 PSay REPLICATE("-",80)
			Else
				@Li ,   0 PSay __prtfatline()
			Endif
			
			Li++
			@Li,00 PSay "|"
			@Li,12 PSay "|"
			@Li,46 PSay "|"
			@Li,62 PSay "|"
			@Li,79 PSay "|"
			Li++
			If _lPorta
				@Li,00 PSay REPLICATE("-",80)
			Else
				@Li ,   0 PSay __prtfatline()
			Endif
			
			Li++
			@Li,00 PSay "|"
			@Li,12 PSay "|"
			@Li,46 PSay "|"
			@Li,62 PSay "|"
			@Li,79 PSay "|"
			Li++
			If _lPorta
				@Li,00 PSay REPLICATE("-",80)
			Else
				@Li ,   0 PSay __prtfatline()
			Endif
			
		Endif
	Else
		//		Li := Li+2
		@Li,34 PSay OemToAnsi("Ferramenta(s)")
		
		Li++
		If _lPorta
			@Li,00 PSay REPLICATE("-",80)
		Else
			@Li ,   0 PSay __prtfatline()
		Endif
		
		Li++
		@Li,00 PSay "|Cod.Molde      |Descrição                      |Numero Cavidade               |"
		Li++
		If _lPorta
			@Li,00 PSay REPLICATE("-",80)
		Else
			@Li ,   0 PSay __prtfatline()
		Endif
		
		Li++
		
		For E:= 1 To Len(aEstru)
			
			dbSelectarea("SB1")
			dbSetOrder(1)
			If dbseek(xFilial("SB1")+aEstru[E,3])
				If SB1->B1_TIPO == "FR"
					@Li,00 PSay "|"+ SB1->B1_COD
					@Li,16 PSay "|"+ Substr(SB1->B1_DESC,1,30)
					@Li,48 PSay "|"+ SB1->B1_CAV
					@Li,79 PSay "|"
					Li++
					If _lPorta
						@Li,00 PSay REPLICATE("-",80)
					Else
						@Li ,   0 PSay __prtfatline()
					Endif
					
					Li++
					_nPeso   := SB1->B1_PESO
					_cMedida := SB1->B1_AREAPEC
					//            I:= Len(aEstru)
					_cFerr   := Substr(SB1->B1_COD,1,11)
				Endif
			Endif
		Next E
		
		li++
		
		@Li,31 PSay "Composto Utilizado"
		Li++
		
		If _lPorta
			@Li,00 PSay REPLICATE("-",80)
		Else
			@Li ,   0 PSay __prtfatline()
		Endif
		
		Li++
		@Li,00 PSay "|Codigo         |Descricao                                                     |"
		Li++
		If _lPorta
			@Li,00 PSay REPLICATE("-",80)
		Else
			@Li ,   0 PSay __prtfatline()
		Endif
		
		Li++
		
		_cCod := ""
		dbSelectArea("SD4")
		dbSetOrder(2)
		If dbSeek(xFilial("SC2")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD)
			_cChavSD4 := Substr(SD4->D4_OP,1,8)
			_lCod := .F.
			While !eof() .And. _cChavSD4 == Substr(SD4->D4_OP,1,8)
				
				If !_lCod
					_lCod := .t.
				Else
					If _cCod == SD4->D4_COD
						dbSelectArea("SD4")
						dbSkip()
						Loop
					Endif
				Endif
				/*
				If (SC2->C2_DATPRI > SD4->D4_DATA)
				dbSelectArea("SD4")
				dbSkip()
				Loop
				Endif
				*/
				dbSelectArea("SB1")
				dbSetOrder(1)
				If dbSeek(xFilial("SB1")+SD4->D4_COD)
					If Alltrim(SB1->B1_GRUPO) == "PIC"
						@Li,00 PSay "|"+SB1->B1_COD
						@Li,16 PSay "|"+SB1->B1_DESC
						@Li,79 PSay "|"
						Li++
					Endif
				Endif
				
				_cCod := SD4->D4_COD
				dbSelectArea("SD4")
				dbSkip()
			EndDo
			
			If _lPorta
				@Li,00 PSay REPLICATE("-",80)
			Else
				@Li ,   0 PSay __prtfatline()
			Endif
			
			Li++
		Endif
		
		Li +=2
		
		IF li > 57 //63
			Li := 0
			cabecOp()		// imprime cabecalho da OP
		EndIF
		
		@Li,35 PSay "Historico"
		Li++
		If _lPorta
			@Li,00 PSay REPLICATE("-",80)
		Else
			@Li ,   0 PSay __prtfatline()
		Endif
		
		Li++
		@Li,00 PSay "|Data       |             Posicao             |     Quantidade|           Saldo|"
		Li++
		If _lPorta
			@Li,00 PSay REPLICATE("-",80)
		Else
			@Li ,   0 PSay __prtfatline()
		Endif
		
		Li++
		If SC2->C2_QUJE > 0
			_nQtdeProd  := 0
			_nSaldoOp   := 0
			dbSelectArea("SD3")
			dbSetOrder(1)
			If dbSeek(xFilial("SC2")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+SC2->C2_PRODUTO+SC2->C2_LOCAL)
				_cChavSD3 := SD3->D3_OP + SD3->D3_COD + SD3->D3_LOCAL
				While !eof() .And. _cChavSD3 == SD3->D3_OP + SD3->D3_COD + SD3->D3_LOCAL
					
					If SD3->D3_ESTORNO == "S"
						dbSelectArea("SD3")
						dbSkip()
						Loop
					Endif
					
					_nQtdeProd  := _nQtdeProd + SD3->D3_QUANT + SD3->D3_PERDA
					_nSaldoOp   := SC2->C2_QUANT - _nQtdeProd
					
					@Li,00 PSay "|"+DTOC(SD3->D3_EMISSAO)
					@Li,12 PSay "|"
					@Li,46 PSay "|"+Transform(SD3->D3_QUANT,PesqPict("SD3","D3_QUANT"))
					@Li,62 PSay "|"+Transform(_nSaldoOp,PesqPict("SC2","C2_QUANT"))
					@Li,79 PSay "|"
					Li++
					
					If _lPorta
						@Li,00 PSay REPLICATE("-",80)
					Else
						@Li ,   0 PSay __prtfatline()
					Endif
					
					Li++
					
					IF li > 57 //63
						Li := 0
						cabecOp()		// imprime cabecalho da OP
					EndIF
					
					dbSelectArea("SD3")
					dbSkip()
				EndDo
			Endif
		Endif
		_nCont := 0
		For i:= Li to 58
			_nCont+= 1
			If _nCont == 10
				i := 63
			Endif
			@Li,00 PSay "|"
			@Li,12 PSay "|"
			@Li,46 PSay "|"
			@Li,62 PSay "|"
			@Li,79 PSay "|"
			Li++
			
			If _lPorta
				@Li,00 PSay REPLICATE("-",80)
			Else
				@Li ,   0 PSay __prtfatline()
			Endif
			
			Li++
		Next i
	Endif
ElseIf Alltrim(SB1->B1_GRUPO) == "PIPB"
	
	a:= 1
	//	If !_lPrim .And. _lPassou
	//		_lPrim := .T.
	//		_lPassou := .F.
	//	Endif
	
	/*
	-
	Composto
	36
	-------------------------------------------------------------------------------
	|Codigo          |Descricao                     |Quantidade                   |
	|----------------|------------------------------|-----------------------------|
	|################|##############################|#############################|
	-------------------------------------------------------------------------------
	9999999999999999999999999999999999999999999999999999999999999999999999999999999
	1                18                             49
	
	
	0        1         2         3         4         5
	123456789012345678901234567890123456789012345678901234
	---------------------------------------------------------------------------
	|Posicao de Estoque / Data   |        Operador       | Data da Liberacao  |
	|----------------------------|-----------------------|--------------------|
	|                            |                       |                    |
	---------------------------------------------------------------------------
	13                           42                      66
	-
	Prensas
	-------------------------------------------------------------------------------
	|Nº.Cavidade  |N.Prensa  |Data Entrada   |Nº.Turnos   |   ES   |   UDUF       |
	--------------|----------|---------------|------------|--------|--------------|
	|#############|##########|###############|############|########|##############|
	-------------------------------------------------------------------------------
	9999999999999999999999999999999999999999999999999999999999999999999999999999999
	1             15         26              42           55       64             79
	
	
	-
	Historico
	-------------------------------------------------------------------------------
	|Data      |           Qtde Produzida|            Rejeito|               Saldo|
	-----------|-------------------------|-------------------|---------------------
	|##########|#########################|###################|####################|
	-------------------------------------------------------------------------------
	9999999999999999999999999999999999999999999999999999999999999999999999999999999
	1          12                        38                  58                   79
	
	*/
	
	Li+=2
	
	nEstru := 0
	aEstru := Estrut(_cProdPa)
	
	dbSelectarea("SB1")
	_cAliSB1 := Alias()
	_nOrdSB1 := IndexOrd()
	_nRecSB1 := Recno()
	
	//	Li := Li+2
	@Li,34 PSay OemToAnsi("Ferramenta(s)")
	
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	@Li,00 PSay "|Cod.Molde       |Descrição                      |Numero Cavidade              |"
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	
	For E:= 1 To Len(aEstru)
		
		dbSelectarea("SB1")
		dbSetOrder(1)
		If dbseek(xFilial("SB1")+aEstru[E,3])
			If SB1->B1_TIPO == "FR"
				@Li,00 PSay "|"+ SB1->B1_COD
				@Li,17 PSay "|"+ Substr(SB1->B1_DESC,1,30)
				@Li,49 PSay "|"+ SB1->B1_CAV
				@Li,79 PSay "|"
				Li++
				If _lPorta
					@Li,00 PSay REPLICATE("-",80)
				Else
					@Li ,   0 PSay __prtfatline()
				Endif
				
				Li++
				_nPeso   := SB1->B1_PESO
				_cMedida := SB1->B1_AREAPEC
				_cCav  := SB1->B1_CAV
			Endif
		Endif
	Next E
	
	dbSelectArea("SB1")
	dbSetOrder(_nOrdSB1)
	dbGoto(_nRecSB1)
	li++
	
	IF li > 57 //63
		Li := 0
		cabecOp()		// imprime cabecalho da OP
	EndIF
	
	@Li,36 PSay "Composto"
	
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	@Li,00 PSay "|Codigo           |Descricao                     |Quantidade                   |"
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	
	_cCod := ""
	dbSelectArea("SD4")
	_cAliSD4 := Alias()
	_nOrdSD4 := IndexOrd()
	_nRecSD4 := Recno()
	dbSetOrder(2)
	If dbSeek(xFilial("SC2")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD)
		_cChavSD4 := Substr(SD4->D4_OP,1,8)
		_lCod := .F.
		While !eof() .And. _cChavSD4 == Substr(SD4->D4_OP,1,8)
			
			If !_lCod
				_lCod := .t.
			Else
				If _cCod == SD4->D4_COD
					dbSelectArea("SD4")
					dbSkip()
					Loop
				Endif
			Endif
			
			If (SC2->C2_DATPRI > SD4->D4_DATA)
				dbSelectArea("SD4")
				dbSkip()
				Loop
			Endif
			
			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+SD4->D4_COD)
				If Alltrim(SB1->B1_GRUPO) == "PIC"
					@Li,00 PSay "|"+SB1->B1_COD
					@Li,18 PSay "|"+Substr(SB1->B1_DESC,1,30)
					@Li,49 PSay "|"+Transform(SD4->D4_QUANT,PesqPict("SD4","D4_QUANT"))
					@Li,79 PSay "|"
					Li++
				Endif
			Endif
			
			_cCod := SD4->D4_COD
			dbSelectArea("SD4")
			dbSkip()
		EndDo
		
		If _lPorta
			@Li,00 PSay REPLICATE("-",80)
		Else
			@Li ,   0 PSay __prtfatline()
		Endif
		
		Li++
	Endif
	
	dbSelectArea(_cAliSD4)
	dbSetOrder(_nOrdSD4)
	dbGoto(_nRecSD4)
	
	dbSelectArea("SB1")
	dbSetOrder(_nOrdSB1)
	dbGoto(_nRecSB1)
	
	Li := Li+1
	
	IF li > 57 //63
		Li := 0
		cabecOp()		// imprime cabecalho da OP
	EndIF
	
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	@Li,00 PSay "|Posicao de Estoque / Data   |        Operador       | Data da Liberacao       |"
	Li++
	@Li,00 PSay "|----------------------------|-----------------------|-------------------------|"
	Li++
	@Li,00 PSay "|                            |                       |                         |"
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	
	Li := Li+2
	
	@Li,36 PSay "Prensas"
	
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	@Li,00 PSay "|N. Cavidade   |N.Prensa  |Data Entrada   |N. Turnos   |   ES   |   UDUF       |"
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	
	@Li,00 PSay "|"+ _cCav
	@Li,15 PSay "|"
	@Li,26 PSay "|"+DTOC(SC2->C2_DATPRI)
	@Li,42 PSay "|  1  2  3"
	@Li,55 PSay "|"
	@Li,64 PSay "|"
	@Li,79 PSay "|"
	
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	@Li,00 PSay "|              |          |               |            |        |              |"
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	
	Li := Li+2
	
	IF li > 57 //63
		Li := 0
		cabecOp()		// imprime cabecalho da OP
	EndIF
	
	@Li,35 PSay "Historico"
	
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	@Li,00 PSay "|Data       |           Qtde Produzida|            Rejeito|               Saldo|"
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	
	If SC2->C2_QUJE > 0
		
		_nQtdeProd  := 0
		_nSaldoOp   := 0
		dbSelectArea("SD3")
		dbSetOrder(1)
		If dbSeek(xFilial("SC2")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+SC2->C2_PRODUTO+SC2->C2_LOCAL)
			_cChavSD3 := SD3->D3_OP + SD3->D3_COD + SD3->D3_LOCAL
			While !eof() .And. _cChavSD3 == SD3->D3_OP + SD3->D3_COD + SD3->D3_LOCAL
				
				If SD3->D3_ESTORNO == "S"
					dbSelectArea("SD3")
					dbSkip()
					Loop
				Endif
				
				_nQtdeProd  := _nQtdeProd + SD3->D3_QUANT + SD3->D3_PERDA
				_nSaldoOp   := Round((SC2->C2_QUANT - _nQtdeProd),2)
				
				@Li,00 PSay "|"+DTOC(SD3->D3_EMISSAO)
				@Li,12 PSay "|"+Transform(Round(SD3->D3_QUANT,2),PesqPict("SD3","D3_QUANT"))
				@Li,38 PSay "|"+Transform(SD3->D3_PERDA,PesqPict("SC2","C2_QUANT"))
				@Li,58 PSay "|"+Transform(_nSaldoOp,PesqPict("SC2","C2_QUANT"))
				@Li,79 PSay "|"
				Li++
				
				If _lPorta
					@Li,00 PSay REPLICATE("-",80)
				Else
					@Li ,   0 PSay __prtfatline()
				Endif
				
				Li++
				
				IF li > 57 //63
					Li := 0
					cabecOp()		// imprime cabecalho da OP
				EndIF
				
				dbSelectArea("SD3")
				dbSkip()
			EndDo
		Endif
	Endif
	
	_nCont := 0
	I:= 0
	For i:= Li to 57
		_nCont+= 1
		If _nCont == 6
			i := 57
		Endif
		@Li,00 PSay "|"
		@Li,12 PSay "|"
		@Li,38 PSay "|"
		@Li,58 PSay "|"
		@Li,79 PSay "|"
		Li++
		
		If _lPorta
			@Li,00 PSay REPLICATE("-",80)
		Else
			@Li ,   0 PSay __prtfatline()
		Endif
		
		
		Li++
	Next i
ElseIf Alltrim(SB1->B1_GRUPO) == "PIPF"
		
	/*
	Ferramentas
	34
	------------------------------------------------------------------------------
	|Cod.Peça       |Descrição                      |Numero Cavidade              |
	----------------|-------------------------------|-----------------------------|
	|###############|###############################|#############################|
	------------------------------------------------------------------------------
	9999999999999999999999999999999999999999999999999999999999999999999999999999999
	1               17                              49                            79
	
	
	-
	Preparação
	34
	------------------------------------------------------------------------------
	|Cod.Pasy       |Quantidade |Peso Unid. | Peso Total|Ferramenta |    Tipo     |
	----------------|-----------|-----------|-----------|-----------|-------------| //    FERRAMENTA              TIPO
	|###############|###########|###########|###########|###########|#############| //(MATRIZ OU VAZADOR),( TRAFILA OU BALANCIN )
	------------------------------------------------------------------------------
	9999999999999999999999999999999999999999999999999999999999999999999999999999999
	1               17          29          41          53          65            79
	38
	
	-
	------------------------------------------------------------------------------
	|Numero Ferramenta|Medida     |Ferramenta      |Tipo                          |
	------------------|-----------|----------------|------------------------------|
	|#################|###########|################|##############################|
	-------------------------------------------------------------------------------
	9999999999999999999999999999999999999999999999999999999999999999999999999999999
	1                 19          31               48                             79
	
	-
	Historico
	-------------------------------------------------------------------------------
	|Data      |           Qtde Produzida|            Rejeito|               Saldo|
	-----------|-------------------------|-------------------|---------------------
	|##########|#########################|###################|####################|
	-------------------------------------------------------------------------------
	9999999999999999999999999999999999999999999999999999999999999999999999999999999
	1          12                        38                  58                   79
	
	*/            
	_cProdPre := SB1->B1_COD   
	_nKgCil   := 0	
	nEstru    := 0
	aEstru    := Estrut(_cProdPa)
	
	dbSelectarea("SB1")
	_cAliSB1 := Alias()
	_nOrdSB1 := IndexOrd()
	_nRecSB1 := Recno()

	Li++
	@Li,00 PSay "Cod.Pasy        Cod.Molde              Numero Cavidade            Nr Lote       "
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li,00 PSay __prtfatline()
	Endif
	
	Li++
	
	For E:= 1 To Len(aEstru)
		
		dbSelectarea("SB1")
		dbSetOrder(1)
		If dbseek(xFilial("SB1")+aEstru[E,3])
			If SB1->B1_TIPO == "FR"
				@Li,00 PSay _cProdPa
				@Li,17 PSay SB1->B1_COD
				@Li,39 PSay SB1->B1_CAV
				@Li,79 PSay ""
				Li++
				_nPeso   := SB1->B1_PESO
				_cMedida := SB1->B1_AREAPEC
				//            I:= Len(aEstru)

				If _lPorta
					@Li,00 PSay REPLICATE("-",80)
				Else
					@Li ,   0 PSay __prtfatline()
				Endif
						
				Li++

			Endif
		Endif

	Next E
	
	dbSelectArea("SB1")
	dbSetOrder(_nOrdSB1)
	dbGoto(_nRecSB1)
	
	Li := Li+1
	
	IF li > 57 //63
		Li := 0
		cabecOp()		// imprime cabecalho da OP
	EndIF
	
	@Li,00 PSay "Material                     | Kg Cilindro                   | Prensa           "
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li,00 PSay __prtfatline()
	Endif
	
	Li++

	dbSelectArea("SG1")
	dbSetOrder(2)	
	dbSeek(xFilial("SG1")+_cProdPre)
               
	If SG1->G1_UMPF == "G "                       
		_nPesoPre1 := SG1->G1_PEPFFIM /1000
	ElseIf SG1->G1_UMPF == "KG"                       
		_nPesoPre1 := SG1->G1_PEPFFIM /1000
	Else	                        
		_nPesoPre1 := SG1->G1_PEPFFIM
	Endif

	If SG1->G1_UMPF == "G "                       
		_nPesoPre2 := SG1->G1_PEMATF2 /1000
	ElseIf SG1->G1_UMPF == "KG"                       
		_nPesoPre2 := SG1->G1_PEMATF2 /1000
	Else	                        
		_nPesoPre2 := SG1->G1_PEMATF2
	Endif                                   
	
//	_nPesoPre := SG1->G1_PEPFFIM - SG1->G1_PEPFINI
                
    dbSelectArea("SZE")
    dbsetOrder(1)
    dbSeek(xFilial("SZE")+SG1->G1_TPRECUR)

	_nKgCil2 := 0
	_nKgCil1 := SZE->ZE_PESOCAB + (SC2->C2_QUANT*_nPesoPre1)
	If _nPesoPre2 > 0
		_nKgCil2 := SZE->ZE_PESOCAB + (SC2->C2_QUANT*_nPesoPre2)
	Endif	
    
	@Li,00 PSay _cMater        
	@Li,30 PSay _nKgCil1 + _nKgCil2   Picture "@E 9,999,999.99"
		
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif	

	Li++
	Li++
	        
	If SZE->ZE_TIPO == "1"
		@Li,00 PSay "Balancim [   ]                 Trafila [ 1 ]                   Cilindro [   ]    "
	ElseIf 	SZE->ZE_TIPO == "2"                                                                        
		@Li,00 PSay "Balancim [   ]                 Trafila [ 2 ]                   Cilindro [   ]    "	
	ElseIf 	SZE->ZE_TIPO == "3"                                                                        
		@Li,00 PSay "Balancim [   ]                 Trafila [ 3 ]                   Cilindro [   ]    "	
	ElseIf 	SZE->ZE_TIPO == "4"
		@Li,00 PSay "Balancim [ X ]                 Trafila [   ]                   Cilindro [   ]    "
	ElseIf 	SZE->ZE_TIPO == "5"
		@Li,00 PSay "Balancim [   ]                 Trafila [   ]                   Cilindro [ X ]    "
	ElseIf 	SZE->ZE_TIPO == "6"
		@Li,00 PSay "Balancim [   ]                 Trafila [2 + 3 ]                Cilindro [   ]    "
	Else                                                                                               
		@Li,00 PSay "Balancim [   ]                 Trafila [   ]                   Cilindro [   ]    "
	Endif	
	
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	Li++
		
	@Li,00 PSay "Matriz/Vazador               | Qte Pre-Formado               | Qte Pecas        "
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif

	Li++

	@Li,00 PSay Alltrim(SG1->G1_NOMEFER) +" + "+Alltrim(SG1->G1_NOMMAT2)
	@Li,34 PSay SG1->G1_QUANT	Picture "@E 9,999,999.99"
	@Li,60 PSay SC2->C2_QUANT	Picture "@E 9,999,999.99"

	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	
	IF li > 57 //63
		Li := 0
		cabecOp()		// imprime cabecalho da OP
	EndIF
		              
	Li++
	@Li,00 PSay "Peso Pre-Formado 1:"
	@Li,20 PSay SG1->G1_PEPFINI	Picture "@E 99.99999" + " " +SG1->G1_UMPI
	@Li,30 PSAY " ATE "
	@Li,36 PSAY SG1->G1_PEPFFIM	Picture "@E 99.99999" + " " +SG1->G1_UMPI
//	@Li,50 PSay " MASSA "
//	@Li,58 PSay _nKgCil1   Picture "@E 9,999,999.99"
	Li++

	@Li,00 PSay "Peso Pre-Formado 2:"
	@Li,20 PSay SG1->G1_PEMATI2	Picture "@E 9,999.99" + " " +SG1->G1_UMPF   //20
	@Li,30 PSAY " ATE "  //42
	@Li,36 PSAY SG1->G1_PEMATF2	Picture "@E 9,999.99" + " " +SG1->G1_UMPF   // 
//	@Li,50 PSay " MASSA "
//	@Li,58 PSay _nKgCil2   Picture "@E 9,999,999.99"
	Li++

	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif

	Li++
	Li++

	@Li,00 PSay "Medida De :"
	@Li,20 PSay SG1->G1_MEPFINI	//Picture "@E 9,999.99"
	Li++
	@Li,00 PSay "Medida Ate :"
	@Li,20 PSay SG1->G1_MEPFFIM	//Picture "@E 9,999.99"

	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif

	IF li > 57
		Li := 0
		cabecOp()		// imprime cabecalho da OP
	EndIF
	Li++
	Li++
	@Li,00 PSay "Ficha Tecnica    :"
	@Li,20 PSay SG1->G1_FICHTEC
	@Li,42 PSay " REV "
	@Li,50 PSay SG1->G1_REVFICH

	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif

	Li++
	Li++
	@Li,00 PSay "Foram Cortados   :"
	
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	Li++

	@Li,00 PSay "Observacao       :"    
	
	Li++
	@Li,00 PSay ""

    li++
   	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif

	li += 5

	@Li,00 PSay "Assinatura Responsavel : _______________________________"
	
	li += 2
	
   	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
ElseIf Alltrim(SB1->B1_GRUPO) == "PIPM"
	
	_cDesenIn := SB1->B1_DESENIN
	_cRevDes  := SB1->B1_REVDESE
	_cProcIn  := SB1->B1_PROCEIN
	_cRevProc := SB1->B1_REVPROC
	
	/*                                    -
	Ferragem
	34
	------------------------------------------------------------------------------
	|            |Data Liberacao |Qtde Media Diaria |Num.Lote Inserto|            |
	-------------|---------------|------------------|----------------|------------|
	|            |###############|##################|################|            |
	------------------------------------------------------------------------------
	9999999999999999999999999999999999999999999999999999999999999999999999999999999
	1            14              30                 49               67          79
	
	
	
	------------------------------------------------------------------------------
	|                   |Num. Lote Adesivo| Num. Lote Adesivo|                    |
	--------------------|-----------------|------------------|--------------------|
	|                   |#################|##################|                    |
	------------------------------------------------------------------------------
	9999999999999999999999999999999999999999999999999999999999999999999999999999999
	1                    22                40                 59                  79
	
	
	------------------------------------------------------------------------------
	|Observacao:                                                                  |
	|                                                                             |
	|                                                                             |
	------------------------------------------------------------------------------|
	|                 |Visual Inicio |      |                  | Visual Fim |     |
	|Data  |Quantidade|  AP   |  RP  | Visto||Data  |Quantidade|  AP  |  RP |Visto|
	------------------------------------------------------------------------------|
	|######|##########|#######|######|######|#######|##########|######|#####|#####|
	-------------------------------------------------------------------------------
	9999999999999999999999999999999999999999999999999999999999999999999999999999999
	1      8          19      27     34     41      49         60     67    73    79
	
	*/
	
	//*********************************************************************************************
	
	Li+=3
	
	nEstru := 0
	aEstru := Estrut(_cProdPa)
	
	dbSelectarea("SB1")
	_cAliSB1 := Alias()
	_nOrdSB1 := IndexOrd()
	_nRecSB1 := Recno()
	
	Li := Li+2
	@Li,34 PSay OemToAnsi("Ferramenta(s)")
	
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	@Li,00 PSay "|Cod.Molde      |Descrição                      |Numero Cavidade              |"
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	
	For E:= 1 To Len(aEstru)
		
		dbSelectarea("SB1")
		dbSetOrder(1)
		If dbseek(xFilial("SB1")+aEstru[E,3])
			If SB1->B1_TIPO == "FR"
				@Li,00 PSay "|"+ SB1->B1_COD
				@Li,17 PSay "|"+ Substr(SB1->B1_DESC,1,30)
				@Li,49 PSay "|"+ SB1->B1_CAV
				@Li,79 PSay "|"
				Li++
				If _lPorta
					@Li,00 PSay REPLICATE("-",80)
				Else
					@Li ,   0 PSay __prtfatline()
				Endif
				
				Li++
				_nPeso   := SB1->B1_PESO
				_cMedida := SB1->B1_AREAPEC
				_cCav  := SB1->B1_CAV
				//            I:= Len(aEstru)
			Endif
		Endif
	Next E
	
	dbSelectArea("SB1")
	dbSetOrder(_nOrdSB1)
	dbGoto(_nRecSB1)
	li+=2
	
	@Li,31 PSay "Ferragem"
	
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	@Li,00 PSay "|             |Data Liberacao |Qtde Media Diaria |Num.Lote Inserto|            |"
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	
	@Li,00 PSay "|             |               |                  |                |            |"
	Li++
	@Li,00 PSay "|             |               |                  |                |            |"
	
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	
	Li+=2
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	
	@Li,00 PSay "|                    |Num. Lote Adesivo| Num. Lote Adesivo| Num. Lote Adesivo  |"
	Li++
	@Li,00 PSay "|                    |X 01 :           | X 02 :           |                    |"
	Li++
	
	@Li,00 PSay "|                    |                 |                  |                    |"
	
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	
	/*
	|                    |                 |                  |                    |
	99999999999999999999 99999999999999999 999999999999999999 99999999999999999999 99999999999999999999
	0                    21                39                 58
	*/
	@Li,00 PSay "|No. Desenho :       |"+_cDesenIn
	@Li,39 PSay "|No. Procedimento: |"+_cProcIn
	Li++
	@Li,00 PSay "|Revisao :           |"+_cRevDes
	@Li,39 PSay "|Revisao :         |"+_cRevProc
	Li+=2
	
	//*********************************************************************************************
	
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	
	@Li,00 PSay "|Observacao:                                                                   |"
	Li++
	@Li,00 PSay "|                                                                              |"
	Li++
	@Li,00 PSay "|                                                                              |"
	Li++
	If _lPorta
		@Li,00 PSay REPLICATE("-",80)
	Else
		@Li ,   0 PSay __prtfatline()
	Endif
	
	Li++
	@Li,00 PSay "|                  |Visual Inicio |      |                  | Visual Fim |     |"
	Li++
	@Li,00 PSay "|Data   |Quantidade|  AP   |  RP  | Visto||Data  |Quantidade|  AP  |  RP |Visto|"
	Li++
	
	_nCont := 0
	For i:= Li to 58
		_nCont+= 1
		If _nCont == 06
			i := 58
		Endif
		@Li,00 PSay "|"
		@Li,08 PSay "|"
		@Li,19 PSay "|"
		@Li,27 PSay "|"
		@Li,34 PSay "|"
		@Li,41 PSay "|"
		@Li,49 PSay "|"
		@Li,60 PSay "|"
		@Li,67 PSay "|"
		@Li,73 PSay "|"
		@Li,79 PSay "|"
		
		Li++
		
		If _lPorta
			@Li,00 PSay REPLICATE("-",80)
		Else
			@Li ,   0 PSay __prtfatline()
		Endif
		
		Li++
		
	Next i
Endif

Return
