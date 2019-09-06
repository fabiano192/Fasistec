#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Pa0054   º Autor ³ Alexandro Da Silva º Data ³  24/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Controle de Producao                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Sigapcp                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0054()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2       := "de acordo com os parametros informados pelo usuario."
Private cDesc3       := "Controle de Producao "
Private cPict        := ""
Private titulo       := "Controle de Producao "
Private nLin         := 80

Private Cabec1       := "Codigo Produto  Ord. Producao Data     Cliente Lj Turno  Prensa Prensista       Operador  Acab. Qtde Produzida    Qtde Refugo"
Private Cabec2       := ""
Private imprime      := .T.
Private aOrd         := {"Por Produto","Por Prensa","Por Operador","Por Data","Por Ferramenta","Por Defeito"}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "PA0054"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "PA0054"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PA0054"
Private cString      := "SD3"

dbSelectArea("SD3")
dbSetOrder(1)

pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo              := If(aReturn[4]==1,15,18)
nOrdem             := aReturn[8]

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| GeraTrb(@_lFim) }
Private _cTitulo01 := 'Processando '
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

If nOrdem == 1
	_cOrd := "Produto"
ElseIf nOrdem == 2
	_cOrd := "Prensa"
ElseIf nOrdem == 3
	_cOrd := "Operador"
ElseIf nOrdem == 4
	_cOrd := "Data"
ElseIf nOrdem == 5
	_cOrd := "Ferramenta"
ElseIf nOrdem == 6
	_cOrd := "Tipo de Perda"
Endif

Private titulo       := "Controle de Producao Periodo "+Dtoc(MV_PAR01)+ " Ate "+DTOC(MV_PAR02)+ " - Por "+_cOrd


If 	MV_PAR18 == 1          //  Analitico
	If nOrdem == 1         //  Por Produto
		_bAcao01   := {|_lFim| ImpRelO1A(@_lFim) }
	ElseIf nOrdem == 2     //  Por Prensa
		_bAcao01   := {|_lFim| ImpRelO2A(@_lFim) }
	ElseIf nOrdem == 3     //  Por Operador
		_bAcao01   := {|_lFim| ImpRelO3A(@_lFim) }
	ElseIf nOrdem == 4     //  Por Data
		_bAcao01   := {|_lFim| ImpRelO4A(@_lFim) }
	ElseIf nOrdem == 5     //  Por Ferramenta
		_bAcao01   := {|_lFim| ImpRelO5A(@_lFim) }
	ElseIf nOrdem == 6     //  Por Defeito
		_bAcao01   := {|_lFim| ImpRelO6A(@_lFim) }
	Endif
Else                        // Sintetico
	_bAcao01   := {|_lFim| ImpRelO1S(@_lFim) }
Endif

_cTitulo01 := 'Imprimindo '
RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

dbSelectArea("TRB")
dbCloseArea()

Return





Static Function GeraTRb(_lFim)


/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////                                       /////
/////  MV_PAR01  : Data De ?                /////
/////  MV_PAR02  : Data Ate?                /////
/////  MV_PAR03  : Produto De?              /////
/////  MV_PAR04  : Produto Ate?             /////
/////  MV_PAR05  : Almoxarifado De?         /////
/////  MV_PAR06  : Almoxarifado Ate?        /////
/////  MV_PAR07  : O.Producao De ?          /////
/////  MV_PAR08  : O.Producao Ate?          /////
/////  MV_PAR09  : Prensista De ?           /////
/////  MV_PAR10  : Prensista Ate ?          /////
/////  MV_PAR11  : Prensa De     ?          /////
/////  MV_PAR12  : Prensa Ate ?             /////
/////  MV_PAR13  : Turno De ?               /////
/////  MV_PAR14  : Turno Ate ?              /////
/////  MV_PAR15  : Oper.Acab. De ?          /////
/////  MV_PAR16  : Oper.Acab. Ate ?         /////
/////  MV_PAR17  : Considera produc c/ Perda/////
/////  MV_PAR18  : Imprime Analit / Sintet  /////
/////                                       /////
/////////////////////////////////////////////////

aStru := {}
AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
AADD(aStru,{"ALMOX"    , "C" , 02, 0 })
AADD(aStru,{"ORDPROD"  , "C" , 13, 0 })
AADD(aStru,{"DTPROD"   , "D" ,  8, 0 })
AADD(aStru,{"CLIENTE"  , "C" ,  6, 0 })
AADD(aStru,{"LOJA"     , "C" , 02, 0 })
AADD(aStru,{"QTDPROD"  , "N" , 14, 2 })
AADD(aStru,{"QTDREF"   , "N" , 14, 2 })
AADD(aStru,{"PEDIDO"   , "C" ,  8, 0 })
AADD(aStru,{"PRENSA"   , "C" ,  6, 0 })
AADD(aStru,{"TURNO"    , "C" ,  6, 0 })
AADD(aStru,{"PRENSIST" , "C" , 15, 0 })
AADD(aStru,{"OPERACAB" , "C" , 15, 0 })
AADD(aStru,{"FERRAM"   , "C" , 06, 0 })
AADD(aStru,{"TPPERDA"  , "C" , 30, 0 })

cArq    := CriaTrab(aStru,.T.)
If MV_PAR18 == 1
	If nOrdem == 1                          // Produto
		cInd    := "PRODUTO+ALMOX+ORDPROD"
	ElseIf nOrdem == 2
		cInd    := "PRENSA+TURNO"           // Prensa
	ElseIf	nOrdem == 3
		cInd    := "OPERACAB"               // Operador de Acabamento
	ElseIf	nOrdem == 4
		cInd    := "DTOS(DTPROD)"           // Data de Produção
	ElseIf	nOrdem == 5
		cInd    := "FERRAM"		            // Ferramenta
	ElseIf	nOrdem == 6
		cInd    := "TPPERDA"		        // Tipo de Perda
	Endif
Else
	cInd    := "PRENSA+PRENSIST"      // Prensa
Endif

dbUseArea(.T.,,cArq,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArq,cInd,,,"Criando Trabalho...")

dbSelectArea("SD3")
dbSetOrder(6)
dbSeek(xFilial("SD3")+Dtos(MV_PAR01),.T.)

ProcRegua(RecCount())

While !Eof() .And. !_lFim .And. SD3->D3_EMISSAO <= MV_PAR02 .And. !_lFim
	
	IncProc()
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	If SD3->D3_COD      < MV_PAR03 .Or. SD3->D3_COD     > MV_PAR04 .Or.;
		SD3->D3_LOCAL   < MV_PAR05 .Or. SD3->D3_LOCAL   > MV_PAR06 .Or.;
		SD3->D3_OP      < MV_PAR07 .Or. SD3->D3_OP      > MV_PAR08 .Or.;
		SD3->D3_OPPRENS < MV_PAR09 .Or. SD3->D3_OPPRENS > MV_PAR10 .Or.;
		SD3->D3_RECURSO < MV_PAR11 .Or. SD3->D3_RECURSO > MV_PAR12 .Or.;
		SD3->D3_TURNO   < MV_PAR13 .Or. SD3->D3_TURNO   > MV_PAR14 .Or.;
		SD3->D3_OPERACA < MV_PAR15 .Or. SD3->D3_OPERACA > MV_PAR16
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif
	
	If MV_PAR17 == 1
		If SD3->D3_PERDA  == 0
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
	Endif
	
	_nPerda := SD3->D3_PERDA
	If SD3->D3_ESTORNO == "S" .Or. Substr(SD3->D3_CF,1,2) != "PR"
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif
	
	If MV_PAR18 == 1
		If nOrdem == 2 .And. Empty(SD3->D3_RECURSO)
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
	Else
		If  Empty(SD3->D3_RECURSO)
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
	Endif
	
	If nOrdem == 3 .And. Empty(SD3->D3_OPERACA)
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif
	
	_cCliente := ""
	_cLoja    := ""
	
	dbSelectArea("SC2")
	dbSetOrder(1)
	If dbSeek(xFilial("SC2")+SD3->D3_OP)
		dbSelectArea("SC5")
		dbSetOrder(1)
		If dbSeek(xFilial("SC5")+SC2->C2_PEDIDO)
			_cCliente := SC5->C5_CLIENTE
			_cLoja    := SC5->C5_LOJACLI
		Endif
	Endif
	
	dbSelectArea("SD3")
	_aAliSD3   := GetArea()
	
	_cNumSeq   := SD3->D3_NUMSEQ
	_nQtProd   := SD3->D3_QUANT
	_nQtPerd   := SD3->D3_PERDA
	_cTurno    := SD3->D3_TURNO
	_cPrensa   := SD3->D3_RECURSO
	_cPrensist := SD3->D3_OPPRENS
	_cOperad   := SD3->D3_OPERACA
	_cFerram   := ""
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SD3->D3_COD)
	
	dbSelectArea("SG1")
	dbSetOrder(1)
	If dbSeek(xFilial("SG1")+SD3->D3_COD)
		
		_cProd   := SG1->G1_COD
		nNivel   := 2
		VerEst(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
	Endif
	
	If _nPerda > 0
		dbSelectArea("SD3")
		dbOrderNickName("INDSD31")
		If dbSeek(xFilial("SD3") + _cNumSeq)
			dbSelectArea("SBC")
			dbOrderNickName("INDSBC2")
			If dbSeek(xfilial("SBC")+SD3->D3_NUMSEQ )
				_cChavSBC := SBC->BC_SEQSD3
				_nProdAcu := 0
				
				While !Eof() .And. !_lFim  .And. _cChavSBC == SBC->BC_SEQSD3
					
					_nProdPar := (_nQtProd * SBC->BC_QUANT	) / _nQtPerd
					_nProdAcu += _nProdPar
					
					dbSelectArea("TRB")
					RecLock("TRB",.T.)
					TRB->PRODUTO  := SD3->D3_COD
					TRB->ALMOX    := SD3->D3_LOCAL
					TRB->ORDPROD  := SD3->D3_OP
					TRB->DTPROD   := SD3->D3_EMISSAO
					TRB->CLIENTE  := _cCliente
					TRB->LOJA     := _cLoja
					TRB->QTDPROD  := Round(_nProdPar,0)
					TRB->QTDREF   := SBC->BC_QUANT
					TRB->PEDIDO   := SC2->C2_PEDIDO + SC2->C2_ITEMPV
					TRB->TURNO    := _cTurno
					TRB->PRENSA   := _cPrensa
					TRB->PRENSIST := _cPrensist
					TRB->OPERACAB := _cOperad
					TRB->TPPERDA  := Tabela("43",SBC->BC_MOTIVO)
					TRB->FERRAM   := _cFerram
					MsUnlock()
					
					dbSelectArea("SBC")
					dbSkip()
				EndDo
			Endif
		Endif
	Else
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->PRODUTO  := SD3->D3_COD
		TRB->ALMOX    := SD3->D3_LOCAL
		TRB->ORDPROD  := SD3->D3_OP
		TRB->DTPROD   := SD3->D3_EMISSAO
		TRB->CLIENTE  := _cCliente
		TRB->LOJA     := _cLoja
		TRB->QTDPROD  := Round(_nQtProd,0)
		TRB->PEDIDO   := SC2->C2_PEDIDO + SC2->C2_ITEMPV
		TRB->TURNO    := _cTurno
		TRB->PRENSA   := _cPrensa
		TRB->PRENSIST := _cPrensist
		TRB->OPERACAB := _cOperad
		TRB->FERRAM   := _cFerram
		MsUnlock()
	Endif
	
	dbSelectArea("SD3")
	RestArea(_aAliSD3)
	dbSkip()
	
EndDo

Return


Static Function VerEst(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev)

Local _nReg,nQuantItem := 0
Local _nRegTrb := 0
dbSelectArea("SG1")
dbSetOrder(1)
While !Eof() .And. SG1->G1_FILIAL + SG1->G1_COD == xFilial("SG1") + _cProd
	
	_nReg := Recno()
	
	nQuantItem := ExplEstr(_nQtPai,,_cOpc,_cRev)
	dbSelectArea("SG1")
	dbSetOrder(1)
	
	dbSelectArea("SB1")
	_aAliSB1 := GetArea()
	dbSeek(xFilial("SB1")+SG1->G1_COMP)
	
	If SB1->B1_TIPO == "FR"
		_cFerram := SG1->G1_COMP
	Endif
	
	RestArea(_aAliSB1)
	
	dbSelectArea("SG1")
	dbSetOrder(1)
	dbSeek(xFilial("SG1")+SG1->G1_COMP)
	IF Found()
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+SG1->G1_COD)
		VerEst(SG1->G1_COD,nQuantItem,nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
	EndIf
	
	dbSelectArea("SG1")
	dbGoto(_nReg)
	
	dbSkip()
EndDo

Return


Static Function ImpRelO1A(_lFim)


/*
Codigo Produto  Motivo da Perda                Ord. Producao Data     Cliente Lj Turno  Prensa Prensista       Operador  Acab. Ferramenta      Qtde Produzida    Qtde Refugo
999999999999999 999999999999999999999999999999 9999999999999 99999999 9999999 99 999999 999999 999999999999999 999999999999999 999999999999999 99999999999999 99999999999999
0               16                             47            61       70      78 81     88     95              111             127             143            158
*/

Private Cabec1 := "Codigo Produto  Motivo da Perda                Ord. Producao Data     Cliente Lj Turno  Prensa Prensista       Operador  Acab. Ferramenta      Qtde Produzida    Qtde Refugo"

_nQtdProd  := _nQtdRef := 0

dbSelectArea("TRB")
dbGotop()

SetRegua(LastRec())

While !Eof() .And. !_lFim
	
	IncRegua()
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@nLin, 000 PSAY TRB->PRODUTO
	@nLin, 016 PSAY TRB->TPPERDA
	@nLin, 047 PSAY TRB->ORDPROD
	@nLin, 061 PSAY TRB->DTPROD
	@nLin, 070 PSAY TRB->CLIENTE
	@nLin, 078 PSAY TRB->LOJA
	@nLin, 081 PSAY TRB->TURNO
	@nLin, 088 PSAY TRB->PRENSA
	@nLin, 095 PSAY Substr(TRB->PRENSIST,1,15)
	@nLin, 111 PSAY TRB->OPERACAB
	@nLin, 127 PSAY TRB->FERRAM
	@nLin, 143 PSAY TRB->QTDPROD                 Picture TM(TRB->QTDPROD,14)
	@nLin, 158 PSAY TRB->QTDREF                  Picture TM(TRB->QTDREF,14)
	
	_nQtdProd += TRB->QTDPROD
	_nQtdRef  += TRB->QTDREF
	
	nLin++
	
	dbSelectArea("TRB")
	dbSkip()
EndDo

nLin ++

If nLin > 60
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

@nLin, 000 PSAY "TOTAL GERAL ----- > "
@nLin, 143 PSAY _nQtdProd             Picture TM(_nQtdProd,14)
@nLin, 158 PSAY _nQtdRef              Picture TM(_nQtdRef,14)


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


Static Function ImpRelO2A(_lFim)


/*
Codigo Produto  Motivo da Perda                Ord. Producao Data     Cliente Lj Turno  Prensa Prensista       Operador  Acab. Ferramenta      Qtde Produzida    Qtde Refugo
999999999999999 999999999999999999999999999999 9999999999999 99999999 9999999 99 999999 999999 999999999999999 999999999999999 999999999999999 99999999999999 99999999999999
0               16                             47            61       70      78 81     88     95              111             127             143            158
*/

Private Cabec1 := "Codigo Produto  Motivo da Perda                Ord. Producao Data     Cliente Lj Turno  Prensa Prensista       Operador  Acab. Ferramenta      Qtde Produzida    Qtde Refugo"

_nGeQProd  := _nGeQRef := 0

dbSelectArea("TRB")
dbGotop()

SetRegua(LastRec())

While !Eof() .And. !_lFim
	
	IncRegua()
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	_cPrensa := TRB->PRENSA
	
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	_nToQProd  := _nToQRef := 0
	
	While !Eof() .And. _cPrensa == TRB->PRENSA
		
		_cTurno    := TRB->TURNO
		_cDesTurno := Space(15)
		dbSelectArea("SZA")
		dbSetOrder(1)
		If dbSeek(xFilial("SZA")+TRB->TURNO)
			_cDesTurno := Alltrim(SZA->ZA_DESTURN)
		Endif
		
		@nLin, 000 PSAY "PRENSA No. "+ _cPrensa + " TURNO No. "+_cTurno+ " ( "+_cDesTurno+" )"
		nLin+=2
		
		_nTurQProd  := _nTurQRef := 0
		
		While !Eof() .And. _cTurno == TRB->TURNO
			
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
				@nLin, 000 PSAY "PRENSA No. "+_cPrensa + " TURNO No. "+_cTurno+ " ( "+_cDesTurno+" )"
				nLin+=2
			Endif
			
			@nLin, 000 PSAY TRB->PRODUTO
			@nLin, 016 PSAY TRB->TPPERDA
			@nLin, 047 PSAY TRB->ORDPROD
			@nLin, 061 PSAY TRB->DTPROD
			@nLin, 070 PSAY TRB->CLIENTE
			@nLin, 078 PSAY TRB->LOJA
			@nLin, 081 PSAY TRB->TURNO
			@nLin, 088 PSAY TRB->PRENSA
			
			_cPrensist := Space(15)
			dbSelectArea("SZ6")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ6")+TRB->PRENSIST)
				_cPrensist := Substr(SZ6->Z6_NOME,1,15)
			Endif
			
			_cOperNom := Space(15)
			dbSelectArea("SZ6")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ6")+TRB->OPERACAB)
				_cOperNom :=  Substr(SZ6->Z6_NOME,1,15)
			Endif
			
			@nLin, 095 PSAY _cPrensist
			@nLin, 111 PSAY _cOperNom
			@nLin, 127 PSAY TRB->FERRAM
			@nLin, 143 PSAY TRB->QTDPROD                 Picture TM(TRB->QTDPROD,14)
			@nLin, 158 PSAY TRB->QTDREF                  Picture TM(TRB->QTDREF,14)
			
			_nTurQProd += TRB->QTDPROD
			_nTurQRef  += TRB->QTDREF
			
			nLin++
			
			dbSelectArea("TRB")
			dbSkip()
		EndDo
		
		nLin++
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		@nLin, 016 PSAY "TOTAL DO TURNO "+_cTurno+ " ( "+_cDesTurno+" ) ----- > "
		@nLin, 143 PSAY _nTurQProd             Picture TM(_nTurQProd,14)
		@nLin, 158 PSAY _nTurQRef              Picture TM(_nTurQRef,14)
		
		_nToQProd += _nTurQProd
		_nToQRef  += _nTurQRef
		
		nlin+=2
		
		dbSelectArea("TRB")
	EndDo
	
	@nLin, 000 PSAY "TOTAL DA PRENSA "+_cPrensa+ " ----- > "
	@nLin, 143 PSAY _nToQProd             Picture TM(_nToQProd,14)
	@nLin, 158 PSAY _nToQRef              Picture TM(_nToQRef,14)
	
	_nGeQProd += _nToQProd
	_nGeQRef  += _nToQRef
	
	nlin+=2
EndDo

nLIn++

@nLin, 000 PSAY "TOTAL GERAL ----- > "
@nLin, 143 PSAY _nGeQProd             Picture TM(_nGeQProd,14)
@nLin, 158 PSAY _nGeQRef              Picture TM(_nGeQRef,14)

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Static Function ImpRelO3A(_lFim)


/*
Codigo Produto  Motivo da Perda                Ord. Producao Data     Cliente Lj Turno  Prensa Prensista       Operador  Acab. Ferramenta      Qtde Produzida    Qtde Refugo
999999999999999 999999999999999999999999999999 9999999999999 99999999 9999999 99 999999 999999 999999999999999 999999999999999 999999999999999 99999999999999 99999999999999
0               16                             47            61       70      78 81     88     95              111             127             143            158
*/

Private Cabec1 := "Codigo Produto  Motivo da Perda                Ord. Producao Data     Cliente Lj Turno  Prensa Prensista       Operador  Acab. Ferramenta      Qtde Produzida    Qtde Refugo"

_nGeQProd  := _nGeQRef := 0

dbSelectArea("TRB")
dbGotop()

SetRegua(LastRec())

While !Eof() .And. !_lFim
	
	IncRegua()
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	_cOperNom := Space(15)
	
	dbSelectArea("SZ6")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ6")+TRB->OPERACAB)
		_cOperNom :=  Substr(SZ6->Z6_NOME,1,15)
	Endif
	
	_nToQProd  := _nToQRef := 0
	_cOperad   := TRB->OPERACAB
	
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
		@nLin, 000 PSAY _cOperad+" - "+AllTrim(SZ6->Z6_NOME)
		nLin+=2
	Else
		@nLin, 000 PSAY _cOperad+" - "+AllTrim(SZ6->Z6_NOME)
		nLin+=2
	Endif
	
	While !Eof() .And. 	_cOperad  == TRB->OPERACAB .And. !_lFim
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
			@nLin, 000 PSAY _cOperad+" - "+AllTrim(SZ6->Z6_NOME)
			nLin+=2
		Endif
		
		@nLin, 000 PSAY TRB->PRODUTO
		@nLin, 016 PSAY TRB->TPPERDA
		@nLin, 047 PSAY TRB->ORDPROD
		@nLin, 061 PSAY TRB->DTPROD
		@nLin, 070 PSAY TRB->CLIENTE
		@nLin, 078 PSAY TRB->LOJA
		@nLin, 081 PSAY TRB->TURNO
		@nLin, 088 PSAY TRB->PRENSA
		
		_cPrensist := Space(15)
		dbSelectArea("SZ6")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ6")+TRB->PRENSIST)
			_cPrensist := Substr(SZ6->Z6_NOME,1,15)
		Endif
		
		@nLin, 095 PSAY _cPrensist
		@nLin, 111 PSAY _cOperNom
		@nLin, 127 PSAY TRB->FERRAM
		@nLin, 143 PSAY TRB->QTDPROD                 Picture TM(TRB->QTDPROD,14)
		@nLin, 158 PSAY TRB->QTDREF                  Picture TM(TRB->QTDREF,14)
		
		_nToQProd += TRB->QTDPROD
		_nToQRef  += TRB->QTDREF
		
		nLin++
		
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	nLin++
	
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@nLin, 000 PSAY "TOTAL DO OPERADOR "+_cOperad+ " ----- > "
	@nLin, 143 PSAY _nToQProd             Picture TM(_nToQProd,14)
	@nLin, 158 PSAY _nToQRef              Picture TM(_nToQRef,14)
	
	_nGeQProd += _nToQProd
	_nGeQRef  += _nToQRef
	
	nlin+=2
EndDo

nLIn++

@nLin, 000 PSAY "TOTAL GERAL ----- > "
@nLin, 143 PSAY _nGeQProd             Picture TM(_nGeQProd,14)
@nLin, 158 PSAY _nGeQRef              Picture TM(_nGeQRef,14)

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function ImpRelO4A(_lFim)


/*
Codigo Produto  Motivo da Perda                Ord. Producao Data     Cliente Lj Turno  Prensa Prensista       Operador  Acab. Ferramenta      Qtde Produzida    Qtde Refugo
999999999999999 999999999999999999999999999999 9999999999999 99999999 9999999 99 999999 999999 999999999999999 999999999999999 999999999999999 99999999999999 99999999999999
0               16                             47            61       70      78 81     88     95              111             127             143            158
*/

Private Cabec1 := "Codigo Produto  Motivo da Perda                Ord. Producao Data     Cliente Lj Turno  Prensa Prensista       Operador  Acab. Ferramenta      Qtde Produzida    Qtde Refugo"

_nGeQProd  := _nGeQRef := 0

dbSelectArea("TRB")
dbGotop()

SetRegua(LastRec())

While !Eof() .And. !_lFim
	
	IncRegua()
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	_nToQProd  := _nToQRef := 0
	_dDtProd   := TRB->DTPROD
	
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
		@nLin, 000 PSAY "Data --> "+Dtoc(_dDtProd)
		nLin+=2
	Else
		@nLin, 000 PSAY "Data --> "+Dtoc(_dDtProd)
		nLin+=2
	Endif
	
	dbSelectArea("TRB")
	
	While !Eof() .And. 	_dDtProd  == TRB->DTPROD .And. !_lFim
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
			@nLin, 000 PSAY "Data --> "+Dtoc(_dDtProd)
			nLin+=2
		Endif
		
		_cOperNom := Space(15)
		
		dbSelectArea("SZ6")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ6")+TRB->OPERACAB)
			_cOperNom :=  Substr(SZ6->Z6_NOME,1,15)
		Endif
		
		@nLin, 000 PSAY TRB->PRODUTO
		@nLin, 016 PSAY TRB->TPPERDA
		@nLin, 047 PSAY TRB->ORDPROD
		@nLin, 061 PSAY TRB->DTPROD
		@nLin, 070 PSAY TRB->CLIENTE
		@nLin, 078 PSAY TRB->LOJA
		@nLin, 081 PSAY TRB->TURNO
		@nLin, 088 PSAY TRB->PRENSA
		
		_cPrensist := Space(15)
		dbSelectArea("SZ6")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ6")+TRB->PRENSIST)
			_cPrensist := Substr(SZ6->Z6_NOME,1,15)
		Endif
		
		@nLin, 095 PSAY _cPrensist
		@nLin, 111 PSAY _cOperNom
		@nLin, 127 PSAY TRB->FERRAM
		@nLin, 143 PSAY TRB->QTDPROD                 Picture TM(TRB->QTDPROD,14)
		@nLin, 158 PSAY TRB->QTDREF                  Picture TM(TRB->QTDREF,14)
		
		_nToQProd += TRB->QTDPROD
		_nToQRef  += TRB->QTDREF
		
		nLin++
		
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	nLin++
	
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@nLin, 000 PSAY "TOTAL DA DATA  "+Dtoc(_dDtProd)+ " ----- > "
	@nLin, 143 PSAY _nToQProd             Picture TM(_nToQProd,14)
	@nLin, 158 PSAY _nToQRef              Picture TM(_nToQRef,14)
	
	_nGeQProd += _nToQProd
	_nGeQRef  += _nToQRef
	
	nlin+=2
EndDo

nLIn++

@nLin, 000 PSAY "TOTAL GERAL ----- > "
@nLin, 127 PSAY _nGeQProd             Picture TM(_nGeQProd,14)
@nLin, 142 PSAY _nGeQRef              Picture TM(_nGeQRef,14)

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return



Static Function ImpRelO5A(_lFim)


/*
Codigo Produto  Motivo da Perda                Ord. Producao Data     Cliente Lj Turno  Prensa Prensista       Operador  Acab. Ferramenta      Qtde Produzida    Qtde Refugo
999999999999999 999999999999999999999999999999 9999999999999 99999999 9999999 99 999999 999999 999999999999999 999999999999999 999999999999999 99999999999999 99999999999999
0               16                             47            61       70      78 81     88     95              111             127             143            158
*/

Private Cabec1 := "Codigo Produto  Motivo da Perda                Ord. Producao Data     Cliente Lj Turno  Prensa Prensista       Operador  Acab. Ferramenta      Qtde Produzida    Qtde Refugo"

_nGeQProd  := _nGeQRef := 0

dbSelectArea("TRB")
dbGotop()

SetRegua(LastRec())

While !Eof() .And. !_lFim
	
	IncRegua()
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	_nToQProd  := _nToQRef := 0
	_cFerram   := TRB->FERRAM
	
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
		@nLin, 000 PSAY "Ferramenta --> "+_cFerram
		nLin+=2
	Else
		@nLin, 000 PSAY "Ferramenta --> "+_cFerram
		nLin+=2
	Endif
	
	dbSelectArea("TRB")
	
	While !Eof() .And. 	_cFerram  ==  TRB->FERRAM .And. !_lFim
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
			@nLin, 000 PSAY "Ferramenta --> "+_cFerram
			nLin+=2
		Endif
		
		_cOperNom := Space(15)
		
		dbSelectArea("SZ6")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ6")+TRB->OPERACAB)
			_cOperNom :=  Substr(SZ6->Z6_NOME,1,15)
		Endif
		
		@nLin, 000 PSAY TRB->PRODUTO
		@nLin, 016 PSAY TRB->TPPERDA
		@nLin, 047 PSAY TRB->ORDPROD
		@nLin, 061 PSAY TRB->DTPROD
		@nLin, 070 PSAY TRB->CLIENTE
		@nLin, 078 PSAY TRB->LOJA
		@nLin, 081 PSAY TRB->TURNO
		@nLin, 088 PSAY TRB->PRENSA
		
		_cPrensist := Space(15)
		dbSelectArea("SZ6")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ6")+TRB->PRENSIST)
			_cPrensist := Substr(SZ6->Z6_NOME,1,15)
		Endif
		
		@nLin, 095 PSAY _cPrensist
		@nLin, 111 PSAY _cOperNom
		@nLin, 127 PSAY TRB->FERRAM
		@nLin, 143 PSAY TRB->QTDPROD                 Picture TM(TRB->QTDPROD,14)
		@nLin, 158 PSAY TRB->QTDREF                  Picture TM(TRB->QTDREF,14)
		
		_nToQProd += TRB->QTDPROD
		_nToQRef  += TRB->QTDREF
		
		nLin++
		
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	nLin++
	
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@nLin, 000 PSAY "TOTAL DA FERRAMENTA --> "+_cFerram
	@nLin, 143 PSAY _nToQProd             Picture TM(_nToQProd,14)
	@nLin, 158 PSAY _nToQRef              Picture TM(_nToQRef,14)
	
	_nGeQProd += _nToQProd
	_nGeQRef  += _nToQRef
	
	nlin+=2
EndDo

nLIn++

@nLin, 000 PSAY "TOTAL GERAL ----- > "
@nLin, 143 PSAY _nGeQProd             Picture TM(_nGeQProd,14)
@nLin, 158 PSAY _nGeQRef              Picture TM(_nGeQRef,14)

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Static Function ImpRelO6A(_lFim)


/*
Codigo Produto  Motivo da Perda                Ord. Producao Data     Cliente Lj Turno  Prensa Prensista       Operador  Acab. Ferramenta      Qtde Produzida    Qtde Refugo
999999999999999 999999999999999999999999999999 9999999999999 99999999 9999999 99 999999 999999 999999999999999 999999999999999 999999999999999 99999999999999 99999999999999
0               16                             47            61       70      78 81     88     95              111             127             143            158
*/

Private Cabec1 := "Codigo Produto  Motivo da Perda                Ord. Producao Data     Cliente Lj Turno  Prensa Prensista       Operador  Acab. Ferramenta      Qtde Produzida    Qtde Refugo"

_nGeQProd  := _nGeQRef := 0

dbSelectArea("TRB")
dbGotop()

SetRegua(LastRec())

While !Eof() .And. !_lFim
	
	IncRegua()
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	_nToQProd  := _nToQRef := 0
	_cTpPerda  := TRB->TPPERDA
	
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
		@nLin, 000 PSAY "Motivo da Perda --> "+_cTpPerda
		nLin+=2
	Else
		@nLin, 000 PSAY "Motivo da Perda --> "+_cTpPerda
		nLin+=2
	Endif
	
	dbSelectArea("TRB")
	
	While !Eof() .And. _cTpPerda  == TRB->TPPERDA  .And.  !_lFim
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
			@nLin, 000 PSAY "Motivo da Perda --> "+_cTpPerda
			nLin+=2
		Endif
		
		_cOperNom := Space(15)
		
		dbSelectArea("SZ6")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ6")+TRB->OPERACAB)
			_cOperNom :=  Substr(SZ6->Z6_NOME,1,15)
		Endif
		
		@nLin, 000 PSAY TRB->PRODUTO
		@nLin, 016 PSAY TRB->TPPERDA
		@nLin, 047 PSAY TRB->ORDPROD
		@nLin, 061 PSAY TRB->DTPROD
		@nLin, 070 PSAY TRB->CLIENTE
		@nLin, 078 PSAY TRB->LOJA
		@nLin, 081 PSAY TRB->TURNO
		@nLin, 088 PSAY TRB->PRENSA
		
		_cPrensist := Space(15)
		dbSelectArea("SZ6")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ6")+TRB->PRENSIST)
			_cPrensist := Substr(SZ6->Z6_NOME,1,15)
		Endif
		
		@nLin, 095 PSAY _cPrensist
		@nLin, 111 PSAY _cOperNom
		@nLin, 127 PSAY TRB->FERRAM
		@nLin, 143 PSAY TRB->QTDPROD                 Picture TM(TRB->QTDPROD,14)
		@nLin, 158 PSAY TRB->QTDREF                  Picture TM(TRB->QTDREF,14)
		
		_nToQProd += TRB->QTDPROD
		_nToQRef  += TRB->QTDREF
		
		nLin++
		
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	nLin++
	
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@nLin, 000 PSAY "TOTAL DO MOTIVO DA PERDA --> "+_cTpPerda
	@nLin, 143 PSAY _nToQProd             Picture TM(_nToQProd,14)
	@nLin, 158 PSAY _nToQRef              Picture TM(_nToQRef,14)
	
	_nGeQProd += _nToQProd
	_nGeQRef  += _nToQRef
	
	nlin+=2
EndDo

nLIn++

@nLin, 000 PSAY "TOTAL GERAL ----- > "
@nLin, 143 PSAY _nGeQProd             Picture TM(_nGeQProd,14)
@nLin, 158 PSAY _nGeQRef              Picture TM(_nGeQRef,14)

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return



Static Function ImpRelO1S(_lFim)


/*      15            12          12           10           13           10
PRODUTO                 QTDE         QTDE      EFIC.     QTDE PERDA       PERC.
					  PADRAO    PRODUZIDA     PROD.%       (PRENSA)       PERDA
999999999999999 999999999999 999999999999 9999999999  9999999999999  9999999999
0               16           29           42          54             69
*/

//@ 0,0 Psay AvalImp(Tamanho)

nTipo   := 18
Tamanho := "P"
limite  := 80
nomeprog:= "PA0054"
titulo  := "Controle de Producao : "
Cabec1  := "PRODUTO                 QTDE         QTDE      EFIC.     QTDE PERDA       PERC."
Cabec2  := "                      PADRAO    PRODUZIDA     PROD.%       (PRENSA)       PERDA"

_nGeQProd  := _nGeQRef := 0

dbSelectArea("TRB")
dbGotop()

SetRegua(LastRec())

While !Eof() .And. !_lFim
	
	IncRegua()
	
	_cPrensa   := TRB->PRENSA
	_nToQProd  := _nToQRef := 0
	
	While !Eof() .And. _cPrensa == TRB->PRENSA
		
		_cCodPrens := TRB->PRENSIST
		_cOperNom  := Space(15)
		dbSelectArea("SZ6")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ6")+TRB->PRENSIST)
			_cOperNom :=  Alltrim(SZ6->Z6_NOME)
		Endif
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
			@nLin, 029 PSAY "PERIODO : "+DTOC(MV_PAR01)+ " A "+DTOC(MV_PAR02)
			nLin++
		Endif
		
		_cTurno := TRB->TURNO
		@nLin, 000 PSAY "PRENSISTA : "+_cOperNom
		nLin++
		@nLin, 000 PSAY "DATA "+DTOC(TRB->DTPROD)+" PRENSA : "+ _cPrensa + " TURNO :"+_cTurno//+ " ( "+Alltrim(_cDesTurno)+" )"
		nLin+=2
			
		dbSelectArea("TRB")
		
		_nOpeQProd := _nOpeQRef  := 0 
		
			
		While !Eof() .And. _cPrensa == TRB->PRENSA  .And. _cCodPrens == TRB->PRENSIST
				
			If _lFim
				Alert("Cancelado Pelo Usuario!!!!")
				Return
			Endif
			
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
				@nLin, 029 PSAY "PERIODO : "+DTOC(MV_PAR01)+ " A "+DTOC(MV_PAR02)
				nLin++
				@nLin, 000 PSAY "PRENSISTA : "+_cOperNom
				nLin++
				@nLin, 000 PSAY "DATA "+DTOC(TRB->DTPROD)+" PRENSA : "+ _cPrensa + " TURNO :"+_cTurno//+ " ( "+Alltrim(_cDesTurno)+" )"
				nLin+=2
			Endif
			
			_nPerPerda := Round(((TRB->QTDREF  / TRB->QTDPROD) * 100),2)
			@nLin, 000 PSAY TRB->PRODUTO
			@nLin, 016 PSAY 0                  Picture Tm(0,12,2)
			@nLin, 029 PSAY TRB->QTDPROD       Picture Tm(TRB->QTDPROD,12,2)
			@nLin, 042 PSAY 100                Picture Tm(100,10,2)
			@nLin, 054 PSAY TRB->QTDREF        Picture TM(TRB->QTDREF,13,2)
			@nLin, 069 PSAY _nPerPerda         Picture TM(_nPerPerda,10,2)
			
			nLIn++
			_nOpeQProd += TRB->QTDPROD
			_nOPeQRef  += TRB->QTDREF
			
			dbSelectArea("TRB")
			dbSkip()
		EndDo
		
		nLIn++
		@nLin, 000 PSAY "TOTAL PRENSISTA : "+Alltrim(_cCodPrens)+" -->"
		@nLin, 029 PSAY _nOpeQProd             Picture TM(_nOpeQProd,12,2)
		@nLin, 054 PSAY _nOpeQRef              Picture TM(_nOpeQRef,13,2)
		
		_nToQProd += _nOpeQProd
		_nToQRef  += _nOpeQRef
		
		nlin+=2
		
		dbSelectArea("TRB")
	EndDo
	
	@nLin, 000 PSAY "TOTAL DA PRENSA : "+_cPrensa+ "-->"
	@nLin, 029 PSAY _nToQProd             Picture TM(_nToQProd,12,2)
	@nLin, 054 PSAY _nToQRef              Picture TM(_nToQRef,13,2)
	
	nLin++
	@nLin, 000 PSAY Repl("_",80)
	_nGeQProd += _nToQProd
	_nGeQRef  += _nToQRef
	
	nlin+=2
EndDo

nLIn++

@nLin, 000 PSAY "TOTAL GERAL ----- > "
@nLin, 029 PSAY _nGeQProd             Picture TM(_nGeQProd,12,2)
@nLin, 054 PSAY _nGeQRef              Picture TM(_nGeQRef,13,2)

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
