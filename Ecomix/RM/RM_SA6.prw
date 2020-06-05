#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_SA6
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas SA6
*/

USER FUNCTION RM_SA6E(_oProcess,_cTab,_cPasta,_cBDados)

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

	TRM->(dbCloseArea())

Return(Nil)




USER FUNCTION RM_SA6I(_oProcess,_cTab,_cPasta)

	Local _cAlias   := ''
	Local _lTabLoc  := .T.
	Local _cModo
	Local _nSA6
	Local _aArea     := GetArea()
	Local _aAreaSA6  := SA6->( GetArea() )
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvArqTab := cArqTab //Salva os arquivos de

	If Alltrim(cEmpAnt) = Substr(_cTab,4,2)
		_cAlias := "SA6"
	Else

		If EmpOpenFile("SA6A","SA6",1,.T., Substr(_cTab,4,2),@_cModo)
			_cAlias := "SA6A"
			_lTabLoc := .F.
		Endif
	Endif

	If !Empty(_cAlias)

		_cUpd := " DELETE "+_cTab

		TCSQLEXEC(_cUpd )

		_cArq	:= "\TAB_RM\"+_cPasta+"\"+_cTab+".dtc"		//Gera o nome do arquivo
		_cInd	:= "\TAB_RM\"+_cPasta+"\"+_cTab+"0"			//Indice do arquivo

		If SELECT("TSA6") > 0
			TSA6->(dbCloseArea())
		Endif

		dbUseArea( .T.,"CTREECDX", _cArq,"TSA6", .T., .F. )

		If Select("TSA6") = 0
			MsgInfo( 'Erro Abrir tabela Temporária TSA6', 'RM_SA6' )
			Return(Nil)
		Endif

		dbSelectArea("TSA6")

		IndRegua( "TSA6", _cInd, SA6->( IndexKey( 1 ) ))

		dbClearIndex()
		dbSetIndex(_cInd + OrdBagExt() )

		_nReg := Contar("TSA6","!EOF()")

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso
		_oProcess:IncRegua2("Importando a tabela "+Left(_cTab,3)+" na Empresa "+Substr(_cTab,4,2) )



		TSA6->(dbGoTop())

		While TSA6->(!EOF())

			(_cAlias)->(RecLock(_cAlias,.T.))
			For _nSA6 := 1 to (_cAlias)->(FCOUNT())
				&("(_cAlias)->"+((_cAlias)->(FIELD(_nSA6)))) := &("TSA6->"+((_cAlias)->(FIELD(_nSA6))))
			Next _nSA6
			(_cAlias)->(MsUnLock())

			TSA6->(dbSkip())
		EndDo

		TSA6->(dbCloseArea())

		If !_lTabLoc
			(_cAlias)->(dbCloseArea())
		Endif

	Endif

	//Restaura os Dados de Entrada ( Ambiente )
	cFilAnt := _cSvFilAnt
	cEmpAnt := _cSvEmpAnt
	cArqTab := _cSvArqTab

	//Restaura os ponteiros das Tabelas

	RestArea( _aAreaSA6 )
	RestArea( _aArea )

Return(Nil)