#INCLUDE 'TOTVS.CH'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recebendo email automaticamente ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function CR0097()
	
	Local oServer
	Local oMessage
	Local nAttach := 0, nI := 0
	Local nMessages := 0
	Local cAttach := "", cName := ""
	Local aAttInfo := {}
	Local xRet
	
	oServer := tMailManager():New()
	writePProString( "Mail", "Protocol", "POP3", getsrvininame() )
	
	oServer:SetUseSSL( .T. )
	xRet := oServer:Init( "mail.totvs.com.br", "", "username", "password", 995, 0 )
	if xRet <> 0
		conout( "Could not initialize mail server: " + oServer:GetErrorString( xRet ) )
		return
	endif
	
	xRet := oServer:POPConnect()
	if xRet <> 0
		conout( "Could not connect on POP3 server: " + oServer:GetErrorString( xRet ) )
		return
	endif
	
	oServer:GetNumMsgs( @nMessages )
	conout( "Number of messages: " + cValToChar( nMessages ) )
	
	oMessage := TMailMessage():New()
	oMessage:Clear()
	
	conout( "Receiving newest message" )
	xRet := oMessage:Receive( oServer, nMessages )
	if xRet <> 0
		conout( "Could not get message " + cValToChar( nMessages ) + ": " + oServer:GetErrorString( xRet ) )
		return
	endif
	
	nAttach := oMessage:GetAttachCount()
	for nI := 1 to nAttach
		aAttInfo := oMessage:GetAttachInfo( nI )
		cName := "\emails\"
		
		if aAttInfo[1] == ""
			cName += "message." + SubStr( aAttInfo[2], At( "/", aAttInfo[2] ) + 1, Len( aAttInfo[2] ) )
		else
			cName += aAttInfo[1]
		endif
		
		conout( "Saving attachment " + cValToChar( nI ) + ": " + cName )
		
		cAttach := oMessage:GetAttach( nI )
		xRet := MemoWrite( cName, cAttach )
		if !xRet
			conout( "Could not save attachment " + cValToChar( nI ) )
		endif
	next nI
	
	xRet := oServer:POPDisconnect()
	if xRet <> 0
		conout( "Could not disconnect from POP3 server: " + oServer:GetErrorString( xRet ) )
	endif
return










/*


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dados da conta POP ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cData         := DtoC(Date())
Local cHora         := Time()
Local cPathTmp     	:= "\xmlnfe\emp15\tmp\"
Local cPath         := "\xmlnfe\emp15\confirmadas"
Local nTotMsg      	:= 0
Local cServer      	:= "mail.minhaempresa.com.br"
Local cAccount      := "email@minhaempresa.com.br"
Local cPassword 	:= "senhadoemail"
Local lConectou 	:= .f.
Local cBody      	:=""
Local cTO           :=""
Local cFrom      	:=""
Local cCc           :=""
Local cBcc          :=""
Local cSubject      :=""
Local cCmdEnv      	:=""
Local nX        	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Conectado ao servidor POP ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CONNECT POP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lConectou
POP MESSAGE COUNT nTotMsg


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Total de mensagens ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nTotMsg>0
	Msgbox("Existem "+alltrim(str(nTotMsg,5,0))+" novas mensagens...","Atenção...","INFO")
Else
	Msgbox("Não existem novas mensagens...","Atenção...","INFO")
Endif


If lConectou
	//Msgbox("Não foi possível abrir a conta de E-mail!")
	//Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recebendo emails ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For w:=1 to nTotMsg
		aFiles:={}
		
		
		RECEIVE MAIL MESSAGE w FROM cFrom TO cTo CC cCc BCC cBcc SUBJECT cSubject BODY cBody ATTACHMENT aFiles SAVE IN (cPathTmp) DELETE
		
		For i:=1 to len(aFiles)
			If Right(aFiles[1],4) $ "#.xml#.XML#"
				Private nHdl := FOpen("\xmlnfe\emp15\tmp\log_salva_anexos_hist.txt",0,,.F.)
				cLog := StrTran(aFiles[1],‘ ‘,‘‘,1)+" "+cData+" "+cHora
				Acalog("\xmlnfe\emp15\tmp\log_salva_anexos_hist.txt",cLog)
				
				xFile := STRTRAN(lower(StrTran(aFiles[1],‘ ‘,‘‘,1)),cPathTmp,cPath)
				
				COPY FILE &aFiles[1] TO &xFile
				nX++
				FErase(aFiles[1])
			Else
				Private nHdl := FOpen("\xmlnfe\emp15\tmp\log_exc_anexos_hist.txt",0,,.F.)
				cLog := aFiles[1]+" "+cData+" "+cHora
				Acalog("\xmlnfe\emp15\tmp\log_exc_anexos_hist.txt",cLog)
				FErase(aFiles[1])
			EndIf
			
		Next
		
	Next
	//Msgbox("Acabei! Baixei "+Str(nX)+" anexos! :D","Atenção...","INFO")
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desconectando ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lConectou
	DISCONNECT POP SERVER Result lDisConectou
	//If !lDisConectou
	//     Alert ("Erro ao desconectar do Servidor de e-mail - " + cServer)
	//Endif
EndIf
Return
*/
