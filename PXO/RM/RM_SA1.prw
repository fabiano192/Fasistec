#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_SA1
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas SA1
*/

USER FUNCTION RM_SA1(_oProcess,_cTab,_cPasta)

	Local _nTRM := 0

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

			_cKey1  := Alltrim(cValToChar(TCLI->EMP))
			_nCodA1 := 0

			If U_RMCriarDTC(_cTab,_cKey1)

				While TCLI->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TCLI->EMP))

					If TCLI->PESSOAFISOUJUR = 'J'
						_cKey2 := _cKey1 + Left(StrTran(StrTran(StrTran(TCLI->CGCCFO,".",""),"-",""),"/",""),8)
						_cChave := '_cKey2 = Alltrim(cValToChar(TCLI->EMP)) + Left(StrTran(StrTran(StrTran(TCLI->CGCCFO,".",""),"-",""),"/",""),8)'
					Else
						_cKey2 := _cKey1 + StrTran(StrTran(StrTran(TCLI->CGCCFO,".",""),"-",""),"/","")
						_cChave := '_cKey2 = Alltrim(cValToChar(TCLI->EMP)) + StrTran(StrTran(StrTran(TCLI->CGCCFO,".",""),"-",""),"/","")'
					Endif

					_cLoja  := "00"
					_nCodA1 ++
					_cCod   := "C"+PadL(Alltrim(Str(_nCodA1)),5,"0")

					While TCLI->(!EOF()) .And. &(_cChave)

						_nRegAtu ++

						_oProcess:IncRegua2("Gerando tabela "+_cTab)
						// _oProcess:IncRegua2("Gerando tabela "+_cTab+" - Registro "+Alltrim(str(_nRegAtu))+" de "+Alltrim(str(_nReg)))

						_cLoja := Soma1(_cLoja)
						_cCNPJ := Alltrim(StrTran(StrTran(StrTran(TCLI->CGCCFO,".",""),"-",""),"/",""))
						_cFil  := Space(TAMSX3("A1_FILIAL")[1])

						// If !TRM->(MsSeek(_cFil+_cCNPJ))

						U_RM_GeraCli("TRM",_cFil,_cCod,_cLoja,_cCNPJ)

/*
								TRM->(RecLock("TRM",.T.))
								TRM->A1_FILIAL  := _cFil
								TRM->A1_YCODRM  := TCLI->CODCFO
								TRM->A1_COD     := _cCod
								TRM->A1_LOJA    := _cLoja
								TRM->A1_PESSOA  := TCLI->PESSOAFISOUJUR
								TRM->A1_NOME    := UPPER(U_RM_NoAcento(TCLI->NOME))
								TRM->A1_NREDUZ  := UPPER(U_RM_NoAcento(TCLI->NOMEFANTASIA))
								TRM->A1_END     := UPPER(U_RM_NoAcento(Alltrim(TCLI->RUA)))+" "+UPPER(U_RM_NoAcento(ALLTRIM(TCLI->NUMERO)))
								TRM->A1_COMPLEM := UPPER(U_RM_NoAcento(Alltrim(TCLI->COMPLEMENTO)))
								// TRM->A1_TIPO    := TCLI-> ????
								TRM->A1_EST     := TCLI->CODETD
								TRM->A1_COD_MUN := TCLI->CODMUNICIPIO
								TRM->A1_MUN     := UPPER(U_RM_NoAcento(Alltrim(TCLI->CIDADE)))
								TRM->A1_BAIRRO  := UPPER(U_RM_NoAcento(Alltrim(TCLI->BAIRRO)))
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
								*/
						// Endif

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

						// If !TRM->(MsSeek(TRM2->A1_FILIAL+TRM2->A1_CGC))

						If !TRM->(MsSeek(TRM2->A1_FILIAL+Left(TRM2->A1_CGC,8)))
							_cLoja := "01"
							_nCodA1  ++
							_cCod  :="C"+PadL(Alltrim(Str(_nCodA1)),5,"0")
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
						// Endif

						TRM2->(dbSkip())
					EndDo

					TRM2->(dbCloseArea())

				Endif
			Endif

			&('_nCodA1'+_cKey1) := _nCodA1

		EndDo

	Endif

	TCLI->(dbCloseArea())

Return(Nil)



User Function RM_GeraCli(_cAlias,_cFil,_cCod,_cLoja,_cCNPJ)

	(_cAlias)->(RecLock(_cAlias,.T.))
	(_cAlias)->A1_YID     := TCLI->IDCFO
	(_cAlias)->A1_FILIAL  := _cFil
	(_cAlias)->A1_YCODRM  := TCLI->CODCFO
	(_cAlias)->A1_COD     := _cCod
	(_cAlias)->A1_LOJA    := _cLoja
	(_cAlias)->A1_PESSOA  := TCLI->PESSOAFISOUJUR
	(_cAlias)->A1_NOME    := UPPER(U_RM_NoAcento(TCLI->NOME))
	(_cAlias)->A1_NREDUZ  := UPPER(U_RM_NoAcento(TCLI->NOMEFANTASIA))
	(_cAlias)->A1_END     := UPPER(U_RM_NoAcento(Alltrim(TCLI->RUA)))+" "+UPPER(U_RM_NoAcento(ALLTRIM(TCLI->NUMERO)))
	(_cAlias)->A1_COMPLEM := UPPER(U_RM_NoAcento(Alltrim(TCLI->COMPLEMENTO)))
	// (_cAlias)->A1_TIPO    := TCLI-> ????
	(_cAlias)->A1_EST     := TCLI->CODETD
	(_cAlias)->A1_COD_MUN := TCLI->CODMUNICIPIO
	(_cAlias)->A1_MUN     := UPPER(U_RM_NoAcento(Alltrim(TCLI->CIDADE)))
	(_cAlias)->A1_BAIRRO  := UPPER(U_RM_NoAcento(Alltrim(TCLI->BAIRRO)))
	// (_cAlias)->A1_NATUREZ := TCLI->
	(_cAlias)->A1_CEP     := TCLI->CEP
	// (_cAlias)->A1_DDD     := TCLI->
	(_cAlias)->A1_TEL     := TCLI->TELEFONE
	(_cAlias)->A1_PAIS    := "105"
	(_cAlias)->A1_CGC     := _cCNPJ
	(_cAlias)->A1_CONTATO := TCLI->CONTATO
	(_cAlias)->A1_INSCR   := TCLI->INSCRESTADUAL
	(_cAlias)->A1_CODPAIS := "01058"
	(_cAlias)->A1_SATIV1  := "1"
	(_cAlias)->A1_SATIV2  := "1"
	(_cAlias)->A1_SATIV3  := "1"
	(_cAlias)->A1_SATIV4  := "1"
	(_cAlias)->A1_SATIV5  := "1"
	(_cAlias)->A1_SATIV6  := "1"
	(_cAlias)->A1_SATIV7  := "1"
	(_cAlias)->A1_SATIV8  := "1"
	(_cAlias)->A1_EMAIL   := TCLI->EMAIL
	(_cAlias)->A1_MSBLQL  := If(TCLI->ATIVO=1,"2","1")
	(_cAlias)->A1_LC      := TCLI->LIMITECREDITO
	(_cAlias)->A1_INSCRM  := TCLI->INSCRMUNICIPAL
	(_cAlias)->A1_CONTRIB  := If(TCLI->CONTRIBUINTE=1,"2","1")
	(_cAlias)->(MsUnLock())

RETURN(nIL)


