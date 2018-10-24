#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'


User Function BRI115()

	Private _oDlg
	Private _oFont1

	Private _cFilDe := cFilAnt
	Private _cFilAt := cFilAnt

	Private _cUFDe := Space(TAMSX3("A1_EST")[1])
	Private _cUFAt := Replicate('Z',TAMSX3("A1_EST")[1])

	Private _cCliDe := Space(TAMSX3("A1_COD")[1])
	Private _cCliAt := Replicate('Z',TAMSX3("A1_COD")[1])

	Private _cLojDe := Space(TAMSX3("A1_LOJA")[1])
	Private _cLojAt := Replicate('Z',TAMSX3("A1_LOJA")[1])

	Private _cProDe := Space(TAMSX3("B1_COD")[1])
	Private _cProAt := Replicate('Z',TAMSX3("B1_COD")[1])

	Private _nPerc	:= 0

	Private _oBrowse	:= Nil
	Private _aBrowse	:= {{.F.,'','','','','','',0,0,0}}

	Private _oOK	:= LoadBitmap(GetResources(),'LBOK')
	Private _oNO	:= LoadBitmap(GetResources(),'LBNO')

	_oSize := FwDefSize():New( .F. )							// Com enchoicebar
	_oSize:AddObject( "P1", 100, 13, .T., .t. )
	_oSize:AddObject( "P2", 100, 08, .T., .t. )
	_oSize:AddObject( "P3", 100, 68, .T., .T. )
	_oSize:AddObject( "P4", 100, 11, .T., .T. )
	_oSize:lProp 	:= .T.
	_oSize:lLateral := .F.  									// Calculo vertical
	_oSize:Process()

	DEFINE MSDIALOG _oDlg TITLE OemToAnsi("Reajuste Tabela de Preço") FROM _oSize:aWindSize[1],_oSize:aWindSize[2] TO ;
	_oSize:aWindSize[3],_oSize:aWindSize[4] OF _oDlg PIXEL  Style DS_MODALFRAME

	_oDlg:lEscClose := .F. //Não permite fechar a janela pelo botão "ESC"

	DEFINE FONT _oFont1 NAME "Arial" BOLD SIZE 0,16 OF _oDlg

	Panel01()

	Panel02()

	Panel03()

	Panel04()

	ACTIVATE MSDIALOG _oDlg CENTERED

Return(Nil)



Static Function Panel01()

	Local _oGroup1	:= TGroup():New(_oSize:GetDimension( "P1","LININI"),_oSize:GetDimension( "P1", "COLINI"),;
	_oSize:GetDimension( "P1", "LINEND"),_oSize:GetDimension( "P1", "COLEND" ),"Parâmetros",_oDlg,CLR_GREEN,,.T.)

	Local _nLiI1	:= _oSize:GetDimension( "P1", "LININI" )+3
	Local _nCol		:= 8
	Local _oCor		:= CLR_CYAN

	_nTmCol	:= 20

	_oSay3	:= TSay():New(_nLiI1+005,_nCol,{||' Filial de ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
	_oSay3:lTransparent := .F.
	@ _nLiI1+005, _nCol+52  MsGet _cFilDe	Picture '@!' Size _nTmCol,08 Pixel Of _oDlg

	_oSay4:= TSay():New(_nLiI1+020,_nCol,{||' Filial Até ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
	_oSay4:lTransparent := .F.
	@ _nLiI1+020, _nCol+52  MsGet _cFilAt	 Picture '@!' Size _nTmCol,08 Pixel Of _oDlg

	//	_nCol += 115
	_nCol	+= (50 + _nTmCol  + 15)
	_nTmCol	:= 20

	_oSay3:= TSay():New(_nLiI1+005,_nCol,{||' UF de ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
	_oSay3:lTransparent := .F.
	@ _nLiI1+005, _nCol+52  MsGet _cUFDe	Picture '@!' Size _nTmCol,08 Pixel Of _oDlg

	_oSay4:= TSay():New(_nLiI1+020,_nCol,{||' UF Até ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
	_oSay4:lTransparent := .F.
	@ _nLiI1+020, _nCol+52  MsGet _cUFAt	 Picture '@!' Size _nTmCol,08 Pixel Of _oDlg

	_nCol	+= (50 + _nTmCol  + 15)
	_nTmCol	:= 40

	_oSay3:= TSay():New(_nLiI1+005,_nCol,{||' Cliente de ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
	_oSay3:lTransparent := .F.
	@ _nLiI1+005, _nCol+52  MsGet _cCliDe	Picture '@!' F3 'SA1' Size _nTmCol,08 Pixel Of _oDlg

	_oSay4:= TSay():New(_nLiI1+020,_nCol,{||' Cliente Até ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
	_oSay4:lTransparent := .F.
	@ _nLiI1+020, _nCol+52  MsGet _cCliAt	Picture '@!' F3 'SA1' Size _nTmCol,08 Pixel Of _oDlg

	_nCol	+= (50 + _nTmCol  + 15)
	_nTmCol	:= 20

	_oSay3:= TSay():New(_nLiI1+005,_nCol,{||' Loja de ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
	_oSay3:lTransparent := .F.
	@ _nLiI1+005, _nCol+52  MsGet _cLojDe	Picture '@!' Size _nTmCol,08 Pixel Of _oDlg

	_oSay4:= TSay():New(_nLiI1+020,_nCol,{||' Loja Até ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
	_oSay4:lTransparent := .F.
	@ _nLiI1+020, _nCol+52  MsGet _cLojAt	 Picture '@!' Size _nTmCol,08 Pixel Of _oDlg

	_nCol	+= (50 + _nTmCol  + 15)
	_nTmCol	:= 70

	_oSay3:= TSay():New(_nLiI1+005,_nCol,{||' Produto de ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
	_oSay3:lTransparent := .F.
	@ _nLiI1+005, _nCol+52  MsGet _cProDe	Picture '@!' F3 'SB1' Size _nTmCol,08 Pixel Of _oDlg

	_oSay4:= TSay():New(_nLiI1+020,_nCol,{||' Produto Até ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
	_oSay4:lTransparent := .F.
	@ _nLiI1+020, _nCol+52  MsGet _cProAt	Picture '@!' F3 'SB1' Size _nTmCol,08 Pixel Of _oDlg

	_nCol	+= (50 + _nTmCol  + 15)

	_oTBut1	:= TButton():New( _nLiI1+005, _nCol, "Consulta" ,_oDlg,{||LjMsgRun("Consultando Tabelas de Preço, aguarde...","Tabela de Preço",{||Consulta()})}	, 40,25,,,.F.,.T.,.F.,,.F.,,,.F. )


Return(Nil)



Static Function Panel02()

	Local _oGroup2 := TGroup():New(_oSize:GetDimension( "P2","LININI"),_oSize:GetDimension( "P2", "COLINI"),;
	_oSize:GetDimension( "P2", "LINEND"),_oSize:GetDimension( "P2", "COLEND" ),"Dados para Reajuste",_oDlg,CLR_BLUE,,.T.)

	Local _nLiI1	:= _oSize:GetDimension( "P2", "LININI" )+5
	Local _nCol		:= 8
	Local _oCor		:= CLR_BLUE
	Local _nTmCol	:= 40

	_oSay3	:= TSay():New(_nLiI1+005,_nCol,{||' % Reajuste ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
	_oSay3:lTransparent := .F.

	@ _nLiI1+005, _nCol+52  MsGet _nPerc	Picture '@<E 99,999.99 %' Size _nTmCol,08 Pixel Of _oDlg

	_nCol	+= (50 + _nTmCol  + 15)

	_oTBut1	:= TButton():New( _nLiI1+005, _nCol, "Calcular" ,_oDlg,{||LjMsgRun("Calculando Reajuste, aguarde...","Tabela de Preço",{||Calcular()})}	, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )


Return(Nil)



Static Function Panel03()

	_oGroup3 := TGroup():New(_oSize:GetDimension( "P3","LININI"),_oSize:GetDimension( "P3", "COLINI"),;
	_oSize:GetDimension( "P3", "LINEND"),_oSize:GetDimension( "P3", "COLEND" ),"Tabelas de Preço",_oDlg,CLR_RED,,.T.)

	_nLiI3 := _oSize:GetDimension( "P3", "LININI" )
	_nCoI3 := _oSize:GetDimension( "P3", "COLINI" )
	_nLiF3 := _oSize:GetDimension( "P3", "LINEND" )
	_nCoF3 := _oSize:GetDimension( "P3", "COLEND" )
	_nYSi3 := _oSize:GetDimension( "P3", "YSIZE" )

	_aCampos := {'','Filial','Cliente','Loja','Nome','UF','Produto','Preço Atual','Preço Calculado','Diferença'}

	_oBrowse := TwBrowse():New( _nLiI3+10, _nCoI3+5,_nCoF3-13,_nYSi3-13,,_aCampos,,_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)

	_oBrowse:SetArray(_aBrowse)

	_oBrowse:bLine := {||{If(_aBrowse[_oBrowse:nAt,1],_oOk,_oNo ),; //1 - Marcador
	_aBrowse[_oBrowse:nAt,2],;
	_aBrowse[_oBrowse:nAt,3],;
	_aBrowse[_oBrowse:nAt,4],;
	_aBrowse[_oBrowse:nAt,5],;
	_aBrowse[_oBrowse:nAt,6],;
	_aBrowse[_oBrowse:nAt,7],;
	Transform(_aBrowse[_oBrowse:nAt,8],"@E 9,999,999.99"),;
	Transform(_aBrowse[_oBrowse:nAt,9],"@E 9,999,999.99"),;
	Transform(_aBrowse[_oBrowse:nAt,10],"@E 9,999,999.99")}}

	// Troca a imagem no duplo click do mouse
	//	_oBrowse:bLDblClick := {|| Check(_aBrowse,_oBrowse)}
	_oBrowse:bLDblClick := {|| _aBrowse[_oBrowse:nAt][1] := !_aBrowse[_oBrowse:nAt][1]}

	_oBrowse:bHeaderClick := {|o, _nCol| If(_nCol = 1,MarkAll(_aBrowse,_oBrowse),Nil) }

	_oBrowse:nAt := 1
	_oBrowse:Refresh()

Return(Nil)



Static Function Panel04()

	Local _oGroup2 := TGroup():New(_oSize:GetDimension( "P4","LININI"),_oSize:GetDimension( "P4", "COLINI"),;
	_oSize:GetDimension( "P4", "LINEND"),_oSize:GetDimension( "P4", "COLEND" ),"Ações",_oDlg,CLR_MAGENTA,CLR_YELLOW,.T.)

	Local _nLiI4 		:= _oSize:GetDimension( "P4", "LININI" )+11
	Local _nColI		:= _oSize:GetDimension( "P4", "COLINI")
	Local _nColF		:= _oSize:GetDimension( "P4", "COLEND")
	Local _oTFont		:= TFont():New('Courier new',,-14,,.T.,,,,,.T.)

	_oTBut1	:= TButton():New( _nLiI4, _nColI+100, "REAJUSTAR" ,_oDlg,{||LjMsgRun("Calculando Reajuste, aguarde...","Tabela de Preço",{||Reajustar()})}	, 60,15,,_oTFont,.F.,.T.,.F.,,.F.,,,.F. )
	_oTBut2	:= TButton():New( _nLiI4, _nColF-100-60, "CANCELAR" ,_oDlg,{||_oDlg:End()}	, 60,15,,_oTFont,.F.,.T.,.F.,,.F.,,,.F. )


Return(Nil)




Static Function Consulta()

	Local _cQuery := ""

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	Endif

	_cQuery := " SELECT * FROM "+RetSqlName("SZ2")+" SZ2 " + CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_COD = Z2_CLIENTE AND A1_LOJA = Z2_LOJA " + CRLF
	_cQuery += " WHERE SZ2.D_E_L_E_T_ = '' " + CRLF
	_cQuery += " AND Z2_FILIAL	BETWEEN '"+_cFilDe+"' AND '"+_cFilAt+"' " + CRLF
	_cQuery += " AND Z2_CLIENTE	BETWEEN '"+_cCliDe+"' AND '"+_cCliAt+"' " + CRLF
	_cQuery += " AND Z2_LOJA	BETWEEN '"+_cLojDe+"' AND '"+_cLojAt+"' " + CRLF
	_cQuery += " AND A1_EST		BETWEEN '"+_cUFDe+"'  AND '"+_cUFAt+"' " + CRLF
	_cQuery += " AND Z2_PRODUTO	BETWEEN '"+_cProDe+"' AND '"+_cProAt+"' " + CRLF
	_cQuery += " AND Z2_PRECO > 0 " + CRLF
	If SZ2->(FieldPos("Z2_LIBERAD")) > 0
		_cQuery += " AND Z2_LIBERAD = 'S' " + CRLF
	Endif
	_cQuery += " ORDER BY Z2_FILIAL, Z2_CLIENTE,Z2_LOJA,Z2_PRODUTO "	+ CRLF

	TcQuery _cQuery New Alias "TRB"

	Count to _nTRB

	If _nTRB = 0
		MsgAlert("Não foi encontrado Tabela de Preço com os parâmetros informados!")
		TRB->(dbCloseArea())
		Return(Nil)
	Endif

	TRB->(dbGoTop())

	_aBrowse := {}

	While TRB->(!EOF())

		AADD(_aBrowse,{;
		.F.				,; //01
		TRB->Z2_FILIAL	,; //02
		TRB->Z2_CLIENTE	,; //03
		TRB->Z2_LOJA	,; //04
		TRB->Z2_NOME	,; //05
		TRB->A1_EST		,; //06
		TRB->Z2_PRODUTO	,; //07
		TRB->Z2_PRECO	,; //08
		0	,; //09
		0	}) //10

		TRB->(dbSkip())
	EndDo

	TRB->(dbCloseArea())

	_oBrowse:SetArray(_aBrowse)

	_oBrowse:bLine := {||{If(_aBrowse[_oBrowse:nAt,1],_oOk,_oNo ),; //1 - Marcador
	_aBrowse[_oBrowse:nAt,2],;
	_aBrowse[_oBrowse:nAt,3],;
	_aBrowse[_oBrowse:nAt,4],;
	_aBrowse[_oBrowse:nAt,5],;
	_aBrowse[_oBrowse:nAt,6],;
	_aBrowse[_oBrowse:nAt,7],;
	Transform(_aBrowse[_oBrowse:nAt,8],"@E 9,999,999.99"),;
	Transform(_aBrowse[_oBrowse:nAt,9],"@E 9,999,999.99"),;
	Transform(_aBrowse[_oBrowse:nAt,10],"@E 9,999,999.99")}}

	_oBrowse:nAt := 1
	_oBrowse:Refresh()

	_oDlg:Refresh()

Return(Nil)



//Marcação do Título
Static Function Check(_aList,_oList)

	Local _nInd := 1 	// Conteudo de retorno

	_aList[_oList:nAt][1] := !_aList[_oList:nAt][1]

	_oBrowse:Refresh()
	_oDlg:Refresh()

Return(Nil)



//Marcação de todos os Cheques
Static Function MarkAll(_aList,_oList)

	Local _nInd		:= 1 	// Conteudo de retorno
	Local _lMark	:= !_aList[_oList:nAt][1]

	For _nInd := 1 To Len(_aList)
		_aList[_nInd][1] := _lMark
	Next

	_oBrowse:Refresh()
	_oDlg:Refresh()

Return(Nil)





Static Function Calcular()

	Local _nInd		:= 1 	// Conteudo de retorno

	For _nInd := 1 To Len(_aBrowse)
		If _aBrowse[_nInd][1]
			_aBrowse[_nInd][9] := _aBrowse[_nInd][8] + (_aBrowse[_nInd][8] * (_nPerc / 100))
			_aBrowse[_nInd][10]:= _aBrowse[_nInd][9] - _aBrowse[_nInd][8]
		Endif
	Next

	_oBrowse:Refresh()
	_oDlg:Refresh()

Return(Nil)
