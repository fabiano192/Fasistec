#include "rwmake.ch"

User Function ACEDOC()

SetPrvt("_cAliOri,_nOrdOri,_nRecOri,_aStrREt,_cArqRet")

_cAliOri := Alias()
_nOrdOri := IndexOrd()
_nRecOri := Recno()
_lBx     := .F.

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| ACENUM(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

MSGINFO("Alteracao Efetuada com Sucesso !!! ")
     

Return



Static Function ACENUM(_lFim)


_cItem   := "000001"
dbSelectArea("SD3")
dbSetOrder(4)
//dbSeek(xFilial("SD3")+"799509",.T.)
dbGotop()

ProcRegua(LastRec())

While !Eof() .And. !_lFim
	
	If _lFim
		Alert("cancelado pelo Operador!!")
		Return
	EndIf
	
	_cNumSeq := SD3->D3_NUMSEQ
	
	While !Eof() .And.	_cNumSeq == SD3->D3_NUMSEQ
		
		IncProc()
		
		dbSelectArea("SD3")
		RecLock("SD3",.F.)
		SD3->D3_DOC    := _cItem
		SD3->D3_CUSTO2 := 0
		SD3->D3_CUSTO3 := 0
		MsUnlock()
		
		dbSelectArea("SD3")
		dbSkip()
	EndDo
	
    _cItem := StrZero( (Val(_cItem)+1) ,6)
	
	dbSelectArea("SD3")
	dbSetOrder(4)
EndDo


Return