#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_DA0
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas DA0
*/

USER FUNCTION RM_DA0E(_oProcess,_cTab,_cPasta,_cBDados)

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

	TRM->(dbCloseArea())

Return(Nil)



USER FUNCTION RM_DA0I(_oProcess,_cTab,_cPasta)

	Local _cAlias   := ''
	Local _lTabLoc  := .T.
	Local _cModo
	Local _nDA0
	Local _aArea     := GetArea()
	Local _aAreaDA0  := DA0->( GetArea() )
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvArqTab := cArqTab //Salva os arquivos de

	If Alltrim(cEmpAnt) = Substr(_cTab,4,2)
		_cAlias := "DA0"
	Else

		If EmpOpenFile("DA0A","DA0",1,.T., Substr(_cTab,4,2),@_cModo)
			_cAlias := "DA0A"
			_lTabLoc := .F.
		Endif
	Endif

	If !Empty(_cAlias)

		_cUpd := " DELETE "+_cTab

		TCSQLEXEC(_cUpd )

		_cArq	:= "\TAB_RM\"+_cPasta+"\"+_cTab+".dtc"		//Gera o nome do arquivo
		_cInd	:= "\TAB_RM\"+_cPasta+"\"+_cTab+"0"			//Indice do arquivo

		If SELECT("TDA0") > 0
			TDA0->(dbCloseArea())
		Endif

		dbUseArea( .T.,"CTREECDX", _cArq,"TDA0", .T., .F. )

		If Select("TDA0") = 0
			MsgInfo( 'Erro Abrir tabela Temporária TDA0', 'RM_DA0' )
			Return(Nil)
		Endif

		dbSelectArea("TDA0")

		IndRegua( "TDA0", _cInd, DA0->( IndexKey( 1 ) ))

		dbClearIndex()
		dbSetIndex(_cInd + OrdBagExt() )

		_nReg := Contar("TDA0","!EOF()")

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso
		_oProcess:IncRegua2("Importando a tabela "+Left(_cTab,3)+" na Empresa "+Substr(_cTab,4,2) )



		TDA0->(dbGoTop())

		While TDA0->(!EOF())

			(_cAlias)->(RecLock(_cAlias,.T.))
			For _nDA0 := 1 to (_cAlias)->(FCOUNT())
				&("(_cAlias)->"+((_cAlias)->(FIELD(_nDA0)))) := &("TDA0->"+((_cAlias)->(FIELD(_nDA0))))
			Next _nDA0
			(_cAlias)->(MsUnLock())

			TDA0->(dbSkip())
		EndDo

		TDA0->(dbCloseArea())

		If !_lTabLoc
			(_cAlias)->(dbCloseArea())
		Endif

	Endif

	//Restaura os Dados de Entrada ( Ambiente )
	cFilAnt := _cSvFilAnt
	cEmpAnt := _cSvEmpAnt
	cArqTab := _cSvArqTab

	//Restaura os ponteiros das Tabelas

	RestArea( _aAreaDA0 )
	RestArea( _aArea )

Return(Nil)