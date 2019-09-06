#include "RWMAKE.CH"
#include "PROTHEUS.CH"
#include "shell.ch"
#include "FILEIO.CH"

/*
Programa	: PA0240
Autor		: Fabiano da Silva
Data		: 10/07/2013
Descrição	: Gerar etiqueta de embalagem para Clientes Nacionais
*/

User Function PA0240()

LOCAL oDlg1 := NIL

Private _cRevis 	:= _cComp := ""
Private _cPedItem  	:= Space(08)
_cCOD    			:= SPACE(15)
_cPedido 			:= Space(6)
_cNota   			:= Space(9)
_nQuant  			:= 000000
_nQuant2 			:= 000000
_cDescp  			:= ""

PRIVATE oPrn       	:= NIL
PRIVATE oFont2     	:= NIL
PRIVATE oFont5     	:= NIL

DEFINE FONT oFont2 NAME "Arial" SIZE 0,13 OF oPrn BOLD
DEFINE FONT oFont5 NAME "Arial" SIZE 0,10 OF oPrn BOLD

DEFINE MSDIALOG oDlg1 FROM 0,0 TO 290,390 TITLE "Etiquetas Clientes Nacionais" OF oDlg1 PIXEL

@ 10 ,10 SAY "Codigo:" OF oDlg1 PIXEL Size 150,010
@ 10 ,70 GET _cCod     PICTURE "@!" SIZE 70,10 VALID VerProd() F3 "SB1" OBJECT _OWCOD
@ 30 ,10 GET _cDescP   SIZE 165,10 WHEN .F. OBJECT _OWDESCP

@ 70 ,10 SAY "Nota Fiscal:" OF oDlg1 PIXEL Size 150,010
@ 70 ,70 GET _cNota  PICTURE "@!" SIZE 70,10 VALID Vernota()  OBJECT _oNota

@ 090,10 SAY "Qtd. Etiquetas:" OF oDlg1 PIXEL Size 150,010
@ 090,70 GET _nQuant   PICTURE "@E 9999" SIZE 50,10 VALID VERETI() OBJECT _oQtEtiq

@ 110,10 SAY "Qtd. Pecas:" OF oDlg1 PIXEL Size 150,010
@ 110,70 GET _nQuant2  PICTURE "@E 999999" SIZE 50,10 VALID VERQTDE() OBJECT _oQtPc

@ 130,10 SAY "Pedido + Item " OF oDlg1 PIXEL Size 150,010
@ 130,70 GET _cPedItem PICTURE "@!" SIZE 70,10 VALID VERPED() OBJECT _oPedItem

@ 080,165 BMPBUTTON TYPE 1 ACTION Processa({|| ImpEt() })
@ 100,165 BMPBUTTON TYPE 2 ACTION Close(oDlg1)

ACTIVATE DIALOG oDlg1 CENTER

Return


Static Function VerProd()

_lRet    :=.F.
_cDescP  :=""

DBSELECTAREA("SB1")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SB1")+_cCod)
	_cDescP  := SB1->B1_DESC
	_lREt    := .T.
Endif

_oWDESCP :Refresh()
_oWCod   :Refresh()
_oNota   :Refresh()
_oQtEtiq :Refresh()
_oQtPc   :Refresh()
_oPedItem:Refresh()

Return(_lRet)


Static Function VerETI()

_lRet    :=.t.

If _nQuant == 0
	_lRet := .F.
Endif

Return(_lRet)


Static Function VerQTDE()

_lRet    :=.t.

If _nQuant2 == 0
	_lRet := .F.
Endif

Return(_lRet)



Static Function VERPED()

_lRet    := .f.

dbSelectArea("SC6")
dbSetOrder(1)
dbSeek(xFilial("SC6")+_cPedItem)

_aAliSD2 := SD2->(GETAREA())
dbSelectArea("SD2")
dbSetOrder(8)
If dbSeek(xFilial("SD2")+_cPedItem)
	_cChavSd2 := SD2->D2_PEDIDO + SD2->D2_ITEMPV
	
	While !Eof() .And.	_cChavSd2 == SD2->D2_PEDIDO + SD2->D2_ITEMPV .And. !_lRet
		If SD2->D2_DOC == _cNota
			_lRet := .T.
		Endif
		
		dbSelectArea("SD2")
		dbSkip()
	EndDo
Endif

RestArea(_aAliSD2)

Return(_lRet)


Static Function VerNota()

_lRet := .F.
dbSelectArea("SF2")
dbSetOrder(1)
If dbSeek(xFilial("SF2") +_cNota )
	dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek(xFilial("SD2")+_cNota + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA + _cCod)
	_lRet := .T.
Endif

dbSelectArea("SZ2")
dbSetOrder(1)
dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD + SD2->D2_PROCLI)

If Empty(SZ2->Z2_REVISAO)
	_cRevis := "00"
Else
	_cRevis := Substr(SZ2->Z2_REVISAO,1,3)
Endif

Return(_lRet)



Static Function ImpEt()

LOCAL aParamImp		:= {}
LOCAL _cDescr:=""


dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)

_nQtEt := _nQuant
_dData := SF2->F2_EMISSAO
_cData := Strzero(day(_dData),2)+"-"+substr(mes(_dData),1,3)+"-"+substr(strzero(year(_dData),4),3,2)

aParamImp:={}

AAdd(aParamImp, {_cData     						,"[DTEMIS]"})    //Emissão

AAdd(aParamImp, {Left(SA1->A1_NOME,40)     			,"[CLIENTE]"})   //Nome Cliente

aADD(aParamImp, {Alltrim(SD2->D2_PROCLI)      		,"[PRODCLI]"})   //Código Produto Cliente
aADD(aParamImp, {_cRevis      						,"[REV]"})   	 //Revisão
aADD(aParamImp, {Alltrim(SC6->C6_PEDCLI)   			,"[PEDCLI]"})    //Pedido Cliente

aADD(aParamImp, {Alltrim(SD2->D2_COD)      			,"[PRODPAS]"})   //Código Produto Pasy
aADD(aParamImp, {Alltrim(_cNOta)	      			,"[NF]"})   	 //Nota Fiscal

AAdd(aParamImp, {_cPedItem							,"[PEDPAS]"})    //Pedido Pasy
AAdd(aParamImp, {Alltrim(TRANSFORM(_nQuant2,"@E 999,999,999 "))+" "+SD2->D2_UM				,"[QTDE]"})    //Quantidade

AAdd(aParamImp, {Substr(SZ2->Z2_DESCCLI,1,30)		,"[DESCRIC]"})    //Descrição

AAdd(aParamImp, {alltrim(SB1->B1_CBAR14)			,"[BAR01]"})    //Código de Barras 01
AAdd(aParamImp, {alltrim(SB1->B1_CODETIQ)			,"[BAR02]"})    //Código de Barras 02

nVias 		:= 1
cTemplate	:="\etiquetas\PA0240.prn"

For F:= 1 to _nQuant
	u_Etiqueta(aParamImp,nVias,cTemplate)
Next F

_oWDESCP  :Refresh()
_oWCod    :Refresh()
_oNota    :Refresh()
_oQtEtiq  :Refresh()
_oQtPc    :Refresh()
_oPedItem :Refresh()

Return .T.



User FUNCTION Etiqueta(aInfo, nVias, cTemplate)

LOCAL cEtiq:=""
LOCAL cArq:=""
LOCAL cArqBat:=""
LOCAL nSt:=""
LOCAL cNVias
LOCAL aDefs:={}
LOCAL nHandle
LOCAL nLength
LOCAL nCpo:=1
LOCAL cXXX:=""
LOCAL nPosCpo:=0

cNVias:=IIf(Valtype(nVias)=="N",StrZero(nVias,4,0), "0001")

IF !File( (cTemplate) )
	Alert('Esta função procura o Template da Etiqueta "'+Upper(cTemplate)+'" no Servidor do Sistema.'+CRLF+'E este template não foi encontrado no local indicado.')
	RETURN
ENDIF

nHandle := Fopen( (cTemplate) , FO_READ + FO_SHARED )
nLength := FSEEK(nHandle, 0, FS_END)

FSEEK(nHandle, 0)

nLidos:=FRead( nHandle, cEtiq, nLength )

FClose(nHandle)

If nLength <> nLidos
	Alert("Não foi possivel ler todo o Template da Etiqueta: '"+cTemplate+"'")
	RETURN
ENDIF

FOR ncpo:=1 TO Len(aInfo)
	nPosCpo:=AT((aInfo[nCpo,2]),cEtiq)
	IF nPoscpo <> 0
		cEtiq:=Stuff( cEtiq,  nPosCpo,  Len(aInfo[nCpo,2]), (Alltrim(aInfo[nCpo,1])))
	ENDIF
NEXT

cArq:=GetTempPath(.T.)+Criatrab(,.F.)
MemoWrite( (cArq),cEtiq)

cArqBat:=cArq+".bat"
MemoWrite( (cArqBat), ("TYPE "+cArq+" >LPT1") )
nSt:=WaitRun( (cArqBat),0)

FERASE((cArq))
FERASE( (cArqBat) )

_cDescP   := ""
_cCod     := space(15)

RETURN

