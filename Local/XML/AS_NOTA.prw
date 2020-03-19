#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} AS_NOTA
//Geração de NF através da rotina "Gestor XML"
@author Fabiano
@since 22/12/2017
@version 1.0
@param _oObj, , oDLG - MsDialog
@param _oCabec, , _oListbox - Cabeçalho do XML
@param _oItem, , _oListIt - Itens do XML
@param _aFldIte, , _aFldIte - Campos apresentados em colunas no Header
@type function
/*/
User Function AS_NOTA(_oObj,_oCabec,_oItem,_aFldIte)

	LjMsgRun("Gerando Documento de Entrada...","AS_NOTA",{||GeraNF(_oObj,_oCabec,_oItem,_aFldIte)})

Return(Nil)


Static Function GeraNF(_oObj,_oCabec,_oItem,_aFldIte)

	local _nB,_nA,F
	Local _aCabec	:= {}
	Local _aItens	:= {}
	Local _aLinha	:= {}
	Local _aColsCC	:= {}
	Local _aCodRet	:= {}
	Local _nX		:= 0
	Local _cDoc		:= ""
	Local _lOk		:= .T.
	Local _nPosIte	:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_ITEM'	})
	Local _nPosCod	:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_COD'	})
	Local _nPosNCo	:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_DESPRO'	})
	Local _nPosPed	:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_PEDIDO'	})
	Local _nPosTES	:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_TES'	})
	Local _nPosCFO	:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_CFOP'	})
	Local _nPosIPC	:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_ITEMPC'	})
	Local _nPosQtd	:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_QUANT'	})
	Local _nPosUni	:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_VUNIT'	})
	Local _nPosTot	:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_VTOTAL'	})
	Local _nPosBIC	:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_BICMS'	})
	Local _nPosPIC	:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_PICMS'	})
	Local _nPosVIC	:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_VICMS'	})
	Local _nPosBIP	:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_BIPI'	})
	Local _nPosPIP	:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_PIPI'	})
	Local _nPosVIP	:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_VIPI'	})
	Local _nPosSNF	:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_SERNFO'	})
	Local _nPosNFO	:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_NFORIG'	})
	Local _nPosINF	:= aSCan(_aFldIte,{|x| x[1] == 'ZA2_ITNFOR'	})

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	Private _nCredCOF   := 0
	Private _nCredPIS   := 0

	For _nA := 1 To Len(_oCabec:aArray)

		If _oCabec:aArray[_nA][1]

			If _oCabec:aArray[_nA][2] <> 1
				ShowHelpDlg("AS_NOTA", {'XML não está apto para ser importado.'},2,{'A Nota Fiscal tem que estar com a Legenda em "Verde".'},2)
				Loop
			Endif

			ZA1->(dbGoTo(_oCabec:aArray[_nA][Len(_oCabec:aArray[_nA])]))

			_cEst := _cCond := _cNat := ''
			If ZA1->ZA1_TIPO2 = 'N'
				SA2->(dbSetOrder(1))
				SA2->(msSeek(xFilial("SA2")+ZA1->ZA1_FORNEC+ZA1->ZA1_LOJA))

				_cEst  := SA2->A2_EST
				_cCond := SA2->A2_COND
				_cNat  := SA2->A2_NATUREZ

			ElseIf ZA1->ZA1_TIPO2 = 'D'
				SA1->(dbSetOrder(1))
				SA1->(msSeek(xFilial("SA1")+ZA1->ZA1_FORNEC+ZA1->ZA1_LOJA))

				_cEst  := SA1->A1_EST
				_cCond := SA1->A1_COND
				_cNat  := SA1->A1_NATUREZ
			Endif

			_aCabec := {}
			_aItens := {}

			_nTVal := _nTBIC := _nTVIC := _nTBIP := _nTVIP := _nTBI5 := _nTVI5 := _nTBI6 := _nTVI6 := 0

			For _nB := 1 To Len(_oItem:aArray)

				_cProd 		:= _oItem:aArray[_nB][_nPosCod]
				_cDesProd	:= _oItem:aArray[_nB][_nPosNCo]
				_cTES		:= _oItem:aArray[_nB][_nPosTES]
				_cCF		:= _oItem:aArray[_nB][_nPosCFO]
				_cPedido	:= _oItem:aArray[_nB][_nPosPed]
				_cItemPC	:= _oItem:aArray[_nB][_nPosIPC]
				_nQuanti	:= _oItem:aArray[_nB][_nPosQtd]
				_nVlUnit	:= _oItem:aArray[_nB][_nPosUni]
				_nVlTotal	:= _oItem:aArray[_nB][_nPosTot]
				_nBasICMS	:= _oItem:aArray[_nB][_nPosBIC]
				_nPerICMS	:= _oItem:aArray[_nB][_nPosPIC]
				_nValICMS	:= _oItem:aArray[_nB][_nPosVIC]
				_nBasIPI	:= _oItem:aArray[_nB][_nPosBIP]
				_nPerIPI	:= _oItem:aArray[_nB][_nPosPIP]
				_nValIPI	:= _oItem:aArray[_nB][_nPosVIP]
				_cSerOri	:= _oItem:aArray[_nB][_nPosSNF]
				_cNFOrig	:= _oItem:aArray[_nB][_nPosNFO]
				_cItNFOr	:= _oItem:aArray[_nB][_nPosINF]
				_cItemXML	:= _oItem:aArray[_nB][_nPosIte]

				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+_cProd))

				If _cPedido = '*'

					ZA3->(dbSetOrder(1))
					If ZA3->(msSeek(xFilial("ZA3")+ZA1->ZA1_SERIE+ZA1->ZA1_DOC+_cItemXML+ZA1->ZA1_FORNEC+ZA1->ZA1_LOJA))

						_nTotQ 	:= _nQuanti
						_nTotBIc:= _nBasICMS
						_nTotBIP:= _nBasIPI

						_cKeyZA3 :=  xFilial("ZA3")+ZA3->ZA3_SERIE+ZA3->ZA3_DOC+ZA3->ZA3_ITEM+ZA3->ZA3_FORNEC+ZA3->ZA3_LOJA

						While ZA3->(!EOF()) .And. _cKeyZA3 == xFilial("ZA3")+ZA3->ZA3_SERIE+ZA3->ZA3_DOC+ZA3->ZA3_ITEM+ZA3->ZA3_FORNEC+ZA3->ZA3_LOJA

							_nPerc := (ZA3->ZA3_QUANT * 100 / _nTotQ) / 100

							_cTES		:= ZA3->ZA3_TES
							_cCF		:= ZA3->ZA3_CFOP
							_cPedido	:= ZA3->ZA3_PEDIDO
							_cItemPC	:= ZA3->ZA3_ITEMPC
							_nQuanti	:= ZA3->ZA3_QUANT
							_nVlUnit	:= _oItem:aArray[_nB][_nPosUni]
							_nVlTotal	:= ZA3->ZA3_QUANT * _nVlUnit
							_nBasICMS	:=  _nTotBIc * _nPerc
							_nValICMS	:= (_nPerICMS / 100) * _nBasICMS
							_nBasIPI	:= _nTotBIP * _nPerc
							_nValIPI	:= (_nPerIPI / 100) * _nBasIPI
							//							_cItemXML	:=

							SF4->(dbSetOrder(1))
							SF4->(dbSeek(xFilial("SF4")+_cTES))

							_cClasFis	:= Left(SB1->B1_ORIGEM,1)+SF4->F4_SITTRIB

							_aLinha := GetLine(_cDesProd,_cTES,_cCF,_nQuanti,_nVlTotal,_nBasICMS,_nPerICMS,_nValICMS,_nBasIPI,_nPerIPI,_nValIPI,_cPedido,_cItemPC,_cNFOrig,_cSerOri,_cItNFOr)

							aadd(_aItens,_aLinha)

							_nTVal += _nVlTotal
							_nTBIC += _nBasICMS
							_nTVIC += _nValICMS
							_nTBIP += _nBasIPI
							_nTVIP += _nValIPI
							_nTBI5 += _nVlTotal
							_nTVI5 += _nCredCOF
							_nTBI6 += _nVlTotal
							_nTVI6 += _nCredPIS

							ZA3->(dbSkip())
						EndDo
					Endif

				Else

					SF4->(dbSetOrder(1))
					SF4->(dbSeek(xFilial("SF4")+_cTES))

					_cClasFis	:= Left(SB1->B1_ORIGEM,1)+SF4->F4_SITTRIB

					_aLinha := GetLine(_cDesProd,_cTES,_cCF,_nQuanti,_nVlTotal,_nBasICMS,_nPerICMS,_nValICMS,_nBasIPI,_nPerIPI,_nValIPI,_cPedido,_cItemPC,_cNFOrig,_cSerOri,_cItNFOr)

					aadd(_aItens,_aLinha)

					_nTVal += _nVlTotal
					_nTBIC += _nBasICMS
					_nTVIC += _nValICMS
					_nTBIP += _nBasIPI
					_nTVIP += _nValIPI
					_nTBI5 += _nVlTotal
					_nTVI5 += _nCredCOF
					_nTBI6 += _nVlTotal
					_nTVI6 += _nCredPIS
				Endif
			Next _nB

			_cTipo := ''
			If ZA1->ZA1_TIPO = "NFE"
				_cTipo := "SPED"
			Endif

			//ExpA1 - Array contendo os dados do cabeçalho da Nota Fiscal de Entrada.
			aadd(_aCabec,{"F1_TIPO"		, ZA1->ZA1_TIPO2	, Nil})
			aadd(_aCabec,{"F1_FORMUL"	, "N"				, Nil})
			aadd(_aCabec,{"F1_DOC"		, ZA1->ZA1_DOC		, Nil})
			aadd(_aCabec,{"F1_SERIE"	, ZA1->ZA1_SERIE	, Nil})
			aadd(_aCabec,{"F1_EMISSAO"	, ZA1->ZA1_EMISSA	, Nil})
			aadd(_aCabec,{"F1_FORNECE"	, ZA1->ZA1_FORNECE	, Nil})
			aadd(_aCabec,{"F1_LOJA"		, ZA1->ZA1_LOJA		, Nil})
			aadd(_aCabec,{"F1_ESPECIE"	, _cTipo			, Nil})
			aadd(_aCabec,{"F1_EST"		, _cEst				, Nil})
			aadd(_aCabec,{"F1_COND"		, _cCond			, Nil})
			aadd(_aCabec,{"F1_DESPESA"	, 0					, Nil})
			aadd(_aCabec,{"F1_DESCONT"	, 0					, Nil})
			aadd(_aCabec,{"F1_SEGURO"	, 0					, Nil})
			aadd(_aCabec,{"F1_FRETE"	, 0					, Nil})
			aadd(_aCabec,{"F1_VALMERC"	, _nTVal			, Nil})
			aadd(_aCabec,{"F1_VALBRUT"	, _nTVal			, Nil})
			aadd(_aCabec,{"F1_MOEDA"	, 1					, Nil})
			aadd(_aCabec,{"F1_STATUS"	, "A" 				, Nil})
			aadd(_aCabec,{"E2_NATUREZ"	, _cNat				, Nil})
			aadd(_aCabec,{"F1_DTDIGIT"	, dDataBase			, Nil})
			aadd(_aCabec,{"F1_CHVNFE"	, ZA1->ZA1_CHAVE	, Nil})
			aadd(_aCabec,{"F1_PREFIXO"	, ZA1->ZA1_SERIE	, Nil})
			aadd(_aCabec,{"F1_RECBMTO"	, ZA1->ZA1_EMISSA	, Nil})
			aadd(_aCabec,{"F1_BASEICM"	, _nTBIC			, Nil})
			aadd(_aCabec,{"F1_VALICM"	, _nTVIC			, Nil})
			aadd(_aCabec,{"F1_BASEIPI"	, _nTBIP			, Nil})
			aadd(_aCabec,{"F1_VALIPI"	, _nTVIP			, Nil})
			If _nTVI5 > 0
				aadd(_aCabec,{"F1_BASIMP5"	, _nTBI5			, Nil})
				aadd(_aCabec,{"F1_VALIMP5"	, _nTVI5			, Nil})
			Endif
			If _nTVI6 > 0
				aadd(_aCabec,{"F1_BASIMP6"	, _nTBI6			, Nil})
				aadd(_aCabec,{"F1_VALIMP6"	, _nTVI6			, Nil})
			Endif

			MATA103(_aCabec,_aItens,3,.T.)

			If lMsErroAuto
				MostraErro()
			EndIf

		Endif

	Next _nA

	U_AS_GetXML(2) //Verifica se existe arquivo para ser importado

	_aItem := {{}}
	For F := 1 To Len(_aFldIte)

		If _aFldIte[F][1] $ 'ZA2_OK|ZA2_RECNO'
			AAdd(_aItem[1],0)
		Else
			AAdd(_aItem[1],Criavar(_aFldIte[F][1]))
		Endif

	Next F

	_oListIt:SetArray(_aItem)

	_oListIt:bLine := {|| U_SetArrIT(_oListIt,_aItem,_aFldIte)}

	_oListIt:Refresh()

Return(Nil)



Static Function GetLine(_cDesProd,_cTES,_cCF,_nQuanti,_nVlTotal,_nBasICMS,_nPerICMS,_nValICMS,_nBasIPI,_nPerIPI,_nValIPI,_cPedido,_cItemPC,_cNFOrig,_cSerOri,_cItNFOr)

	Local _aLinha := {}

	aadd(_aLinha,{"D1_COD"		, SB1->B1_COD		,Nil})
	aadd(_aLinha,{"D1_UM"		, SB1->B1_UM		,Nil})
	aadd(_aLinha,{"D1_DESCRI"	, _cDesProd			,Nil})
	aadd(_aLinha,{"D1_FORNECE"	, ZA1->ZA1_FORNEC	,Nil})
	aadd(_aLinha,{"D1_LOJA"		, ZA1->ZA1_LOJA		,Nil})
	aadd(_aLinha,{"D1_LOCAL"	, SB1->B1_LOCPAD	,Nil})
	aadd(_aLinha,{"D1_GRUPO"	, SB1->B1_GRUPO		,Nil})
	aadd(_aLinha,{"D1_CC"		, SB1->B1_CC		,Nil})
	aadd(_aLinha,{"D1_CLVL"		, SB1->B1_CLVL		,Nil})
	aadd(_aLinha,{"D1_ITEMCTA"	, SB1->B1_ITEMCC	,Nil})
	aadd(_aLinha,{"D1_CONTA"	, SB1->B1_CONTA		,Nil})
	aadd(_aLinha,{"D1_TP"		, SB1->B1_TIPO		,Nil})
	aadd(_aLinha,{"D1_TES"		, _cTES				,Nil})
	aadd(_aLinha,{"D1_CF"		, _cCF				,Nil})
	aadd(_aLinha,{"D1_EMISSAO"	, ZA1->ZA1_EMISSA	,Nil})
	aadd(_aLinha,{"D1_DOC"		, ZA1->ZA1_DOC		,Nil})
	aadd(_aLinha,{"D1_SERIE"	, ZA1->ZA1_SERIE	,Nil})
	aadd(_aLinha,{"D1_DTDIGIT"	, dDataBase			,Nil})
	aadd(_aLinha,{"D1_QUANT"	, _nQuanti			,Nil})
	aadd(_aLinha,{"D1_VUNIT"	, _nVlUnit			,Nil})
	aadd(_aLinha,{"D1_TOTAL"	, _nVlTotal			,Nil})
	aadd(_aLinha,{"D1_BASEICM"	, _nBasICMS			,Nil})
	aadd(_aLinha,{"D1_PICM"		, _nPerICMS			,Nil})
	aadd(_aLinha,{"D1_VALICM"	, _nValICMS			,Nil})
	aadd(_aLinha,{"D1_BASEIPI"	, _nBasIPI			,Nil})
	aadd(_aLinha,{"D1_IPI"		, _nPerIPI			,Nil})
	aadd(_aLinha,{"D1_VALIPI"	, _nValIPI			,Nil})
	If !Empty(_cPedido)
		aadd(_aLinha,{"D1_PEDIDO"	, _cPedido			,Nil})
		aadd(_aLinha,{"D1_ITEMPC"	, _cItemPC			,Nil})
	Endif
	aadd(_aLinha,{"D1_SEGURO"	, 0					,Nil})
	aadd(_aLinha,{"D1_VALFRE"	, 0					,Nil})
	aadd(_aLinha,{"D1_DESPESA"	, 0					,Nil})
	aadd(_aLinha,{"D1_RATEIO"	,"2"				,Nil})
	aadd(_aLinha,{"D1_CLASFIS"	,_cClasFis			,Nil})

	_nCredCOF := _nCredPIS := 0
	If SF4->F4_PISCOF $ '23' .And. SF4->F4_PISCRED == '1' // Gera COF?  e Se credita de COF?
		_nCredCOF	+= Round(_nVlTotal*GETMV("MV_TXCOFIN")/100,2)
		aadd(_aLinha,{"D1_BASIMP5"	,_nVlTotal		,Nil})
		aadd(_aLinha,{"D1_VALIMP5"	,_nCredCOF		,Nil})
	Endif

	If SF4->F4_PISCOF $ '13' .And. SF4->F4_PISCRED == '1' // Gera PIS?  e Se credita de PIS?
		_nCredPIS	+= Round(_nVlTotal*GETMV("MV_TXPIS")/100,2)
		aadd(_aLinha,{"D1_BASIMP6"	,_nVlTotal		,Nil})
		aadd(_aLinha,{"D1_VALIMP6"	,_nCredPIS		,Nil})
	Endif

	If !Empty(_cNFOrig)
		aadd(_aLinha,{"D1_NFORI"	,_cNFOrig		,Nil})
		aadd(_aLinha,{"D1_SERIORI"	,_cSerOri		,Nil})
		aadd(_aLinha,{"D1_ITEMORI"	,_cItNFOr		,Nil})
	Endif

	aadd(_aLinha,{"AUTDELETA" , "N" 				,Nil}) // Incluir sempre no último elemento do array de cada item

Return(_aLinha)
