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

/*/{Protheus.doc} MZ0240
//Alteração de Histórico e Transferência de carteira
@author Fabiano
@since 19/12/2018
/*/
User Function MZ0240()

	//	If !U_ChkAcesso("MZ0240",6,.T.)
	//		Return(Nil)
	//	Endif

	Private _oDlg

	Private _cFilDe := cFilAnt
	Private _cFilAt := cFilAnt

	Private _cCliDe := Space(TAMSX3("A1_COD")[1])
	Private _cCliAt := Replicate('Z',TAMSX3("A1_COD")[1])

	Private _cLojDe := Space(TAMSX3("A1_LOJA")[1])
	Private _cLojAt := Replicate('Z',TAMSX3("A1_LOJA")[1])

	Private _cTitDe := Space(TAMSX3("E1_NUM")[1])
	Private _cTitAt := Replicate('Z',TAMSX3("E1_NUM")[1])

	Private _dVenDe := Firstday(dDatabase)
	Private _dVenAt := Lastday(dDatabase)

	Private _cSit   := Space(20)

	Private _oBrowse:= Nil
	Private _aBrowse:= {{.F.,'','','','','','','',cTod(''),cTod(''),0,0,'','',0}}

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

	Private _oCombo		:= Nil
	Private _cCombo		:= ''
	Private _aCombo		:= {'Cliente','Numero','Vencimento'}

	Private _oSearch	:= Nil
	Private _cSearch	:= Space(6)


	_oSize := FwDefSize():New( .F. )							// Com enchoicebar
	_oSize:AddObject( "P1", 100, 08, .T., .t. )
	_oSize:AddObject( "P2", 100, 15, .T., .t. )
	_oSize:AddObject( "P4", 100, 07, .T., .t. )
	_oSize:AddObject( "P3", 100, 70, .T., .T. )
	_oSize:lProp 	:= .T.
	_oSize:lLateral := .F.  									// Calculo vertical
	_oSize:Process()

	DEFINE MSDIALOG _oDlg TITLE OemToAnsi("Ajuste Histórico/Situação de Cobrança") FROM _oSize:aWindSize[1],_oSize:aWindSize[2] TO ;
	_oSize:aWindSize[3],_oSize:aWindSize[4] OF _oDlg PIXEL  Style DS_MODALFRAME

	_oDlg:lEscClose := .F. //Não permite fechar a janela pelo botão "ESC"

	Panel01()

	Panel02()

	Panel04()

	Panel03()

	ACTIVATE MSDIALOG _oDlg CENTERED

Return(Nil)



Static Function Panel01()

	Local _oGroup1	:= TGroup():New(_oSize:GetDimension( "P1","LININI"),_oSize:GetDimension( "P1", "COLINI"),;
	_oSize:GetDimension( "P1", "LINEND"),_oSize:GetDimension( "P1", "COLEND" ),"Ações",_oDlg,CLR_BLUE,,.T.)

	Local _nLiI1	:= _oSize:GetDimension( "P1", "LININI" )+5
	Local _nColI	:= 30
	Local _nColF	:= _oSize:GetDimension( "P1", "COLEND" )
	Local _oCor		:= CLR_CYAN
	Local _nTmBut		:= 60

	_oGroup1:SetCss(_cStGrp)
	_oGroup1:Refresh()

	_nCol := _nColI

	_oTBut2	:= TButton():New( _nLiI1, _nCol, "Histórico" ,_oDlg,{||Histor()},_nTmBut,15,,_oTFont1,.F.,.T.,.F.,,.F.,,,.F. )
	_oTBut2 :cTooltip = "Alterar Histórico"
	_cStyle := GetStyle(Branco,Verde,Verde_Escuro,Preto)
	_oTBut2:SetCss(_cStyle)

	_nCol += 100

	_oTBut3	:= TButton():New( _nLiI1, _nCol, "Situação" ,_oDlg,{||Situac()},_nTmBut,15,,_oTFont1,.F.,.T.,.F.,,.F.,,,.F. )
	_oTBut3 :cTooltip = "Alterar Situaçao"
	_cStyle := GetStyle(Branco,Azul,Azul_Escuro,Preto)
	_oTBut3:SetCss(_cStyle)

	_nCol += 100

	_oTBut1	:= TButton():New( _nLiI1, _nColF - _nTmBut - _nColI, "Sair" ,_oDlg,{||_oDlg:End()},_nTmBut,15,,_oTFont1,.F.,.T.,.F.,,.F.,,,.F. )
	_oTBut1 :cTooltip = "Fechar"
	_cStyle := GetStyle(Preto,Branco,Cinza,Amarelo)
	_oTBut1:SetCss(_cStyle)


Return(Nil)



Static Function Panel02()

	Local _nLiI2	:= _oSize:GetDimension( "P2", "LININI" )+5
	Local _nCol		:= 8
	Local _oCor		:= CLR_CYAN

	Local _oGroup2	:= TGroup():New(_oSize:GetDimension( "P2","LININI"),_oSize:GetDimension( "P2", "COLINI"),;
	_oSize:GetDimension( "P2", "LINEND"),_oSize:GetDimension( "P2", "COLEND" ),"Parâmetros",_oDlg,CLR_BLUE,,.T.)

	//	_oGroup2:SetCss(_cStGrp)
	//	_oGroup2:Refresh()

	_nTmCol	:= 20
	_cStSay := GetStyle(Preto,Preto,Preto,Branco,2)

	_oSay2	:= TSay():New(_nLiI2+005,_nCol,{||' Filial de ?'},_oGroup2,,_oFont1,,,,.T.,CLR_WHITE,,50,10)
	_oSay2:SetCss(_cStSay)
	_oSay2:Refresh()
	@ _nLiI2+005, _nCol+52  MsGet _cFilDe	Picture '@!' Size _nTmCol,08 Pixel Of _oGroup2

	_oSay3:= TSay():New(_nLiI2+020,_nCol,{||' Filial Até ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,,50,10,,,,,.T.,.T.)
	_oSay3:SetCss(_cStSay)
	_oSay3:Refresh()
	@ _nLiI2+020, _nCol+52  MsGet _cFilAt	 Picture '@!' Size _nTmCol,08 Pixel Of _oGroup2

	_nCol	+= (50 + _nTmCol  + 15)
	_nTmCol	:= 40

	_oSay6:= TSay():New(_nLiI2+005,_nCol,{||' Cliente de ?'},_oGroup2,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
	_oSay6:SetCss(_cStSay)
	_oSay6:Refresh()
	@ _nLiI2+005, _nCol+52  MsGet _cCliDe	Picture '@!' F3 'SA1' Size _nTmCol,08 Pixel Of _oGroup2

	_oSay7:= TSay():New(_nLiI2+020,_nCol,{||' Cliente Até ?'},_oGroup2,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
	_oSay7:SetCss(_cStSay)
	_oSay7:Refresh()
	@ _nLiI2+020, _nCol+52  MsGet _cCliAt	Picture '@!' F3 'SA1' Size _nTmCol,08 Pixel Of _oGroup2

	_nCol	+= (50 + _nTmCol  + 15)
	_nTmCol	:= 20

	_oSay8:= TSay():New(_nLiI2+005,_nCol,{||' Loja de ?'},_oGroup2,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
	_oSay8:SetCss(_cStSay)
	_oSay8:Refresh()
	@ _nLiI2+005, _nCol+52  MsGet _cLojDe	Picture '@!' Size _nTmCol,08 Pixel Of _oGroup2

	_oSay9:= TSay():New(_nLiI2+020,_nCol,{||' Loja Até ?'},_oGroup2,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
	_oSay9:SetCss(_cStSay)
	_oSay9:Refresh()
	@ _nLiI2+020, _nCol+52  MsGet _cLojAt	 Picture '@!' Size _nTmCol,08 Pixel Of _oGroup2

	_nCol	+= (50 + _nTmCol  + 15)
	_nTmCol	:= 40

	_oSay4:= TSay():New(_nLiI2+005,_nCol,{||' Titulo de ?'},_oGroup2,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,,.T.)
	_oSay4:SetCss(_cStSay)
	_oSay4:Refresh()
	@ _nLiI2+005, _nCol+52  MsGet _cTitDe	Picture '@!' Size _nTmCol,08 Pixel Of _oGroup2

	_oSay5:= TSay():New(_nLiI2+020,_nCol,{||' Titulo Até ?'},_oGroup2,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
	_oSay5:SetCss(_cStSay)
	_oSay5:Refresh()
	@ _nLiI2+020, _nCol+52  MsGet _cTitAt	 Picture '@!' Size _nTmCol,08 Pixel Of _oGroup2

	_nCol	+= (50 + _nTmCol  + 15)
	_nTmCol	:= 40

	_oSay4:= TSay():New(_nLiI2+005,_nCol,{||' Vencto de ?'},_oGroup2,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,,.T.)
	_oSay4:SetCss(_cStSay)
	_oSay4:Refresh()
	@ _nLiI2+005, _nCol+52  MsGet _dVenDe	Picture '@d' Size _nTmCol,08 Pixel Of _oGroup2

	_oSay5:= TSay():New(_nLiI2+020,_nCol,{||' Vencto Até ?'},_oGroup2,,_oFont1,,,,.T.,CLR_WHITE,_oCor,50,10,,,,,.T.)
	_oSay5:SetCss(_cStSay)
	_oSay5:Refresh()
	@ _nLiI2+020, _nCol+52  MsGet _dVenAt	 Picture '@d' Size _nTmCol,08 Pixel Of _oGroup2

	_nCol	+= (50 + _nTmCol  + 15)
	_nTmCol	:= 70

	_cSit := ' '

	FRV->(dbSetOrder(1))
	FRV->(dbGoTop())

	While FRV->(!EOF())
		If FRV->FRV_DESCON = '2'
			_cSit += FRV->FRV_CODIGO
		Endif
		FRV->(dbSkip())
	EndDo

	_oSay10:= TSay():New(_nLiI2+005,_nCol,{||' Situação Cobrança?'},_oGroup2,,_oFont1,,,,.T.,CLR_WHITE,_oCor,_nTmCol,10,,,,,.T.)
	_oSay10:SetCss(_cStSay)
	_oSay10:Refresh()
	@ _nLiI2+020, _nCol  MsGet _cSit	 Valid SitCob() Size _nTmCol,08 Pixel Of _oGroup2

	_nCol	+= (_nTmCol  + 15)

	_oTBut1	:= TButton():New( _nLiI2+005, _nCol, "Consultar" ,_oGroup2,{||LjMsgRun("Consultando Títulos, aguarde...","Contas a Receber",{||Consulta()})}	, 40,25,,,.F.,.T.,.F.,,.F.,,,.F. )
	_oTBut1 :cTooltip = "Consultar"
	_oTBut1:SetCss(+;
	"QPushButton { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Branco+", stop: 1 "+Amarelo_Ouro+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Amarelo_Escuro+" }"+;
	"QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Amarelo_Escuro+", stop: 1 "+Branco+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Amarelo_Ouro+"}")

Return(Nil)



Static Function Panel04()

	Local _oGroup4	:= TGroup():New(_oSize:GetDimension( "P4","LININI"),_oSize:GetDimension( "P4", "COLINI"),;
	_oSize:GetDimension( "P4", "LINEND"),_oSize:GetDimension( "P4", "COLEND" ),"Pesquisar",_oDlg,CLR_BLUE,,.T.)

	Local _nLiI1	:= _oSize:GetDimension( "P4", "LININI" )+5
	Local _nColI	:= 30
	Local _nColF	:= _oSize:GetDimension( "P4", "COLEND" )
	Local _nTmBut	:= 60
	Local cStSeek	:= GetStyle(Branco,Branco,Cinza_Escuro,Preto,2)

	_nCol := _nColI

	_oGroup4:SetCss(_cStGrp)
	_oGroup4:Refresh()

	//	_nCol	+= 34

	_oCombo  := TComboBox():New( _nLiI1, _nCol, { |u| If( PCount() > 0, _cCombo := u, _cCombo ) }, _aCombo, 050, 012, _oGroup4  ,,{||IndexGrid(_oBrowse:aArray,_oBrowse,_cCombo)},,,,.T.,       ,,,{|| .T.},,,,, "_cCombo" )

	_nCol	+= 52

	_oSearch	:= TGet():New( _nLiI1, _nCol,{|u| If(PCount()>0,_cSearch:=u,_cSearch)},_oGroup4   ,050,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cSearch",,)

	_nCol	+= 52

	_oTBut2	:= TButton():New( _nLiI1, _nCol, "Pesquisar"	,_oGroup4,{|| PesqCpo(_cSearch,_aBrowse,_oBrowse)}	, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )
	_cStyle := GetStyle(Branco,Laranja,Cinza_Escuro,Preto)
	_oTBut2:SetCss(_cStyle)

	_nLiI1 += 3

Return(Nil)




Static Function Panel03()

	_oGroup3 := TGroup():New(_oSize:GetDimension( "P3","LININI"),_oSize:GetDimension( "P3", "COLINI"),;
	_oSize:GetDimension( "P3", "LINEND"),_oSize:GetDimension( "P3", "COLEND" ),"Títulos Contas a Receber",_oDlg,CLR_BLUE,,.T.)

	_oGroup3:SetCss(_cStGrp)
	_oGroup3:Refresh()


	_nLiI3 := _oSize:GetDimension( "P3", "LININI" )
	_nCoI3 := _oSize:GetDimension( "P3", "COLINI" )
	_nLiF3 := _oSize:GetDimension( "P3", "LINEND" )
	_nCoF3 := _oSize:GetDimension( "P3", "COLEND" )
	_nYSi3 := _oSize:GetDimension( "P3", "YSIZE" )

	_aCampos := {'','Filial','Cliente','Loja','Prefixo','Numero','Parcela','Tipo','Emissão','Vencimento','Valor','Saldo','Situacao','Historico'}

	_oBrowse := TwBrowse():New( _nLiI3+10, _nCoI3+5,_nCoF3-13,_nYSi3-13,,_aCampos,,_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)

	_oBrowse:SetArray(_aBrowse)

	AtuGrid()

	// Troca a imagem no duplo click do mouse
	_oBrowse:bLDblClick := {|| If(!Empty(_aBrowse[_oBrowse:nAt][3]), _aBrowse[_oBrowse:nAt][1] := !_aBrowse[_oBrowse:nAt][1],Nil)}

	_oBrowse:bHeaderClick := {|o, _nCol| If(_nCol = 1,MarkAll(_aBrowse,_oBrowse),Nil) }

	_oBrowse:nAt := 1
	_oBrowse:Refresh()

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



Static Function Consulta()

	Local _cQuery  := ""
	Local _cSitCob := "('"

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	Endif

	For n := 1 To Len(_cSit)
		If Len(_cSitCob) = 2
			_cSitCob += Substr(_cSit,n,1)
		Else
			_cSitCob += "','"+Substr(_cSit,n,1)
		Endif
	Next n

	_cSitCob += "')"

	_cQuery := " SELECT SE1.R_E_C_N_O_ AS E1RECNO,* FROM "+RetSqlName("SE1")+" SE1 " + CRLF
	_cQuery += " WHERE SE1.D_E_L_E_T_ = '' " + CRLF
	_cQuery += " AND E1_FILIAL	BETWEEN '"+_cFilDe+"' AND '"+_cFilAt+"' " + CRLF
	_cQuery += " AND E1_CLIENTE	BETWEEN '"+_cCliDe+"' AND '"+_cCliAt+"' " + CRLF
	_cQuery += " AND E1_LOJA	BETWEEN '"+_cLojDe+"' AND '"+_cLojAt+"' " + CRLF
	_cQuery += " AND E1_NUM		BETWEEN '"+_cTitDe+"' AND '"+_cTitAt+"' " + CRLF
	_cQuery += " AND E1_VENCREA	BETWEEN '"+dTos(_dVenDe)+"' AND '"+dTos(_dVenAt)+"' " + CRLF
	_cQuery += " AND E1_SALDO > 0 " + CRLF
	_cQuery += " AND E1_SITUACA IN "+_cSitCob+" " + CRLF
	_cQuery += " ORDER BY E1_FILIAL, E1_CLIENTE,E1_LOJA,E1_NUM "	+ CRLF

//		Memowrite("D:\MZ0240.txt",_cQuery)

	TcQuery _cQuery New Alias "TRB"

	TcSetField("TRB","E1_EMISSAO","D")
	TcSetField("TRB","E1_VENCREA","D")

	Count to _nTRB

	If _nTRB = 0
		MsgAlert("Não foram encontrados dados de acordo com os parâmetros informados!")
		_aBrowse:= {{.F.,'','','','','','','',cTod(''),cTod(''),0,0,'','',0}}
	Else
		TRB->(dbGoTop())

		_aBrowse := {}

		While TRB->(!EOF())

			AADD(_aBrowse,{;
			.F.				,; //01
			TRB->E1_FILIAL	,; //02
			TRB->E1_CLIENTE	,; //03
			TRB->E1_LOJA	,; //04
			TRB->E1_PREFIXO	,; //05
			TRB->E1_NUM		,; //06
			TRB->E1_PARCELA	,; //07
			TRB->E1_TIPO	,; //08
			TRB->E1_EMISSAO	,; //09
			TRB->E1_VENCREA	,; //10
			TRB->E1_VALOR	,; //11
			TRB->E1_SALDO	,; //12
			TRB->E1_SITUACA	,; //13
			TRB->E1_HIST	,; //14
			TRB->E1RECNO	}) //15

			TRB->(dbSkip())
		EndDo

	Endif

	TRB->(dbCloseArea())

	_oBrowse:SetArray(_aBrowse)

	AtuGrid()

	_oBrowse:nAt := 1

	_cCombo					:= 'Cliente'
	_cSearch 				:= Space(6)
	_oSearch:oGet:Picture	:= '@!'
	_oCombo:Refresh()
	_oSearch:Refresh()

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



Static Function AtuGrid()

	_oBrowse:bLine := {||{If(_aBrowse[_oBrowse:nAt,1],_oOk,_oNo ),; //1 - Marcador
	_aBrowse[_oBrowse:nAt,2],;
	_aBrowse[_oBrowse:nAt,3],;
	_aBrowse[_oBrowse:nAt,4],;
	_aBrowse[_oBrowse:nAt,5],;
	_aBrowse[_oBrowse:nAt,6],;
	_aBrowse[_oBrowse:nAt,7],;
	_aBrowse[_oBrowse:nAt,8],;
	_aBrowse[_oBrowse:nAt,9],;
	_aBrowse[_oBrowse:nAt,10],;
	Transform(_aBrowse[_oBrowse:nAt,11],"@E 9,999,999.99"),;
	Transform(_aBrowse[_oBrowse:nAt,12],"@E 9,999,999.99"),;
	_aBrowse[_oBrowse:nAt,13],;
	_aBrowse[_oBrowse:nAt,14]}}

	_oBrowse:Refresh()
	_oDlg:Refresh()

Return(Nil)




Static Function IndexGrid(_aVet,_oObj,_cPesq)

	If _cPesq = 'Cliente'
		_cSearch 				:= Space(6)
		_oSearch:oGet:Picture	:= '@!'
		_nElem					:= 3
		_aVet := ASORT(_aVet, , , { | x,y | y[_nElem] > x[_nElem] })
	ElseIf _cPesq = 'Numero'
		_cSearch 				:= Space(TamSX3("E1_NUM")[1])
		_oSearch:oGet:Picture	:= '@!'
		_nElem					:= 6
		_aVet := ASORT(_aVet, , , { | x,y | y[_nElem] > x[_nElem] })
	ElseIf _cPesq = 'Vencimento'
		_cSearch 				:= cTod('')
		_oSearch:oGet:Picture	:= '@D'
		_nElem					:= 10
		_aVet := ASORT(_aVet, , , { | x,y | dTos(y[_nElem]) > dTos(x[_nElem]) })
	Endif

	_oSearch:Refresh()

	_oObj:nAt := 1
	_oObj:Refresh()

Return()



//Pesquisar o campo informado na listbox
Static Function PesqCpo(_cString,_aVet,_oObj)

	If _cCombo = 'Cliente'
		_nElem	:= 3
		_cTp	:= 'C'
	ElseIf _cCombo = 'Numero'
		_nElem	:= 6
		_cTp	:= 'C'
	ElseIf _cCombo = 'Vencimento'
		_nElem	:= 10
		_cTp	:= 'D'
	Endif

	If _cTp = 'C'
		_cString := AllTrim(Upper(_cString))
		_nPos	 := aScan(_aVet,{|x| _cString $ Upper(x[_nElem])})
	Else
		_nPos	:= aScan(_aVet,{|x| dTos(x[_nElem]) = dTos(_cString) })
	Endif

	_lRet	:= (_nPos != 0)

	//³Se encontrou, posiciona o objeto ³
	If _lRet
		_oObj:nAt := _nPos
		_oObj:Refresh()
	EndIf

	_oDlg:Refresh()

Return(Nil)




Static Function SitCob(l1Elem)

	Local cTitulo 	:= "St. Cobrança"
	Local MvPar

	Local MvParDef 	:= ""
	Local oWnd

	Default l1Elem	:= .F.
	Private _aSitCob:={}

	oWnd := GetWndDefault()

	cAlias := Alias() 					 // Salva Alias Anterior

	MvPar := _cSit		 // Carrega Nome da Variavel do Get em Questao
	//		MvRet:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno

	FRV->(dbSetOrder(1))
	FRV->(dbGoTop())

	Aadd(_aSitCob,'Vazio')

	MvParDef += ' '

	While FRV->(!EOF())

		If FRV->FRV_DESCON = '2'

			Aadd(_aSitCob,Alltrim(FRV->FRV_DESCRI))

			MvParDef += FRV->FRV_CODIGO

		Endif

		FRV->(dbSkip())
	EndDo

	f_Opcoes(@MvPar,cTitulo,_aSitCob,MvParDef,12,49,l1Elem,1)  // Chama funcao f_Opcoes

	_cSit := MvPar										 // Devolve Resultado


Return( .T. )




Static Function Histor()

	Local _nFor  := 1
	Local _oHist := Nil
	Local _nRet  := 0
	Local _cHist := Space(TamSX3("E1_HIST")[1])
	Local _aHist := {'Concatenar','Substituir'}
	Local _nHist := 1
	Local _nProces := 0

	For _nFor := 1 To Len(_aBrowse)
		If _aBrowse[_nFor][1]
			_nProces ++
		Endif
	Next _nFor

	If _nProces > 0
		DEFINE MSDIALOG _oHist TITLE OemToAnsi("Ajuste Histórico") FROM 0,0 TO 125,600 OF _oHist PIXEL Style DS_MODALFRAME

		_oHist:lEscClose := .F. //Não permite fechar a janela pelo botão "ESC"

		_oGroupA := TGroup():New(5,5,60,300,"",_oHist,CLR_BLUE,,.T.)

		_oSayA	:= TSay():New(10,10,{||'Defina abaixo o histórico para os títulos marcados na tela anterior: '},_oHist,,_oFont1,,,,.T.,CLR_BLACK,,290,10)

		@ 20, 10 MsGet _cHist	 Picture '@!' Size 290,08 Pixel Of _oHist

		_oGroupB	:= TGroup():New(32,10,58,90,"Tipo de alteração do Histórico",_oHist,CLR_BLUE,,.T.)
		_oRad1		:= TRadMenu():New(38,13,_aHist,{|u| If(PCount() > 0, _nHist := u, _nHist) },_oGroupB,,,,,"Tipo de Ajuste",,,60,10,,,,.T.)

		_oGroupC	:= TGroup():New(32,100,58,300,"Ações",_oHist,CLR_BLUE,,.T.)
		_oTButA		:= TButton():New( 41, 120, "OK"			,_oGroupC,{|| _nRet:= 1,_oHist:End()}	, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )
		_oTButB		:= TButton():New( 41, 230, "Cancelar"	,_oGroupC,{|| _nRet:= 2,_oHist:End()}	, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )

		ACTIVATE MSDIALOG _oHist CENTERED

		If _nRet = 1

			LjMsgRun('Atualizando Histórico...','Histórico',{||PrcHist(_nHist,_cHist)})

			LjMsgRun('Atualizando dados...','Ajuste Histórico/Situação de Cobrança',{||Consulta()})

		Endif
	Else
		ShowHelpDlg('MZ0240_1',{'Nenhum título marcado para alteração de Histórico.'},1,{'Não se aplica.'},2)
	Endif

Return(Nil)



Static Function PrcHist(_nHist,_cHist)

	_AreaE1 := SE1->(GetArea())
	For _nFor := 1 To Len(_aBrowse)
		If _aBrowse[_nFor][1]

			SE1->(dbGoTo(_aBrowse[_nFor][15]))

			If _nHist = 1 .And. !Empty(SE1->E1_HIST)
				_cHistE1 := Alltrim(SE1->E1_HIST) + ' - '+Alltrim(_cHist)
			Else
				_cHistE1 := Alltrim(_cHist)
			Endif

			SE1->(RecLock("SE1",.F.))
			SE1->E1_HIST := _cHistE1
			SE1->(MsUnLock())

		Endif
	Next _nFor

	RestArea(_AreaE1)

Return(Nil)



Static Function Situac()

	Local _nFor		:= 1
	Local _oSit		:= Nil
	Local _nRet		:= 0
	Local _nProces	:= 0

	Local _cPort060	:= CRIAVAR("EF_BANCO",.F.)
	Local _cAgen060	:= CRIAVAR("EF_AGENCIA",.f.)
	Local _cConta060:= CRIAVAR("EF_CONTA",.F.)
	Local _cContrato:= ""
	Local _cNumBco	:= ""
	Local _oSituacao:= Nil

	Local _aCboSit	:= MZ240Sit()
	Local _cCboSit	:= '0-Carteira'

	Private _oDescrica	:= Nil
	Private _cDescrica	:= ''
	Private _oPort060	:= NIL
	Private _oAgen060	:= Nil
	Private _oConta060	:= Nil
	Private _lBanco		:= .F.

	For _nFor := 1 To Len(_aBrowse)
		If _aBrowse[_nFor][1]
			_nProces ++
		Endif
	Next _nFor

	If _nProces > 0

		DEFINE MSDIALOG _oSit TITLE OemToAnsi("Ajuste Situação de Cobrança") FROM 0,0 TO 155,460 OF _oSit PIXEL Style DS_MODALFRAME

		_oSit:lEscClose := .F. //Não permite fechar a janela pelo botão "ESC"

		_oGroupA := TGroup():New(5,5,75,230,"",_oSit,CLR_BLUE,,.T.)

		@ 010,010 SAY OemToAnsi("Situação")	SIZE 26, 7 OF _oGroupA PIXEL
		_oSituacao  := TComboBox():New( 010, 040, { |u| If( PCount() > 0, _cCboSit := u, _cCboSit ) }, _aCboSit, 185, 010, _oGroupA  ,,,,,,.T.,,,,{|| VldCombo(_cCboSit)},,,,, "_cCboSit" )

		@ 027, 010 SAY	OemToAnsi('Portador')	SIZE 32, 7 OF _oGroupA PIXEL
		@ 027, 040 MSGET _oPort060 VAR _cPort060 F3 "SA6" WHEN _lBanco SIZE 25,10 OF _oGroupA PIXEL

		@ 027, 078 SAY	OemToAnsi("Agência")	SIZE 26, 7 OF _oGroupA PIXEL
		@ 027, 105 MSGET _oAgen060 VAR _cAgen060 WHEN _lBanco SIZE 35,10 OF _oGroupA PIXEL

		@ 027,155 SAY	OemToAnsi("Conta")	SIZE 26, 7 OF _oGroupA PIXEL
		@ 027,175 MSGET _oConta060 VAR _cConta060 WHEN _lBanco SIZE 50,10 OF _oGroupA PIXEL

		_oGroupC	:= TGroup():New(40,10,70,225,"Ações",_oSit,CLR_BLUE,,.T.)

		_oTButA		:= TButton():New( 50, 030, "OK"			,_oGroupC,{|| If(VldDLG(_cPort060,_cAgen060,_cConta060,_cCboSit),(_nRet:= 1,_oSit:End()),Nil)}	, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )
		_oTButB		:= TButton():New( 50, 155, "Cancelar"	,_oGroupC,{|| _nRet:= 2,_oSit:End()}	, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )

		ACTIVATE MSDIALOG _oSit CENTERED

		If _nRet = 1
			LjMsgRun('Atualizando Cobrança...','Cobrança',{||SitTit(_cPort060,_cAgen060,_cConta060,_cCboSit)})
			LjMsgRun('Atualizando dados...','Ajuste Histórico/Situação de Cobrança',{||Consulta()})
		Endif
	Else
		ShowHelpDlg('MZ0240_1',{'Nenhum título marcado para alteração de Histórico.'},1,{'Não se aplica.'},2)
	Endif

Return(Nil)



Static Function VldCombo(_cSitu)

	Local _lRet := .T.

	FRV->(dbSetOrder(1))
	If FRV->(MsSeek(xFilial("FRV")+Left(_cSitu,1)))
		If FRV->FRV_BANCO = '1'
			_lBanco := .T.
		Else
			_lBanco := .F.
		Endif
	Endif

	_oPort060:Refresh()
	_oAgen060:Refresh()
	_oConta060:Refresh()

Return(_lRet)




Static Function VldDLG(_cPort,_cAgen,_cConta,_cSituaca)

	Local _lRet		:= .T.
	Local _lBcoObg	:= .T.

	FRV->(dbSetOrder(1))
	If FRV->(MsSeek(xFilial("FRV")+Left(_cSituaca,1)))
		If FRV->FRV_BANCO = '1'
			_lBcoObg := .T.
		Else
			_lBcoObg := .F.
		Endif

		If !_lBcoObg .And. (!Empty(_cPort) .Or. !Empty(_cAgen) .Or. !Empty(_cConta))
			_lRet := .F.
			ShowHelpDlg('MZ0240_4',{'Para situação do tipo "'+Alltrim(Capital(FRV->FRV_DESCRI))+'", os dados bancários não devem ser preenchidos.'},1,{'Não se aplica.'},2)
		ElseIf _lBcoObg .And. (Empty(_cPort) .Or. Empty(_cAgen) .Or. Empty(_cConta))
			_lRet := .F.
			ShowHelpDlg('MZ0240_5',{'Para situação do tipo "'+Alltrim(Capital(FRV->FRV_DESCRI))+'", os dados bancários devem ser preenchidos.'},1,{'Não se aplica.'},2)
		ElseIf _lBcoObg .And. (!Empty(_cPort) .Or. !Empty(_cAgen) .Or. !Empty(_cConta))
			SA6->(dbsetOrder(1))
			If !SA6->(MsSeek(xFilial("SA6")+_cPort+_cAgen+_cConta))
				_lRet := .F.
				ShowHelpDlg('MZ0240_3',{'Cadastro do Banco/Agência/Conta informado não encontrado.'},1,{'Digite um código válido.'},2)
			Endif
		Endif
	Endif

Return(_lRet)




Static Function MZ240Sit()

	Local _aRet := {}

	FRV->(dbSetOrder(1))
	FRV->(dbGoTop())

	While FRV->(!EOF())
		If FRV->FRV_DESCON = '2'
			AAdd(_aRet,Alltrim(FRV->FRV_CODIGO)+'-'+Alltrim(Capital(FRV->FRV_DESCRI)))
		Endif
		FRV->(dbSkip())
	EndDo

Return(_aRet)



Static Function SitTit(_cPort,_cAgen,_cConta,_cSituaca)

	Local _cSituac := Left(_cSituaca,1)

	_AreaE1 := SE1->(GetArea())
	For _nFor := 1 To Len(_aBrowse)
		If _aBrowse[_nFor][1]

			cFilAnt_bkp	:= cFilAnt
			cFilAnt		:= _aBrowse[_nFor][2]
			aAreaSM0	:= SM0->(GetArea())

			SM0->(MsSeek(cEmpAnt+cFilAnt))

			SE1->(dbGoTo(_aBrowse[_nFor][15]))

			If SE1->E1_SITUACA <> _cSituac
				SE1->(RecLock("SE1",.F.))
				SE1->E1_PORTADO := _cPort
				SE1->E1_AGEDEP  := _cAgen
				SE1->E1_CONTA	:= _cConta
				SE1->E1_SITUACA := _cSituac
				SE1->E1_MOVIMEN := dDataBase
				SE1->(MsUnLock())
			Endif

			cFilAnt := cFilAnt_bkp
			RestArea(aAreaSM0)
		Endif

	Next _nFor

	RestArea(_AreaE1)

Return(Nil)
