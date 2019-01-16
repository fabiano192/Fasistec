#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ F290FIL  ³ Autor ³ Alexandro da Silva    ³ Data ³ 18/08/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada no Financeiro                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Faturas a Pagar                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function F240BORD()

	_aAliOri := GetArea()
	_aALiSAL := SAL->(GetARea())
	_aALiSCR := SCR->(GetARea())
	_aALiSE2 := SE2->(GetARea())
	_aALiSEA := SEA->(GetARea())
	_aALiSY1 := SY1->(GetARea())

	_cFilSEA := SEA->EA_FILIAL
	_cNumBor := SEA->EA_NUMBOR
	_nVlBor  := 0

	_cGrAprov:= GetNewPar("BRI_GRAPRO","000002")

	SAL->(dbSetOrder(2))
	If SAL->(!dbSeek(xFilial() + _cGrAprov))
		MSGSTOP("Grupo Nao Cadastrado, Favor Contatar o Administrador do Sistema!")
		Return
	EndIf

	SEA->(dbSetOrder(2))
	If SEA->(dbSeek(_cFilSEA + _cNumBor + "P"))

		While SEA->(!Eof()) .And. _cNumBor == SEA->EA_NUMBOR

			SE2->(dbSetOrder(1))
			//If SE2->(dbSeek(xFilial("SE2")+ SEA->EA_PREFIXO + SEA->EA_NUM + SEA->EA_PARCELA +SEA->EA_TIPO + SEA->EA_FORNECE + SEA->EA_LOJA))
			If SE2->(dbSeek(SEA->EA_FILORIG + SEA->EA_PREFIXO + SEA->EA_NUM + SEA->EA_PARCELA +SEA->EA_TIPO + SEA->EA_FORNECE + SEA->EA_LOJA))
				_nVlBor += SE2->E2_SALDO
			Endif

			SEA->(dbSkip())
		EndDo
	Endif

	SCR->(dbSetOrder(1))
	If SCR->(dbSeek(_cFILSEA +"06"+ _cNumBor))

		_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM

		While SCR->(!Eof())	.And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM

			ZAH->(dbSetOrder(2))
			If ZAH->(dbSeek(SCR->CR_FILIAL + SCR->CR_TIPO + SCR->CR_NUM + SCR->CR_USER))
				ZAH->(RecLock("ZAH",.F.))
				ZAH->(DbDelete())
				ZAH->(MsUnlock())
			Endif

			SCR->(RecLock("SCR",.F.))
			SCR->(dbDelete())
			SCR->(MsUnlock())

			SCR->(dbSkip())
		EndDo
	Endif

	lFirstNiv   := .T.
	cAuxNivel   := ""
	_lLibera    := .T.

	SAL->(dbSetOrder(2))
	If SAL->(dbSeek(xFilial() + _cGrAprov))

		While SAL->(!Eof()) .And. xFilial("SAL") + _cGrAprov == SAL->AL_FILIAL+SAL->AL_COD

			If lFirstNiv
				cAuxNivel := SAL->AL_NIVEL
				lFirstNiv := .F.
			EndIf

			SCR->(Reclock("SCR",.T.))
			SCR->CR_FILIAL	:= _cFILSEA
			SCR->CR_NUM		:= _cNumBor
			SCR->CR_TIPO	:= "06"
			SCR->CR_NIVEL	:= SAL->AL_NIVEL
			SCR->CR_USER	:= SAL->AL_USER
			SCR->CR_APROV	:= SAL->AL_APROV
			SCR->CR_STATUS	:= "02"
			SCR->CR_EMISSAO := dDataBase
			SCR->CR_MOEDA	:= 1
			SCR->CR_TXMOEDA := 1
			SCR->CR_OBS     := Alltrim(SM0->M0_NOME) +" - BORDERO DE PAGAMENTO "
			SCR->CR_TOTAL	:= _nVlBor
			SCR->(MsUnlock())

			ZAH->(RecLock("ZAH",.T.))
			ZAH->ZAH_FILIAL:= _cFILSEA
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
			ZAH->ZAH_OBS   := SCR->CR_OBS
			ZAH->ZAH_TOTAL := SCR->CR_TOTAL
			ZAH->(MsUnlock())

			SAL->(dbSkip())
		EndDo
	EndIf

	RestArea(_aAliSAL)
	RestArea(_aAliSCR)
	RestArea(_aAliSE2)
	RestArea(_aAliSEA)
	RestArea(_aAliSY1)
	RestArea(_aAliOri)

Return

User Function F240OK()

	_aAliOri := GetArea()
	_aAliSCR := SCR->(GetArea())

	SCR->(dbSetOrder(1))
	If SCR->(dbSeek(SEA->EA_FILIAL +"06" + SEA->EA_NUMBOR ))

		_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM

		While SCR->(!Eof())	.And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM

			ZAH->(dbSetOrder(2))
			If ZAH->(dbSeek(SCR->CR_FILIAL + SCR->CR_TIPO + SCR->CR_NUM + SCR->CR_USER))
				ZAH->(RecLock("ZAH",.F.))
				ZAH->(DbDelete())
				ZAH->(MsUnlock())
			Endif

			SCR->(RecLock("SCR",.F.))
			SCR->(dbDelete())
			SCR->(MsUnlock())

			SCR->(dbSkip())
		EndDo
	Endif

	RestArea(_aAliSCR)
	RestArea(_aAliOri)

Return(.T.)

User Function F240TIT()

	U_ASI003(.T.)

Return(.T.)


User Function F280PCAN()

	_lRet := .T.

	//If !Empty(SE1->E1_LA)
	//	MSGINFO("Cancelamento Nao Permitido, Duplicata Ja contabilizada!")
	//	_lRet := .F.
	//Else
	U_GRLOG(Procname(),cModulo,__CUSERID,Ddatabase,Time(),cEmpAnt,cFilAnt)
	//Endif

Return(_lRet)


User Function F050ALT()

	_aAliOri := GetArea()
	_aAliSE2 := SE2->(GetArea())

	If Alltrim(FunName()) $ "MATA952/MATA953" // APURAÇÃO DO IPI E APURAÇAÕ DO ICMS

		SE2->(RecLock("SE2",.F.))
		SE2->E2_DATALIB := dDataBase
		SE2->E2_USUALIB := cUsername
		SE2->E2_FILORIG := cFilAnt
		SE2->E2_DATALIB := dDataBase
		SE2->E2_USUALIB := cUsername
		SE2->(MsUnlock())
	Endif

	RestArea(_aAliSE2)
	RestArea(_aAliORI)

Return


User Function CPAPUICMS()

	SE2->E2_DATALIB := dDataBase
	SE2->E2_USUALIB := cUsername
	SE2->E2_FILORIG := cFilAnt

Return



User Function GP670CPO()

	_aAliOri := GetArea()

	SE2->(RecLock("SE2",.F.))
	SE2->E2_DATALIB := dDataBase
	SE2->E2_USUALIB := cUsername
	SE2->E2_FILORIG := cFilAnt
	SE2->(MsUnlock())

	RestArea(_aAliOri)

Return


User function FA290()

	SE2->(Reclock("SE2",.f.))
	SE2->E2_DATALIB	:= dDataBase
	SE2->E2_USUALIB   := cUsername
	SE2->(MsUnlock())

Return


User Function FA050GRV()

	Private _cAliOri:= GetArea()
	Private _cAliSE2:= SE2->(GetArea())

	If Alltrim(FunName()) $ "GPEM670"
		SE2->(RecLock("SE2",.F.))
		SE2->E2_DATALIB := dDataBase
		SE2->E2_USUALIB := cUsername
		SE2->E2_FILORIG := cFilAnt
		SE2->(MsUnlock())
	Endif

Return


User Function GP670ARR()

	_aAliOri:= GetArea()

	_aRet := {{"E2_HIST"	, RC1->RC1_YHIST, NIL}}

	RestArea(_aAliOri)

Return(_aRet)


User Function F420SOMA()

	_nSoma := SE2->E2_SALDO + SE2->E2_ACRESC - SE2->E2_DECRESC

Return(_nSoma)

/*
User Function FA430PA()

Local _aAliOri:= GetArea()
Local _cTipo  := PARAMIXB

_lRet := .T.

If _cTipo = "PA"
_lRet := .F.
Endif

RestArea(_aAliOri)

Return(_lRet)
*/

/*
User Function FIN420_1()  // COMENTADO EM 09/05/17 estava limpando indevidamente o campo de controle

_aAliOri := GetArea()
_aAliSE2 := SE2->(GetArea())

If !Empty(SE2->E2_IDCNAB)
SE2->(RecLock("SE2",.F.))
SE2->E2_IDCNAB := ""
SE2->(MsUnlock())
Endif

RestArea(_aAliSE2)
RestArea(_aAliOri)

Return
*/
User Function F060ACT()

	_aAliOri := GetArea()
	_aAliZA6 := ZA6->(GetArea())

	_cSituac := Left(ParamIXB[1][1],1)
	_cSitAnt := ParamIXB[1][8]

	If SE1->E1_SITUACA == "Z"

		_cChav := SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_CLIENTE + SE1->E1_LOJA + SE1->E1_TIPO + "TR"

		ZA6->(dbSetOrder(1))
		ZA6->(dbSeek(SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_CLIENTE + SE1->E1_LOJA + SE1->E1_TIPO + "TR"+"99",.T.))

		ZA6->(dbSkip(-1))

		If _cChav == ZA6->ZA6_FILIAL + ZA6->ZA6_PREFIX + ZA6->ZA6_NUM + ZA6->ZA6_PARCEL + ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA + ZA6->ZA6_TIPO + "TR"
			_cSeq := Soma1(ZA6->ZA6_SEQ)
		Else
			_cSeq := "01"
		Endif

		ZA6->(RecLock("ZA6",.T.))
		ZA6->ZA6_FILIAL := SE1->E1_FILIAL
		ZA6->ZA6_PREFIX := SE1->E1_PREFIXO
		ZA6->ZA6_NUM    := SE1->E1_NUM
		ZA6->ZA6_PARCEL := SE1->E1_PARCELA
		ZA6->ZA6_TIPO   := SE1->E1_TIPO
		ZA6->ZA6_CLIENT := SE1->E1_CLIENTE
		ZA6->ZA6_LOJA   := SE1->E1_LOJA
		ZA6->ZA6_NATURE := SE1->E1_NATUREZA
		ZA6->ZA6_PORTAD := SE1->E1_PORTADO
		ZA6->ZA6_EMISSA := SE1->E1_EMISSAO
		ZA6->ZA6_VENCTO := SE1->E1_VENCTO
		ZA6->ZA6_VENCRE := SE1->E1_VENCREA
		ZA6->ZA6_VALOR  := SE1->E1_VALOR
		ZA6->ZA6_DTTRAN := dDataBase
		ZA6->ZA6_SITUAC := "Z"
		ZA6->ZA6_SALDO  := SE1->E1_SALDO
		ZA6->ZA6_TPDOC  := "TR"
		ZA6->ZA6_SEQ    := _cSeq
		ZA6->(MsUnlock())
	Else
		If _cSitAnt == "Z"
			_cChav := SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_CLIENTE + SE1->E1_LOJA + SE1->E1_TIPO + "ES"
			ZA6->(dbSetOrder(1))
			ZA6->(dbSeek(SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_CLIENTE + SE1->E1_LOJA + SE1->E1_TIPO + "ES"+"99",.T.))

			ZA6->(dbSkip(-1))

			If _cChav == ZA6->ZA6_FILIAL + ZA6->ZA6_PREFIX + ZA6->ZA6_NUM + ZA6->ZA6_PARCEL + ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA + ZA6->ZA6_TIPO + ZA6->ZA6_TPDOC
				_cSeq := Soma1(ZA6->ZA6_SEQ)
			Else
				_cSeq := "01"
			Endif

			ZA6->(RecLock("ZA6",.T.))
			ZA6->ZA6_FILIAL := SE1->E1_FILIAL
			ZA6->ZA6_PREFIX := SE1->E1_PREFIXO
			ZA6->ZA6_NUM    := SE1->E1_NUM
			ZA6->ZA6_PARCEL := SE1->E1_PARCELA
			ZA6->ZA6_TIPO   := SE1->E1_TIPO
			ZA6->ZA6_CLIENT := SE1->E1_CLIENTE
			ZA6->ZA6_LOJA   := SE1->E1_LOJA
			ZA6->ZA6_NATURE := SE1->E1_NATUREZA
			ZA6->ZA6_PORTAD := SE1->E1_PORTADO
			ZA6->ZA6_EMISSA := SE1->E1_EMISSAO
			ZA6->ZA6_VENCTO := SE1->E1_VENCTO
			ZA6->ZA6_VENCRE := SE1->E1_VENCREA
			ZA6->ZA6_VALOR  := SE1->E1_VALOR
			ZA6->ZA6_DTTRAN := dDataBase
			ZA6->ZA6_SITUAC := "Z"
			ZA6->ZA6_SALDO  := SE1->E1_SALDO
			ZA6->ZA6_TPDOC  := "ES"
			ZA6->ZA6_SEQ    := _cSeq
			ZA6->(MsUnlock())
		Endif
	Endif

	RestArea(_aAliZA6)
	RestArea(_aAliOri)

Return


User Function FA070TIT()

	_aAliori := GetArea()
	_lRet    := .T.

	If SE1->E1_SITUACA == "Z"
		MSGINFO("Favor Transferir o Titulo para carteira Antes de Baixar!!")
		_lRet := .F.
	Endif

	RestArea(_aAliOri)

Return(_lRet)


User Function FA070BCO()

	_aAliori := GetArea()
	_aAliSA6 := SA6->(GetArea())
	_lRet    := .T.

	If cEmpAnt $ "02/50"
		If !Empty(cBanco) .And. !Empty(cAgencia) .And. !Empty(cConta)
			SA6->(dbSetOrder(1))
			If SA6->(dbSeek(xFilial("SA6")+cBanco + cAgencia + cConta))
				If SA6->A6_YEMP <> "99"
					If SA6->A6_YEMP <> cFilAnt
						_lRet := .F.
						MsgAlert("Banco Selecioando Não Pertence a Filial Corrente!!")
					Endif
				Endif
			Endif
		Endif
	Endif

	RestArea(_aAliSA6)
	RestArea(_aAliOri)

Return(_lRet)


User Function FA080BCO()

	_aAliori   := GetArea()
	_aAliSA6   := SA6->(GetArea())
	_lRet      := .T.

	_cBanco    := PARAMIXB[1]
	_cAgencia  := PARAMIXB[2]
	_cConta    := PARAMIXB[3]

	If cEmpAnt $  "02/50"
		If !Empty(_cBanco) .And. !Empty(_cAgencia) .And. !Empty(_cConta)
			SA6->(dbSetOrder(1))
			If SA6->(dbSeek(xFilial("SA6")+cBanco + cAgencia + cConta))
				If SA6->A6_YEMP <> "99"
					If SA6->A6_YEMP <> cFilAnt
						_lRet := .F.
						MsgAlert("Banco Selecioando Não Pertence a Filial Corrente!!")
					Endif
				Endif
			Endif
		Endif
	Endif

	RestArea(_aAliSA6)
	RestArea(_aAliOri)

Return(_lRet)


User Function F420FIL()

	Local cFiltro := ''
	Local warea   := getArea()

	Pergunte("AFI420",.F.)

	_cQ := " SELECT * FROM "+RetSqlName("SEA")+" A "
	_cQ += " WHERE A.D_E_L_E_T_ = '' AND EA_CART = 'P' "
	_cQ += " AND EA_NUMBOR  BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	_cQ += " AND EA_FILORIG BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' "
	_cQ += " ORDER BY EA_FILIAL,EA_NUMBOR "

	TCQUERY _cQ NEW ALIAS "ZEA"

	cBordNAO:= ''
	cBordSIM:= ''
	_cBord  := "('"
	_ncont  := 1

	ZEA->(dbGotop())

	While ZEA->(!Eof())

		If cEmpAnt+ZEA->EA_FILIAL $ "5012"
			If !Empty(ZEA->EA_YLIB01) .Or. !Empty(ZEA->EA_YLIB02)
				cBordSIM+= If ( Alltrim(ZEA->EA_NUMBOR) $ cBordSIM,"","/"+Alltrim(ZEA->EA_NUMBOR) )
			Else
				cBordNAO+= If ( Alltrim(ZEA->EA_NUMBOR) $ cBordNAO,"","/"+Alltrim(ZEA->EA_NUMBOR) )
			Endif
		Else
			If Empty(ZEA->EA_YLIB01) .Or. Empty(ZEA->EA_YLIB02)
				cBordNAO+= If ( Alltrim(ZEA->EA_NUMBOR) $ cBordNAO,"","/"+Alltrim(ZEA->EA_NUMBOR) )
			Else
				cBordSIM+= If ( Alltrim(ZEA->EA_NUMBOR) $ cBordSIM,"","/"+Alltrim(ZEA->EA_NUMBOR) )
			Endif
		Endif

		ZEA->(dbskip())
	EndDo

	ZEA->(dbCloseArea())

	If !Empty(cbordNAO)
		Alert("Liberação incompleta para o Bordero ["+cbordNAO+"]")
	Endif

	cfiltro:= "E2_FILIAL=='XX'"

	If !Empty(cBordSIM)
		cfiltro:= "E2_NUMBOR $ '"+Alltrim(cBordSIM)+"'"
	Endif

	Restarea(warea)

Return cFiltro

User Function F240BOR()

	_lRet := .F.

Return(_lRet)



User Function FA050INC()

	_aAliori := GetArea()
	_aAliSE2 := SE2->(GetArea())

	U_GRLOG(Procname(),cModulo,__CUSERID,Ddatabase,Time(),cEmpAnt,cFilAnt)

	RestArea(_aAliSE2)
	RestArea(_aAliori)

Return .T.

User Function F050INC()

	_aAliori := GetArea()
	_aAliSE2 := SE2->(GetArea())

	If SE2->E2_TIPO = "PA"

		If MsgYesNo("Adiantamento Será Enviado Para o Banco?. Confirma?")  // 1= Gera Mov. Sem Cheque e 2= Nao Gera Movim. Sem Cheque

			MV_PAR09 := 2

			SE2->(RecLock("SE2",.F.))
			SE2->E2_EMISSAO := SE2->E2_VENCREA
			SE2->E2_EMIS1   := SE2->E2_VENCREA
			SE2->E2_YPACNAB := "1"
			SE2->(MsUnlock())
		Else
			MV_PAR09 := 1

			SE2->(RecLock("SE2",.F.))
			SE2->E2_YPACNAB := "2"
			SE2->(MsUnlock())
		Endif

		/*
		If MV_PAR09 ==  2
		SE2->(RecLock("SE2",.F.))
		SE2->E2_EMISSAO := SE2->E2_VENCREA
		SE2->E2_EMIS1   := SE2->E2_VENCREA
		SE2->(MsUnlock())
		Endif
		*/
	Endif

	RestArea(_aAliSE2)
	RestArea(_aAliori)

Return .T.

User Function F590CAN()

	_aAliOri := GetArea()
	_aAliSCR := SCR->(GetArea())
	_aAliZAH := ZAH->(GetArea())

	_cNumBor := ParamIXB[2]

	SCR->(dbSetOrder(1))
	If SCR->(dbSeek(SEA->EA_FILIAL +"06"+_cNumBor))

		_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM

		While SCR->(!Eof())	.And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM

			ZAH->(dbSetOrder(2))
			If ZAH->(dbSeek(SCR->CR_FILIAL + SCR->CR_TIPO + SCR->CR_NUM + SCR->CR_USER))
				ZAH->(RecLock("ZAH",.F.))
				ZAH->(DbDelete())
				ZAH->(MsUnlock())
			Endif

			SCR->(RecLock("SCR",.F.))
			SCR->(dbDelete())
			SCR->(MsUnlock())

			SCR->(dbSkip())
		EndDo
	Endif

	RestArea(_aAliSCR)
	RestArea(_aAliZAH)
	RestArea(_aAliOri)

Return()

User Function FA100TRF()

	_aAliOri := GetArea()
	_aAliSA6 := SA6->(GetArea())

	_lRet    := .T.

	_cBcoOri := PARAMIXB[1]
	_cAgeOri := PARAMIXB[2]
	_cCtaOri := PARAMIXB[3]

	_cBcoDes := PARAMIXB[4]
	_cAgeDes := PARAMIXB[5]
	_cCtaDes := PARAMIXB[6]

	If cEmpAnt $ "02/50"
		SA6->(dbSetorder(1))
		If SA6->(dbSeek(xFilial("SA6") + _cBcoOri + _cAgeOri + _cCtaOri ))
			If SA6->A6_YEMP <> "99"
				If SA6->A6_YEMP <> cFilAnt
					_lRet := .F.
					MsgAlert("Banco Origem Não Pertence a Filial Corrente. Favor Refazer a Operação!!")
				Endif
			Endif
		Endif

		If _lRet
			SA6->(dbSetorder(1))
			If SA6->(dbSeek(xFilial("SA6") + _cBcoDes + _cAgeDes + _cCtaDes ))
				If SA6->A6_YEMP <> "99"
					If SA6->A6_YEMP <> cFilAnt
						_lRet := .F.
						MsgAlert("Banco Destino Não Pertence a Filial Corrente. Favor Refazer a Operação!!")
					Endif
				Endif
			Endif
		Endif
	Endif

	RestArea(_aAliSA6)
	RestArea(_aAliOri)

Return(_lRet)

/*
User Function F030FILT()

cQuery := ""
//aEval(aStru,{|x| cQuery += ","+AllTrim(x[1])})
//cCpoDisp := SubStr(cQuery,2)

cQuery := " SELECT * "//+SubStr(cQuery,2)
cQuery += " FROM "+RetSqlName("SE2")+" SE2,"
cQuery += RetSqlName("SE5")+" SE5 "
cQuery += " WHERE SE2.E2_FILIAL = '" + Space(TamSx3("E2_FILIAL")[1]) + "' AND "
cQuery += " SE2.E2_FORNECE='"+SA2->A2_COD+"' AND "
cQuery += " SE2.E2_LOJA='"+SA2->A2_LOJA+"' AND "
cQuery += " SE2.E2_EMISSAO>='"+Dtos(mv_par01)+"' AND "
cQuery += " SE2.E2_EMISSAO<='"+Dtos(mv_par02)+"' AND "
cQuery += " SE2.E2_VENCREA>='"+Dtos(mv_par03)+"' AND "
cQuery += " SE2.E2_VENCREA<='"+Dtos(mv_par04)+"' AND "

If mv_par05 == 2
cQuery +=   "SE2.E2_TIPO NOT IN "+FormatIn(MVPROVIS,";")+" AND "
EndIf

If mv_par06 == 2
cQuery += " SE2.E2_FATURA IN('"+Space(Len(SE2->E2_FATURA))+"','NOTFAT') AND "
Endif

cQuery += "SE2.E2_TIPO NOT IN " + FormatIn(MVABATIM,";") +" AND "
cQuery += "SE2.E2_TIPO NOT IN " + FormatIn(MVRECANT+";"+MV_CRNEG+";"+MV_CPNEG,";")+" AND "
cQuery += "SE2.E2_VALOR != SE2.E2_SALDO AND "
cQuery += "SE2.D_E_L_E_T_=' ' AND "
nPosAlias := VERFIL(1,"SE5")
cQuery += "SE5.E5_FILIAL " + aTmpFil[nPosAlias,2] + " AND "
cQuery += "SE5.E5_PREFIXO=SE2.E2_PREFIXO AND "
cQuery += "SE5.E5_NUMERO=SE2.E2_NUM AND "
cQuery += "SE5.E5_PARCELA=SE2.E2_PARCELA AND "
cQuery += "SE5.E5_TIPO=SE2.E2_TIPO AND "
cQuery += "SE5.E5_CLIFOR=SE2.E2_FORNECE AND "
cQuery += "SE5.E5_LOJA=SE2.E2_LOJA AND "
cQuery += "SE5.E5_RECPAG='P' AND "
cQuery += "SE5.E5_SITUACA!='C' AND "
cQuery += "SE5.E5_TIPODOC IN ('BA','VL','CP') AND "
cQuery += "SE5.D_E_L_E_T_=' ' AND NOT EXISTS ("
cQuery += "SELECT A.E5_NUMERO "
cQuery += "FROM "+RetSqlName("SE5")+" A "
cQuery += "WHERE "
nPosAlias := VERFIL(1,"SE5")
cQuery += " A.E5_FILIAL " + aTmpFil[nPosAlias,2] + " AND "
cQuery += "A.E5_PREFIXO=SE5.E5_PREFIXO AND "
cQuery += "A.E5_NUMERO=SE5.E5_NUMERO AND "
cQuery += "A.E5_PARCELA=SE5.E5_PARCELA AND "
cQuery += "A.E5_TIPO=SE5.E5_TIPO AND "
cQuery += "A.E5_CLIFOR=SE5.E5_CLIFOR AND "
cQuery += "A.E5_LOJA=SE5.E5_LOJA AND "
cQuery += "A.E5_SEQ=SE5.E5_SEQ AND "
cQuery += "A.E5_TIPODOC='ES' AND "
cQuery += "A.E5_RECPAG!='P' AND "
cQuery += "A.E5_DATA<='"+DtoS(dDataBase)+"' AND "
cQuery += "A.D_E_L_E_T_=' ')"
cOrder := SqlOrder(IndexKey())
cQuery += " ORDER BY " + cOrder

cQuery := ChangeQuery(cQuery)

Return
*/
Static Function VERFIL(nAcao,cAliasFil)

	Local nPosAlias		:= 0
	Local cTmpFil		:= ""

	Default cAliasFil	:= ""
	Default nAcao		:= 2
	aTmpFil := {}
	If nAcao == 1
		If !Empty(cAliasFil)
			nPosAlias := Ascan(aTmpFil,{|carq| carq[1] == cAliasFil})
			If nPosAlias == 0
				Aadd(aTmpFil,{"","",""})
				nPosAlias := Len(aTmpFil)
				aTmpFil[nPosAlias,1] := cAliasFil
				MsgRun("Favor Aguardar.....","Consulta Posição fornecedores" ,{|| aTmpFil[nPosAlias,2] := VERFIL02(aSelFil,cAliasFil,.T.,@cTmpFil)})
				aTmpFil[nPosAlias,3] := cTmpFil
			Endif
		Endif
	Else
		If nAcao == 2
			If !Empty(aTmpFil)
				MsgRun("Favor Aguardar.....","Consulta Posição fornecedores" ,{|| AEval(aTmpFil,{|tmpfil| CtbTmpErase(tmpFil[3])})})
				nPosAlias := Len(aTmpFil)
				aTmpFil := {}
				aSelFil := {}
			Endif
		Endif
	Endif

	If nAcao == 1
		If ((Empty(aTmpFil[1,2]) .OR. aTmpFil[1,2] == " = '  ' ") .and. FWModeAccess(cAliasFil,1) == "E")
			aTmpFil[1,2] := (AllTrim("0" + AllTrim(STR((Len(aTmpFil))))))
			aTmpFil[1,2] := " = '" + aTmpFil[1,2] + "'"
		EndIf
	EndIf

Return(nPosAlias)


Static Function VERFIL02( xSelFil , cAlias, lTmpFil, cTmpFil, nLimTmp )

	Local cRetorno 		:= ""
	Local aArea			:= GetArea()
	Local nX			:= 0
	Local aStruct 		:= {}
	Local nTamFil 		:= CtbTamSXG("033",2)  //grupo ; tamanho padrao
	Local lGestao		:= .F. //Iif( lFWCodFil, ( LEN(CT2->CT2_FILIAL) > 2 ), .F. )	// Indica se usa Gestao Corporativa
	Local aModoComp 	:= {}
	Local lExclusivo 	:= .F.
	Local cFilCpy
	Local cAtualxFil

	Default lTmpFil := .F.
	Default nLimTmp := 50

	If lFWCodFil .And. lGestao
		aAdd(aModoComp, FWModeAccess(cAlias,1) )
		aAdd(aModoComp, FWModeAccess(cAlias,2) )
		aAdd(aModoComp, FWModeAccess(cAlias,3) )
		lExclusivo := Ascan(aModoComp, 'E') > 0
	Else
		dbSelectArea(cAlias)
		lExclusivo := !Empty(xFilial(cAlias))
	EndIf

	If Valtype(xSelFil) == "A"
		If lExclusivo //cAlias em modo exclusivo
			If lTmpFil .And. Len(xSelFil) > nLimTmp //50 //SOMENTE ACIMA DE 50 FILIAIS CRIA ARQUIVO TEMPORARIO NO BANCO
				//cria arquivo temporario no banco de Dados que contera as filiais
				cTmpFil := CriaTrab(,.F.)
				CtbTmpErase(cTmpFil)
				aStruct:= {}
				aAdd(aStruct, { "TMPFIL", "C", nTamFil, 0 } )
				MsCreate(cTmpFil,aStruct, "TOPCONN")
				Sleep(1000)
				dbUseArea(.T., "TOPCONN",cTmpFil,cTmpFil/*cAlias*/,.T.,.F.)
				// Cria o indice temporario
				IndRegua(cTmpFil/*cAlias*/,cTmpFil+"A","TMPFIL",,)
				If lFWCodFil .And. lGestao
					cFilCpy := cFilAnt
					//laco para percorrer todas as filiais selecionadas
					For nX := 1 to Len(xSelFil)
						cFilAnt := xSelFil[nX]
						dbSelectArea(cAlias)
						cAtualxFil := xFilial(cAlias)
						dbSelectArea(cTmpFil)
						//popula arquivo temporario no banco
						If !Empty(cAtualxFil) .And. !dbSeek(cAtualxFil)
							RecLock(cTmpFil, .T.)
							(cTmpFil)->TMPFIL := cAtualxFil
							MsUnlock()
						EndIf
					Next nX
					//restaura empresa/filial posicionada antes do laco
					cFilAnt := cFilCpy
				Else
					//popula arquivo temporario no banco
					For nX := 1 to Len(xSelFil)
						RecLock(cTmpFil, .T.)
						(cTmpFil)->TMPFIL := xSelFil[nX]
						MsUnlock()
					Next nX
				EndIf
				cRetorno := "IN ( SELECT TMPFIL FROM " + cTmpFil + " ) "
			ElseIf Len(xSelFil) > 1
				If lFWCodFil .And. lGestao
					cFilCpy := cFilAnt
					For nX := 1 to Len(xSelFil)
						cFilAnt := xSelFil[nX]
						dbSelectArea(cAlias)
						cAtualxFil := xFilial(cAlias)
						cRetorno += cAtualxFil + "\"
					Next nX
					cRetorno := Left(cRetorno, Len(cRetorno) - 1 )
					cRetorno := "IN " + FormatIn(cRetorno,"\") + " "
					cFilAnt := cFilCpy
				Else
					For nX := 1 to Len(xSelFil)
						cRetorno += xSelFil[nX] + "\"
					Next nX
					cRetorno := Left(cRetorno, Len(cRetorno) - 1 )
					cRetorno := "IN " + FormatIn(cRetorno,"\") + " "
				EndIf
			Else
				If lFWCodFil .And. lGestao
					cFilCpy := cFilAnt
					If Len(xSelFil) > 0
						cFilAnt := xSelFil[1]
					EndIf
					dbSelectArea(cAlias)
					cAtualxFil := xFilial(cAlias)
					cRetorno := " = '" + cAtualxFil + "' "
					cFilAnt := cFilCpy
				Else
					If Len(xSelFil) > 0
						cRetorno := " = '" + xSelFil[1] + "' "
					Else
						cRetorno := " = '" + xFilial(cAlias) + "' "
					EndIf
				EndIf
			EndIf
		Else
			//cAlias em modo compartilhado
			dbSelectArea(cAlias)
			cRetorno := " = '" + xFilial(cAlias) + "' "
		EndIf

	Else
		cRetorno := " = '" + xFilial(cAlias,xSelFil) + "' "
	EndIf

	RestArea(aArea)

RETURN cRetorno
/*
User Function FA280QRY()

_aAliOri := GetArea()

_cQ := "E1_NUMBCO = '' "

RestArea(_aAliOri)

Return(_cQ)
*/

User Function FC010BRW()

	Aadd(aRotina,{"Ref.Comerciais","U_BRI104()", 0 , 6})

Return(Nil)




User Function M040SE1()

	_aAliOri := GetArea()
	_aAliSE1 := SE1->(GetArea())

	If Val(SE4->E4_COND) = 0
		SE1->(RecLock("SE1",.F.))
		SE1->E1_FORMREC := "00"
		SE1->(MsUnlock())
	Endif

	//MSGINFO("Ponto M040SE1!!")


	If SE1->E1_TIPO = 'NF'

		/*
		O Código será composto de 13 caracteres
		Filial = 2
		Prefixo = 3
		Número = 6
		Parcela = 2
		*/

		_cNum	:= If(Len(Alltrim(SE1->E1_NUM)) = 6,Alltrim(SE1->E1_NUM),Right(SE1->E1_NUM,6))
		_cPar	:= If(Empty(SE1->E1_PARCELA),'00',SE1->E1_PARCELA)

		_cCode	:= SE1->E1_FILIAL + SE1->E1_PREFIXO + _cNum + _cPar

		_nTama	:= Len(_cCode)
		_nDigi	:= 0
		_nBase	:= 9
		_nPeso	:= _nBase

		While _nTama > 0
		
			_nDigi += (Val(SubStr(_cCode, _nTama, 1)) * _nPeso)
			
			_nPeso -= 1
			
			If _nPeso = 1
				_nPeso := _nBase
			Endif
			
			_nTama -= 1
		EndDo
		_nResto := Mod(_nDigi,11)

		If (_nResto > 9 )
			_nDigi := 0
		Else
			_nDigi := _nResto
		Endif

		SE1->(RecLock("SE1",.F.))
		SE1->E1_YCODDEP := _cCode+'-'+cValToChar(_nDigi)
		SE1->(MsUnlock())	
	Endif

	RestArea(_aAliSE1)
	RestArea(_aAliORI)

Return(Nil)




/*
User Function FA060QRY()

_aAliOri := GetArea()

_cQ := " E1_FORMREC <> '' "

RestArea(_aAliOri)

Return(_cQ)
*/

User Function PF0001()

	_aAliOri  := GetArea()
	_lRet     := .T.

	_cBorInic := MV_PAR01
	_dDataBor := dDataBase
	_cFilial  := cFilAnt

	_cQ := " SELECT DISTINCT EA_FILIAL,EA_NUMBOR,EA_DATABOR FROM "+RetSqlName("SEA")+" A "
	_cQ += " WHERE A.D_E_L_E_T_ = '' AND EA_DATABOR >= '20180622' AND EA_TRANSF = '' AND EA_CART = 'R' "
	_cQ += " AND EA_DATABOR <= '"+Dtos(_dDataBor)+"' AND EA_FILORIG = '"+_cFilial+"' AND EA_NUMBOR < '"+_cBorInic+"' "
	_cQ += " ORDER BY EA_DATABOR,EA_NUMBOR "

	TCQUERY _cQ NEW ALIAS "ZZ"

	TCSETFIELD("ZZ","EA_DATABOR","D",8)

	ZZ->(dbGotop())

	If !Empty(ZZ->EA_NUMBOR)

		M->MV_PAR01 := Space(06)

		MsgInfo("Existem Borderos Que Não Foram Enviados ao Banco. Favor verificar os Borderos na Planilha Aberta!!!")

		_cDir := "C:\PROTHEUS12"

		If !ExistDir( _cDir )
			If MakeDir( _cDir ) <> 0
				MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
				Return(_lRet)
			EndIf
		EndIf

		_cArq := CriaTrab(NIL,.F.)
		Copy To &_cArq

		dbCloseArea()

		dbUseArea(.T.,,_cArq,"ZZ",.T.)
		_cInd := "DTOS(EA_DATABOR)"
		IndRegua("ZZ",_cArq,_cInd,,,"Selecionando Arquivo Trabalho")

		ZZ->(dbGotop())

		_cData   := DTOS(dDataBase)
		_cUser   := RetCodUsr()
		_cNomArq := "\DOCS\BORDERO_"+_cData+"_"+_cUser+".XLS"

		dbSelectArea("ZZ")
		COPY ALL TO &_cNomArq VIA "DBFCDXADS"

		If !__CopyFile(_cNomArq, "C:\PROTHEUS12\BORDERO_"+_cData+"_"+_cUser+".XLS" )
			MSGAlert("O arquivo não foi copiado!", "AQUIVO NÃO COPIADO!")
		Endif

		If ! ApOleClient( 'MsExcel' )
			MsgStop('MsExcel nao instalado')
		Else
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( "C:\PROTHEUS12\BORDERO_"+_cData+"_"+_cUser+".XLS" ) // Abre uma planilha
			oExcelApp:SetVisible(.T.)

			If  File(_cArq+".DTC")
				Ferase(_cArq+".DTC")
			Endif

			FErase(_cArq+OrdBagExt())
		Endif
	Endif

	ZZ->(dbCloseArea())

	RestArea(_aAliOri)

Return(_lRet)

User function F380FIL()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chamada da funcao pergunte                                   ³
	//³ mv_par01 - Visibilidade                                      ³
	//³          1 - Todos                                           ³
	//³          2 - Nao Conciliados                                 ³
	//³          3 - Conciliados    								 ³
	//³          4 - Receber										 ³
	//³          5 - Pagar					                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	_aAliORI := GetArea()

	_cFiltro := ""

	If MV_PAR01 = 4
		_cFiltro := "E5_RECPAG == 'R' "
	Elseif MV_PAR01 == 5
		_cFiltro := "E5_RECPAG == 'P' "
	Endif

	RestArea(_aAliORI)

Return(_cFiltro)

/*
User function FA060Num()

cProx := cNumBor

While !MayIUseCode ("E1_NUMBOR"+cNumBor)
cNumBor := cProx
cProx :=Soma1(cNumBor)
EndDo


Return
*/

User Function F060BOR()

	_aAliOri := GetArea() 

	dbSelectArea("SX6")

	_cNumBor := Soma1(Pad(GetMV("MV_NUMBORR"),Len(SE1->E1_NUMBOR)),Len(SE1->E1_NUMBOR))

	While !MayIUseCode( "E1_NUMBOR"+SX6->X6_FIL + _cNumBor)
		_cNumBor := Soma1(_cNumBor)
	EndDo

	RestArea(_aAliOri)

Return(_cNumBor)