#INCLUDE "TOTVS.ch"
#INCLUDE "TOPCONN.ch"
#INCLUDE "TBICONN.CH"

/*/
Funçao    	³ 	CR0065
Autor 		³ 	Fabiano da Silva
Data 		³ 	10.09.14
Descricao 	³ 	Workfow para solicitação de Embalagens Caterpillar
/*/

User Function CR0065()

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
	
	ConOut("Enviando E-Mail de Ponto de Pedidos de Embalagens - CR0065")

/*
	_cQuery := " SELECT B1_COD,B1_EMIN,Z2_CODCLI,Z2_DESCCLI,B2_QATU FROM "+RetSqlName('SB1')+" B1 "
	_cQuery += " INNER JOIN "+RetSqlName('SB2')+" B2 ON B1_COD = B2_COD AND B1_LOCPAD = B2_LOCAL "
	_cQuery += " INNER JOIN "+RetSqlName('SZ2')+" Z2 ON B1_COD = Z2_PRODUTO AND Z2_CLIENTE = '000017' "
	_cQuery += " WHERE B1.D_E_L_E_T_ = '' AND B2.D_E_L_E_T_ = '' AND Z2.D_E_L_E_T_ = ''  "
	_cQuery += " AND B1_TIPO = 'EM' AND B1_EMIN > 0 "
	_cQuery += " AND B2_QATU < B1_EMIN "
	*/
	_cQuery := " SELECT B6_CLIFOR,B6_LOJA,B6_PRODUTO,B6_TIPO,Z2_DESCCLI,B1_EMIN,Z2_CODCLI,SUM(B6_SALDO) AS SALDO FROM "+RetSqlName('SB6')+" B6 " 
	_cQuery += " INNER JOIN "+RetSqlName('SB1')+" B1 ON B1_COD = B6_PRODUTO "
	_cQuery += " INNER JOIN "+RetSqlName('SZ2')+" Z2 ON B1_COD = Z2_PRODUTO AND Z2_CLIENTE = '000017' "
	_cQuery += " WHERE B1.D_E_L_E_T_ = '' AND B6.D_E_L_E_T_ = '' AND Z2.D_E_L_E_T_ = ''  "
	_cQuery += " AND B6_CLIFOR = '000017' AND B1_TIPO = 'EM' AND B1_EMIN > 0 " 
	_cQuery += " AND B6_SALDO > 0 "
	_cQuery += " AND B6_TPCF = 'C' AND B6_TIPO = 'D' AND B6_PODER3 = 'R' "
	_cQuery += " GROUP BY B6_CLIFOR,B6_LOJA,B6_PRODUTO,B6_TIPO,Z2_DESCCLI,B1_EMIN,Z2_CODCLI "
	_cQuery += " ORDER BY B6_CLIFOR,B6_LOJA,B6_PRODUTO "
	
	TCQUERY _cQuery NEW Alias "TSB6"
	
	Count to _nRec
	
	If _nRec > 0

		oProcess := TWFProcess():New( "CR0065", "Estoque" )
		oProcess:NewTask( "CR0065", "\WORKFLOW\CR0065.htm" )
		oHTML := oProcess:oHTML

		oProcess:fDesc := "Estoque de Embalagens"

		_cSubject := "Estoque de Embalagens Caterpillar"

		oProcess:cSubject := _cSubject

		TSB6->(dbGoTop())

		While TSB6->(!Eof())

			If TSB6->B1_EMIN > TSB6->SALDO
				AADD( (oHtml:ValByName( "it.codcro"   )), TSB6->B6_PRODUTO)
				AADD( (oHtml:ValByName( "it.codcat"   )), TSB6->Z2_CODCLI)
				AADD( (oHtml:ValByName( "it.clilj"    )), TSB6->B6_CLIFOR+'-'+TSB6->B6_LOJA)
				AADD( (oHtml:ValByName( "it.descri"   )), TSB6->Z2_DESCCLI)
				AADD( (oHtml:ValByName( "it.ponto"    )), TSB6->B1_EMIN)
				AADD( (oHtml:ValByName( "it.estoque"  )), TSB6->SALDO)
			Endif
			
			TSB6->(dbSkip())
		EndDo

		Private _cTo := _cCC := ""
				
		SZG->(dbsetOrder(1))
		SZG->(dbGotop())
	
		While SZG->(!EOF())
	
			If 'H1' $ SZG->ZG_ROTINA
				_cTo += If(Empty(_cTo),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
			ElseIf 'H2' $ SZG->ZG_ROTINA
				_cCC += If(Empty(_cCC),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
			Endif
	
			SZG->(dbSkip())
		Enddo
	
		oProcess:cTo := _cTo
		oProcess:cCC := _cCC

		oProcess:Start()

		oProcess:Finish()

		ConOut("Fim E-Mail de Ponto de Pedidos de Embalagens - CR0065")
	Else
		Conout('Não existem embalagens com saldo inferior ao Ponto de Pedido!')
	Endif
	
	TSB6->(dbCloseArea())
	
Return
