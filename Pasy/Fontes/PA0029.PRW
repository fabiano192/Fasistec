#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Pa0029   ³ Autor ³ Alexandro da Silva    ³ Data ³ 27.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao Das Ordens de Producao com os pedidos de venda      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function Pa0029()

SetPrvt("TITULO,CSTRING,WNREL,CDESC,AORD,TAMANHO")
SetPrvt("ARETURN,CPERG,NLASTKEY,LIMITE,NOMEPROG,NTIPO")
SetPrvt("CPRODUTO,CTOTAL,NTOTORI,NTOTSALDO,CBTXT,CBCONT")
SetPrvt("LI,M_PAG,NORDEM,CABEC1,CABEC2,CSEEK")
SetPrvt("CSTATUS,")

Private titulo 	    := "Relacao Das Ordens de Producao e os pedidos de venda Por Produto"
Private cString	    := "SC2"
Private wnrel	    := "PA0029"
Private cDesc		:= "Este programa ira imprimir a Rela‡„o das Ordens de Produ‡„o."
//Private aOrd    	:= {"Por Produto    ","Por Cliente"}
Private aOrd    	:= {}
Private tamanho	    := "M"
PRIVATE aReturn     := {"Zebrado",1,"Administracao", 1, 2, 1, "",1 }
PRIVATE cPerg       := "PA0029"
PRIVATE nLastKey := 0

pergunte("PA0029",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// Da OP                                 ³
//³ mv_par02        	// Ate a OP                              ³
//³ mv_par03        	// Do Produto                            ³
//³ mv_par04        	// Ate o Produto                         ³
//³ mv_par05        	// Emissao O.P. De                       ³
//³ mv_par06        	// Emissao O.P. Ate                      ³
//³ mv_par07        	// Entrega O.P. De                       ³
//³ mv_par08        	// Entrega O.P. Ate                      ³
//³ mv_par09        	// Pedido  de                            ³
//³ mv_par10        	// Pedido  Ate                           ³
//³ mv_par11        	// Cliente de                            ³
//³ mv_par12        	// Cliente Ate                           ³
//³ mv_par13        	// Entrega Pedido De                     ³
//³ mv_par14        	// Entrega Pedido Ate                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,,,Tamanho)

If nLastKey = 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private CbTxt
Private CbCont,cabec1,cabec2
Private limite   := 132
Private nomeprog := "PA0029"
Private nTipo    := 0
Private cProduto := SPACE(LEN(SC2->C2_PRODUTO))
Private cStatus,nOrdem,cSeek
Private cTotal:="",nTotOri:=0,nTotSaldo:=0 // Totalizar qdo ordem for por produto

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

nTipo := IIF(aReturn[4]==1,15,18)
nOrdem := aReturn[8]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//titulo += IIf(nOrdem==1," - Por O.P.",IIf(nOrdem==2," - Por Produto",""))
cabec1 := "Ord.de Prod Cliente Lj Pedido IT Produto Cliente Emissao  Entrega    Saldo Pedido     Saldo O.P.  Saldo Estoque  Qtde Faltante"
cabec2 := ""

aStru := {}
AADD(aStru,{"OP"       , "C" , 11, 0 })
AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
AADD(aStru,{"DESCPRO"  , "C" , 30, 0 })
AADD(aStru,{"PRODCLI"  , "C" , 15, 0 })
AADD(aStru,{"SDOOP"    , "N" , 14, 2 })
AADD(aStru,{"CLIENTE"  , "C" ,  6, 0 })
AADD(aStru,{"LOJA"     , "C" ,  2, 0 })
AADD(aStru,{"PEDIDO"   , "C" ,  6, 0 })
AADD(aStru,{"ITEMPED"  , "C" ,  2, 0 })
AADD(aStru,{"EMISSAO"  , "D" ,  8, 0 })
AADD(aStru,{"ENTREGA"  , "D" ,  8, 0 })
AADD(aStru,{"QTDEPED"  , "N" , 14, 2 })
AADD(aStru,{"SDOPED"   , "N" , 14, 2 })
AADD(aStru,{"SDOEST"   , "N" , 14, 2 })

_cArqtrb := CriaTrab(aStru,.T.)
//_cIndTRB := "PRODUTO+PEDIDO+ITEMPED+DTOS(ENTREGA)"
_cIndTRB := "PRODUTO+DTOS(ENTREGA)+PEDIDO+ITEMPED"

dbUseArea(.T.,,_cArqTRB,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",_cArqTRB,_cIndTRB,,,"Criando Trabalho...")

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| GeraTRB(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| ImpOrd2(@_lFim) }

dbSelectArea("TRB")
IndRegua("TRB",_cArqTRB,_cIndTRB,,,"Criando Trabalho...")

Private _cTitulo01 := 'Imprimindo'
RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

dbSelectArea("TRB")
dbCloseArea("TRB")
fErase(_cArqTRB+".DBF")
FErase(_cArqTRB+OrdBagExt())

Return


Static Function GeraTRB(_lFim)

/*
Ord.de Prod Cliente Lj Pedido IT Produto Cliente Emissao  Entrega    Saldo Pedido     Saldo O.P.  Saldo Estoque  Qtde Faltante
99999999999 999999  99 999999 99 999999999999999 99999999 9999999  99999999999999 99999999999999 99999999999999 99999999999999
0           12      20 23     30 33              49       58       67             82             97             112
*/

dbSelectArea("SB1")
dbSetOrder(2)
dbSeek(xFilial("SB1")+"PA"+MV_PAR03,.T.)

ProcRegua(LastRec())

While !Eof() .And. SB1->B1_TIPO == "PA" .And. SB1->B1_COD <= MV_PAR04
	
	IncProc()
	
	If _lFim
		Alert("Cancelado pelo Usuario!!!!!")
		Return
	Endif
	
	_cProduto := SB1->B1_COD
	_cDesc    := SB1->B1_DESC
	
	dbSelectArea("SC2")
	dbSetOrder(2)
	If dbSeek(xFilial("SC2")+_cProduto)
		
		While !Eof() .And. SC2->C2_PRODUTO == _cProduto
			
			_cOp := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
			
			If _cOp             < MV_PAR01 .Or. _cOP            > MV_PAR02 .Or.;
				SC2->C2_EMISSAO < MV_PAR05 .Or. SC2->C2_EMISSAO > MV_PAR06 .Or.;
				SC2->C2_DATPRF  < MV_PAR07 .Or. SC2->C2_DATPRF  > MV_PAR08
				dbSelectArea("SC2")
				dbSkip()
				Loop
			Endif
			
			If aSC2Sld() <= 0 .Or. !Empty(C2_DATRF) // O.P.s EM ABERTO
				dbSelectArea("SC2")
				dbSkip()
				Loop
			Endif
			
			If SC2->C2_DESTINA != "P"
				dbSelectArea("SC2")
				dbSkip()
				Loop
			Endif
			
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->OP      := _cOP
			TRB->PRODUTO := SC2->C2_PRODUTO
			TRB->DESCPRO := _cDesc
			TRB->EMISSAO := SC2->C2_EMISSAO
			TRB->ENTREGA := SC2->C2_DATPRF
			TRB->SDOOP   := SC2->C2_QUANT - SC2->C2_QUJE
			MsUnlock()
			
			dbSelectArea("SC2")
			dbSkip()
		EndDo
	Endif

	dbSelectArea("SC6")
	dbSetOrder(2)
	If dbSeek(xFilial("SC6")+_cProduto)
		
		While !Eof() .And. _cProduto == SC6->C6_PRODUTO
			
			If SC6->C6_NUM       < MV_PAR09 .Or. SC6->C6_NUM     > MV_PAR10 .Or.;
				SC6->C6_CLI      < MV_PAR11 .Or. SC6->C6_CLI     > MV_PAR12 .Or.;
				SC6->C6_ENTREG   < MV_PAR13 .Or. SC6->C6_ENTREG  > MV_PAR14
				dbSelectArea("SC6")
				dbSkip()
				Loop
			Endif
			
			If SC6->C6_QTDENT = SC6->C6_QTDVEN .Or. !Empty(SC6->C6_BLQ)
				dbSelectArea("SC6")
				dbSkip()
				Loop
			Endif

			dbSelectArea("SC5")
			dbSetOrder(1)
			dbSeek(xFilial("SC5")+SC6->C6_NUM)
			
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->PRODUTO := SC6->C6_PRODUTO
			TRB->DESCPRO := _cDesc			
			TRB->CLIENTE := SC6->C6_CLI
			TRB->LOJA    := SC6->C6_LOJA
			TRB->PEDIDO  := SC6->C6_NUM
			TRB->ITEMPED := SC6->C6_ITEM
			TRB->PRODCLI := SC6->C6_CPROCLI
			TRB->ENTREGA := SC6->C6_ENTREG 
			TRB->EMISSAO := SC5->C5_EMISSAO
			TRB->QTDEPED := SC6->C6_QTDVEN
			TRB->SDOPED  := SC6->C6_QTDVEN - SC6->C6_QTDENT
			MsUnlock()
			
			dbSelectArea("SC6")
			dbSkip()
		EndDo
	Endif
	
	dbSelectArea("TRB")
	If dbSeek(SB1->B1_COD)
	   dbSelectArea("SB2")
	   dbSetOrder(1)
	   If dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD)
			dbSelectArea("TRB")
			RecLock("TRB",.F.)
			   TRB->SDOEST := SB2->B2_QATU
			MsUnlock()
	   Endif
	Endif		
	
	dbSelectArea("SB1")
	dbSkip()
EndDo


Return


Static Function ImpOrd2(_lFim)

_nGerSdoOp := 0
_nGerQPed  := 0
_nGerSPed  := 0
_nGerSEst  := 0

dbSelectArea("TRB")
dbGotop()

SetRegua(RecCount())

While !Eof()
	
	IncRegua()
	
	_cProd := TRB->PRODUTO
	_cDesc := TRB->DESCPRO

	If li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
		Li:= 9
	EndIf
		
	@Li ,000 PSay _cProd +" - "+ Alltrim(_cDesc)
	@Li ,097 PSay TRB->SDOEST       Picture "@E 999,999,999.99"
	LI+=2	
	_nTotSdoOp := 0
	_nTotQPed  := 0
	_nTotSPed  := 0      
	_nTotSEst  := 0
	
	While !Eof() .And. _cProd == TRB->PRODUTO
		
		If _lFim
			Alert("Cancelado Pelo Usuario!!!!!")
			Return
		Endif
		
		If li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
			Li:= 9
		EndIf
		
//		@Li ,000 PSay TRB->PRODUTO
		@Li ,000 PSay TRB->OP
		@Li ,012 PSay TRB->CLIENTE
		@Li ,020 PSay TRB->LOJA
		@Li ,023 PSay TRB->PEDIDO
		@Li ,030 PSay TRB->ITEMPED
		@Li ,033 PSay TRB->PRODCLI
		@Li ,049 PSay TRB->EMISSAO
		@Li ,058 PSay TRB->ENTREGA
		@Li ,067 PSay TRB->SDOPED       Picture "@E 999,999,999.99"
		@Li ,082 PSay TRB->SDOOP        Picture "@E 999,999,999.99"
		
		_nTotSdoOp += TRB->SDOOP
		_nTotQPed  += TRB->QTDEPED
		_nTotSPed  += TRB->SDOPED 
		_nTotSEst  += TRB->SDOEST
		
		Li++
		If li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,IIF(aReturn[4]==1,15,18))
			Li:= 9
		EndIf
		
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	LI++
	
	@Li ,000 PSay "Total do Produto -----> "
	@Li ,067 PSay _nTotSPED                              Picture "@E 999,999,999.99"
	@Li ,082 PSay _nTotSdoOp                             Picture "@E 999,999,999.99"
	@Li ,097 PSay _nTotSEst                              Picture "@E 999,999,999.99"
	@Li ,112 PSay _nTotSPED - _nTotSdoOP - _nTotSEst     Picture "@E 999,999,999.99"	
	Li+=3
	
	_nGerSdoOp += _nTotSdoOp
	_nGerQPed  += _nTotQPed                                     
	_nGerSPed  += _nTotSPed
	_nGerSEst  += _nTotSEst
	
	_nTotSdoOp := 0
	_nTotQPed  := 0
	_nTotSPed  := 0
	_nTotSEst  := 0
	
EndDo

@Li ,000 PSay "Total Geral -----> "
@Li ,067 PSay _nGerSPed                              Picture "@E 999,999,999.99"
@Li ,082 PSay _nGerSdoOP                             Picture "@E 999,999,999.99"
@Li ,097 PSay _nGerSEst                              Picture "@E 999,999,999.99"
@Li ,112 PSay _nGerSPed - _nGerSdoOp - _nGerSEst     Picture "@E 999,999,999.99"

IF  LI != 80
	roda(cbcont,cbtxt)
EndIF

If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

Return NIL