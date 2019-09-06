#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ PA0023  ³ Autor ³ Alexandro da Silva     ³ Data ³ 14/04/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relacao de Pedidos aptos a faturar                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0023()

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE")
SetPrvt("CSTRING,LCONTINUA,AORD,ARETURN,NOMEPROG,ALINHA")
SetPrvt("NLASTKEY,CPERG,WNREL,NVALIPI,NTOTIPI,CDESCORDEM")
SetPrvt("LIMP,ACAMPOS,ATAM,CTIPO,NC,NQTLIB")
SetPrvt("NQTBLOQ,AQUANT,NVEND,NORDEM,NTQTDE,NTPED")
SetPrvt("NTQLIB,NTQBLOQ,NTQENT,NTIPO,CBTXT,CBCONT")
SetPrvt("LI,M_PAG,CABEC1,CABEC2,CTRAB,CCOND")
SetPrvt("NAG1,NAG2,NAG3,CPEDANT,NAC1,NAC2")
SetPrvt("LFIRST,LRET,CVENDS,LBARRA,I,CVEND")
SetPrvt("NTOTLOCAL,NTOTFAT,NVALDESC,CDESCTAB,NRET,CALIAS")
SetPrvt("NPOS,NIPI,NF4REDUCAO,NPORIMP,CIMP,NBASEIPI")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private CbTxt
Private CbCont,cabec1,cabec2,wnrel
Private titulo    := OemToAnsi("Relacao de Pedidos de Vendas")
Private cDesc1    := OemToAnsi("Este programa ira emitir a relacao  dos Pedidos de Vendas")
Private cDesc2    := OemToAnsi("Sera feita a pesquisa no almoxarifado e verificado")
Private cDesc3    := OemToAnsi("se a quantidade esta disponivel")
Private tamanho   := "G"
Private limite    := 220
Private cString   := "SC6"
Private lContinua := .T.
Private aOrd      := {OemToAnsi(" Por pedido      "),OemToAnsi(" Por produto      "),OemToAnsi(" Por data entrega "),OemToAnsi(" Por Cliente ")}

PRIVATE aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
PRIVATE nomeprog  := "PA0023"
PRIVATE aLinha    := { },nLastKey := 0
PRIVATE cPerg     :="PA0023"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("PA0023",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                            ³
//³ mv_par01        	// Do Pedido                                ³
//³ mv_par02        	// Ate o Pedido                             ³
//³ mv_par03        	// Do Produto                               ³
//³ mv_par04 	     	// Ate o Produto                            ³
//³ mv_par05 	     	// Mascara                                  ³
//³ mv_par06 	     	// Aptos a Faturar Nao Aptos Todos          ³
//³ mv_par07 	     	// Soma Ipi ao Tot Sim Nao                  ³
//³ mv_par08 	     	// Qual moeda                               ³
//³ mv_par09 	     	// Quanto ao Tes- Gera Dupl, Nao Gera, Todos³
//³ mv_par10 	     	// Data de Entrega De                       ³
//³ mv_par11 	     	// Data de Entrega Ate                      ³
//³ mv_par12 	     	// Cliente De                               ³
//³ mv_par13 	     	// Cliente Ate                              ³
//³ mv_par14 	     	// Loja De                                  ³
//³ mv_par15 	     	// Loja Ate                                 ³
//³ mv_par16 	     	// Grupo De                                 ³
//³ mv_par17 	     	// Grupo Ate                                ³
//³ mv_par18 	     	// SubGrupo De                              ³
//³ mv_par19 	     	// SubGrupo Ate                             ³

//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄ¿

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="PA0023"

dbSelectArea("SC6")
wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho)

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

PRIVATE CbTxt
PRIVATE CbCont,cabec1,cabec2
PRIVATE titulo := OemToAnsi("Relacao de Pedidos de Vendas")
PRIVATE cDesc1 := OemToAnsi("Este programa ira emitir a relacao  dos Pedidos de Vendas")
PRIVATE cDesc2 := OemToAnsi("Sera feita a pesquisa no almoxarifado e verificado")
PRIVATE cDesc3 := OemToAnsi("se a quantidade esta disponivel")
PRIVATE tamanho:= "G"
PRIVATE limite := 220
PRIVATE lContinua := .T.
PRIVATE nAc1,nAg1,nAc2,nAg2,nTipo,cPedant,nValIPI:=nTotIpi:=0
PRIVATE cTrab, cDescOrdem:="", lFirst, lImp := .F.
PRIVATE aOrd   :={" Por pedido      "," Por produto      "," Por data entrega "}
PRIVATE aCampos:={}
PRIVATE aTam   :={}
PRIVATE cTipo  :=""
PRIVATE nC		 :=1
PRIVATE nQtLib :=0
PRIVATE nQtBloq:=0
PRIVATE aQuant :={}
PRIVATE nVend  := Fa440cntVen()
PRIVATE nOrdem := aReturn[8]
PRIVATE nTQtde := 0
PRIVATE nTPed  := 0
PRIVATE nTQLib := 0
PRIVATE nTQBLoq:= 0
PRIVATE nTQEnt := 0

nTipo:= GetMv("MV_COMP")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o cabelho do relatorio                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cabec1 := "IT CODIGO PRODUTO  DESCRICAO DO PRODUTO            ESTOQUE        -----------  PEDIDO  --------------     QUANTIDADE     QUANTIDADE         VALOR DO        PRECO UNITARIO                       VALOR A"
cabec2 := "                                                  DISPONIVEL    VENDIDO     ATENDIDO      SALDO     LIBERADA    BLOQUEADA    DESCONTO    LIQUIDO     ORDEM DE PRODUCAO      VALOR DO IPI               FATURAR       ENTREGA"
// 0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19       20        21
// 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789

/*
IT CODIGO PRODUTO  DESCRICAO DO PRODUTO            ESTOQUE        -----------  PEDIDO  --------------     QUANTIDADE     QUANTIDADE         VALOR DO        PRECO UNITARIO                       VALOR A"
99 999999999999999 999999999999999999999999999999 99999999999 99999999999 99999999999 99999999999 99999999999 99999999999 99999999999 99999999999   9999999999999999999999999 99999999999999999 99999999999999999 9999999999
0  3               19                             50          62          74          86          98          110         122         134           148                       174               192               210
DISPONIVEL    VENDIDO     ATENDIDO      SALDO     LIBERADA    BLOQUEADA    DESCONTO    LIQUIDO     ORDEM DE PRODUCAO      VALOR DO IPI               FATURAR       ENTREGA"
0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19       20        21
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
*/


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("B2_LOCAL")
AADD(aCampos,{ "TB_LOCAL" ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("B2_COD")
AADD(aCampos,{ "TB_COD"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("B2_VATU1")
AADD(aCampos,{ "TB_SALDO" ,"N",aTam[1],aTam[2] } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta arquivo de trabalho para baixar estoque na listagem    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTrab:= CriaTrab(aCampos)

USE &cTrab ALIAS STB NEW
IndRegua("STB",cTrab,"TB_LOCAL+TB_COD",,,"Selecionando Registros...")

If nOrdem != 4
	RptStatus({|lEnd| C700Imp(@lEnd,wnRel,cString)},Titulo)
Else
	RptStatus({|lEnd| ImpOrd4(@lEnd,wnRel,cString)},Titulo)
Endif
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C700IMP  ³ Autor ³ Rosane Luciane Chene  ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR700 		                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function C700Imp(lEnd,WnRel,cString)

dbSelectArea("SC6")
dbSetOrder(nOrdem)
If nOrdem = 1
	dbSeek(xFilial("SC6")+mv_par01,.T.)
	cDescOrdem:= "PEDIDO"
	cCond := "SC6->C6_NUM <= mv_par02"
ElseIf nOrdem = 2
	dbSeek(xFilial("SC6")+mv_par03,.T.)
	cDescOrdem:= "PRODUTO"
	cCond := "SC6->C6_PRODUTO <= mv_par04"
	
ELSEIf nOrdem = 3
	cDescOrdem:= "DATA DE ENTREGA"
	cCond := ".T."
	dbSeek(xFilial("SC6"))
Else
	dbSetOrder(5)
	dbSeek(xFilial("SC6")+mv_par12,.T.)
	cDescOrdem:= "CLIENTE"
	cCond := "SC6->C6_CLI <= mv_par13"
ENDIF

IF MV_PAR06 == 1
	cTipo := " APTOS A FATURAR "
ELSEIF MV_PAR06 == 2
	cTipo := " NAO LIBERADOS   "
ELSE
	cTipo := ""
ENDIF
titulo += cTipo +  " - ORDEM DE "  + cDescOrdem + " - " + GetMv("MV_MOEDA"+STR(mv_par08,1))

SetRegua(RecCount())		// Total de Elementos da regua

nAg1   := nAg2:=  nAg3:= 0

While !Eof() .And. xFilial("SC6")==SC6->C6_FILIAL .And. lContinua .and. &cCond
	
	IF lEnd
		@ Prow()+1,001 Psay "CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	Endif
	
	IncRegua()
	If	(SC6->C6_NUM < mv_par01 .Or. SC6->C6_NUM > mv_par02) .or. (SC6->C6_QTDVEN-SC6->C6_QTDENT <= 0 .Or. Alltrim(SC6->C6_BLQ) == "R") //residuo
		dbSelectArea("SC6")
		dbSkip()
		Loop
	Endif
	
	If SC6->C6_ENTREG < MV_PAR10 .Or. SC6->C6_ENTREG > MV_PAR11 .Or.;
		SC6->C6_CLI    < MV_PAR12 .Or. SC6->C6_CLI    > MV_PAR13 .Or.;
		SC6->C6_LOJA   < MV_PAR14 .Or. SC6->C6_LOJA   > MV_PAR15
		dbSelectArea("SC6")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+SC6->C6_PRODUTO )
		If SB1->B1_GRUPO < MV_PAR16  .Or. SB1->B1_GRUPO > MV_PAR17 .Or.;
			SB1->B1_SUBGR < MV_PAR18  .Or. SB1->B1_SUBGR > MV_PAR19
			dbSelectArea("SC6")
			dbSkip()
			Loop
		EndIf
	Endif
	
	aQuant := a700Bloq()
	For nC := 1 To Len(aQuant)
		nQtlib += aQuant[nC,2]
		nQtBloq+= aQuant[nC,3]
	Next nC
	
	If mv_par06 == 1 .And. nQtLib == 0
		dbSelectArea("SC6")
		dbSkip()
		Loop
	ElseIf mv_par06 == 2 .And. nQtBloq == 0
		dbSelectArea("SC6")
		dbSkip()
		Loop
	Endif
	
	cPedant := SC6->C6_NUM
	nAc1:= nAc2:=  nValIpi := nTotIpi := 0
	nQtlib := nQtBloq := 0
	lFirst := .T.
	
	dbSelectArea("SC6")
	
	While !Eof() .and. xFilial("SC6")==SC6->C6_FILIAL .And. cPedant == SC6->C6_NUM .And. lContinua
		
		IF lEnd
			@ Prow()+1,001 Psay "CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		Endif
		IncRegua()
		
		If	(SC6->C6_NUM < mv_par01 .Or. SC6->C6_NUM > mv_par02) .or. (SC6->C6_QTDVEN-SC6->C6_QTDENT <= 0 .Or. Alltrim(SC6->C6_BLQ) == "R") //residuo
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		If SC6->C6_ENTREG < MV_PAR10 .Or. SC6->C6_ENTREG > MV_PAR11 .Or.;
			SC6->C6_CLI    < MV_PAR12 .Or. SC6->C6_CLI    > MV_PAR13 .Or.;
			SC6->C6_LOJA   < MV_PAR14 .Or. SC6->C6_LOJA   > MV_PAR15
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+SC6->C6_PRODUTO )
			If SB1->B1_GRUPO < MV_PAR16  .Or. SB1->B1_GRUPO > MV_PAR17 .Or.;
				SB1->B1_SUBGR < MV_PAR18  .Or. SB1->B1_SUBGR > MV_PAR19
				dbSelectArea("SC6")
				dbSkip()
				Loop
			EndIf
		Endif
		
		If	SC6->C6_PRODUTO < mv_par03 .Or. SC6->C6_PRODUTO > mv_par04
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se ser  considerado pelo TES qto gerac. duplic. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek (xFilial("SF4")+SC6->C6_TES)
		dbSelectArea("SC6")
		If ( SF4->F4_DUPLIC == "S" .And. mv_par09 == 2 ) .Or. ( SF4->F4_DUPLIC != "S" .And. mv_par09 == 1 )
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+SC6->C6_PRODUTO )
			If SB1->B1_GRUPO < MV_PAR16  .Or. SB1->B1_GRUPO > MV_PAR17 .Or.;
				SB1->B1_SUBGR < MV_PAR18  .Or. SB1->B1_SUBGR > MV_PAR19
				dbSelectArea("SC6")
				dbSkip()
				Loop
			EndIf
		Endif

		_cPed := ""
		For Ax:= 1 To Len(MV_PAR20)
			If Substr(MV_PAR20,AX,1) != "*"
			   _cPed += Substr(MV_PAR20,AX,1)+ "/"
		    Endif
		Next AX         
		
		If !SC6->C6_PEDAMOS $ _cPed
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SC6")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o pedido de venda esta apto a faturar(nQtLib!=0) ³
		//³ ou com bloqueio(nQtBloq!=0) , conforme o parametro mv_par06  ³
		//³ seleciona os reguistros a serem impressos                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aQuant := a700Bloq()
		For nC := 1 To Len(aQuant)
			nQtlib += aQuant[nC,2]
			nQtBloq+= aQuant[nC,3]
		Next nC
		
		If mv_par06 == 1 .And. nQtLib == 0
			dbSkip()
			Loop
		ElseIf mv_par06 == 2 .And. nQtBloq == 0
			dbSkip()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida o produto conforme a mascara         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lRet:=ValidMasc(SC6->C6_PRODUTO,MV_PAR05)
		If !lRet
			dbSkip()
			Loop
		Endif
		
		If SC6->C6_QTDVEN-SC6->C6_QTDENT <= 0  .Or. Alltrim(SC6->C6_BLQ) == "R" // residuo
			dbSkip()
			Loop
		Endif
		
		If lFirst
			ImprPed(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,nVend)
			lFirst := .F.
		EndIf
		
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			ImprPed(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,nVend)
		EndIF
		
		lImp := .T.
		
		ImpProd(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,nQtLib,nQtBloq)
		
		nTQLib  += nQtLib
		nTQBloq += nQtBloq
		nTQtde  += SC6->C6_QTDVEN
		nTQEnt  += SC6->C6_QTDENT
		nTPed   += xMoeda(SC6->C6_PRCVEN,SC5->C5_MOEDA,MV_PAR08,SC5->C5_EMISSAO)
		nQtlib  := nQtBloq := 0
		nAc1	  +=CalValFat()
		nAc2    += CalValDes()
		nValIpi :=A700Ipi(SC6->C6_TES,SC6->C6_PRODUTO,CalValFat())
		If mv_par07 == 1
			nAc1 += nValIPI
		Endif
		nTotIPI +=nValIPI
		li++
		dbSelectArea("SC6")
		dbSkip()
	Enddo
	
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	
	If lImp
		@li,  0 Psay "TOTAL DO PEDIDO--> "
		@li,122 Psay nAc2          	PicTure tm(nAc2,11) //118
		If nTotIpi > 0
			@li,174 Psay nTotIpi	Picture PesqPict("SC6","C6_VALOR",17) //170
		Endif
		@li,192 Psay nAc1	        PicTure tm(nAc1,17)
		li   += 2
		lImp := .F.
	EndIf
	nAg1 += nAc1
	nAg2 += nAc2
	nAg3 += nTotIpi
Enddo

IF nAg1 != 0
	
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	
	@li,  0 Psay  "TOTAL GERAL--> "
	@li, 62 Psay nTQtde				PicTure PesqPictQt("C6_QTDVEN",11)
	@li, 74 Psay nTQent	         PicTure PesqPictQt("C6_QTDENT",11)
	@li, 86 Psay (nTQtde-nTQEnt)	PicTure PesqPictQt("C6_QTDVEN",11)
	@li, 98 Psay nTQLib				Picture PesqPictQt("C6_QTDVEN",11)
	@li,110 Psay nTQBloq				Picture PesqPictQt("C6_QTDVEN",11)
	@li,122 Psay nAg2					PicTure tm(nAg2,11)
//	@li,134 Psay nTPed				PicTure PesqPict("SC6","C6_PRCVEN",11)
	if nAg3 > 0
		@li,174 Psay nAg3 Picture PesqPict("SC6","C6_VALOR",17)
	endif
	@li,192 Psay nAg1	PicTure tm(nAg1,17)
	li++
	
EndIF

IF li != 80
	roda(cbcont,cbtxt,Tamanho)
EndIF

dbSelectArea("STB")
dbCloseArea()
fErase(cTrab+".DBF")
fErase(cTrab+OrdBagExt())

RetIndex("SC6")
dbSelectArea("SC6")
Set Filter To
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()

Return

Static Function ImpOrd4(lEnd,WnRel,cString)


dbSelectArea("SC6")
dbOrderNickName("INDSC62")
dbSeek(xFilial("SC6")+mv_par12,.T.)
cDescOrdem:= "CLIENTE"
cCond := "SC6->C6_CLI <= mv_par13"

IF MV_PAR06 == 1
	cTipo := " APTOS A FATURAR "
ELSEIF MV_PAR06 == 2
	cTipo := " NAO LIBERADOS   "
ELSE
	cTipo := ""
ENDIF

titulo += cTipo +  " - ORDEM DE "  + cDescOrdem + " - " + GetMv("MV_MOEDA"+STR(mv_par08,1))

SetRegua(RecCount())		// Total de Elementos da regua

nAg1     := nAg2     :=  nAg3   := 0
_nGeDesc := _nGeaFat := _nGeIPI := 0

While !Eof() .And. lContinua .and. SC6->C6_CLI <= mv_par13
	
	IF lEnd
		@ Prow()+1,001 Psay "CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	Endif
	
	IncRegua()
	
	If	(SC6->C6_NUM < mv_par01 .Or. SC6->C6_NUM > mv_par02) .or. (SC6->C6_QTDVEN-SC6->C6_QTDENT <= 0 .Or. Alltrim(SC6->C6_BLQ) == "R")
		dbSelectArea("SC6")
		dbSkip()
		Loop
	Endif
	
	If SC6->C6_ENTREG  < MV_PAR10 .Or. SC6->C6_ENTREG > MV_PAR11 .Or.;
		SC6->C6_CLI    < MV_PAR12 .Or. SC6->C6_CLI    > MV_PAR13 .Or.;
		SC6->C6_LOJA   < MV_PAR14 .Or. SC6->C6_LOJA   > MV_PAR15
		dbSelectArea("SC6")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+SC6->C6_PRODUTO )
		If SB1->B1_GRUPO  < MV_PAR16  .Or. SB1->B1_GRUPO > MV_PAR17 .Or.;
			SB1->B1_SUBGR < MV_PAR18  .Or. SB1->B1_SUBGR > MV_PAR19
			dbSelectArea("SC6")
			dbSkip()
			Loop
		EndIf
	Endif
	
	aQuant := a700Bloq()
	For nC := 1 To Len(aQuant)
		nQtlib += aQuant[nC,2]
		nQtBloq+= aQuant[nC,3]
	Next nC
	
	If mv_par06 == 1 .And. nQtLib == 0
		dbSelectArea("SC6")
		dbSkip()
		Loop
	ElseIf mv_par06 == 2 .And. nQtBloq == 0
		dbSelectArea("SC6")
		dbSkip()
		Loop
	Endif
	
	_cCliLoja := SC6->C6_CLI+SC6->C6_LOJA
	nAc1      := nAc2:=  nValIpi := nTotIpi := 0
	nQtlib    := nQtBloq := 0
	lFirst    := .T.
	 
	_nCliDesc := _nCliaFat := _nCliIPI := 0
	dbSelectArea("SC6")
	
	While !Eof() .and. _cCliLoja == SC6->C6_CLI+SC6->C6_LOJA .And. lContinua
		
	    _cPedido := SC6->C6_NUM
	    
	    _nToPed   := nAc2:=  nValIpi := nTotIpi := 0
	    	    
	    While !Eof() .And.	_cPedido == SC6->C6_NUM
		
			IF lEnd
				@ Prow()+1,001 Psay "CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
			Endif
			IncRegua()
		
			If	(SC6->C6_NUM < mv_par01 .Or. SC6->C6_NUM > mv_par02) .or. (SC6->C6_QTDVEN-SC6->C6_QTDENT <= 0 .Or. Alltrim(SC6->C6_BLQ) == "R")
				dbSelectArea("SC6")
				dbSkip()
				Loop
			Endif
		
			If SC6->C6_ENTREG  < MV_PAR10 .Or. SC6->C6_ENTREG > MV_PAR11 .Or.;
				SC6->C6_CLI    < MV_PAR12 .Or. SC6->C6_CLI    > MV_PAR13 .Or.;
				SC6->C6_LOJA   < MV_PAR14 .Or. SC6->C6_LOJA   > MV_PAR15
				dbSelectArea("SC6")
				dbSkip()
				Loop
			Endif
		
			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+SC6->C6_PRODUTO )
				If SB1->B1_GRUPO  < MV_PAR16  .Or. SB1->B1_GRUPO > MV_PAR17 .Or.;
					SB1->B1_SUBGR < MV_PAR18  .Or. SB1->B1_SUBGR > MV_PAR19
					dbSelectArea("SC6")
					dbSkip()
					Loop
				EndIf
			Endif
		
			If	SC6->C6_PRODUTO < mv_par03 .Or. SC6->C6_PRODUTO > mv_par04
				dbSelectArea("SC6")
				dbSkip()
				Loop
			Endif
		
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek (xFilial("SF4")+SC6->C6_TES)
			dbSelectArea("SC6")
			If ( SF4->F4_DUPLIC == "S" .And. mv_par09 == 2 ) .Or. ( SF4->F4_DUPLIC != "S" .And. mv_par09 == 1 )
				dbSelectArea("SC6")
				dbSkip()
				Loop
			Endif
			
			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+SC6->C6_PRODUTO )
				If SB1->B1_GRUPO  < MV_PAR16  .Or. SB1->B1_GRUPO > MV_PAR17 .Or.;
					SB1->B1_SUBGR < MV_PAR18  .Or. SB1->B1_SUBGR > MV_PAR19
					dbSelectArea("SC6")
					dbSkip()
					Loop
				EndIf
			Endif
		
			_cPed := ""
			For Ax:= 1 To Len(MV_PAR20)
				If Substr(MV_PAR20,AX,1) != "*"
				   _cPed += Substr(MV_PAR20,AX,1)+ "/"
			    Endif
			Next AX         
		
			If !SC6->C6_PEDAMOS $ _cPed
				dbSelectArea("SC6")
				dbSkip()
				Loop
			Endif
		
			dbSelectArea("SC6")
			aQuant := a700Bloq()
			For nC := 1 To Len(aQuant)
				nQtlib += aQuant[nC,2]
				nQtBloq+= aQuant[nC,3]
			Next nC
		
			If mv_par06 == 1 .And. nQtLib == 0
				dbSkip()
				Loop
			ElseIf mv_par06 == 2 .And. nQtBloq == 0
				dbSkip()
				Loop
			Endif
		
			lRet:=ValidMasc(SC6->C6_PRODUTO,MV_PAR05)
			If !lRet
				dbSkip()
				Loop
			Endif
		
			If SC6->C6_QTDVEN-SC6->C6_QTDENT <= 0  .Or. Alltrim(SC6->C6_BLQ) == "R"
				dbSkip()
				Loop
			Endif
		
			If lFirst
				ImprPed(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,nVend)
				lFirst := .F.
			EndIf
		
			IF li > 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
				ImprPed(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,nVend)
			EndIF
		
			lImp := .T.
		
			ImpProd(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,nQtLib,nQtBloq)
        	
        	_nDesc  := CalValDes()
        	_nValor := CalValFat()
			nTQLib  += nQtLib
			nTQBloq += nQtBloq
			nTQtde  += SC6->C6_QTDVEN
			nTQEnt  += SC6->C6_QTDENT
			nTPed   += xMoeda(SC6->C6_PRCVEN,SC5->C5_MOEDA,MV_PAR08,SC5->C5_EMISSAO)
			nQtlib  := nQtBloq := 0
			nAc1    += _nValor
			nAc2    += _nDesc

			nValIpi  := A700Ipi(SC6->C6_TES,SC6->C6_PRODUTO,CalValFat())			
			
        	_nCliDesc += _nDesc
        	_nCliaFat += _nValor
        	_nCliIPI  += nValIPI
			
			If mv_par07 == 1
				nAc1 += nValIPI
				_nCliAFat += nValIPI
			Endif
			nTotIPI +=nValIPI
			li++
			dbSelectArea("SC6")
			dbSkip()
		Enddo
    EndDo

	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF

	If lImp
		@li,  0 Psay "TOTAL DO CLIENTE--> "
		@li,122 Psay _nCliDesc          	PicTure tm(_nCliDesc,11) //118
		If _nCliIPI > 0
			@li,174 Psay _nCliIPI       	Picture PesqPict("SC6","C6_VALOR",17) //170
		Endif
		@li,192 Psay _nCliaFat   	        PicTure tm(_nCliaFat,17)
		li   += 2
		lImp := .F.
	EndIf
	nAg1 += nAc1
	nAg2 += nAc2
	nAg3 += nTotIpi
	
	_nGeDesc += _nCliDesc
	_nGeIPI  += _nCliIPI
	_nGeaFat += _nCliaFat

Enddo

IF nAg1 != 0
	
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	
	@li,  0 Psay  "TOTAL GERAL--> "
	@li, 62 Psay nTQtde				PicTure PesqPictQt("C6_QTDVEN",11)
	@li, 74 Psay nTQent	            PicTure PesqPictQt("C6_QTDENT",11)
	@li, 86 Psay (nTQtde-nTQEnt)	PicTure PesqPictQt("C6_QTDVEN",11)
	@li, 98 Psay nTQLib				Picture PesqPictQt("C6_QTDVEN",11)
	@li,110 Psay nTQBloq			Picture PesqPictQt("C6_QTDVEN",11)
	@li,122 Psay _nGeDesc			PicTure tm(_nGeDesc,11)
//	@li,134 Psay nTPed				PicTure PesqPict("SC6","C6_PRCVEN",11)
	if _nGeIPI > 0
		@li,174 Psay _nGeIPI        Picture PesqPict("SC6","C6_VALOR",17)
	endif
	@li,192 Psay _nGeAFat	PicTure tm(_nGeAFat,17)
	li++
	
EndIF

IF li != 80
	roda(cbcont,cbtxt,Tamanho)
EndIF

dbSelectArea("STB")
dbCloseArea()
fErase(cTrab+".DBF")
fErase(cTrab+OrdBagExt())

RetIndex("SC6")
dbSelectArea("SC6")
Set Filter To
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImprPed  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 10.01.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados do pedido de venda                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr700                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ImprPed(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,nVend)

IF li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
EndIF

dbSelectArea("SC5")
If dbSeek(xFilial("SC5")+SC6->C6_NUM)
	@li,  0 Psay "PEDIDO : "	 + SC5->C5_NUM
	If SC5->C5_TIPO $ "BD"
		dbSelectArea("SA2")
		dbSetOrder(1)
		If dbSeek( xFilial("SA2")+SC6->C6_CLI+SC6->C6_LOJA )
			@li, PCol()+2 Psay "FORNECEDOR : " + SA2->A2_COD+' - '+ Subs(SA2->A2_NOME,1,40)
			@li, PCol()+2 Psay "LOJA : " + SA2->A2_LOJA
			@li, PCol()+2 Psay "EMISSAO : " + DTOC(SC5->C5_EMISSAO)
			@li, PCol()+2 Psay "TRANSPORTADORA: " + SC5->C5_TRANSP
			@li, PCol()+2 Psay "VENDEDOR(ES): " + R700Vend(nVend)
			@li, PCol()+2 Psay "COND.PGTO:  " + SC5->C5_CONDPAG
			li+=2
		EndIf
	Else
		dbSelectArea("SA1")
		dbSetOrder(1)
		If dbSeek( xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA )
			@li, PCol()+2 Psay "CLIENTE : " + SA1->A1_COD+' - '+ Subs(SA1->A1_NOME,1,40)
			@li, PCol()+2 Psay "LOJA : " + SA1->A1_LOJA
			@li, PCol()+2 Psay "EMISSAO : " + DTOC(SC5->C5_EMISSAO)
			@li, PCol()+2 Psay "TRANSPORTADORA: " + SC5->C5_TRANSP
			@li, PCol()+2 Psay "VENDEDOR(ES): " + R700Vend(nVend)
			@li, PCol()+2 Psay "COND.PGTO:  " + SC5->C5_CONDPAG
			li+=2
		EndIf
	EndIf
EndIf

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R700Vend ³ Autor ³ Marcos Bispo Abrah„o  ³ Data ³ 11/03/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna string com todos vendedores                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr700,ImprPed                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function R700Vend(nVend)
PRIVATE i,cVend,cVends:= "",lBarra:= .F.
FOR i:= 1 TO nVend
	cVend := "SC5->C5_VEND"+STR(i,1)
	cVend := &cVend
	If !Empty(cVend)
		cVends += IF(lBarra,"/","")+TRIM(cVend)
		lBarra:= .T.
	Endif
NEXT
RETURN cVends

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpProd  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 10.01.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados do item do Pedido de Venda                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr700                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ImpProd(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,nQtLib,nQtBloq)

PRIVATE nTotLocal := 0
PRIVATE nTotFat   := 0
PRIVATE nValdesc  := 0
PRIVATE nTotIPI	 := 0

dbSelectArea("SB1")
dbSeek(xFilial("SB1")+SC6->C6_PRODUTO)

dbSelectArea("STB")
IF dbSeek(SC6->C6_LOCAL+SC6->C6_PRODUTO)
	nTotLocal := STB->TB_SALDO
	RecLock("STB",.F.)
ELSE
	dbSelectArea("SB2")
	dbSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL)
	nTotLocal := SaldoSB2()
	RecLock("STB",.T.)
	REPLACE TB_COD WITH SC6->C6_PRODUTO,;
	TB_LOCAL WITH SC6->C6_LOCAL,;
	TB_SALDO WITH nTotLocal
ENDIF
REPLACE TB_SALDO WITH TB_SALDO - (SC6->C6_QTDVEN - SC6->C6_QTDENT)
MsUnLock()

dbSelectArea("SX5")
dbSeek(xFilial("SX5")+"E2"+SC6->C6_OP)
cDescTab := X5Descri()
dbSelectArea("SC6")

IF li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
EndIF

nTotFat   := CalValFat()
nValDesc  := CalValDes()
nTotIPI	  := A700Ipi(SC6->C6_TES,SC6->C6_PRODUTO,CalValFat())
if mv_par07 = 1
	nTotFat+=nTotIPI
endif

If nValDesc < 0
	nValDesc := 0
Endif

@li, 00 Psay SC6->C6_ITEM + " "+SC6->C6_PRODUTO + " " + Substr(SB1->B1_DESC,1,30)
@li, 50 Psay nTotLocal             Picture PesqPictQt("C6_QTDVEN",11)
@li, 62 Psay SC6->C6_QTDVEN             PicTure PesqPictQt("C6_QTDVEN",11)
@li, 74 Psay SC6->C6_QTDENT	           PicTure PesqPictQt("C6_QTDENT",11)
@li, 86 Psay (SC6->C6_QTDVEN-SC6->C6_QTDENT) PicTure PesqPictQt("C6_QTDVEN",11)
@li, 98 Psay nQtLib				   Picture PesqPictQt("C6_QTDVEN",11)
@li,110 Psay nQtBloq			   Picture PesqPictQt("C6_QTDVEN",11)
@li,122 Psay nValDesc              PicTure tm(nValDesc,11)
@li,134 Psay SC6->C6_PRCVEN             PicTure PesqPict("SC6","C6_PRCVEN",11)
@li,148 Psay Substr(SC6->C6_OP+"-"+cDescTab,1,24)
if nTotIPI > 0
	@li,174 Psay nTotIPI           PicTure PesqPict("SC6","C6_VALOR",17)
Endif
@li,192 Psay nTotFat               PicTure tm(nTotFat,17)
@li,210 Psay SC6->C6_ENTREG
Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CalValFat ³ Autor ³ Paulo Boschetti       ³ Data ³ 25.02.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula valor a faturar                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr700                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CalValFat()

Return ((SC6->C6_QTDVEN-SC6->C6_QTDENT)*SC6->C6_PRCVEN)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CalValDes ³ Autor ³ Paulo Boschetti       ³ Data ³ 26.03.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula valor do Desconto concedido ao item a faturar      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr700                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CalValDes()
PRIVATE nRet := 0
If SC6->C6_PRUNIT > 0
	nRet :=(SC6->C6_PRUNIT-SC6->C6_PRCVEN)*(SC6->C6_QTDVEN-SC6->C6_QTDENT)
Else
	nRet := SC6->C6_VALDESC
EndIf

Return nRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³a700Bloq  ³ Autor ³ Rosane Luciane Chene  ³ Data ³ 22.01.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se o pedido esta liberado e se esta bloqueado ou  ³±±
±±³          ³ ou nao                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr700                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function a700Bloq()
PRIVATE cAlias:=Alias()
PRIVATE aQuant:= {}

//Elementos do Array :
// 1. Produto
// 2. Quantidade Liberada
// 3. Quantidade Bloqueada

dbSelectArea("SC9")
dbSetOrder(1)
If dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM,.F.)
	While !Eof() .And. xFilial("SC9")+SC6->C6_NUM == SC9->C9_FILIAL+SC9->C9_PEDIDO
		If SC6->C6_ITEM == SC9->C9_ITEM
			If Empty(SC9->C9_NFISCAL)
				If Empty(SC9->C9_BLEST) .And. Empty(SC9->C9_BLCRED)
					nPos := Ascan(aQuant, {|x|x[1]== SC9->C9_PRODUTO})
					If nPos != 0
						aQuant[nPos,2]+= SC9->C9_QTDLIB
					Else
						Aadd(aQuant,{SC9->C9_PRODUTO,SC9->C9_QTDLIB,0})
					Endif
				Else
					nPos := Ascan(aQuant, {|x|x[1]== SC9->C9_PRODUTO})
					If nPos != 0
						aQuant[nPos,3]+= SC9->C9_QTDLIB
					Else
						Aadd(aQuant,{SC9->C9_PRODUTO,0,SC9->C9_QTDLIB})
					Endif
				Endif
			Endif
		Endif
		dbSkip()
	EndDo
Endif
dbSetOrder(1)
dbSelectArea(cAlias)
Return aQuant

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A700Ipi  ³ Autor ³ Simidu / Rogerio      ³ Data ³ 28.10.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula IPI para valor da NF.                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function A700IPI(cTes,cProduto,nBaseIpi)
PRIVATE nIpi:=0,nF4Reducao:=1
PRIVATE cAlias := Alias()
PRIVATE nporimp:=0

if cPaisloc<>"BRA"  // Localizacoes -Alteracao feita para imprimir o imposto 1 ao inves do IPI
	dbSelectArea("SFC")
	dbsetorder(1)
	If dbSeek(xFilial("SFC")+cTes,.F.)
		cimp:=SFC->FC_IMPOSTO
		dbselectarea ("SFB")
		DBSETORDER(1)
		IF  DBSEEK (xfilial("SFB")+cimp,.f.)
			nporimp:=(sfb->fb_aliq/100)
		Endif
		if nporimp>0
			nIpi:=nporimp*nBaseIpi
		endif
	Endif
else
	dbSelectArea("SF4")
	If dbSeek(xFilial("SF4")+cTes,.F.) .And. F4_IPI=="S" .And. (F4_LFIPI=="T" .Or. F4_BASEIPI>0)
		nF4Reducao:=(IIf(F4_BASEIPI>0,F4_BASEIPI/100,1))
		nBaseIpi:=(nBaseIpi*nF4Reducao)
	Else
		nBaseIPI:=0
	Endif
	dbSelectArea("SB1")
	If dbSeek(xFilial("SB1")+cProduto,.F.) .And. B1_IPI>0
		nIpi:=(B1_IPI/100)*nBaseIpi
	Endif
endif

dbSelectArea(cAlias)

Return(nIpi)