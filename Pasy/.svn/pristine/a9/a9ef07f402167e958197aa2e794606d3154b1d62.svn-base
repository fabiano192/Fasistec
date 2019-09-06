#INCLUDE "rwmake.ch"  
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPA085A    บ Autor ณ 	Fabiano da Silva บ Data ณ  21/04/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Fluxo de Caixa / Previsใo (Financeiro)                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Sigafin                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PA085A()

Private _aMes     := {}
Private _cAno     := ""
Private _dDtI     := _dDtF    := Ctod("")
Private _lImprime := .T.
_cNomBco := ""
_nOpc 	 := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Relatorio Fluxo/Previsao Financeira")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina para apurar a movimentacao Financeira        "     SIZE 160,7
@ 18,18 SAY "Previsao e Realizado conforme parametros informados "     SIZE 160,7
@ 26,18 SAY "Pelo usuario.                                       "     SIZE 160,7
@ 34,18 SAY "Programa PA085A.PRW                                 "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0085")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	PA85A()
Endif

Return(.T.)


Static Function PA85A()

//PERGUNTA PA0085//
// MV_PAR01	-	DATA DE REFERENCIA
// MV_PAR02	-	NATUREZA DE
// MV_PAR03	-	NATUREZA ATE
// MV_PAR04 	-	BANCO DE
// MV_PAR05	-	BANCO ATE
// MV_PAR06	-	QUAIS BANCO (C/C ; VINCULADO ; TODOS)
// MV_PAR07	-	PREVISTO OU RELIZADO
// MV_PAR08    -   CONCILIADOS / NAO CONCILIADOS / TODOS

Pergunte("PA0085",.F.)

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.

_cDesSub := ""
_cGrupo  := ""
_nOrdem  := ""
_cConta  := ""
_cDesc2  := ""
_cNomGr  := ""
_cNomBco := ""
_cCampo  := ""
_nValor  := 0
_cTot    := ""

_cAno      := Substr(StrZero(Year(MV_PAR01),4),3,2)
_dDtIni    := CTOD("01/01/"+_cAno)
_dDtFim    := CTOD("31/12/"+_cAno)
_cArqNew   := "\CRYSTAL\PA0085M.DBF" //Mensal

_bAcao01   := {|_lFim| GeraTrbM(@_lFim) }
_cTitulo01 := 'Criando Arquivo de Trabalho...!!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

If MV_PAR07 = 1
	_cReaPr := "Realizado"
ElseIf MV_PAR07 = 2
	_cReaPr := "Previsto"
Else
	_cReaPr := "Projetado"
Endif

If MV_PAR07 = 1                  /// REALIZADO
	_bAcao01   := {|_lFim| SaldoB(@_lFim) }
	_cTitulo01 := 'Verificando Saldo Inicial!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
	
	_bAcao01   := {|_lFim| VerPgtoM(@_lFim) }
	_cTitulo01 := 'Selecionando Registros do Dia (Realizado)!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
ElseIf MV_PAR07 = 2              /// PREVISTO
	
	_bAcao01   := {|_lFim| VerPrev(@_lFim) }
	_cTitulo01 := 'Selecionando Registros do Dia (Previsto)!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
ElseIf MV_PAR07 = 3              /// PROJETADO
	
	_bAcao01   := {|_lFim| VerProj(@_lFim) }
	_cTitulo01 := 'Selecionando Registros do Dia (Projetado)!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
Endif

dbSelectArea("TRB")
Copy All To &_cArqNew
dbCloseArea()

_cMod    := cModulo
cModulo  := "EEC"
_lRet    := E_ARQCRW()

Public cSeqRel := ""

If _lImprime
	If MV_PAR07 == 1
		AVGCRW32("PA0085R.RPT","FLUXO DE CAIXA",) //Realizado
	ElseIf MV_PAR07 == 2
		AVGCRW32("PA0085P.RPT","FLUXO DE CAIXA",) //Previsto
	Else
		AVGCRW32("PA0085C.RPT","FLUXO DE CAIXA",) //Projetado
	Endif
Endif

cModulo  := _cMod

Return


Static Function GeraTrbM(_lFim)

aStru := {}
AADD(aStru,{"PA008501"  , "C" , 10, 0 })  // Natureza
AADD(aStru,{"PA008502"  , "C" , 60, 0 })  // Descri็ใo da Natureza
AADD(aStru,{"PA008503"  , "C" , 01, 0 })  // Grupo
AADD(aStru,{"PA008507"  , "C" , 30, 0 })  // Nome do Grupo
AADD(aStru,{"PA008504"  , "C" , 01, 0 })  // ORDEM
AADD(aStru,{"PA008505"  , "C" , 60, 0 })  // Descricao do SubGrupo Da Natureza
AADD(aStru,{"PA008506"  , "D" ,  8, 0 })  // Data de Referencia
AADD(aStru,{"PA008508"  , "C" , 15, 0 })  // Data Referencia
AADD(aStru,{"PA008509"  , "C" , 10, 0 })  // Tipo Relat๓rio
AADD(aStru,{"PA008510"  , "C" , 30, 0 })  // Banco / Nome
AADD(aStru,{"SALDO"     , "N" , 14, 2 })  // Saldo
AADD(aStru,{"VALOR01"   , "N" , 14, 2 })  // Valor 01
AADD(aStru,{"VALOR02"   , "N" , 14, 2 })  // Valor 02
AADD(aStru,{"VALOR03"   , "N" , 14, 2 })  // Valor 03
AADD(aStru,{"VALOR04"   , "N" , 14, 2 })  // Valor 04
AADD(aStru,{"VALOR05"   , "N" , 14, 2 })  // Valor 05
AADD(aStru,{"VALOR06"   , "N" , 14, 2 })  // Valor 06
AADD(aStru,{"VALOR07"   , "N" , 14, 2 })  // Valor 07
AADD(aStru,{"VALOR08"   , "N" , 14, 2 })  // Valor 08
AADD(aStru,{"VALOR09"   , "N" , 14, 2 })  // Valor 09
AADD(aStru,{"VALOR10"   , "N" , 14, 2 })  // Valor 10
AADD(aStru,{"VALOR11"   , "N" , 14, 2 })  // Valor 11
AADD(aStru,{"VALOR12"   , "N" , 14, 2 })  // Valor 12
AADD(aStru,{"VALOR13"   , "N" , 14, 2 })  // Valor 12

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "PA008503 + PA008504 + PA008501"
//_cIndTrb := "PA008503 + PA008501 + PA008504"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

Return


Static Function VerPgtoM(_lFim)

_nTotR01 := _nTotR02 := _nTotR03 := _nTotR04 := _nTotR05 := _nTotR06 := 0
_nTotR07 := _nTotR08 := _nTotR09 := _nTotR10 := _nTotR11 := _nTotR12 := 0
_nTotD01 := _nTotD02 := _nTotD03 := _nTotD04 := _nTotD05 := _nTotD06 := 0
_nTotD07 := _nTotD08 := _nTotD09 := _nTotD10 := _nTotD11 := _nTotD12 := 0
_nTotT01 := _nTotT02 := _nTotT03 := _nTotT04 := _nTotT05 := _nTotT06 := 0
_nTotT07 := _nTotT08 := _nTotT09 := _nTotT10 := _nTotT11 := _nTotT12 := 0
_cCheq1  := ""

_cQuery := " SELECT * FROM "+RetSqlName("SE5")+" E5 "
_cQuery += " INNER JOIN "+RetSqlName("SA6")+" A6 ON E5_BANCO+E5_AGENCIA+E5_CONTA = A6_COD+A6_AGENCIA+A6_NUMCON "
_cQuery += " WHERE E5.D_E_L_E_T_ = '' AND A6.D_E_L_E_T_ = ''"
_cQuery += " AND E5_DTDISPO BETWEEN  '"+DTOS(_dDtIni)+"' AND '"+DTOS(_dDtFim)+"'"
_cQuery += " AND E5_BANCO <> '' AND E5_SITUACA <> 'C'"
_cQuery += " AND E5_TIPODOC NOT IN ('BA','CM','D2','J2','M2','C2','V2','CX','CP','TL','DC','JR','MT')"
_cQuery += " AND E5_BANCO BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "
_cQuery += " AND E5_NATUREZ BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' "
_cQuery += " AND A6_FLUXCAI = 'S'"
_cQuery += " ORDER BY E5_DTDISPO,E5_NATUREZ,E5_BANCO "

TCQUERY _cQuery NEW ALIAS "SE5Q"

TCSETFIELD("SE5Q","E5_DTDISPO","D")
TCSETFIELD("SE5Q","E5_VENCREA","D")
TCSETFIELD("SE5Q","E5_VENCTO" ,"D")
TCSETFIELD("SE5Q","E5_DATA"   ,"D")
                              
//Cheque
_cQuer := " SELECT E5_NUMCHEQ,E5_VALOR,E5_TIPODOC,E5_NATUREZ,E5_RECPAG "
_cQuer += " FROM "+RetSqlName("SE5")+" E5 WHERE E5.D_E_L_E_T_ = '' "
_cQuer += " AND E5_SITUACA <> 'C'"
_cQuer += " AND E5_TIPO <> ''"
_cQuer += " AND E5_NATUREZ BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' "
_cQuer += " AND E5_TIPODOC NOT IN ('CH','DC','MT','JR') AND E5_MOTBX NOT IN ('CMP','DEV')"
_cQuer += " GROUP BY E5_NUMCHEQ,E5_VALOR,E5_TIPODOC,E5_NATUREZ,E5_RECPAG"
_cQuer += " ORDER BY E5_NUMCHEQ"

TCQUERY _cQuer NEW ALIAS "SE5C"

TCSETFIELD("SE5C","E5_DTDISPO","D")
TCSETFIELD("SE5C","E5_VENCREA","D")
TCSETFIELD("SE5C","E5_VENCTO" ,"D")
TCSETFIELD("SE5C","E5_DATA"   ,"D")

//cFilterUser:=aReturn[7]
//Set Softseek Off

dbSelectArea("SE5Q")

ProcRegua(U_CONTREG())

While !Eof() //.And. !_lSair
		
	IncProc()
	
	_cNaturez := SE5Q->E5_NATUREZ
	_nMes     := Month(SE5Q->E5_DTDISPO)
	_cCampo   := StrZero(_nMes,2)
	
	If _nMes == 9
		_lParar := .T.
	Endif
	
	While !Eof()  .And.  !_lFim  .And. _nMes == Month(SE5Q->E5_DTDISPO)
		
		IncProc("Data : "+DTOC(SE5Q->E5_DTDISPO)+" Numero : "+SE5Q->E5_NUMERO)
		
		IF SE5Q->E5_MOEDA $ "C1/C2/C3/C4/C5" .and. SE5Q->E5_VENCTO > SE5Q->E5_DATA
			dbSelectArea("SE5Q")
			dbSkip()
			Loop
		Endif
				
		If Empty(SE5Q->E5_RECONC) .And. MV_PAR08 = 01
			dbSelectArea("SE5Q")
			dbSkip()
			Loop
		Endif
		
		IF MV_PAR06 == 1 .And. SE5Q->A6_TPBANCO != "1"  // 1= CC E 2 == VINCULADA
			dbSelectArea("SE5Q")
			dbSkip()
			Loop
		Endif
			
		IF MV_PAR06 == 2 .And. SE5Q->A6_TPBANCO != "2"  // 1= CC E 2 == VINCULADA
			dbSelectArea("SE5Q")
			dbSkip()
			Loop
		Endif
		
		_lPassou := .F.
		_lSair   := .F.
		_lDesc   := .F.
		_dData   := SE5Q->E5_DTDISPO
		
		If SE5Q->E5_TIPODOC $ "CH"
						
			_cCheque := SE5Q->E5_NUMCHEQ
			dbSelectArea("SE5C")
			If dbSeek(xFilial()+_cCheque)
				While !Eof() .And. _cCheque == SE5C->E5_NUMCHEQ .And. !_lSair

					If SE5C->E5_TIPODOC $ "EC"
						dbSelectArea("SE5C")
						dbSkip()
						_lSair := .T.
						Loop
					Endif
										
					_lJuros   := .F.
					_lDesc    := .F.
					_cChav    := SE5C->E5_CLIFOR + SE5C->E5_LOJA + SE5C->E5_PREFIXO + SE5C->E5_NUMERO + SE5C->E5_PARCELA+SE5C->E5_TIPO
					_nValor   := SE5C->E5_VALOR
					_cNaturez := SE5C->E5_NATUREZ
					_cRecPag  := SE5C->E5_RECPAG
					_nVlDesco := SE5C->E5_VLDESCO
					_nVlJuros := SE5C->E5_VLJUROS
					_lPassou  := .T.
					
					GravaTRB()
					
					dbSelectArea("SE5C")
					dbSkip()
				EndDo
				
				If !_lPassou
					dbSelectArea("SE5Q")

					_nValor   := SE5Q->E5_VALOR
					_cChav    := SE5Q->E5_CLIFOR + SE5Q->E5_LOJA + SE5Q->E5_PREFIXO + SE5Q->E5_NUMERO + SE5Q->E5_PARCELA+SE5Q->E5_TIPO
					_cNaturez := SE5Q->E5_NATUREZ					
					_cRecPag  := SE5Q->E5_RECPAG
					_nVlDesco := SE5Q->E5_VLDESCO
					_nVlJuros := SE5Q->E5_VLJUROS					
					GravaTRB()
				Endif
				
			Endif
			
			dbSelectArea("SE5Q")
			dbSkip()
			Loop
		Endif
		
		_nValor   := SE5Q->E5_VALOR
		_cChav    := SE5Q->E5_CLIFOR + SE5Q->E5_LOJA + SE5Q->E5_PREFIXO + SE5Q->E5_NUMERO + SE5Q->E5_PARCELA+SE5Q->E5_TIPO
		_cNaturez := SE5Q->E5_NATUREZ		
		_cRecPag  := SE5Q->E5_RECPAG		
		_nVlDesco := SE5Q->E5_VLDESCO
		_nVlJuros := SE5Q->E5_VLJUROS

		If _nValor = 0
			dbSelectArea("SE5Q")
			dbSkip()
			Loop
		Endif
		
		GravaTRB()
		
		dbSelectArea("SE5Q")
		dbSkip()
	EndDo
EndDo

GeraVal()

Return


Static Function GravaTRB()

dbSelectArea("SED")
dbSetOrder(1)
dbSeek(xFilial()+_cNaturez)

_cConta   := Alltrim(_cNaturez)+Space(6)
_cDesc2   := Alltrim(_cNaturez)+" - "+SED->ED_DESCRIC
_nOrdem   := " "
//_nOrdem   := "1"

_lCont := .T.
If _cRecPag == "R"
	If _cNaturez == "1020      "
		_cTot   := "T"
		_cGrupo := "3"
		_cNomGr := "3-TRANSFERENCIA BANCARIA"
		_cDesc2 := "TRANSFERENCIA BANCARIA - RECEI"
		_nOrdem := "1"
	ElseIf	_cNaturez == "2110      "
		_cTot   := "T"
		_cGrupo := "3"
		_cNomGr := "3-TRANSFERENCIA BANCARIA"
		_cDesc2 := "CHEQUES CANCELADOS - RECEITA"
		_nOrdem := "3"
	Else
		_cTot   := "R"
		_cGrupo := "1"
		_cNomGr := "1-Receitas"
	Endif
		
	dbSelectArea("SE1")
	dbSetOrder(2)
	If dbSeek(xFilial()+_cChav)
		
		_cNatur1 := SE1->E1_NATOUT
		_cNatur2 := SE1->E1_NATOUT2
		
		If _nVlDesco <> 0
			_cConta := _cNatur2
			dbSelectArea("SED")
			dbSetOrder(1)
			dbSeek(xFilial()+_cConta)
		
			_cDesc2   := Alltrim(SED->ED_CODIGO)+" - "+SED->ED_DESCRIC
			_nVal1    := _nValor
			_nValor   := _nVlDesco * -1
			Grava() 
			_nValor   := _nVal1
		Endif
			
		If _nVlJuros <> 0
			_cConta := _cNatur1
			dbSelectArea("SED")
			dbSetOrder(1)
			dbSeek(xFilial()+_cConta)
		
			_cDesc2   := Alltrim(SED->ED_CODIGO)+" - "+SED->ED_DESCRIC
			_nVal2    := _nValor
			_nValor   := _nVlJuros
			Grava()             
			_nValor   := _nVal2
		Endif                                                                       		
  
		_nValor := _nValor - _nVlJuros + _nVlDesco
  		
  		_cConta   := Alltrim(_cNaturez)+Space(6)
  					
		dbSelectArea("SED")
		dbSetOrder(1)
		dbSeek(xFilial()+_cConta)
		_cDesc2   := Alltrim(SED->ED_CODIGO)+" - "+SED->ED_DESCRIC
		
		If _cConta $ "3110      /3111      /3112      /3113      /3114      /3119      "
			If 	SE1->E1_SITUACA == "0"
				_cDesc2   := Alltrim(_cConta)+"0 - COBRANCA EM CARTEIRA"
				_cConta   := Alltrim(_cConta)+"0"+space(5)
				_nOrdem   := "1"
			ElseIf 	SE1->E1_SITUACA == "1"
				_cDesc2   := Alltrim(_cConta)+"1 - COBRANCA SIMPLES	"
				_cConta   := Alltrim(_cConta)+"1"+space(5)
				_nOrdem   := "2"
			ElseIf 	SE1->E1_SITUACA == "2"
				_cDesc2   := Alltrim(_cConta)+"2 - COBRANCA DESCONTADA"
				_cConta   := Alltrim(_cConta)+"2"+space(5)
				_nOrdem   := "3"
			ElseIf 	SE1->E1_SITUACA == "3"
				_cDesc2   := Alltrim(_cConta)+"3 - COBRANCA CAUCIONADA"
				_cConta   := Alltrim(_cConta)+"3"+space(5)
				_nOrdem   := "4"
			ElseIf 	SE1->E1_SITUACA == "4"
				_cDesc2   := Alltrim(_cConta)+"4 - COBRANCA VINCULADA"
				_cConta   := Alltrim(_cConta)+"4"+space(5)
				_nOrdem   := "5"
			ElseIf 	SE1->E1_SITUACA == "5"
				_cDesc2   := Alltrim(_cConta)+"5 - COM ADVOGADO	"
				_cConta   := Alltrim(_cConta)+"5"+space(5)
				_nOrdem   := "5"
			ElseIf 	SE1->E1_SITUACA == "6"
				_cDesc2   := Alltrim(_cConta)+"6 - COBRANCA PROTESTADA"
				_cConta   := Alltrim(_cConta)+"6"+space(5)
				_nOrdem   := "6"
			ElseIf 	SE1->E1_SITUACA == "7"
				_cDesc2   := Alltrim(_cConta)+"7 - CANCEL. / DESCONTO"
				_cConta   := Alltrim(_cConta)+"7"+space(5)
				_nOrdem   := "7"
			Endif
		Endif
	Endif    

	Grava()

ElseIf _cRecPag == "P"
	If _cNaturez == "1020      "
		_cTot   := "T"
		_cGrupo := "3"
		_cNomGr := "3-TRANSFERENCIA BANCARIA"
		_cDesc2 := "TRANSFERENCIA BANCARIA - DESPE"
		_nOrdem := "2"
	ElseIf _cNaturez == "2110      "
		_cTot   := "T"
		_cGrupo := "3"
		_cNomGr := "3-TRANSFERENCIA BANCARIA"
		_cDesc2 := "CHEQUES CANCELADOS - DESPESA"
		_nOrdem := "4"
	Else
		_cTot   := "P"
		_cGrupo := "2"
		_cNomGr := "2-Custos e Despesas"
	Endif
	
	dbSelectArea("SE2")
	dbSetOrder(6)
	If dbSeek(xFilial()+_cChav)
				
		_cNatur1 := SE2->E2_NATOUT
		_cNatur2 := SE2->E2_NATOUT2
		
		If _nVlDesco <> 0
			_cConta := _cNatur2
			dbSelectArea("SED")
			dbSetOrder(1)
			dbSeek(xFilial()+_cConta)
		
			_cDesc2   := Alltrim(SED->ED_CODIGO)+" - "+SED->ED_DESCRIC
			_nVal1    := _nValor
			_nValor   := _nVlDesco * -1
			Grava()             
			_nValor   := _nVal1
		Endif
			
		If _nVlJuros <> 0
			_cConta := _cNatur1
			dbSelectArea("SED")
			dbSetOrder(1)
			dbSeek(xFilial()+_cConta)
		
			_cDesc2   := Alltrim(SED->ED_CODIGO)+" - "+SED->ED_DESCRIC
			_nVal2    := _nValor
			_nValor   := _nVlJuros
			Grava()             
			_nValor   := _nVal2
		Endif                                                                       		
  
		_nValor := _nValor - _nVlJuros + _nVldesco

		_cConta   := Alltrim(_cNaturez)+Space(6)		
		
		dbSelectArea("SED")
		dbSetOrder(1)
		dbSeek(xFilial()+_cConta)
		
		_cDesc2  := Alltrim(SED->ED_CODIGO)+" - "+SED->ED_DESCRIC
				
	Endif
	Grava()       
Endif                                                            


Static Function Grava()

_cDesSub := Tabela("Z9",SED->ED_GRGEREN)
dbSelectArea("TRB")
If !dbseek(_cGrupo  + _nOrdem + _cConta )
	//	If !dbseek(_cGrupo  + _cConta + _nOrdem)
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->PA008501    := _cConta
	TRB->PA008502    := _cDesc2
	TRB->PA008503    := _cGrupo
	TRB->PA008507    := _cNomGr
	TRB->PA008504    := _nOrdem
	TRB->PA008505    := _cDesSub
	TRB->PA008509 	 := "Realizado"
	TRB->PA008508    := STRZERO(Year(MV_PAR01),4)
	If MV_PAR04 == MV_PAR05
		TRB->PA008510    := MV_PAR04 + " - "+Alltrim(_cNomBco)
	Endif
	_cValor          := "TRB->VALOR" + _cCampo
	&_cValor         := _nValor
	
	If _cTot = "R"
		If _cCampo = "01"
			_nTotR01 += _nValor
		ElseIf	_cCampo = "02"
			_nTotR02 += _nValor
		ElseIf	_cCampo = "03"
			_nTotR03 += _nValor
		ElseIf	_cCampo = "04"
			_nTotR04 += _nValor
		ElseIf	_cCampo = "05"
			_nTotR05 += _nValor
		ElseIf	_cCampo = "06"
			_nTotR06 += _nValor
		ElseIf	_cCampo = "07"
			_nTotR07 += _nValor
		ElseIf	_cCampo = "08"
			_nTotR08 += _nValor
		ElseIf	_cCampo = "09"
			_nTotR09 += _nValor
		ElseIf	_cCampo = "10"
			_nTotR10 += _nValor
		ElseIf	_cCampo = "11"
			_nTotR11 += _nValor
		ElseIf	_cCampo = "12"
		_nTotR12 += _nValor
		Endif
	ElseIf _cTot = "P"
		If _cCampo = "01"
			_nTotD01 += _nValor
		ElseIf	_cCampo = "02"
			_nTotD02 += _nValor
		ElseIf	_cCampo = "03"
			_nTotD03 += _nValor
		ElseIf	_cCampo = "04"
			_nTotD04 += _nValor
		ElseIf	_cCampo = "05"
			_nTotD05 += _nValor
		ElseIf	_cCampo = "06"
			_nTotD06 += _nValor
		ElseIf	_cCampo = "07"
			_nTotD07 += _nValor
		ElseIf	_cCampo = "08"
			_nTotD08 += _nValor
		ElseIf	_cCampo = "09"
			_nTotD09 += _nValor
		ElseIf	_cCampo = "10"
			_nTotD10 += _nValor
		ElseIf	_cCampo = "11"
			_nTotD11 += _nValor
		ElseIf	_cCampo = "12"
			_nTotD12 += _nValor
		Endif
	Endif
	MsUnlock()
Else
	Reclock("TRB",.F.)
	_cValor          := "TRB->VALOR" + _cCampo
	&_cValor         += _nValor
	MsUnlock()
	If _cTot = "R"
		If _cCampo = "01"
			_nTotR01 += _nValor
		ElseIf	_cCampo = "02"
			_nTotR02 += _nValor
		ElseIf	_cCampo = "03"
			_nTotR03 += _nValor
		ElseIf	_cCampo = "04"
			_nTotR04 += _nValor
		ElseIf	_cCampo = "05"
			_nTotR05 += _nValor
		ElseIf	_cCampo = "06"
			_nTotR06 += _nValor
		ElseIf	_cCampo = "07"
			_nTotR07 += _nValor
		ElseIf	_cCampo = "08"
			_nTotR08 += _nValor
		ElseIf	_cCampo = "09"
			_nTotR09 += _nValor
		ElseIf	_cCampo = "10"
			_nTotR10 += _nValor
		ElseIf	_cCampo = "11"
			_nTotR11 += _nValor
		ElseIf	_cCampo = "12"
			_nTotR12 += _nValor
		Endif
	ElseIf _cTot = "P"
		If _cCampo = "01"
			_nTotD01 += _nValor
		ElseIf	_cCampo = "02"
			_nTotD02 += _nValor
		ElseIf	_cCampo = "03"
			_nTotD03 += _nValor
		ElseIf	_cCampo = "04"
			_nTotD04 += _nValor
		ElseIf	_cCampo = "05"
			_nTotD05 += _nValor
		ElseIf	_cCampo = "06"
			_nTotD06 += _nValor
		ElseIf	_cCampo = "07"
			_nTotD07 += _nValor
		ElseIf	_cCampo = "08"
			_nTotD08 += _nValor
		ElseIf	_cCampo = "09"
			_nTotD09 += _nValor
		ElseIf	_cCampo = "10"
			_nTotD10 += _nValor
		ElseIf	_cCampo = "11"
			_nTotD11 += _nValor
		ElseIf	_cCampo = "12"
			_nTotD12 += _nValor
		Endif
	Endif
Endif
	
Return


Static Function GeraVal()

_nTraR01 := _nTraR02 := _nTraR03 := _nTraR04 := _nTraR05 := _nTraR06 := 0
_nTraR07 := _nTraR08 := _nTraR09 := _nTraR10 := _nTraR11 := _nTraR12 := 0
_nTraD01 := _nTraD02 := _nTraD03 := _nTraD04 := _nTraD05 := _nTraD06 := 0
_nTraD07 := _nTraD08 := _nTraD09 := _nTraD10 := _nTraD11 := _nTraD12 := 0

dbSelectArea("TRB")
If dbSeek("311020      ")
	//If dbSeek("31020      1")
	_nTraR01 := TRB->VALOR01
	_nTraR02 := TRB->VALOR02
	_nTraR03 := TRB->VALOR03
	_nTraR04 := TRB->VALOR04
	_nTraR05 := TRB->VALOR05
	_nTraR06 := TRB->VALOR06
	_nTraR07 := TRB->VALOR07
	_nTraR08 := TRB->VALOR08
	_nTraR09 := TRB->VALOR09
	_nTraR10 := TRB->VALOR10
	_nTraR11 := TRB->VALOR11
	_nTraR12 := TRB->VALOR12
Endif

dbSelectArea("TRB")
If dbSeek("321020      ")
	//If dbSeek("31020      2")
	_nTraD01 := TRB->VALOR01
	_nTraD02 := TRB->VALOR02
	_nTraD03 := TRB->VALOR03
	_nTraD04 := TRB->VALOR04
	_nTraD05 := TRB->VALOR05
	_nTraD06 := TRB->VALOR06
	_nTraD07 := TRB->VALOR07
	_nTraD08 := TRB->VALOR08
	_nTraD09 := TRB->VALOR09
	_nTraD10 := TRB->VALOR10
	_nTraD11 := TRB->VALOR11
	_nTraD12 := TRB->VALOR12
Endif

_nVlTr01 := _nTraR01 - _nTraD01
_nVlTr02 := _nTraR02 - _nTraD02
_nVlTr03 := _nTraR03 - _nTraD03
_nVlTr04 := _nTraR04 - _nTraD04
_nVlTr05 := _nTraR05 - _nTraD05
_nVlTr06 := _nTraR06 - _nTraD06
_nVlTr07 := _nTraR07 - _nTraD07
_nVlTr08 := _nTraR08 - _nTraD08
_nVlTr09 := _nTraR09 - _nTraD09
_nVlTr10 := _nTraR10 - _nTraD10
_nVlTr11 := _nTraR11 - _nTraD11
_nVlTr12 := _nTraR12 - _nTraD12

_nTot01  := _nTotR01 - _nTotD01 + _nVlTr01
_nTot02  := _nTotR02 - _nTotD02 + _nVlTr02
_nTot03  := _nTotR03 - _nTotD03 + _nVlTr03
_nTot04  := _nTotR04 - _nTotD04 + _nVlTr04
_nTot05  := _nTotR05 - _nTotD05 + _nVlTr05
_nTot06  := _nTotR06 - _nTotD06 + _nVlTr06
_nTot07  := _nTotR07 - _nTotD07 + _nVlTr07
_nTot08  := _nTotR08 - _nTotD08 + _nVlTr08
_nTot09  := _nTotR09 - _nTotD09 + _nVlTr09
_nTot10  := _nTotR10 - _nTotD10 + _nVlTr10
_nTot11  := _nTotR11 - _nTotD11 + _nVlTr11
_nTot12  := _nTotR12 - _nTotD12 + _nVlTr12
AceRoda()

Return


Static Function VerPrev(_lFim)

dbSelectArea("SE1")
dbOrderNickName("INDSE16")
dbGoTop()
//dbSeek(xFilial()+Dtos(_dDtIni)+MV_PAR02,.T.)

ProcRegua(LastRec())

_nToSldD := 0
_nToSldR := 0
_nToJanR := 0
_nToFevR := 0
_nToMarR := 0
_nToAbrR := 0
_nToMaiR := 0
_nToJunR := 0
_nToJulR := 0
_nToAgoR := 0
_nToSetR := 0
_nToOutR := 0
_nToNovR := 0
_nToDezR := 0
_nSaldo  := 0
_nToJanD := 0
_nToJanD := 0
_nToFevD := 0
_nToMarD := 0
_nToAbrD := 0
_nToMaiD := 0
_nToJunD := 0
_nToJulD := 0
_nToAgoD := 0
_nToSetD := 0
_nToOutD := 0
_nToNovD := 0
_nToDezD := 0

While !Eof() .And. !_lFim .And. SE1->E1_VENCTO <= _dDtFim .And. SE1->E1_NATUREZ <= MV_PAR03
	
	_cNaturez := SE1->E1_NATUREZ
	_nMes     := Month(SE1->E1_VENCTO)
	_cCampo   := StrZero(_nMes,2)
	
	If _nMes == 9
		_lParar := .T.
	Endif
	
	While !Eof()  .And.  !_lFim  .And. _nMes == Month(SE1->E1_VENCTO)
		
		IncProc("RECEBER - Data : "+DTOC(SE1->E1_VENCTO)+" Numero : "+SE1->E1_NUM)
		
		If !Empty(SE1->E1_FATURA).And. SE1->E1_FATURA != "NOTFAT"
			dbSelectArea("SE1")
			dbSkip()
			Loop
		Endif
		
		If SE1->E1_CLIENTE $ "ZRESUL/ZPROVI"
			dbSelectArea("SE1")
			dbSkip()
			Loop
		Endif
		
		IF !Empty(SE1->E1_BAIXA) .and. SE1->E1_BAIXA < _dDtIni .and. SE1->E1_SALDO == 0
			dbSkip()
			Loop
		EndIF
		
		dbSelectArea("SED")
		dbSetOrder(1)
		dbSeek(xFilial()+SE1->E1_NATUREZ)
		
		_cConta   := SE1->E1_NATUREZ
		_cDesc2   := Alltrim(SE1->E1_NATUREZ)+" - "+SED->ED_DESCRIC
		_cGrupo   := "1"
		_cNomGr   := "1-Receitas"
		_nValorR  := 0
		
		_lFoi   := .F.
		If SE1->E1_VENCTO < _dDtIni
			If SE1->E1_TIPO == "AB-"
				_aAliSE1 := SE1->(GetArea())
				_cPref  := SE1->E1_PREFIXO
				_cNume  := SE1->E1_NUM
				_cParc  := SE1->E1_PARCELA
				dbSelectArea("SE1")
				dbSetOrder(1)
				If dbSeek(xFilial()+_cPref+_cNume+_cParc+"NF ")
					_nSaldo := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,1,_dDtIni,_dDtIni,SE1->E1_LOJA,SE1->E1_FILIAL)
					_lFoi   := .T.
					
					dbSelectArea("SED")
					dbSetOrder(1)
					dbSeek(xFilial()+SE1->E1_NATUREZ)
				Endif
				
				RestArea(_aAliSE1)
				
				If _nSaldo == SE1->E1_VALOR
					_nSaldo := 0
				Endif
				
				If _lFoi .And. _nSaldo = 0
					dbSelectArea("SE1")
					dbSkip()
					Loop
				Endif
			Endif
		Endif
		
		If !_lFoi
			_nSaldo := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,1,_dDtIni,_dDtIni,SE1->E1_LOJA,SE1->E1_FILIAL)
		ElseIf _lFoi .and. _nSaldo > 0
			_nSaldo := SE1->E1_VALOR
		Endif
		
		If _nSaldo = 0
			dbSelectArea("SE1")
			dbSkip()
			Loop
		Endif
		
		If SE1->E1_TIPO $ ("NCC/AB-/RA ")
			_nValorR := SE1->E1_VALOR * -1
			_nSaldo  := _nSaldo * -1
		Else
			_nValorR := SE1->E1_VALOR
		Endif
		
		_nOrdem   := " "
		If SE1->E1_NATUREZ $ "3110      /3111      /3112      /3113      /3114      /3119      "
			If 	SE1->E1_SITUACA == "0"
				_cDesc2   := Alltrim(_cConta)+"0 - COBRANCA EM CARTEIRA"
				_cConta   := Alltrim(_cConta)+"0"+space(5)
				_nOrdem   := "1"
			ElseIf 	SE1->E1_SITUACA == "1"
				_cDesc2   := Alltrim(_cConta)+"1 - COBRANCA SIMPLES	"
				_cConta   := Alltrim(_cConta)+"1"+space(5)
				_nOrdem   := "2"
			ElseIf 	SE1->E1_SITUACA == "2"
				_cDesc2   := Alltrim(_cConta)+"2 - COBRANCA DESCONTADA"
				_cConta   := Alltrim(_cConta)+"2"+space(5)
				_nOrdem   := "3"
			ElseIf 	SE1->E1_SITUACA == "3"
				_cDesc2   := Alltrim(_cConta)+"3 - COBRANCA CAUCIONADA"
				_cConta   := Alltrim(_cConta)+"3"+space(5)
				_nOrdem   := "4"
			ElseIf 	SE1->E1_SITUACA == "4"
				_cDesc2   := Alltrim(_cConta)+"4 - COBRANCA VINCULADA"
				_cConta   := Alltrim(_cConta)+"4"+space(5)
				_nOrdem   := "5"
			ElseIf 	SE1->E1_SITUACA == "5"
				_cDesc2   := Alltrim(_cConta)+"5 - COM ADVOGADO	"
				_cConta   := Alltrim(_cConta)+"5"+space(5)
				_nOrdem   := "5"
			ElseIf 	SE1->E1_SITUACA == "6"
				_cDesc2   := Alltrim(_cConta)+"6 - COBRANCA PROTESTADA"
				_cConta   := Alltrim(_cConta)+"6"+space(5)
				_nOrdem   := "6"
			ElseIf 	SE1->E1_SITUACA == "7"
				_cDesc2   := Alltrim(_cConta)+"7 - CANCEL. / DESCONTO"
				_cConta   := Alltrim(_cConta)+"7"+space(5)
				_nOrdem   := "7"
			Endif
		Endif
		
		_cDesSub := Tabela("Z9",SED->ED_GRGEREN)
		dbSelectArea("TRB")
		If !dbseek(_cGrupo + _nOrdem + _cConta)
			//		If !dbseek(_cGrupo + _cConta + _nOrdem)
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->PA008501    := _cConta
			TRB->PA008502    := _cDesc2
			TRB->PA008503    := _cGrupo
			TRB->PA008507    := _cNomGr
			TRB->PA008504    := _nOrdem
			TRB->PA008505    := _cDesSub
			TRB->PA008509 	 := "Previsto"
			TRB->PA008508    := STRZERO(Year(MV_PAR01),4)
			If SE1->E1_VENCTO < _dDtIni
				TRB->SALDO := _nSaldo
			Else
				_cValor          := "TRB->VALOR" + _cCampo
				&_cValor         := _nValorR
			Endif
			MsUnlock()
		Else
			RecLock("TRB",.F.)
			If SE1->E1_VENCTO < _dDtIni
				TRB->SALDO 		 += _nSaldo
			Else
				_cValor          := "TRB->VALOR" + _cCampo
				&_cValor         += _nValorR
			Endif
			MsUnlock()
		Endif
		
		_nVlDAc := _nVlDDec := 0
		
		//Inicio Acrescimo
		If SE1->E1_SALDO = SE1->E1_VALOR .And. SE1->E1_ACRESC <> 0
			
			dbSelectArea("SED")
			dbSetOrder(1)
			dbSeek(xFilial()+SE1->E1_NATOUT)
			
			_cConta   := SE1->E1_NATOUT
			_cDesc2   := Alltrim(SE1->E1_NATOUT)+" - "+SED->ED_DESCRIC
			_cGrupo   := "1"
			_cNomGr   := "1-Receitas"
			_nOrdem   := " "
			
			If SE1->E1_NATOUT $ "3110      /3111      /3112      /3113      /3114      /3119      "
				If 	SE1->E1_SITUACA == "0"
					_cDesc2   := Alltrim(_cConta)+"0 - COBRANCA EM CARTEIRA"
					_cConta   := Alltrim(_cConta)+"0"+space(5)
					_nOrdem   := "1"
				ElseIf 	SE1->E1_SITUACA == "1"
					_cDesc2   := Alltrim(_cConta)+"1 - COBRANCA SIMPLES	"
					_cConta   := Alltrim(_cConta)+"1"+space(5)
					_nOrdem   := "2"
				ElseIf 	SE1->E1_SITUACA == "2"
					_cDesc2   := Alltrim(_cConta)+"2 - COBRANCA DESCONTADA"
					_cConta   := Alltrim(_cConta)+"2"+space(5)
					_nOrdem   := "3"
				ElseIf 	SE1->E1_SITUACA == "3"
					_cDesc2   := Alltrim(_cConta)+"3 - COBRANCA CAUCIONADA"
					_cConta   := Alltrim(_cConta)+"3"+space(5)
					_nOrdem   := "4"
				ElseIf 	SE1->E1_SITUACA == "4"
					_cDesc2   := Alltrim(_cConta)+"4 - COBRANCA VINCULADA"
					_cConta   := Alltrim(_cConta)+"4"+space(5)
					_nOrdem   := "5"
				ElseIf 	SE1->E1_SITUACA == "5"
					_cDesc2   := Alltrim(_cConta)+"5 - COM ADVOGADO	"
					_cConta   := Alltrim(_cConta)+"5"+space(5)
					_nOrdem   := "5"
				ElseIf 	SE1->E1_SITUACA == "6"
					_cDesc2   := Alltrim(_cConta)+"6 - COBRANCA PROTESTADA"
					_cConta   := Alltrim(_cConta)+"6"+space(5)
					_nOrdem   := "6"
				ElseIf 	SE1->E1_SITUACA == "7"
					_cDesc2   := Alltrim(_cConta)+"7 - CANCEL. / DESCONTO"
					_cConta   := Alltrim(_cConta)+"7"+space(5)
					_nOrdem   := "7"
				Endif
			Endif
			
			_nVlDAc := SE1->E1_ACRESC
			
			_cDesSub := Tabela("Z9",SED->ED_GRGEREN)
			dbSelectArea("TRB")
			If !dbseek(_cGrupo + _nOrdem + _cConta)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PA008501    := _cConta
				TRB->PA008502    := _cDesc2
				TRB->PA008503    := _cGrupo
				TRB->PA008507    := _cNomGr
				TRB->PA008504    := _nOrdem
				TRB->PA008505    := _cDesSub
				TRB->PA008509 	 := "Previsto"
				TRB->PA008508    := STRZERO(Year(MV_PAR01),4)
				If SE1->E1_VENCTO < _dDtIni
					TRB->SALDO := _nVlDAc
				Else
					_cValor          := "TRB->VALOR" + _cCampo
					&_cValor         := _nVlDAc
				Endif
				MsUnlock()
			Else
				RecLock("TRB",.F.)
				If SE1->E1_VENCTO < _dDtIni
					TRB->SALDO 		 += _nVlDAc
				Else
					_cValor          := "TRB->VALOR" + _cCampo
					&_cValor         += _nVlDAc
				Endif
				MsUnlock()
			Endif
		Endif //Fim Acrescimo
		
		//Inicio Decrescimo
		If SE1->E1_SALDO = SE1->E1_VALOR .And. SE1->E1_DECRESC <> 0
			
			dbSelectArea("SED")
			dbSetOrder(1)
			dbSeek(xFilial()+SE1->E1_NATOUT2)
			
			_cConta   := SE1->E1_NATOUT2
			_cDesc2   := Alltrim(SE1->E1_NATOUT2)+" - "+SED->ED_DESCRIC
			_cGrupo   := "1"
			_cNomGr   := "1-Receitas"
			_nOrdem   := " "
			
			If SE1->E1_NATOUT2 $ "3110      /3111      /3112      /3113      /3114      /3119      "
				If 	SE1->E1_SITUACA == "0"
					_cDesc2   := Alltrim(_cConta)+"0 - COBRANCA EM CARTEIRA"
					_cConta   := Alltrim(_cConta)+"0"+space(5)
					_nOrdem   := "1"
				ElseIf 	SE1->E1_SITUACA == "1"
					_cDesc2   := Alltrim(_cConta)+"1 - COBRANCA SIMPLES	"
					_cConta   := Alltrim(_cConta)+"1"+space(5)
					_nOrdem   := "2"
				ElseIf 	SE1->E1_SITUACA == "2"
					_cDesc2   := Alltrim(_cConta)+"2 - COBRANCA DESCONTADA"
					_cConta   := Alltrim(_cConta)+"2"+space(5)
					_nOrdem   := "3"
				ElseIf 	SE1->E1_SITUACA == "3"
					_cDesc2   := Alltrim(_cConta)+"3 - COBRANCA CAUCIONADA"
					_cConta   := Alltrim(_cConta)+"3"+space(5)
					_nOrdem   := "4"
				ElseIf 	SE1->E1_SITUACA == "4"
					_cDesc2   := Alltrim(_cConta)+"4 - COBRANCA VINCULADA"
					_cConta   := Alltrim(_cConta)+"4"+space(5)
					_nOrdem   := "5"
				ElseIf 	SE1->E1_SITUACA == "5"
					_cDesc2   := Alltrim(_cConta)+"5 - COM ADVOGADO	"
					_cConta   := Alltrim(_cConta)+"5"+space(5)
					_nOrdem   := "5"
				ElseIf 	SE1->E1_SITUACA == "6"
					_cDesc2   := Alltrim(_cConta)+"6 - COBRANCA PROTESTADA"
					_cConta   := Alltrim(_cConta)+"6"+space(5)
					_nOrdem   := "6"
				ElseIf 	SE1->E1_SITUACA == "7"
					_cDesc2   := Alltrim(_cConta)+"7 - CANCEL. / DESCONTO"
					_cConta   := Alltrim(_cConta)+"7"+space(5)
					_nOrdem   := "7"
				Endif
			Endif
			
			_nVlDDec := (SE1->E1_DECRESC * (-1))
			
			_cDesSub := Tabela("Z9",SED->ED_GRGEREN)
			dbSelectArea("TRB")
			If !dbseek(_cGrupo + _nOrdem + _cConta)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PA008501    := _cConta
				TRB->PA008502    := _cDesc2
				TRB->PA008503    := _cGrupo
				TRB->PA008507    := _cNomGr
				TRB->PA008504    := _nOrdem
				TRB->PA008505    := _cDesSub
				TRB->PA008509 	 := "Previsto"
				TRB->PA008508    := STRZERO(Year(MV_PAR01),4)
				If SE1->E1_VENCTO < _dDtIni
					TRB->SALDO 	 := _nVlDDec
				Else
					_cValor      := "TRB->VALOR" + _cCampo
					&_cValor     := _nVlDDec
				Endif
				MsUnlock()
			Else
				RecLock("TRB",.F.)
				If SE1->E1_VENCTO < _dDtIni
					TRB->SALDO 	 += _nVlDDec
				Else
					_cValor      := "TRB->VALOR" + _cCampo
					&_cValor     += _nVlDDec
				Endif
				MsUnlock()
			Endif
		Endif //Fim Decrescimo
		
		_nSaldo  := _nSaldo  + _nVlDAc + _nVlDDec
		_nValorR := _nValorR + _nVlDAc + _nVlDDec
		
		If SE1->E1_VENCTO < _dDtIni
			_nToSldR +=	_nSaldo
		Else
			If Month(SE1->E1_VENCTO) = 1
				_nToJanR += _nValorR
			ElseIf Month(SE1->E1_VENCTO) = 2
				_nToFevR += _nValorR
			ElseIf Month(SE1->E1_VENCTO) = 3
				_nToMarR += _nValorR
			ElseIf Month(SE1->E1_VENCTO) = 4
				_nToAbrR += _nValorR
			ElseIf Month(SE1->E1_VENCTO) = 5
				_nToMaiR += _nValorR
			ElseIf Month(SE1->E1_VENCTO) = 6
				_nToJunR += _nValorR
			ElseIf Month(SE1->E1_VENCTO) = 7
				_nToJulR += _nValorR
			ElseIf Month(SE1->E1_VENCTO) = 8
				_nToAgoR += _nValorR
			ElseIf Month(SE1->E1_VENCTO) = 9
				_nToSetR += _nValorR
			ElseIf Month(SE1->E1_VENCTO) = 10
				_nToOutR += _nValorR
			ElseIf Month(SE1->E1_VENCTO) = 11
				_nToNovR += _nValorR
			ElseIf Month(SE1->E1_VENCTO) = 12
				_nToDezR += _nValorR
			Endif
		Endif
		
		dbSelectArea("SE1")
		dbSkip()
		
	EndDo
	
EndDo

dbSelectArea("SE2")
dbOrderNickName("INDSE24")
dbGotop()
//dbSeek(xFilial()+Dtos(_dDtIni)+MV_PAR02,.T.)

ProcRegua(LastRec())

While !Eof() .And. !_lFim .And. SE2->E2_VENCTO <= _dDtFim .And. SE2->E2_NATUREZ <= MV_PAR03
	
	_cNaturez := SE2->E2_NATUREZ
	_nMes     := Month(SE2->E2_VENCTO)
	_cCampo   := StrZero(_nMes,2)
	
	If _nMes == 9
		_lParar := .T.
	Endif
	
	While !Eof()  .And.  !_lFim  .And. _nMes == Month(SE2->E2_VENCTO)
		
		IncProc("PAGAR - Data : "+DTOC(SE2->E2_VENCTO)+" Numero : "+SE2->E2_NUM)
		
		If !Empty(SE2->E2_FATURA) .And. SE2->E2_FATURA != "NOTFAT"
			dbSelectArea("SE2")
			dbSkip()
			Loop
		Endif
		
		If SE2->E2_FORNECE $ "ZRESUL/ZPROVI"
			dbSelectArea("SE2")
			dbSkip()
			Loop
		Endif
		
		IF !Empty(SE2->E2_BAIXA) .and. SE2->E2_BAIXA < _dDtIni .and. SE2->E2_SALDO == 0
			dbSkip()
			Loop
		EndIF
		
		dbSelectArea("SED")
		dbSetOrder(1)
		dbSeek(xFilial()+SE2->E2_NATUREZ)
		
		_cConta   := SE2->E2_NATUREZ
		_cDesc2   := Alltrim(SE2->E2_NATUREZ)+" - "+SED->ED_DESCRIC
		_cGrupo := "2"
		_cNomGr := "2-Custos e Despesas"
		_nValorD  := 0
		
		_nSaldo := SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,01,_dDtIni,_dDtIni,SE2->E2_LOJA,SE2->E2_FILIAL)
		
		If SE2->E2_TIPO $ ("NDF/PA ")
			_nValorD := SE2->E2_VALOR * -1
			_nSaldo  := _nSaldo * -1
		Else
			_nValorD := SE2->E2_VALOR
		Endif
		
		If _nSaldo = 0
			dbSelectArea("SE2")
			dbSkip()
			Loop
		Endif
		
		_cDesSub := Tabela("Z9",SED->ED_GRGEREN)
		dbSelectArea("TRB")
		If !dbseek(_cGrupo + "1" + _cConta)
			//		If !dbseek(_cGrupo + _cConta + "1")
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->PA008501    := _cConta
			TRB->PA008502    := _cDesc2
			TRB->PA008503    := _cGrupo
			TRB->PA008507    := _cNomGr
			TRB->PA008504    := "1"
			TRB->PA008505    := _cDesSub
			TRB->PA008509 	 := "Previsto"
			TRB->PA008508    := STRZERO(Year(MV_PAR01),4)
			If SE2->E2_VENCTO < _dDtIni
				TRB->SALDO 		 := _nSaldo
			Else
				_cValor          := "TRB->VALOR" + _cCampo
				&_cValor         := _nValorD
			Endif
			MsUnlock()
		Else
			RecLock("TRB",.F.)
			If SE2->E2_VENCTO < _dDtIni
				TRB->SALDO 		 += _nSaldo
			Else
				_cValor          := "TRB->VALOR" + _cCampo
				&_cValor         += _nValorD
			Endif
			MsUnlock()
		Endif
		
		_nVlDAc := _nVlDDec := 0
		//Inicio Acrescimo
		If SE2->E2_SALDO = SE2->E2_VALOR .And. SE2->E2_ACRESC <> 0
			
			dbSelectArea("SED")
			dbSetOrder(1)
			dbSeek(xFilial()+SE2->E2_NATOUT)
			
			_cConta   := SE2->E2_NATOUT
			_cDesc2   := Alltrim(SE2->E2_NATOUT)+" - "+SED->ED_DESCRIC
			_cGrupo := "2"
			_cNomGr := "2-Custos e Despesas"
			
			_nVlDAc := SE2->E2_ACRESC
			
			_cDesSub := Tabela("Z9",SED->ED_GRGEREN)
			dbSelectArea("TRB")
			If !dbseek(_cGrupo + "1" + _cConta)
				//		If !dbseek(_cGrupo + _cConta + "1")
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PA008501    := _cConta
				TRB->PA008502    := _cDesc2
				TRB->PA008503    := _cGrupo
				TRB->PA008507    := _cNomGr
				TRB->PA008504    := "1"
				TRB->PA008505    := _cDesSub
				TRB->PA008509 	 := "Previsto"
				TRB->PA008508    := STRZERO(Year(MV_PAR01),4)
				If SE2->E2_VENCTO < _dDtIni
					TRB->SALDO 		 := _nVlDAc
				Else
					_cValor          := "TRB->VALOR" + _cCampo
					&_cValor         := _nVlDAc
				Endif
				MsUnlock()
			Else
				RecLock("TRB",.F.)
				If SE2->E2_VENCTO < _dDtIni
					TRB->SALDO 		 += _nVlDAc
				Else
					_cValor          := "TRB->VALOR" + _cCampo
					&_cValor         += _nVlDAc
				Endif
				MsUnlock()
			Endif
		Endif //Fim Acrescimo
		
		//Inicio Decrescimo
		If SE2->E2_SALDO = SE2->E2_VALOR .And. SE2->E2_DECRESC <> 0
			
			dbSelectArea("SED")
			dbSetOrder(1)
			dbSeek(xFilial()+SE2->E2_NATOUT2)
			
			_cConta   := SE2->E2_NATOUT2
			_cDesc2   := Alltrim(SE2->E2_NATOUT2)+" - "+SED->ED_DESCRIC
			_cGrupo := "2"
			_cNomGr := "2-Custos e Despesas"
			
			_nVlDDec := (SE2->E2_DECRESC * (-1))
			
			_cDesSub := Tabela("Z9",SED->ED_GRGEREN)
			dbSelectArea("TRB")
			If !dbseek(_cGrupo + "1" + _cConta)
				//		If !dbseek(_cGrupo + _cConta + "1")
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PA008501    := _cConta
				TRB->PA008502    := _cDesc2
				TRB->PA008503    := _cGrupo
				TRB->PA008507    := _cNomGr
				TRB->PA008504    := "1"
				TRB->PA008505    := _cDesSub
				TRB->PA008509 	 := "Previsto"
				TRB->PA008508    := STRZERO(Year(MV_PAR01),4)
				If SE2->E2_VENCTO < _dDtIni
					TRB->SALDO 		 := _nVlDDec
				Else
					_cValor          := "TRB->VALOR" + _cCampo
					&_cValor         := _nVlDDec
				Endif
				MsUnlock()
			Else
				RecLock("TRB",.F.)
				If SE2->E2_VENCTO < _dDtIni
					TRB->SALDO 		 += _nVlDDec
				Else
					_cValor          := "TRB->VALOR" + _cCampo
					&_cValor         += _nVlDDec
				Endif
				MsUnlock()
			Endif
		Endif //Fim Decrescimo
		
		_nValorD := _nValorD + _nVlDAc + _nVlDDec
		_nSaldo  := _nSaldo  + _nVlDAc + _nVlDDec
		
		If SE2->E2_VENCTO < _dDtIni
			_nToSldD +=	_nSaldo
		Else
			If Month(SE2->E2_VENCTO) = 1
				_nToJanD += _nValorD
			ElseIf Month(SE2->E2_VENCTO) = 2
				_nToFevD += _nValorD
			ElseIf Month(SE2->E2_VENCTO) = 3
				_nToMarD += _nValorD
			ElseIf Month(SE2->E2_VENCTO) = 4
				_nToAbrD += _nValorD
			ElseIf Month(SE2->E2_VENCTO) = 5
				_nToMaiD += _nValorD
			ElseIf Month(SE2->E2_VENCTO) = 6
				_nToJunD += _nValorD
			ElseIf Month(SE2->E2_VENCTO) = 7
				_nToJulD += _nValorD
			ElseIf Month(SE2->E2_VENCTO) = 8
				_nToAgoD += _nValorD
			ElseIf Month(SE2->E2_VENCTO) = 9
				_nToSetD += _nValorD
			ElseIf Month(SE2->E2_VENCTO) = 10
				_nToOutD += _nValorD
			ElseIf Month(SE2->E2_VENCTO) = 11
				_nToNovD += _nValorD
			ElseIf Month(SE2->E2_VENCTO) = 12
				_nToDezD += _nValorD
			Endif
		Endif
		
		dbSelectArea("SE2")
		dbSkip()
		
	EndDo
EndDo

dbSelectArea("TRB")
RecLock("TRB",.T.)
TRB->PA008501    := "TOTAL"
TRB->PA008502    := "TOTAL GERAL"
TRB->PA008503    := "5"
TRB->PA008504    := "1"
TRB->PA008507    := "5-TOTAL GERAL"
//TRB->PA008505    := _cDesSub
TRB->PA008509 	 := "Previsto"
TRB->PA008508    := STRZERO(Year(MV_PAR01),4)
TRB->SALDO       := _nToSldR - _nToSldD
TRB->VALOR01     := _nToJanR - _nToJanD
TRB->VALOR02     := _nToFevR - _nToFevD
TRB->VALOR03     := _nToMarR - _nToMarD
TRB->VALOR04     := _nToAbrR - _nToAbrD
TRB->VALOR05     := _nToMaiR - _nToMaiD
TRB->VALOR06     := _nToJunR - _nToJunD
TRB->VALOR07     := _nToJulR - _nToJulD
TRB->VALOR08     := _nToAgoR - _nToAgoD
TRB->VALOR09     := _nToSetR - _nToSetD
TRB->VALOR10     := _nToOutR - _nToOutD
TRB->VALOR11     := _nToNovR - _nToNovD
TRB->VALOR12     := _nToDezR - _nToDezD

//AceRodb()

Return


Static Function VerProj(_lFim)

_nToSldD := _nToSldR := _nToJanR := _nToFevR := _nToMarR := _nToAbrR := _nToMaiR := _nToJunR := _nToJulR := _nToAgoR := 0
_nToSetR := _nToOutR := _nToNovR := _nToDezR := _nSaldo  := _nToJanD := _nToJanD := _nToFevD := _nToMarD := _nToAbrD := 0
_nToMaiD := _nToJunD := _nToJulD := _nToAgoD := _nToSetD := _nToOutD := _nToNovD := _nToDezD := 0

_cQ  := " SELECT * FROM SE1010 E1 "
_cQ  += " INNER JOIN SED010 ED ON ED_CODIGO = E1_NATUREZ "
_cQ  += " WHERE E1.D_E_L_E_T_ = '' AND ED.D_E_L_E_T_ = '' "
_cQ  += " AND E1_CLIENTE NOT IN ('ZRESUL','ZPROVI') "
_cQ  += " ORDER BY E1_VENCREA,E1_NATUREZ "

TCQUERY _cQ NEW ALIAS "ZE1"

TCSETFIELD("ZE1","E1_EMISSAO","D")
TCSETFIELD("ZE1","E1_VENCREA","D")
TCSETFIELD("ZE1","E1_BAIXA","D")

ZE1->(dbGotop())

ProcRegua(ZE1->(U_CONTREG()))

While ZE1->(!Eof()) .And. !_lFim
	
	_cNaturez := ZE1->E1_NATUREZ
	_nMes     := Month(ZE1->E1_VENCREA)
	_cCampo   := StrZero(_nMes,2)
		
	While !Eof()  .And.  !_lFim  .And. _nMes == Month(ZE1->E1_VENCREA)
		
		IncProc("RECEBER - Data : "+DTOC(ZE1->E1_VENCREA)+" Numero : "+ZE1->E1_NUM)
		
		If !Empty(ZE1->E1_FATURA).And. ZE1->E1_FATURA != "NOTFAT"
			dbSelectArea("ZE1")
			dbSkip()
			Loop
		Endif
				
		IF !Empty(ZE1->E1_BAIXA) .and. ZE1->E1_BAIXA < _dDtIni .and. ZE1->E1_SALDO == 0
			dbSelectArea("ZE1")
			dbSkip()
			Loop
		EndIF
				
		_cConta   := ZE1->E1_NATUREZ
		_cDesc2   := Alltrim(ZE1->E1_NATUREZ)+" - "+ZE1->ED_DESCRIC
		_cGrupo   := "1"
		_cNomGr   := "1-Receitas"
		_nValorR  := 0
		
		_lFoi   := .F.
		If ZE1->E1_VENCREA < _dDtIni
			If ZE1->E1_TIPO == "AB-"
				_cPref  := SE1->E1_PREFIXO
				_cNume  := SE1->E1_NUM
				_cParc  := SE1->E1_PARCELA
				dbSelectArea("SE1")
				dbSetOrder(1)
				If dbSeek(xFilial()+_cPref+_cNume+_cParc+"NF ")
					_nSaldo := SE1->E1_SALDO
					_lFoi   := .T.
					
					dbSelectArea("SED")
					dbSetOrder(1)
					dbSeek(xFilial()+SE1->E1_NATUREZ)
				Endif
								
				If _nSaldo == ZE1->E1_VALOR
					_nSaldo := 0
				Endif
				
				If _lFoi .And. _nSaldo = 0
					dbSelectArea("ZE1")
					dbSkip()
					Loop
				Endif
			Endif
		Endif
		
		If !_lFoi
			_nSaldo := ZE1->E1_SALDO
		ElseIf _lFoi .and. _nSaldo > 0
			_nSaldo := ZE1->E1_VALOR
		Endif
		
		If _nSaldo = 0
			dbSelectArea("ZE1")
			dbSkip()
			Loop
		Endif
		
		If ZE1->E1_TIPO == "RA "
			dbSelectArea("ZE1")
			dbSkip()
			Loop
		Endif
		
		If ZE1->E1_TIPO $ ("NCC/AB-")
			_nValorR := ZE1->E1_SALDO * -1
			_nSaldo  := _nSaldo * -1
		Else
			_nValorR := ZE1->E1_SALDO
		Endif
		
		If 	ZE1->E1_SITUACA == "2"
			dbSelectArea("ZE1")
			dbSkip()
			Loop
		Endif
		
		_nOrdem   := " "
		If ZE1->E1_NATUREZ $ "3110      /3111      /3112      /3113      /3114      /3119      "
			If 	ZE1->E1_SITUACA == "0"
				_cDesc2   := Alltrim(_cConta)+"0 - COBRANCA EM CARTEIRA"
				_cConta   := Alltrim(_cConta)+"0"+space(5)
				_nOrdem   := "1"
			ElseIf 	ZE1->E1_SITUACA == "1"
				_cDesc2   := Alltrim(_cConta)+"1 - COBRANCA SIMPLES	"
				_cConta   := Alltrim(_cConta)+"1"+space(5)
				_nOrdem   := "2"
			ElseIf 	ZE1->E1_SITUACA == "3"
				_cDesc2   := Alltrim(_cConta)+"3 - COBRANCA CAUCIONADA"
				_cConta   := Alltrim(_cConta)+"3"+space(5)
				_nOrdem   := "4"
			ElseIf 	ZE1->E1_SITUACA == "4"
				_cDesc2   := Alltrim(_cConta)+"4 - COBRANCA VINCULADA"
				_cConta   := Alltrim(_cConta)+"4"+space(5)
				_nOrdem   := "5"
			ElseIf 	ZE1->E1_SITUACA == "5"
				_cDesc2   := Alltrim(_cConta)+"5 - COM ADVOGADO	"
				_cConta   := Alltrim(_cConta)+"5"+space(5)
				_nOrdem   := "5"
			ElseIf 	ZE1->E1_SITUACA == "6"
				_cDesc2   := Alltrim(_cConta)+"6 - COBRANCA PROTESTADA"
				_cConta   := Alltrim(_cConta)+"6"+space(5)
				_nOrdem   := "6"
			ElseIf 	ZE1->E1_SITUACA == "7"
				_cDesc2   := Alltrim(_cConta)+"7 - CANCEL. / DESCONTO"
				_cConta   := Alltrim(_cConta)+"7"+space(5)
				_nOrdem   := "7"
			Endif
		Endif
				
		_cDesSub := Tabela("Z9",ZE1->ED_GRGEREN)
		dbSelectArea("TRB")
		If !dbseek(_cGrupo + _nOrdem + _cConta)
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->PA008501    := _cConta
			TRB->PA008502    := _cDesc2
			TRB->PA008503    := _cGrupo
			TRB->PA008507    := _cNomGr
			TRB->PA008504    := _nOrdem
			TRB->PA008505    := _cDesSub
			TRB->PA008509 	 := "Projetado"
			TRB->PA008508    := STRZERO(Year(MV_PAR01),4)
			If ZE1->E1_VENCREA < _dDtIni
				TRB->SALDO 		 := _nSaldo
			Else
				_cValor          := "TRB->VALOR" + _cCampo
				&_cValor         := _nValorR
			Endif
			MsUnlock()
		Else
			RecLock("TRB",.F.)
			If ZE1->E1_VENCREA < _dDtIni
				TRB->SALDO 		 += _nSaldo
			Else
				_cValor          := "TRB->VALOR" + _cCampo
				&_cValor         += _nValorR
			Endif
			MsUnlock()
		Endif
		
		_nVlDAc := _nVlDDec := 0
		
		//Inicio Acrescimo
		If ZE1->E1_SALDO = ZE1->E1_VALOR .And. ZE1->E1_ACRESC <> 0
			
			dbSelectArea("SED")
			dbSetOrder(1)
			dbSeek(xFilial()+ZE1->E1_NATOUT)
			
			_cConta   := ZE1->E1_NATOUT
			_cDesc2   := Alltrim(ZE1->E1_NATOUT)+" - "+SED->ED_DESCRIC
			_cGrupo   := "1"
			_cNomGr   := "1-Receitas"
			_nOrdem   := " "
			
			If ZE1->E1_NATOUT $ "3110      /3111      /3112      /3113      /3114      /3119      "
				If 	ZE1->E1_SITUACA == "0"
					_cDesc2   := Alltrim(_cConta)+"0 - COBRANCA EM CARTEIRA"
					_cConta   := Alltrim(_cConta)+"0"+space(5)
					_nOrdem   := "1"
				ElseIf 	ZE1->E1_SITUACA == "1"
					_cDesc2   := Alltrim(_cConta)+"1 - COBRANCA SIMPLES	"
					_cConta   := Alltrim(_cConta)+"1"+space(5)
					_nOrdem   := "2"
				ElseIf 	ZE1->E1_SITUACA == "2"
					_cDesc2   := Alltrim(_cConta)+"2 - COBRANCA DESCONTADA"
					_cConta   := Alltrim(_cConta)+"2"+space(5)
					_nOrdem   := "3"
				ElseIf 	ZE1->E1_SITUACA == "3"
					_cDesc2   := Alltrim(_cConta)+"3 - COBRANCA CAUCIONADA"
					_cConta   := Alltrim(_cConta)+"3"+space(5)
					_nOrdem   := "4"
				ElseIf 	ZE1->E1_SITUACA == "4"
					_cDesc2   := Alltrim(_cConta)+"4 - COBRANCA VINCULADA"
					_cConta   := Alltrim(_cConta)+"4"+space(5)
					_nOrdem   := "5"
				ElseIf 	ZE1->E1_SITUACA == "5"
					_cDesc2   := Alltrim(_cConta)+"5 - COM ADVOGADO	"
					_cConta   := Alltrim(_cConta)+"5"+space(5)
					_nOrdem   := "5"
				ElseIf 	ZE1->E1_SITUACA == "6"
					_cDesc2   := Alltrim(_cConta)+"6 - COBRANCA PROTESTADA"
					_cConta   := Alltrim(_cConta)+"6"+space(5)
					_nOrdem   := "6"
				ElseIf 	ZE1->E1_SITUACA == "7"
					_cDesc2   := Alltrim(_cConta)+"7 - CANCEL. / DESCONTO"
					_cConta   := Alltrim(_cConta)+"7"+space(5)
					_nOrdem   := "7"
				Endif
			Endif
			
			_nVlDAc := ZE1->E1_ACRESC
			
			_cDesSub := Tabela("Z9",SED->ED_GRGEREN)
			dbSelectArea("TRB")
			If !dbseek(_cGrupo + _nOrdem + _cConta)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PA008501    := _cConta
				TRB->PA008502    := _cDesc2
				TRB->PA008503    := _cGrupo
				TRB->PA008507    := _cNomGr
				TRB->PA008504    := _nOrdem
				TRB->PA008505    := _cDesSub
				TRB->PA008509 	 := "Previsto"
				TRB->PA008508    := STRZERO(Year(MV_PAR01),4)
				If ZE1->E1_VENCREA < _dDtIni
					TRB->SALDO := _nVlDAc
				Else
					_cValor          := "TRB->VALOR" + _cCampo
					&_cValor         := _nVlDAc
				Endif
				MsUnlock()
			Else
				RecLock("TRB",.F.)
				If ZE1->E1_VENCREA < _dDtIni
					TRB->SALDO 		 += _nVlDAc
				Else
					_cValor          := "TRB->VALOR" + _cCampo
					&_cValor         += _nVlDAc
				Endif
				MsUnlock()
			Endif
		Endif //Fim Acrescimo
		
		//Inicio Decrescimo
		If ZE1->E1_SALDO = SE1->E1_VALOR .And. ZE1->E1_DECRESC <> 0
			
			dbSelectArea("SED")
			dbSetOrder(1)
			dbSeek(xFilial()+ZE1->E1_NATOUT2)
			
			_cConta   := ZE1->E1_NATOUT2
			_cDesc2   := Alltrim(SE1->E1_NATOUT2)+" - "+SED->ED_DESCRIC
			_cGrupo   := "1"
			_cNomGr   := "1-Receitas"
			_nOrdem   := " "
			
			If ZE1->E1_NATOUT2 $ "3110      /3111      /3112      /3113      /3114      /3119      "
				If 	ZE1->E1_SITUACA == "0"
					_cDesc2   := Alltrim(_cConta)+"0 - COBRANCA EM CARTEIRA"
					_cConta   := Alltrim(_cConta)+"0"+space(5)
					_nOrdem   := "1"
				ElseIf 	ZE1->E1_SITUACA == "1"
					_cDesc2   := Alltrim(_cConta)+"1 - COBRANCA SIMPLES	"
					_cConta   := Alltrim(_cConta)+"1"+space(5)
					_nOrdem   := "2"
				ElseIf 	ZE1->E1_SITUACA == "2"
					_cDesc2   := Alltrim(_cConta)+"2 - COBRANCA DESCONTADA"
					_cConta   := Alltrim(_cConta)+"2"+space(5)
					_nOrdem   := "3"
				ElseIf 	ZE1->E1_SITUACA == "3"
					_cDesc2   := Alltrim(_cConta)+"3 - COBRANCA CAUCIONADA"
					_cConta   := Alltrim(_cConta)+"3"+space(5)
					_nOrdem   := "4"
				ElseIf 	ZE1->E1_SITUACA == "4"
					_cDesc2   := Alltrim(_cConta)+"4 - COBRANCA VINCULADA"
					_cConta   := Alltrim(_cConta)+"4"+space(5)
					_nOrdem   := "5"
				ElseIf 	ZE1->E1_SITUACA == "5"
					_cDesc2   := Alltrim(_cConta)+"5 - COM ADVOGADO	"
					_cConta   := Alltrim(_cConta)+"5"+space(5)
					_nOrdem   := "5"
				ElseIf 	ZE1->E1_SITUACA == "6"
					_cDesc2   := Alltrim(_cConta)+"6 - COBRANCA PROTESTADA"
					_cConta   := Alltrim(_cConta)+"6"+space(5)
					_nOrdem   := "6"
				ElseIf 	ZE1->E1_SITUACA == "7"
					_cDesc2   := Alltrim(_cConta)+"7 - CANCEL. / DESCONTO"
					_cConta   := Alltrim(_cConta)+"7"+space(5)
					_nOrdem   := "7"
				Endif
			Endif
			
			_nVlDDec := (ZE1->E1_DECRESC * (-1))
			
			_cDesSub := Tabela("Z9",SED->ED_GRGEREN)
			dbSelectArea("TRB")
			If !dbseek(_cGrupo + _nOrdem + _cConta)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PA008501    := _cConta
				TRB->PA008502    := _cDesc2
				TRB->PA008503    := _cGrupo
				TRB->PA008507    := _cNomGr
				TRB->PA008504    := _nOrdem
				TRB->PA008505    := _cDesSub
				TRB->PA008509 	 := "Previsto"
				TRB->PA008508    := STRZERO(Year(MV_PAR01),4)
				If ZE1->E1_VENCREA < _dDtIni
					TRB->SALDO 	 := _nVlDDec
				Else
					_cValor      := "TRB->VALOR" + _cCampo
					&_cValor     := _nVlDDec
				Endif
				MsUnlock()
			Else
				RecLock("TRB",.F.)
				If ZE1->E1_VENCREA < _dDtIni
					TRB->SALDO 	 += _nVlDDec
				Else
					_cValor      := "TRB->VALOR" + _cCampo
					&_cValor     += _nVlDDec
				Endif
				MsUnlock()
			Endif
		Endif //Fim Decrescimo
		
		_nSaldo  := _nSaldo  + _nVlDAc + _nVlDDec
		_nValorR := _nValorR + _nVlDAc + _nVlDDec

		If ZE1->E1_VENCREA < _dDtIni
			_nToSldR +=	_nSaldo
		Else
			If Month(ZE1->E1_VENCREA) = 1
				_nToJanR += _nValorR
			ElseIf Month(ZE1->E1_VENCREA) = 2
				_nToFevR += _nValorR
			ElseIf Month(ZE1->E1_VENCREA) = 3
				_nToMarR += _nValorR
			ElseIf Month(ZE1->E1_VENCREA) = 4
				_nToAbrR += _nValorR
			ElseIf Month(ZE1->E1_VENCREA) = 5
				_nToMaiR += _nValorR
			ElseIf Month(ZE1->E1_VENCREA) = 6
				_nToJunR += _nValorR
			ElseIf Month(ZE1->E1_VENCREA) = 7
				_nToJulR += _nValorR
			ElseIf Month(ZE1->E1_VENCREA) = 8
				_nToAgoR += _nValorR
			ElseIf Month(ZE1->E1_VENCREA) = 9
				_nToSetR += _nValorR
			ElseIf Month(ZE1->E1_VENCREA) = 10
				_nToOutR += _nValorR
			ElseIf Month(ZE1->E1_VENCREA) = 11
				_nToNovR += _nValorR
			ElseIf Month(ZE1->E1_VENCREA) = 12
				_nToDezR += _nValorR
			Endif
		Endif
		
		dbSelectArea("ZE1")
		dbSkip()
		
	EndDo
EndDo

dbSelectArea("ZE1")
dbclosearea()


_cQ  := " SELECT * FROM SE2010 E2 "
_cQ  += " INNER JOIN SED010 ED ON E2_NATUREZ = ED_CODIGO "
_cQ  += " WHERE E2.D_E_L_E_T_ = '' AND ED.D_E_L_E_T_ = '' "
_cQ  += " AND E2_FORNECE NOT IN ('ZRESUL','ZPROVI') "
_cQ  += " AND E2_TIPO NOT IN ('PA') "
_cQ  += " ORDER BY E2_VENCREA,E2_NATUREZ "

TCQUERY _cQ NEW ALIAS "ZE2"

TCSETFIELD("ZE2","E2_EMIS1","D")
TCSETFIELD("ZE2","E2_VENCREA","D")
TCSETFIELD("ZE2","E2_BAIXA","D")

ZE2->(dbGotop())

ProcRegua(ZE2->(U_CONTREG()))

While ZE2->(!Eof()) .And. !_lFim

	_cNaturez := ZE2->E2_NATUREZ
	_nMes     := Month(ZE2->E2_VENCREA)
	_cCampo   := StrZero(_nMes,2)
		
	While !Eof()  .And.  !_lFim  .And. _nMes == Month(ZE2->E2_VENCREA)
		
		IncProc("PAGAR - Data : "+DTOC(ZE2->E2_VENCREA)+" Numero : "+ZE2->E2_NUM)
	
		If !Empty(ZE2->E2_FATURA) .And. ZE2->E2_FATURA != "NOTFAT"
			dbSelectArea("ZE2")
			dbSkip()
			Loop
		Endif
				
		IF !Empty(ZE2->E2_BAIXA) .and. ZE2->E2_BAIXA < _dDtIni .and. ZE2->E2_SALDO == 0
			dbSelectArea("ZE2")
			dbSkip()
			Loop
		EndIF
				
		_cConta   := ZE2->E2_NATUREZ
		_cDesc2   := Alltrim(ZE2->E2_NATUREZ)+" - "+ZE2->ED_DESCRIC
		_cGrupo   := "2"
		_cNomGr   := "2-Custos e Despesas"
		_nValorD  := 0
		
		_nSaldo := ZE2->E2_SALDO
				
		If ZE2->E2_TIPO $ ("NDF")
			_nValorD := ZE2->E2_SALDO * -1
			_nSaldo  := _nSaldo * -1
		Else
			_nValorD := ZE2->E2_SALDO
		Endif
		
		If _nSaldo = 0
			dbSelectArea("ZE2")
			dbSkip()
			Loop
		Endif
		
		_cDesSub := Tabela("Z9",ZE2->ED_GRGEREN)
		dbSelectArea("TRB")
		If !dbseek(_cGrupo + "1" + _cConta)
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->PA008501    := _cConta
			TRB->PA008502    := _cDesc2
			TRB->PA008503    := _cGrupo
			TRB->PA008507    := _cNomGr
			TRB->PA008504    := "1"
			TRB->PA008505    := _cDesSub
			TRB->PA008509 	 := "Projetado"
			TRB->PA008508    := STRZERO(Year(MV_PAR01),4)
			If ZE2->E2_VENCREA < _dDtIni
				TRB->SALDO 		 := _nSaldo
			Else
				_cValor          := "TRB->VALOR" + _cCampo
				&_cValor         := _nValorD
			Endif
			MsUnlock()
		Else
			RecLock("TRB",.F.)
			If ZE2->E2_VENCREA < _dDtIni
				TRB->SALDO 		 += _nSaldo
			Else
				_cValor          := "TRB->VALOR" + _cCampo
				&_cValor         += _nValorD
			Endif
			MsUnlock()
		Endif
		
		_nVlDAc := _nVlDDec := 0
		//Inicio Acrescimo
		If ZE2->E2_SALDO = ZE2->E2_VALOR .And. ZE2->E2_ACRESC <> 0
			
			dbSelectArea("SED")
			dbSetOrder(1)
			dbSeek(xFilial()+ZE2->E2_NATOUT)
			
			_cConta   := ZE2->E2_NATOUT
			_cDesc2   := Alltrim(ZE2->E2_NATOUT)+" - "+SED->ED_DESCRIC
			_cGrupo   := "2"
			_cNomGr   := "2-Custos e Despesas"
			
			_nVlDAc   := ZE2->E2_ACRESC
			
			_cDesSub := Tabela("Z9",SED->ED_GRGEREN)
			dbSelectArea("TRB")
			If !dbseek(_cGrupo + "1" + _cConta)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PA008501    := _cConta
				TRB->PA008502    := _cDesc2
				TRB->PA008503    := _cGrupo
				TRB->PA008507    := _cNomGr
				TRB->PA008504    := "1"
				TRB->PA008505    := _cDesSub
				TRB->PA008509 	 := "Previsto"
				TRB->PA008508    := STRZERO(Year(MV_PAR01),4)
				If ZE2->E2_VENCREA < _dDtIni
					TRB->SALDO 		 := _nVlDAc
				Else
					_cValor          := "TRB->VALOR" + _cCampo
					&_cValor         := _nVlDAc
				Endif
				MsUnlock()
			Else
				RecLock("TRB",.F.)
				If ZE2->E2_VENCREA < _dDtIni
					TRB->SALDO 		 += _nVlDAc
				Else
					_cValor          := "TRB->VALOR" + _cCampo
					&_cValor         += _nVlDAc
				Endif
				MsUnlock()
			Endif
		Endif //Fim Acrescimo
		
		//Inicio Decrescimo
		If ZE2->E2_SALDO = ZE2->E2_VALOR .And. ZE2->E2_DECRESC <> 0
			
			dbSelectArea("SED")
			dbSetOrder(1)
			dbSeek(xFilial()+ZE2->E2_NATOUT2)
			
			_cConta   := ZE2->E2_NATOUT2
			_cDesc2   := Alltrim(ZE2->E2_NATOUT2)+" - "+SED->ED_DESCRIC
			_cGrupo := "2"
			_cNomGr := "2-Custos e Despesas"
			
			_nVlDDec := (ZE2->E2_DECRESC * (-1))
			
			_cDesSub := Tabela("Z9",SED->ED_GRGEREN)
			dbSelectArea("TRB")
			If !dbseek(_cGrupo + "1" + _cConta)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PA008501    := _cConta
				TRB->PA008502    := _cDesc2
				TRB->PA008503    := _cGrupo
				TRB->PA008507    := _cNomGr
				TRB->PA008504    := "1"
				TRB->PA008505    := _cDesSub
				TRB->PA008509 	 := "Previsto"
				TRB->PA008508    := STRZERO(Year(MV_PAR01),4)
				If ZE2->E2_VENCREA < _dDtIni
					TRB->SALDO 		 := _nVlDDec
				Else
					_cValor          := "TRB->VALOR" + _cCampo
					&_cValor         := _nVlDDec
				Endif
				MsUnlock()
			Else
				RecLock("TRB",.F.)
				If ZE2->E2_VENCREA < _dDtIni
					TRB->SALDO 		 += _nVlDDec
				Else
					_cValor          := "TRB->VALOR" + _cCampo
					&_cValor         += _nVlDDec
				Endif
				MsUnlock()
			Endif
		Endif //Fim Decrescimo
		
		_nValorD := _nValorD + _nVlDAc + _nVlDDec
		_nSaldo  := _nSaldo  + _nVlDAc + _nVlDDec

		If ZE2->E2_VENCREA < _dDtIni
			_nToSldD +=	_nSaldo
		Else
			If Month(ZE2->E2_VENCREA) = 1
				_nToJanD += _nValorD
			ElseIf Month(ZE2->E2_VENCREA) = 2
				_nToFevD += _nValorD
			ElseIf Month(ZE2->E2_VENCREA) = 3
				_nToMarD += _nValorD
			ElseIf Month(ZE2->E2_VENCREA) = 4
				_nToAbrD += _nValorD
			ElseIf Month(ZE2->E2_VENCREA) = 5
				_nToMaiD += _nValorD
			ElseIf Month(ZE2->E2_VENCREA) = 6
				_nToJunD += _nValorD
			ElseIf Month(ZE2->E2_VENCREA) = 7
				_nToJulD += _nValorD
			ElseIf Month(ZE2->E2_VENCREA) = 8
				_nToAgoD += _nValorD
			ElseIf Month(ZE2->E2_VENCREA) = 9
				_nToSetD += _nValorD
			ElseIf Month(ZE2->E2_VENCREA) = 10
				_nToOutD += _nValorD
			ElseIf Month(ZE2->E2_VENCREA) = 11
				_nToNovD += _nValorD
			ElseIf Month(ZE2->E2_VENCREA) = 12
				_nToDezD += _nValorD
			Endif
		Endif
		
		dbSelectArea("ZE2")
		dbSkip()
		
	EndDo
EndDo
    
dbSelectArea("ZE2")
dbCloseArea()

dbSelectArea("TRB")
RecLock("TRB",.T.)
TRB->PA008501    := "TOTAL"
TRB->PA008502    := "TOTAL GERAL"
TRB->PA008503    := "5"
TRB->PA008504    := "1"
TRB->PA008507    := "5-TOTAL GERAL"
TRB->PA008509 	 := "Projetado"
TRB->PA008508    := STRZERO(Year(MV_PAR01),4)
TRB->SALDO       := _nToSldR - _nToSldD
TRB->VALOR01     := _nToJanR - _nToJanD
TRB->VALOR02     := _nToFevR - _nToFevD
TRB->VALOR03     := _nToMarR - _nToMarD
TRB->VALOR04     := _nToAbrR - _nToAbrD
TRB->VALOR05     := _nToMaiR - _nToMaiD
TRB->VALOR06     := _nToJunR - _nToJunD
TRB->VALOR07     := _nToJulR - _nToJulD
TRB->VALOR08     := _nToAgoR - _nToAgoD
TRB->VALOR09     := _nToSetR - _nToSetD
TRB->VALOR10     := _nToOutR - _nToOutD
TRB->VALOR11     := _nToNovR - _nToNovD
TRB->VALOR12     := _nToDezR - _nToDezD

//AceRodb()

dbSelectArea("SZF")
dbSetOrder(1)
If dbSeek(xFilial()+STRZERO(Year(MV_PAR01),4)+"V")
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->PA008501    := "FORECAST"
	TRB->PA008502    := "(+)FORECAST VENDAS"
	TRB->PA008503    := "7"
	TRB->PA008504    := "1"
	TRB->PA008509 	 := "Projetado"
	TRB->PA008507    := "7-AJUSTES"
	TRB->PA008508    := STRZERO(Year(MV_PAR01),4)
	TRB->SALDO       := SZF->ZF_SALDO
	TRB->VALOR01     := SZF->ZF_JAN
	TRB->VALOR02     := SZF->ZF_FEV
	TRB->VALOR03     := SZF->ZF_MAR
	TRB->VALOR04     := SZF->ZF_ABR
	TRB->VALOR05     := SZF->ZF_MAI
	TRB->VALOR06     := SZF->ZF_JUN
	TRB->VALOR07     := SZF->ZF_JUL
	TRB->VALOR08     := SZF->ZF_AGO
	TRB->VALOR09     := SZF->ZF_SET
	TRB->VALOR10     := SZF->ZF_OUT
	TRB->VALOR11     := SZF->ZF_NOV
	TRB->VALOR12     := SZF->ZF_DEZ
Endif

dbSelectArea("SZF")
dbSetOrder(1)
If dbSeek(xFilial()+STRZERO(Year(MV_PAR01),4)+"R")
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->PA008501    := "FORECAST"
	TRB->PA008502    := "(+)AJUSTES RECEITAS"
	TRB->PA008503    := "7"
	TRB->PA008504    := "2"
	TRB->PA008507    := "7-AJUSTES"
	TRB->PA008508    := STRZERO(Year(MV_PAR01),4)
	TRB->PA008509 	 := "Projetado"
	TRB->SALDO       := SZF->ZF_SALDO
	TRB->VALOR01     := SZF->ZF_JAN
	TRB->VALOR02     := SZF->ZF_FEV
	TRB->VALOR03     := SZF->ZF_MAR
	TRB->VALOR04     := SZF->ZF_ABR
	TRB->VALOR05     := SZF->ZF_MAI
	TRB->VALOR06     := SZF->ZF_JUN
	TRB->VALOR07     := SZF->ZF_JUL
	TRB->VALOR08     := SZF->ZF_AGO
	TRB->VALOR09     := SZF->ZF_SET
	TRB->VALOR10     := SZF->ZF_OUT
	TRB->VALOR11     := SZF->ZF_NOV
	TRB->VALOR12     := SZF->ZF_DEZ
Endif

dbSelectArea("SZF")
dbSetOrder(1)
If dbSeek(xFilial()+STRZERO(Year(MV_PAR01),4)+"C")
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->PA008501    := "FORECAST"
	TRB->PA008502    := "(-)FORECAST COMPRAS"
	TRB->PA008503    := "7"
	TRB->PA008504    := "3"
	TRB->PA008509 	 := "Projetado"
	TRB->PA008507    := "7-AJUSTES"
	TRB->PA008508    := STRZERO(Year(MV_PAR01),4)
	TRB->SALDO       := SZF->ZF_SALDO
	TRB->VALOR01     := SZF->ZF_JAN
	TRB->VALOR02     := SZF->ZF_FEV
	TRB->VALOR03     := SZF->ZF_MAR
	TRB->VALOR04     := SZF->ZF_ABR
	TRB->VALOR05     := SZF->ZF_MAI
	TRB->VALOR06     := SZF->ZF_JUN
	TRB->VALOR07     := SZF->ZF_JUL
	TRB->VALOR08     := SZF->ZF_AGO
	TRB->VALOR09     := SZF->ZF_SET
	TRB->VALOR10     := SZF->ZF_OUT
	TRB->VALOR11     := SZF->ZF_NOV
	TRB->VALOR12     := SZF->ZF_DEZ
Endif

dbSelectArea("SZF")
dbSetOrder(1)
If dbSeek(xFilial()+STRZERO(Year(MV_PAR01),4)+"D")
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->PA008501    := "FORECAST"
	TRB->PA008502    := "(-)AJUSTES DESPESAS"
	TRB->PA008503    := "7"
	TRB->PA008504    := "4"
	TRB->PA008507    := "7-AJUSTES"
	TRB->PA008508    := STRZERO(Year(MV_PAR01),4)
	TRB->PA008509 	 := "Projetado"
	TRB->SALDO       := SZF->ZF_SALDO
	TRB->VALOR01     := SZF->ZF_JAN
	TRB->VALOR02     := SZF->ZF_FEV
	TRB->VALOR03     := SZF->ZF_MAR
	TRB->VALOR04     := SZF->ZF_ABR
	TRB->VALOR05     := SZF->ZF_MAI
	TRB->VALOR06     := SZF->ZF_JUN
	TRB->VALOR07     := SZF->ZF_JUL
	TRB->VALOR08     := SZF->ZF_AGO
	TRB->VALOR09     := SZF->ZF_SET
	TRB->VALOR10     := SZF->ZF_OUT
	TRB->VALOR11     := SZF->ZF_NOV
	TRB->VALOR12     := SZF->ZF_DEZ
Endif

//AceRodb()

Return


Static Function ACERODA()

_nRec01:= 0

For I:= 1 To 12
	dbSelectArea("TRB")
	If dbseek("0")
		While !EOF()
			_cCampo  := StrZero(i,2)
			If TRB->PA008503 == "0"
				_nValor  := &("TRB->VALOR" + _cCampo)
				_nRec01  := _nValor
			Else
				If PA008503 == "1"  // Receber
					_nValor  := &("TRB->VALOR" + _cCampo)
					_nRec01  += _nValor
				ElseIf PA008503 == "2"  // Pagar
					_nValor  := &("TRB->VALOR" + _cCampo)
					_nRec01  -= _nValor
				ElseIf PA008503 == "3"
					If PA008504 $ "1/3"
						_nValor  := &("TRB->VALOR" + _cCampo)
						_nRec01  += _nValor
					Else
						_nValor  := &("TRB->VALOR" + _cCampo)
						_nRec01  -= _nValor
					Endif
				Endif
			Endif
			
			dbSelectArea("TRB")
			dbSkip()
		EndDo
	Endif
	
	dbSelectArea("TRB")
	dbseek("0")
	
	_cCampo   := StrZero(i+1,2)
	dbSelectArea("TRB")
	RecLock("TRB",.F.)
	_cValor   := "TRB->VALOR" + _cCampo
	&_cValor  := _nRec01
	MsUnlock()
	
	_cCampo   := StrZero(i,2)
	dbSelectArea("TRB")
	If !dbseek("6")
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->PA008503 := "6"
		TRB->PA008507 := "6-SALDO FINAL BANCOS"
		TRB->PA008509 := _cReaPr
		TRB->PA008501 := "RODAPE"
		TRB->PA008502 := "SALDO FINAL DOS BANCOS"
		TRB->PA008508 := STRZERO(Year(MV_PAR01),4)
		If MV_PAR04 == MV_PAR05
			TRB->PA008510    := MV_PAR04 + " - "+Alltrim(_cNomBco)
		Endif
		_cValor   	  := "TRB->VALOR" + _cCampo
		&_cValor      := _nRec01
		Msunlock()
	Else
		RecLock("TRB",.F.)
		_cValor   	  := "TRB->VALOR" + _cCampo
		&_cValor      := _nRec01
	Endif
Next I

Return


Static Function ACERODB()

_nRec01:= 0

For I:= 1 To 13
	dbSelectArea("TRB")
	If dbseek("0")
		While !EOF()
			
			If TRB->PA008503 == "7"
				dbSelectArea("TRB")
				dbSkip()
				Loop
			Endif
			
			A:= I
			_cCampo  := StrZero((A-1),2)
			If TRB->PA008503 == "0" //.and. !TRB->PA008501 $ "PROVFIM   /TPROVINI  "
				If I != 1
					_nValor  := &("TRB->VALOR" + _cCampo)
					_nRec01  := _nValor
				Else
					_nRec01 := TRB->SALDO
				Endif
			Else
				If PA008503 == "1"  // Receber
					If I != 1
						_nValor  := &("TRB->VALOR" + _cCampo)
						_nRec01  += _nValor
					Else
						_nRec01 += TRB->SALDO
					Endif
				ElseIf PA008503 == "2"  // Pagar
					If I != 1
						_nValor  := &("TRB->VALOR" + _cCampo)
						_nRec01  -= _nValor
					Else
						_nRec01 -= TRB->SALDO
					Endif
				ElseIf PA008503 == "3" // Transferencia
					If PA008504 == "1"
						If I != 1
							_nValor  := &("TRB->VALOR" + _cCampo)
							_nRec01  += _nValor
						Else
							_nRec01 += TRB->SALDO
						Endif
					Else
						If I != 1
							_nValor  := &("TRB->VALOR" + _cCampo)
							_nRec01  -= _nValor
						Else
							_nRec01 -= TRB->SALDO
						Endif
					Endif
				Endif
			Endif
			
			dbSelectArea("TRB")
			dbSkip()
		EndDo
	Endif
	
	dbSelectArea("TRB")
	dbseek("0 SALDOINI")
	//	dbseek("0SALDOINI")
	
	_cCampo1  := StrZero(i,2)
	dbSelectArea("TRB")
	RecLock("TRB",.F.)
	_cValor   := "TRB->VALOR" + _cCampo1
	&_cValor  := _nRec01
	MsUnlock()
	
	dbSelectArea("TRB")
	If !dbseek("6"+"2"+"RODAPE    ")
		//	If !dbseek("6"+"RODAPE    "+"2")
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->PA008503 := "6"
		TRB->PA008504 := "2"
		If MV_PAR07 = 2
			TRB->PA008507 := "6-SALDO FINAL BANCOS"
		Else              /// PROJETADO
			TRB->PA008507 := "6-SUBTOTAL BANCOS"
		Endif
		TRB->PA008509 := _cReaPr
		TRB->PA008501 := "RODAPE    "
		If MV_PAR07  = 2
			TRB->PA008502 := "SALDO FINAL DOS BANCOS"
		Else              /// PROJETADO
			TRB->PA008502 := "SUBTOTAL BANCOS"
		Endif
		TRB->PA008508 := STRZERO(Year(MV_PAR01),4)
		If MV_PAR04 == MV_PAR05
			TRB->PA008510    := MV_PAR04 + " - "+Alltrim(_cNomBco)
		Endif
		If I != 1
			_cValor   	  := "TRB->VALOR" + _cCampo
			&_cValor      := _nRec01
		Else
			TRB->SALDO 	  := _nRec01
		Endif
		Msunlock()
	Else
		RecLock("TRB",.F.)
		If I != 1
			_cValor   	  := "TRB->VALOR" + _cCampo
			&_cValor      := _nRec01
		Else
			TRB->SALDO := _nRec01
		Endif
	Endif
Next I

If MV_PAR07 = 3
	
	_nSld   := _nVl01  := _nVl02  := _nVl03  := _nVl04  := _nVl05  := _nVl06  := _nVl07  := 0
	_nVl08  := _nVl09  := _nVl10  := _nVl11  := _nVl12  := 0
	
	dbSelectArea("TRB")
	If dbseek("6")
		_nSld   := TRB->SALDO
		_nVl01  := TRB->VALOR01
		_nVl02  := TRB->VALOR02
		_nVl03  := TRB->VALOR03
		_nVl04  := TRB->VALOR04
		_nVl05  := TRB->VALOR05
		_nVl06  := TRB->VALOR06
		_nVl07  := TRB->VALOR07
		_nVl08  := TRB->VALOR08
		_nVl09  := TRB->VALOR09
		_nVl10  := TRB->VALOR10
		_nVl11  := TRB->VALOR11
		_nVl12  := TRB->VALOR12
	Endif
	
	dbSelectArea("TRB")
	If dbSeek("7")
		
		While !EOF() .And. TRB->PA008503 == "7"
			
			If TRB->PA008504 $ "1/2"
				_nSld   += TRB->SALDO
				_nVl01  += TRB->VALOR01
				_nVl02  += TRB->VALOR02
				_nVl03  += TRB->VALOR03
				_nVl04  += TRB->VALOR04
				_nVl05  += TRB->VALOR05
				_nVl06  += TRB->VALOR06
				_nVl07  += TRB->VALOR07
				_nVl08  += TRB->VALOR08
				_nVl09  += TRB->VALOR09
				_nVl10  += TRB->VALOR10
				_nVl11  += TRB->VALOR11
				_nVl12  += TRB->VALOR12
			ElseIf TRB->PA008504 $ "3/4"
				_nSld   -= TRB->SALDO
				_nVl01  -= TRB->VALOR01
				_nVl02  -= TRB->VALOR02
				_nVl03  -= TRB->VALOR03
				_nVl04  -= TRB->VALOR04
				_nVl05  -= TRB->VALOR05
				_nVl06  -= TRB->VALOR06
				_nVl07  -= TRB->VALOR07
				_nVl08  -= TRB->VALOR08
				_nVl09  -= TRB->VALOR09
				_nVl10  -= TRB->VALOR10
				_nVl11  -= TRB->VALOR11
				_nVl12  -= TRB->VALOR12
			Endif
			
			dbSelectArea("TRB")
			dbSkip()
		EndDo
		
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->PA008501    := "SALDO FINAL"
		TRB->PA008502    := "SALDO FINAL DOS BANCOS"
		TRB->PA008503    := "8"
		TRB->PA008504    := "1"
		TRB->PA008507    := "8-SALDO FINAL DOS BANCOS"
		TRB->PA008508    := STRZERO(Year(MV_PAR01),4)
		TRB->PA008509 	 := "Projetado"
		TRB->SALDO       := _nSld
		TRB->VALOR01     := _nVl01
		TRB->VALOR02     := _nVl02
		TRB->VALOR03     := _nVl03
		TRB->VALOR04     := _nVl04
		TRB->VALOR05     := _nVl05
		TRB->VALOR06     := _nVl06
		TRB->VALOR07     := _nVl07
		TRB->VALOR08     := _nVl08
		TRB->VALOR09     := _nVl09
		TRB->VALOR10     := _nVl10
		TRB->VALOR11     := _nVl11
		TRB->VALOR12     := _nVl12
	Endif
Endif

Return


Static Function SaldoB()

dbSelectArea("SA6")
dbSetOrder(1)
dbSeek(xFilial()+MV_PAR04,.T.)

ProcRegua(RecCount())

_nSdo := 0
While !Eof() .And. SA6->A6_COD <= MV_PAR05
	
	IncProc()
	
	If SA6->A6_FLUXCAI != "S"
		dbSelectArea("SA6")
		dbSkip()
		Loop
	Endif
	
	If SA6->A6_COD < MV_PAR04 .Or. SA6->A6_COD > MV_PAR05
		dbSelectArea("SA6")
		dbSkip()
		Loop
	Endif
	
	IF MV_PAR06 == 1 .And. SA6->A6_TPBANCO != "1"  // 1= CC E 2 == VINCULADA
		dbSelectArea("SA6")
		dbSkip()
		Loop
	Endif
	
	IF MV_PAR06 == 2 .And. SA6->A6_TPBANCO != "2"  // 1= CC E 2 == VINCULADA
		dbSelectArea("SA6")
		dbSkip()
		Loop
	Endif
	
	_cNomBco := SA6->A6_NREDUZ
	dbSelectArea("SA6")
	cBanco   := SA6->A6_COD
	cAgencia := SA6->A6_AGENCIA
	cConta   := SA6->A6_NUMCON
	
	dbSelectArea("SE8")
	dbSetOrder(1)
	dbSeek(xFilial()+cBanco+cAgencia+cConta+dTos(_dDtIni),.T.)
	dbSkip(-1)
	
	If SE8->E8_BANCO != cBanco .Or.;
		SE8->E8_AGENCIA != cAgencia .Or.;
		SE8->E8_CONTA != cConta
		dbSelectArea("SA6")
		dbSkip()
		Loop
	Endif
	
	If MV_PAR08 = 1
		_nSdo += SE8->E8_SALRECO
	Else
		_nSdo += SE8->E8_SALATUA
	Endif
	
	dbSelectArea("SA6")
	dbSkip()
EndDo

dbSelectArea("TRB")
RecLock("TRB",.T.)
TRB->PA008503 := "0"
TRB->PA008503 := "0-SALDO INICIAL BANCOS"
TRB->PA008509 := _cReaPr
TRB->PA008501 := "SALDOINICIAL"
TRB->PA008502 := "SALDO INICIAL BANCOS"
TRB->PA008508 := STRZERO(Year(MV_PAR01),4)
If MV_PAR04 == MV_PAR05
	TRB->PA008510    := MV_PAR04 + " - "+Alltrim(_cNomBco)
Endif
If MV_PAR07 = 1
	TRB->VALOR01 := _nSdo
Else
	TRB->SALDO := _nSdo
Endif
MsUnlock()

Return
