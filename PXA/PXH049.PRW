
#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PXH049    ³ Autor ³ Microsiga           ³ Data ³13/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ ORDEM DE CARREGAMENTO - FORMATO GRAFICO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function PXH049(p_cOrigem, p_cnumOC)

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Ordem de Carregamento"
Local cPict          := ""
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd := {}
Local I

Private titulo       := "Ordem de Carregamento"
Private wnPag 		 :=0
Private wnLin
Private oPrint
Private nLinha 		 := 0
Private nSalto 		 := 55
Private cPerg  		 := PADR("PXH049",10)
Private cMes
Private _numOC := iif(p_cnumOC==nil,'',p_cnumOC)

//Colunas
Private lPosCol1 := 100
Private lPosCol2 := lPosCol1+180
Private lPosCol3 := lPosCol2+800
Private lPosCol4 := lPosCol3+100
Private lPosCol5 := lPosCol4+200
Private lPosCol6 := lPosCol5+200
Private lPosCol7 := lPosCol6+200
Private lPosCol8 := lPosCol7+200
Private lPosCol9 := lPosCol8+300
Private lPosCol10 := lPosCol9+300
Private lPosCol11 := lPosCol10+300
Private lPosCol12 := lPosCol11+300

//LINHA INICIAL
Private nRow1 := 050

//LINHA VERTICAL
Private nLeft   := 050        // Margem esquerda
Private nTopo   := 050       // Linha do Topo

//Retrato A4
Private lLimV := 3000
Private lLimH := 2300

IF  p_cOrigem==nil
	if Alltrim(funname()) == "#MIZ023" .or. Alltrim(funname()) == "MIZ023" .or. Alltrim(funname()) == "PXH045" .or. Alltrim(funname()) == "MIZ999"
		Private aenvio := Paramixb
		_placa  := aenvio[1]
		_motor  := aenvio[2]
		_peso   := aenvio[3]
		cctr    := aenvio[4]
		npedagio:= aenvio[5]
		cfornece:= aenvio[6]
		_numOC  := aenvio[7]
		cpm     := aenvio[8]
		plcar   := aenvio[9]
		cLojaF  := aenvio[10]
	endif
Endif

IF  Alltrim(funname()) == "#MIZ023" .or. Alltrim(funname()) == "MIZ023"
	
	While !RecLock("SZE",.T.);EndDo
	SZE->ZE_FILIAL  := xFilial("SZE")
	SZE->ZE_OC      := _numOC
	SZE->ZE_PLACA   := _placa
	SZE->ZE_MOTOR   := _motor
	SZE->ZE_PLCAR   := plcar
	SZE->ZE_DATA    := ddatabase
	SZE->ZE_HORA    := Left(Time(),5)
	SZE->ZE_USUARIO := cUsername
	SZE->ZE_PSENT   := _peso
	SZE->ZE_CTR     := cctr
	SZE->ZE_PEDAGIO := npedagio
	SZE->ZE_TRANSP  := cfornece
	SZE->ZE_PALLET  := cpm
	SZE->ZE_HORPES  := Left(Time(),5)
	MsUnlock()
	
	DbSelectArea("SZF")
	nordem := IndexOrd()
	DbSetOrder(0)
	DbGotop()
	While SZF->(!Eof())
		If Marked("ZF_OK")
			Reclock ("SZF",.F.)
			SZF->ZF_OC       := _numOC
			msUnlock()
			dbCommit()
			
			SC6->(dbSetorder(1))
			If SC6->(dbSeek(xFilial("SC6")+SZF->ZF_NUM))
				SC6->(RecLock("SC6",.F.))
				SC6->C6_YOC      := _numOC
				SC6->(MsUnlock())
			Endif
		EndIf
		
		SZF->(dbSkip())
	EndDo
	
	DbSelectArea("SZF")
	DbSetOrder(nordem)
	DbGotop()
Endif

If !Empty(_numOC)
	dbSelectArea("SX1")
	dbSetOrder(1)
	If  dbSeek(cPerg+"01")
		While ! RecLock("SX1",.F.) ; End
		SX1->X1_CNT01 := _numOC
		msUnlock()
		dbCommit()
	Endif
Endif

ValPerg(cperg)
if ( p_cOrigem==nil .and. (Alltrim(funname()) $ "PXH045%MIZ999") ) .or. !empty(_numOC)
	Pergunte(cPerg,    .f.   )
else
	If !Pergunte(cPerg,    .t.   )
		Return
	EndIf
endif


Private cOrdem := iif( !empty(_numOC) , _numOC, mv_par01 )    					//NUMERO DA ORDEM DE CARREGAMENTO
Private nVias  := Iif(mv_par02>0,mv_par02,1)    //NUMERO DE VIAS
Private nTamVia := 1500

Processa({|| RptDetail()})
Return

Static Function RptDetail()

oPrint:= TMSPrinter():New(Titulo)
oPrint:SetPortrait()

//Definicao das fontes
IF MV_PAR03 == 1
	oFont1 := TFont():New("Arial"  ,10,09,.T.,.F.,5,.T.,5,.T.,.F.) // Courier 09 Plain
	oFont2 := TFont():New("Arial"  ,10,09,.T.,.T.,5,.T.,5,.T.,.F.) // Courier 09 Bold
	oFont3 := TFont():New("Arial"  ,09,11,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   09 Bold
	oFont4 := TFont():New("Arial"  ,09,09,.T.,.F.,5,.T.,5,.T.,.F.) // Arial   09 Plain
	oFont5 := TFont():New("Arial"  ,16,16,.T.,.F.,5,.T.,5,.T.,.F.) // Arial   16 Plain
	oFont6 := TFont():New("Arial"  ,16,16,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   16 Bold
	oFont7 := TFont():New("Arial"  ,14,14,.T.,.F.,5,.T.,5,.T.,.F.) // Arial   14 Plain
	oFont8 := TFont():New("Arial"  ,14,14,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   14 Bold
	oFont10 := TFont():New("Arial" ,110,110,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   25 Bold
ELSEIF MV_PAR03 == 2
	oFont1 := TFont():New("Arial"  ,10,09,.T.,.F.,5,.T.,5,.T.,.F.) // Courier 09 Plain
	oFont2 := TFont():New("Arial"  ,10,09,.T.,.T.,5,.T.,5,.T.,.F.) // Courier 09 Bold
	oFont3 := TFont():New("Arial"  ,09,11,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   09 Bold
	oFont4 := TFont():New("Arial"  ,09,09,.T.,.F.,5,.T.,5,.T.,.F.) // Arial   09 Plain
	oFont5 := TFont():New("Arial"  ,16,16,.T.,.F.,5,.T.,5,.T.,.F.) // Arial   16 Plain
	oFont6 := TFont():New("Arial"  ,16,16,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   16 Bold
	oFont7 := TFont():New("Arial"  ,10,10,.T.,.F.,5,.T.,5,.T.,.F.) // Arial   14 Plain
	oFont8 := TFont():New("Arial"  ,10,10,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   14 Bold
	oFont10 := TFont():New("Arial" ,110,110,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   25 Bold
ENDIF

nLinhaT := 2900   //A4 - retrato
//nLinhaT := 2300   //A4 - paisagem

fImpDet()

oPrint:Preview()

Return

Static Function fImpCabec(nAVert)

Default nAVert := 0

If nAVert == 0
	oPrint:StartPage()
	wnPag ++
	wnLin := 1
EndIf

//Linha vertical esquerda
oPrint:Line (nTopo+nAVert, nLeft,  nTopo+nAVert+nTamVia  , nLeft)//(linha, coluna, linha, coluna)
//Linha vertical direita
oPrint:Line (nTopo+nAVert, nLeft+lLimH,  nTopo+nAVert+nTamVia  , nLeft+lLimH)
//Linha horizontal do topo
oPrint:Line (nRow1+nAVert, nLeft, nRow1+nAVert, nLeft+lLimH)
//Linha horizontal da base
oPrint:Line (nRow1+nAVert+nTamVia,  nLeft, nRow1+nAVert+nTamVia, nLeft+lLimH)

//Posicao da Primeira Linha de Dados
nLinha+=nSalto

Return


/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Funcao: fImpDet                                             		       ±±
±± Descricao: Funcao que imprime os dados do relatorio.                    ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function fImpDet()

Local ctransp
Local carq
Local cLogChar
Local aDados := {}
Local aTotal := {}
Local nPSENT,nPALENT,nPALSAI
Local _LACRE
Local I, nCont
Local aObs 	:= {}
Local nItens := 0

SZE->(dbSetOrder(1))
SZE->(dbSeek(xFilial("SZE") + cOrdem))

DA4->(dbSetOrder(1))
DA4->(dbSeek(xfilial("DA4") + SZE->ZE_MOTOR ))

SM0->(DbSetOrder(1))
SM0->(DbSeek(cEmpAnt+cFilAnt))

SC6->(dbOrderNickName("INDSC61"))
If !SC6->(dbSeek(xfilial("SC6") + cOrdem))
	//SZ7->(dbSetOrder(8))
	//SZ7->(dbSeek(xfilial("SZ7") + cordem))
	
	//While !SZ7->(Eof()) .and. SZ7->Z7_OC == cordem
	//	nItens++
	//	SZ7->(DbSkip())
	//EndDo
	//SZ7->(dbSeek(xfilial("SZ7") + cordem))
	
	//ctransp := SZ7->Z7_FORNECE+SZ7->Z7_LOJAF
	carq := 2
Else
	ctransp := SC6->C6_YTRANSP
	carq    := 1
	
	While !SZF->(Eof()) .and. SZF->ZF_OC == cordem
		nItens++
		SZF->(DbSkip())
	EndDo
	SZF->(dbSeek(xFilial("SZF") + cordem))
EndIf

SA4->(dbSetOrder(1))
SA4->(dbSeek(xFilial("SA4")+cTransp))

cLogChar := Alltrim(SZF->ZF_YPM)

//Impressao de mais de uma via
nPosV2 := 0

//Aumentar tamanho da Via quando mais de 5 itens
If nItens > 5
	nTamVia := 1500 + (80*(nItens-5))
EndIf

fImpCabec()

FOR nCont := 1 To nVias
	
	If nCont == 2
		//LIMITE PARA 5 ITENS PARA IMPRIMIR DUAS VIAS EM UMA PAGINA
		If nItens <= 5
			nPosV2 := 1550
			fImpCabec(nPosV2)
			nLinha := 0 + nSalto + nPosV2
			//oPrint:Line (nRow1+nPosV2, nLeft, nRow1+nPosV2 , nLeft+lLimH)
		Else
			oPrint:EndPage()
			nPosV2 := 0
			fImpCabec()
			nLinha := 0 + nSalto + nPosV2
		EndIf
	EndIf
	
	//Confirma Posicionamento dos arquivos
	SC6->(dbOrderNickName("INDSC61"))
	If !SC6->(dbSeek(xFilial("SC6") + cordem))
		//SZ7->(dbSetOrder(8))
		//SZ7->(dbSeek(xfilial("SZ7") + cordem))
	EndIf
	
	//IMPRESSAO DO CODIGO DE BARRAS
	oPrint:Box(nRow1+nPosV2+20,1600,nRow1+nPosV2+300,1980)
	If nCont == 2 .And. nItens <= 5
		MSBAR("CODE128",14.3,14.3,cOrdem,oPrint,.F.,Nil,Nil,0.025,2.0,Nil,Nil,"A",.F.)
	Else
		MSBAR("CODE128",1.2,14.3,cOrdem,oPrint,.F.,Nil,Nil,0.025,2.0,Nil,Nil,"A",.F.)
	EndIf
	
	//IMPRESSAO DO CARACTERE IDENTIFICADOR
	oPrint:Line (nRow1+nPosV2, 2000, nRow1+nPosV2+(8*nSalto) , 2000)
	oPrint:Line (nRow1+nPosV2+(8*nSalto), nLeft, nRow1+nPosV2+(8*nSalto) , nLeft+lLimH)
	IF MV_PAR03 == 1
		oPrint:Say  (nRow1+nPosV2 ,2030 ,cLogChar,oFont10)
	ELSE
		oPrint:Say  (nRow1+nPosV2-50 ,2030-30 ,cLogChar,oFont10)
	ENDIF
	
	//IMPRESSAO DOS DADOS DO CABECALHO
	oPrint:Say  (nLinha ,nLeft+10 ,alltrim(SM0->M0_NOMECOM),oFont6)
	oPrint:Say  (nLinha ,nLeft+300 ,"ORDEM DE CARREGAMENTO No "+cordem,oFont6)
	nLinha += nSalto
	oPrint:Say  (nLinha ,nLeft+300 ,"Data: " + DTOC(SZE->ZE_DATA),oFont5)
	oPrint:Say  (nLinha ,nLeft+700 ,"Hora: " + SZE->ZE_HORA  ,oFont5)
	nLinha += nSalto
	nLinha += nSalto
	
	oPrint:Say  (nLinha ,nLeft+10 ,"O motorista, Sr. "+Alltrim(DA4->DA4_NOME)+" - Cod. "+DA4->DA4_COD  ,oFont7)
	nLinha += nSalto
	oPrint:Say  (nLinha ,nLeft+10 ,"Transp. " + SA4->A4_COD + "-"+ Left(SA4->A4_NOME,20) ,oFont7)
	nLinha += nSalto
	oPrint:Say  (nLinha ,nLeft+10 ,"está autorizado a carregar no veículo de placa: "+SZE->ZE_PLACA+" - Renavam: "+DA3->DA3_RENAVA ,oFont7)
	nLinha += nSalto
	oPrint:Say  (nLinha ,nLeft+10 ,"conforme abaixo especificado:" ,oFont7)
	nLinha += nSalto
	nLinha += nSalto
	
	//DADOS DOS PESOS
	
	nPSENT 	:= SC6->C6_YPSENT
	nPALENT := SC6->C6_YPALENT
	nPALSAI := SC6->C6_YPALSAI
	
	oPrint:Say  (nLinha ,nLeft+10 ,"Peso Entrada : " + trans(nPSENT,"@E 9,999,999.99")  ,oFont7)
	oPrint:Line (nLinha-5, nLeft+10+600, nLinha+nSalto , nLeft+10+600)
	oPrint:Say  (nLinha ,nLeft+10+610 ,"Pallets Entrada: "+trans(nPALENT,"99")  ,oFont7)
	oPrint:Line (nLinha-5, nLeft+10+1000, nLinha+nSalto , nLeft+10+1000)
	oPrint:Say  (nLinha ,nLeft+10+1010 ,"Pallets Saida: "+trans(nPALSAI,"99")  ,oFont7)
	oPrint:Line (nLinha-5, nLeft+10+1400, nLinha+nSalto , nLeft+10+1400)
	nLinha += nSalto
	oPrint:Line (nLinha, nLeft, nLinha , nLeft+lLimH)
	nLinha += nSalto
	
	//IMPRESSAO DAS LINHAS DA OC
	//CABECALHO
	oPrint:Line (nLinha, nLeft, nLinha , nLeft+lLimH)
	
	nCol1 := nLeft+10
	nCol2 := nLeft+180
	nCol3 := nLeft+400
	nCol4 := nLeft+500
	nCol5 := nLeft+1200
	nCol6 := nLeft+2000
	
	oPrint:Say  (nLinha ,nCol1+10 ,"Pedido" ,oFont8)
	oPrint:Line (nLinha, nCol2, nLinha+nSalto , nCol2)
	oPrint:Say  (nLinha ,nCol2+10 ,"Qtde" ,oFont8)
	oPrint:Line (nLinha, nCol3, nLinha+nSalto , nCol3)
	oPrint:Say  (nLinha ,nCol3+10 ,"UN" ,oFont8)
	oPrint:Line (nLinha, nCol4, nLinha+nSalto , nCol4)
	oPrint:Say  (nLinha ,nCol4+10 ,"Especificacao" ,oFont8)
	oPrint:Line (nLinha, nCol5, nLinha+nSalto , nCol5)
	oPrint:Say  (nLinha ,nCol5+10 ,"Cliente" ,oFont8)
	oPrint:Line (nLinha, nCol6, nLinha+nSalto , nCol6)
	oPrint:Say  (nLinha ,nCol6+10 ,"Frete" ,oFont8)
	nLinha += nSalto
	oPrint:Line (nLinha, nLeft, nLinha , nLeft+lLimH)
	
	//PROCESSAMENTO DOS DADOS
	IF nCont == 1
		
		While !Eof() .and. SC6->C6_YOC == cordem
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xfilial("SB1") + SZF->ZF_PRODUTO))
			
			aAux := {}
			AAdd(aAux,SC6->C6_NUM)
			AAdd(aAux,SC6->C6_QTDVEN)
			AAdd(aAux,SC6->C6_UNID)
			AAdd(aAux,SUBSTR(SB1->B1_DESC,1,25))
			AAdd(aAux,SUBSTR(SC6->C6_XNOMCLI,1,30))
			AAdd(aAux,SC6->C6_YFMOT)
			AAdd(aDados,aAux)
			
			nPos := AScan(aTotal,{|x| x[1] == SC6->C6_PRODUTO})
			IF nPos <= 0
				AAdd(aTotal,{SC6->C6_PRODUTO,SB1->B1_DESC,SC6->C6_QTDVEN,SC6->C6_YFMOT})
			ELSE
				aTotal[nPos][3] += SC6->C6_QTDVEN
				aTotal[nPos][4] += SC6->C6_YFMOT
			ENDIF
			
			If .Not. Empty(SC6->C6_YOBSER)
				Aadd(aObs, SC6->C6_YOBSER)
			EndIf
			
			_LACRE := SC6->C6_YLACRE
			
			SC6->(DbSkip())
		EndDo
		
	ENDIF
	
	//IMPRESSAO DOS PEDIDOS
	FOR I := 1 To Len(aDados)
		
		oPrint:Say  (nLinha ,nCol1+10 , aDados[I][1] ,oFont7)
		oPrint:Line (nLinha, nCol2    , nLinha+nSalto , nCol2)
		oPrint:Say  (nLinha ,nCol2+10 , Transform(aDados[I][2],"@E 9999999.99") ,oFont7)
		oPrint:Line (nLinha, nCol3    , nLinha+nSalto , nCol3)
		oPrint:Say  (nLinha ,nCol3+10 , aDados[I][3] ,oFont7)
		oPrint:Line (nLinha, nCol4    , nLinha+nSalto , nCol4)
		oPrint:Say  (nLinha ,nCol4+10 , aDados[I][4] ,oFont7)
		oPrint:Line (nLinha, nCol5    , nLinha+nSalto , nCol5)
		oPrint:Say  (nLinha ,nCol5+10 , aDados[I][5] ,oFont7)
		oPrint:Line (nLinha, nCol6    , nLinha+nSalto , nCol6)
		oPrint:Say  (nLinha ,nCol6+10 , Transform(aDados[I][6],"@E 999,999,999.99") ,oFont7)
		nLinha += nSalto
		oPrint:Line (nLinha, nLeft, nLinha , nLeft+lLimH)
		
	NEXT I
	
	nLinha += nSalto
	FOR I := 1 To Len(aTotal)
		oPrint:Say  (nLinha ,nCol1+10 ,"Total do "+AllTrim(aTotal[I][2])+": "+Transform(aTotal[I][3],"@E 9999999.99") ,oFont8)
		nLinha += nSalto
		oPrint:Line (nLinha, nLeft, nLinha , nLeft+lLimH)
	NEXT I
	
	IF SZE->ZE_PALLET == "G"
		nLinha += nSalto
		oPrint:Say  (nLinha ,nCol1+10 ,"No dos Lacres: "+Alltrim(_LACRE) ,oFont8)
		nLinha += nSalto
	ENDIF
	
	nLinha += nSalto
	oPrint:Line (nLinha, nLeft, nLinha , nLeft+lLimH)
	oPrint:Say  (nLinha ,nCol1+10 ,"Observacao:" ,oFont8)
	nLinha += nSalto
	For I := 1 to Len(aObs)
		oPrint:Say  (nLinha ,nCol1+10 ,aObs[I] ,oFont8)
		nLinha += nSalto
	Next I
	
	nColQ1 := nLeft+10
	nColQ2 := nLeft+500
	nColQ3 := nLeft+1000
	
	oPrint:Line (nLinha, nLeft, nLinha , nLeft+lLimH)
	oPrint:Say  (nLinha ,nColQ1+10 , "Autorizado" ,oFont7)
	oPrint:Line (nLinha, nColQ2, nLinha+nSalto , nColQ2)
	oPrint:Say  (nLinha ,nColQ2+10 , "Despachado" ,oFont7)
	oPrint:Line (nLinha, nColQ3, nLinha+nSalto , nColQ3)
	oPrint:Say  (nLinha ,nColQ3+10 , "Recebido" ,oFont7)
	nLinha += nSalto
	oPrint:Line (nLinha, nColQ2, nLinha+nSalto , nColQ2)
	oPrint:Line (nLinha, nColQ3, nLinha+nSalto , nColQ3)
	nLinha += nSalto
	oPrint:Line (nLinha, nColQ2, nLinha+nSalto , nColQ2)
	oPrint:Line (nLinha, nColQ3, nLinha+nSalto , nColQ3)
	nLinha += nSalto
	oPrint:Line (nLinha, nLeft, nLinha , nLeft+lLimH)
	nLinha += nSalto
	oPrint:Say  (nLinha ,nColQ1+10 , "Eu, "+ Alltrim(DA4->DA4_NOME)+", Acompanhei todo o carregamento. __________________________________________" ,oFont7)
	
NEXT nCont

Return

Static Function ValPerg(cperg)

aRegs :={}
aAdd(aRegs,{cPerg,"01","Ordem Inicial?		","","","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Numero Vias?       	","","","mv_ch2","N",1,0,0,"C","","mv_par02","Uma","","","","","Duas","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Mod.Impressora?    	","","","mv_ch2","N",1,0,0,"C","","mv_par03","Modelo 1","","","","","Modelo 2","","","","","","","","","","","","","","","","","","","",""})

dbSelectArea("SX1")
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

Return