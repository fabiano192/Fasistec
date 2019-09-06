#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
Programa	: CR0067
Autor		: Fabiano da Silva
Data		: 16/10/2014
Descri��o	: Romaneio de Expedi��o em MVC
*/

User Function CR0067()

	Local _oBrowse
	
// Instanciamento da Classe de Browse
	_oBrowse := FWMBrowse():New()
	
// Defini��o da tabela do Browse
	_oBrowse:SetAlias('SZJ')

// Defini��o da legenda
//	oBrowse:AddLegend( "ZA0_TIPO=='1'", "YELLOW", "Autor" )
//	oBrowse:AddLegend( "ZA0_TIPO=='2'", "BLUE" , "Interprete" )
	
// Defini��o de filtro
//	oBrowse:SetFilterDefault( "ZA0_TIPO=='1'" )

// Titulo da Browse
	_oBrowse:SetDescription('Romaneio - Expedi��o')
	
// Opcionalmente pode ser desligado a exibi��o dos detalhes
//oBrowse:DisableDetails()

// Ativa��o da Classe
	_oBrowse:Activate()
	
Return NIL


Static Function MenuDef()

Return FWMVCMenu( "CR0067" )


Static Function ModelDef()

// Cria a estrutura a ser usada no Modelo de Dados
	Local _oStruSZJ := FWFormStruct( 1, 'SZJ' )
	Local _oModel // Modelo de dados que ser� constru�do

// Cria o objeto do Modelo de Dados
	_oModel := MPFormModel():New('CR0067' )

// Adiciona ao modelo um componente de formul�rio
	_oModel:AddFields( 'SZJMASTER', /*cOwner*/, _oStruSZJ)

// Adiciona a descri��o do Modelo de Dados
	_oModel:SetDescription( 'Romaneio - Expedi��o' )

// Adiciona a descri��o do Componente do Modelo de Dados
	_oModel:GetModel( 'SZJMASTER' ):SetDescription( 'Romaneio - Expedi��o' )

// Retorna o Modelo de dados
Return _oModel


Static Function ViewDef()

// Cria um objeto de Modelo de dados baseado no ModelDef() do fonte informado
	Local _oModel := FWLoadModel( 'CR0067' )

// Cria a estrutura a ser usada na View
	Local _oStruSZJ := FWFormStruct( 2, 'SZJ' )

// Interface de visualiza��o constru�da
	Local _oView

// Cria o objeto de View
	_oView := FWFormView():New()

// Define qual o Modelo de dados ser� utilizado na View
	_oView:SetModel( _oModel )

// Adiciona no nosso View um controle do tipo formul�rio
// (antiga Enchoice)
	_oView:AddField( 'VIEW_SZJ', _oStruSZJ, 'SZJMASTER' )
// Criar um "box" horizontal para receber algum elemento da view

	_oView:CreateHorizontalBox( 'TELA' , 100 )
// Relaciona o identificador (ID) da View com o "box" para exibi��o

	_oView:SetOwnerView( 'VIEW_SZJ', 'TELA' )
// Retorna o objeto de View criado

Return _oView