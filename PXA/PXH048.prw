#include "rwmake.ch"
#include "PROTHEUS.CH"
#include "TCBROWSE.CH"

#define CBS_SIMPLE               1  // 0x0001
#define CBS_DROPDOWN             2  // 0x0002
#define CBS_DROPDOWNLIST         3  // 0x0003
#define CBS_OWNERDRAWFIXED      16  // 0x0010
#define CBS_AUTOHSCROLL         64  // 0x0040
#define CBS_OEMCONVERT         128  // 0x0080
#define CBS_SORT               256  // 0x0100
#define CBS_DISABLENOSCROLL   2048  // 0x0800

#define Altera := .t.

User Function PXH048()

Private aZONAS	     := {}
Private aSETORES	 := {"Todos"}
Private aPONTOPED	 := {"Todos"}
Private cZonas
Private oZonas
Private cSetores
Private oSetores

Private nQtdReg := 0
Private cPontoPed
Private oPONTOPED
Private oSearch
Private cSearch
Private aSearch := {"Nome Cliente","Pedido"}
Private oDlg
Private oMark
Private lInverte := .F.
Private cMarca
Private oTxtSearc
Private cTxtSearch := Space(100)
Private cFiltro    := ""
Private oLABEL_REG
Private cLABEL_REG := " "

private lNoPatio:= iif( sz8->(fieldPos("ZE_PATIO"))>0 ,  iif(m->ZE_patio=='1' , .t. , .f. ) , .t. )

M->ZE_PRODUTO := CriaVar("ZE_PRODUTO")
M->ZE_QUANT   := CriaVar("ZE_QUANT")

getZona()
DEFINE MSDIALOG oDlg TITLE "Pedidos" FROM 0,0 TO 665,1200 PIXEL

@ 003,001 TO 043,700 LABEL "Selecione : " PIXEL OF oDlg
@ 047,002 TO 330,600 LABEL "Pedidos: " PIXEL OF oDlg

@ 013,003 Say "Zona" Size 018,008 COLOR CLR_BLACK PIXEL OF oDlg

oZONAS:= TComboBox():New(013,030,{|u|if(PCount()>0,cZonas:=u,cZonas)},;
aZONAS,072,10,oDlg,,{|| getSetor(cZonas,@aSETORES ) },;
,,,.T.,,,,,,,,,"cZonas")

@ 013,109 Say "Setor" Size 018,008 COLOR CLR_BLACK PIXEL OF oDlg

oSETORES:= TComboBox():New(013,134,{|u|if(PCount()>0,cSetores:=u,cSetores)},;
aSETORES,072,10,oDlg,,{|| getPontoPed(cZonas,cSetores, @aPONTOPED )  },;
,,,.T.,,,,,,,,,"cSetores")

@ 013,213 Say "Ponto Setor" Size 034,008 COLOR CLR_BLACK PIXEL OF oDlg

oPONTOPED:= TComboBox():New(013,246,{|u|if(PCount()>0,cPontoPed:=u,cPontoPed)},;
aPONTOPED,150,10,oDlg,,{||  },;
,,,.T.,,,,,,,,,"cPontoPed")

@ 026,247 Button "Pesquisar" Size 058,011 ACTION getPedidos(cSearch, cTxtSearch )  PIXEL OF oDlg
@ 026,336 Button "Atualizar" Size 058,011 ACTION updCarga(cZonas,cSetores,cPontoPed) PIXEL OF oDlg

@ 026,003 Say "Pesquisa " Size 022,008 COLOR CLR_BLACK PIXEL OF oDlg
oSearch:= TComboBox():New(026,030,{|u|if(PCount()>0,cSearch:=u,cSearch)},;
aSearch,072,10,oDlg,,{||   },;
,,,.T.,,,,,,,,,"cSearch")

oTxtSearch:= TGet():New(026,105, {|U|      ;
	if(PCount()>0,cTxtSearch := U,cTxtSearch)},;
	oDlg,102,09,,{||},,,,,,.T.,,,,,,,,,"","cTxtSearch")

oLABEL_REG:= TSay():New(322,009,{|| cLABEL_REG },oDlg,,,,,,.T.,CLR_BLUE,CLR_WHITE,100,20)

@ 013,450 Button "Confirmar" Size 058,011 ACTION (doConfPed(), close( oDlg )) PIXEL OF oDlg
@ 026,450 Button "Limpar"    Size 058,011 ACTION doClearFilter() PIXEL OF oDlg

showPed()

ACTIVATE MSDIALOG oDlg CENTERED

DbSelectArea("SC6")

Set filter to
dbClearFilter()

DbGotop()

Return

Static Function doConfPed()

Local nmarcados := 0

aPedMark := {}
aPedDesMar:= {}

dbSelectArea("SC6")
Set filter to

dbClearFilter()
DbSetOrder(3)

DbGotop()

While SC6->(!EOF())
	
	IF !Empty(SC6->C6_YOK)
		If Reclock("SC6",.f.)
			if Marked("C6_YOK")
				If Empty(M->ZE_PRODUTO)
					M->ZE_PRODUTO := SC6->C6_PRODUTO
				EndIf
				M->ZE_QUANT  += SC6->C6_QTVEN
				SC6->(MsUnlock() )
				nmarcados++
				
				aAdd(aPedMark,{SC6->C6_NUM})
			endif
		EndIf
	Elseif Empty(SC6->C6_YOK) .and. SC6->C6_YOC == M->ZE_OC
		aAdd(aPedDesMar,{SC6->C6_NUM})
	Endif
	
	SC6->(dbSkip())
EndDo

If Len(aPedMark) <> 0
	M->ZE_STATUS  := 'P'
	If lnoPatio
		M->ZE_STATUS  := '1'  //Agenciado
	EndIf
Else
	M->ZE_STATUS  := ''  //Não-Agenciado
EndIf

aZ8Itens :={}
nPedagio := 0

dbSelectArea('SC6')
dbsetorder(1)
For j := 1 TO Len(aPedMark)
	If dbSeek(xFilial('SC6')+aPedMark[j,1])
		
		While !SC6->(Eof()) .and. SC6->C6_NUM  == aPedMark[j,1]
			
			npos:= ascan(  aZ8Itens, { |x| alltrim(x[1]) == alltrim(SC6->C6_PRODUTO)  } )
			if npos==0
				aadd( aZ8Itens, {SC6->C6_PRODUTO, SC6->C6_QTDVEN} )
			else
				aZ8Itens[npos,2]+= SC6->C6_QTDVEN
			endif
			
			SC6->(dbskip())
		EndDo		
	EndIf
Next

xItensOC:=''
For j:=1 to len(aZ8Itens)
	xitensOC+=aZ8Itens[j,1]+'/'+left(posicione('SB1\',1,xfilial('SB1')+aZ8Itens[j,1],'B1_YDESCRE'),25)+'/'+transform(aZ8Itens[j,2],"@E 9999999.99")+'#'
next
M->ZE_itensoc:=xitensOC
if M->ZE_patio=='1'
	M->ZE_hragenc := time()
endif

Return



Static Function doClearFilter()

DbSelectArea("SC6")

Set filter to
dbClearFilter()
DbGotop()

cLABEL_REG := "Registro(s) : " + StrZero(SC6->(RecCount()),6)
oLABEL_REG:Refresh()

cClientes := ""
oMark:oBrowse:Refresh()

Return

Static Function updCarga(cZonas,cSetores,cPontoPed)

Local cClientes := ""
Local cQuery    := ""
Local nRows     := 0
Local cZona     := ""
Local cSetor    := ""
IF Empty(charText(cZonas) ) .OR.  ;
	Empty(charText(cSetores) )
	Return
EndIF

//AT(cMascara,cString) > 0
IF AllTrim(cZonas) != 'Todos'
	cZona := SubStr(cZonas,1,  At("-",AllTrim(cZonas))-1 )
Else
	cZona := cZonas
EndIF

IF AllTrim(cSetores) != 'Todos'
	cSetor := SubStr(cSetores,1,  At("-",AllTrim(cSetores))-1 )
Else
	cSetor := cSetores
EndIF


IF AllTrim(cZona) == 'Todos' .And. !Empty(AllTrim(cZona))  // Selecionou uma Zona!
	cfiltro := " C6_NUM !=  '" + Space(2) + "' "
Else
	
	cAlias := GetNextAlias()
	
	IF AllTrim(cSetor) <> 'Todos' .And. !Empty(AllTrim(cSetor))   // O Setor, foi selecionado, logo será listados todos os clientes da ZONA + SETOR selecionado
		cQuery := ChangeQuery("SELECT DA7_CLIENT AS DA7_CLIENT FROM " + RETSQLNAME("DA7") + " WHERE DA7_PERCUR = '" + cZona + "' AND DA7_ROTA = '" + cSetor + "' " )
	Else
		cQuery := ChangeQuery("SELECT DA7_CLIENT AS DA7_CLIENT FROM " + RETSQLNAME("DA7") + " WHERE DA7_PERCUR = '" + cZona + "'" )
	EndIF
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)
	(cAlias)->(DbGoTop())
	
	IF((cAlias)->(Eof()))
		
		MsgInfo("Não existem clientes para essa zona.","Pedidos")
		
		Return
		
	Else
		cClientes := "'"
		While !(cAlias)->(Eof())
			cClientes += AllTrim( (cAlias)->DA7_CLIENT )+'/'
			nRows += 1
			(cAlias)->(DbSkip())
		Enddo
		(cAlias)->(DbCloseArea())
	EndIF
	
	cClientes := SubStr(AllTrim( cClientes ),1,Len(AllTrim( cClientes ))-1 )
	cClientes += "'"
	
	IF !Empty(cClientes)
		cfiltro := "  C6_CLI $ " + AllTrim(cClientes)
	EndIF
	
EndIF

IF Empty(charText(cPontoPed) ) .OR. Empty(charText(cPontoPed) )
	cfiltro := cfiltro
Else
	
	IF AllTrim(cPontoPed) <> 'Todos'
		cClientes := AllTrim(cPontoPed)
		cClientes := Left(cPontoPed,6)
		cClientes := "'"+cClientes+"'"
		
		cfiltro := "  C6_CLI $ " + AllTrim(cClientes)
	Else
		DbSelectArea("SC6")
		Set filter to
		dbClearFilter()
		DbGotop()
		
		cLABEL_REG := "Registro(s) : " + StrZero(SC6->(RecCount()),6)
		oLABEL_REG:Refresh()
		
		cClientes := ""
		oMark:oBrowse:Refresh()
		
	EndIF
	
EndIF

cFiltro += " DTOS(C6_ENTREG) <= '"+DTOS(dDataBase)+"'"
cFiltro += " .AND. (C6_QTDVEN - C6_QTDENT) > 0  "

dbSelectArea("SC6")

DbSetOrder(3)

Set Filter to &(cfiltro)
DbGotop()

cLABEL_REG := "Registro(s) : " + StrZero(SC6->(RecCount()),6)
oLABEL_REG:Refresh()

cClientes := ""
oMark:oBrowse:Refresh()

Return


Static Function getZona()

Local cAlias
Local cQuery := ""

cAlias := GetNextAlias()
cQuery := ChangeQuery("SELECT * FROM " + RETSQLNAME("DA5") )

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)
(cAlias)->(DbGoTop())

AADD( aZONAS, "Todos")
IF((cAlias)->(Eof()))
	return
EndIF

cZona := (cAlias)->DA5_COD

While !(cAlias)->(Eof())
	AADD( aZONAS , (cAlias)->DA5_COD + ' - ' + (cAlias)->DA5_DESC )
	(cAlias)->(DbSkip())
Enddo

(cAlias)->(DbCloseArea())

Return


Static Function getSetor(cZona,aSETORES)

Local cAlias
Local cQuery := ""


cZona := SubStr(cZona,1,  At("-",AllTrim(cZona))-1 )

cAlias := GetNextAlias()
cQuery := ChangeQuery("SELECT * FROM " + RETSQLNAME("DA6") + " WHERE DA6_PERCUR = '" + cZona + "'" )

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)

(cAlias)->(DbGoTop())

IF((cAlias)->(Eof()))
	
	aSETORES := {}
	AADD( aSETORES, "Todos")
	oSETORES:aItems:= aSETORES
	oSETORES:Refresh()
	oDlg:Refresh()
	
	return
EndIF

aSETORES := {}

AADD( aSETORES, "Todos")
cSetor :=  (cAlias)->DA6_ROTA
While !(cAlias)->(Eof())
	AADD( aSETORES , (cAlias)->DA6_ROTA + ' - ' + (cAlias)->DA6_REF )
	(cAlias)->(DbSkip())
Enddo

(cAlias)->(DbCloseArea())

IF ;
	oSETORES != NIL
	oSETORES:aItems:= aSETORES
	oSETORES:Refresh()
	oDlg:Refresh()
	
EndIF


Return

Static Function getPontoPed(cZonas,cSetor,aPONTOPED)

Local cAlias
Local cQuery := ""
Local cPontoPed := ""
Local cZona := ""

cPontoPed := SubStr(cSetor,1,  At("-",AllTrim(cSetor))-1 )
cZona := SubStr(cZonas,1,  At("-",AllTrim(cZonas))-1 )

cAlias := GetNextAlias()
cQuery := ChangeQuery("SELECT * FROM " + RETSQLNAME("DA7") + " WHERE  DA7_PERCUR  = '" + cZona  + "' AND DA7_ROTA = '" + cPontoPed + "'" )

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)

(cAlias)->(DbGoTop())

IF((cAlias)->(Eof()))
	
	aPONTOPED := {}
	AADD( aPONTOPED, "Todos")
	oPONTOPED:aItems:= aPONTOPED
	oPONTOPED:Refresh()
	oDlg:Refresh()
	
	return
EndIF

aPONTOPED := {}
AADD( aPONTOPED, "Todos")

While !(cAlias)->(Eof())
	AADD(aPONTOPED, (cAlias)->DA7_CLIENT + ' - ' + Posicione("SA1",1,xFilial("SA1")+(cAlias)->DA7_CLIENT,"A1_NOME") )
	(cAlias)->(DbSkip())
Enddo

(cAlias)->(DbCloseArea())

IF ;
	oPONTOPED != NIL
	oPONTOPED:aItems:= aPONTOPED
	oPONTOPED:Refresh()
	oDlg:Refresh()
EndIF

Return


Static Function getPedidos(cTpSearch,cSearch)

If Empty(charText(cSearch) )
	MsgStop("Informe uma pesquisa válida.","Pedidos")
	oSearch:SetFocus()
	Return
Endif

dbSelectArea("SC6")

IF( AllTrim(cTpSearch) == "Nome Cliente")
	dbOrderNickName("INDSC62")//DbSetOrder(3)
	
Else
	DbSetOrder(1)
EndIF

SC6->(dbseek(xFilial('SC6')+ rtrim(cSearch) ),.T.)

Return





Static Function showPed()

Local nmarcados := 0

aCampos  := { { "C6_YOK"        ,,  " "               ,"@!"},;
			{ "C6_YEMIS"        ,, "Emissao"          ,"@!"},;
			{ "C6_NUM"          ,, "Pedido"           ,"@!"},;
			{ "C6_YTIPO"        ,, "Tipo"             ,"@!"},;
			{ "C6_PRODUTO"      ,, "Produto"          ,"@!"},;
			{ "C6_QTDVEN"       ,, "Quantidade"       ,"@E 999,999,999.99"},;
			{ "C6_ENTREG"       ,, "Dt.Entrega"       ,"@!"},;
			{ "C6_YNOMCLI"      ,, "Cliente"          ,"@!"},;
			{ "C6_LOJA"         ,, "Loja"             ,"@!"},;
			{ "C6_YLOCAL"       ,, "Local Entrega"    ,"@!"},;
			{ "C6_YFRETE"       ,, "Frete"            ,"@!"},;
			{ "C6_YFTRA"        ,, "Frete Transp."    ,"@E 999,999,999.99"},;
			{ "C6_YFMOT"        ,, "Frete Motor."     ,"@E 999,999,999.99"},;
			{ "C6_YHLIB"        ,, "Hora Lib."        ,"@!"},;
			{ "C6_YNLIB"        ,, "Liberador"        ,"@!"} }

dbSelectArea("SC6")
SC6->(dbSetOrderNickName("INDSC62"))
dbGotop()

cFiltro += " DTOS(C6_DTENT) <= '"+DTOS(dDataBase)+"'"
cFiltro += " .AND. (STR(C6_QTDVEN,14,2) > STR(C6_QTENT,12,2)) > '0' "

dbSelectArea("SC6")
dbOrderNickName("INDSC62")

Set Filter to &(cfiltro)  

DbGotop()

lInverte := .F.
cMarca   := GetMark()

While SC6->(!EOF())
	
	If Reclock("SC6",.f.)
		SC6->C6_YOK := " "
		If aScan(apedmark,{|x| x[1] == SC6->C6_NUM}) > 0 .OR. (SC6->C6_YOC == M->ZE_OC)
			SC6->C6_YOK := cmarca
		endif
		MsUnlock()
		nmarcados += 1
	EndIf
	SZ1->(dbSkip())
EndDo

oMark := MsSelect():New("SC6","C6_YOK","",aCampos,@lInverte,@cMarca,{055 , 02, 320, 597 })
oMark:bMark := {|| getSelMark(@cMarca,@lInverte) }

cLABEL_REG := "Registro(s) : " + StrZero(nmarcados,6)
oLABEL_REG:Refresh()

Return




Static Function getSelMark(cMarca,lInverte)

Local cxMarca := ThisMark()
Local nX := 0
Local lxInvert := ThisInv()

If SC6->C6_YTIPO == "B"
	Alert("Nao e permitido marcar o pedido bonificacao")
	DbSelectarea("SC6")
	DbSetOrder(1)
	If Reclock("SC6",.f.)
		SC6->C6_YOK := ""
		MsUnlock()
	EndIf
EndIf

DbSelectArea("SX6")
DbSetOrder(1)
If ! SX6->( DbSeek(xFilial("SX6") + "MV_YOBGPL") )
	RecLock("SX6", .T.)
	SX6->X6_FILIAL  := xFilial("SX6")
	SX6->X6_VAR     := "MV_YOBGPL
	SX6->X6_TIPO    := "L"
	SX6->X6_DESCRIC := "validação para quando for fob preencimento seja obrigatorio da placa e do motorista"
	SX6->X6_CONTEUD := ".F."
	SX6->X6_PROPRI  := 'U'
	SX6->(MsUnlock())
EndIf

If  GetMv("MV_YOBGPL",.F.,.F.) .and. SC6->C6_YFRETE == 'F'
	
	If SC6->C6_YPLACA <> M->ZE_PLACA
		Alert("Placa do Agencimento não bate com a do Pedido !!"+CRLF+"Por favor selecionar outro pedido.")
		DbSelectarea("SC6")
		DbSetOrder(1)
		If Reclock("SC6",.f.)
			SC6->C6_YOK := ""
			MsUnlock()
		EndIf
	EndIf
	
	If SC6->C6_YNMOT <> M->ZE_NOMMOT
		Alert("Nome do Motorista não bate com o Nome do Motorista do Pedido!!"+CRLF+"Por favor selecionar outro pedido.")
		DbSelectarea("SC6")
		DbSetOrder(1)
		If Reclock("SC6",.f.)
			SC6->C6_YOK := ""
			MsUnlock()
		EndIf
	Endif
	
Endif

IF SC6->C6_YOK == cMarca //.AND. !lInverte
	
	IF Reclock("SC6",.F.)
		SC6->C6_YOK := cMarca
		lInverte := .T.
		MsUnlock()
	EndIF
	
	nQtdReg ++
Else	
	IF Reclock("SC6",.F.)
		SC6->C6_YOK := " "
		lInverte := .F.
		MsUnlock()
	EndIF
	
	nQtdReg --
	nQtdReg := IIF(nQtdReg<0,0,nQtdReg)
EndIF

cLABEL_REG := " Selecionado(s) - " + StrZero(nQtdReg,6) + " - Registro(s) "
oLABEL_REG:Refresh()
Return



Static Function __bMark(cMarca)

If IsMark( 'C6_YOK', cMarca )
	RecLock( 'SC6', .F. )
	Replace C6_YOK With Space(2)
	MsUnLock()
Else
	RecLock( 'SC6', .F. )
	Replace C6_YOK With cMarca
	MsUnLock()
EndIf

return


Static Function charText(cTexto)
cTexto := StrTran(cTexto,"Ã","a")
cTexto := StrTran(cTexto,"ã","a")
cTexto := StrTran(cTexto,"Á","a")
cTexto := StrTran(cTexto,"á","a")
cTexto := StrTran(cTexto,"Â","a")
cTexto := StrTran(cTexto,"â","a")
cTexto := StrTran(cTexto,"À","a")
cTexto := StrTran(cTexto,"à","a")
cTexto := StrTran(cTexto,"Ô","o")
cTexto := StrTran(cTexto,"ô","o")
cTexto := StrTran(cTexto,"Ó","o")
cTexto := StrTran(cTexto,"ó","o")
cTexto := StrTran(cTexto,"Õ","o")
cTexto := StrTran(cTexto,"õ","o")
cTexto := StrTran(cTexto,"Ú","u")
cTexto := StrTran(cTexto,"ú","u")
cTexto := StrTran(cTexto,"Ü","u")
cTexto := StrTran(cTexto,"ü","u")
cTexto := StrTran(cTexto,"Í","i")
cTexto := StrTran(cTexto,"í","i")
cTexto := StrTran(cTexto,"Ç","c")
cTexto := StrTran(cTexto,"ç","c")
cTexto := StrTran(cTexto,"É","e")
cTexto := StrTran(cTexto,"é","e")
cTexto := StrTran(cTexto,"Ê","e")
cTexto := StrTran(cTexto,"ê","e")
cTexto := StrTran(cTexto,","," ")
cTexto := StrTran(cTexto,"."," ")
cTexto := StrTran(cTexto,"?"," ")
cTexto := StrTran(cTexto,"!"," ")
cTexto := StrTran(cTexto,"º"," ")
cTexto := StrTran(cTexto,"ª"," ")
cTexto := StrTran(cTexto,"*"," ")
cTexto := StrTran(cTexto,"/"," ")
cTexto := StrTran(cTexto,"\"," ")
cTexto := StrTran(cTexto,"'"," ")
cTexto := StrTran(cTexto,'"'," ")

Return cTexto