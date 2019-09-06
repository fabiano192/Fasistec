#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºExecblock ³PA0032  Autor³ Alexandro da Silva      º Data ³  18/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para Atualizar os Dados do Pedido conforme Exportac º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEEC                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0032()

_cMod    := cModulo
cModulo  := "EEC"

EECAP100()

cModulo  := _cMod

_aAliOri := GetArea()
_aAliEE7 := EE7->(GetArea())
_aAliEE8 := EE8->(GetArea())
_aAliSZ2 := SZ2->(GetArea())

/*
Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| GeraTRB(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
*/

Processa( {|| GeraTRB() } )

RestArea(_aAliEE7)
RestArea(_aAliEE8)
RestArea(_aAliSZ2)
RestArea(_aAliOri)


Static Function GeraTrb()

dbSelectArea("EE7")
dbOrderNickName("INDEE71")
dbGotop()

ProcRegua(LastRec())

While !Eof()// .And. Empty(EE7->EE7_FIM_PE)
	
	IncProc()
	
	dbSelectArea("EE8")
	dbSetOrder(1)
	If dbSeek(xFilial("EE8")+EE7->EE7_PEDIDO)
		_cPedido := EE7->EE7_PEDIDO
		_nEmb    := 0
		
		While !Eof() .And. _cPedido == EE8->EE8_PEDIDO
			
			dbSelectArea("SC6")
			dbSetOrder(1)
			If dbSeek(xFilial("SC6")+EE7->EE7_PEDFAT+EE8->EE8_FATIT+EE8->EE8_COD_I)
				
				_cPedCli := ""
				dbSelectArea("SZ2")
				dbSetOrder(1)
				If dbSeek(xFilial("SZ2")+SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + EE8->EE8_CODCLI+"1")
					_cPedCli := SZ2->Z2_PEDCLI
				Endif
				
				dbSelectArea("SC6")
				RecLock("SC6",.F.)
				SC6->C6_CPROCLI := EE8->EE8_CODCLI
				SC6->C6_PEDCLI  := _cPedCli
				SC6->C6_PEDAMOS := EE8->EE8_TIPPED
				MsUnlock()
			
			    dbSelectArea("SD2")
			    dbSetOrder(8)
			    If dbSeek(xFilial("SD2")+SC6->C6_NUM + SC6->C6_ITEM)
					dbSelectArea("SD2")
					RecLock("SD2",.F.)
					SD2->D2_PROCLI  := SC6->C6_CPROCLI
					SD2->D2_PEDCLI  := SC6->C6_PEDCLI
					MsUnlock()
			    Endif	
			Endif
			
			_nEmb += EE8->EE8_QTDEM1
			
			dbSelectArea("EE8")
			dbSkip()
		EndDo
	Endif
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek(xFilial("SC5")+EE7->EE7_PEDFAT)
		dbSelectArea("SC5")
		RecLock("SC5",.F.)
		SC5->C5_MENNOTA := EE7->EE7_MENNOT
		SC5->C5_VOLUME1 := _nEmb
		MsUnlock()
	Endif
	
	dbSelectArea("EE7")
	dbSkip()
	
EndDo

Return              
