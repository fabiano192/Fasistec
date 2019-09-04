#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "DBSTRUCT.CH"
#INCLUDE "SHELL.CH"
#INCLUDE "FILEIO.CH"

#DEFINE PS_CREATE_EXCEL_FILE			1
#DEFINE PS_ADD_LINE_EXCEL_FILE			2
#DEFINE PS_SHOW_EXCEL_FILE				3
#DEFINE PS_COPY_EXCEL_SRV_LOCAL_FILE	4

#DEFINE MAX_TOP_SELECT					"50"

Static __cCRLF := CRLF

User Function T2PSExcel()

	Local lPrepEnv		:= ( IsBlind() .or. ( Select( "SM0" ) == 0 ) )
	Local lSetCentury	:= .F.

	IF ( lPrepEnv )
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
	EndIF

	SetsDefault()
	lSetCentury			:= __SetCentury( "ON" )

	MsgRun( "Aguarde...." , "Gerando Planilha Excel no Client" , { || GeraExcel() } )

	IF ( lPrepEnv )
		RESET ENVIRONMENT
	EndIF

	__SetCentury( IF( lSetCentury , "ON" , "OFF" ) )

Return( NIL )




Static Function GeraExcel()

//		cWaitRunCmd	:= "PowerShell -NonInteractive -WindowStyle Hidden -File " + cNewPsFile + ""
		cWaitRunCmd	:= "PowerShell -NonInteractive -WindowStyle "

		lStatus		:= ( WaitRun( cWaitRunCmd , SW_HIDE ) == 0 )


	cWaitRunCmd += "# -----------------------------------------------------" +CRLF 
	cWaitRunCmd += "function Release-Ref ($ref) { " +CRLF
	cWaitRunCmd += "([System.Runtime.InteropServices.Marshal]::ReleaseComObject(" +CRLF 
	cWaitRunCmd += "[System.__ComObject]$ref) -gt 0) " +CRLF
	cWaitRunCmd += "[System.GC]::Collect() " +CRLF
	cWaitRunCmd += "[System.GC]::WaitForPendingFinalizers()" +CRLF 
	cWaitRunCmd += "} " +CRLF
	cWaitRunCmd += "# -----------------------------------------------------" +CRLF 

	cWaitRunCmd += "$objExcel = new-object -comobject excel.application  " +CRLF
	cWaitRunCmd += "$objExcel.Visible = $True  " +CRLF
	cWaitRunCmd += "$objWorkbook = $objExcel.Workbooks.Open("C:\Pasta1.xls")" +CRLF 
	cWaitRunCmd += "$objWorksheet = $objWorkbook.Worksheets.Item(1) " +CRLF
	cWaitRunCmd += "$intRow = 2 " +CRLF
	cWaitRunCmd += "Do { " +CRLF
	cWaitRunCmd += ""Codigo: " + $objWorksheet.Cells.Item($intRow, 1).Value()" +CRLF 
	cWaitRunCmd += ""Descricao: " + $objWorksheet.Cells.Item($intRow,2).Value() " +CRLF
	cWaitRunCmd += ""Valor: " + $objWorksheet.Cells.Item($intRow,3).Value() " +CRLF
	cWaitRunCmd += "$intRow++ " +CRLF
	cWaitRunCmd += "} " +CRLF
	cWaitRunCmd += "While ($objWorksheet.Cells.Item($intRow,1).Value() -ne $null)" +CRLF 
	cWaitRunCmd += "$objExcel.Quit() " +CRLF
	cWaitRunCmd += "$a = Release-Ref($objWorksheet)" +CRLF 
	cWaitRunCmd += "$a = Release-Ref($objWorkbook) " +CRLF
	cWaitRunCmd += "$a = Release-Ref($objExcel)" +CRLF



Return(Nil)