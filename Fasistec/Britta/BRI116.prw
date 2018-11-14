#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} BRI116
Tabela de Preço Padrão
/*/
User Function BRI116()

	//Indica a permissão ou não para a operação (pode-se utilizar 'ExecBlock')
	Local _cVldAlt	:= ".T." // Operacao: ALTERACAO
	Local _cVldExc	:= ".T." // Operacao: EXCLUSAO

	chkFile("ZF2")

	ZF2->(dbSetOrder(1))

	axCadastro("ZF2", "Tabela de Preço Padrão", _cVldExc, _cVldAlt)

Return(Nil)
