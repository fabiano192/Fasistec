#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
AUTOR		: FABIANO DA SILVA
DESCRIÇÃO	: Envio de e-mail à Clientes referente aos vencimentos dos títulos
DATA		: 11/09/19
*/

USER FUNCTION BRI133(_aParam)

	Local _oWF		:= Nil
	Local _cQuery	:= ''
	Local _cQ		:= ''
	Local _dData	:= cTod('')

	If ValType( _aParam ) <> "U"
		PREPARE ENVIRONMENT EMPRESA _aParam[1] FILIAL _aParam[2]
	Endif

	Conout("BRI133 "+cEmpAnt + cFilAnt +"- Início de envio de e-mail")

	_dData	:= CheckData()

	Conout("BRI133 "+cEmpAnt + cFilAnt +"- Data: "+dToc(_dData))

	If Select("ZE1") > 0
		ZE1->(dbCloseArea())
	Endif

	_cQuery := " SELECT SE1.R_E_C_N_O_ AS E1RECNO,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_EMISSAO,E1_VENCREA,A1_EMAIL,A1_NOME,E1_SALDO FROM "+RETSQLNAME("SE1")+" SE1 (NOLOCK) " +CRLF
	_cQuery += " INNER JOIN "+RETSQLNAME("SA1")+" SA1 (NOLOCK) ON A1_COD+A1_LOJA = E1_CLIENTE+E1_LOJA " +CRLF
	_cQuery += " WHERE SE1.D_E_L_E_T_ = '' AND SA1.D_E_L_E_T_ = '' AND E1_SALDO > 0 " +CRLF
	// _cQuery += " AND E1_VENCREA <= '"+DTOS(_dData)+"' " +CRLF
	_cQuery += " AND E1_TIPO NOT IN ('NCC','AB-','RA ') " +CRLF
	_cQuery += " AND A1_EMAIL <> '' " +CRLF
	_cQuery += " AND A1_COD = '016791' " +CRLF
	// _cQuery += " AND A1_XMAILFI = 'S' " +CRLF
	// _cQuery += " AND E1_XHRMAIL = '' " +CRLF
	_cQuery += " ORDER BY E1_FILIAL,E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM " +CRLF

//	Memowrite("D:\BRI133.txt",_cQuery)
	
	TCQUERY _cQuery NEW ALIAS "ZE1"

	TCSETFIELD("ZE1","E1_EMISSAO" ,"D")
	TCSETFIELD("ZE1","E1_VENCREA" ,"D")

	While ZE1->(!EOF())

		_oWF := TWFProcess():New( "Aviso", "Aviso de Vencimento" )

		_oWF:NewTask( "Aviso", "\workflow\BRI133.htm" )

		_oWF:oHtml:ValByName("NOME"		, ZE1->A1_NOME		)
		_oWF:oHtml:ValByName("PREFIXO"	, ZE1->E1_PREFIXO	)
		_oWF:oHtml:ValByName("NUMERO"	, ZE1->E1_NUM		)
		_oWF:oHtml:ValByName("PARCELA"	, ZE1->E1_PARCELA	)
		_oWF:oHtml:ValByName("EMISSAO"	, Dtoc(ZE1->E1_EMISSAO))
		_oWF:oHtml:ValByName("VENCTO"	, Dtoc(ZE1->E1_VENCREA))
		_oWF:oHtml:ValByName("VALOR"	, Alltrim(Transform(ZE1->E1_SALDO,"@e 999,999,999.99")))
		_oWF:oHtml:ValByName("EMPRESA"	, Alltrim(SM0->M0_NOMECOM))

		_oWF:cTo := 'fabiano192@yahoo.com.br'
		// _oWF:cTo := Alltrim(ZE1->A1_EMAIL)

		_oWF:cSubject := "Aviso de vencimento de boleto"

		_oWF:Start() 

		// _nRECNO := ZE1->E1RECNO
		// _cHrMai := dToc(dDataBase)+ ' - ' + Left(Time(),5)

		// _cQ := " UPDATE "+RETSQLNAME("SE1")+" SET E1_XHRMAIL = '"+_cHrMai+"' " +CRLF
		// _cQ += " WHERE R_E_C_N_O_ = "+cValToChar(_nRECNO)+" " +CRLF

		// TcSQLExec(_cQ)

		SLEEP(1000) //Aguardar 1 segundo

		ZE1->(dbskip())
	EndDo

	ZE1->(dbCloseArea())
	
	Conout("BRI133 "+cEmpAnt + cFilAnt +"- Fim de envio de e-mail")

Return (Nil)



Static Function CheckData()

	Local _nDias	:= 7
	Local _dData	:= dDataBase + _nDias
	// Local _lNext	:= .T.
	// Local _dNewData	:= dDataBase

	// For _n := 1 To _nDias
		
	// 	_dNewData := DataValida(_dData+1, _lNext)
		
	// 	_dData := _dNewData

	// Next _n

Return(_dData)
