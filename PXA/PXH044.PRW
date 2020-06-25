#include "Protheus.ch"
#include "rwmake.ch"
#Include "TOPCONN.CH"

User Function PXH044(p_lautom,p_cTipo)

local lAutom:= iif(p_lautom<>Nil,p_lautom,.f.)
local cTipo := if(p_cTipo<>Nil,p_cTipo,"C")

aAreaATU := GetArea()
aAreaSZE := SZE->(GetArea())

dbSelectArea("SZE")

nCon1  := -1
ltentar:= .t.

TCCONTYPE("NPIPE")
nCon1  := TCLink("MSSQL/SIGEX","10.0.1.9",7897)

while nCon1 <0 .and. ltentar
	nCon1 := TCLink("MSSQL/SIGEX","10.0.1.9",7897)
	ltentar:= !MsgBox("Falha durante a tentativa de conectar-se ao banco de dados SIGEX. Tentar mais uma vez ?","Acesso SIGEX", "YESNO")
end

If nCon1 < 0
	caux:="Falha durante a tentativa de conectar-se ao banco de dados SIGEX."
	if !lautom
		Alert(caux)
	else
		conout( caux )
	endif
Else
	if lautom
		conout( "conectado banco SIGEX ..." )
	endif
	TCSetConn(nCon1)
	
	cQuery := ""
	cQuery := "SELECT * FROM " + RetSqlName("SZE") + " "
	cQuery += " WHERE D_E_L_E_T_ = '' AND ZE_FILIAL = '" + xFilial("SZE") + "' "
	cQuery += " AND ( ZE_STATUS IN ('4','5') "
	cQuery += " OR ( ZE_STATUS = '3' AND  ZE_PSENT=0 AND  ZE_IHM<>'' ) ) "
	cQuery += " AND ZE_FATUR = '' AND ZE_TPOPER = '"+cTipo+"' AND ZE_DATA >= '"+DTOS(dDataBase-20)+"' "		//rodrigo semar 31/08/13
	//cQuery += " ORDER BY " + cIndE1
	
	if select('sZE_sig')>0
		sZE_sig->(dbCloseArea())
	endif
	dbUseArea(.F., "TOPCONN", TCGenQry(,,cQuery), "SZE_SIG", .F., .T.)
	
	DbSelectArea("SZE_SIG")
	
	sZE_sig->(DbGotop())
	
	aSZE_sig:={}
	
	nposStatus	:=1
	nposOC		:=2
	nposPFin	:=3
	nposDtFin	:=4
	nposHFin	:=5
	nposHPes	:=6
	nposIHM		:=7
	nposHIni	:=8
	
	while !sZE_sig->(eof())
		aAdd(aSZE_sig, { sZE_sig->ZE_status, sZE_sig->ZE_oc, sZE_sig->ZE_pesofin, stod(sZE_sig->ZE_dtfin), sZE_sig->ZE_hrfin, sZE_sig->ZE_horpes, sZE_sig->ZE_ihm , sZE_sig->ZE_hrini})
		sZE_sig->(dbskip())
	EndDo
		
	if len(aSZE_sig)>0
		if lautom
			conout( "ataulizando banco SIGEX ..." )
		endif
		cQuery :=""
		cQuery := "UPDATE "+RetSqlName("SZE")
		cQuery += " SET ZE_STATUS = '6' "
		cQuery += " WHERE D_E_L_E_T_ = '' AND ZE_FILIAL = '" + xFilial("SZE") + "' "
		cQuery += " AND ZE_STATUS IN('5') "
		
		TcSqlExec(cQuery)
				
		TCSetConn(0)
		dbSelectArea("SZE")
		dbSetOrder(1)
		
		for i:=1 to len(aSZE_sig)
						
			If dbSeek(xFilial("SZE")+ aSZE_SIG[i,nposOC])
				While !RecLock("SZE",.F.) ;EndDo
				SZE->ZE_STATUS  := IF(aSZE_SIG[i,nposStatus]=="5","6",aSZE_SIG[i,nposStatus])
				SZE->ZE_PESOFIN	:= aSZE_SIG[i,nposPFin]
				SZE->ZE_DTFIN 	:= aSZE_SIG[i,nposDtFin]
				SZE->ZE_HRFIN  	:= aSZE_SIG[i,nposHFin]
				SZE->ZE_HRINI  	:= aSZE_SIG[i,nposHIni]
				SZE->ZE_IHM  	:= aSZE_SIG[i,nposIHM]
				SZE->(MsUnLock())				
			EndIf			
		next		
	End
		
	TCUnLink(nCon1)
	TCSetConn(0)
	
	if lautom
		conout( "desconectado banco SIGEX ..." )
	endif
	
	dbSelectArea("SZE")
	
EndIf

RestArea(aAreaSZE)
RestArea(aAreaATU)
if lautom
	conout( "fim atualizacao banco SIGEX ..." )
endif

Return


User Function setSigex(lz8Found, cStatus, nPEntAnt, nPesoAux, p_lCarrGranel, cOC, cPager, p_lcancelPeso)

local aAreaATU := GetArea()
local aAreaSZE := SZE->(GetArea())
local lcancelPeso := iif( p_lcancelPeso==nil, .f., p_lcancelPeso )

dbSelectArea("SZE")
dbSetOrder(1)
dbSeek(xFilial("SZE")+cOC)

TCConType("TCPIP")

nCon1  := -1
ltentar:= .t.
nCon1  := TCLink("MSSQL/SIGEX","10.0.1.9",7897)
while nCon1 <0 .and. ltentar
	nCon1 := TCLink("MSSQL/SIGEX","10.0.1.9",7897)
	ltentar:= !MsgBox("Falha durante a tentativa de conectar-se ao banco de dados SIGEX. Tentar mais uma vez ?","Acesso SIGEX", "YESNO")
end

If nCon1 > 0
	dbSelectArea("SZE")
	RegToMemory("SZE",.F.)
	dbCloseArea()
	
	TCSetConn(nCon1)
	
	if cStatus == '3' .and. lcancelPeso
		
		cQuery :=""
		cQuery := "DELETE "+RetSqlName("SZE")
		cQuery += " WHERE D_E_L_E_T_ = '' AND ZE_FILIAL = '" + xFilial("SZE") + "' "
		cQuery += " AND ZE_OC =  '"  +cOC+ "'"
		cQuery += " AND ZE_PAGER =  '"	+cPager+ "'"
		
		TcSqlExec(cQuery)
		
	elseif (cStatus=="3" .and. nPEntAnt==0 .and. p_lCarrGranel)  .and. lz8Found
				
		cQuery :=""
		cQuery := "UPDATE "+RetSqlName("SZE")
		cQuery += " SET ZE_PSENT = "+str(nPesoAux)
		cQuery += " WHERE D_E_L_E_T_ = '' AND ZE_FILIAL = '" + xFilial("SZE") + "' "
		cQuery += " AND ZE_OC =  '"  +cOC+ "'"
		cQuery += " AND ZE_PAGER =  '"	+cPager+ "'"
		
		TcSqlExec(cQuery)
				
	else				
		dbUseArea(.T., "TOPCONN", RetSqlName("SZE"), "SZE_SIGEX", .T., .F.)
		
		dbSelectArea("SZE_SIGEX")
		RecLock("SZE_SIGEX",.T.)
		
		aStructSZE := DbStruct()
		
		For iZ8:= 1 TO Len(aStructSZE)
			cVarZ8    := "M->"+aStructSZE[iZ8,1]
			cFieldZ8  := "SZE_SIGEX->"+aStructSZE[iZ8,1]
			
			If ALLTRIM(aStructSZE[iZ8,1]) $ "ZE_DATA,ZE_DTSAIDA,ZE_YDTLIB,ZE_DTINI,ZE_DTFIN,ZE_DTVIST"
				TCSetField("SZE_SIGEX", ALLTRIM(aStructSZE[iZ8,1]) ,"D")
			EndIf
			
			&(cFieldZ8) := &(cVarZ8)
		Next
		
		SZE_SIGEX->(MsUnLock())
		dbCloseArea()		
	endif
	
	TCUnLink(nCon1)
	TCSetConn(0)
EndIf

dbSelectArea("SZE")


RestArea(aAreaSZE)
RestArea(aAreaATU)

Return


User function SigexRegrava()

local warea   := getArea()
local wTabela := RetSqlName("SZE")
local lz8Found:= .f.

cQuery := ""
cQuery += " SELECT ZE_OC, ZE_STATUS, ZE_PSENT, ZE_SACGRA, ZE_PAGER"
cQuery += " FROM "+wTabela +" P "
cQuery += " WHERE P.D_E_L_E_T_ = '' "
cQuery += " AND ZE_STATUS >= '3' AND ZE_TPOPER IN('C','D') AND ZE_FATUR = '' "
cQuery += " AND ZE_OC NOT IN( SELECT ZE_OC FROM SIGEX.dbo."+wTabela+" S WHERE S.D_E_L_E_T_ = '' AND S.ZE_STATUS = '3' )

dbUseArea(.F., "TOPCONN", TCGenQry(,,cQuery), "xSZE", .F., .T.)
DbSelectArea("xSZE")
xSZE->(DbGotop())

if !empty(xSZE->ZE_oc)
	while !xSZE->(eof())
		u_setSigex(lz8Found,xSZE->ZE_status, xSZE->ZE_psent, 0 ,( xSZE->ZE_sacgra=='G' ), xSZE->ZE_oc, xSZE->ZE_pager)
		xSZE->(dbskip())
	end
endif

DbSelectArea("xSZE")

xSZE->(dbCloseArea())
RestArea(warea)

Return