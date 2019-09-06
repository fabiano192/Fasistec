#include "rwmake.ch"

User Function AceSC2()

SetPrvt("_cAliOri,_nOrdOri,_nRecOri,_aStrREt,_cArqRet")

_cAliOri := Alias()
_nOrdOri := IndexOrd()
_nRecOri := Recno()
_lBx     := .F.

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| ACESC21(@_lFim) }
Private _cTitulo01 := 'Processando Ordem de producao!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

MSGINFO("Alteracao Efetuada com Sucesso !!! ")
Return



Static Function ACESC21(_lFim)

dbSelectArea("SC2")
dbSetOrder(1)
dbGotop()

ProcRegua(LastRec())

While !Eof()
	
	IncProc()
	
	dbSelectArea("SB1")
	dbSetOrder(1)      
	If dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
	   If SB1->B1_GRUPO == "PIC "
	
	   Endif
	Endif
	_cChavSC2 := SC2->C2_NUM + SC2->C2_ITEM

	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek(xFilial("SC6")+_cChavSC2)
		dbSelectArea("SC2")
		dbSkip()
		Loop
	Endif	                     
	
	dbSelectArea("SD3")
	dbSetOrder(1)
	If dbSeek(xFilial("SD3")+ _cChavSC2)
		_cChavSd3 := Substr(SD3->D3_OP,1,8)
		
		While !Eof() .And.	_cChavSd3 == Substr(SD3->D3_OP,1,8)
			
			dbSelectArea("SD3")
			RecLock("SD3",.F.)
			SD3->D3_OP := "Z"+Substr(SD3->D3_OP,2,12)
			MsUnlock()
			
			dbSelectArea("SD3")
			dbSetOrder(1)
			dbSeek(xFilial("SD3")+_cChavSC2)
		EndDo
	Endif
	
	dbSelectarea("SD4")
	dbSetOrder(2)
	If dbSeek(xFilial("SD4") + _cChavSC2)
		
		_cChavSD4 := Substr(SD4->D4_OP,1,8)
		
		While !Eof() .And. _cChavSD4 == Substr(SD4->D4_OP,1,8)
			
			If SD4->D4_QUANT = SD4->D4_QTDEORI
				dbSelectarea("SD4")
				dbSkip()
				Loop
			Endif
			
			dbSelectArea("SD4")
			RecLock("SD4",.F.)
			SD4->D4_OP := "Z"+Substr(SD4->D4_OP,2,12)
			If !Empty(SD4->D4_OPORIG)
				SD4->D4_OPORIG :=	"Z"+Substr(SD4->D4_OPORIG,2,12)
			Endif
			MsUnlock()
			
			dbSelectarea("SD4")
			dbSetOrder(2)
			dbSeek(xFilial("SD4")+_cChavSC2)
		EndDo
	Endif
	
	dbSelectArea("SC2")
	_nRecSC2 := Recno()
	
	While !Eof() .And. _cChavSC2 == SC2->C2_NUM + SC2->C2_ITEM
		
		dbSelectArea("SC2")
		RecLock("SC2",.F.)
		SC2->C2_NUM := "Z"+SUBSTR(SC2->C2_NUM,2,5)
		MsUnlock()
		
		dbSelectarea("SC2")
		dbSetOrder(1)
		dbSeek(xFilial("SC2")+_cChavSC2,.T.)
	EndDo
EndDo

Return




Static Function ACESC2B(_lFim)

dbSelectArea("SC6")
dbSetOrder(1)
dbGotop()

ProcRegua(LastRec())

While !Eof()
	
	IncProc("Pedido + Item: "+SC6->C6_NUM + SC6->C6_ITEM)
	
	If SC6->C6_QTDVEN == SC6->C6_QTDENT .Or. !Empty(SC6->C6_BLQ)
		dbSelectArea("SC6")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SC2")
	dbSetOrder(1)
	If dbseek(xfilial("SC2")+SC6->C6_NUM + SC6->C6_ITEM)
		_cChaVC2 := SC2->C2_NUM + SC2->C2_ITEM
		If SC2->C2_DESTINA == "P"
			If SC2->C2_PEDIDO + SC2->C2_ITEMPV == SC6->C6_NUM + SC6->C6_ITEM
				dbSelectArea("SC6")
				dbSkip()
				Loop
			Else
				dbSelectArea("SD3")
				dbSetOrder(1)
				If dbSeek(xFilial("SD3")+ _cChaVC2)
					_cChavSd3 := Substr(SD3->D3_OP,1,8)
					
					While !Eof() .And.	_cChavSd3 == Substr(SD3->D3_OP,1,8)
						
						dbSelectArea("SD3")
						RecLock("SD3",.F.)
						SD3->D3_OP := "Z"+Substr(SD3->D3_OP,2,12)
						MsUnlock()
						
						dbSelectArea("SD3")
						dbSetOrder(1)
						dbSeek(xFilial("SD3")+_cChavC2)
					EndDo
				Endif
				
				dbSelectarea("SD4")
				dbSetOrder(2)
				If dbSeek(xFilial("SD4") + _cChavC2)
					
					_cChavSD4 := Substr(SD4->D4_OP,1,8)
					
					While !Eof() .And. _cChavSD4 == Substr(SD4->D4_OP,1,8)
						
						If SD4->D4_QUANT = SD4->D4_QTDEORI
							dbSelectarea("SD4")
							dbSkip()
							Loop
						Endif
						
						dbSelectArea("SD4")
						RecLock("SD4",.F.)
						SD4->D4_OP := "Z"+Substr(SD4->D4_OP,2,12)
						If !Empty(SD4->D4_OPORIG)
							SD4->D4_OPORIG :=	"Z"+Substr(SD4->D4_OPORIG,2,12)
						Endif
						MsUnlock()
						
						dbSelectarea("SD4")
						dbSetOrder(2)
						dbSeek(xFilial("SD4")+_cChavC2)
					EndDo
				Endif
				
				dbSelectArea("SC2")
				_nRecSC2 := Recno()
				
				While !Eof() .And. _cChavC2 == SC2->C2_NUM + SC2->C2_ITEM
					
					dbSelectArea("SC2")
					RecLock("SC2",.F.)
					SC2->C2_NUM := "Z"+SUBSTR(SC2->C2_NUM,2,5)
					MsUnlock()
					
					dbSelectarea("SC2")
					dbSetOrder(1)
					dbSeek(xFilial("SC2")+_cChavC2,.T.)
				EndDo
			Endif
		Endif
	Endif
	
	dbSelectArea("SC6")
	dbSkip()
EndDo

Return