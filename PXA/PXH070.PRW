#INCLUDE 'TOTVS.ch'
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PXH070   º Autor ³ Edson Lins         º Data ³  02/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de Saldos por Endereço.                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Estoque/Custos                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PXH070()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Saldos por Endereço físico."
Local cPict          := ""
Local titulo         := "Listagem Para Inventario"
Local nLin           := 80
Local imprime        := .T.
Local aOrd           := {"Amr+Localiz+Codigo","Codigo + Localiz","Descricao + Localiz"}

//If cEmpAnt == '16'
	Private nOrdem
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "M"
	Private nomeprog     := "PXH070"
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "PXH070"
	Private cString      := "SB1"
	Private cPerg        := "PXH070"
	private cQuery       := ""
	Private cDescProd    := ""
	Private cArq         := ""
	Private Cabec1
	Private Cabec2
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	
	ATUSX1()
	
	Pergunte(cPerg,.f.)
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	nOrdem := aReturn[8]
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	
//Else
//	MsgAlert('Relatório exclusivo para Empresa 16 - Vila Nova')
//Endif

Return


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local cProduto,cLocal,cLocaliz
Local nQuant:=nValor:=0
Local cIndice, cLocaliz :=""
Local aCampos := {}
do case
	case  nOrdem == 1 // Por Descricao
		cIndice   := "ARM+LOCALIZ+CODIGO+SEQ"
	case nOrdem == 2
		cIndice   := "CODIGO+ARM+SEQ"
	case  nOrdem == 3
		cIndice   := "DESCRICAO+ARM+SEQ"
EndCase

_cQ := " SELECT * FROM "+RetSqlName("SB1")+" A " +CRLF
_cQ += " INNER JOIN "+RetSqlName("SB2")+" B ON B1_COD=B2_COD "+CRLF
_cQ += " INNER JOIN "+RetSqlName("SBE")+" C ON B1_YPRAT=BE_LOCALIZ "+CRLF
_cQ += " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = ''  AND C.D_E_L_E_T_ = '' "+CRLF
_cQ += " AND B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "+CRLF
_cQ += " AND B2_LOCAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "+CRLF
_cQ += " AND B1_YPRAT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "+CRLF
_cQ += " AND B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF

If MV_PAR07 == 2
	_cQ += " AND B2_QATU > 0" +CRLF
Endif

If nOrdem == 1
	_cQ += "ORDER BY B2_LOCAL,B1_YPRAT,B1_COD"+CRLF
ElseIf nOrdem == 2
	_cQ += "ORDER BY B1_COD,B2_LOCAL"+CRLF
ElseIf nOrdem == 3
	_cQ += "ORDER BY B1_DESC,B2_LOCAL"+CRLF
Endif

TCQUERY _cQ NEW ALIAS "ZZ"

//MemoWrite("D:\PXH070.TXT",_cQ)

/*
Local  Arm   Codigo          Descricao                                          UM  __1a.  CONT__   __2a.  CONT__   __1a.  CONT__
QTDE ETIQUETA   QTDE ETIQUETA   QTDE ETIQUETA
[           ]   [           ]   [           ]
999999 9999  999999999999999 99999999999999999999999999999999999999999999999999 99  9999999999999   9999999999999   9999999999999
0      7     13              29                                                 80  84              100             116
*/

Cabec1 := "Local  Arm   Codigo          Descricao                                          UM  __1a.  CONT__   __2a.  CONT__   __3a.  CONT__"
Cabec2 := "                                                                                    QTDE ETIQUETA   QTDE ETIQUETA   QTDE ETIQUETA"

SetRegua(ZZ->(U_CONTREG()))

ZZ->(DbGoTop())

While !ZZ->(Eof())
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	IncRegua()
	
	If nLin > 57
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	cDescProd := AllTrim(ZZ->B1_DESC)
	
	@nLin,00   PSAY SubStr(ZZ->B1_YPRAT,1,6)
	@nLin,07   PSAY ZZ->B2_LOCAL
	@nLin,13   PSAY SubStr(ZZ->B2_COD,1,10)
	@nLin,29   PSAY SubStr(cDescProd,1,50)
	@nLin,80   PSAY ZZ->B1_UM
	@nLin,84   PSAY "[           ]"
	@nLin,100  PSAY "[           ]"
	@nLin,116  PSAY "[           ]"
	
	If Len(cDescProd) > 51
		nLin++
		@nLin,29  PSAY SubStr(cDescProd,51,50)
	Endif
	
	If Len(cDescProd) > 101
		nLin++
		@nLin,29  PSAY SubStr(cDescProd,101,50)
	Endif
	
	ZZ->(DbSkip())
	
	nLin++
EndDo

nLin++
@nLin,00 Psay Replicate("=",132)

ZZ->(dbCloseArea())

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

SetPgEject(.f.)
MS_FLUSH()

Return


Static Function ATUSX1()

cPerg := "PXH070"

//    	   Grupo/Ordem/Pergunta          /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01   /Def01   /defspa1/defeng1/Cnt01/Var02/Def02          /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Produto De       ?",""       ,""      ,"mv_ch1","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR01","     ",""     ,""     ,""   ,""   ,""              ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"SB1")
U_CRIASX1(cPerg,"02","Produto Ate      ?",""       ,""      ,"mv_ch2","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR02","     ",""     ,""     ,""   ,""   ,""              ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"SB1")
U_CRIASX1(cPerg,"03","Local De         ?",""       ,""      ,"mv_ch3","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR03","     ",""     ,""     ,""   ,""   ,""              ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"04","Local Ate        ?",""       ,""      ,"mv_ch4","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR04","     ",""     ,""     ,""   ,""   ,""              ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"05","Endereco De      ?",""       ,""      ,"mv_ch5","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR05","     ",""     ,""     ,""   ,""   ,""              ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"06","Endereço Ate     ?",""       ,""      ,"mv_ch6","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR06","     ",""     ,""     ,""   ,""   ,""              ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
U_CRIASX1(cPerg,"07","Consd. Sld. Zero ?",""       ,""      ,"mv_ch7","N" ,01     ,0      ,0     ,"C",""        ,"MV_PAR07","Nao"  ,""     ,""     ,""   ,""   ,"Sim"           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")

Return
