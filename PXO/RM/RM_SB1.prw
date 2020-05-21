#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_SB1
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas SB1
*/

USER FUNCTION RM_SB1(_oProcess,_cTab,_cPasta)

	If Select("TPROD") > 0
		TPROD->(dbCloseArea())
	Endif

	_cQry := " SELECT * FROM DADOSRM..TPRODUTO A " +CRLF
	_cQry += " INNER JOIN DADOSRM..TPRODUTODEF B ON A.CODCOLPRD = B.CODCOLIGADA  AND A.IDPRD = B.IDPRD " +CRLF
	_cQry += " WHERE RTRIM(CODCOLPRD) IN  ('0','9','10','11') " +CRLF
	_cQry += " ORDER BY CODCOLPRD,CODIGOPRD" +CRLF

	TcQuery _cQry New Alias "TPROD"

	_nReg := Contar("TPROD","!EOF()")

	If _nReg > 0

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

		_nRegAtu := 0

		TPROD->(dbGoTop())

		While TPROD->(!EOF())

			_cKey1   := Alltrim(cValToChar(TPROD->CODCOLPRD))

			If U_RMCriarDTC(_cTab,_cKey1)

				While TPROD->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TPROD->CODCOLPRD))

					_nRegAtu ++

					// _oProcess:IncRegua2("Gerando tabela "+_cTab)
					_oProcess:IncRegua2("Gerando tabela "+_cTab+" - Registro "+Alltrim(str(_nRegAtu))+" de "+Alltrim(str(_nReg)))

					TRM->(RecLock("TRM",.T.))
					TRM->B1_YID     := TPROD->IDPRD
					// TRM->B1_FILIAL  :=
					TRM->B1_COD		:= Alltrim(StrTran(TPROD->CODIGOPRD,".",""))
					TRM->B1_DESC	:= U_RM_NoAcento(UPPER(Alltrim(TPROD->DESCRICAO)))
					TRM->B1_MSBLQL	:= (TPROD->INATIVO=1,"1","2")
					TRM->B1_PESO	:= TPROD->PESOLIQUIDO
					TRM->B1_PESBRU	:= TPROD->PESOBRUTO
					TRM->B1_ORIGEM	:= Alltrim(cValToChar(TPROD->REFERENCIACP))
					TRM->B1_UPRC	:= TPROD->PRECO1
					TRM->B1_PRV1	:= TPROD->PRECO2
					TRM->B1_CUSTD	:= TPROD->CUSTOUNITARIO
					TRM->B1_UCALSTD	:= TPROD->DATABASEPRECO1
					TRM->B1_POSIPI	:= TPROD->NUMEROCCF
					TRM->B1_UM		:= TPROD->CODUNDCONTROLE
					TRM->B1_LOCPAD	:= "01"
					// TRM->B1_GRUPO	:=
					TRM->B1_EMIN	:= TPROD->PONTODEPEDIDO1
					TRM->B1_EMAX	:= TPROD->ESTOQUEMAXIMO1
					TRM->(MsUnLock())

					// _oProcess:IncRegua2("Gerando tabela "+_cTab)

					TPROD->(dbSkip())
				EndDo

			Endif
		EndDo
	Endif

	TPROD->(dbCloseArea())

Return(Nil)