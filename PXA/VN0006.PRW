#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"

#DEFINE WS_CODRET 1  //COD SEFAZ DE RETORNO
#DEFINE WS_MSG    2  //MENSAGEM COMPLETA MONTADA PELA FUNCAO STATUS
#DEFINE WS_MSGSEF 3  //DESCRICAO DA MENSAGEM SEFAZ

#DEFINE WS1_LCONTG  1  //ESTÁ EM CONTINGENCIA ?
#DEFINE WS1_DESCMOD 2  //DESCRICAO DA MODALIDADE

#DEFINE _wEnter_	chr(13)+chr(10)

#XCommand ROLLBACK TRANSACTION => DisarmTransaction()

/*
Programa	:	VN0006
Descrição	:	Transmissão da NF
*/

User Function VN0006(p_cOpcao,cSerie,cNotaIni,cNotaFim)

Local warea			:= GetArea()
Local lret			:=.t.
Local cParNfeRem 	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDNFEREM"
Local cParNfeMnt 	:= '000179_'+SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDNFEREM"
Local aPerg       	:= {}
Local aParam      	:= {}
/*
VN006A-MZ13807

*/
aParam      := {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC))}

PRIVATE cCondicao 	:= ""
PRIVATE bFiltraBrw	:= {|| .t. }


if p_cOpcao $ 'TODAS/REM'
	
	spedNFeRe2(cSerie,cNotaIni,cNotaFim)
	
Endif
/*
if p_cOpcao $ 'TODAS/MNT'

if p_cOpcao == 'TODAS'

aParam[01] := cSerie
aParam[02] := cNotaIni
aParam[03] := cNotaFim

MV_PAR01 := aParam[01]
MV_PAR02 := aParam[02]
MV_PAR03 := aParam[03]


While alltrim(ParamLoad(cParNfeMnt,aParam,2)) <>  alltrim(cNotaIni)
ParamSave(cParNfeMnt,aParam,"1")
End

aadd(aPerg,{1,'STR0010',aParam[01],"",".T.","",".T.",30,.F.})	//"Serie da Nota Fiscal"
aadd(aPerg,{1,'STR0011',aParam[02],"",".T.","",".T.",30,.T.})	//"Nota fiscal inicial"
aadd(aPerg,{1,'STR0012',aParam[03],"",".T.","",".T.",30,.T.})  //"Nota fiscal final"

Endif

SpedNFe1Mnt()

Endif
*/

if p_cOpcao $ 'TODAS/DAN'
	
	if p_cOpcao == 'TODAS'
		xPerg:='NFSIGW'
		aParametros:={}
		aAdd( aParametros, cNotaIni ) //da nota
		aAdd( aParametros, cNotaFim ) //da nota
		aAdd( aParametros, cSerie ) //da nota
		aAdd( aParametros, '2' ) // 1-entrada ou 2-saida
		aAdd( aParametros, '2' )  //1-imprimir ou 2-visualizar
		aAdd( aParametros, '2' )  //imprimi no verso - 1-Sim  2-Nao
		
		u_smSetSX1(aParametros,xPerg)
	Endif
	
	cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
	
	aFilBrw	  := {'SF2',cCondicao}
	
	_cMsg:="Aguardando Autorizacao"
	Private _lDanfe := .F.
	Processa({|| U_VN006A(cSerie,cNotaIni, @_cMsg,)}, "Aguardando Autorizacao da NF-e...",_cMsg,.F.)
	
	If _lDanfe
		cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
		aFilBrw	:=	{'SF2',cCondicao}
		
		SpedDanfe()
	Endif
	
	
	SpedDanfe()
Endif

if p_cOpcao $ 'STA'
	
	SpedNFeStatus()
	
Endif

RestArea(warea)

Return


User Function smSetSX1(aParametros,cPerg)

Local wArea:=GetArea()

//uso expecifico no profile
//**************************
Private p_name  := cEmpAnt + cUserName // variavel publica
Private p_prog  := iif( !empty(cPerg),cPerg,FunName())  // rotina do sistema
Private p_task  := "PERGUNTE" // padrao do sistema para parametros tipo SX1
Private p_type  := "MV_PAR"   //  ""     "" 			"" 				""
Private p_defs  := ""
//*****************************

dbSelectArea("SX1")
SX1->(DbSetOrder(1))

For i:=1 to Len(aParametros)
	If SX1->(dbSeek(      PadR( cperg , 10 ) + strzero(i,2)    ))
		RecLock("SX1",.f.)
		do case
			case valtype(aParametros[i]) == 'C'
				SX1->x1_cnt01 := aParametros[i]
			case valtype(aParametros[i]) == 'N'
				SX1->x1_cnt01 := val(aParametros[i])
		Endcase
		MsUnlock()
	Endif
Next

//PREENCHE A VARIAVEL COM TODOS OS PARAMETROS, CONFORME A SEQUENCIA DO PROPRIO GRUPO DE PERGUNTAS
If SX1->(dbSeek( PadR( cperg , 10 )   ))
	While !SX1->(EOF()) .and.  alltrim(SX1->x1_grupo) == cPerg
		p_defs+=  SX1->x1_tipo+"#"+alltrim(SX1->x1_gsc)+"#"+SX1->x1_cnt01 + _wEnter_
		SX1->(dbSkip())
	End
Endif

If !Empty(p_defs)
	If ( FindProfDef( p_name,p_prog,p_task,p_type) )
		WriteProfDef( p_name,p_prog,p_task,p_type, p_name,p_prog,p_task,p_type, p_defs )
	Else
		WriteNewProf( p_name,p_prog,p_task,p_type, p_defs )
	EndIf
EndIf

RestArea(wArea)

Return


User Function VN006A(_cSerie, _cNota, _cMsgSt)

Local _aArea      := {}
LOCAL _oDanfe, _oSetup
Local _cIdEnt     := ""
Local _cFilePrint := ""
Local _nFlags     := 0
LOCAL _aWSStat    := {"","",""}
LOCAL _aWSCfg     := {"",""}
LOCAL nVezes, lTEnta
LOCAL lImprime    := .T.
Local cModalidade := ""

cIdEnt := GetIdEnt()
_aArea := GetArea()

aNotas := {}
aadd(aNotas,{})
aadd(Atail(aNotas),.F.)
aadd(Atail(aNotas),"S")
aadd(Atail(aNotas),SF2->F2_EMISSAO)
aadd(Atail(aNotas),SF2->F2_SERIE)
aadd(Atail(aNotas),SF2->F2_DOC)
aadd(Atail(aNotas),SF2->F2_CLIENTE)
aadd(Atail(aNotas),SF2->F2_LOJA)

cNaoAut := ""
aXml := GetXML(cIdEnt,aNotas,@cModalidade)

// 1 tentativa a cada segundo, até que a nf esteja autorizada, máximo de 2 min

ProcRegua(120)

for _nTenta:=1 to 120
	
	IncProc(_nTenta)
	
	_lPassou:=.f.
	_cMensagem:=""
	nLenNotas := Len(aNotas)
	For nX := 1 To nLenNotas
		
		If !Empty(aXML[nX][2])
			
			If !Empty(aXml[nX])
				cAutoriza   := aXML[nX][1]
				cCodAutDPEC := aXML[nX][5]
			Else
				cAutoriza   := ""
				cCodAutDPEC := ""
			EndIf
			If (!Empty(cAutoriza) .Or. !Empty(cCodAutDPEC) .Or. Alltrim(aXML[nX][8]) $ "2,5,7")
				
				cAviso := ""
				cErro  := ""
				oNfe := XmlParser(aXML[nX][2],"_",@cAviso,@cErro)
				
				oNfeDPEC := XmlParser(aXML[nX][4],"_",@cAviso,@cErro)
				If Empty(cAviso) .And. Empty(cErro)
					// ImpDet(@oDanfe,oNFe,cAutoriza,cModalidade,oNfeDPEC,cCodAutDPEC,aXml[nX][6])
					_lPassou:=.t.
				EndIf
			Else
				_cMensagem:=aNotas[nX][04]+aNotas[nX][05]+CRLF
			EndIf
		EndIf
		
		if _lPassou
			exit
		else
			// Aguarda antes de tentar de novo
			_nSeconds:=seconds()
			do while seconds()-_nSeconds<1
			enddo
			aXml := GetXML(cIdEnt,aNotas,@cModalidade)
		endif
		
	Next _nTenta
	cNaoAut+=_cMensagem
	
	_lDanfe := _lPassou
	If _lPassou
		exit
	Endif
	
Next NX

Return(_lPassou)

Static Function GetXML(cIdEnt,aIdNFe,cModalidade)

Local cURL       := PadR(GetNewPar("MV_SPEDURL","http://localhost:8080/sped"),250)
Local oWS
Local cRetorno   := ""
Local cProtocolo := ""
Local cRetDPEC   := ""
Local cProtDPEC  := ""
Local nX         := 0
Local nY         := 0
Local aRetorno   := {}
Local aResposta  := {}
Local aFalta     := {}
Local aExecute   := {}
Local nLenNFe
Local nLenWS
Local cDHRecbto  := ""
Local cDtHrRec   := ""
Local cDtHrRec1	 := ""
Local nDtHrRec1  := 0
Local dDtRecib	 :=	CToD("")
Local cModTrans	 := ""
Local cAviso	 := ""
Local cErro		 := ""

Private oDHRecbto

If Empty(cModalidade)
	oWS := WsSpedCfgNFe():New()
	oWS:cUSERTOKEN := "TOTVS"
	oWS:cID_ENT    := cIdEnt
	oWS:nModalidade:= 0
	oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
	If oWS:CFGModalidade()
		cModalidade    := SubStr(oWS:cCfgModalidadeResult,1,1)
	Else
		cModalidade    := ""
	EndIf
EndIf
oWS:= WSNFeSBRA():New()
oWS:cUSERTOKEN        := "TOTVS"
oWS:cID_ENT           := cIdEnt
oWS:oWSNFEID          := NFESBRA_NFES2():New()
oWS:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()
nLenNFe := Len(aIdNFe)
For nX := 1 To nLenNFe
	//aadd(aRetorno,{"","",aIdNfe[nX][4]+aIdNfe[nX][5],"","",""})
	aadd(aRetorno,{"","",aIdNfe[nX][4]+aIdNfe[nX][5],"","","",CToD(""),""})
	aadd(oWS:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
	Atail(oWS:oWSNFEID:oWSNotas:oWSNFESID2):cID := aIdNfe[nX][4]+aIdNfe[nX][5]
Next nX
oWS:nDIASPARAEXCLUSAO := 0
oWS:_URL := AllTrim(cURL)+"/NFeSBRA.apw"

If oWS:RETORNANOTASNX()
	If Len(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5) > 0
		
		For nX := 1 To Len(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5)
			cRetorno        := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CXML
			cProtocolo      := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CPROTOCOLO
			cDHRecbto  		:= oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CXMLPROT
			///////
			oNFeRet			:= XmlParser(cRetorno,"_",@cAviso,@cErro)
			cModTrans		:= IIf(Type("oNFeRet:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT") <> "U",IIf (!Empty("oNFeRet:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT"),oNFeRet:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT,1),1)
			//////
			
			If ValType(oWs:OWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:OWSDPEC)=="O"
				cRetDPEC        := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSDPEC:CXML
				cProtDPEC       := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSDPEC:CPROTOCOLO
			EndIf
			//Tratamento para gravar a hora da transmissao da NFe
			If !Empty(cProtocolo)
				oDHRecbto		:= XmlParser(cDHRecbto,"","","")
				cDtHrRec		:= oDHRecbto:_ProtNFE:_INFPROT:_DHRECBTO:TEXT
				nDtHrRec1		:= RAT("T",cDtHrRec)
				
				If nDtHrRec1 <> 0
					cDtHrRec1 := SubStr(cDtHrRec,nDtHrRec1+1)
					dDtRecib  := SToD(StrTran(SubStr(cDtHrRec,1,AT("T",cDtHrRec)-1),"-",""))
				EndIf
				
				dbSelectArea("SF2")
				dbSetOrder(1)
				If MsSeek(xFilial("SF2")+aIdNFe[nX][5]+aIdNFe[nX][4]+aIdNFe[nX][6]+aIdNFe[nX][7])
					If SF2->(FieldPos("F2_HORA"))<>0 .And. Empty(SF2->F2_HORA)
						RecLock("SF2")
						SF2->F2_HORA := cDtHrRec1
						MsUnlock()
					EndIf
				EndIf
				dbSelectArea("SF1")
				dbSetOrder(1)
				If MsSeek(xFilial("SF1")+aIdNFe[nX][5]+aIdNFe[nX][4]+aIdNFe[nX][6]+aIdNFe[nX][7])
					If SF1->(FieldPos("F1_HORA"))<>0 .And. Empty(SF1->F1_HORA)
						RecLock("SF1")
						SF1->F1_HORA := cDtHrRec1
						MsUnlock()
					EndIf
				EndIf
			EndIf
			nY := aScan(aIdNfe,{|x| x[4]+x[5] == SubStr(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:CID,1,Len(x[4]+x[5]))})
			If nY > 0
				aRetorno[nY][1] := cProtocolo
				aRetorno[nY][2] := cRetorno
				aRetorno[nY][4] := cRetDPEC
				aRetorno[nY][5] := cProtDPEC
				aRetorno[nY][6] := cDtHrRec1
				///
				aRetorno[nY][7] := dDtRecib
				aRetorno[nY][8] := cModTrans
				//
				
				aadd(aResposta,aIdNfe[nY])
			EndIf
			cRetDPEC := ""
			cProtDPEC:= ""
		Next nX
		For nX := 1 To Len(aIdNfe)
			If aScan(aResposta,{|x| x[4] == aIdNfe[nX,04] .And. x[5] == aIdNfe[nX,05] })==0
				aadd(aFalta,aIdNfe[nX])
			EndIf
		Next nX
		If Len(aFalta)>0
			aExecute := GetXML(cIdEnt,aFalta,@cModalidade)
		Else
			aExecute := {}
		EndIf
		For nX := 1 To Len(aExecute)
			nY := aScan(aRetorno,{|x| x[3] == aExecute[nX][03]})
			If nY == 0
				aadd(aRetorno,{aExecute[nX][01],aExecute[nX][02],aExecute[nX][03]})
			Else
				aRetorno[nY][01] := aExecute[nX][01]
				aRetorno[nY][02] := aExecute[nX][02]
			EndIf
		Next nX
	EndIf
EndIf

Return(aRetorno)

Static Function GetIdEnt()

Local _aArea  := GetArea()
Local _cIdEnt := ""
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"

oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
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
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
If oWs:ADMEMPRESAS()
	_cIdEnt  := oWs:cADMEMPRESASRESULT
Else
	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"?"},3)
EndIf

RestArea(_aArea)
Return(_cIdEnt)