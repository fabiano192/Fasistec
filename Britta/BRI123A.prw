#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

#Define Verde "#9AFF9A"
#Define Vermelho "#FF0000"
#Define Salmao "#FF8C69"
#Define Branco "#FFFAFA"
#Define Preto "#000000"
#Define Verde_Escuro "#006400"
#Define Vermelho_Escuro "#8B0000"

/*{Protheus.doc} BRI123A
//Fonte para gravação do controle de Visitantes (Visitas)
@author Fabiano
@since 13/03/2019
@version 2.0
*/

User Function BRI123A(_lInclui)

    Private _bGetVei	:= {|| BRI123AVei(),SetKey( VK_F4,_bGetVei) }

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

    ADD OPTION aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'       		OPERATION 1 ACCESS 0
    ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.BRI123A'	OPERATION 2 ACCESS 0
    ADD OPTION aMenu TITLE 'Entrada'    ACTION 'VIEWDEF.BRI123A'	OPERATION 3 ACCESS 0
    ADD OPTION aMenu TITLE 'Saída'      ACTION 'U_BRI123ASAIDA()' 	OPERATION 4 ACCESS 0
    ADD OPTION aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.BRI123A'	OPERATION 5 ACCESS 0
    ADD OPTION aMenu TITLE 'Imprimir'   ACTION 'VIEWDEF.BRI123A'	OPERATION 8 ACCESS 0

Return(aMenu)



Static Function ModelDef()

    //Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
    Local _oStruct	:=	FWFormStruct(1,"ZPY")
    Local _oModel

    //Instancia do Objeto de Modelo de Dados
    _oModel	:=	MPFormModel():New('BRI123APE',/*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Cancel*/)

    _aAux := FWStruTrigger("ZPY_VISITA"	,"ZPY_VISITA"	,"U_Bri123AGat()"	,.F.)
    _oStruct:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

    _oStruct:SetProperty('ZPY_PLACVE'	,MODEL_FIELD_OBRIGAT ,.T.)
    _oStruct:SetProperty('ZPY_FABRIC'	,MODEL_FIELD_OBRIGAT ,.T.)
    _oStruct:SetProperty('ZPY_MODELO'	,MODEL_FIELD_OBRIGAT ,.T.)
    _oStruct:SetProperty('ZPY_COR'		,MODEL_FIELD_OBRIGAT ,.T.)

    _oStruct:SetProperty('ZPY_PLACVE' 	, MODEL_FIELD_WHEN,{|| .F. })
    _oStruct:SetProperty('ZPY_FABRIC' 	, MODEL_FIELD_WHEN,{|| .F. })
    _oStruct:SetProperty('ZPY_MODELO' 	, MODEL_FIELD_WHEN,{|| .F. })
    _oStruct:SetProperty('ZPY_COR' 		, MODEL_FIELD_WHEN,{|| .F. })

    _bVlCard := FWBuildFeature( STRUCT_FEATURE_VALID, "U_Bri123ACard()" )
    _oStruct:SetProperty('ZPY_CARTAO',MODEL_FIELD_VALID,_bVlCard)

    //Adiciona um modelo de Formulario de Cadastro Similar à Enchoice ou Msmget
    _oModel:AddFields('MODEL_BRI123A', /*cOwner*/, _oStruct, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

    //Adiciona Descricao do Modelo de Dados
    _oModel:SetDescription( 'Cadastro Visitas' )

    _oModel:SetPrimaryKey({})

    //Adiciona Descricao do Componente do Modelo de Dados
    _oModel:GetModel( 'MODEL_BRI123A' ):SetDescription( 'Cadastro Visitas' )

Return(_oModel)



Static Function ViewDef()

    Local _oStruct	:=	FWFormStruct(2,"ZPY") 	//Retorna a Estrutura do Alias passado

    // como Parametro (1=Model,2=View)
    Local _oModel	:=	FwLoadModel('BRI123A')	//Retorna o Objeto do Modelo de Dados
    Local oView		:=	FwFormView():New()      //Instancia do Objeto de Visualização

    //Define o Modelo sobre qual a Visualizacao sera utilizada
    oView:SetModel(_oModel)

    //Vincula o Objeto visual de Cadastro com o modelo
    oView:AddField( 'VIEW_BRI123A', _oStruct, 'MODEL_BRI123A')

    //Define o Preenchimento da Janela
    oView:CreateHorizontalBox( 'ID_100'  , 100 )

    // Relaciona o ID da View com o "box" para exibicao
    oView:SetOwnerView( 'VIEW_BRI123A', 'ID_100' )


    //Criando um botão
    oView:AddUserButton( 'Veículo (F4)', 'LVEIMG32', _bGetVei )

    SetKEY(VK_F4,_bGetVei)

Return(oView)




User Function BRI123ASAIDA()

    Local _oDlg		:= Nil
    Local _nOpt		:= 0
    Local _oGrup	:= Nil
    Local _cObs		:= ''
    Local _nLin		:= 10
    Local _cHist	:= MSMM(ZPY->ZPY_CODHIS,80)//ZPY->ZPY_HISTVI

    Local _cPlaca	:= ZPY->ZPY_PLACVE
    Local _cFabri	:= ZPY->ZPY_FABRIC
    Local _cModel	:= ZPY->ZPY_MODELO
    Local _cCor		:= ZPY->ZPY_COR

    Private _dSaida	:= Date()
    Private _cHora	:= StrTran(Left(Time(),5),":","")
    Private _oHora	:= Nil

    If !Empty(ZPY->ZPY_DATAS)
        ShowHelpDlg("BRI1232_5", {'Registro já está com data de saída.'},1,{'Não se aplica.'},1)
        Return(Nil)
    Endif

    DEFINE MSDIALOG _oDlg FROM 0,0 TO 210,630 TITLE "Saída" OF _oDlg PIXEL

    _oGrup	:= TGroup():New( 005,005,100,310,"",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

    @ _nLin,010 SAY "Confirme abaixo a data e hora da saída:" OF _oGrup PIXEL Size 150,010

    @ _nLin,210 BUTTON "OK" 			SIZE 040,012 ACTION {||_nOpt := 1,_oDlg:END()} OF _oGrup PIXEL
    @ _nLin,260 BUTTON "Sair"			SIZE 040,012 ACTION {||_nOpt := 2,_oDlg:End()} OF _oGrup PIXEL

    _nLin += 20
    @ _nLin,010 SAY "Data Saída: "														Size 50,010 OF _oGrup PIXEL
    @ _nLin,060 MsGet _dSaida		When .T.	Valid ValidData()						Size 50,010 OF _oGrup PIXEL

    @ _nLin,125 SAY "Placa: "															Size 30,010 OF _oGrup PIXEL
    @ _nLin,155 MsGet _cPlaca		When .F.											Size 50,010 OF _oGrup PIXEL

    @ _nLin,220 SAY "Fabricante: "														Size 30,010 OF _oGrup PIXEL
    @ _nLin,250 MsGet _cFabri		When .F.											Size 50,010 OF _oGrup PIXEL

    _nLin += 15
    @ _nLin,010 SAY "Hora Saída: "														Size 50,010 OF _oGrup PIXEL
    @ _nLin,060 MsGet _oHora VAR _cHora	Picture "@R 99:99" When .T.	 Valid ValidHora()	Size 50,010 OF _oGrup PIXEL

    @ _nLin,125 SAY "Modelo: "															Size 30,010 OF _oGrup PIXEL
    @ _nLin,155 MsGet _cModel		When .F.											Size 50,010 OF _oGrup PIXEL

    @ _nLin,220 SAY "Cor: "																Size 30,010 OF _oGrup PIXEL
    @ _nLin,250 MsGet _cCor			When .F.											Size 50,010 OF _oGrup PIXEL

    _nLin += 15
    @ _nLin,010 SAY "Observações: "								Size 50,010 OF _oGrup PIXEL
    _oObs := tMultiget():new( _nLin, 060, {| u | if( pCount() > 0, _cObs := u, _cObs ) }, _oGrup, 240, 35, , , , , , .T. )

    ACTIVATE MSDIALOG _oDlg CENTERED

    If _nOpt = 1
        ZPY->(RecLock("ZPY",.F.))
        ZPY->ZPY_DATAS := _dSaida
        ZPY->ZPY_SAIDA := Val(Left(_cHora,2)+'.'+Right(_cHora,2))
        If !Empty(_cObs)
            If !Empty(_cHist)
                _cHist += CRLF
                _cHist += Replicate('*',100)
                _cHist += CRLF
                _cHist += _cObs
            Else
                _cHist := _cObs
            Endif
            MSMM(ZPY->ZPY_CODHIS ,,,_cHist,1,,,"ZPY","ZPY_CODHIS")
        Endif
        ZPY->(MsUnlock())

        MsgInfo('Saída efetuada com sucesso!')
    Endif

Return(Nil)



Static Function ValidHora(  )

    Local _lRet		:= .T.
    Local _nHoras	:= 0
    Local _nMinutos := 0

    _cHora := PadL(Alltrim(_cHora),4,"0")

    _nVal := Val(Left(_cHora,2)+'.'+Right(_cHora,2))

    _nHoras		:= Val(Left (StrZero(_nVal,5,2),2))
    _nMinutos	:= Val(Right(StrZero(_nVal,5,2),2))

    If _nHoras < 0 .Or. _nHoras > 23 .Or. _nMinutos < 0 .Or. _nMinutos > 59
        _lRet := .F.
        ShowHelpDlg("BRI123A_1", {'Hora Inválida.'},1,{'Digite uma hora válida.'},1)
    Else
        If _nVal <= ZPY->ZPY_ENTRAD .And. _dSaida = ZPY->ZPY_DATAE
            _lRet := .F.
            ShowHelpDlg("BRI123A_2", {'Hora digitada na Saída é menor que a hora de Entrada.'},1,{'Digite uma hora válida.'},1)
        Endif
    EndIf

    _oHora:Refresh()

Return(_lRet)



Static Function ValidData()

    Local _lRet		:= .T.

    If _dSaida < ZPY->ZPY_DATAE
        _lRet := .F.
        ShowHelpDlg("BRI123A_3", {'Data digitada na Saída é menor que a data de Entrada.'},1,{'Digite uma data válida.'},1)
    Endif

Return(_lRet)



User Function Bri123ACard()

    Local _lRet    := .T.
    Local _cCard   := M->ZPY_CARTAO
    Local _AreaZPY := ZPY->(GetArea())
    Local _dSaida  := cTod('')

    If !Empty(_cCard)
        ZPY->(dbSetOrder(4))
        If ZPY->(MsSeek(xFilial("ZPY")+_cCard+dTos(_dSaida)))
            _lRet := .F.
            ShowHelpDlg("BRI123A_4", {'Este cartão já está em uso por '+Alltrim(ZPY->ZPY_NOME)+'.'},1,{'Finalize a saída antes de inciar uma nova entrada.'},1)
        Endif
    Endif

    RestArea(_AreaZPY)

Return(_lRet)



User Function Bri123AGat()

    Local _cRet		:= M->ZPZ_VISITA

    BRI123AVei()

Return(_cRet)



Static Function BRI123AVei()

    Local _nLin		:= 5
    Local _nCol		:= 10
    Local _oFont12	:= TFont():New('Arial',,-12,.F.)
    Local _oSearch	:= Nil
    Local _cSearch	:= Space(10)

    Private _aRadio		:= {'Todos','Vinculados'}
    Private _nRadio		:= 2
    Private _oDlgDet	:= Nil
    Private _oOK		:= LoadBitmap(GetResources(),'LBOK')
    Private _oNO		:= LoadBitmap(GetResources(),'LBNO')
    Private _oVinc		:= LoadBitmap(GetResources(),'PMSRELA')
    Private _oNVin		:= LoadBitmap(GetResources(),'NOCONNECT')
    Private _oBrowCab	:= Nil
    Private _aHeadCab	:= {}
    Private _aColsSiz	:= {}
    Private _aBrowBkp	:= {}
    Private _aBrowCab	:= GetVeiculo()
    Private _nOpx		:= If(Type("nOpx")!= "U",nOpx,10)

    Private _aAuxCab 	:= {;
        {''				,10	,'@!'	,'N',''			,'C'},;
        {''				,20	,'@!'	,'N',''			,'C'},;
        {'Placa'		,50	,'@!'	,'S',Space(6)	,'C'},;
        {'Fabricante'	,100,'@!'	,'N',Space(2)	,'C'},;
        {'Modelo'		,100,'@!'	,'N',Space(100)	,'C'},;
        {'Cor'			,50	,'@!'	,'N',0			,'C'}}

    For _nCab := 1 To Len(_aAuxCab)
        AAdd(_aHeadCab,_aAuxCab[_nCab][1])
        AAdd(_aColsSiz,_aAuxCab[_nCab][2])
    Next _nCab

    DEFINE DIALOG _oDlgDet TITLE OemToAnsi("Visitante X Veículo") FROM 0,0 TO 570,750	OF _oDlgDet PIXEL

    _oSay1 := TSay():New(_nLin+2,_nCol,{||' Placa:'},_oDlgDet,'@!',_oFont12,,,,.T.,CLR_BLACK,CLR_WHITE,30,11,,,,,.T.)

    _nCol	+= 32

    _oSearch	:= TGet():New( _nLin, _nCol,{|u| If(PCount()>0,_cSearch:=u,_cSearch)},_oDlgDet   ,050,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cSearch",,)

    _nCol	+= 52

    _oTBut2	:= TButton():New( _nLin, _nCol, "Pesquisar"	,_oDlgDet,{|| PesqCpo(_cSearch,_oBrowCab:aArray,_oBrowCab)}	, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )

    _nCol	+= 52

    _oRad1	:= TRadMenu():New(_nLin+2,_nCol,_aRadio,{|u| If(PCount() > 0, _nRadio := u, _nRadio) },_oDlgDet,,{|| ChangeRadio(_nRadio,_oBrowCab)},,,"",,,70,10,,,,.T.,.T.)

    _nCol	+= 80

    _oTBut2	:= TButton():New( _nLin, _nCol, "Incluir Veiculo"	,_oDlgDet,{|| IncVei()}	, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )

    _nLin += 15
    _nCol := 10
    _oGrDet1  := TGroup():New( _nLin,_nCol,_nLin+220,_nCol+355,"",_oDlgDet,CLR_HRED,CLR_WHITE,.T.,.F. )

    _oBrowCab := TwBrowse():New( _nLin+5, _nCol+5,_nCol+330,_nLin+190,, _aHeadCab ,_aColsSiz,_oGrDet1,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

    If _nRadio = 2

        _aBrw := {}

        For f := 1 to Len(_aBrowCab)
            If _aBrowCab[f][1]
                AAdd(_aBrw,_aBrowCab[f])
                _aBrw[Len(_aBrw)][1] := .F.
            Endif
        Next f

        If Empty(_aBrw)
            _aBrw :=  {{.F.,.F.,'','','',''}}
        Endif

        _oBrowCab:SetArray(_aBrw)
        SetArray()
    Else

        _oBrowCab:SetArray(_aBrowCab)

        SetArray()
    Endif


    _nLin += 230

    _oBrowCab:bLDblClick := {|| Check() }

    //		_oTBut1	:= TButton():New( _nLin, 70, "Confirmar" ,_oDlgDet,{||UpdVeic(),_oDlgDet:End()}	, 40,25,,,.F.,.T.,.F.,,.F.,,,.F. )
    _oTBut1	:= TButton():New( _nLin, 70, "Confirmar" ,_oDlgDet,{||UpdFields(),_oDlgDet:End()}	, 40,25,,,.F.,.T.,.F.,,.F.,,,.F. )
    _oTBut1 :cTooltip = "Consultar"
    _cStyle := GetStyle(Branco,Verde,Verde_Escuro,Preto)
    _oTBut1:SetCss(_cStyle)

    ACTIVATE MSDIALOG _oDlgDet CENTERED

Return(Nil)



Static Function UpdFields()

    Local _oModelAct	:= FWModelActive()
    Local _oViewAct		:= FWViewActive()

    For f := 1 to Len(_oBrowCab:aArray)
        If _oBrowCab:aArray[f][1]
            _oModelAct:LoadValue('MODEL_BRI123A','ZPY_PLACVE'		, _oBrowCab:aArray[f][3] )
            _oModelAct:LoadValue('MODEL_BRI123A','ZPY_FABRIC'		, _oBrowCab:aArray[f][4] )
            _oModelAct:LoadValue('MODEL_BRI123A','ZPY_MODELO'		, _oBrowCab:aArray[f][5] )
            _oModelAct:LoadValue('MODEL_BRI123A','ZPY_COR'			, Left(_oBrowCab:aArray[f][6],2))
        Endif
    Next f

    _oViewAct:Refresh()

Return(Nil)



Static Function Check()

    Local _nLine := _oBrowCab:nAt

    _oBrowCab:aArray[_nLine][1] := !_oBrowCab:aArray[_nLine][1]

    For f := 1 to Len(_oBrowCab:aArray)
        If f <> _nLine
            _oBrowCab:aArray[f][1] := .F.
        Endif
    Next f

    _oBrowCab:Refresh()

Return()



Static Function GetStyle(_cCor1,_cCor2,_cCor3,_cCor4)

    Local _cMod := ''

    _cMod := "QPushButton { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+_cCor1+", stop: 1 "+_cCor2+");"
    _cMod += "border-style: outset;border-width: 2px;
        _cMod += "border-radius: 10px;border-color: "+_cCor3+";"
    _cMod += "color: "+_cCor4+"};"
    _cMod += "QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+_cCor2+", stop: 1 "+_cCor1+");"
    _cMod += "border-style: outset;border-width: 2px;"
    _cMod += "border-radius: 10px;"
    _cMod += "border-color: "+_cCor3+" }"

Return(_cMod)



Static Function GetVeiculo()

    Local _aRet		:= {}
    Local _aMemoVei	:= ''
    Local _aCor		:= {}
    Local _cCorVei	:= ''
    Local _nPos		:= 0
    Local _lOk		:= .F.

    ZPW->(dbSetOrder(1))
    If ZPW->(MsSeek(xFilial("ZPW")+M->ZPY_VISITA))
        _aMemoVei := StrTokArr(ZPW->ZPW_VEICUL, "|")
    Endif

    _aBrowBkp		:= {}

    SX3->(dbSetOrder(2))
    If SX3->(msSeek( "ZPZ_COR"))
        _aCor := StrTokArr(X3Cbox(), ";")
    Endif

    ZPZ->(dbSetOrder(1))
    ZPZ->(dbGoTop())

    While ZPZ->(!EOF())

        IF ZPZ->ZPZ_MSBLQL <> '1'

            _nPos := aScan(_aCor,{|x| Left(x,2) = ZPZ->ZPZ_COR})

            If _nPos > 0
                _cCorVei := _aCor[_nPos]
            Endif

            If Alltrim(ZPZ->ZPZ_PLACVE) $ ZPW->ZPW_VEICUL
                _lOk := .T.
            Else
                _lOk := .F.
            Endif

            _lMarc := .T.

            AAdd(_aRet,{;
                _lOk			,;
                _lOk			,;
                ZPZ->ZPZ_PLACVE	,;
                ZPZ->ZPZ_FABRIC	,;
                ZPZ->ZPZ_MODELO	,;
                _cCorVei		})

            AAdd(_aBrowBkp,{;
                .F.			,;
                _lOk			,;
                ZPZ->ZPZ_PLACVE	,;
                ZPZ->ZPZ_FABRIC	,;
                ZPZ->ZPZ_MODELO	,;
                _cCorVei		})

        Endif

        ZPZ->(dbSkip())
    EndDo

    If Empty(_aRet)
        _aRet 		:= {{.F.,.F.,'','','',''}}
        _aBrowBkp 	:= {{.F.,.F.,'','','',''}}
    Endif

Return(_aRet)



//Pesquisar o campo informado
Static Function PesqCpo(_cString,_aVet,_oObj)

    _nPos	 := aScan(_aVet,{|x| Upper(_cString) = Upper(x[3])})

    If _nPos > 0
        _oObj:nAt := _nPos
        _oObj:Refresh()
    EndIf

    _oDlgDet:Refresh()

Return()



Static Function ChangeRadio(_nRadio,_oBrowCab)

    Local _aBrw := {}

    If _nRadio = 1
        For f := 1 to Len(_aBrowBkp)
            AAdd(_aBrw,_aBrowBkp[f])
            _aBrw[Len(_aBrw)][1] := .F.
        Next f
    Else

        For f := 1 to Len(_oBrowCab:aArray)
            If _oBrowCab:aArray[f][2]
                AAdd(_aBrw,_oBrowCab:aArray[f])
                _aBrw[Len(_aBrw)][1] := .F.
            Endif
        Next f

    Endif

    If Empty(_aBrw)
        _aBrw :=  {{.F.,.F.,'','','',''}}
    Endif

    _oBrowCab:SetArray(_aBrw)

    SetArray()

Return(Nil)



Static Function SetArray()

    _oBrowCab:bLine := {||{;
        If(_oBrowCab:aArray[_oBrowCab:nAt,1],_oOk,_oNo ),; //1 - Marcador
        If(_oBrowCab:aArray[_oBrowCab:nAt,2],_oVinc,_oNVin ),; //1 - Marcador
            _oBrowCab:aArray[_oBrowCab:nAt,3],; //
            _oBrowCab:aArray[_oBrowCab:nAt,4],; //
            _oBrowCab:aArray[_oBrowCab:nAt,5],; //
            _oBrowCab:aArray[_oBrowCab:nAt,6]}}

            _oBrowCab:nAt := 1
            _oBrowCab:Refresh()

            _oDlgDet:Refresh()

            Return(Nil)


Static Function IncVei()

    Local _aButtons	:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}
    Local _nExec	:= FWExecView('Inclusao por FWExecView','BRI129', MODEL_OPERATION_INSERT, , { || .T. }, , ,_aButtons )

    If _nExec = 0
        ZPW->(dbSetOrder(1))
        If ZPW->(MsSeek(xFilial("ZPW")+ZPY->ZPY_VISITA))

            _cVeic := ZPW->ZPW_VEICUL

            If !ZPY->ZPY_PLACVE $ _cVeic

                _cVeic := Alltrim(_cVeic) + Alltrim(ZPY->ZPY_PLACVE)+ ' |'

                ZPW->(RecLock("ZPW",.F.))
                ZPW->ZPW_VEICUL := _cVeic
                ZPW->(MsUnLock())
            Endif
        Endif

        LjMsgRun( "Atualizando veículos, aguarde...", "Visitantes X Veículos", {||  GetVeiculo()})

        If _nRadio = 1
            ChangeRadio(2,_oBrowCab)
            ChangeRadio(1,_oBrowCab)
        else
            ChangeRadio(1,_oBrowCab)
            ChangeRadio(2,_oBrowCab)
        Endif

        _oBrowCab:Refresh()
        _oDlgDet:Refresh()

    Endif

Return(Nil)



User Function BRI123APE()

    Local _aParam     := PARAMIXB
    Local _xRet       := .T.
    Local _oObj       := ''
    Local _cIdPonto   := ''
    Local _cIdModel   := ''
    Local _cVeic      := ''

    If _aParam <> NIL

        _oObj       := _aParam[1]
        _cIdPonto   := _aParam[2]
        _cIdModel   := _aParam[3]

        If _cIdPonto == 'MODELCOMMITNTTS'
            ZPW->(dbSetOrder(1))
            If ZPW->(MsSeek(xFilial("ZPW")+ZPY->ZPY_VISITA))

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

Return(_xRet)