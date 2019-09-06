#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function PA0162()

_nKgCil2 	:= _nKgCil1 := 0
_cX1 		:= _cX2 	:= 	_cX3 := " "
_cMatriz 	:= ""
_nQPF    	:= _nQPecas	:= 0
_nPrF1 		:= _nPrF2 	:= _cUMPF := 0
_nPrI1 		:= _nPrI2 	:= _cUMPI := 0
_cMeIn 		:= _cMeFi	:= ""
_cMater     := ""
_cProdPre 	:= ""
_cRev      := ""
_cOP	   := CTOD("  /  /  ")
_dEntr	   := ""
_dEmis 	   := ""
_cProdPa   := ""
_cPorta    := "LPT1"
_cOP1      := SPACE(13)
_cOP2      := Space(13)
_dData1    := CTOD("  /  /  ")
_dData2    := CTOD("  /  /  ")
_nQuant    := 0
_nQtde     := 0
_cCliente  := SPACE(6)
_cLoja 	   := SPACE(2)
_nCil1     := 0
_cObs      := ""

@ 0  ,0 TO 330,470 DIALOG oDlg1 TITLE "Etiquetas Ordem de Produ豫o - PA0162"
@ 10 ,10 SAY "Da O.P.  ?"
@ 10 ,70 GET _cOP1     PICTURE "@!" SIZE 50,10 F3 "SC2" OBJECT _OWCOD1
@ 30 ,10 SAY "Ate O.P. ?"
@ 30 ,70 GET _cOP2     PICTURE "@!" SIZE 50,10 F3 "SC2" OBJECT _OWCOD2
@ 50 ,10 SAY "Data de  ?"
@ 50 ,70 GET _dData1   PICTURE "@!" SIZE 50,10 OBJECT _oWDat1
@ 70 ,10 SAY "Data ate ?"
@ 70 ,70 GET _dData2   PICTURE "@!" SIZE 50,10 OBJECT _oWDat2
@ 90 ,10 SAY "Qtd. Etiquetas:"
@ 90 ,70 GET _nQtde    PICTURE "@E 9999" SIZE 50,10 VALID VERETI() OBJECT _oQtEtiq
@ 110,10 SAY "Cliente:"
@ 110,70 GET _cCliente PICTURE "@!" SIZE 50,10 VALID VERCLI() F3 "SA1" OBJECT _oWCLI
@ 130,10 SAY "Loja:"
@ 130,70 GET _cLoja    PICTURE "@!" SIZE 50,10 OBJECT _oWLOJA

@ 20,185 BMPBUTTON TYPE 1 ACTION Processa({|| R820Imp() })
@ 45,185 BMPBUTTON TYPE 2 ACTION Close(oDlg1)

ACTIVATE DIALOG oDlg1 CENTER

Return


Static Function VERCLI()

_lRet   := .F.
_cLoja  := ""

DBSELECTAREA("SA1")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SA1")+_cCliente)
	_cLoja := SA1->A1_LOJA
	_lRet  := .T.
ENDIF

_oWLOJA :Refresh()

RETURN(_lRet)


Static Function VerETI()

_lRet    :=.t.

If _nQtde == 0
	_lRet := .F.
Endif

Return(_lRet)


Static Function ImpEt()

_nKgMat := aArray[1][5]
//_cData := Strzero(day(dDataBase),2)+"-"+substr(mes(dDataBase),1,3)+	"-"+substr(strzero(year(dDataBase),4),3,2)
_cData := Strzero(day(_dEmis),2)+"-"+substr(mes(_dEmis),1,3)+	"-"+substr(strzero(year(_dEmis),4),3,2)

MSCBPRINTER("ARGOX",_cPorta,,,.f.)
MSCBCHKSTATUS(.f.)

MSCBLOADGRF("\SYSTEM\logPasy2.bmp")

MSCBBEGIN(_nQtde,6)

// Dados da Empresa
MSCBGRAFIC(05,63,"logPasy2")
MSCBSAY(40,63,"OP PREPARACAO"		, "N", "3", "1",.F.)
MSCBSAY(85,66,"FP11 - REV02"		, "N", "1", "1",.F.)
MSCBSAY(85,63,_cData	        	, "N", "2", "1",.F.)

MSCBLINEH(05,61,98,2,"B")

MSCBSAY(05,56,"NR OP:" 		    	, "N", "2", "1",.F.)
MSCBSAY(16,56,_cOP 	    			, "N", "2", "1",.F.)
MSCBBOX(15,55,35,59,1,"B")

MSCBSAY(37,56,"COD.PASY" 	    	, "N", "2", "1",.F.)
MSCBSAY(51,56,_cProdPre	          	, "N", "2", "1",.F.)
MSCBBOX(50,55,68,59,1,"B")

MSCBSAY(69,56,"CLIENTE:"				, "N", "2", "1",.F.)
MSCBSAY(83,56,_cCliente+"/"+_cLoja      	, "N", "2", "1",.F.)
MSCBBOX(82,55,100,59,1,"B")
//MSCBLINEH(82,56,100,1,"B")

MSCBSAY(05,51,"MAT.:"				, "N", "2", "1",.F.)
MSCBSAY(16,51,_cMater           	, "N", "2", "1",.F.)
MSCBBOX(15,50,35,54,1,"B")

_nKgMat := 0
dbSelectArea("SG1")
dbsetorder(2)
If dbSeek(xFilial()+_cMater+_cProdPre)
	_nKgMat := (SG1->G1_QUANT*_nQPF) * _nQPecas
Endif

MSCBSAY(37,51,"KG MAT.:"			, "N", "2", "1",.F.)
MSCBSAY(51,51, Alltrim(TRANSFORM(_nKgMat,"@E 9999.99999 ")) 	, "N", "2", "1",.F.)
MSCBBOX(50,50,68,54,1,"B")

_cEntr := Strzero(day(_dEntr),2)+"/"+substr(mes(_dEntr),1,3)+"/"+substr(strzero(year(_dEntr),4),3,2)
MSCBSAY(69,51,"ENTREGA:"			, "N", "2", "1",.F.)
MSCBSAY(83,51,_cEntr				, "N", "2", "1",.F.)
MSCBBOX(82,50,100,54,1,"B")

MSCBSAY(05,46,"LOTE:"				, "N", "2", "1",.F.)
MSCBLINEH(16,45,100,1,"B")

MSCBSAY(05,41,"MOLDE:" 		    	, "N", "2", "1",.F.)
MSCBSAY(16,41,_cMolde           	, "N", "2", "1",.F.)
MSCBBOX(15,40,35,44,1,"B")

MSCBSAY(42,41,"CAV.:"				, "N", "2", "1",.F.)
MSCBSAY(51,41,_cCav             	, "N", "2", "1",.F.)
MSCBBOX(50,40,68,44,1,"B")

MSCBSAY(71,41,"KG CIL:"			, "N", "2", "1",.F.)
MSCBSAY(83,41, Alltrim(TRANSFORM(_nKgMat+_nCil1,"@E 9999.9999 ")) 	, "N", "2", "1",.F.)
//MSCBSAY(83,41, Alltrim(TRANSFORM(_nKgCil1 + _nKgCil2,"@E 9999.9999 ")) 	, "N", "2", "1",.F.)
MSCBBOX(82,40,100,44,1,"B")

MSCBSAY(05,36,"BCM( "+_cX1+" )" 	, "N", "2", "1",.F.)
MSCBSAY(25,36,"TRAF.( "+_cX2+" )"   , "N", "2", "1",.F.)
MSCBSAY(45,36,"CILIN.( "+_cX3+" )"	, "N", "2", "1",.F.)
MSCBSAY(68,36,"MAT/VAZ.:"	    	, "N", "2", "1",.F.)
MSCBSAY(83,36,_cMatriz				, "N", "2", "1",.F.)
MSCBBOX(82,35,100,39,1,"B")

MSCBSAY(05,31,"PECAS:"		        , "N", "2", "1",.F.)
MSCBSAY(16,31,Alltrim(TRANSFORM(_nQPecas,"@E 99,999.99"))          , "N", "2", "1",.F.)
MSCBBOX(15,30,35,34,1,"B")

MSCBSAY(37,31,"QTDE PF:"				, "N", "2", "1",.F.)
MSCBSAY(51,31,Alltrim(TRANSFORM(_nQPF,"@E 99,999.999"))        , "N", "2", "1",.F.)
MSCBBOX(50,30,68,34,1,"B")

_nMassas := _nQPecas * _nQPF
MSCBSAY(71,31,"MASSAS:"				, "N", "2", "1",.F.)
MSCBSAY(83,31,Alltrim(TRANSFORM(_nMassas,"@E 99,999.99"))     , "N", "2", "1",.F.)
MSCBBOX(82,30,100,34,1,"B")

MSCBSAY(05,26,"PESO PREFORMADO 1:"  , "N", "2", "1",.F.)
MSCBSAY(35,26,Alltrim(TRANSFORM(_nPrI1,"@E 9999.999 "))+" "+_cUMPI        , "N", "2", "1",.F.)
MSCBSAY(60,26,"ATE"	  				, "N", "2", "1",.F.)
MSCBSAY(75,26,Alltrim(TRANSFORM(_nPrI2,"@E 999.999 "))+" "+_cUMPI        , "N", "2", "1",.F.)
MSCBBOX(33,25,100,29,1,"B")

MSCBSAY(05,21,"MEDIDA DE :" 		, "N", "2", "1",.F.)
MSCBSAY(35,21,_cMeIn	            , "N", "2", "1",.F.)
MSCBSAY(60,21,"ATE"	  				, "N", "2", "1",.F.)
MSCBSAY(75,21,_cMeFi	            , "N", "2", "1",.F.)
MSCBBOX(33,20,100,24,1,"B")

MSCBSAY(05,14,"FORAM CORTADOS:" 	, "N", "2", "1",.F.)
MSCBLINEH(30,14,100,1,"B")

MSCBSAY(05,08,"OBS:"				, "N", "2", "1",.F.)
If Empty(_cObs,1,50)
	MSCBLINEH(15,08,100,1,"B")
Else	
	MSCBSAY(16,08,Substr(_cObs,1,50)   , "N", "2", "1",.F.)	
	MSCBBOX(15,07,100,12,1,"B")
Endif

MSCBSAY(05,02,"ASSINATURA:"			, "N", "2", "1",.F.)
MSCBSAY(85,02,"REV:"				, "N", "2", "1",.F.)
MSCBSAY(93,02,_cRev		            , "N", "2", "1",.F.)
MSCBLINEH(25,02,78,1,"B")
MSCBBOX(92,01,100,05,1,"B")

MSCBEND()

MSCBClosePrinter()

_oWCod1    :Refresh()
_oWCod2    :Refresh()
_oWDat1    :Refresh()
_oWDat2    :Refresh()
_oQtEtiq   :Refresh()

Return


Static Function R820Imp()

private CbCont,cabec1,cabec2
private nQuant     := 1
private cProduto   := SPACE(LEN(SC2->C2_PRODUTO))
private cQtd
private cIndSC2    := CriaTrab(NIL,.F.), nIndSC2
Private aArray   := {}
Private li       := 80
cbtxt            := SPACE(10)
cbcont           := 0
_cMolde  := ""
_cCav    := ""
_cMatriz := ""
_nQPF    := _nQPecas := 0

_cCond2          := ".T."
dbSelectArea("SC2")
dbSetOrder(1)
dbSeek(xFilial("SC2")+_cOP1,.T.)

_cCond := "C2_NUM+C2_ITEM+C2_SEQUEN <= _cOP2"

ProcRegua(LastRec())

_lVazados := .F.

While !Eof() .And. &_cCond
		
	IncProc()
	
	_cOp := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN//+SC2->C2_ITEMGRD
	
	If _cOP < _cOP1 .Or. _cOp > _cOP2
		dbSkip()
		Loop
	EndIf
	
	If SC2->C2_EMISSAO < _dData1 .Or. SC2->C2_EMISSAO > _dData2
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
	
	AddAr820(nQuant)
	
	MontStruc(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD,nQuant)
	
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

/*	
//		_cCliente := ""

		dbSelectArea("SC5")
		dbSetOrder(1)
		If dbSeek(xFilial("SC5")+SC2->C2_NUM)
			_cCliente := SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI
		Endif	
	*/
		_cOP 	:= SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
		_dEntr 	:= SC2->C2_DATPRF
		_dEmis 	:= SC2->C2_EMISSAO

		ImpHist()
		ImpEt()
	Endif
	
	dbSelectArea("SC2")
	dbSkip()
EndDO


Static Function AddAr820(nQuantItem)

private cDesc := SB1->B1_DESC
private cRoteiro:=""
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
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


Static Function MontStruc(cOp,nQuant)

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
		AddAr820(SD4->D4_QUANT)
	EndIf
	dbSelectArea("SD4")
	dbSkip()
Enddo

dbSetOrder(1)

Return


Static Function ImpHist()

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

_nKgCil2 := 0
_nKgCil1 := SZE->ZE_PESOCAB + (SC2->C2_QUANT*_nPesoPre1)
_nCil1   := SZE->ZE_PESOCAB
If _nPesoPre2 > 0
	_nKgCil2 := SZE->ZE_PESOCAB + (SC2->C2_QUANT*_nPesoPre2)
Endif

If SZE->ZE_TIPO == "1"
	_cX1 := " "
	_cX2 := "1"
	_cX3 := " "
ElseIf 	SZE->ZE_TIPO == "2"
	_cX1 := " "
	_cX2 := "2"
	_cX3 := " "
ElseIf 	SZE->ZE_TIPO == "3"
	_cX1 := " "
	_cX2 := "3"
	_cX3 := " "
ElseIf 	SZE->ZE_TIPO == "4"
	_cX1 := "X"
	_cX2 := " "
	_cX3 := " "
ElseIf 	SZE->ZE_TIPO == "5"
	_cX1 := " "
	_cX2 := " "
	_cX3 := "X"
ElseIf 	SZE->ZE_TIPO == "6"
	_cX1 := " "
	_cX2 := "2+3"
	_cX3 := " "
Else
	_cX1 := " "
	_cX2 := " "
	_cX3 := " "
Endif

_cObs    := SG1->G1_OBSERV
_cMatriz := Alltrim(SG1->G1_NOMEFER) +" + "+Alltrim(SG1->G1_NOMMAT2)
_nQPF    := SG1->G1_QUANT
//_nQPecas := SC2->C2_QUANT

_nPrI1 := SG1->G1_PEPFINI
_nPrI2 := SG1->G1_PEPFFIM
_cUMPI := SG1->G1_UMPI

_nPrF1 := SG1->G1_PEMATI2
_nPrF2 := SG1->G1_PEMATF2
_cUMPF := SG1->G1_UMPF

_cMeIn := SG1->G1_MEPFINI
_cMeFi := SG1->G1_MEPFFIM
_cRev  := SG1->G1_REVFICH
/*
@Li,00 PSay "Ficha Tecnica    :"
@Li,20 PSay SG1->G1_FICHTEC
@Li,42 PSay " REV "
@Li,50 PSay SG1->G1_REVFICH
*/

Return
