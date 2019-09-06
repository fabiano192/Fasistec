#include "rwmake.ch"

User Function AcePED()

SetPrvt("_cAliOri,_nOrdOri,_nRecOri,_aStrREt,_cArqRet")

_cAliOri := Alias()
_nOrdOri := IndexOrd()
_nRecOri := Recno()
_lBx     := .F.

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| ACEPEDCLI2(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

MSGINFO("Alteracao Efetuada com Sucesso !!! ")
Return



Static Function ACEPEDCLI2(_lFim)

dbSelectArea("SC6")
dbSetOrder(1)
dbGotop()

While !Eof() 
		
	If !Empty(SC6->C6_BLQ)
		dbSelectArea("SC6")
		dbSkip()
		Loop
	Endif
		
	If SC6->C6_QTDENT = SC6->C6_QTDVEN
		dbSelectArea("SC6")
		dbSkip()
		Loop
	Endif

	If SC6->C6_CLI != "000008"		
		dbSelectArea("SC6")
		dbSkip()
		Loop
	Endif
	
	If !SC6->C6_PEDAMOS $ "A/Z"		
		dbSelectArea("SC6") 
		dbSkip()
		Loop
	Endif

	dbSelectArea("SC6")
	RecLock("SC6",.F.)
	SC6->C6_XDTELIM  := CTOD("12/02/06")
	SC6->C6_BLQ      := "R"
	MsUnlock()
		
	dbSelectArea("SC6")
	dbSkip()
EndDo
	
Return   