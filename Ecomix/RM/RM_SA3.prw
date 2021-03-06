#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_SA3
Autor 		: Fabiano da Silva	-	25/03/20
Descri��o 	: Exportar tabelas SA3
*/

USER FUNCTION RM_SA3E(_oProcess,_cTab,_cPasta,_cBDados)

	If Select("TVEN") > 0
		TVEN->(dbCloseArea())
	Endif

	_cQry := " SELECT * FROM "+_cBDados+".TVEN A " +CRLF
	_cQry += " WHERE RTRIM(CODCOLIGADA) IN  ('0','9','10','11') " +CRLF
	_cQry += " ORDER BY CODCOLIGADA,CODVEN" +CRLF

	TcQuery _cQry New Alias "TVEN"

	_nReg := Contar("TVEN","!EOF()")

	If _nReg > 0

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

		_nRegAtu := 0

		TVEN->(dbGoTop())

		While TVEN->(!EOF())

			_cKey1   := Alltrim(cValToChar(TVEN->CODCOLIGADA))

			If U_RMCriarDTC(_cTab,_cKey1)

				While TVEN->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TVEN->CODCOLIGADA))

					_nRegAtu ++

					// _oProcess:IncRegua2("Gerando tabela "+_cTab)
					_oProcess:IncRegua2("Gerando tabela "+_cTab+" - Registro "+Alltrim(str(_nRegAtu))+" de "+Alltrim(str(_nReg)))

					TRM->(RecLock("TRM",.T.))
					TRM->A3_YID        := TVEN->IDFUNCIONARIO
					// TRM->A3_FILIAL  := TVEN->CODFILIAL
					TRM->A3_COD        := Padl(Alltrim(TVEN->CODVEN),TAMSX3("A3_COD")[1],"0")
					TRM->A3_NOME       := U_RM_NoAcento(UPPER(Alltrim(TVEN->NOME)))
					TRM->A3_NREDUZ     := U_RM_NoAcento(UPPER(Alltrim(TVEN->NOME)))
					TRM->A3_MSBLQL     := (TVEN->INATIVO=1,"1","2")
					TRM->A3_SENHA      := TVEN->SENHA
					TRM->A3_COMIS      := TVEN->COMISSAO1
					TRM->A3_ALEMISS    := 0
					TRM->A3_ALBAIXA    := 100

					// TRM->A3_SUPER   := TVEN->PFSUPERVISOR
					// TRM->A3_GEREN   := TVEN->PFGERENTE
					// TRM->A3_END     := TVEN->
					// TRM->A3_BAIRRO  := TVEN->
					// TRM->A3_MUN     := TVEN->
					// TRM->A3_EST     := TVEN->
					// TRM->A3_DDDTEL  := TVEN->
					// TRM->A3_CEP     := TVEN->
					// TRM->A3_TEL     := TVEN->
					// TRM->A3_TIPO    := TVEN->
					// TRM->B1_LOCPAD  := TVEN->
					// TRM->A3_CGC     := TVEN->
					// TRM->A3_INSCR   := TVEN->
					// TRM->A3_INSCRM  := TVEN->
					// TRM->A3_EMAIL   := TVEN->
					// TRM->A3_CODUSR  := TVEN->
					// TRM->A3_FORNECE := TVEN->
					// TRM->A3_LOJA    := TVEN->
					// TRM->A3_GERASE2 := TVEN->
					// TRM->A3_BCO1    := TVEN->
					// TRM->A3_REGIAO  := TVEN->
					// TRM->A3_ICM     := TVEN->
					// TRM->A3_ICMSRET := TVEN->
					// TRM->A3_ISS     := TVEN->
					// TRM->A3_IPI     := TVEN->
					// TRM->A3_FRETE   := TVEN->
					// TRM->A3_ACREFIN := TVEN->
					// TRM->A3_DIA     := TVEN->
					// TRM->A3_DDD     := TVEN->
					// TRM->A3_TIPSUP  := TVEN->
					// TRM->A3_PERDESC := TVEN->
					// TRM->A3_DIARESE := TVEN->
					// TRM->A3_UNIDAD  := TVEN->
					// TRM->A3_HAND    := TVEN->
					// TRM->A3_PEDINI  := TVEN->
					// TRM->A3_QTCONTA := TVEN->
					// TRM->A3_PEDFIM  := TVEN->
					// TRM->A3_REGSLA  := TVEN->
					// TRM->A3_CLIINI  := TVEN->
					// TRM->A3_CARGO   := TVEN->
					// TRM->A3_CLIFIM  := TVEN->
					// TRM->A3_PROXPED := TVEN->
					// TRM->A3_PROXCLI := TVEN->
					// TRM->A3_GRPREP  := TVEN->
					// TRM->A3_FAT_RH  := TVEN->
					// TRM->A3_GRUPSAN := TVEN->
					// TRM->A3_DEPEND  := TVEN->
					// TRM->A3_TIPVEND := TVEN->
					// TRM->A3_PAIS    := TVEN->
					// TRM->A3_CEL     := TVEN->
					// TRM->A3_ADMISS  := TVEN->
					// TRM->A3_NIVEL   := TVEN->
					TRM->(MsUnLock())

// A3_PEN_ALI              A3_URLEXG   A3_NUMRA  A3_DDI            A3_NVLSTR        A3_LANEXG A3_PISCOF A3_BASEIR A3_CODISS  A3_SINCTAF A3_SINCAGE A3_SINCCON A3_PERAGE A3_PERTAF A3_TIMEMIN A3_USUCORP                     A3_HABSINC A3_EMACORP    A3_BIAGEND A3_BITAREF A3_BICONT A3_MSEXP A3_HREXPO A3_DTUMOV A3_HRUMOV A3_USERLGI        A3_USERLGA        A3_MODTRF A3_SNAEXG

					TVEN->(dbSkip())
				EndDo

			Endif
		EndDo
	Endif

	TVEN->(dbCloseArea())

	TRM->(dbCloseArea())

Return(Nil)




USER FUNCTION RM_SA3I(_oProcess,_cTab,_cPasta)

	Local _cAlias   := ''
	Local _lTabLoc  := .T.
	Local _cModo
	Local _nSA3
	Local _aArea     := GetArea()
	Local _aAreaSA3  := SA3->( GetArea() )
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvArqTab := cArqTab //Salva os arquivos de

	If Alltrim(cEmpAnt) = Substr(_cTab,4,2)
		_cAlias := "SA3"
	Else

		If EmpOpenFile("SA3A","SA3",1,.T., Substr(_cTab,4,2),@_cModo)
			_cAlias := "SA3A"
			_lTabLoc := .F.
		Endif
	Endif

	If !Empty(_cAlias)

		_cUpd := " DELETE "+_cTab

		TCSQLEXEC(_cUpd )

		_cArq	:= "\TAB_RM\"+_cPasta+"\"+_cTab+".dtc"		//Gera o nome do arquivo
		_cInd	:= "\TAB_RM\"+_cPasta+"\"+_cTab+"0"			//Indice do arquivo

		If SELECT("TSA3") > 0
			TSA3->(dbCloseArea())
		Endif

		dbUseArea( .T.,"CTREECDX", _cArq,"TSA3", .T., .F. )

		If Select("TSA3") = 0
			MsgInfo( 'Erro Abrir tabela Tempor�ria TSA3', 'RM_SA3' )
			Return(Nil)
		Endif

		dbSelectArea("TSA3")

		IndRegua( "TSA3", _cInd, SA3->( IndexKey( 1 ) ))

		dbClearIndex()
		dbSetIndex(_cInd + OrdBagExt() )

		_nReg := Contar("TSA3","!EOF()")

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso
		_oProcess:IncRegua2("Importando a tabela "+Left(_cTab,3)+" na Empresa "+Substr(_cTab,4,2) )



		TSA3->(dbGoTop())

		While TSA3->(!EOF())

			(_cAlias)->(RecLock(_cAlias,.T.))
			For _nSA3 := 1 to (_cAlias)->(FCOUNT())
				&("(_cAlias)->"+((_cAlias)->(FIELD(_nSA3)))) := &("TSA3->"+((_cAlias)->(FIELD(_nSA3))))
			Next _nSA3
			(_cAlias)->(MsUnLock())

			TSA3->(dbSkip())
		EndDo

		TSA3->(dbCloseArea())

		If !_lTabLoc
			(_cAlias)->(dbCloseArea())
		Endif

	Endif

	//Restaura os Dados de Entrada ( Ambiente )
	cFilAnt := _cSvFilAnt
	cEmpAnt := _cSvEmpAnt
	cArqTab := _cSvArqTab

	//Restaura os ponteiros das Tabelas

	RestArea( _aAreaSA3 )
	RestArea( _aArea )

Return(Nil)