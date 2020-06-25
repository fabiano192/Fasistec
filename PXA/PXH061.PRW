#Include "PROTHEUS.CH"
#INCLUDE "font.CH"
//--------------------------------------------------------------
/*/{Protheus.doc} CadSenha
Description
                                                                
@param xParam Parameter Description                             
@return xRet Return Description
@author  - deniferrsilva@gmail.com Denilson Ferreira
@since 10/06/2010                                                   
/*/
//--------------------------------------------------------------
User Function CadSenha()
	Private oDlg
	Static oGet1
	Private cMotr :=  Space(6)
	Private oGet2
	Private cCodM :=  Space(30)
	Private oGet3
	Private cSenAt :=  Space(6)
	Private oGet5
	Private cSenN :=  Space(6)
	Private cSenAt2 :=  ""
	Private oGet6
	Private cSenC :=  Space(6)
	Private oGet7
	Private cFras :=  Space(60)
	Private oSay1
	Private oSay2
	Private oSay3
	Private oSay4
	Private oSay5
	Private oSay6
	Private oSay7
	Private oSay8
	Private oSay9
	Private oPrn    	:= NIL
	Static oFont1 := TFont():New("Tahoma",,018,,.T.,,,,,.F.,.F.)



	DEFINE MSDIALOG oDlg TITLE "CADASTRO DE SENHAS" FROM -053, 000  TO 370, 530 COLORS 0, 16777215 PIXEL

	@ 020, 005 SAY oSay2 PROMPT  "Codigo"  SIZE 029, 009  OF oDlg FONT oFont1 COLORS 0, 20777215 PIXEL
	@ 016, 070 MSGET oGet2 VAR cCodM F3 "SZ3"  valid xvalid(1)  SIZE 062, 010 OF oDlg COLORS 0, 20777215  PIXEL
	@ 050, 005 SAY oSay1 PROMPT "Motorista" SIZE 062, 009 OF oDlg FONT oFont1 COLORS 0, 20777215 PIXEL
	@ 046, 070 MSGET oGet1 VAR cMotr  when .f. SIZE 139, 010 OF oDlg COLORS 0, 13290186 PIXEL
	@ 080, 005 SAY oSay3 PROMPT "Senha Atual" SIZE 048, 010 OF oDlg FONT oFont1 COLORS 0, 20777215 PIXEL
	@ 076, 070 MSGET oGet3 VAR cSenAt when .f. SIZE 062, 010 OF oDlg COLORS 0, 13290186 PIXEL
	@ 110, 005 SAY oSay5 PROMPT "Nova Senha"   SIZE 048, 010 OF oDlg FONT oFont1 COLORS 0, 20777215 PIXEL
	@ 106, 070 MSGET oGet5 VAR cSenN  valid xvalid(2)  SIZE 062, 010 OF oDlg COLORS 0, 20777215 PIXEL Password
	@ 140, 005 SAY oSay6 PROMPT "Confirma Senha" SIZE 062, 010 OF oDlg FONT oFont1 COLORS 0, 20777215 PIXEL
	@ 136, 070 MSGET oGet6 VAR cSenC   valid xvalid(3) SIZE 062, 010 OF oDlg  COLORS 0, 20777215 PIXEL Password
	@ 170, 005 SAY oSay7 PROMPT "Frase pra Lembra" SIZE 062, 010 OF oDlg FONT oFont1 COLORS 0, 20777215 PIXEL
	@ 166, 070 MSGET oGet7 VAR cFras   SIZE 139, 010 OF oDlg COLORS 0, 20777215 PIXEL
	@ 110, 135 SAY oSay8 PROMPT " ( minino 3 e maximo 6 )" SIZE 060, 009 OF oDlg COLORS 255, 16777215 PIXEL
	@ 140, 135 SAY oSay9 PROMPT " ( minino 3 e maximo 6 )" SIZE 060, 009 OF oDlg COLORS 255, 16777215 PIXEL


	ACTIVATE MSDIALOG oDlg ON INIT  EnchoiceBar(oDlg,{||Grava(),oDlg:End()},{||oDlg:End()},) CENTERED

	Return


Static Function xValid( nType )
	Local  lReturn  := .f.
	aArea := GetArea()


	Do Case
	Case  ( nType == 1 )

		If  ( ! Empty(cCodM) )
     
			lReturn := .t.

			cMotr :=  Posicione('SZ3',1,xFilial("SZ3")+ALLTRIM(cCodM),"Z3_NOME")
			cSenAt2 := Posicione('SZ3',1,xFilial("SZ3")+ALLTRIM(cCodM),"Z3_SENHMOT")
		 
			If !empty(cSenAt2)
				cSenAt := "******"
			Else
				cSenAt :=  cSenAt2
			EndIf
			cFras := Posicione('SZ3',1,xFilial("SZ3")+ALLTRIM(cCodM),"Z3_FRASEMT")
			oGet1:Refresh()
			oGet3:Refresh()
			oGet7:Refresh()
   

		EndIf
	Case  ( nType == 2 )
		If  ( ! Empty(cSenN) )
			If  cSenAt <> cSenN
				lReturn := .t.
			Else
				MsgStop("Senha Igual a atual !","Aviso de Erro")
				lReturn:=.F.
			Endif
		EndIf
	Case  ( nType == 3 )
		If  ( ! Empty(cSenN) .and. Empty(cSenC) )
			MsgStop("Favor confirma Senha !","Aviso de Erro")
			lReturn := .f.
		ElseIf cSenN <> cSenC
			MsgStop("Não Confere com nova senha !","Aviso de Erro")
			lReturn := .f.
		Else
			lReturn := .t.
		EndIf

	End Case
	RestArea(aArea)
	Return lReturn


Static Function Grava()
	aArea := GetArea()
	DbSelectArea("SZ3")
	DbSetOrder(1)
	If SZ3->(DBSEEK(xFILIAL("SZ3")+Alltrim(cCodM)))

	
		SZ3->(RECLOCK("SZ3"))
		SZ3->Z3_SENHMOT := cSenN
		SZ3->Z3_FRASEMT := cFras
		SZ3->(MSUNLOCK())
		MsgStop("Senha Gravada Com Sucesso!","Aviso")
	EndIf

	RestArea(aArea)
	Return




// formulario para apresentação dos pesos das balanças.

User Function frmPesoBal(p_nPesoRet,p_cOrigem, p_cColeta)

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
	Private cGet_Bal5  := Space(1)
	Private cBarraStatus  := Space(1)
                                                              
	Private oFont1 := TFont():New("Arial",,018,,.T.,,,,,.F.,.F.)
	Private oFont2 := TFont():New("Arial",,026,,.T.,,,,,.F.,.F.) 
	Private oFont3 := TFont():New("Arial",,024,,.T.,,,,,.F.,.F.) 
	Private oFont4 := TFont():New("Courier New",,032,,.T.,,,,,.F.,.F.)
	private cColeta:=  "A"

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oDlgPeso","oBal1","oSay2","oSay3","oSay4","oSay5","oGet_bal1","oBtn_capBal1","oBtn_grvBal1","oBtn_grvBal2")
	SetPrvt("oGet_bal2","oGet_Bal4","oBtn_capBal4","oBtn_grvBal4","oBtn_grvBal3","oBtn_capBal3","oGet_Bal3","oBtn_grvBal5","oBtn_capBal5","oGet_Bal5","oBarraStatus")

               
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

	oDlgPeso      := MSDialog():New( 112,286,524,981,"Monitor de BALANÇAS",,,.F.,,,,,,.T.,,,.T. )
    
	oTitulo       := TSay():New( 010,085,{|| cTitulo },oDlgPeso,,oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,150,015)
	oBarraStatus  := TGet():New( 170,200,{|u| If(PCount()>0,oBarraStatus:=u,cBarraStatus)},oDlgPeso,150,010,'',,CLR_HBLUE,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cBarraStatus",,)
	oBarraStatus:disable()
	opesoManual   := TButton():New( 170,036,"Peso Manual",oDlgPeso,{|| cColeta:= U_PXH04501(@p_nPesoRet) , oDlgPeso:end()  },050,012,,,,.T.,,"",,,,.F. )
 
	nposBal1:= aScan( aChave, '01' )
	if nposBal1 >0 //"Balanca1"
		oBal1      := TSay():New( 041,036,{|| aDesc[nposbal1] },oDlgPeso,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
		oGet_bal1  := TGet():New( 038,116,{|u| If(PCount()>0,cGet_bal1:=u,cGet_bal1)}  ,oDlgPeso,075,015,'',,CLR_HBLUE,CLR_WHITE,oFont4,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_bal1",,)
		oGet_bal1:disable()
		bCaptura:= {|| cBarraStatus:= "Iniciando Conexão IP:  "+aIP[nposBal1]+"  Porta: "+aPort[nposBal1] , oBarraStatus:refresh(), cGet_bal1:=u_getsmPeso(aIP[nposBal1], aPort[nposBal1] , oBt_capBa1 , _cTipo)  }
		oBt_capBa1 := TButton():New( 041,229,"Capturar",oDlgPeso, bCaptura ,037,012,,,,.T.,,"",,,,.F. )
		oBt_grvBa1 := TButton():New( 041,276,"Gravar",oDlgPeso,{|| p_nPesoRet:= val(cGet_Bal1), oDlgPeso:end()  },037,012,,,,.T.,,"",,,,.F. )
	endif


	nposBal2:= aScan( aChave, '02' )
	if nposBal2 >0 //"Balanca2"
		oSay2      := TSay():New( 069,036,{||aDesc[nposbal2]},oDlgPeso,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
		oGet_bal2  := TGet():New( 066,116,{|u| If(PCount()>0,cGet_bal2:=u,cGet_bal2)},oDlgPeso,075,015,'',,CLR_HBLUE,CLR_WHITE,oFont4,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_bal2",,)
		oGet_bal2:disable()
		oBt_capBa2 := TButton():New( 069,229,"Capturar",oDlgPeso,{|| cGet_bal2:= u_getsmPeso(aIP[nposBal2], aPort[nposBal2] , oBt_capBa2  , _cTipo)    },037,012,,,,.T.,,"",,,,.F. )
		oBt_grvBa2 := TButton():New( 069,276,"Gravar",oDlgPeso,{|| p_nPesoRet:= val(cGet_bal2), oDlgPeso:end()  },037,012,,,,.T.,,"",,,,.F. )
	
	endif

	nposBal3:= aScan( aChave, '03' )
	if nposBal3 >0 //"Balanca3"
		oSay3      := TSay():New( 099,036,{||aDesc[nposbal3]},oDlgPeso,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
		oGet_Bal3  := TGet():New( 096,116,{|u| If(PCount()>0,cGet_Bal3:=u,cGet_Bal3)},oDlgPeso,075,015,'',,CLR_HBLUE,CLR_WHITE,oFont4,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_Bal3",,)
		oGet_bal3:disable()
		oBt_capBa3 := TButton():New( 099,229,"Capturar",oDlgPeso,{||  cGet_Bal3:=u_getsmPeso(aIP[nposBal3], aPort[nposBal3] , oBt_capBa3 , _cTipo )    },037,012,,,,.T.,,"",,,,.F. )
		oBt_grvBa3 := TButton():New( 099,276,"Gravar",oDlgPeso,{|| p_nPesoRet:= val(cGet_Bal3), oDlgPeso:end()  },037,012,,,,.T.,,"",,,,.F. )
	endif

	nposBal4:= aScan( aChave, '04' )
	if nposBal4 >0 //"Balanca4"
		oSay4      := TSay():New( 128,036,{||aDesc[nposbal4]},oDlgPeso,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
		oGet_Bal4  := TGet():New( 125,116,{|u| If(PCount()>0,cGet_Bal4:=u,cGet_Bal4)},oDlgPeso,075,015,'',,CLR_HBLUE,CLR_WHITE,oFont4,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_Bal4",,)
		oGet_bal4:disable()

		oBt_capBa4 := TButton():New( 128,229,"Capturar",oDlgPeso,{||cGet_Bal4:= u_getsmPeso(aIP[nposBal4], aPort[nposBal4] , oBt_capBa4 , _cTipo )   },037,012,,,,.T.,,"",,,,.F. )
		oBt_grvBa4 := TButton():New( 128,276,"Gravar",oDlgPeso,{|| p_nPesoRet:= val(cGet_Bal4), oDlgPeso:end()  },037,012,,,,.T.,,"",,,,.F. )
	endif
    
	nposBal5:= aScan( aChave, '05' )
	if nposBal5 >0 //"Balanca5"
		oSay5      := TSay():New( 157,036,{||aDesc[nposbal5]},oDlgPeso,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
		oGet_Bal5  := TGet():New( 154,116,{|u| If(PCount()>0,cGet_Bal5:=u,cGet_Bal5)},oDlgPeso,075,015,'',,CLR_HBLUE,CLR_WHITE,oFont4,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_Bal5",,)
		oGet_bal5:disable()

		oBt_capBa5 := TButton():New( 128,229,"Capturar",oDlgPeso,{||cGet_Bal5:= u_getsmPeso(aIP[nposBal5], aPort[nposBal5] , oBt_capBa5 , _cTipo )   },037,012,,,,.T.,,"",,,,.F. )
		oBt_grvBa5 := TButton():New( 128,276,"Gravar",oDlgPeso,{|| p_nPesoRet:= val(cGet_Bal5), oDlgPeso:end()  },037,012,,,,.T.,,"",,,,.F. )
	endif


	oDlgPeso:Activate(,,,.T.)

	Return (p_cColeta:= cColeta)



user function getsmPeso(p_cIP,p_cPort, p_oBtn, p_cTipo)
	local cRet:=""
     
	do case
	case cempant $ '20' // captura via IP - Ethernet
		If cFilAnt == "04"
			cret:=	str( u_getPSer(p_cTipo, p_cPort ) , 7 )
		Else
			cret:=	u_getPIP(p_cIP,p_cPort, p_oBtn)
		Endif
	case cempant $ '10|11|30' // captura via IP - Ethernet
		cret:=	U_GETPIP10(p_cIP,p_cPort, p_oBtn)
//      case cempant $ '01|10' // vai porta seiral 
//      	cret:=	str( u_getPSer(p_cTipo, p_cPort ) , 7 ) 
	case cempant $ '01' // vai porta seiral
		cret:=	str( u_getPSer(p_cTipo, p_cPort ) , 7 )
	endcase

	return cRet
           

user function getPIP(p_cIP,p_cPort, p_oBtn)
	local oObj := tSocketClient():New()
	local cRet:=""
   
	_ip:= alltrim(p_cIP)
	_port:= val(p_cPort)
	_timeout:=02
                                          
	p_oBtn:Disable()
	cBarraStatus:= 'Iniciando ... '

	nResp := oObj:Connect( _port, _ip, _timeout )
	if(nResp == 0 )
		cBarraStatus:= "Conexão OK!  IP:  "+_ip+"  Porta: "+str(_port,5)
		Conout( cBarraStatus )
	else
		cBarraStatus:= "Erro na Conexão! "
		Conout( cBarraStatusRet , nResp  )
		return (cRet:='0')
	endif
                      
	cBuffer := ""
	xAux:=""
	ncont:=1
	nQtd := oObj:Receive( @cBuffer, 10000 )
	if nQtd>0
		while nQtd > 0 .and. ncont < 16
			cBuffer := ""
			nQtd := oObj:Receive( @cBuffer, 10000 )
			xaux+= cbuffer
			ncont++
		    //conout( "fim Recebidos " + Str( nQtd, 4, 0 ), cbuffer )  
			conout(  cbuffer ) //+ ' ['+str(at( '+', xAux ), 3)+']')
		end
		
		cRet:=  substr( xAux, at( '+', xAux )+1, 7 )
             
	else
		cRet:='0'
	endif
	
	
	if empty(cret) .or. val( cret ) == 0 .or. len(cret) < 7 .or. 'k' $ cRet
		cRet := '0'
	endif
	
	
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
	conout( cBarraStatus )
	
	p_oBtn:enable()
    
	return  cRet
            

User function GETPIP10(p_cIP,p_cPort, p_oBtn)

	local oObj := tSocketClient():New()
	local cRet:=""

/*   
_ip:= alltrim(p_cIP)
_port:= val(p_cPort)
_timeout:=02

p_oBtn:Disable()
cBarraStatus:= 'Iniciando ... '

nResp := oObj:Connect( _port, _ip, _timeout ) 
If(nResp == 0 )
   cBarraStatus:= "Conexão OK!  IP:  "+_ip+"  Porta: "+str(_port,5)
   Conout( cBarraStatus )
Else    
    cBarraStatus:= "Erro na Conexão! "
    Conout( cBarraStatusRet , nResp  )
    return (cRet:='0')
endif

cBuffer := ""		
xAux:=""
ncont:=1  
nQtd := oObj:Receive( @cBuffer, 10000 )       
*/
	If cEmpAnt$ '11|30'
                                         
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
			cBuffer := ""
	
			If nQtd > 0
				nQtd   := oObj:Receive( @cBuffer, 10000 )
				_cPeso := ""
				_cPesoA:= ""
				_lCont := .F.

				_cPeso := ""
				For Ax:= 1 To Len(cbuffer)
					_cPesoA := Substr(cbuffer,AX,1)
		    	
					If _cPesoA == Space(01) .Or. _lCont
						_cPeso += Alltrim(_cPesoA)
						_lCont := .T.
					Endif
		    	
					If Len(_cPeso) == 6
						AX:= Len(cbuffer)
						_lSair := .T.
					Endif
				Next AX
		    
				ncont++
	    	
				cRet:=  _cPeso

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
	Else
		_ip:= alltrim(p_cIP)
		_port:= val(p_cPort)
		_timeout:=02
                                       
		p_oBtn:Disable()
		cBarraStatus:= 'Iniciando ... '

		nResp := oObj:Connect( _port, _ip, _timeout )
		If(nResp == 0 )
			cBarraStatus:= "Conexão OK!  IP:  "+_ip+"  Porta: "+str(_port,5)
			Conout( cBarraStatus )
		Else
			cBarraStatus:= "Erro na Conexão! "
			Conout( cBarraStatusRet , nResp  )
			return (cRet:='0')
		endif
	
		cBuffer := ""
		xAux:=""
		ncont:=1
		nQtd := oObj:Receive( @cBuffer, 10000 )
	
		if nQtd>0
			while nQtd > 0 .and. ncont < 16
				cBuffer := ""                  
				nQtd := oObj:Receive( @cBuffer, 10000 )
	//	    xaux+= cbuffer
				xaux:= cbuffer
				ncont++
				conout(  cbuffer ) //+ ' ['+str(at( '+', xAux ), 3)+']')
			EndDo
	
		//	cRet:=  substr( xAux, at( '+', xAux )+1, 7 )
			cRet:=  substr(xAux,6, 5 )
		else
			cRet:='0'
		endif
	Endif

	if empty(cret) .or. val( cret ) == 0 //.or. len(cret) < 7 .or. 'k' $ cRet
		cRet := '0'
	endif

	If cEmpAnt != "30"
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

		conout( cBarraStatus )
	Endif
	
	p_oBtn:enable()
    
	Return  cRet




 
User Function PXH06101(p_cOrigem,p_cOpcao)
		local nRandom:=0
		local lcontinua:=.t.
		local lret:=.f.
		Local cUserSMS     := Alltrim(GETNEWPAR("MV_USRSMS","60674")) // Parametro que armazena o login do usuario na contratação do serviço de sms     *** Declração das variavel para o envio de SMS***  Richardson Martins- Semar Sistema - 11/06/24
		Local cPswSms      := Alltrim(GETNEWPAR("MV_PSWSMS","mzsms2014")) //"mizu.674" Parametro que armazena a senha do usuario na contratação do serviço de sms
		Local cAcesso	   := Alltrim(GETNEWPAR("MV_CHVSMS","bbe6691b-101f-46d6-a20a-a2db1d24ca78")) // Parametro que aramzena a chave de acesso para integração
		Local cCel         := Alltrim(GETNEWPAR("MV_YTELIB","027999496210")) //027999496210
		Local cEspaco      := "%20"
		Local cTexto       := ""
		Local cPostUrl     := ""
		Local cRemet       := "Mizu-BA"
		Local dData        :=  DATE()//GETNEWPAR("MV_DATSMS",dDatabase)
		Local cOrigem      := iif(p_cOrigem==nil,"",p_cOrigem)    
		Local cOpcao	   := iif(p_cOpcao==nil ,"",p_cOpcao)
		Local wArea        := getArea()
		Local cTime        := TIME()
		Local cHora        := SUBSTR(cTime, 1, 2)
		LOcal cMinutos     := SUBSTR(cTime, 4, 2)
		local wTexto       := ''
		
		
		if cOrigem =='CANCELAENTRADA'
			wTexto       := "PESO MANUAL - Senha de liberacao: "   
		else    
			wTexto       := "CANCELAR ENTRADA - Senha de liberacao: "   
		endif	
		
		Private cHeaderRet := ""
		Private oDlg
		Private oGet5
		Private cSenN :=  Space(6)
		Private oSay5
		Private oPrn    	:= NIL
		Static oFont1 := TFont():New("Tahoma",,018,,.T.,,,,,.F.,.F.)
        Static oFont2 := TFont():New("Tahoma",,015,,.T.,,,,,.F.,.F.)
	   
		nRandom:=  randomize(1,9999) 
		if Empty(cOpcao); return lret; endif
			                                
		do case
			case cOpcao == "SMS"
				/*Depois que o código foi gerado vai ser transmitido a senha de liberação.  Richardson Martins - Semar  11/06/14
				 Pega a senha*/ 
			    cTexto := wTexto +cValToChar(nRandom)    
				cTexto := cValToChar(STRTRAN(cTexto," ",cEspaco))
				cPostUrl 	:= "https://sms.comtele.com.br/api/"+cAcesso+"/sendmessage?sender="+cRemet+"&receivers="+cCel+"&content="+Alltrim(cTexto) 
		        cHtmlPage 	:= HttpPost(cPostUrl,,,,,@cHeaderRet) 
		  
		   case cOpcao == "Email"    
		   		cTexto := wTexto +cValToChar(nRandom)  
		   		if !EnviaEmail(cTexto)		    
		           return .F.
		     	endif
		     	
		endcase
		
			while lcontinua
		//nRandom:=  randomize(1,9999)	
       
                                                                                                                                                               
		DEFINE MSDIALOG oDlg TITLE "LIBERACAO POR SENHAS" FROM 053, 000  TO 150, 400 COLORS 0, 16777215 PIXEL
	 
		@ 05, 40 SAY oSay5 PROMPT "Senha:"   SIZE 048, 010 OF oDlg FONT oFont1 COLORS 0, 20777215 PIXEL
		@ 05, 72 MSGET oGet5 VAR cSenN    SIZE 052, 010 OF oDlg COLORS 0, 20777215 PIXEL 
		//@ 25, 105 SAY oSay8 PROMPT " Codigo: "+ str(nRandom,6) SIZE 060, 009 OF oDlg COLORS 255, 16777215 PIXEL   //RICHARSDSON MARTINS- SEMAR 10/06/14	
		@ 25, 30 SAY oSay8 PROMPT "Mensagem enviada em "+(dtoc(dDAta))+" - "+cHora+":"+cMinutos SIZE 200, 000 OF oDlg FONT oFont2 COLORS 255, 16777215 PIXEL
	    
		ACTIVATE MSDIALOG oDlg ON INIT  EnchoiceBar(oDlg,{||lret:=vldSen(cSenN,nrandom,p_cOrigem),iif(lret,lcontinua:=.f.,lcontinua:=.t.),oDlg:End()},{||lret:=.f.,lcontinua:=.f.,oDlg:End()},) CENTERED
                
	end
	Return lret

Static function vldSen(p_senha,p_nRandom,p_cOrigem)

   	Local lRet      := .F.
   	local nhora     := iif( val( left(  time() , 2 ) ) == 0, 24 , val( left(  time() , 2 ) ) )
   	Local cUserAtu  := PswRet(1)[1,1]		// Guarda o usuario atual
   	Local cPswFile  := "sigapss.spf"
   	Local cPswId 	 := ""
	Local cPswName  := ""
	Local cPswPwd 	 := ""
	Local cPswDet 	 := ""
	Local lEncrypt  := .F.
	Local nPswRec   := 0
/*	
nSenha          := val( p_senha )
nContraSenha    := p_nRandom *  nhora

//_cSenha     := Substr(Alltrim(p_senha),1,Len(Alltrim(p_senha))-2) 
_cSenha     := p_senha

nPswRec := SPF_Seek( cPswFile , "1U" + cUserAtu , 1 )
If nPswRec > 0   
	Spf_GetFields( @cPswFile , @nPswRec , @cPswId , @cPswName , @cPswPwd , @cPswDet )
	cPswPwd := PswEncript( Alltrim( cPswPwd ) , 1 )
	cPswPwd	:= Substr( cPswPwd, 1, At( Space(1) , cPswPwd ) -1 )
Endif   

nContraSenha := cPswPwd + StrZero(Day(Date()),2)

If p_cOrigem=='PESOMANUAL'
	nContraSenha:= p_nRandom *  (nhora	+ 1)
Endif
	
lRet:= nSenha == nContraSenha	 
//lRet:= _cSenha == nContraSenha	
*/
     
    // validação alterado para o envio do código via SMS, sem a realização do calculo para a digitação da senha. //Richardson Martins - Semar 12/06/14
   	nSenha:= val( p_senha )           
	nContraSenha:= p_nRandom //*  nhora
	
	if p_cOrigem=='PESOMANUAL'
		nContraSenha:= p_nRandom //*  (nhora	+ 1)
	endif
	

	lRet:= nSenha == nContraSenha 


   	If !lRet
		help("",1,"ERR_SENHA")
	Endif

	Return lret
                            
Static function EnviaEmail(p_cMsg)

	Local cServer		:= SuperGetMV("MV_RELSERV",,"smtp.terra.com.br:587")
	Local cUser			:= SuperGetMV("MV_RELACNT",,"mizu@terra.com.br")
	Local cPsw			:= SuperGetMV("MV_RELPSW",,"f6r9j9")
	Local nPort			:= 56
	Local cEmail		:= GetMV("MV_SMCSML",,"rodrigofeitosa@outlook.com") 
	Local cMsg			:= if(p_cMsg==nil,'',p_cMsg) 
	Local lJob			:= .F.
	
	if EMPTY(cEmail)
		if(!lJob,Alert("Favor preencher o email que deverá receber o arquivo!"),;
			ConOut("Favor preencher o email que deverá receber o arquivo!"))
		return .f.
	endif
	
	if At(":",cServer) > 0
		nPort := val(substr(cServer,At(":",cServer)+1))
		cServer := substr(cServer,1,At(":",cServer)-1)
	endif
	
	oServer := TMailManager():New()
	oServer:Init("",cServer,cUser,cPsw,0,nPort)
	oServer:SetUseSSL(.T.)
	
	if oServer:SetSmtpTimeOut( 60 ) != 0
		if(!lJob,Alert( "Falha ao setar o time out" ),ConOut("Falha ao setar o time out"))
		return .f.
	endif
	
	If oServer:SmtpConnect() != 0
		if(!lJob,Alert( "Falha ao conectar" ),ConOut( "Falha ao conectar" ))
		return .f.
	endif
	
	xRet := oServer:SmtpAuth(cUser,cPsw)
 	if xRet <> 0
    	cMsg := "Could not authenticate on SMTP server: " + oServer:GetErrorString( xRet )
    	if(!lJob,Alert(cMsg),ConOut(cMsg))
    	oServer:SMTPDisconnect()
    	return
  	endif
	
	oMessage := TMailMessage():New()
	oMessage:Clear()
	
	oMessage:cFrom		:= "mizu@terra.com.br"
	oMessage:cTo		:= cEmail
	oMessage:cSubject	:= "Liberação do peso manual "+FWEmpName(cEmpAnt)+" "+DTOC(dDataBase)
	oMessage:cBody		:= "Senha: "+cMsg 

	xRet := oMessage:Send( oServer )
	if xRet != 0
		if(!lJob,Alert("Falha ao enviar o e-mail / " + oServer:GetErrorString( xRet )),;
				ConOut("Falha ao enviar o e-mail / " + oServer:GetErrorString( xRet )))
		return .f.
	endif
	
	if oServer:SmtpDisconnect() != 0
		if(!lJob,Alert("Erro ao disconectar do servidor SMTP"),;
				ConOut("Erro ao disconectar do servidor SMTP"))
		return .f.
	endif

return .t.

User Function FnSenhaPeso(wOpcao)

Local _senha    := space(10)
Local lRet      := .F.

DEFINE MSDIALOG oDlg2 TITLE "Senha" FROM 40,50 TO 100,300 PIXEL
@ 08,10 say "Senha:"
@ 08,35 get _senha PassWord
@ 14,100 BmpButton Type 1 Action Close(oDlg2)
Activate MsDialog oDlg2 Centered

wPsw:=""
Do Case
	Case wOpcao $ 'OC*SAIDA' // Ordem de Carregamento
		wPsw:= GetNewPar("PXH_SENCAR",GetMV("PXH_SENHA"))
EndCase
lRet:= (AllTrim(_senha) == AllTrim(wPsw))
If !lRet
	help("",1,"Y_PXH061")
	Return .F.
End        

Return lRet