#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0124   ³ Autor ³ Fabiano da Silva      ³ Data ³ 23.03.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gráfico de Produtividade                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaEst                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ-±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0124()

_aAliOri := GetArea()
_lAchou  := .F.
_nOpc    := 0

@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Graficos de Produtividade ")
@ 02,10 TO 080,220
@ 10,18 SAY "Graficos de Produtividade                        "    SIZE 160,7
@ 18,18 SAY "Conforme parametros informados                   "    SIZE 160,7
@ 26,18 SAY "                                                 "    SIZE 160,7
@ 34,18 SAY "Programa PA0124.PRW                              "    SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0124")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	PA124A()
Endif

Return


Static Function PA124A()

_cMod   := cModulo
cModulo := "EEC"

_lRet := E_ARQCRW()

Pergunte("PA0124",.F.)

///////////////////////////////////////
///// MV_PAR01 : Data De ?         ////
///// MV_PAR02 : Data Ate ?        ////
///// MV_PAR03 : Indice ?        ////
///// MV_PAR04 : Quais Prensistas   ////
///////////////////////////////////////

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA124B(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_bAcao01   := {|_lFim| PA124C(@_lFim) }
_cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cArqNew1 := "\RELATO\PA0124.DBF"
	
dbSelectArea("TRB")
COPY ALL TO &_cArqNew1
dbCloseArea()

_cArqNew := "\CRYSTAL\PA0124.DBF"
	
dbSelectArea("TMP")
COPY ALL TO &_cArqNew
dbCloseArea()

Private cSeqRel := ""

AVGCRW32("PA0124.RPT","Grafico de Produtividade")

cModulo := _cMod

Return


Static Function PA124B(_lFim)

_nHExFi1 := 0

aStru := {}
AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })    // PRODUTO PASY
AADD(aStru,{"PRENSA"   , "C" , 06, 0 })    // PRENSA
AADD(aStru,{"OPERADOR" , "C" , 06, 0 })    // OPERADOR DA PRENSA
AADD(aStru,{"DTEMIS"   , "D" ,  8, 0 })    // DATA DE EMISSAO PEDIDO
AADD(aStru,{"QTDCAV"   , "C" , 03, 0 })    // QUANTIDADE DE CAVIDADE
AADD(aStru,{"CICLO"    , "N" ,  6, 2 })    // Ciclo
//AADD(aStru,{"CICLO"    , "N" ,  5, 2 })    // Ciclo
AADD(aStru,{"QTDREA"   , "N" , 14, 2 })    // QUANTIDADE DE PRODUCAO REALIZADO
AADD(aStru,{"QTDPRE"   , "N" , 14, 2 })    // QUANTIDADE DE PRODUCAO PREVISTA
AADD(aStru,{"PORCEN"   , "N" , 09, 2 })    // Porcentagem
AADD(aStru,{"QTE"      , "N" , 14, 2 })    // Valor
AADD(aStru,{"OCORRE"   , "N" , 14, 2 })    // Ocorrencia
AADD(aStru,{"EXTRA"    , "C" , 01, 0 })    // Extra
AADD(aStru,{"NOMOPERA" , "C" , 20, 0 })    // Nome do OPERADOR DA PRENSA

cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "DTOS(DTEMIS)+PRENSA + OPERADOR + PRODUTO + EXTRA + QTDCAV"

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
	
	If !SD3->D3_LOCAL $ "20/25"
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif
	
	If Substr(SD3->D3_CF,1,2) != "PR"
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SZ6")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ6")+SD3->D3_OPPRENS)
		
		If SZ6->Z6_ATIVO != "1"
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		If (MV_PAR04 = 1 .And. SZ6->Z6_LOCAL = "2") .Or.;
			(MV_PAR04 = 2 .And. SZ6->Z6_LOCAL = "1")
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		If SZ6->Z6_TURNO < MV_PAR05 .Or. SZ6->Z6_TURNO > MV_PAR06
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
	Endif
	_nHrsPad := _nZaHI := _nZaHF := 0
	_cExtra  := "N"
	
	If !Empty(SD3->D3_TURNO)
		dbSelectArea("SZA")
		dbSetOrder(1)
		dbSeek(xFilial("SZA")+SD3->D3_TURNO)
		
		If SZA->ZA_ATIVO != "1"
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		If (MV_PAR04 = 1 .And. SZA->ZA_LOCAL = "2") .Or.;
			(MV_PAR04 = 2 .And. SZA->ZA_LOCAL = "1")
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		_nReI01 := Val(Substr(StrZero(SZA->ZA_HRINIRE,5,2),1,2))
		_nReI02 := Val(Substr(StrZero(SZA->ZA_HRINIRE,5,2),4,2))
		_nReF01 := Val(Substr(StrZero(SZA->ZA_HRFIMRE,5,2),1,2))
		_nReF02 := Val(Substr(StrZero(SZA->ZA_HRFIMRE,5,2),4,2))
		
		_nRefei := (((_nReF01 - _nReI01) * 60) - _nReI02) + _nReF02
		
		_nHIP01 := Val(Substr(StrZero(SZA->ZA_HRINI,5,2),1,2))
		_nHIP02 := Val(Substr(StrZero(SZA->ZA_HRINI,5,2),4,2))
		_nHFP01 := Val(Substr(StrZero(SZA->ZA_HRFIM,5,2),1,2))
		_nHFP02 := Val(Substr(StrZero(SZA->ZA_HRFIM,5,2),4,2))
		
		If SZA->ZA_HRINI > SZA->ZA_HRFIM
			_nHFP01 += 24
		Endif
		
		_nHCaf01 := Val(Substr(StrZero(SZA->ZA_CAFECON,5,2),1,2))
		_nHCaf02 := Val(Substr(StrZero(SZA->ZA_CAFECON,5,2),4,2))
		
		_nhrCafe := (_nHCaf01 * 60) + _nHCaf02
		
		_nHrsPad := (((((_nHFP01 - _nHIP01) * 60) - _nHIP02) + _nHFP02) - _nRefei) - _nhrCafe
		_nZaHI := SZA->ZA_HRINIRE
		_nZaHF := SZA->ZA_HRFIMRE
		
	Else
		
		_nHExIn1 := Val(Substr(StrZero(SD3->D3_HREXINI,5,2),1,2))
		_nHExIn2 := Val(Substr(StrZero(SD3->D3_HREXINI,5,2),4,2))
		_nHExFi1 := Val(Substr(StrZero(SD3->D3_HREXFIM,5,2),1,2))
		_nHExFi2 := Val(Substr(StrZero(SD3->D3_HREXFIM,5,2),4,2))
		
		If SD3->D3_HREXINI > SD3->D3_HREXFIM
			_nHExFi1 += 24
		Endif
		
		// Desconto Hora Extra
		_nHDeE01 := Val(Substr(StrZero(SD3->D3_HREXDES,5,2),1,2))
		_nHDeE02 := Val(Substr(StrZero(SD3->D3_HREXDES,5,2),4,2))
		
		_nhrExDe := (_nHDeE01 * 60) + _nHDeE02
		
		_nHrsPad  := ((((_nHExFi1 - _nHExIn1) * 60) - _nHExIn2) + _nHExFi2) - _nhrExDe
		_cExtra   := "S"
		
	Endif
	
	_nHIni1 := Val(Substr(StrZero(SD3->D3_HORINIC,5,2),1,2))
	_nHFim1 := Val(Substr(StrZero(SD3->D3_HORFINA,5,2),1,2))
	_nHIni2 := Val(Substr(StrZero(SD3->D3_HORINIC,5,2),4,2))
	_nHFim2 := Val(Substr(StrZero(SD3->D3_HORFINA,5,2),4,2))
	
	If SD3->D3_HORINIC > SD3->D3_HORFINA
		_nHFim1 += 24
	Endif
	
	_nOcorr := (((_nHFim1 - _nHIni1) * 60) - _nHIni2) + _nHFim2
	
	If SD3->D3_TURNO $ "02    /05    "
		//		_nZaHI += 24
	Endif
	
	//	If (SD3->D3_HORINIC < 11.30 .and. SD3->D3_HORFINA > 12.30) .or. (SD3->D3_HORINIC < 02.00 .and. SD3->D3_HORFINA > 03.00)
	If SD3->D3_HORINIC < _nZaHI .and. SD3->D3_HORFINA > _nZaHF
		_nOcorr -= 60
	Endif
	
	If SD3->D3_HORINIC < 9.00 .and. SD3->D3_HORFINA > 9.10
		_nOcorr -= 10
	Endif
	
	If SD3->D3_HORINIC < 15.00 .and. SD3->D3_HORFINA > 15.10
		_nOcorr -= 10
	Endif
	
	dbSelectArea("TRB")
	If dbSeek(DTOS(SD3->D3_EMISSAO)+SD3->D3_RECURSO+SD3->D3_OPPRENSA+SD3->D3_COD+_cExtra+SD3->D3_NUMCAV)
		RecLock("TRB",.F.)
		TRB->OCORRE   += _nOcorr
		TRB->QTE      += SD3->D3_QUANT
		TRB->QTDREA   += (SD3->D3_QUANT / VAL(SD3->D3_NUMCAV)) // / _nNumPlat
		TRB->QTDPRE   := (_nHrsPad - TRB->OCORRE) / SD3->D3_CICLO
		TRB->PORCEN   := (TRB->QTDREA / TRB->QTDPRE) * 100
		MsUnLock()
	Else
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->DTEMIS   := SD3->D3_EMISSAO
		TRB->PRODUTO  := SD3->D3_COD
		TRB->QTDCAV   := IIf(Len(SD3->D3_NUMCAV) = 1, "00"+SD3->D3_NUMCAV , SD3->D3_NUMCAV)
		TRB->CICLO    := SD3->D3_CICLO
		TRB->PRENSA   := SD3->D3_RECURSO
		TRB->OPERADOR := SD3->D3_OPPRENSA
		TRB->QTDREA   := (SD3->D3_QUANT / VAL(SD3->D3_NUMCAV)) // / _nNumPlat
		TRB->QTDPRE   := (_nHrsPad - _nOcorr) / SD3->D3_CICLO
		TRB->PORCEN   := (TRB->QTDREA / TRB->QTDPRE) * 100
		TRB->QTE      := SD3->D3_QUANT
		TRB->OCORRE   := _nOcorr
		TRB->EXTRA    := _cExtra
		TRB->NOMOPERA := SZ6->Z6_NOME
		MsUnLock()
	Endif
	
	dbSelectArea("SD3")
	dbSkip()
EndDo

RETURN


Static Function PA124C()

aStru := {}
AADD(aStru,{"DATADE"   , "D" , 08, 0 })    // Data de
AADD(aStru,{"DATAATE"  , "D" , 08, 0 })    // Data ATE
AADD(aStru,{"INDICE"   , "N" , 06, 2 })    // Indice
AADD(aStru,{"OPERADOR" , "C" , 06, 0 })    // OPERADOR DA PRENSA
AADD(aStru,{"NOMOPERA" , "C" , 20, 0 })    // Nome do OPERADOR DA PRENSA
AADD(aStru,{"QTDREA"   , "N" , 14, 2 })    // QUANTIDADE DE PRODUCAO REALIZADO
AADD(aStru,{"QTDPRE"   , "N" , 14, 2 })    // QUANTIDADE DE PRODUCAO PREVISTA
AADD(aStru,{"VALOR"    , "N" , 14, 2 })    // Valor

cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "OPERADOR"

dbUseArea(.T.,,cArqLOG,"TMP",.F.,.F.)

dbSelectArea("TMP")
IndRegua("TMP",cArqLog,cIndLog,,,"Criando Trabalho...")

dbSelectArea("TRB")
dbGoTop()

ProcRegua(LastRec())

While !EOF()
	
	IncProc("Processando...")
	
	If _lFim
		Return
	Endif
	
	If TRB->OPERADOR == "00869 "
		_lPare := .T.
	Endif
	
	If (TRB->QTDPRE = 0)
		//	If (TRB->QTDREA = 0 .And. TRB->QTDPRE = 0)
		dbSelectArea("TRB")
		dbskip()
		Loop
	Endif
	
	If TRB->OPERADOR = "999999"
		dbSelectArea("TRB")
		dbskip()
		Loop
	Endif
	
	dbSelectArea("TMP")
	If !dbSeek(TRB->OPERADOR)
		RecLock("TMP",.T.)
		TMP->DATADE     := MV_PAR01
		TMP->DATAATE    := MV_PAR02
		TMP->INDICE     := MV_PAR03
		TMP->OPERADOR   := TRB->OPERADOR
		TMP->NOMOPERA   := TRB->NOMOPERA
		TMP->QTDREA     := TRB->QTDREA
		TMP->QTDPRE     := TRB->QTDPRE
		TMP->VALOR      := (TRB->QTDREA / TRB->QTDPRE) * 100
		MsUnlock()
	Else
		RecLock("TMP",.F.)
		TMP->QTDREA     += TRB->QTDREA
		TMP->QTDPRE     += TRB->QTDPRE
		TMP->VALOR      := (TMP->QTDREA / TMP->QTDPRE) * 100
		MsUnlock()
	Endif
	
	dbSelectArea("TRB")
	dbSkip()
EndDo

Return
