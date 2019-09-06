#INCLUDE "RWMAKE.CH"

User Function DigSenha()

lRet     := .F.
cSenDig   := Space(6)
cSenPad   := GETMV("MV_SENHA")
              
@ 115,085 To 267,450 Dialog oSenhas Title " Senha"
@ 002,002 To 038,220
@ 009,008 Say OemToAnsi('Entre coma Senha')
@ 042,004 Say OemToAnsi("Senha   :")
@ 042,042 Get cSenDig   PASSWORD Valid (IIF( AllTrim( cSenDig) <> cSenPad, MSGSTOP( "Senha incorreta" ),lRet:=.T.))

@ 059,120 BmpButton Type 1 Action Close(oSenhas)

Activate Dialog oSenhas Centered Valid fecha()


Return(lRet)


Static Function Fecha()


Close(oSenhas)
_cRet := "N"

Return