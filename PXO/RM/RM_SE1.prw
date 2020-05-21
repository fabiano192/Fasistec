#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_SE1
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas SE1
*/

USER FUNCTION RM_SE1(_oProcess,_cTab,_cPasta)

	If Select("TREC") > 0
		TREC->(dbCloseArea())
	Endif

	_cQry := " SELECT CODFILIAL AS FILIAL,DATAVENCIMENTO AS DTVENC, * FROM DADOSRM..FLAN " + CRLF
	// _cQry += " WHERE RTRIM(CODCOLIGADA) IN  ('0','9','10','11')  " + CRLF
	_cQry += " WHERE RTRIM(A.CODCOLIGADA)+RTRIM(A.CODFILIAL) IN ('91','93','101','103','104','111','113') " + CRLF
	_cQry += " AND PAGREC = '1' " + CRLF
	_cQry += " ORDER BY CODCOLIGADA,CODFILIAL " + CRLF

	TcQuery _cQry New Alias "TREC"

	_nReg := Contar("TREC","!EOF()")

	If _nReg > 0

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

		_nRegAtu := 0

		TREC->(dbGoTop())

		While TREC->(!EOF())

			_cKey1   := Alltrim(cValToChar(TREC->CODCOLIGADA))
			_nCodA1  := &('_nCodA1'+_cKey1)

			If U_RMCriarDTC(_cTab,_cKey1)

				_cArq3	:= "\TAB_RM\"+_cPasta+"\SA1"+_cKey1+".dtc"	//Gera o nome do arquivo
				_cInd3	:= "\TAB_RM\"+_cPasta+"\SA1"+_cKey1			//Indice do arquivo
				_cInd5	:= "\TAB_RM\"+_cPasta+"\SA1"+_cKey1+"A"		//Indice do arquivo

				If SELECT("TRM3") > 0
					TRM3->(dbCloseArea())
				Endif

				dbUseArea( .T.,"CTREECDX", _cArq3,"TRM3", .T., .F. )
				dbSelectArea("TRM3")

				IndRegua( "TRM3", _cInd3, "A1_YCODRM")
				IndRegua( "TRM3", _cInd5, "A1_CGC")

				dbClearIndex()
				dbSetIndex(_cInd3 + OrdBagExt() )

				While TREC->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TREC->CODCOLIGADA))

					_nRegAtu ++

					_oProcess:IncRegua2("Gerando tabela "+_cTab)

					_cCodCli := ''
					_cLojCli := ''
					_cNomCli := ''
					// TRM3->(dbSetOrder(1))
					If TRM3->(MsSeek(TREC->CODCFO))
						_cCodCli := TRM3->A1_COD
						_cLojCli := TRM3->A1_LOJA
						_cNomCli := TRM3->A1_NREDUZ
					Else
						If Select("TCLI") > 0
							TCLI->(dbCloseArea())
						Endif

						_cQry := " SELECT CODCOLIGADA AS 'EMP',* FROM DADOSRM..FCFO " + CRLF
						_cQry += " WHERE CODCFO = '"+TREC->CODCFO+"' " + CRLF

						TcQuery _cQry New Alias "TCLI"

						_nReg := Contar("TCLI","!EOF()")

						If _nReg > 0

							TCLI->(dbGoTop())

							_cCNPJ := Alltrim(StrTran(StrTran(StrTran(TCLI->CGCCFO,".",""),"-",""),"/",""))
							_cFil  := Space(TAMSX3("A1_FILIAL")[1])

							If TCLI->PESSOAFISOUJUR = 'J'

								TRM3->(dbClearIndex())
								TRM3->(dbSetIndex(_cInd5 + OrdBagExt() ))

								_cKey := Left(_cCNPJ,8)
								If TRM3->(MsSeek(_cKey))

									_cCod    := TRM3->A1_COD
									_cLoja   := TRM3->A1_LOJA

									While TRM3->(!EOF()) .And. _cKey = Left(TRM3->A1_CGC,8)

										If TRM3->A1_LOJA > _cLoja
											_cLoja  := TRM3->A1_LOJA
										Endif

										TRM3->(dbSkip())
									EndDo

									_cLoja := Soma1(_cLoja)

								Else
									_nCodA1 ++
									_cCod  :="C"+PadL(Alltrim(Str(_nCodA1 )),5,"0")
									_cLoja := "01"
								Endif

								TRM3->(dbClearIndex())
								TRM3->(dbSetIndex(_cInd3 + OrdBagExt() ))

							Else
								_nCodA1 ++
								_cCod  :="C"+PadL(Alltrim(Str(_nCodA1)),5,"0")
								_cLoja := "01"
							Endif

							U_RM_GeraCli("TRM3",_cFil,_cCod,_cLoja,_cCNPJ)

							_cCodCli := _cCod
							_cLojCli := _cLoja
							_cNomCli := UPPER(U_RM_NoAcento(TCLI->NOME))

						Endif

						TCLI->(dbCloseArea())
					Endif

					TRM->(RecLock("TRM",.T.))
					// TRM->E1_MSEMP :=
					// TRM->E1_MSFIL :=

					TRM->E1_YID       := TREC->IDLAN
					TRM->E1_YCODRM    := TREC->CODCFO
					TRM->E1_YDOCRM    := TREC->NUMERODOCUMENTO

					TRM->E1_FILIAL    := Alltrim(cValtoChar(TREC->CODFILIAL))
					TRM->E1_PREFIXO   := If(Alltrim(TREC->SERIEDOCUMENTO) = '@@@','',Alltrim(TREC->SERIEDOCUMENTO))
					TRM->E1_NUM       := Alltrim(Left(TREC->NUMERODOCUMENTO,9))

					_cParcela := UPPER(Alltrim(TREC->PARCELA))

					If Empty(_cParcela)
						_nAt := At("-",Alltrim(TREC->NUMERODOCUMENTO))
						If _nAt > 0
							_cParcela := Substr(TREC->NUMERODOCUMENTO,_nAt+1)
						Else
							If Len(TREC->NUMERODOCUMENTO) > 9
								_cParcela := Substr(TREC->NUMERODOCUMENTO,10)
							Endif
						Endif
					Endif

					TRM->E1_PARCELA   := _cParcela
					// TRM->E1_TIPO      := "RM"
					// TRM->E1_NATUREZ   := ??
					// TRM->E1_PORTADO   := (TREC->CNABBANCO)
					// TRM->E1_AGEDEP    := ??

					TRM->E1_CLIENTE    := _cCodCli
					TRM->E1_LOJA       := _cLojCli
					TRM->E1_NOMCLI     := _cNomCli

					TRM->E1_EMISSAO    := TREC->DATAEMISSAO
					TRM->E1_EMIS1      := TREC->DATAEMISSAO

					TRM->E1_VENCTO     := TREC->DTVENC
					TRM->E1_VENCREA    := TREC->DTVENC
					TRM->E1_VENCORI    := TREC->DTVENC
					TRM->E1_BAIXA      := TREC->DATABAIXA

					TRM->E1_VALOR      := TREC->VALORORIGINAL
					TRM->E1_VLCRUZ     := TREC->VALORORIGINAL
					TRM->E1_CODBAR     := TREC->CODIGOBARRA
					TRM->E1_BASEIRF    := TREC->VALORBASEIRRF
					TRM->E1_IRRF       := TREC->VALORIRRF
					TRM->E1_VALLIQ     := TREC->VALORORIGINAL + TREC->VALORJUROS + TREC->VALORMULTA - TREC->VALORDESCONTO
					TRM->E1_JUROS      := TREC->VALORJUROS
					TRM->E1_MULTA      := TREC->VALORMULTA
					TRM->E1_DESCONT    := TREC->VALORDESCONTO
					TRM->E1_MOEDA      := 1

					TRM->E1_HIST       := TREC->HISTORICO
					TRM->E1_SALDO      := If(TREC->VALORBAIXADO >= TREC->VALORORIGINAL, 0 , TREC->VALORORIGINAL - TREC->VALORBAIXADO)

					TRM->E1_MODSPB     := "1"
					TRM->E1_DESDOBR    := "2"
					TRM->E1_PROJPMS    := "2"
					TRM->E1_MULTNAT    := "2"

					// TRM->E1_ISS :=
					// TRM->E1_NUMBCO :=
					// TRM->E1_INDICE :=
					// TRM->E1_NUMBOR :=
					// TRM->E1_DATABOR :=

					// TRM->E1_LA :=
					// TRM->E1_LOTE :=
					// TRM->E1_MOTIVO :=
					// TRM->E1_MOVIMEN :=
					// TRM->E1_OP :=
					// TRM->E1_SITUACA :=
					// TRM->E1_CONTRAT :=
					// TRM->E1_SUPERVI :=
					// TRM->E1_VEND1 :=
					// TRM->E1_VEND2 :=
					// TRM->E1_VEND3 :=
					// TRM->E1_VEND4 :=
					// TRM->E1_VEND5 :=
					// TRM->E1_COMIS1 :=
					// TRM->E1_COMIS2 :=
					// TRM->E1_COMIS3 :=
					// TRM->E1_COMIS4 :=
					// TRM->E1_COMIS5 :=

					// TRM->E1_CORREC :=
					// TRM->E1_CONTA :=
					// TRM->E1_VALJUR :=
					// TRM->E1_PORCJUR :=
					// TRM->E1_BASCOM1 :=
					// TRM->E1_BASCOM2 :=
					// TRM->E1_BASCOM3 :=
					// TRM->E1_BASCOM4 :=
					// TRM->E1_BASCOM5 :=
					// TRM->E1_FATPREF :=
					// TRM->E1_FATURA :=
					// TRM->E1_OK :=
					// TRM->E1_PROJETO :=
					// TRM->E1_CLASCON :=
					// TRM->E1_VALCOM1 :=
					// TRM->E1_VALCOM2 :=
					// TRM->E1_VALCOM3 :=
					// TRM->E1_VALCOM4 :=
					// TRM->E1_VALCOM5 :=
					// TRM->E1_OCORREN :=
					// TRM->E1_INSTR1 :=
					// TRM->E1_INSTR2 :=
					// TRM->E1_PEDIDO :=
					// TRM->E1_DTVARIA :=
					// TRM->E1_VARURV :=
					// TRM->E1_DTFATUR :=
					// TRM->E1_NUMNOTA :=
					// TRM->E1_SERIE :=
					// TRM->E1_STATUS :=
					// TRM->E1_ORIGEM :=
					// TRM->E1_IDENTEE :=
					// TRM->E1_NUMCART :=
					// TRM->E1_FLUXO :=
					// TRM->E1_DESCFIN :=
					// TRM->E1_DIADESC :=
					// TRM->E1_TIPODES :=
					// TRM->E1_CARTAO :=
					// TRM->E1_CARTVAL :=
					// TRM->E1_CARTAUT :=
					// TRM->E1_ADM :=
					// TRM->E1_VLRREAL :=
					// TRM->E1_TRANSF :=
					// TRM->E1_BCOCHQ :=
					// TRM->E1_AGECHQ :=
					// TRM->E1_CTACHQ :=
					// TRM->E1_NUMLIQ :=
					// TRM->E1_RECIBO :=
					// TRM->E1_ORDPAGO :=
					// TRM->E1_INSS :=
					// TRM->E1_FILORIG :=
					// TRM->E1_DTACRED :=
					// TRM->E1_TIPOFAT :=
					// TRM->E1_TIPOLIQ :=
					// TRM->E1_CSLL :=
					// TRM->E1_COFINS :=
					// TRM->E1_PIS :=
					// TRM->E1_FLAGFAT :=
					TRM->(MsUnLock())
//E1_MESBASE E1_ANOBASE E1_PLNUCOB   E1_CODEMP E1_CODINT E1_MATRIC E1_TXMOEDA             E1_ACRESC              E1_SDACRES             E1_DECRESC             E1_SDDECRE             E1_MULTNAT E1_MSFIL E1_MSEMP E1_PROJPMS  E1_NRDOC                                           E1_MODSPB E1_EMITCHQ                               E1_IDCNAB  E1_PLCOEMP   E1_PLTPCOE E1_CODCOR E1_PARCCSS E1_CODORCA E1_CODIMOV   E1_FILDEB E1_NUMRA        E1_NUMSOL E1_INSCRIC E1_SERREC                                     E1_DATAEDI E1_CODDIG                                        E1_CHQDEV E1_LIDESCF E1_VLBOLSA             E1_NUMCRD  E1_VLFIES              E1_DEBITO            E1_CCD    E1_ITEMD  E1_CLVLDB E1_CREDIT            E1_CCC    E1_ITEMC  E1_CLVLCR E1_DESCON1             E1_DESCON2             E1_DTDESC3 E1_DTDESC1 E1_DTDESC2 E1_VLMULTA             E1_DESCON3             E1_MOTNEG E1_SABTPIS             E1_SABTCOF             E1_SABTCSL             E1_FORNISS E1_PARTOT E1_SITFAT E1_BASEPIS             E1_BASECOF             E1_BASECSL             E1_VRETISS             E1_PARCIRF E1_SCORGP E1_FRETISS E1_TXMDCOR             E1_SATBIRF             E1_TIPREG E1_CONEMP    E1_VERCON E1_SUBCON E1_VERSUB E1_PLLOTE  E1_PLOPELT E1_CODRDA E1_FORMREC E1_BCOCLI E1_AGECLI E1_CTACLI  E1_PARCFET E1_FETHAB              E1_MDCRON E1_MDCONTR      E1_MEDNUME E1_MDPLANI E1_MDPARCE E1_MDREVIS E1_NUMMOV E1_PREFORI E1_NODIA   E1_TITPAI                                          E1_DOCTEF            E1_MDMULT              E1_JURFAT                                          E1_MDBONI              E1_MDDESC              E1_RELATO E1_BASEINS             E1_MULTDIA             E1_NFELETR           E1_RETCNTR             E1_NUMCON            E1_TURMA             E1_IDLAN               E1_NSUTEF    E1_SABTIRF             E1_IDAPLIC             E1_PROCEL              E1_NOPER               E1_SERVICO E1_DIACTB E1_IDBOLET             E1_VRETIRF             E1_BASEISS             E1_VLBOLP              E1_APLVLMN E1_LTCXA   E1_NUMINSC             E1_CODISS E1_SEQBX D_E_L_E_T_ R_E_C_N_O_  R_E_C_D_E_L_ E1_VLMINIS E1_TPDP                E1_PARTPDP E1_CODIRRF E1_USERLGI        E1_USERLGA        E1_YFORBKP E1_NUMPRO  E1_INDPRO E1_PRISS               E1_PRINSS              E1_PARCFAC E1_FACS                E1_PARCFAB E1_FABOV               E1_PERLET E1_CHAVENF   E1_PRODUTO      E1_FAMAD               E1_PARCFAM E1_FMPEQ               E1_PARCFMP E1_TPDESC E1_FUNDESA             E1_IMAMT               E1_FASEMT              E1_PARFUND E1_PARIMA E1_PARFASE E1_CODRET E1_CTRBCO                                          E1_IDMOV   E1_BOLETO E1_DESCJUR             E1_CCUSTO E1_CDRETCS E1_CDRETIR E1_CLVL   E1_ITEMCTA E1_TPESOC E1_CNO E1_CONHTL                        E1_TCONHTL E1_SDOC E1_SDOCREC E1_VRETBIS             E1_CODSERV E1_BTRISS              E1_RATFIN
					TREC->(dbSkip())
				EndDo

			Endif
		EndDo
	Endif

	TREC->(dbCloseArea())

Return(Nil)