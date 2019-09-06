#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} CR0105
//Eficiencia de entrega (Pedido de Vendas)
@author Fabiano
@since 21/05/2018
@version 1.0
/*/
User Function CR0105()

	Local _nOpc		:= 0
	Local _oDlg		:= Nil
	Local _cDirRede		:= "\CRYSTAL\"
	Local _cDir			:= 'C:\TOTVS\CRONNOS\CRYSTAL\'	// Diretório onde estão os arquivos RPT

	_aDir := StrTokArr( _cDir , "\" )
	_cDirTmp := _aDir[1]
	For _nDir := 2 to Len(_aDir)
		_cDirTmp += "\"+_aDir[_nDir]
		If !ExistDir( _cDirTmp )
			If MakeDir( _cDirTmp ) <> 0
				MsgAlert(  "Impossível criar diretorio ( "+_cDirTmp+" ) " )
				Return(Nil)
			EndIf
		EndIf
	Next _nDir

	Private _cTitulo	:= 'Processando'
	Private _cMsgTit	:= 'Aguarde, analisando Pedidos...'

	Atu_SX1()

	DEFINE MSDIALOG _oDlg  FROM 0,0 TO 160,380 TITLE "Eficiencia de Entrega" OF _oDlg PIXEL

	@ 05,10 TO 050,180 OF _oDlg PIXEL

	@ 15,18 SAY "Relatório de Eficiência de Entrega conforme os parâmetros	"	OF _oDlg PIXEL
	@ 23,18 SAY "informados pelo usuário.									"	OF _oDlg PIXEL

	DEFINE SBUTTON FROM 058,030 TYPE 5 ACTION (Pergunte("CR0105",.T.))	ENABLE Of _oDlg
	DEFINE SBUTTON FROM 058,080 TYPE 1 ACTION (_nOpc:=1,_oDlg:END())	ENABLE Of _oDlg
	DEFINE SBUTTON FROM 058,130 TYPE 2 ACTION (_nOpc:=0,_oDlg:END())	ENABLE Of _oDlg

	ACTIVATE MSDIALOG _oDlg CENTERED

	If _nOpc == 1
		FWMsgRun(, {|_oMsg| CR105A(_oMsg) }, _cTitulo, _cMsgTit )
	Endif

Return




Static Function CR105A(_oMsg)

	Local _cQuery	:= ''
	Local _nProc	:= 0
	Local _nZZ		:= 0
	Local _nEnt_AN	:= 0
	Local _nEnt_OK	:= 0
	Local _nEnt_AT	:= 0
	Local _nNEnt_AT	:= 0
	Local _nTProg	:= 0
	Local _nNEnt_OK	:= 0
	Local _aStru	:= {}
	Local _dEntIni	:= cTod('')
	Local _dEntFim	:= cTod('')
	Local _cSeek	:= ''

	Pergunte("CR0105",.F.)

	If MV_PAR10 = 1
		AADD(_aStru,{"CLIENTE" , "C" , 06, 0 })
		AADD(_aStru,{"LOJA"    , "C" , 02, 0 })
		AADD(_aStru,{"NOMECLI" , "C" , 40, 0 })
	Else
		AADD(_aStru,{"REFERE" , "C" , 06, 0 })// Referencia
		AADD(_aStru,{"DTMES"  , "D" , 08, 0 })
	Endif

	If MV_par09 = 1
		AADD(_aStru,{"QTDPROG" , "N" , 12, 4 })
	Else
		AADD(_aStru,{"QTDPROG" , "C" , 12, 0 })
	Endif
	AADD(_aStru,{"ENTR_AN" , "N" , 12, 4 })
	AADD(_aStru,{"ENTR_OK" , "N" , 12, 4 })
	AADD(_aStru,{"ENTR_AT" , "N" , 12, 4 })
	AADD(_aStru,{"EFICIEN" , "N" , 12, 4 })
	AADD(_aStru,{"NENT_OK" , "N" , 12, 4 })
	AADD(_aStru,{"NENT_AT" , "N" , 12, 4 })

	_cArqTrb := CriaTrab(_aStru,.T.)

	If MV_PAR10 = 1
		_cIndTrb := "CLIENTE+LOJA"
	Else
		_cIndTrb := "REFERE"
	Endif

	dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

	dbSelectArea("TRB")
	IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")


	If Select("ZZ") > 0
		ZZ->(dbCloseArea())
	Endif


	//Pedidos em aberto atrasados
	_cQuery  := " SELECT C6_CLI,C6_LOJA,A1_NOME,C5_EMISSAO,C6_NUM,C6_ITEM,C6_QTDVEN AS QTDVEN,C6_QTDENT AS QTDENT,C6_ENTREG, " +CRLF
	_cQuery  += " COALESCE(F2_DTENTR,'') AS F2_DTENTR,C6_YDTFECH,COALESCE(F2_EMISSAO,'') AS F2_EMISSAO " +CRLF
	_cQuery  += " FROM "+RetSqlName("SC6")+" C6 " +CRLF
	_cQuery  += " INNER JOIN "+RetSqlName("SC5")+" C5 ON C5_NUM = C6_NUM " +CRLF
	_cQuery  += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD = C6_PRODUTO " +CRLF
	_cQuery  += " INNER JOIN "+RetSqlName("SA1")+" A1 ON A1_COD+A1_LOJA = C6_CLI+C6_LOJA " +CRLF
	_cQuery  += " INNER JOIN "+RetSqlName("SF4")+" F4 ON F4_CODIGO = C6_TES " +CRLF
	_cQuery  += " LEFT  JOIN "+RetSqlName("SD2")+" D2 ON D2_PEDIDO+D2_ITEMPV = C6_NUM+C6_ITEM AND D2.D_E_L_E_T_ = '' " +CRLF
	_cQuery  += " LEFT  JOIN "+RetSqlName("SF2")+" F2 ON D2_SERIE+D2_DOC = F2_SERIE+F2_DOC AND F2.D_E_L_E_T_ = '' " +CRLF
	_cQuery  += " WHERE C6.D_E_L_E_T_ = '' AND C5.D_E_L_E_T_ = '' AND A1.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' " +CRLF
	_cQuery  += " AND C5_TIPO = 'N' " +CRLF
	_cQuery  += " AND C6_ENTREG BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' " +CRLF
	_cQuery  += " AND C6_BLQ <> 'R' AND C6_PEDAMOS = 'N' " +CRLF
	_cQuery  += " AND C6_CLI BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND C6_LOJA BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' " +CRLF
	_cQuery  += " AND B1_GRUPO BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"' " +CRLF
	_cQuery  += " AND F4_DUPLIC = 'S' " +CRLF
	If MV_PAR10 = 1
		_cQuery  += " ORDER BY C6_CLI,C6_LOJA " +CRLF
	Else
		_cQuery  += " ORDER BY C6_ENTREG,C6_YDTFECH " +CRLF
	Endif
	TCQUERY _cQuery NEW ALIAS "ZZ"

	TCSETFIELD("ZZ","C6_ENTREG"	,"D")
	TCSETFIELD("ZZ","C6_YDTFECH","D")
	TCSETFIELD("ZZ","F2_DTENTR"	,"D")
	TCSETFIELD("ZZ","F2_EMISSAO","D")
	TCSETFIELD("ZZ","QTDVEN"	,"N",12,2)
	TCSETFIELD("ZZ","QTDENT"	,"N",12,2)

	Count to _nZZ

	ZZ->(dbGotop())

	_nProc	:= _nEnt_AN := _nEnt_OK  := _nEnt_AT := _nNEnt_AT := _nTProg := _nNEnt_OK := 0

	While ZZ->(!Eof())

		_nProc ++

		_oMsg:cCaption := ('Processando Registro '+Alltrim(Str(_nProc))+' de '+Alltrim(Str(_nZZ)))
		ProcessMessages()

		_dEntIni := ZZ->C6_ENTREG
		_dEntFim := If(!Empty(ZZ->C6_YDTFECH),If(ZZ->C6_YDTFECH > ZZ->C6_ENTREG,ZZ->C6_YDTFECH,ZZ->C6_ENTREG),ZZ->C6_ENTREG)

		If MV_PAR10 = 1
			_cSeek := ZZ->C6_CLI+ZZ->C6_LOJA
		Else
			_cSeek := Left(Capital(MesExtenso(_dEntFim)),3)+'/'+Right(StrZero(Year(_dEntFim),4),2)
		Endif

		If !TRB->(dbSeek(_cSeek))

			TRB->(RecLock("TRB",.T.))
			If MV_PAR10 = 1
				TRB->CLIENTE	:= ZZ->C6_CLI
				TRB->LOJA		:= ZZ->C6_LOJA
				IF MV_PAR09 = 1
					TRB->NOMECLI	:= ZZ->A1_NOME
				Else
					TRB->NOMECLI	:= "("+ZZ->C6_CLI+"-"+ZZ->C6_LOJA+") "+ZZ->A1_NOME
				Endif
			Else
				TRB->DTMES	:= LastDay(_dEntFim)
				TRB->REFERE	:= Left(Capital(MesExtenso(_dEntFim)),3)+'/'+Right(StrZero(Year(_dEntFim),4),2)
			Endif
			If MV_par09 = 1
				TRB->QTDPROG	:= 1
			Else
				TRB->QTDPROG	:= StrZero(1,10)
			Endif
			_nTProg   ++

			If ZZ->QTDENT = ZZ->QTDVEN
				If ZZ->F2_EMISSAO < _dEntIni
					TRB->ENTR_AN	:= 1
					TRB->ENTR_OK	:= 0
					TRB->ENTR_AT	:= 0
					TRB->NENT_OK	:= 0
					TRB->NENT_AT	:= 0
					_nEnt_AN ++
				ElseIf ZZ->F2_EMISSAO >= _dEntIni  .And. ZZ->F2_EMISSAO <= _dEntFim
					TRB->ENTR_AN	:= 0
					TRB->ENTR_OK	:= 1
					TRB->ENTR_AT	:= 0
					TRB->NENT_OK	:= 0
					TRB->NENT_AT	:= 0
					_nEnt_OK ++
				Else
					TRB->ENTR_AN	:= 0
					TRB->ENTR_OK	:= 0
					TRB->ENTR_AT	:= 1
					TRB->NENT_OK	:= 0
					TRB->NENT_AT	:= 0
					_nEnt_AT ++
				Endif
			Else
				If _dEntFim >= dDatabase
					TRB->ENTR_AN	:= 0
					TRB->ENTR_OK	:= 0
					TRB->ENTR_AT	:= 0
					TRB->NENT_OK	:= 1
					TRB->NENT_AT	:= 0
					_nNEnt_OK ++
				Else
					TRB->ENTR_AN	:= 0
					TRB->ENTR_OK	:= 0
					TRB->ENTR_AT	:= 0
					TRB->NENT_OK	:= 0
					TRB->NENT_AT	:= 1
					_nNEnt_AT  ++
				Endif
			Endif

			TRB->EFICIEN := ((TRB->ENTR_AN + TRB->ENTR_OK)* 100) /(TRB->ENTR_AN + TRB->ENTR_OK + TRB->NENT_AT + TRB->ENTR_AT)
			TRB->(MsUnlock())
		Else

			TRB->(RecLock("TRB",.F.))

			If MV_par09 = 1
				TRB->QTDPROG	++
			Else
				TRB->QTDPROG	:= StrZero(Val(TRB->QTDPROG)+1,10)
			Endif

			_nTProg   ++

			If ZZ->QTDENT = ZZ->QTDVEN
				If ZZ->F2_EMISSAO < _dEntIni
					TRB->ENTR_AN	++
					_nEnt_AN  ++
				ElseIf ZZ->F2_EMISSAO >= _dEntIni  .And. ZZ->F2_EMISSAO <= _dEntFim
					TRB->ENTR_OK	++
					_nEnt_OK  ++
				Else
					TRB->ENTR_AT	++
					_nEnt_AT  ++
				Endif
			Else
				If _dEntFim >= dDatabase
					TRB->NENT_OK	++
					_nNEnt_OK  ++
				Else
					TRB->NENT_AT	++
					_nNEnt_AT  ++
				Endif
			Endif

			TRB->EFICIEN := ((TRB->ENTR_AN + TRB->ENTR_OK)* 100) /(TRB->ENTR_AN + TRB->ENTR_OK + TRB->NENT_AT + TRB->ENTR_AT)
			TRB->(MsUnlock())
		Endif

		ZZ->(dbSkip())
	Enddo

	ZZ->(dbcloseArea())

	If MV_PAR10 = 1
		TRB->(RecLock("TRB",.T.))
		TRB->CLIENTE	:= "ZZZZZZ"
		TRB->LOJA		:= "ZZ"
		TRB->NOMECLI	:= "(000000-00) TOTAL"
		If MV_par09 = 1
			TRB->QTDPROG	:= _nTProg
		Else
			TRB->QTDPROG	:= StrZero(_nTProg,10)
		Endif
		TRB->ENTR_AN	:= _nEnt_AN
		TRB->ENTR_OK	:= _nEnt_OK
		TRB->ENTR_AT	:= _nEnt_AT
		TRB->NENT_AT	:= _nNEnt_AT
		TRB->NENT_OK	:= _nNEnt_OK
		TRB->EFICIEN := ((TRB->ENTR_AN + TRB->ENTR_OK)* 100) /(TRB->ENTR_AN + TRB->ENTR_OK + TRB->NENT_AT + TRB->ENTR_AT)
		TRB->(MsUnlock())
	Endif

	If _nProc > 0
		If MV_par09 = 1
			GeraExcel(_oMsg)
		Else
			GeraGrafico(_oMsg,_nProc,_nZZ)
		Endif
	Else
		MsgInfo("Não existem dados para os parâmetros informados!")
	Endif

Return



Static Function GeraExcel(_oMsg)

	Local _oFwMsEx := FWMsExcel():New()
	Local _cDirTmp := GetTempPath()

	TRB->(dbGotop())

	_lFirst := .T.

	While !TRB->(Eof())

		If _lFirst

			_cTable		:= 	"Eficiencia Entrega de "+dToc(MV_PAR03)+" a "+dToc(MV_PAR04)
			_cWorkSheet	:= 	"Eficiencia_entrega"

			_oFwMsEx:AddWorkSheet( _cWorkSheet )
			_oFwMsEx:AddTable( _cWorkSheet, _cTable )

			If MV_PAR10 = 1
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Cliente"			, 1,1,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Loja"				, 1,1,.F.)
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Nome"				, 1,1,.F.)
			Else
				_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Mês Referência"			, 1,1,.F.)
			Endif

			_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Qtde Programações"	, 3,2,.F.)
			_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Entregue Antecipado", 3,2,.F.)
			_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Entregue (OK)"		, 3,2,.F.)
			_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Entregue em Atraso"	, 3,2,.F.)
			_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Não Entregue (OK)"	, 3,2,.F.)
			_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Não Entregue Atraso", 3,2,.F.)
			_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Eficiência (%)"		, 3,2,.F.)

			_lFirst := .F.
		Endif

		If MV_PAR10 = 1
			If TRB->CLIENTE = "ZZZZZZ"
				_oFwMsEx:AddRow( _cWorkSheet, _cTable,{;
				,;
				,;
				,;
				,;
				,;
				,;
				,;
				,;
				,;
				})
			Endif

			_oFwMsEx:AddRow( _cWorkSheet, _cTable,{;
			TRB->CLIENTE	,;
			TRB->LOJA		,;
			TRB->NOMECLI	,;
			TRB->QTDPROG	,;
			TRB->ENTR_AN	,;
			TRB->ENTR_OK	,;
			TRB->ENTR_AT	,;
			TRB->NENT_OK	,;
			TRB->NENT_AT	,;
			TRB->EFICIEN	})
		Else
			_oFwMsEx:AddRow( _cWorkSheet, _cTable,{;
			TRB->REFERE		,;
			TRB->QTDPROG	,;
			TRB->ENTR_AN	,;
			TRB->ENTR_OK	,;
			TRB->ENTR_AT	,;
			TRB->NENT_OK	,;
			TRB->NENT_AT	,;
			TRB->EFICIEN	})
		Endif


		TRB->(dbSkip())
	EndDo

	TRB->(dbCloseArea())

	_oFwMsEx:Activate()

	_cArq2 := CriaTrab( NIL, .F. ) + ".xls"

	LjMsgRun( "Gerando o arquivo, aguarde...", "Eficiencia de Entrega", {|| _oFwMsEx:GetXMLFile( _cArq2 ) } )

	_cDat1    := GravaData(dDataBase,.f.,8)
	_cHor1    := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

	_cArq := 'Eficiencia_Entrega_'+_cDat1+'_'+_cHor1 + ".xls"

	If __CopyFile( _cArq2, _cDirTmp + _cArq )
		_oExcelApp := MsExcel():New()
		_oExcelApp:WorkBooks:Open( _cDirTmp + _cArq )
		_oExcelApp:SetVisible(.T.)
	Endif

Return(Nil)


Static Function GeraGrafico(_oMsg,_nProc,_nZZ)

	Local _cDirRede		:= "\CRYSTAL\"
	Local _cDir			:= 'C:\TOTVS\CRONNOS\CRYSTAL\'	// Diretório onde estão os arquivos RPT
	Local _cArqDBF		:= "CR0105.dbf"
	Local _cRelRpt		:= "CR0105"

	_aDir := StrTokArr( _cDir , "\" )
	_cDirTmp := _aDir[1]
	For _nDir := 2 to (Len(_aDir)-1)
		_cDirTmp += "\"+_aDir[_nDir]
		If !ExistDir( _cDirTmp )
			If MakeDir( _cDirTmp ) <> 0
				MsgAlert(  "Impossível criar diretorio ( "+_cDirTmp+" ) " )
				Return(Nil)
			EndIf
		EndIf
	Next _nDir

	If MV_PAR10 = 1
		CpyS2T(_cDirRede+'CR0105.RPT',_cDir,.T.)
	Else
		CpyS2T(_cDirRede+'CR0105A.RPT',_cDir,.T.)
		_cArqDBF := "CR0105A.dbf"
		_cRelRpt := "CR0105A"
	Endif

	_aTSB := {}
	AADD(_aTSB,{"TIPO" 			, "C" , 01, 0 })
	If MV_PAR10 = 1
		AADD(_aTSB,{"CLIENTE" 		, "C" , 06, 0 })
		AADD(_aTSB,{"LOJA"    		, "C" , 02, 0 })
		AADD(_aTSB,{"NOMECLI" 		, "C" , 40, 0 })
	Else
		AADD(_aTSB,{"REFERE" , "C" , 06, 0 })// Referencia
		AADD(_aTSB,{"DTMES"  , "D" , 08, 0 })
	Endif
	AADD(_aTSB,{"QTDPROG"		, "N" , 12, 4 })
	AADD(_aTSB,{"ENTR_AN" 		, "N" , 12, 4 })
	AADD(_aTSB,{"ENTR_OK" 		, "N" , 12, 4 })
	AADD(_aTSB,{"ENTR_AT" 		, "N" , 12, 4 })
	AADD(_aTSB,{"EFICIEN" 		, "N" , 12, 4 })
	AADD(_aTSB,{"DATADE"  		, "D" , 08, 0 })
	AADD(_aTSB,{"DATAATE" 		, "D" , 08, 0 })
	AADD(_aTSB,{"OBJETIV" 		, "N" , 06, 2 })

	_cArqTSB := CriaTrab(_aTSB,.T.)

	If MV_PAR10 = 1
		_cIndTSB := "TIPO+CLIENTE+LOJA"
	Else
		_cIndTSB := "TIPO+DTOS(DTMES)"
	Endif

	dbUseArea(.T.,,_cArqTSB,"TSB",.F.,.F.)

	dbSelectArea("TSB")
	IndRegua("TSB",_cArqTSB,_cIndTSB,"D",,"Criando Trabalho...")


	dbSelectArea("TRB")

	_cArquivo := CriaTrab(Nil,.F.)
	Copy To &_cArquivo

	dbCloseArea()

	dbUseArea(.T.,,_cArquivo,"TRB",.T.)
	_cChave := "QTDPROG"

	//	IndRegua("TRB",_cArquivo,_cChave,"D",,"Selecionando Arquivo Trabalho")
	IndRegua("TRB",_cArquivo,_cChave)

	_oMsg:cCaption := ('Processando Registro '+Alltrim(Str(_nProc))+' de '+Alltrim(Str(_nZZ)))
	ProcessMessages()

	If MV_PAR10 = 1
		TRB->(DbGoBottom())
	Else
		TRB->(DbGotop())
	Endif

	_nQtdCli := 1
	_cCliLj  := ""

	While TRB->(!Eof())

		If MV_PAR10 = 1
			If !Empty(_cCliLj)
				If _cCliLj == TRB->CLIENTE + TRB->LOJA
					Exit
				Endif
			Endif

			If _nQtdCli > 20
				Exit
			Endif
		Endif

		_nQtdCli ++

		TSB->(RecLock("TSB",.T.))
		TSB->TIPO			:= If(MV_PAR10 = 1,If(TRB->CLIENTE = "ZZZZZZ","A","B"),"A")
		If MV_PAR10 = 1
			TSB->CLIENTE	:= TRB->CLIENTE
			TSB->LOJA		:= TRB->LOJA
			TSB->NOMECLI	:= TRB->NOMECLI
		Else
			TSB->REFERE		:= TRB->REFERE
			TSB->DTMES		:= TRB->DTMES
		Endif
		TSB->QTDPROG		:= Val(TRB->QTDPROG)
		TSB->EFICIEN		:= TRB->EFICIEN
		TSB->DATADE			:= MV_PAR03
		TSB->DATAATE		:= MV_PAR04
		TSB->OBJETIV		:= MV_PAR11
		TSB->(MsUnlock())

		If MV_PAR10 = 1
			_cCliLj := TRB->CLIENTE + TRB->LOJA
		Endif

		If Mv_PAR10 = 1
			TRB->(dbSkip(-1))
		Else
			TRB->(dbSkip())
		Endif
	EndDo

	TRB->(dbCloseArea())

	FErase(_cArquivo+OrdBagExt())

	If _nQtdCli > 1

		dbSelectArea("TSB")

		Set Filter To

		COPY to &_cArqDBF VIA "DBFCDXADS"

		_CopyFile( _cArqDBF, _cDir + _cArqDBF)

		FErase(_cArqDBF)

		_cOptions := "1;0;1;Eficiência de Entrega"

		Callcrys(_cRelRpt, ,_cOptions)
	Else
		MsgAlert("Não foi possível encontrar dados para geração do gráfico.")
	Endif

	TSB->(dbCloseArea())

Return(Nil)



Static Function Atu_SX1()

	_cPerg := "CR0105"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                            ³
	//³ mv_par01        	// Do Pedido                                ³
	//³ mv_par02        	// Ate o Pedido                             ³
	//³ mv_par03 	     	// Data de Entrega De                       ³
	//³ mv_par04 	     	// Data de Entrega Ate                      ³
	//³ mv_par05 	     	// Cliente De                               ³
	//³ mv_par06 	     	// Cliente Ate                              ³
	//³ mv_par07 	     	// Loja De                                  ³
	//³ mv_par08 	     	// Loja Ate                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄ¿

	//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02	/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(_cPerg,"01","Pedido de             ?",""       ,""      ,"mv_ch1","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   		,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"02","Pedido Ate            ?",""       ,""      ,"mv_ch2","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   		,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"03","Entrega De            ?",""       ,""      ,"mv_ch3","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR03",""               ,""     ,""     ,""   ,""   		,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"04","Entrega Ate           ?",""       ,""      ,"mv_ch4","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR04",""               ,""     ,""     ,""   ,""   		,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"05","Cliente De            ?",""       ,""      ,"mv_ch5","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR05",""               ,""     ,""     ,""   ,""   		,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CLI")
	U_CRIASX1(_cPerg,"06","Cliente Ate           ?",""       ,""      ,"mv_ch6","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR06",""               ,""     ,""     ,""   ,""   		,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CLI")
	U_CRIASX1(_cPerg,"07","Loja De               ?",""       ,""      ,"mv_ch7","C" ,02     ,0      ,0     ,"G",""            ,"MV_PAR07",""               ,""     ,""     ,""   ,""   		,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"08","Loja Ate              ?",""       ,""      ,"mv_ch8","C" ,02     ,0      ,0     ,"G",""            ,"MV_PAR08",""               ,""     ,""     ,""   ,""   		,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"09","Tipo                  ?",""       ,""      ,"mv_ch9","N" ,01     ,0      ,0     ,"C",""            ,"MV_PAR09","Excel"          ,""     ,""     ,""   ,""        ,"Gráfico"        ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"10","Analitico/Sintetico   ?",""       ,""      ,"mv_cha","N" ,01     ,0      ,0     ,"C",""            ,"MV_PAR10","Analítico"      ,""     ,""     ,""   ,""        ,"Sintético"      ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"11","Objetivo              ?",""       ,""      ,"mv_chb","N" ,06     ,2      ,0     ,"C",""            ,"MV_PAR11",""               ,""     ,""     ,""   ,""        ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"12","Grupo Produto De      ?",""       ,""      ,"mv_chc","C" ,04     ,2      ,0     ,"G",""            ,"MV_PAR12",""               ,""     ,""     ,""   ,""        ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SBM")
	U_CRIASX1(_cPerg,"13","Grupo Produto Ate     ?",""       ,""      ,"mv_chd","C" ,04     ,2      ,0     ,"G",""            ,"MV_PAR13",""               ,""     ,""     ,""   ,""        ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SBM")

Return
