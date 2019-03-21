#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
Programa	:	BRI124
Autor		:	Fabiano da Silva
Data		:	06/03/19
Descrição	:	Cadastro Empresa - Controle de Portaria
*/
User Function BRI124()

	Private _oBrowse 	:= FwMBrowse():New()				//Variavel de Browse

	_oBrowse:SetAlias('ZPX')

	_oBrowse:SetDescripton("Cadastro Empresa - Controle de Portaria")

	_oBrowse:Activate()

Return



Static Function MenuDef()

	Local aMenu :=	{}

	ADD OPTION aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'       	OPERATION 1 ACCESS 0
	ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.BRI124'	OPERATION 2 ACCESS 0
	ADD OPTION aMenu TITLE 'Incluir'    ACTION 'VIEWDEF.BRI124'	OPERATION 3 ACCESS 0
	ADD OPTION aMenu TITLE 'Alterar'    ACTION 'VIEWDEF.BRI124'	OPERATION 4 ACCESS 0
	ADD OPTION aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.BRI124'	OPERATION 5 ACCESS 0
	ADD OPTION aMenu TITLE 'Imprimir'   ACTION 'VIEWDEF.BRI124'	OPERATION 8 ACCESS 0
	ADD OPTION aMenu TITLE 'Copiar'     ACTION 'VIEWDEF.BRI124'	OPERATION 9 ACCESS 0

Return(aMenu)



Static Function ModelDef()

	//Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
	Local _oStruct	:=	FWFormStruct(1,"ZPX")
	Local _oModel

	//Instancia do Objeto de Modelo de Dados
	_oModel	:=	MPFormModel():New('BRI124PE',/*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Cancel*/)

	//Adiciona um modelo de Formulario de Cadastro Similar à Enchoice ou Msmget
	_oModel:AddFields('MODEL_BRI124', /*cOwner*/, _oStruct, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	//Adiciona Descricao do Modelo de Dados
	_oModel:SetDescription( 'Cadastro Empresa - Controle de Portaria' )

	_oModel:SetPrimaryKey({})

	//Adiciona Descricao do Componente do Modelo de Dados
	_oModel:GetModel( 'MODEL_BRI124' ):SetDescription( 'Cadastro Empresa - Controle de Portaria' )

Return(_oModel)



Static Function ViewDef()

	Local _oStruct	:=	FWFormStruct(2,"ZPX") 	//Retorna a Estrutura do Alias passado

	// como Parametro (1=Model,2=View)
	Local _oModel	:=	FwLoadModel('BRI124')	//Retorna o Objeto do Modelo de Dados
	Local oView		:=	FwFormView():New()      //Instancia do Objeto de Visualização

	//Define o Modelo sobre qual a Visualizacao sera utilizada
	oView:SetModel(_oModel)

	//Vincula o Objeto visual de Cadastro com o modelo
	oView:AddField( 'VIEW_BRI124', _oStruct, 'MODEL_BRI124')

	//Define o Preenchimento da Janela
	oView:CreateHorizontalBox( 'ID_100'  , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_BRI124', 'ID_100' )

Return(oView)
