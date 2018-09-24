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

/*/{Protheus.doc} AppExcFont
Classe fornecedora de métodos para gerenciamento de fontes para o XML Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type class
/*/
CLASS AppExcFont FROM LongClassName
	DATA cFontName 	AS STRING HIDDEN
	DATA cSize	   	AS STRING HIDDEN
	DATA cColor		AS STRING HIDDEN
	DATA lBold		AS BOOLEAN HIDDEN
	DATA lItalic	AS BOOLEAN HIDDEN
	DATA lUnderLine AS BOOLEAN HIDDEN

	//Class Properties
	DATA cClassName AS STRING HIDDEN
	
	METHOD NEW() CONSTRUCTOR
	METHOD SetFontName(cFontPar)
	METHOD SetSize(xSizePar)	
	METHOD SetColor(cColorPar)
	METHOD SetBold(lBoldPar)
	METHOD SetItalic(lItalicPar)
	METHOD SetUnderLine(lUnderPar)
	METHOD FontToString() 	           
	
	//Class Properties
	METHOD Destroy()  
	METHOD ClassName()
	
ENDCLASS                           

/*/{Protheus.doc} AppExcFont:New
Método construtor da classe AppExcFont
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param [cFontPar], caractere, nome da fonte que será utilizada
@param [cSizePar], caractere, tamanho da fonte
@param [cColorPar], caractere, cor da fonte no padrão hexadecimal
/*/
METHOD NEW(cFontPar,cSizePar,cColorPar) CLASS AppExcFont         
	DEFAULT cFontPar  := "Calibri"
	DEFAULT cSizePar  := "11"
	DEFAULT cColorPar := "#000000" 
	
	::cClassName := "AppExcFont"
    
	::SetFontName(cFontPar)
	::SetSize(cSizePar)	
	::SetColor(cColorPar)
	::SetBold(.F.)
	::SetItalic(.F.)
	::SetUnderLine(.F.)
	
RETURN
   

/*/{Protheus.doc} AppExcFont:SetFontName
Método para alterar a fonte a ser utilizada 
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param cFontPar, caractere, nome da fonte que será utilizada
/*/
METHOD SetFontName(cFontPar) CLASS AppExcFont
	::cFontName := cFontPar
RETURN
               
/*/{Protheus.doc} AppExcFont:SetSize
Método para alterar o tamanho da fonte
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param xSizePar, caractere/inteiro, tamanho da fonte
/*/
METHOD SetSize(xSizePar) CLASS AppExcFont	
	If ValType(xSizePar) == "N" 
		::cSize := cValToChar(xSizePar)
	Else
		::cSize := xSizePar
	EndIf
RETURN
                                                      

/*/{Protheus.doc} AppExcFont:SetColor
Método para alterar a cor da fonte
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param cColorPar, caractere, cor da fonte no padrão hexadecimal
/*/
METHOD SetColor(cColorPar) CLASS AppExcFont
	::cColor := cColorPar
RETURN                   
   

/*/{Protheus.doc} AppExcFont:SetBold
Método para ativar/desativar a fonte em negrito
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@param lBoldPar, lógico, indica se a fonte será em negrito
@type method
/*/
METHOD SetBold(lBoldPar) CLASS AppExcFont    
	::lBold := lBoldPar
RETURN                 
   

/*/{Protheus.doc} AppExcFont:SetItalic
Método para ativar/desativar a fonte em itálico
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param lItalicPar, lógico, indica se a fonte será em itálico
/*/
METHOD SetItalic(lItalicPar) CLASS AppExcFont
	::lItalic := lItalicPar
RETURN
                                               

/*/{Protheus.doc} AppExcFont:SetUnderLine
Método para ativar/desativar a fonte sublinhada
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param lUnderPar, lógico, indica se a fonte será sublinhada
/*/
METHOD SetUnderLine(lUnderPar) CLASS AppExcFont
	::lUnderLine := lUnderPar
RETURN                   
                       
  
/*/{Protheus.doc} AppExcFont:FontToString
Serialização da formatação da fonte da célula para o padrão XML Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type method
@param nRow, inteiro, número da linha que será serializada
@return caractere, String contendo a formatação da fonte da célula especificada no padrão XML
/*/
METHOD FontToString() CLASS AppExcFont
	Local cFont := ""	
	
	cFont := '<Font ss:FontName="'+::cFontName+'" ss:Size="'+::cSize+'" ss:Color="'+::cColor+'"'
	           
	If ::lBold
		cFont += ' ss:Bold="1"' 
	EndIf
	
	If ::lItalic
		cFont += ' ss:Italic="1"' 
	EndIf	    
	          
	If ::lUnderLine 
		cFont += ' ss:Underline="Single"'
	EndIf
    
    cFont += ' />'
    
RETURN cFont                        

  
/*/{Protheus.doc} AppExcFont:ClassName
Método responsável por retornar o nome da classe
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type method
@return caractere, retorna o nome da classe
/*/
METHOD ClassName() CLASS AppExcFont
RETURN ::cClassName

  
/*/{Protheus.doc} AppExcFont:Destroy
Método destrutor do objeto, responsável pela desalocação da memória
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type method
/*/
METHOD Destroy() CLASS AppExcFont                       
	FreeObj(self)
RETURN 