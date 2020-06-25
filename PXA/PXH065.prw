#INCLUDE "Totvs.ch"
#INCLUDE "TopConn.ch"

/*/
Função	    	:	PXH065
Autor			:	Fabiano da Silva
Data 			: 	18.12.2014
Descrição   	: 	Etiqueta de Produto
/*/

User Function PXH065()

	Local oDlg              // Nome do objeto referente a Dialog
	Private oPrint

	ATUSX1()

	_nOpc := 0

	DEFINE MSDIALOG oDlg  FROM 0,0 TO 160,350 TITLE "Etiqueta de Produto" OF oDlg PIXEL

	@ 02,10 TO 050,168 OF oDlg PIXEL

	@ 10,18 SAY "Rotina para gerar Etiquetas de Produtos" OF oDlg PIXEL
	@ 18,18 SAY "conforme parâmetros solicitados pelo Usuário.    " OF oDlg PIXEL
	@ 34,18 SAY "Programa PXH065.PRW                             " OF oDlg PIXEL

	DEFINE SBUTTON FROM 055,030 TYPE 5 ACTION Pergunte("PXH065") 	ENABLE Of oDlg
	DEFINE SBUTTON FROM 055,075 TYPE 1 ACTION (_nOpc:=1,oDlg:END()) ENABLE Of oDlg
	DEFINE SBUTTON FROM 055,120 TYPE 2 ACTION oDlg:End() 		 	 	 ENABLE Of oDlg

	ACTIVATE MSDIALOG oDlg CENTERED

	If _nOpc == 1

		oPrint:= TMSPrinter():New("Etiqueta Produto")
		oPrint:SetPortrait()

		Private oFont1 := TFont():New("Courier New"  ,09,08,.T.,.T.,5,.T.,5,.T.,.F.) // Courier 09 Plain
		Private oFont2 := TFont():New("Courier New"  ,09,07,.T.,.T.,5,.T.,5,.T.,.F.) // Courier 09 Plain
		Private oFont3 := TFont():New("Arial"   	 ,09,11,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   09 Bold
		Private oFont4 := TFont():New("Arial"   	 ,09,09,.T.,.F.,5,.T.,5,.T.,.F.) // Arial   09 Plain
		Private oFont5 := TFont():New("Arial"   	 ,12,10,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   12 Bold
		Private oFont6 := TFont():New("Arial"   	 ,12,10,.T.,.F.,5,.T.,5,.T.,.F.) // Arial   12 Plain
		Private oFont7 := TFont():New("Arial"   	 ,9,9  ,.T.,.F.,5,.T.,5,.T.,.F.) // Arial   14 Plain
		Private oFont8 := TFont():New("Arial"   	 ,16,16,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   14 Plain
		Private oFont9 := TFont():New("Arial"   	 ,14,14,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   14 Plain

		oPrint:Setup()

		Private _lFim      := .F.
		Private _cMsg01    := ''
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| PXH65A(@_lFim) }
		Private _cTitulo01 := 'Gerando Etiqueta!!!!'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

		oPrint:Preview()

	Endif

Return


Static Function PXH65A()

	nCont := 0
	nCol := 0

	Pergunte('PXH065',.f.)

	_cPorta  	:= "LPT1"
	_nQtEt 		:= 1

	MSCBPRINTER("ZEBRA",_cPorta,,,.f.)
	MSCBCHKSTATUS(.f.)

	_cQuery := " SELECT * FROM "+RetSQLName("SB1")+" B1 "
	_cQuery += " INNER JOIN "+RetSQLName("SBM")+" BM ON B1_GRUPO = BM_GRUPO "
	//	_cQuery += " WHERE B1_COD BETWEEN 'S0020019' AND 'S0020022' "
	_cQuery += " WHERE B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	_cQuery += " AND B1_TIPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	_cQuery += " AND B1.D_E_L_E_T_ = '' AND BM.D_E_L_E_T_ = '' "

	TcQuery _cQuery new Alias "TSB1"

	TSB1->(dbGoTop())

	While !TSB1->(EOF())

		oPrint:StartPage()
		nCol     := 10
		nColEtiq := 0

		oPrint:Say  (025,010,"Localização: ",oFont8)
		oPrint:Say  (025,370,Alltrim(TSB1->B1_YPRAT),oFont8)

		//Codigo
		oPrint:Say  (105,010,"Código: ",oFont8)
		oPrint:Say  (105,370,Alltrim(TSB1->B1_COD),oFont8)

		//Descricao sub-grupo
		oPrint:Say  (185,010,Alltrim(TSB1->BM_DESC),oFont9)

		//Descricao
		_nLin  := 250
		_nLin2 := 0
		For A := 1 To Len(Alltrim(TSB1->B1_DESC))
			_nLin2 ++
			
			oPrint:Say(_nLin,010,MemoLine(Alltrim(TSB1->B1_DESC),30,_nLin2),oFont6)

			_nLin += 45
		Next A 

		oPrint:Say  (400,600,Alltrim(TSB1->B1_UM) 	,oFont8)

		oPrint:EndPage()

		/*
		MSCBBEGIN(_nQtEt,6)

		MSCBSAY(03,05,"Localizacao:"		  	, "N","0","30,50")
		MSCBSAY(35,05,Alltrim(TSB1->B1_YPRAT)	, "N","0","30,50")
		MSCBSAY(03,10,"Codigo:"				  	, "N","0","30,50")
		MSCBSAY(35,10,Alltrim(TSB1->B1_COD)	  	, "N","0","30,50")
		MSCBSAY(03,17,Alltrim(TSB1->BM_DESC)	, "N","0","20,35")
		_nLin1 := 22
		_nLin2 := 0
		For A := 1 To Len(Alltrim(TSB1->B1_DESC))
		_nLin2 ++

		MSCBSAY(03,_nLin1,MemoLine(Alltrim(TSB1->B1_DESC),30,_nLin2), "N","0","20,35")

		_nLin1 += 3
		Next A 

		MSCBSAY(65,37,TSB1->B1_UM 	, "N","0","30,45")

		MSCBEND()

		MSCBClosePrinter()
		*/
		TSB1->(dbSkip())
	EndDo

	TSB1->(dbCloseArea())

Return


Static Function AtuSX1()

	cPerg  := "PXH065"

	//    	      Grupo/Ordem/Pergunta    				/perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01    	/defspa1/defeng1/Cnt01  /Var02/Def02			/Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3	/cPyme	/cGrpSxg/cHelp
	U_CRIASX1(cPerg,"01" ,"Produto De  ?"			,""       ,""      ,"mv_ch1","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR01",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1"	,		,		,		)
	U_CRIASX1(cPerg,"02" ,"Produto Ate ?"			,""       ,""      ,"mv_ch2","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR02",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1"	,		,		,		)
	U_CRIASX1(cPerg,"03" ,"Tipo De  ?"				,""       ,""      ,"mv_ch3","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR03",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,""	,		,		,		)
	U_CRIASX1(cPerg,"04" ,"Tipo Ate ?"				,""       ,""      ,"mv_ch4","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR04",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,""	,		,		,		)

Return (Nil)
