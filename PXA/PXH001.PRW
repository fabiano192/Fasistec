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
PXH00101-SMPESOINI
PXH00102-SMPESAGEM
PXH00103-smPesoFin
PXH00104-smRelTicket
PXH001A -smTICKET
PXH001B -smCupomBal Cupom de Pesagem - Compras
PXH001C -SMFATF75

SZ1-SZH

PXH00101
Criar os campos SC5 E SC6
*/

User Function PXH00101(p_cOpcao, p_cTpOper)

	Local cOpcao :=  iif( p_cOpcao  == nil .or. !(p_cOpcao$'2/6') , '2' , p_cOpcao )

	if valtype(p_cTpOper)=='N'
		cTpOper:=  iif(  !(alltrim(str(p_cTpOper))$'C/D'), 'C' , p_cTpOper )
	elseif valtype(p_cTpOper)=='C'
		cTpOper:=  iif(  !(p_cTpOper$'C/D'), 'C' , p_cTpOper )
	else
		cTpOper:= 'C'
	endif

Return( U_PXH00102(cOpcao, cTpOper)   )


User Function PXH00103(p_cOpcao, p_cTpOper)

	local cOpcao :=  iif( p_cOpcao  == nil .or. !(p_cOpcao$'2/6') , '6' , p_cOpcao )

	if valtype(p_cTpOper)=='N'
		cTpOper:=  iif(  !(alltrim(str(p_cTpOper))$'C/D'), 'C' , p_cTpOper )
	elseif valtype(p_cTpOper)=='C'
		cTpOper:=  iif(  !(p_cTpOper$'C/D'), 'C' , p_cTpOper )
	else
		cTpOper:= 'C'
	endif

Return( U_PXH00102(cOpcao, cTpOper)   )


User Function PXH00104()

	local cnumero:= nil
	cnumero:= iif( alias()=='SZH' , SZH->ZH_NUM  , iif( alias()=='SC5' , SC5->C5_NUM , nil ) )

Return( U_PXH001A(cnumero, alias()) )



User Function PXH00102(p_cOpcao,p_cTpOper)

	Local wArea      := getArea()
	Local cOpcao     := p_cOpcao
	Local cTpOper    := p_cTpOper
	Local lCarrGranel:= .f.

	Private cHora	   := time()
	Private cPlacaCar  := Space(TamSx3("DA3_PLACA")[1])
	Private ccodVeic   := Space(TamSx3("DA3_COD")[1])
	Private cCodMotor  := Space(TamSx3("DA4_COD")[1])
	Private cNomMotor  := Space(TamSx3("DA4_NOME")[1])
	Private cCodTrans  := Space(TamSx3("A4_COD")[1])
	Private cNomTrans  := Space(TamSx3("A4_NOME")[1])
	Private cMenNota   := Space(TamSx3("C5_MENNOTA")[1])
	Private _cItem
	
	do case
		case cTpOper == 'C'  // CARREGAMENTO - VENDA
		if !empty(sc5->c5_nota)
			Alert('Pedido ja Faturado!')
			restArea(wArea)
			return
		endif

		if SC5->C5_BLQ = 'B'
			Alert('Pedido Bloqueado!')
			restArea(wArea)
			return
		endif

		_cItem := U_CheckItem(cOpcao,cTpOper,'DADOS')

		If Empty(_cItem)
			restArea(wArea)
			return		
		Endif

		SC6->(dbsetorder(1))
		SC6->(dbseek( xfilial('SC6')+sc5->c5_num + _cItem ))

		if cOpcao =='2' .and. sc6->c6_ypesini > 0
			Alert('Pedido ja possui peso inicial!')
			restArea(wArea)
			return
		endif

		if cOpcao =='6' .and. sc6->c6_ypesini == 0
			Alert('Pedido nao possui peso inicial!')
			restArea(wArea)
			return
		endif

		if cOpcao =='6' .and. sc6->c6_ypesliq > 0
			Alert('Pedido com pesagem finalizada!')
			restArea(wArea)
			return
		endif

		if !empty(sc5->c5_yplaca)
			cPlacaCar:= sc5->c5_yplaca
		endif
		if !empty(sc5->c5_ycodmot)
			ccodMotor:=	sc5->c5_ycodmot
			cnomMotor:=	sc5->c5_ynommot
		endif
		if !empty(sc5->c5_yhorsai)
			cHora		:= sc5->c5_yhorsai
		endif
		if !empty(sc5->c5_transp)
			ccodTrans		:= sc5->c5_transp
			cnomTrans := posicione('SA4',1,xfilial('SA4')+ccodTrans,"A4_NOME" )
		endif
		if !empty(sc5->c5_mennota)
			cMenNota		:= sc5->c5_mennota
		endif

		case cTpOper == 'D' // DESCARREGAMENTO - COMPRAS

		if !empty(m->zH_placa)
			cPlacaCar:= m->zH_placa
		endif
		if !empty(m->zH_codmot)
			ccodMotor:=	m->zH_codmot
			cnomMotor:=	posicione('DA4',1,xfilial('DA4')+ccodMotor,"DA4_NOME" )
		endif
		if !empty(m->zH_horini)
			cHora		:= m->zH_horini
		endif
		if !empty(m->zH_codtran)
			ccodTrans		:= m->zH_codtran
			cnomTrans := posicione('SA4',1,xfilial('SA4')+ccodTrans,"A4_NOME" )
		endif
	endcase

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oDlg2","oSay1","oSay2","oSay3","oSay4","oBtGranel","oBtn2","oBtn3","oGet1","oGet2","oGet3","oGet4")

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlg2      := MSDialog():New( 241,349,440,780,"Operações",,,.F.,,,,,,.T.,,,.T. )

	nspSay:=13
	nlnSay:=005
	oSay3      := TSay():New( nlnSay += nspSay ,012,{||"Hora"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
	oSay1      := TSay():New( nlnSay += nspSay ,012,{||"Placa"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
	oSay2      := TSay():New( nlnSay += nspSay ,012,{||"Motorista"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
	oSay4      := TSay():New( nlnSay += nspSay ,012,{||"Transp."},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
	oSay5      := TSay():New( nlnSay += nspSay ,012,{||"Mens.NF."},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)


	nlinbtn:= 83 //LINHA DOS BOTOES

	do case
		case cOpcao == "1"
		//oBtn2  := TButton():New( 050,069,"Chamar no Pager",oDlg2,{|| MsAguarde({|| fChamar(@oBrwAux,1), oDlg2:End()},"Gravando mensagem no SIGEX...")},055,015,,,,.T.,,"",,,,.F. )
		case cOpcao == "2"
			oBtn1  := TButton():New( nlinbtn,008,"Cancelar Chamar",oDlg2,{|| MsAguarde({|| fChamar(@oBrwAux,2), oDlg2:End()},"Gravando mensagem no SIGEX...")},042,015,,,,.T.,,"",,,,.F. )
			oBtn1:disable()
			oBtn2  := TButton():New( nlinbtn,055,iif(!lCarrGranel, "Pesar", "S/ Peso" ),oDlg2,{|| MsAguarde( {|| fPesar(cOpcao,cTpOper, lCarrGranel,,_cItem) },"Atualizando...") },042,015,,,,.T.,,"",,,,.F. )
			//oBtn3  := TButton():New( nlinbtn,103,"Peso Manual",oDlg2,{|| MsAguarde( {|| Senha(p_cOpcao,"I") },"Atualizando...") },042,015,,,,.T.,,"",,,,.F. )
		case cOpcao == "6"
//			oBtn1  := TButton():New( nlinbtn,010,"Pesar Saída",oDlg2,{|| MsAguarde( {|| fPesarSai(cOpcao, cTpOper, lCarrGranel,_cItem) },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
			oBtn4  := TButton():New( nlinbtn,080,"Peso Manual",oDlg2,{|| MsAguarde( {|| Senha(p_cOpcao,"F") },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
			//		oBtn4  := TButton():New( nlinbtn,080,"Peso Manual",oDlg2,{|| MsAguarde( {|| U_altera_peso(@p_nPesoRet) },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
			//		oBtn4:disable()
		case cOpcao == "3"
			if luserFull .and. ( oBrwAux:aArray[oBrwAux:nAT,6] > 0  ) // .or. lCarrGranel )
				oBtn1  := TButton():New( nlinbtn,010,"Status Sigex",oDlg2,{|| fMudaStat(@oBrwAux) },055,015,,,,.T.,,"",,,,.F. )
			Endif
			if lCarrGranel
				oBtn2  := TButton():New( nlinbtn,069,"Captura Peso",oDlg2,{|| MsAguarde( {|| fPesar(lCarrGranel) },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
			Endif
	EndCase

	//oBtn3      := TButton():New( nlinbtn ,128,"Fechar",oDlg2,{|| oDlg2:End()},055,015,,,,.T.,,"",,,,.F. )
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


Static Function fPesar(p_cOpcao,p_cTpOper, p_lCarrGranel,p_lSemPeso,p_cItem)

	//Local nPesoAux  := 0
	Local aAreaAtu  := GetArea()
	local cStatus   := p_cOpcao
	local cTpOper   := p_cTpOper
	local cItem     := p_cItem
	local cNumero   := iif(cTpOper=='C' , sc5->c5_num , szH->zH_num )
	local wAlCab    := iif(cTpOper=='C' , 'SC5' , 'SZH' )
	local wAlDet    := iif(cTpOper=='C' , 'SC6' , 'SZH' )
	local lBalIP    := .T.  // usa balança eternt - via ip
	local lusaLacres:= .f.

	Private nPesoAux:= 0

	// so aceita passar sem peso, quando for granel e o status for "2-aguardando pesagem"
	lSemPeso:= iif( p_lSemPeso==nil, .f., p_lSemPeso)

	nPesoAux :=0
	if lBalIP
		u_frmPesoBal(@nPesoAux,"ENTRADA")
	else
		nPesoAux := u_getPSerial('E') // chamar novamente a funcao para obter o peso da balanca
	endif

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
		if p_lCarrGranel   .and. lusaLacres
			cLacre:=''
			while empty(cLacre)
				cLacre:= u_frmLacres()
			end
		endif

		nPEntAnt:= 0
		Begin Transaction

			do case
				case cTpOper =='C'

				If sc6->c6_num == cnumero

					sc6->( RecLock("SC6",.F.) )
					sc6->c6_ypesini := nPesoAux
					sc6->c6_yhorini := time()
					sc6->c6_ystatus := cstatus
					If Empty(SC6->C6_YTPPSIN)
						SC6->C6_YTPPSIN := "A"
					Endif
					sc6->(MsUnLock())

					sc5->( RecLock("SC5",.F.) )
					sc5->c5_yplaca  := cPlacaCar
					sc5->c5_veiculo := ccodVeic
					sc5->c5_ycodmot := ccodMotor
					sc5->c5_ynommot := cnomMotor
					sc5->c5_transp  := ccodTrans
					sc5->c5_mennota := cmennota
					sc5->c5_yhorsai := cHora

					sc5->(MsUnLock())

				EndIf

				case cTpOper =='D'

				If szH->zH_num == cnumero

					m->zH_pesini := nPesoAux
					m->zH_horini := time()
					m->zH_placa  := cPlacaCar
					m->zH_codmot := ccodMotor
					m->zH_codtran:= ccodTrans
					M->ZH_TPPSINI:= "A"

					szH->( RecLock("SZH",.F.) )
					szH->zH_pesini := nPesoAux
					szH->zH_horini := time()
					szH->zH_placa  := cPlacaCar
					szH->zH_codmot := ccodMotor
					szH->zH_codtran:= ccodTrans
					szH->zH_usuario:= alltrim(substr(cusuario,7,15))
					If Empty(SZH->ZH_TPPSINI)
						SZH->ZH_TPPSINI:= "A"
					Endif
				EndIf
			endcase

		End Transaction
	endif

	RestArea(aAreaAtu)

	oDlg2:End()

Return


User Function frmPesoBal(p_nPesoRet,p_cOrigem)

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

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oDlgPeso","oBal1","oSay2","oSay3","oSay4","oGet_bal1","oBtn_capBal1","oBtn_grvBal1","oBtn_grvBal2")
	SetPrvt("oGet_bal2","oGet_Bal4","oBtn_capBal4","oBtn_grvBal4","oBtn_grvBal3","oBtn_capBal3","oGet_Bal3","oBarraStatus")

	_aEndIP := StrToKArr(GETMV("PXH_IPBAL"),";")

	aIP   := {}
	aPort := {}

	aChave:= {"01"}
	aDesc := {"BAL.DE PESAGEM"}

	AADD(aIP  ,_aEndIP[1])
	AADD(aPort,_aEndIP[2])

	ctitulo:= ""
	ctitulo:= iif( p_cOrigem == "SAIDA", "Pesagem  -  S A I D A", "Pesagem - E N T R A D A" )
	_cTipo := iif( p_cOrigem == "SAIDA", "S", "E" )

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlgPeso      := MSDialog():New( 112,286,484,981,"Monitor de BALANÇAS",,,.F.,,,,,,.T.,,,.T. )

	oTitulo       := TSay():New( 010,085,{|| cTitulo },oDlgPeso,,oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,150,015)
	oBarraStatus  := TGet():New( 170,200,{|u| If(PCount()>0,oBarraStatus:=u,cBarraStatus)},oDlgPeso,150,010,'',,CLR_HBLUE,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cBarraStatus",,)
	oBarraStatus:disable()

	opesoManual   := TButton():New( 170,036,"Peso Manual",oDlgPeso,{|| Senha(p_cOrigem,"I") , oDlgPeso:end()  },050,012,,,,.T.,,"",,,,.F. )
	//Senha(p_cOpcao,"I")
	nposBal1:= aScan( aChave, '01' )

	If nposBal1 >0 //"Balanca1"
		oBal1      	:= TSay():New( 041,036,{|| aDesc[nposbal1] },oDlgPeso,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
		oGet_bal1  	:= TGet():New( 038,116,{|u| If(PCount()>0,cGet_bal1:=u,cGet_bal1)}  ,oDlgPeso,075,015,'',,CLR_HBLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_bal1",,)
		oGet_bal1:disable()
		bCaptura	:= {|| cBarraStatus:= "Iniciando Conexão IP:  "+aIP[nposBal1]+"  Porta: "+aPort[nposBal1] , oBarraStatus:refresh(), cGet_bal1:=U_GETPESO(aIP[nposBal1], aPort[nposBal1] , oBt_capBa1 , _cTipo)  }
		oBt_capBa1 	:= TButton():New( 041,229,"Capturar",oDlgPeso, bCaptura ,037,012,,,,.T.,,"",,,,.F. )
		oBt_grvBa1 	:= TButton():New( 041,276,"Gravar",oDlgPeso,{|| p_nPesoRet:= val(cGet_Bal1), oDlgPeso:end()  },037,012,,,,.T.,,"",,,,.F. )
	Endif

	nposBal2:= aScan( aChave, '02' )
	if nposBal2 >0 //"Balanca2"
		oSay2      := TSay():New( 069,036,{||aDesc[nposbal2]},oDlgPeso,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
		oGet_bal2  := TGet():New( 066,116,{|u| If(PCount()>0,cGet_bal2:=u,cGet_bal2)},oDlgPeso,075,015,'',,CLR_HBLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_bal2",,)
		oGet_bal2:disable()
		oBt_capBa2 := TButton():New( 069,229,"Capturar",oDlgPeso,{|| cGet_bal2:= U_GETPESO(aIP[nposBal2], aPort[nposBal2] , oBt_capBa2  , _cTipo)    },037,012,,,,.T.,,"",,,,.F. )
		oBt_grvBa2 := TButton():New( 069,276,"Gravar",oDlgPeso,{|| p_nPesoRet:= val(cGet_bal2), oDlgPeso:end()  },037,012,,,,.T.,,"",,,,.F. )

	endif

	nposBal3:= aScan( aChave, '03' )
	if nposBal3 >0 //"Balanca3"
		oSay3      := TSay():New( 099,036,{||aDesc[nposbal3]},oDlgPeso,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
		oGet_Bal3  := TGet():New( 096,116,{|u| If(PCount()>0,cGet_Bal3:=u,cGet_Bal3)},oDlgPeso,075,015,'',,CLR_HBLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_Bal3",,)
		oGet_bal3:disable()
		oBt_capBa3 := TButton():New( 099,229,"Capturar",oDlgPeso,{||  cGet_Bal3:=U_GETPESO(aIP[nposBal3], aPort[nposBal3] , oBt_capBa3 , _cTipo )    },037,012,,,,.T.,,"",,,,.F. )
		oBt_grvBa3 := TButton():New( 099,276,"Gravar",oDlgPeso,{|| p_nPesoRet:= val(cGet_Bal3), oDlgPeso:end()  },037,012,,,,.T.,,"",,,,.F. )
	endif

	nposBal4:= aScan( aChave, '04' )
	if nposBal4 >0 //"Balanca4"
		oSay4      := TSay():New( 128,036,{||aDesc[nposbal4]},oDlgPeso,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
		oGet_Bal4  := TGet():New( 125,116,{|u| If(PCount()>0,cGet_Bal4:=u,cGet_Bal4)},oDlgPeso,075,015,'',,CLR_HBLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_Bal4",,)
		oGet_bal4:disable()

		oBt_capBa4 := TButton():New( 128,229,"Capturar",oDlgPeso,{||cGet_Bal4:= U_GETPESO(aIP[nposBal4], aPort[nposBal4] , oBt_capBa4 , _cTipo )   },037,012,,,,.T.,,"",,,,.F. )
		oBt_grvBa4 := TButton():New( 128,276,"Gravar",oDlgPeso,{|| p_nPesoRet:= val(cGet_Bal4), oDlgPeso:end()  },037,012,,,,.T.,,"",,,,.F. )
	endif

	oDlgPeso:Activate(,,,.T.)

Return


//funcao para capturar o peso do aquivo .txt  gravado pelo software controlador das balancas
//
User Function getPSerial(p_cTipo,p_cPort)

	local _cDir    := getnewPar("MV_YBALDIR","c:\temp\")
	local _cArqEnt := 'balent.txt'
	local _cArqSai := 'balsai.txt'

	private nHdll  := 0
	private cText  := ''
	private ComEnt := iif( p_cPort<>nil, p_cPort, GetMv("MV_YCOMENT") )       //If MsOpenPort(nHdll,"COM1:4800,E,8,2")

	//cria a pasta TEMP na estacao do usuario
	If !ExistDir( _cDir )
		If MakeDir( _cDir ) <> 0
			MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
			Return
		EndIf
	EndIf

	//cria o arquivo .txt   de trabalho
	xAux:=_cDir+iif( p_cTipo=='E', _cArqEnt , _cArqSai )
	if !file( xAux  )
		memowrite(xAux,'')
	endif

	If p_cTipo=="S" //saida
		_BalES := getnewPar("MV_YBALSAI",xaux) //alltrim(getmv("MV_YBALSAI"))
		cText := 'SAIDA'
	Else
		_BalES := getnewPar("MV_YBALENT",xaux) //alltrim(getmv("MV_YBALENT"))
		cText := 'ENTRADA'
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Acessa arquivo da balanca                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If  ! file(_BalES)
		MsgBox("Arquivo de " + cText + " da Balanca nao existe! "+_BalES,"Atencao","ALERT")
		Return
	End

	cText := ''

	procregua(999)

	while .t.
		incproc('Abrindo porta ['+left(ComEnt,4)+' ] ... ')
		lprosseguir:= MsOpenPort(nHdll,ComEnt)

		if lprosseguir ; exit; endif

		if !MsgBox("Falha ao tentar abrir a porta ["+left(ComEnt,4)+" ]. Continuar tentando ?","Abrindo porta SERIAL", "YESNO")
			MsClosePort(nHdll)
			return 0
		endif
	end

	//lprosseguir:= .f.

	While .t.

		Inkey(0.9)
		incproc('Capturando peso porta ['+left(ComEnt,4)+' ] ... ')
		lprosseguir:= MSRead(nHdll,@cText)
		_peso := VAL(alltrim(substr(cText ,at(" ",cText)+1,12)))/100 //PesoContinuo()
		if MsgBox("Confirma peso ["+transform(_peso,'@E 99,999.999')+"]    ?","Lendo balança", "YESNO")
			lprosseguir:= .t.
			exit
		elseif MsgBox("Abortar leitura DIRETA da balanca ?","Lendo balança", "YESNO")
			lprosseguir:= .f.
			exit
		endif
	end

	nHdll := 0
	cText := ''
	MsClosePort(nHdll)
	MSRead(nHdll,@cText)

	//se houver falha na leitura via porta COM1 ou nao achou o aquivo texto
	if !lprosseguir

		//_peso     := iif( subs(memoread(_BalES),11,1)=='/','"'+ AllTrim( subs(memoread(_BalES),1,10) ) ,subs(memoread(_BalES),1,10))
		while .t.
			_peso     :=  AllTrim( memoread(_BalES) )
			_peso := subs( _peso , 2 , 7 )
			_peso     := val(_peso) / 100
			if MsgBox("Confirma peso ["+transform(_peso,'@E 99,999.999')+"]    ?","Lendo balança", "YESNO")
				exit
			endif
		end

		If _peso >= 88888 .or. _peso == 0
			Alert("Atencao, peso da balanca esta ERRADO. VERIFIQUE!")
			_peso:=0
		EndIf
	EndIf
	//End

Return (_peso)



Static Function fPesarSai(p_cOpcao, p_cTpOper, p_lCarrGranel)

	Local nPesoAux  := 0
	Local aAreaAtu  := GetArea()
	local cStatus   := p_cOpcao
	local cTpOper   := p_cTpOper
	local cNumero   := iif(cTpOper=='C' , sc5->c5_num , szH->zH_num )
	local wAlCab    := iif(cTpOper=='C' , 'SC5' , 'SZH' )
	local wAlDet    := iif(cTpOper=='C' , 'SC6' , 'SZH' )
	local lBalIP    := .f.  // usa balança eternt - via ip
	local lusaLacres:= .f.

	If cEmpAnt $ "01/16"

		nPesoAux :=0
		u_frmPesoBal(@nPesoAux,"SAIDA")
		lpesoOK := .T.
	Else
		lpesoOk:= .f.
		lyes   := .f.
		While  !lpesoOK

			nPesoAux := u_getPSerial("S") // chamar novamente a funcao para obter o peso da balanca
			lyes     := MsgBox("Peso da Balança: "+TRANSFORM(nPesoAux,'@E 99,999.999')+" Confirma?","Peso Balança", "YESNO")
			if !lyes
				lpesoOK:=.f.
				exit
			endif

			//validação da margem de diferença de peso
			lpesoOK:=.t.

			if 1==2

				nPesLiq:=0
				nPesLiq:= sz8->z8_psent - nPesoAux

				nDifPes:=0
				nDifPes:= sz8->z8_nfpesen - nPesLiq

				if  nDifPes > getnewPar('MV_MXDIFPS',200)
					MsgBox("ATENCAO!   A diferença de Peso é maior que a permitida! ","Peso Errado!!! ", "ALERT")
					lpesoOK:= u_getConfirm()
				endif
			endif
		EndDo

	Endif
	(wAlDet)->(dbsetorder(1))
	(wAlDet)->(dbseek( xfilial(wAlDet)+cnumero  ))

	if empty(nPesoAux)
		Alert('Nao e permitido prosseguir sem peso!')
	elseif lpesoOK

		do case
			case cTpOper == 'C'

			If sc6->c6_num == cnumero

				sc6->( RecLock("SC6",.F.) )

				npesliq:=0
				npesliq:= nPesoAux - sc6->c6_ypesini

				sc6->c6_ypesfin := nPesoAux
				sc6->c6_ypesliq := npesliq
				sc6->c6_yhorfin := time()
				sc6->c6_ystatus := cstatus
				sc6->c6_yqtorig := sc6->c6_qtdven
				sc6->c6_qtdven  := sc6->c6_ypesliq
				sc6->c6_qtdlib  := sc6->c6_ypesliq
				sc6->c6_valor   := sc6->c6_prcven * sc6->c6_qtdven
				sc6->c6_op      := '06'
				If Empty(SC6->C6_YTPPSFI)
					SC6->C6_YTPPSFI := "A"
				Endif

				a410Refr("C6_QTDLIB")

				sc6->(MsUnLock())

				sc5->( RecLock("SC5",.F.) )
				//				sc5->c5_liberok := 'S'
				sc5->c5_pesol   := npesliq
				sc5->c5_pbruto  := npesliq
				sc5->(MsUnLock())
			EndIf

			case cTpOper == 'D'

			If szH->zH_num == cnumero

				m->zH_pesfin := nPesoAux
				m->zH_pesliq := szH->zH_pesini - nPesoAux
				m->zH_horfin := time()
				If Empty(M->ZH_TPPSFIM)
					M->ZH_TPPSFIM := "A"
				Endif

				//If cEmpAnt <> '16'
				//	szH->( RecLock("SZH",.F.) )
				//	szH->zH_pesfin := m->zH_pesfin
				//	szH->zH_pesliq := m->zH_pesliq
				//	szH->zH_horfin := m->zH_horfin
				//	szH->zH_usuario:= alltrim(substr(cusuario,7,15))
				//	szH->(MsUnLock())
				//EndIf

			EndIf
		Endcase

		//If cEmpAnt <> '16'
		//	U_PXH001A(cnumero,wAlCab)
		//Endif

	Endif

	RestArea(aAreaAtu)

	oDlg2:End()

Return


Static Function Senha(cOpcao,_cTipo)

	Local cNumero   := Iif(cTpOper=='C' , SC5->C5_NUM , SZH->ZH_NUM )

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

	_lOK := U_PXH042("PXH001",6,.F.)
	If _lOK
		@ 40, 85 BUTTON "Alterar Senha"	SIZE 036,012 ACTION  (_nOpca:=3,_oSenhas:END()) OF _oSenhas PIXEL
	Endif

	ACTIVATE DIALOG _oSenhas CENTERED

	If _nOpca == 1
		If AllTrim(_cSenDig) == Alltrim(_cSenPad)
			Peso_M(cnumero,cOpcao,_cTipo)
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



Static Function Peso_M(cnumero,CSTATUS,_cTipo)

	local wAlCab    := iif(cTpOper=='C' , 'SC5' , 'SZH' )

	_nOpt   := _nPesoM := 0
	DEFINE MSDIALOG _oPeso_M FROM 00, 00 TO 10,38 TITLE "Peso Manual"

	@ 01,01  TO 60,130 OF _oPeso_M PIXEL

	@ 10,05  Say "Digite o Peso abaixo: " OF _oPeso_M PIXEL

	@ 25, 05 Say "Peso: " 								Size 030, 007 OF _oPeso_M PIXEL
	@ 25, 30 MsGet _nPesoM PICTURE "@E 999,999.99" 		Size 050, 007 OF _oPeso_M PIXEL

	@ 40, 05 BUTTON "OK" 			SIZE 036,012 ACTION  (_nOpt:=1,_oPeso_M:END()) OF _oPeso_M PIXEL
	@ 40, 45 BUTTON "Sair"       	SIZE 036,012 ACTION  (_oPeso_M:END()) OF _oPeso_M PIXEL

	ACTIVATE DIALOG _oPeso_M CENTERED

	If _nOpt = 1

		nPesoAux := _nPesoM

		Begin Transaction

			do case
				case cTpOper =='C'

				If SC6->C6_NUM == cnumero

					If _cTipo == 'I'
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

					ElseIf _cTipo == 'F'

						nPesliq  := Round(_nPesoM,0) - SC6->C6_YPESINI
						_nC6QTDV := SC6->C6_QTDVEN
						_nDif    := 0
						If _nC6QTDV <> Round(nPesliq,0)

							_nDif := nPesliq - SC6->C6_QTDVEN
							MsgAlert('Quantidade carregada diferente da programação!'+CRLF+;
							'Quantidade Programação: '+Alltrim(Transform(SC6->C6_QTDVEN,"@E9,999,99.99"))+CRLF+;
							'Quantidade Atual:       '+Alltrim(Transform(nPesliq,"@E9,999,99.99"))	+CRLF+;
							'Diferença:              '+Alltrim(Transform( _nDif,"@E9,999,99.99")))
						Endif 

						SC6->( RecLock("SC6",.F.) )
						SC6->C6_YPESFIN := Round(_nPesoM,0)
						SC6->C6_YPESLIQ := Round(nPesliq,0)
						SC6->C6_YHORFIN := time()
						If SC6->C6_YQTORIG = 0
							SC6->C6_YQTORIG := SC6->C6_QTDVEN
						Endif
						SC6->C6_QTDVEN  := SC6->C6_YPESLIQ
						SC6->C6_QTDLIB  := SC6->C6_YPESLIQ
						SC6->C6_VALOR   := SC6->C6_PRCVEN * SC6->C6_QTDVEN
						SC6->C6_OP      := '06'
						SC6->C6_YSTATUS := CSTATUS
						SC6->C6_YTPPSIFI:= "M"

						a410Refr("C6_QTDLIB")

						SC6->(MsUnlock())

						SC5->( Reclock("SC5",.F.) )
						//						SC5->C5_LIBEROK := 'S'
						SC5->C5_PESOL   := npesliq
						SC5->C5_PBRUTO  := npesliq
						SC5->(MsUnlock())

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
					Endif

				EndIf

				case cTpOper =='D'

				If SZH->ZH_NUM == cnumero

					If _cTipo == 'I'
						M->ZH_PESINI := _nPesoM
						M->ZH_HORINI := TIME()
						M->ZH_PLACA  := CPLACACAR
						M->ZH_CODMOT := CCODMOTOR
						M->ZH_CODTRAN:= CCODTRANS
						M->ZH_TPPSINI:= "M"

						SZH->( RecLock("SZH",.F.) )
						SZH->ZH_PESINI := _nPesoM
						SZH->ZH_HORINI := TIME()
						SZH->ZH_PLACA  := CPLACACAR
						SZH->ZH_CODMOT := CCODMOTOR
						SZH->ZH_CODTRAN:= CCODTRANS
						SZH->ZH_USUARIO:= ALLTRIM(SUBSTR(CUSUARIO,7,15))
						SZH->ZH_TPPSINI:= "M"
						SZH->( MsUnlock() )
					ElseIf _cTipo == 'F'
						m->zH_pesfin := nPesoAux
						m->zH_pesliq := szH->zH_pesini - nPesoAux
						m->zH_horfin := time()
						m->ZH_TPPSFIM := "M"

						szH->( RecLock("SZH",.F.) )
						szH->zH_pesfin := m->zH_pesfin
						szH->zH_pesliq := m->zH_pesliq
						szH->zH_horfin := m->zH_horfin
						szH->zH_usuario:= alltrim(substr(cusuario,7,15))
						SZH->ZH_TPPSFIM:= "M"
						szH->(MsUnLock())
					Endif
				EndIf
			Endcase

		End Transaction

		oDlg2:End()

		If _cTipo == 'F'
			U_PXH001A(cnumero,wAlCab,_cItem)
		Endif

	Endif

Return()

User Function GETPESO(p_cIP,p_cPort, p_oBtn, p_cTipo)

	local cRet:=""

	cret:=	u_getPIP(p_cIP,p_cPort, p_oBtn, p_cTipo)

return cRet


User Function getPIP(p_cIP,p_cPort, p_oBtn, p_cTipo,p_lAutom)

	local oObj      := tSocketClient():New()
	local cRec      := ""
	local cIP       := iif( p_cIP   ==nil, "10.1.2.51" ,cValtoChar(ALLTRIM(p_cIP)) )
	local nPort     := iif( p_cPort ==nil, 8881 , VAL(p_cPort) )
	local cTipo     := iif( p_cTipo ==nil, "E" , ALLTRIM(p_cTipo))
	local lAutom    := iif( p_lAutom==nil, .f. , p_lAutom )
	Local oBtn      := iif( p_oBtn  ==nil, nil , p_oBtn )
	local ntimeout  := 2
	local nVezes    := 3
	local nTry      := 1
	local nRespse

	_lSair  := .F.
	nCont   := 1

	While ncont < 5 .And. !_lSair

		oObj := tSocketClient():New()
		cRet := ""

		_ip      := alltrim(p_cIP)
		_port    := val(p_cPort)
		_timeout := 2

		p_oBtn:Disable()
		cBarraStatus:= 'Iniciando ... '

		nResp := oObj:Connect( _port, _ip, _timeout )

		//Conout("Resposta: "+Str(nResp))

		If(nResp == 0 )
			cBarraStatus:= "Conexão OK!  IP:  "+_ip+"  Porta: "+str(_port,5)
			Conout( cBarraStatus )
		Else
			cBarraStatus:= "Erro na Conexão! "
			Conout( cBarraStatusRet , nResp  )
			return (cRet:='0')
		Endif

		cBuffer := ""
		xAux    := ""
		nQtd    := oObj:Receive( @cBuffer, 10000 )
		//Conout("Tamanho--> "+ cBuffer , nResp  )
		//			cBuffer := ""

		If nQtd > 0
			//				nQtd   := oObj:Receive( @cBuffer, 10000 )
			_cPeso := ""
			_cPesoA:= ""
			_lCont := .F.

			For Ax:= 1 To Len(cbuffer)
				_cPesoA := Substr(cbuffer,AX,1)

				If _cPesoA == Space(1) .Or. _lCont
					_cPeso += Alltrim(_cPesoA)
					_lCont := .T.
				Endif

				If Len(_cPeso) == 7 
					If Val(_cPeso) > 1000
						AX:= Len(cbuffer)
						_lSair := .T.
					Else
						_cPeso := ""
						_lCont := .F.
					Endif
				Endif
			Next AX

			ncont++

			//		cRet:=  Alltrim(str(Val(_cPeso) / 1000))
			cRet:=  Alltrim(str(Val(_cPeso)))

			conout(  _cPeso )
			//conout(" Arquivo --> "+cbuffer ) //+ ' ['+str(at( '+', xAux ), 3)+']')
		Else
			cRet:='0'
		Endif

		If( oObj:IsConnected() )
			cBarraStatus:="OK! Conectado ... " + time()
		else
			cBarraStatus := "Ops! Nao Conectado ...  " + time()
		endif

		conout( cBarraStatus )

		oObj:CloseConnection()
		if( !oObj:IsConnected() )
			cBarraStatus := 	"Desconectado ... " + time()
		else
			cBarraStatus := 	"Falha ao tentar Desconectar !!! " + time()
		Endif
	EndDo

Return cRet



Static function PXH001C(p_oObj,p_lAutom,p_cIP,p_cPort,p_cModelo,p_oBtn,p_cTipo)

	local oObj := tSocketClient():New()
	local cRet := ""

	_lSair  := .F.
	nCont   := 1

	While ncont < 10 .And. !_lSair

		oObj := tSocketClient():New()
		cRet := ""

		//Conout("contador: "+Str(nCont))

		_ip      := alltrim(p_cIP)
		_port    := val(p_cPort)
		_timeout := 2

		p_oBtn:Disable()
		cBarraStatus:= 'Iniciando ... '

		nResp := oObj:Connect( _port, _ip, _timeout )

		//Conout("Resposta: "+Str(nResp))

		If(nResp == 0 )
			cBarraStatus:= "Conexão OK!  IP:  "+_ip+"  Porta: "+str(_port,5)
			Conout( cBarraStatus )
		Else
			cBarraStatus:= "Erro na Conexão! "
			Conout( cBarraStatusRet , nResp  )
			return (cRet:='0')
		Endif

		cBuffer := ""
		xAux    := ""
		nQtd    := oObj:Receive( @cBuffer, 10000 )
		//Conout("Tamanho--> "+ cBuffer , nResp  )
		//			cBuffer := ""

		If nQtd > 0
			//				nQtd   := oObj:Receive( @cBuffer, 10000 )
			_cPeso := ""
			_cPesoA:= ""
			_lCont := .F.

			For Ax:= 1 To Len(cbuffer)
				_cPesoA := Substr(cbuffer,AX,1)

				If _cPesoA == Space(1) .Or. _lCont
					_cPeso += Alltrim(_cPesoA)
					_lCont := .T.
				Endif

				If Len(_cPeso) == 7
					AX:= Len(cbuffer)
					_lSair := .T.
				Endif
			Next AX

			ncont++

			//		cRet:=  Alltrim(str(Val(_cPeso) / 1000))
			cRet:=  Alltrim(str(Val(_cPeso)))

			conout(  _cPeso )
			//conout(" Arquivo --> "+cbuffer ) //+ ' ['+str(at( '+', xAux ), 3)+']')
		Else
			cRet:='0'
		Endif

		if( oObj:IsConnected() )
			cBarraStatus:="OK! Conectado ... " + time()
		else
			cBarraStatus := "Ops! Nao Conectado ...  " + time()
		endif

		conout( cBarraStatus )

		oObj:CloseConnection()
		if( !oObj:IsConnected() )
			cBarraStatus := 	"Desconectado ... " + time()
		else
			cBarraStatus := 	"Falha ao tentar Desconectar !!! " + time()
		endif
	EndDo

	if empty(cret) .or. val( cret ) == 0 //.or. len(cret) < 7 .or. 'k' $ cRet
		cRet := '0'
	endif

	p_oBtn:enable()

Return  cRet



User FUNCTION CheckItem(cOpcao,cTpOper,_cCheck)

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
		TTRB->ITEM    :=  SC6->C6_ITEM		
		TTRB->PRODUTO :=  SC6->C6_PRODUTO		
		TTRB->DESCRIC :=  SC6->C6_DESCRI	
		TTRB->ENTREGA :=  SC6->C6_ENTREG	
		TTRB->QTDVEN  :=  SC6->C6_QTDVEN		
		TTRB->QTDENT  :=  SC6->C6_QTDENT		
		TTRB->UNIT 	  :=  SC6->C6_PRCVEN		
		TTRB->TOTAL	  :=  SC6->C6_VALOR	
		If SC6->C6_QTDVEN > SC6->C6_QTDENT
			If SC6->C6_YPESINI = 0
				TTRB->STATUS  := "1"    //Verde
			ElseiF SC6->C6_YPESFIN = 0
				TTRB->STATUS  := "3"    //Amarelo
			ELSE
				TTRB->STATUS  := "4"    //Azul
			Endif
		Else
			TTRB->STATUS  := "2"    //Vermelho
		Endif
		TTRB->PESOINI	  :=  SC6->C6_YPESINI	
		TTRB->PESOFIN	  :=  SC6->C6_YPESFIN
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