#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PA0149    ºAutor  ³Alexandro da Silva  º Data ³  12/11/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faturamento por Ranking de Produtos                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Sigafat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PA0149()

AtuSX1()

Private nTipo
Private CbTxt
Private cDesc1     := "Este programa ira emitir a relacao do Faturamento dos   ,"
Private cDesc2     := "Clientes por Ranking de Produtos conforme parametros     "
Private cDesc3     := "informados pelo usuario.PA0149                           "
Private cString    := "SD2"
Private titulo     := "Faturamento Por Ranking de Produtos "
Private CbCont,cabec1,cabec2,wnrel
Private tamanho  := " "
Private limite   := 132
PRIVATE aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
PRIVATE nomeprog := "PA0149"
PRIVATE aLinha   := { },nLastKey := 0
PRIVATE cPerg    := "PA0149"

cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1

pergunte("PA0149",.F.)

wnrel := "PA0149"
aOrd  := {}
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

If nLastKey==27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

nTipo  := IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))
Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
_bAcao01   := {|_lFim| PA149A(@_lFim) }
_cTitulo01 := 'Processando'

RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

dbSelectArea("ZD2")
dbCloseArea()

Return

Static Function PA149A(_lSair)

_cQ := " SELECT D2_CLIENTE,D2_LOJA,D2_PROCLI,D2_COD,B1_DESC,A1_NOME,SUM(D2_QUANT) AS D2_QUANT,SUM(D2_TOTAL) AS D2_TOTAL  FROM "+RetSqlName("SD2")+" D2 "
_cQ += " INNER JOIN "+RetSqlName("SB1")+" B1 ON D2_COD=B1_COD "
_cQ += " INNER JOIN "+RetSqlName("SA1")+" A1 ON D2_CLIENTE+D2_LOJA=A1_COD+A1_LOJA "
_cQ += " INNER JOIN "+RetSqlName("SF4")+" F4 ON D2_TES=F4_CODIGO "
_cQ += " WHERE A1.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' AND D2.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' "
_cQ += " AND F4_DUPLIC = 'S' AND D2_CLIENTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
_cQ += " AND D2_LOJA BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND D2_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
_cQ += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
_cQ += " AND D2_GRUPO BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
_cQ += " GROUP BY D2_CLIENTE,D2_LOJA,A1_NOME,D2_PROCLI,D2_COD,B1_DESC"
If MV_PAR11 == 1  // Quantidade
	_cQ += " ORDER BY D2_CLIENTE,D2_LOJA,D2_QUANT DESC"
Else                                                   
	_cQ += " ORDER BY D2_CLIENTE,D2_LOJA,D2_TOTAL DESC"
Endif                                            

TCQUERY _cQ NEW ALIAS "ZD2"

ZD2->(dbGotop())

titulo := "Faturamento Por Ranking de Produtos "+DTOC(MV_PAR07)+" Ate "+DTOC(MV_PAR08)
Cabec1 := "Produto         Prod x Cliente  Decricao do Produto              Quantidade        Valor Rank"
Cabec2 := ""

/*
Produto         Prod x Cliente  Decricao do Produto              Quantidade        Valor Rank
999999999999999 999999999999999 999999999999999999999999999999 999999999999 999999999999 9999
0               16              32                             63           76           89
*/
                          
_nGQtde := _nGValor := 0

ProcRegua(ZD2->(U_CONTREG()))

While ZD2->(!Eof()) .And. !_lSair
	
	_cCliente := ZD2->D2_CLIENTE + ZD2->D2_LOJA
	
	If li > 65
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		li:= 9
	Endif
	
	@Li,000 PSAY "Cliente : "+ZD2->D2_CLIENTE+ " Loja: "+ZD2->D2_LOJA+" Nome: "+ZD2->A1_NOME
	Li+=2
	_nCont := 0
	_nQtde := _nValor := 0
	
	While ZD2->(!Eof()) .And. _cCliente == ZD2->D2_CLIENTE + ZD2->D2_LOJA
		
		_nCont++
		
		If _nCont > MV_PAR12
			ZD2->(dbSkip())
			Loop
		Endif                                 
		
		If _lSair
			Alert("Cancelado pelo Usuario!!!")
		Endif
		
		IF li > 65
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			li:= 9
			@Li,000 Psay "Cliente : "+ZD2->D2_CLIENTE+ " Nome: "+ZD2->A1_NOME
			Li+=2
		Endif
		
		@Li,000 PSAY ZD2->D2_COD
		@Li,016 PSAY ZD2->D2_PROCLI
		@Li,032 PSAY Substr(ZD2->B1_DESC,1,30)
		@Li,063 PSAY ZD2->D2_QUANT                 Picture TM(ZD2->D2_QUANT,12)
		@Li,076 PSAY ZD2->D2_TOTAL                 Picture TM(ZD2->D2_TOTAL,12)
		@Li,089 PSAY _nCont                        Picture TM(_nCont,3,0)
		
		li++
		_nQtde += ZD2->D2_QUANT
		_nValor+= ZD2->D2_TOTAL
		
		ZD2->(dbSkip())
	EndDo
	
	Li++
	@Li,016 PSAY "Total do Cliente --> "
	@Li,063 PSAY _nQtde                        Picture TM(_nQtde,12)
	@Li,076 PSAY _nValor                       Picture TM(_nValor,12)	

	_nGQtde += _nQtde
	_nGValor+= _nValor
	
	LI+=2
EndDo
              
@Li,016 PSAY "Total Geral --> "
@Li,063 PSAY _nGQtde                        Picture TM(_nQtde,12)
@Li,076 PSAY _nGValor                       Picture TM(_nValor,12)	


Set Filter To
set device to screen
If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Return



Static Function AtuSX1()

cPerg := "PA0149"
aRegs :={}

///////////////////////////////////////////////
///////////////////////////////////////////////
/////  Grupo de Pergunta PA0149          //////
/////  MV_PAR01 : Cliente      De ?      //////
/////  MV_PAR02 : Cliente     Ate ?      //////
/////  MV_PAR03 : Loja Ate     De ?      //////
/////  MV_PAR04 : Loja Ate    Ate ?      //////
/////  MV_PAR05 : Produto      De ?      //////
/////  MV_PAR06 : Produto     Ate ?      //////
/////  MV_PAR07 : Emissao      De ?      //////
/////  MV_PAR08 : Emissao     Ate ?      //////
/////  MV_PAR09 : Grupo        De ?      //////
/////  MV_PAR10 : Grupo       Ate ?      //////
///////////////////////////////////////////////
///////////////////////////////////////////////

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01        /defspa1/defeng1/Cnt01/Var02/Def02  /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Cliente De            ?",""       ,""      ,"mv_ch1","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR01",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CLI")
U_CRIASX1(cPerg,"02","Cliente Ate           ?",""       ,""      ,"mv_ch2","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR02",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CLI")
U_CRIASX1(cPerg,"03","Loja    De            ?",""       ,""      ,"mv_ch3","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR03",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"04","Loja    Ate           ?",""       ,""      ,"mv_ch4","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR04",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"05","Produto De            ?",""       ,""      ,"mv_ch5","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR05",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
U_CRIASX1(cPerg,"06","Produto Ate           ?",""       ,""      ,"mv_ch6","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR06",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
U_CRIASX1(cPerg,"07","Emissao De            ?",""       ,""      ,"mv_ch7","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR07",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"08","Emissao Ate           ?",""       ,""      ,"mv_ch8","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR08",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"09","Grupo   De            ?",""       ,""      ,"mv_ch9","C" ,04     ,0      ,0     ,"G",""        ,"MV_PAR09",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SBM")
U_CRIASX1(cPerg,"10","Grupo   Ate           ?",""       ,""      ,"mv_cha","C" ,04     ,0      ,0     ,"G",""        ,"MV_PAR10",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SBM")
U_CRIASX1(cPerg,"11","Ordem de Qtde ou Valor?",""       ,""      ,"mv_chb","N" ,01     ,0      ,0     ,"C",""        ,"MV_PAR11","Quantidade" ,""     ,""     ,""   ,""   ,"Valor",""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"12","Listar Os xx Maiores  ?",""       ,""      ,"mv_chc","N" ,03     ,0      ,0     ,"G",""        ,"MV_PAR12",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return
