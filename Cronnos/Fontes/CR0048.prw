#INCLUDE "Totvs.ch"


/*/
Funçao    	³ 	CR0048
Autor 		³ 	Fabiano da Silva
Data 		³ 	04.11.13
Descricao 	³ 	Relatório de Exportação
/*/


User Function CR0048()

	LOCAL oDlg := NIL

	PRIVATE cTitulo    	:= "Relatório Exportação"
	PRIVATE _cAno     	:= Alltrim(Str(Year(dDataBase)))

	_nOpc := 0

	DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
	@ 004,010 TO 060,157 LABEL "" OF oDlg PIXEL

	@ 010,017 SAY "Esta rotina tem por objetivo gerar relatório " 	OF oDlg PIXEL Size 150,010
	@ 020,017 SAY "em Excel dos Processos de exportação." 					OF oDlg PIXEL Size 150,010
	@ 040,017 SAY "Programa CR0048.PRW                           " 		OF oDlg PIXEL Size 150,010
		
	@ 065,017 SAY "Ano referencia:" 									OF oDlg PIXEL Size 080,010
	@ 065,075 MsGet _cAno												OF oDlg PIXEL Size 030,010
		
	@ 15,165 BUTTON "OK" 		 SIZE 036,012 ACTION (_nOpc := 1,oDlg:End()) 	OF oDlg PIXEL
	@ 40,165 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	If _nOpc = 1
		Private _lFim      := .F.
		Private _cMsg01    := ''
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| CR048A(@_lFim) }
		Private _cTitulo01 := 'Processando'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
	Endif


Return(Nil)



Static Function CR048A(_lFim)

	Local oFwMsEx 		:= NIL
	Local cArq 			:= ""
	Local cDir 			:= GetSrvProfString("Startpath","")
	Local cWorkSheet	:= ""
	Local cTable 		:= ""
	Local cDirTmp 		:= GetTempPath()
		   
	oFwMsEx := FWMsExcel():New()

	_cDtRef := CTod(('01/01/'+_cAno))
	_cDtFim := CTod(('31/12/'+_cAno))

	EEC->(dbSetOrder(12))
	EEC->(msSeek(xFilial("EEC")+Dtos(_cDtRef),.T.))
	
	Private _cCond := "EEC->EEC_DTEMBA <= _cDtFim "

	ProcRegua(LastRec())

	cWorkSheet 	:= 	"Relatório Exportação"
	cTable 		:= 	"Exportação"

	oFwMsEx:AddWorkSheet( cWorkSheet )
	oFwMsEx:AddTable( cWorkSheet, cTable )
			
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Cliente"   		, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Loja"   			, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Invoice"   		, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Dt. Invoice"  		, 1,4,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Valor US$"			, 3,2,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Prazo"   			, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Dt. Embarque"   	, 1,4,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Conhecimento"		, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "RE"  				, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "SD"   				, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Contrato Câmbio" 	, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Ordem Pagto"   	, 1,1,.F.)
//	oFwMsEx:AddColumn( cWorkSheet, cTable , "Dt. Credito"		, 1,1,.F.)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "BUE"   			, 1,1,.F.)

	While !EEC->(eof()) .And. !_lFim .And. &_cCond
	
		IncProc()
		
		nFobValue  := (EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"))
		_nVlOut    := EEC->EEC_FRPCOM+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2")-EEC->EEC_DESCON
		_nAbat     := EEC->EEC_FRPREV + EEC->EEC_SEGPRE + _nVlOut
		_nVlTotExw := nFobValue //- _nAbat
	                          
		_cNumCont  := SPACE(20)
		_cOrdPgto  := SPACE(20)
		_dCredito  := CTOD("  /  /  ")
		_cObs      := SPACE(40)
	
		EEQ->(dbSetOrder(4))
		If EEQ->(msseek(xFilial("EEQ")+EEC->EEC_NRINVO))
			_cNumCont := EEQ->EEQ_NROP
			_cOrdPgto := EEQ->EEQ_RFBC
			_dCredito := EEQ->EEQ_DTCE
			_cObs     := Substr(EEQ->EEQ_OBS,1,15)
		Endif
				
		oFwMsEx:AddRow( cWorkSheet, cTable,{;
			EEC->EEC_IMPORT	,;
			EEC->EEC_IMLOJA	,;
			EEC->EEC_PREEMB	,;
			EEC->EEC_DTPROC ,;
			_nVlTotExw   	,;
			EEC->EEC_DIASPA	,;
			EEC->EEC_DTEMBA	,;
			EEC->EEC_NRCONH	,;
			EEC->EEC_NUMRE	,;
			EEC->EEC_NUMSD	,;
			_cNumCont		,;
			_cOrdPgto		,;
			_cObs			})
//		_dCredito		,;
	

		EEC->(dbSkip())
	EndDo

	oFwMsEx:Activate()
		
	cArq := CriaTrab( NIL, .F. ) + ".xml"
	
	LjMsgRun( "Gerando o arquivo, aguarde...", "Pedido de Compras", {|| oFwMsEx:GetXMLFile( cArq ) } )
	
	If __CopyFile( cArq, cDirTmp + cArq )
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDirTmp + cArq )
		oExcelApp:SetVisible(.T.)

	Else
		MsgInfo( "Arquivo não copiado para temporário do usuário." )

		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDir + cArq )
		oExcelApp:SetVisible(.T.)
	Endif

Return


