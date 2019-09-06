#INCLUDE "PROTHEUS.CH"
//#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa PA0180
Autor 		: Fabiano da Silva	-	11/05/09
Uso 		: SIGAPCP - PCP
Descrição 	: Gerar Grafico de Indice de Pontualidade de Entrega
*/

USER FUNCTION PA0180()

LOCAL oDlg := NIL

PRIVATE cTitulo    	:= "GRAFICO DE PONTUALIDADE DE ENTREGA PREPARAÇÃO"
PRIVATE oPrn       	:= NIL
PRIVATE oFont1     	:= NIL
PRIVATE oFont2     	:= NIL
PRIVATE oFont3     	:= NIL
PRIVATE oFont4     	:= NIL
PRIVATE oFont5     	:= NIL
PRIVATE oFont6     	:= NIL
PRIVATE _nCont     	:= 0

//AtuSx1()

DEFINE FONT oFont1 NAME "Arial" SIZE 0,10 OF oPrn BOLD
DEFINE FONT oFont2 NAME "Arial" SIZE 0,13 OF oPrn BOLD
DEFINE FONT oFont3 NAME "Arial" SIZE 0,14 OF oPrn BOLD
DEFINE FONT oFont4 NAME "Arial" SIZE 0,10 OF oPrn
DEFINE FONT oFont5 NAME "Arial" SIZE 0,10 OF oPrn BOLD
DEFINE FONT oFont6 NAME "Courier New" BOLD

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 010,017 SAY "Esta rotina tem por objetivo gerar o grafico  " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 020,017 SAY "de Indice de Pontualidade de Entrega conforme os" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 030,017 SAY "parâmetros informados pelo usuário.             " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 040,017 SAY "                                                " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 060,017 SAY "                                                " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED
@ 070,017 SAY "Programa PA0180.PRW                             " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED

@ 10,167 BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("PA0179"))	OF oDlg PIXEL
@ 35,167 BUTTON "OK" 		 SIZE 036,012 ACTION (PA180A(),oDlg:End()) 	OF oDlg PIXEL
@ 60,167 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)


Static Function PA180A()

_cMod   := cModulo
cModulo := "EEC"

_lRet := E_ARQCRW()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA180B(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cArqNew := "\CRYSTAL\PA0180.DBF"
	
dbSelectArea("TRB")
COPY ALL TO &_cArqNew
dbCloseArea()

Private cSeqRel := ""

AVGCRW32("PA0180.RPT","Grafico de Produtividade")

cModulo := _cMod

Return(Nil)


Static Function PA180B()

Pergunte("PA0179",.F.)

_nOk	:=	_nNok	:=	_nEnt_Ant	:=	_nEnt_dep	:=	_nTotal	:=	0

aStru := {}
AADD(aStru,{"ENT_NO_DIA" 	, "N" , 10, 0 })
AADD(aStru,{"NAO_ENT" 		, "N" , 10, 0 })
AADD(aStru,{"ENT_ANTES" 	, "N" , 10, 0 })
AADD(aStru,{"ENT_DEPOIS" 	, "N" , 10, 0 })
AADD(aStru,{"TOTAL" 			, "N" , 10, 0 })
	
cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "ENT_NO_DIA"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)
	
dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

_cQuery  := " SELECT C2_EMISSAO,C2_DATPRF,C2_DATRF,C2_PRODUTO,C2_QUANT,C2_QUJE FROM "+RetSqlName("SC2")+" C2 (NOLOCK) "
_cQuery  += " INNER JOIN "+RetSqlName("SB1")+" B1 (NOLOCK) ON C2_PRODUTO = B1_COD "
_cQuery  += " WHERE C2.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' AND B1_GRUPO = 'PIPF' AND C2_TPOP = 'F' "
_cQuery  += " AND C2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery  += " AND C2_DATPRF BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
_cQuery  += " AND C2_PRODUTO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
_cQuery  += " ORDER BY C2_PRODUTO,C2_DATPRF,C2_EMISSAO "

TCQUERY _cQuery NEW ALIAS "ZC2"

TcSetField("ZC2","C2_EMISSAO","D")
TcSetField("ZC2","C2_DATPRF","D")
TcSetField("ZC2","C2_DATRF","D")

ZC2->(dbGoTop())

ProcRegua(LastRec())

While ZC2->(!EOF())

	IncProc()

	dbSelectArea("SG1")
	dbSetOrder(2)
	dbSeek(xFilial("SG1")+ZC2->C2_PRODUTO)

	dbSelectArea("SZE")
	dbsetOrder(1)
	dbSeek(xFilial("SZE")+SG1->G1_TPRECUR)

	If SG1->G1_TPRECUR < MV_PAR07 .Or. SG1->G1_TPRECUR > MV_PAR08
		Return(Nil)
	Endif

	If !Empty(ZC2->C2_DATRF)
		If ZC2->C2_QUANT = ZC2->C2_QUJE
			If ZC2->C2_DATRF = ZC2->C2_DATPRF
				_nOk ++
			ElseIf	ZC2->C2_DATRF > ZC2->C2_DATPRF
				_nEnt_Dep ++
			ElseIf	ZC2->C2_DATRF < ZC2->C2_DATPRF
				_nEnt_Ant ++
			Endif
		Else
			_nNok ++
		Endif	
	Else
		_nNok ++
	Endif		
	_nTotal ++

	ZC2->(dbSkip())
EndDO

TRB->(RecLock("TRB",.T.))
TRB->ENT_NO_DIA		:= (_nOk / _nTotal) * 100
TRB->NAO_ENT		:= (_nNok / _nTotal) * 100
TRB->ENT_ANTES		:= (_nEnt_Ant / _nTotal) * 100
TRB->ENT_DEPOIS		:= (_nEnt_Dep / _nTotal) * 100
TRB->TOTAL			:= _nTotal
TRB->(MsUnlock())

ZC2->(dbCloseArea())

Return (Nil)