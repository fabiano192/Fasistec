#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Pa0065    º Autor ³ Alexandro da Silva º Data ³  14/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programacao de Entrega CNH                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0065()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private _nPula,_lPrim3,_lPrim4,_cItem3,_cItem4,_lAchou,_nPrcVen,_cNum3,_cNum4,_lVerFat
Private _nTotQt := 0
Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := "Programacao de Entrega CNH.    "
Private cPict          := ""
Private titulo         := "Programacao de Entrega Periodo:"
Private nLin           := 80

Private Cabec1         := ""
Private Cabec2         := ""
Private imprime        := .T.
Private aOrd           := {}
Private lEnd           := .F.
Private lAbortPrint    := .F.
Private CbTxt          := ""
Private limite         := 132
Private tamanho        := "M"
Private nomeprog       := "PA0065"
Private nTipo          := 18
Private aReturn        := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey       := 0
Private cPerg          := "PA0065"
Private cbtxt          := Space(10)
Private cbcont         := 00
Private CONTFL         := 01
Private m_pag          := 01
Private wnrel          := "PA0065"
Private cString 	   := "SZ4"

dbSelectArea("SZ4")
dbSetOrder(1)


pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

If aReturn[4]==1
	nTipo := 15
	_nPula := 72
Else
	nTipo := 18
	_nPula := 57
Endif

Private _lNAchou   := .F.
Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| VerMov(@_lFim) }
Private _cTitulo01 := 'Imprimindo Inconsistencia'
RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

If !_lNAchou
	_bAcao01   := {|_lFim| ElimR(@_lFim) }
	_cTitulo01 := 'Eliminando Residuo!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
	_bAcao01   := {|_lFim| INTNOV(@_lFim) }
	_cTitulo01 := 'Integrando Pedido!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
	_bAcao01   := {|_lFim| Imp1(@_lFim) }
	_cTitulo01 := 'Imprimindo'
	RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
Endif


Return


Static Function VerMov()

_lNAchou := .F.

dbSelectArea("SZ4")
dbSetOrder(4)
dbSeek(xFilial("SZ4")+DTOS(MV_PAR01),.t.)

ProcRegua(RecCount())

While !Eof() .And. SZ4->Z4_DTDIGIT <= MV_PAR02
	
	IncProc()

	If SZ4->Z4_CODCLI != "000071"
		dbSelectArea("SZ4")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SZ2")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ2")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA+SZ4->Z4_PRODPAS+SZ4->Z4_PRODCLI)
		dbSelectArea("SZ4")
		dbSkip()
		Loop
	Endif
	
	If nLin > _nPula
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	_lNAchou := .T.
	@nLin,00  PSAY "Produto CLIENTE NAO CADASTRADO "+SZ4->Z4_PRODCLI
	nLin++
	
	dbSelectArea("SZ4")
	dbSkip()
EndDo

If _lNAchou
	dbSelectArea("SZ4")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SET DEVICE TO SCREEN
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
Endif

Return


Static Function ELIMR(_lFim)

dbSelectArea("SC6")
dbSEtOrder(5)
If dbSeek(xFilial("SC6")+"000071")
	
	_cChavSC6 := SC6->C6_CLI //+ SC6->C6_LOJA
	
	ProcRegua(LastRec())
	
	While !Eof() .And. _cChavSC6 == SC6->C6_CLI //+ SC6->C6_LOJA
		
		IncProc()
		
		If !Empty(SC6->C6_BLQ)
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		If Empty(SC6->C6_IDENCAT)
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		If SC6->C6_PEDAMOS $ "A/D"
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SC6->C6_PRODUTO)
		
		If SB1->B1_TIPO == "FR"
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SC6")
		RecLock("SC6",.F.)
		SC6->C6_BLQ     := "R"
		SC6->C6_XDTELIM := dDataBase
		SC6->C6_IDENCAT := "PA0065"
		MsUnLock()
		
		dbSelectArea("SC6")
		dbSkip()
	EndDo
Endif

Return

Static Function INTNOV(_lFim)

dbSelectArea("SD2")
dbSEtOrder(9)
If dbSeek(xFilial("SD2")+"000071")
	
	_cChavSD2 := SD2->D2_CLIENTE
	
	ProcRegua(LastRec())
	
	While !Eof() .And. _cChavSD2 == SD2->D2_CLIENTE
		
		IncProc()
		
		dbSelectArea("SD2")
		RecLock("SD2",.F.)
		SD2->D2_PROGENT := 0
		MsUnLock()
		
		dbSelectArea("SD2")
		dbSkip()
	EndDo
Endif

Return


Static Function Imp1(_lFim)

Private titulo         := "Programacao de Entrega CNH Periodo: "+DTOC(MV_PAR01) + " Ate "+DTOC(MV_PAR02)

///////////////////////////////////////////////
///////////////////////////////////////////////
////// MV_PAR01    :  Data da Entrada   De  ///
////// MV_PAR02    :  Data da Entrada   Ate ///
////// MV_PAR03    :  Data do Movimento De  ///
////// MV_PAR04    :  Data do Movimento Ate ///
///////////////////////////////////////////////


/*
Data Mov Cliente  Lj Prod.Cliente    Prod.Pasy       Controle Dest Tp  Dt.Ult.Nf  Ult.NF.  Entrega   Quantidade    Pedido  Alt.Tec.
99999999 99999999 99 999999999999999 999999999999999 99999999 9999 99  999999999  9999999  99999999  999999999999  999999  99999999
0        9        18 21              37              53       62   67  71         82       91        101           115     123
*/
cabec1:= "Data Mov Cliente  Lj Prod.Cliente    Prod.Pasy       Controle Dest Tp  Dt.Ult.Nf  Ult.NF.  Entrega   Quantidade    Pedido  Alt.Tec."
Cabec2:= ""


dbSelectArea("SZ4")
dbSetOrder(4)
dbSeek(xFilial("SZ4")+DTOS(MV_PAR01),.t.)

SetRegua(RecCount())

While !Eof() .And. SZ4->Z4_DTDIGIT <= MV_PAR02
	
	_lPrim3    := .F.
	_lPrim4    := .F.	
	_nTotQt    := 0
	_cItem3    := "00"
	_cItem4    := "00"
	_cClieLoja := SZ4->Z4_CODCLI + SZ4->Z4_LOJA
	
	dbSelectArea("SZ4")
	
	While !Eof() .And.	_cClieLoja == SZ4->Z4_CODCLI + SZ4->Z4_LOJA
			
		If SZ4->Z4_DTMOV  < MV_PAR03 .Or. SZ4->Z4_DTMOV  > MV_PAR04 .Or.;
			SZ4->Z4_CODCLI != "000071"
			dbSelectArea("SZ4")
			dbSkip()
			Loop
		Endif
		
		IncRegua()
		
		_cProdCli := SZ4->Z4_PRODCLI
		_nSubQt   := 0
		
		dbSelectArea("SZ2")
		dbSetOrder(1)
		If !dbSeek(xFilial("SZ2")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA+SZ4->Z4_PRODPAS+SZ4->Z4_PRODCLI)
			Alert("Produto Nao cadastrado no Cadastro Produto X Cliente  "+SZ4->Z4_PRODCLI)
			Return
		Endif
		
		dDataRef := SZ2->Z2_DTREF01
		nValor   := SZ2->Z2_PRECO01
		For i := 2 to 12
			If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= dDataRef
				dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
				nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
			Endif
		Next i
		
		_nPrcVen := nValor
		If nLin > _nPula
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		@nLin,00  PSAY "Produdo Cliente "+SZ4->Z4_PRODCLI
		
		nLin+=2
		
		dbSelectArea("SZ4")
		_lVerFat := .t.
		
		While !Eof() .And. _cProdCli == SZ4->Z4_PRODCLI
			
			If _lFim
				Alert("Cancelado Pelo Usuario!!!!!!")
				Return
			Endif
			
			IncRegua()
					
			If SZ4->Z4_DTMOV < MV_PAR03 .Or. SZ4->Z4_DTMOV > MV_PAR04
				dbSelectArea("SZ4")
				dbSkip()
				Loop
			Endif
			
			If nLin > _nPula
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			If SZ4->Z4_IMPRES == "3"
				INTSC63()
			Else
			    INTSC64()
			Endif
			
			dbSelectArea("SZ4")
			RecLock("SZ4",.F.)
			SZ4->Z4_INTEGR := "S"
			MsUnlock()
			
			@nLin,00  PSAY SZ4->Z4_DTMOV
			@nLin,09  PSAY SZ4->Z4_CODCLI
			@nLin,18  PSAY SZ4->Z4_LOJA
			@nLin,21  PSAY SZ4->Z4_PRODCLI
			@nLin,37  PSAY SZ4->Z4_PRODPAS
			@nLin,53  PSAY SZ4->Z4_CONTROL
			@nLin,62  PSAY SZ4->Z4_LOCDEST
			@nLin,67  PSAY SZ4->Z4_TIPO
			@nLin,71  PSAY SZ4->Z4_DTULTNF
			@nLin,82  PSAY SZ4->Z4_ULTNF
			@nLin,91  PSAY SZ4->Z4_DTENT
			@nLin,101 PSAY SZ4->Z4_QTENT                    Picture Tm(SZ4->Z4_QTENT,12)
			@nLin,115 PSAY Substr(SZ4->Z4_PEDIDO,1,6)
			//			@nLin,123 PSAY SZ4->Z4_ALTTEC
			If SZ4->Z4_TPPED $ "N"
				_cTipo := "FIRME"
			ElseIf SZ4->Z4_TPPED == "Z"
				_cTipo := "PREVISAO"
			Else
				_cTipo := "VERIFICAR"
			Endif
			
			@nLin,123 PSAY _cTipo
			
			_nSubQt += SZ4->Z4_QTENT
			
			nLin++
			
			dbSelectArea("SZ4")
			dbSkip()
		EndDo
		
		nLin+=2
		
		If nLin > _nPula
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		@nLin,00  PSAY "TotaL Do Produto "+_cProdCli
		@nLin,101 PSAY _nSubQt                    Picture Tm(_nSubQt,12)
		
		_nTotQt += _nSubQt
		
		nLin+=2
		
		dbSelectArea("SZ4")
	EndDo
EndDo

nLin+=2

If nLin > _nPula
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

@nLin,53  PSAY "TotaL Geral "
@nLin,101 PSAY _nTotQt                    Picture Tm(_nTotQt,12)

dbSelectArea("SZ4")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Static Function IntSC63()

_nFatur := 0

If VAL(SZ4->Z4_ULTNF) > 0
	
	dbSelectArea("SD2")
	dbOrderNickName("INDSD26")
	dbSeek(xFilial("SD2")+ SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + SZ4->Z4_ULTNF+"01",.T.)
	
	_cChav  := SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS
	
	While !Eof () .And. _cChav == SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD
		
		If SD2->D2_DOC <= SZ4->Z4_ULTNF
			dbSelectArea("SD2")
			dbSkip()
			Loop
		Endif
		
		If SD2->D2_QUANT == SD2->D2_PROGENT
			dbSelectArea("SD2")
			dbSkip()
			Loop
		Endif
		
		_nFatur2 := _nFatur
		_nFatur += SD2->D2_QUANT - SD2->D2_PROGENT
		
		If _nFatur >= SZ4->Z4_QTENT
			_nDif := SZ4->Z4_QTENT - _nFatur2
		Else
			_nDif := SD2->D2_QUANT - SD2->D2_PROGENT
		Endif
		
		dbSelectArea("SD2")
		RecLock("SD2",.F.)
		SD2->D2_PROGENT += _nDif
		MsUnlock()
		
		If _nFatur >= SZ4->Z4_QTENT
			Return
		Endif
		
		dbSelectArea("SD2")
		dbSkip()
	EndDo
Endif

_lVerFat := .F.
_cItem3   := SomaIt(_cItem3)

If !_lPrim3
	_cNum3  := GETSXENUM("SC5","C5_NUM")
	CONFIRMSX8()
	_lPrim3 := .T.
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA)
	
	dbSelectArea("SC5")
	RecLock("SC5",.T.)
	SC5->C5_FILIAL  := xFilial("SC5")
	SC5->C5_NUM     := _cNum3
	SC5->C5_TIPO    := "N"
	SC5->C5_CLIENTE := SZ4->Z4_CODCLI
	SC5->C5_LOJAENT := SZ4->Z4_LOJA
	SC5->C5_LOJACLI := SZ4->Z4_LOJA
	SC5->C5_TRANSP  := SA1->A1_TRANSP
	SC5->C5_TIPOCLI := SA1->A1_TIPO
	SC5->C5_CONDPAG := SA1->A1_COND
	SC5->C5_TIPLIB  := "1"
	SC5->C5_VEND1   := SA1->A1_VEND
	SC5->C5_COMIS1  := SA1->A1_COMIS
	SC5->C5_EMISSAO := dDataBase
	SC5->C5_PESOL   := 1
	SC5->C5_MOEDA   := 1
	SC5->C5_TXMOEDA := 1
	SC5->C5_TPCARGA := "2"
	SC5->C5_MENNOTA := "REFERENTE A PLANTA I3"
	MsUnlock()
Endif

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+SZ4->Z4_PRODPAS)

dbSelectArea("SF4")
dbSetOrder(1)
dbSeek(xFilial("SF4")+SZ2->Z2_TES)

dbSelectArea("SC6")
RecLock("SC6",.T.)
SC6->C6_FILIAL  := xFilial("SC6")
SC6->C6_NUM     := _cNUm3
SC6->C6_ITEM    := _cItem3
SC6->C6_CPROCLI := SZ4->Z4_PRODCLI
SC6->C6_PRODUTO := SZ4->Z4_PRODPAS
SC6->C6_REVPED  := SZ4->Z4_ALTTEC
SC6->C6_QTDVEN  := SZ4->Z4_QTENT - _nFatur
SC6->C6_PRCVEN  := _nPrcVen
SC6->C6_VALOR   := Round(( (SZ4->Z4_QTENT - _nFatur) * _nPrcVen ),2)
SC6->C6_ENTREG  := SZ4->Z4_DTENT
SC6->C6_PEDAMOS := SZ4->Z4_TPPED
SC6->C6_TES     := SZ2->Z2_TES
If SA1->A1_EST == "SP"
	_cCf         := "5"
ElseIf SA1->A1_EST == "EX"
	_cCf         := "7"
Else
	_cCF         := "6"
Endif
SC6->C6_CF      := _cCf + Substr(SF4->F4_CF,2,3)
SC6->C6_UM      := SB1->B1_UM
SC6->C6_PEDCLI  := SZ4->Z4_PEDIDO
SC6->C6_DESCRI  := SB1->B1_DESC
SC6->C6_LOCAL   := SB1->B1_LOCPAD
SC6->C6_CLI     := SZ4->Z4_CODCLI
SC6->C6_LOJA    := SZ4->Z4_LOJA
SC6->C6_PRUNIT  := _nPrcVen
SC6->C6_TPOP    := "F"
MsUnlock()

dbSelectArea("SZ4")

Return


Static Function IntSC64()

_nFatur := 0

If VAL(SZ4->Z4_ULTNF) > 0
	
	dbSelectArea("SD2")
	dbOrderNickName("INDSD26")
	dbSeek(xFilial("SD2")+ SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + SZ4->Z4_ULTNF+ "01",.T.)
	
	_cChav  := SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS
	
	While !Eof () .And. _cChav == SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD
		
		If SD2->D2_DOC <= SZ4->Z4_ULTNF
			dbSelectArea("SD2")
			dbSkip()
			Loop
		Endif
		
		If SD2->D2_QUANT == SD2->D2_PROGENT
			dbSelectArea("SD2")
			dbSkip()
			Loop
		Endif
		
		_nFatur2 := _nFatur
		_nFatur += SD2->D2_QUANT - SD2->D2_PROGENT
		
		If _nFatur >= SZ4->Z4_QTENT
			_nDif := SZ4->Z4_QTENT - _nFatur2
		Else
			_nDif := SD2->D2_QUANT - SD2->D2_PROGENT
		Endif
		
		dbSelectArea("SD2")
		RecLock("SD2",.F.)
		SD2->D2_PROGENT += _nDif
		MsUnlock()
		
		If _nFatur >= SZ4->Z4_QTENT
			Return
		Endif
		
		dbSelectArea("SD2")
		dbSkip()
	EndDo
Endif

_lVerFat := .F.
_cItem4   := SomaIt(_cItem4)

If !_lPrim4
	_cNum4  := GETSXENUM("SC5","C5_NUM")
	CONFIRMSX8()
	_lPrim4 := .T.
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA)
	
	dbSelectArea("SC5")
	RecLock("SC5",.T.)
	SC5->C5_FILIAL  := xFilial("SC5")
	SC5->C5_NUM     := _cNum4
	SC5->C5_TIPO    := "N"
	SC5->C5_CLIENTE := SZ4->Z4_CODCLI
	SC5->C5_LOJAENT := SZ4->Z4_LOJA
	SC5->C5_LOJACLI := SZ4->Z4_LOJA
	SC5->C5_TRANSP  := SA1->A1_TRANSP
	SC5->C5_TIPOCLI := SA1->A1_TIPO
	SC5->C5_CONDPAG := SA1->A1_COND
	SC5->C5_TIPLIB  := "1"
	SC5->C5_VEND1   := SA1->A1_VEND
	SC5->C5_COMIS1  := SA1->A1_COMIS
	SC5->C5_EMISSAO := dDataBase
	SC5->C5_PESOL   := 1
	SC5->C5_MOEDA   := 1
	SC5->C5_TXMOEDA := 1
	SC5->C5_TPCARGA := "2"
	MsUnlock()
Endif

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+SZ4->Z4_PRODPAS)

dbSelectArea("SF4")
dbSetOrder(1)
dbSeek(xFilial("SF4")+SZ2->Z2_TES)

dbSelectArea("SC6")
RecLock("SC6",.T.)
SC6->C6_FILIAL  := xFilial("SC6")
SC6->C6_NUM     := _cNUm4
SC6->C6_ITEM    := _cItem4
SC6->C6_CPROCLI := SZ4->Z4_PRODCLI
SC6->C6_PRODUTO := SZ4->Z4_PRODPAS
SC6->C6_REVPED  := SZ4->Z4_ALTTEC
SC6->C6_QTDVEN  := SZ4->Z4_QTENT - _nFatur
SC6->C6_PRCVEN  := _nPrcVen
SC6->C6_VALOR   := Round(( (SZ4->Z4_QTENT - _nFatur) * _nPrcVen ),2)
SC6->C6_ENTREG  := SZ4->Z4_DTENT
SC6->C6_PEDAMOS := SZ4->Z4_TPPED
SC6->C6_TES     := SZ2->Z2_TES
If SA1->A1_EST == "SP"
	_cCf         := "5"
ElseIf SA1->A1_EST == "EX"
	_cCf         := "7"
Else
	_cCF         := "6"
Endif
SC6->C6_CF      := _cCf + Substr(SF4->F4_CF,2,3)
SC6->C6_UM      := SB1->B1_UM
SC6->C6_PEDCLI  := SZ4->Z4_PEDIDO
SC6->C6_DESCRI  := SB1->B1_DESC
SC6->C6_LOCAL   := SB1->B1_LOCPAD
SC6->C6_CLI     := SZ4->Z4_CODCLI
SC6->C6_LOJA    := SZ4->Z4_LOJA
SC6->C6_PRUNIT  := _nPrcVen
SC6->C6_TPOP    := "F"
MsUnlock()

dbSelectArea("SZ4")

Return
