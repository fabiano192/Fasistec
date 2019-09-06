#include "rwmake.ch"

User Function MOD_DIST()

SetPrvt("_cAliOri,_nOrdOri,_nRecOri,_aStrREt,_cArqRet")

_cAliOri := Alias()
_nOrdOri := IndexOrd()
_nRecOri := Recno()
_lBx     := .F.


Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| ACEPROD(@_lFim) }
Private _cTitulo01 := 'Processando Cadastro de Ferramentas'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

MSGINFO("Alteracao Efetuada com Sucesso !!! ")
Return



Static Function ACEPROD(_lFim)
                    
_cArqDbf := "DADPROD"
_cArqInd := "DADPROD"

_cIndTRB := "PROD_PASY"

dbUseArea(.T.,,_cArqDBF,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",_cArqInd,_cIndTRB,,,"Criando Trabalho...")
              
dbSelectArea("TRB")
dbGotop()

ProcRegua(LastRec())

While !Eof()

	IncProc()
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+TRB->PROD_PASY)
		If SB1->B1_PESO == 0
			dbSelectArea("SB1")
			RecLock("SB1",.F.)
			SB1->B1_PESO := TRB->PESO_PROD
			MsUnlock()
		Endif
		
		dbSelectArea("SB5")
		dbSetOrder(1)
		If dbSeek(xFilial("SB5")+TRB->PROD_PASY)
			dbSelectArea("SB5")
			RecLock("SB5",.F.)
			SB5->B5_ALTURLC := TRB->ALT_UNIT
			SB5->B5_COMPRLC := TRB->COM_UNIT
			SB5->B5_LARGLC  := TRB->LARG_UNIT
			SB5->B5_CODZON  := "000002"
			SB5->B5_UMIND   := "1"
			MsUnlock()         
		Else
			dbSelectArea("SB5")
			RecLock("SB5",.T.)
			SB5->B5_FILIAL  := xFilial("SB5")
			SB5->B5_COD     := TRB->PROD_PASY
			SB5->B5_CEME    := SB1->B1_DESC
			SB5->B5_ALTURLC := TRB->ALT_UNIT
			SB5->B5_COMPRLC := TRB->COM_UNIT
			SB5->B5_LARGLC  := TRB->LARG_UNIT
			SB5->B5_CODCAI  := "SISTEM"
			SB5->B5_CODZON  := "000002"
			SB5->B5_UMIND   := "1"
			MsUnlock()         
		Endif		
	Else
		Alert("Produto Nao Cadastrado!!! "+TRB->PROD_PASY)
	Endif
	                                                      	
	dbSelectArea("TRB")
	dbSkip()
EndDo


Return