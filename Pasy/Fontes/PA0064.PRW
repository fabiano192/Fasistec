#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0064   ³ Autor ³ Fabiano da Silva      ³ Data ³ 05.06.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualizaçao tabela SZ4 ref. Programacao de Entrega         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat CNH                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0064()

_aAliOri := GetArea()
_lAchou  := .F.
_cNum    := ""

Private titulo         := "Programacao de Entrega Periodo:"
Private nLin           := 80

Private Cabec1         := ""
Private Cabec2         := ""
Private cDesc1         := "Rotina criado para Atualizar Progr.Entrega CNH     "
Private cDesc2         := "conforme Arquivo Recebido da CNH                   "
Private cDesc3         := "Programacao de Entrega.PA0064                      "
Private imprime        := .T.
Private aOrd           := {}
Private lEnd           := .F.
Private lAbortPrint    := .F.
Private CbTxt          := ""
Private limite         := 132
Private tamanho        := "M"
Private nomeprog       := "PA0064"
Private nTipo          := 18
Private aReturn        := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey       := 0
Private cPerg          := "PA0064"
Private cbtxt          := Space(10)
Private cbcont         := 00
Private CONTFL         := 01
Private m_pag          := 01
Private wnrel          := "PA0064"
Private cString 	   := "SZ4"

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := 15

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| INTSZ4(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_bAcao01   := {|_lFim| PA64A(@_lFim) }
_cTitulo01 := 'Integrando Pedido!!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

dbSelectArea("TRB")
dbGotop()

dbSelectArea("TRB")
dbCloseArea()

Return


Static Function INTSZ4(_lFim)

Pergunte("PA0064",.F.)

aStru := {}
AADD(aStru,{"PRODCLI"  , "C" , 15, 0 })
AADD(aStru,{"CLIENTE"  , "C" , 06, 0 })
AADD(aStru,{"LOJA"     , "C" , 02, 0 })
cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "PRODCLI"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

_cCont     := ""
_dDtMov    := Ctod("")
_cCliente  := ""
_cLoja     := ""
_cSemAtu   := ""
_cSemAtu2  := ""
_dDtAtu    := Ctod("")
_cSemAnt   := ""
_cProdCli  := ""
_cProdPasy := ""
_cLocDest  := ""
_cContato  := ""
_cTipo     := ""
_cUltNf    := ""
_cSerNf    := ""
_dDtUltNf  := Ctod("")
_dDtEnt    := Ctod("")
_nQtEnt    := ""
_aDtEnt    := {}
_cPedido   := ""
_aPedido   := {}
_cDesenho  := ""

_cData2 := GravaData(dDataBase,.f.,8)
_cHora2 := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

_dDt    := dDatabase //MV_PAR01

/*

Cód. Cliente 			        Descrição	       		                        Data de expedição	 Quantidade	Situação	Acumulado	U.M.  Filial		Visto	Cód. Pasy na CNH  NOME DO CLIENTE	                 	Nº Relatório	Data Relatório					                                                    	Data início acumul.	Ordem de compra	  Nº Versão da OC					                                          Última OC											                                                                                               	                                                                Data Última Entrada	  Qte Última entrada	Última Nota Fiscal	Última Qte Acumulada
PARTNBR	     REV	REV NOTES	DESCRIPTION    	SUPPLIER PARTNBR	BOOKNUMBER	DATE DUE	        QTY DUE	QTY     TYPE      CUM QTY 	 UOM   PLANT	   Viewed	 SUPPLIER	      SUP NAME                           	REL   	              REL DATE	REL STATUS CODE	 REL STATUS	BALANCE OUT	CONSIGNMENT STOCK	OVERSHIPPED	     CUM START DATE	             PO           PO Line	SHIP CODE	REL NOTE 1	REL NOTE 2	REL NOTE 3	         REL NOTE 4  REL NOTE 5	 REL NOTE 6	 REL NOTE 7	 REL NOTE 8	REL NOTE 9	REL NOTE 10	                         Ship to          	      Ship to address1    Ship to address2	Ship to address3	Ship to address4	           LAST REC	            LAST QTY	     LAST PACK NBR	        LAST CUM QTY
14437785	,999   ,999999999  ,O-RING 2,4X11,3,                   ,	       ,20050614	       ,    750.000,    Firm,   2.360.000,	  PC, 	  BH,  	        N,     	19848,	     ,PASY INDUSTRIA DE COMERCIO DE CHA E  ,57829	       ,      20050525, 999999999999999, 9999999999,99999999999,99999999999999999,  99999999999, 	       20050117,      625900190,	            1,	999999999,     	 LR: *, 9999999999, 9999999999,	* OLD P.O:   018536, 9999999999, 9999999999, 9999999999, 9999999999,9999999999, 99999999999, CNH LATIN AMERICA LTDA-CONTAGEM,	AV GAL DAVID SARNOFF 2237 CONT,	999999999999999999,        	CONTAGEM,       	      MG,      	       20050418,	         800.000,	             58544,	           1.610.000,

layout para importação da Programação de Entrega CNH Baseado no Arquivo
texto onde os campos são separados por virgula:

Virgula  -   Campo
0        -   Codigo do Produto do Cliente
1        -   Revisao da Estrutura
2        -   Notas da Revisão
3        -   Descrição
4        -   Cód. Fornecedor
5        -   BookNumber
6        -   Data Entrega
7        -   Quantidade
8        -   Situação (Firme, Planejado....)
9        -   Quantidade Acumulado
10       -   Unidade
11       -   Planta (BH, CT,....)
12       -   Visto
13       -   Cod. Pasy na CNH (19848)
14       -   Nome fornecedor (Pasy Ind. e ......)
15       -   Nº Relatório ok
16       -   Data Relatório ok
17       -   Cód. de Status do Relatório
18       -   Status do Relatório
19       -   "Balance Out"
20       -   Estoque em Consignação
21       -   "Overshipped"
22       -   Data Início Acumulado
23       -   Ordem de Compra  ok
24       -   Linha da Ordem de Compra
25       -   Cód. de Envio
26       -   Nota do relatório 1
27       -   Nota do relatório 2
28       -   Nota do relatório 3
29       -   Nota do relatório 4
30       -   Nota do relatório 5
31       -   Nota do relatório 6
32       -   Nota do relatório 7
33       -   Nota do relatório 8
34       -   Nota do relatório 9
35       -   Nota do relatório 10
36       -   Envio para
37       -   Endereço para envio 1
38       -   Endereço para envio 2
39       -   Endereço para envio 3
40       -   Endereço para envio 4
41       -   Data última entrada
42       -   Qte da última entrada
43       -   Última Nota Fiscal   ok
44       -   Última Quantidade Acumulada
45       -   (Em branco)

*/

_cDir := "\CNH\CNH*.TXT"
_aArqTxt= ARRAY(ADIR(_cDir))
ADIR("\CNH\CNH*.TXT",_aArqTxt)

ProcRegua(Len(_aArqTxt))

For A:= 1 to Len(_aArqTxt)
	
	IncProc()
	
	_aStru:={}
	AADD(_aStru,{"CAMPO","C",700,0})
	_cArq:=CriaTrab(_aStrU,.T.)
	
	DbUseArea(.T.,,_cArq,"PROG",.F.,.F.)
	
	dbSelectArea("PROG")
	
	_cArqTxt := "\CNH\"+Alltrim(_aArqTxt[A])
	IF !FILE(_cArqTxt)
		dbSelectArea("PROG")
		dbCloseArea("PROG")
		
		Loop
	Endif
	
	APPEND FROM &_cArqTxt SDF
	DBGOTOP()
	
	dbSelectArea("PROG")
	_cArq2 := CriaTrab("",.f.)
	
	_cInd  := "SUBSTR(CAMPO,1,8)"
	IndRegua("PROG",_cArq2,_cInd,,,"Selecionando Arquivo de Itens...")
	
	dbSelectArea("PROG")
	dbGotop()
	
	While !eof()
		
		If Substr(PROG->CAMPO,1,7) == "PARTNBR"
			dbSelectArea("PROG")
			dbSkip()
			Loop
		Endif
		
		_nCont    := 0   // Existem 44 Virgulas
		_lGrupo   := .F.
		_cProdCli := ""
		_cRev     := ""
		_cNotRev  := ""
		_cDesc    := ""
		_cDtEnt   := ""
		_cQuant   := ""
		_cTpPed   := ""
		_cUm      := ""
		_cFilial  := ""
		_cRelato  := ""
		_cDtRelato:= ""
		_cOrdCom  := ""
		_cUltNF   := ""
		_cDtUltNf := ""
		
		
		For I:= 01 To Len(Alltrim(PROG->CAMPO))
			
			If Substr(PROG->CAMPO,I,1) == "," .And. !_lGrupo
				_nCont ++
			ElseIf Substr(PROG->CAMPO,I,1) == CHR(34)        // Comando CHR(34) é o caracter " .
				_lGrupo := .F.
			ElseIf Substr(PROG->CAMPO,I,1) != CHR(34)        // Comando CHR(34) é o caracter " .
				If _nCont != 0
					_lGrupo := .T.
				Endif
				
				If _nCont == 0
					_cProdcli  += Substr(PROG->CAMPO,I,1)    // Codigo do Produto do Cliente 11437785
				ElseIf _nCont == 1
					_cRev      += Substr(PROG->CAMPO,I,1)    // Revisao do Desenho 01
				ElseIf _nCont == 2
					_cNotRev   += Substr(PROG->CAMPO,I,1)    // Notas da Revisao
				ElseIf _nCont == 3
					_cDesc     += Substr(PROG->CAMPO,I,1)    // Descricao do Produto
				ElseIf _nCont == 6
					_cDtEnt    += Substr(PROG->CAMPO,I,1)    // Data de Entrega
				ElseIf _nCont == 7
					_cQuant    += Substr(PROG->CAMPO,I,1)    // Quantidade
				ElseIf _nCont == 8
					_cTpPed    += Substr(PROG->CAMPO,I,1)    // Tipo de Pedido
				ElseIf _nCont == 10
					_cUM       += Substr(PROG->CAMPO,I,1)    // Unidade de Medida
				ElseIf _nCont == 11
					_cFilial   += Substr(PROG->CAMPO,I,1)    // Filial do Cliente
				ElseIf _nCont == 15
					_cRelato   += Substr(PROG->CAMPO,I,1)    // NR Relatório
				ElseIf _nCont == 16
					_cDtRelato += Substr(PROG->CAMPO,I,1)    // Data Relatório
				ElseIf _nCont == 23
					_cOrdCom   += Substr(PROG->CAMPO,I,1)     // Ordem de Compra
				ElseIf _nCont == 41
					_cDtUltNf  += Substr(PROG->CAMPO,I,1)     // Data da Ultima Nota Fiscal
				ElseIf _nCont == 43
					_cUltNF    += Substr(PROG->CAMPO,I,1)     // Ultima Nota Fiscal
				Endif
			Endif
		Next I
		
		_cProdcli := PadR(_cProdcli,15)
		
		_dDtEnt    := cTod(Substr(_cDtEnt,7,2)+"/"+Substr(_cDtEnt,5,2)+"/"+Substr(_cDtEnt,3,2))
		_nQuant    := Val(_cQuant)
		_dDtMov    := cTod(Substr(_cDtRelato,7,2)+"/"+Substr(_cDtRelato,5,2)+"/"+Substr(_cDtRelato,3,2))
		_dDtUltNf  := cTod(Substr(_cDtUltNf,7,2) +"/"+Substr(_cDtUltNf,5,2) +"/"+Substr(_cDtUltNf,3,2))
		_cUltNF    := Strzero(Val(_cUltNF),6)
		
		If UPPER(_cTpPed ) == "FIRM"   // Pedido Firme
			_cTpPed := "N"
		ElseIf UPPER(_cTpPed ) == "PLANNING" // Pedido Planejado
			_cTpPed := "Z"
		Endif
		
		_cLoja     := ""
		_cCliente  := "000071"
		_cLj       := ""
		If Alltrim(_cFilial)      == "BH"
			_cLoja     := "07"
		ElseIf	Alltrim(_cFilial) == "CT"
			_cLoja     := "11"
		ElseIf	Alltrim(_cFilial) == "I1"
			_cLoja     := "08"
		ElseIf	Alltrim(_cFilial) == "I2"
			_cLoja     := "10"
		ElseIf	Alltrim(_cFilial) == "I3"
			_cLoja     := "09"
			_cLj       := "3"
		ElseIf	Alltrim(_cFilial) == "I4"
			_cLoja     := "09"
			_cLj       := "4"
		Endif
		
		dbSelectArea("SA1")
		dbSetOrder(1)
		If !dbSeek(xFilial("SA1")+_cCliente + _cLoja)
			dbSelectArea("Prog")
			dbSkip()
			Loop
		Endif
		
		_cProdPasy := ""
		dbSelectArea("SZ2")
		dbSetOrder(6)
		If dbSeek(xFilial("SZ2")+_cCliente + _cLoja  + _cProdCli + "1")
			_cProdPasy := SZ2->Z2_PRODUTO
		Else
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->PRODCLI := _cProdCli
			TRB->CLIENTE := _cCliente
			TRB->LOJA    := _cLoja
			MsUnlock()
		Endif
		
		dbSelectArea("SZ4")
		RecLock("SZ4",.T.)
		SZ4->Z4_FILIAL  := xFilial("SZ4")
		SZ4->Z4_CODCLI  := _cCliente
		SZ4->Z4_LOJA    := _cLoja
		SZ4->Z4_PRODPAS := _cProdPasy
		SZ4->Z4_PRODCLI := _cProdCli
		SZ4->Z4_DTMOV   := _dDtMov
		SZ4->Z4_CONTROL := _cRelato
		SZ4->Z4_TIPO    := _cTpPed
		SZ4->Z4_ULTNF   := _cUltNf
		SZ4->Z4_DTULTNF := _dDtUltNf
		SZ4->Z4_DTENT   := _dDTEnt
		SZ4->Z4_QTENT   := _nQuant
		SZ4->Z4_PEDIDO  := _cOrdCom
		SZ4->Z4_TPPED   := _cTpPed
		SZ4->Z4_DTDIGIT := MV_PAR01
		SZ4->Z4_ALTTEC  := _cRev
		SZ4->Z4_IMPRES  := _cLj
		MsUnlock()
		
		dbSelectArea("PROG")
		dbSkip()
	EndDo
	
	_cHora    := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
	
//	_cArqNovo := "\CNH\BKP_PROGCNH"+DTOS(DDATABASE) + _cHora+".txt"
	_cArqNovo := "\CNH\BKP_"+Alltrim(_aArqTxt[A])
	dbSelectArea("PROG")
	Copy all to &_cArqNovo
	
	dbCloseArea("PROG")
	
	FErase(_cArqTxt)
	
Next A

Return


Static Function Pa64A()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private _lPrim,_lPrim4,_cItem3,_cItem4,_lAchou,_nPrcVen,_cNum3,_cNum4,_lVerFat
Private _cItem := ""

_bAcao01   := {|_lFim| INTNOV(@_lFim) }
_cTitulo01 := 'Integrando Pedido!!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_bAcao01   := {|_lFim| Imp1(@_lFim) }
_cTitulo01 := 'Integrando Pedido!!!!'//'Imprimindo'
RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Private _lNAchou   := .F.
Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.

_bAcao01   := {|_lFim| VerMov(@_lFim) }
_cTitulo01 := 'Imprimindo Inconsistencia'
RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

If _lNAchou
	SET DEVICE TO SCREEN
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
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

dbSelectArea("SZ4")
dbSetOrder(4)
dbSeek(xFilial("SZ4")+DTOS(MV_PAR01),.t.)

SetRegua(RecCount())

While !Eof() .And. SZ4->Z4_DTDIGIT == MV_PAR01
	
	_lPrim    := .F.
	_lPrim4    := .F.
	_nTotQt    := 0
	_cItem3    := "00"
	_cItem4    := "00"
	_cClieLoja := SZ4->Z4_CODCLI + SZ4->Z4_LOJA
	
	dbSelectArea("SZ4")
	
	While !Eof() .And.	_cClieLoja == SZ4->Z4_CODCLI + SZ4->Z4_LOJA
		
		If Empty(SZ4->Z4_PRODPAS)
			dbSelectArea("SZ4")
			dbSkip()
			Loop
		Endif
		
		If SZ4->Z4_CODCLI != "000071"
			dbSelectArea("SZ4")
			dbSkip()
			Loop
		Endif
		
		IncRegua()
		
		_cProdCli := SZ4->Z4_PRODCLI
		_nSubQt   := 0
		/*
		dbSelectArea("SZ2")
		dbSetOrder(1)
		If !dbSeek(xFilial("SZ2")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA+SZ4->Z4_PRODPAS+SZ4->Z4_PRODCLI+"1")
		dbSelectArea("SZ4")
		dbSkip()
		Loop
		Endif
		*/
		dbSelectArea("SZ2")
		dbSetOrder(6)
		If !dbSeek(xFilial("SZ2") + SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODCLI + "1")
			dbSelectArea("SZ4")
			dbSkip()
			Loop
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
		
		ZERAPED()
		
		dbSelectArea("SZ4")
		_lVerFat := .t.
		
		While !Eof() .And. _cProdCli == SZ4->Z4_PRODCLI
			
			If _lFim
				Alert("Cancelado Pelo Usuario!!!!!!")
				Return
			Endif
			
			IncRegua()
			
			INTSC6C()
			
			dbSelectArea("SZ4")
			RecLock("SZ4",.F.)
			SZ4->Z4_INTEGR := "S"
			MsUnlock()
			
			dbSelectArea("SZ4")
			_nRecSz4 := Recno()
			dbSkip()
		EndDo
		
		dbSelectArea("SZ4")
		dbGoto(_nRecSZ4)
		
		ELIMR()
		
		dbSelectArea("SZ4")
		dbSkip()
	EndDo
EndDo

dbSelectArea("SZ4")

Return


Static Function ZeraPed()

dbSelectArea("SC6")
dbOrderNickName("INDSC61")
If dbSeek(xFilial("SC6")+ SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + SZ4->Z4_PRODCLI)
	
	_cChavSC6 := SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI
	While !Eof() .And. 	_cChavSC6 == SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI
		
		If (SC6->C6_QTDVEN == SC6->C6_QTDENT) .Or. !Empty(SC6->C6_BLQ)
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SC6")
		RecLock("SC6",.F.)
		SC6->C6_IDENCAT := ""
		MsUnlock()
		
		dbSelectArea("SC6")
		dbSkip()
	EndDo
Endif

Return


Static Function IntSC6C()

_nFatur := 0

If VAL(SZ4->Z4_ULTNF) > 0
	_cUltNf := SZ4->Z4_ULTNF + "01"
Else
	_cUltNf := "00000101"
Endif

dbSelectArea("SD2")
dbOrderNickName("INDSD26")
dbSeek(xFilial("SD2")+ SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + _cUltNf,.T.)

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
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO + SD2->D2_ITEMPV)
		If Alltrim(SC6->C6_PEDCLI) != Alltrim(SZ4->Z4_PEDIDO)
			dbSelectArea("SD2")
			dbSkip()
			Loop
		Endif
	Endif
	
	_nFatur2 := _nFatur
	_nFatur  += SD2->D2_QUANT - SD2->D2_PROGENT
	
	If _nFatur >= SZ4->Z4_QTENT
		_nDif  := SZ4->Z4_QTENT - _nFatur2
	Else
		_nDif  := SD2->D2_QUANT - SD2->D2_PROGENT
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

_lAchou   := .F.

dbSelectArea("SC6")
dbOrderNickName("INDSC61")
If dbSeek(xFilial("SC6")+ SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + SZ4->Z4_PRODCLI + DTOS(SZ4->Z4_DTENT))
	
	_cChavSC62 := SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + DTOS(SC6->C6_ENTREG)
	
	While !Eof() .And. 	_cChavSC62 == SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + DTOS(SC6->C6_ENTREG)
		
		If (SC6->C6_QTDVEN == SC6->C6_QTDENT) .Or. !Empty(SC6->C6_BLQ)
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		If (SC6->C6_QTDVEN - SC6->C6_QTDENT) != SZ4->Z4_QTENT - _nFatur
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SC6")
		RecLock("SC6",.F.)
		SC6->C6_IDENCAT := DTOS(MV_PAR01)
		If SZ4->Z4_TPPED = "N"
			SC6->C6_PEDAMOS := "N"
		Endif
		MsUnlock()
		
		_lAchou := .T.
		
		dbSelectArea("SC6")
		dbSkip()
	EndDo
Endif

If !_lAchou
	
	_lVerFat := .F.
	_cItem   := SomaIt(_cItem)
	
	If !_lPrim .Or. _cItem == "ZZ"
		_cItem  := "01"
		_cNum  := GETSXENUM("SC5","C5_NUM")
		CONFIRMSX8()
		_lPrim := .T.
		
		_cPedido := _cNum
		_lIncSC6 := .F.
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA)
		
		dbSelectArea("SC5")
		RecLock("SC5",.T.)
		SC5->C5_FILIAL  := xFilial("SC5")
		SC5->C5_NUM     := _cNum
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
	
	dbSelectArea("SF4")
	dbSetOrder(1)
	dbSeek(xFilial("SF4")+SZ2->Z2_TES)
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SZ4->Z4_PRODPAS)
	
	dbSelectArea("SC6")
	RecLock("SC6",.T.)
	SC6->C6_FILIAL  := xFilial("SC6")
	SC6->C6_NUM     := _cNUm
	SC6->C6_ITEM    := _cItem
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
	SC6->C6_IDENCAT := SZ4->Z4_SEMATU
	MsUnlock()
Endif

dbSelectArea("SZ4")

Return


Static Function ELIMR()

_cIdenCat := StrZero(Val(SZ4->Z4_SEMATU)-1,9)

dbSelectArea("SC6")
dbOrderNickName("INDSC61")
If dbSeek(xFilial("SC6")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA+SZ4->Z4_PRODPAS + SZ4->Z4_PRODCLI)//+DTOS(SZ4->Z4_DTENT))
	
	_cChavSC6 := SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO //+ DTOS(SC6->C6_ENTREG)
	
	ProcRegua(LastRec())
	
	While !Eof() .And. _cChavSC6 == SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO //+ DTOS(SC6->C6_ENTREG)
		
		IncProc()
		
		If !Empty(SC6->C6_BLQ) .Or. SC6->C6_PEDAMOS == "D"
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		If SC6->C6_QTDVEN == SC6->C6_QTDENT
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		If	SC6->C6_IDENCAT == SZ4->Z4_SEMATU
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
		
		If Alltrim(SC6->C6_PEDCLI) != Alltrim(SZ4->Z4_PEDIDO)
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SC6")
		RecLock("SC6",.F.)
		SC6->C6_BLQ     := "R"
		SC6->C6_XDTELIM := dDataBase
		SC6->C6_LOCALIZ := "PA0064"
		MsUnLock()
		
		dbSelectArea("SC6")
		dbSkip()
	EndDo
Endif

Return



Static Function VerMov()

_lNAchou := .F.

dbSelectArea("TRB")
dbGotop()

If !Empty(TRB->PRODCLI)
	
	dbSelectArea("TRB")
	ProcRegua(RecCount())
	
	While !Eof()
		
		IncProc()
		
		If nLin > 57
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		_lNAchou := .T.
		@nLin,00  PSAY "PRODUTO CLIENTE NAO CADASTRADO "+TRB->PRODCLI+" "+TRB->CLIENTE+"-"+TRB->LOJA
		nLin++
		
		dbSelectArea("TRB")
		dbSkip()
	EndDo
Endif

Return
