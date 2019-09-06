#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
//#INCLUDE "RWMAKE.CH"

/*
Programa PA0194
Autor 		: Fabiano da Silva	-	19/10/09
Uso 		: SIGACOM - COM
Descrição 	: Gerar relatório de Compra de materia Prima
*/                                                                                   '

USER FUNCTION PA0194()

LOCAL oDlg := NIL

PRIVATE cTitulo    	:= "Relatório de Custo de Compras"
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

AtuSX1()

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 010,017 SAY "Esta rotina tem por objetivo gerar o relatório  		" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 020,017 SAY "de Compras em Excel									" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 030,017 SAY "                                                		" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 040,017 SAY "                                                		" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 050,017 SAY "                                                		" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 070,017 SAY "Programa PA0194.PRW                             		" OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED

//@ 004,165 TO 028,205 LABEL "" OF oDlg PIXEL

@ 10,167 BUTTON "Parametros" 	SIZE 036,012 ACTION ( Pergunte("PA0194"))   OF oDlg PIXEL
@ 35,167 BUTTON "OK" 			SIZE 036,012 ACTION (PA194A(),oDlg:End()) 	OF oDlg PIXEL
@ 60,167 BUTTON "Sair"       	SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)


Static Function PA194A()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA194B(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return(Nil)


Static Function PA194B()

Pergunte("PA0194",.F.)

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
AADD(aStru,{"VALPIS"    , "N" , 12, 4 })
AADD(aStru,{"VALCOF"    , "N" , 12, 4 })

cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "PRODUTO"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

_cQuery := " SELECT D1_COD,B1_DESC,D1_EMISSAO,D1_UM,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_IPI,D1_VALIPI,D1_PICM,D1_VALICM,D1_VALIMP5,D1_VALIMP6 "
_cQuery += " FROM "+RetSQLName("SD1")+" D1 (NOLOCK) INNER JOIN "+RetSQLName("SF4")+" F4(NOLOCK) ON D1_TES = F4_CODIGO "
_cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1(NOLOCK) ON D1_COD = B1_COD "
_cQuery += " AND D1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
_cQuery += " AND D1_TP BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_cQuery += " WHERE D1.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' AND F4_DUPLIC = 'S' AND D1_TIPO = 'N' "
_cQuery += " ORDER BY D1_COD,D1_EMISSAO DESC"

TCQUERY _cQuery NEW ALIAS "ZD1"

TCSETFIELD("ZD1","D1_EMISSAO","D")

ZD1->(dbGotop())
ProcRegua(LastRec())

While !ZD1->(EOF())
	
	IncProc()

	_cProd1 := ZD1->D1_COD
	
	If _cProd1 <> _cProd2
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
		TRB->VALPIS		:= ZD1->D1_VALIMP5
		TRB->VALCOF		:= ZD1->D1_VALIMP6
		TRB->(MsUnlock())
	Endif

	_cProd2 := ZD1->D1_COD

	ZD1->(dbSkip())
EndDO

ZD1->(dbCloseArea())

_cArqNovo := "\SPOOL\PA0194.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo
	
TRB->(dbCloseArea())
	
If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf
	
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\SPOOL\PA0194.DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return (Nil)


Static Function AtuSx1()

Local aHelp := {}
cPerg       := "PA0194"

PutSx1(cPerg,"01","Produto de     ?" ,"","","mv_ch1","C",15,00,00,"G","","SB1"    ,"","","MV_PAR01",""		 	,"","","",""		  		  ,"","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Produto ate    ?" ,"","","mv_ch2","C",15,00,00,"G","","SB1"    ,"","","MV_PAR02",""		 	,"","","",""		  		  ,"","","","","","","","","","","","","","","")
PutSx1(cPerg,"03","Tipo de        ?" ,"","","mv_ch3","C",02,00,00,"G","","02"     ,"","","MV_PAR03",""		 	,"","","",""		  		  ,"","","","","","","","","","","","","","","")
PutSx1(cPerg,"04","Tipo ate       ?" ,"","","mv_ch4","C",02,00,00,"G","","02"     ,"","","MV_PAR04",""		 	,"","","",""		  		  ,"","","","","","","","","","","","","","","")

Return (Nil)
