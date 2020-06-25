#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
Programa	: PXH075
Autor		: Fabiano da Silva
Data		: 29/05/15
Descrição	: Aviso de Validade do Orçamento
*/

USER FUNCTION PXH075()

	PREPARE ENVIRONMENT EMPRESA "16" FILIAL "09201"

	CONOUT("Início E-Mail Validade Orçamento")

	_cQuery := " SELECT * FROM "+RETSQLNAME("SCJ")+" CJ "
	_cQuery += " WHERE CJ.D_E_L_E_T_ = '' AND CJ_FILIAL = '"+xFilial('SCJ')+"' "
	_cQuery += " AND CJ_STATUS = 'A' AND CJ_EMISSAO + 15 < '"+Dtos(dDataBase)+"' "

	TCQUERY _cQuery NEW ALIAS "TSCJ"

	TCSETFIELD("TSCJ","CJ_EMISSAO","D")
	TCSETFIELD("TSCJ","CJ_VALIDA","D")

	Count to _nCJ

	If _nCJ > 0

		oProcess := TWFProcess():New( "VALORC", "VALIDADE - ORCAMENTO" )

		oProcess:NewTask( "VALORC", "\WORKFLOW\EMP"+cEmpAnt+"\PXH075.HTM" )
		oProcess:bReturn  := ""
		oProcess:bTimeOut := ""

		oHTML := oProcess:oHTML

		oHtml:ValByName( "empresa" , Alltrim(SM0->M0_NOMECOM) )

		oProcess:cSubject := "Validade Proposta Comercial "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

		TSCJ->(dbGotop())

		While !TSCJ->(EOF())

			If (TSCJ->CJ_CLIENTE+TSCJ->CJ_LOJA <> Alltrim(GetMV('MV_ORCLIPD'))) .Or. Empty(TSCJ->CJ_PROSPE)

				SA1->(DBSETORDER(1))
				SA1->(msSeek(xFilial("SA1")+TSCJ->CJ_CLIENTE+TSCJ->CJ_LOJA))

				_cCliente 	:= SA1->A1_COD+SA1->A1_LOJA
				_cNome		:= Alltrim(SA1->A1_NOME)
			Else
				SUS->(DBSETORDER(1))
				SUS->(msSeek(xFilial("SUS")+TSCJ->CJ_PROSPE+TSCJ->CJ_LOJPRO))

				_cCliente 	:= SUS->US_COD+SUS->US_LOJA
				_cNome		:= Alltrim(SUS->US_NOME)

			Endif

			AADD( (oHtml:ValByName( "it.orc"   		)), TSCJ->CJ_NUM			)
			AADD( (oHtml:ValByName( "it.emissao"   	)), DTOC(TSCJ->CJ_EMISSAO)	)
			AADD( (oHtml:ValByName( "it.valida"    	)), DTOC(TSCJ->CJ_VALIDA)	)
			AADD( (oHtml:ValByName( "it.cliente"   	)), _cCliente				)
			AADD( (oHtml:ValByName( "it.nome"    	)), _cNome					)

			TSCJ->(dbSkip())
		EndDo

		TSCJ->(dbCloseArea())

		Private _cTo := _cCC := ""

		SZ0->(dbsetOrder(1))
		SZ0->(dbGotop())

		While SZ0->(!EOF())

			If 'A1' $ SZ0->Z0_ROTINA
				_cTo += If(Empty(_cTo),ALLTRIM(SZ0->Z0_EMAIL),';'+ALLTRIM(SZ0->Z0_EMAIL))
			ElseIf 'A2' $ SZ0->Z0_ROTINA
				_cCC += If(Empty(_cCC),ALLTRIM(SZ0->Z0_EMAIL),';'+ALLTRIM(SZ0->Z0_EMAIL))
			Endif

			SZ0->(dbSkip())
		Enddo

		oProcess:cTo := _cTo
		oProcess:cCC := _cCC

		oProcess:Start()

		oProcess:Finish()

	Endif

	CONOUT("Fim E-Mail Validade Orçamento")
	
	RESET ENVIRONMENT

RETURN(NIL)