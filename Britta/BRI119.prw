#include "TOTVS.ch"
#include "TOPCONN.ch"
#INCLUDE "TBICONN.CH"

/*/
Funçao    	³ 	BRI119
Autor 		³ 	Fabiano da Silva
Data 		³ 	30.11.18
Descricao 	³ 	Importação do Arquivo EDI para realizar as baixas do Contas a Receber - REDE
/*/

User Function BRI119(_aParam)

	Local _lAut := .T.
	Local _nOpc := 1
	LOCAL _oDlg := NIL
	/*
	If ValType(_aParam) <> 'NIL'
	PREPARE ENVIRONMENT EMPRESA _aParam[1] FILIAL _aParam[2]
	_lAut := .T.
	Endif
	*/
	//Private _cRedFold	:= SuperGetMV("BRI_LOCRED",,'\EDI\REDE\') 
	Private _cRedFold	:= SuperGetMV("BRI_LOCRED",,'C:\EDI\RECEBER\')
	Private _cAnexo		:= ''
	Private _cEmpresa	:= ''
	Private _cFilial	:= ''
	Private _aRet       := {{},{}}
	Private _cHis       := "Valor recebido s/ Titulo"

	Private _cBanco		:= ""
	Private _cAgenc		:= ""
	Private _cConta		:= ""

	If _lAut
		_nOpc := 0

		DEFINE MSDIALOG _oDlg FROM 0,0 TO 100,290 TITLE 'EDI - REDE' OF _oDlg PIXEL

		@ 005,005 TO 030,140 LABEL "" OF _oDlg PIXEL

		@ 010,015 SAY "Esta rotina tem por objetivo importar os dados" 	OF _oDlg PIXEL Size 150,010
		@ 020,015 SAY "de Compra referente ao EDI - Rede"				OF _oDlg PIXEL Size 150,010

		@ 035,025 BUTTON "OK"	SIZE 035,012 ACTION (_nOpc := 1,_oDlg:End()) 	OF _oDlg PIXEL
		@ 035,085 BUTTON "Sair"	SIZE 035,012 ACTION ( _oDlg:End()) 			OF _oDlg PIXEL

		ACTIVATE MSDIALOG _oDlg CENTERED
	Endif

	If _nOpc = 1

		LjMsgRun('Importando arquivos EDI, processando...','EDI -  REDE',{|| BRI119A()})

		LjMsgRun('Gerando extrato das baixas e enviando e-mail, processando...','EDI -  REDE',{|| BRI119C()()})

	Endif

Return(Nil)



Static Function BRI119A()

	Local _oTMP
	Local _aStru := {}

	Private _cCliente
	Private _cLoja

	_cDir       := _cRedFold

	_aListFile	:= Directory( _cDir + '*.txt' )

	ProcRegua(Len( _aListFile ))

	For nI:=1 To Len( _aListFile )

		IncProc()

		_cFile := AllTrim(_aListFile[nI][1])

		FT_FUSE( _cDir + _cFile )
		FT_FGOTOP()

		If Substr(_cFile,7,4) == "EEVD"

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
						//						_cContVen := Alltrim(_aLin[12])
						_cContVen := Alltrim(_aLin[10])
						_dDtEmis  := cTod(Left(_aLin[4],2)+'/'+Substr(_aLin[4],3,2)+'/'+Right(Alltrim(_aLin[4]),4))
						_nValLiq  := Val(_aLin[7])/100
						_dDtCred  := cTod(Left(_aLin[11],2)+'/'+Substr(_aLin[11],3,2)+'/'+Right(Alltrim(_aLin[11]),4))

						LoadBaixa(1,_cFile,_cPV,_cGrupo,_cContVen,_dDtEmis,_nValLiq,_dDtCred,)

					Endif
				Endif

				FT_FSKIP()

			EndDo

		ElseIf Substr(_cFile,7,4) == "EEVC"

			Do While !FT_FEOF()

				_cBuffer := FT_FREADLN()

				//_aLin := StrTokArr( _cBuffer , "," )

				_cLinha := _cBuffer

				_cTipo  := Substr(_cLinha,001,003)

				If Len(_cLinha) > 0

					If _cTipo == '002' //Cabeçalho do arquivo
						/*
						Coluna 	Tamanho  De		Ate 	Tipo		Descrição do campo
						1 		003 	 001	003		Num. 		Tipo de registro
						2 		008 	 004	011		Num. 		Data de Emissao
						3 		008 	 012	019		Alfa 		Rede
						4 		030		 020	049		Num. 		Extrato Eletronico de Vendas
						5 		022 	 050	071		Alfa 		Nome comercial do estabelecimento
						6 		006		 072	077		Alfa 		Sequência de movimento
						7 		009 	 078	086		Alfa 		Numero PV Grupo ou Matriz
						8 		015 	 087	101		Alfa 		Tipo de processamento (diário/reprocessamento)
						9  		020 	 102	121		Alfa 		Versão do arquivo (V1.04 – 07/10 – EEVD)
						*/

						_cDtMov := Substr(_cLinha,004,008)
						_cGrupo := Substr(_cLinha,078,009)

						_dDtMov := cTod(Left(_cDtMov,2)+'/'+Substr(_cDtMov,3,2)+'/'+Right(_cDtMov,4))

					ElseIf _cTipo == '008' //Detalhamento dos comprovantes de vendas
						/*
						Coluna 	Tamanho De	Ate 	Tipo		Descrição do campo
						1 		003 	001	003		Num. 		Tipo de registro ("008")
						2 		009 	004	012		Num. 		N.º de filiação do ponto de venda
						3 		009 	013	021		Num. 		N.º do resumo de Vendas
						4 		008 	022	029		Num. 		Data do CV (DDMMAAAA)
						5		008		030	037		Num.		Zeros
						6 		015 	038	052		9(13)V99 	Valor do CV/NSU
						7 		015 	053	067		9(13)V99 	Valor da Gorjeta
						8 		016 	068	083		Alfa     	Numero do Cartao
						9 		003 	084	086		Alfa 		Status do CV/NSU
						10 		012		087	098		Num. 		Número do CV/NSU
						11 		013 	099	111		Num. 		Numero de Referencia
						12 		015		112	126		9(13)V99 	Valor do Desconto
						13 		006 	127	132		Num. 		Numero da Autorizacao
						14 		006		133	138		Num. 		Hora da transação (HHMMSS)
						15 		064 	139	202		Alfa 		Número do Bilhete
						16 		001 	203	203		Num. 		Tipo de captura
						17 		015 	204	218		9(13)V99 	Valor Liquido
						18 		008		219	226		Num. 		Numero do Terminal
						19 		003		227	229		Alfa		Sigla do Pais
						20 		001 	230	230		Alfa 		Bandeira
						*/

						_cPV      := Substr(_cLinha,004,009)
						_cContVen := Substr(_cLinha,127,006)
						_cDtEmis  := Substr(_cLinha,022,008)
						_dDtEmis  := CTOD(LEFT(_cDtEmis,2)+'/'+Substr(_cDtEmis,3,2)+'/'+Right(Alltrim(_cDtEmis),4))
						_nValLiq  := Val(Substr(_cLinha,038,015)) / 100
						_dDtCred  := _dDtEmis

						LoadBaixa(2,_cFile,_cPV,_cGrupo,_cContVen,_dDtEmis,_nValLiq,_dDtCred,)

					Endif
				Endif

				FT_FSKIP()

			EndDo
		Endif

		FT_FUSE()

		//If _lBKP
		_cData    := GravaData(dDataBase,.f.,8)
		_cHora    := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
		_cEmpFil  := _cEmpresa+_cFilial

		If !ExistDir(_cDir+"BKP\")
			If MakeDir(_cDir+"BKP\") <> 0
				MsgAlert("Nao foi possível criar o diretório "+_cDir+"BKP\")
				Return(Nil)
			Endif
		Endif

		__CopyFile( _cDir +_cFile, _cDir+"BKP\"+_cData+_cHora+"_"+_cFile )

		FErase(_cDir + _cFile)

	Next NI

Return(Nil)





Static Function LoadBaixa(_nTp,_cFile,_cPV,_cGrupo,_cContVen,_dDtEmis,_nValLiq,_dDtCred)

	ZF3->(dbSetOrder(2))
	If !ZF3->(MsSeek(xFilial("ZF3") + Alltrim(_cPV)))
		AAdd(_aRet[_nTp], {"1",;  		// TIPO
		"",;   		// EMPRESA
		"",;   		// FILIAL
		"",;   		// CLIENTE
		"",;   		// LOJA
		"",;   		// NOMECLI
		"",;  	    // PREFIXO
		"",;   		// NUMERO
		"",;   		// PARCELA
		_dDtCred,;  // DTPGTO
		_nValLiq,;  // VLRPGTO
		_cFile,;	// ARQUIVO
		"Não encontrado cadastro da empresa/Filial para o código apresentado: "+Alltrim(_cGrupo)}) // MSG

		Return(Nil)
	Endif

	_cEmpresa := ZF3->ZF3_EMPRES
	_cFilial  := ZF3->ZF3_CODFIL

	cFilAnt   := _cFilial

	_cBanco	:= SuperGetMV("BRI_BCOCAR",,"837") 
	_cAgenc	:= SuperGetMV("BRI_AGECAR",,"005")
	_cConta	:= SuperGetMV("BRI_CTACAR",,"00005")

	//CONOUT("BRI119 - SETADA EMPRESA : "+_cEmpresa)
	//CONOUT("ROTINA --> BRI119 :"+DTOS(DDATABASE)+" HORA: "+TIME())

	SE1->(dbOrderNickName('E1XNCC'))
	//If !SE1->(MsSeek(xFilial("SE1")+Alltrim(_cContVen))) 
	If !SE1->(MsSeek(_cFilial + Alltrim(_cContVen)))

		AAdd(_aRet[_nTp], {"1",; // TIPO
		cEmpAnt,; 	// EMPRESA
		cFilAnt,; 	// FILIAL
		"",;   		// CLIENTE
		"",;   		// LOJA
		"",;   		// NOMECLI
		"",;  	    // PREFIXO
		"",;   		// NUMERO
		"",;   		// PARCELA
		_dDtCred,;  // DTPGTO
		_nValLiq,;  // VLRPGTO
		_cFile,;	// ARQUIVO
		"Não encontrado título para baixa: "+Alltrim(_cContVen)}) // MSG

		Return(Nil)
	Endif

	_aBaixa := {;
	{"E1_PREFIXO"		,SE1->E1_PREFIXO			,Nil    },;
	{"E1_NUM"			,SE1->E1_NUM				,Nil    },;
	{"E1_PARCELA"		,SE1->E1_PARCELA			,Nil    },;
	{"E1_TIPO"			,SE1->E1_TIPO				,Nil    },;
	{"AUTMOTBX"			,"CHQ"						,Nil    },;
	{"AUTBANCO"			,_cBanco					,Nil    },;
	{"AUTAGENCIA"		,_cAgenc					,Nil    },;
	{"AUTCONTA"			,_cConta					,Nil	},;
	{"AUTDTBAIXA"		,_dDtCred					,Nil	},;
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

		//MostraErro()

		AAdd(_aRet[_nTp], {"1",; 	// TIPO
		cEmpAnt,; 			// EMPRESA
		cFilAnt,; 			// FILIAL
		SE1->E1_CLIENTE,;   // CLIENTE
		SE1->E1_LOJA,;   	// LOJA
		SE1->E1_NOMCLI,;  	// NOMECLI
		SE1->E1_PREFIXO,;   // PREFIXO
		SE1->E1_NUM,;  		// NUMERO
		SE1->E1_PARCELA,;	// PARCELA
		_dDtCred,;  		// DTPGTO
		_nValLiq,;  		// VLRPGTO
		_cFile,;			// ARQUIVO
		"Erro ao tentar realizar a baixa"}) // MSG

	Else
		AAdd(_aRet[_nTp], {"0",; 	// TIPO
		cEmpAnt,; 			// EMPRESA
		cFilAnt,; 			// FILIAL
		SE1->E1_CLIENTE,;   // CLIENTE
		SE1->E1_LOJA,;   	// LOJA
		SE1->E1_NOMCLI,;  	// NOMECLI
		SE1->E1_PREFIXO,;   // PREFIXO
		SE1->E1_NUM,;  		// NUMERO
		SE1->E1_PARCELA,;	// PARCELA
		_dDtCred,;  		// DTPGTO
		_nValLiq,;  		// VLRPGTO
		_cFile,;			// ARQUIVO
		"Baixa Realizada com sucesso"}) // MSG

	Endif

Return(Nil)




Static Function BRI119C()

	Local _oFwMsEx 		:= NIL
	Local _cArq 		:= ""
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

	For AX:= 1 To Len(_aRet)

		If !Empty(_aRet[AX])
		
			_lEnt    := .T.
			
			If AX = 1
				_cWorkSheet 	:= 	"Debito"
			Else
				_cWorkSheet 	:= 	"Credito"
			Endif

			_cTable 		:= 	"Acompanhamento Baixas EDI - REDE"

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

			For FX := 1 To Len(_aRet[AX])
				_oFwMsEx:AddRow( _cWorkSheet, _cTable,{;
				_aRet[AX][FX][02]		,; // EMPRESA
				_aRet[AX][FX][03]		,; // FILIAL
				_aRet[AX][FX][04]		,; // CLIENTE
				_aRet[AX][FX][05]		,; // LOJA
				_aRet[AX][FX][06]		,; // NOME DO CLIENTE
				_aRet[AX][FX][07]		,; // PREFIXO
				_aRet[AX][FX][08]		,; // NUMERO
				_aRet[AX][FX][09]		,; // PARCELA
				_aRet[AX][FX][10]		,; // DTPGTO
				_aRet[AX][FX][11]		,; // VLRPGTO
				_aRet[AX][FX][12]		,; // ARQUIVO
				_aRet[AX][FX][13]		}) // MSG
			Next FX
		Endif
		
		Sleep(1000) // 1 segundo
		
	Next Ax

	_oFwMsEx:Activate()

	_cDat1		:= GravaData(dDataBase,.f.,8)
	_cHor1		:= Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
	_cArq 		:= 'EDI_REDE_'+_cDat1+'_'+_cHor1 + ".xls"
	_cAnexo 	:= "\WORKFLOW\RELATORIOS\"+_cArq

	_oFwMsEx:GetXMLFile( _cAnexo )

	If _lEnt
		BRI119D() 	//Envia e-mail
	Endif

Return(Nil)



Static Function BRI119D()

	Local _cTo		:= SuperGetMV("BRI_MAILRE",,'alexandro.assystem@gmail.com')
//	Local _cTo		:= "fabiano@fasistec.com.br"
	Local _cCC		:= ""
	Local _oProcess    := TWFProcess():New( "EDI_REDE", "EDI_REDE" )

	_oProcess:NewTask( "EDI_REDE", "\WORKFLOW\BRI119.HTM" )
	_oProcess:bReturn  := ""
	_oProcess:bTimeOut := ""

	_oHTML             := _oProcess:oHTML
	_oProcess:cSubject := "EDI-REDE - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)
	_oProcess:fDesc    := "EDI REDE"

	_oProcess:AttachFile(_cAnexo)

	_oProcess:cTo := _cTo
	_oProcess:cCC := _cCC

	_oProcess:Start()

	_oProcess:Finish()

	//	FErase(_cAnexo)

Return(Nil)

