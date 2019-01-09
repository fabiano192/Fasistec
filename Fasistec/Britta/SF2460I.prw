#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2460i   ºAutor  ³Marcos - Proteam    º Data ³  20/05/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para gravar a placa do caminhao no         º±±
±±º          ³cabecalho da nota fiscal de saida, utilizado no relatorio   º±±
±±º          ³de pagamento de comissao sobre frete para os motoristas .   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservacao³Este ponto e executado apos a gravacao de cada nf saida.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º 12/06/02 ³Modificacao Efetuada :                                      º±±
±±º Marcos   ³Modificado para gravar o codigo do endereco de entrega ,    º±±
±±º Proteam  ³informado no cabecalho do pedido de venda.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION SF2460I()

	LOCAL _cEndEnt:=""
	LOCAL _cBaiEnt:=""
	LOCAL _cMunEnt:=""
	LOCAL _cEstEnt:=""
	LOCAL _cCepEnt:=""
	LOCAL _nDistancia:=0
	LOCAL _cLocEnt:=""

	mv_par57:=sf2->f2_serie

	If sf2->f2_tipo<>'N'
		DbSelectArea("SF2")
		RecLock("SF2",.f.)

		if sza->(za_nota+za_serie)==sf2->(f2_doc+f2_serie)
			sf2->f2_placa:=sza->za_placa
		else
			SF2->F2_PLACA  := SC5->C5_PLACA
		endif

		return
	endif

	_aArea:=GetArea()  //guarda o alias,ordem de indice e registro atual
	_cLocEnt:=IIf(Empty(SC5->C5_CODEE),"01",SC5->C5_CODEE)

	SZD->(OrdSetFocus(1))
	IF SZD->(DbSeek(xFilial("SZD")+sc5->(c5_cliente+c5_lojacli)+_cLocEnt ))
		_cEndEnt:=szd->zd_ee
		_cBaiEnt:=szd->zd_baie
		_cMunEnt:=szd->zd_mune
		_cEstEnt:=szd->zd_este
		_cCepEnt:=szd->zd_cepe
		_nDistancia:=szd->zd_km
	ENDIF
	/*
	_cHora := SF2->F2_HORA
	_cMin  := Right(SF2->F2_HORA,2)
	_lAchou:= .F.

	SZK->(dbSetOrder(1))
	If SZK->(dbSeek(xFilial("SZK")+Left(DTOS(SF2->F2_EMISSAO),4)))
	If SF2->F2_EMISSAO >= SZK->ZK_DATAINI .And. SF2->F2_EMISSAO <= SZK->ZK_DATAFIM
	_cEstado := GETMV("MV_ESTADO")

	_cEst  := ""
	_cHr   := Left(SF2->F2_HORA,2)
	For AX:= 1 To Len(Alltrim(SZK->ZK_ESTADOS)) Step 2
	_cEst := Substr(Alltrim(SZK->ZK_ESTADOS),AX,2)

	If _cEst == _cEstado
	_lAchou :=.T.
	Exit
	Endif
	Next

	If !_lAchou
	If _cHr   == "00"
	_cHora := "23:" + _cMin
	Else
	//_cHora := Alltrim(Str(Val(_cHr)-1)) + ":" + _cMin
	_cHora := Strzero(Val(_cHr)-1,2) + ":" + _cMin
	Endif
	Endif
	Endif
	Endif
	*/
	DbSelectArea("SF2")
	RecLock("SF2",.f.)
	If sza->(za_nota+za_serie)==sf2->(f2_doc+f2_serie)
		sf2->f2_placa:=sza->za_placa
	Else
		SF2->F2_PLACA  := SC5->C5_PLACA
	Endif

	//SF2->F2_HORA   := _cHora
	SF2->F2_CODEE  := SC5->C5_CODEE
	sf2->f2_pdee   :=_cEndEnt
	sf2->f2_pdbaie :=_cBaiEnt
	sf2->f2_pdmune :=_cMunEnt
	sf2->f2_pdeste :=_cEstEnt
	sf2->f2_pdcepe :=_cCepEnt
	sf2->f2_pddist :=_nDistancia
	sf2->f2_pdtpvei:=sc5->c5_pdtpvei
	sf2->f2_xopesai:=sc5->c5_xopesai

	_vStru:=sc5->(dbstruct())
	_nPosic:=ascan(_vStru,{|_vAux|alltrim(upper(_vAux[1]))=="C5_PDUNID"})
	if _nPosic>0
		sf2->f2_pdunid:=sc5->c5_pdunid
	endif

	If sm0->(m0_codigo+m0_codfil)=='0401'
		sf2->f2_valmerc-=sf2->f2_baseiss
	Endif
	MsUnlock()

	//Quando grava titulo a receber, grava o codigo da obra de entrega para geracao
	//da fatura a receber descentralizada,ou seja , obra a obra
	If SF4->F4_DUPLIC<>"N"
		DbSelectArea("SE1")
		RecLock("SE1",.F.)// INCLUIDO POR HUDSON CARDOSO
		SE1->E1_CODEE := SC5->C5_CODEE
		MsUnlock()
	EndIf

	// Atualizacoes em SE1
	if sf2->f2_valfat>0

		_vAmbSe1:=se1->(getarea())
		Se1->(dbsetorder(1)) // _Filial+_Prefixo+_Num+_parcela+_Tipo
		_vE1:={}
		_cKeyE1:=xfilial("SE1")+sf2->(f2_prefixo+f2_doc)
		se1->(dbseek(_cKeyE1))
		do while se1->(!eof().and._cKeyE1==e1_filial+e1_prefixo+e1_num)
			aadd(_vE1,se1->(recno()))
			se1->(dbskip(1))
		enddo

		if len(_vE1)>0
			for _nVez:=1 to len(_vE1)
				se1->(dbgoto(_vE1[_nVez]))
				do while se1->(!reclock(alias(),.f.))
				enddo
				se1->e1_xopesai:=sc5->c5_xopesai
			next
		endif
		se1->(restarea(_vAmbSe1))
	endif

	_fGeraSz8() // Controle de premiacao retira

	u_fAbastec()

	RestArea(_aArea)  // restaura o alias,ordem de indice e registro inicial

	*------------------------------------------------------------------------------
static function _fGeraSz8()
	* Alimentacao de SZ8 - Controle de premiacao "Retira"
	* Ricardo Luiz da Rocha - 24/06/2003 GNSJC
	*------------------------------------------------------------------------------
	local _nViagem,_lPrim:=.t.,_vAmbSd2
	if sf2->(f2_tipo=="N".and.f2_codee=="01".and.f2_valfat>0)
		_vAmbSd2:=sd2->(getarea())
		sd2->(dbsetorder(3)) // d2_filial+d2_doc+d2_serie+d2_cliente+d2_loja+d2_item
		// Verificar o numero sequencial da viagem
		sd2->(dbseek(xfilial()+sf2->(f2_doc+f2_serie+f2_cliente+f2_loja),.f.))

		do while sd2->(!eof().and.d2_filial+d2_doc+d2_serie+d2_cliente+d2_loja==;
		xfilial()+sf2->(f2_doc+f2_serie+f2_cliente+f2_loja))
			if _lPrim
				_lPrim:=.f.
				sz8->(dbsetorder(1)) // z8_filial+z8_status+z8_placa
				_nViagem:=0
				if !sz8->(dbseek(xfilial()+"A"+sF2->F2_placa,.f.))
					// Se nao houverem viagens pendentes, esta e a 1a.
					_nViagem:=1
				else
					sz8->(dbseek(xfilial()+"A"+soma1(sf2->f2_placa),.t.))
					do while sz8->(!bof().and.z8_placa>sf2->f2_placa)
						sz8->(dbskip(-1))
						if sz8->(z8_status=="A".and.z8_placa==sf2->f2_placa)
							_nViagem:=sz8->z8_viagem+1
							exit
						endif
					enddo
				endif
			endif
			sz8->(reclock(alias(),.t.))

			sz8->z8_filial:=xfilial("SZ8")
			//A=Pendente;B=Premio pago;C=Expirado;D=Pagamento ou expiracao de premio
			sz8->Z8_STATUS :="A"
			sz8->Z8_PLACA  :=sf2->f2_PLACA
			sz8->Z8_DOC    :=sf2->f2_DOC
			sz8->Z8_SERIE  :=sf2->f2_SERIE
			sz8->Z8_CLIENTE:=sf2->f2_CLIENTE
			sz8->Z8_LOJA   :=sf2->f2_LOJA
			sz8->Z8_EMISSAO:=sf2->f2_EMISSAO
			sz8->Z8_ITEM   :=sd2->d2_ITEM
			sz8->Z8_PEDIDO :=sd2->d2_PEDIDO
			sz8->Z8_ITEMPV :=sd2->d2_ITEMPV
			sz8->Z8_PRODUTO:=sd2->d2_cod
			sz8->Z8_QUANT  :=sd2->d2_QUANT
			sz8->Z8_PRCVEN :=sd2->d2_PRCVEN
			sz8->Z8_TOTAL  :=sd2->d2_TOTAL
			sz8->Z8_FRETERA:=_fFreteRat()
			sz8->Z8_VIAGEM :=_nViagem

			sz8->(msunlock())
			sd2->(dbskip(1))
		enddo
		sd2->(restarea(_vAmbSd2))
	endif

	*------------------------------------------------------------------------------
static function _fFreteRat()
	* Calcula o frete proporcional do item
	*------------------------------------------------------------------------------
	local _nReturn:=0
	if posicione("SF4",1,xfilial("SF4")+sd2->d2_tes,"f4_duplic")=="S"
		_nReturn:=round(sf2->(f2_frete/f2_valfat)*sd2->(d2_total+d2_valipi),2)
	endif
return _nReturn


User function fAbastec()

	private _nValFrete:=0,_oDlgAbast,_nVlUnit,_nMargem,_nValDisp,;
	_cPictVal:=pesqpict("SF2","F2_PDLITTO"),_nQtLitros:=0

	_dEmis:=sf2->f2_emissao
	_dAbas:=sf2->f2_pddtaba

	u_CriaMv("","N","MV_PDLITUN","0.54","Especifico Polimix. Valor unitario do litro de combustivel (oleo diesel), utilizado para geracao da ordem de abastecimento.")
	u_CriaMv("","N","MV_PDLITMA","80","Especifico Polimix. Percentual maximo do valor do frete da nota que pode ser utilizado para o abastecimento.")

	_aParam := {}

	//       {"X6_FIL","X6_VAR"    ,"X6_TIPO","X6_DESCRIC                                        ","X6_CONTEUD"
	U_CRIASX6("  "    ,"BRI_CLIPOL","C"      ,"Cliente Polimix para Controle de Abastecimento    ","000001"    )

	_cCliente := GETMV("BRI_CLIPOL")

	_lRet := .T.
	/*
	If SF2->F2_CLIENTE != _cCliente
	_lRet := .F.

	If Left(DTOS(SF2->F2_EMISSAO),6) == Left(DTOS(DATE()),6)
	//If Day(dDataBase) >= 01 .And. Day(dDataBase) <= 15
	If Day(DATE()) >= 01 .And. Day(DATE()) <= 15
	If Day(SF2->F2_EMISSAO) >= 01 .And. Day(SF2->F2_EMISSAO) <= 15
	_lRet := .T.
	Endif
	Else
	//If Day(dDataBase) >= 16 .And. Day(dDataBase) <= 31
	If Day(DATE()) >= 16 .And. Day(DATE()) <= 31
	If Day(SF2->F2_EMISSAO) >= 16 .And. Day(SF2->F2_EMISSAO) <= 31
	_lRet := .T.
	Endif
	Endif
	Endif
	Endif
	Endif
	*/
	If !_lRet
		MsgInfo("Nota Fiscal com Data Anterior a Quinzena Atual!!")
		Return()
	Endif

	If sf2->f2_frete>0
		_nValfrete:=sf2->f2_frete
	else
		_vAmbSd2:=sd2->(getarea())
		sd2->(dbsetorder(3))
		sd2->(dbseek(xfilial()+sf2->(f2_doc+f2_serie),.f.))
		_nValfrete:=sd2->d2_pdfretT
		sd2->(restarea(_vAmbSd2))
	endif
	_nVlUnit:=posicione("SA4",1,xfilial("SA4")+sf2->f2_transp,"a4_pdvalit")
	if _nVlUnit==0
		_nVlUnit:=getmv("MV_PDLITUN")
	endif
	_nMargem:=getmv("MV_PDLITMA")/100

	_nValDisp:=round(_nValFrete*_nMargem,2)

	if sf2->f2_pdlitqt==0
		_nQtLitros:=int(_nValDisp/_nVlUnit)
	else
		if !msgyesno("O abastecimento ja foi emitido para esta nota ("+alltrim(str(sf2->f2_pdlitqt))+" litros), deseja emitir novamente ?")
			return
		endif
		_nQtLitros:=int(_nValDisp/_nVlUnit)
	endif

	_nVltot:=round(_nQtLitros*_nVlUnit,2)

	if _nValFrete==0.or._nVlUnit==0
		return
	else
		If !cEmpAnt+ cFilAnt $ "1307/5001/1306/5002/5005"

			@ 0,0 to 100,515 dialog _oDlgAbast title "Abastecimento - Nf "+sf2->(f2_doc+" / "+f2_serie+" Placa: "+left(f2_placa,3)+"-"+substr(f2_placa,4)+" - "+posicione("SZ1",1,xfilial("SZ1")+sf2->f2_placa,"alltrim(z1_nomemot)"))
			@ 005,005 say "Valor total do frete: "
			@ 005,060 get _nValFrete picture _cPictVal size 40,10 when .f.
			@ 005,105 say "Emissao NF: "
			@ 005,145 get _dEmis size 40,10 when .f.
			@ 015,005 say "Valor disponivel:"
			@ 015,060 get _nValDisp picture _cPictVal  size 40,10 when .f.
			@ 015,105 say "Abastecimento: "
			@ 015,145 get _dAbas size 40,10 when .f.
			@ 030,005 say "Quantidade de litros:"
			@ 030,060 get _nQtLitros picture _cPictVal  size 40,10 valid (_nVltot:=round(_nQtLitros*_nVlUnit,2))>=0
			@ 030,105 say "Vl unitario:"
			@ 030,145 get _nVlUnit picture _cPictval size 40,10 valid (_nVltot:=round(_nQtLitros*_nVlUnit,2))>=0//when .f.
			@ 030,190 say "Valor total:"
			@ 030,220 get _nVlTot picture _cPictVal  size 30,10 when .f.
			@ 006,220 bmpbutton type 1 action close(_oDlgAbast)
			activate dialog _oDlgAbast valid _fVldAbast() centered
		Else                 
			_nMargem   := GetMv("MV_PDLITMA")/100
			_nValDisp  := Round(_nValFrete*_nMargem,2)
			_nQtLitros := INT(_nValDisp/_nVlUnit)

			_fVldAbast()
		Endif
	endif

return


Static Function _fVldAbast()

	If _nVltot>_nValDisp
		msgbox("O valor disponivel nao e suficiente para o abastecimento")
		return .f.
	Else
		SF2->(RecLock(alias(),.f.))
		SF2->F2_pdlitqt  := _nQtLitros
		SF2->F2_pdlitun  := _nVlUnit
		SF2->F2_pdlitto  := _nVlTot
		SF2->F2_pddtaba  := ddatabase
		SF2->(MsUnlock())

		If cEmpAnt + cFilAnt $ "1307/5001/1306/5002/5005/5006" .And. _nQtLitros > 0 
			_cNumero := GETSXENUM("SZB","ZB_NUMERO")
			ConfirmSx8()
			SZB->(dbSetOrder(1))
			If SZB->(!dbSeek(xFilial("SZB") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_PLACA))
				SZB->(RecLock("SZB",.T.))
				SZB->ZB_FILIAL := xFilial("SZB")
				SZB->ZB_NFISCAL:= SF2->F2_DOC
				SZB->ZB_SERIE  := SF2->F2_SERIE
				SZB->ZB_CLIENTE:= SF2->F2_CLIENTE
				SZB->ZB_LOJA   := SF2->F2_LOJA
				SZB->ZB_TIPO   := "E"
				SZB->ZB_NUMERO := _cNumero
				SZB->ZB_DATA   := dDataBase
				SZB->ZB_HORA   := Substr(TIME(),1,5)
				SZB->ZB_QUANT  := _nQtLitros
				SZB->ZB_PLACA  := SF2->F2_PLACA
				SZB->ZB_CARTAO := "00"+cEmpAnt + cFilAnt + PADL(Alltrim(_cNumero),14,"0") 
				SZB->ZB_CODEMP := cEmpAnt
				SZB->ZB_CODFIL := cFilAnt
				If SZB->(FieldPos("ZB_TRANSP")) > 0			
					SZB->ZB_TRANSP := SF2->F2_TRANSP
				Endif
				SZB->(MsunLock())
			Endif
		Endif

		If _nQtLitros>0
			_fImpAbast()
		Endif

	Endif

return .t.


Static function _fImpAbast()

	nLastKey  :=0
	limite    :=80
	wnrel     :=nomeprog:="Abastec"
	cDesc1    :="Impressao da Ordem de Abastecimento"
	cDesc2    :=" "
	cDesc3    :=" "
	cString   :="SF2"
	tamanho   := "P"
	titulo    := "Ordem de Abastecimento"
	aReturn := { "Zebrado",;  // Tipo do formulario
	1,;  // Numero de vias
	"Administracao",;  // Destinatario
	2,;  // Formato 1-Comprimido  2-Normal
	2,;  // Midia  1-Disco  2-Impressora
	2,;  // Porta ou arquivo (1-LPT1...)
	"",;  // Expressao do filtro
	1 }  // Ordem (Numero do indice)

	__aImpress[1]:=2

	m_pag     :=1
	Li        :=0
	Cabec1:=""
	Cabec2:=""
	wnrel:=SetPrint(cString,wnrel,_cPerg:=nil,Titulo,cDesc1,cDesc2,cDesc3,.T.)

	if nLastkey==27
		set filter to
		return
	endif

	RptStatus({|| RptDetail() })

	return .t.

	*-------------------------------------------
Static function rptdetail
	Local cLin:=""
	*-------------------------------------------
	setdefault(aReturn,cString)
	setprc(0,0)
	_nLin:=1

	limite:=45

	_vImp:={repl("=",limite)}
	aadd(_vImp,padc(AllTrim(SM0->M0_NOME)+" / "+Alltrim(SM0->M0_FILIAL),limite))

	cLin:=PadR("Dt Nf: "+dtoc(SF2->f2_emissao),limite/2)+" "
	cLin+=PadL('Dt Abast: '+dtoc(SF2->f2_pddtaba),limite/2)
	aadd(_vImp,cLin)
	aadd(_vImp,repl(" ",limite))
	aadd(_vImp,padR("Ordem de Abastecimento NF: "+sf2->(f2_doc+" / "+f2_serie),limite))
	aadd(_vImp,repl("-",limite))
	aadd(_vImp," ")
	aadd(_vImp,"Cliente: "+sf2->(f2_cliente+"/"+f2_loja+" - "+posicione("SA1",1,xfilial("SA1")+f2_cliente+f2_loja,"alltrim(a1_nome)")))
	aadd(_vImp," ")
	aadd(_vImp,"Quantidade de litros.........:    "+tran(sf2->f2_pdlitqt,pesqpict("SF2","F2_PDLITQT")))
	aadd(_vImp,"Valor unitario do litro......: "+tran(sf2->f2_pdlitun,pesqpict("SF2","F2_PDLITUN")))
	aadd(_vImp,"Valor total do abastecimento.: "+tran(sf2->f2_pdlitto,pesqpict("SF2","F2_PDLITTO")))
	aadd(_vImp," ")
	aadd(_vImp,"Placa: "+left(sf2->f2_placa,3)+"-"+substr(sf2->f2_placa,4)+" "+posicione("SZ1",1,xfilial("SZ1")+sf2->f2_placa,"alltrim(z1_nomemot)"))
	aadd(_vImp," ")
	aadd(_vImp,repl("-",limite))

	_nSalto:=9
	setregua(len(_vImp))
	for _nVez:=1 to len(_vImp)
		incregua()
		_cTexto:=(_vImp[_nVez])
		_nLinhas:=mlcount(_cTexto,limite)
		for _nVezL:=1 to _nLinhas
			@ prow()+1,0 PSAY memoline(_cTexto,limite,_nVezL)
		next
	next

	@ prow()+_nSalto,0 psay " "

	If aReturn[5] == 1
		Set Printer To
		Commit
		ourspool(wnrel)
	Endif

	Ms_fLUSH()

Return
