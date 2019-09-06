#INCLUDE "TOTVS.ch"
#INCLUDE "TBICONN.CH"

/*/
Funçao    	³ 	CR0047
Autor 		³ 	Fabiano da Silva
Data 		³ 	18.10.13
Descricao 	³ 	997 Functional Acknowledgment - Caterpillar Exportação(000017)
/*/

User Function CR0047()

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

Private _cCATFold	:= GetMV("CR_CATFOLD")


//	LOCAL oDlg := NIL
//
//	PRIVATE cTitulo    	:= "Functional Acknowledgment"
//	PRIVATE oPrn       	:= NIL
//
//	_nOpc := 0
//
//	DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
//	@ 004,010 TO 060,157 LABEL "" OF oDlg PIXEL
//
//	@ 15,165 BUTTON "OK" 		 SIZE 036,012 ACTION (_nOpc := 1,oDlg:End()) 	OF oDlg PIXEL
//	@ 40,165 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL
//
//	ACTIVATE MSDIALOG oDlg CENTERED
//
//	If _nOpc = 1
//
//		Private _lFim      := .F.
//		Private _cMsg01    := ''
//		Private _lAborta01 := .T.
//		Private _bAcao01   := {|_lFim| CR047A(@_lFim) }
//		Private _cTitulo01 := 'Processando'
//		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
//
//	Endif
//
//Return(Nil)
//
//
//
//Static Function CR047A(_lFim)

U_CR0041() //Aloca os arquivos nas pastas corretas.

_cDir := _cCATFold+"Exportacao\Download\997\"

aListFile	:= Directory( _cDir + '*.txt' )

ProcRegua(Len( aListFile ))

For nI:=1 To Len( aListFile )

	IncProc()

	cFile := AllTrim(aListFile[nI][1])

	FT_FUSE( _cDir + cFile )
	FT_FGOTOP()

	Do While !FT_FEOF()

		cBuffer := FT_FREADLN()

		cBuffer := STRTRAN(cBuffer,'*',' *')

		aLin := StrTokArr( cBuffer , "*" )

		If Len(aLin) > 0

			If Alltrim(aLin[1]) == 'ISA'		//Interchange Control Header
				/*
				ISA02	:= Authorization Information Qualifier
				ISA03	:= Authorization Information
				ISA04	:= Security Information Qualifier
				ISA05	:= Security Information
				ISA06	:= Interchange ID Qualifier
				ISA07	:= Interchange Sender ID
				ISA08	:= Interchange ID Qualifier
				ISA09	:= Interchange Receiver Qualifier
				ISA10	:= Interchange Date
				ISA11	:= Interchange Time
				ISA12	:= Interchange Control Standarts Identifier
				ISA13	:= Interchange Control Version Number
				ISA14	:= Interchange Control Number
				ISA15	:= Acknowledgement Request
				ISA16	:= Test Indicator
				ISA17	:= Subelement Separator
				*/
				_cData := Alltrim(aLin[10])
				_cHora := Alltrim(aLin[11])

				If Alltrim(aLin[17]) == 'T' //Se for Teste
					FT_FUSE() //Fecha o arquivo
					Exit
				Endif

			ElseIf Alltrim(aLin[1]) == 'GS' 	//Functional Group Header
			ElseIf Alltrim(aLin[1]) == 'ST'	//Transaction Set Header
				/*
				ST02 := Transaction Set Identifier Code
				ST03 := Transaction Set Control Number
				*/

				If Alltrim(aLin[2]) != '997' //Se não for Functional Acknowledgment
					FT_FUSE() //Fecha o arquivo
					Exit
				Endif

			ElseIf Alltrim(aLin[1]) == 'AK1'	//Functional Group Response Header
				/*
				AK102 := Functional Identifier Code
				AK103 := Group Control Number
				*/
			ElseIf Alltrim(aLin[1]) == 'AK2'	//Transaction Set Response Header
				/*
				AK102 := Transaction Set Identifier Code
				AK103 := Transaction Set Control Number
				*/
				If Alltrim(aLin[2]) = '997'
					_lBKP  := .T.
					_cPast := '997\'
					Exit
				Endif
				_cTipo    := If(Alltrim(aLin[2]) == '810','I',(If(Alltrim(aLin[2]) = '856','A','')))
				_cControl := Right('000000000'+Alltrim(aLin[3]),9)

			ElseIf Alltrim(aLin[1]) == 'AK3'	//Data Segment Note
			ElseIf Alltrim(aLin[1]) == 'AK4'	//Data Element Note
			ElseIf Alltrim(aLin[1]) == 'AK5'	//Transaction Set Response Trailer
			ElseIf Alltrim(aLin[1]) == 'AK9'	//Functional Group Response Trailer
				/*
				AK902 := Functional Group Acknowledge Code
				AK903 := Number of Transaction Sets Included
				AK904 := Number of Received Transaction Sets
				AK905 := Number of Accepted Transaction Sets
				AK906 := Functional Group Syntax Error Code
				AK907 := Functional Group Syntax Error Code
				AK908 := Functional Group Syntax Error Code
				AK909 := Functional Group Syntax Error Code
				AK910 := Functional Group Syntax Error Code
				*/

				_cStatus := Alltrim(aLin[2])

				CR047B(_cData,_cHora,_cTipo,_cControl,_cStatus,cFile)

				_lBKP := .T.

				If !_cStatus $ ('AE') .Or. Empty(_cTipo)
					_lBKP := .F.
				Endif

				_cPast := "BKP\"

			ElseIf Alltrim(aLin[1]) == 'SE'	//Transaction Set Trailer
			ElseIf Alltrim(aLin[1]) == 'GE'	//Functional Group Trailer
			ElseIf Alltrim(aLin[1]) == 'IEA'	//Interchange Control Trailer
			Endif

		Endif

		FT_FSKIP()

	EndDo

	FT_FUSE()

	If _lBKP
		_cData    := GravaData(dDataBase,.f.,8)
		_cHora    := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

		__CopyFile( _cDir +cFile, _cDir+ _cPast +_cData+_cHora+"_"+cFile )
		FErase(_cDir +cFile)

	Endif
Next NI

Return


Static Function CR047B(_cData,_cHora,_cTipo,_cControl,_cStatus,cFile)

Private _lRet

nOpcao := 0

SZH->(dbSetOrder(2))
If SZH->(msSeek(xFilial('SZH')+_cTipo+_cControl))

	_cTime1 := Substr(Time(),1,2)
	_cTime2 := Substr(Time(),4,2)

	_cProcesso := SZH->ZH_PROCESS
	_cEnvio    := Alltrim(SZH->ZH_ENVIO)
	_cRetorno  := dToc(dDatabase) + ' - ' + _cTime1+':'+_cTime2

	SZH->(RecLock('SZH',.F.))
	SZH->ZH_RETORNO	:= _cRetorno
	SZH->ZH_STATUS	:= _cStatus
	SZH->(MsUnlock())

	EEC->(dbSetOrder(1))
	If EEC->(msSeek(xFilial('EE9')+_cProcesso))

		_cEmbarq 	:= Dtoc(EEC->EEC_DTEMBA)

		SA1->(dbSetOrder(1))
		SA1->(msSeek(xFilial('SA1')+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))

		_cCliente 	:= EEC->EEC_IMPORT+'-'+EEC->EEC_IMLOJA
		_cNome    	:= SA1->A1_NOME
		_cNomPais 	:=  Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_PAIS_I")
		_cEnd	  	:= Alltrim(SA1->A1_ADDRESS)+' - '+Alltrim(SA1->A1_CITY)+' - '+Alltrim(SA1->A1_STATE)+' - '+Alltrim(SA1->A1_POSCODE)+' - '+Alltrim(_cNomPais)

		ConOut("Enviando E-Mail Functional Acknowledgment")

		oProcess := TWFProcess():New( "ENVEM1", "997" )

		If _cTipo == 'I'

			_cTotal 	:= Transform(EEC->EEC_TOTPED,'@E 99,999.99')
			_cPrevisao  := Dtoc(EEC->EEC_DTEMBA+EEC->EEC_DIASPA)
			_cFacility	:= SA1->A1_ENDINV

			If _cStatus = 'A'
				oProcess:NewTask( "Functional Acknowledgment", "\WORKFLOW\CR047IA.HTM" )
			ElseIf _cStatus = 'E'
				oProcess:NewTask( "Functional Acknowledgment", "\WORKFLOW\CR047IE.HTM" )
			ElseIf _cStatus = 'P'
				oProcess:NewTask( "Functional Acknowledgment", "\WORKFLOW\CR047IP.HTM" )
			ElseIf _cStatus = 'R'
				oProcess:NewTask( "Functional Acknowledgment", "\WORKFLOW\CR047IR.HTM" )
			Endif

			oProcess:bReturn  := ""
			oProcess:bTimeOut := ""
			oHTML 			  := oProcess:oHTML

			oProcess:cSubject := "Functional Acknowledgment Invoice "+_cProcesso+" - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

			oHtml:ValByName("processo"	, _cProcesso )
			oHtml:ValByName("cliente"	, _cCliente )
			oHtml:ValByName("nome"		, _cNome )
			oHtml:ValByName("end"		, _cEnd )
			oHtml:ValByName("facility"	, _cFacility )
			oHtml:ValByName("embarq"	, _cEmbarq )
			oHtml:ValByName("envio"		, _cEnvio )
			oHtml:ValByName("retorno"	, _cRetorno )
			oHtml:ValByName("total"		, _cTotal )
			oHtml:ValByName("previsao"	, _cPrevisao )

		Else


			_cFacility	:= SA1->A1_ENDASN

			If _cStatus = 'A'
				oProcess:NewTask( "Functional Acknowledgment", "\WORKFLOW\CR047AA.HTM" )
			ElseIf _cStatus = 'E'
				oProcess:NewTask( "Functional Acknowledgment", "\WORKFLOW\CR047AE.HTM" )
			ElseIf _cStatus = 'P'
				oProcess:NewTask( "Functional Acknowledgment", "\WORKFLOW\CR047AP.HTM" )
			ElseIf _cStatus = 'R'
				oProcess:NewTask( "Functional Acknowledgment", "\WORKFLOW\CR047AR.HTM" )
			Endif

			oProcess:bReturn  := ""
			oProcess:bTimeOut := ""
			oHTML 			  := oProcess:oHTML

			oProcess:cSubject := "Functional Acknowledgment ASN "+_cProcesso+" - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

			oHtml:ValByName("processo"	, _cProcesso )
			oHtml:ValByName("cliente"	, _cCliente )
			oHtml:ValByName("nome"		, _cNome )
			oHtml:ValByName("end"		, _cEnd )
			oHtml:ValByName("facility"	, _cFacility )
			oHtml:ValByName("embarq"	, _cEmbarq )
			oHtml:ValByName("envio"		, _cEnvio )
			oHtml:ValByName("retorno"	, _cRetorno )

			//				oHtml:ValByName("ccronnos"		, {})
			//				oHtml:ValByName("ccliente"		, {})
			//				oHtml:ValByName("po"			, {})
			//				oHtml:ValByName("qtdefat"		, {})
			//				oHtml:ValByName("qtdeemb"		, {})
			//				oHtml:ValByName("qtdepem"		, {})

			EE9->(dbSetOrder(2))
			If EE9->(msSeek(xFilial('EE9')+_cProcesso))

				While !EOF() .And. Alltrim(_cProcesso) == Alltrim(EE9->EE9_PREEMB)

					AADD((oHtml:ValByName( "it.codcron" 	)), Alltrim(EE9->EE9_COD_I		))
					AADD((oHtml:ValByName( "it.codclie"  	)), Alltrim(EE9->EE9_PART_N		))
					AADD((oHtml:ValByName( "it.po"  		)), Alltrim(EE9->EE9_REFCLI		))
					AADD((oHtml:ValByName( "it.qtdefat"  	)), TRANSFORM( EE9->EE9_SLDINI	,  '@E 99,999' 	))
					AADD((oHtml:ValByName( "it.qtdeemb"  	)), TRANSFORM( EE9->EE9_QTDEM1	,  '@E 999' 	))
					AADD((oHtml:ValByName( "it.qtdepem"  	)), TRANSFORM( EE9->EE9_QE		,  '@E 99,999' 	))

					EE9->(dbSkip())
				EndDo
			Endif
		Endif

		oProcess:fDesc := "Functional Acknowledgment"

		Private _cTo := _cCC := ""

		_cZG := ''
		If _cTipo = 'A' //ASN
			_cZG := 'A'
		Else
			_cZG := 'B' //Invoice
		Endif

		SZG->(dbsetOrder(1))
		SZG->(dbGotop())

		While SZG->(!EOF())

			If _cZG+'1' $ SZG->ZG_ROTINA
				_cTo += If(Empty(_cTo),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
			ElseIf _cZG+'2' $ SZG->ZG_ROTINA
				_cCC += If(Empty(_cCC),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
			Endif

			SZG->(dbSkip())
		Enddo

		oProcess:cTo := _cTo
		oProcess:cCC := _cCC

		oProcess:Start()

		oProcess:Finish()

		_cFile := _cData+_cHora+"_"+cFile

		SZ0->(dbsetOrder(1))
		If !SZ0->(msSeek(xFilial("SZ0")+Alltrim(EEC->EEC_PREEMB)))
			_cSeq := "001"
		Else
			_cKey := xFilial("SZ0")+Alltrim(EEC->EEC_PREEMB)

			While !SZ0->(EOF()) .And. _cKey == SZ0->Z0_FILIAL+Alltrim(SZ0->Z0_DOC)

				_cSeq := Soma1(SZ0->Z0_SEQUENC)

				SZ0->(dbSkip())
			EndDo
		Endif

		_aCampos := {}
		aAdd( _aCampos, { 'Z0_DOC'		, Alltrim(EEC->EEC_PREEMB) 	} )
		aAdd( _aCampos, { 'Z0_SERIE'  	, ''						} )
		aAdd( _aCampos, { 'Z0_SEQUENC' 	, _cSeq						} )
		aAdd( _aCampos, { 'Z0_DATA'  	, dDataBase	 				} )
		aAdd( _aCampos, { 'Z0_TIPO'  	, '997'       	   			} )
		aAdd( _aCampos, { 'Z0_TIPO2'  	, 'U'						} )
		aAdd( _aCampos, { 'Z0_CLIENTE'  , EEC->EEC_IMPORT	  		} )
		aAdd( _aCampos, { 'Z0_LOJA'  	, EEC->EEC_IMLOJA   		} )
		aAdd( _aCampos, { 'Z0_FILE'  	, _cFile     				} )

		//Grava na tabela SZ0
		U_CR0070( 'SZ0', _aCampos,'CR0096' )

	Endif
Endif

Return
