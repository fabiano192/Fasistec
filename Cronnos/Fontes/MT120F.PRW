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

User Function MT120FZZZ()

	
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
AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
AADD(aStru,{"DESPROD"  , "C" , 60, 0 })
AADD(aStru,{"QTDE"     , "N" , 14, 2 })
AADD(aStru,{"VLUNIT"   , "N" , 14, 2 })
AADD(aStru,{"VALOR"    , "N" , 14, 2 })
AADD(aStru,{"VLUNITA"  , "N" , 14, 2 })
AADD(aStru,{"FORNECEA"  , "C" , 06, 0 })
AADD(aStru,{"LOJAA"     , "C" , 02, 0 })

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
If dbseek(xfilial()+_cPedido)
                             
	_cChavSc7 := SC7->C7_NUM
	
	ProcRegua()

	While !Eof() .And.	_cChavSc7 == SC7->C7_NUM
               
		IncProc()
		         
		dbSelectArea("SD1")
		dbSetOrder(7)
		dbSeek(xFilial()+SC7->C7_PRODUTO + SC7->C7_LOCAL + "99999999",.t.)
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
		dbSeek(xFilial()+SD1->D1_COD)

		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial()+SC7->C7_FORNECE + SC7->C7_LOJA )
        _cNomPed := SA2->A2_NOME
		
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial()+SD1->D1_FORNECE + SD1->D1_LOJA )
		_cNomNota := SA2->A2_NOME

		If SB1->B1_GRUPO $ "MPIM/FRVC/FRFG/PAT /DPA "
			dbSelectArea("TRB")
			RecLock("TRB",.T.)         	
			TRB->NUMERO  := SC7->C7_NUM
			TRB->FORNECE := SC7->C7_FORNECE              
			TRB->NOMFOR  := _cNomPed
			TRB->LOJA    := SC7->C7_LOJA
			TRB->ENTRADA := SC7->C7_EMISSAO
			TRB->PRODUTO := SC7->C7_PRODUTO
			TRB->DESPROD := SB1->B1_DESC
			TRB->QTDE    := SC7->C7_QUANT
			TRB->VLUNIT  := SC7->C7_PRECO
			TRB->TOTAL   := SC7->C7_TOTAL
			TRB->VLUNITA := SD1->D1_VUNI
			TRB->FORNECEA:= SD1->D1_FORNECE
			TRB->LOJAA   := SD1->D1_LOJA
			TRB->NUMEROA := SD1->D2_DOC
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
_cCc := ""

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