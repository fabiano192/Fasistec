#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
Programa:	CR0076
Autor:		FABIANO DA SILVA
Data:		22/07/10
Descrição: 	Envio de E-mail referente aos Fornecedores Homologados
*/

User Function CR0076()

	PREPARE ENVIRONMENT Empresa "01" Filial "01"

	_aAliOri := GetArea()       
	_aAliSA2 := SA2->(GetArea())

	_lEnvia    := .F.    
	_lFim      := .F.
	_cMsg01    := ''
	_lAborta01 := .T.
	_bAcao01   := {|_lFim| 	CR076A(@_lFim) }
	_cTitulo01 := 'Enviando E-mail !!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

	RestArea(_aAliSA2)
	RestArea(_aAliOri)

Return


Static Function CR076A(_lFim)

	aStru := {}                            
	AADD(aStru,{"CODIGO"   , "C" , 06, 0 })
	AADD(aStru,{"LOJA"     , "C" , 02, 0 })
	AADD(aStru,{"NOME"     , "C" , 30, 0 })
	AADD(aStru,{"TIPO"     , "C" , 12, 0 })
	AADD(aStru,{"DTCERT"   , "D" , 08, 0 })
	AADD(aStru,{"DTVAL"    , "D" , 08, 0 })

	_cArqTrb := CriaTrab(aStru,.T.)
	_cIndTrb := "CODIGO+LOJA"

	dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)
	dbSelectArea("TRB")
	IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

	_lEnvia := .F.

	_cQuery := " SELECT A2_COD,A2_LOJA,A2_NOME,TIPO = CASE WHEN A2_TPHOMOL = '1' THEN 'Certificado' ELSE 'Questionario' END, "
	_cQuery += " A2_DTHOMOL, A2_DTVALHO FROM "+RetSqlName("SA2")+" A2 (NOLOCK) "
	_cQuery += " WHERE A2.D_E_L_E_T_ = '' "
	_cQuery += " AND A2_HOMOLOG = '1'  AND A2_DTVALHO <= '"+DTOS(dDataBase+10)+"' "
	_cQuery += " AND A2_EMAILHO = '1' "
	_cQuery += " ORDER BY A2_COD,A2_LOJA "

	TCQUERY _cQuery New ALIAS "ZA2"

	TcSetField("ZA2","A2_DTHOMOL" ,"D",8)
	TcSetField("ZA2","A2_DTVALHO" ,"D",8)

	ZA2->(dbGoTop())

	While ZA2->(!Eof())

		TRB->(RecLock("TRB",.T.))
		TRB->CODIGO  := ZA2->A2_COD
		TRB->LOJA    := ZA2->A2_LOJA
		TRB->NOME    := ZA2->A2_NOME              
		TRB->TIPO    := ZA2->TIPO
		TRB->DTCERT  := ZA2->A2_DTHOMOL
		TRB->DTVAL   := ZA2->A2_DTVALHO
		TRB->(MsUnlock())		

		_lEnvia := .T.	 

		ZA2->(dbSkip())
	EndDo

	If _lEnvia
		CR076B()
	Endif

	ZA2->(dbCloseArea())
	TRB->(dbCloseArea())

Return


Static Function CR076B()

	Private _lRet

	nOpcao := 0

	ConOut("Enviando E-Mail para COMPRAS:")

	oProcess := TWFProcess():New( "ENVEM1", "Compras " )
	aCond    :={}
	_nTotal  := 0

	oProcess:NewTask( "Fornecedores", "\WORKFLOW\CR0077.HTM" )
	oProcess:bReturn  := ""
	oProcess:bTimeOut := ""
	oHTML := oProcess:oHTML

	_nPerIpi  := 0
	nValIPI   := 0
	nTotal    := 0

	oProcess:cSubject := "Validade Certificado Fornecedores - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

	TRB->(dbGoTop())

	While TRB->(!Eof())

		AADD( (oHtml:ValByName( "TB.CODIGO"   )), TRB->CODIGO)
		AADD( (oHtml:ValByName( "TB.LOJA"     )), TRB->LOJA)
		AADD( (oHtml:ValByName( "TB.NOME"     )), TRB->NOME)
		AADD( (oHtml:ValByName( "TB.TIPO"     )), TRB->TIPO)
		AADD( (oHtml:ValByName( "TB.ENTRADA"  )), DTOC(TRB->DTCERT))
		AADD( (oHtml:ValByName( "TB.DTVALID"  )), DTOC(TRB->DTVAL))

		oProcess:fDesc := "Homologação Certificado"

		TRB->(dbSkip())
	EndDo

	Private _cTo := _cCC := ""

	SZG->(dbsetOrder(1))
	SZG->(dbGotop())

	While SZG->(!EOF())
	
		If 'P1' $ SZG->ZG_ROTINA
			_cTo += If(Empty(_cTo),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
		ElseIf 'P2' $ SZG->ZG_ROTINA
			_cCC += If(Empty(_cCC),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
		Endif
	
		SZG->(dbSkip())
	Enddo

	oProcess:cTo := _cTo
	oProcess:cCC := _cCC

	oProcess:Start()

	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Envio Email para Compras iniciado!' )

	oProcess:Finish()

Return
