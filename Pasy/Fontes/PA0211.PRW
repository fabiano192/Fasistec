#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PA0211  ³ Autor ³Fabiano da Silva       ³ Data ³ 21/06/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envio de E-mail referente a Validade do Lote              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Estoque / Custos                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

/*/

User Function PA0211()
	
_aAliOri := GetArea()       
_aAliSB8 := SB8->(GetArea())

_lEnvia    := .F.    
_lFim      := .F.
_cMsg01    := ''
_lAborta01 := .T.
_bAcao01   := {|_lFim| 	PA211A(@_lFim) }
_cTitulo01 := 'Enviando E-mail !!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

RestArea(_aAliSB8)
RestArea(_aAliOri)

Return


Static Function PA211A(_lFim)

aStru := {}                            
AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
AADD(aStru,{"DESPROD"  , "C" , 30, 0 })
AADD(aStru,{"ENTRADA"  , "D" , 08, 0 })
AADD(aStru,{"LOTE"     , "C" , 10, 0 })
AADD(aStru,{"QTDE"     , "N" , 14, 3 })
AADD(aStru,{"DTVAL"    , "D" , 08, 0 })
AADD(aStru,{"DOC"      , "C" , 09, 0 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "PRODUTO"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")
                                
_lEnvia := .F.

_cQuery := " SELECT B8_PRODUTO,B1_DESC,B8_LOCAL,B8_SALDO,B8_DOC,B8_DTVALID,B8_LOTECTL,B8_QTDORI,B8_DATA FROM "+RetSqlName("SB8")+" B8 (NOLOCK) "
_cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 (NOLOCK) ON B1_COD = B8_PRODUTO "
_cQuery += " WHERE B8.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' "
_cQuery += " AND B1_RASTRO = 'L' AND B1_TIPO = 'MP' AND B8_SALDO > 0 AND B8_LOCAL = '01'  AND B8_DTVALID <= '"+DTOS(dDataBase+10)+"' "
_cQuery += " ORDER BY B8_PRODUTO "

TCQUERY _cQuery New ALIAS "ZB8"

TcSetField("ZB8","B8_DATA" ,"D",8)
TcSetField("ZB8","B8_DTVALID" ,"D",8)

ZB8->(dbGoTop())

While ZB8->(!Eof())

	TRB->(RecLock("TRB",.T.))
	TRB->PRODUTO := ZB8->B8_PRODUTO
	TRB->DESPROD := ZB8->B1_DESC
	TRB->ENTRADA := ZB8->B8_DATA              
	TRB->LOTE    := ZB8->B8_LOTECTL
	TRB->QTDE    := ZB8->B8_SALDO
	TRB->DTVAL   := ZB8->B8_DTVALID
	TRB->DOC     := ZB8->B8_DOC
	TRB->(MsUnlock())		

	_lEnvia := .T.	 

	ZB8->(dbSkip())
EndDo

If _lEnvia
	PA211B()
Endif

ZB8->(dbCloseArea())
TRB->(dbCloseArea())

Return


Static Function PA211B()
                   
Private _lRet

nOpcao := 0

ConOut("Enviando E-Mail para LABORATORIO:")

oProcess := TWFProcess():New( "ENVEM1", "Laboratorio " )
aCond    :={}
_nTotal  := 0

oProcess:NewTask( "Validade", "\WORKFLOW\VAL_PROD.HTM" )
oProcess:bReturn  := ""
oProcess:bTimeOut := ""
oHTML := oProcess:oHTML

_nPerIpi  := 0
nValIPI   := 0
nTotal    := 0

oProcess:cSubject := "Validade Mat. Prima "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

/*
oHtml:ValByName( "NUMERO" , TRB->NUMERO)
  */
  
TRB->(dbGoTop())


While TRB->(!Eof())

	AADD( (oHtml:ValByName( "TB.PRODUTO"  )), TRB->PRODUTO)
//	AADD( (oHtml:ValByName( "TB.DESPROD"  )), TRB->DESPROD)
	AADD( (oHtml:ValByName( "TB.LOTE"     )), TRB->LOTE)
	AADD( (oHtml:ValByName( "TB.QTDE"     )), TRANSFORM( TRB->QTDE,   '@E 999,999,999.999' ))	
	AADD( (oHtml:ValByName( "TB.ENTRADA"  )), DTOC(TRB->ENTRADA))
	AADD( (oHtml:ValByName( "TB.DTVALID"  )), DTOC(TRB->DTVAL))
	AADD( (oHtml:ValByName( "TB.DOC"      )), TRB->DOC)
	
	oProcess:fDesc := "Validade MP"
	  
	TRB->(dbSkip())
EndDo
                                           
//_cTo := GETMV("MV_WEMLAB1")
_cTo := "fabiano@assystem.com.br"
//_cCc := GETMV("MV_WEMALM1")
_cCc := ""

oProcess:cTo := _cTo
oProcess:cCC := _cCC

oProcess:Start()

RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Envio Email para LAB iniciado!' )

oProcess:Finish()

Return
