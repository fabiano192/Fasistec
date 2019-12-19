#INCLUDE "Totvs.ch"

/*
Programa	:	CR0034
Autor		:	Fabiano da Silva
Data		:	24/07/13
Descrição	:	Gerar Invoice em arquivo texto para Caterpillar Exportação
810 Corporate Invoice - Including VAT
*/

User Function CR0034()

	LOCAL oDlg := NIL

	ATUSX1()

	DEFINE MSDIALOG oDlg FROM 0,0 TO 140,330 TITLE "CR0034 - Invoice Caterpillar" OF oDlg PIXEL

	@ 004,008 TO 035,160 LABEL "" OF oDlg PIXEL

	@ 10 ,10 SAY "Este programa tem objetivo de gerar Invoice em arquivo texto " OF oDlg PIXEL
	@ 20 ,10 SAY "para ser enviado à Caterpillar "								OF oDlg PIXEL

	@ 40, 10  BUTTON "Parametros" 	SIZE 036,012 ACTION (Pergunte("CR0034"))		OF oDlg PIXEL
	@ 40 ,60  BUTTON "OK" 			SIZE 036,012 ACTION (_nopc := 1, oDlg:End())	OF oDlg PIXEL
	@ 40 ,110 BUTTON "Sair" 		SIZE 036,012 ACTION (oDlg:End())  				OF oDlg PIXEL

	ACTIVATE DIALOG oDlg CENTER

	If _nopc = 1

		Pergunte("CR0034",.F.)

		Private _lFim      := .F.
		Private _cMsg01    := ''
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| U_CR034A(@_lFim,MV_PAR01) }
		Private _cTitulo01 := 'Processando'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

	Endif

Return



User Function CR034A(_lFim,_cProcess)

	Private _cArqTxtV
	Private _cCATFold	:= GetMV("CR_CATFOLD")

	_lCont  := .T.
	_nQtIT1 := 0
	_nQtSeg := 0
	_nQtST  := 0
	_nQtGS  := 0

	Conout("CR0104 - "+_cProcess)

	dbSelectArea("EE9")
	dbSetOrder(2)
	If dbSeek(xFilial("EE9")+_cProcess)

		EEC->(dbSetOrder(1))
		EEC->(dbSeek(xFilial("EEC")+_cProcess))

		If !Empty(EEC->EEC_DTEMBA)
			If !Empty(EEC->EEC_EDIINV)
				If MsgYesNo("Invoice ja enviada para esse processo, deseja reenviar?")
					_lCont := .T.
				Else
					_lCont := .F.
				Endif
			Endif

			dbSelectArea("SF2")
			dbSetOrder(1)
			dbSeek(xFilial("SF2")+EE9->EE9_NF + EE9->EE9_SERIE)

			If SF2->F2_CLIENTE != "000018"
				Alert("Cliente Não é Caterpillar!!")
				_lCont := .F.
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

		_cArqTxtV := _cCATFold+"Exportacao\Upload\Invoice\INVOICE_"+_cData2+_cHora2+".TXT"

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
		_cIsa08 := SA1->A1_ENDINV				//Interchange Receiver Qualifier
		_cIsa09 := Substr(_cData2,3,6)			//Interchange Date
		_cIsa10 := Left(_cHora2,4)				//Interchange Time
		_cIsa11 := 'U'							//Interchange Control Standarts Identifier
		_cIsa12 := '00200'						//Interchange Control Version Number
		_cIsa13 := Left(GETMV("CR_INVOICE"),9)	//Interchange Control Number
		_cIsa14 := '0'							//Acknowledgement Request
		_cIsa15 := 'P'							//Test Indicator
		_cIsa16 := '\'							//Subelement Separator

		PUTMV("CR_INVOICE",StrZero((Val(_cIsa13)+1),9))

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

		_cGS01 := 'IN'								//Functional Identifier Code
		_cGS02 := 'Q3820C1'							//Application Sender's Code
		_cGS03 := Right(Alltrim(SA1->A1_ENDINV),2)	//Application Reciever's Code
		_cGS04 := _cIsa09							//Date
		_cGS05 := _cIsa10							//Time
		_cGS06 := _cIsa13							//Group Control Number
		_cGS07 := 'X'								//Responsible Agency Code
		_cGS08 := '003030'							//Version / Realease / Industry Identifier Code

		_cCpo    := 'GS'+'*'+_cGS01+'*'+_cGS02+'*'+_cGS03+'*'+_cGS04+'*'+_cGS05+'*'+_cGS06+'*'+_cGS07+'*'+_cGS08

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo GS). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtGS  ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento ST - Transaction Set Header

		_cLin     := Space(128)+_cEOL

		_cST01 := '810'				//Transaction Set Identifier Code
		_cST02 := Right(_cIsa13,4)	//Application Sender's Code

		_cCpo    := 'ST'+'*'+_cST01+'*'+_cST02

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ST). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++
		_nQtST ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento BIG - Beginning Segment for Invoice

		_cLin     := Space(128)+_cEOL

		//		_cBIG01 := GravaData(EEC->EEC_DTPROC,.f.,4)	//Invoice Date
		_cBIG01 := GravaData(EEC->EEC_DTEMBA,.f.,4)	//Invoice Date
		_cBIG02 := Alltrim(EEC->EEC_PREEMB)			//Invoice Number
		_cBIG03 := ''
		_cBIG04 := ''								//Purchase Order Number
		_cBIG05 := ''
		_cBIG06 := ''
		_cBIG07 := 'CA'								//Transaction Type Code

		_cCpo    := 'BIG'+'*'+_cBIG01+'*'+_cBIG02+'*'+_cBIG03+'*'+_cBIG04+'*'+_cBIG05+'*'+_cBIG06+'*'+_cBIG07

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo BIG). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento NTE - Note/Special Instruction

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento CUR - Currency

		_cLin     := Space(128)+_cEOL

		_cCUR01 := If(SF2->F2_LOJA $ '04|39','SE','BY')		//Entity Identifier Code
		_cCUR02 := 'USD'									//Currency Code

		_cCpo    := 'CUR'+'*'+_cCUR01+'*'+_cCUR02

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo CUR). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento REF - Reference Numbers (Packing List)

		_cLin     := Space(128)+_cEOL

		_cREF01 := 'PK'						//Reference Number Qualifier
		_cREF02 := cValtoChar(Val(EEC->EEC_PREEMB))	//Reference Number

		_cCpo    := 'REF'+'*'+_cREF01+'*'+_cREF02

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo REF(PK)). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento N1 - Name (Ship From - SF)

		_cLin     := Space(128)+_cEOL

		_cN1A01 := 'SF'														//Entity Identifier Code
		_cN1A02 := 'CRONNOS'												//Name
		_cN1A03 := '92'														//Identification Code Qualifier
		_cN1A04 := 'Q3820C1'												//Identification Code

		_cCpo    := 'N1'+'*'+_cN1A01+'*'+_cN1A02+'*'+_cN1A03+'*'+_cN1A04

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo N1(SF)). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento N3 - Address Information (Ship From - SF)

		_cLin     := Space(128)+_cEOL

		_cN3A01 := 'AV DAS INDUSTRIAS'		//Address Information
		_cN3A02 := '299'					//Address Information

		_cCpo    := 'N3'+'*'+_cN3A01+'*'+_cN3A02

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo N3(SF)). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento N4 - Geographic Location (Ship From - SF)

		_cLin     := Space(128)+_cEOL

		_cN4A01 := 'JUNDIAI'	//City Name
		_cN4A02 := 'SP'			//State or Province Code
		_cN4A03 := '13213-100'	//Postal Code
		_cN4A04 := 'BR'			//Country Code

		_cCpo    := 'N4'+'*'+_cN4A01+'*'+_cN4A02+'*'+_cN4A03+'*'+_cN4A04

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo N4(SF)). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento N1 - Name (Ship To - ST)

		_cLin     := Space(128)+_cEOL

		_cN1B01 := 'ST'									//Entity Identifier Code
		_cN1B02 := ALLTRIM(Left(EEC->EEC_IMPODE,35))				//Name
		_cN1B03 := '92'									//Identification Code Qualifier
		_cN1B04 := _cGS03								//Identification Code

		_cCpo    := 'N1'+'*'+_cN1B01+'*'+_cN1B02+'*'+_cN1B03+'*'+_cN1B04

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo N1(ST)). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento N3 - Address Information (Ship To - ST)

		_cLin     := Space(128)+_cEOL

		//			_cN3B01 := Alltrim(EEC->EEC_ENDIMP)	//Address Information
		_cN3B01 := Rtrim(Left(SA1->A1_ADDRESS,35))	//Address Information
		//			_cN3B02 := Alltrim(EEC->END2IM) //Address Information

		_cCpo    := 'N3'+'*'+_cN3B01//+'*'+_cN3B02

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo N3(ST)). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento N4 - Geographic Location (Ship To - ST)

		_cLin     := Space(128)+_cEOL

		_cNomPais :=  Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_SIGLA")
		//			_cNomPais :=  Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_NOIDIOM")

		_cN4B01 := rtrim(SA1->A1_CITY)		//City Name
		_cN4B02 := rtrim(SA1->A1_STATE)		//State or Province Code
		_cN4B03 := rtrim(SA1->A1_POSCODE)	//Postal Code
		_cN4B04 := rtrim(_cNomPais)			//Country Code

		//Verificar 01, 02, 03 E 04

		_cCpo    := 'N4'+'*'+_cN4B01+'*'+_cN4B02+'*'+_cN4B03+'*'+_cN4B04

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo N4(ST)). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento N1 - Name (Buying Party (Purchase) - BY)

		_cLin     := Space(128)+_cEOL

		If SF2->F2_LOJA $ '04|39'
			_cName  := 'CATERPILLAR SARL'
		Else
			_cName  := ALLTRIM(Left(EEC->EEC_IMPODE,35))
		Endif

		_cN1C01 := 'BY'				//Entity Identifier Code
		_cN1C02 := 	_cName			//Name
		_cN1C03 := '92'				//Identification Code Qualifier
		_cN1C04 := _cGS03			//Identification Code

		_cCpo    := 'N1'+'*'+_cN1C01+'*'+_cN1C02+'*'+_cN1C03+'*'+_cN1C04

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo N1(BY)). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento N3 - Address Information (Buying Party (Purchase) - BY)

		_cLin     := Space(128)+_cEOL

		_cAdres  := If(SF2->F2_LOJA $ '04|39','ROUTE DE FRONTENEX 76',rtrim(Left(SA1->A1_ADDRESS,35)))

		_cN3C01 := 	_cAdres					//Address Information

		_cCpo    := 'N3'+'*'+_cN3C01//+'*'+_cN3C02

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo N3(BY)). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento N4 - Geographic Location (Buying Party (Purchase) - BY)

		_cLin     := Space(128)+_cEOL

		_cNomPais :=  Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_SIGLA")

		_cCity   := If(SF2->F2_LOJA $ '04|39','GENEVA',rtrim(SA1->A1_CITY))
		_cState  := If(SF2->F2_LOJA $ '04|39','',rtrim(SA1->A1_STATE))
		_cPosCd  := If(SF2->F2_LOJA $ '04|39','CH-1211',rtrim(SA1->A1_POSCODE))
		_cCount  := If(SF2->F2_LOJA $ '04|39','CH',rtrim(_cNomPais))

		_cN4C01 := _cCity		//City Name
		_cN4C02 := _cState		//State or Province Code
		_cN4C03 := _cPosCd		//Postal Code
		_cN4C04 := _cCount		//Country Code

		//Verificar 01, 02, 03 E 04

		_cCpo    := 'N4'+'*'+_cN4C01+'*'+_cN4C02+'*'+_cN4C03+'*'+_cN4C04

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo N4(BY)). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//

		If SF2->F2_LOJA $ '04|39'
			//Segmento REF - Reference Numbers (Value-Added Tax Registration Number (Europe)) - VX)

			_cLin     := Space(128)+_cEOL

			_cREFX1 := 'VX'				//Reference Number Qualifier
			_cREFX2 := 'BE0466550796'	//Reference Number

			_cCpo    := 'REF'+'*'+_cREFX1+'*'+_cREFX2

			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo REF(VX-1)). Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif

			_nQtSeg ++

			//--------------------------------------------------------------------------------------------------------------------------//
			//Segmento N1 - Name (Intermediate Consignee - IC)

			_cLin     := Space(128)+_cEOL

			_cN1D01 := 'IC'								//Entity Identifier Code
			_cN1D02 := 'CATERPILLAR GROUP SERVICES SA'	//Name

			_cCpo    := 'N1'+'*'+_cN1D01+'*'+_cN1D02

			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo N1(IC)). Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif

			_nQtSeg ++

			//--------------------------------------------------------------------------------------------------------------------------//
			//Segmento N3 - Address Information (Intermediate Consignee - IC)

			_cLin     := Space(128)+_cEOL

			_cN3D01 := '1 AVENUE DES ETATS-UNIS'	//Address Information
			_cN3D02 := 'BP1'						//Address Information

			_cCpo    := 'N3'+'*'+_cN3D01+'*'+_cN3D02

			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo N3(IC)). Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif

			_nQtSeg ++

			//--------------------------------------------------------------------------------------------------------------------------//
			//Segmento N4 - Geographic Location (Intermediate Consignee - IC)

			_cLin     := Space(128)+_cEOL

			_cN4D01 := 'GOSSELIES'	//City Name
			_cN4D02 := ''			//State or Province Code
			_cN4D03 := 'B-6041'		//Postal Code
			_cN4D04 := 'BE'			//Country Code

			_cCpo    := 'N4'+'*'+_cN4D01+'*'+_cN4D02+'*'+_cN4D03+'*'+_cN4D04

			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo N4(IC)). Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif

			_nQtSeg ++

			//--------------------------------------------------------------------------------------------------------------------------//
			//Segmento REF - Reference Numbers (Value-Added Tax Registration Number (Europe)) - VX)

			_cLin     := Space(128)+_cEOL

			_cREFX1 := 'VX'				//Reference Number Qualifier
			_cREFX2 := 'BE0428189078'	//Reference Number

			_cCpo    := 'REF'+'*'+_cREFX1+'*'+_cREFX2

			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo REF(VX-2)). Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif

			_nQtSeg ++

		Endif
		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento N1 - Name (Selling Party - SE)

		_cLin     := Space(128)+_cEOL

		_cN1D01 := 'SE'			//Entity Identifier Code
		_cN1D02 := 'CRONNOS'	//Name
		_cN1D03 := '92'			//Identification Code Qualifier
		_cN1D04 := 'Q3820C1'	//Identification Code

		_cCpo    := 'N1'+'*'+_cN1D01+'*'+_cN1D02+'*'+_cN1D03+'*'+_cN1D04

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo N1(SE)). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento N3 - Address Information (Selling Party - SE)

		_cLin     := Space(128)+_cEOL

		_cN3D01 := 'AV DAS INDUSTRIAS'	//Address Information
		_cN3D02 := '299'				//Address Information

		_cCpo    := 'N3'+'*'+_cN3D01+'*'+_cN3D02

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo N3(SE)). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento N4 - Geographic Location (Selling Party - SE)

		_cLin     := Space(128)+_cEOL

		_cN4D01 := 'JUNDIAI'	//City Name
		_cN4D02 := 'SP'			//State or Province Code
		_cN4D03 := '13213-100'	//Postal Code
		_cN4D04 := 'BR'			//Country Code

		_cCpo    := 'N4'+'*'+_cN4D01+'*'+_cN4D02+'*'+_cN4D03+'*'+_cN4D04

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo N4(SE)). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento ITD - Terms of Sale/Deferred Terms of Sale
		If SF2->F2_LOJA $ '04|39'

			//			SZ2->(dbSetOrder(8))
			//			If SZ2->(dbSeek(xFilial("SZ2")+SF2liente + _cLOja + Left(_cProdCli+Space(15),15) + Left(_cPedido+Space(20),20) + "1"))
			//

			_cLin     := Space(128)+_cEOL

			_cITD01 := '08'			//Terms Type Code
			_cITD02 := 'ZZ'			//Terms Basis Date Code
			_cITD03 := '0'			//Terms Discount Percent
			_cITD04 := ''
			_cITD05 := '60'			//Terms Discount Days Due
			//			_cITD05 := GravaData(SZ2->Z2_DESCDAT,.f.,4)		//Terms Discount Days Due

			_cCpo    := 'ITD'+'*'+_cITD01+'*'+_cITD02+'*'+_cITD03+'*'+_cITD04+'*'+_cITD05

			_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

			If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITD). Continua?","Atencao!")
					fClose(_nHdlV)
					Return
				Endif
			Endif

			_nQtSeg ++

		Endif

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento DTM - Date/Time/Period

		_cLin     := Space(128)+_cEOL

		_cDTM01 := '011'								//Date/Time Qualifier
		_cDTM02 := 	GravaData(EEC->EEC_DTEMBA,.f.,4)	//Date

		_cCpo    := 'DTM'+'*'+_cDTM01+'*'+_cDTM02

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo DTM). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento IT1 - Baseline Item Data (Invoice)

		EE9->(dbSetOrder(2))
		If EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB))

			_cKey := EE9->EE9_PREEMB

			ProcRegua(LastRec())

			While EE9->(!Eof()) .And.  _cKey == EE9->EE9_PREEMB

				IncProc()

				SZ2->(dbSetOrder(8))
				If !SZ2->(dbSeek(xFilial("SZ2")+SF2->F2_CLIENTE+SF2->F2_LOJA + Left(Alltrim(EE9->EE9_PART_N)+Space(15),15) + Left(Alltrim(EE9->EE9_REFCLI)+Space(20),20) + "1"))
					MsgAlert("Cadastro de Produto X Cliente não encontrado!")
					fClose(_nHdlV)
					Return
				Endif

				_cIT101 := '1'	//Assigned Identification

				EE8->(dbsetOrder(1))
				If EE8->(msSeek(xFilial()+EE9->EE9_PEDIDO+EE9->EE9_SEQUEN+EE9->EE9_COD_I))
					SC6->(dbsetorder(1))
					If SC6->(msSeek(xFilial()+Left(EE8->EE8_PEDIDO,6)+Left(EE8->EE8_FATIT,2)))
						_cIT101 := Alltrim(Str(Val(SC6->C6_POLINE)))
					ENDIF
				Endif

				_cLin     := Space(128)+_cEOL

				//				_cIT101 := Alltrim(EE9->EE9_SEQUEN)	//Assigned Identification
				_cIT102 := cValtoChar(EE9->EE9_SLDINI)		//Quantity Invoiced
				_cIT103 := EE9->EE9_UNIDAD			//Unit or Basis for Measurement Code
				_cIT104 := cValtoChar(EE9->EE9_PRECO)		//Unit Price
				_cIT105 := ''						//Basis of Unit Price Code
				_cIT106 := 'BP'						//Product/Sevice ID Qualifier
				If !Empty(SZ2->Z2_PCCODE)
					_cIT107 := Alltrim(SZ2->Z2_PCCODE)	//Product/Service ID
				Else
					_cIT107 := Alltrim(EE9->EE9_PART_N)	//Product/Service ID
				Endif
				_cIT108 := 'PO'						//Product/Service ID Qualifier
				_cIT109 := Alltrim(EE9->EE9_REFCLI)	//Product/Service ID
				//				_cIT110 := 'RN'						//Product/Service ID Qualifier
				//				_cIT111 := '123'		//Product/Service ID
				/*
				_cIT112 := '20130724'	//Product/Service ID Qualifier
				_cIT113 := '20130724'	//Product/Service ID
				_cIT114 := '20130724'	//Product/Service ID Qualifier
				_cIT115 := '20130724'	//Product/Service ID
				_cIT116 := '20130724'	//Product/Service ID Qualifier
				_cIT117 := '20130724'	//Product/Service ID
				_cIT118 := '20130724'	//Product/Service ID Qualifier
				_cID119 := '20130724'	//Product/Service ID
				*/

				//Verificar 11

				_cCpo    := 'IT1'+'*'+_cIT101+'*'+_cIT102+'*'+_cIT103+'*'+_cIT104+'*'+_cIT105+'*'+_cIT106+'*'+_cIT107+'*'+_cIT108+'*'+_cIT109//+'*'+;
				//_cIT110+'*'+_cIT111+'*'+_cIT112+'*'+_cIT113+'*'+_cIT114+'*'+_cIT115+'*'+_cIT116+'*'+_cIT117+'*'+_cIT118+'*'+_cIT119

				_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

				If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
					If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo IT1). Continua?","Atencao!")
						fClose(_nHdlV)
						Return
					Endif
				Endif

				_nQtIT1 ++
				_nQtSeg ++

				//--------------------------------------------------------------------------------------------------------------------------//
				//Segmento IT3 - Additional Item Data
				/*
				_cLin     := Space(128)+_cEOL

				_cIT301 := Alltrim(STR(EE9->EE9_SLDINI))//Number of Units Shipped
				_cIT302 := EE9->EE9_UNIDAD				//Unit or Basis for Measurement Code

				//Verificar 01

				_cCpo    := 'IT3'+'*'+_cIT301+'*'+_cIT302

				_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

				If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo IT3). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
				Endif
				Endif

				_nQtSeg ++
				*/
				//--------------------------------------------------------------------------------------------------------------------------//
				//Segmento TX1 - Tax Information

				//--------------------------------------------------------------------------------------------------------------------------//
				//Segmento PID - Product/Item Description

				_cLin     := Space(128)+_cEOL

				cMemo := MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3))

				_cPID01 := 'F'							//Item Description Type
				_cPID02 := ''
				_cPID03 := ''
				_cPID04 := ''
				_cPID05 := Alltrim(MemoLine(cMemo,29,1))//Description

				_cCpo    := 'PID'+'*'+_cPID01+'*'+_cPID02+'*'+_cPID03+'*'+_cPID04+'*'+_cPID05

				_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

				If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
					If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo PID). Continua?","Atencao!")
						fClose(_nHdlV)
						Return
					Endif
				Endif

				_nQtSeg ++

				//--------------------------------------------------------------------------------------------------------------------------//
				//Segmento PWK - Paperwork

				//--------------------------------------------------------------------------------------------------------------------------//
				//Segmento REF - Reference Numbers (Bill of Landing Number)

				If SF2->F2_LOJA $ '04|39'

					_cLin     := Space(128)+_cEOL

					_cREFBM1 := 'BM'						//Reference Number Qualifier
					_cREFBM2 := Alltrim(EEC->EEC_PREEMB)	//Reference Number

					_cCpo    := 'REF'+'*'+_cREFBM1+'*'+_cREFBM2

					_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

					If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
						If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo REF(BM)). Continua?","Atencao!")
							fClose(_nHdlV)
							Return
						Endif
					Endif

					_nQtSeg ++

				Endif
				//--------------------------------------------------------------------------------------------------------------------------//
				//Segmento DTM - Date/Time/Period

				//--------------------------------------------------------------------------------------------------------------------------//
				//Segmento ITA - Allowance, Charge or Service

				/*			_cLin     := Space(128)+_cEOL

				_cITA01 := 'BM'			//Allowance Or Charge Indicator
				_cITA02 := '123456'		//Agency Qualifier Code
				_cITA03 := '123456'		//Special Service Code
				_cITA04 := '123456'		//Allowance or Charge Method of Handling Code
				_cITA05 := ''
				_cITA06 := '123456'		//Allowance or Charge Rate
				_cITA07 := ''
				_cITA08 := ''
				_cITA09 := ''
				_cITA10 := '123456'		//Allowance or Charge Quantity
				_cITA11 := '123456'		//Unit or Basis for Measurement Code
				_cITA12 := ''
				_cITA13 := '123456'		//Description

				//Verificar 02

				_cCpo    := 'ITA'+'*'+_cITA01+'*'+_cITA02+'*'+_cITA03+'*'+_cITA04+'*'+_cITA05+'*'+_cITA06+'*'+_cITA07+'*'+;
				_cITA08+'*'+_cITA09+'*'+_cITA10+'*'+_cITA11+'*'+_cITA12+'*'+_cITA13

				_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

				If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ITA). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
				Endif
				Endif

				_nQtSeg ++
				*/

				//--------------------------------------------------------------------------------------------------------------------------//
				//Segmento TX1 - Tax Information

				//--------------------------------------------------------------------------------------------------------------------------//
				//Segmento NTE - Note/Special Instruction


				EE9->(dbSkip())
			EndDo
		Endif
		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento TDS - Total Monetary Value Summary

		_cLin     := Space(128)+_cEOL

		_cTDS01 := Alltrim(STR(EEC->EEC_TOTPED*100))			//Total Invoice Amount (Lê-se 125530 = 1255,30)

		//Verificar 01

		_cCpo    := 'TDS'+'*'+_cTDS01

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo TDS). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento TX1 - Tax Information

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento CAD - Carrier Detail

		_cLin     := Space(128)+_cEOL

		SYQ->(dbSetOrder(1))
		SYQ->(dbSeek(xFilial("SYQ")+EEC->EEC_VIA))

		_cVia := "S" //Maritimo

		If Left(SYQ->YQ_COD_DI,1) = "4"
			_cVia := "A" //Aereo
		Endif

		_cCAD01 := _cVia			//Transportation Method/Type Code
		_cCAD02 := ''
		_cCAD03 := ''
		_cCAD04 := ''
		_cCAD05 := 'Z'			//Routing

		_cCpo    := 'CAD'+'*'+_cCAD01+'*'+_cCAD02+'*'+_cCAD03+'*'+_cCAD04+'*'+_cCAD05

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo CAD). Continua?","Atencao!")
				fClose(_nHdlV)
				Return
			Endif
		Endif

		_nQtSeg ++

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento ITA - Allowance, Charge or Service

		//--------------------------------------------------------------------------------------------------------------------------//
		//Segmento CTT - Transaction Totals

		_cLin     := Space(128)+_cEOL

		_cCTT01 := Alltrim(Str(_nQtIT1))//Number of Line Items
		//_cCTT02 := ''					//Hash Total

		_cCpo    := 'CTT'+'*'+_cCTT01//+'*'+_cCTT02

		_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

		If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo CTT). Continua?","Atencao!")
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
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo SE). Continua?","Atencao!")
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
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo GE). Continua?","Atencao!")
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
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo IEA). Continua?","Atencao!")
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

		__CopyFile(_cCATFold+"Exportacao\Upload\Invoice\INVOICE_"+_cData2+_cHora2+".TXT",;
		_cCATFold+"Exportacao\Upload\Invoice\BKP\INVOICE_"+_cData2+_cHora2+".TXT")

		_cFile := "INVOICE_"+_cData2+_cHora2+".TXT"

		EEC->(RecLock("EEC",.f.))
		EEC->EEC_EDIINV  := dDataBase
		EEC->(MsUnlock())

		SZH->(RecLock('SZH',.T.))
		SZH->ZH_FILIAL	:= xFilial('SZH')
		SZH->ZH_TIPO	:= 'I'
		SZH->ZH_CONTROL	:= _cIsa13
		SZH->ZH_PROCESS	:= _cBIG02
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
		aAdd( _aCampos, { 'Z0_TIPO'  	, '810'       	   			} )
		aAdd( _aCampos, { 'Z0_TIPO2'  	, 'U'						} )
		aAdd( _aCampos, { 'Z0_CLIENTE'  , SF2->F2_CLIENTE   		} )
		aAdd( _aCampos, { 'Z0_LOJA'  	, SF2->F2_LOJA     			} )
		aAdd( _aCampos, { 'Z0_FILE'  	, _cFile     				} )

		//Grava na tabela SZ0
		U_CR0070( 'SZ0', _aCampos,'CR0096' )

	Endif

Return



Static Function AtuSX1()

	cPerg := "CR0034"
	aRegs := {}

	//    	   Grupo/Ordem/Pergunta               		/perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(cPerg,"01","Nr Processo Exportacao   ?",""       ,""      ,"mv_ch1","C" ,20     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return (Nil)
