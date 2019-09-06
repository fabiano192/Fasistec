#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GEXP001     º Autor ³ Alexandro da Silvaº Data ³  20/12/04  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ AtualizaO Preco de Venda   Exportação                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exportacao                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GEXP001()

_aAliOri  := GetArea()
_aAliSF4  := SF4->(GetArea())
_aAliSZ2  := SZ2->(GetArea())

_nPreco   := M->EE8_PRECO

dbSelectArea("SZ2")
dbSetOrder(1)
If dbSeek(xFilial("SZ2")+M->EE7_IMPORT + M->EE7_IMLOJA + M->EE8_COD_I + M->EE8_CODCLI+"1" )
	dDataRef := SZ2->Z2_DTREF01
	nValor   := SZ2->Z2_PRECO01
	For i := 2 to 12
		If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= dDataRef
			dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
			nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
		Endif
	Next i
	_nPreco  := nValor
Endif

dbSelectArea("SF4")
dbSetOrder(1)
dbSeek(xFilial("SF4")+SZ2->Z2_TES)

M->EE8_TES    	:= SZ2->Z2_TES
M->EE8_CF     	:= SF4->F4_CF
M->EE8_PART_N 	:= SZ2->Z2_CODCLI
M->EE8_REFCLI 	:= SZ2->Z2_PEDCLI
M->EE8_VM_DES   := SZ2->Z2_DESCCLI 
M->EE8_REVENG   := SZ2->Z2_REVISAO

RestArea(_aAliSF4)
RestArea(_aAliSZ2)
RestArea(_aAliOri)

Return(_nPreco)


User Function GEXP002()

_aAliOri := GetArea()
_aAliSC6 := SC6->(GETAREA())
_nSaldo  := 0

dbSelectArea("SC6")
dbSetOrder(1)
If dbSeek(xFilial("SC6")+M->EE7_PEDFAT+M->EE8_FATIT+M->EE8_COD_I)
	_nSaldo := SC6->C6_QTDVEN - SC6->C6_QTDENT
Endif

If _nSaldo < EE8->EE8_SLDINI
	Alert("Pedido Nao Pode Ser Alterado Pois Ja Foi Faturado!!!!!!")
	_nRet := SC6->C6_QTDVEN
Else
	_nRet := M->EE8_SLDINI
Endif

RestArea(_aAliSC6)
RestArea(_aAliORI)

Return(_nRet)


User Function GEXP003()

_aAliOri  := GetArea()
_aAliSZ2  := SZ2->(GetArea())
_aAliSZC  := SZC->(GetArea())
_nPreco   := 0

dbSelectArea("SZ2")
dbSetOrder(1)
If dbSeek(xFilial("SZ2")+M->EE7_IMPORT + M->EE7_IMLOJA + M->EE8_COD_I + M->EE8_CODCLI+"1" )
	_lAchou := .F.
	dbSelectArea("SZC")
	dbSetOrder(1)
	If dbSeek(xFilial("SZC")+SZ2->Z2_CLIENTE + SZ2->Z2_LOJA + SZ2->Z2_PRODUTO + SZ2->Z2_CODCLI)
		_cChavSZC := SZC->ZC_CLIENTE + SZC->ZC_LOJA + SZC->ZC_PRODUTO + SZC->ZC_PRODCLI
		
		While !eof() .And. _cChavSZC == SZC->ZC_CLIENTE + SZC->ZC_LOJA + SZC->ZC_PRODUTO + SZC->ZC_PRODCLI .And. !_lAchou
			If M->EE8_SLDINI >= SZC->ZC_QTINIC  .And. M->EE8_SLDINI <= SZC->ZC_QTFINAL
				_nPreco := SZC->ZC_PRECO
				_lAchou := .T.
			Endif
			
			dbSelectArea("SZC")
			dbSkip()
		EndDo
	Else
		dDataRef := SZ2->Z2_DTREF01
		nValor   := SZ2->Z2_PRECO01
		For i := 2 to 12
			If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= dDataRef
				dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
				nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
			Endif
		Next i
	
		_nPreco  := nValor				
	Endif
Endif

RestArea(_aAliSZC)
RestArea(_aAliSZ2)
RestArea(_aAliOri)

Return(_nPreco)
