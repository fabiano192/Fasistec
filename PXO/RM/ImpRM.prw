#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa TOPOR02
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas RM
*/

USER FUNCTION IMPRM()

	Local _oDlg			:= NIL
	Local _nOpc			:= 0

	Private _cTitulo	:= "Exportar tabelas do RM"
	Private _oProcess	:= Nil

	Private _cProc		:= 'Processando'
	Private _cMsgTit	:= 'Aguarde, gerando dados...'
	Private _cPasta		:= dtos(dDataBase)+'_'+StrTran(Time(),":","")

	Private _oFont11N	:= TFont():New('Arial'	,,-11,,.T.,,,,,.F.,.F.)

	Private _cChave		:= ''

	DEFINE MSDIALOG _oDlg FROM 0,0 TO 120,320 TITLE _cTitulo OF _oDlg PIXEL

	_oGrupo	:= TGroup():New(005,005,035,155,"",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 010,015 SAY _oTSayA VAR "Esta rotina tem por objetivo exportar as tabelas  "	OF _oGrupo PIXEL Size 150,010 FONT _oFont11N
	@ 020,015 SAY 'do Banco de Dados "DADOSRM" '		    						OF _oGrupo PIXEL Size 150,010 FONT _oFont11N

	// _oTBut1	:= TButton():New( 60,010, "Parâmetros" ,_oDlg,{||Pergunte("TOPO02")},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )

	TButton():New( 40,068, "OK" ,_oDlg,{||_nOpc := 1,_oDlg:End()},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )

	TButton():New( 40,120, "Sair" ,_oDlg,{||_nOpc := 0,_oDlg:End()},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )


	ACTIVATE MSDIALOG _oDlg CENTERED

	If _nOpc = 1
		// LjMsgRun(_cMsgTit,_cProc,{||EXPDADOS()})
		_oProcess := MsNewProcess():New( { || EXPDADOS() } , _cMsgTit, _cProc , .F. )
		_oProcess:Activate()

		MsgInfo("Finalizado o processo de Exportação das tabelas do banco de dados DADOSRM")
	Endif

Return(Nil)




Static Function EXPDADOS()

	Local _aTabelas    := {'SA3'}
	// Local _aTabelas := {'CT1','CT2','SA1','SA2','SB1','CTT','SA6','SE1','SE2','SF2','SD2','SA4','DA0','DA1'}//'SE4','SRA,'SF1'
	Local _nTab        := 0
	Local _cTab        := ''
	// Local _aEmp        := GetEmp()
	Private _nCodA1    := 0
	Private _nCodA10   := 0
	Private _nCodA19   := 0
	Private _nCodA110  := 0
	Private _nCodA111  := 0
	Private _nCodA2    := 0
	Private _nCodA20   := 0
	Private _nCodA29   := 0
	Private _nCodA210  := 0
	Private _nCodA211  := 0

	Private _cKey1     := ''

	_oProcess:SetRegua1(Len(_aTabelas)) //Alimenta a primeira barra de progresso
	_oProcess:IncRegua1("Tabelas RM")

	For _nTab := 1 to Len(_aTabelas)

		_oProcess:IncRegua1("Tabelas RM") 

		_cTab := _aTabelas[_nTab]

		&("U_RM_"+_cTab+"(_oProcess,_cTab,_cPasta)")

	/*
		If _cTab = 'CT1'
			U_RM_CT1(_oProcess,_cTab,_cPasta)
		ElseIf _cTab = 'CT2'
			U_RM_CT2(_oProcess,_cTab,_cPasta)
		ElseIf _cTab = "SA1"
			U_RM_SA1(_oProcess,_cTab,_cPasta)
		ElseIf _cTab = 'SA2'
			U_RM_SA2(_oProcess,_cTab,_cPasta)
		ElseIf _cTab = 'SB1'
			U_RM_SB1(_oProcess,_cTab,_cPasta)
		ElseIf _cTab = 'SA4'
			U_RM_SA4(_oProcess,_cTab,_cPasta)
		ElseIf _cTab = 'CTT'
			U_RM_CTT(_oProcess,_cTab,_cPasta)
		ElseIf _cTab = 'SE4'
			U_RM_SE4(_oProcess,_cTab,_cPasta)
		ElseIf _cTab = 'SA6'
			U_RM_SA6(_oProcess,_cTab,_cPasta)
		ElseIf _cTab = 'SRA'
			U_RM_SRA(_oProcess,_cTab,_cPasta)
		ElseIf _cTab = 'SE1'
			U_RM_SE1(_oProcess,_cTab,_cPasta)
		ElseIf _cTab = 'SE2'
			U_RM_SE2(_oProcess,_cTab,_cPasta)
		ElseIf _cTab = 'SF2'
			U_RM_SF2(_oProcess,_cTab,_cPasta)
		ElseIf _cTab = 'SD2'
			U_RM_SD2(_oProcess,_cTab,_cPasta)
		ElseIf _cTab = 'SF1'
			U_RM_SF1(_oProcess,_cTab,_cPasta)
		ElseIf _cTab = 'DA0'
			U_RM_DA0(_oProcess,_cTab,_cPasta)
		ElseIf _cTab = 'DA1'
			U_RM_DA1(_oProcess,_cTab,_cPasta)
		Endif
		*/
	Next _nTab

Return(Nil)



//Criar Tabela
User Function RMCriarDTC(_cTabela,_cNome)

	Local _aCampos	:= {}
	Local _cArquivo	:= ""
	Local _cIndice	:= ""
	Local _lRet		:= .F.
	Local _cNTab	:= ''

	If ValType(_cNome) = "U"
		_cNTab	:= _cTabela
	Else
		_cNTab	:= _cTabela+_cNome
	Endif

	MakeDir( "\TAB_RM\"+_cPasta )

	_cArquivo	:= "\TAB_RM\"+_cPasta+"\"+_cNTab+".dtc"	//Gera o nome do arquivo
	_cIndice	:= "\TAB_RM\"+_cPasta+"\"+_cNTab		//Indice do arquivo

	If !File(_cArquivo)

		SX3->(dbSetOrder(1))
		If SX3->(MsSeek(_cTabela))

			While SX3->(!EOF()) .And. SX3->X3_ARQUIVO = _cTabela

				aAdd(_aCampos,{Alltrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

				SX3->(dbSkip())
			EndDo

			If _cTabela = "CT1"
				aAdd(_aCampos,{"CT1_YID","N",10,0})
			ElseIf _cTabela = "CT2"
				aAdd(_aCampos,{"CT2_YID","N",10,0})
			ElseIf _cTabela = "SA1"
				aAdd(_aCampos,{"A1_YCODRM","C",25,0})
				aAdd(_aCampos,{"A1_YID","N",10,0})
			ElseIf _cTabela = "SA2"
				aAdd(_aCampos,{"A2_YCODRM","C",25,0})
				aAdd(_aCampos,{"A2_YID","N",10,0})
			ElseIf _cTabela = "SB1"
				aAdd(_aCampos,{"B1_YID","N",10,0})
				aAdd(_aCampos,{"B1_YVENDAS","C",1,0})
			ElseIf _cTabela = "SA4"
				aAdd(_aCampos,{"A4_YCODRM","C",5,0})
			ElseIf _cTabela = "CTT"
				aAdd(_aCampos,{"CTT_YID","N",10,0})
				// ElseIf _cTabela = "SA6"
				// 	aAdd(_aCampos,{"A6_YID","N",10,0})
			ElseIf _cTabela = "SE1"
				aAdd(_aCampos,{"E1_YCODRM","C",25,0})
				aAdd(_aCampos,{"E1_YDOCRM","C",40,0})
				aAdd(_aCampos,{"E1_YID","N",10,0})
			ElseIf _cTabela = "SE2"
				aAdd(_aCampos,{"E2_YCODRM","C",25,0})
				aAdd(_aCampos,{"E2_YDOCRM","C",40,0})
				aAdd(_aCampos,{"E2_YID","N",10,0})
			ElseIf _cTabela = "SF2"
				aAdd(_aCampos,{"F2_YID","N",10,0})
			ElseIf _cTabela = "SD2"
				aAdd(_aCampos,{"D2_YID","N",10,0})
			ElseIf _cTabela = "DA0"
				aAdd(_aCampos,{"DA0_YID","N",10,0})
			ElseIf _cTabela = "DA1"
				aAdd(_aCampos,{"DA1_YID","N",10,0})
			ElseIf _cTabela = "SA3"
				aAdd(_aCampos,{"A3_YID","N",10,0})
			Endif

			If SELECT("TRM") > 0
				TRM->(dbCloseArea())
			Endif

			//Criar o arquivo Ctree
			dbCreate(_cArquivo,_aCampos,"CTREECDX")
			dbUseArea(.T.,"CTREECDX",_cArquivo,"TRM",.F.,.F.)

			If _cTabela $ "SA1|SA2"
				IndRegua( "TRM", _cIndice,  (_cTabela)->( IndexKey( 3 ) ))
			Else
				IndRegua( "TRM", _cIndice,  (_cTabela)->( IndexKey( 1 ) ))
			Endif

			dbClearIndex()
			dbSetIndex(_cIndice + OrdBagExt() )

			_lRet := .T.

		Endif
	Else
		MsgAlert("Não foi possível criar o arquivo "+_cArquivo)
	Endif

Return(_lRet)



Static Function GetEmp()

	Local _cQryEmp	:= ''
	Local _cEmp		:= ''
	Local _cFil		:= ''
	Local _cCNPJ	:= ''
	Local _aRet		:= {}
	Local _AreaSM0	:= Nil
	Local _lOk		:= .F.

	If Select("TEMP") > 0
		TEMP->(dbCloseArea())
	Endif

	_cQryEmp := " SELECT * FROM DADOSRM..GFILIAL " + CRLF
	_cQryEmp += " WHERE RTRIM(CODCOLIGADA)+RTRIM(CODFILIAL) IN ('91','93','101','103','104','111','113')  " + CRLF

	TcQuery _cQryEmp New Alias "TEMP"

	TEMP->(dbGoTop())

	While TEMP->(!EOF())

		_cCNPJ := Alltrim(TEMP->CGC)
		_cCNPJ := STRTRAN(_cCNPJ,".","")
		_cCNPJ := STRTRAN(_cCNPJ,"/","")
		_cCNPJ := STRTRAN(_cCNPJ,"-","")

		_cEmp := PadL(Alltrim(cValToChar(TEMP->CODCOLIGADA)),2,"0")
		_cFil := PadL(Alltrim(cValToChar(TEMP->CODFILIAL)),2,"0")

		_AreaSM0:= SM0->(GetArea())

		SM0->(dbGoTop())
		_lOk := .F.

		While SM0->(!Eof()) .And. !_lOk

			If Alltrim(SM0->M0_CGC) = _cCNPJ
				AADD(_aRet,{_cCNPJ,_cEmp,_cFil,Alltrim(SM0->M0_CODIGO),Alltrim(SM0->M0_CODFIL),Alltrim(TEMP->NOMEFANTASIA)})
				_lOk := .T.
			Endif

			SM0->(dbSkip())
		EndDo

		RestArea(_AreaSM0)

		TEMP->(dbSkip())
	EndDo

	TEMP->(dbCloseArea())

Return(_aRet)



User Function RM_NoAcento(cString)

	Local cChar  := ""
	Local nX     := 0
	Local nY     := 0
	Local cVogal := "aeiouAEIOU"
	Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
	Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
	Local cTrema := "äëïöü"+"ÄËÏÖÜ"
	Local cCrase := "àèìòù"+"ÀÈÌÒÙ"
	Local cTio   := "ãõÃÕ"
	Local cCecid := "çÇ"
	Local cMaior := "&lt;"
	Local cMenor := "&gt;"

	For nX:= 1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
			nY:= At(cChar,cAgudo)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCircu)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTrema)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCrase)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTio)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
			EndIf
			nY:= At(cChar,cCecid)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("cC",nY,1))
			EndIf
		Endif
	Next

	If cMaior$ cString
		cString := strTran( cString, cMaior, "" )
	EndIf
	If cMenor$ cString
		cString := strTran( cString, cMenor, "" )
	EndIf

	cString := StrTran( cString, CRLF, " " )

Return cString





/*
//gravar na tabela
Static Function GravarDTC(cCodigo)

	//Verifico se o alias está aberto e fecho
	If ( SELECT("REV") ) > 0
		dbSelectArea("REV")
		REV->(dbCloseArea())
	EndIf

	//abro a tabela
	dbUseArea( .T.,"CTREECDX", cArquivo,"REV", .T., .F. )
	dbSelectArea("REV")
	IndRegua( "REV", cIndice, "REV_FILIAL + REV_COD",,,"CODIGO" )
	dbClearIndex()
	dbSetIndex(cIndice + OrdBagExt() )

	dbSelectArea("REV")
	REV->(dbSetOrder(1))
	REV->(dbGoTop())
	If( REV->(!dbSeek('01' + cCodigo)) )
		if RecLock("REV",.T.)
			REV->REV_FILIAL  := '01'
			REV->REV_COD     := cCodigo
			REV->REV_DATA    := dDatabase
			REV->REV_CONTA   := 1
			MsUnLock("REV")
			MsgInfo("Registro Inserido","Sucesso")
		Else
			MsgStop("Ocorreu um erro","Erro")
		endif
	Else
		if RecLock("REV",.F.)
			REV->REV_DATA    := dDatabase
			REV->REV_CONTA   := 2
			MsUnLock("REV")
			MsgInfo("Registro Alterado","Sucesso")
		Else
			MsgStop("Ocorreu um erro","Erro")
		endif
	Endif
Return

*/