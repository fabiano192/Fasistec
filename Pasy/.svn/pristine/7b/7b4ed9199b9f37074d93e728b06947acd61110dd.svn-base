#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ PA0155  ³ Autor ³ Alexandro da Silva     ³ Data ³ 25/02/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relacao de Pedidos aptos a faturar                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0155()

ATuSX1()

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
PRIVATE nomeprog  := "PA0155"
PRIVATE aLinha    := { },nLastKey := 0
PRIVATE cPerg     :="PA0155"

pergunte("PA0155",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                            ³
//³ mv_par01        	// Do Pedido                                ³
//³ mv_par02        	// Ate o Pedido                             ³
//³ mv_par03        	// Do Produto                               ³
//³ mv_par04 	     	// Ate o Produto                            ³
//³ mv_par05 	     	// Imprime Pedidos                          ³
//³ mv_par06 	     	// Soma Ipi ao Tot Sim Nao                  ³
//³ mv_par07 	     	// Quanto ao Tes                            ³
//³ mv_par08 	     	// Data de Entrega De                       ³
//³ mv_par09 	     	// Data de Entrega Ate                      ³
//³ mv_par10 	     	// Cliente De                               ³
//³ mv_par11 	     	// Cliente Ate                              ³
//³ mv_par12 	     	// Loja De                                  ³
//³ mv_par13 	     	// Loja Ate                                 ³
//³ mv_par14 	     	// Grupo De                                 ³
//³ mv_par15 	     	// Grupo Ate                                ³
//³ mv_par16 	     	// SubGrupo De                              ³
//³ mv_par17 	     	// SubGrupo Ate                             ³
//³ mv_par18 	     	// Quais Pedidos                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄ¿

wnrel:="PA0155"

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
PRIVATE aOrd   := {" Por pedido      "," Por produto      "," Por data entrega "}
PRIVATE aCampos:= {}
PRIVATE aTam   := {}
PRIVATE cTipo  := ""
PRIVATE nC	   := 1
PRIVATE nQtLib := 0
PRIVATE nQtBloq:= 0
PRIVATE aQuant := {}
PRIVATE nVend  := 1
PRIVATE nOrdem := aReturn[8]
PRIVATE nTQtde := 0
PRIVATE nTPed  := 0
PRIVATE nTQLib := 0
PRIVATE nTQBLoq:= 0
PRIVATE nTQEnt := 0

nTipo    := GetMv("MV_COMP")

cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1
cabec1   := "IT CODIGO PRODUTO  DESCRICAO DO PRODUTO            ESTOQUE        -----------  PEDIDO  --------------     QUANTIDADE     QUANTIDADE         VALOR DO        PRECO UNITARIO                       VALOR A"
cabec2   := "                                                  DISPONIVEL    VENDIDO     ATENDIDO      SALDO     LIBERADA    BLOQUEADA    DESCONTO    LIQUIDO     ORDEM DE PRODUCAO      VALOR DO IPI               FATURAR       ENTREGA"
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

aTam:=TamSX3("B2_LOCAL")
AADD(aCampos,{ "TB_LOCAL" ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("B2_COD")
AADD(aCampos,{ "TB_COD"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("B2_VATU1")
AADD(aCampos,{ "TB_SALDO" ,"N",aTam[1],aTam[2] } )

cTrab:= CriaTrab(aCampos)

USE &cTrab ALIAS STB NEW
IndRegua("STB",cTrab,"TB_LOCAL+TB_COD",,,"Selecionando Registros...")

If nOrdem != 4
	RptStatus({|lEnd| C700Imp(@lEnd,wnRel,cString)},Titulo)
Else
	RptStatus({|lEnd| ImpOrd4(@lEnd,wnRel,cString)},Titulo)
Endif

ZC6->(dbCloseArea())

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


IF MV_PAR05 == 1
	cTipo := " APTOS A FATURAR "
ELSEIF MV_PAR05 == 2
	cTipo := " NAO LIBERADOS   "
ELSE
	cTipo := ""
ENDIF
titulo += cTipo

_cPed := "("
For Ax:= 1 To Len(MV_PAR18)
	If Substr(MV_PAR18,AX,1) != "*"
		If _cPed == "("
		   _cPed += "'"+Substr(MV_PAR18,AX,1)
		Else
   		   _cPed += "','"+Substr(MV_PAR18,AX,1)
  		Endif
    Endif
Next AX                    
 
_cPed += "')"              

_cQ   := " SELECT C6_PEDAMOS,C6_NUM,C6_ITEM,C5_EMISSAO,C6_ENTREG,C6_CLI,C6_LOJA,C6_QTDVEN,C6_QTDENT,C6_PRCVEN,C6_PRUNIT, "
_cQ   += " C6_PRODUTO,C6_CPROCLI,C6_TES,C5_TIPO,C5_CONDPAG,C5_TRANSP,C5_VEND1,C6_LOCAL,C6_OP,C6_VALDESC "
_cQ   += " FROM "+RetSqlName("SC6")+" C6 "                 
_cQ   += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD=C6_PRODUTO "
_cQ   += " INNER JOIN "+RetSqlName("SF4")+" F4 ON C6_TES=F4_CODIGO "
_cQ   += " INNER JOIN "+RetSqlName("SC5")+" C5 ON C6_NUM=C5_NUM    "
_cQ   += " WHERE B1.D_E_L_E_T_ = '' AND C5.D_E_L_E_T_ = '' AND C6.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' "    
_cQ   += " AND C6_NUM     BETWEEN '"+MV_PAR01+"'       AND '"+MV_PAR02+"' "
_cQ   += " AND C6_PRODUTO BETWEEN '"+MV_PAR03+"'       AND '"+MV_PAR04+"' "
_cQ   += " AND C6_ENTREG  BETWEEN '"+DTOS(MV_PAR08)+"' AND '"+DTOS(MV_PAR09)+"' "
_cQ   += " AND C6_CLI     BETWEEN '"+MV_PAR10+"'       AND '"+MV_PAR11+"' "
_cQ   += " AND C6_LOJA    BETWEEN '"+MV_PAR12+"'       AND '"+MV_PAR13+"' "
_cQ   += " AND B1_GRUPO   BETWEEN '"+MV_PAR14+"'       AND '"+MV_PAR15+"' "
_cQ   += " AND B1_SUBGR   BETWEEN '"+MV_PAR16+"'       AND '"+MV_PAR17+"' "
_cQ   += " AND C6_PEDAMOS IN "+_cPed+" "
_cQ   += " AND C6_BLQ = '' AND C6_QTDVEN > C6_QTDENT AND C5_TIPO = 'N' "
If MV_PAR07 == 1
	_cQ += " AND F4_DUPLIC  = 'S' "
ElseIf MV_PAR07 == 2
	_cQ += " AND F4_DUPLIC <> 'S' "
Endif
If !Empty(aReturn[7])
	_cQ += " AND "+U_FILUSER(aReturn[7])
Endif
                
If nOrdem = 1
	_cQ        += " ORDER BY C6_NUM,C6_ITEM,C6_ENTREG"
	cDescOrdem := "PEDIDO"
	cCond      := "ZC6->C6_NUM <= mv_par02"
ElseIf nOrdem = 2                                     
	_cQ        += " ORDER BY C6_PRODUTO,C6_NUM,C6_ITEM"
	cDescOrdem := "PRODUTO"
	cCond      := "ZC6->C6_PRODUTO <= mv_par04"	
ElseIf nOrdem = 3
	_cQ        += " ORDER BY C6_ENTREG,C6_NUM,C6_ITEM"
	cDescOrdem := "DATA DE ENTREGA"
	cCond      := ".T."
Else                                                  
	_cQ        += " ORDER BY C6_CLI,C6_LOJA,C6_PRODUTO,"
	cDescOrdem := "CLIENTE"
	cCond      := "ZC6->C6_CLI <= mv_par13"
Endif

titulo += cTipo +  " - ORDEM DE "  + cDescOrdem

TCQUERY _cQ NEW ALIAS "ZC6" 

TCSETFIELD("ZC6","C5_EMISSAO","D")
TCSETFIELD("ZC6","C6_ENTREG","D")
                          
ZC6->(dbGotop())

SetRegua(ZC6->(U_CONTREG()))

nAg1   := nAg2:=  nAg3:= 0

While ZC6->(!Eof()) .And. lContinua .and. &cCond
	
	IF lEnd
		@ Prow()+1,001 Psay "CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	Endif
	
	IncRegua()
		
	aQuant := a700Bloq()
	For nC := 1 To Len(aQuant)
		nQtlib += aQuant[nC,2]
		nQtBloq+= aQuant[nC,3]
	Next nC
	
	If mv_par05 == 1 .And. nQtLib == 0
		ZC6->(dbSkip())
		Loop
	ElseIf mv_par05 == 2 .And. nQtBloq == 0
		ZC6->(dbSkip())
		Loop
	Endif
	
	cPedant := ZC6->C6_NUM
	nAc1    := nAc2    :=  nValIpi := nTotIpi := 0
	nQtlib  := nQtBloq := 0
	lFirst  := .T.
	
	While ZC6->(!Eof()) .And. cPedant == ZC6->C6_NUM .And. lContinua

		IncRegua()
				
		IF lEnd
			@ Prow()+1,001 Psay "CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		Endif
		
		dbSelectArea("ZC6")

		aQuant := a700Bloq()
		For nC := 1 To Len(aQuant)
			nQtlib += aQuant[nC,2]
			nQtBloq+= aQuant[nC,3]
		Next nC
		
		If mv_par05 == 1 .And. nQtLib == 0
			ZC6->(dbSkip())
			Loop
		ElseIf mv_par05 == 2 .And. nQtBloq == 0
			ZC6->(dbSkip())
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

		_nVal   := ((ZC6->C6_QTDVEN-ZC6->C6_QTDENT)*ZC6->C6_PRCVEN)				
		If ZC6->C6_PRUNIT > 0
			_nValDesc := (ZC6->C6_PRUNIT-ZC6->C6_PRCVEN)*(ZC6->C6_QTDVEN-ZC6->C6_QTDENT)
		Else
			_nValDesc := ZC6->C6_VALDESC
		EndIf

		nTQLib  += nQtLib
		nTQBloq += nQtBloq
		nTQtde  += ZC6->C6_QTDVEN
		nTQEnt  += ZC6->C6_QTDENT
		nTPed   += ZC6->C6_PRCVEN
		nQtlib  := nQtBloq := 0
		nAc1	+= _nVal
		nAc2    += _nValDesc
		nValIpi := A700Ipi(ZC6->C6_TES,ZC6->C6_PRODUTO,_nVal)
		If mv_par06 == 1
			nAc1 += nValIPI
		Endif
		nTotIPI +=nValIPI
		li++

		ZC6->(dbSkip())
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
	@li, 62 Psay nTQtde				    PicTure PesqPictQt("C6_QTDVEN",11)
	@li, 74 Psay nTQent	                PicTure PesqPictQt("C6_QTDENT",11)
	@li, 86 Psay (nTQtde-nTQEnt)	    PicTure PesqPictQt("C6_QTDVEN",11)
	@li, 98 Psay nTQLib				    Picture PesqPictQt("C6_QTDVEN",11)
	@li,110 Psay nTQBloq				Picture PesqPictQt("C6_QTDVEN",11)
	@li,122 Psay nAg2					PicTure tm(nAg2,11)
	if nAg3 > 0
		@li,174 Psay nAg3               Picture PesqPict("SC6","C6_VALOR",17)
	endif
	@li,192 Psay nAg1	                PicTure tm(nAg1,17)
	li++
	
Endif

IF li != 80
	roda(cbcont,cbtxt,Tamanho)
EndIF

STB->(dbCloseArea())

fErase(cTrab+".DBF")
fErase(cTrab+OrdBagExt())

dbSelectArea("SC6")
Set Filter To

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()

Return


Static Function ImpOrd4(lEnd,WnRel,cString)

IF MV_PAR05 == 1
	cTipo := " APTOS A FATURAR "
ELSEIF MV_PAR05 == 2
	cTipo := " NAO LIBERADOS   "
ELSE
	cTipo := ""
ENDIF

titulo += cTipo

_cPed := "("
For Ax:= 1 To Len(MV_PAR18)
	If Substr(MV_PAR18,AX,1) != "*"
		If _cPed == "("
		   _cPed += "'"+Substr(MV_PAR18,AX,1)
		Else
   		   _cPed += "','"+Substr(MV_PAR18,AX,1)
  		Endif
    Endif
Next AX                    
 
_cPed += "')"              

_cQ   := " SELECT C6_PEDAMOS,C6_NUM,C6_ITEM,C5_EMISSAO,C6_ENTREG,C6_CLI,C6_LOJA,C6_QTDVEN,C6_QTDENT,C6_PRCVEN,C6_PRUNIT, "
_cQ   += " C6_PRODUTO,C6_CPROCLI,C6_TES,C5_TIPO,C5_CONDPAG,C5_TRANSP,C5_VEND1,C6_LOCAL,C6_OP,C6_VALDESC "
_cQ   += " FROM "+RetSqlName("SC6")+" C6 "
_cQ   += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD=C6_PRODUTO "
_cQ   += " INNER JOIN "+RetSqlName("SF4")+" F4 ON C6_TES=F4_CODIGO "
_cQ   += " INNER JOIN "+RetSqlName("SC5")+" C5 ON C6_NUM=C5_NUM    "
_cQ   += " WHERE B1.D_E_L_E_T_ = '' AND C5.D_E_L_E_T_ = '' AND C6.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' "    
_cQ   += " AND C6_NUM     BETWEEN '"+MV_PAR01+"'       AND '"+MV_PAR02+"' "
_cQ   += " AND C6_PRODUTO BETWEEN '"+MV_PAR03+"'       AND '"+MV_PAR04+"' "
_cQ   += " AND C6_ENTREG  BETWEEN '"+DTOS(MV_PAR08)+"' AND '"+DTOS(MV_PAR09)+"' "
_cQ   += " AND C6_CLI     BETWEEN '"+MV_PAR10+"'       AND '"+MV_PAR11+"' "
_cQ   += " AND C6_LOJA    BETWEEN '"+MV_PAR12+"'       AND '"+MV_PAR13+"' "
_cQ   += " AND B1_GRUPO   BETWEEN '"+MV_PAR14+"'       AND '"+MV_PAR15+"' "
_cQ   += " AND B1_SUBGR   BETWEEN '"+MV_PAR16+"'       AND '"+MV_PAR17+"' "
_cQ   += " AND C6_PEDAMOS IN "+_cPed+" "
_cQ   += " AND C6_BLQ = '' AND C6_QTDVEN > C6_QTDENT AND C5_TIPO = 'N' "

If MV_PAR07 == 1
	_cQ += " AND F4_DUPLIC  = 'S' "
ElseIf MV_PAR07 == 2
	_cQ += " AND F4_DUPLIC <> 'S' "
Endif

If !Empty(aReturn[7])
	_cQ += " AND "+U_FILUSER(aReturn[7])
Endif

_cQ   += " ORDER BY C6_CLI,C6_LOJA,C6_NUM,C6_ITEM,C6_PRODUTO"

TCQUERY _cQ NEW ALIAS "ZC6" 

TCSETFIELD("ZC6","C5_EMISSAO","D")
TCSETFIELD("ZC6","C6_ENTREG","D")

cDescOrdem := "CLIENTE"
cCond      := "ZC6->C6_CLI <= mv_par13"
                          
ZC6->(dbGotop())

titulo += cTipo

SetRegua(ZC6->(U_CONTREG()))

_nGeDesc := _nGeaFat := _nGeIPI := 0
nAg1     := nAg2     := nAg3    := 0

While ZC6->(!Eof()) .And. lContinua

	IF lEnd
		@ Prow()+1,001 Psay "CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	Endif
	
	IncRegua()
	
	aQuant := a700Bloq()
	For nC := 1 To Len(aQuant)
		nQtlib += aQuant[nC,2]
		nQtBloq+= aQuant[nC,3]
	Next nC
	
	If mv_par05 == 1 .And. nQtLib == 0
		ZC6->(dbSkip())
		Loop
	ElseIf mv_par05 == 2 .And. nQtBloq == 0
		ZC6->(dbSkip())
		Loop
	Endif
	
	_cCliLoja := ZC6->C6_CLI+ZC6->C6_LOJA
	nAc1      := nAc2:=  nValIpi := nTotIpi := 0
	nQtlib    := nQtBloq := 0
	lFirst    := .T.
	 
	_nCliDesc := _nCliaFat := _nCliIPI := 0
	
	While ZC6->(!Eof()) .and. _cCliLoja == ZC6->C6_CLI + ZC6->C6_LOJA .And. lContinua
		
	    _cPedido := ZC6->C6_NUM
	    
	    _nToPed   := nAc2:=  nValIpi := nTotIpi := 0
	    	    
	    While ZC6->(!Eof()) .And. _cPedido == ZC6->C6_NUM
		
			IF lEnd
				@ Prow()+1,001 Psay "CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
			Endif
		
			IncRegua()
				
			dbSelectArea("ZC6")
			aQuant := a700Bloq()
			For nC := 1 To Len(aQuant)
				nQtlib += aQuant[nC,2]
				nQtBloq+= aQuant[nC,3]
			Next nC
		
			If mv_par05 == 1 .And. nQtLib == 0
				ZC6->(dbSkip())
				Loop
			ElseIf mv_par05 == 2 .And. nQtBloq == 0
				ZC6->(dbSkip())
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
        	
			If ZC6->C6_PRUNIT > 0
				_nDesc := (ZC6->C6_PRUNIT-ZC6->C6_PRCVEN)*(ZC6->C6_QTDVEN-ZC6->C6_QTDENT)
			Else
				_nDesc := ZC6->C6_VALDESC
			EndIf

        	_nValor := ((ZC6->C6_QTDVEN-ZC6->C6_QTDENT)*ZC6->C6_PRCVEN)
			nTQLib  += nQtLib
			nTQBloq += nQtBloq
			nTQtde  += ZC6->C6_QTDVEN
			nTQEnt  += ZC6->C6_QTDENT
			nTPed   += ZC6->C6_PRCVEN
			nQtlib  := nQtBloq := 0
			nAc1    += _nValor
			nAc2    += _nDesc

			nValIpi  := A700Ipi(ZC6->C6_TES,ZC6->C6_PRODUTO,_nValor)			
			
        	_nCliDesc += _nDesc
        	_nCliaFat += _nValor
        	_nCliIPI  += nValIPI
			
			If mv_par06 == 1
				nAc1 += nValIPI
				_nCliAFat += nValIPI
			Endif

			nTotIPI +=nValIPI
			li++

			ZC6->(dbSkip())
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
	nAg1     += nAc1
	nAg2     += nAc2
	nAg3     += nTotIpi	
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
	if _nGeIPI > 0
		@li,174 Psay _nGeIPI        Picture PesqPict("SC6","C6_VALOR",17)
	endif
	@li,192 Psay _nGeAFat       	PicTure tm(_nGeAFat,17)
	li++
	
EndIF

IF li != 80
	roda(cbcont,cbtxt,Tamanho)
EndIF

STB->(dbCloseArea())

fErase(cTrab+".DBF")
fErase(cTrab+OrdBagExt())

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

@li,  0 Psay "PEDIDO : "	 + ZC6->C6_NUM

If ZC6->C5_TIPO $ "BD"
	dbSelectArea("SA2")
	dbSetOrder(1)
	If dbSeek( xFilial("SA2")+ZC6->C6_CLI+ZC6->C6_LOJA )
		@li, PCol()+2 Psay "FORNECEDOR : " + SA2->A2_COD+' - '+ Subs(SA2->A2_NOME,1,40)
		@li, PCol()+2 Psay "LOJA : " + SA2->A2_LOJA
		@li, PCol()+2 Psay "EMISSAO : " + DTOC(ZC6->C5_EMISSAO)
		@li, PCol()+2 Psay "TRANSPORTADORA: " + ZC6->C5_TRANSP
		@li, PCol()+2 Psay "VENDEDOR(ES): " + R700Vend(nVend)
		@li, PCol()+2 Psay "COND.PGTO:  " + ZC6->C5_CONDPAG
		li+=2
	EndIf
Else
	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek( xFilial("SA1")+ZC6->C6_CLI+ZC6->C6_LOJA )
		@li, PCol()+2 Psay "CLIENTE : " + SA1->A1_COD+' - '+ Subs(SA1->A1_NOME,1,40)
		@li, PCol()+2 Psay "LOJA : " + SA1->A1_LOJA
		@li, PCol()+2 Psay "EMISSAO : " + DTOC(ZC6->C5_EMISSAO)
		@li, PCol()+2 Psay "TRANSPORTADORA: " + ZC6->C5_TRANSP
		@li, PCol()+2 Psay "VENDEDOR(ES): " + R700Vend(nVend)
		@li, PCol()+2 Psay "COND.PGTO:  " + ZC6->C5_CONDPAG
		li+=2
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
	cVend := "ZC6->C5_VEND"+STR(i,1)
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
dbSeek(xFilial("SB1")+ZC6->C6_PRODUTO)

dbSelectArea("STB")
IF dbSeek(ZC6->C6_LOCAL+ZC6->C6_PRODUTO)
	nTotLocal := STB->TB_SALDO
	RecLock("STB",.F.)
ELSE
	dbSelectArea("SB2")
	dbSeek(xFilial("SB2")+ZC6->C6_PRODUTO+ZC6->C6_LOCAL)
	nTotLocal := SaldoSB2()
	RecLock("STB",.T.)
	REPLACE TB_COD WITH ZC6->C6_PRODUTO,;
	TB_LOCAL WITH ZC6->C6_LOCAL,;
	TB_SALDO WITH nTotLocal
ENDIF
REPLACE TB_SALDO WITH TB_SALDO - (ZC6->C6_QTDVEN - ZC6->C6_QTDENT)
MsUnLock()

dbSelectArea("SX5")
dbSeek(xFilial("SX5")+"E2"+ZC6->C6_OP)
cDescTab := X5Descri()
dbSelectArea("ZC6")

IF li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
EndIF

nTotFat   := ((ZC6->C6_QTDVEN-ZC6->C6_QTDENT)*ZC6->C6_PRCVEN)

If ZC6->C6_PRUNIT > 0
	nValDesc :=(ZC6->C6_PRUNIT-ZC6->C6_PRCVEN)*(ZC6->C6_QTDVEN-ZC6->C6_QTDENT)
Else
	nValDesc := ZC6->C6_VALDESC
EndIf

nTotIPI	 := A700Ipi(ZC6->C6_TES,ZC6->C6_PRODUTO,nTotFat)
If mv_par06 = 1
	nTotFat+=nTotIPI
Endif

If nValDesc < 0
	nValDesc := 0
Endif

@li, 00 Psay ZC6->C6_ITEM + " "+ZC6->C6_PRODUTO + " " + Substr(SB1->B1_DESC,1,30)
@li, 50 Psay nTotLocal                       Picture PesqPictQt("C6_QTDVEN",11)
@li, 62 Psay ZC6->C6_QTDVEN                  PicTure PesqPictQt("C6_QTDVEN",11)
@li, 74 Psay ZC6->C6_QTDENT	                 PicTure PesqPictQt("C6_QTDENT",11)
@li, 86 Psay (ZC6->C6_QTDVEN-ZC6->C6_QTDENT) PicTure PesqPictQt("C6_QTDVEN",11)
@li, 98 Psay nQtLib				             Picture PesqPictQt("C6_QTDVEN",11)
@li,110 Psay nQtBloq			             Picture PesqPictQt("C6_QTDVEN",11)
@li,122 Psay nValDesc                        PicTure tm(nValDesc,11)
@li,134 Psay ZC6->C6_PRCVEN                  PicTure PesqPict("SC6","C6_PRCVEN",11)
@li,148 Psay Substr(ZC6->C6_OP+"-"+cDescTab,1,24)
if nTotIPI > 0
	@li,174 Psay nTotIPI                     PicTure PesqPict("SC6","C6_VALOR",17)
Endif
@li,192 Psay nTotFat                         PicTure tm(nTotFat,17)
@li,210 Psay ZC6->C6_ENTREG
Return .T.

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
If dbSeek(xFilial("SC9")+ZC6->C6_NUM+ZC6->C6_ITEM,.F.)
	While SC9->(!Eof()) .And. ZC6->C6_NUM == SC9->C9_PEDIDO
		If ZC6->C6_ITEM == SC9->C9_ITEM
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
		SC9->(dbSkip())
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

PRIVATE nIpi   :=0,nF4Reducao:=1
PRIVATE cAlias := Alias()
PRIVATE nporimp:=0

dbSelectArea("SF4")
If dbSeek(xFilial("SF4")+cTes,.F.) .And. F4_IPI=="S" .And. (F4_LFIPI=="T" .Or. F4_BASEIPI>0)
	nF4Reducao:= (IIf(F4_BASEIPI>0,F4_BASEIPI/100,1))
	nBaseIpi  := (nBaseIpi*nF4Reducao)
Else
	nBaseIPI:=0
Endif

dbSelectArea("SB1")
If dbSeek(xFilial("SB1")+cProduto,.F.) .And. B1_IPI>0
	nIpi:= (B1_IPI/100)*nBaseIpi
Endif

dbSelectArea(cAlias)

Return(nIpi)


Static Function AtuSX1()

cPerg := "PA0155"
aRegs :={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                            ³
//³ mv_par01        	// Do Pedido                                ³
//³ mv_par02        	// Ate o Pedido                             ³
//³ mv_par03        	// Do Produto                               ³
//³ mv_par04 	     	// Ate o Produto                            ³
//³ mv_par05 	     	// Imprime Pedidos                          ³
//³ mv_par06 	     	// Soma Ipi ao Tot Sim Nao                  ³
//³ mv_par07 	     	// Quanto ao Tes                            ³
//³ mv_par08 	     	// Data de Entrega De                       ³
//³ mv_par09 	     	// Data de Entrega Ate                      ³
//³ mv_par10 	     	// Cliente De                               ³
//³ mv_par11 	     	// Cliente Ate                              ³
//³ mv_par12 	     	// Loja De                                  ³
//³ mv_par13 	     	// Loja Ate                                 ³
//³ mv_par14 	     	// Grupo De                                 ³
//³ mv_par15 	     	// Grupo Ate                                ³
//³ mv_par16 	     	// SubGrupo De                              ³
//³ mv_par17 	     	// SubGrupo Ate                             ³
//³ mv_par18 	     	// Quais Pedidos                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄ¿

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Pedido de             ?",""       ,""      ,"mv_ch1","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Pedido Ate            ?",""       ,""      ,"mv_ch2","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"03","Produto De            ?",""       ,""      ,"mv_ch3","C" ,15     ,0      ,0     ,"G",""            ,"MV_PAR03",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
U_CRIASX1(cPerg,"04","Produto Ate           ?",""       ,""      ,"mv_ch4","C" ,15     ,0      ,0     ,"G",""            ,"MV_PAR04",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
U_CRIASX1(cPerg,"05","Imprime Pedidos       ?",""       ,""      ,"mv_ch5","N" ,01     ,0      ,0     ,"C",""            ,"MV_PAR05","Apto a Faturar" ,""     ,""     ,""   ,""   ,"Nao"            ,""     ,""     ,""   ,""   ,"Todos",""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"06","Soma IPI ao Total     ?",""       ,""      ,"mv_ch6","N" ,01     ,0      ,0     ,"C",""            ,"MV_PAR06","Sim"            ,""     ,""     ,""   ,""   ,"Nao"            ,""     ,""     ,""   ,""   ,"Todos",""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"07","Quanto ao Tes         ?",""       ,""      ,"mv_ch7","N" ,01     ,0      ,0     ,"C",""            ,"MV_PAR07","Gera Duplic."   ,""     ,""     ,""   ,""   ,"Nao Gera Duplic",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"08","Entrega De            ?",""       ,""      ,"mv_ch8","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR08",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"09","Entrega Ate           ?",""       ,""      ,"mv_ch9","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR09",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"10","Cliente De            ?",""       ,""      ,"mv_cha","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR10",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CLI")
U_CRIASX1(cPerg,"11","Cliente Ate           ?",""       ,""      ,"mv_chb","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR11",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CLI")
U_CRIASX1(cPerg,"12","Loja De               ?",""       ,""      ,"mv_chc","C" ,02     ,0      ,0     ,"G",""            ,"MV_PAR12",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"13","Loja Ate              ?",""       ,""      ,"mv_chd","C" ,02     ,0      ,0     ,"G",""            ,"MV_PAR13",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"14","Grupo De              ?",""       ,""      ,"mv_che","C" ,04     ,0      ,0     ,"G",""            ,"MV_PAR14",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SBM")
U_CRIASX1(cPerg,"15","Grupo Ate             ?",""       ,""      ,"mv_chf","C" ,04     ,0      ,0     ,"G",""            ,"MV_PAR15",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SBM")
U_CRIASX1(cPerg,"16","SubGrupo De           ?",""       ,""      ,"mv_chg","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR16",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"Z1")
U_CRIASX1(cPerg,"17","SubGrupo Ate          ?",""       ,""      ,"mv_chh","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR17",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"Z1")
U_CRIASX1(cPerg,"18","Quais Pedidos         ?",""       ,""      ,"mv_chi","C" ,06     ,0      ,0     ,"G","U_FTIPOPED()","MV_PAR18",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return