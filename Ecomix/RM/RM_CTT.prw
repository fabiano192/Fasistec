#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_CTT
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas CTT
*/

USER FUNCTION RM_CTTE(_oProcess,_cTab,_cPasta,_cBDados)

	If Select("TCUSTO") > 0
		TCUSTO->(dbCloseArea())
	Endif

	_cQry := " SELECT * FROM "+_cBDados+".GCCUSTO " +CRLF
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
					If CTT->(FieldPos("CTT_MSBLQL")) > 0
						TRM->CTT_MSBLQL	:= If(TCUSTO->ATIVO='T',"2","1")
					Endif
					TRM->(MsUnLock())

					// _oProcess:IncRegua2("Gerando tabela "+_cTab)

					TCUSTO->(dbSkip())
				EndDo

			Endif
		EndDo
	Endif

	TCUSTO->(dbCloseArea())

	TRM->(dbCloseArea())

Return(Nil)



USER FUNCTION RM_CTTI(_oProcess,_cTab,_cPasta)

	Local _cAlias   := ''
	Local _lTabLoc  := .T.
	Local _cModo
	Local _nCTT
	Local _aArea     := GetArea()
	Local _aAreaCTT  := CTT->( GetArea() )
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvArqTab := cArqTab //Salva os arquivos de

	If Alltrim(cEmpAnt) = Substr(_cTab,4,2)
		_cAlias := "CTT"
	Else

		If EmpOpenFile("CTTA","CTT",1,.T., Substr(_cTab,4,2),@_cModo)
			_cAlias := "CTTA"
			_lTabLoc := .F.
		Endif
	Endif

	If !Empty(_cAlias)

		_cUpd := " DELETE "+_cTab

		TCSQLEXEC(_cUpd )

		_cArq	:= "\TAB_RM\"+_cPasta+"\"+_cTab+".dtc"		//Gera o nome do arquivo
		_cInd	:= "\TAB_RM\"+_cPasta+"\"+_cTab+"0"			//Indice do arquivo

		If SELECT("TCTT") > 0
			TCTT->(dbCloseArea())
		Endif

		dbUseArea( .T.,"CTREECDX", _cArq,"TCTT", .T., .F. )

		If Select("TCTT") = 0
			MsgInfo( 'Erro Abrir tabela Temporária TCTT', 'RM_CTT' )
			Return(Nil)
		Endif

		dbSelectArea("TCTT")

		IndRegua( "TCTT", _cInd, CTT->( IndexKey( 1 ) ))

		dbClearIndex()
		dbSetIndex(_cInd + OrdBagExt() )

		_nReg := Contar("TCTT","!EOF()")

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso
		_oProcess:IncRegua2("Importando a tabela "+Left(_cTab,3)+" na Empresa "+Substr(_cTab,4,2) )



		TCTT->(dbGoTop())

		While TCTT->(!EOF())

			(_cAlias)->(RecLock(_cAlias,.T.))
			For _nCTT := 1 to (_cAlias)->(FCOUNT())
				&("(_cAlias)->"+((_cAlias)->(FIELD(_nCTT)))) := &("TCTT->"+((_cAlias)->(FIELD(_nCTT))))
			Next _nCTT
			(_cAlias)->(MsUnLock())

			TCTT->(dbSkip())
		EndDo

		TCTT->(dbCloseArea())

		If !_lTabLoc
			(_cAlias)->(dbCloseArea())
		Endif

	Endif

	//Restaura os Dados de Entrada ( Ambiente )
	cFilAnt := _cSvFilAnt
	cEmpAnt := _cSvEmpAnt
	cArqTab := _cSvArqTab

	//Restaura os ponteiros das Tabelas

	RestArea( _aAreaCTT )
	RestArea( _aArea )

Return(Nil)