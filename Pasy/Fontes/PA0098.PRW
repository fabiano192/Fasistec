#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0098   ³ Autor ³ Alexandro da Silva    ³ Data ³ 11.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualizaçao tabela SZ4 ref. Programacao de Entrega         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat Caterpillar                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0098()

_nOpc    := 0

@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Salvando Arq.TXT Exportacao")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina criado para Salvar os Arquivos Enviados pela"   SIZE 160,7
@ 18,18 SAY "Caterpillar Exportacao no diretorio BKP            "   SIZE 160,7
@ 26,18 SAY "                                                   "   SIZE 160,7
@ 34,18 SAY "Programa PA0098.PRW "                                  SIZE 160,7

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
Private _bAcao01   := {|_lFim| PA98A(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return


Static Function PA98A(_lFim)

_cDir   := "F:\AP7\AP_DATA\Caterpillar\Exportacao\Entrada\*.LAN"

_aArqTxt := ARRAY(ADIR(_cDir))
ADIR("F:\AP7\AP_DATA\Caterpillar\Exportacao\Entrada\*.LAN",_aArqTxt)

ProcRegua(Len(_aArqTxt))

For I:= 1 to Len(_aArqTxt)
	
	IncProc()
	_lAchou    := .t.
	_lProx     := .F.
	
	_cArqBkp := ""
	_lInt    := .F.
	_cArqAtu := Alltrim(_aArqTxt[I])
	For x:= 1 To Len(_cArqAtu)
		If  Substr(_cArqAtu,X,1) == "P" .Or. _lInt
			If Substr(_cArqAtu,X+1,1) == "A" .Or. _lInt
				_lInt    := .T.
				_cArqBkp += Substr(_cArqAtu,X,1)
			Endif
		Endif
	Next X
	
	_cArq2     := "F:\AP7\AP_DATA\Caterpillar\Exportacao\Entrada\BKP\"+_cArqBkp
	_cArq3     := "F:\AP7\AP_DATA\Caterpillar\Exportacao\Entrada\"+Alltrim(_aArqTxt[i])
	
	_cArqNovo  := fCreate(Alltrim(_cArq2),0)
	_cArq      := FOpen(_cArq3,0)
	_cQtArq    := 1
	
	While .T.
		
		cLinha := fReadStr(_cArq,130)
		
		If Len(cLinha) == 0
			Exit
		Endif
		
		FWrite(_cArqNovo,cLinha)
	EndDo
	
	fClose(_cArq2)
	fClose(_cArqNovo)
	
	If File(_cArq3)
		FClose(_cArq)
		FErase(_cArq3)
	Endif
Next I

Return
