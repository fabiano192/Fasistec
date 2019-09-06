#INCLUDE "Totvs.ch"

/*/
Funçao    	³ 	CR0050
Autor 		³ 	Fabiano da Silva
Data 		³ 	23.12.13
Descricao 	³ 	Correcao de Acumulado Caterpillar Exportação
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