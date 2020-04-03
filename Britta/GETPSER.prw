#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

Static Function GetPSer(cCom,_CNUMBAL)

	lOCAL I,AX

	private nHdll   := 0
	private nVezes  := 3
	private nVez    := 0
	private nPBruto := 0
	private nTara   := 0
	private nPLiq   := 0
	private cText   := ""
	Private cText2  := ""
	Private _cTxtAux:= ""
	private nPos    := 0
	private cErro   := "N"
	private nMes    := 100
	private cMes    := ""
	private cOK     := "S"
	private I       := 0

	_cMaqUsu := Left(UPPER(Alltrim(ComputerName())),3)

	If !_cMaqUsu $ "IBA/IRO/SRV/ICC/ALE/FAS"

		//cOK := TesteAle(cText)

		While nPBruto == 0 .And. nVez < nVezes

			lprosseguir:= MsOpenPort(nHdll,cCom)

			If !lprosseguir
				cMsg := 'CC - Falha de ABERTURA da '+substr(cCom,1,4)+' !'
				nVez := nVezes
			Else
				nVez+=1
				Sleep(2000)
				lprosseguir := MSRead(nHdll,@cText)
				Sleep(2000)
				MemoWrite( "c:/temp/retorno_balanca.txt", cText)

				if !lprosseguir .Or. Empty(cText)
					cMsg := 'BB - falha na LEITURA da '+substr(cCom,1,4)+ ' !'
					nVez := nVezes
				else
					do case
					case cEmpAnt $ "14/34"
						cData  := '/'
						cText  := SubStr(cText,at(cData,cText)+19,7)

					otherwise
						nMes := 100
						cMes := ""
						For I = 1 TO 12

							nMes = nMes + 1

							npos   := at("/"+subst(alltrim(str(nMes)),2,2)+"/",cText)

							if  npos > 0
								cMes := "/"+subst(alltrim(str(nMes)),2,2)+"/"
								nVez := nVezes
							endif

						Next I

						If Empty(cMes)    // nPos == 0 // Nao é JUNDIAI

							//F u n c a o  p a r a  v e r i f i c a r  qual a Outra Balança

							cOK := smVerifBalanca(cText)

							nVez := nVezes
							if   cOK == "N"
								cText  := SubStr(cText, 01 , 31)
								//cMsg :=  "Peso não capturado, " + cText
								cMsg :=  "Peso não capturado"
							else
								cText := cText2
							endif

						else
							//Jundiai    --> 19/12/200222:2003    00000000019
							//               15/12/200217:310>    001530000

							//cText   := SubStr(cText,at(cMes,cText)+19,7)

							// INCLUIDO EM 06/01/20 - ALEXANDRO
							_cTEXT2 := ""

							For AX:= 1 TO Len(cText)
								_cTEXT2 := SUBSTR(cText,AX,30)

								AX+= 29

								If Empty(Substr(cText,AX+1,30))
									AX:= Len(cText)
								Endif
							Next

							cText  := SubStr(_cTEXT2,5,7)

							// INCLUIDO EM 06/01/20 - ALEXANDRO

						endif
					endcase
					nPBruto := Val(cText)/1000
				Endif
			Endif

			nHdll := 0
			cText := ''

			MsClosePort(nHdll)

		EndDo
	Else
		cMsg   := ""

		If _cMaqUsu $ "IBA/ICC/SRV/ALE/FAS"
			_cSeq   :=  cValtoChar(VAL(_CNUMBAL)-1)
			_cIP    :=  GETMV("BRI_BALIP"+_cSeq)
			_cPorta :=  GETMV("BRI_BALPO"+_cSeq)
		Else
			_cSeq   :=  cValtoChar(VAL(_CNUMBAL)-1)
			_cIP    :=  GETMV("BRI_BALIP"+_cSeq)
			_cPorta :=  GETMV("BRI_BALPOR")
		Endif

		oObj    := tSocketClient():New()         	// Cria um objeto do tipo Socket Client.
		cRet    := 0								// Variável utilizada para armazenar o retorno da pesagem.

		_ip     := alltrim(_cIP)					// Atribui a variável o IP do módulo de pesagem.
		_port   := val(_cPorta)					    // Atribui a variável a porta do módulo de pesagem.
		_timeout:= 02							    // Atribui a variável o tempo para comunicaçðo com o módulo de pesagem.

		cBarraStatus:= 'Iniciando ... '

		nResp := oObj:Connect( _port, _ip, _timeout )

		If (nResp == 0 )
			cBarraStatus:= "Conexðo OK!  IP:  "+_ip+"  Porta: "+str(_port,5)

			If ( oObj:IsConnected() )
				cBarraStatus:="OK! Conectado ... " + time()

				cBuffer := ""
				xAux    := ""
				nCont   := 1

				nQtd := oObj:Receive( @cBuffer, 10000 )	// Tento obter resposta aguardando por n milisegundos.

				If nQtd > 0
					While nQtd > 0 .and. nCont < 16
						cBuffer := ""
						nQtd    := oObj:Receive( @cBuffer, 10000 )
						xaux    += cbuffer
						ncont++
					EndDo
					If cEmpAnt == "50" .And. cFilAnt = "07"
						cRet:= substr( xAux, at( ')', xAux )+2, 7 )
	
						If Val(cRet) == 0
							cMsg := 'Sem peso na balança.'
						Endif
		
						/*
						npos   := at(")",cBuffer)     // Toledo 3
						cText  := cBuffer
						cRet   := "0"
						If npos > 0
							_cTEXT3 := cText
							cTEXT2  := ""

							For AX:= 1 TO Len(cText)

								npos   := at(")",_cTEXT3)

								If npos > 0
									_cTEXT3 := SUBSTR(_cTEXT3,NPOS+1,LEN(cText))
									cTEXT2 := SUBSTR(_cTEXT3,4,5)
								Else
									AX:= Len(cText)
								Endif
							Next

							cText := cTEXT2
							cRet  := SubStr(cTEXT2,5,7)

							If Val(cRet) == 0
								cMsg := 'Sem peso na balança.'
							Endif
						Endif
						*/
					Else
						cRet:=  substr( xAux, at( '+', xAux )+1, 7 )
					Endif
				Else
					cRet:='0'
				Endif

				if empty(cret) .or. val( cret ) == 0 .or. len(cret) < 7 .or. 'k' $ cRet	// Verifica se o peso é válido.
					cRet := '0'
				endif
			Else
				cBarraStatus := "Ops! Nao Conectado ...  " + time()	// Informa no console se nðo obteve êxito na comunicaçðo com o módulo
				_cMsg := "Nao Conectado"
				cRet  := '0'								// Retorna peso Zero
			Endif
		Else
			cBarraStatus:= "Erro na Conexðo! "			//  Erro na conexðo com o equipamento.
			//Conout( cBarraStatusRet , nResp  )
			_cMsg := "Nao Conectado"
			cRet  := '0'
		endif

		nPBruto :=	Val(cRet) / 1000

		//conout( cBarraStatus )

		oObj:CloseConnection()      					// Fecha a conexðo com o módulo
		If( !oObj:IsConnected() )						// Verifica se nðo tem conexðo ativa
			cBarraStatus := 	"Desconectado ... " + time()	// Se nðo tiver ativo, desconectado com sucesso.
		Else
			cBarraStatus := 	"Falha ao tentar Desconectar !!! " + time()	// Falha ao desconectar.
			_cMsg := "Nao Conectado"
		Endif
		//conout( cBarraStatus )							// Registra no console.

	Endif

	If !empty(cMsg)
		nPBruto := 0.00
	Elseif nPBruto > 0
		cMsg := 'Peso capturado com sucesso!'
	Elseif !empty(cMes)
		cMsg := 'Sem peso na balança.'
	Else
		cMsg := 'problema na captura do peso.'
	Endif

	oGetBal:CtrlRefresh()


Return nPBruto


//
//  Verificar se é TOLEDO OU ALPHA ou Jundiai sp-600
//
static function smVerifBalanca(cText)

	Local AX
	local    cModelo := ""
	local    nPeso  := 0

	If cEmpAnt == "50" .And. cFilAnt = "07"
		npos   := at(")",cText)     // Toledo 3
		If npos > 0

			cModelo := "T3"

			_cTEXT3 := cText

			For AX:= 1 TO Len(cText)

				npos   := at(")",_cTEXT3)

				If npos > 0
					_cTEXT3 := SUBSTR(_cTEXT3,NPOS+1,LEN(cText))
					cTEXT2 := SUBSTR(_cTEXT3,4,5)
				Else
					AX:= Len(cText)
				Endif
			Next

			cText := cTEXT2
		Endif
	Else
		npos   := at("10 ",cText)     // Toledo 2
		if   npos > 0
			cModelo := "T2"

			_cTEXT3 := cText

			For AX:= 1 TO Len(cText)

				npos   := at("10",_cTEXT3)

				If npos > 0
					_cTEXT3 := SUBSTR(_cTEXT3,NPOS+2,LEN(cText))
					cTEXT2 := SUBSTR(_cTEXT3,3,5)
				Else
					AX:= Len(cText)
				Endif
			Next

			cText := cTEXT2

		else
			npos := at("q",cText)  // Toledo 1
			if   npos > 0
				cModelo := "T1"

				_cTEXT3 := cText

				For AX:= 1 TO Len(cText)

					npos   := at("q0",_cTEXT3)

					If npos > 0

						_cTEXT3 := SUBSTR(_cTEXT3,NPOS+2,LEN(cText))
						cTEXT2 := SUBSTR(_cTEXT3,3,5)
					Else
						AX:= Len(cText)
					Endif
				Next

				cText := cTEXT2
			Else
				npos := at(")p`",cText)  // Toledo 4
				if   npos > 0
					cModelo := "T4"

					_cTEXT3 := cText

					For AX:= 1 TO Len(cText)

						npos   := at(")p`",_cTEXT3)

						If npos > 0

							_cTEXT3 := SUBSTR(_cTEXT3,NPOS+2,LEN(cText))
							cTEXT2 := SUBSTR(_cTEXT3,3,5)
						Else
							AX:= Len(cText)
						Endif
					Next

					cText := cTEXT2

				Else
					npos   := at("PB:",cText)  // Alpha
					if  npos > 0
						cModelo := "A1"
					else
						npos   := at(")0",cText)  // Toledo 3
						if  npos > 0
							cModelo := "T3"
						else
							//    00167700
							npos   := at("    0",cText)  // Jundiai sp-600
							if  npos > 0
								cModelo := "J1"

								cTEXT3 := CTEXT

								For AX:= 1 TO Len(cText)

									npos   := at("    0",cTEXT3)

									If npos > 0
										cTEXT3 := SUBSTR(cTEXT3,NPOS+4,LEN(cText))

										cTEXT2 := SUBSTR(cTEXT3,1,7)

									Else
										AX:= Len(cText)
									Endif
								Next

								cText := cTEXT2
							else
								npos   := at("ST,GS",cText)  // Jundiai
								If  npos > 0
									cModelo := "J2"
								Else
									If cEmpAnt == "50" .And. cFilAnt = "10"
										npos   := at("ST,NT",cText)
										If  npos > 0
											cModelo := "J3"
										Else
											cOK := "N"
										Endif
									Else
										If cEmpAnt == "50" .And. cFilAnt = "09"
											npos   := at("i+",cText)
											If  npos > 0
												cModelo := "5009"
											Else
												cOK := "N"
											Endif
										Else
											If cEmpAnt == "50" .And. cFilAnt = "16"
												npos   := at("*U",cText)
												If  npos > 0
													cModelo := "5010"
												Else
													cOK := "N"
												Endif
											Else
												cOK := "N"
											Endif
										Endif
									Endif
								Endif
							Endif
						Endif
					Endif
				endif
			endif
		Endif
	Endif
// Balança Toledo-> q0 029960000000
	if  cModelo == "T1"
		//cText  := SubStr(cText,at("q",cText)+3,6)
		cMes   := "BALANÇA TOLEDO"
	elseif cModelo == "T2"    /// 50-08  PX-ICC
		// TOLEDO outro modelo 10   1160
		//                     10  22460
		//cText  := SubStr(cText,at("10 ",cText)+3,6)
		//cText  := StrTran(cText," ", "0", 1)
		cMes   := "BALANÇA TOLEDO outro modelo"
	elseif cModelo == "T3"
		// TOLEDO outro modelo 00| )0  21090    00|)0  21090

		//cText  := SubStr(cText,at(")",cText)+5,6) -- 13/01/2020 - ALEXANDRO
		//cText  := StrTran(cText," ", "0", 1)		   -- 13/01/2020 - ALEXANDRO
		cMes   := "BALANÇA TOLEDO outro modelo"

	elseif cModelo == "T4"
		// TOLEDO modelo  )p`000910000000

		cMes   := "BALANÇA TOLEDO outro modelo"

	elseif cModelo == "A1"
		//ALPHA PB: 000980
		//PB: 000980 T: 000000PB: 000980 T: 000000PB: 000980
		//PB: 019480 T: 000000

		cText  := SubStr(cText,at("PB:",cText)+4,6)
		cText  := StrTran(cText," ", "0", 1)
		//cText  := cText + "00"
		cMes   := "BALANÇA ALPHA"
	elseif cModelo == "J1"
		// Jundiai sp-600
		//    00167700
		//"    0",cText
		//cText  := SubStr(cText,at("    0",cText)+4,7)
		//cText  := StrTran(cText," ", "0", 1)
		cMes   := "Balança Juandiai sp-600"

	elseif cModelo == "J2"
		// Jundiai sp-860
		//    00167700
		//"    0",cText
		cText  := SubStr(cText,at("GS,+",cText)+4,7)

		//cText  := SubStr(cText,8,7)
		//cText  := StrTran(cText," ", "0", 1)
		cMes   := "Balança Jundiai sp-860"
	ElseIf cModelo == "J3"
		// Jundiai sp-860
		//    00167700
		//"    0",cText
		cText  := SubStr(cText,at("NT,+",cText)+4,7)
		cMes   := "Balança Jundiai sp-860"
	ElseIf cModelo == "5009"
		cText  := SubStr(cText,at("i+",cText)+2,6)
		cMes   := "Balança Confiantec"
	ElseIf cModelo == "5010"
		cText  := SubStr(cText,at("*U",cText)+7,6)
		cMes   := "Balança Confiantec - INHAUMA"
	Else
		cOK := "N"
	Endif

	cText2 := cText

Return cOK


Static Function testeale(cText)

	Local AX
	local    cModelo := ""
	local    nPeso  := 0

//cText  := SubStr(cText,at("    0",cText)+4,7)

	If cEmpAnt+cFilAnt == "5004"

		nHdlConf:=FOPEN("C:\TEMP\50-04_Retorno_balanca.txt",0)
		FREAD(nHdlConf,@cText,500)

		cTEXT3 := CTEXT

		For AX:= 1 TO Len(cText)

			npos   := at("    0",cTEXT3)

			If npos > 0
				cTEXT3 := SUBSTR(cTEXT3,NPOS+4,LEN(cText))

				cTEXT2 := SUBSTR(cTEXT3,1,7)

			Else
				AX:= Len(cText)
			Endif
		Next
	ElseIf cEmpAnt+cFilAnt == "5007"

		nHdlConf:=FOPEN("C:\TEMP\50-07_Retorno_balanca.txt",0)
		FREAD(nHdlConf,@cText,500)

		cTEXT3 := CTEXT

		For AX:= 1 TO Len(cText)

			npos   := at(")",cTEXT3)

			If npos > 0
				cTEXT3 := SUBSTR(cTEXT3,NPOS+1,LEN(cText))

				cTEXT2 := SUBSTR(cTEXT3,4,5)

			Else
				AX:= Len(cText)
			Endif
		Next

	ElseIf cEmpAnt+cFilAnt == "5006"
	/*
	nHdlConf:=FOPEN("C:\TEMP\50-06_Retorno_balanca.txt",0)
	FREAD(nHdlConf,@cText,500)

	_cTEXT3 := cText

		For AX:= 1 TO Len(cText)
			
		npos   := at("q0",_cTEXT3)
			
			If npos > 0

			_cTEXT3 := SUBSTR(_cTEXT3,NPOS+2,LEN(cText))
			cTEXT2 := SUBSTR(_cTEXT3,3,4)
			Else
			AX:= Len(cText)
			Endif
		Next
	*/

		nHdlConf:=FOPEN("C:\TEMP\50-06_Retorno_balanca.txt",0)
		FREAD(nHdlConf,@cText,500)

		_cTEXT3 := cText

		For AX:= 1 TO Len(cText)

			npos   := at(")p`",_cTEXT3)

			If npos > 0

				_cTEXT3 := SUBSTR(_cTEXT3,NPOS+2,LEN(cText))
				cTEXT2 := SUBSTR(_cTEXT3,3,4)
			Else
				AX:= Len(cText)
			Endif
		Next

	ElseIf cEmpAnt+cFilAnt == "5008"

		nHdlConf:=FOPEN("C:\TEMP\50-08_Retorno_balanca.txt",0)
		FREAD(nHdlConf,@cText,500)

		_cTEXT3 := cText

		For AX:= 1 TO Len(cText)

			npos   := at("10",_cTEXT3)

			If npos > 0
				_cTEXT3 := SUBSTR(_cTEXT3,NPOS+2,LEN(cText))
				cTEXT2 := SUBSTR(_cTEXT3,3,5)
			Else
				AX:= Len(cText)
			Endif
		Next

	Endif

	cText := cTEXT2


	If (cEmpAnt == "21") .Or. (cEmpAnt == "50" .And. cFilAnt = "07")
		npos   := at(")",cText)     // Toledo 3
		if   npos > 0
			cModelo := "T3"
		Endif
	Else
		npos   := at("10 ",cText)     // Toledo 2
		if   npos > 0
			cModelo := "T2"
		else
			npos := at("q",cText)  // Toledo 1
			if   npos > 0
				cModelo := "T1"

				// INCLUIDO EM 09/01/2020

				_cTEXT3  := ""

				For AX:= 1 TO Len(cText)
					_cTEXT3 := SUBSTR(cText,AX,15)

					AX+= 14

					If Empty(Substr(cText,AX+1,15))
						AX:= Len(cText)
					Endif
				Next

				cText  := _cTEXT3

				// INCLUIDO EM 09/01/2020

			Else
				npos   := at("PB:",cText)  // Alpha
				if  npos > 0
					cModelo := "A1"
				else
					npos   := at(")0",cText)  // Toledo 3
					if  npos > 0
						cModelo := "T3"
					else
						//    00167700
						npos   := at("    0",cText)  // Jundiai sp-600
						if  npos > 0
							cModelo := "J1"
						else
							npos   := at("ST,GS",cText)  // Jundiai
							If  npos > 0
								cModelo := "J2"
							Else
								If cEmpAnt == "50" .And. cFilAnt = "10"
									npos   := at("ST,NT",cText)
									If  npos > 0
										cModelo := "J3"
									Else
										cOK := "N"
									Endif
								Else
									If cEmpAnt == "50" .And. cFilAnt = "09"
										npos   := at("i+",cText)
										If  npos > 0
											cModelo := "5009"
										Else
											cOK := "N"
										Endif
									Else
										If cEmpAnt == "50" .And. cFilAnt = "16"
											npos   := at("*U",cText)
											If  npos > 0
												cModelo := "5010"
											Else
												cOK := "N"
											Endif
										Else
											cOK := "N"
										Endif
									Endif
								Endif
							Endif
						Endif
					Endif
				Endif
			endif
		endif
	Endif

// Balança Toledo-> q0 029960000000
	if  cModelo == "T1"
		cText  := SubStr(cText,at("q",cText)+3,6)
		cMes   := "BALANÇA TOLEDO"
	elseif cModelo == "T2"
		// TOLEDO outro modelo 10   1160
		//                     10  22460
		cText  := SubStr(cText,at("10 ",cText)+3,6)
		cText  := StrTran(cText," ", "0", 1)
		cMes   := "BALANÇA TOLEDO outro modelo"
	elseif cModelo == "T3"
		// TOLEDO outro modelo 00| )0  21090    00|)0  21090

		cText  := SubStr(cText,at(")",cText)+5,6)
		cText  := StrTran(cText," ", "0", 1)
		cMes   := "BALANÇA TOLEDO outro modelo"

	elseif cModelo == "A1"
		//ALPHA PB: 000980
		//PB: 000980 T: 000000PB: 000980 T: 000000PB: 000980
		//PB: 019480 T: 000000

		cText  := SubStr(cText,at("PB:",cText)+4,6)
		cText  := StrTran(cText," ", "0", 1)
		//cText  := cText + "00"
		cMes   := "BALANÇA ALPHA"
	elseif cModelo == "J1"
		// Jundiai sp-600
		//    00167700
		//"    0",cText
		cText  := SubStr(cText,at("    0",cText)+4,7)
		cText  := StrTran(cText," ", "0", 1)
		cMes   := "Balança Juandiai sp-600"

	elseif cModelo == "J2"
		// Jundiai sp-860
		//    00167700
		//"    0",cText
		cText  := SubStr(cText,at("GS,+",cText)+4,7)

		//cText  := SubStr(cText,8,7)
		//cText  := StrTran(cText," ", "0", 1)
		cMes   := "Balança Jundiai sp-860"
	ElseIf cModelo == "J3"
		// Jundiai sp-860
		//    00167700
		//"    0",cText
		cText  := SubStr(cText,at("NT,+",cText)+4,7)
		cMes   := "Balança Jundiai sp-860"
	ElseIf cModelo == "5009"
		cText  := SubStr(cText,at("i+",cText)+2,6)
		cMes   := "Balança Confiantec"
	ElseIf cModelo == "5010"
		cText  := SubStr(cText,at("*U",cText)+7,6)
		cMes   := "Balança Confiantec - INHAUMA"
	Else
		cOK := "N"
	Endif

	cText2 := cText

Return cOK



User function bals(_nPBruto,_nTara,_nPLiq,_nPrUnit,_nVlTot)

	lOCAL q

	Local	nQtdBal		:= SuperGetMV("MV_YSMQTBL",,1)
	Local	aNomeBals	:= {}
	Local	aPtBals		:= {}
	Local 	oFont		:= TFont():New("Tahoma",,22,,.T.)
	Private	cMsg		:= " "
	Private	_nPBruto,oDlg,oGetBal

	for q:=1 to nQtdBal
		cQ := cValtoChar(q)
		AAdd(aNomeBals,SuperGetMV("MV_YSMNBL"+cQ,,"Balança "+cQ))
		AAdd(aPtBals  ,SuperGetMV("MV_YSMCBL"+cQ,,"COM"+cQ+":9600,N,8,1"))
	next q

	aTam 			:= MsAdvSize(.F.)

	oDlg 			:= TDialog():New(aTam[7],0,(aTam[6]/4)+(((aTam[6]/5)/3)*nQtdBal),aTam[5]/3,"Captura Peso",,,,,,,,,.T.)

	aAreaT1			:= {aTam[1],aTam[2],aTam[3]/3,aTam[4]/7+(((aTam[4]/5)/3)*nQtdBal),5,3}
	nDivisoes1		:= nQtdBal+1
	aProp1			:= {}
	for q:=1 to nQtdBal
		AAdd(aProp1,{0,(85+nQtdBal)/nQtdBal})
	next q
	AAdd(aProp1,{0,15-nQtdBal})
	oArea1			:= redimensiona():New(aAreaT1,nDivisoes1,aProp1,.F.)
	aArea1			:= oArea1:RetArea()

	for q:=1 to nQtdBal
		cQ 					:= cValtoChar(q+1)
		&("aAreaT"+cQ)		:= {aArea1[q,2],aArea1[q,1],aArea1[q,4],aArea1[q,3],0,0}
		&("nDivisoes"+cQ)	:= 2
		&("aProp"+cQ)		:= {{70,0},{30,0}}
		&("oArea"+cQ)		:= redimensiona():New(&("aAreaT"+cQ),&("nDivisoes"+cQ),&("aProp"+cQ),.T.)
		&("aArea"+cQ)		:= &("oArea"+cQ):RetArea()

		&("bSay"+cQ)		:= "{|| '"+aNomeBals[q]+"' }"
		//&("bBtn"+cQ)		:= "{|| _nPBruto := getPSer('"+aPtBals[q]+"'), _nPLiq := _nPBruto - _nTara, _nVlTot := _nPrUnit * _nPLiq }"
		&("bBtn"+cQ)		:= "{|| _nPBruto := getPSer('"+aPtBals[q]+"','"+cQ+"'), _nPLiq := _nPBruto - _nTara, _nVlTot := _nPrUnit * _nPLiq }"

		oSayBal		:= TSay():New(&("aArea"+cQ)[1,1],&("aArea"+cQ)[1,2],&(&("bSay"+cQ)),oDlg,"@!",oFont,,,;
			,.T.,,,&("aArea"+cQ)[1,4]-&("aArea"+cQ)[1,2],&("aArea"+cQ)[1,3]-&("aArea"+cQ)[1,1])
		oBtBal		:= TButton():New(&("aArea"+cQ)[2,1],&("aArea"+cQ)[2,2],"Capturar Peso",oDlg,&(&("bBtn"+cQ));
			,&("aArea"+cQ)[2,4]-&("aArea"+cQ)[2,2],(&("aArea"+cQ)[2,3]-&("aArea"+cQ)[2,1])/2,,,,.T.)

		//TGroup():New(aArea1[q,1],aArea1[q,2],aArea1[q,3],aArea1[q,4],"tst"+cQ,oDlg,,,.T.)
	next q

	oGetBal			:= TGet():New(aArea1[q,1],aArea1[q,2],{|u| If(PCount() > 0 , cMsg := u, cMsg) },oDlg,;
		aArea1[q,4]-aArea1[q,2],aArea1[q,3]-aArea1[q,1],"@!",,0,,,.F.,,.T.,,.F.,;
		,.F.,.F.,,.F.,.F.,,cMsg,,,,)

	oDlg:Activate()

Return