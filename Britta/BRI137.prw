#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'

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
		LjMsgRun(_cMsgTit,_cProc,{||BRI137A()})
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
	Local cLotNfc	:= ''
	// Local cRet := ''
	// Local aCab := {}
	Local aErrMsg	:= {}

	Local _cLote	:= ''
	Local _aCab		:= {}

	Local F, B, I, N, O

	// Local _aCabDTC := {}
	// Local _aItemDTC := {}
	// Local _cLoteAuto:= " "
	Local _cQuery	:= ''
	lOCAL _nDados	:= -1

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

	Pergunte("BRI137",.F.)

	TCConType("TCPIP")

	_nDADOS  := TCLink("MSSQL/DADOS12","172.16.160.2")

	If _nDADOS < 0
		MsgStop("Não foi possível conectar no banco de dados do Protheus para buscar as Notas Fiscais.")
		Return(Nil)
	Endif

	//Seta o Banco de Dados
	TCSETCONN(_nDADOS)

	_aEmp := {"500127202325000103","500227202325000294","500604501925000177","500712141105000220"}

	GeraTRB()

	_lTRB := .F.
	For F := 1 to Len(_aEmp)

		_cEmp    := Left(_aEmp[F],2)
		_cFilEmp := Substr(_aEmp[F],3,2)
		_cCNPJRem:= Right(_aEmp[F],14)

		If Select("TSF2") > 0
			TSF2->(dbCloseArea())
		Endif

		_cQuery := " SELECT * FROM SF2"+_cEmp+"0 F2 " + CRLF
		_cQuery += " INNER JOIN SD2"+_cEmp+"0 D2 ON F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_FILIAL = D2_FILIAL" + CRLF
		_cQuery += " INNER JOIN SA1500 A1 ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA " + CRLF
		_cQuery += " INNER JOIN SA4"+_cEmp+"0 A4 ON F2_TRANSP = A4_COD AND F2_FILIAL = A4_FILIAL" + CRLF
		_cQuery += " WHERE F2.D_E_L_E_T_ = '' AND D2.D_E_L_E_T_ = '' AND A1.D_E_L_E_T_ = ''   AND A4.D_E_L_E_T_ = '' " + CRLF
		_cQuery += " AND F2_FILIAL = '"+_cFilEmp+"' "// AND D2_FILIAL = '"+_cFilEmp+"' AND A4_FILIAL = '"+_cFilEmp+"' " + CRLF
		_cQuery += " AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + CRLF
		_cQuery += " AND A1_GRPVEN = '000001' " + CRLF
		_cQuery += " AND A4_CGC = '15409884000100' "
		_cQuery += " ORDER BY F2_FILIAL,F2_SERIE,F2_DOC " + CRLF

		TcQuery _cQuery New Alias "TSF2"

		Count to _nTSF2

		If _nTSF2 = 0
			Loop
		Endif

		TcSetField("TSF2","F2_EMISSAO","D")

		TSF2->(dbGotop())

		While TSF2->(!EOF())

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
				TRB->EMISSAO:=_dEmissa
				TRB->HORA	:=_cHora
				TRB->(MsUnLock())

				_lTRB := .T.

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

	Next F

	TCUNLINK(_nDADOS)
// TCSetConn(advConnection())	//-TCSetConn eh igual ao dbSelectArea


	If _lTRB

		_cEmpAntBkp := cEmpAnt
		_cFilAntBkp := cFilAnt

		TRB->(dbGoTop())

		While TRB->(!EOF())

			_cCnpj  := TRB->CNPJTR
			_lAchou := .F.

			/*
			_AreaSM0 := SM0->(GetArea())

			RpcClearEnv()

			OpenSm0()
			*/
			SM0->(dbGoTop())

			While SM0->(!Eof()) .And. !_lAchou

				IF Alltrim(SM0->M0_CGC) = _cCNPJ
					_lAchou := .T.

					cEmpAnt := SM0->M0_CODIGO
					cFilAnt := SM0->M0_CODFIL

					// RpcSetType(3)
					// RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
				ENDIF

				SM0->(DbSkip())
			EndDo


			If !_lAchou
				TRB->(dbSkip())
			Endif

			While TRB->(!EOF()) .And. _cCnpj = TRB->CNPJTR

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
						loop
					endif
				Endif
				_cCliRem := SA1->A1_COD
				_cLojRem := SA1->A1_LOJA
				_cRegRem := SA1->A1_CDRDES

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

				_cRet := DTP->DTP_LOTNFC

				If lCont

					lMsErroAuto := .F.

					//Forçando a gravação, pois o msexecauto está gerando error.log
					DTC->(RecLock("DTC",.T.))
					DTC->DTC_FILORI	:= "01"
					// DTC->DTC_FILORI	:= xFilial("DTC")
					DTC->DTC_LOTNFC := _cLote
					DTC->DTC_CLIREM := _cCliRem
					DTC->DTC_LOJREM := _cLojRem
					DTC->DTC_DATENT := TRB->EMISSAO
					DTC->DTC_CLIDES := _cCliDes
					DTC->DTC_LOJDES := _cLojDes
					DTC->DTC_CLIDEV := _cCliRem
					DTC->DTC_LOJDEV := _cLojRem
					DTC->DTC_CLICAL := _cCliRem
					DTC->DTC_LOJCAL := _cLojRem
					DTC->DTC_DEVFRE := "1"
					DTC->DTC_SERTMS := "2"
					DTC->DTC_TIPTRA := "1"
					DTC->DTC_SERVIC := "SNE"
					DTC->DTC_TIPNFC := "0"
					DTC->DTC_TIPFRE := "1"
					DTC->DTC_CODNEG := "1"
					DTC->DTC_SELORI := "1"
					DTC->DTC_CDRORI := _cRegRem
					DTC->DTC_CDRDES := _cRegDes
					DTC->DTC_CDRCAL := _cRegDes
					DTC->DTC_DISTIV := '2'

					DTC->DTC_NUMNFC := TRB->DOC
					DTC->DTC_SERNFC := TRB->SERIE
					DTC->DTC_CODPRO := "CALC.FRETE"
					DTC->DTC_CODEMB := "GR"
					DTC->DTC_EMINFC := TRB->EMISSAO
					DTC->DTC_QTDVOL := TRB->VOLUME
					DTC->DTC_PESO	:= TRB->PLIQUI
					DTC->DTC_PESOM3 := 0.0000
					DTC->DTC_VALOR	:= TRB->VALOR
					DTC->DTC_BASSEG := 0.00
					DTC->DTC_METRO3 := 0.0000
					DTC->DTC_QTDUNI := 0
					DTC->DTC_EDI := "2"

					DTC->DTC_MOENFC := 1
					DTC->(MsUnLock())

					// aCabDTC := { {"DTC_FILORI" ,xFilial("DTC") , Nil},;
						// 	{"DTC_LOTNFC" ,_cLote 	, Nil},;
						// 	{"DTC_CLIREM" ,_cCliRem	, Nil},;
						// 	{"DTC_LOJREM" ,_cLojRem	, Nil},;
						// 	{"DTC_DATENT" ,TRB->EMISSAO , Nil},;
						// 	{"DTC_CLIDES" ,_cCliDes, Nil},;
						// 	{"DTC_LOJDES" ,_cLojDes, Nil},;
						// 	{"DTC_CLIDEV" ,_cCliRem, Nil},;
						// 	{"DTC_LOJDEV" ,_cLojRem, Nil},;
						// 	{"DTC_CLICAL" ,_cCliRem, Nil},;
						// 	{"DTC_LOJCAL" ,_cLojRem, Nil},;
						// 	{"DTC_DEVFRE" ,"1" , Nil},;
						// 	{"DTC_SERTMS" ,"2" , Nil},;
						// 	{"DTC_TIPTRA" ,"1" , Nil},;
						// 	{"DTC_SERVIC" ,"SNE" , Nil},;
						// 	{"DTC_TIPNFC" ,"0" , Nil},;
						// 	{"DTC_TIPFRE" ,"1" , Nil},;
						// 	{"DTC_CODNEG" ,"1" , Nil},;
						// 	{"DTC_SELORI" ,"1" , Nil},;
						// 	{"DTC_CDRORI" ,_cRegRem, Nil},;
						// 	{"DTC_CDRDES" ,_cRegDes, Nil},;
						// 	{"DTC_CDRCAL" ,_cRegDes, Nil},;
						// 	{"DTC_DISTIV" ,'2', Nil}}

					// aItem := {{"DTC_NUMNFC" ,TRB->DOC , Nil},;
						// 	{"DTC_SERNFC" ,TRB->SERIE , Nil},;
						// 	{"DTC_CODPRO" ,"CALC.FRETE", Nil},;
						// 	{"DTC_CODEMB" ,"GR" , Nil},;
						// 	{"DTC_EMINFC" ,TRB->EMISSAO , Nil},;
						// 	{"DTC_QTDVOL" ,TRB->VOLUME , Nil},;
						// 	{"DTC_PESO"   ,TRB->PLIQUI, Nil},;
						// 	{"DTC_PESOM3" ,0.0000, Nil},;
						// 	{"DTC_VALOR"  ,TRB->VALOR, Nil},;
						// 	{"DTC_BASSEG" ,0.00 , Nil},;
						// 	{"DTC_METRO3" ,0.0000, Nil},;
						// 	{"DTC_QTDUNI" ,0 , Nil},;
						// 	{"DTC_EDI" ,"2" , Nil}}

					// AAdd(aItemDTC,aClone(aItem))

// Parametros da TMSA050 (notas fiscais do cliente)
// xAutoCab - Cabecalho da nota fiscal
// xAutoItens - Itens da nota fiscal
// xItensPesM3 - acols de Peso Cubado
// xItensEnder - acols de Enderecamento
// nOpcAuto - Opcao rotina automatica
					// MSExecAuto({|u,v,x,y,z,w| TMSA050(u,v,x,y,z)},aCabDTC,aItemDTC,,,3)
					// // MSExecAuto({|u,v,x,y,z| TMSA050(u,v,x,y,z)},aCabDTC,aItemDTC,,,3)
					// If lMsErroAuto
					// 	MostraErro()
					// 	lCont := .F.
					// Else
					// 	DTC->(dbCommit())
					// EndIf
				EndIf

				If lCont
					AAdd(aVetDoc,{"DT6_FILORI",xFilial("DT6")})
					AAdd(aVetDoc,{"DT6_LOTNFC",_cLote})
					AAdd(aVetDoc,{"DT6_FILDOC","01"})
					AAdd(aVetDoc,{"DT6_DOC" 	,'100000001'})
					AAdd(aVetDoc,{"DT6_SERIE" 	,'ZZZ'})
					AAdd(aVetDoc,{"DT6_DATEMI",TRB->EMISSAO})
					AAdd(aVetDoc,{"DT6_HOREMI",TRB->HORA})
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
					AAdd(aVetDoc,{"DT6_TIPFRE","1"})
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
					AAdd(aVetDoc,{"DT6_CLIDEV",_cCliRem})
					AAdd(aVetDoc,{"DT6_LOJDEV",_cLojRem})
					AAdd(aVetDoc,{"DT6_CLICAL",_cCliRem})
					AAdd(aVetDoc,{"DT6_LOJCAL",_cLojRem})
					AAdd(aVetDoc,{"DT6_DEVFRE","1"})
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
					AAdd(aVetDoc,{"DT6_FIMP" ,"0"})

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
						{"DT8_CODPRO","CALC.FRETE"},;
						{"DT8_DOC" ,_cLote},;
						{"DT8_SERIE" ,"PED"},;
						{"VLR_ICMSOL",0}})

					AAdd(aVetNFc,{{"DTC_CLIREM",_cCliRem},;
						{"DTC_LOJREM",_cLojRem},;
						{"DTC_NUMNFC",TRB->DOC},;
						{"DTC_SERNFC",TRB->SERIE},;
						{"DTC_CODPRO","CALC.FRETE"},;
						{"DTC_QTDVOL", TRB->VOLUME},;
						{"DTC_PESO" , TRB->PLIQUI},;
						{"DTC_PESOM3", 0.0000},;
						{"DTC_METRO3", 0.0000},;
						{"DTC_VALOR" , TRB->VALOR}})

					aErrMsg := TMSImpDoc(aVetDoc,aVetVlr,aVetNFc,cLotNfc,.F.,0,1,.T.,.T.,.T.,.T.)
				EndIf

				TRB->(dbSkip())
			ENDDO
		ENDDO

		TRB->(dbCloseArea())

		TSA1->(dbCloseArea())

		RestArea(_AreaSM0)

		RpcClearEnv()

		cEmpAnt := _cEmpAntBkp
		cFilAnt := _cFilAntBk

	ENDIF


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

	AADD(_aStru,{"CNPJTR"	, "C" , TAMSX3("A4_CGC")[1], 0 })
	AADD(_aStru,{"CNPJRE"	, "C" , TAMSX3("A4_CGC")[1], 0 })
	AADD(_aStru,{"CNPJDE"	, "C" , TAMSX3("A4_CGC")[1], 0 })
	AADD(_aStru,{"CLIDES"	, "C" , TAMSX3("F2_CLIENTE")[1], 0 })
	AADD(_aStru,{"LOJDES"	, "C" , TAMSX3("F2_LOJA")[1], 0 })
	AADD(_aStru,{"DOC"		, "C" , TAMSX3("F2_DOC")[1], 0 })
	AADD(_aStru,{"SERIE"	, "C" , TAMSX3("F2_SERIE")[1], 0 })
	AADD(_aStru,{"EMISSAO"	, "D" , TAMSX3("F2_EMISSAO")[1], 0 })
	AADD(_aStru,{"HORA"		, "C" , TAMSX3("F2_HORA")[1], 0 })
	AADD(_aStru,{"VOLUME"	, "N" , TAMSX3("F2_VOLUME1")[1], 0 })
	AADD(_aStru,{"PLIQUI"	, "N" , TAMSX3("F2_PLIQUI")[1], TAMSX3("F2_PLIQUI")[2] })
	AADD(_aStru,{"VALBRUT"	, "N" , TAMSX3("F2_VALBRUT")[1], TAMSX3("F2_VALBRUT")[2] })
	AADD(_aStru,{"VALFRET"	, "N" , TAMSX3("DT6_VALFRE")[1], TAMSX3("DT6_VALFRE")[2]  })
	AADD(_aStru,{"VALOR"	, "N" , TAMSX3("F2_VALBRUT")[1], TAMSX3("F2_VALBRUT")[2]})
	// AADD(_aStru,{"DOC"		, "C" , TAMSX3("F2_DOC")[1], 0 })

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

/*
	Local _aCabDTC := {}
	Local _aItemDTC := {}
	Local _cLoteAuto:= " "

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

	_cEmpAntBkp := cEmpAnt
	_cFilAntBkp := cFilAnt

	SA4->(dbSetOrder(1))
	If !SA4->(MsSeek(xFilial("SA4")+TSF2->F2_TRANSP))
		Return(Nil)
	Endif

	_cCNPJ   := SA4->A4_CGC
	_AreaSM0 := SM0->(GetArea())
	_lAchou  := .F.
	_cCNPJRem:= SM0->M0_CGC

	_cCliDes := TSF2->F2_CLIENTE
	_cLojDes := TSF2->F2_LOJA
	_cDoc	 := TSF2->F2_DOC
	_cSerie  := TSF2->F2_SERIE
	_nVolume := TSF2->F2_VOLUME1
	_nPeso   := TSF2->F2_PLIQUI
	_nValor  := TSF2->F2_VALBRUT

	RpcClearEnv()

	OpenSm0()

	SM0->(dbGoTop())

	While SM0->(!Eof()) .And. !_lAchou

		IF Alltrim(SM0->M0_CGC) = _cCNPJ
			_lAchou := .T.
			// cEmpAnt := Alltrim(SM0->M0_CODIGO)
			// cFilAnt := Alltrim(SM0->M0_CODFIL)

			RpcSetType(3)
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
		ENDIF

		SM0->(DbSkip())
	EndDo

	If !_lAchou
		RetUrn(Nil)
	Endif

	// dbCloseAll()
	// OpenSM0(cEmpAnt+cFilAnt)
	// OpenFile(cEmpAnt+cFilAnt)

	_cLoteAuto := GetLote() //Chama MSExecAuto do TMSA170 para criar o lote automaticamente

	_cCliRem := _cLojRem := _cRegRem := ''
	SA1->(dbSetOrder(3))
	If SA1->(MsSeek(xFilial("SA1")+_cCNPJRem))
		_cCliRem := SA1->A1_COD
		_cLojRem := SA1->A1_LOJA
		_cRegRem := SA1->A1_CDRDES
	ELSE
		ShowHelpDlg("BRI137_1", {'Cliente Remessa não cadastrado.'},1,{'Cadastre o Cliente na empresa referente à Transportadora.'},1)
		Return(Nil)
	Endif

	_cRegDes := ''
	SA1->(dbSetOrder(1))
	If SA1->(MsSeek(xFilial("SA1")+_cCliDes+_cLojDes))
		_cRegDes := SA1->A1_CDRDES
	ELSE
		ShowHelpDlg("BRI137_1", {'Cliente Destino não cadastrado.'},1,{'Cadastre o Cliente na empresa referente à Transportadora.'},1)
		Return(Nil)
	Endif

// Dados da Nota Fiscal
	_aCabDTC:= {;
		{"DTC_FILORI" ,xFilial("DTC")	, Nil},; //Filial de Origem
	{"DTC_LOTNFC" ,_cLoteAuto		, Nil},; //Número Lote
	{"DTC_DATENT" ,dDataBase		, Nil},; //Data da Entrada
	{"DTC_CLIREM" ,_cCliRem			, Nil},; //Cod. Cliente Remetente
	{"DTC_LOJREM" ,_cLojRem 		, Nil},; //Loja Cliente Remetente
	{"DTC_CLIDES" ,_cCliDes 		, Nil},; //Cod. Destinatário
	{"DTC_LOJDES" ,_cLojDes			, Nil},; //Loja Destinatário
	{"DTC_DEVFRE" ,"1" 				, Nil},; //Devedor do Frete - 1=Remetente;2=Destinatario;3=Consignatario;4=Despachante
	{"DTC_CLIDEV" ,_cCliRem 		, Nil}	,; //Devedor - Cliente Devedor do Frete
	{"DTC_LOJDEV" ,_cLojRem 		, Nil}	,; //Loja Devedor - Loja Cliente Devedor do Frete
	{"DTC_CLICAL" ,_cCliRem 		, Nil},; //Cliente para Calculo
	{"DTC_LOJCAL" ,_cLojRem 		, Nil},; //Loja Cliente para Calculo
	{"DTC_TIPFRE" ,"1" 				, Nil},; //Tipo do Frete - 1=CIF;2=FOB
	{"DTC_SERTMS" ,"1" 				, Nil},; //Servico de Transporte - 1=Rodoviario / 2=Aereo / 3=Fluvial.
	{"DTC_TIPTRA" ,"1" 				, Nil},; //Tipo Transporte
	{"DTC_SERVIC" ,"SNE" 			, Nil},; //Serviço
	{"DTC_TIPNFC" ,"0" 				, Nil},; //Tipo Nf Cli. - 0=Normal;1=Devolucao;2=SubContratacao;3=Nao Fiscal;4=Exportacao;5=Redesp;6=Nao Fiscal 1;7=Nao Fiscal 2;8=Serv Vincul.Multimodal
	{"DTC_CDRORI" ,_cRegRem 		, Nil},; //Cod.Regiao Origem
	{"DTC_CDRDES" ,_cRegDes 		, Nil},; //Cod.Regiao Destino
	{"DTC_CDRCAL" ,_cRegDes 		, Nil},; //Cod.Regiao Calculo
	{"DTC_NCONTR" ,"000000000000001", Nil},; //Número do Contrato do Cliente.
	{"DTC_CODNEG" ,"01" 			, Nil},; //Código da Negociação do Contrato do Cliente.
	{"DTC_DOCTMS" ,"2" 				, Nil},; //Documento de Transporte
	{"DTC_SELORI" ,"2" 				, Nil}} //Seleciona Origem - 1=Transportadora;2=Cliente Remetente;3=Local Coleta

// Itens da NF
	Aadd(_aItemDTC,{ ;
		{"DTC_FILORI" ,xFilial("DTC") 		, Nil},; //Filial de Origem
	{"DTC_LOTNFC" ,_cLoteAuto 			, Nil},; //Número Lote
	{"DTC_NUMNFC" ,_cDoc 				, Nil},; //Doc.Cliente
	{"DTC_SERNFC" ,_cSerie				, Nil},; //Serie Docto. Cliente
	{"DTC_CODPRO" ,"PROD.CALC.FRETE" 	, Nil},; //Codigo do Produto
	{"DTC_CODEMB" ,"CX" 				, Nil},; //Codigo da Embalagem   ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
	{"DTC_EMINFC" ,dDataBase 			, Nil},; //Dt.Emissao Nf Cliente
	{"DTC_QTDVOL" ,_nVolume				, Nil},; //Quantidade de Volumes da Nota Fiscal do Cliente
	{"DTC_PESO"   ,_nPeso 				, Nil},; //Peso da Nota Fiscal do Cliente.
	{"DTC_VALOR" ,_nValor				, Nil},; //Valor da Nota Fiscal do Cliente
	{"DTC_CF" 	 ,'5932' 				, Nil},; //CFOP
	{"DTC_USUAGD",__cUserID 			, Nil},; //Codigo do Usuario Responsável pelo Agendamento de Entrega
	{"DTC_DOCREE","2" 					, Nil},; //Documento de Transporte
	{"DTC_PRVENT",dDataBase+1			, Nil},; //Hora Previsao de Entrega
	{"DTC_NFENTR","2" 					, Nil},; //Nome Expedidor
	{"DTC_EDI" 	 ,'2' 					, Nil}}) //Nota Fiscal do EDI Indica se a Nota Fiscal é de EDI (Electronic Data Interchange).

// Executa rotina TMSA050
	MSExecAuto({|u,v,x,y,z| TMSA050(u,v,x,y,z)},_aCabDTC,_aItemDTC,,,3)
	// MSExecAuto({|u,v,x,y,z| TMSA050(u,v,x,y,z)},_aCabDTC,_aItemDTC,,aItemEnd,3)

// Retorna Resultado do Processo
	If lMsErroAuto
		MostraErro()
	Else
		MsgInfo("Nota gravada com sucesso!")
	EndIf

	RestArea(_AreaSM0)

	RpcClearEnv()

	cEmpAnt := _cEmpAntBkp
	cFilAnt := _cFilAntBkp

Return(Nil)



Static Function GetLote()  // Função de MSExecAuto do Lote

	

Return(_cRet)
*/
