#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa PA0188
Autor 		: Fabiano da Silva	-	03/08/09
Uso 		: SIGAPCP - PCP
Descrição 	: Gerar relatório de Unidade de Medidas
*/

USER FUNCTION PA0188()

LOCAL oDlg := NIL

PRIVATE cTitulo    	:= "Relatório de Unidade de Medidas"
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

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 010,017 SAY "Esta rotina tem por objetivo gerar o relatório  		" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 020,017 SAY "de Unidade de Medida									" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 030,017 SAY "                                                		" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 040,017 SAY "                                                		" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 050,017 SAY "                                                		" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 070,017 SAY "Programa PA0188.PRW                             		" OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED

//@ 004,165 TO 028,205 LABEL "" OF oDlg PIXEL

//@ 10,167 BUTTON "Parametros" 	SIZE 036,012 ACTION ( Pergunte("PA0175"))   OF oDlg PIXEL
@ 35,167 BUTTON "OK" 			SIZE 036,012 ACTION (PA188A(),oDlg:End()) 	OF oDlg PIXEL
@ 60,167 BUTTON "Sair"       	SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)


Static Function PA188A()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA188B(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return(Nil)


Static Function PA188B()

aStru := {}
AADD(aStru,{"CLIENTE" 	, "C" , 06, 0 })
AADD(aStru,{"LOJA" 		, "C" , 02, 0 })
AADD(aStru,{"COD_CLI"   , "C" , 15, 0 })
AADD(aStru,{"UM_CLI"    , "C" , 02, 0 })
AADD(aStru,{"COD_PA"    , "C" , 15, 0 })
AADD(aStru,{"UM_PA"     , "C" , 02, 0 })
AADD(aStru,{"COD_MP"    , "C" , 15, 0 })
AADD(aStru,{"UM_MP1"    , "C" , 02, 0 })
AADD(aStru,{"UM_MP2"    , "C" , 02, 0 })
AADD(aStru,{"QUANTID" 	, "N" , 12, 6 })
AADD(aStru,{"COD_DP"    , "C" , 15, 0 })
AADD(aStru,{"DESC_DP"   , "C" , 60, 0 })

cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "CLIENTE+LOJA+COD_PA+COD_MP"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

private nQuant     	:= 1
private cProduto   	:= SPACE(LEN(SC2->C2_PRODUTO))
private cQtd
private cIndSC2    	:= CriaTrab(NIL,.F.), nIndSC2
Private aArray   	:= {}
Private _cProdPa 	:= ""
Private	_cUM_PA  	:= ""

cbtxt           	:= SPACE(10)
_cMolde  			:= ""
_cMatriz 			:= ""
_nQPF    			:= _nQPecas := 0
_cCond2          	:= ".T."

_cQuery := " SELECT Z2_CLIENTE,Z2_LOJA,Z2_PRODUTO,Z2_CODCLI,Z2_UM FROM "+RetSqlName("SZ2")+" Z2 (NOLOCK) "
_cQuery += " WHERE Z2_ATIVO = '1' AND Z2.D_E_L_E_T_ = ''"
_cQuery += " ORDER BY Z2_CLIENTE,Z2_LOJA,Z2_PRODUTO "

TCQUERY _cQuery NEW ALIAS "ZZ2"

ZZ2->(dbGotop())
ProcRegua(LastRec())

While !ZZ2->(EOF())
	
	IncProc()
	
	cProduto  := ZZ2->Z2_PRODUTO
	nQuant    := aSC2Sld()
	
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+cProduto)
	
	If SB1->B1_TIPO == "PA" .And. SB1->B1_GRUPO == "PAV "
		_lVazados := .T.
		_lVazad   := .T.
	Endif
	
	If SB1->B1_GRUPO $ "PIC "
		ZZ2->(dbSkip())
		Loop
	EndIf
	
	If SB1->B1_GRUPO == "PIPB" .And. !_lVazados
		ZZ2->(dbSkip())
		Loop
	EndIf

	If SB1->B1_TIPO == "PA"    // Primeira Via - Produto Acabado
		_cProdPa := SB1->B1_COD
		_cUM_PA  := SB1->B1_UM
		PA188E()
	Endif
	
	dbSelectArea("ZZ2")
	dbSkip()
EndDO

ZZ2->(dbCloseArea())

_cArqNovo := "\SPOOL\PA0188.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo
	
TRB->(dbCloseArea())
	
If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf
	
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\SPOOL\PA0188.DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return (Nil)


Static Function PA188E()

_cProdPre 	:= SB1->B1_COD
nEstru 		:= 0
aEstru    	:= Estrut(_cProdPa)

dbSelectarea("SB1")
_cAliSB1 := Alias()
_nOrdSB1 := IndexOrd()
_nRecSB1 := Recno()

For E:= 1 To Len(aEstru)
	
	dbSelectarea("SB1")
	dbSetOrder(1)
	If dbseek(xFilial("SB1")+aEstru[E,3])
		
		If SB1->B1_TIPO = 'MP' .And. SB1->B1_GRUPO = 'MPC '
			
			SG1->(dbSetOrder(2))
			If SG1->(dbSeek(xfilial("SG1")+aEstru[E,3]+aEstru[E,2]))
				
				_CQ := "SELECT D1_COD,D1_SEGUM FROM SD1010 D1 WHERE D1_COD = '"+aEstru[E,3]+"' AND D1.D_E_L_E_T_ = '' AND D1_SEGUM <> '' "
				
				TCQUERY _CQ NEW ALIAS "ZD1"
				
				If SB1->B1_TIPO == "MP" .And. SB1->B1_GRUPO != "MPIM"
					TRB->(RecLock("TRB",.T.))
					TRB->CLIENTE	:= ZZ2->Z2_CLIENTE
					TRB->LOJA		:= ZZ2->Z2_LOJA
					TRB->COD_CLI	:= ZZ2->Z2_CODCLI
					TRB->UM_CLI		:= ZZ2->Z2_UM
					TRB->COD_PA		:= _cProdPa
					TRB->UM_PA		:= _cUM_PA
					TRB->COD_MP		:= SB1->B1_COD
					TRB->UM_MP1		:= SB1->B1_UM
					TRB->UM_MP2		:= ZD1->D1_SEGUM
					TRB->QUANTID	:= SG1->G1_QUANT
					TRB->(MsUnlock())
				Endif
				
				ZD1->(dbCloseArea())
			Endif
		ElseIf SB1->B1_TIPO = 'DP'
			If TRB->(dbSeek(ZZ2->Z2_CLIENTE+ZZ2->Z2_LOJA+_cProdPa))
				TRB->(RecLock("TRB",.F.))
				TRB->COD_DP	 := SB1->B1_COD
				TRB->DESC_DP := SB1->B1_DESC
				TRB->(MsUnlock())
			Endif
		Endif		
	Endif
Next E

dbSelectArea("SB1")
dbSetOrder(_nOrdSB1)
dbGoto(_nRecSB1)

Return (Nil)