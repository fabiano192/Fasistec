#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ASC008   ºAutor  ³Alexandro da silva  º Data ³  29/01/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faturamento Por Modalidade de Recebimento                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ASC008()

	Local oDlg              // Nome do objeto referente a Dialog

	Private _aCabec := {}
	Private _aItens := {}

	_aAliORI := GetArea()
	_aAliSX2 := SX2->(GetArea())
	_aAliSX3 := SX3->(GetArea())

	ATUSX1()

	_nOpc := 0

	DEFINE MSDIALOG oDlg  FROM 0,0 TO 160,350 TITLE "Faturamento Por Modalidade" OF oDlg PIXEL

	@ 02,10 TO 050,168 OF oDlg PIXEL

	@ 10,18 SAY "Rotina Exportar o Relatorio das Vendas Em Excel  " OF oDlg PIXEL
	@ 18,18 SAY "Por Modalidade de Recebimento.              .    " OF oDlg PIXEL
	@ 34,18 SAY "                                                 " OF oDlg PIXEL

	DEFINE SBUTTON FROM 055,016 TYPE 5  ACTION Pergunte("ASC008")    ENABLE Of oDlg   // PARAAMETROS
	DEFINE SBUTTON FROM 055,078 TYPE 1  ACTION (_nOpc:=1,oDlg:END()) ENABLE Of oDlg   // CONFIRMAR
	DEFINE SBUTTON FROM 055,138 TYPE 2  ACTION oDlg:End() 		 	 ENABLE Of oDlg

	ACTIVATE MSDIALOG oDlg CENTERED


	If _nOpc == 1 .Or. _nOpc == 3

		Private _lFim      := .F.
		Private _cMsg01    := ''
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| ASC008_A(@_lFim) }
		Private _cTitulo01 := 'Gerando Relatorio!!!!'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	Endif


Return

Static function ASC008_A()

	local nFor
	Pergunte("ASC008",.F.)

	Private aSelFil	 := {}

	If MV_PAR03 == 1
		If Empty(aSelFil)
			If FindFunction("AdmSelecFil")
				AdmSelecFil("ASC008",03,.F.,@aSelFil,"SE1",.F.)
			Else
				aSelFil := AdmGetFil(.F.,.F.,"SE1")
				If Empty(aSelFil)
					Aadd(aSelFil,cFilAnt)
				Endif
			Endif
		Endif
	Endif

	If !Empty(aSelFil)
		If len(aSelFil) > 1
			nI := 1
			If ascan(aSelFil, cFilAnt) != 0 .and. aSelFil[nI] !=  cFilAnt
				aSelFil[ascan(aSelFil, cFilAnt)] := aSelFil[nI]
				aSelFil[nI] := cFilAnt
			EndIf
		EndIf
	EndIf

	cRetornoIn := ""
	nFor       := 0

	For nFor := 1 To Len(aSelFil)
		cRetornoIn += aSelFil[nFor] + '|'
	Next nFor

	_cFiltroF := " IN " + FormatIn( SubStr( cRetornoIn , 1 , Len( cRetornoIn ) -1 ) , '|' )

/*
_cq := " SELECT F2_FILIAL AS FILIAL, "

	If cEmpAnt == "04"
	_cq += " NOMEFILIAL = CASE	WHEN F2_FILIAL = '01' THEN 'MSP' "
	_cq += " 		 			WHEN F2_FILIAL = '02' THEN 'MSP-ROMEIROS' END,"
	ElseIf cEmpAnt == "06"
	_cq += " NOMEFILIAL = CASE	WHEN F2_FILIAL = '02' THEN 'VPE' END,"
	ElseIf cEmpAnt == "13"
	_cq += " NOMEFILIAL = CASE	WHEN F2_FILIAL = '01' THEN 'IRO-MRO' "
	_cq += " 		 			WHEN F2_FILIAL = '04' THEN 'IRO-MBA' "
	_cq += " 					WHEN F2_FILIAL = '06' THEN 'IRO-MRO' "
	_cq += " 					WHEN F2_FILIAL = '07' THEN 'IRO-MBA' END,  "
	ElseIf cEmpAnt == "50"
	_cq += " NOMEFILIAL = CASE	WHEN F2_FILIAL = '01' THEN 'PX-IBA' "
	_cq += " 		 			WHEN F2_FILIAL = '02' THEN 'PX-IRO' "
	_cq += " 					WHEN F2_FILIAL = '03' THEN 'PX-IFT' "
	_cq += " 					WHEN F2_FILIAL = '04' THEN 'PX-INT' "
	_cq += " 					WHEN F2_FILIAL = '05' THEN 'PX-DUQ' "
	_cq += " 					WHEN F2_FILIAL = '06' THEN 'PX-IGU' "
	_cq += " 					WHEN F2_FILIAL = '07' THEN 'PX-ICC' "
	_cq += " 					WHEN F2_FILIAL = '08' THEN 'PX-ISL' "
	_cq += " 					WHEN F2_FILIAL = '09' THEN 'PX-IJB' "
	_cq += " 					WHEN F2_FILIAL = '10' THEN 'PX-ISV' "
	_cq += " 					WHEN F2_FILIAL = '11' THEN 'PX-IRB' "
	_cq += " 					WHEN F2_FILIAL = '12' THEN 'PX-AE ' "
	_cq += " 					WHEN F2_FILIAL = '13' THEN 'PX-IPT' "
	_cq += " 					WHEN F2_FILIAL = '14' THEN 'PX-MT ' "
	_cq += " 					WHEN F2_FILIAL = '15' THEN 'PX-IMC' "
	_cq += " 					WHEN F2_FILIAL = '16' THEN 'PX-INH' END,  "
	Else
	_cq += " '' AS NOMEFILIAL, "
	EndIf

_cq += " TIPOVENDA = CASE  WHEN F2_COND = '000' AND F2_XNCCRED <> '' THEN 'CARTAO' "
_cq += "  				   WHEN F2_COND = '000' AND F2_XNCCRED = ''  THEN 'DEPOSITO' "
_cq += " 				   WHEN F2_COND <> '000'                     THEN 'BOLETO' END, "
_cq += " F2_DOC AS TITULO,F2_SERIE AS SERIE,F2_CLIENTE AS CLIENTE,F2_LOJA AS LOJA,A1_NOME AS NOME,F2_COND AS COND_PAGTO, "
_cq += " F2_EMISSAO AS EMISSAO,F2_XNCCRED AS AUT_CARTAO,F2_VALFAT AS VALOR FROM "+RetSqlName("SF2")+" A "
_cq += " INNER JOIN "+RetSqlName("SA1")+" B ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA "
_cq += " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND F2_DUPL <> '' "
_cq += " AND F2_TIPO = 'N' "
	If MV_PAR03 == 1
	_cq += " AND F2_FILIAL "+_cFiltroF+" "
	Endif

_cq += " ORDER BY FILIAL,TIPOVENDA,TITULO "
*/                                         

	_cq := " SELECT E1_FILIAL AS FILIAL, " + CRLF

	If cEmpAnt == "04"
		_cq += " NOMEFILIAL = CASE	WHEN E1_FILIAL = '01' THEN 'MSP' " + CRLF
		_cq += " 		 			WHEN E1_FILIAL = '02' THEN 'MSP-ROMEIROS' END," + CRLF
	ElseIf cEmpAnt == "06"
		_cq += " NOMEFILIAL = CASE	WHEN E1_FILIAL = '02' THEN 'VPE' END," + CRLF
	ElseIf cEmpAnt == "13"
		_cq += " NOMEFILIAL = CASE	WHEN E1_FILIAL = '01' THEN 'IRO-MRO' " + CRLF
		_cq += " 		 			WHEN E1_FILIAL = '04' THEN 'IRO-MBA' " + CRLF
		_cq += " 					WHEN E1_FILIAL = '06' THEN 'IRO-MRO' " + CRLF
		_cq += " 					WHEN E1_FILIAL = '07' THEN 'IRO-MBA' END,  " + CRLF
	ElseIf cEmpAnt == "50"
		_cq += " NOMEFILIAL = CASE	WHEN E1_FILIAL = '01' THEN 'PX-IBA' " + CRLF
		_cq += " 		 			WHEN E1_FILIAL = '02' THEN 'PX-IRO' " + CRLF
		_cq += " 					WHEN E1_FILIAL = '03' THEN 'PX-IFT' " + CRLF
		_cq += " 					WHEN E1_FILIAL = '04' THEN 'PX-INT' " + CRLF
		_cq += " 					WHEN E1_FILIAL = '05' THEN 'PX-DUQ' " + CRLF
		_cq += " 					WHEN E1_FILIAL = '06' THEN 'PX-IGU' " + CRLF
		_cq += " 					WHEN E1_FILIAL = '07' THEN 'PX-ICC' " + CRLF
		_cq += " 					WHEN E1_FILIAL = '08' THEN 'PX-ISL' " + CRLF
		_cq += " 					WHEN E1_FILIAL = '09' THEN 'PX-IJB' " + CRLF
		_cq += " 					WHEN E1_FILIAL = '10' THEN 'PX-ISV' " + CRLF
		_cq += " 					WHEN E1_FILIAL = '11' THEN 'PX-IRB' " + CRLF
		_cq += " 					WHEN E1_FILIAL = '12' THEN 'PX-AE ' " + CRLF
		_cq += " 					WHEN E1_FILIAL = '13' THEN 'PX-IPT' " + CRLF
		_cq += " 					WHEN E1_FILIAL = '14' THEN 'PX-MT ' " + CRLF
		_cq += " 					WHEN E1_FILIAL = '15' THEN 'PX-IMC' " + CRLF
		_cq += " 					WHEN E1_FILIAL = '16' THEN 'PX-INH' END,  " + CRLF
	Else
		_cq += " '' AS NOMEFILIAL, " + CRLF
	EndIf

	_cq += " TIPOVENDA = CASE  WHEN E1_XNCCRED <> '' 	THEN 'CARTAO' " + CRLF
	_cq += "  				   WHEN E1_YDEPIDE <> ''  	THEN 'DEPOSITO' " + CRLF
	_cq += "				   WHEN F2_COND <> '000'    THEN 'BOLETO' ELSE 'DINHEIRO' END,  " + CRLF
	_cq += " E1_PREFIXO AS PREFIXO,E1_NUM AS TITULO,E1_PARCELA AS PARCELA,E1_CLIENTE AS CLIENTE,E1_LOJA AS LOJA,A1_NOME AS NOME,F2_COND AS COND_PAGTO, " + CRLF
	_cq += " E1_EMISSAO AS EMISSAO,E1_XNCCRED AS AUT_CARTAO,E1_YDEPIDE AS COD_DEP,E1_VALOR  AS VALOR FROM "+RetSqlName("SE1")+" A " + CRLF
	_cq += " INNER JOIN "+RetSqlName("SF2")+" B ON E1_FILIAL = F2_FILIAL AND E1_NUM = F2_DOC AND E1_PREFIXO = F2_SERIE AND E1_CLIENTE = F2_CLIENTE " + CRLF
	_cq += " AND E1_LOJA = F2_LOJA " + CRLF
	_cq += " INNER JOIN "+RetSqlName("SA1")+" C ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA " + CRLF
	_cq += " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND C.D_E_L_E_T_ = ''  AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND F2_DUPL <> '' " + CRLF
	_cq += " AND F2_TIPO = 'N' " + CRLF
	If MV_PAR03 == 1
		_cq += " AND E1_FILIAL "+_cFiltroF+" " + CRLF
	Endif

	_cq += " ORDER BY FILIAL,TIPOVENDA,TITULO " + CRLF

	Memowrite("C:\TEMP\ASC008.TXT",_cq)

	TCQUERY _cQ NEW ALIAS "ZZ"

	Count to _nTZZ

	If _nTZZ = 0
		ZZ->(dbCloseArea())
		ShowHelpDlg("ASC008_1", {'Não foram encontrados dados com os parâmetros informados.'},1,{'Valide os parâmetros informados.'},1)
		Return(Nil)
	Endif

	TcSetField("ZZ","VALOR"  ,"N",17,2)
	TcSetField("ZZ","EMISSAO","D",08,0)

	ZZ->(dbGotop())

	_oFwMsEx := FWMsExcel():New()

	_cWorkSheet 	:= 	"Faturamento"
	_cTable 		:= 	"Faturamento por Modalidade de Recebimento de "+dtoc(MV_PAR01)+" e "+dtoc(MV_PAR02)

	_oFwMsEx:AddWorkSheet( _cWorkSheet )
	_oFwMsEx:AddTable( _cWorkSheet, _cTable )

	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "FILIAL"			, 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "NOMEFILIAL"		, 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "TIPOVENDA"   	, 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "PREFIXO"		, 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "TITULO"   		, 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "PARCELA"   		, 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "CLIENTE"  		, 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "LOJA"   		, 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "NOME"   		, 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "COND_PAGTO"		, 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "EMISSAO"  		, 1,4,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "AUT_CARTAO"		, 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "COD_DEP"		, 1,1,.F.)
	_oFwMsEx:AddColumn( _cWorkSheet, _cTable , "VALOR"			, 3,2,.T.)

	While ZZ->(!EOF())

		_oFwMsEx:AddRow( _cWorkSheet, _cTable,{;
			ZZ->FILIAL		,; // FILIAL
			ZZ->NOMEFILIAL	,; // NOMEFILIAL
			ZZ->TIPOVENDA	,; // TIPOVENDA
			ZZ->PREFIXO		,; // PREFIXO
			ZZ->TITULO		,; // TITULO
			ZZ->PARCELA		,; // PARCELA
			ZZ->CLIENTE		,; // CLIENTE
			ZZ->LOJA		,; // LOJA
			ZZ->NOME		,; // DTPGTO
			ZZ->COND_PAGTO	,; // COND_PAGTO
			ZZ->EMISSAO		,; // EMISSAO
			ZZ->AUT_CARTAO	,; // AUT_CARTAO
			ZZ->COD_DEP		,; // COD_DEP
			ZZ->VALOR		}) // VALOR

		ZZ->(dbSkip())
	EndDo


	ZZ->(dbCloseArea("ZZ"))

	_oFwMsEx:Activate()

	_cArq := CriaTrab( NIL, .F. ) + ".xls"

	LjMsgRun( "Gerando o arquivo, aguarde...", "Pontualidade de Entrega", {|| _oFwMsEx:GetXMLFile( _cArq ) } )

	_cDat1		:= GravaData(dDataBase,.f.,8)
	_cHor1		:= Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

	_cNomArq := "Faturamento_"+_cDat1+"_"+_cHor1+".xls"

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


/*
	_cArq := CriaTrab(NIL,.F.)
	Copy To &_cArq

	dbCloseArea()

	_cInd := "FILIAL + TIPOVENDA + TITULO "

	dbUseArea(.T.,,_cArq,"ZZ",.T.)
	IndRegua("ZZ",_cArq,_cInd,,,"Selecionando Arquivo Trabalho")

	_cData   := DTOS(dDataBase)
	_cUser   := RetCodUsr()
	_cNomArq := "\DOCS\ASC008_"+_cData+"_"+_cUser+".XLS"

	dbSelectArea("ZZ")
	COPY ALL TO &_cNomArq VIA "DBFCDXADS"

	dbCloseArea("ZZ")


	_cDir:= "C:\TOTVS"

	If !ExistDir( _cDir )
		If MakeDir( _cDir ) <> 0
			MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
			Return
		EndIf
	EndIf

	If !__CopyFile(_cNomArq, "C:\TOTVS\ASC008_"+_cData+"_"+_cUser+".XLS" )
		MSGAlert("O arquivo não foi copiado!", "AQUIVO NÃO COPIADO!")
	Endif

	If ! ApOleClient( 'MsExcel' )
		MsgStop('MsExcel nao instalado')
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( "C:\TOTVS\ASC008_"+_cData+"_"+_cUser+".XLS" )
		oExcelApp:SetVisible(.T.)
	Endif
*/
Return



Static Function AtuSX1()

	cPerg  := "ASC008"

//         Grupo/Ordem/Pergunta    				/perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01    	/defspa1/defeng1/Cnt01  /Var02/Def02			/Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3	  /cPyme	/cGrpSxg/cHelp
	U_CRIASX1(cPerg,"01" ,"Data De           ?"		,""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR01",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,""	  ,		,		,      	)
	U_CRIASX1(cPerg,"02" ,"Data Ate       	 ?"     ,""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,""   	  ,		,		,		)
	U_CRIASX1(cPerg,"03" ,"Seleciona Filiais ?"     ,""       ,""      ,"mv_ch3","N" ,01     ,0      ,0     ,"C",""        ,"MV_PAR03","Sim"        ,""     ,""     ,""     ,""   ,"Nao"            ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,""   	  ,		,		,		)

Return (Nil)