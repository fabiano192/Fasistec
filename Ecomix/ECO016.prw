#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} ECO016
Visao Gerencial - Mapinha     
@since 16/09/20
@version 1.0
/*/

User Function ECO016()

    Local _aArea      := GetArea()
    Local _oBrowse    := FWMBrowse():New()
    Local _cFunBkp    := FunName()

    Private _aZ17Cab  := {'Z17_FILIAL','Z17_CODPLA','Z17_NOME','Z17_ORDEM','Z17_CONTAG','Z17_DESCGE','Z17_CTASUP','Z17_CLASSE'}

    SetFunName("ECO016")

    _oBrowse:SetAlias("Z17")
    _oBrowse:SetDescription('Visao Gerencial - Mapinha')
    // _oBrowse:SetFilterDefault("Z17->Z17_LINHA == '001'")
    _oBrowse:Activate()

    SetFunName(_cFunBkp)
    RestArea(_aArea)

Return(Nil)




Static Function MenuDef()

    Local _aMenu := {}

    //Adicionando opções
    ADD OPTION _aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'        OPERATION 1                      ACCESS 0
    ADD OPTION _aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.ECO016' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION _aMenu TITLE 'Incluir'    ACTION 'VIEWDEF.ECO016' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION _aMenu TITLE 'Alterar'    ACTION 'VIEWDEF.ECO016' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION _aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.ECO016' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5

Return(_aMenu)



Static Function ModelDef()

    Local _oModel   := Nil
    Local _oStTmp   := FWFormModelStruct():New()
    Local _oStFilho := FWFormStruct(1, 'Z17')
    Local _bVldPos  := {|| u_VldZ17Tab()}
    Local _bVldCom  := {|| u_SaveZ17()}
    Local _aZ17Rel  := {}
    Local a

    //Adiciona a tabela na estrutura temporária
    _oStTmp:AddTable('Z17', _aZ17Cab, "Cabecalho Z17")
    // _oStTmp:AddTable('Z17', {'X5_FILIAL', 'X5_CHAVE', 'X5_DESCRI'}, "Cabecalho Z17")

    For a := 1 to Len(_aZ17Cab)

        If _aZ17Cab[a] = 'Z17_FILIAL'
            _bIni := FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,Z17->Z17_FILIAL,FWxFilial('Z17'))" )
            _lObri:= .F.
        Else
            _bIni := FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,Z17->"+_aZ17Cab[a]+",'')")
            _lObri:= .T.
        Endif

        _oStTmp:AddField(;
            FWSX3Util():GetDescription(_aZ17Cab[a]) ,;                                              // [01]  C   Titulo do campo
        FWSX3Util():GetDescription(_aZ17Cab[a]),;                                                   // [02]  C   ToolTip do campo
        _aZ17Cab[a],;                                                                               // [03]  C   Id do Field
        FWSX3Util():GetFieldType( _aZ17Cab[a] ),;                                                   // [04]  C   Tipo do campo
        TamSX3(_aZ17Cab[a])[1],;                                                                    // [05]  N   Tamanho do campo
        TamSX3(_aZ17Cab[a])[2],;                                                                    // [06]  N   Decimal do campo
        Nil,;                                                                                       // [07]  B   Code-block de validação do campo
        Nil,;                                                                                       // [08]  B   Code-block de validação When do campo
        {},;                                                                                        // [09]  A   Lista de valores permitido do campo
        _lObri,;                                                                                    // [10]  L   Indica se o campo tem preenchimento obrigatório
        _bIni,;                                                                                     // [11]  B   Code-block de inicializacao do campo
        .T.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
        .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operação de update.
        .F.)                                                                                        // [14]  L   Indica se o campo é virtual
    Next a

    //Setando as propriedades na grid, o inicializador da Filial e Tabela, para não dar mensagem de coluna vazia
    _oStFilho:SetProperty('Z17_FILIAL', MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))
    _oStFilho:SetProperty('Z17_CODPLA', MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))
    _oStFilho:SetProperty('Z17_ORDEM' , MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))
    _oStFilho:SetProperty('Z17_CONTAG', MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))

    //Criando o FormModel, adicionando o Cabeçalho e Grid
    _oModel := MPFormModel():New("ECO016M", , _bVldPos, _bVldCom)
    _oModel:AddFields("FORMCAB",/*cOwner*/,_oStTmp)
    _oModel:AddGrid('Z17DETAIL','FORMCAB',_oStFilho)

    //Adiciona o relacionamento de Filho, Pai
    aAdd(_aZ17Rel, {'Z17_FILIAL', 'Iif(!INCLUI, Z17->Z17_FILIAL, FWxFilial("Z17"))'} )
    aAdd(_aZ17Rel, {'Z17_CODPLA', 'Iif(!INCLUI, Z17->Z17_CODPLA,  "")'} )
    aAdd(_aZ17Rel, {'Z17_ORDEM' , 'Iif(!INCLUI, Z17->Z17_ORDEM,  "")'} )
    aAdd(_aZ17Rel, {'Z17_CONTAG', 'Iif(!INCLUI, Z17->Z17_CONTAG,  "")'} )

    //Criando o relacionamento
    _oModel:SetRelation('Z17DETAIL', _aZ17Rel, Z17->(IndexKey(1)))

    //Setando o campo único da grid para não ter repetição
    _oModel:GetModel('Z17DETAIL'):SetUniqueLine({'Z17_CODPLA','Z17_ORDEM','Z17_CONTAG','Z17_LINHA'})

    //Setando outras informações do Modelo de Dados
    _oModel:SetDescription("Cadastro Visao Gerencial - Mapinha")
    _oModel:SetPrimaryKey({})
    _oModel:GetModel("FORMCAB"):SetDescription("Cadastro Visao Gerencial - Mapinha")

Return _oModel




Static Function ViewDef()

    Local _oModel     := FWLoadModel("ECO016")
    Local _oStTmp     := FWFormViewStruct():New()
    Local _oStFilho   := FWFormStruct(2, 'Z17')
    Local _oView      := FWFormView():New()
    Local b,c
    Local _nOrdem     := 1

    For b := 2 to Len(_aZ17Cab)

        _nOrdem ++

        _oStTmp:AddField(;
            _aZ17Cab[b],;                           // [01]  C   Nome do Campo
        StrZero(_nOrdem,2),;                        // [02]  C   Ordem
        FWSX3Util():GetDescription(_aZ17Cab[b]),;   // [03]  C   Titulo do campo
        X3Descric(_aZ17Cab[b]),;                    // [04]  C   Descricao do campo
        Nil,;                                       // [05]  A   Array com Help
        FWSX3Util():GetFieldType( _aZ17Cab[b] ),;   // [06]  C   Tipo do campo
        X3Picture(_aZ17Cab[b]),;                    // [07]  C   Picture
        Nil,;                                       // [08]  B   Bloco de PictTre Var
        Nil,;                                       // [09]  C   Consulta F3
        Iif(INCLUI, .T., .F.),;                     // [10]  L   Indica se o campo é alteravel
        Nil,;                                       // [11]  C   Pasta do campo
        Nil,;                                       // [12]  C   Agrupamento do campo
        Nil,;                                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                                       // [15]  C   Inicializador de Browse
        Nil,;                                       // [16]  L   Indica se o campo é virtual
        Nil,;                                       // [17]  C   Picture Variavel
        Nil)                                        // [18]  L   Indica pulo de linha após o campo
    Next b

    _oView:SetModel(_oModel)
    _oView:AddField("VIEW_CAB", _oStTmp, "FORMCAB")
    _oView:AddGrid('VIEW_Z17',_oStFilho,'Z17DETAIL')

    //Setando o dimensionamento de tamanho
    _oView:CreateHorizontalBox('CABEC',30)
    _oView:CreateHorizontalBox('GRID',70)

    //Amarrando a view com as box
    _oView:SetOwnerView('VIEW_CAB','CABEC')
    _oView:SetOwnerView('VIEW_Z17','GRID')

    _oView:AddIncrementField( 'VIEW_Z17', 'Z17_LINHA' )

    //Habilitando título
    _oView:EnableTitleView('VIEW_CAB','Cabeçalho - Visao Gerencial (Mapinha)')
    _oView:EnableTitleView('VIEW_Z17','Itens - Visao Gerencial (Mapinha)')

    //Tratativa padrão para fechar a tela
    _oView:SetCloseOnOk({||.T.})

    //Remove os campos de Filial e Tabela da Grid
    For c := 1 to Len(_aZ17Cab)
        _oStFilho:RemoveField(_aZ17Cab[c])
    Next c

Return(_oView)




User Function VldZ17Tab()

    Local _aArea      := GetArea()
    Local _lRet       := .T.
    Local _oModelDad  := FWModelActive()
    Local _Z17FILIAL    := _oModelDad:GetValue('FORMCAB', 'Z17_FILIAL')
    Local _Z17CODPLA    := _oModelDad:GetValue('FORMCAB', 'Z17_CODPLA')
    Local _Z17ORDEM     := _oModelDad:GetValue('FORMCAB', 'Z17_ORDEM')
    Local _Z17CONTAG    := _oModelDad:GetValue('FORMCAB', 'Z17_CONTAG')
    Local _nOpc       := _oModelDad:GetOperation()

    //Se for Inclusão
    If _nOpc == MODEL_OPERATION_INSERT

        DbSelectArea('Z17')
        Z17->(DbSetOrder(1)) //X5_FILIAL + X5_TABELA + X5_CHAVE

        //Se conseguir posicionar, tabela já existe
        If Z17->(MsSeek(_Z17FILIAL + _Z17CODPLA + _Z17ORDEM + _Z17CONTAG))
            Aviso('Atenção', 'Esse código de Visão já existe!', {'OK'}, 02)
            _lRet := .F.
        EndIf
    EndIf

    RestArea(_aArea)

Return(_lRet)




User Function SaveZ17()

    Local d,e
    Local _aArea      := GetArea()
    Local _lRet       := .T.
    Local _nAtual     := 0
    Local _oModelDad  := FWModelActive()
    Local _oModelGrid := _oModelDad:GetModel( 'Z17DETAIL' )
    Local _nOpc       := _oModelDad:GetOperation()
    Local _aHeadAux   := _oModelGrid:aHeader
    Local _Z17CODPLA  := _oModelDad:GetValue( 'FORMCAB' , 'Z17_CODPLA' )
    Local _Z17CONTAG  := _oModelDad:GetValue( 'FORMCAB' , 'Z17_CONTAG' )
    Local _Z17FILIAL  := _oModelDad:GetValue( 'FORMCAB' , 'Z17_FILIAL' )
    Local _Z17ORDEM   := _oModelDad:GetValue( 'FORMCAB' , 'Z17_ORDEM' )

    DbSelectArea('Z17')
    Z17->(DbSetOrder(1))

    //Se for Inclusão
    If _nOpc == MODEL_OPERATION_INSERT

        //Percorre as linhas da grid
        For _nAtual := 1 To _oModelGrid:Length()

            _oModelGrid:GoLine(_nAtual)

            If !_oModelGrid:IsDeleted()

                Z17->(RecLock('Z17', .T.))
                For d := 1 to Len(_aZ17Cab)
                    &('Z17->'+_aZ17Cab[d]) := _oModelDad:GetValue('FORMCAB', _aZ17Cab[d])
                Next d

                For e := 1 to Len(_aHeadAux)

                    If aScan(_aZ17Cab, Alltrim(_aHeadAux[e][2])) = 0
                        &('Z17->'+Alltrim(_aHeadAux[e][2])) := _oModelGrid:GetValue(Alltrim(_aHeadAux[e][2]))
                    Endif
                Next e

                Z17->(MsUnlock())
            EndIf
        Next

        //Se for Alteração
    ElseIf _nOpc == MODEL_OPERATION_UPDATE

        For _nAtual := 1 To _oModelGrid:Length()

            _oModelGrid:GoLine(_nAtual)

            _cLinha := _oModelGrid:GetValue('Z17_LINHA')

            If _oModelGrid:IsDeleted()
                //Se conseguir posicionar, exclui o registro
                If Z17->(MsSeek(_Z17FILIAL + _Z17CODPLA + _Z17ORDEM + _Z17CONTAG + _cLinha))
                    Z17->(RecLock('Z17', .F.))
                    Z17->(DbDelete())
                    Z17->(MsUnlock())
                EndIf

            Else
                //Se conseguir posicionar no registro, será alteração
                If Z17->(MsSeek(_Z17FILIAL + _Z17CODPLA + _Z17ORDEM + _Z17CONTAG + _cLinha))
                    Z17->(RecLock('Z17', .F.))
                Else
                    Z17->(RecLock('Z17', .T.))
                EndIf

                For d := 1 to Len(_aZ17Cab)
                    &('Z17->'+_aZ17Cab[d]) := _oModelDad:GetValue('FORMCAB', _aZ17Cab[d])
                Next d

                For e := 1 to Len(_aHeadAux)
                    If aScan(_aZ17Cab, Alltrim(_aHeadAux[e][2])) = 0
                        &('Z17->'+Alltrim(_aHeadAux[e][2])) := _oModelGrid:GetValue(Alltrim(_aHeadAux[e][2]))
                    Endif
                Next e

                Z17->(MsUnlock())
            EndIf
        Next

        //Se for Exclusão
    ElseIf _nOpc == MODEL_OPERATION_DELETE

        //Percorre a grid
        For _nAtual := 1 To _oModelGrid:Length()

            _oModelGrid:GoLine(_nAtual)

             _cLinha := _oModelGrid:GetValue('Z17_LINHA')

            //Se conseguir posicionar, exclui o registro
            If Z17->(MsSeek(_Z17FILIAL + _Z17CODPLA + _Z17ORDEM + _Z17CONTAG + _cLinha))
                Z17->(RecLock('Z17', .F.))
                Z17->(DbDelete())
                Z17->(MsUnlock())
            EndIf
        Next
    EndIf

    //Se não for inclusão, volta o INCLUI para .T. (bug ao utilizar a Exclusão, antes da Inclusão)
    If _nOpc != MODEL_OPERATION_INSERT
        INCLUI := .T.
    EndIf

    RestArea(_aArea)

Return _lRet
