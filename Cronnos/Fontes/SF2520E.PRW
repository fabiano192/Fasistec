#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
Funçao    	³ SF2520E - Ponto de Entrada para envio de em-ail para CQ de NF excluída
Autor 		³ Fabiano da Silva
Data 		³ 03.12.18
*/

User Function SF2520E()

	_aAliori := GetArea()

	If SF2->F2_TIPO = 'N'
		SA1->(dbSetOrder(1))
		If SA1->(MsSeek(xFilial("SA1")+SF2->CLIENTE + SF2->F2_LOJA))
			If SA1->A1_XCERTIF = 'S'
				GERATRB(2)
			Endif
		Endif
	Endif

	RestArea(_aAliori)

Return

Static Function GeraTRB(_nOpc)

	Private _lEnvia    := .F.

	aStru := {}
	AADD(aStru,{"CODCRO"   , "C" , 15, 0 })
	AADD(aStru,{"CODCLI"   , "C" , 15, 0 })
	AADD(aStru,{"PEDIDO"   , "C" , 20, 0 })
	AADD(aStru,{"QTDE"     , "N" , 12, 4 })
	AADD(aStru,{"UNIT"     , "N" , 12, 4 })
	AADD(aStru,{"TOTAL"    , "N" , 12, 4 })

	_cArqTrb := CriaTrab(aStru,.T.)
	_cIndTrb := "CODCRO"

	dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)
	dbSelectArea("TRB")
	IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

	_cQuery := " SELECT D2_COD,D2_PROCLI,D2_PEDCLI,D2_QUANT,D2_PRCVEN,D2_TOTAL "
	_cQuery += " FROM "+RetSqlName("SD2")+" D2 (NOLOCK) "
	_cQuery += " WHERE D2.D_E_L_E_T_ = '' "
	_cQuery += " AND D2_DOC+D2_SERIE = '"+SF2->F2_DOC+SF2->F2_SERIE+"' "
	_cQuery += " ORDER BY D2_COD "

	TCQUERY _cQuery New ALIAS "ZD2"

	ZD2->(dbGoTop())

	While ZD2->(!Eof())

		TRB->(RecLock("TRB",.T.))
		TRB->CODCRO  := ZD2->D2_COD
		TRB->CODCLI  := ZD2->D2_PROCLI
		TRB->PEDIDO  := ZD2->D2_PEDCLI
		TRB->QTDE    := ZD2->D2_QUANT
		TRB->UNIT    := ZD2->D2_PRCVEN
		TRB->TOTAL   := ZD2->D2_TOTAL
		TRB->(MsUnlock())

		_lEnvia := .T.

		ZD2->(dbSkip())
	EndDo

	ZD2->(dbCloseArea())

	If _lEnvia
		SendMail()
	Endif

	TRB->(dbCloseArea())

Return



Static Function SendMail()

	Local _cTo := ""
	Local _cCC := ""

	ConOut("Enviando E-Mail Cliente com Certificação:")

	_oProcess := TWFProcess():New( "ENVCERT", "CERTIFICACAO" )

	_oProcess:NewTask( "CERTIFICACAO", "\WORKFLOW\CERTIF_E.HTM" )
	_oProcess:bReturn  := ""
	_oProcess:bTimeOut := ""

	_oHTML := oProcess:oHTML

	_oProcess:cSubject := "NF Cancelada - Cliente ("+Alltrim(SA1->A1_NREDUZ)+") - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

	_oHtml:ValByName( "NUMERO" 	, Alltrim(SF2->F2_SERIE)+'-'+SF2->F2_DOC)
	_oHtml:ValByName( "EMISSAO"	, DTOC(SF2->F2_EMISSAO))
	_oHtml:ValByName( "CLIENTE"	, SF2->F2_CLIENTE+'-'+SF2->F2_LOJA)
	_oHtml:ValByName( "NOME"	, Alltrim(SA1->A1_NOME))

	TRB->(dbGoTop())

	While TRB->(!Eof())

		AADD( (oHtml:ValByName( "TB.CODCRO"   )), TRB->CODCRO)
		AADD( (oHtml:ValByName( "TB.CODCLI"   )), TRB->CODCLI)
		AADD( (oHtml:ValByName( "TB.PEDIDO"   )), TRB->PEDIDO)
		AADD( (oHtml:ValByName( "TB.QTDE"     )), TRANSFORM( TRB->QTDE ,   '@E 999,999,999.99' ))
		AADD( (oHtml:ValByName( "TB.UNIT"     )), TRANSFORM( TRB->UNIT ,   '@E 9,999,999.9999' ))
		AADD( (oHtml:ValByName( "TB.TOTAL"    )), TRANSFORM( TRB->TOTAL,   '@E 999,999,999.99' ))

		_oProcess:fDesc := "NF Cliente com Certificação "+SF2->F2_CLIENTE+" - Loja "+SF2->F2_LOJA

		TRB->(dbSkip())
	EndDo

	SZG->(dbsetOrder(1))
	SZG->(dbGotop())

	While SZG->(!EOF())

		If 'U1' $ SZG->ZG_ROTINA
			_cTo += If(Empty(_cTo),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
		ElseIf 'U2' $ SZG->ZG_ROTINA
			_cCC += If(Empty(_cCC),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
		Endif

		SZG->(dbSkip())
	Enddo

	_oProcess:AttachFile(_cAnexo)

	_cCc += If(Empty(_cCc),USRRETMAIL(RETCODUSR()),';'+USRRETMAIL(RETCODUSR()))

	_oProcess:cTo := _cTo
	_oProcess:cCC := _cCC

	_oProcess:Start()
	_oProcess:Finish()

Return
