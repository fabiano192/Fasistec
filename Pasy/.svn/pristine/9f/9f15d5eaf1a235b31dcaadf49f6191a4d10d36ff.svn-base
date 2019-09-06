#INCLUDE "TOTVS.ch"
#INCLUDE "TOPCONN.ch"

/*/
Programa	:	PA0247
Autor		:	Fabiano da Silva
Data		:	10/04/2017
Descrição	:	Relatório Despesas Financeiras
/*/

User Function PA0247()

	Local oDlg
	Local _nOpc 		:= 0
	Local _dDtRef 		:= cTod('')

	ATUSX1()

	DEFINE MSDIALOG oDlg  FROM 0,0 TO 160,380 TITLE "Despesas Financeiras" OF oDlg PIXEL

	@ 02,10 TO 050,180 OF oDlg PIXEL

	@ 10,18 SAY "Relatório de despesas Financeiras em Excel conforme os	" 	OF oDlg PIXEL
	@ 18,18 SAY "parâmetros informados pelo usuário.									"	OF oDlg PIXEL
	@ 34,18 SAY "Programa PA0247.PRW                                					" 	OF oDlg PIXEL

	DEFINE SBUTTON FROM 055,030 TYPE 5 ACTION (Pergunte("PA0247",.T.)) 	ENABLE Of oDlg
	DEFINE SBUTTON FROM 055,080 TYPE 1 ACTION (_nOpc:=1,oDlg:END()) 	ENABLE Of oDlg
	DEFINE SBUTTON FROM 055,130 TYPE 2 ACTION oDlg:End() 				ENABLE Of oDlg

	ACTIVATE MSDIALOG oDlg CENTERED

	If _nOpc == 1

		Pergunte("PA0247",.F.)

		Private _lFim      := .F.
		Private _cMsg01    := ''
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| PA247_A(@_lFim) }
		Private _cTitulo01 := 'Gerando Arquivo!!!!'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

	Endif

Return(Nil)


Static Function PA247_A()

	Local _oFwMsEx 		:= NIL
	Local _cDir			:= GetSrvProfString("Startpath","")
	Local _cWorkSheet	:= ""
	Local _cTable 		:= ""
	Local _cDirTmp 		:= GetTempPath()

	_cQuery := " SELECT E2_PREFIXO AS PREFIXO,E2_PARCELA AS PARCELA,E2_NUM AS NUMERO,E2_TIPO AS TIPO,E2_FORNECE AS FORNECE,E2_LOJA AS LOJA, " +CRLF
	_cQuery += " E2_NOMFOR AS NOME,E2_EMISSAO AS EMISSAO,E2_VENCREA AS VENCREA,E2_VENCTO AS VENCTO,E2_VALOR AS VALOR, E2_SALDO AS SALDO, " +CRLF
	_cQuery += " E2_NATUREZ AS NATUREZA,E2_FATURA AS FATURA" +CRLF
	_cQuery += " FROM "+RetSqlName("SE2")+" E2 " +CRLF
	_cQuery += " WHERE E2.D_E_L_E_T_ = '' " +CRLF
	_cQuery += " AND E2_STATUS <> 'B' " +CRLF
	_cQuery += " AND E2_EMISSAO	BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'" +CRLF
	_cQuery += " AND E2_VENCTO	BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'" +CRLF
	_cQuery += " AND E2_FORNECE	BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' " +CRLF
	_cQuery += " AND E2_NATUREZ	BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' " +CRLF
	_cQuery += " AND E2_NUM		BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' " +CRLF
	_cQuery += " UNION " +CRLF
	_cQuery += " SELECT E5_PREFIXO AS PREFIXO,E5_PARCELA AS PARCELA,E5_NUMERO AS NUMERO,E5_TIPO AS TIPO,E5_CLIFOR AS FORNECE,E5_LOJA AS LOJA, " +CRLF
	_cQuery += " ISNULL(A2_NREDUZ,'') AS NOME,E5_DATA AS EMISSAO,E5_DTDISPO AS VENCREA ,E5_DTDISPO AS VENCTO,E5_VALOR AS VALOR,0 AS SALDO, " +CRLF
	_cQuery += " E5_NATUREZ AS NATUREZA,'' AS FATURA " +CRLF 
	_cQuery += " FROM "+RetSqlName("SE5")+" E5 " +CRLF
	_cQuery += " LEFT JOIN "+RetSqlName("SA2")+" A2 ON E5_CLIFOR = A2_COD AND E5_LOJA = A2_LOJA AND A2.D_E_L_E_T_ = '' " +CRLF
 	_cQuery += " WHERE E5.D_E_L_E_T_ = '' " +CRLF 
	_cQuery += " AND E5_RECPAG = 'P' AND E5_TIPODOC <> 'ES' AND E5_SITUACA <> 'C' AND E5_MOEDA = 'M1'	" +CRLF
	_cQuery += " AND E5_DATA	BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'" +CRLF
	_cQuery += " AND E5_DTDISPO	BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'" +CRLF
	_cQuery += " AND E5_CLIFOR	BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' " +CRLF
	_cQuery += " AND E5_NATUREZ	BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' " +CRLF
	_cQuery += " AND E5_NUMERO	BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' " +CRLF
	_cQuery += " ORDER BY EMISSAO,FORNECE,LOJA,NUMERO " +CRLF

//	MemoWrite("D:\PA0247.TXT",_cQuery)

	TCQUERY _cQuery New ALIAS "TRB"

	TcSetField("TRB","EMISSAO"	,"D")
	TcSetField("TRB","VENCTO"	,"D")
	TcSetField("TRB","VENCREA"	,"D")

	Count to _nRec 

	If _nRec > 0

		TRB->(dbGoTop())

		_oFwMsEx := FWMsExcel():New()

		_cWorkSheet := "Despesa_Financeira"
		_cTable     := "Relatório de Despesa Financeira de "+Dtoc(MV_PAR01)+ " à "+Dtoc(MV_PAR02)

		_oFwMsEx:AddWorkSheet( _cWorkSheet )

		_oFwMsEx:AddTable( _cWorkSheet, _cTable )

		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Emissão"			, 1,4,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Vencimento"			, 1,4,.F.)
//		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Vencimento Real"	, 1,4,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Tipo"  				, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Natureza"			, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Prefixo"			, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Numero"				, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Parcela"			, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Fatura"				, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Fornecedor"			, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Loja"				, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Nome"				, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Valor"  			, 3,2,.T.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Valor Pago"			, 3,2,.T.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Saldo" 				, 3,2,.T.)

		While !TRB->(EOF())

			_oFwMsEx:AddRow( _cWorkSheet, _cTable,{;
			TRB->EMISSAO					,;
			TRB->VENCTO					,;
			Alltrim(TRB->TIPO)			,;
			Alltrim(TRB->NATUREZA)		,;
			Alltrim(TRB->PREFIXO)		,;
			Alltrim(TRB->NUMERO)		,;
			Alltrim(TRB->PARCELA)		,;
			Alltrim(TRB->FATURA)		,;
			Alltrim(TRB->FORNECE)		,;
			Alltrim(TRB->LOJA)			,;
			Alltrim(TRB->NOME)		,;
			TRB->VALOR					,;
			TRB->VALOR - TRB->SALDO		,;
			TRB->SALDO					})

//			TRB->E2_VENCREA					,;

			TRB->(dbSkip())
		EndDo

	Endif

	TRB->(dbCloseArea())

	_oFwMsEx:Activate()

	_cArq2 := CriaTrab( NIL, .F. ) + ".xls"

	LjMsgRun( "Gerando o arquivo, aguarde...", "Despesa Financeira", {|| _oFwMsEx:GetXMLFile( _cArq2 ) } )

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

	cPerg := "PA0247"
	aRegs := {}

	//    	  Grupo/Ordem/Pergunta         /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid         /Var01     /Def01      /defspa1/defeng1/Cnt01/Var02/Def02      /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(cPerg,"01","Emissao De     ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR01",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"02","Emissao Ate    ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR02",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"03","Vencimento de  ?",""       ,""      ,"mv_ch3","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR03",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"04","Vencimento ate ?",""       ,""      ,"mv_ch4","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR04",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"05","Fornecedor de  ?",""       ,""      ,"mv_ch5","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR05",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SA2")
	U_CRIASX1(cPerg,"06","Fornecedor ate ?",""       ,""      ,"mv_ch6","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR06",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SA2")
	U_CRIASX1(cPerg,"07","Natureza de    ?",""       ,""      ,"mv_ch7","C" ,10     ,0      ,0     ,"G",""            ,"MV_PAR07",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SED")
	U_CRIASX1(cPerg,"08","Natureza ate   ?",""       ,""      ,"mv_ch8","C" ,10     ,0      ,0     ,"G",""            ,"MV_PAR08",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SED")
	U_CRIASX1(cPerg,"09","Numero de      ?",""       ,""      ,"mv_ch9","C" ,09     ,0      ,0     ,"G",""            ,"MV_PAR09",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"10","Numero ate     ?",""       ,""      ,"mv_cha","C" ,09     ,0      ,0     ,"G",""            ,"MV_PAR10",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return(Nil)
