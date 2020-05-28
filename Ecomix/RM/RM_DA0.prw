#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_DA0
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas DA0
*/

USER FUNCTION RM_DA0(_oProcess,_cTab,_cPasta,_cBDados)

	If Select("TPRC") > 0
		TPRC->(dbCloseArea())
	Endif

	_cQry := " SELECT * FROM "+_cBDados+".TTABPRECO  A " +CRLF
	_cQry += " WHERE RTRIM(CODCOLIGADA) IN  ('0','9','10','11') " +CRLF
	_cQry += " ORDER BY CODCOLIGADA" +CRLF

	TcQuery _cQry New Alias "TPRC"

	_nReg := Contar("TPRC","!EOF()")

	If _nReg > 0

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

		_nRegAtu := 0

		TPRC->(dbGoTop())

		While TPRC->(!EOF())

			_cKey1   := Alltrim(cValToChar(TPRC->CODCOLIGADA))

			If U_RMCriarDTC(_cTab,_cKey1)

				While TPRC->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TPRC->CODCOLIGADA))

					_nRegAtu ++

					// _oProcess:IncRegua2("Gerando tabela "+_cTab)  
					_oProcess:IncRegua2("Gerando tabela "+_cTab+" - Registro "+Alltrim(str(_nRegAtu))+" de "+Alltrim(str(_nReg)))

					TRM->(RecLock("TRM",.T.))
					TRM->DA0_YID    := TPRC->IDTABPRECO
					// TRM->DA0_FILIAL := 
					TRM->DA0_CODTAB := Padl(cValtoChar(TPRC->IDTABPRECO),TAMSX3("DA0_CODTAB")[1],"0")
					TRM->DA0_DESCRI := U_RM_NoAcento(UPPER(Alltrim(TPRC->NOME)))
					TRM->DA0_DATDE  := TPRC->DATAVIGENCIAINI
					TRM->DA0_HORADE := "00:00"
					TRM->DA0_DATATE := TPRC->DATAVIGENCIAFIM
					TRM->DA0_HORATE := "23:59"
					TRM->DA0_ATIVO  := cValTocHar(TPRC->ATIVA)
					TRM->DA0_TPHORA := "1"
					// TRM->DA0_CONDPG := TPRC->
					// TRM->DA0_FILPUB := TPRC->
					// TRM->DA0_CODPUB := TPRC->
					// TRM->DA0_ECFLAG := TPRC->
					// TRM->DA0_ECDTEX := TPRC->
					// TRM->DA0_ECSEQ  := TPRC->
					TRM->(MsUnLock())

					TPRC->(dbSkip())
				EndDo

			Endif
		EndDo
	Endif

	TPRC->(dbCloseArea())

Return(Nil)