#include "TOTVS.ch"
#INCLUDE "TBICONN.CH"

/*/
Funçao    	³ 	CR0051
Autor 		³ 	Fabiano da Silva
Data 		³ 	10.01.14
Descricao 	³ 	E-mail de Alteração Pedido de Compra - Caterpillar Exportação(000017)
860 Purchase Order Change Request - Buyer Initiated
/*/

User Function CR0051()

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

//	LOCAL oDlg := NIL

	PRIVATE cTitulo    	:= "E-mail Purchase Order Change Request"
	PRIVATE oPrn       	:= NIL
	PRIVATE _nData     	:= Space(3)
	Private _cCATFold	:= GetMV("CR_CATFOLD")

/*
	_nOpc := 0

	DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
	@ 004,010 TO 060,157 LABEL "" OF oDlg PIXEL

	@ 010,017 SAY "Esta rotina tem por objetivo gerar e-mail das Alterações" 	OF oDlg PIXEL Size 150,010
	@ 020,017 SAY "de Pedido de Compra da Caterpillar - Exportação"				OF oDlg PIXEL Size 150,010
	@ 050,017 SAY "Programa CR0051.PRW                           " 		OF oDlg PIXEL Size 150,010

	@ 15,165 BUTTON "OK" 		 SIZE 036,012 ACTION (_nOpc := 1,oDlg:End()) 	OF oDlg PIXEL
	@ 40,165 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	If _nOpc = 1
	*/
		U_CR0041() //Aloca os arquivos nas pastas corretas.

		Private _lFim      := .F.
		Private _cMsg01    := ''
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| CR051A(@_lFim) }
		Private _cTitulo01 := 'Processando'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

//	Endif


Return(Nil)



Static Function CR051A(_lFim)

	Private _cCliente 	:= Space(6)
	Private _cLoja		:= Space(2)
	Private	_cPedido
	Private _dDtEmis
	Private _dDtPedi
	Private	_cProdCli
	Private _cDescri
	Private _nPreco
	Private	_cUM
	Private _cMoeda
	Private	_cDEL := _cGEN := _cORI := _cPAY := _cPUR := _cTRA := _cCHG := ''
	Private cFile
	Private _cASN       := ''
	Private _cInvoice   := ''
	Private _cNameCli 	:= ''
	Private _cBuyer 	:= _cFoneBuy := ''
	Private _cOrdCont	:= _cFoneCon := _cMailCon := ''
	Private _cShipTo	:= _cDtCode  := _cNamComp := ''
	Private _cSegBef    := ''
	Private _cAddress   := ''
	Private _cCity   	:= _cState := _cPosCode := _cCountry := ''
	Private _nQtdOrd
	Private _cRevisao   := ''
	Private _nST		:= 0

	aStru := {}
	AADD(aStru,{"INDICE"   , "C" , 01 , 0 })
	AADD(aStru,{"PRODCLI"  , "C" , 15 , 0 })
	AADD(aStru,{"CLIENTE"  , "C" , 06 , 0 })
	AADD(aStru,{"LOJA"     , "C" , 02 , 0 })
	AADD(aStru,{"NOMECLI"  , "C" , 30 , 0 })
	AADD(aStru,{"DTCODE"   , "C" , 10 , 0 })
	AADD(aStru,{"NOMECOM"  , "C" , 30 , 0 })
	AADD(aStru,{"ADDRESS"  , "C" , 60 , 0 })
	AADD(aStru,{"CITY"     , "C" , 60 , 0 })
	AADD(aStru,{"STATE"    , "C" , 02 , 0 })
	AADD(aStru,{"POSTAL"   , "C" , 15 , 0 })
	AADD(aStru,{"COUNTRY"  , "C" , 02 , 0 })
	AADD(aStru,{"BUYER"    , "C" , 40 , 0 })
	AADD(aStru,{"PHONEBU"  , "C" , 20 , 0 })
	AADD(aStru,{"ASN"  	   , "C" , 15 , 0 })
	AADD(aStru,{"INVOICE"  , "C" , 15 , 0 })
	AADD(aStru,{"PRODUTO"  , "C" , 15 , 0 })
	AADD(aStru,{"PEDCLI"   , "C" , 20 , 0 })
	AADD(aStru,{"REVISAO"  , "C" , 15 , 0 })
	AADD(aStru,{"PRECOAT"  , "N" , 12 , 5 })
	AADD(aStru,{"PCDTEMI"  , "D" , 08 , 0 })
	AADD(aStru,{"PRECOPO"  , "N" , 12 , 5 })
	AADD(aStru,{"CONTATO"  , "C" , 11 , 0 })
	AADD(aStru,{"MAIL"     , "C" , 30 , 0 })
	AADD(aStru,{"PHONE"    , "C" , 20 , 0 })
	AADD(aStru,{"DESCRIC"  , "C" , 25 , 0 })
	AADD(aStru,{"LOTE_MIN" , "N" , 12 , 3 })
	AADD(aStru,{"UM" 	   , "C" , 2  , 0 })
	AADD(aStru,{"MOEDA"    , "C" , 3  , 0 })
	AADD(aStru,{"ARQUIVO"  , "C" , 100, 0 })

	cArqLOG := CriaTrab(aStru,.T.)
	cIndLOG := "INDICE+PRODUTO+PRODCLI+CLIENTE+LOJA+DTCODE"
	dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

	dbSelectArea("TRB")
	IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

	_cDir := _cCATFold+"Exportacao\Download\860\"

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

					If Alltrim(aLin[17]) == 'T' //Se for Teste
						FT_FUSE() //Fecha o arquivo
						Exit
					Endif

				ElseIf Alltrim(aLin[1]) == 'GS' 	//Functional Group Header
				/*
				GS02 := Functional Identifier Code
				GS03 := Application Sender's Code
				GS04 := Application Reciever's Code
				GS05 := Data Interchange Date
				GS06 := Data Interchange Time
				GS07 := Data Interchange Control Number
				GS08 := Responsible Agency Code
				GS09 := Version / Realease / Industry Identifier Code
				*/

					_dDtEmis    := cTod(Right(Alltrim(aLin[6]),2)+'/'+Substr(Alltrim(aLin[6]),3,2)+'/'+Left(Alltrim(aLin[6]),2))

				ElseIf Alltrim(aLin[1]) == 'ST'	//Transaction Set Header
					If _nST > 1
					Endif

					_nST ++

				/*
				ST02 := Transaction Set Identifier Code
				ST03 := Transaction Set Control Number
				*/

					If Alltrim(aLin[2]) != '860' //Se não for Purchase Order
						FT_FUSE() //Fecha o arquivo
						Exit
					Endif

				ElseIf Alltrim(aLin[1]) == 'BCH'	//Beginning Segment for Purchase Order Change
				/*
				BCH02 := Transaction Set Purpose Code
				BCH03 := Purchase Order Type Code
				BCH04 := Purchase Order Number
				BCH05 := ?
				BCH06 := ?
				BCH07 := Purchase Order Date
				BCH08 := Request Reference Number
				BCH09 := ?
				BCH10 := ?
				BCH11 := ?
				BCH12 := Purchase Order Change Request Date
				*/

					_cPedido    := Alltrim(aLin[4])
					_dDtPedi	:= cTod(Right(Alltrim(aLin[12]),2)+'/'+Substr(Alltrim(aLin[12]),3,2)+'/'+Left(Alltrim(aLin[12]),2))

				ElseIf Alltrim(aLin[1]) == 'NTE'	//Note/Special Instruction
				/*
				NTE02 := Note Reference Code
					DEL	-	Delivery
					GEN	-	Entire Transaction Set
					ORI	-	Order Instructions
					PAY	-	Payables
					PUR	-	Purchasing
					TRA	-	Transportation
					CHG - 	Changing

				NTE03 := Free-form text
				*/
					If Alltrim(aLin[2]) == 'DEL'
						_cDEL += Alltrim(Alltrim(aLin[3])) + CRLF
					Elseif Alltrim(aLin[2]) == 'GEN'
						_cGEN += Alltrim(Alltrim(aLin[3])) + CRLF
					Elseif Alltrim(aLin[2]) == 'ORI'
						_cORI += Alltrim(Alltrim(aLin[3])) + CRLF
					Elseif Alltrim(aLin[2]) == 'PAY'
						_cPAY += Alltrim(Alltrim(aLin[3])) + CRLF
					Elseif Alltrim(aLin[2]) == 'PUR'
						_cPUR += Alltrim(Alltrim(aLin[3])) + CRLF
					Elseif Alltrim(aLin[2]) == 'TRA'
						_cTRA += Alltrim(Alltrim(aLin[3])) + CRLF
					Elseif Alltrim(aLin[2]) == 'CHG'
						_cCHG += Alltrim(Alltrim(aLin[3])) + CRLF
					Endif

				ElseIf Alltrim(aLin[1]) == 'FOB'	//F.O.B. Related Instructions
				ElseIf Alltrim(aLin[1]) == 'ITA'	//Allowance, Charge or Service
				ElseIf Alltrim(aLin[1]) == 'ITD'	//Terms Of Sale/Deferred Terms of Sale
				ElseIf Alltrim(aLin[1]) == 'DTM'	//Date/Time/Period
				ElseIf Alltrim(aLin[1]) == 'TD5'	//Carrier Details(Routing Sequence/Transit Time)
				ElseIf Alltrim(aLin[1]) == 'N1'	//Name
				/*
				N102 := Entity Identifier Code
					BT	-	Party to be Billed for Other than Freight(Bill To)
					BY	-	Buying Party (Purchaser)
					PJ	-	Party to receive correspondence
					PN	-	Party to receive shipping notice
					ST	-	Ship To
					SU	-	Supplier/Manufacturer

				N103 := Name
				N104 := Identification Code Qualifier
				N105 := Identification Code
				*/

					If Alltrim(aLin[2]) == 'BT'
						_cInvoice := '005070479'+Alltrim(Alltrim(aLin[5]))
						_cSegBef := 'BT'
					Elseif Alltrim(aLin[2]) == 'BY'
						_cNameCli  := Alltrim(aLin[3])
						_cSegBef := 'BY'
					Elseif Alltrim(aLin[2]) == 'PJ'
						_cSegBef := 'PJ'
					Elseif Alltrim(aLin[2]) == 'PN'
						_cASN := '005070479'+Alltrim(Alltrim(aLin[5]))
						_cSegBef := 'PN'
					Elseif Alltrim(aLin[2]) == 'ST'
						_cShipTo := Alltrim(aLin[3])
						_cDtCode := ''
						If len(aLin) > 4
							_cDtCode := Alltrim(aLin[5])
						Endif
						SA1->(dbOrderNickname('INDSA13'))
						If SA1->(dbSeek(xFilial('SA1')+ _cDtCode))
							_cCliente := SA1->A1_COD
							_cLoja    := SA1->A1_LOJA
						Else
							_cCliente := Space(6)
							_cLoja    := Space(2)
						Endif

						_cSegBef := 'ST'
					Elseif Alltrim(aLin[2]) == 'SU'
						_cSegBef := 'SU'
					Endif

				ElseIf Alltrim(aLin[1]) == 'N2'	//Additional Name Information
				/*
				N202 := Name
				N203 := Name
				*/
					If _cSegBef = 'ST'
						_cNamComp := Alltrim(aLin[2])
					Endif
				ElseIf Alltrim(aLin[1]) == 'N3'	//Address Information
				/*
				N302 := Address Information
				N303 := Address Information
				*/
					If _cSegBef = 'ST'
						_cAddress   := Alltrim(aLin[2])
					Endif
				ElseIf Alltrim(aLin[1]) == 'N4'	//Geographic Infomation
				/*
				N402 := City Name
				N403 := State or Province Code
				N404 := Postal Code
				N405 := Country Code
				*/
					If _cSegBef = 'ST'
						_cCity   	:= Alltrim(aLin[2])
						_cState 	:= Alltrim(aLin[3])
						_cPosCode 	:= Alltrim(aLin[4])
						_cCountry 	:= Alltrim(aLin[5])
					Endif
				ElseIf Alltrim(aLin[1]) == 'PER'	//Administrative Communications Contact
				/*
				PER02 := Contact Function Code
					BD	-	Buyer Name or Department
					OC	-	Order Contact
					RD	-	Receiving Dock
					SR	-	Sales Representative or Department
					ST	-	Service Technician

				PER03 := Name
				PER04 := Communication Number Qualifier
					EM	-	Eletronic Mail
					FX	-	Facsimile
					TE	-	Telephone
				PER05 := Communication Number
				PER06 := Request Reference Number
				*/

					If Alltrim(aLin[2]) == 'BD'
						_cBuyer 	:= Alltrim(aLin[3])
						If Len(aLin) > 3
							If Alltrim(aLin[4]) == 'TE'
								_cFoneBuy 	:= Alltrim(aLin[5])
							Endif
						Endif
					Elseif Alltrim(aLin[2]) == 'OC'
						_cOrdCont	:= Alltrim(aLin[3])
						If Alltrim(aLin[4]) == 'TE'
							_cFoneCon := Alltrim(aLin[5])
						Elseif Alltrim(aLin[4]) == 'EM'
							_cMailCon := Alltrim(aLin[5])
						Endif
					Endif

				ElseIf Alltrim(aLin[1]) == 'POC'	//Line Item change
				/*
				POC02 := Assigned Identification
				POC03 := Change or Response Type Code
					AI	-	Add Additional Item(s)
					DI	-	Delete Item(s)
					RZ	-	Replace All Values
				POC04 := Quantity Ordered
				POC05 := Quantity Left to Receive
				POC06 := Unit or Basis for Measurement Code
				POC07 := Unit Price
				POC08 := Basis of Unit Price Code
				POC09 := Product/Service ID Qualifier
					BP	-	Buyer's Part Number
					CG	-	Commodity Group
					DR	-	Drawing Revision Number
					EC	-	Engineering Change Level
					ON	-	Customer Order Number
					PD	-	Part Number Description
					VP	-	Vendor's(Seller's) Part Number
				POC10 := Product/Service ID
				POC11 := Product/Service ID Qualifier
				POC12 := Product/Service ID
				POC13 := Product/Service ID Qualifier
				POC14 := Product/Service ID
				POC15 := Product/Service ID Qualifier
				POC16 := Product/Service ID
				POC17 := Product/Service ID Qualifier
				POC18 := Product/Service ID
				POC19 := Product/Service ID Qualifier
				POC20 := Product/Service ID
				*/
					_nQtdOrd := Val(Alltrim(aLin[3]))
					_cUM 	 := Alltrim(aLin[5])
					_nPreco  := Val(Alltrim(aLin[7]))

					If Len(aLin) > 9
						For F := 9 To Len(aLin)
							If F%2 > 0 //Impar
								If Alltrim(aLin[F]) == 'BP'
									_cProdCli2 := Alltrim(aLin[F+1])
									_cProdCli  := ''
									For B:= 1 To Len(_cProdCli2)
										If Substr(_cProdCli2,B,1) != "-"
											_cProdCli += Substr(_cProdCli2,B,1)
										Endif
									Next B
								Elseif Alltrim(aLin[F]) == 'CG'
								Elseif Alltrim(aLin[F]) == 'DR'
								Elseif Alltrim(aLin[F]) == 'EC'
									_cRevisao := Alltrim(aLin[F+1])
								Elseif Alltrim(aLin[F]) == 'ON'
								Elseif Alltrim(aLin[F]) == 'PD'
									_cDescri :=  Alltrim(aLin[F+1])
								Elseif Alltrim(aLin[F]) == 'VP'
								Endif
							Endif
						Next F
					Endif
				ElseIf Alltrim(aLin[1]) == 'CUR'	//Currency
				/*
				CUR02 := Entity Identifier Code
				CUR03 := Currency Code
				*/
					_cMoeda := Alltrim(aLin[3])
				ElseIf Alltrim(aLin[1]) == 'PO3'	//Additional Item Detail
				ElseIf Alltrim(aLin[1]) == 'CTP'	//Pricing Information
				/*
				CTP02 :=
				CTP03 := Price Qualifier
				CTP04 := Unit Price
				CTP05 :=
				CTP06 := Unit or Basis for measurement Code
				CTP07 :=
				CTP08 := Multiplier
				*/
					_nPreco  := Val(Alltrim(aLin[4]))


				ElseIf Alltrim(aLin[1]) == 'MEA'	//Measurements
				ElseIf Alltrim(aLin[1]) == 'PID'	//Product/Service Description
				ElseIf Alltrim(aLin[1]) == 'PKG'	//Marking, Packing, Loading

					/*
					PKG02 := Item Description Type
					PKG03 :=
					PKG04 :=
					PKG05 :=
					PKG06 := Description
					*/

					_cTRA += Alltrim(Alltrim(aLin[6])) + CRLF

				ElseIf Alltrim(aLin[1]) == 'REF'	//Reference Numbers
				ElseIf Alltrim(aLin[1]) == 'SCH'	//Line Item Schedule
				ElseIf Alltrim(aLin[1]) == 'CTT'	//Transactions Total
					CR051B()
					_lBKP := .T.
					_cCliente	:= _cLoja 		:= _cPedido := _cProdCli 	:= _cDescri := _cUM 	:= _cMoeda	:= ''
					_cDEL 		:= _cGEN 		:= _cORI 	:= _cPAY 		:= _cPUR 	:= _cTRA 	:= _cCHG	:= _cASN 	:= _cNameCli	:= _cInvoice := ''
					_cBuyer 	:= _cFoneBuy 	:= _cOrdCont:= _cFoneCon 	:= _cMailCon:= ''
					_cShipTo	:= _cDtCode 	:= _cSegBef := _cRevisao 	:= _cNamComp:= ''
					_cAddress 	:= _cCity   	:= _cState 	:= _cPosCode 	:= _cCountry := ''
					_dDtEmis	:= _dDtPedi 	:= CToD("  /  /  ")
					_nPreco		:= _nQtdOrd 	:= 0
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

			__CopyFile( _cDir +cFile, _cDir+"Mail\"+cFile )
			FErase(_cDir +cFile)
		Endif
	Next NI

Return



Static Function CR051B()

	ConOut("Enviando E-Mail Alteração de Pedidos")

	oProcess := TWFProcess():New( "ENVEM1", "860" )

	_cFacility	:= SA1->A1_ENDINV

	oProcess:NewTask( "Change_Order", "\WORKFLOW\CR0051.HTM" )

	oProcess:bReturn  := ""
	oProcess:bTimeOut := ""
	oHTML 			  := oProcess:oHTML

	oProcess:cSubject := "Change Order: "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

	oHtml:ValByName("dtref"			, _dDtPedi )
	oHtml:ValByName("dtcode"		, _cDTCODE )
	oHtml:ValByName("cliente"		, _cCliente+'/'+_cLoja )
	oHtml:ValByName("prodcli"		, _cProdCli )
	oHtml:ValByName("purchase"		, _cPedido )
	oHtml:ValByName("revisao"		, _cRevisao )
	oHtml:ValByName("descric"		, _cDescri )
	oHtml:ValByName("lote"			, _nQtdOrd )
	oHtml:ValByName("um"			, _cUM )
	oHtml:ValByName("preco"			, _nPreco )
	oHtml:ValByName("moeda"			, _cMoeda )
	oHtml:ValByName("contord"		, _cOrdCont )
	oHtml:ValByName("foneord"		, _cFoneCon )
	oHtml:ValByName("mailord"		, _cMailCon )
	oHtml:ValByName("file"			, cFile )
	oHtml:ValByName("transport"		, _cTRA )
	oHtml:ValByName("changing"		, _cCHG )
	oHtml:ValByName("transaction"	, _cGEN )
	oHtml:ValByName("delivery"		, _cDEL )
	oHtml:ValByName("orderins"		, _cORI )
	oHtml:ValByName("payables"		, _cPAY )
	oHtml:ValByName("purchasing"	, _cPUR )

	oProcess:fDesc := "Change Order"

	Private _cTo := _cCC := ""

	SZG->(dbsetOrder(1))
	SZG->(dbGotop())

	While SZG->(!EOF())

		If 'F1' $ SZG->ZG_ROTINA
			_cTo += If(Empty(_cTo),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
		ElseIf 'F2' $ SZG->ZG_ROTINA
			_cCC += If(Empty(_cCC),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
		Endif

		SZG->(dbSkip())
	Enddo

	oProcess:cTo := _cTo
	oProcess:cCC := _cCC

	oProcess:Start()

	oProcess:Finish()

Return
