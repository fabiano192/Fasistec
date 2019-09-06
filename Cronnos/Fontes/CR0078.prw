#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'TDSBIRT.CH'
#INCLUDE 'BIRTDATASET.CH'

/*
Programa	: CR0078
Autor 		: Fabiano da Silva
Descrição 	: Gerar relatório de Indice de Pontualidade de Entrega dos Fornecedores
*/

USER FUNCTION CR0078()

	Local _oDlg			:= NIL
	Local _nOpt			:= 0
	Local _aInfo 		:= GetUserInfoArray()
	Local nI			:= 0
	Local _cCR0078		:= ''
	Local _nCR0078		:= 0

	For nI := 1 to Len(_aInfo)
		If "CR0078" $ Alltrim(_aInfo[nI][11])
			_cCR0078 += Alltrim(_aInfo[nI][1]) +CRLF
			_nCR0078 ++
		Endif
	Next nI

	If _nCR0078 > 1
		MsgInfo('Rotina já está sendo executada pelos usuários: '+CRLF+;
		_cCR0078+'Processo cancelado!')
		Return()
	Endif

	Private _cTitulo	:= 'Processando'
	Private _cMsgTit	:= 'Aguarde, analisando Dados...'

	PRIVATE cTitulo    	:= "Índice de Pontualidade de Entrega dos Fornecedores"
	PRIVATE _nCont     	:= 0

	AtuSx1()

	DEFINE MSDIALOG _oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF _oDlg PIXEL
	@ 004,010 TO 082,157 LABEL "" OF _oDlg PIXEL

	@ 010,017 SAY "Esta rotina tem por objetivo gerar o relatório  " OF _oDlg PIXEL Size 150,010
	@ 020,017 SAY "de Pontualidade de Entrega de Fornecedores"       OF _oDlg PIXEL Size 150,010
	@ 030,017 SAY "conforme os parâmetros informados pelo usuário. " OF _oDlg PIXEL Size 150,010
	@ 040,017 SAY "                                                " OF _oDlg PIXEL Size 150,010
	@ 060,017 SAY "                                                " OF _oDlg PIXEL Size 150,010
	@ 070,017 SAY "Programa CR0078.PRW                             " OF _oDlg PIXEL Size 150,010

	//	@ 35,167 BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("CR0078"))			OF _oDlg PIXEL
	@ 50,167 BUTTON "OK" 		 SIZE 036,012 ACTION {||_nOpt := 1,_oDlg:END()}		OF _oDlg PIXEL
	@ 65,167 BUTTON "Sair"       SIZE 036,012 ACTION {||_nOpt := 2,_oDlg:End()}		OF _oDlg PIXEL

	ACTIVATE MSDIALOG _oDlg CENTERED

	If _nOpt = 1
		If Pergunte("CR0078",.T.)
			FWMsgRun(, {|_oMsg| CR078A(_oMsg) }, _cTitulo, _cMsgTit )
		Endif
	Endif

Return(Nil)



Static Function CR078A(_oMsg)


	Local _aStru := {}
	Local _cQry1 := ''

	Local _aFields := {}
	Local _aCampos := {}
	Local _oTempTable
	Local _oTmpTRB
	Local _cQuery

	//Criação do objeto
	_oTmpTRB := FWTemporaryTable():New( "CR0078" )

	//Monta os campos da tabela
	AADD(_aCampos,{"FORNECE"	, "C" , TamSX3("C7_FORNECE")[1]	, 0 })
	AADD(_aCampos,{"LOJA"		, "C" , TamSX3("C7_LOJA")[1]	, 0 })
	aadd(_aCampos,{"NOME"		, "C"  ,TamSX3("A2_NOME")[1]	, 0})
	AADD(_aCampos,{"PRODUTO"	, "C" , TamSX3("C7_PRODUTO")[1]	, 0 })
	AADD(_aCampos,{"UM"			, "C" , TamSX3("C7_UM")[1]		, 0 })
	AADD(_aCampos,{"PEDIDO"		, "C" , TamSX3("C7_NUM")[1]		, 0 })
	AADD(_aCampos,{"ITEMPC"		, "C" , TamSX3("C7_ITEM")[1]	, 0 })
	AADD(_aCampos,{"DTENTPC"	, "D" , 08, 0 })
	AADD(_aCampos,{"DTENTNF"	, "D" , 08, 0 })
	AADD(_aCampos,{"DTEMIPC"	, "D" , 08, 0 })
	AADD(_aCampos,{"QTDEPC"		, "N" , 12, 2 })
	AADD(_aCampos,{"QTDENF"		, "N" , 12, 2 })
	AADD(_aCampos,{"NF"			, "C" , 09, 0 })
	AADD(_aCampos,{"SERIE"		, "C" , 03, 0 })
	AADD(_aCampos,{"INDICE"		, "N" , 06, 2 })
	AADD(_aCampos,{"DTENTDE"	, "D" , 08, 0 })
	AADD(_aCampos,{"DTENTAT"	, "D" , 08, 0 })

	_oTmpTRB:SetFields( _aCampos )
	_oTmpTRB:AddIndex("INDICE1", {"FORNECE","LOJA","PRODUTO"} )

	//Criação da tabela
	_oTmpTRB:Create()

	//		_oMsg:cCaption := ('Processando dados de '+MesExtenso(_aDtFech[_nRef]) + '/' + Strzero(Year(_aDtFech[_nRef]),4))
	//		ProcessMessages()

	_cQuery  := " SELECT C7_FORNECE,C7_LOJA,C7_PRODUTO,C7_UM,C7_DATPRF,C7_EMISSAO,C7_NUM,C7_ITEM,C7_QUANT,D1_SERIE,D1_DOC, "
	_cQuery  += " D1_DTDIGIT,D1_QUANT,D1_UM,A2_NREDUZ FROM "+RetSqlName("SC7")+" C7 (NOLOCK) "
	_cQuery  += " LEFT JOIN "+RetSqlName("SD1")+" D1 (NOLOCK) ON D1_PEDIDO+D1_ITEMPC+D1_COD = C7_NUM+C7_ITEM+C7_PRODUTO "
	_cQuery  += " LEFT JOIN "+RetSqlName("SA2")+" A2 (NOLOCK) ON A2_COD+A2_LOJA = C7_FORNECE+C7_LOJA "
	_cQuery  += " WHERE C7.D_E_L_E_T_ = '' AND D1.D_E_L_E_T_ = '' AND A2.D_E_L_E_T_ = '' "
	_cQuery  += " AND C7_FORNECE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	_cQuery  += " AND C7_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	_cQuery  += " AND C7_NUM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	_cQuery  += " AND C7_DATPRF BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
	_cQuery  += " AND A2_PONENTR = '1' "
	_cQuery  += " ORDER BY C7_FORNECE,C7_LOJA,C7_PRODUTO"

	TCQUERY _cQuery NEW ALIAS "ZC7"

	TcSetField("ZC7","C7_DATPRF","D")
	TcSetField("ZC7","C7_EMISSAO","D")
	TcSetField("ZC7","D1_DTDIGIT","D")

	ZC7->(dbGoTop())

	While ZC7->(!EOF())


		CR0078->(RecLock("CR0078",.T.))
		CR0078->FORNECE	:= ZC7->C7_FORNECE
		CR0078->LOJA	:= ZC7->C7_LOJA
		CR0078->NOME	:= ZC7->A2_NREDUZ
		CR0078->PRODUTO	:= ZC7->C7_PRODUTO
		CR0078->UM		:= ZC7->C7_UM
		CR0078->PEDIDO	:= ZC7->C7_NUM
		CR0078->ITEMPC	:= ZC7->C7_ITEM
		CR0078->DTENTPC	:= ZC7->C7_DATPRF
		CR0078->DTENTNF	:= ZC7->D1_DTDIGIT
		CR0078->DTEMIPC	:= ZC7->C7_EMISSAO
		CR0078->QTDEPC	:= ZC7->C7_QUANT
		CR0078->QTDENF	:= ZC7->D1_QUANT
		CR0078->NF		:= ZC7->D1_DOC
		CR0078->SERIE	:= ZC7->D1_SERIE
		CR0078->INDICE	:= MV_PAR09
		CR0078->DTENTDE	:= MV_PAR07
		CR0078->DTENTAT	:= MV_PAR08
		CR0078->(MsUnLock())

		ZC7->(dbSkip())
	EndDo

	ZC7->(dbCloseArea())



	_cUpd := " DROP TABLE CR0078 "
	TCSQLEXEC(_cUpd)

	_cUpd := " SELECT * INTO CR0078 FROM "+ _oTmpTRB:GetRealName()
	TCSQLEXEC(_cUpd)

	//Exclui a tabela
	_oTmpTRB:Delete()

	GeraBirt()

Return (NIL)



Static Function GeraBirt()

	Local _oReport := Nil

	Define User_Report _oReport Name TESTE01 Title "Pontualidade Entrega" //ASKPAR EXCLUSIVE

	Activate REPORT _oReport LAYOUT CR0078 Format HTML

Return(Nil)




Static Function AtuSx1(cPerg)

	Local aHelp := {}
	_cPerg       := "CR0078"

	//         Grupo/Ordem/Pergunta         /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01        /defspa1/defeng1/Cnt01/Var02/Def02  /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3   /cPyme/cGrpSxg/cHelp)
	U_CRIASX1(_cPerg,"01","Fornecedor de  ?",""       ,""      ,"mv_ch1","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR01",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SA2"   )
	U_CRIASX1(_cPerg,"02","Fornecedor ate ?",""       ,""      ,"mv_ch2","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR02",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SA2")
	U_CRIASX1(_cPerg,"03","Produto de     ?",""       ,""      ,"mv_ch3","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR03",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
	U_CRIASX1(_cPerg,"04","Produto ate    ?",""       ,""      ,"mv_ch4","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR04",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
	U_CRIASX1(_cPerg,"05","Ped.Compra de  ?",""       ,""      ,"mv_ch5","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR05",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SC7")
	U_CRIASX1(_cPerg,"06","Ped.Compra ate ?",""       ,""      ,"mv_ch6","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR06",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SC7")
	U_CRIASX1(_cPerg,"07","Entrega Ped.de ?",""       ,""      ,"mv_ch7","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR07",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"08","Entrega Ped.ate?",""       ,""      ,"mv_ch8","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR08",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"09","Indice         ?",""       ,""      ,"mv_ch9","N" ,06     ,2      ,0     ,"G",""        ,"MV_PAR09",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return (Nil)
