#include "Protheus.ch"
#include "TopConn.ch"


/*
Programa:	PA0237
Autor:		Fabiano da Silva
Data:		18/03/13
Descrição:	Geração de arquivo Texto referente à Invoice para Caterpillar Exportação
			Formato X12 - 810 Corporate Invoice - Including VAN
*/

User Function PA0237()


Private oDlg

DEFINE MSDIALOG oDlg FROM 0,0 TO 290,390 PIXEL TITLE "Gerar INVOICE Caterpillar Exportacao"

@ 10 ,10 SAY "Rotina criada para gerar INVOICE" OF oDlg PIXEL Size 150,010 
@ 25 ,10 SAY "Para Caterpillar Exportacao. " 	OF oDlg PIXEL Size 150,010 
@ 40 ,10 SAY "Programa PA0237" OF oDlg PIXEL Size 150,010 

@ 90,030 BUTTON "Parametros" SIZE 036,012 PIXEL ACTION (Pergunte("PA0076")) 				OF oDlg 
@ 90,070 BUTTON "OK" 		 SIZE 036,012 PIXEL ACTION (Processa({|| Proces() }),oDlg:End()) OF oDlg 
@ 90,110 BUTTON "Sair"       SIZE 036,012 PIXEL ACTION ( oDlg:End()) 						OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

Return



Static Function Proces()

	Pergunte("PA0076",.F.)

	Private _cArqTxtV

	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| INVOICE(@_lFim) }
	Private _cTitulo01 := 'Processando'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

	Return


Static Function INVOICE(_lFim)

	_c0152   := Space(8)

	dbSelectArea("EE9")
	dbSetOrder(2)
	If dbSeek(xFilial("EE9")+MV_PAR01)
		dbSelectArea("SF2")
		dbSetOrder(1)
		dbSeek(xFilial("SF2")+EE9->EE9_NF + EE9->EE9_SERIE)
		_c0152   := SF2->F2_CLIENTE+SF2->F2_LOJA
		_lGo := .T.

		If SF2->F2_CLIENTE != "000171"
			Alert("Cliente Não é Caterpillar!!")
			_lGo := .F.
		Endif

	Else
		Alert("Processo Exportacao nao encontrado!!")
		_lGo := .F.
	Endif

	_lCont := .T.
	EEC->(dbSetOrder(1))
	If EEC->(dbSeek(xFilial("EEC")+EE9->EE9_PREEMB))
/*		If Empty(EEC->EEC_TRANUM)
			_lCont := .F.
			Alert("Processo sem informação do Transporte!!")
		Else
			If !Empty(EEC->EEC_DTASN)
				If MsgYesNo("ASN ja enviada para esse processo, deseja reenviar?")
					_lCont := .T.
				Else
					_lCont := .F.
				Endif
			Endif
		Endif
	Else
		_lCont := .F.
		Alert("Processo Exportacao nao encontrado!!")
		*/
	Endif

	If _lCont

		Private _nHdlV,_cEOL
		Private _cLin, _cCpo,_c0038,_c0036
		Private _nContLiV

		Private _nCont := 0

		dbSelectArea("EE9")
		dbSetOrder(2)
		dbSeek(xFilial("EE9")+MV_PAR01,.F.)

		ProcRegua(LastRec())

		While !Eof() .And. EE9->EE9_PREEMB == MV_PAR01

			IncProc()

			If _lGo

				_cCgc2  := "60675048000121"
				_cData2 := GravaData(dDataBase,.f.,8)
				_cHora2 := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

				_cArqTxtV := "\\SRVPASY01\ERP\EDI\SINTEL\CAT\SAIDA\INVOICE\INVOICE_"+_cCGC2+"_"+_cData2+_cHora2+".TXT"

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

				_cData  := GravaData(dDataBase,.f.,4)			
				_cHora  := Substr(Time(),1,2) + Substr(Time(),4,2)



				//ISA - Inerchange Control Header
				_cLin    := Space(128) + _cEOL

				dbSelectArea("SA1")
				dbSetOrder(1)
				If dbseek(xFilial("SA1")+ _c0152)
//					_c0038    := SA1->A1_CNPJEXP
//					_c0244    := Substr(SA1->A1_NOME,1,25)
				Endif

				_cNrInv := GetMv("PA_INVOICE")
				
				SX6->(dbSetOrder(1))
				If SX6->(DbSeek(cFilant+_cNrInv))
					SX6->(RecLock("SX6",.F.))
					SX6->X6_CONTEUD := StrZero((Val(_cNrInv)+1),9)
					SX6->(MsUnlock())			
				Endif

				_cI01	:= "00"						// M - Authorization Information Qualifier
				_cI02	:= Space(10)				// M - Authorization Information
				_cI03	:= "00"						// M - Security Information Qualifier
				_cI04	:= Space(10)				// M - Security Information
				_cI05	:= "ZZ"						// M - Interchange ID Qualifier
				_cI06	:= "Q1675X0"+Space(8)		// M - Interchanger Sender ID
				_cI07	:= "09"						// M - Interchanger ID Qualifier
				_cI08	:= "005070479ff"+Space(4)	// M - Interchanger Receiver ID
				_cI09	:= _cData					// M - Interchange Date
				_cI10	:= _cHora					// M - Interchange Time
				_cI11	:= "U"						// M - Interchange Control Standards Identifier
				_cI12	:= "00200"					// M - Interchange Control Version Number				
				_cI13	:= _cNrInv					// M - Interchange Control Number
				_cI14	:= "0"						// M - Acknowledgement Requested
				_cI15	:= "T"						// M - Test Indicator
				_cI16	:= "\"						// M - Subelement Separator
								
				_cCpo    := "ISA"+"*"+_cI01+"*"+_cI02+"*"+_cI03+"*"+_cI04+"*"+_cI05+"*"+_cI06+"*"+_cI07+"*"+_cI08+"*"+;
							_cI09+"*"+_cI10+"*"+_cI11+"*"+_cI12+"*"+_cI13+"*"+_cI14+"*"+_cI15+"*"+_cI16+"@"
							 
				_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
				_nContLiV++

				If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
					If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ISA). Continua?","Atencao!")
						fClose(_nHdlV)
						Return
					Endif
				Endif



				//GS - Functional Groupo Header
				_cLin   := Space(128)+_cEOL

				_cGS01	:= "IN"						// M - Functional Identifier Code
				
				_cGS02	:= "Q1675X0"+Space(8)		// M - Application Sender's Code
				_cGS03	:= "ff"						// M - Application Reciever's Code
				_cGS04	:= _cData					// M - Date
				_cGS05	:= _cHora					// M - Time
				_cGS06	:= _cNrInv					// M - Group Control Number
				_cGS07	:= "X"						// M - Responsible Agency Code
				_cGS08	:= "003030"					// M - Version / Realease / Industry Identifier Code

				_cCpo    := "GS"+"*"+_cGS01+"*"+_cGS02+"*"+_cGS03+"*"+_cGS04+"*"+_cGS05+"*"+_cGS06+"*"+_cGS07+"*"+_cGS08+"@"
							 
				_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
				_nContLiV++

				If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
					If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ISA). Continua?","Atencao!")
						fClose(_nHdlV)
						Return
					Endif
				Endif




				//ST - Transaction Set Header
				_cLin   := Space(128)+_cEOL

				_cST01	:= "810"					// M - Transaction Set Identifier Code	
				_cST02	:= Right(_cNrInv,4)			// M - Transaction Set Control Number
	
				_cCpo    := "ST"+"*"+_cST01+"*"+_cST02+"@"
							 
				_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
				_nContLiV++

				If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
					If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ISA). Continua?","Atencao!")
						fClose(_nHdlV)
						Return
					Endif
				Endif




				//BIG - Begnning Segment for Invoice
				_cLin   := Space(128)+_cEOL

				_cDtInv := GravaData(EEC->EEC_DTPROC,.f.,4)
				
				_cProc    := EEC->EEC_PREEMB
				_cProc0   := Alltrim("EXP"+Substr(_cProc,5,10))
				_nPosM    := At("/",_cProc0)
				_cProc1   := Substr(_cProc0,1,_nPosM-1)+Substr(_cProc0,_nPosM+1,2)

				_cBIG01	:= _cDtInv					// M - Invoice Date	
				_cBIG02	:= _cProc1					// M - Invoice Number
				_cBIG03	:= ""
				_cBIG04	:= ""						// M - Purchase Order Number
				_cBIG05	:= ""
				_cBIG06	:= ""
				_cBIG07	:= "CA"						// M - Transaction Type Code
	
				_cCpo    := "BIG"+"*"+_cBIG01+"*"+_cBIG02+"*"+_cBIG03+"*"+_cBIG04+"*"+_cBIG05+"*"+_cBIG06+"*"+_cBIG07+"@"
							 
				_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
				_nContLiV++

				If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
					If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ISA). Continua?","Atencao!")
						fClose(_nHdlV)
						Return
					Endif
				Endif




				//TDS - Total Monetary Summary
				_cLin   := Space(128)+_cEOL
				
				nFobValue := ALLTRIM(Transf((EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+;
								EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2")),"9999999,99"))				

				_nPoVir   := At(",",nFobValue)
				_cValor   := Substr(nFobValue,1,_nPoVir-1)+Substr(nFobValue,_nPoVir+1,2)

				_cTDS01	:= _cValor		// M - Total Invoice Amount	
	
				_cCpo    := "TDS"+"*"+_cTDS01+"@"
							 
				_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)
				_nContLiV++

				If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
					If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ISA). Continua?","Atencao!")
						fClose(_nHdlV)
						Return
					Endif
				Endif



				fClose(_nHdlV)

				Sleep(1000) // 1 segundo

				If !File(_cArqTxtV)
					MSGSTOP("ARQUIVO NAO PODE SER ABERTO! "+Alltrim(_cArqTxtV))
				Endif

				__CopyFile("\\SRVPASY01\ERP\EDI\SINTEL\CAT\SAIDA\INVOICE\INVOICE_"+_cCGC2+"_"+_cData2+_cHora2+".TXT", "P:\EDI\SINTEL\CAT\SAIDA\INVOICE\BKP\INVOICE_"+_cCGC2+"_"+_cData2+_cHora2+".TXT")

			Endif

			dbSelectArea("EE9")
			dbSkip()
		EndDo

	Endif

	Return
