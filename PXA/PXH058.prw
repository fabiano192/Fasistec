#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"

/*
Programa 	: PXH058
Autor 		: Fabiano da Silva	-	21/06/12
Uso 		: SIGAFIN - Financeiro
Descrição 	: Gerar Relatório Financeiro por Natureza
*/

USER FUNCTION PXH058()

	LOCAL oDlg := NIL

	PRIVATE cTitulo    	:= "Relatório Financeiro - PXH058"
	PRIVATE oPrn       	:= NIL
	PRIVATE oFont08     := NIL
	PRIVATE oFont10     := NIL
	PRIVATE oFont10B    := NIL
	PRIVATE oFont14	    := NIL
	PRIVATE oFont12B    := NIL
	PRIVATE oFont16B    := NIL
	PRIVATE _nCont     	:= 0
	Private _nLin
	Private _lEnt

	AtuSx1()

	DEFINE FONT oFont08 	NAME "Arial" SIZE 0,08 OF oPrn
	DEFINE FONT oFont10 	NAME "Arial" SIZE 0,10 OF oPrn
	DEFINE FONT oFont10B 	NAME "Arial" SIZE 0,10 OF oPrn BOLD
	DEFINE FONT oFont14 	NAME "Arial" SIZE 0,14 OF oPrn
	DEFINE FONT oFont12B 	NAME "Arial" SIZE 0,12 OF oPrn BOLD
	DEFINE FONT oFont16B 	NAME "Arial" SIZE 0,16 OF oPrn BOLD

	_nOpc := 0

	DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

	@ 010,010 TO 060,210 LABEL "" OF oDlg PIXEL

	@ 013,017 SAY "Esta rotina tem por objetivo gerar Relatório	Financeiro por cr	" 	OF oDlg PIXEL Size 180,010 FONT oFont14
	@ 023,017 SAY "conforme os parâmetros informados pelo usuário. " 						OF oDlg PIXEL Size 180,010 FONT oFont14

	@ 70,020 BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("PXH058"))		OF oDlg PIXEL
	@ 70,090 BUTTON "OK" 		 SIZE 036,012 ACTION (_nOpc := 1,oDlg:End()) 	OF oDlg PIXEL
	@ 70,160 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 				OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	If _nOpc = 1
		Private _lFim      := .F.
		Private _cMsg01    := ''
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| PXH58A(@_lFim) }
		Private _cTitulo01 := 'Processando'
	
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	Endif

Return(Nil)


Static Function PXH58A()

	Pergunte("PXH058",.F.)

	If MV_PAR11 == 1

		_cQuery  := " SELECT E5_FILIAL AS FILIAL, E5_PREFIXO AS PREFIXO, E5_NUMERO AS NUMERO,E5_PARCELA AS PARCELA,E5_TIPO AS TIPO,E2_CC AS CUSTO, " + CRLF
		_cQuery  += " E5_CLIFOR AS CLIFOR, E5_LOJA AS LOJA, A2_NREDUZ AS NOME,E2_VENCREA AS VENCREA, E5_DTDISPO AS DTDISPO, E5_MOTBX AS MOTBX, " + CRLF
		_cQuery  += " E5_TIPODOC AS TIPODOC, E2_VALOR AS E2VALOR, E5_VALOR AS E5VALOR " + CRLF
		_cQuery  += " FROM "+RetSqlName("SE5")+" E5 (NOLOCK) " + CRLF
		_cQuery  += " LEFT JOIN "+RetSqlName("SED")+" ED ON ED_CODIGO = E5_NATUREZ AND ED.D_E_L_E_T_ = ''" + CRLF
		_cQuery  += " INNER JOIN "+RetSqlName("SE2")+" E2 ON E2_FILIAL= E5_FILIAL AND E2_PREFIXO=E5_PREFIXO AND E2_NUM=E5_NUMERO " + CRLF
		_cQuery  += " AND E2_PARCELA=E5_PARCELA AND E2_FORNECE=E5_FORNECE AND E2_LOJA=E5_LOJA AND E2_TIPO=E5_TIPO  " + CRLF
//		_cQuery  += " LEFT JOIN "+RetSqlName("CTT")+" CT ON  E2_CC= CTT_CUSTO AND E2_FILIAL = CTT_FILIAL AND CT.D_E_L_E_T_ = '' " + CRLF
		_cQuery  += " LEFT JOIN "+RetSqlName("SA2")+" A2 ON E5_CLIFOR = A2_COD AND E5_LOJA = A2_LOJA AND A2.D_E_L_E_T_ = ''" + CRLF
		_cQuery  += " WHERE E5.D_E_L_E_T_ = '' AND E2.D_E_L_E_T_ = '' " + CRLF
		_cQuery  += " AND E5_FILIAL  BETWEEN '"+MV_PAR01+"' 	  AND '"+MV_PAR02+"' " + CRLF
		_cQuery  += " AND E5_DTDISPO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' " + CRLF
		_cQuery  += " AND E5_CLIFOR  BETWEEN '"+MV_PAR05+"' 	  AND '"+MV_PAR06+"' " + CRLF
		_cQuery  += " AND E2_CC      BETWEEN '"+MV_PAR07+"' 	  AND '"+MV_PAR08+"' " + CRLF
		_cQuery  += " AND E5_NATUREZ BETWEEN '"+MV_PAR09+"'       AND '"+MV_PAR10+"' " + CRLF
		_cQuery  += " AND E5_SITUACA = '' AND E5_TIPODOC NOT IN ('JR','MT','DC','CH') " + CRLF
//		_cQuery  += " ORDER BY E2_CC,E5_FILIAL,E5_DTDISPO" + CRLF

		_cQuery  += " UNION ALL " + CRLF

		_cQuery  += " SELECT E5_FILIAL AS FILIAL, E5_PREFIXO AS PREFIXO, E5_DOCUMEN AS NUMERO,E5_PARCELA AS PARCELA,E5_TIPO AS TIPO,E5_CCD AS CUSTO, " + CRLF
		_cQuery  += " E5_CLIFOR AS CLIFOR, E5_LOJA AS LOJA, A2_NREDUZ AS NOME,E5_DTDISPO AS VENCREA, E5_DTDISPO AS DTDISPO, E5_MOTBX AS MOTBX, " + CRLF
		_cQuery  += " E5_TIPODOC AS TIPODOC, E5_VALOR AS E2VALOR, E5_VALOR AS E5VALOR " + CRLF
		_cQuery  += " FROM "+RetSqlName("SE5")+" E5 (NOLOCK) " + CRLF
		_cQuery  += " LEFT JOIN "+RetSqlName("SED")+" ED ON ED_CODIGO = E5_NATUREZ AND ED.D_E_L_E_T_ = ''" + CRLF
//		_cQuery  += " LEFT JOIN "+RetSqlName("CTT")+" CT ON  E2_CC= CTT_CUSTO AND E2_FILIAL = CTT_FILIAL AND CT.D_E_L_E_T_ = '' " + CRLF
		_cQuery  += " LEFT JOIN "+RetSqlName("SA2")+" A2 ON E5_CLIFOR = A2_COD AND E5_LOJA = A2_LOJA AND A2.D_E_L_E_T_ = ''" + CRLF
		_cQuery  += " WHERE E5.D_E_L_E_T_ = ''  " + CRLF
		_cQuery  += " AND E5_FILIAL  BETWEEN '"+MV_PAR01+"' 	  AND '"+MV_PAR02+"' " + CRLF
		_cQuery  += " AND E5_DTDISPO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' " + CRLF
		_cQuery  += " AND E5_CLIFOR  BETWEEN '"+MV_PAR05+"' 	  AND '"+MV_PAR06+"' " + CRLF
		_cQuery  += " AND E5_CCD     BETWEEN '"+MV_PAR07+"' 	  AND '"+MV_PAR08+"' " + CRLF
		_cQuery  += " AND E5_NATUREZ BETWEEN '"+MV_PAR09+"'       AND '"+MV_PAR10+"' " + CRLF
		_cQuery  += " AND E5_SITUACA = '' AND E5_TIPODOC NOT IN ('JR','MT','DC','CH') " + CRLF
		_cQuery  += " AND E5_RECPAG = 'P' AND E5_NUMERO = '' AND E5_MOEDA = 'M1' " + CRLF
		_cQuery  += " ORDER BY CUSTO,FILIAL,DTDISPO" + CRLF

		TCQUERY _cQuery NEW ALIAS "TSE5"

		TcSetField("TSE5","DTDISPO","D")
		TcSetField("TSE5","VENCREA","D")

//		MemoWrite("D:\PXH058A.TXT",_cQuery)

		oPrn 	:= TMSPrinter():New(cTitulo)
		oPrn:SetPortrait()

		_nLin  	:= 4000
		_lEnt  	:= .F.
		_cQuebra:= _cQueb1  := ""
		_nTotal := _nTGeral := 0

		TSE5->(dbGoTop())

		ProcRegua(LastRec())

		While TSE5->(!EOF())
	
			IncProc()
	
			CheckLine()
	
//			_cCCusto := If(!Empty(Alltrim(TSE5->E2_CC)),Alltrim(TSE5->E2_CC),Alltrim(TSE5->E5_CCC))
			_cCCusto := Alltrim(TSE5->CUSTO)
			_cDescCC := ''
	
			CTT->(dbsetOrder(1))
			If CTT->(msSeek(xFilial('CTT')+_cCCusto))
				_cDescCC := CTT->CTT_DESC01
			Endif
	
//			_cCr        := Alltrim(TSE5->E2_CC)+' - '+ Alltrim(TSE5->CTT_DESC01)
			_cCr        := Alltrim(_cCCusto)+' - '+ Alltrim(_cDescCC)
	
			_cQueb1  := _cCr
	
			If _cQuebra <> _cQueb1
		
				If _lEnt
					oPrn:Say(_nLin,0200, "TOTAL: "+_cQuebra						,oFont10B)
					oPrn:Say(_nLin,2420, TRANS(_nTotal, "@E 999,999,999.99")	,oFont10B,,,,1)
					_nLin += 80
			
					_nTotal  := 0
			
					CheckLine()
				Endif
		
				oBrush := TBrush():New( , CLR_HGRAY)
				oPrn:FillRect( {_nLin, 80, _nLin+40, 2450}, oBrush)
		
				oPrn:Say(_nLin,0200, _cCr	,oFont10B)
		
				_nLin += 40
		
				CheckLine()
			Endif
	
			_cQuebra  := _cCr
	
			_nVlPg := TSE5->E5VALOR
			_cCor  := CLR_BLACK
			If TSE5->TIPODOC = 'ES'
				_nVlPg := TSE5->E5VALOR * -1		
				_cCor  := CLR_HRED
			Endif
	
			oPrn:Say(_nLin,0090,TSE5->FILIAL								,oFont10,,_cCor)
			oPrn:Say(_nLin,0200,TSE5->PREFIXO							,oFont10,,_cCor)
			oPrn:Say(_nLin,0300,TSE5->NUMERO								,oFont10,,_cCor)
			oPrn:Say(_nLin,0490,TSE5->PARCELA							,oFont10,,_cCor)
			oPrn:Say(_nLin,0550,TSE5->TIPO								,oFont10,,_cCor)
			_cFornece := TSE5->CLIFOR +'/'+ TSE5->LOJA +' - '+ Alltrim(TSE5->NOME)
			oPrn:Say(_nLin,0650,_cFornece									,oFont10,,_cCor)
			oPrn:Say(_nLin,1330,DTOC(TSE5->VENCREA)						,oFont10,,_cCor)
			oPrn:Say(_nLin,1530,DTOC(TSE5->DTDISPO)						,oFont10,,_cCor)
			oPrn:Say(_nLin,1750,TSE5->MOTBX								,oFont10,,_cCor)
			oPrn:Say(_nLin,1860,TSE5->TIPODOC							,oFont10,,_cCor)
			oPrn:Say(_nLin,2170,TRANS(TSE5->E2VALOR, "@E 999,999,999.99")	,oFont10,,_cCor,,1)
			oPrn:Say(_nLin,2420,TRANS(_nVlPg, "@E 999,999,999.99")			,oFont10,,_cCor,,1)
	
			_nTotal  += _nVlPg
			_nTGeral += _nVlPg
			
			_lEnt := .T.
			_nLin += 40
		
			TSE5->(dbSkip())
		EndDo

		If _lEnt
	
			CheckLine()
	
			oPrn:Say(_nLin,0200, "TOTAL: "+_cQuebra						,oFont10B)
			oPrn:Say(_nLin,2420, TRANS(_nTotal, "@E 999,999,999.99")	,oFont10B,,,,1)
	
			_nLin += 80
	
			CheckLine()
	
			oPrn:Line(_nLin,0080,_nLin,2450)
			_nLin    += 10
	

			CheckLine()
	
			oPrn:Say(_nLin,0200, "TOTAL GERAL"								,oFont10B)
			oPrn:Say(_nLin,2420, TRANS(_nTGeral, "@E 999,999,999.99")		,oFont10B,,,,1)
		
			Ms_Flush()
			oPrn:EndPage()
			oPrn:End()
	
			oPrn:Preview()
		Else
			MsgInfo('Não existem dados para impressão!')
		Endif

		TSE5->(dbCloseArea())

	Else
	
		_cQuery  := " SELECT E5.E5_FILIAL AS FILIAL,E2.E2_CC AS CUSTO,CT.CTT_DESC01 AS DCUSTO,E5.E5_TIPODOC AS TIPODOC, "+ CRLF
		_cQuery  += " SUM(E5.E5_VALOR) AS PAGAR, SUM(E5_VALOR) AS PAGO "+ CRLF 
		_cQuery  += " FROM "+RetSqlName("SE5")+" E5 (NOLOCK) " + CRLF
		_cQuery  += " INNER JOIN "+RetSqlName("SE2")+" E2 ON E2.E2_FILIAL = E5.E5_FILIAL AND E2.E2_PREFIXO=E5.E5_PREFIXO AND E2.E2_NUM=E5.E5_NUMERO " + CRLF
		_cQuery  += " AND E2.E2_PARCELA=E5.E5_PARCELA AND E2.E2_FORNECE=E5.E5_FORNECE AND E2.E2_LOJA=E5.E5_LOJA AND E2.E2_TIPO=E5.E5_TIPO " + CRLF
		_cQuery  += " LEFT JOIN "+RetSqlName("CTT")+" CT ON  E2.E2_CC = CT.CTT_CUSTO AND E2.E2_FILIAL = CT.CTT_FILIAL AND CT.D_E_L_E_T_ = '' " + CRLF
		_cQuery  += " WHERE E5.D_E_L_E_T_ = '' AND E2.D_E_L_E_T_ = '' " + CRLF
		_cQuery  += " AND E5.E5_FILIAL  BETWEEN '"+MV_PAR01+"' 	  AND '"+MV_PAR02+"' " + CRLF
		_cQuery  += " AND E5.E5_DTDISPO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' " + CRLF
		_cQuery  += " AND E5.E5_CLIFOR  BETWEEN '"+MV_PAR05+"' 	  AND '"+MV_PAR06+"' " + CRLF
		_cQuery  += " AND E2.E2_CC      BETWEEN '"+MV_PAR07+"' 	  AND '"+MV_PAR08+"' " + CRLF
		_cQuery  += " AND E5.E5_NATUREZ BETWEEN '"+MV_PAR09+"'       AND '"+MV_PAR10+"' " + CRLF
		_cQuery  += " AND E5.E5_SITUACA = '' AND E5.E5_TIPODOC NOT IN ('JR','MT','DC','CH') " + CRLF
		_cQuery  += " GROUP BY E5.E5_FILIAL,E2.E2_CC,CT.CTT_DESC01,E5.E5_TIPODOC " + CRLF
//		_cQuery  += " ORDER BY E2.E2_CC,E5.E5_FILIAL " + CRLF

		_cQuery  += " UNION ALL "+ CRLF
		
		_cQuery  += " SELECT E5.E5_FILIAL AS FILIAL,E5.E5_CCD AS CUSTO,CT.CTT_DESC01 AS DCUSTO,E5.E5_TIPODOC AS TIPODOC, "+ CRLF
		_cQuery  += " SUM(E5.E5_VALOR) AS PAGAR, SUM(E5_VALOR) AS PAGO "+ CRLF 
		_cQuery  += " FROM "+RetSqlName("SE5")+" E5 (NOLOCK) " + CRLF
		_cQuery  += " LEFT JOIN "+RetSqlName("CTT")+" CT ON  E5.E5_CCD = CT.CTT_CUSTO AND E5.E5_FILIAL = CT.CTT_FILIAL AND CT.D_E_L_E_T_ = '' " + CRLF
		_cQuery  += " WHERE E5.D_E_L_E_T_ = '' " + CRLF
		_cQuery  += " AND E5.E5_FILIAL  BETWEEN '"+MV_PAR01+"' 	  AND '"+MV_PAR02+"' " + CRLF
		_cQuery  += " AND E5.E5_DTDISPO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' " + CRLF
		_cQuery  += " AND E5.E5_CLIFOR  BETWEEN '"+MV_PAR05+"' 	  AND '"+MV_PAR06+"' " + CRLF
		_cQuery  += " AND E5.E5_CCD     BETWEEN '"+MV_PAR07+"' 	  AND '"+MV_PAR08+"' " + CRLF
		_cQuery  += " AND E5.E5_NATUREZ BETWEEN '"+MV_PAR09+"'       AND '"+MV_PAR10+"' " + CRLF
		_cQuery  += " AND E5.E5_SITUACA = '' AND E5.E5_TIPODOC NOT IN ('JR','MT','DC','CH') " + CRLF
		_cQuery  += " AND E5_RECPAG = 'P' AND E5_NUMERO = '' AND E5_MOEDA = 'M1' " + CRLF
		_cQuery  += " GROUP BY E5.E5_FILIAL,E5.E5_CCD,CT.CTT_DESC01,E5.E5_TIPODOC " + CRLF
		_cQuery  += " ORDER BY CUSTO,FILIAL " + CRLF

		TCQUERY _cQuery NEW ALIAS "TSE5"

//		MemoWrite("D:\PXH058S.TXT",_cQuery)

		oPrn 	:= TMSPrinter():New(cTitulo)
		oPrn:SetPortrait()

		_nLin  	 := 4000
		_lEnt  	 := .F.
		_nTPagar := 0
		_nTPago  := 0

		TSE5->(dbGoTop())

		ProcRegua(LastRec())

		While TSE5->(!EOF())
	
			IncProc()
	
			CheckLine()
												
			_nVlPg := TSE5->PAGO
			_cCor  := CLR_BLACK
			If TSE5->TIPODOC = 'ES'
				_nVlPg := TSE5->PAGO * -1		
				_cCor  := CLR_HRED
			Endif

			oPrn:Say(_nLin,0090,TSE5->FILIAL								,oFont10,,_cCor)
			oPrn:Say(_nLin,0250,TSE5->CUSTO									,oFont10,,_cCor)
			oPrn:Say(_nLin,0490,TSE5->DCUSTO								,oFont10,,_cCor)
			oPrn:Say(_nLin,1860,TSE5->TIPODOC							,oFont10,,_cCor)
			oPrn:Say(_nLin,2170,TRANS(TSE5->PAGAR	, "@E 999,999,999.99")	,oFont10,,_cCor,,1)
			oPrn:Say(_nLin,2420,TRANS(_nVlPg		, "@E 999,999,999.99")	,oFont10,,_cCor,,1)
			
			_nTPagar 	+= _nVlPg
			_nTPago 	+= _nVlPg
			_lEnt 		:= .T.
			_nLin 		+= 40
		
			TSE5->(dbSkip())
		EndDo

		If _lEnt
	
			CheckLine()
	
			oPrn:Line(_nLin,0080,_nLin,2450)
			_nLin    += 10
	
			CheckLine()
	
			oPrn:Say(_nLin,0250, "TOTAL GERAL"								,oFont10B)
			oPrn:Say(_nLin,2170, TRANS(_nTPagar	, "@E 999,999,999.99")		,oFont10B,,,,1)
			oPrn:Say(_nLin,2420, TRANS(_nTPago	, "@E 999,999,999.99")		,oFont10B,,,,1)
		
			Ms_Flush()
			oPrn:EndPage()
			oPrn:End()
	
			oPrn:Preview()
		Else
			MsgInfo('Não existem dados para impressão!')
		Endif

		TSE5->(dbCloseArea())
	
	Endif
	
Return (Nil)


STATIC FUNCTION Cabec() //Cabeçalho

//	oPrn:SayBitmap(0095,0090,"lgrl01.bmp",0250,0070)

	oPrn:Box(0080,0080,0330,2450)

	oPrn:Say(0190,0090,Alltrim(SM0->M0_NOMECOM),oFont12B)

	oPrn:Line(0080,0800,0330,0800)

	oPrn:Say(0125,0900,'Relatório Financeiro - Pagos',oFont16B)
	oPrn:Say(0205,1050,'Por Centro de Custo',oFont16B)

	oPrn:Line(0080,1810,0330,1810)

	oPrn:Say(0090,1820,"Filial:"			,oFont10)
	oPrn:Say(0090,2000,MV_PAR01				,oFont10)
	oPrn:Say(0090,2200,'a'					,oFont10)
	oPrn:Say(0090,2260,MV_PAR02				,oFont10)
	oPrn:Say(0130,1820,"Data:"				,oFont10)
	oPrn:Say(0130,2000,dToc(MV_PAR03)		,oFont10)
	oPrn:Say(0130,2200,'a'					,oFont10)
	oPrn:Say(0130,2260,dToc(MV_PAR04)		,oFont10)
	oPrn:Say(0170,1820,"Fornec.:"			,oFont10)
	oPrn:Say(0170,2000,MV_PAR05				,oFont10)
	oPrn:Say(0170,2200,'a'					,oFont10)
	oPrn:Say(0170,2260,MV_PAR06				,oFont10)
	oPrn:Say(0210,1820,"C.Custo:"			,oFont10)
	oPrn:Say(0210,2000,MV_PAR07				,oFont10)
	oPrn:Say(0210,2200,'a'					,oFont10)
	oPrn:Say(0210,2260,MV_PAR08				,oFont10)
	oPrn:Say(0250,1820,"Natureza:"			,oFont10)
	oPrn:Say(0250,2000,MV_PAR09				,oFont10)
	oPrn:Say(0250,2200,'a'					,oFont10)
	oPrn:Say(0250,2260,MV_PAR10				,oFont10)
	oPrn:Say(0290,1820,"Tipo:"				,oFont10)
	oPrn:Say(0290,2000,If(MV_PAR11 = 1,'Analítico','Sintético')	,oFont10)

	oPrn:Box(0340,0080,0390,2450)

	oPrn:Say(0344,0090,"FL"				,oFont10B)
	If MV_PAR11 = 1
		oPrn:Say(0344,0200,"PRF"			,oFont10B)
		oPrn:Say(0344,0300,"Titulo"			,oFont10B)
		oPrn:Say(0344,0490,"P"				,oFont10B)
		oPrn:Say(0344,0550,"TPT"			,oFont10B)
		oPrn:Say(0344,0650,"Fornecedor"		,oFont10B)
		oPrn:Say(0344,1320,"DT. Vencto"		,oFont10B)
		oPrn:Say(0344,1530,"DT. Pagto"		,oFont10B)
		oPrn:Say(0344,1750,"MBX"			,oFont10B)
	Else
		oPrn:Say(0344,0250,"CR"				,oFont10B)
		oPrn:Say(0344,0490,"Descrição"		,oFont10B)		
		oPrn:Say(0344,1800,"TP"				,oFont10B)
	Endif
	oPrn:Say(0344,1860,"TP"				,oFont10B)
	oPrn:Say(0344,1990,"Valor Titulo"	,oFont10B)
	oPrn:Say(0344,2250,"Valor Pago"		,oFont10B)

	_nCont ++

//Rodapé
	oPrn:Line(3300,0080,3300,2450)
	oPrn:Say(3305,1900,dtoc(dDataBase)+' - '+ Time() +' - '+ 'Página: '+STRZERO(_nCont,3),oFont10B)

Return()


Static Function CheckLine()

	If _nLin > 3200
		If _lEnt
			oPrn:EndPage()
		Endif
		oPrn:StartPage()
		Cabec(_nCont)
		_nLin    := 410
	Endif

Return()



Static Function AtuSx1(cPerg)

	Local aHelp := {}
	cPerg       := "PXH058"

//    	   Grupo/Ordem/Pergunta     	         /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01       /defspa1/defeng1/Cnt01/Var02/Def02		/Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(cPerg,"01","Filial de            ?",""       ,""      ,"mv_ch1","C" ,05     ,0      ,0     ,"G",""        ,"MV_PAR01",""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SM0")
	U_CRIASX1(cPerg,"02","Filial ate           ?",""       ,""      ,"mv_ch2","C" ,05     ,0      ,0     ,"G",""        ,"MV_PAR02",""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SM0")
	U_CRIASX1(cPerg,"03","Data Pagto de        ?",""       ,""      ,"mv_ch3","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR03",""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"04","Data Pagto ate       ?",""       ,""      ,"mv_ch4","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR04",""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"05","Fornecedor de        ?",""       ,""      ,"mv_ch5","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR05",""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SA2")
	U_CRIASX1(cPerg,"06","Fornecedor ate       ?",""       ,""      ,"mv_ch6","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR06",""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SA2")
	U_CRIASX1(cPerg,"07","C.Custo de           ?",""       ,""      ,"mv_ch7","C" ,09     ,0      ,0     ,"G",""        ,"MV_PAR07",""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CTT")
	U_CRIASX1(cPerg,"08","C.Custo ate          ?",""       ,""      ,"mv_ch8","C" ,09     ,0      ,0     ,"G",""        ,"MV_PAR08",""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CTT")
	U_CRIASX1(cPerg,"09","Natureza de          ?",""       ,""      ,"mv_ch9","C" ,10     ,0      ,0     ,"G",""        ,"MV_PAR09",""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SED")
	U_CRIASX1(cPerg,"10","Natureza ate         ?",""       ,""      ,"mv_cha","C" ,10     ,0      ,0     ,"G",""        ,"MV_PAR10",""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SED")
	U_CRIASX1(cPerg,"11","Tipo		           ?",""       ,""      ,"mv_chb","N" ,01     ,0      ,0     ,"C",""        ,"MV_PAR11","Analitico" ,""     ,""     ,""   ,""   ,"Sintético",""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return (Nil)