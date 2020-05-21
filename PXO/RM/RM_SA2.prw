#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_SA2
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas SA2
*/

USER FUNCTION RM_SA2(_oProcess,_cTab,_cPasta)

	Local _nTRM := 0
	
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

			_cKey1   := Alltrim(cValToChar(TFOR->EMP))
			_nCodA2  := 0

			If U_RMCriarDTC(_cTab,_cKey1)

				While TFOR->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TFOR->EMP))

					If TFOR->PESSOAFISOUJUR = 'J'
						_cKey2 := _cKey1 + Left(StrTran(StrTran(StrTran(TFOR->CGCCFO,".",""),"-",""),"/",""),8)
						_cChave := '_cKey2 = Alltrim(cValToChar(TFOR->EMP)) + Left(StrTran(StrTran(StrTran(TFOR->CGCCFO,".",""),"-",""),"/",""),8)'
					Else
						_cKey2 := _cKey1 + StrTran(StrTran(StrTran(TFOR->CGCCFO,".",""),"-",""),"/","")
						_cChave := '_cKey2 = Alltrim(cValToChar(TFOR->EMP)) + StrTran(StrTran(StrTran(TFOR->CGCCFO,".",""),"-",""),"/","")'
					Endif

					_cLoja := "00"
					_nCodA2  ++
					_cCod  :="F"+PadL(Alltrim(Str(_nCodA2)),5,"0")

					While TFOR->(!EOF()) .And. &(_cChave)

						_nRegAtu ++

						_oProcess:IncRegua2("Gerando tabela "+_cTab)
						// _oProcess:IncRegua2("Gerando tabela "+_cTab+" - Registro "+Alltrim(str(_nRegAtu))+" de "+Alltrim(str(_nReg)))

						_cLoja := Soma1(_cLoja)
						_cCNPJ := Alltrim(StrTran(StrTran(StrTran(TFOR->CGCCFO,".",""),"-",""),"/",""))
						_cFil  := Space(TAMSX3("A2_FILIAL")[1])

						// If !TRM->(MsSeek(_cFil+_cCNPJ))

						U_RM_GeraFor("TRM",_cFil,_cCod,_cLoja,_cCNPJ)
/*
								TRM->(RecLock("TRM",.T.))
								TRM->A2_FILIAL  := _cFil
								TRM->A2_YCODRM  := TFOR->CODCFO
								TRM->A2_COD     := _cCod
								TRM->A2_LOJA    := _cLoja
								TRM->A2_NOME    := UPPER(U_RM_NoAcento(TFOR->NOME))
								TRM->A2_NREDUZ  := UPPER(U_RM_NoAcento(TFOR->NOMEFANTASIA))
								TRM->A2_END     := UPPER(U_RM_NoAcento(Alltrim(TFOR->RUA)))+" "+UPPER(U_RM_NoAcento(ALLTRIM(TFOR->NUMERO)))
								TRM->A2_COMPLEM := UPPER(U_RM_NoAcento(Alltrim(TFOR->COMPLEMENTO)))
								TRM->A2_TIPO    := TFOR->PESSOAFISOUJUR
								TRM->A2_EST     := TFOR->CODETD
								TRM->A2_COD_MUN := TFOR->CODMUNICIPIO
								TRM->A2_MUN     := UPPER(U_RM_NoAcento(Alltrim(TFOR->CIDADE)))
								TRM->A2_BAIRRO  := UPPER(U_RM_NoAcento(Alltrim(TFOR->BAIRRO)))
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
*/
						// Endif

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

						// If !TRM->(MsSeek(TRM2->A2_FILIAL+TRM2->A2_CGC))

						If !TRM->(MsSeek(TRM2->A2_FILIAL+Left(TRM2->A2_CGC,8)))
							_cLoja := "01"
							_nCodA2  ++
							_cCod  :="F"+PadL(Alltrim(Str(_nCodA2)),5,"0")
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
						// Endif

						TRM2->(dbSkip())
					EndDo

					TRM2->(dbCloseArea())

				Endif
			Endif

			&('_nCodA2'+_cKey1) := _nCodA2

		EndDo
	Endif

	TFOR->(dbCloseArea())

Return(Nil)




User Function RM_GeraFor(_cAlias,_cFil,_cCod,_cLoja,_cCNPJ)

	(_cAlias)->(RecLock(_cAlias,.T.))
	(_cAlias)->A2_FILIAL  := _cFil
	(_cAlias)->A2_YID     := TFOR->IDCFO
	(_cAlias)->A2_YCODRM  := TFOR->CODCFO
	(_cAlias)->A2_COD     := _cCod
	(_cAlias)->A2_LOJA    := _cLoja
	(_cAlias)->A2_NOME    := UPPER(U_RM_NoAcento(TFOR->NOME))
	(_cAlias)->A2_NREDUZ  := UPPER(U_RM_NoAcento(TFOR->NOMEFANTASIA))
	(_cAlias)->A2_END     := UPPER(U_RM_NoAcento(Alltrim(TFOR->RUA)))+" "+UPPER(U_RM_NoAcento(ALLTRIM(TFOR->NUMERO)))
	(_cAlias)->A2_COMPLEM := UPPER(U_RM_NoAcento(Alltrim(TFOR->COMPLEMENTO)))
	(_cAlias)->A2_TIPO    := TFOR->PESSOAFISOUJUR
	(_cAlias)->A2_EST     := TFOR->CODETD
	(_cAlias)->A2_COD_MUN := TFOR->CODMUNICIPIO
	(_cAlias)->A2_MUN     := UPPER(U_RM_NoAcento(Alltrim(TFOR->CIDADE)))
	(_cAlias)->A2_BAIRRO  := UPPER(U_RM_NoAcento(Alltrim(TFOR->BAIRRO)))
	// (_cAlias)->A2_NATUREZ := TFOR->
	(_cAlias)->A2_CEP     := TFOR->CEP
	// (_cAlias)->A2_DDD     := TFOR->
	(_cAlias)->A2_TEL     := TFOR->TELEFONE
	(_cAlias)->A2_PAIS    := "105"
	(_cAlias)->A2_CGC     := _cCNPJ
	(_cAlias)->A2_CONTATO := TFOR->CONTATO
	(_cAlias)->A2_INSCR   := TFOR->INSCRESTADUAL
	(_cAlias)->A2_CODPAIS := "01058"
	(_cAlias)->A2_EMAIL   := TFOR->EMAIL
	(_cAlias)->A2_MSBLQL  := If(TFOR->ATIVO=1,"2","1")
	// (_cAlias)->A2_LC      := TFOR->LIMITECREDITO
	(_cAlias)->A2_INSCRM  := TFOR->INSCRMUNICIPAL
	(_cAlias)->A2_CONTRIB  := If(TFOR->CONTRIBUINTE=1,"2","1")
	(_cAlias)->(MsUnLock())

Return(Nil)


