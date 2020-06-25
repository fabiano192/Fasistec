#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
Programa	: PXH078
Autor		: Fabiano da Silva
Data		: 12/06/15
Descrição	: Bloqueio de Clientes conforme Limite de Crédito
*/

USER FUNCTION PXH078()

	PREPARE ENVIRONMENT EMPRESA "16" FILIAL "09201"

	CONOUT("Início E-Mail Bloqueio Clientes")

	_cQuery := " SELECT * FROM "+RETSQLNAME("SA1")+" A1 "
	_cQuery += " WHERE A1.D_E_L_E_T_ = '' AND A1_FILIAL = '"+xFilial('SA1')+"' "
	_cQuery += " AND A1_LC > 0 "
	_cQuery += " AND (A1_VENCLC < '"+Dtos(dDataBase)+"' OR A1_MSBLQL = '1') "

	TCQUERY _cQuery NEW ALIAS "TSA1"

	TCSETFIELD("TSA1","A1_VENCLC","D")

	Count to _nA1

	If _nA1 > 0

		oProcess := TWFProcess():New( "BLQCLI", "BLOQUEIO CLIENTES" )

		oProcess:NewTask( "BLQCLI", "\WORKFLOW\EMP"+cEmpAnt+"\PXH078.HTM" )
		oProcess:bReturn  := ""
		oProcess:bTimeOut := ""

		oHTML := oProcess:oHTML

		oHtml:ValByName( "empresa" , Alltrim(SM0->M0_NOMECOM) )

		oProcess:cSubject := "Bloqueio Clientes: "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

		TSA1->(dbGotop())

		While !TSA1->(EOF())

			_cCliente 	:= TSA1->A1_COD+TSA1->A1_LOJA
			_cNome		:= Alltrim(TSA1->A1_NOME)

			AADD( (oHtml:ValByName( "it.cliente"   	)), _cCliente				)
			AADD( (oHtml:ValByName( "it.nome"    	)), _cNome					)
			AADD( (oHtml:ValByName( "it.lc"   		)), TRANSFORM(TSA1->A1_LC,'@E 999,999.99' ) )
			AADD( (oHtml:ValByName( "it.dtlc"   	)), DTOC(TSA1->A1_VENCLC)	)

			If TSA1->A1_MSBLQL <> '1'
				SA1->(dbSetOrder(1))
				If SA1->(msSeek(xFilial('SA1')+TSA1->A1_COD+TSA1->A1_LOJA))
					SA1->(RECLOCK('SA1',.F.))
					SA1->A1_MSBLQL := '1'
					SA1->(MSUNLOCK())
				Endif	
			Endif

			TSA1->(dbSkip())
		EndDo

		TSA1->(dbCloseArea())

		Private _cTo := _cCC := ""

		SZ0->(dbsetOrder(1))
		SZ0->(dbGotop())

		While SZ0->(!EOF())

			If 'B1' $ SZ0->Z0_ROTINA
				_cTo += If(Empty(_cTo),ALLTRIM(SZ0->Z0_EMAIL),';'+ALLTRIM(SZ0->Z0_EMAIL))
			ElseIf 'B2' $ SZ0->Z0_ROTINA
				_cCC += If(Empty(_cCC),ALLTRIM(SZ0->Z0_EMAIL),';'+ALLTRIM(SZ0->Z0_EMAIL))
			Endif

			SZ0->(dbSkip())
		Enddo

		oProcess:cTo := _cTo
		oProcess:cCC := _cCC

		oProcess:Start()

		oProcess:Finish()

	Endif

	CONOUT("Fim E-Mail Bloqueio Clientes")

	RESET ENVIRONMENT

RETURN(NIL)