#INCLUDE "PROTHEUS.CH"
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
AADD(_aRot,{"Lote Composto"	,"U_LOTEPROD()"	,0,2,0,NIL})
AADD(_aRot,{"Etiqueta"		,"U_PA0229()" 	,0,2,0,NIL})

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

