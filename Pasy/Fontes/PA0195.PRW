#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa PA0195
Autor 		: Fabiano da Silva	-	21/10/09
Uso 		: SIGAEST - EST
Descrição 	: Atualiza Último Preço Produto (MP).
*/                                                                                   '

USER FUNCTION PA0195()

LOCAL oDlg := NIL

PRIVATE cTitulo    	:= "Atualiza Último Preço Compra MP"
PRIVATE oPrn       	:= NIL
PRIVATE oFont1     	:= NIL
PRIVATE oFont2     	:= NIL
PRIVATE oFont3     	:= NIL
PRIVATE oFont4     	:= NIL
PRIVATE oFont5     	:= NIL
PRIVATE oFont6     	:= NIL
PRIVATE _nCont     	:= 0

DEFINE FONT oFont1 NAME "Arial" SIZE 0,10 OF oPrn BOLD
DEFINE FONT oFont2 NAME "Arial" SIZE 0,13 OF oPrn BOLD
DEFINE FONT oFont3 NAME "Arial" SIZE 0,14 OF oPrn BOLD UNDERLINE
DEFINE FONT oFont4 NAME "Arial" SIZE 0,10 OF oPrn
DEFINE FONT oFont5 NAME "Arial" SIZE 0,10 OF oPrn BOLD
DEFINE FONT oFont6 NAME "Courier New" BOLD

//AtuSX1()

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 010,017 SAY "Esta rotina tem por objetivo atualizar o último 		" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 020,017 SAY "preço de compra no cadastro de Produto abatendo o	" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 030,017 SAY "ICMS e somando o IPI.                           		" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 040,017 SAY "                                                		" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 050,017 SAY "                                                		" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 070,017 SAY "Programa PA0195.PRW                             		" OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED

@ 35,167 BUTTON "OK" 			SIZE 036,012 ACTION (PA195A(),oDlg:End()) 	OF oDlg PIXEL
@ 60,167 BUTTON "Sair"       	SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)


Static Function PA195A()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA195B(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return(Nil)


Static Function PA195B()

_cProd1 := _cProd2 := ""

aStru := {}
AADD(aStru,{"PRODUTO" 	, "C" , 15, 0 })
AADD(aStru,{"DESCRIC"	, "C" , 50, 0 })
AADD(aStru,{"EMISSAO"	, "D" , 08, 0 })
AADD(aStru,{"UM"   		, "C" , 02, 0 })
AADD(aStru,{"UNITARI"   , "N" , 12, 4 })
AADD(aStru,{"QUANTID"   , "N" , 12, 4 })
AADD(aStru,{"TOTAL"    	, "N" , 12, 4 })
AADD(aStru,{"ALIQ_IPI"  , "N" , 12, 4 })
AADD(aStru,{"VALIPI"    , "N" , 12, 4 })
AADD(aStru,{"ALIQ_ICM"  , "N" , 12, 4 })
AADD(aStru,{"VALICM"    , "N" , 12, 4 })
AADD(aStru,{"PRECO"     , "N" , 17, 5 })

cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "PRODUTO"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

_cQuery := " SELECT D1_COD,B1_DESC,D1_EMISSAO,D1_UM,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_IPI,D1_VALIPI,D1_PICM,D1_VALICM,D1_VALIMP5,D1_VALIMP6 "
_cQuery += " FROM "+RetSQLName("SD1")+" D1 (NOLOCK) INNER JOIN "+RetSQLName("SF4")+" F4(NOLOCK) ON D1_TES = F4_CODIGO "
_cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1(NOLOCK) ON D1_COD = B1_COD "
_cQuery += " AND D1_TP = 'MP' AND F4_DUPLIC = 'S' AND D1_TIPO = 'N' "
_cQuery += " WHERE D1.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' "
_cQuery += " ORDER BY D1_COD,D1_EMISSAO DESC"

TCQUERY _cQuery NEW ALIAS "ZD1"

TCSETFIELD("ZD1","D1_EMISSAO","D")

ZD1->(dbGotop())
ProcRegua(LastRec())

While !ZD1->(EOF())
	
	IncProc()

	_cProd1 := ZD1->D1_COD
	
	If _cProd1 <> _cProd2
		
		_nUltPr := ((ZD1->D1_TOTAL - ZD1->D1_VALICM) + ZD1->D1_VALIPI) / ZD1->D1_QUANT
		
		TRB->(RecLock("TRB",.T.))
		TRB->PRODUTO	:= ZD1->D1_COD
		TRB->DESCRIC	:= ZD1->B1_DESC
		TRB->EMISSAO	:= ZD1->D1_EMISSAO
		TRB->UM			:= ZD1->D1_UM
		TRB->UNITARI	:= ZD1->D1_VUNIT
		TRB->QUANTID	:= ZD1->D1_QUANT
		TRB->TOTAL		:= ZD1->D1_TOTAL
		TRB->ALIQ_IPI	:= ZD1->D1_IPI
		TRB->VALIPI		:= ZD1->D1_VALIPI
		TRB->ALIQ_ICM	:= ZD1->D1_PICM
		TRB->VALICM		:= ZD1->D1_VALICM
		TRB->PRECO		:= _nUltPr
		TRB->(MsUnlock())
				
		_cCq := " UPDATE "+RETSQLNAME("SB1")+" SET B1_UPRC = '"+STR(_nUltPr)+"' "
		_cCq += " WHERE B1_COD = '"+ZD1->D1_COD+"' AND D_E_L_E_T_ = '' AND B1_TIPO = 'MP' "
			
		TCSQLEXEC(_cCq)
	Endif

	_cProd2 := ZD1->D1_COD

	ZD1->(dbSkip())
EndDO

ZD1->(dbCloseArea())

_cArqNovo := "\SPOOL\PA0195.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo
	
TRB->(dbCloseArea())
	
If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf
	
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\SPOOL\PA0195.DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return (Nil)