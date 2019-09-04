#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'

User Function FwDefSize()

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

	_oGroup1	:= TGroup():New(_oSize:GetDimension( "P1","LININI"),_oSize:GetDimension( "P1", "COLINI"),;
	_oSize:GetDimension( "P1", "LINEND"),_oSize:GetDimension( "P1", "COLEND" ),"Parâmetros",_oDlg,CLR_GREEN,,.T.)

	_nLiI1	:= _oSize:GetDimension( "P1", "LININI" )+5

	_oGroup2 := TGroup():New(_oSize:GetDimension( "P2","LININI"),_oSize:GetDimension( "P2", "COLINI"),;
	_oSize:GetDimension( "P2", "LINEND"),_oSize:GetDimension( "P2", "COLEND" ),"Dados para Reajuste",_oDlg,CLR_BLUE,,.T.)

	_nLiI2	:= _oSize:GetDimension( "P2", "LININI" )+5


	_oGroup3 := TGroup():New(_oSize:GetDimension( "P3","LININI"),_oSize:GetDimension( "P3", "COLINI"),;
	_oSize:GetDimension( "P3", "LINEND"),_oSize:GetDimension( "P3", "COLEND" ),"Tabelas de Preço",_oDlg,CLR_RED,,.T.)

	_nLiI3 := _oSize:GetDimension( "P3", "LININI" )
	_nCoI3 := _oSize:GetDimension( "P3", "COLINI" )
	_nLiF3 := _oSize:GetDimension( "P3", "LINEND" )
	_nCoF3 := _oSize:GetDimension( "P3", "COLEND" )
	_nYSi3 := _oSize:GetDimension( "P3", "YSIZE" )

	_aCampos := {'','Filial','Cliente','Loja','Nome','UF','Produto','Preço Atual','Preço Calculado','Diferença'}

	_oBrowse := TwBrowse():New( _nLiI3+10, _nCoI3+5,_nCoF3-13,_nYSi3-13,,_aCampos,,_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)


	_oGroup2 := TGroup():New(_oSize:GetDimension( "P4","LININI"),_oSize:GetDimension( "P4", "COLINI"),;
	_oSize:GetDimension( "P4", "LINEND"),_oSize:GetDimension( "P4", "COLEND" ),"Ações",_oDlg,CLR_MAGENTA,CLR_YELLOW,.T.)

	_nLiI4 		:= _oSize:GetDimension( "P4", "LININI" )+11
	_nColI		:= _oSize:GetDimension( "P4", "COLINI")
	_nColF		:= _oSize:GetDimension( "P4", "COLEND")
	_oTFont		:= TFont():New('Courier new',,-14,,.T.,,,,,.T.)


	ACTIVATE MSDIALOG _oDlg CENTERED

Return(Nil)