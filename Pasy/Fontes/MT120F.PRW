#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT120GRV ³ Autor ³Alexandro da Silva    ³ Data ³ 24/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envio de E-mail referente a Pedidos de Compra             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Faturamento                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

/*/

User Function MT120F()


_aAliOri := GetArea()
_aAliSB1 := SB1->(GetArea())
_aAliSC7 := SC7->(GetArea())
_aAliSD1 := SD1->(GetArea())

_lEnvia    := .F.
_lFim      := .F.
_cMsg01    := ''
_lAborta01 := .T.
_bAcao01   := {|_lFim| 	Proc1(@_lFim) }
_cTitulo01 := 'Enviando E-mail !!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

dbSelectArea("TRB")
dbCloseArea()

RestArea(_aAliSB1)
RestArea(_aAliSC7)
RestArea(_aAliSD1)
RestArea(_aAliOri)

Return


Static Function PROC1(_lFim)

aStru := {}
AADD(aStru,{"NUMERO"   , "C" , 06, 0 })
AADD(aStru,{"SERIE"    , "C" , 03, 0 })
AADD(aStru,{"FORNECE"  , "C" , 06, 0 })
AADD(aStru,{"NOMFOR"   , "C" , 40, 0 })
AADD(aStru,{"LOJA"     , "C" , 02, 0 })
AADD(aStru,{"ENTRADA"  , "D" , 08, 0 })
AADD(aStru,{"ITEM"     , "C" , 04, 0 })
AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
AADD(aStru,{"DESPROD"  , "C" , 60, 0 })
AADD(aStru,{"QTDE"     , "N" , 14, 2 })
AADD(aStru,{"VLUNIT"   , "N" , 14, 2 })
AADD(aStru,{"TOTAL"    , "N" , 14, 2 })
AADD(aStru,{"VLUNITA"  , "N" , 14, 2 })
AADD(aStru,{"FORNECEA" , "C" , 06, 0 })
AADD(aStru,{"LOJAA"    , "C" , 02, 0 })
AADD(aStru,{"NUMEROA"  , "C" , 06, 0 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "PRODUTO"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

_nTotal := 0
_lEnvia := .F.

_cPedido := SC7->C7_NUM

dbselectarea("SC7")
dbsetorder(1)
If dbseek(xfilial("SC7")+_cPedido)
	
	_cChavSc7 := SC7->C7_NUM
	
	ProcRegua(LastRec())
	
	While !Eof() .And.	_cChavSc7 == SC7->C7_NUM
		
		IncProc()
		
		dbSelectArea("SD1")
		dbSetOrder(7)
		dbSeek(xFilial("SD1")+SC7->C7_PRODUTO + SC7->C7_LOCAL + "99999999",.t.)
		dbSkip(-1)
		
		If SC7->C7_PRODUTO != SD1->D1_COD
			dbSelectArea("SC7")
			dbSkip()
			Loop
		Endif
		
		If SD1->D1_VUNIT == SC7->C7_PRECO
			dbSelectArea("SC7")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SD1->D1_COD)
		
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2")+SC7->C7_FORNECE + SC7->C7_LOJA )
		_cNomPed := SA2->A2_NOME
		
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2")+SD1->D1_FORNECE + SD1->D1_LOJA )
		_cNomNota := SA2->A2_NOME
/*		
		If !SB1->B1_GRUPO $ "MPIM"
			dbSelectArea("SC7")
			dbSkip()
			Loop
		Endif
*/		
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->NUMERO  := SC7->C7_NUM
		TRB->FORNECE := SC7->C7_FORNECE
		TRB->NOMFOR  := _cNomPed
		TRB->LOJA    := SC7->C7_LOJA
		TRB->ENTRADA := SC7->C7_EMISSAO
		TRB->ITEM    := SC7->C7_ITEM
		TRB->PRODUTO := SC7->C7_PRODUTO
		TRB->DESPROD := SB1->B1_DESC
		TRB->QTDE    := SC7->C7_QUANT
		TRB->VLUNIT  := SC7->C7_PRECO
		TRB->TOTAL   := SC7->C7_TOTAL
		TRB->VLUNITA := SD1->D1_VUNIT
		TRB->FORNECEA:= SD1->D1_FORNECE
		TRB->LOJAA   := SD1->D1_LOJA
		TRB->NUMEROA := SD1->D1_DOC
		MsUnlock()
		//       Endif
		
		_lEnvia := .T.
		_nTotal += SD1->D1_TOTAL
		
		dbSelectArea("SC7")
		dbSkip()
	EndDo
	
	If _lEnvia
		Proc2()
	Endif
Endif

If _lEnvia
	Proc3()
Endif

Return


Static Function Proc2()

private _lRet

nOpcao := 0

ConOut("Enviando E-Mail para Diretoria:")

oProcess := TWFProcess():New( "ENVEM1", "Compras " )
aCond    :={}
_nTotal  := 0

oProcess:NewTask( "Integracao", "\WORKFLOW\COM_PRC.HTM" )
oProcess:bReturn  := ""
oProcess:bTimeOut := ""
oHTML := oProcess:oHTML

dbSelectArea("TRB")
dbGoTop()

_nPerIpi  := 0
nValIPI   := 0
nTotal    := 0

oProcess:cSubject := "Preco Compras Divergente "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

oHtml:ValByName( "NUMERO" , TRB->NUMERO)
oHtml:ValByName( "FORNECE", TRB->FORNECE)
oHtml:ValByName( "NOMEFOR", TRB->NOMFOR)
oHtml:ValByName( "LOJA"   , TRB->LOJA)
oHtml:ValByName( "ENTRADA", DTOC(TRB->ENTRADA))

While !Eof()
	
	AADD( (oHtml:ValByName( "TB.ITEM"     )), TRB->ITEM)
	AADD( (oHtml:ValByName( "TB.PRODUTO"  )), TRB->PRODUTO)
	AADD( (oHtml:ValByName( "TB.DESPROD"  )), TRB->DESPROD)
	AADD( (oHtml:ValByName( "TB.QTDE"     )), TRANSFORM( TRB->QTDE,     '@E 999,999,999.99' ))
	AADD( (oHtml:ValByName( "TB.VLUNIT"   )), TRANSFORM( TRB->VLUNIT   ,'@E 999,999,999.99' ))
	AADD( (oHtml:ValByName( "TB.TOTAL"    )), TRANSFORM( TRB->TOTAL    ,'@E 999,999,999.99' ))
	AADD( (oHtml:ValByName( "TB.VLUNITA"  )), TRANSFORM( TRB->VLUNITA  ,'@E 999,999,999.99' ))
	AADD( (oHtml:ValByName( "TB.NUMEROA"  )), TRB->NUMEROA)
	AADD( (oHtml:ValByName( "TB.FORNECEA" )), TRB->FORNECEA)
	AADD( (oHtml:ValByName( "TB.LOJAA"    )), TRB->LOJAA)
	
	oProcess:fDesc := "Projeto 4 "
	
	_nTotal += TRB->TOTAL
	dbSelectArea("TRB")
	dbSkip()
EndDo

oHtml:ValByName( "VALTOTAL", TRANSFORM( _nTotal,  '@E 999,999,999.99' ))

_cTo := GETMV("MV_WEMDIR1")
_cCc := GETMV("MV_WEMPCP4")

oProcess:cTo := _cTo
oProcess:cCC := _cCC

oProcess:Start()
RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Envio Email para Diretoria iniciado!' )

oProcess:Finish()

Return


Static Function PROC3()

ConOut("Processo Finalizado" )

oProcess := TWFProcess():New( "ENVEM2", "Diretoria" )

oProcess:NewTask( "Integracao", "\WORKFLOW\COM_PRC.HTM" )
oProcess:bReturn  := ""
oProcess:bTimeOut := ""
oHTML := oProcess:oHTML

oProcess:cSubject := "Processo Encerrado"
oProcess:fDesc := "Processo Encerrado"

_cTo := GETMV("MV_WEMPCP2")
oProcess:cTo := _cTo

_cCC := ""
oProcess:cCC := _cCC

oProcess:Start()
RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10003','Finalizado Integracao' )

oProcess:Free()
oProcess:Finish()

Return
