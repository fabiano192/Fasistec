#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PA0109     º Autor ³ Alexandro da Silva º Data ³  28/10/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Estorno da Apuracao de Resultado                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Sigafin                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PA0109()

Private _aMes     := {}
Private _cAno     := ""
Private _dDtI     := _dDtF    := Ctod("")
Private _lImprime := .T.
_cNomBco := ""
_nOpc := 0

@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Eliminanod da Apuracao de Resultado")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina para eliminar a apuracao de resultado anual  "     SIZE 160,7
@ 18,18 SAY "Da Movimentação financeira (Pela Natureza) conforme "     SIZE 160,7
@ 26,18 SAY "Parametros Informados Pelo Usuario.                 "     SIZE 160,7
@ 34,18 SAY "                Programa PA0109.PRW                 "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0108")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	PA109A()
Endif

Return(.T.)


Static Function PA109A()


/* PERGUNTA (PA0106)
MV_PAR01 ULTIMO DIA DO ANO
*/

Pergunte("PA0108",.F.)

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
_bAcao01   := {|_lFim| GeraTrb(@_lFim) }
_cTitulo01 := 'Processando Naturezas...!!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )


Return


Static Function GeraTrb(_lFim)

_dUltFech := GETMV("MV_PA0108")  // Data da Ultima Apuração do resultado

_dDtInic := _dUltFech + 1
_dDtRef  := LASTDAY(MV_PAR01)

dbSelectArea("SE1")
dbSetOrder(11)
If dbSeek(xFilial("SE1")+DTOS(_dDtRef))
	
	ProcRegua(LastRec())
	
	_cChavSE1 := DTOS(SE1->E1_EMISSAO)
	
	While !Eof() .And.	_cChavSE1 == DTOS(SE1->E1_EMISSAO)
		
		IncProc("Deletando Apuracao Natureza: "+SE1->E1_NATUREZ)
		
		If SE1->E1_TIPO $ "VPR/VNR"
			dbSelectArea("SE1")
			RecLock("SE1",.F.)
			dbDelete()
			MsUnlock()
		Endif
		
		dbSelectArea("SE1")
		dbSkip()
	EndDo
Endif

dbSelectArea("SE1")
dbSetOrder(11)
If dbSeek(xFilial("SE1")+DTOS(_dDtRef+1)+"2303")
	If SE1->E1_TIPO $ "VPR/VNR"
		dbSelectArea("SE1")
		RecLock("SE1",.F.)
		dbDelete()
		MsUnlock()
	Endif
Endif

dbSelectArea("SE2")
dbSetOrder(7)
If dbSeek(xFilial("SE2")+DTOS(_dDtRef))
	
	ProcRegua(LastRec())
	
	_cChavSE2 := DTOS(SE2->E2_EMIS1)
	
	While !Eof() .And. _cChavSE2 == DTOS(SE2->E2_EMIS1)
		
		IncProc("Deletando Apuracao Natureza: "+SE2->E2_NATUREZ)
		
		If SE2->E2_TIPO $ "VPP/VNP"
			dbSelectArea("SE2")
			RecLock("SE2",.F.)
			dbDelete()
			MsUnlock()
		Endif
		
		dbSelectArea("SE2")
		dbSkip()
	EndDo
Endif

dbSelectArea("SE2")
dbSetOrder(7)
If dbSeek(xFilial("SE2")+DTOS(_dDtRef+1)+"2303")
	If SE2->E2_TIPO $ "VPR/VNR"
		dbSelectArea("SE2")
		RecLock("SE2",.F.)
		dbDelete()
		MsUnlock()
	Endif
Endif
Return	