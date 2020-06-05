#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_CT1
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas CT1
*/

USER FUNCTION RM_CT1E(_oProcess,_cTab,_cPasta,_cBDados)

	If Select("TCONTA") > 0
		TCONTA->(dbCloseArea())
	Endif

	_cQry := " SELECT * FROM "+_cBDados+".CCONTA " +CRLF
	// _cQry := " SELECT * FROM DADOSRM..CCONTA " +CRLF
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
				TRM->CT1_YID   := TCONTA->ID
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

				
				_cKey1 := Alltrim(cValToChar(TCONTA->CODCOLIGADA))
				// _cCodEmp := "01"
				_cCodEmp := _aEmp[aScan(_aEmp,{|x| x[1] = PadL(_cKey1,2,"0")})][2]

				_cAliZF6 := 'ZF6'+_cCodEmp

				(_cAliZF6)->(RecLock(_cAliZF6,.T.))
				// (_cAliZF6)->ZF6_FILIAL := 
				(_cAliZF6)->ZF6_TABELA := "CT1"
				(_cAliZF6)->ZF6_CAMPO  := "CT1_CONTA"
				(_cAliZF6)->ZF6_CODRM  := TCONTA->CODCONTA
				(_cAliZF6)->ZF6_IDRM   := TCONTA->ID
				(_cAliZF6)->ZF6_TOTVS  := Alltrim(StrTran(TCONTA->CODCONTA,".",""))
				(_cAliZF6)->(MsUnLock())

				TCONTA->(dbSkip())
			EndDo

		Endif
	Endif

	TCONTA->(dbCloseArea())

	TRM->(dbCloseArea())

Return(Nil)



USER FUNCTION RM_CT1I(_oProcess,_cTab,_cPasta)

	Local _cAlias   := ''
	Local _lTabLoc  := .T.
	Local _cModo
	Local _nCT1
	Local _aArea     := GetArea()
	Local _aAreaCT1  := CT1->( GetArea() )
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvArqTab := cArqTab //Salva os arquivos de

	If Alltrim(cEmpAnt) = Substr(_cTab,4,2)
		_cAlias := "CT1"
	Else

		If EmpOpenFile("CT1A","CT1",1,.T., Substr(_cTab,4,2),@_cModo)
			_cAlias := "CT1A"
			_lTabLoc := .F.
		Endif
	Endif

	If !Empty(_cAlias)

		_cUpd := " DELETE "+_cTab

		TCSQLEXEC(_cUpd )

		_cArq	:= "\TAB_RM\"+_cPasta+"\"+_cTab+".dtc"		//Gera o nome do arquivo
		_cInd	:= "\TAB_RM\"+_cPasta+"\"+_cTab+"0"			//Indice do arquivo

		If SELECT("TCT1") > 0
			TCT1->(dbCloseArea())
		Endif

		dbUseArea( .T.,"CTREECDX", _cArq,"TCT1", .T., .F. )

		If Select("TCT1") = 0
			MsgInfo( 'Erro Abrir tabela Temporária TCT1', 'RM_CT1' )
			Return(Nil)
		Endif

		dbSelectArea("TCT1")

		IndRegua( "TCT1", _cInd, CT1->( IndexKey( 1 ) ))

		dbClearIndex()
		dbSetIndex(_cInd + OrdBagExt() )

		_nReg := Contar("TCT1","!EOF()")

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso
		_oProcess:IncRegua2("Importando a tabela "+Left(_cTab,3)+" na Empresa "+Substr(_cTab,4,2) )



		TCT1->(dbGoTop())

		While TCT1->(!EOF())

			(_cAlias)->(RecLock(_cAlias,.T.))
			For _nCT1 := 1 to (_cAlias)->(FCOUNT())
				&("(_cAlias)->"+((_cAlias)->(FIELD(_nCT1)))) := &("TCT1->"+((_cAlias)->(FIELD(_nCT1))))
			Next _nCT1
			(_cAlias)->(MsUnLock())

			TCT1->(dbSkip())
		EndDo

		TCT1->(dbCloseArea())

		If !_lTabLoc
			(_cAlias)->(dbCloseArea())
		Endif

	Endif

	//Restaura os Dados de Entrada ( Ambiente )
	cFilAnt := _cSvFilAnt
	cEmpAnt := _cSvEmpAnt
	cArqTab := _cSvArqTab

	//Restaura os ponteiros das Tabelas

	RestArea( _aAreaCT1 )
	RestArea( _aArea )

Return(Nil)

