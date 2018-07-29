#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Autor 		: Fabiano da Silva
Data 		: 23/05/18
Programa  	: FINR06
Descrição 	: Relatório de Comissão - Contas a Pagar
*/

User Function FINR06()

	Local _oDlg			:= NIL
	Local _nOpt			:= 0

	Private _oPrinter	:= NIL
	Private _oFont1, _oFont2, _oFont2N
	Private _nPag 		:= _nTPageF := _nTPageA := _nTPageT := 0
	Private _lEnt		:= .F.
	Private _cDir 		:= Space(100)
	Private _lExcel		:= .F.
	Private _nRadio		:= 1
	Private _nLin		:= 1000
	Private _nCol		:= 0
	Private _nColTot	:= 0
	Private _aMargRel	:= {10,10,10,50}
	Private _cTitulo	:= 'Processando'
	Private _cMsgTit	:= 'Aguarde, analisando Comissão...'
	Private _aCabec		:= {}
	Private _nTotlin 	:= 790

	AtuSX1()

	DEFINE MSDIALOG _oDlg FROM 0,0 TO 182,315 TITLE "Relatório de Comissão" OF _oDlg PIXEL

	_oGrupo	:= TGroup():New( 005,005,035,155,"",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 010,010 SAY "Esta rotina gera o relatório financeiro de Comissão" OF _oGrupo PIXEL Size 150,010
	@ 020,010 SAY "conforme os parâmetros informados pelo usuário." 		OF _oGrupo PIXEL Size 150,010

	_oGrupo1 := TGroup():New( 036,005,062,155,"Escolha abaixo o formato do relatório",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 042,065 RADIO _oRadio VAR _nRadio ITEMS "PDF","Excel" SIZE 33,10 PIXEL OF _oGrupo1

	_oGrupo2:= TGroup():New( 065,005,088,155,"",_oDlg,CLR_HBLUE,CLR_HGREEN,.T.,.F. )

	@ 70,010 BUTTON "Parâmetros"	SIZE 036,012 ACTION (Pergunte("FINR06",.t.))OF _oGrupo2 PIXEL
	@ 70,060 BUTTON "OK" 			SIZE 036,012 ACTION {||_nOpt := 1,_oDlg:END()} OF _oGrupo2 PIXEL
	@ 70,110 BUTTON "Sair"			SIZE 036,012 ACTION (_oDlg:End()) 	OF _oGrupo2 PIXEL

	ACTIVATE MSDIALOG _oDlg CENTERED

	Pergunte("FINR06",.F.)

	_lExcel := If(_nRadio = 1,.F.,.T.)

	If _nOpt = 1

		If MV_PAR12 = 2 .And. !_lExcel
			CheckDir()
		Else
			_cDir := GetTempPath()
		Endif

		If !Empty(_cDir)
			FWMsgRun(, {|_oMsg| FIN06A(_oMsg) }, _cTitulo, _cMsgTit )
		Endif
	Endif

Return(Nil)



Static Function CheckDir()

	Local _oODir := Nil
	Local _oGDir := Nil

	DEFINE MSDIALOG _oODir FROM 0,0 TO 130,370 TITLE "Comissão" OF _oODir PIXEL

	_oGDir	:= TGroup():New( 005,005,035,180,"Selecione abaixo o diretório onde serão gravados os arquivos PDF",_oODir,CLR_HRED,CLR_WHITE,.T.,.F. )

	_oSay	:= TSay():New( 020,010,{||"Local:"},_oGDir,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	_oGet	:= TGet():New( 020,055,{|u| If(PCount()>0,_cDir:=u,_cDir)},_oGDir,100,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cDir",,)
	_oGet:Disable()
	_oBtn	:= TBtnBmp2():New( 035,080,23,23,'PMSPESQ',,,, {||_cDir := cGetFile('Arquivo *|*.*','Selecione arquivo',0,'C:\',.T.,GETF_RETDIRECTORY +GETF_LOCALHARD,.F.)},_oGDir,'Local para gravação do PDF',,.F.,.F. )

	@ 45,070 BUTTON "OK" SIZE 036,012 ACTION {|| If(!Empty(_cDir),_oODir:END(),MsgAlert('Selecione o local para gravação do arquivo PDF.'))} OF _oGDir PIXEL

	ACTIVATE MSDIALOG _oODir CENTERED

Return(Nil)



Static Function FIN06A(_oMsg)

	Local _cQuery			:= ''
	Local _nTSE2			:= 0

	Private _aStru := {}

	AADD(_aStru,{"GERENTE"	, "C" , 06, 0 })
	AADD(_aStru,{"NOMEGER"	, "C" , 25, 0 })
	AADD(_aStru,{"VENDEDO"	, "C" , 06, 0 })
	AADD(_aStru,{"NOMEVEN"	, "C" , 25, 0 })
	AADD(_aStru,{"ORIGEM" 	, "C" , 01, 0 })
	AADD(_aStru,{"PREFIXO" 	, "C" , 03, 0 })
	AADD(_aStru,{"TITULO"	, "C" , 09, 0 })
	AADD(_aStru,{"PARCELA"	, "C" , 01, 0 })
	AADD(_aStru,{"TPPAG"	, "C" , 03, 0 })
	AADD(_aStru,{"VALPAG"	, "N" , 12, 2 })
	AADD(_aStru,{"VENCTO"	, "D" , 08, 0 })
	AADD(_aStru,{"SERIE"	, "C" , 03, 0 })
	AADD(_aStru,{"NUMERO"	, "C" , 09, 0 })
	AADD(_aStru,{"TPREC"	, "C" , 03, 0 })
	AADD(_aStru,{"PARCREC"	, "C" , 01, 0 })
	AADD(_aStru,{"CODCLI"	, "C" , 06, 0 })
	AADD(_aStru,{"LOJA"		, "C" , 02, 0 })
	AADD(_aStru,{"NOMCLI"	, "C" , 20, 0 })
	AADD(_aStru,{"EMISSAO"	, "D" , 08, 0 })
	AADD(_aStru,{"DBAIXA"	, "D" , 08, 0 })
	AADD(_aStru,{"VENCTIT"	, "D" , 08, 0 })
	AADD(_aStru,{"VALREC"	, "N" , 12, 4 })
	AADD(_aStru,{"BASCOM"	, "N" , 12, 4 })
	AADD(_aStru,{"PERCOM"	, "N" , 05, 2 })
	AADD(_aStru,{"VALCOM"	, "N" , 12, 2 })
	AADD(_aStru,{"CHEQUE"	, "C" , 15, 0 })
	AADD(_aStru,{"RETIDO"	, "C" , 01, 0 })
	AADD(_aStru,{"FORNECE"	, "C" , 006, 0 })
	AADD(_aStru,{"LOJA"		, "C" , 002, 0 })

	Private _cArqTrb := CriaTrab(_aStru,.T.)
	Private _cIndTrb := "GERENTE+VENDEDO+PREFIXO+TITULO+PARCELA+TPPAG+DTOS(DBAIXA)+SERIE+NUMERO"

	dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

	dbSelectArea("TRB")
	IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")



	Private _aCamp := {}

	AADD(_aCamp,{"FORNECE"	, "C" , 006, 0 })
	AADD(_aCamp,{"LOJA"		, "C" , 002, 0 })
	AADD(_aCamp,{"PREFIXO"	, "C" , 003, 0 })
	AADD(_aCamp,{"TITULO"	, "C" , 009, 0 })
	AADD(_aCamp,{"PARCELA"	, "C" , 001, 0 })
	AADD(_aCamp,{"TIPO"		, "C" , 003, 0 })
	AADD(_aCamp,{"EMISSAO"	, "D" , 008, 0 })
	AADD(_aCamp,{"VENCTO"	, "D" , 008, 0 })
	AADD(_aCamp,{"VALOR"	, "N" , 012, 2 })
	AADD(_aCamp,{"SALDO"	, "N" , 012, 2 })
	AADD(_aCamp,{"HIST"		, "C" , 100, 0 })

	Private _cArq2 := CriaTrab(_aCamp,.T.)
	Private _cInd2 := "FORNECE+LOJA+DTOS(VENCTO)+PREFIXO+TITULO+PARCELA+TIPO"

	dbUseArea(.T.,,_cArq2,"TSB",.F.,.F.)

	dbSelectArea("TSB")
	IndRegua("TSB",_cArq2,_cInd2,,,"Criando Trabalho...")




	If Select("TSE2") > 0
		TSE2->(dbCloseArea())
	Endif

	_cQuery := " SELECT * FROM "+RetSqlName("SE2")+" E2 " +CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SA2")+" A2 ON A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA " +CRLF
	_cQuery += " WHERE E2.D_E_L_E_T_ = '' AND A2.D_E_L_E_T_ = '' "  +CRLF
	_cQuery += " AND E2_FILIAL = '"+xFilial("SE2")+"' AND A2_FILIAL = '"+xFilial("SA2")+"' "  +CRLF
	_cQuery += " AND E2_TIPO = 'DP' " +CRLF
	_cQuery += " AND E2_PREFIXO = 'COM' " +CRLF
	//	_cQuery += " AND A2_XCOMISS = 'S' " +CRLF
	_cQuery += " AND E2_FORNECE BETWEEN '"+MV_PAR05+"'			AND '"+MV_PAR06+"' " +CRLF
	_cQuery += " AND E2_NUM		BETWEEN '"+MV_PAR07+"'			AND '"+MV_PAR08+"' " +CRLF
	_cQuery += " AND E2_VENCREA BETWEEN '"+DTOS(MV_PAR09)+"'	AND '"+DTOS(MV_PAR10)+"' " +CRLF
	_cQuery += " ORDER BY E2_NUM " +CRLF

	TcQuery _cQuery new Alias "TSE2"

	TcSetField("TSE2","E2_EMISSAO"	,"D")
	TcSetField("TSE2","E2_VENCREA"	,"D")

	Count to _nTSE2

	If _nTSE2 = 0
		MsgAlert("Não existem dados nos parâmetros informados!")
		TSE2->(dbCloseArea())
		Return(Nil)
	Endif

	TSE2->(dbGoTop())

	_nProc	:= 0

	While TSE2->(!Eof())

		_nProc ++

		_oMsg:cCaption := ('Processando Registro '+Alltrim(Str(_nProc))+' de '+Alltrim(Str(_nTSE2)))
		ProcessMessages()

		If TSE2->E2_TIPO = 'DP' .And. TSE2->E2_PREFIXO = 'COM'

			If Select("TSE3") > 0
				TSE3->(dbCloseArea())
			Endif

			_cQrySE3 := " SELECT * FROM "+RetSqlName("SE3")+" E3 " +CRLF
			_cQrySE3 += " INNER JOIN "+RetSqlName("SA3")+" A3 ON E3_VEND = A3_COD "  +CRLF
			_cQrySE3 += " WHERE E3.D_E_L_E_T_ = '' AND A3.D_E_L_E_T_ = ''"  +CRLF
			_cQrySE3 += " AND E3_FILIAL = '"+xFilial("SE3")+"' "  +CRLF
			_cQrySE3 += " AND A3_FILIAL = '"+xFilial("SA3")+"' "  +CRLF
			_cQrySE3 += " AND E3_PROCCOM = '"+TSE2->E2_FILIAL+TSE2->E2_PREFIXO+TSE2->E2_NUM+TSE2->E2_PARCELA+"' " +CRLF
			_cQrySE3 += " ORDER BY E3_XINFEXP,E3_NUM " +CRLF

			//		MEMOWRITE("D:\FINR06.txt",_cQrySE3)

			TcQuery _cQrySE3 new Alias "TSE3"

			TcSetField("TSE3","E3_EMISSAO"	,"D")
			TcSetField("TSE3","E3_VENCREA"	,"D")

			Count to _nSE3

			TSE3->(dbgoTop())

			While TSE3->(!EOF())

				_cGerente	:= TSE3->A3_GEREN
				_nNomGere	:= Posicione("SA3",1,xFilial("SA3")+TSE3->A3_GEREN,"A3_NOME")

				If _cGerente < MV_PAR01 .Or. _cGerente > MV_PAR02
					TSE3->(dbSkip())
					Loop
				Endif

				If TSE3->E3_VEND < MV_PAR03 .Or. TSE3->E3_VEND > MV_PAR04
					TSE3->(dbSkip())
					Loop
				Endif

				_cOrigem := ''
				If Empty(TSE3->E3_XINFEXP) //Tocantins
					If Empty(TSE3->E3_XINFIMP)
						_cOrigem := '1'	//Comissão NC
					Else
						_cOrigem := '2'	//Comissão Protheus
					Endif
					_cNomCli := Posicione("SA1",1,xFilial("SA1")+TSE3->E3_CODCLI+TSE3->E3_LOJA,"A1_NOME")
				Else//Ponte Nova
					If Empty(TSE3->E3_XINFIMP)
						_cOrigem := '3'	//Comissão NC
					Else
						_cOrigem := '4'	//Comissão Protheus
					Endif

					_cNewEmp := "02"
					_cOldEmp := "01"

					IF !(EqualFullName("SA1",_cNewEmp,_cOldEmp))

						_nOrder :=	SA1->(IndexOrd())

						//...Abre a Tabela da Nova Empresa
						If EmpChangeTable("SA1",_cNewEmp,_cOldEmp,_nOrder )
							_cNomCli := Posicione("SA1",1,xFilial("SA1")+TSE3->E3_CODCLI+TSE3->E3_LOJA,"A1_NOME")
						Endif
						//Restaura a Tabela da Empresa Atual
						EmpChangeTable("SA1",_cOldEmp,_cNewEmp,_nOrder )
					Endif
				Endif

				TRB->(RecLock("TRB",.T.))
				TRB->TIPO		:= TSE3->A3_XTIPO
				TRB->GERENTE	:= _cGerente
				TRB->NOMEGER	:= _nNomGere
				TRB->VENDEDO	:= TSE3->E3_VEND
				TRB->NOMEVEN	:= TSE3->A3_NOME
				TRB->ORIGEM		:= _cOrigem
				TRB->PREFIXO	:= TSE2->E2_PREFIXO
				TRB->TITULO		:= TSE2->E2_NUM
				TRB->PARCELA	:= TSE2->E2_PARCELA
				TRB->TPPAG		:= TSE2->E2_TIPO
				TRB->VALPAG		:= TSE2->E2_VALOR
				TRB->EMISSAO	:= TSE2->E2_EMISSAO
				TRB->VENCTO		:= TSE2->E2_VENCREA
				TRB->SERIE		:= TSE3->E3_PREFIXO
				TRB->NUMERO		:= TSE3->E3_NUM
				TRB->TPREC		:= TSE3->E3_TIPO
				TRB->PARCREC	:= TSE3->E3_PARCELA
				TRB->DBAIXA		:= TSE3->E3_EMISSAO
				TRB->CODCLI		:= TSE3->E3_CODCLI
				TRB->LOJA		:= TSE3->E3_LOJA
				TRB->NOMCLI		:= _cNomCli
				TRB->BASCOM		:= TSE3->E3_BASE
				TRB->PERCOM		:= TSE3->E3_PORC
				TRB->VALCOM		:= TSE3->E3_COMIS
				TRB->CHEQUE		:= Alltrim(TSE3->E3_XNRCHEQ)
				TRB->RETIDO		:= IF(!Empty(TSE3->E3_XBLOTIT),'S','')
				TRB->FORNECE	:= TSE2->E2_FORNECE
				TRB->LOJA		:= TSE2->E2_LOJA
				TRB->(msUnLock())

				TSE3->(dbSkip())
			EndDo

			TSE3->(dbCloseArea())
		Else
//			TSB->(RecLock("TSB",.T.))
//			TSB->FORNECE	:= TSE2->E2_FORNECE
//			TSB->LOJA		:= TSE2->E2_LOJA
//			TSB->PREFIXO	:= TSE2->E2_PREFIXO
//			TSB->PARCELA	:= TSE2->E2_PARCELA
//			TSB->TIPO		:= TSE2->E2_TIPO
//			TSB->EMISSAO	:= TSE2->E2_EMISSAO
//			TSB->VENCTO		:= TSE2->E2_VENCREA
//			TSB->VALOR		:= TSE2->E2_VALOR
//			TSB->SALDO		:= TSE2->E2_SALDO
//			TSB->HIST		:= TSE2->E2_HIST
//			TSB->(msUnLock())
		Endif

		TSE2->(dbSkip())
	EndDo

	TSE2->(dbCloseArea())

	If _lExcel
		GeraExcel(_oMsg)
	Else
		GeraPDF(_oMsg)
	Endif

Return(Nil)



Static Function GeraExcel(_oMsg)

	Local _cPlan	:= ""
	Local _cTable	:= ""

	_oExcel	:= FWMsExcel():New()

	_oMsg:cCaption := ('Gerando Relatório em Excel...')
	ProcessMessages()

	TRB->(dbGoTop())

	While !TRB->(EOF())

		_cPlan	:= TRB->GERENTE
		_cTable	:= "Gerente: "+Alltrim(TRB->GERENTE)+" "+TRB->NOMEGER

		_oExcel:AddworkSheet(_cPlan)

		_oExcel:AddTable (_cPlan,_cTable)

		_oExcel:AddColumn(_cPlan,_cTable,"Vendedor"			,1,1,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Nome"				,1,1,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Origem"			,1,1,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Prefixo"			,1,1,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Título Pg"		,1,1,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Parcela Pg"		,1,1,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Tipo Pg"			,1,1,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Valor Pg"			,3,2,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Emissao Pg"		,1,1,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Vencto Pg"		,1,1,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Série"			,1,1,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Número"			,1,1,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Tipo"				,1,1,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Parcela"			,1,1,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Cliente"			,1,1,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Loja"				,1,1,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Nome Cliente"		,1,1,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Data Baixa"		,1,1,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Base Comissão"	,3,2,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"% Comissão"		,3,2,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Valor Comissão"	,3,2,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Cheque"			,1,1,.F.)
		_oExcel:AddColumn(_cPlan,_cTable,"Retido?"			,1,1,.F.)

		_cKey := TRB->GERENTE

		While !TRB->(EOF()) .And. _cKey == TRB->GERENTE

			_aCel := {		;
			TRB->VENDEDO	,;
			TRB->NOMEVEN	,;
			TRB->ORIGEM		,;
			TRB->PREFIXO	,;
			TRB->TITULO		,;
			TRB->PARCELA	,;
			TRB->TPPAG		,;
			TRB->VALPAG		,;
			TRB->EMISSAO	,;
			TRB->VENCTO		,;
			TRB->SERIE		,;
			TRB->NUMERO		,;
			TRB->TPREC		,;
			TRB->PARCREC	,;
			TRB->CODCLI		,;
			TRB->LOJA		,;
			TRB->NOMCLI		,; //			TRB->VENCTIT	,; //			TRB->VALREC		,;
			TRB->DBAIXA		,;
			TRB->BASCOM		,;
			TRB->PERCOM		,;
			TRB->VALCOM		,;
			TRB->CHEQUE		,;
			TRB->RETIDO		}

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

	_cArq := 'Comissão_'+_cDat1+'_'+_cHor1 + ".xls"

	If __CopyFile( _cArq2, _cDir + _cArq )
		_oExcelApp := MsExcel():New()
		_oExcelApp:WorkBooks:Open( _cDir + _cArq )
		_oExcelApp:SetVisible(.T.)
	Endif

Return(Nil)



Static Function GeraPdf(_oMsg)

	Local _lAdjustToLegacy	:= .F.
	Local _lDisableSetup	:= .T.
	Local _cTitPDF			:= 'Comissao_'+GravaData(dDataBase,.f.,8)+'_'+StrTran(Time(),':','')
	Local _lArqInd			:= MV_PAR12 == 2
	Local _lSepVend			:= MV_PAR11 == 2 .And. _lArqInd

	_oFont1		:= TFont():New('Arial'	,,-12,,.T.,,,,,.F.,.F.)
	_oFont2		:= TFont():New('Arial'	,,-09,,.F.,,,,,.F.,.F.)
	_oFont2N	:= TFont():New('Arial'	,,-09,,.T.,,,,,.F.,.F.)

	If !_lArqInd
		_oPrinter := FWMSPrinter():New(_cTitPDF, 6, _lAdjustToLegacy,_cDir, _lDisableSetup,    , , ,    , , .F., )

		_oPrinter:SetPortrait()
		_oPrinter:SetPaperSize(9)
	Endif

	_oMsg:cCaption := ('Gerando Relatório em PDF...')
	ProcessMessages()

	TRB->(dbGoTop())

	_nTComT	:= 0

	While !TRB->(EOF())

		If !_lArqInd

			If _lSepVend .And. _nTComT > 0
				_nLin = _nTotlin +1
			Endif

			CheckLine()

			_cGerente := TRB->GERENTE + " - "+ Alltrim(TRB->NOMEGER)
			_oPrinter:SayAlign(_nLin,_nCol+2,"Gerente: "+_cGerente,_oFont2,_nColTot,7,CLR_RED,0, 1 )

			_nLin 	+= 8
		Endif

		_nTComG	:= 0
		_cKey := TRB->GERENTE

		_cPath	:= _cDir+"\"+Alltrim(TRB->NOMEGER)

		If !ExistDir(_cPath)
			If MakeDir(_cPath) <> 0
				MsgAlert("Nao foi possível criar o diretório "+_cPath)
				Return(Nil)
			Endif
		Endif

		While !TRB->(EOF()) .And. _cKey == TRB->GERENTE

			If _lArqInd

				_nPag 		:= _nTPageF := _nTPageA := _nTPageT := 0

				_cTit2  := Substr(_cTitPdf,10)+"_"+Alltrim(TRB->NOMEVEN)

				_oPrinter := FWMSPrinter():New(_cTit2, 6, _lAdjustToLegacy, , _lDisableSetup,    , , , .F./*lserver*/ ,.F./*lPDFAsPNG*/,;
				.F. /*lRaw*/,.F./*lViewPDF*/ )

				_oPrinter:SetPortrait()
				_oPrinter:SetPaperSize(9)
				_oPrinter:cPathPDF := _cPath+"\"

				_nLin = _nTotlin +1
			Endif

			If _lSepVend .And. _nTComG > 0
				_nLin = _nTotlin +1

				CheckLine()

				_cGerente := TRB->GERENTE + " - "+ Alltrim(TRB->NOMEGER)
				_oPrinter:SayAlign(_nLin,_nCol+2,"Gerente: "+_cGerente,_oFont2,_nColTot,7,CLR_HRED,0, 1 )

				_nLin 	+= 8

			Endif

			CheckLine()

			_cVenGer := "Vendedor: "
			If TRB->VENDEDO == TRB->GERENTE
				_cVenGer := "Gerente: "
			Endif

			_cVendedor := TRB->VENDEDO + " - "+ Alltrim(TRB->NOMEVEN)
			_oPrinter:SayAlign(_nLin,_nCol+5,_cVenGer+_cVendedor,_oFont2,_nColTot,7,CLR_BLUE,0, 1 )

			_nLin 	+= 8
			_nTComV	:= 0
			_nTEmp1	:=0
			_nTEmp2	:=0
			_cCodV	:= TRB->VENDEDO
			_cForLj	:= TRB->FORNECE + TRB->LOJA

			_cKey2 := TRB->GERENTE  + TRB->VENDEDO

			While !TRB->(EOF()) .And. _cKey2 == TRB->GERENTE  + TRB->VENDEDO

				CheckLine()

				_cInfoAd1 := Alltrim(TRB->PREFIXO) +"-"+;
				Alltrim(TRB->TITULO) +"-"+;
				Alltrim(TRB->PARCELA) +Space(10)+;
				"Tipo: "+TRB->TPPAG +Space(10)+;
				"Emissão: "+dToc(TRB->EMISSAO) + Space(10)+;
				"Vencimento: "+dToc(TRB->VENCTO)+ Space(10)+;
				"Valor: "+Alltrim(Transform(TRB->VALPAG,'@E 999,999.99'))

				_oPrinter:SayAlign(_nLin,_nCol+8,_cInfoAd1,_oFont2,_nColTot,7,CLR_GREEN,0, 1 )
				_nLin 	+= 8

				_cKey3		:= TRB->GERENTE + TRB->VENDEDO + TRB->PREFIXO + TRB->TITULO + TRB->PARCELA + TRB->TPPAG
				_nTComTit	:= 0

				While !TRB->(EOF()) .And. _cKey3 == TRB->GERENTE + TRB->VENDEDO + TRB->PREFIXO + TRB->TITULO + TRB->PARCELA + TRB->TPPAG

					CheckLine()

					For _nCab := 1 to Len(_aCabec)

						If _aCabec[_nCab][5] = 'N'
							_cImp := Alltrim(Transform(&('TRB->'+_aCabec[_nCab][4]),_aCabec[_nCab][6]))
						ElseIf _aCabec[_nCab][5] = 'D'
							_cImp := dToc(&('TRB->'+_aCabec[_nCab][4]))
						Else
							_cImp := Alltrim(&('TRB->'+_aCabec[_nCab][4]))
						Endif

						_nColRel := _aCabec[_nCab][Len(_aCabec[_nCab])]

						_oPrinter:SayAlign(_nLin,_nColRel,_cImp,_oFont2,_aCabec[_nCab][2],7,,_aCabec[_nCab][3], 1 )
					Next _nCab

					_nTComTit	+= TRB->VALCOM
					_nTComV		+= TRB->VALCOM
					_nTComG		+= TRB->VALCOM
					_nTComT		+= TRB->VALCOM

					If TRB->ORIGEM $ '1|2'
						_nTEmp1	+= TRB->VALCOM
					ElseIf TRB->ORIGEM $ '3|4'
						_nTEmp2	+= TRB->VALCOM
					Endif

					_nLin += 8

					TRB->(dbSkip())
				EndDo

				CheckLine()

				_cMsg := "Total Título: "
				ImpTotal(_cMsg,_oFont2N,'VALCOM',_nTComTit,CLR_GREEN,_nCol+8)

				_nLin += 8
			EndDo

			If _nTEmp1 > 0
				_cMsg := "Total Tocantins:"
				ImpTotal(_cMsg,_oFont2N,'VALCOM',_nTEmp1,CLR_BROWN,_nCol+5)
				CheckLine()
			Endif

			If _nTEmp2 > 0
				_cMsg := "Total Ponte Nova"
				ImpTotal(_cMsg,_oFont2N,'VALCOM',_nTEmp2,CLR_BROWN,_nCol+5)
				CheckLine()
			Endif

//			ImpDebCre(_cForLj)

			_cMsg := "Total "+_cVenGer+_cVendedor
			ImpTotal(_cMsg,_oFont2N,'VALCOM',_nTComV,CLR_BLUE,_nCol+5)

			_nLin += 8

			If MV_PAR13 == 2
				_nLin += 8
				CheckLine()
				ImpRetida(_cCodV)
			Endif

			If _lArqInd
				Ms_Flush()
				_oPrinter:EndPage()
				_oPrinter:Preview()
			Endif

		EndDo

		If !_lArqInd .And. !_lSepVend
			CheckLine()

			//			_nLin += 8

			//			CheckLine()

			_cMsg := "Total Gerente: "+_cGerente
			ImpTotal(_cMsg,_oFont2N,'VALCOM',_nTComG,CLR_RED,_nCol+2)

			_nLin += 8
		Endif
	EndDo

	TRB->(dbCloseArea())

	If !_lArqInd

		If !_lSepVend
			CheckLine()

			_nLin += 8

			CheckLine()

			_cMsg := "Total Geral: "
			ImpTotal(_cMsg,_oFont2N,'VALCOM',_nTComT,CLR_BLACK,_nCol+2)
		Endif

		Ms_Flush()

		_oPrinter:EndPage()

		_oPrinter:Preview()
	Endif

Return(Nil)




Static Function ImpTotal(_cMsg,_oFonte,_cCampo,_nTCom,_nCor,_nColuna)

	_oPrinter:SayAlign(_nLin,_nColuna,_cMsg,_oFonte,_nColTot,7,_nCor,0, 1 )

	_nPosCom := aScan(_aCabec,{|x| x[4] = _cCampo})

	_cTCom := Alltrim(Transform(_nTCom,_aCabec[_nPosCom][6]))

	_nColRel := _aCabec[_nPosCom][Len(_aCabec[_nPosCom])]

	_oPrinter:SayAlign(_nLin,_nColRel,_cTCom,_oFonte,_aCabec[_nPosCom][2],7,_nCor,_aCabec[_nPosCom][3], 1 )

	_nLin += 8

Return(Nil)




Static Function CheckLine()

	If _nLin > _nTotlin
		LoadHeader()
		_nLin := 075
	Endif

Return()




Static Function LoadHeader()

	_nSizePage	:= _oPrinter:nPageWidth / _oPrinter:nFactorHor
	_nLin		:= _aMargRel[2] + 10
	_nCol		:= _aMargRel[1] + 10
	_nColTot	:= _nSizePage-(_aMargRel[1]+_aMargRel[3])
	_nLinTot	:= ((_oPrinter:nPageHeight / _oPrinter:nFactorVert) - (_aMargRel[2]+_aMargRel[4])) - 6
	_nMaxLin	:= _nLinTot
	_nTBoxPag	:= 80
	_nLinIni	:= _nLin

	_nPag ++

	_oPrinter:StartPage()

	_oPrinter:Box(_nLin,_nCol, _nLinTot,_nColTot)

	_nLin += 5

	_oPrinter:SayBitmap(_nLin,_nCol+5,"lgrl"+cEmpAnt+cFilAnt+".jpg",0030,030)

	_oPrinter:SayAlign(_nLin,_nCol,Alltrim(SM0->M0_NOMECOM),_oFont1,_nColTot - _nTBoxPag,7,, 2, 1 )

	_oPrinter:SayAlign(_nLin,_nColTot-_nTBoxPag,"Página: " + cValToChar(_nPag)	,_oFont2N,_nTBoxPag,7,, 2, 1 )

	_nLin += 15

	_oPrinter:SayAlign(_nLin,_nCol,"Relatório de Comissão",_oFont1,_nColTot - _nTBoxPag,7,, 2, 1 )
	_oPrinter:SayAlign(_nLin-5,_nColTot-_nTBoxPag,"Data: " + dToc(dDataBase),_oFont2N,_nTBoxPag,7,, 2, 1 )
	_oPrinter:SayAlign(_nLin+5,_nColTot-_nTBoxPag,"Hora: " + Left(Time(),5),_oFont2N,_nTBoxPag,7,, 2, 1 )

	_nLin += 20
	_oPrinter:Line(_nLin,_nCol,_nLin,_nColTot)

	_oPrinter:Line(_nLinIni,_nColTot-_nTBoxPag,_nLin,_nColTot-_nTBoxPag)

	_nLin += 2

	_aCabec := {;
	{'Orig.'			,20		,0,'ORIGEM'	,'C',Nil			},;
	{'Pref.'			,20		,0,'SERIE'	,'C',Nil			},;
	{'Título'			,40		,0,'NUMERO'	,'C',Nil			},;
	{'Parc.'			,20		,0,'PARCREC','C',Nil			},;
	{'Tipo'				,20		,0,'TPREC'	,'C',Nil			},;
	{'Cód. Cliente'		,50		,0,'CODCLI'	,'C',Nil			},;
	{'Loja'				,20		,0,'LOJA'	,'C',Nil			},;
	{'Nome Fantasia'	,105	,0,'NOMCLI'	,'C',Nil			},;
	{'Dt Baixa'			,40		,2,'DBAIXA' ,'D',Nil			},;
	{'Base'				,35		,1,'BASCOM'	,'N','@e 999,999.99'},;
	{'%'				,25		,1,'PERCOM'	,'N','@e 999.99'	},;
	{'Valor'			,50		,1,'VALCOM'	,'N','@e 999,999.99'},;
	{'Cheque'			,45		,1,'CHEQUE'	,'C',Nil			},;
	{'Retido?'			,40		,2,'RETIDO'	,'C',Nil			}}

	_nColHead := _nCol+20
	For _nCab := 1 to Len(_aCabec)
		_oPrinter:SayAlign(_nLin,_nColHead+2,_aCabec[_nCab][1],_oFont2N,_aCabec[_nCab][2],7,,_aCabec[_nCab][3], 1 )

		AADD(_aCabec[_nCab],_nColHead+2)

		_nColHead += _aCabec[_nCab][2]

	Next _nCab

	_nLin += 10
	_oPrinter:Line(_nLin,_nCol,_nLin,_nColTot)

Return()



Static Function ImpRetida(_cCodVen)

	Local _cQryRet := ''

	If Select("E3RET") > 0
		E3RET->(dbCloseArea())
	Endif

	_cQryRet += " SELECT * FROM "+RetSqlName("SE3")+" E3RET " +CRLF
	_cQryRet += " INNER JOIN "+RetSqlName("SA3")+" A3RET ON E3_VEND = A3_COD "  +CRLF
	_cQryRet += " WHERE E3RET.D_E_L_E_T_ = '' AND A3RET.D_E_L_E_T_ = ''"  +CRLF
	_cQryRet += " AND E3_VEND = '"+_cCodVen+"' " + CRLF
	_cQryRet += " AND E3_DATA = '' " +CRLF
	_cQryRet += " AND E3_XBLOTIT <> '' " +CRLF
	_cQryRet += " ORDER BY E3_VENCTO,E3_NUM " +CRLF

	TcQuery _cQryRet New Alias "E3RET"

	Count to _nE3RET

	If _nE3RET > 0

		TcSetField("E3RET","E3_EMISSAO","D")

		CheckLine()

		_oPrinter:SayAlign(_nLin,_nCol+5,"Comissões Retidas",_oFont2N,_nColTot,7,CLR_MAGENTA,0, 1 )

		_nLin += 8

		E3RET->(dbGotop())

		_nTotRet := 0

		While E3RET->(!EOF())

			CheckLine()

			_cOrigem := ''
			If Empty(E3RET->E3_XINFEXP) //Tocantins
				If Empty(E3RET->E3_XINFIMP)
					_cOrigem := '1'	//Comissão NC
				Else
					_cOrigem := '2'	//Comissão Protheus
				Endif
				_cNomCli := Posicione("SA1",1,xFilial("SA1")+E3RET->E3_CODCLI+E3RET->E3_LOJA,"A1_NOME")
			Else//Ponte Nova
				If Empty(E3RET->E3_XINFIMP)
					_cOrigem := '3'	//Comissão NC
				Else
					_cOrigem := '4'	//Comissão Protheus
				Endif

				_cNewEmp := "02"
				_cOldEmp := "01"

				IF !(EqualFullName("SA1",_cNewEmp,_cOldEmp))

					_nOrder :=	SA1->(IndexOrd())

					//...Abre a Tabela da Nova Empresa
					If EmpChangeTable("SA1",_cNewEmp,_cOldEmp,_nOrder )
						_cNomCli := Posicione("SA1",1,xFilial("SA1")+E3RET->E3_CODCLI+E3RET->E3_LOJA,"A1_NOME")
					Endif
					//Restaura a Tabela da Empresa Atual
					EmpChangeTable("SA1",_cOldEmp,_cNewEmp,_nOrder )
				Endif
			Endif

			For _nCab := 1 to Len(_aCabec)

				_cImp := ''
				If _aCabec[_nCab][4] = 'ORIGEM'
					_cImp := _cOrigem
				ElseIf _aCabec[_nCab][4] = 'SERIE'
					_cImp := Alltrim(E3RET->E3_SERIE)
				ElseIf _aCabec[_nCab][4] = 'NUMERO'
					_cImp := Alltrim(E3RET->E3_NUM)
				ElseIf _aCabec[_nCab][4] = 'PARCREC'
					_cImp := Alltrim(E3RET->E3_PARCELA)
				ElseIf _aCabec[_nCab][4] = 'TPREC'
					_cImp := Alltrim(E3RET->E3_TIPO)
				ElseIf _aCabec[_nCab][4] = 'CODCLI'
					_cImp := Alltrim(E3RET->E3_CODCLI)
				ElseIf _aCabec[_nCab][4] = 'LOJA'
					_cImp := Alltrim(E3RET->E3_LOJA)
				ElseIf _aCabec[_nCab][4] = 'NOMCLI'
					_cImp := Alltrim(_cNomCli)
				ElseIf _aCabec[_nCab][4] = 'DBAIXA'
					_cImp := dToc(E3RET->E3_EMISSAO)
				ElseIf _aCabec[_nCab][4] = 'BASCOM'
					_cImp := Alltrim(Transform(E3RET->E3_BASE,_aCabec[_nCab][6]))
				ElseIf _aCabec[_nCab][4] = 'PERCOM'
					_cImp := Alltrim(Transform(E3RET->E3_PORC,_aCabec[_nCab][6]))
				ElseIf _aCabec[_nCab][4] = 'VALCOM'
					_cImp := Alltrim(Transform(E3RET->E3_COMIS,_aCabec[_nCab][6]))
					_nTotRet += E3RET->E3_COMIS
				Endif

				If !Empty(_cImp)
					_nColRel := _aCabec[_nCab][Len(_aCabec[_nCab])]
					_oPrinter:SayAlign(_nLin,_nColRel,_cImp,_oFont2,_aCabec[_nCab][2],7,CLR_HMAGENTA,_aCabec[_nCab][3], 1 )
				Endif
			Next _nCab

			_nLin += 8

			E3RET->(dbSkip())
		EndDo

		_cMsg := "Total Comissões Retidas: "
		ImpTotal(_cMsg,_oFont2N,'VALCOM',_nTotRet,CLR_MAGENTA,_nCol+5)

		_nLin += 8

	Endif

	E3RET->(dbCloseArea())

	_nLin += 8

Return(Nil)



Static Function ImpDebCre(_cForLj)


	If TSB->(msSeek(_cForLj))

		_nLin += 8
		CheckLine()

		_cMsg := "Informações Adicionais: "
		ImpTotal(_cMsg,_oFont2N,'VALCOM',0,CLR_HCYAN,_nCol+5)

		While TSB->(!EOF()) .And. TSB->FORNECE + TSB->LOJA = _cForLj

			//			_nLin += 8
			//			CheckLine()

			//		_cMsg := "Total Comissões Retidas: "
			//		ImpTotal(_cMsg,_oFont2N,'VALCOM',_nTotRet,CLR_MAGENTA,_nCol+5)
			//
			//	AADD(_aCamp,{"FORNECE"	, "C" , 006, 0 })
			//	AADD(_aCamp,{"LOJA"		, "C" , 002, 0 })
			//	AADD(_aCamp,{"PREFIXO"	, "C" , 003, 0 })
			//	AADD(_aCamp,{"TITULO"	, "C" , 009, 0 })
			//	AADD(_aCamp,{"PARCELA"	, "C" , 001, 0 })
			//	AADD(_aCamp,{"TIPO"		, "C" , 003, 0 })
			//	AADD(_aCamp,{"EMISSAO"	, "D" , 008, 0 })
			//	AADD(_aCamp,{"VENCTO"	, "D" , 008, 0 })
			//	AADD(_aCamp,{"VALOR"	, "N" , 012, 2 })
			//	AADD(_aCamp,{"SALDO"	, "N" , 012, 2 })
			//	AADD(_aCamp,{"HIST"		, "C" , 100, 0 })


			TSB->(dbSkip())
		EndDo

		_nLin += 8
		CheckLine()

		_cMsg := "Total Informações Adicionais: "
		ImpTotal(_cMsg,_oFont2N,'VALCOM',0,CLR_CYAN,_nCol+5)

	Endif

Return(Nil)


Static Function AtuSX1()

	Local _cPerg  := "FINR06"

	//    	  Grupo/Ordem/Pergunta    						/perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid		/Var01     /Def01    	/defspa1/defeng1/Cnt01  /Var02/Def02	/Defspa2/defeng2/Cnt02/Var03/Def03	/defspa3/defeng3/Cnt03/Var04/Def04	/defspa4/defeng4/Cnt04/Var05/Def05	/deefspa5/defeng5/Cnt05/F3		/cPyme	/cGrpSxg/cHelp
	U_CRIASX1(_cPerg,"01" ,"Gerente de ?"					,""       ,""      ,"mv_ch1","C" ,06     ,0      ,0     ,"G",""			,"MV_PAR01",""        	,""     ,""     ,""     ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""      ,""     ,""   ,"SA3"	,		,		,)
	U_CRIASX1(_cPerg,"02" ,"Gerente Até ?"					,""       ,""      ,"mv_ch2","C" ,06     ,0      ,0     ,"G","naovazio"	,"MV_PAR02",""   		,""     ,""     ,""     ,""   ,""		,""     ,""     ,""   ,""   ,""  	,""     ,""     ,""   ,""   ,""  	,""     ,""     ,""   ,""   ,""   	,""      ,""     ,""   ,"SA3"	,		,		,)
	U_CRIASX1(_cPerg,"03" ,"Vendedor De ?"					,""       ,""      ,"mv_ch3","C" ,06     ,0      ,0     ,"G",""			,"MV_PAR03",""        	,""     ,""     ,""     ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""      ,""     ,""   ,"SA3"	,		,		,)
	U_CRIASX1(_cPerg,"04" ,"Vendedor Até ?"					,""       ,""      ,"mv_ch4","C" ,06     ,0      ,0     ,"G","naovazio"	,"MV_PAR04",""   		,""     ,""     ,""     ,""   ,""		,""     ,""     ,""   ,""   ,""  	,""     ,""     ,""   ,""   ,""  	,""     ,""     ,""   ,""   ,""   	,""      ,""     ,""   ,"SA3"	,		,		,)
	U_CRIASX1(_cPerg,"05" ,"Fornecedor De ?"				,""       ,""      ,"mv_ch5","C" ,06     ,0      ,0     ,"G",""			,"MV_PAR05",""        	,""     ,""     ,""     ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""      ,""     ,""   ,"SA2"	,		,		,)
	U_CRIASX1(_cPerg,"06" ,"Fornecedor Ate ?"				,""       ,""      ,"mv_ch6","C" ,06     ,0      ,0     ,"G","naovazio"	,"MV_PAR06",""        	,""     ,""     ,""     ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""      ,""     ,""   ,"SA2"	,		,		,)
	U_CRIASX1(_cPerg,"07" ,"Título De ?"					,""       ,""      ,"mv_ch7","C" ,09     ,0      ,0     ,"G",""			,"MV_PAR07",""        	,""     ,""     ,""     ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""      ,""     ,""   ,"SE2"	,		,		,)
	U_CRIASX1(_cPerg,"08" ,"Título Até ?"					,""       ,""      ,"mv_ch8","C" ,09     ,0      ,0     ,"G","naovazio"	,"MV_PAR08",""        	,""     ,""     ,""     ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""      ,""     ,""   ,"SE2"	,		,		,)
	U_CRIASX1(_cPerg,"09" ,"Vencto Tit. De ?"				,""       ,""      ,"mv_ch9","D" ,08     ,0      ,0     ,"G",""			,"MV_PAR09",""        	,""     ,""     ,""     ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""   	,""      ,""     ,""   ,""		,		,		,)
	U_CRIASX1(_cPerg,"10" ,"Vencto Tit. Até ?"				,""       ,""      ,"mv_cha","D" ,08     ,0      ,0     ,"G",""			,"MV_PAR10",""   		,""     ,""     ,""     ,""   ,""		,""     ,""     ,""   ,""   ,""  	,""     ,""     ,""   ,""   ,""  	,""     ,""     ,""   ,""   ,""   	,""      ,""     ,""   ,""		,		,		,)
	U_CRIASX1(_cPerg,"11","Separa Vendedor ?"				,""       ,""      ,"mv_chb","N" ,01     ,0      ,0     ,"C",""     	,"MV_PAR11","Não"		,""     ,""     ,""   	,""   ,"Sim" 	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""    ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"12","Gera arquivo PDF individual ?"	,""       ,""      ,"mv_chc","N" ,01     ,0      ,0     ,"C",""     	,"MV_PAR12","Não"		,""     ,""     ,""   	,""   ,"Sim" 	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""    ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"13","Imp. Comissão Retida não Paga ?"	,""       ,""      ,"mv_chd","N" ,01     ,0      ,0     ,"C",""     	,"MV_PAR13","Não"		,""     ,""     ,""   	,""   ,"Sim" 	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""    ,""      ,""     ,""   ,"")
	//	U_CRIASX1(_cPerg,"14","Imp. Débitos/Créditos ?"			,""       ,""      ,"mv_che","N" ,01     ,0      ,0     ,"C",""     	,"MV_PAR14","Não"		,""     ,""     ,""   	,""   ,"Sim" 	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""    ,""      ,""     ,""   ,"")

Return (Nil)