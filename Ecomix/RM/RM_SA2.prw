#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_SA2
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas SA2
*/

USER FUNCTION RM_SA2E(_oProcess,_cTab,_cPasta,_cBDados)

	// Local _nTRM := 0

	If Select("TFOR") > 0
		TFOR->(dbCloseArea())
	Endif

	_cQry := " SELECT CODCOLIGADA AS 'EMP',* FROM "+_cBDados+".FCFO " + CRLF
	// _cQry += " WHERE PAGREC = 3 " + CRLF
	_cQry += " WHERE PAGREC <> 1 " + CRLF
	_cQry += " AND RTRIM(CODCOLIGADA) IN  ('0','9','10','11') " + CRLF
	_cQry += " AND CGCCFO IS NOT NULL " + CRLF
	_cQry += " AND CGCCFO <> '' " + CRLF
	// _cQry += " AND (CGCCFO <> '' OR CO1DCFO = 'F00226') " + CRLF
	_cQry += " ORDER BY EMP,CGCCFO " + CRLF

	TcQuery _cQry New Alias "TFOR"

	_nReg := Contar("TFOR","!EOF()")

	If _nReg > 0

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

		_nRegAtu := 0
		_nCodA2  := 0

		If U_RMCriarDTC(_cTab)

			TFOR->(dbGoTop())

			While TFOR->(!EOF())

				If TFOR->PESSOAFISOUJUR = 'J'
					_cKey2 := Left(StrTran(StrTran(StrTran(TFOR->CGCCFO,".",""),"-",""),"/",""),8)
					_cChave := '_cKey2 = Left(StrTran(StrTran(StrTran(TFOR->CGCCFO,".",""),"-",""),"/",""),8)'
				Else
					_cKey2 := StrTran(StrTran(StrTran(TFOR->CGCCFO,".",""),"-",""),"/","")
					_cChave := '_cKey2 = StrTran(StrTran(StrTran(TFOR->CGCCFO,".",""),"-",""),"/","")'
				Endif

				_cLoja := "00"
				_nCodA2  ++
				_cCod  :="F"+PadL(Alltrim(Str(_nCodA2)),5,"0")

				While TFOR->(!EOF()) .And. &(_cChave)

					_nRegAtu ++

					_oProcess:IncRegua2("Gerando tabela "+_cTab)

					_cLoja := Soma1(_cLoja)
					_cCNPJ := Alltrim(StrTran(StrTran(StrTran(TFOR->CGCCFO,".",""),"-",""),"/",""))
					_cFil  := Space(TAMSX3("A2_FILIAL")[1])

					If !TRM->(MsSeek(_cFil+_cCNPJ))
						U_RM_GeraFor("TRM",_cFil,_cCod,_cLoja,_cCNPJ)
					Endif

					_cKey1 := Alltrim(cValToChar(TFOR->EMP))
					// _cCodEmp := "01"
					_cCodEmp := _aEmp[aScan(_aEmp,{|x| x[1] = PadL(_cKey1,2,"0")})][2]

					_cAliZF6 := 'ZF6'+_cCodEmp

					(_cAliZF6)->(RecLock(_cAliZF6,.T.))
					(_cAliZF6)->ZF6_FILIAL := _cFil
					(_cAliZF6)->ZF6_TABELA := "SA2"
					(_cAliZF6)->ZF6_CAMPO  := "A2_COD"
					(_cAliZF6)->ZF6_CODRM  := TFOR->CODCFO
					(_cAliZF6)->ZF6_IDRM   := TFOR->IDCFO
					(_cAliZF6)->ZF6_TOTVS  := _cCod+_cLoja
					(_cAliZF6)->(MsUnLock())

					TFOR->(dbSkip())
				EndDo
			EndDo
		Endif
	Endif

	TFOR->(dbCloseArea())

	TRM->(dbCloseArea())

Return(Nil)




User Function RM_GeraFor(_cAlias,_cFil,_cCod,_cLoja,_cCNPJ)

	(_cAlias)->(RecLock(_cAlias,.T.))
	(_cAlias)->A2_FILIAL  := _cFil
	(_cAlias)->A2_YID     := TFOR->IDCFO
	(_cAlias)->A2_YCODRM  := TFOR->CODCFO
	(_cAlias)->A2_COD     := _cCod
	(_cAlias)->A2_LOJA    := _cLoja
	(_cAlias)->A2_NOME    := UPPER(U_RM_NoAcento(TFOR->NOME))
	(_cAlias)->A2_NREDUZ  := UPPER(U_RM_NoAcento(TFOR->NOMEFANTASIA))
	(_cAlias)->A2_END     := UPPER(U_RM_NoAcento(Alltrim(TFOR->RUA)))+" "+UPPER(U_RM_NoAcento(ALLTRIM(TFOR->NUMERO)))
	(_cAlias)->A2_COMPLEM := UPPER(U_RM_NoAcento(Alltrim(TFOR->COMPLEMENTO)))
	(_cAlias)->A2_TIPO    := TFOR->PESSOAFISOUJUR
	(_cAlias)->A2_EST     := TFOR->CODETD
	(_cAlias)->A2_COD_MUN := TFOR->CODMUNICIPIO
	(_cAlias)->A2_MUN     := UPPER(U_RM_NoAcento(Alltrim(TFOR->CIDADE)))
	(_cAlias)->A2_BAIRRO  := UPPER(U_RM_NoAcento(Alltrim(TFOR->BAIRRO)))
	// (_cAlias)->A2_NATUREZ := TFOR->
	(_cAlias)->A2_CEP     := TFOR->CEP
	// (_cAlias)->A2_DDD     := TFOR->
	(_cAlias)->A2_TEL     := TFOR->TELEFONE
	(_cAlias)->A2_PAIS    := "105"
	(_cAlias)->A2_CGC     := _cCNPJ
	(_cAlias)->A2_CONTATO := TFOR->CONTATO
	(_cAlias)->A2_INSCR   := TFOR->INSCRESTADUAL
	(_cAlias)->A2_CODPAIS := "01058"
	(_cAlias)->A2_EMAIL   := TFOR->EMAIL
	(_cAlias)->A2_MSBLQL  := If(TFOR->ATIVO=1,"2","1")
	// (_cAlias)->A2_LC      := TFOR->LIMITECREDITO
	(_cAlias)->A2_INSCRM  := TFOR->INSCRMUNICIPAL
	(_cAlias)->A2_CONTRIB  := If(TFOR->CONTRIBUINTE=1,"2","1")
	(_cAlias)->(MsUnLock())

Return(Nil)




USER FUNCTION RM_SA2I(_oProcess,_cTab,_cPasta)

	Local _cAlias   := ''
	Local _lTabLoc  := .T.
	Local _cModo
	Local _nSA2
	Local _aArea     := GetArea()
	Local _aAreaSA2  := SA2->( GetArea() )
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvArqTab := cArqTab //Salva os arquivos de

	If Alltrim(cEmpAnt) = Substr(_cTab,4,2)
		_cAlias := "SA2"
	Else

		If EmpOpenFile("SA2A","SA2",1,.T., Substr(_cTab,4,2),@_cModo)
			_cAlias := "SA2A"
			_lTabLoc := .F.
		Endif
	Endif

	If !Empty(_cAlias)

		_cUpd := " DELETE "+_cTab

		TCSQLEXEC(_cUpd )

		_cArq	:= "\TAB_RM\"+_cPasta+"\"+_cTab+".dtc"		//Gera o nome do arquivo
		_cInd	:= "\TAB_RM\"+_cPasta+"\"+_cTab+"0"			//Indice do arquivo

		If SELECT("TSA2") > 0
			TSA2->(dbCloseArea())
		Endif

		dbUseArea( .T.,"CTREECDX", _cArq,"TSA2", .T., .F. )

		If Select("TSA2") = 0
			MsgInfo( 'Erro Abrir tabela Temporária TSA2', 'RM_SA2' )
			Return(Nil)
		Endif

		dbSelectArea("TSA2")

		IndRegua( "TSA2", _cInd, SA2->( IndexKey( 1 ) ))

		dbClearIndex()
		dbSetIndex(_cInd + OrdBagExt() )

		_nReg := Contar("TSA2","!EOF()")

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso
		_oProcess:IncRegua2("Importando a tabela "+Left(_cTab,3)+" na Empresa "+Substr(_cTab,4,2) )


		TSA2->(dbGoTop())

		While TSA2->(!EOF())

			(_cAlias)->(RecLock(_cAlias,.T.))
			For _nSA2 := 1 to (_cAlias)->(FCOUNT())
				&("(_cAlias)->"+((_cAlias)->(FIELD(_nSA2)))) := &("TSA2->"+((_cAlias)->(FIELD(_nSA2))))
			Next _nSA2
			(_cAlias)->(MsUnLock())

			TSA2->(dbSkip())
		EndDo

		TSA2->(dbCloseArea())

		If !_lTabLoc
			(_cAlias)->(dbCloseArea())
		Endif

	Endif

	//Restaura os Dados de Entrada ( Ambiente )
	cFilAnt := _cSvFilAnt
	cEmpAnt := _cSvEmpAnt
	cArqTab := _cSvArqTab

	//Restaura os ponteiros das Tabelas

	RestArea( _aAreaSA2 )
	RestArea( _aArea )

Return(Nil)