#include "RWMAKE.CH"
#include "PROTHEUS.CH"
#include "shell.ch"
#include "FILEIO.CH"

/*
Programa	: CR0033
Autor		: Fabiano da Silva
Data		: 12/07/2013
Descrição	: Gerar etiqueta de Caixa para Clientes Nacionais
*/

User Function CR0033()

LOCAL oDlg1 := NIL

Private _cNota   	:= Space(9)
Private _nQuant  	:= 00000
Private _nQtItens	:= 00000
Private _nQuant2 	:= 00000
Private _dData   	:= dDataBase
Private _cNome   	:= SPACE(40)
Private _cDestino	:= SPACE(40)

DEFINE MSDIALOG oDlg1 FROM 0,0 TO 290,390 TITLE "Etiquetas Clientes Nacionais" OF oDlg1 PIXEL

@ 10 ,10 SAY "Data" OF oDlg1 PIXEL Size 150,010
@ 10 ,70 GET _dData  PICTURE "@!" SIZE 70,10 OBJECT _oData
@ 30 ,10 SAY "Nota Fiscal:" OF oDlg1 PIXEL Size 150,010
@ 30 ,70 GET _cNota  PICTURE "@!" VALID VERNOTA() SIZE 70,10 OBJECT _oNota
@ 50 ,10 SAY "Cliente" OF oDlg1 PIXEL Size 150,010
@ 50 ,70 GET _cNome  When .F. SIZE 120,10 OBJECT _oCliente
@ 70 ,10 SAY "Destino" OF oDlg1 PIXEL Size 150,010
@ 70 ,70 GET _cDestino PICTURE "@!" SIZE 120,10 OBJECT _oDestino
@ 90,10 SAY "Qtd. Etiquetas:" OF oDlg1 PIXEL Size 150,010
@ 90,70 GET _nQuant   PICTURE "@E 9999" SIZE 70,10 OBJECT _oQtEtiq
@ 110,10 SAY "Qtd. Itens:" OF oDlg1 PIXEL Size 150,010
@ 110,70 GET _nQtItens   PICTURE "@E 9999" SIZE 70,10 OBJECT _oQtItens

@ 130,080 BMPBUTTON TYPE 1 ACTION Processa({|| ImpEt() })
@ 130,110 BMPBUTTON TYPE 2 ACTION Close(oDlg1)

ACTIVATE DIALOG oDlg1 CENTER

Return


Static Function VerNota()

_lRet := .F.        

If Len(Alltrim(_cNota)) < 9
	_cNota := PadL(Alltrim(_cNota),9,'0')
Endif

dbSelectArea("SF2")
dbSetOrder(1)
If dbSeek(xFilial("SF2") +_cNota )
	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
    	_cNome := LEFT(SA1->A1_NOME,35)
		_lRet := .T. 
	Endif
Endif

_oNota    :Refresh()
_oCliente :Refresh()
_oQtEtiq  :Refresh()
_oData    :Refresh()
_oDestino :Refresh()

Return(_lRet)



Static Function ImpEt()

LOCAL aParamImp		:= {}

_cData := Strzero(day(_dData),2)+"-"+substr(mes(_dData),1,3)+	"-"+substr(strzero(year(_dData),4),3,2)

AAdd(aParamImp, {_cNome					   					,"[CLIENTE]"})   //Nome Cliente

aADD(aParamImp, {Alltrim(_cDestino)      					,"[DESTINO]"})   //Destino

aADD(aParamImp, {Alltrim(_cNota)	      					,"[NF]"})   	 //Nota Fiscal

AAdd(aParamImp, {_cData     								,"[DTEMIS]"})    //Emissão

AAdd(aParamImp, {Alltrim(TRANSFORM(_nQtItens,"@E 999 "))    ,"[QTITENS]"})    //Qtde Itens

nVias 		:= _nQuant
cTemplate	:="\etiquetas\CR0033.prn"

For F:= 1 to _nQuant
	u_Etiqueta(aParamImp,nVias,cTemplate)
Next F

_oNota    :Refresh()
_oCliente :Refresh()
_oQtEtiq  :Refresh()
_oData    :Refresh()
_oDestino :Refresh()

Return .T.
