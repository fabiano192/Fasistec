#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Pa0027 ³ Autor ³ Alexandro da Silva	    ³ Data ³ 01.09.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao da Movimentacao Bancaria 						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR620(void)											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0027()

PRIVATE CbCont,CbTxt
Private tamanho := " "
PRIVATE nTotEnt := 0,nTotSai := 0,nGerEnt := 0,nGerSai := 0,nTipo := 0,nColuna := 0,lContinua := .T.
PRIVATE nValor,cDoc
PRIVATE lVazio  := .T.
PRIVATE nMoeda, cTexto
PRIVATE cChave
PRIVATE cIndex
PRIVATE cHistor
PRIVATE cChaveSe5
PRIVATE cFiltro := ""
PRIVATE bFiltro

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt 	:= SPACE(10)
cbcont	:= 0
li 		:= 80
m_pag 	:= 1

pergunte("PA0027",.F.)
cMoeda := Str(mv_par09,1,0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos								     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := OemToAnsi("Relacao da Movimentacao Bancaria em ")
cabec1 := OemToAnsi("  DATA   BCO AGENCIA  CONTA    NATUREZA      DOCUMENTO                            VALOR             HISTORICO")
cabec2 := OemToAnsi("                                                                        ENTRADA             SAIDA            ")

nMoeda	:= mv_par09
cTexto	:= GetMv("MV_MOEDA"+Str(nMoeda,1))
Titulo	+= cTexto

PRIVATE wnrel
PRIVATE cDesc1 := OemToAnsi("Este programa ir  emitir a rela‡„o da movimenta‡„o banc ria")
PRIVATE cDesc2 := OemToAnsi("de acordo com os parametros definidos pelo usuario. Poder  ser")
PRIVATE cDesc3 := OemToAnsi("impresso em ordem de data disponivel,banco,natureza ou dt.digita‡„o.")
PRIVATE limite  := 132
PRIVATE cString := "SE5"
//PRIVATE aOrd := {OemToAnsi("Por Dt.Dispo"),OemToAnsi("Por Banco"),OemToAnsi("Por Natureza"),OemToAnsi("Dt.Digitacao")},nOrdem := 1
PRIVATE aOrd := {}
nOrdem := 1

PRIVATE titulo := OemToAnsi("Relacao da Movimentacao Bancaria")
PRIVATE cabec1
PRIVATE cabec2
PRIVATE cNomeArq
PRIVATE aReturn   := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
PRIVATE nomeprog := "PA0027"
PRIVATE nLastKey := 0
PRIVATE cPerg	 :="PA0027"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros						³
//³ mv_par01				// da data							³
//³ mv_par02				// ate a data						³
//³ mv_par03				// do banco 						³
//³ mv_par04				// ate o banco 						³
//³ mv_par05				// da natureza 						³
//³ mv_par06				// ate a natureza 					³
//³ mv_par07				// da data de digitacao 			³
//³ mv_par08				// ate a data de digitacao 			³
//³ mv_par09				// qual moeda						³
//³ mv_par10				// tipo de historico 				³
//³ mv_par11				// Analitico / Sintetico			³
//³ mv_par12				// Considera            			³ 1= Conciliados; 2= Nao Conciliados; 3= Todos
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := "PA0027"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)


nOrdem := aReturn[8]
nTipo  := aReturn[4]

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

aStru := {}
AADD(aStru,{"E5_DTDISPO" , "D" ,  8, 0 })
AADD(aStru,{"E5_PREFIXO" , "C" ,  3, 0 })
AADD(aStru,{"E5_NUMERO"  , "C" ,  6, 0 })
AADD(aStru,{"E5_PARCELA" , "C" ,  1, 0 })
AADD(aStru,{"E5_TIPO"    , "C" ,  3, 0 })
AADD(aStru,{"E5_CLIFOR"  , "C" ,  6, 0 })
AADD(aStru,{"E5_LOJA"    , "C" ,  2, 0 })
AADD(aStru,{"E5_DTDIGIT" , "D" ,  8, 0 })
AADD(aStru,{"E5_NATUREZ" , "C" , 10, 0 })
AADD(aStru,{"E5_BANCO"   , "C" ,  3, 0 })
AADD(aStru,{"E5_AGENCIA" , "C" ,  5, 0 })
AADD(aStru,{"E5_CONTA"   , "C" , 10, 0 })
AADD(aStru,{"E5_NUMCHEQ" , "C" , 15, 0 })
AADD(aStru,{"E5_VALOR"   , "N" , 17, 2 })
AADD(aStru,{"E5_HISTOR"  , "C" , 30, 0 })
AADD(aStru,{"E5_RECPAG"  , "C" ,  1, 0 })

_cArqTRB := CriaTrab(aStru,.T.)

titulo += OemToAnsi(" Por Natureza")
_cChave	:= "E5_NATUREZ +DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+SE5->E5_NUMCHEQ"

dbUseArea(.T.,,_cArqTRB,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",_cArqTRB,_cChave,,,"Criando Trabalho...")

If Len(AllTrim(aReturn[7])) > 2
	cFiltro := "{ || " + aReturn[7] + "}"
	bFiltro := &cFiltro
	dbSetFilter( bFiltro )
EndIf

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| GravaTRB(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )


Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| Fa620Imp(@lEnd,wnRel,cString) }
Private _cTitulo01 := 'Imprimindo'
RptStatus(_bAcao01, _cTitulo01, _cMsg01, _lAborta01)

dbSelectArea("TRB")
dbCloseArea("TRB")

Return


Static Function GravaTrb(_lFim)

dbSelectArea("SE5")
dbOrderNickName("INDSE51")
dbSeek(xFilial("SE5")+DTOS(MV_PAR01),.T.)

ProcRegua(Lastrec())

While !Eof() .And. SE5->E5_DTDISPO <= MV_PAR02
	
	If _lFim
		Alert("Cancelado pelo Usuario!!")
		Return
	EndIf
	
	IncProc()       
	
	If SE5->E5_NATUREZ == "2110      " .And. SE5->E5_NUMCHEQ == "073816         "
		_lPare := .T.
	Endif	
	
	If SE5->E5_BANCO   < MV_PAR03 .Or. SE5->E5_BANCO   > MV_PAR04 .Or. ;
		SE5->E5_DTDIGIT < MV_PAR07 .Or. SE5->E5_DTDIGIT > MV_PAR08
		dbSelectArea("SE5")
		dbSkip()
		Loop
	Endif
	
	If MV_PAR12 == 1 .And. Empty(SE5->E5_RECONC )
		dbSelectArea("SE5")
		dbSkip()
		Loop
	Endif
	
	If MV_PAR12 == 2  .And. !Empty(SE5->E5_RECONC )
		dbSelectArea("SE5")
		dbSkip()
		Loop
	Endif
	
	IF Empty(SE5->E5_BANCO)
		dbSkip()
		Loop
	ENDIF
	
	If 	SE5->E5_NATUREZ < MV_PAR05 .Or. SE5->E5_NATUREZ > MV_PAR06
		dbSelectArea("SE5")
		dbSkip()
		Loop
	Endif
	
	IF SE5->E5_SITUACA == "C"
		dbSkip()
		Loop
	EndIF
	
	IF SE5->E5_MOEDA $ "C1/C2/C3/C4/C5" .and. SE5->E5_VENCTO > SE5->E5_DATA
		dbSkip()
		Loop
	Endif
	
	IF SE5->E5_TIPODOC $ "DC/JR/MT/BA/MT/CM/D2/J2/M2/C2/V2/CX/CP/TL"
		dbSkip()
		Loop
	EndIF

	_lParar := .T.
	_lPassou := .F.
	_lSair   := .F.
	If SE5->E5_TIPODOC $ "CH"
		_cCheque := SE5->E5_NUMCHEQ
		_aAliSE5 := SE5->(GETAREA())
		dbSelectArea("SE5")
		dbOrderNIckName("INDSE52")
		If dbSeek(xFilial("SE5")+_cCheque)
			While !Eof() .And. _cCheque == SE5->E5_NUMCHEQ .And. !_lSair
				
				If SE5->E5_TIPODOC $ "EC"
					dbSelectArea("SE5")
					dbSkip()
					_lSair := .T.
					Loop
				Endif
				
				If SE5->E5_TIPODOC $ "CH"
					dbSelectArea("SE5")
					dbSkip()
					Loop
				Endif
				
				If SE5->E5_TIPODOC $ "DC/MT/JR" .Or. SE5->E5_MOTBX $ "CMP/DEV" .Or. SE5->E5_SITUACA == "C"
					dbSelectArea("SE5")
					dbSkip()
					Loop
				Endif
				
				If 	SE5->E5_NATUREZ < MV_PAR05 .Or. SE5->E5_NATUREZ > MV_PAR06
					dbSelectArea("SE5")
					dbSkip()
					Loop
				Endif
				
				_lPassou  := .T.
				_lImprime := .T.
				_cConta   := SE5->E5_NATUREZ
				
				dbSelectarea("TRB")
				RecLock("TRB",.T.)
				TRB->E5_DTDISPO := SE5->E5_DTDISPO
				TRB->E5_BANCO   := SE5->E5_BANCO
				TRB->E5_AGENCIA := SE5->E5_AGENCIA
				TRB->E5_CONTA   := SE5->E5_CONTA
				TRB->E5_NATUREZ := SE5->E5_NATUREZ
				TRB->E5_NUMCHEQ := SE5->E5_NUMCHEQ
				TRB->E5_VALOR   := SE5->E5_VALOR
				TRB->E5_RECPAG  := SE5->E5_RECPAG
				TRB->E5_HISTOR  := SE5->E5_HISTOR
				
				MsUnlock()
				
				dbSelectArea("SE5")
				dbSkip()
			EndDo
			
			dbSelectArea("SE5")
			RestArea(_aAliSE5)
			
			If !_lPassou
				dbSelectarea("TRB")
				RecLock("TRB",.T.)
				TRB->E5_DTDISPO := SE5->E5_DTDISPO
				TRB->E5_BANCO   := SE5->E5_BANCO
				TRB->E5_AGENCIA := SE5->E5_AGENCIA
				TRB->E5_CONTA   := SE5->E5_CONTA
				TRB->E5_NATUREZ := SE5->E5_NATUREZ
				TRB->E5_NUMCHEQ := SE5->E5_NUMCHEQ
				TRB->E5_VALOR   := SE5->E5_VALOR
				TRB->E5_RECPAG  := SE5->E5_RECPAG
				TRB->E5_HISTOR  := SE5->E5_HISTOR
				MsUnlock()
			Endif
		Endif
		
		dbSelectArea("SE5")
		RestArea(_aAliSE5)
		dbSkip()
		Loop
	Endif
	
	dbSelectarea("TRB")
	RecLock("TRB",.T.)
	TRB->E5_DTDISPO := SE5->E5_DTDISPO
	TRB->E5_BANCO   := SE5->E5_BANCO
	TRB->E5_AGENCIA := SE5->E5_AGENCIA
	TRB->E5_CONTA   := SE5->E5_CONTA
	TRB->E5_NATUREZ := SE5->E5_NATUREZ
	TRB->E5_NUMCHEQ := SE5->E5_NUMCHEQ
	TRB->E5_VALOR   := SE5->E5_VALOR
	TRB->E5_RECPAG  := SE5->E5_RECPAG
	TRB->E5_HISTOR  := SE5->E5_HISTOR
	MsUnlock()
	
	dbSelectArea("SE5")
	dbSkip()
EnDDo


Return


Static Function FA620Imp(_lFim,wnRel,cString)

dbSelectArea("TRB")
dbGotop()

SetRegua(RecCount())

While ! Eof()
	
	IF _lFim
		@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
		lContinua:=.F.
		Exit
	Endif
	
	_cNaturez := TRB->E5_NATUREZ
	
	While !Eof() .And. 	_cNaturez == TRB->E5_NATUREZ
		
		
		IncRegua()
		
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(nTipo==1,15,18))
		Endif
		
		If mv_par11 == 1
			lVazio := .F.
			@li, 0 PSAY TRB->E5_DTDISPO
			@li, 9 PSAY TRB->E5_BANCO
			@li,14 PSAY TRB->E5_AGENCIA
			@li,22 PSAY TRB->E5_CONTA
			@li,33 PSAY TRB->E5_NATUREZ
			@li,45 PSAY TRB->E5_NUMCHEQ
			nColuna := IIF(TRB->E5_RECPAG = "R" ,63, 81)
			@li,nColuna PSAY TRB->E5_Valor PicTure tm(TRB->E5_VALOR,16)
		Endif
		
		IF TRB->E5_RECPAG = "R"
			nTotEnt += TRB->E5_VALOR
		Else
			nTotSai += TRB->E5_VALOR
		Endif
		
		If mv_par11 == 1
			@li,100 PSAY TRB->E5_HISTOR
			li++
		Endif
		
		dbSelectArea("TRB")
		dbSkip()
		
	EndDo
	
	If ( nTotEnt + nTotSai ) != 0
		li++
		dbSelectArea("SED")
		dbSeek(xFilial("SED")+_cNaturez)
		@li, 0 PSAY "Total : " + _cNaturez + " "+SED->ED_DESCRIC
		@li,63 PSAY nTotEnt	  PicTure tm(nTotEnt,16)
		@li,81 PSAY nTotSai	  PicTure tm(nTotSai,16)
		nGerEnt += nTotEnt
		nGerSai += nTotSai
		nTotEnt := 0
		nTotSai := 0
		li+=2
	Endif
	dbSelectArea("TRB")
EndDo


IF li != 80
	li++
	@li,	0 PSAY OemToAnsi("Total Geral : ")
	@li, 63 PSAY nGerEnt 	PicTure tm(nGerEnt,16)
	@li, 81 PSAY nGerSai 	PicTure tm(nGerSai,16)
	li++
	roda(cbcont,cbtxt)
End

If lVazio
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(nTipo==1,15,18))
	End
	@li, 0 PSAY OemToAnsi("Nao existem lancamentos neste periodo")
	li++
	roda(cbcont,cbtxt)
End

Set Device To Screen
dbSelectArea("SE5")
dbSetOrder(1)
Set Filter To

If aReturn[5] = 1
	Set Printer to
	dbCommit()
	OurSpool(wnrel)
End
MS_FLUSH()

Return
