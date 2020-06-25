#Include "Protheus.ch"
#include "rwmake.ch"
#INCLUDE 'COLORS.CH'
#Include "TOPCONN.CH"
#INCLUDE "FWBROWSE.CH"
#include "totvs.ch"
#include "fwmvcdef.ch"

#XCommand ROLLBACK TRANSACTION => DisarmTransaction()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATT13                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//     ATENCIAMENTO DE CARGAS
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SMFATT13()

Local oBrw
Local cAlias := "SZ8"
Private cCadastro := "Agenciamento"
Private aPedDesMar := {}
Private aCores := {}
//Private aRotina := {}
Private aFixe	:= {}
Private aAcho	:= {}
Private aCpos	:= {}
private lSenMot := ( cEmpAnt $ getNewPar('MV_SENMOTO', '20' ) )
//private lUsaPager := ( cEmpAnt $ getNewPar('MV_USAPAGE', '20' ) )
private lUsaPager := .T.
private lBlqFrete := .T.


//testa liberação de acesso a rotina
if !u_SMGETACCESS(funname(),.f.); return; endif



aadd(aAcho,"NOUSER") //Evita Exibição de outros campos de usuario.
aadd(aAcho,"Z8_OC") //OK
aadd(aAcho,"Z8_DATA") //OK
aadd(aAcho,"Z8_HORA")  //OK
aadd(aAcho,"Z8_HRAGENC")  //OK
aadd(aAcho,"Z8_TPOPER")
aadd(aAcho,"Z8_PLACA")    //OK
aadd(aAcho,"Z8_MOTOR")   //OK
aadd(aAcho,"Z8_NOMMOT")  //OK
aadd(aAcho,"Z8_PLCAR")   //OK
aadd(aAcho,"Z8_PRODUTO")
aadd(aAcho,"Z8_QUANT")
aadd(aAcho,"Z8_PALLET")
aadd(aAcho,"Z8_PLTEN")
aadd(aAcho,"Z8_PLTSA")
aadd(aAcho,"Z8_PAGER")
aadd(aAcho,"Z8_LACRE")
aadd(aAcho,"Z8_TRANSP")   //OK
aadd(aAcho,"Z8_LJTRANS")  //OK
aadd(aAcho,"Z8_NMTRANS")   //OK
aadd(aAcho,"Z8_SACGRA")
aadd(aAcho,"Z8_VISTOR")    //OK
aadd(aAcho,"Z8_DTVIST")    //OK
aadd(aAcho,"Z8_MUNIC")     //OK
aadd(aAcho,"Z8_ESTADO")    //OK
aadd(aAcho,"Z8_OBS")
aadd(aAcho,"Z8_USUARIO")
aadd(aAcho,"Z8_FORNECE")  //OK
aadd(aAcho,"Z8_LOJAFOR")  //OK
aadd(aAcho,"Z8_NFCOMP")
aadd(aAcho,"Z8_SERNF")
aadd(aAcho,"Z8_NFPESEN")
aadd(aAcho,"Z8_TICKENT")
aadd(aAcho,"Z8_PATIO")
aadd(aAcho,"Z8_CILINDR")  //OK
aadd(aAcho,"Z8_CATEGMP")
aadd(aAcho,"Z8_CBPAGER")
aadd(aAcho,"Z8_LOCCARR")
aadd(aAcho,"Z8_STATUS2")
aadd(aAcho,"Z8_ITENSOC")



//Instaciamento
oBrw := FWMBrowse():New()

//tabela que será utilizada
oBrw:SetAlias( "SZ8" )

//Realiza o filtro
oBrw:SetFilterDefault("Z8_FILIAL = cFilant .and. Empty(Z8_FATUR) .and. !empty(Z8_TPOPER)")

//Legenda
oBrw:AddLegend( 'If(Z8_STATUS2==" ",Empty(If(Z8_TPOPER=="C",Posicione("SZF",8,xFilial("SZF")+Z8_OC,"ZF_OC"),Posicione("SC7",RetOrdem("SC7","C7_FILIAL+C7_YOC"),xFilial("SC7")+Z8_OC,"C7_YOC"))),.F.)', "WHITE", "" )
oBrw:AddLegend( 'If(SZ8->Z8_STATUS2=="P",!Empty(If(SZ8->Z8_TPOPER=="C",Posicione("SZF",8,xFilial("SZF")+SZ8->Z8_OC,"ZF_OC"),Posicione("SC7",RetOrdem("SC7","C7_FILIAL+C7_YOC"),xFilial("SC7")+SZ8->Z8_OC,"C7_YOC"))),.F.)', "ORANGE", "" )
oBrw:AddLegend( 'If(SZ8->Z8_STATUS2=="1",!Empty(If(SZ8->Z8_TPOPER=="C",Posicione("SZF",8,xFilial("SZF")+SZ8->Z8_OC,"ZF_OC"),Posicione("SC7",RetOrdem("SC7","C7_FILIAL+C7_YOC"),xFilial("SC7")+SZ8->Z8_OC,"C7_YOC"))),.F.)', "YELLOW", "" )
oBrw:AddLegend( 'Z8_STATUS2 == "2"' , "GREEN", "" )
oBrw:AddLegend( 'Z8_STATUS2 == "3"' , "PINK" , "" )
oBrw:AddLegend( 'Z8_STATUS2 == "4"' , "BLUE" , "" )
oBrw:AddLegend( 'Z8_STATUS2 == "5"' , "BLACK" , "" )
oBrw:AddLegend( 'Z8_STATUS2=="6" .AND. empty(Z8_FATUR)' , "RED" , "" )
oBrw:AddLegend( 'SZ8->Z8_STATUS2=="6" .AND. !empty(Z8_FATUR) .AND. Z8_PESOFIN>0' , "BROWN", "" )

//Botoes
oBrw:AddButton("Pesquisar"  ,{||AxPesqui("SZ8",0,1)})
oBrw:AddButton("Visualizar" ,{||U_SMFATT17("SZ8",0,2)})
oBrw:AddButton("Incluir"    ,{||U_SMFATT17("SZ8",0,3)})
oBrw:AddButton("Agenciar"   ,{||U_SMFATT17("SZ8",0,4)})
oBrw:AddButton("Excluir"    ,{||U_SMFATT17("SZ8",0,5)})
oBrw:AddButton("Legenda"    ,{||U_SMFATF29()})
oBrw:AddButton("Cancelar"   ,{||U_SMFATF72()})

//Titulo
oBrw:SetDescription( "Agenciamento" )

//ativa
oBrw:Activate()

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF17                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Inclui				                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function SMFATF17(cAlias, nReg, nOpc)

Local nOpcao := 0
Private aPedMark := {}

nOpcao := AxInclui(cAlias,nReg,nOpc,aAcho,/*aCpos*/,,"u_smSetOC()") // Identifica corretamente a opção definida para o função em aRotinas com mais // do que os 5 elementos padrões.
Return Nil

//** Altera **//
// ANTIGA
/*
static Function f996Alt(cAlias, nReg, nOpc)
Local nOpcao := 0
Local aButtons := {}
Private aPedMark   := {}
Private aPedDesMar := {}


if !( SZ8->Z8_status $ ' *P*1' )
ALERT("ALTERAÇÃO NÃO PERMITIDA: O veículo já iniciou o carregamento/descarregamento. Verifique.")
Return Nil
EndIf

//AADD( aButtons, {"HISTORIC", {|| If(M->Z8_TPOPER='C',U_MIZ998(),ALERT('Somente para TIPO OPERAÇÃO carregamento.'))},"P.Venda"} )

AADD( aButtons, {"HISTORIC", {|| If(M->Z8_TPOPER='C',U_SMFATF80(),ALERT('Somente para TIPO OPERAÇÃO carregamento.'))},"P.Venda"} )
AADD( aButtons, {"PEDIDO", {|| If(M->Z8_TPOPER='D',U_MIZ992(),ALERT('Somente para TIPO OPERAÇÃO descarregamento.'))},"P.Compra"} )

nOpcao := AxAltera(cAlias,nReg,nOpc,aAcho,,,,"u_SMFATF20()",,,aButtons) // Identifica corretamente a opção definida para o função em aRotinas com mais // do que os 5 elementos padrões.

If nOpcao = 1

SMFATF33()

EndIf

Return Nil
*/


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF18                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Deleta				                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function SMFATF18(cAlias, nReg, nOpc)

Local nOpcao := 0
Local cOCOld := SZ8->Z8_OC


If SZ8->Z8_STATUS2 == "1"
	ALERT("EXCLUSÃO NÃO PERMITIDA: A ordem ja possui pedidos associados. Verifique.")
	Return Nil
EndIf


If SZ8->Z8_STATUS2 >= "3"
	ALERT("EXCLUSÃO NÃO PERMITIDA: O veículo já iniciou o carregamento/descarregamento. Verifique.")
	Return Nil
EndIf

If SZ8->Z8_TPOPER == "D"
	dbSelectArea('SC7')
	dbsetorder(RetOrdem("SC7","C7_FILIAL+C7_YOC"))
	If sc7->(dbSeek(xFilial('SC7')+cOCOld))
		While SC7->C7_FILIAL == xFilial("SC7") .AND.;
			SC7->C7_YOC == cOCOld
			
			cSql := "SELECT D1_DOC, D1_SERIE FROM "+RetSqlName("SD1")+" SD1 "
			cSql += " WHERE SD1.D_E_L_E_T_ = ' '"
			cSql += " AND   SD1.D1_FILIAL  = '" +xFilial("SD1")+ "'"
			cSql += " AND   SD1.D1_PEDIDO  = '" + SC7->C7_NUM + "'"
			If Select("QrySC7") > 0
				dbSelectArea("QrySC7")
				QrySC7->(DbCloseArea())
			EndIf
			//wSQL := ChangeQuery(wSQL)
			TcQuery cSql New Alias "QrySC7"
			
			If  QrySC7->(!Eof())
				ALERT("EXCLUSÃO NÃO PERMITIDA: Esta ordem de carregamento já foi relacionada a PRÉ-NOTA/NF "+Alltrim(QrySC7->D1_DOC)+"-"+Alltrim(QrySC7->D1_SERIE)+ ". Verifique.")
				QrySC7->(DbCloseArea())
				Return Nil
			EndIf
			
			sc7->(dbSeek(xFilial('SC7')+cOCOld)) //skip nao funcionou
			sc7->(dbskip())
		EndDo
	EndIf
EndIf
nOpcao := AxDeleta(cAlias,nReg,nOpc,aAcho,/*aCpos*/) // Identifica corretamente a opção definida para o função em aRotinas com mais // do que os 5 elementos padrões.

If nOpcao = 2
	If SZ8->Z8_TPOPER == "C"
		dbSelectArea('SZF')
		dbsetorder(RetOrdem("SZF","ZF_FILIAL+ZF_OC"))
		If dbSeek(xFilial('SZF')+cOCOld)
			While SZF->ZF_FILIAL == xFilial("SZF") .AND.;
				SZF->ZF_OC == cOCOld
				While !RecLock("SZF",.F.) ; End
				SZF->ZF_OC = " "
				SZF->(MsUnlock())
				
				dbSeek(xFilial('SZF')+cOCOld)  //skip nao funcionou
			EndDo
		EndIf
	Else
		dbSelectArea('SC7')
		dbsetorder(RetOrdem("SC7","C7_FILIAL+C7_YOC"))
		If dbSeek(xFilial('SC7')+cOCOld)
			While SC7->C7_FILIAL == xFilial("SC7") .AND.;
				SC7->C7_YOC == cOCOld
				
				While !RecLock("SC7",.F.) ; End
				SC7->C7_YOC = " "
				SC7->(MsUnlock())
				
				dbSeek(xFilial('SC7')+cOCOld) //skip nao funcionou
			EndDo
		EndIf
	EndIf
EndIf

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF19                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Inclui				                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function SMFATF19(cAlias, nReg, nOpc)
Local nOpcao := 0

nOpcao := AxVisual(cAlias,nReg,nOpc,aAcho,/*aCpos*/,,) // Identifica corretamente a opção definida para o função em aRotinas com mais // do que os 5 elementos padrões.
Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF36                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function smSetOC()
Local lRes := .T.

If M->Z8_SACGRA == "S"  .AND. M->Z8_PALLET == "G"
	Alert("A informação do campo PALLET/MANUAL(Granel) é incoerente com a informação do campo SACO/GRANEL(Saco). Verifique.")
	lRes := .F.
EndIf

If M->Z8_SACGRA == "G"  .AND. M->Z8_PALLET <> "G"
	Alert("A informação do campo PALLET/MANUAL é incoerente com a informação do campo SACO/GRANEL(Granel). Verifique.")
	lRes := .F.
EndIf

dbSelectArea("SZ8")
dbSetOrder(1)
While dbSeek(xFilial("SZ8")+M->Z8_OC)
	//M->Z8_OC := GETSXENUM("SZ8","Z8_OC")
	M->Z8_OC := u_smgetSeq("SZ8","Z8_OC")
EndDo

//M->Z8_USUARIO := Subs(Alltrim(cusuario),7,15)
M->Z8_USUARIO := cUsername
m->z8_pswmoto := sz3->z3_senhmot

Return(lRes)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF20                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function SMFATF20()

_aAliOri := GetArea()

Private lRes     := .T.
Private _copcoes := "3"
Private _eixCam  := _eixCar := nTotpedag := _Peso := 0
Private _lGatilho:= .f.

If type('paramIXB')<>'U'
	_lGatilho:= iif( paramIXB<> nil, iif(paramIXB==1,.t.,.f.), .f. )
Endif

Private _pent     := M->Z8_PLTEN
Private _psai     := M->Z8_PLTSA
Private _hora     := M->Z8_HORA
Private _lacre    := M->Z8_LACRE
Private _placa    := M->Z8_PLACA
Private _motor    := M->Z8_MOTOR
Private cctr      := ""
Private cfornece  := M->Z8_TRANSP
Private clojaf    := M->Z8_LJTRANS
Private _numOC    := M->Z8_OC
Private plcar 	  := M->Z8_PLCAR
Private cpm		  := M->Z8_PALLET

If !_lGatilho
	If (M->Z8_TPOPER <> SZ8->Z8_TPOPER) .AND. !Empty(SZ8->Z8_STATUS2)
		Alert("Não é permitido alterar o TIPO DE OPERAÇÃO.")
		RestArea(_aAliOri)
		Return(.F.)
	EndIf
	
	If !u_SMFATF31()
		RestArea(_aAliOri)
		Return(.F.)
	EndIf
	
	
	if !(ALLTRIM(M->Z8_LOCCARR) $ posicione('SX5',1,XFILIAL('SX5')+'PM'+alltrim(M->Z8_PALLET),"X5_DESCENG"))
		Alert("Local de carregamento incompativel com o campo: Pallet/Man. ")
		return(.f.)
	endif
EndIf

//tratamento para pedidos desmarcados
SMFATF33()


If (Len(aPedMark) <> 0 .or. _lGatilho ) .AND. M->Z8_TPOPER == "C" //Se houve selecao de pedido.
	
	If M->Z8_SACGRA == "S"  .AND. M->Z8_PALLET == "G"
		Alert("A informação do campo PALLET/MANUAL(Granel) é incoerente com a informação do campo SACO/GRANEL(Saco). Verifique.")
		lRes := .F.
	EndIf
	
	If M->Z8_SACGRA == "G"  .AND. M->Z8_PALLET <> "G"
		Alert("A informação do campo PALLET/MANUAL é incoerente com a informação do campo SACO/GRANEL(Granel). Verifique.")
		lRes := .F.
	EndIf
	
	If !SMFATF21(_lGatilho)
		lRes := .F.
		//Return(.F.)
	EndIf
	
	If !_lGatilho .and. lRes
		if !SMFATF28()
			lRes := .F.
			RestArea(_aAliOri)
			Return(.F.)
		endif
	EndIf
ElseIf Len(aPedMark) <> 0 .AND. M->Z8_TPOPER == "D" //Se houve selecao de pedido.
	If !fRegDesc()
		RestArea(_aAliOri)
		Return(.F.)
	EndIf
EndIf

//M->Z8_USUARIO := Subs(Alltrim(cusuario),7,15)
M->Z8_USUARIO := cUsername
m->z8_pswmoto := sz3->z3_senhmot

If !empty(m->z8_status2)
	if !Empty(	If(SZ8->Z8_TPOPER=="C",Posicione("SZF",8,xFilial("SZF")+SZ8->Z8_OC,"ZF_OC"),Posicione("SC7",RetOrdem("SC7","C7_FILIAL+C7_YOC"),xFilial("SC7")+SZ8->Z8_OC,"C7_YOC")))
		m->z8_status2:= iif( m->z8_patio == '1', '1','P')
	endif
Endif

RestArea(_aAliOri)

Return(iif( _lGatilho, iif(lres,_placa,"") ,lRes ) )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF21                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Realiza as criticas/verificacoes iniciais                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF21(p_lGatilho)

SetPrvt("_LCREDOK,_BALENT")
SetPrvt("_LRET,_LCONTINUA,_WSALSE1,_WSALSZF")
SetPrvt("_WATRASO,_WDIAS,_WPOSSZF,_WCLI,_WLOJ,_WRISCO,WTOLBAL")
Private npedagio:=0
Private cProduto := CriaVar("ZF_PRODUTO")
Private nNum     := CriaVar("ZF_NUM")
Private oGetlacre
Private nPesoTotal:=0 //usada

p_lGatilho := iif( p_lGatilho<>nil, p_lGatilho, .f. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Identifica nome do arquivo da balanca de entrada                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_BalEnt := alltrim(getmv("MV_YBALENT"))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acessa arquivo da balanca                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If  ! file(_BalEnt)
	MsgBox("Arquivo da Balanca nao existe!","Atencao","ALERT")
	//Return
End

DbSelectArea("SB1")
DbSetOrder(1)
nPesoTotal:=0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se ja foi registrada entrada p/ os pedidos marcados             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !p_lGatilho //Se for peso
	
	If _copcoes $ "2"//Se for peso
		If SZ8->Z8_PSENT <> 0 .or. ;
			empty(SZ8->Z8_PLACA) .or. ;
			empty(SZ8->Z8_MOTOR)
			MsgAlert("Peso ja lancado para o pedido! ","Atencao","Alert")
			Return
		EndIf
	Else
		DbSelectArea("SZF")
		nordem := IndexOrd()
		DbSetOrder(0)
		DbGotop()
		Do while .not. eof()
			If Marked("ZF_OK")
				If _copcoes $ "1" //Se for entrada
					If ! empty(SZF->ZF_PLACA) .or. ;
						! empty(SZF->ZF_MOTOR)
						MsgAlert("Entrada ja lancada para o pedido "+SZF->ZF_NUM,"Atencao","Alert")
						Return
					EndIf
				ElseIf _copcoes $ "3" //entrada+peso
					// Alterado por Rodrigo
					If SZF->ZF_PSENT <> 0
						MsgAlert("Peso ja lancado para o pedido "+SZF->ZF_NUM,"Atencao","Alert")
						Return
					Endif
					
					If SZF->ZF_OC <> SZ8->Z8_OC .And. !Empty(SZF->ZF_OC)
						MsgAlert("O pedido não consta na ordem de carregamento "+SZ8->Z8_OC,"Atencao","Alert")
						Return
					Endif
					
					If SZF->ZF_FRETE == "F"
						If SZF->ZF_PLACA <> SZ8->Z8_PLACA .Or. ;
							SZF->ZF_MOTOR <> SZ8->Z8_MOTOR
							MsgAlert("A Placa ou Motorista do pedido não conferem com os da OC!","Atencao","Alert")
							Return
						Endif
					Else
						If ( SZF->ZF_PSENT <> 0 .or. ;
							! empty(SZF->ZF_PLACA) .or. ;
							! empty(SZF->ZF_MOTOR) ) .and. sz8->z8_oc <> sZF->ZF_oc
							MsgAlert("Entrada e peso ja lancada para o pedido "+SZF->ZF_NUM,"Atencao","Alert")
							Return
						Endif
					EndIf
				Endif
				
				If _copcoes $ "1,3" //Se for entrada ou entrada+peso
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o pedido esta bloqueado                                      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If  SZF->ZF_LIBER == "B"
						MsgBox("Pedido Bloqueado!","Atencao","ALERT")
						Return
					End
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica limite de credito                                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If  SZF->ZF_LIBER <> "S"
						_lCredOk := .T.
						SMFATF26()
						If  ! _lCredOk
							MsgBox("Pedido Bloqueado por Credito!","Atencao","ALERT")
							Return
						End
					End
				EndIf
				
				
				if (sZF->ZF_unid == 'TL' .and. m->z8_sacgra <> 'G') .or. (sZF->ZF_unid $ 'UN/SC' .and. m->z8_sacgra == 'G')
					MsgBox("Tipo de carta diferente entre Pedido e Agenciamento ... ","Atencao","ALERT")
					return .F.
				endif
				
				
				//// SOMA O PESO PRA VALIDAÇÃO DA CAPACIADADE DO CAMINHAO
				/////////////////////////////////////////////////////////
				If SB1->(DbSeek( xFilial('SB1')+SZF->ZF_PRODUTO  )) .And. SB1->B1_UM $ 'SC*SA'
					If !Empty(SB1->B1_CONV)
						Do Case
							Case SB1->B1_TIPCONV=='M'
								nPesoTotal+= SZF->ZF_QUANT * SB1->B1_CONV
							Case SB1->B1_TIPCONV=='D'
								nPesoTotal+= SZF->ZF_QUANT / SB1->B1_CONV
							OtherWise
								nPesoTotal+= SZF->ZF_QUANT
						EndCase
					Endif
					
				Endif
				
				SZ4->(dbSetOrder(1))
				If SZ4->(DbSeek(xFilial("SZ4")+SZF->ZF_UFE+SZF->ZF_MUNE))
					nPedagio += SZ4->Z4_PEDAGIO
				EndIf
			EndIf
			DbSelectArea("SZF")
			DbSkip()
		EndDo
		
		SZF->(DbSetOrder(nordem))
		SZF->(DbGotop())
	EndIf
	
endif

_peso  := 0

// Executa as demais criticas.
If !SMFATF22(p_lGatilho)
	Return(.f.)
EndIf
If !SMFATF23()
	Return(.f.)
EndIf
If !SMFATF24(p_lGatilho)
	Return(.f.)
EndIf
If !SMFATF25()
	Return(.f.)
EndIf

// a vairavel nTotPedag, e' igual:   (somatorio do pedagio de todos os pedios) * (qtdEixosCaminhao + qtdEixosCarreta)
nTotPedag := npedagio * (_eixCam+_eixCar)
m->z8_pedagio:= nTotPedag

Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF22                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Verifica se o caminhao esta bloqueado                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF22(p_lGatilho)

Local ndias := 0
Local lret := .T., lachou
Local aAreaAtu := GetArea()

p_lGatilho := iif( p_lGatilho<>nil, p_lGatilho, .f. )

SZ2->(DbSetOrder(1))
lachou:=SZ2->(DbSeek(xFilial("SZ2")+_placa))
If lachou==.F.
	MsgBox("Placa nao existe, redigite.","Atencao","ALERT")
	lret := .F.
EndIf
If SZ2->Z2_TRAFEGO == "I"
	MsgBox("Atencao, veiculo nao aprovado em vistoria visual para trafego","Atencao","ALERT")
	lret := .F.
EndIf

//tratamento do carga do carro
Do Case
	Case  SZ2->Z2_PESOTRA = 0
		MsgBox("Atencao, o veiculo nao possui peso de transporte!!","Atencao","ALERT")
		lret := .F.
	Case  SZ2->Z2_PESOTRA > 0 .And. 	nPesoTotal > SZ2->Z2_PESOTRA .and. !p_lGatilho
		lret := .F.
		If MsgBox("Peso acima da capacidade maxima do veiculo. Liberar mesmo assim?  ","Escolha","YESNO")
			lRet:= u_SMFATT20('OC')
		Endif
EndCase

If SZ2->Z2_BLOQ == "S"
	MsgBox("Atencao, veiculo bloqueado!!","Atencao","ALERT")
	lret := .F.
EndIf
If SZ2->Z2_TIPO == "1"
	ndias := GETMV("MV_YDCAM")
Else
	ndias := GETMV("MV_YDCAME")
EndIf

If cEmpAnt == "20"
	_aAliOri  := GetArea()
	_aAliSZ8  := SZ8->(GetArea())
	_aAliZA9  := ZA9->(GetArea())
	
	ZA9->(dbSetOrder(2))
	If ZA9->(dbSeek(xFilial("ZA9") + _placa))
		_nDiaVist := GetMV("MZ_VENCVIS")
		
		If (ZA9->ZA9_DTVIST + _nDiaVist) < Date()
			MSGSTOP("VISTORIA DO CAMINHAO VENCIDA!!")
			lret := .F.
		Endif
	Else
		MSGSTOP("CONTROLE DE VISTORIA DO CAMINHAO NAO ENCONTRADA!!")
		lret := .F.
	Endif
	
	RestArea(_aAliZA9)
	RestArea(_aAliSZ8)
	RestArea(_aAliOri)
Else
	If SZ2->Z2_ULTC < ddatabase
		MsgBox("Atencao, vistoria atrasada !!! ","Atencao","ALERT")
		
		If ddatabase-ndias  > SZ2->Z2_ULTC .and. lret == .T.
			MsgBox("Atencao,favor atualizar os dados cadastrais do Caminhao antes de continuar.!!","Atencao","ALERT")
			lret := .F.
		EndIf
	EndIf
Endif
If 	!p_lGatilho .and. ( (_peso > SZ2->Z2_TARA + 500 ) .or. (_peso < SZ2->Z2_TARA - 500 ) )
	Alert("Atencao, existe diferenca do peso de entrada para a tara do caminhao")
EndIf
If SZ2->Z2_EIXOS == 0
	Alert("Atenção, Número de Eixos não cadastrado para este caminhão.Favor alterar o Cadatro de Caminhões")
	//lret := .F.
EndIf
_eixCam := SZ2->Z2_EIXOS
nTotPedag := npedagio * (_eixCam+_eixCar)

_motor := iif( !empty( M->Z8_MOTOR ), m->z8_motor, sz2->z2_mot )

if !p_lGatilho
	
	For ix := 1 TO Len(aPedMark)
		
		nNum	 := aPedMark[ix,1]
		cProduto := GetAdvfVal("SZF","ZF_PRODUTO",xFilial("SZF")+nNum,1)
		
		DbSelectArea("SZF")
		If GetAdvfVal("SB1","B1_YVEND",xFilial("SB1")+cProduto,1) = "S"   // em 23-12-08. A pedido da Marciane. Nao bloquear pedidos nao vendavel
			If GetAdvfVal("SZF","ZF_FRETE",xFilial("SZF")+nNum,1) = "F"
				If GetAdvfVal("SZ3","Z3_TIPO",xFilial("SZ3")+_motor,1) <> "3"
					Alert("Este Pedido é FOB, mas foi digitado um Motorista que não é Fob. Favor Corrigir")
					lret := .F.
				EndIf
			EndIf
		EndIf
		
		
		If GetAdvfVal("SZ3","Z3_TIPO",xFilial("SZ3")+_motor,1) == "3"
			If GetAdvfVal("SZF","ZF_FRETE",xFilial("SZF")+nNum,1) == "C"
				Alert("Este Pedido é CIF, mas foi digitado um Motorista que não é CIF. Favor Corrigir")
				lret := .F.
			EndIf
		EndIf
		
		SZF->(dbSetorder(1))
		If SZF->(dbSeek(xFilial("SZF")+nNum))
			If SZF->ZF_FRETE = "C"
				SZG->(dbSetOrder(1))
				If SZG->(!dbSeek(xFilial("SZG")+SZF->ZF_UFE + SZF->ZF_MUNE + SZ8->Z8_TRANSP + SZ8->Z8_LJTRANS +"L"))
					MSGALERT("FAVOR CADASTRAR TABELA DE PRECO REF. AO FRETE")
					lRet := .F.
				Endif
			Endif
		Endif
	Next
Endif

RestArea(aAreaAtu)

Return(lret)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF23                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Registra entrada do caminhao para carregamento             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF23()

Local aAreaAtu := GetArea()
Local lret := .T.,calias:=Alias(), ultd:=Ctod(Space(8))
Private ndias := GETMV("MV_YDMOT")

//_motor := M->Z8_MOTOR

If _copcoes $ "1,3" .and. Empty(_placa)
	MsgBox("Proibido dar entrada sem placa","Atencao","ALERT")
	Return
EndIf
DbSelectArea("SZ3")
DbSetOrder(1)
DbSeek(xFilial("SZ3")+_motor)
If SZ3->Z3_BLOQ == "S"
	MsgBox("Atencao, motorista bloqueado!!","Atencao","ALERT")
	lret := .F.
EndIf
If SZ3->Z3_BLOQ $ " N" .and. SZ3->Z3_ULTC < (ddatabase-ndias)
	//MsgBox("Atencao,favor atualizar os dados cadastrais do Motorista antes de continuar.!!","Atencao","ALERT")
	MsgBox("Atencao, A ultima atualização do Motorista foi em: [ " +dtoc(SZ3->Z3_ULTC) + " ], Conferir cadastro antes de continuar.","Atencao","ALERT")
	lret := .F.
EndIf

if lSenMot
	If empty(SZ3->Z3_SENHMOT)
		MsgBox("Atencao, Motorista sem S E N H A cadastrada !","Atencao","ALERT")
		//lret := .F.
	EndIf
endif

//validacao de pager
lret:= u_SMFATF31()


DbSelectArea(calias)
RestArea(aAreaAtu)

Return(lret)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF24                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Verifica se o caminhao esta bloqueado                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF24(p_lGatilho)
Local aAreaAtu := GetArea()

lret := .T.

SZZ->(DbSetOrder(1))
lachou:=SZZ->(DbSeek(xFilial("SZZ")+plcar))
If !lachou .and. !p_lGatilho
	MsgBox("Placa da carreta nao existe, redigite.","Atencao","ALERT")
	lret := .F.
EndIf

If SZZ->ZZ_EIXOS == 0 .AND. ! ( plcar $ "TRUCK  ,TOCO   ")
	Alert("Atenção, Número de Eixos não cadastrado para esta carreta.Favor alterar o Cadastro de Carretas")
	//lret := .F.
EndIf

_eixCar := SZZ->ZZ_EIXOS
nTotPedag := npedagio * (_eixCam+_eixCar)

If !Empty(plcar)
	If cEmpAnt == "20"
		_aAliOri  := GetArea()
		_aAliSZ8  := SZ8->(GetArea())
		_aAliZA9  := ZA9->(GetArea())
		
		ZA9->(dbSetOrder(2))
		If ZA9->(dbSeek(xFilial("ZA9") + plCar))
			_nDiaVist := GetMV("MZ_VENCVIS")
			
			If (ZA9->ZA9_DTVIST + _nDiaVist) < Date()
				MSGSTOP("VISTORIA DA CARRETA VENCIDA!!")
				lret := .F.
			Endif
		Else
			MSGSTOP("CONTROLE DE VISTORIA DA CARRETA NAO ENCONTRADA!!")
			lret := .F.
		Endif
		
		RestArea(_aAliZA9)
		RestArea(_aAliSZ8)
		RestArea(_aAliOri)
	Endif
Endif

RestArea(aAreaAtu)

Return(lret)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF25                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Registra entrada do caminhao para carregamento             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF25()
Local aAreaAtu := GetArea()
Local lret := .T.,calias:=Alias()

//cfornece := M->Z8_TRANSP

DbSelectArea("SA2")
DbSetOrder(1)
If !Empty(cfornece)
	If Empty(cLojaf)
		cLojaf := ""
	Endif
	If DbSeek(xFilial("SA2")+cfornece+clojaf)
		//Incluido por Gustav em 26/12/06
		If SA2->A2_YFORCTR <> "S"
			MsgBox("Fornecedor: "+cfornece+" não está cadastrado como Transportador"+Chr(13)+Chr(10)+"Favor atualizar o cadastro de fornecedores","Atencao","ALERT")
			lret := .F.
		EndIf
		//Incluido por Gustav em 26/12/06
		clojaf := SA2->A2_LOJA
	Else
		MsgBox("Transportador nao existe","Atencao","ALERT")
		lret := .F.
	EndIf
EndIf

RestArea(aAreaAtu)

Return(lret)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATT20                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function SMFATT20(wOpcao)
Local _senha    := space(10)
Local lRet:=.F.

//DEFINE MSDIALOG oDlg2 TITLE "Senha" FROM 05,03 TO 200,500 PIXEL
DEFINE MSDIALOG oDlg2 TITLE "SIGEX -  ( SENHA )" FROM 020, 000  TO 150, 300 COLORS 0, 16777215 PIXEL

@ 02,03 say "Senha:"
@ 02,10 get _senha PassWord
@ 40,80 BmpButton Type 1 Action Close(oDlg2)
Activate MsDialog oDlg2 Centered


wPsw:=""
Do Case
	Case wOpcao $ 'OC*SAIDA' // Ordem de Carregamento
		wPsw:= GetNewPar("MV_YSENCAR",GetMV("MV_YSENHA"))
EndCase
lRet:= (AllTrim(_senha) == AllTrim(wPsw))
If !lRet
	help("",1,"Y_MIZ008")
	Return .F.
End
Return lRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF26                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Verifica credito do cliente	                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


// Substituido pelo assistente de conversao do AP5 IDE em 28/06/00 ==> Function SMFATF26
Static Function SMFATF26()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acessa SA1 - Cadastro de Clientes                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+SZF->ZF_CLIENTE+SZF->ZF_LOJA)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa variaveis                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_lRet      := .T.
_lContinua := .T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica data de vencimento do limite de credito                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If  ddatabase > SA1->A1_VENCLC
	_lRet      := .F.
	_lContinua := .F.
End
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Risco "A" - credito liberado                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If  _lContinua  Desabilitado solicitacao da Marciane - 08/04/03
//    If  SA1->A1_RISCO == "A"
//        _lRet      := .T.
//        _lContinua := .F.
//    End
//End
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Risco "E" - credito bloqueado                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If  _lContinua
	If  SA1->A1_RISCO == "E"
		_lRet      := .F.
		_lContinua := .F.
	End
End
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica demais riscos                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If  _lContinua
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa variaveis                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_wSalSE1 := 0
	_wSalSZF := 0
	_wAtraso := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Determina saldo em aberto - SE1-Contas a Receber                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE1")
	dbSetOrder(2)
	dbSeek(xFilial("SE1")+SZF->ZF_CLIENTE+SZF->ZF_LOJA)
	While !eof() .and. SE1->E1_FILIAL  == xFilial("SE1")  ;
		.and. SE1->E1_CLIENTE == SZF->ZF_CLIENTE ;
		.and. SE1->E1_LOJA    == SZF->ZF_LOJA
		If  SE1->E1_SALDO == 0
			dbSkip()
			Loop
		End
		If  subs(SE1->E1_TIPO,3,1) == "-"
			_wSalSE1 := _wSalSE1 - SE1->E1_SALDO
		Else
			_wSalSE1 := _wSalSE1 + SE1->E1_SALDO
		End
		If  dtos(SE1->E1_VENCTO) < dtos(ddatabase)
			_wDias := ddatabase - SE1->E1_VENCTO
			If  _wDias > _wAtraso
				_wAtraso := _wDias
			End
		End
		dbSkip()
	End
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Determina saldo em aberto - SZF-Pedidos de Venda MIZU                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If  funname() == "MIZ020" .or. funname() == "#MIZ020"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Salva posicao SZF                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SZF")
		_wPosSZF := recno()
		_wCli    := SZF->ZF_CLIENTE
		_wLoj    := SZF->ZF_LOJA
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Determina saldo em aberto - SZF-Pedidos de Venda MIZU            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_wSalSZF := 0
		dbSelectArea("SZF")
		dbSetOrder(2)
		dbSeek(xFilial("SZF")+_wCli+_wLoj)
		While !eof() .and. SZF->ZF_FILIAL  == xFilial("SZF") ;
			.and. SZF->ZF_CLIENTE == _wCli           ;
			.and. SZF->ZF_LOJA    == _wLoj
			If  ! empty(SZF->ZF_NUMNF)
				dbSkip()
				Loop
			End
			_wSalSZF := _wSalSZF + (SZF->ZF_QUANT * SZF->ZF_PCOREF)
			dbSkip()
		End
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Restaura posicao SZF                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SZF")
		dbSetOrder(3)
		//        goto _wPosSZF
	End
	
	_lAchou := .F.
	ZA6->(dbSetOrder(1))
	If ZA6->(dbSeek(xFilial("ZA6") + SA1->A1_COD + SA1->A1_LOJA + "L"))
		//If  (_wSalSE1 + _wSalSZF) > ZA6->ZA6_VALOR .and. SA1->A1_RISCO <> "A"
		If  (_wSalSE1 + _wSalSZF) > ZA6->ZA6_VALOR .And. !SA1->A1_RISCO $ "A/S"
			_lAchou    := .T.
			_lRet      := .F.
			_lContinua := .F.
		Endif
		//ElseIf  (_wSalSE1 + _wSalSZF) > SA1->A1_LC .and. SA1->A1_RISCO <> "A"
	ElseIf  (_wSalSE1 + _wSalSZF) > SA1->A1_LC .and. !SA1->A1_RISCO $ "A/S"
		_lAchou    := .T.
		_lRet      := .F.
		_lContinua := .F.
	Endif
	
	If !_lAchou
		_wRisco := 0
		Do Case
			Case SA1->A1_RISCO $ "A/S"
				_wRisco := 0
			Case SA1->A1_RISCO == "B"
				_wRisco := getmv("MV_RISCOB")
			Case SA1->A1_RISCO == "C"
				_wRisco := getmv("MV_RISCOC")
			Case SA1->A1_RISCO == "D"
				_wRisco := getmv("MV_RISCOD")
		EndCase
		If  _wAtraso > _wRisco
			_lRet      := .F.
			_lContinua := .F.
		Endif
	Endif
Endif

_lCredOk := _lRet

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF27                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


//funcao para capturar o peso do aquivo .txt  gravado pelo software controlador das balancas
//
User Function SMFATF27(p_cTipo,p_cPort, p_cColeta)

private nHdll := 0
private cText := ''
private ComEnt := iif( p_cPort<>nil, p_cPort, GetMv("MV_YCOMENT") )
private cColeta:= "S"


If p_cTipo=="S" //saida
	_BalES := alltrim(getmv("MV_YBALSAI"))
	cText := 'SAIDA'
Else
	_BalES := alltrim(getmv("MV_YBALENT"))
	cText := 'ENTRADA'
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acessa arquivo da balanca                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If  ! file(_BalES)
	MsgBox("Arquivo de " + cText + " da Balanca nao existe!","Atencao","ALERT")
	Return ""
End
cText := ''


nVezes:= 5

procregua(5)

//if MsOpenPort(nHdll,+'"'+GetMv("MV_YCOMENT")+'"')
//If MsOpenPort(nHdll,"COM1:4800,E,8,2")
// apmsgalert('lendo peso balança')

lprosseguir:= MsOpenPort(nHdll,ComEnt)

if !lprosseguir
	apmsgalert('CC - Falha da ABERTURA da COM !')
else
	Inkey(0.9)
	
	lprosseguir:= MSRead(nHdll,@cText)
	if !lprosseguir
		apmsgalert('BB - falha na LEITURA da COM!')
	else
		
		nVez:=1
		while .t.
			nVez+=1
			
			incproc('AA - lendo... '+str(nvez,3)+' de '+str(nVezes,3))
			
			if SM0->M0_CODFIL == "21" .or. sm0->m0_codigo=='20'
				_peso := VAL(alltrim(substr(cText ,at(" ",cText)+1,12)))/100 //PesoContinuo()
			else
				//	apmsgalert('lendo peso balança 3')
				_peso := VAL(alltrim(substr(cText ,at(" ",cText)+1,8)))/100  //PesoContinuo()
				
			endif
			
			cText := substr(cText ,at(" ",cText))
			if _peso > 0 .or. nVez > nVezes
				exit
			elseif Mod(10,5) == 0
				nHdll := 0
				cText := ''
				MsClosePort(nHdll)
				MSRead(nHdll,@cText)
			endif
		enddo
	endif
	
	If _peso >= 88888
		Alert("Atencao, peso da balanca esta ERRADO. VERIFIQUE!")
	EndIf
	MsClosePort(nHdll)
	MSRead(nHdll,@cText)
endif


//se houver falha na leitura via porta COM1 ou nao achou o aquivo texto
if !lprosseguir .or. _peso ==0
	
	_peso     := iif( subs(memoread(_BalES),11,1)=='/','"'+ AllTrim( subs(memoread(_BalES),1,10) ) ,subs(memoread(_BalES),1,10))
	If !(Subs(_peso,1,1) $ '0123456789')
		_peso    := Subs(_peso,2,7)
		_peso     := val(_peso)
	Else
		_peso     := val(_peso) / 100
	EndIf
	If _peso >= 88888
		Alert("Atencao, peso da balanca esta ERRADO. VERIFIQUE!")
	EndIf
EndIf

p_cColeta:= iif( _peso==0,"","S")

Return _peso


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF28                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Registra entrada do caminhao para carregamento             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF28()
Private ccli:=Space(8);cprod:=Space(15)
Private lregra := .F.
Private cctr:=Space(6),npedagio:=0,aenvio:={},_numOC:="000000"
_numOC := M->Z8_OC

If  Empty(cpm)
	MsgBox("Escolher TIPO DE CARREGAMENTO ( Palet/Manual ) !","Atencao","ALERT")
	Return
EndIf


Begin transaction
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava SZ8 - Grava o controle do trafego da carga/descarga                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza SZF - Pedido de Vendas MIZU                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _copcoes $ "2"
	Reclock ("SZ8",.F.)
	SZ8->Z8_PSENT    := _peso
	SZ8->Z8_HORPES   := left(time(),5)
	MsUnlock()
	DbSelectArea("SZF")
	DbSetOrder(8)
	DbSeek(xFilial("SZF")+SZ8->Z8_OC)
	Do while .not. eof() .and. ZF_FILIAL == xFilial("SZF") .and. SZF->ZF_OC == SZ8->Z8_OC
		While !Reclock ("SZF",.F.);EndDo
		SZF->ZF_PSENT    := _peso
		MsUnlock()
		DbSkip()
	EndDo
Else
	DbSelectArea("SZF")
	nordem := IndexOrd()
	DbSetOrder(0)
	DbGotop()
	Do while .not. eof()
		//If Posicione("SZF",1,xFilial("SZF")+SZF->ZF_NUM,"ZF_NUM")  // forço a busca no arquivo caso outro usuário simultaneamente tenha usado este pedido em outra OC.
		//EndIf
		If Marked("ZF_OK")
			Reclock ("SZF",.F.)
			If !Empty(SZF->ZF_OC) .and. sZF->ZF_oc <> sz8->z8_oc //Caso outro usuário simultaneamente tenha usado este pedido em outra OC.
				MsgBox("ATENÇÃO: O pedido " +ALLTRIM(SZF->ZF_NUM)+ " está agenciado na OC: "+ALLTRIM(SZF->ZF_OC)+". Selecione outro pedido.","Atencao","STOP")
				SZF->(msUnlock())
				ROLLBACK TRANSACTION
				Return
			EndIf
			SZF->ZF_YPM := cpm
			SZF->ZF_OC		 := M->Z8_OC
			If _copcoes $ "3"
				SZF->ZF_PSENT    := _peso
			EndIf
			If _copcoes $ "1,3"
				SZF->ZF_MOTOR    := _motor
				SZF->ZF_PLCAR    := plcar
				SZF->ZF_HORENT   := _hora
				SZF->ZF_PALENT   := _pent
				SZF->ZF_PALSAI   := _psai
				SZF->ZF_NMOT     := SZ3->Z3_NOME
				SZF->ZF_FORNECE  := cfornece
				SZF->ZF_LOJAF    := clojaf
				SZF->ZF_LACRE    := _lacre
			EndIf
			msUnlock()
			dbCommit()
		EndIf
		DbSkip()
	EndDo
	DbSelectArea("SZF")
	DbSetOrder(nordem)
	DbGotop()
	
	
	//SMFATF33()
	
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recalcular o frete                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _copcoes $ "1,3"  //.and. !lBlqFrete //bloqueia alterações nos valores do frete
	DbSelectArea("SZF")
	nordem := IndexOrd()
	DbSetOrder(0)
	DbGotop()
	Do while .not. eof()
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SZF->ZF_CLIENTE+SZF->ZF_LOJA))
		If Marked("ZF_OK") .and. SA1->A1_YFRECLI == 0
			SZ3->(DbSetOrder(1))
			SZ3->(DbSeek(xFilial("SZ3")+_motor))
			
			If SZF->ZF_UNID == "SC"
				
				If  SZ3->Z3_TIPO == "1" .and. Empty(cFornece)
					MsgBox("Voce esta lancando um transporte com CTR, Sem Transportadora","Atencao","STOP")
					ROLLBACK TRANSACTION
					Return
				ElseIf SZ3->Z3_TIPO == "2" .and. !Empty(cFornece)
					MsgBox("Voce esta lancando um transporte com Motorista RPA, usando CTR","Atencao","STOP")
					ROLLBACK TRANSACTION
					Return
				EndIf
				
				SB1->(dbSetOrder(1))								//// ALTERADO 11/01/12
				SB1->(dbSeek(xFilial("SB1")+SZF->ZF_PRODUTO))		//// ALTERADO 11/01/12
				
				If Alltrim(SB1->B1_TIPCAR) == "S"	    			//// ALTERADO 11/01/12
					_nQtde := (SZF->ZF_QUANT * SB1->B1_CONV) / 1000 //// ALTERADO 11/01/12
				Else												//// ALTERADO 11/01/12
					_nQtde := SZF->ZF_QUANT 						//// ALTERADO 11/01/12
				Endif												//// ALTERADO 11/01/12
				
				IF SZF->ZF_FRETE == "C"
					If  SZ3->Z3_TIPO == "1" /* CTR SZG */
						SZG->(DbSetOrder(1))
						SZG->(DbSeek(xFilial("SZG")+SZF->ZF_UFE+SZF->ZF_MUNE+cFornece + cLojaf +"L"))
						While !Reclock("SZF",.f.);EndDo
						
						SZF->ZF_FTRA := Round(_nQtde * Iif(SZ3->Z3_AGREGA=="S",SZG->ZG_FAGRTRA,SZG->ZG_FRETE) ,2) //// ALTERADO 11/01/12
						SZF->ZF_FMOT := Round(_nQtde * Iif(SZ3->Z3_AGREGA=="S",SZG->ZG_FAGRMOT,SZG->ZG_FMOT) ,2)  //// ALTERADO 11/01/12
						
					Else /* RPA SZ4 */
						SZ4->(DbSetOrder(1))
						SZ4->(DbSeek(xFilial("SZ4")+SZF->ZF_UFE+SZF->ZF_MUNE))
						
						While !Reclock("SZF",.f.);EndDo
						
						SZF->ZF_FTRA := Round(_nQtde * Iif(SZ3->Z3_AGREGA=="S",SZ4->Z4_FAGRTRA,SZ4->Z4_FRETE) ,2) //// ALTERADO 11/01/12
						SZF->ZF_FMOT := Round(_nQtde * Iif(SZ3->Z3_AGREGA=="S",SZ4->Z4_FAGRMOT,SZ4->Z4_FMOT) ,2)  //// ALTERADO 11/01/12
					EndIf
				ENDIF
				
				SZF->(MsUnlock())
			EndIf
		EndIf
		DbSelectArea("SZF")
		DbSkip()
	EndDo
	SZF->(DbSetOrder(nordem))
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificar o maior frete para regravar no pedido                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _copcoes $ "1,3"  .and. !lBlqFrete //bloqueia alterações nos valores do frete
	
	_aAliSB1 := SB1->(GetArea()) //// ALTERADO 11/01/12
	
	SZ3->(DbSetOrder(1))
	SZ3->(DbSeek(xFilial("SZ3")+_motor))
	
	nvalmotm := 0
	nvaltram := 0
	DbSelectArea("SZF")
	nordem := IndexOrd()
	DbSetOrder(0)
	DbGotop()
	Do while .not. eof()
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SZF->ZF_CLIENTE+SZF->ZF_LOJA))
		
		SB1->(dbSetOrder(1))								//// ALTERADO 11/01/12
		SB1->(dbSeek(xFilial("SB1")+SZF->ZF_PRODUTO))		//// ALTERADO 11/01/12
		
		If Alltrim(SB1->B1_TIPCAR) == "S"	    			//// ALTERADO 11/01/12
			_nQtde := (SZF->ZF_QUANT * SB1->B1_CONV) / 1000 //// ALTERADO 11/01/12
		Else												//// ALTERADO 11/01/12
			_nQtde := SZF->ZF_QUANT 						//// ALTERADO 11/01/12
		Endif												//// ALTERADO 11/01/12
		
		If Marked("ZF_OK") .and. SZF->ZF_FRETE == "C" .and. SA1->A1_YFRECLI == 0
			If cEmpAnt == "01"
				If cfilant == "03" .or. ;
					(SZ3->Z3_AGREGA == "S" .and. SZ3->Z3_TIPO == "1" .and. Alltrim(SZF->ZF_UFE)=="ES") .or. ;
					(SZ3->Z3_AGREGA == "N" .and. SZ3->Z3_TIPO == "1" .and. Alltrim(SZF->ZF_UFE)$"RJ,MG,ES")
					If Round(SZF->ZF_FMOT / _nQtde,4) > nvalmotm     //// ALTERADO 11/01/12
						nvalmotm  := Round(SZF->ZF_FMOT / _nQtde,4)  //// ALTERADO 11/01/12
						nvaltram  := Round(SZF->ZF_FTRA / _nQtde,4)  //// ALTERADO 11/01/12
					EndIf
				EndIf
			ElseIf cEmpAnt == "11"
				If Round(SZF->ZF_FMOT / _nQtde,4) > nvalmotm		 //// ALTERADO 11/01/12
					nvalmotm  := Round(SZF->ZF_FMOT / _nQtde,4)		 //// ALTERADO 11/01/12
					nvaltram  := Round(SZF->ZF_FTRA / _nQtde,4)		 //// ALTERADO 11/01/12
				EndIf
			EndIf
		EndIf
		DbSkip()
		If Marked("ZF_OK") .and. SZF->ZF_FRETE == "C" .and. Round(SZF->ZF_FTRA / _nQtde,4) <> nvaltram .and. nvaltram > 0 //// ALTERADO 11/01/12
			lregra := .F.
		EndIf
	EndDo
	SZF->(DbSetOrder(nordem))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravar o valor do pedido encontrado                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SZF")
	nordem := IndexOrd()
	DbSetOrder(0)
	DbGotop()
	Do while .not. eof()
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SZF->ZF_CLIENTE+SZF->ZF_LOJA))
		
		SB1->(dbSetOrder(1))								//// ALTERADO 11/01/12
		SB1->(dbSeek(xFilial("SB1")+SZF->ZF_PRODUTO))		//// ALTERADO 11/01/12
		
		If Alltrim(SB1->B1_TIPCAR) == "S"	    			//// ALTERADO 11/01/12
			_nQtde := (SZF->ZF_QUANT * SB1->B1_CONV) / 1000 //// ALTERADO 11/01/12
		Else												//// ALTERADO 11/01/12
			_nQtde := SZF->ZF_QUANT 						//// ALTERADO 11/01/12
		Endif												//// ALTERADO 11/01/12
		
		If Marked("ZF_OK") .and. SZF->ZF_FRETE == "C" .and. nvalmotm > 0 .and. SA1->A1_YFRECLI == 0
			While !Reclock("SZF",.f.);EndDo
			SZF->ZF_FTRA := Round(nvaltram * _nQtde,2) 		//// ALTERADO 11/01/12
			SZF->ZF_FMOT := Round(nvalmotm * _nQtde,2)		//// ALTERADO 11/01/12
			MsUnlock()
		EndIf
		DbSkip()
	EndDo
	
	RestArea(_aAliSB1)
	
	SZF->(DbSetOrder(nordem))
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificar varias entregas  para o mesmo municipio                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _copcoes $ "1,3"  .and. !lBlqFrete //bloqueia alterações nos valores do frete
	SZ3->(DbSetOrder(1))
	SZ3->(DbSeek(xFilial("SZ3")+_motor))
	
	If SZ3->Z3_AGREGA == "N"
		If cEmpAnt <> "10"
			nacfre  := GetMV("MV_YACFRE")
			nmulfre := GetMV("MV_YMULFRE")
			ndivfre := GetMV("MV_YDIVFRE")
			cmun  := Space(15)
			cuf   := Space(2)
			ccli  := Space(8)
			cprod := Space(15)
			lprimeiro := .T.
			lacres := .F.
			DbSelectArea("SZF")
			nordem := IndexOrd()
			DbSetOrder(0)
			DbGotop()
			Do while .not. eof()
				SA1->(DbSetOrder(1))
				SA1->(DbSeek(xFilial("SA1")+SZF->ZF_CLIENTE+SZF->ZF_LOJA))
				If Marked("ZF_OK") .and. SZF->ZF_FRETE == "C" .and. SA1->A1_YFRECLI == 0
					If lprimeiro
						cmun  := SZF->ZF_MUNE
						cuf   := SZF->ZF_UFE
						ccli  := SZF->ZF_CLIENTE+SZF->ZF_LOJA
						cprod := SZF->ZF_PRODUTO
						lprimeiro := .F.
					Else
						If SZF->ZF_MUNE == cmun .and. SZF->ZF_UFE == cuf
							If SZF->ZF_CLIENTE+SZF->ZF_LOJA <> ccli
								lacres := .T.
								Exit
							EndIf
						EndIf
					EndIf
				EndIf
				DbSkip()
			EndDo
			If lacres .and. !Alltrim(Upper(SZF->ZF_UFE)) $ "BA" .and. lregra == .F.
				lregra := .T.
				DbSelectArea("SZF")
				DbSetOrder(0)
				DbGotop()
				Do while .not. eof()
					SA1->(DbSetOrder(1))
					SA1->(DbSeek(xFilial("SA1")+SZF->ZF_CLIENTE+SZF->ZF_LOJA))
					
					SB1->(dbSetOrder(1))								//// ALTERADO 11/01/12
					SB1->(dbSeek(xFilial("SB1")+SZF->ZF_PRODUTO))		//// ALTERADO 11/01/12
					
					If Alltrim(SB1->B1_TIPCAR) == "S"	    			//// ALTERADO 11/01/12
						_nQtde := (SZF->ZF_QUANT * SB1->B1_CONV) / 1000 //// ALTERADO 11/01/12
					Else												//// ALTERADO 11/01/12
						_nQtde := SZF->ZF_QUANT 						//// ALTERADO 11/01/12
					Endif												//// ALTERADO 11/01/12
					
					If Marked("ZF_OK") .and. SZF->ZF_FRETE == "C" .and. SA1->A1_YFRECLI == 0
						While !Reclock("SZF",.f.);EndDo
						IF !(SZ2->Z2_PLACA $ GETMV("MIZ_PLACAS"))
							SZF->ZF_FMOT := SZF->ZF_FMOT+Round(_nQtde * nacfre,2)                              //// ALTERADO 11/01/12
							SZF->ZF_FTRA := SZF->ZF_FTRA+Round(_nQtde * (Round(nacfre * nmulfre/ndivfre,2)),2) //// ALTERADO 11/01/12
						ENDIF
						MsUnlock()
					EndIf
					DbSkip()
				EndDo
			EndIf
			SZF->(DbSetOrder(nordem))
		EndIf
	EndIf
EndIf

If _copcoes $ "1,3"  .and. !lBlqFrete //bloqueia alterações nos valores do frete
	SZ3->(DbSetOrder(1))
	SZ3->(DbSeek(xFilial("SZ3")+_motor))
	
	If SZ3->Z3_AGREGA == "N"
		If cEmpAnt <> "10"
			nacfre  := GetMV("MV_YACFRE")
			nmulfre := GetMV("MV_YMULFRE")
			ndivfre := GetMV("MV_YDIVFRE")
			cmun    := Space(15)
			cuf     := Space(2)
			nvaltra := 0
			nvalmot := 0
			lprimeiro := .T.
			lacres := .F.
			DbSelectArea("SZF")
			nordem := IndexOrd()
			DbSetOrder(0)
			DbGotop()
			Do while .not. eof()
				SA1->(DbSetOrder(1))
				SA1->(DbSeek(xFilial("SA1")+SZF->ZF_CLIENTE+SZF->ZF_LOJA))
				
				SB1->(dbSetOrder(1))								//// ALTERADO 11/01/12
				SB1->(dbSeek(xFilial("SB1")+SZF->ZF_PRODUTO))		//// ALTERADO 11/01/12
				
				If Alltrim(SB1->B1_TIPCAR) == "S"	    			//// ALTERADO 11/01/12
					_nQtde := (SZF->ZF_QUANT * SB1->B1_CONV) / 1000 //// ALTERADO 11/01/12
				Else												//// ALTERADO 11/01/12
					_nQtde := SZF->ZF_QUANT 						//// ALTERADO 11/01/12
				Endif												//// ALTERADO 11/01/12
				
				If Marked("ZF_OK") .and. SZF->ZF_FRETE == "C" .and. SA1->A1_YFRECLI == 0
					nvaltra += Round(SZF->ZF_FTRA / _nQtde,6)		//// ALTERADO 11/01/12
					nvalmot += Round(SZF->ZF_FMOT / _nQtde,6)		//// ALTERADO 11/01/12
					
					If lprimeiro
						cmun    := SZF->ZF_MUNE
						cuf     := SZF->ZF_UFE
						lprimeiro := .F.
					Else
						If SZF->ZF_MUNE <> cmun .and. ;
							Round(SZF->ZF_FTRA / _nQtde,6) == nvaltra .and. Round(SZF->ZF_FMOT / _nQtde,6) == nvalmot //// ALTERADO 11/01/12
							lacres := .T.
						EndIf
						If Round(SZF->ZF_FTRA / _nQtde,6) <> nvaltra .or. Round(SZF->ZF_FMOT / _nQtde,6) <> nvalmot //// ALTERADO 11/01/12
							lacres := .F.
							exit
						EndIf
					EndIf
				EndIf
				DbSkip()
			EndDo
			If lacres .and. !Alltrim(Upper(SZF->ZF_UFE)) $ "BA" .and. lregra == .F.
				lregra := .F.
				DbSelectArea("SZF")
				DbSetOrder(0)
				DbGotop()
				Do while .not. eof()
					SA1->(DbSetOrder(1))
					SA1->(DbSeek(xFilial("SA1")+SZF->ZF_CLIENTE+SZF->ZF_LOJA))
					
					SB1->(dbSetOrder(1))								//// ALTERADO 11/01/12
					SB1->(dbSeek(xFilial("SB1")+SZF->ZF_PRODUTO))		//// ALTERADO 11/01/12
					
					If Alltrim(SB1->B1_TIPCAR) == "S"	    			//// ALTERADO 11/01/12
						_nQtde := (SZF->ZF_QUANT * SB1->B1_CONV) / 1000 //// ALTERADO 11/01/12
					Else												//// ALTERADO 11/01/12
						_nQtde := SZF->ZF_QUANT 						//// ALTERADO 11/01/12
					Endif												//// ALTERADO 11/01/12
					
					If Marked("ZF_OK") .and. SZF->ZF_FRETE == "C" .and. SA1->A1_YFRECLI == 0
						While !Reclock("SZF",.f.);EndDo
						IF !(SZ2->Z2_PLACA $ GETMV("MIZ_PLACAS"))
							SZF->ZF_FMOT := SZF->ZF_FMOT+Round(_nQtde * nacfre,2) //// ALTERADO 11/01/12
							SZF->ZF_FTRA := SZF->ZF_FTRA+Round(_nQtde * (Round(nacfre*nmulfre/ndivfre,2)),2) //// ALTERADO 11/01/12
						ENDIF
						MsUnlock()
					EndIf
					DbSkip()
				EndDo
			EndIf
			SZF->(DbSetOrder(nordem))
		EndIf
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Ordem de Carregamento                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _copcoes $ "1,3"
	Aadd(aenvio,_placa)
	Aadd(aenvio,_motor)
	Aadd(aenvio,_peso)
	Aadd(aenvio,cctr)
	Aadd(aenvio,nTotPedag)
	Aadd(aenvio,cfornece)
	Aadd(aenvio,_numOC)
	Aadd(aenvio,cpm)
	Aadd(aenvio,plcar)
	Aadd(aenvio,cLojaF)
	
	IF AllTrim(SuperGetMV("MV_OCUSAGR",.F.,"N")) == "S"
		ExecBlock("MIZ050GR",.F.,.F.,aenvio)  // Esse fonte grava os regs na SZ8 e NR.OC NA SZF e imprime a OC.
	ELSE
		ExecBlock("MIZ050",.F.,.F.,aenvio)	  // Esse fonte grava os regs na SZ8 e NR.OC NA SZF e imprime a OC.
	ENDIF
	
	// Abaixo as gravacoes nos novos campos da SZ8
	dbSelectArea("SZ8")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ8")+M->Z8_OC)
		While !Reclock("SZ8",.f.);EndDo
		SZ8->Z8_SACGRA      := M->Z8_SACGRA
		SZ8->Z8_LACRE		:= M->Z8_LACRE
		SZ8->Z8_TPOPER		:= M->Z8_TPOPER
		SZ8->Z8_PAGER		:= M->Z8_PAGER
		//SZ8->Z8_STATUS2		:= "1" //No pátio
		MsUnlock()
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizar placa no final para resolver problema no filtro                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _copcoes $ "1,3"
	DbSelectArea("SZF")
	nordem := IndexOrd()
	DbSetOrder(0)
	DbGotop()
	Do while .not. eof()
		If Marked("ZF_OK")
			Reclock ("SZF",.F.)
			SZF->ZF_PLACA    := _placa
			MsUnlock()
		EndIf
		DbSkip()
	EndDo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Encerra funcao                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

End Transaction

Return(.T.)


/** BOTAO LEGENDA - MOSTRA AS CORES **/
/*
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//

#define CLR_BLACK             0               // RGB(   0,   0,   0 )
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 )
#define CLR_GREEN         32768               // RGB(   0, 128,   0 )
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 )
#define CLR_RED             128               // RGB( 128,   0,   0 )
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 )
#define CLR_BROWN         32896               // RGB( 128, 128,   0 )
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 )
#define CLR_LIGHTGRAY
*/


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF29                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function SMFATF29


Brwlegenda(cCadastro, "Legenda",{{"BR_BRANCO"  ,"Não Agenciado"},;
{"BR_LARANJA" ,"Agenciado - Programado"},;
{"BR_AMARELO" ,"Agenciado - No Patio"},;
{"BR_VERDE"   ,"Chamado"},;
{"BR_PINK"    ,"Pesado na Entrada"},;
{"BR_AZUL"    ,"Início Carga/Descarga"},;
{"BR_PRETO"   ,"Fim Carga/Descarga"},;
{"BR_VERMELHO","Em Espera"},;
{"BR_MARROM"  ,"F a t u r a d a"}})
Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF30                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function SMFATF30(p_cComutadora)

Local cComutadora := iif(p_cComutadora== NIL, '00', p_cComutadora)
TerServ(cComutadora)
Return

Static Function fRegDesc()
Local lres := .T.

dbSelectArea('SC7')
dbsetorder(1)
For ixd := 1 TO Len(aPedMark)
	If dbSeek(xFilial('SC7')+aPedMark[ixd,1])
		While !RecLock("SC7",.F.) ; End
		
		If !Empty(SC7->C7_YOC)
			MsgBox("ATENÇÃO: O pedido " +ALLTRIM(aPedMark[ixd,1])+ " está agenciado na OC: "+ALLTRIM(SC7->C7_YOC)+". Selecione outro pedido.","Atencao","STOP")
		EndIf
		
		SC7->C7_YOC = M->Z8_OC
		SC7->(MsUnlock())
	EndIf
Next

Return(lres)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF31                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


user Function SMFATF31()
local lcontinua:=.t.
local lRes := .T.
local nMaxPager:= GETMV("MV_MAXPAGE")
local aAreaAtu := GetArea()


if !lusaPager; return lres ; endif

If Empty(M->Z8_STATUS2) ; return (lRes); endif


do case
	case Empty(M->Z8_PAGER)
		ALERT("Informe o número do pager.")
		lcontinua:= .f.
	case val(M->Z8_PAGER)<=0 .and. M->Z8_PAGER<>"ZZ"
		ALERT("O campo PAGER,  aceita apenas numeros !")
		lcontinua:= .f.
	case val(M->Z8_PAGER)<=0 .and. M->Z8_PAGER="ZZ" .and. len(u_PXH05301())>0
		ALERT("O pager ZZ só pode ser usado quando não tiver mais pagers disponiveis.")
		lcontinua:= .f.
	case val(M->Z8_PAGER) > nMaxPager
		ALERT("A numeração do pager deve ser menor ou igual a [ '"+strzero(nMaxPager,2)+"' ]")
		lcontinua:= .f.
	otherwise
		
		
		cSql := "SELECT Z8_OC,Z8_PAGER FROM "+RetSqlName("SZ8")+" SZ8 "
		cSql += " WHERE SZ8.D_E_L_E_T_ = ' '"
		cSql += " AND   SZ8.Z8_FILIAL  = '" +xFilial("SZ8")+ "'"
		cSql += " AND   SZ8.Z8_PAGER   = '" + M->Z8_PAGER + "'"
		cSql += " AND   SZ8.Z8_OC   <> '" + M->Z8_OC + "'"
		
		If Select("QrySZ8") > 0
			dbSelectArea("QrySZ8")
			QrySZ8->(DbCloseArea())
		EndIf
		
		TcQuery cSql New Alias "QrySZ8"
		
		If  QrySZ8->(!Eof()) .AND. QrySZ8->Z8_PAGER <> "ZZ"
			ALERT("Nº DE PAGER NÃO PERMITIDO: Este pager já está sendo usado na ORDEM DE CARREGAMENTO/DESCARREGAMENTO: "+Alltrim(QrySZ8->Z8_OC)+". Verifique.")
			QrySZ8->(DbCloseArea())
			RestArea(aAreaAtu)
			lRes := .F.
			lcontinua:=.f.
		EndIf
		
endcase

if !lcontinua
	sz8->(dbsetorder(1))
	sz8->(dbseek(xfilial('SZ8')+M->Z8_OC))
	cPgOld:= sz8->z8_pager
	M->Z8_PAGER := u_PXH053(cPgOld)
	M->Z8_CBPAGER := cValtoChar(10000000 + val(M->Z8_PAGER) )
endif

lRes := !empty(M->Z8_PAGER)
RestArea(aAreaAtu)

Return(lRes)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATT14                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function SMFATT14(p_cLacre)

Local cRet:=""
local cLacre := Space(6)
local oFont1     := TFont():New( "Verdana",0,-12,,.T.,0,,700,.F.,.F.,,,,,, )
local warea:= getArea()

private oLacre
private oBrw1

If cEmpAnt $ "01/11/30"
	cLacre := Space(8)
Endif

nOpc1:=0

ctpRefresh:= '0'

aColsLacre:={}
aAux:={}
if p_clacre <> nil .and. !empty(p_clacre)
	aAux:= STRTOKARR(p_clacre,"/")
	for xi:=1 to len(aaux)
		AAdd(aColsLacre,{aaux[xi]})
	next
	ctpRefresh:= '3'
endif


DbSelectArea("SX3")
DbSetOrder(2) // Nome Campo

waHeader:={}
waColSizes:={}
dbSeek("Z8_LACRE");aAdd(waHeader, Trim(X3Titulo()) ) 			 ; aAdd(waColSizes,6)

oDlg      := MSDialog():New( 69,33 ,440,355,"Digitação dos Nrs. dos Lacres",,,.F.,,,,,,.T.,,,.T. )

@ 001.3,003 GET oLacre VAR cLacre SIZE 100, 10 OF oDlg //valid SMFATT15(cLacre)
oLacre:bLostFocus:=  {|| SMFATT15('1', cLacre), oDlg:refresh() }

oBrw1 := TCBrowse():New( 030,005,150,140,,waHeader,waColSizes,oDlg,,,,,{||},,oFont1,,,,,.F.,,.T.,,.F.,,.T.,.T.)

SMFATT15(	ctpRefresh )


ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpc1 := 1, cRet:=SMFATF32(), oDlg:End()},{|| nOpc1 := 2,oDlg:End()}) CENTERED



restArea(warea)
Return(cRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF32                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF32()

Local cRet:=""
Local wArea:=GetArea()

cRet:=""
For i:=1 to len(acolsLacre)
	if empty(acolsLacre[i,1]); loop; endif
	
	if !Empty(cRet)
		cRet+= "/"
	endif
	
	cRet+=alltrim(acolsLacre[i,1])
	
Next

RestArea(wArea)
Return(cRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATT15                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


static function SMFATT15(p_ctpRefresh, p_cGetLacre)
local lret:= .t.
local nMaxLacre:= 8

if p_ctpRefresh=='1' .and. empty(p_cGetLacre); return .f. ; endif


ncont:=0

For i:=1 to len(acolsLacres)
	
	ncont++
	
	If alltrim(acolsLacres[i,1]) == alltrim(p_cGetlacre)
		alert('Lacre ja informado na posicao de nr. [ '+str(i,2)+' ]')
		aDel( acolsLacres, i )
		aSize( acolsLacres, Len(acolsLacres)-1 )
		lret:= .f.
		exit
	Endif
Next

if lret
	lret:= ( ncont<=nMaxLacre )
	if !lret
		Alert('Sao permitidos ate 8 lacres!')
	endif
endif

if lret .and. p_ctpRefresh $ '0|1'
	
	if p_ctpRefresh=='0'
		p_cGetLacre:=space(6)
	endif
	
	aListAux :={}
	
	aListAux :={ p_cGetLacre }
	
	aAdd(acolsLacre, aListAux)
	
endif

oBrw1:SetArray(acolsLacre)
oBrw1:bLine := {|| { oBrw1:aArray[oBrw1:nAt,01] }}
oBrw1:refresh()

oLacre:setfocus()

return lret


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF33                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


static function SMFATF33()
local warea:= getArea()

If SZ8->Z8_TPOPER == "C" .AND. Len(aPedDesMar)<>0
	dbSelectArea('SZF')
	dbsetorder(1)
	For ixd := 1 TO Len(aPedDesMar)
		If dbSeek(xFilial('SZF')+aPedDesMar[ixd,1]) .and. sZF->ZF_oc == sz8->z8_oc
			While !RecLock("SZF",.F.) ; End
			SZF->ZF_OC = " "
			SZF->ZF_PLACA = SPACE(07)
			SZF->ZF_MOTOR = " "
			SZF->ZF_HORENT := Space(05)
			SZF->ZF_NMOT   := Space(40)
			SZF->(MsUnlock())
		EndIf
	Next
ElseIf SZ8->Z8_TPOPER == "D" .AND. Len(aPedDesMar)<>0 .and. sZF->ZF_oc == sz8->z8_oc
	dbSelectArea('SC7')
	dbsetorder(1)
	For ixd := 1 TO Len(aPedDesMar)
		If dbSeek(xFilial('SC7')+aPedDesMar[ixd,1])
			While !RecLock("SC7",.F.) ; End
			SC7->C7_YOC = " "
			SC7->(MsUnlock())
		EndIf
	Next
EndIf

restArea(warea)

return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATT16                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Altera peso calculado, mediante senha                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function SMFATT16(p_nPeso)

If  (SZF->ZF_UNID $ "SC,SA")  .and. (p_nPeso==nil)
	alert('Nao permitida alteração de peso para as UNIDADES - SC/SA ')
	return ("")
Endif

_peso_liqinf:=0

If !sx6->(DbSeek(xfilial('SX6')+'MV_YDTSEN'))
	if sx6->(reclock('SX6',.t.))
		sx6->x6_fil:= xfilial('SX6')
		sx6->x6_var := 'MV_YDTSEN'
		sx6->x6_tipo := 'C'
		sx6->x6_descric:= 'Data de liberacao para usar o botao peso manual'
		sx6->x6_conteud:= ''
	endif
	sx6->(msunlock())
endif

If !empty(getMV('MV_YDTSEN')) .and. getMV('MV_YDTSEN') <> DTOS(DDATABASE)
	if !u_smvldPsw('PESOMANUAL')
		help("",1,"Y_MIZ008")
		Return ("")
	endif
	
	putMV('MV_YDTSEN',DTOS(DATE()))
	
Endif

DEFINE MSDIALOG oDlgNewPeso TITLE "Quantidade Saida" FROM 40,50 TO 200,400 PIXEL
@ 40,15 say "Peso Liquido: (TL)"
@ 40,70 get _peso_liqinf  Size 60,100   Pict "999,999,999.99"
@ 60,100 BmpButton Type 1 Action Close(oDlgNewPeso)
Activate MsDialog oDlgNewPeso Centered
If  !(SZF->ZF_UNID $ "SC,SA")  .AND. (p_nPeso==nil)
	_peso_liq      := _peso_liqinf
	ypalt:="S"
	odlg1:refresh()
EndIf

If p_nPeso<> nil
	p_nPeso:=_peso_liqinf
Endif

Return iif(_peso_liqinf>0 ,"M","" )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF34                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Altera peso calculado, mediante senha                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function SMFATF34(cAlias,nReg,nOpc,aPosicao)

Local aCampos  := {"Z8_OC","Z8_DATA","Z8_HORA","Z8_HRAGENC","Z8_TPOPER","Z8_PRODUTO","Z8_QUANT","Z8_PALLET","Z8_PLTEN","Z8_PLTSA","Z8_PAGER","Z8_LACRE","Z8_SACGRA","Z8_OBS","Z8_USUARIO","Z8_NFCOMP","Z8_SERNF","Z8_NFPESEN","Z8_TICKENT","Z8_PATIO","Z8_CATEGMP","Z8_CBPAGER","Z8_LOCCARR","NOUSER"}
Local aEdit    := {"Z8_OC","Z8_DATA","Z8_HORA","Z8_HRAGENC","Z8_TPOPER","Z8_PRODUTO","Z8_QUANT","Z8_PALLET","Z8_PLTEN","Z8_PLTSA","Z8_PAGER","Z8_LACRE","Z8_SACGRA","Z8_OBS","Z8_USUARIO","Z8_NFCOMP","Z8_SERNF","Z8_NFPESEN","Z8_TICKENT","Z8_PATIO","Z8_CATEGMP","Z8_CBPAGER","Z8_LOCCARR"}
Static oEnchoice1

oEnchoice1 := MsMGet():New(cAlias,nReg,nOpc,,,,aCampos,aPosicao,aEdit,,,,,oDlg,,,,,.F.)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ fEnchoice3                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function fEnchoice3(cAlias,nReg,nOpc,aPosicao)

Local aCampos  := {"Z8_MOTOR","Z8_NOMMOT","Z8_NMTRANS","Z8_FORNECE","Z8_LOJAFOR","Z8_TRANSP","Z8_LJTRANS","NOUSER"}
Local aEdit    := {"Z8_MOTOR","Z8_NOMMOT","Z8_NMTRANS","Z8_FORNECE","Z8_LOJAFOR","Z8_TRANSP","Z8_LJTRANS"}
Static oEnchoice3

oEnchoice3 := MsMGet():New(cAlias,nReg,nOpc,,,,aCampos,aPosicao,aEdit,,,,,oDlg,,,,,.F.)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ fEnchoice2                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function fEnchoice2(cAlias,nReg,nOpc,aPosicao)

Local aCampos  := {"Z8_PLACA","Z8_PLCAR","Z8_VISTOR","Z8_DTVIST","Z8_MUNIC","Z8_ESTADO","Z8_CILINDR","NOUSER"}
Local aEdit    := {"Z8_PLACA","Z8_PLCAR","Z8_VISTOR","Z8_DTVIST","Z8_MUNIC","Z8_ESTADO","Z8_CILINDR"}

Static oEnchoice2

oEnchoice2 := MsMGet():New(cAlias,nReg,nOpc,,,,aCampos,aPosicao,aEdit,,,,,oDlg,,,,,.F.)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATT17                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Altera peso calculado, mediante senha                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function SMFATT17(cAlias,nReg,nOpc)
Static oDlg
Static oGroup1
Static oGroup2
Static oGroup3
Local aSize	  := {}
Local aInfo    := {}
Local aObjects := {}
Local nOpca    := 2
Local cOCOld   := SZ8->Z8_OC

Local aButtons := {}
Private aPedMark   := {}
Private aPedDesMar := {}

If nOpc == 3
	cTitulo := "Inclusão"
ElseIf nOpc == 4
	cTitulo := "Alteração"
ElseIf nOpc == 2
	cTitulo := "Visualização"
ElseIf nOpc == 5
	cTitulo := "Exclusão"
Endif

If nOpc == 5
	If SZ8->Z8_STATUS2 == "1"
		ALERT("EXCLUSÃO NÃO PERMITIDA: A ordem ja possui pedidos associados. Verifique.")
		Return Nil
	EndIf
	
	If SZ8->Z8_STATUS2 >= "3"
		ALERT("EXCLUSÃO NÃO PERMITIDA: O veículo já iniciou o carregamento/descarregamento. Verifique.")
		Return Nil
	EndIf
	
	If SZ8->Z8_TPOPER == "D"
		dbSelectArea('SC7')
		dbsetorder(RetOrdem("SC7","C7_FILIAL+C7_YOC"))
		If sc7->(dbSeek(xFilial('SC7')+cOCOld))
			While SC7->C7_FILIAL == xFilial("SC7") .AND.;
				SC7->C7_YOC == cOCOld
				
				cSql := "SELECT D1_DOC, D1_SERIE FROM "+RetSqlName("SD1")+" SD1 "
				cSql += " WHERE SD1.D_E_L_E_T_ = ' '"
				cSql += " AND   SD1.D1_FILIAL  = '" +xFilial("SD1")+ "'"
				cSql += " AND   SD1.D1_PEDIDO  = '" + SC7->C7_NUM + "'"
				If Select("QrySC7") > 0
					dbSelectArea("QrySC7")
					QrySC7->(DbCloseArea())
				EndIf
				//wSQL := ChangeQuery(wSQL)
				TcQuery cSql New Alias "QrySC7"
				
				If  QrySC7->(!Eof())
					ALERT("EXCLUSÃO NÃO PERMITIDA: Esta ordem de carregamento já foi relacionada a PRÉ-NOTA/NF "+Alltrim(QrySC7->D1_DOC)+"-"+Alltrim(QrySC7->D1_SERIE)+ ". Verifique.")
					QrySC7->(DbCloseArea())
					Return Nil
				EndIf
				
				sc7->(dbSeek(xFilial('SC7')+cOCOld)) //skip nao funcionou
				sc7->(dbskip())
			EndDo
		EndIf
	EndIf
Endif


If nOpc == 4
	
	
	if !( SZ8->Z8_status2 $ ' *P*1' )
		ALERT("ALTERAÇÃO NÃO PERMITIDA: O veículo já iniciou o carregamento/descarregamento. Verifique.")
		Return Nil
	EndIf
	
	AADD( aButtons, {"HISTORIC", {|| If(M->Z8_TPOPER='C',iif(cEmpAnt == '30',U_SMFATF80(),U_frmfiltpv()),ALERT('Somente para TIPO OPERAÇÃO carregamento.'))},"P.Venda"} )
	AADD( aButtons, {"PEDIDO", {|| If(M->Z8_TPOPER='D',U_MIZ992(),ALERT('Somente para TIPO OPERAÇÃO descarregamento.'))},"P.Compra"} )
Endif

aSize := MsAdvSize(.F.)
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 6 }
AAdd( aObjects, { 100, 33, .T., .T. } )
AAdd( aObjects, { 100, 33, .T., .T. } )
AAdd( aObjects, { 100, 34, .T., .T. } )
'
aPosObj := MsObjSize( aInfo, aObjects,.T.)

DEFINE MSDIALOG oDlg TITLE cTitulo FROM aSize[7], 0  TO aSize[6], aSize[5] of oMainWnd PIXEL
/*
@ aPosObj[1,1]+10,aPosObj[1,2]     GROUP oGroup1 TO aPosObj[3,3]-10, aPosObj[3,4]-315 PROMPT "CARREGAMENTO/DESCARREGAMENTO" OF oDlg COLOR 0, 16777215 PIXEL
@ aPosObj[1,1]+10,aPosObj[1,2]+315 GROUP oGroup2 TO aPosObj[1,3]+40, aPosObj[3,4] PROMPT "M O T O R I S T A" OF oDlg COLOR 0, 16777215 PIXEL
@ aPosObj[1,3]+45,aPosObj[1,2]+315 GROUP oGroup3 TO aPosObj[3,3]-10, aPosObj[3,4] PROMPT "V E I C U L O" OF oDlg COLOR 0, 16777215 PIXEL
*/
@ aPosObj[1,1]*2,aPosObj[1,2]     		GROUP oGroup1 TO aPosObj[3,3], aPosObj[1,4]/1.8 	PROMPT "CARREGAMENTO/DESCARREGAMENTO" OF oDlg COLOR 0, 16777215 PIXEL
@ aPosObj[1,1]*2,aPosObj[1,4]/1.78 		GROUP oGroup2 TO aPosObj[3,3]/2, aPosObj[2,4] 		PROMPT "V E I C U L O" OF oDlg COLOR 0, 16777215 PIXEL
@ aPosObj[3,3]/1.98,aPosObj[1,4]/1.78 	GROUP oGroup3 TO aPosObj[3,3], aPosObj[3,4] 		PROMPT "M O T O R I S T A" OF oDlg COLOR 0, 16777215 PIXEL

RegToMemory("SZ8",IIF(nOpc==3,.T.,.F.), .F., .T.)

SMFATF34(cAlias,nReg,nOpc,{(aPosObj[1,1]*2)+7,aPosObj[1,2]+2,(aPosObj[3,3])-2,(aPosObj[1,4]/1.8)-2})
fEnchoice2(cAlias,nReg,nOpc,{(aPosObj[1,1]*2)+7,(aPosObj[1,4]/1.78)+2,(aPosObj[3,3]/2)-2,(aPosObj[2,4]-2)})
fEnchoice3(cAlias,nReg,nOpc,{(aPosObj[3,3]/1.98)+7,(aPosObj[1,4]/1.78)+2,aPosObj[3,3]-2,aPosObj[3,4]-2})

If nOpc == 4
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {||nOpca := 1,IIF(u_SMFATF20() .And. smObrigatorio(),oDlg:End(),Nil)}, {||nOpca:=2,oDlg:End()},,aButtons)
Elseif nOpc == 3
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {||nOpca := 1,IIF(u_smSetOC().And. smObrigatorio(),oDlg:End(),Nil)}, {||nOpca:=2,oDlg:End()},,aButtons)
ElseIf nOpc == 2
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {||oDlg:End()}, {||oDlg:End()},,aButtons)
ElseIf nOpc == 5
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {||nOpca := 1,oDlg:End()}, {||nOpca := 2,oDlg:End()},,aButtons)
Endif

If nOpca == 1 .And. nOpc <> 5
	// incluida funcao (u_smSetOC) nesse ponto, para garantir que o numero sequencial gerado na abertura da tela, nao ja tenha sido utilizado por outro usuario
	if nOpc==3;  u_smSetOC() ; endif
	RecLock("SZ8",IIF(nOpc == 3,.T.,.F.))
	SZ8->Z8_FILIAL := xFilial("SZ8")
	For l := 2 To Len(aAcho)
		FieldPut(FieldPos(aAcho[l]),&("M->"+aAcho[l]))
	Next
	MsUnlock()
	If nOpc == 4
		SMFATF33()
	Endif
Endif

If nOpc == 5
	
	If nOpca == 1
		RecLock("SZ8",.F.)
		DbDelete()
		MsUnlock()
	Endif
	
	If nOpca == 2
		If SZ8->Z8_TPOPER == "C"
			dbSelectArea('SZF')
			dbsetorder(RetOrdem("SZF","ZF_FILIAL+ZF_OC"))
			If dbSeek(xFilial('SZF')+cOCOld)
				While SZF->ZF_FILIAL == xFilial("SZF") .AND.;
					SZF->ZF_OC == cOCOld
					While !RecLock("SZF",.F.) ; End
					SZF->ZF_OC = " "
					SZF->(MsUnlock())
					
					dbSeek(xFilial('SZF')+cOCOld)  //skip nao funcionou
				EndDo
			EndIf
		Else
			dbSelectArea('SC7')
			dbsetorder(RetOrdem("SC7","C7_FILIAL+C7_YOC"))
			If dbSeek(xFilial('SC7')+cOCOld)
				While SC7->C7_FILIAL == xFilial("SC7") .AND.;
					SC7->C7_YOC == cOCOld
					
					While !RecLock("SC7",.F.) ; End
					SC7->C7_YOC = " "
					SC7->(MsUnlock())
					
					dbSeek(xFilial('SC7')+cOCOld) //skip nao funcionou
				EndDo
			EndIf
		EndIf
	EndIf
Endif

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF35                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function smObrigatoio()
For s := 2 To Len(aAcho)
	If Empty(&("M->"+aAcho[s])) .And. X3Obrigat(aAcho[s])
		Help(" ",1,"OBRIGAT")
		Return .F.
	Endif
Next
Return .T.



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ SMFATF35                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ 					                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


user Function SMFATF37(p_cPager)
local warea:= getArea()
local cRet:=''
local cPager:= iif(  p_cPager==nil, iif( ParamIxb==nil, '' , ParamIxb ) , ''  )

do case
	case cempant=='30' //BA - 1000
		cCB:='1000'
	case cempant=='11' //PA - 2000
		cCB:='2000'
	case cempant=='01' //VI - 3000
		cCB:='3000'
	case cempant=='20' //AB - 4000
		cCB:='4000'
	case cempant=='10' //MO - 5000
		cCB:='5000'
endcase

cRet:= cCB + strzero(val(cPager),4)
restArea(wArea)
Return (cret)




user function smgetSeq(p_cAlias, p_cCampo)
local warea:= getArea()
local wCmpFilial:= iif( left(p_cAlias,1)=='S' ,left(p_cCampo,3),left(p_cCampo,4))+"FILIAL"
local wRet:= '0'
local wTam := tamSX3("Z8_OC")[1]

cSql := "SELECT MAX( " +p_cCampo+ ") NUMSEQ FROM "+RetSqlName(p_cAlias)
cSql += " WHERE D_E_L_E_T_ = ' '"
cSql += " AND   "+wCmpFilial+"  = '" +xFilial(p_cAlias)+ "'"

If Select("QryXEXF") > 0
	dbSelectArea("QryXEXF")
	QryXEXF->(DbCloseArea())
EndIf
//wSQL := ChangeQuery(wSQL)
TcQuery cSql New Alias "QryXEXF"

wRet:= strzero( val( QryXEXF->NUMSEQ ) +1 , wTam)

restArea(wArea)
Return (wret)


User function PXH053(p_cPager)

local cPager:= iif(p_cPager==nil,'',p_cPager)
local nAct:= 0
local oBitmap1
local lAtivo := .t.
local nList
local aItens := u_PXH05301()
local cCombo := aItens[1]

if cCombo = "ZZ" ; return cCombo ; endif

DEFINE MSDIALOG oDlg27 TITLE "PAGERS DISPONIVEIS" FROM 000, 000  TO 60, 200 COLORS 0, 16777215 PIXEL

oFont := TFont():New("Arial",,22,,.T.,,,,,.F.,.F.)
oCombo := TComboBox():New(10,10,{|u|if(PCount()>0,cCombo:=u,cCombo)},aItens,40,40,oDlg27,,{||},,,,.T.,oFont,,,,,,,,'cCombo')
oTButton1 := TButton():New( 05, 60, "OK",oDlg27,{||oDlg27:end(), nAct:= 1},30,20,,,.F.,.T.,.F.,,.F.,,,.F. )

ACTIVATE MSDIALOG oDlg27 CENTERED


Return iif( nAct == 1, cCombo, cPager )


User function PXH05301()

local warea:= getArea()
local cContem := ""
local nmaxpager:= GETMV("MV_MAXPAGE")
public aNDisp := {}


cSQL := "SELECT Z8_PAGER FROM "+RetSqlName("SZ8")+" SZ8"
cSQL += " WHERE SZ8.D_E_L_E_T_= ' ' AND Z8_FILIAL = '" + xFilial("SZ8") + "'"
cSQL += " AND Z8_FATUR != 'S' AND Z8_PAGER != 'ZZ' AND Z8_PAGER != ' ' ORDER BY Z8_PAGER"

TCQUERY cSQL New Alias "BNP" // BUSCA NUMERACAO DO PAGER
dbSelectArea('BNP')
BNP->(DbGoTop())
while BNP->(!eof())
	cContem += BNP->Z8_PAGER+"\"
	BNP->(DbSkip())
end
BNP->(DbCloseArea())
RestArea(warea)

for i:=1 to nmaxpager
	if cValtoChar(STRZERO(i,3)) $ cContem
	else
		AAdd(aNDisp,STRZERO(i,3))
	endif
next

if LEN(aNDisp)=0; AAdd(aNDisp,"ZZ"); endif

return aNDisp


User function SMFATF72()

local warea:= getArea()
local cOC := SZ8->Z8_OC

If SZ8->Z8_STATUS2 <> "1"
	Alert("Não é permitido cancelar agenciamentos com status diferente de 1.")
	return
endif
If !MsgBox("Deseja cancelar o agenciamento?  ","Escolha","YESNO")
	return
endif

dbSelectArea('SZF')
dbSetorder(8)
while dbSeek(xFilial('SZF')+cOC)
	RecLock("SZF",.f.)
	SZF->ZF_OC    := " "
	SZF->ZF_PLACA := " "
	SZF->ZF_MOTOR := " "
	SZF->ZF_NMOT  := " "
	SZF->(MsUnlock())
end
SZF->(DbCloseArea())
RestArea(warea)

RecLock("SZF",.f.)
SZF->ZF_PAGER   := " "
SZF->ZF_CBPAGER := " "
SZF->ZF_STATUS2 := " "
SZF->(MsUnlock())

return