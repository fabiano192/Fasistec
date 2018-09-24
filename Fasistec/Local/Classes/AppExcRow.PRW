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

#DEFINE CELL_ID 	1
#DEFINE CELL_OBJ	2
                          

/*/{Protheus.doc} AppExcRow
Classe fornecedora de métodos para gerenciamento de linhas em uma aba
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type class
/*/
CLASS AppExcRow FROM LongClassName
	DATA nRow 		AS Integer   	HIDDEN      
	DATA aCells		AS Array		HIDDEN
	DATA nIndex		AS Integer   	HIDDEN      	

	//Class Properties
	DATA cClassName AS STRING HIDDEN
	                     
	METHOD New() CONSTRUCTOR    
	METHOD AddCell( oObj )
	METHOD SetIndex( nIndex )	
	METHOD GetAssinature()       
	METHOD GetSize()   
	METHOD CellToString( nId )                   
	METHOD OrderCells()             
	
	//Class Properties
	METHOD Destroy()  
	METHOD ClassName()
	
ENDCLASS


/*/{Protheus.doc} AppExcRow:New
Método construtor da classe AppExcRow
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type constructor
@param nRow, inteiro, numero da linha na aba
/*/
METHOD New( nRow ) CLASS APPEXCROW
	::cClassName := "AppExcRow"
    
	::nRow 			:= nRow                    
	::nIndex		:= 0

	::aCells 		:= {}

RETURN                                                     


/*/{Protheus.doc} AppExcRow:AddCell
Método para adicionar uma célula na linha
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param oObj, objeto, objeto da classe ExcCellProperties
/*/
METHOD AddCell( oObj ) CLASS APPEXCROW
	aAdd(::aCells, { oObj:GetCol() , oObj })
RETURN      
                                                       
                   
/*/{Protheus.doc} AppExcRow:SetIndex
Método para manipular o index da linha
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
@param nIndex,inteiro, index da linha
/*/
METHOD SetIndex( nIndex ) CLASS APPEXCROW
	::nIndex := nIndex                          
RETURN                                                                                               
                                     
             
/*/{Protheus.doc} AppExcRow:GetAssinature
Método para obter uma string com a linha no padrão XML Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type method
/*/
METHOD GetAssinature() CLASS APPEXCROW
	Local cRow := ""      
                    
	cRow := " <Row"
	
	If(::nIndex) > 1
		cRow += ' ss:Index="'+cValToChar(::nIndex)+'"' 
	EndIf	   
	
	cRow +=	' ss:AutoFitHeight="0"'
	cRow +=	'>'              
	
RETURN cRow 

     
/*/{Protheus.doc} AppExcRow:GetSize
Método para obter quantas células foram adicionadas na linha
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0                        
@type method
/*/
METHOD GetSize() CLASS APPEXCROW
RETURN len(::aCells)


         
/*/{Protheus.doc} AppExcRow:OrderCells
Método para ordenar as células de acordo com a posição de cada coluna e atribuir os index de cada célula
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type method
/*/
METHOD OrderCells() CLASS APPEXCROW               
	Local nX 		:= 0
	Local nIndex	:= 0    
	
	aSort(::aCells,,,{|x,y| x[CELL_ID] < y[CELL_ID]}  )	
	
	If len(::aCells) > 0
		If ::aCells[1][CELL_ID] > 1
			::aCells[1][CELL_OBJ]:SetIndex( ::aCells[1][CELL_ID] )
		EndIf        
	
		For nX := 1 to len(::aCells) - 1   
			nIndex := ::aCells[nX + 1][CELL_ID] - ::aCells[nX][CELL_ID] 
			
			If nIndex > 1                                                                                             
				::aCells[nX + 1][CELL_OBJ]:SetIndex( ::aCells[nX][CELL_ID] + nIndex)	
			EndIf	
			
		Next
	EndIf	
	
RETURN
                     

/*/{Protheus.doc} AppExcRow:CellToString
Serialização da célula para o padrão XML Excel
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type method
@param nRow, inteiro, número da linha que será serializada
@return caractere, String contendo a célula especificada no padrão XML
/*/
METHOD CellToString( nPos ) CLASS APPEXCROW                         
RETURN ::aCells[nPos,CELL_OBJ]:CellToString()                                      

  
/*/{Protheus.doc} AppExcRow:ClassName
Método responsável por retornar o nome da classe
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0     
@type method
@return caractere, retorna o nome da classe 
/*/
METHOD ClassName() CLASS AppExcRow
RETURN ::cClassName
          
  
/*/{Protheus.doc} AppExcRow:Destroy
Método destrutor do objeto, responsável pela desalocação da memória
@author Anderson Toledo - anderson@appsoft.com.br
@since 18/02/2014
@version 1.0
@type method
/*/
METHOD Destroy() CLASS AppExcRow         
	Local nX := 1 
	
	For nX := 1 to len(::aCells) 
		::aCells[nX][CELL_OBJ]:Destroy()
	Next
	
	FreeObj(self)
RETURN 