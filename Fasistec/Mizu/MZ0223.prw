#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} MZ0223
//Controle de Pedidos Mizu
@author Fabiano
@since 29/06/2017
@version 2.0
@type Function
/*/

User Function MZ0223()

	Local _aSize		:= MsAdvSize(.F.)
	Local _aObjects		:= {}

	Private _oDlg		:= Nil
	Private _aHeadPro	:= {}
	Private _aColSzPro	:= {}
	Private _aBrwPro	:= {}
	Private _oBrwPro	:= Nil
	Private _aFldPro	:= {}
	Private _aHeadPed	:= {}
	Private _aColSzPed	:= {}
	Private _aBrwPed	:= {}
	Private _oBrwPed	:= Nil
	Private _aFldPed	:= {}
	Private _nRodape	:= 30
	Private _oOK 		:= LoadBitmap(GetResources(),'LBOK')
	Private _oNO 		:= LoadBitmap(GetResources(),'LBNO')
	Private _oRed		:= LoadBitmap(GetResources(),'BR_VERMELHO')
	Private _oGreen		:= LoadBitmap(GetResources(),'BR_VERDE')
	Private _oBlue		:= LoadBitmap(GetResources(),'BR_AZUL')
	Private _oYellow	:= LoadBitmap(GetResources(),'BR_AMARELO')
	Private _oCancel	:= LoadBitmap(GetResources(),'BR_CANCEL')
	Private _oBrow		:= LoadBitmap(GetResources(),'BR_MARROM')
	Private _oBlack		:= LoadBitmap(GetResources(),'BR_PRETO')
	Private _oOrange	:= LoadBitmap(GetResources(),'BR_LARANJA')
	Private _oPink		:= LoadBitmap(GetResources(),'BR_PINK')
	Private _oWhite		:= LoadBitmap(GetResources(),'BR_BRANCO')
	Private _oGray		:= LoadBitmap(GetResources(),'BR_CINZA')
	Private _oClose		:= LoadBitmap(GetResources(),'XCLOSE')
	Private _oChekOK	:= LoadBitmap(GetResources(),'CHECKOK')
	Private _cTextHtml	:= ''
	Private _oFont1		:= TFont():New( "Verdana",0,-17,,.T.,0,,700,.F.,.F.,,,,,, )
	Private _oFont3		:= TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
	Private _lAcesso	:= u_ChkAcesso("MZ0223",6,.F.)
	Private F			:= 0;Private Fa:= 0;Private Fb := 0;Private Fc := 0;Private Fd := 0;Private Ff := 0;Private Fg := 0
	Private _cRastroOC	:= ''
	Private _nUsadGet	:= 0
	Private _bGeraPed	:= ''
	Private _oDadosGet	:= Nil
	Private _nQtPed		:= 0
	Private _cPes1		:= Space(20)
	Private _cPes2		:= Space(20)
	Private _oMenu01	:= Nil

	If !U_ChkAcesso("MZ0223",1,.T.)
		Return(Nil)
	Endif

	If !cFilAnt $ SuperGetMV('MZ_GESTPED',,'')
		ShowHelpDlg("MZ_GESTPED", {'Filial não habilitada para utilização desta rotina!'},2,{'Solicite o ajuste do parâmetro "MZ_GESTPED".'},2)
		Return(Nil)
	Endif

	If SC6->(Fieldpos("C6_YPEDGER")) = 0
		ShowHelpDlg("MZ0223", {'Campo "C6_YPEDGER" não existe na Base de Dados!'},2,{'Solicite a criação do mesmo.'},2)
		Return(Nil)
	Endif

	AAdd( _aObjects, { 45 , 100, .T. , .T. , .F. } )
	AAdd( _aObjects, { 45 , 100, .T. , .T. , .F. } )
	AAdd( _aObjects, { 10 , 100, .T. , .T. , .F. } )

	_aInfo := { _aSize[ 1 ], _aSize[ 2 ], _aSize[ 3 ], _aSize[ 4 ], 5 , 5 , 5 , 5 }
	_aPosObj := MsObjSize( _aInfo, _aObjects, .T. , .T. )

	DEFINE MSDIALOG _oDlg TITLE OemToAnsi("Controle de Programações/Pedidos") FROM _aSize[7],_aSize[1] to _aSize[6],_aSize[5] OF _oDlg PIXEL //Style DS_MODALFRAME // Este estilo retira o botão de fechar no canto superior direito[X]

	_oDlg:lEscClose := .F. //Não permite fechar a janela pelo botão "ESC"

	_nTimeOut	:= GetNewPar('MZ_TIME223',30000)  // 1minuto - tempo em milesegundos
	_oTimer001	:= ""

//	_oTimer001	:= TTimer():New(_nTimeOut,{ || MVSZ223C("A") },_oDlg)
	_oTimer001	:= TTimer():New(_nTimeOut,{ || LjMsgRun('Atualizando... (TimeOut: '+Alltrim(Str(_nTimeOut/1000))+' segundos)','Programação x Pedido',{||MVSZ223C()}) },_oDlg)

	_oTimer001:Activate()

	BoxPro(_aPosObj[1])

	BoxPed(_aPosObj[2])

	BoxBut(_aPosObj[3])

	BoxRod(_aPosObj[1],_aPosObj[3])

	LjMsgRun("Gerando dados para montagem da tela...","Programação x Pedido",{||MVSZ223C()})

//	Set Key VK_F5 TO LjMsgRun("Atualizando dados, aguarde...","Programação x Pedido",{||MVSZ223C("B")})

	ACTIVATE MSDIALOG _oDlg CENTERED

//	Set Key VK_F5 TO

Return(Nil)



Static Function BoxPro(_aPos)

	Local _nLini	:= _aPos[1]
	Local _nColi 	:= _aPos[2]
	Local _nLinf 	:= _aPos[3] - _nRodape
	Local _nColf 	:= _aPos[4]
	Local _oPes1	:= Nil
	Local _aPes1	:= {}
	Local _cSeek	:= Space(10)//Space(TamSx3("C6_NUM")[1])

	_cPes1	:= Space(20)

	/*
	1 = Campo
	2 = Tamanho coluna
	3 = Tipo
	4 = Campo utilizado para pesquisa?
	*/
	_aFldPro := {{"C6_OK"		,1,"C","N"},;
	{"C6_NUM"		,35,"C","S"},;
	{"C5_YTIPOPD"	,40,"C","N"},;
	{"C6_ITEM"		,17,"C","N"},;
	{"C6_CLI"		,25,"C","N"},;
	{"C6_LOJA"		,17,"C","N"},;
	{"A1_NOME"		,40,"C","S"},;
	{"C5_EMISSAO"	,37,"D","N"},;
	{"C6_ENTREG"	,30,"D","S"},;
	{"C6_PRODUTO"	,30,"C","N"},;
	{"C6_QTDVEN"	,35,"N","N"},;
	{"C6_PRCVEN"	,35,"N","N"},;
	{"C6_VALOR"		,30,"N","N"},;
	{"C6_TES"		,32,"C","N"},;
	{"C6_UM"		,30,"C","N"},;
	{"C6_YPEDGER"	,25,"C","N"},;
	{"C5_YCDPALM"	,50,"C","N",},;
	{"C5_YDTIMPR"	,35,"D","N"},;
	{"C6_YITPPAL"	,55,"C","N"},;
	{"C5_YORIGPD"	,30,"C","N"}}


	For F := 1 To Len(_aFldPro)
		SX3->(dbsetOrder(2))
		If SX3->(dbSeek(_aFldPro[F][1]))

			If _aFldPro[F][1] = 'C6_OK'
				_cTit := " "
			ElseIf _aFldPro[F][1] = 'C6_NUM'
				_cTit := "Numero"
			Else
				_cTit := Trim(X3Titulo())
			Endif

			aAdd(_aHeadPro, _cTit)
			aAdd(_aColSzPro,_aFldPro[F][2])

			If _aFldPro[F][4] == 'S'
				AAdd(_aPes1,_cTit)
			Endif
		Endif
	Next F

	_oGrupo1		:= TGroup():New( _nLini,_nColi,_nLinf,_nColf,"",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	_oBmp1		:= TBitmap():New( _nLini,_nColi,_nColf-_nColi,013,,"\images\verde.png",.T.,_oDlg,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	_oSay1		:= TSay():New( _nLini+1,((_nColf-_nColi)/2)-20,{||"Programações"},_oDlg,,_oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,100,010)

	_nLini +=15

	_oPes1 := TComboBox():New( _nLini, _nColi+5, { |u| If( PCount() > 0, _cPes1 := u, _cPes1 )}, _aPes1, 050, 014, _oDlg,,{||IndexGrid(_oBrwPro:aArray,_oBrwPro,_cPes1,_aHeadPro,_aFldPro,1)} ,,,,.T.,,,,{|| .T.},,,,, "_cPes1" )

	@ _nLini, _nColi+58 MsGet _cSeek				Size 060, 010 Of _oDlg Pixel
	_oTBut	:= TButton():New( _nLini, _nColi+121, "Pesquisar"	,_oDlg,{|| PesqCpo(_cSeek,_oBrwPro:aArray,_oBrwPro,_cPes1,_aHeadPro,_aFldPro)}	, 30,12,,,.F.,.T.,.F.,,.F.,,,.F. )

	_nLini +=13

	_oBrwPro		:= TCBrowse():New( _nLini,_nColi,_nColf - _nColi,_nLinf - _nLini,,_aHeadPro,_aColSzPro,_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,.T.,.T.)

	_aBrwPro := {}
	For Fa := 1 To Len(_aFldPro)
		If _aFldPro[Fa][1] = 'C6_OK'
			AAdd(_aBrwPro,"4")
		Else
			AAdd(_aBrwPro,Criavar(_aFldPro[Fa][1]))
		Endif
	Next Fa

	_oBrwPro:SetArray(_aBrwPro)

	_oBrwPro:bLine := {|| GetArray(_oBrwPro,_aBrwPro,_aFldPro)}

	//	If _lAcesso
	_oBrwPro:blDBLClick	:= {|| MZ223D(_oBrwPro,_aBrwPro,_aFldPro) }
	//	_oBrwPro:bRClicked	:= {|_aObj,X,Y| _cOK := But_Right(),If(_cOK = "0",_oMenu01:Activate( X, Y, _aObj ),Nil)}
	_oBrwPro:bRClicked	:= {|_aObj,X,Y| _cOK := But_Right(),_oMenu01:Activate( X, Y, _aObj )}
	//	Endif

Return(Nil)



Static Function BoxPed(_aPos)

	Local _nLini	:= _aPos[1]
	Local _nColi 	:= _aPos[2]
	Local _nLinf 	:= _aPos[3] - _nRodape
	Local _nColf 	:= _aPos[4]
	Local _oPes2	:= Nil
	Local _aPes2	:= {}
	Local _cSeek	:= Space(10)//Space(TamSx3("Z1_NUM")[1])

	_cPes2	:= Space(20)

	_aFldPed := {{"Z1_OK"		,1,"C","N"},;
	{"Z1_NUM"		,30,"C","S"},;
	{"Z1_TIPO"		,15,"C","N"},;
	{"Z1_CLIENTE"	,25,"C","N"},;
	{"Z1_LOJA"		,17,"C","N"},;
	{"Z1_NOMCLI"	,40,"C","S"},;
	{"Z1_EMISSAO"	,30,"D","N"},;
	{"Z1_HORAPED"	,38,"C","N"},;
	{"Z1_DTENT"		,38,"D","S"},;
	{"Z1_PRODUTO"	,30,"C","N"},;
	{"Z1_UNID"		,20,"C","N"},;
	{"Z1_QUANT"		,30,"N","N"},;
	{"Z1_PCOREF"	,33,"N","N"},;
	{"Z1_TES"		,15,"C","N"},;
	{"Z1_USUARIO"	,45,"C","N"},;
	{"Z1_LIBER"		,25	,"C","N"},;
	{"Z1_PEDIDO"	,35,"C","S"},;
	{"Z1_ITEMPV"	,25,"C","N"},;
	{"Z1_YTIPO"		,30,"C","N"},;
	{"Z1_YCDPALM"	,50,"C","N"},;
	{"Z1_YDTIMPR"	,35,"D","N"},;
	{"Z1_YITPPAL"	,55,"C","N"},;
	{"Z1_YORIGPD"	,30,"C","N"}}

	For F := 1 To Len(_aFldPed)
		SX3->(dbsetOrder(2))
		If SX3->(dbSeek(_aFldPed[F][1]))
			If _aFldPed[F][1] = 'Z1_OK'
				_cTit := " "
			ElseIf _aFldPed[F][1] = 'Z1_PEDIDO'
				_cTit := "Nr.Progr."
			ElseIf _aFldPed[F][1] = 'Z1_ITEMPV'
				_cTit := "It.Progr."
			Else
				_cTit := Trim(SX3->X3_TITULO)
			Endif

			aAdd(_aHeadPed, _cTit)
			aAdd(_aColSzPed,_aFldPed[F][2])

			If _aFldPed[F][4] == 'S'
				AAdd(_aPes2,_cTit)
			Endif
		Endif
	Next F

	_oBmp2		:= TBitmap():New( _nLini,_nColi,_nColf-_nColi,013,,"\images\azul.png",.T.,_oDlg,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	_oSay2		:= TSay():New( _nLini+1,_nColi + ((_nColf-_nColi)/2)-10,{||"Pedidos"},_oDlg,,_oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,100,010)

	_nLini +=15

	_oPes2 := TComboBox():New( _nLini, _nColi+5, { |u| If( PCount() > 0, _cPes2 := u, _cPes2 )}, _aPes2, 050, 014, _oDlg,,{||IndexGrid(_oBrwPed:aArray,_oBrwPed,_cPes2,_aHeadPed,_aFldPed,1)} ,,,,.T.,,,,{|| .T.},,,,, "_cPes2" )

	@ _nLini, _nColi+58 MsGet _cSeek				Size 060, 010 Of _oDlg Pixel
	_oTBut	:= TButton():New( _nLini, _nColi+121, "Pesquisar"	,_oDlg,{|| PesqCpo(_cSeek,_oBrwPed:aArray,_oBrwPed,_cPes2,_aHeadPed,_aFldPed)}	, 30,12,,,.F.,.T.,.F.,,.F.,,,.F. )

	_nLini +=13

	_oBrwPed 		:= TCBrowse():New( _nLini,_nColi,_nColf - _nColi,_nLinf - _nLini,,_aHeadPed,_aColSzPed,_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,.T.,.T.)

	_aBrwPed := {}
	For Fe := 1 To Len(_aFldPed)
		If _aFldPed[Fe][1] = 'Z1_OK'
			AAdd(_aBrwPed,_oRed)
		Else
			AAdd(_aBrwPed,Criavar(_aFldPed[Fe][1]))
		Endif
	Next Fe

	_oBrwPed:SetArray(_aBrwPed)

	_oBrwPed:bLine := {|| GetArray(_oBrwPed,_aBrwPed,_aFldPed)}

Return(Nil)



Static Function BoxBut(_aPos)

	Local _nLini	:= _aPos[1]
	Local _nColi 	:= _aPos[2]
	Local _nLinf 	:= _aPos[3] - _nRodape
	Local _nColf 	:= _aPos[4]

	_oGrupo3		:= TGroup():New( _nLini,_nColi,_nLinf,_nColf,"Ações",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	_nAltura	:= 009
	_nEspaco	:= 010
	_nCol		:= _nColi += 6

	//	_oBt_Cli      := TButton():New( _nLini+=_nEspaco ,_nCol,"Cliente" 			, _oDlg		, {||  MATA030()  } ,050,_nAltura,,          ,,.T.,,"",,,,.F. )
	_oBt_Mot      := TButton():New( _nLini+=_nEspaco ,_nCol,"Motorista" 		, _oDlg		, {||  u_Miz010() } ,050,_nAltura,,          ,,.T.,,"",,,,.F. )
	_oBt_Tra      := TButton():New( _nLini+=_nEspaco ,_nCol,"Transportadora"	, _oDlg		, {||  MATA050()  } ,050,_nAltura,,          ,,.T.,,"",,,,.F. )
	_oBt_Cam      := TButton():New( _nLini+=_nEspaco ,_nCol,"Caminhão"			, _oDlg		, {||  u_Miz005() } ,050,_nAltura,,          ,,.T.,,"",,,,.F. )
	_oBt_Car      := TButton():New( _nLini+=_nEspaco ,_nCol,"Carreta"			, _oDlg		, {||  u_Miz1030()} ,050,_nAltura,,          ,,.T.,,"",,,,.F. )
	_nLini+=_nEspaco
	oBt_Ped      := TButton():New( _nLini+=_nEspaco ,_nCol,"Pedido Mizu" 		, _oDlg		, {||  u_Miz016() } ,050,_nAltura,,          ,,.T.,,"",,,,.F. )
	oBt_Age      := TButton():New( _nLini+=_nEspaco ,_nCol,"Agenciamento" 		, _oDlg		, {||  u_Miz996() } ,050,_nAltura,,          ,,.T.,,"",,,,.F. )

	//	If !_lAcesso
	//		_oBt_Cli:Disable()
	//		_oBt_Mot:Disable()
	//		_oBt_Tra:Disable()
	//		_oBt_Cam:Disable()
	//		_oBt_Car:Disable()
	//	Endif

Return(Nil)



Static Function BoxRod(_aPos1,_aPos3)

	Local _nLini	:= _aPos1[3] - _nRodape+2
	Local _nColi 	:= _aPos1[2]
	Local _nLinf 	:= _aPos1[3]
	Local _nColf 	:= _aPos3[4]

	_oGrupo4		:= TGroup():New( _nLini,_nColi,_nLinf,_nColf,"Legenda",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	_nLin1	:= _nLini + 8
	_nLin2	:= _nLin1 + 10
	_nCol1	:= _nColi + 2
	_nCol2	:= _nColi + 15
	_nColA	:= _nColi + 2
	_nColB	:= _nColi + 15

	_oBmp1	:= TBitmap():New( _nLin1,_nCol1,008,008,,"CHECKOK"		,.T.,_oDlg,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	_oSay1	:= TSay():New( _nLin1,_nCol2,{||"Programação em aberto"},_oDlg,,_oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
	_oBmpA	:= TBitmap():New( _nLin2,_nColA,008,008,,"BR_LARANJA"	,.T.,_oDlg,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	_oSayA	:= TSay():New( _nLin2,_nColB,{||"Cliente com Título vencido"}	,_oDlg,,_oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)

	_nTam	:= 110
	_oBmp2	:= TBitmap():New( _nLin1,_nCol1+=_nTam,008,008,,"XCLOSE"	,.T.,_oDlg,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	_oSay2	:= TSay():New( _nLin1,_nCol2+=_nTam,{||"Programação com Pedido gerado"},_oDlg,,_oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
	_oBmpB	:= TBitmap():New( _nLin2,_nColA+=_nTam,008,008,,"BR_CINZA"	,.T.,_oDlg,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	_oSayB	:= TSay():New( _nLin2,_nColB+=_nTam,{||"Cliente com Risco D ou E"}		,_oDlg,,_oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)

	_nTam	:= 130
	_oBmp3	:= TBitmap():New( _nLin1,_nCol1+=_nTam,008,008,,"BR_AMARELO"	,.T.,_oDlg,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	_oSay3	:= TSay():New( _nLin1,_nCol2+=_nTam,{||"Data do SCI vencido"}	,_oDlg,,_oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
	_oBmpC	:= TBitmap():New( _nLin2,_nColA+=_nTam,008,008,,"BR_AZUL"		,.T.,_oDlg,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	_oSayC	:= TSay():New( _nLin2,_nColB+=_nTam,{||"Data do SINTEGRA vencido"},_oDlg,,_oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)

	_nTam	:= 110
	_oBmp4	:= TBitmap():New( _nLin1,_nCol1+=_nTam,008,008,,"BR_VERMELHO"	,.T.,_oDlg,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	_oSay4	:= TSay():New( _nLin1,_nCol2+=_nTam,{||"Pedido Bloqueado"}		,_oDlg,,_oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
	_oBmpD	:= TBitmap():New( _nLin2,_nColA+=_nTam,008,008,,"BR_MARROM"	,.T.,_oDlg,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	_oSayD	:= TSay():New( _nLin2,_nColB+=_nTam,{||"Pedido Cancelado"}		,_oDlg,,_oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)

	_nTam	:= 080
	_oBmp5	:= TBitmap():New( _nLin1,_nCol1+=_nTam,008,008,,"BR_VERDE"		,.T.,_oDlg,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	_oSay5	:= TSay():New( _nLin1,_nCol2+=_nTam,{||"Pedido Liberado"}		,_oDlg,,_oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
	_oBmpE	:= TBitmap():New( _nLin2,_nColA+=_nTam,008,008,,"BR_BRANCO"	,.T.,_oDlg,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	_oSayE	:= TSay():New( _nLin2,_nColB+=_nTam,{||'Cliente Bloqueado'}		,_oDlg,,_oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)

	//

	_nTam	:= 080
	_oBmp6	:= TBitmap():New( _nLin1,_nCol1+=_nTam,008,008,,"BR_PRETO"		,.T.,_oDlg,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	_oSay6	:= TSay():New( _nLin1,_nCol2+=_nTam,{||"Data do SCI e SINTEGRA vencidos"},_oDlg,,_oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
	_oBmpF	:= TBitmap():New( _nLin2,_nColA+=_nTam,008,008,,"BR_PINK"	,.T.,_oDlg,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	_oSayF	:= TSay():New( _nLin2,_nColB+=_nTam,{||"S/ Limite Crédito ou Excedido"}		,_oDlg,,_oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)

Return(Nil)



Static Function GetArray(_oBrw,_aBrw,_aFld)

	_aRet := {}
	For Fb := 1 To Len(_aFld)
		If _aFld[Fb][1] == "C6_OK"
			If _aBrw[_oBrw:nAt,Fb] = "0"
				AAdd(_aRet,  _oClose)
			ElseIf _aBrw[_oBrw:nAt,Fb] = "1"
				AAdd(_aRet,  _oBlack)
			ElseIf _aBrw[_oBrw:nAt,Fb] = "2"
				AAdd(_aRet,  _oYellow)
			ElseIf _aBrw[_oBrw:nAt,Fb] = "3"
				AAdd(_aRet,  _oBlue)
			ElseIf _aBrw[_oBrw:nAt,Fb] = "4"
				AAdd(_aRet,  _oChekOK)
			ElseIf _aBrw[_oBrw:nAt,Fb] = "5"
				AAdd(_aRet,  _oOrange)
			ElseIf _aBrw[_oBrw:nAt,Fb] = "6"
				AAdd(_aRet,  _oWhite)
			ElseIf _aBrw[_oBrw:nAt,Fb] = "7"
				AAdd(_aRet,  _oPink)
			ElseIf _aBrw[_oBrw:nAt,Fb] = "8"
				AAdd(_aRet,  _oGray)
			Endif
		ElseIf _aFld[Fb][3] = 'N'
			AAdd(_aRet,  Alltrim(Transform(_aBrw[_oBrw:nAT,Fb],'@E 99,999,999,999.99')))
		Else
			AAdd(_aRet, _aBrw[_oBrw:nAt,Fb])
		Endif
	Next Fb

Return(_aRet)



//Pesquisar o campo informado na listbox
Static Function PesqCpo(_cString,_aVet,_oObj,_cPesq,_aPesq,_aFld)

	Local _nPos	 := 0
	Local _nElem := aScan(_aPesq,_cPesq)//{|y| y[1] == _cPesq})

	//³Realiza a pesquisa³
	_cString := AllTrim(Upper(_cString))
	_nPos	 := aScan(_aVet,{|x| _cString $ If(Valtype(x[_nElem]) = "D",dToc(x[_nElem]), Upper(x[_nElem]))})
	_lRet	 := (_nPos != 0)

	//³Se encontrou, posiciona o objeto ³
	If _lRet
		_oObj:nAt := _nPos
		_oObj:Refresh()
	EndIf

Return(Nil)



Static Function IndexGrid(_aVet,_oObj,_cPesq,_aPesq,_aFld,_nOpc)

	Local _nElem := aScan(_aPesq,_cPesq)//{|y| y[1] == _cPesq})

	_aCols := ASORT(_aVet, , , { | x,y | y[_nElem] > x[_nElem] } )
	_oObj:SetArray(_aCols)

	_oObj:bLine := {|| GetArray(_oObj,_aVet,_aFld)}
	If _nOpc = 1
		_oObj:nAt := 1
	Endif
	_oObj:Refresh()

Return()



Static Function MZ223D()

	Local _oDlg2 	:= Nil
	Local _nPosPro	:= aScan(_aFldPro,{|x| x[1] == 'C6_NUM' })
	Local _cNumPro	:= _aBrwPro[_oBrwPro:nAt][_nPosPro]
	Local _nPosPrd	:= aScan(_aFldPro,{|x| x[1] == 'C6_PRODUTO' })
	Local _cProdut	:= _aBrwPro[_oBrwPro:nAt][_nPosPrd]
	Local _nPosQtd	:= aScan(_aFldPro,{|x| x[1] == 'C6_QTDVEN' })
	Local _nQuanti	:= _aBrwPro[_oBrwPro:nAt][_nPosQtd]
	Local _nPosGPe	:= aScan(_aFldPro,{|x| x[1] == 'C6_YPEDGER' })
	Local _cGerPed	:= _aBrwPro[_oBrwPro:nAt][_nPosGPe]
	Local _nPosOK	:= aScan(_aFldPro,{|x| x[1] == 'C6_OK' })
	Local _cOK		:= _aBrwPro[_oBrwPro:nAt][_nPosOK]
	Local _aHeadGet	:= {}
	Local _aColsGet	:= {}
	Local _aAlter	:= {"Z1_DTENT","Z1_QUANT","Z1_PALLET","Z1_OBRA","Z1_MOTOR","Z1_COMDESC","Z1_TPF","Z1_FRETE","Z1_YTIPF","Z1_OBSER","Z1_PLACA",;
	"Z1_MENS01","Z1_MENS02","Z1_MENS03"}

	Local _aSize	:= MsAdvSize(.F.)
	Local _aObjects	:= {}

	If _cOK = '0'
		ShowHelpDlg("MZ0223", {'Programação já foi transformada em Pedido.'},2,{'Não é possivel gerar Pedido.'},2)
		Return(Nil)
	ElseIf _cOK = '1'
		ShowHelpDlg("MZ0223", {'Cliente esta com a data de atualização do SCI e do SINTEGRA vencidos.'},2,{'Não é possivel gerar Pedido.'},2)
		Return(Nil)
	ElseIf _cOK = '2'
		ShowHelpDlg("MZ0223", {'Cliente esta com a data de atualização do SINTEGRA vencido.'},2,{'Não é possivel gerar Pedido.'},2)
		Return(Nil)
	ElseIf _cOK = '3'
		ShowHelpDlg("MZ0223", {'Cliente está com a data de atualização do SCI vencido.'},2,{'Não é possivel gerar Pedido.'},2)
		Return(Nil)
	ElseIf _cOK = "5"
		ShowHelpDlg("MZ0223", {'Cliente com título Vencido.'},2,{'Não é possivel gerar Pedido.'},2)
		Return(Nil)
	ElseIf _cOK = "6"
		ShowHelpDlg("MZ0223", {'Cliente Bloqueado.'},2,{'Não é possivel gerar Pedido.'},2)
		Return(Nil)
	ElseIf _cOK = "7"
		ShowHelpDlg("MZ0223", {'Cliente sem Limite de Crédito ou Excedido.'},2,{'Não é possivel gerar Pedido.'},2)
		Return(Nil)
	ElseIf _cOK = "8"
		ShowHelpDlg("MZ0223", {'Cliente com Risco D ou E.'},2,{'Não é possivel gerar Pedido.'},2)
		Return(Nil)
	Endif

	AAdd( _aObjects, { 100 , 100, .T. , .T. , .F. } )

	_aInfo := { _aSize[ 1 ], _aSize[ 2 ], _aSize[ 3 ], _aSize[ 4 ], 5 , 5 , 5 , 5 }
	_aPosObj := MsObjSize( _aInfo, _aObjects, .T. , .T. )

	_oDadosGet		:= Nil
	_nUsadGet		:= 0
	_nQtPed			:= 0

	_nLini	:= _aPosObj[1][1]
	_nColi 	:= _aPosObj[1][2]
	_nLinf 	:= _aPosObj[1][3]
	_nColf 	:= _aPosObj[1][4]


	DEFINE MSDIALOG _oDlg2 TITLE "Programação X Pedido" FROM _aSize[7],_aSize[1] to _aSize[6],_aSize[5] PIXEL Style DS_MODALFRAME

	_oDlg2:lEscClose := .F. //Não permite fechar a janela pelo botão "ESC"

	//	_oGroup1	:= TGroup():New( 005,005,025,500,"",_oDlg2,CLR_HRED,CLR_WHITE,.T.,.F. )
	_oGrupo1	:= TGroup():New( _nLini,_nColi,_nLinf,_nColf,"",_oDlg2,CLR_HRED,CLR_WHITE,.T.,.F. )

	_oSay1		:= TSay():New( 012,010,{||"Programação:"}		,_oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	_oGet1		:= TGet():New( 011,050,{|u| If(PCount()>0,_cNumPro:=u,_cNumPro)}		,_oDlg2,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","_cNumPro",,)
	_oGet1:Disable()

	_oSay4		:= TSay():New( 012,110,{||"Produto:"}		,_oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	_oGet4		:= TGet():New( 011,150,{|u| If(PCount()>0,_cProdut:=u,_cProdut)}		,_oDlg2,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","_cProdut",,)
	_oGet4:Disable()

	_oSay5		:= TSay():New( 012,210,{||"Quantidade:"}		,_oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	_oGet5		:= TGet():New( 011,250,{|u| If(PCount()>0,_nQuanti:=u,_nQuanti)}		,_oDlg2,040,008,'@E 9,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","_nQuanti",,)
	_oGet5:Disable()

	//	_oGroup2	:= TGroup():New( 027,005,047,500,"",_oDlg2,CLR_HRED,CLR_WHITE,.T.,.F. )

	_oSay2		:= TSay():New( 032,010,{||"Defina a quantidade de Pedidos que será gerado pela programação:"}	,_oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,300,008)
	_oGet2		:= TGet():New( 031,175,{|u| If(PCount()>0,_nQtPed:=u,_nQtPed)}	,_oDlg2,020,008,'@E 999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_nQtPed",,)
	_oBtn3		:= TBtnBmp2():New( 60,400,25,25,'PEDIDO',,,,{|| LjMsgRun("Gerando Grid, aguarde...","Programação x Pedido",{||AtuGrid()})},_oDlg2,'Gerar Pedido')

	SX3->(DbSetOrder(1))
	If SX3->(msSeek("SZ1"))

		While SX3->(!EOF()) .And. SX3->X3_ARQUIVO == "SZ1"

			If X3USO(SX3->X3_USADO)  .And. cNivel >= SX3->X3_NIVEL

				If SX3->X3_CAMPO = 'Z1_QUANT'
					aAdd(_aHeadGet, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,'',SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT})
				ElseIf SX3->X3_CAMPO = 'Z1_OBRA'
					aAdd(_aHeadGet, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,'U_MZ223OBRA()',SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT})
				Else
					aAdd(_aHeadGet, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT})
				Endif
				_nUsadGet++
			Endif

			SX3->(dbSkip())
		EndDo
	Endif

	_aColsGet := {}
	Aadd(_aColsGet,Array(Len(_aHeadGet)+1))

	_aColsGet[Len(_aColsGet),_nUsadGet+1] := .F.

	_oDadosGet	:= MsNewGetDados():New(_nLini+50,_nColi+5,_nLinf-20,_nColf-5,GD_UPDATE,"AlwaysTrue()","AllwaysTrue()",,_aAlter,,,,,,_oDlg2,_aHeadGet,_aColsGet)

	_bGeraPed	:= '{|| If(u_GrvMZ223(),_oDlg2:End(),Nil)}'
	_oBtn1		:= TButton():New( _nLinf-15,_nColf-110,"Cancelar"			,_oDlg2,{|| _oDlg2:End()}	,050,012,,,,.T.,,"",,,,.F. )
	_oBtn2		:= TButton():New( _nLinf-15,_nColf-55,"Gerar Pedido(s)"		,_oDlg2,&(_bGeraPed)		,050,012,,,,.T.,,"",,,,.F. )

	Activate MsDialog _oDlg2 Centered

Return(Nil)



Static Function AtuGrid()

	Local _lRet := .F.

	If _nQtPed > 0

		_nPNum  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_NUM"})
		_nPCli  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_CLIENTE"})
		_nPLoj  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_LOJA"})
		_nPEmi  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_EMISSAO"})
		_nPHor  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_HORAPED"})
		_nPEnt  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_DTENT"})
		_nPPro  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_PRODUTO"})
		_nPQtd  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_QUANT"})
		_nPVlR  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_PCOREF"})
		_nPTip  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_TIPO"})
		_nPUsu  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_USUARIO"})
		_nPTES  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_TES"})
		_nPLib  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_LIBER"})
		_nPDLi  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_YDTLIB"})
		_nPPrg  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_PEDIDO"})
		_nPItP  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_ITEMPV"})
		_nPHrE  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_HORENTG"})
		_nPHrL  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_HLIB"})
		_nPVIA  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_TPF"})
		_nPCDES := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_COMDESC"})
		_nPOBRA := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_OBRA"})
		_nPPALL := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_PALLET"})
		_nPMOTO := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_MOTOR"})
		_nPME01 := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_MENS01"})
		_nPME02 := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_MENS02"})
		_nPME03 := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_MENS03"})
		_nPPLAC := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_PLACA"})
		_nPOBSE := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_OBSER"})
		_nPUNID	:= Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_UNID"})
		_nPYTP	:= Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_YTIPO"})

		_nPYPAL	:= Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_YCDPALM"}) //C5_YCDPALM
		_nPYDIM	:= Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_YDTIMPR"}) //C5_YDTIMPR
		_nPYITP	:= Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_YITPPAL"}) //C6_YITPPAL
		_nPYORI	:= Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_YORIGPD"}) //“GEOSALES”

		_lRet  := .T.
		_aCols := {}
		_nCont := 0

		_nQtde := Round(_aBrwPro[_oBrwPro:nAt][Ascan(_aFldPro,{|x| x[1] == "C6_QTDVEN"})] / _nQtPed,TamSx3("Z1_QUANT")[2])
		_cCli  := _aBrwPro[_oBrwPro:nAt][Ascan(_aFldPro,{|x| x[1] == "C6_CLI"		})]
		_cLj   := _aBrwPro[_oBrwPro:nAt][Ascan(_aFldPro,{|x| x[1] == "C6_LOJA"		})]
		_cProd := _aBrwPro[_oBrwPro:nAt][Ascan(_aFldPro,{|x| x[1] == "C6_PRODUTO"	})]
		_nVlUn := _aBrwPro[_oBrwPro:nAt][Ascan(_aFldPro,{|x| x[1] == "C6_PRCVEN"	})]
		_cPedi := _aBrwPro[_oBrwPro:nAt][Ascan(_aFldPro,{|x| x[1] == "C6_NUM"		})]
		_cItem := _aBrwPro[_oBrwPro:nAt][Ascan(_aFldPro,{|x| x[1] == "C6_ITEM"		})]
		_cYTip := 'N'
		_cTipo := _aBrwPro[_oBrwPro:nAt][Ascan(_aFldPro,{|x| x[1] == "C5_YTIPOPD"	})]
		_dEntr := _aBrwPro[_oBrwPro:nAt][Ascan(_aFldPro,{|x| x[1] == "C6_ENTREG"	})]
		_cUM   := _aBrwPro[_oBrwPro:nAt][Ascan(_aFldPro,{|x| x[1] == "C6_UM"		})]

		_cCDPa := _aBrwPro[_oBrwPro:nAt][Ascan(_aFldPro,{|x| x[1] == "C5_YCDPALM"	})]
		_dDtIm := _aBrwPro[_oBrwPro:nAt][Ascan(_aFldPro,{|x| x[1] == "C5_YDTIMPR"	})]
		_cItPa := _aBrwPro[_oBrwPro:nAt][Ascan(_aFldPro,{|x| x[1] == "C6_YITPPAL"	})]
		_cOrig := _aBrwPro[_oBrwPro:nAt][Ascan(_aFldPro,{|x| x[1] == "C5_YORIGPD"	})]

		For J := 1 To _nQtPed
			_nCont++
			AADD(_aCols,Array(_nUsadGet+1))

			_cNum  := GETSX8NUM("SZ1","Z1_NUM")
			_cHora := TIME()
			ConfirmSx8()

			_aCols[_nCont][_nPNum]  := _cNum
			_aCols[_nCont][_nPCli]  := _cCli
			_aCols[_nCont][_nPLoj]  := _cLj
			_aCols[_nCont][_nPEmi]  := dDataBase
			_aCols[_nCont][_nPHor]  := _cHora
			_aCols[_nCont][_nPEnt]  := _dEntr
			_aCols[_nCont][_nPPro]  := _cProd
			_aCols[_nCont][_nPQtd]  := _nQtde
			_aCols[_nCont][_nPVlR]  := _nVlUn
			_aCols[_nCont][_nPTip]  := _cTipo
			_aCols[_nCont][_nPUsu]  := Alltrim(USRRETNAME(RETCODUSR()))
			_aCols[_nCont][_nPDLi]  := dDataBase
			_aCols[_nCont][_nPPrg]  := _cPedi
			_aCols[_nCont][_nPItP]  := _cItem
			_aCols[_nCont][_nPHrE]  := _cHora
			_aCols[_nCont][_nPHrL]  := _cHora
			_aCols[_nCont][_nPVIA]  := "R"
			_aCols[_nCont][_nPCDES] := "N"
			_aCols[_nCont][_nPOBRA] := Space(TamSX3("Z1_OBRA")[1])
			_aCols[_nCont][_nPPALL] := Space(TamSX3("Z1_PALLET")[1])
			_aCols[_nCont][_nPMOTO] := Space(TamSX3("Z1_MOTOR")[1])
			_aCols[_nCont][_nPME01] := Space(TamSX3("Z1_MENS01")[1])
			_aCols[_nCont][_nPME02] := Space(TamSX3("Z1_MENS02")[1])
			_aCols[_nCont][_nPME03] := Space(TamSX3("Z1_MENS03")[1])
			_aCols[_nCont][_nPPLAC] := Space(TamSX3("Z1_PLACA")[1])
			_aCols[_nCont][_nPOBSE] := Space(TamSX3("Z1_OBSER")[1])
			_aCols[_nCont][_nPUNID] := _cUM
			If _nPYTP > 0
				_aCols[_nCont][_nPYTP]  := _cYTip
			Endif
			_aCols[_nCont][_nPYPAL] := _cCDPa
			_aCols[_nCont][_nPYDIM] := _dDtIm
			_aCols[_nCont][_nPYITP] := _cItPa
			_aCols[_nCont][_nPYORI] := If(!Empty(_cOrig),_cOrig,If(!Empty(_cCDPa) .And. !Empty(_dDtIm) .And. !Empty(_cItPa),'GEOSALES',''))

			_lGo := AtuGat(_aCols,_nCont,_cCli,_cLj,_cProd,_nQtde,_nVlUn,_cTipo)

			_aCols[_nCont][_nUsadGet+1] := .F.

			If !_lGo
				Exit
			Endif
		Next J

		_oDadosGet:SetArray ( _aCols, .T.)
		_oDadosGet:ForceRefresh()

	Else
		ShowHelpDlg("MZ0223", {'Quantidade de Pedidos Incorreto.'},2,{'Informe quantidade superior a zero.'},2)
	Endif

Return(_lRet)



Static Function AtuGat(_aCols,_nCont,_cCli,_cLj,_cProd,_nQtde,_nVlUn,_cTipo)

	Local lFazerAnalise := .T.

	_aAliOri  := GetArea()
	_aAliSA1  := SA1->(GetArea())
	_aAliSZ3  := SZ3->(GetArea())
	_aAliZA6  := ZA6->(GetArea())

	_nPTes  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_TES"})
	_nPNCl  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_NOMCLI"})
	_nPMes  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_YMESCR"})
	_nPMic  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_YMICRE"})
	_nPReg  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_YREGIA"})
	_nPYTe  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_YTELVEN"})
	_nPCoP  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_COND"})
	_nPVen  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_VEND"})
	_nPPcD  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_PCDESC"})
	_nPLoc  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_LOCAL"})
	_nPMun  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_MUNE"})
	_nPUFe  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_UFE"})
	_nPMe1  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_MENS01"})
	_nPMe2  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_MENS02"})
	_nPMe3  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_MENS03"})
	_nPYTi  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_YTIPF"})
	_nPFre  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_FRETE"})
	_nPPla  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_PLACA"})
	_nPMuF  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_MUNFRT"})
	_nPUFF  := Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_UFFRT"})

	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1") + _cCli + _cLj))

	_aCols[_nCont][_nPNCl] := SA1->A1_NOME

	If SZ1->(Fieldpos("Z1_YMESCR")) > 0
		_aCols[_nCont][_nPMes] := SA1->A1_YMESCR
	Endif

	If SZ1->(Fieldpos('Z1_YMICRE')) > 0
		_aCols[_nCont][_nPMic] := SA1->A1_YMICRE
	Endif
	If SZ1->(Fieldpos('Z1_YREGIA')) > 0
		_aCols[_nCont][_nPReg] := SA1->A1_YREGIA
	Endif

	If SZ1->(Fieldpos('Z1_YTELVEN')) > 0
		_aCols[_nCont][_nPYTe] := SA1->A1_YTELVEN
	Endif

	If SA1->A1_RISCO == "D" .Or. SA1->A1_RISCO == "E"

		_aCols := {}
		Aadd(_aCols,Array(Len(_oDadosGet:aHeader)+1))

		For nI := 1 To _nUsadGet
			_aCols[1][nI] := CriaVar(_oDadosGet:aHeader[nI][2])
		Next
		_aCols[1][1] := Space(TamSx3("Z1_NUM")[1])

		RestArea(_aAliSA1)
		RestArea(_aAliSZ3)
		RestArea(_aAliZA6)
		RestArea(_aAliOri)

		ShowHelpDlg("MZ0223", {'Cliente com risco "D" ou "E".'},2,{'Contate o Financeiro para ajuste do grau de risco do Cliente.'},2)

		Return(.F.)
	Endif

	ddta      	 := ctod(Space(8))
	_cCond       := Space(03)

	ZA6->(dbSetOrder(1))
	If ZA6->(dbSeek(xFilial("ZA6") + SA1->A1_COD + SA1->A1_LOJA + "L"))
		_aCols[_nCont][_nPCoP] := ZA6->ZA6_PRAZO
		_cCond     := ZA6->ZA6_PRAZO
	EndIf

	If SA1->A1_YLIB == "N" .OR. SA1->A1_MSBLQL == "1"

		If SA1->A1_MSBLQL == "1"
			ShowHelpDlg("MZ0223", {'Cadastro do cliente bloqueado!'},2,{'Solicite ao Responsavel liberar o cadastro do cliente antes de colocar pedidos para o mesmo.'},2)
		Else
			ShowHelpDlg("MZ0223", {'Cliente não está liberado(Campo Liberado no cadastro de cliente como N )!'},2,{'Solicite ao Responsavel liberar o cliente antes de colocar pedidos para o mesmo.'},2)
		EndIf

		_aCols := {}
		Aadd(_aCols,Array(Len(_oDadosGet:aHeader)+1))

		For nI := 1 To _nUsadGet
			_aCols[1][nI] := CriaVar(_oDadosGet:aHeader[nI][2])
		Next
		_aCols[1][1] := Space(TamSx3("Z1_NUM")[1])

		RestArea(_aAliSA1)
		RestArea(_aAliSZ3)
		RestArea(_aAliZA6)
		RestArea(_aAliOri)

		Return(.F.)
	Endif

	IF ( ALLTRIM(_cProd) $ GETNEWPAR('MV_SMREENS',' ')  .and. cEmpAnt + cFilAnt $ '0210|3001') // Quando For produto de Reensaque não Verificar Preco - Juailson Semar 01/04/2015
		lPrdReensaque := .T.
	ELSE
		lPrdReensaque := .F.
	ENDIF

	IF ( lPrdReensaque  .And. cEmpAnt + cFilAnt $ '0210|3001')

		IF MSGYESNO("Atenção: Produto de Reensaque, liberar cliente de ANALISE CREDITO?", "MsgAlertA"  )
			lFazerAnalise := .F.
		ENDIF
	Endif
	//
	If Alltrim(Funname()) <> "RPC"  .and. lFazerAnalise

		If (ddatabase - SA1->A1_YBLQSCI) < GetMV("MV_YBLQSCI")  .and. (ddatabase - SA1->A1_YBLQSIN) < GetMV("MV_YBLQSIN")
			cRet := _cCli
		ElseIf (ddatabase - SA1->A1_YBLQSCI) > GetMV("MV_YBLQSCI")  .and. (ddatabase - SA1->A1_YBLQSIN) > GetMV("MV_YBLQSIN")
			ShowHelpDlg("MZ0223", {'Cliente solicitado esta com a data de atualizacao do SCI e do SINTEGRA vencidos!'},2,{'Solicite atualização do cadastro de Cliente.'},2)

			_aCols := {}
			Aadd(_aCols,Array(Len(_oDadosGet:aHeader)+1))

			For nI := 1 To _nUsadGet
				_aCols[1][nI] := CriaVar(_oDadosGet:aHeader[nI][2])
			Next
			_aCols[1][1] := Space(TamSx3("Z1_NUM")[1])

			RestArea(_aAliSA1)
			RestArea(_aAliSZ3)
			RestArea(_aAliZA6)
			RestArea(_aAliOri)

			Return(.F.)
		EndIf

		If (ddatabase - SA1->A1_YBLQSCI) < GetMV("MV_YBLQSCI")
			cRet := _cCli
		Else

			ShowHelpDlg("MZ0223", {'Cliente solicitado está com a data de atualizacao do SCI vencido!'},2,{'Solicite atualização do cadastro de Cliente.'},2)

			_aCols := {}
			Aadd(_aCols,Array(Len(_oDadosGet:aHeader)+1))

			For nI := 1 To _nUsadGet
				_aCols[1][nI] := CriaVar(_oDadosGet:aHeader[nI][2])
			Next
			_aCols[1][1] := Space(TamSx3("Z1_NUM")[1])

			RestArea(_aAliSA1)
			RestArea(_aAliSZ3)
			RestArea(_aAliZA6)
			RestArea(_aAliOri)

			Return(.F.)
		EndIf

		If (ddatabase - SA1->A1_YBLQSIN) < GetMV("MV_YBLQSIN")
			cRet := _cCli
		Else
			ShowHelpDlg("MZ0223", {'Cliente solicitado está com a data de atualizacao do Sintegra vencido!'},2,{'Solicite atualização do cadastro de Cliente.'},2)

			_aCols := {}
			Aadd(_aCols,Array(Len(_oDadosGet:aHeader)+1))

			For nI := 1 To _nUsadGet
				_aCols[1][nI] := CriaVar(_oDadosGet:aHeader[nI][2])
			Next
			_aCols[1][1] := Space(TamSx3("Z1_NUM")[1])

			RestArea(_aAliSA1)
			RestArea(_aAliSZ3)
			RestArea(_aAliZA6)
			RestArea(_aAliOri)

			Return(.F.)
		EndIf

		ZA6->(dbSetOrder(1))
		If ZA6->(!dbSeek(xFilial("ZA6") + SA1->A1_COD + SA1->A1_LOJA + "L"))
			ShowHelpDlg("MZ0223", {'Cliente solicitado está Sem Limite de Credito!'},2,{'Solicite atualização do cadastro de Cliente.'},2)

			_aCols := {}
			Aadd(_aCols,Array(Len(_oDadosGet:aHeader)+1))

			For nI := 1 To _nUsadGet
				_aCols[1][nI] := CriaVar(_oDadosGet:aHeader[nI][2])
			Next
			_aCols[1][1] := Space(TamSx3("Z1_NUM")[1])

			RestArea(_aAliSA1)
			RestArea(_aAliSZ3)
			RestArea(_aAliZA6)
			RestArea(_aAliOri)

			Return(.F.)
		EndIf

		If _cCond != "100"
			_lBloq := .F.
			If SA1->A1_RISCO != "S"

				_dData    := Date()
				_lFSemana := .F.
				If Dow(_dData) == 7      // SABADO
					_dData    := _dData - 2
					_lFSemana := .T.
				ElseIf Dow(_dData) == 1  // DOMINGO
					_dData    := _dData - 3
					_lFSemana := .T.
				ElseIf Dow(_dData) == 2  // SEGUNDA
					//				_dData    := _dData - 4
					_dData    := _dData - 3	// Marcus Vinicius - 26/07/2016 - Alterado para validar os títulos vencidos na sexta-feira.
					_lFSemana := .T.
				Else
					_dData    := _dData -1
				Endif

				_lBloq := .F.

				//If cEmpAnt == "01" .And. cFilAnt == "04" 		Comentado por Alison - 18/04/18
				If cEmpAnt + cFilAnt $ "0104|0222"
					_cQ:= " SELECT E1_CLIENTE,E1_LOJA,E1_NOMCLI,E1_VENCREA, SUM(E1_SALDO) AS SALDO FROM SE1200 A "
					If !Empty(SA1->A1_GRPVEN)
						_cQ+= " INNER JOIN "+RetSqlName("SA1")+" A1 ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA "
					Endif
					_cQ+= " WHERE A.D_E_L_E_T_ = '' AND E1_VENCREA <= '"+Dtos(_dData)+"' AND E1_SALDO > 0 "
					_cQ+= " AND E1_YOBSLIB = '' AND E1_TIPO NOT IN ('NCC','RA','NP','PR')"
					If !Empty(SA1->A1_GRPVEN)
						_cQ+= " AND A1.D_E_L_E_T_ = '' AND A1_GRPVEN = '"+SA1->A1_GRPVEN+"' "
					Else
						_cQ+= " AND E1_CLIENTE = '"+SA1->A1_COD+"' "
					Endif
					_cQ+= " GROUP BY E1_CLIENTE,E1_LOJA,E1_NOMCLI,E1_VENCREA "
					_cQ+= " ORDER BY E1_CLIENTE,E1_LOJA,E1_NOMCLI,E1_VENCREA DESC"

					TCQUERY _cQ NEW ALIAS "ZZ"

					TCSETFIELD("ZZ","E1_VENCREA","D")

					ZZ->(dbGotop())

					While ZZ->(!Eof()) .And. !_lBloq

						If ZZ->E1_VENCREA == _dData
							If !_lFSemana
								If Left(Time(),2) >= "11"
									_lBloq := .T.
								Endif
							Else
								_lBloq := .T.
							Endif
						Else
							_lBloq := .T.
						Endif

						ZZ->(dbSkip())
					EndDo

					ZZ->(dbCloseArea())
				Endif

				_cQ:= " SELECT E1_CLIENTE,E1_LOJA,E1_NOMCLI,E1_VENCREA, SUM(E1_SALDO) AS SALDO FROM "+RetSqlName("SE1")+" A "
				If !Empty(SA1->A1_GRPVEN)
					_cQ+= " INNER JOIN "+RetSqlName("SA1")+" A1 ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA "
				Endif
				_cQ+= " WHERE A.D_E_L_E_T_ = '' AND E1_VENCREA <= '"+Dtos(_dData)+"' AND E1_SALDO > 0 "
				_cQ+= " AND E1_YOBSLIB = '' AND E1_TIPO NOT IN ('NCC','RA','NP','PR')"
				If !Empty(SA1->A1_GRPVEN)
					_cQ+= " AND A1.D_E_L_E_T_ = '' AND A1_GRPVEN = '"+SA1->A1_GRPVEN+"' "
				Else
					_cQ+= " AND E1_CLIENTE = '"+SA1->A1_COD+"' "
				Endif
				_cQ+= " GROUP BY E1_CLIENTE,E1_LOJA,E1_NOMCLI,E1_VENCREA "
				_cQ+= " ORDER BY E1_CLIENTE,E1_LOJA,E1_NOMCLI,E1_VENCREA DESC"

				TCQUERY _cQ NEW ALIAS "ZZ"

				TCSETFIELD("ZZ","E1_VENCREA","D")

				ZZ->(dbGotop())

				While ZZ->(!Eof()) .And. !_lBloq

					If ZZ->E1_VENCREA == _dData
						If !_lFSemana
							If Left(Time(),2) >= "11"
								_lBloq := .T.
							Endif
						Else
							_lBloq := .T.
						Endif
					Else
						_lBloq := .T.
					Endif

					ZZ->(dbSkip())
				EndDo

				ZZ->(dbCloseArea())

				If !_lBloq
					_cQ := " SELECT Z1_CLIENTE,Z1_LOJA,SUM(Z1_QUANT * Z1_PCOREF) AS TOTAL "
					_cQ += " FROM "+RetSqlName("SZ1")+" A WHERE A.D_E_L_E_T_ = '' AND Z1_CLIENTE = '"+SA1->A1_COD+"' "
					_cQ += " AND Z1_LOJA = '"+SA1->A1_LOJA+"' AND Z1_DTCANC = '' "
					_cQ += " GROUP BY Z1_CLIENTE,Z1_LOJA "
					_cQ += " ORDER BY Z1_CLIENTE,Z1_LOJA "

					TCQUERY _cQ NEW ALIAS "ZZ1"

					_nPedido := ZZ1->TOTAL

					ZZ1->(dbCloseArea())

					_nSdoTit := ZA6->ZA6_SDOTIT	+ _nPedido + (_nQtde *_nVlUn)
					_nDif    := ZA6->ZA6_VALOR  - _nSdoTit

					If _nDif < 0
						_nDif := _nDif * -1

						_nPerc   := (_nDif / ZA6->ZA6_VALOR) * 100

						If _nPerc > GETMV("MZ_PERLIM") .and. !lPrdReensaque // Quando for Reesaque não verifica -Juailson Semar 02/04/15
							//							MsgAlert("3 - Limite de Credito Excedido Em "+STR(GETMV("MZ_PERLIM"),2)+" % ")
							ShowHelpDlg("MZ0223", {'3 - Limite de Crédito Excedido em '+ STR(GETMV("MZ_PERLIM"),2)+' %.'},2,{'Solicite atualização do cadastro de Cliente.'},2)
							_aCols := {}
							Aadd(_aCols,Array(Len(_oDadosGet:aHeader)+1))

							For nI := 1 To _nUsadGet
								_aCols[1][nI] := CriaVar(_oDadosGet:aHeader[nI][2])
							Next
							_aCols[1][1] := Space(TamSx3("Z1_NUM")[1])

							RestArea(_aAliSA1)
							RestArea(_aAliSZ3)
							RestArea(_aAliZA6)
							RestArea(_aAliOri)

							Return(.F.)
						Endif
					Endif
				Endif
			Endif

			If _lBloq
				If Empty(SA1->A1_GRPVEN)
					ShowHelpDlg("MZ0223", {'Cliente Com Titulo Vencido.'},2,{'Verificar com o Departamento Financeiro.'},2)

				Else

					If MsgNoYes("O Grupo tem Cliente(s) com titulo(s) vencido(s), favor verificar com Financeiro."+CRLF+CRLF+;
					"Deseja visualizar quais os Clientes estão com títulos Vencidos?")

						U_MZ0191() //Gera tela com os Clientes do Grupo com títulos vencidos.
					Endif

				Endif
				_aCols := {}
				Aadd(_aCols,Array(Len(_oDadosGet:aHeader)+1))

				For nI := 1 To _nUsadGet
					_aCols[1][nI] := CriaVar(_oDadosGet:aHeader[nI][2])
				Next
				_aCols[1][1] := Space(TamSx3("Z1_NUM")[1])

				RestArea(_aAliSA1)
				RestArea(_aAliSZ3)
				RestArea(_aAliZA6)
				RestArea(_aAliOri)

				Return(.F.)
			Endif
		Endif
	EndIf

	cRet      := ""
	cMVTES	  := ""
	_cEstado  := alltrim(getmv("MV_ESTADO"))

	_aAliSZ3  := SZ3->(GetArea())

	If _cTipo=="N" //VENDA NORMAL

		ZA3->(dbSetOrder(1))
		If ZA3->(dbSeek(xFilial("ZA3")+cEmpAnt + cFilAnt + _cCli + _cLj))
			cRet := ZA3->ZA3_TES
		Else
			SA1->(dbSetOrder(1))
			SA1->(dbseek(xFilial("SA1")+_cCli+_cLj))
			If cfilant=="01" .Or.( cEmpAnt + cFilAnt $ "0203/0208/0210/0213/0223/0216/0226/0218")	// Incluso a empresa 0218 - 18/04/18
				cRet := SA1->A1_YTES
			Else
				cRet := SA1->A1_YTESF
			EndIf
		Endif
	ElseIf _cTipo=="B" //BONIFICACAO
		cMvTes:= 'MV_TESBONI'
	ElseIf _cTipo="F" // VENDA COM ENTRAGA FUTURA
		cMvTes:= 'MV_TESENTF'
	ElseIf _cTipo="R" // REMESSA  POR EMCOMENDA
		cMvTes:= 'MV_TESREME'
	ElseIf _cTipo="C" // VENDA DE PRODUCAO POR CONTA E ORDEM SEM TRANSITAR PELO ESTAB SEM ICMS ST
		cMvTes:= 'MV_TESCONT'
	ElseIf _cTipo="I" // REMESSA INDUSTRIAL POR CONTA E ORDEM SEM TRANSITAR PELO ESTAB DO ADQUIRENTE
		cMvTes:= 'MV_TESINDU'
	Endif

	If Empty(cRet) .AND. !Empty(cMvTes)
		cRet := alltrim(getmv(cMvTes))
	Endif

	If (POSICIONE("SF4",1,xFilial("SF4")+cRet,"F4_MSBLQL") $ "S;1")
		MsgBox("ATENÇÃO: O TES "+cRet+" deste cliente está bloqueado. "+CRLF+"Solicite a verificação no "+IIf(_cTipo=="N","Cadastro do Cliente","Parâmetro "+cMvTes),FunName() )
		cRet:= Space(3)
	Endif

	_aCols[_nCont][_nPTES] := cRet
	_aCols[_nCont][_nPFre] := SA1->A1_TPFRET
	_aCols[_nCont][_nPVen] := SA1->A1_VEND
	If _nPPcD > 0
		_aCols[_nCont][_nPPcD] := SA1->A1_DESC
	Endif
	_aCols[_nCont][_nPLoc] := SA1->A1_ENDENT
	_aCols[_nCont][_nPMun] := SA1->A1_YMUNE
	_aCols[_nCont][_nPUFe] := SA1->A1_YUFE
	_aCols[_nCont][_nPMe1] := SA1->A1_YMENS01
	_aCols[_nCont][_nPMe2] := SA1->A1_YMENS02
	_aCols[_nCont][_nPMe3] := SA1->A1_YMENS03
	_aCols[_nCont][_nPYTi] := SA1->A1_YTIPF
	_aCols[_nCont][_nPPla] := Space(7)

	If SZ1->(FieldPos("Z1_MUNFRT")) > 0 .AND. SZ1->(FieldPos("Z1_UFFRT")) > 0
		_aCols[_nCont][_nPMuF] := SA1->A1_YMUNE
		_aCols[_nCont][_nPUFF] := SA1->A1_YUFE
	EndIf

	RestArea(_aAliSA1)
	RestArea(_aAliSZ3)
	RestArea(_aAliZA6)
	RestArea(_aAliOri)

Return(.T.)



User Function GrvMZ223()

	Local _lRet		:= .T.
	Local _nPosNum	:= aScan(_aFldPro,{|x| x[1] == 'C6_NUM' })
	Local _cProgra	:= _aBrwPro[_oBrwPro:nAt][_nPosNum]
	Local _nPosIte	:= aScan(_aFldPro,{|x| x[1] == 'C6_ITEM' })
	Local _cPrgIte	:= _aBrwPro[_oBrwPro:nAt][_nPosIte]
	Local _nPosQtd	:= aScan(_aFldPro,{|x| x[1] == 'C6_QTDVEN' })
	Local _nQuanti	:= _aBrwPro[_oBrwPro:nAt][_nPosQtd]
	Local _nQtPed	:= 0
	Local _nPPedi	:= Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_NUM"})
	Local _nPQtd	:= Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_QUANT"})
	Local _nPVlR	:= Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_PCOREF"})
	Local _nPTip	:= Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_TIPO"})
	Local _nPFre	:= Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_FRETE"})
	Local _nPMot	:= Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_MOTOR"})
	Local _nPPla	:= Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_PLACA"})
	Local _nPTES	:= Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_TES"})
	Local _nPCon	:= Ascan(_oDadosGet:aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_COND"})
	Local _AreaSC6	:= SC6->(GetArea())
	Local _AreaSA1	:= SA1->(GetArea())
	Local _cCli		:= _aBrwPro[_oBrwPro:nAt][Ascan(_aFldPro,{|x| x[1] == "C6_CLI"		})]
	Local _cLj		:= _aBrwPro[_oBrwPro:nAt][Ascan(_aFldPro,{|x| x[1] == "C6_LOJA"		})]

	SA1->(dbsetorder(1))
	SA1->(msSeek(xFilial("SA1") + _cCli + _cLj))

	If !_oDadosGet:TudoOK()
		_lRet := .F.
	Else

		Begin Transaction

			For C := 1 To Len(_oDadosGet:aCols)
				_nQtPed += _oDadosGet:aCols[C][_nPQtd]

				If SA1->A1_RISCO != "S"
					If _oDadosGet:aCols[C][_nPTip] != "B"
						If _oDadosGet:aCols[C][_nPCon] == "100"
							_nSdoRA := 0
							If cEmpAnt + cFilAnt $ "0104|0222"
								_cQ := " SELECT E1_CLIENTE,E1_LOJA,E1_TIPO, SALDO = CASE E1_TIPO WHEN 'RA' THEN SUM(E1_SALDO) * -1 ELSE SUM(E1_SALDO) END
								_cQ += " FROM SE1200 A WHERE A.D_E_L_E_T_ = '' AND E1_SALDO > 0 AND E1_CLIENTE = '"+SA1->A1_COD+"' "
								_cQ += " AND E1_LOJA = '"+SA1->A1_LOJA+"' AND E1_TIPO IN ('RA','NF') "
								_cQ += " GROUP BY E1_CLIENTE,E1_LOJA,E1_TIPO "
								_cQ += " ORDER BY E1_CLIENTE,E1_LOJA "

								TCQUERY _cQ NEW ALIAS "ZRA"

								ZRA->(dbGotop())

								While ZRA->(!Eof())

									_nSdoRA += ZRA->SALDO

									ZRA->(dbSkip())
								EndDo

								ZRA->(dbCloseArea())
							Endif

							_cQ := " SELECT E1_CLIENTE,E1_LOJA,E1_TIPO, SALDO = CASE E1_TIPO WHEN 'RA' THEN SUM(E1_SALDO) * -1 ELSE SUM(E1_SALDO) END "
							_cQ += " FROM "+RetSqlName("SE1")+" A WHERE A.D_E_L_E_T_ = '' AND E1_SALDO > 0 AND E1_CLIENTE = '"+SA1->A1_COD+"' "
							_cQ += " AND E1_LOJA = '"+SA1->A1_LOJA+"' AND E1_TIPO IN ('RA','NF') "
							_cQ += " GROUP BY E1_CLIENTE,E1_LOJA,E1_TIPO "
							_cQ += " ORDER BY E1_CLIENTE,E1_LOJA "

							TCQUERY _cQ NEW ALIAS "ZRA"

							ZRA->(dbGotop())

							While ZRA->(!Eof())

								_nSdoRA += ZRA->SALDO

								ZRA->(dbSkip())
							EndDo

							ZRA->(dbCloseArea())

							_cQ := " SELECT Z1_CLIENTE,Z1_LOJA,SUM(Z1_QUANT * Z1_PCOREF) AS TOTAL "
							_cQ += " FROM "+RetSqlName("SZ1")+" A WHERE A.D_E_L_E_T_ = '' AND Z1_CLIENTE = '"+SA1->A1_COD+"' "
							_cQ += " AND Z1_LOJA = '"+SA1->A1_LOJA+"' AND Z1_DTCANC = '' "             // Marcus Vinicius - 09/08/16 - Adicionado Z1_DTCANC
							_cQ += " GROUP BY Z1_CLIENTE,Z1_LOJA "
							_cQ += " ORDER BY Z1_CLIENTE,Z1_LOJA "

							TCQUERY _cQ NEW ALIAS "ZZ1"

							_nSdoRa  += (ZZ1->TOTAL + (_nQtPed * _oDadosGet:aCols[C][_nPVlR]) )

							ZZ1->(dbCloseArea())

							If _nSdoRa > 0
								MSGALERT(" 4 -Cliente Sem RA (Recebimento Antecipado) Em Aberto!! ")
								_lRet := .F.
								Exit
							Endif
						Endif
					Endif
				Endif


				If  SuperGetMv("MV_YOBGPL",,.F.) .And. cEmpAnt + cFilAnt $ '0210|3001|4001|0203'

					If _oDadosGet:aCols[C][_nPFre] = "F"
						If Empty(_oDadosGet:aCols[C][_nPPla]) .Or. Empty(_oDadosGet:aCols[C][_nPMot])
							ShowHelpDlg("MZ0223", {'Para Pedidos com Frete do tipo "FOB", é obrigatório o preenchimento do campo Placa e Motorista'},1,;
							{'Preencha os campos "Placa" e "Motorista".'},2)
							_lRet := .F.
							Exit
						Endif
					Else
						If !Empty(_oDadosGet:aCols[C][_nPPla]) .Or. !Empty(_oDadosGet:aCols[C][_nPMot])
							ShowHelpDlg("MZ0223", {'Para Pedidos com Frete do tipo "CIF", não é permitido prosseguir com os campos PLACA ou MOTORISTA preenchidos'},1,;
							{'Limpe os campos "Placa" e "Motorista".'},2)
							_lRet := .F.
							Exit
						Endif
					Endif
				Endif
			Next C

			If !_lRet
				DisarmTransaction()
			Endif

			If _nQtPed <> _nQuanti .And. _lRet
				ShowHelpDlg("MZ0223", {'Quantidade total do(s) pedido(s) diferente da programação!'},2,{'Ajuste a quantidade do(s) Pedido(s).'},2)
				_lRet := .F.
				DisarmTransaction()
			ElseIf _lRet
				For D := 1 To Len(_oDadosGet:aCols)

					_lPare := .T.
					_cLib := MZ223Lib(_oDadosGet,D,_nPVlR,_nPQtd,_nPTES,_nPTip,_nPPedi)

					SZ1->(RecLock("SZ1",.T.))
					SZ1->Z1_FILIAL := xFilial("SZ1")
					SZ1->Z1_LIBER  := _cLib

					For E := 1 To Len(_oDadosGet:aHeader)
						If !(Alltrim(_oDadosGet:aHeader[E][2]) $ "Z1_LIBER|Z1_HISTORI")
							_cCampo := 'SZ1->'+_oDadosGet:aHeader[E][2]
							&_cCampo := _oDadosGet:aCols[D][aScan(_oDadosGet:aHeader,{|x|x[2] = _oDadosGet:aHeader[E][2]})]
						Endif
					Next E

					SZ1->Z1_RPA     := "N"
					SZ1->Z1_TRGR    := "N"
					SZ1->(MsUnLock())
				Next D

				SC6->(dbsetOrder(1))
				If SC6->(msSeek(xFilial("SC6")+_cProgra+_cPrgIte))
					SC6->(RecLock("SC6",.F.))
					SC6->C6_YPEDGER := 'S'
					SC6->(MsUnlock())
				Endif

			Endif

			If _lRet
				//MZ223C("A")	//Marcus Vinicius - 28/02/2018 - criado nova função para montagem da grid MVSZ223C
				MVSZ223C("A")
			Endif
		End Transaction
	Endif

	RestArea(_AreaSC6)

Return(_lRet)



//Verifica se o Pedido ficará liberado
Static Function MZ223Lib(_oDadosGet,_nLine,_nPVlR,_nPQtd,_nPTES,_nPTip,_nPPedi)

	Local _cRet    := "S"
	Local _AreaSZ1 := SZ1->(GetArea())

	_cCli  := _aBrwPro[_oBrwPro:nAt][Ascan(_aFldPro,{|x| x[1] == "C6_CLI"		})]
	_cLj   := _aBrwPro[_oBrwPro:nAt][Ascan(_aFldPro,{|x| x[1] == "C6_LOJA"		})]
	_cProd := _aBrwPro[_oBrwPro:nAt][Ascan(_aFldPro,{|x| x[1] == "C6_PRODUTO"	})]

	_nVlUn := _oDadosGet:aCols[_nLine][_nPVlR]
	_nQtde := _oDadosGet:aCols[_nLine][_nPQtd]
	_cTES  := _oDadosGet:aCols[_nLine][_nPTES]
	_cTipo := _oDadosGet:aCols[_nLine][_nPTip]
	_cPedi := _oDadosGet:aCols[_nLine][_nPPedi]

	SA1->(dbsetorder(1))
	SA1->(msSeek(xFilial("SA1") + _cCli + _cLj))

	ZA6->(dbSetOrder(1))
	If ZA6->(dbSeek(xFilial("ZA6") + _cCli + _cLj + "L"))
		_cCond := ZA6->ZA6_PRAZO
	EndIf

	lBloqueio := .F.
	nSaldo    := 0

	If _cCond == "100"

	Else

		nRiscoB := GetMv("MV_RISCOB")
		nRiscoC := GetMv("MV_RISCOC")
		nRiscoD := GetMv("MV_RISCOD")

		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+_cProd))

		IF ( ALLTRIM(SB1->B1_COD) $ GETNEWPAR('MV_SMREENS',' ') .And. cEmpAnt+cFilAnt $ '0210|3001') // Quando For produto de Reensaque não Verificar Preco - Juailson Semar 01/04/2015
			lPrdReensaque := .T.
		ELSE
			lPrdReensaque := .F.
		ENDIF

		If SB1->B1_YVEND == "S"  .and. !lPrdReensaque // Nao produto Reensaque Critica - Juailson Semar 02/04/15
			If !SA1->A1_RISCO $ "S/A"

				DbSelectArea("SZ1")
				ccliente := _cCli + _cLj
				nTotal   := 0

				SZ1->(DbSetOrder(2))
				If SZ1->(MsSeek(xFilial("SZ1")+ccliente))
					While !SZ1->(Eof()) .and. SZ1->Z1_FILIAL==xFilial("SZ1") .and. SZ1->Z1_CLIENTE+SZ1->Z1_LOJA == ccliente
						If Empty(SZ1->Z1_NUMNF) .AND. SZ1->Z1_TIPO <> "B" .And. Empty(SZ1->Z1_DTCANC)
							nTotal+=SZ1->Z1_QUANT
						EndIf
						SZ1->(DbSkip())
					EndDo
				Endif

				If SA1->A1_YLC <> "Q"
					ZA6->(dbSetOrder(1))
					If ZA6->(dbSeek(xFilial("ZA6") + SA1->A1_COD + SA1->A1_LOJA + "L"))
						If nSaldo + ((_nQtde+nTotal)*_nVlUn) > ZA6->ZA6_VALOR
							MsgAlert("3.Pedido "+Alltrim(_cPedi)+" Bloqueado, Saldo devedor maior que limite de credito")
							//							ShowHelpDlg("MZ0223", {'3.Pedido '+Alltrim(_cPedi)+' Bloqueado, saldo devedor maior que limite de credito'},2,{'Solicite a liberação do Pedido.'},2)

							lBloqueio := .T.
						Endif
					Else
						If _cTES != "547"
							If nSaldo + ((_nQtde+nTotal)*_nVlUn) > SA1->A1_LC
								MsgAlert("4.Pedido "+Alltrim(_cPedi)+" Bloqueado, Saldo devedor maior que limite de credito")
								//								ShowHelpDlg("MZ0223", {'4.Pedido '+Alltrim(_cPedi)+' Bloqueado, saldo devedor maior que limite de credito'},2,{'Solicite a liberação do Pedido.'},2)
								lBloqueio := .T.
							Endif
						Endif
					Endif
				Else
					wLC := SA1->A1_YLCQTDE * _nVlUn
					If nSaldo + ((_nQtde+nTotal)*_nVlUn) > wLC
						MsgAlert("Pedido "+Alltrim(_cPedi)+" Bloqueado, Saldo devedor maior que limite de credito por Quantidade.")
						//						ShowHelpDlg("MZ0223", {'Pedido '+Alltrim(_cPedi)+' Bloqueado, saldo devedor maior que limite de credito por Quantidade'},2,{'Solicite a liberação do Pedido.'},2)
						lBloqueio := .T.
					Endif
				Endif
			EndIf
			IF lBloqueio
				_cRet := "B"
			Else
				_cRet := "S"
			Endif
		Else
			_cRet := "S"
		EndIf

		If _cTES = "542" .Or. _cTipo = "B"
			_cRet := "B"
			MsgAlert('Pedido '+Alltrim(_cPedi)+' Bloqueado, TES utilizada é "542" ou o Tipo de Pedido é igual à "B".')
		Endif

	Endif

	RestArea(_AreaSZ1)

Return(_cRet)



User Function GMZ223A(_cOpt)

	Local _aAliOri	:= GetArea()
	Local _aAliSB1	:= SB1->(GetArea())
	Local _aAliZA2	:= ZA2->(GetArea())
	Local _aAliZA6	:= ZA6->(GetArea())
	Local _aAliSA1	:= SA1->(GetArea())
	Local _AreaSZ1	:= SZ1->(GetArea())
	Local _AreaSZ2	:= SZ2->(GetArea())
	Local _AreaSZI	:= SZI->(GetArea())
	Local _AreaSZ4	:= SZ4->(GetArea())

	Local _nPObra	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_OBRA"})
	Local _nPPreco	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_PCOREF"})
	Local _nPClie	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_CLIENTE"})
	Local _nPLoja	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_LOJA"})
	Local _nPPROD	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_PRODUTO"})
	Local _nPLocal	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_LOCAL"})
	Local _nPMUNE	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_MUNE"})
	Local _nPUFE	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_UFE"})
	Local _nPMUNF	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_MUNFRT"})
	Local _nPUFFR	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_UFFRT"})
	Local _nPVEND	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_VEND"})
	Local _nPNOBRA	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_NOMOBRA"})
	Local _nPPUNIT	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_PUNIT"})
	Local _nPUNID	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_UNID"})
	Local _nPTES	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_TES"})
	Local _nPPCOR	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_PCOREF"})
	Local _nPFRETE	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_FRETE"})
	Local _nPCDESC	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_COMDESC"})
	Local _nPQUANT	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_QUANT"})
	Local _nPFTRA	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_FTRA"})
	Local _nPFMOT	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_FMOT"})
	Local _nPVERC	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_VERCERD"})
	Local _nPTIPO	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_TIPO"})
	Local _nPVIA	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_TPF"})
	Local _nPVIA1	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_VIA"})

	Local _cObra	:= aCols[n][_nPObra]
	Local _nPreco	:= aCols[n][_nPPreco]
	Local _cCli		:= aCols[n][_nPClie]
	Local _cLoja	:= aCols[n][_nPLoja]
	Local _cProd	:= aCols[n][_nPPROD]
	Local _cCDesc	:= aCols[n][_nPCDESC]
	Local _cTpFrete	:= aCols[n][_nPFRETE]
	Local _cTES		:= aCols[n][_nPTES]
	Local _nQuant	:= aCols[n][_nPQUANT]
	Local _cTipo	:= aCols[n][_nPTIPO]
	Local _cVia		:= aCols[n][_nPVIA]

	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+_cProd))

	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1") + _cCli + _cLoja))

	If _cOpt = "O" //Z1_OBRA
		_cRet := _cObra

		If !Empty(_cObra)
			IF cEmpAnt + cFilAnt $ '0210|1201|3001|4001|0203|0216'
				ZA2->(dbSetOrder(4))
				If ZA2->(dbSeek(xFilial("ZA2")+_cCli +_cLoja + "L"))

					SB1->(DbSetOrder(1))
					SB1->(DbSeek(xFilial("SB1")+ZA2->ZA2_PRODUT))

					aCols[n][_nPLocal]	:= Substr(ZA2->ZA2_NOME,1,25)+"-"+ALLTRIM(ZA2->ZA2_ENDENT)+" "+ALLTRIM(ZA2->ZA2_BAIENT)+" "+ALLTRIM(ZA2->ZA2_MUNENT)
					aCols[n][_nPMUNE]	:= ZA2->ZA2_MUNENT
					aCols[n][_nPUFE]	:= ZA2->ZA2_ESTENT

					If SZ1->(FieldPos("Z1_MUNFRT")) > 0 .AND. SZ1->(FieldPos("Z1_UFFRT")) > 0
						aCols[n][_nPMUNF]	:= ZA2->ZA2_MUNENT
						aCols[n][_nPUFFR]	:= ZA2->ZA2_ESTENT
					EndIf

					aCols[n][_nPVEND]	:= ZA2->ZA2_VEND
					aCols[n][_nPNOBRA]	:= ZA2->ZA2_NOME
					aCols[n][_nPPROD]	:= ZA2->ZA2_PRODUT
					If _nPPUNIT > 0
						aCols[n][_nPPUNIT]	:= SB1->B1_PRV1
					Endif
					aCols[n][_nPUNID]	:= SB1->B1_UM
					//					_cProd				:= ZA2->ZA2_PRODUT
				Endif
			ELSE
				ZA2->(dbSetOrder(2))
				If ZA2->(dbSeek(xFilial("ZA2") +_cCli +_cLoja + _cProd + _cObra + "L"))

					SB1->(DbSetOrder(1))
					SB1->(DbSeek(xFilial("SB1")+ZA2->ZA2_PRODUT))

					aCols[n][_nPLocal]	:= Substr(ZA2->ZA2_NOME,1,25)+"-"+ALLTRIM(ZA2->ZA2_ENDENT)+" "+ALLTRIM(ZA2->ZA2_BAIENT)+" "+ALLTRIM(ZA2->ZA2_MUNENT)
					aCols[n][_nPMUNE]	:= ZA2->ZA2_MUNENT
					aCols[n][_nPUFE]	:= ZA2->ZA2_ESTENT
					If SZ1->(FieldPos("Z1_MUNFRT")) > 0 .AND. SZ1->(FieldPos("Z1_UFFRT")) > 0
						aCols[n][_nPMUNF]	:= ZA2->ZA2_MUNENT
						aCols[n][_nPUFFR]	:= ZA2->ZA2_ESTENT
					EndIf
					aCols[n][_nPVEND]	:= ZA2->ZA2_VEND
					aCols[n][_nPNOBRA]	:= ZA2->ZA2_NOME
					aCols[n][_nPPROD]	:= ZA2->ZA2_PRODUT
					If _nPPUNIT > 0
						aCols[n][_nPPUNIT]	:= SB1->B1_PRV1
					Endif
					aCols[n][_nPUNID]	:= SB1->B1_UM
					//					_cProd				:= ZA2->ZA2_PRODUT
				Endif
			ENDIF
		Else
			aCols[n][_nPLocal]	:= SA1->A1_ENDENT
			aCols[n][_nPMUNE]	:= SA1->A1_YMUNE
			aCols[n][_nPUFE]	:= SA1->A1_YUFE
			If SZ1->(FieldPos("Z1_MUNFRT")) > 0 .AND. SZ1->(FieldPos("Z1_UFFRT")) > 0
				aCols[n][_nPMUNF]	:= SA1->A1_YMUNE
				aCols[n][_nPUFFR]	:= SA1->A1_YUFE
			EndIf
			aCols[n][_nPVEND]	:= SA1->A1_VEND
			aCols[n][_nPNOBRA]	:= Space(TAMSX3("Z1_NOMOBRA")[1])
		Endif

		//Gatilho do preço
		If _cTES <> "547"

			IF ( ALLTRIM(SB1->B1_COD) $ GETNEWPAR('MV_SMREENS',' ')  .and. cEmpAnt + cFilAnt $ '0210|3001') // Quando For produto de Reensaque não Verificar Preco - Juailson Semar 01/04/2015
				lPrdReensaque := .T.
			ELSE
				lPrdReensaque := .F.
			ENDIF

			If !Empty(_cObra)
				ZA2->(dbSetOrder(3))
				If ZA2->(dbSeek(xFilial("ZA2") + _cCli + _cLoja  + _cObra + _cProd + "L"))
					If (Alltrim(SB1->B1_TIPCAR) == "CDC") .OR. (Alltrim(SB1->B1_TIPCAR) == "G3")
						aCols[n][_nPPCOR] := ZA2->ZA2_PRUNIT
					Else
						If _cTpFrete == "C"
							//Perguntar pelo Preço Cif Descarga OBRA  - Juailson Semar - em 11/05/15
							if _cCDesc == "S" // Com Descarga? S
								aCols[n][_nPPCOR] := ZA2->ZA2_PRC01D  // Preço Cif Descarga OBRA
							else
								aCols[n][_nPPCOR] := ZA2->ZA2_PRC01
							endif
						Else
							aCols[n][_nPPCOR] := ZA2->ZA2_PRC01F
						Endif

					Endif
				Else
					MSGINFO("PRECO NAO ENCONTRADO OU NAO LIBERADO PARA ESSA OBRA !!")
				Endif
			Endif

			If _nPreco = 0 .and.  !lPrdReensaque // Nao for produto de Reensaque - Juailson Semar em 02/04/15
				SZI->(dbSetOrder(1))
				If SZI->(dbSeek(xFilial("SZI") + _cCli + _cLoja + _cProd + "L"))
					If (Alltrim(SB1->B1_TIPCAR) == "CDC") .OR. (Alltrim(SB1->B1_TIPCAR) == "G3")
						aCols[n][_nPPCOR] := SZI->ZI_PRCUNIT
					Else
						If _cTpFrete == "F"
							aCols[n][_nPPCOR] := SZI->ZI_PRECOF  // Preço FOB
						Else
							//Perguntar pelo Preço Cif Descarga  - Juailson Semar - em 28/01/15
							if _cCDesc == "S" // Com Descarga? S
								aCols[n][_nPPCOR] := SZI->ZI_PRECOD  // Preço Cif Descarga
							else
								aCols[n][_nPPCOR] := SZI->ZI_PRECO
							endif
						Endif
					Endif

					If aCols[n][_nPPCOR] == 0
						MSGSTOP("1- PRECO NAO CADASTRADO OU NAO LIBERADO PARA ESSA MODALIDADE DE FRETE / PRODUTO!!!")
					Endif
				Else
					MSGSTOP("2- PRECO NAO CADASTRADO OU NAO LIBERADO PARA ESSA MODALIDADE DE FRETE / PRODUTO!!!")
					aCols[n][_nPPCOR] := 0
				Endif
			Endif

		Endif
	Endif

	_cMUNE := aCols[n][_nPMUNE]
	_cUFE  := aCols[n][_nPUFE]
	_cMUNF := aCols[n][_nPMUNF]
	_cUFF  := aCols[n][_nPUFFR]
	_cPrc  := aCols[n][_nPPCOR]

	If _cOpt = "Q" //Z1_QUANT

		_nFTRA	:=  aCols[n][_nPFTRA]
		//	If (_cTpFrete = "C" .And. cEmpAnt = "01") .Or. (_cTpFrete $ "C|F" .And. cEmpAnt = "02")
		If _cTpFrete = "C" .Or. (_cTpFrete = "F" .and. !(cEmpAnt+cFilAnt) $ '0201|0215|0218|0220|0221')

			nTipoFRT	:= SuperGetMV("MV_YTPCFRT",,1) // 1 - Utiliza os campos (Z1_MUNE + Z1_UFE) para calculo do frete transp __ 2 - Utiliza os campos (Z1_MUNFRT + Z1_UFFRT) para calculo do frete transp
			_cRotina	:= Alltrim(UPPER(FunName()))
			_lRet		:= .F.
			_nRet		:= 0
			_nFTRA		:= 0

			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+_cProd))

			IF ( ALLTRIM(SB1->B1_COD) $ GETNEWPAR('MV_SMREENS',' ')  .and. cEmpAnt + cFilAnt $ '0210|3001') // Quando For produto de Reensaque não Verificar Preco - Juailson Semar 01/04/2015
				lPrdReensaque := .T.
			ELSE
				lPrdReensaque := .F.
			ENDIF

			If _cTpFrete == "C"

				If Alltrim(SB1->B1_TIPCAR) == "S"
					_nQtde := (_nQuant * SB1->B1_CONV) / 1000
				Else
					_nQtde := _nQuant
				Endif

				SZ4->(dbSetOrder(1))
				If nTipoFRT != 2
					SZ4->(dbSeek(xFilial("SZ4")+_cUFE+_cMUNE))
				Else
					SZ4->(dbSeek(xFilial("SZ4")+_cUFF+_cMUNF))
				Endif

				If SA1->A1_YFRECLI>0
					_nFTRA := SA1->A1_YFRECLI * _nQtde
				Else
					If  _cCDesc == "S" // Com Descarga? S
						_nFTRA := SZ4->Z4_FRETED * _nQtde // Frete Descarga 13/02/15 Juailson - Semar
					Else
						_nFTRA := SZ4->Z4_FRETE * _nQtde
					Endif
				Endif

				If SA1->A1_YFMOT > 0
					_nFMOT:= _nQtde * SA1->A1_YFMOT
				Else
					_nFMOT:= _nQtde * SZ4->Z4_FMOT
				Endif

				/*
				If cEmpAnt + cFilAnt $ '0210|3001'
				SZ3->(dbSetOrder(1))
				If SZ3->(dbSeek(xFilial("SZ3") + M->Z1_MOTOR))
				If laltped <> nil .and. laltped
				If SA1->A1_YFRECLI>0
				_nFTRA := SA1->A1_YFRECLI * _nQtde
				Else
				if  _cCDesc == "S" // Com Descarga? S  -  Frete Descarga - 13/02/15  Juailson-Semar
				_nFTRA := Round(_nQtde * Iif(SZ3->Z3_AGREGA=="S",SZ4->Z4_FAGRTRD,SZ4->Z4_FRETED) ,2) //// ALTERADO 11/01/12  // Frete Descarga
				else
				_nFTRA := Round(_nQtde * Iif(SZ3->Z3_AGREGA=="S",SZ4->Z4_FAGRTRA,SZ4->Z4_FRETE) ,2) //// ALTERADO 11/01/12
				endif
				Endif
				If SA1->A1_YFMOT > 0
				_nFMOT:= _nQtde * SA1->A1_YFMOT
				Else
				_nFMOT := Round(_nQtde * Iif(SZ3->Z3_AGREGA=="S",SZ4->Z4_FAGRMOT,SZ4->Z4_FMOT) ,2)  //// ALTERADO 11/01/12
				endif
				Endif
				endif
				endif
				*/
			Else
				_nFTRA := 0
				_nFMOT := 0
			Endif

			aCols[n][_nPFTRA]	:= _nFTRA
			aCols[n][_nPFMOT]	:= _nFMOT
			If _nPVERC > 0
				aCols[n][_nPVERC]	:= Space(01)
			Endif

			If _cPrc == 0
				aCols[n][_nPPCOR] := SB1->B1_PRV1
				_cPrc := SB1->B1_PRV1
			Endif

			IF ( lPrdReensaque  .And. cEmpAnt + cFilAnt $ '0210|3001')
				_nPreco :=  SB1->B1_PRV1
			ENDIF

			If _cPrc < SB1->B1_YPRVMIN .or. _cPrc > SB1->B1_YPRVMAX
				help("",1,"Y_MIZ004")
				aCols[n][_nPPCOR] := 0
			Endif

			_nPreco := 0
			If _cTES != "547"
				If !Empty(_cObra)
					ZA2->(dbSetOrder(3))
					If ZA2->(dbSeek(xFilial("ZA2") + _cCli + _cLoja  + _cObra + _cProd + "L"))
						If (Alltrim(SB1->B1_TIPCAR) == "CDC") .OR. (Alltrim(SB1->B1_TIPCAR) == "G3")
							_nPreco := ZA2->ZA2_PRUNIT
						Else
							If _cTpFrete == "C"
								if _cCDesc == "S" // Com Descarga? S
									_nPreco := ZA2->ZA2_PRC01D  // Preço Cif Descarga OBRA
								else
									_nPreco := ZA2->ZA2_PRC01
								endif
							Else
								_nPreco := ZA2->ZA2_PRC01F
							Endif
						Endif
					Else
						MSGINFO("PRECO NAO ENCONTRADO OU NAO LIBERADO PARA ESSA OBRA !!")
					Endif
				Endif

				If _nPreco = 0  .and.  !lPrdReensaque  // Verificar se nao for Reensaque - Juailson Semar em 02/04/15
					SZI->(dbSetOrder(1))
					If SZI->(dbSeek(xFilial("SZI") + _cCli + _cLoja + _cProd + "L"))
						If (Alltrim(SB1->B1_TIPCAR) == "CDC") .OR. (Alltrim(SB1->B1_TIPCAR) == "G3")
							_nPreco := SZI->ZI_PRCUNIT
						Else
							If _cTpFrete == "F"
								_nPreco := SZI->ZI_PRECOF  // Preço FOB
							Else
								//Perguntar pelo Preço Cif Descarga  - Juailson Semar - em 28/01/15
								if _cCDesc == "S" // Com Descarga? S
									_nPreco := SZI->ZI_PRECOD  // Preço Cif Descarga
								else
									_nPreco := SZI->ZI_PRECO
								endif
							Endif
						Endif

						If _nPreco == 0
							MSGSTOP("4- PRECO NAO CADASTRADO OU NAO LIBERADO PARA ESSA MODALIDADE DE FRETE / PRODUTO!!!")
						Endif
					Else
						MSGSTOP("5- PRECO NAO CADASTRADO OU NAO LIBERADO PARA ESSA MODALIDADE DE FRETE / PRODUTO!!!")
						_nPreco := 0
					Endif
				Endif

				if lPrdReensaque //  produto Reensaque  - Juailson Semar 02/04/15
					If _nPreco == 0
						_nPreco := SB1->B1_PRV1
					Endif

					If _nPreco < SB1->B1_YPRVMIN .or. _nPreco > SB1->B1_YPRVMAX
						help("",1,"Y_MIZ004")
						Return(0)
					Endif
				endif

				aCols[n][_nPPCOR] := _nPreco

				ZA6->(dbSetOrder(1))
				If ZA6->(dbSeek(xFilial("ZA6") + _cCli + _cLoja + "L"))

					_cQ := " SELECT Z1_CLIENTE,Z1_LOJA,SUM(Z1_QUANT * Z1_PCOREF) AS TOTAL "
					_cQ += " FROM "+RetSqlName("SZ1")+" A WHERE A.D_E_L_E_T_ = '' AND Z1_CLIENTE = '"+SA1->A1_COD+"' "
					_cQ += " AND Z1_LOJA = '"+SA1->A1_LOJA+"' AND Z1_DTCANC = '' AND Z1_TIPO <> 'B' "		// Marcus Vinicius	- 07/04/2017 - Incluído validação para bonificação.
					_cQ += " GROUP BY Z1_CLIENTE,Z1_LOJA "
					_cQ += " ORDER BY Z1_CLIENTE,Z1_LOJA "

					TCQUERY _cQ NEW ALIAS "ZZ1"

					_nPedido := ZZ1->TOTAL

					ZZ1->(dbCloseArea())

					_nSdoTit := ZA6->ZA6_SDOTIT	+ _nPedido + (_nQuant * aCols[n][_nPPCOR])
					_nDif    := ZA6->ZA6_VALOR  - _nSdoTit

					If _nDif < 0
						_nDif  := _nDif * -1
						_nPerc := (_nDif / ZA6->ZA6_VALOR) * 100

						If _nPerc > GETMV("MZ_PERLIM") .AND. ZA6->ZA6_PRAZO<>'100' .AND. _cTipo <> 'B'	// Marcus Vinicius	- 07/04/2017 - Incluído validação para bonificação.
							MSGALERT("2 - Limite de Credito Excedido Em "+STR(GETMV("MZ_PERLIM"),2)+" % ")
							aCols[n][_nPQUANT]	 := 0
							_nFTRA := 0
						Endif
					Endif
				Endif
			Endif
		Endif

		If _cVia = "F"
			SZ4->(dbSetOrder(1))
			IF SZ4->(dbSeek(xFilial("SZ4")+_cUFE+_cMUNE))
				_nFTRA := SZ4->Z4_FREF * _nQuant
				aCols[n][_nPFTRA] := _nFTRA
			Endif
			aCols[n][_nPFMOT] := 0
		ElseIf _cVia = "M"
			aCols[n][_nPFMOT] := 0
			SZ4->(dbSetOrder(1))
			IF SZ4->(dbSeek(xFilial("SZ4")+_cUFE+_cMUNE))
				_nFTRA := SZ4->Z4_FREM * _nQuant
				aCols[n][_nPFTRA] := _nFTRA
			Endif
		Endif

		_cRet := _nFTRA
	Endif

	RestArea(_aAliSA1)
	RestArea(_AreaSZ4)
	RestArea(_aAliZA6)
	RestArea(_AreaSZI)
	RestArea(_AreaSZ2)
	RestArea(_AreaSZ1)
	RestArea(_aAliSB1)
	RestArea(_aAliZA2)
	RestArea(_aAliOri)

Return(_cRet)



User Function MZ223OBRA()

	Local _lRet		:= .F.
	Local _nPClie	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_CLIENTE"})
	Local _nPLoja	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_LOJA"})
	Local _cCli		:= aCols[n][_nPClie]
	Local _cLoja	:= aCols[n][_nPLoja]

	If ExistCPO("ZA2",_cCli+_cLoja,2) .Or. Vazio()
		_lRet := .T.
	Endif

Return(_lRet)



User Function GMZ223B(_cCampo)
	// GATILHO REF. DATA DE ENTREGA NO PEDIDO DE VENDAS
	// DATA : 25/09/13
	// NOME : Alexandro da Silva

	Local _aAliOri	:= GetArea()
	Local _aAliSC4	:= SC4->(GetArea())

	Local _nPDTENT	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_DTENT"})
	Local _nPQUANT	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_QUANT"})
	Local _nPPROD	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_PRODUTO"})
	Local _nPFRETE	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_FRETE"})
	Local _nPFTRA	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_FTRA"})

	Local _dDtEnt	:= aCols[n][_nPDTENT]
	Local _nQuant	:= aCols[n][_nPQUANT]
	Local _cProdu	:= aCols[n][_nPPROD]
	Local _cFrete	:= aCols[n][_nPFRETE]
	Local _nFTRA	:= aCols[n][_nPFTRA]
	Local lPrdReensaque := .F.

	If cEmpAnt+cFilAnt $ "0222/0223"
		If _cCampo = "Z1_DTENT"
			Return(_dDtEnt)
		ElseIf _cCampo = "Z1_FTRA"
			Return(_nFtra)
		Endif
	Endif

	//Desabilitado o Gatilho provisoriamente
	If cFilAnt $ SuperGetMV('MZ_GESTPED',,'03')
		If _cCampo = "Z1_DTENT"
			Return(_dDtEnt)
		ElseIf _cCampo = "Z1_FTRA"
			Return(_nFtra)
		Endif
	Endif

	Private _lRet2     := .f.
	_lVerSenha         := .F.

	//	_cRetorno:= _dDtEnt

	_dDtRet  := CTOD("")

	If _cCampo = "Z1_DTENT"
		If _dDtEnt < Date()
			MsgInfo("Data de Entrega Nao Pode Ser Inferior a Data Atual!!")
			Return(CTOD(""))
		Endif

		If DOW(_dDtEnt) = 1  .and. getNewPar('MZ_BLQDOMI',.T.)
			MsgInfo("Data de Entrega Nao Pode Ser no Domingo!!")
			Return(CTOD(""))
		Endif
	Endif

	PUBLIC _aBrow   := {}

	If !Empty(_dDtEnt) .And. _nQuant > 0
		SC4->(dbOrderNickName("INDSC44"))
		SC4->(dbSeek(xFilial("SC4")+_cProdu + DTOS(_dDtEnt)+"L",.T.))

		_nTotPrev := 0

		If _cProdu != SC4->C4_PRODUTO
			if  lPrdReensaque  // Quando For produto de Reensaque não Verifica Preco - Juailson Semar 01/04/2015 (!SB1_COD $  cPrdReensaque .and. cempant$'30')
				_lRet2 := GFAT14_01()
			else
				MSGINFO("Nao Existe Previsao Em Aberto Para Esse Produto!")
				_lRet2 := GFAT14_01()
			endif
		Else
			_lSair    := .F.

			_cChavSC4 := SC4->C4_PRODUTO

			While SC4->(!Eof()) .And. _cChavSC4 == SC4->C4_PRODUTO .And. !_lSair

				If SC4->C4_YSTATUS == "B"
					SC4->(dbSkip())
					Loop
				Endif

				//				If _cFrete == "C"
				//				Else
				//				Endif

				If SC4->C4_DATA == _dDtEnt
					If _cFrete == "C"
						If SC4->C4_YSDOCIF >= _nQuant
							_lRet2 := .T.
							Aadd(_aBrow,{"OK",.T.,SC4->C4_PRODUTO,SC4->C4_DATA,Transform(SC4->C4_YQTFOB,"@E 999,999,999.99"),Transform(SC4->C4_YSDOFOB,"@E 999,999,999.99"),Transform(SC4->C4_YQTCIF,"@E 999,999,999.99"),Transform(SC4->C4_YSDOCIF,"@E 999,999,999.99"),SC4->C4_YSTATUS})
							_lSair := .T.
						Endif
					Else
						If SC4->C4_YSDOFOB >= _nQuant
							_lRet2 := .T.
							Aadd(_aBrow,{"OK",.T.,SC4->C4_PRODUTO,SC4->C4_DATA,Transform(SC4->C4_YQTFOB,"@E 999,999,999.99"),Transform(SC4->C4_YSDOFOB,"@E 999,999,999.99"),Transform(SC4->C4_YQTCIF,"@E 999,999,999.99"),Transform(SC4->C4_YSDOCIF,"@E 999,999,999.99"),SC4->C4_YSTATUS})
							_lSair := .T.
						Endif
					Endif
				Endif

				If !_lRet2
					If _cFrete == "C"
						If SC4->C4_YSDOCIF > 0
							_nTotPrev += SC4->C4_YSDOCIF
						Endif
					Else
						If SC4->C4_YSDOFOB > 0
							_nTotPrev += SC4->C4_YSDOFOB
						Endif
					Endif

					_lMarc := .F.
					If _nTotPrev >= _nQuant
						_lSair := .T.
						_lMarc := .T.
						_dDtRet := SC4->C4_DATA
					Endif

					Aadd(_aBrow,{"OK",_lMarc,SC4->C4_PRODUTO,SC4->C4_DATA,Transform(SC4->C4_YQTFOB,"@E 999,999,999.99"),Transform(SC4->C4_YSDOFOB,"@E 999,999,999.99"),Transform(SC4->C4_YQTCIF,"@E 999,999,999.99"),Transform(SC4->C4_YSDOCIF,"@E 999,999,999.99"),SC4->C4_YSTATUS})
				Endif

				SC4->(dbSkip())
			EndDo
		Endif

		If _lRet2
			_cRetorno:= _dDtEnt
		Else
			If _nTotPrev < _nQuant
				MSGINFO("Nao Existe Previsão Disponivel!!")
				If GFAT14_01(@_lret2)
					_cRetorno:= _dDtEnt
				Else
					_cRetorno:= CTOD("")
				Endif
			Else
				_lRet2 := GFAT14_03()

				If _lRet2
					_cRetorno:= _dDtRet
				Else
					_cRetorno:= CTOD("")
				Endif
			Endif
		Endif
	Endif

	RestArea(_aAliSC4)
	RestArea(_aAliOri)

Return(_cRetorno)



Static Function GFAT14_01(_lRet2)

	Private laltera	:= .F.
	Private _Libera	:= .T.
	Private _cSenha	:= space(10)
	Private _lRet2    := .F.

	GFAT14_02()

	If _lVerSenha
		DEFINE MSDIALOG oDlg TITLE "Senha" FROM 004,004 TO 100,300 PIXEL

		@ 0.5,2  Say "Senha:"
		@ 0.5,8  Get _cSenha PassWord
		DEFINE SBUTTON FROM 30, 50 TYPE 1 ACTION VerSenha() OF oDlg
		DEFINE SBUTTON FROM 30, 100 TYPE 2 ACTION Close(oDlg) OF oDlg

		Activate MsDialog oDlg Centered
	Else
		_lRet2 := .T.
	Endif

Return(_lRet2)



Static Function Versenha()

	_lRet2 := .t.

	If Alltrim(_cSenha) <> alltrim(getmv("MZ_SENPREV"))
		MsgBox("Atenção, "+Alltrim(cUsername)+" senha digitada inválida","SENHA","STOP")
		_lRet2 := .F.
	EndIf

	If _lRet2
		Close(oDlg)
	Endif

Return(_lRet2)



Static Function GFAT14_02()

	asx61:= {}

	//         "X6_FIL","X6_VAR"   ,"X6_TIPO","X6_DESCRIC"                                        ,"X6_DSCSPA","X6_DSCENG","X6_DESC1"                                          ,"X6_DSCSPA1","X6_DSCENG1","X6_DESC2"              ,"X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA","X6_CONTENG","X6_PROPRI"
	aAdd(asx61,{"  "    ,"MZ_SENPREV","C"      ,"Senha Referente a Rotina de Previsao de Vendas,   ","         ","         ","Quando Nao Existe Previsao para a Data de Entre",""          ,""          ,"                      ",""          ,""          ,"previsao"  ,""          ,""          ,"U"})

	U_CRIASX6(asx61)
Return



Static Function GFAT14_03()

	Private oOk     := LoadBitmap( GetResources(), "LBOK")
	Private oNo     := LoadBitmap( GetResources(), "LBNO")
	Private oVerde  := LoadBitmap( GetResources(), "BR_VERDE")
	Private oVerm   := LoadBitmap( GetResources(), "BR_VERMELHO")

	cTitulo := "Previsao de Vendas"

	Private oDlg2
	Private oWBrowse2
	Private oGroup4

	aBotoes := {}
	oMainWnd:ReadClientCoords()

	DEFINE MSDIALOG oDlg2 TITLE "Previsao de Vendas" FROM 004,004 TO 350,900 PIXEL
	EnchoiceBar(oDlg2, {||Processa({||GFAT14_01(@_lRet2),oDlg2:End()})}, {||oDlg2:End()},,aBotoes)

	@ 005, 005 GROUP oGroup4 TO 170, 440 PROMPT "" OF oDlg2 COLOR 0, 16777215 PIXEL

	oGroup4:ReadClientCoords()

	//                                           1   2  3         4              5         6           7          8           9
	@ 010, 010 LISTBOX oWBrowse2   Fields HEADER "","","Produto","Data Entrega","Qtde.FOB","Saldo FOB","Qtde CIF","Saldo CIF","STATUS" SIZE 430,150 OF oGroup4 PIXEL ColSizes 50,50
	//linha Inferior,coluna Esquerda                                                                                          coluna Direita,linha Inferior
	oWBrowse2:SetArray(_aBrow)

	oWBrowse2:bLine := {|| {If ( !Empty(_aBrow[oWBrowse2:nAT,09]),oVerde,oVerm ),If (_aBrow[oWBrowse2:nAT,2],oOk,oNo),;
	_aBrow[oWBrowse2:nAt,3],;
	_aBrow[oWBrowse2:nAt,4],;
	_aBrow[oWBrowse2:nAt,5],;
	_aBrow[oWBrowse2:nAt,6],;
	_aBrow[oWBrowse2:nAt,7],;
	_aBrow[oWBrowse2:nAt,8],;
	_aBrow[oWBrowse2:nAt,9]}}

	oWBrowse2:bHeaderClick := {|| Inverte(_aBrow,.T.) }

	oWBrowse2:bLDblClick := {|| _aBrow[oWBrowse2:nAt,2] := !_aBrow[oWBrowse2:nAt,2],oWBrowse2:DrawSelect(),VldMarca()}

	oWBrowse2:Refresh()

	Activate MsDialog oDlg2 Centered

Return(_lRet2)


Static Function VldMarca(nPos)

	Default nPos := oWBrowse2:nAt

	_nTotGer    := 0
	_dDtRet     :=_aBrow[nPos,4]
	_lVerSenha  := .F.

	For AX:= 1 To Len(_aBrow)

		If  nPos != AX
			If _aBrow[AX,2]
				_aBrow[AX,2] := .F.
				If  AX > nPos
					_lVerSenha   := .T.
				Endif
			Endif
		Endif
	Next AX

	oWBrowse2:Refresh()

Return(.T.)



User Function GMZ223C(_cTipo)

	Local _aAliOri	:= GetArea()
	Local _aAliSC4	:= SC4->(GetArea())

	Local _nPCLIE	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_CLIENTE"})
	Local _nPLOJA	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_LOJA"})
	Local _nPMOTO	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_MOTOR"})
	Local _nPNMOT	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_NMOT"})
	Local _nPPLAC	:= Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="Z1_PLACA"})

	Local _cClie	:= aCols[n][_nPCLIE]
	Local _cLoja	:= aCols[n][_nPLOJA]
	Local _cMoto	:= aCols[n][_nPMOTO]
	Local _cNMot	:= aCols[n][_nPNMOT]
	Local _cPlac	:= aCols[n][_nPPLAC]

	If cEmpAnt + cFilAnt $ '0210|3001'
		If _cTipo = "P"
			_cRet := _cPlac
			//Verifa se a placa está vinculada no cadastro de Cliente X Placa
			SZX->(dbSetOrder(1))
			If !SZX->(msSeek(xFilial("SZX")+_cClie+_cLoja+_cPlac))
				_cRet 		:= SPACE(TAMSX3("Z1_PLACA")[1])
				MsgAlert("Placa não encontrada no cadastro de CLIENTE X PLACA!")
			Endif
		ElseIf _cTipo = "M"
			_cRet := _cMoto

			//Verifa se a placa está vinculada no cadastro de Cliente X Motorista
			ZAP->(dbSetOrder(1))
			If !ZAP->(msSeek(xFilial("ZAP")+_cClie+_cLoja+_cMoto))
				_cRet 		:= SPACE(TAMSX3("Z1_MOTOR")[1])
				aCols[n][_nPNMOT] 	:= SPACE(TAMSX3("Z1_NMOT")[1])
				MsgAlert("Motorista não encontrado no cadastro de CLIENTE X MOTORISTA!")
			Else
				SZ3->(dbsetOrder(1))
				If SZ3->(msSeek(xFilial('SZ3')+_cMoto))
					aCols[n][_nPNMOT]  := Alltrim(SZ3->Z3_NOME)
				Endif
			Endif
		Endif

	Endif

	If cEmpAnt = "02" //.And. !(cEmpAnt+cFilAnt) $ '0201|0215|0218|0220|0221')
		aCols[n][_nPVIA1] := aCols[n][_nPVIA]
	Endif

	RestArea(_aAliOri)

Return(_cRet)



//Função utilizada ao clicar com o botão direito do mouse sobre o grid
Static Function But_Right()

	Local _Area		:= GetArea()
	Local _oMnItem	:= Nil
	Local _nPosOK	:= aScan(_aFldPro,{|x| x[1] == 'C6_OK' })
	Local _nPosNum	:= aScan(_aFldPro,{|x| x[1] == 'C6_NUM' })
	Local _cOK		:= _aBrwPro[_oBrwPro:nAt][_nPosOK]
	Local _cNum		:= _aBrwPro[_oBrwPro:nAt][_nPosNum]


	_oMenu01 := TMenu():New(0,0,0,0,.T.)

	_oTMenu3A := TMenuItem():New(_oDlg,'Visualizar Programação',,,,{||PedMZ223(_cNum)},,'VERNOTA',,,,,,,.T.)
	_oMenu01:Add(_oTMenu3A)

	If _cOK = '0'

//		_oTMenu3B := TMenuItem():New(_oDlg,'Excluir Pedido',,,,{||ExcMZ223()},,'NOCONNECT',,,,,,,.T.)
		_oTMenu3B := TMenuItem():New(_oDlg,'Excluir Pedido',,,,{|| LjMsgRun('Excluindo Pedido, aguarde...','Programação x Pedido',{||ExcMZ223()})},,'NOCONNECT',,,,,,,.T.)
		_oMenu01:Add(_oTMenu3B)

	Endif

	RestArea(_Area)

Return(_cOK)



Static Function PedMZ223(_cPed)

	_aAliSC5 := SC5->(GetArea())

	SC5->(dbSetOrder(1))
	If SC5->(dbSeek(xFilial("SC5")+_cPed))

		CCADASTRO := "Pedido de Vendas"

		aRotina := {{"Pesquisar","AxPesqui"    , 0 , 1,0 ,.F.}}

		aAdd(aRotina,{"Visualizar" ,"A410Visual" , 0 , 2,0  ,NIL})
		aAdd(aRotina,{"Incluir"    ,"A410Inclui" , 0 , 3,81 ,NIL})
		aAdd(aRotina,{"Alterar"    ,"a410Altera" , 0 , 4,143,NIL})
		aAdd(aRotina,{"Excluir"    ,"A410Deleta" , 0 , 5,144,NIL})

		A410Visual("SC5",SC5->(Recno()),2)
	Endif

	RestArea(_aAliSC5)

Return(Nil)



Static Function ExcMZ223()

	Local _lRet		:= .T.
	Local _nPosNum	:= aScan(_aFldPro,{|x| x[1] == 'C6_NUM' })
	Local _cProgra	:= _aBrwPro[_oBrwPro:nAt][_nPosNum]
	Local _nPosIte	:= aScan(_aFldPro,{|x| x[1] == 'C6_ITEM' })
	Local _cPrgIte	:= _aBrwPro[_oBrwPro:nAt][_nPosIte]
	Local _nPosQtd	:= aScan(_aFldPro,{|x| x[1] == 'C6_QTDVEN' })
	Local _nQuanti	:= _aBrwPro[_oBrwPro:nAt][_nPosQtd]
	Local _AreaSC6	:= SC6->(GetArea())
	Local _cquery	:= ''
	Local _cAlias	:= CriaTrab(Nil,.F.)
	Local _nTSZ1A	:= 0

	_cQuery += " SELECT Z1.R_E_C_N_O_ AS Z1RECNO,* FROM "+RetSqlName("SZ1")+" Z1 " +CRLF
	_cQuery += " WHERE Z1.D_E_L_E_T_ = '' " +CRLF
	_cQuery += " AND Z1_FILIAL = '"+xFilial("SZ1")+"' " +CRLF
	_cQuery += " AND Z1_PEDIDO = '"+_cProgra+"' " +CRLF
	_cQuery += " AND Z1_ITEMPV = '"+_cPrgIte+"' " +CRLF

	TcQuery _cQuery NEW ALIAS (_cAlias)

	Count to _nTSZ1A

	_nQtPed := 0

	If _nTSZ1A > 0

		(_cAlias)->(dbGoTop())

		While (_cAlias)->(!EOF())

			_nQtPed += (_cAlias)->Z1_QUANT

			(_cAlias)->(dbSkip())
		EndDo
	Endif

	If _nQtPed <> _nQuanti
		ShowHelpDlg("MZ0223", {'Quantidade total do(s) pedido(s) diferente da programação!'},2,{'Programação já faturada.'},2)
		_lRet := .F.
	Else

		(_cAlias)->(dbGoTop())

		While (_cAlias)->(!EOF())

			SZ1->(dbgoto((_cAlias)->Z1RECNO))

			SZ1->(RecLock("SZ1",.F.))
			SZ1->(dbDelete())
			SZ1->(msUnLock())

			(_cAlias)->(dbSkip())
		EndDo

		SC6->(dbsetOrder(1))
		If SC6->(msSeek(xFilial("SC6")+_cProgra+_cPrgIte))
			SC6->(RecLock("SC6",.F.))
			SC6->C6_YPEDGER := 'N'
			SC6->(MsUnlock())
		Endif

	Endif

	(_cAlias)->(dbCloseArea())

	If _lRet
		//MZ223C("A")	//Marcus Vinicius - 28/02/2018 - criado nova função para montagem da grid MVSZ223C
		MVSZ223C("A")
	Endif

	RestArea(_AreaSC6)

Return(_lRet)


//Popula o Grid
Static Function MVSZ223C()

	Local _aAreaAtu		:= GetArea()
	Local _cYBLQSCI		:= GetMV('MV_YBLQSCI')
	Local _cYBLQSIN		:= GetMV('MV_YBLQSIN')
	Local _xContent		:= Nil

	Private _cPerLimCred	:= GETMV("MZ_PERLIM")
	Private _cCliLoja		:= ''
	Private _dData			:= Date()

	If Dow(_dData) == 7      // SABADO
		_dData    := _dData - 2
	ElseIf Dow(_dData) == 1  // DOMINGO
		_dData    := _dData - 3
	ElseIf Dow(_dData) == 2  // SEGUNDA
		_dData    := _dData - 3	// Marcus Vinicius - 26/07/2016 - Alterado para validar os títulos vencidos na sexta-feira.
	Else
		_dData    := _dData -1
	Endif


	If Select("TSC6'") > 0
		TSC6->(DbCloseArea())
	Endif

	_cSQL := " SELECT " +CRLF

	For Fc := 1 To Len(_aFldPro)
		_cSQL += " "+_aFldPro[Fc][1]+If(Fc=Len(_aFldPro)," ",", ") +CRLF
	Next Fc

	_cSQL += " ,A1_YBLQSCI, A1_YBLQSIN, A1_RISCO, A1_YLIB, A1_MSBLQL, A1_COND,A1_GRPVEN " +CRLF
	_cSQL += " FROM "+RetSqlName("SC6") +" SC6 " +CRLF
	_cSQL += " INNER JOIN "+RetSqlName("SC5") +" SC5 ON C5_NUM = C6_NUM AND C5_FILIAL = C6_FILIAL " +CRLF
	_cSQL += " INNER JOIN "+RetSqlName("SA1") +" SA1 ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA " +CRLF
	_cSQL += " INNER JOIN "+RetSqlName("SB1") +" SB1 ON C6_PRODUTO = B1_COD " +CRLF
	_cSQL += " WHERE SC6.D_E_L_E_T_ = '' AND SC5.D_E_L_E_T_ = '' AND SA1.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' " +CRLF
	_cSQL += " AND C5_FILIAL = '"+xFilial("SC5")+"' AND C6_FILIAL = '"+xFilial("SC6")+"' AND A1_FILIAL = '"+xFilial("SA1")+"' " +CRLF
	_cSQL += " AND B1_FILIAL = '"+xFilial("SB1")+"' " +CRLF
	_cSQL += " AND C6_QTDVEN > C6_QTDENT " +CRLF
	_cSQL += " AND C6_BLQ = '' " +CRLF
	_cSQL += " AND C5_TIPO = 'N' " +CRLF
	_cSQL += " AND B1_YVEND = 'S' " +CRLF
	_cSQL += " ORDER BY C6_CLI,C6_LOJA,C6_NUM, C6_ITEM " +CRLF

	//	MemoWrite("D:\MZ0223.TXT",_cSQL)

	TcQuery _cSQL New Alias "TSC6"

	TcSetField("TSC6","C5_YDTIMPR","D")
	TcSetField("TSC6","C5_EMISSAO","D")
	TcSetField("TSC6","C6_ENTREG","D")
	TcSetField("TSC6","A1_YBLQSCI","D")
	TcSetField("TSC6","A1_YBLQSIN","D")

	TSC6->(dbGoTop())

	_cCliLoja := ''

	_aBrwPro		:= {}

	While TSC6->(!EOF())

		AADD(_aBrwPro,Array(Len(_aFldPro)))
		_nLen := Len(_aBrwPro)

		For Fd := 1 To Len(_aFldPro)
			If Fd = 1
				_cLeg := ''
				If TSC6->C6_YPEDGER == 'S'
					_cLeg := "0" //					_cLeg := _oClose
				ElseIf _cCliLoja <> TSC6->C6_CLI+TSC6->C6_LOJA

					_cCliLoja := TSC6->C6_CLI+TSC6->C6_LOJA

					If (ddatabase - TSC6->A1_YBLQSCI) > _cYBLQSCI .and. (ddatabase - TSC6->A1_YBLQSIN) > _cYBLQSIN
						_cLeg := "1" //					_cLeg := _oBlack
					ElseIf (ddatabase - TSC6->A1_YBLQSCI) > _cYBLQSCI
						_cLeg := "2" //					_cLeg := _oYellow
					ElseIf (ddatabase - TSC6->A1_YBLQSCI) > _cYBLQSIN
						_cLeg := "3" //					_cLeg := _oBlue
					Else
						_cLeg := "4" //					_cLeg := _oChekOK
					Endif

					If _cLeg == "4"
						_cLeg := MvsChkCli(_cLeg,TSC6->C6_CLI,TSC6->C6_LOJA)
					Endif

					_cLegCliProc := _cLeg

				Else
					_cLeg := _cLegCliProc
				EndIf

				_aBrwPro[_nLen][Fd] := _cLeg
			Else
				_xContent := &('TSC6->'+_aFldPro[Fd][1])
				If _aFldPro[Fd][1] = 'C5_YTIPOPD'
					If Empty(_xContent)
						_xContent := 'N'
					Endif
				Endif
				//				_aBrwPro[_nLen][Fd] := &('TSC6->'+_aFldPro[Fd][1])
				_aBrwPro[_nLen][Fd] := _xContent

			Endif
		Next Fd

		TSC6->(DbSkip())
	EndDo

	TSC6->(DbCloseArea())

	_oBrwPro:SetArray(_aBrwPro)

	If Len(_oBrwPro:aArray) <> 0
		_oBrwPro:bLine := {|| GetArray(_oBrwPro,_aBrwPro,_aFldPro)}
	Endif

	IndexGrid(_oBrwPro:aArray,_oBrwPro,_cPes1,_aHeadPro,_aFldPro,2)

	If Select("TSZ1") > 0
		TSZ1->(DbCloseArea())
	Endif

	_cSQL := " SELECT " +CRLF
	For Ff := 1 To Len(_aFldPed)
		_cSQL += " "+_aFldPed[Ff][1]+If(Ff=Len(_aFldPed)," ",", ") +CRLF
	Next Ff
	_cSQL += " ,Z1_DTCANC,Z1_USERLGA,Z1_FILIAL,A1_YBLQSCI, A1_YBLQSIN " +CRLF
	_cSQL += " FROM "+RetSqlName("SZ1")+" SZ1 INNER JOIN "+RetSqlName("SA1")+" ON Z1_CLIENTE = A1_COD AND Z1_LOJA = A1_LOJA " +CRLF
	_cSQL += " WHERE SZ1.D_E_L_E_T_ = '' " +CRLF
	_cSQL += " AND Z1_FILIAL = '"+xFilial("SZ1")+"' " +CRLF
	_cSQL += " AND Z1_DTCANC = '' " +CRLF
	_cSQL += " ORDER BY Z1_NUM " +CRLF

	TcQuery _cSQL New Alias "TSZ1"

	TcSetField("TSZ1","Z1_YDTIMPR","D")
	TcSetField("TSZ1","Z1_EMISSAO"	,"D")
	TcSetField("TSZ1","Z1_DTENT"	,"D")
	TcSetField("TSZ1","Z1_DTCANC"	,"D")
	TcSetField("TSZ1","A1_YBLQSCI"	,"D")
	TcSetField("TSZ1","A1_YBLQSIN"	,"D")

	TSZ1->(dbGoTop())

	_aBrwPed		:= {}

	While TSZ1->(!EOF())

		AADD(_aBrwPed,Array(Len(_aFldPed)))
		_nLen := Len(_aBrwPed)
		For Fg := 1 To Len(_aFldPed)
			If Fg = 1
				_cLeg := ''
				If TSZ1->Z1_LIBER == 'S' .And. Empty(Z1_DTCANC)
					_cLeg := _oGreen
				ElseIf TSZ1->Z1_LIBER == 'B' .and. ((ddatabase - TSZ1->A1_YBLQSCI) > _cYBLQSCI  .and. (ddatabase - TSZ1->A1_YBLQSIN) > _cYBLQSIN)
					_cLeg := _oBlack
				ElseIf TSZ1->Z1_LIBER == 'B' .and. ((ddatabase - TSZ1->A1_YBLQSIN) > _cYBLQSIN)
					_cLeg := _oBlue
				ElseIf TSZ1->Z1_LIBER == 'B' .and. ((ddatabase - TSZ1->A1_YBLQSCI) > _cYBLQSCI)
					_cLeg := _oYellow
				ElseIf !Empty(TSZ1->Z1_DTCANC) .AND. ALLTRIM(TSZ1->Z1_USERLGA) =='MIZ019'
					//					_cLeg := _oCancel
					_cLeg := _oBrow
				ElseIf !(TSZ1->Z1_FILIAL $ _cRastroOC) .AND. !Empty(TSZ1->Z1_DTCANC)
					_cLeg := _oBrow
				ElseIf TSZ1->Z1_LIBER == 'B'
					_cLeg := _oRed
				Endif

				_aBrwPed[_nLen][Fg] := _cLeg
			Else
				_aBrwPed[_nLen][Fg] := &('TSZ1->'+_aFldPed[Fg][1])
			Endif
		Next Fg

		TSZ1->(DbSkip())
	EndDo

	TSZ1->(DbCloseArea())

	_oBrwPed:SetArray(_aBrwPed)

	If Len(_oBrwPed:aArray) <> 0
		_oBrwPed:bLine := {|| GetArray(_oBrwPed,_aBrwPed,_aFldPed)}
	Endif

	IndexGrid(_oBrwPed:aArray,_oBrwPed,_cPes2,_aHeadPed,_aFldPed,2)

	_oBrwPro:Refresh()
	_oBrwPed:Refresh()

	RestArea(_aAreaAtu)

//	If _cOpc <> "A"
//		MsgInfo("Status Atualizado as " + Time())
//	Endif

Return(Nil)


Static Function MvsChkCli(_cOpc,_cCli,_cLj)

	Local _cSQLSE1 := ''

	If TSC6->A1_RISCO == "D" .Or. TSC6->A1_RISCO == "E"

		ShowHelpDlg("MZ0223", {'Cliente com risco "D" ou "E".'},2,{'Contate o Financeiro para ajuste do grau de risco do Cliente.'},2)

		_cOpc := "8" //Cliente com Risco D ou E

		Return(_cOpc)
	Endif

	_cCond := TSC6->A1_COND

	If TSC6->A1_YLIB == "N" .OR. TSC6->A1_MSBLQL == "1"

		_cOpc := "6" //Cliente Bloqueado

		Return(_cOpc)
	Endif

	ZA6->(dbSetOrder(1))
	If ZA6->(!dbSeek(xFilial("ZA6") + TSC6->C6_CLI + TSC6->C6_LOJA + "L"))
		//ShowHelpDlg("MZ0223", {'Cliente solicitado está Sem Limite de Credito!'},2,{'Solicite atualização do cadastro de Cliente.'},2)

		_cOpc := "7" //Cliente sem Limite de crédito
		Return(_cOpc)
	EndIf

	If _cOpc == "4"

		If Select("TSE1") > 0
			TSE1->(DbCloseArea())
		Endif

		_cSQLSE1 := " SELECT E1_FILIAL,E1_CLIENTE,E1_LOJA "
		_cSQLSE1 += " FROM "+RetSqlName("SE1")+" E INNER JOIN "+RetSqlName("SA1")+" A ON E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA "
		_cSQLSE1 += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND E1_CLIENTE = '"+TSC6->C6_CLI+"' AND E1_LOJA = '"+TSC6->C6_LOJA+"' "
		_cSQLSE1 += " AND E1_STATUS = 'A' AND E1_VENCREA <= '"+DTOS(_dData)+"' AND E1_TIPO = 'NF'  AND A1_RISCO <> 'S'  AND E.D_E_L_E_T_ = '' "
		_cSQLSE1 += " GROUP BY E1_FILIAL,E1_CLIENTE,E1_LOJA
		_cSQLSE1 += " ORDER BY E.E1_FILIAL,E.E1_CLIENTE,E.E1_LOJA

		TcQuery _cSQLSE1 New Alias "TSE1"

		TSE1->(dbGoTop())

		IF TSE1->(!EOF())     // Verifica se a área de trabalho não está no final de arquivo
			_cOpc := "5"
		EndIf

		TSE1->(DbCloseArea())

		If _cCond != "100" .and. _cOpc == "4"
			If TSC6->A1_RISCO != "S"

				_cQ := " SELECT Z1_CLIENTE,Z1_LOJA,SUM(Z1_QUANT * Z1_PCOREF) AS TOTAL "
				_cQ += " FROM "+RetSqlName("SZ1")+" A WHERE A.D_E_L_E_T_ = '' AND Z1_CLIENTE = '"+TSC6->C6_CLI+"' "
				_cQ += " AND Z1_LOJA = '"+TSC6->C6_LOJA+"' AND Z1_DTCANC = '' "
				_cQ += " GROUP BY Z1_CLIENTE,Z1_LOJA "
				_cQ += " ORDER BY Z1_CLIENTE,Z1_LOJA "

				TCQUERY _cQ NEW ALIAS "ZZ1"

				_nPedido := ZZ1->TOTAL

				ZZ1->(dbCloseArea())

				_nSdoTit := ZA6->ZA6_SDOTIT	+ _nPedido
				_nDif    := ZA6->ZA6_VALOR  - _nSdoTit

				If _nDif < 0
					_nDif := _nDif * -1

					_nPerc   := (_nDif / ZA6->ZA6_VALOR) * 100

					If _nPerc > _cPerLimCred
						//ShowHelpDlg("MZ0223", {'3 - Limite de Crédito Excedido em '+ STR(GETMV("MZ_PERLIM"),2)+' %.'},2,{'Solicite atualização do cadastro de Cliente.'},2)
						_cOpc := "7" //Cliente sem Limite de crédito ou Excedido
						Return(_cOpc)
					Endif
				Endif
			Endif
		Endif

	EndIf

Return(_cOpc)