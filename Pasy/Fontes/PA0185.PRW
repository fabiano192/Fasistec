#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa PA0185
Autor 		: Fabiano da Silva	-	29/06/09
Uso 		: SIGACOM - Compras
Descrição 	: Gerar relatório de Indice de Pontualidade de Entrega dos Fornecedores
*/

USER FUNCTION PA0185()

LOCAL oDlg := NIL

PRIVATE cTitulo    	:= "INDICE DE PONTUALIDADE DE ENTREGA DOS FORNECEDORES"
PRIVATE oPrn       	:= NIL
PRIVATE oFont1     	:= NIL
PRIVATE oFont2     	:= NIL
PRIVATE oFont3     	:= NIL
PRIVATE oFont4     	:= NIL
PRIVATE oFont5     	:= NIL
PRIVATE _nCont     	:= 0
Private aRadio  	:= {}
Private nRadio  	:= 1
Private oRadio  	:= Nil

AtuSx1()

aAdd( aRadio, "Relatório" )
aAdd( aRadio, "Excel" )

DEFINE FONT oFont1 NAME "Arial" SIZE 0,08 OF oPrn
DEFINE FONT oFont2 NAME "Arial" SIZE 0,13 OF oPrn BOLD
DEFINE FONT oFont3 NAME "Arial" SIZE 0,13 OF oPrn BOLD
DEFINE FONT oFont4 NAME "Arial" SIZE 0,09 OF oPrn
DEFINE FONT oFont5 NAME "Arial" SIZE 0,09 OF oPrn BOLD

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 010,017 SAY "Esta rotina tem por objetivo gerar o relatório  " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 020,017 SAY "de Pontualidade de Entrega de Fornecedores"       OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 030,017 SAY "conforme os parâmetros informados pelo usuário. " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 040,017 SAY "                                                " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 060,017 SAY "                                                " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED
@ 070,017 SAY "Programa PA0185.PRW                             " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED

//@ 004,165 TO 028,205 LABEL "" OF oDlg PIXEL
//@ 08,167 RADIO oRadio VAR nRadio ITEMS "Relatório","Excel" SIZE 33,10 PIXEL OF oDlg

@ 35,167 BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("PA0185"))	OF oDlg PIXEL
@ 50,167 BUTTON "OK" 		 SIZE 036,012 ACTION (PA185A(),oDlg:End()) 	OF oDlg PIXEL
@ 65,167 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)


Static Function PA185A()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA185B(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return(Nil)


Static Function PA185B()

Pergunte("PA0185",.F.)

If MV_PAR09 = 1 // Analítico
	
	_cQuery  := " SELECT C1_NUM,C1_ITEM,C1_PRODUTO,C1_DATPRF,C1_EMISSAO,C7_NUM,C7_ITEM,C7_DATPRF,C7_FORNECE,C7_LOJA,C7_QUANT,D1_SERIE,D1_DOC, "
	_cQuery  += " D1_DTDIGIT,D1_QUANT,D1_UM,A2_NREDUZ FROM "+RetSqlName("SC1")+" C1 (NOLOCK) "
	_cQuery  += " LEFT JOIN "+RetSqlName("SC7")+" C7 (NOLOCK) ON C1_NUM+C1_ITEM+C1_PRODUTO = C7_NUMSC+C7_ITEMSC+C7_PRODUTO "
	_cQuery  += " LEFT JOIN "+RetSqlName("SD1")+" D1 (NOLOCK) ON D1_PEDIDO+D1_ITEMPC+D1_COD = C7_NUM+C7_ITEM+C7_PRODUTO "
	_cQuery  += " LEFT JOIN "+RetSqlName("SA2")+" A2 (NOLOCK) ON A2_COD+A2_LOJA = C7_FORNECE+C7_LOJA "
	_cQuery  += " WHERE C1.D_E_L_E_T_ = '' AND C7.D_E_L_E_T_ = '' AND D1.D_E_L_E_T_ = '' AND A2.D_E_L_E_T_ = '' "
	_cQuery  += " AND C7_FORNECE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	_cQuery  += " AND C1_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	_cQuery  += " AND C1_NUM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	_cQuery  += " AND C7_NUM BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
	_cQuery  += " AND C7_DATPRF BETWEEN '"+DTOS(MV_PAR10)+"' AND '"+DTOS(MV_PAR11)+"' "
	_cQuery  += " AND A2_PONENTR = '1' "
	_cQuery  += " ORDER BY C7_FORNECE,C7_LOJA,D1_UM,C7_DATPRF,C1_PRODUTO"
	
	TCQUERY _cQuery NEW ALIAS "ZC1"
	
	TcSetField("ZC1","C1_DATPRF","D")
	TcSetField("ZC1","C1_EMISSAO","D")
	TcSetField("ZC1","C7_DATPRF","D")
	TcSetField("ZC1","D1_DTDIGIT","D")
	
	If nRadio == 1
		
		oPrn 	:= TMSPrinter():New(cTitulo)
		oPrn:SetPortrait()
		_nLin  	:= 3000
		_lEnt  	:= .F.
		_nTotal := _nObjNOK  := _nObjOK  := _nTotFor := _nObjet := _nTotPed := _nTotNF := 0
		
		ZC1->(dbGoTop())
		
		ProcRegua(LastRec())
		
		While ZC1->(!EOF())
			
			IncProc()
			
			If _nLin > 2900
				If _lEnt
					oPrn:EndPage()
				Endif
				oPrn:StartPage()
				Cabec(_nCont)
				_nLin    := 260
			Endif
			
			If _lEnt
				If (_cFornece <> ZC1->C7_FORNECE+"/"+ZC1->C7_LOJA) .Or. (_cUM <> ZC1->D1_UM)
					If _nObjet > 89.99
						_cTCor := CLR_GREEN
					Else
						_cTCor := CLR_HRED
					Endif
					
					oPrn:Say(_nLin,0090, "TOTAL - "+_cUM					,oFont5,,_cTCor)
					oPrn:Say(_nLin,0280, _cNomFor							,oFont5,,_cTCor)
					oPrn:Say(_nLin,1185, TRANS(_nTotPed, "@E 999,999.99")	,oFont5,,_cTCor)
					oPrn:Say(_nLin,1540, Trans(_nTotNF , "@E 9,999.99")		,oFont5,,_cTCor)
					oPrn:Say(_nLin,1700, Trans(_nObjet , "@E 9,999.99")+"%"	,oFont5,,_cTCor)
					
					_nObjOK  := _nObjNOK := _nTotFor := _nTotPed := _nTotNF := 0
					
					_nLin += 40
					oPrn:Line(_nLin,0080,_nLin,2250)
					_nLin += 5
					
					If _cFornece <> ZC1->C7_FORNECE
						oPrn:Line(_nLin,0080,_nLin,2250)
						_nLin += 5
					Endif
					
					If _nLin > 2900
						If _lEnt
							oPrn:EndPage()
						Endif
						oPrn:StartPage()
						Cabec(_nCont)
						_nLin    := 260
					Endif
				Endif
			Endif
			
			_cFornece := ZC1->C7_FORNECE+"/"+ZC1->C7_LOJA
			_cNomFor  := ZC1->A2_NREDUZ
			_cUM      := ZC1->D1_UM
			
			If (ZC1->D1_DTDIGIT > (ZC1->C7_DATPRF + 2)) .Or. (ZC1->C7_QUANT <> ZC1->D1_QUANT)
				_nObjNOK += ZC1->C7_QUANT
				_cCor := CLR_HRED
			Else
				_nObjOK  += ZC1->C7_QUANT
				_cCor := CLR_BLACK
			Endif
			
			_nTotFor += ZC1->C7_QUANT
			
			_nObjet := ((_nTotFor - _nObjNOK) / _nTotFor) * 100
			
			oPrn:Say(_nLin,0090, ZC1->C1_PRODUTO			 								,oFont4,,_cCor)
			oPrn:Say(_nLin,0280, ZC1->C1_NUM+"/"+ZC1->C1_ITEM								,oFont4,,_cCor)
			oPrn:Say(_nLin,0500, ZC1->C7_NUM+"/"+ZC1->C7_ITEM								,oFont4,,_cCor)
			oPrn:Say(_nLin,0710, DTOC(ZC1->C1_EMISSAO)										,oFont4,,_cCor)
			oPrn:Say(_nLin,0865, DTOC(ZC1->C1_DATPRF)										,oFont4,,_cCor)
			oPrn:Say(_nLin,1020, DTOC(ZC1->C7_DATPRF)										,oFont4,,_cCor)
			oPrn:Say(_nLin,1185, TRANS(ZC1->C7_QUANT, "@E 999,999.99")						,oFont4,,_cCor)
			oPrn:Say(_nLin,1350, DTOC(ZC1->D1_DTDIGIT)										,oFont4,,_cCor)
			oPrn:Say(_nLin,1540, Trans(ZC1->D1_QUANT, "@E 9,999.99")						,oFont4,,_cCor)
			oPrn:Say(_nLin,1700, Trans(_nObjet, "@E 9,999.99")+"%"							,oFont4,,_cCor)
			oPrn:Say(_nLin,1870, ZC1->D1_SERIE+"-"+ZC1->D1_DOC								,oFont4,,_cCor)
			oPrn:Say(_nLin,2060, _cFornece													,oFont4,,_cCor)
			
			_nTotPed += ZC1->C7_QUANT
			_nTotNF  += ZC1->D1_QUANT
			
			_nLin += 40
			oPrn:Line(_nLin,0080,_nLin,2250)
			_nLin += 5
			
			_lEnt := .T.
			
			ZC1->(dbSkip())
		EndDo
		
		Ms_Flush()
		oPrn:EndPage()
		oPrn:End()
		
		oPrn:Preview()
		
		ZC1->(dbCloseArea())
		
	ElseIf nRadio == 2
		
		_cArqNovo := "\SPOOL\PA0185.DBF"
		dbSelectArea("ZC1")
		Copy all to &_cArqNovo
		
		ZC1->(dbCloseArea())
		
		If ! ApOleClient( 'MsExcel' )
			MsgStop('MsExcel nao instalado')
			Return
		EndIf
		
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\spool\PA0185.DBF" ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
		
	Endif
	
Else // Sintético

	
	aStru := {}
	AADD(aStru,{"FORNECE" 	, "C" , 06, 0 })
	AADD(aStru,{"LOJA"		, "C" , 02, 0 })
	AADD(aStru,{"NOME"		, "C" , 40, 0 })
	AADD(aStru,{"UM"		, "C" , 02, 0 })
	AADD(aStru,{"QUAN_AP"	, "N" , 14, 4 })
	AADD(aStru,{"QUAN_RE"	, "N" , 14, 4 })

	cArqLOG := CriaTrab(aStru,.T.)
	cIndLOG := "FORNECE+LOJA+UM"
	dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

	dbSelectArea("TRB")
	IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

	_cQuery  := " SELECT C7_NUM,C7_ITEM,C7_DATPRF,C7_FORNECE,C7_LOJA,C7_QUANT, "
	_cQuery  += " D1_DTDIGIT,D1_QUANT,D1_UM,A2_NOME FROM "+RetSqlName("SC1")+" C1 (NOLOCK) "
	_cQuery  += " LEFT JOIN "+RetSqlName("SC7")+" C7 (NOLOCK) ON C1_NUM+C1_ITEM+C1_PRODUTO = C7_NUMSC+C7_ITEMSC+C7_PRODUTO "
	_cQuery  += " LEFT JOIN "+RetSqlName("SD1")+" D1 (NOLOCK) ON D1_PEDIDO+D1_ITEMPC+D1_COD = C7_NUM+C7_ITEM+C7_PRODUTO "
	_cQuery  += " LEFT JOIN "+RetSqlName("SA2")+" A2 (NOLOCK) ON A2_COD+A2_LOJA = C7_FORNECE+C7_LOJA "
	_cQuery  += " WHERE C1.D_E_L_E_T_ = '' AND C7.D_E_L_E_T_ = '' AND D1.D_E_L_E_T_ = '' AND A2.D_E_L_E_T_ = '' "
	_cQuery  += " AND C7_FORNECE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	_cQuery  += " AND C1_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	_cQuery  += " AND C1_NUM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	_cQuery  += " AND C7_NUM BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
	_cQuery  += " AND C7_DATPRF BETWEEN '"+DTOS(MV_PAR10)+"' AND '"+DTOS(MV_PAR11)+"' "
	_cQuery  += " AND A2_PONENTR = '1' "
	_cQuery  += " ORDER BY C7_FORNECE,C7_LOJA,D1_UM,C7_DATPRF,C1_PRODUTO"
	
	TCQUERY _cQuery NEW ALIAS "ZC1"
	
	TcSetField("ZC1","C7_DATPRF","D")
	TcSetField("ZC1","D1_DTDIGIT","D")
	
	ZC1->(dbGoTop())
	
	While ZC1->(!EOF())
	
		_nObjNOK := _nObjOK  := 0

		If (ZC1->D1_DTDIGIT > (ZC1->C7_DATPRF + 2)) .Or. (ZC1->C7_QUANT <> ZC1->D1_QUANT)
			_nObjNOK := ZC1->C7_QUANT
		Else
			_nObjOK  := ZC1->C7_QUANT
		Endif

		IF !TRB->(dbSeek(ZC1->C7_FORNECE+ZC1->C7_LOJA+ZC1->D1_UM))
	    	TRB->(RecLock("TRB",.T.))
	    	TRB->FORNECE	:= ZC1->C7_FORNECE
			TRB->LOJA		:= ZC1->C7_LOJA
			TRB->NOME		:= ZC1->A2_NOME
			TRB->UM			:= ZC1->D1_UM
			TRB->QUAN_AP	:= _nObjOK
			TRB->QUAN_RE	:= _nObjNOK
			TRB->(MsUnlock())	
		Else
	    	TRB->(RecLock("TRB",.F.))
			TRB->QUAN_AP	+= _nObjOK
			TRB->QUAN_RE	+= _nObjNOK		
			TRB->(MsUnlock())	
		Endif
		
		ZC1->(dbSkip())
	EndDo
		
	ZC1->(dbClosearea())
	
	If nRadio == 1
		
		oPrn 	:= TMSPrinter():New(cTitulo)
		oPrn:SetPortrait()
		_nLin  	:= 3000
		_lEnt  	:= .F.
		
		TRB->(dbGoTop())
		
//		ProcRegua(LastRec())
		
		While TRB->(!EOF())
  			
  //			IncProc()
			
			If _nLin > 2900
				If _lEnt
					oPrn:EndPage()
				Endif
				oPrn:StartPage()
				Cabec(_nCont)
				_nLin    := 260
			Endif

			_nObjet := (((TRB->QUAN_AP+TRB->QUAN_RE) - TRB->QUAN_RE) / (TRB->QUAN_AP+TRB->QUAN_RE)) * 100
			
			If _nObjet > 89.99
				_cCor := CLR_BLACK
			Else	
				_cCor := CLR_HRED
			Endif	

			oPrn:Say(_nLin,0090, TRB->FORNECE+"/"+TRB->LOJA						,oFont4,,_cCor)
			oPrn:Say(_nLin,0350, TRB->NOME										,oFont1,,_cCor)
			oPrn:Say(_nLin,1140, TRB->UM										,oFont4,,_cCor)
			oPrn:Say(_nLin,1260, TRANS(TRB->QUAN_AP+TRB->QUAN_RE, "@E 999,999.999")			,oFont4,,_cCor)
			oPrn:Say(_nLin,1530, TRANS(TRB->QUAN_AP, "@E 999,999.999")			,oFont4,,_cCor)
			oPrn:Say(_nLin,1790, TRANS(TRB->QUAN_RE, "@E 999,999.999")			,oFont4,,_cCor)
			oPrn:Say(_nLin,2050, TRANS(_nObjet, "@E 9,999.99")+"%"				,oFont4,,_cCor)
			
			_nLin += 40
			oPrn:Line(_nLin,0080,_nLin,2250)
			_nLin += 5
			
			_lEnt := .T.
			
			TRB->(dbSkip())
		EndDo
		
		Ms_Flush()
		oPrn:EndPage()
		oPrn:End()
		
		oPrn:Preview()
		
		TRB->(dbCloseArea())
		
	ElseIf nRadio == 2
		
		_cArqNovo := "\SPOOL\PA0185.DBF"
		dbSelectArea("TRB")
		Copy all to &_cArqNovo
		
		ZC1->(dbCloseArea())
		
		If ! ApOleClient( 'MsExcel' )
			MsgStop('MsExcel nao instalado')
			Return
		EndIf
		
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\spool\PA0185.DBF" ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
		
	Endif
	
Endif

Return (Nil)


STATIC FUNCTION Cabec() //Cabeçalho

oPen	:= TPen():New(10,100,CLR_HRED,oPrn)

Define brush oBr color CLR_HRED

oPrn:SayBitmap(0095,0090,"lgrl01.bmp",0250,0070)

oPrn:Box(0080,0080,3000,2250, oPen)

oPrn:Line(0180,0080,0180,2250)
oPrn:Line(0190,0080,0190,2250)

oPrn:Say(0105,0550,cTitulo,oFont3,,CLR_BLUE)
oPrn:Say(0090,2080,dtoc(dDataBase),oFont5)
oPrn:Say(0130,2080,Time(),oFont5)

If MV_PAR09 = 1 //Analítico
	
	oPrn:Say(0196,0090,"PRODUTO",oFont5)
	oPrn:Line(0190,0270,2950,0270) //Vertical
	oPrn:Say(0196,0280,"NR SC",oFont5)
	oPrn:Line(0190,0490,2950,0490) //Vertical
	oPrn:Say(0196,0500,"NR PC",oFont5)
	oPrn:Line(0190,0700,2950,0700) //Vertical
	oPrn:Say(0196,0710,"EMIS_SC",oFont5)
	oPrn:Line(0190,0855,2950,0855) //Vertical
	oPrn:Say(0196,0865,"ENTR_SC",oFont5)
	oPrn:Line(0190,1010,2950,1010) //Vertical
	oPrn:Say(0196,1020,"ENTR_PC",oFont5)
	oPrn:Line(0190,1170,2950,1170) //Vertical
	oPrn:Say(0196,1180,"QUAN_PC",oFont5)
	oPrn:Line(0190,1340,2950,1340) //Vertical
	oPrn:Say(0196,1350,"ENTR_NF",oFont5)
	oPrn:Line(0190,1495,2950,1495) //Vertical
	oPrn:Say(0196,1525,"QUAN_NF",oFont5)
	oPrn:Line(0190,1690,2950,1690) //Vertical
	oPrn:Say(0196,1730,"%",oFont5)
	oPrn:Line(0190,1860,2950,1860) //Vertical
	oPrn:Say(0196,1870,"N.FISCAL",oFont5)
	oPrn:Line(0190,2050,2950,2050) //Vertical
	oPrn:Say(0196,2060,"FORNEC",oFont5)
	
Else // Sintético

	oPrn:Say(0196,0090,"FORNECEDOR",oFont5)
	oPrn:Line(0190,0340,2950,0340) //Vertical
	oPrn:Say(0196,0350,"NOME",oFont5)
	oPrn:Line(0190,1110,2950,1110) //Vertical
	oPrn:Say(0196,1140,"UM",oFont5)
	oPrn:Line(0190,1210,2950,1210) //Vertical
	oPrn:Say(0196,1300,"TOTAL",oFont5)
	oPrn:Line(0190,1470,2950,1470) //Vertical
	oPrn:Say(0196,1520,"APROVADO",oFont5)
	oPrn:Line(0190,1730,2950,1730) //Vertical
	oPrn:Say(0196,1770,"REPROVADO",oFont5)
	oPrn:Line(0190,1990,2950,1990) //Vertical
	oPrn:Say(0196,2110,"%",oFont5)
	Endif

oPrn:Line(0240,0080,0240,2250)

_nCont ++

//Rodapé
oPrn:Line(2950,0080,2950,2250)
oPrn:Say(2955,0090,"PA0185.PRW",oFont5)
oPrn:Say(2955,2050,"Página "+STRZERO(_nCont,3),oFont5)

Return()


Static Function AtuSx1(cPerg)

Local aHelp := {}
cPerg       := "PA0185"

PutSx1(cPerg,"01","Fornecedor de  ?" ,"","","mv_ch1","C",06,00,00,"G","","SA2"    ,"","","MV_PAR01",""		 	,"","","",""		  		  ,"","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Fornecedor ate ?" ,"","","mv_ch2","C",06,00,00,"G","","SA2"    ,"","","MV_PAR02",""		 	,"","","",""		  		  ,"","","","","","","","","","","","","","","")
PutSx1(cPerg,"03","Produto de     ?" ,"","","mv_ch3","C",15,00,00,"G","","SB1"    ,"","","MV_PAR03",""		 	,"","","",""		  		  ,"","","","","","","","","","","","","","","")
PutSx1(cPerg,"04","Produto ate    ?" ,"","","mv_ch4","C",15,00,00,"G","","SB1"    ,"","","MV_PAR04",""		 	,"","","",""		  		  ,"","","","","","","","","","","","","","","")
PutSx1(cPerg,"06","Sol.Compra ate ?" ,"","","mv_ch6","C",06,00,00,"G","","SC1"    ,"","","MV_PAR06",""		 	,"","","",""		  		  ,"","","","","","","","","","","","","","","")
PutSx1(cPerg,"07","Ped.Compra de  ?" ,"","","mv_ch7","C",06,00,00,"G","","SC7"    ,"","","MV_PAR07",""		 	,"","","",""		  		  ,"","","","","","","","","","","","","","","")
PutSx1(cPerg,"08","Ped.Compra ate ?" ,"","","mv_ch8","C",06,00,00,"G","","SC7"    ,"","","MV_PAR08",""		 	,"","","",""		  		  ,"","","","","","","","","","","","","","","")
PutSx1(cPerg,"09","Tipo           ?" ,"","","mv_ch9","N",01,00,00,"C","",""       ,"","","MV_PAR09","Analítico"  ,"","","","Sintético"        ,"","","","","","","","","","","","","","","")
PutSx1(cPerg,"10","Entrega Ped.de ?" ,"","","mv_cha","D",08,00,00,"G","",""       ,"","","MV_PAR10",""           ,"","","",""                 ,"","","","","","","","","","","","","","","")
PutSx1(cPerg,"11","Entrega Ped.ate?" ,"","","mv_chb","D",08,00,00,"G","",""       ,"","","MV_PAR11",""           ,"","","",""                 ,"","","","","","","","","","","","","","","")

Return (Nil)
