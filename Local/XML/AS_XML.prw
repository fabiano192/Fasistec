#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} AS_XML
Importação de XML
@type function
@author Fabiano
@since 21/10/2016
@version 2.0
@return Nil, Returno Nulo
@description {}

@history 27/10/16	,	Fabiano		,	Versão Original(Inicial)
@history 22/12/17	,	Fabiano		,	Incluído opção de marcar mais de 1 pedido
/*/

#Define CLR_ORANGE RGB( 255, 165, 000 )
#Define SEM_PRODUTO 0
#Define SEM_PEDIDO 1
#Define PEDIDO_DIVERGENTE 2
#Define PEDIDO_OK 3
#Define SEM_NF_ORIGINAL 4

#Define NF_OK 1
#Define NF_NOK 2
#Define NF_SEM_FORNECEDOR 3

#Define EmpFil "100940109020211000160|010107500508000106"
//#Define EmpFil "100940109020211000160"
/*
Empresas Habilitadas

Empresa: Holding
Grupo: 10 - Energia
Filial: 09401 - Lajari
CNPJ: 09.020.211/0001-60
*/

User Function AS_XML()

	If !(cEmpAnt + cFilAnt + SM0->M0_CGC) $ EmpFil
		MsgAlert("Rotina não está habilitada para ser executada nesta Filial!")
		// Return(Nil)
	Endif

	Private _oOK		:= LoadBitmap(GetResources(),'LBOK')
	Private _oNO		:= LoadBitmap(GetResources(),'LBNO')
	Private _oCheck		:= LoadBitmap(GetResources(),'WFCHK')
	Private _oUnChk		:= LoadBitmap(GetResources(),'WFUNCHK')

	Private _oRed		:= LoadBitmap(GetResources(),'BR_VERMELHO')
	Private _oGreen		:= LoadBitmap(GetResources(),'BR_VERDE')
	Private _oHBlue		:= LoadBitmap(GetResources(),'BR_AZUL_OCEAN')
	Private _oBrow		:= LoadBitmap(GetResources(),'BR_MARROM')
	Private _oBlue		:= LoadBitmap(GetResources(),'BR_AZUL')
	Private _oYellow	:= LoadBitmap(GetResources(),'BR_AMARELO')
	Private _oCancel	:= LoadBitmap(GetResources(),'BR_CANCEL')
	Private _oBlack		:= LoadBitmap(GetResources(),'BR_PRETO')
	Private _oOrange	:= LoadBitmap(GetResources(),'BR_LARANJA')
	Private _oWhite		:= LoadBitmap(GetResources(),'BR_BRANCO')

	Private _oTRed		:= LoadBitmap(GetResources(),'BR_VERMELHO.BMP')
	Private _oTYellow	:= LoadBitmap(GetResources(),'BR_AMARELO.BMP')
	Private _oTWhite	:= LoadBitmap(GetResources(),'BR_BRANCO.BMP')
	Private _oTGreen	:= LoadBitmap(GetResources(),'BR_VERDE.BMP')
	Private _oTBlue		:= LoadBitmap(GetResources(),'BR_AZUL.BMP')

	Private _aHeadCab	:= {}
	Private _aColSzCab	:= {}
	Private _aFldCab	:= {}

	Private _aHeadItem	:= {}
	Private _aColSzIte	:= {}
	Private _aFldIte	:= {}

	Private _oDlg		:= Nil
	Private _oListBox	:= Nil
	Private _oListIt	:= Nil
	//	Private _aXML 		:= {{.F.,'','','','',cTod(''),'','','','',''}}
	Private _aXML 		:= {{}}
	Private _aItem		:= {}
	Private _oFont1		:= Nil
	Private _oFont2		:= Nil
	Private _oMenu01	:= Nil

	Private _cSerieNF	:= Space(TamSx3("F1_DOC")[1])
	Private _cNotaFis	:= Space(TamSx3("F1_SERIE")[1])
	Private _cFornece	:= Space(TamSx3("A2_COD")[1])
	Private _cLojaFor	:= Space(TamSx3("A2_LOJA")[1])
	Private _cNomeFor	:= Space(TamSx3("A2_NREDUZ")[1])
	Private _cTipo		:= Space(1)
	Private _cCNPJ		:= Space(TamSx3("A2_CGC")[1])
	Private _nStatus	:= 0
	Private _nRecZA1	:= 0

	Private _cButDan 	:= 'If(!Empty(_aXML),U_AS_DANFE(_aXML,_aFldCab),MsgAlert("Nenhum XML Marcado!"))'

	//Calcula tamanho da tela
	Private _oSize := FwDefSize():New( .F. )							// Com enchoicebar

	Private _cSeek		:= Space(15)
	Private _aCombo 	:= {}
	Private _cCombo 	:= ''
	Private _oGrupo1		:= Nil

	Private _cProduto	:= Space(TamSx3("B1_COD")[1])

	Private _lPCNFE		:= GetNewPar( "MV_PCNFE", .F. ) //-- Nota Fiscal tem que ser amarrada a um Pedido de Compra ?
	Private _cTesPcNf	:= SuperGetMV("MV_TESPCNF") // Tes que nao necessita de pedido de compra amarrado

	Private _cTesFor	:= Space(TamSx3("F4_CODIGO")[1])

	Private _lMenuPed	:= .T.
	Private _lMenuNFo	:= .T.
	Private _oTMenuBar	:= Nil
	Private _oTMenu3B	:= Nil

	Private _aPedido	:= {}
	Private _nQtItXML	:= 0

	_oSize:AddObject( "P1", 100, 065, .t., .t., .t. )
	_oSize:AddObject( "P2", 100, 035, .t., .t., .t. )
	_oSize:lProp := .t.
	_oSize:aMargins := { 3, 3, 3, 3 }							// Margens
	_oSize:lLateral := .F.  									// Calculo vertical
	_oSize:Process()

	Fields_XML() //Campos da tela

	U_AS_GetXML(1) //Verifica se existe arquivo para ser importado

	DEFINE MsDIALOG _oDlg TITLE OemToAnsi("Integração XML CTE") FROM _oSize:aWindSize[1],_oSize:aWindSize[2] TO _oSize:aWindSize[3],_oSize:aWindSize[4] Of _oDlg PIXEL //Style DS_MODALFRAME

	_oDlg:lEscClose := .F. //Não permite fechar a janela pelo botão "ESC"

	DEFINE FONT _oFont1 NAME "Arial" SIZE 0,16 OF _oDlg
	DEFINE FONT _oFont2 NAME "Arial" SIZE 0,12 OF _oDlg

	Panel01()

	Panel02()

	ACTIVATE MSDIALOG _oDlg CENTERED

	SetKey(VK_F4,{||Nil})
	SetKey(VK_F5,{||Nil})
	SetKey(VK_F8,{||Nil})

Return(Nil)



Static Function Fields_XML()

	Local F	:= 0

	_aFldCab := {{"ZA1_OK"		,10,"C","N"},;
	{"ZA1_STATUS"	,10,"N","N"},;
	{"ZA1_FILIAL"	,20,"C","N"},;
	{"ZA1_SERIE"	,40,"C","N"},;
	{"ZA1_DOC"		,40,"C","S"},;
	{"ZA1_EMISSA"	,40,"C","N"},;
	{"ZA1_TIPO2"	,40,"C","N"},;
	{"ZA1_FORNEC"	,40,"C","S"},;
	{"ZA1_LOJA"		,20,"C","N"},;
	{"ZA1_NOME"		,120,"C","S"},;
	{"ZA1_CHAVE"	,140,"C","N"},;
	{"ZA1_CNPJ"		,50,"C","S"},;
	{"ZA1_RECNO"	,30,"C","N"}}

	_aXML := {{}}
	For F := 1 To Len(_aFldCab)
		_cTit := " "
		SX3->(dbsetOrder(2))
		If SX3->(dbSeek(_aFldCab[F][1]))
			_cTit := Trim(X3Titulo())
		Endif

		If _aFldCab[F][1] $ 'ZA1_OK'
			AAdd(_aXML[1],.F.)
			_cTit := ""
		ElseIf _aFldCab[F][1] $ 'ZA1_RECNO'
			AAdd(_aXML[1],0)
			_cTit := "Recno"
		Else
			If _aFldCab[F][1] = 'ZA1_STATUS'
				_cTit := ""
			Endif
			AAdd(_aXML[1],Criavar(_aFldCab[F][1]))
		Endif

		aAdd(_aHeadCab, _cTit)
		aAdd(_aColSzCab,_aFldCab[F][2])

		If _aFldCab[F][4] == 'S'
			AAdd(_aCombo,_cTit)
		Endif

	Next F

	_cCombo := _aCombo[1]

	_aFldIte := {{"ZA2_STATUS"		,10,"N","N"},;
	{"ZA2_ITEM"		,20,"C","N"},;
	{"ZA2_COD"		,40,"C","N"},;
	{"ZA2_PROCLI"	,40,"C","N"},;
	{"ZA2_DESPRO"	,100,"C","N"},;
	{"ZA2_UM"		,20,"C","N"},;
	{"ZA2_QUANT"	,40,"N","N"},;
	{"ZA2_VUNIT"	,40,"N","N"},;
	{"ZA2_VTOTAL"	,30,"N","N"},;
	{"ZA2_TES"		,20,"C","N"},;
	{"ZA2_CFOP"		,25,"C","N"},;
	{"ZA2_PEDIDO"	,30,"C","N"},;
	{"ZA2_ITEMPC"	,30,"C","N"},;
	{"ZA2_BICMS"	,30,"N","N"},;
	{"ZA2_PICMS"	,30,"N","N"},;
	{"ZA2_VICMS"	,30,"N","N"},;
	{"ZA2_BIPI"		,30,"N","N"},;
	{"ZA2_PIPI"		,30,"N","N"},;
	{"ZA2_VIPI"		,30,"N","N"},;
	{"ZA2_SERNFO"	,20,"C","N"},;
	{"ZA2_NFORIG"	,25,"C","N"},;
	{"ZA2_ITNFOR"	,20,"C","N"},;
	{"ZA2_RECNO"	,30,"C","N"}}

	_aItem := {{}}
	For F := 1 To Len(_aFldIte)
		_cTit := " "
		SX3->(dbsetOrder(2))
		If SX3->(dbSeek(_aFldIte[F][1]))
			_cTit := Trim(X3Titulo())
		Endif

		If _aFldIte[F][1] = 'ZA2_RECNO'
			AAdd(_aItem[1],0)
			_cTit := "Recno"
		ElseIf _aFldIte[F][1] = 'ZA2_STATUS'
			AAdd(_aItem[1],0)
			_cTit := ""
		Else
			AAdd(_aItem[1],Criavar(_aFldIte[F][1]))
		Endif

		aAdd(_aHeadItem, _cTit)
		aAdd(_aColSzIte,_aFldIte[F][2])

	Next F

Return(Nil)




/*/{Protheus.doc} GetXML
Busca os arquivos XML na pasta indicada
@type Function
@author Fabiano
@since 21/10/2016
@version 1.0
@return _aFile	, ${array}		, (Array com os arquivo}
/*/
User Function AS_GetXML(_nOpc)

	Local _cFornec 	:= ''
	Local _cNrCte 	:= ''
	Local _lFornec	:= .F.
	Local O
	Local _aListFile:= {}
	Local _nCab		:= 0
	Local _nIt		:= 0

	If Select("TZA1") > 0
		TZA1->(dbCloseArea())
	Endif

	_cQuery := " SELECT "
	For _nCab := 1 To Len(_aFldCab)-1
		_cQuery += " "+_aFldCab[_nCab][1]+", " +CRLF
	Next _nCab
	_cQuery += " ZA1.R_E_C_N_O_ AS ZA1_RECNO FROM "+RetSqlName("ZA1")+" ZA1 " +CRLF
	_cQuery += " WHERE ZA1.D_E_L_E_T_ = '' " +CRLF
	_cQuery += " AND ZA1_FILIAL = '"+xFilial("ZA1")+"' " +CRLF
	_cQuery += " AND ZA1_STATUS <> 0 " +CRLF
	_cQuery += " ORDER BY ZA1_FORNEC,ZA1_LOJA,ZA1_DOC " +CRLF

	TcQuery _cQuery New Alias "TZA1"

	TcSetField("TZA1","ZA1_EMISSA","D")

	Count to _nTZA1

	If _nTZA1 = 0
		//		MsgAlert("Não foi encontrada NF para Processamento!")
		_aListFile := _aXML
		Return(_aListFile)
	Endif

	TZA1->(dbGoTop())

	While TZA1->(!EOF())

		Aadd( _aListFile,Array(Len(_aFldCab)))
		For _nIt := 1 To Len(_aFldCab)
			If _aFldCab[_nIt][1] = "ZA1_OK"
				_aListFile[Len(_aListFile)][_nIt]:= .F.
				//			ElseIf _aFldCab[_nIt][1] = "ZA1_CNPJ"
				//				_aListFile[Len(_aListFile)][_nIt]:= Transform(&("TZA1->"+_aFldCab[_nIt][1]),"@R 99.999.999/9999-99")
			Else
				_aListFile[Len(_aListFile)][_nIt]:= &("TZA1->"+_aFldCab[_nIt][1])
			Endif
		Next _nIt

		TZA1->(dbSkip())
	EndDo

	TZA1->(dbCloseArea())

	_aXML := _aListFile

	If _nOpc > 1
		_oListbox:SetArray(_aXML)

		_oListbox:bLine := {|| SetLineBox(_oListbox,_aXML,_aFldCab)}

		_oListbox:Refresh()

		IndexGrid(_oListbox:aArray,_oListbox,_cCombo,_aHeadCab,_aFldCab,1)

	Endif


Return()



//Atualiza os itens do Panel02
Static Function AtuItem(_nOpcIt,_aArrAtu)

	Local _cFilIt	:= _aArrAtu[aScan(_aFldCab,{|x| x[1] == 'ZA1_FILIAL' })]
	Local _cSerIt	:= _aArrAtu[aScan(_aFldCab,{|x| x[1] == 'ZA1_SERIE' })]
	Local _cDocIt	:= _aArrAtu[aScan(_aFldCab,{|x| x[1] == 'ZA1_DOC' })]
	Local _cForIt	:= _aArrAtu[aScan(_aFldCab,{|x| x[1] == 'ZA1_FORNEC' })]
	Local _cLojIt	:= _aArrAtu[aScan(_aFldCab,{|x| x[1] == 'ZA1_LOJA' })]
	Local _lAtu		:= _aArrAtu[aScan(_aFldCab,{|x| x[1] == 'ZA1_OK' })]

	Local _cKey		:= _cFilIt+_cSerIt+_cDocIt+_cForIt+_cLojIt
	Local Fa		:= 0
	Local _nIt		:= 0

	//Variáveis Private utilizadas em outra função
	If !_lAtu
		_cSerieNF	:= Space(TamSx3("F1_DOC")[1])
		_cNotaFis	:= Space(TamSx3("F1_SERIE")[1])
		_cFornece	:= Space(TamSx3("A2_COD")[1])
		_cLojaFor	:= Space(TamSx3("A2_LOJA")[1])
		_cNomeFor	:= Space(TamSx3("A2_NREDUZ")[1])
		_cTipo		:= Space(1)
		_cCNPJ		:= Space(TamSx3("A2_CGC")[1])
		_nStatus	:= 0
		_nRecZA1	:= 0
	Else
		_cSerieNF		:= _aArrAtu[aScan(_aFldCab,{|x| x[1] == 'ZA1_SERIE' })]
		_cNotaFis		:= _aArrAtu[aScan(_aFldCab,{|x| x[1] == 'ZA1_DOC' 	})]
		_cFornece		:= _aArrAtu[aScan(_aFldCab,{|x| x[1] == 'ZA1_FORNEC'})]
		_cLojaFor		:= _aArrAtu[aScan(_aFldCab,{|x| x[1] == 'ZA1_LOJA' 	})]
		_cNomeFor		:= _aArrAtu[aScan(_aFldCab,{|x| x[1] == 'ZA1_NOME' 	})]
		_cTipo			:= _aArrAtu[aScan(_aFldCab,{|x| x[1] == 'ZA1_TIPO2' })]
		_nStatus		:= _aArrAtu[aScan(_aFldCab,{|x| x[1] == 'ZA1_STATUS'})]
		_cCNPJ			:= _aArrAtu[aScan(_aFldCab,{|x| x[1] == 'ZA1_CNPJ'	})]
		_nRecZA1		:= _aArrAtu[aScan(_aFldCab,{|x| x[1] == 'ZA1_RECNO'	})]
		If _cTipo = "N"
			_lMenuPed := .T.
			_lMenuNFo := .F.
		ElseIf _cTipo = "D"
			_lMenuPed := .F.
			_lMenuNFo := .T.
		Endif
		_oTMenu3B:Refresh()
		_oTMenuBar:Refresh()
	Endif

	_aItem := {{}}
	For Fa := 1 To Len(_aFldIte)
		If _aFldIte[Fa][1] $ 'ZA2_STATUS|ZA2_RECNO'
			AAdd(_aItem[1],0)
		Else
			AAdd(_aItem[1],Criavar(_aFldIte[Fa][1]))
		Endif
	Next Fa

	If _lAtu
		ZA2->(dbSetOrder(1))
		If ZA2->(msSeek(_cKey))

			_aItem := {}

			While ZA2->(!Eof()) .And. _cKey == ZA2->ZA2_FILIAL+ZA2->ZA2_SERIE+ZA2->ZA2_DOC+ZA2->ZA2_FORNEC+ZA2->ZA2_LOJA

				Aadd( _aItem,Array(Len(_aFldIte)))
				For _nIt := 1 To Len(_aFldIte)
					If _aFldIte[_nIt][1] = "ZA2_RECNO"
						_aItem[Len(_aItem)][_nIt]:= ZA2->(Recno())
					Else
						_aItem[Len(_aItem)][_nIt]:= &("ZA2->"+_aFldIte[_nIt][1])
					Endif
				Next _nIt

				ZA2->(dbSkip())
			EndDo
		Endif
	Endif

	If _nOpcIt > 1

		If Empty(_aItem)
			For Fa := 1 To Len(_aFldIte)
				If _aFldIte[Fa][1] $ 'ZA2_STATUS|ZA2_RECNO'
					AAdd(_aItem,0)
				Else
					AAdd(_aItem,Criavar(_aFldIte[Fa][1]))
				Endif
			Next Fa
		Endif

		_oListIt:SetArray(_aItem)

		_oListIt:bLine := {|| U_SetArrIT(_oListIt,_aItem,_aFldIte)}

		//		_oListIt:bRClicked	:= {|_aObj,X,Y| But_Right(2,_oListIt),_oMenu01:Activate( X, Y, _aObj )}

		_oListIt:Refresh()

	Endif

Return()




Static Function MarkAll()

	Local _nInd		:= 1 	// Conteudo de retorno
	Local _lMark	:= !_aXML[1][1]

	For _nInd := 1 To Len(_aXML)
		_aXML[_nInd][1] := _lMark
	Next

	_oListBox:Refresh()

Return(Nil)




Static Function Panel01()

	Local _nP1Lini	:= _oSize:GetDimension( "P1", "LININI" )+10
	Local _nP1Coli 	:= _oSize:GetDimension( "P1", "COLINI" )
	Local _nP1XSiz 	:= _oSize:GetDimension( "P1", "XSIZE" )
	Local _nP1YSiz 	:= _oSize:GetDimension( "P1", "YSIZE" )
	Local _nP1Linf 	:= _oSize:GetDimension( "P1", "LINEND" )
	Local _nP1Colf 	:= _oSize:GetDimension( "P1", "COLEND" )

	// Monta um Menu Suspenso
	_oTMenuBar := TMenuBar():New(_oDlg)

	_oTMenu1 := TMenu():New(0,0,0,0,.T.,,_oDlg)
	_oTMenu2 := TMenu():New(0,0,0,0,.T.,,_oDlg)
	_oTMenu3 := TMenu():New(0,0,0,0,.T.,,_oDlg)
	_oTMenu4 := TMenu():New(0,0,0,0,.T.,,_oDlg)

	_oTMenuBar:AddItem('Executar'	, _oTMenu1, .T.)
	_oTMenuBar:AddItem('Itens NF'	, _oTMenu3, .T.)
	_oTMenuBar:AddItem('Relatorio'	, _oTMenu2, .T.)
	_oTMenuBar:AddItem('Ajuda'		, _oTMenu4, .T.)

	// Cria Itens do Menu

	_oTMenu1A := TMenuItem():New(_oDlg,'Manifesto',,,.T.,{||U_AS_MANIF()},,"Engrenagem",,,,,,,.T.)
	_oTMenu1:Add(_oTMenu1A)

	//	_oTMenuF := TMenuItem():New(_oDlg,'Pré-Nota',,,.F.,{||U_AS_PRENOTA(_aXML[_oListbox:nAt])},,"S4WB014B",,,,,,,.T.)
	//	_oTMenu1:Add(_oTMenuF)

	//	_oTMenuG := TMenuItem():New(_oDlg,'Baixar XML',,,.F.,{||LjMsgRun('Baixando XML, aguarde...','Baixar XML',{||U_AS_BAIX_aXML()})},,"S4WB014B",,,,,,,.T.)
	//	_oTMenu1:Add(_oTMenuG)

	_oTMenu1B := TMenuItem():New(_oDlg,'Cod. Fornecedor/Cliente',,,,{||XML_FORN()},,"PMSRELA",,,,,,,.T.)
	_oTMenu1:Add(_oTMenu1B)

	_oTMenu1C := TMenuItem():New(_oDlg,'Gerar NF',,,,{||U_AS_NOTA(_oDlg,_oListbox,_oListIt,_aFldIte)},,"OBJETIVO",,,,,,,.T.)
	_oTMenu1:Add(_oTMenu1C)

	_oTMenu1D := TMenuItem():New(_oDlg,'Exportar XML',,,.T.,{||U_AS_EXPXML()},,"S4WB014B",,,,,,,.T.)
	_oTMenu1:Add(_oTMenu1D)

	_oTMenu1D := TMenuItem():New(_oDlg,'Grupo Filiais',,,.T.,{||GRPFIL()},,"DEPENDENTES",,,,,,,.T.)
	_oTMenu1:Add(_oTMenu1D)

	_oTMenu1E := TMenuItem():New(_oDlg,'Sair',,,,{|| _oDlg:End()},,"FINAL",,,,,,,.T.)
	_oTMenu1:Add(_oTMenu1E)

	_oTMenuItem4 := TMenuItem():New(_oDlg,'DANFE',,,,{||&(_cButDan)},,'IMPRESSAO',,,,,,,.T.)
	_oTMenu2:Add(_oTMenuItem4)

	//	_oTMenuItem5 := TMenuItem():New(_oDlg,'Divergencias Pedido X XML',,,.F.,{||alert("SDUSETDEL")},,'SDUSOFTSEEK',,,,,,,.T.)
	//	_oTMenu2:Add(_oTMenuItem5)

	//	_oTMenuItem6 := TMenuItem():New(_oDlg,'Notas Importadas',,,.F.,{||alert("Notas Importadas")},,'SHORTCUTEDIT',,,,,,,.T.)
	//	_oTMenu2:Add(_oTMenuItem6)



	_oTMenu3A := TMenuItem():New(_oDlg,'Produto Interno',,,,{||Prod_For(_aItem,_oListIt:nAt,_oListIt)},,'PMSRELA',,,,,,,.T.)
	_oTMenu3:Add(_oTMenu3A)

	//	_oTMenu3B := TMenuItem():New(_oDlg,'Pedido X Item',,,,{||Item_PC(_aItem,_oListIt:nAt,_oListIt)},,'SELECT',,,,,,,.T.)
	_oTMenu3B := TMenuItem():New(_oDlg,'Pedido X Item',,,_lMenuPed,{||Item_PC(_aItem,_oListIt)},,'SELECT',,,,,,,.T.)
	_oTMenu3:Add(_oTMenu3B)

	_oTMenu3B := TMenuItem():New(_oDlg,'NF Original X Item',,,_lMenuNFo,{||NF_ORIGINAL(_aItem,_oListIt)},,'SELECT',,,,,,,.T.)
	_oTMenu3:Add(_oTMenu3B)

	_oTMenu4A := TMenuItem():New(_oDlg,'Sobre',,,.T.,{||Sobre()},,'RPMPERG',,,,,,,.T.)
	_oTMenu4:Add(_oTMenu4A)





	_oGrupo1	:= TGroup():New( _nP1Lini,_nP1Coli,_nP1Linf,_nP1Colf,"Notas Fiscais",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	_oTCombo := TComboBox():New(_nP1Lini+10,10,    {|u|if(PCount()>0,_cCombo := u,_cCombo)}      ,_aCombo,80  ,11  ,_oGrupo1,,{||IndexGrid(_oListbox:aArray,_oListbox,_cCombo,_aHeadCab,_aFldCab,1)},,,,.T.,_oFont1,,,,,,,,'_cCombo')

	@ _nP1Lini+10, 93 MsGet _cSeek				Size 110, 010 Of _oGrupo1 Pixel
	_oTBut2	:= TButton():New( _nP1Lini+10, 206, "Pesquisar"	,_oGrupo1,{|| PesqCpo(_cSeek,_aXML,_oListbox,_cCombo,_aHeadCab,1)}	, 40,11,,,.F.,.T.,.F.,,.F.,,,.F. )

	_oListbox := TCBrowse():New( _nP1Lini+25,_nP1Coli+5,_nP1XSiz-80,_nP1YSiz-30,,_aHeadCab,_aColSzCab,_oGrupo1,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

	_oListbox:SetArray(_aXML)

	_oListbox:bLine := {|| SetLineBox(_oListbox,_aXML,_aFldCab)}

	// Troca a imagem no duplo click do mouse
	_oListbox:bLDblClick := {|| Check(1,_aXML,_oListbox)}

	//	_oListbox:bRClicked	:= {|_aObj,X,Y| But_Right(1,_oListbox),_oMenu01:Activate( X, Y, _aObj )}

	_oGrupo2		:= TGroup():New( _nP1Lini+10,_nP1XSiz-65,_nP1Linf-5,_nP1Colf-5,"Legenda XML",_oGrupo1,CLR_HRED,CLR_WHITE,.T.,.F. )

	_oTBitmap1	:= TBitmap():New(_nP1Lini+25, _nP1XSiz-60, 10, 10, NIL,  "BR_VERDE"   , .T., _oGrupo2,{|| }, NIL, .F., .F., NIL, NIL, .F., NIL, .T., NIL, .F.)
	_oTSay1		:= TSay():New(_nP1Lini+25,_nP1XSiz-48,{||' Liberado '},_oGrupo2,,_oFont2,,,,.T.,CLR_BLACK,CLR_HGREEN,40,08,,,,,.T.)

	_oTBitmap4 	:= TBitmap():New(_nP1Lini+35, _nP1XSiz-60, 10, 10, NIL,  "BR_VERMELHO", .T., _oGrupo2,{|| }, NIL, .F., .F., NIL, NIL, .F., NIL, .T., NIL, .F.)
	_oTSay4		:= TSay():New(_nP1Lini+35,_nP1XSiz-48,{||' Inconsistente '},_oGrupo2,,_oFont2,,,,.T.,CLR_BLACK,CLR_HRED,40,08,,,,,.T.)

	_oTBitmap2 	:= TBitmap():New(_nP1Lini+45, _nP1XSiz-60, 10, 10, NIL,  "BR_PRETO" , .T., _oGrupo2,{|| }, NIL, .F., .F., NIL, NIL, .F., NIL, .T., NIL, .F.)
	_oTSay2		:= TSay():New(_nP1Lini+45,_nP1XSiz-48,{||' Sem Fornecedor '},_oGrupo2,,_oFont2,,,,.T.,CLR_BLACK,CLR_WHITE	,40,08,,,,,.T.)

Return





Static Function Sobre()

	Local _oSobre := Nil
	Local _0Tsay1 := Nil

	Define MsDialog _oSobre Title ("Sobre") from 0,0 to 50,50 Of _oSobre Pixel

	_oTSay1	 := TSay():New(05,05,{||' Versão: 1.0'},_oSobre,,,,,,.T.,CLR_BLACK,CLR_HGREEN,40,08,,,,,.T.)


	ACTIVATE MSDIALOG _oSobre CENTERED


Return(Nil)




//Pesquisar o campo informado na listbox
Static Function PesqCpo(_cString,_aVet,_oObj,_cPesq,_aPesq,_nCol)

	Local _nPos	:= 0
	Local _nLen	:= 0
	Local _lRet	:= .T.
	Local _nElem := 1

	If ValType(_cPesq) <> "U"
		_nElem := aScan(_aPesq,_cPesq)
	Else
		_nElem := _nCol
	Endif

	//³Realiza a pesquisa³
	_cString := AllTrim(Upper(_cString))
	_nPos	 := aScan(_aVet,{|x| _cString $ If(Valtype(x[_nElem]) = "D",dToc(x[_nElem]), Upper(x[_nElem]))})
	_lRet	 := (_nPos != 0)

	//³Se encontrou, posiciona o objeto ³
	If _lRet
		_oObj:nAt := _nPos
		_oObj:Refresh()
	EndIf

	_oListBox:Refresh()
	_oDlg:Refresh()

Return _lRet



//ordena as NF
Static Function IndexGrid(_aVet,_oObj,_cPesq,_aPesq,_aFld,_nOpc)

	Local _nElem := aScan(_aPesq,_cPesq)

	If ValType(_aVet) <> "U"
		_aCols := ASORT(_aVet, , , { | x,y | y[_nElem] > x[_nElem] } )
		_oObj:SetArray(_aCols)

		_oObj:bLine := {|| SetLineBox(_oObj,_aVet,_aFld)}

		If _nOpc = 1
			_oObj:nAt := 1
		Endif

		_oObj:Refresh()
	Endif

Return()



//Marcação do Título
Static Function Check(_nOpc,_aArray,_oObj)

	Local _nInd		:= 1 	// Conteudo de retorno
	Local _nAt		:= _oObj:nAt
	Local _nCount	:= 0

	_aArray[_nAt][1]	:= !_aArray[_nAt][1]

	If _nOpc = 1 //Noat Fiscal Original

		For _nInd := 1 To Len(_aArray)
			If _nAt <> _nInd
				_aArray[_nInd][1] := .F.
			Endif
		Next

		AtuItem(2,_aArray[_nAt])

	Else //Pedido Compra
		_nCount := 0
		For _nInd := 1 To Len(_aArray)
			If _aArray[_nInd][1]
				_nCount ++
			Endif
		Next
	Endif

	_oObj:Refresh()
	_oDlg:Refresh()

Return(Nil)




Static Function Panel02()

	Local _nP2Lini	:= _oSize:GetDimension( "P2", "LININI" )+3
	Local _nP2Coli 	:= _oSize:GetDimension( "P2", "COLINI" )
	Local _nP2XSiz 	:= _oSize:GetDimension( "P2", "XSIZE"  )
	Local _nP2YSiz 	:= _oSize:GetDimension( "P2", "YSIZE"  )
	Local _nP2Linf 	:= _oSize:GetDimension( "P2", "LINEND" )
	Local _nP2Colf 	:= _oSize:GetDimension( "P2", "COLEND" )

	_oGrupo3	:= TGroup():New( _nP2Lini,_nP2Coli,_nP2Linf,_nP2Colf,"Status NF",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	_oListIt	:= TCBrowse():New( _nP2Lini+10,_nP2Coli+5,_nP2XSiz-80,_nP2YSiz-20,,_aHeadItem,_aColSzIte,_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,.T.,.T.)

	_oListIt:SetArray(_aItem)

	_oListIt:bLine := {|| U_SetArrIT(_oListIt,_aItem,_aFldIte)}

	_oListIt:bRClicked	:= {|_aObj,X,Y| But_Right(2,_oListIt),_oMenu01:Activate( X, Y, _aObj )}

	_oListIt:Refresh()

	_oGrupo5		:= TGroup():New( _nP2Lini+10,_nP2XSiz-65,_nP2Linf-5,_nP2Colf-5,"Legenda Itens XML",_oGrupo3,CLR_HRED,CLR_WHITE,.T.,.F. )

	_oTBitmap1	:= TBitmap():New(_nP2Lini+25, _nP2XSiz-60, 10, 10, NIL,  "BR_VERMELHO.BMP"   , .T., _oGrupo5,{|| }, NIL, .F., .F., NIL, NIL, .F., NIL, .T., NIL, .F.)
	_oTSay1		:= TSay():New(_nP2Lini+25,_nP2XSiz-48,{||' S/ Prod. Interno '},_oGrupo5,,_oFont2,,,,.T.,CLR_BLACK,CLR_HGREEN,40,08,,,,,.T.)

	_oTBitmap2 	:= TBitmap():New(_nP2Lini+35, _nP2XSiz-60, 10, 10, NIL,  "BR_AMARELO.BMP" , .T., _oGrupo5,{|| }, NIL, .F., .F., NIL, NIL, .F., NIL, .T., NIL, .F.)
	_oTSay2		:= TSay():New(_nP2Lini+35,_nP2XSiz-48,{||' Sem Pedido '},_oGrupo5,,_oFont2,,,,.T.,CLR_BLACK,CLR_WHITE	,40,08,,,,,.T.)

	_oTBitmap5 	:= TBitmap():New(_nP2Lini+45, _nP2XSiz-60, 10, 10, NIL,  "BR_AZUL.BMP"  , .T., _oGrupo5,{|| }, NIL, .F., .F., NIL, NIL, .F., NIL, .T., NIL, .F.)
	_oTSay5		:= TSay():New(_nP2Lini+45,_nP2XSiz-48,{||' Sem NF Original '},_oGrupo5,,_oFont2,,,,.T.,CLR_BLACK,CLR_ORANGE,40,08,,,,,.T.)

	_oTBitmap3 	:= TBitmap():New(_nP2Lini+55, _nP2XSiz-60, 10, 10, NIL,  "BR_BRANCO.BMP"    , .T., _oGrupo5,{|| }, NIL, .F., .F., NIL, NIL, .F., NIL, .T., NIL, .F.)
	_oTSay3		:= TSay():New(_nP2Lini+55,_nP2XSiz-48,{||' Valor Divergente '},_oGrupo5,,_oFont2,,,,.T.,CLR_BLACK,CLR_HBLUE,40,08,,,,,.T.)

	_oTBitmap4 	:= TBitmap():New(_nP2Lini+65, _nP2XSiz-60, 10, 10, NIL,  "BR_VERDE.BMP", .T., _oGrupo5,{|| }, NIL, .F., .F., NIL, NIL, .F., NIL, .T., NIL, .F.)
	_oTSay4		:= TSay():New(_nP2Lini+65,_nP2XSiz-48,{||' Liberado '},_oGrupo5,,_oFont2,,,,.T.,CLR_BLACK,CLR_HRED,40,08,,,,,.T.)

Return




User Function SetArrIT(_oBrw,_aBrw,_aFld)

	Local Fb	:= 0

	_aRet := {}
	For Fb := 1 To Len(_aFld)
		If _aFld[Fb][1] == "ZA2_STATUS"
			If _aBrw[_oBrw:nAt,Fb] = SEM_PRODUTO
				AAdd(_aRet,  _oTRed)
			ElseIf _aBrw[_oBrw:nAt,Fb] = SEM_PEDIDO
				AAdd(_aRet,  _oTYellow)
			ElseIf _aBrw[_oBrw:nAt,Fb] = PEDIDO_DIVERGENTE
				AAdd(_aRet,  _oTWhite)
			ElseIf _aBrw[_oBrw:nAt,Fb] = PEDIDO_OK
				AAdd(_aRet,  _oTGreen)
			ElseIf _aBrw[_oBrw:nAt,Fb] = SEM_NF_ORIGINAL
				AAdd(_aRet,  _oTBlue)
			Endif

		ElseIf _aFld[Fb][3] = 'N'
			AAdd(_aRet,  Alltrim(Transform(_aBrw[_oBrw:nAT,Fb],'@E 99,999,999,999.9999')))
		Else
			AAdd(_aRet, _aBrw[_oBrw:nAt,Fb])
		Endif
	Next Fb

Return(_aRet)





//Função utilizada ao clicar com o botão direito do mouse sobre o grid
Static Function But_Right(_nOpc,_oListIt)

	Local _Area		:= GetArea()
	Local _oMnItem	:= Nil

	_oMenu01 := TMenu():New(0,0,0,0,.T.)

	If _nOpc = 2
		_oTMenu3A := TMenuItem():New(_oDlg,'Produto Interno',,,,{||Prod_For(_aItem,_oListIt:nAt,_oListIt)},,'PMSRELA',,,,,,,.T.)
		_oMenu01:Add(_oTMenu3A)

		If _cTipo = 'N'
			_oTMenu3B := TMenuItem():New(_oDlg,'Pedido X Item',,,,{||Item_PC(_aItem,_oListIt)},,'SELECT',,,,,,,.T.)
			_oMenu01:Add(_oTMenu3B)

		ElseIf _cTipo = 'D'
			_oTMenu3B := TMenuItem():New(_oDlg,'NF Original X Item',,,,{||NF_ORIGINAL(_aItem,_oListIt)},,'SELECT',,,,,,,.T.)
			_oMenu01:Add(_oTMenu3B)
		Endif
	Endif

	RestArea(_Area)

Return



//Vincular Produto Interno
Static Function Prod_For(_aObj,_nLine,_oObj)

	Local _aEnch	:= {}
	Local _oPrdFor	:= Nil
	Local _oBtn1	:= Nil
	Local _oBtn2	:= Nil
	Local _lOK		:= .F.
	Local _cProdFor	:= _aObj[_nLine][aSCan(_aFldIte,{|x| x[1] == 'ZA2_PROCLI'})]
	Local _cNomePrd	:= _aObj[_nLine][aSCan(_aFldIte,{|x| x[1] == 'ZA2_DESPRO'})]
	Local _cPedido	:= _aObj[_nLine][aSCan(_aFldIte,{|x| x[1] == 'ZA2_PEDIDO'})]
	Local _cNFOri	:= _aObj[_nLine][aSCan(_aFldIte,{|x| x[1] == 'ZA2_NFORIG'})]
	Local _oGrupo4	:= Nil
	Local _lClick	:= .F.
	Local _lWhen	:= .T.

	If Empty(_cTipo)
		ShowHelpDlg("XMLPRD_4", {'Nenhum XML marcado.'},2,{'Não se aplica.'},2)
		Return(Nil)
	Endif

	_cTesFor		:= _aObj[_nLine][aSCan(_aFldIte,{|x| x[1] == 'ZA2_TES'})]
	_cProduto		:= _aObj[_nLine][aSCan(_aFldIte,{|x| x[1] == 'ZA2_COD'})]

	If _nStatus = NF_SEM_FORNECEDOR
		ShowHelpDlg("XMLPRD_3", {'XML sem código do Fornecedor.'},2,{'Vincule o código do Fornecedor.'},2)
		Return(Nil)
	Endif

	If !Empty(_cPedido)
		ShowHelpDlg("XMLPRD_1", {'Já existe Pedido vinculado ao Item.'},2,{'Remova o Pedido para alteração do Produto Interno.'},2)
		Return(Nil)
	Endif

	If !Empty(_cNFOri)
		ShowHelpDlg("XMLPRD_2", {'Já existe Nota Fiscal Original vinculado ao Item.'},2,{'Remova a NF Original para alteração do Produto Interno.'},2)
		Return(Nil)
	Endif

	DEFINE MsDIALOG _oPrdFor TITLE OemToAnsi("Produto X Fornecedor") FROM 0,0 TO 290,430 Of _oPrdFor PIXEL Style DS_MODALFRAME

	_oGrupo4	:= TGroup():New( 05,05,140,210,"Informações Cadastrais",_oPrdFor,CLR_HRED,CLR_WHITE,.T.,.F. )

	_oSay01	:= TSay():New( 015,010,{||"Fornecedor:"},_oGrupo4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	_oGet01	:= TGet():New( 015,055,{|u| If(PCount()>0,_cFornece:=u,_cFornece)},_oGrupo4,050,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","_cFornece",,)
	_oGet01:Disable()

	_oSay02	:= TSay():New( 015,140,{||"Loja:"},_oGrupo4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	_oGet02	:= TGet():New( 015,175,{|u| If(PCount()>0,_cLojaFor:=u,_cLojaFor)},_oGrupo4,030,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","_cLojaFor",,)
	_oGet02:Disable()

	_oSay03	:= TSay():New( 030,010,{||"Nome:"},_oGrupo4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	_oGet03	:= TGet():New( 030,055,{|u| If(PCount()>0,_cNomeFor:=u,_cNomeFor)},_oGrupo4,150,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","_cNomeFor",,)
	_oGet03:Disable()

	_oSay04	:= TSay():New( 045,010,{||"Prod. Fornecedor:"},_oGrupo4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	_oGet04	:= TGet():New( 045,055,{|u| If(PCount()>0,_cProdFor:=u,_cProdFor)},_oGrupo4,050,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","_cProdFor",,)
	_oGet04:Disable()

	_oSay05	:= TSay():New( 060,010,{||"Descrição:"},_oGrupo4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	@060,055 MsGet _oNomePrd VAR _cNomePrd Picture "@!" Size 150, 008 PIXEL OF _oGrupo4

	_oSay05	:= TSay():New( 075,010,{||"Produto:"},_oGrupo4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	@075,055 MsGet _oProduto VAR _cProduto Picture "@!" Size 050, 008 PIXEL F3 "SB1" Valid (ExistCpo("SB1", _cProduto).Or. Vazio())  OF _oGrupo4

	If _cTipo = 'D'
		_lWhen := .F.
	Endif
	_oSay06	:= TSay():New( 090,010,{||"TES:"},_oGrupo4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	@090,055 MsGet _oGet06 VAR _cTesFor Picture "@!" Size 050, 008 PIXEL  When _lWhen F3 "SF4" Valid (ExistCpo("SF4", _cTesFor).Or. Vazio())  OF _oGrupo4

	@105,010 CHECKBOX _oCheck VAR _lClick PROMPT "Atualiza Cadastro Produto X Fornecedor" When _lWhen SIZE 200,008 PIXEL OF _oGrupo4

	_oBtn1 := TButton():New( 120,010,"Cancelar",_oPrdFor, {|| _lOK := .F. , _oPrdFor:end() } ,050,012,,,,.T.,,"",,,,.F. )
	_oBtn2 := TButton():New( 120,155,"Confirma",_oPrdFor, {|| If(!Empty(_cProduto), (_lOK := .T. , _oPrdFor:End()),MsgAlert("Produto não informado!")) },;
	050,012,,,,.T.,,"",,,,.F. )

	ACTIVATE MSDIALOG _oPrdFor CENTERED

	If _lOK

		If _lClick
			Begin Transaction
				//				_nOpt := 3
				//				SA5->(dbSetOrder(14))
				//				If SA5->(msSeek(xFilial("SA5")+_cFornece+_cLojaFor+_cProdFor))
				SA5->(dbSetOrder(1))
				If SA5->(msSeek(xFilial("SA5")+_cFornece+_cLojaFor+_cProduto))
					//					_nOpt := 4
					SA5->(RecLock("SA5",.F.))
					//					SA5->A5_PRODUTO	:= _cProduto
					SA5->A5_CODPRF	:= _cProdFor
					SA5->A5_NOMPROD	:= _cNomePrd
					SA5->A5_YTES	:= _cTesFor
					SA5->(MsUnLock())
				Else
					SA5->(RecLock("SA5",.T.))
					SA5->A5_FILIAL	:= xFilial("SA5")
					SA5->A5_FORNECE	:= _cFornece
					SA5->A5_LOJA	:= _cLojaFor
					SA5->A5_NOMEFOR	:= _cNomeFor
					SA5->A5_CODPRF	:= _cProdFor
					SA5->A5_PRODUTO	:= _cProduto
					SA5->A5_NOMPROD	:= _cNomePrd
					SA5->A5_YTES	:= _cTesFor
					SA5->(MsUnLock())
				Endif

				/*
				PRIVATE lMsErroAuto := .F.

				_aEnch := {}

				If _nOpt = 3
				aadd(_aEnch,{"A5_FORNECE"	,_cFornece,})
				aadd(_aEnch,{"A5_LOJA"	 	,_cLojaFor,})
				aadd(_aEnch,{"A5_NOMEFOR"	,_cNomeFor,})
				aadd(_aEnch,{"A5_CODPRF"	,_cProdFor,})
				Endif
				aadd(_aEnch,{"A5_PRODUTO"	,_cProduto,})
				aadd(_aEnch,{"A5_NOMPROD"	,_cNomePrd,})
				aadd(_aEnch,{"A5_YTES"		,_cTesFor,})

				MSExecAuto({|x,y| Mata060(x,y)},_aEnch,_nOpt)

				If lMsErroAuto
				MostraErro()
				EndIf
				*/

			End Transaction
		Endif

		_AreaZA2 := ZA2->(GetArea())

		ZA2->(dbGoto(_aObj[_nLine][ Len(_aFldIte) ]))

		ZA2->(RecLock("ZA2",.F.))
		ZA2->ZA2_COD	:= _cProduto
		ZA2->ZA2_TES	:= _cTesFor
		ZA2->ZA2_STATUS	:= SEM_PEDIDO
		ZA2->(MsUnLock())

		RestArea(_AreaZA2)

		_aObj[_nLine][aSCan(_aFldIte,{|x| x[1] == 'ZA2_COD'})]	:= _cProduto
		_aObj[_nLine][aSCan(_aFldIte,{|x| x[1] == 'ZA2_TES'})]	:= _cTesFor
		_aObj[_nLine][1] := SEM_PEDIDO

		_oObj:Refresh()

	Endif

	CheckStat(_aItem,_oListIt)

Return(Nil)



//Vincular Pedido de Compras
Static Function Item_PC(_aItem,_oListIt)

	Local _AreaOri	:= GetArea()
	Local _AreaSC7	:= SC7->(GetArea())
	Local _AreaZA2	:= ZA2->(GetArea())
	Local _aEnch	:= {}
	Local _oBtn1	:= Nil
	Local _oBtn2	:= Nil
	Local _cProd	:= _aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_COD'})]
	Local _cCodFo	:= _aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_PROCLI'})]
	Local _nUnita	:= _aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_VUNIT'})]
	Local _nTotal	:= _aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_VTOTAL'})]
	Local _cItXML	:= _aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_ITEM'})]
	Local _oGrupo4	:= Nil
	Local _cQuery	:= ""
	Local _aHeadPed := {'','','Pedido','Item','Emissão','Dt. Entrega','TES','Quantidade','Qtd.Entregue','Prc. Unit.','Prc. Total'}
	Local _cPed		:= ''
	Local _cItP		:= ''
	Local _cTes		:= ''
	Local _cCFOP	:= ''
	Local _oListPC	:= Nil
	Local _nQPC		:= 0
	Local _nVPC		:= 0
	Local _cSearch	:= Space(TAMSX3("C7_NUM")[1])
	Local _lCanc	:= .T.
	Local _nPedido	:= 0

	Private _aPedIt	:= {}
	Private _oPedIt	:= Nil
	Private _bOk	:= "{|| If(GetQtdPed() ,(_lCanc := .F.,_oPedIt:End()),Nil) }"

	_nQtItXML	:= _aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_QUANT'})]

	If _cTipo <> "N"
		ShowHelpDlg("XMLNFORI_3", {'Rotina deve ser utilizada para NF do tipo "Normal".'},2,{'Não se aplica.'},2)

		RestArea(_AreaZA2)
		RestArea(_AreaSC7)
		RestArea(_AreaORI)

		Return(Nil)
	Endif

	If Empty(_cProd)
		ShowHelpDlg("XMLITPED_2", {'Item sem o Produto Interno.'},2,{'Vincule o código do produto Interno.'},2)
		RestArea(_AreaZA2)
		RestArea(_AreaSC7)
		RestArea(_AreaORI)
		Return(Nil)
	Endif

	If Select("TSC7") > 0
		TSC7->(dbCloseArea())
	Endif

	_cQuery += " SELECT * FROM "+RetSqlName("SC7")+" C7 " +CRLF
	_cQuery += " WHERE C7.D_E_L_E_T_ = '' AND C7_FILIAL = '"+xFilial("SC7")+"' " + CRLF
	_cQuery += " AND C7_PRODUTO = '"+_cProd+"' " + CRLF
	_cQuery += " AND C7_QUJE 	< C7_QUANT " + CRLF
	_cQuery += " AND C7_RESIDUO = '' " + CRLF
	_cQuery += " AND C7_FORNECE = '"+_cFornece+"' " + CRLF
	_cQuery += " AND C7_LOJA 	= '"+_cLojaFor+"' " + CRLF
	_cQuery += " ORDER BY C7_NUM,C7_ITEM " + CRLF

	TcQuery _cQuery New Alias "TSC7"

	TcSetField("TSC7","C7_EMISSAO","D")
	TcSetField("TSC7","C7_DATPRF","D")

	TSC7->(dbGoTop())

	_cPedSC7 := _aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_PEDIDO'})]
	_cItSC7  := _aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_ITEMPC'})]

	_ckey :=  _cPedSC7 + _cItSC7

	While TSC7->(!EOF())

		_cKey2	:= xFilial("ZA2")+TSC7->C7_NUM+TSC7->C7_ITEM+TSC7->C7_PRODUTO
		_lSai	:= .F.
		_nQTDE	:= TSC7->C7_QUANT
		_nQUJE	:= TSC7->C7_QUJE
		_nSld	:= _nQTDE - _nQUJE
		_lGo	:= .T.
		_lZA2	:= .F.
		_cStat	:= "1"

		ZA2->(dbSetOrder(3))
		If ZA2->(msSeek(_cKey2))

			_lZA2 := .T.

			While ZA2->(!EOF()) .And. _cKey2 == xFilial("ZA2")+ZA2->ZA2_PEDIDO+ZA2->ZA2_ITEMPC+ZA2->ZA2_COD .And. _lGo

				If ZA2->(Recno()) != _aItem[_oListIt:nAt][Len(_aFldIte)]

					If ZA2->ZA2_QUANT = _nSld
						_lGo = .F.
					Else
						_nSld  -= ZA2->ZA2_QUANT
						_nQUJE += ZA2->ZA2_QUANT
					Endif
					If _nSld < _nQtItXML
						_lGo := .F.
					Endif
				Endif

				ZA2->(dbskip())
			EndDo
		Endif

		_lZA3 := .F.
		If Alltrim(_cPedSC7) = '*'

			ZA3->(dbSetOrder(1))
			If ZA3->(msSeek(xFilial("ZA3")+_cSerieNF+_cNotaFis+_cItXML+_cFornece+_cLojaFor+TSC7->C7_NUM+TSC7->C7_ITEM))

				_lZA3 := .T.

			Endif

		Endif

		If !_lGo
			TSC7->(dbSkip())
			Loop
		Endif

		If !_lZA2 .And. _nSld < _nQtItXML
			_cStat := "2"
		Endif

		If _nUnita <> TSC7->C7_PRECO
			_cStat := "3"
		Endif

		If TSC7->C7_CONAPRO = 'B'
			_cStat := "4"
		Endif

		AAdd(_aPedIt,{		;
		If(_cKey == TSC7->C7_NUM + TSC7->C7_ITEM .Or. _lZA3, .T.,.F.) ,;
		_cStat				,;
		TSC7->C7_NUM		,;
		TSC7->C7_ITEM		,;
		TSC7->C7_EMISSAO	,;
		TSC7->C7_DATPRF		,;
		TSC7->C7_TES		,;
		_nQTDE				,;
		_nQUJE				,;
		TSC7->C7_PRECO		,;
		TSC7->C7_TOTAL		})

		TSC7->(dbSkip())
	EndDo

	If !Empty(_aPedIt)

		DEFINE MsDIALOG _oPedIt TITLE OemToAnsi("Item Pedido") FROM 0,0 TO 400,800 Of _oPedIt PIXEL Style DS_MODALFRAME

		_oGrupo4	:= TGroup():New( 05,05,190,395,"",_oPedIt,CLR_HRED,CLR_WHITE,.T.,.F. )

		_oSay01	:= TSay():New( 010,010,{||"Selecione abaixo o Pedido correspondente ao item da NF:"},_oGrupo4,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,300,008)

		_oListPC := TCBrowse():New( 25,10,380,140,, _aHeadPed ,,_oGrupo4,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

		_oListPC:SetArray(_aPedIt)

		_oListPC:bLine := {||{If(_aPedIt[_oListPC:nAt,1],_oOK,_oNo),;
		If(_aPedIt[_oListPC:nAt,2]="1",_oGreen,If(_aPedIt[_oListPC:nAt,2]="2",_oHBlue,If(_aPedIt[_oListPC:nAt,2]="3",_oRed,_oBrow))),; //		If(_aPedIt[_oListPC:nAt,2]="1",_oGreen,If(_aPedIt[_oListPC:nAt,2]="2",_oBlack,If(_aPedIt[_oListPC:nAt,2]="3",_oRed,_oBrow))),;
		_aPedIt[_oListPC:nAt,3],;
		_aPedIt[_oListPC:nAt,4],;
		_aPedIt[_oListPC:nAt,5],;
		_aPedIt[_oListPC:nAt,6],;
		_aPedIt[_oListPC:nAt,7],;
		Alltrim(Transform(_aPedIt[_oListPC:nAt,8],X3Picture( "C7_QUANT"		))),;
		Alltrim(Transform(_aPedIt[_oListPC:nAt,9],X3Picture( "C7_QUJE"		))),;
		Alltrim(Transform(_aPedIt[_oListPC:nAt,10],X3Picture( "C7_PRECO"	))),;
		Alltrim(Transform(_aPedIt[_oListPC:nAt,11],X3Picture( "C7_TOTAL"	))) } }

		_oListPC:bLDblClick := {|| If(_aPedIt[_oListPC:nAt][2] $ "1|2",Check(2,_aPedIt,_oListPC),Nil)}

		_aLegAux := {}
		AADD(_aLegAux,{"BR_VERDE"		,"Pedido de Compras Liberado" })
		AADD(_aLegAux,{"BR_AZUL_OCEAN"	,"Pedido de Compras com Quantidade Inferior" })
		AADD(_aLegAux,{"BR_VERMELHO"	,"Pedido de Compras com Valor Divergente" })
		AADD(_aLegAux,{"BR_MARROM"		,"Pedido de Compras Bloqueado" })

		//		_oBtn1 := TButton():New( 170,082,"Legenda",_oPedIt, {|| Lege_PC('PC','Pedido de Compra') },	050,012,,,,.T.,,"",,,,.F. )
		_oBtn1 := TButton():New( 170,082,"Legenda",_oPedIt, {|| BrwLegenda('Pedido de Compras', "Legenda", _aLegAux) },	050,012,,,,.T.,,"",,,,.F. )

		_oSay01	:= TSay():New( 170,142,{||"Procurar:"},_oPedIt,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,025,010)

		_oGet01	:= TGet():New( 170, 168,{|u| If(PCount()>0,_cSearch:=u,_cSearch)},_oPedIt,050,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cSearch",,)

		_oBtn3 := TButton():New( 170,220,"Pesquisar",_oPedIt, {|| PesqCpo(_cSearch,_aPedIt,_oListPC,,,3)},	050,012,,,,.T.,,"",,,,.F. )

		_oBtn4 := TButton():New( 170,280,"Cancelar",_oPedIt,{|| _lCanc := .T.,_oPedIt:End()},	050,012,,,,.T.,,"",,,,.F. )

		_oBtn2 := TButton():New( 170,340,"OK",_oPedIt, &(_bOk),	050,012,,,,.T.,,"",,,,.F. )

		ACTIVATE MSDIALOG _oPedIt CENTERED

	Else
		ShowHelpDlg("XMLITPED_1", {'Não foi encontrado Pedido de compras para este Produto.'},2,{'Inclua um novo Pedido de Compras.'},2)
	Endif

	TSC7->(dbCloseArea())

	If !Empty(_aPedido) .And. !_lCanc

		ZA2->(dbGoto(_aItem[_oListIt:nAt][Len(_aFldIte)]))

		ZA3->(dbSetOrder(1))
		If ZA3->(msSeek(xFilial("ZA3")+ZA2->ZA2_SERIE+ZA2->ZA2_DOC+ZA2->ZA2_ITEM+ZA2->ZA2_FORNEC+ZA2->ZA2_LOJA))

			_cKeyZA3 :=  xFilial("ZA3")+ZA3->ZA3_SERIE+ZA3->ZA3_DOC+ZA3->ZA3_ITEM+ZA3->ZA3_FORNEC+ZA3->ZA3_LOJA

			While ZA3->(!EOF()) .And. _cKeyZA3 == xFilial("ZA3")+ZA3->ZA3_SERIE+ZA3->ZA3_DOC+ZA3->ZA3_ITEM+ZA3->ZA3_FORNEC+ZA3->ZA3_LOJA

				ZA3->(RecLock("ZA3",.F.))
				ZA3->(dbDelete())
				ZA3->(MsUnlock())

				ZA3->(dbSkip())
			EndDo
		Endif

		_nQtPC		:= 0
		_nLenPed	:= Len(_aPedido[2])

		For _nPedido := 1 To _nLenPed

			_cPed := _aPedido[2][_nPedido][1]
			_cItP := _aPedido[2][_nPedido][2]
			_cTes := _aPedido[2][_nPedido][3]
			_nQPC := _aPedido[2][_nPedido][4]

			If Empty(_cTes)
				SA5->(dbSetOrder(14))
				If SA5->(msSeek(xFilial("SA5")+_cFornece+_cLojaFor+_cCodFo))
					_cTes := SA5->A5_YTES
				Endif
			Endif

			_cCFOP := ''
			If !Empty(_cTes)
				SF4->(dbSetOrder(1))
				If SF4->(msSeek(xFilial("SF4")+_cTes))
					If SA1->A1_EST == GetMV("MV_ESTADO") .And. SA1->A1_TIPO # "X"
						_cCFOP := "1" + SubStr(SF4->F4_CF, 2, 3)
					ElseIf SA1->A1_TIPO # "X"
						_cCFOP := "2" + SubStr(SF4->F4_CF, 2, 3)
					Else
						_cCFOP := "3" + SubStr(SF4->F4_CF, 2, 3)
					EndIf
				Endif
			Endif

			ZA3->(RecLock("ZA3",.T.))
			ZA3->ZA3_FILIAL	:= xFilial("ZA3")
			ZA3->ZA3_SERIE	:= ZA2->ZA2_SERIE
			ZA3->ZA3_DOC	:= ZA2->ZA2_DOC
			ZA3->ZA3_ITEM	:= ZA2->ZA2_ITEM
			ZA3->ZA3_FORNEC	:= ZA2->ZA2_FORNEC
			ZA3->ZA3_LOJA	:= ZA2->ZA2_LOJA
			ZA3->ZA3_COD	:= ZA2->ZA2_COD
			ZA3->ZA3_PEDIDO	:= _cPed
			ZA3->ZA3_ITEMPC	:= _cItP
			ZA3->ZA3_TES	:= _cTes
			ZA3->ZA3_CFOP	:= _cCFOP
			ZA3->ZA3_QUANT	:= _nQPC
			ZA3->(MsUnlock())

			_nQtPC += _nQPC

		Next _nPedido

		If !Empty(_nQtPC)
			If _nQtItXML = _nQtPC .Or. _nQtItXML < _nQtPC
				_nStat := PEDIDO_OK
			Else
				_nStat := PEDIDO_DIVERGENTE
			Endif
			If _nLenPed > 1
				_cPed := "*"
				_cItP := "*"
				_cTes := "*"
				_cCFOP:= "*"
			Endif

		Else
			_nStat := SEM_PEDIDO
		Endif

		ZA2->(RecLock("ZA2",.F.))
		ZA2->ZA2_PEDIDO	:= _cPed
		ZA2->ZA2_ITEMPC	:= _cItP
		ZA2->ZA2_TES	:= _cTes
		ZA2->ZA2_CFOP	:= _cCFOP
		ZA2->ZA2_STATUS	:= _nStat
		ZA2->(MsUnLock())

		_aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_PEDIDO'})]	:= _cPed
		_aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_ITEMPC'})]	:= _cItP
		_aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_TES'})]		:= _cTes
		_aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_CFOP'})]		:= _cCFOP
		_aItem[_oListIt:nAt][1] := _nStat

		CheckStat(_aItem,_oListIt)

	Endif

	RestArea(_AreaZA2)
	RestArea(_AreaSC7)
	RestArea(_AreaORI)
	_oListIt:Refresh()

Return(Nil)


/*
//Legenda do Pedido de compras
//Static Function Lege_PC(_cTp,_cOpc)
Static Function Lege_PC(_cOpc,_aLeg)

Local _aLegenda := _aLeg

BrwLegenda(_cOpc, "Legenda", _aLegenda)

Return(Nil)
*/


//Marcação do Pedido de Compras
Static Function MarkIt(_oObj,_aArray)

	Local _nInd		:= 1

	_aArray[_oObj:nAt][1] := !_aArray[_oObj:nAt][1]

	For _nInd := 1 To Len(_aArray)
		If _nInd <> _oObj:nAt
			_aArray[_nInd][1] := .F.
		Endif
	Next

	_oObj:Refresh()

Return(Nil)



//Atualiza o Status do XML
User Function AtuXML(_nStat,_cDoc,_cSerie,_cFornece,_cLoja)

	_cq3  := " UPDATE "+RetSqlName("ZA1")+" SET ZA1_STATUS = "+Alltrim(Str(_nStat))+" " +CRLF
	_cq3  += " WHERE D_E_L_E_T_ = '' AND ZA1_FILIAL = '"+xFilial("ZA1")+"' " +CRLF
	_cq3  += " AND ZA1_DOC = '"+_cDoc+"'  " +CRLF
	_cq3  += " AND ZA1_SERIE = '"+_cSerie+"'" +CRLF
	_cq3  += " AND ZA1_FORNEC = '"+_cFornece+"'" +CRLF
	_cq3  += " AND ZA1_LOJA = '"+_cLoja+"'" +CRLF

	TCSQLEXEC(_cq3)

Return(Nil)



//Verifica o Status
Static Function CheckStat(_aItem,_oListIt)

	Local _nIt		:= 0
	Local _nCa		:= 0
	Local _nTES		:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_TES'})
	Local _nPed		:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_PEDIDO'})
	Local _nStat	:= NF_OK
	Local _cTES		:= Space(TamSX3("F4_CODIGO")[1])
	Local _nPDoc	:= aSCan(_aFldCab,{|x| x[1] == 'ZA1_DOC'})
	Local _nPSer	:= aSCan(_aFldCab,{|x| x[1] == 'ZA1_SERIE'})
	Local _nPFor	:= aSCan(_aFldCab,{|x| x[1] == 'ZA1_FORNEC'})
	Local _nPLoj	:= aSCan(_aFldCab,{|x| x[1] == 'ZA1_LOJA'})

	For _nIt := 1 To Len(_aItem)

		_cTes := _aItem[_nIt][_nTES]

		If Empty(_cTes)
			_nStat := NF_NOK
			Exit
		Endif

		IF _cTipo = 'N'
			If _lPCNFE
				_cPed := _aItem[_nIt][_nPed]

				If Empty(_cPed)
					If !_cTes $ _cTesPcNf
						_nStat := NF_NOK
						Exit
					Endif
				Endif
			Endif
		Endif
	Next _nIt

	For _nCa := 1 To Len(_aXML)
		If _aXML[_nCa][1]
			//			U_ATUXML(_nStat,_aXML[_nCa][5],_aXML[_nCa][4],_aXML[_nCa][8],_aXML[_nCa][9])
			U_ATUXML(_nStat,_aXML[_nCa][_nPDoc],_aXML[_nCa][_nPSer],_aXML[_nCa][_nPFor],_aXML[_nCa][_nPLoj])
			_aXML[_nCa][2] := _nStat
		Endif
	Next _nCa

	_oListBox:Refresh()
	_oDlg:Refresh()

Return(Nil)



//Atualiza o XML
Static Function SetLineBox(_oBrw,_aBrw,_aFld)

	Local _aRet := {}
	Local Fb	:= 0

	For Fb := 1 To Len(_aFld)
		If _aFld[Fb][1] == "ZA1_OK"
			If _aBrw[_oBrw:nAt,Fb]
				AAdd(_aRet, _oOk)
			Else
				AAdd(_aRet, _oNo)
			Endif
		ElseIf _aFld[Fb][1] = "ZA1_STATUS"
			If _aBrw[_oBrw:nAt,Fb] = NF_OK
				AAdd(_aRet, _oGreen)
			ElseIf _aBrw[_oBrw:nAt,Fb] = NF_NOK
				AAdd(_aRet, _oRed)
			Else
				AAdd(_aRet, _oBlack)
			Endif
		ElseIf _aFld[Fb][1] = "ZA1_CNPJ"
			AAdd(_aRet, Transform(_aBrw[_oBrw:nAt,Fb],"@R 99.999.999/9999-99"))
		Else
			AAdd(_aRet, _aBrw[_oBrw:nAt,Fb])
		Endif
	Next Fb

Return(_aRet)

//Return(Nil)



//Vincular a NF Original
Static Function NF_ORIGINAL(_aItem,_oListIt)

	Local _AreaOri	:= GetArea()
	Local _AreaSD2	:= SD2->(GetArea())
	Local _AreaZA2	:= ZA2->(GetArea())
	Local _aEnch	:= {}
	Local _oBtn1	:= Nil
	Local _oBtn2	:= Nil
	Local _oBtn3	:= Nil
	Local _cProd	:= _aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_COD'})]
	Local _cCodFo	:= _aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_PROCLI'})]
	Local _nQuant	:= _aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_QUANT'})]
	Local _nUnita	:= _aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_VUNIT'})]
	Local _nTotal	:= _aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_VTOTAL'})]
	Local _cItem	:= _aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_ITEM'})]
	Local _oGrupo4	:= Nil
	Local _cQuery	:= ""
	Local _aNFIt	:= {}
	Local _aHeadNF	:= {'','','Série','NF','Item','Produto','Emissão','TES','Quantidade','Prc. Unit.','Prc. Total'}
	Local _oNFIt	:= Nil
	Local _cNF		:= ''
	Local _cSer		:= ''
	Local _cIt		:= ''
	Local _cTes		:= ''
	Local _oListNF	:= Nil
	Local _cSearch	:= Space(TAMSX3("D2_DOC")[1])
	Local _nIt		:= 0

	If _cTipo <> "D"
		ShowHelpDlg("XMLNFORI_3", {'Rotina deve ser utilizada para NF do tipo "Devolução".'},2,{'Não se aplica.'},2)

		RestArea(_AreaZA2)
		RestArea(_AreaSD2)
		RestArea(_AreaORI)

		Return(Nil)
	Endif

	If Empty(_cProd)

		ShowHelpDlg("XMLNFORI_1", {'Código do Produto Interno em branco.'},2,{'Preencha o código do produto interno..'},2)

		RestArea(_AreaZA2)
		RestArea(_AreaSD2)
		RestArea(_AreaORI)

		Return(Nil)
	Endif

	If Select("TSD2") > 0
		TSD2->(dbCloseArea())
	Endif

	_cQuery += " SELECT * FROM "+RetSqlName("SD2")+" D2 " +CRLF
	_cQuery += " WHERE D2.D_E_L_E_T_ = '' AND D2_FILIAL = '"+xFilial("SD2")+"' " + CRLF
	_cQuery += " AND D2_COD = '"+_cProd+"' " + CRLF
	_cQuery += " AND D2_CLIENTE = '"+_cFornece+"' " + CRLF
	_cQuery += " AND D2_LOJA 	= '"+_cLojaFor+"' " + CRLF
	_cQuery += " ORDER BY D2_SERIE,D2_DOC " + CRLF

	TcQuery _cQuery New Alias "TSD2"

	TcSetField("TSD2","D2_EMISSAO","D")

	TSD2->(dbGoTop())

	_ckey := _aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_SERNFO'})] + _aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_NFORIG'})] + _aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_ITNFOR'})]

	While TSD2->(!EOF())

		_lSai	:= .F.
		_lGo	:= .T.
		_lZA2	:= .F.
		_cStat	:= "1"
		_cKey2	:= xFilial("ZA2")+TSD2->D2_SERIE+TSD2->D2_DOC+TSD2->D2_ITEM
		_nSld	:= TSD2->D2_QUANT
		_nQUJE	:= 0

		ZA2->(dbSetOrder(4))
		If ZA2->(msSeek(_cKey2))

			_lZA2 := .T.

			While ZA2->(!EOF()) .And. _cKey2 == xFilial("ZA2")+ZA2->ZA2_SERNFO+ZA2->ZA2_NFORIG+ZA2->ZA2_ITNFOR .And. _lGo

				If ZA2->(Recno()) != _aItem[_oListIt:nAt][Len(_aFldIte)]

					If ZA2->ZA2_QUANT = _nSld
						_lGo = .F.
					Else
						_nSld  -= ZA2->ZA2_QUANT
						_nQUJE += ZA2->ZA2_QUANT
					Endif
					If _nSld < _nQuant
						_lGo := .F.
					Endif
				Endif

				ZA2->(dbskip())
			EndDo
		Endif

		If !_lZA2 .And. _nSld < _nQuant
			_cStat := "2"
		Endif

		If _nUnita <> TSD2->D2_PRCVEN
			_cStat := "3"
		Endif

		If !_lGo
			TSD2->(dbSkip())
			Loop
		Endif


		AAdd(_aNFIt,{		;
		If(_cKey == TSD2->D2_SERIE + TSD2->D2_DOC + TSD2->D2_ITEM, .T.,.F.) ,;
		_cStat				,;
		TSD2->D2_SERIE		,;
		TSD2->D2_DOC		,;
		TSD2->D2_ITEM		,;
		TSD2->D2_COD		,;
		TSD2->D2_EMISSAO	,;
		TSD2->D2_TES		,;
		TSD2->D2_QUANT		,;
		TSD2->D2_PRCVEN		,;
		TSD2->D2_TOTAL		})

		TSD2->(dbSkip())
	EndDo

	If !Empty(_aNFIt)

		DEFINE MsDIALOG _oNFIt TITLE OemToAnsi("Nota Fiscal Original") FROM 0,0 TO 400,800 Of _oNFIt PIXEL Style DS_MODALFRAME

		_oGrupo4	:= TGroup():New( 05,05,190,395,"",_oNFIt,CLR_HRED,CLR_WHITE,.T.,.F. )

		_oSay01	:= TSay():New( 010,010,{||"Selecione abaixo a NF Original correspondente:"},_oGrupo4,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,300,008)

		_oListNF := TCBrowse():New( 25,10,380,140,, _aHeadNF ,,_oGrupo4,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

		_oListNF:SetArray(_aNFIt)

		_oListNF:bLine := {||{If(_aNFIt[_oListNF:nAt,1],_oOK,_oNo),;
		If(_aNFIt[_oListNF:nAt,2]="1",_oGreen,If(_aNFIt[_oListNF:nAt,2]="2",_oBlack,_oRed)),;
		_aNFIt[_oListNF:nAt,3],;
		_aNFIt[_oListNF:nAt,4],;
		_aNFIt[_oListNF:nAt,5],;
		_aNFIt[_oListNF:nAt,6],;
		_aNFIt[_oListNF:nAt,7],;
		_aNFIt[_oListNF:nAt,8],;
		Alltrim(Transform(_aNFIt[_oListNF:nAt,9],X3Picture( "D2_QUANT"		))),;
		Alltrim(Transform(_aNFIt[_oListNF:nAt,10],X3Picture( "D2_PRCVEN"	))),;
		Alltrim(Transform(_aNFIt[_oListNF:nAt,11],X3Picture( "D2_TOTAL"		))) } }

		_oListNF:bLDblClick := {|| If(_aNFIt[_oListNF:nAt][2] = "1",Check(2,_aNFIt,_oListNF),Nil)}

		_oSay01	:= TSay():New( 170,142,{||"Procurar:"},_oNFIt,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,025,010)

		_oGet01	:= TGet():New( 170, 168,{|u| If(PCount()>0,_cSearch:=u,_cSearch)},_oNFIt,050,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cSearch",,)

		_oBtn3 := TButton():New( 170,220,"Pesquisar",_oNFIt, {|| PesqCpo(_cSearch,_aNFIt,_oListNF,,,4)},	050,012,,,,.T.,,"",,,,.F. )

		_aLegAux := {}
		AADD(_aLegAux,{"BR_VERDE"		,"Nota Fiscal Liberada" })
		AADD(_aLegAux,{"BR_PRETO"		,"Nota Fiscal com Quantidade Inferior" })
		AADD(_aLegAux,{"BR_VERMELHO"	,"Nota Fiscal com Valor Divergente" })

		//		_oBtn1 := TButton():New( 170,280,"Legenda",_oNFIt, {|| Lege_PC('Nota Fiscal',_aLegAux) },	050,012,,,,.T.,,"",,,,.F. )
		_oBtn1 := TButton():New( 170,280,"Legenda",_oNFIt, {|| BrwLegenda('Nota Fiscal', "Legenda", _aLegAux)  },	050,012,,,,.T.,,"",,,,.F. )

		_oBtn2 := TButton():New( 170,340,"OK",_oNFIt, {|| _oNFIt:End() },	050,012,,,,.T.,,"",,,,.F. )

		ACTIVATE MSDIALOG _oNFIt CENTERED

		_cSer := _cNF := _cIt := _cTes := ''
		For _nIt := 1 to Len(_aNFIt)
			If _aNFIt[_nIt][1]
				_cSer := _aNFIt[_nIt][3]
				_cNF  := _aNFIt[_nIt][4]
				_cIt  := _aNFIt[_nIt][5]
				_cTes := Posicione("SF4",1,xFilial("SF4")+_aNFIt[_nIt][8],"F4_TESDV")
			Endif
		Next _nIt

		If !Empty(_cNF)
			_nStat := PEDIDO_OK
		Else
			_nStat := SEM_NF_ORIGINAL
		Endif

		ZA2->(dbGoto(_aItem[_oListIt:nAt][Len(_aFldIte)]))

		ZA2->(RecLock("ZA2",.F.))
		ZA2->ZA2_SERNFO	:= _cSer
		ZA2->ZA2_NFORIG	:= _cNF
		ZA2->ZA2_ITNFOR	:= _cIt
		ZA2->ZA2_TES	:= _cTes
		ZA2->ZA2_STATUS	:= _nStat
		ZA2->(MsUnLock())

		_aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_SERNFO'})]	:= _cSer
		_aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_NFORIG'})]	:= _cNF
		_aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_ITNFOR'})]	:= _cIt
		_aItem[_oListIt:nAt][aSCan(_aFldIte,{|x| x[1] == 'ZA2_TES'})]		:= _cTes
		_aItem[_oListIt:nAt][1] := _nStat

	Else
		ShowHelpDlg("XMLNFORI_2", {'Não foi encontrado Nota Fiscal para este Produto.'},2,{'Confirme se a NF Original vinculada no XML está correta..'},2)
	Endif

	TSD2->(dbCloseArea())

	RestArea(_AreaZA2)
	RestArea(_AreaSD2)
	RestArea(_AreaORI)

	_oListIt:Refresh()

	CheckStat(_aItem,_oListIt)

	//Return(_aNFIt)
Return(Nil)




//Vincular o Fornecedor
Static Function XML_FORN()

	Local _cCod		:= ''
	Local _cLoj		:= ''
	Local _cNom		:= ''
	Local _AreaZA1	:= ZA1->(GetArea())
	Local _AreaZA2	:= ZA2->(GetArea())
	Local _cKey		:= ''
	Local _cTp		:= ''

	If _nStatus = NF_SEM_FORNECEDOR

		If _cTipo = "D"
			SA1->(dbsetOrder(3))
			If SA1->(msSeek(xFilial("SA1")+_cCNPJ))
				_cCod := SA1->A1_COD
				_cLoj := SA1->A1_LOJA
				_cNom := SA1->A1_NOME
			Endif
			_cTp := 'Cliente'
		Else
			SA2->(dbsetOrder(3))
			If SA2->(msSeek(xFilial("SA2")+_cCNPJ))
				_cCod := SA2->A2_COD
				_cLoj := SA2->A2_LOJA
				_cNom := SA2->A2_NOME
			Endif
			_cTp := 'Fornecedor'
		Endif

		If !Empty(_cCod)
			ZA1->(dbGoTo(_nRecZA1))

			ZA1->(RecLock("ZA1",.F.))
			ZA1->ZA1_STATUS	:= NF_NOK
			ZA1->ZA1_FORNEC	:= _cCod
			ZA1->ZA1_LOJA	:= _cLoj
			ZA1->ZA1_NOME	:= _cNom
			ZA1->(MsUnLock())

			ZA2->(dbSetOrder(1))
			If ZA2->(msSeek(xFilial("ZA2")+ZA1->ZA1_SERIE+ZA1->ZA1_DOC))

				_cKey := ZA2->ZA2_FILIAL+ZA2->ZA2_SERIE+ZA2->ZA2_DOC//+ZA2->ZA2_FORNEC+ZA2->ZA2_LOJA

				While ZA2->(!Eof()) .And. _cKey == ZA2->ZA2_FILIAL+ZA2->ZA2_SERIE+ZA2->ZA2_DOC//+ZA2->ZA2_FORNEC+ZA2->ZA2_LOJA

					If Empty(ZA2->ZA2_FORNEC)

						ZA2->(RecLock("ZA2",.F.))
						ZA2->ZA2_FORNEC	:= _cCod
						ZA2->ZA2_LOJA	:= _cLoj
						ZA2->(MsUnLock())

					Endif

					ZA2->(dbSkip())
				EndDo
			Endif

			U_AS_GetXML(2) //Verifica se existe arquivo para ser importado

		Else
			ShowHelpDlg("XML_FORN_1", {'Não existe cadastro de '+_cTp+' para o CNPJ do XML.'},2,{'Cadastre um novo '+_cTp+'.'},2)
		Endif
	Else
		ShowHelpDlg("XML_FORN_2", {'Esta rotina só deverá ser utilizada para o XML que não tem código de Fornecedor/Cliente vinculado.'},2,{'Não se aplica.'},2)
	Endif

	RestArea(_AreaZA2)
	RestArea(_AreaZA1)

Return(Nil)


//Valida os Pedidos de Compras marcados.
Static Function GetQtdPed()

	Local _nCount	:= 0
	Local _cPed		:= _cItP := _cTes := _cTesBkp :=  ''
	Local _aPedMarc	:= {}
	Local _lRet		:= .T.
	Local _cQtPed	:= 0
	Local _nIt		:= 0

	For _nIt := 1 to Len(_aPedIt)
		If _aPedIt[_nIt][1]

			_cPed := _aPedIt[_nIt][3]
			_cItP := _aPedIt[_nIt][4]
			_cTes := _aPedIt[_nIt][7]
			_nQPC := _aPedIt[_nIt][8] - _aPedIt[_nIt][9]
			_cVPC := _aPedIt[_nIt][11]
			AAdd(_aPedMarc,{_cPed , _cItP , _cTes , _nQPC})
			_nCount ++
			_cQtPed += _nQPC

			If _cTesBkp <> _cTes .And. !Empty(_cTesBkp)
				_lRet := .F.
				ShowHelpDlg("GetQtdPed_1", {'A TES dos Pedidos marcados são diferentes.'},2,{'Utilizar Pedidos com a mesma TES!'},2)
				Exit
			Endif

			_cTesBkp := _cTes

		Endif
	Next _nIt

	_aPedido := {_nCount,_aPedMarc}

	If _cQtPed <> _nQtItXML .And. _cQtPed > 0 .And. _lRet
		_lRet := .F.
		ShowHelpDlg("GetQtdPed", {'Quantidade total do(s) Pedido(s) é diferente da quantidade do Item do XML.'},2,{'Não se aplica.'},2)
	Endif

	If _lRet .And. _nCount > 1
		If !MsgYesNO('Foi marcado mais de 1 Pedido, dessa forma ao gerar o Documento de Entrada o Item será desmembrado, conforme a quantidade de pedidos marcados! Confirma?')
			_lRet := .F.
		Endif
	Endif

Return(_lRet)



Static Function GRPFIL()

	Local _cVldAlt	:= ".T." // Operacao: ALTERACAO
	Local _cVldExc	:= ".T." // Operacao: EXCLUSAO

	chkFile("ZA4")

	ZA4->(dbSetOrder(1))

	axCadastro("ZA4", "Grupos de Filiais", _cVldExc, _cVldAlt)

Return(Nil)