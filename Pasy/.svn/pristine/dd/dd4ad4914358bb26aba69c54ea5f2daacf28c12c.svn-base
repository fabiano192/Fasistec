#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0097   ³ Autor ³ Alexandro da Silva    ³ Data ³ 24.07.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Elimina Residuo Exportacao                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat Caterpillar                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0097()

_aAliOri := GetArea()
_lAchou  := .F.                 
_nOpc    := 0

@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Elimina Pedidos Exportacao")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina criado para Eliminar Residuo dos pedidos   "    SIZE 160,7
@ 18,18 SAY "de Venda Exportacao devido falha na rotina SIGAEEC"    SIZE 160,7
@ 26,18 SAY "Uso Automatico.                           "           SIZE 160,7
@ 34,18 SAY "Programa PA0097.PRW "                                 SIZE 160,7
                                
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


dbSelectArea("SC6")
dbOrderNickName("INDSC61")
dbSeek(xFilial("SC6")+"000171")

ProcRegua(LastRec())

While !Eof() .And. SC6->C6_CLI == "000171"
                                          
	IncProc()
	
 	If SC6->C6_QTDVEN == SC6->C6_QTDENT
        dbSelectArea("SC6")
        dbSkip()
        Loop
 	Endif

	If SC6->C6_QTDENT > 0
        dbSelectArea("SC6")
        dbSkip()
        Loop
 	Endif

	If Empty(SC6->C6_XDTELIM)
        dbSelectArea("SC6")
        dbSkip()
        Loop
 	Endif

	_cPedExp := ""
	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek(xFilial("SC5")+SC6->C6_NUM)
		_cPedExp := SC5->C5_PEDEXP
	Endif
		
	dbSelectarea("EE8")
	dbOrderNickName("INDEE81")
	If dbSeek(xFilial("EE8")+_cPedExp+SC6->C6_ITEM)
		RecLock("EE8",.F.)
		EE8->EE8_ORIGEM := "PA0097"
		dbDelete()
		MsUnlock()			
	Endif
           
	dbSelectarea("EE8")
	dbSetOrder(1)
	If !dbSeek(xFilial("EE8")+SC6->C6_NUM)
		dbSelectArea("EE7")
		dbSetOrder(1)
		If dbSeek(xFilial("EE7")+_cPedExp)
			dbSelectArea("EE7")
			RecLock("EE7",.F.)
			dbDelete()
			MsUnlock()
		Endif
	Endif

	dbSelectArea("SC6")
	RecLock("SC6",.F.)
	SC6->C6_LOCALIZ := "PA0097"
	SC6->C6_XDTELIM := dDataBase
	dbDelete()
	MsUnLock()
		              
	_aAliSC6 := SC6->(GETAREA())	
	_cNum    := SC6->C6_NUM
		
	dbSelectArea("SC6")
	dbSetOrder(1)
	If !dbSeek(xFilial("SC6")+ _cNum)
		dbSelectArea("SC5")	
		RecLock("SC5",.F.)
		SC5->C5_MENNOTA := "PA0097"
		dbDelete()
		MsUnlock()
	Endif
	        
	RestArea(_aAliSC6) 
	
	dbSelectArea("SC6")
	dbSkip()
EndDo


Return