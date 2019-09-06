#include "rwmake.ch"

User Function AceSD4()

SetPrvt("_cAliOri,_nOrdOri,_nRecOri,_aStrREt,_cArqRet")

_cAliOri := Alias()
_nOrdOri := IndexOrd()
_nRecOri := Recno()
_lBx     := .F.

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| ACESD41(@_lFim) }
Private _cTitulo01 := 'Processando eMPENHO'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

MSGINFO("Alteracao Efetuada com Sucesso !!! ")
Return



Static Function ACESD41(_lFim)

_cChave  := "D4_OP+DESCEND(DTOS(D4_DATA))+D4_COD"
dbSelectArea("SD4")
_cIndex  := CriaTrab(nil,.f.)

dbSelectArea("SD4")
IndRegua("SD4",_cIndex,_cChave,,,"Selecionando Registros...")
	
dbSelectArea("SD4")
dbGotop()

ProcRegua(LastRec())

While !Eof() .and. !_lFim
                    
	_cOp   := SD4->D4_OP
	_dData := SD4->D4_DATA
	While !Eof() .And.	_cOp == SD4->D4_OP 	
        
		IncProc("O.P. : "+SD4->D4_OP)	

		If _dData == SD4->D4_DATA
		
			dbSelectArea("SD4")
			RecLock("SD4",.F.)
    		SD4->D4_LOTECTL := "DELET"
    		dbDelete()
    		MsUnlock()
        
        Endif
              
		dbSelectArea("SD4")
		dbSkip()
	EndDo
EndDo	    	 	

	 
Return	