#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_SF1
Autor 		: Fabiano da Silva	-	25/03/20
Descri��o 	: Exportar tabelas SF1
*/

USER FUNCTION RM_SF1E(_oProcess,_cTab,_cPasta,_cBDados)

	If Select("TNFISCAL") > 0
		TNFISCAL->(dbCloseArea())
	Endif

	_cQry := " SELECT * FROM "+_cBDados+".TMOV A " +CRLF
	_cQry += " WHERE RTRIM(A.CODCOLIGADA)+RTRIM(A.CODFILIAL) IN ('91','93','101','103','104','111','113') " +CRLF
	_cQry += " AND A.TIPO = 'P' " +CRLF
	_cQry += " ORDER BY A.CODCOLIGADA,A.CODFILIAL " +CRLF

	TcQuery _cQry New Alias "TNFISCAL"

	_nReg := Contar("TNFISCAL","!EOF()")

	If _nReg > 0

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

		_nRegAtu := 0

		TNFISCAL->(dbGoTop())

		While TNFISCAL->(!EOF())

			_cKey1   := Alltrim(cValToChar(TNFISCAL->CODCOLIGADA))
			_nCodA1  := &('_nCodA1'+_cKey1)

			If U_RMCriarDTC(_cTab,_cKey1)

				// _cCodEmp := _aEmp[aScan(_aEmp,{|x| x[1] = PadL(_cKey1,2,"0")})][2]

				_cArq5	:= "\TAB_RM\"+_cPasta+"\SA1010.dtc"		//Gera o nome do arquivo
				_cInd5	:= "\TAB_RM\"+_cPasta+"\SA1010"			//Indice do arquivo
				// _cArq5	:= "\TAB_RM\"+_cPasta+"\SA1"+PadL(_cKey1,2,"0")+"0.dtc"		//Gera o nome do arquivo
				// _cInd5	:= "\TAB_RM\"+_cPasta+"\SA1"+PadL(_cKey1,2,"0")+"0"			//Indice do arquivo

				If SELECT("TRM5") > 0
					TRM5->(dbCloseArea())
				Endif

				dbUseArea( .T.,"CTREECDX", _cArq5,"TRM5", .T., .F. )
				dbSelectArea("TRM5")

				IndRegua( "TRM5", _cInd5, "A1_YCODRM")
				// IndRegua( "TRM3", _cInd5, "A1_CGC")

				dbClearIndex()
				dbSetIndex(_cInd5 + OrdBagExt() )


				While TNFISCAL->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TNFISCAL->CODCOLIGADA))

					_nRegAtu ++

					_oProcess:IncRegua2("Gerando tabela "+_cTab)

					_cCodCli := ''
					_cLojCli := ''
					_cNomCli := ''
					_cUF	 := ''
					If TRM5->(MsSeek(TNFISCAL->CODCFO))
						_cCodCli := TRM5->A1_COD
						_cLojCli := TRM5->A1_LOJA
						_cNomCli := TRM5->A1_NREDUZ
						_cUF	 := TRM5->A1_EST
					ENDIF

					TRM->(RecLock("TRM",.T.))
					TRM->F2_YID     := TNFISCAL->IDMOV
					TRM->F2_FILIAL  := PadL(Alltrim(cValtoChar(TNFISCAL->CODFILIAL)),2,"0")
					TRM->F2_DOC     := Alltrim(TNFISCAL->NUMEROMOV)
					TRM->F2_SERIE   := Alltrim(TNFISCAL->SERIE)
					TRM->F2_CLIENTE := _cCodCli
					TRM->F2_LOJA    := _cLojCli
					TRM->F2_EMISSAO := TNFISCAL->DATAEMISSAO
					TRM->F2_EST     := _cUF
					TRM->F2_VALBRUT := TNFISCAL->VALORLIQUIDO
					TRM->F2_VALMERC := TNFISCAL->VALORBRUTO
					TRM->F2_PREFIXO := Alltrim(TNFISCAL->SERIE)
					TRM->F2_CLIENT  := _cCodCli
					TRM->F2_LOJENT  := _cLojCli
					TRM->F2_CHVNFE  := Alltrim(TNFISCAL->CHAVEACESSONFE)
					// TRM->F2_CODNFE  := Alltrim(TNFISCAL->CHAVEACESSONFE)
					TRM->F2_FRETE   := TNFISCAL->VALORFRETE

					// TRM->F2_COND :=
					// TRM->F2_TIPOCLI :=
					// TRM->F2_VALICM :=
					// TRM->F2_BASEICM :=
					// TRM->F2_VALIPI :=
					// TRM->F2_BASEIPI :=
					// TRM->F2_TIPO :=
					// TRM->F2_ESPECIE :=
					// TRM->F2_BASIMP1 :=
					// TRM->F2_BASIMP2 :=
					// TRM->F2_BASIMP3 :=
					// TRM->F2_BASIMP4 :=
					// TRM->F2_BASIMP5 :=
					// TRM->F2_BASIMP6 :=
					// TRM->F2_VALIMP1:=
					// TRM->F2_VALIMP2:=
					// TRM->F2_VALIMP3:=
					// TRM->F2_VALIMP4:=
					// TRM->F2_VALIMP5:=
					// TRM->F2_VALIMP6:=
					// TRM->F2_HORA   :=
					TRM->(MsUnLock())

					TNFISCAL->(dbSkip())
				EndDo
			Endif
		Enddo
	Endif

	TNFISCAL->(dbCloseArea())

	TRM->(dbCloseArea())

Return(Nil)



USER FUNCTION RM_SF1I(_oProcess,_cTab,_cPasta)

	Local _cAlias   := ''
	Local _lTabLoc  := .T.
	Local _cModo
	Local _nSF1
	Local _aArea     := GetArea()
	Local _aAreaSF1  := SF1->( GetArea() )
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvArqTab := cArqTab //Salva os arquivos de

	If Alltrim(cEmpAnt) = Substr(_cTab,4,2)
		_cAlias := "SF1"
	Else

		If EmpOpenFile("SF1A","SF1",1,.T., Substr(_cTab,4,2),@_cModo)
			_cAlias := "SF1A"
			_lTabLoc := .F.
		Endif
	Endif

	If !Empty(_cAlias)

		_cUpd := " DELETE "+_cTab

		TCSQLEXEC(_cUpd )

		_cArq	:= "\TAB_RM\"+_cPasta+"\"+_cTab+".dtc"		//Gera o nome do arquivo
		_cInd	:= "\TAB_RM\"+_cPasta+"\"+_cTab+"0"			//Indice do arquivo

		If SELECT("TSF1") > 0
			TSF1->(dbCloseArea())
		Endif

		dbUseArea( .T.,"CTREECDX", _cArq,"TSF1", .T., .F. )

		If Select("TSF1") = 0
			MsgInfo( 'Erro Abrir tabela Tempor�ria TSF1', 'RM_SF1' )
			Return(Nil)
		Endif

		dbSelectArea("TSF1")

		IndRegua( "TSF1", _cInd, SF1->( IndexKey( 1 ) ))

		dbClearIndex()
		dbSetIndex(_cInd + OrdBagExt() )

		_nReg := Contar("TSF1","!EOF()")

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso
		_oProcess:IncRegua2("Importando a tabela "+Left(_cTab,3)+" na Empresa "+Substr(_cTab,4,2) )



		TSF1->(dbGoTop())

		While TSF1->(!EOF())

			(_cAlias)->(RecLock(_cAlias,.T.))
			For _nSF1 := 1 to (_cAlias)->(FCOUNT())
				&("(_cAlias)->"+((_cAlias)->(FIELD(_nSF1)))) := &("TSF1->"+((_cAlias)->(FIELD(_nSF1))))
			Next _nSF1
			(_cAlias)->(MsUnLock())

			TSF1->(dbSkip())
		EndDo

		TSF1->(dbCloseArea())

		If !_lTabLoc
			(_cAlias)->(dbCloseArea())
		Endif

	Endif

	//Restaura os Dados de Entrada ( Ambiente )
	cFilAnt := _cSvFilAnt
	cEmpAnt := _cSvEmpAnt
	cArqTab := _cSvArqTab

	//Restaura os ponteiros das Tabelas

	RestArea( _aAreaSF1 )
	RestArea( _aArea )

Return(Nil)