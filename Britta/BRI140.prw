#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE "FWMVCDEF.CH"

#Define Verde "#9AFF9A"
#Define Amarelo "#FFFF00"
#Define Vermelho "#FF0000"
#Define Branco "#FFFAFA"
#Define Preto "#000000"
#Define Cinza "#696969"
#Define Mizu "#E8782F"

	/*
	Programa	:	BRI140
	Autor		:	Fabiano da Silva
	Data		:	19/02/20
	Descrição	:	Cancelamento de CTe
	TDN			:	https://tdn.totvs.com/display/public/PROT/TUMGXW_DT_MsExecAuto_Manutencao_de_Documentos_de_Transporte_TMSA500
	*/
User Function BRI140()

	Local _oDlg			:= NIL
	Local _nOpc			:= 0

	Private _oFont11N	:= TFont():New('Arial'	,,-11,,.T.,,,,,.F.,.F.)

	AtuSX1()

	DEFINE MSDIALOG _oDlg FROM 264,182 TO 435,500 TITLE "Cancelamento de CT-e's (BRI140)" OF _oDlg PIXEL

	_oGrupo	:= TGroup():New(005,005,045,155,"",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 010,010 SAY _oTSayA VAR "Esta rotina tem por objetivo cancelamento de"	OF _oGrupo PIXEL Size 150,010 FONT _oFont11N
	@ 020,010 SAY "CT-e's conforme os parâmetros informados"		OF _oGrupo PIXEL Size 150,010 FONT _oFont11N
	@ 030,010 SAY "pelo usuário."		OF _oGrupo PIXEL Size 150,010 FONT _oFont11N

	_oTBut1	:= TButton():New( 60,009, "Parâmetros" ,_oDlg,{||Pergunte("BRI140")},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )
	_cStyle := GetStyle(Amarelo,Branco,Cinza,Preto,1)
	_oTBut1:SetCss(_cStyle)

	_oTBut2	:= TButton():New( 60,64.5, "OK" ,_oDlg,{||_nOpc := 1,_oDlg:End()},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )
	_cStyle := GetStyle(Verde,Branco,Cinza,Preto,1)
	_oTBut2:SetCss(_cStyle)

	_oTBut3	:= TButton():New( 60,120, "Sair" ,_oDlg,{||_nOpc := 0,_oDlg:End()},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )
	_cStyle := GetStyle(Branco,Mizu,Cinza,Preto,1)
	_oTBut3:SetCss(_cStyle)

	ACTIVATE MSDIALOG _oDlg CENTERED

	If _nOpc = 1
		Pergunte('BRI140',.F.)
		LjMsgRun('Cancelamento de CT-e...','CT-e',{|| BRI140A(1)})
	Endif

Return(Nil)



Static Function GetStyle(_cCor1,_cCor2,_cCor3,_cCor4,_nTip)

	Local _cMod := ''
	Default _nTip := 1

	_cMod := "QPushButton { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+_cCor1+", stop: 1 "+_cCor2+");"
	_cMod += "border-style: outset;border-width: 2px;
		_cMod += "border-radius: 10px;border-color: "+_cCor3+";"
	_cMod += "color: "+_cCor4+"};"
	_cMod += "QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "+_cCor2+", stop: 1 "+_cCor1+");"
	_cMod += "border-style: outset;border-width: 2px;"
	_cMod += "border-radius: 10px;"
	_cMod += "border-color: "+_cCor3+" }"

Return(_cMod)



Static Function BRI140A(_nOpc)

	Local _cQuery	:= ''
	Local _nTDTP	:= 0
	Local _dDtEmi	:= ctod('')
	Local _dDtBkp	:= dDataBase
	Local f			:= 0

	Private cCadastro	:= 'Calculo de Frete'
	Private aPedBlq		:= {}
	Private lIsImpDoc	:= .F.
	Private lTmsCFec	:= TmsCFec()
	Private aRotina		:= MenuDef()
	Private nNumCTRC    := 0

	_cQuery := " SELECT DT6.R_E_C_N_O_ AS DT6RECNO,DTP.R_E_C_N_O_ AS DTPRECNO,DT6_DATEMI,DT6_SERIE, DT6_DOC, DT6_LOTNFC " +CRLF
	_cQuery += " FROM "+RetSqlName("DT6")+" DT6 " +CRLF
	_cQuery += " INNER JOIN "+RetSqlName("DTP")+" DTP ON DTP_LOTNFC = DT6_LOTNFC " +CRLF
	_cQuery += " WHERE DT6.D_E_L_E_T_ = '' AND DT6_FILIAL = '"+xFilial("DT6")+"' " +CRLF
	_cQuery += " AND DTP.D_E_L_E_T_ = '' AND DTP_FILIAL = '"+xFilial("DTP")+"' " +CRLF
	_cQuery += " AND DT6_DATEMI BETWEEN '"+dTos(MV_PAR01)+"' AND '"+dTos(MV_PAR02)+"' " +CRLF
	_cQuery += " AND DT6_DOC BETWEEN  '"+MV_PAR03+"' AND '"+MV_PAR04+"' " +CRLF
	_cQuery += " ORDER BY DT6_DATEMI,DT6_SERIE, DT6_DOC "  +CRLF

	TCQUERY _cQuery NEW ALIAS "TDTP"

	TCSETFIELD("TDTP","DT6_DATEMI","D")

	Count to _nTDTP

	If _nTDTP = 0
		ShowHelpDlg('BRI140_1',{'Nenhum registro encontrado com os parâmetros informados.'},1,{'Verifique os parâmetros.'},2)
		Return(nil)
	Endif

	SaveInter()

	TDTP->(dbGotop())

	_cSerie := TDTP->DT6_SERIE
	_cDocIn := TDTP->DT6_DOC
	_cLotIn := TDTP->DT6_LOTNFC

	While TDTP->(!EOF())

		_dDtEmi := TDTP->DT6_DATEMI

		dDataBase := _dDtEmi

		While TDTP->(!EOF()) .And. _dDtEmi == TDTP->DT6_DATEMI

			DT6->(dbGoto(TDTP->DT6RECNO))

			DTP->(dbGoto(TDTP->DTPRECNO))

			// TMSA200Est(,,,.F. )
			_aDelDocto := {}
			lEnd := .F.
			lDocto := .F.

			AAdd( _aDelDocto, {DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE,'',.T.,DT6->DT6_PRIPER} )

			BR_TMSA200Exc( _aDelDocto, DTP->DTP_LOTNFC, @lEnd, @lDocto,, .T.,.T. )

			_cDocFi := TDTP->DT6_DOC
			_cLotFi := TDTP->DT6_LOTNFC

			TDTP->(dbSkip())
		Enddo
	Enddo

	If _nOpc = 1
		cModalidade	:= ""
		cIdEnt		:= ""
		cVersaoCTE	:= ""
		lUsaColab	:= .F.
		cAmbiente	:= ""
		aParam      := {"","",""}

		_lRet := TMSSpedNFe(@cIdEnt,@cModalidade,@cVersaoCTE,@cAmbiente)


		//Transmissão dos CTe's Cancelados

		SpedNFeCan(/*cEmpAnt*/,/*cFilAnt*/,cIdEnt,cAmbiente,cModalidade,cVersaoCTE,{"","",""}/*aInfnota*/,.T./*lCTe*/)

		//--Filtra tabela SF3 para atualizar as inutilizações
		FiltroSF3(@aParam)

		Sleep(5000)

		//--Rotina responsavel atualizar tabela SF3 na inutilização CT-e
		TMS70INUT(aParam)

		_lCanc := .F.
		For f := 1 to 4
			Sleep(30000) //Aguardo 30 segundos

			BR_CteMnt(_cSerie, _cDocIn, _cDocFi)

			_AreaDT6 := DT6->(GetArea())
			DT6->(dbSetOrder(1))
			If !DT6->(MsSeek(xFilial("DT6")+cFilAnt+_cDocFi+_cSerie))
				_lCanc := .T.
				Exit
			Endif
			RestArea(_AreaDT6)

		Next f

		If _lCanc
			For f := Val(_cLotIn) to Val(_cLotFi)
				DTP->(dbSetOrder(1))
				If DTP->(MsSeek(xFilial("DTC")+strzero(f,TAMSX3("DTC_LOTNFC")[1])))

					_AreaDTP := DTP->(GetArea())
					ExcluiDTP()
					RestArea(_AreaDTP)



					_aCab := {}

					Aadd(_aCab,{'DTP_LOTNFC',DTP->DTP_LOTNFC,NIL})
					Aadd(_aCab,{'DTP_QTDLOT',DTP->DTP_QTDLOT,NIL})
					Aadd(_aCab,{'DTP_QTDDIG',DTP->DTP_QTDDIG,NIL})
					Aadd(_aCab,{'DTP_TIPLOT',DTP->DTP_TIPLOT,NIL})//--1 Normal, 2- Refaturamento, 3- Eletronico
					Aadd(_aCab,{'DTP_STATUS',DTP->DTP_STATUS,NIL})//--1 -Aberto, 2- Digitado, 3- Calculado, 4- Bloqueado, 5- Erro de Gravação

					lMsErroAuto := .F. //Como variável já foi declarada acima, aqui ela foi foi declarada novamente. Caso contrario deve ser declarada com private

					MSExecAuto({|x,y| _cLote := TMSA170(x,y)},_aCab,5)
				Endif
			Next f
		Endif
	Endif


	RestInter()

	dDataBase := _dDtBkp

Return(Nil)





Static Function ExcluiDTP()

//Esta rotina tem o objetivo de excluir o documento de entrada de cliente.

	Local aCabDTC := {}
	Local aItem := {}
	Local aItemDTC := {}

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

	DTC->(dbSetOrder(1))
	If DTC->(MsSeek(xFilial("DTC")+cFilAnt+DTP->DTP_LOTNFC))

// Dados da Nota Fiscal
		aCabDTC :={{"DTC_FILIAL" ,DTC->DTC_FILIAL, Nil},;
			{"DTC_FILORI" ,DTC->DTC_FILORI	, Nil},;
			{"DTC_LOTNFC" ,DTC->DTC_LOTNFC	, Nil},;
			{"DTC_CLIREM" ,DTC->DTC_CLIREM	, Nil},;
			{"DTC_LOJREM" ,DTC->DTC_LOJREM	, Nil},;
			{"DTC_DATENT" ,DTC->DTC_DATENT	, Nil},;
			{"DTC_CLIDES" ,DTC->DTC_CLIDES	, Nil},;
			{"DTC_LOJDES" ,DTC->DTC_LOJDES	, Nil},;
			{"DTC_CLIDEV" ,DTC->DTC_CLIDEV	, Nil},;
			{"DTC_LOJDEV" ,DTC->DTC_LOJDEV	, Nil},;
			{"DTC_CLICAL" ,DTC->DTC_CLICAL	, Nil},;
			{"DTC_LOJCAL" ,DTC->DTC_LOJCAL	, Nil},;
			{"DTC_DEVFRE" ,DTC->DTC_DEVFRE	, Nil},;
			{"DTC_SERTMS" ,DTC->DTC_SERTMS	, Nil},;
			{"DTC_TIPTRA" ,DTC->DTC_TIPTRA	, Nil},;
			{"DTC_SERVIC" ,DTC->DTC_SERVIC	, Nil},;
			{"DTC_TIPNFC" ,DTC->DTC_TIPNFC	, Nil},;
			{"DTC_TIPFRE" ,DTC->DTC_TIPFRE	, Nil},;
			{"DTC_SELORI" ,DTC->DTC_SELORI	, Nil},;
			{"DTC_CDRORI" ,DTC->DTC_CDRORI	, Nil},;
			{"DTC_CDRDES" ,DTC->DTC_CDRDES	, Nil}}

// Itens da Nota Fiscal
		aItem := {{"DTC_NUMNFC" ,DTC->DTC_NUMNFC, Nil},;
			{"DTC_SERNFC" 	,DTC->DTC_SERNFC	, Nil},;
			{"DTC_CODPRO" 	,DTC->DTC_CODPRO	, Nil},;
			{"DTC_CODEMB" 	,DTC->DTC_CODEMB	, Nil},;
			{"DTC_EMINFC" 	,DTC->DTC_EMINFC	, Nil},;
			{"DTC_QTDVOL" 	,DTC->DTC_QTDVOL	, Nil},;
			{"DTC_PESO" 	,DTC->DTC_PESO		, Nil},;
			{"DTC_PESOM3" 	,DTC->DTC_PESOM3	, Nil},;
			{"DTC_VALOR" 	,DTC->DTC_VALOR		, Nil},;
			{"DTC_BASSEG" 	,DTC->DTC_BASSEG	, Nil},;
			{"DTC_QTDUNI" 	,DTC->DTC_QTDUNI	, Nil},;
			{"DTC_EDI" 		,DTC->DTC_EDI		, Nil},;
			{"DTC_ESTORN" 	,"1"				, Nil}}

		AAdd(aItemDTC,aClone(aItem))


// Executa rotina TMSA050 com o nOpcAuto 5 (Exclui)
		MSExecAuto({|u,v,x,y,z| TMSA050(u,v,x,y,z)},aCabDTC,aItemDTC,,,5)

// Retorna Resultado do Processo
		If lMsErroAuto
			MostraErro()
		EndIf
	EndIf

Return(Nil)




Static Function FiltroSF3(aParam)

	Local cAliasQry	:=	""
	Local cQuery  	:= 	""

	Default aParam   := {"","",""}

	cQuery := "SELECT MIN(F3_NFISCAL + F3_SERIE) AS MINIMO, MAX(F3_NFISCAL + F3_SERIE) AS MAXIMO FROM " + RetSqlName("SF3") + " SF3 "
	cQuery += " WHERE SF3.D_E_L_E_T_= ' ' AND SF3.F3_EMISSAO = '"+ DtoS(dDataBase) + "' AND "
	cQuery += " SF3.F3_FILIAL  = '" + xFilial("SF3") + "'"
	cQuery += " AND ( SF3.F3_ESPECIE <> 'SPED' AND SF3.F3_CODRSEF NOT IN ( '101','102','151','155', '220') "
	cQuery += " OR (SF3.F3_ESPECIE = 'SPED'  AND SF3.F3_CODRSEF NOT IN ( '110','205','301','302')) )"

	cAliasQry := GetNextAlias()
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .T.)

	If (cAliasQry)->(!Eof())
		aParam[01] := Substr((cAliasQry)->MINIMO, TamSX3("F3_NFISCAL")[1]+ 1, TamSX3("F3_SERIE")[1]) //Serie
		aParam[02] := Substr((cAliasQry)->MINIMO, 1, TamSX3("F3_NFISCAL")[1]) //Numero NF
		aParam[03] := Substr((cAliasQry)->MAXIMO, 1, TamSX3("F3_NFISCAL")[1])
	EndIf

	(cAliasQry)->( DbCloseArea() )

Return (aParam)


	/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³MenuDef   ³ Autor ³ Marco Bianchi         ³ Data ³01/09/2006³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³Parametros do array a Rotina:                               ³±±
	±±³          ³1. Nome a aparecer no cabecalho                             ³±±
	±±³          ³2. Nome da Rotina associada                                 ³±±
	±±³          ³3. Reservado                                                ³±±
	±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
	±±³          ³    1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
	±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
	±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
	±±³          ³    4 - Altera o registro corrente                          ³±±
	±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
	±±³          ³5. Nivel de acesso                                          ³±±
	±±³          ³6. Habilita Menu Funcional                                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MenuDef()

	Local lRTMSR01    := ExistBlock("RTMSR01")
	Local lRTMSR31    := ExistBlock("RTMSR31",,.T.)
	Local aOpcMenu    := {}
	Local lTMSCTe     := SuperGetMv( "MV_TMSCTE", .F., .F. )

	Private aRotina   := {}


	If lRTMSR01
			AAdd(aOpcMenu, { "CTRC", 'TMSA200Imp' ,0 ,2})	//-- 
	EndIf
	If lRTMSR31
			AAdd(aOpcMenu, { "DACTE", 'U_RTMSR31'  ,0 ,2})	//-- 
	EndIf

		AAdd(aOpcMenu, { "Log Rejeição", 'TMSR625'    ,0 ,2})	//-- ""

		aRotina	:= {	{ 'Pesquisar' ,'AxPesqui'   ,0,1,0,.F.},;	//
						{ 'Calcular' ,'TMSA200Mnt' ,0,2,0,Nil},;	//
						{ 'Estornar' ,'TMSA200Est' ,0,6,0,Nil},;	//
						{ 'Recalculo' ,'TMSA200Rec' ,0,6,0,Nil},;	//
						{ 'Cons.Doc' ,'TMSA200Vis' ,0,6,0,Nil},;	//
						{ 'Refaturar' ,'TMSA200Mnt' ,0,5,0,Nil},;	//
						{ 'Impressao' , aOpcMenu    ,0,6,0,Nil},;	//
						{ 'Legenda' ,'TMSA170Leg' ,0,4,0,.F.},;	//
						{ 'Ct-e' ,'TMSAE70(1)' ,0,2}}			// 


	AAdd(aRotina, { 'Selecionar Lotes', 'TMSA200A'    ,0 ,2})	// '

	Return( aRotina )





	/*/
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³WsCteMnt   ³ Autor ³ Andre Godoi          ³ Data ³ 25.03.10 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Solicita o Status do documento ao TSS e grava os retornos  ³±±
	±±³          ³na tabela DT6                                               ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ExpC1: Serie do Documento                                   ³±±
	±±³          ³ExpC2: Documento Inicial                                    ³±±
	±±³          ³ExpC3: Documento Maximo                                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³                                                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function BR_CteMnt(cSerie, cDocMin, cDocMax, lCTE)

	Local aAreaSF2  := SF2->(GetArea())
	Local aAreaSF3  := SF3->(GetArea())
	Local aAreaSFT  := SFT->(GetArea())
	Local nX        := 0
	Local nY        := 0
	Local cURL      := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local lOk       := .T.
	Local oWS
	Local oRetorno
	Local cNrSerie  := ''
	Local cNrDocto  := ''
	Local cSitCTE   := ''
	Local cIDRCTE   := ''
	Local cIdent    := ''
	Local lTmsCteAut:= ExistBlock("TMSCTEAUT")
	Local aArrayDel := {}
	Local lCTECan	  := SuperGetMv( "MV_CTECAN", .F., .F. ) //-- Cancelamento CTE - .F.-Padrao .T.-Apos autorizacao
	Local cMV_INTTAF:= GetNewPar( 'MV_INTTAF', 'N' ) //Verifica se o parâmetro da integração online esta como 'S'
	Local lTafKey   := SFT->( ColumnPos( 'FT_TAFKEY' ) ) > 0
	Local lIntegTaf := ( cMV_INTTAF == 'S' .and. lTafKey )
	Local lTAFVldAmb:= ExistFunc( 'TAFVldAmb' ) .And. TAFVldAmb( '1' ) .And. ExistFunc( 'DocFisxTAF' ) //Valida se o cliente habilitou a integração nativa Protheus x TAF
	Local cTMSERP   := SuperGetMV("MV_TMSERP",," ")	//-- Condição de integração com ERP (0 - Protheus, 1 - Datasul)
	Local lcanAuto  := SuperGetMV("MV_CANAUTO",.T.,.T.)	//-- Controla a transmissão automatica
	Local lRtCTeId	:= SuperGetMv( "MV_RTCTEID", .F., .F. ) //-- Habilita o botão Retorno de Status
	Local lretUpdCte:= ExistFunc( "retUpdCte" )
	Local lretCte   := .T.
	Default lCTE    := .T.

	Private oXml

	If (CTIsReady())
		cIdEnt := RetIdEnti()
	EndIf

	oWS:= WSNFeSBRA():New()
	oWS:cUSERTOKEN    := "TOTVS"
	oWS:cID_ENT       := cIdEnt
	oWS:_URL          := AllTrim(cURL)+"/NFeSBRA.apw"
	oWS:cIdInicial    := cSerie + cDocMin
	oWS:cIdFinal      := cSerie + cDocMax

	lOk := oWS:MONITORFAIXA()
	oRetorno := oWS:oWsMonitorFaixaResult

	For nX := 1 To Len(oRetorno:oWSMONITORNFE)
		nY       := Len(oRetorno:OWSMONITORNFE[nX]:OWSERRO:OWSLOTENFE)
		cNrSerie := SubStr(oRetorno:OWSMONITORNFE[nX]:CID,1, TamSx3("DT6_SERIE")[1])
		cNrDocto := SubStr(oRetorno:OWSMONITORNFE[nX]:CID, (TamSx3("DT6_SERIE")[1] + 1), TamSx3("DT6_DOC")[1])

	/*//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//           Estas Msg sao retornadas pelo TSS, no metodo ( Substr(oRetorno:OWSMONITORNFE[nX]:CRECOMENDACAO,1,3))                          //
	//	aadd(aMsg,"001 - Emissão de DANFE autorizada")                                                                                         //
	//	aadd(aMsg,"002 - Não foi possível assinar a Nfe - entre em contato com o responsável")                                                 //
	//	aadd(aMsg,"003 - A Nfe ainda não foi assinada - aguarde a assinatura")                                                                 //
	//	aadd(aMsg,"004 - Lote ainda não transmitido, verifique o status da SEFAZ")                                                             //
	//	aadd(aMsg,"005 - Lote recusado, verifique o motivo da SEFAZ")                                                                          //
	//	aadd(aMsg,"006 - ")                                                                                                                    //
	//	aadd(aMsg,"007 - Autorizada operação em contigência")                                                                                  //
	//	aadd(aMsg,"008 - Autorizada manutenção da operação em contigência")                                                                    //
	//	aadd(aMsg,"009 - Aguardar processamento do lote")                                                                                      //
	//	aadd(aMsg,"010 - Lote não autorizado. Corrija o problema e retransmita as notas fiscais eletrônicas")                                  //
	//	aadd(aMsg,"011 - Entre em contato com a SEFAZ, verifique a versão de layout suportada e atualize os parâmetros do sistema")            //
	//	aadd(aMsg,"012 - Lote não autorizado. Verifique os motivos junto a SEFAZ")                                                             //
	//	aadd(aMsg,"013 - NFe não autorizada. Verifique os motivos junto a SEFAZ")                                                              //
	//	aadd(aMsg,"014 - NFe não autorizada. Corrija o problema e retransmita as notas fiscais eletrônicas")                                   //
	//	aadd(aMsg,"015 - Cancelamento autorizado")                                                                                             //
	//	aadd(aMsg,"016 - Cancelamento não transmitido, verifique o status da SEFAZ")                                                           //
	//	aadd(aMsg,"017 - Cancelamento não autorizado. Verifique os motivos junto a SEFAZ")                                                     //
	//	aadd(aMsg,"018 - Dpec autorizado. Emissão de DANFE autorizada")                                                                        //
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// */
	/*
		100 Autorizado o uso do CT-e
		101 Cancelamento de CT-e homologado
		102 Inutilização de número homologado
		103 Lote recebido com sucesso
		104 Lote processado
		105 Lote em processamento
		106 Lote não localizado
		107 Serviço em Operação
		108 Serviço Paralisado Momentaneamente (curto prazo)
		109 Serviço Paralisado sem Previsão
		110 Uso Denegado
		111 Consulta cadastro com uma ocorrência
		112 Consulta cadastro com mais de uma ocorrência
		128 CT-e anulado pelo emissor
		129 CT-e substituído pelo emissor
		130 Apresentada Carta de Correção Eletrônica – CC-e
		131 CT-e desclassificado pelo Fisco

			0 - Nao Transmitido
			1 - Doc Aguardando
			2 - Doc Autorizado
			3 - Doc Nao Autorizado
			4 - Doc em Contingencia
			5 - Doc com Falha na Comunicacao
	*/

		If (!Empty(oRetorno:OWSMONITORNFE[nX]:CRECOMENDACAO))		//-- Mensagem do TSS.
			cSitCTE := oRetorno:OWSMONITORNFE[nX]:OWSERRO:OWSLOTENFE[nY]:CCODRETNFE
			cCodRet := Substr(oRetorno:OWSMONITORNFE[nX]:CRECOMENDACAO,1,3)
			DT6->(dbSetOrder(1))
			If	DT6->(MsSeek(xFilial('DT6')+cFilAnt+PadR(cNrDocto, Len(DT6->DT6_DOC))+cNrSerie))
				If lretUpdCte
					lretCte := retUpdCte(cFilAnt,PadR(cNrDocto, Len(DT6->DT6_DOC)),cNrSerie,cSitCTE)
				EndIf
				If lretCte
					RecLock('DT6',.F.)
					cIDRCTE := DT6->DT6_IDRCTE
					DT6->DT6_IDRCTE := cSitCTE
					DT6->DT6_PROCTE := oRetorno:OWSMONITORNFE[nX]:CPROTOCOLO

					If !Empty(cCodRet) .And. !(cCodRet $ '003/002/004/009/016/039')
						DT6->DT6_RETCTE := SubStr(oRetorno:OWSMONITORNFE[nX]:OWSERRO:OWSLOTENFE[Len(oRetorno:OWSMONITORNFE[nX]:OWSERRO:OWSLOTENFE)]:CCODRETNFE;
							+ " - " +;
							oRetorno:OWSMONITORNFE[nX]:OWSERRO:OWSLOTENFE[Len(oRetorno:OWSMONITORNFE[nX]:OWSERRO:OWSLOTENFE)]:CMSGRETNFE,1,150)
					Else
						DT6->DT6_RETCTE := SubStr(oRetorno:OWSMONITORNFE[nX]:CRECOMENDACAO,1,150)
					EndIf
					DT6->DT6_AMBIEN := oRetorno:OWSMONITORNFE[nX]:NAMBIENTE	//-- Grava o Ambiente que foi gerado o Doc.

					If cCodRet $ '002/016'
						DT6->DT6_SITCTE := StrZero(0,Len(DT6->DT6_SITCTE))		//-- Nao Transmitido

					ElseIf cCodRet $ '003/004/009/039'
						DT6->DT6_SITCTE := StrZero(1,Len(DT6->DT6_SITCTE))		//-- Aguardando.....
						If oRetorno:OWSMONITORNFE[nX]:NMODALIDADE == 7
							If Type("aPChvCtg") <> "U" .And. Len(aPChvCtg)>0
								nPos := Ascan(aPChvCtg,{ | e | e[1]+e[2]+e[3] == DT6->DT6_FILDOC+DT6->DT6_DOC+DT6->DT6_SERIE })
								If nPos>0
									DT6->DT6_CHVCTG := aPChvCtg[nPos,4]
								EndIf
							EndIf
						EndIf

					ElseIf cCodRet $ '001/015'
						DT6->DT6_SITCTE := StrZero(2,Len(DT6->DT6_SITCTE))		//-- Autorizado o uso do Cte.

					ElseIf cCodRet $ '005/010/011/012/013/014/017/026'
						DT6->DT6_SITCTE := StrZero(3,Len(DT6->DT6_SITCTE))		//-- Nao Autorizado

					ElseIf cCodRet $ '007/008'
						DT6->DT6_SITCTE := StrZero(4,Len(DT6->DT6_SITCTE))		//-- Autorizado Contingencia
						If Type("aPChvCtg") <> "U" .And. Len(aPChvCtg)>0
							nPos := Ascan(aPChvCtg,{ | e | e[1]+e[2]+e[3] == DT6->DT6_FILDOC+DT6->DT6_DOC+DT6->DT6_SERIE })
							If nPos>0
								DT6->DT6_CHVCTG := aPChvCtg[nPos,4]
							EndIf
						EndIf
					EndIf

					MsUnLock()
					//-- Se for reentrega diminui 1 na quantidade de reentregas do documento original
					If DT6->DT6_DOCTMS == StrZero(7,Len(DT6->DT6_DOCTMS)) .And. !Empty(cIDRCTE) .And. cIDRCTE <> "101" .And. cSitCTE == '101' //Cancelamento autorizado
						aAreaDT6 := DT6->(GetArea())
						DT6->(dbSetOrder(1))
						If DT6->(MsSeek(xFilial('DT6')+ DT6->DT6_FILDCO + DT6->DT6_DOCDCO + DT6->DT6_SERDCO)) .And. DT6->DT6_REENTR > 0
							RecLock("DT6",.F.)
							DT6->DT6_REENTR := DT6->DT6_REENTR - 1
							DT6->(MsUnLock())
						EndIf
						RestArea(aAreaDT6)
					EndIf
					If lTmsCteAut
						ExecBlock("TMSCTEAUT",.F.,.F.,{DT6->DT6_FILDOC, DT6->DT6_DOC, DT6->DT6_SERIE, DT6->DT6_SITCTE})
					EndIf

					//Nota de saida

					dbSelectArea("SF2")
					dbSetOrder(1)	//-- F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
					If SF2->(MsSeek(xFilial("SF2") + DT6->DT6_DOC + DT6->DT6_SERIE + DT6->DT6_CLIDEV + DT6->DT6_LOJDEV,.T.)) .And. SF2->F2_CHVNFE != DT6->DT6_CHVCTE
						RecLock("SF2",.F.)
						SF2->F2_CHVNFE := DT6->DT6_CHVCTE
						MsUnlock()

						//Função para gravação de campos da Nota no modulo Controle de Lojas com Legislação PAF-ECF
						If !lCTE .And. ExistFunc("STFMMd5NS")
							STFMMd5NS()
						EndIf
					EndIf

					//Livros Fiscais
					dbSelectArea("SF3")
					dbSetOrder(4) //-- F3_FILIAL+F3_CLIFOR+F3_LOJA+F3_NFISCAL+F3_SERIE
					If SF3->(MsSeek(xFilial("SF3") + DT6->DT6_CLIDEV + DT6->DT6_LOJDEV + DT6->DT6_DOC +DT6->DT6_SERIE,.T.))
						cChave := xFilial("SF3")+ DT6->DT6_CLIDEV + DT6->DT6_LOJDEV + DT6->DT6_DOC +DT6->DT6_SERIE
						Do While cChave == xFilial("SF3") + SF3->F3_CLIEFOR + SF3->F3_LOJA + SF3->F3_NFISCAL + SF3->F3_SERIE .And. !SF3->(Eof())
							RecLock("SF3",.F.)
							SF3->F3_CHVNFE  := DT6->DT6_CHVCTE
							SF3->F3_CODRSEF := cSitCTE
							MsUnLock()

							//-- Executa integração do Datasul
							If cTMSERP == "1" .And. FindFunction("TMSAE76")
								TMSAE76()
							EndIf
							SF3->(dbSkip())
						EndDo
					EndIf

					//-- Livro Fiscal por Item de NF
					SFT->(dbSetOrder(1))
					cChave := xFilial("SFT")+"S"+ DT6->DT6_SERIE + DT6->DT6_DOC + DT6->DT6_CLIDEV + DT6->DT6_LOJDEV
					If SFT->(MsSeek(xFilial("SFT")+"S"+ DT6->DT6_SERIE + DT6->DT6_DOC + DT6->DT6_CLIDEV + DT6->DT6_LOJDEV,.T.))
						If SFT->(FieldPos("FT_CHVNFE"))>0  .And. SFT->(FieldPos("FT_CODNFE"))>0
							Do While cChave == xFilial("SFT")+"S"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA .And. !SFT->(Eof())
								RecLock("SFT",.F.)
								SFT->FT_CHVNFE := DT6->DT6_CHVCTE
								SFT->FT_CODNFE := oRetorno:OWSMONITORNFE[nX]:CPROTOCOLO
								MsUnLock()

								//-----------------------------------------------------------------------------------------
								//Quando o cliente utiliza integração com o TAF no retorno do TSS faço o envio do documento
								//-----------------------------------------------------------------------------------------
								If lIntegTaf .and. !empty( SFT->FT_CHVNFE )
									FIntegNfTaf( { SFT->FT_NFISCAL, SFT->FT_SERIE, SFT->FT_CLIEFOR, SFT->FT_LOJA, SFT->FT_TIPOMOV, SFT->FT_ENTRADA }, lTAFVldAmb )
								EndIf

								SFT->(dbSkip())
							EndDo
						EndIf
					EndIf

					//Exclui o documento automaticamente caso o parâmetro MV_CTECAN esteja habilitado, e o MV_CANAUTO também.
					If lcanAuto
						If lCTECan .And. cSitCTE == '101'
							Aadd(aArrayDel , { DT6->DT6_FILDOC, DT6->DT6_DOC, DT6->DT6_SERIE, "", .T., DT6->DT6_SITCTE })
							TMSA200Exc(aArrayDel, DT6->DT6_LOTNFC, .F., .F., )
						EndIf
					EndIf

					If FindFunction ("AvbeGrvCte") .AND. AliasInDic("DL5")
						AvbeGrvCte( DT6->DT6_FILDOC, DT6->DT6_DOC, DT6->DT6_SERIE,DT6->DT6_DATEMI,DT6->DT6_HOREMI,DT6->DT6_IDRCTE,DT6->DT6_DOCTMS, DT6->DT6_CLIDEV, DT6->DT6_LOJDEV)
					EndIF
				EndIf
			EndIf
			If FindFunction ("AvbeGrvCte") .AND. AliasInDic("DL5") .AND. !lCTECan .AND. cSitCTE == '101'
				AvbeGrvCte( cFilAnt, +PadR(cNrDocto, Len(DT6->DT6_DOC)), cNrSerie,,,'101',,,)
			EndIF
		EndIf

	Next nX

	RestArea(aAreaSF2)
	RestArea(aAreaSF3)
	RestArea(aAreaSFT)


Return Nil





Static Function AtuSX1()

	Local _cPerg := "BRI140"
	Local _nTDoc := TAMSX3("DT6_DOC")[1]

	//    	      Grupo/Ordem/Pergunta    				/perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01    	/defspa1/defeng1/Cnt01  /Var02/Def02/Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(_cPerg,"01" ,"Emissao De  ?"			,""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR01",""        	,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"02" ,"Emissao Ate ?"			,""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02",""        	,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"03" ,"CT-e De  ?"				,""       ,""      ,"mv_ch3","C" ,_nTDoc ,0      ,0     ,"G",""        ,"MV_PAR03",""        	,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"DT6")
	U_CRIASX1(_cPerg,"04" ,"CT-e Ate ?"				,""       ,""      ,"mv_ch4","C" ,_nTDoc ,0      ,0     ,"G",""        ,"MV_PAR04",""        	,""     ,""     ,""     ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"DT6")

Return (Nil)





	/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³TMSA200Exc³ Autor ³ Alex Egydio           ³ Data ³20.02.2002³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Estorna documentos                                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ TMSA200Exc()                                               ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpA1 = Array contendo os documentos                       ³±±
	±±³          ³ ExpC1 = Lote da Nota Fiscal                                ³±±
	±±³          ³ ExpL1 = Cancela processamento                              ³±±
	±±³          ³ ExpL2 = .T. indica que ha documentos calculados no lote e  ³±±
	±±³          ³         nao muda o status do lote para digitado.           ³±±
	±±³          ³ ExpC2 = No. do Novo Lote gerado                            ³±±
	±±³          ³ ExpL3 = .T. - Manutencao de Documentos                     ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function BR_TMSA200Exc( aDelDocto, cLotNfc, lEnd, lDocto, cLotEst, l500Doc, lExc2Pe )

	Local aAreaAnt	:= GetArea()
	Local aAreaDTC	:= DTC->(GetArea())
	Local aAreaSF2	:= {}
	Local aAreaDT6	:= {}
	Local aCab		:= {}
	Local cPedido	:= ''
	Local cSeek		:= ''
	Local cChave	:= ''
	Local lRet		:= .F.
	Local lHelpCte	:= .F.
	Local lGerLot 	:= SuperGetMv( "MV_GERLOT", .F., .T. )  //-- Parâmetro que determina se o sistema deve gerar novo lote ao estornar o cálculo
	Local nCntFor	:= 0
	Local nQtdDig	:= 0
	Local nSeek		:= 0
	Local aNfDig	:= {}
	Local aContrt	:= {}
	Local dDtdigit	:= dDataBase
	Local cLotAnt	:= ""
	Local cQuery	:= ""
	Local cAliasQry	:= ""
	Local cAliasDVR	:= ""
	Local lTMSCTe	:= SuperGetMv( "MV_TMSCTE", .F., .F. ) //-- Parametro do CT-e ativo.
	Local lCTECan	:= SuperGetMv( "MV_CTECAN", .F., .F. ) //-- Cancelamento CTE - .F.-Padrao .T.-Apos autorizacao
	Local lAgdEntr	:= Iif(FindFunction("TMSA018Agd"),TMSA018Agd(),.F.)   //-- Agendamento de Entrega.
	Local lCTCFsda	:= SuperGetMv( "MV_CTCFSDA", .F., .F. ) //-- Parametro do CT-e Cancelamento FSDA.
	Local lDTCRee 	:= DTC->(FieldPos("DTC_DOCREE")) > 0
	Local lContDoc	:= SuperGetMv("MV_CONTDOC",.F.,.F.) //--Parametro para controle de Transações da Viagem mod2,
						//-- o documento ficara locado até confirmar ou fechar a viagem impossibilitando o uso do documento por outras Estações.
	Local lUsaColab	:= UsaColaboracao("2")
	Local lTmsCFec  := Iif(Type("lTmsCFec") = "U", TmsCFec(),lTmsCFec)
	Local cIsenSub	:= GetMV("MV_ISENSUB",,"") 
	Local lTabDLT   := TableIndic("DLT")
	Local cAtvChgCli:= SuperGetMv('MV_ATVCHGC',,'') //-- Atividade de Chegada em Cliente
	Local lEstDLT   := .F.

	DEFAULT l500Doc	:= .F.
	Default lExc2Pe	:= .F. //Indica se a exclusão está sendo chamada após erro durante a geração de um CTRC de 2º Percurso.

	ProcRegua(Len(aDelDocto))
	For nCntFor := 1 To Len(aDelDocto)
		IncProc()
		//-- Se nao estiver marcado
		If !aDelDocto[ nCntFor, 5 ]
			Loop
		EndIf
		cSeek := aDelDocto[nCntFor,1] + aDelDocto[nCntFor,2] + aDelDocto[nCntFor,3]
		//-- Posiciona no documento
		DT6->(DbSetOrder(2)) //DT6_FILIAL+DT6_FILORI+DT6_LOTNFC+DT6_FILDOC+DT6_DOC+DT6_SERIE
		If	DT6->(!MsSeek( xFilial('DT6') + cFilAnt + cLotNfc + cSeek ))
			lRet := .F.
			Loop
		EndIf
		//-- Trava o registro que está sendo usado por outra estação
		If lContDoc
			If !TmsConTran(aDelDocto[nCntFor,1],aDelDocto[nCntFor,2],aDelDocto[nCntFor,3], .T.)
				lRet := .F.
				Exit
			Else
				TmsConTran(aDelDocto[nCntFor,1],aDelDocto[nCntFor,2],aDelDocto[nCntFor,3], .F.)
			EndIf
		EndIf

		//-- Nao permitir estorno caso tenha fechamento de seguro para o documento
		If	! Empty( DT6->DT6_DOCSEG )
			Help(' ', 1, 'TMSA20021',," Ha fechamento de seguro para este docto." + aDelDocto[nCntFor,2] +' / '+ aDelDocto[nCntFor,3] + 'Documento: ' + DT6->DT6_DOCSEG,5,11)		//--	//###
			lRet := .F.
			Exit
		EndIf
		// Não permitir o estorno quando a modalidade for EPEC, o estorno só pode ser feito após a validação do evento EPEC conforme manual da da SEFAZ
		If DT6->DT6_IDRCTE $ '136/639/640/641/642/643/644/645/695/696/697/698/756'
			Help(' ', 1, "TMSA20043",, ,5,11 )
			lRet := .F.
			Exit
		EndIf
		// Não permitir o estorno quando a modalidade for EPEC, o estorno só pode ser feito após a validação do evento EPEC conforme manual da da SEFAZ
		If Substr(DT6->DT6_CHVCTE,35,1) = '4' .AND. DT6->DT6_SITCTE = '1'
			Help(' ', 1, 'TMSA20044',, ,5,11 )
			lRet := .F.
			Exit
		EndIf

		// Consumo indevido não permitir o estorno quando o MV_CTECAN estiver habilitado e o retorno da SEFAZ for 678
		If DT6->DT6_IDRCTE $ '678/999' .And. lCTECan
			Help(' ', 1, "TMSA20055",, ,5,11 )
			lRet := .F.
			Exit
		EndIf

		//--Não permitir o estorno quando o MV_CTECAN estiver habilitado e o retorno da SEFAZ for 103
		If DT6->DT6_IDRCTE == "103" .And. lCTECan
			Help(' ', 1, "TMSA20044",, ,5,11 )
			lRet := .F.
			Exit
		EndIf

		//--Nao permitir estornar o Calculo do Frete,
		//--validando o parametro MV_DATAFIS,
		//--validando se houver CC-e nao permite estonar o calculo.
		aAreaSF2 := SF2->(GetArea())
		SF2->(DbSetOrder(1)) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
		If	SF2->(MsSeek( xFilial('SF2') + aDelDocto[nCntFor,2] + aDelDocto[nCntFor,3], .F. ))
			dDtdigit := IIf(!Empty(SF2->F2_DTDIGIT),SF2->F2_DTDIGIT,SF2->F2_EMISSAO)
			If !FisChkDt(dDtDigit)
				lRet := .F.
				Exit
			EndIf
			If !Empty(SF2->F2_IDCCE)
				Help(' ', 1, 'TMSA20053',, ,5,11 )
				lRet := .F.
				Exit
			EndIf
		EndIf
		RestArea(aAreaSF2)

		// Caso MV_CTECAN = .T. e MV_GERLOT = .F. e lote possuir mais de um documento, e não for de rateio, será gerado um novo lote ao estornar o calculo.
		If !lGerLot .And. lCTECan .And. Len(aDelDocto) > 1 .And. DTP->DTP_TIPLOT == StrZero(3,Len(DTP->DTP_TIPLOT)) ;
				.Or. DTP->DTP_TIPLOT == StrZero(4,Len(DTP->DTP_TIPLOT)) .And. DTP->DTP_RATEIO <> StrZero(1, Len(DTP->DTP_RATEIO))
			lGerLot := .T.
			Else
			// Caso MV_CTECAN = .T. e MV_GERLOT = .T. e lote possuir mais de um documento, e o lote for de rateio, não será  gerado um novo lote ao estornar o calculo.
			If lGerLot .And. lCTECan .And. DTP->DTP_RATEIO == StrZero(1, Len(DTP->DTP_RATEIO))
				lGerLot := .F.
			EndIf
		EndIf

		If lAgdEntr .And. !Empty(DT6->DT6_NUMAGD) //-- cancelar os agendamentos
			DbSelectArea("DTC")
			DbSetOrder(3)
			If DTC->(DbSeek(xFilial("DTC")+aDelDocto[nCntFor,1] + aDelDocto[nCntFor,2] + aDelDocto[nCntFor,3]))
				DbSelectArea("DYD")
				DbSetOrder(2)
				DYD->(DbSeek(cSeek := xFilial("DYD")+aDelDocto[nCntFor,1] + aDelDocto[nCntFor,2] + aDelDocto[nCntFor,3]))
				While DYD->(!EoF()) .And. cSeek == DYD->DYD_FILIAL+DYD->DYD_FILDOC+DYD->DYD_DOC+DYD->DYD_SERIE
					TMSA200AGD(5) //Exclui
					DYD->(DbSkip())
				EndDo
			EndIf
		EndIf

		aAreaDT6 := DT6->(GetArea())
		cChave   := xFilial('DT6')+DT6->DT6_FILDOC+DT6->DT6_DOC+DT6->DT6_SERIE
		DT6->(DbSetOrder(8)) //DT6_FILIAL+DT6_FILDCO+DT6_DOCDCO+DT6_SERDCO
		If DT6->(MsSeek(cChave)) .And. !(DT6->DT6_DOCTMS == 'J' .And. DT6->DT6_TIPFRE == '3')
			RestArea(aAreaDT6)
			Help(' ', 1, 'TMSA20029',,DT6->DT6_FILDOC + "/" + DT6->DT6_DOC + "/" + DT6->DT6_SERIE + CRLF + "Existe Manutencao de Doctos. feita para o CTRC : ",2,13) //###". A Exclusao nao sera efetuada .... "
			lRet :=.F.
			Exit
		EndIf
		RestArea(aAreaDT6)

		lRet := .T.

		//-- Se docto nao for de 2o. percurso
		If	aDelDocto[nCntFor,6] == StrZero(2,Len(DT6->DT6_PRIPER))
			DTC->(DbSetOrder(3)) //DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE+DTC_SERVIC+DTC_CODPRO
			cAliasQry := GetNextAlias()
			cQuery := " SELECT DTC_CLIREM, DTC_LOJREM, DTC_SERVIC, DTC_NUMNFC, DTC_SERNFC "
			cQuery += "   FROM " + RetSqlName("DTC") + " DTC "
			cQuery += "  WHERE DTC.DTC_FILIAL = '" + xFilial('DTC')  + "' "
			cQuery += "    AND DTC.DTC_FILDOC = '" + aDelDocto[nCntFor,1] + "' "
			cQuery += "    AND DTC.DTC_DOC    = '" + aDelDocto[nCntFor,2] + "' "
			cQuery += "    AND DTC.DTC_SERIE  = '" + aDelDocto[nCntFor,3] + "' "
			cQuery += "    AND DTC.D_E_L_E_T_ = ' ' "
			cQuery += "    UNION "
			cQuery += " SELECT DTC_CLIREM, DTC_LOJREM, DTC_SERVIC, DTC_NUMNFC, DTC_SERNFC "
			cQuery += "   FROM " + RetSqlName("DY4") + " DY4 "
			cQuery += "   INNER JOIN " + RetSqlName("DTC") + " DTC "
			cQuery += "		ON  DTC.DTC_FILIAL = '"+xFilial('DTC')+"'"
			cQuery += "    	AND DTC.D_E_L_E_T_ = ' ' "
			cQuery += "		AND DTC.DTC_LOTNFC = DY4.DY4_LOTNFC "
			cQuery += "		AND DTC.DTC_NUMNFC = DY4.DY4_NUMNFC "
			cQuery += "		AND DTC.DTC_SERNFC = DY4.DY4_SERNFC "
			cQuery += "		AND DTC.DTC_CODPRO = DY4.DY4_CODPRO "
			cQuery += "  WHERE DY4.DY4_FILIAL = '" + xFilial('DY4')  + "' "
			cQuery += "    AND DY4.DY4_FILDOC = '" + aDelDocto[nCntFor,1] + "' "
			cQuery += "    AND DY4.DY4_DOC    = '" + aDelDocto[nCntFor,2] + "' "
			cQuery += "    AND DY4.DY4_SERIE  = '" + aDelDocto[nCntFor,3] + "' "
			cQuery += "    AND DY4.D_E_L_E_T_ = ' ' "
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
			While (cAliasQry)->(!Eof())
				nSeek := Ascan(aNfDig, {|x| x[1] == (cAliasQry)->DTC_CLIREM + (cAliasQry)->DTC_LOJREM + (cAliasQry)->DTC_NUMNFC + (cAliasQry)->DTC_SERNFC } )
				If nSeek == 0
					AAdd(aNFDig, { (cAliasQry)->DTC_CLIREM + (cAliasQry)->DTC_LOJREM + (cAliasQry)->DTC_NUMNFC + (cAliasQry)->DTC_SERNFC } )
				EndIf
				(cAliasQry)->(DbSkip())
			EndDo
			(cAliasQry)->(DbCloseArea())
		EndIf
	Next

	If	lRet
		//-- Se tipo do lote for refaturamento, retorna a situação dos documentos originais,
		//-- e exclui o apontamento do registro de ocorrencias.
		If DTP->DTP_TIPLOT == StrZero(2,Len(DTP->DTP_TIPLOT))
				TMSA500Exc(DTP->DTP_FILORI,DTP->DTP_LOTNFC)
		EndIf

		ProcRegua(Len(aDelDocto))
		For nCntFor := 1 To Len(aDelDocto)
			IncProc()
			If ! aDelDocto[ nCntFor, 5 ]
				Loop
			EndIf
			cSeek:= aDelDocto[nCntFor,1] + aDelDocto[nCntFor,2] + aDelDocto[nCntFor,3]
			DT6->(DbSetOrder(2)) //DT6_FILIAL+DT6_FILORI+DT6_LOTNFC+DT6_FILDOC+DT6_DOC+DT6_SERIE
			If	DT6->(DbSeek(xFilial('DT6') + cFilAnt + cLotNfc + cSeek ))

				//-- Ajuste Lote Inicio

				DTP->(dbSetOrder(2)) //DTP_FILIAL+DTP_FILORI+DTP_LOTNFC
				If	DTP->(MsSeek(xFilial("DTP")+cFilAnt+cLotNfc))
					If !lUsaColab
						If DTP->DTP_TIPLOT == StrZero(1,Len(DTP->DTP_TIPLOT)).Or.;
							( (DTP->DTP_TIPLOT == StrZero(3,Len(DTP->DTP_TIPLOT)).Or.;
							DTP->DTP_TIPLOT == StrZero(4,Len(DTP->DTP_TIPLOT))) .And. (!lCTECan .Or. ;
							(lCTECan .And. (DT6->DT6_STATUS = 'C' .or. ( SubStr(DT6->DT6_RETCTE,1,3)<> "100" .And. SubStr(DT6->DT6_RETCTE,1,3) <> "004" )))) )
							nQtdDig := DTP->DTP_QTDDIG
							//-- Gera lote de estorno
								If !l500Doc .And. nQtdDig <> Len(aNfDig) .And. AllTrim(FunName()) != 'TMSA200A' .And. lGerLot
								//-- Indica que o status do lote permanecera calculado.
								lDocto  := .T.
								If Empty(cLotEst)
									cLotEst := TmsA200Lte(cLotNfc,StrZero(2,Len(DTP->DTP_STATUS)),Len(aNfDig))
									nQtdDig := DTP->DTP_QTDDIG
								EndIf
							EndIf
						EndIf
					Else
						If DTP->DTP_TIPLOT == StrZero(1,Len(DTP->DTP_TIPLOT)).Or.;
							( (DTP->DTP_TIPLOT == StrZero(3,Len(DTP->DTP_TIPLOT)).Or.;
							DTP->DTP_TIPLOT == StrZero(4,Len(DTP->DTP_TIPLOT))) .And. (!lCTECan .Or. ;
							(lCTECan .And. (DT6->DT6_STATUS = 'C' .or. ( SubStr(DT6->DT6_RETCTE,1,3)<> "001" .And. SubStr(DT6->DT6_RETCTE,1,3) <> "002" )))) )
							nQtdDig := DTP->DTP_QTDDIG
							//-- Gera lote de estorno
								If !l500Doc .And. nQtdDig <> Len(aNfDig) .And. AllTrim(FunName()) != 'TMSA200A' .And. lGerLot
								//-- Indica que o status do lote permanecera calculado.
								lDocto  := .T.
								If Empty(cLotEst)
									cLotEst := TmsA200Lte(cLotNfc,StrZero(2,Len(DTP->DTP_STATUS)),Len(aNfDig))
									nQtdDig := DTP->DTP_QTDDIG
								EndIf
							EndIf
						EndIf
					EndIf

					//-- Controle para estornar os dados da Operação do Documento da Viagem em Transito (DLT e DTW)
					lEstDLT:= .F.	
					If lTabDLT .And. ExistFunc("TMSA351Exc") .And. !Empty(cAtvChgCli) .And. !Empty(DTP->DTP_VIAGEM)
						DTQ->(DbSetOrder(2))
						If DTQ->(MsSeek(xFilial('DTQ') + DTP->(DTP_FILORI+DTP_VIAGEM))) .And. DTQ->DTQ_STATUS == StrZero( 2, Len( DTQ->DTQ_STATUS ) ) //-- Viagem em Trânsito
							lEstDLT:= .T.
						EndIf
					EndIf
				EndIf

				//-- Fim do Ajuste Lote

				//////////////////////////////////////////////////////////////////////
				//-- Exclusao CTE somente apos envio e autorizacao da SEFAZ - Nao efetua exclusao somente altera Status!
				If !lUsaColab
					If	lTMSCTe .And. lCTECan .And. (!Empty(DT6->DT6_CHVCTE) .Or. !Empty(DT6->DT6_CHVCTG)) .And. ( SubStr(DT6->DT6_RETCTE,1,3)= "100" .Or. SubStr(DT6->DT6_RETCTE,1,3)= "004" )
						//Incluido para tratamento FSDA, para permitir cancelar em modalidade FSDA quando o parametro (MV_CTECAN e MV_CTCFSDA) estiver com True
						If !(lCTCFSDA .And. (SubStr(DT6->DT6_CHVCTE,35,1)= "5" .And. SubStr(DT6->DT6_RETCTE,1,3)<> "100"))
							If !DT6->DT6_STATUS $ "B/C"	//-- B- Cancelamento SEFAZ Aguardando, C- Cancelamento SEFAZ Autorizado, D- Cancelamento SEFAZ nao autorizado
								RecLock("DT6",.F.)
								DT6->DT6_BLQDOC	:= StrZero(1, Len(DT6->DT6_BLQDOC)) //-- Bloqueio: 1-Sim
								DT6->DT6_STATUS := "B"	//-- B- Cancelamento SEFAZ Aguardando
								MsUnLock()
								//-- Altera registro SF3 para excluido para permitir transmitir para SEFAZ!
								dbSelectArea("SF3")
								SF3->(DbSetOrder(4)) //F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE
								If	SF3->(DbSeek(xFilial("SF3")+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV+DT6->DT6_DOC+DT6->DT6_SERIE))
									While SF3->(!Eof()) .And. SF3->(F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE) == xFilial("SF3")+DT6->(DT6_CLIDEV+DT6_LOJDEV+DT6_DOC+DT6_SERIE)
										If (Substr(SF3->F3_CFO,1,1) >= "5")
											RecLock("SF3",.F.)
											SF3->F3_DTCANC := dDataBase
											MsUnlock()
										EndIf
										SF3->(dbSkip())
									EndDo
								EndIf
								//-- Nao efetua exclusao somente altera Status!
								lHelpCte := .T.
								lDocto   := .T.
								Loop
							EndIf
						EndIf
					EndIf
				Else
					If	lTMSCTe .And. lCTECan .And. (!Empty(DT6->DT6_CHVCTE) .Or. !Empty(DT6->DT6_CHVCTG)).And. ( SubStr(DT6->DT6_RETCTE,1,3)= "001" .Or. SubStr(DT6->DT6_RETCTE,1,3)= "002" )
						//Incluido para tratamento FSDA, para permitir cancelar em modalidade FSDA quando o parametro (MV_CTECAN e MV_CTCFSDA) estiver com True
						If !(lCTCFSDA .And. (SubStr(DT6->DT6_CHVCTE,35,1)= "5" .And. SubStr(DT6->DT6_RETCTE,1,3)<> "001"))
							If !DT6->DT6_STATUS $ "B/C"	//-- B- Cancelamento SEFAZ Aguardando, C- Cancelamento SEFAZ Autorizado, D- Cancelamento SEFAZ nao autorizado
								RecLock("DT6",.F.)
								DT6->DT6_BLQDOC	:= StrZero(1, Len(DT6->DT6_BLQDOC)) //-- Bloqueio: 1-Sim
								DT6->DT6_STATUS := "B"	//-- B- Cancelamento SEFAZ Aguardando
								MsUnLock()
								//-- Altera registro SF3 para excluido para permitir transmitir para SEFAZ!
								dbSelectArea("SF3")
								SF3->(DbSetOrder(4)) //F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE
								If	SF3->(DbSeek(xFilial("SF3")+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV+DT6->DT6_DOC+DT6->DT6_SERIE))
									While SF3->(!Eof()) .And. SF3->(F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE) == xFilial("SF3")+DT6->(DT6_CLIDEV+DT6_LOJDEV+DT6_DOC+DT6_SERIE)
										If (Substr(SF3->F3_CFO,1,1) >= "5")
											RecLock("SF3",.F.)
											SF3->F3_DTCANC := dDataBase
											MsUnlock()
										EndIf
										SF3->(dbSkip())
									EndDo
								EndIf
								//-- Nao efetua exclusao somente altera Status!
								lHelpCte := .T.
								lDocto   := .T.
								Loop
							EndIf
						EndIf
					EndIf
				EndIf
				If lExc2Pe //Exclusão direta da DT6 para o CTRC do 1º Percurso.
					RecLock("DT6",.F.)
					DT6->( DbDelete() )
					MsUnLock()
				EndIf
				//////////////////////////////////////////////////////////////////////
				aCab	:= {}
				cPedido	:= ''
				If aDelDocto[ nCntFor, 3 ] == 'PED'
					cPedido := aDelDocto[ nCntFor, 2 ]
				Else
					//////////////////////////////////////////////////////////////////////
					//-- Guarda o nr. do pedido de venda gerado para a geracao de conhecimento de frete
					cAliasQry := GetNextAlias()
					cQuery := "   SELECT C9_PEDIDO "
					cQuery += "     FROM " + RetSqlName("SC9") + " SC9 "
					cQuery += "    WHERE SC9.C9_FILIAL  = '" + xFilial("SC9") + "' "
					cQuery += "      AND SC9.C9_SERIENF = '" + DT6->DT6_SERIE + "' "
					cQuery += "      AND SC9.C9_NFISCAL = '" + DT6->DT6_DOC + "' "
					cQuery += "      AND SC9.D_E_L_E_T_ = ' ' "
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
					If (cAliasQry)->(!Eof())
						cPedido := (cAliasQry)->C9_PEDIDO
					EndIf
					(cAliasQry)->(DbCloseArea())
					//////////////////////////////////////////////////////////////////////
					//-- Estorna documentos
					lRet := TMSDelNFS( aDelDocto[ nCntFor, 2 ], aDelDocto[ nCntFor, 3 ] )
				EndIf

				//////////////////////////////////////////////////////////////////////
				//-- Posiciona movimento de viagem.
				cAliasQry := GetNextAlias()
				cQuery := " SELECT R_E_C_N_O_ DUD_RECNO "
				cQuery += "   FROM " + RetSqlName("DUD") + " DUD "
				cQuery += "  WHERE DUD.DUD_FILIAL = '" + xFilial('DUD') + "' "
				cQuery += "    AND DUD.DUD_FILDOC = '" + DT6->DT6_FILDOC + "' "
				cQuery += "    AND DUD.DUD_DOC    = '" + DT6->DT6_DOC + "' "
				cQuery += "    AND DUD.DUD_SERIE  = '" + DT6->DT6_SERIE + "' "
				cQuery += "    AND DUD.DUD_FILORI = '" + cFilAnt + "' "
				cQuery += "    AND DUD.D_E_L_E_T_ = ' ' "
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
				If (cAliasQry)->(!Eof())
					DUD->(MsGoto( (cAliasQry)->DUD_RECNO ))
					RecLock('DUD',.F.)
					DUD->( DbDelete() )
					MsUnLock()
				EndIf
				(cAliasQry)->(DbCloseArea())
				//////////////////////////////////////////////////////////////////////

				//-- Estorna a composicao de frete do documento
				cAliasQry := GetNextAlias()
				cQuery := " SELECT R_E_C_N_O_ DT8_RECNO "
				cQuery += "   FROM " + RetSqlName("DT8") + " DT8 "
				cQuery += "  WHERE DT8.DT8_FILIAL = '" + xFilial('DT8') + "' "
				cQuery += "    AND DT8.DT8_FILDOC = '" + DT6->DT6_FILDOC + "' "
				cQuery += "    AND DT8.DT8_DOC    = '" + DT6->DT6_DOC + "' "
				cQuery += "    AND DT8.DT8_SERIE  = '" + DT6->DT6_SERIE + "' "
				cQuery += "    AND DT8.D_E_L_E_T_ = ' ' "
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
				While (cAliasQry)->(!Eof())
					DT8->(MsGoto((cAliasQry)->DT8_RECNO))
					RecLock('DT8',.F.)
					DT8->(DbDelete())
					MsUnLock()
					(cAliasQry)->(DbSkip())
				EndDo
				(cAliasQry)->(DbCloseArea())
				//////////////////////////////////////////////////////////////////////

				//-- Estorna pedidos de venda, gerados para o conhecimento de frete
				If !Empty(cPedido)
					AAdd( aCab, { 'C5_NUM', cPedido, Nil } )
					TMSPedido( aCab, , 5 )
				EndIf

				//-- Estorna averbacao de seguro
				DU7->(DbSetOrder(1)) //DU7_FILIAL+DU7_FILDOC+DU7_DOC+DU7_SERIE
				While DU7->(MsSeek(xFilial('DU7') + DT6->DT6_FILDOC + DT6->DT6_DOC + DT6->DT6_SERIE))
					RecLock('DU7',.F.)
					DU7->(DbDelete())
					MsUnLock()
				EndDo

				//--Atualização do status do estorno da averbação de seguro na tabela DL5 para NFS normal e/ou NFS de reentrega
				If FindFunction ("AvbeGrvCte") .AND. AliasInDic("DL5") .AND. (DT6->DT6_DOCTMS $ "5D")
					AvbeGrvCte( DT6->DT6_FILDOC, DT6->DT6_DOC, DT6->DT6_SERIE,DT6->DT6_DATEMI,DT6->DT6_HOREMI,'102',DT6->DT6_DOCTMS, DT6->DT6_CLIDEV, DT6->DT6_LOJDEV)
				EndIF

				//////////////////////////////////////////////////////////////////////
				//-- Apaga o numero do documento da nota fiscal do cliente
				cAliasQry := GetNextAlias()
				cQuery := " SELECT DTC_CLICAL, DTC_LOJCAL, DTC_SERVIC, DTC_TIPFRE, DTC_SERTMS, DTC_FILDOC, DTC_DOC, DTC_SERIE, "
				cQuery += "        DTC_LOTNFC, DTC_DOCPER, DTC_FILORI, DTC_CLIREM, DTC_LOJREM, DTC_CLIDES, "
				cQuery += "        DTC_LOJDES, DTC_SERVIC, DTC_NUMNFC, DTC_SERNFC, DTC_CODPRO, R_E_C_N_O_ DTC_RECNO "
				cQuery += ",DTC_CODNEG "

				cQuery += "   FROM " + RetSqlName("DTC") + " DTC "
				cQuery += "  WHERE DTC.DTC_FILIAL = '" + xFilial('DTC')  + "' "
				cQuery += "    AND DTC.DTC_FILDOC = '" + DT6->DT6_FILDOC + "' "
				If lExc2Pe
					cQuery += "    AND ((DTC.DTC_DOC    = '" + DT6->DT6_DOC    + "' "
					cQuery += "    AND   DTC.DTC_SERIE  = '" + DT6->DT6_SERIE  + "') "
					cQuery += "     OR   DTC.DTC_DOCPER = '" + DT6->DT6_DOC    + "') "
				Else
					cQuery += "    AND DTC.DTC_DOC    = '" + DT6->DT6_DOC    + "' "
					cQuery += "    AND DTC.DTC_SERIE  = '" + DT6->DT6_SERIE  + "' "
				EndIf
				cQuery += "    AND DTC.D_E_L_E_T_ = ' ' "
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
				While (cAliasQry)->(!Eof())
					aContrt := TMSContrat( (cAliasQry)->DTC_CLICAL, (cAliasQry)->DTC_LOJCAL, , (cAliasQry)->DTC_SERVIC, .F., (cAliasQry)->DTC_TIPFRE,,,,,,,,,,,,,,,,(cAliasQry)->DTC_CODNEG )
					DTC->(MsGoto((cAliasQry)->DTC_RECNO))
					cLotAnt := (cAliasQry)->DTC_LOTNFC

					//-- Carga Fechada - Estorna ocorrencia de entrega automatica,
					//   Estorna geracao automatica de viagens e atualizacao do status do documento.
					If lTmsCFec .And. (cAliasQry)->DTC_SERTMS == StrZero(3,Len((cAliasQry)->DTC_SERTMS)) //-- Entrega
						A200EstCFec(DT6->DT6_FILDOC, DT6->DT6_DOC, DT6->DT6_SERIE)
					EndIf

					RecLock('DTC',.F.)
					If	! Empty( cLotEst )
						DTC->DTC_LOTNFC := cLotEst
					EndIf
					DTC->DTC_FILDOC := Space(Len(DTC->DTC_FILDOC))
					DTC->DTC_DOC    := Space(Len(DTC->DTC_DOC))
					DTC->DTC_SERIE  := Space(Len(DTC->DTC_SERIE))
					DTC->DTC_DOCPER := Space(Len(DTC->DTC_DOCPER))
					DTC->DTC_NFELET := Space(Len(DTC->DTC_NFELET))
					DTC->DTC_EMINFE := CtoD('  /  /  ')
					DTC->DTC_CODNFE := Space(Len(DTC->DTC_CODNFE))
					If ! Empty( aContrt )
						If aContrt[ 1, 21 ] == StrZero(2,Len(AAM->AAM_SELSER)) //-- Servico Automatico
							DTC->DTC_SERVIC := Space(Len(DTC->DTC_SERVIC))
						EndIf
					EndIf
					MsUnLock()

					//-- Exclui as chaves dos Documentos de Subcontratação
					If TableInDic("DLR") .And. !Empty(cIsenSub)
						DLR->(DbSetOrder(1))
						DLR->(MsSeek(xFilial('DLR')+DT6->DT6_FILDOC+DT6->DT6_DOC+DT6->DT6_SERIE))
						While DLR->(!Eof()) .And. DLR->(DLR_FILIAL+DLR_FILDOC+DLR_DOC+DLR_SERIE) == xFilial('DLR')+DT6->(DT6_FILDOC+DT6_DOC+DT6_SERIE)
							RecLock('DLR',.F.)
							dbDelete()
							MsUnLock()
							DLR->(dbSkip())
						EndDo
					EndIf

					//--Muda os componentes de valor informado de lote
					If !Empty(cLotEst)
						cAliasDVR := GetNextAlias()
						cQuery := "   SELECT R_E_C_N_O_ DVR_RECNO "
						cQuery += "     FROM " + RetSqlName("DVR")  + " DVR "
						cQuery += "    WHERE DVR.DVR_FILIAL = '" + xFilial('DVR') + "' "
						cQuery += "      AND DVR.DVR_FILORI = '" + (cAliasQry)->DTC_FILORI + "' "
						cQuery += "      AND DVR.DVR_LOTNFC = '" + cLotAnt + "' "
						cQuery += "      AND DVR.DVR_CLIREM = '" + (cAliasQry)->DTC_CLIREM + "' "
						cQuery += "      AND DVR.DVR_LOJREM = '" + (cAliasQry)->DTC_LOJREM + "' "
						cQuery += "      AND DVR.DVR_CLIDES = '" + (cAliasQry)->DTC_CLIDES + "' "
						cQuery += "      AND DVR.DVR_LOJDES = '" + (cAliasQry)->DTC_LOJDES + "' "
						cQuery += "      AND DVR.DVR_SERVIC = '" + (cAliasQry)->DTC_SERVIC + "' "
						cQuery += "      AND DVR.DVR_NUMNFC = '" + (cAliasQry)->DTC_NUMNFC + "' "
						cQuery += "      AND DVR.DVR_SERNFC = '" + (cAliasQry)->DTC_SERNFC + "' "
						cQuery += "      AND DVR.DVR_CODPRO = '" + (cAliasQry)->DTC_CODPRO + "' "
						cQuery += "      AND DVR.DVR_CODNEG = '" + (cAliasQry)->DTC_CODNEG + "' "
						cQuery += "      AND D_E_L_E_T_ = ' ' "
						cQuery := ChangeQuery(cQuery)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDVR)
						While (cAliasDVR)->(!Eof())
							DVR->(MsGoto( (cAliasDVR)->DVR_RECNO ))
							RecLock('DVR',.F.)
							DVR->DVR_LOTNFC := cLotEst
							MsUnLock()
							(cAliasDVR)->(DbSkip())
						EndDo
						(cAliasDVR)->(DbCloseArea())
					EndIf

					//--Muda os tipos de veículo de lote
					If !Empty(cLotEst)
						cAliasDVU := GetNextAlias()
						cQuery := "   SELECT R_E_C_N_O_ DVU_RECNO "
						cQuery += "     FROM " + RetSqlName("DVU")  + " DVU "
						cQuery += "    WHERE DVU.DVU_FILIAL = '" + xFilial('DVU') + "' "
						cQuery += "      AND DVU.DVU_FILORI = '" + (cAliasQry)->DTC_FILORI + "' "
						cQuery += "      AND DVU.DVU_LOTNFC = '" + cLotAnt + "' "
						cQuery += "      AND DVU.DVU_CLIREM = '" + (cAliasQry)->DTC_CLIREM + "' "
						cQuery += "      AND DVU.DVU_LOJREM = '" + (cAliasQry)->DTC_LOJREM + "' "
						cQuery += "      AND DVU.DVU_NUMNFC = '" + (cAliasQry)->DTC_NUMNFC + "' "
						cQuery += "      AND DVU.DVU_SERNFC = '" + (cAliasQry)->DTC_SERNFC + "' "
						cQuery += "      AND D_E_L_E_T_ = ' ' "
						cQuery := ChangeQuery(cQuery)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDVU)
						While (cAliasDVU)->(!Eof())
							DVU->(MsGoto( (cAliasDVU)->DVU_RECNO ))
							RecLock('DVU',.F.)
							DVU->DVU_LOTNFC := cLotEst
							MsUnLock()
							(cAliasDVU)->(DbSkip())
						EndDo
						(cAliasDVU)->(DbCloseArea())
					EndIf

					// If lTM200Exc
					// 	ExecBlock('TM200EXC',.F.,.F.)
					// EndIf
					(cAliasQry)->(DbSkip())
				EndDo
				(cAliasQry)->(DbCloseArea())
				//////////////////////////////////////////////////////////////////////
				//-- Atualiza campo DTC_DOCREE
				If !Empty(DT6->DT6_FILDCO) .AND. !Empty(DT6->DT6_DOCDCO) //verifica se eh doc de reentrega/devolucao
					If FindFunction("TmsPsqDY4") .And. TmsPsqDY4( DT6->DT6_FILDOC, DT6->DT6_DOC, DT6->DT6_SERIE ) .AND. lDTCRee
						If FindFunction('A360AtuRee')
							A360AtuRee(DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE, .T./*Estorno*/)
						EndIf
					Endif
				EndIf
				//////////////////////////////////////////////////////////////////////



				//-- Excluir DY4 caso seja reentrega
				If !Empty(DT6->DT6_FILDCO) .AND. !Empty(DT6->DT6_DOCDCO) // Verifica se eh doc de reentrega/devolucao
					If FindFunction("TmsPsqDY4") .And. TmsPsqDY4( DT6->DT6_FILDOC, DT6->DT6_DOC, DT6->DT6_SERIE )
						DY4->(DbSetOrder(1))
						While DY4->(MsSeek(xFilial("DY4") + DT6->DT6_FILDOC + DT6->DT6_DOC + DT6->DT6_SERIE))
							RecLock("DY4",.F.)
							DY4->(DbDelete())
							MsUnLock()
						EndDo
					Endif
				EndIf
				//-- CTRC Complemento, excluir a digitacao do Valor informado x Complemento
				DbSelectArea("DT6")
				If	DT6->DT6_DOCTMS == StrZero(8,Len(DT6->DT6_DOCTMS))
					DVS->(DbSetOrder(1))
					While DVS->(MsSeek(xFilial("DVS") + DT6->DT6_FILDOC + DT6->DT6_DOC + DT6->DT6_SERIE))
						RecLock("DVS",.F.)
						DVS->(DbDelete())
						MsUnLock()
					EndDo
					//Estorna a observacao
					If !Empty(DT6->DT6_CODOBS)
						MSMM(DT6->DT6_CODOBS,,,,2,,,"DT6","DT6_CODOBS")
					EndIf
				EndIf

				//--Se for CRT Complemento nao pode excluir o CRT pesquisando pelo Lote
				//--pois no CRT Complemento o lote e o mesmo do documento original
				//--O CRT Complemento nao tem DIK, somente DT6 e tabelas relacionadas
				If DT6->DT6_TIPTRA == '4' .And. DT6->DT6_DOCTMS != Replicate('L',Len(DT6->DT6_DOCTMS)) //-- Rodoviario Internacional, se nao for CRT Complemento
					//-- Exclui documentos do cliente para transporte do CRT - Conhecimento Internacional
					DIK->(DbSetOrder(1)) //DIK_FILIAL+DIK_FILORI+DIK_LOTNFC
					If DIK->(MsSeek(xFilial('DIK')+DT6->(DT6_FILORI+DT6_LOTNFC)))
						If DIK->DIK_STATUS != '9' //--Cancelado
							DIN->(DbSetOrder(1))
							DIN->(MsSeek(xFilial('DIN')+DT6->(DT6_FILORI+DT6_LOTNFC)))
							While DIN->(!Eof()) .And. DIN->(DIN_FILIAL+DIN_FILORI+DIN_LOTNFC) == xFilial('DIN')+DT6->(DT6_FILORI+DT6_LOTNFC)
								RecLock('DIN',.F.)
								dbDelete()
								MsUnLock()
								DIN->(dbSkip())
							EndDo
							//-- Exclui Frete CIF/FOB
							DIA->(DbSetOrder(1))
							DIA->(MsSeek(xFilial('DIA')+DT6->(DT6_FILORI+DT6_LOTNFC)))
							While DIA->(!Eof()) .And. DIA->(DIA_FILIAL+DIA_FILORI+DIA_LOTNFC) == xFilial('DIA')+DT6->(DT6_FILORI+DT6_LOTNFC)
								RecLock('DIA',.F.)
								dbDelete()
								MsUnLock()
								DIA->(dbSkip())
							EndDo
							//-- Frete por pais
							DI9->(DbSetOrder(1))
							DI9->(MsSeek(xFilial('DI9')+DT6->(DT6_FILORI+DT6_LOTNFC)))
							While DI9->(!Eof()) .And. DI9->(DI9_FILIAL+DI9_FILORI+DI9_LOTNFC) == xFilial('DIA')+DT6->(DT6_FILORI+DT6_LOTNFC)
								RecLock('DI9',.F.)
								dbDelete()
								MsUnLock()
								DI9->(dbSkip())
							EndDo
							//-- Exclui CRT
							RecLock('DIK',.F.)
							dbDelete()
							MsUnLock()
						EndIf
					EndIf
				EndIf

				If !(DT6->DT6_IDRCTE $ '100/101/102') .And. !Empty(DT6->DT6_CHVCTE) //Limpa os campos das tabelas SF3 e SFT (F3_CHVNFE, FT_CHVNFE) quando o documento foi gerando Chave não foi transmitido. Nos casos de inutilização não teremos problemas na geração do sped
					dbSelectArea("SF3")
					SF3->(DbSetOrder(4)) //F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE
					If	SF3->(DbSeek(xFilial("SF3")+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV+DT6->DT6_DOC+DT6->DT6_SERIE))
						RecLock("SF3",.F.)
						SF3->F3_CHVNFE := ""
						MsUnlock()
					EndIf
					dbSelectArea("SFT")
					SFT->(dbSetOrder(1))
					If SFT->(Dbseek(xFilial("SFT")+"S"+DT6->DT6_SERIE+DT6->DT6_DOC+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV))
						While SFT->(!Eof()) .And. SFT->(FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA)  == DT6->DT6_FILDOC+"S"+DT6->(DT6_SERIE+DT6_DOC+DT6_CLIDEV+DT6_LOJDEV)
							RecLock("SFT",.F.)
							SFT->FT_CHVNFE := ""
							MsUnlock()
							SFT->(DbSkip())
						EndDo
					EndIf
				EndIf
				//-- Estorna dados da Operação do Documento da Viagem em Transito (DLT e DTW)
				If lEstDLT
					aAreaDT6:= DT6->(GetArea())
					TMSA351Exc(DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE,DTP->DTP_FILORI,DTP->DTP_VIAGEM)
					RestArea(aAreaDT6)
				EndIf
				RecLock('DT6',.F.)
				DT6->(DbDelete())
				MsUnLock()
			EndIf
		Next

		If lRet .And. lCTECan .And. lGerLot
				nQdtDTC := TMSA200STU(cLotNfc, cFilAnt)
			If nQdtDTC <> 0 .And. nQdtDTC = nQtdDig
				DTP->(dbSetOrder(2)) //DTP_FILIAL+DTP_FILORI+DTP_LOTNFC
				If	DTP->(MsSeek(xFilial("DTP")+cFilAnt+cLotNfc))
					RecLock('DTP',.F.)
					DTP->DTP_STATUS := StrZero(2,Len(DTP->DTP_STATUS))
					MsUnLock()
				EndIf
			EndIf
		ElseIf lRet .And. lCTECan .And. !lGerLot
				nQdtDTC := TMSA200STU(cLotNfc, cFilAnt)
			If nQdtDTC <> 0
				DTP->(dbSetOrder(2)) //DTP_FILIAL+DTP_FILORI+DTP_LOTNFC
				If	DTP->(MsSeek(xFilial("DTP")+cFilAnt+cLotNfc))
					RecLock('DTP',.F.)
					DTP->DTP_STATUS := StrZero(2,Len(DTP->DTP_STATUS))
					MsUnLock()
				EndIf
			EndIf
		EndIf

		//-- Exclusao CTE somente apos envio e autorizacao da SEFAZ - Exibe Help se existem cancelamentos aguardando autorizacao SEFAZ!
		If	lTMSCTe .And. lCTECan .And. lHelpCte
			//Help(' ', 1, 'TMSA20042') //"Cancelamento sem autorizacao da SEFAZ"
		EndIf
	EndIf

	RestArea( aAreaDTC )
	RestArea( aAreaAnt )

	Return( lRet )

	/*/-----------------------------------------------------------
	{Protheus.doc} TMSA200STU()
	Retorna a quantidade de Notas Fiscais do lote.

	Uso: TMSA200

	@sample
	//TMSA200STU()

	@author Fabio Marchiori Sampaio.
	@since 14/04/2015
	@version 1.0
	-----------------------------------------------------------/*/

Static Function TMSA200STU(cLotNfc, cFilOri)

		Local cAliasQry	:= GetNextAlias()
		Local nQdtDtc		:= 0

		cQuery := "   SELECT COUNT(*) nQdtLot  "
		cQuery += "       FROM " + RetSqlName("DTC") + " DTC "
		cQuery += "    WHERE DTC.DTC_FILIAL = '" + xFilial('DTC') + "' "
		cQuery += "      AND DTC.DTC_FILORI = '" + cFilOri + "' "
		cQuery += "      AND DTC.DTC_LOTNFC = '" + cLotNfc + "' "
		cQuery += "      AND DTC.DTC_DOC 	 = ' ' "
		cQuery += "      AND DTC.D_E_L_E_T_ = ' ' "
		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)

		nQdtDtc := (cAliasQry)->nQdtLot

		(cAliasQry)->(DbCloseArea())

	Return(nQdtDtc)


	
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A200EstCFec³ Autor ³ Eduardo de Souza     ³ Data ³ 03/08/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Carga Fechada - Estorno de Ocorrencias / Status da Viagem  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A200EstCFec()                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 - Filial Documento                                   ³±±
±±³          ³ ExpC2 - Documento                                          ³±±
±±³          ³ ExpC3 - Serie Documento                                    ³±±
±±³          ³ ExpC4 - Filial Viagem Coleta                               ³±±
±±³          ³ ExpC5 - Viagem de Coleta                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TMSAF05                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A200EstCFec(cFilDoc,cDocto,cSerie)

Local aCabDUA    := {}
Local aItens     := {}
Local aAgend     := {}
Local cQuery     := ""
Local cAliasDUD  := GetNextAlias()
Local cAliasDTC  := GetNextAlias()
Local aAreaDTC   := DTC->(GetArea())
Local aAreaDT6   := DT6->(GetArea())
Local cFilDT5    := xFilial('DT5')
Local cFilDF1    := xFilial("DF1")
Local cFilDF0    := xFilial("DF0")
Local lPlanejada := .F.
Local nCnt       := 0
Local cOcorCan   := PadR(GetMV("MV_OCORCAN",   ,""),Len(DT2->DT2_CODOCO))  //-- Ocorrencia de Cancelamento p/ Viagem de Coleta Planejada em aberto
Local cCodOco    := PadR(GetMV("MV_OCORENT",.F.,""),Len(DT2->DT2_CODOCO))
Local cSeekDT5   := ""
Local cFilCol    := ""
Local cVgeCol    := ""

//-- Estorna a ocorrencia de Cancelamento automatico da viagem de coleta planejada.
	If	!Empty(cOcorCan) .And. !Empty(DTC->DTC_NUMSOL) .And. ;
	!Empty(DTC->DTC_DATCOL) .And. !Empty(DTC->DTC_HORCOL)

	DT5->(DbSetOrder(1)) //DT5_FILIAL+DT5_FILORI_DT5_NUMSOL
	DF1->(DbSetOrder(3)) //DF1_FILIAL+DF1_FILDOC+DF1_DOC+DF1_SERIE
	DTQ->(dbSetOrder(2)) //DTQ_FILIAL+DTQ_VIAGEM
			If !Empty(cFilDF1)
		cFilDF1 := DTC->DTC_FILCFS
		EndIf
	DT5->(DbSetOrder(1))
		If !Empty(DTC->DTC_FILCFS)
		cFilDT5  := IIf(Empty(cFilDT5), cFilDT5, DTC->DTC_FILCFS)
		cSeekDT5 := cFilDT5+DTC->DTC_FILCFS+DTC->DTC_NUMSOL
		Else
		cSeekDT5 := cFilDT5+DTC->DTC_FILORI+DTC->DTC_NUMSOL
		EndIf
		If DT5->(MsSeek(cSeekDT5))
		DUD->(DbSetOrder(1)) //DUD_FILIAL+DUD_FILDOC+DUD_DOC+DUD_SERIE+DUD_FILORI+DUD_VIAGEM
		cQuery := "SELECT DUD_FILORI, DUD_VIAGEM, DUD_STATUS "
		cQuery += "  FROM "+RetSQLName("DUD")
		cQuery += " WHERE DUD_FILIAL = '"+xFilial('DUD') +"'"
		cQuery += "   AND DUD_FILDOC = '"+DT5->DT5_FILDOC+"'"
		cQuery += "   AND DUD_DOC    = '"+DT5->DT5_DOC   +"'"
		cQuery += "   AND DUD_SERIE  = '"+DT5->DT5_SERIE +"'"
		cQuery += "   AND D_E_L_E_T_ = ' '"
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDUD)
			While (cAliasDUD)->(!Eof())
				If	(cAliasDUD)->DUD_STATUS == StrZero(9,Len(DUD->DUD_STATUS)) //-- Cancelado
					If	DTQ->(MsSeek(xFilial("DTQ")+(cAliasDUD)->DUD_FILORI+(cAliasDUD)->DUD_VIAGEM))
						If	DTQ->DTQ_TIPVIA == StrZero(3, Len(DTQ->DTQ_TIPVIA)) .And.;	//-- Planejada
						DTQ->DTQ_STATUS == StrZero(9, Len(DTQ->DTQ_STATUS))		//-- Cancelado
						cFilCol := (cAliasDUD)->DUD_FILORI
						cVgeCol := (cAliasDUD)->DUD_VIAGEM
						EndIf
					EndIf
				Exit
				EndIf
			(cAliasDUD)->(DbSkip())
			EndDo
		EndIf

	//-- Estorna ocorrencia de cancelamento automatico
		If !Empty(cFilCol) .And. !Empty(cVgeCol)
		DUA->(dbSetOrder(3))
			If DUA->(MsSeek(xFilial("DUA")+cOcorCan+DT5->DT5_FILDOC+DT5->DT5_DOC+DT5->DT5_SERIE))
			//-- Cabecalho da Ocorrencia
			AAdd(aCabDUA,	{"DUA_FILOCO", DUA->DUA_FILOCO , Nil})
			AAdd(aCabDUA,	{"DUA_NUMOCO", DUA->DUA_NUMOCO , Nil})
			AAdd(aCabDUA,	{"DUA_FILORI", DUA->DUA_FILORI , Nil})
			AAdd(aCabDUA,	{"DUA_VIAGEM", DUA->DUA_VIAGEM , Nil})
			//-- Itens da Ocorrencia
			AAdd(aItens, {	{"DUA_SEQOCO", DUA->DUA_SEQOCO , Nil},;
							{"DUA_ESTOCO", StrZero( 1, TamSX3("DUA_ESTOCO")[1]), Nil},;
							{"DUA_DATOCO", DUA->DUA_DATOCO , Nil},;
							{"DUA_HOROCO", DUA->DUA_HOROCO , Nil},;
							{"DUA_CODOCO", DUA->DUA_CODOCO , Nil},;
							{"DUA_RECEBE", DUA->DUA_RECEBE , Nil},;
							{"DUA_SERTMS", DUA->DUA_SERTMS , Nil},;
							{"DUA_FILDOC", DUA->DUA_FILDOC , Nil},;
							{"DUA_DOC"   , DUA->DUA_DOC    , Nil},;
							{"DUA_SERIE" , DUA->DUA_SERIE  , Nil},;
							{"DUA_QTDOCO", DUA->DUA_QTDOCO , Nil},;
							{"DUA_PESOCO", DUA->DUA_PESOCO , Nil}})
			//-- Estorno da Ocorrencia
			MsExecAuto({|w,x,y,z|Tmsa360(w,x,y,z)},aCabDUA,aItens,{},6)

			//-- Atualiza o Status da coleta no Agendamento.
			DF1->(dbSetOrder(3)) //DF1_FILIAL+DF1_FILDOC+DF1_DOC+DF1_SERIE
				If DF1->(MsSeek(xFilial("DF1")+DT5->DT5_FILDOC+DT5->DT5_DOC+DT5->DT5_SERIE))
				RecLock("DF1",.F.)
				DF1->DF1_STACOL := StrZero(3,Len(DF1->DF1_STAENT)) //-- Planejado
				MsUnlock()
				EndIf
			EndIf
		cSeekDT5:= ""
		EndIf
	EndIf

//-- Carga Fechada - Estorna ocorrencia de entrega automatica
	If !Empty(DTC->DTC_DTENTR) .And. !Empty(DTC->DTC_HORENT)
	DUA->(dbSetOrder(3)) //DUA_FILIAL+DUA_CODOCO+DUA_FILDOC+DUA_DOC+DUA_SERIE
		If DUA->(MsSeek(xFilial("DUA")+cCodOco+DTC->DTC_FILDOC+DTC->DTC_DOC+DTC->DTC_SERIE))
		//-- Cabecalho da Ocorrencia
		AAdd(aCabDUA,	{"DUA_FILOCO", DUA->DUA_FILOCO , Nil})
		AAdd(aCabDUA,	{"DUA_NUMOCO", DUA->DUA_NUMOCO , Nil})
		AAdd(aCabDUA,	{"DUA_FILORI", DUA->DUA_FILORI , Nil})
		AAdd(aCabDUA,	{"DUA_VIAGEM", DUA->DUA_VIAGEM , Nil})
		//-- Itens da Ocorrencia
		AAdd(aItens, {	{"DUA_SEQOCO", DUA->DUA_SEQOCO , Nil},;
						{"DUA_ESTOCO", StrZero( 1, TamSX3("DUA_ESTOCO")[1]), Nil},;
						{"DUA_DATOCO", DUA->DUA_DATOCO , Nil},;
						{"DUA_HOROCO", DUA->DUA_HOROCO , Nil},;
						{"DUA_CODOCO", DUA->DUA_CODOCO , Nil},;
						{"DUA_RECEBE", DUA->DUA_RECEBE , Nil},;
						{"DUA_SERTMS", DUA->DUA_SERTMS , Nil},;
						{"DUA_FILDOC", DUA->DUA_FILDOC , Nil},;
						{"DUA_DOC"   , DUA->DUA_DOC    , Nil},;
						{"DUA_SERIE" , DUA->DUA_SERIE  , Nil},;
						{"DUA_QTDOCO", DUA->DUA_QTDOCO , Nil},;
						{"DUA_PESOCO", DUA->DUA_PESOCO , Nil}})
		//-- Estorno da Ocorrencia
		MsExecAuto({|w,x,y,z|Tmsa360(w,x,y,z)},aCabDUA,aItens,{},6)
		EndIf
	EndIf

//-- Atualiza o Status da entrega no Agendamento.
DT5->(DbSetOrder(1)) //DT5_FILIAL+DT5_FILORI_DT5_NUMSOL
DF1->(DbSetOrder(3)) //DF1_FILIAL+DF1_FILDOC+DF1_DOC+DF1_SERIE
DTC->(DbSetOrder(3)) //DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE+DTC_SERVIC+DTC_CODPRO
cQuery := "SELECT DTC_FILCFS, DTC_FILORI, DTC_NUMSOL "
cQuery += "  FROM "+RetSQLName("DTC")
cQuery += " WHERE DTC_FILIAL  = '"+xFilial('DTC')+"'"
cQuery += "   AND DTC_FILDOC  = '"+cFilDoc+"'"
cQuery += "   AND DTC_DOC     = '"+cDocto +"'"
cQuery += "   AND DTC_SERIE   = '"+cSerie +"'"
cQuery += "   AND D_E_L_E_T_  = ' '"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDTC)
	While (cAliasDTC)->(!Eof())
		If !Empty((cAliasDTC)->DTC_FILCFS)
		cFilDT5  := IIf(Empty(cFilDT5), cFilDT5, (cAliasDTC)->DTC_FILCFS)
		cSeekDT5 := cFilDT5+(cAliasDTC)->DTC_FILCFS+(cAliasDTC)->DTC_NUMSOL
		Else
		cSeekDT5 := cFilDT5+(cAliasDTC)->DTC_FILORI+(cAliasDTC)->DTC_NUMSOL
		EndIf
		If DT5->(MsSeek(cSeekDT5))
			If DF1->(MsSeek(xFilial("DF1")+DT5->DT5_FILDOC+DT5->DT5_DOC+DT5->DT5_SERIE))
				RecLock("DF1",.F.)
				DF1->DF1_STAENT := StrZero(2,Len(DF1->DF1_STAENT)) //-- Confirmado
				MsUnlock()
			// aAgend[n,1] = Numero Agendamento
			// aAgend[n,2] = Encerrado
			//-- Armazena o numero do agendamento para verificacao do encerramento (DF0_STATUS).
				If Ascan( aAgend, { |x| x[1] == DF1->DF1_NUMAGE } ) == 0
				AAdd( aAgend, { DF1->DF1_NUMAGE, .F. } )
				EndIf
			EndIf
		EndIf
	(cAliasDTC)->(DbSkip())
	EndDo
(cAliasDTC)->(dbCloseArea())

DF1->(DbSetOrder(1))
DF0->(DbSetOrder(1))
	If !Empty(cFilDF0) .And. !Empty(cFilDF1)
	cFilDF0 := DTC->DTC_FILCFS
	cFilDF1 := DTC->DTC_FILCFS
	EndIf
	For nCnt := 1 To Len(aAgend)
		If !aAgend[nCnt,2] //-- Encerrado
			If DF0->(MsSeek(cFilDF0+aAgend[nCnt,1]))
			RecLock("DF0",.F.)
			DF0->DF0_STATUS := cStatus := StrZero( 3, Len( DF0->DF0_STATUS ) )
			MsUnlock()
			EndIf
		EndIf
	Next nCnt

ResetArr(@aCabDUA    )
ResetArr(@aItens     )
ResetArr(@aAgend     )

RestArea( aAreaDT6 )
RestArea( aAreaDTC )
Return( .T. )


/*/{Protheus.doc} ResetArr
//TODO Descrição auto-gerada.
@author caio.y
@since 11/04/2018
@version 1.0
@return ${return}, ${return_description}
@param aAux, array, descricao
@type function
/*/
Static Function ResetArr(aAux , lOnlySize )

	Default aAux		:= {}
	Default lOnlySize	:= .F.

	aSize(aAux,0)

	If !lOnlySize
		aAux	:= Nil
	Else
		aAux	:= {}
	EndIf

Return