#include "rwmake.ch"

User Function AceInvent()

SetPrvt("_cAliOri,_nOrdOri,_nRecOri,_aStrREt,_cArqRet")

_cAliOri := Alias()
_nOrdOri := IndexOrd()
_nRecOri := Recno()
_lBx     := .F.

Processa({|lend| AceSB7A()},"Alterando ")


MSGINFO("Alteracao Efetuada com Sucesso !!! ")
Return



Static Function AceSB7A()

dbSelectArea("SB1")
dbGotop()

ProcRegua(LastRec())
/*
While !Eof()

IncProc()

dbSelectArea("SB9")
dbSetOrder(1)
If dbSeek(xFilial("SB9")+SB1->B1_COD+SB1->B1_LOCPAD +"20030607")
dbSelectArea("SB1")
RecLock("SB1",.F.)
SB1->B1_APROPRI := "I"
MsUnlock()
Endif

dbSelectArea("SB1")
dbSkip()

EndDo

*/

While !Eof()
	If SB1->B1_APROPRI == "I"
		dbSelectArea("SD4")
		dbSetOrder(5)
		If dbSeek(xFilial("SD4")+SB1->B1_COD)
			
			_cChavSD4 := SD4->D4_COD
			
			While !Eof() .And. _cChavSD4 == SD4->D4_COD
				
				dbSelectArea("SD4")
				RecLocK("SD4",.F.)
				SD4->D4_LOCAL := "97"
				MsUnlock()
				
				dbSelectArea("SD4")
				dbSkip()
			EnddO
		Endif
	Endif
	
	dbSelectArea("SB1")
	dbSkip()
Enddo

Return
