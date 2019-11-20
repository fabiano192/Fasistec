#INCLUDE 'TOTVS.CH'

/*
Ponto de Entrada para gravar o campo Centro de Custo no Contas a Pagar pela rotina de Integração Financeira do Gestão de Pessoal.
*/
User Function GP670ARR()

    Local _aCposUsr := {{'E2_CC' , RC1->RC1_CC,Nil}} 

Return(_aCposUsr)

