#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function ITEM()

	Local _aParam     := PARAMIXB
	Local _xRet       := .T.
	Local _cIdPonto   := ''
	Local _cIdModel   := ''
	Local _aStructSB1 := SB1->(dbStruct())
	Local _nFor       := 0
	Local _aSB1       := {}

	If _aParam <> NIL

		_cIdPonto   := _aParam[2]
		_cIdModel   := _aParam[3]

		// ApMsgInfo('Chamada apos a gravação total do modelo e fora da transação (MODELCOMMITNTTS).' + CRLF + 'ID ' + _cIdModel)
		If _cIdPonto == 'MODELCOMMITNTTS' .And. cEmpAnt = '02' .And. cFilAnt = '27'
		
			For _nFor := 1 TO LEN(_aStructSB1)
				If Alltrim(_aStructSB1[_nFor][1]) <> 'B1_FILIAL'
					AAdd(_aSB1,{ Alltrim(_aStructSB1[_nFor][1]),&('SB1->'+Alltrim(_aStructSB1[_nFor][1])), Nil})
				Endif
			Next _nFor

			If !Empty(_aSB1) 
				
				_oModelMiz := FWModelActive()
				_nOpc      := _oModelMiz:GetOperation()
				
				GERASB1(_aSB1,_nOpc)
			Endif
		EndIf

	EndIf

Return(_xRet)




Static Function GERASB1(_aSB1,_nOpc)

	Local _oServer
	Local _cRpcServer := "10.150.1.5"
	Local _nRPCPort   := 6205
	Local _cRPCEnv    := "FS"

	_oServer := TRPC():New( _cRPCEnv )

	If _oServer:Connect( _cRpcServer, _nRPCPort )

		_oServer:StartJob("U_PXA013", .F., _aSB1,_nOpc)

		_oServer:Disconnect()
	EndIf

Return(Nil)

/*
		// SBM->(dbOrderNickName("INDSBM1"))
		// If SBM->(MsSeek(xFilial("SBM")+ TRB->GRPFATURAMENTO ))
		// 	_cGrProd := SBM->BM_GRUPO
		// Endif

		(_cAliasSB1)->(RecLock(_cAliasSB1,.T.))
		(_cAliasSB1)->B1_COD       := _cProd
		(_cAliasSB1)->B1_DESC      := U_RM_NoAcento(UPPER(Alltrim(TPROD->DESCRICAO)))
		(_cAliasSB1)->B1_MSBLQL    := (TPROD->INATIVO=1,"1","2")
		(_cAliasSB1)->B1_PESO      := TPROD->PESOLIQUIDO
		(_cAliasSB1)->B1_PESBRU    := TPROD->PESOBRUTO
		(_cAliasSB1)->B1_ORIGEM    := Alltrim(cValToChar(TPROD->REFERENCIACP))
		(_cAliasSB1)->B1_UPRC      := TPROD->PRECO1
		(_cAliasSB1)->B1_PRV1      := TPROD->PRECO2
		(_cAliasSB1)->B1_CUSTD     := TPROD->CUSTOUNITARIO
		(_cAliasSB1)->B1_UCALSTD   := TPROD->DATABASEPRECO1
		(_cAliasSB1)->B1_POSIPI    := TPROD->NUMEROCCF
		(_cAliasSB1)->B1_UM        := TPROD->CODUNDCONTROLE
		(_cAliasSB1)->B1_LOCPAD    := "01"
		(_cAliasSB1)->B1_TIPO      := If(TPROD->TIPO = "S","SV","PA")
		(_cAliasSB1)->B1_EMIN      := TPROD->PONTODEPEDIDO1
		(_cAliasSB1)->B1_EMAX      := TPROD->ESTOQUEMAXIMO1
		(_cAliasSB1)->B1_YCODRM    := _cProd
		(_cAliasSB1)->B1_GRUPO     := _cGrProd
		(_cAliasSB1)->(MsUnLock())
	Endif
*/









// 	ConOut("Executando (StartJob) funcao RpcJob...")

// 	uRet := _oServer:StartJob("U_RpcJob", .F., 10)

// 	ConOut(uRet)

// 	ConOut("Desconectando do servidor...")

// 	_oServer:Disconnect()

// Else
// 	ConOut("Conexao indisponivel com o servidor: " + _cRpcServer)
// EndIf


