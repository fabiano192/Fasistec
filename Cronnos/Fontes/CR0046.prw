#Include 'Totvs.ch'

/*
Programa	:	CR0046
Autor		:	Fabiano da Silva
Data		:	18/10/13
Descrição	:	Status ASN/Invoice	
*/

User Function CR0046()

	Local cAlias := "SZH"
	Local aCores := {}

	Private cCadastro := "Status ASN / Invoice"
	Private aRotina := {}

	AADD(aRotina,{"Pesquisar"  	,"AxPesqui"  	,0,1})
	AADD(aRotina,{"Visualizar" 	,"AxVisual"  	,0,2})
//	AADD(aRotina,{"Incluir" 	,"AxInclui"		,0,3})
//	AADD(aRotina,{"Alterar" 	,"AxAltera"		,0,4})
//	AADD(aRotina,{"Excluir" 	,"AxDeleta"		,0,4})
	AADD(aRotina,{"Legenda"    	,"U_CR046LEG()" 	,0,2})

/*-- CORES DISPONIVEIS PARA LEGENDA 
BR_AMARELO
BR_AZUL
BR_BRANCO
BR_CINZA
BR_LARANJA
BR_MARRON
BR_VERDE
BR_VERMELHO
BR_PINK
BR_PRETO
*/

	AADD(aCores,{"EMPTY(ZH_STATUS)" ,"BR_BRANCO" })
	AADD(aCores,{"ZH_STATUS == 'A'" ,"BR_VERDE" })
	AADD(aCores,{"ZH_STATUS == 'E'" ,"BR_AMARELO" })
	AADD(aCores,{"ZH_STATUS == 'P'" ,"BR_LARANJA" })
	AADD(aCores,{"ZH_STATUS == 'R'" ,"BR_VERMELHO" })

	mBrowse( 6,1,22,75,cAlias,,,,,,aCores)

Return


	/*
	Funcao		:CR046LEG
	Descrição	:Legenda da mbrowse.
	*/
User Function CR046LEG()

	Local aLegenda := {}

	aAdd(aLegenda,{ "BR_BRANCO"		, "Sem Retorno" })
	aAdd(aLegenda,{ "BR_VERDE"		, "Aprovado" })
	aAdd(aLegenda,{ "BR_AMARELO"	, "Aprovado com Erros" })
	aAdd(aLegenda,{ "BR_LARANJA"	, "Parcialmente Aprovado" })
	aAdd(aLegenda,{ "BR_VERMELHO"	, "Reprovado" })

	BrwLegenda(cCadastro,"Legenda", aLegenda)

Return
