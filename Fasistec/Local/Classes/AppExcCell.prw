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

/*/{Protheus.doc} AppExcCell
Classe fornecedora de método para gerenciameto de formação de células em Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                   
@type class
/*/
CLASS AppExcCell FROM LongClassName

	//Identifier
	DATA cID	AS STRING HIDDEN  
	
	//Borders
	DATA oBorderTop 	AS OBJECT HIDDEN              
	DATA oBorderBottom 	AS OBJECT HIDDEN              
	DATA oBorderLeft 	AS OBJECT HIDDEN              
	DATA oBorderRight 	AS OBJECT HIDDEN              
	DATA oBorderDLeft 	AS OBJECT HIDDEN              
	DATA oBorderDRight 	AS OBJECT HIDDEN              
    
	//Font
	DATA oFont	AS OBJECT HIDDEN
	                          
	//Interior
	DATA cCellColor	AS STRING HIDDEN            
	            
	//Format
	DATA oFormat AS OBJECT HIDDEN                           
	
	//Align
	DATA oAlign AS OBJECT HIDDEN                           
	    	                                    
	//Class Properties
	DATA cClassName AS STRING HIDDEN
	
	//Constructor                       
	METHOD New() CONSTRUCTOR    
	
	//Identifier
	METHOD SetId(cIdPar)    
	METHOD GetId()    
           
    //Borders           
	METHOD SetBorder(nTypeBorder, bSetBorder)    
	METHOD SetABorders(bSetBorder, bDiagonal)                 
	METHOD SetLineBorder(nTypeLine, nTypeLine)    
	METHOD SetALineBorders(nTypeLine, bDiagonal)  
	METHOD SetLineWeigth(nTypeBorder, nWeigth)       
	METHOD SetALineWeigth(nWeigth, bDiagonal)
	METHOD SetLineColor(nTypeBorder, cColor)       
	METHOD SetALineColor(cColor, bDiagonal)
	                                             
	METHOD GetBorder(nTypeBorder)    
	METHOD GetLineBorder(nTypeBorder)                  
	METHOD GetLineWeigth(nTypeBorder)            
	METHOD GetLineColor(nTypeBorder)          

	//Interior
	METHOD SetCellColor(cColor) 
	METHOD GetCellColor()
	           
	//Font
	METHOD SetFont(oFontPar)      
	METHOD GetFont()      
	
	//Format
	METHOD SetFormat( nFormat )	
	METHOD GetFormat()	
	                
	//Align
	METHOD SetVertAlign( nAlign )
	METHOD SetHorzAlign( nAlign )
	               
	METHOD GetVertAlign( )       
	METHOD GetHorzAlign( )
	                         
	//Manipulation
	METHOD Clone( oCellFather )	
	
	//To String
	METHOD CellToString()
	
	//Class Properties
	METHOD Destroy()  
	METHOD ClassName()	 
	
ENDCLASS

  
/*/{Protheus.doc} AppExcCell:New
Método construtor da classe AppExcCell
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                
@type constructor
/*/
METHOD New() CLASS AppExcCell
	::cClassName	:= "AppExcCell"

 	::oBorderTop 		:= AppExcCellBorder():New( BORDER_POSITION_TOP )
	::oBorderBottom 	:= AppExcCellBorder():New( BORDER_POSITION_BOTTOM ) 
	::oBorderLeft 		:= AppExcCellBorder():New( BORDER_POSITION_LEFT )
	::oBorderRight 		:= AppExcCellBorder():New( BORDER_POSITION_RIGHT )
	::oBorderDLeft 		:= AppExcCellBorder():New( BORDER_POSITION_DIAGONAL_LEFT )
	::oBorderDRight 	:= AppExcCellBorder():New( BORDER_POSITION_DIAGONAL_RIGHT )
	     
	::oFormat 		:= AppExcCellFormat():New()	 
	::oAlign 		:= AppExcCellAlign():New()	
	::oFont 		:= nil
RETURN       



/*/{Protheus.doc} AppExcCell:SetId
Método manipulador da propriedade cID
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0         
@type method                                 
@param cIdPar, character, código do estilo que será atribuido         
/*/
METHOD SetId(cIdPar) CLASS AppExcCell
	::cID := cIdPar
RETURN


/*/{Protheus.doc} AppExcCell:GetId
Método de acesso da propriedade cID
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                             
@type method                              
@return caractere, identificador do objeto
/*/
METHOD GetId() CLASS AppExcCell   
RETURN ::cID  


/*/{Protheus.doc} AppExcCell:SetBorder
Método para ativar/desativar bordas nas células
@author anderson.toledo
@since 18/02/2014
@version 1.0
@type method
@param nTypeBorder, numérico, identificador da borda podendo ser: |ul||li|BORDER_POSITION_TOP 			-> borda superior da célula|/li| |li|BORDER_POSITION_BOTTOM 			-> borda inferior da célula|/li| |li|BORDER_POSITION_LEFT 			-> borda esquerda da célula|/li| |li|BORDER_POSITION_RIGHT 			-> borda direita da célula|/li| |li|BORDER_POSITION_DIAGONAL_LEFT 	-> borda diagonal da esquerda para direita|/li| |li|BORDER_POSITION_DIAGONAL_RIGHT 	-> borda diagonal da direita para a esquerda|/li||/ul|
@param bSetBorder, booleano, indica se a borda deve ser ativada ou não

/*/
METHOD SetBorder(nTypeBorder, bSetBorder ) CLASS AppExcCell     
                                               
	Do Case
		Case BORDER_POSITION_TOP == nTypeBorder  	
			::oBorderTop:SetBorder( bSetBorder )
		Case BORDER_POSITION_BOTTOM == nTypeBorder  	
			::oBorderBottom:SetBorder( bSetBorder )
		Case BORDER_POSITION_LEFT == nTypeBorder  	
			::oBorderLeft:SetBorder( bSetBorder )
		Case BORDER_POSITION_RIGHT == nTypeBorder  	
			::oBorderRight:SetBorder( bSetBorder )
		Case BORDER_POSITION_DIAGONAL_LEFT == nTypeBorder  	
			::oBorderDLeft:SetBorder( bSetBorder )
		Case BORDER_POSITION_DIAGONAL_RIGHT == nTypeBorder  	 
			::oBorderDRight:SetBorder( bSetBorder )
	End Case
	
RETURN



/*/{Protheus.doc} AppExcCell:SetABorders
Método para ativar/desativar todas as bordas da célula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param bSetBorder, lógico, indica se a borda deve ser ativada ou não
@param bDiagonal, lógico, indica se as bordas diagonais devem ser consideradas
/*/
METHOD SetABorders(bSetBorder, bDiagonal) CLASS AppExcCell  
	DEFAULT bDiagonal := .F.                                          
                    
	::oBorderTop:SetBorder( bSetBorder )
	::oBorderBottom:SetBorder( bSetBorder )
	::oBorderLeft:SetBorder( bSetBorder )
	::oBorderRight:SetBorder( bSetBorder )
	
	If bDiagonal
		::oBorderDLeft:SetBorder( bSetBorder )
		::oBorderDRight:SetBorder( bSetBorder )
	EndIf	
RETURN	            
           


/*/{Protheus.doc} AppExcCell:SetLineBorder
Método alterar o tipo da linha na borda
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                                            
@type method
@param nTypeBorder, inteiro, identificador da borda podendo ser:|ul||li|BORDER_POSITION_TOP 			-> borda superior da célula|/li||li|BORDER_POSITION_BOTTOM 			-> borda inferior da célula|/li||li|BORDER_POSITION_LEFT 			-> borda esquerda da célula|/li||li|BORDER_POSITION_RIGHT 			-> borda direita da célula|/li||li|BORDER_POSITION_DIAGONAL_LEFT 	-> borda diagonal da esquerda para direita|/li||li|BORDER_POSITION_DIAGONAL_RIGHT 	-> borda diagonal da direita para a esquerda|/li||/ul|                                                                            
@param nTypeLine, inteiro, indica o tipo da linha podendo ser:|ul||li|BORDER_LINE_CONTINUOUS 		-> "Continuous", linha continua|/li||li|BORDER_LINE_DOT   			-> "Dot", linha pontilhada|/li||li|BORDER_LINE_DASHDOT 		-> "DashDot", linha intercalada pontilhada/tracejada|/li||li|BORDER_LINE_DASHDOTDOT      -> "DashDotDot", linha intercalada pontilhada/tracejada/tracejada|/li||li|BORDER_LINE_SLANTDASHDOT  	-> "SlantDashDot", linha intercalada pontilhada/tracejada inclinada|/li|        |li|BORDER_LINE_DOUBLE			-> "Double", linha dupla|/li||/ul|              
/*/
METHOD SetLineBorder(nTypeBorder, nTypeLine) CLASS AppExcCell  
	Do Case
		Case BORDER_POSITION_TOP == nTypeBorder  	
			::oBorderTop:SetLineStyle( nTypeLine )
		Case BORDER_POSITION_BOTTOM == nTypeBorder  	
			::oBorderBottom:SetLineStyle( nTypeLine )
		Case BORDER_POSITION_LEFT == nTypeBorder  	
			::oBorderLeft:SetLineStyle( nTypeLine )
		Case BORDER_POSITION_RIGHT == nTypeBorder  	
			::oBorderRight:SetLineStyle( nTypeLine )
		Case BORDER_POSITION_DIAGONAL_LEFT == nTypeBorder  	
			::oBorderDLeft:SetLineStyle( nTypeLine )
		Case BORDER_POSITION_DIAGONAL_RIGHT == nTypeBorder  	 
			::oBorderDRight:SetLineStyle( nTypeLine )
	End Case
RETURN      


/*/{Protheus.doc} AppExcCell:SetALineBorders
Método alterar o tipo da linha de todas as bordas
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                                                           
@type method
@param nTypeLine, inteiro, indica o tipo da linha podendo ser:|ul||li|BORDER_LINE_CONTINUOUS 		-> "Continuous", linha continua|/li||li|BORDER_LINE_DOT   			-> "Dot", linha pontilhada|/li||li|BORDER_LINE_DASHDOT 		-> "DashDot", linha intercalada pontilhada/tracejada|/li||li|BORDER_LINE_DASHDOTDOT      -> "DashDotDot", linha intercalada pontilhada/tracejada/tracejada|/li||li|BORDER_LINE_SLANTDASHDOT  	-> "SlantDashDot", linha intercalada pontilhada/tracejada inclinada|/li||li|BORDER_LINE_DOUBLE			-> "Double", linha dupla|/li||/ul|
@param bDiagonal, lógico, indica se as bordas diagonais devem ser consideradas
/*/
METHOD SetALineBorders(nTypeLine, bDiagonal) CLASS AppExcCell  
 	DEFAULT bDiagonal := .F.   
	
	::oBorderTop:SetLineStyle( nTypeLine )
	::oBorderBottom:SetLineStyle( nTypeLine )
	::oBorderLeft:SetLineStyle( nTypeLine )
	::oBorderRight:SetLineStyle( nTypeLine )
	
	If bDiagonal
		::oBorderDLeft:SetLineStyle( nTypeLine )
		::oBorderDRight:SetLineStyle( nTypeLine )
	EndIf
RETURN
   
                                                        

/*/{Protheus.doc} AppExcCell:SetLineWeigth
Método alterar a espessura da linha
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param nTypeBorder, inteiro, identificador da borda podendo ser:|ul||li|BORDER_POSITION_TOP 			-> borda superior da célula|/li||li|BORDER_POSITION_BOTTOM 			-> borda inferior da célula|/li||li|BORDER_POSITION_LEFT 			-> borda esquerda da célula|/li||li|BORDER_POSITION_RIGHT 			-> borda direita da célula|/li||li|BORDER_POSITION_DIAGONAL_LEFT 	-> borda diagonal da esquerda para direita|/li||li|BORDER_POSITION_DIAGONAL_RIGHT 	-> borda diagonal da direita para a esquerda|/li||/ul|
@param nWeigth,inteiro,indica a esperrura da linha podendo variar de 0 a 3
/*/
METHOD SetLineWeigth(nTypeBorder, nWeigth) CLASS AppExcCell       
	Do Case
		Case BORDER_POSITION_TOP == nTypeBorder  	
			::oBorderTop:SetWeight( nWeigth )
		Case BORDER_POSITION_BOTTOM == nTypeBorder  	
			::oBorderBottom:SetWeight( nWeigth )
		Case BORDER_POSITION_LEFT == nTypeBorder  	
			::oBorderLeft:SetWeight( nWeigth )
		Case BORDER_POSITION_RIGHT == nTypeBorder  	
			::oBorderRight:SetWeight( nWeigth )
		Case BORDER_POSITION_DIAGONAL_LEFT == nTypeBorder  	
			::oBorderDLeft:SetWeight( nWeigth )
		Case BORDER_POSITION_DIAGONAL_RIGHT == nTypeBorder  	 
			::oBorderDRight:SetWeight( nWeigth )
	End Case
RETURN

/*/{Protheus.doc} AppExcCell:SetALineWeigth
Método alterar o tipo da linha de todas as bordas
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                                                           
@type method
@param nWeigth,inteiro,indica a esperrura da linha podendo variar de 0 a 3
@param bDiagonal, lógico, indica se as bordas diagonais devem ser consideradas
/*/
METHOD SetALineWeigth(nWeigth, bDiagonal) CLASS AppExcCell
 	DEFAULT bDiagonal := .F.   
	
	::oBorderTop:SetWeight( nWeigth )
	::oBorderBottom:SetWeight( nWeigth )
	::oBorderLeft:SetWeight( nWeigth )
	::oBorderRight:SetWeight( nWeigth )
	
	If bDiagonal
		::oBorderDLeft:SetWeight( nWeigth )
		::oBorderDRight:SetWeight( nWeigth )
	EndIf
RETURN             
                                                                          


/*/{Protheus.doc} AppExcCell:SetLineColor
Método para alterar a cor da linha de uma borda
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                                                           
@type method
@param nTypeBorder, inteiro, identificador da borda podendo ser:|ul||li|BORDER_POSITION_TOP 			-> borda superior da célula|/li||li|BORDER_POSITION_BOTTOM 			-> borda inferior da célula|/li||li|BORDER_POSITION_LEFT 			-> borda esquerda da célula|/li||li|BORDER_POSITION_RIGHT 			-> borda direita da célula|/li||li|BORDER_POSITION_DIAGONAL_LEFT 	-> borda diagonal da esquerda para direita|/li||li|BORDER_POSITION_DIAGONAL_RIGHT 	-> borda diagonal da direita para a esquerda|/li|                                                                            |/ul|
@param cColor, caractere, cor da linha em padrão hexadecimal ex.: #000000 (preto)
/*/
METHOD SetLineColor(nTypeBorder, cColor) CLASS AppExcCell       
	Do Case
		Case BORDER_POSITION_TOP == nTypeBorder  	
			::oBorderTop:SetColor( cColor )
		Case BORDER_POSITION_BOTTOM == nTypeBorder  	
			::oBorderBottom:SetColor( cColor )
		Case BORDER_POSITION_LEFT == nTypeBorder  	
			::oBorderLeft:SetColor( cColor )
		Case BORDER_POSITION_RIGHT == nTypeBorder  	
			::oBorderRight:SetColor( cColor )
		Case BORDER_POSITION_DIAGONAL_LEFT == nTypeBorder  	
			::oBorderDLeft:SetColor( cColor )
		Case BORDER_POSITION_DIAGONAL_RIGHT == nTypeBorder  	 
			::oBorderDRight:SetColor( cColor )
	End Case
RETURN

                                                                                 
/*/{Protheus.doc} AppExcCell:SetALineColor
Método para alterar a cor da linha de todas as bordas
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                                                                  
@type method 
@param cColor, caractere, cor da linha em padrão hexadecimal ex.: #000000 (preto)
@param bDiagonal, lógico, indica se as bordas diagonais devem ser consideradas               
/*/
METHOD SetALineColor(cColor, bDiagonal) CLASS AppExcCell
 	DEFAULT bDiagonal := .F.   
	
	::oBorderTop:SetColor( cColor )
	::oBorderBottom:SetColor( cColor )
	::oBorderLeft:SetColor( cColor )
	::oBorderRight:SetColor( cColor )
	
	If bDiagonal
		::oBorderDLeft:SetColor( cColor )
		::oBorderDRight:SetColor( cColor )
	EndIf
RETURN
           
   

/*/{Protheus.doc} AppExcCell:SetCellColor
Método para alterar a cor de fundo de uma célula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                                                                               
@type method
@param cColor, caractere, cor de funda da célula em padrão hexadecimal ex.: #000000 (preto)
/*/
METHOD SetCellColor(cColor) CLASS AppExcCell  
	::cCellColor := cColor
RETURN                                                                         


/*/{Protheus.doc} AppExcCell:SetFont
Método para alterar a fonte utilizada na célula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                           
@type method
@param oFontPar, objeto, objeto da classe AppExcCell
@See
AppExcFont
/*/
METHOD SetFont(oFontPar) CLASS AppExcCell  
	::oFont := oFontPar
RETURN      

      
/*/{Protheus.doc} AppExcCell:SetFormat
Método para alterar o formato da célula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0         
@type method                                                                      
@param nFormat, inteiro, código do formato a ser utilizado, os formatos suportados são:|ul||li|NUMBER_CURRENCY_REAL		-> Numero formato moeda em R$|/li||li|NUMBER_CURRENCY_RED_REAL    -> Numero formato moeda em R$, negativos em vermelho|/li||/ul|                                               
@See
AppExcFormat
/*/
METHOD SetFormat( nFormat ) CLASS AppExcCell                                           
	::oFormat:SetFormat( nFormat )	                                         	                                              
RETURN                                        
         
/*/{Protheus.doc} AppExcCell:SetVertAlign
Método para alterar o alinhamento vertical da célula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0      
@type method                  
@param nAlign, inteiro, código do tipo do alinhamento, sendo:|ul||li|VERTICAL_ALIGN_TOP   	 -> define o alinhamento vertical como "acima"|/li||li|VERTICAL_ALIGN_CENTER    -> define o alinhamento vertical como "centralizado"|/li||li|VERTICAL_ALIGN_BOTTOM	 -> define o alinhamento vertical como "abaixo"|/li||/ul|
@See
AppExcAlign
/*/
METHOD SetVertAlign( nAlign ) CLASS AppExcCell                                                  
	::oAlign:SetVertAlign( nAlign )
RETURN
        
/*/{Protheus.doc} AppExcCell:SetHorzAlign
Método para alterar o alinhamento horizontal da célula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param nAlign, inteiro, código do tipo do alinhamento, sendo:|ul||li|HORIZONTAL_ALIGN_RIGHT   	-> define o alinhamento "a direira"|/li||li|HORIZONTAL_ALIGN_CENTER    	-> define o alinhamento "centralizado"|/li||li|HORIZONTAL_ALIGN_LEFT	 	-> define o alinhamento "a esquerda"|/li||/ul|
@See
AppExcAlign
/*/
METHOD SetHorzAlign( nAlign ) CLASS AppExcCell  
	::oAlign:SetHorzAlign( nAlign )
RETURN


/*/{Protheus.doc} AppExcCell:GetBorder
Método de acesso para verificar se determina borda está ativada
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param nTypeBorder, inteiro, identificador da borda podendo ser:|ul||li|BORDER_POSITION_TOP 			-> borda superior da célula|/li||li|BORDER_POSITION_BOTTOM 			-> borda inferior da célula|/li||li|BORDER_POSITION_LEFT 			-> borda esquerda da célula|/li||li|BORDER_POSITION_RIGHT 			-> borda direita da célula|/li||li|BORDER_POSITION_DIAGONAL_LEFT 	-> borda diagonal da esquerda para direita|/li||li|BORDER_POSITION_DIAGONAL_RIGHT 	-> borda diagonal da direita para a esquerda|/li||/ul|                                               
@return lógico, indica se a borda informada está ativa
/*/
METHOD GetBorder(nTypeBorder) CLASS AppExcCell    
	Do Case
		Case BORDER_POSITION_TOP == nTypeBorder  	
			Return ::oBorderTop:GetBorder()
		Case BORDER_POSITION_BOTTOM == nTypeBorder  	
			Return ::oBorderBottom:GetBorder()
		Case BORDER_POSITION_LEFT == nTypeBorder  	
			Return ::oBorderLeft:GetBorder()
		Case BORDER_POSITION_RIGHT == nTypeBorder  	
			Return ::oBorderRight:GetBorder()
		Case BORDER_POSITION_DIAGONAL_LEFT == nTypeBorder  	
			Return ::oBorderDLeft:GetBorder()
		Case BORDER_POSITION_DIAGONAL_RIGHT == nTypeBorder  	 
			Return ::oBorderDRight:GetBorder()
	End Case
RETURN                                                             


/*/{Protheus.doc} AppExcCell:GetLineBorder
Método de acesso para verificar o tipo da linha em uma determinada borda
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param nTypeBorder, inteiro, identificador da borda podendo ser:|ul||li|BORDER_POSITION_TOP 			-> borda superior da célula|/li||li|BORDER_POSITION_BOTTOM 			-> borda inferior da célula|/li||li|BORDER_POSITION_LEFT 			-> borda esquerda da célula|/li||li|BORDER_POSITION_RIGHT 			-> borda direita da célula|/li||li|BORDER_POSITION_DIAGONAL_LEFT 	-> borda diagonal da esquerda para direita|/li||li|BORDER_POSITION_DIAGONAL_RIGHT 	-> borda diagonal da direita para a esquerda|/li||/ul|
@return inteiro, indica o código do tipo da linha utilizada
/*/
METHOD GetLineBorder(nTypeBorder) CLASS AppExcCell  
	Do Case
		Case BORDER_POSITION_TOP == nTypeBorder  	
			Return ::oBorderTop:GetLineStyle()
		Case BORDER_POSITION_BOTTOM == nTypeBorder  	
			Return ::oBorderBottom:GetLineStyle()
		Case BORDER_POSITION_LEFT == nTypeBorder  	
			Return ::oBorderLeft:GetLineStyle()
		Case BORDER_POSITION_RIGHT == nTypeBorder  	
			Return ::oBorderRight:GetLineStyle()
		Case BORDER_POSITION_DIAGONAL_LEFT == nTypeBorder  	
			Return ::oBorderDLeft:GetLineStyle()
		Case BORDER_POSITION_DIAGONAL_RIGHT == nTypeBorder  	 
			Return ::oBorderDRight:GetLineStyle()
	End Case
RETURN                        
     
/*/{Protheus.doc} AppExcCell:GetLineWeigth
Método de acesso para verificar a espessura da linha em uma determinada borda
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                                             
@type method 
@param nTypeBorder, inteiro, identificador da borda podendo ser:|ul||li|BORDER_POSITION_TOP 			-> borda superior da célula|/li||li|BORDER_POSITION_BOTTOM 			-> borda inferior da célula|/li||li|BORDER_POSITION_LEFT 			-> borda esquerda da célula|/li||li|BORDER_POSITION_RIGHT 			-> borda direita da célula|/li||li|BORDER_POSITION_DIAGONAL_LEFT 	-> borda diagonal da esquerda para direita|/li||li|BORDER_POSITION_DIAGONAL_RIGHT 	-> borda diagonal da direita para a esquerda|/li||/ul|
@return inteiro, indica a espessura da borda especificada
/*/
METHOD GetLineWeigth(nTypeBorder) CLASS AppExcCell       
	Do Case
		Case BORDER_POSITION_TOP == nTypeBorder  	
			Return ::oBorderTop:GetWeight()
		Case BORDER_POSITION_BOTTOM == nTypeBorder  	
			Return ::oBorderBottom:GetWeight()
		Case BORDER_POSITION_LEFT == nTypeBorder  	
			Return ::oBorderLeft:GetWeight()
		Case BORDER_POSITION_RIGHT == nTypeBorder  	
			Return ::oBorderRight:GetWeight()
		Case BORDER_POSITION_DIAGONAL_LEFT == nTypeBorder  	
			Return ::oBorderDLeft:GetWeight()
		Case BORDER_POSITION_DIAGONAL_RIGHT == nTypeBorder  	 
			Return ::oBorderDRight:GetWeight()
	End Case
RETURN           
     

/*/{Protheus.doc} AppExcCell:GetLineColor
Método de acesso para verificar a cor da linha em uma determinada borda
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                                                             
@type method
@param nTypeBorder, inteiro, identificador da borda podendo ser:|ul||li|BORDER_POSITION_TOP 			-> borda superior da célula|/li||li|BORDER_POSITION_BOTTOM 			-> borda inferior da célula|/li||li|BORDER_POSITION_LEFT 			-> borda esquerda da célula|/li||li|BORDER_POSITION_RIGHT 			-> borda direita da célula|/li||li|BORDER_POSITION_DIAGONAL_LEFT 	-> borda diagonal da esquerda para direita|/li||li|BORDER_POSITION_DIAGONAL_RIGHT 	-> borda diagonal da direita para a esquerda|/li||/ul|                                               
@return caractere, string contendo a cor da célula em padrão hexadecimal
/*/
METHOD GetLineColor(nTypeBorder) CLASS AppExcCell       
	Do Case
		Case BORDER_POSITION_TOP == nTypeBorder  	
			Return ::oBorderTop:GetColor()
		Case BORDER_POSITION_BOTTOM == nTypeBorder  	
			Return ::oBorderBottom:GetColor()
		Case BORDER_POSITION_LEFT == nTypeBorder  	
			Return ::oBorderLeft:GetColor()
		Case BORDER_POSITION_RIGHT == nTypeBorder  	
			Return ::oBorderRight:GetColor()
		Case BORDER_POSITION_DIAGONAL_LEFT == nTypeBorder  	
			Return ::oBorderDLeft:GetColor()
		Case BORDER_POSITION_DIAGONAL_RIGHT == nTypeBorder  	 
			Return ::oBorderDRight:GetColor()
	End Case
RETURN    


/*/{Protheus.doc} AppExcCell:GetCellColor
Método de acesso para obter a cor de fundo da célula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@return character, string contendo a cor de fundo da célula em padrão hexadecimal
/*/
METHOD GetCellColor(cteste) CLASS AppExcCell                 
RETURN ::cCellColor    

/*/{Protheus.doc} AppExcCell:GetFont
Método de acesso para obter a fonte utilizada na célula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@return objeto, objeto da classe AppExcCell utilizada na célula
/*/
METHOD GetFont() CLASS AppExcCell  
RETURN ::oFont
   
/*/{Protheus.doc} AppExcCell:GetFormat
Método de acesso para obter o formato da célula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@return inteiro, retorna o identificador da formação da célula
/*/
METHOD GetFormat( ) CLASS AppExcCell                                           
RETURN ::oFormat:GetFormat( )                                  


/*/{Protheus.doc} AppExcCell:GetVertAlign
Método de acesso obter o alinhamento vertical da célula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@return inteiro, identificador do alinhamento vertical da célula
/*/
METHOD GetVertAlign( ) CLASS AppExcCell                                                  
RETURN ::oAlign:GetVertAlign( )

/*/{Protheus.doc} AppExcCell:GetHorzAlign
Método de acesso obter o alinhamento horizontal da célula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@return inteiro, identificador do alinhamento horizontal da célula
/*/
METHOD GetHorzAlign( nAlign ) CLASS AppExcCell  
RETURN ::oAlign:GetHorzAlign( )
                                                                     
/*/{Protheus.doc} AppExcCell:Clone
Método para copiar todos atributos de um objeto da classe AppExcCell, evitando duplicidade na criação do script AdvPl da planilha
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                           
@type method
@param oCellFather, objeto, objeto da classe AppExcCell
@see
AppExcCell
/*/
METHOD Clone( oCellFather ) CLASS AppExcCell  

    //Borders
	::SetBorder(BORDER_POSITION_LEFT			, oCellFather:GetBorder(BORDER_POSITION_LEFT) )   
	::SetBorder(BORDER_POSITION_RIGHT			, oCellFather:GetBorder(BORDER_POSITION_RIGHT) )   
	::SetBorder(BORDER_POSITION_TOP				, oCellFather:GetBorder(BORDER_POSITION_TOP) )   
	::SetBorder(BORDER_POSITION_BOTTOM			, oCellFather:GetBorder(BORDER_POSITION_BOTTOM) )   
	::SetBorder(BORDER_POSITION_DIAGONAL_LEFT	, oCellFather:GetBorder(BORDER_POSITION_DIAGONAL_LEFT) )   
	::SetBorder(BORDER_POSITION_DIAGONAL_RIGHT	, oCellFather:GetBorder(BORDER_POSITION_DIAGONAL_RIGHT) )   
	
	::SetLineBorder(BORDER_POSITION_LEFT			, oCellFather:GetLineBorder(BORDER_POSITION_LEFT))    
	::SetLineBorder(BORDER_POSITION_RIGHT			, oCellFather:GetLineBorder(BORDER_POSITION_RIGHT))    
	::SetLineBorder(BORDER_POSITION_TOP				, oCellFather:GetLineBorder(BORDER_POSITION_TOP))    
	::SetLineBorder(BORDER_POSITION_BOTTOM			, oCellFather:GetLineBorder(BORDER_POSITION_BOTTOM))    
	::SetLineBorder(BORDER_POSITION_DIAGONAL_LEFT	, oCellFather:GetLineBorder(BORDER_POSITION_DIAGONAL_LEFT))    
	::SetLineBorder(BORDER_POSITION_DIAGONAL_RIGHT	, oCellFather:GetLineBorder(BORDER_POSITION_DIAGONAL_RIGHT))
			
	::SetLineWeigth(BORDER_POSITION_LEFT			, oCellFather:GetLineWeigth(BORDER_POSITION_LEFT))       
	::SetLineWeigth(BORDER_POSITION_RIGHT			, oCellFather:GetLineWeigth(BORDER_POSITION_RIGHT))       
	::SetLineWeigth(BORDER_POSITION_TOP				, oCellFather:GetLineWeigth(BORDER_POSITION_TOP))       
	::SetLineWeigth(BORDER_POSITION_BOTTOM			, oCellFather:GetLineWeigth(BORDER_POSITION_BOTTOM))       
	::SetLineWeigth(BORDER_POSITION_DIAGONAL_LEFT	, oCellFather:GetLineWeigth(BORDER_POSITION_DIAGONAL_LEFT))       
	::SetLineWeigth(BORDER_POSITION_DIAGONAL_RIGHT	, oCellFather:GetLineWeigth(BORDER_POSITION_DIAGONAL_RIGHT))
			
	::SetLineColor(BORDER_POSITION_LEFT				, oCellFather:GetLineColor(BORDER_POSITION_LEFT))       
	::SetLineColor(BORDER_POSITION_RIGHT			, oCellFather:GetLineColor(BORDER_POSITION_RIGHT))       
	::SetLineColor(BORDER_POSITION_TOP				, oCellFather:GetLineColor(BORDER_POSITION_TOP))       	
	::SetLineColor(BORDER_POSITION_BOTTOM			, oCellFather:GetLineColor(BORDER_POSITION_BOTTOM))       	
	::SetLineColor(BORDER_POSITION_DIAGONAL_LEFT	, oCellFather:GetLineColor(BORDER_POSITION_DIAGONAL_LEFT))       	
	::SetLineColor(BORDER_POSITION_DIAGONAL_RIGHT	, oCellFather:GetLineColor(BORDER_POSITION_DIAGONAL_RIGHT))       	

                             
	//Interior
	::SetCellColor( oCellFather:GetCellColor() ) 
	       
	//Font
	::SetFont( oCellFather:GetFont() )      
	
	//Format
	::SetFormat( oCellFather:GetFormat() )	
		                
	//Align
	::SetVertAlign( oCellFather:GetVertAlign() )
	::SetHorzAlign( oCellFather:GetHorzAlign() )
	               
RETURN
              
/*/{Protheus.doc} AppExcCell:CellToString
Serialização da célula para o padrão XML Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type method
@param nRow, inteiro, número da linha que será serializada
@return caractere, String contendo a célula especificada no padrão XML
/*/
METHOD CellToString() CLASS AppExcCell  
	Local cCell := ""                                        
     
    cCell := Space(6)+'<Style ss:ID="'+::cID+'">' + CRLF
                                      
    If ::oAlign:HasAlign()
		cCell += ::oAlign:AlignToString() + CRLF                                                                                       
    EndIf
    
    If ::oFormat:HasFormat()
  		cCell += ::oFormat:FormatToString() + CRLF                                                             
    EndIf                        
                                                                            
    
    If (::oBorderTop:HasBorder() .Or. ::oBorderBottom:HasBorder() .Or. ::oBorderLeft:HasBorder() .Or.;
     	::oBorderRight:HasBorder() .Or. ::oBorderDLeft:HasBorder() .Or. ::oBorderDRight:HasBorder() )
		
		cCell += Space(9)+'<Borders>' + CRLF                                   
			If ::oBorderTop:HasBorder()
				cCell += ::oBorderTop:BorderToString() + CRLF   
			EndIf
			If ::oBorderBottom:HasBorder()
				cCell += ::oBorderBottom:BorderToString() + CRLF   
			EndIf
			If ::oBorderLeft:HasBorder()
				cCell += ::oBorderLeft:BorderToString() + CRLF   
			EndIf
			If ::oBorderRight:HasBorder()
				cCell += ::oBorderRight:BorderToString() + CRLF   
			EndIf						
			If ::oBorderDLeft:HasBorder()
				cCell += ::oBorderDLeft:BorderToString() + CRLF   
			EndIf			
			If ::oBorderDRight:HasBorder()
				cCell += ::oBorderDRight:BorderToString() + CRLF   
			EndIf			
	    cCell += Space(9)+'</Borders>' + CRLF                                                                                         
    EndIf    
    
    If !Empty(::cCellColor)
        cCell += Space(9)+'<Interior ss:Color="'+::cCellColor+'" ss:Pattern="Solid"/>' + CRLF             
    EndIf                 
    
    If ValType(::oFont) == "O"
  		cCell += Space(9)+::oFont:FontToString() + CRLF  
    EndIf                 
    
    cCell += Space(6)+'</Style>' + CRLF                           
    
RETURN cCell

/*/{Protheus.doc} AppExcCell:ClassName
Método responsávelpor retornar o nome da classe
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type method
@return caractere, retorna o nome da classe
/*/
METHOD ClassName() CLASS AppExcCell 
RETURN ::cClassName 
                                
/*/{Protheus.doc} AppExcCell:Destroy
Método destrutor do objeto, responsável pela desalocação da memória
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type method
/*/
METHOD Destroy() CLASS AppExcCell 
	::oBorderTop:Destroy()
	::oBorderBottom:Destroy()
	::oBorderLeft:Destroy()
	::oBorderRight:Destroy()
	::oBorderDLeft:Destroy()
	::oBorderDRight:Destroy()
	::oFormat:Destroy()
	::oAlign:Destroy()
    
	If ValType( ::oFont ) == "O"
		::oFont:Destroy()
	EndIf	
                                                           
	FreeObj(self)                                
RETURN                                          