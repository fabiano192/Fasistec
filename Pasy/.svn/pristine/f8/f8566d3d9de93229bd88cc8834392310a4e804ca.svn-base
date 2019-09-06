#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PA0004A   ºAutor  ³ Fabiano da Silva   º Data ³  21/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualizacao de preco conforme tabela DBF                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/               

User Function PA004A()

Private _nValor1 := 0
Private _nValor2 := 0

Processa( {|| AtuPreco() } )
MsgBox("Preco Atualizado com Sucesso","Informacao","info")

Return


Static Function AtuPreco()

_cArqTrb:= "CATER.DBF"
_cArqInd:= "CATER"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

_cInd := "CODCLI"
IndRegua("TRB",_cArqInd,_cInd,,,"Selecionando Arquivo Trabalho")

TRB->(dbGotop())

ProcRegua(TRB->(U_CONTREG()))

While TRB->(!Eof())
	
	IncProc()

	dbSeLectArea("SZ2")
	SZ2->(dbSetOrder(4))  //CODCLI + Cliente + Loja + PRODUTO + ATIVO
	If dbSeek(xFilial("SZ2")+TRB->CODCLI+"000008"+"01")
                     
        _cChav := SZ2->(Z2_CODCLI+Z2_CLIENTE+Z2_LOJA)
		
		While SZ2->(!Eof()) .And. _cChav == SZ2->(Z2_CODCLI+Z2_CLIENTE+Z2_LOJA)
            
			_nFator := TRB->PORC
   
   			If Empty(SZ2->Z2_PRECO01)
				SZ2->(dbSkip())
				Loop
			Endif   
   
			_lAtualiza := .F.   
			For I:=2 To 12  
		    	_nValor1 :=  &("SZ2->Z2_PRECO"+StrZero(i,2))
		    	_nValor2 :=  &("SZ2->Z2_PRECO"+StrZero(i-1,2))
				If Empty(_nValor1)
		        	dbSelectArea("SZ2")
		        	RecLock("SZ2",.F.)
	          		_nPreco := "SZ2->Z2_PRECO"+strZero(I,2)
	          		_dDtRef := "SZ2->Z2_DTREF"+strZero(I,2)
					_dDtBas := "SZ2->Z2_DTBAS"+strZero(I,2)
		        	
		        	&_nPreco  := Round((_nValor2 * (TRB->PORC/100)+_nValor2),4)
    		    	&_dDtRef  := CTOD("20/01/11")
					&_dDtBas  := CTOD("31/10/10")
                	
    		    	MsUnlock()
		        	I:= 12
        			_lAtualiza := .T.
		    	Endif
			Next I

			If !_lAtualiza
				dbSelectArea("SZ2")
      			Reclock("SZ2",.F.)
         		SZ2->Z2_PRECO01 := SZ2->Z2_PRECO02
         		SZ2->Z2_PRECO02 := SZ2->Z2_PRECO03
         		SZ2->Z2_PRECO03 := SZ2->Z2_PRECO04
         		SZ2->Z2_PRECO04 := SZ2->Z2_PRECO05
         		SZ2->Z2_PRECO05 := SZ2->Z2_PRECO06
         		SZ2->Z2_PRECO06 := SZ2->Z2_PRECO07
         		SZ2->Z2_PRECO07 := SZ2->Z2_PRECO08
         		SZ2->Z2_PRECO08 := SZ2->Z2_PRECO09
         		SZ2->Z2_PRECO09 := SZ2->Z2_PRECO10
         		SZ2->Z2_PRECO10 := SZ2->Z2_PRECO11
         		SZ2->Z2_PRECO11 := SZ2->Z2_PRECO12
         		SZ2->Z2_PRECO12 := Round((SZ2->Z2_PRECO12 * (TRB->PORC/100)+SZ2->Z2_PRECO12),4)
         		SZ2->Z2_DTREF01 := SZ2->Z2_DTREF02
         		SZ2->Z2_DTREF02 := SZ2->Z2_DTREF03
         		SZ2->Z2_DTREF03 := SZ2->Z2_DTREF04
         		SZ2->Z2_DTREF04 := SZ2->Z2_DTREF05
         		SZ2->Z2_DTREF05 := SZ2->Z2_DTREF06
         		SZ2->Z2_DTREF06 := SZ2->Z2_DTREF07
         		SZ2->Z2_DTREF07 := SZ2->Z2_DTREF08
         		SZ2->Z2_DTREF08 := SZ2->Z2_DTREF09
         		SZ2->Z2_DTREF09 := SZ2->Z2_DTREF10
         		SZ2->Z2_DTREF10 := SZ2->Z2_DTREF11
         		SZ2->Z2_DTREF11 := SZ2->Z2_DTREF12
         		SZ2->Z2_DTREF12 := CTOD("20/01/11")
      			MsUnlock()
			Endif

   			AtuPed() // Atualiza os pedidos em Aberto
   
			SZ2->(dbSkip())
		EndDo
    Else
    	If SZ2->Z2_LOJA = "01"
			Alert("Produto nao encontrado: "+TRB->CODCLI)
		Endif
    Endif

	TRB->(dbSkip())
EndDo

TRB->(dbClosearea())

Return



Static Function AtuPed()

SC6->(dbOrderNickName("INDSC61"))
If SC6->(dbSeek(xFilial()+ SZ2->(Z2_CLIENTE + Z2_LOJA + Z2_PRODUTO + Z2_CODCLI + Z2_PEDCLI)))

	_cChav1 := SC6->(C6_CLI+C6_LOJA+C6_PRODUTO+C6_CPROCLI+C6_PEDCLI)

	While SC6->(!Eof()) .And. 	_cChav1 == SC6->(C6_CLI+C6_LOJA+C6_PRODUTO+C6_CPROCLI+C6_PEDCLI)

   		If SC6->C6_QTDVEN == SC6->C6_QTDENT .Or. Alltrim(SC6->C6_BLQ) == "R"
      		SC6->(dbSkip())
      		Loop
   		Endif

   		If SC6->C6_ENTREG < CTOD("01/01/10")
      		SC6->(dbSkip())
      		Loop
   		Endif

   		SC6->(RecLock("SC6",.F.))
      	SC6->C6_PRCVEN := Round((SC6->C6_PRCVEN * (TRB->PORC/100)+SC6->C6_PRCVEN),4)
      	SC6->C6_PRUNIT := Round((SC6->C6_PRUNIT * (TRB->PORC/100)+SC6->C6_PRUNIT),4)
      	SC6->C6_VALOR  := Round((SC6->C6_QTDVEN * SC6->C6_PRCVEN),4)
   		SC6->(MsUnlock())

   		dbSelectArea("SC9")
   		dbSetorder(1)
   		If dbSeek(xFilial()+SC6->C6_NUM+SC6->C6_ITEM)
      		_cChavSc9 := SC9->C9_PEDIDO + SC9->C9_ITEM

      		While SC9->(!Eof()) .And. _cChavSc9 == SC9->C9_PEDIDO + SC9->C9_ITEM

         		If !Vazio(SC9->C9_NFISCAL)
	            	SC9->(dbSkip())
    	        	Loop
         		Endif

         		SC9->(RecLock("SC9",.F.))
            	SC9->C9_PRCVEN := Round((SC9->C9_PRCVEN * (TRB->PORC/100)+SC9->C9_PRCVEN),4)
         		SC9->(MsUnlock())

         		SC9->(dbSkip())
      		EndDo
   		Endif
   
   		SC6->(dbSkip())
	EndDo      
Endif
            
Return      