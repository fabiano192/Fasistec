#Include 'Totvs.ch'

/*
Programa	:	PXH074
Autor		:	Fabiano da Silva
Data		:	29/05/15
Descrição	:	Cadastro E-mail	
*/

User Function PXH074()

  	Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
	Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

	Private cString := "SZ0"

	dbSelectArea("SZ0")
	dbSetOrder(1)

	AxCadastro(cString,"Cadastro de E-mail",cVldExc,cVldAlt)

Return
