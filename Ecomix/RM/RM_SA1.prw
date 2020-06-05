#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_SA1
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas SA1
*/

USER FUNCTION RM_SA1E(_oProcess,_cTab,_cPasta,_cBDados)

	// Local _nTRM := 0

	If Select("TCLI") > 0
		TCLI->(dbCloseArea())
	Endif

	_cQry := " SELECT CODCOLIGADA AS 'EMP',* FROM "+_cBDados+".FCFO " + CRLF
	// _cQry += " WHERE PAGREC = 3 " + CRLF
	_cQry += " WHERE PAGREC <> 2 " + CRLF
	_cQry += " AND RTRIM(CODCOLIGADA) IN  ('0','9','10','11') " + CRLF
	_cQry += " AND CGCCFO IS NOT NULL " + CRLF
	// _cQry += " AND (CGCCFO <> '' OR CODCFO = 'F00226') " + CRLF
	_cQry += " AND CGCCFO <> '' " + CRLF
	// _cQry += " AND CGCCFO > '9'" + CRLF
	_cQry += " ORDER BY CGCCFO,EMP " + CRLF
	// _cQry += " ORDER BY EMP,CGCCFO " + CRLF

	TcQuery _cQry New Alias "TCLI"

	_nReg := Contar("TCLI","!EOF()")

	If _nReg > 0

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

		_nRegAtu := 0
		_nCodA1 := 0

		If U_RMCriarDTC(_cTab)

			TCLI->(dbGoTop())

			While TCLI->(!EOF())

				// _cKey1  := Alltrim(cValToChar(TCLI->EMP))
				// _nCodA1 := 0

				// If U_RMCriarDTC(_cTab,_cKey1)

				// While TCLI->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TCLI->EMP))

				If TCLI->PESSOAFISOUJUR = 'J'
					_cKey2 := Left(StrTran(StrTran(StrTran(TCLI->CGCCFO,".",""),"-",""),"/",""),8)
					_cChave := '_cKey2 = Left(StrTran(StrTran(StrTran(TCLI->CGCCFO,".",""),"-",""),"/",""),8)'
				Else
					_cKey2 := StrTran(StrTran(StrTran(TCLI->CGCCFO,".",""),"-",""),"/","")
					_cChave := '_cKey2 = StrTran(StrTran(StrTran(TCLI->CGCCFO,".",""),"-",""),"/","")'
				Endif

				_cLoja  := "00"
				_nCodA1 ++
				_cCod   := "C"+PadL(Alltrim(Str(_nCodA1)),5,"0")

				While TCLI->(!EOF()) .And. &(_cChave)

					_nRegAtu ++

					_oProcess:IncRegua2("Gerando tabela "+_cTab)

					_cLoja := Soma1(_cLoja)
					_cCNPJ := Alltrim(StrTran(StrTran(StrTran(TCLI->CGCCFO,".",""),"-",""),"/",""))
					_cFil  := Space(TAMSX3("A1_FILIAL")[1])

					If !TRM->(MsSeek(_cFil+_cCNPJ))
						U_RM_GeraCli("TRM",_cFil,_cCod,_cLoja,_cCNPJ)
					Endif

					_cKey1 := Alltrim(cValToChar(TCLI->EMP))
					// _cCodEmp := "01"
					_cCodEmp := _aEmp[aScan(_aEmp,{|x| x[1] = PadL(_cKey1,2,"0")})][2]

					_cAliZF6 := 'ZF6'+_cCodEmp

					(_cAliZF6)->(RecLock(_cAliZF6,.T.))
					(_cAliZF6)->ZF6_FILIAL := _cFil
					(_cAliZF6)->ZF6_TABELA := "SA1"
					(_cAliZF6)->ZF6_CAMPO  := "A1_COD"
					(_cAliZF6)->ZF6_CODRM  := TCLI->CODCFO
					(_cAliZF6)->ZF6_IDRM   := TCLI->IDCFO
					(_cAliZF6)->ZF6_TOTVS  := _cCod+_cLoja
					(_cAliZF6)->(MsUnLock())

					TCLI->(dbSkip())
				EndDo

			EndDo
		Endif
	Endif

	TCLI->(dbCloseArea())

	TRM->(dbCloseArea())

Return(Nil)



User Function RM_GeraCli(_cAlias,_cFil,_cCod,_cLoja,_cCNPJ)

	(_cAlias)->(RecLock(_cAlias,.T.))
	(_cAlias)->A1_YID     := TCLI->IDCFO
	(_cAlias)->A1_FILIAL  := _cFil
	(_cAlias)->A1_YCODRM  := TCLI->CODCFO
	(_cAlias)->A1_COD     := _cCod
	(_cAlias)->A1_LOJA    := _cLoja
	(_cAlias)->A1_PESSOA  := TCLI->PESSOAFISOUJUR
	(_cAlias)->A1_NOME    := UPPER(U_RM_NoAcento(TCLI->NOME))
	(_cAlias)->A1_NREDUZ  := UPPER(U_RM_NoAcento(TCLI->NOMEFANTASIA))
	(_cAlias)->A1_END     := UPPER(U_RM_NoAcento(Alltrim(TCLI->RUA)))+" "+UPPER(U_RM_NoAcento(ALLTRIM(TCLI->NUMERO)))
	(_cAlias)->A1_COMPLEM := UPPER(U_RM_NoAcento(Alltrim(TCLI->COMPLEMENTO)))
	// (_cAlias)->A1_TIPO    := TCLI-> ????
	(_cAlias)->A1_EST     := TCLI->CODETD
	(_cAlias)->A1_COD_MUN := TCLI->CODMUNICIPIO
	(_cAlias)->A1_MUN     := UPPER(U_RM_NoAcento(Alltrim(TCLI->CIDADE)))
	(_cAlias)->A1_BAIRRO  := UPPER(U_RM_NoAcento(Alltrim(TCLI->BAIRRO)))
	// (_cAlias)->A1_NATUREZ := TCLI->
	(_cAlias)->A1_CEP     := TCLI->CEP
	// (_cAlias)->A1_DDD     := TCLI->
	(_cAlias)->A1_TEL     := TCLI->TELEFONE
	(_cAlias)->A1_PAIS    := "105"
	(_cAlias)->A1_CGC     := _cCNPJ
	(_cAlias)->A1_CONTATO := TCLI->CONTATO
	(_cAlias)->A1_INSCR   := TCLI->INSCRESTADUAL
	(_cAlias)->A1_CODPAIS := "01058"
	(_cAlias)->A1_SATIV1  := "1"
	(_cAlias)->A1_SATIV2  := "1"
	(_cAlias)->A1_SATIV3  := "1"
	(_cAlias)->A1_SATIV4  := "1"
	(_cAlias)->A1_SATIV5  := "1"
	(_cAlias)->A1_SATIV6  := "1"
	(_cAlias)->A1_SATIV7  := "1"
	(_cAlias)->A1_SATIV8  := "1"
	(_cAlias)->A1_EMAIL   := TCLI->EMAIL
	(_cAlias)->A1_MSBLQL  := If(TCLI->ATIVO=1,"2","1")
	(_cAlias)->A1_LC      := TCLI->LIMITECREDITO
	(_cAlias)->A1_INSCRM  := TCLI->INSCRMUNICIPAL
	(_cAlias)->A1_CONTRIB  := If(TCLI->CONTRIBUINTE=1,"2","1")
	(_cAlias)->(MsUnLock())

RETURN(nIL)



USER FUNCTION RM_SA1I(_oProcess,_cTab,_cPasta)

	Local _cAlias   := ''
	Local _lTabLoc  := .T.
	Local _cModo
	Local _nSA1
	Local _aArea     := GetArea()
	Local _aAreaSA1  := SA1->( GetArea() )
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvArqTab := cArqTab //Salva os arquivos de

	// _cPasta := "20200603_110107"

	If Alltrim(cEmpAnt) = Substr(_cTab,4,2)
		_cAlias := "SA1"
	Else

		If Select("SA1A") > 0
			SA1A->(dbCloseArea())
		Endif

		If EmpOpenFile("SA1A","SA1",1,.T., Substr(_cTab,4,2),@_cModo)
			_cAlias := "SA1A"
			_lTabLoc := .F.
		Endif
	Endif

	If !Empty(_cAlias)

		_cUpd := " DELETE "+_cTab

		TCSQLEXEC(_cUpd )

		_cArq	:= "\TAB_RM\"+_cPasta+"\"+_cTab+".dtc"		//Gera o nome do arquivo
		_cInd	:= "\TAB_RM\"+_cPasta+"\"+_cTab+"0"			//Indice do arquivo

		If SELECT("TSA1") > 0
			TSA1->(dbCloseArea())
		Endif

		dbUseArea( .T.,"CTREECDX", _cArq,"TSA1", .T., .F. )

		If Select("TSA1") = 0
			MsgInfo( 'Erro Abrir tabela Temporária TSA1', 'RM_SA1' )
			Return(Nil)
		Endif

		dbSelectArea("TSA1")

		IndRegua( "TSA1", _cInd, SA1->( IndexKey( 1 ) ))

		dbClearIndex()
		dbSetIndex(_cInd + OrdBagExt() )

		_nReg := Contar("TSA1","!EOF()")

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso
		_oProcess:IncRegua2("Importando a tabela "+Left(_cTab,3)+" na Empresa "+Substr(_cTab,4,2) )



		TSA1->(dbGoTop())

		While TSA1->(!EOF())

			(_cAlias)->(RecLock(_cAlias,.T.))
			For _nSA1 := 1 to (_cAlias)->(FCOUNT())
				&("(_cAlias)->"+((_cAlias)->(FIELD(_nSA1)))) := &("TSA1->"+((_cAlias)->(FIELD(_nSA1))))
			Next _nSA1
			(_cAlias)->(MsUnLock())

			TSA1->(dbSkip())
		EndDo

		TSA1->(dbCloseArea())

		If !_lTabLoc
			(_cAlias)->(dbCloseArea())
		Endif

	Endif

	//Restaura os Dados de Entrada ( Ambiente )
	cFilAnt := _cSvFilAnt
	cEmpAnt := _cSvEmpAnt
	cArqTab := _cSvArqTab

	//Restaura os ponteiros das Tabelas

	RestArea( _aAreaSA1 )
	RestArea( _aArea )

Return(Nil)