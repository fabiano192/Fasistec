#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_CT1
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas CT1
*/

USER FUNCTION RM_CT1(_oProcess,_cTab,_cPasta)

	If Select("TCONTA") > 0
		TCONTA->(dbCloseArea())
	Endif

	_cQry := " SELECT * FROM DADOSRM..CCONTA " +CRLF
	_cQry += " WHERE CODCOLIGADA = '0' " +CRLF
	_cQry += " ORDER BY CODCONTA " +CRLF

	TcQuery _cQry New Alias "TCONTA"

	_nReg := Contar("TCONTA","!EOF()")

	If _nReg > 0

		If U_RMCriarDTC(_cTab)

			_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

			_nRegAtu := 0

			TCONTA->(dbGoTop())

			While TCONTA->(!EOF())

				_nRegAtu ++

				_oProcess:IncRegua2("Gerando tabela "+_cTab)
				// _oProcess:IncRegua2("Gerando tabela "+_cTab+" - Registro "+Alltrim(str(_nRegAtu))+" de "+Alltrim(str(_nReg)))

				TRM->(RecLock("TRM",.T.))
				TRM->CT1_YID   := TCONTA->IDMOV
				// TRM->CT1_FILIAL :=
				TRM->CT1_CLASSE := If(TCONTA->ANALITICA=0,'1','2')
				TRM->CT1_CONTA  := Alltrim(StrTran(TCONTA->CODCONTA,".",""))
				TRM->CT1_DESC01 := Alltrim(TCONTA->DESCRICAO)
				TRM->CT1_NORMAL := "2"
				TRM->CT1_RES    := TCONTA->REDUZIDO
				TRM->CT1_BLOQ   := If(TCONTA->INATIVA=0,'2','1')
				TRM->CT1_NTSPED := TCONTA->NATSPED
				// TRM->CT1_DC     :=
				TRM->CT1_CVD02  := "1"
				TRM->CT1_CVD03  := "1"
				TRM->CT1_CVD04  := "1"
				TRM->CT1_CVD05  := "1"
				TRM->CT1_CVC02  := "1"
				TRM->CT1_CVC03  := "1"
				TRM->CT1_CVC04  := "1"
				TRM->CT1_CVC05  := "1"
				// TRM->CT1_CTASUP :=
				TRM->CT1_DTEXIS := CTOD('25/03/2020')
				TRM->CT1_AGLSLD := "2"
				TRM->CT1_CCOBRG := "2"
				TRM->CT1_ITOBRG := "2"
				TRM->CT1_CLOBRG := "2"
				// TRM->CT1_CTLALU :=
				TRM->CT1_LALHIR := "2"
				// TRM->CT1_NATCTA :=
				TRM->CT1_ACATIV := "2"
				TRM->CT1_ATOBRG := "2"
				TRM->CT1_ACET05 := "2"
				TRM->CT1_05OBRG := "2"
				TRM->CT1_SPEDST := "2"
				TRM->CT1_ACITEM := "1"
				TRM->CT1_ACCUST := "1"
				TRM->CT1_ACCLVL := "1"
				TRM->(MsUnLock())

				TCONTA->(dbSkip())
			EndDo

		Endif
	Endif

	TCONTA->(dbCloseArea())

Return(Nil)