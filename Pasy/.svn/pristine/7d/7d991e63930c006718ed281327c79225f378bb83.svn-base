#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
Programa	:	PA0238
Autor		:	Fabiano da Silva
Descrição	:	Envio de Solicitação de Compra por workflow
Conforme programa MATR100 (Relação de Solicitação de Compra)
*/


User Function PA0238()

PREPARE ENVIRONMENT Empresa "01" Filial "01"

_aAliOri := GetArea()
_aAliSC1 := SC1->(GetArea())
_aAliSc7 := Sc7->(GetArea())

_lEnvia    := .F.
_lFim      := .F.
_cMsg01    := ''
_lAborta01 := .T.
_bAcao01   := {|_lFim| 	PA238A(@_lFim) }
_cTitulo01 := 'Enviando E-mail !!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

RestArea(_aAliSc1)
RestArea(_aAliSc7)
RestArea(_aAliOri)

Return



Static Function PA238A(_lFim)

LOCAL nCntImpr	:= 0
LOCAL nSldEntre	:= 0
LOCAL nSldProd	:= 0
LOCAL nTotSC	:= 0
Local nIndex	:= 0
LOCAL aSoma		:= {}
Local lQuery    := .F.
Local cQuery    := ""
Local lPedido   := .F.
Local nOrdSC1   := 1
Local nRegSC1   := 0
Local nQtdSC1   := 0
Local nQtdSC7   := 0
Local cCotSC1   := ""
Local cProSC1   := ""
Local cItPSC1   := ""
Local cProduto	:= ""
Local cNumSol   := ""
Local nI        := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
dbSelectArea("SC7")  // ChkFile() precisa da tabela (SC7) criada
ChkFile('SC7',.F.,'TMP')

aADD(aIndex,CriaTrab(NIL,.F.))
IndRegua("TMP",aIndex[Len(aIndex)],"C7_FILIAL+C7_NUMCOT+C7_PRODUTO")

dbSelectArea("SC7")
aADD(aIndex,CriaTrab(NIL,.F.))

IndRegua("SC7",aIndex[Len(aIndex)],"C7_FILIAL+C7_NUMSC+C7_ITEMSC+C7_PRODUTO")
nIndex := RetIndex("SC7")

dbSetIndex(aIndex[2]+OrdbagExt())
dbSetOrder(nIndex+1)
*/

Private _lRet

nOpcao := 0

ConOut("Enviando E-Mail SC:")

oProcess := TWFProcess():New( "ENVEM1", "Compras" )
aCond    :={}

oProcess:NewTask( "SC", "\WORKFLOW\SOL_COMPRA.HTM" )
oProcess:bReturn  := ""
oProcess:bTimeOut := ""
oHTML := oProcess:oHTML 

oProcess:cSubject := "Solicitações de Compra em Aberto em: "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

dbSelectArea("SC1")
dbSetOrder(2)
dbSeek(xFilial("SC1"))

//SetRegua(LastRec())

While !Eof() .And. SC1->C1_FILIAL == xFilial()
	
	cValAnt		:= xFilial("SC1")+SC1->C1_PRODUTO
	cProduto    	:= SC1->C1_PRODUTO
	cQuebra		:= 'cValAnt==xFilial("SC1")+SC1->C1_PRODUTO'
	
	While !Eof() .And. &(cQuebra)
		
		//		IncRegua()
		
		If SC1->C1_QUANT == SC1->C1_QUJE
			dbSkip()
			Loop
		Endif
		
		_dEmis1 := dDataBase - 100
		_dEmis2 := dDataBase + 100
		If (SC1->C1_EMISSAO < _dEmis1 .Or. SC1->C1_EMISSAO > _dEmis2)
			dbSkip()
			Loop
		Endif    
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial()+SC1->C1_PRODUTO)          
		
		If SB1->B1_TIPO <> "MP"   
			dbSelectArea("SC1")
			dbSkip()
			Loop
		Endif    
		
		dbSelectArea("SC1")

		AADD( (oHtml:ValByName( "IT.NUM"   		)), SC1->C1_NUM)
		AADD( (oHtml:ValByName( "IT.ITEM"     	)), SC1->C1_ITEM )
		AADD( (oHtml:ValByName( "IT.PRODUTO"  	)), SC1->C1_PRODUTO)
		AADD( (oHtml:ValByName( "IT.DESCRIC"  	)), SubStr(SC1->C1_DESCRI,1,20))
		AADD( (oHtml:ValByName( "IT.TP"   		)), SB1->B1_TIPO)
		AADD( (oHtml:ValByName( "IT.GRUPO"   	)), SB1->B1_GRUPO)	
		AADD( (oHtml:ValByName( "IT.QTDE"   	)), Transform(SC1->C1_QUANT, "@E 999,999.999"))
		AADD( (oHtml:ValByName( "IT.UM"   		)), SC1->C1_UM)
		AADD( (oHtml:ValByName( "IT.EMISSC"	)), DTOC(SC1->C1_EMISSAO))
		AADD( (oHtml:ValByName( "IT.ENTSC"		)), DTOC(SC1->C1_DATPRF))
		AADD( (oHtml:ValByName( "IT.SOLIC"		)), Substr(SC1->C1_SOLICIT,1,12))
		_dDtLim := SomaPrazo(SC1->C1_DATPRF, - CalcPrazo(SC1->C1_PRODUTO,SC1->C1_QUANT))
		AADD( (oHtml:ValByName( "IT.DTLIM"		)), DTOC(_dDtLim))
		_nsaldo := SC1->C1_QUANT-SC1->C1_QUJE
		AADD( (oHtml:ValByName( "IT.SALDO"		)), Transform(_nsaldo, "@E 999,999.999"))
		
		cAliasSC7 := "TMP"
		lQuery := .T.
		cQuery := "SELECT C7_FILIAL,C7_NUM,C7_FORNECE,C7_LOJA,C7_EMISSAO,C7_TPOP,C7_NUMSC,C7_ITEMSC "
		cQuery += "FROM "+RetSqlName("SC7")+" "
		cQuery += "WHERE "
		cQuery += "C7_FILIAL = '"+xFilial("SC7")+"' AND "
		cQuery += "C7_NUMSC  = '"+SC1->C1_NUM+"' AND "
		cQuery += "C7_ITEMSC = '"+SC1->C1_ITEM+"' AND "
		cQuery += "C7_TIPO   = 1 AND "
		cQuery += "D_E_L_E_T_= ' ' "
		cQuery += "ORDER BY C7_FILIAL,C7_NUMSC,C7_ITEMSC"
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)
		TcSetField("TMP","C7_EMISSAO","D",8,0)
		
		_lent := .F.
		While !Eof()
				
			AADD( (oHtml:ValByName( "IT.PEDIDO"   	)), (cAliasSC7)->C7_NUM)
			AADD( (oHtml:ValByName( "IT.FORN"   	)), (cAliasSC7)->C7_FORNECE+"/"+(cAliasSC7)->C7_LOJA)
				
			dbSelectArea("SA2")
			dbSeek(xFilial()+(cAliasSC7)->C7_FORNECE+(cAliasSC7)->C7_LOJA)
				
			AADD( (oHtml:ValByName( "IT.RAZAO"   	)), SA2->A2_NREDUZ)
			AADD( (oHtml:ValByName( "IT.EMISPC"   	)), DTOC((cAliasSC7)->C7_EMISSAO))
			
			_lent := .T.
			
			dbSelectArea(cAliasSC7)
			dbSkip()
		EndDo
	
		If !_lent
			
			AADD( (oHtml:ValByName( "IT.PEDIDO"   	)), " ")
			AADD( (oHtml:ValByName( "IT.FORN"   	)), " ")
			AADD( (oHtml:ValByName( "IT.RAZAO"   	)), " ")
			AADD( (oHtml:ValByName( "IT.EMISPC"   	)), " ")
			
		Endif
		
		If ( lQuery )
			(cAliasSC7)->(dbCloseArea())
		EndIf
		
		dbSelectArea("SC7")
		
		oProcess:fDesc := "Solicitação de Compras"
		
		dbSelectArea("SC1")
		dbSkip()
	EndDo
	
EndDo


//_cTo := GETMV("MV_WEMDIR1")
_cTo := GETMV("MV_WEMPCP1")
//_cTo := "fabiano@assystem.com.br"
_cCc := GETMV("MV_WEMDIR1")+";"+GETMV("MV_WEMPCP4")+";"+GETMV("MV_WEMCOM1")

//_cCc := GETMV("MV_WEMTI1")

oProcess:cTo := _cTo
oProcess:cCC := _cCC

oProcess:Start()

RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Envio Email SC iniciado!' )

oProcess:Finish()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta Arquivo Temporario e Restaura os Indices Nativos.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If ( Select("TMP")<>0 )
	dbSelectArea("TMP")
	dbCloseArea()
	dbSelectArea("SC7")
EndIf

Return
