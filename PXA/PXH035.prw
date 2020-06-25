#Include 'Totvs.ch'

/*
Programa 	: PXH035
Autor 		: Fabiano da Silva
Data 		: 22/10/13
Descrição	: Cadastro de TAGS
*/

User function PXH035()

	Local cVldAlt := ".T." // Operacao: ALTERACAO
	Local cVldExc := ".T." // Operacao: EXCLUSAO

	SZA->(dbSetOrder(1))

	AxCadastro("SZA", "Cadastro de TAGS", cVldExc, cVldAlt)

Return
