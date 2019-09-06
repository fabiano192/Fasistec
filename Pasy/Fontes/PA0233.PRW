#INCLUDE 'PROTHEUS.CH'

/*
Programa	: PA0233
Autor		: Fabiano da Silva
Data		: 20/11/2012
Descrição	: Gravar Numero do Tracking Number nos processos de embarque
*/


User Function PA0233()

Private oDlg, oScr, oCombo, oGet1, oGet2, oGet3, oGet4
Private _lWhen   := .F.
Private _cExp    := SPACE(20)
Private _cTransp := Space(6)
Private _cDescTr := Space(40)
Private _cTrack  := Space(30)
Private _oCombo  
Private _aCombo  := {'Sim','Não'}
Private _cCombo  := _aCombo[2]

DEFINE MSDIALOG oDlg FROM 0,0 TO 290,390 PIXEL TITLE "Tracking Number"

@ 10 ,10 SAY "Processo:" OF oDlg PIXEL Size 150,010 
@ 10 ,70 MSGET oGet1 VAR _cExp SIZE 70,10 PIXEL PICTURE "@!"  VALID VerProc()

@ 25 ,10 SAY "Tracking Number?" OF oDlg PIXEL Size 150,010 
@ 25, 70 COMBOBOX _oCombo VAR _cCombo ITEMS _aCombo SIZE 70, 010 PIXEL VALID VerCombo()

@ 40 ,10 SAY "Transportadora:" OF oDlg PIXEL Size 150,010 
@ 40 ,70 MSGET oGet2 VAR _cTransp  PICTURE "@!" SIZE 70,10 PIXEL WHEN _lWhen VALID VerTransp() F3 "Z6"
@ 55 ,10 MSGET oGet3 VAR _cDescTr  SIZE 165,10  PIXEL WHEN .F. 

@ 70 ,10 SAY "Tracking Number:" OF oDlg PIXEL Size 150,010
@ 70 ,70 MSGET oGet4 VAR _cTrack   PICTURE "@!" SIZE 70,10 PIXEL WHEN _lWhen VALID VERTRACK()

@ 90,030 BUTTON "OK" 		 SIZE 036,012 PIXEL ACTION (Processa({|| Track() }),oDlg:End()) 	OF oDlg 
@ 90,070 BUTTON "Sair"       SIZE 036,012 PIXEL ACTION ( oDlg:End()) 			OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

Return


Static Function VERTRACK()

_lRet    :=.t.

If Empty(_cTrack)
	_lRet := .F.
Endif

Return(_lRet)


Static Function VerProc()

_lRet := .F.

EEC->(dbSetOrder(1))
If EEC->(dbSeek(xFilial("EEC") + _cExp ))
	_lRet := .T.
	If !Empty(EEC->EEC_TRANUM)
		If MsgYesNo('Processo ja atualizado, deseja redigitar?')
			_lRet := .T.
		Else            
			_lRet := .F.
			oDlg:End()	
		Endif
	Endif
Else
	MsgInfo('Processo não encontrado!')
Endif

Return(_lRet)



Static Function VerTransp()

_lRet := .F.

SX5->(dbSetOrder(1))
If SX5->(dbSeek(xFilial("SX5")+"Z6"+ _cTransp))
	_cDescTr := SX5->X5_DESCRI
	_lRet := .T.			
Else
	MsgInfo('Transportadora não encontrada!')
Endif

Return(_lRet)


Static Function VerCombo()

If _cCombo == 'Sim'
	_lWhen := .T.
Else
	_lWhen := .F.
	_cTransp := Space(6)
	_cDescTr := Space(40)
	_cTrack  := Space(30)
Endif

Return()



Static Function TRACK()

EEC->(dbSetOrder(1))
If EEC->(dbSeek(xFilial("EEC") + _cExp ))
	EEC->(RecLock("EEC",.F.))
	EEC->EEC_TRANUM := Left(_cCombo,1)
	EEC->EEC_TRANSP := _cTransp
	EEC->EEC_TRACKI := _cTrack
	EEC->(MsUnlock())
Endif

Return()
