#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} BRI114
//Bloueio do Pedido de Vendas
@author Fabiano
@since 17/10/2018

@type function
/*/
User Function BRI114(_nLin)

	Local _cCodBlq	:= '02'
	Local _cPedido	:= M->C5_NUM
	Local _cItem	:= ''
	Local _nPrcV	:= 0
	Local _cOC		:= ''
	Local _nPosIt	:= aScan(aHeader,{|x| UPPER(Alltrim(x[2])) = 'C6_ITEM'})
	Local _nPosOC	:= aScan(aHeader,{|x| UPPER(Alltrim(x[2])) = 'C6_PDGEROC'})
	Local _nPosPr	:= aScan(aHeader,{|x| UPPER(Alltrim(x[2])) = 'C6_PRODUTO'})
	Local _nPosPc	:= aScan(aHeader,{|x| UPPER(Alltrim(x[2])) = 'C6_PRCVEN'})
	Local _nPosBl	:= aScan(aHeader,{|x| UPPER(Alltrim(x[2])) = 'C6_YBLQPRC'})

	_cItem	:= aCols[_nLin][_nPosIt]
	_cProd	:= aCols[_nLin][_nPosPr]
	_nPrcV	:= aCols[_nLin][_nPosPc]
	_cOC	:= aCols[_nLin][_nPosOC]

	SZ2->(dbsetOrder(4))
	If SZ2->(msSeek(xFilial("SZ2")+M->C5_CLIENTE+M->C5_LOJACLI+_cProd))

		SCR->(dbSetOrder(1))
		If SCR->(dbSeek(xFilial("SCR")+ _cCodBlq + _cPedido + _cItem ))

			_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM

			ZAH->(dbSetOrder(1))
			If ZAH->(dbSeek(SCR->CR_FILIAL + _cChavSCR  ))

				_cCq := " DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_FILIAL = '"+SCR->CR_FILIAL+"' AND ZAH_NUM = '"+SCR->CR_NUM+"' AND ZAH_TIPO = '"+SCR->CR_TIPO+"' "
				TcSqlExec(_cCq)
			Endif

			While SCR->(!Eof())	.And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM

				SCR->(RecLock("SCR",.F.))
				SCR->(dbDelete())
				SCR->(MsUnlock())

				SCR->(dbSkip())
			EndDo
		Endif

		If _nPrcV < SZ2->Z2_PRECO

			_cGrAprov:= SuperGetMV("ASC_GRPRPV",.F.,'')

			SAL->(dbSetOrder(2))
			If SAL->(!dbSeek(xFilial() + _cGrAprov))
				MSGSTOP("Grupo Nao Cadastrado, Favor Contatar o Administrador do Sistema!")
				Return
			EndIf

			lFirstNiv   := .T.
			cAuxNivel   := ""
			_lLibera    := .T.

			SAL->(dbSetOrder(2))
			If SAL->(dbSeek(xFilial() + _cGrAprov))

				While SAL->(!Eof()) .And. xFilial("SAL")+_cGrAprov == SAL->AL_FILIAL+SAL->AL_COD

					If lFirstNiv
						cAuxNivel := SAL->AL_NIVEL
						lFirstNiv := .F.
					EndIf

					SCR->(Reclock("SCR",.T.))
					SCR->CR_FILIAL	:= xFilial("SC9")
					SCR->CR_NUM		:= _cPedido + _cItem
					SCR->CR_TIPO	:= _cCodBlq
					SCR->CR_NIVEL	:= SAL->AL_NIVEL
					SCR->CR_USER	:= SAL->AL_USER
					SCR->CR_APROV	:= SAL->AL_APROV
					SCR->CR_STATUS	:= "02"
					SCR->CR_EMISSAO := dDataBase
					SCR->CR_MOEDA	:= 1
					SCR->CR_TXMOEDA := 1
					SCR->CR_OBS     := Alltrim(SM0->M0_NOME) +" - PRECO PEDIDO DE VENDA"
					SCR->CR_TOTAL	:= _nPrcV
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

			If _nPosBl > 0
				aCols[_nLin][_nPosBl] := 'S'
			Endif
			aCols[_nLin][_nPosOC] := Space(TAMSX3('C6_PDGEROC')[1])

			//MSGSTOP("O Pedido "+M->C5_NUM+", Item "+_cItem+" foi bloqueado Por Credito. Solicite a Aprovacao Pelo Departamento Financeiro.")
			ShowHelpDlg("BRI114", {'Pedido Bloqueado, pois o preço informado é menor que a tabela de Preço.',;
			'Pedido+Item: '+_cPedido+'-'+_cItem,;
			'Produto: '+_cProd,;
			'Preço Pedido: '+cValtoChar(_nPrcV),;
			'Preço Tabela: '+cValtoChar(SZ2->Z2_PRECO)},5,;
			{'Solicite a liberação junto ao setor responsável.'},1)

		EndIf
	EndIf

Return(Nil)