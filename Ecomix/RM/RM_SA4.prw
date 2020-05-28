#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_SA4
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas SA4
*/

USER FUNCTION RM_SA4(_oProcess,_cTab,_cPasta,_cBDados)

	If Select("TTRAN") > 0
		TTRAN->(dbCloseArea())
	Endif

	_cQry := " SELECT * FROM "+_cBDados+".TTRA  A " +CRLF
	_cQry += " WHERE RTRIM(CODCOLIGADA) IN  ('0','9','10','11') " +CRLF
	_cQry += " ORDER BY CODCOLIGADA,CODTRA" +CRLF

	TcQuery _cQry New Alias "TTRAN"

	_nReg := Contar("TTRAN","!EOF()")

	If _nReg > 0

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

		_nRegAtu := 0

		TTRAN->(dbGoTop())

		While TTRAN->(!EOF())

			_cKey1   := Alltrim(cValToChar(TTRAN->CODCOLIGADA))
			_cCodTr  := "000000"

			If U_RMCriarDTC(_cTab,_cKey1)

				While TTRAN->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TTRAN->CODCOLIGADA))

					_nRegAtu ++
					_cCodTr := Soma1(_cCodTr)

					_oProcess:IncRegua2("Gerando tabela "+_cTab)
					// _oProcess:IncRegua2("Gerando tabela "+_cTab+" - Registro "+Alltrim(str(_nRegAtu))+" de "+Alltrim(str(_nReg)))

					TRM->(RecLock("TRM",.T.))
					TRM->A4_YCODRM  := TTRAN->CODTRA
					TRM->A4_COD     := _cCodTr
					TRM->A4_NOME	:= U_RM_NoAcento(UPPER(Alltrim(TTRAN->NOME)))
					TRM->A4_NREDUZ  := U_RM_NoAcento(UPPER(Alltrim(TTRAN->NOMEFANTASIA)))
					// TRM->A4_MSBLQL	:= (TTRAN->INATIVO=1,"1","2")
					TRM->A4_END  	:= U_RM_NoAcento(UPPER(Alltrim(TTRAN->RUA)))+', '+Alltrim(TTRAN->NUMERO)
					TRM->A4_COMPLEM := U_RM_NoAcento(UPPER(Alltrim(TTRAN->COMPLEMENTO)))
					TRM->A4_MUN 	:= TTRAN->CIDADE
					TRM->A4_COD_MUN	:= TTRAN->CODMUNICIPIO
					TRM->A4_BAIRRO	:= U_RM_NoAcento(UPPER(Alltrim(TTRAN->BAIRRO)))
					TRM->A4_EST 	:= TTRAN->CODETD
					TRM->A4_CEP 	:= TTRAN->CEP
					// TRM->A4_DDD 	:= TTRAN->
					TRM->A4_TEL 	:= TTRAN->TELEFONE
					TRM->A4_CGC		:= Alltrim(StrTran(StrTran(StrTran(TTRAN->CGC,".",""),"-",""),"/",""))
					TRM->A4_INSEST	:= TTRAN->INSCRESTADUAL
					TRM->A4_EMAIL	:= TTRAN->EMAIL
					TRM->A4_CONTATO	:= TTRAN->CONTATO
					TRM->A4_CODPAIS	:= '01058'
					TRM->A4_INSCRM	:= TTRAN->INSCRMUNICIPAL
					TRM->(MsUnLock())

					// _oProcess:IncRegua2("Gerando tabela "+_cTab)

					TTRAN->(dbSkip())
				EndDo

			Endif
		EndDo
	Endif

	TTRAN->(dbCloseArea())

Return(Nil)