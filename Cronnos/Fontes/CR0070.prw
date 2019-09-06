#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
Programa	:	CR0070
Autor		:	Fabiano da Silva
Data		:	09.02.15
Descrição	:	Importação tabelas em MVC - Rotina Automática
*/

User Function CR0070(  cMaster, aCpoMaster,_cFonte  )

	Local  oModel, oAux, oStruct
	Local  nI        := 0
	Local  nJ        := 0
	Local  nPos      := 0
	Local  lRet      := .T.
	Local  aAux	     := {}
	Local  aC  	     := {}
	Local  aH        := {}
	Local  nItErro   := 0
	Local  lAux      := .T.

	dbSelectArea( cMaster )
	dbSetOrder( 1 )

	//Instacia o Modelo de onde iremos importar as informações
	oModel := FWLoadModel(_cFonte)

	// Temos que definir qual a operação deseja: 3 – Inclusão
	//                      4 – Alteração
	//                      5 - Exclusão
	oModel:SetOperation( 3 )
	// Antes de atribuirmos os valores dos campos temos que ativar o modelo
	oModel:Activate()
	// Instanciamos apenas a parte do modelo referente aos dados de cabeçalho
	oAux    := oModel:GetModel('MODEL_'+_cFonte)

	// Obtemos a estrutura de dados do cabeçalho
	oStruct := oAux:GetStruct()
	aAux	:= oStruct:GetFields()

	If lRet
		For nI := 1 To Len( aCpoMaster )
			// Verifica se os campos passados existem na estrutura do cabeçalho

			If ( nPos := aScan( aAux, { |x| AllTrim( x[3] ) ==  AllTrim( aCpoMaster[nI][1] ) } ) ) > 0

				// È feita a atribuicao do dado aos campo do Model do cabeçalho
				If !( lAux := oModel:SetValue( 'MODEL_'+_cFonte, aCpoMaster[nI][1],aCpoMaster[nI][2] ) )
					// Caso a atribuição não possa ser feita, por algum motivo
					//(validação, por exemplo)
					// o método SetValue retorna .F.
					lRet    := .F.
					Exit
				EndIf
			EndIf
		Next
	EndIf


	If lRet
		// Faz-se a validação dos dados, note que diferentemente das tradicionais "rotinas automáticas"
		// neste momento os dados não são gravados, são somente validados.
		If ( lRet := oModel:VldData() )
			// Se o dados foram validados faz-se a gravação efetiva dos dados (commit)
			oModel:CommitData()
		EndIf
	EndIf

	If !lRet
		// Se os dados não foram validados obtemos a descrição do erro para
		//gerar LOG ou mensagem de aviso
		aErro   := oModel:GetErrorMessage()
		// A estrutura do vetor com erro é:
		//  [1] Id do formulário de origem
		//  [2] Id do campo de origem
		//  [3] Id do formulário de erro
		//  [4] Id do campo de erro
		//  [5] Id do erro
		//  [6] mensagem do erro
		//  [7] mensagem da solução
		//  [8] Valor atribuido
		//  [9] Valor anterior

		AutoGrLog( "Id do formulário de origem:" + ' [' + AllToChar( aErro[1]  ) + ']' )
		AutoGrLog( "Id do campo de origem:     " + ' [' + AllToChar( aErro[2]  ) + ']' )
		AutoGrLog( "Id do formulário de erro:  " + ' [' + AllToChar( aErro[3]  ) + ']' )
		AutoGrLog( "Id do campo de erro:       " + ' [' + AllToChar( aErro[4]  ) + ']' )
		AutoGrLog( "Id do erro:                " + ' [' + AllToChar( aErro[5]  ) + ']' )
		AutoGrLog( "Mensagem do erro:          " + ' [' + AllToChar( aErro[6]  ) + ']' )
		AutoGrLog( "Mensagem da solução:       " + ' [' + AllToChar( aErro[7]  ) + ']' )
		AutoGrLog( "Valor atribuido:           " + ' [' + AllToChar( aErro[8]  ) + ']' )
		AutoGrLog( "Valor anterior:            " + ' [' + AllToChar( aErro[9]  ) + ']' )

		If nItErro > 0
			AutoGrLog( "Erro no Item:   " + ' [' + AllTrim( AllToChar( nItErro  ) ) + ']' )
		EndIf

		MostraErro()

	EndIf

	// Desativamos o Model
	oModel:DeActivate()

Return lRet
