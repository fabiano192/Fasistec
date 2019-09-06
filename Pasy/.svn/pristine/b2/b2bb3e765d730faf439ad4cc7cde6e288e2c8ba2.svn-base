#include "rwmake.ch" 
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ PA0010   ³ Autor ³ Alexandro da Silva    ³ Data ³ 01.02.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Desmarcar Cheque para Reimpressao                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafin                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PA0010()

_nOpc := 0

@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Desmarcar Cheque para Reimpressao")
@ 02,10 TO 080,220             
@ 10,18 SAY "Rotina criado para desmarcar os cheques"     SIZE 160,7
@ 18,18 SAY "Ja impressos para reimprimi-los, conforme"   SIZE 160,7
@ 26,18 SAY "Parametro solicitado"                        SIZE 160,7
@ 34,18 SAY "Programa PA0010.PRW "                        SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0010")
//@ 85,158 BMPBUTTON TYPE 1 ACTION Limp()
//@ 85,188 BMPBUTTON TYPE 2 ACTION Close(oDlg)

@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered
                             
If _nOpc == 1
	Limp()
Endif

Return 


Static Function limp()

Private _lAchou := .f.
Pergunte("PA0010",.F.)

Processa( {|| Desmarca() } )

If _lAchou
   MsgBox ("Cheque(s) pronto para Impressao","Informaç¦o","INFO")
Else
   MsgBox ("Cheque nao Encontrado !!!!!","Erro!!!","STOP")
Endif   


Return


Static Function Desmarca()

_lAchou := .F.
dbselectArea("SEF")
dbSetOrder(1)
dbseek(xFilial("SEF")+MV_PAR01+MV_PAR02+MV_PAR03+MV_PAR04,.T.)

ProcRegua(LastRec())

While !Eof() .And. SEF->EF_NUM <= MV_PAR05

   _lAchou := .T.
   IncProc()
   
   If SEF->EF_IMPRESS $ "A/C/ "
      dbSkip()
      Loop
   Endif

   dbSelectArea("SEF")
   RecLock("SEF",.F.)
      SEF->EF_IMPRESS := " "
   MsUnlock()

   dbSelectArea("SEF")
   dbSkip()
EndDo

Return