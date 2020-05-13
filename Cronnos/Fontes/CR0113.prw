#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPRINTSETUP.CH"
#include "msgraphi.ch"

#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2

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

	Private _oExcel
	Private _aExcel		:= {'Sim','Não'}
	Private _cExcel		:= 'Não'

	Private _oMes
	Private _aMes		:= {'Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'}
	Private _cMes		:= Left(Mesextenso(Month(dDatabase)),3)

	Private _cAno		:= Strzero(Year(dDatabase),4)
	private _aDtFech	:= {}
	Private _cLocal		:= "01"
	Private _nIndice	:= 90

	Private _aCabec 	:= {;
		{'Mês'				,11		,0,'MES'		,'C',Nil					},;
		{'Índice'			,09		,2,'INDICE'		,'N','@e 999,999.99'		},;
		{'Tipo'				,09		,2,'TIPO'		,'C',Nil					},;
		{'Produto'			,09		,2,'PRODUTO'	,'C',Nil					},;
		{'Peso'				,10		,2,'PESO'		,'N','@e 9,999,999.9999'	},;
		{'Est.Inicial'		,08		,1,'ESTIN'		,'N','@e 9,999,999,999.99'	},;
		{'Est.Final'		,09		,2,'ESTFIN'		,'D','@e 9,999,999,999.99'	},;
		{'Variação'			,09		,1,'VARIAC'		,'N','@e 9,999,999,999.99'	},;
		{'Saida/Entrada'	,08		,2,'SAIENT'		,'N','@e 999.9,999,999.99'	},;
		{'Peso MP'			,10		,2,'PESOMP'		,'C','@e 999.9,999,999.99'	}}

	Private _aMargRel	:= {10,10,10,50}
	Private _oFwMsEx	:= Nil

	Private _oFont8		:= TFont():New('Arial'	,,-08,,.F.,,,,,.F.,.F.)
	Private _oFont9		:= TFont():New('Arial'	,,-09,,.F.,,,,,.F.,.F.)
	Private _oFont9N	:= TFont():New('Arial'	,,-09,,.T.,,,,,.F.,.F.)
	Private _oFont11N	:= TFont():New('Arial'	,,-11,,.T.,,,,,.F.,.F.)
	Private _oFont18N	:= TFont():New('Arial'	,,-18,,.T.,,,,,.F.,.F.)

	Private _nPag		:= 0
	Private _nTamRod	:= 22


	DEFINE MSDIALOG _oDlg FROM 0,0 TO 240,315 TITLE "Produtividade (MP)" OF _oDlg PIXEL

	_oGrup1	:= TGroup():New( 005,005,020,155,"",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 009,010 SAY "Esta rotina gera o relatório de Produtividade (MP)." OF _oGrup1 PIXEL Size 150,010


	_oGrup2 := TGroup():New( 021,005,055,155,"Selecione abaixo o Mês e o Ano de Referência",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 30,010 SAY "Mês: " 	Size 50,010 OF _oGrup2 PIXEL
	@ 30,085 MsCOMBOBOX _oMes 	VAR _cMes ITEMS _aMes Size 30,04  PIXEL OF _oGrup2

	@ 42,010 SAY "Ano: " 	Size 50,010 OF _oGrup2 PIXEL
	@ 42,085 MsGet _cAno   	Size 30,04  PIXEL OF _oGrup2


	_oGrup5 := TGroup():New( 056,005,080,155,"Preencha abaixo os dados complementares",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 65,010 SAY "Índice: " 	Size 50,010 OF _oGrup5 PIXEL
	@ 65,085 MsGet _nIndice		Picture "@e 999.99" Size 30,010  PIXEL OF _oGrup5

	_oGrup4:= TGroup():New( 0081,005,100,155,"",_oDlg,CLR_HBLUE,CLR_HGREEN,.T.,.F. )

	@ 85,010 SAY "Dados Analíticos em Excel? " 	Size 70,010 OF _oGrup4 PIXEL
	@ 85,085 MsCOMBOBOX _oExcel 	VAR _cExcel ITEMS _aExcel Size 30,04  PIXEL OF _oGrup4

	_oGrup6:= TGroup():New( 0101,005,120,155,"",_oDlg,CLR_HBLUE,CLR_HGREEN,.T.,.F. )

	@ 105,015 BUTTON "OK" 			SIZE 036,012 ACTION {||_nOpt := 1,_oDlg:END()} OF _oGrup6 PIXEL
	@ 105,109 BUTTON "Sair"			SIZE 036,012 ACTION {||_nOpt := 2,_oDlg:End()} 	OF _oGrup6 PIXEL

	ACTIVATE MSDIALOG _oDlg CENTERED

	If _nOpt = 1
		FWMsgRun(, {|_oMsg| CR113A(_oMsg) }, _cTitulo, _cMsgTit )
	Endif

Return



Static Function CR113A(_oMsg)

	// Local _aStru := {}
	Local _cQry1 := ''

	// Local _aFields := {}
	Local _aCampos := {}
	// Local _oTempTable
	Local _oTmpTRB
	Local _cQuery
	Local _n
	Local _nRef

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

	// For _n := 1 to 2
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

	GeraGrafico()

Return (NIL)



Static Function GeraGrafico()

	Local _aArea       := GetArea()
	Local _cNomeRel    := "produtividade_mp__"+dToS(Date())+StrTran(Time(), ':', '-')
	Local _cDiretorio  := GetTempPath()
	Local _nLinCab     := 025
	Local _nAltur      := 250
	Local _nLargur     := 1050
	Local _aRand       := {}
	Local _cQry        := ''

	Private _cHoraEx   := Time()
	Private _nPagAtu   := 1
	Private _oPrinter


	//Fontes
	Private _cNomeFont := "Arial"
	Private _oFontRod  := TFont():New(_cNomeFont, , -06, , .F.)
	Private _oFontTit  := TFont():New(_cNomeFont, , -20, , .T.)
	Private _oFontSubN := TFont():New(_cNomeFont, , -17, , .T.)

	//Linhas e colunas
	Private _nLinAtu   := 0
	Private _nLinFin   := 820
	Private _nColIni   := 010
	Private _nColFin   := 550
	Private _nColMeio  := (_nColFin-_nColIni)/2
	Private _nLin      := 3000
	Private _nCol	   := 0

	//Criando o objeto de impressão
	_oPrinter := FWMSPrinter():New(_cNomeRel, IMP_PDF, .F.             , /*cStartPath*/, .T.,          , @_oPrinter, , , , , .T.)
	_oPrinter:cPathPDF := GetTempPath()
	_oPrinter:SetPortrait()


	//Se o arquivo existir, exclui ele
	If File(_cDiretorio+"_grafico.png")
		FErase(_cDiretorio+"_grafico.png")
	EndIf

	If Select("TCR13") > 0
		TCR13->(dbCloseArea())
	Endif


	_cQry := " SELECT DISTINCT DTFECH, Right(A.DTFECH,2)+'/'+SUBSTRING(A.DTFECH,5,2)+'/'+LEFT(A.DTFECH,4) AS MES, " + CRLF
	_cQry += " A.INDICE AS INDICE, " + CRLF
	_cQry += " TOTAL = (	((SELECT SUM(B.PESOMP) FROM CR0113 B WHERE B.DTFECH = A.DTFECH AND B.TIPO = 'S') " + CRLF
	_cQry += " 				+ " + CRLF
	_cQry += " 			(SELECT ISNULL(SUM(I1.ZI_QTPROC),0) FROM SZI010 I1 " + CRLF
	_cQry += " 				WHERE I1.D_E_L_E_T_ = '' AND I1.ZI_DTREF = A.DTFECH AND I1.ZI_TIPO = 'S')) " + CRLF
	_cQry += " 			/  " + CRLF
	_cQry += " 			CASE WHEN 	((SELECT SUM(C.PESOMP) FROM CR0113 C WHERE C.DTFECH = A.DTFECH AND C.TIPO = 'E') " + CRLF
	_cQry += " 						+ " + CRLF
	_cQry += " 						(SELECT ISNULL(SUM(I2.ZI_QTPROC),0) FROM SZI010 I2 	WHERE I2.D_E_L_E_T_ = '' AND  I2.ZI_DTREF = A.DTFECH AND I2.ZI_TIPO = 'E')) = 0 THEN 1  " + CRLF
	_cQry += " 				ELSE " + CRLF
	_cQry += " 						((SELECT SUM(C.PESOMP) FROM CR0113 C WHERE C.DTFECH = A.DTFECH AND C.TIPO = 'E') " + CRLF
	_cQry += " 						+ " + CRLF
	_cQry += " 						(SELECT ISNULL(SUM(I2.ZI_QTPROC),0) FROM SZI010 I2 WHERE I2.D_E_L_E_T_ = '' AND  I2.ZI_DTREF = A.DTFECH AND I2.ZI_TIPO = 'E')) END " + CRLF
	_cQry += " 		* 100 ) " + CRLF
	_cQry += " FROM CR0113 A " + CRLF
	_cQry += " ORDER BY A.DTFECH " + CRLF

	TcQuery _cQry New Alias "TCR13"

	If Contar("TCR13","!EOF()") > 0

		//Cria a Janela
		DEFINE MSDIALOG _oDlgChar PIXEL FROM 0,0 TO _nAltur,_nLargur

		//Instância a classe
		_oChart := FWChartBar():New()

		// _oChart:SetLegend( GRP_SCRBOTTOM, CLR_WHITE, GRP_SERIES, .T. )

		//Inicializa pertencendo a janela
		_oChart:Init(_oDlgChar, .T., .T. )


		TCR13->(dbGoTop())

		While TCR13->(!EOF())

			_oChart:addSerie(TCR13->MES, TCR13->TOTAL)

			TCR13->(dbSkip())
		EndDo

		//Seta a máscara mostrada na régua
		_oChart:cPicture := "@E 999,999,999,999,999.99"

		//Constrói o gráfico
		_oChart:Build()

		ACTIVATE MSDIALOG _oDlgChar CENTERED ON INIT (_oChart:SaveToPng(0, 0, _nLargur, _nAltur, _cDiretorio+"_grafico.png"), _oDlgChar:End())

		Cabec()
		
		_nAlt := _nAltur/1.6

		_oPrinter:SayBitmap(_nLin+20, _nCol+10, _cDiretorio+"_grafico.png", _nLargur/2,_nAlt )

		_nLin += (_nAlt + 40)

		_oPrinter:SayAlign(_nLin,_nCol+10,"Dados do Gráfico",_oFont9N,300,10,CLR_BLACK, 0 , 1 )

		_nLin += 15

		_oPrinter:SayAlign(_nLin,_nCol+10,"Meta (%): "+Alltrim(Transform(_nIndice, "@e 9,999,999.99")),_oFont9N,300,10,CLR_BLUE, 0 , 1 )

		_nLin += 15

		_oPrinter:SayAlign(_nLin,_nCol+10,"Mês"  ,_oFont9N,100,10,CLR_BLACK, 0 , 1 )
		_oPrinter:SayAlign(_nLin,200     ,"%"    ,_oFont9N,100,10,CLR_BLACK, 1 , 1 )

		TCR13->(dbGoTop())

		While TCR13->(!EOF())

			_nLin += 15

			_oCor := CLR_BLACK

			If TCR13->TOTAL < _nIndice
				_oCor := CLR_RED
			Endif

			_oPrinter:SayAlign(_nLin,_nCol+10,TCR13->MES											,_oFont9,100,10,_oCor, 0 , 1 )
			_oPrinter:SayAlign(_nLin,200     ,Alltrim(Transform(TCR13->TOTAL, "@e 9,999,999.99"))	,_oFont9,100,10,_oCor, 1 , 1 )

			TCR13->(dbSkip())
		EndDo


		//Gera o pdf para visualização
		_oPrinter:Preview()

		RestArea(_aArea)
	ENDIF

	TCR13->(dbCloseArea())


	If  _cExcel = 'Sim'

		If Select("TANA") > 0
			TANA->(dbCloseArea())
		Endif

		_cQry := " SELECT Right(A.DTFECH,2)+'/'+SUBSTRING(A.DTFECH,5,2)+'/'+LEFT(A.DTFECH,4) AS MES,INDICE,TIPO, PRODUTO,PESO,ESTINI,ESTFIN,VARIAC,SAIENT,PESOMP FROM CR0113 A "

		TcQuery _cQry New Alias "TANA"

		If Contar("TANA","!EOF()") > 0

			_oFwMsEx := FWMsExcel():New()

			_cWorkSheet	:= "Dados"
			_cTable		:= "Produtividade (MP) - Analítico"

			_oFwMsEx:AddWorkSheet( _cWorkSheet )
			_oFwMsEx:AddTable( _cWorkSheet, _cTable )

			_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Mês"			, 1,1,.F.)
			_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Indice"			, 1,1,.F.)
			_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Tipo"			, 1,1,.F.)
			_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Produto"		, 1,1,.F.)
			_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Peso"			, 3,2,.F.)
			_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Estoque Inicial", 3,2,.F.)
			_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Estoque Final"	, 3,2,.F.)
			_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Variação"		, 3,2,.F.)
			_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Saída/Entrada"	, 3,2,.F.)
			_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "Peso MP"		, 3,2,.F.)

			TANA->(dbGoTop())

			While TANA->(!EOF())

				_oFwMsEx:AddRow( _cWorkSheet, _cTable,{;
					TANA->MES		,;
					TANA->INDICE	,;
					TANA->TIPO		,;
					TANA->PRODUTO	,;
					TANA->PESO		,;
					TANA->ESTINI	,;
					TANA->ESTFIN	,;
					TANA->VARIAC	,;
					TANA->SAIENT	,;
					TANA->PESOMP	})

				TANA->(dbSkip())
			EndDo

			_oFwMsEx:Activate()


			_cArq := CriaTrab( NIL, .F. ) + ".xls"

			LjMsgRun( "Gerando o arquivo, aguarde...", "Produtividade MP", {|| _oFwMsEx:GetXMLFile( _cArq ) } )

			_cData   := DTOS(dDataBase)
			_cHora   := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

			_cNomArq := "Produtividade_MP_"+_cData+"_"+_cHora+".xls"

			_cDir 	:= GetTempPath()

			If __CopyFile(_cArq, _cDir + _cNomArq)

				If ! ApOleClient( 'MsExcel' )
					MsgStop('MsExcel nao instalado')
					Return
				EndIf

				_oExcelApp := MsExcel():New()
				_oExcelApp:WorkBooks:Open( _cDir + _cNomArq )
				_oExcelApp:SetVisible(.T.)

			Else
				MSGAlert("O arquivo não foi copiado!", "AQUIVO NÃO COPIADO!")
			Endif


		Endif

		TANA->(dbCloseArea())

	Endif

Return(Nil)




Static Function Cabec() //Cabeçalho

	Local _nCab

	_oPrinter:StartPage()

	_nSizePage	:= _oPrinter:nPageWidth / _oPrinter:nFactorHor
	_nLin		:= _aMargRel[2] + 10
	_nCol		:= _aMargRel[1] + 10
	_nColTot	:= _nSizePage-(_aMargRel[1]+_aMargRel[3])
	_nLinTot	:= ((_oPrinter:nPageHeight / _oPrinter:nFactorVert) - (_aMargRel[2]+_aMargRel[4])) - 6
	_nMaxLin	:= _nLinTot
	_nTBoxPag	:= 80
	_nLinIni	:= _nLin
	_nCIni		:= _nCol  + 15
	_nCFim		:= _nColTot - 150
	_nTLin		:= 12
	_nDist		:= 60
	_nTmBox		:= _nColTot - _nCol

	_nPag ++

	_oPrinter:Box(_nLin,_nCol, _nLinTot,_nColTot)

	_nLin += 8

	_oPrinter:SayBitmap(_nLin+1,_nCol+5,"lgrl"+cEmpAnt+".bmp",080,040)

	_oPrinter:SayAlign(_nLin,_nColTot-_nTBoxPag,"Página: " + cValToChar(_nPag)	,_oFont9N,_nTBoxPag,7,, 2, 1 )

	_nLin += 15

	_oPrinter:SayAlign(_nLin-5,_nColTot-_nTBoxPag,"Data: " + dToc(dDataBase),_oFont9N,_nTBoxPag,7,, 2, 1 )

	_oPrinter:SayAlign(_nLin-10,_nCol,'Gráfico de Produtividade MP',_oFont18N,_nColTot - _nTBoxPag,7,, 2, 1 )

	_oPrinter:SayAlign(_nLin+5,_nColTot-_nTBoxPag,"Hora: " + Left(Time(),5),_oFont9N,_nTBoxPag,7,, 2, 1 )

	_nLin += 27
	_oPrinter:Line(_nLin,_nCol,_nLin,_nColTot)

	_oPrinter:Line(_nLinIni,_nColTot-_nTBoxPag,_nLin,_nColTot-_nTBoxPag)

	_nLin += 2

	_oPrinter:Line(_nLin,_nCol,_nLin,_nColTot)

	_nLin += 2

	//Rodapé
	_nLinRod := _nLinTot - _nTamRod + 2
	_oPrinter:Line(_nLinRod,_nCol,_nLinRod,_nColTot, RGB(200, 200, 200))
	_nLinRod += 07

	_oPrinter:SayAlign(_nLinRod,_nCol+10,"TOCOM001.PRW",_oFont9N,200,10,, 0, 1 )
	_oPrinter:SayAlign(_nLinRod,_nColTot-80,"Página "+STRZERO(_nPag,3),_oFont9N,70,10,, 1, 1)

Return()