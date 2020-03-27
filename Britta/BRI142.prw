#INCLUDE "TOTVS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE 'TOPCONN.CH'


/*/{Protheus.doc} BRI142
//Relatório de Avisos do RH
@author Fabiano
@since 19/03/2020
/*/
User Function BRI142(_aParam)

	Local F	:= 0

	Private _aMens	:= {}

	If ValType(_aParam) <> 'U'
		PREPARE ENVIRONMENT EMPRESA _aParam[1] FILIAL _aParam[2]
	Endif

	Private _cTo := SuperGetMV("BRI_AVISRH",,"")

	If Empty(_cTo)
		// Return(Nil)
	Endif


	Conout('Iniciando BRI142 - '+Alltrim(cEmpAnt)+Alltrim(cFilAnt))

	Conout('Inicio Afastamento BRI142')
	Afasta()
	Conout('Fim Afastamento BRI142')

	Conout('Início Férias BRI142')
	Ferias()
	Conout('Fim Férias BRI142')

	Conout('Início Experiência BRI142')
	Experi()
	Conout('Fim Experiência BRI142')


	If !Empty(_aMens)
		Conout('Início Envio de e-mail BRI142')
		_oProcess		:= TWFProcess():New( "000001", "Envio de WorkFlow Avisos RH" )
		_oProcess:NewTask( "Envio de WorkFlow Avisos RH", "/workflow/BRI142.htm" )
		_oProcess:cSubject := 'Avisos RH '+dtoc(dDataBase)+' - '+Alltrim(SM0->M0_FILIAL)
		_oProcess:NewVersion (.T.)
		_oHtml     	 		:= _oProcess:oHtml

		_oHtml:ValByName( "dthoje"	, dtoc(dDataBase))
		_oHtml:ValByName( "filial"	, SM0->M0_FILIAL)
		_oHtml:ValByName( "emp"		, SM0->M0_NOMECOM)

		For F := 1 to Len(_aMens)
			AAdd( (_oHtml:ValByName( "it.Msg"  )), _aMens[F][1])
			If _aMens[F][2] = 1
				AAdd( (_oHtml:ValByName( "it.cor"  )), "color: rgb(255, 0, 0);")
			ElseIf _aMens[F][2] = 2
				AAdd( (_oHtml:ValByName( "it.cor"  )), "color: rgb(25, 25, 112);")
			Else
				AAdd( (_oHtml:ValByName( "it.cor"  )), "color: rgb(0, 0, 0);")
			Endif
		Next F


		_cTo := _cCC := ""
/*
		SZI->(dbsetOrder(1))
		SZI->(dbGotop())

		While SZI->(!EOF())

			If SZI->ZI_FILIAL <>  xFilial("SZI")
				SZI->(dbSkip())
				Loop
			Endif

			If 'A1' $ SZI->ZI_ROTINA
				_cTo += If(Empty(_cTo),ALLTRIM(SZI->ZI_EMAIL),';'+ALLTRIM(SZI->ZI_EMAIL))
			ElseIf 'A2' $ SZI->ZI_ROTINA
				_cCC += If(Empty(_cCC),ALLTRIM(SZI->ZI_EMAIL),';'+ALLTRIM(SZI->ZI_EMAIL))
			Endif

			SZI->(dbSkip())
		Enddo
*/

		_oProcess:cTo := 'fabiano@fasistec.com.br'
		// _oProcess:cTo := _cTo
		// _oProcess:cCC := _cCC

		_oProcess:Start()  // Cria o processo e gravo o ID do processo de Workflow
		_oProcess:Finish() // FINALIZA O PROCESSO

	Endif

	Conout('Fim BRI142 - '+Alltrim(cEmpAnt)+Alltrim(cFilAnt))

Return(Nil)



Static Function Afasta()

	Local _aAfas	:= {}
	Local F			:= 0
	Local _cQrySR8	:= ""

	If Select("TSR8") > 0
		TSR8->(dbCloseArea())
	Endif

	_cQrySR8 += " SELECT R8_DATAINI,R8_DATAFIM,R8_MAT,R8_TIPOAFA,RA_NOME FROM "+RetSqlName("SR8")+" R8 " +CRLF
	_cQrySR8 += " INNER JOIN "+RetSqlName("SRA")+" RA ON R8_MAT = RA_MAT " +CRLF
	_cQrySR8 += " WHERE R8.D_E_L_E_T_ = '' AND R8_FILIAL = '"+xFilial("SR8")+"' " +CRLF
	_cQrySR8 += " AND RA.D_E_L_E_T_ = '' AND RA_FILIAL = '"+xFilial("SRA")+"' " +CRLF
	_cQrySR8 += " AND R8_TIPOAFA <> '001' " +CRLF
	_cQrySR8 += " ORDER BY R8_MAT, R8_DATA " +CRLF

	TcQuery _cQrySR8 New Alias "TSR8"

	If Contar("TSR8","!EOF()") > 0

		TcSetField("TSR8","R8_DATAFIM","D")
		TcSetField("TSR8","R8_DATAINI","D")

		TSR8->(dbGotop())

		While !TSR8->(EOF())

			If Empty(TSR8->R8_DATAFIM) .Or. (TSR8->R8_DATAFIM-dDatabase <= 30 .And. TSR8->R8_DATAFIM-dDatabase >= 0)

				cMotAf	:= Alltrim(POSICIONE("RCM",1,XFILIAL("RCM")+TSR8->R8_TIPOAFA,"RCM_DESCRI"))

				If Empty(TSR8->R8_DATAFIM)
					_cMsg := " - Afastamento a partir de "+dToc(TSR8->R8_DATAINI)
				Else
					_cMsg := " - Afastamento até "+DToC(TSR8->R8_DATAFIM)+" - Retorno em: "+DToC(TSR8->R8_DATAFIM+1)
				Endif
				AAdd(_aAfas,{Capital(Alltrim(cMotAf)),TSR8->R8_MAT+" - "+ALLTRIM(Capital(TSR8->RA_NOME))+_cMsg})
			EndIf

			TSR8->(dbSkip())
		EndDo

		If !Empty(_aAfas)
			AAdd(_aMens,{"Afastamentos",1})
			AAdd(_aMens,{"",0})

			_aAfas := ASORT(_aAfas,,,{ | x,y | y[1] > x[1] })

			_cAfast := ''
			For F := 1 To Len(_aAfas)
				If _cAfast <> _aAfas[F][1]
					AAdd(_aMens,{_aAfas[F][1],2})
				Endif
				AAdd(_aMens,{_aAfas[F][2],0})
				_cAfast := _aAfas[F][1]
			Next F
		Endif
	Endif

	TSR8->(dbCloseArea())

Return(Nil)



Static Function Ferias()

	Local _cQuery := ''

	If Select('TSRF') > 0
		TSRF->(dbCloseArea())
	Endif

	_cQuery += " SELECT * FROM ( " + CRLF
	_cQuery += " select RF.RF_MAT AS MAT,RA_NOME AS NOME,SUM(RF_DFERVAT+RF_DFERAAT) AS TOTAL, RF2.DTBASE AS DTBASE from "+RetSqlName("SRF")+" RF " + CRLF
	_cQuery += " INNER JOIN  " + CRLF
	_cQuery += " ( " + CRLF
	_cQuery += " SELECT RF_MAT,MIN(RF_DATABAS) AS DTBASE FROM "+RetSqlName("SRF")+" RF3  " + CRLF
	_cQuery += " WHERE RF3.D_E_L_E_T_ = '' AND RF3.RF_FILIAL = '"+xFilial("SRF")+"' AND RF3.RF_STATUS ='1' AND RF3.RF_MAT = RF_MAT " + CRLF
	_cQuery += " GROUP BY RF_MAT " + CRLF
	_cQuery += " ) " + CRLF
	_cQuery += " RF2 ON RF2.RF_MAT = RF.RF_MAT " + CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SRA")+" RA ON RA_MAT = RF.RF_MAT " + CRLF
	_cQuery += " WHERE RF.D_E_L_E_T_ = '' AND RA.D_E_L_E_T_ = '' " + CRLF
	_cQuery += " AND RF_FILIAL =  '"+xFilial("SRF")+"' AND RA_FILIAL =  '"+xFilial("SRA")+"' " + CRLF
	_cQuery += " AND RA_SITFOLH <> 'D' " + CRLF
	_cQuery += " AND RA_DEMISSA = '' " + CRLF
	_cQuery += " AND RA_CATFUNC <> 'A' " + CRLF
	_cQuery += " AND RF_STATUS ='1' " + CRLF
	_cQuery += " GROUP BY RF.RF_MAT,RA_NOME,RF2.DTBASE " + CRLF
	_cQuery += " ) A " + CRLF
	_cQuery += " WHERE A.TOTAL >= 52.5 " + CRLF
	_cQuery += " ORDER BY A.MAT " + CRLF

	TcQuery _cQuery New Alias "TSRF"

	Conout("BRI142 - _cQuery: "+_cQuery)

	Count to _nTSRF

	If _nTSRF > 0
		AAdd(_aMens,{"",0})
		AAdd(_aMens,{"Verificar Período de Férias",1})
		AAdd(_aMens,{"",0})

		TcSetfield("TSRF","DTBASE","D")

		TSRF->(dbGoTop())

		While TSRF->(!EOF())

			AAdd(_aMens,{TSRF->MAT+" - "+Capital(TSRF->NOME)+" - Data base: "+dtoc(TSRF->DTBASE)+" - Dias Direito: "+CVALTOCHAR(TSRF->TOTAL),0})

			TSRF->(dbSkip())
		ENDDO
	ENDIF

	TSRF->(dbCloseArea())

Return(Nil)



Static Function Experi()

	Local _lEnt		:= .F.
	Local _cQrySRA	:= ""

	If Select('TSRA') > 0
		TSRA->(dbCloseArea())
	Endif

	_cQrySRA += " SELECT RA_MAT,RA_NOME,RA_VCTOEXP FROM "+RetSqlName("SRA")+" RA " + CRLF
	_cQrySRA += " WHERE RA.D_E_L_E_T_ = '' AND RA_FILIAL = '"+xFilial("SRA")+"' " + CRLF
	_cQrySRA += " AND RA_SITFOLH NOT IN ('D','A') " + CRLF
	_cQrySRA += " AND RA_CATFUNC <> 'E' " + CRLF
	_cQrySRA += " AND RA_VCTEXP2 = '' " + CRLF
	_cQrySRA += " ORDER BY RA_MAT " + CRLF

	TcQuery _cQrySRA New Alias "TSRA"

	If Contar("TSRA","!EOF()") > 0

		TcSetField("TSRA","RA_VCTOEXP","D")

		TSRA->(dbGotop())

		While !TSRA->(EOF())

			// If (SRA->RA_SITFOLH $ "D|A") .Or. SRA->RA_CATFUNC = "E" .Or. !Empty(SRA->RA_VCTEXP2)
			// 	SRA->(dbSkip())
			// 	Loop
			// Endif

			_lOk := .F.
			If (Month(TSRA->RA_VCTOEXP) = Month(dDataBase) .And. Year(TSRA->RA_VCTOEXP) = Year(dDataBase))
				_lOk := .T.
			Endif

			If (Month(TSRA->RA_VCTOEXP) = (Month(dDataBase)+1) .And. Year(TSRA->RA_VCTOEXP) = Year(dDataBase))
				_lOk := .T.
			Endif

			If (Month(TSRA->RA_VCTOEXP) = 1 .And. Month(dDataBase) = 12 .And. (Year(TSRA->RA_VCTOEXP)-1) = Year(dDataBase))
				_lOk := .T.
			Endif

			If _lOk

				If !_lEnt
					AAdd(_aMens,{"",0})
					AAdd(_aMens,{"1º Período de Experiência",1})
					AAdd(_aMens,{"",0})
				Endif

				_lEnt := .T.

				AAdd(_aMens,{TSRA->RA_MAT+" - "+ALLTRIM(Capital(TSRA->RA_NOME))+" "+dtoc(TSRA->RA_VCTOEXP),0})
			EndIf

			TSRA->(dbSkip())
		EndDo

	Endif

	TSRA->(dbCloseArea())



	_cQrySRA	:= ""

	If Select('TSRA') > 0
		TSRA->(dbCloseArea())
	Endif

	_cQrySRA += " SELECT RA_MAT,RA_NOME,RA_VCTEXP2 FROM "+RetSqlName("SRA")+" RA " + CRLF
	_cQrySRA += " WHERE RA.D_E_L_E_T_ = '' AND RA_FILIAL = '"+xFilial("SRA")+"' " + CRLF
	_cQrySRA += " AND RA_SITFOLH NOT IN ('D','A') " + CRLF
	_cQrySRA += " AND RA_CATFUNC <> 'E' " + CRLF
	_cQrySRA += " ORDER BY RA_MAT " + CRLF

	TcQuery _cQrySRA New Alias "TSRA"

	If Contar("TSRA","!EOF()") > 0

		TcSetField("TSRA","RA_VCTEXP2","D")

		TSRA->(dbGotop())

		_lEnt := .F.


		While !TSRA->(EOF())

			// If (SRA->RA_SITFOLH $ "D|A") .Or. SRA->RA_CATFUNC = "E"
			// 	SRA->(dbSkip())
			// 	Loop
			// Endif

			_lOk := .F.
			If (Month(TSRA->RA_VCTEXP2) = Month(dDataBase) .And. Year(TSRA->RA_VCTEXP2) = Year(dDataBase))
				_lOk := .T.
			Endif

			If (Month(TSRA->RA_VCTEXP2) = (Month(dDataBase)+1) .And. Year(TSRA->RA_VCTEXP2) = Year(dDataBase))
				_lOk := .T.
			Endif

			If (Month(TSRA->RA_VCTEXP2) = 1 .And. Month(dDataBase) = 12 .And. (Year(TSRA->RA_VCTEXP2)-1) = Year(dDataBase))
				_lOk := .T.
			Endif

			If _lOk
				If !_lEnt
					AAdd(_aMens,{"",0})
					AAdd(_aMens,{"2º Período de Experiência",1})
					AAdd(_aMens,{"",0})
				Endif

				_lEnt := .T.

				AAdd(_aMens,{TSRA->RA_MAT+" - "+ALLTRIM(Capital(TSRA->RA_NOME))+" "+dtoc(TSRA->RA_VCTEXP2),0})
			EndIf

			TSRA->(dbSkip())
		EndDo

	Endif

	TSRA->(dbCloseArea())

Return(Nil)