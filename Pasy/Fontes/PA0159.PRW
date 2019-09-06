#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PA0159    ºAutor  ³Fabiano da Silva    º Data ³  19/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faturamento por Ranking de Produtos                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Sigafat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PA0159()

Private nTipo
Private CbTxt
Private cDesc1     := "Este programa ira emitir a relacao do Faturamento dos   ,"
Private cDesc2     := "Clientes por Ranking de Produtos conforme parametros     "
Private cDesc3     := "informados pelo usuario.PA0159                           "
Private cString    := "SD2"
Private titulo     := "Faturamento Por Ranking de Produtos "
Private CbCont,cabec1,cabec2,wnrel
Private tamanho    := " "
Private limite     := 132
PRIVATE aReturn    := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
PRIVATE nomeprog   := "PA0159"
PRIVATE aLinha     := { },nLastKey := 0
PRIVATE cPerg      := "PA0149"

cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1

pergunte("PA0149",.F.)

wnrel := "PA0159"
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
_bAcao01   := {|_lFim| PA159A(@_lFim) }
_cTitulo01 := 'Processando'

RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

dbSelectArea("ZD2")
dbCloseArea()

Return
                           

Static Function PA159A(_lSair)

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
	_cQ += " ORDER BY D2_QUANT DESC"
Else                                                   
	_cQ += " ORDER BY D2_TOTAL DESC"
Endif                                            

TCQUERY _cQ NEW ALIAS "ZD2"

ZD2->(dbGotop())

titulo := "Faturamento Por Ranking de Produtos "+DTOC(MV_PAR07)+" Ate "+DTOC(MV_PAR08)
Cabec1 := "Produto         Prod x Cliente  Decricao do Produto              Quantidade        Valor Ranking  Cliente Loja"
Cabec2 := ""

/*
Produto         Prod x Cliente  Decricao do Produto              Quantidade        Valor Ranking  Cliente Loja
999999999999999 999999999999999 999999999999999999999999999999 999999999999 999999999999 9999     999999  99
0               16              32                             63           76           89       98      106
*/
                          
_nGQtde := _nGValor := 0
_nCont  := _nQtde   := _nValor := 0

ProcRegua(ZD2->(U_CONTREG()))

While ZD2->(!Eof()) .And. !_lSair
		
	If li > 65
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		li:= 9
	Endif
			
	_nCont++
		
	If _nCont > MV_PAR12
		ZD2->(dbSkip())
		Loop
	Endif                                 
		
	If _lSair
		Alert("Cancelado pelo Usuario!!!")
	Endif
		
	@Li,000 PSAY ZD2->D2_COD
	@Li,016 PSAY ZD2->D2_PROCLI
	@Li,032 PSAY Substr(ZD2->B1_DESC,1,30)
	@Li,063 PSAY ZD2->D2_QUANT                 Picture TM(ZD2->D2_QUANT,12)
	@Li,076 PSAY ZD2->D2_TOTAL                 Picture TM(ZD2->D2_TOTAL,12)
	@Li,089 PSAY _nCont                        Picture TM(_nCont,3,0)
	@Li,098 PSAY ZD2->D2_CLIENTE
	@Li,106 PSAY ZD2->D2_LOJA
		
	li++
	_nQtde += ZD2->D2_QUANT
	_nValor+= ZD2->D2_TOTAL
		
	ZD2->(dbSkip())
EndDo
	
LI++
              
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