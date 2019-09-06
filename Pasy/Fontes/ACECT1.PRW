#INCLUDE "PROTHEUS.CH"

/*
Autor : Fabiano da Silva
Data  : 18/03/09
Desc  : Inserção de dados na tabela CT1010 - PLANO DE CONTAS
Uso   : SIGACTB - CONTABILIDADE
*/

USER FUNCTION ACECT1()

Local aContab 		:= {}
Local nOpc   		:= 3
Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.

_cArqDbf := "PLANO.DBF"
_cArqInd := "CT1IND"

_cIndTRB := "CONTA"

dbUseArea(.T.,,_cArqDBF,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",_cArqInd,_cIndTRB,,,"Criando Trabalho...")

TRB->(dbGotop())

ProcRegua(TRB->(U_CONTREG()))

While TRB->(!Eof())
	
	IncProc()
	
    aContab := {}
	aContab := {{'CT1_CONTA' 	, TRB->CONTA 	, NIL},;
	{'CT1_DESC01'	, TRB->DESCRIC	, NIL},;
	{'CT1_CLASSE'	, TRB->CLASSE	, NIL},;
	{'CT1_NORMAL'	, TRB->NORMAL	, NIL},;
	{'CT1_RES'		, TRB->RESUM	, NIL},;
	{'CT1_BLOQ'		, TRB->BLOQ		, NIL},;
	{'CT1_DTEXIS'	, TRB->EXIST	, NIL}}
	
	lMSHelpAuto := .t.
	lMsErroAuto := .f. // se retornar .t. deu erro
	MSExecAuto({|x,y| CTBA020(x,y)},aContab,nOpc)
	
	If lMsErroAuto
		MOSTRAERRO()
		Return (.F.)
	Endif
		
	TRB->(dbSkip())
EndDo

TRB->(dbCloseArea())

Return (.T.)