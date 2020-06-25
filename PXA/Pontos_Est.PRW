#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Rotina   ³ PONTOS DE ENTRADA DO ESTOQUE            ³ Data ³ 22/04/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ PONTOS DE ENTRADA DO ESTOQUE                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Módulo   ³ SIGAEST                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT010INC()

//Private nOpc:= 3 //INCLUSAO

_aAliOri := GetArea()
_aAliSB1 := SB1->(GetArea())
_aAliSBZ := SBZ->(GetArea())

//If cEmpAnt <> "13"
	
	SBZ->(dbSetOrder(1))
	If SBZ->(!dbSeek(xFilial("SBZ")+ SB1->B1_COD))
		SBZ->(RecLock("SBZ",.T.))
		SBZ->BZ_FILIAL  := xFilial("SBZ")
		SBZ->BZ_COD     := SB1->B1_COD
		SBZ->BZ_LOCPAD  := SB1->B1_LOCPAD
		SBZ->BZ_YCONTA  := SB1->B1_CONTA
		SBZ->BZ_YPRAT   := SB1->B1_YPRAT
		SBZ->(MsUnlock())
	Endif
//Endif

RestArea(_aAliSB1)
RestArea(_aAliSBZ)
RestArea(_aAliORI)

Return

User Function MTA240MNU()

aadd(aRotina,{"Dados Contábeis"	,"U_VN0001()" , 0 , 4,0,NIL})

Return(aRotina)