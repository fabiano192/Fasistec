#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE 	_wEnter_	chr(13)+chr(10)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ PXH054                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Conexão com o PLC por TCP/IP                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
u_SMFATF64()
/*/

User function PXH054(p_comando)

local oObj    := tSocketClient():New()
local cRec    := ""
local cIP     := GETNEWPAR("MV_SMPLCIP","192.168.0.102")
local nPort   := GETNEWPAR("MV_SMPLCPT",5000)
local ntimeout:= 02
local _wEnter := chr(10)+chr(13)

if !u_SMGETACCESS(funname(),.f.); return; endif

cMens:=""
nResp:=0
if nResp:= oObj:Connect(nPort,cIP,ntimeout) <> 0
	cMens:= "Conexão OK!  IP:  "+cIP+"  Porta: "+str(nPort,5)
	Conout( cMens )
	Alert(cMens)
	return nResp
endif


nResp := oObj:Send( p_comando + _wEnter )


nQtd:=0
ncont:=0
cMens:=''
while nQtd > 0 .and. ncont < 10
	cBuffer := ""
	nQtd := oObj:Receive( @cBuffer, 10000 )
	cMens+= cbuffer
	ncont++
end
Conout( "Recebido: "+cMens )
alert( "Recebido: "+cMens )

oObj:CloseConnection()
Conout( "Conexcao encerrada! " )


return


user function smConect(p_nConexao)
local lautom:=.T.
local nCon1:= p_nConexao
local wBanco:="MSSQL/SIGEX"
local wServidor:= "10.1.1.1" //"MIZUSP"
local xRetorno


do case
	case nCon1 <0 // conectar
		//	TCSetConn(0)
		ltentar:=.t.
		while ltentar
			caux:= "Conectando com BANCO:  "+wBanco+" em SERVIDOR:  "+wServidor+"  ..."
			iif( !lautom , Alert(caux) , conout( caux )	)
			
			nCon1 := TCLink(wBanco,wServidor) //nCon1 := TCLink("MSSQL/SIGEX1","MIZUSP")
			if nCon1>0; exit; endif
			//UserException("Erro ("+str(nCon1,4)+") ao conectar com "+wBanco+" em "+wServidor)
			ltentar:= MsgBox("Erro ("+str(nCon1,4)+") ao conectar com BANCO:  "+wBanco+" em SERVIDOR: "+wServidor+" . Tentar mais uma vez ?","Acesso SIGEX", "YESNO")
		end
		TCSetConn(nCon1)
		
		xRetorno := nCon1
		
	case nCon1 > 0 // desconectar
		
		xRetorno := TCUnLink(nCon1)
		
		if !xRetorno
			caux:= "Nao foi possivel Desconectando com BANCO:  "+wBanco+" em SERVIDOR:  "+wServidor+"  ..."
		else
			caux:= "Desconectando com BANCO:  "+wBanco+" em SERVIDOR:  "+wServidor+"  ..."
		endif
		iif( !lautom , Alert(caux) , conout( caux )	)
		//TCSetConn(0)
endcase


Return (xRetorno)




User Function PXH05401(p_nPesoRet,p_cOrigem, p_cColeta)

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
private cColeta:=  "A"

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgPeso","oBal1","oSay2","oSay3","oSay4","oGet_bal1","oBtn_capBal1","oBtn_grvBal1","oBtn_grvBal2")
SetPrvt("oGet_bal2","oGet_Bal4","oBtn_capBal4","oBtn_grvBal4","oBtn_grvBal3","oBtn_capBal3","oGet_Bal3","oBarraStatus")

aChave := {}
aDesc  := {}
aIP    := {}
aPort  := {}
aModelo:= {}

sx5->(dbsetorder(1))
if sx5->(dbseek( xfilial('SX5') + 'BL' ))
	while !sx5->(eof()) .and. sx5->x5_tabela == 'BL'
		
		aAdd( aChave 	, alltrim(sx5->x5_chave) )
		aAdd( aDesc  	, alltrim(sx5->x5_descri) )
		aAdd( aIP 	 	, sx5->x5_desceng )
		
		xAux:=alltrim(sx5->x5_descspa)
		aAdd( aPort    	, left( xAux ,  at('#', xAux )-1 ) )
		aAdd( aModelo  	, substr( xAux ,  at('#', xAux )+1 , len(xAux) ) )
		
		sx5->(dbskip())
		
	EndDo
else
	alert('Atencao:   Tabela auxiliar  (BL) nao localizada na SX5 !')
	return
endif

ctitulo       := ""
ctitulo       := iif( p_cOrigem == "SAIDA", "Pesagem  -  S A I D A", "Pesagem - E N T R A D A" )
_cTipo        := iif( p_cOrigem == "SAIDA", "S", "E" )
oDlgPeso      := MSDialog():New( 112,286,484,981,"Monitor de BALANÇAS",,,.F.,,,,,,.T.,,,.T. )
oTitulo       := TSay():New( 010,085,{|| cTitulo },oDlgPeso,,oFont3,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,150,015)
oBarraStatus  := TGet():New( 170,200,{|u| If(PCount()>0,oBarraStatus:=u,cBarraStatus)},oDlgPeso,150,010,'',,CLR_HBLUE,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cBarraStatus",,)
oBarraStatus:disable()
opesoManual   := TButton():New( 170,036,"Peso Manual",oDlgPeso,{|| cColeta:= U_PXH04501(@p_nPesoRet) , oDlgPeso:end()  },050,012,,,,.T.,,"",,,,.F. )

nposBal1:= aScan( aChave, '01' )
if nposBal1 >0 //"Balanca1"
	oBal1      := TSay():New( 041,036,{|| aDesc[nposbal1] },oDlgPeso,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
	oGet_bal1  := TGet():New( 038,116,{|u| If(PCount()>0,cGet_bal1:=u,cGet_bal1)}  ,oDlgPeso,075,015,'',,CLR_HBLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_bal1",,)
	oGet_bal1:disable()
	oBt_capBa1 := TButton():New( 041,229,"Capturar",oDlgPeso,{|| cGet_bal1:= u_PXH05402(aIP[nposBal1], aPort[nposBal1] , aModelo[nposBal1] , oBt_capBa1  , _cTipo)    } ,037,012,,,,.T.,,"",,,,.F. )
	oBt_grvBa1 := TButton():New( 041,276,"Gravar",oDlgPeso,{|| p_nPesoRet:= val(cGet_Bal1), oDlgPeso:end()  },037,012,,,,.T.,,"",,,,.F. )
endif

nposBal2:= aScan( aChave, '02' )
if nposBal2 >0 //"Balanca2"
	oSay2      := TSay():New( 069,036,{||aDesc[nposbal2]},oDlgPeso,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
	oGet_bal2  := TGet():New( 066,116,{|u| If(PCount()>0,cGet_bal2:=u,cGet_bal2)},oDlgPeso,075,015,'',,CLR_HBLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_bal2",,)
	oGet_bal2:disable()
	oBt_capBa2 := TButton():New( 069,229,"Capturar",oDlgPeso,{|| cGet_bal2:= u_PXH05402(aIP[nposBal2], aPort[nposBal2] , aModelo[nposBal2] ,  oBt_capBa2  , _cTipo)    },037,012,,,,.T.,,"",,,,.F. )
	oBt_grvBa2 := TButton():New( 069,276,"Gravar",oDlgPeso,{|| p_nPesoRet:= val(cGet_bal2), oDlgPeso:end()  },037,012,,,,.T.,,"",,,,.F. )
	
endif

nposBal3:= aScan( aChave, '03' )
if nposBal3 >0 //"Balanca3"
	oSay3      := TSay():New( 099,036,{||aDesc[nposbal3]},oDlgPeso,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
	oGet_Bal3  := TGet():New( 096,116,{|u| If(PCount()>0,cGet_Bal3:=u,cGet_Bal3)},oDlgPeso,075,015,'',,CLR_HBLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_Bal3",,)
	oGet_bal3:disable()
	oBt_capBa3 := TButton():New( 099,229,"Capturar",oDlgPeso,{||  cGet_Bal3:= u_PXH05402(aIP[nposBal3], aPort[nposBal3] , aModelo[nposBal3] ,  oBt_capBa3 , _cTipo )    },037,012,,,,.T.,,"",,,,.F. )
	oBt_grvBa3 := TButton():New( 099,276,"Gravar",oDlgPeso,{|| p_nPesoRet:= val(cGet_Bal3), oDlgPeso:end()  },037,012,,,,.T.,,"",,,,.F. )
endif

nposBal4:= aScan( aChave, '04' )
if nposBal4 >0 //"Balanca4"
	oSay4      := TSay():New( 128,036,{||aDesc[nposbal4]},oDlgPeso,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
	oGet_Bal4  := TGet():New( 125,116,{|u| If(PCount()>0,cGet_Bal4:=u,cGet_Bal4)},oDlgPeso,075,015,'',,CLR_HBLUE,CLR_WHITE,oFont2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet_Bal4",,)
	oGet_bal4:disable()
	
	oBt_capBa4 := TButton():New( 128,229,"Capturar",oDlgPeso,{||cGet_Bal4:= u_PXH05402(aIP[nposBal4], aPort[nposBal4] , aModelo[nposBal4] ,  oBt_capBa4 , _cTipo )   },037,012,,,,.T.,,"",,,,.F. )
	oBt_grvBa4 := TButton():New( 128,276,"Gravar",oDlgPeso,{|| p_nPesoRet:= val(cGet_Bal4), oDlgPeso:end()  },037,012,,,,.T.,,"",,,,.F. )
endif

oDlgPeso:Activate(,,,.T.)

Return (p_cColeta:= cColeta)



User function PXH05402(p_cIP,p_cPort, p_cModelo, p_oBtn, p_cTipo)

local cRet        := ""
local wSER_EmpFil := '0101|2004'
local wIP_EmpFil  := '2001|1001|1101|3001'

do case
	case cempant+cfilant $ wSER_EmpFil // captura via SERIAL
		cret:=	str( u_PXH04502(p_cTipo, p_cPort ) , 7 )
	case cempant+cfilant $ wIP_EmpFil  // captura via IP - Ethernet
		cret:=	u_PXH05403(p_cIp, p_cPort, p_cModelo, p_oBtn, p_cTipo)
endcase

return cRet


User function PXH05403(p_cIP,p_cPort,p_cModelo,p_oBtn,p_cTipo,p_lAutom)

local oObj      := tSocketClient():New()
local cRec      := ""
local cIP       := iif( p_cIP==nil, "10.1.2.51" ,cValtoChar(ALLTRIM(p_cIP)) )
local nPort     := iif( p_cPort==nil, 8881 , VAL(p_cPort) )
local cTipo     := iif( p_cTipo==nil, "E" , ALLTRIM(p_cTipo))
local lAutom    := iif( p_lAutom==nil, .f. , p_lAutom )
Local oBtn      := iif( p_oBtn==nil, nil , p_oBtn )
local ntimeout  := 10000
local nVezes    := 3
local nTry      := 1
local nRespse
xAux:=   'CONECTANDO ... IP: '+cIP+"  Porta: "+str(nPort,5)
//iif(lAutom,conout(xAux),LjMsgRun(xAux)

//nResp:= oObj:Connect(nPort,cIP,ntimeout)
nResp:=-1
nTry:=1
while nTry < 5  .and. nResp<>0
	cBarraStatus := xAux+ " Tentativa nr. ["+cValtoChar(nTry)+"]"
	iif(lAutom,conout(cBarraStatus),LjMsgRun(cBarraStatus))
	nResp:= oObj:Connect(nPort,cIP,ntimeout)
	nTry+=1
end

if nResp == 0
	// iif(lAutom,conout("Conexão OK!  IP:  "+cIP+"  Porta: "+str(nPort,5) ),LjMsgRun("Conexão OK!  IP:  "+cIP+"  Porta: "+str(nPort,5) ))
else
	iif(lAutom,conout('Erro '+str(nResp)+' - ABORTAR ...'),Alert('Erro '+str(nResp)+' - ABORTAR!!! '))
	return
endif

cBuffer := space(50)
nTentar:=1
nQtd := 0
cRet := "IP-Erro"
while nQtd==0 .and. ntentar < 5
	//cBarraStatus:="A-Lendo IP:  "+cIP+"  Porta: "+str(nPort,5)+ " Tentativa "+str(ntentar)
	//iif(lAutom,conout(cBarraStatus),LjMsgRun(cBarraStatus))
	
	
	cBuffer := space(50)
	sleep(500)
	nQtd := oObj:Receive(cBuffer,0 )  //10000)
	if nQtd <> 0
		while nQtd < 20 .And. nTry < 5
			sleep(1000)
			//cBarraStatus := "Tentando capturar informações da balança. ["+cValtoChar(nTry)+"]"
			//iif(lAutom,conout(cBarraStatus),LjMsgRun(cBarraStatus))
			nQtd := oObj:Receive( @cBuffer, ntimeout )
			nTry+=1
		end
		if nQtd < 20
			cBarraStatus := "Não foi possivel capturar toda informação da balança."
			iif(lAutom,conout(cBarraStatus),LjMsgRun(cBarraStatus))
			cBuffer := " "
		endif
		
		if Empty(cBuffer);return('0');endif
		
		do case
			case p_cModelo == 'TOLEDO'
				cBarraStatus := "Peso capturado com sucesso."
				iif(lAutom,conout(cBarraStatus),LjMsgRun(cBarraStatus))
				cRet:=  substr( cBuffer, at( 'q', cBuffer )+3, 6 )
			case p_cModelo == 'IND780'
				cRet:= SMFATF74(oObj,lAutom)
		endcase
	endif
	ntentar++
end


oObj:CloseConnection()

if !oObj:IsConnected()
	iif(lAutom,conout('Conexao FECHADA!'),LjMsgRun('Conexao FECHADA!'))
else
	iif(lAutom,conout('Conexao AINDA ABERTA!'),LjMsgRun('Conexao AINDA ABERTA!'))
endif

iif(oBtn=nil,,oBtn:enable())

return cRet


Static function SMFATF74(p_oObj,p_lAutom)

Local lAutom := p_lAutom
Local oObj := p_oObj
Local cComando  := "USER "
Local cComando2 := "r wt0101 "
Local nVezes := 5
Local ntimeout := 0

//cBarraStatus := 'Enviando comando'
//iif(lAutom,conout(cBarraStatus),LjMsgRun(cBarraStatus))
nResp := oObj:Send( cComando + CRLF )
nTentar:=1
nQtd := 1
while nQtd <>0
	cBuffer := space(50)
	sleep(500)
	//cBarraStatus:="Lendo a porta pela "+cValtoChar(nTentar)+" vez."
	//iif(lAutom,conout(cBarraStatus),LjMsgRun(cBarraStatus))
	nQtd := oObj:Receive( @cBuffer, ntimeout )
	cBuffer := substr( cBuffer, at( '1', cBuffer ), 12)
	if cBuffer <> "12 Access OK"
		Alert("Comando enviado a balança é invalido.")
		return "0"
	endif
	//cBarraStatus:="Informações capturadas com sucesso."
	//iif(lAutom,conout(cBarraStatus),LjMsgRun(cBarraStatus))
	if  nTentar > nVezes  .or. nqtd >0
		if cBuffer <> "12 Access OK"
			cBarraStatus:= "Comando enviado a balança é invalido."
			iif(lAutom,conout(cBarraStatus),LjMsgRun(cBarraStatus))
			return "0"
		endif
		exit
	endif
	sleep(1000)
	ntentar++
end

//cBarraStatus := 'Enviando 2º comando'
//iif(lAutom,conout(cBarraStatus),LjMsgRun(cBarraStatus))
nResp := oObj:Send( cComando2 + CRLF )
nTentar:=1
nQtd := 1
while nQtd<>0
	cBuffer := space(50)
	sleep(500)
	//cBarraStatus:="Lendo a porta pela "+cValtoChar(nTentar)+" vez."
	//iif(lAutom,conout(cBarraStatus),LjMsgRun(cBarraStatus))
	nQtd := oObj:Receive( @cBuffer, ntimeout )
	cBarraStatus:="Peso capturado com sucesso!"
	iif(lAutom,conout(cBarraStatus),LjMsgRun(cBarraStatus))
	m->m4_descr:= alltrim(cBarraStatus)
	if  nTentar > nVezes .or. nQtd>0
		exit
	endif
	sleep(1000)
	ntentar++
end

iif(val(substr(cBuffer,17,5))=0,cRet := "0",cRet := "0"+substr(cBuffer,17,5))

return cRet


User function conPLC(p_cIP,p_cPort,p_cTipo,p_cRele,p_lAutom)

local oObj  := tSocketClient():New()
local cIP   := iif( p_cIP==nil, "10.1.2.56" ,cValtoChar(ALLTRIM(p_cIP)) )
local cTipo := iif( p_cTipo==nil, "L" , p_cTipo )
local nPort := iif( p_cPort==nil, 5000 , VAL(p_cPort) )
local lAutom := iif( p_lAutom==nil, .t. , p_lAutom )
local nResp := ""
local ntimeout:= 10000
local nVezes := 3
local nTry := 1
local cComando := iif(cTipo="L","SET "+alltrim(p_cRele),"RESET "+alltrim(p_cRele))
local lRet := .F.
Local nLog := 4
Local wArea := getArea()

cMens:=""
nResp:=0

xAux:=   'CONECTANDO ... IP: '+cIP+"  Porta: "+str(nPort,5)

nResp:=-1
nTry:=1
while nTry < 5  .and. nResp<>0
	cBarraStatus := xAux+ " Tentativa nr. ["+cValtoChar(nTry)+"]"
	iif(lAutom,conout(cBarraStatus),LjMsgRun(cBarraStatus))
	nResp:= oObj:Connect(nPort,cIP,ntimeout)
	nTry+=1
end

if nResp == 0
	// iif(lAutom,conout("Conexão OK!  IP:  "+cIP+"  Porta: "+str(nPort,5) ),LjMsgRun("Conexão OK!  IP:  "+cIP+"  Porta: "+str(nPort,5) ))
else
	iif(lAutom,conout('Erro '+str(nResp)+' - ABORTAR ...'),Alert('Erro '+str(nResp)+' - ABORTAR!!! '))
	U_GRVLOGSX(FunName(),7,"[PLC]")
	RestArea(wArea)
	return lRet
endif

cBuffer := space(50)
nTentar:=1
nQtd := 0
cRet := "IP-Erro"

while nQtd==0 .and. ntentar < 5
	//cBarraStatus:="A-Lendo IP:  "+cIP+"  Porta: "+str(nPort,5)+ " Tentativa "+str(ntentar)
	//iif(lAutom,conout(cBarraStatus),LjMsgRun(cBarraStatus))
	
	cBuffer := space(50)
	sleep(500)
	nQtd := oObj:Receive(cBuffer,0 )  //10000)
	if nQtd <> 0
		while nQtd < 20 .And. nTry < 5
			sleep(1000)
			//cBarraStatus := "Tentando capturar informações da balança. ["+cValtoChar(nTry)+"]"
			//iif(lAutom,conout(cBarraStatus),LjMsgRun(cBarraStatus))
			nQtd := oObj:Receive( @cBuffer, ntimeout )
			nTry+=1
		end
		if nQtd < 20
			cBarraStatus := "Não foi possivel capturar toda informação do PLC."
			iif(lAutom,conout(cBarraStatus),LjMsgRun(cBarraStatus))
			cBuffer := " "
		endif
		
		if Empty(cBuffer)
			U_GRVLOGSX(FunName(),8,"[PLC]")
			RestArea(wArea)
			return lRet
		endif
		
		nResp := oObj:Send( cComando + CRLF )
		nTentar:=1
		nQtd := 1
		while nQtd <>0
			cBuffer := space(50)
			//cBarraStatus:="Lendo a porta pela "+cValtoChar(nTentar)+" vez."
			//iif(lAutom,conout(cBarraStatus),LjMsgRun(cBarraStatus))
			sleep(500)
			nQtd := oObj:Receive( @cBuffer, ntimeout )
			cBuffer := substr( cBuffer, at( '2', cBuffer ), 6)
			if cBuffer <> "210 OK"
				Alert("Comando enviado ao PLC é invalido.")
				U_GRVLOGSX(FunName(),9,"[PLC]")
				RestArea(wArea)
				return lRet
			endif
			//cBarraStatus:="Informações capturadas com sucesso."
			//iif(lAutom,conout(cBarraStatus),LjMsgRun(cBarraStatus))
			if  nTentar > nVezes  .or. nqtd >0
				if cBuffer <> "210 OK"
					cBarraStatus:= "Comando enviado ao PLC é invalido."
					U_GRVLOGSX(FunName(),9,"[PLC]")
					iif(lAutom,conout(cBarraStatus),LjMsgRun(cBarraStatus))
					RestArea(wArea)
					return lRet
				endif
				exit
			endif
			sleep(1000)
			ntentar++
		end
		lRet := .T.
		cBarraStatus := "Comando enviado ao PLC com sucesso."
		iif(substr(cComando,1,1)="S",nLog:=4,nLog:=5)
		U_GRVLOGSX(FunName(),nLog,"[PLC]")
		iif(lAutom,conout(cBarraStatus),LjMsgRun(cBarraStatus))
		
	endif
	ntentar++
end

oObj:CloseConnection()

if !oObj:IsConnected()
	iif(lAutom,conout('Conexao FECHADA!'),LjMsgRun('Conexao FECHADA!'))
else
	iif(lAutom,conout('Conexao AINDA ABERTA!'),LjMsgRun('Conexao AINDA ABERTA!'))
endif

RestArea(wArea)

return lRet 