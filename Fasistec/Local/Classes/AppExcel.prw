/*
Copyright 2015 AppSoft - Fabrica de Software

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

#Include "Totvs.ch"

//Dummy Function
User Function APPEXCEL()
Return .T.



/*/{Protheus.doc} AppExcel
Classe principal da biblioteca AppExcel que fornece métodos para gerar Excel com abas no formato XML no Microsiga Protheus

@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type class
/*/
CLASS AppExcel
DATA aSheets 		AS ARRAY 	HIDDEN
DATA nActualSheet 	AS INTEGER 	HIDDEN
DATA cFileName 		AS STRING 	HIDDEN
DATA cDestPath 		AS STRING 	HIDDEN
DATA aCellStyle		AS ARRAY 	HIDDEN

//Class Properties
DATA cClassName AS STRING HIDDEN

METHOD New(cSheetName) CONSTRUCTOR
METHOD SetSheetName(cNamePar)
METHOD SetDestPath( cDestPath )
METHOD AddSheet(cNameSheet)
METHOD AddCell(nRow, nCol, xContent, oStyle, cFormula)
METHOD Merge( nRow, nCol, nMergeAcross, nMergeDown, xContent, oStyle, cFormula )
METHOD Make()
METHOD OpenXML()
METHOD SetFileName(cNamePar)

METHOD SetHorzFrozen( nRows )
METHOD SetVertFrozen( nCols )

//Class Properties
METHOD Destroy()
METHOD ClassName()

ENDCLASS


/*/{Protheus.doc} AppExcel:New
Método construtor da classe AppExcel
@author anderson.toledo
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type constructor
@param cSheetName, caractere, nome que será apresentada na aba (Sheet) do Excel
@example
Local oExcel := AppExcel():New("Teste")
@type method
/*/
METHOD New(cSheetName,_cPath) CLASS APPEXCEL

	DEFAULT cSheetName := "Plan1"

	::cClassName 	:= "AppExcel"

	::aSheets 		:= {}
	::aCellStyle    := {}

	aAdd(::aSheets, AppExcSheet():New(cSheetName) )
	::nActualSheet := 1

	::cFileName := CriaTrab(,.F.)+".xml"

	If ValType(_cPath) = 'U'
		::cDestPath := GetTempPath()
	Else
		::cDestPath := _cPath
	Endif

RETURN


/*/{Protheus.doc} AppExcel:SetFileName
Método para alterar o nome do arquivo XML a ser gerado, o nome do arquivo não deve conter a extensão

@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type method
@param cNamePar, caractere, nome do arquivo XML a ser gerado
@example
oExcel:setFileName("rel_excel")
/*/
METHOD SetFileName(cNamePar) CLASS APPEXCEL
	::cFileName := cNamePar
RETURN

/*/{Protheus.doc} AppExcel:SetSheetName
Método para alterar o nome da aba (Sheet) atual
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type method
@param cNamePar, caractere, nome a ser atribuido a aba (Sheet) atual
@example
oExcel:setSheetName("Nova aba")
/*/
METHOD SetSheetName(cNamePar) CLASS APPEXCEL
	::aSheets[::nActualSheet]:SetName(cNamePar)
RETURN

/*/{Protheus.doc} AppExcel:SetDestPath
Método para alterar a pasta destino

@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type method
@param cDestPath, caractere, caminho do qual será gerado o arquivo XML
@example
oExcel:setDestPath("c:\temp\")
/*/
METHOD SetDestPath( cDestPath ) CLASS APPEXCEL
	::cDestPath := cDestPath
RETURN

/*/{Protheus.doc} AppExcel:AddSheet
Cria uma nova aba na planilha
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type method
@param cNameSheet, caractere, nome da aba (Sheet) que será adicionada na planilha
@example
oExcel:addSheet("Nova aba")
/*/
METHOD AddSheet(cNameSheet) CLASS APPEXCEL
	aAdd(::aSheets, AppExcSheet():New(cNameSheet) )
	::nActualSheet++
RETURN


/*/{Protheus.doc} AppExcel:AddCell
Adiciona uma nova célula na aba atual

@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0

@param nRow			, inteiro	, número da linha a qual a célula será atribuida
@param nCol			, inteiro	, número da coluna a qual a célula será atribuida
@param xContent		, indefinido, conteudo da célula, podendo ser: numérico, string ou data
@param <oStyle>		, objeto	, objeto AppExcCell com a definição (estilo) da célula
@param <cFormula>	, String	, Formula no padrão Excel, ex.: "=RC[-3]+RC[-2]+RC[-1]"

@type method

@example
oCell1 := AppExcCell():New()

oFont1 := AppExcFont():New("Arial","16","#363636")
oFont1:SetBold(.T.)

oCell1:SetFont(oFont1)

oExcel:AddCell(1,1, "Celula 1",oCell1)
oExcel:AddCell(1,2, 130.75 )

@see
AppExcCell

/*/
METHOD AddCell(nRow,nCol,xContent,oStyle,cFormula) CLASS APPEXCEL

	If ValType( oStyle ) == "O" .And. Empty( oStyle:GetId() )
		oStyle:SetId( "s"+StrZero( len( ::aCellStyle ) + 1 ,3)  )
		aAdd(::aCellStyle, oStyle )
	EndIf

	::aSheets[::nActualSheet]:AddCell(nRow,nCol,xContent,oStyle,cFormula)

RETURN


/*/{Protheus.doc} AppExcel:Merge
Realiza a junção entre células de uma sheet

@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type method

@param nRow			, inteiro	, número da linha inicial da célula que será mesclada, nRow e nCol formam a célula de referência
@param nCol			, inteiro	, número da coluna inicial da célula que será mesclada
@param nMergeAcross	, inteiro	, número de células a frente da referência que serão mescladas
@param nMergeDown	, inteiro	, número de células a abaixo da referência que serão mescladas
@param xContent		, indefinido, conteudo da célula, podendo ser: numérico, string ou data
@param [oStyle]		, objeto	, objeto AppExcCell com a definição (estilo) da célula
@param [cFormula]	, String	, Formula no padrão Excel, ex.: "=RC[-3]+RC[-2]+RC[-1]"

@Example
oExcel:Merge(10,2,5,5,"Células agrupadas")

@see
AppExcCell
/*/
METHOD Merge( nRow, nCol, nMergeAcross, nMergeDown, xContent, oStyle, cFormula ) CLASS APPEXCEL
	DEFAULT xContent := ""
	DEFAULT cFormula := ""

	If ValType( oStyle ) == "O" .And. Empty( oStyle:GetId() )
		oStyle:SetId( "s"+StrZero( len( ::aCellStyle ) + 1 ,3)  )
		aAdd(::aCellStyle, oStyle )
	EndIf

	::aSheets[::nActualSheet]:AddCell( nRow, nCol, xContent, oStyle, cFormula,  nMergeAcross, nMergeDown  )
RETURN

/*/{Protheus.doc} AppExcel:SetHorzFrozen
Congela as linhas superiores na rolagem de tela

@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type method

@param nRows, inteiro, numero de linhas que serão congeladas

@example
oExcel:SetHorzFrozen( 2 )
/*/
METHOD SetHorzFrozen( nRows ) CLASS APPEXCEL

	::aSheets[::nActualSheet]:SetHorzFrozen( nRows )

RETURN

/*/{Protheus.doc} AppExcel:SetVertFrozen
Congela as linhas laterais na rolagem de tela

@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type method

@param nCols, inteiro, numero de colunas que serão congeladas

@example
oExcel:SetVertFrozen( 2 )
/*/
METHOD SetVertFrozen( nCols ) CLASS APPEXCEL

	::aSheets[::nActualSheet]:SetVertFrozen( nCols )

RETURN



/*/{Protheus.doc} AppExcel:Make
Realiza a geração do arquivo XML

@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type method

@example
oExcel:Make()
/*/
METHOD Make(_lAut) CLASS APPEXCEL

	Local _lJob		:= If(ValType(_lAut) <> 'U',_lAut,.F.)
	Local nHandle	:= FCreate( If(_lJob,'\Workflow\Relatorios\'+(::cFileName),::cFileName) , 0 )
	Local nX		:= 0

	If nHandle < 0
		Alert("Erro ao criar o arquivo temporário.")
		return
	EndIf

	//Header File - NO CHANGE THIS SECTION
	FWrite(nHandle,'<?xml version="1.0"?>' + CRLF)
	FWrite(nHandle,'<?mso-application progid="Excel.Sheet"?>' + CRLF)
	FWrite(nHandle,'<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"' + CRLF)
	FWrite(nHandle,'          xmlns:o="urn:schemas-microsoft-com:office:office"' + CRLF)
	FWrite(nHandle,'          xmlns:x="urn:schemas-microsoft-com:office:excel"' + CRLF)
	FWrite(nHandle,'          xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"' + CRLF)
	FWrite(nHandle,'          xmlns:html="http://www.w3.org/TR/REC-html40">' + CRLF)

	//Styles
	FWrite(nHandle,'   <Styles>' + CRLF)
	FWrite(nHandle,'      <Style ss:ID="Default" ss:Name="Normal">' + CRLF)
	FWrite(nHandle,'         <Alignment ss:Vertical="Bottom"/>' + CRLF)
	FWrite(nHandle,'         <Borders/>' + CRLF)
	FWrite(nHandle,'         <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>' + CRLF)
	FWrite(nHandle,'         <Interior/>' + CRLF)
	FWrite(nHandle,'         <NumberFormat/>' + CRLF)
	FWrite(nHandle,'         <Protection/>' + CRLF)
	FWrite(nHandle,'      </Style>' + CRLF)
	FWrite(nHandle,'      <Style ss:ID="sDtDefault">' + CRLF)
	FWrite(nHandle,'         <NumberFormat ss:Format="Short Date"/>' + CRLF)
	FWrite(nHandle,'      </Style>' + CRLF)

	For nX := 1 to len(::aCellStyle)
		FWrite(nHandle,::aCellStyle[nX]:CellToString())
	Next

	FWrite(nHandle,'   </Styles>' + CRLF)

	//Worksheets
	For nX := 1 to len(::aSheets)

		FWrite(nHandle,'   <Worksheet ss:Name="'+ StaticCall(AppExcCellProperties,NoExpChar,::aSheets[nX]:GetName()) +'">' + CRLF)
		FWrite(nHandle,'      <Table ss:ExpandedColumnCount="'+ cValToChar(::aSheets[nX]:GetColumnCount()) +'" ss:ExpandedRowCount="'+cValToChar(::aSheets[nX]:GetRowCount())+'">' + CRLF)

		::aSheets[nX]:OrderSheet()
		For nY := 1 to ::aSheets[nX]:GetRowCount()
			FWrite(nHandle, ::aSheets[nX]:RowToString( nY ) )
		Next

		FWrite(nHandle,'      </Table>' + CRLF)

		If ::aSheets[nX]:HasOptions()
			FWrite(nHandle,'      <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' + CRLF)
			FWrite(nHandle,::aSheets[nX]:OptionsToString() )
			FWrite(nHandle,'         <DoNotDisplayGridlines/>'  + CRLF)
			//	  		FWrite(nHandle,'         <TabColorIndex>13</TabColorIndex>'  + CRLF) //Cor da aba
			FWrite(nHandle,'      </WorksheetOptions>' + CRLF)
		EndIf
		FWrite(nHandle,'   </Worksheet>' + CRLF)
	Next

	FWrite(nHandle,'</Workbook>')

	FClose(nHandle)

	Conout('Appexcel')
	Conout(_lJob)
	Conout(::cDestPath)
	Conout(::cFileName)

	If !_lJob
		If !CpyS2T( ::cFileName, ::cDestPath, .F. )
			Alert("Erro ao copiar o arquivo "+::cFileName+" para "+::cDestPath)
		EndIf

		FErase( ::cFileName )
//	Else
//		__CopyFile(::cFileName,::cDestPath+::cFileName)
	Endif

RETURN


/*/{Protheus.doc} AppExcel:OpenXML
Abre o XML criado pelo método Make

@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type method

@example
oExcel:OpenXML()
/*/
METHOD OpenXML() CLASS APPEXCEL
	Local oExcel := nil

	If !ApOleClient( 'MsExcel' )
		MsgStop( 'MsExcel não instalado!' )
		Return
	Else
		oExcel:= MsExcel():New()
		oExcel:WorkBooks:Open(::cDestPath + ::cFileName)
		oExcel:SetVisible(.T.)
		oExcel:Destroy()

		FreeObj(oExcel)
	EndIf

RETURN

/*/{Protheus.doc} AppExcel:ClassName
Método responsável por retornar o nome da classe

@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type method

@return caractere, retorna o nome da classe
/*/
METHOD ClassName() CLASS AppExcel
RETURN ::cClassName

/*/{Protheus.doc} AppExcel:Destroy
Método destrutor do objeto, responsável pela desalocação da memória

@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type method

/*/
METHOD Destroy() CLASS APPEXCEL
	Local nX := 0

	For nX := 1 to Len(::aSheets)
		::aSheets[nX]:Destroy()
	Next

	For nX := 1 to Len(::aCellStyle)
		::aCellStyle[nX]:Destroy()
	Next

	FreeObj(self)

RETURN