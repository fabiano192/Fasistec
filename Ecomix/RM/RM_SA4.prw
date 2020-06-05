#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_SA4
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas SA4
*/

USER FUNCTION RM_SA4E(_oProcess,_cTab,_cPasta,_cBDados)

	If Select("TTRAN") > 0
		TTRAN->(dbCloseArea())
	Endif

	_cQry := " SELECT * FROM "+_cBDados+".TTRA  A " +CRLF
	_cQry += " WHERE RTRIM(CODCOLIGADA) IN  ('0','9','10','11') " +CRLF
	_cQry += " ORDER BY CODCOLIGADA,CODTRA" +CRLF

	TcQuery _cQry New Alias "TTRAN"

	_nReg := Contar("TTRAN","!EOF()")

	If _nReg > 0

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

		_nRegAtu := 0

		If U_RMCriarDTC(_cTab)

			TTRAN->(dbGoTop())

			While TTRAN->(!EOF())

				_cCodTr  := "000000"

				_nRegAtu ++
				_cCodTr := Soma1(_cCodTr)

				_oProcess:IncRegua2("Gerando tabela "+_cTab)

				TRM->(RecLock("TRM",.T.))
				TRM->A4_YCODRM  := TTRAN->CODTRA
				TRM->A4_COD     := _cCodTr
				TRM->A4_NOME	:= U_RM_NoAcento(UPPER(Alltrim(TTRAN->NOME)))
				TRM->A4_NREDUZ  := U_RM_NoAcento(UPPER(Alltrim(TTRAN->NOMEFANTASIA)))
				// TRM->A4_MSBLQL	:= (TTRAN->INATIVO=1,"1","2")
				TRM->A4_END  	:= U_RM_NoAcento(UPPER(Alltrim(TTRAN->RUA)))+', '+Alltrim(TTRAN->NUMERO)
				TRM->A4_COMPLEM := U_RM_NoAcento(UPPER(Alltrim(TTRAN->COMPLEMENTO)))
				TRM->A4_MUN 	:= TTRAN->CIDADE
				TRM->A4_COD_MUN	:= TTRAN->CODMUNICIPIO
				TRM->A4_BAIRRO	:= U_RM_NoAcento(UPPER(Alltrim(TTRAN->BAIRRO)))
				TRM->A4_EST 	:= TTRAN->CODETD
				TRM->A4_CEP 	:= TTRAN->CEP
				// TRM->A4_DDD 	:= TTRAN->
				TRM->A4_TEL 	:= TTRAN->TELEFONE
				TRM->A4_CGC		:= Alltrim(StrTran(StrTran(StrTran(TTRAN->CGC,".",""),"-",""),"/",""))
				TRM->A4_INSEST	:= TTRAN->INSCRESTADUAL
				TRM->A4_EMAIL	:= TTRAN->EMAIL
				TRM->A4_CONTATO	:= TTRAN->CONTATO
				TRM->A4_CODPAIS	:= '01058'
				TRM->A4_INSCRM	:= TTRAN->INSCRMUNICIPAL
				TRM->(MsUnLock())

				_cKey1 := Alltrim(cValToChar(TTRAN->CODCOLIGADA))
				_cCodEmp := _aEmp[aScan(_aEmp,{|x| x[1] = PadL(_cKey1,2,"0")})][2]

				_cAliZF6 := 'ZF6'+_cCodEmp

				(_cAliZF6)->(RecLock(_cAliZF6,.T.))
				// (_cAliZF6)->ZF6_FILIAL := 
				(_cAliZF6)->ZF6_TABELA := "SA4"
				(_cAliZF6)->ZF6_CAMPO  := "A4_COD"
				(_cAliZF6)->ZF6_CODRM  := TTRAN->CODTRA
				// (_cAliZF6)->ZF6_IDRM   := 
				(_cAliZF6)->ZF6_TOTVS  := _cCodTr
				(_cAliZF6)->(MsUnLock())

				TTRAN->(dbSkip())
			EndDo

		Endif
	Endif

	TTRAN->(dbCloseArea())

	TRM->(dbCloseArea())

Return(Nil)



USER FUNCTION RM_SA4I(_oProcess,_cTab,_cPasta)

	Local _cAlias   := ''
	Local _lTabLoc  := .T.
	Local _cModo
	Local _nSA4
	Local _aArea     := GetArea()
	Local _aAreaSA4  := SA4->( GetArea() )
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvArqTab := cArqTab //Salva os arquivos de

	If Alltrim(cEmpAnt) = Substr(_cTab,4,2)
		_cAlias := "SA4"
	Else

		If EmpOpenFile("SA4A","SA4",1,.T., Substr(_cTab,4,2),@_cModo)
			_cAlias := "SA4A"
			_lTabLoc := .F.
		Endif
	Endif

	If !Empty(_cAlias)

		_cUpd := " DELETE "+_cTab

		TCSQLEXEC(_cUpd )

		_cArq	:= "\TAB_RM\"+_cPasta+"\"+_cTab+".dtc"		//Gera o nome do arquivo
		_cInd	:= "\TAB_RM\"+_cPasta+"\"+_cTab+"0"			//Indice do arquivo

		If SELECT("TSA4") > 0
			TSA4->(dbCloseArea())
		Endif

		dbUseArea( .T.,"CTREECDX", _cArq,"TSA4", .T., .F. )

		If Select("TSA4") = 0
			MsgInfo( 'Erro Abrir tabela Temporária TSA4', 'RM_SA4' )
			Return(Nil)
		Endif

		dbSelectArea("TSA4")

		IndRegua( "TSA4", _cInd, SA4->( IndexKey( 1 ) ))

		dbClearIndex()
		dbSetIndex(_cInd + OrdBagExt() )

		_nReg := Contar("TSA4","!EOF()")

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso
		_oProcess:IncRegua2("Importando a tabela "+Left(_cTab,3)+" na Empresa "+Substr(_cTab,4,2) )



		TSA4->(dbGoTop())

		While TSA4->(!EOF())

			(_cAlias)->(RecLock(_cAlias,.T.))
			For _nSA4 := 1 to (_cAlias)->(FCOUNT())
				&("(_cAlias)->"+((_cAlias)->(FIELD(_nSA4)))) := &("TSA4->"+((_cAlias)->(FIELD(_nSA4))))
			Next _nSA4
			(_cAlias)->(MsUnLock())

			TSA4->(dbSkip())
		EndDo

		TSA4->(dbCloseArea())

		If !_lTabLoc
			(_cAlias)->(dbCloseArea())
		Endif

	Endif

	//Restaura os Dados de Entrada ( Ambiente )
	cFilAnt := _cSvFilAnt
	cEmpAnt := _cSvEmpAnt
	cArqTab := _cSvArqTab

	//Restaura os ponteiros das Tabelas

	RestArea( _aAreaSA4 )
	RestArea( _aArea )

Return(Nil)