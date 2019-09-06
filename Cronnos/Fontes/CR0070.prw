#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
Programa	:	CR0070
Autor		:	Fabiano da Silva
Data		:	09.02.15
Descri��o	:	Importa��o tabelas em MVC - Rotina Autom�tica
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

	//Instacia o Modelo de onde iremos importar as informa��es
	oModel := FWLoadModel(_cFonte)

	// Temos que definir qual a opera��o deseja: 3 � Inclus�o
	//                      4 � Altera��o
	//                      5 - Exclus�o
	oModel:SetOperation( 3 )
	// Antes de atribuirmos os valores dos campos temos que ativar o modelo
	oModel:Activate()
	// Instanciamos apenas a parte do modelo referente aos dados de cabe�alho
	oAux    := oModel:GetModel('MODEL_'+_cFonte)

	// Obtemos a estrutura de dados do cabe�alho
	oStruct := oAux:GetStruct()
	aAux	:= oStruct:GetFields()

	If lRet
		For nI := 1 To Len( aCpoMaster )
			// Verifica se os campos passados existem na estrutura do cabe�alho

			If ( nPos := aScan( aAux, { |x| AllTrim( x[3] ) ==  AllTrim( aCpoMaster[nI][1] ) } ) ) > 0

				// � feita a atribuicao do dado aos campo do Model do cabe�alho
				If !( lAux := oModel:SetValue( 'MODEL_'+_cFonte, aCpoMaster[nI][1],aCpoMaster[nI][2] ) )
					// Caso a atribui��o n�o possa ser feita, por algum motivo
					//(valida��o, por exemplo)
					// o m�todo SetValue retorna .F.
					lRet    := .F.
					Exit
				EndIf
			EndIf
		Next
	EndIf


	If lRet
		// Faz-se a valida��o dos dados, note que diferentemente das tradicionais "rotinas autom�ticas"
		// neste momento os dados n�o s�o gravados, s�o somente validados.
		If ( lRet := oModel:VldData() )
			// Se o dados foram validados faz-se a grava��o efetiva dos dados (commit)
			oModel:CommitData()
		EndIf
	EndIf

	If !lRet
		// Se os dados n�o foram validados obtemos a descri��o do erro para
		//gerar LOG ou mensagem de aviso
		aErro   := oModel:GetErrorMessage()
		// A estrutura do vetor com erro �:
		//  [1] Id do formul�rio de origem
		//  [2] Id do campo de origem
		//  [3] Id do formul�rio de erro
		//  [4] Id do campo de erro
		//  [5] Id do erro
		//  [6] mensagem do erro
		//  [7] mensagem da solu��o
		//  [8] Valor atribuido
		//  [9] Valor anterior

		AutoGrLog( "Id do formul�rio de origem:" + ' [' + AllToChar( aErro[1]  ) + ']' )
		AutoGrLog( "Id do campo de origem:     " + ' [' + AllToChar( aErro[2]  ) + ']' )
		AutoGrLog( "Id do formul�rio de erro:  " + ' [' + AllToChar( aErro[3]  ) + ']' )
		AutoGrLog( "Id do campo de erro:       " + ' [' + AllToChar( aErro[4]  ) + ']' )
		AutoGrLog( "Id do erro:                " + ' [' + AllToChar( aErro[5]  ) + ']' )
		AutoGrLog( "Mensagem do erro:          " + ' [' + AllToChar( aErro[6]  ) + ']' )
		AutoGrLog( "Mensagem da solu��o:       " + ' [' + AllToChar( aErro[7]  ) + ']' )
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
