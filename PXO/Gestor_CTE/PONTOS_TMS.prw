#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'

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

	_cUPD := " UPDATE "+Retsqlname("DT6")+" SET DT6_YSORIG=DTC_SERNFC " 
	_cUPD += " FROM "+Retsqlname("DT6")+" A INNER JOIN "+Retsqlname("DTC")+" B ON DT6_LOTNFC = DTC_LOTNFC AND DT6_DOC=DTC_DOC AND DT6_SERIE=DTC_SERIE "
	_cUPD += " WHERE A.D_E_L_E_T_='' AND B.D_E_L_E_T_='' "
	
	TCSQLEXEC(_cUPD)

	//_cRet += "AND DT6_DATEMI >= '"+DTOS(dDataBase)+"' "
	
	If Alltrim(FUNNAME()) == "RPC"
		If !U_BRI137B("CTEMBA",6,.F.)
			_cRet += " AND DT6_YSORIG <> '001' "
		Endif

		If !U_BRI137B("CTEMRO",6,.F.)
			_cRet += " AND DT6_YSORIG <> '002' "
		Endif

		If !U_BRI137B("CTEIGU",6,.F.)
			_cRet += " AND DT6_YSORIG <> '006' "
		Endif

		If !U_BRI137B("CTEICC",6,.F.)
			_cRet += " AND DT6_YSORIG <> '007' "
		Endif
	Endif

RETURN (_cRet)