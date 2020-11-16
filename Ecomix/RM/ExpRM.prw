#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa TOPOR02
Autor 		: Fabiano da Silva	-	25/03/20
Descrição 	: Exportar tabelas RM
*/

USER FUNCTION EXPRM()

	Local _oDlg			:= NIL
	Local _nOpc			:= 0

	Private _cTitulo	:= "Exportar tabelas do RM"
	Private _oProcess	:= Nil

	Private _cProc		:= 'Processando'
	Private _cMsgTit	:= 'Aguarde, gerando dados...'
	Private _cPasta		:= dtos(dDataBase)+'_'+StrTran(Time(),":","")

	Private _oFont11N	:= TFont():New('Arial'	,,-11,,.T.,,,,,.F.,.F.)

	Private _cChave		:= ''

	Private _aTabImp	:= {}

	Private _aEmp      := {}

	DEFINE MSDIALOG _oDlg FROM 0,0 TO 120,320 TITLE _cTitulo OF _oDlg PIXEL

	_oGrupo	:= TGroup():New(005,005,035,155,"",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 010,015 SAY _oTSayA VAR "Esta rotina tem por objetivo exportar as tabelas  "	OF _oGrupo PIXEL Size 150,010 FONT _oFont11N
	@ 020,015 SAY 'do Banco de Dados "DADOSRM" '		    						OF _oGrupo PIXEL Size 150,010 FONT _oFont11N

	TButton():New( 40,068, "OK" ,_oDlg,{||_nOpc := 1,_oDlg:End()},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )

	TButton():New( 40,120, "Sair" ,_oDlg,{||_nOpc := 0,_oDlg:End()},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )


	ACTIVATE MSDIALOG _oDlg CENTERED

	If _nOpc = 1
		_aRetTab := GetTable()

		If !Empty(_aRetTab)
			_oProcess := MsNewProcess():New( { || EXPDADOS(_aRetTab) } , _cMsgTit, _cProc , .F. )
			_oProcess:Activate()

			If MsgYesNo("Finalizado o processo de Exportação das tabelas do banco de dados DADOSRM. Deseja importar agora as tabelas exportadas?")

				// _aTabImp := {'SA1020','SA1030'}

				// U_IMPRM(_aTabImp)
			Endif
		Else
			MsgInfo("Não foi marcado nenhuma tabela para Importação.")
		Endif
	Endif

Return(Nil)



Static Function GetTable()

	Local cTitulo 	:='Tabelas'
	Local a
	Local b

	Local MvParDef 	:= ""
	Local oWnd
	Local _aTabelas 	:= {;
		{'CT1','Plano de Contas'		},;
		{'CT2','Lançamentos Contábeis'	},;
		{'SA1','Cliente'				},;
		{'SA2','Fornecedor'				},;
		{'SB1','Produto'				},;
		{'CTT','Centro de Custo'		},;
		{'SA6','Bancos'					},;
		{'SE1','Contas a Receber'		},;
		{'SE2','Contas a Pagar'			},;
		{'SF2','Cabeçalho NF Saída'		},;
		{'SD2','Itens NF de Saída'		},;
		{'SA4','Transportadora'			},;
		{'DA0','Cabeçalho Tab. Preço'	},;
		{'DA1','Itens Tab. Preço'		}}//'SE4','SRA,'SF1'

	Local l1Elem		:= .F.

	Local _aRetTb 		:= {}

	Private _aRet		:= {}

	GetEmp()

	oWnd := GetWndDefault()

	_cRet:= Space(Len(_aTabelas)*3)

	For a := 1 to Len(_aTabelas)

		Aadd(_aRet,_aTabelas[a][2])

		MvParDef += _aTabelas[a][1]

	Next a

	f_Opcoes(@_cRet,cTitulo,_aRet,MvParDef,12,49,l1Elem,3,Len(_aTabelas))  // Chama funcao f_Opcoes

	For b := 1 to Len(_cRet) Step 3
		If Substr(_cRet,b,1) <> '*'
			AAdd(_aRetTb,Substr(_cRet,b,3))
		Endif
	Next b

Return(_aRetTb)



Static Function EXPDADOS(_aTabelas)

	// Local _aTabelas    := {'SA3'}
	// Local _aTabelas := {'CT1','CT2','SA1','SA2','SB1','CTT','SA6','SE1','SE2','SF2','SD2','SA4','DA0','DA1'}//'SE4','SRA,'SF1'
	Local _nTab        := 0
	Local _cTab        := ''
	Local _cBDados	   := "[10.140.1.5].[CorporeRM].dbo"

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

		&("U_RM_"+_cTab+"E(_oProcess,_cTab,_cPasta,_cBDados)")

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
		_cNTab	:= _cTabela+"010"
	Else
		_cCodEmp := PadL(_cNome,2,"0")
		_cCodEmp := _aEmp[aScan(_aEmp,{|x| x[1] = _cCodEmp})][2]
		_cNTab	 := _cTabela+_cCodEmp+"0"
	Endif

	MakeDir( "\TAB_RM\"+_cPasta )

	_cArquivo	:= "\TAB_RM\"+_cPasta+"\"+_cNTab+".dtc"	//Gera o nome do arquivo
	_cIndice	:= "\TAB_RM\"+_cPasta+"\"+_cNTab		//Indice do arquivo

	If !File(_cArquivo)

		If Right(_cNTab,3) <> '000'
			AAdd(_aTabImp,_cNTab)
		Endif

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

	Local n
	
	_aEmp	:= {{'09','01'},;
		{'10','02'},;
		{'11','03'},;
		{'00','00'}}

	// Local _aRet	:= {{'0901','0101'},;
		// 				{'0903','0103'},;
		// 				{'1001','0201'},;
		// 				{'1003','0203'},;
		// 				{'1004','0204'},;
		// 				{'1101','0301'},;
		// 				{'1103','0303'}}

/*
EMP_OLD		FILIAL_OLD		M0_CODIGO	M0_CODFIL
09			01				01			01
09			03				01			03
10			01				02			01
10			03				02			03
10			04				02			04
11			01				03			01
11			03				03			03
*/

	// For n := 1 to Len(_aEmp)
	// 	U_RMCriarDTC("ZF6",_aEmp[n][1])

	// 	_cArq	:= "\TAB_RM\"+_cPasta+"\ZF6"+_aEmp[n][2]+"0.dtc"		//Gera o nome do arquivo
	// 	_cInd	:= "\TAB_RM\"+_cPasta+"\ZF6"+_aEmp[n][2]+"0"			//Indice do arquivo
	// 	_cTabZ  := "ZF6"+_aEmp[n][2]

	// 	TRM->(dbCloseArea())

	// 	dbUseArea( .T.,"CTREECDX", _cArq,_cTabZ, .T., .F. )
	// 	dbSelectArea(_cTabZ)

	// 	IndRegua( _cTabZ, _cInd, ZF6->( IndexKey( 1 )))

	// 	dbClearIndex()
	// 	dbSetIndex(_cInd + OrdBagExt() )
	// Next n

Return()



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
