#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Pa0100 ³ Autor ³ Alexandro da Silva	    ³ Data ³ 27.07.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao dos Titulos a Receber    						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Sigafin  												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0100()

PRIVATE CbCont,CbTxt
Private tamanho := "M"
PRIVATE nTotEnt := 0,nTotSai := 0,nGerEnt := 0,nGerSai := 0,nTipo := 0,nColuna := 0,lContinua := .T.
PRIVATE nValor,cDoc
PRIVATE lVazio  := .T.
PRIVATE nMoeda, cTexto

cbtxt 	:= SPACE(10)
cbcont	:= 0
li 		:= 132
m_pag 	:= 1

pergunte("PA0100",.F.)
titulo := OemToAnsi("Relacao do Contas a Receber")

nMoeda	:= mv_par09

PRIVATE wnrel
PRIVATE cDesc1   := OemToAnsi("Este programa ir  emitir a relacao do contas a Receber     ")
PRIVATE cDesc2   := OemToAnsi("de acordo com os parametros definidos pelo usuario. Poder  ser")
PRIVATE cDesc3   := OemToAnsi("impresso em ordem de Natureza ")
PRIVATE limite   := 80
PRIVATE cString  := "SE1"
PRIVATE aOrd     := {}
PRIVATE cNomeArq
PRIVATE aReturn  := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
PRIVATE nomeprog := "PA0100"
PRIVATE nLastKey := 0
PRIVATE cPerg	 :="PA0100"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros						³
//³ mv_par01				// da data							³
//³ mv_par02				// ate a data						³
//³ mv_par03				// Cliente  De       				³
//³ mv_par04				// Cliente Ate 						³
//³ mv_par05				// Loja   De         				³
//³ mv_par06				// Loja Ate     					³
//³ mv_par07				// Natureza   De					³
//³ mv_par08				// Natureza   Ate 					³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := "PA0100"
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
AADD(aStru,{"E1_EMISSAO" , "D" ,  8, 0 })
AADD(aStru,{"E1_PREFIXO" , "C" ,  3, 0 })
AADD(aStru,{"E1_NUM"     , "C" ,  6, 0 })
AADD(aStru,{"E1_PARCELA" , "C" ,  1, 0 })
AADD(aStru,{"E1_TIPO"    , "C" ,  3, 0 })
AADD(aStru,{"E1_CLIENTE" , "C" ,  6, 0 })
AADD(aStru,{"E1_NOMCLI"  , "C" , 19, 0 })
AADD(aStru,{"E1_LOJA"    , "C" ,  2, 0 })
AADD(aStru,{"E1_NATUREZ" , "C" , 10, 0 })
AADD(aStru,{"E1_VALORD"  , "N" , 14, 2 })
AADD(aStru,{"E1_VALORC"  , "N" , 14, 2 })
AADD(aStru,{"E1_VENCTO"  , "D" ,  8, 0 })

_cArqTRB := CriaTrab(aStru,.T.)

_cChave	:= "E1_NATUREZ +DTOS(E1_EMISSAO)+E1_PREFIXO+E1_NUM+E1_PARCELA"

dbUseArea(.T.,,_cArqTRB,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",_cArqTRB,_cChave,,,"Criando Trabalho...")

aStru := {}
AADD(aStru,{"E1_NATUREZ" , "C" , 10, 0 })
AADD(aStru,{"E1_DESCNAT" , "C" , 40, 0 })
AADD(aStru,{"E1_VALORD"  , "N" , 14, 2 })
AADD(aStru,{"E1_VALORC"  , "N" , 14, 2 })

_cArqTRB := CriaTrab(aStru,.T.)

_cChave	:= "E1_NATUREZ"

dbUseArea(.T.,,_cArqTRB,"TRB2",.F.,.F.)
dbSelectArea("TRB2")
IndRegua("TRB2",_cArqTRB,_cChave,,,"Criando Trabalho...")

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| GravaTRB(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )


Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| Imprime(@_lfim) }
Private _cTitulo01 := 'Imprimindo'
RptStatus(_bAcao01, _cTitulo01, _cMsg01, _lAborta01)

dbSelectArea("TRB")
dbCloseArea("TRB")

dbSelectArea("TRB2")
dbCloseArea("TRB2")


Return


Static Function GravaTrb(_lFim)

dbSelectArea("SE1")
dbSetOrder(11)
dbSeek(xFilial("SE1")+DTOS(MV_PAR01),.T.)

ProcRegua(Lastrec())

While !Eof() .And. SE1->E1_EMISSAO <= MV_PAR02
	
	If _lFim
		Alert("Cancelado pelo Usuario!!")
		Return
	EndIf
	
	IncProc()
	
	If  SE1->E1_CLIENTE  < MV_PAR03 .Or. SE1->E1_CLIENTE > MV_PAR04 .Or.;
		SE1->E1_LOJA     < MV_PAR05 .Or. SE1->E1_LOJA    > MV_PAR06 .Or.;
		SE1->E1_VENCREA  < MV_PAR07 .Or. SE1->E1_VENCREA > MV_PAR08 .Or.;
		SE1->E1_NATUREZ  < MV_PAR09 .Or. SE1->E1_NATUREZ > MV_PAR10
		dbSelectArea("SE1")
		dbSkip()
		Loop
	Endif
	
	If !Empty(SE1->E1_FATURA).And. SE1->E1_FATURA != "NOTFAT"
		dbSelectArea("SE1")
		dbSkip()
		Loop
	Endif

	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+ SE1->E1_CLIENTE + SE1->E1_LOJA )
	
	dbSelectArea("SED")
	dbSeek(xFilial("SED")+ SE1->E1_NATUREZ)
	
	dbSelectarea("TRB")
	RecLock("TRB",.T.)
	TRB->E1_EMISSAO := SE1->E1_EMISSAO
	TRB->E1_CLIENTE := SE1->E1_CLIENTE
	TRB->E1_LOJA    := SE1->E1_LOJA
	TRB->E1_NOMCLI  := SA1->A1_NREDUZ
	TRB->E1_PREFIXO := SE1->E1_PREFIXO
	TRB->E1_NUM     := SE1->E1_NUM
	TRB->E1_PARCELA := SE1->E1_PARCELA
	TRB->E1_NATUREZ := SE1->E1_NATUREZ
	
	If SE1->E1_TIPO $ "NCC/AB-/VNR"
		TRB->E1_VALORD  := SE1->E1_VALOR
	Else
		TRB->E1_VALORC  := SE1->E1_VALOR
	Endif
	
	TRB->E1_TIPO    := SE1->E1_TIPO
	TRB->E1_VENCTO  := SE1->E1_VENCREA
	MsUnlock()
	
	dbSelectArea("SE1")
	dbSkip()
EnDDo


Return


Static Function Imprime(_lFim)

/*
Pre Numero Pa Tp  Client Lj Nome Cl Emissao  Vencto           Debito         Credito          Saldo
999 999999 99 999 999999 99 9999999 99999999 99999999 99999999999999 999999999999999 99999999999999
0   4      11 14  18     25 28      36       45       54             69              85
*/

cabec1    := "Pre Numero Pa Tp  Client Lj Nome Cl Emissao  Vencto           Debito         Credito          Saldo"
cabec2    := ""
titulo    := "Tit. a Receber: "+DTOC(MV_PAR01)+" A "+DTOC(MV_PAR02)
_nGerNatD := _nGerNatC  := 0
Li        := 80

dbSelectArea("TRB")
dbGotop()

SetRegua(RecCount())

While ! Eof()
	
	IF _lFim
		@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
		lContinua:=.F.
		Exit
	Endif
	
	IF li > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(nTipo==1,15,18))
		li:= 9
	Endif
	
	_cNaturez := TRB->E1_NATUREZ
	dbSelectArea("SED")
	dbSeek(xFilial("SED")+_cNaturez)
	
	_nValNatd  := _nValNatC := 0
	_nNatSint  := 0
	
	@li, 0 PSAY _cNaturez + " "+SED->ED_DESCRIC
	li+=2
	
	dbSelectArea("TRB")
	
	While !Eof() .And. 	_cNaturez == TRB->E1_NATUREZ
		
		IncRegua()
		
		IF li > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(nTipo==1,15,18))
			@li, 0 PSAY _cNaturez + " "+SED->ED_DESCRIC
			li+=2
		Endif
		
		@li, 0 PSAY TRB->E1_PREFIXO
		@li, 4 PSAY TRB->E1_NUM
		@li,11 PSAY TRB->E1_PARCELA
		@li,14 PSAY TRB->E1_TIPO
		@li,18 PSAY TRB->E1_CLIENTE
		@li,25 PSAY TRB->E1_LOJA
		@li,28 PSAY Substr(TRB->E1_NOMCLI,1,7)
		@li,36 PSAY TRB->E1_EMISSAO
		@li,45 PSAY TRB->E1_VENCTO
		@li,54 PSAY TRB->E1_VALORD                   Picture TM(TRB->E1_VALORD,14)
		@li,69 PSAY TRB->E1_VALORC                   Picture TM(TRB->E1_VALORC,14)
		@li,85 PSAY TRB->E1_VALORC - TRB->E1_VALORD  Picture TM(TRB->E1_VALORC,14)
		
		_nValNatD += TRB->E1_VALORD
		_nValNatC += TRB->E1_VALORC
		
		li++
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	li++
	@li, 0 PSAY "TOTAL : " + _cNaturez + " "+SED->ED_DESCRIC
	@li,54 PSAY _nValNatD              PicTure tm(_nValNatD,14)
	@li,69 PSAY _nValNatC              PicTure tm(_nValNatC,14)
	@li,85 PSAY _nValNatC - _nValNatD  PicTure tm(_nValNatC,14)
	
	dbSelectArea("TRB2")
	RecLock("TRB2",.T.)
	TRB2->E1_NATUREZ := _cNaturez
	TRB2->E1_DESCNAT := SED->ED_DESCRIC
	TRB2->E1_VALORD  := _nValNatD
	TRB2->E1_VALORC  := _nValNatC
	MsUnlock()
	
	Li+=2
	_nGerNatD += _nValNatD
	_nGerNatC += _nValNatC
	_nValnatD := _nValnatC := 0
	
	dbSelectArea("TRB")
EndDo

li++

@li,0  PSAY OemToAnsi("TOTAL GERAL : ")
@li,54 PSAY _nGerNatD              PicTure tm(_nGerNatD,14)
@li,69 PSAY _nGerNatC              PicTure tm(_nGerNatC,14)
@li,85 PSAY _nGerNatC - _nGerNatD  PicTure tm(_nGerNatC,14)


/*
Natureza   Descricao da Natureza                            Debito        Credito          Saldo
9999999999 9999999999999999999999999999999999999999 99999999999999 99999999999999 99999999999999
0          11                                       52             67             82
*/

cabec1    := "Natureza   Descricao da Natureza                          Debito        Credito          Saldo"
cabec2    := ""
_nGerNatD := 0
_nGerNatC := 0
Li        := 80

dbSelectArea("TRB2")
dbGotop()

SetRegua(RecCount())

While ! Eof()
	
	IF _lFim
		@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
		lContinua:=.F.
		Exit
	Endif
	
	IF li > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(nTipo==1,15,18))
		li:= 9
	Endif
	
	IncRegua()
	
	@li, 0  PSAY TRB2->E1_NATUREZ
	@li, 11 PSAY TRB2->E1_DESCNAT
	@li, 52 PSAY TRB2->E1_VALORD                    Picture TM(TRB->E1_VALORD,14)
	@li, 67 PSAY TRB2->E1_VALORC                    Picture TM(TRB->E1_VALORC,14)
	@li, 82 PSAY TRB2->E1_VALORC - TRB2->E1_VALORD  Picture TM(TRB->E1_VALORC,14)
	
	li++
	
	_nGerNatD += TRB2->E1_VALORD
	_nGerNatC += TRB2->E1_VALORC
	
	dbSelectArea("TRB2")
	dbSkip()
EndDo

li++

@li,0  PSAY OemToAnsi("TOTAL GERAL : ")
@li,52 PSAY _nGerNatD	            PicTure tm(_nGerNatD,14)
@li,67 PSAY _nGerNatC            	PicTure tm(_nGerNatC,14)
@li,82 PSAY _nGerNatC - _nGerNatD	PicTure tm(_nGerNatC,14)

If aReturn[5] = 1
	Set Printer to
	dbCommit()
	OurSpool(wnrel)
End
MS_FLUSH()

Return
