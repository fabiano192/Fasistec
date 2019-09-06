#include "rwmake.ch"

User Function AceProd()

SetPrvt("_cAliOri,_nOrdOri,_nRecOri,_aStrREt,_cArqRet")

_cAliOri := Alias()
_nOrdOri := IndexOrd()
_nRecOri := Recno()
_lBx     := .F.

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| ACEB12(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

MSGINFO("Alteracao Efetuada com Sucesso !!! ")
Return



Static Function ACEB12(_lFim)

dbSelectArea("SB1")
dbGotop()

ProcRegua(LastRec())

While !Eof()
	
	If _lFim
		Alert("cancelado pelo Operador!!")
		Return
	EndIf
	
	IncProc()		

	dbSelectArea("SB1")
	RecLock("SB1",.F.)
	SB1->B1_REVMAT := RIGHT(ALLTRIM(SB1->B1_ESPECIF),3)
	MsUnlock()
			
	dbSelectArea("SB1")
	dbSkip()
EndDo


Return