#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'

#Define Verde "#9AFF9A"
#Define Amarelo_Escuro "#8B6914"
#Define Amarelo_Ouro "#FFD700"
#Define Amarelo "#FFFF00"
#Define Amarelo_Claro "#F0E68C"
#Define Vermelho "#FF0000"
#Define Salmao "#FF8C69"
#Define Branco "#FFFAFA"
#Define Azul "#87CEEB"
#Define Preto "#000000"
#Define Cinza "#696969"
#Define Cinza_Medio "#BDBDBD"
#Define Cinza_Claro "#F2F2F2"
#Define Cinza_Escuro "#4c4c4c"
#Define Verde_Escuro "#006400"
#Define Azul_Escuro "#191970"
#Define Vermelho_Escuro "#8B0000"
#Define Chocolate "#FF7F24"
#Define Roxo "#912CEE"
#Define Roxo_Escuro "#551A8B"
#Define Laranja "#FFA500"

/*/{Protheus.doc} MZ0241
//Cópia da Tabela de Preço
@author Fabiano
@since 30/01/2019
/*/
User Function MZ0241()

	//	If !U_ChkAcesso("MZ0241",6,.T.)
	//		Return(Nil)
	//	Endif

	Private _oDlg

	Private _cClieOri	:= Space(TAMSX3("A1_COD")[1])
	Private _cLojaOri	:= Space(TAMSX3("A1_LOJA")[1])
	Private _cNomeOri	:= Space(TAMSX3("A1_NOME")[1])
	Private _cProdOri	:= Space(TAMSX3("B1_COD")[1])
	Private _cDescOri	:= Space(TAMSX3("B1_DESC")[1])

	Private _cClieDe	:= Space(TAMSX3("A1_COD")[1])
	Private _cClieAte	:= Replicate('Z',TAMSX3("A1_COD")[1])

	Private _cLojaDe	:= Space(TAMSX3("A1_LOJA")[1])
	Private _cLojaAte	:= Replicate('Z',TAMSX3("A1_LOJA")[1])

	Private _cUF		:= Space(50)

	Private _CProdDes	:= Space(TAMSX3("B1_COD")[1])
	Private _cDescDes	:= Space(TAMSX3("B1_DESC")[1])
	
	Private _oBrowse:= Nil
	//	Private __aBrows1:= {{.F.,'','','','','','','',cTod(''),cTod(''),0,0,'','',0}}
	Private _aBrows1:= {}

	Private _oOK	:= LoadBitmap(GetResources(),'LBOK')
	Private _oNO	:= LoadBitmap(GetResources(),'LBNO')

	Private _oTFont1		:= TFont():New('Courier new',,-14,,.T.,,,,,.T.)
	Private _oTFont2		:= TFont():New('Calibri',,-14,,.T.,,,,,.F.)
	Private _oFont1 		:= TFont():New('Arial',,-12,,.T.,,,,,.F.)

	Private _cStGrp	:= "QGroupBox {"+;
	"background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #E0E0E0, stop: 1 #FFFFFF);"+;
	"border: 2px solid gray;"+;
	"border-radius: 5px;"+;
	"margin-top: 1ex; "+;
	"}"+;
	"QGroupBox::title {"+;
	"subcontrol-origin: margin;"+;
	"subcontrol-position: top left; "+;
	"padding: 0 3px;"+;
	"background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,"+;
	"                              stop: 0 #FFOECE, stop: 1 #FFFFFF);"+;
	"}"

	Private _aCols		:= {}
	Private _aHeader	:= {}
	private _aCampos	:= {}
	private _aField		:= {"ZI_LIBER","ZI_DTBLOQ","ZI_YGRPPRC","ZI_PRODUTO","ZI_DESC","ZI_DESCON","ZI_PRECO",/*"ZI_DESCCID",*/"ZI_PRECOD","ZI_DESCONF","ZI_PRECOF","ZI_DTREAJ","ZI_PGER","ZI_PRCUNIT","ZI_DTVIGEN","ZI_USRINC","ZI_ITEM"}
	Private _aFldIte	:= {}




	/*
	Private _oCombo		:= Nil
	Private _cCombo		:= ''
	Private _aCombo		:= {'Cliente','Numero','Vencimento'}

	Private _oSearch	:= Nil
	Private _cSearch	:= Space(6)
	*/

	_oSize := FwDefSize():New( .F. )							// Com enchoicebar
	_oSize:AddObject( "P1", 100, 30, .T., .t. )
	_oSize:AddObject( "P2", 100, 60, .T., .t. )
	_oSize:AddObject( "P3", 100, 10, .T., .T. )
	_oSize:lProp 	:= .T.
	_oSize:lLateral := .F.  									// Calculo vertical
	_oSize:Process()

	DEFINE MSDIALOG _oDlg TITLE OemToAnsi("Copiar Tabela de Preço") FROM _oSize:aWindSize[1],_oSize:aWindSize[2] TO ;
	_oSize:aWindSize[3],_oSize:aWindSize[4] OF _oDlg PIXEL  Style DS_MODALFRAME

	_oDlg:lEscClose := .F. //Não permite fechar a janela pelo botão "ESC"

	Panel01()

	Panel02()

	Panel03()

	ACTIVATE MSDIALOG _oDlg CENTERED

Return(Nil)




Static Function Panel01()

	Local _oGroup1	:= TGroup():New(_oSize:GetDimension( "P1","LININI"),_oSize:GetDimension( "P1", "COLINI"),;
	_oSize:GetDimension( "P1", "LINEND"),_oSize:GetDimension( "P1", "COLEND" ),"Parâmetros (Origem)",_oDlg,CLR_BLUE,,.T.)

	Local _nLiI1	:= _oSize:GetDimension( "P1", "LININI" )+10
	Local _nLiF1	:= _oSize:GetDimension( "P1", "LINEND" )
	Local _nCoI1	:= _oSize:GetDimension( "P1", "COLINI" )+10
	Local _nCoF1	:= _oSize:GetDimension( "P1", "COLEND" )
	Local _nYSi1	:= _oSize:GetDimension( "P1", "YSIZE" )
	Local _oCor		:= CLR_CYAN
	Local _nTmCol	:= 50
	Local _nTamNom	:= (_nTmCol*4)

	_cStSay := GetStyle(Cinza_Escuro,Cinza_Medio,Cinza_Escuro,Branco,2)

	_nCol := _nCoI1

	_oSay1	:= TSay():New(_nLiI1,_nCol,{||' Cliente ?'},_oGroup1,,_oFont1,,,,.T.,CLR_WHITE,,50,10)
	_oSay1:SetCss(_cStSay)
	_oSay1:Refresh()
	_nCol += 52
	@ _nLiI1, _nCol  MsGet _cClieOri	F3 "SA1" Valid If(!Empty(_cClieOri),ExistCpo("SA1",_cClieOri),.T.) Picture '@!' Size _nTmCol,08 Pixel Of _oGroup1

	_nCol += _nTmCol + 15

	_oSay2	:= TSay():New(_nLiI1,_nCol,{||' Loja ?'},_oGroup1,,_oFont1,,,,.T.,CLR_WHITE,,50,10)
	_oSay2:SetCss(_cStSay)
	_oSay2:Refresh()
	_nCol += 52
	@ _nLiI1, _nCol  MsGet _cLojaOri	Valid If(!Empty(_cLojaOri),ExistCpo("SA1",_cClieOri+_cLojaOri),.T.) Picture '@!' Size _nTmCol,08 Pixel Of _oGroup1

	_nCol += _nTmCol + 15

	_oSay3	:= TSay():New(_nLiI1,_nCol,{||' Nome:'},_oGroup1,,_oFont1,,,,.T.,CLR_WHITE,,50,10)
	_oSay3:SetCss(_cStSay)
	_oSay3:Refresh()
	_nCol += 52
	@ _nLiI1, _nCol  MsGet _cNomeOri	Picture '@!' When .F. Size _nTamNom,08 Pixel Of _oGroup1

	_nLiI1 += 15
	_nCol := _nCoI1

	_oSay4	:= TSay():New(_nLiI1,_nCol,{||' Produto ?'},_oGroup1,,_oFont1,,,,.T.,CLR_WHITE,,50,10)
	_oSay4:SetCss(_cStSay)
	_oSay4:Refresh()
	_nCol += 52
	@ _nLiI1, _nCol  MsGet _cProdOri	Picture '@!' Size _nTmCol,08 Pixel Of _oGroup1

	_nCol += _nTmCol + 15

	_oSay5	:= TSay():New(_nLiI1,_nCol,{||' Descrição:'},_oGroup1,,_oFont1,,,,.T.,CLR_WHITE,,50,10)
	_oSay5:SetCss(_cStSay)
	_oSay5:Refresh()
	_nCol += 52
	@ _nLiI1, _nCol  MsGet _cDescOri	Picture '@!' When .F. Size _nTamNom+_nTmCol+50+15+2,08 Pixel Of _oGroup1

	_nLibk := _nLiI1
	_nLiI1 += 15

	AADD(_aBrows1,{})

	FOR AZ:= 1 TO Len(_aField)

		SX3->(dbSetOrder(2))
		If SX3->(MsSeek(_aField[AZ]))

			If  X3USO(SX3->X3_USADO) .and. SX3->X3_NIVEL <= cNivel

				AaDD(_aFldIte,{aLLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO})

				AAdd(_aCampos,Alltrim(SX3->X3_TITULO))
				AAdd(_aBrows1[1],CriaVar(SX3->X3_CAMPO))

			Endif
		Endif
	Next AZ

	_oBrowse := TwBrowse():New( _nLiI1+5, _nCoI1,_nCoF1 - 20,_nYSi1-_nLibk-20,,_aCampos,,_oGroup1,,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)

	_oBrowse:SetArray(_aBrows1)

	_oBrowse:bLine := {|| SetArr(_oBrowse,_aBrows1,_aFldIte)}

Return(Nil)



Static Function SetArr(_oBrw,_aBrw,_aFld)

	Local _aRet := {}
	Local Fb	:= 0

	For Fb := 1 To Len(_aFld)
		If _aFld[Fb][2] = 'N'
			AAdd(_aRet,  Alltrim(Transform(_aBrw[_oBrw:nAT,Fb],'@E 99,999,999,999.9999')))
		Else
			AAdd(_aRet, _aBrw[_oBrw:nAt,Fb])
		Endif
	Next Fb

Return(_aRet)



Static Function Panel02()

	Local _oGroup2	:= TGroup():New(_oSize:GetDimension( "P2","LININI"),_oSize:GetDimension( "P2", "COLINI"),;
	_oSize:GetDimension( "P2", "LINEND"),_oSize:GetDimension( "P2", "COLEND" ),"Parâmetros (Destino)",_oDlg,CLR_BLUE,,.T.)

	Local _nLiI2	:= _oSize:GetDimension( "P2", "LININI" )+10
	Local _nLiF2	:= _oSize:GetDimension( "P2", "LINEND" )
	Local _nCoI2	:= _oSize:GetDimension( "P2", "COLINI" )+10
	Local _nCoF2	:= _oSize:GetDimension( "P2", "COLEND" )
	Local _nYSi2	:= _oSize:GetDimension( "P2", "YSIZE" )
	Local _nTmCol	:= 50
	Local _nTamNom	:= (_nTmCol*4)

	_cStSay := GetStyle(Cinza_Escuro,Cinza_Medio,Cinza_Escuro,Branco,2)

	_nCol := _nCoI2

	_oSay1	:= TSay():New(_nLiI2,_nCol,{||' Cliente De ?'},_oGroup2,,_oFont1,,,,.T.,CLR_WHITE,,50,10)
	_oSay1:SetCss(_cStSay)
	_oSay1:Refresh()
	@ _nLiI2, _nCol+ 52  MsGet _cClieDe	F3 "SA1"  Picture '@!' Size _nTmCol,08 Pixel Of _oGroup2

	_oSay1	:= TSay():New(_nLiI2+15,_nCol,{||' Cliente Até ?'},_oGroup2,,_oFont1,,,,.T.,CLR_WHITE,,50,10)
	_oSay1:SetCss(_cStSay)
	_oSay1:Refresh()

	@ _nLiI2+15, _nCol+52  MsGet _cClieAte	F3 "SA1"  Picture '@!' Size _nTmCol,08 Pixel Of _oGroup2

	_nCol += _nTmCol + 15
	_nCol += 52

	_oSay2	:= TSay():New(_nLiI2,_nCol,{||' Loja De ?'},_oGroup2,,_oFont1,,,,.T.,CLR_WHITE,,50,10)
	_oSay2:SetCss(_cStSay)
	_oSay2:Refresh()
	@ _nLiI2, _nCol+52  MsGet _cLojaDe	 Picture '@!' Size _nTmCol,08 Pixel Of _oGroup2

	_oSay2	:= TSay():New(_nLiI2+15,_nCol,{||' Loja Até ?'},_oGroup2,,_oFont1,,,,.T.,CLR_WHITE,,50,10)
	_oSay2:SetCss(_cStSay)
	_oSay2:Refresh()
	@ _nLiI2+15, _nCol+52  MsGet _cLojaAte	 Picture '@!' Size _nTmCol,08 Pixel Of _oGroup2

	_nCol += _nTmCol + 15
	_nCol += 52

	_oSay2	:= TSay():New(_nLiI2,_nCol,{||' UF ?'},_oGroup2,,_oFont1,,,,.T.,CLR_WHITE,,50,10)
	_oSay2:SetCss(_cStSay)
	_oSay2:Refresh()
	@ _nLiI2, _nCol+52  MsGet _cUF	 Valid U_MZ0239('12','Unidade Federativa',.F.) Size (_nTmCol*5),08 Pixel Of _oGroup2

	_oSay2	:= TSay():New(_nLiI2+15,_nCol,{||' Produto:'},_oGroup2,,_oFont1,,,,.T.,CLR_WHITE,,50,10)
	_oSay2:SetCss(_cStSay)
	_oSay2:Refresh()
	@ _nLiI2+15, _nCol+52  MsGet _cProdDes	 Picture '@!' Size _nTmCol,08 Pixel Of _oGroup2
	_nCol += (_nTmCol+2)
	@ _nLiI2+15, _nCol+52 MsGet _cDescDes	Picture '@!' When .F. Size (_nTmCol*4)-2,08 Pixel Of _oGroup2

	_nCol += _nTmCol + 15
	_nCol += 52

	_nLibk := _nLiI2
	_nLiI2 += 30

	//	AADD(_aBrows1,{})
	//
	//	FOR AZ:= 1 TO Len(_aField)
	//
	//		SX3->(dbSetOrder(2))
	//		If SX3->(MsSeek(_aField[AZ]))
	//
	//			If  X3USO(SX3->X3_USADO) .and. SX3->X3_NIVEL <= cNivel
	//
	//				AaDD(_aFldIte,{aLLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO})
	//
	//				AAdd(_aCampos,Alltrim(SX3->X3_TITULO))
	//				AAdd(_aBrows1[1],CriaVar(SX3->X3_CAMPO))
	//
	//			Endif
	//		Endif
	//	Next AZ

	_oBrowse := TwBrowse():New( _nLiI2+5, _nCoI2,_nCoF2 - 20,_nYSi2-40,,_aCampos,,_oGroup2,,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)

	_oBrowse:SetArray(_aBrows1)

	_oBrowse:bLine := {|| SetArr(_oBrowse,_aBrows1,_aFldIte)}

Return(Nil)



Static Function Panel03()

	Local _nTmBut		:= 60

	_oGroup3 := TGroup():New(_oSize:GetDimension( "P3","LININI"),_oSize:GetDimension( "P3", "COLINI"),;
	_oSize:GetDimension( "P3", "LINEND"),_oSize:GetDimension( "P3", "COLEND" ),"Ações",_oDlg,CLR_BLUE,,.T.)

	_oGroup3:SetCss(_cStGrp)
	_oGroup3:Refresh()

	_nLiI3 := _oSize:GetDimension( "P3", "LININI" )+10
	_nCoI3 := _oSize:GetDimension( "P3", "COLINI" )
	_nLiF3 := _oSize:GetDimension( "P3", "LINEND" )
	_nCoF3 := _oSize:GetDimension( "P3", "COLEND" )
	_nYSi3 := _oSize:GetDimension( "P3", "YSIZE" )


	_oTBut1	:= TButton():New( _nLiI3, _nCoI3+50, "Sair" ,_oGroup3,{||_oDlg:End()},_nTmBut,15,,_oTFont1,.F.,.T.,.F.,,.F.,,,.F. )
	_oTBut1 :cTooltip = "Fechar"
	_cStyle := GetStyle(Preto,Branco,Cinza,Amarelo)
	_oTBut1:SetCss(_cStyle)


	_oTBut2	:= TButton():New( _nLiI3, _nLiF3 - _nTmBut - _nCoI3, "Copiar" ,_oDlg,{||Histor()},_nTmBut,15,,_oTFont1,.F.,.T.,.F.,,.F.,,,.F. )
	_oTBut2 :cTooltip = "Alterar Histórico"
	_cStyle := GetStyle(Branco,Azul,Azul_Escuro,Preto)
	_oTBut2:SetCss(_cStyle)
	/*_aCampos := {'','Filial','Cliente','Loja','Prefixo','Numero','Parcela','Tipo','Emissão','Vencimento','Valor','Saldo','Situacao','Historico'}

	_oBrowse := TwBrowse():New( _nLiI3+10, _nCoI3+5,_nCoF3-13,_nYSi3-13,,_aCampos,,_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)

	_oBrowse:SetArray(__aBrows1)

	AtuGrid()

	// Troca a imagem no duplo click do mouse
	_oBrowse:bLDblClick := {|| If(!Empty(__aBrows1[_oBrowse:nAt][3]), __aBrows1[_oBrowse:nAt][1] := !__aBrows1[_oBrowse:nAt][1],Nil)}

	_oBrowse:bHeaderClick := {|o, _nCol| If(_nCol = 1,MarkAll(__aBrows1,_oBrowse),Nil) }

	_oBrowse:nAt := 1
	_oBrowse:Refresh()*/

Return(Nil)




Static Function GetStyle(_cCor1,_cCor2,_cCor3,_cCor4,_nTip)

	Local _cMod := ''
	Default _nTip := 1

	If _nTip = 1
		_cMod := "QPushButton { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+_cCor1+", stop: 1 "+_cCor2+");"
		_cMod += "border-style: outset;border-width: 2px;
		_cMod += "border-radius: 10px;border-color: "+_cCor3+";"
		_cMod += "color: "+_cCor4+"};"
		_cMod += "QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+_cCor2+", stop: 1 "+_cCor1+");"
		_cMod += "border-style: outset;border-width: 2px;"
		_cMod += "border-radius: 10px;"
		_cMod += "border-color: "+_cCor3+" }"
	Else
		_cMod := "QLabel { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+_cCor1+", stop: 1 "+_cCor2+");"
		//		_cMod += "border-style: outset;border-width: 2px;
		//		_cMod += "border-radius: 10px;border-color: "+_aCor[3]+";"
		_cMod += "color: "+_cCor4+";
		_cMod += "}"
	Endif


Return(_cMod)
