#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_SE4
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas SE4
*/

USER FUNCTION RM_SE4(_oProcess,_cTab,_cPasta)

/*
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

					If U_RMCriarDTC(_cTab,_cKey1)

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
			*/


Return(Nil)