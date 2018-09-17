#INCLUDE 'TOTVS.CH'


User Function MT103FIM()

	Local _nOpcao		:= PARAMIXB[1]	// Opção Escolhida pelo usuario no aRotina
	Local _nConfirma	:= PARAMIXB[2]	// Se o usuario confirmou a operação de gravação da NFE
	Local _aAliOri		:= GetArea()
	Local _aAliSF1		:= SF1->(GetArea())
	Local _nStat		:= 0

	If _nConfirma = 1

//		If FunName() == "AS_XML" .And. _nOpcao = 3 //Incluir
		If _nOpcao = 3 //Incluir
			_nStat := 0
			U_ATUXML(_nStat,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA) //Função do programa AS_XML
		ElseIf FunName() == "MATA103" .And. _nOpcao = 5 //Excluir
			_nStat := 1
			U_ATUXML(_nStat,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA) //Função do programa AS_XML
		Endif

	Endif

	RestArea(_aAliSF1)
	RestArea(_aAliOri)

Return(Nil)