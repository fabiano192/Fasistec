#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'

#Define Verde "#9AFF9A"
#Define Amarelo "#FFFF00"
#Define Branco "#FFFAFA"
#Define Preto "#000000"
#Define Cinza "#696969"
#Define Mizu "#E8782F"

/*
Programa	:	BRI139
Autor		:	Fabiano da Silva
Data		:	03/02/20
Descrição	:	Relação de CT-es
*/
User Function BRI139()

	Local _oDlg			:= NIL
	Local _nOpc			:= 0

	Private _oFont11N	:= TFont():New('Arial'	,,-11,,.T.,,,,,.F.,.F.)

	AtuSX1()

	DEFINE MSDIALOG _oDlg FROM 264,182 TO 435,500 TITLE "Relatório de CT-e's (BRI139)" OF _oDlg PIXEL

	_oGrupo	:= TGroup():New(005,005,045,155,"",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 010,010 SAY _oTSayA VAR "Esta rotina tem por objetivo emitir o relatório de"	OF _oGrupo PIXEL Size 150,010 FONT _oFont11N
	@ 020,010 SAY "CT-e's conforme os parâmetros informados"		OF _oGrupo PIXEL Size 150,010 FONT _oFont11N
	@ 030,010 SAY "pelo usuário."		OF _oGrupo PIXEL Size 150,010 FONT _oFont11N

	_oTBut1	:= TButton():New( 60,010, "Parâmetros" ,_oDlg,{||Pergunte("BRI139")},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )
	_cStyle := GetStyle(Amarelo,Branco,Cinza,Preto,1)
	_oTBut1:SetCss(_cStyle)

	_oTBut2	:= TButton():New( 60,068, "OK" ,_oDlg,{||_nOpc := 1,_oDlg:End()},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )
	_cStyle := GetStyle(Verde,Branco,Cinza,Preto,1)
	_oTBut2:SetCss(_cStyle)

	_oTBut3	:= TButton():New( 60,120, "Sair" ,_oDlg,{||_nOpc := 0,_oDlg:End()},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )
	_cStyle := GetStyle(Branco,Mizu,Cinza,Preto,1)
	_oTBut3:SetCss(_cStyle)

	ACTIVATE MSDIALOG _oDlg CENTERED

	If _nOpc = 1
		Pergunte('BRI139',.F.)
		LjMsgRun('Gerando relatório de CT-e...','CT-e',{|| BRI139A()})
	Endif

Return(Nil)



Static Function GetStyle(_cCor1,_cCor2,_cCor3,_cCor4,_nTip)

	Local _cMod := ''
	Default _nTip := 1

	_cMod := "QPushButton { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+_cCor1+", stop: 1 "+_cCor2+");"
	_cMod += "border-style: outset;border-width: 2px;
		_cMod += "border-radius: 10px;border-color: "+_cCor3+";"
	_cMod += "color: "+_cCor4+"};"
	_cMod += "QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+_cCor2+", stop: 1 "+_cCor1+");"
	_cMod += "border-style: outset;border-width: 2px;"
	_cMod += "border-radius: 10px;"
	_cMod += "border-color: "+_cCor3+" }"

Return(_cMod)



Static Function BRI139A()

	Local _oFwMsEx 		:= NIL
	Local _cArq 		:= ""
	Local _cWorkSheet	:= "CTe"
	Local _cTable 		:= "Relatório de CT-e de "+dtoc(MV_PAR01)+" até "+dtoc(MV_PAR02)
	Local _lCTe			:= .F.
	Local _cDir			:= GetTempPath()

	_oFwMsEx := FWMsExcel():New()

	_oFwMsEx:AddWorkSheet( _cWorkSheet )

	_oFwMsEx:AddTable( _cWorkSheet, _cTable )

// codigo, loja nome, nf, serie, emissao. (remetente), (codigo, loja, nome, numero cte, data cte, valor do frete)

	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Transportadora"		, 1,1,.F.)
	// _oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Nome"			, 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Nr CT-e"			, 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Série CT-e"			, 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Data CT-e"  		, 1,4,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Valor Frete"		, 3,2,.T.)

	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Código Remetente"	, 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Loja Remetente"		, 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Nome Remetente"		, 1,1,.F.)

	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Código Destinatário", 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Loja Destinatário"	, 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Nome Destinatário" 	, 1,1,.F.)

	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Nota Fiscal"		, 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Série NF"			, 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Emissão NF"			, 1,4,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Valor NF"  			, 3,2,.T.)

	_nRecnoSM0 := SM0->(GetArea())

	SM0->(dbGoTop())

	While SM0->(!EOF())

		_cEmp := Alltrim(SM0->M0_CODIGO)
		If _cEmp < MV_PAR03 .Or. _cEmp > MV_PAR04
			SM0->(dbSkip())
			Loop
		Endif

		_cQuery := " SELECT DT6_DOC,DT6_SERIE,DT6_DATEMI,DT6_VALFRE,DT6_CLIREM,DT6_LOJREM,A1R.A1_NREDUZ AS NOMREM,DT6_CLIDES,DT6_LOJDES,A1D.A1_NREDUZ AS NOMDES,DTC_NUMNFC,DTC_SERNFC,DT6_VALMER,DTC_DATENT " +CRLF
		_cQuery += " FROM DT6"+_cEmp+"0 DT6 " +CRLF
		_cQuery += " INNER JOIN DTC"+_cEmp+"0 DTC ON DT6_LOTNFC = DTC_LOTNFC " +CRLF
		_cQuery += " INNER JOIN SA1010 A1R ON A1R.A1_COD = DT6_CLIREM AND A1R.A1_LOJA = DT6_LOJREM " +CRLF
		_cQuery += " INNER JOIN SA1010 A1D ON A1D.A1_COD = DT6_CLIDES AND A1D.A1_LOJA = DT6_LOJDES " +CRLF
		_cQuery += " WHERE DT6.D_E_L_E_T_ = '' AND DTC.D_E_L_E_T_ = '' AND A1R.D_E_L_E_T_ = '' AND A1D.D_E_L_E_T_ = '' " +CRLF
		_cQuery += " AND DT6_DATEMI BETWEEN '"+dTos(MV_PAR01)+"' AND '"+dTos(MV_PAR02)+"' " +CRLF
		_cQuery += " AND DT6_YSORIG BETWEEN  '"+MV_PAR05+"' AND '"+MV_PAR06+"' " +CRLF
		_cQuery += " ORDER BY DT6_YSORIG,DT6_SERIE, DT6_DOC "  +CRLF

		TCQUERY _cQuery NEW ALIAS "TDT6"

		TCSETFIELD("TDT6","DT6_DATEMI","D")
		TCSETFIELD("TDT6","DTC_DATENT","D")

		COUNT TO nRec

		If nRec > 0

			TDT6->(dbGoTop())

			While !TDT6->(EOF())

				_oFwMsEx:AddRow( _cWorkSheet, _cTable,{;
					Alltrim(SM0->M0_NOMECOM)	,;
					TDT6->DT6_DOC				,;
					TDT6->DT6_SERIE   			,;
					TDT6->DT6_DATEMI 			,;
					TDT6->DT6_VALFRE  			,;
					TDT6->DT6_CLIREM			,;
					TDT6->DT6_LOJREM			,;
					TDT6->NOMREM				,;
					TDT6->DT6_CLIDES   			,;
					TDT6->DT6_LOJDES   			,;
					TDT6->NOMDES	 			,;
					TDT6->DTC_NUMNFC 			,;
					TDT6->DTC_SERNFC			,;
					TDT6->DTC_DATENT			,;
					TDT6->DT6_VALMER			})

				TDT6->(dbSkip())
			EndDo

			_lCTe := .T.
		Endif

		TDT6->(dbCloseArea())

		SM0->(dbSkip())
	EndDo

	RestArea(_nRecnoSM0)

	If !_lCTe
		MsgAlert('Não existem dados para serem impressos!')
		Return(Nil)
	Endif

	_oFwMsEx:Activate()

	_cArq := CriaTrab( NIL, .F. ) + ".xls"

	LjMsgRun( "Gerando o arquivo, aguarde...", "CT-e", {|| _oFwMsEx:GetXMLFile( _cArq ) } )

	If !ExistDir( _cDir )
		If MakeDir( _cDir ) <> 0
			MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
			Return
		EndIf
	EndIf

	_cNomArq := "CTe_"+dtos(dDatabase)+"_"+StrTran(Time(),":","")+".xls"

	If __CopyFile(_cArq, _cDir + _cNomArq)

		FErase(_cArq)

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

	_cPerg := "BRI139"

//    	      Grupo/Ordem/Pergunta    				/perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01    	/defspa1/defeng1/Cnt01  /Var02/Def02/Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(_cPerg,"01" ,"Emissao De  ?"			,""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR01",""        	,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"02" ,"Emissao Ate ?"			,""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02",""        	,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"03" ,"Transportadora De  ?"	,""       ,""      ,"mv_ch3","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR03",""        	,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SM0")
	U_CRIASX1(_cPerg,"04" ,"Transportadora Ate ?"	,""       ,""      ,"mv_ch4","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR04",""        	,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SM0")
	U_CRIASX1(_cPerg,"05" ,"Origem De  ?"			,""       ,""      ,"mv_ch5","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR05",""        	,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"06" ,"Origem Ate ?"			,""       ,""      ,"mv_ch6","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR06",""        	,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return (Nil)
