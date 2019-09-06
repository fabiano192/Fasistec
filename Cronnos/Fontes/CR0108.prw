#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} CR0108
//Apontamento de Produção
@author Fabiano
@since 13/08/2018
@version 1.0

@type function
/*/
User Function CR0108()

	Private _oBrowse 	:= FwMBrowse():New()				//Variavel de Browse

	Atu_SX1()

	//Alias do Browse
	_oBrowse:SetAlias('FZ1')

	//Descrição da Parte Superior Esquerda do Browse
	_oBrowse:SetDescripton("Apontamento de Produção")

	//Ativa o Browse
	_oBrowse:Activate()

Return(NIL)



Static Function Atu_SX1()

	Local _cPerg := "CR0108"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                            ³
	//³ mv_par01        	// Tipo                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄ¿

	//    	   Grupo/Ordem/Pergunta           /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02	/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(_cPerg,"01","Tipo Apontamento ?",""       ,""      ,"mv_ch1","N" ,01     ,0      ,0     ,"C",""            ,"MV_PAR01","Prensa"          ,""     ,""     ,""   ,""        ,"Acabamento"               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return(Nil)



Static Function MenuDef()

	Local _aMenu :=	{}

	ADD OPTION _aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'       	OPERATION 1 ACCESS 0
	ADD OPTION _aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.CR0108'	OPERATION 2 ACCESS 0
	ADD OPTION _aMenu TITLE 'Incluir'    ACTION 'VIEWDEF.CR0108'	OPERATION 3 ACCESS 0
	ADD OPTION _aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.CR0108'	OPERATION 5 ACCESS 0

Return(_aMenu)



Static Function ModelDef()

	// Cria as estruturas a serem usadas no Modelo de Dados
	Local _oStruFZ1 := FWFormStruct( 1, 'FZ1' )
	Local _oStruFZ2 := FWFormStruct( 1, 'FZ2' )
	Local _oStruFZ3 := FWFormStruct( 1, 'FZ3' )
	Local _oStruFZ4 := FWFormStruct( 1, 'FZ4' )
	Local _oModel

	Local _cVlProd	:= "ExistCpo('SB1') .And. U_CR108VldField('FZ1_PRODUT')"
	Local _bVlProd	:= Nil

	Local _cOperad	:= "Vazio() .or. U_CR108VldField('FZ1_OPERAD')"
	Local _bOperad	:= Nil

	Local _cVlQtde	:= "U_CR108VldField('FZ1_QTDEPR')"
	Local _bVlQtde	:= Nil

	Local _cPerda	:= "U_CR108VldField('FZ1_PERDA')"
	Local _bPerda	:= Nil

	// Cria o objeto do Modelo de Dados
	_oModel := MPFormModel():New('CR108PE',/*Pre-Validacao*/,/*Pos-Validacao*/ { | _oModel | TudoOk( _oModel ) },/*Commit*/,/*Cancel*/)

	_bVlProd := FWBuildFeature( STRUCT_FEATURE_VALID, _cVlProd )
	_oStruFZ1:SetProperty('FZ1_PRODUT',MODEL_FIELD_VALID,_bVlProd)

	_bOperad := FWBuildFeature( STRUCT_FEATURE_VALID, _cOperad )
	_oStruFZ1:SetProperty('FZ1_OPERAD',MODEL_FIELD_VALID,_bOperad)

	_bVlQtde := FWBuildFeature( STRUCT_FEATURE_VALID, _cVlQtde )
	_oStruFZ1:SetProperty('FZ1_QTDEPR',MODEL_FIELD_VALID,_bVlQtde)

	_bPerda := FWBuildFeature( STRUCT_FEATURE_VALID, _cPerda )
	_oStruFZ1:SetProperty('FZ1_PERDA',MODEL_FIELD_VALID,_bPerda)

	_oStruFZ1:SetProperty('FZ1_PRENSA'	,MODEL_FIELD_WHEN,{||M->FZ1_TIPO = 'P'})
	_oStruFZ1:SetProperty('FZ1_CICLO'	,MODEL_FIELD_WHEN,{||M->FZ1_TIPO = 'P'})
	_oStruFZ1:SetProperty('FZ1_CAVIDA'	,MODEL_FIELD_WHEN,{||M->FZ1_TIPO = 'P'})

	CR108GAT(_oStruFZ1,_oStruFZ3,_oStruFZ4)

	// Adiciona a descrição do Modelo de Dados
	_oModel:SetDescription( 'Apontamento Produção' )

	_oModel:AddFields( 'FZ1MASTER', /*cOwner*/, _oStruFZ1 )

	_oModel:SetPrimaryKey({})

	// Adiciona ao modelo uma componente de grid
	_oModel:AddGrid( 'FZ2GRID', 'FZ1MASTER', _oStruFZ2 )

	// Adiciona ao modelo uma componente de grid
	_oModel:AddGrid( 'FZ3GRID', 'FZ1MASTER', _oStruFZ3 )

	// Adiciona ao modelo uma componente de grid
	_oModel:AddGrid( 'FZ4GRID', 'FZ1MASTER', _oStruFZ4 )

	//	_oModel:AddGrid( 'FZ4GRID', 'FZ1MASTER' ,_oStruFZ4,,{|_oStruFZ4| LineOK(_oModel)} )

	// Faz relacionamento entre os componentes do model
	_oModel:SetRelation( 'FZ2GRID', { { 'FZ2_FILIAL', 'xFilial( "FZ2" )' }, { 'FZ2_CODIGO','FZ1_CODIGO' } }, FZ2->( IndexKey( 1 ) ) )
	_oModel:SetRelation( 'FZ3GRID', { { 'FZ3_FILIAL', 'xFilial( "FZ3" )' }, { 'FZ3_CODIGO','FZ1_CODIGO' } }, FZ3->( IndexKey( 1 ) ) )
	_oModel:SetRelation( 'FZ4GRID', { { 'FZ4_FILIAL', 'xFilial( "FZ4" )' }, { 'FZ4_CODIGO','FZ1_CODIGO' } }, FZ4->( IndexKey( 1 ) ) )

	// Adiciona a descrição dos Componentes do Modelo de Dados
	_oModel:GetModel( 'FZ1MASTER' ):SetDescription( 'Apontamento Produção' )
	_oModel:GetModel( 'FZ2GRID' ):SetDescription( 'Ordem Produção' )
	_oModel:GetModel( 'FZ3GRID' ):SetDescription( 'Ocorrências' )
	_oModel:GetModel( 'FZ4GRID' ):SetDescription( 'Perdas' )
	// Retorna o Modelo de dados

	//	_oModel:GetModel( 'FZ4GRID' ):SetNoUpdateLine(.T.)
	_oModel:GetModel( 'FZ2GRID' ):SetNoUpdateLine(.F.)
	_oModel:GetModel( 'FZ2GRID' ):SetNoInsertLine(.T.)

	_oModel:GetModel( 'FZ4GRID' ):SetOptional( .T. )
	_oModel:GetModel( 'FZ3GRID' ):SetOptional( .T. )

Return _oModel



Static Function ViewDef()

	// Cria um objeto de Modelo de dados baseado no ModelDef do fonte informado
	Local _oModel := FWLoadModel( 'CR0108' )
	Local _oModelFZ1:= _oModel:GetModel( 'FZ1MASTER' )

	// Cria as estruturas a serem usadas na View
	Local _oStruFZ1 := FWFormStruct( 2, 'FZ1' )
	Local _oStruFZ2 := FWFormStruct( 2, 'FZ2' )
	Local _oStruFZ3 := FWFormStruct( 2, 'FZ3' )
	Local _oStruFZ4 := FWFormStruct( 2, 'FZ4' )
	Local _nOpc		:= _oModel:GetOperation()

	// Interface de visualização construída
	Local _oView

	_oView := FWFormView():New()

	// Define qual Modelo de dados será utilizado
	_oView:SetModel( _oModel )

	// Adiciona no nosso View um controle do tipo formulário (antiga Enchoice)AdvPl utilizando MVC – 27
	_oView:AddField( 'VIEW_FZ1', _oStruFZ1, 'FZ1MASTER' )

	//Adiciona no nosso View um controle do tipo Grid (antiga Getdados)
	_oView:AddGrid( 'VIEW_FZ2', _oStruFZ2, 'FZ2GRID' )
	_oView:AddGrid( 'VIEW_FZ3', _oStruFZ3, 'FZ3GRID' )
	_oView:AddGrid( 'VIEW_FZ4', _oStruFZ4, 'FZ4GRID' )

	// Cria um "box" horizontal para receber cada elemento da view
	_oView:CreateHorizontalBox( 'P01', 50 )
	_oView:CreateHorizontalBox( 'P02', 25 )
	_oView:CreateHorizontalBox( 'P03', 25 )

	_oView:CreateVerticalBox( 'P03L', 50, 'P03' )
	_oView:CreateVerticalBox( 'P03R', 50, 'P03' )

	_oView:SetOwnerView( 'VIEW_FZ1', 'P01' )
	_oView:SetOwnerView( 'VIEW_FZ3', 'P02' )
	_oView:SetOwnerView( 'VIEW_FZ4', 'P03L' )
	_oView:SetOwnerView( 'VIEW_FZ2', 'P03R' )

	_oView:EnableTitleView( 'VIEW_FZ1' )
	_oView:EnableTitleView( 'VIEW_FZ3', "Ocorrências" )
	_oView:EnableTitleView( 'VIEW_FZ4', "Perdas" )
	_oView:EnableTitleView( 'VIEW_FZ2', "Ordens de Produção" )

	_oStruFZ2:RemoveField( 'FZ2_CODIGO' )
	_oStruFZ2:RemoveField( 'FZ2_OK' )
	_oStruFZ3:RemoveField( 'FZ3_CODIGO' )
	_oStruFZ4:RemoveField( 'FZ4_CODIGO' )

	_oModel:Activate()

	_oModel:DeActivate()

Return _oView



User Function CR108VldField(_cField)

	Local _xRet		:= .T.
	Local _oModel	:= FWModelActive()
	Local _oView	:= FWViewActive()
	Local _oModelFZ1:= _oModel:GetModel( 'FZ1MASTER' )
	Local _oModelFZ4:= _oModel:GetModel( 'FZ4GRID' )
	Local _oModelFZ2:= _oModel:GetModel( 'FZ2GRID' )
	Local _cQuery	:= ''
	Local _cOP		:= ''
	Local _nLinFZ2	:= 0
	Local _lNewLin	:= .F.
	Local _nQtde	:= 0
	Local _nSldOP	:= 0
	Local _nTSC2	:= 0
	Local _lGo		:= .T.
	Local _nRow		:= 0

	If _cField = "FZ1_OPERAD"
		SZ6->(dbSetOrder(1))
		If !SZ6->(msSeek(xFilial("SZ6")+_oModelFZ1:GetValue("FZ1_OPERAD")))
			_xRet := .F.
			ShowHelpDlg("CR0108_1", {'Código inexistente.'},1,{'Digite um código válido.'},1)
		Else
			If SZ6->Z6_TIPO <> '1' .And. _oModelFZ1:GetValue("FZ1_TIPO") = 'P'
				_xRet := .F.
				ShowHelpDlg("CR0108_2", {'Código não se refere à um Prensista.'},1,{'Digite um código válido.'},1)
			ElseIf SZ6->Z6_TIPO <> '2' .And. _oModelFZ1:GetValue("FZ1_TIPO") = 'A'
				_xRet := .F.
				ShowHelpDlg("CR0108_13", {'Código não se refere à um Operador de Acabamento.'},1,{'Digite um código válido.'},1)
			Endif
		Endif
	ElseIf _cField = "FZ1_PRODUT"
		SB1->(dbsetOrder(1))
		If SB1->(msSeek(xFilial("SB1")+_oModelFZ1:GetValue("FZ1_PRODUT")))
			IF SB1->B1_LOCPAD <> '45' .And. _oModelFZ1:GetValue("FZ1_TIPO") = 'P'
				_xRet := .F.
				ShowHelpDlg("CR0108_3", {'Produto não está localizado no armazém 45.'},1,{'Digite um código válido.'},1)
			ElseIF SB1->B1_LOCPAD <> '99' .And. _oModelFZ1:GetValue("FZ1_TIPO") = 'A'
				_xRet := .F.
				ShowHelpDlg("CR0108_14", {'Produto não está localizado no armazém 99.'},1,{'Digite um código válido.'},1)
			Endif
		Endif
	ElseIf _cField $ "FZ1_QTDEPR|FZ1_PERDA"

		SB1->(dbsetOrder(1))
		If SB1->(msSeek(xFilial("SB1")+_oModelFZ1:GetValue("FZ1_PRODUT")))

			_oModel:GetModel( 'FZ2GRID' ):SetNoUpdateLine(.F.)
			_oModel:GetModel( 'FZ2GRID' ):SetNoInsertLine(.F.)
			_oModel:GetModel( 'FZ2GRID' ):SetNoDeleteLine(.F.)

			If Select("TSC2") > 0
				TSC2->(dbCloseArea())
			Endif

			_cQuery += " SELECT * FROM "+retSqlName("SC2")+" C2 (NOLOCK)" +CRLF
			_cQuery += " WHERE C2.D_E_L_E_T_ = '' AND C2_FILIAL = '"+xFilial("SC2")+"' " +CRLF
			_cQuery += " AND C2_PRODUTO = '"+SB1->B1_COD+"' " +CRLF
			_cQuery += " AND C2_LOCAL = '"+SB1->B1_LOCPAD+"' " +CRLF
			_cQuery += " AND C2_QUANT > C2_QUJE " +CRLF
			_cQuery += " ORDER BY C2_NUM,C2_ITEM,C2_SEQUEN " +CRLF

			TcQuery _cQuery New Alias "TSC2"

			Count to _nTSC2

			If _nTSC2 > 0

				TSC2->(dbGotop())

				_lGo		:= .T.
				_nLinFZ2	:= 0
				_nQtde		:= _oModelFZ1:GetValue("FZ1_QTDEPR")
				_nQtde		+= _oModelFZ1:GetValue("FZ1_PERDA")

				For _nRow := 1 To _oModelFZ2:Length()

					_oModelFZ2:GoLine(_nRow)

					If !Empty(_oModelFZ2:GetValue("FZ2_QTDEAP"))
						_oModel:SetValue('FZ2GRID','FZ2_QTDEAP'	, 0)
					Endif

				Next _nRow

				While TSC2->(!EOF()) .And. _lGo

					_cOP	:= TSC2->C2_NUM+TSC2->C2_ITEM+TSC2->C2_SEQUEN
					_nSldOP	:= TSC2->C2_QUANT - TSC2->C2_QUJE
					_lNewLin := .T.

					For _nRow := 1 To _oModelFZ2:Length()

						_oModelFZ2:GoLine(_nRow)

						If _oModelFZ2:GetValue("FZ2_OP") = _cOP .And. _oModelFZ2:GetValue("FZ2_OP") = _oModelFZ1:GetValue("FZ1_CODIGO")

							If _oModelFZ2:IsDeleted()
								_oModelFZ2:UnDeleteLine()
							Endif
							If _nQtde <= _nSldOP
								_oModel:SetValue('FZ2GRID','FZ2_QTDEAP'	,_nQtde)
								_lGo := .F.
								_nQtde := 0

							ElseIf _nQtde > _nSldOP
								_nQtde -= _nSldOP
								_oModel:SetValue('FZ2GRID','FZ2_QTDEAP'	, _nSldOP)
							Endif
							_lNewLin := .F.
						Endif

					Next _nRow


					If _lNewLin
						_nLinFZ2 ++
						If _nLinFZ2 > 1
							If _oModelFZ2:AddLine() <> _nLinFZ2
								_lNewLin := .F.
							Endif
						Endif

						If _nQtde <= _nSldOP
							_oModel:SetValue('FZ2GRID','FZ2_OP'		, _cOP )
							_oModel:SetValue('FZ2GRID','FZ2_QTOP'	, TSC2->C2_QUANT )
							_oModel:SetValue('FZ2GRID','FZ2_SLDOOP'	, _nSldOP)
							_oModel:SetValue('FZ2GRID','FZ2_QTDEAP'	, _nQtde)

							_lGo := .F.
							_nQtde := 0
						ElseIf _nQtde > _nSldOP
							_nQtde -= _nSldOP
							_oModel:SetValue('FZ2GRID','FZ2_OP'		, _cOP )
							_oModel:SetValue('FZ2GRID','FZ2_QTOP'	, TSC2->C2_QUANT )
							_oModel:SetValue('FZ2GRID','FZ2_SLDOOP'	, _nSldOP)
							_oModel:SetValue('FZ2GRID','FZ2_QTDEAP'	, _nSldOP)
						Endif

					Endif

					TSC2->(dbSkip())
				EndDo

				TSC2->(dbCloseArea())

				For _nRow := 1 To _oModelFZ2:Length()

					_oModelFZ2:GoLine(_nRow)

					If !_oModelFZ2:IsDeleted() .And. Empty(_oModelFZ2:GetValue("FZ2_QTDEAP"))
						//						_oModel:SetValue('FZ2GRID','FZ2_QTDEAP'	, 0)
						_oModelFZ2:DeleteLine()
					Endif

				Next _nRow

				_oModelFZ2:GoLine(1)

				If _nQtde > 0
					_xRet := .F.
					ShowHelpDlg("CR0108_10", {'Não existe quantidade suficiente de OP em aberto.'},1,{'Realize o ajuste antes de prosseguir.'},1)
					For _nRow := 1 To _oModelFZ2:Length()

						_oModelFZ2:GoLine(_nRow)

						If !_oModelFZ2:IsDeleted()
							_oModelFZ2:SetValue('FZ2_QTDEAP'	, 0)
							_oModelFZ2:DeleteLine()
						Endif

					Next _nRow
				Endif
			Else
				_xRet := .F.
				ShowHelpDlg("CR0108_4", {'Não existe OP em aberto para este produto.'},1,{'Digite um código válido.'},1)
			Endif

			_oModel:GetModel( 'FZ2GRID' ):SetNoUpdateLine(.T.)
			_oModel:GetModel( 'FZ2GRID' ):SetNoInsertLine(.T.)
			_oModel:GetModel( 'FZ2GRID' ):SetNoDeleteLine(.T.)

		Endif
//	ElseIf _cField = "FZ1_TIPO"
//
//		Pergunte("CR0108",.T.)
//
//		If MV_PAR01 = 1
//			_xRet := 'P'
//		Else
//			_xRet := 'A'
//		Endif

	Endif

Return(_xRet)



//Gatilhos
Static Function CR108GAT(_oStruFZ1,_oStruFZ3,_oStruFZ4)

	Local _aAux

	//Gatilho para Tipo
	_aAux := FWStruTrigger("FZ1_TIPO"	,"FZ1_OPERAD"	,Space(TamSX3("FZ1_OPERAD")[1]),.F.)
	_oStruFZ1:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

	//Gatilho para Tipo
	_aAux := FWStruTrigger("FZ1_TIPO"	,"FZ1_NOME"	,Space(TamSX3("FZ1_NOME")[1]),.F.)
	_oStruFZ1:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

	//Gatilho para Tipo
	_aAux := FWStruTrigger("FZ1_TIPO"	,"FZ1_PRODUT"	,Space(TamSX3("FZ1_PRODUT")[1]),.F.)
	_oStruFZ1:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

	//Gatilho para Tipo
	_aAux := FWStruTrigger("FZ1_TIPO"	,"FZ1_CICLO"	,'0',.F.)
	_oStruFZ1:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

	//Gatilho para Tipo
	_aAux := FWStruTrigger("FZ1_TIPO"	,"FZ1_PRENSA"	,Space(TamSX3("FZ1_PRENSA")[1]),.F.)
	_oStruFZ1:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

	//Gatilho para Tipo
	_aAux := FWStruTrigger("FZ1_TIPO"	,"FZ1_CAVIDA"	,'0',.F.)
	_oStruFZ1:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])




	//Gatilho para Nome do Prensista
	_aAux := FWStruTrigger("FZ1_OPERAD"	,"FZ1_NOME"	,"SZ6->Z6_NOME"	,.T.,"SZ6",1,'xFilial("SZ6")+M->FZ1_OPERAD', NIL,"01")
	_oStruFZ1:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

	//Gatilho para Produto
	_aAux := FWStruTrigger("FZ1_PRODUT"	,"FZ1_PRODUT",'U_GATFZ1("FZ1_PRODUT")'	,.F.)
	_oStruFZ1:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

	//Gatilho para Produto
	_aAux := FWStruTrigger("FZ1_PERDA"	,"FZ1_PERDA",'U_GATFZ1("FZ1_PERDA")'	,.F.)
	_oStruFZ1:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])



	//Gatilho para Ocorrencia
	_aAux := FWStruTrigger("FZ3_OCORRE"	,"FZ3_DESCOC"	,"SX5->X5_DESCRI"	,.T.,"SX5",1,'xFilial("SX5")+"Z4"+M->FZ3_OCORRE', NIL,"01")
	_oStruFZ3:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

	//Gatilho para Ocorrencia
	_aAux := FWStruTrigger("FZ3_DTINIC"	,"FZ3_TOTAL"	,"U_GATFZ3('FZ3_DTINIC')"	,.F.)
	_oStruFZ3:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])
	//Gatilho para Ocorrencia
	_aAux := FWStruTrigger("FZ3_HRINIC"	,"FZ3_TOTAL"	,"U_GATFZ3('FZ3_HRINIC')"	,.F.)
	_oStruFZ3:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])
	//Gatilho para Ocorrencia
	_aAux := FWStruTrigger("FZ3_DTFINA"	,"FZ3_TOTAL"	,"U_GATFZ3('FZ3_DTFINA')"	,.F.)
	_oStruFZ3:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])
	//Gatilho para Ocorrencia
	_aAux := FWStruTrigger("FZ3_HRFINA"	,"FZ3_TOTAL"	,"U_GATFZ3('FZ3_HRFINA')"	,.F.)
	_oStruFZ3:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

	//Gatilho para Ocorrencia
	_aAux := FWStruTrigger("FZ3_OCORRE"	,"FZ3_DESCOC"	,"SX5->X5_DESCRI"	,.T.,"SX5",1,'xFilial("SX5")+"Z4"+M->FZ3_OCORRE', NIL,"01")
	_oStruFZ3:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])


	//Gatilho para Motivo Perda
	_aAux := FWStruTrigger("FZ4_MOTIVO"	,"FZ4_DESCRI"	,"SX5->X5_DESCRI"	,.T.,"SX5",1,'xFilial("SX5")+"43"+M->FZ4_MOTIVO', NIL,"01")
	_oStruFZ4:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

Return(Nil)



User Function GATFZ1(_cField)

	Local _xRet 	:= Nil
	Local _Area 	:= GetArea()

	Local _oModel	:= FWModelActive()
	Local _oView	:= FWViewActive()

	Local _cPrensa	:= Space(TAMSX3("FZ1_PRENSA")[1])
	Local _nCiclo	:= 0
	Local _nCavid	:= 0
	Local _cKey		:= ''

	If _cField = 'FZ1_PRODUT' .And. _oModel:GetValue('FZ1MASTER',"FZ1_TIPO") = 'P'
		_xRet	:= _oModel:GetValue('FZ1MASTER',"FZ1_PRODUT")
		_cPrensa := Space(TAMSX3("FZ1_PRENSA")[1])
		_nCiclo  := 0
		_nCavid  := 0

		SB1->(dbsetOrder(1))
		If SB1->(msSeek(xFilial("SB1")+_xRet))
			SG1->(dbSetOrder(2))
			If SG1->(msSeek(xFilial("SG1")+_xRet))
				_cKey := xFilial("SG1")+_xRet

				While SG1->(!EOF())

					SB1->(dbSetOrder(1))
					SB1->(msSeek(xFilial("SB1")+SG1->G1_COD))

					If SB1->B1_TIPO = 'PA'
						_cPrensa := SB1->B1_9RECURS
						_nCiclo  := SB1->B1_9CICLO
						_nCavid  := SB1->B1_CAVMOO
						Exit
					Endif

					SG1->(dbSkip())
				EndDo
			Endif
		Endif

		_oModel:SetValue('FZ1MASTER','FZ1_PRENSA',_cPrensa )
		_oModel:SetValue('FZ1MASTER','FZ1_CICLO' ,_nCiclo )
		_oModel:SetValue('FZ1MASTER','FZ1_CAVIDA',_nCavid )

	ElseIf _cField = "FZ1_PERDA"

		_xRet := _oModel:GetValue('FZ1MASTER',"FZ1_PERDA")

		If _xRet > 0
			_oModel:GetModel( 'FZ4GRID' ):SetNoUpdateLine(.F.)
		Else
			_oModel:GetModel( 'FZ4GRID' ):SetNoUpdateLine(.T.)
		Endif
	Endif

	_oView:Refresh()

	Restarea(_Area)

Return(_xRet)




User Function GATFZ3(_cField)

	Local _Area		:= GetArea()
	Local _AreaFZ3	:= FZ3->(GetArea())

	Local _oModel	:= FWModelActive()
	Local _oView	:= FWViewActive()

	Local _nTot		:= 0

	Local _dDtIni := _oModel:GetValue('FZ3GRID',"FZ3_DTINIC")
	Local _dDtFim := _oModel:GetValue('FZ3GRID',"FZ3_DTFINA")
	Local _nHrIni := _oModel:GetValue('FZ3GRID',"FZ3_HRINIC")
	Local _nHrFim := _oModel:GetValue('FZ3GRID',"FZ3_HRFINA")

	If (_dDtFim < _dDtIni) .Or. (_dDtFim = _dDtIni .And. _nHrFim < _nHrIni)
		_nTot	:= 0
	Else
		_nTot	:= DataHora2Val(_dDtIni,_nHrIni,_dDtFim,_nHrFim,"H")
	Endif

	_oView:Refresh()

	Restarea(_AreaFZ3)
	Restarea(_Area)

Return(_nTot)



//Validação TudoOK
Static Function TudoOK(_oMod)

	Local _lRet		:= .T.
	Local _oModelFZ1:= _oMod:GetModel( 'FZ1MASTER' )
	Local _oModelFZ4:= _oMod:GetModel( 'FZ4GRID' )
	Local _oModelFZ2:= _oMod:GetModel( 'FZ2GRID' )
	Local _nRow		:= 0
	Local _nTotPer	:= 0
	Local _nTotAP	:= 0
	Local _nPerda	:= _oMod:GetValue('FZ1MASTER',"FZ1_PERDA")
	Local _nProdAP	:= _oMod:GetValue('FZ1MASTER',"FZ1_QTDEPR")
	Local _nOpc		:= _oMod:GetOperation()
	Local _aArea	:= GetArea()
	Local _dDtIni	:= _oMod:GetValue('FZ1MASTER',"FZ1_DTINIC")
	Local _dDtFim	:= _oMod:GetValue('FZ1MASTER',"FZ1_DTFINA")
	Local _nHrIni	:= _oMod:GetValue('FZ1MASTER',"FZ1_HRINIC")
	Local _nHrFim	:= _oMod:GetValue('FZ1MASTER',"FZ1_HRFINA")
	Local _dEmis	:= _oMod:GetValue('FZ1MASTER',"FZ1_EMISSA")
	Local _dDtFech	:= GetMv("MV_ULMES")
	Local _aVetor	:= {}
	Local _cTot		:= ''
	Local _cQry		:= ''
	Local _aCaPerda := {}
	Local _aItPerda := {}
	Local _aLiPerda := {}
	lOCAL _cLocB1	:= ''
	Local _cTM		:= ''


	If _nOpc = 5 //Excluir
		If _dEmis <= _dDtFech
			_lRet := .F.
			ShowHelpDlg("CR0108_9", {'Não é possível a exclusão do Apontamento, pois a data de fechamento de estoque é maior que a data de emissão.'},1,{'Não se aplica.'},1)
		Else

			If Select("TSD3") > 0
				TSD3->(dbCloseArea())
			Endif

			_cQry := " SELECT * FROM "+RetSqlName("SD3")+" D3 (NOLOCK) " + CRLF
			_cQry += " WHERE D3.D_E_L_E_T_ = '' AND D3_FILIAL = '"+xFilial("SD3")+"' AND D3_ESTORNO <> 'S' " +CRLF
			_cQry += " AND D3_YCODAPR = '"+ _oModelFZ1:GetValue("FZ1_CODIGO")+"' " +CRLF
			_cQry += " ORDER BY D3_DOC " +CRLF

			TcQuery _cQry New Alias "TSD3"

			TcSetField("TSD3","D3_EMISSAO","D")

			TSD3->(dbGoTop())

			Begin Transaction

				While TSD3->(!EOF())

					lMsErroAuto := .F.

					_aVetor := {;
					{"D3_TM"		, TSD3->D3_TM		, NIL},;
					{"D3_EMISSAO"	, TSD3->D3_EMISSAO	, NIL},;
					{"D3_COD"		, TSD3->D3_COD		, NIL},;
					{"D3_OP"		, TSD3->D3_OP		, NIL},;
					{"D3_QUANT"		, TSD3->D3_QUANT	, NIL},;
					{"D3_PERDA"		, TSD3->D3_PERDA	, NIL},;
					{"D3_PARCTOT"	, TSD3->D3_PARCTOT	, NIL},;
					{"D3_YCODAPR"	, TSD3->D3_YCODAPR	, NIL},;
					{"ATUEMP"		, "T"				, NIL}}

					MSExecAuto({|x, y| mata250(x, y)},_aVetor, _nOpc )

					If lMsErroAuto
						Mostraerro()
						DisarmTransaction()
					Endif

					TSD3->(dbSkip())
				EndDo
			End Transaction

			TSD3->(dbCloseArea())


			If Select("TSBC") > 0
				TSBC->(dbCloseArea())
			Endif

			_cQry := " SELECT * FROM "+RetSqlName("SBC")+" BC (NOLOCK) " + CRLF
			_cQry += " WHERE BC.D_E_L_E_T_ = '' AND BC_FILIAL = '"+xFilial("SBC")+"' " +CRLF
			_cQry += " AND BC_YCODAPR = '"+ _oModelFZ1:GetValue("FZ1_CODIGO")+"' " +CRLF
			_cQry += " ORDER BY BC_MOTIVO " +CRLF

			TcQuery _cQry New Alias "TSBC"

			TcSetField("TSBC","BC_DATA","D")

			TSBC->(dbGoTop())

			Begin Transaction

				_aCaPerda := {}
				_aItPerda := {}
				_aLiPerda := {}
				lMsErroAuto := .f.

				While TSBC->(!EOF())

					_aItPerda := {;
					{"BC_QUANT"		,TSBC->BC_QUANT			,NIL},;
					{"BC_QTDDEST"	,TSBC->BC_QTDDEST		,NIL},;
					{"BC_PRODUTO"	,TSBC->BC_PRODUTO		,NIL},;
					{"BC_CODDEST"	,TSBC->BC_CODDEST		,NIL},;
					{"BC_LOCORIG"	,TSBC->BC_LOCORIG		,NIL},;
					{"BC_LOCAL"		,TSBC->BC_LOCAL			,NIL},;
					{"BC_TIPO"		,TSBC->BC_TIPO			,NIL},;
					{"BC_DATA"		,TSBC->BC_DATA			,NIL},;
					{"BC_MOTIVO"	,TSBC->BC_MOTIVO		,NIL},;
					{"BC_RECURSO"	,TSBC->BC_RECURSO		,NIL},;
					{"BC_APONTAD"	,TSBC->BC_APONTAD		,NIL},;
					{"BC_YCODAPR"	,TSBC->BC_YCODAPR		,NIL}}

					AAdd(_aLiPerda ,_aItPerda)

					TSBC->(dbSkip())
				EndDo

				If !Empty(_aLiPerda)
					_aCaPerda := {{"BC_OP"      ,_oModelFZ2:GetValue("FZ2_OP")		,NIL}}

					MsExecAuto ( {|x,y,z| MATA685(x,y,z) }, _aCaPerda, _aLiPerda, 6)

					If lMsErroAuto
						Mostraerro()
						DisarmTransaction()
					Endif
				Endif

			End Transaction

			TSBC->(dbCloseArea())

		Endif
	ElseIf _nOpc == 3 //Inclui
		If _dEmis <= _dDtFech
			_lRet := .F.
			ShowHelpDlg("CR0108_12", {'Não é possível a inclusão do Apontamento, pois a data de fechamento de estoque é maior que a data de emissão.'},1,{'Não se aplica.'},1)
		ElseIf _dDtIni = _dDtFim .And. _nHrFim < _nHrIni
			_lRet := .F.
			ShowHelpDlg("CR0108_7", {'Hora Final menor que a Hora Inicial.'},1,{'Realize o ajuste antes de prosseguir.'},1)
		ElseIf _dDtIni > _dDtFim
			_lRet := .F.
			ShowHelpDlg("CR0108_8", {'Data Final menor que a Data Inicial.'},1,{'Realize o ajuste antes de prosseguir.'},1)
		ElseIf _oModelFZ1:GetValue("FZ1_TIPO") = 'P' .And. (Empty(_oModelFZ1:GetValue("FZ1_PRENSA")) .Or. Empty(_oModelFZ1:GetValue("FZ1_CAVIDA")) .or.;
			Empty(_oModelFZ1:GetValue("FZ1_CICLO")))

			_lRet := .F.
			ShowHelpDlg("CR0108_14", {'Preencher os campo "Prensa", "Ciclo" e "Cavidade".'},1,{'Campos Obrigatórios!'},1)

		Else
			For _nRow := 1 To _oModelFZ4:Length()

				_oModelFZ4:GoLine(_nRow)

				If !_oModelFZ4:IsDeleted()
					_nTotPer += _oModelFZ4:GetValue("FZ4_QTDE")
				Endif

			Next _nRow

			If _nTotPer <> _nPerda
				_lRet := .F.
				ShowHelpDlg("CR0108_5", {'Total de intens de Perda é diferente do informado no cabeçalho.'},1,{'Realize o ajuste antes de prosseguir.'},1)
			Endif

			For _nRow := 1 To _oModelFZ2:Length()

				_oModelFZ2:GoLine(_nRow)

				If !_oModelFZ2:IsDeleted()
					_nTotAP += _oModelFZ2:GetValue("FZ2_QTDEAP")
				Endif

			Next _nRow

			If _nTotAP <> (_nPerda+_nProdAP)
				_lRet := .F.
				ShowHelpDlg("CR0108_11", {'Total Produzido + Perda é diferente do total de OP Apontado.'},1,{'Realize o ajuste antes de prosseguir.'},1)
			Endif

			If _lRet

				_cTM := If(_oModelFZ1:GetValue("FZ1_TIPO") = "P","300","301")
				Begin Transaction

					For _nRow := 1 To _oModelFZ2:Length()

						_oModelFZ2:GoLine(_nRow)

						If !_oModelFZ2:IsDeleted() .And. _oModelFZ2:GetValue("FZ2_QTDEAP") > 0

							lMsErroAuto := .F.

							_cTot := If(_oModelFZ2:GetValue("FZ2_QTOP") = _oModelFZ2:GetValue("FZ2_QTDEAP"),'T','P')

							_aVetor := {;
							{"D3_TM"		, _cTM								, NIL},;
							{"D3_EMISSAO"	, dDataBase							, NIL},;
							{"D3_COD"		, _oModelFZ1:GetValue("FZ1_PRODUT")	, NIL},;
							{"D3_OP"		, _oModelFZ2:GetValue("FZ2_OP")		, NIL},;
							{"D3_QUANT"		, _oModelFZ2:GetValue("FZ2_QTDEAP")	, NIL},;
							{"D3_PERDA"		, 0									, NIL},;
							{"D3_PARCTOT"	, _cTot								, NIL},;
							{"D3_YCODAPR"	, _oModelFZ1:GetValue("FZ1_CODIGO")	, NIL},;
							{"ATUEMP"		, "T"								, NIL}}

							MSExecAuto({|x, y| mata250(x, y)},_aVetor, _nOpc )

							If lMsErroAuto
								Mostraerro()
								DisarmTransaction()
							Endif
						Endif

					Next _nRow

					_aCaPerda := {}
					_aItPerda := {}
					_aLiPerda := {}
					lMsErroAuto := .f.

					For _nRow := 1 To _oModelFZ4:Length()

						_oModelFZ4:GoLine(_nRow)

						If !_oModelFZ4:IsDeleted() .And. _oModelFZ4:GetValue("FZ4_QTDE") > 0

							_cLocB1 := Posicione("SB1",1,xFilial("SB1")+_oModelFZ1:GetValue("FZ1_PRODUT"),"B1_LOCPAD")

							_aItPerda := {;
							{"BC_QUANT"		,_oModelFZ4:GetValue("FZ4_QTDE")	,NIL},;
							{"BC_QTDDEST"	,_oModelFZ4:GetValue("FZ4_QTDE")	,NIL},;
							{"BC_PRODUTO"	,_oModelFZ1:GetValue("FZ1_PRODUT")	,NIL},;
							{"BC_CODDEST"	,_oModelFZ1:GetValue("FZ1_PRODUT")	,NIL},;
							{"BC_LOCORIG"	,_cLocB1							,NIL},;
							{"BC_LOCAL"		,"80"								,NIL},;
							{"BC_TIPO"		,"R" 								,NIL},;
							{"BC_DATA"		,dDatabase							,NIL},;
							{"BC_MOTIVO"	,_oModelFZ4:GetValue("FZ4_MOTIVO")	,NIL},;
							{"BC_RECURSO"	,_oModelFZ1:GetValue("FZ1_PRENSA")	,NIL},;
							{"BC_APONTAD"	,_oModelFZ1:GetValue("FZ1_OPERAD")	,NIL},;
							{"BC_YCODAPR"	,_oModelFZ1:GetValue("FZ1_CODIGO")	,NIL}}

							AAdd(_aLiPerda ,_aItPerda)

						Endif

					Next _nRow

					If !Empty(_aLiPerda)
						_aCaPerda := {{"BC_OP"      ,_oModelFZ2:GetValue("FZ2_OP")		,NIL},;
						{"CRECURSO"   ,_oModelFZ1:GetValue("FZ1_PRENSA")		,NIL}}

						MsExecAuto ( {|x,y,z| MATA685(x,y,z) }, _aCaPerda, _aLiPerda, 3)

						If lMsErroAuto
							Mostraerro()
							DisarmTransaction()
						Endif
					Endif

				End Transaction

			Endif
		Endif
	Endif

	RestArea(_aArea)
	FwModelActive( _oMod, .T. )

Return(_lRet)


/*
User Function CR108PE()

	Local aParam := PARAMIXB
	Local xRet := .T.
	Local oObj := ''
	Local cIdPonto := ''

	Local cIdModel := ''
	Local lIsGrid := .F.
	Local nLinha := 0
	Local nQtdLinhas := 0
	Local cMsg := ''

	Local _oModel := FWLoadModel( 'CR0108' )

	// Cria as estruturas a serem usadas na View
	Local _oStruFZ1 := FWFormStruct( 2, 'FZ1' )
	Local _nOpc		:= _oModel:GetOperation()


	If aParam <> NIL
		oObj := aParam[1]
		cIdPonto := aParam[2]
		cIdModel := aParam[3]
		lIsGrid := ( Len( aParam ) > 3 )
		If cIdPonto == 'MODELPOS'
			cMsg := 'Chamada na validação total do modelo (MODELPOS).' + CRLF
			cMsg += 'ID ' + cIdModel + CRLF
			If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
				Help( ,, 'Help',, 'O MODELPOS retornou .F.', 1, 0 )
			EndIf
		ElseIf cIdPonto == 'FORMPOS'
			cMsg := 'Chamada na validação total do formulário (FORMPOS).' + CRLF
			cMsg += 'ID ' + cIdModel + CRLF
//			If cClasse == 'FWFORMGRID'
//				cMsg += 'É um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ;
//				' linha(s).' + CRLF
//				cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha ) ) + CRLF
//			ElseIf cClasse == 'FWFORMFIELD'
//				cMsg += 'É um FORMFIELD' + CRLF
//			EndIf
			If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
				Help( ,, 'Help',, 'O FORMPOS retornou .F.', 1, 0 )
			EndIf
		ElseIf cIdPonto == 'FORMLINEPRE'
			If aParam[5] == 'DELETE'
				cMsg := 'Chamada na pré validação da linha do formulário (FORMLINEPRE).' + CRLF
				cMsg += 'Onde esta se tentando deletar uma linha' + CRLF
				cMsg += 'É um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) +' linha(s).' + CRLF
				cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha ) ) +CRLF
				cMsg += 'ID ' + cIdModel + CRLF
				If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
					Help( ,, 'Help',, 'O FORMLINEPRE retornou .F.', 1, 0 )
				EndIf
			EndIf
		ElseIf cIdPonto == 'FORMLINEPOS'
			cMsg := 'Chamada na validação da linha do formulário (FORMLINEPOS).' + CRLF
			cMsg += 'ID ' + cIdModel + CRLF
			cMsg += 'É um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ;
			' linha(s).' + CRLF
			cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha ) ) + CRLF
			If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
				Help( ,, 'Help',, 'O FORMLINEPOS retornou .F.', 1, 0 )
			EndIf
		ElseIf cIdPonto == 'MODELCOMMITTTS'
			ApMsgInfo('Chamada apos a gravação total do modelo e dentro da transação(MODELCOMMITTTS).' + CRLF + 'ID ' + cIdModel )
		ElseIf cIdPonto == 'MODELCOMMITNTTS'
			ApMsgInfo('Chamada apos a gravação total do modelo e fora da transação	(MODELCOMMITNTTS).' + CRLF + 'ID ' + cIdModel)
			//ElseIf cIdPonto == 'FORMCOMMITTTSPRE'
		ElseIf cIdPonto == 'FORMCOMMITTTSPOS'
			ApMsgInfo('Chamada apos a gravação da tabela do formulário(FORMCOMMITTTSPOS).' + CRLF + 'ID ' + cIdModel)
		ElseIf cIdPonto == 'MODELCANCEL'
			cMsg := 'Chamada no Botão Cancelar (MODELCANCEL).' + CRLF + 'Deseja Realmente	Sair ?'
			If !( xRet := ApMsgYesNo( cMsg ) )
				Help( ,, 'Help',, 'O MODELCANCEL retornou .F.', 1, 0 )
			EndIf
		ElseIf cIdPonto == 'MODELVLDACTIVE'
			cMsg := 'Chamada na validação da ativação do Model.' + CRLF + 'Continua ?'
			If !( xRet := ApMsgYesNo( cMsg ) )
				Help( ,, 'Help',, 'O MODELVLDACTIVE retornou .F.', 1, 0 )
			EndIf
		ElseIf cIdPonto == 'BUTTONBAR'
			ApMsgInfo('Adicionando Botão na Barra de Botões (BUTTONBAR).' + CRLF + 'ID ' +cIdModel )
			xRet := { {'Salvar', 'SALVAR', { || Alert( 'Salvou' ) }, 'Este botão Salva' } }
		EndIf
	EndIf
Return xRet
*/