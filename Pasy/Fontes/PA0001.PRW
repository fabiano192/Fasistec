#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PA0001    ³ Autor ³ Alexandro da Silva    ³ Data ³ 10.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Tela de cadastramento Cliente x Cod.Prod. Cliente           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PA0001()

_aAliOri := GetArea()

PRIVATE aMemos := { { "Z2_CODMEM", "Z2_DESMEM" } }
Private cVldAlt := .T.
Private cVldVis := .T.
Private cVldExc := .T.
//    Exclusao     Inclusao
AxCadastro("SZ2","Cliente x Produto x Cod.Prod.Cliente","U_VerMov()","U_PA01_A()")

RestArea(_aAliOri)

Return


User Function PA01_A()

Private _lRet

If ALTERA
	If M->Z2_TPAPROV == "1" .And. Empty(M->Z2_PPAP)
		Alert("Favor informar o Numero o PPAP!!")
		Return(.F.)
	Endif
Endif		                                           
		
nOpcao := 0

ConOut("Enviando E-Mail para Vendas:")

oProcess := TWFProcess():New( "ENVEM1", "Vendas " )
aCond    :={}
_nTotal  := 0

oProcess:NewTask( "Integracao", "\WORKFLOW\PA0001.HTM" )
oProcess:bReturn  := ""
oProcess:bTimeOut := ""
oHTML := oProcess:oHTML

oProcess:cSubject := "Produto Sem Aprovação!! "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1")+M->Z2_CLIENTE + M->Z2_LOJA))

oHtml:ValByName( "CLIENTE", M->Z2_CLIENTE)
oHtml:ValByName( "LOJA"   , M->Z2_LOJA)
oHtml:ValByName( "NOME"   , Alltrim(SA1->A1_NOME))
oHtml:ValByName( "PRODUTO", M->Z2_PRODUTO)
oHtml:ValByName( "DESCPRO", M->Z2_DESCCLI)
oHtml:ValByName( "PRODCLI", M->Z2_CODCLI)

If INCLUI
	If Empty(SA1->A1_VEND)
		_cTo := "paulo.freitas@pasy.com.br"
	Else
		SA3->(dbSetOrder(1))
		SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND))
		_cTo := Alltrim(SA3->A3_EMAIL)
	Endif
Else                                                 
	If M->Z2_TPAPROV != "1" .And. SZ2->Z2_TPAPROV != M->Z2_TPAPROV
		_cTo := GETMV("MV_WEMCQ3")
	Else
		Return(.T.)
	Endif
Endif                   

oProcess:cTo := _cTo
//oProcess:cCC := _cCC

oProcess:Start()
RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Envio Email para Vendas iniciado!' )

oProcess:Finish()

PA01_B()


Return(.T.)



Static Function PA01_B()

ConOut("Processo Finalizado" )

oProcess := TWFProcess():New( "ENVEM2", "Compras " )

oProcess:NewTask( "Integracao", "\WORKFLOW\PA0001.HTM" )
oProcess:bReturn  := ""
oProcess:bTimeOut := ""
oHTML := oProcess:oHTML

oProcess:cSubject := "Processo Encerrado"
oProcess:fDesc := "Processo Encerrado"

oProcess:cTo := ""

_cCC := ""
oProcess:cCC := _cCC

oProcess:Start()
RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10003','Finalizado Integracao' )

oProcess:Free()
oProcess:Finish()

Return


User Function VerMov()

_aAliOri2:= GetArea()
_aAliSC6 := SC6->(GetArea())
_aAliSD2 := SD2->(GetArea())
_lRet    := .T.

dbSelectArea("SC6")
dbOrderNickname("INDSC67")
If dbSeek(xFilial("SC6")+SZ2->Z2_CLIENTE+SZ2->Z2_LOJA+SZ2->Z2_PRODUTO+SZ2->Z2_CODCLI+SZ2->Z2_PEDCLI+SZ2->Z2_REVISAO)
	MSGBOX("Cadastro ja Possui Movimento e nao Pode ser Alterado/Excluido!!!","Informacao","INFO")
	_lRet := .F.
Endif

dbSelectArea("SD2")
dbOrderNickname("INDSD25")
If dbSeek(xFilial("SD2")+SZ2->Z2_CLIENTE+SZ2->Z2_LOJA+SZ2->Z2_PRODUTO+SZ2->Z2_CODCLI+SZ2->Z2_PEDCLI)
	MSGBOX("Cadastro ja Possui Movimento e nao Pode ser Alterado/Excluido!!!","Informacao","INFO")
	_lRet := .F.
Endif

RestArea(_aAliSC6)
RestArea(_aAliSD2)
RestArea(_aAliOri2)

Return(_lRet)


User Function VerMov3()

_aAliOri2:= GetArea()
_aAliSC6 := SC6->(GetArea())
_aAliSD2 := SD2->(GetArea())
_lRet    := .T.

dbSelectArea("SC6")
dbOrderNickname("INDSC67")
If dbSeek(xFilial("SC6")+M->Z2_CLIENTE+M->Z2_LOJA+M->Z2_PRODUTO+M->Z2_CODCLI+M->Z2_PEDCLI+M->Z2_REVISAO)
	MSGBOX("Cadastro ja Possui Movimento e nao Pode ser Alterado/Excluido!!!","Informacao","INFO")
	_lRet := .F.
Endif

dbSelectArea("SD2")
dbOrderNickname("INDSD25")
If dbSeek(xFilial("SD2") + M->Z2_CLIENTE + M->Z2_LOJA + M->Z2_PRODUTO + M->Z2_CODCLI + M->Z2_PEDCLI)
	MSGBOX("Cadastro ja Possui Movimento e nao Pode ser Alterado/Excluido!!!","Informacao","INFO")
	_lRet := .F.
Endif

RestArea(_aAliSC6)
RestArea(_aAliSD2)
RestArea(_aAliOri2)

Return(_lRet)


User Function PA01A()

_aAliOri := GetArea()
_aAliSZC := SB1->(GetArea())

Private oGetDad
nOpcx:=3

dbSelectArea("Sx3")
dbSetOrder(1)
dbSeek("SZC")
nUsado:=0
aHeader:={}
While !Eof() .And. (x3_arquivo == "SZC")
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And.(Alltrim(x3_campo) $ "ZC_DTREF  /ZC_QTINIC  /ZC_QTFINAL/ZC_PRECO  /ZC_ATIVO  ")
		nUsado:=nUsado+1
		If RTrim(X3_CAMPO) == "ZC_PRECO"
			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal, 'U_LINHA01()',;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )
		Else
			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal, x3_valid,;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )
		Endif
	Endif
	dbSkip()
End

aCols:=Array(1,nUsado+1)
dbSelectArea("Sx3")
dbSeek("SZC")
nUsado:=0
While !Eof() .And. (x3_arquivo == "SZC")
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And.(Alltrim(x3_campo) $ "ZC_DTREF  /ZC_QTINIC  /ZC_QTFINAL/ZC_PRECO  /ZC_ATIVO  ")
		nUsado:=nUsado+1
		IF nOpcx == 3
			IF x3_tipo == "C"
				aCOLS[1][nUsado] := SPACE(x3_tamanho)
			Elseif x3_tipo == "N"
				aCOLS[1][nUsado] := 0
			Elseif x3_tipo == "D"
				aCOLS[1][nUsado] := dDataBase
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

_cProdCli   := M->Z2_CODCLI
_cProduto   := M->Z2_PRODUTO
_cCliente   := M->Z2_CLIENTE
_cLoja      := M->Z2_LOJA
_cPedCli    := M->Z2_PEDCLI

ACols:={}
dbSelectArea("SZC")
dbSetOrder(1)
dbSeek(xFilial("SZC") + _cCliente + _cLoja + _cProduto + _cProdCli + _cPedCli)

_cChavSZC := _cCliente + _cLoja + _cProduto + _cProdCli + _cPedCli

While !eof() .And. _cChavSZC == SZC->ZC_CLIENTE + SZC->ZC_LOJA + SZC->ZC_PRODUTO + SZC->ZC_PRODCLI + SZC->ZC_PEDCLI
	AADD(aCols,Array(nUsado+1))
	For _ni:=1 to nUsado
		aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
	Next
	aCols[Len(aCols),nUsado+1]:=.F.
	dbSkip()
EndDo

nLinGetD:= 0
cTitulo := "Tabela de Preco Exportacao"

aC:={}
AADD(aC,{"_cProduto"     ,{15,10}    ,"Produto: "          ,"@I","","SB1",.F.})
AADD(aC,{"_cProdCli"     ,{15,150}    ,"ProdXCliente: "     ,"@I","","SB1",.F.})

aR:={}

aCGD  := {33,10,100,315}
aCord := {120,150,350,815}

/*
1 -  Linha Superior
2 -  Coluna Esquerda
3 -  Linha Inferior
4 -  Coluna Direita
*/
cLinhaOk  := "AllWaysTrue()"
cTudoOk   := "AllWaysTrue()"
//cTudoOk   :="U_PA01B()"

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,aCord)

If lRetMod2
	PA01C()
Endif

RestArea(_aAliSZC)
RestArea(_aAliOri)

_cRet := ""

Return(_cRet)


Static Function PA01C()

Private  _nPDtRef  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="ZC_DTREF"})
Private  _nPQtIni  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="ZC_QTINIC"})
Private  _nPQtFim  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="ZC_QTFINAL"})
Private  _nPPreco  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="ZC_PRECO"})
Private  _nPAtivo  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="ZC_ATIVO"})
Private  _nPPedCl  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="ZC_PEDCLI"})

_lDel := .F.
For I:= 1 to Len(Acols)
	_cFim := (Len(aHeader)+1)
	If aCols[I,_cFim]
		I := I
	Else
		If !_lDel
			_lDel := .T.
			dbSelectArea("SZC")
			dbSetOrder(1)
			dbSeek(xFilial("SZC") + _cCliente + _cLoja + _cProduto + _cProdCli + _cPedCli)
			
			_cChavSZC := _cCliente + _cLoja + _cProduto + _cProdCli + _cPedCli
			
			While !eof() .And. _cChavSZC == SZC->ZC_CLIENTE + SZC->ZC_LOJA + SZC->ZC_PRODUTO + SZC->ZC_PRODCLI +SZC->ZC_PEDCLI
				dbSelectArea("SZC")
				RecLock("SZC",.F.)
				dbDelete()
				MsUnlock()
				dbSelectarea("SZC")
				dbSkip()
			EndDo
		Endif
		
		If aCols[I,_nPPreco] > 0
			dbSelectArea("SZC")
			RecLock("SZC",.T.)
			SZC->ZC_FILIAL   := xFilial("SZC")
			SZC->ZC_CLIENTE  := _cCliente
			SZC->ZC_LOJA     := _cLoja
			SZC->ZC_PRODUTO  := _cProduto
			SZC->ZC_PRODCLI  := _cProdCli
			SZC->ZC_DTREF    := aCols[I,_nPDtRef]
			SZC->ZC_QTINIC   := aCols[I,_nPQtIni]
			SZC->ZC_QTFINAL  := aCols[I,_nPQtFim]
			SZC->ZC_PRECO    := aCols[I,_nPPreco]
			SZC->ZC_ATIVO    := aCols[I,_nPAtivo]
			SZC->ZC_PEDCLI   := _cPedCli
			MsUnlock()
		Endif
	Endif
	
Next I

Return

Static Function PA01B()

_nPDtRef  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="ZC_DTREF"})
_dDtRef   := aCols[N,_nPDtRef]
If N > 1
	_dDtRef := aCols[N-1,_nPDtRef]
Endif

Return(_dDtRef)