#include "rwmake.ch"

/*
Programa 	: CR0025
Data 		: 26/10/12
Descrição	: Atualizacao de preco Indice
*/

User Function CR0023()

	///////////////////////////////////////////////
	///////////////////////////////////////////////
	/////  Grupo de Pergunta PA0004          //////
	/////  MV_PAR01 : Cliente      De ?      //////
	/////  MV_PAR02 : Cliente      Ate?      //////
	/////  MV_PAR03 : Loja         De ?      //////
	/////  MV_PAR04 : Loja         Ate?      //////
	/////  MV_PAR05 : Produto      De ?      //////
	/////  MV_PAR06 : Produto      Ate?      //////
	/////  MV_PAR07 : Atualiza Pedido ?      //////
	/////  MV_PAR08 : Pedido     De ?        //////
	/////  MV_PAR09 : Pedido     Ate?        //////
	/////  MV_PAR10 : Dt.Entrega De ?        //////
	/////  MV_PAR11 : Dt.Entrega Ate?        //////
	/////  MV_PAR12 : Dt.Emissao De ?        //////
	/////  MV_PAR13 : Dt.Emissao Ate?        //////
	/////  MV_PAR14 : Fator Multip. ?        //////
	/////  MV_PAR15 : Tipo de Calculo?       //////
	/////  MV_PAR16 : Data Referencia?       //////
	/////  MV_PAR17 : Base Economica?        //////
	///////////////////////////////////////////////
	///////////////////////////////////////////////

	If !Pergunte("CR0023",.T.)
		Return
	Endif

	If MV_PAR14 == 0 .OR. Empty(MV_PAR16) .Or. EMPTY(MV_PAR17)
		MsgBox("Esta Faltando Alguma Informacao nos Parametros!!!","Informacao","erro")
		Return
	Endif

	Private _nValor1 := 0
	Private _nValor2 := 0

	If MV_PAR15 == 1
		Processa( {|| AtuPreco() } )
		MsgBox("Preco Atualizado com Sucesso","Informacao","info")
	Else
		Processa( {|| DescPreco() } )
		MsgBox("Preco Descalculado com Sucesso","Informacao","info")
	Endif

Return


Static Function AtuPreco()

	dbSeLectArea("SZ2")
	dbSetOrder(2)  //Produto + Cliente + Loja
	dbSeek(xFilial()+MV_PAR05+MV_PAR01+MV_PAR03,.T.)

	_nRec := LastRec()
	ProcRegua(_nRec)

	While !Eof()

		IncProc()

		If SZ2->Z2_CLIENTE < MV_PAR01 .Or. SZ2->Z2_CLIENTE > MV_PAR02 .Or.;
		SZ2->Z2_LOJA    < MV_PAR03 .Or. SZ2->Z2_LOJA    > MV_PAR04 .Or.;
		SZ2->Z2_PRODUTO < MV_PAR05 .OR. SZ2->Z2_PRODUTO > MV_PAR06
			dbSelectarea("SZ2")
			dbSkip()
			Loop
		Endif

		//   If Alltrim(SZ2->Z2_CODCLI) $ '3222943|3471881|3865659|4661384|5129040|5143935|5152212|5152218|5287140|5427279|5465213|5479582|5626938|5626939|5626942|5637404|5681307|2G8096'
		//      dbSelectarea("SZ2")
		//      dbSkip()
		//      Loop
		//   Endif

		_nFator := MV_PAR14

		If Empty(SZ2->Z2_PRECO01)
			dbSelecTarea("SZ2")
			dbSkip()
			Loop
		Endif

		_lAtualiza := .F.
		For I:=2 To 12
			_nValor1 :=  &("SZ2->Z2_PRECO"+StrZero(i,2))
			_nValor2 :=  &("SZ2->Z2_PRECO"+StrZero(i-1,2))
			If Empty(_nValor1)
				dbSelectArea("SZ2")
				RecLock("SZ2",.F.)
				_nPreco := "SZ2->Z2_PRECO"+strZero(I,2)
				_dDtRef := "SZ2->Z2_DTREF"+strZero(I,2)
				_dDtBas := "SZ2->Z2_DTBAS"+strZero(I,2)

				&_nPreco  := Round((_nValor2 * MV_PAR14),4)
				&_dDtRef  := MV_PAR16
				&_dDtBas  := MV_PAR17

				MsUnlock()
				I:= 12
				_lAtualiza := .T.
			Endif
		Next I

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
			SZ2->Z2_PRECO12 := Round((SZ2->Z2_PRECO12 * MV_PAR14),4)
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
			SZ2->Z2_DTREF12 := MV_PAR16
			MsUnlock()
		Endif

		If MV_PAR07 == 1
			AtuPed()
		Endif

		dbSelectArea("SZ2")
		dbSkip()
	EndDo

Return



Static Function AtuPed()

	SC6->(dbSetOrder(2))
	SC6->(dbSeek(xFilial()+SZ2->Z2_PRODUTO + MV_PAR08,.T.))

	While !SC6->(Eof()) .And. (SZ2->Z2_PRODUTO == SC6->C6_PRODUTO) .And. SC6->C6_NUM <= MV_PAR09

		If SC6->C6_QTDVEN == SC6->C6_QTDENT .Or. Alltrim(SC6->C6_BLQ) == "R"
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif

//		If Alltrim(SC6->C6_PEDCLI) <> Alltrim(SZ2->Z2_PEDCLI)
//			SC6->(dbSkip())
//			Loop
//		Endif

		If SC6->C6_CLI     <  MV_PAR01 .Or. SC6->C6_CLI     > MV_PAR02 .Or.;
		SC6->C6_LOJA    <  MV_PAR03 .Or. SC6->C6_LOJA    > MV_PAR04 .Or.;
		SC6->C6_PRODUTO <  MV_PAR05 .Or. SC6->C6_PRODUTO > MV_PAR06 .Or.;
		SC6->C6_ENTREG  <  MV_PAR10 .Or. SC6->C6_ENTREG  > MV_PAR11
			SC6->(dbSkip())
			Loop
		Endif

		dbSelectArea("SC5")
		dbSetOrder(1)
		If dbSeek(xFilial()+SC6->C6_NUM)
			If SC5->C5_EMISSAO < MV_PAR12 .Or. SC5->C5_EMISSAO > MV_PAR13
				dbSelectArea("SC6")
				dbSkip()
				Loop
			Endif
		Endif

		dbSelectArea("SC6")
		RecLock("SC6",.F.)
		SC6->C6_PRCVEN := Round((_nValor2 * MV_PAR14),4)
		SC6->C6_PRUNIT := Round((_nValor2 * MV_PAR14),4)
		SC6->C6_VALOR  := Round((SC6->C6_QTDVEN * SC6->C6_PRCVEN),4)
		MsUnlock()

		dbSelectArea("SC9")
		dbSetorder(1)
		If dbSeek(xFilial()+SC6->C6_NUM+SC6->C6_ITEM)
			_cChavSc9 := SC9->C9_PEDIDO + SC9->C9_ITEM

			While !Eof() .And. _cChavSc9 == SC9->C9_PEDIDO + SC9->C9_ITEM

				If !Vazio(SC9->C9_NFISCAL)
					dbSelectArea("SC9")
					dbSkip()
					Loop
				Endif

				dbSelectArea("SC9")
				RecLock("SC9",.F.)
				SC9->C9_PRCVEN := Round((_nValor2 * MV_PAR14),4)
				MsUnlock()

				dbSelectArea("SC9")
				dbSkip()
			EndDo
		Endif

		SC6->(dbSkip())
	EndDo

Return



Static Function DescPreco()

	dbSeLectArea("SZ2")
	dbSetOrder(2)  //Produto + Cliente+Loja
	dbSeek(xFilial()+MV_PAR05+MV_PAR01+MV_PAR03,.T.)

	_nRec := LastRec()
	ProcRegua(_nRec)

	While !Eof()

		IncProc()

		If SZ2->Z2_CLIENTE < MV_PAR01 .Or. SZ2->Z2_CLIENTE > MV_PAR02 .Or.;
		SZ2->Z2_LOJA    < MV_PAR03 .Or. SZ2->Z2_LOJA    > MV_PAR04 .Or.;
		SZ2->Z2_PRODUTO < MV_PAR05 .OR. SZ2->Z2_PRODUTO > MV_PAR06
			dbSelectarea("SZ2")
			dbSkip()
			Loop
		Endif

		_nFator := MV_PAR14

		If Empty(SZ2->Z2_PRECO01)
			dbSelecTarea("SZ2")
			dbSkip()
			Loop
		Endif

		For I:=2 To 12
			_nValor1 :=  &("SZ2->Z2_PRECO"+StrZero(i,2))
			_nValor2 :=  &("SZ2->Z2_PRECO"+StrZero(i-1,2))
			_dData   := "SZ2->Z2_DTREF"+strZero(I,2)
			If &_dData == MV_PAR16
				_nPreco := "SZ2->Z2_PRECO"+strZero(I,2)
				_dDtRef := "SZ2->Z2_DTREF"+strZero(I,2)
				_dDtBas := "SZ2->Z2_DTBAS"+strZero(I,2)

				dbSelectArea("SZ2")
				RecLock("SZ2",.F.)
				&_nPreco  := 0
				&_dDtRef  := CTOD("  /  /  ")
				&_dDtBas  := CTOD("  /  /  ")
				MsUnlock()
				I:= 12
			Endif
		Next I

		If MV_PAR07 == 1
			DescPed()
		Endif

		dbSelectArea("SZ2")
		dbSkip()
	EndDo

Return


Static Function DescPed()

	dbSelectArea("SC6")
	dbSetOrder(2)
	dbSeek(xFilial()+SZ2->Z2_PRODUTO + MV_PAR08,.T.)

	While !Eof() .And. (SZ2->Z2_PRODUTO == SC6->C6_PRODUTO) .And. SC6->C6_NUM <= MV_PAR09

		If SC6->C6_QTDVEN == SC6->C6_QTDENT .Or. Alltrim(SC6->C6_BLQ) == "R"
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif

		If SC6->C6_CLI     <  MV_PAR01 .Or. SC6->C6_CLI     > MV_PAR02 .Or.;
		SC6->C6_LOJA    <  MV_PAR03 .Or. SC6->C6_LOJA    > MV_PAR04 .Or.;
		SC6->C6_PRODUTO <  MV_PAR05 .Or. SC6->C6_PRODUTO > MV_PAR05 .Or.;
		SC6->C6_ENTREG  <  MV_PAR10 .Or. SC6->C6_ENTREG  > MV_PAR11
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif

//		If Alltrim(SC6->C6_PEDCLI) <> Alltrim(SZ2->Z2_PEDCLI)
//			SC6->(dbSkip())
//			Loop
//		Endif

		dbSelectArea("SC5")
		dbSetOrder(1)
		If dbSeek(xFilial()+SC6->C6_NUM)
			If SC5->C5_EMISSAO < MV_PAR12 .Or. SC5->C5_EMISSAO > MV_PAR13
				dbSelectArea("SC6")
				dbSkip()
				Loop
			Endif
		Endif

		dbSelectArea("SC6")
		RecLock("SC6",.F.)
		SC6->C6_PRCVEN := _nValor2
		SC6->C6_PRUNIT := _nValor2
		SC6->C6_VALOR  := Round((SC6->C6_QTDVEN * SC6->C6_PRCVEN),4)
		MsUnlock()

		dbSelectArea("SC9")
		dbSetorder(1)
		If dbSeek(xFilial()+SC6->C6_NUM+SC6->C6_ITEM)
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

		dbSelectArea("SC6")
		dbSkip()
	EndDo

Return