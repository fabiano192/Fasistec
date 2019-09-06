#include "TOTVS.ch"
#include "TOPCONN.ch"

/*/
Fun�ao    	� 	CR0042
Autor 		� 	Fabiano da Silva
Data 		� 	25.09.13
Descricao 	� 	Altera��o Pedido de Compra - Caterpillar Exporta��o(000017)
				860 Purchase Order Change Request - Buyer Initiated
/*/

User Function CR0042()

	LOCAL oDlg := NIL

	Private _cCATFold	:= GetMV("CR_CATFOLD")

	PRIVATE cTitulo    	:= "Purchase Order Change Request"
	PRIVATE oPrn       	:= NIL
	PRIVATE _nData     	:= Space(3)

	_nOpc := 0

	DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
	@ 004,010 TO 060,157 LABEL "" OF oDlg PIXEL

	@ 010,017 SAY "Esta rotina tem por objetivo importar as Altera��es" 	OF oDlg PIXEL Size 150,010
	@ 020,017 SAY "de Pedido de Compra da Caterpillar - Exporta��o"				OF oDlg PIXEL Size 150,010
	@ 050,017 SAY "Programa CR0042.PRW                           " 		OF oDlg PIXEL Size 150,010

	@ 15,165 BUTTON "OK" 		 SIZE 036,012 ACTION (_nOpc := 1,oDlg:End()) 	OF oDlg PIXEL
	@ 40,165 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	If _nOpc = 1

		U_CR0041() //Aloca os arquivos nas pastas corretas.

		Private _lFim      := .F.
		Private _cMsg01    := ''
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| CR042A(@_lFim) }
		Private _cTitulo01 := 'Processando'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

		CR042C()
	Endif


Return(Nil)



Static Function CR042A(_lFim)

	Private _cCliente
	Private _cLoja
	Private	_cPedido
	Private _dDtEmis
	Private _dDtPedi
	Private	_cProdCli
	Private	_cProdCli2
	Private _cDescri
	Private _nPreco
	Private	_cUM
	Private _cMoeda
	Private	_cDEL := _cGEN := _cORI := _cPAY := _cPUR := _cTRA := ''
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

	_cDir := _cCATFold+"Exportacao\Download\860\MAIL\"

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

					If Alltrim(aLin[2]) != '860' //Se n�o for Purchase Order
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
						_cDtCode := Alltrim(aLin[5])

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
						If Alltrim(aLin[4]) == 'TE'
							_cFoneBuy 	:= Alltrim(aLin[5])
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
					CR042B()
					_lBKP := .T.
					If Empty(_cCliente)
						_lBKP := .F.
					Endif
					_cCliente	:= _cLoja 		:= _cPedido := _cProdCli 	:= _cProdCli2	:= _cDescri := _cUM 	:= _cMoeda	:= ''
					_cDEL 		:= _cGEN 		:= _cORI 	:= _cPAY 		:= _cPUR 		:= _cTRA 	:= _cASN 	:= _cNameCli	:= _cInvoice := ''
					_cBuyer 	:= _cFoneBuy 	:= _cOrdCont:= _cFoneCon 	:= _cMailCon	:= ''
					_cShipTo	:= _cDtCode 	:= _cSegBef := _cRevisao 	:= _cNamComp	:= ''
					_cAddress 	:= _cCity   	:= _cState 	:= _cPosCode 	:= _cCountry 	:= ''
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

			__CopyFile( _cDir +cFile, _cDir+"BKP\"+_cData+_cHora+"_"+cFile )
			FErase(_cDir +cFile)
		Endif
	Next NI

Return



Static Function CR042B()

	_cIndice := "1"

	SZ2->(dbSetOrder(8))
	If !SZ2->(dbSeek(xFilial("SZ2")+_cCliente + _cLOja + Left(_cProdCli+Space(15),15) + Left(_cPedido+Space(20),20) + "1"))

		If Empty(_cCliente)
			TRB->(RecLock("TRB",.T.))
			TRB->INDICE  	:= '1' //Cliente n�o cadastrado
			TRB->NOMECLI	:= _cShipTo
			TRB->NOMECOM	:= _cNamComp
			TRB->DTCODE		:= _cDtCode
			TRB->ADDRESS	:= _cAddress
			TRB->CITY		:= _cCity
			TRB->STATE		:= _cState
			TRB->POSTAL		:= _cPosCode
			TRB->COUNTRY	:= _cCountry
			TRB->BUYER		:= _cBuyer
			TRB->PHONEBU	:= _cFoneBuy
			TRB->ASN		:= _cASN
			TRB->INVOICE	:= _cInvoice
			MsUnlock()

			TRB->(RecLock("TRB",.T.))
			TRB->INDICE  	:= '2' //Produto n�o Cadastrado
			TRB->CLIENTE 	:= _cCliente
			TRB->LOJA    	:= _cLoja
			TRB->DTCODE		:= _cDtCode
			TRB->PRODCLI 	:= _cProdCli
			TRB->DESCRIC 	:= _cDescri
			TRB->PEDCLI  	:= _cPedido
			TRB->PCDTEMI 	:= _dDtPedi
			TRB->PRECOPO 	:= _nPreco
			TRB->REVISAO    := _cRevisao
			TRB->CONTATO 	:= _cOrdCont
			TRB->PHONE 		:= _cFoneCon
			TRB->MAIL 		:= _cMailCon
			TRB->LOTE_MIN 	:= _nQtdOrd
			TRB->UM 		:= _cUM
			TRB->MOEDA 		:= _cMoeda
			MsUnlock()

		Else

			_aAliSZ2 := SZ2->(GetArea())

			SZ2->(dbSetOrder(8))
			If !SZ2->(dbSeek(xFilial("SZ2")+_cCliente + _cLOja + Left(_cProdCli+Space(15),15)))

				TRB->(RecLock("TRB",.T.))
				TRB->INDICE  	:= '2' //Produto n�o Cadastrado
				TRB->CLIENTE 	:= _cCliente
				TRB->LOJA    	:= _cLoja
				TRB->DTCODE		:= _cDtCode
				TRB->PRODCLI 	:= _cProdCli
				TRB->DESCRIC 	:= _cDescri
				TRB->PEDCLI  	:= _cPedido
				TRB->PCDTEMI 	:= _dDtPedi
				TRB->PRECOPO 	:= _nPreco
				TRB->REVISAO    := _cRevisao
				TRB->CONTATO 	:= _cOrdCont
				TRB->PHONE 		:= _cFoneCon
				TRB->MAIL 		:= _cMailCon
				TRB->LOTE_MIN 	:= _nQtdOrd
				TRB->UM 		:= _cUM
				TRB->MOEDA 		:= _cMoeda
				MsUnlock()
			Else
				TRB->(RecLock("TRB",.T.))
				TRB->INDICE  	:= '3' //PO n�o Cadastrado
				TRB->CLIENTE 	:= _cCliente
				TRB->LOJA    	:= _cLoja
				TRB->DTCODE		:= _cDtCode
				TRB->PRODCLI 	:= _cProdCli
				TRB->DESCRIC 	:= _cDescri
				TRB->PEDCLI  	:= _cPedido
				TRB->PCDTEMI 	:= _dDtPedi
				TRB->PRECOPO 	:= _nPreco
				TRB->REVISAO    := _cRevisao
				TRB->CONTATO 	:= _cOrdCont
				TRB->PHONE 		:= _cFoneCon
				TRB->MAIL 		:= _cMailCon
				TRB->LOTE_MIN 	:= _nQtdOrd
				TRB->UM 		:= _cUM
				TRB->MOEDA 		:= _cMoeda
				MsUnlock()
			Endif
			RestArea(_aAliSZ2)

			SZ2->(RecLock("SZ2",.T.))
			SZ2->Z2_CLIENTE	:= _cCliente
			SZ2->Z2_LOJA	:= _cLoja
//			SZ2->Z2_PRODUTO	:=
			SZ2->Z2_CODCLI	:= _cProdCli
			SZ2->Z2_UM		:= _cUM
			SZ2->Z2_DESCCLI	:= _cDescri
			SZ2->Z2_REVISAO	:= _cRevisao
			SZ2->Z2_PEDCLI	:= _cPedido
			SZ2->Z2_TES		:= '503'
			SZ2->Z2_LOTEMIN	:= _nQtdOrd
//			SZ2->Z2_DNP		:=
			SZ2->Z2_PRECO01	:= _nPreco
			SZ2->Z2_DTREF01	:= _dDtPedi
//			SZ2->Z2_TXCAM01	:= _nTxCamb
//			SZ2->Z2_DTBAS01	:= _dBasEcon
			SZ2->Z2_DTCODE	:= _cDTCODE
			SZ2->Z2_ATIVO	:= "2"
			SZ2->Z2_PCDTEMI := _dDtPedi
			SZ2->Z2_PCCONTA := _cOrdCont
			SZ2->Z2_PCFONE  := _cFoneCon
			SZ2->Z2_PCMAIL  := _cMailCon
			SZ2->Z2_PCDESCR := _cDescri
			SZ2->Z2_PCPRECO := _nPreco
			SZ2->Z2_PCLOTEM := _nQtdOrd
			SZ2->Z2_PCUM    := _cUM
			SZ2->Z2_PCMOEDA := _cMoeda
			SZ2->Z2_PCARQUI := cFile
			SZ2->Z2_NTETRA  := _cTRA
			SZ2->Z2_NTEDEL  := _cDEL
			SZ2->Z2_NTEGEN  := _cGEN
			SZ2->Z2_NTEORI  := _cORI
			SZ2->Z2_NTEPAY  := _cPAY
			SZ2->Z2_NTEPUR  := _cPUR
			SZ2->Z2_PCCODE  := _cProdCli2
			SZ2->(MsUnlock())

		Endif
	Else

		If Alltrim(SZ2->Z2_REVISAO) != Alltrim(_cRevisao)

			TRB->(RecLock("TRB",.T.))
			TRB->INDICE  	:= '4' //Revis�o n�o Cadastrado
			TRB->CLIENTE 	:= _cCliente
			TRB->LOJA    	:= _cLoja
			TRB->DTCODE		:= _cDtCode
			TRB->PRODCLI 	:= _cProdCli
			TRB->DESCRIC 	:= _cDescri
			TRB->PEDCLI  	:= _cPedido
			TRB->PCDTEMI 	:= _dDtPedi
			TRB->PRECOPO 	:= _nPreco
			TRB->REVISAO    := _cRevisao
			TRB->CONTATO 	:= _cOrdCont
			TRB->PHONE 		:= _cFoneCon
			TRB->MAIL 		:= _cMailCon
			TRB->LOTE_MIN 	:= _nQtdOrd
			TRB->UM 		:= _cUM
			TRB->MOEDA 		:= _cMoeda
			MsUnlock()

			SZ2->(RecLock("SZ2",.T.))
			SZ2->Z2_CLIENTE	:= _cCliente
			SZ2->Z2_LOJA	:= _cLoja
			SZ2->Z2_CODCLI	:= _cProdCli
			SZ2->Z2_UM		:= _cUM
			SZ2->Z2_DESCCLI	:= _cDescri
			SZ2->Z2_REVISAO	:= _cRevisao
			SZ2->Z2_PEDCLI	:= _cPedido
			SZ2->Z2_TES		:= '503'
			SZ2->Z2_LOTEMIN	:= If(_nQtdOrd = 0, 1,_nQtdOrd)
			SZ2->Z2_PRECO01	:= _nPreco
			SZ2->Z2_DTREF01	:= _dDtPedi
			SZ2->Z2_DTCODE	:= _cDTCODE
			SZ2->Z2_ATIVO	:= "2"
			SZ2->Z2_PCDTEMI := _dDtPedi
			SZ2->Z2_PCCONTA := _cOrdCont
			SZ2->Z2_PCFONE  := _cFoneCon
			SZ2->Z2_PCMAIL  := _cMailCon
			SZ2->Z2_PCDESCR := _cDescri
			SZ2->Z2_PCPRECO := _nPreco
			SZ2->Z2_PCLOTEM := _nQtdOrd
			SZ2->Z2_PCUM    := _cUM
			SZ2->Z2_PCMOEDA := _cMoeda
			SZ2->Z2_PCARQUI := cFile
			SZ2->Z2_NTETRA  := _cTRA
			SZ2->Z2_NTEDEL  := _cDEL
			SZ2->Z2_NTEGEN  := _cGEN
			SZ2->Z2_NTEORI  := _cORI
			SZ2->Z2_NTEPAY  := _cPAY
			SZ2->Z2_NTEPUR  := _cPUR
			SZ2->Z2_PCCODE  := _cProdCli2
			SZ2->(MsUnlock())

		Else
			MSGINFO("Para o Item "+Rtrim(_cProdCli)+" do Pedido "+Rtrim(_cPedido)+" j� existe uma PO emitida em "+dToc(SZ2->Z2_PCDTEMI)+"! Arquivo n�o processado!")
		Endif

	Endif

Return




Static Function CR042C()


	Local oFwMsEx 		:= NIL
	Local cArq 			:= ""
	Local cDir 			:= GetSrvProfString("Startpath","")
	Local cWorkSheet	:= ""
	Local cTable 		:= ""
	Local cDirTmp 		:= GetTempPath()

	/*
	Indice		Descri��o
	1			Cliente n�o Cadastrado
	2			Produto N�o cadastrado
	3			PO n�o cadastrado
	4			Revis�o N�o Cadastrado
	*/

	oFwMsEx := FWMsExcel():New()

	TRB->(dbGotop())

	While !TRB->(Eof())

		_cIndice := TRB->INDICE

		If _cIndice = "1"

			cWorkSheet 	:= 	"Cliente N�o Cadastrado"
			cTable 		:= 	"Cliente n�o Cadastrado"

			oFwMsEx:AddWorkSheet( cWorkSheet )
			oFwMsEx:AddTable( cWorkSheet, cTable )

			oFwMsEx:AddColumn( cWorkSheet, cTable , "Ship To"   		, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Complemento"  		, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "DTCODE"   			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Endere�o"			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Cidade"   			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Estado"   			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "CEP"  				, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Pais"   			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Comprador"   		, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Fone"   			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "End.ASN"  			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "End.Invoice"		, 1,1,.F.)

		Else
			If _cIndice = "2"
				cWorkSheet 	:= 	"Produto n�o Cadastrado"
				cTable 		:= 	"Produto n�o Cadastrado"
			ElseIf _cIndice = "3"
				cWorkSheet 	:= 	"PO n�o Cadastrado"
				cTable 		:= 	"PO n�o Cadastrado"
			ElseIf _cIndice = "4"
				cWorkSheet 	:= 	"Revis�o n�o Cadastrada"
				cTable 		:= 	"Revis�o n�o Cadastrada"
			Endif

			oFwMsEx:AddWorkSheet( cWorkSheet )
			oFwMsEx:AddTable( cWorkSheet, cTable )

			oFwMsEx:AddColumn( cWorkSheet, cTable , "Cliente"   		, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Loja"   			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "DTCODE"   			, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto Cliente"	, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Revis�o"   		, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "UM"   		        , 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Descri��o"	        , 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Pedido Cliente"    , 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Emiss�o"   		, 1,4,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Moeda"   		    , 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Pre�o"   		    , 3,2,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Qtde PO"   		, 3,2,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Contato"   		, 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "Fone"   		    , 1,1,.F.)
			oFwMsEx:AddColumn( cWorkSheet, cTable , "E-mail"   		    , 1,1,.F.)

		Endif

		_cDTCode := ''

		While !TRB->(Eof()) .And. _cIndice == TRB->INDICE

			If _cIndice = "1"

				If _cDTCode = TRB->DTCODE
					TRB->(dbSkip())
					Loop
				Endif

				_cDTCode = TRB->DTCODE

				oFwMsEx:AddRow( cWorkSheet, cTable,{;
					TRB->NOMECLI	,;
					TRB->NOMECOM   	,;
					TRB->DTCODE   	,;
					TRB->ADDRESS   	,;
					TRB->CITY	    ,;
					TRB->STATE  	,;
					TRB->POSTAL    	,;
					TRB->COUNTRY	,;
					TRB->BUYER   	,;
					TRB->PHONEBU	,;
					TRB->ASN		,;
					TRB->INVOICE	})

			Else

				oFwMsEx:AddRow( cWorkSheet, cTable,{;
					TRB->CLIENTE	,;
					TRB->LOJA    	,;
					TRB->DTCODE   	,;
					TRB->PRODCLI    ,;
					TRB->REVISAO    ,;
					TRB->UM         ,;
					TRB->DESCRIC    ,;
					TRB->PEDCLI    	,;
					TRB->PCDTEMI   	,;
					TRB->MOEDA   	,;
					TRB->PRECOPO   	,;
					TRB->LOTE_MIN	,;
					TRB->CONTATO	,;
					TRB->PHONE	    ,;
					TRB->MAIL	    })
			Endif

			TRB->(dbSkip())
		EndDo
	EndDo

	TRB->(dbCloseArea())

	oFwMsEx:Activate()

	cArq := CriaTrab( NIL, .F. ) + ".xml"

	LjMsgRun( "Gerando o arquivo, aguarde...", "Pedido de Compras", {|| oFwMsEx:GetXMLFile( cArq ) } )

	If __CopyFile( cArq, cDirTmp + cArq )
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDirTmp + cArq )
		oExcelApp:SetVisible(.T.)
	Else
		MsgInfo( "Arquivo n�o copiado para tempor�rio do usu�rio." )

		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( _cDir + cArq )
		oExcelApp:SetVisible(.T.)
	Endif

Return
