#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'TDSBIRT.CH'
#INCLUDE 'BIRTDATASET.CH'

/*/{Protheus.doc} CR0113
//Produtividade (MP)
@author Fabiano
@since 22/10/2018
/*/
User Function CR0113()

	Local _oDlg			:= NIL
	Local _nOpt			:= 0

	Private _dDtCorte		:= cTod('01/11/2018')

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

	DEFINE MSDIALOG _oDlg FROM 0,0 TO 240,315 TITLE "Produtividade (MP)" OF _oDlg PIXEL

	_oGrup1	:= TGroup():New( 005,005,020,155,"",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 009,010 SAY "Esta rotina gera o relatório de Produtividade (MP)." OF _oGrup1 PIXEL Size 150,010


	_oGrup2 := TGroup():New( 021,005,055,155,"Selecione abaixo o Mês e o Ano de Referência",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 30,010 SAY "Mês: " 	Size 50,010 OF _oGrup2 PIXEL
	@ 30,060 MsCOMBOBOX _oMes 	VAR _cMes ITEMS _aMes Size 30,04  PIXEL OF _oGrup2

	@ 42,010 SAY "Ano: " 	Size 50,010 OF _oGrup2 PIXEL
	@ 42,060 MsGet _cAno   	Size 30,04  PIXEL OF _oGrup2


	_oGrup5 := TGroup():New( 056,005,080,155,"Preencha abaixo os dados complementares",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 65,010 SAY "Índice: " 	Size 50,010 OF _oGrup5 PIXEL
	@ 65,060 MsGet _nIndice		Picture "@e 999.99" Size 30,010  PIXEL OF _oGrup5

	_oGrup4:= TGroup():New( 0081,005,100,155,"",_oDlg,CLR_HBLUE,CLR_HGREEN,.T.,.F. )

	@ 085,015 BUTTON "OK" 			SIZE 036,012 ACTION {||_nOpt := 1,_oDlg:END()} OF _oGrup4 PIXEL
	@ 085,109 BUTTON "Sair"			SIZE 036,012 ACTION {||_nOpt := 2,_oDlg:End()} 	OF _oGrup4 PIXEL

	ACTIVATE MSDIALOG _oDlg CENTERED

	If _nOpt = 1
		FWMsgRun(, {|_oMsg| CR113A(_oMsg) }, _cTitulo, _cMsgTit )
	Endif

Return



Static Function CR113A(_oMsg)

	Local _aStru := {}
	Local _cQry1 := ''

	Local _aFields := {}
	Local _aCampos := {}
	Local _oTempTable
	Local _oTmpTRB
	Local _cQuery

	//Criação do objeto
	_oTmpTRB := FWTemporaryTable():New( "CR0113" )

	//Monta os campos da tabela
	AADD(_aCampos,{"DTFECH"		, "D" , 08, 0 })    // Data Fechamento
	AADD(_aCampos,{"REFERE"		, "C" , 06, 0 })    // Referencia
	aadd(_aCampos,{"INDICE"		, "N"  ,06, 2})
	aadd(_aCampos,{"TIPO"		, "C"  ,01, 0})
	AADD(_aCampos,{"PRODUTO"	, "C" , 15, 0 })    // Produto
	AADD(_aCampos,{"PESO"		, "N" , 12, 4 })    // Produto
	AADD(_aCampos,{"ESTINI"		, "N" , 12, 2 })    // Estoque Final
	AADD(_aCampos,{"ESTFIN"		, "N" , 12, 2 })    // Estoque Final
	AADD(_aCampos,{"VARIAC"		, "N" , 12, 2 })    // Variação
	AADD(_aCampos,{"SAIENT"		, "N" , 12, 2 })    // Saida - Entrada
	AADD(_aCampos,{"PESOMP"		, "N" , 12, 2 })    // PESO MP

	_oTmpTRB:SetFields( _aCampos )
	_oTmpTRB:AddIndex("INDICE1", {"DTFECH","TIPO","PRODUTO"} )

	//Criação da tabela
	_oTmpTRB:Create()




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

		_oMsg:cCaption := ('Processando dados de '+MesExtenso(_aDtFech[_nRef]) + '/' + Strzero(Year(_aDtFech[_nRef]),4))
		ProcessMessages()

		If Select("TSB9") > 0
			TSB9->(dbCloseArea())
		Endif

		_cQry1 := " SELECT B9_COD,B9_LOCAL,B9_QINI,B1_PESO FROM "+RetSqlName("SB9")+" B9 " +CRLF
		_cQry1 += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B9_COD = B1_COD " +CRLF
		_cQry1 += " WHERE B9.D_E_L_E_T_ = '' AND B9_FILIAL = '"+xFilial("SB9")+"' " +CRLF
		_cQry1 += " AND B1.D_E_L_E_T_ = '' AND B1_FILIAL = '"+xFilial("SB1")+"' " +CRLF
		_cQry1 += " AND B9_DATA = '"+dTos(_aDtFech[_nRef])+"' " +CRLF
		_cQry1 += " AND B9_LOCAL = B1_LOCPAD " +CRLF
		_cQry1 += " AND B1_GRUPO = 'PAMD' " +CRLF
		_cQry1 += " ORDER BY B9_COD " +CRLF

		TcQuery _cQry1 New Alias "TSB9"

		TSB9->(dbGoTop())

		While !TSB9->(EOF())

			_nMes := Month(_aDtFech[_nRef])
			_nAno := Year(_aDtFech[_nRef])
			_cMP  := Space(TamSX3('B1_COD')[1])

			If _nMes = 1
				_nMesAnt := 12
				_nAnoAnt := _nAno - 1
			Else
				_nMesAnt := _nMes -1
				_nAnoAnt := _nAno
			Endif

			_dDtMesAnt	:= LastDay(cTod('01/'+StrZero(_nMesAnt,2)+'/'+StrZero(_nAnoAnt,4)))
			_nSldAnt	:= 0
			SB9->(dbsetOrder(1))
			If SB9->(msSeek(xFilial("SB9")+TSB9->B9_COD+TSB9->B9_LOCAL+Dtos(Lastday(_dDtMesAnt))))
				_nSldAnt := SB9->B9_QINI
			Endif

			If Select("TSD2") > 0
				TSD2->(dbCloseArea())
			Endif

			_cQry := " SELECT SUM(D2_QUANT) AS QTDE FROM "+RetSQLName("SD2")+" D2 " +CRLF
			_cQry += " INNER JOIN "+RetSQLName("SF4")+" F4 ON D2_TES = F4_CODIGO " +CRLF
			_cQry += " WHERE D2.D_E_L_E_T_ = '' AND D2_FILIAL = '"+xFilial("SD2")+"' " +CRLF
			_cQry += " AND F4.D_E_L_E_T_ = '' AND F4_FILIAL = '"+xFilial("SF4")+"' " +CRLF
			_cQRY += " AND D2_COD = '"+TSB9->B9_COD+"' " +CRLF
			_cQRY += " AND D2_EMISSAO BETWEEN '"+dTos(FirstDay(_aDtFech[_nRef]))+"' AND '"+dTos(_aDtFech[_nRef])+"' " +CRLF
			_cQRY += " AND F4_DUPLIC = 'S' " +CRLF

			TcQuery _cQRY New Alias "TSD2"

			Count to _nTSD2

			If _nTSD2 > 0
				TSD2->(dbGoTop())

				_nQSD2 := TSD2->QTDE
			Else
				nQSD2 := 0
			Endif

			TSD2->(dbCloseArea())

			_nVar := _nQSD2 + ( TSB9->B9_QINI -_nSldAnt)

			CR0113->(RecLock("CR0113",.T.))
			CR0113->DTFECH	:= _aDtFech[_nRef]
			CR0113->REFERE	:= Left(Capital(MesExtenso(_aDtFech[_nRef])),3)+'/'+Right(StrZero(Year(_aDtFech[_nRef]),4),2)
			CR0113->TIPO	:= 'S'
			CR0113->INDICE	:= _nIndice
			CR0113->PRODUTO	:= TSB9->B9_COD
			CR0113->ESTINI	:= _nSldAnt
			CR0113->ESTFIN	:= TSB9->B9_QINI
			CR0113->SAIENT	:= _nQSD2
			CR0113->VARIAC	:= _nVar
			CR0113->PESO	:= TSB9->B1_PESO
			CR0113->PESOMP	:= _nVar * TSB9->B1_PESO
			CR0113->(msUnLock())

			TSB9->(dbSkip())
		EndDo

		TSB9->(dbCloseArea())


//		_oMsg:cCaption := ('Processando Entradas de '+MesExtenso(_aDtFech[_nRef]) + '/' + Strzero(Year(_aDtFech[_nRef]),4))
//		ProcessMessages()

		If Select("TSB9") > 0
			TSB9->(dbCloseArea())
		Endif

		_cQry1 := " SELECT B9_COD,B9_LOCAL,B9_QINI FROM "+RetSqlName("SB9")+" B9 " +CRLF
		_cQry1 += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B9_COD = B1_COD " +CRLF
		_cQry1 += " WHERE B9.D_E_L_E_T_ = '' AND B9_FILIAL = '"+xFilial("SB9")+"' " +CRLF
		_cQry1 += " AND B1.D_E_L_E_T_ = '' AND B1_FILIAL = '"+xFilial("SB1")+"' " +CRLF
		_cQry1 += " AND B9_DATA = '"+dTos(_aDtFech[_nRef])+"' " +CRLF
		_cQry1 += " AND B9_LOCAL = B1_LOCPAD " +CRLF
		_cQry1 += " AND B1_GRUPO = 'PPCO' " +CRLF
		//_cQry1 += " AND B1_GRUPO = 'MPVC' " +CRLF
		_cQry1 += " ORDER BY B9_COD " +CRLF

		TcQuery _cQry1 New Alias "TSB9"

		TSB9->(dbGoTop())

		While !TSB9->(EOF())

			_nMes := Month(_aDtFech[_nRef])
			_nAno := Year(_aDtFech[_nRef])
			_cMP  := Space(TamSX3('B1_COD')[1])

			If _nMes = 1
				_nMesAnt := 12
				_nAnoAnt := _nAno - 1
			Else
				_nMesAnt := _nMes -1
				_nAnoAnt := _nAno
			Endif

			_dDtMesAnt	:= LastDay(cTod('01/'+StrZero(_nMesAnt,2)+'/'+StrZero(_nAnoAnt,4)))
			_nSldAnt	:= 0
			SB9->(dbsetOrder(1))
			If SB9->(msSeek(xFilial("SB9")+TSB9->B9_COD+TSB9->B9_LOCAL+Dtos(Lastday(_dDtMesAnt))))
				_nSldAnt := SB9->B9_QINI
			Endif

			If Select("TSD1") > 0
				TSD1->(dbCloseArea())
			Endif

			_cQry := " SELECT SUM(D1_QUANT) AS QTDE FROM "+RetSQLName("SD1")+" D1 " +CRLF
			_cQry += " INNER JOIN "+RetSQLName("SF4")+" F4 ON D1_TES = F4_CODIGO " +CRLF
			_cQry += " WHERE D1.D_E_L_E_T_ = '' AND D1_FILIAL = '"+xFilial("SD1")+"' " +CRLF
			_cQry += " AND F4.D_E_L_E_T_ = '' AND F4_FILIAL = '"+xFilial("SF4")+"' " +CRLF
			_cQRY += " AND D1_COD = '"+TSB9->B9_COD+"' " +CRLF
			_cQRY += " AND D1_DTDIGIT BETWEEN '"+dTos(FirstDay(_aDtFech[_nRef]))+"' AND '"+dTos(_aDtFech[_nRef])+"' " +CRLF
			_cQRY += " AND F4_DUPLIC = 'S' " +CRLF

			TcQuery _cQRY New Alias "TSD1"

			TSD1->(dbGoTop())

			_nQSD1 := TSD1->QTDE

			TSD1->(dbCloseArea())

			_nVar := _nQSD1 //+ (TSB9->B9_QINI - _nSldAnt)
			CR0113->(RecLock("CR0113",.T.))
			CR0113->DTFECH	:= _aDtFech[_nRef]
			CR0113->TIPO	:= 'E'
			CR0113->REFERE	:= Left(Capital(MesExtenso(_aDtFech[_nRef])),3)+'/'+Right(StrZero(Year(_aDtFech[_nRef]),4),2)
			CR0113->PRODUTO	:= TSB9->B9_COD
			CR0113->INDICE	:= _nIndice
			CR0113->ESTINI	:= _nSldAnt
			CR0113->ESTFIN	:= TSB9->B9_QINI
			CR0113->SAIENT	:= _nQSD1
			CR0113->VARIAC	:= _nVar
			CR0113->PESOMP	:= _nVar
			CR0113->(MsUnLock())

			TSB9->(dbSkip())
		EndDo

		TSB9->(dbCloseArea())

	Next _nRef

	_cUpd := " DROP TABLE CR0113 "
	TCSQLEXEC(_cUpd)

	_cUpd := " SELECT * INTO CR0113 FROM "+ _oTmpTRB:GetRealName()
	TCSQLEXEC(_cUpd)

	//Exclui a tabela
	_oTmpTRB:Delete()

	GeraBirt()

Return (NIL)



Static Function GeraBirt()

	Local _oReport := Nil

	Define User_Report _oReport Name TESTE01 Title "Produtividade MP" //ASKPAR EXCLUSIVE

	Activate REPORT _oReport LAYOUT CR0113A Format HTML

Return(Nil)

