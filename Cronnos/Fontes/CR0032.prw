#include "RWMAKE.CH"
#include "PROTHEUS.CH"
#include "shell.ch"
#include "FILEIO.CH"

/*
Programa	: CR0032
Autor		: Fabiano da Silva
Data		: 12/07/2013
Descrição	: Gerar etiqueta de embalagem para Clientes Nacionais
*/

User Function CR0032()
	
	LOCAL oDlg1 := NIL
	
	Private _cRevis 	:= _cComp := ""
	Private _cPedItem  	:= Space(08)
	Private _nQtpEmb    := 1
	Private _lASN		:= .T.
	Private _cNota		:= Space(9)
	Private _cCOD		:= SPACE(15)
	Private _nDif       := 0
	_nQuant  			:= 0
	_nQuant2 			:= 0
	_nQuant3 			:= 0
	_cDescp  			:= ""
	
	PRIVATE oPrn       	:= NIL
	PRIVATE oFont2     	:= NIL
	PRIVATE oFont5     	:= NIL
	
	DEFINE FONT oFont2 NAME "Arial" SIZE 0,13 OF oPrn BOLD
	DEFINE FONT oFont5 NAME "Arial" SIZE 0,10 OF oPrn BOLD
	
	DEFINE MSDIALOG oDlg1 FROM 0,0 TO 290,390 TITLE "Etiquetas Clientes Nacionais" OF oDlg1 PIXEL
	
	@ 010 ,10 SAY "Codigo:" OF oDlg1 PIXEL Size 150,010
	@ 010 ,70 GET _cCod     PICTURE "@!" SIZE 70,10 VALID VerProd() F3 "SB1" OBJECT _OWCOD
	@ 030 ,10 GET _cDescP   SIZE 165,10 WHEN .F. OBJECT _OWDESCP
	
	@ 050 ,10 SAY "Nota Fiscal:" OF oDlg1 PIXEL Size 150,010
	@ 050 ,70 GET _cNota  PICTURE "@!" SIZE 70,10 VALID Vernota()  OBJECT _oNota
	
	@ 070,10 SAY "Pedido + Item " OF oDlg1 PIXEL Size 150,010
	@ 070,70 GET _cPedItem PICTURE "@!" SIZE 70,10 VALID VERPED() OBJECT _oPedItem
	
	@ 090,10 SAY "Qtd. Pecas:" OF oDlg1 PIXEL Size 150,010
	@ 090,70 GET _nQuant2  PICTURE "@E 999999" SIZE 50,10 VALID VERQTDE(_nQuant2) OBJECT _oQtPc
	
	@ 110,10 SAY "Qtd. Pecas p/ Emb:" OF oDlg1 PIXEL Size 150,010
	@ 110,70 GET _nQuant3   PICTURE "@E 9999" SIZE 50,10 VALID VerQuant(1,_nQuant2) OBJECT _oQtPEmb
	
	@ 130,10 SAY "Qtd. Etiquetas:" OF oDlg1 PIXEL Size 150,010
	@ 130,70 GET _nQuant   PICTURE "@E 999.99" When .F. SIZE 50,10 OBJECT _oQtEtiq
	
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


Static Function VerQTDE(_nQuant)
	
	_lRet    :=.t.
	
	If _nQuant == 0
		_lRet := .F.
	Endif
	
	VerQuant(2,_nQuant)
	
Return(_lRet)



Static Function VERPED()
	
	_lRet    := .F.
	
	If Len(Alltrim(_cPedItem)) < 8
		_cPedItem := PadL(Alltrim(_cPedItem),8,'0')
	Endif
	
	SC6->(dbSetOrder(1))
	SC6->(msSeek(xFilial("SC6")+_cPedItem))
	
	//	_aAliSD2 := SD2->(GETAREA())
	
	SD2->(dbSetOrder(8))
	If SD2->(msSeek(xFilial("SD2")+_cPedItem))
		_cChavSd2 := SD2->D2_PEDIDO + SD2->D2_ITEMPV
		
		While !SD2->(Eof()) .And.	_cChavSd2 == SD2->D2_PEDIDO + SD2->D2_ITEMPV .And. !_lRet
			
			If SD2->D2_DOC == _cNota
				
				VerQuant(2,SD2->D2_QUANT)
				
				_lRet 		:= .T.
				
				Return(_lRet)
				
			Endif
			
			SD2->(dbSkip())
		EndDo
	Endif
	
	_oPedItem:Refresh()
	
Return(_lRet)



Static Function VerQuant(_nTp,_nQuant1)
	
	SZ2->(dbSetOrder(8))
	SZ2->(dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_PROCLI + SD2->D2_PEDCLI+'1'))

//	SZ2->(dbSetOrder(1))
//	SZ2->(dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD + SD2->D2_PROCLI))
	
	If Empty(SZ2->Z2_REVISAO)
		_cRevis := "00"
	Else
		_cRevis := Substr(SZ2->Z2_REVISAO,1,3)
	Endif
	
	//	_nQtpEmb := _nQuant1
	
	If SZ2->Z2_QTPEMB > 0 //.And. SZ2->Z2_QTPEMB < _nQuant1
		_nQtpEmb := SZ2->Z2_QTPEMB
	Else
		_nQtpEmb := 0
	Endif
	
	If _nTp = 1
		lRet := .T.
	Else
		lRet := Nil
		_nQuant3    := _nQtpEmb
	Endif
	
	_nQuant2 := _nQuant1
	
	_nDif := 0
	If (_nQuant1 / _nQuant3) - Int(_nQuant1 / _nQuant3) > 0		
		_nQuant  := Int(_nQuant1 / _nQuant3)+1
		_nDif    := _nQuant1 - ((_nQuant - 1) * _nQuant3)
//		_nDif    := ((_nQuant1 / _nQuant3) - Int(_nQuant1 / _nQuant3)) * 100
	Else
		_nQuant  := _nQuant1 / _nQuant3
	Endif
		
	If _nQuant3 = 0
		If _nTp = 1
			lRet := .F.
		Endif
	Endif
	
	_oQtPc:Refresh()
	_oQtPEmb:Refresh()
	_oQtEtiq:Refresh()
	
	
Return(lRet)


Static Function VerNota()
	
	_lRet := .F.
	
	If Len(Alltrim(_cNota)) < 9
		_cNota := PadL(Alltrim(_cNota),9,'0')
	Endif
	
	dbSelectArea("SF2")
	dbSetOrder(1)
	If dbSeek(xFilial("SF2") +_cNota )
		
		If SF2->F2_CLIENTE = '000017' .AND. Empty(SF2->F2_ASN)
			MsgAlert("ASN não gerada para essa NF!")
			_lRet := .F.
		Else
			_lRet := .T.
		Endif
	Endif
	
	_oNota:Refresh()
	
Return(_lRet)



Static Function ImpEt()
	
	LOCAL aParamImp		:= {}
	LOCAL _cDescr:=""
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
	
	_dData := SF2->F2_EMISSAO
	_cData := Strzero(day(_dData),2)+"-"+substr(mes(_dData),1,3)+"-"+substr(strzero(year(_dData),4),3,2)
	
	
	nVias 		:= 1
	cTemplate	:="\etiquetas\CR0032.prn"
	
	For F:= 1 to _nQuant
		
		aParamImp:={}
		
		AAdd(aParamImp, {_cData     						,"[DTEMIS]"})    //Emissão
		
		AAdd(aParamImp, {Left(SA1->A1_NOME,40)     			,"[CLIENTE]"})   //Nome Cliente
		
		aADD(aParamImp, {Alltrim(SD2->D2_PROCLI)      		,"[PRODCLI]"})   //Código Produto Cliente
		aADD(aParamImp, {_cRevis      						,"[REV]"})   	 //Revisão
		aADD(aParamImp, {Alltrim(SD2->D2_PEDCLI)   			,"[PEDCLI]"})    //Pedido Cliente
		
		aADD(aParamImp, {Alltrim(SD2->D2_COD)      			,"[PRODPAS]"})   //Código Produto Pasy
		aADD(aParamImp, {Alltrim(_cNOta)	      			,"[NF]"})   	 //Nota Fiscal
		
		_nQtImp := _nQuant3
//		_nQtImp := _nQuant2/_nQuant
		If F = _nQuant .And. _nDif > 0
			_nQtImp := _nDif
		Endif
		
		AAdd(aParamImp, {Alltrim(TRANSFORM(_nQtImp,"@E 99,999"))+" / "+Alltrim(TRANSFORM(_nQuant2,"@E 99,999"))				,"[QTDE]"})    //Quantidade
		
		AAdd(aParamImp, {Alltrim(TRANSFORM(F,"@E 999 "))+" / "+ Alltrim(TRANSFORM(_nQuant,"@E 999")),	"[VOLUME]"})    //Volume
		
		AAdd(aParamImp, {Substr(SZ2->Z2_DESCCLI,1,30)		,"[DESCRIC]"})    //Descrição
		
		AAdd(aParamImp, {alltrim(SB1->B1_CBAR14)			,"[BAR01]"})    //Código de Barras 01
		AAdd(aParamImp, {alltrim(SB1->B1_CODETIQ)			,"[BAR02]"})    //Código de Barras 02
		
		
		u_Etiqueta(aParamImp,nVias,cTemplate)
		
		_cDescP   := ""
		_cCod     := space(15)

	Next F
	
	_oWDESCP  :Refresh()
	_oWCod    :Refresh()
	_oNota    :Refresh()
	_oQtEtiq  :Refresh()
	_oQtPc    :Refresh()
	//	_oPedItem :Refresh()
	
Return .T.
