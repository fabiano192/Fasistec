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
                  
//TODO: 
//		Verificar motivo que somente funciona com <ActivePane>2</ActivePane> 

			                       			
/*/{Protheus.doc} AppExcSheetOptions
Classe fornecedora de métodos para gerenciameto de opções em uma aba
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type class
/*/
CLASS AppExcSheetOptions From LongClassName
	DATA lHorzFrozen AS Boolean HIDDEN
	DATA lVertFrozen AS Boolean HIDDEN                                      

	DATA nHorzFrozen AS Integer	HIDDEN
	DATA nVertFrozen AS Integer	HIDDEN          
	
	//Class Properties
	DATA cClassName AS STRING HIDDEN

	
	METHOD New() CONSTRUCTOR
	METHOD SetHorzFrozen( nRows )
	METHOD SetVertFrozen( nCols )
	METHOD HasOptions()
	METHOD OptionsToString()

	//Class Properties
	METHOD Destroy()  
	METHOD ClassName()
		
ENDCLASS


                   
/*/{Protheus.doc} AppExcSheetOptions:New
Método construtor da classe AppExcSheetOptions
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0      
@type constructor
/*/
METHOD New() CLASS AppExcSheetOptions   
	::cClassName 	:= "AppExcSheetOptions"
	
	::lHorzFrozen := .F.
	::lVertFrozen := .F.

	::nHorzFrozen := 0
	::nVertFrozen := 0
	
RETURN
                                    
                                    
/*/{Protheus.doc} AppExcSheetOptions:SetHorzFrozen
Congela as linhas superiores na rolagem de tela
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                              
@type method
@param nRows, inteiro, numero de linhas que serão congeladas
/*/
METHOD SetHorzFrozen( nRows ) CLASS AppExcSheetOptions 
	
	::lHorzFrozen := .T.		                  
	::nHorzFrozen := nRows

RETURN 



/*/{Protheus.doc} AppExcSheetOptions:SetVertFrozen
Congela as linhas laterais na rolagem de tela
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                              
@type method
@param nCols, inteiro, numero de colunas que serão congeladas
/*/
METHOD SetVertFrozen( nCols ) CLASS AppExcSheetOptions 
	
	::lVertFrozen := .T.		                  
	::nVertFrozen := nCols

RETURN 



/*/{Protheus.doc} AppExcSheetOptions:HasOptions
Verifica se existe opções adicionais na aba
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                              
@type method
@return, lógico, indica se existe opções adicionais na aba
/*/
METHOD HasOptions() CLASS AppExcSheetOptions 
RETURN ::lHorzFrozen .Or. ::lVertFrozen
                                                          
      
/*/{Protheus.doc} AppExcSheetOptions:OptionsToString
Serialização das opções da worksheet para o padrão XML Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type method
@param nRow, inteiro, número da linha que será serializada
@return caractere, String contendo as opções da worksheet para o padrão XML Excel
/*/
METHOD OptionsToString() CLASS AppExcSheetOptions 
	Local cOptions := ""      
    
	If ::lHorzFrozen .Or. ::lVertFrozen
	   	cOptions := '	<Selected/>' + CRLF 
	   	cOptions += '	<FreezePanes/>' + CRLF
		cOptions += '  	<FrozenNoSplit/>' + CRLF
//		cOptions += '  	<DoNotDisplayGridlines/>' + CRLF

	   	If ::lHorzFrozen
			   	cOptions += '	<SplitHorizontal>'+cValToChar(::nHorzFrozen)+'</SplitHorizontal>' + CRLF	
			   	cOptions += '	<TopRowBottomPane>'+cValToChar(::nHorzFrozen)+'</TopRowBottomPane>' + CRLF
		EndIf
		
		If ::lVertFrozen			
				cOptions += '	<SplitVertical>'+cValToChar(::nVertFrozen)+'</SplitVertical>' + CRLF
				cOptions += '	<LeftColumnRightPane>'+cValToChar(::nVertFrozen)+'</LeftColumnRightPane>' + CRLF
		EndIf
			
	   	If ::lHorzFrozen .And. ::lVertFrozen
	   		cOptions += '	<ActivePane>0</ActivePane>' + CRLF
	   	ElseIf ::lVertFrozen
	   		cOptions += '	<ActivePane>1</ActivePane>' + CRLF
	   	Else                                           
	   		cOptions += '	<ActivePane>2</ActivePane>' + CRLF
	   	EndIf	                                       
	   	
  	EndIf	

RETURN cOptions                                                                                                         

  
/*/{Protheus.doc} AppExcSheetOptions:ClassName
Método responsável por retornar o nome da classe
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type method
@return caractere, retorna o nome da classe
/*/
METHOD ClassName() CLASS AppExcSheetOptions
RETURN ::cClassName


  
/*/{Protheus.doc} AppExcSheetOptions:Destroy
Método destrutor do objeto, responsável pela desalocação da memória
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type method
/*/
METHOD Destroy() CLASS AppExcSheetOptions        
	FreeObj(self)
RETURN 