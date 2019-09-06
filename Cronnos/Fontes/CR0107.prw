#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"


/*/{Protheus.doc} CR0107
//Relatório de Acuracidade de Estoque
@author Fabiano
@since 18/06/2018
/*/
User Function CR0107()

	Local _oDlg			:= NIL
	Local _nOpt			:= 0

	Private _dDtCorte		:= cTod('30/06/2018')

	Private _cTitulo	:= 'Processando'
	Private _cMsgTit	:= 'Aguarde, analisando Dados...'

	Private _lExcel		:= .F.
	Private _nRadio		:= 1

	Private _oMes
	Private _aMes		:= {'Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'}
	Private _cMes		:= Left(Mesextenso(Month(dDatabase)),3)
	Private _cAno		:= Strzero(Year(dDatabase),4)
	private _aDtFech	:= {}
	Private _cLocal		:= "01"
	Private _nIndice	:= 90

	DEFINE MSDIALOG _oDlg FROM 0,0 TO 275,315 TITLE "Acuracidade de Estoque" OF _oDlg PIXEL

	_oGrup1	:= TGroup():New( 005,005,020,155,"",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 009,010 SAY "Esta rotina gera o relatório de acuracidade de estoque." OF _oGrup1 PIXEL Size 150,010


	_oGrup2 := TGroup():New( 021,005,055,155,"Selecione abaixo o Mês e o Ano de Referência",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 30,010 SAY "Mês: " 	Size 50,010 OF _oGrup2 PIXEL
	@ 30,060 MsCOMBOBOX _oMes 	VAR _cMes ITEMS _aMes Size 30,04  PIXEL OF _oGrup2

	@ 42,010 SAY "Ano: " 	Size 50,010 OF _oGrup2 PIXEL
	@ 42,060 MsGet _cAno   	Size 30,04  PIXEL OF _oGrup2


	_oGrup5 := TGroup():New( 056,005,090,155,"Preencha abaixo os dados complementares",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 65,010 SAY "Armazém: " 	Size 50,010 OF _oGrup5 PIXEL
	@ 65,060 MsGet _cLocal		Size 30,004  F3 "NNR" Valid(ExistCpo("NNR",_cLocal)) PIXEL OF _oGrup5

	@ 77,010 SAY "Índice: " 	Size 50,010 OF _oGrup5 PIXEL
	@ 77,060 MsGet _nIndice		Picture "@e 999.99" Size 30,004  PIXEL OF _oGrup5

	_oGrup3 := TGroup():New( 091,005,115,155,"Escolha abaixo o tipo de relatório",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 097,060 RADIO _oRadio VAR _nRadio ITEMS "Gráfico","Excel" SIZE 33,10 PIXEL OF _oGrup3


	_oGrup4:= TGroup():New( 0116,005,135,155,"",_oDlg,CLR_HBLUE,CLR_HGREEN,.T.,.F. )

	@ 120,015 BUTTON "OK" 			SIZE 036,012 ACTION {||_nOpt := 1,_oDlg:END()} OF _oGrup4 PIXEL
	@ 120,109 BUTTON "Sair"			SIZE 036,012 ACTION {||_nOpt := 2,_oDlg:End()} 	OF _oGrup4 PIXEL

	ACTIVATE MSDIALOG _oDlg CENTERED

	If _nOpt = 1
		FWMsgRun(, {|_oMsg| CR107A(_oMsg) }, _cTitulo, _cMsgTit )
	Endif

Return



Static Function CR107A(_oMsg)

	Local _aStru := {}

	_lExcel := If(_nRadio = 1,.F.,.T.)


	If !_lExcel

		AADD(_aStru,{"DTFECH"		, "D" , 08, 0 })    // Data Fechamento
		AADD(_aStru,{"REFERE"		, "C" , 06, 0 })    // Referencia
		AADD(_aStru,{"TPRDFE"		, "N" , 12, 0 })    // Total Produtos Fechamento com Saldo maior que zero
		AADD(_aStru,{"TPRDAJ"		, "N" , 12, 0 })    // Total Produtos Ajustados com Inventário
		AADD(_aStru,{"PERCAC"		, "N" , 12, 0 })    // Percentual Acuracidade
		AADD(_aStru,{"INDICE"		, "N" , 05, 2 })    // Indice
		AADD(_aStru,{"LOCALI"		, "C" , 20, 0 })    // Indice

		_cArqLOG := CriaTrab(_aStru,.T.)
		_cIndLOG := "DTOS(DTFECH)"

	Else

		AADD(_aStru,{"DTFECH"		, "D" , 08, 0 })    // Data Fechamento
		AADD(_aStru,{"REFERE"		, "C" , 06, 0 })    // Referencia
		AADD(_aStru,{"PRODUTO"		, "C" , 15, 0 })    // Produto
		AADD(_aStru,{"ARMAZEM"		, "C" , 02, 0 })    // Armazem
		AADD(_aStru,{"ESTOQUE"		, "N" , 12, 2 })    // Estoque Final
		AADD(_aStru,{"AJUSTAD"		, "C" , 01, 0 })    // Percentual Acuracidade

		_cArqLOG := CriaTrab(_aStru,.T.)
		_cIndLOG := "DTOS(DTFECH)+PRODUTO"
	Endif

	dbUseArea(.T.,,_cArqLOG,"TRB",.F.,.F.)

	dbSelectArea("TRB")
	IndRegua("TRB",_cArqLOG,_cIndLOG,,,"Criando Trabalho...")


	_nMes := aScan(_aMes,{|x| x == _cMes})
	_nAno := Val(_cAno)

	If _nMes = 12
		_nMesIni := 1
		_nAnoIni := _nAno
	Else
		_nMesIni := _nMes + 1
		_nAnoIni := _nAno - 1
	Endif

	_dDtMes := LastDay(cTod('01/'+StrZero(_nMesIni,2)+'/'+StrZero(_nAnoIni,4)))
	If _dDtMes > _dDtCorte
		AAdd(_aDtFech,_dDtMes)
	Endif

	For _n := 1 to 11
		_nMesIni ++
		If _nMesIni = 13
			_nMesIni := 1
			_nAnoIni ++
		Endif
		_dDtMes := LastDay(cTod('01/'+StrZero(_nMesIni,2)+'/'+StrZero(_nAnoIni,4)))
		If _dDtMes > _dDtCorte
			AAdd(_aDtFech,_dDtMes)
		Endif
	Next _n

	For _nRef := 1 To Len(_aDtFech)

		_oMsg:cCaption := ('Processando Registros de '+MesExtenso(_aDtFech[_nRef]) + '/' + Strzero(Year(_aDtFech[_nRef]),4))
		ProcessMessages()

		If Select("TSB9") > 0
			TSB9->(dbCloseArea())
		Endif

		If !_lExcel
			_cQry1 := " SELECT Count(B9_COD) as Total FROM "+RetSqlName("SB9")+" B9 " +CRLF
		Else
			_cQry1 := " SELECT B9_COD,B9_LOCAL,B9_QINI FROM "+RetSqlName("SB9")+" B9 " +CRLF
		Endif
		_cQry1 += " WHERE B9.D_E_L_E_T_ = '' AND B9_FILIAL = '"+xFilial("SB9")+"' " +CRLF
		_cQry1 += " AND B9_DATA = '"+dTos(_aDtFech[_nRef])+"' " +CRLF
		_cQry1 += " AND B9_QINI > 0 " +CRLF
		_cQry1 += " AND B9_LOCAL = '"+_cLocal+"' " +CRLF
		If _lExcel
			_cQry1 += " ORDER BY B9_COD " +CRLF
		Endif

		TcQuery _cQry1 New Alias "TSB9"

		TSB9->(dbGoTop())

		If _lExcel

			While !TSB9->(EOF())

				TRB->(RecLock("TRB",.T.))
				TRB->DTFECH	:= _aDtFech[_nRef]
				//			TRB->REFERE	:= StrZero(Month(_aDtFech[_nRef]),2)+'_'+StrZero(Year(TRB->DTFECH),2)
				TRB->REFERE	:= Left(Capital(MesExtenso(_aDtFech[_nRef])),3)+'/'+Right(StrZero(Year(_aDtFech[_nRef]),4),2)
				TRB->PRODUTO:= TSB9->B9_COD
				TRB->ARMAZEM:= TSB9->B9_LOCAL
				TRB->ESTOQUE:= TSB9->B9_QINI
				TRB->(msUnLock())

				TSB9->(dbSkip())
			EndDo
		Endif





		If Select("TSD3") > 0
			TSD3->(dbCloseArea())
		Endif

		_cQry2 := " SELECT D3_COD,COUNT(D3_COD) AS TOT FROM "+RetSqlName("SD3")+" D3 " +CRLF
		_cQry2 += " WHERE D3.D_E_L_E_T_ = '' AND D3_FILIAL = '"+xFilial("SD3")+"' " +CRLF
		_cQry2 += " AND D3_DOC = 'INVENT' " +CRLF
//		_cQry2 += " AND D3_EMISSAO = '"+dTos(_aDtFech[_nRef])+"' " +CRLF
		_cQry2 += " AND D3_EMISSAO BETWEEN '"+dTos(FirstDay(_aDtFech[_nRef]))+"' AND '"+dTos(Lastday(_aDtFech[_nRef]))+"'" +CRLF
		_cQry2 += " AND D3_LOCAL = '"+_cLocal+"' " +CRLF
		_cQry2 += " AND D3_ESTORNO <> 'S' " +CRLF
		_cQry2 += " GROUP BY D3_COD " +CRLF

		TcQuery _cQry2 New Alias "TSD3"

		Count TO _nTSD3

		TSD3->(dbGotop())

		If !_lExcel
			TRB->(RecLock("TRB",.T.))
			TRB->DTFECH	:= _aDtFech[_nRef]
			TRB->REFERE	:= Left(Capital(MesExtenso(_aDtFech[_nRef])),3)+'/'+Right(StrZero(Year(_aDtFech[_nRef]),4),2)
			TRB->TPRDFE	:= TSB9->TOTAL
			TRB->TPRDAJ	:= _nTSD3
			If TSB9->TOTAL > 0
				TRB->PERCAC := 100 - (_nTSD3*100/TSB9->TOTAL)
			Endif
			TRB->INDICE	:= _nIndice
			TRB->LOCALI	:= Posicione("NNR",1,xFilial("NNR")+_cLocal,"NNR_DESCRI")
			TRB->(msUnLock())
		Else

			While !TSD3->(EOF())
				If TRB->(msSeek(dTos(_aDtFech[_nRef])+TSD3->D3_COD))
					TRB->(RecLock("TRB",.F.))
					TRB->AJUSTAD := "S"
					TRB->(msUnLock())
				Endif
				TSB9->(dbSkip())
			EndDo
		Endif

		TSB9->(dbCloseArea())
		TSD3->(dbCloseArea())

	Next _nRef

	If _lExcel
		GeraExcel(_oMsg)
	Else
		_cArqDBF	:= "CR0107.dbf"
		_cRelRpt	:= "CR0107"

		GeraGrafico(_oMsg,_cArqDBF,_cRelRpt)
	Endif

Return (NIL)




Static Function GeraGrafico(_oMsg,_cArq,_cRel)

	Local _cDirRede		:= "\CRYSTAL\"
	Local _cDir			:= 'C:\TOTVS\CRONNOS\CRYSTAL\'	// Diretório onde estão os arquivos RPT
	Local _cArqDBF		:= _cArq
	Local _cRelRpt		:= _cRel

	_oMsg:cCaption := ('Gerando Gráfico...')
	ProcessMessages()

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


	CpyS2T(_cDirRede+_cRel+'.RPT',_cDir,.T.)


	dbSelectArea("TRB")

	Set Filter To

	COPY to &_cArqDBF VIA "DBFCDXADS"

	_CopyFile( _cArqDBF, _cDir + _cArqDBF)

	FErase(_cArqDBF)

	_cOptions := "1;0;1;Acuracidade estoque"

	Callcrys(_cRelRpt, ,_cOptions)

	TRB->(dbCloseArea())

Return(Nil)




Static Function GeraExcel(_oMsg)

	Local _cPlan	:= ""
	Local _cTable	:= ""
	Local _cDir		:= GetTempPath()

	_oExcel	:= FWMsExcel():New()

	_oMsg:cCaption := ('Gerando Relatório em Excel...')
	ProcessMessages()

	TRB->(dbGoTop())

	While !TRB->(EOF())

		_cPlan	:= TRB->REFERE
		_cTable	:= Left(Capital(MesExtenso(TRB->DTFECH)),3)+'/'+Right(StrZero(Year(TRB->DTFECH),4),2)

		_oExcel:AddworkSheet(_cPlan)

		_oExcel:AddTable (_cPlan,_cTable)

		_oExcel:AddColumn(_cPlan,_cTable,"Produto"		,1,1,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Armazém"		,1,1,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Estoque"		,3,2,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Ajustado"		,1,1,.F.)


		While !TRB->(EOF()) .And. _cPlan == TRB->REFERE

			_aCel := {		;
			TRB->PRODUTO	,;
			TRB->ARMAZEM	,;
			TRB->ESTOQUE	,;
			If(!Empty(TRB->AJUSTAD),"Sim","")	}

			_oExcel:AddRow(_cPlan,_cTable,_aCel) //Insere uma linha na Tabela

			TRB->(dbSkip())
		EndDo
	EndDo

	TRB->(dbCloseArea())

	_oExcel:Activate()

	_cArq2 := CriaTrab( NIL, .F. ) + ".xls"

	_oExcel:GetXMLFile( _cArq2 )

	_cDat1    := GravaData(dDataBase,.f.,8)
	_cHor1    := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

	_cArq := 'Acuracidade_'+_cDat1+'_'+_cHor1 + ".xls"

	If __CopyFile( _cArq2, _cDir + _cArq )
		_oExcelApp := MsExcel():New()
		_oExcelApp:WorkBooks:Open( _cDir + _cArq )
		_oExcelApp:SetVisible(.T.)
	Endif

Return(Nil)
