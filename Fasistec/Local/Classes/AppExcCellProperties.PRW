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
Classe fornecedora de métodos para gerenciameto de customização e conteudo de células para o XML Excel
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
Método construtor da classe AppExcCellProperties                       
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
Método para indicar em qual linha a célula pertence
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param nRow,inteiro	, número da linha a qual a célula será atribuida
/*/
METHOD AddRow( nRow ) CLASS AppExcCellProperties   
	::nRow := nRow
RETURN
                          

                       
/*/{Protheus.doc} AppExcCellProperties:AddCol
Método para indicar em qual coluna a célula pertence
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param nCol,inteiro	, número da coluna a qual a célula será atribuida
/*/
METHOD AddCol( nCol ) CLASS AppExcCellProperties      
	::nCol := nCol
RETURN
           
 
/*/{Protheus.doc} AppExcCellProperties:AddContent
Método para adicionar o conteudo (valor) da célula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param xContent,indefinido	, conteudo da célula, podendo ser: numérico, string ou data
/*/
METHOD AddContent( xContent ) CLASS AppExcCellProperties      
	::cType		:= ::GetType(xContent)
	::cContent 	:= ::ConvType(xContent)   
RETURN
           

/*/{Protheus.doc} AppExcCellProperties:AddStyle
Método para atribuir um objeto AppExcCell (com propriedades customizadas da célula) a célula atual
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
Método para atribuir uma fórmula a célula no padrão do XML Excel, ex.: "=RC[-3]+RC[-2]+RC[-1]"
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param cFormula,String		, Formula no padrão Excel, ex.: "=RC[-3]+RC[-2]+RC[-1]"
/*/
METHOD AddFormula( cFormula ) CLASS AppExcCellProperties         
	::cFormula := cFormula
RETURN
               
        
/*/{Protheus.doc} AppExcCellProperties:GetCol
Método de acesso a coluna da célula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param nCol,inteiro	, número da coluna a qual a célula foi atribuida
/*/
METHOD GetCol( ) CLASS AppExcCellProperties 
RETURN ::nCol                 

       
/*/{Protheus.doc} AppExcCellProperties:SetIndex
Método para adicionar indices na células, diminuindo o tamanho do arquivo gerado e mantendo a formatação exigida pelo script AdvPl
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param nIndex,inteiro, index da célula
/*/
METHOD SetIndex( nIndex ) CLASS AppExcCellProperties
	::nIndex := nIndex                          
RETURN                                         
               
       
/*/{Protheus.doc} AppExcCellProperties:SetMerged
Método para indicar se a célula foi mesclada com outras células
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param lMerged,lógico, indica se a célula foi mesclada com outras células
/*/
METHOD SetMerged( lMerged ) CLASS AppExcCellProperties
	::lMerged := lMerged
RETURN

       
/*/{Protheus.doc} AppExcCellProperties:SetMergeAcross
Metodo para indicar quantas células a frente deverão ser mescladas
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param nMergeAcross	,inteiro	, número de células a frente da referência que serão mescladas
/*/
METHOD SetMergeAcross( nMergeAcross ) CLASS AppExcCellProperties               
	::nMergeAcross := nMergeAcross
RETURN
          
       
/*/{Protheus.doc} AppExcCellProperties:SetMergeDown
Metodo para indicar quantas células abaixo deverão ser mescladas
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param nMergeDown		,inteiro	, número de células a abaixo da referência que serão mescladas
/*/
METHOD SetMergeDown( nMergeDown ) CLASS AppExcCellProperties
	::nMergeDown := nMergeDown     
RETURN

          
       
/*/{Protheus.doc} AppExcCellProperties:ConvType
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param xValue,indefinido, conteudo da célula, podendo ser: numérico, string ou data
@return caractere, valor convertido no padrão XML Excel
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
Método para obter o tipo do valor (conteudo da célula) no padrão XML Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param xValue,indefinido, conteudo da célula, podendo ser: numérico, string ou data
@return caractere, tipo do valor no padrão XML Excel
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
Serialização do conteudo da célula para o padrão XML Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type method
@param nRow, inteiro, número da linha que será serializada
@return caractere, String com o conteudo da célula especificada no padrão XML
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
Método responsável por retornar o nome da classe
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@type method
@version 1.0     
@return caractere, retorna o nome da classe
/*/
METHOD ClassName() CLASS AppExcCellProperties
RETURN ::cClassName
          
  
/*/{Protheus.doc} AppExcCellProperties:Destroy
Método destrutor do objeto, responsável pela desalocação da memória
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type method
/*/
METHOD Destroy() CLASS AppExcCellProperties                  
	FreeObj(self)
RETURN 
      

/*/ NoExpChar
Função estática para converter Strings, alterando acentuação para o padrão XML Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014                                                                                  
@version 1.0                                                                                                   	
@return, caractere, string convertida para o padrão XML Excel
@type function
/*/
Static Function NoExpChar( cText )
	                                  
	cText := StrTran(cText,"&","&amp;")	                                  	          	
	cText := StrTran(cText,"Á","&Aacute;")
	cText := StrTran(cText,"á","&aacute;")
	cText := StrTran(cText,"Â","&Acirc;")
	cText := StrTran(cText,"â","&acirc;")
	cText := StrTran(cText,"À","&Agrave;")
	cText := StrTran(cText,"à","&agrave;")
	cText := StrTran(cText,"Å","&Aring;")
	cText := StrTran(cText,"å","&aring;")
	cText := StrTran(cText,"Ã","&Atilde;")
	cText := StrTran(cText,"ã","&atilde;")
	cText := StrTran(cText,"Ä","&Auml;")
	cText := StrTran(cText,"ä","&auml;")
	cText := StrTran(cText,"Æ","&AElig;")
	cText := StrTran(cText,"æ","&aelig;")
	cText := StrTran(cText,"É","&Eacute;")
	cText := StrTran(cText,"é","&eacute;")
	cText := StrTran(cText,"Ê","&Ecirc;")
	cText := StrTran(cText,"ê","&ecirc;")
	cText := StrTran(cText,"È","&Egrave;")
	cText := StrTran(cText,"è","&egrave;")
	cText := StrTran(cText,"Ë","&Euml;")
	cText := StrTran(cText,"ë","&euml;")
	cText := StrTran(cText,"Ð","&ETH;")
	cText := StrTran(cText,"ð","&eth;")
	cText := StrTran(cText,"Í","&Iacute;")
	cText := StrTran(cText,"í","&iacute;")
	cText := StrTran(cText,"Î","&Icirc;")
	cText := StrTran(cText,"î","&icirc;")
	cText := StrTran(cText,"Ì","&Igrave;")
	cText := StrTran(cText,"ì","&igrave;")
	cText := StrTran(cText,"Ï","&Iuml;")
	cText := StrTran(cText,"ï","&iuml;")
	cText := StrTran(cText,"Ó","&Oacute;")
	cText := StrTran(cText,"ó","&oacute;")
	cText := StrTran(cText,"Ô","&Ocirc;")
	cText := StrTran(cText,"ô","&ocirc;")
	cText := StrTran(cText,"Ò","&Ograve;")
	cText := StrTran(cText,"ò","&ograve;")
	cText := StrTran(cText,"Ø","&Oslash;")
	cText := StrTran(cText,"ø","&oslash;")
	cText := StrTran(cText,"Õ","&Otilde;")
	cText := StrTran(cText,"õ","&otilde;")
	cText := StrTran(cText,"Ö","&Ouml;")
	cText := StrTran(cText,"ö","&ouml;")
	cText := StrTran(cText,"Ú","&Uacute;")
	cText := StrTran(cText,"ú","&uacute;")
	cText := StrTran(cText,"Û","&Ucirc;")
	cText := StrTran(cText,"û","&ucirc;")
	cText := StrTran(cText,"Ù","&Ugrave;")
	cText := StrTran(cText,"ù","&ugrave;")
	cText := StrTran(cText,"Ü","&Uuml;")
	cText := StrTran(cText,"ü","&uuml;")
	cText := StrTran(cText,"Ç","&Ccedil;")
	cText := StrTran(cText,"ç","&ccedil;")
	cText := StrTran(cText,"Ñ","&Ntilde;")
	cText := StrTran(cText,"ñ","&ntilde;")
	cText := StrTran(cText,"<","&lt;")
	cText := StrTran(cText,">","&gt;")
	cText := StrTran(cText,'"',"&quot;")
	cText := StrTran(cText,"®","&reg;")
	cText := StrTran(cText,"©","&copy;")
	cText := StrTran(cText,"Ý","&Yacute;")
	cText := StrTran(cText,"ý","&yacute;")
	cText := StrTran(cText,"Þ","&THORN;")
	cText := StrTran(cText,"þ","&thorn;")
	cText := StrTran(cText,"ß","&szlig;")       
	
Return cText                          
                          
