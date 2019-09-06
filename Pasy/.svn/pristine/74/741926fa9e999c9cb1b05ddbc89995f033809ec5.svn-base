#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa PA0177
Autor 		: Fabiano da Silva	-	27/04/09
Uso 		: SIGAPCP - PCP
Descrição 	: Gerar relatório da Programação de Mistura
*/

USER FUNCTION PA0177()

LOCAL oDlg := NIL

PRIVATE cTitulo    	:= "PROGRAMAÇÃO DE MISTURA"
PRIVATE oPrn       	:= NIL
PRIVATE oFont1     	:= NIL
PRIVATE oFont2     	:= NIL
PRIVATE oFont3     	:= NIL
PRIVATE oFont4     	:= NIL
PRIVATE oFont5     	:= NIL
PRIVATE oFont6     	:= NIL
PRIVATE _nCont     	:= 0

AtuSx1()

DEFINE FONT oFont1 NAME "Arial" SIZE 0,10 OF oPrn BOLD
DEFINE FONT oFont2 NAME "Arial" SIZE 0,13 OF oPrn BOLD
DEFINE FONT oFont3 NAME "Arial" SIZE 0,14 OF oPrn BOLD
DEFINE FONT oFont4 NAME "Arial" SIZE 0,10 OF oPrn
DEFINE FONT oFont5 NAME "Arial" SIZE 0,10 OF oPrn BOLD
DEFINE FONT oFont6 NAME "Courier New" BOLD

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 010,017 SAY "Esta rotina tem por objetivo gerar o relatório  " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 020,017 SAY "de Programação de Mistura conforme os           " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 030,017 SAY "parâmetros informados pelo usuário.             " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 040,017 SAY "                                                " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 060,017 SAY "FP_10_REV_03                                    " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED
@ 070,017 SAY "Programa PA0177.PRW                             " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED

@ 10,167 BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("PA0177"))	OF oDlg PIXEL
@ 35,167 BUTTON "OK" 		 SIZE 036,012 ACTION (PA177A(),oDlg:End()) 	OF oDlg PIXEL
@ 60,167 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)


Static Function PA177A()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA177B(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return(Nil)


Static Function PA177B()

Pergunte("PA0177",.F.)

_cQuery  := " SELECT C2_PRODUTO,B1_QB,SUM(C2_QUANT - C2_QUJE) AS QUANT FROM "+RetSqlName("SC2")+" C2 (NOLOCK) "
_cQuery  += " INNER JOIN "+RetSqlName("SB1")+" B1 (NOLOCK) ON C2_PRODUTO = B1_COD "
_cQuery  += " WHERE C2.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' AND C2_LOCAL = '10' AND C2_QUANT > C2_QUJE AND C2_TPOP = 'F' "
_cQuery  += " AND C2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery  += " AND C2_DATPRF BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
_cQuery  += " AND C2_PRODUTO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
_cQuery  += " GROUP BY C2_PRODUTO,B1_QB "
_cQuery  += " ORDER BY C2_PRODUTO "

TCQUERY _cQuery NEW ALIAS "ZC2"

oPrn := TMSPrinter():New(cTitulo)
oPrn:SetPortrait()
	
_nLin  := 3000
_lEnt  := .F.

ZC2->(dbGoTop())

ProcRegua(LastRec())

While ZC2->(!EOF())

	IncProc()

	If _nLin > 2900
		If _lEnt
			oPrn:EndPage()
		Endif
		oPrn:StartPage()
		Cabec(_nCont)
		_nLin := 260
	Endif
		
	oPrn:Say(_nLin,0090, ZC2->C2_PRODUTO						,oFont4)
	oPrn:Say(_nLin,0800, TRAN(ZC2->B1_QB , "@E 9,999.999999")	,oFont4)
	oPrn:Say(_nLin,1320, TRAN(ZC2->QUANT , "@E 9999,999.999")	,oFont4)
//	oPrn:Say(_nLin,1720,                                 		,oFont4)
//	oPrn:Say(_nLin,2060,                                  		,oFont4)
	
	_nLin += 40
	oPrn:Line(_nLin,0080,_nLin,2250)
	_nLin += 5

	_lEnt := .T.
		
	ZC2->(dbSkip())
EndDO
		
Ms_Flush()
oPrn:EndPage()
oPrn:End()

oPrn:Preview()

ZC2->(dbCloseArea())

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

oPrn:Say(0196,0090,"COMPOSTO",oFont5)
oPrn:Line(0190,0570,2950,0570) //Vertical
oPrn:Say(0196,0800,"LOTE MINIMO",oFont5)
oPrn:Line(0190,1220,2950,1220) //Vertical
oPrn:Say(0196,1320,"QUANTIDADE",oFont5)
oPrn:Line(0190,1630,2950,1630) //Vertical
oPrn:Say(0196,1720,"PRODUZIR",oFont5)
oPrn:Line(0190,1970,2950,1970) //Vertical
oPrn:Say(0196,2060,"VISTO",oFont5)
oPrn:Line(0240,0080,0240,2250) //Horizontal

_nCont ++

//Rodapé
oPrn:Line(2950,0080,2950,2250)
oPrn:Say(2955,0090,"FP_10_REV_03",oFont5)
oPrn:Say(2955,2050,"Página "+STRZERO(_nCont,3),oFont5)

Return()


Static Function AtuSx1(cPerg)

Local aHelp := {}
cPerg       := "PA0177"

//            Texto do help em português        			 , Inglês, Espanhol
AAdd(aHelp, {{"Data Inicial da Emissão da OP"				}, {""} , {""}})
AAdd(aHelp, {{"Data Final da Emissão da OP"					}, {""} , {""}})
AAdd(aHelp, {{"Data Inicial de Entrega da OP"				}, {""} , {""}})
AAdd(aHelp, {{"Data Final da Entrega da OP"					}, {""} , {""}})
AAdd(aHelp, {{"Informe o Composto Inicial"  				}, {""} , {""}})
AAdd(aHelp, {{"Informe o Composto Final"    				}, {""} , {""}})

PutSx1(cPerg,"01","Emissao de       ?" ,"","","mv_ch1","D",08,00,00,"G","",""   	,"","","MV_PAR01",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[1 ,1],aHelp[1 ,2],aHelp[1 ,3],"")
PutSx1(cPerg,"02","Emissao ate      ?" ,"","","mv_ch2","D",08,00,00,"G","",""   	,"","","MV_PAR02",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[2 ,1],aHelp[2 ,2],aHelp[2 ,3],"")
PutSx1(cPerg,"03","Entrega de       ?" ,"","","mv_ch3","D",08,00,00,"G","",""   	,"","","MV_PAR03",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[3 ,1],aHelp[3 ,2],aHelp[3 ,3],"")
PutSx1(cPerg,"04","Entrega ate      ?" ,"","","mv_ch4","D",08,00,00,"G","",""   	,"","","MV_PAR04",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[4 ,1],aHelp[4 ,2],aHelp[4 ,3],"")
PutSx1(cPerg,"05","Composto de     	?" ,"","","mv_ch5","C",15,00,00,"G","","SB1COM"	,"","","MV_PAR05",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[5 ,1],aHelp[5 ,2],aHelp[5 ,3],"")
PutSx1(cPerg,"06","Composto ate    	?" ,"","","mv_ch6","C",15,00,00,"G","","SB1COM"	,"","","MV_PAR06",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[6 ,1],aHelp[6 ,2],aHelp[6 ,3],"")
//PutSx1(cPerg,"07","Tipo		    	?" ,"","","mv_ch7","N",01,00,00,"C","",""   ,"","","MV_PAR07","Analítico","","","","Sintético","","","","","","","","","","","",aHelp[7,1],aHelp[7,2],aHelp[7,3],"")

Return (Nil)
