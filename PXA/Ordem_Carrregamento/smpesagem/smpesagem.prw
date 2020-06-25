#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
  
//estrutura de funcoes criada, devido a chamada em submenu - pedido de venda
// p_cOpcao = '2' - inicial  6 - final
// p_cTpOper= 'C' - Carregamento (venda)  'D' - Descarregamento (compras)
//###############################################################################
user function smPesoIni(p_cOpcao, p_cTpOper)                                       
   local cOpcao :=  iif( p_cOpcao  == nil .or. !(p_cOpcao$'2/6') , '2' , p_cOpcao )

	if valtype(p_cTpOper)=='N'      
		cTpOper:=  iif(  !(alltrim(str(p_cTpOper))$'C/D'), 'C' , p_cTpOper )		
	elseif valtype(p_cTpOper)=='C'            
		cTpOper:=  iif(  !(p_cTpOper$'C/D'), 'C' , p_cTpOper )		
	else
		cTpOper:= 'C'	
	endif

return( u_smPesagem(cOpcao, cTpOper)   )

user function smPesoFin(p_cOpcao, p_cTpOper) 
   local cOpcao :=  iif( p_cOpcao  == nil .or. !(p_cOpcao$'2/6') , '6' , p_cOpcao )
	if valtype(p_cTpOper)=='N'      
		cTpOper:=  iif(  !(alltrim(str(p_cTpOper))$'C/D'), 'C' , p_cTpOper )		
	elseif valtype(p_cTpOper)=='C'            
		cTpOper:=  iif(  !(p_cTpOper$'C/D'), 'C' , p_cTpOper )		
	else
		cTpOper:= 'C'	
	endif   
return( u_smPesagem(cOpcao, cTpOper)   )

user function smRelTicket()   
	local cnumero:= nil
	cnumero:= iif( alias()=='SZ1' , sz1->z1_num  , iif( alias()=='SC5' , sc5->c5_num , nil ) ) 		
return( u_smTICKET(cnumero, alias()) )                           



user Function smPesagem(p_cOpcao,p_cTpOper)
	local wArea:= getArea()
   local cOpcao :=   p_cOpcao
	local cTpOper:=   p_cTpOper
	local lCarrGranel:= .f.  

	
	private cHora			:= time()
	private cPlacaCar  := Space(TamSx3("DA3_PLACA")[1])
	private ccodVeic   := Space(TamSx3("DA3_COD")[1])
	private cCodMotor  := Space(TamSx3("DA4_COD")[1])	             
	private cNomMotor  := Space(TamSx3("DA4_NOME")[1])	             	
	private cCodTrans  := Space(TamSx3("A4_COD")[1])	             
	private cNomTrans  := Space(TamSx3("A4_NOME")[1])	             	
	private cMenNota   := Space(TamSx3("C5_MENNOTA")[1])	             		
	                                   
	
	
               
	//VALIDAÇÕES INICIAIS
	//###################
	
	do case
		case cTpOper == 'C'  // CARREGAMENTO - VENDA
				if !empty(sc5->c5_nota)
					Alert('Pedido ja Faturado!')
					restArea(wArea)
					return
				endif
	
				sc6->(dbsetorder(1))
				sc6->(dbseek( xfilial('SC6')+sc5->c5_num  ))
			
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

            //sz1->(dbsetorder(1))
				//sc6->(dbseek( xfilial('SC6')+sc5->c5_num  ))            

				if !empty(m->z1_placa)
					cPlacaCar:= m->z1_placa
				endif		                      
				if !empty(m->z1_codmot)		
					ccodMotor:=	m->z1_codmot  
					cnomMotor:=	posicione('DA4',1,xfilial('DA4')+ccodMotor,"DA4_NOME" )
				endif
				if !empty(m->z1_horini)				
					cHora		:= m->z1_horini
				endif
				if !empty(m->z1_codtran)				
					ccodTrans		:= m->z1_codtran  
					cnomTrans := posicione('SA4',1,xfilial('SA4')+ccodTrans,"A4_NOME" )
				endif



   endcase   
   
	//FIM VALIDAÇÕES INICIAIS
	//#######################
	
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
			oBtn1  := TButton():New( nlinbtn,010,"Cancelar Chamar",oDlg2,{|| MsAguarde({|| fChamar(@oBrwAux,2), oDlg2:End()},"Gravando mensagem no SIGEX...")},055,015,,,,.T.,,"",,,,.F. )	
			oBtn1:disable()
			oBtn2  := TButton():New( nlinbtn,069,iif(!lCarrGranel, "Pesar", "S/ Peso" ),oDlg2,{|| MsAguarde( {|| fPesar(cOpcao,cTpOper, lCarrGranel) },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
		case cOpcao == "6"
		   //If SZ8->Z8_TPOPER == "C"
			//	oBtn2  := TButton():New( 050,069,"Faturar",oDlg2,{|| fFaturar() },055,015,,,,.T.,,"",,,,.F. )
			//ElseIf SZ8->Z8_TPOPER == "D"                                                
		
				oBtn1  := TButton():New( nlinbtn,010,"Pesar Saída",oDlg2,{|| MsAguarde( {|| fPesarSai(cOpcao, cTpOper, lCarrGranel) },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
				
				// ESSA É FORMA COMPLETA DO COMANDO. ALTERADO ATÉ DEFINICAO DO USU DA PRE-NOTA
				//oBtn2  := TButton():New( 050,069,"Pré-Nota"   ,oDlg2,{|| MsAguarde( {|| ExecBlock("MIZ993",.F.,.F.,SZ8->Z8_OC),oDlg2:End(),fConsulta() },"Pré-Nota...") },055,015,,,,.T.,,"",,,,.F. )
			//EndIf
		case cOpcao == "3"   
		    if luserFull .and. ( oBrwAux:aArray[oBrwAux:nAT,6] > 0  ) // .or. lCarrGranel )
				oBtn1  := TButton():New( nlinbtn,010,"Status Sigex",oDlg2,{|| fMudaStat(@oBrwAux) },055,015,,,,.T.,,"",,,,.F. )
			 endif	 
			 if lCarrGranel
				oBtn2  := TButton():New( nlinbtn,069,"Captura Peso",oDlg2,{|| MsAguarde( {|| fPesar(lCarrGranel) },"Atualizando...") },055,015,,,,.T.,,"",,,,.F. )
			 endif

	endcase
	
	oBtn3      := TButton():New( nlinbtn ,128,"Fechar",oDlg2,{|| oDlg2:End()},055,015,,,,.T.,,"",,,,.F. )
	 
	nspGet := 12
	nlnGet := 004	
			
	oGet3 := TGet():New( nlnGet += nspGet ,043,{|u| If(PCount()>0,cHora:=u,cHora)},oDlg2,021,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cHora",,)

	oGet1	:=	TGet():New( nlnGet += nspGet , 043   , bSETGET(cPlacaCar)		, oDlg2 ,033,008,,{||ExistCpo("DA3",cPlacaCar,3)},,,,,,.T.,,,,,,,,,,)
	oGet1:CF3 := "DA302"
	oGet1:BLostFocus := { || ccodVeic:= da3->da3_cod  }   	        
	
//	oGet2	:=	TGet():New(  030   , 043   , bSETGET(cMotorCar)		, oDlg2 ,116,008,,{||ExistCpo("DA4",cMotorCar,2)},,,,,,.T.,,,,,,,,,,)
//	oGet2:CF3 := "DA402"
	
	oGet2	:=	TGet():New(  nlnGet += nspGet  , 043   , bSETGET(cCodMotor)		, oDlg2 ,033,008,,{||ExistCpo("DA4",cCodMotor,1)},,,,,,.T.,,,,,,,,,,)
	oGet2:CF3 := "DA4"
	oGet2:BLostFocus := { || cnomMotor:= da4->da4_nome, oDlg2:Refresh() }   
   
   oGet5      := TGet():New( nlnGet  ,083,{|u| If(PCount()>0,cnomMotor:=u,cnomMotor)},oDlg2,116,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cnomMotor",,)

	oGet4	:=	TGet():New(  nlnGet += nspGet , 043   , bSETGET(cCodTrans)		, oDlg2 ,033,008,,{||ExistCpo("SA4",cCodTrans,1)},,,,,,.T.,,,,,,,,,,)
	oGet4:CF3 := "SA4"
	oGet4:BLostFocus := { || cnomTrans:= sa4->a4_nome, oDlg2:Refresh() }   
	
   oGet6  := TGet():New( nlnGet  ,083,{|u| If(PCount()>0,cnomTrans:=u,cnomTrans)},oDlg2,116,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cnomTrans",,)	

	oGet7	 :=	TGet():New(  nlnGet += nspGet+2    , 043   , bSETGET(cMenNota)		, oDlg2 ,150,008,,{||.t.},,,,,,.T.,,,,,,,,,,)
	//oGet7:CF3 := "DA402"



	oDlg2:Activate(,,,.T.)
	
Return







Static Function fPesar(p_cOpcao,p_cTpOper, p_lCarrGranel,p_lSemPeso)
	Local nPesoAux := 0
	Local aAreaAtu := GetArea()
	local cStatus:= p_cOpcao
	local cTpOper:= p_cTpOper
	local cNumero := iif(cTpOper=='C' , sc5->c5_num , sz1->z1_num )
	local wAlCab := iif(cTpOper=='C' , 'SC5' , 'SZ1' )
	local wAlDet := iif(cTpOper=='C' , 'SC6' , 'SZ1' )
	local lBalIP := .f.  // usa balança eternt - via ip
	local lusaLacres:= .f.

	
	
	// so aceita passar sem peso, quando for granel e o status for "2-aguardando pesagem"
	lSemPeso:= iif( p_lSemPeso==nil, .f., p_lSemPeso)  
	
	
	nPesoAux :=0
	if lBalIP 
		u_frmPesoBal(@nPesoAux,"ENTRADA")
	else
		nPesoAux := u_getPSerial('E') // chamar novamente a funcao para obter o peso da balanca
	endif
   
   
	(wAlDet)->(dbsetorder(1))
	(wAlDet)->(dbseek( xfilial(wAlDet)+cnumero  ))
	
	if (nPesoAux==0) .and. !lSemPeso  //saco
		Alert('Nao e permitido prosseguir sem peso!')
	else
	
			
		if p_lCarrGranel   .and. lusaLacres		
			cLacre:=''
			while empty(cLacre)
				cLacre:= u_frmLacres()
			end				
		endif
	
	
		//****************
			
		nPEntAnt:= 0 //sz8->z8_psent // grava o peso antes de altera-lo mais abaixo. para comparar se estava zerado
		Begin Transaction
		
			do case
				case cTpOper =='C'
	
						If sc6->c6_num == cnumero
							
							
								sc6->( RecLock("SC6",.F.) )
								
								sc6->c6_ypesini := nPesoAux
								sc6->c6_yhorini := time()
								sc6->c6_ystatus := cstatus
								
								if p_lCarrGranel .and. lusaLacres
									if !empty( Alltrim(cLacre) )
										sz8->z8_lacre := Alltrim(cLacre)
									else
										sz8->z8_lacre := 'Nao informado na entrada'
									endif
								endif			
								
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

						If sz1->z1_num == cnumero
							
							
								m->z1_pesini := nPesoAux
								m->z1_horini := time()
								m->z1_placa  := cPlacaCar            
								m->z1_codmot := ccodMotor				
								m->z1_codtran:= ccodTrans
								

								sz1->( RecLock("SZ1",.F.) )
								
								sz1->z1_pesini := nPesoAux
								sz1->z1_horini := time()
								sz1->z1_placa  := cPlacaCar            
								sz1->z1_codmot := ccodMotor				
								sz1->z1_codtran:= ccodTrans
								sz1->z1_usuario:= alltrim(substr(cusuario,7,15))
																
								if p_lCarrGranel .and. lusaLacres
									if !empty( Alltrim(cLacre) )
										sz8->z8_lacre := Alltrim(cLacre)
									else
										sz8->z8_lacre := 'Nao informado na entrada'
									endif
								endif			
								
								sz1->(MsUnLock())
							
						EndIf




			endcase
			
		End Transaction

	endif




	RestArea(aAreaAtu)
	
	oDlg2:End()
	
Return



// formulario para apresentação dos pesos das balanças.

User Function frmPesoBal(p_nPesoRet,p_cOrigem)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
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

               
aChave:={}
aDesc:={}
aIP:={}
aPort:={}


sx5->(dbsetorder(1))
if sx5->(dbseek( xfilial('SX5') + 'BL' ))
   while !sx5->(eof()) .and. sx5->x5_tabela == 'BL'
        
        aAdd( aChave , alltrim(sx5->x5_chave) )                                                                         
        aAdd( aDesc , alltrim(sx5->x5_descri) )   
        aAdd( aIP , sx5->x5_desceng )
        aAdd( aPort , sx5->x5_descspa )        
        
   		sx5->(dbskip())
   	
   end
else
	alert('Atencao:   Tabela auxiliar  (BL) nao localizada na SX5 !')
	return   
endif

      
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
//opesoManual   := TButton():New( 170,030,"Peso Manual",oDlgPeso,{|| p_nPesoRet:= 0, oDlgPeso:end()  },037,012,,,,.T.,,"",,,,.F. )
opesoManual   := TButton():New( 170,036,"Peso Manual",oDlgPeso,{|| u_altera_peso(@p_nPesoRet) , oDlgPeso:end()  },050,012,,,,.T.,,"",,,,.F. )


 
nposBal1:= aScan( aChave, '01' )
if nposBal1 >0 //"Balanca1"
	oBal1      := TSay():New( 041,036,{|| aDesc[nposbal1] },oDlgPeso,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
	oGet_bal1  := TGet():New( 038,116,{|u| If(PCount()>0,cGet_bal1:=u,cGet_bal1)}  ,oDlgPeso,075,015,'',,CLR_HBLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_bal1",,)
	oGet_bal1:disable()                                           
	bCaptura:= {|| cBarraStatus:= "Iniciando Conexão IP:  "+aIP[nposBal1]+"  Porta: "+aPort[nposBal1] , oBarraStatus:refresh(), cGet_bal1:=u_getsmPeso(aIP[nposBal1], aPort[nposBal1] , oBt_capBa1 , _cTipo)  }
	oBt_capBa1 := TButton():New( 041,229,"Capturar",oDlgPeso, bCaptura ,037,012,,,,.T.,,"",,,,.F. )
	oBt_grvBa1 := TButton():New( 041,276,"Gravar",oDlgPeso,{|| p_nPesoRet:= val(cGet_Bal1), oDlgPeso:end()  },037,012,,,,.T.,,"",,,,.F. )		
endif    


nposBal2:= aScan( aChave, '02' )
if nposBal2 >0 //"Balanca2"
	oSay2      := TSay():New( 069,036,{||aDesc[nposbal2]},oDlgPeso,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
	oGet_bal2  := TGet():New( 066,116,{|u| If(PCount()>0,cGet_bal2:=u,cGet_bal2)},oDlgPeso,075,015,'',,CLR_HBLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_bal2",,)
	oGet_bal2:disable()
	oBt_capBa2 := TButton():New( 069,229,"Capturar",oDlgPeso,{|| cGet_bal2:= u_getsmPeso(aIP[nposBal2], aPort[nposBal2] , oBt_capBa2  , _cTipo)    },037,012,,,,.T.,,"",,,,.F. )
	oBt_grvBa2 := TButton():New( 069,276,"Gravar",oDlgPeso,{|| p_nPesoRet:= val(cGet_bal2), oDlgPeso:end()  },037,012,,,,.T.,,"",,,,.F. )
	
endif

nposBal3:= aScan( aChave, '03' )
if nposBal3 >0 //"Balanca3"
	oSay3      := TSay():New( 099,036,{||aDesc[nposbal3]},oDlgPeso,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
	oGet_Bal3  := TGet():New( 096,116,{|u| If(PCount()>0,cGet_Bal3:=u,cGet_Bal3)},oDlgPeso,075,015,'',,CLR_HBLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_Bal3",,)
	oGet_bal3:disable()
	oBt_capBa3 := TButton():New( 099,229,"Capturar",oDlgPeso,{||  cGet_Bal3:=u_getsmPeso(aIP[nposBal3], aPort[nposBal3] , oBt_capBa3 , _cTipo )    },037,012,,,,.T.,,"",,,,.F. )
	oBt_grvBa3 := TButton():New( 099,276,"Gravar",oDlgPeso,{|| p_nPesoRet:= val(cGet_Bal3), oDlgPeso:end()  },037,012,,,,.T.,,"",,,,.F. )	
endif

nposBal4:= aScan( aChave, '04' )
if nposBal4 >0 //"Balanca4"
	oSay4      := TSay():New( 128,036,{||aDesc[nposbal4]},oDlgPeso,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
	oGet_Bal4  := TGet():New( 125,116,{|u| If(PCount()>0,cGet_Bal4:=u,cGet_Bal4)},oDlgPeso,075,015,'',,CLR_HBLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_Bal4",,)
	oGet_bal4:disable()

	oBt_capBa4 := TButton():New( 128,229,"Capturar",oDlgPeso,{||cGet_Bal4:= u_getsmPeso(aIP[nposBal4], aPort[nposBal4] , oBt_capBa4 , _cTipo )   },037,012,,,,.T.,,"",,,,.F. )
	oBt_grvBa4 := TButton():New( 128,276,"Gravar",oDlgPeso,{|| p_nPesoRet:= val(cGet_Bal4), oDlgPeso:end()  },037,012,,,,.T.,,"",,,,.F. )
endif



oDlgPeso:Activate(,,,.T.)

Return                                              


//funcao para capturar o peso do aquivo .txt  gravado pelo software controlador das balancas
//
User Function getPSerial(p_cTipo,p_cPort)
	local _cDir:= getnewPar("MV_YBALDIR","c:\temp\")
   local _cArqEnt:= 'balent.txt'
   local _cArqSai:= 'balsai.txt'
   
	private nHdll := 0
	private cText := ''
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
	
	
	while .t.
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
		
	
Return _peso



Static Function fPesarSai(p_cOpcao, p_cTpOper, p_lCarrGranel)
	Local nPesoAux := 0
	Local aAreaAtu := GetArea()
	local cStatus:= p_cOpcao       
	local cTpOper := p_cTpOper
	local cNumero := iif(cTpOper=='C' , sc5->c5_num , sz1->z1_num )
	local wAlCab := iif(cTpOper=='C' , 'SC5' , 'SZ1' )
	local wAlDet := iif(cTpOper=='C' , 'SC6' , 'SZ1' )
	local lBalIP := .f.  // usa balança eternt - via ip
	local lusaLacres:= .f.

	

	// Grava o peso e status na SZ8
	lpesoOk:=.f.
	lyes:=.f.
	While  !lpesoOK
		nPesoAux := u_getPSerial("S") // chamar novamente a funcao para obter o peso da balanca
		
		lyes := MsgBox("Peso da Balança: "+TRANSFORM(nPesoAux,'@E 99,999.999')+" Confirma?","Peso Balança", "YESNO")
		if !lyes
			lpesoOK:=.f.
			exit
		endif
		
		//validação da margem de diferença de peso
		lpesoOK:=.t.
		
		if 1==2 //sz8->z8_tpoper == 'D'
			
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

	(wAlDet)->(dbsetorder(1))
	(wAlDet)->(dbseek( xfilial(wAlDet)+cnumero  ))
		
	if empty(nPesoAux)
		Alert('Nao e permitido prosseguir sem peso!')
	elseif lpesoOK
		
		
		//nPEntAnt:= sz8->z8_psent // grava o peso antes de altera-lo mais abaixo. para comparar se estava zerado
		
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
							                                                    
							//if sc6->c6_ypesliq > sc6->c6_qtdven
							   
								sc6->c6_yqtorig := sc6->c6_qtdven 
								sc6->c6_qtdven  := sc6->c6_ypesliq
								sc6->c6_qtdlib  := sc6->c6_ypesliq
							//else	
							//	sc6->c6_qtdlib := sc6->c6_ypesliq
							//endif       
							
							sc6->c6_valor:= sc6->c6_prcven * sc6->c6_qtdven							     
							sc6->c6_op := '06'
																		
							a410Refr("C6_QTDLIB")                                                       				
							
							
							sc6->(MsUnLock())
			            
							
							sc5->( RecLock("SC5",.F.) )				
							sc5->c5_liberok := 'S'
							sc5->c5_pesol   := npesliq
							sc5->c5_pbruto  := npesliq

							sc5->(MsUnLock())
								            
			            
			                              									
					EndIf			
						
			case cTpOper == 'D'			


					If sz1->z1_num == cnumero
						   
							m->z1_pesfin := nPesoAux
							m->z1_pesliq := sz1->z1_pesini - nPesoAux
							m->z1_horfin := time()
						
							sz1->( RecLock("SZ1",.F.) )
							
							sz1->z1_pesfin := m->z1_pesfin
							sz1->z1_pesliq := m->z1_pesliq
							sz1->z1_horfin := m->z1_horfin
							sz1->z1_usuario:= alltrim(substr(cusuario,7,15))							                                                    
							
							sz1->(MsUnLock())
			                              									
					EndIf			




		endcase
                                       
			
		//imprime tickt de balança
		u_smTICKET(cnumero,wAlCab)
		

	endif
	
	RestArea(aAreaAtu)
	
	oDlg2:End()
	
Return
