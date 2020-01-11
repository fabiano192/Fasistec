#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa CR0119
Autor 		: Fabiano da Silva	-	08/01/20
Uso 		: SIGAEEC
Descrição 	: Gerar relatório de Exportação
*/

#Define Verde "#9AFF9A"
#Define Amarelo "#FFFF00"
#Define Branco "#FFFAFA"
#Define Preto "#000000"
#Define Cinza "#696969"
#Define Mizu "#E8782F"
#Define POSDES 5
#Define POSTOT 9

USER FUNCTION CR0119()

	Local _oDlg				:= NIL
	Local _nOpc				:= 0

	Private _cTitulo    := "Documentos de Exportação - CR0119"

	Private _oPrinter	:= NIL
	Private _nTmPag 	:= 0
	Private _nLin		:= 0
	Private _nTamRod	:= 0
	private _nLinTot	:= 0
	Private _nCol		:= 0
	Private _nColTot	:= 0
	Private _nPosIRod	:= 0
	Private _aMargRel	:= {10,15,10,20}

	Private _cProc		:= 'Processando'
	Private _cMsgTit	:= 'Aguarde, gerando dados...'

	Private _oFont7N	:= TFont():New('Courier New'	,,-07,,.T.,,,,,.F.,.F.)
	Private _oFont8		:= TFont():New('Courier New'	,,-08,,.F.,,,,,.F.,.F.)
	Private _oFont8N	:= TFont():New('Courier New'	,,-08,,.T.,,,,,.F.,.F.)
	Private _oFont10	:= TFont():New('Courier New'	,,-10,,.F.,,,,,.F.,.F.)
	Private _oFont11	:= TFont():New('Courier New'	,,-11,,.F.,,,,,.F.,.F.)
	Private _oFont11N	:= TFont():New('Courier New'	,,-11,,.T.,,,,,.F.,.F.)
	Private _oFont13N	:= TFont():New('Courier New'	,,-13,,.T.,,,,,.F.,.F.)

	Private _nTLin		:= 10
	Private _aCabec		:= {}

	AtuSX1()

	DEFINE MSDIALOG _oDlg FROM 264,182 TO 435,500 TITLE _cTitulo OF _oDlg PIXEL

	_oGrupo	:= TGroup():New(005,005,045,155,"",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

	@ 010,015 SAY _oTSayA VAR "Esta rotina tem por objetivo gerar os  "	OF _oGrupo PIXEL Size 150,010 FONT _oFont11N
	@ 020,015 SAY "Documentos de Exportação conforme os"				OF _oGrupo PIXEL Size 150,010 FONT _oFont11N
	@ 030,015 SAY "parâmetros informados pelo usuário." 				OF _oGrupo PIXEL Size 150,010 FONT _oFont11N

	_oTBut1	:= TButton():New( 60,010, "Parâmetros" ,_oDlg,{||Pergunte("CR0119")},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )
	_cStyle := GetStyle(Amarelo,Branco,Cinza,Preto,1)
	_oTBut1:SetCss(_cStyle)

	_oTBut2	:= TButton():New( 60,068, "OK" ,_oDlg,{||_nOpc := 1,_oDlg:End()},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )
	_cStyle := GetStyle(Verde,Branco,Cinza,Preto,1)
	_oTBut2:SetCss(_cStyle)

	_oTBut3	:= TButton():New( 60,120, "Sair" ,_oDlg,{||_nOpc := 0,_oDlg:End()},035,012,,,.F.,.T.,.F.,,.F.,,,.F. )
	_cStyle := GetStyle(Branco,Mizu,Cinza,Preto,1)
	_oTBut3:SetCss(_cStyle)

	ACTIVATE MSDIALOG _oDlg CENTERED

	If _nOpc = 1

		Pergunte("CR0119",.f.)

		If MV_PAR02 = 1 .Or. MV_PAR02 = 2
			LjMsgRun(_cMsgTit,_cProc,{||CR119IN()})
		Endif
		If MV_PAR02 = 1 .Or. MV_PAR02 = 3
			LjMsgRun(_cMsgTit,_cProc,{||CR119PL()})
		Endif
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



Static Function CR119IN()

	Local _lAdjustToLegacy	:= .F.
	Local _lDisableSetup	:= .T.
	Local _cTitPDF			:= ''
	Local _cDir				:= GetTempPath()

		/*
	1 - Percentual do campo conforme tamanho total
	2 - Tamanho da coluna (calculado)
	3 - Posição Inicial da coluna (calculado)
	4 - Nome
	5 - Alinhamento Horizontal (0=Esquerda, 1=Direita, 2 = Centralizado)
	6 - Qtde a somar na posição inicial
	7 - Qtde a diminuir no tamanho da coluna
	8 - Campo que será impresso na coluna
	9 - Picture do campo
	10- Campo SubTotal
	11- Campo Total Geral
	*/
	_aCabec		:= {;
		{08,0,0,{'Cronnos','Code'}			,2,0,0,'PRODINT'	,'@!'				,''		,''	},;
		{10,0,0,{'Part','Number'}	        ,2,0,0,'PRODCLI'	,'@!'				,''		,''	},;
		{10,0,0,{'Purchase','Order'}        ,2,0,0,'PEDICLI'	,'@!'				,''		,''	},;
		{09,0,0,{'HTS'}		                ,2,0,0,'NCM'	    ,'@!'				,''		,''	},;
		{28,0,0,{'D E S C R I P T I O N'}	,0,3,0,'DESCPRO'	,'@!'				,''		,''	},;
		{10,0,0,{'QTY'}						,1,0,3,'QUANTI'		,"@E 9.999.999,99"	,''		,''	},;
		{05,0,0,{'UM'}						,2,0,0,'UM'			,"@!"				,''		,''	},;
		{10,0,0,{'Unit','Price'}			,1,0,3,'PRCUNI'		,"@E 9.999.999,99"	,''		,''	},;
		{10,0,0,{'Total'}					,1,0,3,'PRCTOT'		,"@E 9.999.999,99"	,''		,''	}}

	_nTamRod	:= 210

	If Select("TEXP") > 0
		TEXP->(dbCloseArea())
	Endif

	_cQuery := " SELECT " +CRLF
	_cQuery += " 'NOMEEXP' = SA2.A2_NOME, " +CRLF
	_cQuery += " 'END1EXP' = (RTRIM(SA2.A2_END)+','+RTRIM(SA2.A2_NR_END)), " +CRLF
	_cQuery += " 'END2EXP' = (RTRIM(SA2.A2_MUN)+'-'+RTRIM(SA2.A2_EST)+' '+RTRIM(YA2.YA_NOIDIOM)), " +CRLF
	_cQuery += " 'CEPEXP'  = LEFT(SA2.A2_CEP,5)+'-'+RIGHT(SA2.A2_CEP,3), " +CRLF
	_cQuery += " 'FONEEXP' = RTRIM(SA2.A2_DDI)+' '+RTRIM(SA2.A2_DDD)+' '+RTRIM(SA2.A2_TEL), " +CRLF
	_cQuery += " 'FAXEXP'  = RTRIM(SA2.A2_DDI)+' '+RTRIM(SA2.A2_DDD)+' '+RTRIM(SA2.A2_FAX), " +CRLF
	_cQuery += " SA1A.A1_SUPCODE AS 'SUPCODE', " +CRLF
	_cQuery += " RTRIM(EEC.EEC_PREEMB) AS 'PROCESSO', " +CRLF
	_cQuery += " (SUBSTRING(EEC.EEC_DTINVO,5,2)+'/'+RIGHT(EEC.EEC_DTINVO,2)+'/'+LEFT(EEC.EEC_DTINVO,4)) AS 'DTPROCES', " +CRLF
	_cQuery += " 'NOMEIMP' = (RTRIM(SA1A.A1_NOME)), " +CRLF
	_cQuery += " 'END1IMP' = (RTRIM(SA1A.A1_ADDRESS)+' - '+RTRIM(SA1A.A1_CITY)+'-'+RTRIM(SA1A.A1_STATE)), " +CRLF
	_cQuery += " 'END2IMP' = (RTRIM(SA1A.A1_POSCODE)+' - '+RTRIM(YA1.YA_NOIDIOM)), " +CRLF
	_cQuery += " 'NOMECON' = CASE WHEN COALESCE(EEC_CONSIG,'') = '' THEN RTRIM(SA1A.A1_NOME) ELSE RTRIM(SA1B.A1_NOME) END, " +CRLF
	_cQuery += " 'END1CON' = CASE WHEN COALESCE(EEC_CONSIG,'') = '' THEN RTRIM(SA1A.A1_ADDRESS)+' - '+RTRIM(SA1A.A1_CITY)+'-'+RTRIM(SA1A.A1_STATE) ELSE RTRIM(SA1B.A1_ADDRESS)+' - '+RTRIM(SA1B.A1_CITY)+'-'+RTRIM(SA1B.A1_STATE) END, " +CRLF
	_cQuery += " 'END2CON' = CASE WHEN COALESCE(EEC_CONSIG,'') = '' THEN RTRIM(SA1A.A1_POSCODE)+' - '+RTRIM(YA1.YA_NOIDIOM) ELSE RTRIM(SA1B.A1_POSCODE)+' - '+RTRIM(YA3.YA_NOIDIOM) END, " +CRLF
	_cQuery += " 'BILLTO1' = (SELECT (CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='001' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE  " +CRLF
	_cQuery += " 				UPPER(IIF(CHARINDEX('\13\10',(CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='001' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE UPPER((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='001' AND D_E_L_E_T_='')) END)) = 0, " +CRLF
	_cQuery += " 				(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='001' AND D_E_L_E_T_=''), " +CRLF
	_cQuery += " 				LEFT((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='001' AND D_E_L_E_T_=''),CHARINDEX('\13\10',(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='001' AND D_E_L_E_T_=''))-1))) " +CRLF
	_cQuery += " 			END)), " +CRLF
	_cQuery += " 'BILLTO2' = (SELECT (CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='002' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE  " +CRLF
	_cQuery += " 				UPPER(IIF(CHARINDEX('\13\10',(CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='002' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE UPPER((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='002' AND D_E_L_E_T_='')) END)) = 0, " +CRLF
	_cQuery += " 				(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='002' AND D_E_L_E_T_=''), " +CRLF
	_cQuery += " 				LEFT((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='002' AND D_E_L_E_T_=''),CHARINDEX('\13\10',(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='002' AND D_E_L_E_T_=''))-1))) " +CRLF
	_cQuery += " 			END)), " +CRLF
	_cQuery += " 'BILLTO3' = (SELECT (CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='003' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE  " +CRLF
	_cQuery += " 				UPPER(IIF(CHARINDEX('\13\10',(CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='003' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE UPPER((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='003' AND D_E_L_E_T_='')) END)) = 0, " +CRLF
	_cQuery += " 				(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='003' AND D_E_L_E_T_=''), " +CRLF
	_cQuery += " 				LEFT((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='003' AND D_E_L_E_T_=''),CHARINDEX('\13\10',(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='003' AND D_E_L_E_T_=''))-1))) " +CRLF
	_cQuery += " 			END)), " +CRLF
	_cQuery += " 'BILLTO4' = (SELECT (CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='004' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE  " +CRLF
	_cQuery += " 				UPPER(IIF(CHARINDEX('\13\10',(CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='004' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE UPPER((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='004' AND D_E_L_E_T_='')) END)) = 0, " +CRLF
	_cQuery += " 				(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='004' AND D_E_L_E_T_=''), " +CRLF
	_cQuery += " 				LEFT((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='004' AND D_E_L_E_T_=''),CHARINDEX('\13\10',(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='004' AND D_E_L_E_T_=''))-1))) " +CRLF
	_cQuery += " 			END)), " +CRLF
	_cQuery += " 'BILLTO5' = (SELECT (CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='005' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE  " +CRLF
	_cQuery += " 				UPPER(IIF(CHARINDEX('\13\10',(CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='005' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE UPPER((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='005' AND D_E_L_E_T_='')) END)) = 0, " +CRLF
	_cQuery += " 				(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='005' AND D_E_L_E_T_=''), " +CRLF
	_cQuery += " 				LEFT((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='005' AND D_E_L_E_T_=''),CHARINDEX('\13\10',(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=SA1A.A1_OBS AND YP_SEQ='005' AND D_E_L_E_T_=''))-1))) " +CRLF
	_cQuery += " END)), " +CRLF
	_cQuery += " 'PRODINT' = RTRIM(EE9.EE9_COD_I), " +CRLF
	_cQuery += " 'PRODCLI' = RTRIM(EE9.EE9_PART_N), " +CRLF
	_cQuery += " 'PEDICLI' = RTRIM(EE9.EE9_REFCLI), " +CRLF
	_cQuery += " 'NCM'     = LEFT(EE9.EE9_POSIPI,4)+'.'+SUBSTRING(EE9.EE9_POSIPI,5,2)+'.'+SUBSTRING(EE9.EE9_POSIPI,7,2), " +CRLF
	_cQuery += " 'DESCPRO' = (SELECT (CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EE9.EE9_DESC AND YP_SEQ='001' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE  " +CRLF
	_cQuery += " 				UPPER(IIF(CHARINDEX('\13\10',(CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EE9.EE9_DESC AND YP_SEQ='001' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE UPPER((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EE9.EE9_DESC AND YP_SEQ='001' AND D_E_L_E_T_='')) END)) = 0, " +CRLF
	_cQuery += " 				(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EE9.EE9_DESC AND YP_SEQ='001' AND D_E_L_E_T_=''), " +CRLF
	_cQuery += " 				LEFT((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EE9.EE9_DESC AND YP_SEQ='001' AND D_E_L_E_T_=''),CHARINDEX('\13\10',(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EE9.EE9_DESC AND YP_SEQ='001' AND D_E_L_E_T_=''))-1))) " +CRLF
	_cQuery += " 			END)), " +CRLF
	_cQuery += " 'QUANTI'  = EE9.EE9_SLDINI, " +CRLF
	_cQuery += " 'UM'      = EE9.EE9_UNIDAD, " +CRLF
	// _cQuery += " 'UM'      = EE9.EE9_UNPRC, " +CRLF
	_cQuery += " 'PRCUNI'  = EE9.EE9_PRECO, " +CRLF
	_cQuery += " 'PRCTOT'  = EE9.EE9_PRECO * EE9.EE9_SLDINI, " +CRLF
	_cQuery += " 'PESLIQ'  = EEC.EEC_PESLIQ, " +CRLF
	_cQuery += " 'PESBRU'  = EEC.EEC_PESBRU, " +CRLF
	_cQuery += " 'MEASUR'  = (SELECT SUM(EE9M.EE9_QTDEM1 * ( EE5M.EE5_CCOM * EE5M.EE5_LLARG * EE5M.EE5_HALT )) FROM "+RetSqlName("EE9")+" EE9M INNER JOIN "+RetSqlName("EE5")+" EE5M ON EE5M.EE5_CODEMB = EE9M.EE9_EMBAL1 " +CRLF
	_cQuery += " 			WHERE EE5M.D_E_L_E_T_ = '' AND EE9M.D_E_L_E_T_ = '' AND EE9M.EE9_PREEMB = EE9.EE9_PREEMB ), " +CRLF
	_cQuery += " 'WAY'     = IIF(Left(SYQ.YQ_COD_DI,1) = '4','BY AIR',SYQ.YQ_DESCR), " +CRLF
	_cQuery += " 'PAIS'    = RTRIM(YA2.YA_NOIDIOM), " +CRLF
	_cQuery += " 'LOADIN'  = SY9A.Y9_DESCR, " +CRLF
	_cQuery += " 'UNLOAD'  = SY9B.Y9_DESCR, " +CRLF
	_cQuery += " 'INCOTE'  = EEC.EEC_INCOTE, " +CRLF
	_cQuery += " 'MOEDA'   = EEC.EEC_MOEDA, " +CRLF
	_cQuery += " 'PAGAM'   = LTRIM(STR(EEC.EEC_DIASPA)) +' DAYS', " +CRLF
	_cQuery += " 'RESPONS' = COALESCE(EE3.EE3_NOME,''), " +CRLF
	_cQuery += " 'FUNCAO'  = COALESCE(EE3.EE3_CARGO,''), " +CRLF
	_cQuery += " 'FONE'    = COALESCE(EE3.EE3_FONE,''), " +CRLF
	_cQuery += " 'IL'      = EEC.EEC_LICIMP, " +CRLF
	_cQuery += " 'LC'      = EEC.EEC_LC_NUM, " +CRLF
	_cQuery += " 'REMARK1' = (SELECT (CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='001' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE  " +CRLF
	_cQuery += " 				UPPER(IIF(CHARINDEX('\13\10',(CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='001' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE UPPER((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='001' AND D_E_L_E_T_='')) END)) = 0, " +CRLF
	_cQuery += " 				(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='001' AND D_E_L_E_T_=''), " +CRLF
	_cQuery += " 				LEFT((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='001' AND D_E_L_E_T_=''),CHARINDEX('\13\10',(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='001' AND D_E_L_E_T_=''))-1))) " +CRLF
	_cQuery += " 			END)), " +CRLF
	_cQuery += " 'REMARK2' = (SELECT (CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='002' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE  " +CRLF
	_cQuery += " 				UPPER(IIF(CHARINDEX('\13\10',(CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='002' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE UPPER((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='002' AND D_E_L_E_T_='')) END)) = 0, " +CRLF
	_cQuery += " 				(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='002' AND D_E_L_E_T_=''), " +CRLF
	_cQuery += " 				LEFT((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='002' AND D_E_L_E_T_=''),CHARINDEX('\13\10',(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='002' AND D_E_L_E_T_=''))-1))) " +CRLF
	_cQuery += " 			END)), " +CRLF
	_cQuery += " 'REMARK3' = (SELECT (CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='003' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE  " +CRLF
	_cQuery += " 				UPPER(IIF(CHARINDEX('\13\10',(CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='003' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE UPPER((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='003' AND D_E_L_E_T_='')) END)) = 0, " +CRLF
	_cQuery += " 				(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='003' AND D_E_L_E_T_=''), " +CRLF
	_cQuery += " 				LEFT((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='003' AND D_E_L_E_T_=''),CHARINDEX('\13\10',(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='003' AND D_E_L_E_T_=''))-1))) " +CRLF
	_cQuery += " 			END)), " +CRLF
	_cQuery += " 'REMARK4' = (SELECT (CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='004' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE  " +CRLF
	_cQuery += " 				UPPER(IIF(CHARINDEX('\13\10',(CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='004' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE UPPER((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='004' AND D_E_L_E_T_='')) END)) = 0, " +CRLF
	_cQuery += " 				(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='004' AND D_E_L_E_T_=''), " +CRLF
	_cQuery += " 				LEFT((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='004' AND D_E_L_E_T_=''),CHARINDEX('\13\10',(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='004' AND D_E_L_E_T_=''))-1))) " +CRLF
	_cQuery += " 			END)), " +CRLF
	_cQuery += " 'REMARK5' = (SELECT (CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='005' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE  " +CRLF
	_cQuery += " 				UPPER(IIF(CHARINDEX('\13\10',(CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='005' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE UPPER((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='005' AND D_E_L_E_T_='')) END)) = 0, " +CRLF
	_cQuery += " 				(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='005' AND D_E_L_E_T_=''), " +CRLF
	_cQuery += " 				LEFT((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='005' AND D_E_L_E_T_=''),CHARINDEX('\13\10',(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='005' AND D_E_L_E_T_=''))-1))) " +CRLF
	_cQuery += " 			END)), " +CRLF
	_cQuery += " 'REMARK6' = (SELECT (CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='006' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE  " +CRLF
	_cQuery += " 				UPPER(IIF(CHARINDEX('\13\10',(CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='006' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE UPPER((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='006' AND D_E_L_E_T_='')) END)) = 0, " +CRLF
	_cQuery += " 				(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='006' AND D_E_L_E_T_=''), " +CRLF
	_cQuery += " 				LEFT((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='006' AND D_E_L_E_T_=''),CHARINDEX('\13\10',(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EEC.EEC_CODMAR AND YP_SEQ='006' AND D_E_L_E_T_=''))-1))) " +CRLF
	_cQuery += " 			END)), " +CRLF
	_cQuery += " 'NF'      = RTRIM(EE9.EE9_NF)+'-'+RTRIM(EE9.EE9_SERIE), " +CRLF
	_cQuery += " 'SUBTOTAL'= (EE9.EE9_PRECO*EE9.EE9_SLDINI) -(EEC.EEC_FRPREV+EEC.EEC_SEGPRE+(EEC.EEC_FRPCOM+EEC.EEC_DESPIN-EEC.EEC_DESCON)), " +CRLF
	_cQuery += " 'TOTAL'   = (EEC.EEC_TOTPED+EEC.EEC_DESCON)-(EEC.EEC_FRPREV+EEC.EEC_FRPCOM+EEC.EEC_SEGPRE+EEC.EEC_DESPIN)-(EEC.EEC_FRPREV+EEC.EEC_SEGPRE+(EEC.EEC_FRPCOM+EEC.EEC_DESPIN-EEC.EEC_DESCON)), " +CRLF
	_cQuery += " 'FRETE'   = EEC.EEC_FRPREV, " +CRLF
	_cQuery += " 'SEGURO'  = EEC.EEC_SEGPRE, " +CRLF
	_cQuery += " 'OUTROS'  = EEC.EEC_FRPCOM+EEC.EEC_DESPIN-EEC.EEC_DESCON, " +CRLF
	_cQuery += " 'TOTALGER'= (EEC.EEC_TOTPED+EEC.EEC_DESCON)-(EEC.EEC_FRPREV+EEC.EEC_FRPCOM+EEC.EEC_SEGPRE+EEC.EEC_DESPIN) " +CRLF
	_cQuery += " FROM "+RetSqlName("EE9")+" EE9 " +CRLF
	_cQuery += " INNER JOIN "+RetSqlName("EEC")+" EEC ON EE9_PREEMB = EEC_PREEMB " +CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1A ON SA1A.A1_COD = EEC_IMPORT AND SA1A.A1_LOJA = EEC_IMLOJA " +CRLF
	_cQuery += " LEFT JOIN "+RetSqlName("SA1")+" SA1B ON SA1B.A1_COD = EEC_CONSIG AND SA1B.A1_LOJA = EEC_COLOJA AND SA1B.D_E_L_E_T_ = '' AND SA1B.D_E_L_E_T_ = '' " +CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON A2_COD = EEC_FORN AND A2_LOJA = EEC_FOLOJA " +CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SYA")+" YA1 ON YA1.YA_CODGI = SA1A.A1_PAIS  " +CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SYA")+" YA2 ON YA2.YA_CODGI = A2_PAIS  " +CRLF
	_cQuery += " LEFT JOIN "+RetSqlName("SYA")+" YA3 ON YA3.YA_CODGI = SA1B.A1_PAIS AND YA3.D_E_L_E_T_ = ''  " +CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SYQ")+" SYQ ON SYQ.YQ_VIA = EEC.EEC_VIA " +CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SYR")+" SYR ON SYR.YR_VIA = EEC.EEC_VIA AND SYR.YR_ORIGEM = EEC.EEC_ORIGEM AND SYR.YR_DESTINO = EEC.EEC_DEST AND SYR.YR_TIPTRAN = EEC.EEC_TIPTRA " +CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SY9")+" SY9A ON SY9A.Y9_SIGLA = SYR.YR_ORIGEM " +CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SY9")+" SY9B ON SY9B.Y9_SIGLA = SYR.YR_DESTINO " +CRLF
	_cQuery += " LEFT JOIN "+RetSqlName("EE3")+" EE3 ON RTRIM(EE3_NOME) = RTRIM(EEC.EEC_RESPON) AND EE3.D_E_L_E_T_ = '' " +CRLF
	_cQuery += " WHERE EE9.D_E_L_E_T_ = '' AND EEC.D_E_L_E_T_ = '' AND SA1A.D_E_L_E_T_ = '' AND YA1.D_E_L_E_T_ = '' AND YA2.D_E_L_E_T_ = '' AND SYQ.D_E_L_E_T_ = ''  AND SYQ.D_E_L_E_T_ = '' " +CRLF
	_cQuery += " AND SYR.D_E_L_E_T_ = '' AND SY9A.D_E_L_E_T_ = '' AND SY9B.D_E_L_E_T_ = '' " +CRLF
	_cQuery += " AND EE9_FILIAL = '' AND EEC_FILIAL = '' AND SA1A.A1_FILIAL = '' AND YA1.YA_FILIAL = '' AND YA2.YA_FILIAL = '' " +CRLF
	_cQuery += " AND EEC_PREEMB = '"+MV_PAR01+"' " + CRLF

	// MemoWrite("C:\TEMP\PORTARIA.txt",_cQuery)

	TcQuery _cQuery NEW ALIAS "TEXP"

	Count to _nTEXP

	If _nTEXP = 0
		MsgAlert("Não foram encontrados dados para geração da INVOICE.")
		Return(Nil)
	Endif

	TEXP->(dbGoTop())

	_cTitPDF  := 'Invoice_'+alltrim(TEXP->PROCESSO)+'_'+GravaData(dDataBase,.f.,8)+'_'+StrTran(Time(),':','')
	_oPrinter := FWMSPrinter():New(UPPER(_cTitPDF), 6, _lAdjustToLegacy,_cDir, _lDisableSetup, , , ,    , , .F., )
	_oPrinter:SetPortrait()
	_oPrinter:SetPaperSize(9)
	_nLin	:= 3000

	_nSubTot := _nTotMea := 0
	_aNF	 := {}
	While TEXP->(!EOF())

		CheckIN()

		_nPs := _nCol
		For _a := 1 to Len(_aCabec)

			_xConteud := &('TEXP->'+_aCabec[_a][8])
			If Valtype(_xConteud) = 'N'
				_cImp := Alltrim(str(_xConteud,,2))
				// _cImp := Alltrim(Transform(_xConteud,_aCabec[_a][9]))
			ElseIf Valtype(_xConteud) = 'C'
				_cImp := Alltrim(_xConteud)
			ElseIf Valtype(_xConteud) = 'D'
				_cImp := dToc(_xConteud)
			Endif

			_oPrinter:SayAlign(_nLin,_aCabec[_a][3]+_aCabec[_a][6],_cImp,_oFont8,_aCabec[_a][2] -_aCabec[_a][7],7,CLR_BLACK, _aCabec[_a][5] , 0 )

			_nPs += _aCabec[_a][2]

		Next _a

		_nSubTot += TEXP->SUBTOTAL
		_nTotMea += TEXP->MEASUR
		_nLin 	+= _nTLin
		If aScan(_aNF,Alltrim(TEXP->NF)) = 0
			AAdd(_aNF,Alltrim(TEXP->NF))
		Endif

		TEXP->(dbskip())
	ENDDO

	_nLin += 5
	_oPrinter:SayAlign(_nLin,_aCabec[POSDES][3],Replicate('-',30),_oFont8,_aCabec[POSDES][2],7,,2, 0 )
	_nLin += 10

	_oPrinter:SayAlign(_nLin,_aCabec[POSDES][3]+3,'Notas Fiscais: ',_oFont8,_aCabec[POSDES][2]-3,70,,0, 0 )
	For _n := 1 to Len(_aNF)
		_oPrinter:SayAlign(_nLin,_aCabec[POSDES][3]+70,+_aNF[_n],_oFont8N,_aCabec[POSDES][2]-3,70,,0, 0 )
		_nLin += 10
	Next _n

	FooterIN()

	Ms_Flush()
	_oPrinter:EndPage()
	_oPrinter:Preview()

	TEXP->(dbCloseArea())

Return(nil)



Static Function CheckIN()

	If _nLin > _nPosIRod-10
		// If _nLin > _nTotlin
		CabecIN()
	Endif

Return()



Static Function CabecIN() //Cabeçalho

	_oPrinter:StartPage()


	_nSizePage	:= _oPrinter:nPageWidth / _oPrinter:nFactorHor
	_nColTot	:= _nSizePage-(_aMargRel[1]+_aMargRel[3])
	_nLinTot	:= ((_oPrinter:nPageHeight / _oPrinter:nFactorVert) - (_aMargRel[2]+_aMargRel[4])) - 50
	_nCol		:= _aMargRel[1] + 10
	_nLin		:= _aMargRel[2] + 10
	_nMaxLin	:= _nLinTot
	_nTmPag		:= _nColTot - _nCol
	_nLinIni	:= _nLin

	_nLin += 6

	_oPrinter:SayBitmap(_nLin,_nCol+5,"lgrl"+cEmpAnt+".bmp",080,040)

	_oPrinter:SayAlign(_nLin,_nCol+105,Alltrim(TEXP->NOMEEXP),_oFont13N,_nTmPag-105,10,, 0, 0 )
	_nLin += 14
	_oPrinter:SayAlign(_nLin,_nCol+105,Alltrim(TEXP->END1EXP),_oFont8N,_nTmPag-105,10,, 0, 0 )
	_nLin += _nTLin
	_oPrinter:SayAlign(_nLin,_nCol+105,Alltrim(TEXP->END2EXP)+' CEP: '+Alltrim(TEXP->CEPEXP),_oFont8N,_nTmPag-105,10,, 0, 0 )
	_nLin += _nTLin
	_oPrinter:SayAlign(_nLin,_nCol+105,'TEL.: +'+Alltrim(TEXP->FONEEXP)+' FAX: +'+Alltrim(TEXP->FAXEXP),_oFont8N,_nTmPag-105,10,, 0, 0 )
	_nLin += _nTLin
	_oPrinter:SayAlign(_nLin,_nCol+105,'Supplier Code: ',_oFont11,_nTmPag-75,10,, 0, 0 )
	_oPrinter:SayAlign(_nLin-2,_nCol+180,Alltrim(TEXP->SUPCODE),_oFont11N,_nTmPag-105,10,, 0, 0 )
	_nLin += _nTLin-5
	_oPrinter:SayAlign(_nLin,_nColTot-110,'Invoice:'				,_oFont11 ,050,10,, 0, 2 )
	_oPrinter:SayAlign(_nLin-2,_nColTot-065,Alltrim(TEXP->PROCESSO)	,_oFont13N,050,10,, 0, 2 )
	_nLin += _nTLin
	_oPrinter:SayAlign(_nLin,_nColTot-110,'Date:'					,_oFont11 ,050,10,, 0, 2 )
	_oPrinter:SayAlign(_nLin-2,_nColTot-065,Alltrim(TEXP->DTPROCES)	,_oFont13N,070,10,, 0, 2 )

	_nLin += _nTLin
	_nLin += _nTLin
	_oPrinter:Box(_nLin,_nCol, _nLinTot,_nColTot,"-9")


	_oPrinter:SayAlign(_nLin+1,_nCol+5,'SHIP TO:',_oFont7N,32,10,, 0, 0 )
	_oPrinter:SayAlign(_nLin,_nCol+37,Alltrim(TEXP->NOMEIMP),_oFont8N,(_nTmPag/2)-35,10,, 0, 0 )

	_oPrinter:SayAlign(_nLin+1,_nCol+(_nTmPag/2)+2,'CONSIGNEE TO:',_oFont7N,50,10,, 0, 0 )
	_oPrinter:SayAlign(_nLin,_nCol+(_nTmPag/2)+52,Alltrim(TEXP->NOMEIMP),_oFont8N,(_nTmPag/2)-52,10,, 0, 0 )

	_nLin += _nTLin
	_oPrinter:SayAlign(_nLin,_nCol+37,Alltrim(TEXP->END1IMP),_oFont8N,(_nTmPag/2)-35,10,, 0, 0 )
	_oPrinter:SayAlign(_nLin,_nCol+(_nTmPag/2)+52,Alltrim(TEXP->END1CON),_oFont8N,(_nTmPag/2)-52,10,, 0, 0 )
	_nLin += _nTLin
	_oPrinter:SayAlign(_nLin,_nCol+37,Alltrim(TEXP->END2IMP),_oFont8N,(_nTmPag/2)-35,10,, 0, 0 )
	_oPrinter:SayAlign(_nLin,_nCol+(_nTmPag/2)+52,Alltrim(TEXP->END2CON),_oFont8N,(_nTmPag/2)-52,10,, 0, 0 )

	_nLin += _nTLin+2
	_oPrinter:Line(_nLin,_nCol,_nLin,_nColTot)
	_oPrinter:SayAlign(_nLin,_nCol+5,'BILL TO:',_oFont7N,_nTmPag-105,10,, 0, 0 )
	_oPrinter:SayAlign(_nLin,_nCol+35,Alltrim(TEXP->BILLTO1),_oFont8N,_nTmPag-30,10,, 0, 0 )
	_nLin += _nTLin
	_oPrinter:SayAlign(_nLin,_nCol+35,Alltrim(TEXP->BILLTO2),_oFont8N,_nTmPag-30,10,, 0, 0 )
	_nLin += _nTLin
	_oPrinter:SayAlign(_nLin,_nCol+35,Alltrim(TEXP->BILLTO3),_oFont8N,_nTmPag-30,10,, 0, 0 )
	_nLin += _nTLin
	_oPrinter:SayAlign(_nLin,_nCol+35,Alltrim(TEXP->BILLTO4),_oFont8N,_nTmPag-30,10,, 0, 0 )
	_nLin += _nTLin
	_oPrinter:SayAlign(_nLin,_nCol+35,Alltrim(TEXP->BILLTO5),_oFont8N,_nTmPag-30,10,, 0, 0 )
	_nLin += _nTLin+2
	_oPrinter:Line(_nLin,_nCol,_nLin,_nColTot)

	_nT2Fim := (_aCabec[8][1]+_aCabec[9][1]) / 100 * _nTmPag

	_oPrinter:SayAlign(_nLin,_nCol,'P R O D U C T',_oFont7N,_nTmPag-_nT2Fim,10,, 2, 0 )
	_oPrinter:SayAlign(_nLin,_nCol+_nTmPag-_nT2Fim,'VALUES IN '+Alltrim(TEXP->MOEDA),_oFont7N,_nT2Fim,10,, 2, 0 )
	_oPrinter:Line(_nLin,_nCol+_nTmPag-_nT2Fim,_nLin+_nTLin,_nCol+_nTmPag-_nT2Fim)

	_nLin += _nTLin
	_oPrinter:Line(_nLin,_nCol,_nLin,_nColTot)


	_nPosIRod := _nLinTot - _nTamRod
	_nPs := _nCol
	_nLiBk := _nLin
	For _a := 1 to Len(_aCabec)
		_nTm := (_aCabec[_a][1] / 100) * _nTmPag
		_aCabec[_a][2] := _nTm
		_aCabec[_a][3] := _nPs

		If Len(_aCabec[_a][4]) = 1
			_oPrinter:SayAlign(_nLin+5,_nPs+_aCabec[_a][6],_aCabec[_a][4][1],_oFont7N,_nTm-_aCabec[_a][7],7,, _aCabec[_a][5] , 0 )
		Else
			_oPrinter:SayAlign(_nLin	,_nPs+_aCabec[_a][6],_aCabec[_a][4][1],_oFont7N,_nTm-_aCabec[_a][7],7,, _aCabec[_a][5] , 0 )
			_oPrinter:SayAlign(_nLin+8	,_nPs+_aCabec[_a][6],_aCabec[_a][4][2],_oFont7N,_nTm-_aCabec[_a][7],7,, _aCabec[_a][5] , 0 )
		Endif

		_oPrinter:Line(_nLiBk,_nPs,_nPosIRod,_nPs)

		_nPs += _nTm
	Next _a

	_nLin += 10
	_nLin += _nTLin

	_oPrinter:Line(_nLin,_nCol,_nLin,_nColTot)

Return()



Static Function FooterIN()

	TEXP->(dbGoTop())

	_oPrinter:Line(_nPosIRod,_nCol,_nPosIRod,_nColTot)
	_nLiR := _nPosIRod-1
	_oPrinter:SayAlign(_nLiR,_aCabec[POSDES][3],'R E M A R K S',_oFont8N,_aCabec[POSDES][2],7,, 2, 0 )
	_oPrinter:SayAlign(_nLiR,_aCabec[POSDES+1][3]+3,'Sub-Total',_oFont8,_aCabec[POSDES+1][2],7,, 0, 0 )
	_oPrinter:SayAlign(_nLiR,_aCabec[POSTOT][3],Alltrim(str(_nSubTot,,2)),_oFont8N,_aCabec[POSTOT][2]-_aCabec[POSTOT][7],7,, 1, 0 )
	_nLiR += _nTLin+1
	_oPrinter:Line(_nLiR,_nCol,_nLiR,_nColTot)
	_oPrinter:SayAlign(_nLiR+5,_nCol+3,'Net Weight (KG)',_oFont8,100,7,, 0, 0 )
	_oPrinter:SayAlign(_nLiR+5,_aCabec[4][3],Alltrim(str(TEXP->PESLIQ,,2)),_oFont8N,_aCabec[4][2]-3,7,, 1, 0 )

	_oPrinter:SayAlign(_nLiR,_aCabec[POSDES][3]+3,Alltrim(TEXP->REMARK1),_oFont8N,_aCabec[POSDES][2]-3,7,,0, 0 )
	_nLiR += _nTLin
	_oPrinter:SayAlign(_nLiR,_aCabec[POSDES][3]+3,Alltrim(TEXP->REMARK2),_oFont8N,_aCabec[POSDES][2]-3,7,,0, 0 )
	_nLiR += _nTLin
	_oPrinter:SayAlign(_nLiR,_aCabec[POSDES][3]+3,Alltrim(TEXP->REMARK3),_oFont8N,_aCabec[POSDES][2]-3,7,,0, 0 )
	_oPrinter:Line(_nLiR,_aCabec[POSDES+1][3],_nLiR,_nColTot)
	_nBkLi := _nLiR
	_oPrinter:SayAlign(_nLiR-2,_aCabec[POSDES+1][3]+3,'Total',_oFont8,_aCabec[POSDES+1][2],7,, 0, 0 )	
	_oPrinter:SayAlign(_nLiR-2,_aCabec[9][3],Alltrim(str(TEXP->TOTAL,,2)) ,_oFont8N,_aCabec[9][2]-3,7,, 1, 0 )	
	_nLiR += _nTLin
	_oPrinter:SayAlign(_nLiR-5,_nCol+3,'Gross Weight (KG)',_oFont8,100,7,, 0, 0 )
	_oPrinter:SayAlign(_nLiR-5,_aCabec[4][3],Alltrim(str(TEXP->PESBRU,,2)),_oFont8N,_aCabec[4][2]-3,7,, 1, 0 )
	_oPrinter:SayAlign(_nLiR,_aCabec[POSDES][3]+3,Alltrim(TEXP->REMARK4),_oFont8N,_aCabec[POSDES][2]-3,7,,0, 0 )
	_oPrinter:Line(_nLiR,_aCabec[POSDES+1][3],_nLiR,_nColTot)
	_oPrinter:SayAlign(_nLiR-2,_aCabec[POSDES+1][3]+3,'Freight',_oFont8,_aCabec[POSDES+1][2],7,, 0, 0 )	
	_oPrinter:SayAlign(_nLiR-2,_aCabec[9][3],Alltrim(str(TEXP->FRETE,,2)) ,_oFont8N,_aCabec[9][2]-3,7,, 1, 0 )	
	_nLiR += _nTLin
	_oPrinter:SayAlign(_nLiR,_aCabec[POSDES][3]+3,Alltrim(TEXP->REMARK5),_oFont8N,_aCabec[POSDES][2]-3,7,,0, 0 )
	_oPrinter:Line(_nLiR,_aCabec[POSDES+1][3],_nLiR,_nColTot)
	_oPrinter:SayAlign(_nLiR-2,_aCabec[POSDES+1][3]+3,'Insurance',_oFont8,_aCabec[POSDES+1][2],7,, 0, 0 )	
	_oPrinter:SayAlign(_nLiR-2,_aCabec[9][3],Alltrim(str(TEXP->SEGURO,,2)) ,_oFont8N,_aCabec[9][2]-3,7,, 1, 0 )	
	_nLiR += _nTLin
	_oPrinter:SayAlign(_nLiR-5,_nCol+3,'Measurement (M3)',_oFont8,100,7,, 0, 0 )
	_oPrinter:SayAlign(_nLiR-5,_aCabec[4][3],Alltrim(str(_nTotMea,,4)),_oFont8N,_aCabec[4][2]-3,7,, 1, 0 )

	_oPrinter:SayAlign(_nLiR,_aCabec[POSDES][3]+3,Alltrim(TEXP->REMARK6),_oFont8N,_aCabec[POSDES][2]-3,7,,0, 0 )
	_oPrinter:Line(_nLiR,_aCabec[POSDES+1][3],_nLiR,_nColTot)
	_oPrinter:SayAlign(_nLiR,_aCabec[POSDES+1][3]+3,'Others',_oFont8,_aCabec[POSDES+1][2],7,, 0, 0 )	
	_oPrinter:SayAlign(_nLiR-2,_aCabec[9][3],Alltrim(str(TEXP->OUTROS,,2)) ,_oFont8N,_aCabec[9][2]-3,7,, 1, 0 )	
	_nLiR += _nTLin+2
	_oPrinter:Line(_nLiR,_nCol,_nLiR,_nColTot)
	_oPrinter:SayAlign(_nLiR,_nCol+3,Alltrim('Way:'),_oFont8,_aCabec[POSDES][2]-3,7,,0, 0 )
	_oPrinter:SayAlign(_nLiR,_nCol+30,Alltrim(TEXP->WAY),_oFont8N,100,7,,0, 0 )
	_oPrinter:SayAlign(_nLiR,_aCabec[POSDES][3]+3,Alltrim('Incoterms 2000:'),_oFont8,_aCabec[POSDES][2]-3,7,,0, 0 )
	_oPrinter:SayAlign(_nLiR-1,_aCabec[POSDES][3]+70,Alltrim(TEXP->INCOTE),_oFont8N,100,7,,0, 0 )
	_oPrinter:SayAlign(_nLiR,_aCabec[POSDES+1][3]+3,'Total Amount',_oFont8,_aCabec[POSDES+1][2],7,, 0, 0 )
	_oPrinter:SayAlign(_nLiR-1,_aCabec[9][3],Alltrim(str(TEXP->TOTALGER,,2)) ,_oFont8N,_aCabec[9][2]-3,7,, 1, 0 )	
	_nLiR += _nTLin+2
	_oPrinter:Line(_nLiR,_nCol,_nLiR,_nColTot)

	_oPrinter:Line(_nBkLi,_aCabec[9][3],_nLiR,_aCabec[9][3])
	
	_oPrinter:SayAlign(_nLiR,_nCol+3,'Country of Origin: ',_oFont8,100,7,,0, 0 )
	_oPrinter:SayAlign(_nLiR,_nCol+90,Alltrim(TEXP->PAIS),_oFont8N,100,7,,0, 0 )
	_oPrinter:SayAlign(_nLiR,_aCabec[POSDES+1][3]+3,'Agent:',_oFont8,_aCabec[POSDES+1][2],7,, 0, 0 )	
	_nLiR += _nTLin+2
	_oPrinter:Line(_nLiR,_nCol,_nLiR,_aCabec[POSDES+1][3])
	_oPrinter:SayAlign(_nLiR,_nCol,'Port of Loading',_oFont8,_aCabec[1][2]+_aCabec[2][2]+_aCabec[3][2]+_aCabec[4][2],7,,2, 0 )
	_oPrinter:SayAlign(_nLiR,_aCabec[POSDES][3],'Port of Unloading',_oFont8,_aCabec[POSDES][2],7,,2, 0 )
	_nLiR += _nTLin+2
	_oPrinter:Line(_nLiR,_nCol,_nLiR,_aCabec[POSDES+1][3])
	_oPrinter:SayAlign(_nLiR,_nCol,Alltrim(TEXP->LOADIN),_oFont8N,_aCabec[1][2]+_aCabec[2][2]+_aCabec[3][2]+_aCabec[4][2],7,,2, 0 )
	_oPrinter:SayAlign(_nLiR,_aCabec[POSDES][3],Alltrim(TEXP->UNLOAD),_oFont8N,_aCabec[POSDES][2],7,,2, 0 )
	_nLiR += _nTLin+2
	_oPrinter:Line(_nPosIRod,_aCabec[POSDES][3],_nLiR,_aCabec[POSDES][3])
	_oPrinter:Line(_nPosIRod,_aCabec[POSDES+1][3],_nLiR,_aCabec[POSDES+1][3])


	_oPrinter:Line(_nLiR,_nCol,_nLiR,_nColTot)
	_oPrinter:SayAlign(_nLiR,_nCol+3,'Payment Terms:',_oFont8,_nTmPag,7,,0, 0 )
	_oPrinter:SayAlign(_nLiR-2,_nCol+80,Alltrim(TEXP->PAGAM),_oFont8N,100,7,,0, 0 )
	_nLiR += _nTLin
	_oPrinter:Line(_nLiR,_nCol,_nLiR,_nColTot)
	_oPrinter:SayAlign(_nLiR,_nCol+3,'I/L No.:',_oFont8,_nTmPag/2,7,,0, 0 )
	_oPrinter:SayAlign(_nLiR,_nCol+30,Alltrim(TEXP->IL),_oFont8N,100,7,,0, 0 )
	_oPrinter:SayAlign(_nLiR,_nCol+(_nTmPag/2)+3,'L/C No.:',_oFont8,_nTmPag/2,7,,0, 0 )
	_oPrinter:SayAlign(_nLiR,_nCol+(_nTmPag/2)+30,Alltrim(TEXP->LC),_oFont8N,100,7,,0, 0 )
	_oPrinter:Line(_nLiR,_nCol+(_nTmPag/2),_nLiR+_nTLin,_nCol+(_nTmPag/2))
	_nLiR += _nTLin
	_oPrinter:Line(_nLiR,_nCol,_nLiR,_nColTot)

	_nLiR += (_nTLin*2)
	_oPrinter:SayAlign(_nLiR,_nCol,'_________________________________________________________',_oFont8N,_nTmPag,7,,2, 0 )
	_nLiR += _nTLin
	_oPrinter:SayAlign(_nLiR,_nCol,Alltrim(TEXP->RESPONS),_oFont8N,_nTmPag,7,,2, 0 )
	_nLiR += _nTLin
	_oPrinter:SayAlign(_nLiR,_nCol,Alltrim(TEXP->FUNCAO),_oFont8N,_nTmPag,7,,2, 0 )
	_nLiR += _nTLin
	_oPrinter:SayAlign(_nLiR,_nCol,'PHONE: '+Alltrim(TEXP->FONE),_oFont8N,_nTmPag,7,,2, 0 )

Return(Nil)




Static Function CR119PL()

	Local _lAdjustToLegacy	:= .F.
	Local _lDisableSetup	:= .T.
	Local _cTitPDF			:= ''
	Local _cDir				:= GetTempPath()

		/*
	1 - Percentual do campo conforme tamanho total
	2 - Tamanho da coluna (calculado)
	3 - Posição Inicial da coluna (calculado)
	4 - Nome
	5 - Alinhamento Horizontal (0=Esquerda, 1=Direita, 2 = Centralizado)
	6 - Qtde a somar na posição inicial
	7 - Qtde a diminuir no tamanho da coluna
	8 - Campo que será impresso na coluna
	9 - Picture do campo
	10- Campo SubTotal
	11- Campo Total Geral
	*/
	_aCabec		:= {;
		{16,0,0,{'On the','Packages'}			,2,0,0,'QTEMB'		,'@!'				,''		,''	},;
		{09,0,0,{'Part','Number'}	        	,2,0,0,'PRODCLI'	,'@!'				,''		,''	},;
		{06,0,0,{'Cronnos','Code'}        	 	,2,0,0,'PRODINT'	,'@!'				,''		,''	},;
		{09,0,0,{'Order'}		         		,2,0,0,'PEDICLI'	,'@!'				,''		,''	},;
		{23,0,0,{'Description of the Goods'}	,0,3,0,'DESCPRO'	,'@!'				,''		,''	},;
		{08,0,0,{'QTY'}							,1,0,3,'QUANTI'		,"@E 9.999.999,99"	,''		,''	},;
		{12,0,0,{'Cubic Meter'}					,2,0,0,'CUBIC'		,"@!"				,''		,''	},;
		{08,0,0,{'Net Weight','Kilo'}			,1,0,3,'PESLIQ'		,"@E 9.999.999,99"	,''		,''	},;
		{09,0,0,{'Gross Weight','Kilo'}			,1,0,3,'PESBRU'		,"@E 9.999.999,99"	,''		,''	}}

	_nTamRod	:= 60

	// Pergunte("CR0119",.f.)

	If Select("TEXP") > 0
		TEXP->(dbCloseArea())
	Endif

	_cQuery := " SELECT " + CRLF
	_cQuery += " 'NOMEEXP' = SA2.A2_NOME, " + CRLF
	_cQuery += " 'END1EXP' = (RTRIM(SA2.A2_END)+','+RTRIM(SA2.A2_NR_END)), " + CRLF
	_cQuery += " 'END2EXP' = (RTRIM(SA2.A2_MUN)+'-'+RTRIM(SA2.A2_EST)+' '+RTRIM(YA2.YA_NOIDIOM)), " + CRLF
	_cQuery += " 'CEPEXP'  = LEFT(SA2.A2_CEP,5)+'-'+RIGHT(SA2.A2_CEP,3), " + CRLF
	_cQuery += " 'FONEEXP' = RTRIM(SA2.A2_DDI)+' '+RTRIM(SA2.A2_DDD)+' '+RTRIM(SA2.A2_TEL), " + CRLF
	_cQuery += " 'FAXEXP'  = RTRIM(SA2.A2_DDI)+' '+RTRIM(SA2.A2_DDD)+' '+RTRIM(SA2.A2_FAX), " + CRLF
	_cQuery += " 'SUPCODE' =  SA1A.A1_SUPCODE, " + CRLF
	_cQuery += " 'PROCESSO'= RTRIM(EEC.EEC_PREEMB), " + CRLF
	_cQuery += " 'DTPROCES'= (SUBSTRING(EEC.EEC_DTINVO,5,2)+'/'+RIGHT(EEC.EEC_DTINVO,2)+'/'+LEFT(EEC.EEC_DTINVO,4)), " + CRLF
	_cQuery += " 'NOMEIMP' = (RTRIM(SA1A.A1_NOME)), " + CRLF
	_cQuery += " 'END1IMP' = (RTRIM(SA1A.A1_ADDRESS)+' - '+RTRIM(SA1A.A1_CITY)+'-'+RTRIM(SA1A.A1_STATE)), " + CRLF
	_cQuery += " 'END2IMP' = (RTRIM(SA1A.A1_POSCODE)+' - '+RTRIM(YA1.YA_NOIDIOM)), " + CRLF
	_cQuery += " 'NOMECON' = CASE WHEN COALESCE(EEC_CONSIG,'') = '' THEN RTRIM(SA1A.A1_NOME) ELSE RTRIM(SA1B.A1_NOME) END, " + CRLF
	_cQuery += " 'END1CON' = CASE WHEN COALESCE(EEC_CONSIG,'') = '' THEN RTRIM(SA1A.A1_ADDRESS)+' - '+RTRIM(SA1A.A1_CITY)+'-'+RTRIM(SA1A.A1_STATE) ELSE RTRIM(SA1B.A1_ADDRESS)+' - '+RTRIM(SA1B.A1_CITY)+'-'+RTRIM(SA1B.A1_STATE) END, " + CRLF
	_cQuery += " 'END2CON' = CASE WHEN COALESCE(EEC_CONSIG,'') = '' THEN RTRIM(SA1A.A1_POSCODE)+' - '+RTRIM(YA1.YA_NOIDIOM) ELSE RTRIM(SA1B.A1_POSCODE)+' - '+RTRIM(YA3.YA_NOIDIOM) END, " + CRLF
	_cQuery += " 'PRODINT' = RTRIM(EE9.EE9_COD_I), " + CRLF
	_cQuery += " 'PRODCLI' = RTRIM(EE9.EE9_PART_N), " + CRLF
	_cQuery += " 'PEDICLI' = RTRIM(EE9.EE9_REFCLI), " + CRLF
	_cQuery += " 'DESCPRO' = (SELECT (CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EE9.EE9_DESC AND YP_SEQ='001' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE  " + CRLF
	_cQuery += " 				UPPER(IIF(CHARINDEX('\13\10',(CASE (SELECT COUNT(YP_TEXTO) FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EE9.EE9_DESC AND YP_SEQ='001' AND D_E_L_E_T_='') WHEN 0 THEN '' ELSE UPPER((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EE9.EE9_DESC AND YP_SEQ='001' AND D_E_L_E_T_='')) END)) = 0, " + CRLF
	_cQuery += " 				(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EE9.EE9_DESC AND YP_SEQ='001' AND D_E_L_E_T_=''), " + CRLF
	_cQuery += " 				LEFT((SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EE9.EE9_DESC AND YP_SEQ='001' AND D_E_L_E_T_=''),CHARINDEX('\13\10',(SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" WHERE YP_CHAVE=EE9.EE9_DESC AND YP_SEQ='001' AND D_E_L_E_T_=''))-1))) " + CRLF
	_cQuery += " 			END)), " + CRLF
	_cQuery += " 'QUANTI'  = EE9.EE9_SLDINI, " + CRLF
	_cQuery += " 'UM'      = EE9.EE9_UNPRC, " + CRLF
	_cQuery += " 'PESLIQ'  = EE9.EE9_PSLQTO, " + CRLF
	_cQuery += " 'PESBRU'  = EE9.EE9_PSBRTO, " + CRLF
	_cQuery += " 'LOADIN'  = SY9A.Y9_DESCR, " + CRLF
	_cQuery += " 'UNLOAD'  = SY9B.Y9_DESCR, " + CRLF
	_cQuery += " 'RESPONS' = COALESCE(EE3B.EE3_NOME,''), " + CRLF
	_cQuery += " 'ROUTE'   = UPPER(SUBSTRING(SYQ.YQ_COD_DI,3,20)), " + CRLF
	_cQuery += " 'PAISDES' =RTRIM(YA4.YA_NOIDIOM), " + CRLF
	_cQuery += " 'QTEMB'   = EE9.EE9_QTDEM1, " + CRLF
	_cQuery += " 'CUBIC'   = EE5.EE5_DIMENS " + CRLF
	_cQuery += " FROM "+RetSqlName("EE9")+" EE9 " + CRLF
	_cQuery += " INNER JOIN "+RetSqlName("EEC")+" EEC ON EE9_PREEMB = EEC_PREEMB " + CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1A ON SA1A.A1_COD = EEC_IMPORT AND SA1A.A1_LOJA = EEC_IMLOJA " + CRLF
	_cQuery += " LEFT JOIN "+RetSqlName("SA1")+" SA1B ON SA1B.A1_COD = EEC_CONSIG AND SA1B.A1_LOJA = EEC_COLOJA AND SA1B.D_E_L_E_T_ = '' AND SA1B.D_E_L_E_T_ = '' " + CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON A2_COD = EEC_FORN AND A2_LOJA = EEC_FOLOJA " + CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SYA")+" YA1 ON YA1.YA_CODGI = SA1A.A1_PAIS  " + CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SYA")+" YA2 ON YA2.YA_CODGI = A2_PAIS  " + CRLF
	_cQuery += " LEFT JOIN "+RetSqlName("SYA")+" YA3 ON YA3.YA_CODGI = SA1B.A1_PAIS AND YA3.D_E_L_E_T_ = ''  " + CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SYQ")+" SYQ ON SYQ.YQ_VIA = EEC.EEC_VIA " + CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SYR")+" SYR ON SYR.YR_VIA = EEC.EEC_VIA AND SYR.YR_ORIGEM = EEC.EEC_ORIGEM AND SYR.YR_DESTINO = EEC.EEC_DEST AND SYR.YR_TIPTRAN = EEC.EEC_TIPTRA " + CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SY9")+" SY9A ON SY9A.Y9_SIGLA = SYR.YR_ORIGEM " + CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SY9")+" SY9B ON SY9B.Y9_SIGLA = SYR.YR_DESTINO " + CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SYA")+" YA4 ON YA4.YA_CODGI = SY9B.Y9_PAIS " + CRLF
	_cQuery += " LEFT JOIN "+RetSqlName("EE3")+" EE3 ON RTRIM(EE3.EE3_NOME) = RTRIM(EEC.EEC_RESPON) AND EE3.D_E_L_E_T_ = '' " + CRLF
	_cQuery += " LEFT JOIN "+RetSqlName("EE3")+" EE3B ON EE3B.D_E_L_E_T_ = '' AND EE3B.EE3_CODCAD = 'X' " + CRLF
	_cQuery += " INNER JOIN "+RetSqlName("EE5")+" EE5 ON EE5.EE5_CODEMB = EE9.EE9_EMBAL1 " + CRLF
	_cQuery += " WHERE EE9.D_E_L_E_T_ = '' AND EEC.D_E_L_E_T_ = '' AND SA1A.D_E_L_E_T_ = '' AND YA1.D_E_L_E_T_ = '' AND YA2.D_E_L_E_T_ = '' AND SYQ.D_E_L_E_T_ = ''  AND SYQ.D_E_L_E_T_ = '' " + CRLF
	_cQuery += " AND SYR.D_E_L_E_T_ = '' AND SY9A.D_E_L_E_T_ = '' AND SY9B.D_E_L_E_T_ = '' AND EE5.D_E_L_E_T_ = '' " + CRLF
	_cQuery += " AND EE9_FILIAL = '' AND EEC_FILIAL = '' AND SA1A.A1_FILIAL = '' AND YA1.YA_FILIAL = '' AND YA2.YA_FILIAL = '' " + CRLF
	_cQuery += " AND EEC_PREEMB = '"+MV_PAR01+"' " + CRLF

	// MemoWrite("C:\TEMP\PORTARIA.txt",_cQuery)

	TcQuery _cQuery NEW ALIAS "TEXP"

	Count to _nTEXP

	If _nTEXP = 0
		MsgAlert("Não foram encontrados dados para geração do PACKING LIST.")
		Return(Nil)
	Endif

	TEXP->(dbGoTop())

	_cTitPDF  := 'Packing_List_'+alltrim(TEXP->PROCESSO)+'_'+GravaData(dDataBase,.f.,8)+'_'+StrTran(Time(),':','')
	_oPrinter := FWMSPrinter():New(UPPER(_cTitPDF), 6, _lAdjustToLegacy,_cDir, _lDisableSetup, , , ,    , , .F., )
	_oPrinter:SetPortrait()
	_oPrinter:SetPaperSize(9)
	_nLin	:= 3000

	_nPesLiq := _nPesBru := _nTCaixa := 0
	While TEXP->(!EOF())

		CheckPL()

		_nPs := _nCol
		For _a := 1 to Len(_aCabec)

			_xConteud := &('TEXP->'+_aCabec[_a][8])
			If Valtype(_xConteud) = 'N'
				If _a = 1
					If TEXP->QTEMB = 1
						_cImp := Alltrim(str(_xConteud)) + ' Cardboard Box'
					Else
						_cImp := Alltrim(str(_xConteud)) + ' Cardboard Boxes'
					Endif
				else
					_cImp := Alltrim(str(_xConteud,,2))
				Endif
				// _cImp := Alltrim(Transform(_xConteud,_aCabec[_a][9]))
			ElseIf Valtype(_xConteud) = 'C'
				_cImp := Alltrim(_xConteud)
			ElseIf Valtype(_xConteud) = 'D'
				_cImp := dToc(_xConteud)
			Endif

			_oPrinter:SayAlign(_nLin,_aCabec[_a][3]+_aCabec[_a][6],_cImp,_oFont8,_aCabec[_a][2] -_aCabec[_a][7],7,CLR_BLACK, _aCabec[_a][5] , 0 )

			_nPs += _aCabec[_a][2]

		Next _a

		_nTCaixa += TEXP->QTEMB
		_nPesLiq += TEXP->PESLIQ
		_nPesBru += TEXP->PESBRU
		_nLin 	+= _nTLin

		TEXP->(dbskip())
	ENDDO

	FooterPL()

	Ms_Flush()
	_oPrinter:EndPage()
	_oPrinter:Preview()

	TEXP->(dbCloseArea())

Return(nil)



Static Function CheckPL()

	If _nLin > _nPosIRod-10
		CabecPL()
	Endif

Return()


Static Function CabecPL() //Cabeçalho

	_oPrinter:StartPage()


	_nSizePage	:= _oPrinter:nPageWidth / _oPrinter:nFactorHor
	_nColTot	:= _nSizePage-(_aMargRel[1]+_aMargRel[3])
	_nLinTot	:= ((_oPrinter:nPageHeight / _oPrinter:nFactorVert) - (_aMargRel[2]+_aMargRel[4])) - 50
	_nCol		:= _aMargRel[1] + 10
	_nLin		:= _aMargRel[2] + 10
	_nMaxLin	:= _nLinTot
	_nTmPag		:= _nColTot - _nCol
	_nLinIni	:= _nLin

	_nLin += 6

	_oPrinter:SayBitmap(_nLin,_nCol+5,"lgrl"+cEmpAnt+".bmp",080,040)

	_oPrinter:SayAlign(_nLin,_nCol+105,Alltrim(TEXP->NOMEEXP),_oFont13N,_nTmPag-105,10,, 0, 0 )
	_nLin += 14
	_oPrinter:SayAlign(_nLin,_nCol+105,Alltrim(TEXP->END1EXP),_oFont8N,_nTmPag-105,10,, 0, 0 )
	_nLin += _nTLin
	_oPrinter:SayAlign(_nLin,_nCol+105,Alltrim(TEXP->END2EXP)+' CEP: '+Alltrim(TEXP->CEPEXP),_oFont8N,_nTmPag-105,10,, 0, 0 )
	_nLin += _nTLin
	_oPrinter:SayAlign(_nLin,_nCol+105,'TEL.: +'+Alltrim(TEXP->FONEEXP)+' FAX: +'+Alltrim(TEXP->FAXEXP),_oFont8N,_nTmPag-105,10,, 0, 0 )
	_nLin += _nTLin
	_oPrinter:SayAlign(_nLin,_nCol+105,'Supplier Code: ',_oFont11,_nTmPag-75,10,, 0, 0 )
	_oPrinter:SayAlign(_nLin-2,_nCol+180,Alltrim(TEXP->SUPCODE),_oFont11N,_nTmPag-105,10,, 0, 0 )
	_nLin += _nTLin-5
	_oPrinter:SayAlign(_nLin,_nColTot-130,'Packing List: '+Alltrim(TEXP->PROCESSO)		,_oFont11N ,127,10,, 1, 2 )
	// _oPrinter:SayAlign(_nLin,_nColTot-065,Alltrim(TEXP->PROCESSO)	,_oFont11N,050,10,, 1, 2 )
	_nLin += _nTLin+2
	_oPrinter:SayAlign(_nLin,_nColTot-065,'Page 1 of 1'			,_oFont11N ,062,10,, 1, 2 )

	_nLin += _nTLin-2
	_nLin += _nTLin
	_oPrinter:Box(_nLin,_nCol, _nLinTot,_nColTot,"-9")


	_oPrinter:SayAlign(_nLin+1,_nCol+5,'SHIP TO:',_oFont7N,32,10,, 0, 0 )
	_oPrinter:SayAlign(_nLin,_nCol+37,Alltrim(TEXP->NOMEIMP),_oFont8N,(_nTmPag/2)-35,10,, 0, 0 )

	_oPrinter:SayAlign(_nLin+1,_nCol+(_nTmPag/2)+2,'CONSIGNEE TO:',_oFont7N,50,10,, 0, 0 )
	_oPrinter:SayAlign(_nLin,_nCol+(_nTmPag/2)+52,Alltrim(TEXP->NOMEIMP),_oFont8N,(_nTmPag/2)-52,10,, 0, 0 )

	_nLin += _nTLin
	_oPrinter:SayAlign(_nLin,_nCol+37,Alltrim(TEXP->END1IMP),_oFont8N,(_nTmPag/2)-35,10,, 0, 0 )
	_oPrinter:SayAlign(_nLin,_nCol+(_nTmPag/2)+52,Alltrim(TEXP->END1CON),_oFont8N,(_nTmPag/2)-52,10,, 0, 0 )
	_nLin += _nTLin
	_oPrinter:SayAlign(_nLin,_nCol+37,Alltrim(TEXP->END2IMP),_oFont8N,(_nTmPag/2)-35,10,, 0, 0 )
	_oPrinter:SayAlign(_nLin,_nCol+(_nTmPag/2)+52,Alltrim(TEXP->END2CON),_oFont8N,(_nTmPag/2)-52,10,, 0, 0 )


	_nTm3	:= _nTmPag/3
	_nP1	:= _nCol
	_nP2	:= _nP1+_nTm3
	_nP3	:= _nP2+_nTm3

	_nLin += _nTLin+2
	_oPrinter:Line(_nLin,_nCol,_nLin,_nColTot)
	_nBkLin := _nLin
	_oPrinter:SayAlign(_nLin,_nP1+3,'Route:'			,_oFont7N,_nTm3-3,10,, 0, 0 )
	_oPrinter:SayAlign(_nLin,_nP2+3,'Port of Loading:'	,_oFont7N,_nTm3-3,10,, 0, 0 )
	_oPrinter:SayAlign(_nLin,_nP3+3,'Invoice Nr.:'		,_oFont7N,_nTm3-3,10,, 0, 0 )
	_nLin += _nTLin
	_oPrinter:SayAlign(_nLin,_nP1+3,Alltrim(TEXP->ROUTE),_oFont8N,_nTm3-3,10,, 0, 0 )
	_oPrinter:SayAlign(_nLin,_nP2+3,Alltrim(TEXP->LOADIN),_oFont8N,_nTm3-3,10,, 0, 0 )
	_oPrinter:SayAlign(_nLin,_nP3+3,Alltrim(TEXP->PROCESSO),_oFont8N,_nTm3-3,10,, 0, 0 )
	_nLin += _nTLin+2
	_oPrinter:Line(_nLin,_nCol,_nLin,_nColTot)
	_oPrinter:SayAlign(_nLin,_nP1+3,'Port of Discharge:'	,_oFont7N,_nTm3-3,10,, 0, 0 )
	_oPrinter:SayAlign(_nLin,_nP2+3,'Country of Discharge:'	,_oFont7N,_nTm3-3,10,, 0, 0 )
	_oPrinter:SayAlign(_nLin,_nP3+3,'Date:'					,_oFont7N,_nTm3-3,10,, 0, 0 )
	_nLin += _nTLin
	_oPrinter:SayAlign(_nLin,_nP1+3,Alltrim(TEXP->UNLOAD),_oFont8N,_nTm3-3,10,, 0, 0 )
	_oPrinter:SayAlign(_nLin,_nP2+3,Alltrim(TEXP->PAISDES),_oFont8N,_nTm3-3,10,, 0, 0 )
	_oPrinter:SayAlign(_nLin,_nP3+3,Alltrim(TEXP->DTPROCES),_oFont8N,_nTm3-3,10,, 0, 0 )


	_nLin += _nTLin+2
	_oPrinter:Line(_nBkLin,_nP2,_nLin,_nP2)
	_oPrinter:Line(_nBkLin,_nP3,_nLin,_nP3)

	_oPrinter:Line(_nLin,_nCol,_nLin,_nColTot)

	_nPosIRod := _nLinTot - _nTamRod
	_nPs := _nCol
	_nLiBk := _nLin
	For _a := 1 to Len(_aCabec)
		_nTm := (_aCabec[_a][1] / 100) * _nTmPag
		_aCabec[_a][2] := _nTm
		_aCabec[_a][3] := _nPs

		If Len(_aCabec[_a][4]) = 1
			_oPrinter:SayAlign(_nLin+5,_nPs+_aCabec[_a][6],_aCabec[_a][4][1],_oFont7N,_nTm-_aCabec[_a][7],7,, _aCabec[_a][5] , 0 )
		Else
			_oPrinter:SayAlign(_nLin	,_nPs+_aCabec[_a][6],_aCabec[_a][4][1],_oFont7N,_nTm-_aCabec[_a][7],7,, _aCabec[_a][5] , 0 )
			_oPrinter:SayAlign(_nLin+8	,_nPs+_aCabec[_a][6],_aCabec[_a][4][2],_oFont7N,_nTm-_aCabec[_a][7],7,, _aCabec[_a][5] , 0 )
		Endif

		_oPrinter:Line(_nLiBk,_nPs,_nPosIRod,_nPs)

		_nPs += _nTm
	Next _a

	_nLin += 10
	_nLin += _nTLin

	_oPrinter:Line(_nLin,_nCol,_nLin,_nColTot)

Return()



Static Function FooterPL()

	TEXP->(dbGoTop())

	_oPrinter:Line(_nPosIRod,_nCol,_nPosIRod,_nColTot)
	_nLiR := _nPosIRod
	_oPrinter:SayAlign(_nLiR,_nCol+3,'Total of Packs:',_oFont8N,100,7,, 0, 0 )
	If _nTCaixa = 1
		_oPrinter:SayAlign(_nLiR,_nCol+80,Alltrim(str(_nTCaixa)) + ' CARDBOARD BOX',_oFont8N,200,7,, 0, 0 )
	Else
		_oPrinter:SayAlign(_nLiR,_nCol+80,Alltrim(str(_nTCaixa)) + ' CARDBOARD BOXES',_oFont8N,200,7,, 0, 0 )
	Endif
	_oPrinter:SayAlign(_nLiR,_aCabec[7][3]+3,'Total',_oFont8N,_aCabec[7][2],7,, 0, 0 )
	_oPrinter:SayAlign(_nLiR,_aCabec[8][3],Alltrim(str(_nPesLiq,,2)),_oFont8N,_aCabec[8][2]-3,7,, 1, 0 )
	_oPrinter:SayAlign(_nLiR,_aCabec[9][3],Alltrim(str(_nPesBru,,2)),_oFont8N,_aCabec[9][2]-3,7,, 1, 0 )
	
	_nLiR += _nTLin+3
	_oPrinter:Line(_nPosIRod,_aCabec[7][3],_nLiR,_aCabec[7][3])
	_oPrinter:Line(_nPosIRod,_aCabec[8][3],_nLiR,_aCabec[8][3])
	_oPrinter:Line(_nPosIRod,_aCabec[9][3],_nLiR,_aCabec[9][3])
	_oPrinter:Line(_nLiR,_aCabec[7][3],_nLiR,_nColTot)


	_nLiR += (_nTLin*2)
	_oPrinter:SayAlign(_nLiR,_nColTot-300,'_________________________________________________________',_oFont8N,295,7,,1, 0 )
	_nLiR += _nTLin
	_oPrinter:SayAlign(_nLiR,_nColTot-250,Alltrim(TEXP->RESPONS),_oFont8N,250,7,,2, 0 )

Return(Nil)



Static Function AtuSX1()

	_cPerg := "CR0119"
	_aRegs := {}

	//    	   Grupo/Ordem/Pergunt      /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01        /defspa1/defeng1/Cnt01/Var02/Def02    /Defspa2/defeng2/Cnt02/Var03/Def03			/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3   /cPyme/cGrpSxg/cHelp)
	U_CRIASX1(_cPerg,"01","Processo    ",""       ,""      ,"mv_ch1","C" ,20     ,0      ,0     ,"G",""        ,"MV_PAR01",""           ,""     ,""     ,""   ,""   ,""       ,""     ,""     ,""   ,""   ,""   			,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"EEC",""   ,""     ,)
	U_CRIASX1(_cPerg,"02","Documentos  ",""       ,""      ,"mv_ch2","N" ,01     ,0      ,0     ,"C",""        ,"MV_PAR01","Ambos"      ,""     ,""     ,""   ,""   ,"Invoice",""     ,""     ,""   ,""   ,"Packing List"   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"",""   ,""     ,)

Return(Nil)
