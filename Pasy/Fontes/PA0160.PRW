#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PA0160   º Autor ³ Alexandro Silva    º Data ³  09/04/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Liberação do Pedido de Venda                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFAT                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0160()

Private oGetDad
Private _cData
Private _lExclui := .F.
Private _lInclui := .F.
Private _cProduto,_cLocal
nOldValor :=    0
nOldISS   :=    0
lAltera   :=  .T.
lInclui   :=  .T.

aRotina := {{ "Pesquisa",   "AxPesqui", 0 , 1},;
{ "Visualizar",'U_VIS160()', 0 , 2},;
{ "Liberar",   'U_ALT160()', 0 , 4, 20 }}


cCadastro := "Pedido de Venda"
aFixe     := {}

MBrowse(6, 1, 22,75,"SC5",aFixe,"C5_NOTA",,,3)


Return


User Function VIS160()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcao de acesso para o Modelo 2                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
nOpcx:=7

dbSelectArea("Sx3")
dbSetOrder(1)
dbSeek("SC6")
nUsado:=0
aHeader:={}
While SX3->(!Eof()) .And. (x3_arquivo == "SC6")
	
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And.(Alltrim(x3_campo) $ "C6_TES/C6_CPROCLI/C6_PRODUTO/C6_QTDVEN/C6_ENTREG/C6_QTDLIB/C6_ITEM/C6_LOCAL/C6_QTDENT")
		nUsado:=nUsado+1
		If Alltrim(x3_campo) $ "C6_QTDLIB"
			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal, x3_valid,;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )
		Else
			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal, x3_valid,;
			x3_usado, x3_tipo, x3_arquivo, "V" } )
		Endif
	Endif
	
	SX3->(dbSkip())
EndDo

aCols:=Array(1,nUsado+1)
dbSelectArea("Sx3")
dbSeek("SC6")
nUsado:=0
While !Eof() .And. (x3_arquivo == "SC6")
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And.(Alltrim(x3_campo) $ "C6_TES/C6_CPROCLI/C6_PRODUTO/C6_QTDVEN/C6_ENTREG/C6_QTDLIB/C6_ITEM/C6_LOCAL/C6_QTDENT")
		nUsado:=nUsado+1
		IF nOpcx == 7
			IF x3_tipo == "C"
				aCOLS[1][nUsado] := SPACE(x3_tamanho)
			Elseif x3_tipo == "N"
				aCOLS[1][nUsado] := 0
			Elseif x3_tipo == "D"
				aCOLS[1][nUsado] := cTod("")
			Elseif x3_tipo == "M"
				aCOLS[1][nUsado] := ""
			Else
				aCOLS[1][nUsado] := .F.
			Endif
		Endif
	Endif
	dbSkip()
End
aCOLS[1][nUsado+1] := .F.

_cPedido  := SC5->C5_NUM
_cCliente := SC5->C5_CLIENTE
_cLoja    := SC5->C5_LOJACLI

nLinGetD  := 0
cTitulo   := "Pedido de Venda"
aC        := {}

AADD(aC,{"_cPedido"	,{15,10} ,"Numero Pedido"	    ,"@!",,,.F.})
AADD(aC,{"_cCliente",{15,200},"Cliente"    	        ,"@!",,,.F.})
AADD(aC,{"_cLoja"	,{27,10} ,"Loja"                ,"@!",,,.F.})

aR:={}

aCGD:={44,5,118,315}

ACols:={}
SC6->(dbSetOrder(1))
SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))

_cNum := SC6->C6_NUM

dbSelectArea("SC6")

While SC6->(!Eof()) .And. _cNum == SC6->C6_NUM
	AADD(aCols,Array(nUsado+1))
	For _ni:=1 to nUsado
		aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
	Next
	aCols[Len(aCols),nUsado+1]:=.F.
	SC6->(dbSkip())
EndDo

cLinhaOk:= "AllWaysTrue()"
cTudoOk := "AllWaysTrue()"

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)

Return



User Function ALT160()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcao de acesso para o Modelo 2                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

nOpcx  := 3
nUsado := 0
aHeader:= {}

nUsado++
SX3->(dbSetOrder(2))
SX3->(dbSeek("C6_ITEM"))
SX3->(AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho, x3_decimal, ".F.",x3_usado, x3_tipo, x3_arquivo, x3_context } ))

nUsado++
SX3->(dbSetOrder(2))
SX3->(dbSeek("C6_PRODUTO"))
SX3->(AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho, x3_decimal, ".F.",x3_usado, x3_tipo, x3_arquivo, x3_context } ))

nUsado++
SX3->(dbSetOrder(2))
SX3->(dbSeek("C6_CPROCLI"))
SX3->(AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho, x3_decimal, ".F.",x3_usado, x3_tipo, x3_arquivo, x3_context } ))

nUsado++
SX3->(dbSetOrder(2))
SX3->(dbSeek("C6_PEDCLI"))
SX3->(AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho, x3_decimal, ".F.",x3_usado, x3_tipo, x3_arquivo, x3_context } ))

nUsado++
SX3->(dbSetOrder(2))
SX3->(dbSeek("C6_QTDLIB"))
SX3->(AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho, x3_decimal, "U_PA160A()",x3_usado, x3_tipo, x3_arquivo, x3_context } ))

nUsado++
SX3->(dbSetOrder(2))
SX3->(dbSeek("C6_QTDVEN"))
SX3->(AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho, x3_decimal, ".F.",x3_usado, x3_tipo, x3_arquivo, x3_context } ))

nUsado++
SX3->(dbSetOrder(2))
SX3->(dbSeek("C6_QTDENT"))
SX3->(AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho, x3_decimal, ".F.",x3_usado, x3_tipo, x3_arquivo, x3_context } ))

nUsado++
SX3->(dbSetOrder(2))
SX3->(dbSeek("C6_ENTREG"))
SX3->(AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho, x3_decimal, ".F.",x3_usado, x3_tipo, x3_arquivo, x3_context } ))

nUsado++
SX3->(dbSetOrder(2))
SX3->(dbSeek("C6_TES"))
SX3->(AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho, x3_decimal, ".F.",x3_usado, x3_tipo, x3_arquivo, x3_context } ))

nUsado++
SX3->(dbSetOrder(2))
SX3->(dbSeek("C6_PRCVEN"))
SX3->(AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho, x3_decimal, ".F.",x3_usado, x3_tipo, x3_arquivo, x3_context } ))

nUsado++
SX3->(dbSetOrder(2))
SX3->(dbSeek("C6_LOCAL"))
SX3->(AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho, x3_decimal, ".F.",x3_usado, x3_tipo, x3_arquivo, x3_context } ))

aCols:=Array(1,nUsado+1)
dbSelectArea("Sx3")
dbSetOrder(1)
dbSeek("SC6")
nUsado:=0
While !Eof() .And. (x3_arquivo == "SC6")
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And.(Alltrim(x3_campo) $ "C6_TES/C6_CPROCLI/C6_PRODUTO/C6_QTDVEN/C6_ENTREG/C6_QTDLIB/C6_ITEM/C6_LOCAL/C6_QTDENT/C6_PRCVEN/C6_PEDCLI")
		nUsado:=nUsado+1
		IF nOpcx == 3
			IF x3_tipo == "C"
				aCOLS[1][nUsado] := SPACE(x3_tamanho)
			Elseif x3_tipo == "N"
				aCOLS[1][nUsado] := 0
			Elseif x3_tipo == "D"
				aCOLS[1][nUsado] := cTod("")
			Elseif x3_tipo == "M"
				aCOLS[1][nUsado] := ""
			Else
				aCOLS[1][nUsado] := .F.
			Endif
		Endif
	Endif
	dbSkip()
End
aCOLS[1][nUsado+1] := .F.

_cPedido  := SC5->C5_NUM
_cCliente := SC5->C5_CLIENTE
_cLoja    := SC5->C5_LOJACLI

nLinGetD  := 0
cTitulo   := "Pedido de Venda"
aC        := {}

AADD(aC,{"_cPedido"	,{15,10} ,"Numero Pedido"	    ,"@!",,,.F.})
AADD(aC,{"_cCliente",{15,200},"Cliente"    	        ,"@!",,,.F.})
AADD(aC,{"_cLoja"	,{27,10} ,"Loja"                ,"@!",,,.F.})

aR:={}

aCGD:={44,5,118,315}

ACols:={}
SC6->(dbSetOrder(1))
SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))

dbSelectArea("SC6")
_cNum := SC6->C6_NUM

While SC6->(!Eof()) .And. _cNum == SC6->C6_NUM
	If !Empty(SC6->C6_BLQ) .Or. SC6->C6_PEDAMOS != "N"
		SC6->(dbSkip())
		Loop
	Endif
	
	If SC6->C6_QTDENT == SC6->C6_QTDVEN
		SC6->(dbSkip())
		Loop
	Endif
	
	AADD(aCols,Array(nUsado+1))
	For _ni:=1 to nUsado
		aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
	Next
	aCols[Len(aCols),nUsado+1]:=.F.
	SC6->(dbSkip())
EndDo

cLinhaOk:= "AllWaysTrue()"
cTudoOk := "AllWaysTrue()"

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)

If lRetMod2
	U_GRAVALT()
Endif

Return




User Function VerCod()

_lRet := .T.
dbSelectarea("SB1")
dbSetOrder(1)
If dbSeek(xFilial()+_cProduto)
	_cLocal := SB1->B1_LOCPAD
	_cDesc  := SB1->B1_DESC
Else
	_lRet := .F.
Endif


Return(_lRet)



User Function GravAlt()

Local I
_lParar := .t.

SC9->(dbSetOrder(1))
SC9->(dbSeek(xFilial("SC9")+SC5->C5_NUM))

_cPedSC9 := SC9->C9_PEDIDO

While SC9->(!Eof()) .And. _cPedSC9 == SC9->C9_PEDIDO
	
	If !Empty(SC9->C9_NFISCAL)
		SC9->(dbSkip())
		Loop
	Endif
	
	If Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)
		SB2->(dbSetOrder(1))
		If SB2->(dbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL))
			SB2->(RecLock("SB2",.F.))
			SB2->B2_RESERVA -= SC9->C9_QTDLIB
			SB2->(MsUnLock())
		Endif
	Endif
	
	SC9->(RecLock("SC9",.F.))
	SC9->(dbDelete())
	SC9->(MsUnLock())
	
	SC9->(dbSkip())
EndDo

_cSeqSc9 := "00"
_nPItem  := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_ITEM"})
_nPProdC := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_CPROCLI"})
_nPPedCli:= aScan(aHeader,{|x| Alltrim(x[2]) == "C6_PEDCLI"})
_nPProd  := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO"})
_nPLocal := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_LOCAL"})
_nPTes   := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_TES"})
_nPQuant := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_QTDLIB"})
_nPPreco := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_PRCVEN"})
_lRet    := .T.

For I:= 1 to Len(Acols)
	_cFim := (Len(aHeader)+1)
	If aCols[I,_cFim]
		I := I
	Else
		If Acols[I,_nPQuant] > 0
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+Acols[I,_nPProd]))
			
			_cEst := ""
			SF4->(dbSetOrder(1))
			If SF4->(dbSeek(xFilial("SF4")+Acols[I,_nPTES]) )
				If ( SF4->F4_ESTOQUE == "S" )
					SB2->(dbSetOrder(1))
					If SB2->(dbSeek(xFilial("SB2")+Acols[I,_nPProd]+Acols[I,_nPLocal]) )
						If SB2->B2_QATU - SB2->B2_RESERVA >= Acols[I,_nPQuant]
							_cEst := ""
						Else
							_cEst := "02"
						Endif
					Endif
				Endif
			Endif
			
			_cIt   := Acols[I,_nPItem]
			cQuery := " SELECT MAX(C9_SEQUEN) SEQUEN "
			cQuery += " FROM "+RetSqlName("SC9")+" SC9 "
			cQuery += " WHERE C9_FILIAL='"+xFilial("SC9")+"' AND "
			cQuery += " C9_PEDIDO='"+SC5->C5_NUM+"' AND "
			cQuery += " C9_ITEM='"+_cIt+"' AND "
			cQuery += " SC9.D_E_L_E_T_ = '' "
			
			TCQUERY cQuery NEW ALIAS "ZC9"
			
			_cSeqSC9 := ZC9->SEQUEN
			
			ZC9->(dbCloseArea())
			
			_cSeqSC9 := Soma1(_cSeqSC9,Len(SC9->C9_SEQUEN))
			
			SC9->(RecLock("SC9",.T.))
			SC9->C9_FILIAL   := xFilial("SC9")
			SC9->C9_PEDIDO   := SC5->C5_NUM
			SC9->C9_ITEM     := _cIt
			SC9->C9_CLIENTE  := SC5->C5_CLIENTE
			SC9->C9_LOJA     := SC5->C5_LOJACLI
			SC9->C9_PRODUTO  := Acols[I,_nPProd]
			SC9->C9_CPROCLI  := Acols[I,_nPProdC]
			SC9->C9_PEDCLI   := Acols[I,_nPPedCli]
			SC9->C9_LOCAL    := Acols[I,_nPLocal]
			SC9->C9_QTDLIB   := Acols[I,_nPQuant]
			SC9->C9_DATALIB  := dDataBase
			SC9->C9_SEQUEN   := _cSeqSC9
			SC9->C9_GRUPO    := SB1->B1_GRUPO
			SC9->C9_PRCVEN   := Acols[I,_nPPreco]
			SC9->C9_BLEST    := _cEst
			SC9->C9_BLCRED   := ""
			SC9->C9_TPCARGA  := "2"
			SC9->(MsUnlock())
			
			SC6->(dbSetOrder(1))
			If SC6->(dbSeek(xFilial("SC6")+ SC5->C5_NUM + Acols[I,_nPItem]))
				SC6->(RecLock("SC6",.F.))
				SC6->C6_QTDEMP := Acols[I,_nPQuant]
				SC6->C6_OP     := "07"
				SC6->(MsUnlock())
			Endif
			
			SB2->(dbSetOrder(1))
			If SB2->(!dbSeek(xFilial("SB2")+SC6->C6_PRODUTO+Acols[I,_nPLocal]) )
				CriaSB2( SC6->C6_PRODUTO,Acols[I,_nPLocal] )
			Endif
			
			SB2->(RecLock("SB2"))
			SB2->B2_RESERVA += Acols[I,_nPQuant]
			SB2->(MsUnLock())
		Endif
	Endif
Next I

Return


User Function PA160A()

_nPQtdlib := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_QTDLIB"})
_nPQtdven := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_QTDVEN"})
_nPQtdEnt := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_QTDENT"})
_nPoProdC := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_CPROCLI" } )
_nPoProd  := aScan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO" } )


_cProduto := ACols[N][_nPoProd]
_cProdCli := ACols[N][_nPoProdC]


_nQtdEnt  := Acols[N,_nPQtdEnt]
_nQtdVen  := Acols[N,_nPQtdVen]
_nQtdLib  := M->C6_QTDLIB
_lRet     := .T.

If _nQtdLib <= (_nQtdVen - _nQtdEnt)
	SZ2->(dbSetOrder(1))
	If SZ2->(dbSeek(xFilial("SZ2")+_cCliente + _cLoja + _cProduto + _cProdCli+"1"))
		If SZ2->Z2_TPAPROV == "4"
			MSGINFO("ITEM SEM APROVACAO. FAVOR CONTACTAR C.Q. !!")
			_lRet := .F.
		Endif
	Endif
Else
	Alert("Quantidade Liberada Maior que o Saldo a Liberar!!!")
	_lRet := .F.
Endif


Return(_lRet)