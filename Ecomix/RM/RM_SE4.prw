#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_SE4
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas SE4
*/

USER FUNCTION RM_SE4E(_oProcess,_cTab,_cPasta,_cBDados)

/*
			If Select("TCONPAG") > 0
				TCONPAG->(dbCloseArea())
			Endif

			_cQry := " SELECT TOP 5 * FROM "+_cBDados+".TCPG " +CRLF
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

			
			TRM->(dbCloseArea())
			*/


Return(Nil)




USER FUNCTION RM_SE4I(_oProcess,_cTab,_cPasta)

	Local _cAlias   := ''
	Local _lTabLoc  := .T.
	Local _cModo
	Local _nSE4
	Local _aArea     := GetArea()
	Local _aAreaSE4  := SE4->( GetArea() )
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvArqTab := cArqTab //Salva os arquivos de

	If Alltrim(cEmpAnt) = Substr(_cTab,4,2)
		_cAlias := "SE4"
	Else

		If EmpOpenFile("SE4A","SE4",1,.T., Substr(_cTab,4,2),@_cModo)
			_cAlias := "SE4A"
			_lTabLoc := .F.
		Endif
	Endif

	If !Empty(_cAlias)

		_cUpd := " DELETE "+_cTab

		TCSQLEXEC(_cUpd )

		_cArq	:= "\TAB_RM\"+_cPasta+"\"+_cTab+".dtc"		//Gera o nome do arquivo
		_cInd	:= "\TAB_RM\"+_cPasta+"\"+_cTab+"0"			//Indice do arquivo

		If SELECT("TSE4") > 0
			TSE4->(dbCloseArea())
		Endif

		dbUseArea( .T.,"CTREECDX", _cArq,"TSE4", .T., .F. )

		If Select("TSE4") = 0
			MsgInfo( 'Erro Abrir tabela Temporária TSE4', 'RM_SE4' )
			Return(Nil)
		Endif

		dbSelectArea("TSE4")

		IndRegua( "TSE4", _cInd, SE4->( IndexKey( 1 ) ))

		dbClearIndex()
		dbSetIndex(_cInd + OrdBagExt() )

		_nReg := Contar("TSE4","!EOF()")

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso
		_oProcess:IncRegua2("Importando a tabela "+Left(_cTab,3)+" na Empresa "+Substr(_cTab,4,2) )



		TSE4->(dbGoTop())

		While TSE4->(!EOF())

			(_cAlias)->(RecLock(_cAlias,.T.))
			For _nSE4 := 1 to (_cAlias)->(FCOUNT())
				&("(_cAlias)->"+((_cAlias)->(FIELD(_nSE4)))) := &("TSE4->"+((_cAlias)->(FIELD(_nSE4))))
			Next _nSE4
			(_cAlias)->(MsUnLock())

			TSE4->(dbSkip())
		EndDo

		TSE4->(dbCloseArea())

		If !_lTabLoc
			(_cAlias)->(dbCloseArea())
		Endif

	Endif

	//Restaura os Dados de Entrada ( Ambiente )
	cFilAnt := _cSvFilAnt
	cEmpAnt := _cSvEmpAnt
	cArqTab := _cSvArqTab

	//Restaura os ponteiros das Tabelas

	RestArea( _aAreaSE4 )
	RestArea( _aArea )

Return(Nil)