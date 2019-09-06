#INCLUDE "PROTHEUS.CH"
#include 'TBICONN.ch'
#include 'TOPCONN.ch'

/*/
Data		: 13/08/2012
Programa	: CR0021
Descrição	: Inclusão de DNP
/*/

User Function CR0021()

	Private cCadastro := "Abertura de DNP"
	Private aRotina := { {"Pesquisar"	,"AxPesqui"		,0,1} ,;
		{"Visualizar"	,"AxVisual"		,0,2} ,;
		{"Incluir"		,"AxInclui"		,0,3} ,;
		{"Alterar"		,If(Empty(SZF->ZF_STATUS) .Or. SZF->ZF_STATUS = "IM","AxAltera",'Alert("Processo não pode ser alterado.")')	,0,4} ,;
		{"Excluir"		,If(Empty(SZF->ZF_STATUS) .Or. SZF->ZF_STATUS = "IM","AxDeleta",'Alert("Processo não pode ser excluído.")')	,0,5} ,;
		{"Imprimir"	,"U_CR0022()"		,0,6} ,;
		{"Efetivar"	,"U_CR21Fin()"	,0,7} ,;
		{"Legenda"		,"U_CR21LEG()"	,0,8} }

	_aCor := {	{"Empty(ZF_STATUS)"  ,'BR_BRANCO'  },;
		{"ZF_STATUS = 'IM'"  ,'BR_AMARELO'	},;
		{"ZF_STATUS = 'OK'"  ,'BR_VERDE'	},;
		{"ZF_STATUS = 'NO'"  ,'BR_VERMELHO'} }


	Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

	Private cString := "SZF"

	dbSelectArea("SZF")
	dbSetOrder(1)

	dbSelectArea(cString)
	mBrowse( 6,1,22,75,cString,,,,, 2,_aCor )

	Return


//Legenda
User Function CR21LEG()

	BrwLegenda("Legenda","Controle de DNP"	,;
		{{"BR_BRANCO" 	, "DNP nao Impresso"							}	,;
		{"BR_AMARELO" 	, "DNP Impresso, aguardando efetivacao"	}	,;
		{"BR_VERDE"		, "Efetivado"									}  	,;
		{"BR_VERMELHO"	, "Não Efetivado"								}})


/*
{"BR_PINK"    , "Packing List Incompleto"} ,;
{"BR_CINZA"    , "Packing List Incompleto"} ,;
{"BR_MARROM"    , "Packing List Incompleto"} ,;
{"BR_LARANJA"    , "Packing List Incompleto"} ,;
{"LIGHTBLU"    , "Packing List Incompleto"} ,;
{"LIGHTGRE"    , "Packing List Incompleto"} ,;
{"BR_CANCEL"    , "Packing List Incompleto"} ,;
{"BR_PRETO"    , "Packing List Incompleto"} ,;
*/
	Return(NIL)



//Status
User Function CR21Fin()

	LOCAL oWindow := NIL
	Local	oWindow,;
		oFontWin,;
		aFolders	:= {},;
		aHead		:= {},;
		bOk 		:= '{ || Iif(Iif(Left(_cCodcli,6) = "000018",!Empty(_cProd).and.!Empty(_cDesc).and.!Empty(_cOC).and.!Empty(_cTES).and._nLote > 0.and.!Empty(_dDtRef).and.!Empty(_dBasEcon).and.!Empty(_cDtCode).and._nTxCamb > 0,!Empty(_cProd).and.!Empty(_cDesc).and.!Empty(_cOC).and.!Empty(_cTES).and._nLote > 0.and.!Empty(_dDtRef).and.!Empty(_dBasEcon)),(lSave:=.t.,oWindow:End()),Nil) }',;
		bCancel 	:= '{ || lSave:=.f. , oWindow:End() }',;
		aButtons	:= {},;
		_cStat		:= SZF->ZF_STATUS

	Private _cDNP		:= Space(6),;
		_cCodcli	:= Space(15),;
		_cProd		:= Space(15),;
		_cProdCli	:= Space(15),;
		_cUM		:= Space(2),;
		_cDesc		:= Space(60),;
		_cRev		:= Space(15),;
		_cOC		:= Space(15),;
		_cTES		:= Space(3),;
		_cMen		:= Space(3),;
		_cDtCode	:= Space(10),;
		_nLote		:= 0,;
		_nPrcVen	:= 0,;
		_dDtRef	:= Ctod('  /  /  '),;
		_dBasEcon	:= Ctod('  /  /  '),;
		_nTxCamb	:= 0,;
		_cIPB		:= Space(20),;
		_cHallib	:= Space(20),;
		_cBacker	:= Space(20),;
		_cWeathe	:= Space(20)

	Private lSave		:= .f.			// Variavel controla se tem ou nao que salvar.

	_cDNP		:= SZF->ZF_CODDNP
	_cNome 	:= Posicione("SA1",1,xFilial("SZF")+SZF->ZF_CLIENTE+SZF->ZF_LOJA,"A1_NOME")
	_cCodcli  	:= SZF->ZF_CLIENTE+"/"+SZF->ZF_LOJA+" - "+Alltrim(_cNome)
	_cProdCli	:= SZF->ZF_CODCLI
	_cUM		:= SZF->ZF_UM
	_cRev     	:= SZF->ZF_REVISAO
	_nPrcVen	:= SZF->ZF_PRECO
	_dDtRef	:= SZF->ZF_EMISSAO
	_dBasEcon	:= LastDay(SZF->ZF_EMISSAO)

	If SZF->ZF_STATUS == 'IM'

		If MsgYesNo("Deseja efetivar a cotação e gerar cadastro de Produto X Cliente?")

			PRIVATE cTitulo  := "Pré-cadastro Prod. X Cliente"
			Private _nOpc    := 0

			DEFINE MSDIALOG oWindow FROM 0,0 TO 500,550 TITLE cTitulo PIXEL

			DEFINE FONT oFontWin NAME 'Arial' SIZE 6, 15 BOLD
			DEFINE FONT oFontMemo NAME 'Courier New' SIZE 0,15

			@ 005, 005 Say OemToAnsi('DNP:') Size 023, 007 Of oWindow Pixel
			@ 005, 040 MsGet _cDNP 			 Size 200, 010 When .F. Font oFontWin Of oWindow Pixel

			@ 020, 005 Say OemToAnsi('Cliente:') Size 023, 007 Of oWindow Pixel
			@ 020, 040 MsGet _cCodcli 			 Size 200, 010 When .F. Font oFontWin Of oWindow Pixel

			aAdd(aFolders,OemToAnsi('&Dados Cadastrais'))
			aAdd(aHead,'HEADER 1')
			aAdd(aFolders,OemToAnsi('&Dados/Ref. Comerciais'))
			aAdd(aHead,'HEADER 2')

			oFolder := TFolder():New(035,005,aFolders,aHead,oWindow,,,,.T.,.F.,250,192)

//³Dados Cadastrais³
			@ 005,005 SAY OemToAnsi('*Produto Pasy:') 	Size 050,007 OF oFolder:aDialogs[1] PIXEL
			@ 005,060 MsGet _cProd   						Picture("@!") Size 150,010 F3 'SB1' Valid xValid(1)  OF oFolder:aDialogs[1] PIXEL

			@ 020,005 SAY OemToAnsi('*Produto Cliente:') 	Size 050,007 OF oFolder:aDialogs[1] PIXEL
			@ 020,060 MsGet _cProdCli  						Size 150,010 When .F. OF oFolder:aDialogs[1] PIXEL

			@ 035,005 SAY OemToAnsi('*UM:') 				Size 050,007 OF oFolder:aDialogs[1] PIXEL
			@ 035,060 MsGet _cUM   							Size 150,010 When .F. OF oFolder:aDialogs[1] PIXEL

			@ 050,005 SAY OemToAnsi('*Desc. Produto:') 	Size 050,007 OF oFolder:aDialogs[1] PIXEL
			@ 050,060 MsGet _cDesc   						Picture("@!") Size 150,010 OF oFolder:aDialogs[1] PIXEL

			@ 065,005 SAY OemToAnsi('*Revisão:') 			Size 050,007 OF oFolder:aDialogs[1] PIXEL
			@ 065,060 MsGet _cRev   							Size 150,010 When .F. OF oFolder:aDialogs[1] PIXEL

			@ 080,005 SAY OemToAnsi('*OC Cliente:') 		Size 050,007 OF oFolder:aDialogs[1] PIXEL
			@ 080,060 MsGet _cOC   							Picture("@!") Size 150,010 OF oFolder:aDialogs[1] PIXEL

			@ 095,005 SAY OemToAnsi('*TES:') 				Size 050,007 OF oFolder:aDialogs[1] PIXEL
			@ 095,060 MsGet _cTES  							Picture("@!") Size 150,010 F3 'SF4' Valid xValid(2)  OF oFolder:aDialogs[1] PIXEL

			@ 110,005 SAY OemToAnsi('Mens. Padrão:') 		Size 050,007 OF oFolder:aDialogs[1] PIXEL
			@ 110,060 MsGet _cMen  							Picture("@!") Size 150,010 F3 'SM4' Valid xValid(3)  OF oFolder:aDialogs[1] PIXEL

			@ 125,005 SAY OemToAnsi('**DTCODE:') 			Size 050,007 OF oFolder:aDialogs[1] PIXEL
			@ 125,060 MsGet _cDTCODE 						Picture("@!") Size 150,010 OF oFolder:aDialogs[1] PIXEL

			@ 150,005 Say "*Campos de preenchimento obrigatório" Font oFontWin Of oFolder:aDialogs[1] Pixel
			@ 165,005 Say "**Campos de preenchimento obrigatório para Caterpillar Exportação" Font oFontWin Of oFolder:aDialogs[1] Pixel


//³Dados Comerciais³
			@ 005,005 SAY OemToAnsi('*Lote Mínimo:') 		Size 050,007 OF oFolder:aDialogs[2] PIXEL
			@ 005,060 MsGet _nLote   						PICTURE "@E 9,999,999.99" Size 150,010 OF oFolder:aDialogs[2] PIXEL

			@ 020,005 SAY OemToAnsi('*Preço Venda:') 		Size 050,007 OF oFolder:aDialogs[2] PIXEL
			@ 020,060 MsGet _nPrcVen   						PICTURE "@E 9,999,999.99" Size 150,010 OF oFolder:aDialogs[2] PIXEL

			@ 035,005 SAY OemToAnsi('*DT Referencia:')		Size 050,007 OF oFolder:aDialogs[2] PIXEL
			@ 035,060 MsGet _dDtRef 							Size 150,010 OF oFolder:aDialogs[2] PIXEL

			@ 050,005 SAY OemToAnsi('*Base Economica:') 	Size 050,007 OF oFolder:aDialogs[2] PIXEL
			@ 050,060 MsGet _dBasEcon  						Size 150,010 OF oFolder:aDialogs[2] PIXEL

			@ 065,005 SAY OemToAnsi('**TX Cambial:') 		Size 050,007 OF oFolder:aDialogs[2] PIXEL
			@ 065,060 MsGet _nTxCamb  						PICTURE "@E 9,999,999.99" Size 150,010 OF oFolder:aDialogs[2] PIXEL

			@ 080,005 SAY OemToAnsi('Ref. IPB:') 			Size 050,007 OF oFolder:aDialogs[2] PIXEL
			@ 080,060 MsGet _cIPB   							Size 150,010 OF oFolder:aDialogs[2] PIXEL

			@ 095,005 SAY OemToAnsi('Ref. Halliburton:') 		Size 050,007 OF oFolder:aDialogs[2] PIXEL
			@ 095,060 MsGet _cHallib  						Size 150,010 OF oFolder:aDialogs[2] PIXEL

			@ 110,005 SAY OemToAnsi('Ref. Backer:') 		Size 050,007 OF oFolder:aDialogs[2] PIXEL
			@ 110,060 MsGet _cBacker  						Size 150,010 OF oFolder:aDialogs[2] PIXEL

			@ 125,005 SAY OemToAnsi('Ref. Weatherford:') 	Size 050,007 OF oFolder:aDialogs[2] PIXEL
			@ 125,060 MsGet _cWeathe 						Size 150,010 OF oFolder:aDialogs[2] PIXEL

			@ 150,005 Say "*Campos de preenchimento obrigatório" Font oFontWin Of oFolder:aDialogs[2] Pixel
			@ 165,005 Say "**Campos de preenchimento obrigatório para Caterpillar Exportação" Font oFontWin Of oFolder:aDialogs[2] Pixel

			ACTIVATE MSDIALOG oWindow CENTERED ON INIT EnchoiceBar(oWindow,&(bOk),&(bCancel),,aButtons)

			If lSave

				SZ2->(RecLock("SZ2",.T.))
				SZ2->Z2_CLIENTE	:= SZF->ZF_CLIENTE
				SZ2->Z2_LOJA		:= SZF->ZF_LOJA
				SZ2->Z2_PRODUTO	:= _cProd
				SZ2->Z2_CODCLI	:= _cProdCli
				SZ2->Z2_UM			:= _cUM
				SZ2->Z2_DESCCLI	:= _cDesc //SZF->ZF_DESCCLI
				SZ2->Z2_REVISAO	:= _cRev
				SZ2->Z2_PEDCLI	:= _cOC
				SZ2->Z2_TES		:= _cTES
				SZ2->Z2_LOTEMIN	:= _nLote
				SZ2->Z2_MENPAD	:= _cMen
				SZ2->Z2_DNP		:= VAL(_cDNP)
				SZ2->Z2_PRECO01	:= _nPrcVen
				SZ2->Z2_DTREF01	:= _dDtRef
				SZ2->Z2_TXCAM01	:= _nTxCamb
				SZ2->Z2_DTBAS01	:= _dBasEcon
				SZ2->Z2_IPB		:= _cIPB
				SZ2->Z2_HALLIBU	:= _cHallib
				SZ2->Z2_BACKER	:= _cBacker
				SZ2->Z2_WEATHER	:= _cWeathe
//			SZ2->Z2_OBSREFE	:= _cObsRef
				SZ2->Z2_DTCODE	:= _cDTCODE
				SZ2->Z2_ATIVO		:= "1"
				SZ2->(MsUnlock())

				_cStat := "OK"
			Endif

		Else
			_cStat := "NO"
		Endif

		SZF->(RecLock("SZF",.F.))
		SZF->ZF_STATUS := _cStat
		SZF->(MsUnlock())

	Else
		ALERT("Processo não poderá ser efetivado, pois a legenda não está em amarelo (aguardando efetivação)")
	Endif

	Return(NIL)



Static Function xValid( nType )

	Local	lReturn	:= .f.

	Do Case
	Case	( nType == 1 ) // Produto
		If	ExistCpo('SB1',_cProd)
			lReturn := .t.
		EndIf
	Case	( nType == 2 ) // TES
		If	( !Empty(_cTES) )
			If	ExistCpo('SF4',_cTES)
				If _cTES > '500'
					lReturn := .t.
				Else
					Alert("TES digitada não é de saída!")
					lReturn := .F.
				Endif
			EndIf
		EndIf
	Case	( nType == 3 ) // Mensagem Padrão
		If( !Empty(_cMen) )
			If	ExistCpo('SM4',_cMen)
				lReturn := .t.
			EndIf
		Else
			lReturn := .t.
		EndIf
	End Case

	Return lReturn


/*
Programa  	³ GAT21_01
Data 		³ 15/08/12
Descricao 	³ Preencher o número da solicitação de cotação
*/
User Function GAT21_01()

	_aAliOri := GetArea()
	_aAliSZF := SZF->(GetArea())

	_cNrSoli := ""
//_cNrSoli := Space(15)
	If M->ZF_TEMSOLI = "N"
		_cNrSoli := dtos(M->ZF_DTSOLIC)
	Endif

	M->ZF_EMISSOR := UPPER(USRFULLNAME(RETCODUSR()))

	RestArea(_aAliSZF)
	RestArea(_aAliOri)

	Return (_cNrSoli)
