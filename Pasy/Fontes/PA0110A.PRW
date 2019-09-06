#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Pa0110 ³ Autor ³ Alexandro da Silva	    ³ Data ³ 28.10.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao dos Titulos a Pagar      						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Sigafin  												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0110A()

PRIVATE CbCont,CbTxt
Private tamanho := "M"
PRIVATE nTotEnt := 0,nTotSai := 0,nGerEnt := 0,nGerSai := 0,nTipo := 0,nColuna := 0,lContinua := .T.
PRIVATE nValor,cDoc
PRIVATE lVazio  := .T.
PRIVATE nMoeda, cTexto

cbtxt 	:= SPACE(10)
cbcont	:= 0
li 		:= 80
m_pag 	:= 1

pergunte("PA0110",.F.)
titulo := OemToAnsi("Relacao do Contas a Pagar")

nMoeda	:= mv_par09

PRIVATE wnrel
PRIVATE cDesc1   := OemToAnsi("Este programa ir  emitir a relacao do contas a Pagar       ")
PRIVATE cDesc2   := OemToAnsi("de acordo com os parametros definidos pelo usuario. Poder  ser")
PRIVATE cDesc3   := OemToAnsi("impresso em ordem de Natureza ")
PRIVATE limite   := 132
PRIVATE cString  := "SE1"
PRIVATE aOrd     := {}
PRIVATE cNomeArq
PRIVATE aReturn  := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
PRIVATE nomeprog := "PA0110"
PRIVATE nLastKey := 0
PRIVATE cPerg	 :="PA0110"

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

wnrel := "PA0110"
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
AADD(aStru,{"E2_EMISSAO" , "D" ,  8, 0 })
AADD(aStru,{"E2_PREFIXO" , "C" ,  3, 0 })
AADD(aStru,{"E2_NUM"     , "C" ,  6, 0 })
AADD(aStru,{"E2_PARCELA" , "C" ,  1, 0 })
AADD(aStru,{"E2_TIPO"    , "C" ,  3, 0 })
AADD(aStru,{"E2_FORNECE" , "C" ,  6, 0 })
AADD(aStru,{"E2_NOMFOR"  , "C" , 19, 0 })
AADD(aStru,{"E2_LOJA"    , "C" ,  2, 0 })
AADD(aStru,{"E2_NATUREZ" , "C" , 10, 0 })
AADD(aStru,{"E2_VALORD"  , "N" , 14, 2 })
AADD(aStru,{"E2_VALORC"  , "N" , 14, 2 })
AADD(aStru,{"E2_VENCTO"  , "D" ,  8, 0 })

_cArqTRB := CriaTrab(aStru,.T.)

_cChave	:= "DTOS(E2_EMISSAO)+E2_PREFIXO+E2_NUM+E2_PARCELA"

dbUseArea(.T.,,_cArqTRB,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",_cArqTRB,_cChave,,,"Criando Trabalho...")

aStru := {}
AADD(aStru,{"E2_EMISSAO" , "C" , 10, 0 })
AADD(aStru,{"E2_DESCNAT" , "C" , 40, 0 })
AADD(aStru,{"E2_VALORD"  , "N" , 14, 2 })
AADD(aStru,{"E2_VALORC"  , "N" , 14, 2 })

_cArqTRB := CriaTrab(aStru,.T.)

_cChave	:= "E2_EMISSAO"

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

_cQ := " SELECT * FROM "+RetSqlName("SE2")+" E2 "
_cQ += " WHERE E2.D_E_L_E_T_ = '' AND E2_FORNECE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
_cQ += " AND E2_LOJA    BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
_cQ += " AND E2_VENCREA BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
_cQ += " AND E2_NATUREZ BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
_cQ += " AND E2_EMIS1 BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQ += " ORDER BY E2_EMIS1 "

TCQUERY _cQ NEW ALIAS "SE2A"

TCSETFIELD("SE2A","E2_EMIS1","D")
TCSETFIELD("SE2A","E2_VENCTO","D")
TCSETFIELD("SE2A","E2_VENCREA","D")

dbSelectArea("SE2A")

ProcRegua(U_CONTREG())
                                                   
While !Eof()
	
	IncProc("Processando!!!!")

	If _lFim
		Alert("Cancelado pelo Usuario!!")
		Return
	EndIf
	
	IncProc()
	
	If !Empty(SE2A->E2_FATURA) .And. SE2A->E2_FATURA != "NOTFAT"
		dbSelectArea("SE2A")
		dbSkip()
		Loop
	Endif                                                                                    

	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+ SE2A->E2_FORNECE + SE2A->E2_LOJA )

	dbSelectArea("SED")
	dbSeek(xFilial("SED")+ SE2A->E2_NATUREZ)
	
	dbSelectarea("TRB")
	RecLock("TRB",.T.)
	TRB->E2_EMISSAO := SE2A->E2_EMIS1
	TRB->E2_FORNECE := SE2A->E2_FORNECE
	TRB->E2_LOJA    := SE2A->E2_LOJA
	TRB->E2_NOMFOR  := SA2->A2_NREDUZ
	TRB->E2_PREFIXO := SE2A->E2_PREFIXO
	TRB->E2_NUM     := SE2A->E2_NUM
	TRB->E2_PARCELA := SE2A->E2_PARCELA
	TRB->E2_NATUREZ := SE2A->E2_NATUREZ  
	
	If SE2A->E2_TIPO $ "NDF/AB-/VNP"
		TRB->E2_VALORC  := SE2A->E2_VALOR  
	Else
		TRB->E2_VALORD  := SE2A->E2_VALOR 	           
	Endif

	TRB->E2_TIPO    := SE2A->E2_TIPO
	TRB->E2_VENCTO  := SE2A->E2_VENCREA
	MsUnlock()
	
	dbSelectArea("SE2A")
	dbSkip()
EnDDo
                      
SE2A->(dbCloseArea())

Return


Static Function Imprime(_lFim)

/*
Pre Numero Pa Tp  Fornec Lj Nome Cl Emissao  Vencto           Debito         Credito          Saldo
999 999999 99 999 999999 99 9999999 99999999 99999999 99999999999999 999999999999999 99999999999999
0   4      11 14  18     25 28      36       45       54             69              85
*/

cabec1    := "Pre Numero Pa Tp  Fornec Lj Nome Cl Emissao  Vencto           Debito         Credito          Saldo"
cabec2    := ""
titulo    := "Tit.a Pagar: "+DTOC(MV_PAR01)+" A "+DTOC(MV_PAR02)
_nGerNatD := _nGerNatC := 0
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
	
	_cEmis := StrZero(Month(TRB->E2_EMISSAO),2)
	
	_nValNatD := _nValNatC  := 0     
	_cAno     := StrZero(Year(TRB->E2_EMISSAO),4)
	
	@li, 0 PSAY "Mes : "+_cEmis+" / "+_cAno
	li+=2
	
	dbSelectArea("TRB")
	
	While !Eof() .And. 	_cEmis == StrZero(Month(TRB->E2_EMISSAO),2)
		
		IncRegua()
		
		IF li > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(nTipo==1,15,18))
			li+=2
		Endif
		
		@li, 0 PSAY TRB->E2_PREFIXO
		@li, 4 PSAY TRB->E2_NUM
		@li,11 PSAY TRB->E2_PARCELA
		@li,14 PSAY TRB->E2_TIPO
		@li,18 PSAY TRB->E2_FORNECE
		@li,25 PSAY TRB->E2_LOJA
		@li,28 PSAY Substr(TRB->E2_NOMFOR,1,7)
		@li,36 PSAY TRB->E2_EMISSAO
		@li,45 PSAY TRB->E2_VENCTO
		@li,54 PSAY TRB->E2_VALORD                      Picture TM(TRB->E2_VALORD,14)
		@li,69 PSAY TRB->E2_VALORC                      Picture TM(TRB->E2_VALORC,14)
		@li,85 PSAY TRB->E2_VALORD - TRB->E2_VALORC     Picture TM(TRB->E2_VALORC,14)
				
		_nValNatD += TRB->E2_VALORD
		_nValNatC += TRB->E2_VALORC
		li++
		
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	li++
	@li, 0 PSAY "TOTAL do Mes: " + _cEmis
	@li,54 PSAY _nValNatD                PicTure tm(_nValNatD,14)
	@li,69 PSAY _nValNatC                PicTure tm(_nValNatC,14)
	@li,85 PSAY _nValNatD - _nValNatC    PicTure tm(_nValNatC,14)
	
	dbSelectArea("TRB2")
	RecLock("TRB2",.T.)
	TRB2->E2_EMISSAO := _cEmis+"/"+_cAno
	TRB2->E2_VALORD  := _nValNatD
	TRB2->E2_VALORC  := _nValNatC	
	MsUnlock()
	
	Li+=2
	_nGerNatD += _nValNatD
	_nGerNatC += _nValNatC	
	_nValnatD := _nValnatC := 0
	dbSelectArea("TRB")
EndDo

li++

@li,0  PSAY OemToAnsi("TOTAL GERAL : ")
@li,54 PSAY _nGERNatD               PicTure tm(_nGERNatD,14)
@li,69 PSAY _nGERNatC               PicTure tm(_nGERNatC,14)
@li,85 PSAY _nGERNatD -_nGERNatC    PicTure tm(_nGERNatC,14)

/*
Mes /Ano   Debito         Credito        Saldo
9999999999 99999999999999 99999999999999 99999999999999
0          11             26             41
*/
                                                                                              
cabec1    := "Mes /Ano   Debito         Credito        Saldo
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
	
	@li, 0  PSAY TRB2->E2_EMISSAO
	@li, 11 PSAY TRB2->E2_DESCNAT
	@li, 52 PSAY TRB2->E2_VALORD                       Picture TM(TRB->E2_VALORD,14)
	@li, 67 PSAY TRB2->E2_VALORC                       Picture TM(TRB->E2_VALORC,14)
	@li, 82 PSAY TRB2->E2_VALORD - TRB2->E2_VALORC     Picture TM(TRB->E2_VALORC,14)
	
	li++
	
	_nGerNatD += TRB2->E2_VALORD
	_nGerNatC += TRB2->E2_VALORC
	dbSelectArea("TRB2")
	dbSkip()
EndDo

li++

@li,0  PSAY OemToAnsi("TOTAL GERAL : ")
@li,52 PSAY _nGerNatD	            PicTure tm(_nGerNatD,14)
@li,67 PSAY _nGerNatC	            PicTure tm(_nGerNatC,14)
@li,82 PSAY _nGerNatD - _nGerNatC	PicTure tm(_nGerNatC,14)

If aReturn[5] = 1
	Set Printer to
	dbCommit()
	OurSpool(wnrel)
End
MS_FLUSH()

Return