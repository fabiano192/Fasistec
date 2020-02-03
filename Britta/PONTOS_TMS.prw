#INCLUDE 'TOTVS.CH'

/*
Ponto de Entrada:	TME70CAB
Descrição:			Permite Incluir novos títulos no cabeçalho do monitor CTe. Obs: Este PE complementa o PE TME70CPO
URL:				https://tdn.totvs.com.br/pages/releaseview.action?pageId=73076947
*/
User Function TME70CAB()

	Local _aRetPE := {}

	aAdd(_aRetPE, "Origem" )

Return( _aRetPE )



/*
Ponto de Entrada:	TME70CAB
Descrição:			Permite Incluir novos títulos no cabeçalho do monitor CTe. Obs: Este PE complementa o PE TME70CPO
URL:				https://tdn.totvs.com.br/display/public/PROT/TME70CPO+-+Campos+Monitor+CTE
*/
User Function TME70CPO()

	Local _aRetPE := {}

	aAdd(_aRetPE,DT6->DT6_YSORIG )
	// aAdd(_aRetPE,Posicione("DTC",1,xFilial("DTC")+cFilAnt+DT6->DT6_LOTNFC,"DTC_SERNFC") )
	// aAdd(_aRetPE, DT6->DT6_PROCTE )

Return( _aRetPE )



/*
Ponto de Entrada:	TME70QRY
Descrição:			PE criado para filtrar os CT-e's que devem aparecer.
URL:				https://tdninterno.totvs.com/display/public/PROT/TME70QRY
*/
User Function TME70QRY()

	Local _cRet	:= ""

	If !u_ChkAcesso("CTEMBA",6,.F.)
		_cRet += " AND DT6_YSORIG <> '001' "
	Endif

	If !u_ChkAcesso("CTEMRO",6,.F.)
		_cRet += " AND DT6_YSORIG <> '002' "
	Endif

	If !u_ChkAcesso("CTEIGU",6,.F.)
		_cRet += " AND DT6_YSORIG <> '006' "
	Endif

	If !u_ChkAcesso("CTEICC",6,.F.)
		_cRet += " AND DT6_YSORIG <> '007' "
	Endif
	
	// _cRet += " AND DT6_YSORIG <> '002' "
	// _cRet += " AND DT6_YSORIG <> '006' "

RETURN (_cRet)