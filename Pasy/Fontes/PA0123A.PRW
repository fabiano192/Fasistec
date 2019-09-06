#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
'±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0123A  ³ Autor ³ Fabiano da Silva      ³ Data ³ 23.03.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gráfico de Ocorrencias                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaEst                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ-±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0123A()

_aAliOri := GetArea()
_lAchou  := .F.
_nOpc    := 0

@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Graficos de Ocorrencia ")
@ 02,10 TO 080,220
@ 10,18 SAY "Graficos de Ocorrencia                           "    SIZE 160,7
@ 18,18 SAY "Conforme parametros informados                   "    SIZE 160,7
@ 26,18 SAY "                                                 "    SIZE 160,7
@ 34,18 SAY "Programa PA0123A.PRW                             "    SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0123")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	PA123A()
Endif

Return


Static Function PA123A()

_cMod   := cModulo
cModulo := "EEC"
_nTotHr := 0
_lRet   := E_ARQCRW()

Pergunte("PA0123",.F.)

///////////////////////////////////////
///// MV_PAR01 : Data De ?         ////
///// MV_PAR02 : Data Ate ?        ////
///////////////////////////////////////

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA123B(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cArqNew := "\CRYSTAL\PA0123.DBF"
dbSelectArea("TRB")
COPY ALL TO &_cArqNew

dbSelectArea("TRB")
dbCloseArea()

Private cSeqRel := ""

AVGCRW32("PA0123.RPT","Grafico de Ocorrencias")

cModulo := _cMod

Return


Static Function PA123B(_lFim)

aStru := {}
AADD(aStru,{"OCORRE"   , "C" , 06, 0 })    // Ocorrencia
AADD(aStru,{"NOMOCO"   , "C" , 30, 0 })    // Nome da Ocorrencia
AADD(aStru,{"HORAS"    , "N" , 12, 2 })    // Horas Perdidas
AADD(aStru,{"THORAS"   , "N" , 12, 2 })    // Total Horas Perdidas
AADD(aStru,{"PHORAS"   , "N" , 12, 2 })    // Porcentagem Horas Perdidas
AADD(aStru,{"DATADE"   , "D" , 08, 0 })    // Data emissão de
AADD(aStru,{"DATATE"   , "D" , 08, 0 })    // Data emissão até

cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "OCORRE"

dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

dbSelectarea("SD3")
dbSetOrder(6)
dbSeek(xFilial("SD3")+DTOS(MV_PAR01),.T.)

ProcRegua(LastRec())

While !Eof() .And. !_lFim .And. SD3->D3_EMISSAO <= MV_PAR02
	
	IncProc("Processando Movimento Interno!!")
	
	If _lFim
		Return
	Endif               
                       	
	If SD3->D3_ESTORNO == "S"
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif                          

	If SD3->D3_LOCAL != "20"
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif

	If Substr(SD3->D3_CF,1,2) != "PR"
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif
                        
	If Empty(SD3->D3_OCORR) .Or. SD3->D3_OCORR $ "019   /020   "
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif

	_nHIni1 := Val(Substr(StrZero(SD3->D3_HORINIC,5,2),1,2))
	_nHFim1 := Val(Substr(StrZero(SD3->D3_HORFINA,5,2),1,2))
	_nHIni2 := Val(Substr(StrZero(SD3->D3_HORINIC,5,2),4,2))
	_nHFim2 := Val(Substr(StrZero(SD3->D3_HORFINA,5,2),4,2))
	
	If SD3->D3_HORINIC > SD3->D3_HORFINA
		_nHFim1 += 24
	Endif
	
	_nOcorr := (((_nHFim1 - _nHIni1) * 60) - _nHIni2) + _nHFim2

    dbSelectArea("SZA")
    dbSetOrder(1)
    If dbSeek(xFilial("SZA")+SD3->D3_TURNO)
	
		_nZaHI := SZA->ZA_HRINIRE
		_nZaHF := SZA->ZA_HRFIMRE
	
		If (SD3->D3_HORINIC < _nZaHI .and. SD3->D3_HORFINA > _nZaHF) .Or.;
			(SD3->D3_HORINIC = _nZaHI .and. SD3->D3_HORFINA > _nZaHF) .Or.;
			(SD3->D3_HORINIC < _nZaHI .and. SD3->D3_HORFINA = _nZaHF)
			_nOcorr -= 60
		Endif

		If SZA->ZA_ATIVO != "1"
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		If (MV_PAR03 = 1 .And. SZA->ZA_LOCAL = "2") .Or.;
			(MV_PAR03 = 2 .And. SZA->ZA_LOCAL = "1")
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		If SZA->ZA_CODIGO < MV_PAR04 .Or. SZA->ZA_CODIGO > MV_PAR05
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
	Endif
	
	dbSelectArea("SZ6")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ6")+SD3->D3_OPPRENS)
		
		If SZ6->Z6_ATIVO != "1"
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		If (MV_PAR03 = 1 .And. SZ6->Z6_LOCAL = "2") .Or.;
			(MV_PAR03 = 2 .And. SZ6->Z6_LOCAL = "1")
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		If SZ6->Z6_TURNO < MV_PAR04 .Or. SZ6->Z6_TURNO > MV_PAR05
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
	Endif

	If SD3->D3_HORINIC < 9.00 .and. SD3->D3_HORFINA > 9.10
		_nOcorr -= 10
	Endif

	If SD3->D3_HORINIC < 15.00 .and. SD3->D3_HORFINA > 15.10
		_nOcorr -= 10
	Endif	
	
	If SD3->D3_OCORR = "005"
		_lPare := .T.
	Endif
		
    _nOcor0 := _nOcorr / 60           
	_nOcor1 := Int(_nOcor0)
	_nOcor2 := (_nOcorr - (_nOcor1 * 60)) / 100
	_nOcor3 := _nOcor1 + _nOcor2       		                           	               
                           	                                          	                      
	_cDesOco := Tabela("Z4",SD3->D3_OCORR)
	dbSelectArea("TRB")
	If !dbSeek(SD3->D3_OCORR)
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->OCORRE   := SD3->D3_OCORR
		TRB->NOMOCO   := Substr(_cDesOco,1,30)
		TRB->HORAS    := _nOcor3
		TRB->DATADE   := MV_PAR01
		TRB->DATATE   := MV_PAR02
		MsUnLock()
		_nTotHr       += _nOcor3
	Else
		_nHora1 := Int(TRB->HORAS) * 60		
		_nHora2 := TRB->HORAS - Int(TRB->HORAS)
		_nHor21 := Val(Substr(StrZero(_nHora2,5,2),4,2)) 
		_nHora3 := _nHora1 + _nHor21
		
		_nOcor4 := _nOcorr + _nHora3
		_nOcor5 := Int(_nOcor4 / 60)
		_nOcor6 := (_nOcor4 - (_nOcor5 * 60)) / 100
		
		_nOcor7 := _nOcor5 + _nOcor6

		RecLock("TRB",.F.)      		
		TRB->HORAS    := _nOcor7
		MsUnLock()              
 		_nTotHr       += _nOcor3
	Endif
	
	dbSelectArea("SD3")
	dbSkip()
EndDo

dbSelectArea("TRB")
dbGotop()
    
While !EOF()
	
	RecLock("TRB",.F.)
	TRB->THORAS    := _nTotHr
	TRB->PHORAS    := (TRB->HORAS / TRB->THORAS) * 100
	MsUnLock()
	
	dbSelectArea("TRB")
	dbSkip()
EndDo

Return (NIL)