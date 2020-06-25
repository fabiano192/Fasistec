#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "colors.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PXH056   บ Autor ณSaulo Carvalho Gomesบ Data ณ  26/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rios Pedido de Compra                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ M๓dulo Compras                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObserv.   ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAleracoes ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PXH056(lAuto,_cNum1,_cNum2)

Local lExec 		:= .F.
Private oDlg
Private _aImpress	:={}
Private cString 	:= "TRA"
Private cPerg		:= "PXH056"
Private cstartpath	:= Getsrvprofstring("startpath","")
Private cFigura 	:= cstartpath + "LAMPERH.bmp"
Private cLinGray	:= cstartpath + "lin_clr_gray.bmp"
Private cLinBlack	:= cstartpath + "lin_clr_black.bmp"
Private cLinWhite	:= cstartpath + "lin_clr_white.bmp"

cFigura 	:= cstartpath + "lgrl" + SM0->M0_CODIGO + ".bmp"

lAuto := IIF(lAuto = Nil,.F.,.T.)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ValidPerg()

IF !lAuto
	pergunte(cPerg,.T.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem da tela de processamento.                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	@ 200,1 TO 370,370 DIALOG oDlg TITLE OemToAnsi("Pedido de Compra")
	@ 02,05 TO 080,180
	@ 15,010 Say "Este programa tem a finalidade de imprimir Pedido de Compra"
	@ 30,010 Say "em modo grแfico conforme os parโmetros informados."
	
	@ 65,090 BMPBUTTON TYPE 05 ACTION pergunte(cPerg,.T.)
	@ 65,120 BMPBUTTON TYPE 06 ACTION OkRunRel(.F.,MV_PAR01,MV_PAR02)
	@ 65,150 BMPBUTTON TYPE 02 ACTION oDlg:End()
	
	Activate Dialog oDlg Centered
	
ELSE
	
	Processa(OkRunRel(.T.,_cNum1,_cNum2), "Imprimindo Pedido de Compra")
	
ENDIF
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  10/01/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OkRunRel(_lAuto,cNum1,cNum2)
cstartpath:= Getsrvprofstring("startpath","")
if right(cstartpath,1) != "/"
	cstartpath+= "/"
endif

IF !_lAuto
	CLOSE(oDlg)
ENDIF

IF (cNum2 >= cNum1) .AND. (LEN(ALLTRIM(cNum1)) = 6) .AND. (LEN(ALLTRIM(cNum2)) = 6)
	Processa({|| RelPC(cNum1,cNum2)},"Imprimindo Pedido de Compra")
ELSE
	MSGBOX("Verifique o intervalo a ser impresso, pois os n๚meros dos pedidos devem ter seis posi็๕es e o pedido final deve ser superior ao pedido inicial.","Aten็ใo","ALERT")
	RETURN()
ENDIF
RETURN

STATIC FUNCTION RELPC(_cNum1,_cNum2)

Local _cQuery:= Space(1)
Private nLin	 := 0
Private nLinObs  := 0
Private nAltLin	 := 200
Private dDtEntrega	:= CTOD("00/00/00")

Private oFont82 := TFont():New( "Arial",,82,,.F.,,,,,.F. )

Private oFont08c  := TFont():New("Courier New",9,08,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont08cn := TFont():New("Courier New",9,08,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont09c  := TFont():New("Courier New",9,09,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont09cn := TFont():New("Courier New",9,09,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont10c  := TFont():New("Courier New",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont10cn := TFont():New("Courier New",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont11c  := TFont():New("Courier New",9,11,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont11cn := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont12c  := TFont():New("Courier New",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont12cn := TFont():New("Courier New",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont13c  := TFont():New("Courier New",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont13cn := TFont():New("Courier New",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont14c  := TFont():New("Courier New",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont14cn := TFont():New("Courier New",9,14,.T.,.T.,5,.T.,5,.T.,.F.)

Private oFont06a  := TFont():New("Arial",9,06,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont08a  := TFont():New("Arial",9,08,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont08an := TFont():New("Arial",9,08,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont09a  := TFont():New("Arial",9,09,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont09an := TFont():New("Arial",9,09,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont10a  := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont10an := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont11a  := TFont():New("Arial",9,11,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont11an := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont12a  := TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont12an := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont13a  := TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont13an := TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont14a  := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont14an := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)

Private nTotGer	  := 0
Private nTotDesc  := 0
Private nTotFrete := 0
Private nValIPI	  := 0
Private nTotItem  := 0
Private lVeicTer  := .F.

_cQuery:="SELECT DISTINCT SC7.C7_FILIAL, SC7.C7_NUM FROM " + RETSQLNAME("SC7") + " SC7 WHERE SC7.C7_FILIAL = '" + XFILIAL("SC7") + "' AND (SC7.C7_NUM BETWEEN '" + _cNum1 + "' AND '"  + _cNum2 + "') AND SC7.C7_TIPO = 1 "
_cQuery+=" ORDER BY SC7.C7_FILIAL, SC7.C7_NUM "

TCQUERY _cQuery  NEW ALIAS "TRA"

TCSQLEXEC (_cQuery)

DBSELECTAREA("TRA")
DBGOTOP()
IF EOF()
	TRA->(DBCLOSEAREA())
	MSGBOX("Nใo hแ pedidos no intervalo informado. Verifique o n๚mero do pedido e a filial do Pedido de Compra.","Aten็ใo","INFO")
	RETURN()
ENDIF

oPrint:= TMSPrinter():New( "Pedidos de Compra")

oPrint:SetPortrait()
oPrint:SetPaperSize(9)

WHILE !TRA->(EOF())
	nTotGer	  := 0
	nTotDesc  := 0
	nTotFrete := 0
	nValIPI	  := 0
	nTotItem  := 0
	lVeicTer := .F.
	
	_cQuery:=" SELECT SC7.C7_FILIAL, SC7.C7_TIPO, SC7.C7_NUM, SC7.C7_ITEM, SC7.C7_CONAPRO, SC7.C7_PRODUTO, SC7.C7_DESCRI, SC7.C7_UM, SC7.C7_QUANT, SC7.C7_PRECO, "
	_cQuery+=" SC7.C7_TOTAL, SC7.C7_CC, SC7.C7_CODVEIC, SC7.C7_IPI, SC7.C7_NUMSC, SC7.C7_ITEMSC, SC7.C7_DATPRF, SC7.C7_OBS, SC7.C7_FORNECE, SC7.C7_LOJA, SC7.C7_EMISSAO, "
	_cQuery+=" SC7.C7_TPFRETE, SC7.C7_VLDESC, SC7.C7_CODREQ, SC7.C7_CONTRAT, SC7.C7_CODMED, SC7.C7_DESPESA, SC7.C7_CONTA, SC7.C7_VALFRE, "
	_cQuery+=" SA2.A2_NOME, SA2.A2_NREDUZ, SA2.A2_END, SA2.A2_BAIRRO, SA2.A2_MUN, SA2.A2_EST, SA2.A2_CGC, SA2.A2_TEL, SA2.A2_FAX,SA2.A2_INSCR, SA2.A2_BANCO, SA2.A2_AGENCIA, SA2.A2_NUMCON, SA2.A2_TIPO, SA2.A2_INSCRPA, SA2.A2_CONTATO, SE4.E4_DESCRI, "
	_cQuery+=" SC1.C1_FILIAL, SC1.C1_SOLICIT, SC1.C1_ENDENT, SC1.C1_BAIENT, SC1.C1_CIDENT, SC1.C1_ESTENT,SC1.C1_CEPENT, SC8.C8_CONTATO,SC1.C1_NOMAPRO "
	//_cQuery+=" , SAK.AK_NOME "
	_cQuery+=" , SY1.Y1_NOME, SY1.Y1_USER, SCR.CR_USERLIB "
	_cQuery+=" FROM " + RETSQLNAME("SC7") + " SC7 "
	_cQuery+=" LEFT OUTER JOIN " + RETSQLNAME("SA2") + " SA2 ON (SA2.D_E_L_E_T_<>'*' AND SC7.C7_FORNECE = SA2.A2_COD AND SC7.C7_LOJA = SA2.A2_LOJA) "
	_cQuery+=" LEFT OUTER JOIN " + RETSQLNAME("SE4") + " SE4 ON (SE4.D_E_L_E_T_<>'*' AND SC7.C7_COND= SE4.E4_CODIGO) "
	_cQuery+=" LEFT OUTER JOIN " + RETSQLNAME("SCR") + " SCR ON (SCR.D_E_L_E_T_<>'*' AND SCR.CR_NIVEL=50 AND SCR.CR_VALLIB>0  AND SC7.C7_FILIAL = SCR.CR_FILIAL AND SC7.C7_NUM = SCR.CR_NUM) "
	_cQuery+=" LEFT OUTER JOIN " + RETSQLNAME("SC1") + " SC1 ON (SC1.D_E_L_E_T_<>'*' AND SC7.C7_FILIAL = SC1.C1_FILIAL AND SC7.C7_NUMSC = SC1.C1_NUM AND SC7.C7_ITEMSC = SC1.C1_ITEM) "
	_cQuery+=" LEFT OUTER JOIN " + RETSQLNAME("SC8") + " SC8 ON (SC8.D_E_L_E_T_<>'*' AND SC7.C7_FILIAL = SC8.C8_FILIAL AND SC7.C7_NUM = SC8.C8_NUMPED AND SC7.C7_ITEM = SC8.C8_ITEMPED) "
	_cQuery+=" RIGHT OUTER JOIN " + RETSQLNAME("SAJ") + " SAJ ON (SAJ.D_E_L_E_T_<>'*' AND SC7.C7_FILIAL = SAJ.AJ_FILIAL AND SC7.C7_USER = SAJ.AJ_USER AND SC7.C7_GRUPCOM = SAJ.AJ_GRCOM) "
	_cQuery+=" LEFT OUTER JOIN " + RETSQLNAME("SY1") + " SY1 ON (SY1.D_E_L_E_T_<>'*' AND SAJ.AJ_FILIAL = SY1.Y1_FILIAL AND SAJ.AJ_USERCHV = SY1.Y1_USER AND SAJ.AJ_GRCOM = SY1.Y1_GRUPCOM) "

	_cQuery+=" WHERE SC7.C7_NUM = '" + TRA->C7_NUM + "' AND SC7.C7_FILIAL = '" + TRA->C7_FILIAL + "' AND SC7.D_E_L_E_T_ <> '*' AND SC7.C7_TIPO = 1 "
	_cQuery+=" AND C7_FILIAL = '"+xFilial("SC7")+"' "
	_cQuery+=" ORDER BY SC7.C7_NUM ASC, SC7.C7_ITEM ASC"
	
	TCQUERY _cQuery  NEW ALIAS "TRB"                
	
	TCSQLEXEC (_cQuery)
	
	DBSELECTAREA("TRB")
	DBGOTOP()
	_nRecs:=0
	
	WHILE !TRB->(EOF())
		_nRecs++
		TRB->(DBSKIP())
	ENDDO
	
	TRB->(DBGOTOP())
	
	ProcRegua(_nRecs)
	nPagRel:=1
	
	IF !EOF()
		CABECREL()
	ENDIF
	
	WHILE !EOF() .AND. (TRB->C7_NUM = TRA->C7_NUM)
		IF nLin>2800
			RODAPE(1)
			oPrint:EndPage()
			CABECREL()
			nPagRel += 1
		ENDIF
		For i:= 0 to 2
			oPrint:Line(nLin + i,0030,nLin + i,2350)
		NEXT
		
		oPrint:Say (nLin + 020,0040,TRB->C7_ITEM ,oFont08a)
		oPrint:Say (nLin + 020,0130,TRB->C7_PRODUTO,oFont08a)
		oPrint:Say (nLin + 020,1270,TRB->C7_UM ,oFont10Cn)
		nValIPI  := (TRB->C7_TOTAL*((TRB->C7_IPI/100)))
		nTotItem := (TRB->C7_TOTAL*(1+(TRB->C7_IPI/100)))
		oPrint:Say (nLin + 020,1280,TRANSFORM(TRB->C7_QUANT,"@E 99,999,999.999"),oFont10Cn)
		oPrint:Say (nLin + 020,1485,TRANSFORM(TRB->C7_PRECO,"@E 99,999,999.999") ,oFont10cn)
		oPrint:Say (nLin + 020,1790,TRANSFORM(TRB->C7_IPI,"@E 99.99") ,oFont10cn)
		oPrint:Say (nLin + 020,1920,TRANSFORM(nTotItem,"@E 99,999,999.99") ,oFont10cn)
		oPrint:Say (nLin + 020,2210,ALLTRIM(TRB->C7_CC) ,oFont08A)

		IF !EMPTY(ALLTRIM(TRB->C7_CODVEIC))
			oPrint:Say (nLin + 080,1280,"Req./NF :" + TRB->C7_CODREQ,oFont10CN)
			oPrint:Say (nLin + 080,1780,"Veํculo: " + TRB->C7_CODVEIC,oFont10CN)
			oPrint:Say (nLin + 080,2120,"Status:" + Posicione("SZ1",1,XFilial("SZ1") + TRB->C7_CODVEIC,"Z1_SITUACA"),oFont10CN)
			IF TRB->C7_CODVEIC >= '5000'
				lVeicTer := .T.
			ENDIF
			oPrint:Say (nLin + 140,1280,"Proprietแrio :" + ALLTRIM(Posicione("SA2",1,XFILIAL("SA2")+Posicione("SZ1",1,Xfilial("SZ1")+TRB->C7_CODVEIC,"Z1_PROPRIE"),"A2_NOME")),oFont10CN)
		ENDIF
		
		ITEMDESC(ALLTRIM(TRB->C7_DESCRI),nLin,40,.F.)
		ITEMDESC(ALLTRIM(TRB->C7_OBS),nLinObs,40,.T.)
		
		oPrint:line(nLin,0125,nLin + 050,0125)
		oPrint:line(nLin,1255,nLin + 060,1255)
		oPrint:line(nLin,1335,nLin + 060,1335)
		oPrint:line(nLin,1590,nLin + 060,1590)
		oPrint:line(nLin,1790,nLin + 060,1790)
		oPrint:line(nLin,1895,nLin + 060,1895)
		oPrint:line(nLin,2205,nLin + 060,2205)
		oPrint:line(nLin + 050,0030,nLin + 050,0300)
		oPrint:line(nLin + 060,1255,nLin + 060,2350)
		
		ITEMPROJ(TRB->C7_NUMSC, TRB->C7_ITEMSC,nLin,30)
		
		For i:= 0 to 2
			oPrint:Line(nLin + nAltLin + i,0030,nLin + nAltLin + i,2350)
		NEXT
		
		oPrint:Line(nLin,0030,nLin  + nAltLin,0030)
		oPrint:Line(nLin,2350,nLin  + nAltLin,2350)
		oPrint:line(nLin,0300,nLin  + nAltLin,0300)
				
		nLin := nLin + nAltLin + 010
		nTotDesc:= nTotDesc + TRB->C7_VLDESC
		nTotFrete:=nTotFrete + TRB->C7_DESPESA + TRB->C7_VALFRE
		nTotGer := nTotGer + TRB->C7_TOTAL + nValIPI
		
		IF DTOS(dDtEntrega) < TRB->C7_DATPRF
			dDtEntrega := STOD(TRB->C7_DATPRF )
		ENDIF
		TRB->(DBSKIP())
		INCPROC()
	ENDDO
	DBGOTOP()
	
	RODAPE(2)
	oPrint:EndPage()
	nLin := 0
	TRB->(DBCLOSEAREA())
	nTotGer := 0
	TRA->(DBSKIP())
ENDDO
If !oPrint:Setup()
	TRA->(DBCLOSEAREA())
	return
endif
IF !oPrint:IsPrinterActive()
	Alert("Impressora nใo selecionada!")
	TRA->(DBCLOSEAREA())
	return
Endif
TRA->(DBCLOSEAREA())
oPrint:Preview()
oPrint:End()   // Visualiza antes de imprimir


RETURN

STATIC FUNCTION CABECREL()

Local 	aBloq	 := {"B","L","O","Q","U","E","A","D","O"}

oPrint:StartPage()
oPrint:line(0100,0030,0100,2350)			//Linha Horizontal Topo
oPrint:line(0100,0030,0480,0030)			//Linha Vertical Esquerda
oPrint:line(0100,2350,0480,2350)			//Linha Vertical Direita
IF cEmpAnt='01'
	oPrint:SayBitmap(0130,0080,cFigura,0400,0130)
ELSEIF cEmpAnt='03'
	oPrint:SayBitmap(0070,0080,cFigura,0367,0220)
ELSEIF cEmpAnt='04'
	oPrint:SayBitmap(0090,0045,cFigura,0371,0180)
ELSEIF cEmpAnt='08'
	oPrint:SayBitmap(0090,0040,cFigura,0419,0180)
ELSEIF cEmpAnt='93'
	oPrint:SayBitmap(0040,0080,cFigura,152,0240)
ENDIF

oPrint:Say (0120,0520,"PEDIDO DE COMPRA: " + TRB->C7_NUM,oFont13aN,,CLR_HRED)
oPrint:Say (0190,0520,"EMISSรO: " + DTOC(STOD(TRB->C7_EMISSAO)),oFont13aN,,CLR_HRED)

oPrint:Say (0260,0080,SM0->M0_NOMECOM,oFont11aN,,CLR_HBLUE)
oPrint:Say (0300,0080,ALLTRIM(SM0->M0_ENDENT) + " - " + ALLTRIM(SM0->M0_BAIRENT) ,oFont11a)
oPrint:Say (0340,0080,ALLTRIM(SM0->M0_COMPENT),oFont11a)
oPrint:Say (0340,0380,ALLTRIM(SM0->M0_CIDENT) + " - " + SM0->M0_ESTENT ,oFont11a)
oPrint:Say (0380,0080,TRANSFORM(ALLTRIM(SM0->M0_CEPENT),"@R 99.999-999") + " FONE: " + SM0->M0_TEL + " FAX: " + SM0->M0_FAX,oFont11a)
oPrint:Say (0420,0080,"CNPJ: " + TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99") + " I.E.: " + SM0->M0_INSC+ " FILIAL: " + TRB->C7_FILIAL,oFont11a)

oPrint:line(0100,1200,0480,1200)

//Dados do Fornecedor
oPrint:Say (0120,1240,TRB->C7_FORNECE + " / " + TRB->C7_LOJA + " - " + LEFT(ALLTRIM(TRB->A2_NREDUZ),20),oFont12aN)
oPrint:Say (0170,1240,LEFT(ALLTRIM(TRB->A2_NOME),40),oFont11a)
oPrint:Say (0220,1240,ALLTRIM(TRB->A2_END) + SPACE(2) + LEFT(ALLTRIM(TRB->A2_BAIRRO),12) ,oFont10a)
oPrint:Say (0270,1240,ALLTRIM(TRB->A2_MUN) + " - " + TRB->A2_EST ,oFont10a)
oPrint:Say (0270,1840,"CONTATO: " + ALLTRIM(TRB->A2_CONTATO),oFont10a)
oPrint:Say (0320,1240,"FONE: " + LEFT(ALLTRIM(TRB->A2_TEL),13) ,oFont10a)
oPrint:Say (0320,1840,"FAX: " + LEFT(ALLTRIM(TRB->A2_FAX),13),oFont10a)

IF TRB->A2_TIPO <> "F"
	oPrint:Say (0370,1240,"CNPJ: " + TRANSFORM(TRB->A2_CGC,"@R 99.999.999/9999-99") + SPACE(5) + "I.E.: " + TRB->A2_INSCR,oFont10a)
ELSE
	oPrint:Say (0370,1240,"CPF: " + TRANSFORM(TRB->A2_CGC,"@R 999.999.999-99") + SPACE(5) + " PIS: " + TRB->A2_INSCRPA,oFont10a)
ENDIF
oPrint:Say (0420,1240,"BANCO: " + TRB->A2_BANCO,oFont10a)
oPrint:Say (0420,1580,"AG.: " + TRB->A2_AGENCIA,oFont10a)
oPrint:Say (0420,1880,"C/C: " + TRB->A2_NUMCON,oFont10a)
oPrint:line(0480,0030,0480,2350)			//Linha Horizontal
nLin:=500
oPrint:line(nLin,0030,nLin,2350)			   //Linha Horizontal Topo
oPrint:line(nLin,0030,nLin + 050,0030)		   //Linha Vertical Esquerda
oPrint:line(nLin,2350,nLin + 050,2350)		   //Linha Vertical Direita
oPrint:line(nLin + 050,0030,nLin + 050,2350)  //Linha Horizontal Pe

oPrint:line(nLin,0125,nLin + 050,0125)
oPrint:line(nLin,0300,nLin + 050,0300)
oPrint:line(nLin,1255,nLin + 050,1255)
oPrint:line(nLin,1335,nLin + 050,1335)
oPrint:line(nLin,1590,nLin + 050,1590)
oPrint:line(nLin,1790,nLin + 050,1790)
oPrint:line(nLin,1896,nLin + 050,1895)
oPrint:line(nLin,2205,nLin + 050,2205)
oPrint:Say (nLin + 010,0040,"Item",oFont08cn)

oPrint:Say (nLin + 010,0130,"Produto",oFont08cn)

oPrint:Say (nLin + 010,0305,"Descri็ใo",oFont08cn)

oPrint:Say (nLin + 010,1265,"UM",oFont08cn)

oPrint:Say (nLin + 010,1345,"Quant.",oFont08cn)
oPrint:Say (nLin + 010,1595,"Pre็o",oFont08cn)
oPrint:Say (nLin + 010,1795,"%IPI",oFont08cn)
oPrint:Say (nLin + 010,1900,"Total",oFont08cn)
IF SM0->M0_CODIGO<>'03'
	oPrint:Say (nLin + 010,2210,"C.Custo",oFont08cn)
ELSE
	oPrint:Say (nLin + 010,2210,"C.Contab",oFont08cn)
ENDIF

nLin += 070

IF TRB->C7_CONAPRO == "B"
	nAux := 1
	FOR i := 500 to 1700 STEP 150
		oPrint:Say( i, (nAux * 250) - 200 ,aBloq[nAux] ,oFont82,,CLR_HGRAY,100  )
		nAux := nAux + 1
	NEXT
ENDIF

return


STATIC FUNCTION ITEMDESC(_cTexto,_nLin,_nAlin,lObs)

Local _nTLin := IIF(lObs,45,35)
Local _nPosI := 0315
IIF(lObs = Nil, .F.,.T.)

_cTexto:=Alltrim(_cTexto)
WHILE len(_cTexto)>0
	IF len(_cTexto)>_nTLin
		npos:=_nTLin+1
		nTamTxt:=Len(_cTexto)
		//While SUBSTR(_cTexto,nPos,1)<>" "
		//	nPos--
		//ENDDO
		cPrt:=Left(_cTexto,nPos-1)
		nCp1:=INT(len(cPrt)/2)
		nCp2:=nCp1+1
		WHILE LEN(cPrt)<_nTLin
			IF SUBSTR(cPrt,nCp1,1)==" " .or. SUBSTR(cPrt,nCp2,1)==" "
				IF SUBSTR(cPrt,nCp1,1)==" "
					cPrt:=SUBSTR(cPrt,1,nCp1)+" "+SUBSTR(cPrt,nCp1+1,Len(cPrt)-nCP1)
					nCp1--
					nCp2++
				ELSE
					cPrt:=SUBSTR(cPrt,1,nCp2-1)+" "+SUBSTR(cPrt,nCp2,Len(cPrt)-nCP2+1)
					nCp2++
					nCp2++
				ENDIF
			ELSE
				nCp1--
				nCp2++
				IF nCp1<3
					nCp1:=INT(len(cPrt)/2)
					nCp2:=nCp1+1
				ENDIF
			ENDIF
		ENDDO
		IF lObs
			oPrint:Say( _nLin, _nPosI ,cPrt, oFont11cN)
		ELSE
			oPrint:Say( _nLin, _nPosI ,cPrt, oFont11cN)
		ENDIF
		_nLin+=_nAlin
		_cTexto:=SUBSTR(_cTexto,nPos+1,nTamTxt-nPos+1)
	ELSE
		IF lObs
			oPrint:Say( _nLin, _nPosI ,_cTexto, oFont11cN)
		ELSE
			oPrint:Say( _nLin, _nPosI ,_cTexto, oFont11cN)
		ENDIF
		_nLin+=_nAlin
		_cTexto=""
	ENDIF
ENDDO
nLinObs:= _nLin
//IF nLinObs > nLin
//   	nLin := nLinObs
//ENDIF
RETURN()

STATIC FUNCTION ITEMPROJ(_cNumSC1,_cItemSC1,_nLin,_nAlin)

Local aArea  := GetArea()

DbSelectArea("AFG")
DbSetOrder(2)
DbGoTop()
_nLin += 055
IF DBSEEK(XFILIAL("AFG")+_cNumSC1+_cItemSC1)
	WHILE !EOF() .AND. (AFG->AFG_NUMSC = _cNumSC1) .AND. (AFG->AFG_ITEMSC = _cItemSC1 )
		
		oPrint:Say (_nLin,0040,AFG->AFG_PROJET ,oFont08C)
		oPrint:Say (_nLin,0120,AFG->AFG_TAREFA,oFont08C)
		oPrint:Say (_nLin,0140,TRANSFORM(AFG->AFG_QUANT,"@E 999.99"),oFont08c)
		_nLin += _nAlin
		AFG->(DBSKIP())
	ENDDO
ENDIF
IF nLinObs > nLin
	
ENDIF
RestArea(aArea)
RETURN()

STATIC FUNCTION RODAPE(nTipo)
Local cFigComprador := cstartpath + TRB->Y1_USER+".bmp"
Local cFigAprovSol
Local cFigAprovCom
Local cFigDiretoria
Local aArea			:= GetArea()
Local cCodAproPed	:= Space(1)
Local cNomAproPed	:= Space(1)

cCodAproPed 	:= 	TRB->CR_USERLIB
cNomAproPed	:=  Posicione("SAK",2,XFILIAL("SAK")+TRB->CR_USERLIB,"AK_NOME")

nLin += 20
oPrint:Line(nLin,0030,nLin,2350)
IF nTipo = 2
	
	oPrint:Line(nLin,0030,nLin + 0220,0030)
	oPrint:Line(nLin,2350,nLin + 0220,2350)
	
	//nLin += 20
	oPrint:Say (nLin,0080,"Prazo para Entrega",oFont09cN)
	oPrint:Say (nLin,0520,"Condi็ใo de Entrega",oFont09cN)
	oPrint:Say (nLin,0925,"Forma de Pagamento",oFont09cN)
	oPrint:Say (nLin,1330,"Frete/Despesa",oFont09cN)
	oPrint:Say (nLin,1650,"Desconto",oFont09cN)
	oPrint:Say (nLin,1910,"Valor do(s) Produto(s)",oFont09cN)
	
	oPrint:Line(nLin,0500,nLin + 0100,0500)
	oPrint:Line(nLin,0900,nLin + 0100,0900)
	oPrint:Line(nLin,1300,nLin + 0100,1300)
	oPrint:Line(nLin,1600,nLin + 0100,1600)
	oPrint:Line(nLin,1900,nLin + 0100,1900)
	
	nLin += 60
	oPrint:Say (nLin,0160,DTOC(dDtEntrega),oFont10cN)
	oPrint:Say (nLin,0535,PADC(IIF(TRB->C7_TPFRETE = "C","CIF","FOB"),15),oFont10cN)
	oPrint:Say (nLin,0950,PADC(ALLTRIM(TRB->E4_DESCRI),12),oFont10cN)
	oPrint:Say (nLin,1370,Transform(nTotFrete,"@E 99,999.99"),oFont10cN)
	oPrint:Say (nLin,1670,Transform(nTotDesc,"@E 99,999.99"),oFont10cN)
	oPrint:Say (nLin,2010,TRANSFORM(nTotGer,"@E 999,999,999.99"),oFont10cN)
	
	nLin += 40
	oPrint:Line(nLin,0030,nLin ,2350)
	//nLin += 40
	nTotPedido := nTotGer - nTotDesc + nTotFrete
	
	oPrint:Line(nLin,1150,nLin + 0120,1150)
	oPrint:Line(nLin,1800,nLin + 0120,1800)
	
	oPrint:Say (nLin,0080,"Observa็ใo",oFont10cN)
	oPrint:Say (nLin,1250,"Solicita็ใo da Compra",oFont10cN)
	oPrint:Say (nLin,1820,"Valor Total do Pedido",oFont11cN)
	nLin += 60
	oPrint:Say (nLin - 20,1330,"N๚mero:" + TRB->C7_NUMSC,oFont11cn)
	oPrint:Say (nLin + 20,1330,TRB->C1_SOLICIT,oFont11cn)
	oPrint:Say (nLin,2000,TRANSFORM(nTotPedido,"@E 999,999,999.99"),oFont11cn)
	nLin += 60
	oPrint:Line(nLin,0030,nLin ,2350)
	nLin += 40
	oPrint:SayBitmap(nLin,0080,cFigComprador,0400,0130)
	nLin += 80
	oPrint:Say (nLin,0100,PADC(TRB->Y1_NOME,24),oFont11cN)
	oPrint:Say (nLin,0700,PADC(TRB->C1_NOMAPRO,24),oFont11cN)
	IF !EMPTY(ALLTRIM(cCodAproPed))
		oPrint:Say (nLin,1300,PADC(AllTrim(cNomAproPed),24),oFont11cN)
	ENDIF
	//oPrint:Say (nLin,1900,"Diretoria",oFont10c)
	nLin += 40
	oPrint:Say (nLin,0200,"Comprador(a)",oFont10cn)
	oPrint:Say (nLin,0700,"Aprovador Solicita็ใo",oFont10cn)
	oPrint:Say (nLin,1300,"Aprovador(a) Matriz",oFont10cn)
	oPrint:Say (nLin,1900,"Diretoria",oFont10cn)
	nLin += 80
	oPrint:Say (nLin,0030,"Notas",oFont10cn)
	nLin += 40
	oPrint:Line(nLin,0030,nLin,2350)
	IF SM0->M0_CODIGO<>'01'
		oPrint:Line(nLin,0030,nLin + 0160,0030)
		oPrint:Line(nLin,2350,nLin + 0160,2350)
	ELSE
		oPrint:Line(nLin,0030,nLin + 0240,0030)
		oPrint:Line(nLin,2350,nLin + 0240,2350)
	ENDIF
	oPrint:Say (nLin,0050,"S๓ aceitaremos a(s) mercadoria(s) e/ou servi็o(s) se:",oFont10cn)
	nLin += 40
	oPrint:Say (nLin,0050," - Constar o n๚mero do nosso Pedido de Compra no corpo da Nota Fiscal;",oFont10cn)
	IF SM0->M0_CODIGO='01'
		nLin += 40
		oPrint:Say (nLin,0050," - O prestador de servi็o de Cuiabแ - MT deve informar o N๚mero do CAE 13.521 para reten็ใo do ISSQN",oFont10cn)
		nLin += 40
		oPrint:Say (nLin,0050,"conforme Ofํcio No. 288/02 da Secretแria Municipal de Finan็as da Prefeitura Municipal de Cuiabแ.",oFont10cn)
	ENDIF
	nLin += 40
	oPrint:Say (nLin,0050," - A Nota Fiscal for emitida pela empresa na qual consta o CNPJ e IE do Pedido acima.",oFont10cn)
	nLin += 40
	oPrint:Say (nLin,0050,"Caso haja diverg๊ncias, favor entrar em contato com o nosso departamento de Compras.",oFont10cn)
	nLin += 40
	oPrint:Line(nLin,0030,nLin,2350)
	IF lVeicTer
		
		nLin += 80
		oPrint:Say (nLin,0050,"Valor a ser descontado em medi็ใo do veํculo/equipamento contratado.",oFont10cn)
		nLin += 40
	ENDIF
ENDIF
RestArea(aArea)
RETURN()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ AP5 IDE            บ Data ณ  10/04/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}
Local cKey	   := space(1)

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)
cPerg := cPerg+SPACE(4)

//          Grupo/Ordem/Pergunta            /Perg.          /Varavel/Tpo/Tm/Dc/Pre/GSC/Vld/Var01/Def01/Def1Esp/Def1Ing/Cnt01/Var02/Def02/Def2Esp/Def2Ing/Cnt02/Var03/Def03/Def3Esp/Def3Ing/Cnt03/Var04/Def04/Def4Esp/Def4Ing/Cnt04/Var05/Def05/Def5Esp/Def5Ing/Cnt05/F3/GRPSXG/
aAdd(aRegs,{cPerg,"01","Pedido De:"				,"."  ,"."     ,"mv_ch1","C",06,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC7","","","",""})
aAdd(aRegs,{cPerg,"02","Pedido At้:" 			,"."  ,"."     ,"mv_ch2","C",06,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC7","","","",""})
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

DBSelectArea(_sAlias)

Return ()