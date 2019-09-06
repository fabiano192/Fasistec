#INCLUDE "TOTVS.ch"
#INCLUDE "TBICONN.CH"

/*/
Funçao    	³ 	CR0049
Autor 		³ 	Fabiano da Silva
Data 		³ 	13.11.13
Descricao 	³ 	824 Application Advice - Caterpillar Exportação(000017)
/*/

User Function CR0049()

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

	Private _cCATFold	:= GetMV("CR_CATFOLD")

/*
	LOCAL oDlg := NIL

	PRIVATE cTitulo    	:= "Application Advice"
	PRIVATE oPrn       	:= NIL

	_nOpc := 0

	DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
	@ 004,010 TO 060,157 LABEL "" OF oDlg PIXEL

	@ 15,165 BUTTON "OK" 		 SIZE 036,012 ACTION (_nOpc := 1,oDlg:End()) 	OF oDlg PIXEL
	@ 40,165 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	If _nOpc = 1

		Private _lFim      := .F.
		Private _cMsg01    := ''
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| CR049A(@_lFim) }
		Private _cTitulo01 := 'Processando'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

	Endif

Return(Nil)



Static Function CR049A(_lFim)
	*/

	ConOut("824 - Application Advice")

	Private _cStatus	:= _cTable := _cControl := _cPack := _cPo := _cPart := _cMessage := _cBadElem := ''
	Private _lBKP       := .T.

	U_CR0041() //Aloca os arquivos nas pastas corretas.

	_cDir := _cCATFold+"Exportacao\Download\824\"

	aListFile	:= Directory( _cDir + '*.txt' )

	ProcRegua(Len( aListFile ))

	For nI:=1 To Len( aListFile )

		IncProc()

		cFile := AllTrim(aListFile[nI][1])

		FT_FUSE( _cDir + cFile )
		FT_FGOTOP()

		_lBKP := .T.

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

					If Alltrim(aLin[2]) != '824' //Se não for Functional Acknowledgment
						FT_FUSE() //Fecha o arquivo
						Exit
					Endif
				ElseIf Alltrim(aLin[1]) == 'BGN'	//Beginning Segment
					/*
					BGN02 := Transaction Set Purpose Code
					BGN03 := Reference Number
					BGN04 := Date
					BGN05 := Time
					*/

				ElseIf Alltrim(aLin[1]) == 'N1'	//Name
					/*
					N102 := Entity Identifier Code
						SF	-	Ship From
						ST	-	Ship To
					N103 := Name
					N104 := Identification Code Qualifier
					N105 := Identification Code
					*/

				ElseIf Alltrim(aLin[1]) == 'OTI'	//Original Transaction Identification
					/*
					OTI02 := Application Acknowledgment Code
						GR	-	Functional Group Reject
						IE	-	Item Accept with Error
						IR	-	Item Reject
						TR	-	Transaction Set Reject
					OTI03 := Reference Number Qualifier
						IV	-	Seller's Invoice Number
						SI	-	Shipper's Identifying Number for Shipment
						TN	-	Transaction Reference Number
					OTI04 := Reference Number
					OTI05 := ?
					OTI06 := ?
					OTI07 := ?
					OTI08 := ?
					OTI09 := ?
					OTI19 := ?
					OTI11 := Transaction Set Identifier Code
						810	-	X12.2 Invoice
						856	-	X12.10 Ship Notice/Manifest
						870	-	X12.23 Order Status Report
					*/
					_cStatus :=	_cTable := ''

					If Alltrim(aLin[2]) = 'GR'
						_cStatus := 'Grupo Rejeitado'
					ElseIf Alltrim(aLin[2]) = 'IE'
						_cStatus := 'Item aceito com Erros'
					ElseIf Alltrim(aLin[2]) = 'IR'
						_cStatus := 'Item Rejeitado'
					ElseIf Alltrim(aLin[2]) = 'TR'
						_cStatus := 'Transação Rejeitada'
					Endif

					If Alltrim(aLin[11]) = '810'
						_cTable := 'ZD'
					ElseIf Alltrim(aLin[11]) = '856'
						_cTable := 'ZC'
					Endif

					_cControl := Alltrim(aLin[4])

				ElseIf Alltrim(aLin[1]) == 'REF'	//Reference Numbers
					/*
					REF02 := Referece Number Qualifier
						LI	-	Line Item Identifier (Seller's)
						P7	-	Product Line Number
						PK	-	Packing List Number
						PM	-	Part Number
						PO	-	Purchase Order Number
					REF03 := Referece Number
					*/

					If Alltrim(aLin[2]) == 'PK'
						_cPack := Alltrim(aLin[3])
					ElseIf Alltrim(aLin[2]) == 'PO'
						_cPo := Alltrim(aLin[3])
					ElseIf Alltrim(aLin[2]) == 'PM'
						_cPart := Alltrim(aLin[3])
					Endif

				ElseIf Alltrim(aLin[1]) == 'TED'	//Technical Error Description
					/*
					TED02 := Transaction Set Identifier Code
					TED03 := Transaction Set Control Number
					TED04 :=
					TED05 :=
					TED06 :=
					TED07 :=
					TED08 := Copy of Bad Data Element
					*/

					_cMessage := Alltrim(aLin[3])
//					_cMessage := Left(Alltrim(aLin[3]),3)
					If Len(aLin) > 7
						_cBadElem := Alltrim(aLin[8])
					Endif

				ElseIf Alltrim(aLin[1]) == 'SE'	//Transaction Set Trailer

					If Empty(_cTable)
						_lBKP := .F.
					Endif

					CR049B(_cStatus,_cTable,_cControl,_cPack,_cPo,_cPart,_cMessage,_cBadElem,cFile)

					_cStatus	:= _cTable := _cControl := _cPack := _cPo := _cPart := _cMessage := _cBadElem := ''

				ElseIf Alltrim(aLin[1]) == 'GE'		//Functional Group Trailer
				ElseIf Alltrim(aLin[1]) == 'IEA'	//Interchange Control Trailer
				Endif

			Endif

			FT_FSKIP()

		EndDo

		FT_FUSE()

		If _lBKP
			_cData    := GravaData(dDataBase,.f.,8)
			_cHora    := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

			__CopyFile( _cDir +cFile, _cDir+"BKP\"+_cData+_cHora+"_"+cFile )
			FErase(_cDir +cFile)
		Endif
	Next NI

Return



Static Function CR049B(_cStatus,_cTable,_cControl,_cPack,_cPo,_cPart,_cMessage,_cBadElem,cFile)

	If _cTable = 'ZC'
		_cTipo := 'ASN'
	Else
		_cTipo := 'INVOICE'
	Endif

	//_cProcesso := Right('000000'+_cPack,6)
	_cProcesso := Padl(_cControl,6,'0')

/*
	If Empty(_cPack)
		SZH->(dbSetOrder(2))
		If SZH->(msSeek(xFilial('SZH')+Left(_cTipo,1)+Right('000000000'+_cControl,9)))
			_cProcesso := SZH->ZH_PROCESS
		Endif
	Endif
*/
	_cInfo := _cMessage
	/*
	_cInfo := ''
	SX5->(dbsetOrder(1))
	If SX5->(msseek(xFilial('SX5')+_cTable+_cMessage))
		_cInfo := _cMessage+'-'+Alltrim(SX5->X5_DESCRI)

		If _cMessage = '351'
			_cInfo += '; PO: '+_cPo+'; Part Number: '+_cPart+'; Qtde: '+_cBadElem
		Endif
	Else
		_cInfo := _cMessage+' - Código não encontrado!'
	Endif
	 */
	EEC->(dbSetOrder(1))
	If EEC->(msSeek(xFilial('EE9')+_cProcesso))

		SA1->(dbSetOrder(1))
		SA1->(msSeek(xFilial('SA1')+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))

		_cCliente 	:= EEC->EEC_IMPORT+'-'+EEC->EEC_IMLOJA
		_cNome    	:= SA1->A1_NOME
		_cNomPais 	:=  Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_PAIS_I")
		_cEnd	  	:= Alltrim(SA1->A1_ADDRESS)+' - '+Alltrim(SA1->A1_CITY)+' - '+Alltrim(SA1->A1_STATE)+' - '+Alltrim(SA1->A1_POSCODE)+' - '+Alltrim(_cNomPais)

		ConOut("Enviando E-Mail Application Advice")

		oProcess := TWFProcess():New( "ENVEM1", "824" )

		_cFacility	:= SA1->A1_ENDINV

		oProcess:NewTask( "Application Advice", "\WORKFLOW\CR0049.HTM" )

		oProcess:bReturn  := ""
		oProcess:bTimeOut := ""
		oHTML 			  := oProcess:oHTML

		oProcess:cSubject := "Application Advice "+_cTipo+" "+_cProcesso+" - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

		oHtml:ValByName("tipo"		, _cTipo )
		oHtml:ValByName("processo"	, _cProcesso )
		oHtml:ValByName("cliente"	, _cCliente )
		oHtml:ValByName("nome"		, _cNome )
		oHtml:ValByName("end"		, _cEnd )
		oHtml:ValByName("facility"	, _cFacility )
		oHtml:ValByName("message"	, _cInfo )
		oHtml:ValByName("status"	, _cStatus )

		oProcess:fDesc := "Application Advice"

		Private _cTo := _cCC := ""

		_cZG := ''
		If _cTipo = 'A' //ASN
			_cZG := 'D'
		Else
			_cZG := 'E' //Invoice
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
		aAdd( _aCampos, { 'Z0_TIPO'  	, '824'       	   			} )
		aAdd( _aCampos, { 'Z0_TIPO2'  	, 'U'						} )
		aAdd( _aCampos, { 'Z0_CLIENTE'  , EEC->EEC_IMPORT	  		} )
		aAdd( _aCampos, { 'Z0_LOJA'  	, EEC->EEC_IMLOJA   		} )
		aAdd( _aCampos, { 'Z0_FILE'  	, _cFile     				} )

		//Grava na tabela SZ0
		U_CR0070( 'SZ0', _aCampos,'CR0096' )

	Endif

Return
