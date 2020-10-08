#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#Include 'TBICONN.ch'

#Define Verde "#9AFF9A"
#Define Amarelo "#FFFF00"
#Define Branco "#FFFAFA"
#Define Preto "#000000"
#Define Cinza "#696969"
#Define Mizu "#E8782F"

/*
Função		: PXH114
Data		: 22/01/2020
Descrição	: Gerar CT-e
*/

User Function PXH114()

	Local _oDlg			:= NIL
	Local _nOpc			:= 0

	If Alltrim(cEmpAnt)+Alltrim(cFilAnt) <> '1307701'
		ShowHelpDlg("PXH114_4", {'Rotina criada para ser utilizada somente na empresa "13", filial "07701".'},1,{'Não se aplica.'},1)
		Return(Nil)
	Endif

	Private _cProc		:= 'Processando'
	Private _cMsgTit	:= 'Aguarde, gerando dados...'
	Private _cCampo		:= ''

	Private _oFont11N	:= TFont():New('Arial'	,,-11,,.T.,,,,,.F.,.F.)

	Private _oProcess	:= Nil

	Public  _cUsrBRI37  := CUSERNAME

	AtuSX1()

	DEFINE MSDIALOG _oDlg FROM 264,182 TO 435,500 TITLE 'Geração de CT-e' OF _oDlg PIXEL

	_oGrupo	:= TGroup():New(005,005,045,155,"",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 010,010 SAY _oTSayA VAR "Esta rotina tem por objetivo gerar CT-e conforme "	OF _oGrupo PIXEL Size 150,010 FONT _oFont11N
	@ 020,010 SAY "os parâmetros informados pelo usuário."			OF _oGrupo PIXEL Size 150,010 FONT _oFont11N
	// @ 030,015 SAY "" 							OF _oGrupo PIXEL Size 150,010 FONT _oFont11N

	_oTBut1	:= TButton():New( 60,010, "Parâmetros" ,_oDlg,{||Pergunte("PXH114")},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )
	_cStyle := GetStyle(Amarelo,Branco,Cinza,Preto,1)
	_oTBut1:SetCss(_cStyle)

	_oTBut2	:= TButton():New( 60,068, "OK" ,_oDlg,{||_nOpc := 1,_oDlg:End()},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )
	_cStyle := GetStyle(Verde,Branco,Cinza,Preto,1)
	_oTBut2:SetCss(_cStyle)

	_oTBut3	:= TButton():New( 60,120, "Sair" ,_oDlg,{||_nOpc := 0,_oDlg:End()},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )
	_cStyle := GetStyle(Branco,Mizu,Cinza,Preto,1)
	_oTBut3:SetCss(_cStyle)

	ACTIVATE MSDIALOG _oDlg CENTERED

	If _nOpc = 1
		// LjMsgRun(_cMsgTit,_cProc,{||PXH114A()})
		_oProcess := MsNewProcess():New( { || PXH114A() } , "CT-e" , "Aguarde..." , .T. )
		_oProcess:Activate()
	Endif

Return(Nil)



Static Function GetStyle(_cCor1,_cCor2,_cCor3,_cCor4,_nTip)

	Local _cMod := ''
	Default _nTip := 1

	_cMod := "QPushButton { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+_cCor1+", stop: 1 "+_cCor2+");"
	_cMod += "border-style: outset;border-width: 2px;
		_cMod += "border-radius: 10px;border-color: "+_cCor3+";"
	_cMod += "color: "+_cCor4+"};"
	_cMod += "QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+_cCor2+", stop: 1 "+_cCor1+");"
	_cMod += "border-style: outset;border-width: 2px;"
	_cMod += "border-radius: 10px;"
	_cMod += "border-color: "+_cCor3+" }"

Return(_cMod)




Static Function PXH114A()

	Local aVetDoc	:= {}
	Local aVetVlr	:= {}
	Local aVetNFc	:= {}
	Local aItemDTC	:= {}
	Local aCabDTC	:= {}
	Local aItem		:= {}
	Local lCont		:= .T.
	Local aErrMsg	:= {}

	Local _cLote	:= ''
	Local _aCab		:= {}

	Local B, I, N, O, nI

	Local _cQuery	:= ''
	Local _nDados	:= -1

	Local cModalidade	:= ""
	Local cIdEnt		:= ""

	Local _cCNPJCLI		:= "07526355000168"

	Local _aStrSA1		:= SA1->(DbStruct())

	Private cVersaoCTE	:= ""
	Private lUsaColab	:= .F.

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

	Pergunte("PXH114",.F.)

	_dDtIni := MV_PAR01
	_dDtFim := MV_PAR02

	_cNfIni := MV_PAR03
	_cNfFim := MV_PAR04




	TCConType("TCPIP")

	_nDADOS  := TCLink("MSSQL/DADOS12","10.160.1.5")
	// _nDADOS  := TCLink("MSSQL/DADOS12","172.16.160.2")

	If _nDADOS < 0
		MsgStop("Não foi possível conectar no banco de dados da Britta para buscar as Notas Fiscais.")
		Return(Nil)
	Endif

	//Seta o Banco de Dados
	TCSETCONN(_nDADOS)

	GeraTRB()

	_lTRB := .F.
	_nTRB := 0

	_dDtBack := dDataBase


	_cQrySM0 := " SELECT * FROM CTESM0 " + CRLF
	_cQrySM0 += " WHERE M0_CODIGO IN ('04','05','13','50') " + CRLF
	_cQrySM0 += " AND M0_ESTCOB = 'SP' " + CRLF
	_cQrySM0 += " ORDER BY M0_CODIGO, M0_CODFIL " + CRLF

	TcQuery _cQrySM0 New Alias "TSM0"

	_nReg := Contar("TSM0","!EOF()")

	_oProcess:SetRegua1(_nReg) //Alimenta a primeira barra de progresso

	TSM0->(dbGoTop())

	While TSM0->(!EOF())

		_oProcess:IncRegua1("Processando a empresa "+Alltrim(TSM0->M0_NOMECOM)+".")

		_cCNPJRem := TSM0->M0_CGC
		_cSM0Cod  := Alltrim(TSM0->M0_CODIGO)
		_cSM0Fil  := Alltrim(TSM0->M0_CODFIL)

		dDataBase := _dDtBack

		If Select("TSF2") > 0
			TSF2->(dbCloseArea())
		Endif

		_cQuery := " SELECT A4_CGC,A4_NREDUZ,F2_FILIAL,F2_CLIENTE,F2_LOJA,F2_DOC,F2_SERIE,F2_VOLUME1,F2_PLIQUI,F2_VALBRUT,F2_PDLITTO,F2_EMISSAO,F2_HORA,D2_PDFRETT, " + CRLF
		_cQuery += " F2_PLACA,F2_PDLITQT,F2_PDLITUN,A1.* FROM SF2"+_cSM0Cod+"0 F2 (NOLOCK) " + CRLF
		_cQuery += " INNER JOIN SD2"+_cSM0Cod+"0 D2 (NOLOCK) ON F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_FILIAL = D2_FILIAL" + CRLF
		_cQuery += " INNER JOIN SA1500 A1 (NOLOCK) ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA " + CRLF
		_cQuery += " INNER JOIN SA4"+_cSM0Cod+"0 A4 (NOLOCK) ON F2_TRANSP = A4_COD AND F2_FILIAL = A4_FILIAL" + CRLF
		_cQuery += " WHERE F2.D_E_L_E_T_ = '' AND D2.D_E_L_E_T_ = '' AND A1.D_E_L_E_T_ = ''   AND A4.D_E_L_E_T_ = '' " + CRLF
		_cQuery += " AND F2_EMISSAO BETWEEN '"+DTOS(_dDtIni)+"' AND '"+DTOS(_dDtFim)+"' " + CRLF
		_cQuery += " AND F2_DOC		BETWEEN '"+_cNFINI+"'       AND '"+_cNFFIM+"' " + CRLF
		_cQuery += " AND A4_CGC = '"+_cCNPJCLI+"'  " + CRLF
		_cQuery += " ORDER BY F2_FILIAL,F2_SERIE,F2_DOC " + CRLF

		TcQuery _cQuery New Alias "TSF2"

		Count to _nTSF2

		If _nTSF2 = 0
			TSM0->(dbSkip())
			Loop
		Endif

		TcSetField("TSF2","F2_EMISSAO","D")

		_oProcess:SetRegua2(_nTSF2) //Alimenta a primeira barra de progresso

		TSF2->(dbGotop())

		While TSF2->(!EOF())

			_oProcess:IncRegua2('Processando a Nota Fiscal '+Alltrim(TSF2->F2_DOC)+'.')

			If Alltrim(TSF2->A1_COD_MUN) = Alltrim(Substr(TSM0->M0_CODMUN,3))
				TSF2->(dbSkip()) // DENTRO DO MUNICIPIO NAO PRECISA DE CTE
				Loop
			Endif

			// If TSF2->F2_FILIAL $ "01/02" .And. TSF2->A1_COD_MUN   = "47304"   // SANTANA DE PARNAIBA
			// 	TSF2->(dbSkip()) // DENTRO DO MUNICIPIO NAO PRECISA DE CTE
			// 	Loop
			// ElseIf TSF2->F2_FILIAL == "06" .And. TSF2->A1_COD_MUN = "18800" // GUARULHOS
			// 	TSF2->(dbSkip()) // DENTRO DO MUNICIPIO NAO PRECISA DE CTE
			// 	Loop
			// ElseIf TSF2->F2_FILIAL == "07" .And. TSF2->A1_COD_MUN = "05708" // BARUERI
			// 	TSF2->(dbSkip()) // DENTRO DO MUNICIPIO NAO PRECISA DE CTE
			// 	Loop
			// Endif

			//Grava o Cliente na tabela temporária TSA1
			If !TSA1->(MsSeek(TSF2->A1_CGC))
				TSA1->(RecLock("TSA1",.T.))
				_nCount := TSA1->(FCount())
				For B := 1 to _nCount
					_cCampo := TSA1->(Field(B))
					If TSF2->(FieldPos(_cCampo)) > 0
						_xVal := &("TSF2->"+_cCampo)
						_xSA1 := &("SA1->"+_cCampo)
						If ValType(_xSA1) = 'D'
							_xVal := stod(_xVal)
						Endif
						&("TSA1->"+_cCampo) :=_xVal
					Endif
				Next B
				TSA1->(MsUnLock())
			Endif

			_cCNPJ   := TSF2->A4_CGC
			_cCNPJDe := TSF2->A1_CGC
			_cCliDes := TSF2->F2_CLIENTE
			_cLojDes := TSF2->F2_LOJA
			_cDoc	 := TSF2->F2_DOC
			_cSerie  := TSF2->F2_SERIE
			_nVolume := 1
			_nPeso   := TSF2->F2_PLIQUI
			_nValor  := TSF2->F2_VALBRUT
			_nVlFret := TSF2->F2_PDLITTO * -1
			_nValBru := TSF2->F2_VALBRUT
			_dEmissa := TSF2->F2_EMISSAO
			_cHora   := TSF2->F2_HORA
			_cNomTr  := TSF2->A4_NREDUZ

			_cPLACA  := TSF2->F2_PLACA
			_nQTLIT  := TSF2->F2_PDLITQT
			_nVLUNIT := TSF2->F2_PDLITUN
			_nVLTOT  := TSF2->F2_PDLITTO
			_nFREBRU := TSF2->D2_PDFRETT

			_cKey 	 := TSF2->F2_FILIAL+TSF2->F2_SERIE+TSF2->F2_DOC

			While TSF2->(!EOF()) .And. _cKey = TSF2->F2_FILIAL+TSF2->F2_SERIE+TSF2->F2_DOC

				_nVlFret += TSF2->D2_PDFRETT

				TSF2->(dbSkip())
			EndDo

			If _nVlFret > 0

				TRB->(RecLock("TRB",.T.))
				TRB->CNPJTR := _cCNPJ
				TRB->CNPJRE := _cCNPJRem
				TRB->CNPJDE := _cCNPJDe
				TRB->CLIDES := _cCliDes
				TRB->LOJDES := _cLojDes
				TRB->DOC	:= _cDoc
				TRB->SERIE	:= _cSerie
				TRB->VOLUME := _nVolume
				TRB->PLIQUI := _nPeso
				TRB->VALBRUT:= _nValor
				TRB->VALFRET:= _nVlFret
				TRB->VALOR	:= _nValBru
				TRB->EMISSAO:= _dEmissa
				TRB->HORA	:= _cHora
				TRB->NOMETR	:= _cNomTr

				TRB->PLACA  := _cPLACA
				TRB->QTLITRO:= _nQTLIT
				TRB->VLUNI	:= _nVLUNIT
				TRB->VLTOT	:= _nVLTOT
				TRB->VLFRET	:= _nFREBRU
				TRB->(MsUnLock())

				_lTRB := .T.
				_nTRB ++

			Endif
		EndDo

		TSF2->(dbCloseArea())

		//Grava o Cliente de remessa na tabela temporária TSA1
		If !TSA1->(MsSeek( Alltrim(_cCNPJRem)))

			If Select("TSA1A")
				TSA1A->(dbCloseArea())
			Endif

			_cQry := " SELECT * FROM SA1010 A1 (NOLOCK) WHERE A1.D_E_L_E_T_ = '' AND A1_CGC = '"+Alltrim(_cCNPJRem)+"' "

			TcQuery _cQry New Alias "TSA1A"

			For nI := 1 TO LEN(_aStrSA1)
				If _aStrSA1[nI][2] != "C"
					TCSetField("TSA1A", _aStrSA1[nI][1], _aStrSA1[nI][2], _aStrSA1[nI][3], _aStrSA1[nI][4])
				EndIf
			Next

			Count to _nTSA1A

			If _nTSA1A > 0

				TSA1A->(dbGoTop())

				TSA1->(RecLock("TSA1",.T.))
				_nCount := TSA1->(FCount())
				For i := 1 to _nCount
					_cCampo := Alltrim(TSA1->(Field(i)))
					If TSA1A->(FieldPos(_cCampo)) > 0

						_xVal := &("TSA1A->"+_cCampo)
						// _xSA1 := &("SA1->"+_cCampo)
						// If ValType(_xSA1) = 'D'
						// _xVal := stod(_xVal)
						// Endif
						&("TSA1->"+_cCampo) :=_xVal

					Endif
				Next i

				TSA1->(MsUnLock())

				TSA1A->(dbCloseArea())
			Endif
		Endif

		TSM0->(dbSkip())
	EndDo

	_oProcess:IncRegua1()

	TSM0->(dbCloseArea())

	TCUNLINK(_nDADOS)


	If _lTRB

		TRB->(dbGoTop())

		_oProcess:IncRegua1("Processando registros da tabela Temporária...")
		_oProcess:SetRegua2( _nTRB ) //Alimenta a segunda barra de progresso

		While TRB->(!EOF())

			_cCnpj  := TRB->CNPJTR
			_cNomTr := TRB->NOMETR

			aVetDoc := {}
			aVetVlr := {}
			aVetNFc := {}

			While TRB->(!EOF()) .And. _cCnpj = TRB->CNPJTR

				_oProcess:IncRegua2("Processando a Transportadora "+Alltrim(_cNomTr))//+' - CNPJ: '+Alltrim(_cCNPJ))

				//Verifica se o Cliente Destino está cadastrado
				SA1->(dbSetOrder(3))
				If !SA1->(MsSeek(xFilial("SA1")+TRB->CNPJDE))
					// If !SA1->(MsSeek(xFilial("SA1")+TRB->CLIDES+TRB->LOJDES))

					If TSA1->(MsSeek(TRB->CNPJDE))

						SA1->(RecLock("SA1",.T.))
						_nCount := SA1->(FCount())
						For N := 1 to _nCount
							_cCampo := SA1->(Field(N))
							&("SA1->"+_cCampo) := &("TSA1->"+_cCampo)
						Next N
						SA1->A1_CDRDES := TSA1->A1_EST
						SA1->(MsUnLock())
					Endif
				Endif

				_cCliDes := SA1->A1_COD
				_cLojDes := SA1->A1_LOJA
				_cRegDes := SA1->A1_CDRDES

				//Verifica se o Cliente Remessa está cadastrado
				SA1->(dbSetOrder(3))
				If !SA1->(MsSeek(xFilial("SA1")+TRB->CNPJRE))

					If TSA1->(MsSeek(TRB->CNPJRE))

						_aCod := U_RETCODLOJA(TSA1->A1_PESSOA,TSA1->A1_CGC,"SA1",.T.)

						SA1->(RecLock("SA1",.T.))
						_nCount := SA1->(FCount())
						For O := 1 to _nCount
							_cCampo := Alltrim(SA1->(Field(O)))
							If _cCampo = 'A1_FILIAL'
								SA1->A1_FILIAL := xFilial("SA1")
							Elseif _cCampo = 'A1_COD'
								SA1->A1_COD := _aCod[1]
							ElseIf _cCampo = 'A1_LOJA'
								SA1->A1_LOJA := _aCod[2]
							Else
								If SA1->(FieldPos(_cCampo)) > 0
									&("SA1->"+_cCampo) := &("TSA1->"+_cCampo)
								Endif
							Endif
						Next O
						SA1->A1_CDRDES := TSA1->A1_EST
						SA1->(MsUnLock())
					ELSE
						ShowHelpDlg("PXH114_1", {'Cliente Remessa não cadastrado.'},1,{'Cadastre o Cliente ('+TRB->CNPJRE+').'},1)
						TRB->(dbSkip())
						Loop
					endif
				Endif

				_cCliRem := SA1->A1_COD
				_cLojRem := SA1->A1_LOJA
				_cRegRem := SA1->A1_CDRDES
				_cProdCte:= ''
				_cCTe	 := ''
				_cSerCTe := ''

				DTC->(dbSetOrder(2))
				If DTC->(MsSeek(xFilial("DTC")+TRB->DOC+TRB->SERIE+_cCliRem+_cLojRem ))
					TRB->(dbSkip())
					Loop
				Endif

				DUI->(dbSetOrder(1))
				If DUI->(MsSeek(xFilial("DUI")+"2"))

					SX5->(dbSetOrder(1))
					If SX5->(MsSeek(xFilial("SX5")+"01"+DUI->DUI_SERIE))
						_cCTe := PadL(Alltrim(SX5->X5_DESCRI),9,"0")
						_cSerCTe := DUI->DUI_SERIE
					Else
						ShowHelpDlg("PXH114_2", {'Não encontrado a série '+DUI->DUI_SERIE+' cadastrada.'},1,{'Solicite o cadastro pelo Administrador do sistema na tabela SX5.'},1)
						Return(Nil)
					EndIF

					_cProdCte := DUI->DUI_CODPRO
				Else
					ShowHelpDlg("PXH114_3", {'Não encontrado o cadastro de Configuração de Documentos.'},1,{'Realize o cadastro de Configuração de Documentos.'},1)
					Return(Nil)
				Endif

				_aCab := {}

				Aadd(_aCab,{'DTP_QTDLOT',1,NIL})
				Aadd(_aCab,{'DTP_QTDDIG',0,NIL})
				Aadd(_aCab,{'DTP_TIPLOT','3',NIL})//--1 Normal, 2- Refaturamento, 3- Eletronico
				Aadd(_aCab,{'DTP_STATUS','1',NIL})//--1 -Aberto, 2- Digitado, 3- Calculado, 4- Bloqueado, 5- Erro de Gravação

				lMsErroAuto := .F. //Como variável já foi declarada acima, aqui ela foi foi declarada novamente. Caso contrario deve ser declarada com private

				MSExecAuto({|x,y| _cLote := TMSA170(x,y)},_aCab,3)

				If lMsErroAuto
					MostraErro()
					_cLote := Space(TamSX3('DTP_LOTNFC')[1])
					lCont := .F.
				EndIf

				If lCont

					lMsErroAuto := .F.
					aCabDTC := {}

					aCabDTC := {;
						{"DTC_FILORI" 	,"07701" 			, Nil},;
						{"DTC_LOTNFC" 	,_cLote 		, Nil},;
						{"DTC_CLIREM" 	,_cCliRem		, Nil},;
						{"DTC_LOJREM" 	,_cLojRem		, Nil},;
						{"DTC_DATENT" 	,TRB->EMISSAO 	, Nil},;
						{"DTC_CLIDES"	,_cCliDes		, Nil},;
						{"DTC_LOJDES" 	,_cLojDes		, Nil},;
						{"DTC_CLIDEV" 	,_cCliDes		, Nil},; //{"DTC_CLIDEV" 	,_cCliRem	, Nil},;
						{"DTC_LOJDEV" 	,_cLojDes		, Nil},; //{"DTC_LOJDEV" 	,_cLojRem	, Nil},;
						{"DTC_CLICAL" 	,_cCliDes		, Nil},; //{"DTC_CLICAL" 	,_cCliRem	, Nil},;
						{"DTC_LOJCAL" 	,_cLojDes		, Nil},; //{"DTC_LOJCAL" 	,_cLojRem	, Nil},;
						{"DTC_DEVFRE" 	,"2" 			, Nil},; //{"DTC_DEVFRE" 	,"1" 		, Nil},;
						{"DTC_SERTMS" 	,"3" 			, Nil},; //{"DTC_SERTMS" 	,"3" 		, Nil},;
						{"DTC_TIPTRA" 	,"1" 			, Nil},;
						{"DTC_SERVIC" 	,"SNE" 			, Nil},;
						{"DTC_TIPNFC" 	,"0" 			, Nil},;
						{"DTC_TIPFRE" 	,"2" 			, Nil},; //{"DTC_TIPFRE" 	,"1" 		, Nil},;
						{"DTC_CODNEG" 	,"01" 			, Nil},;
						{"DTC_SELORI" 	,"1" 			, Nil},;
						{"DTC_CDRORI" 	,_cRegRem		, Nil},;
						{"DTC_CDRDES" 	,_cRegDes		, Nil},;
						{"DTC_CDRCAL" 	,_cRegDes		, Nil},;
						{"DTC_DISTIV" 	,'2'			, Nil},;
						{"DTC_YPLACA" 	, TRB->PLACA   	, Nil},;
						{"DTC_YQTLIT" 	, TRB->QTLITRO 	, Nil},;
						{"DTC_YVLUNI" 	, TRB->VLUNI   	, Nil},;
						{"DTC_YVLTOT" 	, TRB->VLTOT   	, Nil},;
						{"DTC_YFRCHE" 	, TRB->VLFRET  	, Nil}}

					aItemDTC := {}

					aItem := {;
						{"DTC_NUMNFC" ,TRB->DOC 	 , Nil},;
						{"DTC_SERNFC" ,TRB->SERIE 	 , Nil},;
						{"DTC_CODPRO" ,_cProdCte	 , Nil},;
						{"DTC_CODEMB" ,"GR" 		 , Nil},;
						{"DTC_EMINFC" ,TRB->EMISSAO  , Nil},;
						{"DTC_QTDVOL" ,TRB->VOLUME 	 , Nil},;
						{"DTC_PESO"   ,TRB->PLIQUI	 , Nil},;
						{"DTC_PESOM3" ,0.0000		 , Nil},;
						{"DTC_VALOR"  ,TRB->VALOR	 , Nil},;
						{"DTC_BASSEG" ,0.00 		 , Nil},;
						{"DTC_METRO3" ,0.0000		 , Nil},;
						{"DTC_QTDUNI" ,0 			 , Nil},;
						{"DTC_EDI" 	  ,"2" 			 , Nil},;
						{"DTC_CF" 	  ,'5932'		 , Nil}}


					AAdd(aItemDTC,aClone(aItem))

					// Parametros da TMSA050 (notas fiscais do cliente)
					// xAutoCab - Cabecalho da nota fiscal
					// xAutoItens - Itens da nota fiscal
					// xItensPesM3 - acols de Peso Cubado
					// xItensEnder - acols de Enderecamento
					// nOpcAuto - Opcao rotina automatica
					MSExecAuto({|u,v,x,y,z,w| TMSA050(u,v,x,y,z)},aCabDTC,aItemDTC,,,3)

					If lMsErroAuto
						MostraErro()
						lCont := .F.
					Else
						DTC->(dbCommit())
					EndIf

				EndIf

				If lCont

					aVetDoc := {}
					aVetVlr := {}
					aVetNFc := {}

					AAdd(aVetDoc, {"DT6_FILORI"	, xFilial("DT6")})
					AAdd(aVetDoc, {"DT6_LOTNFC"	, _cLote		})
					AAdd(aVetDoc, {"DT6_FILDOC"	, "07701"		})
					AAdd(aVetDoc, {"DT6_DOC" 	, _cCTe			})
					AAdd(aVetDoc, {"DT6_SERIE" 	, _cSerCTe		})
					AAdd(aVetDoc, {"DT6_DATEMI"	, dDataBase		}) 		//AAdd(aVetDoc,{"DT6_DATEMI",TRB->EMISSAO})
					AAdd(aVetDoc, {"DT6_HOREMI"	, StrTran(Left(Time(),5),":","")}) //AAdd(aVetDoc,{"DT6_HOREMI",TRB->HORA})
					AAdd(aVetDoc, {"DT6_VOLORI"	, 1				})
					AAdd(aVetDoc, {"DT6_QTDVOL"	, TRB->VOLUME	})
					AAdd(aVetDoc, {"DT6_PESO" 	, TRB->PLIQUI	})
					AAdd(aVetDoc, {"DT6_PESOM3"	, 0.0000		})
					AAdd(aVetDoc, {"DT6_PESCOB"	, TRB->PLIQUI	})
					AAdd(aVetDoc, {"DT6_METRO3"	, 0.0000		})
					AAdd(aVetDoc, {"DT6_VALMER"	, TRB->VALOR	})
					AAdd(aVetDoc, {"DT6_QTDUNI"	, 0				})
					AAdd(aVetDoc, {"DT6_VALFRE"	, TRB->VALFRET	})
					AAdd(aVetDoc, {"DT6_VALIMP"	, 0				})
					AAdd(aVetDoc, {"DT6_VALTOT"	, TRB->VALFRET	})
					AAdd(aVetDoc, {"DT6_BASSEG"	, 0.00			})
					AAdd(aVetDoc, {"DT6_SERTMS"	, "3"			})
					AAdd(aVetDoc, {"DT6_TIPTRA"	, "1"			})
					AAdd(aVetDoc, {"DT6_DOCTMS"	, "2"			})
					AAdd(aVetDoc, {"DT6_CDRORI"	, _cRegRem		})
					AAdd(aVetDoc, {"DT6_CDRDES"	, _cRegDes		})
					AAdd(aVetDoc, {"DT6_CDRCAL"	, _cRegDes		})
					AAdd(aVetDoc, {"DT6_TABFRE"	, "0001"		})
					AAdd(aVetDoc, {"DT6_TIPTAB"	, "01"			})
					AAdd(aVetDoc, {"DT6_SEQTAB"	, "00"			})
					AAdd(aVetDoc, {"DT6_TIPFRE"	, "2"			}) 		//AAdd(aVetDoc,{"DT6_TIPFRE","1"			})
					AAdd(aVetDoc, {"DT6_FILDES"	, "07701"		})
					AAdd(aVetDoc, {"DT6_BLQDOC"	, "2"			})
					AAdd(aVetDoc, {"DT6_PRIPER"	, "2"			})
					AAdd(aVetDoc, {"DT6_PERDCO"	, 0.00000		})
					AAdd(aVetDoc, {"DT6_FILDCO"	, ""			})
					AAdd(aVetDoc, {"DT6_DOCDCO"	, ""			})
					AAdd(aVetDoc, {"DT6_SERDCO"	, ""			})
					AAdd(aVetDoc, {"DT6_CLIREM"	, _cCliRem		})
					AAdd(aVetDoc, {"DT6_LOJREM"	, _cLojRem		})
					AAdd(aVetDoc, {"DT6_CLIDES"	, _cCliDes		})
					AAdd(aVetDoc, {"DT6_LOJDES"	, _cLojDes		})
					//AAdd(aVetDoc,{"DT6_CLIDEV"	,_cCliRem})
					//AAdd(aVetDoc,{"DT6_LOJDEV"	,_cLojRem})
					//AAdd(aVetDoc,{"DT6_CLICAL"	,_cCliRem})//--
					//AAdd(aVetDoc,{"DT6_LOJCAL"	,_cLojRem})//--
					//AAdd(aVetDoc,{"DT6_DEVFRE"	,"1"})//--
					AAdd(aVetDoc, {"DT6_CLIDEV"	, _cCliDes		})
					AAdd(aVetDoc, {"DT6_LOJDEV"	, _cLojDes		})
					AAdd(aVetDoc, {"DT6_CLICAL"	, _cCliDes		})		//ALTERADO POR ALISON - 04/02/20
					AAdd(aVetDoc, {"DT6_LOJCAL"	, _cLojDes		})		//ALTERADO POR ALISON - 04/02/20
					AAdd(aVetDoc, {"DT6_DEVFRE"	, "2"			})		//ALTERADO POR ALISON - 04/02/20
					AAdd(aVetDoc, {"DT6_FATURA"	, ""			})
					AAdd(aVetDoc, {"DT6_SERVIC"	, "SNE"			})
					AAdd(aVetDoc, {"DT6_CODMSG"	, ""			})
					AAdd(aVetDoc, {"DT6_STATUS"	, "1"			})
					AAdd(aVetDoc, {"DT6_DATEDI"	, CToD(" / / ")	})
					AAdd(aVetDoc, {"DT6_NUMSOL"	, ""			})
					AAdd(aVetDoc, {"DT6_VENCTO"	, CToD(" / / ")	})
					AAdd(aVetDoc, {"DT6_FILDEB"	, "07701"		})
					AAdd(aVetDoc, {"DT6_PREFIX"	, ""			})
					AAdd(aVetDoc, {"DT6_NUM" 	, ""			})
					AAdd(aVetDoc, {"DT6_TIPO" 	, ""			})
					AAdd(aVetDoc, {"DT6_MOEDA" 	,  1			})
					AAdd(aVetDoc, {"DT6_BAIXA" 	, CToD(" / / ")	})
					AAdd(aVetDoc, {"DT6_FILNEG"	, "07701"		})
					AAdd(aVetDoc, {"DT6_ALIANC"	, ""			})
					AAdd(aVetDoc, {"DT6_REENTR"	,  0			})
					AAdd(aVetDoc, {"DT6_TIPMAN"	, ""			})
					AAdd(aVetDoc, {"DT6_PRZENT"	, TRB->EMISSAO	})
					AAdd(aVetDoc, {"DT6_YSORIG"	, TRB->SERIE	})
					AAdd(aVetDoc, {"DT6_FIMP" 	, "0"			})
					//AAdd(aVetDoc,{"DT6_YSORIG", TRB->SERIE		})

					AAdd(aVetVlr,{{"DT8_CODPAS","07"	},;
						{"DT8_VALPAS"	, TRB->VALFRET	},;
						{"DT8_VALIMP"	, 0				},;
						{"DT8_VALTOT"	, TRB->VALFRET	},;
						{"DT8_FILORI"	, ""			},;
						{"DT8_TABFRE"	, "0001"		},;
						{"DT8_TIPTAB"	, "01"			},;
						{"DT8_FILDOC"	, "07701"		},;
						{"DT8_CODPRO"	, "CALC.FRETE"	},;
						{"DT8_DOC" 		, _cLote		},;
						{"DT8_SERIE" 	, "PED"			},;
						{"VLR_ICMSOL"	, 0				}})

					AAdd(aVetVlr,{{"DT8_CODPAS","TF"	},;
						{"DT8_VALPAS"	, TRB->VALFRET	},;
						{"DT8_VALIMP"	, 0				},;
						{"DT8_VALTOT"	, TRB->VALFRET	},;
						{"DT8_FILORI"	, ""			},;
						{"DT8_TABFRE"	, ""			},;
						{"DT8_TIPTAB"	, ""			},;
						{"DT8_FILDOC"	, "07701"		},;
						{"DT8_CODPRO"	, _cProdCte		},;
						{"DT8_DOC" 		, _cLote		},;
						{"DT8_SERIE" 	, "PED"			},;
						{"VLR_ICMSOL"	, 0				}})

					AAdd(aVetNFc,{{"DTC_CLIREM",_cCliRem},;
						{"DTC_LOJREM"	, _cLojRem		},;
						{"DTC_NUMNFC"	, TRB->DOC		},;
						{"DTC_SERNFC"	, TRB->SERIE	},;
						{"DTC_CODPRO"	, _cProdCte		},;
						{"DTC_QTDVOL"	, TRB->VOLUME	},;
						{"DTC_PESO" 	, TRB->PLIQUI	},;
						{"DTC_PESOM3"	, 0.0000		},;
						{"DTC_METRO3"	, 0.0000		},;
						{"DTC_VALOR" 	, TRB->VALOR	}})

					Pergunte("TMB200",.F.)

					MV_PAR10 := 2

					aErrMsg := TMSImpDoc(aVetDoc,aVetVlr,aVetNFc,_cLote,.F.,0,1,.T.,.T.,.T.,.T.)

					If Empty(aErrMsg)
						SX5->(dbSetOrder(1))
						If SX5->(MsSeek(xFilial("SX5")+"01"+_cSerCTe))

							_cNewCTe := StrZero(val(_cCTe)+1,9)

							SX5->(Reclock("SX5",.F.))
							SX5->X5_DESCRI := _cNewCTe
							SX5->(MsUnlock())
							SX5->(dbCommit())
						Endif

						//Transmissão CT-e
						// _lRet := TMSA200Tra(.F.,cFilAnt,_cLote,,,,,"TMSA200")
						// _lRet := TMSA200Tra(lLotExpress,cFilAnt,cLotNfc,nTotDoc,nTotnTran,aMsgErr,aVisErr,"TMSA200")

					Endif
				EndIf

				TRB->(dbSkip())
			ENDDO

			Pergunte("TM200C",.F.)

			mv_par01  := ''
			mv_par02  := 'zzzzzz'
			mv_par03  := 3
			mv_par04  := '2'
			mv_par05  := dDataBase
			mv_par06  := dDataBase

			cModalidade	:= ""
			cIdEnt		:= ""
			cVersaoCTE	:= ""
			lUsaColab	:= .F.

			_lRet := TMSSpedNFe(@cIdEnt,@cModalidade,@cVersaoCTE,lUsaColab)

			//Monitor Cte.
			//U_TMSAE70AST(1,"01",,,,,,.T.)
			TMSAE70(1,cFilAnt,,,,,,.T.) //ALTERADO POR ALEXANDRO EM 30/01/20
		ENDDO

		TRB->(dbCloseArea())

		TSA1->(dbCloseArea())

	ENDIF

Return(Nil)



Static Function AtuSX1()

	_cPerg := "PXH114"
	_aRegs := {}

	//    	   Grupo/Ordem/Pergunta         /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01         /defspa1/defeng1/Cnt01/Var02/Def02  /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3   /cPyme/cGrpSxg/cHelp)
	U_CRIASX1(_cPerg,"01","Data NF De     ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR01",""            ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""     ,)
	U_CRIASX1(_cPerg,"02","Data NF Ate    ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02",""            ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""     ,)
	U_CRIASX1(_cPerg,"03","NF Venda De    ?",""       ,""      ,"mv_ch3","C" ,09     ,0      ,0     ,"G",""        ,"MV_PAR03",""            ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""     ,)
	U_CRIASX1(_cPerg,"04","NF Venda Ate   ?",""       ,""      ,"mv_ch4","C" ,09     ,0      ,0     ,"G",""        ,"MV_PAR04",""            ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""     ,)
	// U_CRIASX1(_cPerg,"03","Transp De      ?",""       ,""      ,"mv_ch3","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR03",""            ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""     ,)
	// U_CRIASX1(_cPerg,"04","TRansp Ate     ?",""       ,""      ,"mv_ch4","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR04",""            ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""     ,)


Return(Nil)



Static Function GeraTRB()

	Local _aStru	:= {}
	Local _cArqTrb	:= Nil
	Local _cIndTrb	:= "CNPJTR+DOC+SERIE"

	AADD(_aStru,{"CNPJTR"	, "C" , TAMSX3("A4_CGC")[1]    , 0 })
	AADD(_aStru,{"CNPJRE"	, "C" , TAMSX3("A4_CGC")[1]    , 0 })
	AADD(_aStru,{"CNPJDE"	, "C" , TAMSX3("A4_CGC")[1]    , 0 })
	AADD(_aStru,{"CLIDES"	, "C" , TAMSX3("F2_CLIENTE")[1], 0 })
	AADD(_aStru,{"LOJDES"	, "C" , TAMSX3("F2_LOJA")[1]   , 0 })
	AADD(_aStru,{"DOC"		, "C" , TAMSX3("F2_DOC")[1]    , 0 })
	AADD(_aStru,{"SERIE"	, "C" , TAMSX3("F2_SERIE")[1]  , 0 })
	AADD(_aStru,{"EMISSAO"	, "D" , TAMSX3("F2_EMISSAO")[1], 0 })
	AADD(_aStru,{"HORA"		, "C" , TAMSX3("F2_HORA")[1]   , 0 })
	AADD(_aStru,{"VOLUME"	, "N" , TAMSX3("F2_VOLUME1")[1], 0 })
	AADD(_aStru,{"PLIQUI"	, "N" , TAMSX3("F2_PLIQUI")[1] , TAMSX3("F2_PLIQUI")[2] } )
	AADD(_aStru,{"VALBRUT"	, "N" , TAMSX3("F2_VALBRUT")[1], TAMSX3("F2_VALBRUT")[2] })
	AADD(_aStru,{"VALFRET"	, "N" , TAMSX3("DT6_VALFRE")[1], TAMSX3("DT6_VALFRE")[2] })
	AADD(_aStru,{"VALOR"	, "N" , TAMSX3("F2_VALBRUT")[1], TAMSX3("F2_VALBRUT")[2] })
	AADD(_aStru,{"NOMETR"	, "C" , TAMSX3("A4_NREDUZ")[1] , 0 })
	AADD(_aStru,{"PLACA"	, "C" , 7	                   , 0 })
	AADD(_aStru,{"QTLITRO"	, "N" , TAMSX3("F2_PLIQUI")[1] , TAMSX3("F2_PLIQUI")[2] } )
	AADD(_aStru,{"VLUNI"	, "N" , TAMSX3("F2_PLIQUI")[1] , TAMSX3("F2_PLIQUI")[2] } )
	AADD(_aStru,{"VLTOT"	, "N" , TAMSX3("F2_PLIQUI")[1] , TAMSX3("F2_PLIQUI")[2] } )
	AADD(_aStru,{"VLFRET"	, "N" , TAMSX3("F2_PLIQUI")[1] , TAMSX3("F2_PLIQUI")[2] } )

	_cArqTrb	:= CriaTrab(_aStru,.T.)

	dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

	dbSelectArea("TRB")
	IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

	_aStru	:= {}
	_cArqTrb	:= Nil

	SX3->(dbSetOrder(1))
	If SX3->(MsSeek("SA1"))

		While SX3->(!EOF()) .And. SX3->X3_ARQUIVO = 'SA1'

			If X3USO(SX3->X3_USADO)
				AADD(_aStru,{Alltrim(SX3->X3_CAMPO)	, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL })
			Endif

			SX3->(dbSkip())
		EndDo

	Endif

	_cArqTrb	:= CriaTrab(_aStru,.T.)
	_cIndTrb	:= "A1_CGC"

	dbUseArea(.T.,,_cArqTrb,"TSA1",.F.,.F.)

	dbSelectArea("TSA1")
	IndRegua("TSA1",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

Return(Nil)
