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

/*/{Protheus.doc} AppExcCellBorder
Classe fornecedora de m�todos para gerenciameto de borda de c�lulas em Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type class
/*/
CLASS AppExcCellBorder FROM LongClassName
	DATA lBorder		AS BOOLEAN 	HIDDEN              
	DATA nTypeBorder	AS INTEGER 	HIDDEN
	DATA nLineStyle		AS INTEGER  HIDDEN      
	DATA nLineWeight	AS INTEGER 	HIDDEN	
	DATA cColor			AS STRING	HIDDEN	                           
                          
	//Class Properties
	DATA cClassName AS STRING HIDDEN

	METHOD New( nTypeBorder ) Constructor
	METHOD SetBorder( lBorder )
	METHOD SetLineStyle( nStyle )
	METHOD SetColor( cColor )
	METHOD SetWeight( nWeight )		        
	METHOD BorderToString( ) 
	METHOD HasBorder( )
	       
	METHOD GetBorder()
	METHOD GetWeight()
	METHOD GetLineStyle()
	METHOD GetColor()			
	
	//Class Properties
	METHOD Destroy()  
	METHOD ClassName()
ENDCLASS    


/*/{Protheus.doc} AppExcCellBorder:New
M�todo construtor da classe AppExcCell
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type  constructor
@param nTypeBorder, inteiro, identificador da borda que o objeto ir� manipular, podendo ser:
	BORDER_POSITION_TOP 			-> borda superior da c�lula
	BORDER_POSITION_BOTTOM 			-> borda inferior da c�lula
	BORDER_POSITION_LEFT 			-> borda esquerda da c�lula
	BORDER_POSITION_RIGHT 			-> borda direita da c�lula
	BORDER_POSITION_DIAGONAL_LEFT 	-> borda diagonal da esquerda para direita
	BORDER_POSITION_DIAGONAL_RIGHT 	-> borda diagonal da direita para a esquerda
/*/
METHOD New( nTypeBorder ) CLASS APPEXCCELLBORDER
	DEFAULT nTypeBorder := 0
	 
	::cClassName := "AppExcCellBorder"
	
	::lBorder		:= .F.
	::nTypeBorder	:= nTypeBorder 				//TODO: Usar para valida��es se determinada borda ou tamanho pode ser atribuida
	::nLineStyle	:= BORDER_LINE_CONTINUOUS
	::nLineWeight	:= 1

RETURN     
   
/*/{Protheus.doc} AppExcCellBorder:SetBorder
M�todo para ativar/desativar bordas nas c�lulas
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                                                        
@type  method           
@param lSetBorder, l�gico, indica se a borda deve ser ativada ou n�o
/*/
METHOD SetBorder( lBorder ) CLASS APPEXCCELLBORDER
	::lBorder := lBorder
RETURN     


/*/{Protheus.doc} AppExcCellBorder:GetBorder
M�todo de acesso para verificar se determina borda est� ativada
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                                           
@type  method                       
@return, l�gico, indica se a borda informada est� ativa
/*/
METHOD GetBorder() CLASS APPEXCCELLBORDER
RETURN ::lBorder
                                                          
   
/*/{Protheus.doc} AppExcCellBorder:SetWeight
M�todo alterar a espessura da linha
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                                                             
@type  method
@param nWeigth,inteiro,indica a esperrura da linha podendo variar de 0 a 3
/*/
METHOD SetWeight( nWeight ) CLASS APPEXCCELLBORDER	
	If nWeight > 0 .And. nWeight <= 3 
		::nLineWeight := nWeight
	EndIf	
RETURN	                                                                



/*/{Protheus.doc} AppExcCellBorder:GetWeight
M�todo de acesso para verificar a espessura da linha em uma determinada borda
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type  method
@return, inteiro, indica a espessura da borda especificada
/*/
METHOD GetWeight() CLASS APPEXCCELLBORDER	
RETURN ::nLineWeight                 
                                    
/*/{Protheus.doc} AppExcCellBorder:SetLineStyle
M�todo alterar o tipo da linha na borda
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type  method
@param nStyle, inteiro, indica o tipo da linha podendo ser:|ul||li|BORDER_LINE_CONTINUOUS 		-> "Continuous", linha continua|/li||li|BORDER_LINE_DOT   			-> "Dot", linha pontilhada|/li||li|BORDER_LINE_DASHDOT 		-> "DashDot", linha intercalada pontilhada/tracejada|/li||li|BORDER_LINE_DASHDOTDOT      -> "DashDotDot", linha intercalada pontilhada/tracejada/tracejada|/li||li|BORDER_LINE_SLANTDASHDOT  	-> "SlantDashDot", linha intercalada pontilhada/tracejada inclinada|/li|        |li|BORDER_LINE_DOUBLE			-> "Double", linha dupla|/li||/ul|
/*/
METHOD SetLineStyle( nStyle ) CLASS APPEXCCELLBORDER                                                                                                            
	::nLineStyle := nStyle                               
RETURN
             
                                          
/*/{Protheus.doc} AppExcCellBorder:GetLineStyle
M�todo de acesso para verificar o tipo da linha
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type  method
@return, inteiro, indica o c�digo do tipo da linha utilizada
/*/
METHOD GetLineStyle() CLASS APPEXCCELLBORDER                                                                                                            
RETURN ::nLineStyle
                        
       
/*/{Protheus.doc} AppExcCellBorder:SetColor
M�todo para alterar a cor de fundo de uma c�lula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                                                                               
@type  method   
@param cColor, caractere, cor de funda da c�lula em padr�o hexadecimal ex.: #000000 (preto)
/*/
METHOD SetColor( cColor ) CLASS APPEXCCELLBORDER           
	::cColor := cColor
RETURN     
    
/*/{Protheus.doc} AppExcCellBorder:GetColor
M�todo de acesso para verificar a cor da linha em uma determinada borda
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                                                             
@type  method            
@return, caractere, string contendo a cor da c�lula em padr�o hexadecimal
/*/
METHOD GetColor() CLASS APPEXCCELLBORDER           
RETURN ::cColor

                
/*/{Protheus.doc} AppExcCellBorder:HasBorder
M�todo para verificar se a borda est� ativa
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type  method
@return, l�gico, indica se a borda est� ativa
/*/
METHOD HasBorder( ) CLASS APPEXCCELLBORDER
RETURN ::lBorder                             

  
/*/{Protheus.doc} AppExcCellBorder:ClassName
M�todo respons�vel por retornar o nome da classe
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type  method
@return caractere, retorna o nome da classe
/*/
METHOD ClassName() CLASS AppExcCellBorder
RETURN ::cClassName
  
/*/{Protheus.doc} AppExcCellBorder:Destroy
M�todo destrutor do objeto, respons�vel pela desaloca��o da mem�ria
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type  method
/*/
METHOD Destroy() CLASS AppExcCellBorder          
	FreeObj(self)
RETURN 

     
/*/{Protheus.doc} AppExcCellBorder:BorderToString
Serializa��o da borda da c�lula para o padr�o XML Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type  method
@param nRow, inteiro, n�mero da linha que ser� serializada
@return caractere, String contendo bordas da c�lula especificada no padr�o XML
/*/
METHOD BorderToString( ) CLASS APPEXCCELLBORDER
	Local cBorder := "" 
	   
	If ::lBorder
		If !Empty(::cColor) 
			// O Excel aceita cores nas bordas apenas para Linha Continuos e tamanho 1     
			cBorder :=  '<Border ss:Position="' + GetPosition(::nTypeBorder)+'" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="'+::cColor+'"/>'
		Else
		                                       
			cBorder := '<Border ss:Position="' + GetPosition(::nTypeBorder)+'"'                         
			cBorder += ' ss:LineStyle="' + GetStyle( ::nLineStyle ) + '"'      
		     
			If ::nLineStyle == BORDER_LINE_CONTINUOUS
				cBorder += ' ss:Weight="'+cValToChar(::nLineWeight)+'"/>'
			Else
				cBorder += ' ss:Weight="1"/>'
			EndIf
		EndIf
	EndIf	
RETURN cBorder          
               
        
/*/ GetPosition
Fun��o est�tica para convers�o do identificador da borda com a string utilizada pelo XML Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014                                                                                  
@version 1.0                                       
@type  function                                                
@param nPosition, inteiro, identificador da borda podendo ser:
	BORDER_POSITION_TOP 			-> borda superior da c�lula
	BORDER_POSITION_BOTTOM 			-> borda inferior da c�lula
	BORDER_POSITION_LEFT 			-> borda esquerda da c�lula
	BORDER_POSITION_RIGHT 			-> borda direita da c�lula
	BORDER_POSITION_DIAGONAL_LEFT 	-> borda diagonal da esquerda para direita
	BORDER_POSITION_DIAGONAL_RIGHT 	-> borda diagonal da direita para a esquerda                                           	
@return, caractere, string utilizada pelo XML Excel
/*/
Static Function GetPosition( nPosition )
	Local cPosition := ""
	
	Do Case
		Case nPosition == BORDER_POSITION_TOP
	   		cPosition := "Top"
	   	Case nPosition == BORDER_POSITION_BOTTOM   
	   		cPosition := "Bottom"
	   	Case nPosition == BORDER_POSITION_LEFT
	   		cPosition := "Left"
	   	Case nPosition == BORDER_POSITION_RIGHT
	   		cPosition := "Right"
	   	Case nPosition == BORDER_POSITION_DIAGONAL_LEFT       
	   		cPosition := "DiagonalLeft"
	   	Case nPosition == BORDER_POSITION_DIAGONAL_RIGHT  
	   		cPosition := "DiagonalRight"
	EndCase      

Return cPosition                     
                           
/*/ GetStyle
Fun��o est�tica para convers�o do identificador do tipo da linha utilizada pela borda com a string utilizada pelo XML Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014                                                                                  
@version 1.0                                         
@type  function                                              
@param nStyle, inteiro, identificador da linha podendo ser:
	BORDER_LINE_CONTINUOUS 		-> "Continuous", linha continua
	BORDER_LINE_DOT   			-> "Dot", linha pontilhada
	BORDER_LINE_DASHDOT 		-> "DashDot", linha intercalada pontilhada/tracejada
	BORDER_LINE_DASHDOTDOT      -> "DashDotDot", linha intercalada pontilhada/tracejada/tracejada
	BORDER_LINE_SLANTDASHDOT  	-> "SlantDashDot", linha intercalada pontilhada/tracejada inclinada        
	BORDER_LINE_DOUBLE			-> "Double", linha dupla                                             	
@return, caractere, string utilizada pelo XML Excel	 
/*/
Static Function GetStyle( nStyle )       
	Local cStyle := ""
	
	Do Case
		Case nStyle == BORDER_LINE_CONTINUOUS
	   		cStyle := "Continuous"
	   	Case nStyle == BORDER_LINE_DOT   
	   		cStyle := "Dot"
	   	Case nStyle == BORDER_LINE_DASHDOT
	   		cStyle := "DashDot"
	   	Case nStyle == BORDER_LINE_DASHDOTDOT       
	   		cStyle := "DashDotDot"
	   	Case nStyle == BORDER_LINE_SLANTDASHDOT  
	   		cStyle := "SlantDashDot"        
	   	Case nStyle == BORDER_LINE_DOUBLE
	   		cStyle := "Double"
	EndCase      

Return cStyle