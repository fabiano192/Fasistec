#INCLUDE "TOTVS.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa 	: PXH096
Autor 		: Fabiano da Silva
Data		: 27/09/16
Uso 		: SIGAFIN
Descrição 	: Impressão de Relatório de Centro de Custo BNDES
*/

User Function PXH096()

	Local _oDlg := NIL

	Private _oPrinter   := NIL
	Private _oFont1, _oFont2, _oFont3, _oFont4, _oFont5, _oFont6
	Private _nPag 		:= _nTPageF := _nTPageA := _nTPageT := 0
	Private _lEnt
	Private _cDir 		:= "C:\TOTVS\"
	Private _lExcel		:= .F.
	Private _nRadio		:= 1

	If !ExistDir( _cDir )
		If MakeDir( _cDir ) <> 0
			MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
			Return
		EndIf
	EndIf

	AtuSX1()

	DEFINE MSDIALOG _oDlg FROM 0,0 TO 182,315 TITLE "CC BNDES" OF _oDlg PIXEL

	_oGrupo	:= TGroup():New( 005,005,035,155,"",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 010,010 SAY "Esta rotina rega o relatório financeiro por Centro de Custo" OF _oGrupo PIXEL Size 150,010
	@ 020,010 SAY "BNDES, conforme os parâmetros informados pelo usuário." 		OF _oGrupo PIXEL Size 150,010

	_oGrupo1 := TGroup():New( 036,005,062,155,"Escolha abaixo o formato do relatório",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 042,065 RADIO _oRadio VAR _nRadio ITEMS "PDF","Excel" SIZE 33,10 PIXEL OF _oGrupo1

	_oGrupo2:= TGroup():New( 065,005,088,155,"",_oDlg,CLR_HBLUE,CLR_HGREEN,.T.,.F. )

	@ 70,010 BUTTON "Parâmetros"	SIZE 036,012 ACTION (Pergunte("PXH096",.t.))OF _oGrupo2 PIXEL
	@ 70,060 BUTTON "OK" 			SIZE 036,012 ACTION (LjMsgRun( "Processando, aguarde...", "CC BNDES", {||PXH96A() } ),_oDlg:End()) OF _oGrupo2 PIXEL
	@ 70,110 BUTTON "Sair"			SIZE 036,012 ACTION (_oDlg:End()) 	OF _oGrupo2 PIXEL

	ACTIVATE MSDIALOG _oDlg CENTERED

Return(Nil)


Static Function PXH96A()

	Local _lAdjustToLegacy	:= .F.
	Local _lDisableSetup	:= .T.

	Pergunte("PXH096",.F.)

	_lExcel := If(_nRadio = 1,.F.,.T.)

	_oFont1 	:= TFont():New('Arial'	,,-12,,.T.,,,,,.F.,.F.)
	_oFont2 	:= TFont():New('Arial'	,,-09,,.T.,,,,,.F.,.F.)
	_oFont3 	:= TFont():New('Courier',,-09,,.T.,,,,,.F.,.F.)
	_oFont4 	:= TFont():New('Courier',,-09,,.F.,,,,,.F.,.F.)
	_oFont5 	:= TFont():New('Arial'	,,-10,,.T.,,,,,.F.,.F.)
	_oFont6 	:= TFont():New('Courier',,-09,,.F.,,,,,.F.,.T.)

	Pergunte("PXH096",.F.)

	//Lançamentos via SE2
	_cQuery  := " SELECT E5_FILIAL AS FILIAL, E5_PREFIXO AS PREFIXO, E5_NUMERO AS NUMERO,E5_PARCELA AS PARCELA,E5_TIPO AS TIPO, " + CRLF
	// _cQuery  := " SELECT E5_FILIAL AS FILIAL, E5_PREFIXO AS PREFIXO, E5_NUMERO AS NUMERO,E5_PARCELA AS PARCELA,E5_TIPO AS TIPO,E2_CC AS CUSTO, " + CRLF
	_cQuery  += " 'CUSTO' = IIF(coalesce(E2_CC,'')='', E5_CCUSTO, E2_CC), " + CRLF
	_cQuery  += " E5_CLIFOR AS CLIFOR, E5_LOJA AS LOJA, A2_NREDUZ AS NOME, A2_CGC AS CNPJ,A2_TIPO AS PESSOA,E5_DTDISPO AS DTDISPO, E5_MOTBX AS MOTBX, " + CRLF
	_cQuery  += " E5_TIPODOC AS TIPODOC, E5_VALOR AS E5VALOR " + CRLF
	_cQuery  += " FROM "+RetSqlName("SE5")+" E5 (NOLOCK) " + CRLF
	_cQuery  += " LEFT JOIN "+RetSqlName("SED")+" ED ON ED_CODIGO = E5_NATUREZ AND ED.D_E_L_E_T_ = '' AND ED_FILIAL = '"+xFilial("SED")+"' " + CRLF
	_cQuery  += " LEFT JOIN "+RetSqlName("SE2")+" E2 ON E2_FILIAL= E5_FILIAL AND E2_PREFIXO=E5_PREFIXO AND E2_NUM=E5_NUMERO " + CRLF
	_cQuery  += " AND E2_PARCELA=E5_PARCELA AND E2_FORNECE=E5_FORNECE AND E2_LOJA=E5_LOJA AND E2_TIPO=E5_TIPO AND E2.D_E_L_E_T_ = '' " + CRLF
	_cQuery  += " LEFT JOIN "+RetSqlName("SA2")+" A2 ON E5_CLIFOR = A2_COD AND E5_LOJA = A2_LOJA AND A2.D_E_L_E_T_ = ''" + CRLF
	_cQuery  += " WHERE E5.D_E_L_E_T_ = '' " + CRLF
	_cQuery  += " AND E5_FILIAL = '"+xFilial("SE5")+"' " + CRLF
	_cQuery  += " AND E5_DTDISPO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + CRLF
	_cQuery  += " AND E5_SITUACA = '' AND E5_TIPODOC NOT IN ('JR','MT','DC','CH','TR') " + CRLF
/*
	_cQuery  += " UNION ALL " + CRLF

	//Lançamentos via SE5 Movto Bancária
	_cQuery  += " SELECT E5_FILIAL AS FILIAL, E5_PREFIXO AS PREFIXO, LEFT(E5_DOCUMEN,9) AS NUMERO,E5_PARCELA AS PARCELA,E5_TIPO AS TIPO,E5_CCD AS CUSTO, " + CRLF
	_cQuery  += " E5_CLIFOR AS CLIFOR, E5_LOJA AS LOJA, A2_NOME AS NOME, A2_CGC AS CNPJ,A2_TIPO AS PESSOA,E5_DTDISPO AS DTDISPO, E5_MOTBX AS MOTBX, " + CRLF
	_cQuery  += " E5_TIPODOC AS TIPODOC, E5_VALOR AS E5VALOR " + CRLF
	_cQuery  += " FROM "+RetSqlName("SE5")+" E5 (NOLOCK) " + CRLF
	_cQuery  += " LEFT JOIN "+RetSqlName("SED")+" ED ON ED_CODIGO = E5_NATUREZ AND ED.D_E_L_E_T_ = ''  AND ED_FILIAL = '"+xFilial("SED")+"' " + CRLF
	_cQuery  += " LEFT JOIN "+RetSqlName("SA2")+" A2 ON E5_CLIFOR = A2_COD AND E5_LOJA = A2_LOJA AND A2.D_E_L_E_T_ = ''" + CRLF
	_cQuery  += " WHERE E5.D_E_L_E_T_ = ''  " + CRLF
	_cQuery  += " AND E5_FILIAL = '"+xFilial("SE5")+"' " + CRLF
	_cQuery  += " AND E5_SITUACA = '' AND E5_TIPODOC NOT IN ('JR','MT','DC','CH') " + CRLF
	_cQuery  += " AND E5_RECPAG = 'P' AND E5_NUMERO = '' AND E5_MOEDA = 'M1' " + CRLF
	_cQuery  += " AND E5_DTDISPO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + CRLF
	_cQuery  += " ORDER BY CUSTO,FILIAL,DTDISPO" + CRLF
*/

	MemoWrite('D:\PXH096.txt',_cQuery)

	TCQUERY _cQuery NEW ALIAS "TSE5"

	TcSetField("TSE5","DTDISPO","D")
	TcSetField("TSE5","E5VALOR","N",16,4)

	Count to _nRec

	dbSelectArea("TSE5")

	_cArq := CriaTrab(NIL,.F.)
	Copy To &_cArq

	dbCloseArea()

	dbUseArea(.T.,,_cArq,"TSE5",.T.)
	_cInd := "CUSTO+FILIAL+DTOS(DTDISPO)+PREFIXO+NUMERO+PARCELA+TIPO"

	IndRegua("TSE5",_cArq,_cInd,,,"Selecionando Arquivo Trabalho")

	//		MemoWrite("D:\PXH058A.TXT",_cQuery)

	If _nRec > 0

		_cData		:= DTOS(dDataBase)
		_cHora		:= Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
		_cTitulo	:= 'CC_BNDES_'+_cData+'_'+_cHora

		If !_lExcel
			_oPrinter := FWMSPrinter():New(_cTitulo, 6, _lAdjustToLegacy,_cDir, _lDisableSetup,    , , ,    , , .F., )
		Else

			_cTit1 := ""
			If !Empty(MV_PAR03)
				_cTit1 += Alltrim(MV_PAR03)
			Endif
			If !Empty(MV_PAR04)
				_cMVPar04 := "Contrato: "+Alltrim(MV_PAR04)
				_cTit1 += If(Empty(_cTit1),_cMVPar04," - "+_cMVPar04)
			Endif
			If !Empty(MV_PAR05)
				_cMVPar05 := "FRO: "+Alltrim(MV_PAR05)
				_cTit1 += If(Empty(_cTit1),_cMVPar05," - "+_cMVPar05)
			Endif

			_cTit1 += CRLF

			If !Empty(MV_PAR06)
				_cTit1 += Alltrim(MV_PAR06)
			Endif
			If !Empty(MV_PAR07)
				_cMVPar07 := "Contrato: "+Alltrim(MV_PAR07)
				_cTit1 += If(Empty(_cTit1),_cMVPar07," - "+_cMVPar07)
			Endif

			_cTit1 += CRLF

			_cTit1 += "Razão Social: "+ Alltrim(SM0->M0_NOMECOM)+" - Mapa: "+ Alltrim(MV_PAR08)+" - "
			_cTit1 += "Período: "+Dtoc(MV_PAR01)+" - "+dToc(MV_PAR02)

			_oPrinter	:= FWMsExcel():New()
			_cWkSheet	:= "Analítico"
			_cTable		:= _cTit1

			_oPrinter:AddWorkSheet( _cWkSheet )
			_oPrinter:AddTable( _cWkSheet, _cTable )

			_oPrinter:AddColumn( _cWkSheet, _cTable , "Item BNDES"					, 1,1,.F.)
			_oPrinter:AddColumn( _cWkSheet, _cTable , "CC Lajari"					, 1,1,.F.)
			_oPrinter:AddColumn( _cWkSheet, _cTable , "Descrição Sucinta"			, 1,1,.F.)
			_oPrinter:AddColumn( _cWkSheet, _cTable , "Nome do Fornecedor"			, 1,1,.F.)
			_oPrinter:AddColumn( _cWkSheet, _cTable , "CNPJ/CPF"					, 1,1,.F.)
			_oPrinter:AddColumn( _cWkSheet, _cTable , "Data"						, 1,1,.F.)
			_oPrinter:AddColumn( _cWkSheet, _cTable , "Tipo de Título"				, 1,1,.F.)
			_oPrinter:AddColumn( _cWkSheet, _cTable , "Número"						, 1,1,.F.)
			_oPrinter:AddColumn( _cWkSheet, _cTable , "Valor Pago [R$]"				, 2,3,.F.)
			_oPrinter:AddColumn( _cWkSheet, _cTable , "Valor da NF [R$]"			, 2,3,.F.)

		Endif

		GeraTRB()

		LoadTRB()

		_lEnt    := .F.
		_cQuebra := _cQueb1  := _cSubItem := _cSubIt1 := ""
		_nLin  	 := 1000
		_nTotal  := _nTGeral := _nTotIt := _nTNF := _nTGNF := 0

		TRB->(dbGoTop())

		ProcRegua(LastRec())

		While TRB->(!EOF())

			IncProc()

			If !_lExcel
				CheckLine()
			Endif

			_cQueb1		:= Left(TRB->ITEM,1)
			_cSubIt1	:= TRB->ITEM

			If _cQuebra <> _cQueb1

				If _lEnt

					SZJ->(dbSetOrder(1))
					If SZJ->(msSeek(xFilial("SZJ")+_cQuebra))
						_cItem   := Padr(SZJ->ZJ_CODIGO,TamSx3("ZJ_CODIGO")[1])
						_cDescIt := Alltrim(SZJ->ZJ_DESCRIC)

						If !Empty(SZJ->ZJ_CTASUP)
							If TSB->(msSeek(SZJ->ZJ_CTASUP))
								TSB->(RecLock("TSB",.F.))
								TSB->VALOR	+= _nTotal
								TSB->(msUnLock())
							Else
								TSB->(RecLock("TSB",.T.))
								TSB->ITEM	:= SZJ->ZJ_CTASUP
								TSB->VALOR	:= _nTotal
								TSB->(msUnLock())
							Endif
						Endif

					Else
						_cItem   := Padr("999",TamSx3("ZJ_CODIGO")[1])
						_cDescIt := "Não Encontrado"
					Endif

					If !_lExcel
						_oPrinter:Say(_nLin,0015, "SubTotal - "+_cDescIt		,_oFont3)
						_oPrinter:Say(_nLin,0520, TRANS(_nTotal, "@E 999,999,999.99")	,_oFont3,,,,1)
						_nLin += 10
					Else
						_oPrinter:AddRow( _cWkSheet, _cTable,{"SubTotal - "+_cDescIt,,,,,,,,_nTotal,_nTNF})
					Endif

					TSB->(RecLock("TSB",.T.))
					TSB->ITEM	:= _cItem
					TSB->VALOR	:= _nTotal
					TSB->(msUnLock())

					_nTotal  := _nTNF := 0

					If !_lExcel
						CheckLine()
					Endif

				Endif

			Endif

			If _cSubItem <> _cSubIt1
				If _lEnt

					SZJ->(dbSetOrder(1))
					If SZJ->(msSeek(xFilial("SZJ")+_cSubItem))
						_cItem   := Padr(SZJ->ZJ_CODIGO,TamSx3("ZJ_CODIGO")[1])
						_cDescIt := Alltrim(SZJ->ZJ_DESCRIC)

						If !Empty(SZJ->ZJ_CTASUP)
							If TSB->(msSeek(SZJ->ZJ_CTASUP))
								TSB->(RecLock("TSB",.F.))
								TSB->VALOR	+= _nTotIt
								TSB->(msUnLock())
							Else
								TSB->(RecLock("TSB",.T.))
								TSB->ITEM	:= SZJ->ZJ_CTASUP
								TSB->VALOR	:= _nTotIt
								TSB->(msUnLock())
							Endif
						Endif

					Else
						_cItem   := Padr("999",TamSx3("ZJ_CODIGO")[1])
						_cDescIt := "Não Encontrado"
					Endif

					TSB->(RecLock("TSB",.T.))
					TSB->ITEM	:= _cItem
					TSB->VALOR	:= _nTotIt
					TSB->(msUnLock())

					_nTotIt := 0

				Endif
			Endif

			_cQuebra  := Left(TRB->ITEM,1)
			_cSubItem := TRB->ITEM

			_cCnpj := TRB->CNPJ
			If !Empty(TRB->CNPJ)
				If TRB->PESSOA == 'F'
					_cCnpj := Transform(TRB->CNPJ, "@R 999.999.999-99")
				Else
					_cCnpj := Transform(TRB->CNPJ, "@R 99.999.999/9999-99")
				Endif
			Endif

			If !_lExcel
				_oPrinter:Say(_nLin,0015,TRB->ITEM										,_oFont4)
				_oPrinter:Say(_nLin,0040,TRB->DEITEM									,_oFont4)
				_oPrinter:Say(_nLin,0200,TRB->FORNECE									,_oFont4)
				_oPrinter:Say(_nLin,0300,_cCnpj											,_oFont4)
				_oPrinter:Say(_nLin,0380,DTOC(TRB->DTDISPO)								,_oFont4)
				_oPrinter:Say(_nLin,0420,TRB->SR										,_oFont4)
				_oPrinter:Say(_nLin,0440,TRB->CF										,_oFont4)
				_oPrinter:Say(_nLin,0460,TRB->CS										,_oFont4)
				_oPrinter:Say(_nLin,0480,TRB->NUMERO									,_oFont4)
				_oPrinter:Say(_nLin,0520,TRANS(TRB->E5VALOR, "@E 999,999,999.99")		,_oFont4,,,,1)
			Else
				_oPrinter:AddRow( _cWkSheet, _cTable,{;
				TRB->ITEM		,;
				TRB->CC			,;
				TRB->DEITEM		,;
				TRB->FORNECE	,;
				_cCnpj			,;
				TRB->DTDISPO	,;
				TRB->SR			,;
				TRB->NUMERO		,;
				TRB->E5VALOR	,;
				TRB->F1VALOR	})
			Endif

			_nTotal  += TRB->E5VALOR
			_nTGeral += TRB->E5VALOR
			_nTPageF += TRB->E5VALOR
			_nTotIt  += TRB->E5VALOR
			_nTNF    += TRB->F1VALOR
			_nTGNF   += TRB->F1VALOR

			_lEnt := .T.
			_nLin += 8

			TRB->(dbSkip())
		EndDo

		If !_lExcel
			CheckLine()
		Endif

		SZJ->(dbSetOrder(1))
		If SZJ->(msSeek(xFilial("SZJ")+_cQuebra))
			_cItem   := Padr(SZJ->ZJ_CODIGO,TamSx3("ZJ_CODIGO")[1])
			_cDescIt := Alltrim(SZJ->ZJ_DESCRIC)

			If !Empty(SZJ->ZJ_CTASUP)
				If TSB->(msSeek(SZJ->ZJ_CTASUP))
					TSB->(RecLock("TSB",.F.))
					TSB->VALOR	+= _nTotal
					TSB->(msUnLock())
				Else
					TSB->(RecLock("TSB",.T.))
					TSB->ITEM	:= SZJ->ZJ_CTASUP
					TSB->VALOR	:= _nTotal
					TSB->(msUnLock())
				Endif
			Endif

		Else
			_cItem   := Padr("999",TamSx3("ZJ_CODIGO")[1])
			_cDescIt := "Não Encontrado"
		Endif

		If !_lExcel
			_oPrinter:Say(_nLin,0015, "SubTotal - "+_cDescIt		,_oFont3)
			_oPrinter:Say(_nLin,0520, TRANS(_nTotal, "@E 999,999,999.99")	,_oFont3,,,,1)
		Else
			_oPrinter:AddRow( _cWkSheet, _cTable,{"SubTotal - "+_cDescIt,,,,,,,,_nTotal,_nTNF})
		Endif

		TSB->(RecLock("TSB",.T.))
		TSB->ITEM	:= _cQuebra
		TSB->VALOR	:= _nTotal
		TSB->(msUnLock())

		SZJ->(dbSetOrder(1))
		If SZJ->(msSeek(xFilial("SZJ")+_cSubItem))
			_cItem   := Padr(SZJ->ZJ_CODIGO,TamSx3("ZJ_CODIGO")[1])
			_cDescIt := Alltrim(SZJ->ZJ_DESCRIC)
			If !Empty(SZJ->ZJ_CTASUP)
				If TSB->(msSeek(SZJ->ZJ_CTASUP))
					TSB->(RecLock("TSB",.F.))
					TSB->VALOR	+= _nTotIt
					TSB->(msUnLock())
				Else
					TSB->(RecLock("TSB",.T.))
					TSB->ITEM	:= SZJ->ZJ_CTASUP
					TSB->VALOR	:= _nTotIt
					TSB->(msUnLock())
				Endif
			Endif
		Else
			_cItem   := Padr("999",TamSx3("ZJ_CODIGO")[1])
			_cDescIt := "Não Encontrado"
		Endif

		TSB->(RecLock("TSB",.T.))
		TSB->ITEM	:= _cItem
		TSB->VALOR	:= _nTotIt
		TSB->(msUnLock())

		_nLin += 15

		If !_lExcel
			CheckLine()

			_oPrinter:Line(_nLin,0010,_nLin,0580)
			_nLin    += 10

			CheckLine()

			_oPrinter:Say(_nLin,0015, "TOTAL GERAL"								,_oFont3)
			_oPrinter:Say(_nLin,0520, TRANS(_nTGeral, "@E 999,999,999.99")		,_oFont3,,,,1)

			LoadFooter()

			_oPrinter:EndPage()

			LoadSynthetic(_lExcel)

			Ms_Flush()

			_oPrinter:EndPage()

			_oPrinter:Preview()

		Else

			_oPrinter:AddRow( _cWkSheet, _cTable,{"TOTAL GERAL",,,,,,,,_nTGeral,_nTGNF})

			LoadSynthetic(_lExcel)

			_oPrinter:Activate()

			_cArq2 := CriaTrab( NIL, .F. ) + ".xls"

			LjMsgRun( "Gerando o arquivo, aguarde...", "Despesa Financeira", {|| _oPrinter:GetXMLFile( _cArq2 ) } )


			If __CopyFile( _cArq2, _cDir + _cArq2 )
				_oExcelApp := MsExcel():New()
				_oExcelApp:WorkBooks:Open( _cDir + _cArq2 )
				_oExcelApp:SetVisible(.T.)
			Else
				MsgInfo( "Arquivo não copiado para o computador do usário." )
			Endif

		Endif

		TRB->(dbCloseArea())
		TSB->(dbCloseArea())

	Endif

Return(Nil)



Static Function GeraTRB(_cOpt)

	aCampos := {}

	AADD(aCampos,{"ITEM"		,TamSx3("ZJ_CODIGO")[3]		,TamSx3("ZJ_CODIGO")[1]		,TamSx3("ZJ_CODIGO")[2]})
	AADD(aCampos,{"CC"			,TamSx3("CTT_CUSTO")[3]		,TamSx3("CTT_CUSTO")[1]		,TamSx3("CTT_CUSTO")[2]})
	AADD(aCampos,{"DEITEM"		,TamSx3("ZJ_DESCRIC")[3]	,TamSx3("ZJ_DESCRIC")[1]	,TamSx3("ZJ_DESCRIC")[2]})
	AADD(aCampos,{"FORNECE"		,TamSx3("A2_NOME")[3]		,TamSx3("A2_NOME")[1]		,TamSx3("A2_NOME")[2]	})
	AADD(aCampos,{"CNPJ"		,TamSx3("A2_CGC")[3]		,TamSx3("A2_CGC")[1]		,TamSx3("A2_CGC")[2]})
	AADD(aCampos,{"DTDISPO"		,TamSx3("E5_DTDISPO")[3]	,TamSx3("E5_DTDISPO")[1]	,TamSx3("E5_DTDISPO")[2]})
	AADD(aCampos,{"SR"			,TamSx3("E5_TIPO")[3] 		,TamSx3("E5_TIPO")[1]		,TamSx3("E5_TIPO")[2]	})
	AADD(aCampos,{"CF"			,TamSx3("D1_CF")[3]			,TamSx3("D1_CF")[1]			,TamSx3("D1_CF")[2]})
	AADD(aCampos,{"CS"			,TamSx3("D1_CLASFIS")[3]	,TamSx3("D1_CLASFIS")[1]	,TamSx3("D1_CLASFIS")[2]})
	AADD(aCampos,{"NUMERO"		,TamSx3("E5_NUMERO")[3] 	,TamSx3("E5_NUMERO")[1]		,TamSx3("E5_NUMERO")[2]	})
	AADD(aCampos,{"E5VALOR"		,TamSx3("E5_VALOR")[3] 		,TamSx3("E5_VALOR")[1]		,TamSx3("E5_VALOR")[2]	})
	AADD(aCampos,{"PESSOA"		,TamSx3("A2_TIPO")[3] 		,TamSx3("A2_TIPO")[1]		,TamSx3("A2_TIPO")[2]	})
	AADD(aCampos,{"F1VALOR"		,TamSx3("F1_VALBRUT")[3] 	,TamSx3("F1_VALBRUT")[1]	,TamSx3("F1_VALBRUT")[2]	})

	cArqTemp	:=	CriaTrab(aCampos)

	dbUseArea(.T.,,cArqTemp,"TRB",.F.,.F.)

	IndRegua("TRB",cArqTemp,"ITEM+DTOS(DTDISPO)+NUMERO",,,"Indexando Dados")


	_aSintet := {}

	AADD(_aSintet,{"ITEM"		,TamSx3("ZJ_CODIGO")[3]		,TamSx3("ZJ_CODIGO")[1]		,TamSx3("ZJ_CODIGO")[2]})
	AADD(_aSintet,{"VALOR"		,"N"						,14							,2	})

	cArqTemp	:=	CriaTrab(_aSintet)

	dbUseArea(.T.,,cArqTemp,"TSB",.F.,.F.)

	IndRegua("TSB",cArqTemp,"ITEM",,,"Indexando Dados")


Return(Nil)



Static Function LoadTRB()

	TSE5->(dbGoTop())

	ProcRegua(LastRec())

	While TSE5->(!EOF())

		IncProc()

		If TSE5->NUMERO = '000012144'
			_lPare := .T.
		Endif

		SEV->(dbSetOrder(1))
		If SEV->(msSeek(xFilial("SEV")+TSE5->PREFIXO+TSE5->NUMERO+TSE5->PARCELA+TSE5->TIPO+TSE5->CLIFOR+ TSE5->LOJA))

			_cKeySEV := SEV->EV_FILIAL+SEV->EV_PREFIXO+SEV->EV_NUM+SEV->EV_PARCELA+SEV->EV_TIPO+SEV->EV_CLIFOR+SEV->EV_LOJA

			While !SEV->(EOF()) .And. _cKeySEV == SEV->EV_FILIAL+SEV->EV_PREFIXO+SEV->EV_NUM+SEV->EV_PARCELA+SEV->EV_TIPO+SEV->EV_CLIFOR+SEV->EV_LOJA

				If SEV->EV_IDENT = '2'
					SEV->(dbSkip())
					Loop
				Endif

				_nVlPg		:= TSE5->E5VALOR * SEV->EV_PERC
				If TSE5->TIPODOC = 'ES'
					_nVlPg := _nVlPg * -1
				Endif

				dbSelectArea("CTT")
				CTT->(dbSetOrder(1))
				If CTT->(msSeek(xFilial("CTT")+SEV->EV_NATUREZ))

					If CTT->CTT_YRELBN = 'S'
						_cItem   := ""
						_cDescIt := ""
						SZJ->(dbSetOrder(1))
						If SZJ->(msSeek(xFilial("SZJ")+CTT->CTT_YBNDS))
							_cItem   := Alltrim(SZJ->ZJ_CODIGO)
							_cDescIt := Alltrim(Left(SZJ->ZJ_DESCRIC,35))
						Endif

						TRB->(RecLock("TRB",.T.))
						TRB->ITEM		:= _cItem
						TRB->CC			:= SEV->EV_NATUREZ
						TRB->DEITEM		:= _cDescIt
						TRB->FORNECE	:= TSE5->NOME
						TRB->CNPJ		:= TSE5->CNPJ
						TRB->DTDISPO	:= TSE5->DTDISPO

						TRB->SR			:= TSE5->TIPO
						TRB->CF			:= ""
						TRB->CS			:= ""

						TRB->NUMERO		:= TSE5->NUMERO
						TRB->E5VALOR	:= _nVlPg
						TRB->PESSOA		:= If(Type("TSE5->PESSOA") != "U",TSE5->PESSOA,'')

						If TSE5->TIPO = 'NF'
							SF1->(dbSetOrder(1))
							If SF1->(msSeek(xFilial("SF1")+TSE5->NUMERO+TSE5->PREFIXO+TSE5->CLIFOR+TSE5->LOJA))
								TRB->F1VALOR := SF1->F1_VALBRUT
							Endif
						Endif

						TRB->(msUnLock())
					Endif
				Endif

				SEV->(dbSkip())
			EndDo
		Else

			dbSelectArea("CTT")
			CTT->(dbSetOrder(1))
			If CTT->(msSeek(xFilial("CTT")+TSE5->CUSTO))

				If CTT->CTT_YRELBN = 'S'
					_cItem   := ""
					_cDescIt := ""
					SZJ->(dbSetOrder(1))
					If SZJ->(msSeek(xFilial("SZJ")+CTT->CTT_YBNDS))
						_cItem   := Alltrim(SZJ->ZJ_CODIGO)
						_cDescIt := Alltrim(Left(SZJ->ZJ_DESCRIC,35))
					Endif

					_nVlPg		:= TSE5->E5VALOR
					If TSE5->TIPODOC = 'ES'
						_nVlPg := TSE5->E5VALOR * -1
					Endif

					TRB->(RecLock("TRB",.T.))
					TRB->ITEM		:= _cItem
					TRB->CC			:= TSE5->CUSTO
					TRB->DEITEM		:= _cDescIt
					TRB->FORNECE	:= TSE5->NOME
					TRB->CNPJ		:= TSE5->CNPJ
					TRB->DTDISPO	:= TSE5->DTDISPO

					TRB->SR			:= TSE5->TIPO
					TRB->CF			:= ""
					TRB->CS			:= ""

					TRB->NUMERO		:= TSE5->NUMERO
					TRB->E5VALOR	:= _nVlPg
					TRB->PESSOA		:= If(Type("TSE5->PESSOA") != "U",TSE5->PESSOA,'')

					If TSE5->TIPO = 'NF'
						SF1->(dbSetOrder(1))
						If SF1->(msSeek(xFilial("SF1")+TSE5->NUMERO+TSE5->PREFIXO+TSE5->CLIFOR+TSE5->LOJA))
							TRB->F1VALOR := SF1->F1_VALBRUT
						Endif
					Endif

					TRB->(msUnLock())
				Endif
			Endif
		Endif

		TSE5->(dbSkip())
	EndDo

	TSE5->(dbCloseArea())

Return(Nil)


Static Function CheckLine()

	If _nLin > 750

		If _lEnt

			LoadFooter()

			_oPrinter:EndPage()

		Endif

		LoadHeader()

		_nLin := 085
	Endif

Return()



Static Function LoadHeader()

	_oPrinter:SetPortrait()

	_nPag ++

	_oPrinter:StartPage()

	_cTit1 := ""
	If !Empty(MV_PAR03)
		_cTit1 += Alltrim(MV_PAR03)
	Endif
	If !Empty(MV_PAR04)
		_cMVPar04 := "Contrato: "+Alltrim(MV_PAR04)
		_cTit1 += If(Empty(_cTit1),_cMVPar04," - "+_cMVPar04)
	Endif
	If !Empty(MV_PAR05)
		_cMVPar05 := "FRO: "+Alltrim(MV_PAR05)
		_cTit1 += If(Empty(_cTit1),_cMVPar05," - "+_cMVPar05)
	Endif

	_oPrinter:Say(015,010,_cTit1,_oFont1)

	_cTit2 := ""
	If !Empty(MV_PAR06)
		_cTit2 += Alltrim(MV_PAR06)
	Endif
	If !Empty(MV_PAR07)
		_cMVPar07 := "Contrato: "+Alltrim(MV_PAR07)
		_cTit2 += If(Empty(_cTit2),_cMVPar07," - "+_cMVPar07)
	Endif
	_oPrinter:Say(027,010,_cTit2,_oFont1)

	_oPrinter:Say(039,010,"Razão Social: "+ Alltrim(SM0->M0_NOMECOM),_oFont5)
	_oPrinter:Say(039,295,"Mapa: "+ Alltrim(MV_PAR08),_oFont5)
	_oPrinter:Say(039,465,"Período: "+Dtoc(MV_PAR01)+" - "+dToc(MV_PAR02),_oFont5)

	_oPrinter:Box(044,010, 074, 580)

	_oPrinter:Say(070,015,"Item",_oFont5)
	_oPrinter:Line(044,037,074,037)
	_oPrinter:Say(070,040,"Descrição Sucinta",_oFont5)
	_oPrinter:Line(044,197,074,197)
	_oPrinter:Say(070,200,"Nome do Fornecedor",_oFont5)
	_oPrinter:Line(044,297,074,297)
	_oPrinter:Say(070,300,"CNPJ/CPF",_oFont5)
	_oPrinter:Line(059,377,059,522)
	_oPrinter:Say(055,395,"Informações do Documento",_oFont5)
	_oPrinter:Line(044,377,074,377)
	_oPrinter:Say(070,380,"Data",_oFont5)
	_oPrinter:Line(059,417,074,417)
	_oPrinter:Say(070,420,"SR",_oFont5)
	_oPrinter:Line(059,437,074,437)
	_oPrinter:Say(070,440,"CF",_oFont5)
	_oPrinter:Line(059,457,074,457)
	_oPrinter:Say(070,460,"CS",_oFont5)
	_oPrinter:Line(059,477,074,477)
	_oPrinter:Say(070,480,"Núm.",_oFont5)
	_oPrinter:Line(044,522,074,522)
	_oPrinter:Say(070,530,"Valor em R$",_oFont5)

	_oPrinter:Say(815,520,"Folha: " + cValToChar(_nPag)	,_oFont2)
	_oPrinter:Say(825,520,"Data: " + dToc(dDataBase)	,_oFont2)

Return()



Static Function LoadFooter()

	_nTPageT += _nTPageF

	_oPrinter:Box(765,010, 800, 580)

	_oPrinter:Say(775,350,"Total desta Folha: "			,_oFont5)
	_oPrinter:Say(775,520,TRANS(_nTPageF, "@E 999,999,999.99")	,_oFont5,,,,1)

	_oPrinter:Say(785,350,"Transporte Folha Anterior: "	,_oFont5)
	_oPrinter:Say(785,520,TRANS(_nTPageA, "@E 999,999,999.99")	,_oFont5,,,,1)

	_oPrinter:Say(795,350,"SubTotal a Transportar: "	,_oFont5)
	_oPrinter:Say(795,520,TRANS(_nTPageT, "@E 999,999,999.99")	,_oFont5,,,,1)

	_nTPageA := _nTPageT
	_nTPageF := 0

Return()


Static Function LoadSynthetic(_lExcel)

	If !_lExcel
		_oPrinter:SetPortrait()

		_nPag ++

		_oPrinter:StartPage()

		_cTit2 := ""
		If !Empty(MV_PAR06)
			_cTit2 += Alltrim(MV_PAR06)
		Endif

		_cTit2 := ""
		If !Empty(MV_PAR03)
			_cTit2 += If(Empty(_cTit2),MV_PAR03," - "+MV_PAR03)
		Endif

		If !Empty(MV_PAR07)
			_cMVPar07 := "Contrato: "+Alltrim(MV_PAR07)
			_cTit2 += If(Empty(_cTit2),_cMVPar07," - "+_cMVPar07)
		Endif

		_oPrinter:Say(015,010,_cTit2,_oFont1)

		_oPrinter:Say(027,010,"Razão Social: "+ Alltrim(SM0->M0_NOMECOM),_oFont5)
		_oPrinter:Say(027,295,"Mapa: "+ Alltrim(MV_PAR08),_oFont5)
		_oPrinter:Say(027,465,"Período: "+Dtoc(MV_PAR01)+" - "+dToc(MV_PAR02),_oFont5)

		_oPrinter:Say(045,010,"Totais: ",_oFont1)
	Else

		_cTit2 := ""
		If !Empty(MV_PAR06)
			_cTit2 += Alltrim(MV_PAR06)
		Endif

		_cTit2 := ""
		If !Empty(MV_PAR03)
			_cTit2 += If(Empty(_cTit2),MV_PAR03," - "+MV_PAR03)
		Endif

		If !Empty(MV_PAR07)
			_cMVPar07 := "Contrato: "+Alltrim(MV_PAR07)
			_cTit2 += If(Empty(_cTit2),_cMVPar07," - "+_cMVPar07)
		Endif

		_cTit2 += " - Razão Social: "+ Alltrim(SM0->M0_NOMECOM)
		_cTit2 += " - Mapa: "+ Alltrim(MV_PAR08)
		_cTit2 += " - Período: "+Dtoc(MV_PAR01)+" - "+dToc(MV_PAR02)

		_cWkSheet	:= "Sintético"
		_cTable		:= _cTit2

		_oPrinter:AddWorkSheet( _cWkSheet )
		_oPrinter:AddTable( _cWkSheet, _cTable )

		_oPrinter:AddColumn( _cWkSheet, _cTable , "Descrição"		, 1,1,.F.)
		_oPrinter:AddColumn( _cWkSheet, _cTable , "Total"			, 3,2,.F.)

	Endif

	_nTotCC := 0
	_nLin 		:= 60

	If TSB->(msSeek("999"))
		If !_lExcel
			_oPrinter:Say(_nLin,010,'  - Não encontrado',_oFont3)
			_nLin += 10
			_oPrinter:Say(_nLin,015,'  - Não encontrado',_oFont4)
			_oPrinter:Say(_nLin,250,TRANS(TSB->VALOR, "@E 999,999,999.99")		,_oFont4,,,,1)
			_nLin += 10
		Else
			_oPrinter:AddRow( _cWkSheet, _cTable,{'  - Não encontrado',TSB->VALOR	})
		Endif
		_nTotCC += TSB->VALOR
	Endif

	_cNiv1    := _cNiv1Bkp := ''
	_nNiv1    := 0
	_nLin1    := 0
	_nCol     := 10
	_cMsg     := ''
	_aExcel   := {}

	SZJ->(dbSetOrder(1))
	If SZJ->(MsSeek(xFilial("SZJ")))

		_cKey := SZJ->ZJ_FILIAL

		While SZJ->(!EOF()) .And. _cKey == SZJ->ZJ_FILIAL

			_cNivel := SZJ->ZJ_CODIGO

			If Len(Alltrim(SZJ->ZJ_CODIGO)) = 1 //1
				_cNiv1 := Alltrim(SZJ->ZJ_CODIGO) +" - "+Alltrim(SZJ->ZJ_DESCRIC)
				_oFont := _oFont3
				_nCol  := 10
			ElseIf Len(Alltrim(SZJ->ZJ_CODIGO)) = 3 //1.1
				_oFont := _oFont4
				_nCol  := 15
			ElseIf Len(Alltrim(SZJ->ZJ_CODIGO)) = 5 //1.1.1
				_nCol  := 20
				_oFont := _oFont6
			Endif

			If _cNiv1Bkp != _cNiv1 .and. _nNiv1 > 0
				If !_lExcel
					_oPrinter:Say(_nLin1,250,TRANS(_nNiv1, "@E 999,999,999.99"),_oFont,,,,1)
				Else
					_nPos := aScan(_aExcel,{|x| x[1] == _cNiv1Bkp})
					If _nPos = 0
						AADD(_aExcel,{_cNiv1Bkp,0})
					Else
						_aExcel[_nPos][2] := _nNiv1
					Endif

				Endif
				_nNiv1 := 0
			Endif

			_cMsg := Alltrim(SZJ->ZJ_CODIGO) +" - "+Alltrim(SZJ->ZJ_DESCRIC)
			If !_lExcel
				_oPrinter:Say(_nLin,_nCol,_cMsg,_oFont)
			ELSE
				_nPos := aScan(_aExcel,{|x|x[1] == _cMsg})
				If _nPos = 0
					AADD(_aExcel,{_cMsg,0})
				Endif
			Endif

			_nVal := 0
			If TSB->(msSeek(SZJ->ZJ_CODIGO))
				_nVal := TSB->VALOR
			Endif

			If Len(Alltrim(SZJ->ZJ_CODIGO)) > 1 .Or. SZJ->ZJ_ClASSE = '2'
				If !_lExcel
					_oPrinter:Say(_nLin,250,TRANS(_nVal, "@E 999,999,999.99"),_oFont,,,,1)
				Else
					_nPos := aScan(_aExcel,{|x|x[1] == _cMsg})
					If _nPos = 0
						AADD(_aExcel,{_cMsg,_nVal})
					Else
						_aExcel[_nPos][2] := _nVal
					Endif
				Endif
			Endif

			If SZJ->ZJ_CLASSE = '2'
				_nTotCC += _nVal
				_nNiv1 += _nVal
			Endif

			_cNiv1Bkp := _cNiv1

			If Len(Alltrim(SZJ->ZJ_CODIGO)) = 1
				_nLin1 := _nLin
			Endif

			_nLin += 10

			SZJ->(dbSkip())
		EndDo

	Endif

	_nLin += 10

	If !_lExcel 
		_oPrinter:Say(_nLin,010,"Total Geral:",_oFont3)
		_oPrinter:Say(_nLin,250,TRANS(_nTotCC, "@E 999,999,999.99")		,_oFont3,,,,1)

		_oPrinter:Say(815,520,"Folha: " + cValToChar(_nPag)	,_oFont2)
		_oPrinter:Say(825,520,"Data: " + dToc(dDataBase)	,_oFont2)
	Else

		For A := 1 To Len(_aExcel)
			_oPrinter:AddRow( _cWkSheet, _cTable,{_aExcel[A][1],_aExcel[A][2]	})
		Next A

		_oPrinter:AddRow( _cWkSheet, _cTable,{,	})
		_oPrinter:AddRow( _cWkSheet, _cTable,{"Total Geral:",_nTotCC	})
	Endif

Return(Nil)



Static Function ATUSX1()

	_cPerg := "PXH096"

	//    	   Grupo/Ordem/Pergunta        /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid  /Var01     /Def01    /defspa1/defeng1/Cnt01/Var02/Def02  /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03  /Var04/Def04/defspa4/defeng4/Cnt04  /Var05/Def05 /deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(_cPerg,"01","Data De       ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""     ,"MV_PAR01","       ",""     ,""     ,""   ,""   ,"    " ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""    ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"02","Data Ate      ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""     ,"MV_PAR02","       ",""     ,""     ,""   ,""   ,"    " ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""    ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"03","Titulo        ?",""       ,""      ,"mv_ch3","C" ,60     ,0      ,0     ,"G",""     ,"MV_PAR03","       ",""     ,""     ,""   ,""   ,"    " ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""    ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"04","Contrato      ?",""       ,""      ,"mv_ch4","C" ,30     ,0      ,0     ,"G",""     ,"MV_PAR04","       ",""     ,""     ,""   ,""   ,"    " ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""    ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"05","FRO           ?",""       ,""      ,"mv_ch5","C" ,30     ,0      ,0     ,"G",""     ,"MV_PAR05","       ",""     ,""     ,""   ,""   ,"    " ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""    ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"06","Titulo FCO    ?",""       ,""      ,"mv_ch6","C" ,60     ,0      ,0     ,"G",""     ,"MV_PAR06","       ",""     ,""     ,""   ,""   ,"    " ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""    ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"07","Contrato FCO  ?",""       ,""      ,"mv_ch7","C" ,30     ,0      ,0     ,"G",""     ,"MV_PAR07","       ",""     ,""     ,""   ,""   ,"    " ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""    ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"08","Mapa          ?",""       ,""      ,"mv_ch8","C" ,10     ,0      ,0     ,"G",""     ,"MV_PAR08","       ",""     ,""     ,""   ,""   ,"    " ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""    ,""      ,""     ,""   ,"")
	//	U_CRIASX1(_cPerg,"09","Excel         ?",""       ,""      ,"mv_ch9","C" ,01     ,0      ,0     ,"C",""     ,"MV_PAR09","Não    ",""     ,""     ,""   ,""   ,"Sim " ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""    ,""      ,""     ,""   ,"")

Return