#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Pa0037    º Autor ³ Alexandro da Silva º Data ³  09/08/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para Acerto dos pedidos                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0037()

Private _cPerg    := "PA0037"
Private _oGeraTxt

Private _cString  := "SC6"


Pergunte(_cPerg,.F.)

dbSelectArea("SC6")
dbSetOrder(9)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 150,1 TO 380,450 DIALOG _oGeraTxt TITLE OemToAnsi("Ajustes nos Pedidos de Venda")
@ 02,10 TO 080,220
@ 10,018 Say " Este programa ira ajustar os pedidos Que Foram Eliminados Re- " SIZE 160,7
@ 18,018 Say " siduos em relação aos novos pedidos incluidos manualmente no  " SIZE 160,7
@ 26,018 Say " Sistema.                                                      " SIZE 160,7
@ 85,128 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 85,158 BMPBUTTON TYPE 02 ACTION Close(_oGeraTxt)
@ 85,188 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)

Activate Dialog _oGeraTxt Centered

Return



Static Function OkGeraTxt()

Close(_oGeraTxt)

Private oProcess
oProcess := MsNewProcess():New({|| Regua(oProcess)},"","",.F.)
oProcess :cTitle:="Processando Pedidos"
oProcess :Activate()

Return


Static Function Regua(oProcess)

oProcess:SetRegua1(3)
oProcess:IncRegua1("Processando Pedidos")
VerPedTot()
oProcess:IncRegua1("Processando Pedidos")
ProcVel()
oProcess:IncRegua1("Processando Pedidos")
ProcNew()


dbSelectArea("PEDN")
dbCloseArea()
             
dbSelectArea("PEDV")
dbCloseArea()
/*
Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| Proc1(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
*/

Return


Static Function VerPedTot()

aStru := {}
AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
AADD(aStru,{"PEDIDO"   , "C" , 06, 0 })
AADD(aStru,{"ITEM"     , "C" , 02, 0 })
AADD(aStru,{"CLIENTE"  , "C" ,  6, 0 })
AADD(aStru,{"LOJA"     , "C" , 02, 0 })
AADD(aStru,{"ENTREGA"  , "D" , 08, 0 })
AADD(aStru,{"QTDE"     , "N" , 14, 2 })
AADD(aStru,{"SDOQTDE"  , "N" , 14, 2 })
AADD(aStru,{"LANCADO"  , "C" ,  1, 0 })
AADD(aStru,{"PEDN"     , "C" ,  1, 0 })

cArqLOG1 := CriaTrab(aStru,.T.)
cIndLOG1 := "PRODUTO+DTOS(ENTREGA)+PEDIDO+ITEM"
dbUseArea(.T.,,cArqLOG1,"PEDN",.F.,.F.)

dbSelectArea("PEDN")
IndRegua("PEDN",cArqLog1,cIndLog1,,,"Criando Trabalho...")

aStru := {}
AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
AADD(aStru,{"PEDIDO"   , "C" , 06, 0 })
AADD(aStru,{"ITEM"     , "C" , 02, 0 })
AADD(aStru,{"CLIENTE"  , "C" ,  6, 0 })
AADD(aStru,{"LOJA"     , "C" , 02, 0 })
AADD(aStru,{"ENTREGA"  , "D" , 08, 0 })
AADD(aStru,{"QTDE"     , "N" , 14, 2 })
AADD(aStru,{"SDOQTDE"  , "N" , 14, 2 })
AADD(aStru,{"LANCADO"  , "C" ,  1, 0 })
AADD(aStru,{"PEDV"     , "C" ,  1, 0 })

cArqLOG3 := CriaTrab(aStru,.T.)
cIndTemp1:= Substr(CriaTrab(NIL,.F.),1,7)+"1"
cIndTemp2:= Substr(CriaTrab(NIL,.F.),1,7)+"2"
cIndL1   := "PRODUTO+DTOS(ENTREGA)+PEDIDO+ITEM"
cIndL2   := "PRODUTO+LANCADO+DTOS(ENTREGA)"
dbUseArea(.T.,,cArqLOG3,"PEDV",.F.,.F.)

IndRegua("PEDV",cIndTemp1,cIndL1,,,"Criando Trabalho...")
IndRegua("PEDV",cIndTemp2,cIndL2,,,"Criando Trabalho...")

Set Cursor Off
DbClearIndex()
DbSetIndex(cIndTemp1+OrdBagExt())
DbSetIndex(cIndTemp2+OrdBagExt())

////////////////////////////////////////////////
/////// Parametros   PA0037                 ////
/////// MV_PAR01 : Cliente DE ?   	        ////
/////// MV_PAR02 : Loja  De   ?             ////
/////// MV_PAR03 : Emissao De ?             ////
/////// MV_PAR04 : Emissao Ate?             ////
/////// MV_PAR05 : Pedido De  ?             ////
/////// MV_PAR06 : Pedido Ate ?             ////
//////  MV_PAR07 : Entrega De ?   			////
/////// MV_PAR08 : Entrega Ate?   			////
/////// MV_PAR09 : Emis.Pedido Novo  De ?   ////
/////// MV_PAR10 : Emis.Pedido Novo  Ate?   ////
////////////////////////////////////////////////

dbSelectArea("SC5")
dbOrderNickName("INDSC51")
dbseek(xFilial("SC5")+MV_PAR01+DTOS(MV_PAR03),.T.)

oProcess:SetRegua2(LastRec())

While !Eof() .And. SC5->C5_CLIENTE+DTOS(SC5->C5_EMISSAO) <= MV_PAR02+DTOS(MV_PAR04)
	
	oProcess:IncRegua2("Relacionando Pedidos!!")
	
	If SC5->C5_CLIENTE+SC5->C5_LOJACLI != MV_PAR01+MV_PAR02
		dbSelectArea("SC5")
		dbSkip()
		Loop
	Endif
	
	If SC5->C5_NUM < MV_PAR05 .Or. SC5->C5_NUM > MV_PAR06
		dbSelectArea("SC5")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek(xFilial("SC6")+SC5->C5_NUM)
		
		_cChavSC6 := SC6->C6_NUM 
		While !Eof() .And. _cChavSC6 == SC6->C6_NUM 
			
			If SC6->C6_ENTREG  <  MV_PAR07  .Or. SC6->C6_ENTREG  > MV_PAR08
				dbSelectArea("SC6")
				dbSkip()
				Loop
			Endif
			
			If SC6->C6_QTDVEN == SC6->C6_QTDENT
				dbSelectArea("SC6")
				dbSkip()
				Loop
			Endif
			
			If SC5->C5_EMISSAO >= MV_PAR09 .And. SC5->C5_EMISSAO <= MV_PAR10
				dbSelectArea("PEDN")
				dbSetOrder(1)
				If !dbSeek(SC6->C6_PRODUTO+DTOS(SC6->C6_ENTREG)+SC6->C6_NUM+SC6->C6_ITEM )
					dbSelectArea("PEDN")
					RecLock("PEDN",.T.)
					PEDN->PRODUTO := SC6->C6_PRODUTO
					PEDN->CLIENTE := SC6->C6_CLI
					PEDN->LOJA    := SC6->C6_LOJA
					PEDN->ENTREGA := SC6->C6_ENTREG
					PEDN->QTDE    := SC6->C6_QTDVEN - SC6->C6_QTDENT
					PEDN->PEDIDO  := SC6->C6_NUM
					PEDN->ITEM    := SC6->C6_ITEM
					MsUnlock()
				Endif				
			Else
				dbSelectArea("PEDV")
				dbSetOrder(1)
				If !dbSeek(SC6->C6_PRODUTO+DTOS(SC6->C6_ENTREG)+SC6->C6_NUM+SC6->C6_ITEM )
					dbSelectArea("PEDV")
					RecLock("PEDV",.T.)
					PEDV->PRODUTO := SC6->C6_PRODUTO
					PEDV->CLIENTE := SC6->C6_CLI
					PEDV->LOJA    := SC6->C6_LOJA
					PEDV->ENTREGA := SC6->C6_ENTREG
					PEDV->QTDE    := SC6->C6_QTDVEN - SC6->C6_QTDENT
					PEDV->PEDIDO  := SC6->C6_NUM
					PEDV->ITEM    := SC6->C6_ITEM
					MsUnlock()
				Endif				
			Endif
			dbSelectArea("SC6")
			dbSkip()
		EndDo
	Endif
	
	dbSelectArea("SC5")
	dbSkip()
EndDo

Return



Static Function ProcNew(_lFim)


dbSelectArea("PEDN")
dbGotop()
oProcess:SetRegua2(LastRec())

While !Eof()
	
	oProcess:IncRegua2("Relacionando Pedidos Novos!!")
	
	dbSelectArea("PEDV")
	dbSetOrder(2)
	If dbSeek(PEDN->PRODUTO+"")
		_lSair := .F.
		While !Eof().And. PEDN->PRODUTO == PEDV->PRODUTO .And. !_lSair
			
			If PEDV->LANCADO == "S"
				dbSelectArea("PEDV")
				dbSkip()
				Loop
			Endif
			
			dbSelectArea("SC6")
			dbSetOrder(1)
			If dbSeek(xFilial("SC6")+PEDV->PEDIDO+PEDV->ITEM+PEDV->PRODUTO)
				_aAreaSC6 := GetArea()
			
				If SC6->C6_STALTER == "S"
					dbSelectArea("PEDV")
					dbSkip()
					Loop
				Endif
			
				If PEDN->QTDE == PEDV->QTDE
					dbSelectArea("SC6")
					RecLock("SC6",.F.)
					SC6->C6_ENTORI   := SC6->C6_ENTREG
					SC6->C6_ENTREG  := PEDN->ENTREGA
					SC6->C6_STALTER := "S"
					MsUnlock()
					_lSair          := .T.
				
					dbSelectArea("SC6")
					dbSetOrder(1)
					If dbSeek(xFilial("SC6")+PEDN->PEDIDO+PEDN->ITEM+PEDN->PRODUTO)
						dbSelectArea("SC6")
						RecLock("SC6",.F.)
						SC6->C6_BLQ     := "R"
						SC6->C6_STALTER := "S"
						MsUnlock()
					Endif
					RestArea(_aAreaSC6)
				ElseIf PEDN->QTDE < PEDV->QTDE
				
					dbSelectArea("SC6")
					RecLock("SC6",.F.)
					If Empty(SC6->C6_QTORI)
						SC6->C6_QTORI  := SC6->C6_QTDVEN - SC6->C6_QTDENT
						SC6->C6_ENTORI := SC6->C6_ENTREG
					Endif
					SC6->C6_ENTREG  := PEDN->ENTREGA
					SC6->C6_QTDVEN  := PEDN->QTDE
					SC6->C6_STALTER := "S"
					MsUnlock()
				
					dbSelectArea("SC6")
					dbSetOrder(1)
					If dbSeek(xFilial("SC6")+PEDN->PEDIDO+PEDN->ITEM+PEDN->PRODUTO)
						dbSelectArea("SC6")
						RecLock("SC6",.F.)
						SC6->C6_BLQ     := "R"
						SC6->C6_STALTER := "S"
						MsUnlock()
					Endif
					RestArea(_aAreaSC6)
					_lSair          := .T.
				ElseIf PEDN->QTDE > PEDV->QTDE
					dbSelectArea("SC6")
					RecLock("SC6",.F.)
					If Empty(SC6->C6_QTORI)
						SC6->C6_QTORI  := SC6->C6_QTDVEN - SC6->C6_QTDENT
						SC6->C6_ENTORI := SC6->C6_ENTREG
					Endif
					SC6->C6_ENTREG  := PEDN->ENTREGA
					SC6->C6_STALTER := "S"
					MsUnlock()
				Endif
			
				dbSelectArea("PEDV")
				RecLock("PEDV",.F.)
				PEDV->LANCADO := "S"
				MsUnLock()
			Endif			
		
			dbSelectArea("PEDV")
			dbSkip()		
		EndDo
	Endif
	dbSelectArea("PEDN")
	dbSkip()				
EndDo

Return


Static Function ProcVel(_lFim)


dbSelectArea("PEDV")
dbGotop()
oProcess:SetRegua2(LastRec())

While !Eof()
	
	oProcess:IncRegua2("Eliminando Residuo Pedidos Antigos!!")
	
	dbSelectArea("PEDN")
	dbSetOrder(1)
	If !dbSeek(PEDV->PRODUTO)
		
		dbSelectArea("SC6")
		dbSetOrder(1)
		If dbSeek(xFilial("SC6")+PEDV->PEDIDO+PEDV->ITEM+PEDV->PRODUTO)
			dbSelectArea("SC6")
			RecLock("SC6",.F.)
			SC6->C6_BLQ     := "R"
			SC6->C6_STALTER := "S"
			MsUnlock()
		Endif
	Endif
	dbSelectArea("PEDV")
	dbSkip()
EndDo

Return						       