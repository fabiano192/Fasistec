#INCLUDE 'TOTVS.CH'

User Function BRI137()

/*
	Local _aCabDTC := {}
	Local _aItemDTC := {}
	Local _cLoteAuto:= " "

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

	_cEmpAntBkp := cEmpAnt
	_cFilAntBkp := cFilAnt

	SA4->(dbSetOrder(1))
	If !SA4->(MsSeek(xFilial("SA4")+SF2->F2_TRANSP))
		Return(Nil)
	Endif

	_cCNPJ   := SA4->A4_CGC
	_AreaSM0 := SM0->(GetArea())
	_lAchou  := .F.
	_cCNPJRem:= SM0->M0_CGC

	_cCliDes := SF2->F2_CLIENTE
	_cLojDes := SF2->F2_LOJA
	_cDoc	 := SF2->F2_DOC
	_cSerie  := SF2->F2_SERIE
	_nVolume := SF2->F2_VOLUME1
	_nPeso   := SF2->F2_PLIQUI
	_nValor  := SF2->F2_VALBRUT

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

	Local aVetDoc := {}
	Local aVetVlr := {}
	Local aVetNFc := {}
	Local aItemDTC := {}
	Local aCabDTC := {}
	Local aItem := {}
	Local lCont := .T.
	Local cLotNfc := ''
	Local cRet := ''
	Local aCab := {}
	Local aErrMsg := {}

	Local _cLote
	Local _aCab := {}


	Local _aCabDTC := {}
	Local _aItemDTC := {}
	Local _cLoteAuto:= " "

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

	_cEmpAntBkp := cEmpAnt
	_cFilAntBkp := cFilAnt

	SA4->(dbSetOrder(1))
	If !SA4->(MsSeek(xFilial("SA4")+SF2->F2_TRANSP))
		Return(Nil)
	Endif

	_cCNPJ   := SA4->A4_CGC
	_AreaSM0 := SM0->(GetArea())
	_lAchou  := .F.
	_cCNPJRem:= SM0->M0_CGC

	_cCliDes := SF2->F2_CLIENTE
	_cLojDes := SF2->F2_LOJA
	_cDoc	 := SF2->F2_DOC
	_cSerie  := SF2->F2_SERIE
	_nVolume := SF2->F2_VOLUME1
	_nPeso   := SF2->F2_PLIQUI
	_nValor  := SF2->F2_VALBRUT
	_nVlFret := 0

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


	lMsErroAuto := .F. //Como variável já foi declarada acima, aqui ela foi foi declarada novamente. Caso contrario deve ser declarada com private

//Executa ExecAuto do Lote
	Aadd(_aCab,{'DTP_QTDLOT',1,NIL})
	Aadd(_aCab,{'DTP_QTDDIG',0,NIL})
	Aadd(_aCab,{'DTP_TIPLOT','3',NIL})//--1 Normal, 2- Refaturamento, 3- Eletronico
	Aadd(_aCab,{'DTP_STATUS','1',NIL})//--1 -Aberto, 2- Digitado, 3- Calculado, 4- Bloqueado, 5- Erro de Gravação

// Executa rotina TMSA170
	MSExecAuto({|x,y| _cLote := TMSA170(x,y)},_aCab,3)

// Retorna Resultado do Processo
	If lMsErroAuto
		MostraErro()
		_cLote := Space(TamSX3('DTP_LOTNFC')[1])
		lCont := .F.
	EndIf

	_cRet := DTP->DTP_LOTNFC

	If lCont

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

		lMsErroAuto := .F.

		aCabDTC := { {"DTC_FILORI" ,xFilial("DTC") , Nil},;
			{"DTC_LOTNFC" ,_cLote 	, Nil},;
			{"DTC_CLIREM" ,_cCliRem	, Nil},;
			{"DTC_LOJREM" ,_cLojRem	, Nil},;
			{"DTC_DATENT" ,dDataBase , Nil},;
			{"DTC_CLIDES" ,_cCliDes, Nil},;
			{"DTC_LOJDES" ,_cLojDes, Nil},;
			{"DTC_CLIDEV" ,_cCliRem, Nil},;
			{"DTC_LOJDEV" ,_cLojRem, Nil},;
			{"DTC_CLICAL" ,_cCliRem, Nil},;
			{"DTC_LOJCAL" ,_cLojRem, Nil},;
			{"DTC_DEVFRE" ,"1" , Nil},;
			{"DTC_SERTMS" ,"2" , Nil},;
			{"DTC_TIPTRA" ,"1" , Nil},;
			{"DTC_SERVIC" ,"SNE" , Nil},;
			{"DTC_TIPNFC" ,"0" , Nil},;
			{"DTC_TIPFRE" ,"1" , Nil},;
			{"DTC_CODNEG" ,"1" , Nil},;
			{"DTC_SELORI" ,"1" , Nil},;
			{"DTC_CDRORI" ,_cRegRem, Nil},;
			{"DTC_CDRDES" ,_cRegDes, Nil},;
			{"DTC_CDRCAL" ,_cRegDes, Nil},;
			{"DTC_DISTIV" ,'2', Nil}}

		aItem := {{"DTC_NUMNFC" ,_cDoc , Nil},;
			{"DTC_SERNFC" ,_cSerie , Nil},;
			{"DTC_CODPRO" ,"CALC.FRETE", Nil},;
			{"DTC_CODEMB" ,"GR" , Nil},;
			{"DTC_EMINFC" ,dDataBase , Nil},;
			{"DTC_QTDVOL" ,_nVolume , Nil},;
			{"DTC_PESO" ,_nPeso, Nil},;
			{"DTC_PESOM3" ,0.0000, Nil},;
			{"DTC_VALOR" ,_nValor, Nil},;
			{"DTC_BASSEG" ,0.00 , Nil},;
			{"DTC_METRO3" ,0.0000, Nil},;
			{"DTC_QTDUNI" ,0 , Nil},;
			{"DTC_EDI" ,"2" , Nil}}

		AAdd(aItemDTC,aClone(aItem))

// Parametros da TMSA050 (notas fiscais do cliente)
// xAutoCab - Cabecalho da nota fiscal
// xAutoItens - Itens da nota fiscal
// xItensPesM3 - acols de Peso Cubado
// xItensEnder - acols de Enderecamento
// nOpcAuto - Opcao rotina automatica
		MSExecAuto({|u,v,x,y,z| TMSA050(u,v,x,y,z)},aCabDTC,aItemDTC,,,3)
		If lMsErroAuto
			MostraErro()
			lCont := .F.
		Else
			DTC->(dbCommit())
		EndIf
	EndIf

	If lCont
		AAdd(aVetDoc,{"DT6_FILORI",xFilial("DT6")})
		AAdd(aVetDoc,{"DT6_LOTNFC",_cLote})
		AAdd(aVetDoc,{"DT6_FILDOC","01"})
		//AAdd(aVetDoc,{"DT6_DOC" ,_cDoc})
		//AAdd(aVetDoc,{"DT6_SERIE" ,_cSerie})
		AAdd(aVetDoc,{"DT6_DATEMI",dDataBase})
		AAdd(aVetDoc,{"DT6_HOREMI",StrTran(Left(Time(),5),":",""})
		AAdd(aVetDoc,{"DT6_VOLORI", 1})
		AAdd(aVetDoc,{"DT6_QTDVOL", 1})
		AAdd(aVetDoc,{"DT6_PESO" , _nPeso})
		AAdd(aVetDoc,{"DT6_PESOM3", 0.0000})
		AAdd(aVetDoc,{"DT6_PESCOB", _nPeso})
		AAdd(aVetDoc,{"DT6_METRO3", 0.0000})
		AAdd(aVetDoc,{"DT6_VALMER", _nValor})
		AAdd(aVetDoc,{"DT6_QTDUNI", 0})
		AAdd(aVetDoc,{"DT6_VALFRE", _nVlCte})
		AAdd(aVetDoc,{"DT6_VALIMP", 0})
		AAdd(aVetDoc,{"DT6_VALTOT", _nVlCte})
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
		AAdd(aVetDoc,{"DT6_PRZENT",dDataBase})
		AAdd(aVetDoc,{"DT6_FIMP" ,"0"})

		AAdd(aVetVlr,{{"DT8_CODPAS","07"},;
			{"DT8_VALPAS", _nVlFret},;
			{"DT8_VALIMP", 0,;
			{"DT8_VALTOT", _nVlFret},;
			{"DT8_FILORI",""},;
			{"DT8_TABFRE","0001"},;
			{"DT8_TIPTAB","01"},;
			{"DT8_FILDOC","01"},;
			{"DT8_CODPRO","CALC.FRETE"},;
			{"DT8_DOC" ,_cLote"},;
			{"DT8_SERIE" ,"PED"},;
			{"VLR_ICMSOL",0}})

		AAdd(aVetVlr,{{"DT8_CODPAS","TF"},;
			{"DT8_VALPAS", _nVlFret},;
			{"DT8_VALIMP", 0},;
			{"DT8_VALTOT", _nVlFret},;
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
			{"DTC_NUMNFC",_cDoc},;
			{"DTC_SERNFC",_cSerie},;
			{"DTC_CODPRO","CALC.FRETE"},;
			{"DTC_QTDVOL", _nVolume},;
			{"DTC_PESO" , _nPeso},;
			{"DTC_PESOM3", 0.0000},;
			{"DTC_METRO3", 0.0000},;
			{"DTC_VALOR" , _nValor}})

		aErrMsg := TMSImpDoc(aVetDoc,aVetVlr,aVetNFc,cLotNfc,.F.,0,1,.T.,.T.,.T.,.T.)
	EndIf

Return