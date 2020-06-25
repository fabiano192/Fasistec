#include "Protheus.ch"
#include "TopConn.ch"
#include "RwMake.ch"

User Function GeraClVl()

DbSelectArea("SA1")
SA1->(DbGoTop())
While SA1->(!EoF())
	DBSELECTAREA("CTH")
	CTH->(DBSETORDER(1))
	IF CTH->(!DBSEEK(xFILIAL("CTH")+SA1->A1_COD+SA1->A1_LOJA, .F.))
		If RecLock("CTH",.T.)
			CTH->CTH_FILIAL := xFILIAL("CTH")
			CTH->CTH_CLVL   := SA1->A1_COD+SA1->A1_LOJA
			CTH->CTH_CLASSE := "2"
			CTH->CTH_BLOQ   := "2"
			CTH->CTH_DESC01 := SA1->A1_NOME
			CTH->CTH_NORMAL := "0"
			CTH->(MsUnlock())
		EndIf
	ENDIF
	SA1->(DbSkip())
EndDo

DbSelectArea("SA2")
SA2->(DbGoTop())
While SA2->(!EoF())
	DBSELECTAREA("CTH")
	CTH->(DBSETORDER(1))
	IF CTH->(!DBSEEK(xFILIAL("CTH")+SA2->A2_COD+SA2->A2_LOJA, .F.))
		If RecLock("CTH",.T.)
			CTH->CTH_FILIAL := xFILIAL("CTH")
			CTH->CTH_CLVL   := SA2->A2_COD+SA2->A2_LOJA
			CTH->CTH_CLASSE := "2"
			CTH->CTH_BLOQ   := "2"
			CTH->CTH_DESC01 := SA2->A2_NOME
			CTH->CTH_NORMAL := "0"
			CTH->(MsUnlock())
		EndIf
	ENDIF
	SA2->(DbSkip())
EndDo

Return (Nil)