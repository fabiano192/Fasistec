#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_SB1
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas SB1
*/

USER FUNCTION RM_SB1E(_oProcess,_cTab,_cPasta,_cBDados)

	If Select("TPROD") > 0
		TPROD->(dbCloseArea())
	Endif

	_cQry := " SELECT * FROM "+_cBDados+".TPRODUTO A " +CRLF
	_cQry += " INNER JOIN "+_cBDados+".TPRODUTODEF B ON A.CODCOLPRD = B.CODCOLIGADA  AND A.IDPRD = B.IDPRD " +CRLF
	_cQry += " WHERE RTRIM(CODCOLPRD) IN  ('0','9','10','11') " +CRLF
	_cQry += " ORDER BY CODCOLPRD,CODIGOPRD " +CRLF

	TcQuery _cQry New Alias "TPROD"

	_nReg := Contar("TPROD","!EOF()")

	If _nReg > 0

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

		_nRegAtu := 0

		If U_RMCriarDTC(_cTab)

			TPROD->(dbGoTop())

			While TPROD->(!EOF())

				_nRegAtu ++

				// _oProcess:IncRegua2("Gerando tabela "+_cTab)
				_oProcess:IncRegua2("Gerando tabela "+_cTab+" - Registro "+Alltrim(str(_nRegAtu))+" de "+Alltrim(str(_nReg)))

				TRM->(RecLock("TRM",.T.))
				TRM->B1_YID     := TPROD->IDPRD
				// TRM->B1_FILIAL  :=
				TRM->B1_COD		:= Alltrim(StrTran(TPROD->CODIGOPRD,".",""))
				TRM->B1_DESC	:= U_RM_NoAcento(UPPER(Alltrim(TPROD->DESCRICAO)))
				TRM->B1_MSBLQL	:= (TPROD->INATIVO=1,"1","2")
				TRM->B1_PESO	:= TPROD->PESOLIQUIDO
				TRM->B1_PESBRU	:= TPROD->PESOBRUTO
				TRM->B1_ORIGEM	:= Alltrim(cValToChar(TPROD->REFERENCIACP))
				TRM->B1_UPRC	:= TPROD->PRECO1
				TRM->B1_PRV1	:= TPROD->PRECO2
				TRM->B1_CUSTD	:= TPROD->CUSTOUNITARIO
				TRM->B1_UCALSTD	:= TPROD->DATABASEPRECO1
				TRM->B1_POSIPI	:= TPROD->NUMEROCCF
				TRM->B1_UM		:= TPROD->CODUNDCONTROLE
				TRM->B1_LOCPAD	:= "01"
				// TRM->B1_GRUPO	:=
				TRM->B1_EMIN	:= TPROD->PONTODEPEDIDO1
				TRM->B1_EMAX	:= TPROD->ESTOQUEMAXIMO1
				TRM->(MsUnLock())


				_cKey1 := Alltrim(cValToChar(TPROD->CODCOLPRD))
				// _cCodEmp := "01"
				_cCodEmp := _aEmp[aScan(_aEmp,{|x| x[1] = PadL(_cKey1,2,"0")})][2]

				_cAliZF6 := 'ZF6'+_cCodEmp

				(_cAliZF6)->(RecLock(_cAliZF6,.T.))
				// (_cAliZF6)->ZF6_FILIAL := _cFil
				(_cAliZF6)->ZF6_TABELA := "SB1"
				(_cAliZF6)->ZF6_CAMPO  := "B1_COD"
				(_cAliZF6)->ZF6_CODRM  := TPROD->CODIGOPRD
				(_cAliZF6)->ZF6_IDRM   := TPROD->IDPRD
				(_cAliZF6)->ZF6_TOTVS  := Alltrim(StrTran(TPROD->CODIGOPRD,".",""))
				(_cAliZF6)->(MsUnLock())

				TPROD->(dbSkip())
			EndDo

		Endif
	Endif

	TPROD->(dbCloseArea())

	TRM->(dbCloseArea())

Return(Nil)




USER FUNCTION RM_SB1I(_oProcess,_cTab,_cPasta)

	Local _cAlias   := ''
	Local _lTabLoc  := .T.
	Local _cModo
	Local _nSB1
	Local _aArea     := GetArea()
	Local _aAreaSB1  := SB1->( GetArea() )
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvArqTab := cArqTab //Salva os arquivos de

	If Alltrim(cEmpAnt) = Substr(_cTab,4,2)
		_cAlias := "SB1"
	Else

		If EmpOpenFile("SB1A","SB1",1,.T., Substr(_cTab,4,2),@_cModo)
			_cAlias := "SB1A"
			_lTabLoc := .F.
		Endif
	Endif

	If !Empty(_cAlias)

		_cUpd := " DELETE "+_cTab

		TCSQLEXEC(_cUpd )

		_cArq	:= "\TAB_RM\"+_cPasta+"\"+_cTab+".dtc"		//Gera o nome do arquivo
		_cInd	:= "\TAB_RM\"+_cPasta+"\"+_cTab+"0"			//Indice do arquivo

		If SELECT("TSB1") > 0
			TSB1->(dbCloseArea())
		Endif

		dbUseArea( .T.,"CTREECDX", _cArq,"TSB1", .T., .F. )

		If Select("TSB1") = 0
			MsgInfo( 'Erro Abrir tabela Temporária TSB1', 'RM_SB1' )
			Return(Nil)
		Endif

		dbSelectArea("TSB1")

		IndRegua( "TSB1", _cInd, SB1->( IndexKey( 1 ) ))

		dbClearIndex()
		dbSetIndex(_cInd + OrdBagExt() )

		_nReg := Contar("TSB1","!EOF()")

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso
		_oProcess:IncRegua2("Importando a tabela "+Left(_cTab,3)+" na Empresa "+Substr(_cTab,4,2) )



		TSB1->(dbGoTop())

		While TSB1->(!EOF())

			(_cAlias)->(RecLock(_cAlias,.T.))
			For _nSB1 := 1 to (_cAlias)->(FCOUNT())
				&("(_cAlias)->"+((_cAlias)->(FIELD(_nSB1)))) := &("TSB1->"+((_cAlias)->(FIELD(_nSB1))))
			Next _nSB1
			(_cAlias)->(MsUnLock())

			TSB1->(dbSkip())
		EndDo

		TSB1->(dbCloseArea())

		If !_lTabLoc
			(_cAlias)->(dbCloseArea())
		Endif

	Endif

	//Restaura os Dados de Entrada ( Ambiente )
	cFilAnt := _cSvFilAnt
	cEmpAnt := _cSvEmpAnt
	cArqTab := _cSvArqTab

	//Restaura os ponteiros das Tabelas

	RestArea( _aAreaSB1 )
	RestArea( _aArea )

Return(Nil)
