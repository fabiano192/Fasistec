#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PA0221  ³ Autor ³Fabiano da Silva       ³ Data ³ 23/09/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envio de E-mail referente aos processos que ainda nao     ³±±
±±³			   foram embarcados.										 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Exportacao                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0221()

PREPARE ENVIRONMENT Empresa "01" Filial "01"
	
_aAliOri := GetArea()       
_aAliEEC := EEC->(GetArea())
_aAliEE9 := EE9->(GetArea())

_lEnvia    := .F.    
_lFim      := .F.
_cMsg01    := ''
_lAborta01 := .T.
_bAcao01   := {|_lFim| 	PA221A(@_lFim) }
_cTitulo01 := 'Enviando E-mail !!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

RestArea(_aAliEE9)
RestArea(_aAliEEC)
RestArea(_aAliOri)

Return


Static Function PA221A(_lFim)
    
//Local oExcel
Private cArq
Private nArq
Private cPath

cPath := "\ArqCSV\"
//cPath := AllTrim(GetTempPath())

cArq  := CriaTrab(Nil, .F.)
nArq  := FCreate(cPath + cArq + ".CSV")

If nArq == -1  
	MsgAlert("Não conseguiu criar o arquivo!")
	Return
EndIf

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

FWrite(nArq, "CLIENTE;LOJA;PROCESSO;EMISSAO;COD.PASY;COD.CLIENTE;REF.CLIENTE;QUANTIDADE;UNITARIO;TOTAL" + Chr(13) + Chr(10))
//FWrite(nArq, "" + Chr(13) + Chr(10))
                                
_lEnvia := .F.

_cQuery := " SELECT EEC_IMPORT,EEC_IMLOJA,EEC_IMPODE,EEC_PREEMB,EEC_DTPROC,EE9_COD_I,EE9_PART_N,EE9_REFCLI,EE9_SLDINI,EE9_PRECO,EE9_PRCTOT "
_cQuery += " FROM "+RetSqlName("EEC")+" EEC (NOLOCK) "
_cQuery += " INNER JOIN "+RetSqlName("EE9")+" EE9 (NOLOCK) ON EEC_PREEMB = EE9_PREEMB "
_cQuery += " WHERE EEC.D_E_L_E_T_ = '' AND EE9.D_E_L_E_T_ = '' "
_cQuery += " AND EEC_DTEMBA = '' AND EEC_STATUS <> '*' "
_cQuery += " ORDER BY EEC_IMPORT,EEC_IMLOJA,EEC_PREEMB,EE9_COD_I"

TCQUERY _cQuery New ALIAS "ZEC"

TcSetField("ZEC","EEC_DTPROC" ,"D",8)

ZEC->(dbGoTop())

While ZEC->(!Eof())

	If !TRB->(dbSeek(ZEC->EEC_PREEMB))
		TRB->(RecLock("TRB",.T.))
		TRB->CLIENT  := ZEC->EEC_IMPORT
		TRB->LOJA    := ZEC->EEC_IMLOJA
		TRB->NOME    := ZEC->EEC_IMPODE              
		TRB->PROCES  := ZEC->EEC_PREEMB
		TRB->DTPROC  := ZEC->EEC_DTPROC
		TRB->(MsUnlock())		
	Endif	

	_cCli := Alltrim(ZEC->EEC_IMPORT)
	_cLoj := Alltrim(ZEC->EEC_IMLOJA)
	_cPro := Alltrim(ZEC->EEC_PREEMB)
	_cEmi := dToc(ZEC->EEC_DTPROC)
	_cCPa := Alltrim(ZEC->EE9_COD_I)
	_cCCl := Alltrim(ZEC->EE9_PART_N)
	_cRef := Alltrim(ZEC->EE9_REFCLI)
	_cQte := Alltrim(Transform(ZEC->EE9_SLDINI,"@ze 9,999,999.99"))
	_cUni := Alltrim(Transform(ZEC->EE9_PRECO,"@ze 9,999,999.99"))
	_cTot := Alltrim(Transform(ZEC->EE9_PRCTOT,"@ze 9,999,999.99"))
	
//	FWrite(nArq, _cCli+";"+_cLoj+";"+_cPro+";"+_cEmi+";"+_cCPa+";"+_cCCl+";"+_cRef+";"+_cQte+";"+_cUni+";"+_cTot + Chr(13) + Chr(10))
	FWrite(nArq, "'"+_cCli+";'"+_cLoj+";"+_cPro+";"+_cEmi+";'"+_cCPa+";'"+_cCCl+";'"+_cRef+";"+_cQte+";"+_cUni+";"+_cTot + Chr(13) + Chr(10))

	_lEnvia := .T.	 

	ZEC->(dbSkip())
EndDo

FClose(nArq)

If _lEnvia
	PA221B()
Endif

ZEC->(dbCloseArea())
TRB->(dbCloseArea())

Return


Static Function PA221B()
                   
Private _lRet

nOpcao := 0

ConOut("Enviando E-Mail de Processos não embarcados:")

oProcess := TWFProcess():New( "ENVEM1", "Exportacao " )
aCond    :={}
_nTotal  := 0

oProcess:NewTask( "PROC_NAO_EMBARCADO", "\WORKFLOW\ENV_PNE.HTM" )
oProcess:bReturn  := ""
oProcess:bTimeOut := ""
oHTML := oProcess:oHTML

_nPerIpi  := 0
nValIPI   := 0
nTotal    := 0

oProcess:cSubject := "Processo(s) não Embarcado(s) - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

TRB->(dbGoTop())

While TRB->(!Eof())

	AADD( (oHtml:ValByName( "TB.CODIGO"   )), TRB->CLIENT)
	AADD( (oHtml:ValByName( "TB.LOJA"     )), TRB->LOJA)
	AADD( (oHtml:ValByName( "TB.NOME"     )), TRB->NOME)
	AADD( (oHtml:ValByName( "TB.PROCESS"  )), TRB->PROCES)
	AADD( (oHtml:ValByName( "TB.DTPROC"   )), DTOC(TRB->DTPROC))
	
	oProcess:fDesc := "PROCESSOS NÃO EMBARCADOS"
	  
	TRB->(dbSkip())
EndDo
                                           
_cTo := GETMV("MV_WEMDIR1")
//_cTo := "fabiano@assystem.com.br"
//_cTo := GETMV("MV_WEMTI1")
_cCc := GETMV("PA_WFASN02")+";"+GETMV("MV_WEMTI1")+";"+GETMV("MV_WEMPCP1")+";"+GETMV("PA_WFASN01")
//_cCc := ""

oProcess:AttachFile(cPath + cArq + ".CSV")

oProcess:cTo := _cTo
oProcess:cCC := _cCC

oProcess:Start()

RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Envio Email PNE iniciado!' )

oProcess:Finish()

Return
