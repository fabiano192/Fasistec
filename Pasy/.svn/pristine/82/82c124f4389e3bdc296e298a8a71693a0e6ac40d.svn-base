#INCLUDE "rwmake.ch"

/*/
Programa	: 	PA0231
Autor		:	Fabiano da Silva
Data		:	17/10/12
Descricao	: 	Cadastro de Embalagens para ASN
/*/

User Function PA0231()

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZP"

dbSelectArea("SZP")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Embalagens ASN CAT. . .",cVldExc,cVldAlt)

Return
