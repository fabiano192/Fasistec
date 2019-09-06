#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'

/*
Programa	:	PA0245
Autor		:	Fabiano da Silva
Data		:	30/06/14
Descrição	:	dados Lead Time	
*/

User Function PA0245()

	Local oDlg              // Nome do objeto referente a Dialog
	
	_nOpc := 0

	DEFINE MSDIALOG oDlg  FROM 0,0 TO 160,380 TITLE "Dados Lead Time" OF oDlg PIXEL

	@ 02,10 TO 050,180 OF oDlg PIXEL

	@ 10,18 SAY "Rotina Gerar a Base de dados do Lead Time dos Produtos	" 					OF oDlg PIXEL
	@ 26,18 SAY "                                                   " OF oDlg PIXEL
	@ 34,18 SAY "Programa PA0245.PRW                                " OF oDlg PIXEL

	DEFINE SBUTTON FROM 055,080 TYPE 1 ACTION (_nOpc:=1,oDlg:END()) ENABLE Of oDlg
	DEFINE SBUTTON FROM 055,130 TYPE 2 ACTION oDlg:End() 			ENABLE Of oDlg

	ACTIVATE MSDIALOG oDlg CENTERED

	If _nOpc == 1
		
		Private _lFim      := .F.
		Private _cMsg01    := ''
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| PA245_A(@_lFim) }
		Private _cTitulo01 := 'Gerando Relatório!!!!'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

	Endif

Return


Static Function PA245_A()

	Local oFwMsEx 		:= NIL
	Local cArq 			:= ""
	Local cDir 			:= GetSrvProfString("Startpath","")
	Local cWorkSheet	:= ""
	Local cTable1 		:= ""
	Local cTable2 		:= ""
	Local cDirTmp 		:= GetTempPath()
	Local _cDir			:= "C:\TOTVS\"
	
	_cQuery := " SELECT B1_COD,B1_TIPO,B1_PE FROM "+RetSqlName("SB1")+" B1 "
	_cQuery += " WHERE B1.D_E_L_E_T_ = '' AND B1_TIPO = 'MP' "
	_cQuery += " ORDER BY B1_COD "

	TCQUERY _cQuery NEW ALIAS "TSB1"
	
	COUNT TO nRec

	If nRec > 0

		cWorkSheet  := "Lead_Time"
		cTable     := "Lead_Time"
	   
		oFwMsEx := FWMsExcel():New()

		oFwMsEx:AddWorkSheet( cWorkSheet )

		oFwMsEx:AddTable( cWorkSheet, cTable )
	
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto" 		, 1,1,.F.)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Tipo"  		, 1,1,.F.)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Lead_Time"		, 3,2,.F.)

		dbSelectArea("TSB1")
	
		TSB1->(dbGotop())

		TSB1->(ProcRegua(0))

		While TSB1->(!Eof())
		
			TSB1->(IncProc())

			oFwMsEx:AddRow( cWorkSheet, cTable,{;
				TSB1->B1_COD	,;
				TSB1->B1_TIPO 	,;
				TSB1->B1_PE   	})
	
			TSB1->(dbSkip())
		EndDo
		
		TSB1->(dbCloseArea())
	
		oFwMsEx:Activate()
		
		cArq := CriaTrab( NIL, .F. ) + ".xls"
	
		LjMsgRun( "Gerando o arquivo, aguarde...", "Vendas com Custo", {|| oFwMsEx:GetXMLFile( cArq ) } )
		
		If !ExistDir( _cDir )
			If MakeDir( _cDir ) <> 0
				MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
				Return
			EndIf
		EndIf

		_cNomArq := "LEAD_TIME_PASY.XLS"
	
		If __CopyFile(cArq, _cDir + _cNomArq)

			FErase(cArq)
		
			If ! ApOleClient( 'MsExcel' )
				MsgStop('MsExcel nao instalado')
				Return
			EndIf

			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( _cDir + _cNomArq )
			oExcelApp:SetVisible(.T.)

		Else
			MSGAlert("O arquivo não foi copiado!", "AQUIVO NÃO COPIADO!")
		Endif
	
	Endif
	
Return
	