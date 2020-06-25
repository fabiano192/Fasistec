#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"

*------------------------------------------------------------------------------------
User Function VN0020()
	/*
	* Controle das Ordens de Carregamento (SZK)
	* Procedimento para implantacao:
	* - Implementacao deste, Mta410, Mta440c9
	* - Atualizacao de Ms520Vld (para tratar exclusao de nf's)
	* - Criacao de SZK (Sx2,Sx3,Six)
	* - Inclusao dos campos C6_PDGEROC, C9_PDOC e D2_PDOC (C 6)
	* - Inclusao desta rotina no projeto e menus (faturamento)
	* - Inclusao do novo indice (8) de SC9 (_filial+_pdOc)
	*/
	
	Private cCadastro := "Ordens de carregamento"
	
	//U_CriaMv("","N","MV_PDQTDPA","20","ExpecIfico Polimix. Quantidade padrao para a liberacao do pedido - analise de credito")
	
	_aParam  := {}
	//            {"X6_FIL","X6_VAR"   ,"X6_TIPO","X6_DESCRIC"                                  ,"X6_DSCSPA"                                         ,"X6_DSCENG"                                         ,"X6_DESC1"                  						,"X6_DSCSPA1","X6_DSCENG1","X6_DESC2","X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD"   ,"X6_PROPRI"}
	aAdd(_aParam, {"    "    ,"VN_PDQTDPA" ,"C"      ,"Expecifico Polimix. Quantidade padrao para","                                                  ","                                                  ","a liberacao do pedido - analise de credito"   ,""          ,""          , ""       ,""          ,""          ,""             ,"U"})
	
	U_CRIASX6(_aParam)
	
	Private aRotina := 	{ {"Pesquisar"		,"AxPesqui"		,0,1} ,;
		{"Visualizar"		,"AxVisual"		,0,2} ,;
		{"Baixar"			,"U_VN020C()"	,0,2} ,;
		{"Imprimir"			,"U_VN020B()"	,0,2} ,;
		{"Excluir"			,"AxDeleta"		,0,5},;
		{'Legenda'			,'BrwLegenda("Situacao da ordem de carregamento"  ,"Legenda",_vLegenda)', 0 ,3}}
	
	//		{"Relacao de OC's"	,"U_VN020D()"	,0,2} ,;
		//						{"Lib Credito"		,"U_VN020e()"	,0,2} ,;
		
	Private cDelFunc := "U_VN020a()" // Validacao para a exclusao
	Private cString := "SZK"
	
	_vLegenda:=	{{"BR_AZUL"		,'Bloqueado por credito'},;
		{"BR_VERDE"		,'Aguardando carregamento'},;
		{"BR_AMARELO"	,"Aguardando faturamento"},;
		{"BR_VERMELHO"	,"Ordem de carregamento faturada"}}
	
	aCores := 	{{'SZK->ZK_PBRUTO==0.and.!Empty(SZK->ZK_blcred)'	,'BR_AZUL'   },;   // Bloqueado por credito
	{ 'SZK->ZK_PBRUTO==0.and.SZK->ZK_nota=="         "'	,'BR_VERDE'   },;   // Em Aberto
	{ 'SZK->ZK_PBRUTO>0.and.SZK->ZK_nota=="         "' 	,'BR_AMARELO' },; // Aguardando faturamento
	{ 'SZK->ZK_PBRUTO>0.and.SZK->ZK_nota>"         "'  	,'BR_VERMELHO'}}  // Ordem de carregamento faturada
	
	dbSelectArea("SZK")
	dbSetOrder(1)
	mBrowse(,,,,cString,,,,,,aCores)
	
Return



*-----------------------------------------------------
User Function VN020a
	*-----------------------------------------------------
	Local _lReturn:=.T.
	If !Empty(SZK->ZK_nota)
		sf2->(dbSetOrder(1))
		If sf2->(MsSeek(xfilial()+SZK->(ZK_nota+ZK_serie),.F.))
			MsgBox("Esta ordem de carregamento nao podera ser excluida pois gerou nota fiscal")
			_lReturn:=.F.
		Endif
	Endif
	
Return _lReturn

*-----------------------------------------------------
User Function VN020b
	* Impressao da OC
	*-----------------------------------------------------
	If !Empty(SZK->ZK_blcred)
		MsgBox("O pedido foi bloqueado por credito, impressao nao permitida")
		Return
	Endif
	
	nLastKey  :=0
	limite    :=80
	wnrel     :=nomeprog:="VN020b"
	cDesc1    :="Impressao da Ordem de Carregamento"
	cDesc2    :=" "
	cDesc3    :=" "
	cString   :="SZK"
	tamanho   := "P"
	titulo    := "Ordem de carregamento"
	aReturn := { "Zebrado",;  // Tipo do formulario
	1,;  // Numero de vias
	"Administracao",;  // Destinatario
	1,;  // Formato 1-Comprimido  2-Normal
	2,;  // Midia  1-Disco  2-Impressora
	2,;  // Porta ou arquivo (1-LPT1...)
	"",;  // Expressao do filtro
	1 }  // Ordem (Numero do indice)
	
	m_pag     :=1
	Li        :=0
	Cabec1:=""
	Cabec2:=""
	_vBkImp:=aclone(__aImpress)
	/*
	If "guiche"$lower(getcomputername())
		aReturn[6]:=1 // Se for guiche, força padrão LPT1
	Endif
	__aImpress[1]:=3 // Forca impressao padrao 1=Em disco;2=Via Spool;3=Direta na porta;4=E-mail
	__aImpress[2]:=1
	__aImpress[3]:=2 // Forca impressao padrao 1=Cliente;2=Servidor
	__aImpress[4]:=1
	*/
	//wnrel := SetPrint(cString,wnrel,,@Titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,tamanho)
	
	__aImpress[1]:=2 // Forca impressao padrao 1=Em disco;2=Via Spool;3=Direta na porta;4=E-mail
	
	wnrel:=SetPrint(cString,wnrel,_cPerg:=nil,Titulo,cDesc1,cDesc2,cDesc3,.T.)
	
	__aImpress[1]:=_vBkImp[1]
	__aImpress[2]:=_vBkImp[2]
	__aImpress[3]:=_vBkImp[3]
	__aImpress[4]:=_vBkImp[4]
	
	If nLastkey==27
		set filter to
		Return
	Endif
	
	RptStatus({|| RptDetail() })
	
	*-------------------------------------------
Static Function rptdetail
	*-------------------------------------------
	setdefault(aReturn,cString)
	setprc(0,0)
	_nLin:=1
	
	limite:=45
	
	do while SZK->(!reclock(alias(),.F.))
	enddo
	SZK->ZK_hruimp:=left(time(),5)
	SZK->(msunlock())
	
	_vImp:={repl("=",limite)}
	//aadd(_vImp,padc("BRITTA - "+dtoc(SZK->ZK_emissao)+" - "+SZK->ZK_hruimp+" h",limite))
	aadd(_vImp,padc(AllTrim(SM0->M0_NOME)+" / "+ Alltrim(SM0->M0_FILIAL),limite))
	aadd(_vImp,padc(dtoc(SZK->ZK_emissao)+" - "+SZK->ZK_hruimp+" h",limite))
	aadd(_vImp,repl(" ",limite))
	aadd(_vImp,padc("Ordem de Carregamento No.: "+SZK->ZK_num,limite))
	aadd(_vImp,repl("-",limite))
	aadd(_vImp,"")
	aadd(_vImp,"Cliente: "+SZK->ZK_nomcli)
	aadd(_vImp,"")
	aadd(_vImp,"Destino: "+SZK->ZK_descee)
	SZK->(aadd(_vImp,alltrim(ZK_pdbaie)+" - "+ Alltrim(ZK_pdmune)))
	aadd(_vImp,"")
	aadd(_vImp,"Produto: "+ Alltrim(SZK->ZK_produto)+" - "+posicione("SB1",1,xfilial("SB1")+SZK->ZK_produto,"alltrim(b1_desc)"))
	aadd(_vImp,"")
	aadd(_vImp,"Placa: "+left(SZK->ZK_placa,3)+"-"+substr(SZK->ZK_placa,4)+"  -  Pedido: "+SZK->ZK_numpv)
	aadd(_vImp,"")
	// Ricardo - depuracao de problemas na gravacao do pedido
	SZK->(aadd(_vImp,"Transp..: "+ZK_transp+" - "+posicione("SA4",1,xfilial("SA4")+ZK_transp,"left(a4_nome,25)")))
	SZK->(aadd(_vImp,"Vendedor: "+ZK_vend1+" - "+posicione("SA3",1,xfilial("SA3")+ZK_vend1,"left(a3_nome,25)")))
	
	aadd(_vImp,repl("-",limite))
	_cArq:="c:\Bema.txt"
	_cConteudo:=""
	_nLin:=0
	setregua(len(_vImp))
	for _nVez:=1 to len(_vImp)
		incregua()
		_cTexto:=(_vImp[_nVez])
		_nLinhas:=mlcount(_cTexto,limite)
		for _nVezL:=1 to _nLinhas
			@ _nLin++,0 PSAY memoline(_cTexto,limite,_nVezL)
			//@ _nLin++,0 PSAY left(strzero(_nLin,3)+memoline(_cTexto,limite,_nVezL),limite)
			_cConteudo+=memoline(_cTexto,limite,_nVezL)+chr(13)+chr(10)
		next
	next
	
	// Alimentacao para o corte
	@ _nLin+9,0 psay " "
	
	If aReturn[5] == 1
		Set Printer To
		Commit
		ourspool(wnrel)
	Endif
	
	ms_fLUSH()
	
Return

//Baixa da OC
User Function VN020C()
	
	Local _lDigPeso	:=.F.
	Local _bPeso
	
	Private _oDlg
	Private _cOC		:= space(6)
	Private _cPlaca		:= space(len(SZK->ZK_placa))
	Private _cMotorista	:= _cEndEnt:=""
	Private	_cPictPeso	:= pesqpict("SZK","ZK_PBRUTO")
	Private _cNomeMot
	Private _lReturn	:= .F.
	Private	_nTara		:= _nPliq := _nPEmb := 0
	Private _nPrUnit	:=0
	Private _nVlrTot	:=0
	PRIVATE _xNumCC		:= ""
	Private _cTpPes		:= Space(10)
	
	Public _nPBruto  	:=0
	
	_cLacre          := space(7)
	
	_aParam  := {}
	//            {"X6_FIL","X6_VAR"   ,"X6_TIPO","X6_DESCRIC"                                  ,"X6_DSCSPA"                                         ,"X6_DSCENG"                                         ,"X6_DESC1"                  ,"X6_DSCSPA1","X6_DSCENG1","X6_DESC2","X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD"   ,"X6_PROPRI"}
	aAdd(_aParam, {"    "    ,"VN_CLILAC" ,"C"      ,"Cliente Que Utiliza Lacre de Carregamento","                                                  ","                                                  ",""                          ,""          ,""          , ""       ,""          ,""          ,""             ,"U"})
	
	U_CRIASX6(_aParam)
	
	_cCliLacre       := GETMV("VN_CLILAC")
	
	_bPeso := "If(cEmpAnt=='01'.and.cFilant=='04',U_LeBjMro(),U_LeBjBritta()),If(Type('_oPBruto')=='O',_oPBruto:Refresh(),'')"
	
	//_nPesoFin := 0
	Private cTpOper := 'C'
	_bTara := 'U_PesoBal(@_nPBruto,"SAIDA","F")'
	//	_bTara := "U_BALS(@_nPBruto,@_nTara,@_nPLiq,@_nPrUnit,@_nVlTot)"
	
	setkey(123,{|| &_bPeso} )
	setkey(122,{|| &_bTara})
	
	_lDigPeso :=  U_PXH042("DIGITAPESO",6,.F.)
	
	If !_lDigPeso
		Eval({|| &_bPeso })
	Endif
	
	
	@ 0,0 to 210,550 Dialog _oDlg title "Baixa da Ordem de Carregamento"
	
	@ 010,005 say "Numero: "
	@ 010,055 get _cOC valid (vazio().or._fVldOc('Numero')) F3 "SZK" size 45,10
	
	@ 007,140 Button "Imprime Ticket" size 50,12 Action U_fTicket(_cPlaca,_nPBruto,'Peso Bruto') object _oImpTicket
	
	_oImpTicket:BWhen:={||_nPBruto>0.and.!Empty(_cPlaca)}
	
	@ 007,217 button "F11 - Captura peso" size 50,12 Action (Eval({|| &_bTara }),U_fVldPBruto()) object _oCaptura
	_oCaptura:BWhen:={||!Empty(_cOC)}
	
	@ 025,005 say "Placa do veiculo: "
	@ 025,055 get _cPlaca Picture '@!' size 45,10 When .F. valid vazio().or.(_fVldOc('Placa').and._fFocus())
	
	@ 025,110 say "Motorista:"
	@ 025,140 get _cNomeMot size 127,10 when .F.
	
	@ 040,005 say "End. de Entrega: "
	@ 040,055 get _cEndent size 227,10 when .F.
	
	@ 055,005 say "Peso Bruto: "
	@ 055,055 get _nPBruto Picture _cPictPeso size 45,10 WHEN _lDigPeso VALID U_fVldPBruto("S") object _oPBruto
	
	@ 055,110 say "Peso Inicial: "
	@ 055,140 get _nTara when .F. size 45,10 Picture _cPictPeso
	
	@ 055,190 say "Embalagem: "
	@ 055,222 get _nPEmb when .F. size 45,10 Picture _cPictPeso object _oPEmbal
	
	@ 070,005 say "Peso Liquido: "
	@ 070,055 get _nPLiq when .F. size 45,10 Picture _cPictPeso
	
/*
	_nPrUnit := _nVlTot:=0
	@ 070,110 say "Vl Unit"
	_cPictVal := "@er 9,999.99"
	@ 070,140 get _nPrUnit when .F. size 45,10 Picture _cPictVal
	
	@ 070,190 say "Valor total: "
	@ 070,222 get _nVlTot when .F. size 45,10 Picture _cPictVal
*/	
	_cProduto := Space(15)
	@ 070,110 say "Produto"
	@ 070,140 get _cProduto size 045,15 when .F.
	
	@ 070,190 Say "Lacre"
	@ 070,222 get _cLacre   Size 045,15 When SZK->ZK_CLIENTE + SZK->ZK_LOJACLI $ _cCliLacre   VALID !Vazio()
	
	@ 085,005 say "Tipo Pesagem: "
	@ 085,055 get _cTpPes when .F. size 45,10

	@ 085,200 bmpbutton type 1 Action (_lReturn:=_fBaixaOc(_xNumCC,_lReturn)) object _oBut1
	@ 085,240 bmpbutton type 2 Action close(_oDlg)
	
	Activate Dialog _oDlg centered
	
	setkey(123,{||nil})
	
Return _lReturn



Static Function _fFocus()
	*---------------------------------------------------------------------------------------
	_oBut1:Setfocus()
Return .T.



Static Function _fVldOc(_cNumPlaca)
	
	Local _lReturn := _lAchou := .F.
	
	Cursorwait()
	
	If _cNumPlaca == Nil
		_cNumPlaca:='Numero'
	Endif
	
	If _cNumPlaca == 'Numero'
		SZK->(dbSetOrder(1))
		If SZK->(MsSeek(xfilial()+_cOc,.F.))
			_lAchou := .T.
		Endif
	ElseIf _cNumPlaca=='Placa'
		SZK->(dbSetOrder(5))  // ZK_FILIAL+ZK_PLACA+ZK_NOTA+DTOS(ZK_EMISSAO)+ZK_NUM
		SZK->(MsSeek(xfilial()+_cPlaca+space(len(ZK_nota)),.F.))
		Do while SZK->(!eof().and.ZK_filial+ZK_placa+ZK_nota==xfilial()+_cPlaca+space(len(ZK_nota)))
			If SZK->ZK_PBRUTO == 0
				_cOc := SZK->ZK_num
			Endif
			SZK->(dbskip(1))
		Enddo
		
		SZK->(dbSetOrder(1))
		If SZK->(MsSeek(xfilial()+_cOc,.F.))
			_lAchou := .T.
		Endif
	Endif
	
	If _lAchou
		
		SC5->(dbSetOrder(1))
		SC5->(MsSeek(xFilial("SC5")+SZK->ZK_NUMPV))
		
		If !Empty(SZK->ZK_NOTA)
			MsgBox("Esta ordem de carregamento ja gerou nota fiscal")
		ElseIf !Empty(SZK->ZK_blcred)
			MsgBox("Esta ordem de carregamento foi bloqueada por credito")
		Else
			If SZK->ZK_PBRUTO == 0 .or. (SZK->ZK_PBRUTO <> 0 .and.;
					MsgYesNo("Esta ordem de carregamento ja foi apontada (Peso bruto = "+Tran(SZK->ZK_PBRUTO,_cPictPeso)+"), deseja apontar novamente ?"))
				
				_cProduto	:= SZK->ZK_PRODUTO
				
				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				If SB1->(msSeek(xFilial("SB1")+_cProduto))
					
					_nTara  	:= SZK->ZK_PESOVEI
					//				_nTara  	:= SZK->ZK_tara
					_cPlaca 	:= SZK->ZK_placa
					_cNomeMot	:= Alltrim(SC5->C5_YNOMMOT)
					_cEndent	:= SZK->(alltrim(ZK_DESCEE)+" - "+ Alltrim(ZK_PDBAIE)+" - "+ Alltrim(ZK_PDMUNE))
					_nPBruto	:= If(SZK->ZK_PBRUTO <> 0,SZK->ZK_PBRUTO,_nPBruto)
					
					/*
					_nLiq  := _nPBruto-_nTara
					_nPEmb := 0
					If !Empty(SB1->B1_YEMBALA) .And. SB1->B1_CONV > 0
						dbSelectArea("CB3")
						CB3->(dbSetOrder(1))
						If CB3->(msSeek(xFilial("CB3")+SB1->B1_YEMBALA))
							_nPEmb := (Round((_nLiq / SB1->B1_CONV)/ CB3->CB3_YQTDEM,0))* CB3->CB3_PESO
						Endif
					Endif
					
					_nPLiq  := _nLiq - _nPEmb
					
					*/
					SC6->(dbSetOrder(1))
					SC6->(MsSeek(xfilial()+SZK->(ZK_NUMPV+ZK_ITEMPV),.F.))
					
					_nPLiq  	:= _nPBruto - _nTara

					_nPrUnit	:= SC6->C6_PRCVEN
					_nVlTot		:= Round(_nPliq * _nPrunit,2)
					
					U_fVldPBruto()

					_lReturn := .T.
				Endif
			Endif
		Endif
	Else
		MsgBox("Ordem de carregamento nao encontrada")
	Endif
	
	cursorarrow()
	
	If Type("_oPBruto") =="O"
		_oPBruto:Refresh()
	Endif
	
Return _lReturn



Static Function _fBaixaOc(_xNumCC,_lReturn)
	
	Local _lReturn:=.F.,_vAmbSc9:=sc9->(getarea())
	
	If Empty(_cOc)
		Return _lReturn
	Endif
	
	If SZK->ZK_CLIENTE + SZK->ZK_LOJACLI $ _cCliLacre
		If Empty(_cLacre)
			MsgInfo("Favor Informar o Lacre!!")
			Return .F.
		Endif
	Endif
	
	If _nPBruto==0
		alert("Problemas na leitura do peso")
		Return .F.
	Endif
	
	If _nPLiq <=0 .or. _nPBruto <= _nTara
		Alert("Peso Invalido. VerIfique a Placa/OC, Peso Bruto e Tara")
		Return .F.
	Endif
	
	If !Empty(_cOC) .and. _nPBruto <> 0 .and. SZK->ZK_NUM == _cOC
		
		_lReturn := .T.
		
		SC5->(dbSetOrder(1))
		If SC5->(MsSeek(xFilial("SC5")+SZK->ZK_NUMPV))
			
			SC5->(Reclock("SC5",.F.))
			SC5->C5_PBRUTO:= _nPBruto
			SC5->C5_PESOL := _nPLiq
			SC5->(Msunlock())
			
			SC6->(dbSetOrder(1))
			If SC6->(MsSeek(xFilial("SC6")+SZK->ZK_NUMPV+SZK->ZK_ITEMPV))
				
				_nPsEmba := 0
				_nPesliq := _nPLiq//Round(_nPesoM,0) - SC6->C6_YPESINI
				_nC6QTDV := SC6->C6_QTDVEN
				
				_nDif    := 0
				If _nC6QTDV <> Round(_nPLiq,0) .And. !Empty(SC6->C6_SEGUM) //Conforme contato com Luccas, o bloqueio só pode ocorrer se tiver a 2ª UM.
					
					_nDif 		:= _nPLiq - _nC6QTDV
					_nDif		:= If(_nDif < 0,_nDif *-1,_nDif)
					_nLimite	:= GETMV("PXH_LIMPES")
					_nLimPeso 	:= _nC6QTDV * (_nLimite/100)
					
					_cMsg2 := 'Quantidade Programação: '+ Tran(_nC6QTDV,_cPictPeso)
					_cMsg3 := 'Quantidade Atual:       '+ Tran(_nPesliq,_cPictPeso)
					_cMsg4 := 'Diferença:              '+ Tran(_nDif,_cPictPeso)
					
					If _nDif > _nLimPeso
						_lReturn := .F.
						//						SC5->(RecLock('SC5',.F.))
						//						SC5->C5_BLQ := 'B'
						//						SC5->(MsUnlock())
						
						_cMsg1 := 'Quantidade carregada diferente da programação e superior ao limite de '+cValtoChar(_nLimite)+'%'
						
						_lReturn := VN020Pswd(_cMsg1,_cMsg2,_cMsg3,_cMsg4)
						
					Else
						_cMsg1 := 'Quantidade carregada diferente da programação e inferior ao limite de '+cValtoChar(_nLimite)+'%, '+CRLF+;
							'portanto o Pedido está liberado para ser Faturado!'
						MsgAlert(_cMsg1+CRLF+CRLF+_cMsg2+CRLF+_cMsg3+CRLF+_cMsg4)
					Endif
					
					//					MsgAlert(_cMsg+CRLF+;
						//						'Quantidade Programação: '+ Alltrim(Transform(_nC6QTDV,"@E9,999,99.99"))+CRLF+;
						//						'Quantidade Atual:       '+ Alltrim(Transform(_nPesliq,"@E9,999,99.99"))	+CRLF+;
						//						'Diferença:              '+ Alltrim(Transform( _nDif,"@E9,999,99.99")))
				Endif
				
				
				If _lReturn
					SC6->( RecLock("SC6",.F.) )
					SC6->C6_YPESFIN := Round(_nPBruto,0)
					SC6->C6_YPESLIQ := Round(_nPLiq,0)
					SC6->C6_YHORFIN := time()
					SC6->C6_YPSEMBA := _nPsEmba
					
					If SC6->C6_YQTORIG = 0
						SC6->C6_YQTORIG := SC6->C6_QTDVEN
					Endif
					SC6->C6_QTDVEN  := SC6->C6_YPESLIQ
					SC6->C6_QTDLIB  := SC6->C6_YPESLIQ
					SC6->C6_VALOR   := SC6->C6_PRCVEN * SC6->C6_QTDVEN
					
					SC6->C6_OP      := '06'
					SC6->C6_YSTATUS := "6"//CSTATUS
					SC6->C6_YTPPSFI := Left(_cTpPes,1)
					
					a410Refr("C6_QTDLIB")
					
					SC6->(MsUnlock())
					
					dbSelectArea("SZK")
					SZK->(Reclock("SZK",.F.))
					SZK->ZK_PBRUTO := _nPBruto
					SZK->ZK_PLIQ   := _nPLiq
					If SZK->(FieldPos("ZK_LACRE")) > 0
						SZK->ZK_LACRE := _cLacre
					Endif
					SZK->(MsUnlock())
					
					SC9->(dbSetOrder(1))
					If SC9->(msSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))
						SC9->(RecLock("SC9"),.F.)
						SC9->(dbDelete())
						SC9->(MsUnLock())
						
						SC5->(RecLock("SC5"),.F.)
						SC5->C5_LIBEROK := ''
						SC5->(MsUnLock())
						
					Endif
					
					dbSelectArea("SC6")
					
					MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.T.,.T.)
					
					dbSelectArea("SC9")
					SC9->(dbSetOrder(1))
					If SC9->(msSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))
						
						SC9->(RecLock("SC9"),.F.)
						SC9->C9_BLEST := ''
						SC9->(mSunLock())
						
						MaLiberOk({ SC5->C5_NUM },.T.)
					Endif
					
				Endif
				/*
				sc9->(dbSetOrder(9))
				If sc9->(Empty(c9_nfiscal).and.reclock(alias(),.F.))
					
					// verIfica se a sequencia de liberacao esta em ordem, prevenindo chave duplicada
					_cSequen:=sc9->c9_sequen
					_vAmbSc9:=sc9->(getarea())
					sc9->(dbSetOrder(1))
					do while sc9->(MsSeek(sc9->(xfilial()+c9_pedido+c9_item+_cSequen+c9_produto),.F.))
						_cSequen:=soma1(_cSequen)
					enddo
					sc9->(restarea(_vAmbSc9))
					
					sc9->c9_filial:=xfilial("SC9")
					sc9->c9_sequen:=_cSequen
					sc9->c9_blest:=""
					_nQtdLib:=sc9->c9_qtdlib
					_nQtdLIb2:=sc9->c9_qtdlib2/_nQtdLib*SZK->ZK_pliq
					sc9->c9_qtdlib:=SZK->ZK_pliq
					sc9->c9_qtdlib2:=round(_nQtdLib2,2)
					
					sc9->c9_blcred:=SZK->ZK_blcred
					sc9->(msunlock())
					
					// Atualiza dados no cabecalho do pedido
					SC5->(dbSetOrder(1))
					If SC5->(MsSeek(xFilial()+SZK->ZK_NUMPV,.F.))
						
						//						sc5->c5_frete:=SZK->(ZK_pliq*ZK_vlrfret)
						//						sc5->c5_transp:=SZK->ZK_transp
						//						sc5->c5_vend1:=SZK->ZK_vend1
						//						sc5->c5_placa:=SZK->ZK_placa
						//						sc5->c5_nomemot:=posicione("SA3",1,xfilial("SA3")+sc5->c5_vend1,"A3_NREDUZ")
						//						sc5->c5_nometra:=posicione("SA4",1,XFILIAL("SA4")+sc5->C5_TRANSP,"A4_NREDUZ")
						
						
						SC5->(Reclock("SC5",.F.)))
						//SC5->C5_VOLUME1:=ROUND(_nPLiq,0)
						SC5->C5_PBRUTO:= _nPBruto
						SC5->C5_PESOL := _nPLiq
						SC5->(Msunlock())
						
					Endif
					
					_lReturn:=.T.
				Endif
				*/
				//				Endif
			Endif
		Endif
	Endif
	
	If _lReturn
		
		_xNumDoc := SF2->F2_DOC+SF2->F2_SERIE
		
		_dDatBkp := dDataBase
		_dEmissao:= dDataBase
		_cHora   := Left(time(),5)
		_cMin    := Right(_cHora,2)
		
		If SM0->M0_ESTCOB $ "AC/AM/MT/MS/RO/RR"
			If _cHora   == "00"
				_dEmissao--
				_cHora  := "23:" + _cMin
			Else
				_cHora := Strzero(Val(_cHora)-1,2) + ":" + _cMin
			Endif
		Endif
		
		If GETMV("MV_HVERAO")  /// SE VERDADEIRO ENTAO TEM HORARIO DE VERÃO
			If !SM0->M0_ESTCOB $ "DF/GO/ES/MT/MS/MG/PR/RJ/RS/SP/SC"   // ESTADOS QUE NAO TEM HORARIO DE VERAO
				If _cHora   == "00"
					_dEmissao--
					_cHora    := "23:" + _cMin
				Else
					_cHora := Strzero(Val(_cHora)-1,2) + ":" + _cMin
				Endif
			Endif
		Endif
		
		dDataBase := _dEmissao
		
		MATA460A() // Faturamento padrao do sistema
		
		dDataBase := _dDatBkp
		
		If _xNumDoc <> SF2->F2_DOC+SF2->F2_SERIE
			RECLOCK("SF2",.F.)
			SF2->F2_XNCCRED := _xNumCC
			MSUNLOCK()
			RECLOCK("SE1",.F.)
			SE1->E1_XNCCRED := _xNumCC
			MSUNLOCK()
		Endif
	Endif
	
	If !_lReturn
		MsgBox("A ordem de carregamento nao foi baixada ZK_NUM: ("+SZK->ZK_num+") _cOC: ("+_cOc+") _nPBruto: "+ Alltrim(str(_nPBruto)))
	Endif
	
	close(_oDlg)
Return _lReturn


User Function fVldPBruto(_cOpt)
	
	Local _lReturn := (_nPBruto > 0)
	
	Default _cOpt := "N"
	
	If _lReturn
		
		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		If SB1->(msSeek(xFilial("SB1")+_cProduto))
			
			_nLiq  := _nPBruto-_nTara
			_nPEmb := 0
			If !Empty(SB1->B1_YEMBALA) .And. SB1->B1_CONV > 0
				dbSelectArea("CB3")
				CB3->(dbSetOrder(1))
				If CB3->(msSeek(xFilial("CB3")+SB1->B1_YEMBALA))
					_nQt1  := If(Int(_nLiq / SB1->B1_CONV / CB3->CB3_YQTDEM) = 0, 1,Int(_nLiq / SB1->B1_CONV / CB3->CB3_YQTDEM)) 
					_nPEmb := _nQt1 * CB3->CB3_PESO
//					_nPEmb := (Round((_nLiq / SB1->B1_CONV)/ CB3->CB3_YQTDEM,0))* CB3->CB3_PESO
				Endif
			Endif
			
			_nPLiq  := _nLiq - _nPEmb
			_nVlTot := round(_nPLiq*_nPrUnit,2)
			
		Endif
		
		If _cOpt = "S"
			_cTpPes  := "Manual"
		Endif
	Endif
	
Return _lReturn



User Function VN020d
	* Relacao de OC's
	*----------------------------------------------------------------------------------------
	
	nLastKey  :=0
	limite    :=132
	wnrel     :=nomeprog:="VN020d"
	cDesc1    :="Relacao de ordens de Carregamento"
	cDesc2    :=" "
	cDesc3    :=" "
	cString   :="SZK"
	tamanho   := "M"
	titulo    := cDesc1
	aReturn := { "Zebrado",;  // Tipo do formulario
	1,;  // Numero de vias
	"Administracao",;  // Destinatario
	2,;  // Formato 1-Comprimido  2-Normal
	2,;  // Midia  1-Disco  2-Impressora
	2,;  // Porta ou arquivo (1-LPT1...)
	"",;  // Expressao do filtro
	1 }  // Ordem (Numero do indice)
	_cPergD:="FAt10d"
	validperg(_cPergD)
	
	m_pag     :=1
	Li        :=99
	Cabec1:="Numero  Emissao  Impressao Placa     Motorista                     Pedido  Produto         Peso Liq  NF     Serie Situacao"
	Cabec2:=""
	//wnrel := SetPrint(cString,wnrel,,@Titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,tamanho)
	wnrel:=SetPrint(cString,wnrel,_cPergD,Titulo,cDesc1,cDesc2,cDesc3,.T.)
	If nLastkey==27
		set filter to
		Return
	Endif
	
	RptStatus({|| Rpt10d() })
	
	*-------------------------------------------
Static Function rpt10d
	*-------------------------------------------
	pergunte(_cPergD,.F.)
	_dDataIni :=mv_par01
	_dDataFim :=mv_par02
	_nSituacao:=mv_par03 // 1=Aguard carregamento,2=Aguard faturamento,3=Faturadas,4=Todas
	
	_cFiltro:="dtos(ZK_emissao)>='"+dtos(_dDataIni)+"'.and.dtos(ZK_emissao)<='"+dtos(_dDataFim)+"'"
	If _nSituacao==1
		_cFiltro+=".and.ZK_pbruto==0"
	ElseIf _nSituacao==2
		_cFiltro+=".and.ZK_pbruto>0.and.Empty(ZK_nota)"
	ElseIf _nSituacao==3
		_cFiltro+=".and.!Empty(ZK_nota)"
	Endif
	SZK->(dbSetOrder(1))
	SZK->(indregua(alias(),criatrab(,.F.),indexkey(),,_cFiltro))
	
	setdefault(aReturn,cString)
	
	setregua(SZK->(lastrec()))
	SZK->(dbgotop())
	
	do while SZK->(!eof())
		_cSit:=""
		
		SC5->(dbSetOrder(1))
		SC5->(MsSeek(xFilial("SC5")+SZK->ZK_NUMPV))
		
		If SZK->(ZK_pbruto==0)
			_cSit:="Aguardando carregamento"
		ElseIf SZK->(ZK_pbruto>0.and.Empty(ZK_nota))
			_cSit:="Aguardando faturamento"
		ElseIf SZK->(!Empty(ZK_nota))
			_cSit:="Faturada"
		Endif
		
		@ _fIncrLin(),0 psay SZK->(ZK_num+"  "+dtoc(ZK_emissao)+"  "+SZK->ZK_hruimp+" h  "+left(ZK_placa,3)+"-"+substr(ZK_placa,4)+"  "+Left(SC5->C5_YNOMMOT,30)+;
			ZK_numpv+"  "+ZK_produto+" "+tran(ZK_pliq,pesqpict("SC6","C6_QTDVEN"))+" "+ZK_nota+" "+ZK_serie)+"   "+_cSit
		SZK->(dbskip(1))
	enddo
	
	roda(0,"",tamanho)
	
	If aReturn[5] == 1
		Set Printer To
		Commit
		ourspool(wnrel)
	Endif
	MS_FLUSH()
Return

*--------------------------------------------------------------------------
User Function VN020e
	* Liberacao de credito
	*--------------------------------------------------------------------------
	If msgyesno("Confirma a liberacao de credito ?").and.SZK->(reclock(alias(),.F.))
		SZK->ZK_blcred:=""
		SZK->(msunlock())
	Endif
	
Return

*--------------------------------------------------------------------------
Static Function _fIncrLin(_nIncr)
	*--------------------------------------------------------------------------
	If _nIncr==nil
		_nIncr:=1
	Endif
	li+=_nIncr
	If Li > 61
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
	Endif
Return li

*------------------------------------------------------------------------------------
User Function LeBjBritta()
	* Ricardo Luiz da Rocha 01/04/2009 GNSJC
	*------------------------------------------------------------------------------------
	Local _cDir:="c:\",_cEscopo:="peso.txt"
	Local _nLePeso:=0,_nVez:=0
	
	If cEmpAnt='08' //File("c:\balanca\"+_cEscopo)
		_cDir:="c:\balanca\"
	Endif
	
	If cEmpAnt $ "02/12" .Or. (cEmpAnt == "50" .And. cFilAnt == "04")
		_cEscopo:= "peso1.txt"
	Endif
	
	If funname()=='PDFATA11'
		_vDir:=directory(_cDir+_cEscopo)
		// Colhe o nome do arquivo mais recente
		
		asort(_vDir,,,{|_vAux1,_vAux2|dtos(_vAux1[3])+_vAux1[4]>=dtos(_vAux2[3])+_vAux2[4]})
		
		_vPeso:={}
		cursorwait()
		do while len(_vDir)>0.and._nVez<10 //200 // quantidade de leituras a fazer para obter a leitura mais frequente
			_cPeso:=memoread(_cDir+_vDir[1][1])
			_cPeso:=strtran(_cPeso,chr(13),'')
			_cPeso:=strtran(_cPeso,chr(10),'')
			_cPeso:=right(_cPeso,6)
			If len(_vPeso)<2000
				aadd(_vPeso,_cPeso)
			Endif
			_nVez++
		enddo
		_nLePeso:=0
		If len(_vPeso)>0
			_vPeso2:={}
			// classIfica por peso lido
			asort(_vPeso)
			_nOcor:=0
			_cPeso:=_vPeso[1]
			for _nVez:=1 to len(_vPeso)
				_nOcor++
				If _vPeso[_nVez]<>_cPeso.or._nVez==len(_vPeso)
					aadd(_vPeso2,strzero(_nOcor,6)+_cPeso)
					_nOcor:=0
				Endif
			next
			asort(_vPeso2)
			_nLePeso:=val(substr(_vPeso2[len(_vPeso2)],7))
		Endif
		cursorarrow()
	Else
		setkey(123,{||nil})
	Endif
	
	_nPBruto:=round(_nLePeso/1000,2)
	
	//_oPBruto:Refresh()
	U_fVldPBruto()
	
Return .T.

*------------------------------------------------------------------------------------
User Function LeBjMro()
	* Ricardo Luiz da Rocha 07/07/2010 GNSJC
	*------------------------------------------------------------------------------------
	Local _cDir:="c:\",_cEscopo:="peso.txt",_nLePeso:=0,_nVez:=0
	
	If cEmpAnt == "12" .Or. (cEmpAnt == "50" .And. cFilAnt == "04")
		_cEscopo:= "peso1.txt"
	Endif
	
	If funname()=='PDFATA11'
		_vDir:=directory(_cDir+_cEscopo)
		// Colhe o nome do arquivo mais recente
		
		asort(_vDir,,,{|_vAux1,_vAux2|dtos(_vAux1[3])+_vAux1[4]>=dtos(_vAux2[3])+_vAux2[4]})
		
		_vPeso:={}
		cursorwait()
		do while len(_vDir)>0.and._nVez<=10 //200 // quantidade de leituras a fazer para obter a leitura mais frequente
			_cPeso:=memoread(_cDir+_vDir[1][1])
			_cPeso:=strtran(_cPeso,chr(13),'')
			_cPeso:=strtran(_cPeso,chr(10),'')
			_cPeso:=right(_cPeso,6)
			If len(_vPeso)<2000
				aadd(_vPeso,_cPeso)
			Endif
			_nVez++
		enddo
		_nLePeso:=0
		If len(_vPeso)>0
			_vPeso2:={}
			// classIfica por peso lido
			asort(_vPeso)
			_nOcor:=0
			_cPeso:=_vPeso[1]
			for _nVez:=1 to len(_vPeso)
				_nOcor++
				If _vPeso[_nVez]<>_cPeso.or._nVez==len(_vPeso)
					aadd(_vPeso2,strzero(_nOcor,6)+_cPeso)
					_nOcor:=0
				Endif
			next
			asort(_vPeso2)
			_nLePeso:=val(substr(_vPeso2[len(_vPeso2)],7))
		Endif
		cursorarrow()
	Else
		setkey(123,{||nil})
	Endif
	
	_nPBruto:=round(_nLePeso/1000,2)
	
	U_fVldPBruto()
	// Eliminado, abortando quando o arquivo estava indisponível //ferase("c:\peso.txt")
Return .T.

*-----------------------------------------------------
User Function fTicket(_cPPlaca,_nPPeso,_cPTipo)
	* Impressao do ticket da balança
	*-----------------------------------------------------
	
	nLastKey  :=0
	limite    :=80
	wnrel     :=nomeprog:="fTicket"
	cDesc1    :="Impressao do ticket da balança"
	cDesc2    :=" "
	cDesc3    :=" "
	cString   :="SZK"
	tamanho   := "P"
	titulo    := "Ticket - comprovante de pesagem"
	aReturn := { "Zebrado",;  // Tipo do formulario
	1,;  // Numero de vias
	"Administracao",;  // Destinatario
	1,;  // Formato 1-Comprimido  2-Normal
	3,;  // Midia  1-Disco  2-Impressora
	2,;  // Porta ou arquivo (1-LPT1...)
	"",;  // Expressao do filtro
	1 }  // Ordem (Numero do indice)
	
	m_pag     :=1
	Li        :=0
	Cabec1:=""
	Cabec2:=""
	_vBkImp:=aclone(__aImpress)
	If "guiche"$lower(getcomputername())
		aReturn[6]:=1 // Se for guiche, força padrão LPT1
	Endif
	__aImpress[1]:=3 // Forca impressao padrao 1=Em disco;2=Via Spool;3=Direta na porta;4=E-mail
	__aImpress[2]:=1
	__aImpress[3]:=2 // Forca impressao padrao 1=Cliente;2=Servidor
	__aImpress[4]:=1
	
	//wnrel := SetPrint(cString,wnrel,,@Titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,tamanho)
	wnrel:=SetPrint(cString,wnrel,_cPerg:=nil,Titulo,cDesc1,cDesc2,cDesc3,.T.)
	
	__aImpress[1]:=_vBkImp[1]
	__aImpress[2]:=_vBkImp[2]
	__aImpress[3]:=_vBkImp[3]
	__aImpress[4]:=_vBkImp[4]
	
	If nLastkey==27
		set filter to
		Return
	Endif
	
	RptStatus({|| RptTicket(_cPPlaca,_nPPeso,_cPTipo)})
	
	*-------------------------------------------------------
Static Function rptTicket(_cPPlaca,_nPPeso,_cPTipo)
	*-------------------------------------------------------
	cPictPeso:=pesqpict("SZK","ZK_PBRUTO")
	
	setdefault(aReturn,cString)
	setprc(0,0)
	_nLin:=1
	
	limite:=45
	
	_vImp:={repl("=",limite)}
	aadd(_vImp,left(sm0->m0_nomecom,limite))
	aadd(_vImp,left('CNPJ: '+tran(sm0->m0_cgc,'@R 99.999.999/9999-99'),limite))
	aadd(_vImp,repl(" ",limite))
	aadd(_vImp,padc("Emissao: "+dtoc(ddatabase)+" - "+time()+" h",limite))
	aadd(_vImp,repl(" ",limite))
	aadd(_vImp,"Placa: "+_cPPlaca+"   "+_cPTipo+": "+tran(_nPPeso,_cPictPeso)+' Kg')
	aadd(_vImp,"")
	aadd(_vImp,repl("-",limite))
	_cArq:="c:\Bema.txt"
	_cConteudo:=""
	_nLin:=0
	setregua(len(_vImp))
	for _nVez:=1 to len(_vImp)
		incregua()
		_cTexto:=(_vImp[_nVez])
		_nLinhas:=mlcount(_cTexto,limite)
		for _nVezL:=1 to _nLinhas
			@ _nLin++,0 PSAY memoline(_cTexto,limite,_nVezL)
			//@ _nLin++,0 PSAY left(strzero(_nLin,3)+memoline(_cTexto,limite,_nVezL),limite)
			_cConteudo+=memoline(_cTexto,limite,_nVezL)+chr(13)+chr(10)
		next
	next
	
	// Alimentacao para o corte
	@ _nLin+9,0 psay " "
	
	If aReturn[5] == 1
		Set Printer To
		Commit
		ourspool(wnrel)
	Endif
	
	ms_fLUSH()
	
Return


/*
*------------------------------------------------------------------------------------
User Function LeBjMro()
	* Ricardo Luiz da Rocha 07/07/2010 GNSJC
	*------------------------------------------------------------------------------------
	Local _cDir:="c:\",_cEscopo:="peso.txt",_nPeso:=_nVez:=0
	
	If funname()=='PDFATA11'
		_vDir:=directory(_cDir+_cEscopo)
		// Colhe o nome do arquivo mais recente
		
		asort(_vDir,,,{|_vAux1,_vAux2|dtos(_vAux1[3])+_vAux1[4]>=dtos(_vAux2[3])+_vAux2[4]})
		
		_vPeso:={}
		cursorwait()
		do while len(_vDir)>0.and._nVez<50 // quantidade de leituras a fazer para obter a leitura mais frequente
			_cPeso:=memoread(_cDir+_vDir[1][1])
			_cPeso:=strtran(_cPeso,chr(13),'')
			_cPeso:=strtran(_cPeso,chr(10),'')
			_cPeso:=right(_cPeso,6)
			If len(_vPeso)<2000
				aadd(_vPeso,_cPeso)
			Endif
			_nVez++
		enddo
		_nPeso:=0
		If len(_vPeso)>0
			_vPeso2:={}
			// classIfica por peso lido
			asort(_vPeso)
			_nOcor:=0
			_cPeso:=_vPeso[1]
			for _nVez:=1 to len(_vPeso)
				_nOcor++
				If _vPeso[_nVez]<>_cPeso.or._nVez==len(_vPeso)
					aadd(_vPeso2,strzero(_nOcor,6)+_cPeso)
					_nOcor:=0
				Endif
			next
			asort(_vPeso2)
			_nPeso:=val(substr(_vPeso2[len(_vPeso2)],7))
		Endif
		cursorarrow()
	Else
		setkey(123,{||nil})
	Endif
	
	_nPBruto:=round(_nPeso/1000,2)
	_oPBruto:Refresh()
	U_fVldPBruto()
	// Eliminado, abortando quando o arquivo estava indisponível //ferase("c:\peso.txt")
Return .T.
*/
*-----------------------------------------------------------------------------
Static Function VALIDPERG(_cPergD)
	*-----------------------------------------------------------------------------
	_cPergD    := PADR(_cPergD,len(sx1->x1_grupo))
	aRegs := {}
	*   1    2            3                4     5   6  7 8  9  10   11        12    13 14    15    16 17 18 19 20 21 22 23 24 25  26
	*+---------------------------------------------------------------------------------------------------------------------------------+
	*¦G    ¦ O  ¦ PERGUNT              ¦V       ¦T  ¦T ¦D¦P¦ G ¦V ¦V         ¦ D    ¦C ¦V ¦D       ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦V ¦D ¦C ¦F    ¦
	*¦ R   ¦ R  ¦                      ¦ A      ¦ I ¦A ¦E¦R¦ S ¦A ¦ A        ¦  E   ¦N ¦A ¦ E      ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦A ¦E ¦N ¦3    ¦
	*¦  U  ¦ D  ¦                      ¦  R     ¦  P¦MA¦C¦E¦ C ¦ L¦  R       ¦   F  ¦ T¦ R¦  F     ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦R ¦F ¦ T¦     ¦
	*¦   P ¦ E  ¦                      ¦   I    ¦  O¦NH¦ ¦S¦   ¦ I¦   0      ¦    0 ¦ 0¦ 0¦   0    ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦0 ¦0 ¦ 0¦     ¦
	*¦    O¦ M  ¦                      ¦    AVL ¦   ¦ O¦ ¦E¦   ¦ D¦    1     ¦    1 ¦ 1¦ 2¦    2   ¦ 2¦3 ¦3 ¦ 3¦4 ¦4 ¦ 4¦5 ¦5 ¦ 5¦     ¦
	AADD(aRegs,{_cPergD,"01","Emissao de         :","mv_ch1","D",08,0,0,"G","","mv_par01",""    ,"","",""      ,"","","","","","","","","","",""})
	AADD(aRegs,{_cPergD,"02","Emissao ate        :","mv_ch2","D",08,0,0,"G","","mv_par02",""    ,"","",""      ,"","","","","","","","","","",""})
	AADD(aRegs,{_cPergD,"03","Situacao           :","mv_ch3","N",01,0,0,"C","","mv_par03","Aguard carregamento" ,"","","Aguard faturamento"   ,"","","Faturadas","","","Todas","","","","",""})
	
	U__fAtuSx1(padr(_cPergD,len(sx1->x1_grupo)),aRegs)
	
Return





Static Function VN020Pswd(_cMsg1,_cMsg2,_cMsg3,_cMsg4)
	
	Local _lRet
	Local _oSenhas := Nil
	Default _cMsg1 := _cMsg2 := _cMsg3 := _cMsg4 := ''
	
	Private	_cSenDig   	:= Space(6)
	Private	_cSenPad   	:= GETMV("PXH_SENBLQ")
	
	_nOpca   := 0
	DEFINE MSDIALOG _oSenhas FROM 00, 00 TO 240,380 TITLE "SENHA" OF _oSenhas PIXEL
	
	@ 03,03  TO 110,190 OF _oSenhas PIXEL
	
	@ 10,05  Say _cMsg1 OF _oSenhas PIXEL
	@ 25,05  Say _cMsg2 OF _oSenhas PIXEL
	@ 35,05  Say _cMsg3 OF _oSenhas PIXEL
	@ 45,05  Say _cMsg4 OF _oSenhas PIXEL
	
	@ 60,05  Say "Digite a Senha para liberar o Pedido de Vendas! " OF _oSenhas PIXEL
	
	@ 75,05  Say "Senha: " 								OF _oSenhas PIXEL
	@ 75,30  MsGet _cSenDig   PASSWORD Size 030, 007 	OF _oSenhas PIXEL
	
	@ 90, 05 BUTTON "OK" 			SIZE 036,012 Action  (If(AllTrim(_cSenDig) == Alltrim(_cSenPad),(_lRet := .T.,_oSenhas:END()),MSGSTOP( "Senha Incorreta" ))) OF _oSenhas PIXEL
	//	@ 90, 05 BUTTON "OK" 			SIZE 036,012 Action  (_nOpca:=1,_oSenhas:END()) OF _oSenhas PIXEL
	@ 90, 45 BUTTON "Sair"			SIZE 036,012 Action  (_oSenhas:END()) OF _oSenhas PIXEL
	
	_lOK := U_PXH042("PXH076",6,.F.)
	If _lOK
		@ 90, 85 BUTTON "Alterar Senha"	SIZE 036,012 Action  (Atualiza()) OF _oSenhas PIXEL
		//		@ 90, 85 BUTTON "Alterar Senha"	SIZE 036,012 Action  (_nOpca:=3,_oSenhas:END()) OF _oSenhas PIXEL
	Endif
	
	ACTIVATE DIALOG _oSenhas CENTERED
	
	//	If _nOpca == 1
	//		If AllTrim(_cSenDig) == Alltrim(_cSenPad)
	//			SC5->(RecLock('SC5',.F.))
	//			SC5->C5_BLQ := ''
	//			SC5->(MsUnlock())
	//		Else
	//			MSGSTOP( "Senha Incorreta" )
	//			_lRet :=.F.
	//		Endif
	//	ElseIf _nOpca == 2
	
	If _nOpca == 3
		Atualiza()
	Endif
	
Return(_lRet)



Static Function ATUALIZA()
	
	_cSenDig   := Space(6)
	_cSenPad   := GETMV("PXH_SENBLQ")
	
	_cGet3     := Space(6)
	_cGet4     := Space(6)
	
	_nOpc     := 0
	
	DEFINE MSDIALOG _oSenha FROM 00, 00 TO 11,26 TITLE "ALTERAR SENHA"
	
	@ 01,01  TO 75,100 OF _oSenha PIXEL
	
	@ 03,04 Say "Senha Atual: " OF _oSenha PIXEL
	@ 18,04 Say "Nova Senha  : " OF _oSenha PIXEL
	@ 33,04 Say "Redigita Nova Senha  : " OF _oSenha PIXEL
	
	@ 03,65 MsGet _cSenDig  PASSWORD Valid VerSenha() 	Size 030, 007 OF _oSenha PIXEL
	@ 18,65 MsGet _cGet3    PASSWORD 					Size 030, 007 OF _oSenha PIXEL
	@ 33,65 MsGet _cGet4    PASSWORD Valid VerSenha2() 	Size 030, 007 OF _oSenha PIXEL
	
	DEFINE SBUTTON FROM 055, 005 TYPE 1 Action (_nOpc:=1,_oSenha:END()) ENABLE OF _oSenha
	DEFINE SBUTTON FROM 055, 045 TYPE 2 Action (_nOpc:=2,_oSenha:END()) ENABLE OF _oSenha
	
	ACTIVATE DIALOG _oSenha CENTERED
	
	If _nOpc == 1
		If !Empty(_cGet4)
			SX6->(dbSetOrder(1))
			If SX6->(msSeek(cFilAnt+"PXH_SENBLQ"))
				SX6->(RecLock("SX6",.F.))
				SX6->X6_CONTEUD := Alltrim(_cGet3)
				SX6->(MsUnlock())
				
				MSGINFO("Senha Alterada com sucesso!")
			Endif
		Else
			MSGSTOP("Nova senha incorreta!")
		Endif
	Endif
	
Return()


Static Function VerSenha()
	
	Local _lRet
	
	If AllTrim(_cSenDig) == Alltrim(_cSenPad) //.And. !Empty(_cSenDig)
		_lRet :=.T.
	Else
		MSGSTOP( "Senha incorreta" )
		_lRet :=.F.
	Endif
	
Return(_lRet)


Static Function VerSenha2()
	
	Local _lRet :=.F.
	If (AllTrim(_cGet3) == Alltrim(_cGet4)) .And. !Empty(_cGet3)
		_lRet :=.T.
	Else
		MSGSTOP( "Nova Senha incorreta" )
	Endif
	
Return(_lRet)
