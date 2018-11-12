#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} BRI116
Tabela de Pre�o Padr�o
/*/
User Function BRI116()

	//Indica a permiss�o ou n�o para a opera��o (pode-se utilizar 'ExecBlock')
	Local _cVldAlt	:= ".T." // Operacao: ALTERACAO
	Local _cVldExc	:= ".T." // Operacao: EXCLUSAO

	chkFile("ZF2")

	ZF2->(dbSetOrder(1))

	axCadastro("ZF2", "Tabela de Pre�o Padr�o", _cVldExc, _cVldAlt)

Return(Nil)
