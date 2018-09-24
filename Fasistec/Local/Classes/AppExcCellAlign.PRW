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
#Include "AppExcel.ch"
  
/*/{Protheus.doc} AppExcCellAlign
Classe responsável pelo gerenciamento de alinhamento nas células
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type class
/*/
CLASS AppExcCellAlign FROM LongClassName
	DATA nVertAlign AS INTEGER 
	DATA nHorzAlign AS INTEGER
	
	DATA lVertAlign AS BOOLEAN
	DATA lHorzAlign AS BOOLEAN
                                                
	//Class Properties
	DATA cClassName AS STRING HIDDEN
                                 
	METHOD New( nTypeFormat ) CONSTRUCTOR
	METHOD HasAlign()
	METHOD SetVertAlign( nTypeAlign )
	METHOD SetHorzAlign( nTypeAlign )
	METHOD AlignToString() 

	METHOD GetVertAlign()
	METHOD GetHorzAlign()
	
	//Class Properties
	METHOD Destroy()  
	METHOD ClassName()

ENDCLASS                  


/*/{Protheus.doc} AppExcCellAlign:New
Método construtor da classe AppExcCellAlign
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type constructor
/*/
METHOD New() CLASS AppExcCellAlign
	::cClassName := "AppExcCellAlign"         

	::lVertAlign := .F.
	::lHorzAlign := .F.
	
	::nVertAlign := 0
	::nHorzAlign := 0
	
RETURN     
                                           

/*/{Protheus.doc} AppExcCellAlign:HasAlign
Método para indicar se algum alinhamento foi especificado
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@return, lógico, indica se algum alinhamento foi especificado
/*/
METHOD HasAlign() CLASS AppExcCellAlign
RETURN ::lVertAlign .Or. ::lHorzAlign

                                                         
/*/{Protheus.doc} AppExcCellAlign:SetVertAlign
Método para alterar o alinhamento vertical da célula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                                                               
@type method                   
@param nAlign, inteiro, código do tipo do alinhamento sendo:|ul||li|VERTICAL_ALIGN_TOP   	 -> define o alinhamento vertical como "acima"|/li||li|VERTICAL_ALIGN_CENTER    -> define o alinhamento vertical como "centralizado"|/li||li|VERTICAL_ALIGN_BOTTOM	 -> define o alinhamento vertical como "abaixo"|/li||/ul|
/*/
METHOD SetVertAlign( nTypeAlign ) CLASS AppExcCellAlign
	If nTypeAlign > 0 
		::lVertAlign := .T.    
		::nVertAlign := nTypeAlign	           
	EndIf	
RETURN
                
        
/*/{Protheus.doc} AppExcCellAlign:SetHorzAlign
Método para alterar o alinhamento horizontal da célula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                                                        
@type method                         
@param nAlign, inteiro, código do tipo do alinhamento sendo: |ul||li| HORIZONTAL_ALIGN_RIGHT   	-> define o alinhamento "a direira"  |/li||li| HORIZONTAL_ALIGN_CENTER    	-> define o alinhamento "centralizado" |/li||li| HORIZONTAL_ALIGN_LEFT	 	-> define o alinhamento "a esquerda" |/li||/ul| 
/*/
METHOD SetHorzAlign( nTypeAlign ) CLASS AppExcCellAlign
	If nTypeAlign > 0
		::lHorzAlign := .T.    
		::nHorzAlign := nTypeAlign	           
	EndIf	
RETURN
           

/*/{Protheus.doc} AppExcCellAlign:GetVertAlign
Método de acesso obter o alinhamento vertical da célula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@return, inteiro, identificador do alinhamento vertical da célula
/*/
METHOD GetVertAlign() CLASS AppExcCellAlign
RETURN ::nVertAlign
   

/*/{Protheus.doc} AppExcCellAlign:GetHorzAlign
Método de acesso obter o alinhamento horizontal da célula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@return, inteiro, identificador do alinhamento horizontal da célula
/*/
METHOD GetHorzAlign() CLASS AppExcCellAlign
RETURN ::nHorzAlign    
   
/*/{Protheus.doc} AppExcCellAlign:ClassName
Método responsável por retornar o nome da classe
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type method
@return caractere, retorna o nome da classe
/*/
METHOD ClassName() CLASS AppExcCellAlign 
RETURN ::cClassName
  
/*/{Protheus.doc} AppExcCellAlign:Destroy
Método destrutor do objeto, responsável pela desalocação da memória
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type method
/*/
METHOD Destroy() CLASS AppExcCellAlign          
	FreeObj(self)
RETURN 
            

/*/{Protheus.doc} AppExcCellAlign:AlignToString
Serialização do alinhamento da célula para o padrão XML Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type method
@param nRow, inteiro, número da linha que será serializada
@return caractere, String contendo alinhamento da célula especificada no padrão XML
/*/
METHOD AlignToString( ) CLASS AppExcCellAlign
	Local cStringAlign := ""       

	If ::HasAlign()              
		cStringAlign := '<Alignment '
		    
		If ::lHorzAlign
			cStringAlign += " " + GetAlign( 1, ::nHorzAlign )       		
		EndIf
		
		If ::lVertAlign
			cStringAlign += " " + GetAlign( 2, ::nVertAlign )       	
		EndIf
			
		cStringAlign += '/>'
	EndIf

RETURN cStringAlign
           
/*/ GetAlign
Função estática para conversão do identificador do alinhamento com a string utilizada pelo XML Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014                                                                                  
@version 1.0                                       
@type function                                                
@param nType, inteiro, tipo do alinhamento 1-Horizontal, 2-Vertical                                                          
@param nAlign, inteiro, código do tipo do alinhamento, sendo:      
	nType == 1
	VERTICAL_ALIGN_TOP   	 -> alinhamento vertical como "acima"
	VERTICAL_ALIGN_CENTER    -> alinhamento vertical como "centralizado"
	VERTICAL_ALIGN_BOTTOM	 -> alinhamento vertical como "abaixo"
    
    nType == 2                                
	HORIZONTAL_ALIGN_RIGHT   	-> alinhamento "a direira"
	HORIZONTAL_ALIGN_CENTER    	-> alinhamento "centralizado"
	HORIZONTAL_ALIGN_LEFT	 	-> alinhamento "a esquerda"
@return, caractere, string utilizada pelo XML Excel
/*/
Static Function GetAlign( nType, nAlign )       
	Local cFormat := ""                                   
	                                    
	If nType == 1	                          
		Do Case
			Case nAlign == HORIZONTAL_ALIGN_RIGHT 
		   		cFormat := 'ss:Horizontal="Right"'
		   	Case nAlign == HORIZONTAL_ALIGN_CENTER
		   		cFormat := 'ss:Horizontal="Center"'
		   	Case nAlign == HORIZONTAL_ALIGN_LEFT
		   		cFormat := 'ss:Horizontal="Left"'	
		EndCase      
	Else
		Do Case
			Case nAlign == VERTICAL_ALIGN_TOP
		   		cFormat := 'ss:Vertical="Top"'
		   	Case nAlign == VERTICAL_ALIGN_CENTER
		   		cFormat := 'ss:Vertical="Center"'
		   	Case nAlign == VERTICAL_ALIGN_BOTTOM
		   		cFormat := 'ss:Vertical="Bottom"'	
		EndCase      	
	EndIf            
	
Return cFormat