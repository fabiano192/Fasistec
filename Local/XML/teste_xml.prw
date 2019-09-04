#include 'TOTVS.CH'

User Function Teste_XML()

	Local oWsdl
	Local xRet
	Local aOps := {}, aComplex := {}, aSimple := {}
	Local cURL		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cIdEnt	:= RetIdEnti()

	If ReadyTSS()

	Endif

	// Cria o objeto da classe TWsdlManager
	oWsdl := TWsdlManager():New()

	// Faz o parse de uma URL
	xRet := oWsdl:ParseURL( "https://www.nfe.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx?WSDL" )
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	endif

	aOps := oWsdl:ListOperations()

	if Len( aOps ) == 0
		conout( "Erro: " + oWsdl:cError )
		Return
	endif

	varinfo( "", aOps )

	// Define a operação
	xRet := oWsdl:SetOperation( "GetCityForecastByZIP" )
	//xRet := oWsdl:SetOperation( aOps[1][1] )
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	endif

	aComplex := oWsdl:NextComplex()
	varinfo( "", aComplex )

	aSimple := oWsdl:SimpleInput()
	varinfo( "", aSimple )

	// Define o valor de cada parâmeto necessário
	xRet := oWsdl:SetValue( 0, "90210" )
	//xRet := oWsdl:SetValue( aSimple[1][1], "90210" )
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	endif

	// Exibe a mensagem que será enviada
	conout( oWsdl:GetSoapMsg() )

	// Envia a mensagem SOAP ao servidor
	xRet := oWsdl:SendSoapMsg()
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	endif

	// Pega a mensagem de resposta
	conout( oWsdl:GetSoapResponse() )

	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	endif
Return

Static Function ReadyTSS(cURL,nTipo,lHelp)
	Return (CTIsReady(cURL,nTipo,lHelp,.F.))
