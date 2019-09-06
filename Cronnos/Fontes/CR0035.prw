#INCLUDE "Totvs.ch"

/*
Programa	:	CR0035
Autor		:	Fabiano da Silva
Data		:	31/07/13
Descrição	:	Gerar ASN em arquivo texto para Caterpillar Exportação
856 Ship Notice/Manifest
*/

User Function CR0035()

	LOCAL oDlg := NIL

	Private _cCATFold	:= GetMV("CR_CATFOLD")

	_nopc := 0

	DEFINE MSDIALOG oDlg FROM 0,0 TO 140,330 TITLE "CR0035 - ASN Caterpillar" OF oDlg PIXEL

	@ 004,008 TO 035,160 LABEL "" OF oDlg PIXEL

	@ 10 ,10 SAY "Este programa tem objetivo de gerar ASN em arquivo texto " OF oDlg PIXEL
	@ 20 ,10 SAY "para ser enviado à Caterpillar "								OF oDlg PIXEL

	@ 40, 10  BUTTON "Parametros" 	SIZE 036,012 ACTION (Pergunte("CR0034"))		OF oDlg PIXEL
	@ 40 ,60  BUTTON "OK" 			SIZE 036,012 ACTION (_nopc := 1, oDlg:End())  	OF oDlg PIXEL
	@ 40 ,110 BUTTON "Sair" 		SIZE 036,012 ACTION (oDlg:End())  				OF oDlg PIXEL

	ACTIVATE DIALOG oDlg CENTER

	If _nopc = 1

		Pergunte("CR0034",.F.)

		Private _cArqTxtV

		Private _lFim      := .F.
		Private _cMsg01    := ''
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| CR035A(@_lFim) }
		Private _cTitulo01 := 'Processando'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

//		_bAcao02   := {|_lFim| U_CR034A(@_lFim,MV_PAR01) }
//		_cTitulo02 := 'Processando'
//		Processa( _bAcao02, _cTitulo02, _cMsg01, _lAborta01 )

	Endif

Return



Static Function CR035A(_lFim)

	_lCont  := .T.
	_nQtIT1 := 0
	_nQtSeg := 0
	_nQtST  := 0
	_nQtGS  := 0
	_nQtHL  := 0
	_nSN1   := 0
	_nLin   := 0
	_lGo    := .F.

	dbSelectArea("EE9")
	dbSetOrder(2)
	If dbSeek(xFilial("EE9")+MV_PAR01)

		EEC->(dbSetOrder(1))
		EEC->(dbSeek(xFilial("EEC")+MV_PAR01))

		If !Empty(EEC->EEC_DTEMBA)
			If !Empty(EEC->EEC_EDIASN)
				If MsgYesNo("ASN ja enviada para esse processo, deseja reenviar?")
					_lCont := .T.
				Else
					_lCont := .F.
				Endif
			Endif

			dbSelectArea("SF2")
			dbSetOrder(1)
			dbSeek(xFilial("SF2")+EE9->EE9_NF + EE9->EE9_SERIE)

			If SF2->F2_CLIENTE != "000018"
				Alert("Cliente Não é Caterpillar, mas ira gerar informações para Etiqueta!!")

				_lGo   := .T.
				//			_lCont := .F.
			Endif
		Else
			Alert("Processo ainda não foi embarcado!")
			_lCont := .F.
		Endif

	Else
		_lCont := .F.
		Alert("Processo Exportacao nao encontrado!!")
	Endif


	If _lCont

		Private _nHdlV,_cEOL

		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))


		_cData2 := GravaData(dDataBase,.f.,8)
		_cTime1 := Substr(Time(),1,2)
		_cTime2 := Substr(Time(),4,2)
		_cTime3 := Substr(Time(),7,2)
		_cHora2 := _cTime1 + _cTime2 + _cTime3

		_cArqTxtV := _cCATFold+"Exportacao\Upload\ASN\ASN_"+_cData2+_cHora2+".TXT"

		_nHdlV    := MSfCreate(_cArqTxtV)

		If _nHdlV == -1
			MsgAlert("O arquivo de nome "+_cArqTxtV+" 1 nao pode ser executado!","Atencao!")
			fClose(_nHdlV)
			Return
		Endif

		_cEOL    := "CHR(13)+CHR(10)"

		If Empty(_cEOL)
			_cEOL := CHR(13)+CHR(10)
		Else
			_cEOL := Trim(_cEOL)
			_cEOL := &_cEOL
		Endif

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento ISA - Interchange Control Header

		_cLin    := Space(128) + _cEOL


		_cIsa01 := '00'							//Authorization Information Qualifier
		_cIsa02 := Space(10)					//Authorization Information
		_cIsa03 := '00'							//Security Information Qualifier
		_cIsa04 := Space(10)					//Security Information
		_cIsa05 := 'ZZ'							//Interchange ID Qualifier
		_cIsa06 := 'Q3820C1'+Space(8)			//Interchange Sender ID
		_cIsa07 := '09'							//Interchange ID Qualifier
		_cIsa08 := SA1->A1_ENDASN				//Interchange Receiver Qualifier
		_cIsa09 := Substr(_cData2,3,6)			//Interchange Date
		_cIsa10 := Left(_cHora2,4)				//Interchange Time
		_cIsa11 := 'U'							//Interchange Control Standarts Identifier
		_cIsa12 := '00200'						//Interchange Control Version Number
		_cIsa13 := Left(GETMV("CR_ASN"),9)		//Interchange Control Number
		_cIsa14 := '0'							//Acknowledgement Request
		_cIsa15 := 'P'							//Test Indicator
		_cIsa16 := '\'							//Subelement Separator

		PUTMV("CR_ASN",StrZero((Val(_cIsa13)+1),9))

		_cCpo    := 'ISA'+'*'+_cIsa01+'*'+_cIsa02+'*'+_cIsa03+'*'+_cIsa04+'*'+_cIsa05+'*'+_cIsa06+'*'+_cIsa07+'*'+;
		_cIsa08+'*'+_cIsa09+'*'+_cIsa10+'*'+_cIsa11+'*'+_cIsa12+'*'+_cIsa13+'*'+_cIsa14+'*'+_cIsa15+'*'+_cIsa16

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento GS - Functional Group Header

		_cLin     := Space(128)+_cEOL

		_cGS01 := 'SH'								//Functional Identifier Code
		_cGS02 := 'Q3820C1'							//Application Sender's Code
		_cGS03 := Right(Alltrim(SA1->A1_ENDASN),2)	//Application Reciever's Code
		_cGS04 := _cIsa09							//Date
		_cGS05 := _cIsa10							//Time
		_cGS06 := _cIsa13							//Group Control Number
		_cGS07 := 'X'								//Responsible Agency Code
		_cGS08 := '003020'							//Version / Realease / Industry Identifier Code

		_cCpo    := 'GS'+'*'+_cGS01+'*'+_cGS02+'*'+_cGS03+'*'+_cGS04+'*'+_cGS05+'*'+_cGS06+'*'+_cGS07+'*'+_cGS08

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtGS  ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento ST - Transaction Set Header

		_cLin     := Space(128)+_cEOL

		_cST01 := '856'				//Transaction Set Identifier Code
		_cST02 := Right(_cIsa13,4)	//Application Sender's Code

		_cCpo    := 'ST'+'*'+_cST01+'*'+_cST02

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++
		_nQtST ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento BSN - Beginning Segment for Ship Note

		_cLin     := Space(128)+_cEOL

		_cBSN01 := '00'                           	//Transaction Set Purpose Code
		_cBSN02 := Alltrim(EEC->EEC_PREEMB)			//Shipment Identification
		_cBSN03 := _cIsa09							//Date
		_cBSN04 := _cIsa10							//Time

		//Verificar 01

		_cCpo    := 'BSN'+'*'+_cBSN01+'*'+_cBSN02+'*'+_cBSN03+'*'+_cBSN04

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento NTE - Note/Special Instruction

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento DTM - Date/Time/Period (Shipped)

		_cLin     := Space(128)+_cEOL

		_cDTM01 := '011'								//Date/Time Qualifier
		_cDTM02 := 	GravaData(EEC->EEC_DTEMBA,.f.,4)	//Date
		//		_cDTM03 := 	''''								//Time

		_cCpo   := 'DTM'+'*'+_cDTM01+'*'+_cDTM02

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento DTM - Date/Time/Period (Estimate Delivery)

		SYQ->(dbSetOrder(1))
		SYQ->(dbSeek(xFilial("SYQ")+EEC->EEC_VIA))

		_cVia := 'SS' //Maritimo
		_nDia := 60

		If Left(SYQ->YQ_COD_DI,1) = "4"
			_cVia := "A" //Aereo
			_nDia := 15
		Endif

		_cLin     := Space(128)+_cEOL

		_cDTM01 := '017'									//Date/Time Qualifier
		_cDTM02 := 	GravaData(EEC->EEC_DTEMBA+_nDia,.f.,4)	//Date
		//		_cDTM03 := 	''''									//Time

		_cCpo   := 'DTM'+'*'+_cDTM01+'*'+_cDTM02

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++


		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento HL - Hierarchical Level = Shipment Level

		_nQtHL ++

		_cLin     := Space(128)+_cEOL

		_cHL01 := Alltrim(Str(_nQtHL))		//Hierarchical ID Number
		_cHL02 := ''
		_cHL03 := 'S'						//Hierarchical ID Number

		_cCpo    := 'HL'+'*'+_cHL01+'*'+_cHL02+'*'+_cHL03

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++
		_cIDHL := _cHL01

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento MEA - Measurememts

		_cLin     := Space(128)+_cEOL

		_cMEA01 := 'PD'								//Measurement Reference ID Code
		_cMEA02 := 'G'								//Measurement Qualifier
		_cMEA03 := cValtoChar(INT(EEC->EEC_PESBRU))	//Measurement Value
		//		_cMEA04 := 'PC'								//Unit or Basis for Measurement Code
		_cMEA04 := 'KG'							//Unit or Basis for Measurement Code -- Alterado para 'KGM', conforme e-mail em 06/07/15.

		_cCpo    := 'MEA'+'*'+_cMEA01+'*'+_cMEA02+'*'+_cMEA03+'*'+_cMEA04

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento TD1 - Carrier Details (Quantity and Wheight)



		_cLin     := Space(128)+_cEOL

		_cTD101 := 'BOX71'							//Packing Code
		_cTD102 := cValtoChar(INT(EEC->EEC_TOTVOL))	//Lading Quantity

		//Verificar 01

		_cCpo    := 'TD1'+'*'+_cTD101+'*'+_cTD102

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento TD5 - Carrier Details (Routing Sequence/Transit Time)

		_cCode := ''
		_cIden := '2'
		If EEC->EEC_TRANSP = "000001"
			_cCode := "DHLC"
		Else
			If _cVia == "SS"
				_cCode := "CEVV"
				//				_cCode := "CEVA"
			Else
				_cIden := '92'
				_cCode := "1477"
				//			_cCode := "UNKNOWN"
			Endif
		Endif

		_cLin     := Space(128)+_cEOL

		_cTD501 := 'B'					//Routing Sequence Code
		_cTD502 := _cIden				//Identification Code Qualifier
		_cTD503 := 	_cCode				//Identification Code
		_cTD504 := _cVia				//Transportation Method/Type Code

		_cCpo    := 'TD5'+'*'+_cTD501+'*'+_cTD502+'*'+_cTD503+'*'+_cTD504

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento TD3 - Carrier Details (Equipament)

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento REF - Reference Numbers (Carrier's Pro Number)

		_cTrck   := If(!Empty(EEC->EEC_TRACKI),Alltrim(EEC->EEC_TRACKI),Alltrim(EEC->EEC_PREEMB))

		_cLin    := Space(128)+_cEOL

		_cREF01  := 'CN'				//Reference Number Qualifier
		_cREF02  := _cTrck			//Reference Number

		//Verificar 02

		_cCpo    := 'REF'+'*'+_cREF01+'*'+_cREF02

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento FOB - F.O.B. Related Instructions

		_cLin    := Space(128)+_cEOL

		_cFOB01  := EEC->EEC_FRPPCC			//Shipment Method of Payment

		_cCpo    := 'FOB'+'*'+_cFOB01

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento N1 - Name (Ship From - SF (16 = Postal Zip Code))

		_cLin     := Space(128)+_cEOL

		_cN1A01 := 'SF'								//Entity Identifier Code
		_cN1A02 := ''
		_cN1A03 := '16'								//Identification Code Qualifier
		_cN1A04 := '13213-100'						//Identification Code
		//		_cN1A04 := rtrim(SA1->A1_POSCODE)			//Identification Code

		_cCpo    := 'N1'+'*'+_cN1A01+'*'+_cN1A02+'*'+_cN1A03+'*'+_cN1A04

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento N1 - Name (Ship From - SF (92 = Supplier Code))

		_cLin     := Space(128)+_cEOL

		_cN1B01 := 'SF'								//Entity Identifier Code
		_cN1B02 := ''
		_cN1B03 := '92'								//Identification Code Qualifier
		_cN1B04 := 'Q3820C1'						//Identification Code

		_cCpo    := 'N1'+'*'+_cN1B01+'*'+_cN1B02+'*'+_cN1B03+'*'+_cN1B04

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento N1 - Name (Ship From - SF (91 = Caterpillar Ship Point))

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento N1 - Name (Ship From - SU (91 = Country Code))

		//		_cNomPais :=  Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_SIGLA")

		_cLin     := Space(128)+_cEOL

		_cN1B01 := 'SU'							//Entity Identifier Code
		_cN1B02 := ''
		_cN1B03 := '91'							//Identification Code Qualifier
		_cN1B04 := 'BR'							//Identification Code
		//		_cN1B04 := rtrim(_cNomPais)				//Identification Code

		_cCpo    := 'N1'+'*'+_cN1B01+'*'+_cN1B02+'*'+_cN1B03+'*'+_cN1B04

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++


		EE9->(dbSetOrder(2))
		If EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB))

			_cKey := EE9->EE9_PREEMB

			ProcRegua(LastRec())

			While EE9->(!Eof()) .And.  _cKey == EE9->EE9_PREEMB

				IncProc()

				EE8->(dbsetOrder(1))
				If EE8->(msSeek(xFilial()+EE9->EE9_PEDIDO+EE9->EE9_SEQUEN+EE9->EE9_COD_I))

					SC6->(dbsetorder(1))
					If SC6->(msSeek(xFilial()+Left(EE8->EE8_PEDIDO,6)+Left(EE8->EE8_FATIT,2)))

						//--------------------------------------------------------------------------------------------------------------------------//
						//Segmento HL - Hierarchical Level = Item Level

						_nQtHL ++

						_cLin  := Space(128)+_cEOL

						_cHLA01 := Alltrim(Str(_nQtHL))		//Hierarchical ID Number
						_cHLA02 := _cIDHL					//Hierarchical Parent ID Number
						_cHLA03 := 'I'						//Hierarchical ID Number

						_cCpo    := 'HL'+'*'+_cHLA01+'*'+_cHLA02+'*'+_cHLA03

						_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

						If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
							If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
								fClose(_nHdlV)
								Return
							Endif
						Endif

						_nQtSeg ++

						//--------------------------------------------------------------------------------------------------------------------------//
						//Segmento LIN - Item Identification

						SZ2->(dbSetOrder(8))
						SZ2->(dbSeek(xFilial("SZ2")+SF2->F2_CLIENTE+SF2->F2_LOJA + Left(Alltrim(EE9->EE9_PART_N)+Space(15),15) + Left(Alltrim(EE9->EE9_REFCLI)+Space(20),20) + "1"))

						_nLin ++

						_cLin  := Space(128)+_cEOL

						_cLIN01 := Alltrim(Str(_nLin))		//Assigned Identification
						//_cLIN01 := Alltrim(EE9->EE9_SEQUEN)	//Assigned Identification
						_cLIN02 := 'SI'						//Product/Service ID Qualifier
						_cLIN03 := 'ASN'					//Product/Service ID
						_cLIN04 := 'BP'						//Product/Service ID Qualifier
						If !Empty(SZ2->Z2_PCCODE)
							_cLIN05 := Alltrim(SZ2->Z2_PCCODE)	//Product/Service ID
						Else
							_cLIN05 := Alltrim(EE9->EE9_PART_N)	//Product/Service ID
						Endif
						If !Empty(EE9->EE9_REVENG)
							_cLIN06 := 'EC'						//Product/Service ID Qualifier
							_cLIN07 := ALLTRIM(EE9->EE9_REVENG)	//Product/Service ID
							_cLIN08 := 'CH'						//Product/Service ID Qualifier
							_cLIN09 := 'BR'						//Product/Service ID
							_cCpo    := 'LIN'+'*'+_cLIN01+'*'+_cLIN02+'*'+_cLIN03+'*'+_cLIN04+'*'+_cLIN05+'*'+_cLIN06+'*'+_cLIN07+'*'+_cLIN08+'*'+_cLIN09
						Else
							_cLIN06 := 'CH'						//Product/Service ID Qualifier
							_cLIN07 := 'BR'						//Product/Service ID
							_cCpo    := 'LIN'+'*'+_cLIN01+'*'+_cLIN02+'*'+_cLIN03+'*'+_cLIN04+'*'+_cLIN05+'*'+_cLIN06+'*'+_cLIN07
						Endif

						//					_cCpo    := 'LIN'+'*'+_cLIN01+'*'+_cLIN02+'*'+_cLIN03+'*'+_cLIN04+'*'+_cLIN05+'*'+_cLIN06+'*'+_cLIN07+'*'+_cLIN08+'*'+_cLIN09

						_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

						If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
							If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
								fClose(_nHdlV)
								Return
							Endif
						Endif

						_nQtSeg ++

						//--------------------------------------------------------------------------------------------------------------------------//
						//Segmento SN1 - Item Detail(Shipment)

						_cLin  := Space(128)+_cEOL

						_cSN101 := ''
						_cSN102 := cValtoChar(EE9->EE9_SLDINI)	//Number of Units Shipped
						_cSN103 := EE9->EE9_UNIDAD				//Unit or Basis for Measurement Code

						_cCpo    := 'SN1'+'*'+_cSN101+'*'+_cSN102+'*'+_cSN103

						_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

						If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
							If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
								fClose(_nHdlV)
								Return
							Endif
						Endif

						_nSN1 += EE9->EE9_SLDINI
						_nQtSeg ++

						//--------------------------------------------------------------------------------------------------------------------------//
						//Segmento SLN - SubLine Item Detail

						//--------------------------------------------------------------------------------------------------------------------------//
						//Segmento PRF - Purchase Order Reference

						_cLin  := Space(128)+_cEOL

						_cPRF01 := Alltrim(EE9->EE9_REFCLI)		//Purchase Order Number
						_cPRF02 := ''							//Release Number
						_cPRF03 := ''
						_cPRF04 := ''
//						_cPRF05 := Alltrim(SC6->C6_POLINE)		//Assigned Identification
						//Alterado conforme e-mail
						_cPRF05 := Alltrim(Str(Val(SC6->C6_POLINE)))		//Assigned Identification

						//Verificar 02

						If !Empty(_cPRF05)
							_cCpo    := 'PRF'+'*'+_cPRF01+'*'+_cPRF02+'*'+_cPRF03+'*'+_cPRF04+'*'+_cPRF05
						Else
							_cCpo    := 'PRF'+'*'+_cPRF01
						Endif

						_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

						If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
							If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
								fClose(_nHdlV)
								Return
							Endif
						Endif

						_nQtSeg ++

						//--------------------------------------------------------------------------------------------------------------------------//
						//Segmento PID - Purchase/Item Description

						_cLin  := Space(128)+_cEOL

						cMemo := MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3))

						_cPID01 := 'F'					//Item Description Type
						_cPID02 := ''
						_cPID03 := ''
						_cPID04 := ''
						_cPID05 := Alltrim(MemoLine(cMemo,29,1))	//Description

						_cCpo    := 'PID'+'*'+_cPID01+'*'+_cPID02+'*'+_cPID03+'*'+_cPID04+'*'+_cPID05

						_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

						If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
							If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
								fClose(_nHdlV)
								Return
							Endif
						Endif

						_nQtSeg ++

						//--------------------------------------------------------------------------------------------------------------------------//
						//Segmento MEA - Measurememts

						//--------------------------------------------------------------------------------------------------------------------------//
						//Segmento REF - Reference Numbers (Packing List)

						_cLin     := Space(128)+_cEOL

						_cREF01 := 'PK'						//Reference Number Qualifier
						_cREF02 := cValtoChar(Val(EEC->EEC_PREEMB))	//Reference Number

						_cCpo    := 'REF'+'*'+_cREF01+'*'+_cREF02

						_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

						If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
							If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
								fClose(_nHdlV)
								Return
							Endif
						Endif

						_nQtSeg ++

						//--------------------------------------------------------------------------------------------------------------------------//
						//Segmento CLD - Load Detail

						_cLin     := Space(128)+_cEOL

						_cCLD01 := cValtoChar(EE9->EE9_QTDEM1)	//Number of Loads
						_cCLD02 := cValtoChar(EE9->EE9_QE)	//Number of Units Shiped
						//				_cCLD02 := cValtoChar(EE9->EE9_SLDINI)	//Number of Units Shiped
						_cCLD03 := 'BOX71'						//Packing Code

						//_cCLD04 := ''							//Size
						//_cCLD05 := ''							//Unit or Basis for Measurement Code

						//Verificar 03

						_cCpo    := 'CLD'+'*'+_cCLD01+'*'+_cCLD02+'*'+_cCLD03//+'*'+_cCLD04+'*'+_cCLD05

						_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

						If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
							If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
								fClose(_nHdlV)
								Return
							Endif
						Endif

						_nQtSeg ++

						//--------------------------------------------------------------------------------------------------------------------------//
						//Segmento REF - Reference Numbers (Bar-Coded Serial Number)

						_cAno_At   := strzero(year(dDataBase),4)
						_cMvPl     := Alltrim(GETMV("CR_PALLCAT"))
						_cAno_MV   := Substr(_cMvPl,2,4)

						If _cAno_At > _cAno_MV
							_cEtiqCat  := "P"+_cAno_At+"000001"
						Else
							_cEtiqCat  := "P"+_cAno_At+Strzero(Val(Right(_cMvPl,6))+1,6)
						Endif

						PUTMV("CR_PALLCAT",_cEtiqCat)
						_cPallet     := _cEtiqCat    // NUMERO DO PALLETE QUE ESTÃO AS EMBALAGENS

						For X:= 1 To EE9->EE9_QTDEM1

							_cLin     := Space(128)+_cEOL

							_cAno_At   := strzero(year(dDataBase),4)
							_cMvEt     := Alltrim(GETMV("CR_ETIQCAT"))
							_cAno_MV   := Substr(_cMvEt,2,4)

							If _cAno_At > _cAno_MV
								_cEtiqCat  := "E"+_cAno_At+"000001"
							Else
								_cEtiqCat  := "E"+_cAno_At+Strzero(Val(Right(_cMvEt,6))+1,6)
							Endif

							_cREF01 := 'LS'						//Reference Number Qualifier
							_cREF02 := _cEtiqCat		//Reference Number

							_cCpo    := 'REF'+'*'+_cREF01+'*'+_cREF02

							_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

							If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
								If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
									fClose(_nHdlV)
									Return
								Endif
							Endif

							_nQtSeg ++

							PUTMV("CR_ETIQCAT",_cEtiqCat)

							SZ7->(RecLock("SZ7",.T.))
							SZ7->Z7_FILIAL	:= xFilial("SZ7")
							SZ7->Z7_CODIGO  := _cREF02
							SZ7->Z7_PALETE  := _cPallet
							SZ7->Z7_ASN 	:= EE9->EE9_PREEMB
							SZ7->Z7_PREEMB  := EE9->EE9_PREEMB
							SZ7->Z7_SEQEMB	:= EE9->EE9_SEQEMB
							SZ7->(MsUnlock())

						Next X
					Else
						MsgAlert("Produto "+Alltrim(EE9->EE9_COD_I)+" não encontrado no Pedido de Vendas, contate o Administrador!")
					Endif
				Else
					MsgAlert("Produto "+Alltrim(EE9->EE9_COD_I)+" não encontrado no Processo de Exportação, contate o Administrador!")
				Endif

				EE9->(dbSkip())
			EndDo
		Endif

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento CUR - Currency

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento ITA - Allowance, Charge or Service

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento CTT - Transaction Totals

		_cLin     := Space(128)+_cEOL

		_cCTT01 := Alltrim(Str(_nQtHL))//Number of Line Items
		_cCTT02 := Alltrim(Str(_nSN1)) //Hash Total

		_cCpo    := 'CTT'+'*'+_cCTT01+'*'+_cCTT02

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento SE - Transaction Set Trailer

		_cLin     := Space(128)+_cEOL

		_nQtSeg ++

		_cSE01 := Alltrim(Str(_nQtSeg))	//Number of Included Segments
		_cSE02 := _cST02				//Transaction Set Control Number

		_cCpo    := 'SE'+'*'+_cSE01+'*'+_cSE02

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento GE - Functional Group Trailer

		_cLin     := Space(128)+_cEOL

		_cGE01 := Alltrim(Str(_nQtST))	//Number of Transaction Sets Included
		_cGE02 := _cGS06				//Group Control Number

		_cCpo    := 'GE'+'*'+_cGE01+'*'+_cGE02

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento IEA - Interchange Control Trailer

		_cLin     := Space(128)+_cEOL

		_cIEA01 := Alltrim(Str(_nQtGS))	//Number of Included Functional Groups
		_cIEA02 := _cGS06				//Interchange Control Number

		_cCpo    := 'IEA'+'*'+_cIEA01+'*'+_cIEA02

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITP). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		//--------------------------------------------------------------------------------------------------------------------------//

		fClose(_nHdlV)

		Sleep(3000) // 3 segundo

		If !File(_cArqTxtV)
			MSGSTOP("ARQUIVO NAO PODE SER ABERTO! "+Alltrim(_cArqTxtV))
		Endif

		__CopyFile(_cCATFold+"Exportacao\Upload\ASN\ASN_"+_cData2+_cHora2+".TXT",;
		_cCATFold+"Exportacao\Upload\ASN\BKP\ASN_"+_cData2+_cHora2+".TXT")

		_cFile := "ASN_"+_cData2+_cHora2+".TXT"

		EEC->(RecLock("EEC",.f.))
		EEC->EEC_EDIASN  := dDataBase
		EEC->(MsUnlock())

		SZH->(RecLock('SZH',.T.))
		SZH->ZH_FILIAL	:= xFilial('SZH')
		SZH->ZH_TIPO	:= 'A'
		SZH->ZH_CONTROL	:= _cIsa13
		SZH->ZH_PROCESS	:= _cBSN02
		SZH->ZH_ENVIO	:= dToc(dDatabase) + ' - ' + _cTime1+':'+_cTime2
		SZH->ZH_FILE	:= _cFile
		SZH->(MsUnlock())

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
		aAdd( _aCampos, { 'Z0_TIPO'  	, '856'       	   			} )
		aAdd( _aCampos, { 'Z0_TIPO2'  	, 'U'						} )
		aAdd( _aCampos, { 'Z0_CLIENTE'  , SF2->F2_CLIENTE   		} )
		aAdd( _aCampos, { 'Z0_LOJA'  	, SF2->F2_LOJA     			} )
		aAdd( _aCampos, { 'Z0_FILE'  	, _cFile     				} )

		//Grava na tabela SZ0
		U_CR0070( 'SZ0', _aCampos,'CR0096' )

	Else
		If _lGo
			EE9->(dbSetOrder(2))
			If EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB))

				_cKey := EE9->EE9_PREEMB

				ProcRegua(LastRec())

				While EE9->(!Eof()) .And.  _cKey == EE9->EE9_PREEMB

					IncProc()

//					_nCont    ++

					SYQ->(dbSetOrder(1))
					SYQ->(dbSeek(xFilial("SYQ")+EEC->EEC_VIA))

					_cVia := "O" //Maritimo

					If Left(SYQ->YQ_COD_DI,1) = "4"
						_cVia := "A" //Aereo
					Endif

					_cAno_At   := strzero(year(dDataBase),4)
					_cMvPl     := Alltrim(GETMV("CR_PALLCAT"))
					_cAno_MV   := Substr(_cMvPl,2,4)

					If _cAno_At > _cAno_MV
						_cEtiqCat  := "P"+_cAno_At+"000001"
					Else
						_cEtiqCat  := "P"+_cAno_At+Strzero(Val(Right(_cMvPl,6))+1,6)
					Endif

					PUTMV("CR_PALLCAT",_cEtiqCat)
					_cPS20     := Space(6)+_cEtiqCat    // NUMERO DO PALLETE QUE ESTÃO AS EMBALAGENS

					For X:= 1 To EE9->EE9_QTDEM1

						_cMvEt     := Alltrim(GETMV("CR_ETIQCAT"))
						_cAno_MV   := Substr(_cMvEt,2,4)

						If _cAno_At > _cAno_MV
							_cEtiqCat  := "E"+_cAno_At+"000001"
						Else
							_cEtiqCat  := "E"+_cAno_At+Strzero(Val(Right(_cMvEt,6))+1,6)
						Endif

						PUTMV("CR_ETIQCAT",_cEtiqCat)
						_cPS19     := Space(6)+_cEtiqCat    // NUMERO DA Etiqueta de Cada Embalagem

						SZP->(RecLock("SZP",.T.))
						SZP->ZP_FILIAL	:= xFilial("SZP")
						SZP->ZP_CODIGO  := Alltrim(_cPS19)
						SZP->ZP_PALETE  := Alltrim(_cPS20)
						SZP->ZP_ASN 	:= EE9->EE9_PREEMB
						SZP->ZP_PREEMB  := EE9->EE9_PREEMB
						SZP->ZP_SEQEMB	:= EE9->EE9_SEQEMB
						SZP->(MsUnlock())
					Next X
					EE9->(dbSkip())
				EndDo

				EEC->(RecLock("EEC",.f.))
				EEC->EEC_EDIASN  := dDataBase
				EEC->(MsUnlock())

			Endif
		Endif
	Endif

Return
