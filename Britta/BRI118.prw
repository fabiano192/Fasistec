#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
Programa	:	BRI118
Autor		:	Fabiano da Silva
Data		:	30/11/2018
Descrição	:	Cadastro Empresa EDI - REDE
*/


User Function BRI118()

	Private _oBrowse 	:= FwMBrowse():New()				//Variavel de Browse

	_oBrowse:SetAlias('ZF3')

	_oBrowse:SetDescripton("Cadastro Empresa EDI - REDE")

	_oBrowse:Activate()

Return



Static Function MenuDef()

	Local aMenu :=	{}

	ADD OPTION aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'       	OPERATION 1 ACCESS 0
	ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.BRI118'	OPERATION 2 ACCESS 0
	ADD OPTION aMenu TITLE 'Incluir'    ACTION 'VIEWDEF.BRI118'	OPERATION 3 ACCESS 0
	ADD OPTION aMenu TITLE 'Alterar'    ACTION 'VIEWDEF.BRI118'	OPERATION 4 ACCESS 0
	ADD OPTION aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.BRI118'	OPERATION 5 ACCESS 0
	ADD OPTION aMenu TITLE 'Imprimir'   ACTION 'VIEWDEF.BRI118'	OPERATION 8 ACCESS 0
	ADD OPTION aMenu TITLE 'Copiar'     ACTION 'VIEWDEF.BRI118'	OPERATION 9 ACCESS 0

Return(aMenu)



Static Function ModelDef()

	//Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
	Local _oStruct	:=	FWFormStruct(1,"ZF3")
	Local _oModel

	//Instancia do Objeto de Modelo de Dados
	_oModel	:=	MPFormModel():New('BRI118PE',/*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Cancel*/)

	//Adiciona um modelo de Formulario de Cadastro Similar à Enchoice ou Msmget
	_oModel:AddFields('MODEL_BRI118', /*cOwner*/, _oStruct, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	//Adiciona Descricao do Modelo de Dados
	_oModel:SetDescription( 'Cadastro Empresa EDI - REDE' )

	_oModel:SetPrimaryKey({})

	//Adiciona Descricao do Componente do Modelo de Dados
	_oModel:GetModel( 'MODEL_BRI118' ):SetDescription( 'Cadastro Empresa EDI - REDE' )

Return(_oModel)



Static Function ViewDef()

	Local _oStruct	:=	FWFormStruct(2,"ZF3") 	//Retorna a Estrutura do Alias passado

	// como Parametro (1=Model,2=View)
	Local _oModel	:=	FwLoadModel('BRI118')	//Retorna o Objeto do Modelo de Dados
	Local oView		:=	FwFormView():New()      //Instancia do Objeto de Visualização

	//Define o Modelo sobre qual a Visualizacao sera utilizada
	oView:SetModel(_oModel)

	//Vincula o Objeto visual de Cadastro com o modelo
	oView:AddField( 'VIEW_BRI118', _oStruct, 'MODEL_BRI118')

	//Define o Preenchimento da Janela
	oView:CreateHorizontalBox( 'ID_100'  , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_BRI118', 'ID_100' )

Return(oView)
