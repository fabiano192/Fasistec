#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PA0020    ºAutor  ³Alexandro da Silva  º Data ³  05/12/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualizacao de preco                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PA0020()

///////////////////////////////////////////////
///////////////////////////////////////////////
/////  Grupo de Pergunta PA0020          //////
/////  MV_PAR01 : Cliente      De ?      //////
/////  MV_PAR02 : Loja         De ?      //////
/////  MV_PAR03 : Loja Ate     De ?      //////
/////  MV_PAR04 : Produto      De ?      //////
/////  MV_PAR05 : Atualiza Pedido ?      //////
/////  MV_PAR06 : Pedido     De ?        //////
/////  MV_PAR07 : Pedido     Ate?        //////
/////  MV_PAR08 : Dt.Entrega De ?        //////
/////  MV_PAR09 : Dt.Entrega Ate?        //////
/////  MV_PAR10 : Dt.Emissao De ?        //////
/////  MV_PAR11 : Dt.Emissao Ate?        //////
/////  MV_PAR12 : Novo Preco    ?        //////
/////  MV_PAR13 : Tipo de Calculo?       //////
/////  MV_PAR14 : Data de Referencia?    //////
/////  MV_PAR15 : Base Economica  ?      //////
/////  MV_PAR16 : Quais Pedidos   ?      //////
/////  MV_PAR17 : Não considerar Lojas?? //////
/////  MV_PAR18 : Qual a Taxa Cambial??  //////
///////////////////////////////////////////////
///////////////////////////////////////////////

dbSelectArea("SX1")
If dbSeek("PA002001")
	While !Eof() .And. SX1->X1_GRUPO == "PA0020"
		
		dbSelectArea("SX1")
		RecLock("SX1",.F.)
		If SX1->X1_ORDEM $ "12/14/15/18"
			SX1->X1_CNT01 := Space(60)
		Endif
		dbSkip()
	EndDo
Endif

If !Pergunte("PA0020",.T.)
	Return
Endif

If MV_PAR12 == 0 .OR. Empty(MV_PAR14) .Or. EMPTY(MV_PAR15)
	MsgBox("Esta Faltando Alguma Informacao nos Parametros!!!","Informacao","erro")
	Return
Endif

If MV_PAR13 == 1
	Private _lParar    := .F.
	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| AtuPreco(@_lFim) }
	Private _cTitulo01 := 'Processando'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
	If !_lParar
		MsgBox("Preco Atualizado com Sucesso","Informacao","info")
	Else
		MsgBox("Preco Nao Foi Atualizado ","Informacao","info")
	Endif
Else
	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| DescPreco(@_lFim) }
	Private _cTitulo01 := 'Processando'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	MsgBox("Preco Descalculado com Sucesso","Informacao","info")
Endif


Return


Static Function AtuPreco(_lFim)

dbSeLectArea("SZ2")
dbSetOrder(4)
If dbSeek(xFilial("SZ2")+MV_PAR04+MV_PAR01)
	
	_cChavSZ2 := SZ2->Z2_CODCLI + SZ2->Z2_CLIENTE
	
	While !Eof() .And. (_cChavSZ2 == SZ2->Z2_CODCLI+SZ2->Z2_CLIENTE) .And. (SZ2->Z2_LOJA <= MV_PAR03)
		
		If _lFim
			Alert("Cancelado pelo Usuario!!")
			Return
		EndIf
		
		If SZ2->Z2_LOJA < MV_PAR02
			dbSelecTarea("SZ2")
			dbSkip()
			Loop
		Endif
		
		If SZ2->Z2_LOJA $ MV_PAR17
			dbSelectarea("SZ2")
			dbSkip()
			Loop
		Endif
		
		If Empty(SZ2->Z2_PRECO01)
			dbSelecTarea("SZ2")
			dbSkip()
			Loop
		Endif
		
		If SZ2->Z2_ATIVO == "2"
			dbSelectArea("SZ2")
			dbSkip()
			Loop
		Endif
		
		_nPrNovo   := MV_PAR12
		
		_nPerDes := 0
		                         
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SZ2->Z2_PRODUTO)
		
		If Substr(SZ2->Z2_PEDCLI,1,4) $ "QAPC/QAPP/QHPP"
			If SB1->B1_PICM == 12
				_nPerDes := Val(Tabela("Z8","12"))
			Else
				_nPerDes := Val(Tabela("Z8","18"))
			Endif
		Endif
			
		_nPrNov1 := _nPrNovo - (_nPrNovo * (_nPerDes/100))

		_lParar    := .F.
		_lAtualiza := .F.
		For I:=2 To 12
			_nValor1 :=  &("SZ2->Z2_PRECO"+StrZero(i,2))
			_nValor2 :=  &("SZ2->Z2_PRECO"+StrZero(i-1,2))
			_dData   := "SZ2->Z2_DTREF"+strZero(I,2)
			If &_dData == MV_PAR14
				Alert("Já existe Preço Na Data Informada, Descalcule ou Altere a Data")
				_lParar := .T.
				Exit
			Endif
			
			If Empty(_nValor1)
				dbSelectArea("SZ2")
				RecLock("SZ2",.F.)
				_nPreco   := "SZ2->Z2_PRECO"+strZero(I,2)
				_nTaxa    := "SZ2->Z2_TXCAM"+strZero(I,2)
				_dDtRef   := "SZ2->Z2_DTREF"+strZero(I,2)
				_dDtBas   := "SZ2->Z2_DTBAS"+strZero(I,2)
				&_nPreco  := _nPrNovo
				&_dDtRef  := MV_PAR14
				&_dDtBas  := MV_PAR15
				&_nTaxa   := MV_PAR18
				MsUnlock()
				I:= 12
				_lAtualiza := .T.
			Else
				_nValor2 :=  &("SZ2->Z2_PRECO"+StrZero(i,2))
			Endif
		Next I
		
		If _lparar
			dbSelecTarea("SZ2")
			dbSkip()
			Loop
		Endif
		
		If !_lAtualiza
			dbSelectArea("SZ2")
			Reclock("SZ2",.F.)
			SZ2->Z2_PRECO01 := SZ2->Z2_PRECO02
			SZ2->Z2_PRECO02 := SZ2->Z2_PRECO03
			SZ2->Z2_PRECO03 := SZ2->Z2_PRECO04
			SZ2->Z2_PRECO04 := SZ2->Z2_PRECO05
			SZ2->Z2_PRECO05 := SZ2->Z2_PRECO06
			SZ2->Z2_PRECO06 := SZ2->Z2_PRECO07
			SZ2->Z2_PRECO07 := SZ2->Z2_PRECO08
			SZ2->Z2_PRECO08 := SZ2->Z2_PRECO09
			SZ2->Z2_PRECO09 := SZ2->Z2_PRECO10
			SZ2->Z2_PRECO10 := SZ2->Z2_PRECO11
			SZ2->Z2_PRECO11 := SZ2->Z2_PRECO12
			SZ2->Z2_PRECO12 := _nPrNovo
			SZ2->Z2_DTREF01 := SZ2->Z2_DTREF02
			SZ2->Z2_DTREF02 := SZ2->Z2_DTREF03
			SZ2->Z2_DTREF03 := SZ2->Z2_DTREF04
			SZ2->Z2_DTREF04 := SZ2->Z2_DTREF05
			SZ2->Z2_DTREF05 := SZ2->Z2_DTREF06
			SZ2->Z2_DTREF06 := SZ2->Z2_DTREF07
			SZ2->Z2_DTREF07 := SZ2->Z2_DTREF08
			SZ2->Z2_DTREF08 := SZ2->Z2_DTREF09
			SZ2->Z2_DTREF09 := SZ2->Z2_DTREF10
			SZ2->Z2_DTREF10 := SZ2->Z2_DTREF11
			SZ2->Z2_DTREF11 := SZ2->Z2_DTREF12
			SZ2->Z2_DTREF12 := MV_PAR14
			SZ2->Z2_DTBAS01 := SZ2->Z2_DTBAS02
			SZ2->Z2_DTBAS02 := SZ2->Z2_DTBAS03
			SZ2->Z2_DTBAS03 := SZ2->Z2_DTBAS04
			SZ2->Z2_DTBAS04 := SZ2->Z2_DTBAS05
			SZ2->Z2_DTBAS05 := SZ2->Z2_DTBAS06
			SZ2->Z2_DTBAS06 := SZ2->Z2_DTBAS07
			SZ2->Z2_DTBAS07 := SZ2->Z2_DTBAS08
			SZ2->Z2_DTBAS08 := SZ2->Z2_DTBAS09
			SZ2->Z2_DTBAS09 := SZ2->Z2_DTBAS10
			SZ2->Z2_DTBAS10 := SZ2->Z2_DTBAS11
			SZ2->Z2_DTBAS11 := SZ2->Z2_DTBAS12
			SZ2->Z2_DTBAS12 := MV_PAR15
			SZ2->Z2_TXCAM01 := SZ2->Z2_TXCAM02
			SZ2->Z2_TXCAM02 := SZ2->Z2_TXCAM03
			SZ2->Z2_TXCAM03 := SZ2->Z2_TXCAM04
			SZ2->Z2_TXCAM04 := SZ2->Z2_TXCAM05
			SZ2->Z2_TXCAM05 := SZ2->Z2_TXCAM06
			SZ2->Z2_TXCAM06 := SZ2->Z2_TXCAM07
			SZ2->Z2_TXCAM07 := SZ2->Z2_TXCAM08
			SZ2->Z2_TXCAM08 := SZ2->Z2_TXCAM09
			SZ2->Z2_TXCAM09 := SZ2->Z2_TXCAM10
			SZ2->Z2_TXCAM10 := SZ2->Z2_TXCAM11
			SZ2->Z2_TXCAM11 := SZ2->Z2_TXCAM12
			SZ2->Z2_TXCAM12 := MV_PAR18			
			MsUnlock()
		Endif
		
		If Mv_par05 == 1
			AtuPed()
		Endif
		
		_lParar    := .F.
		dbSelectArea("SZ2")
		dbSkip()
	EndDo
Endif

Return


Static Function AtuPed()

_cPed := "("
For Ax:= 1 To Len(MV_PAR16)
	If Substr(MV_PAR16,AX,1) != "*"
//		If AX == 1		
		If _cPed == "("
		   _cPed += "'"+Substr(MV_PAR16,AX,1)
		Else
   		   _cPed += "','"+Substr(MV_PAR16,AX,1)
  		Endif
    Endif
Next AX         
            
_cPed += "')"              

_cQ := " SELECT * FROM SC6010 C6 "
_cQ += " WHERE C6.D_E_L_E_T_ = '' AND C6_BLQ = '' AND C6_QTDVEN > C6_QTDENT "
_cQ += " AND C6_CLI = '"+SZ2->Z2_CLIENTE+"' AND C6_LOJA = '"+SZ2->Z2_LOJA+"' AND C6_PRODUTO = '"+SZ2->Z2_PRODUTO+"' "
_cQ += " AND C6_CPROCLI = '"+MV_PAR04+"' AND C6_ENTREG BETWEEN '"+DTOS(MV_PAR08)+"' AND '"+DTOS(MV_PAR09)+"' "
_cQ += " AND C6_PEDAMOS IN "+_cPed+" "

TCQUERY _cQ New ALIAS "ZC6"

ZC6->(dbGotop())

ProcRegua(ZC6->(U_CONTREG()))

While !Eof()
	
	IncProc()
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek(xFilial("SC5")+ZC6->C6_NUM)
		If SC5->C5_EMISSAO < MV_PAR10 .Or. SC5->C5_EMISSAO > MV_PAR11
			dbSelectArea("ZC6")
			dbSkip()
			Loop
		Endif
	Endif
/*	
	If MV_PAR16 == 1
		_cPed := "N"
	ElseIf MV_PAR16 == 2
		_cPed := "A"
	ElseIf MV_PAR16 == 3
		_cPed := "Z"
	ElseIf MV_PAR16 == 4
		_cPed := "D"
	Else
		_cPed := " /3/D/N/A/Z"
	Endif
	
	If !ZC6->C6_PEDAMOS $ _cPed
		dbSelectArea("ZC6")
		dbSkip()
		Loop
	Endif
*/	
	SC6->(dbSetOrder(1))
	If SC6->(dbSeek(xFilial("SC6")+ZC6->C6_NUM + ZC6->C6_ITEM + ZC6->C6_PRODUTO))
		dbSelectArea("SC6")
		RecLock("SC6",.F.)
//		SC6->C6_PRCVEN := _nPrNovo
		SC6->C6_PRCVEN := _nPrNov1
//		SC6->C6_PRUNIT := _nPrNovo
		SC6->C6_PRUNIT := _nPrNov1
//		SC6->C6_VALOR  := Round((SC6->C6_QTDVEN * _nPrNovo),2)
		SC6->C6_VALOR  := Round((SC6->C6_QTDVEN * _nPrNov1),2)
		SC6->C6_CHASSI := "CAL "+DTOC(MV_PAR14)+" "+STR(MV_PAR12,2)
		MsUnlock()
		
		dbSelectArea("SC5")
		dbSetOrder(1)
		If dbSeek(xFilial("SC5")+SC6->C6_NUM)
			dbSelectArea("EE7")
			dbSetOrder(1)
			If dbSeek(xFilial("EE7") + SC5->C5_PEDEXP)
				dbSelectArea("EE8")
				dbOrderNickName("INDEE81")
				If dbSeek(xFilial("EE8") + SC5->C5_PEDEXP + SC6->C6_ITEM )
					dbSelectArea("EE8")
					RecLock("EE8",.F.)
//					EE8->EE8_PRECO  := _nPrNovo
					EE8->EE8_PRECO  := _nPrNov1
//					EE8->EE8_PRECOI := _nPrNovo
					EE8->EE8_PRECOI := _nPrNov1
//					EE8->EE8_PRCINC := Round(( (EE8->EE8_SLDINI) * _nPrNovo ),2)
					EE8->EE8_PRCINC := Round(( (EE8->EE8_SLDINI) * _nPrNov1 ),2)
//					EE8->EE8_PRCTOT := Round(( (EE8->EE8_SLDINI) * _nPrNovo ),2)
					EE8->EE8_PRCTOT := Round(( (EE8->EE8_SLDINI) * _nPrNov1 ),2)
					MsUnlock()
				Endif
			Endif
		Endif
		
		dbSelectArea("SC9")
		dbSetorder(1)
		If dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
			_cChavSc9 := SC9->C9_PEDIDO + SC9->C9_ITEM
			
			While !Eof() .And. _cChavSc9 == SC9->C9_PEDIDO + SC9->C9_ITEM
				
				If !Vazio(SC9->C9_NFISCAL)
					dbSelectArea("SC9")
					dbSkip()
					Loop
				Endif
				
				dbSelectArea("SC9")
				RecLock("SC9",.F.)
//				SC9->C9_PRCVEN :=  _nPrNovo
				SC9->C9_PRCVEN :=  _nPrNov1
				MsUnlock()
				
				dbSelectArea("SC9")
				dbSkip()
			EndDo
		Endif
	Endif
	
	dbSelectArea("ZC6")
	dbSkip()
EndDo

dbSelectArea("ZC6")
dbCloseArea("ZC6")

Return


Static Function DescPreco(_lFim)

dbSeLectArea("SZ2")
dbSetOrder(4)    // Produto + Cliente + Loja
//If dbSeek(xFilial("SZ2")+MV_PAR04+MV_PAR01+MV_PAR02)
If dbSeek(xFilial("SZ2")+MV_PAR04+MV_PAR01)
	
	_nRec := LastRec()
	ProcRegua(_nRec)
	
	_cChavSZ2 := SZ2->Z2_CODCLI + SZ2->Z2_CLIENTE
	
	While !Eof() .And. (_cChavSZ2 == SZ2->Z2_CODCLI+SZ2->Z2_CLIENTE) .And. (SZ2->Z2_LOJA <= MV_PAR03)
		
		If _lFim
			Alert("cancelado pelo Usuario!!")
			Return
		EndIf
		
		IncProc()
		
		If SZ2->Z2_LOJA < MV_PAR02
			dbSelecTarea("SZ2")
			dbSkip()
			Loop
		Endif
		
		If SZ2->Z2_LOJA $ MV_PAR17
			dbSelectarea("SZ2")
			dbSkip()
			Loop
		Endif
		
		_nFator := MV_PAR12
		
		If Empty(SZ2->Z2_PRECO01)
			dbSelecTarea("SZ2")
			dbSkip()
			Loop
		Endif
		
		For I:=2 To 12
			_nValor2 :=  &("SZ2->Z2_PRECO"+StrZero(i-1,2))
			_dData   := "SZ2->Z2_DTREF"+strZero(I,2)
			If &_dData == MV_PAR14
				_nPreco := "SZ2->Z2_PRECO"+strZero(I,2)
				_nTaxa  := "SZ2->Z2_TXCAM"+strZero(I,2)
				_dDtRef := "SZ2->Z2_DTREF"+strZero(I,2)
				_dDtBas := "SZ2->Z2_DTBAS"+strZero(I,2)
				dbSelectArea("SZ2")
				RecLock("SZ2",.F.)
				&_nPreco  := 0
				&_nTaxa   := 0
				&_dDtRef  := CTOD("  /  /  ")
				&_dDtBas  := CTOD("  /  /  ")
				MsUnlock()
				I:= 12
			Endif
		Next I
		
		If Mv_par05 == 1
			DescPed()
		Endif
		
		dbSelectArea("SZ2")
		dbSkip()
	EndDo
Endif

Return


Static Function DescPed()

_cPed := "("
For Ax:= 1 To Len(MV_PAR16)
	If Substr(MV_PAR16,AX,1) != "*"
//		If AX == 1		
		If _cPed == "("		
		   _cPed += "'"+Substr(MV_PAR16,AX,1)
		Else
   		   _cPed += "','"+Substr(MV_PAR16,AX,1)
  		Endif
    Endif
Next AX         
            
_cPed += "')"              

_cQ := " SELECT * FROM SC6010 C6 "
_cQ += " WHERE C6.D_E_L_E_T_ = '' AND C6_BLQ = '' AND C6_QTDVEN > C6_QTDENT "
_cQ += " AND C6_CLI = '"+SZ2->Z2_CLIENTE+"' AND C6_LOJA = '"+SZ2->Z2_LOJA+"' AND C6_PRODUTO = '"+SZ2->Z2_PRODUTO+"' "
_cQ += " AND C6_CPROCLI = '"+MV_PAR04+"' AND C6_ENTREG BETWEEN '"+DTOS(MV_PAR08)+"' AND '"+DTOS(MV_PAR09)+"' "
_cQ += " AND C6_PEDAMOS IN "+_cPed+" "

TCQUERY _cQ New ALIAS "ZC6"

ZC6->(dbGotop())

ProcRegua(ZC6->(U_CONTREG()))

While !Eof()
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek(xFilial("SC5")+ZC6->C6_NUM)
		If SC5->C5_EMISSAO < MV_PAR10 .Or. SC5->C5_EMISSAO > MV_PAR11
			dbSelectArea("ZC6")
			dbSkip()
			Loop
		Endif
	Endif
	
	SC6->(dbSetOrder(1))
	If SC6->(dbSeek(xFilial("SC6")+ZC6->C6_NUM + ZC6->C6_ITEM + ZC6->C6_PRODUTO))
		dbSelectArea("SC6")
		RecLock("SC6",.F.)
		SC6->C6_PRCVEN := _nValor2
		SC6->C6_PRUNIT := _nValor2
		SC6->C6_VALOR  := Round((SC6->C6_QTDVEN * SC6->C6_PRCVEN),2)
		SC6->C6_CHASSI := "DES "+DTOC(MV_PAR14)+" "+STR(_NFATOR,2)
		MsUnlock()
		
		dbSelectArea("SC5")
		dbSetOrder(1)
		If dbSeek(xFilial("SC5")+SC6->C6_NUM)
			dbSelectArea("EE7")
			dbSetOrder(1)
			If dbSeek(xFilial("EE7") + SC5->C5_PEDEXP)
				dbSelectArea("EE8")
				dbOrderNickName("INDEE81")
				If dbSeek(xFilial("EE8") + SC5->C5_PEDEXP + SC6->C6_ITEM )
					dbSelectArea("EE8")
					RecLock("EE8",.F.)
					EE8->EE8_PRECO  := _nValor2
					EE8->EE8_PRECOI := _nValor2
					EE8->EE8_PRCINC := Round(( (EE8->EE8_SLDINI) * _nValor2 ),2)
					EE8->EE8_PRCTOT := Round(( (EE8->EE8_SLDINI) * _nValor2 ),2)
					MsUnlock()
				Endif
			Endif
		Endif
		
		dbSelectArea("SC9")
		dbSetorder(1)
		If dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
			_cChavSc9 := SC9->C9_PEDIDO + SC9->C9_ITEM
			
			While !Eof() .And. _cChavSc9 == SC9->C9_PEDIDO + SC9->C9_ITEM
				
				If !Vazio(SC9->C9_NFISCAL)
					dbSelectArea("SC9")
					dbSkip()
					Loop
				Endif
				
				dbSelectArea("SC9")
				RecLock("SC9",.F.)
				SC9->C9_PRCVEN := _nValor2
				MsUnlock()
				
				dbSelectArea("SC9")
				dbSkip()
			EndDo
		Endif
	Endif
	
	dbSelectArea("ZC6")
	dbSkip()
EndDo

Return