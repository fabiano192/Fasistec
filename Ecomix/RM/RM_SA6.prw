#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_SA6
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas SA6
*/

USER FUNCTION RM_SA6(_oProcess,_cTab,_cPasta,_cBDados)

	If Select("TBANCO") > 0
		TBANCO->(dbCloseArea())
	Endif

	_cQry := " SELECT * FROM "+_cBDados+".FCONTA A " + CRLF
	_cQry += " INNER JOIN "+_cBDados+".GBANCO B ON A.NUMBANCO = B.NUMBANCO " + CRLF
	_cQry += " WHERE RTRIM(A.CODCOLIGADA) IN  ('0','9','10','11')  " + CRLF
	_cQry += " ORDER BY A.CODCOLIGADA " + CRLF

	TcQuery _cQry New Alias "TBANCO"

	_nReg := Contar("TBANCO","!EOF()")

	If _nReg > 0

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

		_nRegAtu := 0

		TBANCO->(dbGoTop())

		While TBANCO->(!EOF())

			_cKey1   := Alltrim(cValToChar(TBANCO->CODCOLIGADA))

			If U_RMCriarDTC(_cTab,_cKey1)

				While TBANCO->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TBANCO->CODCOLIGADA))

					_nRegAtu ++

					_oProcess:IncRegua2("Gerando tabela "+_cTab)
					// _oProcess:IncRegua2("Gerando tabela "+_cTab+" - Registro "+Alltrim(str(_nRegAtu))+" de "+Alltrim(str(_nReg)))

					TRM->(RecLock("TRM",.T.))
					// TRM->A6_FILIAL
					TRM->A6_COD     := Alltrim(TBANCO->NUMBANCO)
					TRM->A6_AGENCIA := Alltrim(TBANCO->NUMAGENCIA)
					TRM->A6_NOMEAGE := U_RM_NoAcento(UPPER(Alltrim(TBANCO->NOMEREDUZIDO)))
					// TRM->A6_DVAGE   :=
					TRM->A6_NUMCON  := Alltrim(TBANCO->NROCONTA)
					TRM->A6_DVCTA   := TBANCO->DIGCONTA
					TRM->A6_NOME    := U_RM_NoAcento(UPPER(Alltrim(TBANCO->NOME)))
					TRM->A6_NREDUZ  := U_RM_NoAcento(UPPER(Alltrim(TBANCO->NOMEREDUZIDO)))
					// TRM->A6_END     :=
					// TRM->A6_BAIRRO  :=
					// TRM->A6_MUN     :=
					// TRM->A6_CEP     :=
					// TRM->A6_EST     :=
					// TRM->A6_TEL     :=
					// TRM->A6_CONTATO :=
					TRM->(MsUnLock())

					// _oProcess:IncRegua2("Gerando tabela "+_cTab)

					TBANCO->(dbSkip())
				EndDo

			Endif
		EndDo
	Endif

	TBANCO->(dbCloseArea())

Return(Nil)