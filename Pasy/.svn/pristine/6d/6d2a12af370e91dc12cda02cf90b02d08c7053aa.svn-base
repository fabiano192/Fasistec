#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PA0218  ³ Autor ³Fabiano da Silva       ³ Data ³ 15/08/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envio de E-mail referente ao envio de ASN CAT Expotacao   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Exportacao                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

/*/

User Function PA0218()

PREPARE ENVIRONMENT Empresa "01" Filial "01"
	
_aAliOri := GetArea()       
_aAliEEC := EEC->(GetArea())

_lEnvia    := .F.    
_lFim      := .F.
_cMsg01    := ''
_lAborta01 := .T.
_bAcao01   := {|_lFim| 	PA218A(@_lFim) }
_cTitulo01 := 'Enviando E-mail !!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

RestArea(_aAliEEC)
RestArea(_aAliOri)

Return


Static Function PA218A(_lFim)

aStru := {}                            
AADD(aStru,{"CLIENT"   , "C" , 06, 0 })
AADD(aStru,{"LOJA"     , "C" , 02, 0 })
AADD(aStru,{"NOME"     , "C" , 30, 0 })
AADD(aStru,{"PROCES"   , "C" , 12, 0 })
AADD(aStru,{"DTPROC"    , "D" , 08, 0 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "PROCES"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")
                                
_lEnvia := .F.

_cQuery := " SELECT EEC_IMPORT,EEC_IMLOJA,EEC_IMPODE,EEC_PREEMB,EEC_DTPROC "
_cQuery += " FROM "+RetSqlName("EEC")+" EEC (NOLOCK) "
_cQuery += " WHERE EEC.D_E_L_E_T_ = '' "
_cQuery += " AND EEC_DTASN = '' AND EEC_IMPORT = '000171' "
_cQuery += " ORDER BY EEC_PREEMB"

TCQUERY _cQuery New ALIAS "ZEC"

TcSetField("ZEC","EEC_DTPROC" ,"D",8)

ZEC->(dbGoTop())

While ZEC->(!Eof())

	TRB->(RecLock("TRB",.T.))
	TRB->CLIENT  := ZEC->EEC_IMPORT
	TRB->LOJA    := ZEC->EEC_IMLOJA
	TRB->NOME    := ZEC->EEC_IMPODE              
	TRB->PROCES  := ZEC->EEC_PREEMB
	TRB->DTPROC  := ZEC->EEC_DTPROC
	TRB->(MsUnlock())		

	_lEnvia := .T.	 

	ZEC->(dbSkip())
EndDo

If _lEnvia
	PA218B()
Endif

ZEC->(dbCloseArea())
TRB->(dbCloseArea())

Return


Static Function PA218B()
                   
Private _lRet

nOpcao := 0

ConOut("Enviando E-Mail sobre ASN:")

oProcess := TWFProcess():New( "ENVEM1", "Expotacao " )
aCond    :={}
_nTotal  := 0

oProcess:NewTask( "ASN", "\WORKFLOW\ENV_ASN.HTM" )
oProcess:bReturn  := ""
oProcess:bTimeOut := ""
oHTML := oProcess:oHTML

_nPerIpi  := 0
nValIPI   := 0
nTotal    := 0

oProcess:cSubject := "Processo(s) sem ASN - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

TRB->(dbGoTop())

While TRB->(!Eof())

	AADD( (oHtml:ValByName( "TB.CODIGO"   )), TRB->CLIENT)
	AADD( (oHtml:ValByName( "TB.LOJA"     )), TRB->LOJA)
	AADD( (oHtml:ValByName( "TB.NOME"     )), TRB->NOME)
	AADD( (oHtml:ValByName( "TB.PROCESS"  )), TRB->PROCES)
	AADD( (oHtml:ValByName( "TB.DTPROC"   )), DTOC(TRB->DTPROC))
	
	oProcess:fDesc := "ASN - EMBARQUES"
	  
	TRB->(dbSkip())
EndDo
                                           
_cTo := GETMV("MV_WEMDIR1")
//_cTo := GETMV("PA_WFASN01")
//_cTo := "fabiano@assystem.com.br"
_cCc := GETMV("PA_WFASN02")+";"+GETMV("MV_WEMTI1")
//_cCc := ""

oProcess:cTo := _cTo
oProcess:cCC := _cCC

oProcess:Start()

RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Envio Email ASN iniciado!' )

oProcess:Finish()

Return
