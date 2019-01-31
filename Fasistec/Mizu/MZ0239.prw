#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} MZ0239
//Função para gerar Consulta Padrão ("F3") específica com o conteúdo da tabela genéria (SX5)
@author Fabiano
@since 14/11/2018
/*/
User Function MZ0239(_cTable,_cTitle,_l1Elem)

	Local _cVar
	Local _cVarDef	:= ""
	Local _cAlias	:= Alias() // Salva Alias Anterior

	Private _aTipo	:= {}

	Default _cTitle	:= ""		//O titulo não é obrigatório pois pode ser pegar o titulo da tabela SX5
	Default _l1Elem := .F.

	_cVar		:= &(Alltrim(ReadVar()))	// Carrega Nome da Variavel do Get em Questao
	_cVarRet	:= Alltrim(ReadVar())		// Iguala Nome da Variavel ao Nome variavel de Retorno

	If SX5->(MsSeek(xFilial("SX5")+"00"+_cTable))
		_cTitle := Alltrim(Left(X5Descri(),20))
	Endif

	If SX5->(MsSeek(xFilial("SX5")+_cTable))

		CursorWait()
		_aTipo := {}

		While SX5->(!Eof()) .AND. SX5->X5_FILIAL == XFilial("SX5") .AND. SX5->X5_Tabela == _cTable

			Aadd(_aTipo,Alltrim(X5Descri()))

			_cVarDef += Left(SX5->X5_Chave,2)

			SX5->(dbSkip())
		Enddo
		CursorArrow()
	Endif

	IF f_Opcoes(@_cVar,_cTitle,_aTipo,_cVarDef,12,49,_l1Elem,2,28)  // Chama funcao f_Opcoes (padrão Protheus)
		&_cVarRet := _cVar										 // Devolve Resultado
	EndIF

	VAR_IXB := &_cVarRet //variável de retorno da consulta padrão (SXB)

	dbSelectArea(_cAlias) // Retorna Alias

Return(.T.)