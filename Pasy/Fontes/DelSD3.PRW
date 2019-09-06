#include "rwmake.ch"

User Function DELSD3()

SetPrvt("_cAliOri,_nOrdOri,_nRecOri,_aStrREt,_cArqRet")

_cAliOri := Alias()
_nOrdOri := IndexOrd()
_nRecOri := Recno()
_lBx     := .F.

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| DELSD31(@_lFim) }
Private _cTitulo01 := 'Deletando Sd3'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

MSGINFO("Alteracao Efetuada com Sucesso !!! ")
Return



Static Function DELSD31(_lFim)

dbSelectArea("SD3")
dbGotop()

ProcRegua(LastRec())

While !Eof() .And. !_lFim
                    
	If SD3->D3_EMISSAO >= CTOD("01/01/06")
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif
	
	IF !SD3->D3_LOCAL $ "10/97" 
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif

	If Empty(SD3->D3_OP)
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif

	dbSelectArea("SD3")
	RecLock("SD3",.F.)
	SD3->D3_USUARIO := "210806"
	dbDelete()
	MsUnlock()
        
    dbSelectArea("SD3")
	dbSkip()
EndDo	    	 	

Return	