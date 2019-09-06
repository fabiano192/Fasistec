#INCLUDE 'TOTVS.CH'

//Cadastro das rotinas do Sistema
USER Function CR0079()

Local cVldAlt := ".T." // Operacao: ALTERACAO
Local cVldExc := ".T." // Operacao: EXCLUSAO

ZZY->(dbSetOrder(1))

AxCadastro("ZZY", "Rotinas do Sistema", cVldExc, cVldAlt)

Return