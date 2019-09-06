#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} CR0111
//Controle Ferramental
@author Fabiano
@since 16/09/2018
@version 1.0

@type function
/*/
User Function CR0111()

	Private _oBrowse 	:= FwMBrowse():New()

	//Alias do Browse
	_oBrowse:SetAlias('SZL')

	// Definição da legenda
	_oBrowse:AddLegend( "ZL_DIF > 0" , "Green", "Molde em Produção" )
	_oBrowse:AddLegend( "ZL_DIF <= 0", "Red"  , "Molde Bloqueado" )

	//Descrição da Parte Superior Esquerda do Browse
	_oBrowse:SetDescripton("Controle Ferramental")

	//Ativa o Browse
	_oBrowse:Activate()

Return(NIL)



Static Function MenuDef()

	Local _aMenu :=	{}

	ADD OPTION _aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'       	OPERATION 1 ACCESS 0
	ADD OPTION _aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.CR0111'	OPERATION 2 ACCESS 0
	ADD OPTION _aMenu TITLE 'Incluir'    ACTION 'VIEWDEF.CR0111'	OPERATION 3 ACCESS 0
	ADD OPTION _aMenu TITLE 'Alterar'    ACTION 'VIEWDEF.CR0111'	OPERATION 4 ACCESS 0
	ADD OPTION _aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.CR0111'	OPERATION 5 ACCESS 0
	ADD OPTION _aMenu TITLE 'Liberar'    ACTION 'U_CR111LIB()'		OPERATION 6 ACCESS 0

Return(_aMenu)



Static Function ModelDef()

	// Cria as estruturas a serem usadas no Modelo de Dados
	Local _oStruSZL := FWFormStruct( 1, 'SZL' )
	Local _oStruSZM := FWFormStruct( 1, 'SZM' )
	Local _oModel

	// Cria o objeto do Modelo de Dados
	//	_oModel := MPFormModel():New('CR111PE',/*Pre-Validacao*/,/*Pos-Validacao*/ { | _oModel | TudoOk( _oModel ) },/*Commit*/,/*Cancel*/)
	_oModel := MPFormModel():New('CR111PE',/*Pre-Validacao*/,/*Pos-Validacao*/ ,/*Commit*/,/*Cancel*/)

	//	CR111GAT(_oStruSZL,_oStruFZ3,_oStruFZ4)

	// Adiciona a descrição do Modelo de Dados
	_oModel:SetDescription( 'Controle Ferramental' )

	_oModel:AddFields( 'SZLMASTER', /*cOwner*/, _oStruSZL )

	_oModel:SetPrimaryKey({})

	// Adiciona ao modelo uma componente de grid
	_oModel:AddGrid( 'SZMGRID', 'SZLMASTER', _oStruSZM )

	// Faz relacionamento entre os componentes do model
	_oModel:SetRelation( 'SZMGRID', { { 'ZM_FILIAL', 'xFilial( "SZM" )' }, { 'ZM_MOLDE','ZL_MOLDE' } }, SZM->( IndexKey( 1 ) ) )

	// Adiciona a descrição dos Componentes do Modelo de Dados
	_oModel:GetModel( 'SZLMASTER' ):SetDescription( 'Controle Ferramental' )
	_oModel:GetModel( 'SZMGRID' ):SetDescription( 'Histórico' )
	// Retorna o Modelo de dados

	//	_oModel:GetModel( 'FZ4GRID' ):SetNoUpdateLine(.T.)
	_oModel:GetModel( 'SZMGRID' ):SetNoUpdateLine(.T.)
	_oModel:GetModel( 'SZMGRID' ):SetNoInsertLine(.T.)
	_oModel:GetModel( 'SZMGRID' ):SetOptional( .T. )

Return _oModel



Static Function ViewDef()

	// Cria um objeto de Modelo de dados baseado no ModelDef do fonte informado
	Local _oModel 	:= FWLoadModel( 'CR0111' )
	Local _oModelSZL:= _oModel:GetModel( 'SZLMASTER' )

	// Cria as estruturas a serem usadas na View
	Local _oStruSZL := FWFormStruct( 2, 'SZL' )
	Local _oStruSZM := FWFormStruct( 2, 'SZM' )
	Local _nOpc		:= _oModel:GetOperation()

	// Interface de visualização construída
	Local _oView

	_oView := FWFormView():New()

	// Define qual Modelo de dados será utilizado
	_oView:SetModel( _oModel )

	// Adiciona no nosso View um controle do tipo formulário (antiga Enchoice)AdvPl utilizando MVC – 27
	_oView:AddField( 'VIEW_SZL', _oStruSZL, 'SZLMASTER' )

	//Adiciona no nosso View um controle do tipo Grid (antiga Getdados)
	_oView:AddGrid( 'VIEW_SZM', _oStruSZM, 'SZMGRID' )

	// Cria um "box" horizontal para receber cada elemento da view
	_oView:CreateHorizontalBox( 'P01', 40 )
	_oView:CreateHorizontalBox( 'P02', 60 )


	_oView:SetOwnerView( 'VIEW_SZL', 'P01' )
	_oView:SetOwnerView( 'VIEW_SZM', 'P02' )

	_oView:EnableTitleView( 'VIEW_SZL' )
	_oView:EnableTitleView( 'VIEW_SZM', "Histórico" )

	_oStruSZM:RemoveField( 'ZM_MOLDE' )

	_oModel:Activate()

	_oModel:DeActivate()

Return _oView






//Gatilhos
Static Function CR111GAT(_oStruSZL,_oStruFZ3,_oStruFZ4)

	Local _aAux

	//Gatilho para Tipo
	_aAux := FWStruTrigger("FZ1_TIPO"	,"FZ1_OPERAD"	,Space(TamSX3("FZ1_OPERAD")[1]),.F.)
	_oStruSZL:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

	//Gatilho para Tipo
	_aAux := FWStruTrigger("FZ1_TIPO"	,"FZ1_NOME"	,Space(TamSX3("FZ1_NOME")[1]),.F.)
	_oStruSZL:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

	//Gatilho para Tipo
	_aAux := FWStruTrigger("FZ1_TIPO"	,"FZ1_PRODUT"	,Space(TamSX3("FZ1_PRODUT")[1]),.F.)
	_oStruSZL:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

	//Gatilho para Tipo
	_aAux := FWStruTrigger("FZ1_TIPO"	,"FZ1_CICLO"	,'0',.F.)
	_oStruSZL:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

	//Gatilho para Tipo
	_aAux := FWStruTrigger("FZ1_TIPO"	,"FZ1_PRENSA"	,Space(TamSX3("FZ1_PRENSA")[1]),.F.)
	_oStruSZL:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

	//Gatilho para Tipo
	_aAux := FWStruTrigger("FZ1_TIPO"	,"FZ1_CAVIDA"	,'0',.F.)
	_oStruSZL:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])




	//Gatilho para Nome do Prensista
	_aAux := FWStruTrigger("FZ1_OPERAD"	,"FZ1_NOME"	,"SZ6->Z6_NOME"	,.T.,"SZ6",1,'xFilial("SZ6")+M->FZ1_OPERAD', NIL,"01")
	_oStruSZL:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

	//Gatilho para Produto
	_aAux := FWStruTrigger("FZ1_PRODUT"	,"FZ1_PRODUT",'U_GATFZ1("FZ1_PRODUT")'	,.F.)
	_oStruSZL:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

	//Gatilho para Produto
	_aAux := FWStruTrigger("FZ1_PERDA"	,"FZ1_PERDA",'U_GATFZ1("FZ1_PERDA")'	,.F.)
	_oStruSZL:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])



	//Gatilho para Ocorrencia
	_aAux := FWStruTrigger("FZ3_OCORRE"	,"FZ3_DESCOC"	,"SX5->X5_DESCRI"	,.T.,"SX5",1,'xFilial("SX5")+"Z4"+M->FZ3_OCORRE', NIL,"01")
	_oStruFZ3:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

	//Gatilho para Ocorrencia
	_aAux := FWStruTrigger("FZ3_DTINIC"	,"FZ3_TOTAL"	,"U_GATFZ3('FZ3_DTINIC')"	,.F.)
	_oStruFZ3:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])
	//Gatilho para Ocorrencia
	_aAux := FWStruTrigger("FZ3_HRINIC"	,"FZ3_TOTAL"	,"U_GATFZ3('FZ3_HRINIC')"	,.F.)
	_oStruFZ3:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])
	//Gatilho para Ocorrencia
	_aAux := FWStruTrigger("FZ3_DTFINA"	,"FZ3_TOTAL"	,"U_GATFZ3('FZ3_DTFINA')"	,.F.)
	_oStruFZ3:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])
	//Gatilho para Ocorrencia
	_aAux := FWStruTrigger("FZ3_HRFINA"	,"FZ3_TOTAL"	,"U_GATFZ3('FZ3_HRFINA')"	,.F.)
	_oStruFZ3:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

	//Gatilho para Ocorrencia
	_aAux := FWStruTrigger("FZ3_OCORRE"	,"FZ3_DESCOC"	,"SX5->X5_DESCRI"	,.T.,"SX5",1,'xFilial("SX5")+"Z4"+M->FZ3_OCORRE', NIL,"01")
	_oStruFZ3:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])


	//Gatilho para Motivo Perda
	_aAux := FWStruTrigger("FZ4_MOTIVO"	,"FZ4_DESCRI"	,"SX5->X5_DESCRI"	,.T.,"SX5",1,'xFilial("SX5")+"43"+M->FZ4_MOTIVO', NIL,"01")
	_oStruFZ4:AddTrigger(_aAux[1],_aAux[2],_aAux[3],_aAux[4])

Return(Nil)






//Validação TudoOK
Static Function TudoOK(_oMod)

	Local _lRet		:= .T.
	Local _oModelSZL:= _oMod:GetModel( 'SZLMASTER' )
	Local _oModelFZ4:= _oMod:GetModel( 'FZ4GRID' )
	Local _oModelFZ2:= _oMod:GetModel( 'SZMGRID' )
	Local _nRow		:= 0
	Local _nTotPer	:= 0
	Local _nTotAP	:= 0
	Local _nPerda	:= _oMod:GetValue('SZLMASTER',"FZ1_PERDA")
	Local _nProdAP	:= _oMod:GetValue('SZLMASTER',"FZ1_QTDEPR")
	Local _nOpc		:= _oMod:GetOperation()
	Local _aArea	:= GetArea()
	Local _dDtIni	:= _oMod:GetValue('SZLMASTER',"FZ1_DTINIC")
	Local _dDtFim	:= _oMod:GetValue('SZLMASTER',"FZ1_DTFINA")
	Local _nHrIni	:= _oMod:GetValue('SZLMASTER',"FZ1_HRINIC")
	Local _nHrFim	:= _oMod:GetValue('SZLMASTER',"FZ1_HRFINA")
	Local _dEmis	:= _oMod:GetValue('SZLMASTER',"FZ1_EMISSA")
	Local _dDtFech	:= GetMv("MV_ULMES")
	Local _aVetor	:= {}
	Local _cTot		:= ''
	Local _cQry		:= ''
	Local _aCaPerda := {}
	Local _aItPerda := {}
	Local _aLiPerda := {}
	lOCAL _cLocB1	:= ''
	Local _cTM		:= ''


	If _nOpc = 5 //Excluir
		If _dEmis <= _dDtFech
			_lRet := .F.
			ShowHelpDlg("CR0111_9", {'Não é possível a exclusão do Apontamento, pois a data de fechamento de estoque é maior que a data de emissão.'},1,{'Não se aplica.'},1)
		Else

			If Select("TSD3") > 0
				TSD3->(dbCloseArea())
			Endif

			_cQry := " SELECT * FROM "+RetSqlName("SD3")+" D3 (NOLOCK) " + CRLF
			_cQry += " WHERE D3.D_E_L_E_T_ = '' AND D3_FILIAL = '"+xFilial("SD3")+"' AND D3_ESTORNO <> 'S' " +CRLF
			_cQry += " AND D3_YCODAPR = '"+ _oModelSZL:GetValue("FZ1_CODIGO")+"' " +CRLF
			_cQry += " ORDER BY D3_DOC " +CRLF

			TcQuery _cQry New Alias "TSD3"

			TcSetField("TSD3","D3_EMISSAO","D")

			TSD3->(dbGoTop())

			Begin Transaction

				While TSD3->(!EOF())

					lMsErroAuto := .F.

					_aVetor := {;
					{"D3_TM"		, TSD3->D3_TM		, NIL},;
					{"D3_EMISSAO"	, TSD3->D3_EMISSAO	, NIL},;
					{"D3_COD"		, TSD3->D3_COD		, NIL},;
					{"D3_OP"		, TSD3->D3_OP		, NIL},;
					{"D3_QUANT"		, TSD3->D3_QUANT	, NIL},;
					{"D3_PERDA"		, TSD3->D3_PERDA	, NIL},;
					{"D3_PARCTOT"	, TSD3->D3_PARCTOT	, NIL},;
					{"D3_YCODAPR"	, TSD3->D3_YCODAPR	, NIL},;
					{"ATUEMP"		, "T"				, NIL}}

					MSExecAuto({|x, y| mata250(x, y)},_aVetor, _nOpc )

					If lMsErroAuto
						Mostraerro()
						DisarmTransaction()
					Endif

					TSD3->(dbSkip())
				EndDo
			End Transaction

			TSD3->(dbCloseArea())


			If Select("TSBC") > 0
				TSBC->(dbCloseArea())
			Endif

			_cQry := " SELECT * FROM "+RetSqlName("SBC")+" BC (NOLOCK) " + CRLF
			_cQry += " WHERE BC.D_E_L_E_T_ = '' AND BC_FILIAL = '"+xFilial("SBC")+"' " +CRLF
			_cQry += " AND BC_YCODAPR = '"+ _oModelSZL:GetValue("FZ1_CODIGO")+"' " +CRLF
			_cQry += " ORDER BY BC_MOTIVO " +CRLF

			TcQuery _cQry New Alias "TSBC"

			TcSetField("TSBC","BC_DATA","D")

			TSBC->(dbGoTop())

			Begin Transaction

				_aCaPerda := {}
				_aItPerda := {}
				_aLiPerda := {}
				lMsErroAuto := .f.

				While TSBC->(!EOF())

					_aItPerda := {;
					{"BC_QUANT"		,TSBC->BC_QUANT			,NIL},;
					{"BC_QTDDEST"	,TSBC->BC_QTDDEST		,NIL},;
					{"BC_PRODUTO"	,TSBC->BC_PRODUTO		,NIL},;
					{"BC_CODDEST"	,TSBC->BC_CODDEST		,NIL},;
					{"BC_LOCORIG"	,TSBC->BC_LOCORIG		,NIL},;
					{"BC_LOCAL"		,TSBC->BC_LOCAL			,NIL},;
					{"BC_TIPO"		,TSBC->BC_TIPO			,NIL},;
					{"BC_DATA"		,TSBC->BC_DATA			,NIL},;
					{"BC_MOTIVO"	,TSBC->BC_MOTIVO		,NIL},;
					{"BC_RECURSO"	,TSBC->BC_RECURSO		,NIL},;
					{"BC_APONTAD"	,TSBC->BC_APONTAD		,NIL},;
					{"BC_YCODAPR"	,TSBC->BC_YCODAPR		,NIL}}

					AAdd(_aLiPerda ,_aItPerda)

					TSBC->(dbSkip())
				EndDo

				If !Empty(_aLiPerda)
					_aCaPerda := {{"BC_OP"      ,_oModelFZ2:GetValue("FZ2_OP")		,NIL}}

					MsExecAuto ( {|x,y,z| MATA685(x,y,z) }, _aCaPerda, _aLiPerda, 6)

					If lMsErroAuto
						Mostraerro()
						DisarmTransaction()
					Endif
				Endif

			End Transaction

			TSBC->(dbCloseArea())

		Endif
	ElseIf _nOpc == 3 //Inclui
		If _dEmis <= _dDtFech
			_lRet := .F.
			ShowHelpDlg("CR0111_12", {'Não é possível a inclusão do Apontamento, pois a data de fechamento de estoque é maior que a data de emissão.'},1,{'Não se aplica.'},1)
		ElseIf _dDtIni = _dDtFim .And. _nHrFim < _nHrIni
			_lRet := .F.
			ShowHelpDlg("CR0111_7", {'Hora Final menor que a Hora Inicial.'},1,{'Realize o ajuste antes de prosseguir.'},1)
		ElseIf _dDtIni > _dDtFim
			_lRet := .F.
			ShowHelpDlg("CR0111_8", {'Data Final menor que a Data Inicial.'},1,{'Realize o ajuste antes de prosseguir.'},1)
		ElseIf _oModelSZL:GetValue("FZ1_TIPO") = 'P' .And. (Empty(_oModelSZL:GetValue("FZ1_PRENSA")) .Or. Empty(_oModelSZL:GetValue("FZ1_CAVIDA")) .or.;
		Empty(_oModelSZL:GetValue("FZ1_CICLO")))

			_lRet := .F.
			ShowHelpDlg("CR0111_14", {'Preencher os campo "Prensa", "Ciclo" e "Cavidade".'},1,{'Campos Obrigatórios!'},1)

		Else
			For _nRow := 1 To _oModelFZ4:Length()

				_oModelFZ4:GoLine(_nRow)

				If !_oModelFZ4:IsDeleted()
					_nTotPer += _oModelFZ4:GetValue("FZ4_QTDE")
				Endif

			Next _nRow

			If _nTotPer <> _nPerda
				_lRet := .F.
				ShowHelpDlg("CR0111_5", {'Total de intens de Perda é diferente do informado no cabeçalho.'},1,{'Realize o ajuste antes de prosseguir.'},1)
			Endif

			For _nRow := 1 To _oModelFZ2:Length()

				_oModelFZ2:GoLine(_nRow)

				If !_oModelFZ2:IsDeleted()
					_nTotAP += _oModelFZ2:GetValue("FZ2_QTDEAP")
				Endif

			Next _nRow

			If _nTotAP <> (_nPerda+_nProdAP)
				_lRet := .F.
				ShowHelpDlg("CR0111_11", {'Total Produzido + Perda é diferente do total de OP Apontado.'},1,{'Realize o ajuste antes de prosseguir.'},1)
			Endif

			If _lRet

				_cTM := If(_oModelSZL:GetValue("FZ1_TIPO") = "P","300","301")
				Begin Transaction

					For _nRow := 1 To _oModelFZ2:Length()

						_oModelFZ2:GoLine(_nRow)

						If !_oModelFZ2:IsDeleted() .And. _oModelFZ2:GetValue("FZ2_QTDEAP") > 0

							lMsErroAuto := .F.

							_cTot := If(_oModelFZ2:GetValue("FZ2_QTOP") = _oModelFZ2:GetValue("FZ2_QTDEAP"),'T','P')

							_aVetor := {;
							{"D3_TM"		, _cTM								, NIL},;
							{"D3_EMISSAO"	, dDataBase							, NIL},;
							{"D3_COD"		, _oModelSZL:GetValue("FZ1_PRODUT")	, NIL},;
							{"D3_OP"		, _oModelFZ2:GetValue("FZ2_OP")		, NIL},;
							{"D3_QUANT"		, _oModelFZ2:GetValue("FZ2_QTDEAP")	, NIL},;
							{"D3_PERDA"		, 0									, NIL},;
							{"D3_PARCTOT"	, _cTot								, NIL},;
							{"D3_YCODAPR"	, _oModelSZL:GetValue("FZ1_CODIGO")	, NIL},;
							{"ATUEMP"		, "T"								, NIL}}

							MSExecAuto({|x, y| mata250(x, y)},_aVetor, _nOpc )

							If lMsErroAuto
								Mostraerro()
								DisarmTransaction()
							Endif
						Endif

					Next _nRow

					_aCaPerda := {}
					_aItPerda := {}
					_aLiPerda := {}
					lMsErroAuto := .f.

					For _nRow := 1 To _oModelFZ4:Length()

						_oModelFZ4:GoLine(_nRow)

						If !_oModelFZ4:IsDeleted() .And. _oModelFZ4:GetValue("FZ4_QTDE") > 0

							_cLocB1 := Posicione("SB1",1,xFilial("SB1")+_oModelSZL:GetValue("FZ1_PRODUT"),"B1_LOCPAD")

							_aItPerda := {;
							{"BC_QUANT"		,_oModelFZ4:GetValue("FZ4_QTDE")	,NIL},;
							{"BC_QTDDEST"	,_oModelFZ4:GetValue("FZ4_QTDE")	,NIL},;
							{"BC_PRODUTO"	,_oModelSZL:GetValue("FZ1_PRODUT")	,NIL},;
							{"BC_CODDEST"	,_oModelSZL:GetValue("FZ1_PRODUT")	,NIL},;
							{"BC_LOCORIG"	,_cLocB1							,NIL},;
							{"BC_LOCAL"		,"80"								,NIL},;
							{"BC_TIPO"		,"R" 								,NIL},;
							{"BC_DATA"		,dDatabase							,NIL},;
							{"BC_MOTIVO"	,_oModelFZ4:GetValue("FZ4_MOTIVO")	,NIL},;
							{"BC_RECURSO"	,_oModelSZL:GetValue("FZ1_PRENSA")	,NIL},;
							{"BC_APONTAD"	,_oModelSZL:GetValue("FZ1_OPERAD")	,NIL},;
							{"BC_YCODAPR"	,_oModelSZL:GetValue("FZ1_CODIGO")	,NIL}}

							AAdd(_aLiPerda ,_aItPerda)

						Endif

					Next _nRow

					If !Empty(_aLiPerda)
						_aCaPerda := {{"BC_OP"      ,_oModelFZ2:GetValue("FZ2_OP")		,NIL},;
						{"CRECURSO"   ,_oModelSZL:GetValue("FZ1_PRENSA")		,NIL}}

						MsExecAuto ( {|x,y,z| MATA685(x,y,z) }, _aCaPerda, _aLiPerda, 3)

						If lMsErroAuto
							Mostraerro()
							DisarmTransaction()
						Endif
					Endif

				End Transaction

			Endif
		Endif
	Endif

	RestArea(_aArea)
	FwModelActive( _oMod, .T. )

Return(_lRet)





User Function GeraSZM()

	Local _cQry := ""

	Private _aMolde := {}

	_cQry += " SELECT * FROM "+RetSqlName("SD2")+" D2 " +CRLF
	_cQry += " INNER JOIN "+RetSqlName("SB1")+" B1 ON D2_COD = B1_COD " +CRLF
	_cQry += " WHERE D2.D_E_L_E_T_ = '' AND D2_FILIAL = '"+xFilial("SD2")+"' " +CRLF
	_cQry += " AND B1.D_E_L_E_T_ = '' AND B1_FILIAL = '"+xFilial("SB1")+"' " +CRLF
	_cQry += " AND D2_EMISSAO >= '20180701' AND D2_TIPO = 'N' " +CRLF
	_cQry += " AND B1_GRUPO NOT IN ('PACP','PAC') " +CRLF
	_cQry += " ORDER BY D2_COD,D2_DOC,D2_SERIE,D2_ITEM " +CRLF

	TcQuery _cQry New Alias "TSD2"

	TcSetField("TSD2","D2_EMISSAO","D")

	TSD2->(dbGotop())

	While TSD2->(!EOF())

		_aMolde := {}

		nEstru	:= 0
		_aStru	:= Estrut(TSD2->D2_COD,1,.F.,.F.)

		For E:= 1 To Len(_aStru)
			SB1->(dbSetOrder(1))
			If SB1->(msSeek(xFilial("SB1")+_aStru[E,3]))
				If SB1->B1_GRUPO $ "FRVC/FRVI/FRVT/FRFG/FRES/FRPU"   // Molde de Vulcanização / Ferramenta
					If aScan(_aMolde,{|x| x[1] = SB1->B1_COD}) = 0
						AAdd(_aMolde, {SB1->B1_COD,(SB1->B1_CAVMOO - SB1->B1_CAVMOR)})
					Endif
				Endif
			Endif
		Next E

		If Empty(_aMolde)
			TSD2->(dbSkip())
			Loop
		Endif

		_cCod	:= TSD2->D2_COD

		While TSD2->(!EOF()) .And. _cCod == TSD2->D2_COD

			For N:= 1 to Len(_aMolde)

				_nQtPrens := INT(TSD2->D2_QUANT/_aMolde[N][2])

				SZL->(dbSetOrder(1))
				If !SZL->(msSeek(xFilial("SZL")+_aMolde[N][1]))
					SZL->(Reclock("SZL",.T.))
					SZL->ZL_FILIAL	:= xFilial("SZL")
					SZL->ZL_MOLDE	:= _aMolde[N][1]
					SZL->ZL_VDUTIL	:= 3000
					SZL->ZL_QTPRENS	:= _nQtPrens
					SZL->ZL_DIF		:= 3000 - _nQtPrens
					SZL->ZL_DATA	:= cTod("01/07/2018")
					SZL->(MsUnLock())
				Else
					SZL->(Reclock("SZL",.F.))
					SZL->ZL_QTPRENS	+= _nQtPrens
					SZL->ZL_DIF		:= SZL->ZL_VDUTIL - SZL->ZL_QTPRENS
					SZL->(MsUnLock())
				Endif

				SZM->(Reclock("SZM",.T.))
				SZM->ZM_FILIAL	:= xFilial("SZM")
				SZM->ZM_MOLDE	:= _aMolde[N][1]
				SZM->ZM_DATA	:= TSD2->D2_EMISSAO
				SZM->ZM_PRODUTO	:= TSD2->D2_COD
				SZM->ZM_SERIE	:= TSD2->D2_SERIE
				SZM->ZM_DOC		:= TSD2->D2_DOC
				SZM->ZM_ITEMNF	:= TSD2->D2_ITEM
				SZM->ZM_QTNF	:= TSD2->D2_QUANT
				SZM->ZM_QTPRENS	:= _nQtPrens
				SZM->ZM_CAV		:= _aMolde[N][2]
				SZM->ZM_TIPO	:= 'S'
				SZM->ZM_USUARIO	:= 'Administrador'
				SZM->(MsUnLock())

			Next N

			TSD2->(dbSkip())
		EndDo
	EndDo

	TSD2->(dbCloseArea())

Return(Nil)




User Function CR111LIB()

	Local _oDlg		:= Nil
	Local _lAtu		:= .F.

	Local _oButton1	:= Nil
	Local _oButton2	:= Nil
	Local _oGroup1	:= Nil
	Local _oGroup2	:= Nil
	Local _oGroup3	:= Nil
	Local _oGet1	:= Nil
	Local _cGet1	:= SZL->ZL_MOLDE
	Local _oGet2	:= Nil
	Local _nGet2	:= SZL->ZL_VDUTIL
	Local _oGet3	:= Nil
	Local _nGet3	:= SZL->ZL_QTPRENS
	Local _oGet4	:= Nil
	Local _nGet4	:= SZL->ZL_DIF
	Local _oGet5	:= Nil
	Local _dGet5	:= SZL->ZL_DATA
	Local _oGet7	:= Nil
	Local _dGet7	:= dDataBase
	Local _oGet8	:= Nil
	Local _nGet8	:= SZL->ZL_VDUTIL
	Local _oSay1	:= Nil
	Local _oSay2	:= Nil
	Local _oSay3	:= Nil
	Local _oSay4	:= Nil
	Local _oSay5	:= Nil
	Local _oSay6	:= Nil
	Local _oSay7	:= Nil

	If SZL->ZL_DIF < 0

		DEFINE MSDIALOG _oDlg TITLE "Liberar Ferramental" FROM 000, 000  TO 280, 500 PIXEL

		@ 005, 005 GROUP _oGroup1 TO 065, 245 PROMPT "Dados Atuais" OF _oDlg PIXEL
		@ 015, 010 SAY _oSay1 PROMPT "Molde" 		SIZE 030, 007 OF _oDlg PIXEL
		@ 015, 130 SAY _oSay2 PROMPT "Vida Útil"	SIZE 030, 007 OF _oDlg PIXEL
		@ 030, 010 SAY _oSay3 PROMPT "Prensadas"	SIZE 030, 007 OF _oDlg PIXEL
		@ 030, 130 SAY _oSay4 PROMPT "Diferença"	SIZE 030, 007 OF _oDlg PIXEL
		@ 045, 010 SAY _oSay5 PROMPT "Data"			SIZE 030, 007 OF _oDlg PIXEL
		//	@ 074, 124 SAY _oSay6 PROMPT "_oSay6" SIZE 025, 007 OF _oDlg PIXEL

		@ 015, 050 MSGET _oGet1 VAR _cGet1 SIZE 050, 010 Picture ('@!')	When .F.	OF _oDlg PIXEL
		@ 015, 170 MSGET _oGet2 VAR _nGet2 SIZE 050, 010 Picture ('@E 999,999')	When .F.	OF _oDlg PIXEL
		@ 030, 050 MSGET _oGet3 VAR _nGet3 SIZE 050, 010 Picture ('@E 999,999')	When .F.	OF _oDlg PIXEL
		@ 030, 170 MSGET _oGet4 VAR _nGet4 SIZE 050, 010 Picture ('@E 999,999')	When .F.	OF _oDlg PIXEL
		@ 045, 050 MSGET _oGet5 VAR _dGet5 SIZE 050, 010 						When .F.	OF _oDlg PIXEL
		//		@ 073, 153 MSGET _oGet6 VAR _cGet6 SIZE 050, 010 OF _oDlg PIXEL

		@ 068, 005 GROUP _oGroup2 TO 098, 245 PROMPT "Dados Liberação" OF _oDlg PIXEL
		@ 079, 010 SAY _oSay7 PROMPT "Data"								SIZE 030, 007 OF _oDlg PIXEL
		@ 079, 050 MSGET _oGet7 VAR _dGet7								SIZE 050, 010 OF _oDlg PIXEL
		@ 079, 130 SAY _oSay8 PROMPT "Vida Útil"						SIZE 030, 007 OF _oDlg PIXEL
		@ 079, 170 MSGET _oGet8 VAR _nGet8		 Picture ('@E 999,999')	SIZE 050, 010 OF _oDlg PIXEL

		@ 101, 005 GROUP _oGroup3 TO 131, 245 PROMPT "Ações" OF _oDlg PIXEL
		@ 111, 020 BUTTON _oButton1 PROMPT "Cancelar"	Action (_lAtu := .F.,_oDlg:End())	SIZE 040, 012 OF _oDlg PIXEL
		@ 111, 190 BUTTON _oButton2 PROMPT "OK" 		Action (_lAtu := .T.,_oDlg:End())	SIZE 040, 012 OF _oDlg PIXEL

		ACTIVATE MSDIALOG _oDlg CENTERED
	Else
		ShowHelpDlg('CR0111',{'Ferramental não está Bloqueado.'},1,{'Não se aplica.'},1)
	Endif

	If _lAtu
		SZL->(RecLock("SZL",.F.))
		SZL->ZL_DATA	:= _dGet7
		SZL->ZL_VDUTIL	:= _nGet8
		SZL->ZL_QTPRENS	:= 0
		SZL->ZL_DIF		:= _nGet8
		SZL->(Msunlock())

		SZM->(Reclock("SZM",.T.))
		SZM->ZM_FILIAL	:= xFilial("SZM")
		SZM->ZM_MOLDE	:= SZL->ZL_MOLDE
		SZM->ZM_DATA	:= dDataBase
		SZM->ZM_DOC		:= dtos(dDataBase)
		SZM->ZM_TIPO	:= 'L'
		SZM->ZM_USUARIO	:= Capital(UsrFullName(RetCodUsr()))
		SZM->(MsUnLock())
	Endif

Return(Nil)
