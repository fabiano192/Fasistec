#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PA0094    º Autor ³ Alexandro da Silva º Data ³  13/05/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Exportacao                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Sigafin                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PA0094()

titulo 	 := "Relatorio de Exportacao"
cDesc1 	 := "Relatorio de Exportacao"
cDesc2 	 := ""
cDesc3 	 := "PA0094"
cabec1	 := ""
cabec2   := ""
tamanho	 := "M"
limite 	 := 132
nOrdem 	 := 0
cString	 := "EEC"
nTipo    := 18
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
nomeprog := "PA0094"
aLinha   := { }
nLastKey := 0
cPerg    := "PA0094"
lAbortPrint  := .F.
cbtxt    		 := SPACE(10)
cbcont   		 := 0
li       		 :=80
m_pag    		 :=1

pergunte("PA0094",.F.)

/////////////////////////////////////////////////
/////////////////////////////////////////////////
/// MV_PAR01  : Data do Embarque  De  ?    //////  INDICE C
/// MV_PAR02  : Data do Embarque Ate  ?    //////  INDICE C
/// MV_PAR03  : Numero da Invoice De  ?    //////  INDICE 1
/// MV_PAR04  : Numero da Invoice Ate ?    //////  INDICE 1
/// MV_PAR05  : Numero da R.E.    De  ?    //////  INDICE INDEEC4
/// MV_PAR06  : Numero da R.E.    De  ?    //////  INDICE INDEEC4
/// MV_PAR07  : Data da Invoice   De  ?    //////  INDICE INDEEC1
/// MV_PAR08  : Data do INvoice  Ate  ?    //////  INDICE INDEEC1
/// MV_PAR09  : Cliente De            ?    //////  CLIENTE DE     
/// MV_PAR10  : Cliente Ate           ?    //////  CLIENTE ATE
/// MV_PAR11  : Loja    De            ?    //////  Loja    DE     
/// MV_PAR12  : LOja    Ate           ?    //////  Loja    ATE
/// MV_PAR13  : Contrato de           ?    //////
/// MV_PAR14  : Contrato ate          ?    //////
/// MV_PAR15  : Ordem de Pagto de     ?    //////
/// MV_PAR16  : Ordem de Pagto ate    ?    //////
/// MV_PAR17  : Data credito de       ?    //////
/// MV_PAR18  : Data credito ate      ?    //////
/////////////////////////////////////////////////

wnrel:="PA0094"
aOrd :={"Por Nr Invoice","Por Contrato","Por Ordem Pagto","Por Data Credito"}

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
Private _bAcao01   := {|_lFim| PA094A(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return


Static Function PA094A(_lFim)

nOrdem    := aReturn[8]
/*
Private _aMes     := {}
Private _cAno     := ""
Private _dDtI     := _dDtF    := Ctod("")
Private _lImprime := .T.
_cNomBco := ""
_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Relatorio de Exportacao ")
@ 02,10 TO 080,220
@ 10,18 SAY "Relatorio com os dados necessarios para Informar    "     SIZE 160,7
@ 18,18 SAY "o Banco referente exportacao Conforme parametros    "     SIZE 160,7
@ 26,18 SAY "informado Pelo usuario. Programa PA0094.PRW         "     SIZE 160,7
@ 34,18 SAY "                                                    "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0094")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	PA94A()
Endif

Return(.T.)


Static Function PA94A()
  */

aStru := {}
AADD(aStru,{"PA009401"  , "C" , 20, 0 })  // Numero da INVOICE
AADD(aStru,{"PA009402"  , "N" , 14, 2 })  // VALOR DA INVOICE
AADD(aStru,{"PA009403"  , "N" ,  3, 0 })  // PRAZO
AADD(aStru,{"PA009404"  , "D" , 08, 0 })  // DATA DO EMBARQUE
AADD(aStru,{"PA009405"  , "C" , 20, 0 })  // NUM'ERO DO CONHECIMENTO
AADD(aStru,{"PA009406"  , "C" , 12, 0 })  // NUMERO DO R.E.
AADD(aStru,{"PA009407"  , "C" , 20, 0 })  // NUMERO DO S.D.
AADD(aStru,{"PA009408"  , "D" , 08, 0 })  // DATA DA INVOICE 
AADD(aStru,{"PA009409"  , "C" , 20, 0 })  // NUMERO DO CONTRATO DE CAMBIO
AADD(aStru,{"PA009410"  , "C" , 06, 0 })  // CODIGO DO CLIENTE
AADD(aStru,{"PA009411"  , "C" , 02, 0 })  // LOJA DO CLIENTE
AADD(aStru,{"PA009412"  , "C" , 20, 0 })  // ORDEM DE PAGAMENTO
AADD(aStru,{"PA009413"  , "D" , 08, 0 })  // DATA DO CREDITO EXTERIOR
AADD(aStru,{"PA009414"  , "C" , 15, 0 })  // OBSERVAÇÃO

_cArqTrb := CriaTrab(aStru,.T.)
If nOrdem == 1
	_cIndTrb := "PA009401"
ElseIf nOrdem == 2
	_cIndTrb := "PA009409"
ElseIf nOrdem == 3
	_cIndTrb := "PA009412"
ElseIf nOrdem == 4
	_cIndTrb := "PA009413"
Endif

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")
           
_cCond2 := ""
dbSelectArea("EEC")
If !EMPTY(MV_PAR01)
	dbSetOrder(12)             
	dbSeek(xFilial("EEC")+Dtos(MV_PAR01),.T.)
	_cCond2 := "EEC->EEC_DTEMBA <= MV_PAR02 "
ElseIf !Empty(MV_PAR03)
	dbSetOrder(1)                 
	dbSeek(xFilial("EEC")+MV_PAR03,.T.)
	_cCond2 := "EEC->EEC_PREEMB <= MV_PAR04 "
ElseIf !Empty(MV_PAR05)
	dbOrderNickName("INDEEC4")        
	dbSeek(xFilial("EEC")+MV_PAR05,.T.)
	_cCond2 := "EEC->EEC_NUMRE  <= MV_PAR06 "
ElseIf !Empty(MV_PAR07)
	dbOrderNickName("INDEEC1")        
	dbSeek(xFilial("EEC")+Dtos(MV_PAR07),.T.)
	_cCond2 := "EEC->EEC_DTPROC  <= MV_PAR08 "
Else
	dbSetOrder(3)
Endif

ProcRegua(LastRec())

While !eof() .And. !_lFim .And. &_cCond2
	
	IncProc() 
	
	If EEC->EEC_PREEMB = "EXP 064/07"
		_lPare  := .T.
	Endif	
	
	If EEC->EEC_DTEMBA  < MV_PAR01 .Or. EEC->EEC_DTEMBA > MV_PAR02 .Or.;
		EEC->EEC_PREEMB < MV_PAR03 .Or. EEC->EEC_PREEMB > MV_PAR04 .Or.;
		EEC->EEC_NUMRE  < MV_PAR05 .Or. EEC->EEC_NUMRE  > MV_PAR06 .Or.;
		EEC->EEC_DTPROC < MV_PAR07 .Or. EEC->EEC_DTPROC > MV_PAR08 .Or.;
        EEC_IMPORT      < MV_PAR09 .Or. EEC->EEC_IMPORT > MV_PAR10 .Or.;
		EEC_IMLOJA      < MV_PAR11 .Or. EEC->EEC_IMLOJA > MV_PAR12
		dbSelectArea("EEC")
		dbSkip()
		Loop
	Endif
	
	nFobValue  := (EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"))
	_nVlOut    := EEC->EEC_FRPCOM+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2")-EEC->EEC_DESCON
	_nAbat     := EEC->EEC_FRPREV + EEC->EEC_SEGPRE + _nVlOut
	_nVlTotExw := nFobValue //- _nAbat
	                          
	_cNumCont  := SPACE(20)
	_cOrdPgto  := SPACE(20)
	_dCredito  := CTOD("  /  /  ")
	_cObs      := ""
	dbSelectArea("EEQ")
	dbSetOrder(4)
//	If dbseek(xFilial("EEQ")+EEC->EEC_PREEMB)
//	If dbseek(xFilial("EEQ")+EEC->EEC_NRINVO+EEC->EEC_PREEMB)
	If dbseek(xFilial("EEQ")+EEC->EEC_NRINVO)
		_cNumCont := EEQ->EEQ_NROP
		_cOrdPgto := EEQ->EEQ_RFBC		
		_dCredito := EEQ->EEQ_DTCE
		_cObs     := Substr(EEQ->EEQ_OBS,1,15)
	Endif
	
	If _cNumCont < MV_PAR13 .Or. _cNumCont > MV_PAR14 .Or.;
		_cOrdPgto < MV_PAR15 .Or. _cOrdPgto > MV_PAR16 .Or.;
		_dCredito < MV_PAR17 .Or. _dCredito > MV_PAR18
		dbSelectArea("EEC")
		dbSkip()
		Loop
	Endif
		
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->PA009401  := EEC->EEC_PREEMB
	TRB->PA009402  := _nVlTotExw
	TRB->PA009403  := EEC->EEC_DIASPA
	TRB->PA009404  := EEC->EEC_DTEMBA
	TRB->PA009405  := EEC->EEC_NRCONH
	TRB->PA009406  := EEC->EEC_NUMRE
	TRB->PA009407  := EEC->EEC_NUMSD
	TRB->PA009408  := EEC->EEC_DTPROC
	TRB->PA009409  := _cNumCont
	TRB->PA009410  := EEC->EEC_IMPORT
	TRB->PA009411  := EEC->EEC_IMLOJA
	TRB->PA009412  := _cOrdPgto
	TRB->PA009413  := _dCredito
	TRB->PA009414  := _cObs
	MsUnlock()
	
	dbSelectArea("EEC")
	dbSkip()
EndDo

_cArqNew   := "\CRYSTAL\PA0094.DBF"

dbSelectArea("TRB")
Copy All To &_cArqNew

dbCloseArea()

_cMod    := cModulo
cModulo  := "EEC"
_lRet    := E_ARQCRW()

Public cSeqRel := ""

AVGCRW32("PA0094.RPT","RELATORIO EXPORTACAO",)
cModulo  := _cMod

Return