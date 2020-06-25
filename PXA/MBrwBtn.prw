#INCLUDE 'TOTVS.CH'

User Function MBrwBtn()

	LOCAL lREt:=.T.
	
	If ParamIxb[3] = 9 .AND. Upper(FunName()) = 'MATA410'
		_cFunName := 'MTA410NF'
	Else
		_cFunName := FunName()
	Endif
	
	ZZZ->(dbsetOrder(1))
	If ZZZ->(msSeek(xFilial('ZZZ')+_cFunName))
		lRet:= u_PXH042(_cFunName, ParamIxb[3], .T.)  //Verifica se a rotina tem controle de acesso
	Endif

RETURN lREt