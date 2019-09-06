#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"

/*
Programa PA0193
Autor 		: Fabiano da Silva	-	19/10/09
Uso 		: SIGAFAT - FAT
Descrição 	: Gerar relatório de Romaneio Expedição
*/

USER FUNCTION PA0193()

LOCAL oDlg := NIL

PRIVATE cTitulo    	:= "Relatório de Saída de NF"
PRIVATE oPrn       	:= NIL
PRIVATE oFont1     	:= NIL
PRIVATE oFont2     	:= NIL
PRIVATE oFont3     	:= NIL
PRIVATE oFont4     	:= NIL
PRIVATE oFont5     	:= NIL
PRIVATE oFont6     	:= NIL
PRIVATE _nCont     	:= 0
Private aRadio  	:= {}
Private nRadio  	:= 1
Private oRadio  	:= Nil

AtuSx1()

DEFINE FONT oFont1 NAME "Arial" SIZE 0,09 OF oPrn BOLD
DEFINE FONT oFont2 NAME "Arial" SIZE 0,13 OF oPrn BOLD
DEFINE FONT oFont3 NAME "Arial" SIZE 0,14 OF oPrn BOLD
DEFINE FONT oFont4 NAME "Arial" SIZE 0,10 OF oPrn
DEFINE FONT oFont5 NAME "Arial" SIZE 0,10 OF oPrn BOLD
DEFINE FONT oFont6 NAME "Courier New" BOLD

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

@ 004,010 TO 060,157 LABEL "" OF oDlg PIXEL

@ 010,017 SAY "Esta rotina tem por objetivo gerar o Relatório" OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 020,017 SAY "de Saída de NF conforme os parâmetros         " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 030,017 SAY "informados pelo usuário.                      " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 050,017 SAY "Programa PA0193.PRW                           " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED

@ 002,165 TO 60,205 LABEL "Ordem" OF oDlg PIXEL
@ 10,167 RADIO oRadio VAR nRadio ITEMS "Emissão","Vencto","Cliente","Dt Saída","Romaneio" SIZE 33,10 PIXEL OF oDlg

@ 70,020 BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("PA0193"))	OF oDlg PIXEL
@ 70,090 BUTTON "OK" 		 SIZE 036,012 ACTION (PA193A(),oDlg:End()) 	OF oDlg PIXEL
@ 70,160 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)


Static Function PA193A()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA193B(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return(Nil)


Static Function PA193B()

Pergunte("PA0193",.F.)

_cQuery  := " SELECT E1_EMISSAO,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_VENCREA,E1_CLIENTE,E1_LOJA,E1_NOMCLI,ISNULL(ZJ_MOTORIS,'') AS ZJ_MOTORIS,
_cQuery  += " ISNULL(ZJ_NUMERO,'') AS ZJ_NUMERO,E1_VALOR,E1_SALDO,ISNULL(ZJ_DTSAIDA,'') AS ZJ_DTSAIDA,ISNULL(ZJ_HORASAI,'') AS ZJ_HORASAI "
_cQuery  += " FROM "+RetSqlName("SE1")+" E1 (NOLOCK) "
_cQuery  += " LEFT JOIN "+RetSqlName("SZJ")+" ZJ (NOLOCK) ON E1_PREFIXO+E1_NUM+E1_CLIENTE+E1_LOJA = ZJ_SERIE+ZJ_NF+ZJ_CLIENTE+ZJ_LOJACLI  AND ZJ.D_E_L_E_T_ = '' "
_cQuery  += " INNER JOIN "+RetSqlName("SF2")+" F2 (NOLOCK) ON E1_PREFIXO+E1_NUM+E1_CLIENTE+E1_LOJA = F2_SERIE+F2_DOC+F2_CLIENTE+F2_LOJA "
//_cQuery  += " INNER JOIN "+RetSqlName("SA1")+" A1 (NOLOCK) ON E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA "
_cQuery  += " WHERE E1.D_E_L_E_T_ = '' AND F2.D_E_L_E_T_ = '' AND E1_TIPO = 'NF ' "
_cQuery  += " AND E1_NUM     BETWEEN '"+MV_PAR01+"' 	  AND '"+MV_PAR02+"' "
_cQuery  += " AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
_cQuery  += " AND E1_CLIENTE BETWEEN '"+MV_PAR05+"' 	  AND '"+MV_PAR06+"' "
_cQuery  += " AND E1_LOJA    BETWEEN '"+MV_PAR07+"' 	  AND '"+MV_PAR08+"' "
_cQuery  += " AND F2_DTENTR  BETWEEN '"+DTOS(MV_PAR11)+"' AND '"+DTOS(MV_PAR12)+"' "
If MV_PAR09 = 1
	_cQuery  += " AND F2_DTENTR <> '' "
ElseIf MV_PAR09 = 2
	_cQuery  += " AND F2_DTENTR = '' "
Endif
If MV_PAR10 = 1
	_cQuery  += " AND E1_SALDO > 0 "
ElseIf MV_PAR10 = 2
	_cQuery  += " AND E1_SALDO = 0 "
Endif
If nRadio == 1
	_cQuery  += " ORDER BY E1_EMISSAO"
	cTitulo := cTitulo + " - Por Emissão"
ElseIf nRadio == 2
	_cQuery  += " ORDER BY E1_VENCTO"
	cTitulo := cTitulo + " - Por Vencimento"
ElseIf nRadio == 3
	_cQuery  += " ORDER BY E1_CLIENTE+E1_LOJA"
	cTitulo := cTitulo + " - Por Cliente"
ElseIf nRadio == 4
	_cQuery  += " ORDER BY ZJ_DTSAIDA"
	cTitulo := cTitulo + " - Por Data Saída"
ElseIf nRadio == 5
	_cQuery  += " ORDER BY ZJ_NUMERO"
	cTitulo := cTitulo + " - Por Romaneio"
Endif

TCQUERY _cQuery NEW ALIAS "ZZJ"

TcSetField("ZZJ","E1_EMISSAO","D")
TcSetField("ZZJ","E1_VENCREA","D")
//TcSetField("ZZJ","F2_DTENTR","D")
TcSetField("ZZJ","ZJ_DTSAIDA","D")


If MV_PAR13 = 1
	oPrn 	:= TMSPrinter():New(cTitulo)
	oPrn:SetPortrait()
	
	_nLin  	:= 3000
	_lEnt  	:= .F.
	_nCon   := 0
	_nTotal := _nSaldo := _nTGeral := _nTSald0 := 0
	_cQuebra:= _cQueb1 := ""
	
	ZZJ->(dbGoTop())
	
	ProcRegua(LastRec())
	
	While ZZJ->(!EOF())
		
		IncProc()
		
		If _nLin > 2900
			If _lEnt
				oPrn:EndPage()
			Endif
			oPrn:StartPage()
			Cabec(_nCont)
			_nLin    := 260
		Endif
		
		If nRadio == 1
			_cQueb1  := DTOC(ZZJ->E1_EMISSAO)
		ElseIf nRadio == 2
			_cQueb1  := DTOC(ZZJ->E1_VENCREA)
		ElseIf nRadio == 3
			_cQueb1  := ZZJ->E1_CLIENTE+"-"+ZZJ->E1_LOJA
		ElseIf nRadio == 4
			_cQueb1  := DTOC(ZZJ->ZJ_DTSAIDA)
		ElseIf nRadio == 5
			_cQueb1  := ZZJ->ZJ_NUMERO
		Endif
		
		
		If _lEnt
			If _cQuebra <> _cQueb1
				
				If _nCon > 1
					oPrn:Say(_nLin,0090, "TOTAL - "+_cQuebra				,oFont5)
					oPrn:Say(_nLin,1510, TRANS(_nTotal, "@E 9,999,999.99")	,oFont5)
					oPrn:Say(_nLin,1735, Trans(_nSaldo, "@E 9,999,999.99")	,oFont5)
					_nLin += 40
				Endif
				
				_nTotal := _nSaldo := 0
				_nCon   := 0
				
				oPrn:Line(_nLin,0080,_nLin,2250)
				_nLin += 5
				
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
		
		If nRadio == 1
			_cQuebra  := DTOC(ZZJ->E1_EMISSAO)
		ElseIf nRadio == 2
			_cQuebra  := DTOC(ZZJ->E1_VENCREA)
		ElseIf nRadio == 3
			_cQuebra  := ZZJ->E1_CLIENTE+"-"+ZZJ->E1_LOJA
		ElseIf nRadio == 4
			_cQuebra  := DTOC(ZZJ->ZJ_DTSAIDA)
		ElseIf nRadio == 5
			_cQuebra  := ZZJ->ZJ_NUMERO
		Endif
		
		oPrn:Say(_nLin,0090, DTOC(ZZJ->E1_EMISSAO)										,oFont4)
		oPrn:Say(_nLin,0260, ZZJ->E1_NUM	+ IF(!Empty(ZZJ->E1_PARCELA)," - "+ZZJ->E1_PARCELA,"")	,oFont4)
		oPrn:Say(_nLin,0460, DTOC(ZZJ->E1_VENCREA)										,oFont4)
		oPrn:Say(_nLin,0630, ZZJ->E1_CLIENTE+"-"+ZZJ->E1_LOJA							,oFont4)
		oPrn:Say(_nLin,0805, ZZJ->E1_NOMCLI												,oFont4)
		oPrn:Say(_nLin,1100, Substr(ZZJ->ZJ_MOTORIS,1,20)								,oFont4)
		oPrn:Say(_nLin,1340, ZZJ->ZJ_NUMERO 											,oFont4)
		oPrn:Say(_nLin,1510, TRANS(ZZJ->E1_VALOR, "@E 999,999.99")						,oFont4)
		oPrn:Say(_nLin,1735, TRANS(ZZJ->E1_SALDO, "@E 999,999.99")						,oFont4)
		oPrn:Say(_nLin,1960, DTOC(ZZJ->ZJ_DTSAIDA)										,oFont4)
		oPrn:Say(_nLin,2110, ZZJ->ZJ_HORASAI											,oFont4)
		
		_nTotal  += ZZJ->E1_VALOR
		_nSaldo  += ZZJ->E1_SALDO
		_nTGeral += ZZJ->E1_VALOR
		_nTSald0 += ZZJ->E1_SALDO
		
		_nLin += 40
		
		_lEnt := .T.
		_nCon ++
		
		ZZJ->(dbSkip())
	EndDo
	
	If _nLin > 2900
		If _lEnt
			oPrn:EndPage()
		Endif
		oPrn:StartPage()
		Cabec(_nCont)
		_nLin    := 260
	Endif
	
	lVai := .F.
	If _nCon > 1
		oPrn:Say(_nLin,0090, "TOTAL - "+_cQuebra				,oFont5)
		oPrn:Say(_nLin,1510, TRANS(_nTotal, "@E 9,999,999.99")	,oFont5)
		oPrn:Say(_nLin,1735, Trans(_nSaldo, "@E 9,999,999.99")	,oFont5)
		lVai := .T.
	Endif
	
	If !lVai
		oPrn:Line(_nLin,0080,_nLin,2250)
	Endif
	
	_nLin += 60
	oPrn:Line(_nLin,0080,_nLin,2250)
	_nLin += 5
	oPrn:Line(_nLin,0080,_nLin,2250)
	_nLin += 40
	
	If _nLin > 2900
		If _lEnt
			oPrn:EndPage()
		Endif
		oPrn:StartPage()
		Cabec(_nCont)
		_nLin    := 260
	Endif
	
	oPrn:Say(_nLin,0090, "TOTAL GERAL"						,oFont5)
	oPrn:Say(_nLin,1510, TRANS(_nTGeral, "@E 9,999,999.99")	,oFont5)
	oPrn:Say(_nLin,1735, Trans(_nTSald0, "@E 9,999,999.99")	,oFont5)
	
	Ms_Flush()
	oPrn:EndPage()
	oPrn:End()
	
	oPrn:Preview()
	
	ZZJ->(dbCloseArea())
	
Else                
	_cDir:= "C:\TOTVS\"
	
	If !ExistDir( _cDir )
		If MakeDir( _cDir ) <> 0
			MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
			Return
		EndIf
	EndIf

	_cData   := DTOS(dDataBase)
	_cHora   := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

	_cNomArq := "\SPOOL\ROMANEIO_NF_"+_cData+"_"+_cHora+".XLS"
	
	dbSelectArea("ZZJ")
	Copy all to &_cNomArq
	
	dbCloseArea()
	
	If !__CopyFile(_cNomArq, "C:\TOTVS\ROMANEIO_NF_"+_cData+"_"+_cHora+".xls" )
		MSGAlert("O arquivo não foi copiado!", "AQUIVO NÃO COPIADO!")
	Else

		FErase(_cNomArq)
		
		If ! ApOleClient( 'MsExcel' )
			MsgStop('MsExcel nao instalado')
			Return
		EndIf
	
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( "C:\TOTVS\ROMANEIO_NF_"+_cData+"_"+_cHora+".xls" )
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

oPrn:Say(0105,0850,cTitulo,oFont3,,CLR_BLUE)
oPrn:Say(0090,2080,dtoc(dDataBase),oFont5)
oPrn:Say(0130,2080,Time(),oFont5)

oPrn:Say(0196,0090,"EMISSAO",oFont1)
oPrn:Line(0190,0250,2950,0250) //Vertical
oPrn:Say(0196,0260,"NOTA FISCAL",oFont1)
oPrn:Line(0190,0450,2950,0450) //Vertical
oPrn:Say(0196,0460,"VENCTO",oFont5)
oPrn:Line(0190,0620,2950,0620) //Vertical
oPrn:Say(0196,0630,"CLIENTE",oFont5)
oPrn:Line(0190,0795,2950,0795) //Vertical
oPrn:Say(0196,0805,"NOME CLIENTE",oFont5)
oPrn:Line(0190,1090,2950,1090) //Vertical
oPrn:Say(0196,1100,"MOTORISTA",oFont5)
oPrn:Line(0190,1330,2950,1330) //Vertical
oPrn:Say(0196,1340,"ROMANEIO",oFont1)
oPrn:Line(0190,1500,2950,1500) //Vertical
oPrn:Say(0196,1510,"VALOR",oFont5)
oPrn:Line(0190,1725,2950,1725) //Vertical
oPrn:Say(0196,1735,"SALDO",oFont5)
oPrn:Line(0190,1950,2950,1950) //Vertical
oPrn:Say(0196,1960,"DT SAIDA",oFont1)
oPrn:Line(0190,2100,2950,2100) //Vertical
oPrn:Say(0196,2110,"HR SAIDA",oFont1)

oPrn:Line(0240,0080,0240,2250)

_nCont ++

//Rodapé
oPrn:Line(2950,0080,2950,2250)
oPrn:Say(2955,0090,"PA0193.PRW",oFont5)
oPrn:Say(2955,2050,"Página "+STRZERO(_nCont,3),oFont5)

Return()


Static Function AtuSx1(cPerg)

Local aHelp := {}
cPerg       := "PA0193"

PutSx1(cPerg,"01","NF de          ?" ,"","","mv_ch1","C",09,00,00,"G","","SF2"    ,"","","MV_PAR01",""		 	,"","","" ,""		  		  ,"","",""			,"","","","","","","","","","","","")
PutSx1(cPerg,"02","NF ate         ?" ,"","","mv_ch2","C",09,00,00,"G","","SF2"    ,"","","MV_PAR02",""		 	,"","","" ,""		  		  ,"","",""			,"","","","","","","","","","","","")
PutSx1(cPerg,"03","Emissao NF de  ?" ,"","","mv_ch3","D",08,00,00,"G","",""       ,"","","MV_PAR03",""		 	,"","","" ,""		  		  ,"","",""			,"","","","","","","","","","","","")
PutSx1(cPerg,"04","Emissao Nf ate ?" ,"","","mv_ch4","D",08,00,00,"G","",""       ,"","","MV_PAR04",""		 	,"","","" ,""		  		  ,"","",""			,"","","","","","","","","","","","")
PutSx1(cPerg,"05","Cliente de     ?" ,"","","mv_ch5","C",06,00,00,"G","","SA1"    ,"","","MV_PAR05",""		 	,"","","" ,""		  		  ,"","",""			,"","","","","","","","","","","","")
PutSx1(cPerg,"06","Cliente ate    ?" ,"","","mv_ch6","C",06,00,00,"G","","SA1"    ,"","","MV_PAR06",""		 	,"","","" ,""		  		  ,"","",""			,"","","","","","","","","","","","")
PutSx1(cPerg,"07","Loja de        ?" ,"","","mv_ch7","C",02,00,00,"G","",""       ,"","","MV_PAR07",""		 	,"","","" ,""		  		  ,"","",""			,"","","","","","","","","","","","")
PutSx1(cPerg,"08","Loja ate       ?" ,"","","mv_ch8","C",02,00,00,"G","",""       ,"","","MV_PAR08",""		 	,"","","" ,""		  		  ,"","",""			,"","","","","","","","","","","","")
PutSx1(cPerg,"09","Quais NFs      ?" ,"","","mv_ch9","N",01,00,00,"C","",""       ,"","","MV_PAR09","Entregues"  ,"","","","Não Entregues"    ,"","","Ambos"	,"","","","","","","","","","","","")
PutSx1(cPerg,"10","Quais Títulos  ?" ,"","","mv_cha","N",01,00,00,"C","",""       ,"","","MV_PAR10","Em Aberto"  ,"","","","Baixado"    	  ,"","","Ambos"	,"","","","","","","","","","","","")
PutSx1(cPerg,"11","Dt Saida de    ?" ,"","","mv_chb","D",08,00,00,"G","",""       ,"","","MV_PAR11",""		 	,"","","" ,""		  		  ,"","",""			,"","","","","","","","","","","","")
PutSx1(cPerg,"12","Dt Saida ate   ?" ,"","","mv_chc","D",08,00,00,"G","",""       ,"","","MV_PAR12",""		 	,"","","" ,""		  		  ,"","",""			,"","","","","","","","","","","","")
PutSx1(cPerg,"13","Tipo           ?" ,"","","mv_chd","N",01,00,00,"C","",""       ,"","","MV_PAR13","Em tela"	,"","","" ,"Em Excel"		  ,"","",""			,"","","","","","","","","","","","")

Return (Nil)
