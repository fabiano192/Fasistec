#include "TOTVS.CH"

/*
Programa	: CR0072
Autor		: Fabiano da Silva
Data		: 08/06/2015
Descrição	: Gerar etiqueta de identificação do Produto
*/


User Function CR0072(_cCodigo,_cDescri,_dDta,_cLoteCtl,_cArmaz,_nTotal,_nTPEmb,_nEtiq)

	LOCAL _oDlg := NIL

	If _cCodigo <> Nil
		Private _cCOD		:= _cCodigo
		Private _cDescp  	:= _cDescri
		Private _dData  	:= _dDta
		Private _cLote  	:= _cLoteCtl
		Private _cAlmox  	:= _cArmaz
		Private _nQTotal 	:= _nTotal
		Private _nQtPEmb 	:= _nTPEmb
		Private _nQEtiq  	:= _nEtiq
		Private _lWhen  	:= .F.
		VerProd(_cCOD)
	Else
		Private _cCOD		:= SPACE(15)
		Private _cDescp  	:= SPACE(40)
		Private _dData  	:= dDataBase//CTOD('')
		Private _cLote  	:= SPACE(6)
		Private _cAlmox  	:= SPACE(2)
		Private _nQTotal 	:= 0
		Private _nQtPEmb 	:= 0
		Private _nQEtiq  	:= 0
		Private _lWhen  	:= .T.
	Endif

	Private _oDescP  	:= Nil
	Private _oCod 		:= Nil
	Private _oData 		:= Nil
	Private _oLote 		:= Nil
	Private _oQtEtiq 	:= Nil 
	Private _oQtPc 		:= Nil

	Private _nDif       := 0

	Private _lPrint		:= .f.

	_bOk 		:= "{ || If(!Empty(_cCod) .and. _nQTotal > 0 .and. !Empty(_dData) ,(_lPrint:=.t.,_oDlg:End()),Alert('Existe algum campo sem preenchimento!')) }"
	_bCancel 	:= "{ || _lPrint:=.f. , _oDlg:End() }"

//	DEFINE MSDIALOG _oDlg FROM 0,0 TO 290,390 TITLE "Etiquetas de Identificação" OF _oDlg PIXEL
	DEFINE MSDIALOG _oDlg FROM 0,0 TO 290,420 TITLE "Etiquetas de Identificação" OF _oDlg PIXEL

	_nLin := 35
	@ _nLin ,10 SAY "Codigo:" 															OF _oDlg PIXEL Size 150,010
	@ _nLin ,70 MSGET _oCod 	VAR _cCod     	WHEN _lWhen PICTURE "@!"  VALID VerProd(_cCod) F3 "SB1" 		OF _oDlg PIXEL SIZE 050,010
	
	_nLin += 15
	@ _nLin ,10 MSGET _oDescP VAR _cDescP    	WHEN .F.										OF _oDlg PIXEL SIZE 165,010
	
	_nLin += 15
	@ _nLin ,10 SAY "Data Entrada:" 														OF _oDlg PIXEL Size 150,010
	@ _nLin ,70 MSGET _oData 	VAR _dData  	WHEN _lWhen									OF _oDlg PIXEL SIZE 050,010

	_nLin += 15
	@ _nLin,10 SAY "Lote" 																	OF _oDlg PIXEL Size 150,010
	@ _nLin,70 MSGET _oLote 	VAR _cLote 		WHEN _lWhen PICTURE "@!" 					OF _oDlg PIXEL SIZE 050,010

	_nLin += 15
	@ _nLin,10 SAY "Qtd. Pecas:" 															OF _oDlg PIXEL Size 150,010
	@ _nLin,70 MSGET _oQtPc 	VAR _nQTotal  	WHEN _lWhen	PICTURE "@E 99,999.999" VALID VERQTDE(_nQTotal)	OF _oDlg PIXEL SIZE 050,010

	_nLin += 15
	@ _nLin,10 SAY "Qtd. Pecas p/ Emb:" 													OF _oDlg PIXEL Size 150,010
	@ _nLin,70 MSGET _oQtPEmb VAR _nQtPEmb   PICTURE "@E 9,999.999" VALID VerQuant(1,_nQTotal)	OF _oDlg PIXEL SIZE 050,010

	_nLin += 15
	@ _nLin,10 SAY "Qtd. Etiquetas:" 														OF _oDlg PIXEL Size 150,010
	@ _nLin,70 MSGET _oQtEtiq VAR _nQEtiq   PICTURE "@E 99" When .F. 						OF _oDlg PIXEL SIZE 050,010

	ACTIVATE MSDIALOG _oDlg CENTERED ON INIT EnchoiceBar(_oDlg,&(_bOk),&(_bCancel))

	If _lPrint
		ImpEt(_cCod,_cDescp,_dData,_cLote,_cAlmox,_nQTotal,_nQtPEmb,_nQEtiq)
	Endif

Return


Static Function VerProd(_cCod)

	_lRet    :=.F.
	_cDescP  :=""

	SB1->(DBSETORDER(1))
	IF SB1->(MSSEEK(XFILIAL("SB1")+_cCod))
		_cDescP  := Alltrim(SB1->B1_DESC)
		_cAlmox  := SB1->B1_LOCPAD
		_lREt    := .T.
	Endif

Return(_lRet)


Static Function VerQTDE(_nQEtiq)

	_lRet    :=.t.

	If _nQEtiq == 0
		_lRet := .F.
	Endif

	VerQuant(2,_nQEtiq)

Return(_lRet)




Static Function VerQuant(_nTp,_nQtde)

	If _nQtPEmb <= _nQtde

		If _nTp = 1 //Peças por Embalagem
			lRet := .T.
		ElseIf _nTp = 2 //Quantidade Total
			If _nQtPEmb = 0
				_nQtPEmb := _nQtde
			Endif
			lRet := Nil
		Endif

		_nQTotal := _nQtde

		_nDif := 0
		If (_nQtde / _nQtPEmb) - Int(_nQtde / _nQtPEmb) > 0		
			_nQEtiq  := Int(_nQtde / _nQtPEmb)+1
			_nDif    := _nQtde - ((_nQEtiq - 1) * _nQtPEmb)
		Else
			_nQEtiq  := _nQtde / _nQtPEmb
		Endif

		If _nQtPEmb = 0
			If _nTp = 1
				lRet := .F.
			Endif
		Endif
	Else
		MsgAlert('Quantidade por embalagem maior que o total!')
		lRet := .F.
	Endif
	
	_oQtPc:Refresh()
	_oQtPEmb:Refresh()
	_oQtEtiq:Refresh()

Return(lRet)



Static Function ImpEt(_cCod,_cDescp,_dData,_cLote,_cAlmox,_nQTotal,_nQtPEmb,_nQEtiq)

	LOCAL aParamImp		:= {}
	LOCAL _cDescr:=""

	nVias 		:= 1
	cTemplate	:="\etiquetas\CR0072.prn"

	For F:= 1 to _nQEtiq

		aParamImp:={}

		AAdd(aParamImp, {_cCod	     						,"[PRODUTO]"	})  //Produto

		AAdd(aParamImp, {Left(_cDescP,40)     				,"[DESCPRO]"	})  //Descrição

		AAdd(aParamImp, {SB1->B1_UM							,"[UM]"			})	//UM

		_nQtImp := _nQtPEmb
		If F = _nQEtiq .And. _nDif > 0
			_nQtImp := _nDif
		Endif

		AAdd(aParamImp, {Alltrim(TRANSFORM(_nQtImp,"@E 99,999.999"))	,"[QTDE]"})    //Quantidade

		AAdd(aParamImp, {Dtoc(_dData)						,"[DTENT]"		})	//Data entrada
		AAdd(aParamImp, {_cLote								,"[LOTE]"		})  //Lote
		AAdd(aParamImp, {_cAlmox							,"[ALMOX]"		})  //Almoxarifado

		U_ETIQUETA(aParamImp,nVias,cTemplate)
	Next F

Return .T.
