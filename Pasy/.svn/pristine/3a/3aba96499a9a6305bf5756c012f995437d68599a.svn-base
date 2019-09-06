#INCLUDE "PROTHEUS.CH"
//#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa PA0184
Autor 		: Fabiano da Silva	-	17/06/09
Uso 		: SIGAEST - PCP
Descrição 	: Gerar relatório de Comparação de Estoque
*/

USER FUNCTION PA0184()

LOCAL oDlg := NIL

PRIVATE cTitulo    	:= "RELATÓRIO DE COMPARAÇÃO DE ESTOQUE"
PRIVATE oPrn       	:= NIL
PRIVATE oFont1     	:= NIL
PRIVATE oFont2     	:= NIL
PRIVATE oFont3     	:= NIL
PRIVATE oFont4     	:= NIL
PRIVATE oFont5     	:= NIL
PRIVATE oFont6     	:= NIL
PRIVATE _nCont     	:= 0
Private aRadio  	:= {}
Private nRadio  	:= 1
Private oRadio  	:= Nil

AtuSx1()

aAdd( aRadio, "Relatório" )
aAdd( aRadio, "Excel" )

DEFINE FONT oFont1 NAME "Arial" SIZE 0,10 OF oPrn BOLD
DEFINE FONT oFont2 NAME "Arial" SIZE 0,13 OF oPrn BOLD
DEFINE FONT oFont3 NAME "Arial" SIZE 0,14 OF oPrn BOLD
DEFINE FONT oFont4 NAME "Arial" SIZE 0,10 OF oPrn
DEFINE FONT oFont5 NAME "Arial" SIZE 0,10 OF oPrn BOLD
DEFINE FONT oFont6 NAME "Courier New" BOLD

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 010,017 SAY "Esta rotina tem por objetivo gerar o relatório  " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 020,017 SAY "de Comparação de Estoque conforme os parâmetros " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 030,017 SAY "informados pelo usuário.                        " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 040,017 SAY "                                                " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 060,017 SAY "                                                " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED
@ 070,017 SAY "Programa PA0184.PRW                             " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED

@ 004,165 TO 028,205 LABEL "" OF oDlg PIXEL
@ 08,167 RADIO oRadio VAR nRadio ITEMS "Relatório","Excel" SIZE 33,10 PIXEL OF oDlg

@ 35,167 BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("PA0184"))	OF oDlg PIXEL
@ 50,167 BUTTON "OK" 		 SIZE 036,012 ACTION (PA184A(),oDlg:End()) 	OF oDlg PIXEL
@ 65,167 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)


Static Function PA184A()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA184B(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return(Nil)


Static Function PA184B()

Pergunte("PA0184",.F.)

aStru := {}
AADD(aStru,{"PRODUTO" 	, "C" , 15, 0 })
AADD(aStru,{"ARMAZEM"	, "C" ,  2, 0 })
AADD(aStru,{"DESCRIC"	, "C" , 40, 0 })
AADD(aStru,{"DATA_01"	, "D" ,  8, 0 })
AADD(aStru,{"DATA_02"	, "D" ,  8, 0 })
AADD(aStru,{"QUAN_01" 	, "N" , 14, 2 })
AADD(aStru,{"QUAN_02" 	, "N" , 14, 2 })

cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "PRODUTO"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

private nQuant     	:= 1
private cProduto   	:= ""
private cQtd
Private aArray   	:= {}
_nOk := _nNEnt := _nEntAnt := _nEntDep := 0

_dData1 := LastDay(MV_PAR01 - 35)
_dData2 := LastDay(MV_PAR01)

_cQuery  := " SELECT B9_COD,B1_DESC,B9_LOCAL,B9_DATA,B9_QINI FROM "+RetSqlName("SB9")+" B9 (NOLOCK) "
_cQuery  += " INNER JOIN "+RetSqlName("SB1")+" B1 (NOLOCK) ON B9_COD = B1_COD "
_cQuery  += " WHERE B1.D_E_L_E_T_ = '' AND B9.D_E_L_E_T_ = '' "
_cQuery  += " AND B9_DATA BETWEEN '"+DTOS(_dData1)+"' AND '"+DTOS(_dData2)+"' "
_cQuery  += " AND B9_COD BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' "
_cQuery  += " AND B9_LOCAL = '"+MV_PAR04+"' "
_cQuery  += " AND B1_TIPO = 'MP' "
_cQuery  += " ORDER BY B9_COD,B9_LOCAL,B9_DATA"

TCQUERY _cQuery NEW ALIAS "ZB9"

TcSetField("ZB9","B9_DATA","D")

ZB9->(dbGoTop())

ProcRegua(LastRec())

While ZB9->(!EOF())
	
	IncProc()
	
	If !TRB->(dbSeek(ZB9->B9_COD))	 // 1ª DATA
		RecLock("TRB",.T.)
		TRB->PRODUTO	:= ZB9->B9_COD
		TRB->ARMAZEM	:= ZB9->B9_LOCAL
		TRB->DESCRIC	:= ZB9->B1_DESC
		TRB->DATA_01	:= _dData1
		TRB->QUAN_01	:= ZB9->B9_QINI
	Else
		RecLock("TRB",.F.)   	 // 2ª DATA
		TRB->DATA_02	:= _dData2
		TRB->QUAN_02	:= ZB9->B9_QINI
		MsUnlock()
	Endif
	
	ZB9->(dbSkip())
EndDO

If nRadio == 1
	
	oPrn := TMSPrinter():New(cTitulo)
	oPrn:SetPortrait()
	_nLin  := 3000
	_lEnt  := .F.
	_nQuant01 := _nQuant02 := 0
	
	TRB->(dbGoTop())
	
	ProcRegua(LastRec())
	
	While TRB->(!EOF())
		
		IncProc()
		
		If _nLin > 2900
			If _lEnt
				oPrn:EndPage()
			Endif
			oPrn:StartPage()
			Cabec(_nCont)
			_nLin := 260
		Endif
		
		oPrn:Say(_nLin,0090, TRB->PRODUTO												,oFont4)
		oPrn:Say(_nLin,0300, TRB->ARMAZEM												,oFont4)
		oPrn:Say(_nLin,0500, TRB->DESCRIC												,oFont4)
		oPrn:Say(_nLin,1280, Trans(TRB->QUAN_01						, "@E 999,999.99")	,oFont4)
		oPrn:Say(_nLin,1690, Trans(TRB->QUAN_02						, "@E 999,999.99")	,oFont4)
		oPrn:Say(_nLin,2000, Trans((TRB->QUAN_02 - TRB->QUAN_01)	, "@E 999,999.99")	,oFont4)
		
		_nLin += 40
		oPrn:Line(_nLin,0080,_nLin,2250)
		_nLin += 5
		
		_nQuant01 += TRB->QUAN_01
		_nQuant02 += TRB->QUAN_02
		_lEnt := .T.
		
		TRB->(dbSkip())
	EndDo
	
	oPrn:Line(_nLin,0080,_nLin,2250)
	_nLin += 5
	
	oPrn:Say(_nLin,0090, "TOTAL -->"										,oFont4)
	oPrn:Say(_nLin,1280, Trans(_nQuant01				, "@E 999,999.99")	,oFont4)
	oPrn:Say(_nLin,1690, Trans(_nQuant02				, "@E 999,999.99")	,oFont4)
	oPrn:Say(_nLin,2000, Trans((_nQuant02 - _nQuant01)	, "@E 999,999.99")	,oFont4)
	
	_nLin += 40
	oPrn:Line(_nLin,0080,_nLin,2250)
	
	Ms_Flush()
	oPrn:EndPage()
	oPrn:End()
	
	oPrn:Preview()

	TRB->(dbCloseArea())
	
ElseIf nRadio == 2
	
	_cArqNovo := "\SPOOL\PA0184.DBF"
	dbSelectArea("TRB")
	Copy all to &_cArqNovo
	
	TRB->(dbCloseArea())
	
	If ! ApOleClient( 'MsExcel' )
		MsgStop('MsExcel nao instalado')
		Return
	EndIf
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\spool\PA0184.DBF" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	
Endif

ZB9->(dbCloseArea())

Return (Nil)


STATIC FUNCTION Cabec() //Cabeçalho

oPen	:= TPen():New(10,100,CLR_HRED,oPrn)

Define brush oBr color CLR_HRED

oPrn:SayBitmap(0095,0090,"lgrl01.bmp",0250,0070)

oPrn:Box(0080,0080,3000,2250, oPen)

oPrn:Line(0180,0080,0180,2250)
oPrn:Line(0190,0080,0190,2250)

oPrn:Say(0105,0900,cTitulo,oFont3)
oPrn:Say(0090,2080,dtoc(dDataBase),oFont5)
oPrn:Say(0130,2080,Time(),oFont5)

oPrn:Say(0196,0090,"PRODUTO",oFont5)
oPrn:Line(0190,0290,2950,0290) //Vertical
oPrn:Say(0196,0300,"ARMAZEM",oFont5)
oPrn:Line(0190,0490,2950,0490) //Vertical
oPrn:Say(0196,0500,"DESCRICAO",oFont5)
oPrn:Line(0190,1140,2950,1140) //Vertical
oPrn:Say(0196,1290,dToc(_dData1),oFont5)
oPrn:Line(0190,1570,2950,1570) //Vertical
oPrn:Say(0196,1700,dToc(_dData2),oFont5)
oPrn:Line(0190,1900,2950,1900) //Vertical
oPrn:Say(0196,2010,"SALDO",oFont5)

oPrn:Line(0240,0080,0240,2250)

_nCont ++

//Rodapé
oPrn:Line(2950,0080,2950,2250)
oPrn:Say(2955,2050,"Página "+STRZERO(_nCont,3),oFont5)

Return()


Static Function AtuSx1(cPerg)

Local aHelp := {}
cPerg       := "PA0184"

PutSx1(cPerg,"01","Data          ?" ,"","","mv_ch1","D",08,00,00,"G","",""       ,"","","MV_PAR01",""		 	,"","","",""		  		  ,"","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Produto de    ?" ,"","","mv_ch2","C",15,00,00,"G","","SB1"    ,"","","MV_PAR02",""		 	,"","","",""		  		  ,"","","","","","","","","","","","","","","")
PutSx1(cPerg,"03","Produto ate   ?" ,"","","mv_ch3","C",15,00,00,"G","","SB1"    ,"","","MV_PAR03",""		 	,"","","",""		  		  ,"","","","","","","","","","","","","","","")
PutSx1(cPerg,"04","Local         ?" ,"","","mv_ch4","C",02,00,00,"G","",""       ,"","","MV_PAR04",""		 	,"","","",""		  		  ,"","","","","","","","","","","","","","","")

Return (Nil)
