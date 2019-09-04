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
	ADD OPTION aMenu TITLE 'Saída'      ACTION 'U_BRI123SAIDA()' OPERATION 4 ACCESS 0
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




User Function BRI123SAIDA()

	Local _oDlg		:= Nil
	Local _nOpt		:= 0
	Local _oGrup	:= Nil
	Local _cObs		:= ''
	Local _nLin		:= 10
	Local _cHist	:= MSMM(ZPY->ZPY_CODHIS,80)//ZPY->ZPY_HISTVI

	Private _dSaida	:= Date()
	Private _cHora	:= StrTran(Left(Time(),5),":","")
	Private _oHora	:= Nil

	If Empty(ZPY->ZPY_DATAS)

		DEFINE MSDIALOG _oDlg FROM 0,0 TO 210,630 TITLE "Saída" OF _oDlg PIXEL

		_oGrup	:= TGroup():New( 005,005,100,310,"",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

		@ _nLin,010 SAY "Confirme abaixo a data e hora da saída:" OF _oGrup PIXEL Size 150,010

		@ _nLin,210 BUTTON "OK" 			SIZE 040,012 ACTION {||_nOpt := 1,_oDlg:END()} OF _oGrup PIXEL
		@ _nLin,260 BUTTON "Sair"			SIZE 040,012 ACTION {||_nOpt := 2,_oDlg:End()} OF _oGrup PIXEL

		_nLin += 15
		@ _nLin,010 SAY "Data Saída: "														Size 50,010 OF _oGrup PIXEL
		@ _nLin,060 MsGet _dSaida		When .T.	Valid ValidData()						Size 70,010 OF _oGrup PIXEL

		_nLin += 15
		@ _nLin,010 SAY "Hora Saída: "														Size 50,010 OF _oGrup PIXEL
		@ _nLin,060 MsGet _oHora VAR _cHora	Picture "@R 99:99" When .T.	 Valid ValidHora()	Size 70,010 OF _oGrup PIXEL

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
				MSMM(ZPY->ZPY_CODHIS ,,,_cHist                         ,1,,,"ZPY","ZPY_CODHIS")
			Endif
			ZPY->(MsUnlock())

			MsgInfo('Saída efetuada com sucesso!')
		Endif
	Else
		ShowHelpDlg("BRI123_4", {'Visita já está encerrada.'},1,{'Não se aplica.'},1)
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
		ShowHelpDlg("BRI123_1", {'Hora Inválida.'},1,{'Digite uma hora válida.'},1)
	Else
		If _nVal <= ZPY->ZPY_ENTRAD .And. _dSaida = ZPY->ZPY_DATAE 
			_lRet := .F.
			ShowHelpDlg("BRI123_2", {'Hora digitada na Saída é menor que a hora de Entrada.'},1,{'Digite uma hora válida.'},1)
		Endif
	EndIf

	_oHora:Refresh()

Return(_lRet)


Static Function ValidData(  )

	Local _lRet		:= .T.

	If _dSaida < ZPY->ZPY_DATAE 
		_lRet := .F.
		ShowHelpDlg("BRI123_3", {'Data digitada na Saída é menor que a data de Entrada.'},1,{'Digite uma data válida.'},1)
	Endif

Return(_lRet)