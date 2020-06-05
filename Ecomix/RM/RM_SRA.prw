#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_SRA
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas SRA
*/

USER FUNCTION RM_SRAE(_oProcess,_cTab,_cPasta,_cBDados)

	If Select("TFUNC") > 0
		TFUNC->(dbCloseArea())
	Endif

	_cQry := " SELECT * FROM "+_cBDados+".FCONTA A " + CRLF
	_cQry += " INNER JOIN "+_cBDados+".GBANCO B ON A.NUMBANCO = B.NUMBANCO " + CRLF
	_cQry += " WHERE RTRIM(A.CODCOLIGADA) IN  ('0','9','10','11')  " + CRLF
	_cQry += " ORDER BY A.CODCOLIGADA " + CRLF

	TcQuery _cQry New Alias "TFUNC"

	_nReg := Contar("TFUNC","!EOF()")

	If _nReg > 0

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

		_nRegAtu := 0

		TFUNC->(dbGoTop())

		While TFUNC->(!EOF())

			_cKey1   := Alltrim(cValToChar(TFUNC->CODCOLIGADA))

			If U_RMCriarDTC(_cTab,_cKey1)

				While TFUNC->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TFUNC->CODCOLIGADA))
/*
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
*/
					TFUNC->(dbSkip())
				EndDo

			Endif
		EndDo
	Endif

	TFUNC->(dbCloseArea())

	TRM->(dbCloseArea())

Return(Nil)



USER FUNCTION RM_SRAI(_oProcess,_cTab,_cPasta)

	Local _cAlias   := ''
	Local _lTabLoc  := .T.
	Local _cModo
	Local _nSRA
	Local _aArea     := GetArea()
	Local _aAreaSRA  := SRA->( GetArea() )
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvArqTab := cArqTab //Salva os arquivos de

	If Alltrim(cEmpAnt) = Substr(_cTab,4,2)
		_cAlias := "SRA"
	Else

		If EmpOpenFile("SRAA","SRA",1,.T., Substr(_cTab,4,2),@_cModo)
			_cAlias := "SRAA"
			_lTabLoc := .F.
		Endif
	Endif

	If !Empty(_cAlias)

		_cUpd := " DELETE "+_cTab

		TCSQLEXEC(_cUpd )

		_cArq	:= "\TAB_RM\"+_cPasta+"\"+_cTab+".dtc"		//Gera o nome do arquivo
		_cInd	:= "\TAB_RM\"+_cPasta+"\"+_cTab+"0"			//Indice do arquivo

		If SELECT("TSRA") > 0
			TSRA->(dbCloseArea())
		Endif

		dbUseArea( .T.,"CTREECDX", _cArq,"TSRA", .T., .F. )

		If Select("TSRA") = 0
			MsgInfo( 'Erro Abrir tabela Temporária TSRA', 'RM_SRA' )
			Return(Nil)
		Endif

		dbSelectArea("TSRA")

		IndRegua( "TSRA", _cInd, SRA->( IndexKey( 1 ) ))

		dbClearIndex()
		dbSetIndex(_cInd + OrdBagExt() )

		_nReg := Contar("TSRA","!EOF()")

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso
		_oProcess:IncRegua2("Importando a tabela "+Left(_cTab,3)+" na Empresa "+Substr(_cTab,4,2) )



		TSRA->(dbGoTop())

		While TSRA->(!EOF())

			(_cAlias)->(RecLock(_cAlias,.T.))
			For _nSRA := 1 to (_cAlias)->(FCOUNT())
				&("(_cAlias)->"+((_cAlias)->(FIELD(_nSRA)))) := &("TSRA->"+((_cAlias)->(FIELD(_nSRA))))
			Next _nSRA
			(_cAlias)->(MsUnLock())

			TSRA->(dbSkip())
		EndDo

		TSRA->(dbCloseArea())

		If !_lTabLoc
			(_cAlias)->(dbCloseArea())
		Endif

	Endif

	//Restaura os Dados de Entrada ( Ambiente )
	cFilAnt := _cSvFilAnt
	cEmpAnt := _cSvEmpAnt
	cArqTab := _cSvArqTab

	//Restaura os ponteiros das Tabelas

	RestArea( _aAreaSRA )
	RestArea( _aArea )

Return(Nil)