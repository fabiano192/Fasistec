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
Função		: BRI137
Data		: 22/01/2020
Descrição	: Gerar CT-e
*/

User Function BRI137()

	Local _oDlg			:= NIL
	Local _nOpc			:= 0

	Private _cProc		:= 'Processando'
	Private _cMsgTit	:= 'Aguarde, gerando dados...'
	Private _cCampo		:= ''

	Private _oFont11N	:= TFont():New('Arial'	,,-11,,.T.,,,,,.F.,.F.)

	Private _oProcess	:= Nil

	AtuSX1()

	DEFINE MSDIALOG _oDlg FROM 264,182 TO 435,500 TITLE 'Geração de CT-e' OF _oDlg PIXEL

	_oGrupo	:= TGroup():New(005,005,045,155,"",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 010,010 SAY _oTSayA VAR "Esta rotina tem por objetivo gerar CT-e conforme "	OF _oGrupo PIXEL Size 150,010 FONT _oFont11N
	@ 020,010 SAY "os parâmetros informados pelo usuário."			OF _oGrupo PIXEL Size 150,010 FONT _oFont11N
	// @ 030,015 SAY "" 							OF _oGrupo PIXEL Size 150,010 FONT _oFont11N

	_oTBut1	:= TButton():New( 60,010, "Parâmetros" ,_oDlg,{||Pergunte("BRI137")},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )
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
		// LjMsgRun(_cMsgTit,_cProc,{||BRI137A()})
		_oProcess := MsNewProcess():New( { || BRI137A() } , "CT-e" , "Aguarde..." , .T. )
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




Static Function BRI137A()

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

	Local F, B, I, N, O

	Local _cQuery	:= ''
	Local _nDados	:= -1

	Local cModalidade	:= ""
	Local cIdEnt		:= ""

	Local _nSM0		:= 0
	Local _aSM0		:= {}
	Local _aEmp		:= {{"500129067113009495","CTEMBA"},{"500229067113009495","CTEMRO"},{"500629067113033280","CTEIGU"},{"500729067113027809","CTEICC"}}
	// Local _aEmp		:= {"500129067113009495","500229067113009495","500629067113033280","500729067113027809"}
	Local _n		:= 0

	Private cVersaoCTE	:= ""
	Private lUsaColab	:= .F.

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

// Verifica se o usuário tem acesso à rotina, conforme cada emnpresa.
	For _n := 1 to Len(_aEmp)
		AAdd(_aEmp[_n],u_ChkAcesso(_aEmp[_n][2],6,.F.) )
	Next _n

	Pergunte("BRI137",.F.)

	_dDtIni := MV_PAR01
	_dDtFim := MV_PAR02

	_AreaSM0:= SM0->(GetArea())

	SM0->(dbGoTop())

	While SM0->(!Eof())

		AAdd(_aSM0,{Alltrim(SM0->M0_CGC),SM0->M0_CODIGO,SM0->M0_CODFIL,Alltrim(SM0->M0_NOME)})

		SM0->(dbSkip())
	EndDo

	RestArea(_AreaSM0)


	For _nSM0 := 1 to Len(_aSM0)

		_oProcess:SetRegua1(2) //Alimenta a primeira barra de progresso
		_oProcess:IncRegua1("Processando a empresa "+_aSM0[_nSM0][4])

		_oProcess:SetRegua2(Len(_aEmp)) //Alimenta a primeira barra de progresso

		_cSM0Cnpj := _aSM0[_nSM0][1]
		_cSM0Cod  := _aSM0[_nSM0][2]
		_cSM0Fil  := _aSM0[_nSM0][3]

		//If !(_cSM0Cnpj $ '17674000000170')
		If !(_cSM0Cnpj $ '28311497000188')
			Loop
		Endif

		RpcClearEnv()

		OpenSM0()

		RpcSetType(3)
		RpcSetEnv(_cSM0Cod, _cSM0Fil,'cte','cte2020','TMS' ,,  {"DTC","DTP","DT6","DT8","SD1","SD2","SD3","SF2","SA1"})

		TCConType("TCPIP")

		_nDADOS  := TCLink("MSSQL/DADOS12","172.16.160.2")

		If _nDADOS < 0
			MsgStop("Não foi possível conectar no banco de dados do Protheus para buscar as Notas Fiscais.")
			Return(Nil)
		Endif

		//Seta o Banco de Dados
		TCSETCONN(_nDADOS)

		GeraTRB()

		_lTRB := .F.
		_nTRB := 0
		For F := 1 to Len(_aEmp)

			If _aEmp[F][3] // Verifica se o usuário tem acesso à rotina, conforme cada emnpresa.
			// If u_ChkAcesso(_aEmp[F][2],6,.F.) // Verifica se o usuário tem acesso à rotina, conforme cada emnpresa.

				_oProcess:IncRegua2('Processando a empresa '+Left(_aEmp[F][1],4)+'.')

				_cEmp    := Left(_aEmp[F][1],2)
				_cFilEmp := Substr(_aEmp[F][1],3,2)
				_cCNPJRem:= Right(_aEmp[F][1],14)

				If Select("TSF2") > 0
					TSF2->(dbCloseArea())
				Endif

				_cQuery := " SELECT A1.*,A4_CGC,A4_NREDUZ,F2_FILIAL,F2_CLIENTE,F2_LOJA,F2_DOC,F2_SERIE,F2_VOLUME1,F2_PLIQUI,F2_VALBRUT,F2_PDLITTO,F2_EMISSAO,F2_HORA,D2_PDFRETT, " + CRLF
				_cQuery += " F2_PLACA,F2_PDLITQT,F2_PDLITUN FROM SF2"+_cEmp+"0 F2 " + CRLF
				_cQuery += " INNER JOIN SD2"+_cEmp+"0 D2 ON F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_FILIAL = D2_FILIAL" + CRLF
				_cQuery += " INNER JOIN SA1500 A1 ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA " + CRLF
				_cQuery += " INNER JOIN SA4"+_cEmp+"0 A4 ON F2_TRANSP = A4_COD AND F2_FILIAL = A4_FILIAL" + CRLF
				_cQuery += " WHERE F2.D_E_L_E_T_ = '' AND D2.D_E_L_E_T_ = '' AND A1.D_E_L_E_T_ = ''   AND A4.D_E_L_E_T_ = '' " + CRLF
				_cQuery += " AND F2_FILIAL = '"+_cFilEmp+"' "// AND D2_FILIAL = '"+_cFilEmp+"' AND A4_FILIAL = '"+_cFilEmp+"' " + CRLF
				_cQuery += " AND F2_EMISSAO BETWEEN '"+DTOS(_dDtIni)+"' AND '"+DTOS(_dDtFim)+"' " + CRLF
				_cQuery += " AND A1_GRPVEN = '000001' " + CRLF
				_cQuery += " AND A4_CGC <> '' " + CRLF
				_cQuery += " AND A4_CGC = '"+_cSM0Cnpj+"'  " + CRLF
				// _cQuery += " AND A4_CGC = '15409884000100' " + CRLF
				_cQuery += " ORDER BY F2_FILIAL,F2_SERIE,F2_DOC " + CRLF

				TcQuery _cQuery New Alias "TSF2"

				Count to _nTSF2

				If _nTSF2 = 0
					Loop
				Endif

				TcSetField("TSF2","F2_EMISSAO","D")

				TSF2->(dbGotop())

				While TSF2->(!EOF())

					If TSF2->F2_FILIAL $ "01/02" .And. TSF2->A1_COD_MUN   = "3547304"   // SANTANA DE PARNAIBA
						TSF2->(dbSkip()) // DENTRO DO MUNICIPIO NAO PRECISA DE CTE
						Loop
					ElseIf TSF2->F2_FILIAL == "06" .And. TSF2->A1_COD_MUN = "3518800" // GUARULHOS
						TSF2->(dbSkip()) // DENTRO DO MUNICIPIO NAO PRECISA DE CTE
						Loop
					ElseIf TSF2->F2_FILIAL == "07" .And. TSF2->A1_COD_MUN = "3505708" // BARUERI
						TSF2->(dbSkip()) // DENTRO DO MUNICIPIO NAO PRECISA DE CTE
						Loop
					Endif

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
					_nVolume := TSF2->F2_VOLUME1
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

					_cQry := " SELECT * FROM SA1010 A1 WHERE A1.D_E_L_E_T_ = '' AND A1_CGC = '"+Alltrim(_cCNPJRem)+"' "

					TcQuery _cQry New Alias "TSA1A"

					Count to _nTSA1A

					If _nTSA1A > 0

						TSA1A->(dbGoTop())

						TSA1->(RecLock("TSA1",.T.))
						_nCount := TSA1->(FCount())
						For i := 1 to _nCount
							_cCampo := TSA1->(Field(i))
							If TSA1A->(FieldPos(_cCampo)) > 0
								// &("TSA1->"+_cCampo) := &("TSA->"+_cCampo)
								_xVal := &("TSA1A->"+_cCampo)
								_xSA1 := &("SA1->"+_cCampo)
								If ValType(_xSA1) = 'D'
									_xVal := stod(_xVal)
								Endif
								&("TSA1->"+_cCampo) :=_xVal

							Endif
						Next i

						TSA1->(MsUnLock())

						TSA1A->(dbCloseArea())
					Endif
				Endif

				_oProcess:IncRegua1()
			Endif
		Next F

		TCUNLINK(_nDADOS)
		// TCSetConn(advConnection())	//-TCSetConn eh igual ao dbSelectArea

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
					SA1->(dbSetOrder(1))
					If !SA1->(MsSeek(xFilial("SA1")+TRB->CLIDES+TRB->LOJDES))

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

							SA1->(RecLock("SA1",.T.))
							_nCount := SA1->(FCount())
							For O := 1 to _nCount
								_cCampo := SA1->(Field(O))
								&("SA1->"+_cCampo) := &("TSA1->"+_cCampo)
							Next O
							SA1->A1_CDRDES := TSA1->A1_EST
							SA1->(MsUnLock())
						ELSE
							ShowHelpDlg("BRI137_1", {'Cliente Remessa não cadastrado.'},1,{'Cadastre o Cliente ('+TRB->CNPJRE+').'},1)
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
							ShowHelpDlg("BRI137_2", {'Não encontrado a série '+DUI->DUI_SERIE+' cadastrada.'},1,{'Solicite o cadastro pelo Administrador do sistema na tabelka SX5.'},1)
							Return(Nil)
						EndIF

						_cProdCte := DUI->DUI_CODPRO
					Else
						ShowHelpDlg("BRI137_3", {'Não encontrado o cadastro de Configuração de Documentos.'},1,{'Realize o cadastro de Configuração de Documentos.'},1)
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
							{"DTC_FILORI" 	,"01" 		, Nil},;
							{"DTC_LOTNFC" 	,_cLote 	, Nil},;
							{"DTC_CLIREM" 	,_cCliRem	, Nil},;
							{"DTC_LOJREM" 	,_cLojRem	, Nil},;
							{"DTC_DATENT" 	,TRB->EMISSAO , Nil},;
							{"DTC_CLIDES"	,_cCliDes	, Nil},;
							{"DTC_LOJDES" 	,_cLojDes	, Nil},;
							{"DTC_CLIDEV" 	,_cCliDes	, Nil},; //{"DTC_CLIDEV" 	,_cCliRem	, Nil},;
							{"DTC_LOJDEV" 	,_cLojDes	, Nil},; //{"DTC_LOJDEV" 	,_cLojRem	, Nil},;
							{"DTC_CLICAL" 	,_cCliDes	, Nil},; //{"DTC_CLICAL" 	,_cCliRem	, Nil}
							{"DTC_LOJCAL" 	,_cLojDes	, Nil},; //{"DTC_LOJCAL" 	,_cLojRem	, Nil},;
							{"DTC_DEVFRE" 	,"2" 		, Nil},; //{"DTC_DEVFRE" 	,"1" 		, Nil},;
							{"DTC_SERTMS" 	,"3" 		, Nil},; //{"DTC_SERTMS" 	,"3" 		, Nil},;
							{"DTC_TIPTRA" 	,"1" 		, Nil},; 
							{"DTC_SERVIC" 	,"SNE" 		, Nil},;
							{"DTC_TIPNFC" 	,"0" 		, Nil},;
							{"DTC_TIPFRE" 	,"2" 		, Nil},; //{"DTC_TIPFRE" 	,"1" 		, Nil},;
							{"DTC_CODNEG" 	,"01" 		, Nil},;
							{"DTC_SELORI" 	,"1" 		, Nil},;
							{"DTC_CDRORI" 	,_cRegRem	, Nil},;
							{"DTC_CDRDES" 	,_cRegDes	, Nil},;
							{"DTC_CDRCAL" 	,_cRegDes	, Nil},;
							{"DTC_DISTIV" 	,'2'		, Nil},;
							{"DTC_YPLACA" , TRB->PLACA  , Nil},;
							{"DTC_YQTLIT" , TRB->QTLITRO, Nil},;
							{"DTC_YVLUNI" , TRB->VLUNI  , Nil},;
							{"DTC_YVLTOT" , TRB->VLTOT  , Nil},;
							{"DTC_YFRCHE" , TRB->VLFRET , Nil}}
							
						aItem := {}
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

						AAdd(aVetDoc,{"DT6_FILORI",xFilial("DT6")})
						AAdd(aVetDoc,{"DT6_LOTNFC",_cLote})
						AAdd(aVetDoc,{"DT6_FILDOC","01"})
						AAdd(aVetDoc,{"DT6_DOC" 	,_cCTe})
						AAdd(aVetDoc,{"DT6_SERIE" 	,_cSerCTe})
						AAdd(aVetDoc,{"DT6_DATEMI",dDataBase}) //AAdd(aVetDoc,{"DT6_DATEMI",TRB->EMISSAO})
						AAdd(aVetDoc,{"DT6_HOREMI",StrTran(Left(Time(),5),":","")}) //AAdd(aVetDoc,{"DT6_HOREMI",TRB->HORA})
						AAdd(aVetDoc,{"DT6_VOLORI", 1})
						AAdd(aVetDoc,{"DT6_QTDVOL", TRB->VOLUME})
						AAdd(aVetDoc,{"DT6_PESO" ,  TRB->PLIQUI})
						AAdd(aVetDoc,{"DT6_PESOM3", 0.0000})
						AAdd(aVetDoc,{"DT6_PESCOB", TRB->PLIQUI})
						AAdd(aVetDoc,{"DT6_METRO3", 0.0000})
						AAdd(aVetDoc,{"DT6_VALMER", TRB->VALOR})
						AAdd(aVetDoc,{"DT6_QTDUNI", 0})
						AAdd(aVetDoc,{"DT6_VALFRE", TRB->VALFRET})
						AAdd(aVetDoc,{"DT6_VALIMP", 0})
						AAdd(aVetDoc,{"DT6_VALTOT", TRB->VALFRET})
						AAdd(aVetDoc,{"DT6_BASSEG", 0.00})
						AAdd(aVetDoc,{"DT6_SERTMS","3"})
						AAdd(aVetDoc,{"DT6_TIPTRA","1"})
						AAdd(aVetDoc,{"DT6_DOCTMS","2"})
						AAdd(aVetDoc,{"DT6_CDRORI",_cRegRem})
						AAdd(aVetDoc,{"DT6_CDRDES",_cRegDes})
						AAdd(aVetDoc,{"DT6_CDRCAL",_cRegDes})
						AAdd(aVetDoc,{"DT6_TABFRE","0001"})
						AAdd(aVetDoc,{"DT6_TIPTAB","01"})
						AAdd(aVetDoc,{"DT6_SEQTAB","00"})
						AAdd(aVetDoc,{"DT6_TIPFRE","2"}) //AAdd(aVetDoc,{"DT6_TIPFRE","1"})
						AAdd(aVetDoc,{"DT6_FILDES","01"})
						AAdd(aVetDoc,{"DT6_BLQDOC","2"})
						AAdd(aVetDoc,{"DT6_PRIPER","2"})
						AAdd(aVetDoc,{"DT6_PERDCO", 0.00000})
						AAdd(aVetDoc,{"DT6_FILDCO",""})
						AAdd(aVetDoc,{"DT6_DOCDCO",""})
						AAdd(aVetDoc,{"DT6_SERDCO",""})
						AAdd(aVetDoc,{"DT6_CLIREM",_cCliRem})
						AAdd(aVetDoc,{"DT6_LOJREM",_cLojRem})
						AAdd(aVetDoc,{"DT6_CLIDES",_cCliDes})
						AAdd(aVetDoc,{"DT6_LOJDES",_cLojDes})
						//AAdd(aVetDoc,{"DT6_CLIDEV",_cCliRem})
						//AAdd(aVetDoc,{"DT6_LOJDEV",_cLojRem})
						//AAdd(aVetDoc,{"DT6_CLICAL",_cCliRem})//--
						//AAdd(aVetDoc,{"DT6_LOJCAL",_cLojRem})//--
						//AAdd(aVetDoc,{"DT6_DEVFRE","1"})//--
						AAdd(aVetDoc,{"DT6_CLIDEV",_cCliDes})
						AAdd(aVetDoc,{"DT6_LOJDEV",_cLojDes})
						AAdd(aVetDoc,{"DT6_CLICAL",_cCliDes})		//ALTERADO POR ALISON - 04/02/20
						AAdd(aVetDoc,{"DT6_LOJCAL",_cLojDes})		//ALTERADO POR ALISON - 04/02/20
						AAdd(aVetDoc,{"DT6_DEVFRE","2"})			//ALTERADO POR ALISON - 04/02/20
						AAdd(aVetDoc,{"DT6_FATURA",""})
						AAdd(aVetDoc,{"DT6_SERVIC","SNE"})
						AAdd(aVetDoc,{"DT6_CODMSG",""})
						AAdd(aVetDoc,{"DT6_STATUS","1"})
						AAdd(aVetDoc,{"DT6_DATEDI",CToD(" / / ")})
						AAdd(aVetDoc,{"DT6_NUMSOL",""})
						AAdd(aVetDoc,{"DT6_VENCTO",CToD(" / / ")})
						AAdd(aVetDoc,{"DT6_FILDEB","01"})
						AAdd(aVetDoc,{"DT6_PREFIX",""})
						AAdd(aVetDoc,{"DT6_NUM" ,""})
						AAdd(aVetDoc,{"DT6_TIPO" ,""})
						AAdd(aVetDoc,{"DT6_MOEDA" , 1})
						AAdd(aVetDoc,{"DT6_BAIXA" ,CToD(" / / ")})
						AAdd(aVetDoc,{"DT6_FILNEG","01"})
						AAdd(aVetDoc,{"DT6_ALIANC",""})
						AAdd(aVetDoc,{"DT6_REENTR", 0})
						AAdd(aVetDoc,{"DT6_TIPMAN",""})
						AAdd(aVetDoc,{"DT6_PRZENT",TRB->EMISSAO})
						AAdd(aVetDoc,{"DT6_YSORIG",TRB->SERIE})
						AAdd(aVetDoc,{"DT6_FIMP" ,"0"})
						//AAdd(aVetDoc,{"DT6_YSORIG",TRB->SERIE})

						AAdd(aVetVlr,{{"DT8_CODPAS","07"},;
							{"DT8_VALPAS", TRB->VALFRET},;
							{"DT8_VALIMP", 0},;
							{"DT8_VALTOT", TRB->VALFRET},;
							{"DT8_FILORI",""},;
							{"DT8_TABFRE","0001"},;
							{"DT8_TIPTAB","01"},;
							{"DT8_FILDOC","01"},;
							{"DT8_CODPRO","CALC.FRETE"},;
							{"DT8_DOC" 	,_cLote},;
							{"DT8_SERIE" ,"PED"},;
							{"VLR_ICMSOL",0}})

						AAdd(aVetVlr,{{"DT8_CODPAS","TF"},;
							{"DT8_VALPAS", TRB->VALFRET},;
							{"DT8_VALIMP", 0},;
							{"DT8_VALTOT", TRB->VALFRET},;
							{"DT8_FILORI",""},;
							{"DT8_TABFRE",""},;
							{"DT8_TIPTAB",""},;
							{"DT8_FILDOC","01"},;
							{"DT8_CODPRO",_cProdCte},;
							{"DT8_DOC" ,_cLote},;
							{"DT8_SERIE" ,"PED"},;
							{"VLR_ICMSOL",0}})

						AAdd(aVetNFc,{{"DTC_CLIREM",_cCliRem},;
							{"DTC_LOJREM",_cLojRem},;
							{"DTC_NUMNFC",TRB->DOC},;
							{"DTC_SERNFC",TRB->SERIE},;
							{"DTC_CODPRO",_cProdCte},;
							{"DTC_QTDVOL", TRB->VOLUME},;
							{"DTC_PESO" , TRB->PLIQUI},;
							{"DTC_PESOM3", 0.0000},;
							{"DTC_METRO3", 0.0000},;
							{"DTC_VALOR" , TRB->VALOR}})

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
				TMSAE70(1,"01",,,,,,.T.)
				// TMSAE70(1,cFilAnt,,,,,,.T.) //ALTERADO POR ALEXANDRO EM 30/01/20

			ENDDO

			TRB->(dbCloseArea())

			TSA1->(dbCloseArea())

		ENDIF

		RpcClearEnv()   //Libera o Ambiente

	Next _nSM0


Return(Nil)



Static Function AtuSX1()

	_cPerg := "BRI137"
	_aRegs := {}

	//    	   Grupo/Ordem/Pergunta            /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01         /defspa1/defeng1/Cnt01/Var02/Def02  /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3     /cPyme/cGrpSxg/cHelp)
	U_CRIASX1(_cPerg,"01","Data NF De     ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR01",""            ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"" ,""   ,""     ,)
	U_CRIASX1(_cPerg,"02","Data NF Ate    ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02",""            ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"" ,""   ,""     ,)
	// U_CRIASX1(_cPerg,"03","Tipo               ?",""       ,""     ,"mv_ch3","N" ,01     ,0      ,0     ,"C",""        ,"MV_PAR03","Carregamento",""     ,""     ,""   ,""   ,"Descarregamento"     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""     ,)

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

	AADD(_aStru,{"PLACA"	, "C" , TAMSX3("F2_PLACA")[1]  , 0 })
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