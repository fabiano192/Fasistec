#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
Programa	:	BRI129
Autor		:	Fabiano da Silva
Data		:	10/07/19
Descrição	:	Cadastro Veículos - Controle de Portaria
*/
User Function BRI129()

    Private _oBrowse 	:= FwMBrowse():New()				//Variavel de Browse

    _oBrowse:SetAlias('ZPZ')

    _oBrowse:SetDescripton("Cadastro Veículos - Controle de Portaria")

    _oBrowse:Activate()

Return



Static Function MenuDef()

    Local aMenu :=	{}

    ADD OPTION aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'       	OPERATION 1 ACCESS 0
    ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.BRI129'	OPERATION 2 ACCESS 0
    ADD OPTION aMenu TITLE 'Incluir'    ACTION 'VIEWDEF.BRI129'	OPERATION 3 ACCESS 0
    ADD OPTION aMenu TITLE 'Alterar'    ACTION 'VIEWDEF.BRI129'	OPERATION 4 ACCESS 0
    ADD OPTION aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.BRI129'	OPERATION 5 ACCESS 0
    ADD OPTION aMenu TITLE 'Imprimir'   ACTION 'VIEWDEF.BRI129'	OPERATION 8 ACCESS 0
    ADD OPTION aMenu TITLE 'Copiar'     ACTION 'VIEWDEF.BRI129'	OPERATION 9 ACCESS 0

Return(aMenu)



Static Function ModelDef()

    //Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
    Local _oStruct	:=	FWFormStruct(1,"ZPZ")
    Local _oModel

    //Instancia do Objeto de Modelo de Dados
    _oModel	:=	MPFormModel():New('BRI129PE',/*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Cancel*/)

    //Adiciona um modelo de Formulario de Cadastro Similar à Enchoice ou Msmget
    _oModel:AddFields('MODEL_BRI129', /*cOwner*/, _oStruct, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

    //Adiciona Descricao do Modelo de Dados
    _oModel:SetDescription( 'Cadastro Veículos - Controle de Portaria' )

    _oModel:SetPrimaryKey({})

    //Adiciona Descricao do Componente do Modelo de Dados
    _oModel:GetModel( 'MODEL_BRI129' ):SetDescription( 'Cadastro Veículos - Controle de Portaria' )

Return(_oModel)



Static Function ViewDef()

    Local _oStruct	:=	FWFormStruct(2,"ZPZ") 	//Retorna a Estrutura do Alias passado

    // como Parametro (1=Model,2=View)
    Local _oModel	:=	FwLoadModel('BRI129')	//Retorna o Objeto do Modelo de Dados
    Local oView		:=	FwFormView():New()      //Instancia do Objeto de Visualização

    //Define o Modelo sobre qual a Visualizacao sera utilizada
    oView:SetModel(_oModel)

    //Vincula o Objeto visual de Cadastro com o modelo
    oView:AddField( 'VIEW_BRI129', _oStruct, 'MODEL_BRI129')

    //Define o Preenchimento da Janela
    oView:CreateHorizontalBox( 'ID_100'  , 100 )

    // Relaciona o ID da View com o "box" para exibicao
    oView:SetOwnerView( 'VIEW_BRI129', 'ID_100' )

Return(oView)


User Function BRI129PE()

    Local _aParam     := PARAMIXB
    Local _xRet       := .T.
    Local _oObj       := ''
    Local _cIdPonto   := ''
    Local _cIdModel   := ''
    Local _cVeic      := ''

    If UPPER(FunName()) = 'BRI123A'
        If _aParam <> NIL .And. !Empty(M->ZPY_VISITA)

            _oObj       := _aParam[1]
            _cIdPonto   := _aParam[2]
            _cIdModel   := _aParam[3]

            If _cIdPonto == 'MODELCOMMITNTTS'
                ZPW->(dbSetOrder(1))
                If ZPW->(MsSeek(xFilial("ZPW")+M->ZPY_VISITA))

                    _cVeic := ZPW->ZPW_VEICUL

                    If !ZPZ->ZPZ_PLACVE $ _cVeic

                        _cVeic := Alltrim(_cVeic) + Alltrim(ZPZ->ZPZ_PLACVE)+ ' |'

                        ZPW->(RecLock("ZPW",.F.))
                        ZPW->ZPW_VEICUL := _cVeic
                        ZPW->(MsUnLock())
                    Endif
                Endif
            EndIf

        EndIf
    EndIf

Return(_xRet)