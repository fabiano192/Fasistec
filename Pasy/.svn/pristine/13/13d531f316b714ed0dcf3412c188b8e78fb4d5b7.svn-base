#include "rwmake.ch"
#INCLUDE "TOPCONN.ch"

User Function ACESZC()

_cArqDbf := "SZC.DBF"
_cArqInd := "SZC"
                                                                             
_cIndTRB := "CLIENTE+LOJA+PRODUTO+PRODCLI"

dbUseArea(.T.,,_cArqDBF,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",_cArqInd,_cIndTRB,,,"Criando Trabalho...")

TRB->(dbGotop())

//ProcRegua(TRB->(U_CONTREG()))

While TRB->(!Eof())
	
//	IncProc()

	SZC->(dbSetOrder(1))
	If SZC->(dbseek(xFilial("SZC")+TRB->CLIENTE + TRB->LOJA + TRB->PRODUTO + TRB->PRODCLI))
	
		_cChav := SZC->ZC_CLIENTE + SZC->ZC_LOJA + SZC->ZC_PRODUTO + SZC->ZC_PRODCLI

		While SZC->(!Eof()) .And. _cChav == SZC->ZC_CLIENTE + SZC->ZC_LOJA + SZC->ZC_PRODUTO + SZC->ZC_PRODCLI
	
			_cQuery := " UPDATE SZC010 SET ZC_PEDCLI = '"+TRB->PEDCLI2+"' "
			_cQuery += " WHERE ZC_CLIENTE+ZC_LOJA+ZC_PRODUTO+ZC_PRODCLI = '"+TRB->CLIENTE+TRB->LOJA+TRB->PRODUTO+TRB->PRODCLI+"' "
			

			TCSQLEXEC(_cQuery)
			
			SZC->(dbSkip())
		EndDo
	Endif		
	
    TRB->(dbSkip())
    
EndDo

TRB->(dbCloseArea())

Return(Nil)
