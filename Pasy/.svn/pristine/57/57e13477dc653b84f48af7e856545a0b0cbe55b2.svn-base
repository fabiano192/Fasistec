#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PA0108     º Autor ³ Alexandro  Silva   º Data ³  26/10/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Apuracao de Resultado Por Natureza Financeira              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Sigafin                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PA0108()

Private _aMes     := {}
Private _cAno     := ""
Private _dDtI     := _dDtF    := _dDtRef := Ctod("")
Private _lImprime := .T.
_cNomBco := ""
_nOpc := 0

@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Rotina de Apuracao de Resultado")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina para apurar o resultado anual baseado na     "     SIZE 160,7
@ 18,18 SAY "Movimentação financeira (Pela Natureza) conforme    "     SIZE 160,7
@ 26,18 SAY "Parametros Informados Pelo Usuario.                 "     SIZE 160,7
@ 34,18 SAY "                Programa PA0108.PRW                 "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0108")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	PA108A()
Endif

Return(.T.)


Static Function PA108A()


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

PUTMV("MV_PA0108",_dDtRef)

dbSelectArea("TRB")
_cArqNovo := "\RELATO\PA0108.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo

dbCloseArea()

dbSelectArea("TRB2")
_cArqNovo := "\RELATO\SE5APU.DBF"

dbSelectArea("TRB2")
Copy all to &_cArqNovo

dbCloseArea()

Return


Static Function GeraTrb(_lFim)

aStru := {}
AADD(aStru,{"NATUREZA"  , "C" , 10, 0 })  // Natureza
AADD(aStru,{"DESCNAT"   , "C" , 30, 0 })  // Descrição da Natureza
AADD(aStru,{"VALORD"    , "N" , 14, 2 })  // Valor 01
AADD(aStru,{"VALORC"    , "N" , 14, 2 })  // Valor 01
AADD(aStru,{"TIPONAT"   , "C" , 01, 0 })  // Tipo da Natureza
AADD(aStru,{"RECPAG"    , "C" , 01, 0 })  // Receber ou Pagar
AADD(aStru,{"TIPOMOV"   , "C" , 03, 0 })  // Tipo de Movimentacao

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "NATUREZA+RECPAG+TIPOMOV"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

aStru := {}
AADD(aStru,{"NATUREZA", "C" , 10, 0 })  // Natureza
AADD(aStru,{"PREF"    , "C" , 03, 0 })  // Natureza
AADD(aStru,{"NUMERO"  , "C" , 06, 0 })  // Descrição da Natureza
AADD(aStru,{"PARCELA" , "C" , 03, 0 })  // Valor 01
AADD(aStru,{"TIPO"    , "C" , 03, 0 })  // Valor 01
AADD(aStru,{"VALOR"   , "N" , 14, 2 })  // Tipo da Natureza
AADD(aStru,{"RECPAG"  , "C" , 01, 0 })  // Valor 01
AADD(aStru,{"TIPODOC" , "C" , 02, 0 })  // Tipo da Natureza

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "PREF+NUMERO"

dbUseArea(.T.,,_cArqTrb,"TRB2",.F.,.F.)
dbSelectArea("TRB2")
IndRegua("TRB2",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

_dUltFech := GETMV("MV_PA0108")  // Data da Ultima Apuração do resultado
//_dUltFech   := CTOD("01/01/80")
_dDtInic    := _dUltFech + 1
_dDtRef     := LASTDAY(MV_PAR01)

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
	If SE2->E2_TIPO $ "VPR/VNP"
		dbSelectArea("SE2")
		RecLock("SE2",.F.)
		dbDelete()
		MsUnlock()
	Endif
Endif

dbSelectArea("SE5")
dbOrderNickName("INDSE53")
If dbSeek(xFilial("SE5")+DTOS(_dDtRef))
	
	ProcRegua(LastRec())
	
	_cChavSE5 := DTOS(SE5->E5_DTDISPO)
	
	While !Eof() .And. _cChavSE5 == DTOS(SE5->E5_DTDISPO)
		
		IncProc("Deletando Apuracao Natureza: "+SE5->E5_NATUREZ)
		
		If SE5->E5_MOEDA $ "AR"
			dbSelectArea("SE5")
			RecLock("SE5",.F.)
			dbDelete()
			MsUnlock()
		Endif
		
		dbSelectArea("SE5")
		dbSkip()
	EndDo
Endif

dbSelectArea("SE5")
dbOrderNickName("INDSE53")
If dbSeek(xFilial("SE5")+DTOS(_dDtRef+1)+"2303")
	
	_cChavSE5 := DTOS(SE5->E5_DTDISPO)+"2303"
	
	While !Eof() .And. _cChavSE5 == DTOS(SE5->E5_DTDISPO)+ALLTRIM(SE5->E5_NATUREZ)
		
		IncProc("Deletando Apuracao Natureza: "+SE5->E5_NATUREZ)
		
		If SE5->E5_MOEDA $ "AR"
			dbSelectArea("SE5")
			RecLock("SE5",.F.)
			dbDelete()
			MsUnlock()
		Endif
		
		dbSelectArea("SE5")
		dbSkip()
	EndDo
Endif

dbSelectArea("SED")
dbGotop()

ProcRegua(LastRec())

While !Eof() .And. !_lFim
	
	IncProc("Processando Natureza: "+SED->ED_CODIGO)
/*
	If Alltrim(SED->ED_CODIGO) != "1031"
		dbSkip()
		Loop
	Endif
*/

	If SED->ED_CODIGO == "3175      "
		_lPare   := .T.
	Endif	

	dbSelectArea("SE1")
	dbOrderNickName("INDSE13")
	dbSeek(xFilial("SE1")+SED->ED_CODIGO+ DTOS(_dDtInic),.T.)
	
	_cNaturez := SED->ED_CODIGO
	
	_lSai := .F.
	While !Eof() .And. !_lFim .And. !_lSai .And. _cNaturez == SE1->E1_NATUREZ .And. SE1->E1_EMISSAO <= _dDtRef
		
		If !Empty(SE1->E1_FATURA).And. SE1->E1_FATURA != "NOTFAT"
			dbSelectArea("SE1")
			dbSkip()
			Loop
		Endif
		
		If Substr(SED->ED_CODIGO,1,1) $ "1/2"
			_lSai := .T.
			Loop
		Endif
		
		dbSelectArea("TRB")
		If !dbseek(SE1->E1_NATUREZ+"RSE1")
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->NATUREZA    := SE1->E1_NATUREZ
			TRB->DESCNAT     := SED->ED_DESCRIC
			TRB->TIPONAT     := SED->ED_CLASSE
			TRB->RECPAG      := "R"
			TRB->TIPOMOV     := "SE1"
			If SE1->E1_TIPO $ "RA /NCC/AB-"
				TRB->VALORD  := SE1->E1_VALOR
			Else
				TRB->VALORC  := SE1->E1_VALOR
			Endif
			MsUnlock()
		Else
			RecLock("TRB",.F.)
			If SE1->E1_TIPO $ "RA /NCC/AB-"
				TRB->VALORD  += SE1->E1_VALOR
			Else
				TRB->VALORC  += SE1->E1_VALOR
			Endif
			MsUnlock()
		Endif
		
		dbSelectArea("SE1")
		dbSkip()
	EndDo
	
	dbSelectArea("SE2")
	dbOrderNickName("INDSE22")
	dbSeek(xFilial("SE2")+SED->ED_CODIGO+ DTOS(_dDtInic),.T.)
	
	_cNaturez := SED->ED_CODIGO
	
	_lSai := .F.
	While !Eof() .And. !_lFim .And. !_lSai .And. _cNaturez == SE2->E2_NATUREZ .And. SE2->E2_EMIS1  <= _dDtRef
		
		If !Empty(SE2->E2_FATURA) .And. SE2->E2_FATURA != "NOTFAT"
			dbSelectArea("SE2")
			dbSkip()
			Loop
		Endif
		
		If Substr(SED->ED_CODIGO,1,1) $ "1/2"
			_lSai := .T.
			Loop
		Endif
		
		dbSelectArea("TRB")
		If !dbseek(SE2->E2_NATUREZ+"PSE2")
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->NATUREZA    := SE2->E2_NATUREZ
			TRB->DESCNAT     := SED->ED_DESCRIC
			TRB->TIPONAT     := SED->ED_CLASSE
			TRB->RECPAG      := "P"
			TRB->TIPOMOV     := "SE2"
			//			If SE2->E2_TIPO $ "NDF/PA /AB-"
			If SE2->E2_TIPO $ "NDF/AB-"
				TRB->VALORC  := SE2->E2_VALOR
			Else
				TRB->VALORD  := SE2->E2_VALOR
			Endif
			MsUnlock()
		Else
			dbSelectArea("TRB")
			RecLock("TRB",.F.)
			//			If SE2->E2_TIPO $ "NDF/PA /AB-"
			If SE2->E2_TIPO $ "NDF/AB-"
				TRB->VALORC  += SE2->E2_VALOR
			Else
				TRB->VALORD  += SE2->E2_VALOR
			Endif
			MsUnlock()
		Endif
/*		
		dbSelectArea("TRB2")
		RecLock("TRB2",.T.)
		TRB2->NATUREZA    := SED->ED_CODIGO
		TRB2->PREF        := SE2->E2_PREFIXO
		TRB2->NUMERO      := SE2->E2_NUM   
		TRB2->PARCELA     := SE2->E2_PARCELA
		TRB2->TIPO        := SE2->E2_TIPO
		TRB2->VALOR       := SE2->E2_VALOR
		MsUnlock()
*/		
		dbSelectArea("SE2")
		dbSkip()
	EndDo
	
	dbSelectArea("SE5")
	dbOrderNickName("INDSE56")
	dbSeek(xFilial("SE5")+SED->ED_CODIGO+ DTOS(_dDtInic),.T.)
	
	_lSai     := .F.
	_cNaturez := SED->ED_CODIGO
	
	While !Eof() .And. !_lSai .And. !_lFim .And. _cNaturez == SE5->E5_NATUREZ .And. SE5->E5_DTDISPO <= _dDtRef
				
		If !Empty(SE5->E5_SITUACA )
			dbSelectArea("SE5")
			dbSkip()
			Loop
		Endif
		
		IF SE5->E5_TIPODOC $ "ES/TL/M2/CM/C2/CH/EC/E2/BD/TE/RA/PA/BA/VL/V2/CP/TR/CB"
			dbSelectArea("SE5")
			dbSkip()
			Loop
		Endif                                    
/*	
		If Substr(SED->ED_CODIGO,1,1) $ "9"
			_lSai := .T.
			Loop
		Endif
*/	
		_aAliSED := SED->(GETAREA())
		
		If SE5->E5_TIPODOC $ "MT/M2/JR/J2"
			If SE5->E5_RECPAG == "P"
				dbSelectArea("SED")
				dbSetOrder(1)
				dbSeek(xFilial("SED")+"4781")
			Else
				dbSelectArea("SED")
				dbSetOrder(1)
				dbSeek(xFilial("SED")+"3121")
			Endif
		ElseIf SE5->E5_TIPODOC $ "DC/D2"
			If SE5->E5_RECPAG == "P"
				dbSelectArea("SED")
				dbSetOrder(1)
				dbSeek(xFilial("SED")+"3180")
			Else
				dbSelectArea("SED")
				dbSetOrder(1)
				dbSeek(xFilial("SED")+"4780")
			Endif
		Endif
		
		dbSelectArea("TRB")
		If !dbseek(SED->ED_CODIGO+SE5->E5_RECPAG+"SE5")
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->RECPAG      := SE5->E5_RECPAG
			TRB->TIPOMOV     := "SE5"
			If SE5->E5_TIPODOC $ "MT/M2/JR/J2"
				If SE5->E5_RECPAG == "P"
					TRB->VALORD   := SE5->E5_VALOR
				Else
					TRB->VALORC   := SE5->E5_VALOR
				Endif
			ElseIf SE5->E5_TIPODOC $ "DC/D2"
				If SE5->E5_RECPAG == "P"
					TRB->VALORC   := SE5->E5_VALOR
				Else
					TRB->VALORD   := SE5->E5_VALOR
				Endif
			Else
				If SE5->E5_RECPAG == "R"
					TRB->VALORC   := SE5->E5_VALOR
				Else
					TRB->VALORD   := SE5->E5_VALOR
				Endif
			Endif
			
			TRB->NATUREZA := SED->ED_CODIGO
			TRB->DESCNAT  := SED->ED_DESCRIC
			TRB->TIPONAT  := SED->ED_CLASSE
			MsUnlock()
		Else
			dbSelectArea("TRB")
			RecLock("TRB",.F.)
			If SE5->E5_TIPODOC $ "MT/M2/JR/J2"
				If SE5->E5_RECPAG == "P"
					TRB->VALORD  += SE5->E5_VALOR
				Else
					TRB->VALORC  += SE5->E5_VALOR
				Endif
			ElseIf SE5->E5_TIPODOC $ "DC/D2"
				If SE5->E5_RECPAG == "P"
					TRB->VALORC  += SE5->E5_VALOR
				Else
					TRB->VALORD  += SE5->E5_VALOR
				Endif
			Else
				If SE5->E5_RECPAG == "R"
					TRB->VALORC  += SE5->E5_VALOR
				Else
					TRB->VALORD  += SE5->E5_VALOR
				Endif
			Endif
			MsUnlock()
		Endif
		
		dbSelectArea("TRB2")
		RecLock("TRB2",.T.)
		TRB2->NATUREZA    := SED->ED_CODIGO
		TRB2->PREF        := SE5->E5_PREFIXO
		TRB2->NUMERO      := SE5->E5_NUMERO
		TRB2->PARCELA     := SE5->E5_PARCELA
		TRB2->TIPO        := SE5->E5_TIPO
		TRB2->VALOR       := SE5->E5_VALOR
		TRB2->RECPAG      := SE5->E5_RECPAG
		TRB2->TIPODOC     := SE5->E5_TIPODOC
		MsUnlock()

		RestArea(_aAliSED)
		
		dbSelectArea("SE5")
		dbSkip()
	Enddo
	
	dbSelectArea("SED")
	dbSkip()
Enddo

dbSelectArea("TRB")
dbGotop()

ProcRegua(LastRec())

_nVlRecD := _nVlRecC := _nVlPagD := _nVlPagC := _nVlMovD := _nVlMovC := 0

While !EOF()
	
	IncProc()
	
	If TRB->RECPAG == "R" .And. TRB->TIPOMOV $  "SE1/SE2"
		
		_nVlRecD += TRB->VALORD
		_nVlRecC += TRB->VALORC
		
		_nLp := TRB->VALORC  - TRB->VALORD
		
		If _nLp > 0
			_cTipo := "VNR"
		Else
			_cTipo := "VPR"
			_nLP   := _nLp * -1
		Endif
		
		dbSelectArea("SE1")
		dbOrderNickname("INDSE14")
		dbSeek(xFilial("SE1")+_cTipo+"999999",.T.)
		
		dbSkip(-1)
		
		If SE1->E1_TIPO == _cTipo
			_cNum := StrZero(Val(SE1->E1_NUM)+1,6)
		Else
			_cNum := "000001"
		Endif
		
		dbSelectArea("SE1")
		RecLock("SE1",.T.)
		SE1->E1_FILIAL  := xFilial("SE1")
		SE1->E1_PREFIXO := "APR"
		SE1->E1_NUM     := _cNUm
		SE1->E1_TIPO    := _cTipo
		SE1->E1_NATUREZ := TRB->NATUREZA
		SE1->E1_CLIENTE := "ZRESUL"
		SE1->E1_LOJA    := "01"
		SE1->E1_NOMCLI  := "DRE"
		SE1->E1_EMISSAO := _dDtRef
		SE1->E1_EMIS1   := _dDtRef
		SE1->E1_VENCTO  := _dDtRef
		SE1->E1_VENCREA := _dDtRef
		SE1->E1_VENCORI := _dDtRef
		SE1->E1_VALOR   := _nLp
		SE1->E1_SALDO   := _nLp
		SE1->E1_VLCRUZ  := _nLp
		SE1->E1_MOEDA   := 1
		SE1->E1_OCORREN := "01"
		SE1->E1_STATUS  := "B"
		SE1->E1_ORIGEM  := "PA0108"
		SE1->E1_FLUXO   := "N"
		SE1->E1_FILORIG := "01"
		SE1->E1_DECRESC := _nLp
		SE1->E1_MSFIL   := "01"
		SE1->E1_MSEMP   := "01"
		SE1->E1_TIPODES := "1"
		MsUnlock()
	ElseIf TRB->RECPAG == "P" .And. TRB->TIPOMOV $  "SE1/SE2"
				
		_nVlPagD += TRB->VALORD
		_nVlPagC += TRB->VALORC
		
		_nLp     := TRB->VALORD - TRB->VALORC
		
		If _nLp > 0
			_cTipo := "VNP"
		Else
			_cTipo := "VPP"
			_nLP   := _nLp * -1
		Endif
		
		dbSelectArea("SE2")
		dbOrderNickname("INDSE21")
		dbSeek(xFilial("SE2")+_cTipo+"999999",.T.)
		
		dbSkip(-1)
		
		If SE2->E2_TIPO == _cTipo
			_cNum := sTRzERO(Val(SE2->E2_NUM)+1,6)
		Else
			_cNum := "000001"
		Endif
		
		dbSelectArea("SE2")
		RecLock("SE2",.T.)
		SE2->E2_FILIAL  := xFilial("SE2")
		SE2->E2_PREFIXO := "APR"
		SE2->E2_NUM     := _cNUm
		SE2->E2_TIPO    := _cTipo
		SE2->E2_NATUREZ := TRB->NATUREZA
		SE2->E2_FORNECE := "ZRESUL"
		SE2->E2_LOJA    := "01"
		SE2->E2_NOMFOR  := "DRE"
		SE2->E2_EMISSAO := _dDtRef
		SE2->E2_EMIS1   := _dDtRef
		SE2->E2_VENCTO  := _dDtRef
		SE2->E2_VENCREA := _dDtRef
		SE2->E2_VENCORI := _dDtRef
		SE2->E2_VALOR   := _nLp
		SE2->E2_SALDO   := _nLp
		SE2->E2_VLCRUZ  := _nLp
		SE2->E2_MOEDA   := 1
		SE2->E2_OCORREN := "01"
		SE2->E2_ORIGEM  := "PA0108"
		SE2->E2_FLUXO   := "N"
		MsUnlock()
	Else
		_nVlMovD += TRB->VALORD
		_nVlMOvC += TRB->VALORC
		
		_nLp     := TRB->VALORD - TRB->VALORC
		
		If _nLp > 0
			_cTipo := "R"
		Else
			_cTipo := "P"
			_nLP   := _nLp * -1
		Endif
		
		dbSelectArea("SE5")
		dbOrderNickname("INDSE57")
		dbSeek(xFilial("SE5")+"AR999999",.T.)
		
		dbSkip(-1)
		
		If SE5->E5_MOEDA == "AR"
			_cNum := StrZero(Val(SE5->E5_DOCUMEN)+1,6)
		Else
			_cNum := "000001"
		Endif
		
		dbSelectArea("SE5")
		RecLock("SE5",.T.)
		SE5->E5_FILIAL  := xFilial("SE5")
		SE5->E5_DATA    := _dDtRef
		SE5->E5_DTDIGIT := _dDtRef
		SE5->E5_DTDISPO := _dDtRef
		SE5->E5_VENCTO  := _dDtRef
		SE5->E5_MOEDA   := "AR"
		SE5->E5_VALOR   := _nLp
		SE5->E5_NATUREZ := TRB->NATUREZA
		SE5->E5_BANCO   := "ZAR"
		SE5->E5_AGENCIA := "001"
		SE5->E5_CONTA   := "000001"
		SE5->E5_DOCUMEN := _cNum
		SE5->E5_RECPAG  := _cTipo
		SE5->E5_HISTOR  := "APURACAO DE RESULTADO"
		MsUnlock()
	Endif
	
	dbSelectArea("TRB")
	dbSkip()
Enddo

_nLp := _nVlRecC - _nVLRecD

If _nLp <> 0
	If _nLp > 0
		_cTipo := "VNR"
	Else
		_cTipo := "VPR"
		_nLP   := _nLp * -1
	Endif
	
	dbSelectArea("SE1")
	dbOrderNickname("INDSE14")
	dbSeek(xFilial("SE1")+_cTipo+"999999",.T.)
	
	dbSkip(-1)
	
	If SE1->E1_TIPO == _cTipo
		_cNum := StrZero(Val(SE1->E1_NUM)+1,6)
	Else
		_cNum := "000001"
	Endif
	
	//  Resultado do Periodo
	
	dbSelectArea("SE1")
	RecLock("SE1",.T.)
	SE1->E1_FILIAL  := xFilial("SE1")
	SE1->E1_PREFIXO := "APR"
	SE1->E1_NUM     := _cNUm
	SE1->E1_TIPO    := _cTipo
	SE1->E1_NATUREZ := "2304"
	SE1->E1_CLIENTE := "ZRESUL"
	SE1->E1_LOJA    := "01"
	SE1->E1_NOMCLI  := "DRE"
	SE1->E1_EMISSAO := _dDtRef
	SE1->E1_EMIS1   := _dDtRef
	SE1->E1_VENCTO  := _dDtRef
	SE1->E1_VENCREA := _dDtRef
	SE1->E1_VENCORI := _dDtRef
	SE1->E1_VALOR   := _nLp
	SE1->E1_SALDO   := _nLp
	SE1->E1_VLCRUZ  := _nLp
	SE1->E1_MOEDA   := 1
	SE1->E1_OCORREN := "01"
	SE1->E1_STATUS  := "B"
	SE1->E1_ORIGEM  := "PA0108"
	SE1->E1_FLUXO   := "N"
	SE1->E1_FILORIG := "01"
	SE1->E1_DECRESC := _nLp
	SE1->E1_MSFIL   := "01"
	SE1->E1_MSEMP   := "01"
	SE1->E1_TIPODES := "1"
	MsUnlock()
	
	//  Resultado Acumulado
	
	_nVlAcum := _nLP

	_cNum := StrZero(Val(_cNum)+1,6)

	dbSelectArea("SE1")
	RecLock("SE1",.T.)
	SE1->E1_FILIAL  := xFilial("SE1")
	SE1->E1_PREFIXO := "APR"
	SE1->E1_NUM     := _cNUm
	SE1->E1_TIPO    := _cTipo
	SE1->E1_NATUREZ := "2303"
	SE1->E1_CLIENTE := "ZRESUL"
	SE1->E1_LOJA    := "01"
	SE1->E1_NOMCLI  := "DRE"
	SE1->E1_EMISSAO := _dDtRef
	SE1->E1_EMIS1   := _dDtRef
	SE1->E1_VENCTO  := _dDtRef
	SE1->E1_VENCREA := _dDtRef
	SE1->E1_VENCORI := _dDtRef
	SE1->E1_VALOR   := _nVlAcum
	SE1->E1_SALDO   := _nVlAcum
	SE1->E1_VLCRUZ  := _nVlAcum
	SE1->E1_MOEDA   := 1
	SE1->E1_OCORREN := "01"
	SE1->E1_STATUS  := "B"
	SE1->E1_ORIGEM  := "PA0108"
	SE1->E1_FLUXO   := "N"
	SE1->E1_FILORIG := "01"
	SE1->E1_DECRESC := _nVlAcum
	SE1->E1_MSFIL   := "01"
	SE1->E1_MSEMP   := "01"
	SE1->E1_TIPODES := "1"
	MsUnlock()
Endif

_nLp    := _nVlPagD - _nVLPagC

If _nLp <> 0
	If _nLp > 0
		_cTipo := "VNP"
	Else
		_cTipo := "VPP"
		_nLP   := _nLp * -1
	Endif
	
	dbSelectArea("SE2")
	dbOrderNickname("INDSE21")
	dbSeek(xFilial("SE2")+_cTipo+"999999",.T.)
	
	dbSkip(-1)
	
	If SE2->E2_TIPO == _cTipo
		_cNum := sTRzERO(Val(SE2->E2_NUM)+1,6)
	Else
		_cNum := "000001"
	Endif
	
	//  Resultado do Periodo
	
	dbSelectArea("SE2")
	RecLock("SE2",.T.)
	SE2->E2_FILIAL  := xFilial("SE2")
	SE2->E2_PREFIXO := "APR"
	SE2->E2_NUM     := _cNUm
	SE2->E2_TIPO    := _cTipo
	SE2->E2_NATUREZ := "2304"
	SE2->E2_FORNECE := "ZRESUL"
	SE2->E2_LOJA    := "01"
	SE2->E2_NOMFOR  := "DRE"
	SE2->E2_EMISSAO := _dDtRef
	SE2->E2_EMIS1   := _dDtRef
	SE2->E2_VENCTO  := _dDtRef
	SE2->E2_VENCREA := _dDtRef
	SE2->E2_VENCORI := _dDtRef
	SE2->E2_VALOR   := _nLp
	SE2->E2_SALDO   := _nLp
	SE2->E2_VLCRUZ  := _nLp
	SE2->E2_MOEDA   := 1
	SE2->E2_OCORREN := "01"
	SE2->E2_ORIGEM  := "PA0108"
	SE2->E2_FLUXO   := "N"
	MsUnlock()
	
	//  Resultado Acumulado
	
	_nVlAcum := _nLP
	_cNum    := StrZero(Val(_cNum)+1,6)
	
	dbSelectArea("SE2")
	RecLock("SE2",.T.)
	SE2->E2_FILIAL  := xFilial("SE2")
	SE2->E2_PREFIXO := "APR"
	SE2->E2_NUM     := _cNUm
	SE2->E2_TIPO    := _cTipo
	SE2->E2_NATUREZ := "2303"
	SE2->E2_FORNECE := "ZRESUL"
	SE2->E2_LOJA    := "01"
	SE2->E2_NOMFOR  := "DRE"
	SE2->E2_EMISSAO := _dDtRef
	SE2->E2_EMIS1   := _dDtRef
	SE2->E2_VENCTO  := _dDtRef
	SE2->E2_VENCREA := _dDtRef
	SE2->E2_VENCORI := _dDtRef
	SE2->E2_VALOR   := _nVlAcum
	SE2->E2_SALDO   := _nVlAcum
	SE2->E2_VLCRUZ  := _nVlAcum
	SE2->E2_MOEDA   := 1
	SE2->E2_OCORREN := "01"
	SE2->E2_ORIGEM  := "PA0108"
	SE2->E2_FLUXO   := "N"
	MsUnlock()
Endif

///  Movimentacao Bancaria

_nLp    := _nVlMOVD - _nVLMOVC

If _nLp <> 0
	If _nLp > 0
		_cTipo := "R"
	Else
		_cTipo := "P"
		_nLP   := _nLp * -1
	Endif
	
	dbSelectArea("SE5")
	dbOrderNickname("INDSE57")
	dbSeek(xFilial("SE5")+"AR999999",.T.)
	
	dbSkip(-1)
	
	If SE5->E5_MOEDA == "AR"
		_cNum := StrZero(Val(SE5->E5_DOCUMEN)+1,6)
	Else
		_cNum := "000001"
	Endif
	
	//  Resultado do Periodo
	
	dbSelectArea("SE5")
	RecLock("SE5",.T.)
	SE5->E5_FILIAL  := xFilial("SE5")
	SE5->E5_DATA    := _dDtRef
	SE5->E5_DTDIGIT := _dDtRef
	SE5->E5_DTDISPO := _dDtRef
	SE5->E5_VENCTO  := _dDtRef
	SE5->E5_MOEDA   := "AR"
	SE5->E5_VALOR   := _nLp
	SE5->E5_NATUREZ := "2304"
	SE5->E5_BANCO   := "ZAR"
	SE5->E5_AGENCIA := "001"
	SE5->E5_CONTA   := "000001"
	SE5->E5_DOCUMEN := _cNum
	SE5->E5_RECPAG  := _cTipo
	SE5->E5_HISTOR  := "APURACAO DE RESULTADO"
	MsUnlock()
	
	//  Resultado Acumulado
	
	If _nLp > 0
		_cTipo := "R"
	Else
		_cTipo := "P"
		_nLP   := _nLp * -1
	Endif
	
	dbSelectArea("SE5")
	dbOrderNickname("INDSE57")
	dbSeek(xFilial("SE5")+"AR999999",.T.)
	
	dbSkip(-1)
	
	If SE5->E5_MOEDA == "AR"
		_cNum := StrZero(Val(SE5->E5_DOCUMEN)+1,6)
	Else
		_cNum := "000001"
	Endif
	
	_nVlAcum := _nLP
	_cNum    := StrZero(Val(_cNum)+1,6)
	
	dbSelectArea("SE5")
	RecLock("SE5",.T.)
	SE5->E5_FILIAL  := xFilial("SE5")
	SE5->E5_DATA    := _dDtRef
	SE5->E5_DTDIGIT := _dDtRef
	SE5->E5_DTDISPO := _dDtRef
	SE5->E5_VENCTO  := _dDtRef
	SE5->E5_MOEDA   := "AR"
	SE5->E5_VALOR   := _nVlacum
	SE5->E5_NATUREZ := "2303"
	SE5->E5_BANCO   := "ZAR"
	SE5->E5_AGENCIA := "001"
	SE5->E5_CONTA   := "000001"
	SE5->E5_DOCUMEN := _cNum
	SE5->E5_RECPAG  := _cTipo
	SE5->E5_HISTOR  := "APURACAO DE RESULTADO"
	MsUnlock()
Endif

Return