#INCLUDE "PROTHEUS.CH"
//#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa PA0179
Autor 		: Fabiano da Silva	-	05/05/09
Uso 		: SIGAPCP - PCP
Descrição 	: Gerar relatório de Indice de Pontualidade de Entrega
*/

USER FUNCTION PA0179()

LOCAL oDlg := NIL

PRIVATE cTitulo    	:= "INDICE DE PONTUALIDADE DE ENTREGA PREPARAÇÃO"
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
@ 020,017 SAY "de Indice de Pontualidade de Entrega conforme os" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 030,017 SAY "parâmetros informados pelo usuário.             " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 040,017 SAY "                                                " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 060,017 SAY "                                                " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED
@ 070,017 SAY "Programa PA0179.PRW                             " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED

@ 10,167 BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("PA0179"))	OF oDlg PIXEL
@ 35,167 BUTTON "OK" 		 SIZE 036,012 ACTION (PA179A(),oDlg:End()) 	OF oDlg PIXEL
@ 60,167 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)


Static Function PA179A()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA179B(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return(Nil)


Static Function PA179B()

Pergunte("PA0179",.F.)

aStru := {}
AADD(aStru,{"ENTR_PR" 	, "D" ,  8, 0 })
AADD(aStru,{"EMISSAO" 	, "D" ,  8, 0 })
AADD(aStru,{"PRODUTO" 	, "C" , 15, 0 })
AADD(aStru,{"EXTRUSO" 	, "C" , 10, 0 })
AADD(aStru,{"QUAN_OP" 	, "N" , 14, 2 })
AADD(aStru,{"QUAN_EN" 	, "N" , 14, 2 })
AADD(aStru,{"ENTR_RE" 	, "D" ,  8, 0 })
	
cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "DTOS(ENTR_PR)+PRODUTO"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)
	
dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")
	
private nQuant     	:= 1
private cProduto   	:= ""
private cQtd
Private aArray   	:= {}
_nOk := _nNEnt := _nEntAnt := _nEntDep := 0

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

	_nQuant := ZC2->C2_QUANT - ZC2->C2_QUJE
	
	dbSelectArea("SG1")
	dbSetOrder(2)
	dbSeek(xFilial("SG1")+ZC2->C2_PRODUTO)

	dbSelectArea("SZE")
	dbsetOrder(1)
	dbSeek(xFilial("SZE")+SG1->G1_TPRECUR)

	If SG1->G1_TPRECUR < MV_PAR07 .Or. SG1->G1_TPRECUR > MV_PAR08
		Return(Nil)
	Endif

	If SZE->ZE_TIPO == "1"
		_cTraf := "TRA(1)"
	ElseIf 	SZE->ZE_TIPO == "2"
		_cTraf := "TRA(2)"
	ElseIf 	SZE->ZE_TIPO == "3"
		_cTraf := "TRA(3)"
	ElseIf 	SZE->ZE_TIPO == "4"
		_cTraf := "BCM"
	ElseIf 	SZE->ZE_TIPO == "5"
		_cTraf := "CILIN"
	ElseIf 	SZE->ZE_TIPO == "6"
		_cTraf := "TRA(2+3)"
	Else
		_cTraf := ""
	Endif

	dbselectarea("TRB")
	RecLock("TRB",.T.)
	TRB->ENTR_PR	:= ZC2->C2_DATPRF
	TRB->EMISSAO	:= ZC2->C2_EMISSAO
	TRB->PRODUTO	:= ZC2->C2_PRODUTO
	TRB->EXTRUSO	:= _cTraf
	TRB->QUAN_OP	:= ZC2->C2_QUANT
	TRB->QUAN_EN	:= ZC2->C2_QUJE
	TRB->ENTR_RE	:= ZC2->C2_DATRF
	MsUnlock()

	If !Empty(ZC2->C2_DATRF)
		If ZC2->C2_QUANT = ZC2->C2_QUJE
			If ZC2->C2_DATRF = ZC2->C2_DATPRF
				_nOk ++
			ElseIf	ZC2->C2_DATRF > ZC2->C2_DATPRF
				_nEntDep ++
			ElseIf	ZC2->C2_DATRF < ZC2->C2_DATPRF
				_nEntAnt ++
			Endif
		Else
			_nNEnt ++
		Endif	
	Else
		_nNEnt ++
	Endif		
	
	ZC2->(dbSkip())
EndDO

oPrn := TMSPrinter():New(cTitulo)
oPrn:SetPortrait()
	
_nLin  := 3000
_lEnt  := .F.
	
TRB->(dbGoTop())
	
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

	oPrn:Say(_nLin,0090, dToc(TRB->EMISSAO)					,oFont4)
	oPrn:Say(_nLin,0300, dToc(TRB->ENTR_PR)					,oFont4)
	oPrn:Say(_nLin,0500, TRB->PRODUTO						,oFont4)
	oPrn:Say(_nLin,0800, TRB->EXTRUSO 						,oFont4)
	oPrn:Say(_nLin,1150, Trans(TRB->QUAN_OP	, "@E 99999")	,oFont4)
	oPrn:Say(_nLin,1450, Trans(TRB->QUAN_EN	, "@E 99999")	,oFont4)
	oPrn:Say(_nLin,1750, dToc(TRB->ENTR_RE)					,oFont4)
	If !Empty(TRB->ENTR_RE)
		oPrn:Say(_nLin,2100, Trans(TRB->ENTR_RE - TRB->ENTR_PR	, "@E 99999")	,oFont4)
	Endif
		
	_nLin += 40
	oPrn:Line(_nLin,0080,_nLin,2250)
	_nLin += 5

	_lEnt := .T.
	                                             	
	TRB->(dbSkip())
EndDo

_nTotal := _nOk + _nNEnt + _nEntAnt + _nEntDep

_nLin += 40
oPrn:Line(_nLin,0080,_nLin,2250)
_nLin += 40
oPrn:Say(_nLin,0500, "ENTREGUE ANTES:"									,oFont4)
oPrn:Say(_nLin,0800, Trans(_nEntAnt					, "@E 9999")+" - "	,oFont4)
oPrn:Say(_nLin,0900, Trans((_nEntAnt / _nTotal)*100	, "@E 999.99")+" %"	,oFont4)
_nLin += 40
oPrn:Say(_nLin,0500, "ENTREGUE NO DIA:"									,oFont4)
oPrn:Say(_nLin,0800, Trans(_nOk 					, "@E 9999")+" - "	,oFont4)
oPrn:Say(_nLin,0900, Trans((_nOk / _nTotal)*100		, "@E 999.99")+" %"	,oFont4)
_nLin += 40
oPrn:Say(_nLin,0500, "ENTREGUE DEPOIS:"									,oFont4)
oPrn:Say(_nLin,0800, Trans(_nEntDep 				, "@E 9999")+" - "	,oFont4)
oPrn:Say(_nLin,0900, Trans((_nEntDep / _nTotal)*100	, "@E 999.99")+" %"	,oFont4)
_nLin += 40
oPrn:Say(_nLin,0500, "NÃO ENTREGUE:"									,oFont4)
oPrn:Say(_nLin,0800, Trans(_nNent 					, "@E 9999")+" - "	,oFont4)
oPrn:Say(_nLin,0900, Trans((_nNent / _nTotal)*100	, "@E 999.99")+" %"	,oFont4)

Ms_Flush()
oPrn:EndPage()
oPrn:End()

oPrn:Preview()

TRB->(dbCloseArea())
ZC2->(dbCloseArea())

Return (Nil)


STATIC FUNCTION Cabec() //Cabeçalho

oPen	:= TPen():New(10,100,CLR_HRED,oPrn)

Define brush oBr color CLR_HRED

oPrn:SayBitmap(0095,0090,"lgrl01.bmp",0250,0070)

oPrn:Box(0080,0080,3000,2250, oPen)

oPrn:Line(0180,0080,0180,2250)
oPrn:Line(0190,0080,0190,2250)

oPrn:Say(0105,0500,cTitulo,oFont3)
oPrn:Say(0090,2080,dtoc(dDataBase),oFont5)
oPrn:Say(0130,2080,Time(),oFont5)

oPrn:Say(0196,0090,"EMISSAO",oFont5)
oPrn:Line(0190,0290,2950,0290) //Vertical
oPrn:Say(0196,0300,"ENTREGA",oFont5)
oPrn:Line(0190,0490,2950,0490) //Vertical
oPrn:Say(0196,0500,"PRODUTO",oFont5)
oPrn:Line(0190,0790,2950,0790) //Vertical
oPrn:Say(0196,0800,"EXTRUSORA",oFont5)
oPrn:Line(0190,1130,2950,1130) //Vertical
oPrn:Say(0196,1140,"QUANT_OP",oFont5)
oPrn:Line(0190,1430,2950,1430) //Vertical
oPrn:Say(0196,1440,"QUANT_ENTREGUE",oFont5)
oPrn:Line(0190,1740,2950,1740) //Vertical
oPrn:Say(0196,1750,"DATA EFETIVA",oFont5)
oPrn:Line(0190,2080,2950,2080) //Vertical
oPrn:Say(0196,2090,"DIF. DIAS",oFont5)
oPrn:Line(0240,0080,0240,2250)
//oPrn:Line(0190,1740,2950,1740)

_nCont ++

//Rodapé
oPrn:Line(2950,0080,2950,2250)
//oPrn:Say(2955,0090,"FP_?????????",oFont5)
oPrn:Say(2955,2050,"Página "+STRZERO(_nCont,3),oFont5)

Return()


Static Function AtuSx1(cPerg)

Local aHelp := {}
cPerg       := "PA0179"

//            Texto do help em português        			 	, Inglês, Espanhol
AAdd(aHelp, {{"Data Inicial da Emissão da OP"					}, {""} , {""}})
AAdd(aHelp, {{"Data Final da Emissão da OP"						}, {""} , {""}})
AAdd(aHelp, {{"Data Inicial de Entrega da OP"					}, {""} , {""}})
AAdd(aHelp, {{"Data Final da Entrega da OP"						}, {""} , {""}})
AAdd(aHelp, {{"Informe o Produto Inicial"   					}, {""} , {""}})
AAdd(aHelp, {{"Informe o Produto Final"     					}, {""} , {""}})
AAdd(aHelp, {{"Informe a Extrusora Inicial"    					}, {""} , {""}})
AAdd(aHelp, {{"Informe a Extrusora Final"     					}, {""} , {""}})
//AAdd(aHelp, {{"Informe qual o tipo do relatório à ser impresso"	}, {""} , {""}})

PutSx1(cPerg,"01","Emissao de    ?" ,"","","mv_ch1","D",08,00,00,"G","",""     ,"","","MV_PAR01",""		 	,"","","",""		  		  ,"","","","","","","","","","","",aHelp[1 ,1],aHelp[1 ,2],aHelp[1 ,3],"")
PutSx1(cPerg,"02","Emissao ate   ?" ,"","","mv_ch2","D",08,00,00,"G","",""     ,"","","MV_PAR02",""		 	,"","","",""		  		  ,"","","","","","","","","","","",aHelp[2 ,1],aHelp[2 ,2],aHelp[2 ,3],"")
PutSx1(cPerg,"03","Entrega de    ?" ,"","","mv_ch3","D",08,00,00,"G","",""     ,"","","MV_PAR03",""		 	,"","","",""		  		  ,"","","","","","","","","","","",aHelp[3 ,1],aHelp[3 ,2],aHelp[3 ,3],"")
PutSx1(cPerg,"04","Entrega ate   ?" ,"","","mv_ch4","D",08,00,00,"G","",""     ,"","","MV_PAR04",""		 	,"","","",""		  		  ,"","","","","","","","","","","",aHelp[4 ,1],aHelp[4 ,2],aHelp[4 ,3],"")
PutSx1(cPerg,"05","Produto de    ?" ,"","","mv_ch5","C",15,00,00,"G","","SB1PF"  ,"","","MV_PAR05",""		 	,"","","",""		  		  ,"","","","","","","","","","","",aHelp[5 ,1],aHelp[5 ,2],aHelp[5 ,3],"")
PutSx1(cPerg,"06","Produto ate   ?" ,"","","mv_ch6","C",15,00,00,"G","","SB1PF"  ,"","","MV_PAR06",""		 	,"","","",""		  		  ,"","","","","","","","","","","",aHelp[6 ,1],aHelp[6 ,2],aHelp[6 ,3],"")
PutSx1(cPerg,"07","Extrusora de  ?" ,"","","mv_ch7","C",06,00,00,"G","","SZE"  ,"","","MV_PAR07",""		 	,"","","",""		  		  ,"","","","","","","","","","","",aHelp[7 ,1],aHelp[7 ,2],aHelp[7 ,3],"")
PutSx1(cPerg,"08","Extrusora ate ?" ,"","","mv_ch8","C",06,00,00,"G","","SZE"  ,"","","MV_PAR08",""		    ,"","","",""		  		  ,"","","","","","","","","","","",aHelp[8 ,1],aHelp[8 ,2],aHelp[8 ,3],"")
//PutSx1(cPerg,"09","Tipo	         ?" ,"","","mv_ch9","N",01,00,00,"C","",""     ,"","","MV_PAR09","Preparação","","","","Inserto Metálico" ,"","","","","","","","","","","",aHelp[9 ,1],aHelp[9 ,2],aHelp[9 ,3],"")

Return (Nil)
