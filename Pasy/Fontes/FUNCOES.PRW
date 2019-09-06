#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FUNCOES   º Autor ³ Ivan M. Tore       º Data ³  30/01/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Arquivo com Funcoes Diversas                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function BrkLines(_cMessage,_nLineSize)
Local _aResult := {}
Local _nPos

If Len(Alltrim(_cMessage)) > _nLineSize
	While Len(Alltrim(_cMessage)) > _nLineSize
		_nPos := Rat(" ",Left(_cMessage,_nLineSize))
		If _nPos > _nLineSize .or. _nPos == 0
			_nPos := _nLineSize
		EndIf
		aAdd( _aResult, Left(_cMessage,_nPos - 1) )
		_cMessage := Subs(_cMessage,_nPos + 1, Len(_cMessage))
	EndDo
	If Len(Alltrim(_cMessage)) > 0
		aAdd( _aResult, _cMessage)
	Endif
Else
	aAdd( _aResult, _cMessage)
Endif

Return _aResult

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PrcVend   º Autor ³ Ivan M. Tore       º Data ³  06/02/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Retorna o valor do produto para o cliente informado        º±±
±±º          ³ Utiliza Cad. Amarracao Produto x Cliente                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs       ³ Na variavel _cCliente passar Cliente+Loja                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PrcVend(_cProduto,_cCliente,_cLoja,_cProdCli)

Local nPosPrcVen := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRCVEN"  } )
Local _aAliOri
Local nValor   := aCols[n][nPosPrcVen]
Local dDataRef := Ctod(Space(8))
Local i

_nPerDes := 0
_aAliOri := GetArea()
_aAliSZ2 := SZ2->(GETAREA())
_aAliSB1 := SB1->(GETAREA())

If !Empty(_cProdCli) .and. !Empty(_cCliente)
	dbSelectArea("SZ2")
	dbSetOrder(1)		//--> Filial + Cliente + Produto
	If dbSeek(xFilial("SZ2")+_cCliente + _cLoja + _cProduto + _cProdCli+"1")
		dDataRef := SZ2->Z2_DTREF01
		nValor   := SZ2->Z2_PRECO01
		For i := 2 to 12
			If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= dDataRef
				dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
				nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
			Endif
		Next i
		
		If _cCliente == "000008" .And. Substr(SZ2->Z2_PEDCLI,1,4) $ "QAPC/QAPP/QHPP"
			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+_cProduto)
				If SB1->B1_PICM == 12
					_nPerDes := Tabela("Z8","12")
				Else
					_nPerDes := Tabela("Z8","18")
				Endif
			Endif
			nValor := nValor - (nValor * (_nPerDes/100))
//		ElseIf _cCliente == "000026"  .And. _cLoja == "01"
		ElseIf _cCliente == "000026"  .And. _cLoja == "02"   // Alterado em 27/04/06 conforme Silvana
			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+_cProduto)
				If SB1->B1_PICM == 12
					_nPerDes := Tabela("Z8","12")
				Else
					_nPerDes := Tabela("Z8","18")
				Endif
			Endif
			nValor := nValor - (nValor * (_nPerDes/100))
		Endif	
	Endif
Endif

RestArea(_aAliSB1)
RestArea(_aAliSZ2)
RestArea(_aAliORI)

Return nValor

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldCProCliº Autor ³ Ivan M. Tore       º Data ³  22/03/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validacao do codigo do produto no cliente + o codigo do    º±±
±±º          ³ produto na Pasy                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Itens Pedido de Venda                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function VldCProCli()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nPosCProCli := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_CPROCLI" } )
Local nPosProd    := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PRODUTO" } )
Local nRegSA7, nOrderSA7, cAlias, nReg, nOrder, lRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salvando dados Alias Ativo                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAlias := Select()
nOrder := IndexOrd()
nreg   := RecNo()
lRet   := .T.

If nPosCProCli > 0
	If !Empty(aCols[n][nPosCProCli])
		dbSelectArea("SZ2")
		nOrderSZ2 := IndexOrd()
		nRegSZ2   := RecNo()
		dbSetOrder(3)
		If !dbSeek(xFilial("SZ2")+M->C5_CLIENTE+M->C5_LOJACLI+aCols[n][nPosCProCli]+aCols[n][nPosProd])
			MsgStop("Produto digitado não foi encontrado na amarração Produto x Cliente")
			lRet := .F.
		Endif
		dbSetOrder(nOrderSZ2)
		dbGoTo(nRegSZ2)
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaurando dados do alias ativo antes da funcao             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
dbSetOrder(nOrder)
dbgoTo(nreg)

Return lRet


User Function LINHA()

oGetDad:= CallMod2Obj()
oGetDad:oBrowse:bEditCol := { || ALLWAYSTRUE()}

Return(.t.)


User Function LINHA01()

oGetDad := CallMod2Obj()
oGetDad:oBrowse:bEditCol := { || oGetDad:oBrowse:GoDown(), oGetDad:oBrowse:nColPos:= 1}
'
Return(.t.)


User Function MesExtIng( nMes )

Local cRet := " "
//Local aMeses := { "Janeiro","Fevereiro","Marco","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro" }
Local aMeses := { "January","February","March","April","May","June","July","August","September","October","November","December" }

IF nMes == NIL
	nMes := Month ( dDataBase )
Elseif ValType( nMes ) = "C"
	nMes := Int ( Val ( nMes ) )
Elseif ValType ( nMes ) = "D"
	nMes := Month ( nMes )
Endif

IF nMes > 0 .and. nMes <= 12
	cRet := aMeses [ nMes ]
Endif

Return cRet


User Function FSUBGRUPO(l1Elem)

Local cTitulo:=""
Local MvPar
Local MvParDef:=""
Local oWnd

Private aCat:={}
l1Elem := If (l1Elem = Nil , .F. , .T.)

oWnd := GetWndDefault()

cAlias := Alias() 					 // Salva Alias Anterior
MvPar:=&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
mvRet:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
dbSelectArea("SX5")
If dbSeek(cFilial+"00Z1")
	cTitulo := Alltrim(Left(SX5->X5_Descri,20))
Endif
If dbSeek(xFilial("SX5")+"Z1")
	While !Eof() .And. SX5->X5_Tabela == "Z1"
		If Substr(SX5->X5_CHAVE,1,4) $ "MPIM/9999"
			Aadd(aCat,Alltrim(SX5->X5_Descri))
			MvParDef+=Left(SX5->X5_Chave,6)
		Endif
		dbSkip()
	Enddo
Endif

f_Opcoes(@MvPar,cTitulo,aCat,MvParDef,12,49,l1Elem,6)  // Chama funcao f_Opcoes
&MvRet := mvpar										 // Devolve Resultado
dbSelectArea(cAlias) 								 // Retorna Alias
Return( .T. )

User Function FTIPOPED(l1Elem)

Local cTitulo:=""
Local MvPar
Local MvParDef:=""
Local oWnd

Private aCat:={}
//l1Elem := If (l1Elem = Nil , .F. , .T.)
l1Elem := .F.

oWnd := GetWndDefault()

cAlias := Alias() 					 // Salva Alias Anterior
MvPar:=&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
mvRet:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
cTitulo := "Tipo de Pedido"

Aadd(aCat,"Firme")
MvParDef+="N"

Aadd(aCat,"Amostra")
MvParDef+="A"

Aadd(aCat,"Previsao")
MvParDef+="Z"

Aadd(aCat,"Despesas Acessorias")
MvParDef+="D"

Aadd(aCat,"Aquisicao Material")
MvParDef+="M"

Aadd(aCat,"Industrializacao")
MvParDef+="I"

f_Opcoes(@MvPar,cTitulo,aCat,MvParDef,12,49,l1Elem,1)  // Chama funcao f_Opcoes
&MvRet := mvpar										 // Devolve Resultado
dbSelectArea(cAlias) 								 // Retorna Alias
Return( .T. )



User Function ContReg()

Local _nQtReg := 0
While !Eof()
	_nQtReg++
	dbSkip()
EndDo

dbGotop()

Return(_nQtReg)

User Function QTREG()

Local _nQtReg := 0
While !Eof()
	_nQtReg++
	dbSkip()
EndDo

dbGotop()

Return(_nQtReg)
               

User Function FILUSER(cFilADV)

cFilADV := Upper(cFilADV)
 
cFilADV := StrTran(cFilADV,".AND."," AND ")
cFilADV := StrTran(cFilADV,".OR."," OR ")
cFilADV := StrTran(cFilADV,"=="," = ")
cFilADV := StrTran(cFilADV,'"',"'")
cFilADV := StrTran(cFilADV,'$'," IN ")
cFilADV := StrTran(cFilADV,"ALLTRIM","  ")
 
Return(cFilADV)
                               

User Function CRIASX1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo,nTamanho,nDecimal,nPresel,cGSC,;
					 cValid,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
					        cVar02,cDef02,cDefSpa2,cDefEng2,cCnt02,;
					        cVar03,cDef03,cDefSpa3,cDefEng3,cCnt03,;
					        cVar04,cDef04,cDefSpa4,cDefEng4,cCnt04,;
					        cVar05,cDef05,cDefSpa5,cDefEng5,cCnt05,;
					        cF3,cPyme,cGrpSxg,cHelp)

_aAliOri := GetArea()
cPyme    := Iif(cPyme   == Nil, " " , cPyme )
cF3      := Iif(cF3     == NIl, " " , cF3 )
cGrpSxg  := Iif(cGrpSxg == Nil, " " , cGrpSxg )
cCnt01   := Iif(cCnt01  == Nil, ""  , cCnt01 )
cHelp	 := If(cHelp    == Nil, ""  , cHelp)

_nTam   := Len(Alltrim(cGrupo)) 
_nSX1   := Len(SX1->X1_GRUPO)

If _nTam < _nSX1
	cGrupo := Alltrim(cGrupo)+Space(_nSX1 - _nTam)
Endif

dbSelectArea("SX1")
dbSetOrder(1)

If !(dbSeek(cGrupo + cOrdem ))
	Reclock("SX1" , .T. )
	Replace X1_GRUPO   With cGrupo
	Replace X1_ORDEM   With cOrdem
	Replace X1_PERGUNT With cPergunt
	Replace X1_PERSPA  With cPerSpa
	Replace X1_PERENG  With cPerEng
	Replace X1_VARIAVL With cVar
	Replace X1_TIPO    With cTipo
	Replace X1_TAMANHO With nTamanho
	Replace X1_DECIMAL With nDecimal
	Replace X1_PRESEL  With nPresel
	Replace X1_GSC     With cGSC
	Replace X1_VALID   With cValid

	Replace X1_VAR01   With cVar01

	Replace X1_F3      With cF3
	Replace X1_GRPSXG  With cGrpSxg

	Replace X1_CNT01   With cCnt01
	If cGSC == "C"			// Mult Escolha
		Replace X1_DEF01   With cDef01
		Replace X1_DEFSPA1 With cDefSpa1
		Replace X1_DEFENG1 With cDefEng1

		Replace X1_DEF02   With cDef02
		Replace X1_DEFSPA2 With cDefSpa2
		Replace X1_DEFENG2 With cDefEng2

		Replace X1_DEF03   With cDef03
		Replace X1_DEFSPA3 With cDefSpa3
		Replace X1_DEFENG3 With cDefEng3

		Replace X1_DEF04   With cDef04
		Replace X1_DEFSPA4 With cDefSpa4
		Replace X1_DEFENG4 With cDefEng4

		Replace X1_DEF05   With cDef05
		Replace X1_DEFSPA5 With cDefSpa5
		Replace X1_DEFENG5 With cDefEng5
	Endif

	Replace X1_HELP  With cHelp

	MsUnlock()
Endif

RestArea(_aAliOri)

Return                         