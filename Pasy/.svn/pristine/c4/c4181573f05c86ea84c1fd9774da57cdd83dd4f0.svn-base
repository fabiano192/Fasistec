#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa PA0173
Autor 		: Fabiano da Silva	-	18/02/09
Uso 		: SIGAFAT - Faturamento
Descrição 	: Gerar relatório do maior preço de venda
*/

USER FUNCTION PA0173()

LOCAL oDlg := NIL

PRIVATE cTitulo    	:= "Maior Preço de Venda sem Impostos"
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

aAdd( aRadio, "Relatório" )
aAdd( aRadio, "Excel" )

AtuSx1()

DEFINE FONT oFont1 NAME "Arial" SIZE 0,10 OF oPrn BOLD
DEFINE FONT oFont2 NAME "Arial" SIZE 0,13 OF oPrn BOLD
DEFINE FONT oFont3 NAME "Arial" SIZE 0,14 OF oPrn BOLD UNDERLINE
DEFINE FONT oFont4 NAME "Arial" SIZE 0,10 OF oPrn
DEFINE FONT oFont5 NAME "Arial" SIZE 0,14 OF oPrn
DEFINE FONT oFont6 NAME "Courier New" BOLD

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 010,017 SAY "Esta rotina tem por objetivo gerar o relatório  " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 020,017 SAY "de maior preço de venda sem impostos conforme   " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 030,017 SAY "parâmetros informados pelo usuário. Caso opte   " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 040,017 SAY "por gerar o arquivo em Excel, será o seguinte   " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 050,017 SAY "arquivo \SPOOL\PA0173.DBF                       " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 070,017 SAY "Programa PA0173.PRW                             " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED

@ 004,165 TO 028,205 LABEL "" OF oDlg PIXEL
@ 08,167 RADIO oRadio VAR nRadio ITEMS "Relatório","Excel" SIZE 33,10 PIXEL OF oDlg

@ 35,167 BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("PA0173"))    OF oDlg PIXEL
@ 50,167 BUTTON "OK" SIZE 036,012 ACTION (PA173A(),oDlg:End()) OF oDlg PIXEL
@ 65,167 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)


Static Function PA173A()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA173B(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return(Nil)


Static Function PA173B()

Pergunte("PA0173",.F.)

If MV_PAR07 = 1
	aStru := {}
	AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
	AADD(aStru,{"DESCRICAO", "C" , 40, 0 })
	AADD(aStru,{"PROD_CLI" , "C" , 40, 0 })
	AADD(aStru,{"MATERIAL" , "C" , 15, 0 })
	AADD(aStru,{"CLIENTE"  , "C" , 06, 0 })
	AADD(aStru,{"LOJA"     , "C" , 02, 0 })
	AADD(aStru,{"UNITARIO" , "N" , 14, 2 })
	
	cArqLOG := CriaTrab(aStru,.T.)
	cIndLOG := "PRODUTO+MATERIAL+CLIENTE+LOJA+PROD_CLI"
	dbUseArea(.T.,,cArqLOG,"TRB1",.F.,.F.)
	
	dbSelectArea("TRB1")
	IndRegua("TRB1",cArqLog,cIndLog,,,"Criando Trabalho...")
	
	_cQuery := " SELECT D2_COD AS PRODUTO,D2_PROCLI AS PROD_CLI,D2_CLIENTE AS CLIENTE,D2_LOJA AS LOJA,B1_DESC AS DESCRICAO, "
	_cQuery += " MAX((D2_TOTAL - D2_VALICM - D2_VALIMP5 - D2_VALIMP6) / D2_QUANT) AS UNITARIO FROM "+RetSqlName("SD2")+" D2 (NOLOCK) "
	_cQuery += " INNER JOIN "+RetSqlName("SF4")+" F4 (NOLOCK) ON F4_CODIGO = D2_TES "
	_cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 (NOLOCK) ON B1_COD = D2_COD "
	_cQuery += " WHERE D2.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' "
	_cQuery += " AND D2_TP = 'PA' AND D2_TIPO = 'N' AND F4_DUPLIC = 'S' AND F4_ESTOQUE = 'S' "
	_cQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	_cQuery += " AND D2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	_cQuery += " AND D2_CLIENTE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	_cQuery += " GROUP BY D2_COD,D2_PROCLI,D2_CLIENTE,D2_LOJA,B1_DESC "
	_cQuery += " ORDER BY D2_COD,D2_CLIENTE,D2_LOJA "
Else
	aStru := {}
	AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
	AADD(aStru,{"DESCRICAO", "C" , 40, 0 })
	AADD(aStru,{"PROD_CLI" , "C" , 40, 0 })
	AADD(aStru,{"MATERIAL" , "C" , 15, 0 })
	AADD(aStru,{"UNITARIO" , "N" , 14, 2 })
	
	cArqLOG := CriaTrab(aStru,.T.)
	cIndLOG := "PRODUTO+MATERIAL+PROD_CLI"
	dbUseArea(.T.,,cArqLOG,"TRB1",.F.,.F.)
	
	dbSelectArea("TRB1")
	IndRegua("TRB1",cArqLog,cIndLog,,,"Criando Trabalho...")
	
	_cQuery := " SELECT D2_COD AS PRODUTO,D2_PROCLI AS PROD_CLI,B1_DESC AS DESCRICAO, "
	_cQuery += " MAX((D2_TOTAL - D2_VALICM - D2_VALIMP5 - D2_VALIMP6) / D2_QUANT) AS UNITARIO FROM "+RetSqlName("SD2")+" D2 (NOLOCK) "
	_cQuery += " INNER JOIN "+RetSqlName("SF4")+" F4 (NOLOCK) ON F4_CODIGO = D2_TES "
	_cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 (NOLOCK) ON B1_COD = D2_COD "
	_cQuery += " WHERE D2.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' "
	_cQuery += " AND D2_TP = 'PA' AND D2_TIPO = 'N' AND F4_DUPLIC = 'S' AND F4_ESTOQUE = 'S' "
	_cQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	_cQuery += " AND D2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	_cQuery += " AND D2_CLIENTE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	_cQuery += " GROUP BY D2_COD,D2_PROCLI,B1_DESC "
	_cQuery += " ORDER BY D2_COD "
Endif

TCQuery _cQuery New Alias "TRB"

TcSetField("TRB","UNITARIO","N",14,2)

TRB->(dbGoTop())

ProcRegua(LastRec())

While TRB->(!EOF())
	
	IncProc()
	
	dbSelectArea("SG1")
	dbSetOrder(1)
	If dbSeek(xFilial("SG1")+TRB->PRODUTO)
		
		_cProd   := SG1->G1_COD
		nNivel   := 2
		
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+_cProd)
		
		NECESC6(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
	Endif
	
	TRB->(dbSkip())
EndDo

If nRadio == 1
	
	oPrn := TMSPrinter():New(cTitulo)
	oPrn:SetPortrait()
	
	_nLin  := 3000
	_lEnt  := .F.
	
	TRB1->(dbGoTop())
	
	While TRB1->(!EOF())
		
		IncProc()
		
		If _nLin > 2900
			If _lEnt
				oPrn:EndPage()
			Endif
			oPrn:StartPage()
			Cabec(_nCont)
			_nLin := 260
		Endif
		
		oPrn:Say(_nLin,0090, TRB1->PRODUTO ,oFont4)
		oPrn:Say(_nLin,0310, TRB1->DESCRICAO ,oFont4)
		oPrn:Say(_nLin,1000, TRB1->PROD_CLI ,oFont4)
		oPrn:Say(_nLin,1500, TRB1->MATERIAL ,oFont4)
		If MV_PAR07 = 1
			oPrn:Say(_nLin,1900, TRB1->CLIENTE+"/"+TRB1->LOJA ,oFont4)
		Endif
		If TRB1->UNITARIO > 100
			oPrn:Say(_nLin,2200, Trans(TRB1->UNITARIO, "@E 9,999,999.99") ,oFont1)
		Else
			oPrn:Say(_nLin,2200, Trans(TRB1->UNITARIO, "@E 9,999,999.99"),oFont4)
		Endif
		
		_nLin += 45
		_lEnt := .T.
		
		TRB1->(dBsKIP())
	EndDo
	
	TRB->(dbCloseArea())
	TRB1->(dbCloseArea())
	
	Ms_Flush()
	oPrn:EndPage()
	oPrn:End()
	
	oPrn:Preview()
	
ElseIf nRadio == 2
	
	TRB->(dbCloseArea())
	
	_cArqNovo := "\SPOOL\PA0173.DBF"
	dbSelectArea("TRB1")
	Copy all to &_cArqNovo
	
	TRB1->(dbCloseArea())
	
	If ! ApOleClient( 'MsExcel' )
		MsgStop('MsExcel nao instalado')
		Return
	EndIf
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\spool\PA0173.DBF" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	
Endif

Return (Nil)


STATIC FUNCTION Cabec() //Cabeçalho

oPen	:= TPen():New(10,100,CLR_HRED,oPrn)

Define brush oBr color CLR_HRED

oPrn:SayBitmap(0095,0090,"lgrl01.bmp",0250,0070)

oPrn:Box(0080,0080,3000,2370, oPen)

oPrn:Line(0180,0080,0180,2370)
oPrn:Line(0190,0080,0190,2370)

oPrn:Say(0105,0900,cTitulo,oFont3)
oPrn:Say(0090,2220,dtoc(dDataBase),oFont4)
oPrn:Say(0130,2220,Time(),oFont4)

oPrn:Say(0196,0090,"PRODUTO",oFont4)
oPrn:Line(0190,0300,2950,0310) //Vertical
oPrn:Say(0196,0310,"DESCRIÇÃO",oFont4)
oPrn:Line(0190,0990,2950,0990) //Vertical
oPrn:Say(0196,1000,"PRODUTO CLIENTE",oFont4)
oPrn:Line(0190,1490,2950,1490) //Vertical
oPrn:Say(0196,1500,"MATERIAL",oFont4)
If MV_PAR07 = 1
	oPrn:Line(0190,1890,2950,1890) //Vertical
	oPrn:Say(0196,1900,"CLIENTE/LJ",oFont4)
Endif
oPrn:Line(0190,2190,2950,2190) //Vertical
oPrn:Say(0196,2200,"VALOR",oFont4)
oPrn:Line(0240,0080,0240,2370)
//oPrn:Line(0190,1740,2950,1740)

_nCont ++

//Rodapé
oPrn:Line(2950,0080,2950,2370)
oPrn:Say(2955,2180,"Página "+STRZERO(_nCont,3),oFont4)

Return()


Static Function NECESC6(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev)

Local _nReg := 0
Local _nRegTrb := 0

dbSelectArea("SG1")
dbSetOrder(1)
While !Eof() .And. SG1->G1_FILIAL + SG1->G1_COD == xFilial("SG1") + _cProd
	
	_nReg := Recno()
	
	nQuantItem := ExplEstr(_nQtPai,,_cOpc,_cRev)
	dbSelectArea("SG1")
	dbSetOrder(1)
	
	If nQuantItem > 0
		
		dbSelectArea("SB1")
		aAreaSB1:=GetArea()
		dbSeek(xFilial("SB1")+SG1->G1_COMP)
		
		_nRegTRb := Recno()
		
		If SB1->B1_GRUPO $ "PIC /MPVZ/MPC /MPL "   // Material Utilizado
			
			If MV_PAR07 = 1
				_cChav := TRB->PRODUTO+SG1->G1_COMP+TRB->CLIENTE+TRB->LOJA+TRB->PROD_CLI
			Else
				_cChav := TRB->PRODUTO+SG1->G1_COMP+TRB->PROD_CLI
			Endif
			
			If !TRB1->(dbSeek(_cChav))
				TRB1->(RecLock("TRB1",.T.))
				TRB1->PRODUTO  	:= TRB->PRODUTO
				TRB1->DESCRICAO	:= TRB->DESCRICAO
				TRB1->PROD_CLI 	:= TRB->PROD_CLI
				TRB1->MATERIAL 	:= SG1->G1_COMP
				If MV_PAR07 = 1
					TRB1->CLIENTE	:= TRB->CLIENTE
					TRB1->LOJA		:= TRB->LOJA
				Endif
				TRB1->UNITARIO	:= TRB->UNITARIO
				TRB1->(MsUnlock())
			Endif
		Endif
		RestArea(aAreaSB1)
		
		dbSelectArea("SG1")
		dbSetOrder(1)
		dbSeek(xFilial("SG1")+SG1->G1_COMP)
		IF Found()
			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+SG1->G1_COD)
			
			NECESC6(SG1->G1_COD,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
		EndIf
		
		dbSelectArea("SG1")
		dbGoto(_nReg)
		
		dbSelectArea("SG1")
	Endif
	dbSkip()
EndDo

Return(Nil)


Static Function AtuSx1(cPerg)

Local aHelp := {}
cPerg       := "PA0173"

//            Texto do help em português        			 , Inglês, Espanhol
AAdd(aHelp, {{"Informe a Data Inicial"   					}, {""} , {""}})
AAdd(aHelp, {{"Informe a Data Final"   						}, {""} , {""}})
AAdd(aHelp, {{"Informe o Produto Inicial"   				}, {""} , {""}})
AAdd(aHelp, {{"Informe o Produto Final"     				}, {""} , {""}})
AAdd(aHelp, {{"Informe o Cliente Inicial"       			}, {""} , {""}})
AAdd(aHelp, {{"Informe o Cliente Final"         			}, {""} , {""}})
AAdd(aHelp, {{"Analítico separdo por Clientes ou Sintético"	}, {""} , {""}})

PutSx1(cPerg,"01","Data de          ?" ,"","","mv_ch1","D",08,00,00,"G","",""   ,"","","MV_PAR01",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[1,1],aHelp[1,2],aHelp[1,3],"")
PutSx1(cPerg,"02","Data ate         ?" ,"","","mv_ch2","D",08,00,00,"G","",""   ,"","","MV_PAR02",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[2,1],aHelp[2,2],aHelp[2,3],"")
PutSx1(cPerg,"03","Produto de      	?" ,"","","mv_ch3","C",15,00,00,"G","","SB1","","","MV_PAR03",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[3,1],aHelp[3,2],aHelp[3,3],"")
PutSx1(cPerg,"04","Produto ate     	?" ,"","","mv_ch4","C",15,00,00,"G","","SB1","","","MV_PAR04",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[4,1],aHelp[4,2],aHelp[4,3],"")
PutSx1(cPerg,"05","Cliente de     	?" ,"","","mv_ch5","C",06,00,00,"G","","SA1","","","MV_PAR05",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[5,1],aHelp[5,2],aHelp[5,3],"")
PutSx1(cPerg,"06","Cliente ate    	?" ,"","","mv_ch6","C",06,00,00,"G","","SA1","","","MV_PAR06",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[6,1],aHelp[6,2],aHelp[6,3],"")
PutSx1(cPerg,"07","Tipo		    	?" ,"","","mv_ch7","N",01,00,00,"C","",""   ,"","","MV_PAR07","Analítico","","","","Sintético","","","","","","","","","","","",aHelp[7,1],aHelp[7,2],aHelp[7,3],"")

Return (Nil)
