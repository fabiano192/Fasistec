#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

//estrutura de funcoes criada, devido a chamada em submenu - pedido de venda
// p_cOpcao = '2' - inicial  6 - final
// p_cTpOper= 'C' - Carregamento (venda)  'D' - Descarregamento (compras)
//###############################################################################

/*
VN000201-SMPESOINI
VN000202-SMPESAGEM
VN000203-smPesoFin
VN000204-smRelTicket
VN0003 -TICKET
VN0004 -Cupom de Pesagem - Compras

SZ1-SZH

VN000201
Criar os campos SC5 E SC6
*/

//Pesagem Inicial
User Function VN000201(p_cOpcao, p_cTpOper)
	
	Local cOpcao :=  Iif( p_cOpcao  == nil .or. !(p_cOpcao$'2/6') , '2' , p_cOpcao )
	
	If Valtype(p_cTpOper)=='N'
		cTpOper:=  iif(  !(alltrim(str(p_cTpOper))$'C/D'), 'C' , p_cTpOper )
	Elseif Valtype(p_cTpOper)=='C'
		cTpOper:=  iif(  !(p_cTpOper$'C/D'), 'C' , p_cTpOper )
	Else
		cTpOper:= 'C'
	Endif
	
Return( U_VN000202(cOpcao, cTpOper)   )



//Pesagem Final
User Function VN000203(p_cOpcao, p_cTpOper)
	
	Local cOpcao :=  iif( p_cOpcao  == nil .or. !(p_cOpcao$'2/6') , '6' , p_cOpcao )
	
	if valtype(p_cTpOper)=='N'
		cTpOper:=  iif(  !(alltrim(str(p_cTpOper))$'C/D'), 'C' , p_cTpOper )
	elseif valtype(p_cTpOper)=='C'
		cTpOper:=  iif(  !(p_cTpOper$'C/D'), 'C' , p_cTpOper )
	else
		cTpOper:= 'C'
	endif
	
Return( U_VN000202(cOpcao, cTpOper)   )




//Impressão Ticket
User Function VN000204()
	
	Local cnumero:= nil
	cnumero:= iif( alias()=='SZH', SZH->ZH_NUM  , iif( alias()=='SC5' , SC5->C5_NUM , nil ) )  // Alterado o posicionamento do número do ticket de M->ZH_NUM para SZH->ZH_NUM poisionando registro no alias posicionado na SZH
	
Return( U_VN0003(cnumero, alias()) )




//Abre a tela para Realizar a Pesagem
User Function VN000202(p_cOpcao,p_cTpOper)
	
	Local wArea      := getArea()
	Local cOpcao     := p_cOpcao
	Local cTpOper    := p_cTpOper
	
	Private cHora	   := time()
	Private cPlacaCar  := Space(TamSx3("DA3_PLACA")[1])
	Private ccodVeic   := Space(TamSx3("DA3_COD")[1])
	Private cCodMotor  := Space(TamSx3("DA4_COD")[1])
	Private cNomMotor  := Space(TamSx3("DA4_NOME")[1])
	Private cCodTrans  := Space(TamSx3("A4_COD")[1])
	Private cNomTrans  := Space(TamSx3("A4_NOME")[1])
	Private cMenNota   := Space(TamSx3("C5_MENNOTA")[1])
	Private _cItem
	Private _lAut	   := .T.
	
	do case
	case cTpOper == 'C'  // CARREGAMENTO - VENDA
		
		If !Empty(SC5->C5_NOTA)
			Alert('Pedido ja Faturado!')
			RestArea(wArea)
			Return
		Endif
		
		If SC5->C5_BLQ = 'B'
			Alert('Pedido Bloqueado!')
			RestArea(wArea)
			Return
		Endif
		
		//Abre uma tela para escolher o Item do pedido que deseja pesar
		_cItem := U_CheckItC6(cOpcao,cTpOper,'DADOS')
		
		If Empty(_cItem)
			RestArea(wArea)
			Return
		Endif
		
		SC6->(dbsetorder(1))
		SC6->(dbseek( xfilial('SC6')+SC5->C5_NUM + _cItem ))
		
		If cOpcao =='2' .and. SC6->C6_YPESINI > 0
			Alert('Pedido ja possui peso inicial!')
			RestArea(wArea)
			Return
		Endif
		
		If cOpcao =='6' .and. SC6->C6_YPESINI == 0
			Alert('Pedido nao possui peso inicial!')
			RestArea(wArea)
			Return
		Endif
		
		If cOpcao =='6' .and. SC6->C6_YPESLIQ > 0
			Alert('Pedido com pesagem finalizada!')
			RestArea(wArea)
			Return
		Endif
		
		If cOpcao =='6'
			dbSelectArea("SZK")
			SZK->(dbSetOrder(2))
			If !SZK->(msSeek(xFilial("SZK")+SC5->C5_NUM+_cItem))
				Alert('Item do Pedido não tem Ordem de Carregamento gerada!')
				RestArea(wArea)
				Return
			Endif
		Endif
		
		If !Empty(SC5->C5_YPLACA)
			cPlacaCar:= SC5->C5_YPLACA
		Endif
		If !Empty(SC5->C5_YCODMOT)
			ccodMotor:=	SC5->C5_YCODMOT
			cnomMotor:=	SC5->C5_YNOMMOT
		Endif
		If !Empty(SC5->C5_YHORSAI)
			cHora		:= SC5->C5_YHORSAI
		Endif
		If !Empty(SC5->C5_TRANSP)
			ccodTrans		:= SC5->C5_TRANSP
			cnomTrans := posicione('SA4',1,xfilial('SA4')+ccodTrans,"A4_NOME" )
		Endif
		If !Empty(SC5->C5_MENNOTA)
			cMenNota		:= SC5->C5_MENNOTA
		Endif
		
	Case cTpOper == 'D' // DESCARREGAMENTO - COMPRAS
		
		If !Empty(M->ZH_PLACA)
			cPlacaCar:= M->ZH_PLACA
		Endif
		If !Empty(M->ZH_CODMOT)
			ccodMotor:=	M->ZH_CODMOT
			cnomMotor:=	posicione('DA4',1,xfilial('DA4')+ccodMotor,"DA4_NOME" )
		Endif
		If !Empty(M->ZH_HORINI)
			cHora		:= M->ZH_HORINI
		Endif
		If !Empty(M->ZH_CODTRAN)
			ccodTrans		:= M->ZH_CODTRAN
			cnomTrans := posicione('SA4',1,xfilial('SA4')+ccodTrans,"A4_NOME" )
		Endif
	Endcase
	
	
	//Declaração de Variaveis Private dos Objetos                             ±±
	SetPrvt("oDlg2","oSay1","oSay2","oSay3","oSay4","oBtGranel","oBtn2","oBtn3","oGet1","oGet2","oGet3","oGet4")
	
	//Definicao do Dialog e todos os seus componentes.                        ±±
	oDlg2      := MSDialog():New( 241,349,440,780,"Operações",,,.F.,,,,,,.T.,,,.T. )
	
	nspSay:=13
	nlnSay:=005
	oSay3      := TSay():New( nlnSay += nspSay ,012,{||"Hora"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
	oSay1      := TSay():New( nlnSay += nspSay ,012,{||"Placa"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
	oSay2      := TSay():New( nlnSay += nspSay ,012,{||"Motorista"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
	oSay4      := TSay():New( nlnSay += nspSay ,012,{||"Transp."},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
	oSay5      := TSay():New( nlnSay += nspSay ,012,{||"Mens.NF."},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
	
	nlinbtn:= 83 //LINHA DOS BOTOES
	
	If cOpcao == "1"
		
	ElseIf cOpcao == "2"
		
		oBtn2  := TButton():New( nlinbtn,055,"Pesar Entrada",oDlg2,{|| MsAguarde( {|| fPesarEnt(cOpcao,cTpOper,,_cItem,"I") },"Atualizando...") },042,015,,,,.T.,,"",,,,.F. )
		
	ElseIf cOpcao == "6"
		
		oBtn1  := TButton():New( nlinbtn,010,"Pesar Saída",oDlg2,{|| MsAguarde( {|| fPesarSai(cOpcao, cTpOper,_cItem,"F") },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
		//		oBtn4  := TButton():New( nlinbtn,080,"Peso Manual",oDlg2,{|| MsAguarde( {|| Senha(p_cOpcao,"F") },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
		
	ElseIf cOpcao == "3"
		
	Endif
	
	oBtn3      := TButton():New( nlinbtn ,150,"Fechar",oDlg2,{|| oDlg2:End()},042,015,,,,.T.,,"",,,,.F. )
	
	nspGet := 12
	nlnGet := 004
	
	oGet3  := TGet():New( nlnGet += nspGet ,043,{|u| If(PCount()>0,cHora:=u,cHora)}	,oDlg2,021,008,'',								 ,CLR_BLACK	,CLR_WHITE	,,,,.T.,"",,,.F.   ,.F.,,.T.,.F.,"","cHora",,)
	oGet1  := TGet():New( nlnGet += nspGet ,043, bSETGET(cPlacaCar)					,oDlg2,033,008,  ,{||ExistCpo("DA3",cPlacaCar,3)},			,			,,,,.T.,  ,,,,,,,,,)
	
	oGet1:CF3        := "DA302"
	oGet1:BLostFocus := { || ccodVeic:= da3->da3_cod  }
	
	oGet2	  :=	TGet():New(  nlnGet += nspGet  , 043   , bSETGET(cCodMotor)		, oDlg2 ,033,008,,{||ExistCpo("DA4",cCodMotor,1)},,,,,,.T.,,,,,,,,,,)
	oGet2:CF3 := "DA4"
	oGet2:BLostFocus := { || cnomMotor:= da4->da4_nome, oDlg2:Refresh() }
	
	oGet5     := TGet():New( nlnGet  ,083,{|u| If(PCount()>0,cnomMotor:=u,cnomMotor)},oDlg2,116,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cnomMotor",,)
	
	oGet4	  := TGet():New(  nlnGet += nspGet , 043   , bSETGET(cCodTrans)		, oDlg2 ,033,008,,{||ExistCpo("SA4",cCodTrans,1)},,,,,,.T.,,,,,,,,,,)
	oGet4:CF3 := "SA4"
	oGet4:BLostFocus := { || cnomTrans:= sa4->a4_nome, oDlg2:Refresh() }
	
	oGet6  := TGet():New( nlnGet  ,083,{|u| If(PCount()>0,cnomTrans:=u,cnomTrans)},oDlg2,116,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cnomTrans",,)
	
	oGet7	 :=	TGet():New(  nlnGet += nspGet+2    , 043   , bSETGET(cMenNota)		, oDlg2 ,150,008,,{||.t.},,,,,,.T.,,,,,,,,,,)
	
	oDlg2:Activate(,,,.T.)
	
Return





//Função que abre a tela para chamar a captura do peso e gravação dos campos
Static Function fPesarEnt(p_cOpcao,p_cTpOper, p_lSemPeso,p_cItem,_cTp)
	
	Local aAreaAtu  := GetArea()
	Local cStatus   := p_cOpcao
	Local cTpOper   := p_cTpOper
	Local cItem     := p_cItem
	Local cNumero   := iif(cTpOper=='C' , sc5->c5_num , M->ZH_NUM )
	Local wAlCab    := iif(cTpOper=='C' , 'SC5' , 'SZH' )
	Local wAlDet    := iif(cTpOper=='C' , 'SC6' , 'SZH' )
	
	Private nPesoAux:= 0
	
	// so aceita passar sem peso, quando for granel e o status for "2-aguardando pesagem"
	lSemPeso:= iif( p_lSemPeso==nil, .f., p_lSemPeso)
	
	//Faz a Captura do peso
	u_PesoBal(@nPesoAux,"ENTRADA",_cTp,)
	
	If wAlDet = 'SC6'
		_cSeek := cnumero+cItem
	Else
		_cSeek := cnumero
	Endif
	
	(wAlDet)->(dbsetorder(1))
	(wAlDet)->(dbseek( xfilial(wAlDet)+_cSeek  ))
	
	if (nPesoAux==0) .and. !lSemPeso  //saco
		Alert('Nao e permitido prosseguir sem peso!')
	else
		
		nPEntAnt:= 0
		Begin Transaction
			
			do case
			case cTpOper =='C'
				
				If SC6->C6_NUM == cnumero
					
					SC6->( RecLock("SC6",.F.) )
					SC6->C6_YPESINI := nPesoAux
					SC6->C6_YHORINI := time()
					SC6->C6_YSTATUS := cstatus
					If Empty(SC6->C6_YTPPSIN)
						SC6->C6_YTPPSIN := "A"
					Endif
					SC6->(MsUnLock())
					
					SC5->( RecLock("SC5",.F.) )
					SC5->C5_YPLACA  := cPlacaCar
					SC5->C5_VEICULO := ccodVeic
					SC5->C5_YCODMOT := ccodMotor
					SC5->C5_YNOMMOT := cnomMotor
					SC5->C5_TRANSP  := ccodTrans
					SC5->C5_MENNOTA := cmennota
					SC5->C5_YHORSAI := cHora
					SC5->(MsUnLock())
					
					/*
					dbSelectArea("SZK")
					
					SZK->(RecLock("SZK",.F.))
					SZK->ZK_PESOVEI := nPesoAux
					SZK->(MsUnLock())
					*/
					
					dbSelectArea("SZK")
					SZK->(dbSetOrder(2))
					If SZK->(msSeek(xFilial("SZK")+SC5->C5_NUM+SC6->C6_ITEM))
						SZK->(RecLock("SZK",.F.))
						SZK->(dbDelete())
						SZK->(msUnlock())
					Endif
					
					SZK->(RecLock("SZK",.T.))
					SZK->ZK_FILIAL	:= xFilial("SZK")
					SZK->ZK_NUM		:= GetSxeNum("SZK","ZK_NUM")
					SZK->ZK_NUMPV	:= SC5->C5_NUM
					SZK->ZK_ITEMPV	:= SC6->C6_ITEM
					SZK->ZK_EMISSAO	:= ddatabase
					SZK->ZK_CLIENTE	:= SC5->C5_CLIENTE
					SZK->ZK_LOJACLI	:= SC5->C5_LOJACLI
					SZK->ZK_LOJAENT	:= SC5->C5_LOJAENT
					SZK->ZK_NOMCLI	:= Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
					SZK->ZK_PLACA	:= SC5->C5_YPLACA
					SZK->ZK_TPFRETE	:= SC5->C5_TPFRETE
					SZK->ZK_PRODUTO	:= SC6->C6_PRODUTO
					SZK->ZK_PESOVEI	:= nPesoAux
					SZK->ZK_UM		:= SC6->C6_UM
					SZK->ZK_VLRFRET	:= SC5->C5_FRETE
					SZK->ZK_TRANSP	:= SC5->C5_TRANSP
					SZK->ZK_VEND1	:= SC5->C5_VEND1
					SZK->(msUnlock())
					
					SZK->(ConfirmSx8())
					
					U_VN0019(SZK->ZK_NUM) //Imprime Ordem de Carregamento
					
				EndIf
				
			case cTpOper =='D'
				
				If M->ZH_NUM == cnumero
					
					M->ZH_PESINI := nPesoAux
					M->ZH_HORINI := time()
					M->ZH_PLACA  := cPlacaCar
					M->ZH_CODMOT := ccodMotor
					M->ZH_CODTRAN:= ccodTrans
					M->ZH_USUARIO:= alltrim(substr(cusuario,7,15))
					M->ZH_TPPSINI:= If(_lAut,"A","M")
					/*
					SZH->( RecLock("SZH",.F.) )
					SZH->ZH_PESINI := nPesoAux
					SZH->ZH_HORINI := time()
					SZH->ZH_PLACA  := cPlacaCar
					SZH->ZH_CODMOT := ccodMotor
					SZH->ZH_CODTRAN:= ccodTrans
					SZH->ZH_USUARIO:= alltrim(substr(cusuario,7,15))
					If Empty(SZH->ZH_TPPSINI)
						SZH->ZH_TPPSINI:= "A"
					Endif
					*/
				EndIf
			endcase
			
		End Transaction
	endif
	
	RestArea(aAreaAtu)
	
	oDlg2:End()
	
Return



//Faz a Captura do Peso
User Function PesoBal(p_nPesoRet,p_cOrigem,_cTp)
	
	Private cBal1      := Space(1)
	Private cBal1      := Space(1)
	Private cBal1      := Space(1)
	Private cBal1      := Space(1)
	Private cGet_bal1  := Space(1)
	Private cGet_bal2  := Space(1)
	Private cGet_Bal3  := Space(1)
	Private cGet_Bal4  := Space(1)
	Private cBarraStatus  := Space(1)
	
	Private oFont1 := TFont():New("Arial",,018,,.T.,,,,,.F.,.F.)
	Private oFont2 := TFont():New("Courier New",,028,,.T.,,,,,.F.,.F.)
	Private oFont3 := TFont():New("Arial",,024,,.T.,,,,,.F.,.F.)
	
	//Declaração de Variaveis Private dos Objetos                             ±±
	SetPrvt("oDlgPeso","oBal1","oSay2","oSay3","oSay4","oGet_bal1","oBtn_capBal1","oBtn_grvBal1","oBtn_grvBal2")
	SetPrvt("oGet_bal2","oGet_Bal4","oBtn_capBal4","oBtn_grvBal4","oBtn_grvBal3","oBtn_capBal3","oGet_Bal3","oBarraStatus")
	
	_aEndIP := StrToKArr(GETMV("PXH_IPBAL"),";")
	
	aIP   := {}
	aPort := {}
	
	aChave:= {"01"}
	aDesc := {"PESO:"}
	
	AADD(aIP  ,_aEndIP[1])
	AADD(aPort,_aEndIP[2])
	
	ctitulo:= ""
	ctitulo:= iif( p_cOrigem == "SAIDA", "Pesagem  -  S A I D A", "Pesagem - E N T R A D A" )
	_cTipo := iif( p_cOrigem == "SAIDA", "S", "E" )
	
	//Definicao do Dialog e todos os seus componentes.                        ±±
	oDlgPeso      := MSDialog():New( 112,286,484,981,"Monitor de BALANÇAS",,,.F.,,,,,,.T.,,,.T. )
	
	oTitulo       := TSay():New( 010,085,{|| cTitulo },oDlgPeso,,oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,150,015)
	oBarraStatus  := TGet():New( 170,200,{|u| If(PCount()>0,oBarraStatus:=u,cBarraStatus)},oDlgPeso,150,010,'',,CLR_HBLUE,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cBarraStatus",,)
	oBarraStatus:disable()
	
	opesoManual   := TButton():New( 170,036,"Peso Manual",oDlgPeso,{|| Senha(p_cOrigem,_cTp) , oDlgPeso:end()  },050,012,,,,.T.,,"",,,,.F. )
	
	nposBal1:= aScan( aChave, '01' )
	
	If nposBal1 >0 //"Balanca1"
		oBal1      	:= TSay():New( 041,036,{|| aDesc[nposbal1] },oDlgPeso,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
		oGet_bal1  	:= TGet():New( 038,116,{|u| If(PCount()>0,cGet_bal1:=u,cGet_bal1)}  ,oDlgPeso,075,015,'',,CLR_HBLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_bal1",,)
		oGet_bal1:disable()
		bCaptura	:= {|| cBarraStatus:= "Iniciando Conexão IP:  "+aIP[nposBal1]+"  Porta: "+aPort[nposBal1] , oBarraStatus:refresh(), cGet_bal1:=U_CheckPeso(aIP[nposBal1], aPort[nposBal1] , oBt_capBa1 , _cTipo)  }
		oBt_capBa1 	:= TButton():New( 041,229,"Capturar",oDlgPeso, bCaptura ,037,012,,,,.T.,,"",,,,.F. )
		//		oBt_grvBa1 	:= TButton():New( 041,276,"Gravar",oDlgPeso,{|| p_nPesoRet:= val(cGet_Bal1), oDlgPeso:end()  },037,012,,,,.T.,,"",,,,.F. )
		oBt_grvBa1 	:= TButton():New( 041,276,"Gravar",oDlgPeso,{|| p_nPesoRet:= cGet_Bal1, _cTpPes  := "Automatico",oDlgPeso:end()  },037,012,,,,.T.,,"",,,,.F. )
		
	Endif
	
	oDlgPeso:Activate(,,,.T.)
	
Return


//Faz a pesagem na saída do Caminhão
Static Function fPesarSai(p_cOpcao, p_cTpOper,_cItem,_cTp)
	
	Local aAreaAtu  := GetArea()
	Local cStatus   := p_cOpcao
	Local cTpOper   := p_cTpOper
	Local cNumero   := iif(cTpOper=='C' , sc5->c5_num , M->ZH_NUM )
	Local wAlCab    := iif(cTpOper=='C' , 'SC5' , 'SZH' )
	Local wAlDet    := iif(cTpOper=='C' , 'SC6' , 'SZH' )
	
	nPesoAux :=0
	U_PesoBal(@nPesoAux,"SAIDA",_cTp,)
	
	lpesoOK := .T.
	
	(wAlDet)->(dbsetorder(1))
	(wAlDet)->(dbseek( xfilial(wAlDet)+cnumero  ))
	
	if empty(nPesoAux)
		Alert('Nao e permitido prosseguir sem peso!')
	elseif lpesoOK
		
		Begin Transaction
			
			do case
			case cTpOper == 'C'
				
				If SC6->c6_num == cnumero
					
					SC6->( RecLock("SC6",.F.) )
					
					_nPesliq:=0
					_nPesliq:= nPesoAux - SC6->c6_ypesini
					
					SC6->C6_YPESFIN := nPesoAux
					SC6->C6_YPESLIQ := _nPesliq
					SC6->C6_YHORFIN := time()
					SC6->C6_YSTATUS := cstatus
					
					SC6->C6_YQTORIG := SC6->C6_QTDVEN
					SC6->C6_QTDVEN  := SC6->C6_YPESLIQ
					SC6->C6_QTDLIB  := SC6->C6_YPESLIQ
					SC6->C6_VALOR   := SC6->C6_PRCVEN * SC6->C6_QTDVEN
					
//					If SC6->C6_UM = 'KG'
						SC6->C6_YQTORIG := SC6->C6_QTDVEN
						SC6->C6_QTDVEN  := SC6->C6_YPESLIQ
						SC6->C6_QTDLIB  := SC6->C6_YPESLIQ
						SC6->C6_VALOR   := SC6->C6_PRCVEN * SC6->C6_QTDVEN
//					Else
						
						//						If SC6->C6_SEGUM = 'KG'
						//							SC6->C6_YQTORIG := SC6->C6_UNSVEN
						//							SC6->C6_UNSVEN  := SC6->C6_YPESLIQ
						//							SC6->C6_QTDLIB  := SC6->C6_QTDVEN
						//							SC6->C6_QTDLIB2 := SC6->C6_YPESLIQ
						//						Else
						
//						MsgAlert('Produto não contém a UM "KG".')
//						DisarmTransaction()
//						Return()
//						
//					Endif
					
					
					SC6->C6_OP      := '06'
					If Empty(SC6->C6_YTPPSFI)
						SC6->C6_YTPPSFI := "A"
					Endif
					a410Refr("C6_QTDLIB")
					
					SC6->(MsUnLock())
					
					SC5->( RecLock("SC5",.F.) )
					SC5->C5_PESOL   := _nPesliq
					SC5->C5_PBRUTO  := _nPesliq
					SC5->(MsUnLock())
				EndIf
				
			case cTpOper == 'D'
				
				If M->ZH_NUM == cnumero
					
					M->ZH_PESFIN  := nPesoAux
					M->ZH_PESLIQ  := SZH->ZH_PESINI - nPesoAux
					M->ZH_HORFIN  := time()
					M->ZH_TPPSFIM := If(_lAut,"A","M")
					
				EndIf
			Endcase
		End Transaction
		
	Endif
	
	RestArea(aAreaAtu)
	
	oDlg2:End()
	
	If _cTp == 'F' .And. cTpOper == 'C'
		U_VN0003(cnumero,wAlCab,_cItem)
	Endif
	
Return


Static Function Senha(cOpcao,_cTp)
	
	Local cNumero   := Iif(cTpOper=='C' , SC5->C5_NUM , M->ZH_NUM )
	
	Private _lRet 		:= .T.
	Private	_cSenDig   	:= Space(6)
	Private	_cSenPad   	:= GETMV("PXH_SENPES")
	
	_nOpca   := 0
	DEFINE MSDIALOG _oSenhas FROM 00, 00 TO 10,38 TITLE "SENHA"
	
	@ 01,01  TO 60,130 OF _oSenhas PIXEL
	
	@ 10,05  Say "Digite a Senha para incluir o Peso Manualmente! " OF _oSenhas PIXEL
	
	@ 25,05  Say "Senha: " 								OF _oSenhas PIXEL
	@ 25,30  MsGet _cSenDig   PASSWORD Size 030, 007 	OF _oSenhas PIXEL
	
	@ 40, 05 BUTTON "OK" 			SIZE 036,012 ACTION  (_nOpca:=1,_oSenhas:END()) OF _oSenhas PIXEL
	@ 40, 45 BUTTON "Sair"       	SIZE 036,012 ACTION  (_nOpca:=2,_oSenhas:END()) OF _oSenhas PIXEL
	
	_lOK := U_PXH042("VN0002",6,.F.)
	If _lOK
		@ 40, 85 BUTTON "Alterar Senha"	SIZE 036,012 ACTION  (_nOpca:=3,_oSenhas:END()) OF _oSenhas PIXEL
	Endif
	
	ACTIVATE DIALOG _oSenhas CENTERED
	
	If _nOpca == 1
		If AllTrim(_cSenDig) == Alltrim(_cSenPad)
			Peso_M(cnumero,cOpcao,_cTp)
		Else
			MSGSTOP( "Senha Incorreta" )
			_lRet :=.F.
		Endif
	ElseIf _nOpca == 2
		
	ElseIf _nOpca == 3
		Atualiza()
	Endif
	
Return



Static Function ATUALIZA()
	
	_cSenDig   := Space(6)
	_cSenPad   := GETMV("PXH_SENPES")
	
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
	
	@ 55,05  BmpButton Type 1 Action (_nOpc:=1,_oSenha:END())
	@ 55,45  BmpButton Type 2 Action (_nOpc:=2,_oSenha:END())
	
	ACTIVATE DIALOG _oSenha CENTERED
	
	If _nOpc == 1
		If !Empty(_cGet4)
			SX6->(dbSetOrder(1))
			If SX6->(msSeek(xFilial('SX6')+"PXH_SENPES"))
				SX6->(RecLock("SX6",.F.))
				SX6->X6_CONTEUD := Alltrim(_cGet3)
				SX6->(MsUnlock())
			Endif
		Else
			MSGSTOP("Nova senha incorreta!")
		Endif
	Endif
	
Return(_lRet)



Static Function VerSenha()
	
	If AllTrim(_cSenDig) == Alltrim(_cSenPad) //.And. !Empty(_cSenDig)
		_lRet :=.T.
	Else
		MSGSTOP( "Senha incorreta" )
		_lRet :=.F.
	Endif
	
Return(_lRet)



Static Function VerSenha2()
	
	_lRet :=.F.
	If (AllTrim(_cGet3) == Alltrim(_cGet4)) .And. !Empty(_cGet3)
		_lRet :=.T.
	Else
		MSGSTOP( "Nova Senha incorreta" )
	Endif
	
Return(_lRet)



//Inclusão do Peso manualmente
Static Function Peso_M(cnumero,CSTATUS,_cTp)
	
	Local wAlCab    := iif(cTpOper=='C' , 'SC5' , 'SZH' )
	
	_nOpt   := _nPesoM := 0
	DEFINE MSDIALOG _oPeso_M FROM 00, 00 TO 10,38 TITLE "Peso Manual"
	
	@ 01,01  TO 60,130 OF _oPeso_M PIXEL
	
	@ 10,05  Say "Digite o Peso abaixo: " OF _oPeso_M PIXEL
	
	@ 25, 05 Say "Peso: " 								Size 030, 007 OF _oPeso_M PIXEL
	@ 25, 30 MsGet _nPesoM PICTURE "@E 999,999.99" 		Size 050, 007 OF _oPeso_M PIXEL
	
	@ 40, 05 BUTTON "Gravar"		SIZE 036,012 ACTION  (_nOpt:=1,_oPeso_M:END()) OF _oPeso_M PIXEL
	@ 40, 45 BUTTON "Sair"       	SIZE 036,012 ACTION  (_oPeso_M:END()) OF _oPeso_M PIXEL
	
	ACTIVATE DIALOG _oPeso_M CENTERED
	
	If _nOpt = 1
		
		nPesoAux := _nPesoM
		If _nPesoM > 0
			_lAut := .F.
		Endif
		
		If Alltrim(Upper(FunName())) == 'VN020C'
			_cTpPes  := "Manual"
			_nPBruto := Round(_nPesoM,0)
			U_fVldPBruto()
		Else
			
			Begin Transaction
				
				do case
				case cTpOper =='C'
					
					If SC6->C6_NUM == cnumero
						
						If _cTp == 'I'
							SC6->( RecLock("SC6",.F.) )
							SC6->C6_YPESINI := Round(_nPesoM,0)
							SC6->C6_YHORINI := TIME()
							SC6->C6_YSTATUS := CSTATUS
							SC6->C6_YTPPSIN := "M"
							SC6->(MsUnlock())
							
							SC5->( Reclock("SC5",.F.) )
							SC5->C5_YPLACA  := CPLACACAR
							SC5->C5_VEICULO := CCODVEIC
							SC5->C5_YCODMOT := CCODMOTOR
							SC5->C5_YNOMMOT := CNOMMOTOR
							SC5->C5_TRANSP  := CCODTRANS
							SC5->C5_MENNOTA := CMENNOTA
							SC5->C5_YHORSAI := CHORA
							SC5->(MsUnlock())
							
							/*
							dbSelectArea("SZK")
							SZK->(dbSetOrder(2))
							If SZK->(msSeek(xFilial("SZK")+SC5->C5_NUM+SC6->C6_ITEM))
								SZK->(RecLock("SZK",.F.))
								SZK->(dbDelete())
								SZK->(msUnlock())
							Endif
							
							SZK->(RecLock("SZK",.T.))
							SZK->ZK_FILIAL	:= xFilial("SZK")
							SZK->ZK_NUM		:= GetSxeNum("SZK","ZK_NUM")
							SZK->ZK_NUMPV	:= SC5->C5_NUM
							SZK->ZK_ITEMPV	:= SC6->C6_ITEM
							SZK->ZK_EMISSAO	:= ddatabase
							SZK->ZK_CLIENTE	:= SC5->C5_CLIENTE
							SZK->ZK_LOJACLI	:= SC5->C5_LOJACLI
							SZK->ZK_LOJAENT	:= SC5->C5_LOJAENT
							SZK->ZK_NOMCLI	:= Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
							SZK->ZK_PLACA	:= SC5->C5_YPLACA
							SZK->ZK_TPFRETE	:= SC5->C5_TPFRETE
							SZK->ZK_PRODUTO	:= SC6->C6_PRODUTO
							SZK->ZK_PESOVEI	:= Round(_nPesoM,0)
							SZK->ZK_UM		:= SC6->C6_UM
							SZK->ZK_VLRFRET	:= SC5->C5_FRETE
							SZK->ZK_TRANSP	:= SC5->C5_TRANSP
							SZK->ZK_VEND1	:= SC5->C5_VEND1
							SZK->(msUnlock())
							
							SZK->(ConfirmSx8())
							
							U_VN0019(SZK->ZK_NUM) //Imprime Ordem de Carregamento
							*/
						ElseIf _cTp == 'F'
							_nPsEmba := 0
							_nPesliq := Round(_nPesoM,0) - SC6->C6_YPESINI
//							If SC6->C6_UM = 'KG'
								_nC6QTDV := SC6->C6_QTDVEN
								//						ElseIf SC6->C6_SEGUM = 'KG'
								//						_nC6QTDV := SC6->C6_UNSVEN
//							Endif
							
							SC6->( RecLock("SC6",.F.) )
							SC6->C6_YPESFIN := Round(_nPesoM,0)
							SC6->C6_YPESLIQ := Round(_nPesliq,0)
							SC6->C6_YHORFIN := time()
							SC6->C6_YPSEMBA := _nPsEmba
							
//							If SC6->C6_UM = 'KG'
								If SC6->C6_YQTORIG = 0
									SC6->C6_YQTORIG := SC6->C6_QTDVEN
								Endif
								SC6->C6_QTDVEN  := SC6->C6_YPESLIQ
								SC6->C6_QTDLIB  := SC6->C6_YPESLIQ
								SC6->C6_VALOR   := SC6->C6_PRCVEN * SC6->C6_QTDVEN
//							Else
								
								//							If SC6->C6_SEGUM = 'KG'
								//								SC6->C6_YQTORIG := SC6->C6_UNSVEN
								//								SC6->C6_UNSVEN  := SC6->C6_YPESLIQ
								//								SC6->C6_QTDLIB  := SC6->C6_QTDVEN
								//								SC6->C6_QTDLIB2 := SC6->C6_YPESLIQ
								//							Else
								
//								MsgAlert('Produto não contém a UM "KG".')
//								DisarmTransaction()
//								Return()
//
//							Endif
							
							SC6->C6_OP      := '06'
							SC6->C6_YSTATUS := CSTATUS
							SC6->C6_YTPPSFI := "M"
							
							a410Refr("C6_QTDLIB")
							
							SC6->(MsUnlock())
							
							SC5->( Reclock("SC5",.F.) )
							SC5->C5_PESOL   := _nPesliq
							SC5->C5_PBRUTO  := _nPesliq
							SC5->(MsUnlock())
							
							_nDif    := 0
							If _nC6QTDV <> Round(_nPesliq,0)
								
								_nDif 		:= _nPesliq - _nC6QTDV
								_nDif		:= If(_nDif < 0,_nDif *-1,_nDif)
								_nLimite	:= GETMV("PXH_LIMPES")
								_nLimPeso 	:= _nC6QTDV * (_nLimite/100)
								
								If _nDif > _nLimPeso
									SC5->(RecLock('SC5',.F.))
									SC5->C5_BLQ := 'B'
									SC5->(MsUnlock())
									_cMsg := 'Quantidade carregada diferente da programação e superior ao limite de '+cValtoChar(_nLimite)+'%, '+CRLF+;
										'portanto o Pedido ficará bloqueado!'
								Else
									_cMsg := 'Quantidade carregada diferente da programação e inferior ao limite de '+cValtoChar(_nLimite)+'%, '+CRLF+;
										'portanto o Pedido está liberado para ser Faturado!'
								Endif
								
								MsgAlert(_cMsg+CRLF+;
									'Quantidade Programação: '+Alltrim(Transform(_nC6QTDV,"@E9,999,99.99"))+CRLF+;
									'Quantidade Atual:       '+Alltrim(Transform(_nPesliq,"@E9,999,99.99"))	+CRLF+;
									'Diferença:              '+Alltrim(Transform( _nDif,"@E9,999,99.99")))
							Endif
							
							/*
							If _nDif <> 0
								
								_cItPr := SC6->C6_ITEM
								_cProd := SC6->C6_PRODUTO
								
								_aAliSC6 := SC6->(GetArea())
								
								SC6->(dbSetOrder(2))
								SC6->(msSeek(xFilial('SC6')+_cProd+cnumero))
								
								_lEnt := .F.
								
								While !SC6->(EOF()) .And. SC5->C5_FILIAL+_cProd+cnumero = SC6->C6_FILIAL+SC6->C6_PRODUTO+SC6->C6_NUM
									
									If SC6->C6_ITEM = _cItPr
										SC6->(dbskip())
										Loop
									Endif
									
									If SC6->C6_QTDVEN = SC6->C6_QTDENT
										SC6->(dbskip())
										Loop
									Endif
									
									If !Empty(SC6->C6_BLQ)
										SC6->(dbskip())
										Loop
									Endif
									
									If SC6->C6_YPESLIQ > 0
										SC6->(dbskip())
										Loop
									Endif
									
									SC6->(RECLOCK('SC6',.F.))
									SC6->C6_QTDVEN -= _nDif
									SC6->C6_VALOR  := SC6->C6_QTDVEN * SC6->C6_PRCVEN
									SC6->(MSUNLOCK())
									
									_lEnt := .T.
									
									Exit
									
									SC6->(dbskip())
								EndDo
								
								_dEntrega := SC6->C6_ENTREG
								
								RestArea(_aAliSC6)
								
								If _lEnt
									MsgAlert('Atualizado a diferença apontada na próxima programação do dia: '+DTOC(_dEntrega))
								ELSE
									
									_nLimPeso := _nC6QTDV * (GETMV("PXH_LIMPES")/100)
									
									If _nDif > _nLimPeso
										Alert('Este item do Pedido ficará bloqueado para Faturamento devido à diferença apontada!')
										
										SC5->(RecLock('SC5',.F.))
										SC5->C5_BLQ := 'B'
										SC5->(MsUnlock())
									Endif
								Endif
								
							Endif
							*/
						Endif
						
					EndIf
					
				case cTpOper =='D'
					
					If M->ZH_NUM == cnumero
						
						If _cTp == 'I'
							M->ZH_PESINI := _nPesoM
							M->ZH_HORINI := TIME()
							M->ZH_PLACA  := CPLACACAR
							M->ZH_CODMOT := CCODMOTOR
							M->ZH_CODTRAN:= CCODTRANS
							M->ZH_TPPSINI:= If(_lAut,"A","M")
						ElseIf _cTp == 'F'
							M->ZH_PESFIN := nPesoAux
							M->ZH_PESLIQ := SZH->zH_pesini - nPesoAux
							M->ZH_HORFIN := time()
							M->ZH_TPPSFIM:= If(_lAut,"A","M")
							M->ZH_USUARIO:= alltrim(substr(cusuario,7,15))
						Endif
					EndIf
				Endcase
				
			End Transaction
			
			oDlg2:End()
			
			If _cTp == 'F' .And. cTpOper == 'C'
				U_VN0003(cnumero,wAlCab,_cItem)
			Endif
		Endif
		
	Endif
	
Return()




User Function CheckPESO(p_cIP,p_cPort, p_oBtn, p_cTipo)
	
	Private cRet:="0"
	
	//cret:=	u_GetIP(p_cIP,p_cPort, p_oBtn, p_cTipo)
	_lEnd   := .f.
	
	//		LjMsgRun(OemToAnsi("Aguarde, capturando o peso da balança..."),("Peso"),{| _lEnd | u_GetIP(p_cIP,p_cPort, p_oBtn, p_cTipo) } )			// Desabilitado por Marcus Vinicius - 15/06/2016
	LjMsgRun(OemToAnsi("Aguarde, capturando o peso da balança..."),("Peso"),{| _lEnd | cRet := u_VnGetIP(p_cIP,p_cPort, p_oBtn, p_cTipo) } )// Marcus Vinicius - 15/06/2016 - Desenvolvido nova função para coletar peso VnGetIP
	cRet := Val(cRet)
		
Return cRet


/*User Function GetIP(p_cIP,p_cPort, p_oBtn, p_cTipo,p_lAutom)

Local oObj      := tSocketClient():New()
Local cRec      := ""
Local cIP       := iif( p_cIP   ==nil, "10.50.1.60" ,cValtoChar(ALLTRIM(p_cIP)) )
Local nPort     := iif( p_cPort ==nil, 4001 , VAL(p_cPort) )
Local cTipo     := iif( p_cTipo ==nil, "E" , ALLTRIM(p_cTipo))
Local lAutom    := iif( p_lAutom==nil, .f. , p_lAutom )
Local oBtn      := iif( p_oBtn  ==nil, nil , p_oBtn )
Local ntimeout  := 2
Local nVezes    := 3
Local nTry      := 1
Local nRespse

For F:= 1 To 5 //Captura 2 vezes o peso
	
	_lSair  := .F.
	nCont   := 0
	cRet 	:= "0"
	
	oObj 	:= tSocketClient():New()
	Sleep(1000)
	
	_ip      := alltrim(p_cIP)
	_port    := val(p_cPort)
	_timeout := 02
	
	//		p_oBtn:Disable()
	cBarraStatus:= 'Iniciando ... '
	
	nResp := oObj:Connect( _port, _ip, _timeout )
	
	If(nResp == 0 )
		
		cBarraStatus:= "Conexão OK!  IP:  "+_ip+"  Porta: "+str(_port,5)
		Conout( cBarraStatus )
		
		While ncont < 3 .And. !_lSair
			
			cBuffer := ""
			//			cBuffer := space(100)
			
			Sleep(1000)
			
			nQtd    := oObj:Receive( @cBuffer, 10000 )
			
			If nQtd > 0
				
				_cPeso := ""
				
				For Ax:= Len(cbuffer) To 1 Step -1
					
					If Substr(cbuffer,AX,1) == Space(1) .And. Substr(cbuffer,AX+1,1)  <> Space(1)
						_cPeso += Substr(cbuffer,AX+1,7)
					Endif
					
					If Val(_cPeso) > 1000
						AX:= 1
					Else
						_cPeso := ""
					Endif
					
				Next AX
				
				ncont++
				
				cRet:=  Alltrim(str(Val(_cPeso)))
				
				conout(  _cPeso )
			Else
				cRet:='0'
			Endif
			
			If( oObj:IsConnected() )
				cBarraStatus:="OK! Conectado ... " + time()
			else
				cBarraStatus := "Ops! Nao Conectado ...  " + time()
			endif
			
			conout( cBarraStatus )
			
		EndDo
		
		oObj:CloseConnection()
		if( !oObj:IsConnected() )
			cBarraStatus := 	"Desconectado ... " + time()
		else
			cBarraStatus := 	"Falha ao tentar Desconectar !!! " + time()
		Endif
		
	Else
		cBarraStatus:= "Erro na Conexão! "
		Conout( cBarraStatusRet , nResp  )
		return (cRet:='0')
	Endif
Next F

If Val(cRet) > 0
	_lAut := .T.
Endif

Return
//Return cRet*/




//Verifica o Item do Pedido que deseja pesar
User FUNCTION CheckItC6(cOpcao,cTpOper,_cCheck)
	
	Local _stru			:= {}
	Local aCpoBro 		:= {}
	Local aCores 		:= {}
	
	Private _oDlg1
	Private lInverte 	:= .F.
	Private cMark   	:= GetMark()
	Private oMark
	Private _cIt    	:= Space(2)
	Private _lGo		:= .F.
	
	AADD(_stru,{"OK"     	,"C"	,2		,0		})
	AADD(_stru,{"ITEM"    	,"C"	,2		,0		})
	AADD(_stru,{"PRODUTO"   ,"C"	,15		,0		})
	AADD(_stru,{"DESCRIC"   ,"C"	,20		,0		})
	AADD(_stru,{"ENTREGA" 	,"D"	,8		,0		})
	AADD(_stru,{"QTDVEN"	,"N"	,12		,2		})
	AADD(_stru,{"QTDENT"	,"N"	,12		,2		})
	AADD(_stru,{"UNIT"    	,"N"	,12		,2		})
	AADD(_stru,{"TOTAL" 	,"N"	,12		,2		})
	AADD(_stru,{"STATUS" 	,"C"	,1		,0		})
	AADD(_stru,{"PESOINI" 	,"N"	,12		,2		})
	AADD(_stru,{"PESOFIN" 	,"N"	,12		,2		})
	
	cArq:=Criatrab(_stru,.T.)
	_cIndTrb := "ITEM"
	DBUSEAREA(.t.,,carq,"TTRB")
	
	dbSelectArea("TTRB")
	IndRegua("TTRB",cArq,_cIndTrb,,,"Criando Trabalho...")
	
	SC6->(dbSetOrder(1))
	SC6->(msSeek(xFilial('SC6')+SC5->C5_NUM))
	
	While  SC6->(!Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM == SC5->C5_FILIAL+SC5->C5_NUM
		
		TTRB->(RecLock("TTRB",.T.))
		TTRB->ITEM    := SC6->C6_ITEM
		TTRB->PRODUTO := SC6->C6_PRODUTO
		TTRB->DESCRIC := SC6->C6_DESCRI
		TTRB->ENTREGA := SC6->C6_ENTREG
		TTRB->QTDVEN  := SC6->C6_QTDVEN
		TTRB->QTDENT  := SC6->C6_QTDENT
		TTRB->UNIT 	  := SC6->C6_PRCVEN
		TTRB->TOTAL	  := SC6->C6_VALOR
		If SC6->C6_QTDVEN > SC6->C6_QTDENT
			If SC6->C6_YPESINI = 0
				TTRB->STATUS  := "1"    //Verde
			ElseiF SC6->C6_YPESFIN = 0
				TTRB->STATUS  := "3"    //Amarelo
			ELSE
				TTRB->STATUS  := "4"    //Azul
			Endif
		Else
			TTRB->STATUS := "2"    //Vermelho
		Endif
		TTRB->PESOINI	 :=  SC6->C6_YPESINI
		TTRB->PESOFIN	 :=  SC6->C6_YPESFIN
		TTRB->(MsunLock())
		
		SC6->(DbSkip())
	Enddo//Define as cores dos itens de legenda.
	
	aCores := {}
	aAdd(aCores,{"TTRB->STATUS == '1'","BR_VERDE"	})
	aAdd(aCores,{"TTRB->STATUS == '2'","BR_VERMELHO"})
	aAdd(aCores,{"TTRB->STATUS == '3'","BR_AMARELO"})
	aAdd(aCores,{"TTRB->STATUS == '4'","BR_AZUL"})
	
	//Define quais colunas (campos da TTRB) serao exibidas na MsSelect
	
	aCpoBro	:= {;
		{ "OK"			,, " "           	,"@!"},;
		{ "ITEM"		,, "Item"         	,"@!"},;
		{ "PRODUTO"		,, "Codigo"         ,"@!"},;
		{ "DESCRIC"		,, "Descrição"      ,"@!"},;
		{ "ENTREGA"		,, "Dt. Entrega"    ,"@!"},;
		{ "QTDVEN"		,, "Quantidade"     ,"@E 999,999,999.99"},;
		{ "QTDENT"		,, "Entregue"   	,"@E 999,999,999.99"},;
		{ "UNIT"		,, "Unitário"   	,"@E 999,999,999.99"},;
		{ "TOTAL"		,, "Total"   		,"@E 999,999,999.99"},;
		{ "PESOINI"		,, "Peso Inicial"	,"@E 999,999,999.99"},;
		{ "PESOFIN"		,, "Peso Final"		,"@E 999,999,999.99"}}
	
	//Cria uma Dialog
	
	_cTit := If(cOpcao = '2', 'Itens do Pedido - Pesagem Inicial','Itens do Pedido - Pesagem Final')
	
	DEFINE MSDIALOG _oDlg1 TITLE _cTit From 0,0 To 400,850 PIXEL
	
	@ 05, 10 SAY "Pedido: " 				Size 020,010 OF _oDlg1 PIXEL
	@ 05, 35 MsGet SC5->C5_NUM  When .F.   	Size 040,008 Of _oDlg1 Pixel
	
	_cCli := SC5->C5_CLIENTE+'/'+SC5->C5_LOJAENT+' - '+Alltrim(Posicione('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJAENT,"A1_NOME"))
	
	@ 05, 90 SAY "Cliente: " 				Size 020,010 OF _oDlg1 PIXEL
	@ 05, 115 MsGet _cCli  		When .F.   	Size 140,008 Of _oDlg1 Pixel
	
	TTRB->(DbGotop())
	
	oMark := MsSelect():New("TTRB","OK","",aCpoBro,@lInverte,@cMark,{17,1,150,400},,,,,aCores)
	
	oMark:bMark := {| | Disp(cOpcao,cTpOper,_cCheck)} //Exibe a Dialog
	
	ACTIVATE MSDIALOG _oDlg1 CENTERED ON INIT EnchoiceBar(_oDlg1,{|| If(_lGo,_oDlg1:End(),MsgAlert('Nenhum Item marcado!'))},{|| _cIt := Space(2),_oDlg1:End()})
	
	//Fecha a Area e elimina os arquivos de apoio criados em disco.
	TTRB->(DbCloseArea())
	
	Iif(File(cArq + GetDBExtension()),FErase(cArq  + GetDBExtension()) ,Nil)
	
RETURN(_cIt)



//Valida a marcação do Item do pedido
Static Function Disp(cOpcao,cTpOper,_cCheck)
	
	_cIt := TTRB->ITEM
	_lGo := .F.
	
	TTRB->(dbGotop())
	
	WHILE !TTRB->(EOF())
		
		If _cCheck = 'DADOS'
			If (cOpcao = '2' .And. TTRB->STATUS = '1') .Or. (cOpcao = '6' .And. TTRB->STATUS = '3')
				
				TTRB->(RecLock("TTRB",.F.))
				If TTRB->ITEM = _cIt
					If Marked("OK")
						TTRB->OK := cMark
						_lGo := .T.
					Endif
				Else
					TTRB->OK := ""
				Endif
				TTRB->(MSUNLOCK())
				
			Else
				
				If TTRB->STATUS = '1' .And. TTRB->ITEM = _cIt  .And. cOpcao = '6'
					MsgAlert('Item sem Peso Inicial!')
				ElseIf TTRB->STATUS = '3' .And. TTRB->ITEM = _cIt .And. cOpcao = '2'
					MsgAlert('Item já tem Peso Inicial!')
				ElseIf TTRB->STATUS = '2' .And. TTRB->ITEM = _cIt
					MsgAlert('Item já está Faturado!')
				ElseIf TTRB->STATUS = '4' .And. TTRB->ITEM = _cIt
					MsgAlert('Item com Pesagem Finalizada!')
				Endif
				
				TTRB->(RecLock("TTRB",.F.))
				TTRB->OK := ""
				TTRB->(MSUNLOCK())
			Endif
			
		ELSEIF _cCheck = 'RELATORIO'
			
			If TTRB->STATUS $ '2|4'
				
				TTRB->(RecLock("TTRB",.F.))
				If TTRB->ITEM = _cIt
					If Marked("OK")
						TTRB->OK := cMark
						_lGo := .T.
					Endif
				Else
					TTRB->OK := ""
				Endif
				TTRB->(MSUNLOCK())
			ELse
				If TTRB->ITEM = _cIt
					MsgAlert('Item não está com a Pesagem Finalizada!')
				Endif
				
				TTRB->(RecLock("TTRB",.F.))
				TTRB->OK := ""
				TTRB->(MSUNLOCK())
			Endif
		ENDIF
		
		TTRB->(dbskip())
	EndDo
	
	oMark:oBrowse:Refresh()
	
	If !_lGo
		_cIt := Space(2)
	Endif
	
Return()




// _____________________________________
//|										|
//|	Nova função de pesagem Vila Nova	|
//|	Marcus Vinicius - 15/06/2016		|
//|_____________________________________|

user function VnGetIP(p_cIP,p_cPort, p_oBtn)
	
	Local oObj := tSocketClient():New()         	// Cria um objeto do tipo Socket Client.
	Local cRet := 0									// Variável utilizada para armazenar o retorno da pesagem.
	
	_ip:= alltrim(p_cIP)							// Atribui a variável o IP do módulo de pesagem.
	_port:= val(p_cPort)							// Atribui a variável a porta do módulo de pesagem.
	_timeout:=02									// Atribui a variável o tempo para comunicação com o módulo de pesagem.
	
	p_oBtn:Disable()								// Desabilita o botão de pesagem.
	cBarraStatus:= 'Iniciando ... '
	Conout( cBarraStatus )							// Registra no console o momento que inicia a comunicação com o módulo de pesagem.
	
	nResp := oObj:Connect( _port, _ip, _timeout ) 	// Tento efetuar a Conexão com o módulo aguardando o milisegungos configurado na variável _timeout.
	if (nResp == 0 )								// Caso tenha sucesso na conexão atribui na variável nResp := 0.
		cBarraStatus:= "Conexão OK!  IP:  "+_ip+"  Porta: "+str(_port,5)
		Conout( cBarraStatus )						// Registra no console que comunicou com o IP e Porta do módulo.
		
		if( oObj:IsConnected() )					// Verifico se a conexão foi efetuada com sucesso.
			cBarraStatus:="OK! Conectado ... " + time()
			
			// Inicia a coleta da pesagem através do módulo IP.
			
			cBuffer := ""
			xAux:=""
			//			ncont:=1
			nQtd := oObj:Receive( @cBuffer, 10000 )	// Tento obter resposta aguardando por n milisegundos.
			
			if nQtd>0								// Se obtive alguma resposta.
				conout(  cbuffer )					// Registra no console o conteúdo do Buffer coletado no módulo de pesagem.
				cRet:=  substr( cbuffer, at( '+', cbuffer )+4, 7 )	// Percorre o Buffer posicionando e atribuindo na variável cRet o peso do veículo.
			else
				cRet:='0'
			endif
			
			if empty(cret) .or. val( cret ) == 0 .or. len(cret) < 7 .or. 'k' $ cRet	// Verifica se o peso é válido.
				cRet := '0'
			endif
		else
			cBarraStatus := "Ops! Nao Conectado ...  " + time()	// Informa no console se não obteve êxito na comunicação com o módulo
			cRet:='0'								// Retorna peso Zero
		endif
		
	else
		cBarraStatus:= "Erro na Conexão! "			//  Erro na conexão com o equipamento.
		Conout( cBarraStatusRet , nResp  )
		return (cRet:='0')
	endif
	
	conout( cBarraStatus )
	
	oObj:CloseConnection()      					// Fecha a conexão com o módulo
	if( !oObj:IsConnected() )						// Verifica se não tem conexão ativa
		cBarraStatus := 	"Desconectado ... " + time()	// Se não tiver ativo, desconectado com sucesso.
	else
		cBarraStatus := 	"Falha ao tentar Desconectar !!! " + time()	// Falha ao desconectar.
	endif
	conout( cBarraStatus )							// Registra no console.
	
	p_oBtn:enable()									// Habilita botão de pesagem.
	
return  cRet										// Retorna peso.
