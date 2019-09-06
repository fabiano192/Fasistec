#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPA0019    บ Autor ณ Alexandro da Silva บ Data ณ  19/10/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio de Diferenca de Preco                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Sigafat                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PA0019()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cString
Private aOrd             := {"Produto Pasy","Produto Cliente"}
Private CbTxt            := ""
Private cDesc1             := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2             := "de acordo com os parametros informados pelo usuario."
Private cDesc3             := "Relatorio de diferenca de preco"
Private cPict              := ""
Private lEnd             := .F.
Private lAbortPrint      := .F.
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "PA0019"
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey         := 0
Private cPerg            := "PA0019"
Private titulo             := "Relatorio de diferenca de preco"
Private nLin               := 80

Private Cabec1             := ""
Private Cabec2             := ""
Private cbtxt            := Space(10)
Private cbcont           := 00
Private CONTFL           := 01
Private m_pag            := 01
Private imprime            := .T.
Private wnrel            := "PA0019"

Private cString := "SF2"

dbSelectArea("SF2")
dbSetOrder(1)


//ValidPerg()

pergunte(cPerg,.T.)


If MV_PAR10 == 1
	Tamanho := "G"
Else
	Tamanho := ""
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP5 IDE            บ Data ณ  19/10/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)


////////// GRUPO DE PERGUNTAS ///////////
////// MV_PAR01 : Cliente De         ////
////// MV_PAR02 : Cliente Ate        ////
////// MV_PAR03 : Loja    De         ////
////// MV_PAR04 : Loja    Ate        ////
////// MV_PAR05 : Emissao De         ////
////// MV_PAR06 : Emissao Ate        ////
////// MV_PAR07 : Produto De         ////
////// MV_PAR08 : Produto Ate        ////
////// MV_PAR09 : Indice de Reajuste ////
////// MV_PAR10 : Analit / Sintetico ////
////// MV_PAR11 : Data de Vigencia   ////
/////                                ////
/////////////////////////////////////////


Local nOrdem
nOrdem := aReturn[8]

If MV_PAR10 == 1 // Analitico
	
	If nOrdem == 1 // Ordem Produto Pasy
		/*
		Produto Pasy    Produto Cliente Emissao  N.Fisc           Qtde    Prc.Uni Ant.    Prc.Uni Atu.        Dif.Unit      Dif. Total  Aliq.IPI       Total IPI     Valor Total
		999999999999999 999999999999999 99999999 999999 99999999999999  99999999999999  99999999999999  99999999999999  99999999999999  99999999  99999999999999  99999999999999
		0               16              32       41     48              64              79              95              112             128       138             154
		*/
		_cOrdem := "INDSD21"
		cabec1  := "Produto Pasy    Produto Cliente Emissao  N.Fisc           Qtde    Prc.Uni Ant.    Prc.Uni Atu.        Dif.Unit      Dif. Total  Aliq.IPI       Total IPI     Valor Total"
	Else   // Ordem Produto Cliente
		/*                                       19
		Produto Cliente Produto  Pasy   Emissao  N.Fisc           Qtde    Prc.Uni Ant.    Prc.Uni Atu.        Dif.Unit      Dif. Total  Aliq.IPI       Total IPI     Valor Total
		999999999999999 999999999999999 99999999 999999 99999999999999  99999999999999  99999999999999  99999999999999  99999999999999  99999999  99999999999999  99999999999999
		0               16              32       41     48              64              79              95              112             128       138             154
		*/
		_cOrdem := "INDSD22"
		cabec1  := "Produto Cliente Produto  Pasy   Emissao  N.Fisc           Qtde    Prc.Uni Ant.    Prc.Uni Atu.        Dif.Unit      Dif. Total  Aliq.IPI       Total IPI     Valor Total"
	Endif
	
	_nTotGeral := 0
	_nTotDif  := 0
	_nTotIPI  := 0
	_nTotProd := 0
	
	dbSelectArea("SD2")
	dbOrderNickName(_cOrdem)
	dbSeek(xFilial("SD2")+MV_PAR01,.T.)
	
	While !Eof() .And. SD2->D2_CLIENTE <= MV_PAR02
		
		_lAchou := .F.
		_nTotCli := 0
		_cChavSD2 := SD2->D2_PROCLI
		
		SetRegua(RecCount())
		
		While !Eof() .And. _cChavSD2 == SD2->D2_PROCLI
			
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			
			IncRegua()
			
			If  SD2->D2_LOJA     < MV_PAR03 .Or. SD2->D2_LOJA    > MV_PAR04 .Or.;
				SD2->D2_EMISSAO  < MV_PAR05 .Or. SD2->D2_EMISSAO > MV_PAR06 .Or.;
				SD2->D2_COD      < MV_PAR07 .OR. SD2->D2_COD     > MV_PAR08
				dbSelectArea("SD2")
				dbSkip()
				Loop
			Endif
			
			If SD2->D2_TIPO != "N"
				dbSelectArea("SD2")
				dbSkip()
				Loop
			Endif
			
			If SD2->D2_QTDEDEV == SD2->D2_QUANT
				dbSelectArea("SD2")
				dbSkip()
				Loop
			Endif
			
			dbSelectarea("SF4")
			dbSetOrder(1)
			If dbSeek(xFilial("SF4")+SD2->D2_TES)
				If SF4->F4_DUPLIC != "S" .Or. SF4->F4_TPNFISC == "S" .Or. SF4->F4_ESTOQUE != "S"
					dbSelectArea("SD2")
					dbSkip()
					Loop
				Endif
			Endif
			
			If !Empty(MV_PAR11)
				_dDtRef := Ctod("")
				dbSelectArea("SZ2")
				dbSetOrder(3)
				If dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_PROCLI+SD2->D2_COD+"1")
					
					_dDtRef  := SZ2->Z2_DTREF01
					nValor   := SZ2->Z2_PRECO01
					For i := 2 to 12
						If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= _dDtRef
							_dDtRef  := &("SZ2->Z2_DTREF"+StrZero(i,2))
							nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
						Endif
					Next i
				Endif
				
				If _dDtRef != MV_PAR11
					dbSelectArea("SD2")
					dbSkip()
					Loop
				Endif
				
			Endif
			_lAchou := .T.
			dbSelectarea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+SD2->D2_COD)
			
			If nLin > 58
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				@8 ,00  PSAY "Periodo de "+DTOC(MV_PAR05)+" Ate "+ DTOC(MV_PAR06)
				nLin := 10
			Endif
			
			_PRCVEN   := ROUND(SD2->D2_PRCVEN,2)
			_nPrcUnit := _PRCVEN + Round((_PRCVEN * (MV_PAR09/100)),2)
			_nDif     := _nPrcUnit - _PRCVEN
			@nLin,00  PSAY IIF (nOrdem == 1,SD2->D2_COD,SD2->D2_PROCLI)
			@nLin,16  PSAY IIF (nOrdem == 1,SD2->D2_PROCLI,SD2->D2_COD)
			@nLin,32  PSAY SD2->D2_EMISSAO
			@nLin,41  PSAY SD2->D2_DOC
			@nLin,48  PSAY SD2->D2_QUANT                   PICTURE "@E 9,999,999.99"
			@nLin,64  PSAY _PRCVEN                         PICTURE "@E 9,999,999.99"
			@nLin,79  PSAY _nPrcUnit                       PICTURE "@E 9,999,999.99"
			@nLin,95  PSAY _nDif                           PICTURE "@E 9,999,999.99"
			_nDifTot      := Round((_nDif * SD2->D2_QUANT),2)
			@nLin,112 PSAY _nDifTot                        PICTURE "@E 9,999,999.99"
			@nLin,128 PSAY SD2->D2_IPI                     PICTURE "@E 99999999"
			_nValIPI      := Round((_nDifTot * (SD2->D2_IPI/100)),2)
			@nLin,138 PSAY _nValIPI                        PICTURE "@E 9,999,999.99"
			@nLin,154 PSAY _nDifTot + _nValIPI             PICTURE "@E 999,999,999.99"
			
			nLin++
			
			_nTotDif  +=  _nDifTot
			_nTotIPI  +=  _nValIPI
			_nTotProd += _nDifTot + _nValIPI
			
			dbSelectArea("SD2")
			dbSkip()
		EndDo
		
		If _lAchou
			If nLin > 58
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				@8 ,00  PSAY "Periodo de "+DTOC(MV_PAR05)+" Ate "+ DTOC(MV_PAR06)
				nLin := 10
			Endif
			
			//         _nTotGeral += _nTotProd
		Endif
	EndDo
	
	nLin+=2
	@nLin,00  PSAY "Total  Geral ---------> "
	@nLin,112 PSAY _nTotDif    PICTURE "@E 9,999,999.99"
	@nLin,138 PSAY _nTotIPI    PICTURE "@E 9,999,999.99"
	@nLin,154 PSAY _nTotProd   PICTURE "@E 999,999,999.99"
	
ElseIf MV_PAR10 == 2 // Sintetico por Produto
	If nOrdem == 1 // Ordem Produto Pasy Sint้tico
		
		/*                                       19
		Produto Pasy    Produto Cliente Descricao                Diferen็a    Valor do IPI       Valor Total
		999999999999999 999999999999999 9999999999999999999 99999999999999  99999999999999  99999999999999
		0               17              32                  52              68              84
		*/
		_cOrdem := "INDSD21"
		cabec1  := "Produto Pasy    Produto Cliente Descricao                Diferen็a    Valor do IPI       Valor Total"
	Else   // Ordem Produto Cliente
		
		/*                                       19
		Produto Cliente Produto Pasy    Descricao           Diferen็a         Valor do IPI       Valor Total
		999999999999999 999999999999999 9999999999999999999 99999999999999  99999999999999    99999999999999
		0               17              32                  52              68                86
		*/
		_cOrdem := "INDSD22"
		cabec1  := "Produto Cliente Produto Pasy    Descricao           Diferen็a         Valor do IPI       Valor Total"
	Endif
	
	_nTotDif   := 0
	_nTotIPI   := 0
	_nTotGeral := 0
	
	dbSelectArea("SD2")
	dbOrderNickName(_cOrdem)
	dbSeek(xFilial("SD2")+MV_PAR01,.T.)
	
	While !Eof() .And. SD2->D2_CLIENTE <= MV_PAR02
		
		_cChavSD2 := SD2->D2_PROCLI
		_lAchou := .F.
		
		dbSelectarea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SD2->D2_COD)
		
		_nDifTot:= 0
		_nDifProd := 0
		_nIPIProd := 0
		
		dbSelectArea("SD2")
		SetRegua(RecCount())
		
		While !Eof() .And. _cChavSD2 == SD2->D2_PROCLI
			
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			
			IncRegua()
			
			If  SD2->D2_LOJA   < MV_PAR03 .Or. SD2->D2_LOJA    > MV_PAR04 .Or.;
				SD2->D2_EMISSAO < MV_PAR05 .Or. SD2->D2_EMISSAO > MV_PAR06 .Or.;
				SD2->D2_COD    < MV_PAR07 .OR. SD2->D2_COD     > MV_PAR08
				dbSelectArea("SD2")
				dbSkip()
				Loop
			Endif
			
			If SD2->D2_QTDEDEV == SD2->D2_QUANT
				dbSelectArea("SD2")
				dbSkip()
				Loop
			Endif
			
			dbSelectarea("SF4")
			dbSetOrder(1)
			If dbSeek(xFilial("SF4")+SD2->D2_TES)
				If SF4->F4_DUPLIC != "S" .Or. SF4->F4_TPNFISC == "S" .Or. SF4->F4_ESTOQUE != "S"
					dbSelectArea("SD2")
					dbSkip()
					Loop
				Endif
			Endif
			
			If !Empty(MV_PAR11)
				_dDtRef := Ctod("")
				dbSelectArea("SZ2")
				dbSetOrder(3)
				If dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_PROCLI+SD2->D2_COD+"1")
					
					_dDtRef  := SZ2->Z2_DTREF01
					nValor   := SZ2->Z2_PRECO01
					For i := 2 to 12
						If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= _dDtRef
							_dDtRef  := &("SZ2->Z2_DTREF"+StrZero(i,2))
							nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
						Endif
					Next i
				Endif
				
				If _dDtRef != MV_PAR11
					dbSelectArea("SD2")
					dbSkip()
					Loop
				Endif
				
			Endif
			_lAchou := .T.
			_cCodPasy := SD2->D2_COD
			_cCodCli  := SD2->D2_PROCLI
			
			_PRCVEN   := ROUND(SD2->D2_PRCVEN,2)
			_nPrcUnit := _PRCVEN + Round((_PRCVEN * (MV_PAR09/100)),2)
			_nDif     := _nPrcUnit - _PRCVEN
			_nDifTot  := Round((_nDif * SD2->D2_QUANT),2)
			_nValIPI  := Round((_nDifTot * (SD2->D2_IPI/100)),2)
			
			_nDifProd += _nDifTot
			_nIPIProd += _nValIPI
			
			dbSelectArea("SD2")
			dbSkip()
		EndDo
		
		If _lAchou
			If nLin > 58
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				@8 ,00  PSAY "Periodo de "+DTOC(MV_PAR05)+" Ate "+ DTOC(MV_PAR06)
				nLin := 10
			Endif
			
			nLin := nLin + 1 // Avanca a linha de impressao
			
			@nLin,00  PSAY IIF (nOrdem == 1,_cCodPasy,_cCodCli)
			@nLin,17  PSAY IIF (nOrdem == 1,_cCodCli,_cCodPasy)
			@nLin,32  PSAY SUBSTR(SB1->B1_DESC,1,19)
			@nLin,52  PSAY _nDifProd              PICTURE "@E 999,999,999.99"
			@nLin,68  PSAY _nIPIProd              PICTURE "@E 999,999,999.99"
			@nLin,84  PSAY _nDifProd + _nIPIProd  PICTURE "@E 999,999,999.99"
			
			_nTotDif   += _nDifProd
			_nTotIPI   += _nIPIProd
			_nTotGeral += _nDifProd + _nIPIProd
			
		Endif
	EndDo
	
	nLin+=2
	@nLin,00  PSAY "Total  Geral ---------> "
	@nLin,52  PSAY _nTotDif    PICTURE "@E 999,999,999.99"
	@nLin,68  PSAY _nTotIPI    PICTURE "@E 999,999,999.99"
	@nLin,84  PSAY _nTotGeral  PICTURE "@E 999,999,999.99"
	
Else    // sintetico por Aliquota IPI
	
	/*
	Descri็ใo da Aliquota        Diferen็a Aliquota    Valor do IPI     Valor Total
	999999999999999999999  999999999999999 99999999  99999999999999  99999999999999
	0                      23              39        49              65
	*/
	
	cabec1  := "Descri็ใo da Aliquota        Diferen็a Aliquota    Valor do IPI     Valor Total"
	aStru := {}
	AADD(aStru,{"DESCRI",   "C" ,21, 0 })
	AADD(aStru,{"PRODCLI",  "C" ,15, 0 })
	AADD(aStru,{"DIFTOT",   "N" ,12, 2 })
	AADD(aStru,{"ALIQIPI",  "C" , 2, 0 })
	AADD(aStru,{"VLIPI",    "N" ,12, 2 })
	AADD(aStru,{"VLTOTAL",  "N" ,14, 2 })
	
	cArqTRB := CriaTrab(aStru,.T.)
	cIndTRB := "ALIQIPI"
	dbUseArea(.T.,,cArqTRB,"TRB",.F.,.F.)
	dbSelectArea("TRB")
	IndRegua("TRB",cArqTRB,cIndTRB,,,"Criando Trabalho...")
	
	_cOrdem := "INDSD21"
	
	
	_nTotGeral := 0
	
	dbSelectArea("SD2")
	dbOrderNickName(_cOrdem)
	dbSeek(xFilial("SD2")+MV_PAR01,.T.)
	
	While !Eof() .And. SD2->D2_CLIENTE <= MV_PAR02
		
		If  SD2->D2_LOJA    < MV_PAR03 .Or. SD2->D2_LOJA    > MV_PAR04 .Or.;
			SD2->D2_EMISSAO < MV_PAR05 .Or. SD2->D2_EMISSAO > MV_PAR06 .Or.;
			SD2->D2_COD     < MV_PAR07 .OR. SD2->D2_COD     > MV_PAR08
			dbSelectArea("SD2")
			dbSkip()
			Loop
		Endif
		
		If SD2->D2_QTDEDEV == SD2->D2_QUANT
			dbSelectArea("SD2")
			dbSkip()
			Loop
		Endif
		
		dbSelectarea("SF4")
		dbSetOrder(1)
		If dbSeek(xFilial("SF4")+SD2->D2_TES)
			If SF4->F4_DUPLIC != "S" .Or. SF4->F4_TPNFISC == "S" .Or. SF4->F4_ESTOQUE != "S"
				dbSelectArea("SD2")
				dbSkip()
				Loop
			Endif
		Endif
		
		If !Empty(MV_PAR11)
			_dDtRef := Ctod("")
			dbSelectArea("SZ2")
			dbSetOrder(3)
			If dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_PROCLI+SD2->D2_COD+"1")
				
				_dDtRef  := SZ2->Z2_DTREF01
				nValor   := SZ2->Z2_PRECO01
				For i := 2 to 12
					If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= _dDtRef
						_dDtRef  := &("SZ2->Z2_DTREF"+StrZero(i,2))
						nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
					Endif
				Next i
			Endif
			
			If _dDtRef != MV_PAR11
				dbSelectArea("SD2")
				dbSkip()
				Loop
			Endif
		Endif
		
		dbSelectarea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SD2->D2_COD)
		
		_PRCVEN   := ROUND(SD2->D2_PRCVEN,2)
		_nPrcUnit := _PRCVEN + Round((_PRCVEN * (MV_PAR09/100)),2)
		_nDif     := _nPrcUnit - _PRCVEN
		_nDifTot      := Round((_nDif * SD2->D2_QUANT),2)
		_nValIPI      := Round((_nDifTot * (SD2->D2_IPI/100)),2)
				
		dbSelectArea("TRB")
		If dbSeek(STRZERO(SD2->D2_IPI,2))
			RecLock("TRB",.F.)
		Else
			RecLock("TRB",.T.)
			TRB->DESCRI  := "Aliquota de "+ Alltrim(STRZERO(SD2->D2_IPI,2))+" % "
			TRB->ALIQIPI := STRZERO(SD2->D2_IPI,2)
		Endif
		TRB->DIFTOT  += _nDifTot
		TRB->VLIPI   += _nValIPI
		TRB->VLTOTAL += _nDifTot + _nValIPI
		MsUnLock()
		
		dbSelectArea("SD2")
		dbSkip()
	EndDo
	
	_nValDif   := 0
	_nValIPI   := 0
	_nValTotal := 0
	
	dbSelectArea("TRB")
	dbGotop()
	
	SetRegua(RecCount())
	
	While !Eof()
		
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		IncRegua()
		
		If nLin > 58
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,"P",nTipo)
			@8 ,00  PSAY "Periodo de "+DTOC(MV_PAR05)+" Ate "+ DTOC(MV_PAR06)
			nLin := 10
		Endif
		
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,00  PSAY TRB->DESCRI
		@nLin,023 PSAY TRB->DIFTOT          PICTURE "@E 999,999,999.99"
		@nLin,039 PSAY TRB->ALIQIPI
		_nIPI :=   Round((TRB->DIFTOT * (Val(TRB->ALIQIPI)/100)),2)
		@nLin,049 PSAY _nIPI                PICTURE "@E 999,999,999.99"
		@nLin,065 PSAY TRB->DIFTOT + _nIPI PICTURE "@E 999,999,999.99"
		
		_nValDif+=   TRB->DIFTOT
		_nValIPI+=   _nIPI
		_nValTotal+= TRB->DIFTOT + _nIPI
		
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	nLin+=2
	@nLin,00  PSAY "Total Geral ------> "
	@nLin,23  PSAY _nValDif    PICTURE "@E 999,999,999.99"
	@nLin,49  PSAY _nValIPI    PICTURE "@E 999,999,999.99"
	@nLin,65  PSAY _nValTotal  PICTURE "@E 999,999,999.99"
	
	dbSelectArea("TRB")
	dbCloseArea()
	Ferase(cArqTrb+".DBF")    // Elimina arquivos de Trabalho
	Ferase(cArqTrb+OrdBagExt())	  // Elimina arquivos de Trabalho
	
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
