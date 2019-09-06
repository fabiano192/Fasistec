#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PA0090   บ Autor ณ Alexandro da Silva บ Data ณ  08/05/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Atualiza Titulos para o Fluxo de Caixa                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SigaFin                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PA0090()
/*
_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Atualiza titulos para o Fluxo de Caixa")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina criado para Atualizar os titulos do "    SIZE 160,7
@ 18,18 SAY "Contas a Receber para o Fluxo de Caixa     "    SIZE 160,7
@ 26,18 SAY "Conforme Faturamento                       "    SIZE 160,7
@ 34,18 SAY "Programa PA0090.PRW.                       "    SIZE 160,7

//@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0076")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	Proces()
Endif


Return


Static Function Proces()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| Proc1(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return


Static Function Proc1(_lFim)
                                                  
*/

_cQ := " UPDATE SE1010 SET E1_FLUXO = 'S' WHERE E1_STATUS = 'A' AND E1_SITUACA <> '2' AND E1_CLIENTE NOT IN ('ZPROVI','ZRESUL') "
TCSQLEXEC(_cQ)

FINC021()

/*
SE1->(dbOrderNickName("INDSE11"))
SE1->(dbSeek(xFilial("EE1")+"A0",.t.))

ProcRegua(LastRec())

While SE1->(!Eof()) .And. SE1->E1_STATUS = "A"
	
	IncProc()
                   
    If SE1->E1_CLIENTE $ "ZPROVI/ZRESUL" .Or. SE1->E1_SITUACA == "2"
    	SE1->(dbSkip())
    	Loop
    Endif
        
	SE1->(RecLock("SE1",.F.))
	SE1->E1_FLUXO := "S"    
	SE1->(MsUnlock())
	
	SE1->(dbSkip())
EndDo
*/
Return