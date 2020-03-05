#Include "Totvs.ch"
#Include "topconn.ch"

User Function A100DEL()

	_aAliOri := GETAREA()
	_aAliPA1 := PA1->(GetArea())
	_aAliPA2 := PA2->(GetArea())
	_aAliSD1 := SD1->(GetArea())
	_aAliZAC := ZAC->(GetArea())
	_lRet    := .T.

	If SF1->F1_EST = "EX"
		SD1->(dbSetOrder(1))
		If SD1->(dbSeek(xFilial("SD1")+SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
			ZAC->(dbSetorder(1))
			If ZAC->(dbSeek(xFilial("ZAC")+SD1->D1_YCODIMP))
				ZAC->(RecLock("ZAC",.F.))
				ZAC->ZAC_ENCER := ""
				ZAC->(MsUnLock())
			Endif

			ZAJ->(dbSetorder(1))
			If ZAJ->(dbSeek(xFilial("ZAJ")+SD1->D1_YCODREM))
				ZAJ->(RecLock("ZAJ",.F.))
				ZAJ->ZAJ_ENCER := ""
				ZAJ->(MsUnLock())
			Endif

			ZAK->(dbSetorder(3))
			If ZAK->(dbSeek(xFilial("ZAK")+"03"+SD1->D1_YCODREM))
				ZAK->(RecLock("ZAK",.F.))
				ZAK->ZAK_ENCER := ""
				ZAK->(MsUnLock())
			Endif
		Endif

		PA2->(dbSetOrder(5))
		If PA2->(dbSeek(xFilial("PA2")+ SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_DOC + SF1->F1_SERIE ))

			_cChavPA2 := PA2->PA2_FORREM + PA2->PA2_LJREM + PA2->PA2_NFREM + PA2->PA2_SERREM

			While PA2->(!Eof()) .And.	_cChavPA2 == PA2->PA2_FORREM + PA2->PA2_LJREM + PA2->PA2_NFREM + PA2->PA2_SERREM

				PA2->(RecLock("PA2",.F.))
				PA2->PA2_STATUS := "N"
				PA2->PA2_NFREM  := ""
				PA2->PA2_SERREM := ""
				PA2->PA2_FORREM := ""
				PA2->PA2_LJREM  := ""
				PA2->PA2_ITREM  := ""
				PA2->PA2_DTREM  := CTOD("")
				PA2->(MsUnlock())

				PA2->(dbSetOrder(5))
				PA2->(dbSeek(xFilial("PA2")+ SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_DOC + SF1->F1_SERIE ))

			EndDo
		Else
			PA1->(dbSetOrder(5))
			If PA1->(dbSeek(xFilial("PA1")+ SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_DOC + SF1->F1_SERIE ))

				_cChavPA1 := PA1->PA1_FORREM + PA1->PA1_LJREM + PA1->PA1_NFREM + PA1->PA1_SERREM

				While PA1->(!Eof()) .And. _cChavPA1 == PA1->PA1_FORREM + PA1->PA1_LJREM + PA1->PA1_NFREM + PA1->PA1_SERREM

					PA1->(RecLock("PA1",.F.))
					PA1->PA1_STATUS := "N"
					PA1->PA1_NFREM  := ""
					PA1->PA1_SERREM := ""
					PA1->PA1_FORREM := ""
					PA1->PA1_LJREM  := ""
					PA1->(MsUnlock())

					PA1->(dbSkip())
				EndDo
			Endif
		Endif
	Endif

	RestArea(_aAliPA1)
	RestArea(_aAliPA2)
	RestArea(_aAliSD1)
	RestArea(_aAliZAC)
	RestArea(_aAliOri)

Return(.T.)

User Function MTALCDOC()

	_aAliOri := GetArea()
	_aAliSAL := SAL->(GetArea())
	_aAliSC7 := SC7->(GetArea())
	_aAliSCR := SCR->(GetArea())
	_aAliZAH := ZAH->(GetArea())

	_cDoc     := PARAMIXB[1][1]
	_cTipoSCR := PARAMIXB[1][2]
	_nValSCR  := PARAMIXB[1][3]
	_cAprov   := PARAMIXB[1][4]
	_cGrupo   := PARAMIXB[1][6]

	_nMoeDcto := If(Len(PARAMIXB[1] ) > 7, If(PARAMIXB[1][8]== Nil, 1,PARAMIXB[1][8]),1)
	_nTxMoeda := If(Len(PARAMIXB[1] ) > 8, If(PARAMIXB[1][9]== Nil, 0,PARAMIXB[1][9]),0)

	_cNivel   := ""
	_nOpcao   := PARAMIXB[3]

	If _nOpcao == 1
		SCR->(dbSetOrder(1))
		If SCR->(dbSeek(xFilial("SCR")+ _cTipoSCR + _cDoc  ))
			_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM
			_cObs     := SCR->CR_OBS

			While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM

				_cObs := ""

				If  _cTipoSCR == "NF"
					If  SCR->CR_NIVEL != "01" //'!MaAlcLim(SCR->CR_APROV,_nValSCR,_nMoeDcto,_nTxMoeda)
						SCR->(RecLock("SCR",.F.))
						SCR->(dbDelete())
						SCR->(MsUnlock())

						ZAH->(dbSetOrder(2))
						If ZAH->(dbSeek(xFilial("ZAH")+SCR->CR_TIPO + SCR->CR_NUM + SCR->CR_USER))
							ZAH->(RecLock("ZAH",.F.))
							ZAH->(dbDelete())
							ZAH->(MsUnlock())
						Endif

						SCR->(dbSkip())
						Loop
					EndIf

					_cObs := Alltrim(SM0->M0_NOME) +" - DEVOLUCAO DE VENDAS"
				Endif

				SCR->(RecLock("SCR",.F.))
				SCR->CR_OBS   := _cObs
				SCR->(MsUnlock())

				ZAH->(RecLock("ZAH",.T.))
				ZAH->ZAH_FILIAL:= SCR->CR_FILIAL
				ZAH->ZAH_NUM   := SCR->CR_NUM
				ZAH->ZAH_TIPO  := SCR->CR_TIPO
				ZAH->ZAH_NIVEL := SCR->CR_NIVEL
				ZAH->ZAH_USER  := SCR->CR_USER
				ZAH->ZAH_APROV := SCR->CR_APROV
				ZAH->ZAH_STATUS:= SCR->CR_STATUS
				ZAH->ZAH_TOTAL := SCR->CR_TOTAL
				ZAH->ZAH_EMISSA:= SCR->CR_EMISSAO
				ZAH->ZAH_MOEDA := SCR->CR_MOEDA
				ZAH->ZAH_TXMOED:= SCR->CR_TXMOEDA
				ZAH->ZAH_OBS   := _cObs
				ZAH->(MsUnlock())

				SCR->(dbSkip())
			EndDo
		Endif
	ElseIf _nOpcao == 3
		ZAH->(dbSetOrder(1))
		If ZAH->(dbSeek(xFilial("ZAH")+ _cTipoSCR + _cDoc  ))
			_cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM

			_cCq := " DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cDoc+"' AND ZAH_TIPO = '"+_cTipoSCR+"' "
			_cCq += " AND ZAH_FILIAL = '"+xFilial("ZAH")+"' "

			TcSqlExec(_cCq)
		Endif
	ElseIf _nOpcao == 4
		SAL->(dbSetOrder(3))
		If SAL->(dbSeek(xFilial("SAL")+_cGrupo+_cAprov) )

			ZAH->(dbSetOrder(2))
			If ZAH->(dbSeek(xFilial("ZAH")+ _cTipoSCR + _cDoc  ))

				_cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM

				_cQ := " UPDATE "+RetSqlName("ZAH")+ " SET ZAH_STATUS = CR_STATUS FROM "+RetSqlName("ZAH")+ " A INNER JOIN "+RetSqlName("SCR")+ " B ON CR_FILIAL = ZAH_FILIAL AND CR_NUM=ZAH_NUM AND CR_USER=ZAH_USER AND CR_TIPO=ZAH_TIPO "
				_cQ += " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND  CR_TIPO = '"+_cTipoSCR+"' AND CR_NUM = '"+_cDoc+"' "
				_cQ += " AND ZAH_FILIAL = '"+xFilial("ZAH")+"' "

				TcSqlExec(_cQ)

				If SAL->AL_TPLIBER $ "NP"
					_cCq := " DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cDoc+"' AND ZAH_TIPO = '"+_cTipoSCR+"' AND ZAH_NIVEL = '"+SAL->AL_NIVEL+"' AND ZAH_STATUS <> '03' "
					_cCq += " AND ZAH_FILIAL = '"+xFilial("ZAH")+"' "

					TcSqlExec(_cCq)

				ElseIf SAL->AL_TPLIBER $ "U"
					_cCq := " DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cDoc+"' AND ZAH_TIPO = '"+_cTipoSCR+"' AND ZAH_USER = '"+SAL->AL_USER+"' AND ZAH_STATUS <> '03' "
					_cCq += " AND ZAH_FILIAL = '"+xFilial("ZAH")+"' "

					TcSqlExec(_cCq)

				Endif
			Endif
		Endif
	Endif

	_cQ := " UPDATE "+RetSqlName("ZAH")+ " SET ZAH_STATUS = CR_STATUS FROM "+RetSqlName("ZAH")+ " A INNER JOIN "+RetSqlName("SCR")+ " B ON CR_FILIAL = ZAH_FILIAL AND CR_NUM = ZAH_NUM AND CR_USER=ZAH_USER AND CR_TIPO=ZAH_TIPO "
	_cQ += " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND  CR_TIPO = '"+_cTipoSCR+"' AND CR_NUM = '"+_cDoc+"' "
	_cQ += " AND ZAH_FILIAL = '"+xFilial("ZAH")+"' "

	TcSqlExec(_cQ)

	RestArea(_aAliSC7)
	RestArea(_aAliSCR)
	RestArea(_aAliSAL)
	RestArea(_aAliZAH)
	RestArea(_aAliOri)

Return


User Function A103BLOQ()

	_aAliOri := GetArea()
	_lRet    := .F.

	If !l103Class
		If cTipo == "D"
			//_lRet := .T.
		Endif
	Endif

	RestArea(_aAliOri)

Return(_lRet)

User Function CTAXCC(_cTab)

	_aAliOri := GetArea()
	_lRet    := .T.

	If _cTab == "SC7"
		_nPosCC  := aScan(aHeader,{|x| AllTrim(x[2])== "C7_CC"      })
		_nPosCT  := aScan(aHeader,{|x| AllTrim(x[2])== "C7_CONTA"   })
		_nPosIT  := aScan(aHeader,{|x| AllTrim(x[2])== "C7_ITEMCTA" })
		_nPosCL  := aScan(aHeader,{|x| AllTrim(x[2])== "C7_CLVL"    })
	ElseIf _cTab == "SD1"
		_nPosCC  := aScan(aHeader,{|x| AllTrim(x[2])== "D1_CC"      })
		_nPosCT  := aScan(aHeader,{|x| AllTrim(x[2])== "D1_CONTA"   })
		_nPosIT  := aScan(aHeader,{|x| AllTrim(x[2])== "D1_ITEMCTA" })
		_nPosCL  := aScan(aHeader,{|x| AllTrim(x[2])== "D1_CLVL"    })
	Endif

	_cCta    := aCols[N,_nPosCT]
	_cCC     := aCols[N,_nPosCC]
	_cItem   := aCols[N,_nPosIT]
	_cClasse := aCols[N,_nPosCL]
	_cRet    := &(ReadVar())

	_lRet    := CtbAmarra(_cCta,_cCC,_cItem ,_cClasse,.T.)
	_lParar  := .T.

	If !_lRet
		If Alltrim(ReadVar())     == "M->C7_CONTA"
			_cRet := Space(20)
		ElseIf Alltrim(ReadVar()) == "M->C7_CC"
			_cRet := Space(10)
		ElseIf Alltrim(ReadVar()) == "M->D1_CONTA"
			_cRet := Space(20)
		ElseIf Alltrim(ReadVar()) == "M->D1_CC"
			_cRet := Space(10)
		Endif
	Endif

	RestArea(_aAliOri)

Return(_cRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103LCF  ºAutor  ³MARCIO AFLITOS      º Data ³  17/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PONTO DE ENTRADA PARA TRATAR BLOQUEIO DE CAMPOS NO         º±±
±±º          ³    DOCMENTO DE ENTRADA                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³  MATA103 - MIZU                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function MT103LCF()

	Local cCampo:=UPPER(PARAMIXB[1])
	LOCAL nD1Pedido:=0
	LOCAL lTemPC:=.F.
	Local lRet :=.T.

	IF u_ChkAcesso("MT103LCF",6,.F.)
		RETURN lRet
	ENDIF

	IF Type("aHeader")=="A"
		nD1Pedido:=Ascan(aHeader, {|ZZ| Alltrim(ZZ[2])='D1_PEDIDO'})
		lTemPc:= (Ascan(aCols,{|aa,nn| !Empty(aa[nD1Pedido]) })<>0)
	ENDIF

	IF lTemPc

		Do Case
		Case cCampo == "F1_DESCONT"
			lRet = .T.
		Case cCampo == "F1_FRETE"
			lRet = .T.
		Case cCampo == "F1_DESPESA"
			lRet = .F.
		Case cCampo == "F1_SEGURO"
			lRet = .F.
		EndCase
	ENDIF

Return (lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103NAT  ºAutor  ³Microsiga           º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function MT103NAT()

	local _nL
	STATIC _cNaturez   :=""
	STATIC _lRet       :=.T.
	LOCAL _nPosCCus    := 0
	LOCAL cMZNaturez:=""
	LOCAL cMZGrCusto:=""
	LOCAL cMZCCusto:=""

	IF _cNaturez  == PARAMIXB
		RETURN _lRet
	ENDIF
	_cNaturez    := PARAMIXB

	SED->(OrdSetFocus(1))
	IF .NOT. (_lRet:=ExistCpo("SED",(_cNaturez)))
		RETURN _lRet
	ENDIF

	_nPosCCus  := aScan(aHeader,{|x| alltrim(x[2])=="D1_CC"})
	cMzNaturez := GETMV("MZ_NATUREZ")
	cMZGrCusto := GETMV("MZ_GRCUSTO")
	cMZCCusto  := GETMV("MZ_CCUSTO")

	For _nL = 1 To Len(aCols)

		If GdDeleted( _nL )
			Loop
		Endif

		_cCusto     := ACOLS[_nL,_nPosCCus]

		If Substr(_cCusto,1,2) $ cMzGrCusto// "07/08"
			If !Alltrim(_cCusto) $ cMzCCusto  //"0701/0702/0703"
				If !Alltrim(_cNaturez) $ cMzNaturez //  "3"
					_lRet := .F.
				Else
					_lRet := .t.
				Endif
			Endif
		Endif
	Next _nL

	If !_lRet
		MSGSTOP("QUANDO UTILIZAR CC COM INICIAIS '07' OU '08', A NATUREZA TEM QUE SER "+cMzNaturez )
	Endif

Return(_lRet)


User Function MA103BUT()

	aButtons := {}

//aadd(aButtons,{ 'Ticket'            ,{|| U_MZ0150() },'Ticket' } )
	aadd(aButtons,{ 'Pedido'            ,{|| U_MZ0151() },'Pedido Comp.Preco' } )

Return (aButtons )


User Function MA020TOK()

	Local _aAliORI	:= GetArea()
	Local _aAliSA2	:= SA2->(GetArea())
	Local lRet		:= .T.

	If M->A2_EST <> "EX" .And. (Empty(M->A2_CGC) .Or. Empty(M->A2_INSCR))
		MSGINFO("FAVOR DIGITAR O CNPJ / INSCRICAO ESTADUAL!!")
		Return(.F.)
	Endif

	If !INCLUI
		Return(lRet)
	Endif

	SA2->(dbSetOrder(1))
	If SA2->(dbSeek(xFilial("SA2")+M->A2_COD + M->A2_LOJA))

		_cq := " SELECT MAX(A2_COD) AS COD FROM "+RetSqlName("SA2")+" A "
		_cq += " WHERE A.D_E_L_E_T_ = '' AND SUBSTRING(A2_COD,1,1) = 'F' "

		TcQuery _cQ New Alias "ZZ"

		_cCod := Substr(ZZ->COD,2,5)

		M->A2_COD := "F"+ Soma1(_cCod)

		ZZ->(dbCloseArea())
	Endif
/*
	If Substr(M->A2_COD,1,1) == "F" .AND. Len(Alltrim(M->A2_COD)) == TamSx3("A2_COD")[1]
	
	DBSELECTAREA("CTH")
	DBSETORDER(1)
		IF !DBSEEK(xFILIAL("CTH")+M->A2_COD+M->A2_LOJA, .F.)
		RecLock("CTH",.T.)
		CTH->CTH_FILIAL := xFILIAL("CTH")
		CTH->CTH_CLVL   := M->A2_COD+M->A2_LOJA
		CTH->CTH_CLASSE := "2"
		CTH->CTH_BLOQ   := "2"
		CTH->CTH_DESC01 := M->A2_NOME
		CTH->CTH_NORMAL := "0"
		MsUnlock()
		ENDIF
	Else
	lRet := .F.
	EndIf

MSGINFO("Codigo do Novo Fornecedor: "+M->A2_COD+"-"+M->A2_LOJA)
*/
	RestArea(_aAliSA2)
	RestArea(_aAliORI)

Return(lRet)

User Function M020INC()

	Local lRet		:= .T.

	_aAliORI := GetArea()
	_aAliSA2 := SA2->(GetArea())
/*
	If Substr(M->A2_COD,1,1) == "F" .AND. Len(Alltrim(M->A2_COD)) == TamSx3("A2_COD")[1]
	DBSELECTAREA("CTH")
	DBSETORDER(1)
		IF !DBSEEK(xFILIAL("CTH")+M->A2_COD+M->A2_LOJA, .F.)
		RecLock("CTH",.T.)
			CTH->CTH_FILIAL := xFILIAL("CTH")
			CTH->CTH_CLVL   := M->A2_COD+M->A2_LOJA
			CTH->CTH_CLASSE := "2"
			CTH->CTH_DESC01 := M->A2_NOME
			CTH->CTH_NORMAL := "0"
			CTH->CTH_BLOQ   := "2"
	
		MsUnlock()
		ENDIF
	Else
	lRet	:= .F.
	EndIf
*/
	_cQ:= " SELECT MAX(CTD_ITEM) AS ULTCTD FROM "+RetSqlName("CTD")+" WHERE D_E_L_E_T_ = ''  AND LEFT(CTD_ITEM,4) = 'AGLF' "

	TCQUERY _cQ NEW ALIAS "ZZ2"

	If Empty(ZZ2->ULTCTD)
		_cSeqCTD := "00001"
	Else
		_cSeqCTD := SOMA1(SUBSTR(ZZ2->ULTCTD,5,5))
	Endif

	_cCODCTD := "AGLF"+ _cSeqCTD

	ZZ2->(dbCloseArea())

	CTD->(dbOrderNickName( "INDCTD1" ))
	If CTD->(!MsSeek(xFilial("CTD") + "F"+ M->A2_COD + M->A2_LOJA))
		CTD->(RecLock("CTD",.T.))
		CTD->CTD_FILIAL := XFILIAL("CTD")
		CTD->CTD_ITEM   := _cCODCTD
		CTD->CTD_CLASSE := "2"
		CTD->CTD_DESC01 := M->A2_COD+"-"+M->A2_LOJA+" - "+M->A2_NOME
		CTD->CTD_BLOQ   := "2"
		CTD->CTD_DTEXIS := CTOD("01/01/19")
		CTD->CTD_ITLP   := _cCODCTD
		CTD->CTD_CLOBRG := "2"
		CTD->CTD_ACCLVL := "1"
		CTD->CTD_YIDENT := "F" + M->A2_COD + M->A2_LOJA
		CTD->(MsUnlock())

		//M->A2_YITEMC    := _cCODCTD

		SA2->(dbSetOrder(1))
		If SA2->(MsSeek(xFilial("SA2")+ M->A2_COD + M->A2_LOJA))
			SA2->(RecLock("SA2",.F.))
			SA2->A2_YITEMC    := _cCODCTD
			SA2->(MsUnlock())
		Endif

	Endif

	RestArea(_aAliSA2)
	RestArea(_aAliORI)

Return(lRet)

User Function MA030TOK()

	local F
	Local lRet		:= .T.
	Local lWeb	:= IF(IsInCallStack("U_SFTA050") .Or. IsInCallStack("SetSA1"),.T.,.F.)


	_aAliOri := GetArea()
	_aAliSF4 := SF4->(GetArea())

	If !lWeb

		_aCampo := {'A1_YCELSMS','A1_YMUNE','A1_YUFE','A1_YTESF','A1_YTES','A1_RISCO','A1_YFICMS','A1_YTIPF','A1_CODPAIS','A1_CONTRIB','A1_YEMAILC','A1_YCELCOB','A1_YTPCLI','A1_COD_MUN','A1_NATUREZ','A1_CONTA','A1_ATIVIDA'}
		_cCampo := ''

		If M->A1_EST <> 'EX' .AND. Empty(M->A1_CGC)   // Inclusa validação cadastro exterior - Chamado 39199 - Raphael Moura
			AADD(_aCampo, 'A1_CGC')
		EndIf

		For F := 1 to Len(_aCampo)
			If Empty(&('M->'+_aCampo[F]))
				SX3->( dbSetOrder(2) )
				If SX3->( msSeek(_aCampo[F]) )
					_cCampo += Alltrim(X3Titulo())+CRLF
				Endif
			Endif
		Next F


		If !Empty(_cCampo)
			MsgAlert('Os campos abaixo não estão preenchidos, favor revisar o cadastro!'+CRLF+CRLF+_cCampo)
			lRet := .F.
		Endif

		SF4->(dbSetOrder(1))
		If SF4->(dbSeek(xFilial("SF4")+M->A1_YTES))
			_cSitTrib := SF4->F4_SITTRIB
			_cCf      := Substr(SF4->F4_CF,2,3)

			If M->A1_TIPO == "S" .And. !(_cSitTrib $ "10/30/70")
				MSGSTOP("TES INCOMPATIVEL COM O TIPO DO CLIENTE!!")
				_lRet := .F.

				RestArea(_aAliSF4)
				RestArea(_aAliOri)

				Return(_lRet)

			Else
				If M->A1_TIPO != "S" .And. _cCf $ "401/403"
					MSGSTOP("TES INCOMPATIVEL COM O TIPO DO CLIENTE!!")
					_lRet := .F.

					RestArea(_aAliSF4)
					RestArea(_aAliOri)

					Return(_lRet)
				Endif
			Endif
		Endif
	EndIf
/****************************************************************************************************************************************************************************/

	If !INCLUI
		Return(lRet)
	Endif

	_aAliORI := GetArea()
	_aAliSA1 := SA1->(GetArea())

	If lRet
		SA1->(dbSetOrder(1))
		If SA1->(dbSeek(xFilial("SA1")+M->A1_COD + M->A1_LOJA))

			If Select("ZZ") > 0
				ZZ->(dbCloseArea())
			Endif

			_cq := " SELECT MAX(A1_COD) AS COD FROM "+RetSqlName("SA1")+" A "
			_cq += " WHERE A.D_E_L_E_T_ = '' AND SUBSTRING(A1_COD,1,1) = 'C' "

			TcQuery _cQ New Alias "ZZ"


			_cCod := Substr(ZZ->COD,2,5)

			M->A1_COD := "C"+ Soma1(_cCod)

			ZZ->(dbCloseArea())
		Endif

		If Substr(M->A1_COD,1,1) == "C" .AND. Len(Alltrim(M->A1_COD)) == TamSx3("A1_COD")[1]
			DBSELECTAREA("CTH")
			DBSETORDER(1)
			IF !DBSEEK(xFILIAL("CTH")+M->A1_COD+M->A1_LOJA, .F.)
				RecLock("CTH",.T.)
				CTH->CTH_FILIAL := xFILIAL("CTH")
				CTH->CTH_CLVL   := M->A1_COD+M->A1_LOJA
				CTH->CTH_CLASSE := "2"
				CTH->CTH_BLOQ   := "2"
				CTH->CTH_DESC01 := M->A1_NOME
				CTH->CTH_NORMAL := "0"
				MsUnlock()
			ENDIF
		Else
			lRet := .F.
		EndIf

		MSGINFO("Codigo do Novo Cliente: "+M->A1_COD+"-"+M->A1_LOJA)

	EndIf

	RestArea(_aAliSA1)
	RestArea(_aAliORI)

Return(lRet)
/*
User Function MT010INC()

Local aRecnoSM0:= {}
Local lStartJob:= .T.
Private nOpc   := 3 //INCLUSAO

_aAliOri := GetArea()
_aAliCTH := CTH->(GetArea())
_aAliSB1 := SB1->(GetArea())
_aAliSBZ := SBZ->(GetArea())

	If nOpc == 3
	CTH->(dbSetOrder(1))
		If CTH->(!dbSeek(xFilial("CTH")+SB1->B1_COD))
		CTH->(RecLock("CTH",.T.))
		CTH->CTH_FILIAL := xFilial("CTH")
		CTH->CTH_CLVL   := SB1->B1_COD
		CTH->CTH_CLASSE := "2"
		CTH->CTH_BLOQ   := "2"
		CTH->CTH_DESC01 := SB1->B1_DESC
		CTH->CTH_CLSUP  := SB1->B1_SUBGRUP
		CTH->CTH_NORMAL := "0"
		CTH->(MsUnlock())
		Endif
	Endif
*/

/*
Autor		:	Fabiano	 da Silva
Data		:	03/06/2014
Descrição	:	Ponto de Entrada Utilizado após a gravação para produtos que se iniciam com 'I'
http://tdn.totvs.com/pages/releaseview.action?pageId=6087685
*/
	If Left(SB1->B1_COD,1) = 'I'
		ConOut("Enviando E-Mail Referente ao Produto de Importação:")

		oProcess := TWFProcess():New( "Prod_Imp", "SIGAEIC" )
		oProcess:NewTask( "Prod_Imp", "\WORKFLOW\MT010INC.htm" )
		oHTML := oProcess:oHTML

		oHtml:ValByName( "empresa"  	, Alltrim(SM0->M0_NOME))
		oHtml:ValByName( "produto"   	, SB1->B1_COD)
		oHtml:ValByName( "descric"   	, Alltrim(SB1->B1_DESC))

		cUser 	:= Subs(cUsuario,7,15)
		oProcess:ClientName(cUser)

		oProcess:cBody    	:= ""
		oProcess:bReturn  	:= {}
		oProcess:bTimeOut   := {}

		Private _cTo := _cCC := _cBcc := ""

		_cTo := SuperGetMv( "MZ_MAILFIS" , .F. , "" ,)

		oProcess:cTo  := _cTo
		oProcess:cCC  := _cCC
		oProcess:cBCC := _cBcc

		oProcess:cSubject := "Novo Cadastro de Produto de Importação - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

		oProcess:Start()

		oProcess:Free()
		oProcess:Finish()
		oProcess:= Nil
	Endif

	RestArea(_aAliCTH)
	RestArea(_aAliSB1)
	RestArea(_aAliSBZ)
	RestArea(_aAliORI)

Return


/*
Autor		:	Fabiano da Silva
Programa	:	MT103FIM
Descrição	:	Ponto de Entrada para gravar/excluir os tickets (NF)
Data		: 	11/03/14
*/
User Function MT103FIM()

	Local nOpcao 	:= PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina
	Local nConfirma := PARAMIXB[2] 	 // Se o usuario confirmou a operação de gravação da NFE
	Local cEmpLib	:= Alltrim(SuperGetMV("MV_SMEFPEE",,"0101|0218|1001|0226|1101|0213|2001|0223|3001|0210|4001|0203"))    // Incluso empresa 02 e as filiais - Alison 22/07/2016


	If Alltrim(FunName()) $ "MZ0085"
		Return
	Endif

	If cEmpAnt + cFilAnt $ "1201|5001|0216"

		If nConfirma = 1 //Confirmou a Tela

			If SF1->F1_TIPO = 'N'

				If nOpcao = 3 //Incluir

					_nZTR   := Select("ZTR") //Verifica se a Tabela existe

					If _nZTR > 0

						ZTR->(dbGoTop())

						While ZTR->(!EOF())

							_nIndice := 1

							ZAM->(dbSetOrder(_nIndice))
							If ZAM->(dbSeek(xFilial("ZAM")+ZTR->SERIE+ZTR->TICKET+ZTR->FORNECE+ZTR->LOJA))

								IF ZTR->TIPO != 'CTR'
									ZAM->(RecLock("ZAM"),.F.)
									ZAM->ZAM_NFORIG := ZTR->NFORI
									ZAM->ZAM_SEORIG := ZTR->SERORI
									ZAM->ZAM_ITORIG := ZTR->ITORI
									ZAM->ZAM_FOORIG := ZTR->FORNECE
									ZAM->ZAM_LJORIG := ZTR->LOJA
									ZAM->(MsUnLock())
								Endif

							Endif

							ZTR->(dbskip())

						EndDo

						ZTR->(dbCloseArea())

					Endif

				ElseIf nOpcao = 5 //Excluir

					_cID := SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)

					_cSeek := "ZAM_NFORIG+ZAM_SEORIG+ZAM_FOORIG+ZAM_LJORIG = '"+_cID+"' "

					_cQuery := " SELECT * FROM "+RetSqlName("ZAM")+" ZAM " + CRLF
					_cQuery += " WHERE D_E_L_E_T_= '' AND "+_cSeek + CRLF

					TCQUERY _cQuery New ALIAS "ZZ"

					//					MemoWrite("D:\MT103FIM.TXT",_cQuery)

					ZZ->(dbGoTop())

					While ZZ->(!EOF())

						ZAM->(dbSetOrder(1))
						If ZAM->(dbSeek(xFilial("ZAM")+ZZ->ZAM_SERIE+ZZ->ZAM_TICKET+ZZ->ZAM_FORNEC+ZZ->ZAM_LOJA))

							IF SF1->F1_ESPECIE != 'CTR'
								ZAM->(RecLock("ZAM"),.F.)
								ZAM->ZAM_NFORIG := ""
								ZAM->ZAM_SEORIG := ""
								ZAM->ZAM_ITORIG := ""
								ZAM->ZAM_FOORIG := ""
								ZAM->ZAM_LJORIG := ""
								ZAM->(MsUnLock())
							Endif

						Endif

						ZZ->(dbSkip())
					EndDo

					ZZ->(dbCloseArea())

				Endif

			Endif
		Else //Não confirmou a tela
			_nZTR := Select("ZTR") //Verifica se a Tabela existe

			If _nZTR > 0
				ZTR->(dbCloseArea())
			Endif

		Endif
		//ElseIf cEmpAnt $ "30/40"                 Comentado por Alison - 22/07/2016
	ElseIf cEmpAnt + cFilAnt $ '0210|3001|4001|0203'	//Incluso a empresa 0203 - 12/09/2016
		If nConfirma = 1 //Confirmou a Tela

			If SF1->F1_TIPO = 'N'
				If nOpcao = 3 //Incluir

					U_MZ0178(SF1->F1_SERIE,SF1->F1_DOC,SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_EMISSAO,SF1->F1_DTDIGIT) //Envia e-mail para o programador (MNT)

				Endif
			Endif
		Endif

	Endif

//if cEmpAnt+cFilAnt $ cEmpLib .AND. nConfirma == 1 .AND. nOpcao == 5
	if nConfirma == 1 .AND. nOpcao == 5 // Alterado por Rodrigo (semar) em 18/05/2017 - retirada liberação por parametro
		U_smZA1Restor()
	endif


//**************************************************************************************************************************************************************************//
//  Descrição:	Grava os dados da nota fiscal na tabela de solicitação de compras (SC1) se o pedido de compra possuir vinculo com SC.										//
//	Analista:	Marcus Vinicius da Silva                                                                                                                                    //
//	Data:		10/04/2017                                                                                                                                                  //
//**************************************************************************************************************************************************************************//
	If nOpcao <> 5 // Diferente de Excluir

		SC7->(dbSetOrder(1))
		SC7->(DbSeek(xFilial("SC7")+SD1->D1_PEDIDO))

		While SC7->(!Eof()) .And. xFilial("SD1") == xFilial("SC7") .And. SD1->D1_PEDIDO == SC7->C7_NUM

			If !Empty(SC7->C7_NUMSC)

				SC1->(dbSetOrder(1))
				SC1->(DbSeek(xFilial("SC1")+SC7->C7_NUMSC))

				While SC1->(!Eof()) .And. xFilial("SC7") == xFilial("SC1") .And. SC7->C7_NUMSC == SC1->C1_NUM

					If SC7->C7_ITEMSC == SC1->C1_ITEM
						SC1->(RecLock("SC1",.F.))
						IIF (SC1->(FieldPos("C1_YNFNUM"	)) > 0, SC1->C1_YNFNUM	:= SD1->D1_DOC									, 0)
						IIF (SC1->(FieldPos("C1_YNFSERI")) > 0, SC1->C1_YNFSERI := SD1->D1_SERIE								, 0)
						IIF (SC1->(FieldPos("C1_YNFDIGI")) > 0, SC1->C1_YNFDIGI := SD1->D1_DTDIGIT								, 0)
						IIF (SC1->(FieldPos("C1_YDIFDAT")) > 0, SC1->C1_YDIFDAT	:= cValToChar(SD1->D1_DTDIGIT - SC1->C1_DATPRF)	, 0)
						SC1->(MsUnlock())
					EndIf
					SC1->(dbSkip())
				EndDo

			EndIf

			SC7->(dbSkip())
		EndDo
	Else
		SC7->(dbSetOrder(1))
		SC7->(DbSeek(xFilial("SC7")+SD1->D1_PEDIDO))

		While SC7->(!Eof()) .And. xFilial("SD1") == xFilial("SC7") .And. SD1->D1_PEDIDO == SC7->C7_NUM

			If !Empty(SC7->C7_NUMSC)

				SC1->(dbSetOrder(1))
				SC1->(DbSeek(xFilial("SC1")+SC7->C7_NUMSC))

				While SC1->(!Eof()) .And. xFilial("SC7") == xFilial("SC1") .And. SC7->C7_NUMSC == SC1->C1_NUM

					If SC7->C7_ITEMSC == SC1->C1_ITEM
						SC1->(RecLock("SC1",.F.))
						IIF (SC1->(FieldPos("C1_YNFNUM"	)) > 0, SC1->C1_YNFNUM	:= SPACE(9)		 , 0)
						IIF (SC1->(FieldPos("C1_YNFSERI")) > 0, SC1->C1_YNFSERI := SPACE(3)		 , 0)
						IIF (SC1->(FieldPos("C1_YNFDIGI")) > 0, SC1->C1_YNFDIGI := STOD(SPACE(8)), 0)
						IIF (SC1->(FieldPos("C1_YDIFDAT")) > 0, SC1->C1_YDIFDAT	:= SPACE(3)		 , 0)
						SC1->(MsUnlock())
					EndIf
					SC1->(dbSkip())
				EndDo

			EndIf

			SC7->(dbSkip())
		EndDo

	EndIF

/*
	If nConfirma = 1 //Confirmou a Tela
		If SF1->F1_TIPO = 'N'
			If nOpcao = 3 //Incluir
			U_MZ0004()
			Endif
		Endif
	Endif
*/

Return



/*
Autor		:	Fabiano da Silva
Descrição	:	Ponto de Entrada para excluir os tickets (CTR)
Programa	:	MT116OK
Data		: 	20/05/14
*/
User Function MT116OK()

	local _nMZ204
	Local _lExclusao := PARAMIXB[1] 	 // Se é Exclusão
	Local ExpL1    	 := PARAMIXB[1]
	Local _lRet 	 := .T.

	If cEmpAnt + cFilAnt $ "1201|5001|0216"
		If _lExclusao

			_cID := SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)

			_cSeek := "ZAM_CTRNUM+ZAM_CTRSER+ZAM_CTRFOR+ZAM_CTRLOJ = '"+_cID+"' "

			_cQuery := " SELECT * FROM "+RetSqlName("ZAM")+" ZAM " + CRLF
			_cQuery += " WHERE D_E_L_E_T_= '' AND "+_cSeek + CRLF

			TCQUERY _cQuery New ALIAS "ZZ"

			ZZ->(dbGoTop())

			While ZZ->(!EOF())

				ZAM->(dbSetOrder(1))
				If ZAM->(dbSeek(xFilial("ZAM")+ZZ->ZAM_SERIE+ZZ->ZAM_TICKET+ZZ->ZAM_FORNEC+ZZ->ZAM_LOJA))

					IF SF1->F1_ESPECIE = 'CTR'
						ZAM->(RecLock("ZAM"),.F.)
						ZAM->ZAM_CTRNUM := ""
						ZAM->ZAM_CTRSER := ""
						ZAM->ZAM_CTRITE := ""
						ZAM->ZAM_CTRFOR := ""
						ZAM->ZAM_CTRLOJ := ""
						ZAM->(MsUnLock())
					Endif

				Endif

				ZZ->(dbSkip())
			EndDo

			ZZ->(dbCloseArea())

		Endif
	Endif

	if ExpL1
		DbSelectArea("ZA1")
		DbSetOrder(1)
		If ZA1->(MsSeek(xFilial("ZA1")+CA100FOR+CLOJA+CSERIE+CNFISCAL))
			RecLock("ZA1",.F.)
			ZA1->ZA1_DOCSF1 	:= ""
			ZA1->ZA1_DTENT	:= CTOD("//")
			ZA1->ZA1_STATUS	:= 0
			ZA1->(MsUnlock())
		endif
	endif

	if IsInCallStack("u_smXMLCentral")
		l116Auto := .T.
	endif

	If IsInCallStack("u_MZ0204") .And. _lRet
		_nPosIcm  := aScan(aHeader,{|x| AllTrim(x[2])== "D1_VALICM"  })

		//Verifica se o valor do ICMS do CTE é igual ao XML importado
		_nMZ204TOT := 0

		For _nMZ204 := 1 to Len(aCols)
			_nMZ204TOT += aCols[_nMZ204,_nPosIcm]
		Next _nMZ204

		If _nMZ204ICM <> _nMZ204TOT
			If _nMZ204ICM < _nMZ204TOT
				_nMZ204TOT -= 0.01
				_lRet := .T.
			Elseif _nMZ204ICM > _nMZ204TOT
				_nMZ204TOT += 0.01
				_lRet := .T.
			Else
				_lRet := .F.
			Endif
		Endif
	Endif

Return (_lRet)




User Function MT116TOK()

	Local AZ
	_aAliOri := GetArea()
	_aAliSA2 := SA2->(GetArea())
	_lRet    := .T.

	_nPosPed  := aScan(aHeader,{|x| AllTrim(x[2])== "D1_PEDIDO"  })
	_nPosIT   := aScan(aHeader,{|x| AllTrim(x[2])== "D1_ITEMPC"  })
	_nDesp    := 0

	For AZ:= 1 To Len(Acols)

		If cEmpAnt + cFilAnt $ "1201|5001|0216"
			_aAcolsOri := AClone(ACOLS)
			_lRet      := U_MZ0150()
			ACOLS      := _aAcolsOri
		Endif

		_cPedido  := aCols[AZ,_nPosPed]
		_cIT      := aCols[AZ,_nPosIT]

		SC7->(dbSetOrder(1))
		If SC7->(dbSeek(xFilial("SC7")+ _cPedido + _cIT ))
			_nDesp += SC7->C7_DESPESA
		Endif

	Next AZ

	_nPedagio := MaFisRet(,"NF_DESPESA")

	If _nPedagio <> _nDesp
		MSGINFO("Valor da Despesa esta divergente (Pedido de Compra x Nota Fiscal).")
		_lRet := .F.
	Endif

	If AllTrim( cEspecie ) $ "SPED|CTE" .AND. CFORMUL <> "S"

		If Empty( aNfeDanfe[13] )
			MsgAlert( 'Deve ser informada a Chave na aba "Informações DANFE" ', 'Validação de Chave')
			_lRet := .F.
		ElseIf Len(Alltrim(aNfeDanfe[13])) < 44
			MsgAlert( 'A Chave está incompleta na aba "Informações DANFE" ', 'Validação de Chave')
			_lRet := .F.
		Else

			_lRet := U_DVNFECTE(ca100For,cLoja,cTipo,aNfeDanfe[13],cUFOri,ddEmissao,cEspecie,cSerie,cNFiscal)

	/*	 // Marcus Vinicius - 15/12/2017 - Desabilitado e criado a funcao U_DVNFECTE para substituir a validacao abaixo
		dbSelectArea("SA2")
		SA2->(dbSetOrder(1))
			If SA2->(msSeek(xFilial("SA2")+ca100For+cLoja))
			
			_cAnoMes := SubStr(aNfeDanfe[13],3,4)    	    // Ano+Mes conforme manual Nota Fiscal Eletrônica
			_cCNPJ   := SubStr(aNfeDanfe[13],7,14)    	// CNPJ Emitente conforme manual Nota Fiscal Eletrônica
			_cSerie  := Val(SubStr(aNfeDanfe[13],23,3))  	// Série da nota conforme manual Nota Fiscal Eletrônica
			_cNota   := Val(SubStr(aNfeDanfe[13],26,9))  	// Número da nota conforme manual Nota Fiscal Eletrônica
			
				If ( AllTrim(SA2->A2_CGC) == _cCNPJ ) .And. (Val(cNFiscal) == _cNota) .And. (Val(cSerie) == _cSerie ) .And. (Substr(dTos(ddEmissao),3,4) == _cAnoMes)
				_lRet := .T.
				ElseIf (Val(cNFiscal) == _cNota) .And. (Val(cSerie) == _cSerie ) .And. (Substr(dTos(ddEmissao),3,4) == _cAnoMes) .and. _cSerie >= 890 .and. _cSerie <= 899      // Marcus Vinicius - 12/09/17 - Nota fiscal avulsa
					_lRet := .T.			
				Else
					MsgAlert('A Chave está incorreta na aba "Informações DANFE" ', 'Validação de Chave')
					_lRet := .F.
				EndIf
			EndIf */
		
		Endif
	
	Endif

RestArea(_aAliSA2)
RestArea(_aAliOri)

Return(_lRet)




User Function SD1100E()

_aAliOri:= GetArea()
_aaliSC7:= SC7->(GetArea())
_aaliSD1:= SD1->(GetArea())

	If Alltrim(FunName()) = "MATA116" .And. SD1->D1_TIPO == "C"
	SC7->(dbSetOrder(1))
		IF SC7->(dbSeek(xFilial("SC7") + SD1->D1_PEDIDO + SD1->D1_ITEMPC))
		
		SC7->(Reclock("SC7",.F.))
		SC7->C7_QUJE  := SC7->C7_QUANT
		SC7->C7_ENCER := ""
		SC7->(MsUnlock())
		EndIf
	Endif

RestArea(_aAliSC7)
RestArea(_aAliSD1)
RestArea(_aAliOri)

Return


//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//				Marcus Vinicius - 15/06/2015
// 				P.E. utilizado para liberar o pedido de compra de acordo com a tabela de preço cadastrada.
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USER FUNCTION MT120FIM()

Local nOpcao	:= PARAMIXB[1]   // Opção Escolhida pelo usuario 	2 - VISUALIZA  3 - INCLUI  4 - ALTERA   5 - EXCLUI
Local cNumPC	:= PARAMIXB[2]   // Numero do Pedido de Compras
Local nOpcA		:= PARAMIXB[3]   // Indica se a ação foi "CANCELADA" = 0 ou "CONFIRMADA" = 1

_aAliOri := GetArea()
_aAliAIA := AIA->(GetArea())
_aAliAIB := AIB->(GetArea())
_aAliSA2 := SA2->(GetArea())
_aAliSC7 := SC7->(GetArea())
_aAliSCR := SCR->(GetArea())
_aAliZAH := ZAH->(GetArea())

_lLibOk	:= .F.

	If (nOpcao == 3 .OR. nOpcao == 4) .AND. nOpcA == 1
	
		If !Empty(SC7->C7_CODTAB)
		dbSelectArea("SX5")
		dBsetOrder(2)
			If dbSeek(xFilial("SX5")+"Z7"+SC7->C7_PRODUTO)
			_lLibOk := .T.
			Else
			ApMsgInfo("Produto Nao Encontrado na Tabela 'Z7', Favor Entrar em Contato com o 'TI'.")
			Endif
		
			If SC7->( MsSeek( XFILIAL("SC7") + cNumPC )) .AND. _lLibOk
				While SC7->(.NOT. Eof()) .AND. (XFILIAL("SC7") + cNumPC) == SC7->(xFilial()+C7_NUM)
				
				AIB->(dbOrderNickName("INDAIB2"))
					If AIB->(dbSeek(xFilial("AIB")+ SC7->C7_FORNECE + SC7->C7_LOJA + SC7->C7_CODTAB + SC7->C7_PRODUTO + "L"))
						If SC7->C7_PRECO > AIB->AIB_PRCCOM
						ApMsgInfo("O preço praticado NÃO está previsto para o fornecedor "+SC7->(C7_FORNECE+C7_LOJA+" e tabela "+C7_CODTAB)+". O produto "+Rtrim(SC7->C7_PRODUTO)+" não será liberado automaticamente.","PREÇO")
						Return
						Endif
						If .NOT. Posicione("AIA",1,xFilial("AIA")+SC7->(C7_FORNECE+C7_LOJA+C7_CODTAB),"(SC7->C7_EMISSAO>=AIA_DATDE .AND. SC7->C7_EMISSAO<=AIA_DATATE)")
						ApMsgInfo("A data de emissão do pedido está fora da vigência da tabela: Fornecedor: "+SC7->(C7_FORNECE+C7_LOJA+" Tabela: "+C7_CODTAB)+". O produto "+Rtrim(SC7->C7_PRODUTO)+"  não será liberado automaticamente.","VIGÊNCIA")
						Return
						Endif
					
					SC7->(RecLock("SC7",.F.))
					SC7->C7_CONAPRO := "L"
					SC7->(MsUnlock())
					
					ApMsgInfo("O pedido foi liberado pela Tabela de Preco Vigente ate:"+DTOC(AIA->AIA_DATATE)+".","LIBERADO")
					
					dbselectarea("SCR")
					SCR->(dbSetOrder(1))
						If SCR->(dbSeek(xFilial("SCR")+"PC"+SC7->C7_NUM))
						_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM
						
							While SCR->(!EOF()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM
							SCR->(RecLock("SCR",.F.))
							SCR->CR_STATUS	:= '05'      //NIVEL LIBERADO
							SCR->CR_DATALIB	:= date()	 //DATA DO SERVER
							SCR->CR_USERLIB	:= '000000' //ADMINISTRATOR
							SCR->CR_OBS		:= "LIBERADO PELA DATA DO PEDIDO (IBEC)"
							SCR->(MsUnlock())
							
							SCR->(dbSkip())
							EndDo
						Endif
					
					ZAH->(dbSetOrder(1))
						If ZAH->(dbSeek(xFilial("ZAH")+ "PC" + SC7->C7_NUM  ))
						_cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
						_cCrTipo  := ZAH->ZAH_TIPO
						_cDocSCR  := ZAH->ZAH_NUM
						
						_cCq := " DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "
						_cCq += " AND ZAH_FILIAL = '"+xFilial("ZAH")+"' "
						
						TcSqlExec(_cCq)
						Endif
					
					ELSE
					ApMsgInfo("A tabela "+SC7->C7_CODTAB+" não foi encontrada para o fornecedor: "+SC7->(C7_FORNECE+C7_LOJA)+". O produto "+Rtrim(SC7->C7_PRODUTO)+"  não será liberado automaticamente.","TABELA")
					Return
					Endif
				SC7->(dbSkip())
				EndDo
			EndiF
		Else
		SA2->(dbSetorder(1))
		SA2->(dbSeek(xFilial("SA2")+ SC7->C7_FORNECE + SC7->C7_LOJA ))
		
		SCR->(dbSetOrder(1))
			If SCR->(dbSeek(xFilial("SCR")+"PC"+SC7->C7_NUM))
			
			_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM
			
				While SCR->(!EOF()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM
				
				SCR->(RecLock("SCR",.F.))
				SCR->CR_OBS		:= SC7->C7_FORNECE + SC7->C7_LOJA+"-"+Alltrim(SA2->A2_NREDUZ)
				SCR->(MsUnlock())
				
				SCR->(dbSkip())
				EndDo
			Endif
		
		ZAH->(dbSetOrder(1))
			If ZAH->(dbSeek(xFilial("ZAH")+ "PC" + SC7->C7_NUM  ))
			
			_cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
			
				While ZAH->(!EOF()) .And. _cChavZAH == ZAH->ZAH_TIPO + ZAH->ZAH_NUM
				
				ZAH->(RecLock("ZAH",.F.))
				ZAH->ZAH_OBS	:= SC7->C7_FORNECE + SC7->C7_LOJA+"-"+Alltrim(SA2->A2_NREDUZ)
				ZAH->(MsUnlock())
				
				ZAH->(dbSkip())
				EndDo
			Endif
		Endif
	ElseIf nOpcao == 5
	
	_cDocSCR := SC7->C7_NUM
	
	_cCq := " DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = 'PC' "
	_cCq += " AND ZAH_FILIAL = '"+xFilial("ZAH")+"' "
	
	TcSqlExec(_cCq)
	
	EndIF

RestArea(_aAliAIA)
RestArea(_aAliAIB)
RestArea(_aAliSA2)
RestArea(_aAliSC7)
RestArea(_aAliSCR)
RestArea(_aAliZAH)
RestArea(_aAliOri)

RETURN
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//		Final do P.E. MT120FIM
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
Ponto de entrada adicionado por Rodrigo Feitosa (Semar) - 17/09/15 - Para tratar a geração de CTe pela Central XML
*/
User function MT116GRV()

	if IsInCallStack("u_smXMLCentral") .AND. LEN(aCols) > 0
		U_smCteAcpos()
	endif

return

/*
Ponto de entrada adicionado por Rodrigo Feitosa (Semar) - 18/09/15 - Para tratar a geração de CTe pela Central XML
*/
User Function MT103SE2

	Local aHead:= PARAMIXB[1]
	Local lVisual:= PARAMIXB[2]
	Local aRet:= {}// Customizações desejadas para adição do campo no grid de informações

	if IsInCallStack("u_smXMLCentral")
		l116Auto := .T.
	endif

Return (aRet)

/*
Ponto de entrada adicionado por Rodrigo Feitosa (Semar) - 18/09/15 - Para tratar a geração de CTe pela Central XML
*/
user function MT103NTZ()
	Local ExpC1 := ParamIxb[1]

	if IsInCallStack("u_smXMLCentral")
		if cTipo == "CTE"
			ExpC1 := cNatur
		endif
	endif

Return ExpC1


/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄt¿
//³                                                                                                        ³
//³Ponto de Entrada:                                                                                       ³
//³#############                                                                                           ³
//³                                                                                                        ³
//³Usado na validaçao de:  inclusao/alteracao/exclusao do Pedido de Compra                                 ³
//³                                                                                                        ³
//³====================================================                                                    ³
//³                                                                                                        ³
//³Sergio-SEMAR-25/10/2016 -  Vaidaçao do campo Filial de Entrega que nao pode ser vaizio                  ³
//³Funcona juntamente com parametro:  MV_PCFILEN - Utiliza filial de Entrega (T) numeracao do PC por       ³
//³--------------------------------------------------------------------------------------------------------³
//³                                                                                                        ³
//³Escreva aqui sobre uma proxima validaçao...                                                             ³
//³                                                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄtÙ
*/

User function MT120GRV()

	local lret:= .t.
	local warea:= getArea()
	LocAL _aAliSC7  := SC7->(GetArea()) //Cassiano Henrique
	Local _aAliSB1  := SB1->(GetArea()) //Cassiano Henrique

	Private _nPProduto := aScan( aHeader, { |x| Alltrim(x[2])== "C7_PRODUTO"} ) //Cassiano Henrique
	Private _nNUmsc    := aScan( aHeader, { |x| Alltrim(x[2])== "C7_NUMSC"} )   //Cassiano Henrique

	_cProduto := Acols[N,_nPProduto]
	_nNumSC   := Acols[N,_nNUmsc]

	if !empty(xfilial('SC7')) .and. empty( cFilialEnt )
		alert(  'O campo [Filial Entrega], deve ser preenchido!   Usar filial corrente!!! ' )
		lret:=.f.
	endif

/*
	If SuperGetMv( "MZ_VLPCSC" , .F. , "" ,) //Em stand by Cassiano Henrique - 01/10/2019
		IF Upper(GetEnvServer()) $ 'COMPRAS'
		SC7->(DbSetOrder(1))
		SB1->(DbSetOrder(1))
			If SB1->(Msseek(xFilial("SB1") + _cProduto))
				If Left(SB1->B1_GRUPO,4) >= 'M004' .And. Left(SB1->B1_GRUPO,1) <> 'P' .And. Empty(_nNUmsc)
				MsgAlert(" Para produtos do grupo: " + SB1->B1_GRUPO + " é necessário que o pedido de compras tenha uma SC vinculada! ")
				lret:= .F.
				Endif
			Endif
		Endif
	Endif

*/
	restArea(warea)
	RestArea(_aAliSC7)
	RestArea(_aAliSB1)

return (lret)



/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄt¿
//³                                                                                                        ³
//³Ponto de Entrada:                                                                                       ³
//³#############                                                                                           ³
//³                                                                                                        ³
//³Usado no filtro do programa MATA103										                               ³
//³                                                                                                        ³
//³====================================================                                                    ³
//³                                                                                                        ³
//³Marcus Vinicius-24/02/2017 -  Filtro a ser utilizado quando a rotina MATA103Y estiver em execução	   ³
//³                                                                                                        ³
//³--------------------------------------------------------------------------------------------------------³
//³                                                                                                        ³
//³Escreva aqui sobre uma proxima validaçao...                                                             ³
//³                                                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄtÙ
*/

User Function M103FILB()
	Local cFiltro	:= ''

	If FUNNAME() == 'MATA103Y'
		cFiltro += " F1_FILIAL = '"+xFilial("SF1")+"' AND F1_STATUS = '' AND F1_DTDIGIT >= '"+DTOS(dDtIni)+"' "
	EndIf

Return cFiltro


/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄt¿
//³                                                                                                                        ³
//³Ponto de Entrada:  A103VLR                                                                                              ³
//³#############                                                                                                           ³
//³                                                                                                                        ³
//³========================================================================================================================³
//³Marcus Vinicius-27/12/2017                                                                                              ³
//³http://tdn.totvs.com/display/public/PROT/A103VLR+-+Utilizado+para+alterar+o+valor+da+duplicata+na+nota+Fiscal+de+Entrada³
//³LOCALIZAÇÃO:	Function NfeRFldFin - Rotina de atualizacao dos dados do folder financeiro do documento de entrada.        ³
//³EM QUE PONTO: Este Ponto de Entrada é utilizado para alterar o valor da duplicata na nota fiscal de entrada.            ³
//³MZ_PEDGFOR: Parâmetro que contém os fornecedores com acordo comercial referente a pedágio                               ³
//³------------------------------------------------------------------------------------------------------------------------³
//³                                                                                                                        ³
//³Escreva aqui sobre uma proxima validaçao...                                                                             ³
//³                                                                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄtÙ
*/

User Function A103VLR()

	local i
	Local nValDupli	:= MaFisRet(,"NF_BASEDUP")
	Local nTotBruto	:= MaFisRet(,"NF_TOTAL")

	_aAliOri := GetArea()
	_aPedagFor := StrToKarr(UPPER(GetMv("MZ_PEDGFOR")),";")

	If nValDupli > 0 .and. aNFeDanfe[15] > 0 //Verifica se o valor da duplicata e o campo de pedágio são maior que zero
		For i:=1 to Len(_aPedagFor)
			If TRIM(ca100For+cLoja) == TRIM(_aPedagFor[i])
				If MaFisFound()
					If aNFeDanfe[15] > 0
						nValDupli :=  nTotBruto - aNFeDanfe[15]
					EndIf
				EndIf
			EndIf
		Next i
	EndIf

	RestArea(_aAliOri)

Return nValDupli



/*/{Protheus.doc} MT160GRPC
Gravação de valores e campos no pedido de compras. Executado durante a geração do pedido de compra na análise da cotação.
@type Ponto de Entrada
@version 001
@author Fabiano
@since 04/03/2020
/*/
User Function MT160GRPC()

	Local _aArea    := GetArea()

	IF SC7->(FieldPos("C7_YTAGMAE")) > 0 .And. SC1->(FieldPos("C1_YTAGMAE")) > 0
		SC1->(dbsetOrder(1))
		IF SC1->(msSeek(xFilial("SC1")+SC8->C8_NUMSC+SC8->C8_ITEMSC))
			SC7->C7_YTAGMAE := SC1->C1_YTAGMAE
		ENDIF
	ENDIF

	RestArea(_aArea)

Return(NIL)



/*/{Protheus.doc} MT120ISC
Manipula o acols do pedido de compras
@type Ponto de Entrada
@version 001
@author Fabiano
@since 04/03/2020
/*/
User Function MT120ISC()

	Local _nPTag    := aScan(aHeader,{|x| AllTrim(x[2])=="C7_YTAGMAE"})

	If nTipoPed ==1 //Variavel que contem o tipo do pedido(1=Sc 2= Contrato de parceria)
		aCols[n][_nPTag]  := SC1->C1_YTAGMAE
	EndIf

Return(Nil)