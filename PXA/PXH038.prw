#Include 'Totvs.ch'

/*
Programa 	: PXH038
Autor 		: Fabiano da Silva
Data 		: 19/11/13
Descri��o	: Cadastro de Equipamentos
*/

User function PXH038()

	Local cVldAlt := ".T." // Operacao: ALTERACAO
	Local cVldExc := ".T." // Operacao: EXCLUSAO

	SZC->(dbSetOrder(1))

	AxCadastro("SZC", "Cadastro de Itens (Plano de A��o)", cVldExc, cVldAlt)

Return
