#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa TOPOR02
Autor 		: Fabiano da Silva	-	25/03/20
Descri��o 	: Exportar tabelas RM
*/

USER FUNCTION IMPRM()

	Local _oDlg			:= NIL
	Local _nOpc			:= 0

	Private _cTitulo	:= "Exportar tabelas do RM"
	Private _oProcess	:= Nil

	Private _cProc		:= 'Processando'
	Private _cMsgTit	:= 'Aguarde, gerando dados...'
	Private _cPasta		:= dtos(dDataBase)+'_'+StrTran(Time(),":","")

	Private _oFont11N	:= TFont():New('Arial'	,,-11,,.T.,,,,,.F.,.F.)

	Private _cChave		:= ''

	DEFINE MSDIALOG _oDlg FROM 0,0 TO 120,320 TITLE _cTitulo OF _oDlg PIXEL

	_oGrupo	:= TGroup():New(005,005,035,155,"",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 010,015 SAY _oTSayA VAR "Esta rotina tem por objetivo exportar as tabelas  "	OF _oGrupo PIXEL Size 150,010 FONT _oFont11N
	@ 020,015 SAY 'do Banco de Dados "DADOSRM" '		    						OF _oGrupo PIXEL Size 150,010 FONT _oFont11N

	// _oTBut1	:= TButton():New( 60,010, "Par�metros" ,_oDlg,{||Pergunte("TOPO02")},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )

	TButton():New( 40,068, "OK" ,_oDlg,{||_nOpc := 1,_oDlg:End()},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )

	TButton():New( 40,120, "Sair" ,_oDlg,{||_nOpc := 0,_oDlg:End()},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )


	ACTIVATE MSDIALOG _oDlg CENTERED

	If _nOpc = 1
		// LjMsgRun(_cMsgTit,_cProc,{||EXPDADOS()})
		_oProcess := MsNewProcess():New( { || EXPDADOS() } , _cMsgTit, _cProc , .F. )
		_oProcess:Activate()

		MsgInfo("Finalizado o processo de Exporta��o das tabelas do banco de dados DADOSRM")
	Endif

Return(Nil)




Static Function EXPDADOS()

	Local _aTabelas := {'SE4'}
	// Local _aTabelas := {'CT1','CT2','SA1','SA2','SB1','CTT','SE4'}
	Local _nTab		:= 0
	Local _cQry		:= ''
	Local _nReg		:= 0
	Local _cTab		:= ''
	Local _aEmp		:= GetEmp()
	Local _nH		:= 0
	Local _nTRM		:= 0

	_oProcess:SetRegua1(Len(_aTabelas)) //Alimenta a primeira barra de progresso
	_oProcess:IncRegua1("Tabelas RM")

	For _nTab := 1 to Len(_aTabelas)

		_cTab := _aTabelas[_nTab]

		If _cTab = 'CT1'

			If Select("TCONTA") > 0
				TCONTA->(dbCloseArea())
			Endif

			_cQry := " SELECT * FROM DADOSRM..CCONTA " +CRLF
			_cQry += " WHERE CODCOLIGADA = '0' " +CRLF
			_cQry += " ORDER BY CODCONTA " +CRLF

			TcQuery _cQry New Alias "TCONTA"

			_nReg := Contar("TCONTA","!EOF()")

			If _nReg > 0

				If CriarDTC(_cTab)

					_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

					_nRegAtu := 0

					TCONTA->(dbGoTop())

					While TCONTA->(!EOF())

						_nRegAtu ++

						_oProcess:IncRegua2("Gerando tabela "+_cTab)
						// _oProcess:IncRegua2("Gerando tabela "+_cTab+" - Registro "+Alltrim(str(_nRegAtu))+" de "+Alltrim(str(_nReg)))

						TRM->(RecLock("TRM",.T.))
						// TRM->CT1_FILIAL :=
						TRM->CT1_CLASSE := If(TCONTA->ANALITICA=0,'1','2')
						TRM->CT1_CONTA  := Alltrim(StrTran(TCONTA->CODCONTA,".",""))
						TRM->CT1_DESC01 := Alltrim(TCONTA->DESCRICAO)
						TRM->CT1_NORMAL := "2"
						TRM->CT1_RES    := TCONTA->REDUZIDO
						TRM->CT1_BLOQ   := If(TCONTA->INATIVA=0,'2','1')
						TRM->CT1_NTSPED := TCONTA->NATSPED
						// TRM->CT1_DC     :=
						TRM->CT1_CVD02  := "1"
						TRM->CT1_CVD03  := "1"
						TRM->CT1_CVD04  := "1"
						TRM->CT1_CVD05  := "1"
						TRM->CT1_CVC02  := "1"
						TRM->CT1_CVC03  := "1"
						TRM->CT1_CVC04  := "1"
						TRM->CT1_CVC05  := "1"
						// TRM->CT1_CTASUP :=
						TRM->CT1_DTEXIS := CTOD('25/03/2020')
						TRM->CT1_AGLSLD := "2"
						TRM->CT1_CCOBRG := "2"
						TRM->CT1_ITOBRG := "2"
						TRM->CT1_CLOBRG := "2"
						// TRM->CT1_CTLALU :=
						TRM->CT1_LALHIR := "2"
						// TRM->CT1_NATCTA :=
						TRM->CT1_ACATIV := "2"
						TRM->CT1_ATOBRG := "2"
						TRM->CT1_ACET05 := "2"
						TRM->CT1_05OBRG := "2"
						TRM->CT1_SPEDST := "2"
						TRM->CT1_ACITEM := "1"
						TRM->CT1_ACCUST := "1"
						TRM->CT1_ACCLVL := "1"
						TRM->(MsUnLock())

						// _oProcess:IncRegua2("Gerando tabela "+_cTab)

						TCONTA->(dbSkip())
					EndDo

				Endif
			Endif

			TCONTA->(dbCloseArea())

		ElseIf _cTab = 'CT2'

			If Select("TCONTA") > 0
				TCONTA->(dbCloseArea())
			Endif

			_cQry := " SELECT A.CODCOLIGADA,CODFILIAL,A.CODLOTEORIGEM,DOCUMENTO,DATA,DEBITO,CREDITO,PARTIDA,A.CODCCUSTO,A.CODHISTP,B.DESCRICAO,COMPLEMENTO,VALOR " +CRLF
			_cQry += " FROM DADOSRM..CPARTIDA A " +CRLF
			_cQry += " LEFT JOIN DADOSRM..CHISTP B ON A.CODCOLIGADA = B.CODCOLIGADA AND A.CODHISTP = B.CODHISTP " +CRLF
			_cQry += " INNER JOIN DADOSRM..CLANCAMENTO C ON A.CODCOLIGADA = C.CODCOLIGADA AND A.CODLOTE = C.CODLOTE AND A.IDLANCAMENTO = C.IDLANCAMENTO " +CRLF
			_cQry += " WHERE DATA >= '2020' " +CRLF
			_cQry += " AND RTRIM(A.CODCOLIGADA)+RTRIM(CODFILIAL) IN ('91','93','101','103','104','111','113') " +CRLF
			_cQry += " ORDER BY CODCOLIGADA, CODFILIAL,DATA " +CRLF

			TcQuery _cQry New Alias "TCONTA"

			_nReg := Contar("TCONTA","!EOF()")

			If _nReg > 0

				_oProcess:IncRegua1("Tabelas RM")
				_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

				_nRegAtu := 0

				TCONTA->(dbGoTop())

				While TCONTA->(!EOF())

					_cKey1 := Alltrim(cValToChar(TCONTA->CODCOLIGADA))

					If CriarDTC(_cTab,_cKey1)

						While TCONTA->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TCONTA->CODCOLIGADA))

							_cKey2 := _cKey1 + dtos(TCONTA->DATA)

							While TCONTA->(!EOF()) .And. _cKey2 == Alltrim(cValToChar(TCONTA->CODCOLIGADA)) + dtos(TCONTA->DATA)

								_cKey3 := _cKey2 + Alltrim(cValtoChar(TCONTA->CODLOTEORIGEM))
								_cLinha:= "000"

								While TCONTA->(!EOF()) .And. _cKey3 == Alltrim(cValToChar(TCONTA->CODCOLIGADA)) + dtos(TCONTA->DATA) + Alltrim(cValtoChar(TCONTA->CODLOTEORIGEM))

									_cHist   := ALLTRIM(UPPER(TCONTA->DESCRICAO)) + ' - '+ALLTRIM(UPPER(TCONTA->COMPLEMENTO))
									_nCount  := 1
									_nQtdCar := TamSX3("CT2_HIST")[1]
									_nQtLine := MlCount(alltrim(_cHist),_nQtdCar)
									_nRegAtu ++

									_oProcess:IncRegua2("Gerando tabela "+_cTab)
									// _oProcess:IncRegua2("Gerando tabela "+_cTab+" - Registro "+Alltrim(str(_nRegAtu))+" de "+Alltrim(str(_nReg)))

									For _nH := 1 to _nQtLine

										_cHistor := MemoLine(Alltrim(_cHist),_nQtdCar,_nH)
										_cLinha  := Soma1(_cLinha)

										If _nH = 1

											If !Empty(TCONTA->DEBITO) .And. Empty(TCONTA->CREDITO)
												_cDC := "1"
											ElseIf Empty(TCONTA->DEBITO) .And. !Empty(TCONTA->CREDITO)
												_cDC := "2"
											Else
												_cDC := "3"
											Endif

											TRM->(RecLock("TRM",.T.))
											TRM->CT2_FILIAL := Alltrim(cValtoChar(TCONTA->CODFILIAL))
											TRM->CT2_DATA   := TCONTA->DATA
											TRM->CT2_LOTE   := PADL(Alltrim(cValtoChar(TCONTA->CODLOTEORIGEM)),6,"0")
											TRM->CT2_SBLOTE := "001"
											TRM->CT2_DOC    := TCONTA->DOCUMENTO
											TRM->CT2_LINHA  := _cLinha
											TRM->CT2_MOEDLC := "01"
											TRM->CT2_DC     := _cDC
											TRM->CT2_DEBITO := STRTRAN(TCONTA->DEBITO,".","")
											TRM->CT2_CREDIT := STRTRAN(TCONTA->CREDITO,".","")
											// TRM->CT2_DCD    :=
											// TRM->CT2_DCC    :=
											TRM->CT2_VALOR  := TCONTA->VALOR
											TRM->CT2_HIST   := NoAcento(_cHistor)
											// TRM->CT2_EMPORI :=
											// TRM->CT2_FILORI :=
											TRM->CT2_TPSALD := "1"
											TRM->CT2_MANUAL := "1"
											// TRM->CT2_SEQUEN :=
											// TRM->CT2_ORIGEM :=
											// TRM->CT2_ROTINA :=
											TRM->CT2_AGLUT  := "2"
											// TRM->CT2_LP :=
											TRM->CT2_SEQHIS := "001"
											// TRM->CT2_SEQLAN :=
											TRM->CT2_CRCONV := "1"
											TRM->CT2_DTCV3  := dDataBase
											TRM->(MsUnLock())
										Else
											TRM->(RecLock("TRM",.T.))
											TRM->CT2_FILIAL := Alltrim(cValtoChar(TCONTA->CODFILIAL))
											TRM->CT2_DATA   := TCONTA->DATA
											TRM->CT2_LOTE   := PADL(Alltrim(cValtoChar(TCONTA->CODLOTEORIGEM)),6,"0")
											TRM->CT2_SBLOTE := "001"
											TRM->CT2_DOC    := TCONTA->DOCUMENTO
											TRM->CT2_LINHA  := _cLinha
											TRM->CT2_MOEDLC := "01"
											TRM->CT2_DC     := "4"
											TRM->CT2_HIST   := NoAcento(_cHistor)
											TRM->CT2_TPSALD := "1"
											TRM->CT2_MANUAL := "1"
											TRM->CT2_AGLUT  := "2"
											TRM->CT2_SEQHIS := PADL(ALLTRIM(CVALTOCHAR(_nH)),3,"0")
											TRM->(MsUnLock())
										Endif
									Next _nH

									TCONTA->(dbSkip())
								EndDo
							EndDo
						EndDo
					Endif
				EndDo
			Endif
		ElseIf _cTab = "SA1"

			If Select("TCLI") > 0
				TCLI->(dbCloseArea())
			Endif

			_cQry := " SELECT CODCOLIGADA AS 'EMP',* FROM DADOSRM..FCFO " + CRLF
			// _cQry += " WHERE PAGREC = 3 " + CRLF
			_cQry += " WHERE PAGREC <> 2 " + CRLF
			_cQry += " AND RTRIM(CODCOLIGADA) IN  ('0','9','10','11') " + CRLF
			_cQry += " AND CGCCFO IS NOT NULL " + CRLF
			// _cQry += " AND (CGCCFO <> '' OR CODCFO = 'F00226') " + CRLF
			_cQry += " AND CGCCFO <> '' " + CRLF
			// _cQry += " AND CGCCFO > '9'" + CRLF
			_cQry += " ORDER BY EMP,CGCCFO " + CRLF

			TcQuery _cQry New Alias "TCLI"

			_nReg := Contar("TCLI","!EOF()")

			If _nReg > 0

				_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

				_nRegAtu := 0

				TCLI->(dbGoTop())

				While TCLI->(!EOF())

					_nCod    := 0
					_cKey1   := Alltrim(cValToChar(TCLI->EMP))

					If CriarDTC(_cTab,_cKey1)

						While TCLI->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TCLI->EMP))

							// _cCGC := StrTran(StrTran(StrTran(TCLI->CGCCFO,".",""),"-",""),"/","")

							If TCLI->PESSOAFISOUJUR = 'J'
								_cKey2 := _cKey1 + Left(StrTran(StrTran(StrTran(TCLI->CGCCFO,".",""),"-",""),"/",""),8)
								_cChave := '_cKey2 = Alltrim(cValToChar(TCLI->EMP)) + Left(StrTran(StrTran(StrTran(TCLI->CGCCFO,".",""),"-",""),"/",""),8)'
							Else
								_cKey2 := _cKey1 + StrTran(StrTran(StrTran(TCLI->CGCCFO,".",""),"-",""),"/","")
								_cChave := '_cKey2 = Alltrim(cValToChar(TCLI->EMP)) + StrTran(StrTran(StrTran(TCLI->CGCCFO,".",""),"-",""),"/","")'
							Endif

							_cLoja := "00"
							_nCod  ++
							_cCod  :="C"+PadL(Alltrim(Str(_nCod)),5,"0")

							While TCLI->(!EOF()) .And. &(_cChave)

								_nRegAtu ++

								_oProcess:IncRegua2("Gerando tabela "+_cTab)
								// _oProcess:IncRegua2("Gerando tabela "+_cTab+" - Registro "+Alltrim(str(_nRegAtu))+" de "+Alltrim(str(_nReg)))

								_cLoja := Soma1(_cLoja)
								_cCNPJ := Alltrim(StrTran(StrTran(StrTran(TCLI->CGCCFO,".",""),"-",""),"/",""))
								_cFil  := Space(TAMSX3("A1_FILIAL")[1])

								If !TRM->(MsSeek(_cFil+_cCNPJ))

									TRM->(RecLock("TRM",.T.))
									TRM->A1_FILIAL  := _cFil
									TRM->A1_YCODRM  := TCLI->CODCFO
									TRM->A1_COD     := _cCod
									TRM->A1_LOJA    := _cLoja
									TRM->A1_PESSOA  := TCLI->PESSOAFISOUJUR
									TRM->A1_NOME    := UPPER(NOACENTO(TCLI->NOME))
									TRM->A1_NREDUZ  := UPPER(NOACENTO(TCLI->NOMEFANTASIA))
									TRM->A1_END     := UPPER(NOACENTO(Alltrim(TCLI->RUA)))+" "+UPPER(NOACENTO(ALLTRIM(TCLI->NUMERO)))
									TRM->A1_COMPLEM := UPPER(NOACENTO(Alltrim(TCLI->COMPLEMENTO)))
									// TRM->A1_TIPO    := TCLI-> ????
									TRM->A1_EST     := TCLI->CODETD
									TRM->A1_COD_MUN := TCLI->CODMUNICIPIO
									TRM->A1_MUN     := UPPER(NOACENTO(Alltrim(TCLI->CIDADE)))
									TRM->A1_BAIRRO  := UPPER(NOACENTO(Alltrim(TCLI->BAIRRO)))
									// TRM->A1_NATUREZ := TCLI->
									TRM->A1_CEP     := TCLI->CEP
									// TRM->A1_DDD     := TCLI->
									TRM->A1_TEL     := TCLI->TELEFONE
									TRM->A1_PAIS    := "105"
									TRM->A1_CGC     := _cCNPJ
									TRM->A1_CONTATO := TCLI->CONTATO
									TRM->A1_INSCR   := TCLI->INSCRESTADUAL
									TRM->A1_CODPAIS := "01058"
									TRM->A1_SATIV1  := "1"
									TRM->A1_SATIV2  := "1"
									TRM->A1_SATIV3  := "1"
									TRM->A1_SATIV4  := "1"
									TRM->A1_SATIV5  := "1"
									TRM->A1_SATIV6  := "1"
									TRM->A1_SATIV7  := "1"
									TRM->A1_SATIV8  := "1"
									TRM->A1_EMAIL   := TCLI->EMAIL
									TRM->A1_MSBLQL  := If(TCLI->ATIVO=1,"2","1")
									TRM->A1_LC      := TCLI->LIMITECREDITO
									TRM->A1_INSCRM  := TCLI->INSCRMUNICIPAL
									TRM->A1_CONTRIB  := If(TCLI->CONTRIBUINTE=1,"2","1")
									TRM->(MsUnLock())
								Endif

								// _oProcess:IncRegua2("Gerando tabela "+_cTab)

								TCLI->(dbSkip())
							EndDo
						EndDo

						If _cKey1 <> '0'
							_cArq1	:= "\TAB_RM\"+_cPasta+"\SA10.dtc"	//Gera o nome do arquivo
							_cInd1	:= "\TAB_RM\"+_cPasta+"\SA10"		//Indice do arquivo

							If SELECT("TRM2") > 0
								TRM2->(dbCloseArea())
							Endif

							dbUseArea( .T.,"CTREECDX", _cArq1,"TRM2", .T., .F. )
							dbSelectArea("TRM2")

							IndRegua( "TRM2", _cInd1, SA1->(IndexKey(3)))

							dbClearIndex()
							dbSetIndex(_cInd1 + OrdBagExt() )

							TRM2->(dbSetOrder(1))
							TRM2->(dbGoTop())

							While TRM2->(!EOF())

								If !TRM->(MsSeek(TRM2->A1_FILIAL+TRM2->A1_CGC))

									If !TRM->(MsSeek(TRM2->A1_FILIAL+Left(TRM2->A1_CGC,8)))
										_cLoja := "01"
										_nCod  ++
										_cCod  :="C"+PadL(Alltrim(Str(_nCod)),5,"0")
									ELSE
										_cCod  := TRM->A1_COD
										_cSeek := TRM->A1_FILIAL+Left(TRM->A1_CGC,8)
										_cLoja := "00"

										While TRM->(!EOF()) .And. _cSeek == TRM->A1_FILIAL+Left(TRM->A1_CGC,8)

											_cLoja := If( TRM->A1_LOJA > _cLoja,TRM->A1_LOJA,_cLoja )

											TRM->(dbSkip())
										EndDo

										_cLoja := SOMA1(_cLoja)

									Endif

									TRM->(RecLock("TRM",.T.))
									For _nTRM := 1 to TRM->(FCOUNT())
										If TRM->(FIELD(_nTRM)) = "A1_COD"
											TRM->A1_COD := _cCod
										ElseIf TRM->(FIELD(_nTRM)) = "A1_LOJA"
											TRM->A1_LOJA := _cLoja
										Else
											&("TRM->"+(TRM->(FIELD(_nTRM)))) := &("TRM2->"+(TRM2->(FIELD(_nTRM))))
										Endif
									Next _nTRM

									TRM->(MsUnLock())
								Endif

								TRM2->(dbSkip())
							EndDo

							TRM2->(dbCloseArea())

						Endif
					Endif
				EndDo

			Endif

			TCLI->(dbCloseArea())

		ElseIf _cTab = 'SA2'

			If Select("TFOR") > 0
				TFOR->(dbCloseArea())
			Endif

			_cQry := " SELECT CODCOLIGADA AS 'EMP',* FROM DADOSRM..FCFO " + CRLF
			// _cQry += " WHERE PAGREC = 3 " + CRLF
			_cQry += " WHERE PAGREC <> 1 " + CRLF
			_cQry += " AND RTRIM(CODCOLIGADA) IN  ('0','9','10','11') " + CRLF
			_cQry += " AND CGCCFO IS NOT NULL " + CRLF
			_cQry += " AND CGCCFO <> '' " + CRLF
			// _cQry += " AND (CGCCFO <> '' OR CO1DCFO = 'F00226') " + CRLF
			_cQry += " ORDER BY EMP,CGCCFO " + CRLF

			TcQuery _cQry New Alias "TFOR"

			_nReg := Contar("TFOR","!EOF()")

			If _nReg > 0

				_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

				_nRegAtu := 0

				TFOR->(dbGoTop())

				While TFOR->(!EOF())

					_nCod    := 0
					_cKey1   := Alltrim(cValToChar(TFOR->EMP))

					If CriarDTC(_cTab,_cKey1)

						While TFOR->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TFOR->EMP))

							If TFOR->PESSOAFISOUJUR = 'J'
								_cKey2 := _cKey1 + Left(StrTran(StrTran(StrTran(TFOR->CGCCFO,".",""),"-",""),"/",""),8)
								_cChave := '_cKey2 = Alltrim(cValToChar(TFOR->EMP)) + Left(StrTran(StrTran(StrTran(TFOR->CGCCFO,".",""),"-",""),"/",""),8)'
							Else
								_cKey2 := _cKey1 + StrTran(StrTran(StrTran(TFOR->CGCCFO,".",""),"-",""),"/","")
								_cChave := '_cKey2 = Alltrim(cValToChar(TFOR->EMP)) + StrTran(StrTran(StrTran(TFOR->CGCCFO,".",""),"-",""),"/","")'
							Endif

							_cLoja := "00"
							_nCod  ++
							_cCod  :="F"+PadL(Alltrim(Str(_nCod)),5,"0")

							While TFOR->(!EOF()) .And. &(_cChave)

								_nRegAtu ++

								_oProcess:IncRegua2("Gerando tabela "+_cTab)
								// _oProcess:IncRegua2("Gerando tabela "+_cTab+" - Registro "+Alltrim(str(_nRegAtu))+" de "+Alltrim(str(_nReg)))

								_cLoja := Soma1(_cLoja)
								_cCNPJ := Alltrim(StrTran(StrTran(StrTran(TFOR->CGCCFO,".",""),"-",""),"/",""))
								_cFil  := Space(TAMSX3("A2_FILIAL")[1])

								If !TRM->(MsSeek(_cFil+_cCNPJ))

									TRM->(RecLock("TRM",.T.))
									TRM->A2_FILIAL  := _cFil
									TRM->A2_YCODRM  := TFOR->CODCFO
									TRM->A2_COD     := _cCod
									TRM->A2_LOJA    := _cLoja
									TRM->A2_NOME    := UPPER(NOACENTO(TFOR->NOME))
									TRM->A2_NREDUZ  := UPPER(NOACENTO(TFOR->NOMEFANTASIA))
									TRM->A2_END     := UPPER(NOACENTO(Alltrim(TFOR->RUA)))+" "+UPPER(NOACENTO(ALLTRIM(TFOR->NUMERO)))
									TRM->A2_COMPLEM := UPPER(NOACENTO(Alltrim(TFOR->COMPLEMENTO)))
									TRM->A2_TIPO    := TFOR->PESSOAFISOUJUR
									TRM->A2_EST     := TFOR->CODETD
									TRM->A2_COD_MUN := TFOR->CODMUNICIPIO
									TRM->A2_MUN     := UPPER(NOACENTO(Alltrim(TFOR->CIDADE)))
									TRM->A2_BAIRRO  := UPPER(NOACENTO(Alltrim(TFOR->BAIRRO)))
									// TRM->A2_NATUREZ := TFOR->
									TRM->A2_CEP     := TFOR->CEP
									// TRM->A2_DDD     := TFOR->
									TRM->A2_TEL     := TFOR->TELEFONE
									TRM->A2_PAIS    := "105"
									TRM->A2_CGC     := _cCNPJ
									TRM->A2_CONTATO := TFOR->CONTATO
									TRM->A2_INSCR   := TFOR->INSCRESTADUAL
									TRM->A2_CODPAIS := "01058"
									TRM->A2_EMAIL   := TFOR->EMAIL
									TRM->A2_MSBLQL  := If(TFOR->ATIVO=1,"2","1")
									// TRM->A2_LC      := TFOR->LIMITECREDITO
									TRM->A2_INSCRM  := TFOR->INSCRMUNICIPAL
									TRM->A2_CONTRIB  := If(TFOR->CONTRIBUINTE=1,"2","1")
									TRM->(MsUnLock())
								Endif

								// _oProcess:IncRegua2("Gerando tabela "+_cTab)

								TFOR->(dbSkip())
							EndDo
						EndDo

						If _cKey1 <> '0'
							_cArq1	:= "\TAB_RM\"+_cPasta+"\SA20.dtc"	//Gera o nome do arquivo
							_cInd1	:= "\TAB_RM\"+_cPasta+"\SA20"		//Indice do arquivo

							If SELECT("TRM2") > 0
								TRM2->(dbCloseArea())
							Endif

							dbUseArea( .T.,"CTREECDX", _cArq1,"TRM2", .T., .F. )
							dbSelectArea("TRM2")

							IndRegua( "TRM2", _cInd1, SA2->(IndexKey(3)))

							dbClearIndex()
							dbSetIndex(_cInd1 + OrdBagExt() )

							TRM2->(dbSetOrder(1))
							TRM2->(dbGoTop())

							While TRM2->(!EOF())

								If !TRM->(MsSeek(TRM2->A2_FILIAL+TRM2->A2_CGC))

									If !TRM->(MsSeek(TRM2->A2_FILIAL+Left(TRM2->A2_CGC,8)))
										_cLoja := "01"
										_nCod  ++
										_cCod  :="F"+PadL(Alltrim(Str(_nCod)),5,"0")
									ELSE
										_cCod  := TRM->A2_COD
										_cSeek := TRM->A2_FILIAL+Left(TRM->A2_CGC,8)
										_cLoja := "00"

										While TRM->(!EOF()) .And. _cSeek == TRM->A2_FILIAL+Left(TRM->A2_CGC,8)

											_cLoja := If( TRM->A2_LOJA > _cLoja,TRM->A2_LOJA,_cLoja )

											TRM->(dbSkip())
										EndDo

										_cLoja := SOMA1(_cLoja)

									Endif

									TRM->(RecLock("TRM",.T.))
									For _nTRM := 1 to TRM->(FCOUNT())
										If TRM->(FIELD(_nTRM)) = "A2_COD"
											TRM->A2_COD := _cCod
										ElseIf TRM->(FIELD(_nTRM)) = "A2_LOJA"
											TRM->A2_LOJA := _cLoja
										Else
											&("TRM->"+(TRM->(FIELD(_nTRM)))) := &("TRM2->"+(TRM2->(FIELD(_nTRM))))
										Endif
									Next _nTRM

									TRM->(MsUnLock())
								Endif

								TRM2->(dbSkip())
							EndDo

							TRM2->(dbCloseArea())

						Endif
					Endif
				EndDo

			Endif

			TFOR->(dbCloseArea())

		ElseIf _cTab = 'SB1'

			If Select("TPROD") > 0
				TPROD->(dbCloseArea())
			Endif

			_cQry := " SELECT * FROM DADOSRM..TPRODUTO A " +CRLF
			_cQry += " INNER JOIN DADOSRM..TPRODUTODEF B ON A.CODCOLPRD = B.CODCOLIGADA  AND A.IDPRD = B.IDPRD " +CRLF
			_cQry += " WHERE RTRIM(CODCOLPRD) IN  ('0','9','10','11') " +CRLF
			_cQry += " ORDER BY CODCOLPRD,CODIGOPRD" +CRLF

			TcQuery _cQry New Alias "TPROD"

			_nReg := Contar("TPROD","!EOF()")

			If _nReg > 0

				_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

				_nRegAtu := 0

				TPROD->(dbGoTop())

				While TPROD->(!EOF())

					_cKey1   := Alltrim(cValToChar(TPROD->CODCOLPRD))

					If CriarDTC(_cTab,_cKey1)

						While TPROD->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TPROD->CODCOLPRD))

							_nRegAtu ++

							_oProcess:IncRegua2("Gerando tabela "+_cTab)
							// _oProcess:IncRegua2("Gerando tabela "+_cTab+" - Registro "+Alltrim(str(_nRegAtu))+" de "+Alltrim(str(_nReg)))

							TRM->(RecLock("TRM",.T.))
							// TRM->B1_FILIAL  :=
							TRM->B1_COD		:= Alltrim(StrTran(TPROD->CODIGOPRD,".",""))
							TRM->B1_DESC	:= NoAcento(UPPER(Alltrim(TPROD->DESCRICAO)))
							TRM->B1_MSBLQL	:= (TPROD->INATIVO=1,"1","2")
							TRM->B1_PESO	:= TPROD->PESOLIQUIDO
							TRM->B1_PESBRU	:= TPROD->PESOBRUTO
							TRM->B1_ORIGEM	:= Alltrim(cValToChar(TPROD->REFERENCIACP))
							TRM->B1_UPRC	:= TPROD->PRECO1
							TRM->B1_PRV1	:= TPROD->PRECO2
							TRM->B1_CUSTD	:= TPROD->CUSTOUNITARIO
							TRM->B1_UCALSTD	:= TPROD->DATABASEPRECO1
							TRM->B1_POSIPI	:= TPROD->NUMEROCCF
							TRM->B1_UM		:= TPROD->CODUNDCONTROLE
							TRM->B1_LOCPAD	:= "01"
							// TRM->B1_GRUPO	:=
							TRM->B1_EMIN	:= TPROD->PONTODEPEDIDO1
							TRM->B1_EMAX	:= TPROD->ESTOQUEMAXIMO1
							TRM->(MsUnLock())

							// _oProcess:IncRegua2("Gerando tabela "+_cTab)

							TPROD->(dbSkip())
						EndDo

					Endif
				EndDo
			Endif

			TPROD->(dbCloseArea())

		ElseIf _cTab = 'CTT'

			If Select("TCUSTO") > 0
				TCUSTO->(dbCloseArea())
			Endif

			_cQry := " SELECT * FROM DADOSRM..GCCUSTO " +CRLF
			_cQry += " WHERE RTRIM(CODCOLIGADA) IN  ('0','9','10','11') " +CRLF
			_cQry += " ORDER BY CODCOLIGADA,CODCCUSTO" +CRLF

			TcQuery _cQry New Alias "TCUSTO"

			_nReg := Contar("TCUSTO","!EOF()")

			If _nReg > 0

				_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

				_nRegAtu := 0

				TCUSTO->(dbGoTop())

				While TCUSTO->(!EOF())

					_cKey1   := Alltrim(cValToChar(TCUSTO->CODCOLIGADA))

					If CriarDTC(_cTab,_cKey1)

						While TCUSTO->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TCUSTO->CODCOLIGADA))

							_nRegAtu ++

							_oProcess:IncRegua2("Gerando tabela "+_cTab)
							// _oProcess:IncRegua2("Gerando tabela "+_cTab+" - Registro "+Alltrim(str(_nRegAtu))+" de "+Alltrim(str(_nReg)))

							TRM->(RecLock("TRM",.T.))
							// TRM->CTT_FILIAL  :=
							TRM->CTT_CUSTO	:= Alltrim(StrTran(TCUSTO->CODCCUSTO,".",""))
							TRM->CTT_CLASSE	:= If(Len(Alltrim(StrTran(TCUSTO->CODCCUSTO,".",""))) = 4,"2","1")
							TRM->CTT_DESC01	:= NoAcento(UPPER(Alltrim(TCUSTO->NOME)))
							TRM->CTT_DTEXIS	:= CTOD('25/03/2020')
							TRM->CTT_BLOQ	:= If(TCUSTO->PERMITELANC='T',"2","1")
							TRM->CTT_MSBLQL	:= If(TCUSTO->ATIVO='T',"2","1")
							TRM->(MsUnLock())

							// _oProcess:IncRegua2("Gerando tabela "+_cTab)

							TCUSTO->(dbSkip())
						EndDo

					Endif
				EndDo
			Endif

			TCUSTO->(dbCloseArea())

		ElseIf _cTab = 'SE4'

			If Select("TCONPAG") > 0
				TCONPAG->(dbCloseArea())
			Endif

			_cQry := " SELECT TOP 5 * FROM DADOSRM..TCPG " +CRLF
			_cQry += " WHERE RTRIM(CODCOLIGADA) IN  ('0','9','10','11') " +CRLF
			_cQry += " ORDER BY CODCOLIGADA,CODCPG " +CRLF

			TcQuery _cQry New Alias "TCONPAG"

			_nReg := Contar("TCONPAG","!EOF()")

			If _nReg > 0

				_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

				_nRegAtu := 0

				TCONPAG->(dbGoTop())

				While TCONPAG->(!EOF())

					_cKey1   := Alltrim(cValToChar(TCONPAG->CODCOLIGADA))

					If CriarDTC(_cTab,_cKey1)

						While TCONPAG->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TCONPAG->CODCOLIGADA))

							_nRegAtu ++

							_oProcess:IncRegua2("Gerando tabela "+_cTab)

							TRM->(RecLock("TRM",.T.))
							// TRM->E4_FILIAL  :=
							TRM->E4_CODIGO	:= 
							TRM->E4_TIPO	:= 
							TRM->E4_COND	:= 
							TRM->E4_DESCRI	:= 
							TRM->E4_DDD		:= 
							TRM->E4_MSBLQL	:= 
							TRM->(MsUnLock())

							// _oProcess:IncRegua2("Gerando tabela "+_cTab)

							TCONPAG->(dbSkip())
						EndDo

					Endif
				EndDo
			Endif

			TCONPAG->(dbCloseArea())

			// ElseIf _cTab = 'CT2'
		Endif

		// _oProcess:IncRegua1("Tabelas RM")

	Next _nTab

Return(Nil)



//Criar Tabela
Static Function CriarDTC(_cTabela,_cNome)

	Local _aCampos	:= {}
	Local _cArquivo	:= ""
	Local _cIndice	:= ""
	Local _lRet		:= .F.
	Local _cNTab	:= ''

	If ValType(_cNome) = "U"
		_cNTab	:= _cTabela
	Else
		_cNTab	:= _cTabela+_cNome
	Endif

	MakeDir( "\TAB_RM\"+_cPasta )

	_cArquivo	:= "\TAB_RM\"+_cPasta+"\"+_cNTab+".dtc"	//Gera o nome do arquivo
	_cIndice	:= "\TAB_RM\"+_cPasta+"\"+_cNTab		//Indice do arquivo

	If !File(_cArquivo)

		SX3->(dbSetOrder(1))
		If SX3->(MsSeek(_cTabela))

			While SX3->(!EOF()) .And. SX3->X3_ARQUIVO = _cTabela

				// If X3USO(SX3->X3_USADO)
				aAdd(_aCampos,{Alltrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
				// Endif

				SX3->(dbSkip())
			EndDo

			If _cTabela = "SA1"
				aAdd(_aCampos,{"A1_YCODRM","C",25,0})
			ElseIf _cTabela = "SA2"
				aAdd(_aCampos,{"A2_YCODRM","C",25,0})
			Endif

			If SELECT("TRM") > 0
				TRM->(dbCloseArea())
			Endif

			//Criar o arquivo Ctree
			dbCreate(_cArquivo,_aCampos,"CTREECDX")
			dbUseArea(.T.,"CTREECDX",_cArquivo,"TRM",.F.,.F.)

			If _cTabela $ "SA1|SA2"
				IndRegua( "TRM", _cIndice,  (_cTabela)->( IndexKey( 3 ) ))
			Else
				IndRegua( "TRM", _cIndice,  (_cTabela)->( IndexKey( 1 ) ))
			Endif

			dbClearIndex()
			dbSetIndex(_cIndice + OrdBagExt() )

			_lRet := .T.

		Endif
	Else
		MsgAlert("N�o foi poss�vel criar o arquivo "+_cArquivo)
	Endif

Return(_lRet)



Static Function GetEmp()

	Local _cQryEmp	:= ''
	Local _cEmp		:= ''
	Local _cFil		:= ''
	Local _cCNPJ	:= ''
	Local _aRet		:= {}
	Local _AreaSM0	:= Nil
	Local _lOk		:= .F.

	If Select("TEMP") > 0
		TEMP->(dbCloseArea())
	Endif

	_cQryEmp := " SELECT * FROM DADOSRM..GFILIAL " + CRLF
	_cQryEmp += " WHERE RTRIM(CODCOLIGADA)+RTRIM(CODFILIAL) IN ('91','93','101','103','104','111','113')  " + CRLF

	TcQuery _cQryEmp New Alias "TEMP"

	TEMP->(dbGoTop())

	While TEMP->(!EOF())

		_cCNPJ := Alltrim(TEMP->CGC)
		_cCNPJ := STRTRAN(_cCNPJ,".","")
		_cCNPJ := STRTRAN(_cCNPJ,"/","")
		_cCNPJ := STRTRAN(_cCNPJ,"-","")

		_cEmp := PadL(Alltrim(cValToChar(TEMP->CODCOLIGADA)),2,"0")
		_cFil := PadL(Alltrim(cValToChar(TEMP->CODFILIAL)),2,"0")

		_AreaSM0:= SM0->(GetArea())

		SM0->(dbGoTop())
		_lOk := .F.

		While SM0->(!Eof()) .And. !_lOk

			If Alltrim(SM0->M0_CGC) = _cCNPJ
				AADD(_aRet,{_cCNPJ,_cEmp,_cFil,Alltrim(SM0->M0_CODIGO),Alltrim(SM0->M0_CODFIL),Alltrim(TEMP->NOMEFANTASIA)})
				_lOk := .T.
			Endif

			SM0->(dbSkip())
		EndDo

		RestArea(_AreaSM0)

		TEMP->(dbSkip())
	EndDo

	TEMP->(dbCloseArea())

Return(_aRet)



Static Function NoAcento(cString)

	Local cChar  := ""
	Local nX     := 0
	Local nY     := 0
	Local cVogal := "aeiouAEIOU"
	Local cAgudo := "�����"+"�����"
	Local cCircu := "�����"+"�����"
	Local cTrema := "�����"+"�����"
	Local cCrase := "�����"+"�����"
	Local cTio   := "����"
	Local cCecid := "��"
	Local cMaior := "&lt;"
	Local cMenor := "&gt;"

	For nX:= 1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
			nY:= At(cChar,cAgudo)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCircu)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTrema)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCrase)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTio)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
			EndIf
			nY:= At(cChar,cCecid)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("cC",nY,1))
			EndIf
		Endif
	Next

	If cMaior$ cString
		cString := strTran( cString, cMaior, "" )
	EndIf
	If cMenor$ cString
		cString := strTran( cString, cMenor, "" )
	EndIf

	cString := StrTran( cString, CRLF, " " )

Return cString





/*

//gravar na tabela
Static Function GravarDTC(cCodigo)

	//Verifico se o alias est� aberto e fecho
	If ( SELECT("REV") ) > 0
		dbSelectArea("REV")
		REV->(dbCloseArea())
	EndIf

	//abro a tabela
	dbUseArea( .T.,"CTREECDX", cArquivo,"REV", .T., .F. )
	dbSelectArea("REV")
	IndRegua( "REV", cIndice, "REV_FILIAL + REV_COD",,,"CODIGO" )
	dbClearIndex()
	dbSetIndex(cIndice + OrdBagExt() )

	dbSelectArea("REV")
	REV->(dbSetOrder(1))
	REV->(dbGoTop())
	If( REV->(!dbSeek('01' + cCodigo)) )
		if RecLock("REV",.T.)
			REV->REV_FILIAL  := '01'
			REV->REV_COD     := cCodigo
			REV->REV_DATA    := dDatabase
			REV->REV_CONTA   := 1
			MsUnLock("REV")
			MsgInfo("Registro Inserido","Sucesso")
		Else
			MsgStop("Ocorreu um erro","Erro")
		endif
	Else
		if RecLock("REV",.F.)
			REV->REV_DATA    := dDatabase
			REV->REV_CONTA   := 2
			MsUnLock("REV")
			MsgInfo("Registro Alterado","Sucesso")
		Else
			MsgStop("Ocorreu um erro","Erro")
		endif
	Endif
Return

*/


//A1_TIPO 
//A1_NATUREZ
//A1_DDD