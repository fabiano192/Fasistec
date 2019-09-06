#include "RWMAKE.CH"
#include "PROTHEUS.CH"
#include "shell.ch"
#include "FILEIO.CH"

/*
Programa	: PA0242
Autor		: Fabiano da Silva
Data		: 17/07/2013
Descrição	: Gerar etiqueta de Amostra para Clientes Nacionais
*/

User Function PA0242()

LOCAL oDlg1 := NIL

Private _cRevis := _cComp := ""
_cCOD    := SPACE(15)
_cPedido := Space(6)
_cNota   := Space(9)
_nQuant  := 00000
_nQuant2 := 00000
_cDescp  := ""
_dData   := dDataBase
_cNome   := SPACE(40)
_cCliente:= SPACE(6)
_cCodCli := SPACE(15)
_cRev    := SPACE(3)
_cOP     := SPACE(8)
_cPedCli := SPACE(10)

Private _cPedItem  := Space(08)

DEFINE MSDIALOG oDlg1 FROM 0,0 TO 350,420 TITLE "Etiquetas Clientes Nacionais" OF oDlg1 PIXEL

@ 05 ,10 SAY "Data" OF oDlg1 PIXEL Size 150,010
@ 05 ,70 GET _dData  PICTURE "@!" SIZE 70,10 OBJECT _oData
@ 20 ,10 SAY "Nome Cliente" OF oDlg1 PIXEL Size 150,010
@ 20 ,70 GET _cNome  PICTURE "@!" SIZE 70,10 OBJECT _oCliente
@ 35 ,10 SAY "Cód. Produto Cliente" OF oDlg1 PIXEL Size 150,010
@ 35 ,70 GET _cCodCli  PICTURE "@!" SIZE 70,10 OBJECT _oCodCli
@ 50 ,10 SAY "Revisão" OF oDlg1 PIXEL Size 150,010
@ 50 ,70 GET _cRev  PICTURE "@!" SIZE 70,10 OBJECT _oRev
@ 065 ,10 SAY "Codigo:" OF oDlg1 PIXEL Size 150,010
@ 065 ,70 GET _cCod     PICTURE "@!" SIZE 70,10 F3 "SB1" Valid verprod() OBJECT _OWCOD
@ 080 ,10 GET _cDescP   SIZE 165,10 WHEN .F. OBJECT _OWDESCP    
@ 095,10 SAY "Pedido+Item " OF oDlg1 PIXEL Size 150,010
@ 095,70 GET _cOP PICTURE "@!" SIZE 70,10 OBJECT _oOP
@ 110,10 SAY "Pedido Cliente" OF oDlg1 PIXEL Size 150,010                      
@ 110,70 GET _cPedCli PICTURE "@!" SIZE 70,10 OBJECT _oPedCli
@ 125 ,10 SAY "Nota Fiscal:" OF oDlg1 PIXEL Size 150,010
@ 125 ,70 GET _cNota  PICTURE "@!" SIZE 70,10 OBJECT _oNota
@ 140,10 SAY "Qtd. Pecas:" OF oDlg1 PIXEL Size 150,010
@ 140,70 GET _nQuant2  PICTURE "@E 9999" SIZE 50,10 OBJECT _oQtPc
@ 155,10 SAY "Qtd. Etiquetas:" OF oDlg1 PIXEL Size 150,010
@ 155,70 GET _nQuant   PICTURE "@E 9999" SIZE 50,10 OBJECT _oQtEtiq

@ 05,160 BMPBUTTON TYPE 1 ACTION Processa({|| ImpEt() })
@ 20,160 BMPBUTTON TYPE 2 ACTION Close(oDlg1)

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

AAdd(aParamImp, {_cNome     						,"[CLIENTE]"})   //Nome Cliente

aADD(aParamImp, {_cCodCli      						,"[PRODCLI]"})   //Código Produto Cliente
aADD(aParamImp, {_cRev      						,"[REV]"})   	 //Revisão
aADD(aParamImp, {_cPedCli   						,"[PEDCLI]"})    //Pedido Cliente

aADD(aParamImp, {SB1->B1_COD       					,"[PRODPAS]"})   //Código Produto Pasy
aADD(aParamImp, {_cNOta	      						,"[NF]"})   	 //Nota Fiscal

AAdd(aParamImp, {_cOP								,"[PEDPAS]"})    //Pedido Pasy
AAdd(aParamImp, {Alltrim(TRANSFORM(_nQuant2,"@E 999,999,999 "))+" "+SB1->B1_UM				,"[QTDE]"})    //Quantidade

AAdd(aParamImp, {Substr(SB1->B1_DESC ,1,30)			,"[DESCRIC]"})    //Descrição

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
_oData    :Refresh()
_oCliente :Refresh()
_oCodCli  :Refresh()
_oRev     :Refresh()
_oPedCli  :Refresh()
_oOP      :Refresh()

Return .T.

