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
          
/*/{Protheus.doc} AppExcCellProperties
Classe fornecedora de m�todos para gerenciameto de customiza��o e conteudo de c�lulas para o XML Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type class
/*/
CLASS AppExcCellProperties FROM LongClassName
	DATA nRow 		AS Integer   	HIDDEN      
	DATA nCol 		AS Integer   	HIDDEN      
	DATA cContent	AS String		HIDDEN	 
	DATA cType		AS String 		HIDDEN      
	DATA cStyle		AS String		HIDDEN       
	DATA cFormula	AS String		HIDDEN       
	DATA nIndex		AS Integer   	HIDDEN      	
	DATA lMerged	AS Boolean 		HIDDEN 
	DATA nMergeAcross AS Integer   	HIDDEN      	 
	DATA nMergeDown	  AS Integer   	HIDDEN      	
	                            
	//Class Properties
	DATA cClassName AS STRING HIDDEN	                     
	                     
	METHOD New() CONSTRUCTOR    
	METHOD ConvType(xValue)		 
	METHOD GetType(xValue)	  
	METHOD GetCol( )                  
	METHOD AddRow( nRow )
	METHOD AddCol( nCol )
	METHOD AddContent( xContent ) 
	METHOD AddStyle( oStyle )                     
	METHOD AddFormula( cFormula )
	METHOD SetIndex( nIndex )             
	METHOD SetMerged( lMerged )
	METHOD SetMergeAcross( nMergeAcross )               
	METHOD SetMergeDown( nMergeDown ) 
	METHOD CellToString()           
	
	//Class Properties
	METHOD Destroy()  
	METHOD ClassName()                 
	
ENDCLASS               


/*/{Protheus.doc} AppExcCellProperties:New
M�todo construtor da classe AppExcCellProperties                       
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type method
/*/
METHOD New() CLASS AppExcCellProperties                       
	::cClassName := "AppExcCellProperties"
 
	::nRow 		:= 0      
	::nCol 		:= 0
	::cContent	:= ""
	::cType		:= ""
	::cStyle	:= ""
	::cFormula	:= ""                
	
	::lMerged		:= .F.
	::nMergeAcross 	:= 0
	::nMergeDown	:= 0
	                
	                
	//Controle posicionamento da tela
	::nIndex	:= 0
RETURN             
                      
                       
/*/{Protheus.doc} AppExcCellProperties:AddRow
M�todo para indicar em qual linha a c�lula pertence
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param nRow,inteiro	, n�mero da linha a qual a c�lula ser� atribuida
/*/
METHOD AddRow( nRow ) CLASS AppExcCellProperties   
	::nRow := nRow
RETURN
                          

                       
/*/{Protheus.doc} AppExcCellProperties:AddCol
M�todo para indicar em qual coluna a c�lula pertence
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param nCol,inteiro	, n�mero da coluna a qual a c�lula ser� atribuida
/*/
METHOD AddCol( nCol ) CLASS AppExcCellProperties      
	::nCol := nCol
RETURN
           
 
/*/{Protheus.doc} AppExcCellProperties:AddContent
M�todo para adicionar o conteudo (valor) da c�lula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param xContent,indefinido	, conteudo da c�lula, podendo ser: num�rico, string ou data
/*/
METHOD AddContent( xContent ) CLASS AppExcCellProperties      
	::cType		:= ::GetType(xContent)
	::cContent 	:= ::ConvType(xContent)   
RETURN
           

/*/{Protheus.doc} AppExcCellProperties:AddStyle
M�todo para atribuir um objeto AppExcCell (com propriedades customizadas da c�lula) a c�lula atual
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param oStyle,objeto, objeto da classe AppExcCell
/*/
METHOD AddStyle( oStyle ) CLASS AppExcCellProperties         
	If ValType(oStyle) == "O" 
		::cStyle := oStyle:GetId()
	EndIf
RETURN               

/*/{Protheus.doc} AppExcCellProperties:AddFormula
M�todo para atribuir uma f�rmula a c�lula no padr�o do XML Excel, ex.: "=RC[-3]+RC[-2]+RC[-1]"
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param cFormula,String		, Formula no padr�o Excel, ex.: "=RC[-3]+RC[-2]+RC[-1]"
/*/
METHOD AddFormula( cFormula ) CLASS AppExcCellProperties         
	::cFormula := cFormula
RETURN
               
        
/*/{Protheus.doc} AppExcCellProperties:GetCol
M�todo de acesso a coluna da c�lula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param nCol,inteiro	, n�mero da coluna a qual a c�lula foi atribuida
/*/
METHOD GetCol( ) CLASS AppExcCellProperties 
RETURN ::nCol                 

       
/*/{Protheus.doc} AppExcCellProperties:SetIndex
M�todo para adicionar indices na c�lulas, diminuindo o tamanho do arquivo gerado e mantendo a formata��o exigida pelo script AdvPl
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param nIndex,inteiro, index da c�lula
/*/
METHOD SetIndex( nIndex ) CLASS AppExcCellProperties
	::nIndex := nIndex                          
RETURN                                         
               
       
/*/{Protheus.doc} AppExcCellProperties:SetMerged
M�todo para indicar se a c�lula foi mesclada com outras c�lulas
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param lMerged,l�gico, indica se a c�lula foi mesclada com outras c�lulas
/*/
METHOD SetMerged( lMerged ) CLASS AppExcCellProperties
	::lMerged := lMerged
RETURN

       
/*/{Protheus.doc} AppExcCellProperties:SetMergeAcross
Metodo para indicar quantas c�lulas a frente dever�o ser mescladas
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param nMergeAcross	,inteiro	, n�mero de c�lulas a frente da refer�ncia que ser�o mescladas
/*/
METHOD SetMergeAcross( nMergeAcross ) CLASS AppExcCellProperties               
	::nMergeAcross := nMergeAcross
RETURN
          
       
/*/{Protheus.doc} AppExcCellProperties:SetMergeDown
Metodo para indicar quantas c�lulas abaixo dever�o ser mescladas
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param nMergeDown		,inteiro	, n�mero de c�lulas a abaixo da refer�ncia que ser�o mescladas
/*/
METHOD SetMergeDown( nMergeDown ) CLASS AppExcCellProperties
	::nMergeDown := nMergeDown     
RETURN

          
       
/*/{Protheus.doc} AppExcCellProperties:ConvType
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param xValue,indefinido, conteudo da c�lula, podendo ser: num�rico, string ou data
@return caractere, valor convertido no padr�o XML Excel
/*/
METHOD ConvType(xValue) CLASS AppExcCellProperties
	If ValType(xValue) == "D"
    	return cValToChar(Year(xValue))+"-"+StrZero(Month(xValue),2)+"-"+StrZero(Day(xValue),2)+'T00:00:00.000'                         
	ElseIf ValType(xValue) == "C"
		return NoExpChar( xValue )
	Else
		return cValToChar(xValue)	
	EndIf
Return



/*/{Protheus.doc} AppExcCellProperties:GetType
M�todo para obter o tipo do valor (conteudo da c�lula) no padr�o XML Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param xValue,indefinido, conteudo da c�lula, podendo ser: num�rico, string ou data
@return caractere, tipo do valor no padr�o XML Excel
/*/
METHOD GetType(xValue) CLASS AppExcCellProperties
	Local cType := ValType(xValue)

	Do Case
    	Case cType == "C" 
    		Return "String"      
    	Case cType == "D"       
    		Return "DateTime"
    	Case cType == "N"       
    		Return "Number"
    	OtherWise
    		Return 'X'       
	EndCase
Return                
  
               
/*/{Protheus.doc} AppExcCellProperties:CellToString
Serializa��o do conteudo da c�lula para o padr�o XML Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type method
@param nRow, inteiro, n�mero da linha que ser� serializada
@return caractere, String com o conteudo da c�lula especificada no padr�o XML
/*/
METHOD CellToString() CLASS AppExcCellProperties
	Local cCell := ""
  
	cRow := '<Cell'
 
	If ::nIndex > 1
    	cRow += ' ss:Index="'+cValToChar(::nIndex)+'"'	                  
	EndIf                     
	
	If ::lMerged      
		If ::nMergeAcross > 0           
			cRow += ' ss:MergeAcross="'+cValToChar(::nMergeAcross)+'"' 
		EndIf
		
		If ::nMergeDown	> 0
			cRow += ' ss:MergeDown="'+cValToChar(::nMergeDown)+'"'		
		EndIf
	EndIf
	
	If !Empty(::cStyle)
		cRow += ' ss:StyleID="'
		cRow += ::cStyle
		cRow += '"'              
	Else
		If ::cType == "DateTime"
			cRow += ' ss:StyleID="sDtDefault"'
		EndIf
	EndIf
			
	If !Empty(::cFormula)
		cRow += ' ss:Formula="'+ ::cFormula +'"'	
	EndIf
		
	cRow += '>'
	cRow += '<Data ss:Type="'
	cRow += ::cType
	cRow += '">'
	cRow += ::cContent
	cRow += '</Data></Cell>'

RETURN cRow                               

                                
  
/*/{Protheus.doc} AppExcCellProperties:ClassName
M�todo respons�vel por retornar o nome da classe
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@type method
@version 1.0     
@return caractere, retorna o nome da classe
/*/
METHOD ClassName() CLASS AppExcCellProperties
RETURN ::cClassName
          
  
/*/{Protheus.doc} AppExcCellProperties:Destroy
M�todo destrutor do objeto, respons�vel pela desaloca��o da mem�ria
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type method
/*/
METHOD Destroy() CLASS AppExcCellProperties                  
	FreeObj(self)
RETURN 
      

/*/ NoExpChar
Fun��o est�tica para converter Strings, alterando acentua��o para o padr�o XML Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014                                                                                  
@version 1.0                                                                                                   	
@return, caractere, string convertida para o padr�o XML Excel
@type function
/*/
Static Function NoExpChar( cText )
	                                  
	cText := StrTran(cText,"&","&amp;")	                                  	          	
	cText := StrTran(cText,"�","&Aacute;")
	cText := StrTran(cText,"�","&aacute;")
	cText := StrTran(cText,"�","&Acirc;")
	cText := StrTran(cText,"�","&acirc;")
	cText := StrTran(cText,"�","&Agrave;")
	cText := StrTran(cText,"�","&agrave;")
	cText := StrTran(cText,"�","&Aring;")
	cText := StrTran(cText,"�","&aring;")
	cText := StrTran(cText,"�","&Atilde;")
	cText := StrTran(cText,"�","&atilde;")
	cText := StrTran(cText,"�","&Auml;")
	cText := StrTran(cText,"�","&auml;")
	cText := StrTran(cText,"�","&AElig;")
	cText := StrTran(cText,"�","&aelig;")
	cText := StrTran(cText,"�","&Eacute;")
	cText := StrTran(cText,"�","&eacute;")
	cText := StrTran(cText,"�","&Ecirc;")
	cText := StrTran(cText,"�","&ecirc;")
	cText := StrTran(cText,"�","&Egrave;")
	cText := StrTran(cText,"�","&egrave;")
	cText := StrTran(cText,"�","&Euml;")
	cText := StrTran(cText,"�","&euml;")
	cText := StrTran(cText,"�","&ETH;")
	cText := StrTran(cText,"�","&eth;")
	cText := StrTran(cText,"�","&Iacute;")
	cText := StrTran(cText,"�","&iacute;")
	cText := StrTran(cText,"�","&Icirc;")
	cText := StrTran(cText,"�","&icirc;")
	cText := StrTran(cText,"�","&Igrave;")
	cText := StrTran(cText,"�","&igrave;")
	cText := StrTran(cText,"�","&Iuml;")
	cText := StrTran(cText,"�","&iuml;")
	cText := StrTran(cText,"�","&Oacute;")
	cText := StrTran(cText,"�","&oacute;")
	cText := StrTran(cText,"�","&Ocirc;")
	cText := StrTran(cText,"�","&ocirc;")
	cText := StrTran(cText,"�","&Ograve;")
	cText := StrTran(cText,"�","&ograve;")
	cText := StrTran(cText,"�","&Oslash;")
	cText := StrTran(cText,"�","&oslash;")
	cText := StrTran(cText,"�","&Otilde;")
	cText := StrTran(cText,"�","&otilde;")
	cText := StrTran(cText,"�","&Ouml;")
	cText := StrTran(cText,"�","&ouml;")
	cText := StrTran(cText,"�","&Uacute;")
	cText := StrTran(cText,"�","&uacute;")
	cText := StrTran(cText,"�","&Ucirc;")
	cText := StrTran(cText,"�","&ucirc;")
	cText := StrTran(cText,"�","&Ugrave;")
	cText := StrTran(cText,"�","&ugrave;")
	cText := StrTran(cText,"�","&Uuml;")
	cText := StrTran(cText,"�","&uuml;")
	cText := StrTran(cText,"�","&Ccedil;")
	cText := StrTran(cText,"�","&ccedil;")
	cText := StrTran(cText,"�","&Ntilde;")
	cText := StrTran(cText,"�","&ntilde;")
	cText := StrTran(cText,"<","&lt;")
	cText := StrTran(cText,">","&gt;")
	cText := StrTran(cText,'"',"&quot;")
	cText := StrTran(cText,"�","&reg;")
	cText := StrTran(cText,"�","&copy;")
	cText := StrTran(cText,"�","&Yacute;")
	cText := StrTran(cText,"�","&yacute;")
	cText := StrTran(cText,"�","&THORN;")
	cText := StrTran(cText,"�","&thorn;")
	cText := StrTran(cText,"�","&szlig;")       
	
Return cText                          
                          
