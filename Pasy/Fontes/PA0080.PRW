#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PA0080    ºAutor  ³Alexandro           º Data ³  20/02/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualizacao de preco Komatsu                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PA0080()

///////////////////////////////////////////////
/////  MV_PAR01 : Tipo de Calculo?       ////// 1 = Calculo; 2= Descalculo
///////////////////////////////////////////////

If !Pergunte("PA0080",.T.)
	Return
Endif

If MV_PAR01 == 1
	Processa( {|| AtuPreco() } )
//	Processa( {|| AtuTES() } )
	MsgBox("Preco Atualizado com Sucesso","Informacao","info")
Else
	Processa( {|| DescPreco() } )
//	Processa( {|| DescTES() } )
	MsgBox("Preco Descalculado com Sucesso","Informacao","info")
Endif


Return


Static Function AtuPreco()

dbSeLectArea("SZ2")
dbSetOrder(1)
dbSeek(xFilial("SZ2")+"00002602")

_nRec := LastRec()
ProcRegua(_nRec)

While !Eof() .And. SZ2->Z2_CLIENTE == "000026" .And. SZ2->Z2_LOJA == "02"
	
	IncProc()
	
	If Empty(SZ2->Z2_PRECO01)
		dbSelecTarea("SZ2")
		dbSkip()
		Loop
	Endif
	
	If SZ2->Z2_ATIVO == "2"
		dbSelectArea("SZ2")
		dbSkip()
		Loop
	Endif
	
	dDataRef := SZ2->Z2_DTREF01
	nValor   := SZ2->Z2_PRECO01
	For i := 2 to 12
		If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= dDataRef
			dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
			nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
		Endif
	Next i
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1") + SZ2->Z2_PRODUTO)
	
		If SB1->B1_PICM == 12
			_nPerDes := Val(Tabela("Z8","12"))
		Else
			_nPerDes := Val(Tabela("Z8","18"))
		Endif
		nValor := nValor - (nValor * (_nPerDes/100))
	
		AtuPed()
		
	dbSelectArea("SZ2")
	dbSkip()
EndDo

Return



Static Function AtuPed()

dbSelectArea("SC6")
dbOrderNickName("INDSC61")
If dbSeek(xFilial("SC6")+SZ2->Z2_CLIENTE + SZ2->Z2_LOJA + SZ2->Z2_PRODUTO + SZ2->Z2_CODCLI + SZ2->Z2_PEDCLI)
	
	_cChavSZ2 := SZ2->Z2_CLIENTE + SZ2->Z2_LOJA + SZ2->Z2_PRODUTO + SZ2->Z2_CODCLI + SZ2->Z2_PEDCLI
	While !Eof() .And. _cChavSZ2 == SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SZ2->Z2_CODCLI + SZ2->Z2_PEDCLI
		
		If SC6->C6_QTDVEN == SC6->C6_QTDENT .Or. Alltrim(SC6->C6_BLQ) == "R"
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		If SC6->C6_PEDAMOS == "D"
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SC6")
		RecLock("SC6",.F.)
		SC6->C6_PRCVEN := Round((nValor),4)
		SC6->C6_PRUNIT := Round((nValor),4)
		SC6->C6_VALOR  := Round((SC6->C6_QTDVEN * SC6->C6_PRCVEN),2)
		SC6->C6_TES    := "598"
		MsUnlock()
		
		dbSelectArea("SC9")
		dbSetorder(1)
		If dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
			_cChavSc9 := SC9->C9_PEDIDO + SC9->C9_ITEM
			
			While !Eof() .And. _cChavSc9 == SC9->C9_PEDIDO + SC9->C9_ITEM
				
				If !Vazio(SC9->C9_NFISCAL)
					dbSelectArea("SC9")
					dbSkip()
					Loop
				Endif
				
				dbSelectArea("SC9")
				RecLock("SC9",.F.)
				SC9->C9_PRCVEN := Round((nValor),4)
				MsUnlock()
				
				dbSelectArea("SC9")
				dbSkip()
			EndDo
		Endif
		
		dbSelectArea("SC6")
		dbSkip()
	EndDo
Endif                    

Return


Static Function DescPreco()

dbSeLectArea("SZ2")
dbSetOrder(1)
dbSeek(xFilial("SZ2")+"00002602")

_nRec := LastRec()
ProcRegua(_nRec)

While !Eof() .And. SZ2->Z2_CLIENTE == "000026" .And. SZ2->Z2_LOJA == "02"
	
	IncProc()
	
	If SZ2->Z2_ATIVO == "2"
		dbSelectArea("SZ2")
		dbSkip()
		Loop
	Endif
	
	If Empty(SZ2->Z2_PRECO01)
		dbSelecTarea("SZ2")
		dbSkip()
		Loop
	Endif
	
	dDataRef := SZ2->Z2_DTREF01
	nValor   := SZ2->Z2_PRECO01
	
	For i := 2 to 12
		If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= dDataRef
			dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
			nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
		Endif
	Next i
	
	DescPed()
	
	dbSelectArea("SZ2")
	dbSkip()
EndDo

Return


Static Function DescPed()

dbSelectArea("SC6")
dbOrderNickName("INDSC61")
If dbSeek(xFilial("SC6")+SZ2->Z2_CLIENTE + SZ2->Z2_LOJA + SZ2->Z2_PRODUTO + SZ2->Z2_CODCLI + SZ2->Z2_PEDCLI)
	
	_cChavSZ2 := SZ2->Z2_CLIENTE + SZ2->Z2_LOJA + SZ2->Z2_PRODUTO + SZ2->Z2_CODCLI + SZ2->Z2_PEDCLI
	While !Eof() .And. _cChavSZ2 == SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SZ2->Z2_CODCLI + SZ2->Z2_PEDCLI
		
		If SC6->C6_QTDVEN == SC6->C6_QTDENT .Or. Alltrim(SC6->C6_BLQ) == "R"
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		If SC6->C6_PEDAMOS == "D"
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SC6")
		RecLock("SC6",.F.)
		SC6->C6_PRCVEN := Round(nValor,4)
		SC6->C6_PRUNIT := Round(nValor,4)
		SC6->C6_VALOR  := Round((SC6->C6_QTDVEN * SC6->C6_PRCVEN),2)
		SC6->C6_TES    := "501"
		MsUnlock()
		
		dbSelectArea("SC9")
		dbSetorder(1)
		If dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
			_cChavSc9 := SC9->C9_PEDIDO + SC9->C9_ITEM
			
			While !Eof() .And. _cChavSc9 == SC9->C9_PEDIDO + SC9->C9_ITEM
				
				If !Vazio(SC9->C9_NFISCAL)
					dbSelectArea("SC9")
					dbSkip()
					Loop
				Endif
				
				dbSelectArea("SC9")
				RecLock("SC9",.F.)
				SC9->C9_PRCVEN := Round(nValor,4)
				MsUnlock()
				
				dbSelectArea("SC9")
				dbSkip()
			EndDo
		Endif
		
		dbSelectArea("SC6")
		dbSkip()
	EndDo
Endif
