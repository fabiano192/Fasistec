
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.ch"
#INCLUDE "FONT.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณASI003    บAutor  ณ Alexandro da Silva บ Data ณ  27/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza็ใo do Contas a Pagar                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Compras / Financeiro                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ASI003(_lAuto)

	LOCAL aAlias	:={},cSavRegua

	Private _lPonto  := _lAuto <> NIL

	If !_lPonto
		Private aRotina := {{"Pesquisar" 	,"AxPesqui",0,1} ,;
			{"Visualizar"   ,"U_ASI03A",0,2} ,;
			{"Alterar"      ,"U_ASI03A",0,3} }

		Private cDelFunc := ".T."

		SE2->(dbSetOrder(1))

		_aCor := {	{"E2_SALDO = 0"     ,'BR_VERMELHO'},;
			{"E2_SALDO > 0"     ,'BR_VERDE'}}

		MBrowse( 6,1,22,75,"SE2",,,,, 2,_aCor )
	Else
		U_ASI03A()
	Endif

Return .T.


User Function ASI03A(cAlias, nReg, nOpc1)

	_lAlt := .T.
	If !_lPonto
		If nOpc1 = 2 //Visualiza
			_lGo   := .T.
			_lAlt  := .F.
		ElseIf nOpc1 = 3 // Altera
			If SE2->E2_SALDO > 0
				_lGo := .T.
			Else
				_lGo := .F.
				MSGBOX(UPPER(Alltrim(Subs(cUsuario,7,15))) + ", Este procedimento s๓ pode ser efetuado para tํtulos com saldo em aberto.")
			Endif
		Endif
	Else
		//	SE2->(dbSetOrder(6))
		//	SE2->(dbSeek(xFilial("SE2")+SF1->F1_FORNECE+ SF1->F1_LOJA + SF1->F1_PREFIXO + SF1->F1_DOC))

		_lGo := .T.
	Endif

	_cModPg := Space(02)
	_cTpPg  := space(02)

	If _lGo

		_aALiOri := GetArea()
		_aAliSA2 := SA2->(GetArea())
		_aAliSE2 := SE2->(GetArea())
		_aAliSE4 := SE4->(GetArea())

		Private aSize	  := MsAdvSize()
		Private aObjects  := {}
		Private aPosObj   := {}
		Private aSizeAut  := MsAdvSize() // devolve o tamanho da tela atualmente no micro do usuario

		AAdd( aObjects, { 100, 100, .T., .t. } )
		AAdd( aObjects, { 100, 100, .t., .t. } )
		AAdd( aObjects, { 100, 015, .t., .t. } )

		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
		aPosObj := MsObjSize( aInfo, aObjects,.T. )

		If UPPER(Alltrim(FunName())) = "FINA240"
			SE2->(dbSetOrder(1))
			If SE2->(!dbSeek(xFilial("SE2")+(cAliasSE2)->E2_PREFIXO+(cAliasSE2)->E2_NUM+(cAliasSE2)->E2_PARCELA+(cAliasSE2)->E2_TIPO+(cAliasSE2)->E2_FORNECE +(cAliasSE2)->E2_LOJA))
				Return(_aAliSA2)
				Return(_aAliSE2)
				Return(_aAliSE4)
				Return(_aALiOri)

				MSGINFO("TITULO NAO ENCONTRADO!!")
				Return
			Endif
		Endif

		SA2->(dbSetOrder(1))
		SA2->(dbSeek(xFilial("SA2")+SE2->E2_FORNECE + SE2->E2_LOJA))

		cTitulo   := "Titulos do Contas a Pagar"
		_cPrefixo := SE2->E2_PREFIXO
		_cNumero  := SE2->E2_NUM
		_cParcela := SE2->E2_PARCELA
		_cFornece := SE2->E2_FORNECE
		_cLoja    := SE2->E2_LOJA
		_dEmissao := SE2->E2_EMISSAO
		_dVencto  := SE2->E2_VENCTO
		_dVencRea := SE2->E2_VENCREA
		_nValor   := SE2->E2_VALOR
		_cNomeFor := SA2->A2_NOME
		_cCodBar  := SE2->E2_CODBAR

		aRadio    := {}
		nRadio    := 1
		aRadio2   := {}
		nRadio2   := 1

		_lForn    := .f.
		_cIPTE    := Space(47)
		//_cCodBar  := Space(48)

		If !Empty(SE2->E2_XBANCO)
			_cBanco   := SE2->E2_XBANCO 
			_cAgencia := SE2->E2_XAGEN  
			_cAgenDig := SE2->E2_XDVAGEN
			_cConta   := SE2->E2_XCONTA 
			_cContaDig:= SE2->E2_XDVCON 
		Else
			_cBanco   := SA2->A2_BANCO
			_cAgencia := SA2->A2_AGENCIA
			_cAgenDig := SA2->A2_XDVAGEN
			_cConta   := SA2->A2_NUMCON
			_cContaDig:= SA2->A2_XDVCON
		Endif
        
		_nJuros   := SE2->E2_ACRESC
		_nDescon  := SE2->E2_DECRESC

		_cFavorec := PADR(SA2->A2_NOME,60)

		If !Empty(_cBanco)
			_lForn := .T.
		Endif

		SX5->(dbSetOrder(1))
		If SX5->(dbSeek(xFilial("SX5")+"Z9"))

			_cChav := SX5->X5_TABELA

			While SX5->(!Eof()) .And. 	_cChav == SX5->X5_TABELA

				AADD(aRadio,Substr(SX5->X5_DESCRI,1,20))

				SX5->(dbSkip())
			EndDo
		Endif

		SX5->(dbSetOrder(1))
		If SX5->(dbSeek(xFilial("SX5")+"Z8"))

			_cChav := SX5->X5_TABELA

			While SX5->(!Eof()) .And. 	_cChav == SX5->X5_TABELA

				AADD(aRadio2,Substr(SX5->X5_DESCRI,1,20))

				SX5->(dbSkip())
			EndDo
		Endif

		_dDt  := DATE()
		_lGet := .T.
		_nOpc := 0
		Private _lModTpPG:= .T.
		Private _lCODBAR := .T.

		DEFINE MSDIALOG oDlg TITLE cTitulo From 10,0 to 390,900 of oMainWnd PIXEL

		@ 05,aPosObj[2,2] TO 50,360

		@ 15,010  Say "Prefixo: "
		@ 15,040  GET _cPrefixo  WHEN .F. SIZE 20,20
		@ 15,065  Say "Numero: "
		@ 15,090 Get _cNumero   WHEN .F. SIZE 50,20
		@ 15,144 Say "Parc: "
		@ 15,164 GET _cParcela  WHEN .F. SIZE 20,20
		@ 15,190 Say "Fornecedor: "
		@ 15,220 GET _cFornece  WHEN .F. SIZE 40,20
		@ 15,265 Say "Loja: "
		@ 15,280 GET _cLoja     WHEN .F. SIZE 30,20

		@ 35,010 Say "Emissao: "
		@ 35,030 GET _dEmissao  WHEN .F. SIZE 50,20
		@ 35,090 Say "Vencimento:"
		@ 35,120 GET _dVencto    WHEN .F. SIZE 50,20
		@ 35,175 Say "Vencimento Real:"
		@ 35,220 GET _dVencRea   WHEN .F. SIZE 50,20
		@ 35,280 Say "Valor:"
		@ 35,300 GET _nValor     WHEN .F. PICTURE "@E 999,999.99" SIZE 50,20

		@ 130,010  Say "Cod.Barras: "
		@ 130,060  GET _cCodBar WHEN _lCODBAR VALID ASI03B("C") SIZE 170,30

		@ 130,280  Say "Mod. Pagto: "
		@ 130,310  GET _cModPg  WHEN  _lModTpPG F3 "58" VALID Existcpo("SX5","58"+_cModPg)  SIZE 30,20

		@ 150,280  Say "Tipo Pagto: "
		@ 150,310  GET _cTpPg   WHEN  _lModTpPG F3 "59" VALID Existcpo("SX5","59"+_cTpPg)  SIZE 30,20

		@ 170,270 BMPBUTTON TYPE 1  ACTION (_nOpc:=1,oDlg:END())
		@ 170,320 BMPBUTTON TYPE 2  ACTION oDlg:END()

		@ 056,003 TO 100,110 TITLE "Forma de Pagamento"
		@ 070,015 RADIO aRadio VAR nRadio

	/*
	@ 056,003 TO 100,110 TITLE "Juros/Descontos"
	
	@ 065,015 Say "Juros: "
	@ 065,050 GET _nJuros   WHEN .T. Valid ASI03C("J") PICTURE "@E 999,999.99" SIZE 50,20
	
	@ 080,015 Say "Desc.Boleto: "
	@ 080,050 GET _nDescon  WHEN .T. Valid ASI03C("D") PICTURE "@E 999,999.99" SIZE 50,20
	*/

		@ 056,120 TO 125,265 TITLE "Dados Para Deposito"

		@ 065,130 Say "Banco: "
		@ 065,170 GET _cBanco   WHEN .T. Valid MZ144_01() SIZE 20,20

		@ 080,130 Say "Agencia/Dig: "
		@ 080,170 GET _cAgencia  WHEN _lAlt SIZE 30,20
		@ 080,200 GET _cAgenDig  WHEN _lAlt SIZE 15,20

		@ 095,130 Say "Conta/Dig:"
		@ 095,170 GET _cConta    WHEN _lAlt SIZE 50,20
		@ 095,220 GET _cContaDig WHEN _lAlt SIZE 15,20

		@ 110,130 Say "Favorecido:"
		@ 110,170 GET _cFavorec  WHEN .T. SIZE 90,20

		@ 056,280 TO 100,360 TITLE "Praca de Pagamento"
		@ 070,285 RADIO aRadio2 VAR nRadio2

		@ 001,365 TO 187,445 TITLE "Composicao dos Valores"

		_nValor := SE2->E2_VALOR + SE2->E2_PIS + SE2->E2_COFINS + SE2->E2_CSLL + SE2->E2_ISS + SE2->E2_INSS + SE2->E2_IRRF + SF1->F1_DESCONT - SF1->F1_FRETE - SF1->F1_DESPESA - SF1->F1_ICMSRET

		@ 010,370 Say "VL.TITULO: "
		@ 010,410 GET _nValor          WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

		@ 025,370 Say "(-)VL.PIS: "
		@ 025,410 GET SE2->E2_PIS      WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

		@ 040,370 Say "(-)VL.COFINS: "
		@ 040,410 GET SE2->E2_COFINS   WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

		@ 055,370 Say "(-)VL.CSLL: "
		@ 055,410 GET SE2->E2_CSLL     WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

		@ 070,370 Say "(-)VL.ISS: "
		@ 070,410 GET SE2->E2_ISS      WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

		@ 085,370 Say "(-)VL.INSS: "
		@ 085,410 GET SE2->E2_INSS     WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

		@ 100,370 Say "(-)VL.IRRF: "
		@ 100,410 GET SE2->E2_IRRF     WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

		@ 115,370 Say "(+)VL.DESCONTO:"
		@ 115,410 GET SF1->F1_DESCONT  WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

		@ 130,370 Say "(+)VL.FRETE  :"
		@ 130,410 GET SF1->F1_FRETE    WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

		@ 145,370 Say "(+)VL.DESPESAS:"
		@ 145,410 GET SF1->F1_DESPESA  WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

		@ 160,370 Say "(+)VL.ICMS ST:"
		@ 160,410 GET SF1->F1_ICMSRET  WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

		@ 175,370 Say "(=)VL.LIQUIDO:"
		@ 175,410 GET SE2->E2_VALOR    WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

		@ 170,010  Say "Nome Fornecedor: "
		@ 170,060  GET _cNomeFor WHEN .F. SIZE 150,30


		ACTIVATE MSDIALOG oDlg Centered

		If _nOpc == 1
			SE2->(RecLock("SE2",.F.))
			If UPPER(Alltrim(FunName())) = "MATA103"
				SE2->E2_CODBAR  := ""
			Else
				SE2->E2_CODBAR  := _cCodBar
			Endif

			SE2->E2_XLINDIG := _cIPTE
			SE2->E2_YFORMPG := StrZero(nRadio,3)
			SE2->E2_YPRAPG  := StrZero(nRadio2,3)
			SE2->E2_XBANCO  := _cBanco
			SE2->E2_XAGEN   := _cAgencia
			SE2->E2_XDVAGEN := _cAgenDig
			SE2->E2_XCONTA  := _cConta
			SE2->E2_XDVCON  := _cContaDig
			SE2->E2_XMODPGT := _cModPg
			SE2->E2_XTIPPGT := _cTpPg
			SE2->E2_DATALIB := dDataBase
			SE2->E2_USUALIB := cUsername
			SE2->E2_ACRESC  := _nJuros
			SE2->E2_SDACRES := _nJuros
			SE2->E2_XDESBOL := _nDescon
			//SE2->E2_SDDECRE := _nDescon
			SE2->(MsUnlock())

			If !_lForn .And. !Empty(_cBanco)
				SA2->(RecLock("SA2",.F.))
				SA2->A2_BANCO    := _cBanco
				SA2->A2_AGENCIA  := _cAgencia
				SA2->A2_XdvAgen  := _cAgenDig
				SA2->A2_NUMCON   := _cConta
				SA2->A2_xDvCon   := _cContaDig
				SA2->(MsUnlock())
			Endif

			If UPPER(Alltrim(FunName())) = "FINA240"
				(cAliasSE2)->(RecLock((cAliasSE2),.F.))
				(cAliasSE2)->E2_CODBAR  := _cCodBar
				(cAliasSE2)->E2_XLINDIG := _cIPTE
				(cAliasSE2)->E2_YFORMPG := StrZero(nRadio,3)
				(cAliasSE2)->E2_YPRAPG  := StrZero(nRadio2,3)
				(cAliasSE2)->E2_XBANCO  := _cBanco
				(cAliasSE2)->E2_XAGEN   := _cAgencia
				(cAliasSE2)->E2_XDVAGEN := _cAgenDig
				(cAliasSE2)->E2_XCONTA  := _cConta
				(cAliasSE2)->E2_XDVCON  := _cContaDig
				(cAliasSE2)->E2_ACRESC  := _nJuros
				(cAliasSE2)->E2_XDESBOL := _nDescon
				(cAliasSE2)->(MsUnLock())
			Endif

		Endif
	Endif

Return


Static Function ASI03B(_cTp)

	_lRet := .T.

	If !Empty(_cCodBar)
		_cModPg  := "31"
		_cTpPg   := "20"
		_lModTpPG:= .f.
	Else
		If !Empty(_cBanco)
			_lForn := .T.
			If _cBanco == "237"
				_cModPg  := "01"
				_cTpPg   := "20"
			Else
				_cModPg  := "08"
				_cTpPg   := "20"
			Endif
			_lModTpPG:= .f.
		Endif
	Endif

	If U_PGFOR021()
		_cCodBar := U_PGFOR022()

		_nFatValor:= Val(Substr(_cCodBar,01,14))

		If _nFatValor <> 0
			_dBase    := CTOD("07/10/97")
			_nFator   := Val(Substr(_cCodBar,06,04))

			_nValCBAR := Val(Substr(_cCodBar,10,10))/100
			_nValTit  := SE2->E2_SALDO + SE2->E2_ACRESC - SE2->E2_DECRESC

			If Substr(_cCodBar,10,10) <> "0000000000"
				If _nValTit <> _nValCBAR
					MsgAlert("Valor do Titulo ้ Diferente do Valor do Codigo de Barras!!")
					_lRet := .F.
				Endif
			Endif

			_aAliSE2 := SE2->(GetArea())

			SE2->(dbOrderNickName("INDSE29"))
			If SE2->(dbSeek(_cCodBar))  // INDICE SEM O CAMPO FILIAL PARA CHECAR EM TODAS AS FILIAIS / EMPRESA.
				MsgAlert("Codigo de Barras Jแ Utizado em outra Nota Fiscal!!")
				_lRet := .F.
			Endif

			RestArea(_aAliSE2)

		Endif
	Else
		_lRet := .F.
	Endif

Return(_lRet)


Static Function MZ144_01()

	If _cBanco == "237"
		_cModPg  := "01"
		_cTpPg   := "20"
	Else
		_cModPg  := "08"
		_cTpPg   := "20"
	Endif

	If !Empty(_cBanco)
		_lCODBAR := .F.
	Else
		_lCODBAR := .T.
		_cModPg  := "31"
		_cTpPg   := "20"
	Endif

Return

Static Function ASI03C(_cTp)

	If _cTp == "J"
		If _nDescon > 0 .And. _nJuros <> 0
			_lRet := .F.
		Else
			_lRet := .T.
		Endif
	Else
		If _nJuros  > 0 .And. _nDescon <> 0
			_lRet := .F.
		Else
			_lRet := .T.
		Endif
	Endif

Return(_lRet)
