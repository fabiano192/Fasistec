#include "TOTVS.ch"

/*/
Funçao    	³ CR0041
Autor 		³ Fabiano da Silva
Data 		³ 09.09.13
Descricao 	³ Alocação dos arquivos EDI (Caterpillar - Exportação) nas suas respectivas pastas
/*/

User Function CR0041()

	Private _cCATFold	:= GetMV("CR_CATFOLD")
	Private aListFile  	:= {}		 // Array utilizados pela ListBox com arquivos a serem importados
	Private oListArq		 		// Objeto referente a janela da ListBox
//	Private cDir       	:= '\\SRVCRONNOS01\ERP\EDI\Caterpillar\Exportacao\Download\'
	Private cDir       	:= _cCATFold+'Exportacao\Download\'
	Private _aISA		:= {}
	Private _aGS		:= {}
	Private _aST		:= {}
	Private _cData2 	:= _cHora2 	:= ''

	GetFile()

	For nI:=1 To Len( aListFile )

		cFile := AllTrim(aListFile[nI][1])

		FT_FUSE( cDir + cFile )
		FT_FGOTOP()

		Do While !FT_FEOF()

			cBuffer := FT_FREADLN()

			aLin := StrTokArr( cBuffer , "*" )

			_cPasta 	:= ''
			If aLin[1] = 'ISA'
				_aIsa 	:= aLin
			ElseIf aLin[1] = 'GS'
				_aGS  	:= aLin
			ElseIf aLin[1] = 'ST'
				_aST  	:= aLin
				_cPasta := _cCATFold+"Exportacao\Download\"+aLin[2]+"\"

				If !ExistDir( _cPasta )
					If MakeDir( _cPasta ) <> 0
						MsgAlert(  "Impossível criar diretorio ( "+_cPasta+" ) " )
						Return
					EndIf
				EndIf

				_cNum     := Alltrim(GETMV("CR_NREDI"))

				_nFile := Len(AllTrim(aListFile[nI][1]))
				_cFile := Left(AllTrim(aListFile[nI][1]),_nFile-4)+'_'+_cNum+".TXT"

				__CopyFile( cDir +AllTrim(aListFile[nI][1]), _cPasta + _cFile )

				If _cNum > '9998'
					_cNum := '0000'
				Endif

				PUTMV("CR_NREDI",Soma1(_cNum))

				If aLin[2] <> '997'
					Gera997()
				Endif

				FT_FUSE() //Fecha o arquivo

				FErase(cDir +AllTrim(aListFile[nI][1]))
				Exit

			Endif

			FT_FSKIP()

		EndDo

	Next NI

Return


Static Function GetFile() //Verifica se existem arquivos

	Local nI      := 0
	Local aFiles  := {}

	aFiles	:= Directory( cDir + '*.txt' )

	For nI:=1 to Len(aFiles)
		If Upper(Right(AllTrim(aFiles[nI][1]),3)) == "TXT"
			Aadd( aListFile, {aFiles[nI][1]} )
		EndIf
	Next nI

Return


Static Function Gera997()

	Private _nHdlV,_cEOL

	_nQtSeg := 0
	_nQtST  := 0
	_nQtGS  := 0

	_cData2 := GravaData(dDataBase,.f.,8)
	_cTime1 := Substr(Time(),1,2)
	_cTime2 := Substr(Time(),4,2)
	_cTime3 := Substr(Time(),7,2)
	_cHora2 := _cTime1 + _cTime2 + _cTime3

	_cArqTxtV := _cCATFold+"Exportacao\Upload\Acknowledgment\Acknowledgment_"+_cData2+_cHora2+".TXT"

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
//	_cIsa05 := '09'							//Interchange ID Qualifier
	_cIsa05 := 'ZZ'							//Interchange ID Qualifier
	_cIsa06 := 'Q3820C1'+Space(8)			//Interchange Sender ID
//	_cIsa07 := 'ZZ'							//Interchange ID Qualifier
	_cIsa07 := '09'							//Interchange ID Qualifier
	_cIsa08 := _aISA[7]						//Interchange Receiver Qualifier
	_cIsa09 := Substr(_cData2,3,6)			//Interchange Date
	_cIsa10 := Left(_cHora2,4)				//Interchange Time
	_cIsa11 := 'U'							//Interchange Control Standarts Identifier
	_cIsa12 := '00200'						//Interchange Control Version Number
	_cIsa13 := Left(GETMV("CR_ACKNOWL"),9)	//Interchange Control Number
	_cIsa14 := '0'							//Acknowledgement Request
	_cIsa15 := 'P'							//Test Indicator
	_cIsa16 := '\'							//Subelement Separator

	PUTMV("CR_ACKNOWL",StrZero((Val(_cIsa13)+1),9))

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
	_cGS03 := Right(Alltrim(_aISA[7]),2)		//Application Reciever's Code
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

	_cST01 := '997'				//Transaction Set Identifier Code
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
	//Segmento AK1 - Functional Group Response Header

	_cLin     	:= Space(128)+_cEOL

	_cAK101 	:= _aGS[2]						// Functional Identifier Code
	_cAK102		:= Alltrim(Str(Val(_aGS[7])))	// Group Control Number

	_cCpo    	:= 'AK1'+'*'+_cAK101+'*'+_cAK102

	_cLin    	:= Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

	If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ST). Continua?","Atencao!")
			fClose(_nHdlV)
			Return
		Endif
	Endif

	_nQtSeg ++

//--------------------------------------------------------------------------------------------------------------------------//
	//Segmento AK2 - Transaction Set Response Header

	_cLin     := Space(128)+_cEOL

	_cAK201 := _aST[2]						// Transaction Set Identifier Code
	_cAK202 :=  Strzero(Val(_aST[3]),4) 	// Transaction Set Control Number

	_cCpo    := 'AK2'+'*'+_cAK201+'*'+_cAK202

	_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

	If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ST). Continua?","Atencao!")
			fClose(_nHdlV)
			Return
		Endif
	Endif

	_nQtSeg ++
//--------------------------------------------------------------------------------------------------------------------------//
	//Segmento AK3 - Data Segment Note

//--------------------------------------------------------------------------------------------------------------------------//
	//Segmento AK4 - Data Element Note

//--------------------------------------------------------------------------------------------------------------------------//
	//Segmento AK5  - Transaction Set Response Trailer

	_cLin     := Space(128)+_cEOL

	_cAK501 := 'A'				//Transaction Set Response Trailer

	_cCpo    := 'AK5'+'*'+_cAK501

	_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

	If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ST). Continua?","Atencao!")
			fClose(_nHdlV)
			Return
		Endif
	Endif

	_nQtSeg ++
//--------------------------------------------------------------------------------------------------------------------------//
	//Segmento AK9 - Functional Group Response Trailer

	_cLin     := Space(128)+_cEOL

	_cAK901 := 'A'				//Functional Group Acknowledge Code
	_cAK902 := '1'				//Number of Transaction Sets Include
	_cAK903 := '1'				//Number of Received Transaction sets
	_cAK904 := '1'				//Number of Accepted Transaction sets

	_cCpo    := 'AK9'+'*'+_cAK901+'*'+_cAK902+'*'+_cAK903+'*'+_cAK904

	_cLin    := Stuff(_cLin,01,Len(_cLin)-2,_cCpo)

	If fWrite(_nHdlV,_cLin,Len(_cLin)) != Len(_cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo (Tipo ST). Continua?","Atencao!")
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

	Sleep(3000) // 3 segundos

	If !File(_cArqTxtV)
		MSGSTOP("ARQUIVO NAO PODE SER ABERTO! "+Alltrim(_cArqTxtV))
	Endif

	__CopyFile(_cCATFold+"Exportacao\Upload\Acknowledgment\Acknowledgment_"+_cData2+_cHora2+".TXT",;
		_cCATFold+"Exportacao\Upload\Acknowledgment\BKP\Acknowledgment_"+_cData2+_cHora2+".TXT")

	_aISA		:= {}
	_aGS		:= {}
	_aST		:= {}

Return