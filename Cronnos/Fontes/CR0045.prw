#Include 'Totvs.ch'

/*
Programa	:	CR0045
Autor		:	Fabiano da Silva
Data		:	18/10/13
Descrição	:	Cadastro E-mail	
*/

User Function CR0045()

	Local cVldAlt := ".T." // Operacao: ALTERACAO
	Local cVldExc := ".T." // Operacao: EXCLUSAO
	Local cAlias

	cAlias := "SZG"
	chkFile(cAlias)
	dbSelectArea(cAlias)

	dbSetOrder(1)

	Private cCadastro := "Cadastro de E-mail"

	aRotina := {;
		{ 'Pesquisar'	, "AxPesqui", 0, 1},;
		{ 'Visualizar'	, "AxVisual", 0, 2},;
		{ 'Incluir'		, "AxInclui", 0, 3},;
		{ 'Alterar'		, "AxAltera", 0, 4},;
		{ 'Exlcuir'		, "AxDeleta", 0, 5};
		}

	dbSelectArea(cAlias)
	mBrowse( 6, 1, 22, 75, cAlias)

Return
