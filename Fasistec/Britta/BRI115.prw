#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'

#Define Verde "#9AFF9A"
#Define Amarelo "#FFD700"
#Define Vermelho "#FF0000"
#Define Salmao "#FF8C69"
#Define Branco "#FFFAFA"
#Define Azul "#87CEEB"
#Define Preto "#000000"
#Define Cinza "#696969"
#Define Verde_Escuro "#006400"
#Define Azul_Escuro "#191970"
#Define Vermelho_Escuro "#8B0000"
#Define Amarelo_Escuro "#8B6914"


/*/{Protheus.doc} BRI115
//Reajuste de Tabela de Preço
@author Fabiano
@since 26/10/2018
@version 1.0
/*/
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

	Private _oPreco	:= Nil
	Private _nValor	:= 0

	Private _oBrowse:= Nil
	Private _aBrowse:= {{.F.,'','','','','','',0,0,0}}

	Private _oOK	:= LoadBitmap(GetResources(),'LBOK')
	Private _oNO	:= LoadBitmap(GetResources(),'LBNO')

	Private _aReaj	:= {"Valor","Percentual","Alinhamento"}
	Private _aTipo	:= {"Acréscimo","Decréscimo"}

	Private _oRad1	:= Nil
	Private _oRad2	:= Nil

	Private _nReaj	:= 1
	Private _nTipo	:= 1

	_oSize := FwDefSize():New( .F. )							// Com enchoicebar
	_oSize:AddObject( "P1", 100, 13, .T., .t. )
	_oSize:AddObject( "P2", 100, 15, .T., .t. )
	_oSize:AddObject( "P3", 100, 64, .T., .T. )
	_oSize:AddObject( "P4", 100, 08, .T., .T. )
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

	_oTBut1	:= TButton():New( _nLiI1+005, _nCol, "Consultar" ,_oDlg,{||LjMsgRun("Consultando Tabelas de Preço, aguarde...","Tabela de Preço",{||Consulta()})}	, 40,25,,,.F.,.T.,.F.,,.F.,,,.F. )
	_oTBut1 :cTooltip = "Consultar"
	_oTBut1:SetCss(+;
	"QPushButton { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Branco+", stop: 1 "+Verde+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Verde_Escuro+" }"+;
	"QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Verde+", stop: 1 "+Branco+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Verde_Escuro+"}")


Return(Nil)



Static Function Panel02()

	Local _oGroup2 := TGroup():New(_oSize:GetDimension( "P2","LININI"),_oSize:GetDimension( "P2", "COLINI"),;
	_oSize:GetDimension( "P2", "LINEND"),_oSize:GetDimension( "P2", "COLEND" ),"Dados para Reajuste",_oDlg,CLR_BLUE,,.T.)

	Local _nLiI1	:= _oSize:GetDimension( "P2", "LININI" )+5
	Local _nCol		:= 8
	Local _oCor		:= CLR_BLUE
	Local _nTmCol	:= 40

	_oRad1		:= TRadMenu():New(_nLiI1+005,_nCol,_aReaj,{|u| If(PCount() > 0, _nReaj := u, _nReaj) },_oDlg,,{|| ChangeRadio()},,,;
	"Tipo de Reajuste",,,60,10,,,,.T.)

	_nCol += 65

	_oRad2		:= TRadMenu():New(_nLiI1+010,_nCol,_aTipo,{|u| If(PCount() > 0, _nTipo := u, _nTipo) },_oDlg,,{||},,,;
	"Tipo de Reajuste",,,60,10,,,,.T.)

	_nCol += 65

	_oSay3	:= TSay():New(_nLiI1+015,_nCol,{||' Reajuste ?'},_oDlg,,_oFont1,,,,.T.,CLR_WHITE,_oCor,40,10,,,,,.T.)
	_oSay3:lTransparent := .F.

	_nCol += 42

	_oPreco	:= TGet():New(_nLiI1+015,_nCol,{|u| If(PCount() > 0, _nValor := u, _nValor) },_oDlg,_nTmCol,08,'@<E 99,999.99',;
	,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cValtoChar(_nValor),,,,)

	_nCol	+= ( _nTmCol  + 40)

	_oTBut1	:= TButton():New( _nLiI1+007, _nCol, "Calcular" ,_oDlg,{||LjMsgRun("Calculando Reajuste, aguarde...","Tabela de Preço",{||Calcular()})}	, 40,25,,,.F.,.T.,.F.,,.F.,,,.F. )
	_oTBut1 :cTooltip = "Calcular"
	_oTBut1:SetCss(+;
	"QPushButton { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Branco+", stop: 1 "+Azul+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Azul_Escuro+"}"+;
	"QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Azul+", stop: 1 "+Branco+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Azul_Escuro+"}")


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

	AtuGrid()

	// Troca a imagem no duplo click do mouse
	_oBrowse:bLDblClick := {|| If(!Empty(_aBrowse[_oBrowse:nAt][2]),;
	If(_aBrowse[_oBrowse:nAt][1],;
	If(_oBrowse:ColPos==9,lEditCell( _aBrowse, _oBrowse, '@<E 999,999.99', _oBrowse:ColPos ) .And. VldCpo(),;
	_aBrowse[_oBrowse:nAt][1] := !_aBrowse[_oBrowse:nAt][1]),;
	_aBrowse[_oBrowse:nAt][1] := !_aBrowse[_oBrowse:nAt][1]),Nil),;
	_oBrowse:Refresh()}

	_oBrowse:bHeaderClick := {|o, _nCol| If(_nCol = 1,MarkAll(_aBrowse,_oBrowse),Nil) }

	_oBrowse:nAt := 1
	_oBrowse:Refresh()

Return(Nil)



Static Function Panel04()

	Local _oGroup2 := TGroup():New(_oSize:GetDimension( "P4","LININI"),_oSize:GetDimension( "P4", "COLINI"),;
	_oSize:GetDimension( "P4", "LINEND"),_oSize:GetDimension( "P4", "COLEND" ),"Ações",_oDlg,CLR_MAGENTA,CLR_YELLOW,.T.)

	Local _nLiI4 		:= _oSize:GetDimension( "P4", "LININI" )+6
	Local _nColI		:= _oSize:GetDimension( "P4", "COLINI")
	Local _nColF		:= _oSize:GetDimension( "P4", "COLEND")
	Local _oTFont		:= TFont():New('Courier new',,-14,,.T.,,,,,.T.)

	_oTBut1	:= TButton():New( _nLiI4, _nColI+100, "Reajustar" ,_oDlg,{||LjMsgRun("Processando Reajuste, aguarde...","Tabela de Preço",{||Reajustar()})}	, 60,15,,_oTFont,.F.,.T.,.F.,,.F.,,,.F. )
	_oTBut1 :cTooltip = "Reajustar"
	_oTBut1:SetCss(+;
	"QPushButton { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Branco+", stop: 1 "+Amarelo+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Amarelo_Escuro+" }"+;
	"QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Amarelo+", stop: 1 "+Branco+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Amarelo_Escuro+" }")

	_oTBut2	:= TButton():New( _nLiI4, _nColF-100-60, "Cancelar/Sair" ,_oDlg,{||_oDlg:End()}	, 60,15,,_oTFont,.F.,.T.,.F.,,.F.,,,.F. )
	_oTBut2 :cTooltip = "Cancelar"
	_oTBut2:SetCss(+;
	"QPushButton { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Branco+", stop: 1 "+Salmao+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Vermelho_Escuro+" }"+;
	"QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+Salmao+", stop: 1 "+Branco+");border-style: outset;border-width: 2px;border-radius: 10px;border-color: "+Vermelho_Escuro+" }")

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

	Local _nInd		:= 1
	Local _lOK		:= .F.

	If _nValor > 0
		For _nInd := 1 To Len(_aBrowse)
			If _aBrowse[_nInd][1]

				If _nReaj == 1
					If _nTipo == 1
						_aBrowse[_nInd][9] := _aBrowse[_nInd][8] + _nValor
					Else
						_aBrowse[_nInd][9] := _aBrowse[_nInd][8] - _nValor
					Endif
				ElseIf _nReaj == 2
					If _nTipo == 1
						_aBrowse[_nInd][9] := _aBrowse[_nInd][8] + (_aBrowse[_nInd][8] * (_nValor / 100))
					Else
						_aBrowse[_nInd][9] := _aBrowse[_nInd][8] - (_aBrowse[_nInd][8] * (_nValor / 100))
					Endif
				ElseIf _nReaj == 3
					_aBrowse[_nInd][9] := _nValor
				Endif

				_aBrowse[_nInd][10]:= _aBrowse[_nInd][9] - _aBrowse[_nInd][8]
				_lOK := .T.
			Endif
		Next
	Else
		ShowHelpDlg('BRI115_1',{'Preencha o campo "Valor" para realizar o cálculo'},1,{'Não se aplica.'},2)
		_lOK := .T.
	Endif

	If !_lOK
		ShowHelpDlg('BRI115_2',{'Nenhum registro marcado.'},1,{'Não se aplica.'},2)
	Endif

	_oBrowse:Refresh()
	_oDlg:Refresh()

Return(Nil)



Static Function Reajustar()

	Local _nInd		:= 1
	Local _cProcLib	:= ''
	Local _cCodBlq	:= '03' // Tabela de Preço
	Local _cFil		:= ''
	Local _cCli		:= ''
	Local _cLoja	:= ''
	Local _cProd	:= ''
	Local _nPrcAt	:= 0
	Local _nPCalc	:= 0
	Local _nDif		:= 0
	Local _cChavSCR	:= ''
	Local _lProc	:= .F.

	For _nInd := 1 To Len(_aBrowse)
		If _aBrowse[_nInd][1]

			_cProcLib	:= GetSxeNum('ZF1','ZF1_PROCES')
			_cFil		:= Alltrim(_aBrowse[_nInd][2])
			_cCli		:= Alltrim(_aBrowse[_nInd][3])
			_cLoja		:= Alltrim(_aBrowse[_nInd][4])
			_cProd		:= Alltrim(_aBrowse[_nInd][7])
			_nPrcAt		:= _aBrowse[_nInd][8]
			_nPCalc		:= _aBrowse[_nInd][9]
			_nDif		:= _aBrowse[_nInd][10]

			If _nDif < 0

				SCR->(dbSetOrder(1))
				If SCR->(dbSeek(xFilial("SCR")+ _cCodBlq + _cFil + _cCli + _cLoja + _cProd))

					_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM

					ZAH->(dbSetOrder(1))
					If ZAH->(dbSeek(SCR->CR_FILIAL + _cChavSCR  ))

						_cCq := " DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_FILIAL = '"+SCR->CR_FILIAL+"' AND ZAH_NUM = '"+SCR->CR_NUM+"' AND ZAH_TIPO = '"+SCR->CR_TIPO+"' "
						TcSqlExec(_cCq)
					Endif

					While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM

						SCR->(RecLock("SCR",.F.))
						SCR->(dbDelete())
						SCR->(MsUnlock())

						SCR->(dbSkip())
					EndDo
				Endif

				_cGrAprov:= SuperGetMV("ASC_GRPRPV",.F.,'')

				SAL->(dbSetOrder(2))
				If SAL->(!dbSeek(xFilial() + _cGrAprov))
					MSGSTOP("Grupo Nao Cadastrado, Favor Contatar o Administrador do Sistema!")
					Return
				EndIf

				lFirstNiv   := .T.
				cAuxNivel   := ""
				_lLibera    := .T.

				SAL->(dbSetOrder(2))
				If SAL->(dbSeek(xFilial() + _cGrAprov))

					While SAL->(!Eof()) .And. xFilial("SAL")+_cGrAprov == SAL->AL_FILIAL+SAL->AL_COD

						If lFirstNiv
							cAuxNivel := SAL->AL_NIVEL
							lFirstNiv := .F.
						EndIf

						SCR->(Reclock("SCR",.T.))
						SCR->CR_FILIAL	:= xFilial("SCR")
						SCR->CR_NUM		:= _cFil + _cCli + _cLoja + _cProd
						SCR->CR_TIPO	:= _cCodBlq
						SCR->CR_NIVEL	:= SAL->AL_NIVEL
						SCR->CR_USER	:= SAL->AL_USER
						SCR->CR_APROV	:= SAL->AL_APROV
						SCR->CR_STATUS	:= "02"
						SCR->CR_EMISSAO := dDataBase
						SCR->CR_MOEDA	:= 1
						SCR->CR_TXMOEDA := 1
						SCR->CR_OBS     := Alltrim(SM0->M0_NOME) +" - TABELA DE PREÇO"
						SCR->CR_TOTAL	:= _nPCalc
//						SCR->CR_YCLIENT	:= _cCli
//						SCR->CR_YLOJA	:= _cLoja
						SCR->(MsUnlock())

						ZAH->(RecLock("ZAH",.T.))
						ZAH->ZAH_FILIAL:= SCR->CR_FILIAL
						ZAH->ZAH_NUM   := SCR->CR_NUM
						ZAH->ZAH_TIPO  := SCR->CR_TIPO
						ZAH->ZAH_NIVEL := SCR->CR_NIVEL
						ZAH->ZAH_USER  := SCR->CR_USER
						ZAH->ZAH_APROV := SCR->CR_APROV
						ZAH->ZAH_STATUS:= SCR->CR_STATUS
						ZAH->ZAH_TOTAL := SCR->CR_TOTAL
						ZAH->ZAH_EMISSA:= SCR->CR_EMISSAO
						ZAH->ZAH_MOEDA := SCR->CR_MOEDA
						ZAH->ZAH_TXMOED:= SCR->CR_TXMOEDA
						ZAH->ZAH_OBS   := SCR->CR_OBS
						ZAH->ZAH_TOTAL := SCR->CR_TOTAL
						ZAH->(MsUnlock())

						SAL->(dbSkip())
					EndDo
				EndIf

				ShowHelpDlg("BRI115_3", {'Tabela de Preço Bloqueada, pois o valor calculado é menor que o valor em vigência.',;
				'Filial+Cliente+Loja: '+_cFil+"-"+_cCli +"-"+_cLoja,;
				'Produto: '+_cProd,;
				'Preço Calculado: '+Alltrim(Transform(_nPCalc,"@e 999,999.99")),;
				'Preço Vigente: '+Alltrim(Transform(_nPrcAt,"@e 999,999.99"))},5,;
				{'Solicite a liberação junto ao setor responsável.'},1)

			EndIf

			ZF1->(RecLock("ZF1",.T.))
			ZF1->ZF1_FILIAL	:= _cFil
			ZF1->ZF1_CLIENT	:= _cCli
			ZF1->ZF1_LOJA	:= _cLoja
			ZF1->ZF1_PRODUT	:= _cProd
			ZF1->ZF1_PROCES	:= _cProcLib
			ZF1->ZF1_DTEMIS	:= dDataBase
			ZF1->ZF1_PRCANT	:= _nPrcAt
			ZF1->ZF1_PRCATU	:= _nPCalc
			ZF1->ZF1_STATUS	:= If(_nDif < 0,"P","L")
			ZF1->ZF1_USUARI	:= UsrRetName(RetCodUsr())
			ZF1->(MsUnLock())

			ConfirmSX8()

			_lProc := .T.

		Endif
	Next

	_aBrowse:= {{.F.,'','','','','','',0,0,0}}

	_oBrowse:SetArray(_aBrowse)

	AtuGrid()

	If _lProc
		MsgInfo("Reajuste realizado com sucesso!")
	Endif

Return(Nil)



Static Function AtuGrid()

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

	_oBrowse:Refresh()
	_oDlg:Refresh()

Return(Nil)




Static Function ChangeRadio()

	Local _cMasc   := ""

	If _nReaj == 1
		_cMasc := '@<E 999,999.99'
		_oRad2:Enable()
	ElseIf _nReaj == 2
		_cMasc := '@<E 999.99%'
		_oRad2:Enable()
	ElseIf _nreaj == 3
		_cMasc := '@<E 999,999.99'
		_oRad2:Disable()
	Endif

	_oPreco:oGet:Picture	:= _cMasc
	_nValor := 1
	_oPreco:CtrlRefresh()
	_nValor := 0
	_oPreco:CtrlRefresh()

	_oDlg:Refresh()

Return(Nil)



Static Function VldCpo()

	_aBrowse[_oBrowse:nAt][10]:= _aBrowse[_oBrowse:nAt][9] - _aBrowse[_oBrowse:nAt][8]

	_oBrowse:Refresh()

Return(Nil)
