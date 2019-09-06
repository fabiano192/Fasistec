#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
Programa	:	CR0084
Autor		:	Fabiano da Silva
Data		:	16/05/2016
Descrição	:	Cadastro de Turno de Trabalho
*/


User Function CR0084()

	Private oBrowse 	:= FwMBrowse():New()				//Variavel de Browse

	//Alias do Browse
	oBrowse:SetAlias('SZA')

	//Descrição da Parte Superior Esquerda do Browse
	oBrowse:SetDescripton("Cadastro de Turno de Trabalho")

	//Adiciona as Legendas no MarkBrowse
//	oBrowse:AddLegend('Empty(Z4_INTEGR)', 'RED'		, 'Não Integrado'     )
//	oBrowse:AddLegend('Z6_TIPO = "1"' , 'ORANGE'	, 'Prensistas'     )
//	oBrowse:AddLegend('Z6_TIPO = "2"' , 'BLUE'		, 'Op. Acabamento'     )

	//Desabilita os Detalhes da parte inferior do Browse
	//oBrowse:DisableDetails()

	//Ativa o Browse
	oBrowse:Activate()

Return



Static Function MenuDef()
  

	Local aMenu :=	{}

	ADD OPTION aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'       	OPERATION 1 ACCESS 0
	ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.CR0084'	OPERATION 2 ACCESS 0
	ADD OPTION aMenu TITLE 'Incluir'    ACTION 'VIEWDEF.CR0084'	OPERATION 3 ACCESS 0
	ADD OPTION aMenu TITLE 'Alterar'    ACTION 'VIEWDEF.CR0084'	OPERATION 4 ACCESS 0
	ADD OPTION aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.CR0084'	OPERATION 5 ACCESS 0
	ADD OPTION aMenu TITLE 'Imprimir'   ACTION 'VIEWDEF.CR0084'	OPERATION 8 ACCESS 0
	ADD OPTION aMenu TITLE 'Copiar'     ACTION 'VIEWDEF.CR0084'	OPERATION 9 ACCESS 0

Return(aMenu)


Static Function ModelDef()

	//Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
	Local oStruct	:=	FWFormStruct(1,"SZA")
	Local oModel

	//Instancia do Objeto de Modelo de Dados
	oModel	:=	MpFormModel():New('CR084PE',/*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Cancel*/)

	//Adiciona um modelo de Formulario de Cadastro Similar à Enchoice ou Msmget
	oModel:AddFields('MODEL_CR0084', /*cOwner*/, oStruct, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	//Adiciona Descricao do Modelo de Dados
	oModel:SetDescription( 'Modelo de Dados do Cadastro de Turno de Trabalho' )

	oModel:SetPrimaryKey({})

	//Adiciona Descricao do Componente do Modelo de Dados
	oModel:GetModel( 'MODEL_CR0084' ):SetDescription( 'Formulario de Cadastro de Turno de Trabalho' )
Return(oModel)



Static Function ViewDef()

	Local oStruct	:=	FWFormStruct(2,"SZA") 	//Retorna a Estrutura do Alias passado

	// como Parametro (1=Model,2=View)
	Local oModel	:=	FwLoadModel('CR0084')	//Retorna o Objeto do Modelo de Dados
	Local oView		:=	FwFormView():New()      //Instancia do Objeto de Visualização

	//Define o Modelo sobre qual a Visualizacao sera utilizada
	oView:SetModel(oModel)

	//Vincula o Objeto visual de Cadastro com o modelo
	oView:AddField( 'VIEW_CR0084', oStruct, 'MODEL_CR0084')

	//Define o Preenchimento da Janela
	oView:CreateHorizontalBox( 'ID_100'  , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_CR0084', 'ID_100' )

	Return(oView)

Return(Nil)