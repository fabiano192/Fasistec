#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*
Programa	: CR0031
Autor		: Fabiano da Silva
Data		: 11/06/2012
Descrição	: Programa utilizado para imprimmir etiqueta através no menu do Movto de Produção (MATA250)
*/


User Function CR0031()

Private _cPorta    := "LPT1"
Private _dEmis     := dDataBase
Private _nQuant    := 0
Private _nQtde     := 0
Private _cProd     := SPACE(15)
Private _cLote     := SPACE(6)
Private _dValid    := CTOD("  /  /  ")
Private _cCompo    := ""
Private _cMolde    := ""
//Private _cCliente  := Space(6)

@ 0  ,0 TO 350,380 DIALOG oDlg1 TITLE "Etiquetas Produção Preparação - PA0229"
@ 10 ,10 SAY "Emissao"
@ 10 ,70 GET _dEmis   PICTURE "@!" SIZE 50,10 OBJECT _oEmissa
//@ 30 ,10 SAY "Cliente:"
//@ 30 ,70 GET _cCliente  PICTURE "@!" SIZE 50,10 F3 "SA1" VALID VERSA1() OBJECT _oCliente
@ 30 ,10 SAY "Produto"
@ 30 ,70 GET _cProd   PICTURE "@!" SIZE 50,10 F3 "SB1" VALID VERSB1() OBJECT _oProdut
//@ 30 ,70 GET _cProd   PICTURE "@!" SIZE 50,10 When !Empty(_cCliente) F3 "SB1" VALID VERSB1() OBJECT _oProdut
@ 50 ,10 SAY "Quantidade:"
@ 50 ,70 GET _nQtde   PICTURE "@E 9999" SIZE 50,10 VALID VERET1() OBJECT _oQuant
//@ 50 ,70 GET _nQtde   PICTURE "@E 9999" SIZE 50,10 When !Empty(_cCliente) VALID VERET1() OBJECT _oQuant
@ 70 ,10 SAY "Qtd. de Etiquetas:"
@ 70 ,70 GET _nQuant   PICTURE "@E 9999" SIZE 50,10 VALID VERET2() OBJECT _oQtEti
//@ 70 ,70 GET _nQuant   PICTURE "@E 9999" SIZE 50,10 When !Empty(_cCliente) VALID VERET2() OBJECT _oQtEti
@ 090,10 SAY "Lote:"
@ 090,70 GET _cLote     PICTURE "@!" SIZE 50,10 OBJECT _oLote
//@ 090,70 GET _cLote     PICTURE "@!" SIZE 50,10 When !Empty(_cCliente) OBJECT _oLote
@ 110,10 SAY "Validade:"
@ 110,70 GET _dValid    PICTURE "@!" SIZE 50,10 OBJECT _oDValid
//@ 110,70 GET _dValid    PICTURE "@!" SIZE 50,10 When !Empty(_cCliente) OBJECT _oDValid

@ 130,030 BMPBUTTON TYPE 1 ACTION (Processa({|| ImpEt() }),Close(oDlg1))
@ 130,080 BMPBUTTON TYPE 2 ACTION Close(oDlg1)

ACTIVATE DIALOG oDlg1 CENTER

Return


Static Function VerSB1()

_lRet    :=.F.

SB1->(dbSetOrder(1))
If SB1->(dbseek(xFilial("SB1")+_cProd))
	If SB1->B1_GRUPO $  "PIPF/PIPM"   // PRE FORMADO   / Inserto Metalico
		_lRet    :=.T.
	Else
		Alert("Produto digitado não´é um pre-formado! Digite um codigo de produto valido.")
	Endif
Else
	Alert("Produto digitado não´encontrado! Digite um codigo de produto valido.")
Endif

Return(_lRet)


Static Function VerET1()

_lRet    :=.t.

If _nQtde == 0
	_lRet := .F.
Endif

Return(_lRet)



Static Function VerET2()

_lRet    :=.t.

If _nQuant == 0
	_lRet := .F.
Endif

Return(_lRet)




Static Function ImpEt()

_cProdPre 	:= _cProd
_cProdu     := _cProdPre

For F:=1 to 50 //Descobrir o PA
	
	dbSelectArea("SG1")
	dbSetOrder(2)
	If dbSeek(xFilial("SG1")+_cProdu)
		
		dbSelectarea("SB1")
		dbSetOrder(1)
		If dbseek(xFilial("SB1")+SG1->G1_COD)
			If SB1->B1_TIPO = 'PA'
				Exit
			Endif
		Endif
	Endif
	_cProdu := SG1->G1_COD
Next F

nEstru 		:= 0
aEstru    	:= Estrut(SB1->B1_COD)

dbSelectarea("SB1")
_cAliSB1 := Alias()
_nOrdSB1 := IndexOrd()
_nRecSB1 := Recno()

For E:= 1 To Len(aEstru)
	
	dbSelectarea("SB1")
	dbSetOrder(1)
	If dbseek(xFilial("SB1")+aEstru[E,3])
//		If SB1->B1_TIPO == "PI" .And. SB1->B1_GRUPO $ "PIC /MPVZ/MPC " .And. SB1->B1_SUBGR != "PACO"
		If SB1->B1_TIPO == "MP" .And. SB1->B1_GRUPO $ "PIC /MPVZ/MPC " .And. SB1->B1_SUBGR != "PACO"
			If Len(_cCompo) > 2
				_cCompo += ";"
			Endif
			_cCompo += SB1->B1_COD
		ElseIf SB1->B1_TIPO == "FR"
			If Len(_cMolde) > 2
				_cMolde += ";"
			Endif
			_cMolde += SB1->B1_COD
		Endif
	Endif
Next E

dbSelectArea("SB1")
dbSetOrder(_nOrdSB1)
dbGoto(_nRecSB1)

_nQtSD3 := _nQtde / _nQuant

_nQt1 := _nQt2 := 0
If _nQtde % _nQuant = 0
	_nQt1 := _nQt2 := _nQtSD3
Else
	_nQt1 := Int(_nQtSD3)
	_nQt2 := _nQtde - (_nQt1 * (_nQuant-1))
Endif

For Et := 1 To _nQuant
	
	If 	Et < _nQuant
		_nQt3 := _nQt1
	Else
		_nQt3 := _nQt2
	Endif
	
	MSCBPRINTER("ARGOX",_cPorta,,,.f.)
	MSCBCHKSTATUS(.f.)
	
	MSCBBEGIN(1,6)
	
	MSCBSAY(35,45,Alltrim(_cProd)    	, "N", "5", "2",.F.)
	
	MSCBSAY(05,32,"QUANTIDADE:"				, "N", "2", "1",.F.)
	MSCBSAY(28,32, Alltrim(TRANSFORM(_nQt3,"@E 9999.999 ")) 	, "N", "3", "1",.F.)
	
	MSCBSAY(60,32,"COMPOSTO:"				, "N", "2", "1",.F.)
	MSCBSAY(75,32, _cCompo 					, "N", "3", "1",.F.)
	
	_cEmiss := Strzero(day(_dEmis),2)+"/"+substr(mes(_dEmis),1,3)+"/"+substr(strzero(year(_dEmis),4),3,2)
	MSCBSAY(05,23,"DATA PRODUCAO:"			, "N", "2", "1",.F.)
	MSCBSAY(28,23,_cEmiss					, "N", "3", "1",.F.)
	
	MSCBSAY(60,23,"MOLDE:"					, "N", "2", "1",.F.)
	MSCBSAY(75,23, _cMolde 					, "N", "3", "1",.F.)
	
	MSCBSAY(05,14,"LOTE:"					, "N", "2", "1",.F.)
	MSCBSAY(28,14,_cLote					, "N", "3", "1",.F.)
	
	If !Empty(_dValid)
		_cValid := Strzero(day(_dValid),2)+"/"+substr(mes(_dValid),1,3)+"/"+substr(strzero(year(_dValid),4),3,2)
	Else
		_cValid := ""
	Endif
	MSCBSAY(60,14,"VALIDADE:"				, "N", "2", "1",.F.)
	MSCBSAY(75,14,_cValid				    , "N", "3", "1",.F.)
	
//	MSCBSAY(05,09,"CLIENTE:"				, "N", "2", "1",.F.)
//	MSCBSAY(28,09,_cCliente				    , "N", "3", "1",.F.)
	
	MSCBEND()
	
	MSCBClosePrinter()
	
	_oEmissa   :Refresh()
	_oProdut   :Refresh()
	_oQuant    :Refresh()
	_oQtEti    :Refresh()
//	_oCliente  :Refresh()
	_oLote     :Refresh()
	_oDValid   :Refresh()
	
Next Et

Return()
