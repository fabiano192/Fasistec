#INCLUDE "rwmake.ch"

User Function CriaSdoLot()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| Proc1(@_lFim) }
Private _cTitulo01 := 'Processando SB2'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_bAcao01   := {|_lFim| Proc2(@_lFim) }
_cTitulo01 := 'Processando SB9'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )


Return


Static Function Proc1(_lFim)

_cSubLote := "000000"

_dDtFech := GETMV("MV_ULMES")

dbSelectArea("SB9")
dbOrderNickName("INDSB91")
dbSeek(xFilial("SB9")+Dtos(_dDtFech),.t.)

ProcRegua(LastRec())

While !Eof() .And. SB9->B9_DATA == _dDtFech
	
	If _lFim
		Alert('Cancelado Pelo Usuario!!!')
		Return
	Endif
	
	IncProc()

	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+SB9->B9_COD)
		If SB1->B1_RASTRO == "N"
			dbSelectArea("SB9")
			dbSkip()
			Loop
		Endif
	Else
		dbSelectArea("SB9")
		dbSkip()
		Loop
	Endif
	
	_cSubLote := StrZero((Val(_cSubLote) + 1),6)
	
    dbSelectArea("SBJ")
    RecLock("SBJ",.T.)
    SBJ->BJ_FILIAL  := xFilial("SBJ")
    SBJ->BJ_COD     := SB9->B9_COD
    SBJ->BJ_DATA    := _dDtFech
    SBJ->BJ_DTVALID := _dDtFech
    SBJ->BJ_LOCAL   := SB9->B9_LOCAL
	SBJ->BJ_LOTECTL := "000001"
	SBJ->BJ_NUMLOTE := _cSubLote    
	SBJ->BJ_QINI    := SB9->B9_QINI
	MsUnlock()   
    	
	dbSelectArea("SB9")
	dbSkip()
EndDo

Return


Static Function Proc2(_lFim)

Local _cSubLote := "000000"

dbSelectArea("SB2")
dbGotop()

ProcRegua(LastRec())

_dDtFech := GETMV("MV_ULMES")

While !Eof()
	
	If _lFim
		Alert('Cancelado Pelo Usuario!!!')
		Return
	Endif
	
	IncProc()

	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+SB2->B2_COD)
		If SB1->B1_RASTRO == "N"
			dbSelectArea("SB2")
			dbSkip()
			Loop
		Endif
	Else
		dbSelectArea("SB2")
		dbSkip()
		Loop
	Endif
	
	_cSubLote := StrZero((Val(_cSubLote) + 1),6)
	
	dbSelectArea("SX6")
	_cDocSeq := StrZero(Val(GetMv("MV_DOCSEQ"))+1,6)
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := _cDocSeq
	MsUnlock()
	
	dbSelectArea("SB8")
	RecLock("SB8",.T.)
	SB8->B8_FILIAL  := "01"
	SB8->B8_QTDORI  := SB2->B2_QATU
	SB8->B8_PRODUTO := SB2->B2_COD
	SB8->B8_LOCAL   := SB2->B2_LOCAL
	SB8->B8_DATA    := DDATABASE
	SB8->B8_DTVALID := CTOD("31/12/2010")
	SB8->B8_SALDO   := SB2->B2_QATU
	SB8->B8_ORIGLAN := "MN"
	SB8->B8_LOTECTL := "000001"
	SB8->B8_NUMLOTE := _cSubLote
	SB8->B8_DOC     := "000001"
	SB8->B8_SERIE   := "MAN"
	MsUnlock()
	
	dbSelectArea("SD5")
	RecLock("SD5",.T.)
	SD5->D5_FILIAL  := "01"
	SD5->D5_PRODUTO := SB2->B2_COD
	SD5->D5_LOCAL   := SB2->B2_LOCAL
	SD5->D5_DOC     := "000001"
	SD5->D5_SERIE   := "MAN"
	SD5->D5_DATA    := DDATABASE
	SD5->D5_ORIGLAN := "MN"
	SD5->D5_NUMSEQ  := _cDocSeq
	SD5->D5_QUANT   := SB2->B2_QATU
	SD5->D5_LOTECTL := "000001"
	SD5->D5_NUMLOTE := _cSubLote
	SD5->D5_DTVALID := CTOD("31/12/2010")
	MsUnlock()
	
	dbSelectArea("SB2")
	dbSkip()
EndDo


Return