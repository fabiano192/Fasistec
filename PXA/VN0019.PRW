#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} VN0019
IMPRESSÃO ORDEM DE CARREGAMENTO - FORMATO GRAFICO
@type function
@author Fabiano
@since 06/09/2016
@version 1.0
@param _cOrigem, ${param_type}, (Descrição do parâmetro)
@param _cNumOC, ${param_type}, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function VN0019(_cXNumOC)
	
	Private _cTitulo	:= "Ordem de Carregamento"
	Private _nPag		:=0
	Private _nLin
	Private _oPrint
	Private _nLine		:= 0
	Private _nJump		:= 55
	Private _cPerg		:= PADR("VN0019",10)
	Private _cNumOC		:= If(_cXNumOC==Nil,'',_cXNumOC)
	
	//Colunas
	Private _nPosCol1  := 100
	Private _nPosCol2  := _nPosCol1+180
	Private _nPosCol3  := _nPosCol2+800
	Private _nPosCol4  := _nPosCol3+100
	Private _nPosCol5  := _nPosCol4+200
	Private _nPosCol6  := _nPosCol5+200
	Private _nPosCol7  := _nPosCol6+200
	Private _nPosCol8  := _nPosCol7+200
	Private _nPosCol9  := _nPosCol8+300
	Private _nPosCol10 := _nPosCol9+300
	Private _nPosCol11 := _nPosCol10+300
	Private _nPosCol12 := _nPosCol11+300
	
	//LINHA INICIAL
	Private _nRow1 := 050
	//	Private _nRow1 := 050
	
	//LINHA VERTICAL
	Private _nLeft   := 050        // Margem esquerda
	Private _nTopo   := 050       // Linha do Topo
	
	//Retrato A4
	Private _nLimH := 2300
	
	IF _cXNumOC == Nil
		/*
		Private aenvio := Paramixb
		_placa  := aenvio[1]
		_motor  := aenvio[2]
		_peso   := aenvio[3]
		cctr    := aenvio[4]
		npedagio:= aenvio[5]
		cfornece:= aenvio[6]
		_cNumOC  := aenvio[7]
		cpm     := aenvio[8]
		plcar   := aenvio[9]
		cLojaF  := aenvio[10]
		*/
		//Criacao e exibicao da pergunta SX1
		ValPerg(_cPerg)
		
		Pergunte(_cPerg,.T.)
	Else
		MV_PAR01 := _cNumOC
		MV_PAR02 := 1
		MV_PAR03 := 1
	Endif
	
	//CONFIGURACOES DO RELATORIO
	Processa({|| VN019PROCESS()})
	
Return



Static Function VN019PROCESS()
	
	//ESPECIFICOS
	Private _cOrdem := If( !Empty(_cNumOC) , _cNumOC, MV_PAR01 )	//NUMERO DA ORDEM DE CARREGAMENTO
	Private _nVias  := If(MV_PAR02>0,MV_PAR02,1)					//NUMERO DE VIAS
	Private _nTamVia := 1400
	
	_oPrint:= FWMsPrinter():New(_cTitulo+'_'+Alltrim(MV_PAR01),6,.T., ,.T., , , , ,.F., , .T., )
	
	_oPrint:SetPortrait()
	
	//Definicao das fontes
	IF MV_PAR03 == 1
		_oFont1  := TFont():New("Arial"  ,10,09,.T.,.F.,5,.T.,5,.T.,.F.) // Courier 09 Plain
		_oFont2  := TFont():New("Arial"  ,10,09,.T.,.T.,5,.T.,5,.T.,.F.) // Courier 09 Bold
		_oFont3  := TFont():New("Arial"  ,09,11,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   09 Bold
		_oFont4  := TFont():New("Arial"  ,09,09,.T.,.F.,5,.T.,5,.T.,.F.) // Arial   09 Plain
		_oFont5  := TFont():New("Arial"  ,16,16,.T.,.F.,5,.T.,5,.T.,.F.) // Arial   16 Plain
		_oFont6  := TFont():New("Arial"  ,16,16,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   16 Bold
		_oFont7  := TFont():New("Arial"  ,14,14,.T.,.F.,5,.T.,5,.T.,.F.) // Arial   14 Plain
		_oFont8  := TFont():New("Arial"  ,14,14,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   14 Bold
		_oFont10 := TFont():New("Arial" ,110,110,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   25 Bold
		_oFont11 := TFont():New("Arial"  ,20,20,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   28 Bold
	ELSEIF MV_PAR03 == 2
		_oFont1  := TFont():New("Arial"  ,10,09,.T.,.F.,5,.T.,5,.T.,.F.) // Courier 09 Plain
		_oFont2  := TFont():New("Arial"  ,10,09,.T.,.T.,5,.T.,5,.T.,.F.) // Courier 09 Bold
		_oFont3  := TFont():New("Arial"  ,09,11,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   09 Bold
		_oFont4  := TFont():New("Arial"  ,09,09,.T.,.F.,5,.T.,5,.T.,.F.) // Arial   09 Plain
		_oFont5  := TFont():New("Arial"  ,16,16,.T.,.F.,5,.T.,5,.T.,.F.) // Arial   16 Plain
		_oFont6  := TFont():New("Arial"  ,16,16,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   16 Bold
		_oFont7  := TFont():New("Arial"  ,10,10,.T.,.F.,5,.T.,5,.T.,.F.) // Arial   14 Plain
		_oFont8  := TFont():New("Arial"  ,10,10,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   14 Bold
		_oFont10 := TFont():New("Arial"  ,110,110,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   25 Bold
		_oFont11 := TFont():New("Arial"  ,20,20,.T.,.T.,5,.T.,5,.T.,.F.) // Arial   28 Bold
	ENDIF
	
	_nLineT := 2900   //A4 - retrato
	
	fImpDet()
	
	_oPrint:Preview()
	
Return



/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Funcao: fImpCabec                                             		   ±±
±± Descricao: Funcao que imprime o cabecalho do relatorio  na primeira     ±±
±± folha e quando tiver mais de uma folha.                                 ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function fImpCabec(_nAVert)
	
	Default _nAVert := 0
	
	If _nAVert == 0
		_oPrint:StartPage()
		_nPag ++
		_nLin := 1
	EndIf
	
	//Linha vertical esquerda
	_oPrint:Line (_nTopo+_nAVert, _nLeft,  _nTopo+_nAVert+_nTamVia  , _nLeft)//(linha, coluna, linha, coluna)
	//Linha vertical direita
	_oPrint:Line (_nTopo+_nAVert, _nLeft+_nLimH,  _nTopo+_nAVert+_nTamVia  , _nLeft+_nLimH)
	//Linha horizontal do topo
	_oPrint:Line (_nRow1+_nAVert, _nLeft, _nRow1+_nAVert, _nLeft+_nLimH)
	//Linha horizontal da base
	_oPrint:Line (_nRow1+_nAVert+_nTamVia,  _nLeft, _nRow1+_nAVert+_nTamVia, _nLeft+_nLimH)
	
	//Posicao da Primeira Linha de Dados
	_nLine+=_nJump
	
Return



/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Funcao: fImpDet                                             		       ±±
±± Descricao: Funcao que imprime os dados do relatorio.                    ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function fImpDet()
	
	Local _cTransp
	Local _cArq
	Local _cLogChar
	Local _aDados 	:= {}
	Local _aTotal 	:= {}
	Local _aObs 	:= {}
	Local _nPsEnt,_nPalEnt,_nPalSai,_cComDesc
	Local _cLacre
	Local I, _nCont
	Local _nItens	:= 0
	
	//POSICIONA ORDEM DE CARREGAMENTO
	SZK->(dbSetOrder(1))
	If SZK->(msSeek(xfilial("SZK") + _cOrdem))
		
		SC6->(dbSetOrder(1))
		If SC6->(msSeek(xFilial("SC6")+SZK->ZK_NUMPV+SZK->ZK_ITEMPV))
			
			SC5->(dbSetOrder(1))
			If SC5->(msSeek(xFilial("SC5") + SC6->C6_NUM))
				
				_cTransp := SC5->C5_TRANSP
				_cArq 	:= 2
				
				//POSICIONA TRANSPORTADORA
				SA4->(DbSetOrder(1))
				SA4->(msSeek(xFilial("SA4")+_cTransp))
				
				//VARIAVEIS DO ARQUIVO
				_cLogChar := ''//alltrim(SZ7->Z7_YPM)
				cAlias := "SC5"
				
				//Impressao de mais de uma via
				_nPosV2 := 0
				
				//Aumentar tamanho da Via quando mais de 5 itens
				If _nItens > 5
					_nTamVia := 1400 + (80*(_nItens-5))
				EndIf
				
				fImpCabec()
				
				FOR _nCont := 1 To _nVias
					
					If _nCont == 2
						//LIMITE PARA 5 ITENS PARA IMPRIMIR DUAS VIAS EM UMA PAGINA
						If _nItens <= 5
							_nPosV2 := 1450
							fImpCabec(_nPosV2)
							_nLine := 0 + _nJump + _nPosV2
						Else
							_oPrint:EndPage()
							_nPosV2 := 0
							fImpCabec()
							_nLine := 0 + _nJump + _nPosV2
						EndIf
					EndIf
					
					//IMPRESSAO DO CODIGO DE BARRAS
					_oPrint:Box(_nRow1+_nPosV2+20,1500+250,_nRow1+_nPosV2+300,1980+250)
//					_oPrint:Box(_nRow1+_nPosV2+20,1500,_nRow1+_nPosV2+300,1980)
					If _nCont == 2 .And. _nItens <= 5
						_oPrint:FWMSBAR("CODE128",36,37.3,_cOrdem,_oPrint,.F.,Nil,Nil,0.025,1.8,Nil,Nil,"A",.F.)
//						_oPrint:FWMSBAR("CODE128",36,32.3,_cOrdem,_oPrint,.F.,Nil,Nil,0.025,1.8,Nil,Nil,"A",.F.)
					Else
						_oPrint:FWMSBAR("CODE128",02,37.3,_cOrdem,_oPrint,.F.,Nil,Nil,0.025,1.8,Nil,Nil,"A",.F.)
//						_oPrint:FWMSBAR("CODE128",02,32.3,_cOrdem,_oPrint,.F.,Nil,Nil,0.025,1.8,Nil,Nil,"A",.F.)
					EndIf
					
					/*
					//IMPRESSAO DO CARACTERE IDENTIFICADOR
					_oPrint:Line (_nRow1+_nPosV2, 2000, _nRow1+_nPosV2+(8*_nJump) , 2000)
					IF MV_PAR03 == 1
						_oPrint:Say  (_nLine+300 ,2030 ,_cLogChar,_oFont10)
					ELSE
						_oPrint:Say  (_nLine+300 ,2000 ,_cLogChar,_oFont10)
					ENDIF
					*/
					
					_oPrint:Line (_nRow1+_nPosV2+(8*_nJump), _nLeft, _nRow1+_nPosV2+(8*_nJump) , _nLeft+_nLimH)

					//IMPRESSAO DOS DADOS DO CABECALHO
					_nLine += _nJump
					_oPrint:Say  (_nLine ,_nLeft+10 ,alltrim(SM0->M0_NOMECOM)+" - Ordem de Carregamento No "+_cOrdem,_oFont6)
					_nLine += _nJump
					_oPrint:Say  (_nLine ,_nLeft+300 ,"Data: " + dtoc(SZK->ZK_EMISSAO)		,_oFont5)
					_oPrint:Say  (_nLine ,_nLeft+700 ,"Hora: " + Left( Alltrim(Time()) , 5)	,_oFont5)
					//					_oPrint:Say  (_nLine ,_nLeft+700 ,"Hora: " + SZ8->Z8_HRAGENC  ,_oFont5)
					_nLine += _nJump
					_nLine += _nJump
					
					_oPrint:Say  (_nLine ,_nLeft+10 ,"O motorista, Sr. "+Alltrim(SC5->C5_YNOMMOT)+" - Cod. "+SC5->C5_YCODMOT  ,_oFont7)
//					If !Empty(SC5->C5_TRANSP)
						_nLine += _nJump
						_oPrint:Say  (_nLine ,_nLeft+10 ,"Transportadora: " + SA4->A4_COD + "-"+ Left(SA4->A4_NOME,20) ,_oFont7)
//					Endif
					_nLine += _nJump
					_oPrint:Say  (_nLine ,_nLeft+10 ,"está autorizado a carregar no veículo de placa: "+SC5->C5_YPLACA ,_oFont7)
					//					_oPrint:Say  (_nLine ,_nLeft+10 ,"está autorizado a carregar no veículo de placa: "+SC5->C5_YPLACA+" - Renavam: "+SZ2->Z2_REN ,_oFont7)
					_nLine += _nJump
					_oPrint:Say  (_nLine ,_nLeft+10 ,"conforme abaixo especificado:" ,_oFont7)
					_nLine += _nJump
					
					//DADOS DOS PESOS
					_nPsEnt		:= SZK->ZK_PESOVEI
					_nPalEnt	:= 0//SZ7->Z7_PALENT
					_nPalSai	:= 0//SZ7->Z7_PALSAI
					_cComDesc	:= "N"//SZ1->Z1_COMDESC
					
					_oPrint:Say  (_nLine+40 ,_nLeft+10 ,"Peso Entrada : " + Trans(_nPsEnt,"@E 9,999,999.99")  ,_oFont7)
//					_oPrint:Line (_nLine-5, _nLeft+10+600, _nLine+_nJump , _nLeft+10+600)
//					_oPrint:Say  (_nLine+40 ,_nLeft+10+610 ,"Pallets Entrada: "+ Trans(_nPalEnt,"99")  ,_oFont7)
//					_oPrint:Line (_nLine-5, _nLeft+10+1000, _nLine+_nJump , _nLeft+10+1000)
//					_oPrint:Say  (_nLine+40 ,_nLeft+10+1010 ,"Pallets Saida: "+ Trans(_nPalSai,"99")  ,_oFont7)
					
					//Colocar quando for com descarga - sai um mensagem "COM DESCARGA"  - Juailson Semar - 18/03/2015
					If _cComDesc == "S"
						_oPrint:Say  (_nLine+40 ,_nLeft+10+1500 ,"COM DESCARGA",_oFont7)
					Endif
					
//					_oPrint:Line (_nLine-5, _nLeft+10+1400, _nLine+_nJump , _nLeft+10+1400)
					
					_nLine += _nJump
					_oPrint:Line (_nLine, _nLeft, _nLine , _nLeft+_nLimH)
					_nLine += _nJump
					
					//IMPRESSAO DAS LINHAS DA OC
					//CABECALHO
					_oPrint:Line (_nLine, _nLeft, _nLine , _nLeft+_nLimH)
					
					_nCol1 := _nLeft+10
					_nCol2 := _nLeft+180
					_nCol3 := _nLeft+400
					_nCol4 := _nLeft+500
					_nCol5 := _nLeft+1200
					_nCol6 := _nLeft+2000
					
					_oPrint:Say  (_nLine+40 ,_nCol1+10 ,"Pedido" ,_oFont8)
					_oPrint:Line (_nLine, _nCol2, _nLine+_nJump , _nCol2)
					_oPrint:Say  (_nLine+40 ,_nCol2+10 ,"Qtde" ,_oFont8)
					_oPrint:Line (_nLine, _nCol3, _nLine+_nJump , _nCol3)
					_oPrint:Say  (_nLine+40 ,_nCol3+10 ,"UN" ,_oFont8)
					_oPrint:Line (_nLine, _nCol4, _nLine+_nJump , _nCol4)
					_oPrint:Say  (_nLine+40 ,_nCol4+10 ,"Especificacao" ,_oFont8)
					_oPrint:Line (_nLine, _nCol5, _nLine+_nJump , _nCol5)
					_oPrint:Say  (_nLine+40 ,_nCol5+10 ,"Cliente" ,_oFont8)
//					_oPrint:Line (_nLine, _nCol6, _nLine+_nJump , _nCol6)
//					_oPrint:Say  (_nLine+40 ,_nCol6+10 ,"Frete" ,_oFont8)
					_nLine += _nJump
					_oPrint:Line (_nLine, _nLeft, _nLine , _nLeft+_nLimH)
					
					//PROCESSAMENTO DOS DADOS
					IF _nCont == 1
						
						//						While !Eof() .and. SZK->ZK_NUM == _cOrdem
						
						SB1->(dbSetOrder(1))
						SB1->(msSeek(xfilial("SB1") + SC6->C6_NUM))
						
						aAux := {}
						AAdd(aAux,SC6->C6_NUM)
						AAdd(aAux,If(SC6->C6_YQTORIG = 0, SC6->C6_QTDVEN,SC6->C6_YQTORIG))
						AAdd(aAux,SC6->C6_UM)
						AAdd(aAux,LEFT(SC6->C6_DESCRI,25))
						AAdd(aAux,LEFT(SA1->A1_NOME,50))
//						AAdd(aAux,SC5->C5_FRETE)
						//							AAdd(aAux,SC5->C5_YCODMOT)
						AAdd(_aDados,aAux)
						
						nPos := AScan(_aTotal,{|x| x[1] == SC6->C6_PRODUTO})
						IF nPos <= 0
							AAdd(_aTotal,{SC6->C6_PRODUTO,SC6->C6_DESCRI,If(SC6->C6_YQTORIG = 0, SC6->C6_QTDVEN,SC6->C6_YQTORIG),0})
						ELSE
							_aTotal[nPos][3] += If(SC6->C6_YQTORIG = 0, SC6->C6_QTDVEN,SC6->C6_YQTORIG)
							_aTotal[nPos][4] += 0
						ENDIF
						
						If !Empty(SC5->C5_MENNOTA)
							Aadd(_aObs, SC5->C5_MENNOTA)
						EndIf
						
						_cLacre := ''//SZ1->Z1_cLacre
						
						//							SC5->(DbSkip())
						//						EndDo
						
					ENDIF
					
					//IMPRESSAO DOS PEDIDOS
					FOR I := 1 To Len(_aDados)
						
						_oPrint:Say  (_nLine+40 ,_nCol1+10 ,_aDados[I][1] ,_oFont7)
						_oPrint:Line (_nLine, _nCol2, _nLine+_nJump , _nCol2)
						_oPrint:Say  (_nLine+40 ,_nCol2+10 ,Transform(_aDados[I][2],"@E 9999999.99") ,_oFont7)
						_oPrint:Line (_nLine, _nCol3, _nLine+_nJump , _nCol3)
						_oPrint:Say  (_nLine+40 ,_nCol3+10 ,_aDados[I][3] ,_oFont7)
						_oPrint:Line (_nLine, _nCol4, _nLine+_nJump , _nCol4)
						_oPrint:Say  (_nLine+40 ,_nCol4+10 ,_aDados[I][4] ,_oFont7)
						_oPrint:Line (_nLine, _nCol5, _nLine+_nJump , _nCol5)
						_oPrint:Say  (_nLine+40 ,_nCol5+10 ,_aDados[I][5] ,_oFont7)
//						_oPrint:Line (_nLine, _nCol6, _nLine+_nJump , _nCol6)
//						_oPrint:Say  (_nLine+40 ,_nCol6+10 ,Transform(_aDados[I][6],"@E 999,999,999.99") ,_oFont7)
						_nLine += _nJump
						_oPrint:Line (_nLine, _nLeft, _nLine , _nLeft+_nLimH)
						
					NEXT I
					
					
					FOR I := 1 To Len(_aTotal)
						_nLine += _nJump
						_oPrint:Say  (_nLine+20 ,_nCol1+1 ,"Total do "+AllTrim(_aTotal[I][2])+": "+Transform(_aTotal[I][3],"@E 9999999.99") ,_oFont11)
						_nLine += _nJump
						_oPrint:Line (_nLine, _nLeft, _nLine , _nLeft+_nLimH)
					NEXT I
					
					//					IF SZ8->Z8_PALLET == "G"
					//						_nLine += _nJump
					//						_oPrint:Say  (_nLine+40 ,_nCol1+10 ,"No dos Lacres: "+Alltrim(_cLacre) ,_oFont8)
					//						_nLine += _nJump
					//					ENDIF
					
					_nLine += _nJump
					_oPrint:Line (_nLine, _nLeft, _nLine , _nLeft+_nLimH)
					_oPrint:Say (_nLine-10 ,_nCol1+10 ,"Observacao:" ,_oFont8)
					_nLine += _nJump
					For I := 1 to Len(_aObs)
						_oPrint:Say  (_nLine ,_nCol1+10 ,_aObs[I] ,_oFont8)
						_nLine += _nJump
					Next I
					
					_nColQ1 := _nLeft+10
					_nColQ2 := _nLeft+500
					_nColQ3 := _nLeft+1000
					
					_oPrint:Line (_nLine, _nLeft, _nLine , _nLeft+_nLimH)
					_oPrint:Say  (_nLine+40 ,_nColQ1+10 , "Autorizado" ,_oFont7)
					_oPrint:Line (_nLine, _nColQ2, _nLine+_nJump , _nColQ2)
					_oPrint:Say  (_nLine+40 ,_nColQ2+10 , "Despachado" ,_oFont7)
					_oPrint:Line (_nLine, _nColQ3, _nLine+_nJump , _nColQ3)
					_oPrint:Say  (_nLine+40 ,_nColQ3+10 , "Recebido" ,_oFont7)
					_nLine += _nJump
					_oPrint:Line (_nLine, _nColQ2, _nLine+_nJump , _nColQ2)
					_oPrint:Line (_nLine, _nColQ3, _nLine+_nJump , _nColQ3)
					_nLine += _nJump
					_oPrint:Line (_nLine, _nColQ2, _nLine+_nJump , _nColQ2)
					_oPrint:Line (_nLine, _nColQ3, _nLine+_nJump , _nColQ3)
					_nLine += _nJump
					_oPrint:Line (_nLine, _nLeft, _nLine , _nLeft+_nLimH)
					_nLine += _nJump
					_oPrint:Say  (_nRow1+_nPosV2+_nTamVia-50 ,_nColQ1+10 , "Eu, "+ Alltrim(SC5->C5_YNOMMOT)+", acompanhei todo o carregamento. __________________________________________" ,_oFont7)
					
				NEXT _nCont
				
			Endif
			
		Endif
		
	Endif
	
Return


Static Function ValPerg(_cPerg)
	
	//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01           /Def01    	/defspa1/defeng1/Cnt01/Var02/Def02      /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(_cPerg,"01","Ordem Carregamento    ?",""       ,""      ,"mv_ch1","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR01",""        ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SZK")
	U_CRIASX1(_cPerg,"02","Numero Vias           ?",""       ,""      ,"mv_ch2","N" ,01     ,0      ,0     ,"C",""        ,"MV_PAR02","Uma"     ,""     ,""     ,""   ,""   ,"Duas"     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(_cPerg,"03","Mod.Impressora        ?",""       ,""      ,"mv_ch3","N" ,01     ,0      ,0     ,"C",""        ,"MV_PAR03","Modelo 1",""     ,""     ,""   ,""   ,"Modelo 2" ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	
Return
