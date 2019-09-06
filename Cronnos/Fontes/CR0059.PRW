#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'

/*
Programa	:	CR0059
Autor		:	Fabiano da Silva
Data		:	02/06/14
Descrição	:	Pedidos de Compras
*/

User Function CR0059()

	Local oDlg              // Nome do objeto referente a Dialog

	ATUSX1()

	_nOpc := 0

	DEFINE MSDIALOG oDlg  FROM 0,0 TO 160,380 TITLE "Pedido Compras Excel" OF oDlg PIXEL

	@ 02,10 TO 050,180 OF oDlg PIXEL

	@ 10,18 SAY "Relatório de Pedidos de Compras (Linha)			" 					OF oDlg PIXEL
	@ 26,18 SAY "                                                   " OF oDlg PIXEL
	@ 34,18 SAY "Programa CR0059.PRW                                " OF oDlg PIXEL

	DEFINE SBUTTON FROM 055,030 TYPE 5 ACTION Pergunte("CR0059") 	ENABLE Of oDlg
	DEFINE SBUTTON FROM 055,080 TYPE 1 ACTION (_nOpc:=1,oDlg:END()) ENABLE Of oDlg
	DEFINE SBUTTON FROM 055,130 TYPE 2 ACTION oDlg:End() 			ENABLE Of oDlg

	ACTIVATE MSDIALOG oDlg CENTERED

	If _nOpc == 1

		Private _lFim      := .F.
		Private _cMsg01    := ''
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| CR059_A(@_lFim) }
		Private _cTitulo01 := 'Gerando Relatório!!!!'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

	Endif

Return


Static Function CR059_A()

	Local oFwMsEx 		:= NIL
	Local cArq 			:= ""
	Local cDir 			:= GetSrvProfString("Startpath","")
	Local cWorkSheet	:= ""
	Local cTable1 		:= ""
	Local cTable2 		:= ""
	Local cDirTmp 		:= GetTempPath()
	Local _cDir			:= "C:\TOTVS\"

	Pergunte('CR0059',.F.)

	If MV_PAR07 = 1 //Analitico

		_cQuery := " SELECT C7_NUM, C7_NUMSC, C7_FORNECE,C7_LOJA,A2_NREDUZ,A2_TEL,C7_ITEM,C7_PRODUTO,C7_DESCRI,B1_GRUPO,C7_EMISSAO,C7_FILENT,C7_DATPRF, "
		_cQuery += " C7_QUANT,C7_UM,C7_PRECO,C7_TOTAL,C7_VLDESC,C7_VALIPI,C7_QUJE, C7_RESIDUO "
		_cQuery += " FROM "+RetSqlName("SC7")+" C7 "
		_cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD = C7_PRODUTO "
		_cQuery += " INNER JOIN "+RetSqlName("SA2")+" A2 ON A2_COD+A2_LOJA = C7_FORNECE+C7_LOJA "
		_cQuery += " WHERE C7.D_E_L_E_T_ = '' AND A2.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' "
		_cQuery += " AND C7_PRODUTO BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' "
		_cQuery += " AND C7_EMISSAO BETWEEN '"+dTos(MV_PAR01)+"' AND '"+dTos(MV_PAR02)+"' "
		_cQuery += " AND C7_DATPRF BETWEEN  '"+dTos(MV_PAR03)+"' AND '"+dTos(MV_PAR04)+"' "
		_cQuery += " AND B1_TIPO BETWEEN  '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
		_cQuery += " AND B1_GRUPO BETWEEN  '"+MV_PAR10+"' AND '"+MV_PAR11+"' "
		_cQuery += " AND C7_QUANT > C7_QUJE "
		_cQuery += " AND C7_RESIDUO <> 'S' "
		_cQuery += " ORDER BY C7_NUM,C7_ITEM "

		TCQUERY _cQuery NEW ALIAS "TSC7"

		TCSETFIELD("TSC7","C7_EMISSAO","D")
		TCSETFIELD("TSC7","C7_DATPRF","D")

		COUNT TO nRec

		If nRec > 0

			cWorkSheet  := "PC_Cronnos"
			cTable      := "PC_Cronnos"

			oFwMsEx := FWMsExcel():New()

			oFwMsEx:AddWorkSheet( cWorkSheet )

			oFwMsEx:AddTable( cWorkSheet, cTable )

			oFwMsEx:AddColumn( cWorkSheet, cTable , "Num.PC" 		, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Numero da SC"  , 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Fornecedor"  	, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Loja"  		, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Razao Social"  , 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Telefone"  	, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Item"  		, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto"  		, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Descricao"  	, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Grupo"  		, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Emissão"  		, 1,4,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Lj"  			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Entrega"  		, 1,4,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Quantidade"  	, 3,2,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "UM"			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Prc Unitario"	, 3,2,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Vl. Desconto"	, 3,2,.T.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Vlr.IPI"		, 3,2,.T.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Vlr.Total"		, 3,2,.T.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Qtd.Entregue"	, 3,2,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Quant.Receber"	, 3,2,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Saldo Receber"	, 3,2,.T.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Res. Elim."	, 1,1,.F.)

			dbSelectArea("TSC7")

			TSC7->(dbGotop())

			TSC7->(ProcRegua(0))

			While TSC7->(!Eof())

				TSC7->(IncProc())

				_nSaldo := TSC7->C7_QUANT - TSC7->C7_QUJE

				oFwMsEx:AddRow( cWorkSheet, cTable,{;
				TSC7->C7_NUM				,;
				TSC7->C7_NUMSC 				,;
				TSC7->C7_FORNECE   			,;
				TSC7->C7_LOJA   			,;
				TSC7->A2_NREDUZ   			,;
				TSC7->A2_TEL   				,;
				TSC7->C7_ITEM   			,;
				TSC7->C7_PRODUTO   			,;
				TSC7->C7_DESCRI   			,;
				TSC7->B1_GRUPO   			,;
				TSC7->C7_EMISSAO   			,;
				TSC7->C7_FILENT   			,;
				TSC7->C7_DATPRF   			,;
				TSC7->C7_QUANT   			,;
				TSC7->C7_UM   				,;
				TSC7->C7_PRECO   			,;
				TSC7->C7_VLDESC   			,;
				TSC7->C7_VALIPI   			,;
				TSC7->C7_TOTAL   			,;
				TSC7->C7_QUJE   			,;
				_nSaldo   					,;
				_nSaldo * TSC7->C7_PRECO   	,;
				TSC7->C7_RESIDUO   	})

				TSC7->(dbSkip())
			EndDo

			TSC7->(dbCloseArea())

		Else
			MsgAlert('Não existem dados para serem impressos!')
		Endif
	Else //Sintetico

		_cQrySB1 := " SELECT B1_COD,B1_UM,B1_TIPO,B1_GRUPO,SUM(B2_QATU) AS ESTOQUE FROM "+RetSqlName("SB1")+" B1 "
		_cQrySB1 += " INNER JOIN "+RetSqlName("SB2")+" B2 ON B2_FILIAL+B2_COD+B2_LOCAL = B1_FILIAL+B1_COD+B1_LOCPAD"
		_cQrySB1 += " WHERE B1.D_E_L_E_T_ = '' AND B2.D_E_L_E_T_ = '' AND B1_FILIAL = '"+xFilial("SB1")+"' "
		_cQrySB1 += " AND B1_COD BETWEEN  '"+MV_PAR08+"' AND '"+MV_PAR09+"' "
		_cQrySB1 += " AND B1_TIPO BETWEEN  '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
		_cQrySB1 += " AND B1_GRUPO BETWEEN  '"+MV_PAR10+"' AND '"+MV_PAR11+"' "
		_cQrySB1 += " GROUP BY B1_COD,B1_UM,B1_TIPO,B1_GRUPO"
		_cQrySB1 += " ORDER BY B1_COD "

		TCQUERY _cQrySB1 NEW ALIAS "TSB1"

		COUNT TO nRec

		If nRec > 0

			_cQuery := " SELECT SUM(C7_QUANT) AS QUANT,SUM(C7_QUJE) AS ENTREGUE,C7_PRODUTO,C7_UM "
			_cQuery += " FROM "+RetSqlName("SC7")+" C7 "
			_cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD = C7_PRODUTO "
			_cQuery += " WHERE C7.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' "
			_cQuery += " AND C7_PRODUTO BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' "
			_cQuery += " AND C7_EMISSAO BETWEEN '"+dTos(MV_PAR01)+"' AND '"+dTos(MV_PAR02)+"' "
			_cQuery += " AND C7_DATPRF BETWEEN  '"+dTos(MV_PAR03)+"' AND '"+dTos(MV_PAR04)+"' "
			_cQuery += " AND B1_TIPO BETWEEN  '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
			_cQuery += " AND B1_GRUPO BETWEEN  '"+MV_PAR10+"' AND '"+MV_PAR11+"' "
			_cQuery += " AND C7_QUANT > C7_QUJE "
			_cQuery += " AND C7_RESIDUO <> 'S' "
			_cQuery += " GROUP BY C7_PRODUTO,C7_UM "

			TCQUERY _cQuery NEW ALIAS "TSC7"

			dbSelectArea("TSC7")

			_cArq1 := CriaTrab(NIL,.F.)
			Copy To &_cArq1

			dbCloseArea()

			dbUseArea(.T.,,_cArq1,"TSC7",.T.)
			_cInd1 := "C7_PRODUTO"

			IndRegua("TSC7",_cArq1,_cInd1,,,"Selecionando Arquivo Trabalho")

			_cQuery := " SELECT SUM(C1_QUANT) AS QUANT,SUM(C1_QUJE) AS ENTREGUE,C1_PRODUTO,C1_UM "
			_cQuery += " FROM "+RetSqlName("SC1")+" C1 "
			_cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD = C1_PRODUTO "
			_cQuery += " WHERE C1.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' "
			_cQuery += " AND C1_PRODUTO BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' "
			_cQuery += " AND C1_EMISSAO BETWEEN '"+dTos(MV_PAR01)+"' AND '"+dTos(MV_PAR02)+"' "
			_cQuery += " AND C1_DATPRF BETWEEN  '"+dTos(MV_PAR03)+"' AND '"+dTos(MV_PAR04)+"' "
			_cQuery += " AND B1_TIPO BETWEEN  '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
			_cQuery += " AND B1_GRUPO BETWEEN  '"+MV_PAR10+"' AND '"+MV_PAR11+"' "
			_cQuery += " AND C1_QUANT > C1_QUJE "
			_cQuery += " AND C1_RESIDUO <> 'S' "
			_cQuery += " GROUP BY C1_PRODUTO,C1_UM "
			_cQuery += " ORDER BY C1_PRODUTO "

			TCQUERY _cQuery NEW ALIAS "TSC1"

			dbSelectArea("TSC1")

			_cArq2 := CriaTrab(NIL,.F.)
			Copy To &_cArq2

			dbCloseArea()

			dbUseArea(.T.,,_cArq2,"TSC1",.T.)
			_cInd2 := "C1_PRODUTO"

			IndRegua("TSC1",_cArq2,_cInd2,,,"Selecionando Arquivo Trabalho")

			cWorkSheet  := "Cronnos"
			cTable      := "Cronnos"

			oFwMsEx := FWMsExcel():New()

			oFwMsEx:AddWorkSheet( cWorkSheet )

			oFwMsEx:AddTable( cWorkSheet, cTable )

			oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto"  			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "UM"				, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Tipo"				, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Grupo"				, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Qtde SC Original"	, 3,2,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Qtde SC Entregue"	, 3,2,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Saldo SC"			, 3,2,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Qtde PC Original"	, 3,2,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Qtde PC Entregue"	, 3,2,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Saldo PC"			, 3,2,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Estoque Atual"		, 3,2,.F.)

			TSB1->(dbGoTop())
			TSB1->(ProcRegua(0))

			While !TSB1->(eof())

				TSB1->(IncProc())

				_nQtdeSC 	:= _nEntrSC := _nSldSC := 0
				_nQtdePC 	:= _nEntrPC := _nSldPC := 0
				_lSC		:= _lPC		:= .F.

				If TSC1->(msSeek(TSB1->B1_COD))
					_nQtdeSC 	:= TSC1->QUANT
					_nEntrSC 	:= TSC1->ENTREGUE
					_nSldSC 	:= TSC1->QUANT - TSC1->ENTREGUE
					_lSC		:= .T.
				Endif

				If TSC7->(msSeek(TSB1->B1_COD))
					_nQtdePC 	:= TSC7->QUANT
					_nEntrPC 	:= TSC7->ENTREGUE
					_nSldPC 	:= TSC7->QUANT - TSC7->ENTREGUE
					_lPC		:= .T.
				Endif

				If _lSC .Or. _lPC .Or. TSB1->ESTOQUE > 0

					oFwMsEx:AddRow( cWorkSheet, cTable,{;
					TSB1->B1_COD   				,;
					TSB1->B1_UM   				,;
					TSB1->B1_TIPO  				,;
					TSB1->B1_GRUPO 				,;
					_nQtdeSC					,;
					_nEntrSC					,;
					_nSldSC						,;
					_nQtdePC					,;
					_nEntrPC					,;
					_nSldPC						,;
					TSB1->ESTOQUE				})

				Endif

				TSB1->(dbSkip())
			EndDo

			TSC7->(dbCloseArea())
			TSC1->(dbCloseArea())
		Else
			MsgAlert('Não existem dados para serem impressos!')
		Endif
	Endif

	oFwMsEx:Activate()

	cArq := CriaTrab( NIL, .F. ) + ".xls"

	LjMsgRun( "Gerando o arquivo, aguarde...", "Vendas com Custo", {|| oFwMsEx:GetXMLFile( cArq ) } )

	If !ExistDir( _cDir )
		If MakeDir( _cDir ) <> 0
			MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
			Return
		EndIf
	EndIf

	_cNomArq := "Pedido_Compras_CRONNOS.XLS"

	If __CopyFile(cArq, _cDir + _cNomArq)

		FErase(cArq)

		If ! ApOleClient( 'MsExcel' )
			MsgStop('MsExcel nao instalado')
			Return
		EndIf

		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( _cDir + _cNomArq )
		oExcelApp:SetVisible(.T.)

	Else
		MSGAlert("O arquivo não foi copiado!", "AQUIVO NÃO COPIADO!")
	Endif

Return


Static Function AtuSX1()

	cPerg := "CR0059"

	//    	      Grupo/Ordem/Pergunta    				/perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01    	/defspa1/defeng1/Cnt01  /Var02/Def02		/Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(cPerg,"01" ,"Emissao De  ?"			,""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR01",""        	,""     ,""     ,""     ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"02" ,"Emissao Ate ?"			,""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02",""        	,""     ,""     ,""     ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"03" ,"Entrega De  ?"			,""       ,""      ,"mv_ch3","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR03",""        	,""     ,""     ,""     ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"04" ,"Entrega Ate ?"			,""       ,""      ,"mv_ch4","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR04",""        	,""     ,""     ,""     ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"05" ,"Tipo De  ?"				,""       ,""      ,"mv_ch5","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR05",""        	,""     ,""     ,""     ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"02")
	U_CRIASX1(cPerg,"06" ,"Tipo Ate ?"				,""       ,""      ,"mv_ch6","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR06",""        	,""     ,""     ,""     ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"02")
	U_CRIASX1(cPerg,"07" ,"Analitico/Sintetico ?"	,""       ,""      ,"mv_ch7","N" ,01     ,0      ,0     ,"C",""        ,"MV_PAR07","Analitico" 	,""     ,""     ,""     ,""   ,"Sintetico"  ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"08" ,"Produto De ?"			,""       ,""      ,"mv_ch8","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR08","" 			,""     ,""     ,""     ,""   ,""  			,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
	U_CRIASX1(cPerg,"09" ,"Produto Ate ?"			,""       ,""      ,"mv_ch9","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR09","" 			,""     ,""     ,""     ,""   ,""  			,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
	U_CRIASX1(cPerg,"10" ,"Grupo De ?"				,""       ,""      ,"mv_cha","C" ,04     ,0      ,0     ,"G",""        ,"MV_PAR10","" 			,""     ,""     ,""     ,""   ,""  			,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SBM")
	U_CRIASX1(cPerg,"11" ,"Grupo Ate ?"				,""       ,""      ,"mv_chb","C" ,04     ,0      ,0     ,"G",""        ,"MV_PAR11","" 			,""     ,""     ,""     ,""   ,""  			,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SBM")

Return (Nil)

