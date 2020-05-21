#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_SE2
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas SE2
*/

USER FUNCTION RM_SE2(_oProcess,_cTab,_cPasta)

	If Select("TPAG") > 0
		TPAG->(dbCloseArea())
	Endif

	_cQry := " SELECT CODFILIAL AS FILIAL,DATAVENCIMENTO AS DTVENC, * FROM DADOSRM..FLAN " + CRLF
	_cQry += " WHERE RTRIM(A.CODCOLIGADA)+RTRIM(A.CODFILIAL) IN ('91','93','101','103','104','111','113') " + CRLF
	// _cQry += " WHERE RTRIM(CODCOLIGADA) IN  ('0','9','10','11')  " + CRLF
	_cQry += " AND PAGREC = '2' " + CRLF
	_cQry += " ORDER BY CODCOLIGADA,CODFILIAL " + CRLF

	TcQuery _cQry New Alias "TPAG"

	_nReg := Contar("TPAG","!EOF()")

	If _nReg > 0

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

		_nRegAtu := 0

		TPAG->(dbGoTop())

		While TPAG->(!EOF())

			_cKey1   := Alltrim(cValToChar(TPAG->CODCOLIGADA))
			_nCodA2  := &('_nCodA2'+_cKey1)

			If U_RMCriarDTC(_cTab,_cKey1)

				// _cArq3	:= "\TAB_RM\20200513_124607\SA2"+_cKey1+".dtc"	//Gera o nome do arquivo
				// _cInd3	:= "\TAB_RM\20200513_124607\SA2"+_cKey1			//Indice do arquivo
				_cArq4	:= "\TAB_RM\"+_cPasta+"\SA2"+_cKey1+".dtc"	//Gera o nome do arquivo
				_cInd4	:= "\TAB_RM\"+_cPasta+"\SA2"+_cKey1			//Indice do arquivo
				_cInd6	:= "\TAB_RM\"+_cPasta+"\SA2"+_cKey1+"A"		//Indice do arquivo

				If SELECT("TRM4") > 0
					TRM4->(dbCloseArea())
				Endif

				dbUseArea( .T.,"CTREECDX", _cArq4,"TRM4", .T., .F. )
				dbSelectArea("TRM4")

				IndRegua( "TRM4", _cInd4, "A2_YCODRM")
				IndRegua( "TRM4", _cInd6, "A2_CGC")

				dbClearIndex()
				dbSetIndex(_cInd4 + OrdBagExt() )

				While TPAG->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TPAG->CODCOLIGADA))

					_nRegAtu ++

					_oProcess:IncRegua2("Gerando tabela "+_cTab)

					_cCodFor := ''
					_cLojFor := ''
					_cNomFor := ''
					TRM4->(dbSetOrder(1))
					If TRM4->(MsSeek(TPAG->CODCFO))
						_cCodFor := TRM4->A2_COD
						_cLojFor := TRM4->A2_LOJA
						_cNomFor := TRM4->A2_NREDUZ
					Else
						If Select("TFOR") > 0
							TFOR->(dbCloseArea())
						Endif

						_cQry := " SELECT CODCOLIGADA AS 'EMP',* FROM DADOSRM..FCFO " + CRLF
						_cQry += " WHERE CODCFO = '"+TPAG->CODCFO+"' " + CRLF

						TcQuery _cQry New Alias "TFOR"

						_nReg := Contar("TFOR","!EOF()")

						If _nReg > 0

							TFOR->(dbGoTop())

							_cCNPJ := Alltrim(StrTran(StrTran(StrTran(TFOR->CGCCFO,".",""),"-",""),"/",""))
							_cFil  := Space(TAMSX3("A2_FILIAL")[1])

							If TFOR->PESSOAFISOUJUR = 'J'

								TRM4->(dbClearIndex())
								TRM4->(dbSetIndex(_cInd6 + OrdBagExt() ))

								_cKey := Left(_cCNPJ,8)
								If TRM4->(MsSeek(_cKey))

									_cCod    := TRM4->A2_COD
									_cLoja   := TRM4->A2_LOJA

									While TRM4->(!EOF()) .And. _cKey = Left(TRM4->A2_CGC,8)

										If TRM4->A2_LOJA > _cLoja
											_cLoja  := TRM4->A2_LOJA
										Endif

										TRM4->(dbSkip())
									EndDo

									_cLoja := Soma1(_cLoja)

								Else
									_nCodA2 ++
									_cCod  :="F"+PadL(Alltrim(Str(_nCodA2)),5,"0")
									_cLoja := "01"
								Endif

								TRM4->(dbClearIndex())
								TRM4->(dbSetIndex(_cInd4 + OrdBagExt() ))

							Else
								_nCodA2  ++
								_cCod  :="F"+PadL(Alltrim(Str(_nCodA2)),5,"0")
								_cLoja := "01"
							Endif

							U_RM_GeraFor("TRM4",_cFil,_cCod,_cLoja,_cCNPJ)

							_cCodCli := _cCod
							_cLojCli := _cLoja
							_cNomCli := UPPER(U_RM_NoAcento(TFOR->NOME))

						Endif

						TFOR->(dbCloseArea())
					Endif

					TRM->(RecLock("TRM",.T.))
					// TRM->E1_MSEMP :=
					// TRM->E1_MSFIL :=

					TRM->E2_YID       := TPAG->IDLAN
					TRM->E2_YCODRM    := TPAG->CODCFO
					TRM->E2_YDOCRM    := TPAG->NUMERODOCUMENTO

					TRM->E2_FILIAL    := Alltrim(cValtoChar(TPAG->CODFILIAL))
					TRM->E2_PREFIXO   := If(Alltrim(TPAG->SERIEDOCUMENTO) = '@@@','',Alltrim(TPAG->SERIEDOCUMENTO))
					TRM->E2_NUM       := Alltrim(Left(TPAG->NUMERODOCUMENTO,9))

					_cParcela := UPPER(Alltrim(TPAG->PARCELA))

					If Empty(_cParcela)
						_nAt := At("-",Alltrim(TPAG->NUMERODOCUMENTO))
						If _nAt > 0
							_cParcela := Substr(TPAG->NUMERODOCUMENTO,_nAt+1)
						Else
							If Len(TPAG->NUMERODOCUMENTO) > 9
								_cParcela := Substr(TPAG->NUMERODOCUMENTO,10)
							Endif
						Endif
					Endif

					TRM->E2_PARCELA   := _cParcela
					// TRM->E2_TIPO      := "RM"
					// TRM->E2_NATUREZ   := ??
					// TRM->E2_PORTADO   := (TPAG->CNABBANCO)
					// TRM->E2_AGEDEP    := ??

					TRM->E2_FORNECE    := _cCodFor
					TRM->E2_LOJA       := _cLojFor
					TRM->E2_NOMFOR     := _cNomFor

					TRM->E2_EMISSAO    := TPAG->DATAEMISSAO
					TRM->E2_EMIS1      := TPAG->DATAEMISSAO

					TRM->E2_VENCTO     := TPAG->DTVENC
					TRM->E2_VENCREA    := TPAG->DTVENC
					TRM->E2_VENCORI    := TPAG->DTVENC
					TRM->E2_BAIXA      := TPAG->DATABAIXA

					TRM->E2_VALOR      := TPAG->VALORORIGINAL
					TRM->E2_VLCRUZ     := TPAG->VALORORIGINAL
					TRM->E2_CODBAR     := TPAG->CODIGOBARRA
					TRM->E2_BASEIRF    := TPAG->VALORBASEIRRF
					TRM->E2_IRRF       := TPAG->VALORIRRF
					TRM->E2_VALLIQ     := TPAG->VALORORIGINAL + TPAG->VALORJUROS + TPAG->VALORMULTA - TPAG->VALORDESCONTO
					TRM->E2_JUROS      := TPAG->VALORJUROS
					TRM->E2_MULTA      := TPAG->VALORMULTA
					TRM->E2_DESCONT    := TPAG->VALORDESCONTO
					TRM->E2_MOEDA      := 1

					TRM->E2_HIST       := TPAG->HISTORICO
					TRM->E2_SALDO      := If(TPAG->VALORBAIXADO >= TPAG->VALORORIGINAL, 0 , TPAG->VALORORIGINAL - TPAG->VALORBAIXADO)

					TRM->E2_MODSPB     := "1"
					TRM->E2_DESDOBR    := "2"
					TRM->E2_PROJPMS    := "2"
					TRM->E2_MULTNAT    := "2"

					TRM->(MsUnLock())

					TPAG->(dbSkip())
				EndDo

			Endif
		EndDo
	Endif

	TPAG->(dbCloseArea())

Return(Nil)