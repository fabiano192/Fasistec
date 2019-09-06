#INCLUDE "TOTVS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MT250MNU บ Autor ณ Alexandro da Silva บ Data ณ  17/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de Entrada para incluir menu no Movto Produ็ใo       บฑฑ
ฑฑ           ณ MATA250()                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SigaEst                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


User Function MT250MNU()

	_aAliORI := GetArea()
	_aAliSD3 := SD3->(GetArea())

	_aRot := {}
//	AADD(_aRot,{"Lote Composto"	,"U_LOTEPROD()"	,0,2,0,NIL})
	AADD(_aRot,{"Ocorrencias"	,"U_CR0099()" 	,0,2,0,NIL})
	AADD(_aRot,{"Etiqueta"		,"U_CR0031()" 	,0,2,0,NIL})

	Set Key VK_F11 TO U_CR0099()

	RestArea(_aAliSD3)
	RestArea(_aAliOri)

Return(_aRot)



User Function LOTEPROD(cAlias,nReg)

	// Variaveis utilizadas para posicionamento dos objetos
	Local nOpc     := 6
	Local aObjects :={},aPosObj  :={}
	Local aSize    :=MsAdvSize()
	Local aInfo    :={aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	Local nOpca    := 0
	Local nx       := 0
	Local aListaSD5:={}
	Local aArea    :=GetArea()
	Local aAreaSD3 :=GetArea()
	Local lContinua:= .T.
	// Variaveis utilizadas na selecao de registros
	Local oChkQual,lQual,oQual,cVarQ
	// Carrega bitmaps
	Local oOk       := LoadBitmap( GetResources(), "LBOK")
	Local oNo       := LoadBitmap( GetResources(), "LBNO")
	// Selecao para filtro
	Local aOpcFiltro:={1}

	// Valida se trata-se de um movimento de producao
	If Subs(D3_CF,1,2) != "PR"
		Help(" ",1,"A250NAO")
		lContinua := .F.
	ElseIf D3_ESTORNO == "S"
		Help(" ",1,"A250ESTORN")
		lContinua := .F.
	ElseIf Empty(D3_LOTECTL+D3_NUMLOTE)
		Help(" ",1,"NAORASTRO")
		lContinua := .F.
	EndIf

	// Seleciona parametrizacao ao usuario
	If lContinua .And. ParamBox({	{3,"Apresenta itens :",aOpcFiltro[1],{"Sem lote associado","Com lote associado","Todos"},60,,.T.}},"Selecao de registros",aOpcFiltro,,,.T.,120,3)

		// Array com objetos utilizados
		AADD(aObjects,{100,095,.T.,.F.,.F.})
		AADD(aObjects,{100,100,.T.,.T.,.F.})
		aPosObj:=MsObjSize(aInfo,aObjects)

		// Monta lista de registros
		dbSelectArea("SD3")
		dbSetOrder(4)
		dbSelectArea("SD5")
		dbSetOrder(4)
		dbSeek(xFilial("SD5")+SD3->D3_OP)
		While !EOF() .And. SD5->D5_FILIAL+SD5->D5_OP == xFilial("SD3")+SD3->D3_OP
			// Checa registros validos para a lista
			If D5_ESTORNO == "S" .Or. Substr(AC040TM(SD5->D5_NUMSEQ,SD5->D5_ORIGLAN),1,1) # "R" .Or. If(aOpcFiltro[1] == 1,!Empty(D5_LOTEPRD+D5_SLOTEPR),If(aOpcFiltro[1] == 2,Empty(D5_LOTEPRD+D5_SLOTEPR),.F.))
				dbSkip()
				Loop
			EndIf
			// Adiciona registros na lista
			AADD(aListaSD5,{.F.,SD5->D5_PRODUTO,SD5->D5_DATA,SD5->D5_LOTECTL,If(Rastro(SD5->D5_PRODUTO,"S"),SD5->D5_NUMLOTE,""),SD5->D5_QUANT,SD5->D5_DOC,SD5->D5_SERIE,SD5->D5_NUMSEQ,SD5->D5_OP,SD5->D5_LOTEPRD,SD5->D5_SLOTEPR,Recno()})
			dbSkip()
		End
		// Restaura area original do SD3
		SD3->(RestArea(aAreaSD3))

		// Mostra interface para
		If Len(aListaSD5) > 0
			DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Muda o valor do aRotina para so visualizar enchoice.         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			EnChoice(cAlias,nReg,nOpc,,,,,{aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]})
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Monta tela para selecao dos registros                        ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			@ aPosObj[2,1],aPosObj[2,2] TO aPosObj[2,3],aPosObj[2,4] LABEL "Selecione as requisicoes que devem ser associadas ao lote produzido." OF oDlg  PIXEL
			@ aPosObj[2,1]+10,aPosObj[2,2]+5 CHECKBOX oChkQual VAR lQual PROMPT "Inverte Selecao" SIZE 50, 10 OF oDlg PIXEL ON CLICK (AEval(aListaSD5, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}), oQual:Refresh(.F.))
			@ aPosObj[2,1]+25,aPosObj[2,2]+5 LISTBOX oQual VAR cVarQ Fields HEADER "",RetTitle("D5_PRODUTO"),RetTitle("D5_DATA"),RetTitle("D5_LOTECTL"),RetTitle("D5_NUMLOTE"),RetTitle("D5_QUANT"),RetTitle("D5_DOC"),RetTitle("D5_SERIE"),RetTitle("D5_NUMSEQ"),RetTitle("D5_OP"),RetTitle("D5_LOTEPRD"),RetTitle("D5_SLOTEPR") SIZE (aPosObj[2,4]-aPosObj[2,2])-15,(aPosObj[2,3]-aPosObj[2,1])-30 ON DBLCLICK (aListaSD5:=CA250Troca(oQual:nAt,aListaSD5),oQual:Refresh()) SCROLL OF oDlg PIXEL
			oQual:SetArray(aListaSD5)
			oQual:bLine := { || {If(aListaSD5[oQual:nAt,1],oOk,oNo),aListaSD5[oQual:nAt,2],aListaSD5[oQual:nAt,3],aListaSD5[oQual:nAt,4],aListaSD5[oQual:nAt,5],aListaSD5[oQual:nAt,6],aListaSD5[oQual:nAt,7],aListaSD5[oQual:nAt,8],aListaSD5[oQual:nAt,9],aListaSD5[oQual:nAt,10],aListaSD5[oQual:nAt,11],aListaSD5[oQual:nAt,12]}}
			oQual:Refresh()
			ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca:=1,oDlg:End()},{||oDlg:End()})

			// Grava lote / sublote nos registros selecionados
			If nOpca == 1
				// Ordena pelos registros
				ASORT(aListaSD5,,,{ |x,y| x[13] < y[13]})
				// Varre lista de registros
				For nx:=1 to Len(aListaSD5)
					If aListaSD5[nx,1]
						// Se estiver marcado grava lote produzido
						SD5->(dbGoto(aListaSD5[nx,13]))
						Reclock("SD5",.F.)
						Replace D5_LOTEPRD With SD3->D3_LOTECTL
						Replace D5_SLOTEPR With SD3->D3_NUMLOTE
						MsUnlock()
					EndIf
				Next nx
			EndIf
		Else
			Help(" ",1,"RECNO")
		EndIf
	EndIf
RETURN


/*
Autor		:	Fabiano da Silva
Data		:	22/06/15
Descri็ใo	:	Pontos de Entrada do m๓dulo Estoque/Custos
SF1100I()	:	Ap๓s a grava็ใo da baixa do CQ
Link TDN	:	http://tdn.totvs.com/display/public/mp/A175GRV
Desc. TDN	: 	LOCALIZAวรO : Function A175Grava() - Responsแvel por realizar a Liberacao/Rejeicao do Material no CQ. EM QUE PONTO : ษ chamado ap๓s a grava็ใo de todos os dados (funcao FGRAVACQ), inclusive apos gerar a requisicao no arquivo de movimentos internos (SD3).
*/
User Function A175GRV()

	Private _lRet

	nOpcao := 0

	SD1->(dbSetOrder(2))
	If SD1->(dbSeek(xFilial('SD1')+SD7->D7_PRODUTO+SD7->D7_DOC+SD7->D7_SERIE+SD7->D7_FORNECE+SD7->D7_LOJA, .F.))

		ConOut("Enviando E-Mail Retorno do CQ:")

		oProcess := TWFProcess():New( "ENVEM2", "CQ" )

		oProcess:NewTask( "CQ", "\WORKFLOW\RETCQ.HTM" )
		oProcess:bReturn  := ""
		oProcess:bTimeOut := ""
		oHTML := oProcess:oHTML

		oProcess:cSubject := "Retorno CQ "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

		If SD1->D1_TIPO $ 'D|B' // Devolucao|Beneficiamento
			SA1->(dbSetOrder(1))
			If SA1->(dbSeek(xFilial('SA1')+SD1->D1_FORNECE+SD1->D1_LOJA, .F.))
				_cClifor	:= "Cliente"
				_cDesCliFor := SD1->D1_FORNECE+'/'+SD1->D1_LOJA + ' - '+Alltrim(SA1->A1_NREDUZ)
			EndIf
		Else
			SA2->(dbSetOrder(1))
			If SA2->(dbSeek(xFilial('SA2')+SD1->D1_FORNECE+SD1->D1_LOJA))
				_cClifor	:= "Fornecedor"
				_cDesCliFor := SD1->D1_FORNECE+'/'+SD1->D1_LOJA + ' - '+Alltrim(SA2->A2_NREDUZ)
			EndIf
		EndIf

		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial('SB1') + SD7->D7_PRODUTO, .F.))

		oHtml:ValByName( "CLIFOR" 		, _cClifor			)
		oHtml:ValByName( "DESCLIFOR" 	, _cDesCliFor		)
		oHtml:ValByName( "NF"  			, SD7->D7_SERIE+'-'+SD7->D7_DOC)
		oHtml:ValByName( "EMISSAO"		, DTOC(SD1->D1_DTDIGIT))
		oHtml:ValByName( "PRODUTO"		, Alltrim(SD7->D7_PRODUTO)+' - '+Alltrim(SB1->B1_DESC))

		_cKey := SD7->D7_FILIAL+SD7->D7_NUMERO+SD7->D7_PRODUTO+SD7->D7_LOCAL

		While SD7->(!Eof()) .AND. _cKey == SD7->D7_FILIAL+SD7->D7_NUMERO+SD7->D7_PRODUTO+SD7->D7_LOCAL

			_cStatus := ''
			_cCor	 := '255, 255, 255' //Branco
			If SD7->D7_TIPO = 0
				_cStatus	:= 'QTDE ORIGINAL'
			ElseIf SD7->D7_TIPO = 1
				_cStatus	:= 'LIBERADO'
				_cCor		:= '153, 255, 153' //Verde
			ElseIf SD7->D7_TIPO = 2
				_cStatus	:= 'REJEITADO'
				_cCor		:= '255, 0, 0' //Vermelho
			ElseIf SD7->D7_TIPO = 5
				_cStatus	:= 'ALTERAวรO DT VALIDADE'
				_cCor		:= '192, 192, 192' //Cinza
			ElseIf SD7->D7_TIPO = 6
				_cStatus	:= 'ESTORNO LIBERAวรO'
				_cCor		:= '255, 255, 0' //Amarelo
			ElseIf SD7->D7_TIPO = 7
				_cStatus	:= 'ESTORNO REJEIวรO'
				_cCor		:= '255, 255, 0' //Amarelo
			Endif

			AADD( (oHtml:ValByName( "it.DATA"   )),  DTOC(SD7->D7_DATA))
			AADD( (oHtml:ValByName( "it.QTDE"   )),  TRANSFORM( SD7->D7_QTDE,  '@E 999,999,999.99' ))
			AADD( (oHtml:ValByName( "it.SALDO"  )),  TRANSFORM( SD7->D7_SALDO,  '@E 999,999,999.99' ))
			AADD( (oHtml:ValByName( "it.STATUS" )),  _cStatus)
			AADD( (oHtml:ValByName( "it.COR"    )),  _cCor)

			SD7->(dbSkip())
		EndDo

		Private _cTo := _cCC := ""

		SZG->(dbsetOrder(1))
		SZG->(dbGotop())

		While SZG->(!EOF())

			If 'M1' $ SZG->ZG_ROTINA
				_cTo += If(Empty(_cTo),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
			ElseIf 'M2' $ SZG->ZG_ROTINA
				_cCC += If(Empty(_cCC),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
			Endif

			SZG->(dbSkip())
		Enddo

		oProcess:cTo := _cTo
		oProcess:cCC := _cCC

		oProcess:Start()

		oProcess:Finish()

		ConOut("Fim E-Mail Retorno do CQ:")

	EndIf

Return(Nil)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT250TOK   บ Autor ณ Fabiano da Silva บ Data ณ   01/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de Entrda Para Lan็amento de Produ็ใo SD3            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SigaEST                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
/*
User Function MT250TOK()


	_aAliori := GetArea()
	_aAliSD3 := SD3->(GetArea())
	_aAliSZ6 := SZ6->(GetArea())
	_aAliSZA := SZA->(GetArea())
	_cRet := .T.

	If M->D3_LOCAL $ "98"
		If Empty(M->D3_YOPERAC) .Or. Empty(M->D3_YOPPREN)
			Alert("Campo Operador de Prensa ou Operador de Acabamento em Branco")
			_cRet := .F.
		Endif
	ElseIf M->D3_LOCAL == "45" //.Or. M->D3_LOCAL == "25"
		If M->D3_COD = "YPRODU"
			If (Empty(M->D3_RECURSO) .Or. Empty(M->D3_YOCORR) .Or.;
					(M->D3_YHORINI = 0 .And. M->D3_YHORFIN = 0))
				Alert("Campo - PRENSA / OCORRENCIA / INICIO / FIM - em Branco")
				_cRet := .F.
			ElseIf !Empty(M->D3_OP)
				Alert("Campo - OP nใo pode ser preenchido para o produto YPRODU")
				_cRet := .F.
			Endif
		Else
			If (Empty(M->D3_YRECURS) .Or. Empty(M->D3_YTURNO) .Or. Empty(M->D3_YNUMCAV) .Or.;
					M->D3_YCICLO = 0) .And. (M->D3_YHREXIN = 0 .And. M->D3_YHREXFI = 0)
				Alert("Campo - PRENSA / TURNO / NR CAVIDADE / CICLO - em Branco")
				_cRet := .F.
			ElseIf !Empty(M->D3_YTURNO) .And. M->D3_YHREXIN != 0 .And. M->D3_YHREXFI != 0
				Alert("Para inclusao de Hora Extra nao e necessario colocar o Turno")
				_cRet := .F.
			ElseIf (Empty(M->D3_YRECURS) .Or. Empty(M->D3_YNUMCAV) .Or.;
					M->D3_YCICLO = 0) .And. (M->D3_YHREXIN != 0 .And. M->D3_YHREXFI != 0) .And. Empty(M->D3_YTURNO)
				Alert("Campo - PRENSA / NR CAVIDADE / CICLO - em Branco")
				_cRet := .F.
			ElseIf Empty(M->D3_YOPPREN)
				If !M->D3_YOCORR $ "010   /011   "
					Alert("Campo - OPERADOR DE PRENSA - em Branco")
					_cRet := .F.
				Endif
			Endif
		Endif
	Endif

	dbSelectArea("SZ6")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ6")+M->D3_YOPPREN)
		//	If SZ6->Z6_ATIVO = "2"
		//		Alert("Cadastro de Prensista Inativo")
		//		_cRet := .F.
		//	Endif
	Endif

	dbSelectArea("SZA")
	dbSetOrder(1)
	If dbSeek(xFilial("SZA")+M->D3_YTURNO)
		If SZA->ZA_ATIVO = "2"
			Alert("Cadastro de Turno Inativo")
			_cRet := .F.
		Endif
	Endif

	//If Len(M->D3_YNUMCAV) != 3
	//	Alert("Numero de Cavidades deve conter 03 digitos")
	//	_cRet := .F.
	//Endif

	RestArea(_aAliSZA)
	RestArea(_aAliSZ6)
	RestArea(_aAliSD3)
	RestArea(_aAliOri)

Return(_cRet)
*

/*
User Function M250BUT()

	Local _nOpc     := PARAMIXB[1]
	Local _aButtons := {}

	If _nOpc == 3 // Inclui botao somente se for inclusao

		Aadd( _aButtons, {"DBG09", {|| U_CR0099()}, "Ocorrencias", "Ocorrencias" , {|| .T.}} )

		Set Key VK_F5 TO U_CR0099()
	EndIf

Return(_aButtons)
*/


User Function MT241TOK()

	Local _lRet 	:= .T.
	Local _aAliori 	:= GetArea()
	Local _aAliSD3 	:= SD3->(GetArea())
	Local _nPEnd	:= aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "D3_LOCALIZ" } )
	Local _nPLocal	:= aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "D3_LOCAL" } )

	For _nFor := 1 to Len(aCols)
		If !Empty(aCols[_nFor][_nPEnd])
			SBE->(dbSetOrder(1))
			If !SBE->(msSeek(xFilial("SBE")+aCols[_nFor][_nPLocal]+aCols[_nFor][_nPEnd]))
				_lRet := .F.
				ShowHelpDlg("MT241TOK", {'A localiza็ใo "'+Alltrim(aCols[_nFor][_nPEnd])+'" nใo existe no cadastro de endere็o!'},2,{'Digite um endere็o existente.'},2)
			Endif
		Endif
	Next _nFor

	RestArea(_aAliSD3)
	RestArea(_aAliOri)

Return(_lRet)