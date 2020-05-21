#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_CTT
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas CTT
*/

USER FUNCTION RM_CTT(_oProcess,_cTab,_cPasta)

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

			If U_RMCriarDTC(_cTab,_cKey1)

				While TCUSTO->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TCUSTO->CODCOLIGADA))

					_nRegAtu ++

					_oProcess:IncRegua2("Gerando tabela "+_cTab)
					// _oProcess:IncRegua2("Gerando tabela "+_cTab+" - Registro "+Alltrim(str(_nRegAtu))+" de "+Alltrim(str(_nReg)))

					TRM->(RecLock("TRM",.T.))
					// TRM->CTT_FILIAL  :=
					TRM->CTT_YID    := TCUSTO->ID
					TRM->CTT_CUSTO	:= Alltrim(StrTran(TCUSTO->CODCCUSTO,".",""))
					TRM->CTT_CLASSE	:= If(Len(Alltrim(StrTran(TCUSTO->CODCCUSTO,".",""))) = 4,"2","1")
					TRM->CTT_DESC01	:= U_RM_NoAcento(UPPER(Alltrim(TCUSTO->NOME)))
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

Return(Nil)