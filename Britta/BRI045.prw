#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BRI045   º Autor ³ Alexandro          º Data ³  13/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para regravar a tabela ZZD                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Geracao do arquivo ZZD - EXPORTA PARA BI                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BRI045(_lSched)

	If _lSched == NIL
		Private _lSched := .F.
	Else
		Private _lSched := .T.
	Endif

//Private _lSched := .T.  // ALEXANDRO

	Private cTipo

	CONOUT("ATUALIZANDO ZZD --> BRI045 - DATA: "+TIME())

	Private dPartir := dDtAte := Ctod("  /  /  ")

	If !_lSched

		ATUSX1()

		_nOpc := 0

		@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Atualizacao da Tabela de Vendas")
		@ 02,10 TO 080,220
		@ 10,18 SAY "Rotina Para Atualizacao da Planilha de Vendas.      "     SIZE 160,7
		@ 18,18 SAY "                                                    "     SIZE 160,7
		@ 26,18 SAY "                                                    "     SIZE 160,7
		@ 34,18 SAY "                                                    "     SIZE 160,7

		@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("BRI045")
		@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
		@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

		ACTIVATE DIALOG oDlg Centered

		If _nOpc == 1
			FREGZZD()
			//U_BROWSEZZD()
		Endif
	Else
		_dDtIni := FirstDay(Date()-5)
		_dDtFim := LastDay(Date()-1)
		BRI45_01(_lSched)
	Endif

Return



Static Function FRegZZD()

	_lEnd   := .f.
	LjMsgRun(OemToAnsi("Aguarde, Regravando ZZD..."),("Atencao"),{| _lEnd | fGeraTRB() } )

Return



Static Function fGeraTRB()

	Local cFonteZZD:=''

	Pergunte("BRI045",.f.)

//Close(oDlg1)

	Private _cFilial := Space(02)
	Private cDoc     := Space(06)
	Private cSerie   := Space(03)
	Private cCliente := Space(06)
	Private cLoja    := Space(02)
	Private _cProduto:= Space(15)
	Private aSelFil	 := {}

	If MV_PAR03 == 1
		If Empty(aSelFil)
			If FindFunction("AdmSelecFil")
				AdmSelecFil("BRI045",03,.F.,@aSelFil,"ZZD",.F.)
			Else
				aSelFil := AdmGetFil(.F.,.F.,"ZZD")
				If Empty(aSelFil)
					Aadd(aSelFil,cFilAnt)
				Endif
			Endif
		Endif
	Endif

	If !Empty(aSelFil)// .And. MV_PAR13 == 1
		If len(aSelFil) > 1
			nI := 1
			If ascan(aSelFil, cFilAnt) != 0 .and. aSelFil[nI] !=  cFilAnt
				aSelFil[ascan(aSelFil, cFilAnt)] := aSelFil[nI]
				aSelFil[nI] := cFilAnt
			EndIf
		EndIf
	EndIf

	cQuery := "  DELETE "
	cQuery += "  FROM "+RetSqlName("ZZD")+" "
	cQuery += "  WHERE ZZD_CODEMP    = '"+cEmpAnt+"'"
	cQuery += "  AND ZZD_SERIE  BETWEEN '   '      AND 'ZZZ'
	cQuery += "  AND ZZD_DOC    BETWEEN '      '   AND 'ZZZZZZ'
	cQuery += "  AND ZZD_EMIS   BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
	cQuery += "  AND ZZD_CODFIL " + BRI45FIL()

	MemoWrite("\cfglog\BRI045A.txt",cQuery)

	TCSQLExec(cQuery)

	cQry := " "
	cQry := " SELECT * "
	cQry += " FROM "+RetSqlName("SF2")+" A "
	cQry += " INNER JOIN "+ RetSqlName("SD2")+ " B ON F2_FILIAL = D2_FILIAL  "
	cQry += " AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND F2_TIPO = D2_TIPO "
	cQry += " WHERE A.D_E_L_E_T_ =  '' AND B.D_E_L_E_T_ =  ''"
	cQry += " AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
//cQry += " AND F2_DOC = '000026810' "
	cQry += " AND F2_FILIAL " + BRI45FIL()
	cQry += " ORDER BY F2_FILIAL,F2_EMISSAO,F2_SERIE,F2_DOC "

	MemoWrite("\CFGLOG\BRI045B.TXT",cqry)

	TcQuery cQry New Alias "QRYSF2"

	TCSETFIELD("QRYSF2","D2_EMISSAO","D")
	TCSETFIELD("QRYSF2","F2_EMISSAO","D")

	_cFilBkp := cFilAnt

	cTipo := "SF2"

	While !QRYSF2->(Eof())

		cFilAnt  := QRYSF2->F2_FILIAL
		_cFilial := QRYSF2->F2_FILIAL
		cDoc     := QRYSF2->F2_DOC
		cSerie   := QRYSF2->F2_SERIE
		cCliente := QRYSF2->F2_CLIENTE
		cLoja    := QRYSF2->F2_LOJA
		_cProduto:= QRYSF2->D2_COD

		If cDoc == "000035932"
			_lParar := .T.
		Endif

		U_BRI049(_cfilial,cDoc,cSERIE,cCliente,cLoja,_cProduto)

		QRYSF2->(dbSkip())
	Enddo

	dbCloseArea("QRYSF2")


	cQry := ""
	cQry += " SELECT * "
	cQry += " FROM "+RetSqlName("SD1")+" "
	cQry += " WHERE D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	cQry += " AND D1_FILIAL " + BRI45FIL()
	cQry += " AND D_E_L_E_T_ =  ' ' AND D1_TIPO = 'D' "
	cQry += " ORDER BY D1_DTDIGIT,D1_SERIE,D1_DOC "

MemoWrite("\CFGLOG\BRI045D.TXT",cqry)

	TCQUERY cQry NEW ALIAS "ZZ"

	TCSETFIELD("ZZ","D1_EMISSAO","D")
	TCSETFIELD("ZZ","D1_DTDIGIT","D")

	ZZ->(dbGotop())

	cTipo := "SF1"

	While !ZZ->(Eof())

		cFilAnt  := ZZ->D1_FILIAL
		_cFilial := ZZ->D1_FILIAL

		cDoc     := ZZ->D1_DOC
		cSerie   := ZZ->D1_SERIE
		cCliente := ZZ->D1_FORNECE
		cLoja    := ZZ->D1_LOJA

		If cDoc == "000136593"
			_lParar := .T.
		Endif

		U_BRI049(_cfilial,cDoc,cSERIE,cCliente,cLoja,_cProduto)

		dbSelectArea("ZZ")

		ZZ->(dbSkip())
	Enddo

	ZZ->(dbCloseArea())


	If Alltrim(cEmpAnt)+Alltrim(cFilAnt) $ '1306|1307'
		cQry := " "
		cQry := " SELECT * "
		cQry += " FROM "+RetSqlName("SC5")+" A "
		cQry += " INNER JOIN "+ RetSqlName("SC6")+ " B ON C5_FILIAL = C6_FILIAL  "
		cQry += " AND C5_NUM = C6_NUM"
		cQry += " WHERE A.D_E_L_E_T_ =  '' AND B.D_E_L_E_T_ =  ''"
		cQry += " AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
//cQry += " AND F2_DOC = '000026810' "
		cQry += " AND C5_FILIAL " + BRI45FIL()
		cQry += " AND C5_CLIENTE = '000276' "
		cQry += " ORDER BY C5_FILIAL,C5_EMISSAO,C5_NUM "

		MemoWrite("\CFGLOG\BRI045C.TXT",cqry)

		TcQuery cQry New Alias "QRYSC5"

		TCSETFIELD("QRYSC5","C5_EMISSAO","D")

		_cFilBkp := cFilAnt

		cTipo := "SC5"

		QRYSC5->(dbGoTop())

		While !QRYSC5->(Eof())

			cFilAnt  := QRYSC5->C5_FILIAL
			_cFilial := QRYSC5->C6_FILIAL
			cDoc     := QRYSC5->C5_NUM
			cSerie   := 'ROM'
			cCliente := QRYSC5->C5_CLIENTE
			cLoja    := QRYSC5->C5_LOJACLI
			_cProduto:= QRYSC5->C6_PRODUTO

			U_BRI049(_cfilial,cDoc,cSERIE,cCliente,cLoja,_cProduto)

			QRYSC5->(dbSkip())
		Enddo

		dbCloseArea("QRYSC5")

	Endif

	cFilAnt := _cFilBkp

Return



User Function BrowseZZD

	Private cCadastro:= "Tabela do Exporta - ZZD"
	Private aRotina  := {{"Pesquisar","AxPesqui",0,1},;
		{"Visualizar","AxVisual",0,2},;
		{"Incluir","AxInclui",0,3},;
		{"Alterar","AxAltera",0,4},;
		{"Excluir","AxDeleta",0,5}}

	Private cDelFunc := ".t."

	dbSelectArea("ZZD")
	dbSetOrder(1)

	MBrowse(6,1,22,75,"ZZD")

Return



Static Function BRI45FIL()

	Local cRetornoIn := ""
	Local nFor := 0

	For nFor := 1 To Len(aSelFil)
		cRetornoIn += aSelFil[nFor] + '|'
	Next nFor

Return " IN " + FormatIn( SubStr( cRetornoIn , 1 , Len( cRetornoIn ) -1 ) , '|' )



Static Function BRI45_01(_lSch)

	LOCAL AX
	Private dPartir   := dDtAte := Ctod("  /  /  ")
	Private cRevisao  := Space(4)
	Private cFonteZZD := ''
	Private cDoc      := Space(06)
	Private cSerie    := Space(03)
	Private cCliente  := Space(06)
	Private cLoja     := Space(02)

//CONOUT("ATUALIZANDO ZZD --> BRI045 - DATA: "+STR(TIME()))

	If Select("SX2") == 0
		RpcSetType(3)
		RpcSetEnv("01","01",,,"COM",GetEnvServer(),{"ZZD"})
	EndIf

	_aEmpresa := {"02","04","09","13","16","50"}

	_aFiliais := {}

	For AX:= 1 To Len(_aEmpresa)

		_cEmpresa := _aEmpresa[AX]

		SM0->(dbSetOrder(1))
		If SM0->(dbSeek(_cEmpresa))

			_cChavSM0 := SM0->M0_CODIGO

			While SM0->(!Eof()) .And. _cChavSM0 == SM0->M0_CODIGO

				If !_lSch
					If SM0->M0_CODIGO + SM0->M0_CODFIL < MV_PAR03 + MV_PAR05 .Or. SM0->M0_CODIGO  + SM0->M0_CODFIL > MV_PAR04 + MV_PAR06
						SM0->(dbSkip())
						Loop
					Endif
				Endif

				AADD( _aFiliais,{_cEmpresa,SM0->M0_CODFIL})

				SM0->(dbSkip())
			EndDo
		Endif
	Next AX

	For AX:= 1 To Len(_aFiliais)

		CONOUT("ATUALIZANDO ZZD DA EMPRESA "+_aFiliais[AX][1]+" Filial: "+_aFiliais[AX][2])

		U_BRI45_02(_aFiliais[AX][1],_aFiliais[AX][2])

		CONOUT("ATUALIZADO  ZZD DA EMPRESA "+_aFiliais[AX][1]+" Filial: "+_aFiliais[AX][2])

	Next AX

//oApp := _oAppBkp

Return



User Function BRI45_02(_cEmpresa,_cFilial)

	If _cEmpresa != cEmpAnt .Or. _cFilial != cFilAnt

		If Select('SM0')>0
			nRecno := SM0->(Recno())
			RpcClearEnv()
		Endif

		OpenSm0()

		SM0->(DbGoTop())

		If SM0->(dbSeek(_cEmpresa + _cFilial , .F. ) )
			RpcSetType(3)
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)

			CONOUT("EMPRESA, "+SM0->M0_CODIGO+SM0->M0_CODFIL)
		Else
			CONOUT("NAO ACHOU EMPRESA "+_cEmpresa)
			SM0->(DBGOTOP())
			DBCLOSEALL()
			RpcClearEnv()
		Endif

		CONOUT("ATUALIZANDO ZZD, EMPRESA: "+cEmpAnt+" DATA: "+DtoS(dDataBase)+" HORA : "+Time())
	Endif

	cQuery := "DELETE "
	cQuery += "FROM "+RetSqlName("ZZD")+" WHERE ZZD_EMIS BETWEEN '"+Dtos(_dDtIni)+"' AND '"+Dtos(_dDtFim)+"' AND ZZD_CODEMP = '"+_cEmpresa+"' AND ZZD_CODFIL = '"+_cFilial+"' "

	TCSQLEXEC(cQuery)
/*
cQry := " SELECT * "
cQry += " FROM "+RetSqlName("SF2")+" AS A, "+ RetSqlName("SD2")+" AS B"
cQry += " WHERE A.D_E_L_E_T_ =  '' AND B.D_E_L_E_T_ =  ''"
cQry += " AND F2_FILIAL   =  D2_FILIAL  "
cQry += " AND F2_DOC      =  D2_DOC     "
cQry += " AND F2_SERIE    =  D2_SERIE   "
cQry += " AND F2_CLIENTE  =  D2_CLIENTE "
cQry += " AND F2_LOJA     =  D2_LOJA    "
cQry += " AND F2_EMISSAO BETWEEN '"+Dtos(_dDtIni)+"' AND '"+Dtos(_dDtFim)+"' "
cQry += " ORDER BY F2_EMISSAO,F2_SERIE,F2_DOC "
*/
	cQry := " SELECT * "
	cQry += " FROM "+RetSqlName("SF2")+" A "
	cQry += " INNER JOIN "+ RetSqlName("SD2")+ " B ON F2_FILIAL = D2_FILIAL  "
	cQry += " AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND F2_TIPO = D2_TIPO "
	cQry += " WHERE A.D_E_L_E_T_ =  '' AND B.D_E_L_E_T_ =  ''"
	cQry += " AND F2_EMISSAO BETWEEN '"+Dtos(_dDtIni)+"' AND '"+Dtos(_dDtFim)+"' "
	cQry += " AND F2_FILIAL = '"+_cFilial+"' "
	cQry += " ORDER BY F2_FILIAL,F2_EMISSAO,F2_SERIE,F2_DOC "

	MemoWrite("\CFGLOG\BRI045B.TXT",cqry)

	TcQuery cQry New Alias "QRYSF2"

	TCSETFIELD("QRYSF2","D2_EMISSAO","D")
	TCSETFIELD("QRYSF2","F2_EMISSAO","D")

	cTipo := "SF2"

	QRYSF2->(dbGotop())

//ProcRegua(QRYSF2->(U_CONTREG()))

	While !QRYSF2->(Eof())

		_cFilial := QRYSF2->F2_FILIAL
		cDoc     := QRYSF2->F2_DOC
		cSerie   := QRYSF2->F2_SERIE
		cCliente := QRYSF2->F2_CLIENTE
		cLoja    := QRYSF2->F2_LOJA
		_cProduto:= QRYSF2->D2_COD

		U_BRI049(_cfilial,cDoc,cSERIE,cCliente,cLoja,_cProduto)

		QRYSF2->(dbSkip())
	Enddo

	If Select("QRYSF2") > 0
		QRYSF2->(dbCloseArea())
	Endif
	cQry := ""
	cQry += " SELECT * "
	cQry += " FROM "+RetSqlName("SD1")+" "
	cQry += " WHERE D1_DTDIGIT BETWEEN '"+Dtos(_dDtIni)+"' AND '"+Dtos(_dDtFim)+"' "
//cQry += " AND D1_FILIAL " + BRI45FIL() 
	cQry += " AND D1_FILIAL = '"+_cFilial+"' "
	cQry += " AND D_E_L_E_T_ =  ' ' AND D1_TIPO = 'D' "
	cQry += " ORDER BY D1_DTDIGIT,D1_SERIE,D1_DOC "

	MemoWrite("\CFGLOG\BRI045C.TXT",cqry)

	TCQUERY cQry NEW ALIAS "ZZ"

	TCSETFIELD("ZZ","D1_EMISSAO","D")
	TCSETFIELD("ZZ","D1_DTDIGIT","D")

	ZZ->(dbGotop())

	cTipo := "SF1"

	While !ZZ->(Eof())

		cFilAnt  := ZZ->D1_FILIAL
		_cFilial := ZZ->D1_FILIAL

		cDoc     := ZZ->D1_DOC
		cSerie   := ZZ->D1_SERIE
		cCliente := ZZ->D1_FORNECE
		cLoja    := ZZ->D1_LOJA

		U_BRI049(_cfilial,cDoc,cSERIE,cCliente,cLoja,_cProduto)

		dbSelectArea("ZZ")

		ZZ->(dbSkip())
	Enddo

	ZZ->(dbCloseArea())

//cFilAnt := _cFilBkp


	If Alltrim(cEmpAnt)+Alltrim(cFilAnt) $ '1306|1307'
		cQry := " "
		cQry := " SELECT * "
		cQry += " FROM "+RetSqlName("SC5")+" A "
		cQry += " INNER JOIN "+ RetSqlName("SC6")+ " B ON C5_FILIAL = C6_FILIAL  "
		cQry += " AND C5_NUM = C6_NUM"
		cQry += " WHERE A.D_E_L_E_T_ =  '' AND B.D_E_L_E_T_ =  ''"
		cQry += " AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
//cQry += " AND F2_DOC = '000026810' "
		cQry += " AND C5_FILIAL " + BRI45FIL()
		cQry += " AND C5_CLIENTE = '000276' "
		cQry += " ORDER BY C5_FILIAL,C5_EMISSAO,C5_NUM "

		MemoWrite("\CFGLOG\BRI045C.TXT",cqry)

		TcQuery cQry New Alias "QRYSC5"

		TCSETFIELD("QRYSC5","C5_EMISSAO","D")

		_cFilBkp := cFilAnt

		cTipo := "SC5"

		QRYSC5->(dbGoTop())

		While !QRYSC5->(Eof())

			cFilAnt  := QRYSC5->C5_FILIAL
			_cFilial := QRYSC5->C6_FILIAL
			cDoc     := QRYSC5->C5_NUM
			cSerie   := 'ROM'
			cCliente := QRYSC5->C5_CLIENTE
			cLoja    := QRYSC5->C5_LOJACLI
			_cProduto:= QRYSC5->C6_PRODUTO

			U_BRI049(_cfilial,cDoc,cSERIE,cCliente,cLoja,_cProduto)

			QRYSC5->(dbSkip())
		Enddo

		dbCloseArea("QRYSC5")

	Endif




	If _cEmpresa != cEmpAnt .And. _cFilial != cFilAnt
		If Select("SX2") > 0
			CONOUT("Fechando Ambiente")
			RpcClearEnv()
		Endif
	Endif

Return


Static Function AtuSX1()

	cPerg := "BRI045"
	aRegs := {}

//    	   Grupo/Ordem/Pergunta                /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01           /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(cPerg,"01","Data   De              ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"02","Data   Ate             ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"03","Seleciona Filiais?      ",""       ,""      ,"mv_ch3","N" ,01     ,0      ,0     ,"C",""            ,"MV_PAR03","Sim"            ,""     ,""     ,""   ,""   ,"Nao"            ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")

Return (Nil)
