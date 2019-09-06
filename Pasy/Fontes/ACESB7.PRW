#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACESB7    º Autor ³ Fabiando da Silva º Data ³  16/01/08    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualizaçao Lançamentos do Inventário                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ACESB7()

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Rotina Para gerar Inventário")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina Para Atualizacao da Tabela SB7               "     SIZE 160,7
@ 18,18 SAY "                                                    "     SIZE 160,7
@ 26,18 SAY "Programa ACESB7                                     "     SIZE 160,7
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

_cArqTrb:= "INVENT.DBF"
_cArqInd:= "INVENT"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

_cInd := "PRODUTO"
IndRegua("TRB",_cArqInd,_cInd,,,"Selecionando Arquivo Trabalho")

SB1->(dbGotop())

ProcRegua(SB1->(U_CONTREG()))

While SB1->(!Eof()) .And. !_lFim
	
	IncProc()
	
	If _lFim
		REturn
	Endif
	
	If SB1->B1_GRUPO != 'PAV' //.Or. (!SB1->B1_LOCPAD $ '99/25')
		SB1->(dbSkip())
		Loop
	Endif
	
	_nQuant := 0
	
		dbSelectArea("SB7")
		RecLock("SB7",.T.)
		SB7->B7_FILIAL   := xFilial("SB7")
		SB7->B7_COD		 := SB1->B1_COD
		SB7->B7_QUANT    := _nQuant
		SB7->B7_TIPO     := SB1->B1_TIPO
		SB7->B7_LOCAL  	 := "99"
		SB7->B7_DOC  	 := "000001"
		SB7->B7_DATA  	 := ddataBase
		SB7->B7_DTVALID	 := ddataBase
//		SB7->B7_LOCALIZ	 := TRB->ENDER
		SB7->(MsUnlock())
		
	SB1->(dbSkip())
EndDo

dbSelectArea("TRB")
dbCloseArea()

MsgInfo("ATUALIZADO COM SUCESSO","INFO","INFORMACAO")

Return 	 	
