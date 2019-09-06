//#include "RWMAKE.CH"
#include "TOTVS.CH"
#include "SHELL.ch"
#include "FILEIO.CH"
#INCLUDE "TOPCONN.CH"

/*/
Funçao    	³ 	CR0058
Autor 		³ 	Fabiano da Silva
Data 		³ 	11.06.14
Descricao 	³	Impressão de etiquetas conforme Ordem de Produção
/*/


User Function CR0058()

	Private _cPerg  	:= "CR0058"
	Private _cCont  	:= '0'
	Private aParamImp	:= {}
	Private _cFerr 		:= _cDisp  := _cCompA := _cCompB := _cCompC := _cRecu := _cPPH  := _cCompo := _cMatr  := _cTraf  := _cMPrim := _cTipo := _cPUso := ''
	Private _nQtCom 	:= _nKgCom := _nCompr := 0

	AtuSx1()
	
	If Pergunte("CR0058",.T.)

		_cQ := " SELECT * FROM "+RetSqlName('SC2')+" C2 "
		_cQ += " INNER JOIN "+RetSqlName('SB1')+" B1 ON C2_PRODUTO = B1_COD "
		_cQ += " WHERE C2.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' "
		_cQ += " AND (C2_QUANT - C2_QUJE) > 0 "
		_cQ += " AND C2_NUM  BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' "
		_cQ += " AND C2_PRODUTO  BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "
		_cQ += " AND C2_EMISSAO  BETWEEN '"+DTOS(MV_PAR06)+"' AND '"+DTOS(MV_PAR07)+"' "
		If MV_PAR01 = 1
			_cQ += " AND B1_GRUPO = 'PPPF' "
		ElseIf MV_PAR01 = 2
			_cQ += " AND B1_TIPO = 'PA' "
		Endif
		_cQ += " ORDER BY C2_NUM "

		TCQUERY _cQ NEW ALIAS "ZC2"

		TCSETFIELD("ZC2","C2_DATPRF","D")
		TCSETFIELD("ZC2","C2_XDTPREV","D")

		ZC2->(dbGotop())
		ProcRegua(ZC2->(U_CONTREG()))

		While ZC2->(!Eof())
	
			IncProc()
		
			_cTipo := '-'
			If ZC2->B1_9TPCOMP = 'V'
				_cTipo := 'Vazado:'
			ElseIf ZC2->B1_9TPCOMP = 'M'
				_cTipo := 'Matriz:'
			ElseIf ZC2->B1_9TPCOMP = 'C'
				_cTipo := 'Cilindro'
			ElseIf ZC2->B1_9TPCOMP = 'P'
				_cTipo := 'Caixa/Pino:'
			ElseIf ZC2->B1_9TPCOMP = 'B'
				_cTipo := 'Balancim'
			Endif

			_nCompr := 0
			If SB1->B1_GRUPO $ "PPPF"
				_nCompr := SG1->G1_MEDBLAL
			Endif
		
			If MV_PAR01 = 1
				_cPUso := '-'
				SB1->(dbSetOrder(1))
				If SB1->(msSeek(xFilial('SB1')+Left(ZC2->B1_COD,6)))
					_cPUso := Alltrim(Posicione("SX5",1,xFilial("SX5")+'ZA'+SB1->B1_9RECURS,"X5_DESCRI"))
				Endif
			Endif
			
			SG1->(dbSetOrder(1))
			If SG1->(dbSeek(xFilial("SG1")+ZC2->B1_COD))
				_cProd   := SG1->G1_COD
				nNivel   := 2
		
				SB1->(dbSetOrder(1))
				SB1->(msSeek(xFilial("SB1")+_cProd))
		
				_cFerr := _cDisp := _cCompA := _cCompB := _cCompC := '-'
//				_cRecu := Alltrim(Posicione("SX5",1,xFilial("SX5")+'ZA'+SB1->B1_9RECURS,"X5_DESCRI"))
				_cPPH  := Alltrim(Str(SB1->B1_9PPH))+' Pc'
				_cCompo := _cMatr  := _cTraf  := _cMPrim := '-'
				_nQtCom := _nKgCom := 0
						
				NECES(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
		
			Endif
	
			_cCont := Alltrim(Str(Val(_cCont)+1))
 
			ImpEt()
			
			ZC2->(dbSkip())
		EndDo
	
		If _cCont = '1'

			If MV_PAR01 = 1
				AAdd(aParamImp, { ''     		,"[PROD2]"})   	//Produto 2
				AAdd(aParamImp, { '0'     		,"[QTDE2]"})   	//Quantidade 2
				AAdd(aParamImp, { '  /  /  '  	,"[DATA2]"})   	//Data 2
				AAdd(aParamImp, { ''     		,"[COMP2]"})   	//Composto 2
				AAdd(aParamImp, { '0'     		,"[QTCO2]"})   	//Quantidade Composto 2
				AAdd(aParamImp, { '0'     		,"[PESO2]"})   	//Peso Composto 2
				AAdd(aParamImp, { '0'     		,"[COPR2]"})   	//Comprimento Composto 2
				AAdd(aParamImp, { ''			,"[MAPR2]"})   	//Mat. Prima
				AAdd(aParamImp, { ''     		,"[TIPO2]"})   	//Tipo
				AAdd(aParamImp, { ''     		,"[MATR2]"})   	//Matriz 2
				AAdd(aParamImp, { ''     		,"[TRAF2]"})   	//Trafila 2
				AAdd(aParamImp, { ''     		,"[PUSO2]"})   	//Ponto de Uso 2
				AAdd(aParamImp, { ''     		,"[CBOP2]"})   	//Cód. de Barras OP 2
				AAdd(aParamImp, { ''     		,"[CDOP2]"})   	//Cód. de Barras OP 2
//				AAdd(aParamImp, { ''     		,"[CBPR2]"})   	//Cód. de Barras Produto 2
//				AAdd(aParamImp, { ''     		,"[CDPR2]"})   	//Cód. de Barras Produto 2
			ElseIf MV_PAR01 = 2
				AAdd(aParamImp, { ''     		,"[PROD2]"})   	//Produto 2
				AAdd(aParamImp, { '0'     		,"[QTDE2]"})   	//Quantidade 2
				AAdd(aParamImp, { '  /  /  '  	,"[DATA2]"})   	//Data 2
				AAdd(aParamImp, { ''  			,"[RECU2]"})   	//Recurso 2
				AAdd(aParamImp, { ''     		,"[FERR2]"})   	//Ferramentais 2
				AAdd(aParamImp, { ''     		,"[DISP2]"})   	//Dispositivo 2
				AAdd(aParamImp, { ''     		,"[COMP2A]"})   //Componentes 2
				AAdd(aParamImp, { ''     		,"[COMP2B]"})   //Componentes 2
				AAdd(aParamImp, { ''     		,"[COMP2C]"})   //Componentes 2
				AAdd(aParamImp, { '0'     		,"[PPH2]"})   	//PPH 2
				AAdd(aParamImp, { ''     		,"[CBOP2]"})   	//Cód. de Barras OP 2
				AAdd(aParamImp, { ''     		,"[CDOP2]"})   	//Cód. dA OP 2
//				AAdd(aParamImp, { ''     		,"[CBPR2]"})   	//Cód. de Barras Produto 2
//				AAdd(aParamImp, { ''     		,"[CDPR2]"})   	//Cód. de Produto 2
			Endif
		
			u_EtiqOP(aParamImp)
		Endif

		ZC2->(dbCloseArea())
	Endif
Return


Static Function NECES(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev)

	Local _nReg := 0
	Local _nRegTrb := 0

	SG1->(dbSetOrder(1))

	While SG1->(!Eof()) .And. SG1->G1_COD == _cProd
	
		_nReg := SG1->(Recno())
	
		dbSelectArea("SG1")
		dbSetOrder(1)
	
		aAreaSB1:=SB1->(GetArea())
		SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))
	
		_nRegTRb := SB1->(Recno())

		If SB1->B1_GRUPO $ "PPPF/PPPM/MPIM" .Or. SB1->B1_SUBGR $ 'MPUDVC'  					// Componentes
			If MV_PAR01 = 2
				If _cCompA == '-'
					_cCompA := SB1->B1_COD
				ElseIf _cCompB == '-'
					_cCompB := SB1->B1_COD
				Else
					_cCompC := SB1->B1_COD
				Endif
			Endif
		ElseIf SB1->B1_GRUPO $ "DPVC"   		// Dispositivo
			_cDisp := If(_cDisp == '-',SB1->B1_COD,_cDisp+';'+SB1->B1_COD)
		ElseIf SB1->B1_GRUPO $ "FRPU|FRVC|FRVI|FRVT"   		// Molde de Vulcanização
			_cFerr := If(_cFerr == '-',SB1->B1_COD,_cDisp+';'+SB1->B1_COD)
		ElseIf SB1->B1_GRUPO $ "PPCO"   		// Composto Preparacao
			_cCompo := SB1->B1_COD
			_nQtCom := SG1->G1_QUANT
		ElseIf SB1->B1_SUBGR $ 'MPUDPP' //mat. Prima Preparacao
			_cMPrim :=  SB1->B1_COD
		ElseIf SB1->B1_GRUPO $ 'DPPF' //Disp. Matriz
			_cMatr :=  SB1->B1_COD
		Endif
		
		RestArea(aAreaSB1)
	
		SG1->(dbSetOrder(1))
		If SG1->(dbSeek(xFilial("SG1")+SG1->G1_COMP))
			SB1->(dbSeek(xFilial("SB1")+SG1->G1_COD))
			NECES(SG1->G1_COD,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
		EndIf
	
		SG1->(dbGoto(_nReg))
	
		SG1->(dbSkip())
	EndDo

Return


Static Function IMPET()

	If MV_PAR01 = 1 //Preparação
		AAdd(aParamImp, { Alltrim(ZC2->C2_PRODUTO)							,"[PROD"+_cCont+"]"})   	//Produto
		_nSaldo := ZC2->C2_QUANT - ZC2->C2_QUJE
		AAdd(aParamImp, { Alltrim(STR(_nSaldo))+' Pc'	,"[QTDE"+_cCont+"]"})   	//Quantidade
		_dDat := cTod('')
		SC2->(dbSetOrder(1))
		If SC2->(msSeek(xFilial('SC2')+ZC2->C2_NUM+'01001'))
			_dDat := SC2->C2_XDTPREV - ZC2->B1_PE
		Endif
		AAdd(aParamImp, { DTOC(_dDat)						     			,"[DATA"+_cCont+"]"})   	//Data
		AAdd(aParamImp, { Alltrim(_cCompo)						     		,"[COMP"+_cCont+"]"})   	//Composto
		AAdd(aParamImp, { Alltrim(STR(_nQtCom * _nSaldo))+' Kg'	    		,"[QTCO"+_cCont+"]"})   	//Quantidade Composto
		AAdd(aParamImp, { Alltrim(STR(_nQtCom))+' Kg'	     				,"[PESO"+_cCont+"]"})   	//Peso Composto
		AAdd(aParamImp, { Alltrim(_nCompr)+' Mt'	     					,"[COPR"+_cCont+"]"})   	//Comprimento Composto
		AAdd(aParamImp, { Alltrim(_cMPrim)			     					,"[MAPR"+_cCont+"]"})   	//Mat. Prima
		AAdd(aParamImp, { Alltrim(_cTipo)									,"[TIPO"+_cCont+"]"})   	//Tipo
		AAdd(aParamImp, { Alltrim(_cMatr)			     					,"[MATR"+_cCont+"]"})   	//Matriz
		AAdd(aParamImp, { Alltrim(_cTraf)			     					,"[TRAF"+_cCont+"]"})   	//Trafila
		AAdd(aParamImp, { Alltrim(_cPUso)			     					,"[PUSO"+_cCont+"]"})   	//Ponto de Uso
		AAdd(aParamImp, { Alltrim(ZC2->C2_NUM+ZC2->C2_ITEM+ZC2->C2_SEQUEN)	,"[CBOP"+_cCont+"]"})   	//Cód. de Barras OP
		AAdd(aParamImp, { Alltrim(ZC2->C2_NUM+ZC2->C2_ITEM+ZC2->C2_SEQUEN)	,"[CDOP"+_cCont+"]"})   	//Cód. de Barras OP
//		AAdd(aParamImp, { Alltrim(ZC2->C2_PRODUTO)   	  					,"[CBPR"+_cCont+"]"})   	//Cód. de Barras Produto
//		AAdd(aParamImp, { Alltrim(ZC2->C2_PRODUTO)   	  					,"[CDPR"+_cCont+"]"})   	//Cód. de Barras Produto
	ElseIF MV_PAR01 = 2 //Vulcanização
		AAdd(aParamImp, { Alltrim(ZC2->C2_PRODUTO)  						,"[PROD"+_cCont+"]"})   	//Produto
		AAdd(aParamImp, { Alltrim(STR(ZC2->C2_QUANT - ZC2->C2_QUJE))		,"[QTDE"+_cCont+"]"})   	//Quantidade
		AAdd(aParamImp, { DTOC(ZC2->C2_XDTPREV)		  						,"[DATA"+_cCont+"]"})   	//Data
//		AAdd(aParamImp, { DTOC(ZC2->C2_DATPRF)		  						,"[DATA"+_cCont+"]"})   	//Data
		AAdd(aParamImp, { Alltrim(ZC2->C2_OBS)					  			,"[RECU"+_cCont+"]"})   	//Recurso
//		AAdd(aParamImp, { Alltrim(_cRecu)						  			,"[RECU"+_cCont+"]"})   	//Recurso
		AAdd(aParamImp, { Alltrim(_cFerr) 					    			,"[FERR"+_cCont+"]"})   	//Ferramentais
		AAdd(aParamImp, { Alltrim(_cDisp) 					    			,"[DISP"+_cCont+"]"})   	//Dispositivos
		AAdd(aParamImp, { Alltrim(_cCompA)						     		,"[COMP"+_cCont+"A]"})   	//Componentes
		AAdd(aParamImp, { Alltrim(_cCompB)						     		,"[COMP"+_cCont+"B]"})   	//Componentes
		AAdd(aParamImp, { Alltrim(_cCompC)						     		,"[COMP"+_cCont+"C]"})   	//Componentes
		AAdd(aParamImp, { Alltrim(_cPPH)							     	,"[PPH"+_cCont+"]"})   		//PPH
		AAdd(aParamImp, { Alltrim(ZC2->C2_NUM+ZC2->C2_ITEM+ZC2->C2_SEQUEN)	,"[CBOP"+_cCont+"]"})   	//Cód. de Barras OP
		AAdd(aParamImp, { Alltrim(ZC2->C2_NUM+ZC2->C2_ITEM+ZC2->C2_SEQUEN)	,"[CDOP"+_cCont+"]"})   	//Cód. da OP
//		AAdd(aParamImp, { Alltrim(ZC2->C2_PRODUTO)   	  					,"[CBPR"+_cCont+"]"})   	//Cód. de Barras Produto
//		AAdd(aParamImp, { Alltrim(ZC2->C2_PRODUTO)   	  					,"[CDPR"+_cCont+"]"})   	//Cód. do Produto
	Endif
	
	If _cCont = '2'
		u_EtiqOP(aParamImp)
		_cCont 		:= '0'
		aParamImp 	:= {}
	Endif

Return .T.



User FUNCTION EtiqOP(aInfo, nVias)

	LOCAL cEtiq:=""
	LOCAL cTemplate:=""
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

	If MV_PAR01 = 1
		cTemplate:="\etiquetas\CR058A.prn"
	ElseIf MV_PAR01 = 2
		cTemplate:="\etiquetas\CR058B.prn"
	Endif
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


Static Function AtuSX1()

	cPerg := "CR0058"
	aRegs :={}

//    	   Grupo/Ordem/Pergunta     	         /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01              /defspa1/defeng1/Cnt01/Var02/Def02/Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(cPerg,"01","Tipo		           ?",""       ,""      ,"mv_ch1","N" ,01     ,0      ,0     ,"C",""        ,"MV_PAR01","Preparacao"   ,""     ,""     ,""   ,""   ,"Vulcanizacao"   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"02","OP de                ?",""       ,""      ,"mv_ch2","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR02",""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SC2")
	U_CRIASX1(cPerg,"03","OP ate               ?",""       ,""      ,"mv_ch3","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR03",""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SC2")
	U_CRIASX1(cPerg,"04","Produto de           ?",""       ,""      ,"mv_ch4","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR04",""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
	U_CRIASX1(cPerg,"05","Produto ate          ?",""       ,""      ,"mv_ch5","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR05",""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
	U_CRIASX1(cPerg,"06","Emissao de           ?",""       ,""      ,"mv_ch6","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR06",""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"07","Emissao ate          ?",""       ,""      ,"mv_ch7","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR07",""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return
