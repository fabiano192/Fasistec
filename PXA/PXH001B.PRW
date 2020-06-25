#Include "Protheus.ch"
#include "rwmake.ch"
#INCLUDE 'COLORS.CH'
#Include "TOPCONN.CH"
#XCommand ROLLBACK TRANSACTION => DisarmTransaction()

User Function PXH001B()

Local cAlias := "SZH"

Private cCadastro := "Cupom de Pesagem"
Private aCores := {}
Private aRotina := {}
Private aFixe	:= {}
Private aAcho	:= {}
Private aCpos	:= {}

AADD(aRotina,{"Pesquisar"     ,"AxPesqui",0,1})
AADD(aRotina,{"Visualizar"    ,"U_smCupVis",0,2})
AADD(aRotina,{"Incluir"       ,"U_smCupInc",0,3})
AADD(aRotina,{"Alterar"       ,"U_smCupAlt",0,4})
AADD(aRotina,{"Legenda"       ,"U_DIALEG1",0,6})
AADD(aRotina,{"Imprimir Tickt","U_PXH00104",0,7})

AADD(aCores,{'if(sZH->ZH_pesini<=0,.t.,.f.)',"BR_VERDE" })
AADD(aCores,{'if(sZH->ZH_pesini>0.and.sZH->ZH_pesfin<=0,.t.,.f.)' ,"BR_AMARELO" })
AADD(aCores,{'if(sZH->ZH_pesliq>0,.t.,.f.)',"BR_VERMELHO" })

dbSelectArea(cAlias)
dbSetOrder(1)

mBrowse(6,1,22,75,cAlias,/*Fixe*/,,,,,aCores)

Return Nil




//** Inclui **//
User Function smCupInc(cAlias, nReg, nOpc)

Local nOpcao := 0
Local aButtons := {}

AADD( aButtons, {"CARGA", {|| U_PXH00101('2', 'D')    },"Peso inicial"} )

nOpcao := AxInclui(cAlias,nReg,nOpc,aAcho,/*aCpos*/,,"u_fVld_IA()",,,aButtons) // Identifica corretamente a opção definida para o função em aRotinas com mais // do que os 5 elementos padrões.

Return Nil


User Function smCupAlt(cAlias, nReg, nOpc)

Local nOpcao := 0
Local aButtons := {}

if sZH->ZH_pesliq >0
	ALERT("ALTERAÇÃO NÃO PERMITIDA: Pesagem finalizada! ")
	Return Nil
EndIf

AADD( aButtons, {"CARGA", {|| U_PXH00103('6', 'D')    },"Peso final"} )

nOpcao := AxAltera(cAlias,nReg,nOpc,aAcho,/*aCpos*/,,,"u_fVld_IA()",,,aButtons) // Identifica corretamente a opção definida para o função em aRotinas com mais // do que os 5 elementos padrões.

	If SZH->ZH_PESFIN > 0 
		U_PXH001A(SZH->ZH_NUM ,'SZH')
	Endif

Return Nil


//** Inclui **//
User Function smCupVis(cAlias, nReg, nOpc)
Local nOpcao := 0

nOpcao := AxVisual(cAlias,nReg,nOpc,aAcho,/*aCpos*/,,) // Identifica corretamente a opção definida para o função em aRotinas com mais // do que os 5 elementos padrões.
Return Nil


User Function fVld_IA()

Local lRes := .T.

Return(lRes)


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
//³ Atualiza SZH - Pedido de Vendas MIZU                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _copcoes $ "2"
	Reclock ("SZ8",.F.)
	SZ8->Z8_PSENT    := _peso
	SZ8->Z8_HORPES   := left(time(),5)
	MsUnlock()
	DbSelectArea("SZH")
	DbSetOrder(8)
	DbSeek(xFilial("SZH")+SZ8->Z8_OC)
	Do while .not. eof() .and. ZH_FILIAL == xFilial("SZH") .and. SZH->ZH_OC == SZ8->Z8_OC
		While !Reclock ("SZH",.F.);EndDo
		SZH->ZH_PSENT    := _peso
		MsUnlock()
		DbSkip()
	EndDo
Else
	DbSelectArea("SZH")
	nordem := IndexOrd()
	DbSetOrder(0)
	DbGotop()
	Do while .not. eof()
		//If Posicione("SZH",1,xFilial("SZH")+SZH->ZH_NUM,"ZH_NUM")  // forço a busca no arquivo caso outro usuário simultaneamente tenha usado este pedido em outra OC.
		//EndIf
		If Marked("ZH_OK")
			Reclock ("SZH",.F.)
			If !Empty(SZH->ZH_OC) .and. sZH->ZH_oc <> sz8->z8_oc //Caso outro usuário simultaneamente tenha usado este pedido em outra OC.
				MsgBox("ATENÇÃO: O pedido " +ALLTRIM(SZH->ZH_NUM)+ " está agenciado na OC: "+ALLTRIM(SZH->ZH_OC)+". Selecione outro pedido.","Atencao","STOP")
				SZH->(msUnlock())
				ROLLBACK TRANSACTION
				Return
			EndIf
			SZH->ZH_YPM := cpm
			SZH->ZH_OC		 := M->Z8_OC
			If _copcoes $ "3"
				SZH->ZH_PSENT    := _peso
			EndIf
			If _copcoes $ "1,3"
				SZH->ZH_MOTOR    := _motor
				SZH->ZH_PLCAR    := plcar
				SZH->ZH_HORENT   := _hora
				SZH->ZH_PALENT   := _pent
				SZH->ZH_PALSAI   := _psai
				SZH->ZH_NMOT     := SZ3->Z3_NOME
				SZH->ZH_FORNECE  := cfornece
				SZH->ZH_LOJAF    := clojaf
				SZH->ZH_LACRE    := _lacre
			EndIf
			msUnlock()
			dbCommit()
		EndIf
		DbSkip()
	EndDo
	DbSelectArea("SZH")
	DbSetOrder(nordem)
	DbGotop()
	
	
	//setDesmark()
	
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recalcular o frete                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _copcoes $ "1,3"  //.and. !lBlqFrete //bloqueia alterações nos valores do frete
	DbSelectArea("SZH")
	nordem := IndexOrd()
	DbSetOrder(0)
	DbGotop()
	Do while .not. eof()
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SZH->ZH_CLIENTE+SZH->ZH_LOJA))
		If Marked("ZH_OK") .and. SA1->A1_YFRECLI == 0
			SZ3->(DbSetOrder(1))
			SZ3->(DbSeek(xFilial("SZ3")+_motor))
			
			If SZH->ZH_UNID == "SC"
				
				If  SZ3->Z3_TIPO == "1" .and. Empty(cFornece)
					MsgBox("Voce esta lancando um transporte com CTR, Sem Transportadora","Atencao","STOP")
					ROLLBACK TRANSACTION
					Return
				ElseIf SZ3->Z3_TIPO == "2" .and. !Empty(cFornece)
					MsgBox("Voce esta lancando um transporte com Motorista RPA, usando CTR","Atencao","STOP")
					ROLLBACK TRANSACTION
					Return
				EndIf
				
				IF SZH->ZH_FRETE == "C"
					If  SZ3->Z3_TIPO == "1" /* CTR SZG */
						SZG->(DbSetOrder(1))
						SZG->(DbSeek(xFilial("SZG")+SZH->ZH_UFE+SZH->ZH_MUNE+cFornece+cLojaf))
						//	MsgBox("TIPO 1, CTR PEGA EM BAIXO","Atencao","ALERT")
						While !Reclock("SZH",.f.);EndDo
						
						//ANULADA POR AUGUSTO EM 12-02-2009 AS 12:03
						//SZH->ZH_FTRA := Round(SZH->ZH_QUANT * Iif(SZG->ZG_FAGRTRA>0,SZG->ZG_FAGRTRA,SZG->ZG_FRETE) ,2)
						//SZH->ZH_FMOT := Round(SZH->ZH_QUANT * Iif(SZG->ZG_FAGRMOT>0,SZG->ZG_FAGRMOT,SZG->ZG_FMOT) ,2)
						
						//AS DUAS LINHAS ABAIXO FORAM ALTERADAS CONFORME SOLICITAÇÃO DA JEANE
						SZH->ZH_FTRA := Round(SZH->ZH_QUANT * Iif(SZ3->Z3_AGREGA=="S",SZG->ZG_FAGRTRA,SZG->ZG_FRETE) ,2)
						SZH->ZH_FMOT := Round(SZH->ZH_QUANT * Iif(SZ3->Z3_AGREGA=="S",SZG->ZG_FAGRMOT,SZG->ZG_FMOT) ,2)
						
					Else /* RPA SZ4 */
						SZ4->(DbSetOrder(1))
						SZ4->(DbSeek(xFilial("SZ4")+SZH->ZH_UFE+SZH->ZH_MUNE))
						//	MsgBox("TIPO 2, RPA PEGA EM CIMA","Atencao","ALERT")
						
						While !Reclock("SZH",.f.);EndDo
						
						//ANULADA POR AUGUSTO EM 12-02-2009 AS 12:03
						//SZH->ZH_FTRA := Round(SZH->ZH_QUANT * Iif(SZ4->Z4_FAGRTRA>0,SZ4->Z4_FAGRTRA,SZ4->Z4_FRETE) ,2)
						//SZH->ZH_FMOT := Round(SZH->ZH_QUANT * Iif(SZ4->Z4_FAGRMOT>0,SZ4->Z4_FAGRMOT,SZ4->Z4_FMOT) ,2)
						
						//AS DUAS LINHAS ABAIXO FORAM ALTERADAS CONFORME SOLICITAÇÃO DA JEANE
						SZH->ZH_FTRA := Round(SZH->ZH_QUANT * Iif(SZ3->Z3_AGREGA=="S",SZ4->Z4_FAGRTRA,SZ4->Z4_FRETE) ,2)
						SZH->ZH_FMOT := Round(SZH->ZH_QUANT * Iif(SZ3->Z3_AGREGA=="S",SZ4->Z4_FAGRMOT,SZ4->Z4_FMOT) ,2)
					EndIf
				ENDIF
				
				MsUnlock()
			EndIf
		EndIf
		DbSelectArea("SZH")
		DbSkip()
	EndDo
	SZH->(DbSetOrder(nordem))
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificar o maior frete para regravar no pedido                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _copcoes $ "1,3"  .and. !lBlqFrete //bloqueia alterações nos valores do frete
	SZ3->(DbSetOrder(1))
	SZ3->(DbSeek(xFilial("SZ3")+_motor))
	nvalmotm := 0
	nvaltram := 0
	DbSelectArea("SZH")
	nordem := IndexOrd()
	DbSetOrder(0)
	DbGotop()
	Do while .not. eof()
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SZH->ZH_CLIENTE+SZH->ZH_LOJA))
		If Marked("ZH_OK") .and. SZH->ZH_FRETE == "C" .and. SA1->A1_YFRECLI == 0
			If cEmpAnt == "01"
				If cfilant == "03" .or. ;
					(SZ3->Z3_AGREGA == "S" .and. SZ3->Z3_TIPO == "1" .and. Alltrim(SZH->ZH_UFE)=="ES") .or. ;
					(SZ3->Z3_AGREGA == "N" .and. SZ3->Z3_TIPO == "1" .and. Alltrim(SZH->ZH_UFE)$"RJ,MG,ES")
					If Round(SZH->ZH_FMOT / SZH->ZH_QUANT,4) > nvalmotm
						nvalmotm  := Round(SZH->ZH_FMOT / SZH->ZH_QUANT,4)
						nvaltram  := Round(SZH->ZH_FTRA / SZH->ZH_QUANT,4)
					EndIf
				EndIf
			ElseIf cEmpAnt == "11"
				If Round(SZH->ZH_FMOT / SZH->ZH_QUANT,4) > nvalmotm
					nvalmotm  := Round(SZH->ZH_FMOT / SZH->ZH_QUANT,4)
					nvaltram  := Round(SZH->ZH_FTRA / SZH->ZH_QUANT,4)
				EndIf
			EndIf
		EndIf
		DbSkip()
		If Marked("ZH_OK") .and. SZH->ZH_FRETE == "C" .and. Round(SZH->ZH_FTRA / SZH->ZH_QUANT,4) <> nvaltram .and. nvaltram > 0
			lregra := .F. //.T. Desabilitado dia 07/10/02 - MARCIANE
		EndIf
	EndDo
	SZH->(DbSetOrder(nordem))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravar o valor do pedido encontrado                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SZH")
	nordem := IndexOrd()
	DbSetOrder(0)
	DbGotop()
	Do while .not. eof()
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SZH->ZH_CLIENTE+SZH->ZH_LOJA))
		If Marked("ZH_OK") .and. SZH->ZH_FRETE == "C" .and. nvalmotm > 0 .and. SA1->A1_YFRECLI == 0
			While !Reclock("SZH",.f.);EndDo
			SZH->ZH_FTRA := Round(nvaltram * SZH->ZH_QUANT,2)
			SZH->ZH_FMOT := Round(nvalmotm * SZH->ZH_QUANT,2)
			MsUnlock()
		EndIf
		DbSkip()
	EndDo
	SZH->(DbSetOrder(nordem))
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
			DbSelectArea("SZH")
			nordem := IndexOrd()
			DbSetOrder(0)
			DbGotop()
			Do while .not. eof()
				SA1->(DbSetOrder(1))
				SA1->(DbSeek(xFilial("SA1")+SZH->ZH_CLIENTE+SZH->ZH_LOJA))
				If Marked("ZH_OK") .and. SZH->ZH_FRETE == "C" .and. SA1->A1_YFRECLI == 0
					If lprimeiro
						cmun  := SZH->ZH_MUNE
						cuf   := SZH->ZH_UFE
						ccli  := SZH->ZH_CLIENTE+SZH->ZH_LOJA
						cprod := SZH->ZH_PRODUTO
						lprimeiro := .F.
					Else
						If SZH->ZH_MUNE == cmun .and. SZH->ZH_UFE == cuf
							If SZH->ZH_CLIENTE+SZH->ZH_LOJA <> ccli
								lacres := .T.
								Exit
							EndIf
						EndIf
					EndIf
				EndIf
				DbSkip()
			EndDo
			If lacres .and. !Alltrim(Upper(SZH->ZH_UFE)) $ "BA" .and. lregra == .F.
				lregra := .T.
				DbSelectArea("SZH")
				DbSetOrder(0)
				DbGotop()
				Do while .not. eof()
					SA1->(DbSetOrder(1))
					SA1->(DbSeek(xFilial("SA1")+SZH->ZH_CLIENTE+SZH->ZH_LOJA))
					If Marked("ZH_OK") .and. SZH->ZH_FRETE == "C" .and. SA1->A1_YFRECLI == 0
						While !Reclock("SZH",.f.);EndDo
						IF !(SZ2->Z2_PLACA $ GETMV("MIZ_PLACAS"))
							SZH->ZH_FMOT := SZH->ZH_FMOT+Round(SZH->ZH_QUANT*nacfre,2)
							SZH->ZH_FTRA := SZH->ZH_FTRA+Round(SZH->ZH_QUANT*(Round(nacfre*nmulfre/ndivfre,2)),2)
						ENDIF
						MsUnlock()
					EndIf
					DbSkip()
				EndDo
			EndIf
			SZH->(DbSetOrder(nordem))
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
			DbSelectArea("SZH")
			nordem := IndexOrd()
			DbSetOrder(0)
			DbGotop()
			Do while .not. eof()
				SA1->(DbSetOrder(1))
				SA1->(DbSeek(xFilial("SA1")+SZH->ZH_CLIENTE+SZH->ZH_LOJA))
				If Marked("ZH_OK") .and. SZH->ZH_FRETE == "C" .and. SA1->A1_YFRECLI == 0
					nvaltra += Round(SZH->ZH_FTRA / SZH->ZH_QUANT,6)
					nvalmot += Round(SZH->ZH_FMOT / SZH->ZH_QUANT,6)
					
					If lprimeiro
						cmun    := SZH->ZH_MUNE
						cuf     := SZH->ZH_UFE
						// alterado  por sergio em 17/02/2011
						//nvaltra := Round(SZH->ZH_FTRA / SZH->ZH_QUANT,6)
						//nvalmot := Round(SZH->ZH_FMOT / SZH->ZH_QUANT,6)
						lprimeiro := .F.
					Else
						If SZH->ZH_MUNE <> cmun .and. ;
							Round(SZH->ZH_FTRA / SZH->ZH_QUANT,6) == nvaltra .and. Round(SZH->ZH_FMOT / SZH->ZH_QUANT,6) == nvalmot
							lacres := .T.
						EndIf
						If Round(SZH->ZH_FTRA / SZH->ZH_QUANT,6) <> nvaltra .or. Round(SZH->ZH_FMOT / SZH->ZH_QUANT,6) <> nvalmot
							lacres := .F.
							exit
						EndIf
					EndIf
				EndIf
				DbSkip()
			EndDo
			If lacres .and. !Alltrim(Upper(SZH->ZH_UFE)) $ "BA" .and. lregra == .F.
				lregra := .F. //.T. Desabilitado dia 07/10/02 - Marciane
				DbSelectArea("SZH")
				DbSetOrder(0)
				DbGotop()
				Do while .not. eof()
					SA1->(DbSetOrder(1))
					SA1->(DbSeek(xFilial("SA1")+SZH->ZH_CLIENTE+SZH->ZH_LOJA))
					If Marked("ZH_OK") .and. SZH->ZH_FRETE == "C" .and. SA1->A1_YFRECLI == 0
						While !Reclock("SZH",.f.);EndDo
						IF !(SZ2->Z2_PLACA $ GETMV("MIZ_PLACAS"))
							SZH->ZH_FMOT := SZH->ZH_FMOT+Round(SZH->ZH_QUANT*nacfre,2)
							SZH->ZH_FTRA := SZH->ZH_FTRA+Round(SZH->ZH_QUANT*(Round(nacfre*nmulfre/ndivfre,2)),2)
						ENDIF
						MsUnlock()
					EndIf
					DbSkip()
				EndDo
			EndIf
			SZH->(DbSetOrder(nordem))
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
		ExecBlock("MIZ050GR",.F.,.F.,aenvio)  // Esse fonte grava os regs na SZ8 e NR.OC NA SZH e imprime a OC.
	ELSE
		ExecBlock("MIZ050",.F.,.F.,aenvio)	  // Esse fonte grava os regs na SZ8 e NR.OC NA SZH e imprime a OC.
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
	DbSelectArea("SZH")
	nordem := IndexOrd()
	DbSetOrder(0)
	DbGotop()
	Do while .not. eof()
		If Marked("ZH_OK")
			Reclock ("SZH",.F.)
			SZH->ZH_PLACA    := _placa
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
DbSelectArea("SZH")
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