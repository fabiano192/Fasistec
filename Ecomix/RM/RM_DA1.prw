#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_DA1
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas DA1
*/

USER FUNCTION RM_DA1(_oProcess,_cTab,_cPasta,_cBDados)

	If Select("TIPRC") > 0
		TIPRC->(dbCloseArea())
	Endif

	_cQry := " SELECT B.CODIGOPRD,* FROM "+_cBDados+".TTABPRECOPRD  A " +CRLF
	_cQry += " INNER JOIN "+_cBDados+".TPRODUTO B ON A.IDPRD = B.IDPRD  " +CRLF
	_cQry += " WHERE RTRIM(CODCOLIGADA) IN  ('0','9','10','11') " +CRLF
	_cQry += " ORDER BY A.CODCOLIGADA, A.IDTABPRECO,B.CODIGOPRD" +CRLF

	TcQuery _cQry New Alias "TIPRC"

	_nReg := Contar("TIPRC","!EOF()")

	If _nReg > 0

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

		_nRegAtu := 0

		TIPRC->(dbGoTop())

		While TIPRC->(!EOF())

			_cKey1   := Alltrim(cValToChar(TIPRC->CODCOLIGADA))

			If U_RMCriarDTC(_cTab,_cKey1)

				While TIPRC->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TIPRC->CODCOLIGADA))

					_cItem := Padl("",TAMSX3("DA1_ITEM")[1],"0")
					_cKey2   := Alltrim(cValToChar(TIPRC->CODCOLIGADA)) + Alltrim(cValToChar(TIPRC->IDTABPRECO))
					While TIPRC->(!EOF()) .And. _cKey2 == Alltrim(cValToChar(TIPRC->CODCOLIGADA))  + Alltrim(cValToChar(TIPRC->IDTABPRECO))

						_nRegAtu ++

						// _oProcess:IncRegua2("Gerando tabela "+_cTab)
						_oProcess:IncRegua2("Gerando tabela "+_cTab+" - Registro "+Alltrim(str(_nRegAtu))+" de "+Alltrim(str(_nReg)))


						_cItem := Soma1(_cItem)

						TRM->(RecLock("TRM",.T.))
						TRM->DA1_YID       := TIPRC->IDTABPRECO
						// TRM->DA1_FILIAL
						TRM->DA1_CODTAB    := Padl(cValtoChar(TIPRC->IDTABPRECO),TAMSX3("DA0_CODTAB")[1],"0")
						TRM->DA1_ITEM      := _cItem
						TRM->DA1_CODPRO    := Alltrim(StrTran(TIPRC->CODIGOPRD,".",""))
						TRM->DA1_PRCVEN    := TIPRC->PRECO
						TRM->DA1_TPOPER    := "4"
						TRM->DA1_DATVIG    := TIPRC->DATAVIGENCIAFIM
						TRM->DA1_QTDLOT    := 999999.99
						TRM->DA1_ATIVO     := cValTocHar(TIPRC->ATIVO)
						TRM->DA1_MOEDA  := 1
						// TRM->DA1_GRUPO
						// TRM->DA1_REFGRD
						// TRM->DA1_VLRDES := 0
						// TRM->DA1_PERDES := 0
						// TRM->DA1_FRETE
						// TRM->DA1_ESTADO := TIPRC->
						// TRM->DA1_INDLOT := TIPRC->
						// TRM->DA1_ITEMGR := TIPRC->
						// TRM->DA1_PRCMAX := TIPRC->
						// TRM->DA1_DTUMOV := TIPRC->
						// TRM->DA1_HRUMOV := TIPRC->
						// TRM->DA1_ECDTEX := TIPRC->
						// TRM->DA1_ECSEQ  := TIPRC->
						// TRM->DA1_MSEXP  := TIPRC->
						// TRM->DA1_HREXPO := TIPRC->
						// TRM->DA1_TIPPRE := TIPRC->
						TRM->(MsUnLock())

						TIPRC->(dbSkip())
					EndDo
				EndDo
			Endif
		EndDo
	Endif

	TIPRC->(dbCloseArea())

Return(Nil)