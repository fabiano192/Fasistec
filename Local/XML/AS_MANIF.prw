#INCLUDE "PROTHEUS.CH"
#INCLUDE "SPEDNFE.CH"

/*/{Protheus.doc} SPEDMANIFE
Fun��o principal

@author Natalia Sartori
@since 04.07.2012
@version 1.00
/*/

#Define NF_OK 1
#Define NF_NOK 2
#Define NF_SEM_FORNECEDOR 3

#Define SEM_PRODUTO 0
#Define SEM_PEDIDO 1
#Define PEDIDO_DIVERGENTE 2
#Define PEDIDO_OK 3
#Define SEM_NF_ORIGINAL 4

Static cVersaoTSS := IIf( UsaColaboracao("4"), "", StrTran(getVersaoTSS(),".","" ))

User Function AS_MANIF()

	Local aArea			:= GetArea()
	Local lRetorno		:= .T.
	Local nVezes		:= 0

	//	If SA5->(Fieldpos("A5_YTES")) = 0
	//		ShowHelpDlg("XML_TES", {'Campo "A5_YTES" n�o existe na Base de Dados!'},2,{'Solicite a cria��o do mesmo.'},2)
	//		Return(Nil)
	//	Endif

	Private lBtnFiltro	:= .F.
	Private lUsacolab	:= .F.
	Private _lVldFil	:= SuperGetMv('AS_VLDFIL',,.T.)


	While lRetorno

		lBtnFiltro	:= .F.
		lRetorno	:= FiltroManif(nVezes==0)

		nVezes++

		If !lBtnFiltro
			Exit
		EndIf

	EndDo

	U_AS_GetXML(2)

	RestArea(aArea)

Return Nil



/*/{Protheus.doc} FiltroManif
Fun��o de montagem das perguntas e condi��o para efetuar o filtro

@author Natalia Sartori
@since 04.07.2012
@version 1.00
/*/
Static Function FiltroManif(lInit,cAlias)

	Local lOk		:= .F.
	Local aPerg		:={}
	Local aStatus	:={}
	Local aMes		:={}
	Local aFiltro	:= {}
	Local aParam	:={"","","","","","","","",""}

	Local cMes		:= ""
	Local cFilMani	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"FILTMANIFEST"

	Local lEvento	:= .F.
	Local lEntAtiva	:= .T.
	Local lPeFil	:= ExistBlock("MDeFil")
	Local aPeFil	:= {}

	Local nCombo7	:= 0
	Local nCombo9	:= 0
	Local nMiliseg:= 4000

	Private _lSinAut	:= SuperGetMv('AS_XMLSIC',,.T.)

	Private aRotina		:= {}
	Private aFilBrw		:= {}

	Private cCadastro	:= "Manifesta��o do Destinat�rio"
	Private cMarca		:= GetMark()
	Private cCondicao   := ""
	Private cCondQry    := ""

	Private bFiltraBrw

	aRotina := MarkBr()


	aadd(aStatus,"0 - "+STR0414)//"Sem manifesta��o"
	aadd(aStatus,"1 - "+STR0415)//"Confirmada"
	aadd(aStatus,"2 - "+STR0416)//"Desconhecida"
	aadd(aStatus,"3 - "+STR0417)//"N�o realizada"
	aadd(aStatus,"4 - "+STR0418)//"Ci�ncia"
	aadd(aStatus,"5 - Todas")
	aadd(aStatus,"6 - Em processamento")

	aadd(aMes,"1 - Janeiro")
	aadd(aMes,"2 - Fevereiro")
	aadd(aMes,"3 - Mar�o")
	aadd(aMes,"4 - Abril")
	aadd(aMes,"5 - Maio")
	aadd(aMes,"6 - Junho")
	aadd(aMes,"7 - Julho")
	aadd(aMes,"8 - Agosto")
	aadd(aMes,"9 - Setembro")
	aadd(aMes,"10 - Outubro")
	aadd(aMes,"11 - Novembro")
	aadd(aMes,"12 - Dezembro")
	aadd(aMes,"             ")

	SX2->(DBSETORDER(1))
	If SX2->(DBSEEK("C00"))

		MV_PAR01 := aParam[01] := PadR(ParamLoad(cFilMani,aPerg,1,aParam[01]),Len(C00->C00_CNPJEM))
		MV_PAR02 := aParam[02] := PadR(ParamLoad(cFilMani,aPerg,2,aParam[02]),Len(C00->C00_CNPJEM))
		MV_PAR03 := aParam[03] := PadR(ParamLoad(cFilMani,aPerg,3,aParam[03]),Len(C00->C00_SERNFE))
		MV_PAR04 := aParam[04] := PadR(ParamLoad(cFilMani,aPerg,4,aParam[04]),Len(C00->C00_SERNFE))
		MV_PAR05 := aParam[05] := PadR(ParamLoad(cFilMani,aPerg,5,aParam[05]),Len(C00->C00_NUMNFE))
		MV_PAR06 := aParam[06] := PadR(ParamLoad(cFilMani,aPerg,6,aParam[06]),Len(C00->C00_NUMNFE))
		MV_PAR07 := aParam[07] := PadR(ParamLoad(cFilMani,aPerg,7,aParam[07]),13)
		MV_PAR08 := aParam[08] := PadR(ParamLoad(cFilMani,aPerg,8,aParam[08]),Len(C00->C00_ANONFE))
		MV_PAR09 := aParam[09] := PadR(ParamLoad(cFilMani,aPerg,9,aParam[09]),36)
		nCombo7	 := Iif(aScan(aMes,{|x| x == AllTrim(aParam[07])}) > 0,aScan(aMes,{|x| x == Alltrim(aParam[07]) }),13)
		nCombo9	 := Iif(aScan(aStatus,{|x| x == Alltrim(aParam[09]) }) > 0,aScan(aStatus,{|x| x == AllTrim(aParam[09]) }),6)

		aadd(aPerg,{1,STR0423,aParam[01],'@R 99.999.999/9999-99',"ValidAPerg('Cnpj')",,'Empty(MV_PAR02)',55,.F.})//"Cnpj"
		aadd(aPerg,{1,STR0424,aParam[02],'@R 999.999.999-99',"ValidAPerg('Cpf')",,'Empty(MV_PAR01)',55,.F.})//"Cpf"
		aadd(aPerg,{1,STR0229,aParam[03],,,,,30,.F.})//"Serie de"
		aadd(aPerg,{1,STR0230,aParam[04],,,,,30,.F.})//"Serie At�"
		aadd(aPerg,{1,STR0227,aParam[05],,,,,55,.F.})//"Nota de"
		aadd(aPerg,{1,STR0228,aParam[06],,,,,55,.F.})//"Nota Ate"
		aadd(aPerg,{2,STR0425,aParam[07],aMes,105,".T.",.F.,".T."}) //M�s
		aadd(aPerg,{1,STR0426,aParam[08],,"ValidAPerg('Ano')",,,55,.F.})//"Ano"
		aadd(aPerg,{2,STR0427,aParam[09],aStatus,105,".T.",.F.,".T."})//Status

		//Verifica se o servi�o foi configurado - Somente o Adm pode configurar
		If lInit
			If (!ReadyTss() .Or. !ReadyTss(,2))
				If PswAdmin( /*cUser*/, /*cPsw*/,RetCodUsr()) == 0
					SpedNFeCFG()
				Else
					HelProg(,"FISTRFNFe")
				EndIf
			EndIf
			lEntAtiva := EntAtivTss()
		EndIf
		If lEntAtiva .And. (!lInit .Or. ReadyTSS())

			cCondicao := "C00_FILIAL=='"+xFilial("C00")+"' "

			If lPeFil
				aPeFil :=  ExecBlock("MDeFil",.F.,.F.)
				cCondicao += aPeFil[1]
				cCondQry += aPeFil[2]
				lOk := .T.

			ElseIf ParamBox(aPerg,"Filtro",aParam,,,.T.,,,,cFilMani,.T.,.T.)

				aFilBrw  := MontaFiltro()
				cCondicao += aFilBrw[1]
				cCondQry  += aFilBrw[2]
				lOk := .T.

			EndIf

			If lOk
				execMarkbrowse()
			EndIf
		Else
			HelProg(,"FISTRFNFe")
		EndIf
	Else
		Aviso("Manifesto","Execute o compatibilizador NFEP11R1 (Id. NFE11R122) para o Manifesto do destinat�rio" ,{STR0114},3)
	EndIf

Return




Static function execMarkbrowse()

	Local aIndArq	:={}
	Local aCores	:={}
	Local aCampos	:={}


	If _lSinAut
		LjMsgRun( "Sincronizando com SEFAZ, aguarde...", "Gestor XML", {|| SincDados(.F.,.F.) } )
	Endif

	aCores := {	;
		{"C00_YSTATU = 'FI'",'S4WB016N_.PNG'},;
		{"C00_STATUS = '1' .and. alltrim(C00_SITDOC)=='3'",'BR_PINK'},;
		{"C00_STATUS $ '1' .and. alltrim(C00_CODEVE)=='3' .and. Empty(C00_YSTATU)" ,'BR_LARANJA'},;
		{"C00_STATUS=='1' .and. alltrim(C00_CODEVE)=='3'",'ENABLE'},;
		{"C00_STATUS=='2' .and. alltrim(C00_CODEVE)=='3'",'BR_CINZA'},;
		{"C00_STATUS=='3' .and. alltrim(C00_CODEVE)=='3'",'DISABLE'},;
		{"C00_STATUS=='4' .and. alltrim(C00_CODEVE)=='3'",'BR_AZUL'},;
		{"C00_STATUS=='0'",'BR_BRANCO'},;
		{"C00_STATUS $ '1234' .and. alltrim(C00_CODEVE)=='2'",'BR_AMARELO'}}

	//	aFilBrw		:=	{'C00',cCondicao}
	//	bFiltraBrw := {|| FilBrowse("C00",@aIndArq,@cCondicao) }
	//	Eval(bFiltraBrw)

	AADD(aCampos,{"C00_OK","",""})
	AADD(aCampos,{"C00_CHVNFE","","Chave da NFe"})
	AADD(aCampos,{"C00_SERNFE","","Serie"})
	AADD(aCampos,{"C00_NUMNFE","","Numero"})
	AADD(aCampos,{"C00_VLDOC","","Valor Nfe","@E 99,999,999,999.99"})
	AADD(aCampos,{{||RetSitDoc(C00_SITDOC)},"","Sit.Nfe"})
	AADD(aCampos,{{||RetSitEve(C00_CODEVE)},"","Sit.Evento"})

	cMarkDlg := GetMark(,"C00","C00_OK")
	MarkBrow("C00","C00_OK",,aCampos,.F.,cMarkDlg,'MDeMarkAll()',,,,,,"C00_FILIAL = '"+xFilial("C00")+"' " + cCondQry,,aCores)

	/*Restaura a integridade da rotina*/
	RetIndex("C00")
	dbClearFilter()
	aEval(aIndArq,{|x| Ferase(x[1]+OrdBagExt())})

Return



Static function MontaFiltro()

	local cCondicao	:= ""
	local cCondQry	:= ""

	local aMes			:= {}
	local aStatus		:= {}


	aadd(aMes,"1 - Janeiro")
	aadd(aMes,"2 - Fevereiro")
	aadd(aMes,"3 - Mar�o")
	aadd(aMes,"4 - Abril")
	aadd(aMes,"5 - Maio")
	aadd(aMes,"6 - Junho")
	aadd(aMes,"7 - Julho")
	aadd(aMes,"8 - Agosto")
	aadd(aMes,"9 - Setembro")
	aadd(aMes,"10 - Outubro")
	aadd(aMes,"11 - Novembro")
	aadd(aMes,"12 - Dezembro")
	aadd(aMes,"             ")

	aadd(aStatus,"0 - "+STR0414)//"Sem manifesta��o"
	aadd(aStatus,"1 - "+STR0415)//"Confirmada"
	aadd(aStatus,"2 - "+STR0416)//"Desconhecida"
	aadd(aStatus,"3 - "+STR0417)//"N�o realizada"
	aadd(aStatus,"4 - "+STR0418)//"Ci�ncia"
	aadd(aStatus,"5 - Todas")
	aadd(aStatus,"6 - Em processamento")

	If ValType(MV_PAR07) == "N"
		MV_PAR07 := aMes[MV_PAR07]
	EndIf

	If ValType(MV_PAR09) == "N"
		MV_PAR09 := aStatus[MV_PAR09]
	EndIf

	If !Empty(MV_PAR01) //"Cnpj"
		cCondicao+=".and. C00_CNPJEM == '"+MV_PAR01+"' "
		cCondQry += "and C00_CNPJEM	= '"+MV_PAR01+"' "
	EndIF

	If !Empty(MV_PAR02) //"Cpf"
		cCondicao+=".and. C00_CNPJEM == '"+MV_PAR02+"' "
		cCondQry += "and C00_CNPJEM	= '"+MV_PAR02+"' "
	EndIF

	If !Empty(MV_PAR03) //"Serie de"
		cCondicao+=".and. C00_SERNFE	>= '"+MV_PAR03+"' "
		cCondQry +="and C00_SERNFE	>= '"+MV_PAR03+"' "
	EndIF
	If !Empty(MV_PAR04) //"Serie at�"
		cCondicao+=".and. C00_SERNFE	<= '"+MV_PAR04+"' "
		cCondQry +="and C00_SERNFE	<= '"+MV_PAR04+"' "
	EndIF
	If !Empty(MV_PAR05) //"Nota de"
		cCondicao+=".and. C00_NUMNFE	>= '"+MV_PAR05+"' "
		cCondQry +="and C00_NUMNFE	>= '"+MV_PAR05+"' "
	EndIF
	If !Empty(MV_PAR06) //"Nota at�"
		cCondicao+=".and. C00_NUMNFE	<= '"+MV_PAR06+"' "
		cCondQry +="and C00_NUMNFE	<= '"+MV_PAR06+"' "
	EndIF
	If !Empty(MV_PAR07)//M�s
		cMes:= Strzero(Val(SubStr(MV_PAR07,1,2)),2)
		cCondicao+=".and. C00_MESNFE	== '"+cMes+"' "
		cCondQry +="and C00_MESNFE	= '"+cMes+"' "
	Endif

	If !Empty(MV_PAR08) //"Ano"
		cCondicao+=".and. C00_ANONFE	== '"+MV_PAR08+"' "
		cCondQry +="and C00_ANONFE	= '"+MV_PAR08+"' "
	EndIF

	If !Empty(MV_PAR09) .and. SubStr(MV_PAR09,1,1) <> '5'  //"Status"

		if SubStr(MV_PAR09,1,1) == '6'
			cCondicao	+= ".and. alltrim(C00_CODEVE) == '2' "
			cCondQry += "and LTRIM(RTRIM(C00_CODEVE)) = '2' "
		else
			cCondicao += ".and. C00_STATUS == '"+SubStr(MV_PAR09,1,1)+"' "
			cCondQry +="and C00_STATUS = '"+SubStr(MV_PAR09,1,1)+"' "
		endif

	EndIf

	cCondicao	+= ".and. C00_YSTATU <> 'OK' "
	cCondQry	+= "and C00_YSTATU <> 'OK' "

Return({cCondicao,cCondQry})



	/*/{Protheus.doc} MarkBr()
	Utilizacao de menu Funcional

	@author Natalia Sartori
	@since 04.07.2012
	@version 1.00

	@param	aRotina		1. Nome a aparecer no cabecalho
	2. Nome da Rotina associada
	3. Reservado
	4. Tipo de Transa��o a ser efetuada:
	1 - Pesquisa e Posiciona em um Banco de Dados
	2 - Simplesmente Mostra os Campos
	3 - Inclui registros no Bancos de Dados
	4 - Altera o registro corrente
	5 - Remove o registro corrente do Banco de Dados
	5. Nivel de acesso
	6. Habilita Menu Funcional
	@return	aRotina 	Array com opcoes da rotina
	/*/
Static Function MarkBr()

	Private aRotina := {}
	Private cMark := GetMark()

	If _lSinAut
		aRotina   := { { STR0004,			"PesqBrw"		,0,1,0,.F.},; //Pesquisar
		{ STR0431,		"U_ASManif"			,0,2,0,.F.},; //Manifestar
		{ STR0432,		"U_MontaMonitor"	,0,2,0,.F.},; //Monitorar
		{ "Exportar",	"U_ASExporXML(0)"	,0,2,0,.F.},; //Exportar Zip
		{ "Baixar XML",	"U_ASGrava"			,0,3,0,.F.},; //Gravar XML
		{ STR0299,		"U_ASBtLegenda"		,0,3,0,.F.},; //Legenda
		{ "Validar Filial","U_ASVldFilial"		,0,3,0,.F.}}  // Validar Filial
	Else
		aRotina   := { { STR0004,			"PesqBrw"		,0,1,0,.F.},; //Pesquisar
		{ STR0430,		"Sincronizar"		,0,3,0,.F.},; //Sincronizar
		{ STR0431,		"U_ASManif"			,0,2,0,.F.},; //Manifestar
		{ STR0432,		"U_MontaMonitor"	,0,2,0,.F.},; //Monitorar
		{ "Exportar",	"U_ASExporXML(0)"	,0,2,0,.F.},; //Exportar Zip
		{ STR0299,		"U_ASBtLegenda"		,0,3,0,.F.},;  //Legenda
		{ "Baixar XML",	"U_ASGrava"			,0,3,0,.F.},;  //Gravar XML
		{ "Validar Filial","U_ASVldFilial"		,0,3,0,.F.}}  // Validar Filial
	Endif

Return aRotina




User Function ASBtLegenda()

	Local aLegenda:= {}

	AADD(aLegenda, {"S4WB016N_.PNG"	,"Validar Filial"})
	AADD(aLegenda, {"BR_PINK"		,"NF Cancelada"})
	AADD(aLegenda, {"BR_LARANJA"	,"Manifestado(Ciencia ou Confirmado) e sem XML gerado"})
	AADD(aLegenda, {"BR_BRANCO"		,STR0414})//Sem manifesta��o
	AADD(aLegenda, {"ENABLE"		,STR0415})//Confirmada
	AADD(aLegenda, {"BR_CINZA"		,STR0416})//Desconhecida
	AADD(aLegenda, {"DISABLE"		,STR0417})//N�o realizada
	AADD(aLegenda, {"BR_AZUL"		,STR0418})//Ci�ncia
	AADD(aLegenda, {"BR_AMARELO"	,"Manifesta��o em processamento"})

	BrwLegenda(cCadastro,STR0117,aLegenda)

Return




	/*/{Protheus.doc} ReadyTSS()
	Verifica se a conexao com o TSS pode ser estabelecida

	@author Natalia Sartori
	@since 04.07.2012
	@version 1.00
	/*/
Static Function ReadyTSS(cURL,nTipo,lHelp)

Return (CTIsReady(cURL,nTipo,lHelp,.F.))



	/*/{Protheus.doc} SincDados()
	Executa a funcionalidade do menu 'Sincronizar'

	@param	lCheck	Define se ser� realizado a sincronzia��o at� finalizar
	os documentos dispon�veis na SEFAZ.

	@author Natalia Sartori
	@since 04.07.2012
	@version 1.00
	/*/
Static Function SincDados(lProcAll,lRefazSinc)

	Local aChave	:= {}
	Local aDocs		:= {}
	Local aProc		:= {}

	Local cURL		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cIdEnt	:= RetIdEnti()
	Local cChave	:= ""
	Local cCancNSU	:= ""
	Local cAlert	:= ""
	Local cSitConf	:= ""
	Local cCodEvento	:= ""
	Local cAmbiente	:= ""
	Local lContinua	:= .T.

	Local lOk       := .F.

	Local nX		:= 0
	Local nZ		:= 0

	Private oWs		:= Nil

	Default lProcAll := .F.
	Default lRefazSinc	:= .F.

	If ReadyTSS()

		oWs :=WSMANIFESTACAODESTINATARIO():New()
		oWs:cUserToken   := "TOTVS"
		oWs:cIDENT	     := cIdEnt
		oWs:cINDNFE		 := "0"
		oWs:cINDEMI      := "0"
		oWs:_URL         := AllTrim(cURL)+"/MANIFESTACAODESTINATARIO.apw"

		cAmbiente		 := getAmbMde()

		// Refaz a sincroniza��o de todos os documentos disponiveis na SEFAZ
		If lRefazSinc
			oWs:cUltNSU	:= "0"
			oWs:CONFIGURARPARAMETROS()
		Endif

		//Tratamento para solicitar a sincroniza��o enaquanto o IDCONT n�o retornar zero.
		While lContinua

			lOk		:= .F.
			aChave	:= {}
			aProc	:= {}

			If oWs:SINCRONIZARDOCUMENTOS()
				If Type ("oWs:OWSSINCRONIZARDOCUMENTOSRESULT:OWSDOCUMENTOS:OWSSINCDOCUMENTOINFO") <> "U"
					If Type("oWs:OWSSINCRONIZARDOCUMENTOSRESULT:OWSDOCUMENTOS:OWSSINCDOCUMENTOINFO")=="A"
						aDocs := oWs:OWSSINCRONIZARDOCUMENTOSRESULT:OWSDOCUMENTOS:OWSSINCDOCUMENTOINFO
					Else
						aDocs := {oWs:OWSSINCRONIZARDOCUMENTOSRESULT:OWSDOCUMENTOS:OWSSINCDOCUMENTOINFO}
					EndIf

					For nX := 1 To Len(aDocs)
						If Type(aDocs[nX]:CCHAVE) <> "U" .and. Type(aDocs[nX]:CSITCONF) <> "U"
							cSitConf  := aDocs[Nx]:CSITCONF
							cChave    := aDocs[Nx]:CCHAVE
							cCancNSU  := aDocs[Nx]:CCANCNSU
							If Type("aDocs[Nx]:CCODEVENTO") <> "U"
								If ValType(aDocs[Nx]:CCODEVENTO) <> "U"
									cCodEvento:= aDocs[Nx]:CCODEVENTO
								Else
									CodEvento:= ""
								EndIf
							Else
								CodEvento:= ""
							EndIf

							// Caso o doc sincronizado tenha TPEVENTO n�o deve ir pra tabela C00
							If !cCodEvento $ "411500|411501|411502|411503"
								if SincAtuDados(cChave,cSitConf,cCancNSU)
									aadd(aChave, cChave)
									lOk := .T.
								endif
							EndIf
						EndIf
					Next

					If lOk
						For nZ := 1 To Len( aChave )

							AADD( aProc, aChave[nZ] )

							If Len( aProc ) >= 30
								MonitoraManif(aProc,cAmbiente,cIdEnt,cUrl)
								aProc := {}
							Endif

						Next
						If Len( aProc ) > 0
							MonitoraManif(aProc,cAmbiente,cIdEnt,cUrl)
						Endif
					EndIf

					If Type("oWs:OWSSINCRONIZARDOCUMENTOSRESULT:CINDCONT") <> "U"

						If oWs:OWSSINCRONIZARDOCUMENTOSRESULT:CINDCONT == "0"
							lContinua := .F.
						endif
					Else
						lContinua := .F.
					Endif

					If Empty(aDocs) .And. !lContinua .And. !lOk .And. !_lSinAut
						cAlert:= STR0437 //"N�o h� documentos para serem sincronizados"
						Aviso("Sincroniza��o",cAlert,{"OK"},3)
					EndIF

					Sleep(2000)
				EndIf
			Else
				//				Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
				lContinua := .F.
			EndIf
		EndDo
	Else
		Aviso("SPED",STR0021,{STR0114},3) //"Execute o m�dulo de configura��o do servi�o, antes de utilizar esta op��o!!!"
	EndIf

	oWs := Nil
	DelClassIntf()

Return



	/*/{Protheus.doc} Manifest()
	Montagem da Dialog 'Manifestar'

	@author Natalia Sartori
	@since 04.07.2012
	@version 1.00

	@param cAlias, nReg, nOpc, cMarca, lInverte
	/*/
User Function ASManif(cAlias, nReg, nOpc,cMarca, lInverte)

	Local aListBox	:= {}
	Local aItensCb	:= {}
	Local aMontXml	:= {}

	Local cAliasC00	:= GetNextAlias()
	Local cWhere	:= ""
	Local cCNPJEM	:= ""
	Local cRazao	:= ""
	Local cIEemit	:= ""
	Local cDataEmis	:= ""
	Local cDtAut	:= ""
	Local cCbCpo	:= ""
	Local cRetorno	:= ""
	Local cJustific := Space(255)
	Local cTexto	:= ""

	Local nOpcJust	:= 0
	Local nX		:= 0

	Local lContinue := .F.
	Local lEnvOk 	:= .F.
	Local lProc		:= .T.
	Local lMarkAll	:= .T.

	Local oOkx		:= LoadBitmap( GetResources(), "LBOK" )
	Local oNo		:= LoadBitmap( GetResources(), "LBNO" )
	Local oBmpVerm	:= LoadBitmap( GetResources(), "BR_VERMELHO" )
	Local oBmpVerd	:= LoadBitmap( GetResources(), "BR_VERDE" )
	Local oBmpAzul	:= LoadBitmap( GetResources(), "BR_AZUL" )
	Local oBmpBran	:= LoadBitmap( GetResources(), "BR_BRANCO" )
	Local oBmpCinz	:= LoadBitmap( GetResources(), "BR_CINZA" )
	Local oDlg
	Local oTBut1
	Local oTBut2
	Local oListBox
	Local oGrpForm2
	Local oGrpForm1
	Local oGrpForm
	Local oCombo
	Local oSay
	Local oRazao
	Local oCnpjEmi
	Local oCnpjEmi1
	Local oIEEst
	Local oIEEst1
	Local oDtEmis
	Local oDtEmis1
	Local oDtAut
	Local oDtAut1

	If ReadyTss()
		If lInverte
			cWhere+="%C00.C00_FILIAL='"+xFilial("C00")+"' AND C00.C00_OK <>'"+cMarca+"' "+cCondQry+" AND C00.C00_YSTATU <> 'FI'%"
			// cWhere+="%C00.C00_FILIAL='"+xFilial("C00")+"' AND C00.C00_OK <>'"+cMarca+"' "+cCondQry+"%"
		Else
			cWhere+="%C00.C00_FILIAL='"+xFilial("C00")+"' AND C00.C00_OK ='"+cMarca+"'"+cCondQry+" AND C00.C00_YSTATU <> 'FI'%"
			// cWhere+="%C00.C00_FILIAL='"+xFilial("C00")+"' AND C00.C00_OK ='"+cMarca+"'"+cCondQry+"%"
		EndIF

		BeginSql Alias cAliasC00

			SELECT C00_CHVNFE,C00_SERNFE,C00_NUMNFE,C00_VLDOC,C00_CNPJEM,C00_NOEMIT,C00_IEEMIT,C00_DTEMI,C00_DTREC,C00_STATUS,C00_CODEVE,R_E_C_N_O_
			FROM %Table:C00% C00
			WHERE %Exp:cWhere% AND
			C00.%notdel%
		EndSql

		TcSetField(cAliasC00,"C00_DTEMI"  ,"D",008,0)
		TcSetField(cAliasC00,"C00_DTREC" ,"D",008,0)

		While (cAliasC00)->(!Eof())
			aadd(aListBox,{oNo,(cAliasC00)->C00_CHVNFE,(cAliasC00)->C00_SERNFE,(cAliasC00)->C00_NUMNFE,(cAliasC00)->C00_VLDOC,(cAliasC00)->C00_CNPJEM,(cAliasC00)->C00_NOEMIT,(cAliasC00)->C00_IEEMIT,(cAliasC00)->C00_DTEMI,(cAliasC00)->C00_DTREC,.T.,(cAliasC00)->C00_STATUS,(cAliasC00)->C00_CODEVE})
			(cAliasC00)->(dbSkip())
		EndDo

		If Len(aListBox) > 0

			DEFINE MSDIALOG oDlg TITLE "Manifestar" FROM 0,0 TO  540, 700 PIXEL

			DEFINE FONT oFont BOLD

			//======================= ListBox ===========================
			@065,020 LISTBOX oListBox FIELDS HEADER "","","Chave","Serie","Numero","Valor NFe" SIZE 310,115 PIXEL OF oDlg ON dblClick (aListBox[oListBox:nAt,11]:= !aListBox[oListBox:nAt,11])
			oListBox:SetArray( aListBox )
			oListBox:bLine := {||{If(aListBox[oListBox:nAt,11],oOkx,oNo),;
				getColorStat( aListBox[oListBox:nAt,12] ),;
				aListBox[oListBox:nAt,2],;
				aListBox[oListBox:nAt,3],;
				aListBox[oListBox:nAt,4],;
				Transform(aListBox[oListBox:nAt,5],"@E 99,999,999,999.99")}}

			oListBox:bChange := {|| AtuDetalhe(aListBox[oListBox:nAt],@cCNPJEM,@cRazao,@cIEemit,@cDataEmis,@cDtAut),oCnpjEmi1:Refresh(),oRazao:Refresh(),oIEEst1:Refresh(),oDtEmis1:Refresh(),oDtAut1:Refresh()}
			oListBox:bHeaderClick := {|| aEval(aListBox, {|e| e[11] := lMarkAll}),lMarkAll:=!lMarkAll, oListBox:Refresh()}

			//======================= Adicionando dados no Array do Combo ===========================
			aadd(aItensCb,STR0419)//"210200 - Confirma��o da Opera��o"
			aadd(aItensCb,STR0420)//"210210 - Ci�ncia da Opera��o"
			aadd(aItensCb,STR0421)//"210220 - Desconhecimento da Opera��o"
			aadd(aItensCb,STR0422)//"210240 - Opera��o n�o Realizada"

			//======================= Borda ===========================
			@010,010 GROUP oGrpForm2 TO 050,340  OF oDlg PIXEL
			@055,010 GROUP oGrpForm TO 250,340  PROMPT "Dados da Nota" OF oDlg PIXEL
			@185,015 GROUP oGrpForm1 TO 200,335  PROMPT "Legenda" OF oGrpForm PIXEL

			//======================= Combo ===========================
			@035,020 COMBOBOX oCombo VAR cCbCpo ITEMS aItensCb SIZE 120,30 PIXEL OF oDlg

			//======================= Says ===========================
			@015,020 SAY oSay PROMPT STR0438 OF oDlg FONT oFont PIXEL SIZE 290, 030 //"Esta rotina permite que o destinat�rio da NFe se manifeste sobre as notas emitidas para o seu CNPJ.  "
			@025,020 SAY oSay PROMPT STR0439 OF oDlg FONT oFont PIXEL SIZE 290, 030 //"Escolha uma das op��es abaixo para as notas selecionadas: "

			@210,020 SAY oRazao PROMPT "Nome/Razao Social: " OF oDlg FONT oFont PIXEL SIZE 300, 200
			@210,075 SAY oRazao PROMPT cRazao OF oDlg PIXEL SIZE 300, 200

			@220,020 SAY oCnpjEmi PROMPT "Cpf/Cnpj Emitente: " OF oDlg FONT oFont PIXEL SIZE 230, 030
			@220,075 SAY oCnpjEmi1 PROMPT cCNPJEM  OF oDlg PIXEL SIZE 230, 030

			@220,230 SAY oIEEst PROMPT "IE Emitente: " OF oDlg FONT oFont PIXEL SIZE 230, 030
			@220,265 SAY oIEEst1 PROMPT cIEemit OF oDlg PIXEL SIZE 230, 030

			@230,020 SAY oDtEmis PROMPT "Data Emiss�o: " OF oDlg FONT oFont PIXEL SIZE 230, 030
			@230,060 SAY oDtEmis1 PROMPT cDataEmis OF oDlg PIXEL PICTURE "@D" SIZE 230, 030

			@230,230 SAY oDtAut PROMPT "Data Autoriza��o: " OF oDlg FONT oFont PIXEL SIZE 230, 030
			@230,279 SAY oDtAut1 PROMPT cDtAut OF oDlg PIXEL PICTURE "@D" SIZE 230, 030

			//======================= Legendas ===========================
			@ 190,040 BITMAP oBmpVerd RESOURCE "BR_VERDE.PNG" NO BORDER SIZE 017, 017 OF oDlg PIXEL
			@ 190,050 SAY oSay PROMPT STR0415 SIZE 100,010 PIXEL OF oDlg //Confirmada

			@ 190, 095 BITMAP oBmpVerm RESOURCE "BR_VERMELHO.PNG" NO BORDER SIZE 017, 017 OF oDlg PIXEL
			@ 190, 105 SAY oSay PROMPT STR0417 SIZE 100,010 PIXEL OF oDlg //N�o realizada

			@ 190, 155 BITMAP oBmpAzul RESOURCE "BR_AZUL.PNG" NO BORDER SIZE 017, 017 OF oDlg PIXEL
			@ 190, 165 SAY oSay PROMPT STR0418 SIZE 100,010 PIXEL OF oDlg //Ci�ncia

			@ 190, 200 BITMAP oBmpCinz RESOURCE "BR_CINZA.PNG" NO BORDER SIZE 017, 017 OF oDlg PIXEL
			@ 190, 210 SAY oSay PROMPT STR0416 SIZE 100,010 PIXEL OF oDlg //Desconhecida

			@ 190, 256 BITMAP oBmpbran RESOURCE "BR_BRANCO.PNG" NO BORDER SIZE 017, 017 OF oDlg PIXEL
			@ 190, 270 SAY oSay PROMPT STR0414 SIZE 100,010 PIXEL OF oDlg //Sem manifesta��o

			//======================= Buttons ===========================
			oTBut1 := TButton():New( 255, 245, "Manifestar"	,oDlg,{||(lContinue := ValidManif( cCbCpo, @cJustific, aListBox, aMontXml ),if(lContinue,oDlg:End(),(cJustific := "",cJustific := space(255))))},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
			oTBut2 := TButton():New( 255, 290, "Cancelar"	,oDlg,{||(lContinue :=.F.,oDlg:End())},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

			ACTIVATE MSDIALOG oDlg CENTERED

			If lContinue
				MsgRun("Aguarde Manifesta��o","Processando",{|| lEnvOk := MontaXmlManif(cCbCpo,aMontXml,@cRetorno,cJustific)})
			EndIf

			If lEnvOk
				Aviso("Envio Manifesto",cRetorno,{"OK"},3)
				MDeDesMark()
			EndIF
		Else
			Aviso("Envio Manifesto",STR0440,{"OK"},3)//"Selecione uma ou mais chaves pendentes de manifesta��o"
		EndIf

	Else
		Aviso("SPED",STR0021,{STR0114},3) //"Execute o m�dulo de configura��o do servi�o, antes de utilizar esta op��o!!!"
	EndIf

Return



	/*/{Protheus.doc} SincAtuDados()
	Realiza a atualza��o do sincroizar dados.

	@author Rafael Iaquinto
	@since 18.08.2014
	@version 1.00

	@param cChave, string, chave do documento.
	@param cSitConf, string, Situa��o da Manifesta��o do Destinat�rio.
	@param cCancNSU, string, NSU do Cancelamento.
	/*/
Static function SincAtuDados(cChave,cSitConf,cCancNSU)

	Local dData		:= CtoD("  /  /    ")
	Local lOk			:= .F.

	C00->(DbsetOrder(1))
	If !C00->( DbSeek( xFilial("C00") + cChave) )
		RecLock("C00",.T.)
		C00->C00_FILIAL     := xFilial("C00")
		C00->C00_STATUS     := cSitConf
		C00->C00_CHVNFE		:= cChave
		dData := CtoD("01/"+Substr(cChave,5,2)+"/"+Substr(cChave,3,2))
		C00->C00_ANONFE		:= Strzero(Year(dData),4)
		C00->C00_MESNFE		:= Strzero(Month(dData),2)
		C00->C00_SERNFE		:= Substr(cChave,23,3)
		C00->C00_NUMNFE		:= Substr(cChave,26,9)
		C00->C00_CODEVE		:= Iif(cSitConf $ '0',"1","3")
		If !Empty(cCancNSU)
			C00->C00_SITDOC := "3" //nota cancelada
		Else
			C00->C00_SITDOC := "1" //nota autorizada
		EndIf
		lOk := .T.
		C00->C00_YSTATU		:= If(_lVldFil,'FI','')
		C00->(MsUnLock())

		If ExistBlock("MANIGRV")
			ExecBlock("MANIGRV",.F.,.F.,{Substr(cChave,23,3),Substr(cChave,26,9),cChave,cSitConf})
		EndIf
	Else
		If !Empty(cCancNSU)
			C00->(RecLock("C00",.F.))
			C00->C00_SITDOC := "3"
			C00->(MsUnLock())
		EndIf
	EndIf

return (lOk)




	/*/{Protheus.doc} MonAtuDados()
	Realiza a atualiza��o do sincronizar dados.

	@author Rafael Iaquinto
	@since 18.08.2014
	@version 1.00

	@param cChave, string, chave do documento.
	@param cCNPJEmit, string, CNPJ do Emitente.
	@param cIeEmit, string, IE do Emitente
	@param cNomeEmit, string, Nome do Emitente
	@param cSitConf, string, Situa��o da Manifesta��o do Destinat�rio.
	@param cSituacao, string, Situa��o da NF-e.
	@param cDesResp, string, xMotivo do retConsNFeDest.
	@param cDesCod, string, CSTAT do retConsNFeDest.
	@param dDtEmi, date, Data de Emiss�o. DEMI
	@param dDtRec, date, Data de Autoriza��o DHRECBTO
	@param nValDoc, inteiro, Valor total do documento. VNF
	/*/
Static function MonAtuDados(cChave,cCNPJEmit,cIeEmit,cNomeEmit,cSitConf,cSituacao,cDesResp,cDesCod,dDtEmi,dDtRec,nValDoc)

	C00->(DbsetOrder(1))
	If C00->(DbSeek( xFilial("C00") + cChave))
		RecLock("C00",.F.)
		C00->C00_CNPJEM		:= Alltrim(cCNPJEmit)
		C00->C00_IEEMIT		:= AllTrim(cIeEmit)
		C00->C00_NOEMIT		:= Alltrim(cNomeEmit)
		C00->C00_STATUS		:= cSitConf
		C00->C00_SITDOC		:= cSituacao
		C00->C00_DESRES		:= Alltrim(cDesResp)
		C00->C00_CODRET		:= cDesCod
		C00->C00_DTEMI		:= dDtEmi
		C00->C00_DTREC		:= dDtRec
		C00->C00_VLDOC		:= nValDoc
		C00->C00_CODEVE		:= Iif(alltrim(C00->C00_STATUS) $ '0',"1","3")
		C00->(MsUnLock())
	EndIf

Return nil



	/*/{Protheus.doc} AtuBrowse()
	Realiza a atualiza��o da MarkBrowse p�ncipal.

	@author Rafael Iaquinto
	@since 18.08.2014
	@version 1.00

	/*/
Static function AtuBrowse()

	local cMsg := ""

	ColMdeCons(@cMsg)

	if !empty(cMsg)
		Aviso("Manifesto",cMsg ,{STR0114},3)
	endif

return nil



	/*/{Protheus.doc} AtuDetalhe()
	Atualiza os dados dos Says ao trocar a sele��o no ListBox

	@author Natalia Sartori
	@since 04.07.2012
	@version 1.00

	@param 	aList     - Dados da Nota selecionada no ListBox
	cCNPJEM   - Cnpj Emitente
	cRazao    - Razao Social
	cIEemit   - Ie do emitente
	cDataEmis - Data de Emissao da Nota
	cDtAut    - Data de autoriza��o da Nota
	/*/
Static Function AtuDetalhe(aList,cCNPJEM,cRazao,cIEemit,cDataEmis,cDtAut)

	cCNPJEM 	:= 	aList[6]
	cRazao  	:=	aList[7]
	cIEemit 	:=	aList[8]
	cDataEmis	:=	aList[9]
	cDtAut  	:=	aList[10]

Return ()



	/*/{Protheus.doc} MontaXmlManif()
	Monta xml para transmiss�o da manifesta��o

	@author Natalia Sartori
	@since 04.07.2012
	@version 1.00

	@param 	cCbCpo     - Evento Selecionado no listbox
	aMontXml   - Dados da nota que deve ser transmitida
	cRetorno   - Chaves de acesso das notas transmitidas
	cJustific  - Justificativa da Opera��o n�o realizada

	@Return lRetOk	   - Se a transmiss�o foi conclu�da ou n�o
	/*/
Static Function MontaXmlManif(cCbCpo,aMontXml,cRetorno,cJustific)

	Local aRet			:={}

	Local cAmbiente		:= ""
	Local cXml			:= ""
	Local cTpEvento		:= SubStr(cCbCpo,1,6)
	Local cIdEnt		:= RetIdEnti(.F.)
	Local cURL			:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cChavesMsg	:= ""
	Local cMsgManif		:= ""
	Local cIdEven		:= ""
	Local cErro			:= ""
	Local cRetPE		:= ""

	Local aNfe			:= {}

	Local lRetOk		:= .T.
	Local lManiEven		:= ExistBlock("MANIEVEN")
	Local lMata103	:= IIf(FunName()$"MATA103",.T.,.F.)

	Local nX 			:= 0
	Local nZ 			:= 0

	Private oWs			:= Nil

	Default cJustific 	:= ""

	If ReadyTSS()
		oWs :=WSMANIFESTACAODESTINATARIO():New()
		oWs:cUserToken   := "TOTVS"
		oWs:cIDENT	     := cIdEnt
		oWs:cAMBIENTE	 := ""
		oWs:cVERSAO      := ""
		oWs:_URL         := AllTrim(cURL)+"/MANIFESTACAODESTINATARIO.apw"

		If oWs:CONFIGURARPARAMETROS()
			cAmbiente		 := oWs:OWSCONFIGURARPARAMETROSRESULT:CAMBIENTE

			cXml+='<envEvento>'
			cXml+='<eventos>'

			For nX:=1 To Len(aMontXml)
				cXml+='<detEvento>'
				If lManiEven
					cRetPE := ExecBlock("MANIEVEN",.F.,.F.,{cTpEvento,aMontXml[nX][2]})
					If cRetPE <> Nil .And. !Empty(cRetPE)
						cTpEvento := cRetPE
					EndIf
				EndIf
				cXml+='<tpEvento>'+cTpEvento+'</tpEvento>'
				cXml+='<chNFe>'+Alltrim(aMontXml[nX][2])+'</chNFe>'
				cXml+='<ambiente>'+cAmbiente+'</ambiente>'
				If '210240' $ cTpEvento .and. !Empty(cJustific)
					cXml+='<xJust>'+Alltrim(cJustific)+'</xJust>'
				EndIf
				cXml+='</detEvento>'
			Next
			cXml+='</eventos>'
			cXml+='</envEvento>'

			lRetOk:= EnvioManif(cXml,cIdEnt,cUrl,@aRet)

		Else
			Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
		Endif

		If lRetOk .And. Len(aRet) > 0
			For nZ:=1 to Len(aRet)
				aRet[nZ]:= Substr(aRet[nZ],9,44)
				cChavesMsg += aRet[nZ] + Chr(10) + Chr(13)
			Next
			cMsgManif := STR0441+ Chr(10) + Chr(13)//"Transmiss�o da Manifesta��o conclu�da com sucesso!"
			cMsgManif += cCbCpo + Chr(10) + Chr(13)
			cMsgManif += "Chave(s): "+ Chr(10) + Chr(13)
			cMsgManif += cChavesMsg
			IF lMata103
				cMsgManif += Chr(10) + Chr(13)+ "Consulte a rotina de Manifesta��o do Destinat�rio para verificar o resultado!"
			EndIf
			cRetorno := Alltrim(cMsgManif)

		EndIf

		AtuStatus(aRet,cTpEvento)

	Else
		Aviso("SPED",STR0021,{STR0114},3) //"Execute o m�dulo de configura��o do servi�o, antes de utilizar esta op��o!!!"
	EndIf

Return lRetOk



	/*/{Protheus.doc} EnvioManif()
	Envia o xml para transmiss�o da manifesta��o

	@author Natalia Sartori
	@since 04.07.2012
	@version 1.00

	@param 	cXmlReceb  - String com o XML a ser transmitido
	cIdEnt	   - Codigo da Entidade
	cUrl	   - URL
	aRetorno   - Retorno do RemessaEvento

	@Return lRetOk	   - Se a transmiss�o foi conclu�da ou n�o
	/*/
Static Function EnvioManif(cXmlReceb,cIdEnt,cUrl,aRetorno,cModel)

	Local lRetOk		:= .T.

	Default cURL		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Default cIdEnt		:= RetIdEnti(.F.)
	Default aRetorno	:= {}
	Default cModel		:= ""

	If ReadyTSS()

		// Chamada do metodo e envio
		oWs:= WsNFeSBra():New()
		oWs:cUserToken	:= "TOTVS"
		oWs:cID_ENT		:= cIdEnt
		oWs:cXML_LOTE	:= cXmlReceb
		oWS:_URL		:= AllTrim(cURL)+"/NFeSBRA.apw"

		If !Empty(cModel)
			oWS:cModelo := cModel
		EndIf
		//oWs:RemessaEvento()

		If oWs:RemessaEvento()
			If Type("oWS:oWsRemessaEventoResult:cString") <> "U"
				If Type("oWS:oWsRemessaEventoResult:cString") <> "A"
					aRetorno:={oWS:oWsRemessaEventoResult:cString}
				Else
					aRetorno:=oWS:oWsRemessaEventoResult:cString
				EndIf
			EndIf
		Else
			lRetOk := .F.
			Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
		Endif
	Else
		Aviso("SPED",STR0021,{STR0114},3) //"Execute o m�dulo de configura��o do servi�o, antes de utilizar esta op��o!!!"
	EndIf

Return lRetOk



/*/{Protheus.doc} MonitoraManif
Realiza o monitoramento da Manifesta��o ao sincronizar os dados.

@author Natalia Sartori
@since 04.07.2012
@version 1.00

@param		aChave 	  - Array com as chaves de acesso sincronizadas e gravadas
na tabela C00
cAmbiente - Ambiente (1-Produ��o,2-Homologa��o)
cIdEnt    - Codigo da Entidade
cUrl	  - URL

/*/
Static Function MonitoraManif(aChave,cAmbiente,cIdEnt,cUrl,lJob)

	Local cChave		:= ""
	Local cCNPJEmit	:= ""
	Local cIeEmit		:= ""
	Local cNomeEmit	:= ""
	Local cSitConf	:= ""
	Local cSituacao	:= ""
	Local cDesResp	:= ""
	Local cDesCod		:= ""

	Local dDtEmi		:= CTOD("  /  /  ")
	Local dDtRec		:= CTOD("  /  /  ")

	Local nValDoc		:= 0
	Local nZ := 0
	Local nY := 0

	Local aMonDoc	:={}

	Private oWS		:= Nil

	Default lJob	:= .F.

	If ReadyTss()
		oWs :=WSMANIFESTACAODESTINATARIO():New()
		oWs:cUserToken   := "TOTVS"
		oWs:cIDENT	     := cIdEnt
		oWs:cAMBIENTE	 := cAmbiente
		oWs:OWSMONDADOS:OWSDOCUMENTOS  := MANIFESTACAODESTINATARIO_ARRAYOFMONDOCUMENTO():New()
		For nY := 1 to Len(aChave)
			aadd(oWs:OWSMONDADOS:OWSDOCUMENTOS:OWSMONDOCUMENTO,MANIFESTACAODESTINATARIO_MONDOCUMENTO():New())
			oWs:OWSMONDADOS:OWSDOCUMENTOS:OWSMONDOCUMENTO[nY]:CCHAVE := aChave[nY]
		Next
		oWs:_URL	:= AllTrim(cURL)+"/MANIFESTACAODESTINATARIO.apw"

		If oWs:MONITORARDOCUMENTOS()
			If Type ("oWs:OWSMONITORARDOCUMENTOSRESULT:OWSDOCUMENTOS:OWSMONDOCUMENTORET") <> "U"
				If Type ("oWs:OWSMONITORARDOCUMENTOSRESULT:OWSDOCUMENTOS:OWSMONDOCUMENTORET") == "A"
					aMonDoc := oWs:OWSMONITORARDOCUMENTOSRESULT:OWSDOCUMENTOS:OWSMONDOCUMENTORET
				Else
					aMonDoc := {oWs:OWSMONITORARDOCUMENTOSRESULT:OWSDOCUMENTOS:OWSMONDOCUMENTORET}
				EndIf
			EndIF
			For nZ :=1 to Len(aMonDoc)
				If Type(aMonDoc[nZ]:CCHAVE) <> "U"
					cChave := aMonDoc[nZ]:CCHAVE

					cCNPJEmit	:= Iif(!Empty(Alltrim(aMonDoc[nZ]:CEMITENTECNPJ)),Alltrim(aMonDoc[nZ]:CEMITENTECNPJ),Alltrim(aMonDoc[nZ]:CEMITENTECPF))
					cIeEmit		:= AllTrim(aMonDoc[nZ]:CEMITENTEIE)
					cNomeEmit	:= Alltrim(aMonDoc[nZ]:CEMITENTENOME)
					cSitConf	:= aMonDoc[nZ]:CSITUACAOCONFIRMACAO
					cSituacao	:= aMonDoc[nZ]:CSITUACAO
					cDesResp	:= Alltrim(aMonDoc[nZ]:CRESPOSTADESCRICAO)
					cDesCod		:= aMonDoc[nZ]:CRESPOSTASTATUS

					dDtEmi		:= StoD(StrTran(aMonDoc[nZ]:CDATAEMISSAO,"-",""))
					dDtRec		:= StoD(StrTran(aMonDoc[nZ]:CDATAAUTORIZACAO,"-",""))

					nValDoc		:= aMonDoc[nZ]:NVALORTOTAL

					MonAtuDados(cChave,cCNPJEmit,cIeEmit,cNomeEmit,cSitConf,cSituacao,cDesResp,cDesCod,dDtEmi,dDtRec,nValDoc)

				EndIf
			Next
		Else
			If !lJob
				Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
			EndIf
		EndIf
	Else
		If !lJob
			Aviso("SPED",STR0021,{STR0114},3) //"Execute o m�dulo de configura��o do servi�o, antes de utilizar esta op��o!!!"
		EndIf
	EndIf

	oWs := Nil
	DelClassIntf()

Return



	/*/{Protheus.doc} AtuStatus()
	Atualiza o Status da Manifesta��o de acordo com o Tipo de Evento

	@author Natalia Sartori
	@since 04.07.2012
	@version 1.00

	@param 	aRet   	   - Chaves de acesso das notas transmitidas
	cTpEvento  - Tipo do Evento em que a nota foi transmitida
	/*/
Static Function AtuStatus(aRet,cTpEvento)

	Local aAreas	:= {}

	Local cStat		:= "0"
	Local nX		:= 0

	If cTpEvento $ '210200'
		cStat:= "1"  //Confirmada opera��o
	ElseIf cTpEvento $ '210220'
		cStat:= "2"  //Desconhecimento da Opera��o
	ElseIf cTpEvento $ '210240'
		cStat:= "3"  //Opera��o n�o Realizada
	ElseIf cTpEvento $ '210210'
		cStat:= "4"  //Ci�ncia da opera��o
	EndIf


	If Len(aRet) > 0
		aAreas := GetArea()
		For nX:=1 to Len(aRet)
			C00->(DbSetOrder(1))
			If C00->(DBSEEK(xFilial("C00")+aRet[nX]))
				RecLock("C00")
				C00->C00_STATUS := cStat
				C00->C00_CODEVE := "2"
				MsUnlock()

				//				If cStat $ '1|4'
				If cStat $ '1'
					U_ASExporXML(0,C00_CHVNFE,.T.)
				Endif

			EndIf
		Next
		RestArea(aAreas)
	EndIf

Return



	/*/{Protheus.doc} RetSitDoc()
	Retorna a descri��o do tipo da NF para mostrar a descri��o na MarkBrow
	Coluna (Sit.Nfe)

	@author Natalia Sartori
	@since 04.07.2012
	@version 1.00

	@param 	cSitDoc    - Codigo da Situa��o da NF(C00_SITDOC)

	@return cDescSit   - Retorna a descri��o do tipo da Nota

	/*/
Static Function RetSitDoc(cSitDoc)

	Local cDescSit	:= ""

	If !Empty(cSitDoc)
		If Alltrim(cSitDoc) $ "1"
			cDescSit	:= STR0442  //"Uso autorizado da NFe"
		ElseIf Alltrim(cSitDoc) $ "2"
			cDescSit	:= STR0443	//"Uso denegado"
		ElseIf Alltrim(cSitDoc) $ "3"
			cDescSit	:= STR0444	//"NFe cancelada"
		EndIf
	EndIf

Return cDescSit



	/*/{Protheus.doc} RetSitEve()
	Retorna a descri��o do processamento do Evento
	Coluna (Sit.Evento)

	@author Natalia Sartori
	@since 04.07.2012
	@version 1.00

	@param 	cCodEve    - Codigo do Evento(C00_CODEVE)

	@return cDescEve   - Retorna a descri��o do Codigo do evento

	/*/
Static Function RetSitEve(cCodEve)

	Local cDescEve	:= ""

	If !Empty(cCodEve)
		If Alltrim(cCodEve) $ "1"
			cDescEve	:=	STR0445//"Envio de Evento n�o realizado"
		ElseIf Alltrim(cCodEve) $ "2"
			cDescEve	:=	STR0446//"Envio de Evento realizado - Aguardando processamento"
		ElseIf Alltrim(cCodEve) $ "3"
			cDescEve	:=	STR0447//"Evento vinculado com sucesso"
		ElseIf Alltrim(cCodEve) $ "4"
			cDescEve	:=	STR0448//"Evento rejeitado - Verifique o monitor para saber os motivos"
		EndIf
	EndIf

Return cDescEve



	/*/{Protheus.doc} btLegMonit()
	Legenda dos eventos no menu 'Monitorar'

	@author Natalia Sartori
	@since 04.07.2012
	@version 1.00
	/*/
Static Function btLegMonit()

	Local aLegenda:= {}

	AADD(aLegenda, {"ENABLE"		,STR0447})//"Evento vinculado com sucesso"
	AADD(aLegenda, {"DISABLE"		,STR0449})//"Evento n�o vinculado"

	BrwLegenda(cCadastro,STR0117,aLegenda)

Return





	/*/{Protheus.doc} ASExporXML()
	Montagem da Dialog 'Exportar Zip'

	@author Natalia Sartori
	@since 04.07.2012
	@version 1.00

	@param cAlias, nReg, nOpc, cMarca, lInverte
	/*/
User Function ASExporXML(nOpc,_cChave,_lExpAut)

	Local aArea		:= GetArea()
	Local aChaves	:= {}
	Local aXmlRet	:= {}

	Local cWhere	:= ""
	Local cAliasTemp:= GetNextAlias()
	Local cURL		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cIdEnt	:= RetIdEnti(.F.)
	Local cAmbiente	:= ""
	Local cAviso	:= ""
	Local cHelp		:= ""
	Local lParamOk	:= .F.
	Local lRet		:= .F.

	Local nX		:= 0
	Local nY		:= 0
	Local nZ		:= 0
	Local nW		:= 0
	Local nXAux		:= 0
	Local nQtdChv	:= 0

	Local oOk		:= LoadBitMap(GetResources(), "ENABLE")
	Local oNo		:= LoadBitMap(GetResources(), "DISABLE")

	Local _cTitulo := 'Processando'
	Local _cMsgTit	:= 'Aguarde, consultando retorno do SEFAZ...'


	//V�ri�vel que define se vai ser a exporta��o direta ou ir� montar browse para marcar - usado apenas para TOTVS Colabora��o
	Default nOpc		:= 0
	Default _cChave		:= ''
	Default _lExpAut	:= .F.

	Private oRet
	Private aPerg		:= {}
	Private aParam		:= {Space(3),Space(09),Space(09),Space(60),Space(1)}
	Private cPaExpXml	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"BxXml"
	Private _lOk_		:= .F.

	If ReadyTss()
		MV_PAR01 := aParam[01] := PadR(ParamLoad(cPaExpXml,aPerg,1,aParam[01]),Len(C00->C00_SERNFE))
		MV_PAR02 := aParam[02] := PadR(ParamLoad(cPaExpXml,aPerg,2,aParam[02]),Len(C00->C00_NUMNFE))
		MV_PAR03 := aParam[03] := PadR(ParamLoad(cPaExpXml,aPerg,3,aParam[03]),Len(C00->C00_NUMNFE))
		MV_PAR04 := aParam[04] := ParamLoad(cPaExpXml,aPerg,4,aParam[04])
		MV_PAR05 := aParam[05] := ParamLoad(cPaExpXml,aPerg,5,aParam[05])

		If !_lExpAut
			aadd(aPerg,{1,STR0010,aParam[01],"",".T.","",".T.",30,.F.})	//"Serie da Nota Fiscal"
			aadd(aPerg,{1,STR0011,aParam[02],"",,"",".T.",30,.F.})	//"Nota fiscal inicial"
			aadd(aPerg,{1,STR0012,aParam[03],"",,"",".T.",30,.F.}) 	//"Nota fiscal final"

			aadd(aPerg,{6,STR0119,aParam[04],"",".T.","!Empty(mv_par04)",80,.T.," |*.","c:\",GETF_RETDIRECTORY+GETF_LOCALHARD,.F.}) //"Diret�rio de destino"

			If ( Left(LTrim(cVersaoTSS),2) <> "12" .And. Val(cVersaoTSS) < 271 ) .Or. ( Left(LTrim(cVersaoTSS),2) == "12" .And. Val(cVersaoTSS) < 121016 )
				aadd(aPerg,{2,"Exportar arquivos",aParam[05],{"1=Separados","2=Unificados"},50,".T.",.F.}) 	//"Unificado ou Separado"
			Endif

			if nOpc == 0
				MsgInfo(STR0450)//"Ser�o consideradas apenas as notas com status 'Confirmada Opera��o e 'Ci�ncia da Opera��o'"
			endif
			_cBloco := 'ParamBox(aPerg,"Exportar",aParam,,,,,,,cPaExpXml,.T.,.T.)'
		Else

			MV_PAR01 := aParam[01] := Space(Len(C00->C00_SERNFE))
			Mv_PAR02 := aParam[02] := Space(Len(C00->C00_NUMNFE))
			Mv_PAR03 := aParam[03] := Padr('zzz'+Space(Len(C00->C00_NUMNFE)),Len(C00->C00_NUMNFE))
			Mv_PAR04 := aParam[04] := '\XML\'
			//			Mv_PAR04 := aParam[04] := 'd:\fabiano\'
			Mv_PAR05 := aParam[05] := '2'
			_cBloco := '.T.'
		Endif

		If &(_cBloco)

			cWhere += "%"
			cWhere += " C00_FILIAL='"+xFilial("C00")+"'"
			If !_lExpAut
				cWhere += " AND C00_NUMNFE BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "'"
				cWhere += " AND C00_SERNFE = '" + MV_PAR01+ "'"
			Else
				cWhere += " AND C00_CHVNFE = '"+_cChave+"' "
			Endif
			//			cWhere += " AND C00_STATUS IN ('1','4') "
			cWhere += " AND C00_STATUS IN ('1') "
			cWhere += " AND C00_YSTATU <> 'FI' "

			//Ponto de entrada para customizar o filtro dos itens exportados.
			If ExistBlock("MDeExpFil")
				cWhere += ExecBlock("MDeExpFil",.F.,.F.)
			EndIf
			cWhere += "%"

			BeginSql Alias cAliasTemp
				SELECT C00_CHVNFE
				FROM %Table:C00%
				WHERE %Exp:cWhere% AND
				%notdel%
			EndSql

			(cAliasTemp)->(dbGotop())

			If (cAliasTemp)->(Eof())
				Aviso("Baixar ZIP",STR0451,{STR0114},3)//"As notas selecionadas n�o foram localizadas. Verifique os par�metros de busca."
				Return nil
			Else
				While !(cAliasTemp)->(Eof())
					aadd(aChaves,(cAliasTemp)->C00_CHVNFE)
					(cAliasTemp)->(dbSkip())
				End
			EndIf
			(cAliasTemp)->(dbCloseArea())
			RestArea(aArea)

			_lOk_ := .F.

			FWMsgRun(, {|_oMsg| RetManif(_oMsg,aChaves) }, _cTitulo, _cMsgTit )

			If !_lOk_
				MsgInfo("Nota fiscal sem retorno da Manifesta��o junto � SEFAZ!")
				Return(Nil)
			Endif

			oWs :=WSMANIFESTACAODESTINATARIO():New()
			oWs:cUserToken   := "TOTVS"
			oWs:cIDENT	     := cIdEnt
			oWs:cAMBIENTE	 := ""
			oWs:cVERSAO      := ""
			oWs:_URL         := AllTrim(cURL)+"/MANIFESTACAODESTINATARIO.apw"
			oWs:CONFIGURARPARAMETROS()
			cAmbiente		 := oWs:OWSCONFIGURARPARAMETROSRESULT:CAMBIENTE

			oWs:cUserToken   := "TOTVS"
			oWs:cIDENT	     := cIdEnt
			oWs:cAMBIENTE	 := cAmbiente

			oWs:_URL         := AllTrim(cURL)+"/MANIFESTACAODESTINATARIO.apw"

			cAviso := "Arquivos gerados: "+ CRLF + CRLF + "S�rie  N�mero" + CRLF

			While nQtdChv < Len(aChaves)

				oWs:oWSDOCUMENTOS:oWSDOCUMENTO  := MANIFESTACAODESTINATARIO_ARRAYOFBAIXARDOCUMENTO():New()

				If (Len(aChaves) - nQtdChv) < 5

					nXAux := 1
					For nX:= nQtdChv+1 to Len(aChaves)
						aadd(oWs:oWSDOCUMENTOS:oWSDOCUMENTO:oWSBAIXARDOCUMENTO,MANIFESTACAODESTINATARIO_BAIXARDOCUMENTO():New())
						oWs:oWSDOCUMENTOS:oWSDOCUMENTO:oWSBAIXARDOCUMENTO[nXAux]:CCHAVE := aChaves[nX]
						nXAux++
						nQtdChv++
					Next nX
					If oWs:BAIXARXMLDOCUMENTOS()
						If Type ("oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET") <> "U"
							If Type ("oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET") == "A"
								aXmlRet := oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET
							Else
								aXmlRet := {oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET}
							EndIf
						EndIF

						Processa({|| lRet := VerifProces(oRet,aXmlRet,aParam,@cAviso,_lExpAut)},"Processando","Aguarde, exportando arquivos",.T.)

					EndIf
				Else
					For nY:= 1 to 5
						aadd(oWs:oWSDOCUMENTOS:oWSDOCUMENTO:oWSBAIXARDOCUMENTO,MANIFESTACAODESTINATARIO_BAIXARDOCUMENTO():New())
						oWs:oWSDOCUMENTOS:oWSDOCUMENTO:oWSBAIXARDOCUMENTO[nY]:CCHAVE := aChaves[nY+nQtdChv]
					Next nY
					nQtdChv := nQtdChv + 5

					If oWs:BAIXARXMLDOCUMENTOS()

						If Type ("oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET") <> "U"
							If Type ("oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET") == "A"
								aXmlRet := oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET
							Else
								aXmlRet := {oWs:OWSBAIXARXMLDOCUMENTOSRESULT:OWSDOCUMENTORET:OWSBAIXARDOCUMENTORET}
							EndIf
						EndIF
						Processa({|| lRet := VerifProces(oRet,aXmlRet,aParam,@cAviso,_lExpAut)},"Processando","Aguarde, exportando arquivos",.T.)
					EndIf
				EndIf

			EndDo

			If lRet .And. nOpc == 0 .And. !_lExpAut
				Aviso("Baixar ZIP",cAviso,{STR0114},3)
			ElseIf nOpc == 0 .And. !_lExpAut
				cHelp := STR0452//"N�o existem arquivos para serem exportados."
				Aviso("Baixar ZIP",cHelp,{STR0114},3)
			EndIF
		EndIf

	Else
		Aviso("SPED",STR0021,{STR0114},3)	//"Execute o m�dulo de configura��o do servi�o, antes de utilizar esta op��o!!!"
	EndIf

Return(Nil)


/*/{Protheus.doc} getColorStat
Atualiza cor da legenda do listbox no menu 'manifestar'

@author Natalia Sartori
@since 04.07.2012
@version 1.00

@param	cStatus		Status da Manifesta�ao (C00_STATUS)

@return	oClrRet 	Cor da legenda no listbox
/*/
Static function getColorStat( cStatus )

	Local oAzul    := LoadBitmap( GetResources(), "BR_AZUL" )
	Local oBranco  := LoadBitmap( GetResources(), "BR_BRANCO" )
	Local oCinza   := LoadBitmap( GetResources(), "BR_CINZA" )
	Local oVerde   := LoadBitmap( GetResources(), "BR_VERDE" )
	Local oVermelho:= LoadBitmap( GetResources(), "BR_VERMELHO" )
	Local oClrRet

	If ( cStatus == "0" )
		oClrRet := oBranco
	Elseif ( cStatus == "1" )
		oClrRet := oVerde
	Elseif ( cStatus == "2" )
		oClrRet := oCinza
	Elseif ( cStatus == "3" )
		oClrRet := oVermelho
	Elseif ( cStatus == "4" )
		oClrRet := oAzul
	endif

Return oClrRet



/*/{Protheus.doc} ValidManif
Fun��o de valida��o do bot�o Manifestar, para continuar ou n�o o
processamento

@author Natalia Sartori
@since 04.07.2012
@version 1.00

@param	cOpcEve		Op��o da manifesta��o
cJustific   Justificativa do Opera��o n�o realizada
aListBox    Array com todas as notas do listbox
aMontXml    Array com as notas selecionadas no listbox

@return	lContinua	Continua ou n�o o processamento da manifesta��o
/*/
Static Function ValidManif( cOpcEve, cJustific, aListBox, aMontXml, lValid )

	Local aProcessa := {}

	Local lContinua	:= .T.
	Local lCiencia	:= .F.

	Local nOpcJust	:= 2
	Local nX		:= 0
	Local nCount	:= 0

	Default lValid	:= .T.

	If lValid
		For nX:=1 to Len(aListBox)
			If aListBox[nX][11]
				aadd(aMontXml,aListBox[nX])
			else
				nCount++
			EndIf
		Next

		If ( nCount == len(aListBox) )
			msgInfo(STR0453)//"Para manifestar deve ser selecionada ao menos uma nota."
			return .F.
		endif
	EndIf

	//Valida se o manifesto esta pendente
	If lValid
		For nX:=1 to Len(aMontXml)
			If Alltrim(aMontXml[nX][13]) == '2'
				msgInfo(STR0497) //Existe uma ou mais notas com manifesta��o pendente, por favor verificar o monitor.
				return .F.
			Endif
		Next
	EndIf

	If ( cOpcEve $ "210240 - Opera��o n�o Realizada" )

		nOpcJust := Aviso("Manifesto - Justificativa de Op. n�o realizada",@cJustific,{"Confirma","Cancela"},3,,,,.T.)

		cJustific := allTrim(cJustific)

		If( ( nOpcJust == 1 .and. ( len(cJustific) <= 15 .or. empty(cJustific) ) ) )
			msgInfo("A justificativa para "+cOpcEve+" deve ser preenchida com mais de 15 caracteres.")
			lContinua := ValidManif( cOpcEve, @cJustific,aListBox,aMontXml,.F.)
		Elseif ( nOpcJust == 2 )
			lContinua	:= .F.
			aMontXml	:= {}
		Endif

	Elseif ( cOpcEve $ "210210 - Ci�ncia da Opera��o" )

		For nX := 1 to Len(aMontXml)

			If !(Alltrim(aMontXml[nX][12]) == "4" .and. Alltrim(aMontXml[nX][13]) == "3")
				aAdd(aProcessa,aMontXml[nX])
			else
				lCiencia := .T.
			EndIf

		Next

		If ( lCiencia )
			If ( empty(aProcessa) )
				msgInfo("As notas selecionadas j� foram manifestadas com a op��o:"+CRLF+cOpcEve+CRLF+"Selecione outras notas")
				lContinua := .F.
			Else
				If MsgYesNo("Existem notas selecionadas que j� foram manifestadas com a op��o:"+CRLF+cOpcEve+CRLF+CRLF+"Deseja ignor�-las na transmiss�o?"+CRLF+CRLF+;
						"IMPORTANTE"+CRLF+;
						"Ao selecionar a op��o 'N�o', nenhuma manifesta��o ser� transmitida!")

					lContinua := .T.
				Else
					lContinua := .F.
					aMontXml  := {}
				Endif
			Endif
		Endif

		If ( lContinua )
			aMontXml  := aclone(aProcessa)
		Endif

	Endif

Return lContinua




	//-----------------------------------------------------------------------
	/*/{Protheus.doc} VerifProces()

	Fun��o auxiliar para o processamento da exporta��o do arquivo zip

	@author Natalia Sartori
	@since 04.07.2012
	@version 1.00

	@param oRet, aXmlRet, aParam, cAviso

	@return lRet - Se o arquivo foi gerado ou n�o
	/*/
//-----------------------------------------------------------------------
Static Function VerifProces(oRet,aXmlRet,aParam,cAviso,_lExpAut)

	Local nZ 		:= 0
	Local lRet 		:= .F.

	ProcRegua(Len(aXmlRet))

	For nZ:=1 to Len(aXmlRet)
		IncProc()
		oRet := aXmlRet[nZ]
		If GeraArq(aParam,oRet,_lExpAut)
			lRet := .T.
			cAviso += SubStr(oRet:CCHAVE,23,3)+ "    "+SubStr(oRet:CCHAVE,26,9) + CRLF
			_AreaC00 := C00->(GetArea())
			C00->(DbsetOrder(1))
			If C00->( DbSeek( xFilial("C00") + oRet:CCHAVE) )

				RecLock("C00")
				C00->C00_YSTATU := "OK"
				MsUnlock()
			EndIf
			RestArea(_AreaC00)
			Exit
		Endif
	Next nZ


Return(lRet)


	/*/{Protheus.doc} GeraArq()

	Fun��o que exporta os arquivos conforme o retorno do m�todo

	@author Natalia Sartori
	@since 04.07.2012
	@version 1.00

	@param aParam 	- Parametros do parambox
	oRetorno - Retorno do metodo com o resultado da solicita��o

	@return lRet	- Arquivo gerado ou n�o
	/*/
Static Function GeraArq(aParam,oRetorno,_lExpAut)

	Local cDestino		:= ""
	Local cDrive		:= ""
	Local cNfeProt		:= ""
	Local cNfe			:= ""
	Local cNfeProc		:= ""
	Local cChave		:= ""
	Local cNfeProtzi	:= ""
	Local cNfeZip		:= ""
	Local cNfeProcZi	:= ""
	Local cExportar	:= ""

	Local lRet		:= .F.

	Local nHandle	:= 0

	If ( Left(LTrim(cVersaoTSS),2) <> "12" .And. Val(cVersaoTSS) < 271 ) .Or. ( Left(LTrim(cVersaoTSS),2) == "12" .And. Val(cVersaoTSS) < 121016 )
		cExportar := aParam[5]	// 1=Separado ou 2=Unificado
	Endif

	oRet := oRetorno

	SplitPath(aParam[04],@cDrive,@cDestino,"","")
	cDestino := cDrive+cDestino


	If Type ("oRet:CCHAVE") <> "U" .and. !Empty(oRet:CCHAVE)
		cChave	:= oRet:CCHAVE
	EndIf
	If Type ("oRet:CCHVSTATUS") <> "U" .and. (!Empty(oRet:CCHVSTATUS) .and. ('138' $ oRet:CCHVSTATUS .or. '140' $ oRet:CCHVSTATUS .or. '656' $ oRet:CCHVSTATUS))   //140: Download disponibilizado - 656:Consumo indevido (tras dos campos da SPED156)
		If Type ("oRet:CNFEPROTZIP") <> "U" .and. !Empty(oRet:CNFEPROTZIP)
			cNfeProtZi	:= oRet:CNFEPROTZIP
		EndIf
		If Type ("oRet:CNFEZIP") <> "U" .and. !Empty(oRet:CNFEZIP)
			cNfeZip	:= oRet:CNFEZIP
		EndIf
		If Type ("oRet:CNFEPROCZIP") <> "U" .and. !Empty(oRet:CNFEPROCZIP)
			cNfeProcZi	:= oRet:CNFEPROCZIP
		EndIf
	EndIf

	If !Empty(cChave)

		If !Empty(cNfeProcZi)
			cFileUnZip	:= ""
			nLenZip		:= Len( cNfeProcZi )
			cNewFunc 	:= "GzStrDecomp"

			If &cNewFunc.(cNfeProcZi, nLenZip, @cFileUnZip)

				//Gera o Objeto XML
				cError := cError1 := ""
				cWarning  := cWarni1 := ""

				oXml  := XmlParser( cFileUnZip	, "_", @cError, @cWarning )
				//			oXml1 := XmlParser( cNfeProtZi	, "_", @cError1, @cWarni1 )

				If (oXml == NIL ) //.Or. (oXml1 == NIL )
					MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
					Return(.F.)
				Else

					lRet := .T.

					_oNFE			:= oXML:_NFEPROC:_NFE
					_oProtnfe		:= oXML:_NFEPROC:_PROTNFE

					_cTipo := ""
					If _oNFE:_INFNFE:_IDE:_FINNFE:TEXT = "1"
						_cTipo := "N"
					ElseIf _oNFE:_INFNFE:_IDE:_FINNFE:TEXT = "2"
						_cTipo := "C"
					Elseif _oNFE:_INFNFE:_IDE:_FINNFE:TEXT = "4"
						_cTipo := "D"
					Endif

					_cForn := _cLoja := _cNome := ''

					If _cTipo = "D"
						SA1->(dbSetOrder(3))
						If SA1->(msSeek(xFilial("SA1")+_oNFE:_INFNFE:_EMIT:_CNPJ:TEXT))
							_cForn := SA1->A1_COD
							_cLoja := SA1->A1_LOJA
							_cNome := SA1->A1_NOME
						Else
							//							ShowHelpDlg("XML_ZA1", {'Fornecedor n�o encontrado!'},2,{'Cadastre o Fornecedor.'},2)
							//							Return(.F.)
						Endif
					Else
						SA2->(dbSetOrder(3))
						If SA2->(msSeek(xFilial("SA2")+_oNFE:_INFNFE:_EMIT:_CNPJ:TEXT))
							_cForn := SA2->A2_COD
							_cLoja := SA2->A2_LOJA
							_cNome := SA2->A2_NOME
						Else
							//							ShowHelpDlg("XML_ZA1", {'Fornecedor n�o encontrado!'},2,{'Cadastre o Fornecedor.'},2)
							//							Return(.F.)
						Endif
					Endif

					ZA1->(RecLock("ZA1",.T.))
					ZA1->ZA1_FILIAL		:= xFilial("ZA1")
					ZA1->ZA1_CHAVE		:= _OPROTNFE:_INFPROT:_CHNFE:TEXT
					ZA1->ZA1_FORNEC		:= _cForn
					ZA1->ZA1_LOJA		:= _cLoja
					ZA1->ZA1_NOME		:= _cNome
					ZA1->ZA1_SERIE		:= _oNFE:_INFNFE:_IDE:_SERIE:TEXT
					ZA1->ZA1_DOC		:= Padl(Alltrim(_oNFE:_INFNFE:_IDE:_NNF:TEXT),9,"0")
					ZA1->ZA1_EMISSAO	:= Ctod(Substr(_oNFE:_INFNFE:_IDE:_DHEMI:TEXT,9,2)+"/"+Substr(_oNFE:_INFNFE:_IDE:_DHEMI:TEXT,6,2)+"/"+Left(_oNFE:_INFNFE:_IDE:_DHEMI:TEXT,4))
					ZA1->ZA1_XML		:= cFileUnZip
					//				ZA1->ZA1_NOMARQ		:= AllTrim(_aListXML[_nI][1])
					ZA1->ZA1_STATUS		:= If(Empty(_cForn),NF_SEM_FORNECEDOR,NF_NOK)
					ZA1->ZA1_USER		:= UsrRetName(RetCodUsr())
					ZA1->ZA1_TIPO		:= "NFE"
					ZA1->ZA1_DTIMP		:= dDataBase
					ZA1->ZA1_TIPO2		:= _cTipo
					ZA1->ZA1_CNPJ		:= _oNFE:_INFNFE:_EMIT:_CNPJ:TEXT
					ZA1->(MsUnlock())

					IF Type("_oNFE:_INFNFE:_DET") == "A"
						_nFor  := Len(_oNFE:_INFNFE:_DET)
						_InfCh := "_oNFE:_INFNFE:_DET[_cB]"
					Else
						_nFor := 1
						_InfCh := "_oNFE:_INFNFE:_DET"
					Endif

					For _cB := 1 To _nFor

						_cCod := _cTes := ''
						SA5->(dbSetOrder(14))
						If SA5->(msSeek(xFilial("SA5")+_cForn+_cLoja+&(_InfCh):_PROD:_CPROD:TEXT))
							_cCod := SA5->A5_PRODUTO
							_cTes := SA5->A5_YTES
						Endif

						_cPed   := ''
						_cItPed := ''
						IF Type(_InfCh+":_PROD:_XPED:TEXT") != "U"
							_cPed := Padr(&(_InfCh):_PROD:_XPED:TEXT,TAMSX3("C7_NUM")[1])
							IF Type(_InfCh+":_PROD:_ITEMPED:TEXT") != "U"
								_cItPed := Padr(&(_InfCh):_PROD:_ITEMPED:TEXT,TAMSX3("C7_ITEM")[1])
							Endif
							If !Empty(_cItPed)
								SC7->(dbsetOrder(1))
								If !SC7->(msSeek(xFilial("SC7")+_cPed+_cItPed))
									_cPed   := ''
									_cItPed := ''
								Else
									_cCod := SC7->C7_PRODUTO
									_cTes := SC7->C7_TES
								Endif
							Else
								_cPed   := ''
								_cItPed := ''
							Endif
						Endif

						_nBaseICMS	:= _nPercICMS := _nValICMS := 0
						IF Type(_InfCh+":_IMPOSTO:_ICMS:_ICMS00:_VBC") != "U"
							_nBaseICMS	:= Val(&(_InfCh):_IMPOSTO:_ICMS:_ICMS00:_VBC:TEXT)
							_nPercICMS	:= Val(&(_InfCh):_IMPOSTO:_ICMS:_ICMS00:_PICMS:TEXT)
							_nValICMS	:= Val(&(_InfCh):_IMPOSTO:_ICMS:_ICMS00:_VICMS:TEXT)
						Endif

						_nBasIPI	:= _nAlqIPI := _nValIPI := 0
						IF Type(_InfCh+":_IMPOSTO:_IPI:_IPITRIB:_VBC") != "U"
							_nBasIPI  := Val(&(_InfCh):_IMPOSTO:_IPI:_IPITRIB:_VBC:TEXT)
							_nAlqIPI  := Val(&(_InfCh):_IMPOSTO:_IPI:_IPITRIB:_PIPI:TEXT)
							_nValIPI  := Val(&(_InfCh):_IMPOSTO:_IPI:_IPITRIB:_VIPI:TEXT)
						Endif

						_cCFOP := ''
						If !Empty(_cTes)
							SF4->(dbSetOrder(1))
							If SF4->(msSeek(xFilial("SF4")+_cTes))
								If SA1->A1_EST == GetMV("MV_ESTADO") .And. SA1->A1_TIPO # "X"
									_cCFOP := "1" + SubStr(SF4->F4_CF, 2, 3)
								ElseIf SA1->A1_TIPO # "X"
									_cCFOP := "2" + SubStr(SF4->F4_CF, 2, 3)
								Else
									_cCFOP := "3" + SubStr(SF4->F4_CF, 2, 3)
								EndIf
							Endif
						Endif

						ZA2->(RecLock("ZA2",.T.))
						ZA2->ZA2_FILIAL		:= xFilial("ZA2")
						ZA2->ZA2_SERIE		:= _oNFE:_INFNFE:_IDE:_SERIE:TEXT
						ZA2->ZA2_DOC		:= Padl(Alltrim(_oNFE:_INFNFE:_IDE:_NNF:TEXT),9,"0")
						ZA2->ZA2_ITEM		:= PadL(_cB,TamSx3("ZA2_ITEM")[1],'0')
						ZA2->ZA2_FORNEC		:= _cForn
						ZA2->ZA2_LOJA		:= _cLoja
						ZA2->ZA2_COD		:= _cCod
						ZA2->ZA2_PROCLI		:= &(_InfCh):_PROD:_CPROD:TEXT
						ZA2->ZA2_DESPRO		:= &(_InfCh):_PROD:_XPROD:TEXT
						ZA2->ZA2_UM			:= &(_InfCh):_PROD:_UCOM:TEXT
						ZA2->ZA2_QUANT		:= Val(&(_InfCh):_PROD:_QCOM:TEXT)
						ZA2->ZA2_VUNIT		:= Val(&(_InfCh):_PROD:_VUNCOM:TEXT)
						ZA2->ZA2_VTOTAL		:= Val(&(_InfCh):_PROD:_VPROD:TEXT)
						ZA2->ZA2_TES		:= _cTes
						//						ZA2->ZA2_CFOP		:= If(Left(&(_InfCh):_PROD:_CFOP:TEXT,1) = "5","1","2")+Right(&(_InfCh):_PROD:_CFOP:TEXT,3)
						ZA2->ZA2_CFOP		:= _cCFOP
						ZA2->ZA2_PEDIDO		:= _cPed
						ZA2->ZA2_ITEMPC		:= _cItPed
						ZA2->ZA2_BICMS		:= _nBaseICMS
						ZA2->ZA2_PICMS		:= _nPercICMS
						ZA2->ZA2_VICMS		:= _nValICMS
						ZA2->ZA2_BIPI		:= _nBasIPI
						ZA2->ZA2_PIPI		:= _nAlqIPI
						ZA2->ZA2_VIPI		:= _nValIPI
						ZA2->ZA2_STATUS		:= SEM_PRODUTO
						ZA2->(MsUnlock())
					Next _cB
				Endif
			EndIf
		EndIf
	EndIf


Return lRet

	//-----------------------------------------------------------------------
	/*/{Protheus.doc} ValidAPerg()

	Fun��o que valida a m�scara das perguntas do filtro

	@author Natalia Sartori
	@since 04.07.2012
	@version 1.00

	@param cPerg 	- Pergunta do parambox

	@return lRet	- Libera o cursor para o proximo campo
	/*/
//-----------------------------------------------------------------------
Static Function ValidAPerg(cPerg)

	Local lRet := .F.

	If cPerg == "Cnpj"
		If Len(Alltrim(MV_PAR01)) == 14 .or. Empty(MV_PAR01)
			lRet := .T.
		EndIf
	Elseif cPerg == "Cpf"
		If Len(Alltrim(MV_PAR02)) == 11 .or. Empty(MV_PAR02)
			lRet := .T.
		EndIf
	ElseIf cPerg == "Ano"
		If len(Alltrim(MV_PAR08)) == 4 .or. Empty(MV_PAR08)
			lRet := .T.
		EndIf
	EndIf

Return lRet



	//-------------------------------------------------------------------------------------------
	/*/{Protheus.doc} getAmbMde()

	retorna ambiente de configura��o do Md-e

	@param

	@return cAmbiente		Ambiente
	/*/
//-------------------------------------------------------------------------------------------
static function getAmbMde()

	local cAmbiente := ""
	local cURL		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	local oWs

	if readyTSS()
		oWs :=WSMANIFESTACAODESTINATARIO():New()
		oWs:cUserToken   := "TOTVS"
		oWs:cIDENT	     := retIdEnti()
		oWs:cAMBIENTE	 := ""
		oWs:cVERSAO      := ""
		oWs:_URL         := AllTrim(cURL)+"/MANIFESTACAODESTINATARIO.apw"
		oWs:CONFIGURARPARAMETROS()
		cAmbiente		 := oWs:OWSCONFIGURARPARAMETROSRESULT:CAMBIENTE

		freeObj(oWs)
		oWs := nil

	endif

return (cAmbiente)

	//-------------------------------------------------------------------------------------------
	/*/{Protheus.doc} getDescEvento()

	retorna desr��o do evento

	@param	cEvento	codigo do evento

	@return cDesc		descri��o do evento
	/*/
//-------------------------------------------------------------------------------------------
static Function getDescEvento(cEvento)

	local cDesc := ""

	do case
	case cEvento == "210200"
		cDesc := "Confirma��o da Opera��o"
	case cEvento == "210210"
		cDesc := "Ciencia da Opera��o"
	case cEvento == "210220"
		cDesc := "Desconhecimento da Opera��o"
	case cEvento == "210240"
		cDesc := "Opera��o n�o Realizada"
	end Case
return (cDesc)




static function getSitConf(cCodEvento)

	local cSitConf := "0"

	cCodEvento := alltrim(cCodEvento)

	do case
	case cCodEvento == "210200"
		cSitConf := "1"
	case cCodEvento == "210210"
		cSitConf := "4"
	case cCodEvento == "210220"
		cSitConf := "2"
	case cCodEvento == "210240"
		cSitConf := "3"
	endCase

return (cSitConf)




User Function ASGrava(cAlias, nReg, nOpc,cMarca, lInverte)

	Local cAliasC00	:= GetNextAlias()
	Local cWhere	:= ""

	cWhere+="%C00.C00_FILIAL='"+xFilial("C00")+"' AND C00_YSTATU <> 'OK' AND C00_YSTATU <> 'FI' AND C00.C00_OK ='"+cMarca+"'"+cCondQry+"%"
	// cWhere+="%C00.C00_FILIAL='"+xFilial("C00")+"' AND C00_YSTATU <> 'OK' AND C00.C00_OK ='"+cMarca+"'"+cCondQry+"%"

	BeginSql Alias cAliasC00

		SELECT C00_CHVNFE
		FROM %Table:C00% C00
		WHERE %Exp:cWhere% AND
		C00.%notdel%
	EndSql

	While (cAliasC00)->(!Eof())

		LjMsgRun( "Baixando XML("+Alltrim((cAliasC00)->C00_CHVNFE)+"), aguarde...", "Gestor XML", {|| U_ASExporXML(0,(cAliasC00)->C00_CHVNFE,.T.)} )

		(cAliasC00)->(dbSkip())
	EndDo

	(cAliasC00)->(dbCloseArea())

Return(Nil)


//-----------------------------------------------------------------------
/*/{Protheus.doc} MDeDesMark
Desmarca os registros selecionados do markBrow apos manifestacao

@author Jonatas Almeida
@since 04.07.2016
@version 1.00
/*/
//-----------------------------------------------------------------------
Static Function MDeDesMark()
	local cWhere	:= "%C00.C00_FILIAL='"+xFilial("C00")+"' AND C00.C00_OK ='"+cMarkDlg+"' "+cCondQry+"%"
	local cAliasC00	:= getNextAlias()

	BeginSql Alias cAliasC00

		SELECT C00_CHVNFE
		FROM %Table:C00% C00
		WHERE %Exp:cWhere% AND
		C00.%notdel%
	EndSql

	TcSetField(cAliasC00,"C00_DTEMI" ,"D",008,0)
	TcSetField(cAliasC00,"C00_DTREC" ,"D",008,0)

	C00->(dbSetOrder(1))

	while((cAliasC00)->(!Eof()))
		if(C00->(dbSeek(xFilial("C00") + (cAliasC00)->(C00_CHVNFE))))
			recLock("C00",.F.)
			C00->C00_OK := space(TamSX3("C00_OK")[1])
			C00->(msUnLock())
		endIf

		(cAliasC00)->(dbSkip())
	endDo

	(cAliasC00)->(dbCloseArea())

	MarkBRefresh()
return


//-----------------------------------------------------------------------
/*/{Protheus.doc} MDeMarkAll
Marca e desmarca todos os registros do markBrow

@author Jonatas Almeida
@since 04.07.2016
@version 1.00
/*/
//-----------------------------------------------------------------------
Static function MDeMarkAll()

	Local cWhere	:= "%C00.C00_FILIAL='"+xFilial("C00")+"' "+cCondQry+"%"
	Local cAliasC00	:= getNextAlias()

	BeginSql Alias cAliasC00

		SELECT C00_OK, C00_CHVNFE
		FROM %Table:C00% C00
		WHERE %Exp:cWhere% AND
		C00.%notdel%
	EndSql

	TCSetField(cAliasC00,"C00_DTEMI" ,"D",008,0)
	TCSetField(cAliasC00,"C00_DTREC" ,"D",008,0)

	C00->(dbSetOrder(1))

	if((cAliasC00)->(C00_OK) == cMarkDlg)
		while((cAliasC00)->(!Eof()))
			if(C00->(dbSeek(xFilial("C00") + (cAliasC00)->(C00_CHVNFE))))
				recLock("C00",.F.)
				C00->C00_OK := space(TamSX3("C00_OK")[1])
				C00->(msUnLock())
			endIf

			(cAliasC00)->(dbSkip())
		endDo
	else
		while((cAliasC00)->(!Eof()))
			if(C00->(dbSeek(xFilial("C00") + (cAliasC00)->(C00_CHVNFE))))
				recLock("C00",.F.)
				C00->C00_OK := cMarkDlg
				C00->(msUnLock())
			endIf

			(cAliasC00)->(dbSkip())
		endDo
	endIf

	(cAliasC00)->(dbCloseArea())

	MarkBRefresh()

Return



	//-----------------------------------------------------------------------
	/*/{Protheus.doc} MontaMonitor()
	Montagem da Dialog 'Monitorar'

	@author Natalia Sartori
	@since 04.07.2012
	@version 1.00

	@param cAlias, nReg, nOpc, cMarca, lInverte
	/*/
//-----------------------------------------------------------------------
User Function MontaMonitor()

	Local aPerg		:= {}
	Local aChaves	:= {}
	Local aListBox 	:= {}
	Local aListChv	:= {}
	Local aParam	:={Space(3),Space(09),Space(09),Space(01)}
	Local aSize		:= MsAdvSize()
	Local aObjects	:= {}
	Local aInfo		:= {}
	Local aPosObj	:= {}
	Local aArea		:= GetArea()
	Local cParManif := SM0->M0_CODIGO+SM0->M0_CODFIL+"MonitManif"
	Local cEventMon := ""
	Local cWhere	:= ""
	Local cChvIni	:= ""
	Local cChvFin	:= ""
	Local cCodEve	:= ""
	Local nCombo
	Local cChaves	:= ""
	Local nCont := 0

	Local bBloco
	Local oWS
	Local oDlg
	Local oListBox
	Local oBtn1
	Local oBtn2
	Local oBtn3
	Local oBtn4

	Private aCodEve	:= {}

	aadd(aCodEve,STR0419)//"210200 - Confirma��o da Opera��o"
	aadd(aCodEve,STR0420)//"210210 - Ci�ncia da Opera��o"
	aadd(aCodEve,STR0421)//"210220 - Desconhecimento da Opera��o"
	aadd(aCodEve,STR0422)//"210240 - Opera��o n�o Realizada"

	MV_PAR01 := aParam[01] := PadR(ParamLoad(cParManif,aPerg,1,aParam[01]),Len(C00->C00_SERNFE))
	MV_PAR02 := aParam[02] := PadR(ParamLoad(cParManif,aPerg,2,aParam[02]),Len(C00->C00_NUMNFE))
	MV_PAR03 := aParam[03] := PadR(ParamLoad(cParManif,aPerg,3,aParam[03]),Len(C00->C00_NUMNFE))
	MV_PAR04 := aParam[04] := ParamLoad(cParManif,aPerg,4,aParam[04])
	nCombo	:= Iif(aScan(aCodeve,{|x| x == aParam[04] }) > 0,aScan(aCodeve,{|x| x == aParam[04] }),1)

	aadd(aPerg,{1,STR0010,aParam[01],"",".T.","",".T.",30,.F.})	//"Serie da Nota Fiscal"
	aadd(aPerg,{1,STR0011,aParam[02],"",,"",".T.",30,.F.})	//"Nota fiscal inicial"
	aadd(aPerg,{1,STR0012,aParam[03],"",,"",".T.",30,.F.}) 	//"Nota fiscal final"
	aadd(aPerg,{2,"Codigo do Evento",nCombo,aCodEve,115,".T.",.F.,".T."})  //C�digo do Evento

	If ReadyTSS()
		If ParamBox(aPerg,"Monitor Manifesta��o",aParam,,,,,,,cParManif,.T.,.T.)
			aChaves := getChaves(@cCodEve)
			RestArea(aArea)

			If Len(aChaves) > 0
				aListBox := getEventos(cChvIni,cChvFin,cCodEve,aChaves)

				If !Empty(aListBox)
					AAdd( aObjects, { 100, 100, .t., .t. } )
					AAdd( aObjects, { 100, 015, .t., .f. } )
					aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
					aPosObj := MsObjSize( aInfo, aObjects )

					DEFINE FONT oBold BOLD
					DEFINE MSDIALOG oDlg TITLE "Monitoramento da Manifesta��o" From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL
					//607,365
					@aPosObj[1,1],aPosObj[1,2] LISTBOX oListBox 	FIELDS HEADER "","Protocolo","ID","Ambiente","Mensagem" ;
						SIZE aPosObj[1,4]-aPosObj[1,2],aPosObj[1,3]-aPosObj[1,1] PIXEL
					oListBox:SetArray(aListBox)
					oListBox:bLine:={||	{	aListBox[oListBox:nAt][01],;
						Alltrim(aListBox[oListBox:nAt][02]),;
						Alltrim(aListBox[oListBox:nAt][03]),;
						Alltrim(aListBox[oListBox:nAt][04]),;
						Alltrim(aListBox[oListBox:nAt][06])}}

					@ aPosObj[2,1],aPosObj[2,4]-080 BUTTON oBtn1 PROMPT STR0118		ACTION (aChaves := {}, aChaves := getChaves(@cCodEve), aListBox := getEventos(cChvIni,cChvFin,cCodEve,aChaves) ,oListBox:nAt := 1,IIF(Empty(aListBox),oDlg:End(),oListBox:Refresh())) OF oDlg PIXEL SIZE 035,011 //"Refresh"
					@ aPosObj[2,1],aPosObj[2,4]-040 BUTTON oBtn2 PROMPT STR0294		ACTION oDlg:End() OF oDlg PIXEL SIZE 035,011 //Sair
					@ aPosObj[2,1],aPosObj[2,4]-120 BUTTON oBtn3 PROMPT "Legenda"	ACTION btLegMonit() OF oDlg PIXEL SIZE 035,011
					@ aPosObj[2,1],aPosObj[2,4]-160 BUTTON oBtn4 PROMPT "Vis. XML"	ACTION btVisuXml(Alltrim(aListBox[oListBox:nAt][03]),aListBox[oListBox:nAt][07]) OF oDlg PIXEL SIZE 035,011

					ACTIVATE MSDIALOG oDLg CENTERED
				else
					Aviso("SPED",STR0106,{STR0114}) // N�o ha Dados
				EndIf
			else
				Aviso("SPED",STR0106,{STR0114}) // N�o ha Dados
			endif
		EndIf
	Else
		Aviso("SPED",STR0021,{STR0114},3) //"Execute o m�dulo de configura��o do servi�o, antes de utilizar esta op��o!!!"
	EndIf
Return




/*/{Protheus.doc} getChaves
Montagem da Lista de Chaves

@author Jonatas Almeida
@since 13.07.2012
@version 1.00

@param cCodEve
/*/
//-----------------------------------------------------------------------
static function getChaves(cCodEve)
	local aChaves		:= {}
	local cAliasTemp	:= GetNextAlias()

	If ValType(MV_PAR04) == "N"
		MV_PAR04 := aCodEve[MV_PAR04]
	EndIf

	cCodEve	:= SubStr(MV_PAR04,1,6)

	BeginSql Alias cAliasTemp
		SELECT
		C00_CHVNFE AS CHAVE
		FROM
		%Table:C00% C00
		WHERE
		C00.C00_FILIAL = %xFilial:C00% AND
		C00.C00_NUMNFE BETWEEN %exp:MV_PAR02% AND %exp:MV_PAR03% AND
		C00.C00_SERNFE = %exp:MV_PAR01% AND
		C00.%notdel%
	EndSql

	(cAliasTemp)->(dbGotop())

	If (cAliasTemp)->(Eof())
		//msgInfo(STR0398)//"Nenhum registro � monitorar "
		(cAliasTemp)->(dbCloseArea())
		return {}
	EndIf

	While (cAliasTemp)->(!EOF())
		aadd(aChaves, (cAliasTemp)->CHAVE )
		(cAliasTemp)->(DbSkip())
	endDo

	(cAliasTemp)->(dbCloseArea())
return aChaves


//-----------------------------------------------------------------------
/*/{Protheus.doc} getEventos
Montagem da Lista de Eventos - ListBox

@author Jonatas Almeida
@since 13.07.2012
@version 1.00

@param cChvIni, cChvFin, cCodEve, aChaves
/*/
//-----------------------------------------------------------------------
static function getEventos(cChvIni, cChvFin, cCodEve, aChaves)
	local nW		:= 0
	local nY		:= 0
	local cEventMon	:= "MonitEven"
	local aListChv	:= {}
	local aListBox	:= {}
	local cChaves	:= ""
	local nCont		:= 0

	if lUsaColab
		cEventMon	:= "ColEveMonit"
		bBloco		:= "{|| " + cEventMon + "(aChaves, cCodEve) }"
		aListBox	:= Eval(&bBloco)
	else
		cEventMon	:= "MonitEven"
		aListChv	:= {}
		aListBox	:= {}
		cChaves		:= ""
		nCont		:= 0

		For nW := 1 To Len( aChaves )
			++nCont
			cChaves += IIf(!Empty(cChaves),",","") + "'" + aChaves[nW] + "'"

			If nCont >= 50
				aListChv := MonitEven(cChvIni,cChvFin,cCodEve,,cChaves)

				For nY := 1 To Len( aListChv )
					AADD( aListBox, aListChv[nY] )
				Next

				nCont		:= 0
				cChaves		:= ""
				aListChv	:= {}
			Endif
		Next nW

		If nCont > 0
			aListChv := MonitEven(cChvIni,cChvFin,cCodEve,,cChaves)

			For nY := 1 To Len( aListChv )
				AADD( aListBox, aListChv[nY] )
			Next

			cChaves := ""
		Endif
	endif

Return(aListBox)



Static Function MonitEven(cChvIni,cChvFin,cCodEve,cModelo,cChaves)

	Local aListBox		:= {}

	Local oOk			:= LoadBitMap(GetResources(), "ENABLE")
	Local oNo			:= LoadBitMap(GetResources(), "DISABLE")

	Local cURL     		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cOpcUpd		:= ""
	Local cIdEnt		:= RetIdEnti()

	Local nX			:= 0

	Local lOk      		:= .T.

	Private oXmlCCe
	Private oDados
	Private oWS			:= Nil

	Default cModelo 	:= ""
	Default cChaves	:= ""
	If ReadyTss()

		// Executa o metodo NfeRetornaEvento()
		oWS:= WSNFeSBRA():New()
		oWS:cUSERTOKEN	:= "TOTVS"
		oWS:cID_ENT		:= cIdEnt
		oWS:_URL		:= AllTrim(cURL)+"/NFeSBRA.apw"
		oWS:cEVENTO			:= cCodEve
		oWS:cCHVINICIAL		:= cChvIni
		oWS:cCHVFINAL		:= cChvFin
		oWS:cCHAVES		:= cChaves
		lOk:=oWS:NFEMONITORLOTEEVENTO()

		If lOk

			// Tratamento do retorno do evento
			If Type("oWS:oWsNfemonitorLoteEventoResult:OWSNfeMonitorEvento") <> "U"

				If Valtype(oWS:oWsNfemonitorLoteEventoResult:OWSNfeMonitorEvento) <> "A"
					aMonitor := {oWS:oWsNfemonitorLoteEventoResult:OWSNfeMonitorEvento}
				Else
					aMonitor := oWS:oWsNfemonitorLoteEventoResult:OWSNfeMonitorEvento
				EndIF

				For nX:=1 To Len(aMonitor)
					AADD( aListBox, {	If(aMonitor[nX]:nStatus <> 6 .And. aMonitor[nX]:nStatus <> 7 ,oNo,oOk),;
						If(aMonitor[nX]:nProtocolo <> 0 ,Alltrim(Str(aMonitor[nX]:nProtocolo)),""),;
							aMonitor[nX]:cId_Evento,;
							Alltrim(Str(aMonitor[nX]:nAmbiente)),;
							Alltrim(Str(aMonitor[nX]:nStatus)),;
							If(!Empty(aMonitor[nX]:cCMotEven),Alltrim(aMonitor[nX]:cCMotEven),Alltrim(aMonitor[nX]:cMensagem)),;
								"" }) //XML manter devido ao TOTVS Colabora��o.
							//Atualizacao do Status do registro de saida
							cOpcUpd := "3"
							If aListBox[nX][5]	== "3" .Or. aListBox[nX][5] == "5"
								cOpcUpd :=	"4"  //Evento rejeitado +msg rejei�ao
							ElseIf aListBox[nX][5] == "6"
								cOpcUpd := "3"  //Evento vinculado com sucesso
							ElseIf aListBox[nX][5] == "1"
								cOpcUpd := "2"  //Envio de Evento realizado - Aguardando processamento
							EndIF

							cChave:= Substr(aMonitor[nX]:cId_Evento,9,44)

							AtuCodeEve( cChave, cOpcUpd, cCodEve, cModelo, aListBox[nX][4], cIdEnt, cUrl )

						Next

					EndIF

				EndIf

			Else
				Aviso("SPED",STR0021,{STR0114},3)	//"Execute o m�dulo de configura��o do servi�o, antes de utilizar esta op��o!!!"
			EndIf

			Return aListBox



Static Function RetManif(_oMsg,aChaves)

	Local aListChv	:= {}
	Local _nTen_	:= 0
	Local _nList	:= 0

	For _nTen_ := 1 To 10

		_oMsg:cCaption := ('Aguardando retorno da SEFAZ, aguarde... '+Alltrim(Str(_nTen_)))
		ProcessMessages()

		aListChv := MonitEven(aChaves[1],aChaves[1],"210200",,"")
		For _nList := 1 to Len(aListChv)
			If aListChv[_nList][5] $ "6|7"
				_lOk_ := .T. //Vari�vel que define se houve retorno do SEFAZ.
				_nList := Len(aListChv)
				_nTen_ := 10
			Else
				Sleep(3000)
			Endif
		Next _nList

	Next _nTen

Return(Nil)




User Function ASVldFilial()

	Local _oOdlgFil := NIL
	Local _AreaSM0  := SM0->(GetArea())

	Local _cEmp		:= SM0->M0_CODIGO
	Local _cFil		:= SM0->M0_CODFIL

	Local _nOpc		:= 0

	Local _cAlias	:= GetNextAlias()
	Local _cWhere	:= ""

	Local _aRadio := {}
	Local _nRadio := 1

	ZA4->(dbSetOrder(2))
	If ZA4->(MsSeek(xFilial("ZA4")+cFilAnt))

		_cGrp  := ZA4->ZA4_GRUPO

		While ZA4->(!EOF()) .And. _cGrp == ZA4->ZA4_GRUPO

			If SM0->( dbSeek( cEmpAnt+ZA4->ZA4_CODFIL) )
				aAdd( _aRadio, ZA4->ZA4_CODFIL+' - '+SM0->M0_FILIAL )
			Endif

			ZA4->(dbSkip())
		EndDo

		SM0->( dbSeek( _cEmp + _cFil ) )

	Endif

	Define MsDialog _oOdlgFil TITLE "Filial" FROM 0,0 TO  150, 360 PIXEL

	TGroup():New(005,005,70,175,'',_oOdlgFil,,,.T.)

	TSay():New(010,010,{||'Selecione abaixo a Filial ao qual percente o(s) XML(s) marcado(s)'},_oOdlgFil,,,,,,.T.,CLR_BLUE,CLR_WHITE,200,007)

	TRadMenu():New(025,015,_aRadio,{|u| If(PCount() > 0, _nRadio := u, _nRadio) },_oOdlgFil,,{|| },,,"",,,70,10,,,,.T.,.F.,.T.)

	TButton():New( 050, 140, "Confirmar"	,_oOdlgFil,{||(_nOpc := 1,_oOdlgFil:End())},30,10,,,.F.,.T.,.F.,,.F.,,,.F. )


	ACTIVATE MSDIALOG _oOdlgFil CENTERED

	RestArea(_AreaSM0)


	If _nOpc = 1
	
		_cWhere += "%C00.C00_FILIAL='"+xFilial("C00")+"' AND C00_YSTATU = 'FI' AND C00.C00_OK = '"+cMarca+"' "+cCondQry+"%"
	
		BeginSql Alias _cAlias
	
			SELECT C00_CHVNFE
			FROM %Table:C00% C00
			WHERE %Exp:_cWhere% AND
			C00.%notdel%
		EndSql
	
		While (_cAlias)->(!Eof())
	
			C00->(DbsetOrder(1))
			If C00->( DbSeek( xFilial("C00") + (_cAlias)->C00_CHVNFE) )
				C00->(RecLock("C00",.F.))
				C00->C00_FILIAL     := Left(_aRadio[_nRadio],2)
				C00->C00_STATUS     := ''
				C00->(MsUnLock())
			Endif
	
			(_cAlias)->(dbSkip())
		EndDo
	
		(cAliasC00)->(dbCloseArea())
	
	Endif

Return(Nil)
