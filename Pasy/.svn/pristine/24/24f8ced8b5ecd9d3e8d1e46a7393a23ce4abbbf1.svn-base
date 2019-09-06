#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PA0055    ³ Autor ³ Alexandro da Silva    ³ Data ³ 19.03.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Tela de cadastramento De Roteiro de Processo                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

User Function pa0055()

_aAliOri := GetArea()

PRIVATE aMemos  := {{"Z9_CODMEMO","Z9_DESC"}}
Private cVldAlt := .T.
Private cVldVis := .T.
Private cVldExc := .T. 


AxCadastro("SZ9","Cadastro de Processo","U_VerMov2()")

RestArea(_aAliOri)

Return



User Function VerMov2()

_aAliOri2:= GetArea()
_aAliSG2 := SG2->(GetArea())
_lRet    := .T.

dbSelectArea("SG2")
dbOrderNickname("INDSG21")
If dbSeek(xFilial("SG2")+SZ9->Z9_CODIGO)
   MSGBOX("Cadastro ja Possui Movimento e nao Pode ser Excluido!!!","Informacao","INFO")
   _lRet := .F.
Endif

RestArea(_aAliSG2)
RestArea(_aAliOri2)

Return(_lRet)   

Return 