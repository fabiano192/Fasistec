#INCLUDE "TOTVS.ch"
#INCLUDE "TOPCONN.CH"

/*
Ponto de Entrada	:	MA410MNU
Autor				:
Data				:
Descrição			: Inserir Itens no Menu do pedido de Vendas - Ações Relacionadas.
*/
User Function MA410MNU()
	
	local _aAliOri:= Getarea()
	
	Local aRotina2  := { {"Peso Inicial"   ,"U_VN000201",0,2},;
		{"Imprimir Ticket","U_VN000204",0,2}}
	
	//		{"Peso Final"     ,"U_VN000203",0,2},;
		
	aAdd( aRotina, { OemToAnsi("Pesagem")  ,aRotina2,0,3,0 ,NIL} )
	
	aadd(aRotina,{"Desbloqueio"	,"U_PXH076()" , 0 , 4,0,NIL})
	
	Restarea(_aAliOri)
	
Return


/*
Ponto de Entrada	:	MSD2460
Autor				:
Data				:
Descrição			:
*/
User Function MSD2460()
	
	_aAliOri := GetArea()
	_aAliSZK := SZK->(GetArea())
	_aAliSD2 := SD2->(GetArea())
	
	SZK->(dbsetorder(1))
	If SZK->(dbseek(xFilial("SZK")+SD2->D2_PEDIDO+SD2->D2_ITEMPV))
		SZK->(Reclock("SZK",.F.))
		SZK->ZK_NOTA  := SD2->D2_DOC
		SZK->ZK_SERIE := SD2->D2_SERIE
		SZK->(MsUnLock())
	Endif
	
	RestArea(_aAliSZK)
	RestArea(_aAliSD2)
	RestArea(_aAliOri)
	
Return


/*
Ponto de Entrada	:	SF2460I
Autor				:	Fabiano da Silva
Data				:	16/08/16
Descrição			:	Gravar campos customizados
*/
User Function SF2460I()
	
	/*
	Chama a função PXH59GERA(), que se encontra no fonte PXH059.prw
	Parâmetros: Série, NF, Visualiza Doc, Cópia E-mail
	*/
	
	If Alltrim(SM0->M0_CODIGO) = '13' .And. Alltrim(SM0->M0_CODFIL) = '07701'
		_cSerie	:= SF2->F2_SERIE
		_cNF	:= SF2->F2_DOC
		_lView	:= .F.
		_cCC	:= ''
		U_PXH59GERA(_cSerie,_cNF,_lView,_cCC)
	Endif
	
Return()




/*
Programa  :	M460FIM
Descrição :	PONTO DE ENTRADA EXECUTADO APOS A GERACAO E GRAVACAO DO DOCUMENTO DE SAIDA (NF)
*/
USER FUNCTION M460Fim()
	
	LOCAL _cSerie  	:= SF2->F2_SERIE
	LOCAL _cNotaIni	:= SF2->F2_DOC
	LOCAL _cNotafim	:= SF2->F2_DOC
	Local _aNotas	:= {}
	
	_aAliOri := GetArea()
	_aAliSF2 := SF2->(GetArea())
	_aAliSD2 := SD2->(GetArea())
	
	_cHora   := Left(time(),5)
	_cMin    := Right(_cHora,2)
	
	If SM0->M0_ESTCOB $ "AC/AM/MT/MS/RO/RR"
		If _cHora   == "00"
			If SM0->M0_ESTCOB $ "AC"
				_cHora    := "22:" + _cMin // MENOS 02 HORAS
			Else
				_cHora    := "23:" + _cMin // MENOS 01 HORAS
			Endif
		Else
			_cHora := Strzero(Val(_cHora)-1,2) + ":" + _cMin
		Endif
	Endif
	
	If GETMV("MV_HVERAO")  /// SE VERDADEIRO ENTAO TEM HORARIO DE VERÃO
		If !SM0->M0_ESTCOB $ "DF/GO/ES/MT/MS/MG/PR/RJ/RS/SP/SC"   // ESTADOS QUE NAO TEM HORARIO
			If _cHora   == "00"
				_cHora  := "23:" + _cMin
			Else
				_cHora := Strzero(Val(_cHr)-1,2) + ":" + _cMin
			Endif
		Endif
	Endif
	
	_nFrete := 0
	_cTpCar := ''
	
	SD2->(dbsetorder(3))
	If SD2->(msSeek(xfilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE))
		SC5->(dbSetOrder(1))
		If SC5->(msSeek(xFilial("SC5")+SD2->D2_PEDIDO))
			_nFrete := SC5->C5_YFRETE
			_cTpCar := SC5->C5_YTPCAR
		Endif
	Endif
	
	SF2->(RecLock("SF2",.F.))
	SF2->F2_HORA   := _cHora
	SF2->F2_YFRETE := _nFrete
	SF2->F2_YTPCAR := _cTpCar
	SF2->(MsUnLock())
	
	aadd(_aNotas, _cNotaIni)
	If MsgYesNo("Deseja transmitir a Nota fiscal: "+_cNotaIni+" ?")
		//U_VN0006('TODAS',_cserie, _aNotas[1], _aNotas[len(_aNotas)] )
		U_VN0007(_cSerie,_aNotas[1])
	Endif
	
	RestArea(_aAliSD2)
	RestArea(_aAliSF2)
	RestArea(_aAliOri)
	
RETURN .T.


/*
Ponto de Entrada: MT415EFT
Autor			: Fabiano da Silva
Data			: 28/05/15
Uso				: Gerar o Prospect em Cliente na Efetivação do Orçamento.
Link TDN		: http://tdn.totvs.com/pages/releaseview.action?pageId=6784357
Descrição TDN	: EFETIVAÇÃO DO ORÇAMENTO, Validação da efetivação ou não do Orçamento em questão.
*/
User Function MT415EFT()
	
	_aAliOri := GetArea()
	_aAliSCJ := SCJ->(GetArea())
	_aAliSCK := SCK->(GetArea())
	
	If Empty(SCJ->CJ_PROSPE) .And. SCJ->CJ_CLIENTE = 'C000001'
		MsgAlert('Orçamento sem Cliente ou Prospect!')
		RestArea(_aAliSCK)
		RestArea(_aAliSCJ)
		RestArea(_aAliOri)
		Return(.F.)
	Endif
	
	_cTESDig := Space(3)
	
	_nValOrc := 0
	_cProdSCK:= ''
	
	SCK->(dbSetOrder(1))
	If SCK->(msSeek(xFilial('SCK')+SCJ->CJ_NUM))
		
		_cProdSCK:= SCK->CK_PRODUTO
		
		While SCK->(!EOF()) .And. SCK->CK_NUM == SCJ->CJ_NUM
			
			_cTES 		:= MaTesInt(2,"01",SCJ->CJ_CLIENTE,SCJ->CJ_LOJA,"C",SCK->CK_PRODUTO,Nil)
			
			If Empty(_cTes)
				
				_nOpca   := 0
				DEFINE MSDIALOG _oTES FROM 00, 00 TO 10,38 TITLE "TES Padrão"
				
				@ 01,01  TO 60,130 OF _oTES PIXEL
				
				@ 10,05  Say "Digite a TES padrão para o produto: "+SCK->CK_PRODUTO OF _oTES PIXEL
				
				@ 25,05  Say "TES: " 								OF _oTES PIXEL
				@ 25,30  MsGet _cTESDig   F3 "SF4" Size 030, 007 	OF _oTES PIXEL
				
				@ 40, 05 BUTTON "OK" 			SIZE 036,012 ACTION  (_nOpca:=1,_oTES:END()) OF _oTES PIXEL
				@ 40, 45 BUTTON "Sair"       	SIZE 036,012 ACTION  (_nOpca:=2,_oTES:END()) OF _oTES PIXEL
				
				ACTIVATE DIALOG _oTES CENTERED
				
				If _nOpca == 1
					If !Empty(_cTESDig) .And. _cTESDig > '499' .And. ExistCpo('SF4',_cTESDig)
						SFM->(RecLock('SFM',.T.))
						SFM->FM_FILIAL 	:= xFilial("SFM")
						SFM->FM_TIPO   	:= "01"
						SFM->FM_TS 		:= _cTESDig
						SFM->FM_CLIENTE := SCJ->CJ_CLIENTE
						SFM->FM_LOJACLI := SCJ->CJ_LOJA
						SFM->FM_PRODUTO := SCK->CK_PRODUTO
						SFM->(MsUnlock())
						
						SCK->(RecLock('SCK',.F.))
						//							SCK->CK_OPER 	:= "01
						SCK->CK_TES   	:= _cTESDig
						SCK->(MsUnlock())
						
					Else
						MSGAlert( "TES Incorreta" )
						Loop
					Endif
				ElseIf _nOpca == 2
					
					MsgAlert('Orçamento não Efetivado!')
					
					RestArea(_aAliSCK)
					RestArea(_aAliSCJ)
					RestArea(_aAliOri)
					Return (.F.)
				Else
					Loop
				Endif
			Endif
			
			_nValOrc += SCK->CK_VALOR
			
			SCK->(dbSkip())
		EndDo
	Endif
	
	If !Empty(SCJ->CJ_PROSPE)
		SUS->(dbSetOrder(1))
		If SUS->(msSeek(xFilial('SUS')+SCJ->CJ_PROSPE+SCJ->CJ_LOJPRO))
			
			If SUS->US_LC = 0
				MsgAlert('Prospect sem Limite de Crédito! Processo Cancelado!')
				RestArea(_aAliSCK)
				RestArea(_aAliSCJ)
				RestArea(_aAliOri)
				Return(.F.)
			Endif
			
			If SUS->US_STATUS != "6" .And. Empty(SUS->US_CODCLI)
				//Cria Cliente
				
				_aCod := U_RETCODLOJA(SUS->US_TIPO,SUS->US_CGC,"SA1",.T.)
				
				SA1->(RECLOCK('SA1',.T.))
				SA1->A1_FILIAL	:= xFilial("SA1")
				SA1->A1_COD		:= _aCod[1]
				SA1->A1_LOJA	:= _aCod[2]
				SA1->A1_NOME	:= SUS->US_NOME
				SA1->A1_NREDUZ	:= SUS->US_NREDUZ
				SA1->A1_TIPO	:= SUS->US_TIPO
				SA1->A1_END		:= SUS->US_END
				SA1->A1_EST		:= SUS->US_EST
				SA1->A1_COD_MUN	:= SUS->US_COD_MUN
				SA1->A1_MUN		:= SUS->US_MUN
				SA1->A1_BAIRRO	:= SUS->US_BAIRRO
				SA1->A1_CEP		:= SUS->US_CEP
				SA1->A1_DDI		:= SUS->US_DDI
				SA1->A1_DDD		:= SUS->US_DDD
				SA1->A1_TEL		:= SUS->US_TEL
				SA1->A1_CGC		:= SUS->US_CGC
				SA1->A1_INSCR	:= SUS->US_INSCR
				SA1->A1_INSCRM	:= SUS->US_INSCRM
				SA1->A1_EMAIL	:= SUS->US_EMAIL
				SA1->A1_CONTATO	:= SUS->US_CONTATO
				SA1->A1_PAIS	:= SUS->US_PAIS
				SA1->A1_NATUREZ	:= SUS->US_NATUREZ
				SA1->A1_COND	:= SUS->US_COND
				SA1->A1_LC		:= SUS->US_LC
				SA1->A1_VENCLC	:= SUS->US_VENCLC
				SA1->A1_MOEDALC	:= SUS->US_MOEDALC
				SA1->A1_RISCO	:= "D"
				SA1->A1_DTINIV	:= dDatabase
				SA1->(MsUnlock())
				
				SUS->(RecLock("SUS",.f.))
				SUS->US_STATUS  := "6"
				SUS->US_CODCLI  := SA1->A1_COD
				SUS->US_LOJACLI := SA1->A1_LOJA
				SUS->US_DTCONV  := dDatabase //database do sistema
				SUS->(MsUnlock())
				
				//Verifica banco de Conhecimento do Prospect
				AC9->(dbSetOrder(2))
				If AC9->(msSeek(xfilial('AC9')+'SUS'+SUS->US_FILIAL+SUS->US_COD+SUS->US_LOJA))
					AC9->(RecLock('AC9',.F.))
					AC9->AC9_ENTIDA := 'SA1'
					AC9->AC9_CODENT := SA1->A1_COD+SA1->A1_LOJA
					AC9->AC9_FILENT := ''
					AC9->(MsUnlock())
				Endif
				
				SCJ->(RecLock("SCJ",.F.))
				SCJ->CJ_CLIENTE  := SA1->A1_COD
				SCJ->CJ_LOJA     := SA1->A1_LOJA
				//				SCJ->CJ_NOMCLI   := SA1->A1_NOME
				SCJ->CJ_CLIENT   := SA1->A1_COD
				SCJ->CJ_LOJAENT  := SA1->A1_LOJA
				SCJ->(MsUnlock())
			Endif
		Endif
	Else
		
		SA1->(dbSetOrder(1))
		IF SA1->(msSeek(xFilial('SA1')+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA))
			
			_nOpEf   := 0
			
			Private _oEfet    := _oCodCli := _oNomCli := _oCodTra := _oNomTra := _oTpCar := _oNTpCar := _oVlFret := _oCombo := Nil
			Private _cCodCli  := SCJ->CJ_CLIENTE+'/'+SCJ->CJ_LOJA
			Private _cNomCli  := SA1->A1_NOME
			Private _cNomTra  := Space(TamSX3("A4_NOME")[1])
			Private _cNTpCar  := Space(TamSX3("X5_DESCRI")[1])
			Private _lWhen    := .T.
			Public _cPECombo  := ''
			Public _cPECodTra := Space(TamSX3("A4_COD")[1])
			Public _cPETpCar  := Space(TamSX3("ZL_TPCAR")[1])
			Public _nPEVlFret := 0
			
			_aCombo := {"C=CIF","F=FOB"}
			//			_aCombo := {"F=FOB","C=CIF","T=Por Conta Terceiros","S=Por Conta Cliente"}
			
			DEFINE MSDIALOG _oEfet FROM 00, 00 TO 220,440 TITLE "Dados Orçamento" Of _oEfet PIXEL Style DS_MODALFRAME
			
			_oEfet:lEscClose := .F.
			
			@ 005,005 TO 088,215 LABEL "" OF _oEfet PIXEL
			
			@ 07,010 Say "Preencha abaixo as informações necessárias para efetivação do Orçamento:" OF _oEfet PIXEL
			
			@ 20,010 Say "Tipo Frete:" OF _oEfet PIXEL
			@ 20,055 MSCOMBOBOX _oCombo VAR _cPECombo ITEMS _aCombo	Valid(CheckEfet("F"))			SIZE 050, 007 	OF _oEfet PIXEL
			
			@ 33,010 Say "Cliente: "																Size 050, 007 	OF _oEfet PIXEL
			@ 33,055 MsGet _oCodCli VAR _cCodCli   When .F.											Size 050, 007 	OF _oEfet PIXEL
			@ 33,110 MsGet _oNomCli VAR _cNomCli   When .F.											Size 100, 007 	OF _oEfet PIXEL
			
			@ 46,010 Say "Transportadora: "															Size 050, 007 	OF _oEfet PIXEL
			@ 46,055 MsGet _oCodTra VAR _cPECodTra When _lWhen F3 "SA4"	Valid(CheckEfet("T"))	Size 050, 007 	OF _oEfet PIXEL
			@ 46,110 MsGet _oNomTra VAR _cNomTra   When .F.											Size 100, 007 	OF _oEfet PIXEL
			
			@ 59,010 Say "Tipo Carro: "																Size 050, 007 	OF _oEfet PIXEL
			@ 59,055 MsGet _oTpCar  VAR _cPETpCar  When _lWhen  F3 "MU" 	Valid(CheckEfet("C"))	Size 050, 007 	OF _oEfet PIXEL
			@ 59,110 MsGet _oNTpCar VAR _cNTpCar   When .F.											Size 050, 007 	OF _oEfet PIXEL
			
			@ 72,010 Say "Valor Frete: "															Size 050, 007 	OF _oEfet PIXEL
			@ 72,055 MsGet _oVlFret VAR _nPEVlFret  When .F.		Picture "@e 9,999,999.999"		Size 050, 007 	OF _oEfet PIXEL
			
			@ 93,010 BUTTON "OK" 			SIZE 036,012 ACTION  ;
				(If((Left(_cPECombo,1) = 'F') .Or. (_nPEVlFret > 0 .And. Left(_cPECombo,1) = 'C'),(_nOpEf:=1,_oEfet:END()),;
				MsgAlert("Valor do Frete zerado, favor verificar a tabela de Frete!"))) OF _oEfet PIXEL
			//(If(_nPEVlFret > 0,(_nOpEf:=1,_oEfet:END()),;
				//	MsgAlert("Valor do Frete zerado, favor verificar a tabela de Frete!"))) OF _oEfet PIXEL
			
			@ 93,070 BUTTON "Cancelar"		SIZE 036,012 ACTION  (_nOpEf:=2,_oEfet:END()) OF _oEfet PIXEL
			
			ACTIVATE DIALOG _oEfet CENTERED
			
			If _nOpEf <> 1
				MsgAlert("Efetivação do Orçamento Cancelado")
				RestArea(_aAliSCK)
				RestArea(_aAliSCJ)
				RestArea(_aAliOri)
				Return(.F.)
			Endif
			
			If SA1->A1_RISCO == "D" .Or. SA1->A1_RISCO == "E"
				MsgAlert("Cliente com Risco de Crédito igual a 'D' ou 'E'."+CRLF+CRLF+;
					"Contate o setor Financeiro!")
				RestArea(_aAliSCK)
				RestArea(_aAliSCJ)
				RestArea(_aAliOri)
				Return(.F.)
			Endif
			
			ZA6->(dbSetOrder(1))
			If !ZA6->(dbSeek(xFilial("ZA6") + SA1->A1_COD + SA1->A1_LOJA + "L"))
				MsgAlert('Cliente sem Limite de Crédito cadastrado!'+CRLF+CRLF+;
					'Contate o setor Financeiro!')
				RestArea(_aAliSCK)
				RestArea(_aAliSCJ)
				RestArea(_aAliOri)
				Return(.F.)
			EndIf
			
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
					_dData    := _dData - 3	// Marcus Vinicius - 26/07/2016 - Alterado para validar os títulos vencidos na sexta-feira.
					_lFSemana := .T.
				Else
					_dData    := _dData -1
				Endif
				
				_lBloq := .F.
				
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
					//					_cQ := " SELECT C6_CLI,C6_LOJA,SUM(C6_VALOR) AS TOTAL "
					_cQ := " SELECT C6_CLI,C6_LOJA,SUM((C6_QTDVEN - C6_QTDENT) * C6_PRCVEN ) AS TOTAL "
					_cQ += " FROM "+RetSqlName("SC6")+" A WHERE A.D_E_L_E_T_ = '' AND C6_CLI = '"+SA1->A1_COD+"' "
					_cQ += " AND C6_LOJA = '"+SA1->A1_LOJA+"' AND C6_BLQ = '' "
					_cQ += " AND C6_QTDENT < C6_QTDVEN "
					_cQ += " GROUP BY C6_CLI,C6_LOJA "
					_cQ += " ORDER BY C6_CLI,C6_LOJA "
					
					TCQUERY _cQ NEW ALIAS "ZZ1"
					
					_nPedido := ZZ1->TOTAL
					
					ZZ1->(dbCloseArea())
					
					_nSdoTit := ZA6->ZA6_SDOTIT + _nPedido + _nValOrc
					_nDif    := ZA6->ZA6_VALOR - _nSdoTit
					
					If _nDif < 0
						_nDif := _nDif * -1
						
						_nPerc   := (_nDif / ZA6->ZA6_VALOR) * 100
						
						If _nPerc > GETMV("VN_PERLIM")
							MSGALERT("Limite de Credito Excedido Em "+STR(GETMV("VN_PERLIM"),2)+" % ")
							RestArea(_aAliSCK)
							RestArea(_aAliSCJ)
							RestArea(_aAliOri)
							Return(.F.)
							
						Endif
					Endif
				Else
					If Empty(SA1->A1_GRPVEN)
						MSGALERT("Cliente Com Titulo Vencido, Favor Verificar com Financeiro")
						RestArea(_aAliSCK)
						RestArea(_aAliSCJ)
						RestArea(_aAliOri)
						Return(.F.)
					Else
						MsgAlert("O Grupo tem Cliente(s) com titulo(s) vencido(s), favor verificar com Financeiro.")
						RestArea(_aAliSCK)
						RestArea(_aAliSCJ)
						RestArea(_aAliOri)
						Return(.F.)
						//						If MsgNoYes("O Grupo tem Cliente(s) com titulo(s) vencido(s), favor verificar com Financeiro."+CRLF+CRLF+;
							//				 			"Deseja visualizar quais os Clientes estão com títulos Vencidos?")
						//							U_MZ0191() //Gera tela com os Clientes do Grupo com títulos vencidos.
						
					Endif
				Endif
				
			Endif
			
		Endif
	Endif
	
	RestArea(_aAliSCK)
	RestArea(_aAliSCJ)
	RestArea(_aAliOri)
	
Return .T.


Static Function CheckEfet(_cOpc)
	
	Local _lRet := .T.
	
	If _cOpc $ ("T|C")
		
		If _cOpc = "T"
			
			If !Empty(_cPECodTra)
				SA4->(dbSetOrder(1))
				If SA4->(msSeek(xFilial("SA4")+_cPECodTra))
					_cNomTra := SA4->A4_NOME
				Else
					MsgAlert("Transportadora não encontrada!")
					_cNomTra := Space(TamSX3("A4_NOME")[1])
					_lRet := .F.
				Endif
			Endif
		ElseIf _cOpc = "C"
			If !Empty(_cPETpCar)
				SX5->(dbSetOrder(1))
				If SX5->(msSeek(xFilial("SX5")+"MU"+_cPETpCar))
					_cNTpCar := Alltrim(SX5->X5_DESCRI)
				Else
					MsgAlert("Tipo de Veículo não encontrado!")
					_cNTpCar := Space(TamSX3("X5_DESCRI")[1])
					_lRet := .F.
				Endif
			Endif
		Endif
		
		_cEst    := SA1->A1_EST
		_cCodMun := SA1->A1_COD_MUN
		
		If !Empty(SA1->A1_YUFENT) .And. !Empty(SA1->A1_YMUNENT)
			_cEst    := SA1->A1_YUFENT
			_cCodMun := SA1->A1_YMUNENT
		Endif
		
		_nPEVlFret := 0
		SZL->(dbSetOrder(1))
		If SZL->(msSeek(xFilial("SZL")+_cEst+_cCodMun+_cPETpCar+_cPECodTra+Left(_cProdSCK,4)))
			_nPEVlFret := SZL->ZL_VALFRET
		Else
			SZL->(dbSetOrder(1))
			If SZL->(msSeek(xFilial("SZL")+_cEst+_cCodMun+_cPETpCar+_cPECodTra))
				_nPEVlFret := SZL->ZL_VALFRET
			Endif
		Endif
		
	ElseIf _cOpc = "F"
		
		If Left(_cPECombo,1) = 'C'
			_lWhen := .T.
		Else
			_cPECodTra := Space(TamSX3("A4_COD")[1])
			_cNomTra   := Space(TamSX3("A4_NOME")[1])
			_cNTpCar   := Space(TamSX3("X5_DESCRI")[1])
			_cPETpCar  := Space(TamSX3("ZL_TPCAR")[1])
			_nPEVlFret := 0
			_lWhen     := .F.
		Endif
		
	Endif
	
	_oCodTra:Refresh()
	_oNomTra:Refresh()
	_oTpCar:Refresh()
	_oNTpCar:Refresh()
	_oVlFret:Refresh()
	
Return(_lRet)



/*
Ponto de Entrada: MA410COR
Autor			: Fabiano da Silva
Data			: 10/06/15
Uso				: Alterar cor da legenda no Pedido
Link TDN		: http://tdn.totvs.com/display/public/mp/MA410COR+-+Alterar+cores+do+cadastro+do+status+do+pedido
Descrição TDN	: Este ponto de entrada pertence à rotina de pedidos de venda, MATA410(). Usado, em conjunto com o ponto MA410LEG, para alterar cores do “browse” do cadastro, que representam o “status” do pedido.
*/
User Function MA410COR(aCores)
	
	Local aCores := ParamIXB
	
	aCores:={   { "C5_BLQ == '1'",'BR_AZUL'},;     					// Pedido Bloqueado por regra
	{ "C5_BLQ == '2'",'BR_LARANJA'},;    							// Pedido Bloqueado por verba
	{ "C5_BLQ == 'B'",'BR_PRETO'},;     							// Pedido Bloqueado por Diferença de Peso
	{'Empty(C5_LIBEROK) .and. Empty(C5_NOTA)','ENABLE'},;			// Pedido em Aberto
	{'!Empty(C5_NOTA) .or. C5_LIBEROK=="E"','DISABLE'},;			// Pedido Encerrado
	{'!Empty(C5_LIBEROK) .and. Empty(C5_NOTA)','BR_AMARELO'}}		// Pedido Liberado
	
Return(aCores)


/*
Ponto de Entrada: MA410LEG
Autor			: Fabiano da Silva
Data			: 10/06/15
Uso				: Alterar a legenda no Pedido
Link TDN		: http://tdn.totvs.com/display/public/mp/MA410LEG+-+Alterar+textos+da+legenda+de+status+do+pedido
Descrição TDN	: Este ponto de entrada pertence à rotina de pedidos de venda, MATA410(). Usado, em conjunto com o ponto MA410COR, para alterar os textos da legenda, que representam o “status” do pedido.
*/
User Function MA410LEG(aLegenda)
	
	aLegenda := { {'ENABLE'    	,"Pedido de Venda em aberto"},;
		{'DISABLE'   	,"Pedido de Venda encerrado"},;
		{'BR_AMARELO'	,"Pedido de Venda liberado" } ,;
		{'BR_AZUL'		,"Pedido de Venda com Bloqueio de Regra" } ,;
		{'BR_LARANJA'	,"Pedido de Venda com Bloqueio de Verba" } ,;
		{'BR_PRETO'		,"Pedido de Venda com Bloqueio por Diferença de Peso " } }
	
Return(aLegenda)


/*
Ponto de Entrada: MT410ACE
Autor			: Fabiano da Silva
Data			: 10/06/15
Uso				: Acesso à alteração do Pedido
Link TDN		: http://tdn.totvs.com/pages/releaseview.action?pageId=6784346
Descrição TDN	: Ponto de entrada 'MT410ACE' criado para verificar o acesso dos usuários nas rotinas: Excluir, Visualizar, Resíduo, Copiar e Alterar.
*/
User Function MT410ACE()
	
	Local lContinua := .T.
	Local nOpc  := PARAMIXB [1]
	
	_aAliOri := GetArea()
	_aAliSC5 := SC5->(GetArea())
	_aAliSC9 := SC9->(GetArea())
	
	IF nOpc == 1 // excluir
		//		IF cUsuario <> 'XXXXXX'
		//			lContinua := .F.
		//		EndIf
	ElseIf nOpc == 4 // Alterar
		If SC5->C5_BLQ = 'B'
			lContinua := .F.
			Alert('Pedido '+SC5->C5_NUM+' não pode ser alterado, pois está bloqueado por Diferença de Peso!')
		EndIf
		
		If lContinua
			SC9->(dbSetOrder(1))
			If SC9->(msSeek(xFilial('SC9')+SC5->C5_NUM))
				While SC9->(!EOF()) .And. SC9->C9_PEDIDO == SC5->C5_NUM
					If SC9->C9_BLCRED = '01'
						lContinua := .F.
						Alert('Pedido '+SC5->C5_NUM+' não pode ser alterado, pois existe um processo de análise de crédito em aberto!')
						Exit
					Endif
					SC9->(dbSkip())
				EndDo
			Endif
		Endif
		
	ElseIf nOpc == 2// visualizar ou residuo
		//		IF cUsuario <> 'XXXXXX'
		//			lContinua := .F.
		//		EndIf
	Endif
	
	RestArea(_aAliSC5)
	RestArea(_aAliSC9)
	RestArea(_aAliOri)
	
Return(lContinua)



/*
Ponto de Entrada: MT440AT
Autor			: Fabiano da Silva
Data			: 10/06/15
Uso				: Bloqueio à rotina de Liberação de Pedido
Link TDN		: http://tdn.totvs.com/pages/releaseview.action?pageId=6784362
Descrição TDN	: Este ponto de entrada é executado antes da visualização da liberação do pedido de venda e permite ao desenvolvedor impedir a utilização da rotina.
*/
USER FUNCTION MT440AT()
	
	_aAliOri := GetArea()
	_aAliSC9 := SC9->(GetArea())
	
	lContinua := .T.
	If SC5->C5_BLQ = 'B'
		lContinua := .F.
		Alert('Pedido '+SC5->C5_NUM+' não pode ser Liberado, pois está bloqueado por Diferença de Peso!')
	EndIf
	
	RestArea(_aAliSC9)
	RestArea(_aAliOri)
	
Return(lContinua)



/*
Ponto de Entrada: Ma440VLD
Autor			: Fabiano da Silva
Data			: 10/06/15
Uso				: Bloqueio à rotina de Liberação de Pedido pelo Botão Automático
Link TDN		: http://tdn.totvs.com/pages/releaseview.action?pageId=6784532
Descrição TDN	: O ponto de entrada Ma440VLD será executado na confirmação da liberação de um pedido de vendas e será utilizado para que o usuário possa realizar validações antes de efetuar a autorização de liberação.
*/
USER FUNCTION Ma440VLD()
	
	_aAliOri := GetArea()
	_aAliSC9 := SC9->(GetArea())
	
	lContinua := .T.
	If SC5->C5_BLQ = 'B'
		lContinua := .F.
		Alert('Pedido '+SC5->C5_NUM+' não pode ser Liberado, pois está bloqueado por Diferença de Peso!')
	EndIf
	
	RestArea(_aAliSC9)
	RestArea(_aAliOri)
	
Return(lContinua)



/*
Ponto de Entrada: MT410ALT
Autor			: Fabiano da Silva
Data			: 11/06/15
Uso				: E-mail análise de crédito
Link TDN		: http://tdn.totvs.com/display/public/mp/MT410ALT
Descrição TDN	: Este ponto de entrada pertence à rotina de pedidos de venda, MATA410(). Está localizado na rotina de alteração do pedido, A410ALTERA(). É executado após a gravação das alterações.
*/

USER FUNCTION MT410ALT()
	
	_aAliOri := GetArea()
	_aAliSC5 := SC5->(GetArea())
	_aAliSC6 := SC6->(GetArea())
	
	//U_PXH077()
	
	RestArea(_aAliSC6)
	RestArea(_aAliSC5)
	RestArea(_aAliOri)
	
Return(Nil)



/*
Ponto de Entrada: MT410INC
Autor			: Fabiano da Silva
Data			: 12/06/15
Uso				: E-mail análise de crédito
Link TDN		: http://tdn.totvs.com/display/public/mp/MT410INC
Descrição TDN	: Este ponto de entrada pertence à rotina de pedidos de venda, MATA410(). Está localizado na rotina de alteração do pedido, A410INCLUI(). É executado após a gravação das informações.
*/
USER FUNCTION MT410INC()
	
	_aAliOri := GetArea()
	_aAliSC5 := SC5->(GetArea())
	_aAliSC6 := SC6->(GetArea())
	
	//U_PXH077()
	
	_nProd    := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="C6_PRODUTO"})
	_nTes     := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="C6_TES"})
	
	_cProduto := aCols[n][_nProd]
	_cTES     := aCols[n][_nTES]
	
	SFM->(dbSetOrder(1))
	If SFM->(!dbSeek(xFilial("SFM") +"01" + _cProduto + SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
		SFM->(RecLock('SFM',.T.))
		SFM->FM_FILIAL 	:= xFilial("SFM")
		SFM->FM_TIPO   	:= "01"
		SFM->FM_TS 		:= _cTes
		SFM->FM_CLIENTE := SC5->C5_CLIENTE
		SFM->FM_LOJACLI := SC5->C5_LOJACLI
		SFM->FM_PRODUTO := _cProduto
		SFM->(MsUnlock())
	Endif
	
	RestArea(_aAliSC6)
	RestArea(_aAliSC5)
	RestArea(_aAliOri)
	
Return(Nil)



/*
Ponto de Entrada: M410lDel
Autor			: Fabiano da Silva
Data Criação	: 18/06/15
Descrição 		: Ponto de Entrada que permite adicionar validações para o tratamento de exclusão de um item do PV.
TDN				: http://tdn.totvs.com/pages/releaseview.action?pageId=6784565
*/
User Function M410lDel()
	
	Local _lRet := .T.
	
	_aAliOri := GetArea()
	_aAliSC5 := SC5->(GetArea())
	_aAliSC6 := SC6->(GetArea())
	
	_nPItem  	:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_ITEM"  	} )
	
	SC6->(dbSetOrder(1))
	If SC6->(msSeek(xFilial('SC6')+SC5->C5_NUM+aCols[n][_nPItem]))
		If !Empty(SC6->C6_NUMORC)
			MsgAlert("Este Item do Pedido de Vendas não poderá ser excluido, pois foi oriundo de um Orçamento!")
			_lRet := .F.
		Endif
	Endif
	
	RestArea(_aAliSC6)
	RestArea(_aAliSC5)
	RestArea(_aAliOri)
	
Return(_lRet)



/*
Ponto de Entrada: MTA416PV
Autor			: Fabiano da Silva
Data Criação	: 15/08/16
Descrição 		: APOS GERACAO DO ACOLS NA BAIXA ORCAMENTO
TDN				: http://tdn.totvs.com/pages/releaseview.action?pageId=6784395
*/
User Function MTA416PV()
	
	Local _nAux := PARAMIXB
	
	_aAliOri   := GetArea()
	_aAliSB1   := SB1->(GetArea())
	_aAliSC5   := SC5->(GetArea())
	_aAliSC6   := SC6->(GetArea())
	
	_nPProd    := aScan(_aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRODUTO" } )
	_nP2UM     := aScan(_aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_SEGUM" 	} )
	_nP2QUM    := aScan(_aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_UNSVEN" 	} )
	_nPQVEN    := aScan(_aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_QTDVEN" 	} )
	
	If !Empty(_aCols[_nAux][_nP2UM])
		dbSelectArea("SB1")
		SB1->(dbsetOrder(1))
		If SB1->(msSeek(xFilial("SB1")+_aCols[_nAux][_nPProd]))
			If SB1->B1_CONV > 0
				If SB1->B1_TIPCONV = 'M'
					_aCols[_nAux][_nP2QUM] := _aCols[_nAux][_nPQVEN] * SB1->B1_CONV
				ElseIf SB1->B1_TIPCONV = 'D'
					_aCols[_nAux][_nP2QUM] := _aCols[_nAux][_nPQVEN] / SB1->B1_CONV
				Endif
			Endif
		Endif
	Endif
	
	M->C5_YTPCAR 	:= _cPETpCar
	M->C5_YFRETE 	:= _nPEVlFret
	M->C5_FRETE		:= _nPEVlFret
	M->C5_TRANSP 	:= _cPECodTra
	M->C5_TPFRETE	:= Left(_cPECombo,1)
	
	_cPETpCar  := _cPECodTra := _cPECombo := ''
	_nPEVlFret := 0
	
	RestArea(_aAliSB1)
	RestArea(_aAliSC5)
	RestArea(_aAliSC6)
	RestArea(_aAliOri)
	
Return



/*
Ponto de Entrada: M440SC9I
Autor			: Fabiano da Silva
Data Criação	: 11/08/16
Descrição 		: Gravação de campos na tabela SC9
TDN				: http://tdn.totvs.com/pages/releaseview.action?pageId=6784165
*/
User Function M440SC9I()
	
	_aAliOri := GetArea()
	_aAliSC9 := SC9->(GetArea())
	_aAliSC5 := SC5->(GetArea())
	
	SC5->(dbsetOrder(1))
	If SC5->(msSeek(xFilial("SC5")+SC9->C9_PEDIDO)) .And. Alltrim(Upper(FunName())) != 'VN020C'
		If SC5->C5_TIPO = 'N'
			SC9->(RecLock("SC9",.F.))
			SC9->C9_BLCRED := "01"
			SC9->(MsUnlock())
		Endif
	Endif
	
	RestArea(_aAliSC5)
	RestArea(_aAliSC9)
	RestArea(_aAliOri)
	
Return(Nil)



/*
Ponto de Entrada: MTA410
Autor			: Fabiano da Silva
Data Criação	: 16/08/16
Descrição 		: Validação do Pedido de Vendas
TDN				: http://tdn.totvs.com/pages/releaseview.action;jsessionid=E20358E860B9FC8A8728B9D8E2FDA4CA?pageId=6784388
*/
User Function MTA410()
	
	_aAliOri := GetArea()
	_aAliSC6 := SC6->(GetArea())
	_aAliSC5 := SC5->(GetArea())
	
	_lRet := .T.
	
	_nPItem		:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_ITEM"  	} )
	_nPProd		:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRODUTO"	} )
	_nPUM		:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_UM"  	} )
	_nPPrcV		:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRCVEN" 	} )
	_nPQtdV		:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_QTDVEN"	} )
	_nPValo		:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_VALOR"	} )
	_nPTES		:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_TES"		} )
	_nPGeOC		:= Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_YGERAOC"	} )
	
	If M->C5_TIPO = 'N'
		
		
		_nValPed := 0
		For F:= 1 To Len(aCols)
			
			If !aCols[F][Len(aHeader)+1]
				
				_cTes       := aCols[F][_nPTES]
				
				SF4->(dbSetOrder(1))
				SF4->(msSeek(xFilial("SF4")+_cTes))
				
				If SF4->F4_DUPLIC = 'S'
					_nValPed += aCols[F][_nPValo]
				Endif
			Endif
			
		Next F
		
		SA1->(dbSetOrder(1))
		SA1->(msSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))
		
		If SA1->A1_RISCO == "D" .Or. SA1->A1_RISCO == "E"
			MsgAlert("Cliente com Risco de Crédito igual a 'D' ou 'E'."+CRLF+CRLF+;
				"Contate o setor Financeiro!")
			RestArea(_aAliSC5)
			RestArea(_aAliSC6)
			RestArea(_aAliOri)
			Return(.F.)
		Endif
		
		ZA6->(dbSetOrder(1))
		If !ZA6->(dbSeek(xFilial("ZA6") + SA1->A1_COD + SA1->A1_LOJA + "L"))
			MsgAlert('Cliente sem Limite de Crédito cadastrado!'+CRLF+CRLF+;
				'Contate o setor Financeiro!')
			RestArea(_aAliSC5)
			RestArea(_aAliSC6)
			RestArea(_aAliOri)
			Return(.F.)
		EndIf
		
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
				_dData    := _dData - 3	// Marcus Vinicius - 26/07/2016 - Alterado para validar os títulos vencidos na sexta-feira.
				_lFSemana := .T.
			Else
				_dData    := _dData -1
			Endif
			
			_lBloq := .F.
			
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
				//					_cQ := " SELECT C6_CLI,C6_LOJA,SUM(C6_VALOR) AS TOTAL "
				_cQ := " SELECT C6_CLI,C6_LOJA,SUM((C6_QTDVEN - C6_QTDENT) * C6_PRCVEN ) AS TOTAL "
				_cQ += " FROM "+RetSqlName("SC6")+" A WHERE A.D_E_L_E_T_ = '' AND C6_CLI = '"+SA1->A1_COD+"' "
				_cQ += " AND C6_LOJA = '"+SA1->A1_LOJA+"' AND C6_BLQ = '' "
				_cQ += " AND C6_QTDENT < C6_QTDVEN "
				_cQ += " AND C6_NUM <> '"+M->C5_NUM+"' "
				_cQ += " GROUP BY C6_CLI,C6_LOJA "
				_cQ += " ORDER BY C6_CLI,C6_LOJA "
				
				TCQUERY _cQ NEW ALIAS "ZZ1"
				
				_nPedido := ZZ1->TOTAL
				
				ZZ1->(dbCloseArea())
				
				_nSdoTit := ZA6->ZA6_SDOTIT + _nPedido + _nValPed
				_nDif    := ZA6->ZA6_VALOR - _nSdoTit
				
				If _nDif < 0
					_nDif := _nDif * -1
					
					_nPerc   := (_nDif / ZA6->ZA6_VALOR) * 100
					
					If _nPerc > GETMV("VN_PERLIM")
						MSGALERT("Limite de Credito Excedido Em "+STR(GETMV("VN_PERLIM"),2)+" % ")
						RestArea(_aAliSC5)
						RestArea(_aAliSC6)
						RestArea(_aAliOri)
						Return(.F.)
						
					Endif
				Endif
			Else
				If Empty(SA1->A1_GRPVEN)
					MSGALERT("Cliente Com Titulo Vencido, Favor Verificar com Financeiro")
					RestArea(_aAliSC5)
					RestArea(_aAliSC6)
					RestArea(_aAliOri)
					Return(.F.)
				Else
					MsgAlert("O Grupo tem Cliente(s) com titulo(s) vencido(s), favor verificar com Financeiro.")
					RestArea(_aAliSC5)
					RestArea(_aAliSC6)
					RestArea(_aAliOri)
					Return(.F.)
					//						If MsgNoYes("O Grupo tem Cliente(s) com titulo(s) vencido(s), favor verificar com Financeiro."+CRLF+CRLF+;
						//				 			"Deseja visualizar quais os Clientes estão com títulos Vencidos?")
					//							U_MZ0191() //Gera tela com os Clientes do Grupo com títulos vencidos.
					
				Endif
			Endif
			
		Endif
	Endif
	
	RestArea(_aAliSC5)
	RestArea(_aAliSC6)
	RestArea(_aAliOri)
	
Return(_lRet)

