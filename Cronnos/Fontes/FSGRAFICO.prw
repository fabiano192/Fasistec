#INCLUDE "TOTVS.CH"
#INCLUDE "MSGRAPHI.CH"

/*/{Protheus.doc} FSGRAFICO
Criação de Gráfico
@type function
@author Fabiano
@since 14/06/2016
@version 1.0
@param _cTit, ${Caracter}, Título do Gráfico
@param _aDados, ${Array}, Dados do Gráfico, sendo um array, contendo o valor e o título, exemplo {{100,'Item01},{200,'Item02}...}
@param _cFonte, ${Caracter}, Nome do Fonte que está chamando o gráfico
/*/

User Function FSGRAFICO(_cTit,_aDados,_cFonte)

	/*
	Local _oSize

	Private _nTipo 		:= GRP_LINE//GRP_PIE
	Private _nSerie		:= Nil
	Private _oDlg		:= Nil
	Private _oGraphic	:= Nil
	Private _l3D	 	:= .F.

	Default _cTit 		:= "Gráfico"
	Default _cFonte		:= "TMSGraphic"
	Default _aDados		:= {}

	Private _aCor		:= {}

	If Len(_aDados) > 15
	MsgAlert('Na impressão do Gráfico só pode conter 15 séries!')
	Return(Nil)
	Endif

	AADD(_aCor,CLR_BLUE)
	AADD(_aCor,CLR_YELLOW)
	AADD(_aCor,CLR_CYAN)
	AADD(_aCor,CLR_GRAY)
	AADD(_aCor,CLR_MAGENTA)
	AADD(_aCor,CLR_HRED)
	AADD(_aCor,CLR_HMAGENTA)
	AADD(_aCor,CLR_BROWN)
	AADD(_aCor,CLR_GREEN)
	AADD(_aCor,CLR_HGRAY)
	AADD(_aCor,CLR_HCYAN)
	AADD(_aCor,CLR_WHITE)
	AADD(_aCor,CLR_HGREEN)
	AADD(_aCor,CLR_RED)
	AADD(_aCor,CLR_HBLUE)


	//	AADD(_aDados,{200,"Item 01"})
	//	AADD(_aDados,{350,"Item 02"})
	//	AADD(_aDados,{100,"Item 03"})
	//	AADD(_aDados,{090,"Item 04"})
	//	AADD(_aDados,{160,"Item 05"})
	//	AADD(_aDados,{020,"Item 06"})
	//	AADD(_aDados,{460,"Item 07"})

	// Calcula as dimensoes dos objetos
	_oSize := FwDefSize():New( .T. ) // Com enchoicebar
	_oSize:lLateral     := .F.  // Calculo vertical

	// Dispara o calculo
	_oSize:Process()

	DEFINE DIALOG _oDlg TITLE _cFonte FROM _oSize:aWindSize[1],_oSize:aWindSize[2] TO _oSize:aWindSize[3],_oSize:aWindSize[4] PIXEL

	// Cria o gráfico
	_oGraphic := TMSGraphic():New( 15,01,_oDlg,,,,260,184)
	//	_oGraphic:Hide()
	_oGraphic:SetTitle(_cTit, "Data:" + dtoc(Date()), CLR_BLACK, A_LEFTJUST, GRP_TITLE )
	//	_oGraphic:SetLegenProp(GRP_SCRRIGHT, CLR_LIGHTGRAY, GRP_AUTO, .T.)
	_oGraphic:SetMargins(6,6,6,6)
	_oGraphic:Align := CONTROL_ALIGN_ALLCLIENT

	// Itens do Gráfico
	_nSerie := _oGraphic:CreateSerie( _nTipo )

	_oGraphic:l3D   := _l3D

	For F:= 1 To Len(_aDados)
	If _nTipo = GRP_PIE
	_cCor := _aCor[F]
	Else
	If Len(_aDados[F]) = 3
	_cCor := _aDados[F][3]
	Else
	_cCor := CLR_HBLUE
	Endif
	Endif
	_oGraphic:Add(_nSerie, _aDados[F][1], _aDados[F][2], _cCor)
	Next F

	_oGraphic:Show()

	ACTIVATE DIALOG _oDlg CENTERED ON INIT (MenuGraph(_oDlg,_aDados,_cTit))

	Return


	Static Function MenuGraph(_oDlg,_aDados,_cTit)

	Local _oMenu

	_oMenu := TBar():New( _oDlg,25,32,.T.,,,,.F. )

	DEFINE BUTTON RESOURCE "S4WB008N"		OF _oMenu	ACTION Calculadora()				   																PROMPT " "	TOOLTIP "Calculadora" //
	DEFINE BUTTON RESOURCE "PMSPRINT"    	OF _oMenu	ACTION (PrintGraph(),_oDlg:End())          															PROMPT " "	TOOLTIP "Imprimir" //
	DEFINE BUTTON RESOURCE "NG_ICO_PONTOS"	OF _oMenu	ACTION Processa({ || CreateSerie(_oDlg,GRP_POINT,_aDados,_cTit,_l3D)})								PROMPT " " 	TOOLTIP "Pontos" //
	DEFINE BUTTON RESOURCE "S4WB013N"    	OF _oMenu	ACTION Processa({ || CreateSerie(_oDlg,GRP_PIE	,_aDados,_cTit,_l3D)})								PROMPT " "	TOOLTIP "Pizza" //
	DEFINE BUTTON RESOURCE "BAR"		  	OF _oMenu	ACTION Processa({ || CreateSerie(_oDlg,GRP_BAR	,_aDados,_cTit,_l3D)})								PROMPT " " 	TOOLTIP "Barra" //
	DEFINE BUTTON RESOURCE "LINE"			OF _oMenu	ACTION Processa({ || CreateSerie(_oDlg,GRP_LINE	,_aDados,_cTit,_l3D)})								PROMPT " "  TOOLTIP "Linha" //
	DEFINE BUTTON RESOURCE "GRAF3D"	    	OF _oMenu	ACTION Processa({ || CreateSerie(_oDlg,_nTipo	,_aDados,_cTit,!_l3D)}) WHEN _nTipo != GRP_POINT	PROMPT " "	TOOLTIP "3D"
	DEFINE BUTTON RESOURCE "FINAL"	    	OF _oMenu	ACTION _oDlg:End() 																					PROMPT " "	TOOLTIP "Sair"

	Return


	Static Function CreateSerie(_oDlg,_nType,_aDados,_cTit,_lChange3D)

	_l3D := _lChange3D

	FreeObj(_oGraphic) //Exclui o objeto anterior

	RELEASE OBJECTS _oGraphic

	_nTipo := _nType

	_oGraphic := TMSGraphic():New( 01,01,_oDlg,,,,260,184)
	//	_oGraphic:Hide()
	_oGraphic:SetMargins(6,6,6,6)
	_oGraphic:Align := CONTROL_ALIGN_ALLCLIENT

	_oGraphic:SetTitle(_cTit, "Data:" + dtoc(Date()), CLR_BLACK, A_LEFTJUST, GRP_TITLE )

	_nSerie   := _oGraphic:CreateSerie(_nType)

	_oGraphic:l3D   := _l3D

	For F:= 1 To Len(_aDados)
	If _nType = GRP_PIE
	_cCor := _aCor[F]
	Else
	If Len(_aDados[F]) = 3
	_cCor := _aDados[F][3]
	Else
	_cCor := CLR_HBLUE
	Endif
	Endif
	_oGraphic:Add(_nSerie, _aDados[F][1], _aDados[F][2], _cCor)
	Next F

	_oGraphic:Show()
	Return


	Static Function PrintGraph()

	_oGraphic:Refresh()

	_oGraphic:SaveToImage( "imagem.png", "\spool\", "PNG" )

	// Salva o conteúdo da imagem
	cFile := "\spool\imagem.png"

	// Monta objeto para impressão
	oPrint := TMSPrinter():New("How to")
	oPrint:SetLandscape()
	oPrint:StartPage()

	// Insere imagem no relatório
	oPrint:SayBitmap( 20,10,cFile,3200,1700 )

	// Exibe preview
	oPrint:EndPage()
	oPrint:Preview()

	Return

	*/




	Local oChart
	Local oDlg      

	DEFINE MSDIALOG oDlg PIXEL FROM 10,0 TO 600,600

	oChart := FWChartBarComp():New()

	oChart:init( oDlg, .t. ) 
	oChart:addSerie( "Votos PT", { {"Jan",50}, {"Fev",55}, {"Mar",60} })
	oChart:addSerie( "Votos PMDB", { {"Jan",30}, {"Fev",35}, {"Mar",40} } )
	oChart:addSerie( "Votos PV", { {"Jan",20}, {"Fev",10}, {"Mar",10} } ) 
	oChart:setLegend( CONTROL_ALIGN_LEFT ) 
	oChart:Build()
	ACTIVATE MSDIALOG oDlg

Return