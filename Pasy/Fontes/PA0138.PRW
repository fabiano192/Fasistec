#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0138   ³ Autor ³ Fabiano da Silva      ³ Data ³ 16.07.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verificação das pastas de Programação Caterpillar Brasil   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat Caterpillar                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0138()

PREPARE ENVIRONMENT Empresa "01" Filial "01"

_lEnvia    := .F.
_lFim      := .F.
_cMsg01    := ''
_lAborta01 := .T.  

_bAcao01   := {|_lFim| 	PA138A(@_lFim) }
_cTitulo01 := 'Enviando E-mail !!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

dbSelectArea("TRB")
dbCloseArea()

Return


Static Function PA138A(_lFim)

aStru := {}
AADD(aStru,{"ENTRADA"    , "D" , 08, 0 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "ENTRADA"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

_dDt    := dDataBase - 10

ProcRegua(20)

For Z:= _dDt TO dDataBase
	
	IncProc()
	
	If Dow(_dDt) != 1

//		_cDir1 := "O:\AP7\AP_DATA\Caterpillar\ENTRADA\"+DTOS(_dDt)+"\*Vendas.????.000001.RND001*.TXT"
		_cDir1 := "\CATERPILLAR\BRASIL\ENTRADA\"+DTOS(_dDt)+"\*Vendas.????.000001.RND001*.TXT"
		  	
		_aArqTx1 = ARRAY(ADIR(_cDir1))
		ADIR("\CATERPILLAR\BRASIL\ENTRADA\"+DTOS(_dDt)+"\*Vendas.????.000001.RND001*.TXT",_aArqTx1)
		
		_lEnvia := .T.
		For I:= 1 to Len(_aArqTx1)
			
			_lEnvia := .F.
			
		Next I
/*		                	
		_cDir := "O:\AP7\AP_DATA\Caterpillar\ENTRADA\"+DTOS(_dDt)+"\bkp_Vendas.????.000001.RND001*.TXT"
		
		_aArqTxt = ARRAY(ADIR(_cDir))
		ADIR("O:\AP7\AP_DATA\Caterpillar\ENTRADA\"+DTOS(_dDt)+"\bkp_Vendas.????.000001.RND001*.TXT",_aArqTxt)
		
		For I:= 1 to Len(_aArqTxt)
			
			_lEnvia := .F.
			
		Next I
*/
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->ENTRADA := _dDt
		MsUnlock()
		
		If _lEnvia
			PA138B()
		Endif
	Endif

	_dDt++

Next Z

Return


Static Function PA138B()

Private _lRet

nOpcao := 0

ConOut("Enviando E-Mail:")

oProcess := TWFProcess():New( "ENVEM1", "Tecnologia da Informacao " )
aCond    :={}
_nTotal  := 0

oProcess:NewTask( "Integracao", "\WORKFLOW\EMTECINF.HTM" )
oProcess:bReturn  := ""
oProcess:bTimeOut := ""
oHTML  := oProcess:oHTML

dbSelectArea("TRB")

_nPerIpi  := 0
nValIPI   := 0
nTotal    := 0

oProcess:cSubject := "Verificacao de Programacao CBL "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

oHtml:ValByName( "ENTRADA", DTOC(TRB->ENTRADA))

_cTo := GETMV("MV_WEMTI1")

oProcess:cTo := _cTo

oProcess:Start()
RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Envio Email para TI iniciado!' )

oProcess:Finish()

Return
