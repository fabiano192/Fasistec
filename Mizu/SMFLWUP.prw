#Include 'Protheus.ch'
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#Include "TOPCONN.CH"
#INCLUDE "SPEDNFE.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "PARMTYPE.CH"

User Function SMFLWUP()

Private 	aHeader 	:= {}
Private	aBrowse 	:= {}
Private	oDlg,oBrw
Private	oImp		:= LoadBitmap(GetResources(),'impressao')
Private	oCanc		:= LoadBitmap(GetResources(),'cancel')
Private	oOk			:= LoadBitmap(GetResources(),'ok')
Private	cTableQry	:= "SMFLWUP"
Private	aBrowse	:= {}
Private	aBrowseAux	:= {}
Private	cCBPager	:= Space(TAMSX3("Z8_CBPAGER")[1])
Private	cPlaca		:= Space(TAMSX3("Z7_PLACA")[1])
Private 	cCliente	:= Space(TAMSX3("Z7_CLIENTE")[1])
Private	cOC			:= Space(TAMSX3("Z7_OC")[1])
Private	cNumNF		:= Space(TAMSX3("Z7_NUMNF")[1])
Private	lFirst		:= .T.
Private	aVars		:= {{'cCBPager',"Z8_CBPAGER",cCBPager},;
{'cPlaca',"Z7_PLACA",cPlaca},;
{'cCliente',"Z7_CLIENTE",cCliente},;
{'cOC',"Z7_OC",cOC},;
{'cNumNF',"Z7_NUMNF",cNumNF}}

//CabeГalho do browse
AADD(aHeader,{"Danfe"			,"JCH_FLGSIT"	,"@BMP"				,2	,0,,,"C",,})
AADD(aHeader,{"Ticket"			,"JCH_FLGSIT"	,"@BMP"				,2	,0,,,"C",,})
AADD(aHeader,{"Boleto"			,"JCH_FLGSIT"	,"@BMP"				,2	,0,,,"C",,})
AADD(aHeader,{"Ord.Carreg."		,"Z7_OC"		,"@!"					,6	,0,,,"C",,})
AADD(aHeader,{"Placa"			,"Z8_PLACA"	,"@!"					,7	,0,,,"C",,})
AADD(aHeader,{"Data"				,"Z8_DATA"		,""						,8	,0,,,"D",,})
AADD(aHeader,{"Nome Mot."		,"Z8_NOMMOT"	,"@40"					,40	,0,,,"C",,})
AADD(aHeader,{"Num. NF"			,"Z7_NUMNF"	,""						,6	,0,,,"C",,})
AADD(aHeader,{"Valor"			,"F2_VALBRUT"	,"@E 999,999,999.99"	,14	,2,,,"N",,})
AADD(aHeader,{"Cliente"			,"Z7_CLIENTE"	,"@!"					,6	,0,,,"C",,})
AADD(aHeader,{"Loja"				,"Z7_LOJA"		,"99"					,2	,0,,,"C",,})
AADD(aHeader,{"Nome Cliente"	,"Z7_NOMCLI"	,"@!"					,40	,0,,,"C",,})
AADD(aHeader,{"Nr. Pager"		,"Z8_PAGER"	,"@99"					,3	,0,,,"C",,})
AADD(aHeader,{"Cod.Bar.Pager"	,"Z8_CBPAGER"	,"99999999"			,8	,0,,,"C",,})

oDlg := TDialog():New(0,0,800,1100,"Follow Up de impressЦo",,,,,,,,,.T.)

RptStatus({|| popula()},"aguarde..","Carregando registros")

oSay1 := TSay():New(15,8,{|| "Cod. Barras Pager: "},oDlg,,,,,,.T.,,,40,8)

oGetNFE := TGet():New(13,45,{|u| If(PCount() > 0, cCBPager := u, cCBPager) },;
oDlg,90,8,"99999999",;
{|| if(&(aVars[1][1])!=aVars[1][3],RptStatus({||popula(,'Z8_CBPAGER',.T.)},"Aguarde..","Filtrando registros"),)},;
0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cCBPager,,,,)

oSay2 := TSay():New(15,250,{|| "Placa: "},oDlg,,,,,,.T.,,,40,8)

oGetPlaca := TGet():New(13,270,{|u| If(PCount() > 0, cPlaca := u, cPlaca) },;
oDlg,30,8,"",;
{|| if(&(aVars[2][1])!=aVars[2][3],RptStatus({||popula(,'Z7_PLACA',.F.)},"Aguarde..","Filtrando registros"),)},;
0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cPlaca,,,,)

oSay3 := TSay():New(15,310,{|| "Cliente: "},oDlg,,,,,,.T.,,,40,8)

oGetPlaca := TGet():New(13,330,{|u| If(PCount() > 0, cCliente := u, cCliente) },;
oDlg,30,8,"@!",;
{|| if(&(aVars[3][1])!=aVars[3][3],RptStatus({||popula(,'Z7_CLIENTE',.F.)},"Aguarde...","Filtrando registros"),)},;
0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cCliente,,,,)

oSay4 := TSay():New(15,370,{|| "OC: "},oDlg,,,,,,.T.,,,40,8)

oGetPlaca := TGet():New(13,385,{|u| If(PCount() > 0, cOC := u, cOC) },;
oDlg,30,8,"999999",;
{|| if(&(aVars[4][1])!=aVars[4][3],RptStatus({||popula(,'Z7_OC',.F.)},"Aguarde...","Filtrando registros"),)},;
0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cOC,,,,)

oSay5 := TSay():New(15,420,{|| "Numero NF: "},oDlg,,,,,,.T.,,,40,8)

oGetPlaca := TGet():New(13,450,{|u| If(PCount() > 0, cNumNF := u, cNumNF) },;
oDlg,30,8,"999999",;
{|| if(&(aVars[5][1])!=aVars[5][3],RptStatus({||popula(,'Z7_NUMNF',.F.)},"Aguarde...","Filtrando registros"),)},;
0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cNumNF,,,,)

oBrw := MsNewGetDados():New(40,0,400,550,3,,,,{'JCH_FLGSTT'},0,Len(aBrowse),,,,oDlg,aHeader,aBrowse)
oBrw:oBrowse:bLDBLCLICK := {|| imprime()}

oDlg:Activate(,,,.T.)

Return

Static function popula(p_dData,p_cCampo,p_lFiltCB)

Local dData 		:= if(p_dData==nil,dDataBase-1,p_dData)
Local cCampo		:= if(p_cCampo==nil,'',p_cCampo)
Local lFiltCB		:= if(p_lFiltCB==nil,.F.,p_lFiltCB)
Local lCont			:= .F.

if !EMPTY(cCampo)
	nPos := aScan(aVars,{|x| x[2] == cCampo })
	if &(aVars[nPos][1]) != aVars[nPos][3]
		lCont := .T.
		aVars[nPos][3] := &(aVars[nPos][1])
	endif
	if !lCont; return; endif
endif

aBrowse := {}

cQuery := "SELECT  Z7_OC,Z7_NUMNF,Z7_CLIENTE,Z7_LOJA,Z7_NOMCLI,Z8_PAGER, "
if SZ7->(FieldPos("Z7_IMPTICK")) > 0
	cQuery += "Z7_IMPDANF,Z7_IMPTICK,Z7_IMPBOL, "
else
	cQuery += "'' AS Z7_IMPDANF,'' AS Z7_IMPTICK,'' AS Z7_IMPBOL, "
endif
cQuery += "Z8_CBPAGER,Z8_PLACA,Z8_DATA,Z8_NOMMOT,F2_VALBRUT "
cQuery += "FROM "+RetSqlName("SZ7")+" SZ7 INNER JOIN "+RetSqlName("SZ8")+" SZ8 ON "
cQuery += "Z7_OC = Z8_OC AND Z7_FILIAL = Z8_FILIAL AND Z7_PLACA = Z8_PLACA "
cQuery += "INNER JOIN "+RetSqlName("SF2")+" SF2 ON "
cQuery += "Z7_FILIAL = F2_FILIAL AND Z7_NUMNF = F2_DOC AND Z7_SERIE = F2_SERIE AND Z7_CLIENTE = F2_CLIENTE "
cQuery += "AND Z7_LOJA = F2_LOJA "
cQuery += "WHERE Z8_DATA >= '"+DTOS(dData)+"' "
for nX := 1 to LEN(aVars)
	if !EMPTY(&(aVars[nX][1]))
		cQuery += "AND "+aVars[nX][2]+" = '"+&(aVars[nX][1])+"' "
	endif
next nX
cQuery += "AND SZ7.D_E_L_E_T_ = ' ' AND SZ8.D_E_L_E_T_ = ' ' AND SF2.D_E_L_E_T_ = ' ' "
if SZ7->(FieldPos("Z7_IMPTICK")) > 0
	cQuery += "AND (Z7_IMPDANF = '' OR Z7_IMPTICK = '' OR Z7_IMPBOL = '') "
endif
cQuery += "ORDER BY Z7_OC"

TCQUERY cQuery New Alias (cTableQry)

TCSetField(cTableQry,"Z8_DATA","D")

DbSelectArea(cTableQry)
(cTableQry)->(DbGoTop())
While (cTableQry)->(!EOF())
	AAdd(aBrowse,{if(EMPTY((cTableQry)->Z7_IMPDANF),oImp,oCanc),;
	if(EMPTY((cTableQry)->Z7_IMPTICK),oImp,oCanc),;
	if(EMPTY((cTableQry)->Z7_IMPBOL ),oImp,oCanc),;
	(cTableQry)->Z7_OC,;
	(cTableQry)->Z8_PLACA,;
	(cTableQry)->Z8_DATA,;
	(cTableQry)->Z8_NOMMOT,;
	(cTableQry)->Z7_NUMNF,;
	(cTableQry)->F2_VALBRUT,;
	(cTableQry)->Z7_CLIENTE,;
	(cTableQry)->Z7_LOJA,;
	(cTableQry)->Z7_NOMCLI,;
	(cTableQry)->Z8_PAGER,;
	(cTableQry)->Z8_CBPAGER,;
	.F.})
	(cTableQry)->(DbSkip())
EndDo

(cTableQry)->(DbCloseArea())

if LEN(aBrowse) == 0
	//Conteudo inicial do browse (vazia)
	AAdd(aBrowse,{oCanc,oCanc,oCanc,space(6),space(7),CTOD("//"),space(40),space(6),0,space(6),space(2),space(40),space(3),space(8),.F.})
endif

if ValType(oBrw) == "O"
	oBrw:SetArray(aBrowse,.T.)
	oBrw:ForceRefresh()
endif
oDlg:CtrlRefresh()

return

Static function imprime()

Private	aFilBrw	:={}
Private	cCondicao	:= ""
Private	nColPos	:= oBrw:oBrowse:nColPos

do case
	case nColPos == 1 .And. oBrw:aCols[oBrw:nAt,01] == oImp	// Imprime danfe
		// Posiciona as tabelas de acordo com o necessАrio
		posiciona()
		// Parte responsavel pela impressЦo da danfe
		xPerg:='NFSIGW'
		aParametros:={}
		aAdd( aParametros, SZ7->Z7_NUMNF ) //da nota
		aAdd( aParametros, SZ7->Z7_NUMNF ) //da nota
		aAdd( aParametros, SZ7->Z7_SERIE ) //da nota
		aAdd( aParametros, '2' ) // 1-entrada ou 2-saida
		aAdd( aParametros, '2' )  //1-imprimir ou 2-visualizar
		aAdd( aParametros, '2' )  //imprimi no verso - 1-Sim  2-Nao
		
		u_SMFATF57(aParametros,xPerg)
		
		cCondicao 	:= "F2_FILIAL=='"+xFilial("SF2")+"'"
		aFilBrw	:=	{'SF2',cCondicao}
		lRet := SMSpedDanfe()
		// Atualiza Flag
		if if(lRet==nil,.F.,lRet) .AND. (SZ7->(FieldPos("Z7_IMPDANF")) > 0)
			Posiciona()
			RecLock("SZ7",.F.)
			SZ7->Z7_IMPDANF := "S"
			SZ7->(MsUnlock())
			oBrw:aCols[oBrw:nAt,01] := oCanc
			oBrw:ForceRefresh()
		endif
		
		
	case nColPos == 2 .And. oBrw:aCols[oBrw:nAt,02] == oImp	// Imprime ticket
		posiciona(2)
		If SA1->A1_YTICKET == "S"
			U_RTICKET(SZ8->Z8_OC)
		else
			Alert("Esse cliente nЦo estА habilitado para impressЦo de ticket!")
		endif
		// Atualiza Flag
		if SZ7->(FieldPos("Z7_IMPTICK")) > 0
			Posiciona()
			RecLock("SZ7",.F.)
			SZ7->Z7_IMPTICK := "S"
			SZ7->(MsUnlock())
			oBrw:aCols[oBrw:nAt,02] := oCanc
			oBrw:ForceRefresh()
		endif
		
	case nColPos == 3 .And. oBrw:aCols[oBrw:nAt,03] == oImp	// Imprime boleto
		posiciona()
		Do Case
			//Case ( sm0->m0_codigo == '01' .and. SM0->M0_CODFIL $ "01,04,06,08,09,21") .or. ( sm0->m0_codigo $  "02,10,11,20,30" )
			Case SM0->M0_CODIGO == "02"
				awParam:={  2,;												//	Filtrar por  1= Bordero ou 2=Titulo Expecif
				"",;														//	Bordero
				SZ7->Z7_PREFIXO,;											//	Do Prefixo
				SZ7->Z7_PREFIXO,;											//	Ate o Prefixo
				SZ7->Z7_NUMNF,;												//	Do Numero
				Iif(Empty(SZ7->Z7_NUMNF2),SZ7->Z7_NUMNF,SZ7->Z7_NUMNF2),;	//	Ate o Numero
				"" }	   													//	Mensagem Adcional

				Z07->(dbSetOrder(1))
				If Z07->(dbSeek(xFilial("Z07")+SA1->A1_COD + SA1->A1_LOJA))
					_cSa1Bco := Z07->Z07_BANCO
				Else		
					_cSa1Bco := IF(!EMPTY(SA1->A1_BCO1),SA1->A1_BCO1,GETMV("MV_YBCOPAD"))
					_cSa1Bco := IF(!EMPTY(_cSa1Bco),_cSa1Bco,GETMV("MV_YBCOPAD"))
				Endif


//				If SA1->A1_BCO1 == "021"
				If _cSa1Bco == "021"
					U_MZ0238(awParam)
				Else
					U_BOLCODBAR(awParam)
				Endif
				
			OtherWise
				Execblock("MIZ060",.f.,.f.)
		EndCase
		// Atualiza Flag
		if SZ7->(FieldPos("Z7_IMPBOL")) > 0
			Posiciona()
			RecLock("SZ7",.F.)
			SZ7->Z7_IMPBOL := "S"
			SZ7->(MsUnlock())
			oBrw:aCols[oBrw:nAt,03] := oCanc
			oBrw:ForceRefresh()
		endif
		
endcase

return

Static function posiciona(p_nTipo)

Local nTipo := if(p_nTipo==nil,0,p_nTipo)

DbSelectArea("SZ8")
DbSetOrder(1)
SZ8->(MsSeek(xFilial("SZ8")+oBrw:aCols[oBrw:nAt,04]))

DbSelectArea("SZ7")
DbSetOrder(4)
SZ7->(MsSeek(xFilial("SZ7")+oBrw:aCols[oBrw:nAt,08]))

if nTipo == 2
	DbSelectArea("SA1")
	DbSetOrder(1)
	SA1->(MsSeek(xFilial("SA1")+oBrw:aCols[oBrw:nAt,10]+oBrw:aCols[oBrw:nAt,11]))
endif

return

Static Function SMSpedDanfe()

Local cIdEnt := GetIdEnt()
Local aIndArq   := {}
Local oDanfe
Local nHRes  := 0
Local nVRes  := 0
Local nDevice
Local cFilePrint := "DANFE_"+cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")
Local oSetup
Local aDevice  := {}
Local cSession     := GetPrinterSession()
Local nRet := 0
Local lRet := .F.
If findfunction("U_DANFE_V")
	nRet := U_Danfe_v()
EndIf

AADD(aDevice,"DISCO") // 1
AADD(aDevice,"SPOOL") // 2
AADD(aDevice,"EMAIL") // 3
AADD(aDevice,"EXCEL") // 4
AADD(aDevice,"HTML" ) // 5
AADD(aDevice,"PDF"  ) // 6


nLocal       	:= If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
nOrientation 	:= If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
cDevice     	:= If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
nPrintType      := aScan(aDevice,{|x| x == cDevice })
//зддддддддддддддддддддддддддддддддддддддддддд©
//ЁAjuste no pergunte NFSIGW                  Ё
//юддддддддддддддддддддддддддддддддддддддддддды
AjustaSX1()

If IsReady()
	dbSelectArea("SF2")
	RetIndex("SF2")
	dbClearFilter()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁObtem o codigo da entidade                                              Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If nRet >= 20100824
		
		lAdjustToLegacy := .F. // Inibe legado de resoluГЦo com a TMSPrinter
		oDanfe := FWMSPrinter():New(cFilePrint, IMP_PDF, lAdjustToLegacy, /*cPathInServer*/, .T.)
		
		// ----------------------------------------------
		// Cria e exibe tela de Setup Customizavel
		// OBS: Utilizar include "FWPrintSetup.ch"
		// ----------------------------------------------
		//nFlags := PD_ISTOTVSPRINTER+ PD_DISABLEORIENTATION + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
		nFlags := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
		If ( !oDanfe:lInJob )
			oSetup := FWPrintSetup():New(nFlags, "DANFE")
			// ----------------------------------------------
			// Define saida
			// ----------------------------------------------
			oSetup:SetPropert(PD_PRINTTYPE   , nPrintType)
			oSetup:SetPropert(PD_ORIENTATION , nOrientation)
			oSetup:SetPropert(PD_DESTINATION , nLocal)
			oSetup:SetPropert(PD_MARGIN      , {60,60,60,60})
			oSetup:SetPropert(PD_PAPERSIZE   , 2)
			
		EndIf
		
		// ----------------------------------------------
		// Pressionado botЦo OK na tela de Setup
		// ----------------------------------------------
		If oSetup:Activate() == PD_OK // PD_OK =1
			//зддддддддддддддддддддддддддддддддддддддддддд©
			//ЁSalva os Parametros no Profile             Ё
			//юддддддддддддддддддддддддддддддддддддддддддды
			
			fwWriteProfString( cSession, "LOCAL"      , If(oSetup:GetProperty(PD_DESTINATION)==1 ,"SERVER"    ,"CLIENT"    ), .T. )
			fwWriteProfString( cSession, "PRINTTYPE"  , If(oSetup:GetProperty(PD_PRINTTYPE)==2   ,"SPOOL"     ,"PDF"       ), .T. )
			fwWriteProfString( cSession, "ORIENTATION", If(oSetup:GetProperty(PD_ORIENTATION)==1 ,"PORTRAIT"  ,"LANDSCAPE" ), .T. )
			
			// Configura o objeto de impressЦo com o que foi configurado na interface.
			oDanfe:setCopies( val( oSetup:cQtdCopia ) )
			
			If oSetup:GetProperty(PD_ORIENTATION) == 1
				//зддддддддддддддддддддддддддддддддддддддддддд©
				//ЁDanfe Retrato DANFEII.PRW                  Ё
				//юддддддддддддддддддддддддддддддддддддддддддды
				lRet := u_PrtNfeSef(cIdEnt,,,oDanfe, oSetup, cFilePrint)
			Else
				//зддддддддддддддддддддддддддддддддддддддддддд©
				//ЁDanfe Paisagem DANFEIII.PRW                Ё
				//юддддддддддддддддддддддддддддддддддддддддддды
				lRet := u_DANFE_P1(cIdEnt,,,oDanfe, oSetup)
			EndIf
			
		Else
			MsgInfo("RelatСrio cancelado pelo usuАrio.")
			Pergunte("NFSIGW",.F.)
			bFiltraBrw := {|| FilBrowse(aFilBrw[1],@aIndArq,@aFilBrw[2])}
			Eval(bFiltraBrw)
			Return
		Endif
		
	Else
		lRet := u_PrtNfeSef(cIdEnt)
	EndIf
	
	Pergunte("NFSIGW",.F.)
	bFiltraBrw := {|| FilBrowse(aFilBrw[1],@aIndArq,@aFilBrw[2])}
	Eval(bFiltraBrw)
EndIf
oDanfe := Nil
oSetup := Nil
Return lRet

Static Function GetIdEnt()

Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs
Local lUsaGesEmp := IIF(FindFunction("FWFilialName") .And. FindFunction("FWSizeFilial") .And. FWSizeFilial() > 2,.T.,.F.)
Local lEnvCodEmp := GetNewPar("MV_ENVCDGE",.F.)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁObtem o codigo da entidade                                              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"

oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := IIF(lUsaGesEmp,FWFilialName(),Alltrim(SM0->M0_NOME))
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""

If lUsaGesEmp .And. lEnvCodEmp
	oWS:oWSEMPRESA:CIDEMPRESA:= FwGrpCompany()+FwCodFil()
EndIf

oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
If oWs:ADMEMPRESAS()
	cIdEnt  := oWs:cADMEMPRESASRESULT
Else
	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{STR0114},3)
EndIf

RestArea(aArea)
Return(cIdEnt)

Static Function AjustaSX1()
Local nRet := 0
If findfunction("U_DANFE_V")
	nRet := U_Danfe_v()
EndIf


Return()

Static Function IsReady(cURL,nTipo,lHelp)

Local nX       := 0
Local cHelp    := ""
Local oWS
Local lRetorno := .F.
DEFAULT nTipo := 1
DEFAULT lHelp := .F.
If !Empty(cURL) .And. !PutMV("MV_SPEDURL",cURL)
	RecLock("SX6",.T.)
	SX6->X6_FIL     := xFilial( "SX6" )
	SX6->X6_VAR     := "MV_SPEDURL"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "URL SPED NFe"
	MsUnLock()
	PutMV("MV_SPEDURL",cURL)
EndIf
SuperGetMv() //Limpa o cache de parametros - nao retirar
DEFAULT cURL      := PadR(GetNewPar("MV_SPEDURL","http://"),250)
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁVerifica se o servidor da Totvs esta no ar                              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oWs := WsSpedCfgNFe():New()
oWs:cUserToken := "TOTVS"
oWS:_URL := AllTrim(cURL)+"/SPEDCFGNFe.apw"
If oWs:CFGCONNECT()
	lRetorno := .T.
Else
	If lHelp
		Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{STR0114},3)
	EndIf
	lRetorno := .F.
EndIf
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁVerifica se o certificado digital ja foi transferido                    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If nTipo <> 1 .And. lRetorno
	oWs:cUserToken := "TOTVS"
	oWs:cID_ENT    := GetIdEnt()
	oWS:_URL := AllTrim(cURL)+"/SPEDCFGNFe.apw"
	If oWs:CFGReady()
		lRetorno := .T.
	Else
		If nTipo == 3
			cHelp := IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
			If lHelp .And. !"003" $ cHelp
				Aviso("SPED",cHelp,{STR0114},3)
				lRetorno := .F.
			EndIf
		Else
			lRetorno := .F.
		EndIf
	EndIf
EndIf
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁVerifica se o certificado digital ja foi transferido                    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If nTipo == 2 .And. lRetorno
	oWs:cUserToken := "TOTVS"
	oWs:cID_ENT    := GetIdEnt()
	oWS:_URL := AllTrim(cURL)+"/SPEDCFGNFe.apw"
	If oWs:CFGStatusCertificate()
		If Len(oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE) > 0
			For nX := 1 To Len(oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE)
				If oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE[nx]:DVALIDTO-30 <= Date()
					
					Aviso("SPED",STR0127+Dtoc(oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE[nX]:DVALIDTO),{STR0114},3) //"O certificado digital irА vencer em: "
					
				EndIf
			Next nX
		EndIf
	EndIf
EndIf

Return(lRetorno)