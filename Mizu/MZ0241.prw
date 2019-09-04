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
#Define Mizu "#E8782F"

/*/{Protheus.doc} MZ0241
//Cópia da Tabela de Preço
@author Fabiano
@since 30/01/2019
/*/
User Function MZ0241()

	If !U_ChkAcesso("MZ0241",6,.T.)
		Return(Nil)
	Endif

	Private _oDlg

	Private _cClieOri	:= Space(TAMSX3("A1_COD")[1])
	Private _cLojaOri	:= Space(TAMSX3("A1_LOJA")[1])
	Private _cNomeOri	:= Space(TAMSX3("A1_NOME")[1])
	Private _oNomeOri	:= Nil

	Private _cProdOri	:= Space(TAMSX3("B1_COD")[1])
	Private _cDescOri	:= Space(TAMSX3("B1_DESC")[1])
	Private _oDescOri	:= Nil

	Private _cClieDe	:= Space(TAMSX3("A1_COD")[1])
	Private _cClieAte	:= Replicate('Z',TAMSX3("A1_COD")[1])

	Private _cLojaDe	:= Space(TAMSX3("A1_LOJA")[1])
	Private _cLojaAte	:= Replicate('Z',TAMSX3("A1_LOJA")[1])

	Private _cUF		:= GetUF()

	Private _cProdDes	:= Space(TAMSX3("B1_COD")[1])
	Private _cDescDes	:= Space(TAMSX3("B1_DESC")[1])
	Private _oDescDes	:= Nil
	Private _oProdDes	:= Nil

	Private _oBrowse:= Nil
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

	Private _aCampos	:= {}
	Private _aField		:= {"ZI_LIBER","ZI_DESCON","ZI_PRECO","ZI_DESCONF","ZI_PRECOF","ZI_PRCUNIT","ZI_PRECOD","ZI_PGER","ZI_DTVIGEN","ZI_DTBLOQ","ZI_YGRPPRC","ZI_DTREAJ","ZI_USRINC","ZI_ITEM"}
	Private _aFldIte	:= {}

	Private _oBroCli:= Nil
	Private _aBroCli:= {}
	Private _aBroCBk:= {}

	Private _aCampCli	:= {''}
	Private _aClie		:= {"A1_COD","A1_LOJA","A1_EST","A1_NOME"}
	Private _aNClie		:= {{'','C'}}

	Private _cStSay		:= GetStyle(Branco,Amarelo_Claro,Nil,Preto,2)

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
	_oSize:GetDimension( "P1", "LINEND"),_oSize:GetDimension( "P1", "COLEND" ),"Parâmetros (Origem)",_oDlg,CLR_RED,,.T.)

	Local _nLiI1	:= _oSize:GetDimension( "P1", "LININI" )+10
	Local _nLiF1	:= _oSize:GetDimension( "P1", "LINEND" )
	Local _nCoI1	:= _oSize:GetDimension( "P1", "COLINI" )+10
	Local _nCoF1	:= _oSize:GetDimension( "P1", "COLEND" )
	Local _nYSi1	:= _oSize:GetDimension( "P1", "YSIZE" )
	Local _oCor		:= CLR_CYAN
	Local _nTmCol	:= 50
	Local _nTamNom	:= (_nTmCol*4)

	_nCol := _nCoI1

	_oSay1	:= TSay():New(_nLiI1,_nCol,{||' Cliente ?'},_oGroup1,,_oFont1,,,,.T.,CLR_WHITE,,50,10)
	_oSay1:SetCss(_cStSay)
	_oSay1:Refresh()
	_nCol += 52
	@ _nLiI1, _nCol  MsGet _cClieOri	F3 "SA1" Valid If(!Empty(_cClieOri),VldFld(_cClieOri,'SA1',1),.T.) Picture '@!' Size _nTmCol,08 Pixel Of _oGroup1

	_nCol += _nTmCol + 15

	_oSay2	:= TSay():New(_nLiI1,_nCol,{||' Loja ?'},_oGroup1,,_oFont1,,,,.T.,CLR_WHITE,,50,10)
	_oSay2:SetCss(_cStSay)
	_oSay2:Refresh()
	_nCol += 52
	@ _nLiI1, _nCol  MsGet _cLojaOri	Valid If(!Empty(_cLojaOri),VldFld(_cClieOri+_cLojaOri,'SA1',1),.T.) Picture '@!' Size _nTmCol,08 Pixel Of _oGroup1

	_nCol += _nTmCol + 15

	_oSay3	:= TSay():New(_nLiI1,_nCol,{||' Nome:'},_oGroup1,,_oFont1,,,,.T.,CLR_WHITE,,50,10)
	_oSay3:SetCss(_cStSay)
	_oSay3:Refresh()
	_nCol += 52
	@ _nLiI1, _nCol  MsGet _oNomeOri VAR _cNomeOri	Picture '@!' When .F. Size _nTamNom,08 Pixel Of _oGroup1

	_nLiI1 += 15
	_nCol := _nCoI1

	_oSay4	:= TSay():New(_nLiI1,_nCol,{||' Produto ?'},_oGroup1,,_oFont1,,,,.T.,CLR_WHITE,,50,10)
	_oSay4:SetCss(_cStSay)
	_oSay4:Refresh()
	_nCol += 52
	@ _nLiI1, _nCol  MsGet _cProdOri F3 "SB1"  Valid If(!Empty(_cProdOri),VldFld(_cProdOri,'SB1',2),.T.) Picture '@!' Size _nTmCol,08 Pixel Of _oGroup1

	_nCol += _nTmCol + 15

	_oSay5	:= TSay():New(_nLiI1,_nCol,{||' Descrição:'},_oGroup1,,_oFont1,,,,.T.,CLR_WHITE,,50,10)
	_oSay5:SetCss(_cStSay)
	_oSay5:Refresh()
	_nCol += 52
	@ _nLiI1, _nCol  MsGet _oDescOri VAR _cDescOri	Picture '@!' When .F. Size _nTamNom+_nTmCol+50+15+2,08 Pixel Of _oGroup1

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

	_oBrowse:bLine := {|| SetArr(_oBrowse,_aBrows1,_aFldIte,1)}

Return(Nil)



Static Function SetArr(_oBrw,_aBrw,_aFld,_nOpc)

	Local _aRet := {}
	Local Fb	:= 0

	For Fb := 1 To Len(_aFld)
		If _nOpc = 2 .And. Fb = 1
			AAdd(_aRet, If(_aBrw[_oBrw:nAt,1],_oOk,_oNo ))
		Else
			If _aFld[Fb][2] = 'N' 
				AAdd(_aRet,  Alltrim(Transform(_aBrw[_oBrw:nAT,Fb],'@E 99,999,999,999.9999')))
			Else
				AAdd(_aRet, _aBrw[_oBrw:nAt,Fb])
			Endif
		Endif
	Next Fb

Return(_aRet)



Static Function Panel02()

	Local _oGroup2	:= TGroup():New(_oSize:GetDimension( "P2","LININI"),_oSize:GetDimension( "P2", "COLINI"),;
	_oSize:GetDimension( "P2", "LINEND"),_oSize:GetDimension( "P2", "COLEND" ),"Parâmetros (Destino)",_oDlg,CLR_RED,,.T.)

	Local _nLiI2	:= _oSize:GetDimension( "P2", "LININI" )+10
	Local _nLiF2	:= _oSize:GetDimension( "P2", "LINEND" )
	Local _nCoI2	:= _oSize:GetDimension( "P2", "COLINI" )+10
	Local _nCoF2	:= _oSize:GetDimension( "P2", "COLEND" )
	Local _nYSi2	:= _oSize:GetDimension( "P2", "YSIZE" )
	Local _nTmCol	:= 50
	Local _nTamNom	:= (_nTmCol*4)

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

	_oSay2	:= TSay():New(_nLiI2+11,_nCol,{||' UF ?'},_oGroup2,,_oFont1,,,,.T.,CLR_WHITE,,50,10)
	_oSay2:SetCss(_cStSay)
	_oSay2:Refresh()
	@ _nLiI2+11, _nCol+52  MsGet _cUF	 Valid U_MZ0239('12','Unidade Federativa',.F.) Size (_nTmCol*5),08 Pixel Of _oGroup2

	_nCol += (52 + (_nTmCol*5)) + 10

	_oTBut1	:= TButton():New( _nLiI2, _nCol, "Consulta" ,_oGroup2,{||LjMsgRun('Consultando Clientes...','Cópia Tab. Preço',{||Consultar()})},60,30,,_oTFont1,.F.,.T.,.F.,,.F.,,,.F. )
	_oTBut1 :cTooltip = "Consulta"
	_cStyle := GetStyle(Verde,Branco,Cinza,Preto)
	_oTBut1:SetCss(_cStyle)

	_nCol += _nTmCol + 15
	_nCol += 52

	_nLibk := _nLiI2
	_nLiI2 += 30

	AADD(_aBroCli,{.F.})

	FOR AZ:= 1 TO Len(_aClie)

		SX3->(dbSetOrder(2))
		If SX3->(MsSeek(_aClie[AZ]))

			If  X3USO(SX3->X3_USADO) .and. SX3->X3_NIVEL <= cNivel

				AaDD(_aNClie,{aLLTRIM(SX3->X3_CAMPO),SX3->X3_TIPO})

				AAdd(_aCampCli,Alltrim(SX3->X3_TITULO))

				AAdd(_aBroCli[1],CriaVar(SX3->X3_CAMPO))

			Endif
		Endif
	Next AZ

	_aBroCBk := aClone(_aBroCli)

	_nLinFi := _nYSi2-70

	_oBroCli := TwBrowse():New( _nLiI2+5, _nCoI2,_nCoF2 - 20,_nLinFi,,_aCampCli,,_oGroup2,,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)

	_oBroCli:SetArray(_aBroCli)

	_oBroCli:bLine := {|| SetArr(_oBroCli,_aBroCli,_aNClie,2)}

	_oBroCli:bLDblClick := {|| If(!Empty(_aBroCli[_oBroCli:nAt][3]), _aBroCli[_oBroCli:nAt][1] := !_aBroCli[_oBroCli:nAt][1],Nil)}

	_oBroCli:bHeaderClick := {|o, _nCol| If(_nCol = 1,MarkAll(_aBroCli,_oBroCli),Nil) }

	_nLiF2 -= 18

	_oSay2	:= TSay():New(_nLiF2,_nCoI2,{||' Produto:'},_oGroup2,,_oFont1,,,,.T.,CLR_WHITE,,50,10)
	_oSay2:SetCss(_cStSay)
	_oSay2:Refresh()

	@ _nLiF2, _nCoI2+52  MsGet _oProdDes VAR _cProdDes	F3 "SB1" Valid If(!Empty(_cProdDes),VldFld(_cProdDes,'SB1',3),.T.) Picture '@!' Size _nTmCol,08 Pixel Of _oGroup2
	_nCoI2 += (_nTmCol+2)

	@ _nLiF2, _nCoI2+52 MsGet _oDescDes VAR _cDescDes	Picture '@!' When .F. Size (_nTmCol*4)-2,08 Pixel Of _oGroup2

Return(Nil)



//Marcação de todos os Cheques
Static Function MarkAll(_aBroCli,_oBroCli)

	Local _nInd		:= 1 	// Conteudo de retorno
	Local _lMark	:= !_aBroCli[_oBroCli:nAt][1]

	For _nInd := 1 To Len(_aBroCli)
		_aBroCli[_nInd][1] := _lMark
	Next

	_oBroCli:Refresh()
	_oDlg:Refresh()

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

	_oTBut1	:= TButton():New( _nLiI3, _nCoI3+100, "Sair" ,_oGroup3,{||_oDlg:End()},_nTmBut,15,,_oTFont1,.F.,.T.,.F.,,.F.,,,.F. )
	_oTBut1 :cTooltip = "Fechar"
	_cStyle := GetStyle(Preto,Branco,Cinza,Amarelo)
	_oTBut1:SetCss(_cStyle)

	_oTBut2	:= TButton():New( _nLiI3, _nCoF3 - 100 - _nTmBut, "Copiar" ,_oDlg,{||LjMsgRun('Copiando registros...','Cópia Tab. Preço',{||Copiar()})},_nTmBut,15,,_oTFont1,.F.,.T.,.F.,,.F.,,,.F. )
	_oTBut2 :cTooltip = "Copiar Tabela de Preço"
	//	_cStyle := GetStyle(Branco,Salmao,Vermelho_Escuro,Preto)
	_cStyle := GetStyle(Branco,Mizu,Cinza,Preto)
	_oTBut2:SetCss(_cStyle)

Return(Nil)



Static Function GetUF()

	Local _cTable := "12"
	Local _cEst   := ""

	If SX5->(MsSeek(xFilial("SX5")+_cTable))

		While SX5->(!Eof()) .AND. SX5->X5_FILIAL == XFilial("SX5") .AND. SX5->X5_Tabela == _cTable

			_cEst += Alltrim(SX5->X5_CHAVE)

			SX5->(dbSkip())
		Enddo
	Endif

Return(_cEst)



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
		_cMod += "color: "+_cCor4+";
		_cMod += "}"
	Endif

Return(_cMod)



Static Function VldFld(_cVar,_cTab,_cOpt)

	Local _lRet		:= .T.
	Local _Area		:= (_cTab)->(GetArea())

	(_cTab)->(dbSetorder(1))
	If !(_cTab)->(MsSeek(xFilial(_cTab)+_cVar))
		ShowHelpDlg('MZ0241_2',{'Registro não encontrado.'},1,{'Digite um código válido.'},2)
		//		ExistCpo(_cTab,_cVar)
		_lRet := .F.
	Else
		If _cTab = "SA1"
			_cNomeOri := SA1->A1_NOME
			_oNomeOri:Refresh()
		ElseIf _cTab = "SB1" .And. _cOpt = 2
			_cDescOri := SB1->B1_DESC
			_oDescOri:Refresh()
		ElseIf _cTab = "SB1" .And. _cOpt = 3
			If _cProdDes = _cProdOri
				_cProdDes := Space(TAMSX3("B1_COD")[1])
				_cDescDes := Space(TAMSX3("B1_DESC")[1])
				ShowHelpDlg('MZ0241_6',{'Produto de Destino não pode ser igual ao produto de Origem.'},1,{'Digite um produto válido.'},2)
			Else
				_cDescDes := SB1->B1_DESC
			Endif

			_oDescDes:Refresh()
			_oProdDes:Refresh()
		Endif
	Endif

	If !Empty(_cClieOri) .And. !Empty(_cLojaOri) .And. !Empty(_cProdOri) .And. _lRet
		_lRet := GetTab(_cClieOri,_cLojaOri,_cProdOri)

		If !_lRet
			ShowHelpDlg('MZ0241_1',{'Não encontrado Tabela de Preço para os parâmetros informados.'},1,{'Valide os parâmetros digitados.'},2)
		Endif
	Endif

	RestArea(_Area)

Return(_lRet)



Static Function GetTab(_cClieOri,_cLojaOri,_cProdOri)

	Local _lTab := .F.
	Local _cQry := ''
	Local _nTSZI:= 0

	If Select("TSZI") > 0
		TSZI->(dbCloseArea())
	Endif

	_cQry += " SELECT "
	For _nF := 1 To Len(_aFldIte)
		_cQry += _aFldIte[_nF][1]+If(_nF < Len(_aFldIte),", ","")
	Next _nF
	_cQry += " FROM "+RetSqlName("SZI")+" ZI " +CRLF
	_cQry += " WHERE ZI.D_E_L_E_T_ = '' AND ZI_FILIAL = '"+xFilial("SZI")+"' " +CRLF
	_cQry += " AND ZI_CLIENTE = '"+_cClieOri+"' " +CRLF
	_cQry += " AND ZI_LOJA = '"+_cLojaOri+"' " +CRLF
	_cQry += " AND ZI_PRODUTO = '"+_cProdOri+"' " +CRLF
	_cQry += " AND ZI_LIBER = 'L' " +CRLF

	TcQuery _cQry New Alias "TSZI"

	Count to _nTSZI

	If _nTSZI > 0

		For Fb := 1 To Len(_aFldIte)
			If _aFldIte[Fb][2] = 'D'
				TcSetField("TSZI", _aFldIte[Fb][1],"D")
			Endif
		Next Fb

		TSZI->(dbGotop())

		_aBrows1 := {}

		While TSZI->(!EOF())

			AAdd(_aBrows1,{})

			_nPos := Len(_aBrows1)

			For _nF := 1 To Len(_aFldIte)
				AAdd(_aBrows1[_nPos],&("TSZI->"+_aFldIte[_nF][1]))
			Next _nF

			_lTab := .T.

			TSZI->(dbSkip())
		EndDo

		_oBrowse:SetArray(_aBrows1)

		_oBrowse:bLine := {|| SetArr(_oBrowse,_aBrows1,_aFldIte,1)}

		_oBrowse:Refresh()
		_oDlg:Refresh()

	Endif

	TSZI->(dbCloseArea())

Return(_lTab)




Static Function Consultar()

	Local _lTab := .F.
	Local _cQry := ''
	Local _nTSA1:= 0
	Local _cEst	:= "('"

	For _e := 1 to Len(_cUF) Step 2
		_cEst += Substr(_cUF,_e,2)+"','"
	Next _e

	_cEst := Left(_cEst,Len(_cEst)-2)+")"

	If Select("TSA1") > 0
		TSA1->(dbCloseArea())
	Endif

	_cQry += " SELECT "
	For _nF := 2 To Len(_aNClie)
		_cQry += _aNClie[_nF][1]+If(_nF < Len(_aNClie),", ","")
	Next _nF
	_cQry += " FROM "+RetSqlName("SA1")+" A1 " +CRLF
	_cQry += " WHERE A1.D_E_L_E_T_ = '' AND A1_FILIAL = '"+xFilial("SA1")+"' " +CRLF
	_cQry += " AND A1_COD BETWEEN '"+_cClieDe+"' AND '"+_cClieAte+"' " +CRLF
	_cQry += " AND A1_LOJA BETWEEN '"+_cLojaDe+"' AND '"+_cLojaAte+"' " +CRLF
	_cQry += " AND A1_EST IN "+_cEst+" " +CRLF
	_cQry += " ORDER BY A1_COD,A1_LOJA

	TcQuery _cQry New Alias "TSA1"

	Count to _nTSA1

	If _nTSA1 > 0

		For Fb := 1 To Len(_aNClie)
			If _aNClie[Fb][2] = 'D'
				TcSetField("TSA1", _aNClie[Fb][1],"D")
			Endif
		Next Fb

		TSA1->(dbGotop())

		_aBroCli := {}

		While TSA1->(!EOF())

			AAdd(_aBroCli,{})

			_nPos := Len(_aBroCli)

			AAdd(_aBroCli[_nPos],.T.) 

			For _nF := 2 To Len(_aNClie)
				AAdd(_aBroCli[_nPos],&("TSA1->"+_aNClie[_nF][1]))
			Next _nF

			_lTab := .T.

			TSA1->(dbSkip())
		EndDo

		_oBroCli:SetArray(_aBroCli)

		_oBroCli:bLine := {|| SetArr(_oBroCli,_aBroCli,_aNClie,2)}

		_oBroCli:Refresh()
		_oDlg:Refresh()

	Endif

	TSA1->(dbCloseArea())

Return(_lTab)




Static Function Copiar()

	Local _lPar := .F.
	Local _lCli := .F.

	//	If Empty(_cClieOri) .Or. _aBrows1(_cLojaOri) .Or. Empty(_cProdOri)
	For _a := 1 To Len(_aBroCli)
		If _aBrows1[_a][1] = 'L'
			_lPar := .T.
			Exit
		Endif
	Next _a

	If !_lPar
		ShowHelpDlg('MZ0241_3',{'Parâmetros de Origem não preenchidos.'},1,{'Preencha os parâmetros de Origem.'},2)
		Return(Nil)
	Endif
	//	Endif

	If Empty(_cProdDes)
		ShowHelpDlg('MZ0241_4',{'Produto destino não foi preenchido.'},1,{'Preencha o Produto Destino.'},2)		
		Return(Nil)
	Endif


	For _a := 1 To Len(_aBroCli)
		If _aBroCli[_a][1]
			_lCli := .T.
			Exit
		Endif
	Next _a

	If !_lCli
		ShowHelpDlg('MZ0241_5',{'Parâmetros de Destino não preenchidos ou nenhum Cliente marcado.'},1,{'Preencha os parâmetros de Destino.'},2)
		Return(Nil)
	Endif

	For _o := 1 To Len(_aBroCli)
		If _aBroCli[_o][1]
			For _i := 1 TO Len(_aBrows1)

				SZI->(dbSetOrder(1))
				If !SZI->(msSeek(xFilial("SZI")+ _aBroCli[_o][2]+_aBroCli[_o][3]+_cProdDes+'L'))

					SZI->(RecLock("SZI",.T.))
					For _u := 1 to Len(_aFldIte)
						&('SZI->'+_aFldIte[_u][1]) := _aBrows1[_i][_u]
					Next _u
					SZI->ZI_FILIAL	:= xFilial("SZI")
					SZI->ZI_CLIENTE	:= _aBroCli[_o][2]
					SZI->ZI_LOJA	:= _aBroCli[_o][3]
					SZI->ZI_PRODUTO	:= _cProdDes
					SZI->ZI_DESC	:= _cDescDes
					SZI->ZI_USRINC	:= cUsername
					SZI->ZI_USRLIB	:= 'MZ0241'
					SZI->(MsUnLock())
				Else
					ShowHelpDlg('MZ0241_7',{'Cadastro já existe na tabela de preço.','','Cliente/Loja: '+_aBroCli[_o][2]+'/'+_aBroCli[_o][3]},3,{'Não se aplica.'},1)
					Return(Nil)
				Endif
			Next _i
		Endif
	Next _o

	_aBroCli := aClone(_aBroCBk)

	_oBroCli:SetArray(_aBroCli)

	_oBroCli:bLine := {|| SetArr(_oBroCli,_aBroCli,_aNClie,2)}

	_oBroCli:Refresh()

	MsgInfo('Cópia realizada com sucesso!')

	_oDlg:Refresh()

Return(Nil)