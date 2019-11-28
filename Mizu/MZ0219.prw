#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'RWMAKE.CH'

/*/{Protheus.doc} MZ0219
//Monitor do Trafego de Carga para os "CD's" 
@author Fabiano
@since 07/04/2017
@version 1.0
@type Function
/*/
User Function MZ0219

	Private _nVeicPatio		:= 0
	Private _nVeicAge		:= 0
	Private _cNumOC			:= ""
	Private aFilBrw			:={}

	SetPrvt("_oFont1","_oFont3","_oDlg1","oSay1","_oBmp8","_oBmp10","_oSay14","_oSay16","oBmp3","oSay2")
	SetPrvt("oSay4","oSay5","oSay6","oSay7","oBmp2","oBmp4","oBmp5","oBmp6","oBmp7","_oGrupo","oSay8","oSay9")
	SetPrvt("_oSay11","_oSay12","oSay13","_oBrw1")

	SetPrvt("oSay1d","_oBmp8d","oBmpd3","oSay2d")
	SetPrvt("oSay4d","oSay5d","oSay6d","oSay7d","oBmp2d","oBmp4d","oBmp5d","oBmp6d","oBmp7d","_oGrupod","oSay8d","oSay9d")
	SetPrvt("oSay13d","_oBrw1d")

	Private _aHeader	:= {}
	Private _aColSizes	:= {}
	Private _aList1		:= {}
	Private _aList2		:= {}
	Private _lUserFull	:= .F.
	Private _nTotSC		:= 0	
	Private _oMenu01	:= Nil

	If !cFilAnt $ SuperGetMV('MZ_CD',,'')
		MsgInfo('Filial não cadastrada como "Centro de Distribuição - CD"!')
		Return(Nil)
	Endif

	_lUserFull := u_ChkAcesso("MZ0219",6,.F.)

	_oVermelho	:= LoadBitmap(GetResources(),'BR_Vermelho')
	_oVerde		:= LoadBitmap(GetResources(),'BR_VERDE')

	_oFont1		:= TFont():New( "Verdana",0,-17,,.T.,0,,700,.F.,.F.,,,,,, )
	_oFont3		:= TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
	_oDlg1		:= MSDialog():New( 080,092,680,1280,"Controle do Tráfego de Cargarregamento",,,.F.,,,,,,.T.,,,.T. )

	_nTimeOut	:= getnewPar('MV_TIME999',30000)  // 1minuto - tempo em milesegundos
	_oTimer001	:= ""
	_oTimer001	:= TTimer():New(_nTimeOut,{ || MZ219B(0) },_oDlg1)
	_oTimer001:Activate()

	_oFolder	:= TFolder():New( 0,0,{"Carregamento"},,_oDlg1,,,,.T.,.F.,540,300,)

	//	_oBmp8		:= TBitmap():New( 000,005,530,013,,"\images\azul.png",.T.,_oFolder:aDialogs[1],,,.F.,.T.,,"",.T.,,.T.,,.F. )
	_oBmp8		:= TBitmap():New( 000,005,530,013,,"\images\verde.png",.T.,_oFolder:aDialogs[1],,,.F.,.T.,,"",.T.,,.T.,,.F. )
	_oSay14		:= TSay():New( 001,250,{||"Veículos Agenciados"},_oFolder:aDialogs[1],,_oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,100,010)
	_oBmp10		:= TBitmap():New( 121,005,530,013,,"\images\vermelho.png",.T.,_oFolder:aDialogs[1],,,.F.,.T.,,"",.T.,,.T.,,.F. )
	_oSay16		:= TSay():New( 123,250,{||"Veículos no Pátio"},_oFolder:aDialogs[1],,_oFont1,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_WHITE,100,009)

	_oGrupo		:= TGroup():New( 245,006,265,535,"Estatísticas",_oFolder:aDialogs[1],CLR_BLACK,CLR_WHITE,.T.,.F. )
	_oSay11		:= TSay():New( 255,017,{||"Veículos Agenciados:"},_oGrupo,,_oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,095,008)
	_oVeicAge	:= TGet():New( 252,114,{|u| If(PCount()>0,_nVeicAge:=u,_nVeicAge)},_oGrupo,020,008,'',,CLR_BLACK,CLR_WHITE,_oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","_nVeicAge",,)
	_oVeicAge:Disable()

	_oSay12		:= TSay():New( 255,402,{||"Veículos no Pátio:"},_oGrupo,,_oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,063,008)
	_oVeicPatio	:= TGet():New( 252,499,{|u| If(PCount()>0,_nVeicPatio:=u,_nVeicPatio)},_oGrupo,020,008,'',,CLR_BLACK,CLR_WHITE,_oFont3,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","_nVeicPatio",,)
	_oVeicPatio:Disable()

	// Define o tamanho e as colunas dos browses.
	MZ219A()

	_oBrw1 := TCBrowse():New( 012,005,530,109,,_aHeader,_aColSizes,_oFolder:aDialogs[1],,,,,{||},,_oFont3,,,,,.F.,,.T.,,.F.,,.T.,.T.)
	_oBrw2 := TCBrowse():New( 134,005,530,109,,_aHeader,_aColSizes,_oFolder:aDialogs[1],,,,,{||},,_oFont3,,,,,.F.,,.T.,,.F.,,.T.,.T.)

	// Realiza a consulta para popular os browses
	MZ219B(0)

	If _lUserFull

		_oBrw1:blDBLClick	:= {|| MZ219D(@_oBrw1) }
		_oBrw1:BSEEKCHANGE	:= {|| MZ219F(@_oBrw1 ) }
		_oBrw1:bRClicked	:= {|oObj,X,Y| MZ219G("Prov",_oBrw1),_oMenu01:Activate( X, Y, oObj )}

		_oBrw2:blDBLClick	:= {|| MZ219D(@_oBrw2) }
		_oBrw2:BSEEKCHANGE	:= {|| MZ219F(@_oBrw2 ) }
		_oBrw2:bRClicked	:= {|oObj,X,Y| MZ219G("Prov",_oBrw2),_oMenu01:Activate( X, Y, oObj )}

	Endif

	//botoes laterais

	_nAltura	:= 009
	_nLin		:= 015
	_nEspaco	:= 10

	_oSayNf      := TSay():New( _nLin ,545,{||"Nota Fiscal"},_oDlg1,,_oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,085,008)
	_oBt_NFe      := TButton():New( _nLin+=_nEspaco ,542,"NF-e Sefaz"	,_oDlg1	, {||  MZ219E('NFE')      }  ,050,_nAltura,,,,.T.,,"",,,,.F. )
	_oBt_Mnt      := TButton():New( _nLin+=_nEspaco ,542,"Monitor"		,_oDlg1	, {||  MZ219H('MNT')    } ,050,_nAltura,,,,.T.,,"",,,,.F. )
	_oBt_Dan      := TButton():New( _nLin+=_nEspaco ,542,"Danfe"		,_oDlg1	, {||  MZ219H('DAN')    } ,050,_nAltura,,,,.T.,,"",,,,.F. )
	_oBt_Sta      := TButton():New( _nLin+=_nEspaco ,542,"Status Sefaz"	,_oDlg1	, {||  MZ219H('STA')    } ,050,_nAltura,,,,.t.,,"",,,,.f. )
	_oBt_Rem      := TButton():New( _nLin+=_nEspaco ,542,"Transmisão"	,_oDlg1	, {||  MZ219H('REM')    } ,050,_nAltura,,,,.t.,,"",,,,.f. )
	/*IF Upper(GetEnvServer()) $ 'FATURAMENTO'
		_oBt_Mdf  := TButton():New(_nLin+=_nEspaco ,542,"Mdf-e",_oDlg1		,     {||   MZ219H('MDF')    } ,050,_nAltura,,,,.t.,,"",,,,.f. ) //Cassiano Henrique - Chamado Nº 49405 - Chamada de função MDF-E
	Endif
*/
	_nLin+=10

	_oSayVda      := TSay():New( _nLin+=_nEspaco  ,545,{||"Pedido"},_oDlg1,,_oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,085,008)
	_oBt_Ped      := TButton():New( _nLin+=_nEspaco ,542,"Pedido Mizu" , _oDlg1		, {||  MZ219E('PED')   } ,050,_nAltura,,          ,,.T.,,"",,,,.F. )
	_oBt_Age      := TButton():New( _nLin+=_nEspaco ,542,"Agenciamento" , _oDlg1	, {||  MZ219E('AGE')    } ,050,_nAltura,,          ,,.T.,,"",,,,.F. )
	_oBt_IOC      := TButton():New( _nLin+=_nEspaco ,542,"Imp.Ord.Carreg" , _oDlg1	, {||  MZ219E('IOC')    } ,050,_nAltura,,          ,,.T.,,"",,,,.F. )

	_nLin+=20

	_oSayVda      := TSay():New( _nLin+=_nEspaco  ,545,{||"Cadastro"},_oDlg1,,_oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,085,008)
	_oBt_Cli      := TButton():New( _nLin+=_nEspaco ,542,"Cliente" , _oDlg1			, {||  MZ219E('CLI')    } ,050,_nAltura,,          ,,.T.,,"",,,,.F. )
	_oBt_Mot      := TButton():New( _nLin+=_nEspaco ,542,"Motorista" , _oDlg1		, {||  MZ219E('MOT')    } ,050,_nAltura,,          ,,.T.,,"",,,,.F. )
	_oBt_Tra      := TButton():New( _nLin+=_nEspaco ,542,"Transportadora" , _oDlg1	, {||  MZ219E('TRA')    } ,050,_nAltura,,          ,,.T.,,"",,,,.F. )
	_oBt_Cam      := TButton():New( _nLin+=_nEspaco ,542,"Caminhão" , _oDlg1		, {||  MZ219E('CAM')    } ,050,_nAltura,,          ,,.T.,,"",,,,.F. )
	_oBt_Car      := TButton():New( _nLin+=_nEspaco ,542,"Carreta" , _oDlg1			, {||  MZ219E('CAR')    } ,050,_nAltura,,          ,,.T.,,"",,,,.F. )


	If !_lUserFull

		_oBt_NFe:Disable()
		_oBt_NFe:Disable()
		_oBt_Mnt:Disable()
		_oBt_Dan:Disable()
		_oBt_Sta:Disable()
		_oBt_Rem:Disable()
		_oBt_Cli:Disable()
		_oBt_Por:Disable()
		/*if Upper(GetEnvServer()) $ 'FATURAMENTO'
			_oBt_Mdf:disable() //Cassiano Henrique
		Endif*/

	Endif

	Set Key VK_F5 TO MZ219B()

	_oDlg1:Activate(,,,.T.)

	Set Key VK_F5 TO

Return



//Funcao que monta aHeader e Monta Area de Trabalho
Static Function MZ219A()

	SX3->(DbSetOrder(2)) // Nome Campo

	SX3->(msSeek("Z8_STATUS"))	;aAdd(_aHeader, " ")			 	; aAdd(_aColSizes,1)
	SX3->(msSeek("Z8_HRAGENC"))	;aAdd(_aHeader, Trim(X3Titulo())) 	; aAdd(_aColSizes,30)
	SX3->(msSeek("Z8_PLACA"))	;aAdd(_aHeader, Trim(X3Titulo())) 	; aAdd(_aColSizes,25)
	SX3->(msSeek("Z8_MOTOR"))	;aAdd(_aHeader, Trim(X3Titulo())) 	; aAdd(_aColSizes,150)
	SX3->(msSeek("Z8_PSENT"))	;aAdd(_aHeader, Trim(X3Titulo())) 	; aAdd(_aColSizes,40)
	SX3->(msSeek("Z8_OC"))		;aAdd(_aHeader, Trim(X3Titulo())) 	; aAdd(_aColSizes,40)
	SX3->(msSeek("Z8_PALLET"))	;aAdd(_aHeader, Trim(X3Titulo())) 	; aAdd(_aColSizes,40)
	SX3->(msSeek("Z1_FRETE"))	;aAdd(_aHeader, Trim(X3Titulo())) 	; aAdd(_aColSizes,40)

Return


// Atualiza os grids
Static Function MZ219C()

	Local _aAreaAtu		:= GetArea()
	Local _cStat		:= "Z8_STATUS"
	Local _aVeicAge		:= {}
	Local _aVeicPatio	:= {}

	_aList1				:= {}
	_aList2				:= {}
	_nVeicAge			:= 0
	_nVeicPatio			:= 0
	_cZ1Frete			:= ''

	_cSQL := "SELECT "+_cStat+", Z8_HRAGENC, Z8_PAGER, Z8_PLACA, Z8_NOMMOT, Z8_PSENT, Z8_OC, Z8_PATIO, " +CRLF
	_cSQL += " Z8_TPOPER, Z8_SACGRA , Z8_IHM, Z8_PALLET, Z8_CILINDR, LEFT(Z8_CATEGMP,2) AS Z8_CATEGMP, Z8_HORPES " +CRLF
	_cSQL += " FROM "+RetSqlName("SZ8") +" SZ8 " +CRLF
	_cSQL += " WHERE Z8_DATA >= '"+DTOS(dDataBase-20)+"' " +CRLF
	//_cSQL += " WHERE Z8_DATA   <= '" +DTOS(dDataBase)+ "'" +CRLF	//Marcus Vinicius - 28/06/2018 - Ajustado validação de data para buscar apenas os ultimos 20 dias
	_cSQL += " AND   Z8_FATUR <> 'S'" +CRLF // NAO FATURADOS
	_cSQL += " AND   Z8_PRODUTO <> '' " +CRLF
	_cSQL += " AND   Z8_DTAGEN <> '' " +CRLF
	_cSQL += " AND   Z8_STATUS2 <> 'C' " +CRLF
	_cSQL += " AND   SZ8.D_E_L_E_T_= ' ' AND Z8_FILIAL = '" + xFilial("SZ8") + "' " +CRLF
	_cSQL += " ORDER BY Z8_DATA, Z8_HORA " +CRLF

	TcQuery _cSQL New Alias "TSZ8"

	TSZ8->(dbGoTop())

	While TSZ8->(!EOF())

		_aListAux := {}

		_cZ1Frete := Posicione("SZ1",8,xFilial("SZ1")+TSZ8->Z8_OC,"Z1_FRETE")

		_aListAux := {;
		TSZ8->&(_cStat),;
		TSZ8->Z8_HRAGENC,;
		TSZ8->Z8_PLACA,;
		SUBSTR(TSZ8->Z8_NOMMOT,1,30),;
		TSZ8->Z8_PSENT,;
		TSZ8->Z8_OC,;
		TSZ8->Z8_PALLET,;
		_cZ1Frete}

		If TSZ8->Z8_TPOPER == "C" .AND. TSZ8->Z8_SACGRA == "S" .AND. TSZ8->Z8_PATIO = '2'
			AADD(_aVeicAge,_aListAux)
		ElseIf TSZ8->Z8_TPOPER == "C" .AND. TSZ8->Z8_SACGRA == "S" .AND. TSZ8->Z8_PATIO = '1'						//CARREGAMENTO FABRICA SACO
			AADD(_aVeicPatio,_aListAux)
		Endif

		TSZ8->(DbSkip())
	EndDo
	TSZ8->(DbCloseArea())

	//Veiculos Agenciados
	_aList1 	:= _aVeicAge
	_nVeicAge 	:= LEN(_aVeicAge)

	//Veículos no Pátio  
	_aList2 	:= _aVeicPatio
	_nVeicPatio := LEN(_aVeicPatio)

	If Len(_aList1) = 0
		_aListAux := {" ",Criavar("Z8_HRAGENC"),Criavar("Z8_PLACA"),Criavar("Z8_NOMMOT"),Criavar("Z8_PSENT"), space( TamSx3('Z8_OC')[1] ), space( 1 ), space( 1 ), space( 1 )}
		aAdd(_aList1, _aListAux)
	Endif

	If Len(_aList2) = 0
		_aListAux := {" ",Criavar("Z8_HRAGENC"),Criavar("Z8_PLACA"),Criavar("Z8_NOMMOT"),Criavar("Z8_PSENT"), space( TamSx3('Z8_OC')[1] ), space( 1 ), space( 1 ), space( 1 )}
		aAdd(_aList2, _aListAux)
	Endif

	_oBrw1:SetArray(_aList1)
	_oBrw2:SetArray(_aList2)

	If Len(_oBrw1:aArray) <> 0
		_oBrw1:bLine := {|| {;
		_oVerde,;
		_oBrw1:aArray[_oBrw1:nAt,02],;
		_oBrw1:aArray[_oBrw1:nAt,03],;
		_oBrw1:aArray[_oBrw1:nAT,04],;
		TransForm(_oBrw1:aArray[_oBrw1:nAT,05],'@E 99,999.999'),;
		_oBrw1:aArray[_oBrw1:nAT,06],;
		_oBrw1:aArray[_oBrw1:nAT,07],;
		_oBrw1:aArray[_oBrw1:nAT,08]}}
	Endif


	If Len(_oBrw2:aArray) <> 0
		_oBrw2:bLine := {|| {;
		_oVermelho,;
		_oBrw2:aArray[_oBrw2:nAt,02],;
		_oBrw2:aArray[_oBrw2:nAt,03],;
		_oBrw2:aArray[_oBrw2:nAT,04],;
		TransForm(_oBrw2:aArray[_oBrw2:nAT,05],'@E 99,999.999'),;
		_oBrw2:aArray[_oBrw2:nAT,06],;
		_oBrw2:aArray[_oBrw2:nAT,07],;
		_oBrw2:aArray[_oBrw2:nAT,08]}}
	Endif

	_oBrw1:Refresh()
	_oBrw2:Refresh()
	_oVeicAge:Refresh()
	_oVeicPatio:Refresh()

	RestArea(_aAreaAtu)

Return



//Função a ser executado ao clicar sobre a linha do grid
Static Function MZ219D(_oBrwAux)

	Local _cHour
	Local _cPlacaCar
	Local _cMotorCar
	Local _nPesoEnt
	Local _cStatFat		:= "B"
	Local _lPatio		:= .F.
	Local _lFatura		:= .F.
	Local _lRemove		:= .F.

	If Len(_oBrwAux:aArray) = 0
		Return
	Endif

	_cHour		:= _oBrwAux:aArray[_oBrwAux:nAT,2]
	_cPlacaCar	:= _oBrwAux:aArray[_oBrwAux:nAT,3]
	_cMotorCar	:= _oBrwAux:aArray[_oBrwAux:nAT,4]
	_nPesoEnt	:= Posicione("SZ2",1,xFilial("SZ2")+_cPlacaCar,"Z2_TARA")

	If Empty(_cPlacaCar)
		Return(Nil)
	Endif

	SZ8->(dbsetorder(1))
	SZ8->(msSeek(xFilial("SZ8")+_oBrwAux:aArray[_oBrwAux:nAT,6])) //Posiciona na OC para faturar

	SetPrvt("_oDlg2","_oSay1","_oSay2","_oSay3","_oSay4","_oBtn2","_oBtn3","_oBtn4","_oBtn5","_oGet1","_oGet2","_oGet3","_oGet4","_cStatus")

	DEFINE MSDIALOG _oDlg2 TITLE "Operações" FROM 0,0 TO 145,380 PIXEL Style DS_MODALFRAME

	_oDlg2:lEscClose := .F. //Não permite fechar a janela pelo botão "ESC"

	_oSay1		:= TSay():New( 005,012,{||"Hora"}		,_oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
	_oGet1		:= TGet():New( 004,040,{|u| If(PCount()>0,_cHour:=u,_cHour)}		,_oDlg2,050,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","_cHour",,)

	_oSay2		:= TSay():New( 005,100,{||"Placa"}		,_oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
	_oGet2		:= TGet():New( 004,128,{|u| If(PCount()>0,_cPlacaCar:=u,_cPlacaCar)},_oDlg2,050,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","_cPlacaCar",,)

	_oSay3		:= TSay():New( 018,012,{||"Motorista"}	,_oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
	_oGet3		:= TGet():New( 017,040,{|u| If(PCount()>0,_cMotorCar:=u,_cMotorCar)},_oDlg2,138,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","_cMotorCar",,)

	_oSay4		:= TSay():New( 031,012,{||"Peso Entrada"}	,_oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
	_oGet4		:= TGet():New( 030,040,{|u| If(PCount()>0,_nPesoEnt:=u,_nPesoEnt)},_oDlg2,050,008,'@E 99,999.999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","_nPesoEnt",,)

	_cStatus	:= _oBrwAux:aArray[_oBrwAux:nAT,1]

	If SZ8->Z8_PATIO = '2'
		_oBtn4      := TButton():New( 050,005,"Pátio"			,_oDlg2,{|| _lPatio := .T., _oDlg2:End()},050,015,,,,.T.,,"",,,,.F. )
		_oBtn3      := TButton():New( 050,115,"Fechar"			,_oDlg2,{|| _oDlg2:End()},050,015,,,,.T.,,"",,,,.F. )
	Else
		_oBtn5      := TButton():New( 050,005,"Remover Pátio"	,_oDlg2,{|| _lRemove := .T., _oDlg2:End()},050,015,,,,.T.,,"",,,,.F. )
		_oBtn4      := TButton():New( 050,060,"Faturar"			,_oDlg2,{|| _lFatura := .T., _oDlg2:End()},050,015,,,,.T.,,"",,,,.F. )
		_oBtn3      := TButton():New( 050,115,"Fechar"			,_oDlg2,{|| _oDlg2:End()},050,015,,,,.T.,,"",,,,.F. )
	Endif

	Activate MsDialog _oDlg2 Centered

	If _lPatio

		If _nPesoEnt > 0

			SZ1->(DbSetOrder(8))
			SZ1->(msSeek(xFilial("SZ1")+SZ8->Z8_OC))

			_nTotSC := 0
			_nQtTot := 0
			while SZ1->(!Eof()) .and. SZ1->Z1_FILIAL == xFilial("SZ1") .and. SZ1->Z1_OC == SZ8->Z8_OC

				If SZ1->Z1_UNID $ "SC,SA"

					SB1->(dbSetOrder(1))
					SB1->(dbSeek(xFilial("SB1")+SZ1->Z1_PRODUTO))

					_nTotSC	+= SZ1->Z1_QUANT

					_nQtTot += SZ1->Z1_QUANT * SB1->B1_CONV

				EndIf

				SZ1->(DbSkip())
			EndDo

			_nMaxVeiculo := Posicione("SZ2",1,xFilial('SZ2')+SZ8->Z8_PLACA,"Z2_PESOTRA")

			If _nQtTot > _nMaxVeiculo
				MsgStop("Peso acima da capacidade maxima do veiculo, verifique o pedido utilizado ou o cadastro do caminhão. ","Peso excedido")
				Return(Nil)
			Endif

			SZ8->(RecLock("SZ8",.F.))
			SZ8->Z8_PATIO = '1'
			SZ8->Z8_PSENT = _nPesoEnt
			SZ8->Z8_PSSAI = _nQtTot + _nPesoEnt
			SZ8->(MsunLock())
		Else
			MsgAlert("Caminhão sem o peso (Tara) cadastrado!.")
		Endif

		MZ219C()
	Endif

	If _lRemove

		SZ8->(RecLock("SZ8",.F.))
		SZ8->Z8_PATIO = '2'
		SZ8->Z8_PSENT = 0
		SZ8->Z8_PSSAI = 0
		SZ8->(MsunLock())

		MZ219C()
	Endif

	If _lFatura

		IF SZ8->Z8_PSSAI = 0
			MsgAlert('Peso Final zerado. NF não será gerada!')
			Return(Nil)
		Endif

		SZ1->(DbSetOrder(8))
		SZ1->(msSeek(xFilial("SZ1")+SZ8->Z8_OC))

		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1")+SZ1->Z1_PRODUTO))

		//Variáveis utilizadas na função Gera_NF()
		Private _loDlg4			:= .F.
		Private _peso_liq		:= SZ8->Z8_PSSAI - SZ8->Z8_PSENT
		Private _peso_liqcalc	:= SZ8->Z8_PSSAI - SZ8->Z8_PSENT
		Private _nf				:= ""
		Private _serie			:= Space(3)
		Private _prefixo		:= Space(3)
		Private _hora			:= left(time(),5)
		Private _DtSaida		:= dDataBase
		Private _tes			:= SZ1->Z1_TES
		Private lAltLacre		:= .F.
		Private _lTicket		:= .F.
		Private nqtven 			:= 0
		Private cprven			:= ""
		Private aNotas			:= {}
		Private _cTpPed			:= SZ1->Z1_TIPO
		Private _cNumPed		:= SZ1->Z1_YPEDB
		Private _dEmissao		:= dDataBase
		Private _cHora			:= Left(time(),5)
		Private _cMin			:= Right(_cHora,2)
		Private _peso_sai		:= SZ8->Z8_PSSAI
		Private ypalt			:= "N"
		Private cColeta			:= "S"
		Private cOrigem			:= "MZ0219"
		Private _dDatBkp		:= dDataBase
		Private _nPedagio		:= SZ8->Z8_PEDAGIO
		Private _localcli		:= SZ1->Z1_LOCAL
		Private _ufCli			:= SZ1->Z1_UFE
		//Variaveis utilizadas no MIZ035
		Private _cF2Placa	    := SZ1->Z1_PLACA
		Private _cF2Plcar	    := SZ1->Z1_PLCAR
		Private _cF2Plcar2	    := SZ1->Z1_PLCAR2
		Private _cPedSC6	    := SZ1->Z1_PEDIDO
		Private _cIteSC6	    := SZ1->Z1_ITEMPV
		Private _cQtdSZ1	    := SZ1->Z1_QUANT
		
/*************************************************************************************************************************************************************************************************************************/
/*		Marcus Vinicius - 05/11/2018 - Tratamento do horário de verão                                                                                                                                                                                                                           
/*************************************************************************************************************************************************************************************************************************/
		If SM0->M0_ESTCOB $ "AC/AM/MT/MS/RO/RR"
			If SUBSTR(_cHora,1,2)   == "00"
				_dEmissao--
				If SM0->M0_ESTCOB $ "AC"
					_cHora    := "22:" + _cMin // MENOS 02 HORAS
				Else
					_cHora    := "23:" + _cMin // MENOS 01 HORAS
				Endif
			Else
				_cHora := Strzero(Val(_cHora)-1,2) + ":" + _cMin
			Endif
		Endif
		
		If GETMV("MV_HVERAO") .AND. (_dEmissao >= GETMV("MV_HVERAOI") .AND. _dEmissao <= GETMV("MV_HVERAOF"))    /// SE VERDADEIRO ENTAO TEM HORARIO DE VERÃO
			If !(SM0->M0_ESTCOB $ "DF/GO/ES/MT/MS/MG/PR/RJ/RS/SP/SC")
				If SUBSTR(_cHora,1,2)   == "00"
					_dEmissao--
					_cHora    := "23:" + _cMin
				Else
					_cHora := Strzero(Val(_cHora)-1,2) + ":" + _cMin
				Endif
			Endif
		Endif
		
		dDataBase := _dEmissao
		
/*************************************************************************************************************************************************************************************************************************/

		If UPPER(Alltrim(cUserName)) $ "ALE|FABIANO|ALISON|MARCUS.VINICIUS|CASSIANO.NUNES|RAPHAEL.MOURA|VICTOR.ALVES"
			_serie   := "ZZZ"
			_prefixo := "ZZZ"
		Else
			_serie   := StrTran(PadR(getmv("MV_YSERIE"),3," "),"*"," ")
			_prefixo := alltrim(getmv("MV_YPREF"))
		Endif

		SX5->(dbSetOrder(1))
		If SX5->(MsSeek(xFilial("SX5")+"01"+_serie))
			If  subs(SX5->X5_DESCRI,1,1) == "*"
				help("Numero NF",1,"Y_MIZ001 Num NF")
				Return
			Endif
			_nf := PADR(strzero(val(SX5->X5_DESCRI),6),9)
		Else
			help("",1,"Y_MIZ002 N")
			Return(Nil)
		EndIf

		_serie		:= IIF( cFilAnt $ GetMv("MV_YFILKEY"), LEFT(_serie,1), _serie )

		_nPesoEnt 	:= SZ8->Z8_PSENT
		_lOpc 		:= .F.
		_cOC		:= SZ8->Z8_OC 

		_lOpc := MZ219I()

		If _lOpc
			_lFat := .F.
			LjMsgRun( "Gerando a NF, aguarde...", "Faturamento", {|| _lFat := U_Gera_NF() } )
			If _lFat
				If !Empty(aNotas)
					if MSGYESNO("Deseja iniciar o processo de transmissão da NF "+Alltrim(aNotas[1])+"?")
						U_MzNfetransm('TODAS',_serie, aNotas[1], aNotas[Len(aNotas)] )
					Endif
					if FindFunction("U_SMAPPPORTAL")
						U_SMAPPPORTAL(_cOC,5)
					endif
					MZ219C()
				Else
					MsgAlert('NF não foi gerada!')
				Endif
			Endif
		Endif
	Endif

Return(Nil)



//Popula o Grid
Static Function MZ219B(_nOpc)

	MZ219C() // atualiza os grids

	If _nOpc == Nil .or. _nOpc > 0
		MsgInfo("Status Atualizado as " + Time())
	Endif

	If dDataBase != DATE()  // 30/09/14 - Adicionado para evitar que notas sejam faturadas com a variavel dDataBase errada.
		dDataBase := DATE()
	Endif

Return





Static Function MZ219H(p_cOpcao,cSerie,cNotaIni,cNotaFim)

	Local _warea:= getarea()
	Local lret:=.t.
	Local cParNfeRem := SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDNFEREM"
	Local cParNfeMnt := '000179_'+SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDNFEREM"
	Local aPerg       := {}
	Local aParam      := {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC))}

	Private cCondicao := ""

	If p_cOpcao $ 'TODAS/REM'

		spedNFeRe2(cSerie,cNotaIni,cNotaFim)

	Endif

	If p_cOpcao $ 'TODAS/MNT'

		If p_cOpcao == 'TODAS'

			aParam[01] := cSerie
			aParam[02] := cNotaIni
			aParam[03] := cNotaFim

			MV_PAR01 := aParam[01] 
			MV_PAR02 := aParam[02] 
			MV_PAR03 := aParam[03] 

			while alltrim(ParamLoad(cParNfeMnt,aParam,2)) <>  alltrim(cNotaIni)
				ParamSave(cParNfeMnt,aParam,"1")
			end

			aadd(aPerg,{1,'STR0010',aParam[01],"",".T.","",".T.",30,.F.})	//"Serie da Nota Fiscal"
			aadd(aPerg,{1,'STR0011',aParam[02],"",".T.","",".T.",30,.T.})	//"Nota fiscal inicial"
			aadd(aPerg,{1,'STR0012',aParam[03],"",".T.","",".T.",30,.T.})  //"Nota fiscal final"

		Endif

		SpedNFe1Mnt()

	Endif

	If p_cOpcao $ 'TODAS/DAN'

		If p_cOpcao == 'TODAS'
			xPerg:='NFSIGW'
			aParametros:={}
			aAdd( aParametros, cNotaIni ) //da nota
			aAdd( aParametros, cNotaFim ) //da nota
			aAdd( aParametros, cSerie ) //da nota
			aAdd( aParametros, '2' ) // 1-entrada ou 2-saida
			aAdd( aParametros, '2' )  //1-imprimir ou 2-visualizar
			aAdd( aParametros, '2' )  //imprimi no verso - 1-Sim  2-Nao

			SMFATF57(aParametros,xPerg)
		Endif

		cCondicao	:= "F2_FILIAL=='"+xFilial("SF2")+"'"
		aFilBrw	:=	{'SF2',cCondicao}

		SpedDanfe()

	Endif

	If p_cOpcao $ 'STA'

		SpedNFeStatus()

	Endif
/*
	IF Upper(GetEnvServer()) $ 'FATURAMENTO'
		if p_cOpcao $ 'MDF'
			SPEDMDFE() // Cassiano Henrique
		Endif	
	Endif
*/
	RestArea(_warea)
Return



Static Function SMFATF57(aParametros,cPerg)

	Local _warea:=GetArea()

	//uso expecifico no profile
	//**************************
	Private p_name  := cEmpAnt + cUserName // variavel publica
	Private p_prog  := iif( !Empty(cPerg),cPerg,FunName())  // rotina do sistema
	Private p_task  := "PERGUNTE" // padrao do sistema para parametros tipo SX1
	Private p_type  := "MV_PAR"   //  ""     "" 			"" 				""
	Private p_defs  := ""
	//*****************************

	dbSelectArea("SX1")
	SX1->(DbSetOrder(1))

	For i:=1 to Len(aParametros)
		If SX1->(msSeek(      PadR( cperg , 10 ) + strzero(i,2)    ))
			RecLock("SX1",.f.)
			do case
				case valtype(aParametros[i]) == 'C'
				sx1->x1_cnt01 := aParametros[i]
				case valtype(aParametros[i]) == 'N'
				sx1->x1_cnt01 := val(aParametros[i])
			endcase
			MsUnlock()
		Endif
	Next

	//PREENCHE A VARIAVEL COM TODOS OS PARAMETROS, CONForME A SEQUENCIA DO PROPRIO GRUPO DE PERGUNTAS
	If sx1->(msSeek( PadR( cperg , 10 )   ))
		while !sx1->(eof()) .and.  alltrim(sx1->x1_grupo) == cPerg
			p_defs+=  sx1->x1_tipo+"#"+alltrim(sx1->x1_gsc)+"#"+sx1->x1_cnt01 + _wEnter_
			sx1->(dbskip())
		end
	Endif

	If !Empty(p_defs)
		If ( FindProfDef( p_name,p_prog,p_task,p_type) )
			WriteProfDef( p_name,p_prog,p_task,p_type, p_name,p_prog,p_task,p_type, p_defs )
		Else
			WriteNewProf( p_name,p_prog,p_task,p_type, p_defs )
		Endif
	Endif

	RestArea(_warea)

Return



Static Function MZ219E(p_cOpcao)

	Local _warea:= getArea()

	Local aParamibx := {SZ7->Z7_NUMNF, SZ7->Z7_SERIE}

	do case
		case p_cOpcao =='PED' ; u_Miz016()
		case p_cOpcao =='CLI' ; MATA030()
		case p_cOpcao =='AGE' ; u_SMFATT13()
		case p_cOpcao =='MOT' ; u_Miz010()
		case p_cOpcao =='TRA' ; MATA050()
		case p_cOpcao =='CAM' ; u_Miz005()
		case p_cOpcao =='CAR' ; u_Miz1030()
		case p_cOpcao =='IOC' ; u_MIZ050GR('botaomiz999',_cNumOC)
		case p_cOpcao =='NFE' ; SpedNFe() 
		case p_cOpcao =='CEN' ; u_miz030(_cNumOC)
		case p_cOpcao =='PAG' ; SMFATT01()	
		case p_cOpcao =='LAC' 
		case p_cOpcao =='RPE' ; SMFATT41()
		case p_cOpcao =='TK1' ; EXECBLOCK("MIZ790",.F.,.F.,aParamibx) 
		case p_cOpcao =='TK2' ; u_RTICKET()
		case p_cOpcao =='FLW' ; U_SMFLWUP()
		case p_cOpcao =='CAN' ; U_SMCANCEP(_cNumOC)
		case p_cOpcao =='RES' ; U_SMRESTP(_cNumOC)
	Endcase

	RestArea(_warea)

Return(Nil)



static Function MZ219F(_oBrwAux)

	Local _warea:= getArea()

	_oBrwAux:Refresh()

	_cNumOC:=_oBrwAux:aArray[_oBrwAux:nAT,6]

	If Empty(_oBrwAux:aArray[_oBrwAux:nAT,6]) ; Return; Endif

	SZ8->(dbsetorder(1))
	SZ8->(msSeek(xFilial("SZ8")+_cNumOC))

	RestArea(_warea)

Return(Nil)



Static Function NOTAENTREGUE(_oBrwAux)

	Local cOC	 := _oBrwAux:aArray[_oBrwAux:nAT,6]
	Local _cStat	 := "Z8_STATUS"

	If SZ8->Z8_OC = cOC
		SZ8->(RecLock("SZ8",.F.))
		SZ8->&(_cStat)   := 'D'
		SZ8->Z8_FATUR   := "S" 
		SZ8->Z8_HORAATU := time()
		SZ8->Z8_PAGER	:= ''
		SZ8->(MsUnlock())
	Endif

	MZ219B(0)

Return


//Função utilizada ao clicar com o botão direito do mouse sobre o grid
Static Function MZ219G(p_cOrigem,p_oBrwAux)

	Local _warea      := getArea()
	Local cOrigem    := iif(p_cOrigem == nil, "", ALLTRIM(p_cOrigem)) 
	Local _oBrwAux    := iif(p_oBrwAux == nil, "", p_oBrwAux)
	Local cOC        := iif(_oBrwAux == nil, "", ALLTRIM(_oBrwAux:aArray[_oBrwAux:nAT,6]))
	Local _cItensOC   := ""
	Local aCampos
	Local _aItens     := {} 
	Local _oMenuItem
	Private cCadastro

	If Empty(cOrigem) .Or. Empty(cOC)
		Return .F.
	Endif

	do case
		case cOrigem == "Produto"

		cCadastro := "Detalhes - Produto"
		aCampos   := {"NOUSER","B1_COD","B1_DESC","B1_TIPO","B1_PRV1"}

		dbSelectArea("SZ8")
		dbSetOrder(1)
		If msSeek(xFilial("SZ8")+cOC)
			dbSelectArea("SB1")
			dbSetOrder(1)
			If msSeek(xFilial("SB1")+SZ8->Z8_PRODUTO)
				AxVisual("SB1",RECNO(),1,aCampos)
			Endif
		Endif

		case cOrigem == "OC"

		cCadastro := "Detalhes - OC"
		aCampos   := {"NOUSER","Z8_OC","Z8_PLACA","Z8_NOMMOT"}

		dbSelectArea("SZ8")
		dbSetOrder(1)
		If msSeek(xFilial("SZ8")+cOC)
			iif(Empty(SZ8->Z8_ITENSOC),AAdd(aCampos,"Z8_PRODUTO"),AAdd(aCampos,"Z8_ITENSOC"))
			AxVisual("SZ8",RECNO(),1,aCampos)
		Endif

		case cOrigem == "Prov"

		_oMenu01 := tMenu():new(0,0,0,0,.T.)

		SZ8->(dbSetOrder(1))
		If SZ8->(msSeek(xFilial("SZ8")+cOC))
			If !Empty(SZ8->Z8_ITENSOC)

				_cItensOC	:= ALLTRIM(SZ8->Z8_ITENSOC)
				_aItens		:= StrTokArr(_cItensOC,"#")

				For i := 1 to LEN(_aItens)
					_aItens[i] := "Produto: "+substr(_aItens[i],1,at("/",_aItens[i])-1)
					_oMenuItem := tMenuItem():new(_oMenu01,_aItens[i],,,,{||},,,,,,,,,.T.)
					_oMenu01:Add(_oMenuItem)
				Next

			Else
				AAdd(_aItens,"Produto: "+ALLTRIM(SZ8->Z8_PRODUTO))
				For i := 1 to LEN(_aItens)
					_oMenuItem := tMenuItem():new(_oMenu01,_aItens[i],,,,{||},,,,,,,,,.T.)
					_oMenu01:Add(_oMenuItem)
				Next
			Endif
		Endif
	endcase

	RestArea(_warea)

Return



Static Function MZ219I()

	Local _lRet			:= .F.
	Local _nF2FRETE		:= 0
	Local _nQtde		:= 0
	Local _nQtdeNf		:= 0
	Local _cGetdtsai	:= _DtSaida
	Local _cGetendCl	:= _localcli
	Local _cGetestCl	:= _ufCli
	Local _cGethrsai	:= _hora
	Local _cGetnomCl	:= SZ1->Z1_NOMCLI
	Local _cGetnota		:= _nf
	Local _cGetnrLac	:= SZ8->Z8_LACRE
	Local _lacre		:= SZ8->Z8_LACRE
	Local _cGetprefi	:= _prefixo
	Local _cGetpsent	:= Transform(SZ8->Z8_PSENT    ,"@E 999,999,999.99")
	Local _cGetpssai	:= Transform(SZ8->Z8_PSSAI    ,"@E 999,999,999.99")
	Local _cGetpliqu	:= Transform(_peso_liq,"@E 999,999,999.99")
	Local _cGetsacos	:= Transform(_nTotSC,"@E 999,999")
	Local _cGetserie	:= _serie
	Local _cGetvlrpe	:= Transform(SZ8->Z8_PEDAGIO,"@E 9,999.99")
	Local _cGetfrete	:= Transform( _nF2FRETE ,"@E 9,999,999.99")
	Local _oFont1		:= TFont():New( "Verdana",0,-17,,.T.,0,,700,.F.,.F.,,,,,, )
	Local _oFont2		:= TFont():New( "Verdana",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
	Local _oFont3		:= TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
	Local _oFont14		:= TFont():New( "Verdana",0,14,,.F.,0,,400,.F.,.F.,,,,,, )
	Local _oDlg3		:= Nil
	Local _oGrp1		:= Nil
	Local _oGrp2		:= Nil
	Local _oGrp3		:= Nil
	Local _oSay1		:= Nil ; Local _oGet1	:= Nil
	Local _oSay2		:= Nil ; Local _oGet2	:= Nil
	Local _oSay3		:= Nil ; Local _oGet3	:= Nil
	Local _oSay4		:= Nil ; Local _oGet4	:= Nil
	Local _oSay5		:= Nil ; Local _oGet5	:= Nil
	Local _oSay6		:= Nil ; Local _oGet6	:= Nil
	Local _oSay7		:= Nil ; Local _oGet7	:= Nil
	Local _oSay8		:= Nil ; Local _oGet8	:= Nil
	Local _oSay9		:= Nil ; Local _oGet9	:= Nil
	Local _oSay10		:= Nil ; Local _oGet10	:= Nil
	Local _oSay11		:= Nil ; Local _oGet11	:= Nil
	Local _oSay12		:= Nil ; Local _oGet12	:= Nil
	Local _oSay13		:= Nil ; Local _oGet13	:= Nil
	Local _oSay14		:= Nil ; Local _oGet14	:= Nil
	Local _oSay15		:= Nil ; Local _oGet15	:= Nil
	Local _oGetNomCl	:= Nil
	Local _oGetEndCl	:= Nil
	Local _oUsr			:= Nil
	Local _oBtn1		:= Nil ; Local _oBtn2	:= Nil
	
	SZ3->(DbSetOrder(1))
	SZ3->(DbSeek(xFilial("SZ3")+SZ1->Z1_MOTOR))

	If Alltrim(SB1->B1_TIPCAR) == "S"
		_nQtde   := (SZ1->Z1_QUANT * SB1->B1_CONV) / 1000
		_nQtdeNf := (SZ1->Z1_QTENF * SB1->B1_CONV) / 1000
	Else
		_nQtde   := SZ1->Z1_QUANT
		_nQtdenF := SZ1->Z1_QTENF
	Endif
	
	If _nQtdenF > 0 .and. SB1->B1_YTRBIG==0 .and. SZ1->Z1_UNID $ "SC"
		_nF2FRETE := Iif(SZ3->Z3_TIPO=="2",(SZ1->Z1_FMOT * _nQtde) / (_nQtde + _nQtdenF),(SZ1->Z1_FTRA * _nQtde)/(_nQtde + _nQtdenF))
	Else
		_nF2FRETE := Iif(SZ3->Z3_TIPO=="2",SZ1->Z1_FMOT,SZ1->Z1_FTRA) //SZ1->Z1_VLFRE
	EndIf
 
	 _cGetfrete	:= Transform( _nF2FRETE ,"@E 9,999,999.99")
 
	_oDlg3		:= MSDialog():New( 101,258,508,1006,"Consulta Dados da  Fatura",,,.F.,,,,,,.T.,,,.T. )
	_oDlg3:lEscClose := .F. //Não permite fechar a janela pelo botão "ESC"
// Style DS_MODALFRAME
 
	_oGrp1		:= TGroup():New( 004,012,052,356,"Dados do Cliente",_oDlg3,CLR_HRED,CLR_WHITE,.T.,.F. )
	_oSay1		:= TSay():New( 018,020,{||"Nome"},_oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	_oGet1		:= TGet():New( 016,060,{|u| If(PCount()>0,_cGetnomCli:=u,_cGetnomCli)},_oGrp1,184,008,'',,CLR_BLACK,CLR_WHITE,/*fonte*/,,,.t.,"",,,.F.,.F.,,.F.,.F.,"","_cGetnomCli",,)
	_oGet1:Disable()

	_oSay2		:= TSay():New( 036,020,{||"Endereço"},_oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	_oGet2		:= TGet():New( 033,060,{|u| If(PCount()>0,_cGetendCl:=u,_cGetendCl)},_oGrp1,184,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cGetendCl",,)
	_oGet2:Disable()

	_oSay3		:= TSay():New( 036,288,{||"Estado"},_oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	_oGet3		:= TGet():New( 033,308,{|u| If(PCount()>0,_cGetestCli:=u,_cGetestCli)},_oGrp1,032,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cGetestCli",,)
	_oGet3:Disable()


	_oGrp2		:= TGroup():New( 056,012,112,356,"Dados do Transporte",_oDlg3,CLR_HRED,CLR_WHITE,.T.,.F. )
	
	_oSay4		:= TSay():New( 068,020,{||"Peso Entrada"},_oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	_oGet4		:= TGet():New( 068,060,{|u| If(PCount()>0,_cGetpsent:=u,_cGetpsent)},_oGrp2,050,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cGetpsent",,)
	_oGet4:Disable()

	_oSay5		:= TSay():New( 080,020,{||"Peso Saida"},_oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	_oGet5		:= TGet():New( 080,060,{|u| If(PCount()>0,_cGetpssai:=u,_cGetpssai)},_oGrp2,050,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cGetpssai",,)
	_oGet5		:Disable()

	_oSay6		:= TSay():New( 068,180,{||"Qtd.Sacos"},_oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	_oGet6		:= TGet():New( 068,212,{|u| If(PCount()>0,_cGetsacos:=u,_cGetsacos)},_oGrp2,039,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cGetsacos",,)
	_oGet6:Disable()

	_oSay7		:= TSay():New( 098,020,{||"Peso liquido"},_oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	_oGet7		:= TGet():New( 098,060,{|u| If(PCount()>0,_cGetpliquido:=u,_cGetpliquido)},_oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cGetpliquido",,)
	_oGet7:Disable()

	_oSay8		:= TSay():New( 088,056,{||"___________________________________"},_oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)

	_oSay9		:= TSay():New( 098,180,{||"R$ Pedagio"},_oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	_oGet9:= TGet():New( 097,212,{|u| If(PCount()>0,_cGetvlrpedagio:=u,_cGetvlrpedagio)},_oGrp2,039,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cGetvlrpedagio",,)
	_oGet9:Disable()

	_oSay10		:= TSay():New( 098,272,{||"R$ Frete"},_oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,027,008)
	_oGet10		:= TGet():New( 097,303,{|u| If(PCount()>0,_cGetfrete:=u,_cGetfrete)},_oGrp2,039,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cGetfrete",,)
	_oGet10:Disable()

	
	_oGrp3      := TGroup():New( 116,012,168,356,"Dados da Nota",_oDlg3,CLR_HRED,CLR_WHITE,.T.,.F. )
	
	_oSay11		:= TSay():New( 128,116,{||"Serie"},_oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
	_oGet11		:= TGet():New( 128,136,{|u| If(PCount()>0,_cGetserie:=u,_cGetserie)},_oGrp3,025,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cGetserie",,)
	_oGet11:Disable()

	_oSay12		:= TSay():New( 128,172,{||"Prefixo"},_oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	_oGet12		:= TGet():New( 128,204,{|u| If(PCount()>0,_cGetprefixo:=u,_cGetprefixo)},_oGrp3,025,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cGetprefixo",,)
	_oGet12:Disable()

	_oSay13		:= TSay():New( 128,020,{||"Data de Saida"},_oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
	_oGet13		:= TGet():New( 128,060,{|u| If(PCount()>0,_cGetdtsaida:=u,_cGetdtsaida)},_oGrp3,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cGetdtsaida",,)
	_oGet13:Disable()

	_oSay14		:= TSay():New( 144,020,{||"Hora de Saida"},_oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,039,008)
	_oGet14:= TGet():New( 141,060,{|u| If(PCount()>0,_cGethrsaida:=u,_cGethrsaida)},_oGrp3,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cGethrsaida",,)
	_oGet14:Disable()

	_oSay15		:= TSay():New( 128,240,{||"Número"},_oGrp3,,_oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,032,008)
	_oGet15		:= TGet():New( 128,276,{|u| If(PCount()>0,_cGetnota:=u,_cGetnota)},_oGrp3,060,008,'',{||  val_nf(_cGetnota), _cGetnota:=_nf },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cGetnota",,)
	_oGet15:Disable()

	_oUsr      := TSay():New( 175,020,{||"Operador: "},_oGrp3,,_oFont14,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,032,008)
	_oUsr      := TSay():New( 175,080,{||  sz8->z8_usuario  },_oGrp3,,_oFont14,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)

	_oBtn1      := TButton():New( 176,246,"Cancelar",_oDlg3, {|| _lRet := .F. , _oDlg3:end() } ,050,012,,,,.T.,,"",,,,.F. )
	_oBtn1      := TButton():New( 176,302,"Confirma",_oDlg3, {|| _lRet := .T. , _oDlg3:end() } ,050,012,,,,.T.,,"",,,,.F. )

	_oDlg3:Activate(,,,.T.)

Return(_lRet)
