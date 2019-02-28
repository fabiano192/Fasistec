/*
 ***
	* Exemplo de Uso do Protheus com PowerShell e Excel através da interação com o shell usando WaitRun.
	*
	* **************************************************************************************************************************
	*
	* Função: WaitRun <http://tdn.totvs.com.br/kbm#9634>
	*
	* Executa um programa externo  (arquivo executável) através do sistema operacional da estação onde o Smart Client está sendo
	* executado, e aguarda pelo término do programa externo.
	*
	* Sintaxe: WaitRun ( <cExeName>, [ nOpc] ) --> nStatus
	*
	* **************************************************************************************************************************
    *
	* Por questoes de seguranca, recomendo ler sobre assinatura de script digitando get-help about_signing no Console do Windows
	* PowerShell.
	*
	* **************************************************************************************************************************
	*
	* PS C:\> get-help about_signing | more
	*
	* TÓPICO
	*     about_signing
	*
	*     Explica como assinar scripts em conformidade com as diretiva
	*     execução do Windows PowerShell.
	*
	* DESCRIÇÃO LONGA
	*     A diretiva de execução Restricted não permite a execução de
	*     As diretivas de execução AllSigned e RemoteSigned impedem o
	*     PowerShell de executar scripts sem uma assinatura digital.
	*
	*     Este tópico explica como executar scripts selecionados não
	*     assinados, até mesmo com a diretiva de execução RemoteSigned
	*     como assinar scripts para seu próprio uso.
	*
	*     Para obter mais informações sobre as diretivas de execução d
	*     PowerShell, consulte about_Execution_Policy.
	*
	*
	*  PARA PERMITIR A EXECUÇÃO DE SCRIPTS ASSINADOS
	*  -------------------------------
	*     Quando você inicia o Windows PowerShell pela primeira vez em
	*     computador, é provável que a diretiva de execução Restricted
	*     (padrão) esteja em vigor.
	*
	*     A diretiva Restricted não permite a execução de scripts.
	*
	*     Para determinar qual a diretiva de execução em vigor no seu
	* te:
	*
	*         get-executionpolicy
	*
	*     Para executar scripts não assinados gravados por você no seu
	*     computador local e scripts assinados de outros usuários, use
	*     comando a seguir para alterar a diretiva de execução no
	*     computador para RemoteSigned:
	*
	*         set-executionpolicy remotesigned
	*
	*     Para obter mais informações, consulte Set-ExecutionPolicy.
	*
	* **************************************************************************************************************************
	*
	* Para a didatica do exemplo, autorize a execução dos scripts digitando: Set-ExecutionPolicy unrestricted no Console      do
	* PowerShell como:
	*
	* **************************************************************************************************************************
	*
	* PS C:\> Set-ExecutionPolicy unrestricted
	*
	* Alteração da Diretiva de Execução
	* A diretiva de execução ajuda a proteger contra scripts não confiáveis. A
	* alteração da diretiva de execução pode implicar em exposição aos riscos de
	* segurança descritos no tópico da ajuda about_Execution_Policies. Deseja alterar
	*  a diretiva de execução?
	* [S] Sim  [N] Não  [U] Suspender  [?] Ajuda (o padrão é "S"): S
	*
	* **************************************************************************************************************************
	*
	* Isso permitira que qualquer script seja executado pelo PowerShell. O Recomendado é, por questões óbvias de segurança,  que
	* todo script seja assinado.
	*
	* Para entender e aprender um pouco mais sobre assinatura de um script consulte:
	*
	* Windows PowerShell: about_Signing <http://technet.microsoft.com/pt-br/library/dd347649.aspx>
	* Windows PowerShell: Set-ExecutionPolicy: < http://technet.microsoft.com/pt-br/library/dd347628.aspx>
	* Windows PowerSheel: Protegendo o Shell <http://www.inw-seguranca.com/windows-powersheel-protegendo-o-shell>
	* Windows PowerSheel: Protegendo o Shell <http://www.securityhacker.org/artigos/item/windows-powersheel-protegendo-o-shell>
	* Windows PowerShell: Prevenção contra código mal-intencionado <http://64.4.10.145/pt-br/magazine/cc137728>
	*
	* **************************************************************************************************************************
	*
	* Interessando em entender um pouco mais sobre Windows PowerShell:
	*
	* Windows PowerShell em Ação <http://altabooks.tempsite.ws/capitulos_amostra/wps.pdf>
	* PowerShell Tutorials <http://www.powershellpro.com/powershell-tutorial-introduction/>
	* Windows PowerShell 1.0 Documentation Pack <http://www.microsoft.com/download/en/details.aspx?displaylang=en&id=23407>
    *
	* **************************************************************************************************************************
    *
    * Paleta de Cores do Excel http://dmcritchie.mvps.org/excel/colors.htm
    *
	* **************************************************************************************************************************
 ***
*/

//#INCLUDE "PROTHEUS.CH"
//#INCLUDE "TBICONN.CH"
//#INCLUDE "TOPCONN.CH"
//#INCLUDE "DBSTRUCT.CH"
//#INCLUDE "SHELL.CH"
//#INCLUDE "FILEIO.CH"

#include "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#include "PROTHEUS.CH"
#include "shell.ch"
#include "FILEIO.CH"

#DEFINE PS_CREATE_EXCEL_FILE			1
#DEFINE PS_ADD_LINE_EXCEL_FILE			2
#DEFINE PS_SHOW_EXCEL_FILE				3
#DEFINE PS_COPY_EXCEL_SRV_LOCAL_FILE	4

#DEFINE MAX_TOP_SELECT	"50"

Static __cCRLF := CRLF

/*/
	Funcao:		U_T2PSExcel
	Autor:		Marinaldo de Jesus (Sharing the Experience)
	Data:		25/09/2011
	Descricao:	Exemplo de Integracao Totvs/Protheus vs PowerShell & Excel via WaitRun
	Sintaxe:	<vide parametros formais>
/*/
User Function T2PSExcel()

	Local lPrepEnv		:= ( IsBlind() .or. ( Select( "SM0" ) == 0 ) )
	Local lSetCentury	:= .F.

	SetsDefault()
	lSetCentury			:= __SetCentury( "ON" )

	MsgRun( "Aguarde...." , "Gerando Planilha Excel no Client" , { || T2PSExcel() } )



	__SetCentury( IF( lSetCentury , "ON" , "OFF" ) )

Return( NIL )




/*/
	Funcao:		T2PSExcel
	Autor:		Marinaldo de Jesus (Sharing the Experience)
	Data:		25/09/2011
	Descricao:	Exemplo de Integracao Totvs/Protheus vs PowerShell & Excel via WaitRun
	Sintaxe:	<vide parametros formais>
/*/
Static Function T2PSExcel()

	Local aDbStruct

	Local cSrvPath		:= GetSrvProfString( "StartPath" , "\system\" )
	Local cLocalPath	:= GetTempPath()

	Local cQuery		:= ""
	Local cCSVFile
	Local cExcelFile

	Local cFields
	Local cHeaderFormat
	Local cDetailFormat

	Local cNextAlias	:= GetNextAlias()

	Local nfhCSVFile

	IF !( SubStr( cSrvPath , -1 ) == "\" )
		cSrvPath += "\"
	EndIF

	IF !( SubStr( cLocalPath , -1 ) == "\" )
		cLocalPath += "\"
	EndIF

	cExcelFile		:= PsNewExcelFile( @cSrvPath , @cLocalPath , @cCSVFile , @nfhCSVFile )
	IF !( "ERROR" $ ( cExcelFile + cCSVFile ) )

		cQuery	:= "SELECT" + __cCRLF
		cQuery	+= "	TOP " + MAX_TOP_SELECT + __cCRLF
		cQuery	+= "	SRA.RA_FILIAL," + __cCRLF
		cQuery	+= "	SRA.RA_MAT," + __cCRLF
		cQuery	+= "	'NOME DO FUNCIONARIO' + ' ' +  SRA.RA_FILIAL + ' ' + SRA.RA_MAT AS RA_NOME,					--SRA.RA_NOME" + __cCRLF
		cQuery	+= "	SRA.RA_ADMISSA," + __cCRLF
		cQuery	+= "	SRA.RA_CODFUNC," + __cCRLF
		cQuery	+= "	'FUNCAO DO FUNCIONARIO' + ' ' +  SRA.RA_FILIAL + ' ' + SRA.RA_CODFUNC AS RJ_DESC,	   		--SRJ.RJ_DESC" + __cCRLF
		cQuery	+= "	SRA.RA_SALARIO," + __cCRLF
		cQuery	+= "	SRA.RA_CC," + __cCRLF
		cQuery	+= "	'CENTRO DE CUSTO DO FUNCIONARIO' + ' ' +  SRA.RA_FILIAL + ' ' + SRA.RA_CC AS CTT_DESC01,	--CTT.CTT_DESC01" + __cCRLF
		cQuery	+= "	( " + __cCRLF
		cQuery	+= "		SELECT " + __cCRLF
		cQuery	+= "			COUNT(1) " + __cCRLF
		cQuery	+= "		FROM " + __cCRLF
		cQuery	+= "			" + RetSqlName( "SRB" ) + " SRB WITH (NOLOCK)" + __cCRLF
		cQuery	+= "		WHERE " + __cCRLF
		cQuery	+= "			SRB.RB_FILIAL = SRA.RA_FILIAL " + __cCRLF
		cQuery	+= "		AND" + __cCRLF
		cQuery	+= "			SRB.RB_MAT = SRA.RA_MAT" + __cCRLF
		cQuery	+= "	  ) AS RB_DEP" + __cCRLF
		cQuery	+= "FROM" + __cCRLF
		cQuery	+= "		" + RetSqlName( "SRA" ) + " SRA WITH (NOLOCK)" + __cCRLF
		cQuery	+= "INNER JOIN" + __cCRLF
		cQuery	+= "		" + RetSqlName( "SRJ" ) + " SRJ WITH (NOLOCK)" + __cCRLF
		cQuery	+= "ON" + __cCRLF
		cQuery	+= "(" + __cCRLF
		cQuery	+= "	(" + __cCRLF
		cQuery	+= "		SRJ.RJ_FILIAL = ' '" + __cCRLF
		cQuery	+= "	OR" + __cCRLF
		cQuery	+= "		SRJ.RJ_FILIAL = SRA.RA_FILIAL" + __cCRLF
		cQuery	+= "	)" + __cCRLF
		cQuery	+= "	AND" + __cCRLF
		cQuery	+= "	SRJ.RJ_FUNCAO = SRA.RA_CODFUNC" + __cCRLF
		cQuery	+= ")" + __cCRLF
		cQuery	+= "INNER JOIN" + __cCRLF
		cQuery	+= "		" + RetSqlName( "CTT" ) + " CTT WITH (NOLOCK)" + __cCRLF
		cQuery	+= "ON" + __cCRLF
		cQuery	+= "(" + __cCRLF
		cQuery	+= "	(" + __cCRLF
		cQuery	+= "		CTT.CTT_FILIAL = ' '" + __cCRLF
		cQuery	+= "	OR" + __cCRLF
		cQuery	+= "		CTT.CTT_FILIAL = SRA.RA_FILIAL" + __cCRLF
		cQuery	+= "	)" + __cCRLF
		cQuery	+= "	AND" + __cCRLF
		cQuery	+= "		CTT.CTT_CUSTO = SRA.RA_CC" + __cCRLF
		cQuery	+= ")" + __cCRLF
		cQuery	+= "ORDER BY" + __cCRLF
		cQuery	+= "	SRA.RA_FILIAL," + __cCRLF
		cQuery	+= "	SRA.RA_CC," + __cCRLF
		cQuery	+= "	SRA.RA_MAT" + __cCRLF

		TCQUERY ( cQuery ) ALIAS ( cNextAlias ) NEW

		TcSetField( cNextAlias , "RA_SALARIO"	, GetSx3Cache( "RA_SALARIO" , "X3_TIPO" ) , GetSx3Cache( "RA_SALARIO" , "X3_TAMANHO" ) , GetSx3Cache( "RA_SALARIO" , "X3_DECIMAL" ) )
		TcSetField( cNextAlias , "RA_ADMISSA"	, GetSx3Cache( "RA_ADMISSA" , "X3_TIPO" ) , GetSx3Cache( "RA_ADMISSA" , "X3_TAMANHO" ) , GetSx3Cache( "RA_ADMISSA" , "X3_DECIMAL" ) )
		TcSetField( cNextAlias , "RB_DEP"	    , "N" , 3  , 0 )

		aDbStruct	:= ( cNextAlias )->( dbStruct() )
		nFields		:= Len( aDbStruct )

		( cNextAlias )->( CSVAddExcelLine( @nfhCSVFile , @aDbStruct , @nFields , .T. , @cFields , @cHeaderFormat , @cDetailFormat ) )

		While ( cNextAlias )->( !Eof() )

			( cNextAlias )->( CSVAddExcelLine( @nfhCSVFile , @aDbStruct , @nFields , .F. ) )

			( cNextAlias )->( dbSkip() )

		End While

		( cNextAlias )->( dbCloseArea() )

		fClose( nfhCSVFile )
		nfhCSVFile	:= fOpen( cCSVFile , FO_SHARED )

		IF PsExecute( PS_COPY_EXCEL_SRV_LOCAL_FILE , @cExcelFile , @cSrvPath , @cLocalPath , @cCSVFile )

			IF PsExecute( PS_ADD_LINE_EXCEL_FILE , @cExcelFile , @cSrvPath , @cLocalPath , @cCSVFile , @cFields , @cHeaderFormat , @cDetailFormat )

				PsExecute( PS_SHOW_EXCEL_FILE , @cExcelFile , @cSrvPath , @cLocalPath )

			EndIF

		EndIF

		fClose( nfhCSVFile )
		fErase( cCSVFile )

	EndIF

	dbSelectArea( "SRA" )

Return( NIL )

/*/
	Funcao:		PsAddExcelLine
	Autor:		Marinaldo de Jesus (Sharing the Experience)
	Data:		25/09/2011
	Descricao:	Adiciona uma Nova Linha na Planilha Excel
	Sintaxe:	<vide parametros formais>
/*/
Static Function CSVAddExcelLine( nfhCSVFile , aDbStruct , nFields , lHeader , cFields , cHeaderFormat , cDetailFormat )

	Local cLine			:= ""

	Local cValue
	Local cFieldN
	Local cPicture

	Local nField

	IF ( lHeader )

		cFields	:= ""

		For nField := 1 To nFields

			cFieldN	:= aDbStruct[ nField ][ DBS_NAME ]

			cLine 	+= cFieldN
			cFields += '"'
			cFields += cFieldN
			cFields += '"'

			IF ( nField < nFields )
				cLine		+= "|"
				cFields		+= ","
			EndIF

		Next nField

		cLine 		+= __cCRLF

		fWrite( nfhCSVFile , cLine )

		cLine			:= ""
		cHeaderFormat	:= ""
		cDetailFormat	:= ""

		For nField := 1 To nFields

			cFieldN	:= aDbStruct[ nField ][ DBS_NAME ]

			cValue	:= GetX3Titulo( cFieldN )

			cLine 	+= cValue

			cPicture			:= GetSx3Cache( cFieldN , "X3_PICTURE" )
			cValue				:= AllToChar( FieldGet( nField ) , cPicture )
			DEFAULT cPicture	:= ""

			cDetailFormat += '"'
			IF ( aDbStruct[ nField ][ DBS_TYPE ] == "N" )
				IF ( "@E" $ cPicture )
					cValue	:= StrTran( cValue , "." , "" )
				ElseIF ( "@R" $ cPicture )
					cValue	:= StrTran( cValue , "," , "" )
					cValue	:= StrTran( cValue , "." , "," )
				ElseIF ( "," $ cValue ) .and. ( "." $ cValue )
					cValue	:= StrTran( cValue , "," , "" )
					cValue	:= StrTran( cValue , "." , "," )
				EndIF
				IF ( "," $ cValue )
					cDetailFormat += "#.##0,00"
				Else
					cDetailFormat += "0"
				EndIF
			ElseIF ( aDbStruct[ nField ][ DBS_TYPE ] == "C" )
				IF ( SubStr( cValue , 1 , 1 ) $ "0123456789" )
					cDetailFormat += Replicate( "0" , aDbStruct[ nField ][ DBS_LEN ] )
				Else
					cDetailFormat += "Geral"
				EndIF
			ElseIF ( aDbStruct[ nField ][ DBS_TYPE ] == "D" )
				cDetailFormat += "dd/mm/aaaa"
			EndIF
			cDetailFormat += '"'

			cHeaderFormat += '"'
			cHeaderFormat += "Geral"
			cHeaderFormat += '"'

			IF ( nField < nFields )
				cLine 			+= "|"
				cDetailFormat	+= ","
				cHeaderFormat	+= ","
			EndIF

		Next nField

		cLine 		+= __cCRLF

		fWrite( nfhCSVFile , cLine )

	Else

		For nField := 1 To nFields

			cFieldN				:= aDbStruct[ nField ][ DBS_NAME ]
			cPicture			:= GetSx3Cache( cFieldN , "X3_PICTURE" )
			cValue				:= AllToChar( FieldGet( nField ) , cPicture )
			DEFAULT cPicture	:= ""

			IF ( aDbStruct[ nField ][ DBS_TYPE ] == "N" )
				IF ( "@E" $ cPicture )
					cValue	:= StrTran( cValue , "." , "" )
				ElseIF ( "@R" $ cPicture )
					cValue	:= StrTran( cValue , "," , "" )
					cValue	:= StrTran( cValue , "." , "," )
				ElseIF ( "," $ cValue ) .and. ( "." $ cValue )
					cValue	:= StrTran( cValue , "," , "" )
					cValue	:= StrTran( cValue , "." , "," )
				EndIF
			EndIF

			cLine += cValue

			IF ( nField < nFields )
				cLine 		+= "|"
			EndIF

		Next nField

		cLine 		+= __cCRLF

		fWrite( nfhCSVFile , cLine )

	EndIF

Return( NIL )




/*/
	Funcao:		PsNewExcelFile
	Autor:		Marinaldo de Jesus (Sharing the Experience)
	Data:		25/09/2011
	Descricao:	Cria uma Nova Planilha Excel
	Sintaxe:	<vide parametros formais>
/*/
Static Function PsNewExcelFile( cSrvPath , cLocalPath , cCSVFile , nfhCSVFile )

	Local cExcelFile		:= Lower( CriaTrab( NIL , .F. ) )

	Local cFullCSVFile
	Local cFullExcelFile

	cCSVFile				:= ( cExcelFile +  ".csv" )
	cExcelFile				+= ".xlsx"

	cFullExcelFile			:= ( cLocalPath + cExcelFile )
	While File( cFullExcelFile )
		cExcelFile			:= Lower( CriaTrab( NIL , .F. ) )
		cCSVFile			:= ( cExcelFile +  ".csv" )
		cExcelFile			+= ".xlsx"
		cFullExcelFile		:= ( cLocalPath + cExcelFile )
	End While

	IF PsExecute( PS_CREATE_EXCEL_FILE  , @cFullExcelFile , @cSrvPath , @cLocalPath )

		IF !( File( cFullExcelFile ) )
			cFullExcelFile		:= "ERROR"
			cCSVFile			:= ""
		Else
			cFullCSVFile		:= ( cSrvPath + cCSVFile )
			While File( cFullCSVFile )
				cCSVFile		:= Lower( CriaTrab( NIL , .F. ) )
				cCSVFile		+= ".csv"
				cFullCSVFile	+= ( cSrvPath + cCSVFile )
			End While
			nfhCSVFile			:= fCreate( cCSVFile , FC_NORMAL )
			IF !( File( cFullCSVFile ) )
				cCSVFile		:= "ERROR"
			Else
				cCSVFile		:= cFullCSVFile
			EndIF
			fClose( nfhCSVFile )
			nfhCSVFile			:= fOpen( cCSVFile , FO_READWRITE )
		EndIF

	Else

		cCSVFile				:= ""
		cFullExcelFile			:= "ERROR"

	EndIF

Return( cFullExcelFile )

/*/
	Funcao:		PsExecute
	Autor:		Marinaldo de Jesus (Sharing the Experience)
	Data:		25/09/2011
	Descricao:	Cria e Executa, via WaitRun, os Scripts em PowerShell
	Sintaxe:	<vide parametros formais>
/*/
Static Function PsExecute( nScript , cExcelFile , cSrvPath , cLocalPath , cCSVFile , cFields , cHeaderFormat , cDetailFormat )

	Local cPsScript		:= ""
	Local cNewPsFile	:= ""
	Local cWaitRunCmd	:= ""

	Local cLocalCSV

	Local lStatus		:= .F.
	Local lWriteOk

	Static __cPsFile

	cPsScript 		+= '# -----------------------------------------------------'+ __cCRLF
	cPsScript 		+= 'function Release-Ref ($ref){' + __cCRLF
	cPsScript 		+= '	([System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject]$ref) -gt 0);' + __cCRLF
	cPsScript 		+= '	[System.GC]::Collect();' + __cCRLF
	cPsScript 		+= '	[System.GC]::WaitForPendingFinalizers();' + __cCRLF
	cPsScript 		+= '}' + __cCRLF
	cPsScript 		+= '# -----------------------------------------------------' + __cCRLF
	cPsScript 		+= '$objExcel					= New-Object -Com Excel.Application;' + __cCRLF
	DO CASE
	CASE ( nScript == PS_CREATE_EXCEL_FILE )
		cPsScript 	+= '$objExcel.Visible			= $False;' + __cCRLF
		cPsScript 	+= '$objExcel.DisplayAlerts		= $False;' + __cCRLF
		cPsScript 	+= '$objWorkBook = $objExcel.Workbooks.Add();' + __cCRLF
		cPsScript 	+= '$objWorkBook.SaveAs("'+cExcelFile+'");' + __cCRLF
		cPsScript 	+= '$objExcel.Quit();' + __cCRLF
		cPsScript 	+= '$dummy = Release-Ref($objWorkBook)	| Out-Null;' + __cCRLF
	CASE ( nScript == PS_ADD_LINE_EXCEL_FILE )
		cPsScript 	+= '$objExcel.Visible 			= $False;' + __cCRLF
		cPsScript 	+= '$objExcel.DisplayAlerts		= $False;' + __cCRLF
		cPsScript 	+= '$objWorkBook  				= $objExcel.Workbooks.Open("'+cExcelFile+'");' + __cCRLF
		cPsScript 	+= '$objWorksheet 				= $objWorkBook.Worksheets.Item(1);' + __cCRLF
		cPsScript 	+= '$CSVFile					= "' + cCSVFile + '";' + __cCRLF
		cPsScript 	+= '$objCSV			        	= @(Import-Csv -Path $CSVFile -Delimiter "|" );' + __cCRLF
		cPsScript 	+= '' + __cCRLF
		cPsScript 	+= '[int]$nLine					= 0;' + __cCRLF
		cPsScript 	+= '[int]$nColNum				= 0;' + __cCRLF
		cPsScript 	+= '[int]$nObjCol				= 0;' + __cCRLF
		cPsScript 	+= '[int]$nColFormat			= 0;' + __cCRLF
		cPsScript 	+= '' + __cCRLF
		cPsScript 	+= '[Array]$Fields 				= ' + cFields + ';' + __cCRLF
		cPsScript 	+= '[Array]$HeaderFormat		= ' + cHeaderFormat + ';' + __cCRLF
		cPsScript 	+= '[Array]$DetailFormat		= ' + cDetailFormat + ';' + __cCRLF
		cPsScript 	+= '' + __cCRLF
		cPsScript 	+= '[String]$sColValue			= "";' + __cCRLF
		cPsScript 	+= '[String]$sColFormat			= "";' + __cCRLF
		cPsScript 	+= '' + __cCRLF
		cPsScript 	+= '[boolean]$bHeader			= $False;' + __cCRLF
		cPsScript 	+= '[boolean]$bChangeColor		= $False;' + __cCRLF
		cPsScript 	+= 'for ( $Row = 0 ; $Row -lt $objCSV.Length ; ++$Row )' + __cCRLF
		cPsScript 	+= '{' + __cCRLF
		cPsScript 	+= '	++$nLine' + __cCRLF
		cPsScript 	+= '	$bHeader																= ( $nLine -eq 1 );' + __cCRLF
		cPsScript 	+= '	$nColNum																= 0;' + __cCRLF
		cPsScript 	+= '	$nObjCol																= 0;' + __cCRLF
		cPsScript 	+= '	$nColFormat																= 0;' + __cCRLF
		cPsScript 	+= '	$bChangeColor															= ( ( ( $nLine ) % 2 ) -eq 0 );' + __cCRLF
		cPsScript 	+= '	For ( $Field = 0 ; $Field -lt $Fields.Length ; ++$Field )' + __cCRLF
		cPsScript 	+= '	{' + __cCRLF
		cPsScript 	+= '		++$nColNum;' + __cCRLF
		cPsScript 	+= '		$sColValue															= $objCSV.Get($Row).($Fields[$nObjCol++]);' + __cCRLF
		cPsScript 	+= '		if ( $bHeader  ){' + __cCRLF
		cPsScript 	+= '			$sColFormat														= $HeaderFormat[$nColFormat++];' + __cCRLF
		cPsScript 	+= '		}' + __cCRLF
		cPsScript 	+= '		else{' + __cCRLF
		cPsScript 	+= '			$sColFormat														= $DetailFormat[$nColFormat++];' + __cCRLF
		cPsScript 	+= '		}' + __cCRLF
		cPsScript 	+= '		$objWorksheet.Cells.Item($nLine,$nColNum).Value()					= $sColValue;' + __cCRLF
		cPsScript 	+= '		$objWorksheet.Cells.Item($nLine,$nColNum).NumberFormat				= $sColFormat;' + __cCRLF
		cPsScript 	+= '		if ( $bChangeColor ){' + __cCRLF
		cPsScript 	+= '			$objWorksheet.Cells.Item($nLine,$nColNum).Interior.ColorIndex	= 16;' + __cCRLF
		cPsScript 	+= '		}' + __cCRLF
		cPsScript 	+= '		else {' + __cCRLF
		cPsScript 	+= '			$objWorksheet.Cells.Item($nLine,$nColNum).Interior.ColorIndex	= 15;' + __cCRLF
		cPsScript 	+= '		}' + __cCRLF
		cPsScript 	+= '	}' + __cCRLF
		cPsScript 	+= '}' + __cCRLF
		cPsScript 	+= '$objRange 					= $objWorksheet.UsedRange;' + __cCRLF
		cPsScript 	+= '$objRange.Font.ColorIndex	= 11;' + __cCRLF
		cPsScript 	+= '$objRange.Font.Bold			= $True;' + __cCRLF
		cPsScript 	+= '$objRange.Borders.Color		= 0;' + __cCRLF
		cPsScript 	+= '$objRange.Borders.Weight	= 2;' + __cCRLF
		cPsScript 	+= '[void] $objRange.EntireColumn.Autofit();' + __cCRLF
		cPsScript 	+= '$objRange.EntireColumn.AutoFilter();' + __cCRLF
		cPsScript 	+= '$objWorkBook.Save();' + __cCRLF
		cPsScript 	+= '$objExcel.Quit();' + __cCRLF
		cPsScript 	+= '$dummy 						= Release-Ref($objWorksheet) | Out-Null;' + __cCRLF
		cPsScript 	+= '$dummy 						= Release-Ref($objWorkbook)  | Out-Null;' + __cCRLF
	CASE ( nScript == PS_SHOW_EXCEL_FILE )
		cPsScript 	+= '$objWorkBook				= $objExcel.Workbooks.Open("'+cExcelFile+'");' + __cCRLF
		cPsScript 	+= '$objExcel.Visible			= $True;' + __cCRLF
		cPsScript 	+= '$dummy 						= Release-Ref($objWorksheet) | Out-Null;' + __cCRLF
		cPsScript 	+= '$dummy 						= Release-Ref($objWorkbook)  | Out-Null;' + __cCRLF
	CASE ( nScript == PS_COPY_EXCEL_SRV_LOCAL_FILE )
		cPsScript 	+= '$objExcel.Visible			= $False;' + __cCRLF
		cPsScript 	+= '$objWorkBook				= $objExcel.Workbooks.Open("'+cExcelFile+'");' + __cCRLF
		cPsScript 	+= '$objWorksheet 				= $objWorkBook.Worksheets.Item(1);' + __cCRLF
		cPsScript 	+= '$objWorksheet.Cells.Item(1,1).Activate() | Out-Null;' + __cCRLF
		cPsScript 	+= '$objExcel.DisplayAlerts		= $True;' + __cCRLF
		cPsScript 	+= '$objWorkBook.Save();' + __cCRLF
		cPsScript 	+= '$objExcel.Quit();' + __cCRLF
		cPsScript 	+= '$dummy 						= Release-Ref($objWorksheet) | Out-Null;' + __cCRLF
		cPsScript 	+= '$dummy 						= Release-Ref($objWorkbook)	 | Out-Null;' + __cCRLF
	END CASE
	cPsScript 		+= '$dummy 						= Release-Ref($objExcel)	 | Out-Null;' + __cCRLF

	DEFAULT __cPsFile	:= Lower( ( CriaTrab( NIL , .F. ) + ".ps1" ) )

	cNewPsFile			:= ( cLocalPath + __cPsFile )
	While File( cNewPsFile )
		__cPsFile		:= Lower( CriaTrab( NIL , .F. ) + ".ps1" )
		cNewPsFile		:= ( cLocalPath + __cPsFile )
	End While

	lWriteOk 			:= MemoWrite( cNewPsFile , cPsScript )

	IF ( lWriteOk .and. File( cNewPsFile ) )

		cWaitRunCmd	:= 'PowerShell -NonInteractive -WindowStyle Hidden -File ' + cNewPsFile

		lStatus		:= ( WaitRun( cWaitRunCmd , SW_HIDE ) == 0 )

		IF ( ( lStatus ) .and. ( nScript == PS_COPY_EXCEL_SRV_LOCAL_FILE ) )

			cLocalCSV	:= StrTran( cCSVFile   , cSrvPath , cLocalPath )

			lStatus		:= __CopyFile( cCSVFile , cLocalCSV )

			fErase( cCSVFile )

			IF ( lStatus )

				IF File( cLocalCSV )
					cCSVFile	:= cLocalCSV
				Else
					lStatus		:= .F.
				EndIF

			EndIF

		EndIF

	EndIF

	fErase( cNewPsFile )

Return( lStatus )

/*/
	Funcao:		GetX3Titulo
	Autor:		Marinaldo de Jesus (Sharing the Experience)
	Data:		25/09/2011
	Descricao:	Obtem X3_TITULO conforme Local
	Sintaxe:	<vide parametros formais>
/*/
Static Function GetX3Titulo( cField )
	Local cX3Titulo := GetSx3Cache( cField , "X3_TITULO" )
	IF ( cX3Titulo == NIL )
		cX3Titulo	:= cField
	Else
		cX3Titulo	:= EncodeUTF8( X3Titulo() )
	EndIF
Return( cX3Titulo )