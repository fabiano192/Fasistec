#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³PA0223  ºAutor  ³Fabiano da Silva      º Data ³  18/01/12   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envia WorkFlow de Aprovacao de Solicitacao de Compras      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus10(Compras)                                        º±±
±±º          ³                                                            º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PA0223()

Local cSuperior := PswRet()[1][11]
Local cTotItem := Strzero(Len(aCols),4)

Private cDiasA
Private cDiasE

//U_CFGRD001(FunName())

//³Verifica a Existencia de Parametro PA_TIMESC, Caso nao exista. Cria o parametro.
dbSelectArea("SX6")
If !dbSeek("  "+"PA_TIMESC")
	RecLock("SX6",.T.)
	X6_VAR    	:= "PA_TIMESC"
	X6_TIPO 	:= "C"
	X6_CONTEUD 	:= "0305"
	X6_CONTENG 	:= "0305"
	X6_CONTSPA 	:= "0305"
	X6_DESCRIC	:= "DEFINE TEMPO EM DIAS DE TIMEOUT DA APROVACAO DE SO"
	X6_DESC1	:= "LICITACAO DE COMPRAS - EX: AVISO EM 3 DIAS E EXCLU"
	X6_DESC2	:= "SAO EM 5 DIAS = 0305                              "
	MsUnlock("SX6")
EndIf

cDiasA := SubStr(GetMv("PA_TIMESC"),1,2) //TIMEOUT Dias para Avisar Aprovador
cDiasE := SubStr(GetMv("PA_TIMESC"),3,2) //TIMEOUT Dias para Excluir a Solicitacao

Pergunte("COMRD3",.F.) //Carrega Perguntas

If ! Empty(cSuperior)
	RecLock("SC1",.F.)
	C1_CODAPRO := cSuperior
	MsUnlock()
	
	U_COMWF002() //Envio dos Detalhes da Solicitacao
	
	If SC1->C1_ITEM == cTotItem
		U_COMWF001(cSuperior) //Envio do Resumo da Solicitacao
	EndIf
	
EndIf

Return


/*
Desc.     ³ Envia Workflow de Aprovacao de Solicitacao de Compras
³ Para quando a aprovacao e feita por SOLICITACAO
*/

User Function COMWF001(cAprov)

//³Declaração de Variaveis³
Local cMvAtt := GetMv("MV_WFHTML")
Local cMailSup := UsrRetMail(cAprov)
Local cCodProcesso, cCodStatus, cHtmlModelo, cMailID
Local cUsuarioProtheus, cCodProduto, cTexto, cAssunto

Private oHtml

cQuery := " SELECT C1_NUM, C1_EMISSAO, C1_SOLICIT, C1_ITEM, C1_PRODUTO, C1_DESCRI, C1_UM, C1_QUANT, C1_DATPRF, C1_OBS, C1_CC, C1_CODAPRO, C1_USER"
cQuery += " FROM SC1010"
cQuery += " WHERE C1_NUM = '"+SC1->C1_NUM+"'"

MemoWrit("COMWF001.sql",cQuery)
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)

TcSetField("TRB","C1_EMISSAO","D")
TcSetField("TRB","C1_DATPRF","D")

COUNT TO nRec
//CASO TENHA DADOS
If nRec > 0
	
	dbSelectArea("TRB")
	dbGoTop()
	
	cNumSc		:= TRB->C1_NUM
	cSolicit	:= TRB->C1_SOLICIT
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Muda o parametro para enviar no corpo do e-mail³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PutMv("MV_WFHTML","T")
	
	oProcess:=TWFProcess():New("000004","WORKFLOW PARA APROVACAO DE SC")
	oProcess:NewTask('Inicio',"\WORKFLOW\COMWF001.htm")
	oHtml   := oProcess:oHtml
	
	oHtml:ValByName("diasA"			, cDiasA)
	oHtml:ValByName("diasE"			, cDiasE)
	oHtml:ValByName("cNUM"			, TRB->C1_NUM)
	oHtml:ValByName("cEMISSAO"		, DTOC(TRB->C1_EMISSAO))
	oHtml:ValByName("cSOLICIT"		, TRB->C1_SOLICIT)
	oHtml:ValByName("cCODUSR"		, TRB->C1_USER)
	oHtml:ValByName("cAPROV"		, "")
//	oHtml:ValByName("cMOTIVO"		, "")
	oHtml:ValByName("it.ITEM"		, {})
	oHtml:ValByName("it.PRODUTO"	, {})
	oHtml:ValByName("it.DESCRI"		, {})
	oHtml:ValByName("it.UM"			, {})
	oHtml:ValByName("it.QUANT"		, {})
	oHtml:ValByName("it.DATPRF"		, {})
	oHtml:ValByName("it.OBS"		, {})
	oHtml:ValByName("it.CC"			, {})
	
	dbSelectArea("TRB")
	dbGoTop()
	While !EOF()
		aadd(oHtml:ValByName("it.ITEM")       ,TRB->C1_ITEM			) //Item Cotacao
		aadd(oHtml:ValByName("it.PRODUTO")    ,TRB->C1_PRODUTO		) //Cod Produto
		aadd(oHtml:ValByName("it.DESCRI")     ,TRB->C1_DESCRI		) //Descricao Produto
		aadd(oHtml:ValByName("it.UM")         ,TRB->C1_UM			) //Unidade Medida
		aadd(oHtml:ValByName("it.QUANT")      ,TRANSFORM( TRB->C1_QUANT,'@E 999,999.99' )) //Quantidade Solicitada
		aadd(oHtml:ValByName("it.DATPRF")     ,DTOC(TRB->C1_DATPRF)) //Data da Necessidade
		aadd(oHtml:ValByName("it.OBS")        ,TRB->C1_OBS			) //Observacao
//		aadd(oHtml:ValByName("it.CC")         ,TRB->C1_CC			) //Centro de Custo
		dbSkip()
	End
	
	//envia o e-mail
	cUser 				:= Subs(cUsuario,7,15)
	oProcess:ClientName(cUser)
	cAssunto    	    := "Liberação de SC - "+cNumSc+" - De: "+cSolicit
	
	oProcess:cSubject  	:= "Aprovação de SC - "+cNumSc+" - De: "+cSolicit
	oProcess:cTo        := "link" //nome da pasta
	
	oProcess:cBody    	:= ""
	oProcess:bReturn  	:= "U_COMWF01a()"
	oProcess:bTimeOut := {{"U_COMWF01b()", Val(cDiasA) , 0, 0 },{"U_COMWF01c()", Val(cDiasE) , 0, 0 }}
	
	cMailID := oProcess:Start()

	cHtmlModelo := "\workflow\wflink.htm"

	oProcess:NewTask(cAssunto, cHtmlModelo)  
	conout("(INICIO|WFLINK)Processo: " + oProcess:fProcessID + " - Task: " + oProcess:fTaskID )

	oProcess:cSubject := cAssunto

	oProcess:cTo    	:= cMailSup

	oProcess:ohtml:ValByName("usuario",cUser)
	oProcess:ohtml:ValByName("referente",cAssunto)

	oProcess:ohtml:ValByName("proc_link","http://SERVER2:83/wf/messenger/emp01/link/" + cMailID + ".htm")

// Adicione informacao a serem incluidas na rastreabilidade
	cTexto := "Enviando solicitação..."
	cCodStatus := "100300"

	oProcess:Start()

	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'1001','ENVIO DE WORKFLOW PARA APROVACAO DE SC')
	
	oProcess:Finish()
	oProcess:Free()
	oProcess:= Nil
	
	PutMv("MV_WFHTML",cMvAtt)
	
	TRB->(dbCloseArea())
	
	WFSendMail({"01","01"})
	
Else
	TRB->(dbCloseArea())
	MsgStop("Problemas no Envio do E-Mail de Aprovação!","ATENÇÃO!")
EndIf

Return


/*
Desc.     ³ Retor Workflow de Aprovacao de Solicitacao de Compras      º±±
³                                                            º±±
*/
User Function COMWF01a(oProcess)

Local cMvAtt := GetMv("MV_WFHTML")
Local cNumSc	:= oProcess:oHtml:RetByName("cNUM")
Local cSolicit	:= oProcess:oHtml:RetByName("cSOLICIT")
Local cEmissao	:= oProcess:oHtml:RetByName("cEMISSAO")
Local cAprov	:= oProcess:oHtml:RetByName("cAPROV")
Local cMotivo	:= oProcess:oHtml:RetByName("cMOTIVO")
Local cCodSol	:= oProcess:oHtml:RetByName("cCODUSR")
Local cMailSol 	:= UsrRetMail(cCodSol)
Private oHtml

ConOut("Aprovando SC: "+cNumSc)

cQuery := " UPDATE SC1010"
cQuery += " SET C1_APROV = '"+cAprov+"'"
cQuery += " WHERE C1_NUM = '"+cNumSc+"'"

MemoWrit("COMWF01a.sql",cQuery)
TcSqlExec(cQuery)
TCREFRESH(RetSqlName("SC1"))


//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
//RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004",'1002',"RETOR DE WORKFLOW PARA APROVACAO DE SC",cUsername)
RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'1002','RETOR DE WORKFLOW PARA APROVACAO DE SC')

oProcess:Finish()
oProcess:Free()
oProcess:= Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia Envio de Mensagem de Aviso³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutMv("MV_WFHTML","T")

oProcess:=TWFProcess():New("000004","WORKFLOW PARA APROVACAO DE SC")
If cAprov == "L" //Verifica se foi aprovado
	oProcess:NewTask('Inicio',"\WORKFLOW\COMWF005.htm")
ElseIf cAprov == "R" //Verifica se foi rejeitado
	oProcess:NewTask('Inicio',"\WORKFLOW\COMWF006.htm")
EndIf
oHtml   := oProcess:oHtml

oHtml:valbyname("Num"		, cNumSc)
oHtml:valbyname("Req"    	, cSolicit)
oHtml:valbyname("Emissao"   , cEmissao)
oHtml:valbyname("Motivo"   , cMotivo)
oHtml:valbyname("it.Item"   , {})
oHtml:valbyname("it.Cod"  	, {})
oHtml:valbyname("it.Desc"   , {})

cQuery2 := " SELECT C1_ITEM, C1_PRODUTO, C1_DESCRI"
cQuery2 += " FROM SC1010"
cQuery2 += " WHERE C1_NUM = '"+cNumSc+"'"

MemoWrit("COMWF01a.sql",cQuery2)
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery2),"TRB", .F., .T.)

COUNT TO nRec
//CASO TENHA DADOS
If nRec > 0
	
	dbSelectArea("TRB")
	dbGoTop()
	
	While !EOF()
		aadd(oHtml:ValByName("it.Item")		, TRB->C1_ITEM)
		aadd(oHtml:ValByName("it.Cod")		, TRB->C1_PRODUTO)
		aadd(oHtml:ValByName("it.Desc")		, TRB->C1_DESCRI)
		dbSkip()
	End
	
EndIf
TRB->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcoes para Envio do Workflow³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//envia o e-mail
cUser 			  := Subs(cUsuario,7,15)
oProcess:ClientName(cUser)

CONOUT("e-MAIL: "+cMailSol)
CONOUT("USERCOD "+cCodSol)
oProcess:cTo	  := cMailSol
//oProcess:cBCC     := "fabiano@assystem.com.br"
If cAprov == "L" //Verifica se foi aprovado
	oProcess:cSubject := "SC N°: "+cNumSc+" - Aprovada"
ElseIf cAprov == "R" //Verifica se foi rejeitado
	oProcess:cSubject := "SC N°: "+cNumSc+" - Reprovada"
EndIf
oProcess:cBody    := ""
oProcess:bReturn  := ""
oProcess:Start()

//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
If cAprov == "L" //Verifica se foi aprovado
	//	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004",'1005',"APROVACAO DE WORKFLOW DE SC",cUsername)
	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10005','APROVACAO DE WORKFLOW DE SC')
ElseIf cAprov == "R" //Verifica se foi rejeitado
	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10006','REJEICAO DE WORKFLOW DE SC')
EndIf

oProcess:Free()
oProcess:Finish()
oProcess:= Nil

PutMv("MV_WFHTML",cMvAtt)

WFSendMail({"01","01"})

Return

/*
Desc.     ³ Envia um Aviso para Aprovador apos periodo de TIMEOUT      º±±
³                                                            º±±
*/
User Function COMWF01b(oProcess)

Local cMvAtt 	:= GetMv("MV_WFHTML")
Local cNumSc	:= oProcess:oHtml:RetByName("cNUM")
Local cSolicit	:= oProcess:oHtml:RetByName("cSOLICIT")
Local cEmissao	:= oProcess:oHtml:RetByName("cEMISSAO")
Local cDiasA	:= oProcess:oHtml:RetByName("diasA")
Local cDiasE	:= oProcess:oHtml:RetByName("diasE")
Private oHtml

ConOut("AVISO POR TIMEOUT SC:"+cNumSc+" Solicitante:"+cSolicit)

oProcess:Free()
oProcess:= Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia Envio de Mensagem de Aviso³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutMv("MV_WFHTML","T")

oProcess:=TWFProcess():New("000004","WORKFLOW PARA APROVACAO DE SC")
oProcess:NewTask('Inicio',"\WORKFLOW\COMWF003.htm")
oHtml   := oProcess:oHtml

oHtml:valbyname("Num"		, cNumSc)
oHtml:valbyname("Req"    	, cSolicit)
oHtml:valbyname("Emissao"   , cEmissao)
oHtml:valbyname("diasA"   	, cDiasA)
oHtml:valbyname("diasE"   	, Val(cDiasE)-Val(cDiasA))
oHtml:valbyname("it.Item"   , {})
oHtml:valbyname("it.Cod"  	, {})
oHtml:valbyname("it.Desc"   , {})

cQuery := " SELECT C1_ITEM, C1_PRODUTO, C1_DESCRI, C1_CODAPRO"
cQuery += " FROM SC1010"
cQuery += " WHERE C1_NUM = '"+cNumSc+"'"

MemoWrit("COMWF01b.sql",cQuery)
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)

COUNT TO nRec
//CASO TENHA DADOS
If nRec > 0
	
	dbSelectArea("TRB")
	dbGoTop()
	cMailSup := UsrRetMail(TRB->C1_CODAPRO)
	While !EOF()
		aadd(oHtml:ValByName("it.Item")		, TRB->C1_ITEM)
		aadd(oHtml:ValByName("it.Cod")		, TRB->C1_PRODUTO)
		aadd(oHtml:ValByName("it.Desc")		, TRB->C1_DESCRI)
		dbSkip()
	End
	
EndIf
TRB->(dbCloseArea())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcoes para Envio do Workflow³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//envia o e-mail
cUser 			  := Subs(cUsuario,7,15)
oProcess:ClientName(cUser)
oProcess:cTo	  := cMailSup
//oProcess:cBCC     := "fabiano@assystem.com.br"
oProcess:cSubject := "Aviso de TimeOut de SC N°: "+cNumSc+" - De: "+cSolicit
oProcess:cBody    := ""
oProcess:bReturn  := ""
oProcess:Start()
//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
//RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004",'1003',"TIMEOUT DE WORKFLOW PARA APROVACAO DE SC",cUsername)
RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10003','TIMEOUT DE WORKFLOW PARA APROVACAO DE SC')
oProcess:Free()
oProcess:Finish()
oProcess:= Nil

PutMv("MV_WFHTML",cMvAtt)

WFSendMail({"01","01"})

Return

/*
Desc.     ³ Exclui a solicitacao apos um periodo de TIMEOUT            º±±
³                                                            º±±
*/
User Function COMWF01c(oProcess)

Local cMvAtt 	:= GetMv("MV_WFHTML")
Local cNumSc	:= oProcess:oHtml:RetByName("cNUM")
Local cSolicit	:= oProcess:oHtml:RetByName("cSOLICIT")
Local cEmissao	:= oProcess:oHtml:RetByName("cEMISSAO")
Local cDiasA	:= oProcess:oHtml:RetByName("diasA")
Local cDiasE	:= oProcess:oHtml:RetByName("diasE")
Local cCodSol	:= RetCodUsr(cSolicit)
Local cMailSol 	:= UsrRetMail(cCodSol)
Local aCab := {}
Local aItem:= {}
Private oHtml

ConOut("EXCLUSAO POR TIMEOUT SC:"+cNumSc+" Solicitante:"+cSolicit)

cQuery := " SELECT C1_ITEM, C1_PRODUTO, C1_DESCRI, C1_CODAPRO"
cQuery += " FROM SC1010"
cQuery += " WHERE C1_NUM = '"+cNumSc+"'"

MemoWrit("COMWF01b.sql",cQuery)
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)

COUNT TO nRec
//CASO TENHA DADOS
If nRec > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia MsExecAuto da Exclusao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TRB")
	dbGoTop()
	cMailSup := UsrRetMail(TRB->C1_CODAPRO)
	While !EOF()
		lMsErroAuto := .F.
		aCab:= {		{"C1_NUM",cNumSc,NIL}}
		Aadd(aItem, {	{"C1_ITEM",TRB->C1_ITEM,NIL}})
		
		Begin Transaction
		MSExecAuto({|x,y,z| mata110(x,y,z)},aCab,aItem,5) //Exclusao
		End Transaction
		
		dbSkip()
	End
	
	oProcess:Finish()
	oProcess:Free()
	oProcess:= Nil
	
	PutMv("MV_WFHTML","T")
	
	oProcess:=TWFProcess():New("000004","WORKFLOW PARA APROVACAO DE SC")
	oProcess:NewTask('Inicio',"\WORKFLOW\COMWF004.htm")
	oHtml   := oProcess:oHtml
	
	oHtml:valbyname("Num"		, cNumSc)
	oHtml:valbyname("Req"    	, cSolicit)
	oHtml:valbyname("Emissao"   , cEmissao)
	oHtml:valbyname("diasE"		, cDiasE)
	oHtml:valbyname("it.Item"   , {})
	oHtml:valbyname("it.Cod"  	, {})
	oHtml:valbyname("it.Desc"   , {})
	
	dbSelectArea("TRB")
	dbGoTop()
	
	While !EOF()
		aadd(oHtml:ValByName("it.Item")		, TRB->C1_ITEM)
		aadd(oHtml:ValByName("it.Cod")		, TRB->C1_PRODUTO)
		aadd(oHtml:ValByName("it.Desc")		, TRB->C1_DESCRI)
		dbSkip()
	End
	
EndIf
TRB->(dbCloseArea())

//³Funcoes para Envio do Workflow³

//envia o e-mail
cUser 			  := Subs(cUsuario,7,15)
oProcess:ClientName(cUser)
oProcess:cTo	  := cMailSup+";"+cMailSol
//oProcess:cBCC     := "fabiano@assystem.com.br"
oProcess:cSubject := "Exclusão por TimeOut - SC N°: "+cNumSc+" - De: "+cSolicit
oProcess:cBody    := ""
oProcess:bReturn  := ""
oProcess:Start()
//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
//RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004",'1004',"TIMEOUT EXCLUSAO DE WORKFLOW PARA APROVACAO DE SC",cUsername)
RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'1004','TIMEOUT EXCLUSAO DE WORKFLOW PARA APROVACAO DE SC')
oProcess:Free()
oProcess:Finish()
oProcess:= Nil

PutMv("MV_WFHTML",cMvAtt)

WFSendMail({"01","01"})

Return



/*
Desc.     ³ Envia Workflow de Aprovacao de Solicitacao de Compras
³ Para quando a aprovacao e feita por ITEM
*/
User Function COMWF002()

Local cMvAtt    := GetMv("MV_WFHTML")
Local cAprov    := PswRet()[1][11]
Local cMailSup  := Alltrim(UsrRetMail(cAprov))
LOCAL aMeses	:= {"Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez"}
Local cMailSol 	:= Alltrim(UsrRetMail(RetCodUsr()))
Private oHtml

cQuery := " SELECT C1_FILIAL, C1_NUM, C1_EMISSAO, C1_SOLICIT, C1_ITEM, C1_PRODUTO, C1_DESCRI, C1_UM, C1_QUANT, C1_DATPRF, C1_OBS, C1_CC, C1_CODAPRO, C1_QUJE, C1_LOCAL, B2_QATU, B1_EMIN, B1_QE, B1_UPRC"
cQuery += " FROM SC1"+xFILIAL("SC1")+"0 AS C1"
cQuery += " INNER JOIN SB2"+xFILIAL("SB2")+"0 AS B2 ON C1_PRODUTO = B2_COD AND C1_LOCAL = B2_LOCAL"
cQuery += " INNER JOIN SB1"+xFILIAL("SB1")+"0 AS B1 ON C1_PRODUTO = B1_COD"
cQuery += " WHERE C1_NUM = '"+SC1->C1_NUM+"'"
cQuery += " AND C1_ITEM = '"+SC1->C1_ITEM+"'"

MemoWrit("COMWF002.sql",cQuery)
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)

TcSetField("TRB","C1_EMISSAO","D")
TcSetField("TRB","C1_DATPRF","D")

COUNT TO nRec
//CASO TENHA DADOS
If nRec > 0
	
	dbSelectArea("TRB")
	TRB->(dbGoTop())
	
	cNumSc		:= TRB->C1_NUM
	cSolicit	:= TRB->C1_SOLICIT
	cItem		:= TRB->C1_ITEM
	
	//³Muda o parametro para enviar no corpo do e-mail³
	PutMv("MV_WFHTML","T")
	
	oProcess:=TWFProcess():New("000004","WORKFLOW PARA APROVACAO DE SC")
	oProcess:NewTask('Inicio',"\WORKFLOW\COMWF002.htm")
	oHtml   := oProcess:oHtml
	
	oHtml:ValByName("diasA"			, cDiasA)
	oHtml:ValByName("diasE"			, cDiasE)
	oHtml:ValByName("Num"		, TRB->C1_NUM				) //Numero da Cotacao
	oHtml:ValByName("Item1"		, TRB->C1_ITEM 				) //Item Cotacao
	oHtml:ValByName("Req"	  	, TRB->C1_SOLICIT			) //Nome Requisitante
	oHtml:ValByName("Emissao"	, DTOC(TRB->C1_EMISSAO)		) //Data de Emissao Solicitacao
	
	//³Saldos em Estoque³
	oHtml:ValByName("Item"		, TRB->C1_ITEM		   		) //Item Cotacao
	oHtml:ValByName("CodProd"	, TRB->C1_PRODUTO	   		) //Cod Produto
	oHtml:ValByName("Desc"		, TRB->C1_DESCRI			) //Descricao Produto
	oHtml:ValByName("SaldoAtu"	, TRANSFORM(TRB->B2_QATU  		, PesqPict("SB2","B2_QATU" ,12))	) //Saldo Atual Estoque
	oHtml:ValByName("EstMin"	, TRANSFORM(TRB->B1_EMIN		, PesqPict("SB1","B1_EMIN" ,12))	) //Ponto de Pedido
	oHtml:ValByName("QuantSol"	, TRANSFORM(TRB->C1_QUANT - TRB->C1_QUJE , PesqPict("SC1","C1_QUANT",12))) //Saldo da Solicitacao
	oHtml:ValByName("UM"		, TRANSFORM(TRB->C1_UM			, PesqPict("SC1","C1_UM"))			) //Unidade de Medida
	oHtml:ValByName("Local"		, TRANSFORM(TRB->C1_LOCAL		, PesqPict("SC1","C1_LOCAL"))		) //Armazem da Solicitacao
	oHtml:ValByName("QuantEmb"	, TRANSFORM(TRB->B1_QE			, PesqPict("SB1","B1_QE"   ,09))	) //Quantidade Por Embalagem
	oHtml:ValByName("UPRC"		, TRANSFORM(TRB->B1_UPRC		, PesqPict("SB1","B1_UPRC",12))		) //Ultimo Preco de Compra
	oHtml:ValByName("Lead" 		, TRANSFORM(CalcPrazo(TRB->C1_PRODUTO,TRB->C1_QUANT), "999")		) //Lead Time
	oHtml:ValByName("DataNec"	, If(Empty(TRB->C1_DATPRF),TRB->C1_EMISSAO,TRB->C1_DATPRF)			)//Data da Necessidade
	oHtml:ValByName("DataCom"	, SomaPrazo(If(Empty(TRB->C1_DATPRF),TRB->C1_EMISSAO,TRB->C1_DATPRF), -CalcPrazo(TRB->C1_PRODUTO,TRB->C1_QUANT)))// Data para Comprar
	oHtml:ValByName("Obs"		, TRANSFORM(TRB->C1_OBS , "@!")										) //Observacao da Cotacao
	                                               
	//³Consumo Ultimos 12 Meses³
	//Query busca Consumo do produto
	  
	//³Ultimos Pedidos de Compra ³
	oHtml:ValByName("it.NumP"			, {})
	oHtml:ValByName("it.ItemP"			, {})
	oHtml:ValByName("it.CodP"			, {})
	oHtml:ValByName("it.LjP"			, {})
	oHtml:ValByName("it.NomeP"			, {})
	oHtml:ValByName("it.QtdeP"			, {})
	oHtml:ValByName("it.UMP"			, {})
	oHtml:ValByName("it.VlrUnP"			, {})
	oHtml:ValByName("it.VlrTotP"		, {})
	oHtml:ValByName("it.EmiP"			, {})
	oHtml:ValByName("it.NecP"			, {})
	oHtml:ValByName("it.PraP"			, {})
	oHtml:ValByName("it.CondP"			, {})
	oHtml:ValByName("it.QtdeEntP"		, {})
	oHtml:ValByName("it.SalP"			, {})
	oHtml:ValByName("it.EliP"			, {})
	
	//Query busca Pedidos do Produto
	cQuery3 := " SELECT C7_NUM, C7_ITEM, C7_FORNECE, C7_LOJA, A2_NOME, C7_QUANT, C7_UM, C7_PRECO, C7_TOTAL, C7_EMISSAO, C7_DATPRF, C7_COND, C7_QUJE, C7_RESIDUO"
	cQuery3 += " FROM SC7"+xFILIAL("SC7")+"0 AS C7"
	cQuery3 += " INNER JOIN SA2010 AS A2 ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA"
	cQuery3 += " WHERE C7_FILIAL = '"+TRB->C1_FILIAL+"' AND C7_PRODUTO = '"+TRB->C1_PRODUTO+"'"
	cQuery3 += " AND C7.D_E_L_E_T_ <> '*'"
	cQuery3 += " AND A2.D_E_L_E_T_ <> '*'"
	cQuery3 += " ORDER BY C7_EMISSAO DESC"
	
	MemoWrit("COMWF002c.sql",cQuery3)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery3),"TRB3", .F., .T.)
	
	TcSetField("TRB3","C7_EMISSAO","D")
	TcSetField("TRB3","C7_DATPRF","D")
	
	COUNT TO nRec3
	//CASO TENHA DADOS
	If nRec3 > 0
		
		dbSelectArea("TRB3")
		TRB3->(dbGoTop())
		
		nContador := 0
		
		While !TRB3->(EOF())
			
			nContador++
			If nContador > 03 //Numero de Pedidos
				Exit
			EndIf
			
			aadd(oHtml:ValByName("it.NumP")			, TRB3->C7_NUM		)
			aadd(oHtml:ValByName("it.ItemP")		, TRB3->C7_ITEM		)
			aadd(oHtml:ValByName("it.CodP")			, TRB3->C7_FORNECE	)
			aadd(oHtml:ValByName("it.LjP")			, TRB3->C7_LOJA		)
			aadd(oHtml:ValByName("it.NomeP")		, TRB3->A2_NOME		)
			aadd(oHtml:ValByName("it.QtdeP")		, TRANSFORM(TRB3->C7_QUANT , PesqPict("SC7","C7_QUANT",14))	)
			aadd(oHtml:ValByName("it.UMP")			, TRB3->C7_UM		)
			aadd(oHtml:ValByName("it.VlrUnP")		, TRANSFORM(TRB3->C7_PRECO, PesqPict("SC7","c7_preco",14))	)
			aadd(oHtml:ValByName("it.VlrTotP")		, TRANSFORM(TRB3->C7_TOTAL, PesqPict("SC7","c7_total",14))	)
			aadd(oHtml:ValByName("it.EmiP")			, DTOC(TRB3->C7_EMISSAO))
			aadd(oHtml:ValByName("it.NecP")			, DTOC(TRB3->C7_DATPRF)	)
			aadd(oHtml:ValByName("it.PraP")			, TRANSFORM(Val(DTOC(TRB3->C7_DATPRF))-Val(DTOC(TRB3->C7_EMISSAO)), "999"))
			aadd(oHtml:ValByName("it.CondP")		, TRB3->C7_COND		)
			aadd(oHtml:ValByName("it.QtdeEntP")		, TRANSFORM(TRB3->C7_QUJE, PesqPict("SC7","C7_QUJE",14))		)
			aadd(oHtml:ValByName("it.SalP")			, TRANSFORM(If(Empty(TRB3->C7_RESIDUO),TRB3->C7_QUANT-TRB3->C7_QUJE,0), PesqPict("SC7","C7_QUJE",14)))
			aadd(oHtml:ValByName("it.EliP")			, If(Empty(TRB3->C7_RESIDUO),'Não','Sim'))
			
			TRB3->(dbSkip())
		End
		
	Else //Caso nao tenha dados
		
		aadd(oHtml:ValByName("it.NumP")			, "")
		aadd(oHtml:ValByName("it.ItemP")		, "")
		aadd(oHtml:ValByName("it.CodP")			, "")
		aadd(oHtml:ValByName("it.LjP")			, "")
		aadd(oHtml:ValByName("it.NomeP")		, "")
		aadd(oHtml:ValByName("it.QtdeP")		, "")
		aadd(oHtml:ValByName("it.UMP")			, "")
		aadd(oHtml:ValByName("it.VlrUnP")		, "")
		aadd(oHtml:ValByName("it.VlrTotP")		, "")
		aadd(oHtml:ValByName("it.EmiP")			, "")
		aadd(oHtml:ValByName("it.NecP")			, "")
		aadd(oHtml:ValByName("it.PraP")			, "")
		aadd(oHtml:ValByName("it.CondP")		, "")
		aadd(oHtml:ValByName("it.QtdeEntP")		, "")
		aadd(oHtml:ValByName("it.SalP")			, "")
		aadd(oHtml:ValByName("it.EliP")			, "")
		
	EndIf
	TRB3->(dbCloseArea())
	
	//³Ultimos Fornecedores³
	oHtml:ValByName("it1.CodF"			, {})
	oHtml:ValByName("it1.LjF"			, {})
	oHtml:ValByName("it1.NomeF"			, {})
	oHtml:ValByName("it1.TelF"			, {})
	oHtml:ValByName("it1.ContF"			, {})
	oHtml:ValByName("it1.FaxF"			, {})
	oHtml:ValByName("it1.UlComF"		, {})
	oHtml:ValByName("it1.MunicF"		, {})
	oHtml:ValByName("it1.UFF"			, {})
	oHtml:ValByName("it1.RisF"			, {})
	oHtml:ValByName("it1.CodForF"		, {})
	
	If mv_par03 == 1 // Amarracao por Produto
		
		//Query busca Fornecedores do Produto
		cQuery4 := " SELECT A5_FORNECE, A5_LOJA, A2_NOME, A2_TEL, A2_CONTATO, A2_FAX, A2_ULTCOM, A2_MUN, A2_EST, A2_RISCO, A5_CODPRF"
		cQuery4 += " FROM SA5010 AS A5"
		cQuery4 += " INNER JOIN SA2010 A2 ON A5_FORNECE = A2_COD AND A5_LOJA = A2_LOJA"
		cQuery4 += " WHERE A5_PRODUTO = '"+TRB->C1_PRODUTO+"'"
		cQuery4 += " AND A5.D_E_L_E_T_ <> '*'"
		cQuery4 += " AND A2.D_E_L_E_T_ <> '*'"
		cQuery4 += " order by  A2_ULTCOM DESC"
		
		MemoWrit("COMWF002d.sql",cQuery4)
		dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery4),"TRB4", .F., .T.)
		
		TcSetField("TRB4","A2_ULTCOM","D")
		
		COUNT TO nRec4
		//CASO TENHA DADOS
		If nRec4 > 0
			
			dbSelectArea("TRB4")
			TRB4->(dbGoTop())
			
			nContador := 0
			
			While !TRB4->(EOF())
				
				nContador++
				If nContador > 03 //Numero de Fornecedores
					Exit
				EndIf
				
				aadd(oHtml:ValByName("it1.CodF")		, TRB4->A5_FORNECE	) //Codigo do Fornecedor
				aadd(oHtml:ValByName("it1.LjF")			, TRB4->A5_LOJA		) //Codigo da Loja
				aadd(oHtml:ValByName("it1.NomeF")		, TRB4->A2_NOME		) //Nome do Fornecedor
				aadd(oHtml:ValByName("it1.TelF")		, TRB4->A2_TEL		) //Telefone do Fornecedor
				aadd(oHtml:ValByName("it1.ContF")		, TRB4->A2_CONTATO	) //Contato no Fornecedor
				aadd(oHtml:ValByName("it1.FaxF")		, TRB4->A2_FAX		) //Fax no Fornecedor
				aadd(oHtml:ValByName("it1.UlComF")		, DTOC(TRB4->A2_ULTCOM)	) //Ultima Compra com o Fornecedor
				aadd(oHtml:ValByName("it1.MunicF")		, TRB4->A2_MUN		) //Municipio do Fornecedor
				aadd(oHtml:ValByName("it1.UFF")			, TRB4->A2_EST		) //Estado do Fornecedor
				aadd(oHtml:ValByName("it1.RisF")		, TRB4->A2_RISCO	) //Risco do Fornecedor
				aadd(oHtml:ValByName("it1.CodForF")		, TRB4->A5_CODPRF	) //Codigo no Forncedor
				
				TRB4->(dbSkip())
			End
			
		Else //Caso nao tenha dados
			
			aadd(oHtml:ValByName("it1.CodF")		, ""	) //Codigo do Fornecedor
			aadd(oHtml:ValByName("it1.LjF")			, ""	) //Codigo da Loja
			aadd(oHtml:ValByName("it1.NomeF")		, ""	) //Nome do Fornecedor
			aadd(oHtml:ValByName("it1.TelF")		, ""	) //Telefone do Fornecedor
			aadd(oHtml:ValByName("it1.ContF")		, ""	) //Contato no Fornecedor
			aadd(oHtml:ValByName("it1.FaxF")		, ""	) //Fax no Fornecedor
			aadd(oHtml:ValByName("it1.UlComF")		, ""	) //Ultima Compra com o Fornecedor
			aadd(oHtml:ValByName("it1.MunicF")		, ""	) //Municipio do Fornecedor
			aadd(oHtml:ValByName("it1.UFF")			, ""	) //Estado do Fornecedor
			aadd(oHtml:ValByName("it1.RisF")		, ""	) //Risco do Fornecedor
			aadd(oHtml:ValByName("it1.CodForF")		, ""	) //Codigo no Forncedor
			
		EndIf
		TRB4->(dbCloseArea())
		
	Else
		
		//Query busca Fornecedores do Grupo de Produtos
		cQuery4 := " SELECT AD_FORNECE, AD_LOJA, A2_NOME, A2_TEL, A2_CONTATO, A2_FAX, A2_ULTCOM, A2_MUN, A2_EST, A2_RISCO"
		cQuery4 += " FROM SB1"+xFILIAL("SB1")+"0 AS B1"
		cQuery4 += " INNER JOIN SAD010 AS AD ON B1_GRUPO = AD_GRUPO"
		cQuery4 += " INNER JOIN SA2010 AS A2 ON AD_FORNECE = A2_COD AND AD_LOJA = A2_LOJA"
		cQuery4 += " WHERE B1_COD = '"+TRB->C1_PRODUTO+"'"
		cQuery4 += " AND AD.D_E_L_E_T_ <> '*'"
		cQuery4 += " AND A2.D_E_L_E_T_ <> '*'"
		cQuery4 += " AND B1.D_E_L_E_T_ <> '*'"
		cQuery4 += " ORDER BY  A2_ULTCOM DESC"
		
		MemoWrit("COMWF002d.sql",cQuery4)
		dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery4),"TRB4", .F., .T.)
		
		TcSetField("TRB4","A2_ULTCOM","D")
		
		COUNT TO nRec4
		//CASO TENHA DADOS
		If nRec4 > 0
			
			dbSelectArea("TRB4")
			TRB4->(dbGoTop())
			
			nContador := 0
			
			While !TRB4->(EOF())
				
				nContador++
				If nContador > 03 //Numero de Fornecedores
					Exit
				EndIf
				
				aadd(oHtml:ValByName("it1.CodF")		, TRB4->AD_FORNECE	) //Codigo do Fornecedor
				aadd(oHtml:ValByName("it1.LjF")			, TRB4->AD_LOJA		) //Codigo da Loja
				aadd(oHtml:ValByName("it1.NomeF")		, TRB4->A2_NOME		) //Nome do Fornecedor
				aadd(oHtml:ValByName("it1.TelF")		, TRB4->A2_TEL		) //Telefone do Fornecedor
				aadd(oHtml:ValByName("it1.ContF")		, TRB4->A2_CONTATO	) //Contato no Fornecedor
				aadd(oHtml:ValByName("it1.FaxF")		, TRB4->A2_FAX		) //Fax no Fornecedor
				aadd(oHtml:ValByName("it1.UlComF")		, DTOC(TRB4->A2_ULTCOM)	) //Ultima Compra com o Fornecedor
				aadd(oHtml:ValByName("it1.MunicF")		, TRB4->A2_MUN		) //Municipio do Fornecedor
				aadd(oHtml:ValByName("it1.UFF")			, TRB4->A2_EST		) //Estado do Fornecedor
				aadd(oHtml:ValByName("it1.RisF")		, TRB4->A2_RISCO	) //Risco do Fornecedor
				aadd(oHtml:ValByName("it1.CodForF")		, ""				) //Codigo no Forncedor
				TRB4->(dbSkip())
			End
			
		Else //Caso nao tenha dados
			
			aadd(oHtml:ValByName("it1.CodF")		, ""	) //Codigo do Fornecedor
			aadd(oHtml:ValByName("it1.LjF")			, ""	) //Codigo da Loja
			aadd(oHtml:ValByName("it1.NomeF")		, ""	) //Nome do Fornecedor
			aadd(oHtml:ValByName("it1.TelF")		, ""	) //Telefone do Fornecedor
			aadd(oHtml:ValByName("it1.ContF")		, ""	) //Contato no Fornecedor
			aadd(oHtml:ValByName("it1.FaxF")		, ""	) //Fax no Fornecedor
			aadd(oHtml:ValByName("it1.UlComF")		, ""	) //Ultima Compra com o Fornecedor
			aadd(oHtml:ValByName("it1.MunicF")		, ""	) //Municipio do Fornecedor
			aadd(oHtml:ValByName("it1.UFF")			, ""	) //Estado do Fornecedor
			aadd(oHtml:ValByName("it1.RisF")		, ""	) //Risco do Fornecedor
			aadd(oHtml:ValByName("it1.CodForF")		, ""	) //Codigo no Forncedor
			
		EndIf
		TRB4->(dbCloseArea())
		
	EndIf
	
	//³Funcoes para Envio do Workflow³

	//envia o e-mail
	cUser 			  := Alltrim(Subs(cUsuario,7,15))
	oProcess:ClientName(cUser)
	oProcess:cTo	  := cMailSup
	oProcess:cCC      := cMailSol
//	oProcess:cBCC     := "fabiano@assystem.com.br"
	oProcess:cSubject := "Aprovação de SC N°: "+cNumSc+" Item: "+cItem+" - De: "+cSolicit
	oProcess:cBody    := ""

	oProcess:bReturn  := "U_COMWF02a()"

	oProcess:Start()

	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','ENVIO DE WORKFLOW PARA APROVACAO DE SC')

	oProcess:Free()
	oProcess:Finish()
	oProcess:= Nil
	
	PutMv("MV_WFHTML",cMvAtt)
	
Else
	MsgStop("Foi encontrado um problema na Geração do E-Mail de Aprovação. Favor avisar o Depto de Informática. NREC =","ATENÇÃO!")
EndIf

TRB->(dbCloseArea())

Return


/*
Desc.     ³ Retor Workflow de Aprovacao de Solicitacao de Compras      º±±
³                                                            º±±
*/
User Function COMWF02a(oProcess)

Local cMvAtt := GetMv("MV_WFHTML")
Local cNumSc	:= oProcess:oHtml:RetByName("Num")
Local cItemSc	:= oProcess:oHtml:RetByName("Item")
Local cSolicit	:= oProcess:oHtml:RetByName("Req")
Local cEmissao	:= oProcess:oHtml:RetByName("Emissao")
Local cDiasA	:= oProcess:oHtml:RetByName("diasA")
Local cDiasE	:= oProcess:oHtml:RetByName("diasE")
Local cCod		:= oProcess:oHtml:RetByName("CodProd")
Local cDesc		:= oProcess:oHtml:RetByName("Desc")
Local cAprov	:= oProcess:oHtml:RetByName("cAPROV")
Local cMotivo	:= oProcess:oHtml:RetByName("cMOTIVO")

Private oHtml

ConOut("Atualizando SC:"+cNumSc+" Item:"+cItemSc)

cQuery := " UPDATE SC1010"
cQuery += " SET C1_APROV = '"+cAprov+"'"
cQuery += " WHERE C1_NUM = '"+cNumSc+"'"
cQuery += " AND C1_ITEM = '"+cItemSc+"'"

MemoWrit("COMWF02a.sql",cQuery)
TcSqlExec(cQuery)
TCREFRESH(RetSqlName("SC1"))

//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
//RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004",'1002',"RETOR DE WORKFLOW PARA APROVACAO DE SC",cUsername)
RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10002','RETOR DE WORKFLOW PARA APROVACAO DE SC')

oProcess:Finish()
oProcess:Free()
oProcess:= Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia Envio de Mensagem de Aviso³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutMv("MV_WFHTML","T")

oProcess:=TWFProcess():New("000004","WORKFLOW PARA APROVACAO DE SC")
If cAprov == "L" //Verifica se foi aprovado
	oProcess:NewTask('Inicio',"\WORKFLOW\COMWF005.htm")
ElseIf cAprov == "R" //Verifica se foi rejeitado
	oProcess:NewTask('Inicio',"\WORKFLOW\COMWF006.htm")
EndIf
oHtml   := oProcess:oHtml

oHtml:valbyname("Num"		, cNumSc)
oHtml:valbyname("Req"    	, cSolicit)
oHtml:valbyname("Emissao"   , cEmissao)
oHtml:valbyname("Motivo"   , cMotivo)
oHtml:valbyname("it.Item"   , {})
oHtml:valbyname("it.Cod"  	, {})
oHtml:valbyname("it.Desc"   , {})
aadd(oHtml:ValByName("it.Item")		, cItemSc)
aadd(oHtml:ValByName("it.Cod")		, cCod)
aadd(oHtml:ValByName("it.Desc")		, cDesc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcoes para Envio do Workflow³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//envia o e-mail
cUser 			  := Subs(cUsuario,7,15)
oProcess:ClientName(cUser)
oProcess:cTo	  := cMailSup
//oProcess:cBCC     := "fabiano@assystem.com.br"

If cAprov == "L" //Verifica se foi aprovado
	oProcess:cSubject := "SC N°: "+cNumSc+" - Item: "+cItemSc+" - Aprovada"
ElseIf cAprov == "R" //Verifica se foi rejeitado
	oProcess:cSubject := "SC N°: "+cNumSc+" - Item: "+cItemSc+" - Reprovada"
EndIf

oProcess:cBody    := ""
oProcess:bReturn  := ""
oProcess:Start()

//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
If cAprov == "L" //Verifica se foi aprovado
	//	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004",'1005',"TIMEOUT DE WORKFLOW PARA APROVACAO DE SC",cUsername)
	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10005','TIMEOUT DE WORKFLOW PARA APROVACAO DE SC')
ElseIf cAprov == "R" //Verifica se foi rejeitado
	//	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004",'1006',"TIMEOUT DE WORKFLOW PARA APROVACAO DE SC",cUsername)
	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10006','TIMEOUT DE WORKFLOW PARA APROVACAO DE SC')
EndIf

oProcess:Free()
oProcess:Finish()
oProcess:= Nil

PutMv("MV_WFHTML",cMvAtt)

WFSendMail({"01","01"})

Return

/*
Desc.     ³ Envia um Aviso para Aprovador apos periodo de TIMEOUT      º±±
³                                                            º±±
*/
User Function COMWF02b(oProcess)

Local cMvAtt 	:= GetMv("MV_WFHTML")
Local cNumSc	:= oProcess:oHtml:RetByName("Num")
Local cItemSc	:= oProcess:oHtml:RetByName("Item")
Local cSolicit	:= oProcess:oHtml:RetByName("Req")
Local cEmissao	:= oProcess:oHtml:RetByName("Emissao")
Local cDiasA	:= oProcess:oHtml:RetByName("diasA")
Local cDiasE	:= oProcess:oHtml:RetByName("diasE")
Local cCod		:= oProcess:oHtml:RetByName("CodProd")
Local cDesc		:= oProcess:oHtml:RetByName("Desc")
Private oHtml

ConOut("AVISO POR TIMEOUT SC:"+cNumSc+" Item:"+cItemSc+" Solicitante:"+cSolicit)

oProcess:Free()
oProcess:= Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia Envio de Mensagem de Aviso³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutMv("MV_WFHTML","T")

oProcess:=TWFProcess():New("000004","WORKFLOW PARA APROVACAO DE SC")
oProcess:NewTask('Inicio',"\WORKFLOW\COMWF003.htm")
oHtml   := oProcess:oHtml

oHtml:valbyname("Num"		, cNumSc)
oHtml:valbyname("Req"    	, cSolicit)
oHtml:valbyname("Emissao"   , cEmissao)
oHtml:valbyname("diasA"   	, cDiasA)
oHtml:valbyname("diasE"   	, Val(cDiasE)-Val(cDiasA))
oHtml:valbyname("it.Item"   , {})
oHtml:valbyname("it.Cod"  	, {})
oHtml:valbyname("it.Desc"   , {})
aadd(oHtml:ValByName("it.Item")		, cItemSc)
aadd(oHtml:ValByName("it.Cod")		, cCod)
aadd(oHtml:ValByName("it.Desc")		, cDesc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcoes para Envio do Workflow³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//envia o e-mail
cUser 			  := Subs(cUsuario,7,15)
oProcess:ClientName(cUser)
oProcess:cTo	  := cMailSup
//oProcess:cBCC     := "fabiano@assystem.com.br"
oProcess:cSubject := "Aviso de TimeOut de SC N°: "+cNumSc+" Item: "+cItemSc+" - De: "+cSolicit
oProcess:cBody    := ""
oProcess:bReturn  := ""
oProcess:Start()
//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
//RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004",'1003',"TIMEOUT DE WORKFLOW PARA APROVACAO DE SC",cUsername)
RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10003','TIMEOUT DE WORKFLOW PARA APROVACAO DE SC')
oProcess:Free()
oProcess:Finish()
oProcess:= Nil

PutMv("MV_WFHTML",cMvAtt)

WFSendMail({"01","01"})

Return

/*
Desc.     ³ Exclui a solicitacao apos um periodo de TIMEOUT
³
*/
User Function COMWF02c(oProcess)
Local cMvAtt 	:= GetMv("MV_WFHTML")
Local cNumSc	:= oProcess:oHtml:RetByName("Num")
Local cItemSc	:= oProcess:oHtml:RetByName("Item")
Local cSolicit	:= oProcess:oHtml:RetByName("Req")
Local cEmissao	:= oProcess:oHtml:RetByName("Emissao")
Local cDiasE	:= oProcess:oHtml:RetByName("diasE")
Local cCod		:= oProcess:oHtml:RetByName("CodProd")
Local cDesc		:= oProcess:oHtml:RetByName("Desc")
Local cCodSol	:= RetCodUsr(cSolicit)
Local cMailSol 	:= UsrRetMail(cCodSol)
Private oHtml

ConOut("EXCLUSAO POR TIMEOUT SC:"+cNumSc+" Item:"+cItemSc+" Solicitante:"+cSolicit)

cQuery := " UPDATE SC1010"
cQuery += " SET D_E_L_E_T_ = '*'"
cQuery += " WHERE C1_NUM = '"+cNumSc+"'"
cQuery += " AND C1_ITEM = '"+cItemSc+"'"

MemoWrit("COMWF02c.sql",cQuery)
TcSqlExec(cQuery)
TCREFRESH(RetSqlName("SC1"))

oProcess:Finish()
oProcess:Free()
oProcess:= Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia Envio de Mensagem de Aviso³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutMv("MV_WFHTML","T")

oProcess:=TWFProcess():New("000004","WORKFLOW PARA APROVACAO DE SC")
oProcess:NewTask('Inicio',"\WORKFLOW\COMWF004.htm")
oHtml   := oProcess:oHtml

oHtml:valbyname("Num"		, cNumSc)
oHtml:valbyname("Req"    	, cSolicit)
oHtml:valbyname("Emissao"   , cEmissao)
oHtml:valbyname("diasE"		, cDiasE)
oHtml:valbyname("it.Item"   , {})
oHtml:valbyname("it.Cod"  	, {})
oHtml:valbyname("it.Desc"   , {})
aadd(oHtml:ValByName("it.Item")		, cItemSc)
aadd(oHtml:ValByName("it.Cod")		, cCod)
aadd(oHtml:ValByName("it.Desc")		, cDesc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcoes para Envio do Workflow³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//envia o e-mail
cUser 			  := Subs(cUsuario,7,15)
oProcess:ClientName(cUser)
oProcess:cTo	  := cMailSup+";"+cMailSol
//oProcess:cBCC     := "fabiano@assystem.com.br"
oProcess:cSubject := "Exclusão por TimeOut - SC N°: "+cNumSc+" Item: "+cItemSc+" - De: "+cSolicit
oProcess:cBody    := ""
oProcess:bReturn  := ""
oProcess:Start()
//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
//RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000004",'1004',"TIMEOUT EXCLUSAO DE WORKFLOW PARA APROVACAO DE SC",cUsername)
RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10004','TIMEOUT EXCLUSAO DE WORKFLOW PARA APROVACAO DE SC')
oProcess:Free()
oProcess:Finish()
oProcess:= Nil

PutMv("MV_WFHTML",cMvAtt)

WFSendMail({"01","01"})

Return
