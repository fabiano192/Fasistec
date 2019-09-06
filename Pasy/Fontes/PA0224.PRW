#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
Função    ³ PA0224   ³ Autor ³ Fabiano da Silva     
Data      ³ 28.02.12 
Descrição ³ Verifica se existe arquivo EDI - CBL				       
Uso       ³ Sigafat Caterpillar                                        
*/

User Function PA0224()

PREPARE ENVIRONMENT Empresa "01" Filial "01"
	
_aAliOri := GetArea()       

_lEnvia    := .F.    
_lFim      := .F.
_cMsg01    := ''
_lAborta01 := .T.
_bAcao01   := {|_lFim| 	PA224A(@_lFim) }
_cTitulo01 := 'Enviando E-mail !!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

RestArea(_aAliOri)

Return


Static Function PA224A(_lFim)
    

aStru := {}                            
AADD(aStru,{"DATAEDI"    , "D" , 08, 0 })
AADD(aStru,{"SEMANA"     , "C" , 20, 0 })
AADD(aStru,{"STATEDI"    , "C" , 35, 0 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "DTOS(DATAEDI)"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

_dDt := dDataBase - 10

ProcRegua(10)

For Z:= _dDt TO dDataBase
	
	IncProc()
	
	_lDir := ExistDir("\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\Caterpillar\Brasil\Entrada\"+DTOS(_dDt))
	
	If _lDir
		TRB->(RecLock("TRB",.T.))
		TRB->DATAEDI  := _dDt
		TRB->SEMANA   := FG_CDOW(_dDt)
		TRB->STATEDI  := "OK"
		TRB->(MsUnlock())
	Else
		TRB->(RecLock("TRB",.T.))
		TRB->DATAEDI  := _dDt
		TRB->SEMANA   := FG_CDOW(_dDt)
		TRB->STATEDI  := "Sem arquivo para ser integrado"
		TRB->(MsUnlock())	
	Endif

	_dDt++
	
Next Z
                  
Private _lRet

nOpcao := 0

ConOut("Enviando E-Mail referente a existencia do arquivo EDI")

oProcess := TWFProcess():New( "ENVEM1", "EDI" )
aCond    :={}
_nTotal  := 0

oProcess:NewTask( "Existe_EDI", "\WORKFLOW\EXI_EDI.HTM" )
oProcess:bReturn  := ""
oProcess:bTimeOut := ""
oHTML := oProcess:oHTML

_nPerIpi  := 0
nValIPI   := 0
nTotal    := 0

oProcess:cSubject := "Conferencia da existencia de arquivos EDI(CBL) - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

TRB->(dbGoTop())

While TRB->(!Eof())

	AADD( (oHtml:ValByName( "TB.DATAEDI"  )), DTOC(TRB->DATAEDI))
	AADD( (oHtml:ValByName( "TB.SEMANA"   )), TRB->SEMANA)
	AADD( (oHtml:ValByName( "TB.STATEDI"  )), TRB->STATEDI)
	
	oProcess:fDesc := "Existencia EDI - CBL"

	TRB->(dbSkip())
EndDo
                                           
_cTo := GETMV("MV_WEMPCP3")
//_cTo := GETMV("MV_WEMTI1")
_cCc := GETMV("MV_WEMTI1")
//_cCc := ""

oProcess:cTo := _cTo
oProcess:cCC := _cCC

oProcess:Start()

RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Envio Email EX_EDI iniciado!' )

oProcess:Finish()

Return
