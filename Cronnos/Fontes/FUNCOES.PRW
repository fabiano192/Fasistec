#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "SHELL.CH"
#INCLUDE "FILEIO.CH"

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

			If _cCliente == "000017" .And. Substr(SZ2->Z2_PEDCLI,1,4) $ "QAPC/QAPP/QHPP"
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

	Aadd(aCat,"D.A./Ferramental")
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


User Function FTIPOMAIL(l1Elem)

	Local cTitulo 	:=""
	Local MvPar

	Local MvParDef 	:=""
	Local oWnd
	Local cCpos			:= "M->ZG_ROTINA"
	Local cVar			:= Upper( Alltrim( ReadVar() ) )

	IF ( cVar $ cCpos )

		Private aMail:={}

		oWnd := GetWndDefault()

		cAlias := Alias() 					 // Salva Alias Anterior

		MvPar:=&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
		MvRet:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno

		dbSelectArea("SX5")
		If dbSeek(cFilial+"ZG")
			cTitulo := Alltrim(Left(SX5->X5_DESCRI,20))
		Endif

		If dbSeek(xFilial("SX5")+"ZG")
			While !Eof() .And. SX5->X5_Tabela == "ZG"

				Aadd(aMail,Alltrim(SX5->X5_Descri))
				MvParDef+=Left(SX5->X5_Chave,2)

				SX5->(dbSkip())
			Enddo
		Endif

		f_Opcoes(@MvPar,cTitulo,aMail,MvParDef,12,49,l1Elem,2)  // Chama funcao f_Opcoes

		&MvRet := mvpar										 // Devolve Resultado

		dbSelectArea(cAlias) 								 // Retorna Alias

	Endif

Return( .T. )



User FUNCTION Etiqueta(aInfo, nVias, cTemplate)

	LOCAL cEtiq:=""
	LOCAL cArq:=""
	LOCAL cArqBat:=""
	LOCAL nSt:=""
	LOCAL cNVias
	LOCAL aDefs:={}
	LOCAL nHandle
	LOCAL nLength
	LOCAL nCpo:=1
	LOCAL cXXX:=""
	LOCAL nPosCpo:=0

	cNVias:=IIf(Valtype(nVias)=="N",StrZero(nVias,4,0), "0001")

	IF !File( (cTemplate) )
		Alert('Esta função procura o Template da Etiqueta "'+Upper(cTemplate)+'" no Servidor do Sistema.'+CRLF+'E este template não foi encontrado no local indicado.')
		RETURN
	ENDIF

	nHandle := Fopen( (cTemplate) , FO_READ + FO_SHARED )
	nLength := FSEEK(nHandle, 0, FS_END)

	FSEEK(nHandle, 0)

	nLidos:=FRead( nHandle, cEtiq, nLength )

	FClose(nHandle)

	If nLength <> nLidos
		Alert("Não foi possivel ler todo o Template da Etiqueta: '"+cTemplate+"'")
		RETURN
	ENDIF

	FOR ncpo:=1 TO Len(aInfo)
		nPosCpo:=AT((aInfo[nCpo,2]),cEtiq)
		IF nPoscpo <> 0
			cEtiq:=Stuff( cEtiq,  nPosCpo,  Len(aInfo[nCpo,2]), (Alltrim(aInfo[nCpo,1])))
		ENDIF
	NEXT

	cArq:=GetTempPath(.T.)+Criatrab(,.F.)
	MemoWrite( (cArq),cEtiq)

	cArqBat:=cArq+".bat"
	MemoWrite( (cArqBat), ("TYPE "+cArq+" >LPT1") )
	nSt:=WaitRun( (cArqBat),0)

	FERASE((cArq))
	FERASE( (cArqBat) )

RETURN



User Function Estrut(cProduto,nQuant,lOneLevel,lPreEstru)

	LOCAL nRegi
	LOCAL nQuantItem:=0
	LOCAL cCodigo,cComponente,cTrt,cGrOpc,cOpc

	DEFAULT lOneLevel := .F.
	DEFAULT lPreEstru := .F.

	nQuant:=IF(nQuant == NIL,1,nQuant)
	nEstru++
	If nEstru == 1
		aEstrutura:={}
	EndIf
	dbSelectArea(If(lPreEstru,"SGG","SG1"))
	dbSetOrder(1)
	dbSeek(xFilial()+cProduto)
	While !Eof() .And. If(lPreEstru,GG_FILIAL+GG_COD,G1_FILIAL+G1_COD) == xFilial()+cProduto
		nRegi:=Recno()
		cCodigo    :=If(lPreEstru,GG_COD,G1_COD)
		cComponente:=If(lPreEstru,GG_COMP,G1_COMP)
		cTrt       :=If(lPreEstru,GG_TRT,G1_TRT)
		cGrOpc     :=If(lPreEstru,GG_GROPC,G1_GROPC)
		cOpc       :=If(lPreEstru,GG_OPC,G1_OPC)
		If cCodigo != cComponente
			nProcura:=aScan(aEstrutura,{|x| x[1] == nEstru .And. x[2] == cCodigo .And. x[3] == cComponente .And. x[5] == cTrt})
			If nProcura  = 0
				nQuantItem:=ExplEstr(nQuant,nil,nil,nil,nil,lPreEstru)
				AADD(aEstrutura,{nEstru,cCodigo,cComponente,nQuantItem,cTrt,cGrOpc,cOpc,Recno()})
			EndIf

			If !lOneLevel
				nRecno:=Recno()
				dbSeek(xFilial()+cComponente)
				IF Found()
					cCodigo:=If(lPreEstru,GG_COD,G1_COD)
					U_Estrut(cCodigo,nQuantItem,nil,lPreEstru)
					nEstru --
				Else
					MsGoto(nRecno)
					nProcura:=aScan(aEstrutura,{|x| x[1] == nEstru .And. x[2] == cCodigo .And. x[3] == cComponente .And. x[5] == cTrt})
					If nProcura  = 0
						nQuantItem:=ExplEstr(nQuant,nil,nil,nil,nil,lPreEstru)
						AADD(aEstrutura,{nEstru,cCodigo,cComponente,nQuantItem,cTrt,cGrOPc,cOpc,Recno()})
					EndIf
				Endif
			EndIf
		EndIf
		MsGoto(nRegi)
		dbSkip()
	Enddo
Return(aEstrutura)
