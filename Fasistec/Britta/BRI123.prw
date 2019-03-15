#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*{Protheus.doc} BRI123
//Fonte para gravação do controle de Visitantes
@author Fabiano
@since 13/03/2019
@version 1.0
*/

User Function BRI123(_lInclui)

	Default _lInclui	:= .F.

	If !_lInclui
		Private _oBrowse 	:= FwMBrowse():New()				//Variavel de Browse

		_oBrowse:SetAlias('ZPY')

		// Definição da legenda
		_oBrowse:AddLegend( "Empty(ZPY_DATAS)" , "Green", "Entrada sem Saída" )
		_oBrowse:AddLegend( "!Empty(ZPY_DATAS)", "Red"  , "Visita Finalizada" )

		_oBrowse:SetDescripton("Cadastro Visitas")

		_oBrowse:Activate()
	Else

	Endif

Return



Static Function MenuDef()

	Local aMenu :=	{}

	ADD OPTION aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'       	OPERATION 1 ACCESS 0
	ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.BRI123'	OPERATION 2 ACCESS 0
	ADD OPTION aMenu TITLE 'Entrada'    ACTION 'VIEWDEF.BRI123'	OPERATION 3 ACCESS 0
	ADD OPTION aMenu TITLE 'Saída'      ACTION 'U_CR114PESO()' OPERATION 4 ACCESS 0
	ADD OPTION aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.BRI123'	OPERATION 5 ACCESS 0
	ADD OPTION aMenu TITLE 'Imprimir'   ACTION 'VIEWDEF.BRI123'	OPERATION 8 ACCESS 0

Return(aMenu)



Static Function ModelDef()

	//Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
	Local _oStruct	:=	FWFormStruct(1,"ZPY")
	Local _oModel

	//Instancia do Objeto de Modelo de Dados
	_oModel	:=	MPFormModel():New('BRI123PE',/*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Cancel*/)

	//Adiciona um modelo de Formulario de Cadastro Similar à Enchoice ou Msmget
	_oModel:AddFields('MODEL_BRI123', /*cOwner*/, _oStruct, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	//Adiciona Descricao do Modelo de Dados
	_oModel:SetDescription( 'Cadastro Visitas' )

	_oModel:SetPrimaryKey({})

	//Adiciona Descricao do Componente do Modelo de Dados
	_oModel:GetModel( 'MODEL_BRI123' ):SetDescription( 'Cadastro Visitas' )

Return(_oModel)



Static Function ViewDef()

	Local _oStruct	:=	FWFormStruct(2,"ZPY") 	//Retorna a Estrutura do Alias passado

	// como Parametro (1=Model,2=View)
	Local _oModel	:=	FwLoadModel('BRI123')	//Retorna o Objeto do Modelo de Dados
	Local oView		:=	FwFormView():New()      //Instancia do Objeto de Visualização

	//Define o Modelo sobre qual a Visualizacao sera utilizada
	oView:SetModel(_oModel)

	//Vincula o Objeto visual de Cadastro com o modelo
	oView:AddField( 'VIEW_BRI123', _oStruct, 'MODEL_BRI123')

	//Define o Preenchimento da Janela
	oView:CreateHorizontalBox( 'ID_100'  , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_BRI123', 'ID_100' )

Return(oView)




User Function CR114PESO()

	Local _oDlg		:= Nil
	Local _nOpt		:= 0
	Local _oGrup	:= Nil
	Local _cProd	:= SB1->B1_COD
	Local _nPesAt	:= SB1->B1_PESO
	Local _nNewPes	:= 0
	Local _nLin		:= 12

	DEFINE MSDIALOG _oDlg FROM 0,0 TO 220,315 TITLE "Peso Produto" OF _oDlg PIXEL

	_oGrup	:= TGroup():New( 005,005,100,155,"",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ _nLin,010 SAY "Esta rotina ajusta o peso do cadastro de Produto" OF _oGrup PIXEL Size 150,010

	_nLin += 18
	@ _nLin,010 SAY "Produto: "					Size 50,010 OF _oGrup PIXEL
	@ _nLin,060 MsGet _cProd		When .F.	Size 70,010 OF _oGrup PIXEL

	_nLin += 15
	@ _nLin,010 SAY "Peso Atual: "											Size 50,010 OF _oGrup PIXEL
	@ _nLin,060 MsGet _nPesAt		When .F. Picture "@e 999,999,999.9999"	Size 70,010 OF _oGrup PIXEL

	_nLin += 15
	@ _nLin,010 SAY "Novo Peso: "											Size 50,010 OF _oGrup PIXEL
	@ _nLin,060 MsGet _nNewPes		When .T. Picture "@e 999,999.9999"	Size 70,010 OF _oGrup PIXEL

	_nLin += 20
	@ _nLin,015 BUTTON "OK" 			SIZE 036,012 ACTION {||_nOpt := 1,_oDlg:END()} OF _oGrup PIXEL
	@ _nLin,109 BUTTON "Sair"			SIZE 036,012 ACTION {||_nOpt := 2,_oDlg:End()} OF _oGrup PIXEL

	ACTIVATE MSDIALOG _oDlg CENTERED

	If _nOpt = 1
//		SB1->(RecLock("SB1",.F.))
//		SB1->B1_PESO := _nNewPes
//		SB1->(MsUnlock())

		MsgInfo('Peso alterado com sucesso!')
	Endif

Return(Nil)
