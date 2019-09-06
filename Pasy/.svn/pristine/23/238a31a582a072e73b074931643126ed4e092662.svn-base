#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACESBE    º Autor ³ Fabiando da Silva º Data ³  16/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualizaçao cadastro de endereço                           º±±
±±º          ³                                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ACESBE()

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Rotina Para gerar Endereço")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina Para Atualizacao da Tabela SBE               "     SIZE 160,7
@ 18,18 SAY "                                                    "     SIZE 160,7
@ 26,18 SAY "Programa ACESBE                                     "     SIZE 160,7
@ 34,18 SAY "                                                    "     SIZE 160,7

@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	Private _cMsg01    := ''
	Private _lFim      := .F.
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| Proc1(@_lFim) }
	Private _cTitulo01 := 'Selecionando Registros !!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
Endif

Return


Static Function Proc1(_lFim)

For X := 1 to 999
	
	dbSelectArea("SBE")
	RecLock("SBE",.T.)
	SBE->BE_FILIAL   := xFilial("SBE")
	SBE->BE_LOCAL 	 := "99"
	SBE->BE_LOCALIZ  := "ECX"+STRZERO(X,3)
	SBE->BE_DESCRIC  := "CAIXA "+STRZERO(X,3)
	SBE->(MsUnlock())
	
Next F

MsgInfo("ATUALIZADO COM SUCESSO","INFO","INFORMACAO")

Return
