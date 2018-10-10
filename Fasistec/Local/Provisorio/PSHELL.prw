#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "DBSTRUCT.CH"
#INCLUDE "SHELL.CH"

#DEFINE PS_CREATE_EXCEL_FILE	1
#DEFINE PS_ADD_LINE_EXCEL_FILE	2
#DEFINE PS_SHOW_EXCEL_FILE	3

#DEFINE MAX_TOP_SELECT	"50"

//Criar gráfico
//https://codewala.net/2016/09/23/how-to-create-excel-chart-using-powershell-part-2/


/*/
Funcao:	U_T2PSExcel
Autor:	Marinaldo de Jesus (Sharing the Experience)
Data:	19/09/2011
Descricao:	Exemplo de Integracao Totvs/Protheus vs PowerShell & Excel via WaitRun
Sintaxe:
/*/
User Function PSHELL()

	Local lPrepEnv	:= ( IsBlind() .or. ( Select( "SM0" ) == 0 ) )
	Local lSetCentury	:= .F.

	IF ( lPrepEnv )
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
	EndIF

	SetsDefault()
	lSetCentury	:= __SetCentury( "ON" )

	MsgRun( "Aguarde...." , "Gerando Planilha Excel...." , { || T2PSExcel() } )

	IF ( lPrepEnv )
		RESET ENVIRONMENT
	EndIF

	__SetCentury( IF( lSetCentury , "ON" , "OFF" ) )

Return( NIL )

/*/
Funcao:	T2PSExcel
Autor:	Marinaldo de Jesus (Sharing the Experience)
Data:	19/09/2011
Descricao:	Exemplo de Integracao Totvs/Protheus vs PowerShell & Excel via WaitRun
Sintaxe:
/*/
Static Function T2PSExcel()

	Local aDbStruct

	Local cPath	:= GetTempPath()
	Local cQuery	:= ""
	Local cExcelFile

	Local cNextAlias	:= GetNextAlias()

	Local nLine


	Local cExcelFile	:= ( CriaTrab( NIL , .F. ) + ".xlsx" )
	Local cNewExcelFile	:= ""


	Local cPsFile	:= ( CriaTrab( NIL , .F. ) + ".ps1" )
	Local cStrLine	:= ""
	Local cPsScript	:= ""
	Local cNewPsFile	:= ""
	Local cWaitRunCmd	:= ""

	Local lStatus	:= .F.


	cPsScript := "Powershell -noexit $excel = New-Object -ComObject excel.application" + CRLF
	cPsScript += "$excel.Application.Visible = $true " + CRLF
	cPsScript += "$excel.DisplayAlerts = $false " + CRLF

	cPsScript += "$book = $excel.Workbooks.Add() " + CRLF
	cPsScript += "$sheet = $book.Worksheets.Item(1) " + CRLF
	cPsScript += "$sheet.name = 'Computer Information'"  + CRLF

	cPsScript += "$sheet.Cells.Item(1,1)= 'Coluna 1'" + CRLF
	cPsScript += "$sheet.Cells.Item(1,2)= 30" + CRLF
	cPsScript += "$sheet.Cells.Item(2,1)= 'Linha 1'" + CRLF
	cPsScript += "$sheet.Cells.Item(2,2)= 80" + CRLF
/*
	cPsScript += "#merging a few cells on the top row to make the title look nicer;" + CRLF
	cPsScript += "$MergeCells = $sheet.Range('A5:G5')" + CRLF
	cPsScript += "$MergeCells.Select() " + CRLF
	cPsScript += "$MergeCells.MergeCells = $true " + CRLF
	cPsScript += "$sheet.Cells(5, 1).HorizontalAlignment = -4108" + CRLF
	cPsScript += "$dummy = Release-Ref($oExcel)	| Out-Null" + CRLF

	cPsScript += "$sheet.Cells.Item(5,1).Font.Size = 18 " + CRLF
	cPsScript += "$sheet.Cells.Item(5,1).Font.Bold=$True " + CRLF
	cPsScript += "$sheet.Cells.Item(5,1).Font.Name = 'Cambria' " + CRLF
	cPsScript += "$sheet.Cells.Item(5,1).Font.ThemeFont = 1 " + CRLF
	cPsScript += "$sheet.Cells.Item(5,1).Font.ThemeColor = 4 " + CRLF
	cPsScript += "$sheet.Cells.Item(5,1).Font.ColorIndex = 55 " + CRLF
	cPsScript += "$sheet.Cells.Item(5,1).Font.Color = 8210719 " + CRLF

	cPsScript += "$sheet.Cells.Item(5,1)= 'Teste Merge' " + CRLF
*/
	cPsScript += "#adjusting the column width so all datas properly visible " + CRLF
	cPsScript += "$usedRange = $sheet.UsedRange	" + CRLF
	cPsScript += "$usedRange.EntireColumn.AutoFit() | Out-Null" + CRLF


	cPsScript += "#$sheet.activate() " + CRLF
	cPsScript += "$DataforFirstChart = $sheet.Range('A1').CurrentRegion " + CRLF
	cPsScript += "$firstChart = $sheet.Shapes.AddChart().Chart " + CRLF
	cPsScript += "$firstChart.chartType = 60 " + CRLF
//	cPsScript += "$firstChart.chartType = xlCylinderColClustered " + CRLF
	cPsScript += "# Providing the source data " + CRLF
	cPsScript += "$firstChart.SetSourceData($DataforFirstChart) " + CRLF
	cPsScript += "$firstChart.HasTitle = $true " + CRLF
	cPsScript += "# Providing the Title for the chart " + CRLF
	cPsScript += "#$firstChart.ChartTitle.Text = 'Domain controllers usage- Bar Chart' " + CRLF

	cPsScript += "$sheet.shapes.item('Chart 1').top = 100 " + CRLF
	cPsScript += "$sheet.shapes.item('Chart 1').left = 0 " + CRLF

	cPsScript += "$book.Worksheets.Add() " + CRLF
	cPsScript += "$sheet2 = $book.Worksheets.Item(1) " + CRLF
	cPsScript += "$sheet2.name = 'Teste'"  + CRLF


	cPsScript += "#$excel.Quit()" + CRLF
	cPsScript += "$dummy = Release-Ref($oExcel)	| Out-Null " + CRLF

	cPsScript += "Exit " + CRLF

	WaitRun( cPsScript , SW_HIDE )

Return( lStatus )

