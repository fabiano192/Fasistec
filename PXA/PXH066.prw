#INCLUDE "TOTVS.CH"

/*
Fun��o			:	PXH066
Autor			:	Fabiano da Silva
Data 			: 	09.10.2014 
Descri��o		: 	Cadastro E-mail Inventario Rotativo
*/


User Function PXH066()

	local cVldAlt := ".T." // Operacao: ALTERACAO
	local cVldExc := ".T." // Operacao: EXCLUSAO
	
	chkFile("ZAG")

	ZAG->(dbSetOrder(1))
	axCadastro("ZAG", "Cadastro de E-mail - Inventario Rotativo", cVldExc, cVldAlt)
	
return
