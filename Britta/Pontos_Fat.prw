#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

#define DS_MODALFRAME   128

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PONTOS   ³ Autor ³ Alexandro da Silva    ³ Data ³ 07/08/12 ³±±
±±ðÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada no Faturamento                            ³±±
±±ðÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Faturas a Pagar                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SF2520E()

	_aAliOri := GETAREA()
	_aAliSF2 := SF2->(GETAREA())
	_aAliSD2 := SD2->(GETAREA())

	_cMotivo := Space(100)

	DEFINE MsDialog oDlg From 150,001 To 270,450 Title OemToAnsi("Motivo do Cancelamento") Pixel Style DS_MODALFRAME // Cria Dialog sem o botðo de Fecha

	@ 02,10 TO 040,220
	@ 10,18 SAY "Informar o Motivo: "     SIZE 160,7
	@ 18,18 GET _cMotivo         WHEN .T. Valid (!EMPTY(_cMotivo) .And. Len(alltrim(_cMotivo))> 20)    SIZE 180,7

	@ 45,188 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())

	oDlg:lEscClose := .F.

	ACTIVATE MSDIALOG oDlg CENTERED

	SD2->(dbSetorder(3))
	If SD2->(dbSeek(xFilial("SD2")+ SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA))

		_cChavSD2 :=  SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA

		While SD2->(!Eof()) .And. _cChavSD2 ==  SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA

			SZJ->(dbSetorder(1))
			If SZJ->(!dbSeek(xFilial("SZJ")+ SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_TIPO+SD2->D2_ITEM))
				SZJ->(RecLock("SZJ",.T.))
				SZJ->ZJ_FILIAL := xFilial("SZJ")
				SZJ->ZJ_DOC    := SF2->F2_DOC
				SZJ->ZJ_SERIE  := SF2->F2_SERIE
				SZJ->ZJ_CLIENTE:= SF2->F2_CLIENTE
				SZJ->ZJ_LOJA   := SF2->F2_LOJA
				SZJ->ZJ_TIPO   := SF2->F2_TIPO
				SZJ->ZJ_MOTIVO := _cMotivo
				SZJ->ZJ_DTCANC := Date()
				SZJ->ZJ_HORA   := Left(Time(),5)
				SZJ->ZJ_USUARIO:= Substr(cUsuario,7,15)
				SZJ->ZJ_DTEMIS := SF2->F2_EMISSAO
				SZJ->ZJ_HORAEMI:= SF2->F2_HORA
				SZJ->ZJ_VEND1  := SF2->F2_VEND1
				SZJ->ZJ_VALMERC:= SF2->F2_VALMERC
				SZJ->ZJ_VALBRUT:= SF2->F2_VALBRUT
				SZJ->ZJ_VALFRET:= SF2->F2_FRETE
				SZJ->ZJ_ITEM   := SD2->D2_ITEM
				SZJ->ZJ_PRODUTO:= SD2->D2_COD
				SZJ->ZJ_TES    := SD2->D2_TES
				SZJ->ZJ_PRCVEN := SD2->D2_PRCVEN
				SZJ->ZJ_QTDITEM:= SD2->D2_QUANT
				SZJ->ZJ_TOTITEM:= SD2->D2_TOTAL
				SZJ->ZJ_PEDIDO := SD2->D2_PEDIDO
				SZJ->(MsUnlock())
			Else
				SZJ->(RecLock("SZJ",.F.))
				SZJ->(dbDelete())
				SZJ->(MsUnlock())
			Endif

			SD2->(dbSkip())
		EndDo
	Endif

	RestArea(_aAliSD2)
	RestArea(_aAliSF2)
	RestArea(_aAliOri)

	U_GRLOG(Procname(),cModulo,__CUSERID,Ddatabase,Time(),cEmpAnt,cFilAnt)

Return



User Function M410ALOK()

	Local lRetorno := .T.

	If(SM0->M0_CODIGO $ "04/13/14/21/50")

		If SC5->C5_ALTQTD == "S"
			MsgAlert("ATENCAO, NAO AUMENTAR A QUANTIDADE DO PEDIDO:"+Chr(13)+Chr(10)+SC5->C5_NUM+" - "+ALLTRIM(SC5->C5_NOMCLI))
		EndIf
	EndIf

	If ALTERA
		U_GRLOG(Procname(),cModulo,__CUSERID,Ddatabase,Time(),cEmpAnt,cFilAnt)
	EndIf

Return lRetorno




User Function M460FRET()

	_aAliOri := GetArea()
	_aAliSC5 := SC5->(GetArea())
	_aAliSC6 := SC6->(GetArea())
	_aAliSC9 := SC9->(GetArea())
	_aAliSZA := SZA->(GetArea())

	_nFrete := 0

	SZA->(dbSetOrder(2))
	If SZA->(MsSeek(SC9->C9_FILIAL + SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_PDOC))
		If SZA->ZA_VLRFRET > 0
			_nFrete := SC9->C9_QTDLIB *  SZA->ZA_VLRFRET
		Endif
	Endif

	RestArea(_aAliSC5)
	RestArea(_aAliSC6)
	RestArea(_aAliSC9)
	RestArea(_aAliSZA)
	RestArea(_aAliOri)

Return(_nFrete)



User Function MA410DEL()

	Local _cCodBlq	:= '02'
	Local _cPedido	:= M->C5_NUM

	SCR->(dbSetOrder(1))
	If SCR->(dbSeek(xFilial("SCR")+ _cCodBlq + _cPedido ))

		//		_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM
		_cChavSCR := SCR->CR_TIPO + Left(SCR->CR_NUM,6)

		ZAH->(dbSetOrder(1))
		If ZAH->(dbSeek(SCR->CR_FILIAL + _cChavSCR  ))

			_cCq := " DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_FILIAL = '"+SCR->CR_FILIAL+"' AND LEFT(ZAH_NUM,6) = '"+Left(SCR->CR_NUM,6)+"' AND ZAH_TIPO = '"+SCR->CR_TIPO+"' "
			TcSqlExec(_cCq)

		Endif

		While SCR->(!Eof())	.And. _cChavSCR == SCR->CR_TIPO + Left(SCR->CR_NUM,6)

			SCR->(RecLock("SCR",.F.))
			SCR->(dbDelete())
			SCR->(MsUnlock())

			SCR->(dbSkip())
		EndDo
	Endif

Return(Nil)

User Function M460FIL()

	_aAliOri := GetArea()

	_cFiltro:= " C9_BLOQUEI = ' ' "

	RestArea(_aAliOri)

Return(_cFiltro)


User Function MTASF2()

	_aAliOri := GetArea()

//If SC5->C5_FRETE > 0
	If SF2->F2_FRETE > 0

		_nAliPIS := GETMV("MV_TXPIS")
		_nAliCOF := GETMV("MV_TXCOFIN")

		SF2->(RecLock("SF2",.F.))

		// ALTERADO EM 10/10/19
		//SF2->F2_FRETE  := SC5->C5_FRETE
		//SF2->F2_VALBRUT:= SF2->F2_VALMERC + SF2->F2_FRETE
		//SF2->F2_VALFAT := SF2->F2_VALMERC + SF2->F2_FRETE
		// ALTERADO EM 10/10/19

		If SF2->F2_BASIMP5 <> 0
			If cEmpAnt == "50" .And. SF2->F2_EMISSAO >= CTOD("01/04/17")
				_nBase := SF2->F2_VALMERC + SF2->F2_FRETE - SF2->F2_VALICM
				_nCof  := Round((_nBase * (_nAliCof / 100)),2)
				_nPis  := Round((_nBase * (_nAliPis / 100)),2)
			ElseIf cEmpAnt == "04" .And. SF2->F2_EMISSAO >= CTOD("01/08/17")
				_nBase := SF2->F2_VALMERC + SF2->F2_FRETE - SF2->F2_VALICM
				_nCof  := Round((_nBase * (_nAliCof / 100)),2)
				_nPis  := Round((_nBase * (_nAliPis / 100)),2)
			ElseIf cEmpAnt == "13" .And. SF2->F2_EMISSAO >= CTOD("01/08/17")
				_nBase := SF2->F2_VALMERC + SF2->F2_FRETE - SF2->F2_VALICM
				_nCof  := Round((_nBase * (_nAliCof / 100)),2)
				_nPis  := Round((_nBase * (_nAliPis / 100)),2)
			Else
				_nBase := SF2->F2_VALMERC + SF2->F2_FRETE
				_nCof  := Round((_nBase * (_nAliCof / 100)),2)
				_nPis  := Round((_nBase * (_nAliPis / 100)),2)
			Endif

			SF2->F2_BASIMP5 := _nBase
			SF2->F2_BASIMP6 := _nBase
			SF2->F2_VALIMP5 := _nCof
			SF2->F2_VALIMP6 := _nPis
		Endif

		SF2->(MsUnLock())
	Endif

	RestArea(_aAliOri)


User Function Msd2460()

	_aAliORI := GetArea()
	_aAliDA0 := DA0->(GetArea())
	_aAliDA1 := DA1->(GetArea())
	_aAliSA1 := SA1->(GetArea())
	_aAliSC5 := SC5->(GetArea())
	_aAliSC9 := SC9->(GetArea())
	_aAliSF4 := SF4->(GetArea())
	_aAliSZ2 := SZ2->(GetArea())
	_aAliSZA := SZA->(GetArea())

	SD2->D2_PDFRUM3:= Posicione("SA1",1,xfilial("SA1")+sd2->(d2_cliente+d2_loja),"a1_pdfrem3")
	SD2->D2_PDFRUTL:= Round(sd2->d2_pdfrUM3/posicione("SB1",1,xfilial("SB1")+sd2->d2_cod,"b1_conv"),2)

	If cEmpAnt+cFilAnt  $ "5001/5002/5006/5007" // ALTERADO EM 27/02/20 INCLUIDO 5006 E 5007
		SD2->D2_PDFRETT:= SD2->D2_QUANT * SD2->D2_PDFRUM3
	Else
		SD2->D2_PDFRETT:= SD2->(D2_QUANT*D2_PDFRUTL)
	Endif

	SD2->D2_XOPESAI:= Posicione("SC5",1,xfilial("SC5")+sd2->d2_pedido,'c5_xopesai')

	If sc9->(c9_nfiscal+c9_serienf+c9_pedido+c9_item)==sd2->(d2_doc+d2_serie+d2_pedido+d2_itempv)
		If !empty(sc9->c9_pdoc)
			sza->(dbsetorder(1))
			If sza->(dbseek(xfilial()+sc9->c9_pdoc,.f.).and.reclock(alias(),.f.))
				sza->za_nota :=sd2->d2_doc
				sza->za_serie:=sd2->d2_serie
				sza->(msunlock())
				sd2->d2_pdoc:=sza->za_num
			Endif
		Endif
	Endif

	SZ2->(dbSetOrder(4))
	If SZ2->(dbSeek(SD2->D2_FILIAL + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD))

		_nPreco := 	SZ2->Z2_PRCGER

		SD2->(RecLock("SD2",.F.))
		SD2->D2_YPRG := _nPreco
		If SD2->(FieldPos("D2_YFREGER")) > 0
			SD2->D2_YFREGER := SZ2->Z2_FRETGER
		Endif

		SD2->(MsUnLock())
	Endif

	If cEmpAnt == "04" .And. SD2->D2_CLIENTE == "010798" .And. SC5->C5_FRETE > 0
		SF4->(dbSetOrder(1))
		If SF4->(MsSeek(xFilial("SF4")+SD2->D2_TES))
			If SF4->F4_DUPLIC == "S"
				_lDup := .T.
			Else
				_lDup := .F.
			Endif

			SD2->(RecLock("SD2",.F.))
			If _lDup
				SD2->D2_VALFRE := SC5->C5_FRETE
				SD2->D2_BASEICM:= SD2->D2_TOTAL + SD2->D2_VALFRE
				SD2->D2_VALICM := ROUND(SD2->D2_BASEICM * (SD2->D2_PICM / 100),2)
				If !Empty(SD2->D2_BASFECP)
					SD2->D2_BASFECP:= SD2->D2_BASEICM
					SD2->D2_VALFECP:= ROUND(SD2->D2_BASFECP * (SD2->D2_ALQFECP / 100),2)
				Endif
			Else
				SD2->D2_VALFRE := 0
				SD2->D2_VALBRUT:= SD2->D2_TOTAL
			Endif
			SD2->(MsUnlock())
		Endif
	Else
		//If !EMPTY(SC9->C9_PDOC) .AND. SC6->C6_VLRFRET > 0
		If SC6->C6_VLRFRET > 0
			SF4->(dbSetOrder(1))
			If SF4->(MsSeek(xFilial("SF4")+SD2->D2_TES))

				_NVALFRE := ROUND((SC9->C9_QTDLIB * SC6->C6_VLRFRET),2)
				_nBASE   := ROUND((SD2->D2_TOTAL + _NVALFRE),2)

				If SF4->F4_BASEICM > 0
					_nBASE :=  ROUND((SD2->D2_TOTAL + _NVALFRE),2) * (SF4->F4_BASEICM /100)
				Endif

				SD2->(RecLock("SD2",.F.))
				SD2->D2_VALFRE := _NVALFRE
				SD2->D2_BASEICM:= _nBase
				SD2->D2_VALBRUT:= ROUND((SD2->D2_TOTAL + _NVALFRE),2)
				SD2->D2_VALICM := ROUND(SD2->D2_BASEICM * (SD2->D2_PICM / 100),2)

				If !Empty(SD2->D2_BASFECP)
					SD2->D2_BASFECP:= SD2->D2_BASEICM
					SD2->D2_VALFECP:= ROUND(SD2->D2_BASFECP * (SD2->D2_ALQFECP / 100),2)
				Endif

				_nAliPIS := GETMV("MV_TXPIS")
				_nAliCOF := GETMV("MV_TXCOFIN")

				If SF4->F4_PISCOF == "4"
					_nBase   := 0
					_nCof    := 0
					_nPis    := 0
					_nAliCof := 0
					_nAliPis := 0
				Else
					If cEmpAnt == "50" .And. SD2->D2_EMISSAO >= CTOD("01/04/17")
						_nBase := SD2->D2_TOTAL + SD2->D2_VALFRE - SD2->D2_VALICM
						_nCof  := Round((_nBase * (_nAliCof / 100)),2)
						_nPis  := Round((_nBase * (_nAliPis / 100)),2)
					ElseIf cEmpAnt == "04" .And. SD2->D2_EMISSAO >= CTOD("01/08/17")
						_nBase := SD2->D2_TOTAL + SD2->D2_VALFRE - SD2->D2_VALICM
						_nCof  := Round((_nBase * (_nAliCof / 100)),2)
						_nPis  := Round((_nBase * (_nAliPis / 100)),2)
					ElseIf cEmpAnt == "13" .And. SD2->D2_EMISSAO >= CTOD("01/08/17")
						_nBase := SD2->D2_TOTAL + SD2->D2_VALFRE - SD2->D2_VALICM
						_nCof  := Round((_nBase * (_nAliCof / 100)),2)
						_nPis  := Round((_nBase * (_nAliPis / 100)),2)
					Else
						_nBase := SD2->D2_TOTAL + SD2->D2_VALFRE
						_nCof  := Round((_nBase * (_nAliCof / 100)),2)
						_nPis  := Round((_nBase * (_nAliPis / 100)),2)
					Endif

					SD2->D2_BASIMP5 := _nBase
					SD2->D2_BASIMP6 := _nBase
					SD2->D2_VALIMP5 := _nCof
					SD2->D2_VALIMP6 := _nPis
					SD2->D2_ALQIMP5 := _nAliCof
					SD2->D2_ALQIMP6 := _nAliPis
				Endif

				SD2->(MsUnlock())
			Endif
		Endif
	Endif

	RestArea(_aAliDA0)
	RestArea(_aAliDA1)
	RestArea(_aAliSA1)
	RestArea(_aAliSC5)
	RestArea(_aAliSC9)
	RestArea(_aAliSF4)
	RestArea(_aAliSZ2)
	RestArea(_aAliSZA)
	RestArea(_aAliORI)

Return


User Function M030INC()

	Local nOpcao := ParamIXB

	If nOpcao == 3
		RETURN(.T.)
	Endif

	_cQ:= " SELECT MAX(CTD_ITEM) AS ULTCTD FROM CTD500 WHERE D_E_L_E_T_ = ''  AND LEFT(CTD_ITEM,4) = 'AGRC' "

	TCQUERY _cQ NEW ALIAS "ZZ2"

	If Empty(ZZ2->ULTCTD)
		_cSeqCTD := "00001"
	Else
		_cSeqCTD := SOMA1(SUBSTR(ZZ2->ULTCTD,5,5))
	Endif

	_cCODCTD := "AGRC"+ _cSeqCTD

	ZZ2->(dbCloseArea())

	CTD->(dbOrderNickName( "INDCTD1" ))
	If CTD->(!MsSeek(xFilial("CTD") + "C"+ M->A1_COD + M->A1_LOJA))
		CTD->(RecLock("CTD",.T.))
		CTD->CTD_FILIAL := XFILIAL("CTD")
		CTD->CTD_ITEM   := _cCODCTD
		CTD->CTD_CLASSE := "2"
		CTD->CTD_DESC01 := M->A1_COD+"-"+ M->A1_LOJA+" - "+ M->A1_NOME
		CTD->CTD_BLOQ   := "2"
		CTD->CTD_DTEXIS := CTOD("01/01/19")
		CTD->CTD_ITLP   := _cCODCTD
		CTD->CTD_CLOBRG := "2"
		CTD->CTD_ACCLVL := "1"
		CTD->CTD_YIDENT := "C" + M->A1_COD + M->A1_LOJA
		CTD->(MsUnlock())

		SA1->(RecLock("SA1",.F.))
		SA1->A1_YITEMC    := _cCODCTD
		SA1->(MsUnlock())

	Endif

Return .T.


User Function M030EXC()

	Private lret := .T.

	_aAliOri := GetArea()
	_aAliSA1 := SA1->(GetArea())
	_aAliCTH := CTH->(GetArea())
	_aAliCTD := CTD->(GetArea())

	CTH->(dbSetOrder(1))
	If CTH->(MsSeek(xFilial("CTH") + "C" + SA1->A1_COD+SA1->A1_LOJA))
		CTH->(RecLock("CTH",.F.))
		CTH->(dbDelete())
		CTH->(MsUnLock())
	Endif

	CTD->(dbOrderNickName( "INDCTD1" ))
	If CTD->(MsSeek(xFilial("CTD") + "C" + SA1->A1_COD + SA1->A1_LOJA))
		CTD->(RecLock("CTD",.F.))
		CTD->(dbDelete())
		CTD->(MsUnLock())
	Endif

	RestArea(_aAliCTD)
	RestArea(_aAliCTH)
	RestArea(_aAliSA1)
	RestArea(_aAliORI)

Return .T.


User Function M020INC()

	Local lRet		:= .T.

	_aAliORI := GetArea()
	_aAliSA2 := SA2->(GetArea())

	_cQ:= " SELECT MAX(CTD_ITEM) AS ULTCTD FROM CTD500 WHERE D_E_L_E_T_ = ''  AND LEFT(CTD_ITEM,4) = 'AGRF' "

	TCQUERY _cQ NEW ALIAS "ZZ2"

	If Empty(ZZ2->ULTCTD)
		_cSeqCTD := "00001"
	Else
		_cSeqCTD := SOMA1(SUBSTR(ZZ2->ULTCTD,5,5))
	Endif

	_cCODCTD := "AGRF"+ _cSeqCTD

	ZZ2->(dbCloseArea())

	CTD->(dbOrderNickName( "INDCTD1" ))
	If CTD->(!MsSeek(xFilial("CTD") + "F"+ M->A2_COD + M->A2_LOJA))
		CTD->(RecLock("CTD",.T.))
		CTD->CTD_FILIAL := XFILIAL("CTD")
		CTD->CTD_ITEM   := _cCODCTD
		CTD->CTD_CLASSE := "2"
		CTD->CTD_DESC01 := M->A2_COD+"-"+M->A2_LOJA+" - "+M->A2_NOME
		CTD->CTD_BLOQ   := "2"
		CTD->CTD_DTEXIS := CTOD("01/01/19")
		CTD->CTD_ITLP   := _cCODCTD
		CTD->CTD_CLOBRG := "2"
		CTD->CTD_ACCLVL := "1"
		CTD->CTD_YIDENT := "F" + M->A2_COD + M->A2_LOJA
		CTD->(MsUnlock())

		SA2->(RecLock("SA2",.F.))
		SA2->A2_YITEMC    := _cCODCTD
		SA2->(MsUnlock())

		//M->A2_YITEMC    := _cCODCTD   -- NAO ATUALIZOU

		//_oModel := FWModelActive()
		//_oModel:SetValue('MATA020M','A2_YITEMC',_cCODCTD) -- ERRO
		//_oModel:SetValue('SA2MASTER','A2_YITEMC',_cCODCTD) -- NAO ATUALIZOU
		//_oModel:LoadValue('SA2MASTER','A2_YITEMC',_cCODCTD)-- NAO ATUALIZOU


	Endif

	RestArea(_aAliSA2)
	RestArea(_aAliORI)

Return(lRet)

User Function M020EXC()

	_aAliORI := GetArea()
	_aAliCTH := CTH->(GetArea())
	_aAliCTD := CTD->(GetArea())
	_lRet    := .T.

	CTH->(dbSetOrder(1))
	If CTH->(dbSeek(xFilial("CTH")+"F" + SA2->A2_COD+SA2->A2_LOJA))
		CTH->(RecLock("CTH",.F.))
		CTH->(dbDelete())
		CTH->(MsUnLock())
	Endif

	CTD->(dbOrderNickName( "INDCTD1" ))
	If CTD->(MsSeek(xFilial("CTD") + "F" + SA2->A2_COD + SA2->A2_LOJA))
		CTD->(RecLock("CTD",.F.))
		CTD->(dbDelete())
		CTD->(MsUnLock())
	Endif

	RestArea(_aAliCTD)
	RestArea(_aAliCTH)
	RestArea(_aAliORI)

Return(_lRet)

User Function MT010INC()

	Local aRecnoSM0:= {}
	Local lStartJob:= .T.
	Private nOpc   := 3 //INCLUSAO

	_aAliOri := GetArea()
	_aAliCTH := CTH->(GetArea())
	_aAliSB1 := SB1->(GetArea())
	_aAliSBZ := SBZ->(GetArea())

	If nOpc == 3

		_cChavCTD := "P"+ SB1->B1_COD

		_cQ:= " SELECT MAX(CTD_ITEM) AS ULTCTD FROM CTD500 WHERE D_E_L_E_T_ = ''  AND LEFT(CTD_ITEM,4) = 'AGRP' "

		TCQUERY _cQ NEW ALIAS "ZZ2"

		If Empty(ZZ2->ULTCTD)
			_cSeqCTD := "00001"
		Else
			_cSeqCTD := SOMA1(SUBSTR(ZZ2->ULTCTD,5,5))
		Endif

		ZZ2->(dbCloseArea())

		_cCODCTD := "AGRP"+ _cSeqCTD

		CTD->(dbOrderNickName("INDCTD1"))
		If CTD->(!MsSeek(xFilial("CTD") + _cChavCTD))
			CTD->(RecLock("CTD",.T.))
			CTD->CTD_FILIAL := XFILIAL("CTD")
			CTD->CTD_ITEM   := _cCODCTD
			CTD->CTD_CLASSE := "2"
			CTD->CTD_DESC01 := SB1->B1_COD+"-"+Alltrim(SB1->B1_DESC)
			CTD->CTD_BLOQ   := "2"
			CTD->CTD_DTEXIS := CTOD("01/01/00")
			CTD->CTD_ITLP   := _cCODCTD
			CTD->CTD_CLOBRG := "2"
			CTD->CTD_ACCLVL := "1"
			CTD->CTD_YIDENT := _cCHAVCTD
			CTD->(MsUnlock())

			SB1->(RecLock("SB1",.F.))
			SB1->B1_YITEMC    := _cCODCTD
			SB1->(MsUnlock())
		Endif
	Endif

User Function MT010EXC()

	_aAliOri := GetArea()
	_aAliCTD := CTD->(GetArea())
	_aAliCTH := CTH->(GetArea())

	CTH->(dbSetOrder(1))
	If CTH->(dbSeek(xFilial("CTH")+SB1->B1_COD))
		CTH->(RecLock("CTH",.F.))
		CTH->(dbDelete())
		CTH->(MsUnlock())
	Endif

	CTD->(dbOrderNickName("INDCTD1"))
	If CTD->(MsSeek(xFilial("CTD") + "P" + SB1->B1_COD))
		CTD->(RecLock("CTD",.F.))
		CTD->(dbDelete())
		CTD->(MsUnlock())
	Endif

	RestArea(_aAliCTD)
	RestArea(_aAliCTH)
	RestArea(_aAliORI)

Return

User Function M070INFC()

	Local lRet		:= .T.

	If !INCLUI
		Return(lRet)
	Endif

	_aAliORI  := GetArea()
	_aAliSA6  := SA6->(GetArea())

	_cBanco   := SA6->A6_COD
	_cAgencia := SA6->A6_AGENCIA
	_cNumCon  := SA6->A6_NUMCON
	_cEmpresa := CEMPANT

	_cChavCTD := "B" + _cEmpresa + _cBANCO + _CAGENCIA + _CNUMCON

	_cQ:= " SELECT MAX(CTD_ITEM) AS ULTCTD FROM CTD500 WHERE D_E_L_E_T_ = ''  AND LEFT(CTD_ITEM,4) = 'AGRB' "

	TCQUERY _cQ NEW ALIAS "ZZ2"

	If Empty(ZZ2->ULTCTD)
		_cSeqCTD := "00001"
	Else
		_cSeqCTD := SOMA1(SUBSTR(ZZ2->ULTCTD,5,5))
	Endif

	_cCODCTD := "AGRB"+ _cSeqCTD

	ZZ2->(dbCloseArea())

	CTD->(dbOrderNickName("INDCTD1"))
	If CTD->(!MsSeek(xFilial("CTD") + _cChavCTD))
		CTD->(RecLock("CTD",.T.))
		CTD->CTD_FILIAL := XFILIAL("CTD")
		CTD->CTD_ITEM   := _cCODCTD
		CTD->CTD_CLASSE := "2"
		CTD->CTD_DESC01 := _cEmpresa+"-"+_cBanco+"-"+ALLTRIM(_cAgencia)+"-"+ALLTRIM(_cNumCon)+" - "+Alltrim(SA6->A6_NOME)
		CTD->CTD_BLOQ   := "2"
		CTD->CTD_DTEXIS := CTOD("01/01/00")
		CTD->CTD_ITLP   := _cCODCTD
		CTD->CTD_CLOBRG := "2"
		CTD->CTD_ACCLVL := "1"
		CTD->CTD_YIDENT := _cCHAVCTD
		CTD->(MsUnlock())

		SA6->(RecLock("SA6",.F.))
		SA6->A6_YITEMC  := _cCODCTD
		SA6->(MsUnlock())

	Endif

	RestArea(_aAliSA6)
	RestArea(_aAliORI)

Return(lRet)

//User Function M070VEXC()
User Function M070VLUS()

	Local lRet:= .T.

	_aAliORI  := GetArea()
	_aAliSA6  := SA6->(GetArea())

	_cParam := PARAMIXB

//Alert("Ponto de Entrada M070VLUS"+Str(_cParam))

	If _cParam == NIL

		_cBanco   := SA6->A6_COD
		_cAgencia := SA6->A6_AGENCIA
		_cNumCon  := SA6->A6_NUMCON
		_cEmpresa := CEMPANT

		_cChavCTD := "B"+ _cEmpresa + _cBANCO + _CAGENCIA + _CNUMCON

		CTD->(dbOrderNickName("INDCTD1"))
		If CTD->(MsSeek(xFilial("CTD") + _cChavCTD))
			CTD->(RecLock("CTD",.F.))
			CTD->(dbDelete())
			CTD->(MsUnlock())
		Endif
	Endif

	RestArea(_aAliSA6)
	RestArea(_aAliORI)

Return(lRet)



/*/{Protheus.doc} Mt410Ace
Ponto de entrada criado para verificar o acesso dos usuários nas rotinas: Excluir, Visualizar, Resíduo, Copiar e Alterar.
@type Ponto de entrada 
@version 1.0
@author Fabiano
@since 16/04/2020
/*/
User Function Mt410Ace()

	Local _lContinua	:= .T.
	Local _nOpc			:= PARAMIXB [1] //  1 - Excluir | 2 - Visualizar / Residuo | 3 - Copiar | 4 - Alterar

	If Alltrim(cEmpAnt)+Alltrim(cFilAnt) $ '1306|1307' .And. SC5->C5_CLIENTE = '000276'
		If SC5->C5_EMISSAO <> dDataBase .And. SC5->C5_XOPER = 'V'
			IF _nOpc == 1
				_lContinua := u_ChkAcesso("Mt410Ace",5,.T.)
			ElseIf _nOpc == 4
				_lContinua := u_ChkAcesso("Mt410Ace",4,.T.)
			Endif
		Endif
	Endif

Return(_lContinua)