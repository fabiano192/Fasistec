#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa TOPOR02
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Importar tabelas RM
*/

USER FUNCTION IMPRM(_aTab)

	Local _oDlg			:= NIL
	Local _nOpc			:= 0

	Private _cTitulo	:= "Importar tabelas do RM"
	Private _oProcess	:= Nil

	Private _cProc		:= 'Processando'
	Private _cMsgTit	:= 'Aguarde, gerando dados...'
	// Private _cPasta		:= dtos(dDataBase)+'_'+StrTran(Time(),":","")

	Private _oFont11N	:= TFont():New('Arial'	,,-11,,.T.,,,,,.F.,.F.)

	Private _cChave		:= ''


	If !Empty(_aTab)
		_oProcess := MsNewProcess():New( { || IMPDADOS(_aTab) } , _cMsgTit, _cProc , .F. )
		_oProcess:Activate()
	Else

		DEFINE MSDIALOG _oDlg FROM 0,0 TO 120,320 TITLE _cTitulo OF _oDlg PIXEL

		_oGrupo	:= TGroup():New(005,005,035,155,"",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

		@ 010,015 SAY _oTSayA VAR "Esta rotina tem por objetivo Importar as tabelas  "	OF _oGrupo PIXEL Size 150,010 FONT _oFont11N
		@ 020,015 SAY 'do Banco de Dados "DADOSRM" '		    						OF _oGrupo PIXEL Size 150,010 FONT _oFont11N

		TButton():New( 40,068, "OK" ,_oDlg,{||_nOpc := 1,_oDlg:End()},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )

		TButton():New( 40,120, "Sair" ,_oDlg,{||_nOpc := 0,_oDlg:End()},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )

		ACTIVATE MSDIALOG _oDlg CENTERED

		If _nOpc = 1
			_aRetTab := GetTable()

			If !Empty(_aRetTab)
				_oProcess := MsNewProcess():New( { || IMPDADOS(_aRetTab) } , _cMsgTit, _cProc , .F. )
				_oProcess:Activate()

				// MsgInfo("Finalizado o processo de IMPortação das tabelas do banco de dados DADOSRM")
				If MsgYesNo("Finalizado o processo de Importação das tabelas do banco de dados DADOSRM. Deseja importar agora?")

				Endif
			Else
				MsgInfo("Não foi marcado nenhuma tabela para Importação.")
			Endif
		Endif
	Endif

Return(Nil)




Static Function IMPDADOS(_aTabelas)

	Local _nTab        := 0
	Local _cTab        := ''

	Private _cKey1     := ''

	_oProcess:SetRegua1(Len(_aTabelas)) //Alimenta a primeira barra de progresso
	_oProcess:IncRegua1("Tabelas RM")

	For _nTab := 1 to Len(_aTabelas)

		_oProcess:IncRegua1("Tabelas RM")

		_cTab := _aTabelas[_nTab]

		&("U_RM_"+Left(_cTab,3)+"I(_oProcess,_cTab,_cPasta)")

	Next _nTab

Return(Nil)




USER FUNCTION RM_ZF6I(_oProcess,_cTab,_cPasta)

	Local _cAlias   := ''
	Local _lTabLoc  := .T.
	Local _cModo
	Local _nZF6
	Local _aArea     := GetArea()
	Local _aAreaZF6  := ZF6->( GetArea() )
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvArqTab := cArqTab //Salva os arquivos de

	// _cPasta := "20200603_110107"

	If Alltrim(cEmpAnt) = Substr(_cTab,4,2)
		_cAlias := "ZF6"
	Else

		If Select("ZF6A") > 0
			ZF6A->(dbCloseArea())
		Endif

		If EmpOpenFile("ZF6A","ZF6",1,.T., Substr(_cTab,4,2),@_cModo)
			_cAlias := "ZF6A"
			_lTabLoc := .F.
		Endif
	Endif

	If !Empty(_cAlias)

		_cUpd := " DELETE "+_cTab

		TCSQLEXEC(_cUpd )

		_cArq	:= "\TAB_RM\"+_cPasta+"\"+_cTab+".dtc"		//Gera o nome do arquivo
		_cInd	:= "\TAB_RM\"+_cPasta+"\"+_cTab+"0"			//Indice do arquivo

		If SELECT("TZF6") > 0
			TZF6->(dbCloseArea())
		Endif

		dbUseArea( .T.,"CTREECDX", _cArq,"TZF6", .T., .F. )

		If Select("TZF6") = 0
			MsgInfo( 'Erro Abrir tabela Temporária TZF6', 'RM_ZF6' )
			Return(Nil)
		Endif

		dbSelectArea("TZF6")

		IndRegua( "TZF6", _cInd, ZF6->( IndexKey( 1 ) ))

		dbClearIndex()
		dbSetIndex(_cInd + OrdBagExt() )

		_nReg := Contar("TZF6","!EOF()")

		_oProcess:SetRegua2( _nReg ) //Alimenta a segunda barra de progresso
		_oProcess:IncRegua2("Importando a tabela "+Left(_cTab,3)+" na Empresa "+Substr(_cTab,4,2) )



		TZF6->(dbGoTop())

		While TZF6->(!EOF())

			(_cAlias)->(RecLock(_cAlias,.T.))
			For _nZF6 := 1 to (_cAlias)->(FCOUNT())
				&("(_cAlias)->"+((_cAlias)->(FIELD(_nZF6)))) := &("TZF6->"+((_cAlias)->(FIELD(_nZF6))))
			Next _nZF6
			(_cAlias)->(MsUnLock())

			TZF6->(dbSkip())
		EndDo

		TZF6->(dbCloseArea())

		If !_lTabLoc
			(_cAlias)->(dbCloseArea())
		Endif

	Endif

	//Restaura os Dados de Entrada ( Ambiente )
	cFilAnt := _cSvFilAnt
	cEmpAnt := _cSvEmpAnt
	cArqTab := _cSvArqTab

	//Restaura os ponteiros das Tabelas

	RestArea( _aAreaZF6 )
	RestArea( _aArea )

Return(Nil)