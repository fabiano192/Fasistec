#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa RM_SD2
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas SD2
*/

USER FUNCTION RM_SD2(_oProcess,_cTab,_cPasta)

	If Select("TNFITEM") > 0
		TNFITEM->(dbCloseArea())
	Endif

	_cQry := " SELECT B.CODCFO,C.CODIGOPRD,D.CODUNDBASE,B.CODTMV,B.NUMEROMOV,B.SERIE,A.* FROM DADOSRM..TITMMOV A " +CRLF
	_cQry += " INNER JOIN DADOSRM..TMOV B ON A.CODCOLIGADA = B.CODCOLIGADA AND A.IDMOV = B.IDMOV " +CRLF
	_cQry += " INNER JOIN DADOSRM..TPRD C ON A.IDPRD = C.IDPRD AND A.CODCOLIGADA = C.CODCOLIGADA " +CRLF
	_cQry += " INNER JOIN DADOSRM..TUND D ON A.CODUND = D.CODUND " +CRLF
	_cQry += " WHERE RTRIM(A.CODCOLIGADA)+RTRIM(A.CODFILIAL) IN ('91','93','101','103','104','111','113')" +CRLF
	_cQry += " AND B.TIPO = 'P' " +CRLF
	_cQry += " ORDER BY A.CODCOLIGADA,A.CODFILIAL " +CRLF

	TcQuery _cQry New Alias "TNFITEM"

	_nReg := Contar("TNFITEM","!EOF()")

	If _nReg > 0

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso

		_nRegAtu := 0

		TNFITEM->(dbGoTop())

		While TNFITEM->(!EOF())

			_cKey1   := Alltrim(cValToChar(TNFITEM->CODCOLIGADA))
			_nCodA1  := &('_nCodA1'+_cKey1)

			If U_RMCriarDTC(_cTab,_cKey1)

				_cArq5	:= "\TAB_RM\"+_cPasta+"\SA1"+_cKey1+".dtc"	//Gera o nome do arquivo
				_cInd5	:= "\TAB_RM\"+_cPasta+"\SA1"+_cKey1			//Indice do arquivo

				If SELECT("TRM5") > 0
					TRM5->(dbCloseArea())
				Endif

				dbUseArea( .T.,"CTREECDX", _cArq5,"TRM5", .T., .F. )
				dbSelectArea("TRM5")

				IndRegua( "TRM5", _cInd5, "A1_YCODRM")
				// IndRegua( "TRM3", _cInd5, "A1_CGC")

				dbClearIndex()
				dbSetIndex(_cInd5 + OrdBagExt() )



				_cArq6	:= "\TAB_RM\"+_cPasta+"\SB1"+_cKey1+".dtc"	//Gera o nome do arquivo
				_cInd6	:= "\TAB_RM\"+_cPasta+"\SB1"+_cKey1			//Indice do arquivo

				If SELECT("TRM6") > 0
					TRM6->(dbCloseArea())
				Endif

				dbUseArea( .T.,"CTREECDX", _cArq6,"TRM6", .T., .F. )
				dbSelectArea("TRM6")

				IndRegua( "TRM6", _cInd6, "B1_COD")
				// IndRegua( "TRM3", _cInd5, "A1_CGC")

				dbClearIndex()
				dbSetIndex(_cInd6 + OrdBagExt() )



				While TNFITEM->(!EOF()) .And. _cKey1 == Alltrim(cValToChar(TNFITEM->CODCOLIGADA))

					_nRegAtu ++

					_oProcess:IncRegua2("Gerando tabela "+_cTab)

					_cCodCli := ''
					_cLojCli := ''
					_cNomCli := ''
					_cUF	 := ''
					If TRM5->(MsSeek(TNFITEM->CODCFO))
						_cCodCli := TRM5->A1_COD
						_cLojCli := TRM5->A1_LOJA
						_cNomCli := TRM5->A1_NREDUZ
						_cUF	 := TRM5->A1_EST
					ENDIF

					_cCodPrd := Alltrim(StrTran(TNFITEM->CODIGOPRD,".",""))
					If TRM6->(MsSeek(_cCodPrd))
						TRM6->(RecLock("TRM6",.F.))
						TRM6->B1_YVENDAS := 'S'
						TRM6->(MsUnLock())
					ENDIF


					TRM->(RecLock("TRM",.T.))
					TRM->D2_YID     := TNFITEM->IDMOV
					TRM->D2_FILIAL  := Alltrim(cValtoChar(TNFITEM->CODFILIAL))
					TRM->D2_DOC     := Alltrim(TNFITEM->NUMEROMOV)
					TRM->D2_SERIE   := Alltrim(TNFITEM->SERIE)
					TRM->D2_CLIENTE := _cCodCli
					TRM->D2_LOJA    := _cLojCli
					TRM->D2_EMISSAO := TNFITEM->DATAEMISSAO
					TRM->D2_ITEM    := PadL(Alltrim(STR(TNFITEM->NSEQITMMOV)),TAMSX3("D2_ITEM")[1],"0")
					TRM->D2_COD     := _cCodPrd //TNFITEM->CODIGOPRD
					TRM->D2_UM      := TNFITEM->CODUNDBASE
					TRM->D2_QUANT   := TNFITEM->QUANTIDADE
					TRM->D2_PRCVEN  := TNFITEM->PRECOUNITARIO
					TRM->D2_TOTAL   := TNFITEM->VALORLIQUIDO
					// TRM->D2_TES     := TNFITEM->
					TRM->D2_CF      := StrTran(TNFITEM->CODTMV,".","")

					// TRM->D2_DESC    := TNFITEM->
					// TRM->D2_IPI     := TNFITEM->
					// TRM->D2_VALCSL  := TNFITEM->
					// TRM->D2_PICM    := TNFITEM->
					// TRM->D2_PEDIDO  := TNFITEM->
					// TRM->D2_ITEMPV  := TNFITEM->
					// TRM->D2_LOCAL   := TNFITEM->CODLOC
					// TRM->D2_GRUPO   := TNFITEM->
					// TRM->D2_TP      := TNFITEM->
					// TRM->D2_PRUNIT  := TNFITEM->
					// TRM->D2_NUMSEQ  := TNFITEM->
					// TRM->D2_EST     := TNFITEM->
					// TRM->D2_TIPO    := TNFITEM->
					// TRM->D2_QTDEDEV := TNFITEM->
					// TRM->D2_VALDEV  := TNFITEM->
					// TRM->D2_NFORI   := TNFITEM->
					// TRM->D2_SERIORI := TNFITEM->
					// TRM->D2_BASEICM := TNFITEM->
					// TRM->D2_CLASFIS := TNFITEM->
					// TRM->D2_ALQIMP5 := TNFITEM->
					// TRM->D2_ALQIMP6 := TNFITEM->
					// TRM->D2_ALIQINS := TNFITEM->
					// TRM->D2_ALIQISS := TNFITEM->
					// TRM->D2_BASEIPI := TNFITEM->
					// TRM->D2_BASEISS := TNFITEM->
					// TRM->D2_VALISS  := TNFITEM->
					// TRM->D2_VALFRE  := TNFITEM->
					// TRM->D2_VALBRUT := TNFITEM->
					// TRM->D2_ALIQSOL := TNFITEM->
					TRM->(MsUnLock())

					TNFITEM->(dbSkip())
				EndDo
			Endif
		Enddo
	Endif

	TNFITEM->(dbCloseArea())

Return(Nil)