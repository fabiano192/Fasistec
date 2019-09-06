#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CR0082    ºAutor  ³Fabiano da Silva  º   Data ³  18/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualizacao de preco (CAT)			                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CR0082()

	LOCAL oDlg := NIL

	PRIVATE cTitulo    	:= "Reajuste de Preco - Tabela"

	_nOpc := 0

	DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
	@ 004,010 TO 060,157 LABEL "" OF oDlg PIXEL

	@ 010,017 SAY "Esta rotina tem por objetivo importar a Tabela de Preço" 	OF oDlg PIXEL Size 150,010
	@ 050,017 SAY "Programa CR0082.PRW                           		" 	OF oDlg PIXEL Size 150,010

	@ 15,165 BUTTON "OK" 		 SIZE 036,012 ACTION (_nOpc := 1,oDlg:End()) 	OF oDlg PIXEL
	@ 40,165 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	If _nOpc = 1

		Private _lParar    := .F.
		Private _lFim      := .F.
		Private _cMsg01    := ''
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| AtuPreco(@_lFim) }
		Private _cTitulo01 := 'Processando'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

		If !_lParar
			MsgInfo("Preco Atualizado com Sucesso","Informacao","info")
		Else
			MsgInfo("Preco Nao Foi Atualizado ","Informacao","info")
		Endif
	Endif

Return(Nil)



Static Function AtuPreco(_lFim)

	_cArqDbf := "PRECO.DBF"
	_cArqInd := "PRECO"

	_cIndTRB := "PEDIDO"

	dbUseArea(.T.,,_cArqDBF,"TRB",.F.,.F.)

	dbSelectArea("TRB")
	IndRegua("TRB",_cArqInd,_cIndTRB,,,"Criando Trabalho...")

	SZ2->(dbSetOrder(10))
	SZ2->(dbGotop())

	ProcRegua(TRB->(U_CONTREG()))

	While !SZ2->(EOF())

		IncProc()

		If _lFim
			Alert("Cancelado pelo Usuario!!")
			Return
		EndIf

		If SZ2->Z2_CLIENTE != "000017"
			SZ2->(dbSkip())
			Loop
		Endif

		If !SZ2->Z2_LOJA $ '01|02'
			SZ2->(dbSkip())
			Loop
		Endif

//		If SZ2->Z2_ATIVO == "2"
//			SZ2->(dbSkip())
//			Loop
//		Endif

		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+SZ2->Z2_PRODUTO))

		If TRB->(msSeeK(SZ2->Z2_PEDCLI))

//			If Alltrim(SZ2->Z2_REVISAO) <> Alltrim(TRB->REVISAO)
//				SZ2->(dbSkip())
//				Loop
//			Endif
                                  
			If !Empty(TRB->STATUS)
				SZ2->(dbSkip())
				Loop			
			Endif
			
			_dDtRef1		:= TRB->DTREF
			_dDtBas1		:= TRB->DTBASE
			_lParar			:= .F.
			_lAtualizado	:= .F.
			For I:=2 To 12

				_nValor1 :=  &("SZ2->Z2_PRECO"+StrZero(i,2))
				_dData   := "SZ2->Z2_DTREF"+strZero(I,2)
				_dDtBase := &("SZ2->Z2_DTBAS"+strZero(I-1,2))

				If &_dData == _dDtRef1
					Alert("Já existe Preço Na Data Informada, Descalcule ou Altere a Data: "+Alltrim(SZ2->Z2_PEDCLI))
					_lParar := .T.
					Exit
				Endif

				If Empty(_nValor1)
					dbSelectArea("SZ2")
					RecLock("SZ2",.F.)
					_nPreco   := "SZ2->Z2_PRECO"+strZero(I,2)
					_dDtRef   := "SZ2->Z2_DTREF"+strZero(I,2)
					_dDtBas   := "SZ2->Z2_DTBAS"+strZero(I,2)
					&_nPreco  := TRB->PRECO
					&_dDtRef  := _dDtRef1
					&_dDtBas  := _dDtBas1
					SZ2->Z2_ATIVO := "1"
					MsUnlock()
					I:= 12

					TRB->(RecLock("TRB",.F.))
					TRB->STATUS  := "OK"
					TRB->(MsUnlock())

					_lAtualizado := .T.
				Endif
			Next I

			If _lparar
				SZ2->(dbSkip())
				Loop
			Endif

			If !_lAtualizado
				If _nValor1 > 0
					//Alert("Cadastrar novo Produto X Cliente: "+Alltrim(TRB->PASY)+" - Loja: "+Alltrim(TRB->LOJA))

					dbSelectArea("SZ2")
					Reclock("SZ2",.F.)
					SZ2->Z2_ATIVO	:= "2"
					SZ2->(MsUnlock())

					_cUM   := SZ2->Z2_UM
					_cDesc := SZ2->Z2_DESCCLI
					_cRev  := SZ2->Z2_REVISAO
					_cPed  := SZ2->Z2_PEDCLI
					_cTES  := SZ2->Z2_TES
					_nLote := SZ2->Z2_LOTEMIN
					_cMen  := SZ2->Z2_MENPAD
					_nDNP  := SZ2->Z2_DNP
					_cProd := SZ2->Z2_PRODUTO

					_aAliSZ2 := SZ2->(GetArea())

					SZ2->(RecLock("SZ2",.T.))
					SZ2->Z2_CLIENTE	:= TRB->CLIENTE
					SZ2->Z2_LOJA	:= TRB->LOJA
					SZ2->Z2_PRODUTO	:= _cProd 
					SZ2->Z2_CODCLI	:= TRB->PN
					SZ2->Z2_UM		:= _cUM
					SZ2->Z2_DESCCLI	:= _cDesc
					SZ2->Z2_REVISAO	:= _cRev
					SZ2->Z2_PEDCLI	:= _cPed
					SZ2->Z2_TES		:= _cTES
					SZ2->Z2_LOTEMIN	:= _nLote
					SZ2->Z2_MENPAD	:= _cMen
					SZ2->Z2_DNP		:= _nDNP
					SZ2->Z2_PRECO01	:= TRB->PRECO
					SZ2->Z2_DTREF01	:= _dDtRef1
					SZ2->Z2_DTBAS01	:= _dDtBas1
					SZ2->Z2_ATIVO	:= "1"
					SZ2->(MsUnlock())

					RestArea(_aAliSZ2)

					TRB->(RecLock("TRB",.F.))
					TRB->STATUS  := "OK"
					TRB->(MsUnlock())

				Endif
			Endif


		Else
			SZ2->(Reclock("SZ2",.F.))
			SZ2->Z2_ATIVO	:= "2"
			SZ2->(MsUnlock())

		Endif

		_lParar    := .F.

		SZ2->(dbSkip())
	EndDo


	TRB->(dbCloseArea())

Return


Static Function AtuPed() //Não utilizado

	_cQ := " SELECT * FROM SC6010 C6 "
	_cQ += " WHERE C6.D_E_L_E_T_ = '' AND C6_BLQ = '' AND C6_QTDVEN > C6_QTDENT "
	_cQ += " AND C6_CLI = '"+SZ2->Z2_CLIENTE+"' AND C6_LOJA = '"+SZ2->Z2_LOJA+"' AND C6_PRODUTO = '"+SZ2->Z2_PRODUTO+"' "
	//	_cQ += " AND C6_PRODUTO = '"+TRB->PASY+"' "//AND C6_PEDCLI = '"+TRB->PO+"' "
	_cQ += " AND C6_PEDAMOS IN ('N','Z','M','I') "

	TCQUERY _cQ New ALIAS "ZC6"

	ZC6->(dbGotop())

	While !Eof()

		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek(xFilial("SC5")+ZC6->C6_NUM)

		SC6->(dbSetOrder(1))
		If SC6->(dbSeek(xFilial("SC6")+ZC6->C6_NUM + ZC6->C6_ITEM + ZC6->C6_PRODUTO))

			_nPrcVen := SC6->C6_PRCVEN

			dbSelectArea("SC6")
			RecLock("SC6",.F.)
			SC6->C6_PRCVEN := TRB->PRECO
			SC6->C6_PRUNIT := TRB->PRECO
			SC6->C6_VALOR  := Round((SC6->C6_QTDVEN * (TRB->PRECO)),2)
			SC6->C6_CHASSI := "CAL "+DTOC(_dDtRef1)
			MsUnlock()

			TRB->(RecLock("TRB",.F.))
			TRB->STATU2  := "OK"
			TRB->(MsUnlock())

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
					SC9->C9_PRCVEN :=  TRB->PRECO
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
