#include "rwmake.ch"

User Function ACESC7()

SetPrvt("_cAliOri,_nOrdOri,_nRecOri,_aStrREt,_cArqRet")

_cAliOri := Alias()
_nOrdOri := IndexOrd()
_nRecOri := Recno()
_lBx     := .F.

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| ACESC72(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

MSGINFO("Alteracao Efetuada com Sucesso !!! ")
     

Return



Static Function ACESC72(_lFim)

dbSelectArea("SC7")
dbOrderNickname("INDSC73")
dbGotop()
     
ProcRegua(LastRec())

While !Eof() .And. !_lFim

	IncProc()
	
	_cChavSC7 := SC7->C7_PRODUTO
	_cLote    := 0

	While !Eof() .And.	_cChavSC7 = SC7->C7_PRODUTO .And. Empty(SC7->C7_LOTE)
	           
	    If SC7->C7_QUANT == SC7->C7_QUJE .or. !Empty(SC7->C7_RESIDUO)
	    	dbSkip()
	    	Loop
	    Endif
			
		_cLote++
		                       
		RecLock("SC7",.F.)
		SC7->C7_LOTE := StrZero(_cLote,6)
		MsUnlock()
		               
		dbSelectArea("SC7")
		dbOrderNickName("INDSC73")
		dbSeek(xFilial("SC7") + _cChavSC7)
	EndDo	
	                
	dbSelectArea("SC7")	
   	dbSkip()
EndDo	

Return