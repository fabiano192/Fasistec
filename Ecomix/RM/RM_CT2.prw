#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_CT2
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas CT2
*/

USER FUNCTION RM_CT2E(_oProcess,_cTab,_cPasta,_cBDados)

	Local _nH := 0

	If Select("TCONTA") > 0
		TCONTA->(dbCloseArea())
	Endif

	_cQry := " SELECT A.CODCOLIGADA,CODFILIAL,A.CODLOTEORIGEM,DOCUMENTO,DATA,DEBITO,CREDITO,PARTIDA,A.CODCCUSTO,A.CODHISTP,B.DESCRICAO,COMPLEMENTO,VALOR " +CRLF
	_cQry += " FROM "+_cBDados+".CPARTIDA A " +CRLF
	// _cQry += " FROM DADOSRM..CPARTIDA A " +CRLF
	_cQry += " LEFT JOIN "+_cBDados+".CHISTP B ON A.CODCOLIGADA = B.CODCOLIGADA AND A.CODHISTP = B.CODHISTP " +CRLF
	_cQry += " INNER JOIN "+_cBDados+".CLANCAMENTO C ON A.CODCOLIGADA = C.CODCOLIGADA AND A.CODLOTE = C.CODLOTE AND A.IDLANCAMENTO = C.IDLANCAMENTO " +CRLF
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

			If U_RMCriarDTC(_cTab,_cKey1)

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
									TRM->CT2_YID    := TCONTA->IDPARTIDA
									TRM->CT2_FILIAL := PadL(Alltrim(cValtoChar(TCONTA->CODFILIAL)),2,"0")
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
									TRM->CT2_HIST   := U_RM_NoAcento(_cHistor)
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
									TRM->CT2_FILIAL := PadL(Alltrim(cValtoChar(TCONTA->CODFILIAL)),2,"0")
									TRM->CT2_DATA   := TCONTA->DATA
									TRM->CT2_LOTE   := PADL(Alltrim(cValtoChar(TCONTA->CODLOTEORIGEM)),6,"0")
									TRM->CT2_SBLOTE := "001"
									TRM->CT2_DOC    := TCONTA->DOCUMENTO
									TRM->CT2_LINHA  := _cLinha
									TRM->CT2_MOEDLC := "01"
									TRM->CT2_DC     := "4"
									TRM->CT2_HIST   := U_RM_NoAcento(_cHistor)
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

	TCONTA->(dbCloseArea())

	TRM->(dbCloseArea())

Return(Nil)




USER FUNCTION RM_CT2I(_oProcess,_cTab,_cPasta)

	Local _cAlias   := ''
	Local _lTabLoc  := .T.
	Local _cModo
	Local _nCT2
	Local _aArea     := GetArea()
	Local _aAreaCT2  := CT2->( GetArea() )
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvArqTab := cArqTab //Salva os arquivos de

	If Alltrim(cEmpAnt) = Substr(_cTab,4,2)
		_cAlias := "CT2"
	Else

		If EmpOpenFile("CT2A","CT2",1,.T., Substr(_cTab,4,2),@_cModo)
			_cAlias := "CT2A"
			_lTabLoc := .F.
		Endif
	Endif

	If !Empty(_cAlias)

		_cUpd := " DELETE "+_cTab

		TCSQLEXEC(_cUpd )

		_cArq	:= "\TAB_RM\"+_cPasta+"\"+_cTab+".dtc"		//Gera o nome do arquivo
		_cInd	:= "\TAB_RM\"+_cPasta+"\"+_cTab+"0"			//Indice do arquivo

		If SELECT("TCT2") > 0
			TCT2->(dbCloseArea())
		Endif

		dbUseArea( .T.,"CTREECDX", _cArq,"TCT2", .T., .F. )

		If Select("TCT2") = 0
			MsgInfo( 'Erro Abrir tabela Temporária TCT2', 'RM_CT2' )
			Return(Nil)
		Endif

		dbSelectArea("TCT2")

		IndRegua( "TCT2", _cInd, CT2->( IndexKey( 1 ) ))

		dbClearIndex()
		dbSetIndex(_cInd + OrdBagExt() )

		_nReg := Contar("TCT2","!EOF()")

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso
		_oProcess:IncRegua2("Importando a tabela "+Left(_cTab,3)+" na Empresa "+Substr(_cTab,4,2) )

		TCT2->(dbGoTop())

		While TCT2->(!EOF())

			(_cAlias)->(RecLock(_cAlias,.T.))
			For _nCT2 := 1 to (_cAlias)->(FCOUNT())
				&("(_cAlias)->"+((_cAlias)->(FIELD(_nCT2)))) := &("TCT2->"+((_cAlias)->(FIELD(_nCT2))))
			Next _nCT2
			(_cAlias)->(MsUnLock())

			TCT2->(dbSkip())
		EndDo

		TCT2->(dbCloseArea())

		If !_lTabLoc
			(_cAlias)->(dbCloseArea())
		Endif

	Endif

	//Restaura os Dados de Entrada ( Ambiente )
	cFilAnt := _cSvFilAnt
	cEmpAnt := _cSvEmpAnt
	cArqTab := _cSvArqTab

	//Restaura os ponteiros das Tabelas

	RestArea( _aAreaCT2 )
	RestArea( _aArea )

Return(Nil)