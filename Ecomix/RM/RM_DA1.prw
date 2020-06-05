#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_DA1
Autor 		: Fabiano da Silva	-	25/03/20
Descri��o 	: Exportar tabelas DA1
*/

USER FUNCTION RM_DA1E(_oProcess,_cTab,_cPasta,_cBDados)

	If Select("TIPRC") > 0
		TIPRC->(dbCloseArea())
	Endif

	_cQry := " SELECT B.CODIGOPRD,* FROM "+_cBDados+".TTABPRECOPRD  A " +CRLF
	_cQry += " INNER JOIN "+_cBDados+".TPRODUTO B ON A.IDPRD = B.IDPRD  " +CRLF
	_cQry += " WHERE RTRIM(CODCOLIGADA) IN  ('0','9','10','11') " +CRLF
	_cQry += " ORDER BY A.CODCOLIGADA, A.IDTABPRECO,B.CODIGOPRD" +CRLF

	TcQuery _cQry New Alias "TIPRC"

	_nReg := Contar("TIPRC","!EOF()")

	If _nReg > 0

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

		_nRegAtu := 0

		TIPRC->(dbGoTop())

		While TIPRC->(!EOF())

			_cKey1   := Alltrim(cValToChar(TIPRC->CODCOLIGADA))

			If U_RMCriarDTC(_cTab,_cKey1)

				While TIPRC->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TIPRC->CODCOLIGADA))

					_cItem := Padl("",TAMSX3("DA1_ITEM")[1],"0")
					_cKey2   := Alltrim(cValToChar(TIPRC->CODCOLIGADA)) + Alltrim(cValToChar(TIPRC->IDTABPRECO))
					While TIPRC->(!EOF()) .And. _cKey2 == Alltrim(cValToChar(TIPRC->CODCOLIGADA))  + Alltrim(cValToChar(TIPRC->IDTABPRECO))

						_nRegAtu ++

						// _oProcess:IncRegua2("Gerando tabela "+_cTab)
						_oProcess:IncRegua2("Gerando tabela "+_cTab+" - Registro "+Alltrim(str(_nRegAtu))+" de "+Alltrim(str(_nReg)))


						_cItem := Soma1(_cItem)

						TRM->(RecLock("TRM",.T.))
						TRM->DA1_YID       := TIPRC->IDTABPRECO
						// TRM->DA1_FILIAL
						TRM->DA1_CODTAB    := Padl(cValtoChar(TIPRC->IDTABPRECO),TAMSX3("DA0_CODTAB")[1],"0")
						TRM->DA1_ITEM      := _cItem
						TRM->DA1_CODPRO    := Alltrim(StrTran(TIPRC->CODIGOPRD,".",""))
						TRM->DA1_PRCVEN    := TIPRC->PRECO
						TRM->DA1_TPOPER    := "4"
						TRM->DA1_DATVIG    := TIPRC->DATAVIGENCIAFIM
						TRM->DA1_QTDLOT    := 999999.99
						TRM->DA1_ATIVO     := cValTocHar(TIPRC->ATIVO)
						TRM->DA1_MOEDA  := 1
						// TRM->DA1_GRUPO
						// TRM->DA1_REFGRD
						// TRM->DA1_VLRDES := 0
						// TRM->DA1_PERDES := 0
						// TRM->DA1_FRETE
						// TRM->DA1_ESTADO := TIPRC->
						// TRM->DA1_INDLOT := TIPRC->
						// TRM->DA1_ITEMGR := TIPRC->
						// TRM->DA1_PRCMAX := TIPRC->
						// TRM->DA1_DTUMOV := TIPRC->
						// TRM->DA1_HRUMOV := TIPRC->
						// TRM->DA1_ECDTEX := TIPRC->
						// TRM->DA1_ECSEQ  := TIPRC->
						// TRM->DA1_MSEXP  := TIPRC->
						// TRM->DA1_HREXPO := TIPRC->
						// TRM->DA1_TIPPRE := TIPRC->
						TRM->(MsUnLock())

						TIPRC->(dbSkip())
					EndDo
				EndDo
			Endif
		EndDo
	Endif

	TIPRC->(dbCloseArea())

	TRM->(dbCloseArea())

Return(Nil)




USER FUNCTION RM_DA1I(_oProcess,_cTab,_cPasta)

	Local _cAlias   := ''
	Local _lTabLoc  := .T.
	Local _cModo
	Local _nDA1
	Local _aArea     := GetArea()
	Local _aAreaDA1  := DA1->( GetArea() )
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvArqTab := cArqTab //Salva os arquivos de

	If Alltrim(cEmpAnt) = Substr(_cTab,4,2)
		_cAlias := "DA1"
	Else

		If EmpOpenFile("DA1A","DA1",1,.T., Substr(_cTab,4,2),@_cModo)
			_cAlias := "DA1A"
			_lTabLoc := .F.
		Endif
	Endif

	If !Empty(_cAlias)

		_cUpd := " DELETE "+_cTab

		TCSQLEXEC(_cUpd )

		_cArq	:= "\TAB_RM\"+_cPasta+"\"+_cTab+".dtc"		//Gera o nome do arquivo
		_cInd	:= "\TAB_RM\"+_cPasta+"\"+_cTab+"0"			//Indice do arquivo

		If SELECT("TDA1") > 0
			TDA1->(dbCloseArea())
		Endif

		dbUseArea( .T.,"CTREECDX", _cArq,"TDA1", .T., .F. )

		If Select("TDA1") = 0
			MsgInfo( 'Erro Abrir tabela Tempor�ria TDA1', 'RM_DA1' )
			Return(Nil)
		Endif

		dbSelectArea("TDA1")

		IndRegua( "TDA1", _cInd, DA1->( IndexKey( 1 ) ))

		dbClearIndex()
		dbSetIndex(_cInd + OrdBagExt() )

		_nReg := Contar("TDA1","!EOF()")

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso
		_oProcess:IncRegua2("Importando a tabela "+Left(_cTab,3)+" na Empresa "+Substr(_cTab,4,2) )



		TDA1->(dbGoTop())

		While TDA1->(!EOF())

			(_cAlias)->(RecLock(_cAlias,.T.))
			For _nDA1 := 1 to (_cAlias)->(FCOUNT())
				&("(_cAlias)->"+((_cAlias)->(FIELD(_nDA1)))) := &("TDA1->"+((_cAlias)->(FIELD(_nDA1))))
			Next _nDA1
			(_cAlias)->(MsUnLock())

			TDA1->(dbSkip())
		EndDo

		TDA1->(dbCloseArea())

		If !_lTabLoc
			(_cAlias)->(dbCloseArea())
		Endif

	Endif

	//Restaura os Dados de Entrada ( Ambiente )
	cFilAnt := _cSvFilAnt
	cEmpAnt := _cSvEmpAnt
	cArqTab := _cSvArqTab

	//Restaura os ponteiros das Tabelas

	RestArea( _aAreaDA1 )
	RestArea( _aArea )

Return(Nil)