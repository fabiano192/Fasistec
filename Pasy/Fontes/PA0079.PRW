#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0079   ³ Autor ³ Alexandro da Silva    ³ Data ³ 05.09.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao do Pedido de Compras                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0079()

LOCAL wnrel		:= "PA0079"
LOCAL cDesc1   	:= "Emissao dos pedidos de compras ou autorizacoes de entrega"
LOCAL cDesc2   	:= "cadastradados e que ainda nao foram impressos"
LOCAL cDesc3   	:= " ", nBaseIPI
LOCAL cString  	:= "SC7"

_nQtEmb         := 0
PRIVATE tamanho := "M"
PRIVATE titulo	:= "Emissao dos Pedidos de Compras ou Autorizacoes de Entrega"
PRIVATE aReturn := {"Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
PRIVATE nomeprog:= "Pa0079",nLastKey := 0,nBegin:=0,aLinha:={ }
PRIVATE cPerg   := "MTR110"
PRIVATE aSenhas := {}, aUsuarios:={}
Private _lMenSubGr := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01               Do Pedido                             ³
//³ mv_par02               Ate o Pedido                          ³
//³ mv_par03               A partir da data de emissao           ³
//³ mv_par04               Ate a data de emissao                 ³
//³ mv_par05               Somente os Novos                      ³
//³ mv_par06               Campo Descricao do Produto    	     ³
//³ mv_par07               Unidade de Medida:Primaria ou Secund. ³
//³ mv_par08               Imprime ? Pedido Compra ou Aut. Entreg³
//³ mv_par09               Numero de vias                        ³
//³ mv_par10               Pedidos ? Liberados Bloqueados Ambos  ³
//³ mv_par11               Impr. SC's Firmes, Previstas ou Ambas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("MTR110",.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

If mv_par08 == 1
	RptStatus({|lEnd| PA79A(@lEnd,wnRel,cString)},titulo)
ElsE
	RptStatus({|lEnd| C110AE(@lEnd,wnRel,cString)},titulo)
EndIf

Return .T.

Static Function PA79A(lEnd,WnRel,cString)


Local nReem,nOrder,cCondBus
Local nSavRec,aSavRec := {}
Local nDescItem:= 0

limite   := 130
li       := 80
nTotNota := 0
nTotIpi  := 0
nDescProd:= 0
nTotal   := 0
NumPed   := Space(6)
aMens    := {}

cCondBus	:=mv_par01
nOrder	:=	1

dbSelectArea("SC7")
dbSetOrder(nOrder)
SetRegua(RecCount())
dbSeek(xFilial("SC7")+cCondBus,.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 0,0 PSay AvalImp(Limite+2)

While !Eof() .And. C7_FILIAL = xFilial("SC7") .And. C7_NUM >= mv_par01 .And. C7_NUM <= mv_par02
	
	nOrdem     := 1
	nReem      := 0
	cObs01     := cObs02  := cObs03 := cObs04 := cObs05 := cObs06 := cObs07 := cObs08 := " "
	_cCond01   := " "
	_cCond02   := " "
	_cCond03   := " "
	_cCond04   := " "
	
	If C7_EMITIDO == "S" .And. mv_par05 == 1
		dbSkip()
		Loop
	Endif

	If (C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
		(C7_CONAPRO != "B" .And. mv_par10 == 2)
		dbSkip()
		Loop
	Endif

	If (C7_EMISSAO < mv_par03) .Or. (C7_EMISSAO > mv_par04)
		dbSkip()
		Loop
	Endif

	If C7_TIPO == 2
		dbSkip()
		Loop
	EndIf
	
	If !MtrAValOP(mv_par11, 'SC7')
		dbSkip()
		Loop
	EndIf
	
	lLiberador := .F.
	If GetMV("MV_ALCADA") == "S"
		If !File(cArqAlca)
			lLiberador := .F.
		Else
			lLiberador := .T.
			If Empty(C7_CODLIB)
				dbSkip()
				Loop
			EndIf
		EndIf
	EndIf
	
	For ncw := 1 To mv_par09		// Imprime o numero de vias informadas
		
		ImpCabec()
		
		nTotNota := 0
		nTotal   := 0
		nTotIpi  := 0
		nDescProd:= 0
		nTotNota += SC7->C7_FRETE
		nReem    := SC7->C7_QTDREEM + 1
		nSavRec  := SC7->(Recno())
		NumPed   := SC7->C7_NUM
		aMens    := {}
		
		_lMenSubGr := .f.
		_aProd     := {}
		
		While !Eof() .And. C7_FILIAL = xFilial("SC7") .And. C7_NUM == NumPed
			
			If Ascan(aSavRec,Recno()) == 0
				AADD(aSavRec,Recno())
			Endif
			
			If lEnd
				@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
				Goto Bottom
				Exit
			Endif
			
			IncRegua()
			
			If Ascan(_aProd, SC7->C7_PRODUTO) !=0
				dbSelectArea("SC7")
				dbSkip()
				Loop
			Endif
			
			_nPrUnit  := SC7->C7_PRECO
			_nPrTot   := SC7->C7_TOTAL
			_aAliSC7  := SC7->(GETAREA())
			_cProduto := SC7->C7_PRODUTO
			_lPed     := .F.
			dbSelectArea("SG1")
			dbSetOrder(2)
			If dbSeek(xFilial("SG1")+SC7->C7_PRODUTO)
				dbSelectArea("SB1")
				dbSetOrder(1)
				If dbSeek(xFilial("SB1")+SG1->G1_COD)
					If SB1->B1_GRUPO == "CONJ"
						_cComp   := SG1->G1_COD
						_nPrUnit := 0
						_nPrTot  := 0
						_lPed    := .T.
						dbSelectArea("SG1")
						dbSetOrder(1)
						If dbSeek(xFilial("SG1")+_cComp)
							While !Eof() .And. _cComp == SG1->G1_COD .And. _lPed
								If Ascan(_aProd, SG1->G1_COMP)==0
									AADD(_aProd,SG1->G1_COMP)
								Endif
																
								dbSelectArea("SC7")
								dbSetOrder(4)
								If dbSeek(xFilial("SC7")+SG1->G1_COMP+NumPed)
									_nPrUnit += SC7->C7_PRECO
									_nPrTot  += SC7->C7_TOTAL
								Else
									_lPed := .F.
								Endif
	
								dbSelectArea("SG1")
								dbSkip()
							EndDo
							
							If _lPed
								_cProduto := _cComp
							Endif
						Endif
					Endif
				Endif
			Endif
			
			RestArea(_aAliSC7)
			
			If li > 56
				nOrdem++
				ImpRodape()
				ImpCabec()
			Endif
			
			li++
			
			@ li,001 PSAY "|"
			@ li,002 PSAY StrZero(Val(C7_ITEM),2)  		Picture PesqPict("SC7","c7_item")
			@ li,005 PSAY "|"
			@ li,006 PSAY _cProduto	Picture             PesqPict("SC7","c7_produto")
			
			ImpProd()
			
			If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
				nDescItem:= CalcDesc(_nPrTot,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
			Else
				nDescItem:= SC7->C7_VLDESC
			Endif
			nDescProd+= nDescItem
			nBaseIPI := _nPrTot - IIF(SC7->C7_IPIBRUT=="L",nDescItem,0)
			nTotIpi  := nTotIpi+NoRound(nBaseIPI*SC7->C7_IPI/100,2)

			cItem := ""
			If Len(Alltrim(SC7->C7_ITEM)) = 2
				cItem := SC7->C7_ITEM
			ElseIf Len(Alltrim(SC7->C7_ITEM)) = 4
				cItem := Substr(SC7->C7_ITEM,3,2)
			Endif
			
//			If !Empty(SC7->C7_OBS)
			If cItem < "08"
//			If SC7->C7_ITEM < "05"
//				cVar:="cObs"+SC7->C7_ITEM
				cVar:="cObs"+cItem
				Eval(MemVarBlock(cVar),SC7->C7_OBS)
				_cVarCond:= "_cCond"+SC7->C7_ITEM
				Eval(MemVarBlock(_cVarCond),SC7->C7_OBS2)
			Endif
			dbSkip()
		EndDo
		
		dbGoto(nSavRec)
		
		If li>38
			nOrdem++
			ImpRodape()
			ImpCabec()
		Endif
		
		FinalPed(nDescProd)
		
	Next
	
	If Len(aSavRec)>0
		For i:=1 to Len(aSavRec)
			dbGoto(aSavRec[i])
			RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
			Replace C7_QTDREEM With (C7_QTDREEM+1)
			Replace C7_EMITIDO With "S"
			MsUnLock()
		Next
		dbGoto(aSavRec[Len(aSavRec)])		// Posiciona no ultimo elemento e limpa array
	Endif
	
	aSavRec := {}
	
	dbSkip()
EndDo

dbSelectArea("SC7")
Set Filter To
dbSetOrder(1)

dbSelectArea("SX3")
dbSetOrder(1)

Set device to Screen

If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C110AE   ³ Autor ³ Cristina M. Ogura     ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PA0079 		                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C110AE(lEnd,WnRel,cString)
Local nReem
Local nSavRec,aSavRec := {}

limite   := 130
li       := 80
nTotNota := 0
nTotIpi  := 0
nDescProd:= 0
nTotal   := 0
NumPed   := Space(6)

dbSelectArea("SC7")
dbSetOrder(10)
dbSeek(xFilial("SC7")+"2"+mv_par01,.T.)

SetRegua(Reccount())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 0,0 PSay AvalImp(Limite+2)

While !Eof().And.C7_FILIAL = xFilial("SC7") .And. C7_NUM >= mv_par01 .And. C7_NUM <= mv_par02
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria as variaveis para armazenar os valores do pedido        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOrdem     := 1
	nReem      := 0
	cObs01     := cObs02  := cObs03 := cObs04 := cObs05 := cObs06 := cObs07 := " "
	_cCond01   := " "
	_cCond02   := " "
	_cCond03   := " "
	_cCond04   := " "
	
	If C7_EMITIDO == "S" .And. mv_par05 == 1
		dbSkip()
		Loop
	Endif
	If (C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
		(C7_CONAPRO != "B" .And. mv_par10 == 2)
		dbSkip()
		Loop
	Endif
	If (SC7->C7_EMISSAO < mv_par03) .Or. (SC7->C7_EMISSAO > mv_par04)
		dbSkip()
		Loop
	Endif
	If SC7->C7_TIPO != 2
		dbSkip()
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra Tipo de SCs Firmes ou Previstas                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !MtrAValOP(mv_par11, 'SC7')
		dbSkip()
		Loop
	EndIf
	
	For ncw := 1 To mv_par09		// Imprime o numero de vias informadas
		
		ImpCabec()
		
		nTotNota := 0
		nTotal   := 0
		nTotIpi  := 0
		nDescProd:= 0
		nTotNota += SC7->C7_FRETE
		nReem    := SC7->C7_QTDREEM + 1
		nSavRec  := SC7->(Recno())
		NumPed   := SC7->C7_NUM
		
		While !Eof() .And. C7_FILIAL = xFilial("SC7") .And. C7_NUM == NumPed
			
			If Ascan(aSavRec,Recno()) == 0
				AADD(aSavRec,Recno())
			Endif
			
			If lEnd
				@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
				Goto Bottom
				Exit
			Endif
			
			IncRegua()
			
			If li > 56
				nOrdem++
				ImpRodape()
				ImpCabec()
			Endif
			li++
			@ li,001 PSAY "|"
			@ li,002 PSAY StrZero(Val(SC7->C7_ITEM),2)  	Picture PesqPict("SC7","C7_ITEM")
			@ li,005 PSAY "|"
			@ li,006 PSAY _cProduto	                        Picture PesqPict("SC7","C7_PRODUTO")
			
			ImpProd()
			
			If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
				nDescProd+= CalcDesc(_nPrTot,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
			Else
				nDescProd+=SC7->C7_VLDESC
			Endif
			nBaseIPI := _nPrTot - IIF(SC7->C7_IPIBRUT=="L",nDescProd,0)
			nTotIpi:=nTotIpi+NoRound(nBaseIPI*SC7->C7_IPI/100,2)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializacao da Observacao do Pedido.                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			cItem := ""
			If Len(Alltrim(SC7->C7_ITEM)) = 2
				cItem := SC7->C7_ITEM
			ElseIf Len(Alltrim(SC7->C7_ITEM)) = 4
				cItem := Substr(SC7->C7_ITEM,3,2)
			Endif

//			If !Empty(SC7->C7_OBS)
			If SC7->C7_ITEM < "08"
				cVar:="cObs"+cItem
				Eval(MemVarBlock(cVar),SC7->C7_OBS)
				_cVarCond:= "_cCond"+SC7->C7_ITEM
				Eval(MemVarBlock(_cVarCond),SC7->C7_OBS2)
			Endif
			dbSkip()
		EndDo
		
		dbGoto(nSavRec)
		If li>38
			nOrdem++
			ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
			ImpCabec()
		Endif
		
		FinalAE(nDescProd)		// dados complementares da Autorizacao de Entrega
	Next
	
	If Len(aSavRec)>0
		dbGoto(aSavRec[Len(aSavRec)])
		For i:=1 to Len(aSavRec)
			dbGoto(aSavRec[i])
			RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
			Replace C7_EMITIDO With "S"
			Replace C7_QTDREEM With (C7_QTDREEM+1)
			MsUnLock()
		Next
	Endif
	aSavRec := {}
	
	dbSkip()
End

dbSelectArea("SC7")
Set Filter To
dbSetOrder(1)

dbSelectArea("SX3")
dbSetOrder(1)

Set device to Screen
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpProd  ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pesquisar e imprimir  dados Cadastrais do Produto.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpProd(Void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PA0079                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpProd()

LOCAL cDesc, nLinRef := 1, nBegin := 0, cDescri := "", nLinha:=0

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek( xFilial("SB1")+_cProduto )
cDescri := Alltrim(SB1->B1_DESC)
_nQtEmb := SB1->B1_QE

If Substr(SB1->B1_SUBGR,1,4) == "MPIM"
	_lMenSubGr := .T.
Endif

dbSelectArea("SZ1")
dbSetOrder(1)
If dbSeek(xFilial("SZ1")+SB1->B1_TIPO)
	Do While !Eof() .and. SZ1->Z1_TIPO == SB1->B1_TIPO
		If aScan( aMens, { |x| x[1] == SZ1->Z1_CODMENS } ) == 0
			aAdd( aMens, { SZ1->Z1_CODMENS, Formula(SZ1->Z1_CODMENS) } )
		Endif
		dbSkip()
	EndDo
Endif

dbSelectArea("SB5")
dbSetOrder(1)
If dbSeek( xFilial("SB5") + _cProduto )
	cDescri := cDescri + " " + Alltrim(B5_CEME)
EndIf

dbSelectArea("SA5")
dbSetOrder(1)
If dbSeek(xFilial("SA5")+SC7->C7_FORNECE+SC7->C7_LOJA+_cProduto).And. !Empty(SA5->A5_CODPRF)
	cDescri := cDescri + " ("+Alltrim(A5_CODPRF)+")"
EndIf
dbSelectArea("SC7")

nLinha:= MLCount(cDescri,28)

@ li,021 PSAY "|"
@ li,022 PSAY MemoLine(cDescri,28,1)

ImpCampos()

For nBegin := 2 To nLinha
	li++
	@ li,001 PSAY "|"
	@ li,005 PSAY "|"
	@ li,021 PSAY "|"
	@ li,022 PSAY Memoline(cDescri,28,nBegin)
	@ li,051 PSAY "|"
	@ li,054 PSAY "|"
	@ li,068 PSAY "|"
	@ li,083 PSAY "|"
	If mv_par08 == 1
		@ li,087 PSAY "|"
		@ li,104 PSAY "|"
		@ li,115 PSAY "|"
		@ li,125 PSAY "|"
		@ li,132 PSAY "|"
	Else
		@ li,102 PSAY "|"
		@ li,111 PSAY "|"
		@ li,132 PSAY "|"
	EndIf
Next nBegin

Return NIL
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCampos³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir dados Complementares do Produto no Pedido.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCampos(Void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PA0079                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCampos()

LOCAL bBloco :={|ny| iif(ny==1,"SC7->C7_UM",iif(!Empty(SC7->C7_SEGUM),"SC7->C7_SEGUM","SC7->C7_UM"))}
LOCAL bBloco1:={|ny| iif(ny==1,"SC7->C7_QUANT",iif(!Empty(SC7->C7_QTSEGUM),"SC7->C7_QTSEGUM","SC7->C7_QUANT"))}
LOCAL bBloco2:={|ny| iif(ny==1,"_nPrUnit",iif(!Empty(SC7->C7_QTSEGUM),"_nPrTot/SC7->C7_QTSEGUM","_nPrUnit"))}

@ li,051 PSAY "|"
@ li,052 PSAY &(Eval(bBloco,mv_par07))     Picture PesqPict("SC7","C7_UM")
@ li,054 PSAY "|"
dbSelectArea("SC7")
@ li,055 PSAY &(Eval(bBloco1,mv_par07))    Picture PesqPictQt("C7_QUANT",13)
@ li,068 PSAY "|"
@ li,069 PSAY &(Eval(bBloco2,mv_par07))    Picture PesqPict("SC7","C7_PRECO",14)
@ li,083 PSAY "|"

If mv_par08 == 1
	@ li,084 PSAY SC7->C7_IPI     				 Picture "99"
	@ li,086 PSAY "%"
	@ li,087 PSAY "|"
	@ li,088 PSAY _nPrTot      				     Picture PesqPict("SC7","C7_TOTAL",16)
	@ li,104 PSAY "|"
	@ li,105 PSAY SC7->C7_DATPRF  				 Picture PesqPict("SC7","C7_DATPRF")
	@ li,115 PSAY "|"
	@ li,116 PSAY _nQtEmb        				 Picture PesqPict("SC7","C7_QUANT",9)
	@ li,125 PSAY "|"
	@ li,126 PSAY SC7->C7_NUMSC
	@ li,132 PSAY "|"
Else
	@ li,084 PSAY _nPrTot      				     Picture PesqPict("SC7","C7_TOTAL",16)
	@ li,100 PSAY "|"
	@ li,101 PSAY SC7->C7_DATPRF  				 Picture PesqPict("SC7","C7_DATPRF")
	@ li,111 PSAY "|"
	@ li,113 PSAY SC7->C7_OP
	@ li,132 PSAY "|"
EndIf

nTotNota:= nTotNota + _nPrTot
nTotal  := nTotal   + _nPrTot

Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FinalPed ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados complementares do Pedido de Compra        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinalPed(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PA0079                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FinalPed(nDescProd)
Local nk := 1,lImpLeg := .T.
Local nTotDesc:= nDescProd,nQuebra := 0
Local lNewAlc:= .F.,cComprador:="",cAlter:="",cAprov:="",lLiber := .F.
Local aLinhas := {}

cMensagem:= Formula(C7_MSG)
nTotIPI := NoRound(nTotIPI,2)
If !Empty(cMensagem)
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Padc(cMensagem,129)
	@ li,132 PSAY "|"
Endif
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li++
While li<39
	@ li,001 PSAY "|"
	@ li,005 PSAY "|"
	@ li,021 PSAY "|"
	@ li,021 + nk PSAY "*"
	nk := IIf( nk == 32 , 1 , nk + 1 )
	@ li,051 PSAY "|"
	@ li,054 PSAY "|"
	@ li,068 PSAY "|"
	@ li,083 PSAY "|"
	@ li,087 PSAY "|"
	@ li,104 PSAY "|"
	@ li,115 PSAY "|"
	@ li,125 PSAY "|"
	@ li,132 PSAY "|"
	li++
EndDo
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li++
@ li,001 PSAY "|"
@ li,015 PSAY "D E S C O N T O S -->"
@ li,037 PSAY C7_DESC1 Picture "999.99"
@ li,046 PSAY C7_DESC2 Picture "999.99"
@ li,055 PSAY C7_DESC3 Picture "999.99"

@ li,068 PSAY nTotDesc Picture tm(nTotDesc,14)
@ li,132 PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acessar o Endereco para Entrega do Arquivo de Empresa SM0.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAlias := Alias()
dbSelectArea("SM0")
dbSetOrder(1)   // forca o indice na ordem certa
nRegistro := Recno()
dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT)
li++
@ li,001 PSAY "|"
@ li,003 PSAY "Local de Entrega  : " + SM0->M0_ENDENT
@ li,057 PSAY "-"
@ li,061 PSAY SM0->M0_CIDENT
@ li,083 PSAY "-"
@ li,085 PSAY SM0->M0_ESTENT
@ li,088 PSAY "-"
@ li,090 PSAY "CEP :"
@ li,096 PSAY Alltrim(SM0->M0_CEPENT)
@ li,132 PSAY "|"
dbGoto(nRegistro)

dbSelectArea( cAlias )
li++
@ li,001 PSAY "|"
@ li,003 PSAY "Local de Cobranca : " + SM0->M0_ENDCOB
@ li,057 PSAY "-"
@ li,061 PSAY SM0->M0_CIDCOB
@ li,083 PSAY "-"
@ li,085 PSAY SM0->M0_ESTCOB
@ li,088 PSAY "-"
@ li,090 PSAY "CEP :"
@ li,096 PSAY Alltrim(SM0->M0_CEPCOB)
@ li,132 PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial("SE4")+SC7->C7_COND)
dbSelectArea("SC7")

/*
Condicao de Pagamento                                |Data de Emissao| Total das Mercadorias :   99999999999999
012345678901234567901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
0        1        2         3         4         5         6         7         8         9         0         1         2          3
-------------------------------------------------------------------------------


*/

If Empty(_cCond02)
	If Len(_cCond01) > 50
		_cCond    := _cCond01
		_cCond01  := Substr(_cCond,1,50)
		For nX := 2 To 4
			_cVarCond  := "_cCond"+StrZero(nX,2)
			&_cVarCond := Substr(_cCond,(50*(nX-1))+1,50)
		Next
	EndIf
Else
	_cCond01:= Substr(_cCond01,1,IIf(Len(_cCond01)<50,Len(_cCond01),50))
	_cCond02:= Substr(_cCond02,1,IIf(Len(_cCond02)<50,Len(_cCond01),50))
	_cCond03:= Substr(_cCond03,1,IIf(Len(_cCond03)<50,Len(_cCond01),50))
	_cCond04:= Substr(_cCond04,1,IIf(Len(_cCond04)<50,Len(_cCond01),50))
Endif

li++
@ li,001 PSAY "|"
@ li,003 PSAY "Condicao de Pagto "
@ li,054 PSAY "|Data de Emissao|"
@ li,074 PSAY "Total das Mercadorias : "
@ li,100 PSAY nTotal Picture tm(nTotNota,14)
@ li,132 PSAY "|"
li++
@ li,001 PSAY "|"
@ li,003 PSAY IIf (Vazio(SC7->C7_OBS2),SubStr(SE4->E4_COND,1,15), _cCond01)
@ li,054 PSAY "|"
@ li,061 PSAY SC7->C7_EMISSAO
@ li,070 PSAY "|"
@ li,132 PSAY "|"

li++
@ li,001 PSAY "|"
@ li,003 PSAY IIf (Vazio(SC7->C7_OBS2),"Descr: "+SubStr(SE4->E4_DESCRI,1,34), _cCond02)
@ li,054 PSAY "|"+Replicate("-",77)
@ li,132 PSAY "|"

dbSelectArea("SM4")
dbSetOrder(1)
dbSeek(xFilial("SM4")+SC7->C7_REAJUST)
dbSelectArea("SC7")

li++
@ li,001 PSAY "|"
@ li,003 PSAY IIF (Empty(_cCond03),Space(50),_cCond03)
@ li,054 PSAY "| IPI   :"
@ li,100 PSAY nTotIpi         Picture tm(nTotIpi,14)
@ li,132 PSAY "|"
li++

@ li,001 PSAY "|"
@ li,003 PSAY _cCond04
@ li,054 PSAY "| Frete :"
@ li,100 PSAY SC7->C7_FRETE   Picture tm(SC7->C7_FRETE,14)
@ li,132 PSAY "|"
li++

@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",52)
@ li,054 PSAY "| Grupo :"
@ li,132 PSAY "|"

li++
@ li,001 PSAY "|"
@ li,002 PSAY "Reajuste :"
@ li,014 PSAY SC7->C7_REAJUST Picture PesqPict("SC7","c7_reajust")
@ li,018 PSAY SM4->M4_DESCR
@ li,054 PSAY "|"
@ li,055 PSAY Replicate("-",77)
@ li,132 PSAY "|"

If Empty(cObs02)
	If Len(cObs01) > 50
		cObs   := cObs01
		cObs01 := Substr(cObs,1,50)
		For nX := 2 To 4
			cVar  := "cObs"+StrZero(nX,2)
			&cVar := Substr(cObs,(50*(nX-1))+1,50)
		Next
	EndIf
Else
	cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
	cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
	cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
	cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
	cObs05:= Substr(cObs05,1,IIf(Len(cObs05)<50,Len(cObs01),50))
	cObs06:= Substr(cObs06,1,IIf(Len(cObs06)<50,Len(cObs01),50))
	cObs07:= Substr(cObs07,1,IIf(Len(cObs07)<50,Len(cObs01),50))
EndIf

dbSelectArea("SC7")
If !Empty(C7_APROV)
	lNewAlc := .T.
	cComprador := UsrFullName(SC7->C7_USER)
	If C7_CONAPRO == "L"
		lLiber := .T.
	EndIf
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial("SCR")+SC7->C7_NUM)
	While !Eof() .And. SCR->CR_FILIAL+SCR->CR_NUM==xFilial("SCR")+SC7->C7_NUM
		cAprov += AllTrim(UsrFullName(SCR->CR_USER))+" ["+ IIF(SCR->CR_STATUS=="03","Ok",IiF(SCR->CR_STATUS=="04","BLQ","??"))+"] - "
		dbSelectArea("SCR")
		dbSkip()
	Enddo
	If !Empty(SC7->C7_GRUPCOM)
		dbSelectArea("SAJ")
		dbSetOrder(1)
		dbSeek(xFilial("SAJ")+SC7->C7_GRUPCOM)
		While !Eof() .And. SAJ->AJ_FILIAL+SAJ->AJ_GRCOM == xFilial("SAJ")+SC7->C7_GRUPCOM
			If SAJ->AJ_USER != SC7->C7_USER
				cAlter += AllTrim(UsrFullName(SAJ->AJ_USER))+"/"
			EndIf
			dbSelectArea("SAJ")
			dbSkip()
		EndDo
	EndIf
EndIf

li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",52)
@ li,054 PSAY "| Total Geral : "

nTotGeral:=nTotNota+nTotIpi-nTotDesc
If !lNewAlc
	@ li,100 PSAY nTotGeral      Picture tm(nTotGeral,14)
Else
	If lLiber
		@ li,100 PSAY nTotGeral      Picture tm(nTotGeral,14)
	Else
		@ li,080 PSAY ("     P E D I D O   B L O Q U E A D O ")
	EndIf
EndIf

@ li,132 PSAY "|"

li++
@ li,001 PSAY "| Observacoes"
@ li,054 PSAY "|"+Replicate("-",77)
@ li,132 PSAY "|"


If !lNewAlc
	
	li++
	@ li,001 PSAY "|"
	@ li,003 PSAY cObs01
	@ li,054 PSAY "|             Nome do Comprador:"
	@ li,102 PSAY "| Obs. do Frete: "
	@ li,119 PSAY IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " ))
	@ li,132 PSAY "|"
	
	li++
	@ li,001 PSAY "|"
	@ li,003 PSAY cObs02
	@ li,054 PSAY "|             "+ Alltrim(Upper(UsrFullName(__cUserID)))
	@ li,102 PSAY "|"
	@ li,132 PSAY "|"
	li++
	
	cLiberador := ""
	nPosicao := 0
	If lLiberador
		If SubStr(SC7->C7_CODLIB,1,6) == EnCript(cMestra,0)
			cLiberador := "Administrador"
		Else
			cSenhaA  := SubStr(SC7->C7_CODLIB,1,6)
			For nx := 1 To Len(aSenhas)
				If aSenhas[nx][1] == cSenhaA
					nPosicao := nx
					Exit
				EndIf
			Next
			If nPosicao > 0
				cLiberador := EnCript(SubStr(aUsuarios[nPosicao][1],8,30),1)
			EndIf
		EndIf
	EndIf
	
	@ li,001 PSAY "|"
	@ li,003 PSAY cObs03
	@ li,054 PSAY "|"
	@ li,102 PSAY "|"
	@ li,132 PSAY "|"
	li++
	
	@ li,001 PSAY "|"
	@ li,003 PSAY cObs04
	@ li,054 PSAY "|"
	@ li,102 PSAY "|"+Replicate("-",29)
	@ li,132 PSAY "|"
	li++
	
	@ li,001 PSAY "|"
	@ li,003 PSAY cObs05
	@ li,054 PSAY "|"
	@ li,102 PSAY "|     Liberacao do Pedido"
	@ li,132 PSAY "|"
	li++
	
	@ li,001 PSAY "|"
	@ li,003 PSAY cObs06
	@ li,054 PSAY "|     ------------------------------"
	@ li,102 PSAY "|"
	@ li,132 PSAY "|"
	li++
	
	@ li,001 PSAY "|"
	@ li,003 PSAY cObs07	
	@ li,054 PSAY "|"
	@ li,102 PSAY "|     -------------------"
	@ li,132 PSAY "|"
	li++
	
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,132 PSAY "|"
	li++
	
	If _lMenSubGr
		@ li,001 PSAY "| NOTA: NAO ACEITAREMOS MERCADORIAS COM QUANTIDADE MAIOR QUE A DETERMINADA NO PEDIDO."
		@ li,132 PSAY "|"
	Endif
	
	li++
	For j := 1 to Len(aMens)
		aLinhas := U_BrkLines(aMens[j][2],128)
		For h := 1 to Len(aLinhas)
			@ li,001 PSAY "| "
			@ li,003 PSAY aLinhas[h]
			@ li,132 PSAY "|"
			li++
		Next h
	Next j
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,132 PSAY "|"
Else
	@ li,001 PSAY "|"
	@ li,003 PSAY IIF (Empty(cObs04),Space(50),cObs04)
	@ li,054 PSAY "|"
	@ li,059 PSAY IF(lLiber,"     P E D I D O   L I B E R A D O","|     P E D I D O   B L O Q U E A D O !!!")
	@ li,102 PSAY "| Obs. do Frete: "
	@ li,119 PSAY IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " ))
	@ li,132 PSAY "|"
	li++
	@ li,001 PSAY "|"+Replicate("-",99)
	@ li,102 PSAY "|"
	@ li,132 PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,003 PSAY "Comprador Responsavel :"
	@ li,027 PSAY Substr(cComprador,1,60)
	@ li,088 PSAY "|"
	@ li,089 PSAY "BLQ:Bloqueado"
	@ li,102 PSAY "|"
	@ li,132 PSAY "|"
	li++
	nAuxLin := Len(cAlter)
	@ li,001 PSAY "|"
	@ li,003 PSAY "Compradores Alternativos :"
	While nAuxLin > 0 .oR. lImpLeg
		@ li,029 PSAY Substr(cAlter,Len(cAlter)-nAuxLin+1,60)
		@ li,088 PSAY "|"
		If lImpLeg
			@ li,089 PSAY "Ok:Liberado"
			lImpLeg := .F.
		EndIf
		@ li,102 PSAY "|"
		@ li,132 PSAY "|"
		nAuxLin -= 60
		li++
	EndDo
	nAuxLin := Len(cAprov)
	lImpLeg := .T.
	@ li,001 PSAY "|"
	@ li,003 PSAY "Aprovador(es) :"
	While nAuxLin > 0	.Or. lImpLeg
		@ li,019 PSAY Substr(cAprov,Len(cAprov)-nAuxLin+1,70)
		@ li,088 PSAY "|"
		If lImpLeg
			@ li,089 PSAY "??:Aguar.Lib"
			lImpLeg := .F.
		EndIf
		@ li,102 PSAY "|"
		@ li,132 PSAY "|"
		nAUxLin -=70
		li++
	EndDo
	If nAuxLin == 0
		li++
	EndIf
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,132 PSAY "|"
	li++
	@ li,001 PSAY "|   NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras."
	@ li,132 PSAY "|"
	li++
	
	If _lMenSubGr
		@ li,001 PSAY "|         NAO ACEITAREMOS MERCADORIAS COM QUANTIDADE MAIOR QUE A DETERMINADA NO PEDIDO."
		@ li,132 PSAY "|"
	Endif
	
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,132 PSAY "|"
EndIf

Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FinalAE  ³ Autor ³ Cristina Ogura        ³ Data ³ 05.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados complementares da Autorizacao de Entrega  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinalAE(Void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PA0079                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FinalAE(nDescProd)
Local nk := 1
Local nTotDesc:= nDescProd
cMensagem:= Formula(C7_MSG)
nTotIPI := NoRound(nTotIPI,2)
If !Empty(cMensagem)
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Padc(cMensagem,129)
	@ li,132 PSAY "|"
Endif
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li++
While li<39
	@ li,001 PSAY "|"
	@ li,005 PSAY "|"
	@ li,021 PSAY "|"
	@ li,021 + nk PSAY "*"
	nk := IIf( nk == 32 , 1 , nk + 1 )
	@ li,051 PSAY "|"
	@ li,054 PSAY "|"
	@ li,068 PSAY "|"
	@ li,083 PSAY "|"
	@ li,100 PSAY "|"
	@ li,111 PSAY "|"
	@ li,132 PSAY "|"
	li++
EndDo
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acessar o Endereco para Entrega do Arquivo de Empresa SM0.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAlias := Alias()
dbSelectArea("SM0")
dbSetOrder(1)   // forca o indice na ordem certa
nRegistro := Recno()
dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT)
li++
@ li,001 PSAY "|"
@ li,003 PSAY "Local de Entrega  : " + Alltrim(SM0->M0_ENDENT)
@ li,057 PSAY "-"
@ li,061 PSAY Alltrim(SM0->M0_CIDENT)
@ li,083 PSAY "-"
@ li,085 PSAY Alltrim(SM0->M0_ESTENT)
@ li,088 PSAY "-"
@ li,090 PSAY "CEP :"
@ li,096 PSAY Alltrim(SM0->M0_CEPENT)
@ li,132 PSAY "|"
dbGoto(nRegistro)

dbSelectArea(cAlias)
li++
@ li,001 PSAY "|"
@ li,003 PSAY "Local de Cobranca : " + Alltrim(SM0->M0_ENDCOB)
@ li,057 PSAY "-"
@ li,061 PSAY Alltrim(SM0->M0_CIDCOB)
@ li,083 PSAY "-"
@ li,085 PSAY Alltrim(SM0->M0_ESTCOB)
@ li,088 PSAY "-"
@ li,090 PSAY "CEP :"
@ li,096 PSAY Alltrim(SM0->M0_CEPCOB)
@ li,132 PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial("SE4")+SC7->C7_COND)
dbSelectArea("SC7")
li++
@ li,001 PSAY "|"
@ li,003 PSAY "Condicao de Pagto "+SubStr(SE4->E4_COND,1,15)
@ li,038 PSAY "|Data de Emissao|"
@ li,056 PSAY "Total das Mercadorias : "
@ li,094 PSAY nTotal Picture tm(nTotNota,14)
@ li,132 PSAY "|"
li++
@ li,001 PSAY "|"
@ li,003 PSAY SubStr(SE4->E4_DESCRI,1,34)
@ li,038 PSAY "|"
@ li,043 PSAY SC7->C7_EMISSAO
@ li,054 PSAY "|"
@ li,132 PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",52)
@ li,054 PSAY "|"
@ li,055 PSAY Replicate("-",77)
@ li,132 PSAY "|"
li++
dbSelectArea("SM4")
dbSeek(xFilial("SM4")+SC7->C7_REAJUST)
dbSelectArea("SC7")
@ li,001 PSAY "|"
@ li,003 PSAY "Reajuste :"
@ li,014 PSAY SC7->C7_REAJUST Picture PesqPict("SC7","c7_reajust")
@ li,018 PSAY SM4->M4_DESCR
@ li,054 PSAY "| Total Geral : "

nTotGeral:=nTotNota+nTotIpi-nTotDesc

@ li,094 PSAY nTotGeral      Picture tm(nTotGeral,14)
@ li,132 PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializar campos de Observacoes.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cObs02)
	If Len(cObs01) > 50
		cObs 	:= cObs01
		cObs01:= Substr(cObs,1,50)
		For nX := 2 To 4
			cVar  := "cObs"+StrZero(nX,2)
			&cVar := Substr(cObs,(50*(nX-1))+1,50)
		Next
	EndIf
Else
	cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
	cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
	cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
	cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
EndIf

li++
@ li,001 PSAY "| Observacoes"
@ li,054 PSAY "| Comprador    "
@ li,070 PSAY "| Gerencia     "
@ li,085 PSAY "| Diretoria    "
@ li,132 PSAY "|"

li++
@ li,001 PSAY "|"
@ li,003 PSAY cObs01
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,132 PSAY "|"

li++
@ li,001 PSAY "|"
@ li,003 PSAY cObs02
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,132 PSAY "|"

li++
@ li,001 PSAY "|"
@ li,003 PSAY cObs03
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,132 PSAY "|"

li++
@ li,001 PSAY "|"
@ li,003 PSAY cObs04
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,132 PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li++
@ li,001 PSAY "|   NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero da Autorizacao de Entrega."
@ li,132 PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"

Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpRodape³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o rodape do formulario e salta para a proxima folha³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpRodape(Void)                 					          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 					                     					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PA0079                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRodape()
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li++
@ li,001 PSAY "|"
@ li,070 PSAY "Continua ..."
@ li,132 PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,132 PSAY "|"
li:=0
Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Cabecalho do Pedido de Compra                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCabec(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PA0079                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCabec()
Local cCGCPict, cCEPPict
@ 01,001 PSAY "|"
@ 01,002 PSAY Replicate("-",limite)
@ 01,132 PSAY "|"
@ 02,001 PSAY "|"
If mv_par08 == 1
	@ 02,045 PSAY ("| P E D I D O  D E  C O M P R A S")
Else
	@ 02,045 PSAY ("| A U T. D E  E N T R E G A     ")
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definir los pictures.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( cPaisLoc=="ARG" )
	cCepPict:="@R 9999"
	cCGCPict:="@R 99-99.999.999-9"
Else
	cCepPict:="@R 99999-999"
	cCGCPict:="@R 99.999.999/9999-99"
EndIf
@ 02,079 PSAY IIf(nOrdem>1,(" - continuacao")," ")
If ( Mv_PAR08==2 )
	@ 02,090 PSAY "|"
	@ 02,093 PSAY SC7->C7_NUMSC + "/" + SC7->C7_NUM  //    Picture PesqPict("SC7","c7_num")
Else
	@ 02,096 PSAY "|"
	@ 02,101 PSAY SC7->C7_NUM      Picture PesqPict("SC7","c7_num")
EndIf

@ 02,107 PSAY "/"+Str(nOrdem,1)
@ 02,112 PSAY IIf(SC7->C7_QTDREEM>0,Str(SC7->C7_QTDREEM+1,2)+"a.Emissao "+Str(ncw,2)+"a.VIA","")
@ 02,132 PSAY "|"
@ 03,001 PSAY "|"
@ 03,003 PSAY SM0->M0_NOMECOM
@ 03,045 PSAY "|"+Replicate("-",86)
@ 03,132 PSAY "|"
@ 04,001 PSAY "|"
@ 04,003 PSAY Alltrim(SM0->M0_ENDENT)
dbSelectArea("SA2")
dbSetOrder(1)
dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
@ 04,045 PSAY "|"
If ( cPaisLoc=="ARG" )
	@ 04,047 PSAY Substr(SA2->A2_NOME,1,40)+"  -  "+SA2->A2_COD
Else
	@ 04,047 PSAY Substr(SA2->A2_NOME,1,40)+"  -  "+SA2->A2_COD+(" I.E.: ")+SA2->A2_INSCR
EndIf
@ 04,132 PSAY "|"
@ 05,001 PSAY "|"
@ 05,003 PSAY ("CEP :")+Trans(SM0->M0_CEPENT,cCepPict)+" - "+Trim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT
@ 05,045 PSAY "|"
@ 05,047 PSAY SA2->A2_END    		Picture PesqPict("SA2","A2_END")
@ 05,089 PSAY "-  "+Trim(SA2->A2_BAIRRO)	Picture "@!"
@ 05,132 PSAY "|"
@ 06,001 PSAY "|"
@ 06,003 PSAY "TEL: "+SM0->M0_TEL
@ 06,023 PSAY "FAX: "+SM0->M0_FAX
@ 06,045 PSAY "|"
@ 06,047 PSAY Trim(SA2->A2_MUN)  Picture "@!"
@ 06,069 PSAY SA2->A2_EST    		Picture PesqPict("SA2","A2_EST")
@ 06,074 PSAY "CEP :"
@ 06,081 PSAY SA2->A2_CEP    		Picture PesqPict("SA2","A2_CEP")
@ 06,093 PSAY "CGC: "
@ 06,100 PSAY SA2->A2_CGC    		Picture PesqPict("SA2","A2_CGC")
@ 06,132 PSAY "|"
@ 07,001 PSAY "|"
@ 07,003 PSAY "CGC: "+ Transform(SM0->M0_CGC,cCgcPict)
@ 07,027 PSAY "IE:"+ InscrEst()
@ 07,045 PSAY "|"
@ 07,047 PSAY SC7->C7_CONTATO Picture PesqPict("SC7","C7_CONTATO")
@ 07,069 PSAY "FONE: "
@ 07,075 PSAY Substr(SA2->A2_TEL,1,15)
@ 07,095 PSAY "FAX: "
@ 07,101 PSAY SA2->A2_FAX     Picture PesqPict("SA2","A2_FAX")
@ 07,132 PSAY "|"
@ 08,001 PSAY "|"
@ 08,002 PSAY Replicate("-",limite)
@ 08,132 PSAY "|"

If mv_par08 == 1
	@ 09,001 PSAY "|"
	@ 09,002 PSAY "Itm|"
	@ 09,009 PSAY "Codigo      "
	@ 09,021 PSAY "|Descricao do Material"
	@ 09,051 PSAY "|UM|  Quant."
	@ 09,068 PSAY "|Valor Unitario|IPI|  Valor Total   |Entrega   |Qt.Embal.| S.C. |"
	@ 10,001 PSAY "|"
	@ 10,002 PSAY Replicate("-",limite)
	@ 10,132 PSAY "|"
Else
	@ 09,001 PSAY "|"
	@ 09,002 PSAY "Itm|"
	@ 09,009 PSAY "Codigo      "
	@ 09,021 PSAY "|Descricao do Material"
	@ 09,051 PSAY "|UM|  Quant."
	@ 09,068 PSAY "|Valor Unitario|  Valor Total   |Entrega | Numero da OP  "
	@ 09,132 PSAY "|"
	@ 10,001 PSAY "|"
	@ 10,002 PSAY Replicate("-",limite)
	@ 10,132 PSAY "|"
EndIf
dbSelectArea("SC7")
li := 10
Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R110Center³ Autor ³ Jose Lucas            ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Centralizar o Nome do Liberador do Pedido.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpC1 := R110CenteR(ExpC2)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Nome do Liberador                                 ³±±
±±³Parametros³ ExpC2 := Nome do Liberador Centralizado                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PA0079                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R110Center(cLiberador)
Return( Space((30-Len(AllTrim(cLiberador)))/2)+AllTrim(cLiberador) )
