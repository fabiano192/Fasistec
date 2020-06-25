#Include "Protheus.ch"
#include "rwmake.ch"
#INCLUDE 'COLORS.CH'
#Include "TOPCONN.CH"
#XCommand ROLLBACK TRANSACTION => DisarmTransaction()

User Function smCupomBal()
	
	Local cAlias := "SZ1"
	
	Private cCadastro := "Cupom de Pesagem"
	Private aCores := {}
	Private aRotina := {}
	Private aFixe	:= {}
	Private aAcho	:= {}
	Private aCpos	:= {}
	
	
	
	AADD(aRotina,{"Pesquisar"  ,"AxPesqui",0,1})
	AADD(aRotina,{"Visualizar" ,"U_smCupVis",0,2})
	AADD(aRotina,{"Incluir"    ,"U_smCupInc",0,3})
	AADD(aRotina,{"Alterar"    ,"U_smCupAlt",0,4})
	//AADD(aRotina,{"Excluir"    ,"U_smCupDel",0,5})
	AADD(aRotina,{"Legenda"    ,"U_DIALEG1",0,6})
	AADD(aRotina,{"Imprimir Tickt"    ,"u_smRelTicket",0,7})
	
	/*
	// Campos que serao apresentados no browse.
	//aadd(aFixe,{Posicione("SX3",2,"Z8_OC","X3_TITULO") ,"Z8_OC"})
	
	// Somente campos que serao exibidos
	aadd(aAcho,"NOUSER") //Evita Exibição de outros campos de usuario.
	aadd(aAcho,"Z8_OC")
	aadd(aAcho,"Z8_DATA")
	aadd(aAcho,"Z8_HORA")
	aadd(aAcho,"Z8_CATEGMP")
	
	// Campos que podem ser alterados
	//aCpos := {}
	//aadd(aCpos,"Z8_OC")
	
	*/
	
	/*
	AADD(aCores,{'If(SZ8->Z8_STATUS==" ",Empty(If(SZ8->Z8_TPOPER=="C",Posicione("SZ1",8,xFilial("SZ1")+SZ8->Z8_OC,"Z1_OC"),Posicione("SC7",RetOrdem("SC7","C7_FILIAL+C7_YOC"),xFilial("SC7")+SZ8->Z8_OC,"C7_YOC"))),.F.)' ,"BR_BRANCO" })
	AADD(aCores,{'If(SZ8->Z8_STATUS=="P",!Empty(If(SZ8->Z8_TPOPER=="C",Posicione("SZ1",8,xFilial("SZ1")+SZ8->Z8_OC,"Z1_OC"),Posicione("SC7",RetOrdem("SC7","C7_FILIAL+C7_YOC"),xFilial("SC7")+SZ8->Z8_OC,"C7_YOC"))),.F.)' ,"BR_LARANJA" })
	AADD(aCores,{'If(SZ8->Z8_STATUS=="1",!Empty(If(SZ8->Z8_TPOPER=="C",Posicione("SZ1",8,xFilial("SZ1")+SZ8->Z8_OC,"Z1_OC"),Posicione("SC7",RetOrdem("SC7","C7_FILIAL+C7_YOC"),xFilial("SC7")+SZ8->Z8_OC,"C7_YOC"))),.F.)' ,"BR_AMARELO" })
	AADD(aCores,{'If(SZ8->Z8_STATUS=="2",.T.,.F.)',"BR_VERDE" })
	AADD(aCores,{'If(SZ8->Z8_STATUS=="3",.T.,.F.)',"BR_PINK" })
	AADD(aCores,{'If(SZ8->Z8_STATUS=="4",.T.,.F.)',"BR_AZUL" })
	AADD(aCores,{'If(SZ8->Z8_STATUS=="5",.T.,.F.)',"BR_PRETO" })
	AADD(aCores,{'If(SZ8->Z8_STATUS=="6".and.empty(SZ8->Z8_FATUR) ,.T.,.F.)',"BR_VERMELHO" })
	AADD(aCores,{'If(SZ8->Z8_STATUS=="6".and.!empty(SZ8->Z8_FATUR).and.SZ8->Z8_PESOFIN>0,.T.,.F.)',"BR_MARROM" })
	*/
	
	AADD(aCores,{'if(sz1->z1_pesini<=0,.t.,.f.)',"BR_VERDE" })
	AADD(aCores,{'if(sz1->z1_pesini>0.and.sz1->z1_pesfin<=0,.t.,.f.)' ,"BR_AMARELO" })
	AADD(aCores,{'if(sz1->z1_pesliq>0,.t.,.f.)',"BR_VERMELHO" })
	
	dbSelectArea(cAlias)
	dbSetOrder(1)
	
	//sz8->(DbSetFilter({|| z8_filial = cFilant .and. Empty(z8_fatur)  .and. !empty(z8_tpoper) }, " z8_filial = cFilant .and. Empty(z8_fatur) .and. !empty(z8_tpoper)"))
	
	
	mBrowse(6,1,22,75,cAlias,/*Fixe*/,,,,,aCores)
	
	//set filter to
	
Return Nil
  



//** Inclui **//
User Function smCupInc(cAlias, nReg, nOpc)
	Local nOpcao := 0
	Local aButtons := {}                                                                                                           
	
	AADD( aButtons, {"CARGA", {|| u_smPesoIni('2', 'D')    },"Peso inicial"} )	

	nOpcao := AxInclui(cAlias,nReg,nOpc,aAcho,/*aCpos*/,,"u_fVld_IA()",,,aButtons) // Identifica corretamente a opção definida para o função em aRotinas com mais // do que os 5 elementos padrões.	
Return Nil

//** Altera **//
User Function smCupAlt(cAlias, nReg, nOpc)
	Local nOpcao := 0
	Local aButtons := {}
	
	
	if sz1->z1_pesliq >0 
		ALERT("ALTERAÇÃO NÃO PERMITIDA: Pesagem finalizada! ")
		Return Nil
	EndIf
	
	AADD( aButtons, {"CARGA", {|| u_smPesoFin('6', 'D')    },"Peso final"} )	

	
	nOpcao := AxAltera(cAlias,nReg,nOpc,aAcho,/*aCpos*/,,,"u_fVld_IA()",,,aButtons) // Identifica corretamente a opção definida para o função em aRotinas com mais // do que os 5 elementos padrões.
		
Return Nil

//** Deleta **//
User Function f996Del(cAlias, nReg, nOpc)

Local nOpcao := 0
Local cOCOld := SZ8->Z8_OC


If SZ8->Z8_STATUS == "1"
	ALERT("EXCLUSÃO NÃO PERMITIDA: A ordem ja possui pedidos associados. Verifique.")
	Return Nil
EndIf


If SZ8->Z8_STATUS >= "3"
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
		dbSelectArea('SZ1')
		dbsetorder(RetOrdem("SZ1","Z1_FILIAL+Z1_OC"))
		If dbSeek(xFilial('SZ1')+cOCOld)
			While SZ1->Z1_FILIAL == xFilial("SZ1") .AND.;
				SZ1->Z1_OC == cOCOld
				While !RecLock("SZ1",.F.) ; End
				SZ1->Z1_OC = " "
				SZ1->(MsUnlock())
				
				dbSeek(xFilial('SZ1')+cOCOld)  //skip nao funcionou
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

//** Inclui **//
User Function smCupVis(cAlias, nReg, nOpc)
Local nOpcao := 0

nOpcao := AxVisual(cAlias,nReg,nOpc,aAcho,/*aCpos*/,,) // Identifica corretamente a opção definida para o função em aRotinas com mais // do que os 5 elementos padrões.
Return Nil


User Function fVld_IA()
Local lRes := .T.


//If M->Z8_SACGRA == "G"  .AND. M->Z8_PALLET <> "G"
//	Alert("A informação do campo PALLET/MANUAL é incoerente com a informação do campo SACO/GRANEL(Granel). Verifique.")
//	lRes := .F.
//EndIf

/*
dbSelectArea("SZ8")
dbSetOrder(1)
While dbSeek(xFilial("SZ8")+M->Z8_OC)
	M->Z8_OC := GETSXENUM("SZ8","Z8_OC")
EndDo

//M->Z8_USUARIO := Subs(Alltrim(cusuario),7,15)
*/

Return(lRes)



User Function f996Vld()
Local lRes := .T.
Private _copcoes := "3"
Private _eixCam := _eixCar := nTotpedag := _Peso := 0
Private _lGatilho:=.f.

if type('paramIXB')<>'U'
	_lGatilho:= iif( paramIXB<> nil, iif(paramIXB==1,.t.,.f.), .f. )
endif

Private _pent  := M->Z8_PLTEN
Private _psai  := M->Z8_PLTSA
Private _hora  := M->Z8_HORA
Private _lacre := M->Z8_LACRE
Private _placa := M->Z8_PLACA
Private _motor := M->Z8_MOTOR
Private cctr   := ""
Private cfornece  := M->Z8_TRANSP
//Private clojaf    := Posicione("SA2",1,xFilial("SA2")+M->Z8_TRANSP,"A2_LOJA")
Private clojaf    := M->Z8_LJTRANS
Private _numOC    := M->Z8_OC
Private plcar 	  := M->Z8_PLCAR
Private cpm		  := M->Z8_PALLET

If !_lGatilho
	If (M->Z8_TPOPER <> SZ8->Z8_TPOPER) .AND. !Empty(SZ8->Z8_STATUS)
		Alert("Não é permitido alterar o TIPO DE OPERAÇÃO.")
		Return(.F.)
	EndIf
	
	If !fCritPag()
		Return(.F.)
	EndIf
EndIf

//tratamento para pedidos desmarcados
setDesmark()


If (Len(aPedMark) <> 0 .or. _lGatilho ) .AND. M->Z8_TPOPER == "C" //Se houve selecao de pedido.
	
	If M->Z8_SACGRA == "S"  .AND. M->Z8_PALLET == "G"
		Alert("A informação do campo PALLET/MANUAL(Granel) é incoerente com a informação do campo SACO/GRANEL(Saco). Verifique.")
		lRes := .F.
	EndIf
	
	If M->Z8_SACGRA == "G"  .AND. M->Z8_PALLET <> "G"
		Alert("A informação do campo PALLET/MANUAL é incoerente com a informação do campo SACO/GRANEL(Granel). Verifique.")
		lRes := .F.
	EndIf
	
	If !fCritIni(_lGatilho)
		lRes := .F.
		//Return(.F.)
	EndIf
	
	If !_lGatilho .and. lRes
		if !Registra_Entrada()
			lRes := .F.
			Return(.F.)
		endif
	EndIf
ElseIf Len(aPedMark) <> 0 .AND. M->Z8_TPOPER == "D" //Se houve selecao de pedido.
	If !fRegDesc()
		Return(.F.)
	EndIf
EndIf

M->Z8_USUARIO := Subs(Alltrim(cusuario),7,15)
m->z8_pswmoto := sz3->z3_senhmot

if !empty(m->z8_status)
	if !Empty(	If(SZ8->Z8_TPOPER=="C",Posicione("SZ1",8,xFilial("SZ1")+SZ8->Z8_OC,"Z1_OC"),Posicione("SC7",RetOrdem("SC7","C7_FILIAL+C7_YOC"),xFilial("SC7")+SZ8->Z8_OC,"C7_YOC")))
		m->z8_status:= iif( m->z8_patio == '1', '1','P')
	endif
endif

Return(iif( _lGatilho, iif(lres,_placa,"") ,lRes ) )



//** REALIZA AS CRITICAS/VERIFICACOES INICIAIS **//
Static Function fCritIni(p_lGatilho)

SetPrvt("_LCREDOK,_BALENT")
SetPrvt("_LRET,_LCONTINUA,_WSALSE1,_WSALSZ1")
SetPrvt("_WATRASO,_WDIAS,_WPOSSZ1,_WCLI,_WLOJ,_WRISCO,WTOLBAL")
//Private _copcoes,cfornece:=Space(6),clojaf:=Space(2),cpm := Space(1),_lacre:= Space(80)
//Private cctr:=Space(6),npedagio:=0,_placa,_motor,aenvio:={},_numOC:="000000"
Private npedagio:=0
//Private plcar := Space(7)
Private cProduto := CriaVar("Z1_PRODUTO")
Private nNum     := CriaVar("Z1_NUM")
Private oGetlacre
Private nPesoTotal:=0 //usada


p_lGatilho := iif( p_lGatilho<>nil, p_lGatilho, .f. )

//_copcoes  := Paramixb

//If _copcoes $ "13"
//	If nmarcados==0
//		MsgBox("Nao foi selecionado nenhum pedido","Atencao","ALERT")
//		Return
//	EndIf
//EndIf
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
		DbSelectArea("SZ1")
		nordem := IndexOrd()
		DbSetOrder(0)
		DbGotop()
		Do while .not. eof()
			If Marked("Z1_OK")
				If _copcoes $ "1" //Se for entrada
					If ! empty(SZ1->Z1_PLACA) .or. ;
						! empty(SZ1->Z1_MOTOR)
						MsgAlert("Entrada ja lancada para o pedido "+SZ1->Z1_NUM,"Atencao","Alert")
						Return
					EndIf
				ElseIf _copcoes $ "3" //entrada+peso
					If ( SZ1->Z1_PSENT <> 0 .or. ;
						! empty(SZ1->Z1_PLACA) .or. ;
						! empty(SZ1->Z1_MOTOR) ) .and. sz8->z8_oc <> sz1->z1_oc
						MsgAlert("Entrada e peso ja lancada para o pedido "+SZ1->Z1_NUM,"Atencao","Alert")
						Return
					EndIf
				EndIf
				If _copcoes $ "1,3" //Se for entrada ou entrada+peso
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o pedido esta bloqueado                                      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If  SZ1->Z1_LIBER == "B"
						MsgBox("Pedido Bloqueado!","Atencao","ALERT")
						Return
					End
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica limite de credito                                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If  SZ1->Z1_LIBER <> "S"
						_lCredOk := .T.
						Ver_Credito()
						If  ! _lCredOk
							MsgBox("Pedido Bloqueado por Credito!","Atencao","ALERT")
							Return
						End
					End
				EndIf
				
				
				if (sz1->z1_unid == 'TL' .and. m->z8_sacgra <> 'G') .or. (sz1->z1_unid $ 'UN/SC' .and. m->z8_sacgra == 'G')
					MsgBox("Tipo de carta diferente entre Pedido e Agenciamento ... ","Atencao","ALERT")
					return .F.
				endif
				
				
				//// SOMA O PESO PRA VALIDAÇÃO DA CAPACIADADE DO CAMINHAO
				/////////////////////////////////////////////////////////
				If SB1->(DbSeek( xFilial('SB1')+SZ1->Z1_PRODUTO  )) .And. SB1->B1_UM $ 'SC*SA'
					If !Empty(SB1->B1_CONV)
						Do Case
							Case SB1->B1_TIPCONV=='M'
								nPesoTotal+= SZ1->Z1_QUANT * SB1->B1_CONV
							Case SB1->B1_TIPCONV=='D'
								nPesoTotal+= SZ1->Z1_QUANT / SB1->B1_CONV
							OtherWise
								nPesoTotal+= SZ1->Z1_QUANT
						EndCase
					Endif
					
				Endif
				
				SZ4->(dbSetOrder(1))
				If SZ4->(DbSeek(xFilial("SZ4")+SZ1->Z1_UFE+SZ1->Z1_MUNE))
					nPedagio += SZ4->Z4_PEDAGIO
				EndIf
			EndIf
			DbSelectArea("SZ1")
			DbSkip()
		EndDo
		
		SZ1->(DbSetOrder(nordem))
		SZ1->(DbGotop())
	EndIf
	
endif

_peso  := 0

// Executa as demais criticas.
If !fplaca(p_lGatilho)
	Return(.f.)
EndIf
If !nome_motor()
	Return(.f.)
EndIf
If !fcar(p_lGatilho)
	Return(.f.)
EndIf
If !Nome_forn()
	Return(.f.)
EndIf

// a vairavel nTotPedag, e' igual:   (somatorio do pedagio de todos os pedios) * (qtdEixosCaminhao + qtdEixosCarreta)
nTotPedag := npedagio * (_eixCam+_eixCar)
m->z8_pedagio:= nTotPedag

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³  fplaca  ³ Autor ³ NILTON CESAR          ³ Data ³ 21.09.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Verifica se o caminhao esta  bloqueado                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFAT - Menu Atualizacoes                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fplaca(p_lGatilho)
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
			lRet:= u_SenhaPe('OC')
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
If SZ2->Z2_ULTC < ddatabase
	MsgBox("Atencao, vistoria atrasada !!! ","Atencao","ALERT")
	
	If ddatabase-ndias  > SZ2->Z2_ULTC .and. lret == .T.
		MsgBox("Atencao,favor atualizar os dados cadastrais do Caminhao antes de continuar.!!","Atencao","ALERT")
		lret := .F.
	EndIf
EndIf
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
		cProduto := GetAdvfVal("SZ1","Z1_PRODUTO",xFilial("SZ1")+nNum,1)
		
		DbSelectArea("SZ1")
		If GetAdvfVal("SB1","B1_YVEND",xFilial("SB1")+cProduto,1) = "S"   // em 23-12-08. A pedido da Marciane. Nao bloquear pedidos nao vendavel
			If GetAdvfVal("SZ1","Z1_FRETE",xFilial("SZ1")+nNum,1) = "F"
				If GetAdvfVal("SZ3","Z3_TIPO",xFilial("SZ3")+_motor,1) <> "3"
					Alert("Este Pedido é FOB, mas foi digitado um Motorista que não é Fob. Favor Corrigir")
					lret := .F.
				EndIf
			EndIf
		EndIf
		
		
		If GetAdvfVal("SZ3","Z3_TIPO",xFilial("SZ3")+_motor,1) == "3"
			If GetAdvfVal("SZ1","Z1_FRETE",xFilial("SZ1")+nNum,1) == "C"
				Alert("Este Pedido é CIF, mas foi digitado um Motorista que não é CIF. Favor Corrigir")
				lret := .F.
			EndIf
		EndIf
		
		SZ1->(dbSetorder(1))
		If SZ1->(dbSeek(xFilial("SZ1")+nNum))
		   If SZ1->Z1_FRETE = "C"
				SZG->(dbSetOrder(1))
				If SZG->(!dbSeek(xFilial("SZG")+SZ1->Z1_UFE + SZ1->Z1_MUNE + SZ8->Z8_TRANSP + SZ8->Z8_LJTRANS))
					MSGALERT("FAVOR CADASTRAR TABELA DE PRECO REF. AO FRETE")
					lRet := .F.
				Endif
			Endif
		Endif
	Next
Endif
// Fim Welinton 16-12-08


RestArea(aAreaAtu)



Return(lret)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ Mostrar na tela o nome do motorista                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Registra entrada do caminhao para carregamento             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Nome_motor()
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
If SZ3->Z3_BLOQ $ " N" .and. SZ3->Z3_ULTC < ddatabase
	If ddatabase-ndias  > SZ3->Z3_ULTC
		MsgBox("Atencao,favor atualizar os dados cadastrais do Motorista antes de continuar.!!","Atencao","ALERT")
		lret := .F.
	EndIf
EndIf

if lSenMot
	If empty(SZ3->Z3_SENHMOT)
		MsgBox("Atencao, Motorista sem S E N H A cadastrada !","Atencao","ALERT")
		//lret := .F.
	EndIf
endif

//validacao de pager
lret:= fCritPag()


DbSelectArea(calias)
RestArea(aAreaAtu)

Return(lret)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³  fcar    ³ Autor ³ NILTON CESAR          ³ Data ³ 20.02.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Verifica se o caminhao esta  bloqueado                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFAT - Menu Atualizacoes                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fcar(p_lGatilho)
Local aAreaAtu := GetArea()

//plcar := M->Z8_PLCAR

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

RestArea(aAreaAtu)



Return(lret)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ Mostrar na tela o nome do fornecedor/transportador         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Registra entrada do caminhao para carregamento             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Nome_forn()
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

User Function SenhaPe(wOpcao)
Local _senha    := space(10)
Local lRet:=.F.

DEFINE MSDIALOG oDlg2 TITLE "Senha" FROM 40,50 TO 100,300 PIXEL
@ 08,10 say "Senha:"
@ 08,35 get _senha PassWord
@ 14,100 BmpButton Type 1 Action Close(oDlg2)
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
±±³Fun‡Æo    ³ Ver_Credito                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Verifica credito do cliente                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 28/06/00 ==> Function Ver_Credito
Static Function Ver_Credito()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acessa SA1 - Cadastro de Clientes                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA)
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
	_wSalSZ1 := 0
	_wAtraso := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Determina saldo em aberto - SE1-Contas a Receber                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE1")
	dbSetOrder(2)
	dbSeek(xFilial("SE1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA)
	While !eof() .and. SE1->E1_FILIAL  == xFilial("SE1")  ;
		.and. SE1->E1_CLIENTE == SZ1->Z1_CLIENTE ;
		.and. SE1->E1_LOJA    == SZ1->Z1_LOJA
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
	//³ Determina saldo em aberto - SZ1-Pedidos de Venda MIZU                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If  funname() == "MIZ020" .or. funname() == "#MIZ020"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Salva posicao SZ1                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SZ1")
		_wPosSZ1 := recno()
		_wCli    := SZ1->Z1_CLIENTE
		_wLoj    := SZ1->Z1_LOJA
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Determina saldo em aberto - SZ1-Pedidos de Venda MIZU            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_wSalSZ1 := 0
		dbSelectArea("SZ1")
		dbSetOrder(2)
		dbSeek(xFilial("SZ1")+_wCli+_wLoj)
		While !eof() .and. SZ1->Z1_FILIAL  == xFilial("SZ1") ;
			.and. SZ1->Z1_CLIENTE == _wCli           ;
			.and. SZ1->Z1_LOJA    == _wLoj
			If  ! empty(SZ1->Z1_NUMNF)
				dbSkip()
				Loop
			End
			_wSalSZ1 := _wSalSZ1 + (SZ1->Z1_QUANT * SZ1->Z1_PCOREF)
			dbSkip()
		End
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Restaura posicao SZ1                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SZ1")
		dbSetOrder(3)
		//        goto _wPosSZ1
	End
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica limite de credito                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If  (_wSalSE1 + _wSalSZ1) > SA1->A1_LC .and. SA1->A1_RISCO <> "A" //Solicitado pela Marciane em 08/04/03
		_lRet      := .F.
		_lContinua := .F.
	Else
		_wRisco := 0
		Do Case
			Case SA1->A1_RISCO == "A"
				_wRisco := 0 //Solicitado pela Marciane em 08/04/03
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
		End
	End
End

_lCredOk := _lRet

Return



//funcao para capturar o peso do aquivo .txt  gravado pelo software controlador das balancas
//
User Function getPSer(p_cTipo,p_cPort)

private nHdll := 0
private cText := ''
private ComEnt := iif( p_cPort<>nil, p_cPort, GetMv("MV_YCOMENT") )

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
	Return
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


Return _peso

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ Registra_Entrada                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Registra entrada do caminhao para carregamento             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Registra_Entrada()
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
//³ Atualiza SZ1 - Pedido de Vendas MIZU                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _copcoes $ "2"
	Reclock ("SZ8",.F.)
	SZ8->Z8_PSENT    := _peso
	SZ8->Z8_HORPES   := left(time(),5)
	MsUnlock()
	DbSelectArea("SZ1")
	DbSetOrder(8)
	DbSeek(xFilial("SZ1")+SZ8->Z8_OC)
	Do while .not. eof() .and. Z1_FILIAL == xFilial("SZ1") .and. SZ1->Z1_OC == SZ8->Z8_OC
		While !Reclock ("SZ1",.F.);EndDo
		SZ1->Z1_PSENT    := _peso
		MsUnlock()
		DbSkip()
	EndDo
Else
	DbSelectArea("SZ1")
	nordem := IndexOrd()
	DbSetOrder(0)
	DbGotop()
	Do while .not. eof()
		//If Posicione("SZ1",1,xFilial("SZ1")+SZ1->Z1_NUM,"Z1_NUM")  // forço a busca no arquivo caso outro usuário simultaneamente tenha usado este pedido em outra OC.
		//EndIf
		If Marked("Z1_OK")
			Reclock ("SZ1",.F.)
			If !Empty(SZ1->Z1_OC) .and. sz1->z1_oc <> sz8->z8_oc //Caso outro usuário simultaneamente tenha usado este pedido em outra OC.
				MsgBox("ATENÇÃO: O pedido " +ALLTRIM(SZ1->Z1_NUM)+ " está agenciado na OC: "+ALLTRIM(SZ1->Z1_OC)+". Selecione outro pedido.","Atencao","STOP")
				SZ1->(msUnlock())
				ROLLBACK TRANSACTION
				Return
			EndIf
			SZ1->Z1_YPM := cpm
			SZ1->Z1_OC		 := M->Z8_OC
			If _copcoes $ "3"
				SZ1->Z1_PSENT    := _peso
			EndIf
			If _copcoes $ "1,3"
				SZ1->Z1_MOTOR    := _motor
				SZ1->Z1_PLCAR    := plcar
				SZ1->Z1_HORENT   := _hora
				SZ1->Z1_PALENT   := _pent
				SZ1->Z1_PALSAI   := _psai
				SZ1->Z1_NMOT     := SZ3->Z3_NOME
				SZ1->Z1_FORNECE  := cfornece
				SZ1->Z1_LOJAF    := clojaf
				SZ1->Z1_LACRE    := _lacre
			EndIf
			msUnlock()
			dbCommit()
		EndIf
		DbSkip()
	EndDo
	DbSelectArea("SZ1")
	DbSetOrder(nordem)
	DbGotop()  
	
	
	//setDesmark()
	
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recalcular o frete                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _copcoes $ "1,3"  //.and. !lBlqFrete //bloqueia alterações nos valores do frete
	DbSelectArea("SZ1")
	nordem := IndexOrd()
	DbSetOrder(0)
	DbGotop()
	Do while .not. eof()
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))
		If Marked("Z1_OK") .and. SA1->A1_YFRECLI == 0
			SZ3->(DbSetOrder(1))
			SZ3->(DbSeek(xFilial("SZ3")+_motor))
			
			If SZ1->Z1_UNID == "SC"
				
				If  SZ3->Z3_TIPO == "1" .and. Empty(cFornece)
					MsgBox("Voce esta lancando um transporte com CTR, Sem Transportadora","Atencao","STOP")
					ROLLBACK TRANSACTION
					Return
				ElseIf SZ3->Z3_TIPO == "2" .and. !Empty(cFornece)
					MsgBox("Voce esta lancando um transporte com Motorista RPA, usando CTR","Atencao","STOP")
					ROLLBACK TRANSACTION
					Return
				EndIf
				
				IF SZ1->Z1_FRETE == "C"
					If  SZ3->Z3_TIPO == "1" /* CTR SZG */
						SZG->(DbSetOrder(1))
						SZG->(DbSeek(xFilial("SZG")+SZ1->Z1_UFE+SZ1->Z1_MUNE+cFornece+cLojaf))
						//	MsgBox("TIPO 1, CTR PEGA EM BAIXO","Atencao","ALERT")
						While !Reclock("SZ1",.f.);EndDo
						
						//ANULADA POR AUGUSTO EM 12-02-2009 AS 12:03
						//SZ1->Z1_FTRA := Round(SZ1->Z1_QUANT * Iif(SZG->ZG_FAGRTRA>0,SZG->ZG_FAGRTRA,SZG->ZG_FRETE) ,2)
						//SZ1->Z1_FMOT := Round(SZ1->Z1_QUANT * Iif(SZG->ZG_FAGRMOT>0,SZG->ZG_FAGRMOT,SZG->ZG_FMOT) ,2)
						
						//AS DUAS LINHAS ABAIXO FORAM ALTERADAS CONFORME SOLICITAÇÃO DA JEANE
						SZ1->Z1_FTRA := Round(SZ1->Z1_QUANT * Iif(SZ3->Z3_AGREGA=="S",SZG->ZG_FAGRTRA,SZG->ZG_FRETE) ,2)
						SZ1->Z1_FMOT := Round(SZ1->Z1_QUANT * Iif(SZ3->Z3_AGREGA=="S",SZG->ZG_FAGRMOT,SZG->ZG_FMOT) ,2)
						
					Else /* RPA SZ4 */
						SZ4->(DbSetOrder(1))
						SZ4->(DbSeek(xFilial("SZ4")+SZ1->Z1_UFE+SZ1->Z1_MUNE))
						//	MsgBox("TIPO 2, RPA PEGA EM CIMA","Atencao","ALERT")
						
						While !Reclock("SZ1",.f.);EndDo
						
						//ANULADA POR AUGUSTO EM 12-02-2009 AS 12:03
						//SZ1->Z1_FTRA := Round(SZ1->Z1_QUANT * Iif(SZ4->Z4_FAGRTRA>0,SZ4->Z4_FAGRTRA,SZ4->Z4_FRETE) ,2)
						//SZ1->Z1_FMOT := Round(SZ1->Z1_QUANT * Iif(SZ4->Z4_FAGRMOT>0,SZ4->Z4_FAGRMOT,SZ4->Z4_FMOT) ,2)
						
						//AS DUAS LINHAS ABAIXO FORAM ALTERADAS CONFORME SOLICITAÇÃO DA JEANE
						SZ1->Z1_FTRA := Round(SZ1->Z1_QUANT * Iif(SZ3->Z3_AGREGA=="S",SZ4->Z4_FAGRTRA,SZ4->Z4_FRETE) ,2)
						SZ1->Z1_FMOT := Round(SZ1->Z1_QUANT * Iif(SZ3->Z3_AGREGA=="S",SZ4->Z4_FAGRMOT,SZ4->Z4_FMOT) ,2)
					EndIf
				ENDIF
				
				MsUnlock()
			EndIf
		EndIf
		DbSelectArea("SZ1")
		DbSkip()
	EndDo
	SZ1->(DbSetOrder(nordem))
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificar o maior frete para regravar no pedido                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _copcoes $ "1,3"  .and. !lBlqFrete //bloqueia alterações nos valores do frete
	SZ3->(DbSetOrder(1))
	SZ3->(DbSeek(xFilial("SZ3")+_motor))
	nvalmotm := 0
	nvaltram := 0
	DbSelectArea("SZ1")
	nordem := IndexOrd()
	DbSetOrder(0)
	DbGotop()
	Do while .not. eof()
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))
		If Marked("Z1_OK") .and. SZ1->Z1_FRETE == "C" .and. SA1->A1_YFRECLI == 0
			If cEmpAnt == "01"
				If cfilant == "03" .or. ;
					(SZ3->Z3_AGREGA == "S" .and. SZ3->Z3_TIPO == "1" .and. Alltrim(SZ1->Z1_UFE)=="ES") .or. ;
					(SZ3->Z3_AGREGA == "N" .and. SZ3->Z3_TIPO == "1" .and. Alltrim(SZ1->Z1_UFE)$"RJ,MG,ES")
					If Round(SZ1->Z1_FMOT / SZ1->Z1_QUANT,4) > nvalmotm
						nvalmotm  := Round(SZ1->Z1_FMOT / SZ1->Z1_QUANT,4)
						nvaltram  := Round(SZ1->Z1_FTRA / SZ1->Z1_QUANT,4)
					EndIf
				EndIf
			ElseIf cEmpAnt == "11"
				If Round(SZ1->Z1_FMOT / SZ1->Z1_QUANT,4) > nvalmotm
					nvalmotm  := Round(SZ1->Z1_FMOT / SZ1->Z1_QUANT,4)
					nvaltram  := Round(SZ1->Z1_FTRA / SZ1->Z1_QUANT,4)
				EndIf
			EndIf
		EndIf
		DbSkip()
		If Marked("Z1_OK") .and. SZ1->Z1_FRETE == "C" .and. Round(SZ1->Z1_FTRA / SZ1->Z1_QUANT,4) <> nvaltram .and. nvaltram > 0
			lregra := .F. //.T. Desabilitado dia 07/10/02 - MARCIANE
		EndIf
	EndDo
	SZ1->(DbSetOrder(nordem))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravar o valor do pedido encontrado                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SZ1")
	nordem := IndexOrd()
	DbSetOrder(0)
	DbGotop()
	Do while .not. eof()
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))
		If Marked("Z1_OK") .and. SZ1->Z1_FRETE == "C" .and. nvalmotm > 0 .and. SA1->A1_YFRECLI == 0
			While !Reclock("SZ1",.f.);EndDo
			SZ1->Z1_FTRA := Round(nvaltram * SZ1->Z1_QUANT,2)
			SZ1->Z1_FMOT := Round(nvalmotm * SZ1->Z1_QUANT,2)
			MsUnlock()
		EndIf
		DbSkip()
	EndDo
	SZ1->(DbSetOrder(nordem))
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificar varias entregas  para o mesmo municipio                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _copcoes $ "1,3"  .and. !lBlqFrete //bloqueia alterações nos valores do frete
	SZ3->(DbSetOrder(1))
	SZ3->(DbSeek(xFilial("SZ3")+_motor))
	//Alterado por Gustav em 04/04/06 por solicitação da Sra. Marciane.
	//Haverá acréscimo MV_YACFRE no valor do frete para mais de uma entrega no mesmo munuicipio, mesmo sendo agregrado.
	//excetuando a empresa 10 - Mogi
	//Alterado por Gustav em 13/06/06 - Volta a situação anterior, somente para não agregados - solicitação Marciane
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
			DbSelectArea("SZ1")
			nordem := IndexOrd()
			DbSetOrder(0)
			DbGotop()
			Do while .not. eof()
				SA1->(DbSetOrder(1))
				SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))
				If Marked("Z1_OK") .and. SZ1->Z1_FRETE == "C" .and. SA1->A1_YFRECLI == 0
					If lprimeiro
						cmun  := SZ1->Z1_MUNE
						cuf   := SZ1->Z1_UFE
						ccli  := SZ1->Z1_CLIENTE+SZ1->Z1_LOJA
						cprod := SZ1->Z1_PRODUTO
						lprimeiro := .F.
					Else
						If SZ1->Z1_MUNE == cmun .and. SZ1->Z1_UFE == cuf
							If SZ1->Z1_CLIENTE+SZ1->Z1_LOJA <> ccli
								lacres := .T.
								Exit
							EndIf
						EndIf
					EndIf
				EndIf
				DbSkip()
			EndDo
			If lacres .and. !Alltrim(Upper(SZ1->Z1_UFE)) $ "BA" .and. lregra == .F.
				lregra := .T.
				DbSelectArea("SZ1")
				DbSetOrder(0)
				DbGotop()
				Do while .not. eof()
					SA1->(DbSetOrder(1))
					SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))
					If Marked("Z1_OK") .and. SZ1->Z1_FRETE == "C" .and. SA1->A1_YFRECLI == 0
						While !Reclock("SZ1",.f.);EndDo
						IF !(SZ2->Z2_PLACA $ GETMV("MIZ_PLACAS"))
							SZ1->Z1_FMOT := SZ1->Z1_FMOT+Round(SZ1->Z1_QUANT*nacfre,2)
							SZ1->Z1_FTRA := SZ1->Z1_FTRA+Round(SZ1->Z1_QUANT*(Round(nacfre*nmulfre/ndivfre,2)),2)
						ENDIF
						MsUnlock()
					EndIf
					DbSkip()
				EndDo
			EndIf
			SZ1->(DbSetOrder(nordem))
		EndIf
	EndIf
	//Alterado por Gustav em 04/04/06 por solicitação da Sra. Marciane.
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificar varias entregas  para municipios diferentes com mesmo valor      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _copcoes $ "1,3"  .and. !lBlqFrete //bloqueia alterações nos valores do frete
	SZ3->(DbSetOrder(1))
	SZ3->(DbSeek(xFilial("SZ3")+_motor))
	//Alterado por Gustav em 04/04/06 por solicitação da Sra. Marciane.
	//Haverá acréscimo MV_YACFRE no valor do frete para mais de uma entrega no mesmo munuicipio, mesmo sendo agregrado.
	//excetuando a empresa 10 - Mogi
	//Alterado por Gustav em 13/06/06 - Volta a situação anterior, somente para não agregados - solicitação Marciane
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
			DbSelectArea("SZ1")
			nordem := IndexOrd()
			DbSetOrder(0)
			DbGotop()
			Do while .not. eof()
				SA1->(DbSetOrder(1))
				SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))
				If Marked("Z1_OK") .and. SZ1->Z1_FRETE == "C" .and. SA1->A1_YFRECLI == 0
				    nvaltra += Round(SZ1->Z1_FTRA / SZ1->Z1_QUANT,6)
					nvalmot += Round(SZ1->Z1_FMOT / SZ1->Z1_QUANT,6)

					If lprimeiro
						cmun    := SZ1->Z1_MUNE
						cuf     := SZ1->Z1_UFE
						// alterado  por sergio em 17/02/2011
						//nvaltra := Round(SZ1->Z1_FTRA / SZ1->Z1_QUANT,6)
						//nvalmot := Round(SZ1->Z1_FMOT / SZ1->Z1_QUANT,6)
						lprimeiro := .F.
					Else
						If SZ1->Z1_MUNE <> cmun .and. ;
							Round(SZ1->Z1_FTRA / SZ1->Z1_QUANT,6) == nvaltra .and. Round(SZ1->Z1_FMOT / SZ1->Z1_QUANT,6) == nvalmot
							lacres := .T.
						EndIf
						If Round(SZ1->Z1_FTRA / SZ1->Z1_QUANT,6) <> nvaltra .or. Round(SZ1->Z1_FMOT / SZ1->Z1_QUANT,6) <> nvalmot
							lacres := .F.
							exit
						EndIf
					EndIf
				EndIf
				DbSkip()
			EndDo
			If lacres .and. !Alltrim(Upper(SZ1->Z1_UFE)) $ "BA" .and. lregra == .F.
				lregra := .F. //.T. Desabilitado dia 07/10/02 - Marciane
				DbSelectArea("SZ1")
				DbSetOrder(0)
				DbGotop()
				Do while .not. eof()
					SA1->(DbSetOrder(1))
					SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))
					If Marked("Z1_OK") .and. SZ1->Z1_FRETE == "C" .and. SA1->A1_YFRECLI == 0
						While !Reclock("SZ1",.f.);EndDo
						IF !(SZ2->Z2_PLACA $ GETMV("MIZ_PLACAS"))
							SZ1->Z1_FMOT := SZ1->Z1_FMOT+Round(SZ1->Z1_QUANT*nacfre,2)
							SZ1->Z1_FTRA := SZ1->Z1_FTRA+Round(SZ1->Z1_QUANT*(Round(nacfre*nmulfre/ndivfre,2)),2)
						ENDIF
						MsUnlock()
					EndIf
					DbSkip()
				EndDo
			EndIf
			SZ1->(DbSetOrder(nordem))
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
		ExecBlock("MIZ050GR",.F.,.F.,aenvio)  // Esse fonte grava os regs na SZ8 e NR.OC NA SZ1 e imprime a OC.
	ELSE
		ExecBlock("MIZ050",.F.,.F.,aenvio)	  // Esse fonte grava os regs na SZ8 e NR.OC NA SZ1 e imprime a OC.
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
		//SZ8->Z8_STATUS		:= "1" //No pátio
		MsUnlock()
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizar placa no final para resolver problema no filtro                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _copcoes $ "1,3"
	DbSelectArea("SZ1")
	nordem := IndexOrd()
	DbSetOrder(0)
	DbGotop()
	Do while .not. eof()
		If Marked("Z1_OK")
			Reclock ("SZ1",.F.)
			SZ1->Z1_PLACA    := _placa
			MsUnlock()
		EndIf
		DbSkip()
	EndDo
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Encerra funcao                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Close(oDlg1)
End Transaction
/*
If _copcoes $ "13"
DbSelectArea("SZ1")
DbSetOrder(nordem)
DbGotop()
nmarcados:=0
oMarcados:Refresh()
ElseIf _copcoes $ "2"
DbSelectArea("SZ8")
DbGotop()
EndIf
*/
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
User Function DIALEG1

/*
Brwlegenda(cCadastro, "Legenda",{{"BR_BRANCO"  ,"Não Agenciado"},;
{"BR_LARANJA" ,"Agenciado - Programado"},;
{"BR_AMARELO" ,"Agenciado - No Patio"},;
{"BR_VERDE"   ,"Chamado"},;
{"BR_PINK"    ,"Pesado na Entrada"},;
{"BR_AZUL"    ,"Início Carga/Descarga"},;
{"BR_PRETO"   ,"Fim Carga/Descarga"},;
{"BR_VERMELHO","Em Espera"},;
{"BR_MARROM"  ,"F a t u r a d a"}})
*/
Brwlegenda(cCadastro, "Legenda",{{"BR_VERDE"   ,"Sem peso"},;
{"BR_AMARELO" ,"Pesado inicio"},;
{"BR_VERMELHO","Finalizado"}})

Return .T.


User Function JobTerSrv(p_cComutadora)
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
		
		If !Empty(SC7->C7_YOC)  //Caso outro usuário simultaneamente tenha usado este pedido em outra OC.
			MsgBox("ATENÇÃO: O pedido " +ALLTRIM(aPedMark[ixd,1])+ " está agenciado na OC: "+ALLTRIM(SC7->C7_YOC)+". Selecione outro pedido.","Atencao","STOP")
			// comentado por sergio em 08.07.2010 - temporariamente
			//SC7->(msUnlock())
			//Return
		EndIf
		
		SC7->C7_YOC = M->Z8_OC
		SC7->(MsUnlock())
	EndIf
Next

Return(lres)

Static Function fCritPag()

lRes := .T.

if !lusaPager; return lres ; endif

if !Empty(M->Z8_PAGER) .and. (val(M->Z8_PAGER)==0 .or. len(alltrim(M->Z8_PAGER))<2 )
	ALERT("Pager nao pode ser igual zero e nem com apenas 1(um) algarismo !")
	Return(.F.)
endif

nMaxPager:= getnewPar('MV_MAXPAGE',65)
//nMaxPager:= SuperGetMv('MV_MAXPAGE',.F.,65,cFilAnt)
if !Empty(M->Z8_PAGER) .and. val(M->Z8_PAGER) > nMaxPager
	ALERT("A numeração do pager deve ser menor ou igual a [ '"+strzero(nMaxPager,2)+"' ]")
	Return(.F.)
endif

If !Empty(M->Z8_STATUS) .AND. Empty(M->Z8_PAGER)
	ALERT("Informe o número do pager.")
	Return(.F.)
EndIf

If Empty(M->Z8_STATUS) .OR. Empty(M->Z8_PAGER)
	Return(lRes)
EndIf


aAreaAtu := GetArea()

cSql := "SELECT Z8_OC FROM "+RetSqlName("SZ8")+" SZ8 "
cSql += " WHERE SZ8.D_E_L_E_T_ = ' '"
cSql += " AND   SZ8.Z8_FILIAL  = '" +xFilial("SZ8")+ "'"
//cSql += " AND   SZ8.Z8_PESOFIN = 0 "
cSql += " AND   SZ8.Z8_PAGER   = '" + M->Z8_PAGER + "'"
If Altera
	//	cSql += " AND   SZ8.Z8_PAGER   <> '" + SZ8->Z8_PAGER + "'"
	cSql += " AND   SZ8.Z8_OC   <> '" + M->Z8_OC + "'"
EndIf

If Select("QrySZ8") > 0
	dbSelectArea("QrySZ8")
	QrySZ8->(DbCloseArea())
EndIf
//wSQL := ChangeQuery(wSQL)
TcQuery cSql New Alias "QrySZ8"

If  QrySZ8->(!Eof())
	ALERT("Nº DE PAGER NÃO PERMITIDO: Este pager já está sendo usado na ORDEM DE CARREGAMENTO/DESCARREGAMENTO: "+Alltrim(QrySZ8->Z8_OC)+". Verifique.")
	QrySZ8->(DbCloseArea())
	RestArea(aAreaAtu)
	lRes := .F.
EndIf

RestArea(aAreaAtu)

Return(lRes)







User Function frmLacres(p_cLacre)
Local cRet:=""
local cLacre := Space(6)
local oFont1     := TFont():New( "Verdana",0,-12,,.T.,0,,700,.F.,.F.,,,,,, )
local warea:= getArea()

private oLacre
private oBrw1




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


@ 001.3,003 GET oLacre VAR cLacre SIZE 100, 10 OF oDlg //valid fnValid(cLacre)
oLacre:bLostFocus:=  {|| fnValid('1', cLacre), oDlg:refresh() }

oBrw1 := TCBrowse():New( 030,005,150,140,,waHeader,waColSizes,oDlg,,,,,{||},,oFont1,,,,,.F.,,.T.,,.F.,,.T.,.T.)


fnValid(	ctpRefresh )


ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpc1 := 1, cRet:=fnConfirm(), oDlg:End()},{|| nOpc1 := 2,oDlg:End()}) CENTERED



restArea(warea)
Return(cRet)


Static Function FnConfirm()
Local cRet:=""
Local wArea:=GetArea()


//If Aviso("Atenção !","Confirma selecao ?",{"Sim","Nao"}) == 2
//   Return(cRet)
//Endif

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




static function fnValid(p_ctpRefresh, p_cGetLacre)
local lret:= .t.
local nMaxLacre:= 8

if p_ctpRefresh=='1' .and. empty(p_cGetLacre); return .f. ; endif


ncont:=0

for i:=1 to len(acolsLacres)
	
	ncont++
	
	//verifica duplicidade
	if alltrim(acolsLacres[i,1]) == alltrim(p_cGetlacre)
		alert('Lacre ja informado na posicao de nr. [ '+str(i,2)+' ]')
		aDel( acolsLacres, i )
		aSize( acolsLacres, Len(acolsLacres)-1 )
		lret:= .f.
		exit
	endif
next

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



static function setDesmark()
	local warea:= getArea()
	              	
	If SZ8->Z8_TPOPER == "C" .AND. Len(aPedDesMar)<>0
		dbSelectArea('SZ1')
		dbsetorder(1)
		For ixd := 1 TO Len(aPedDesMar)
			If dbSeek(xFilial('SZ1')+aPedDesMar[ixd,1]) .and. sz1->z1_oc == sz8->z8_oc
				While !RecLock("SZ1",.F.) ; End
				SZ1->Z1_OC = " "
				SZ1->Z1_PLACA = SPACE(07)
				SZ1->Z1_MOTOR = " "
				SZ1->(MsUnlock())
			EndIf
		Next
	ElseIf SZ8->Z8_TPOPER == "D" .AND. Len(aPedDesMar)<>0 .and. sz1->z1_oc == sz8->z8_oc
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