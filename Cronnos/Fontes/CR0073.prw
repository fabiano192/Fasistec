#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"

/*/
Programa	: CR0073  ?Autor Alexandro da Silva
Data 		: 17/07/06
Descriçã	: Envio de E-mail referente a Compras MPIM
/*/

User Function CR0073()
	
	_aAliOri := GetArea()
	_aAliSB1 := SB1->(GetArea())
	_aAliSD1 := SD1->(GetArea())
	_aAliSF1 := SF1->(GetArea())
	_aAliSF4 := SF4->(GetArea())
	
	_lEnvia    := .F.
	_lFim      := .F.
	_cMsg01    := ''
	_lAborta01 := .T.
	_bAcao01   := {|_lFim| 	CR73A(@_lFim) }
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


Static Function CR73A(_lFim)
	
	aStru := {}
	AADD(aStru,{"DEPTO"    , "C" , 02, 0 }) // 01 PCP , 02 ENGENHARIA
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
	
	SD1->(dbsetorder(1))
	If SD1->(dbseek(xfilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
		
		_cChavSD1 := SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
		
		While SD1->(!Eof()) .And. _cChavSD1 == SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
			
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
			
			If !SD1->D1_TIPO $ "B/D"
				SA2->(dbSetOrder(1))
				SA2->(dbSeek(xFilial("SA2")+SD1->D1_FORNECE + SD1->D1_LOJA ))
				_cNomeFor := SA2->A2_NOME
			Else
				SA1->(dbSetOrder(1))
				SA1->(dbSeek(xFilial("SA1")+SD1->D1_FORNECE + SD1->D1_LOJA ))
				_cNomeFor := SA1->A1_NOME
			Endif
			
			SF4->(dbSetOrder(1))
			SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
			
			If SB1->B1_NOTAMIN > 0 .Or. SB1->B1_TIPO $ 'FR|DP'
				TRB->(RecLock("TRB",.T.))
				TRB->DEPTO   := If(SB1->B1_TIPO $ 'FR|DP',"02","01")
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
				TRB->(MsUnlock())
				
				If SF4->F4_ESTOQUE = 'S'
					U_CR0072(SD1->D1_COD,SB1->B1_DESC,SD1->D1_DTDIGIT,SD1->D1_LOTECTL,SD1->D1_LOCAL,SD1->D1_QUANT,SD1->D1_QUANT,1)
				Endif
				
				_lEnvia := .T.
				
			Endif
			_nTotal += SD1->D1_TOTAL
			
			SD1->(dbSkip())
		EndDo
		
		If _lEnvia
			CR73B()
		Endif
	Endif
	
Return



Static Function CR73B()
	
	Private _lRet
	
	nOpcao := 0
	
	ConOut("Enviando E-Mail NF:")
	
	oProcess := TWFProcess():New( "ENVEM1", "Compras " )
	aCond    :={}
	_nTotal  := 0
	
	oProcess:NewTask( "Integracao", "\WORKFLOW\EMCOMPRA.HTM" )
	oProcess:bReturn  := ""
	oProcess:bTimeOut := ""
	oHTML := oProcess:oHTML
	
	TRB->(dbGotop())
	
	While TRB->(!Eof())
		
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
		
		_cDepto :=  TRB->DEPTO
		
		While TRB->(!EOF()) .And. _cDepto ==  TRB->DEPTO
			
			AADD( (oHtml:ValByName( "TB.ITEM"     )), TRB->ITEM)
			AADD( (oHtml:ValByName( "TB.PRODUTO"  )), TRB->PRODUTO)
			AADD( (oHtml:ValByName( "TB.DESPROD"  )), TRB->DESPROD)
			AADD( (oHtml:ValByName( "TB.GRUPO"    )), TRB->GRUPO)
			AADD( (oHtml:ValByName( "TB.LOTE"     )), TRB->LOTE)
			AADD( (oHtml:ValByName( "TB.QTDE"     )), TRANSFORM( TRB->QTDE,   '@E 999,999,999.99' ))
			AADD( (oHtml:ValByName( "TB.VALOR"    )), TRANSFORM( TRB->VALOR,  '@E 999,999,999.99' ))
			
			oProcess:fDesc := "Projeto 4 "
			
			_nTotal += TRB->VALOR
			
			TRB->(dbSkip())
		EndDo
		
		oHtml:ValByName( "VALTOTAL", TRANSFORM( _nTotal,  '@E 999,999,999.99' ))
		
		Private _cTo := _cCC := ""
		
		If _cDepto = '01'
			_cZG := 'L'
		Else
			_cZG := 'Q'
		Endif 
		
		SZG->(dbsetOrder(1))
		SZG->(dbGotop())
		
		While SZG->(!EOF())
			
			If (_cZG+'1') $ SZG->ZG_ROTINA
				_cTo += If(Empty(_cTo),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
			ElseIf (_cZG+'2') $ SZG->ZG_ROTINA
				_cCC += If(Empty(_cCC),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
			Endif
			
			SZG->(dbSkip())
		Enddo
		
		oProcess:cTo := _cTo
		oProcess:cCC := _cCC
		
		oProcess:Start()
		oProcess:Finish()
	EndDo
	
Return
