#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PA0093    º Autor ³ Alexandro da Silva º Data ³  13/05/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualiza o Contas a Receber com o Numero da Invoice        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Sigafin                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PA0093()

Private _aMes     := {}
Private _cAno     := ""
Private _dDtI     := _dDtF    := Ctod("")
Private _lImprime := .T.
_cNomBco := ""
_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Atualiza o Numero da Invoice")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina para Atualizar o numero da Invoide nos titu- "     SIZE 160,7
@ 18,18 SAY "los do Contas a Receber conforme o embarque no modu-"     SIZE 160,7
@ 26,18 SAY "lo de Exportacao. Programa PA0093.PRW               "     SIZE 160,7
@ 34,18 SAY "                                                    "     SIZE 160,7

//@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0093")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	PA93A()
Endif

Return(.T.)


Static Function PA93A()


Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.

_bAcao01   := {|_lFim| PA93B(@_lFim) }
_cTitulo01 := 'Atualizando Contas a Receber...!!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

MsgInfo("Atualizado com Sucesso!!!")         

Return



Static Function PA93B(_lFim)

dbSelectarea("SE1")
dbOrderNickName("INDSE12")
If dbSeek(xFilial("SE1")+Space(20)+"000171")
	
	ProcRegua(LastRec())
	
	While !Eof() .And. !_lFim .And. Empty(SE1->E1_NUMINVO) .And. SE1->E1_CLIENTE == "000171"
		
		IncProc("Nota Fiscal: "+SE1->E1_NUM)
	
		If SE1->E1_TIPO != "NF "
			dbSelectArea("SE1")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("EEM")
		dbOrderNickName("INDEEM1")
		If dbSeek(xFilial("EEM")+SE1->E1_NUM+Space(11) + SE1->E1_PREFIXO + Space(2))
			dbSelectArea("SE1")
			RecLock("SE1",.F.)
			SE1->E1_NUMINVO := EEM->EEM_PREEMB
			MsUnlock()

			dbSelectArea("SE1")
			dbSeek(xFilial("SE1")+Space(20)+"000171")			
		Else
			dbSelectArea("SE1")
			dbSkip()		
		Endif		
	EndDo
Endif

Return