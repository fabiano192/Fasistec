#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PA0096  ³ Autor ³Alexandro da Silva     ³ Data ³ 17/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envio de E-mail referente a Compras MPIM                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Faturamento                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

/*/

User Function PA0096()

//If SF1->F1_TIPO != "N"
//	Return
//Endif
	
_aAliOri := GetArea()       
_aAliSB1 := SB1->(GetArea())
_aAliSD1 := SD1->(GetArea())
_aAliSF1 := SF1->(GetArea())
_aAliSF4 := SF4->(GetArea())

_lEnvia    := .F.    
_lFim      := .F.
_cMsg01    := ''
_lAborta01 := .T.
_bAcao01   := {|_lFim| 	PA96A(@_lFim) }
_cTitulo01 := 'Enviando E-mail !!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

dbSelectArea("TRB")
dbCloseArea() 

RestArea(_aAliSB1)
RestArea(_aAliSD1)
RestArea(_aAliSF1)
RestArea(_aAliSF4)
RestArea(_aAliOri)

Return


Static Function PA96A(_lFim)

aStru := {}                            
AADD(aStru,{"DEPTO"    , "C" , 02, 0 }) // 01 PCP , 02 Laboratório , 03 C.Q.
AADD(aStru,{"NUMERO"   , "C" , 06, 0 })
AADD(aStru,{"SERIE"    , "C" , 03, 0 })
AADD(aStru,{"FORNECE"  , "C" , 06, 0 })
AADD(aStru,{"NOMFOR"   , "C" , 40, 0 })
AADD(aStru,{"LOJA"     , "C" , 02, 0 })
AADD(aStru,{"ENTRADA"  , "D" , 08, 0 })
AADD(aStru,{"ITEM"     , "C" , 04, 0 })
AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
AADD(aStru,{"DESPROD"  , "C" , 60, 0 })
AADD(aStru,{"OP"       , "C" , 13, 0 })
AADD(aStru,{"GRUPO"    , "C" , 04, 0 })
AADD(aStru,{"LOTE"     , "C" , 06, 0 })
AADD(aStru,{"QTDE"     , "N" , 14, 2 })
AADD(aStru,{"VALOR"    , "N" , 14, 2 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "DEPTO+PRODUTO"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")
                                
_nTotal := 0
_lEnvia := .F.
dbselectarea("SD1")
dbsetorder(1)
If dbseek(xfilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

	_cChavSD1 := SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA

	While !Eof() .And.	_cChavSD1 == SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA

		If SD1->D1_TP != "MP" .And. Empty(SD1->D1_OP)
			dbSelectArea("SD1")
			dbSkip()
			Loop
		Endif                       
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SD1->D1_COD)
        
		If !SD1->D1_TIPO $ "B/D"
			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek(xFilial("SA2")+SD1->D1_FORNECE + SD1->D1_LOJA )
			_cNomeFor := SA2->A2_NOME
		Else
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+SD1->D1_FORNECE + SD1->D1_LOJA )
			_cNomeFor := SA1->A1_NOME			
		Endif		
		
		If Empty(SD1->D1_OP)
			dbSelectArea("SF4")
			dbSetOrder(1)
			If dbSeek(xFilial("SF4")+SD1->D1_TES)		
				If  SF4->F4_PODER3 == "D"
					dbSelectArea("SD1")
					dbSkip()
					Loop
				Endif
			Endif
		Endif
	
		If SD1->D1_GRUPO $ "MPIM/FRVC/FRFG/PAT /DPA /PIVZ"
			dbSelectArea("TRB")
			RecLock("TRB",.T.)         	
			TRB->DEPTO := "01"   // PCP
			TRB->NUMERO  := SD1->D1_DOC
			TRB->SERIE   := SD1->D1_SERIE
			TRB->FORNECE := SD1->D1_FORNECE              
			TRB->NOMFOR  := _cNomeFor
			TRB->LOJA    := SD1->D1_LOJA
			TRB->ENTRADA := SD1->D1_DTDIGIT
			TRB->ITEM    := SD1->D1_ITEM
			TRB->PRODUTO := SD1->D1_COD
			TRB->DESPROD := SB1->B1_DESC
			TRB->GRUPO   := SD1->D1_GRUPO
			TRB->LOTE    := SD1->D1_LOTECTL
			TRB->QTDE    := SD1->D1_QUANT
			TRB->VALOR   := SD1->D1_TOTAL
			MsUnlock()
        Endif
        
		If SD1->D1_GRUPO $ "MPIM/MPVZ/MPC /PIVZ"
			dbSelectArea("TRB")
			RecLock("TRB",.T.)         	
			TRB->DEPTO := "03" // C.Q.
			TRB->NUMERO  := SD1->D1_DOC
			TRB->SERIE   := SD1->D1_SERIE
			TRB->FORNECE := SD1->D1_FORNECE
			TRB->NOMFOR  := _cNomeFor
			TRB->LOJA    := SD1->D1_LOJA
			TRB->ENTRADA := SD1->D1_DTDIGIT
			TRB->ITEM    := SD1->D1_ITEM
			TRB->PRODUTO := SD1->D1_COD
			TRB->DESPROD := SB1->B1_DESC
			TRB->GRUPO   := SD1->D1_GRUPO
			TRB->LOTE    := SD1->D1_LOTECTL			
			TRB->QTDE    := SD1->D1_QUANT
			TRB->VALOR   := SD1->D1_TOTAL
			MsUnlock()
        ElseIf !SD1->D1_GRUPO $ "MPG " .And. !Substr(SD1->D1_GRUPO,1,2) $ "PA" .And. Empty(SD1->D1_OP)
			dbSelectArea("TRB")
			RecLock("TRB",.T.)         	
			TRB->DEPTO   := "02" // LABORATORIO
			TRB->NUMERO  := SD1->D1_DOC
			TRB->SERIE   := SD1->D1_SERIE
			TRB->FORNECE := SD1->D1_FORNECE
			TRB->LOJA    := SD1->D1_LOJA
			TRB->NOMFOR  := _cNomeFor
			TRB->ENTRADA := SD1->D1_DTDIGIT
			TRB->ITEM    := SD1->D1_ITEM
			TRB->PRODUTO := SD1->D1_COD
			TRB->DESPROD := SB1->B1_DESC
			TRB->GRUPO   := SD1->D1_GRUPO
			TRB->LOTE    := SD1->D1_LOTECTL
			TRB->QTDE    := SD1->D1_QUANT
			TRB->VALOR   := SD1->D1_TOTAL
			MsUnlock()        
        Endif
        
		If !Empty(SD1->D1_OP)
			dbSelectArea("TRB")
			RecLock("TRB",.T.)         	
			TRB->DEPTO   := "04" // PCP Para Apontar O.P.
			TRB->NUMERO  := SD1->D1_DOC
			TRB->SERIE   := SD1->D1_SERIE
			TRB->FORNECE := SD1->D1_FORNECE
			TRB->LOJA    := SD1->D1_LOJA
			TRB->NOMFOR  := _cNomeFor
			TRB->ENTRADA := SD1->D1_DTDIGIT
			TRB->ITEM    := SD1->D1_ITEM
			TRB->PRODUTO := SD1->D1_COD
			TRB->DESPROD := SB1->B1_DESC
			TRB->GRUPO   := SD1->D1_GRUPO
			TRB->OP      := SD1->D1_OP
			TRB->LOTE    := SD1->D1_LOTECTL
			TRB->QTDE    := SD1->D1_QUANT
			TRB->VALOR   := SD1->D1_TOTAL
			MsUnlock()        
		Endif
		
		_lEnvia := .T.	 
		_nTotal += SD1->D1_TOTAL
	
		dbSelectArea("SD1")
		dbSkip()
	EndDo
    
	If _lEnvia
		PA96B()
	Endif
Endif

If _lEnvia
	PA96C()
Endif

Return


Static Function PA96B()
                   

dbSelectArea("TRB")
If dbSeek("01")
	PA96B1()
Endif
	                       
dbSelectArea("TRB")
If dbSeek("02")
	PA96B2()
Endif

dbSelectArea("TRB")
If dbSeek("03")
	PA96B3()
Endif

dbSelectArea("TRB")
If dbSeek("04")
	PA96B4()
Endif


Return


Static Function PA96B1()

Private _lRet

nOpcao := 0

ConOut("Enviando E-Mail para PCP:")

oProcess := TWFProcess():New( "ENVEM1", "Compras " )
aCond    :={}
_nTotal  := 0

oProcess:NewTask( "Integracao", "\WORKFLOW\EMCOMPRA.HTM" )
oProcess:bReturn  := ""
oProcess:bTimeOut := ""
oHTML := oProcess:oHTML

dbSelectArea("TRB")

_nPerIpi  := 0
nValIPI   := 0
nTotal    := 0

oProcess:cSubject := "Entrada Compras "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

oHtml:ValByName( "NUMERO" , TRB->NUMERO)
oHtml:ValByName( "SERIE"  , TRB->SERIE)
oHtml:ValByName( "FORNECE", TRB->FORNECE)
oHtml:ValByName( "NOMEFOR", TRB->NOMFOR)
oHtml:ValByName( "LOJA"   , TRB->LOJA)
oHtml:ValByName( "ENTRADA", DTOC(TRB->ENTRADA))

While !Eof() .And. TRB->DEPTO == "01"
	                                                       
	AADD( (oHtml:ValByName( "TB.ITEM"     )), TRB->ITEM)
	AADD( (oHtml:ValByName( "TB.PRODUTO"  )), TRB->PRODUTO)
	AADD( (oHtml:ValByName( "TB.DESPROD"  )), TRB->DESPROD)
	AADD( (oHtml:ValByName( "TB.GRUPO"    )), TRB->GRUPO)
	AADD( (oHtml:ValByName( "TB.LOTE"     )), TRB->LOTE)
	AADD( (oHtml:ValByName( "TB.QTDE"     )), TRANSFORM( TRB->QTDE,   '@E 999,999,999.99' ))
	AADD( (oHtml:ValByName( "TB.VALOR"    )), TRANSFORM( TRB->VALOR,  '@E 999,999,999.99' ))	

	oProcess:fDesc := "Projeto 4 "
	  
	_nTotal += TRB->VALOR
	dbSelectArea("TRB")
	dbSkip()
EndDo
                                           
oHtml:ValByName( "VALTOTAL", TRANSFORM( _nTotal,  '@E 999,999,999.99' ))	

_cTo := GETMV("MV_WEMPCP1")
_cCc := GETMV("MV_WEMPCP4")

oProcess:cTo := _cTo
oProcess:cCC := _cCC

oProcess:Start()
RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Envio Email para PCP iniciado!' )

oProcess:Finish()

Return


Static Function PA96B2()

Private _lRet

nOpcao := 0

ConOut("Enviando E-Mail para Laboratorio:")

oProcess := TWFProcess():New( "ENVEM1", "Compras " )
aCond    :={}
_nTotal  := 0

oProcess:NewTask( "Integracao", "\WORKFLOW\EMCOMPRA.HTM" )
oProcess:bReturn  := ""
oProcess:bTimeOut := ""
oHTML := oProcess:oHTML

dbSelectArea("TRB")

_nPerIpi  := 0
nValIPI   := 0
nTotal    := 0

oProcess:cSubject := "Entrada Compras "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

oHtml:ValByName( "NUMERO" , TRB->NUMERO)
oHtml:ValByName( "SERIE"  , TRB->SERIE)
oHtml:ValByName( "FORNECE", TRB->FORNECE)
oHtml:ValByName( "LOJA"   , TRB->LOJA)
oHtml:ValByName( "NOMEFOR", TRB->NOMFOR)
oHtml:ValByName( "ENTRADA", DTOC(TRB->ENTRADA))

While !Eof() .And. TRB->DEPTO == "02"
	                                                       
	AADD( (oHtml:ValByName( "TB.ITEM"     )), TRB->ITEM)
	AADD( (oHtml:ValByName( "TB.PRODUTO"  )), TRB->PRODUTO)
	AADD( (oHtml:ValByName( "TB.DESPROD"  )), TRB->DESPROD)
	AADD( (oHtml:ValByName( "TB.GRUPO"    )), TRB->GRUPO)
	AADD( (oHtml:ValByName( "TB.LOTE"     )), TRB->LOTE)
	AADD( (oHtml:ValByName( "TB.QTDE"     )), TRANSFORM( TRB->QTDE,   '@E 999,999,999.99' ))
	AADD( (oHtml:ValByName( "TB.VALOR"    )), TRANSFORM( TRB->VALOR,  '@E 999,999,999.99' ))	

	oProcess:fDesc := "Projeto 4 "
	   
	_nTotal += TRB->VALOR

	dbSelectArea("TRB")
	dbSkip()
EndDo
                                           
oHtml:ValByName( "VALTOTAL", TRANSFORM( _nTotal,  '@E 999,999,999.99' ))	

_cTo := GETMV("MV_WEMLAB1")
_cCc := ""

oProcess:cTo := _cTo
oProcess:cCC := _cCC

oProcess:Start()
RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Envio Email para Laboratorio!' )

oProcess:Finish()

Return


Static Function PA96B3()

Private _lRet

nOpcao := 0

ConOut("Enviando E-Mail para C.Q.")

oProcess := TWFProcess():New( "ENVEM1", "Compras " )

aCond:={}
nTotal := 0

oProcess:NewTask( "Integracao", "\WORKFLOW\EMCOMPRA.HTM" )
oProcess:bReturn  := ""
oProcess:bTimeOut := ""
oHTML := oProcess:oHTML

dbSelectArea("TRB")

_nPerIpi  := 0
nValIPI   := 0
_nTotal   := 0

oProcess:cSubject := "Entrada Compras "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

oHtml:ValByName( "NUMERO" , TRB->NUMERO)
oHtml:ValByName( "SERIE"  , TRB->SERIE)
oHtml:ValByName( "FORNECE", TRB->FORNECE)
oHtml:ValByName( "LOJA"   , TRB->LOJA)  
oHtml:ValByName( "NOMEFOR", TRB->NOMFOR)
oHtml:ValByName( "ENTRADA", DTOC(TRB->ENTRADA))

While !Eof() .And. TRB->DEPTO == "03"
	                                                       
	AADD( (oHtml:ValByName( "TB.ITEM"     )), TRB->ITEM)
	AADD( (oHtml:ValByName( "TB.PRODUTO"  )), TRB->PRODUTO)
	AADD( (oHtml:ValByName( "TB.DESPROD"  )), TRB->DESPROD)
	AADD( (oHtml:ValByName( "TB.GRUPO"    )), TRB->GRUPO)
	AADD( (oHtml:ValByName( "TB.LOTE"     )), TRB->LOTE)
	AADD( (oHtml:ValByName( "TB.QTDE"     )), TRANSFORM( TRB->QTDE,   '@E 999,999,999.99' ))
	AADD( (oHtml:ValByName( "TB.VALOR"    )), TRANSFORM( TRB->VALOR,  '@E 999,999,999.99' ))	

	oProcess:fDesc := "Projeto 4 "
	    
	_nTotal += TRB->VALOR

	dbSelectArea("TRB")
	dbSkip()
EndDo
                                           
oHtml:ValByName( "VALTOTAL", TRANSFORM( _nTotal,  '@E 999,999,999.99' ))	

_cTo := GETMV("MV_WEMCQ1")
_cCc := ""

oProcess:cTo := _cTo
oProcess:cCC := _cCC

oProcess:Start()
RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Envio Email para C.Q.iniciado!' )

oProcess:Finish()

Return


Static Function PA96B4()

Private _lRet

nOpcao := 0

ConOut("Enviando E-Mail para P.C.P.")

oProcess := TWFProcess():New( "ENVEM1", "Compras " )

aCond:={}
nTotal := 0

oProcess:NewTask( "Integracao", "\WORKFLOW\PA0096B.HTM" )
oProcess:bReturn  := ""
oProcess:bTimeOut := ""
oHTML := oProcess:oHTML

dbSelectArea("TRB")

_nPerIpi  := 0
nValIPI   := 0
_nTotal   := 0

oProcess:cSubject := "Entrada Compras "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

oHtml:ValByName( "NUMERO" , TRB->NUMERO)
oHtml:ValByName( "SERIE"  , TRB->SERIE)
oHtml:ValByName( "FORNECE", TRB->FORNECE)
oHtml:ValByName( "LOJA"   , TRB->LOJA)  
oHtml:ValByName( "NOMEFOR", TRB->NOMFOR)
oHtml:ValByName( "ENTRADA", DTOC(TRB->ENTRADA))

While !Eof() .And. TRB->DEPTO == "04"
	                                                       
	AADD( (oHtml:ValByName( "TB.ITEM"     )), TRB->ITEM)
	AADD( (oHtml:ValByName( "TB.PRODUTO"  )), TRB->PRODUTO)
	AADD( (oHtml:ValByName( "TB.OP"       )), TRB->OP)
	AADD( (oHtml:ValByName( "TB.DESPROD"  )), TRB->DESPROD)
	AADD( (oHtml:ValByName( "TB.LOTE"     )), TRB->LOTE)
	AADD( (oHtml:ValByName( "TB.QTDE"     )), TRANSFORM( TRB->QTDE,   '@E 999,999,999.99' ))
	AADD( (oHtml:ValByName( "TB.VALOR"    )), TRANSFORM( TRB->VALOR,  '@E 999,999,999.99' ))	

	oProcess:fDesc := "Projeto 4 "
	    
	_nTotal += TRB->VALOR

	dbSelectArea("TRB")
	dbSkip()
EndDo
                                           
oHtml:ValByName( "VALTOTAL", TRANSFORM( _nTotal,  '@E 999,999,999.99' ))	

_cTo := GETMV("MV_WEMPCP3")
_cCc := ""

oProcess:cTo := _cTo
oProcess:cCC := _cCC

oProcess:Start()
RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Envio Email para P.C.P.!' )

oProcess:Finish()

Return

Static Function PA96C()

ConOut("Processo Finalizado" )

oProcess := TWFProcess():New( "ENVEM2", "Compras " )

oProcess:NewTask( "Integracao", "\WORKFLOW\EMCOMPRA.HTM" )
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