#INCLUDE "rwmake.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GATFAT    ºAutor  ³                    º Data ³  26/04/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilho para atualizar o valor do frete na tabela SZ2 (pre  º±±
±±º          ³co X Cliente), de acordo com o Vl/Km X Distancia da obra.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function GATFAT01()

	_nVar02  := Posicione("SZD",1,xFilial("SZD")+SA1->A1_COD+SA1->A1_LOJA+M->Z2_LOCENT,"ZD_KM")
	_nValRet := SB1->B1_FRETEKM * _nVar02

Return(_nValRet)



User function GATFAT02()

	nPosQtde  := Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == "C6_QTDLIB"})
	nPosFrete  := Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == "C6_VLRFRET"})
	_nValFrete := acols[n,nPosQtde]*acols[n,nPosFrete]

	If _nValFrete>0
		if !inclui
			DbSelectArea("SC5")
			RecLock("SC5",.F.)
			SC5->C5_FRETE := _nValFrete
			MsUnlock()
		endif
		M->C5_FRETE := _nValFrete
	EndIf

Return(.T.)



User Function GFAT003()

	_aAliOri := GetArea()
	_aAliSC5 := SC5->(GetArea())

	_cRet := M->C5_CLIENTE

	If Date() >= CTOD("01/04/16")
		//If dDataBase >= CTOD("01/04/16")
		//If cFilAnt $ "01/04"
		//If !M->C5_CLIENTE $ "004903/011510/011882"
		//	MsgStop("Cliente Não pode ser Utilizado Nessa Filial!!!")
		//	_cRet := Space(06)
		//Endif
		//Else
		//If M->C5_CLIENTE $ "004903/011510/011882"
		//	MsgStop("Cliente Não pode ser Utilizado Nessa Filial!!!")
		//	_cRet := Space(06)
		//Endif
		//Endif
	Endif

	RestArea(_aAliSC5)
	RestArea(_aAliOri)

Return(_cRet)



User Function GFAT004()

	_aAliOri := GetArea()
	_aAliSC5 := SC5->(GetArea())

	_nPGERAOC  := Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == "C6_PDGEROC"})
	_cGeraOC   := Acols[N,_nPGERAOC]

	_cRet 	   := _cGeraOC

	If Date() >= CTOD("01/04/16")
		//If dDataBase >= CTOD("01/04/16")
		If cFilAnt $ "01/04"
			If !M->C5_CLIENTE $ "004903/011510/011882"
				MsgStop("Cliente Não pode ser Utilizado Nessa Filial!!!")
				_cRet := Space(01)
			Endif
		Endif
		/*
		Else
		If M->C5_CLIENTE $ "004903/011510/011882"
		MsgStop("Cliente Não pode ser Utilizado Nessa Filial!!!")
		_cRet := Space(01)
		Endif
		Endif
		*/
	Endif

	RestArea(_aAliSC5)
	RestArea(_aAliOri)

Return(_cRet)



User Function GFAT005()

	_aAliOri   := GetArea()

	_dRet      := &(Alltrim(ReadVar()))
	_cVar      := Alltrim(ReadVar())

	If !Alltrim(FunName()) $ "BRI099
		Return(_dRet)
	Endif

	_nPCODFIL  := aScan(aHeader,{|xCpo| Alltrim(xCpo[2]) == "Z04_CODFIL"})
	_nPDTFIN   := Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == "Z04_DTFIN"})
	_nPDTFIS   := Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == "Z04_DTFIS"})
	_nPDTEST   := Ascan(aHeader,{|xCpo| Alltrim(xCpo[2]) == "Z04_DTEST"})

	_cFilZ04   := Acols[N,_nPCODFIL]
	_dDtFIN    := Acols[N,_nPDTFIN]
	_dDtFIS    := Acols[N,_nPDTFIS]
	_dDtEST    := Acols[N,_nPDTEST]

	_dDtFGer   := CTOD("")

	SX6->(dbSetOrder(1))
	If SX6->(dbSeek(_cFilZ04 + "BRI_DTCTB"))
		_dDtFGer   := CTOD(Alltrim(SX6->X6_CONTEUD))
	Endif

	_dDtFIN    := Acols[N,_nPDTFIN]
	_dDtFIS    := Acols[N,_nPDTFIS]
	_dDtEST    := Acols[N,_nPDTEST]

	If     _cVar == "M->Z04_DTFIN"
		If _dDtFIN < _dDtFGer
			MsgInfo("Favor Verificar a Data do Fechamento Contábil!!")
			_dRet := CTOD("")
		Endif
	ElseIf _cVar == "M->Z04_DTFIS"
		If _dDtFIS < _dDtFGer
			MsgInfo("Favor Verificar a Data do Fechamento Contábil!!")
			_dRet := CTOD("")
		Endif
	ElseIf _cVar == "M->Z04_DTEST"
		If _dDtEST < _dDtFGer
			MsgInfo("Favor Verificar a Data do Fechamento Contábil!!")
			_dRet := CTOD("")
		Endif
	Endif
	//Next AX

Return(_dRet)



User Function GFAT006()

	_aAliOri := GetArea()

	_cTransp := M->ZW_TRANSP

	If _cTransp == "999999"
		_lRet 	 := U_CHKACESSO("ZW_TRANSP",6,.F.)
		If !_lRet
			MsgInfo("Favor solicitar o Acesso ao TI, referente ao campo: ZW_TRANSP")
			_cTransp := Space(06)
		Endif
	Endif

	RestArea(_aAliori)

Return(_cTransp)



//Função para validar se o campo Preço Unitário poderá ser alterado no Pedido de Vendas.
User Function GFAT007()

	Local _aAliOri	:= GetArea()
	Local _nPITEM	:= aScan( aHeader, { |x| Alltrim(x[2])== "C6_ITEM" } )
	Local _lRet		:= .T.
	Local _cPed		:= M->C5_NUM
	Local _cItem	:= aCols[n][_nPITEM]

	SC6->(dbSetOrder(1))
	If SC6->(MsSeek(xFilial("SC6")+_cPed+_cItem))
		If SC6->C6_QTDENT > 0
			_lRet := .F.
			ShowHelpDlg("GFAT007", {'Item do Pedido já foi Faturado.','','Alteração não permitida!'},3,{'Não se aplica.'},1)
		Endif
	Endif

	RestArea(_aAliori)

Return(_lRet)



//Função para validar se o campo Gera OC poderá ser editado.
User Function GFAT008(_cField)

	Local _aAliOri	:= GetArea()
	Local _nPos		:= aScan(aHeader,{|x| UPPER(Alltrim(x[2])) = _cField})
	Local _nPosBl	:= aScan(aHeader,{|x| UPPER(Alltrim(x[2])) = 'C6_YBLQPRC'})
	Local _lRet		:= .T.
	Local _cBlq		:= aCols[n][_nPosBl]

	If _cBlq = 'S'
		_lRet := .F.
		If _cField = 'C6_PDGEROC'
			ShowHelpDlg("GFAT008", {'Item do Pedido Bloqueado.','','Geração de OC não permitida!'},3,{'Não se aplica.'},1)
			aCols[n][_nPos] := Space(TAMSX3('C6_PDGEROC')[1])
		Else
			ShowHelpDlg("GFAT008", {'Item do Pedido Bloqueado.','','Liberação do Pedido não permitida!'},3,{'Não se aplica.'},1)
			aCols[n][_nPos] := 0
		Endif
	Endif

	RestArea(_aAliori)

Return(_lRet)



//Gatilho para validar o bloqueio do Pedido
User Function GFAT009()

	Local _aAliOri	:= GetArea()
//	Local _nPosIt	:= aScan(aHeader,{|x| UPPER(Alltrim(x[2])) = 'C6_ITEM'})
	Local _nPosOC	:= aScan(aHeader,{|x| UPPER(Alltrim(x[2])) = 'C6_PDGEROC'})
	Local _nPosPr	:= aScan(aHeader,{|x| UPPER(Alltrim(x[2])) = 'C6_PRODUTO'})
	Local _nPosPc	:= aScan(aHeader,{|x| UPPER(Alltrim(x[2])) = 'C6_PRCVEN'})
	Local _nPosBl	:= aScan(aHeader,{|x| UPPER(Alltrim(x[2])) = 'C6_YBLQPRC'})
	Local _nPosLi	:= aScan(aHeader,{|x| UPPER(Alltrim(x[2])) = 'C6_QTDLIB'})

	Local _cBlq		:= aCols[n][_nPosBl]
	Local _cProd	:= aCols[n][_nPosPr]
	Local _nPrcV	:= aCols[n][_nPosPc]

	SZ2->(dbsetOrder(4))
	If SZ2->(msSeek(xFilial("SZ2")+M->C5_CLIENTE+M->C5_LOJACLI+_cProd+'S'))
		If _nPrcV < SZ2->Z2_PRECO
			aCols[n][_nPosOC]	:= Space(TAMSX3('C6_PDGEROC')[1])
			aCols[n][_nPosLi]	:= 0
			_cBlq				:= 'S'
		Else
			_cBlq				:= 'N'
		Endif
	Endif

	RestArea(_aAliori)

Return(_cBlq)