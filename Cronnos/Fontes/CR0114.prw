#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} CR0114
//Ajuste Peso Produto
@author Fabiano
@since 12/11/2018
/*/
User Function CR0114()

	Local _oBrowse

	//	Private _aRotina := MenuDef()

	// Instanciamento da Classe de Browse
	_oBrowse := FWMBrowse():New()

	// Definição da tabela do Browse
	_oBrowse:SetAlias('SB1')

	// Definição de filtro
	//	_oBrowse:SetFilterDefault( "ZA0_TIPO=='1'" )

	// Titulo da Browse
	_oBrowse:SetDescription('Cadastro de Produto')

	// Opcionalmente pode ser desligado a exibição dos detalhes
	_oBrowse:DisableDetails()

	// Ativação da Classe
	_oBrowse:Activate()

Return (Nil)



Static Function MenuDef()

	Local _aRotina := {}

	ADD OPTION _aRotina TITLE 'Peso'    ACTION 'U_CR114PESO()' OPERATION 4 ACCESS 0

Return _aRotina



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
		SB1->(RecLock("SB1",.F.))
		SB1->B1_PESO := _nNewPes
		SB1->(MsUnlock())

		MsgInfo('Peso alterado com sucesso!')
	Endif



Return(Nil)
