#INCLUDE "Totvs.ch"

/*/
Fun�ao    	� 	CR0050
Autor 		� 	Fabiano da Silva
Data 		� 	23.12.13
Descricao 	� 	Correcao de Acumulado Caterpillar Exporta��o
/*/

User Function CR0050()

Private cString
Private cVldAlt := ".T." 
Private cVldExc := ".T." 
Private cString := "SZD"

dbSelectArea("SZD")
dbSetOrder(1)

AxCadastro(cString,"Acumulado Caterpillar",cVldAlt,cVldExc)

Return