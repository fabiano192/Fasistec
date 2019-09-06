#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
Programa	: CR0067
Autor		: Fabiano da Silva
Data		: 16/10/2014
Descrição	: Romaneio de Expedição em MVC
*/

User Function CR0067()

	Local _oBrowse
	
// Instanciamento da Classe de Browse
	_oBrowse := FWMBrowse():New()
	
// Definição da tabela do Browse
	_oBrowse:SetAlias('SZJ')

// Definição da legenda
//	oBrowse:AddLegend( "ZA0_TIPO=='1'", "YELLOW", "Autor" )
//	oBrowse:AddLegend( "ZA0_TIPO=='2'", "BLUE" , "Interprete" )
	
// Definição de filtro
//	oBrowse:SetFilterDefault( "ZA0_TIPO=='1'" )

// Titulo da Browse
	_oBrowse:SetDescription('Romaneio - Expedição')
	
// Opcionalmente pode ser desligado a exibição dos detalhes
//oBrowse:DisableDetails()

// Ativação da Classe
	_oBrowse:Activate()
	
Return NIL


Static Function MenuDef()

Return FWMVCMenu( "CR0067" )


Static Function ModelDef()

// Cria a estrutura a ser usada no Modelo de Dados
	Local _oStruSZJ := FWFormStruct( 1, 'SZJ' )
	Local _oModel // Modelo de dados que será construído

// Cria o objeto do Modelo de Dados
	_oModel := MPFormModel():New('CR0067' )

// Adiciona ao modelo um componente de formulário
	_oModel:AddFields( 'SZJMASTER', /*cOwner*/, _oStruSZJ)

// Adiciona a descrição do Modelo de Dados
	_oModel:SetDescription( 'Romaneio - Expedição' )

// Adiciona a descrição do Componente do Modelo de Dados
	_oModel:GetModel( 'SZJMASTER' ):SetDescription( 'Romaneio - Expedição' )

// Retorna o Modelo de dados
Return _oModel


Static Function ViewDef()

// Cria um objeto de Modelo de dados baseado no ModelDef() do fonte informado
	Local _oModel := FWLoadModel( 'CR0067' )

// Cria a estrutura a ser usada na View
	Local _oStruSZJ := FWFormStruct( 2, 'SZJ' )

// Interface de visualização construída
	Local _oView

// Cria o objeto de View
	_oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado na View
	_oView:SetModel( _oModel )

// Adiciona no nosso View um controle do tipo formulário
// (antiga Enchoice)
	_oView:AddField( 'VIEW_SZJ', _oStruSZJ, 'SZJMASTER' )
// Criar um "box" horizontal para receber algum elemento da view

	_oView:CreateHorizontalBox( 'TELA' , 100 )
// Relaciona o identificador (ID) da View com o "box" para exibição

	_oView:SetOwnerView( 'VIEW_SZJ', 'TELA' )
// Retorna o objeto de View criado

Return _oView