#INCLUDE "TOTVS.CH"
#INCLUDE "TOTVS.CH"


/*/{Protheus.doc} SZ2010
Manutenção de dados em SZ2-TAB. CLI X PROD X PRECO.
/*/

User Function SZ2010()

	//Indica a permissão ou não para a operação (pode-se utilizar 'ExecBlock')
	Local _cVldAlt := "U_VldAltSZ2()" // Operacao: ALTERACAO
	Local _cVldExc := "U_VldExcSZ2()" // Operacao: EXCLUSAO

	//-- procedimentos ---------------------------------------------------------------------
	chkFile("SZ2")

	SZ2->(dbSetOrder(1))

	axCadastro("SZ2", "TAB. CLI X PROD X PRECO", _cVldExc, _cVldAlt)

Return(Nil)


User Function VldAltSZ2()

	Local _lRet		:= .F.
	Local _cProcLib	:= GetSxeNum('ZF1','ZF1_PROCES')
	Local _cGrAprov	:= SuperGetMV("ASC_GRPRPV",.F.,'')

	Local _cFil		:= xFilial("SZ2")
	Local _cCli		:= M->Z2_CLIENTE
	Local _cLoja	:= M->Z2_LOJA
	Local _cProd	:= M->Z2_PRODUTO
	Local _nPrcAt	:= 0
	Local _nPCalc	:= M->Z2_PRECO
	Local _nDif		:= M->Z2_PRECO
	LOcal _cNome	:= Z2_NOME
	Local _cCodBlq	:= '03'

	Local lFirstNiv	:= .T.
	Local cAuxNivel	:= ""
	Local _lLibera	:= .T.

	If Altera
		_lRet := .T.
		Return(_lRet)
	Endif

	SAL->(dbSetOrder(2))
	If SAL->(!dbSeek(xFilial() + _cGrAprov))
		MSGSTOP("Grupo Não Cadastrado, Favor Contatar o Administrador do Sistema!")
		Return(_lRet)
	EndIf


	SAL->(dbSetOrder(2))
	If SAL->(dbSeek(xFilial() + _cGrAprov))

		While SAL->(!Eof()) .And. xFilial("SAL")+_cGrAprov == SAL->AL_FILIAL+SAL->AL_COD

			If lFirstNiv
				cAuxNivel := SAL->AL_NIVEL
				lFirstNiv := .F.
			EndIf

			SCR->(Reclock("SCR",.T.))
			SCR->CR_FILIAL	:= xFilial("SCR")
			SCR->CR_NUM		:= _cFil + _cCli + _cLoja + _cProcLib + Alltrim(_cProd)
			SCR->CR_TIPO	:= _cCodBlq
			SCR->CR_NIVEL	:= SAL->AL_NIVEL
			SCR->CR_USER	:= SAL->AL_USER
			SCR->CR_APROV	:= SAL->AL_APROV
			SCR->CR_STATUS	:= "02"
			SCR->CR_EMISSAO := dDataBase
			SCR->CR_MOEDA	:= 1
			SCR->CR_TXMOEDA := 1
			SCR->CR_OBS     := Alltrim(SM0->M0_NOME) +" - TABELA DE PREÇO"
			SCR->CR_TOTAL	:= _nPCalc
			//						SCR->CR_YCLIENT	:= _cCli
			//						SCR->CR_YLOJA	:= _cLoja
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
			ZAH->ZAH_OBS   := SCR->CR_OBS
			ZAH->ZAH_TOTAL := SCR->CR_TOTAL
			ZAH->(MsUnlock())

			SAL->(dbSkip())
		EndDo
	EndIf

	ShowHelpDlg("SZ2010_1", {'Tabela de Preço Bloqueada!',;
	'Filial+Cliente+Loja: '+_cFil+"-"+_cCli +"-"+_cLoja,;
	'Produto: '+_cProd,;
	'Preço Digitado: '+Alltrim(Transform(_nPCalc,"@e 999,999.99"))},4,;
	{'Solicite a liberação junto ao setor responsável.'},1)

	ZF1->(RecLock("ZF1",.T.))
	ZF1->ZF1_FILIAL	:= _cFil
	ZF1->ZF1_CLIENT	:= _cCli
	ZF1->ZF1_LOJA	:= _cLoja
	ZF1->ZF1_NOME	:= _cNome
	ZF1->ZF1_PRODUT	:= _cProd
	ZF1->ZF1_PROCES	:= _cProcLib
	ZF1->ZF1_DTEMIS	:= dDataBase
	ZF1->ZF1_PRCANT	:= _nPrcAt
	ZF1->ZF1_PRCATU	:= _nPCalc
	ZF1->ZF1_STATUS	:= 'P'
	ZF1->ZF1_USUARI	:= UsrRetName(RetCodUsr())
	ZF1->(MsUnLock())

	ConfirmSX8()

	_lRet := .T.

	M->Z2_PROCES := _cProcLib

Return(_lRet)



User Function VldExcSZ2()

	Local _lRet		:= .T.
	Local _cFil		:= xFilial("SZ2")
	Local _cCli		:= SZ2->Z2_CLIENTE
	Local _cLoja	:= SZ2->Z2_LOJA
	Local _cProd	:= SZ2->Z2_PRODUTO
	Local _nPrcAt	:= 0
	Local _nPCalc	:= SZ2->Z2_PRECO
	Local _nDif		:= SZ2->Z2_PRECO
	LOcal _cNome	:= SZ2->Z2_NOME
	LOcal _cProcLib	:= SZ2->Z2_PROCES
	Local _cCodBlq	:= '03'
	Local _cNum		:= _cFil + _cCli + _cLoja + _cProcLib + Alltrim(_cProd)

	If SZ2->(FieldPos("Z2_LIBERAD")) > 0
		If SZ2->Z2_LIBERAD = 'S'
			Return(_lRet)
		Endif

		_cUpd := "DELETE "+RetSqlName("ZF1")+ " WHERE ZF1_CLIENT = '"+_cCli+"' AND ZF1_LOJA = '"+_cLoja+"' AND D_E_L_E_T_ = '' "
		_cUpd += "AND ZF1_PRODUT = '"+_cProd+"' AND ZF1_PROCES = '"+_cProcLib+"' "
		TcSqlExec(_cUpd)

		_cUpd := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cNum+"' AND ZAH_TIPO = '"+_cCodBlq+"' AND D_E_L_E_T_ = '' "
		TcSqlExec(_cUpd)

		_cUpd := "DELETE "+RetSqlName("SCR")+ " WHERE CR_NUM = '"+_cNum+"' AND CR_TIPO = '"+_cCodBlq+"'  AND D_E_L_E_T_ = '' "
		TcSqlExec(_cUpd)

	Endif

Return(_lRet)