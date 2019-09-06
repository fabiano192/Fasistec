#INCLUDE "TOTVS.ch"
#INCLUDE "TOPCONN.ch"

/*/
Programa	:	CR0071
Autor		:	Fabiano da Silva
Data		:	26/04/2015
Descrição	:	Ranking de Materiais por Compra
/*/

User Function CR0071()

	Local oDlg
	Local _nOpc 		:= 0
	Local _dDtRef 		:= cTod('')

	ATUSX1()

	DEFINE MSDIALOG oDlg  FROM 0,0 TO 160,380 TITLE "Ranking Produto por Compra" OF oDlg PIXEL

	@ 02,10 TO 050,180 OF oDlg PIXEL

	@ 10,18 SAY "Rotina Gerar a Ranking de Materiais por Compra em Excel 		" 	OF oDlg PIXEL
	@ 18,18 SAY "Conforme os parâmetros informados pelo usuário.				"	OF oDlg PIXEL
	@ 34,18 SAY "Programa CR0071.PRW                                			" 	OF oDlg PIXEL

	DEFINE SBUTTON FROM 055,030 TYPE 5 ACTION (Pergunte("CR0071",.T.)) 	ENABLE Of oDlg
	DEFINE SBUTTON FROM 055,080 TYPE 1 ACTION (_nOpc:=1,oDlg:END()) 	ENABLE Of oDlg
	DEFINE SBUTTON FROM 055,130 TYPE 2 ACTION oDlg:End() 				ENABLE Of oDlg

	ACTIVATE MSDIALOG oDlg CENTERED

	If _nOpc == 1

		Pergunte("CR0071",.F.)

		Private _lFim      := .F.
		Private _cMsg01    := ''
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| CR071_A(@_lFim) }
		Private _cTitulo01 := 'Gerando Arquivo!!!!'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

	Endif

Return(Nil)


Static Function CR071_A()

	Local _oFwMsEx 		:= NIL
	Local _cDir			:= GetSrvProfString("Startpath","")
	Local _cWorkSheet	:= ""
	Local _cTable 		:= ""
	Local _cDirTmp 		:= GetTempPath()

	_cQuery := " SELECT D1_COD,B1_DESC,B1_UM,B1_TIPO,B1_GRUPO,B1_SUBGR,SUM(D1_TOTAL) AS TOTAL,SUM(D1_VALIPI) AS IPI,SUM(D1_QUANT) AS QTDE "
	_cQuery += " FROM "+RetSqlName("SD1")+" D1 "
	_cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 ON D1_COD = B1_COD "
	_cQuery += " INNER JOIN "+RetSqlName("SF4")+" F4 ON D1_TES = F4_CODIGO "
	_cQuery += " WHERE D1.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = ''"
	_cQuery += " AND D1_TIPO = 'N' AND F4_DUPLIC = 'S' "
	_cQuery += " AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
	_cQuery += " AND B1_TIPO 	BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
	_cQuery += " AND B1_GRUPO 	BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
	_cQuery += " AND B1_SUBGR 	BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"
	_cQuery += " AND D1_COD 	BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"
	_cQuery += " AND D1_FORNECE BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'"
	_cQuery += " GROUP BY D1_COD,B1_DESC,B1_UM,B1_TIPO,B1_GRUPO,B1_SUBGR ""

	TCQUERY _cQuery New ALIAS "TRB"

	TcSetField("TRB","TOTAL","N",18,2)
	
	Count to _nRec 

	If _nRec > 0

		dbSelectArea("TRB")

		_cArq := CriaTrab(NIL,.F.)
		Copy To &_cArq

		TRB->(dbCloseArea())

		dbUseArea(.T.,,_cArq,"TRB",.T.)
		_cInd := "DESCEND(STR(TRB->TOTAL,18,2))"
		IndRegua("TRB",_cArq,_cInd,,,"Selecionando Arquivo Trabalho")

		TRB->(dbGoTop())

		_nRank := 0

		_oFwMsEx := FWMsExcel():New()

		_cWorkSheet  := "Ranking"
		_cTable      := "Ranking de Materiais por Compra de "+Dtoc(MV_PAR01)+ " à "+Dtoc(MV_PAR02)

		_oFwMsEx:AddWorkSheet( _cWorkSheet )

		_oFwMsEx:AddTable( _cWorkSheet, _cTable )

		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Produto" 	, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Descrição"	, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "UM"  		, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Tipo"  		, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Grupo"  	, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "SubGrupo"	, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Valor"  	, 3,2,.T.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Valor IPI" 	, 3,2,.T.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Quantidade" , 3,2,.T.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Valor/Qtde"	, 3,2,.T.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Ranking"	, 1,1,.F.)

		While !TRB->(EOF())

			_nRank ++

			_oFwMsEx:AddRow( _cWorkSheet, _cTable,{;
			Alltrim(TRB->D1_COD)				,;
			Alltrim(TRB->B1_DESC)				,;
			TRB->B1_UM							,;
			TRB->B1_TIPO						,;
			TRB->B1_GRUPO						,;
			TRB->B1_SUBGR						,;
			TRB->TOTAL							,;
			TRB->IPI							,;
			TRB->QTDE							,;
			Round((TRB->TOTAL / TRB->QTDE),2)	,;
			Alltrim(Str(_nRank))				})

			TRB->(dbSkip())
		EndDo

	Endif

	TRB->(dbCloseArea())

	fErase(_cArq+".DBF")
	FErase(_cArq+OrdBagExt())

	_oFwMsEx:Activate()

	_cArq2 := CriaTrab( NIL, .F. ) + ".xls"

	LjMsgRun( "Gerando o arquivo, aguarde...", "Controle de Estoque", {|| _oFwMsEx:GetXMLFile( _cArq2 ) } )

	If __CopyFile( _cArq2, _cDirTmp + _cArq2 )
		_oExcelApp := MsExcel():New()
		_oExcelApp:WorkBooks:Open( _cDirTmp + _cArq2 )
		_oExcelApp:SetVisible(.T.)
	Else
		MsgInfo( "Arquivo não copiado para temporário do usuário." )

		_oExcelApp := MsExcel():New()
		_oExcelApp:WorkBooks:Open( _cDir + _cArq2 )
		_oExcelApp:SetVisible(.T.)
	Endif

Return



Static Function AtuSX1()

	cPerg := "CR0071"
	aRegs := {}

	//    	  Grupo/Ordem/Pergunta        	  /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid         /Var01     /Def01      /defspa1/defeng1/Cnt01/Var02/Def02      /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(cPerg,"01","Data De 			?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR01",""      	,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"02","Data Ate			?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR02",""      	,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"03","Tipo de       	?",""       ,""      ,"mv_ch3","C" ,02     ,0      ,0     ,"G",""            ,"MV_PAR03",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"02")
	U_CRIASX1(cPerg,"04","Tipo ate      	?",""       ,""      ,"mv_ch4","C" ,02     ,0      ,0     ,"G",""            ,"MV_PAR04",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"02")
	U_CRIASX1(cPerg,"05","Grupo de      	?",""       ,""      ,"mv_ch5","C" ,04     ,0      ,0     ,"G",""            ,"MV_PAR05",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SBM")
	U_CRIASX1(cPerg,"06","Grupo ate     	?",""       ,""      ,"mv_ch6","C" ,04     ,0      ,0     ,"G",""            ,"MV_PAR06",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SBM")
	U_CRIASX1(cPerg,"07","SubGrupo de   	?",""       ,""      ,"mv_ch7","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR07",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"Z1")
	U_CRIASX1(cPerg,"08","SubGrupo ate  	?",""       ,""      ,"mv_ch8","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR08",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"Z1")
	U_CRIASX1(cPerg,"09","Produto de    	?",""       ,""      ,"mv_ch9","C" ,15     ,0      ,0     ,"G",""            ,"MV_PAR09",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
	U_CRIASX1(cPerg,"10","Produto ate   	?",""       ,""      ,"mv_cha","C" ,15     ,0      ,0     ,"G",""            ,"MV_PAR10",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
	U_CRIASX1(cPerg,"11","Fornecedor de 	?",""       ,""      ,"mv_chb","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR11",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SA2")
	U_CRIASX1(cPerg,"12","Fornecedor ate	?",""       ,""      ,"mv_chc","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR12",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SA2")

Return (Nil)


///   MV_PAR03     /// Tipo De       ?  //////
///   MV_PAR04     /// Tipo Ate      ?  //////
///   MV_PAR05     /// Grupo De      ?  ////// 
///   MV_PAR06     /// Grupo Ate     ?  //////
///   MV_PAR07     /// SubGrupo De   ?  //////
///   MV_PAR08     /// SubGrupo Ate  ?  //////
///   MV_PAR09     /// Produto De    ?  ////// 
///   MV_PAR10     /// Produto Ate   ?  //////
///   MV_PAR11     /// Fornecedor De ?  ////// 
///   MV_PAR10     /// Fornecedor Ate?  //////
//////////////////////////////////////////////
*/
