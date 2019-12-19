#INCLUDE 'TOTVS.CH'

User Function BRI137()

    // _cLote := GeraLote()

    // GeraCTE()

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

    Local _cRet
    Local _aCab := {}

    lMsErroAuto := .F. //Como variável já foi declarada acima, aqui ela foi foi declarada novamente. Caso contrario deve ser declarada com private

//Executa ExecAuto do Lote
    Aadd(_aCab,{'DTP_QTDLOT',1,NIL})
    Aadd(_aCab,{'DTP_QTDDIG',0,NIL})
    Aadd(_aCab,{'DTP_TIPLOT','3',NIL})//--1 Normal, 2- Refaturamento, 3- Eletronico
    Aadd(_aCab,{'DTP_STATUS','1',NIL})//--1 -Aberto, 2- Digitado, 3- Calculado, 4- Bloqueado, 5- Erro de Gravação

// Executa rotina TMSA170
    MSExecAuto({|x,y| _cRet := TMSA170(x,y)},_aCab,3)

// Retorna Resultado do Processo
    If lMsErroAuto
        MostraErro()
        _cRet := Space(TamSX3('DTP_LOTNFC')[1])
        Return(_cRet)
    EndIf

    _cRet := DTP->DTP_LOTNFC

Return(_cRet)