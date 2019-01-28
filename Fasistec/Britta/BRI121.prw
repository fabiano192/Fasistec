#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} BRI121
//Importação do arquivo de depósito identificado
@author Fabiano
@since 23/01/2019
@version 1.0
/*/
User Function BRI121(_aParam)

	Local _lAut	:= .F.
	Local _nOpc := 1
	Local _oDlg := NIL

	If ValType( _aParam ) <> "U"
		PREPARE ENVIRONMENT EMPRESA _aParam[1] FILIAL _aParam[2]
		_lAut := .T.
	Endif

	Private _cRedFold	:= SuperGetMV("BRI_LOCDEP",,'\EDI\DEPOSITO\')
	Private _cAnexo		:= ''
	Private _cEmpresa	:= ''
	Private _cFilial	:= ''

	If _lAut
		_nOpc := 0

		DEFINE MSDIALOG _oDlg FROM 264,182 TO 441,613 TITLE 'EDI - REDE' OF _oDlg PIXEL

		@ 004,010 TO 060,157 LABEL "" OF _oDlg PIXEL

		@ 010,017 SAY "Esta rotina tem por objetivo importar os arquivos" 	OF _oDlg PIXEL Size 150,010
		@ 020,017 SAY "referente ao Depósito Identificado"					OF _oDlg PIXEL Size 150,010

		@ 15,165 BUTTON "OK" 		 SIZE 036,012 ACTION (_nOpc := 1,_oDlg:End()) 	OF _oDlg PIXEL
		@ 40,165 BUTTON "Sair"       SIZE 036,012 ACTION ( _oDlg:End()) 			OF _oDlg PIXEL

		ACTIVATE MSDIALOG _oDlg CENTERED
	Endif

	If _nOpc = 1

		LjMsgRun('Importando arquivos, processando...','Depósito Identificado',{|| BRI121A()})

		LjMsgRun('Gerando e-mail, processando...','Depósito Identificado',{|| BRI121B()})

	Endif

Return(Nil)



Static Function BRI121A() //Importar arquivo

	Local _oTMP
	Local _aStru := {}

	Private _cCliente
	Private _cLoja

	//CriaçãO de tabela temporária no banco de dados
	_oTMP := FWTemporaryTable():New( "BRI121" )

	AADD(_aStru,{"TIPO"     , "C" , 01						, 0 })
	AADD(_aStru,{"EMPRESA"  , "C" , 02						, 0 })
	AADD(_aStru,{"FILIAL"   , "C" , 02						, 0 })
	AADD(_aStru,{"CLIENTE"  , "C" , TamSx3("E1_CLIENTE")[1]	, 0 })
	AADD(_aStru,{"LOJA"     , "C" , TamSx3("E1_LOJA")[1]	, 0 })
	AADD(_aStru,{"NOMECLI"  , "C" , TamSx3("A1_NREDUZ")[1]	, 0 })
	AADD(_aStru,{"PREFIXO"  , "C" , TamSx3("E1_PREFIXO")[1]	, 0 })
	AADD(_aStru,{"NUMERO"   , "C" , TamSx3("E1_NUM")[1] 	, 0 })
	AADD(_aStru,{"PARCELA"  , "C" , TamSx3("E1_PARCELA")[1]	, 0 })
	AADD(_aStru,{"DTPGTO"   , "D" , TamSx3("E5_DTDISPO")[1]	, 0 })
	AADD(_aStru,{"VLRPGTO"  , "N" , TamSx3("E5_VALOR")[1]	, TamSx3("E5_VALOR")[2] })
	AADD(_aStru,{"ARQUIVO"  , "C" , 100, 0 })
	AADD(_aStru,{"MSG"      , "C" , 200, 0 })

	//CriaçãO de indice na tabela temporária no banco de dados
	_oTMP:SetFields( _aStru )
	_oTMP:AddIndex("INDICE1", {"TIPO","EMPRESA","FILIAL","CLIENTE","LOJA","PREFIXO","NUMERO","PARCELA"} )

	//Criação da tabela
	_oTMP:Create()

	_cDir := _cRedFold

	_aListFile	:= Directory( _cDir + '*.txt' )

	ProcRegua(Len( _aListFile ))

	For nI:=1 To Len( _aListFile )

		IncProc()

		_cFile := AllTrim(_aListFile[nI][1])

		FT_FUSE( _cDir + _cFile )
		FT_FGOTOP()

		Do While !FT_FEOF()

			_cBuffer := FT_FREADLN()

			_aLin := StrTokArr( _cBuffer , "," )

			If Len(_aLin) > 0

				If Alltrim(_aLin[1]) == '00' //Cabeçalho do arquivo
					/*
					Coluna 	Tamanho 	Tipo		Descrição do campo
					1 		002 		Num. 		Tipo de registro
					2 		009 		Num. 		Nº- de filiação da matriz ou grupo comercial
					3 		008 		Num. 		Data de emissão (DDMMAAAA)
					4 		008 		Num. 		Data de movimento (DDMMAAAA)
					5 		039 		Alfa 		“Movimentação diária – Cartões de débito”
					6 		008 		Alfa 		“Rede”
					7 		026 		Alfa 		Nome comercial do estabelecimento
					8 		006 		Num. 		Sequência de movimento
					9 		015 		Alfa 		Tipo de processamento (diário/reprocessamento)
					10 		020 		Alfa 		Versão do arquivo (V1.04 – 07/10 – EEVD)
					*/

					_cGrupo := Alltrim(_aLin[2])
					_cDtMov := Alltrim(_aLin[4])
					_dDtMov := cTod(Left(_cDtMov,2)+'/'+Substr(_cDtMov,3,2)+'/'+Right(_cDtMov,4))
					//					If Alltrim(aLin[17]) == 'T' //Se for Teste
					//						FT_FUSE() //Fecha o arquivo
					//						Exit
					//					Endif

				ElseIf Alltrim(_aLin[1]) == '05' //Detalhamento dos comprovantes de vendas
					/*
					Coluna 	Tamanho 	Tipo		Descrição do campo
					1 		002 		Num. 		Tipo de registro
					2 		009 		Num. 		N.º de filiação do ponto de venda
					3 		009 		Num. 		N.º do resumo de Vendas
					4 		008 		Num. 		Data do CV (DDMMAAAA)
					5 		015 		9(13)V99 	Valor bruto (para o compre e saque,este campo será composto pelo “Valor da Compra”+ “Valor do Saque”)
					6 		015 		9(13)V99 	Valor desconto
					7 		015 		9(13)V99 	Valor líquido
					8 		019 		Alfa 		Número do cartão
					9 		001 		Alfa 		Tipo de transação
					10 		012 		Num. 		Número do CV
					11 		008 		Num. 		Data do crédito (DDMMAAAA)
					12 		002 		Num. 		Status da transação (01 – acatada)
					13 		006 		Num. 		Hora da transação (HHMMSS)
					14 		008 		Alfa 		Número do terminal
					15 		002 		Num. 		Tipo de captura
					16 		005 		Num. 		Reservado
					17 		015 		9(13)V99 	Valor da compra (para o compre e saque )
					18 		015 		9(13)V99 	Valor do saque (para o compre e saque)
					19 		001 		Alfa 		Bandeira
					*/

					_cPV      := Alltrim(_aLin[2])
					_cContVen := Alltrim(_aLin[12])
					_dDtEmis  := cTod(Left(_aLin[4],2)+'/'+Substr(_aLin[4],3,2)+'/'+Right(Alltrim(_aLin[4]),4))
					_nValLiq  := Val(_aLin[7])/100
					_dDtCred  := cTod(Left(_aLin[11],2)+'/'+Substr(_aLin[11],3,2)+'/'+Right(Alltrim(_aLin[11]),4))

					LoadBaixa(_cFile,_cPV,_cGrupo,_cContVen,_dDtEmis,_nValLiq,_dDtCred,)

				Endif
			Endif

			FT_FSKIP()

		EndDo

		FT_FUSE()

		If _lBKP
			_cData    := GravaData(dDataBase,.f.,8)
			_cHora    := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
			_cEmpFil  := _cEmpresa+_cFilial

			If !ExistDir(_cDir+"BKP\"+_cEmpFil)
				If MakeDir(_cDir+"BKP\"+_cEmpFil) <> 0
					MsgAlert("Nao foi possível criar o diretório "+_cDir+"BKP\"+_cEmpFil)
					Return(Nil)
				Endif
			Endif
			__CopyFile( _cDir +_cFile, _cDir+"BKP\"+_cEmpFil+"\"+_cData+_cHora+"_"+_cFile )
			FErase(_cDir +cFile)
		Endif

	Next NI

Return(Nil)




Static Function LoadBaixa(_cFile,_cPV,_cGrupo,_cContVen,_dDtEmis,_nValLiq,_dDtCred) //Baixar título

/*
	ZF3->(dbSetOrder(2))
	If !ZF3->(MsSeek(xFilial("ZF3")+Alltrim(_cPV)))
		BRI121->(RecLock("BRI121",.T.))
		BRI121->TIPO		:= '1'
		BRI121->EMPRESA	:= ''
		BRI121->FILIAL	:= ''
		BRI121->CLIENTE	:= ''
		BRI121->LOJA		:= ''
		BRI121->NOMECLI	:= ''
		BRI121->PREFIXO	:= ''
		BRI121->NUMERO	:= ''
		BRI121->PARCELA	:= ''
		BRI121->DTPGTO	:= _dDtCred
		BRI121->VLRPGTO	:= _nValLiq
		BRI121->ARQUIVO	:= _cFile
		BRI121->MSG		:= 'Não encontrado cadastro da empresa/Filial para o código apresentado: '+Alltrim(_cGrupo)
		BRI121->(MsUnLock())

		Return(Nil)
	Endif

	_cEmpresa := ZF3->ZF3_EMPRES
	_cFilial  := ZF3->ZF3_CODFIL

	If Select('SM0')>0
		nRecno := SM0->(Recno())
		RpcClearEnv()
	Endif

	OpenSM0()

	IF SM0->(msSeek(Left(_cEmpresa, 4) , .F. ) )
		RpcSetType(3)
		//		RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL,'schedule','schedule','FIN',,{"ZF3","SE1","SE5","SA6","SED","SA1"})
		RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL,'schedule','schedule','FIN')
	Else
		CONOUT("BRI121 - Não encontrou empresa "+_cEmpresa)
		SM0->(dbGoTop())
		dbCloseAll()
		RpcClearEnv()
	Endif
*/
	CONOUT("BRI121 - SETADA EMPRESA : "+_cEmpresa)
	CONOUT("ROTINA --> BRI121 :"+DTOS(DDATABASE)+" HORA: "+TIME())

	SE1->(dbOrderNickName('E1XNCC'))
	If !SE1->(MsSeek(xFilial("SE1")+Alltrim(_cContVen)))
		BRI121->(RecLock("BRI121",.T.))
		BRI121->TIPO		:= '1'
		BRI121->EMPRESA	:= cEmpAnt
		BRI121->FILIAL	:= cFilAnt
		BRI121->CLIENTE	:= ''
		BRI121->LOJA		:= ''
		BRI121->NOMECLI	:= ''
		BRI121->PREFIXO	:= ''
		BRI121->NUMERO	:= ''
		BRI121->PARCELA	:= ''
		BRI121->DTPGTO	:= _dDtCred
		BRI121->VLRPGTO	:= _nValLiq
		BRI121->ARQUIVO	:= _cFile
		BRI121->MSG		:= 'Não encontrado título para baixa: '+Alltrim(_cContVen)
		BRI121->(MsUnLock())

		Return(Nil)
	Endif

	_aBaixa := {;
	{"E1_PREFIXO"		,SE1->E1_PREFIXO			,Nil    },;
	{"E1_NUM"			,SE1->E1_NUM				,Nil    },;
	{"E1_PARCELA"		,SE1->E1_PARCELA			,Nil    },;
	{"E1_TIPO"			,SE1->E1_TIPO				,Nil    },;
	{"AUTMOTBX"			,"CHQ"						,Nil    },;
	{"AUTBANCO"			,_cBco						,Nil    },;
	{"AUTAGENCIA"		,_cAge						,Nil    },;
	{"AUTCONTA"			,_cCta						,Nil	},;
	{"AUTDTBAIXA"		,dDataBase					,Nil	},;
	{"AUTDTCREDITO"		,_dDtCred					,Nil	},;
	{"AUTHIST"			,_cHis						,Nil	},;
	{"AUTACRESC"		,0							,Nil,.T.},;
	{"AUTJUROS"			,0							,Nil,.T.},;
	{"AUTDECRESC"		,0							,Nil,.T.},;
	{"AUTVALREC"		,_nValLiq					,Nil	}}

	lMsErroAuto := .F.

	dbSelectArea("SE1")

	RetIndex("SE1")

	MSExecAuto({|x,y| FINA070(x,y)},_aBaixa,3)

	If lMsErroAuto
		BRI121->(RecLock("BRI121",.T.))
		BRI121->TIPO		:= '1'
		BRI121->EMPRESA	:= cEmpAnt
		BRI121->FILIAL	:= cFilAnt
		BRI121->CLIENTE	:= SE1->E1_CLIENTE
		BRI121->LOJA		:= SE1->E1_LOJA
		BRI121->NOMECLI	:= SE1->E1_LOJA
		BRI121->PREFIXO	:= SE1->E1_PREFIXO
		BRI121->NUMERO	:= SE1->E1_NUM
		BRI121->PARCELA	:= SE1->E1_PARCELA
		BRI121->DTPGTO	:= _dDtCred
		BRI121->VLRPGTO	:= _nValLiq
		BRI121->ARQUIVO	:= _cFile
		BRI121->MSG		:= 'Erro ao tentar realizar a baixa'
		BRI121->(MsUnLock())
	Else
		BRI121->(RecLock("BRI121",.T.))
		BRI121->TIPO		:= '0'
		BRI121->EMPRESA	:= cEmpAnt
		BRI121->FILIAL	:= cFilAnt
		BRI121->CLIENTE	:= SE1->E1_CLIENTE
		BRI121->LOJA		:= SE1->E1_LOJA
		BRI121->NOMECLI	:= SE1->E1_LOJA
		BRI121->PREFIXO	:= SE1->E1_PREFIXO
		BRI121->NUMERO	:= SE1->E1_NUM
		BRI121->PARCELA	:= SE1->E1_PARCELA
		BRI121->DTPGTO	:= _dDtCred
		BRI121->VLRPGTO	:= _nValLiq
		BRI121->ARQUIVO	:= _cFile
		BRI121->MSG		:= 'Baixa Realizada com sucesso'
		BRI121->(MsUnLock())
	Endif

Return(Nil)



Static Function BRI121B() //Gerar arquivo à ser enviado por e-mail

	Local _oFwMsEx 		:= NIL
	Local _cArq 			:= ""
	Local _cWorkSheet	:= ""
	Local _cTable 		:= ""
	Local _lEnt 		:= .F.
	/*
	Indice		Descrição
	1			Cliente não Cadastrado
	2			Produto Não cadastrado
	3			PO não cadastrado
	4			Revisão Não Cadastrado
	*/

	_oFwMsEx := FWMsExcel():New()

	BRI121->(dbGotop())

	While !BRI121->(Eof())

		_cIndice := BRI121->TIPO

		_lEnt := .T.
		If _cIndice = "0"
			_cWorkSheet 	:= 	"Baixas_OK"
			_cTable 		:= 	"Baixas Realizadas com sucesso"
		Else
			_cWorkSheet 	:= 	"Nao_Realizado"
			_cTable 		:= 	"Baixas NÃO Realizadas"
		Endif

		_oFwMsEx:AddWorkSheet( _cWorkSheet )
		_oFwMsEx:AddTable( _cWorkSheet, _cTable )

		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Empresa"		, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Filial"			, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Cliente"   		, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Loja"			, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Nome"   		, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Prefixo"   		, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Numero"  		, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Parcela"   		, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Data Pagto"   	, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Valor"   		, 3,2,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Obs"  			, 1,1,.F.)
		_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Arquivo"		, 1,1,.F.)

		While !BRI121->(Eof()) //.And. _cIndice == BRI121->INDICE

			_oFwMsEx:AddRow( _cWorkSheet, _cTable,{;
			BRI121->EMPRESA	,;
			BRI121->FILIAL	,;
			BRI121->CLIENTE	,;
			BRI121->LOJA	,;
			BRI121->NOMECLI	,;
			BRI121->PREFIXO	,;
			BRI121->NUMERO	,;
			BRI121->PARCELA	,;
			BRI121->DTPGTO	,;
			BRI121->VLRPGTO	,;
			BRI121->ARQUIVO	,;
			BRI121->MSG		})

			BRI121->(dbSkip())
		EndDo
	EndDo

	//Exclui a tabela
	_oTMP:Delete()

	_oFwMsEx:Activate()

	_cDat1		:= GravaData(dDataBase,.f.,8)
	_cHor1		:= Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

	_cArq 		:= 'EDI_REDE_'+_cDat1+'_'+_cHor1 + ".xls"

	_cAnexo 	:= "\WORKFLOW\RELATORIOS\"+_cArq

	_oFwMsEx:GetXMLFile( _cAnexo )

	If _lEnt
		BRI121C() 	//Envia e-mail
	Endif

Return(Nil)



Static Function BRI121C() //Envia e-mail

	Local _cTo		:= SuperGetMV("BRI_MAILRE",,'fabiano@assystem.com.br')
	Local _oProcess := TWFProcess():New( "EDI_REDE", "PO_CBL" )

	_oProcess:NewTask( "EDI_REDE", "\WORKFLOW\BRI121.HTM" )
	_oProcess:bReturn  := ""
	_oProcess:bTimeOut := ""

	_oHTML := _oProcess:oHTML

	_oProcess:cSubject := "EDI-REDE - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

	_oProcess:fDesc := "EDI REDE"

	Private _cTo := _cCC := ""

	_oProcess:AttachFile(_cAnexo)

	_oProcess:cTo := _cTo
	_oProcess:cCC := _cCC

	_oProcess:Start()

	_oProcess:Finish()

	FErase(_cAnexo)

Return(Nil)




