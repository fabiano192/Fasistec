#include "Totvs.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CR0003    ³                               ³ Data ³ 18.03.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Tela de cadastramento Cliente x Cod.Prod. Cliente           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CR0003()

	Local cAlias := "SZ2"
	Local aCores := {}

	Private cCadastro := "Cliente x Produto x Cod.Prod.Cliente"
	Private aRotina := {}

	AADD(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
	AADD(aRotina,{"Visualizar" ,"AxVisual",0,2})
	AADD(aRotina,{"Incluir" ,"AxInclui",0,3})
	AADD(aRotina,{"Alterar" ,"AxAltera",0,4})
	AADD(aRotina,{"Excluir" ,"U_VerMov",0,5})
	AADD(aRotina,{"Compl.Informações" ,"U_CR03INFO()",0,6})
	AADD(aRotina,{"Legenda" ,"U_BLegenda" ,0,3})

	/*-- CORES DISPONIVEIS PARA LEGENDA
	BR_AMARELO
	BR_AZUL
	BR_BRANCO
	BR_CINZA
	BR_LARANJA
	BR_MARRON
	BR_VERDE
	BR_VERMELHO
	BR_PINK
	BR_PRETO
	*/

	AADD(aCores,{"Z2_ATIVO == '1'" ,"BR_VERDE" })
	AADD(aCores,{"Z2_ATIVO == '2' .AND. Empty(Z2_PRODUTO)" ,"BR_AMARELO" })
	AADD(aCores,{"Z2_ATIVO == '2' .AND. !Empty(Z2_PRODUTO)" ,"BR_VERMELHO" })

	mBrowse( 6,1,22,75,cAlias,,,,,,aCores)

Return



User Function VerMov(cAlias, nReg, nOpc)

	_aAliOri2:= GetArea()
	_aAliSC6 := SC6->(GetArea())
	_aAliSD2 := SD2->(GetArea())
	_lRet    := .T.

	dbSelectArea("SC6")
	dbOrderNickname("INDSC66")
	If dbSeek(xFilial()+SZ2->Z2_CLIENTE+SZ2->Z2_LOJA+SZ2->Z2_PRODUTO+SZ2->Z2_CODCLI+SZ2->Z2_PEDCLI)
		_lRet := .F.
	Endif

	dbSelectArea("SD2")
	dbOrderNickname("INDSD25")
	If dbSeek(xFilial()+SZ2->Z2_CLIENTE+SZ2->Z2_LOJA+SZ2->Z2_PRODUTO+SZ2->Z2_CODCLI+SZ2->Z2_PEDCLI)
		_lRet := .F.
	Endif

	If _lRet
		AxDeleta(cAlias,nReg,nOpc)
	Else
		MSGAlert('Cadastro ja possui movimento e nao pode ser Excluido!!!')
	Endif

	RestArea(_aAliSC6)
	RestArea(_aAliSD2)
	RestArea(_aAliOri2)

Return Nil


User Function VerMov3()

	_aAliOri2:= GetArea()
	_aAliSC6 := SC6->(GetArea())
	_aAliSD2 := SD2->(GetArea())
	_lRet    := .T.

	dbSelectArea("SC6")
	dbOrderNickname("INDSC61")
	If dbSeek(xFilial()+M->Z2_CLIENTE+M->Z2_LOJA+M->Z2_PRODUTO+M->Z2_CODCLI)
		MSGBOX("Cadastro ja Possui Movimento e nao Pode ser Alterado/Excluido!!!","Informacao","INFO")
		_lRet := .F.
	Endif

	dbSelectArea("SD2")
	dbOrderNickname("INDSD21")
	If dbSeek(xFilial() + M->Z2_CLIENTE + M->Z2_LOJA + M->Z2_PRODUTO + M->Z2_CODCLI)
		MSGBOX("Cadastro ja Possui Movimento e nao Pode ser Alterado/Excluido!!!","Informacao","INFO")
		_lRet := .F.
	Endif

	RestArea(_aAliSC6)
	RestArea(_aAliSD2)
	RestArea(_aAliOri2)

Return(_lRet)


User Function CR03A()

	_aAliOri := GetArea()
	_aAliSZC := SB1->(GetArea())

	Private oGetDad
	nOpcx:=3

	dbSelectArea("Sx3")
	dbSetOrder(1)
	dbSeek("SZC")
	nUsado:=0
	aHeader:={}
	While !Eof() .And. (x3_arquivo == "SZC")
		IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And.(Alltrim(x3_campo) $ "ZC_DTREF  /ZC_QTINIC  /ZC_QTFINAL/ZC_PRECO  /ZC_ATIVO  ")
			nUsado:=nUsado+1
			If RTrim(X3_CAMPO) == "ZC_PRECO"
				AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
				x3_tamanho, x3_decimal, 'U_LINHA01()',;
				x3_usado, x3_tipo, x3_arquivo, x3_context } )
			Else
				AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
				x3_tamanho, x3_decimal, x3_valid,;
				x3_usado, x3_tipo, x3_arquivo, x3_context } )
			Endif
		Endif
		dbSkip()
	End

	aCols:=Array(1,nUsado+1)
	dbSelectArea("Sx3")
	dbSeek("SZC")
	nUsado:=0
	While !Eof() .And. (x3_arquivo == "SZC")
		IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And.(Alltrim(x3_campo) $ "ZC_DTREF  /ZC_QTINIC  /ZC_QTFINAL/ZC_PRECO  /ZC_ATIVO  ")
			nUsado:=nUsado+1
			IF nOpcx == 3
				IF x3_tipo == "C"
					aCOLS[1][nUsado] := SPACE(x3_tamanho)
				Elseif x3_tipo == "N"
					aCOLS[1][nUsado] := 0
				Elseif x3_tipo == "D"
					aCOLS[1][nUsado] := dDataBase
				Elseif x3_tipo == "M"
					aCOLS[1][nUsado] := ""
				Else
					aCOLS[1][nUsado] := .F.
				Endif
			Endif
		Endif
		dbSkip()
	End
	aCOLS[1][nUsado+1] := .F.

	_cProdCli   := M->Z2_CODCLI
	_cProduto   := M->Z2_PRODUTO
	_cCliente   := M->Z2_CLIENTE
	_cLoja      := M->Z2_LOJA

	ACols:={}
	dbSelectArea("SZC")
	dbSetOrder(1)
	dbSeek(xFilial() + _cCliente + _cLoja + _cProduto + _cProdCli )

	_cChavSZC := _cCliente + _cLoja + _cProduto + _cProdCli

	While !eof() .And. _cChavSZC == SZC->ZC_CLIENTE + SZC->ZC_LOJA + SZC->ZC_PRODUTO + SZC->ZC_PRODCLI
		AADD(aCols,Array(nUsado+1))
		For _ni:=1 to nUsado
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next
		aCols[Len(aCols),nUsado+1]:=.F.
		dbSkip()
	EndDo

	nLinGetD:= 0
	cTitulo := "Tabela de Preco Exportacao"

	aC:={}
	AADD(aC,{"_cProduto"     ,{15,10}    ,"Produto: "          ,"@I","","SB1",.F.})
	AADD(aC,{"_cProdCli"     ,{15,150}    ,"ProdXCliente: "     ,"@I","","SB1",.F.})

	aR:={}

	aCGD  := {33,10,100,315}
	aCord := {120,150,350,815}

	/*
	1 -  Linha Superior
	2 -  Coluna Esquerda
	3 -  Linha Inferior
	4 -  Coluna Direita
	*/
	cLinhaOk  := "AllWaysTrue()"
	cTudoOk   := "AllWaysTrue()"
	//cTudoOk   :="U_CR03B()"

	lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,aCord)

	If lRetMod2
		CR03C()
	Endif

	RestArea(_aAliSZC)
	RestArea(_aAliOri)

	_cRet := ""

Return(_cRet)


Static Function CR03C()

	Private  _nPDtRef  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="ZC_DTREF"})
	Private  _nPQtIni  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="ZC_QTINIC"})
	Private  _nPQtFim  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="ZC_QTFINAL"})
	Private  _nPPreco  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="ZC_PRECO"})
	Private  _nPAtivo  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="ZC_ATIVO"})

	_lDel := .F.
	For I:= 1 to Len(Acols)
		_cFim := (Len(aHeader)+1)
		If aCols[I,_cFim]
			I := I
		Else
			If !_lDel
				_lDel := .T.
				dbSelectArea("SZC")
				dbSetOrder(1)
				dbSeek(xFilial() + _cCliente + _cLoja + _cProduto + _cProdCli )

				_cChavSZC := _cCliente + _cLoja + _cProduto + _cProdCli

				While !eof() .And. _cChavSZC == SZC->ZC_CLIENTE + SZC->ZC_LOJA + SZC->ZC_PRODUTO + SZC->ZC_PRODCLI
					dbSelectArea("SZC")
					RecLock("SZC",.F.)
					dbDelete()
					MsUnlock()
					dbSelectarea("SZC")
					dbSkip()
				EndDo
			Endif

			If aCols[I,_nPPreco] > 0
				dbSelectArea("SZC")
				RecLock("SZC",.T.)
				SZC->ZC_FILIAL   := xFilial("SZC")
				SZC->ZC_CLIENTE  := _cCliente
				SZC->ZC_LOJA     := _cLoja
				SZC->ZC_PRODUTO  := _cProduto
				SZC->ZC_PRODCLI  := _cProdCli
				SZC->ZC_DTREF    := aCols[I,_nPDtRef]
				SZC->ZC_QTINIC   := aCols[I,_nPQtIni]
				SZC->ZC_QTFINAL  := aCols[I,_nPQtFim]
				SZC->ZC_PRECO    := aCols[I,_nPPreco]
				SZC->ZC_ATIVO    := aCols[I,_nPAtivo]
				MsUnlock()
			Endif
		Endif

	Next I

Return

Static Function CR03B()

	_nPDtRef  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="ZC_DTREF"})
	_dDtRef   := aCols[N,_nPDtRef]
	If N > 1
		_dDtRef := aCols[N-1,_nPDtRef]
	Endif


Return(_dDtRef)


/*
Funcao		:BLegenda
Descrição	:Legenda da mbrowse.
*/
User Function BLegenda()

	Local aLegenda := {}

	aAdd(aLegenda,{ "BR_VERDE"		, "Ativo" })
	aAdd(aLegenda,{ "BR_AMARELO"	, "Inativo, faltam informações" })
	aAdd(aLegenda,{ "BR_VERMELHO"	, "Inativo" })

	BrwLegenda(cCadastro,"Legenda", aLegenda)

Return


User Function CR03INFO()

	Local oDlg
	Local bOk
	Local bCancel	:= "{ || lSave:=.f. , oDlg:End() }"
	Local _oCheck	:= Nil
	Local _lClick	:= .F.
	Local _lRev		:= .F.

	Private cProduto 	:= Space(15)
	Private nDNP 		:= 0
	Private dBase 		:= cTod('  /  /  ')
	Private dRef 		:= dDataBase
	Private nTxDollar 	:= 0
	Private nLote 		:= SZ2->Z2_LOTEMIN
	Private nPrecoCli	:= SZ2->Z2_PRECO01
	Private nPrecoCro	:= SZ2->Z2_PRECO01
	Private lSave		:= .f.			// Variavel controla se tem ou nao que salvar.
	Private cIngles		:= Rtrim(SZ2->Z2_DESCCLI)
	Private cPortu		:= Space(30)
	Private cRevisao	:= SZ2->Z2_REVISAO
	Private cCodCli		:= SZ2->Z2_CODCLI
	Private _cDesc1 	:= "Desc. Inglês"
	Private _cDesc2 	:= "Desc. Português"

	If SZ2->Z2_CLIENTE = '000018'
		bOk := "{ || If(!Empty(cProduto) .and. nPrecoCro > 0 .and. nDNP > 0.and. nLote > 0 .and. !Empty(dBase) .and. nTxDollar > 0 .and. !Empty(Alltrim(cPortu)) ,(lSave:=.t.,oDlg:End()),Alert('Existe algum campo sem preenchimento!')) }"
		nHight := 495
	ElseIf SZ2->Z2_CLIENTE = '000017'
		bOk := "{ || If(!Empty(cProduto) .and. nPrecoCro > 0 .and. nDNP > 0.and. nLote > 0 .and. !Empty(dBase) .and. !Empty(Alltrim(cPortu)),(lSave:=.t.,oDlg:End()),Alert('Existe algum campo sem preenchimento!')) }"
		nHight := 455
	Else
		bOk :="{ || If(!Empty(cProduto) .and. nPrecoCro > 0 .and. nDNP > 0.and. nLote > 0 .and. !Empty(dBase) .and. !Empty(cPortu) .and. !Empty(cRevisao) .And. !Empty(dRef),(lSave:=.t.,oDlg:End()),Alert('Existe algum campo sem preenchimento!')) } "
		nHight := 495
		_cDesc1		:= "Desc. Cliente"
		_cDesc2		:= "Desc. Cronnos"
		//		cPortu		:= If(Empty(cIngles),Space(TAMSX3("Z2_DESCCLI")[1]),cIngles)
		cPortu		:= Padr(cIngles,TAMSX3("Z2_DESCCLI")[1])
		_lRev		:= .T.
	Endif

	If SZ2->Z2_ATIVO = '2' .AND. Empty(SZ2->Z2_PRODUTO)

		DEFINE MSDIALOG oDlg TITLE "Informações Complementares" FROM 000, 000  TO nHight,400  PIXEL

		_nTLin := 18
		_nLin  := 35
		@ _nLin, 015 SAY "Produto Cliente" 					SIZE 040, 007 OF oDlg PIXEL
		@ _nLin, 060 MSGET cCodCli 			When .F. 		SIZE 100, 010 OF oDlg PIXEL

		_nLin += _nTLin
		@ _nLin, 015 SAY "Revisao" 							SIZE 040, 007 OF oDlg PIXEL
		@ _nLin, 060 MSGET cRevisao 		When _lRev	SIZE 100, 010 OF oDlg PIXEL

		_nLin += _nTLin
		@ _nLin, 015 SAY "Preço Cliente" 					SIZE 040, 007 OF oDlg PIXEL
		@ _nLin, 060 MSGET nPrecoCli		When .F. 	PICTURE "@E 999,999.999"  SIZE 100, 010 OF oDlg PIXEL

		_nLin += _nTLin
		@ _nLin, 015 SAY "Preço Cronnos" 					SIZE 040, 007 OF oDlg PIXEL
		@ _nLin, 060 MSGET nPrecoCro		 			PICTURE "@E 999,999.999"  SIZE 100, 010 OF oDlg PIXEL

		If _lRev
			_nLin += _nTLin
			@ _nLin, 015 SAY "Data Referencia"					SIZE 040, 007 OF oDlg PIXEL
			@ _nLin, 060 MSGET dRef								SIZE 100, 010 OF oDlg PIXEL
		Endif

		_nLin += _nTLin
		@ _nLin, 015 SAY "Produto" 							SIZE 040, 007 OF oDlg PIXEL
		@ _nLin, 060 MSGET cProduto 			F3 'SB1'	VALID CR03PROD()	SIZE 100, 010 OF oDlg PIXEL

		_nLin += _nTLin
		@ _nLin, 015 SAY "DNP" 								SIZE 040, 007 OF oDlg PIXEL
		@ _nLin, 060 MSGET nDNP 				PICTURE "@E 99999"  SIZE 100, 010 OF oDlg PIXEL

		_nLin += _nTLin
		@ _nLin, 015 SAY "Lote Minimo" 						SIZE 040, 007 OF oDlg PIXEL
		@ _nLin, 060 MSGET nLote 				PICTURE "@E 999,999.99" SIZE 100, 010 OF oDlg PIXEL

		_nLin += _nTLin
		@ _nLin, 015 SAY "Base Economica" 					SIZE 040, 007 OF oDlg PIXEL
		@ _nLin, 060 MSGET dBase 							SIZE 100, 010 OF oDlg PIXEL

		If SZ2->Z2_CLIENTE = '000018'
			_nLin += _nTLin
			@ _nLin, 015 SAY "TX Dollar" 					SIZE 040, 007 OF oDlg PIXEL
			@ _nLin, 060 MSGET nTxDollar 		PICTURE "@E 99.999" SIZE 100, 010 OF oDlg PIXEL
		Endif

		_nLin += _nTLin
		@ _nLin, 015 SAY _cDesc1							SIZE 040, 007 OF oDlg PIXEL
		@ _nLin, 060 MSGET cIngles 		When .F.			SIZE 100, 010 OF oDlg PIXEL

		_nLin += _nTLin
		@ _nLin, 015 SAY _cDesc2 							SIZE 040, 007 OF oDlg PIXEL
		@ _nLin, 060 MSGET cPortu	PICTURE "@!"			SIZE 100, 010 OF oDlg PIXEL

		If SZ2->Z2_CLIENTE $ '000017/000018/000063'
			_lClick := .T.
			_nLin += _nTLin
			@ _nLin,015 CHECKBOX _oCheck VAR _lClick PROMPT "Processa Programações" 	SIZE 100,007 PIXEL OF oDlg
		Endif

		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,&(bOk),&(bCancel))

		If lSave

			Begin Transaction

				SZ2->(RecLock("SZ2",.F.))
				SZ2->Z2_PRODUTO	:= cProduto
				SZ2->Z2_DNP		:= nDNP
				SZ2->Z2_DTBAS01	:= dBase
				SZ2->Z2_TXCAM01	:= nTxDollar
				SZ2->Z2_LOTEMIN	:= nLote
				SZ2->Z2_ATIVO	:= '1'
				SZ2->Z2_DTCOINF	:= dDataBase
				SZ2->Z2_PRECO01	:= nPrecoCro
				If _lRev
					SZ2->Z2_REVISAO := cRevisao
					SZ2->Z2_DTREF01 := dRef
					SZ2->Z2_DESCCLI	:= Alltrim(cPortu)
				Else
					SZ2->Z2_DESCCLI	:= cIngles +' / '+Alltrim(cPortu)
				Endif
				SZ2->(MsUnlock())

				If _lClick
					ShowProg()
				Endif

			End Transaction

		Endif

	Else

		Alert('Cadastro não pode ser alterado!')

	Endif

Return



Static Function CR03PROD()

	Local _lRet := .T.

	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(xFilial('SB1')+cProduto))
		If SB1->B1_MSBLQL = '1'
			_lRet := .F.
			Alert('Produto Bloqueado!')
			cProduto := Space(15)
		Endif

		If SB1->B1_PESO = 0
			_lRet := .F.
			Alert('Peso Líquido não informado no cadastro de Produto!')
			cProduto := Space(15)
		Endif

	Else
		Alert('Produto não encontrado!')
		cProduto := Space(15)
		_lRet := .F.
	Endif

Return (_lRet)



Static Function ShowProg()

	Local _aListBox	:= {}
	Local _cQuery 	:= ""
	Local _oDlg2	:= Nil
	Local _oListBox := Nil

	Local _cItem 	:= '01'
	Local _aCabec 	:= {}
	Local _aItens 	:= {}

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .f. // Determina se as mensagens de help devem ser direcionadas para o arq. de log

	If Select("TSZ4") > 0
		TSZ4->(dbCloseArea())
	Endif

	_cQuery := " SELECT R_E_C_N_O_ AS Z4RECNO,* FROM "+RetSqlName("SZ4")+" Z4 " + CRLF
	_cQuery += " WHERE Z4.D_E_L_E_T_ = '' AND Z4_FILIAL = '"+xFilial("SZ4")+"' " + CRLF
	_cQuery += " AND Z4_CODCLI = '"+SZ2->Z2_CLIENTE+"' " + CRLF
	_cQuery += " AND Z4_LOJA = '"+SZ2->Z2_LOJA+"' " + CRLF
	_cQuery += " AND Z4_PRODCLI = '"+SZ2->Z2_CODCLI+"' " + CRLF
	_cQuery += " AND Z4_PEDIDO = '"+SZ2->Z2_PEDCLI+"' " + CRLF
	_cQuery += " AND Z4_PRODPAS = '' " + CRLF
	_cQuery += " AND Z4_INTEGR <> 'S' " + CRLF
	_cQuery += " AND Z4_QTENT > 0 " + CRLF

	TcQuery _cQuery New Alias "TSZ4"

	Count To _nTSZ4

	If _nTSZ4 = 0
		MsgAlert("Não foi encontrado programações para processamento!")
		Return(Nil)
	Endif

	TcSetField("TSZ4","Z4_DTDIGIT","D")
	TcSetField("TSZ4","Z4_DTENT","D")
	TcSetField("TSZ4","Z4_DTFECH","D")

	TSZ4->(dbGoTop())

	While TSZ4->(!EOF())

		AADD(_aListBox,{.T.							,; //01
		TSZ4->Z4_DTDIGIT							,; //02
		TSZ4->Z4_DTENT								,; //03
		TSZ4->Z4_DTFECH								,; //04
		TSZ4->Z4_QTENT								,; //05
		TSZ4->Z4_TPPED								,; //06
		TSZ4->Z4_ULTNF								,; //07
		TSZ4->Z4_QTACUM								,; //08
		TSZ4->Z4_NOMARQ								,; //09
		TSZ4->Z4_ALTTEC								,; //10
		TSZ4->Z4_SEMATU								,; //11
		TSZ4->Z4_LOCDEST							,; //12
		TSZ4->Z4_LOCDEST							,; //13
		TSZ4->Z4RECNO								,; //14
		TSZ4->Z4_ALTENG								,; //15
		TSZ4->Z4_POLINE								}) //16

		TSZ4->(dbSkip())
	EndDo

	TSZ4->(dbCloseArea())

	_oOk   := LoadBitmap(GetResources(), "LBOK")
	_oNo   := LoadBitmap(GetResources(), "LBNO")

	DEFINE DIALOG _oDlg2 TITLE "Programações não Integradas" FROM 0,0 TO 200,800	OF _oDlg2 PIXEL Style DS_MODALFRAME

	@ 005,005 TO 075,395 LABEL "" OF _oDlg2 PIXEL

	_oDlg2:lEscClose := .F. //Não permite fechar a janela pelo botão "ESC"

	_oListbox := TWBrowse():New( 10,10,380,060,,{'','Data Integração','Data Entrega','Data Fechamento','Quantidade','Tipo','Ult. NF','Acumulado','Arquivo'},,;
	_oDlg2,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

	_oListbox:SetArray(_aListBox)
	_oListbox:bLine := {||{If(_aListBox[_oListbox:nAt,1],_oOk,_oNo ),_aListBox[_oListbox:nAt,2],_aListBox[_oListbox:nAt,3],;
	_aListBox[_oListbox:nAt,4],;
	Transform(_aListBox[_oListbox:nAt,5],"@E 9,999,999.99"),;
	_aListBox[_oListbox:nAt,6],;
	_aListBox[_oListbox:nAt,7],;
	Transform(_aListBox[_oListbox:nAt,8],"@E 9,999,999.99"),;
	_aListBox[_oListbox:nAt,9] }}

	_oListbox:bLDblClick := {|| _aListBox[_oListbox:nAt][1] := !_aListBox[_oListbox:nAt][1]}

	_oListBox:bHeaderClick := {|o, _nCol| If(_nCol = 1,MarkAll(_aListBox,_oListbox),Nil) }

	_oTButOk	:= TButton():New( 080, 010, "OK"	,_oDlg2,{||_oDlg2:End()}	, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE MSDIALOG _oDlg2 CENTERED

	If !Empty(_aListBox)

		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial("SA1")+SZ2->Z2_CLIENTE+SZ2->Z2_LOJA))

		//		If SZ2->Z2_CLIENTE = '000017'
		If SZ2->Z2_CLIENTE != '000018'

			_cNum := GetSxeNum("SC5","C5_NUM")

			SF4->(dbSetOrder(1))
			SF4->(dbSeek(xFilial("SF4")+SZ2->Z2_TES))

			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+SZ2->Z2_PRODUTO))

			If SZ2->Z2_CLIENTE = '000017'
				_nPerDes := 0

				If Substr(SZ2->Z2_PEDCLI,1,4) $ "QAPC/QAPP/QHPP"
					If SB1->B1_PICM == 12
						_nPerDes := Val(Tabela("Z8","12"))
					Else
						_nPerDes := Val(Tabela("Z8","18"))
					Endif
				Endif

				_nValor   := SZ2->Z2_PRECO01 - (SZ2->Z2_PRECO01 * (_nPerDes/100))
			Else
				_nValor   := SZ2->Z2_PRECO01
			Endif

			_nPrcVen := Round(_nValor,5)

			For F := 1 To Len(_aListBox)
				If _aListBox[F][1]

					_aLinha := {}

					aadd(_aLinha,{"C6_NUM"     , _cNUm						,Nil})
					aadd(_aLinha,{"C6_ITEM"    , _cItem						,Nil})
					aadd(_aLinha,{"C6_CPROCLI" , SZ2->Z2_CODCLI				,Nil})
					aadd(_aLinha,{"C6_PRODUTO" , SZ2->Z2_PRODUTO			,Nil})
					aadd(_aLinha,{"C6_REVPED"  , _aListBox[F][10]			,Nil})
					aadd(_aLinha,{"C6_QTDVEN"  , _aListBox[F][5]			,Nil})
					//				aadd(_aLinha,{"C6_PRCVEN"  , SZ2->Z2_PRECO01			,Nil})
					aadd(_aLinha,{"C6_PRCVEN"  , _nPrcVen					,Nil})
					//				aadd(_aLinha,{"C6_VALOR"   , Round(( _aListBox[F][5] * SZ2->Z2_PRECO01 ),2)		,Nil})
					aadd(_aLinha,{"C6_VALOR"   , Round(( _aListBox[F][5] * _nPrcVen ),2)		,Nil})
					aadd(_aLinha,{"C6_ENTREG"  , _aListBox[F][3]				,Nil})

					If _aListBox[F][6] == "1"
						aadd(_aLinha,{"C6_PEDAMOS" , "N"					,Nil})
					ElseIf _aListBox[F][6]== "2"
						aadd(_aLinha,{"C6_PEDAMOS" , "I"					,Nil})
					ElseIf _aListBox[F][6] == "3"
						aadd(_aLinha,{"C6_PEDAMOS" , "M"					,Nil})
					ElseIf _aListBox[F][6] == "4"
						aadd(_aLinha,{"C6_PEDAMOS" , "Z"					,Nil})
					Endif

					aadd(_aLinha,{"C6_YDTFECH"  , _aListBox[F][4]				,Nil})

					If SZ4->Z4_TIPO == "A"
						aadd(_aLinha,{"C6_PEDAMOS" , "A"					,Nil})
					Endif

					aadd(_aLinha,{"C6_TES"     , SZ2->Z2_TES				,Nil})

					If SA1->A1_EST == "SP"
						_cCf        := "5"
					ElseIf SA1->A1_EST == "EX"
						_cCf        := "7"
					Else
						_cCF        := "6"
					Endif

					aadd(_aLinha,{"C6_CF"      , _cCf + Substr(SF4->F4_CF,2,3)		,Nil})
					aadd(_aLinha,{"C6_UM"      , SB1->B1_UM				,Nil})
					aadd(_aLinha,{"C6_PEDCLI"  , SZ2->Z2_PEDCLI			,Nil})
					//				aadd(_aLinha,{"C6_POLINE"  , "1"					,Nil})
					aadd(_aLinha,{"C6_DESCRI"  , SB1->B1_DESC			,Nil})
					aadd(_aLinha,{"C6_LOCAL"   , SB1->B1_LOCPAD			,Nil})
					aadd(_aLinha,{"C6_CLI"     , SZ2->Z2_CLIENTE		,Nil})
					aadd(_aLinha,{"C6_LOJA"    , SZ2->Z2_LOJA			,Nil})
					//				aadd(_aLinha,{"C6_PRUNIT"  , SZ2->Z2_PRECO01		,Nil})
					aadd(_aLinha,{"C6_PRUNIT"  , _nPrcVen				,Nil})
					aadd(_aLinha,{"C6_TPOP"    , "F"					,Nil})
					aadd(_aLinha,{"C6_IDENCAT" , _aListBox[F][11]		,Nil})
					aadd(_aLinha,{"C6_LA" 		, "OK"					,Nil})
					aadd(_aLinha,{"C6_CLASFIS" , SUBSTR(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB		,Nil})
					aadd(_aLinha,{"C6_LOCDEST" , _aListBox[F][12]			,Nil})

					aadd(_aItens,_aLinha)

					_cItem := Soma1(_cItem)

					SZ4->(dbGoTo(_aListBox[F][14]))

					SZ4->(RecLock("SZ4",.F.))
					SZ4->Z4_INTEGR := "S"
					SZ4->(MsUnLock())

				Endif
			Next F

			If !Empty(_aItens)

				RollBAckSx8()

				aadd(_aCabec,{"C5_NUM"     	, _cNum				,Nil})
				aadd(_aCabec,{"C5_TIPO"    	, "N"				,Nil})
				aadd(_aCabec,{"C5_CLIENTE"	, SZ2->Z2_CLIENTE	,Nil})
				aadd(_aCabec,{"C5_CLIENT"  	, SZ2->Z2_CLIENTE	,Nil})
				aadd(_aCabec,{"C5_LOJAENT" 	, SZ2->Z2_LOJA		,Nil})
				aadd(_aCabec,{"C5_LOJACLI" 	, SZ2->Z2_LOJA		,Nil})
				aadd(_aCabec,{"C5_TRANSP"  	, SA1->A1_TRANSP	,Nil})
				aadd(_aCabec,{"C5_TIPOCLI" 	, SA1->A1_TIPO		,Nil})
				aadd(_aCabec,{"C5_CONDPAG" 	, SA1->A1_COND		,Nil})
				aadd(_aCabec,{"C5_TIPLIB"  	, "1"				,Nil})
				aadd(_aCabec,{"C5_VEND1"   	, SA1->A1_VEND		,Nil})
				aadd(_aCabec,{"C5_COMIS1"  	, SA1->A1_COMIS		,Nil})
				aadd(_aCabec,{"C5_EMISSAO" 	, dDataBase			,Nil})
				aadd(_aCabec,{"C5_PESOL"   	, 1					,Nil})
				aadd(_aCabec,{"C5_MOEDA"   	, 1					,Nil})
				aadd(_aCabec,{"C5_TXMOEDA" 	, 1					,Nil})
				aadd(_aCabec,{"C5_TPCARGA" 	, "2"				,Nil})

				MATA410(_aCabec,_aItens,3)

				If lMsErroAuto
					MostraErro()
				EndIf
			Endif

		ElseIf SZ2->Z2_CLIENTE = '000018'

			_cItemExp := 0

			_cCodCli  := SA1->A1_COD
			_cLoja    := SA1->A1_LOJA
			_cNome    := SA1->A1_NOME

			_cEnd1    := SA1->A1_END
			_cLoja    := SA1->A1_LOJA
			_cNome    := SA1->A1_NOME
			_cCodCli  := SA1->A1_COD
			_cEnd1a   := EECMEND("SA1",1,SA1->A1_COD+SA1->A1_LOJA,.T.,,2)

			_cVia     := ""
			_cDestino := ""
			_cOrigem  := ""

			SYR->(dbSetOrder(1))
			If SYR->(dbSeek(xFilial("SYR")+SA1->A1_DEST_1))
				_cVia     := SYR->YR_VIA
				_cDestino := SYR->YR_DESTINO
				_cOrigem  := SYR->YR_ORIGEM
			Endif

			_cCondPgt := ''
			_cDisPa   := 0
			_cDescPA  := ''

			SY6->(dbSetOrder(1))
			If SY6->(dbSeek(xFilial("SY6")+SA1->A1_CONDPAG))
				_cCondPgt := SY6->Y6_COD
				_cDisPa   := SY6->Y6_DIAS_PA

				SYP->(dbSetOrder(1))
				If SYP->(dbSeek(xFilial("SYP")+SZ9->Z9_CODMEMO))
					_cDescPA := Alltrim(SYP->YP_TEXTO)
				Endif
			Endif

			SA2->(dbSetOrder(1))
			If SA2->(dbSeek(xFilial("SA2")+"000000"))
				_cBairro  := Alltrim(SA2->A2_BAIRRO)
				_cMun     := Alltrim(SA2->A2_MUN)
				_cEst     := Alltrim(SA2->A2_EST)
				_cCep     := Alltrim(SA2->A2_CEP)
				_cEnd2    := SA2->A2_END
				_cName    := Alltrim(SA2->A2_NOME)
			Endif

			EE3->(dbsetOrder(1))
			EE3->(dbseek(xFilial("EE3")+"X"))

			SF4->(dbSetOrder(1))
			SF4->(dbSeek(xFilial("SF4")+SZ2->Z2_TES))

			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+SZ2->Z2_PRODUTO))

			_nPosIPI := SB1->B1_POSIPI
			_cUM     := SB1->B1_UM
			_lEnt    := .F.

			Begin Transaction

				_cItem    := "01"
				_cItemExp := 1

				For F := 1 To Len(_aListBox)

					If _aListBox[F][1]
						If !_lEnt
							_cNum     := GETSXENUM("SC5","C5_NUM")
							CONFIRMSX8()

							SC5->(RecLock("SC5",.T.))
							SC5->C5_FILIAL  := xFilial("SC5")
							SC5->C5_NUM     := _cNum
							SC5->C5_TIPO    := "N"
							SC5->C5_CLIENTE := SZ2->Z2_CLIENTE
							SC5->C5_LOJAENT := SZ2->Z2_LOJA
							SC5->C5_LOJACLI := SZ2->Z2_LOJA
							SC5->C5_TRANSP  := SA1->A1_TRANSP
							SC5->C5_TIPOCLI := SA1->A1_TIPO
							SC5->C5_CONDPAG := SA1->A1_COND
							SC5->C5_TIPLIB  := "1"
							SC5->C5_VEND1   := SA1->A1_VEND
							SC5->C5_COMIS1  := SA1->A1_COMIS
							SC5->C5_EMISSAO := dDataBase
							SC5->C5_PESOL   := 1
							SC5->C5_MOEDA   := 1
							SC5->C5_TXMOEDA := 1
							SC5->C5_TPCARGA := "2"
							SC5->C5_PEDEXP  := _cNum
							SC5->(MsUnlock())
							//			End Transaction

							//			Begin Transaction
							EE7->(RecLock("EE7",.T.))
							EE7->EE7_AMOSTR := "2"
							EE7->EE7_BELOJA := "01"
							EE7->EE7_BENEDE := _cName
							EE7->EE7_BENEF  := "000000"
							EE7->EE7_BRUEMB := "1"  // Peso da Embalagem
							EE7->EE7_CALCEM := "1"  // sempre "Volume"
							EE7->EE7_CONDPA := _cCondPgt
							EE7->EE7_DIASPA := _cDisPa
							EE7->EE7_DEST   := _cDestino
							EE7->EE7_DTPEDI := dDataBase
							EE7->EE7_DTPROC := dDataBase
							EE7->EE7_END2BE := _cBairro + " - " + _cMun + " - " + _cEst + " - Brazil - C.E.P " + _cCep
							EE7->EE7_END2IM := _cEnd1a
							EE7->EE7_ENDBEN := _cEnd2
							EE7->EE7_ENDIMP := _cEnd1
							EE7->EE7_EXLIMP := "2"
							EE7->EE7_FATURA := dDataBase
							EE7->EE7_FORN   := "000000"
							EE7->EE7_FOLOJA := "01"
							EE7->EE7_FRPPCC := "CC"
							EE7->EE7_IDIOMA := "INGLES-INGLES"
							EE7->EE7_IMPORT := _cCodCli
							EE7->EE7_IMLOJA := _cLoja
							EE7->EE7_IMPODE := _cNome
							EE7->EE7_CLIENT := _cCodCli
							EE7->EE7_CLLOJA := _cLoja
							EE7->EE7_INCOTE := "EXW"
							EE7->EE7_INCO2  := "EXW"
							EE7->EE7_MOEDA  := "US$"
							EE7->EE7_MPGEXP := "003"
							EE7->EE7_ORIGEM := _cOrigem
							EE7->EE7_PEDFAT := _cNum
							EE7->EE7_PEDIDO := _cNum
							EE7->EE7_PGTANT := "2"
							EE7->EE7_PRECOA := "1"
							EE7->EE7_RESPON := EE3->EE3_NOME
							EE7->EE7_STATUS := "B"
							EE7->EE7_STTDES := "Aguardando Faturamento"
							EE7->EE7_TIPCOM := "2"
							EE7->EE7_TIPCVL := "1"
							EE7->EE7_TIPTRA := "3"
							EE7->EE7_VIA    := _cVia
							EE7->EE7_DECQTD := 2
							EE7->EE7_DECPRC := 4
							EE7->EE7_DECPES := 3
							EE7->EE7_INTERM := "2"
							EE7->EE7_COND2  := _cCondPgt
							EE7->EE7_DIAS2  :=  _cDisPa
							EE7->EE7_GPV    := "S"
							EE7->(MsUnlock())

						Endif

						_lEnt := .T.

						SC6->(RecLock("SC6",.T.))
						SC6->C6_FILIAL  := xFilial("SC6")
						SC6->C6_NUM     := _cNUm
						SC6->C6_ITEM    := _cItem
						SC6->C6_CPROCLI := SZ2->Z2_CODCLI
						SC6->C6_PRODUTO := SZ2->Z2_PRODUTO
						SC6->C6_REVPED  := _aListBox[F][10]
						SC6->C6_REVENG  := _aListBox[F][15]
						SC6->C6_QTDVEN  := _aListBox[F][5]
						SC6->C6_PRCVEN  := SZ2->Z2_PRECO01
						SC6->C6_VALOR   := Round(( _aListBox[F][5] * SZ2->Z2_PRECO01 ),2)
						SC6->C6_ENTREG  := _aListBox[F][3]
						SC6->C6_PEDAMOS := _aListBox[F][6]
						SC6->C6_TES     := SZ2->Z2_TES
						SC6->C6_CF      := "7" + Substr(SF4->F4_CF,2,3)
						SC6->C6_UM      := SB1->B1_UM
						SC6->C6_PEDCLI  := SZ2->Z2_PEDCLI
						SC6->C6_DESCRI  := SZ2->Z2_DESCCLI
						SC6->C6_LOCAL   := SB1->B1_LOCPAD
						SC6->C6_CLI     := SZ2->Z2_CODCLI
						SC6->C6_LOJA    := SZ2->Z2_LOJA
						SC6->C6_PRUNIT  := SZ2->Z2_PRECO01
						SC6->C6_TPOP    := "F"
						SC6->C6_IDENCAT := DTOS(dDataBase)
						SC6->C6_CLASFIS := SUBSTR(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB
						SA3->(dbSetOrder(1))
						If SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND))
							SC6->C6_COMIS1   := SA3->A3_COMIS
						Endif
						SC6->C6_POLINE := _aListBox[F][16]
						SC6->(MsUnlock())
						//			End Transaction

						//			Begin Transaction
						EE8->(RecLock("EE8",.T.))
						EE8->EE8_COD_I  := SZ2->Z2_PRODUTO
						_cCodDes        := GETIDMEMO()
						EE8->EE8_DESC   := _cCodDes
						EE8->EE8_TIPPED := _aListBox[F][6]
						EE8->EE8_DTENTR := _aListBox[F][3]
						EE8->EE8_DTPREM := _aListBox[F][3]
						EE8->EE8_CODCLI := SZ2->Z2_CODCLI
						EE8->EE8_EMBAL1 := SZ2->Z2_CODEMB
						EE8->EE8_FABR   := "000000"
						EE8->EE8_FALOJA := "01"
						EE8->EE8_FATIT  := _cItem
						EE8->EE8_FOLOJA := "01"
						EE8->EE8_FORN   := "000000"
						EE8->EE8_PART_N := SZ2->Z2_CODCLI
						EE8->EE8_PEDIDO := _cNUm
						EE8->EE8_POSIPI := SB1->B1_POSIPI
						EE8->EE8_PRCINC := Round(( _aListBox[F][5] * SZ2->Z2_PRECO01 ),2)
						EE8->EE8_PRCTOT := Round(( _aListBox[F][5] * SZ2->Z2_PRECO01 ),2)
						EE8->EE8_PRECO  := SZ2->Z2_PRECO01
						EE8->EE8_PRECOI := SZ2->Z2_PRECO01
						EE8->EE8_PSLQUN := SB1->B1_PESO
						EE8->EE8_QE	    := _aListBox[F][5]
						EE8->EE8_QTDEM1 := 1
						EE8->EE8_REFCLI := SZ2->Z2_PEDCLI
						EE8->EE8_SEQUEN := Padl(Alltrim(Str(_cItemExp)),6)
						EE8->EE8_SLDATU := _aListBox[F][5]
						EE8->EE8_SLDINI := _aListBox[F][5]
						EE8->EE8_UNPRC  := _cUM
						EE8->EE8_UNPES  := "KG"
						EE8->EE8_UNIDAD := _cUM
						EE8->EE8_CF     := "7" + Substr(SF4->F4_CF,2,3)
						EE8->EE8_TES    := SZ2->Z2_TES
						EE8->EE8_REVPED := _aListBox[F][10]
						EE8->EE8_REVENG := _aListBox[F][15]
						EE8->EE8_POLINE := _aListBox[F][16]
						MSMM(EE8->EE8_DESC  ,,,Alltrim(SZ2->Z2_DESCCLI)       ,1,,,"EE8","EE8_DESC")
						EE8->(MsUnlock())

						_cItem    := SomaIt(_cItem)
						_cItemExp ++

						SZ4->(dbGoTo(_aListBox[F][14]))

						SZ4->(RecLock("SZ4",.F.))
						SZ4->Z4_INTEGR := "S"
						SZ4->(MsUnLock())

					Endif
				Next F
			End Transaction

			/*
			_cNum := GetSxeNum("SC5","C5_NUM")

			SF4->(dbSetOrder(1))
			SF4->(dbSeek(xFilial("SF4")+SZ2->Z2_TES))

			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+SZ2->Z2_PRODUTO))

			_nValor   := SZ2->Z2_PRECO01
			_nPrcVen  := Round(_nValor,5)
			_cItemExp := 0

			For F := 1 To Len(_aListBox)
			If _aListBox[F][1]

			_cItemExp ++

			_aLinha := {}

			aAdd(_aLinha,{'EE8_SEQUEN'	,Padr(Str(_cItemExp),6)	, NIL})
			aAdd(_aLinha,{'EE8_COD_I'	,SZ2->Z2_PRODUTO		, NIL})
			aAdd(_aLinha,{'EE8_DESC'	,GETIDMEMO()			, NIL})
			aAdd(_aLinha,{'EE8_TIPPED'	,_aListBox[F][6]		, NIL})
			aAdd(_aLinha,{'EE8_DTENTR'	,_aListBox[F][3]		, NIL})
			aAdd(_aLinha,{'EE8_DTPREM'	,_aListBox[F][3]		, NIL})
			aAdd(_aLinha,{'EE8_FORN' 	,'000000'				, NIL})
			aAdd(_aLinha,{'EE8_FOLOJA' 	,'01'					, NIL})
			aAdd(_aLinha,{'EE8_FABR' 	,'000000'				, NIL})
			aAdd(_aLinha,{'EE8_FALOJA' 	,'01'					, NIL})
			aAdd(_aLinha,{'EE8_EMBAL1' 	,SZ2->Z2_CODEMB			, NIL})
			aAdd(_aLinha,{'EE8_CODCLI' 	,SZ2->Z2_CODCLI			, NIL})
			aAdd(_aLinha,{'EE8_PART_N' 	,SZ2->Z2_CODCLI			, NIL})
			aAdd(_aLinha,{'EE8_REFCLI' 	,SZ2->Z2_PEDCLI			, NIL})
			aAdd(_aLinha,{'EE8_POSIPI' 	,SB1->B1_POSIPI			, NIL})
			aAdd(_aLinha,{'EE8_PSLQUN' 	,SB1->B1_PESO			, NIL})
			aAdd(_aLinha,{'EE8_QTDEM1' 	,1						, NIL})
			aAdd(_aLinha,{'EE8_UNPRC' 	,SB1->B1_UM				, NIL})
			aAdd(_aLinha,{'EE8_UNPES' 	,"KG"					, NIL})
			aAdd(_aLinha,{'EE8_UNIDAD' 	,SB1->B1_UM				, NIL})
			aAdd(_aLinha,{'EE8_CF'		,"7" + Substr(SF4->F4_CF,2,3)	, NIL})
			aAdd(_aLinha,{'EE8_TES'		,SZ2->Z2_TES			, NIL})
			aAdd(_aLinha,{'EE8_QE'		, _aListBox[F][5]		, NIL})
			aAdd(_aLinha,{'EE8_SLDATU'	, _aListBox[F][5]		, NIL})
			aAdd(_aLinha,{'EE8_SLDINI'	, _aListBox[F][5]		, NIL})
			aAdd(_aLinha,{'EE8_PRECO'	, _nPrcVen				, NIL})
			aAdd(_aLinha,{'EE8_PRECOI'	, _nPrcVen				, NIL})
			aAdd(_aLinha,{'EE8_PRCINC'	, Round(( (_aListBox[F][5]) * _nPrcVen ),2)	, NIL})
			aAdd(_aLinha,{'EE8_PRCINC'	, Round(( (_aListBox[F][5]) * _nPrcVen ),2)	, NIL})
			aAdd(_aLinha,{'EE8_REVPED'	, _aListBox[F][10]		, NIL})
			aAdd(_aLinha,{'EE8_REVENG'	, _aListBox[F][15]		, NIL})
			aAdd(_aLinha,{'EE8_POLINE'	, _aListBox[F][16]		, NIL})
			//					aAdd(_aLinha,{'EE8_PEDIDO'	, _cNum					, NIL})
			//					aAdd(_aLinha,{'EE8_FATIT'	, _cItem				, NIL})
			//					aAdd(_aLinha,{'EE8_FATIT'	, Padl(Alltrim(Str(_cItemExp)),6)	, NIL})

			//					aAdd(_aLinha,{'EE8_EMBAL1' , '001' , NIL})
			//				MSMM(EE8->EE8_DESC  ,,,Alltrim(SZ2->Z2_DESCCLI)       ,1,,,"EE8","EE8_DESC")

			aadd(_aItens,_aLinha)

			_cItem := Soma1(_cItem)

			Endif
			Next F

			If !Empty(_aItens)

			SA1->(dbSetOrder(1))
			SA1->(dbSeek(xFilial("SA1")+SZ2->Z2_CLIENTE+SZ2->Z2_LOJA))

			RollBAckSx8()

			_cVia     := ""
			_cDestino := ""
			_cOrigem  := ""
			dbselectArea("SYR")
			dbSetOrder(1)
			If dbSeek(xFilial("SYR")+SA1->A1_DEST_1)
			_cVia     := SYR->YR_VIA
			_cDestino := SYR->YR_DESTINO
			_cOrigem  := SYR->YR_ORIGEM
			Endif

			_cCondPgt := ''
			_cDisPa   := 0
			_cDescPA  := ''
			SY6->(dbSetOrder(1))
			If SY6->(dbSeek(xFilial("SY6")+SA1->A1_CONDPAG))
			_cCondPgt := SY6->Y6_COD
			_cDisPa   := SY6->Y6_DIAS_PA

			SYP->(dbSetOrder(1))
			If SYP->(dbSeek(xFilial("SYP")+SZ9->Z9_CODMEMO))
			_cDescPA := Alltrim(SYP->YP_TEXTO)
			Endif
			Endif

			_cBairro  := _cMun := _cEst := _cCep := _cEnd2 := _cName := ''
			SA2->(dbSetOrder(1))
			If SA2->(dbSeek(xFilial("SA2")+"000000"))
			_cBairro  := Alltrim(SA2->A2_BAIRRO)
			_cMun     := Alltrim(SA2->A2_MUN)
			_cEst     := Alltrim(SA2->A2_EST)
			_cCep     := Alltrim(SA2->A2_CEP)
			_cEnd2    := SA2->A2_END
			_cName    := Alltrim(SA2->A2_NOME)
			Endif

			EE3->(dbsetOrder(1))
			EE3->(dbseek(xFilial("EE3")+"X"))

			_cEnd1    := SA1->A1_END
			_cEnd1a   := EECMEND("SA1",1,SA1->A1_COD+SA1->A1_LOJA,.T.,,2)
			_cNome    := SA1->A1_NOME


			aadd(_aCabec,{"EE7_FILIAL"	, xFilial("EE7")	,Nil})
			aadd(_aCabec,{"EE7_AMOSTR"  , "2"				,Nil})
			aadd(_aCabec,{"EE7_BENEF"   , "000000"			,Nil})
			aadd(_aCabec,{"EE7_BELOJA"  , "01"				,Nil})
			aadd(_aCabec,{"EE7_BENEDE"  , _cName			,Nil})
			aadd(_aCabec,{"EE7_BRUEMB"  , "1"				,Nil})
			aadd(_aCabec,{"EE7_CALCEM"  , "1"				,Nil})
			aadd(_aCabec,{"EE7_IMPORT"	, SZ2->Z2_CLIENTE	,Nil})
			aadd(_aCabec,{"EE7_IMLOJA"	, SZ2->Z2_LOJA		,Nil})
			aadd(_aCabec,{"EE7_IMPODE"  , _cNome			,Nil})
			aadd(_aCabec,{"EE7_FORN"	, "000000"			,Nil})
			aadd(_aCabec,{"EE7_FOLOJA"  , "01"				,Nil})
			aadd(_aCabec,{"EE7_FORNDE" 	, _cName			,Nil})
			aadd(_aCabec,{"EE7_IDIOMA" 	, "INGLES-INGLES"	,Nil})
			aadd(_aCabec,{"EE7_EXLIMP" 	, "2"				,Nil})
			aadd(_aCabec,{"EE7_FATURA" 	, dDataBase			,Nil})
			aadd(_aCabec,{"EE7_FRPPCC"  , "CC"				,Nil})
			aadd(_aCabec,{"EE7_CLIENT"  , SZ2->Z2_CLIENTE	,Nil})
			aadd(_aCabec,{"EE7_CLLOJA"  , SZ2->Z2_LOJA		,Nil})
			aadd(_aCabec,{"EE7_INCOTE" 	, "EXW"				,Nil})
			aadd(_aCabec,{"EE7_INCO2"   , "EXW"				,Nil})
			aadd(_aCabec,{"EE7_MOEDA"   , "US$"				,Nil})
			aadd(_aCabec,{"EE7_MPGEXP" 	, "003"				,Nil})
			aadd(_aCabec,{"EE7_CONDPA" 	, _cCondPgt			,Nil})
			aadd(_aCabec,{"EE7_DIASPA" 	, _cDisPa			,Nil})
			aadd(_aCabec,{"EE7_DESCPA" 	, _cDescPA			,Nil})
			aadd(_aCabec,{"EE7_DEST" 	, _cDestino			,Nil})
			aadd(_aCabec,{"EE7_DTPEDI" 	, dDataBase			,Nil})
			aadd(_aCabec,{"EE7_DTPROC" 	, dDataBase			,Nil})
			aadd(_aCabec,{"EE7_END2BE" 	, _cBairro + " - " + _cMun + " - " + _cEst + " - Brazil - C.E.P " + _cCep	,Nil})
			aadd(_aCabec,{"EE7_END2IM" 	, _cEnd1a			,Nil})
			aadd(_aCabec,{"EE7_ENDBEN" 	, _cEnd2			,Nil})
			aadd(_aCabec,{"EE7_ENDIMP" 	, _cEnd1			,Nil})
			aadd(_aCabec,{"EE7_PEDFAT" 	, _cNum				,Nil})
			aadd(_aCabec,{"EE7_PEDIDO" 	, _cNum				,Nil})
			aadd(_aCabec,{"EE7_PGTANT" 	, "2"				,Nil})
			aadd(_aCabec,{"EE7_PRECOA" 	, "1"				,Nil})
			aadd(_aCabec,{"EE7_RESPON" 	, EE3->EE3_NOME		,Nil})
			aadd(_aCabec,{"EE7_INTERM" 	, "2" 				,Nil})
			aadd(_aCabec,{"EE7_COND2" 	, _cCondPgt			,Nil})
			aadd(_aCabec,{"EE7_DIAS2" 	, _cDisPa			,Nil})
			aadd(_aCabec,{"EE7_GPV" 	, "S"				,Nil})
			aadd(_aCabec,{"EE7_STATUS" 	, "B"				,Nil})
			aadd(_aCabec,{"EE7_STTDES" 	, "Aguardando Faturamento"	,Nil})
			aadd(_aCabec,{"EE7_TIPCOM" 	, "2"				,Nil})
			aadd(_aCabec,{"EE7_TIPCVL" 	, "1"				,Nil})
			aadd(_aCabec,{"EE7_TIPTRA" 	, "3"				,Nil})
			aadd(_aCabec,{"EE7_DECQTD" 	, 2					,Nil})
			aadd(_aCabec,{"EE7_DECPRC" 	, 2					,Nil})
			aadd(_aCabec,{"EE7_DECPES" 	, 2					,Nil})

			//				aadd(_aCabec,{"EE7_PAISET" 	, "105"				,Nil})
			//				aadd(_aCabec,{"EE7_ORIGEM" 	, _cOrigem			,Nil})
			//				aadd(_aCabec,{"EE7_VIA" 	, _cVia				,Nil})


			//				{'EE7_DSCMPE' ,"COBRANCA" ,NIL};
			//				{'EE7_VIA' ,'02' ,NIL};
			//				{'EE7_VIA_DE' ,"VIA TRANSP." ,NIL};
			//				{'EE7_ORIGEM' ,'AGA' ,NIL};
			//				{'EE7_DSCORI' ,"ACEGUA-RS" ,NIL};
			//				{'EE7_DEST' ,'VYX' ,NIL};
			//				{'EE7_DSCDES' ,"VITORIA-ES" ,NIL};
			//				{'EE7_PAISET' ,'105' ,NIL};

			MSExecAuto( {|X,Y,Z| EECAP100(X,Y,Z)},_aCabec ,_aItens, 3)

			If lMsErroAuto
			lRetorno := .F.
			MostraErro()
			Else
			lRetorno:=.T.
			EndIf

			//				MATA410(_aCabec,_aItens,3)
			//
			//				If lMsErroAuto
			//					MostraErro()
			//				EndIf
			*/
		Endif

	Endif

Return(Nil)

/*
Static Function CheckBox(_aListBox,_oListbox)

_aListBox[_oListbox:nAt][1] := !_aListBox[_oListbox:nAt][1]

_oListbox:Refresh()

Return
*/

Static Function MarkAll(_aListBox,_oListbox)

	Local _nInd		:= 1 	// Conteudo de retorno
	Local _lMark	:= !_aListBox[1][1]

	For _nInd := 1 To Len(_aListBox)
		_aListBox[_nInd][1] := _lMark
	Next

	_oListBox:Refresh()

Return(Nil)
