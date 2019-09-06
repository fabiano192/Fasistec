#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa PA0174
Autor 		: Fabiano da Silva	-	11/03/09
Uso 		: SIGAPCP - PCP
Descrição 	: Gerar relatório da Programação de Preparação 
*/

USER FUNCTION PA0174()

LOCAL oDlg := NIL

PRIVATE cTitulo    	:= "PROGRAMAÇÃO DE PREPARAÇÃO"
PRIVATE oPrn       	:= NIL
PRIVATE oFont1     	:= NIL
PRIVATE oFont2     	:= NIL
PRIVATE oFont3     	:= NIL
PRIVATE oFont4     	:= NIL
PRIVATE oFont5     	:= NIL
PRIVATE oFont6     	:= NIL
PRIVATE _nCont     	:= 0

AtuSx1()
/*
Local oFont1 := TFont():New( "Times New Roman",,08,,.T.,,,,,.F.)
Local oFont2 := TFont():New( "Tahoma",,16,,.T.,,,,,.F.)
Local oFont3 := TFont():New( "Arial"       ,,20,,.F.,,,,,.F.)
  */
DEFINE FONT oFont1 NAME "Arial" SIZE 0,10 OF oPrn BOLD
DEFINE FONT oFont2 NAME "Arial" SIZE 0,13 OF oPrn BOLD
DEFINE FONT oFont3 NAME "Arial" SIZE 0,14 OF oPrn BOLD
DEFINE FONT oFont4 NAME "Arial" SIZE 0,10 OF oPrn
DEFINE FONT oFont5 NAME "Arial" SIZE 0,10 OF oPrn BOLD
DEFINE FONT oFont6 NAME "Courier New" BOLD

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 010,017 SAY "Esta rotina tem por objetivo gerar o relatório  " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 020,017 SAY "de Programação de Preparação conforme os        " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 030,017 SAY "parâmetros informados pelo usuário.             " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 040,017 SAY "                                                " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 050,017 SAY "                                                " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 070,017 SAY "Programa PA0174.PRW                             " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED

//@ 004,165 TO 028,205 LABEL "" OF oDlg PIXEL

@ 10,167 BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("PA0174"))    OF oDlg PIXEL
@ 35,167 BUTTON "OK" SIZE 036,012 ACTION (PA174A(),oDlg:End()) OF oDlg PIXEL
@ 60,167 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)


Static Function PA174A()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA174B(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return(Nil)


Static Function PA174B()

Pergunte("PA0174",.F.)

aStru := {}
AADD(aStru,{"ENTREGA" 	, "D" ,  8, 0 })
AADD(aStru,{"LIBERACAO" , "D" ,  8, 0 })
AADD(aStru,{"OP"		, "C" , 40, 0 })
AADD(aStru,{"MOLDE" 	, "C" , 15, 0 })
AADD(aStru,{"PRODUTO" 	, "C" , 15, 0 })
AADD(aStru,{"MATERIAL" 	, "C" , 15, 0 })
AADD(aStru,{"TRAFILA" 	, "C" , 10, 0 })
AADD(aStru,{"MATRIZ"  	, "C" , 06, 0 })
AADD(aStru,{"MEDIDA"    , "C" , 02, 0 })
AADD(aStru,{"PESO" 		, "N" , 14, 2 })
AADD(aStru,{"QUAN_OP" 	, "N" , 14, 2 })
AADD(aStru,{"SALDO" 	, "N" , 14, 2 })
	
cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "DTOS(ENTREGA)+PRODUTO+OP"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)
	
dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")
	
private nQuant     	:= 1
private cProduto   	:= SPACE(LEN(SC2->C2_PRODUTO))
private cQtd
private cIndSC2    	:= CriaTrab(NIL,.F.), nIndSC2
Private aArray   	:= {}
//Private _cProdPa 	:= ""

cbtxt           	:= SPACE(10)
_cMolde  			:= ""
_cMater  			:= ""
_cMatriz 			:= ""
_nQPF    			:= _nQPecas := 0
_cCond2          	:= ".T."

dbSelectArea("SC2")
dbOrderNickName("INDSC21")
dbSeek(xFilial("SC2")+DTOS(MV_PAR01),.T.)

//_cCond := 

ProcRegua(LastRec())

_lVazados := .F.

While !Eof() .And. SC2->C2_EMISSAO <= MV_PAR02
		
	IncProc()
	
	_cOp := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
	
	If _cOP < MV_PAR03 .Or. _cOp > MV_PAR04
		dbSelectArea("SC2")
		dbSkip()
		Loop
	EndIf

/*	If SC2->C2_EMISSAO < MV_PAR01 .Or. SC2->C2_EMISSAO > MV_PAR02
		dbSelectArea("SC2")
		dbSkip()
		Loop
	Endif */
	
	If SC2->C2_PRODUTO < MV_PAR05 .Or. SC2->C2_PRODUTO > MV_PAR06
		dbSelectArea("SC2")
		dbSkip()
		Loop
	Endif

	If SC2->C2_DATPRF < MV_PAR09 .Or. SC2->C2_DATPRF > MV_PAR10
		dbSelectArea("SC2")
		dbSkip()
		Loop
	Endif

	If SC2->C2_TPOP <> "F"
		dbSelectArea("SC2")
		dbSkip()
		Loop
	Endif

	If SC2->C2_QUANT = SC2->C2_QUJE
		dbSelectArea("SC2")
		dbSkip()
		Loop
	Endif

	cProduto  := SC2->C2_PRODUTO
	nQuant    := aSC2Sld()
	
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+cProduto)
	
	If SB1->B1_TIPO == "PA" .And. SB1->B1_GRUPO == "PAV "
		_lVazados := .T.
		_lVazad   := .T.
	Endif
	
	If SB1->B1_GRUPO $ "PIC "
		dbSelectArea("SC2")
		dbSkip()
		Loop
	EndIf
	
	If SB1->B1_GRUPO == "PIPB" .And. !_lVazados
		dbSelectArea("SC2")
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("SC2")
	
	FF174C(nQuant)
	
	FF174D(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD,nQuant)
	
	aSort( aArray,2,, { |x, y| (x[1]+x[8]) < (y[1]+y[8]) } )
	
	_nQuant := SC2->C2_QUANT - SC2->C2_QUJE
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dBseek(xFilial("SB1")+SC2->C2_PRODUTO)
	_aAliSB1 := GetArea()
	
	If SB1->B1_TIPO == "PA"    // Primeira Via - Produto Acabado
		_cProdPa := SB1->B1_COD
		_nQPecas := SC2->C2_QUANT
	ElseIf Alltrim(SB1->B1_GRUPO) == "PIPF"

		_cOP := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
		FF174E()
	Endif
	
	dbSelectArea("SC2")
	dbSkip()
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
		
	oPrn:Say(_nLin,0090, dToc(TRB->LIBERACAO)					,oFont4)
	oPrn:Say(_nLin,0260, dToc(TRB->ENTREGA	)					,oFont4)
	oPrn:Say(_nLin,0440, TRB->OP		 						,oFont4)
	oPrn:Say(_nLin,0580, TRB->MOLDE 							,oFont4)
	oPrn:Say(_nLin,0730, TRB->PRODUTO							,oFont4)
	oPrn:Say(_nLin,0920, TRB->MATERIAL 							,oFont4)
	oPrn:Say(_nLin,1050, TRB->TRAFILA 							,oFont4)
	oPrn:Say(_nLin,1230, TRB->MATRIZ 							,oFont4)
	oPrn:Say(_nLin,1400, TRB->MEDIDA 							,oFont4)
	oPrn:Say(_nLin,1500, Trans(TRB->PESO		, "@E 9999.9")	,oFont4)
	oPrn:Say(_nLin,1650, Trans(TRB->QUAN_OP		, "@E 99999")	,oFont4)
	oPrn:Say(_nLin,2000, Trans(TRB->SALDO		, "@E 99999")	,oFont4)
//	oPrn:Say(_nLin,2120, ""										,oFont4)
	
	_nLin += 40
	oPrn:Line(_nLin,0080,_nLin,2250)
	_nLin += 5

	_lEnt := .T.
	
	TRB->(dbSkip())
EndDo

Ms_Flush()
oPrn:EndPage()
oPrn:End()

oPrn:Preview()

TRB->(dbCloseArea())

Return (Nil)



Static Function FF174C(nQuantItem)

private cDesc := SB1->B1_DESC
private cRoteiro:=""

If !Empty(SC2->C2_ROTEIRO)
	cRoteiro:=SC2->C2_ROTEIRO
Else
	If !Empty(SB1->B1_OPERPAD)
		cRoteiro:=SB1->B1_OPERPAD
	Else
		dbSelectArea("SG2")
		If dbSeek(xFilial("SG2")+SC2->C2_PRODUTO+"01")
			RecLock("SB1",.F.)
			Replace B1_OPERPAD With "01"
			MsUnLock()
			cRoteiro:="01"
		EndIf
	EndIf
EndIf

dbSelectArea("SB2")
dbSeek(xFilial("SB2")+SB1->B1_COD+SD4->D4_LOCAL)
dbSelectArea("SD4")
AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,D4_LOCAL,SB2->B2_LOCALIZ,D4_TRT,cRoteiro } )

Return


Static Function FF174D(cOp,nQuant)

dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial("SD4")+cOp)

While !Eof() .And. D4_FILIAL+D4_OP == xFilial("SD4")+cOp
	
	If (SC2->C2_DATPRI > SD4->D4_DATA)
		dbSelectArea("SD4")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+SD4->D4_COD)
	If SD4->D4_QUANT > 0
		FF174C(SD4->D4_QUANT)
	EndIf
	dbSelectArea("SD4")
	dbSkip()
Enddo

dbSetOrder(1)

Return


Static Function FF174E()

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
		If SB1->B1_TIPO == "FR"
			_cMolde := SB1->B1_COD
			_cCav   := SB1->B1_CAV
		ElseIf SB1->B1_TIPO == "PI" .And. SB1->B1_GRUPO = "PIC" .And. SB1->B1_SUBGR != "PACO"
			_cMater := SB1->B1_COD
		Endif
	Endif
Next E

dbSelectArea("SB1")
dbSetOrder(_nOrdSB1)
dbGoto(_nRecSB1)

dbSelectArea("SG1")
dbSetOrder(2)
dbSeek(xFilial("SG1")+_cProdPre)

If SG1->G1_UMPF == "G "
	_nPesoPre1 := SG1->G1_PEPFFIM /1000
ElseIf SG1->G1_UMPF == "KG"
	_nPesoPre1 := SG1->G1_PEPFFIM /1000
Else
	_nPesoPre1 := SG1->G1_PEPFFIM
Endif

If SG1->G1_UMPF == "G "
	_nPesoPre2 := SG1->G1_PEMATF2 /1000
ElseIf SG1->G1_UMPF == "KG"
	_nPesoPre2 := SG1->G1_PEMATF2 /1000
Else
	_nPesoPre2 := SG1->G1_PEMATF2
Endif

dbSelectArea("SZE")
dbsetOrder(1)
dbSeek(xFilial("SZE")+SG1->G1_TPRECUR)

If SG1->G1_TPRECUR < MV_PAR07 .Or. SG1->G1_TPRECUR > MV_PAR08
	Return(Nil)
Endif

_nKgCil2 := 0
_nKgCil1 := SZE->ZE_PESOCAB + (SC2->C2_QUANT*_nPesoPre1)
_nCil1   := SZE->ZE_PESOCAB
If _nPesoPre2 > 0
	_nKgCil2 := SZE->ZE_PESOCAB + (SC2->C2_QUANT*_nPesoPre2)
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

_cObs    := SG1->G1_OBSERV
_cMatriz := Alltrim(SG1->G1_NOMEFER)+" + "+Alltrim(SG1->G1_NOMMAT2)
_cMatriz := IIF(Alltrim(_cMatriz) = "+","",_cMatriz)
_nQPF    := SG1->G1_QUANT

_cMeFi := SG1->G1_MEPFFIM
_cRev  := SG1->G1_REVFICH

_nKgMat := 0
dbSelectArea("SG1")
dbsetorder(2)
If dbSeek(xFilial()+_cMater+_cProdPre)
	_nKgMat := (SG1->G1_QUANT*_nQPF) * _nQPecas
Endif

dbselectarea("TRB")
RecLock("TRB",.T.)
TRB->ENTREGA	:= SC2->C2_DATPRF
TRB->LIBERACAO	:= SC2->C2_EMISSAO
TRB->OP			:= SC2->C2_NUM
//TRB->OP			:= SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
TRB->MOLDE		:= _cMolde
TRB->PRODUTO	:= SC2->C2_PRODUTO
TRB->MATERIAL	:= _cMater
TRB->TRAFILA	:= _cTraf
TRB->MATRIZ		:= _cMatriz
TRB->MEDIDA		:= _cMeFi
TRB->PESO		:= _nKgMat
TRB->QUAN_OP	:= SC2->C2_QUANT
TRB->SALDO		:= SC2->C2_QUANT - SC2->C2_QUJE
MsUnlock()

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

oPrn:Say(0196,0090,"EMISSAO",oFont5)
oPrn:Line(0190,0250,2950,0250) //Vertical
oPrn:Say(0196,0260,"ENTREGA",oFont5)
oPrn:Line(0190,0430,2950,0430) //Vertical
oPrn:Say(0196,0440,"NR OP",oFont5)
oPrn:Line(0190,0570,2950,0570) //Vertical
oPrn:Say(0196,0580,"MOLDE",oFont5)
oPrn:Line(0190,0720,2950,0720) //Vertical
oPrn:Say(0196,0730,"PRODUTO",oFont5)
oPrn:Line(0190,0910,2950,0910) //Vertical
oPrn:Say(0196,0920,"MAT.",oFont5)
oPrn:Line(0190,1040,2950,1040) //Vertical
oPrn:Say(0196,1050,"EXTRUSORA",oFont5)
oPrn:Line(0190,1220,2950,1220) //Vertical
oPrn:Say(0196,1230,"MATRIZ",oFont5)
oPrn:Line(0190,1380,2950,1380) //Vertical
oPrn:Say(0196,1390,"MED",oFont5)
oPrn:Line(0190,1490,2950,1490) //Vertical
oPrn:Say(0196,1510,"PESO",oFont5)
oPrn:Line(0190,1630,2950,1630) //Vertical
oPrn:Say(0196,1640,"QUANT",oFont5)
oPrn:Line(0190,1780,2950,1780) //Vertical
oPrn:Say(0196,1790,"LOTE",oFont5)
oPrn:Line(0190,1970,2950,1970) //Vertical
oPrn:Say(0196,1980,"SALDO",oFont5)
oPrn:Line(0190,2110,2950,2110) //Vertical
oPrn:Say(0196,2120,"VISTO",oFont5)
oPrn:Line(0240,0080,0240,2250)
//oPrn:Line(0190,1740,2950,1740)

_nCont ++

//Rodapé
oPrn:Line(2950,0080,2950,2250)
oPrn:Say(2955,0090,"FP_08_REV_04",oFont5)
oPrn:Say(2955,2050,"Página "+STRZERO(_nCont,3),oFont5)

Return()


Static Function AtuSx1(cPerg)

Local aHelp := {}
cPerg       := "PA0174"

//            Texto do help em português        			 , Inglês, Espanhol
AAdd(aHelp, {{"Data Inicial da Emissão da OP"				}, {""} , {""}})
AAdd(aHelp, {{"Data Final da Emissão da OP"					}, {""} , {""}})
AAdd(aHelp, {{"Informe a OP Inicial"    		   			}, {""} , {""}})
AAdd(aHelp, {{"Informe a OP Final"	    		   			}, {""} , {""}})
AAdd(aHelp, {{"Informe o Produto Inicial"   				}, {""} , {""}})
AAdd(aHelp, {{"Informe o Produto Final"     				}, {""} , {""}})
AAdd(aHelp, {{"Informe a Extrusora Inicial"    				}, {""} , {""}})
AAdd(aHelp, {{"Informe a Extrusora Final"     				}, {""} , {""}})
AAdd(aHelp, {{"Data Inicial de Entrega da OP"				}, {""} , {""}})
AAdd(aHelp, {{"Data Final da Entrega da OP"					}, {""} , {""}})

PutSx1(cPerg,"01","Emissao de       ?" ,"","","mv_ch1","D",08,00,00,"G","",""   ,"","","MV_PAR01",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[1 ,1],aHelp[1 ,2],aHelp[1 ,3],"")
PutSx1(cPerg,"02","Emissao ate      ?" ,"","","mv_ch2","D",08,00,00,"G","",""   ,"","","MV_PAR02",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[2 ,1],aHelp[2 ,2],aHelp[2 ,3],"")
PutSx1(cPerg,"03","OP de 	     	?" ,"","","mv_ch3","C",11,00,00,"G","","SC2","","","MV_PAR03",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[3 ,1],aHelp[3 ,2],aHelp[3 ,3],"")
PutSx1(cPerg,"04","OP ate   	  	?" ,"","","mv_ch4","C",11,00,00,"G","","SC2","","","MV_PAR04",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[4 ,1],aHelp[4 ,2],aHelp[4 ,3],"")
PutSx1(cPerg,"05","Produto de      	?" ,"","","mv_ch5","C",15,00,00,"G","","SB1","","","MV_PAR05",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[5 ,1],aHelp[5 ,2],aHelp[5 ,3],"")
PutSx1(cPerg,"06","Produto ate     	?" ,"","","mv_ch6","C",15,00,00,"G","","SB1","","","MV_PAR06",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[6 ,1],aHelp[6 ,2],aHelp[6 ,3],"")
PutSx1(cPerg,"07","Extrusora de    	?" ,"","","mv_ch7","C",06,00,00,"G","","SZE","","","MV_PAR07",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[7 ,1],aHelp[7 ,2],aHelp[7 ,3],"")
PutSx1(cPerg,"08","Extrusora ate   	?" ,"","","mv_ch8","C",06,00,00,"G","","SZE","","","MV_PAR08",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[8 ,1],aHelp[8 ,2],aHelp[8 ,3],"")
PutSx1(cPerg,"09","Entrega de       ?" ,"","","mv_ch9","D",08,00,00,"G","",""   ,"","","MV_PAR09",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[9 ,1],aHelp[9 ,2],aHelp[9 ,3],"")
PutSx1(cPerg,"10","Entrega ate      ?" ,"","","mv_cha","D",08,00,00,"G","",""   ,"","","MV_PAR10",""		 ,"","","",""		  ,"","","","","","","","","","","",aHelp[10,1],aHelp[10,2],aHelp[10,3],"")
//PutSx1(cPerg,"07","Tipo		    	?" ,"","","mv_ch7","N",01,00,00,"C","",""   ,"","","MV_PAR07","Analítico","","","","Sintético","","","","","","","","","","","",aHelp[7,1],aHelp[7,2],aHelp[7,3],"")

Return (Nil)
