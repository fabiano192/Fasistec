#include "rwmake.ch"

User Function AcePEDALI()

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


cArqLOG := "SZ2CNH"
cIndLOG := "CODCLI+LOJA+PRODCLI+PCATUAL"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

dbSelectArea("TRB")
dbGotop()

ProcRegua(LastRec())

While !Eof()
	
	If _lFim
		Alert("cancelado pelo Operador!!")
		Return
	EndIf
	
	IncProc()
	
	dbSelectArea("SZ2")
	dbSetOrder(6)
	If dbSeek(xFilial("SZ2")+TRB->CODCLI+TRB->LOJA+TRB->PRODCLI+"1")
		
		_cChaVSZ2 := SZ2->Z2_CLIENTE+SZ2->Z2_LOJA+SZ2->Z2_CODCLI
		
		While !Eof() .And. _cChaVSZ2 == SZ2->Z2_CLIENTE+SZ2->Z2_LOJA+SZ2->Z2_CODCLI
			
			If SZ2->Z2_PEDCLI == TRB->PCANT
				dbSelectArea("SZ2")
				RecLock("SZ2",.F.)
				SZ2->Z2_PEDCLI := TRB->PCATUAL
				MsUnlock()
			Endif
			
			VerPed()
			dbSelectArea("SZ2")
			dbSkip()
		EndDo
	Endif
	
	dbSelectArea("TRB")
	dbSkip()
Enddo


Return


Static Function VerPed()


dbSelectArea("SC6")
dbSetOrder(9)
If dbSeek(xFilial("SC6")+SZ2->Z2_CLIENTE+SZ2->Z2_LOJA+SZ2->Z2_PRODUTO+SZ2->Z2_CODCLI)
	
	_cChavSC6 := SC6->C6_CLI+SC6->C6_LOJA + SC6->C6_PRODUTO+ SC6->C6_CPROCLI
	
	While !Eof() .And. _cChavSC6 == SC6->C6_CLI+SC6->C6_LOJA + SC6->C6_PRODUTO+ SC6->C6_CPROCLI
		
		
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
		
		dbSelectArea("SC6")
		RecLock("SC6",.F.)
		SC6->C6_CPROCLI := TRB->PCATUAL
		MsUnlock()
		
		dbSelectArea("SC6")
		dbSkip()
	EndDo
	
Endif


Return   