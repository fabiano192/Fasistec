#INCLUDE 'TOTVS.ch'
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
Autor 		: Fabiano da Silva
Data 		: 27/07/15
Programa  	: CR0075
Descrição 	: Baixar o Estoque conforme NF emitida pela Pasy
*/

User Function CR0075()

	Local _lWait     := .F.
	Local _cCommand  := ""
	Local _cPath     := ""

//	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

	Conout('Inicio Baixa Estoque - CR0075')

	Private _aItD3   := {}
	Private _aCabD3  := {}

//	_cDir := "\\srvcronnos01\Protheus11\Protheus_data\Check_Estoque\"
	_cDir := GetMV("CR_ESTFOLD")

	aListFile	:= Directory( _cDir + '*.txt' )

	For nI:=1 To Len( aListFile )

		_aItD3   := {}
		_aCabD3  := {}
		_aPick   := {}
		_aErro   := {}

		Private _cFile := AllTrim(aListFile[nI][1])

		If UPPER(Left(_cFile,1)) = 'R'

			AAdd(_aCabD3,{"D3_DOC" 		,  NextNumero("SD3",2,"D3_DOC",.T.)	,NIL})
			AAdd(_aCabD3,{"D3_TM" 		, "501"        						,NIL})
			AAdd(_aCabD3,{"D3_EMISSAO"  , dDataBase    						,NIL})

			Private _lBKP := .T.

			FT_FUSE( _cDir + _cFile )
			FT_FGOTOP()

			Do While !FT_FEOF()

				cBuffer := FT_FREADLN()

				_aLin := StrTokArr( cBuffer , ";" )

				If _aLin[1] = 'NF'
					FT_FSKIP()
					Loop
				Endif

				If Len(_aLin) > 0

					SB1->(dbSetOrder(1))
					If !SB1->(MsSeek(xFilial("SB1")+_aLin[2]))
						AADD(_aErro,{_aLin[1],_aLin[2],'','',Val(_aLin[3]),'Produto não Cadastrado!'})
						_lBKP := .F.
						FT_FSKIP()
						Loop
					Endif

					_nQtOri := Val(_aLin[3])

					IF SB1->B1_LOCALIZ = 'S'

						SBF->(dbSetOrder(2))
						If !SBF->(msSeek(xFilial('SBF')+SB1->B1_COD+SB1->B1_LOCPAD))
							AADD(_aErro,{_aLin[1],_aLin[2],SB1->B1_UM,SB1->B1_LOCPAD,Val(_aLin[3]),'Saldo Insuficiente!'})
							_lBKP := .F.
							FT_FSKIP()
							Loop
						Endif

						_cWhile := SB1->B1_COD+SB1->B1_LOCPAD
						_nQuant := 0
						_nDif   := 0

						While SBF->(!EOF()) .And. _cWhile == SBF->BF_PRODUTO+SBF->BF_LOCAL

							If SBF->BF_QUANT >= _nQtOri
								_lExit  := .T.
								_nQuant := _nQtOri
							Else
								_nDif   := _nQtOri - SBF->BF_QUANT
								_nQuant := SBF->BF_QUANT
								_lExit  := .F.
							Endif

							aadd(_aItD3,   {{"D3_COD"    , SB1->B1_COD 		,NIL},;
								{"D3_UM"     , SB1->B1_UM		,NIL},;
								{"D3_QUANT"  , _nQuant			,NIL},;
								{"D3_LOCAL"  , SB1->B1_LOCPAD	,Nil},;
								{"D3_LOCALIZ", SBF->BF_LOCALIZ	,Nil},;
								{"D3_GRUPO"  , SB1->B1_GRUPO	,Nil},;
								{"D3_YNFPASY", RIGHT(_aLin[1],9),Nil}})

							AADD(_aPick,{_aLin[1],SB1->B1_COD,SB1->B1_UM,SB1->B1_LOCPAD,SBF->BF_LOCALIZ,_nQuant})

							_nQtOri :=  _nDif

							If _lExit
								Exit
							Endif

							SBF->(dbskip())
						EndDo

						If !_lExit
							AADD(_aErro,{_aLin[1],_aLin[2],SB1->B1_UM,SB1->B1_LOCPAD,Val(_aLin[3]),'Saldo Insuficiente!'})
							_lBKP := .F.
						Endif
					Else
						SB2->(dbSetOrder(1))
						If !SB2->(msSeek(xFilial('SB2')+SB1->B1_COD+SB1->B1_LOCPAD))
							AADD(_aErro,{_aLin[1],_aLin[2],SB1->B1_UM,SB1->B1_LOCPAD,Val(_aLin[3]),'Saldo Insuficiente!'})
							_lBKP := .F.
							FT_FSKIP()
							Loop
						Endif

						If SB2->B2_QATU >= _nQtOri

							aadd(_aItD3,   {{"D3_COD"    , SB1->B1_COD 		,NIL},;
								{"D3_UM"     , SB1->B1_UM		,NIL},;
								{"D3_QUANT"  , _nQtOri			,NIL},;
								{"D3_LOCAL"  , SB1->B1_LOCPAD	,Nil},;
								{"D3_LOCALIZ", ''				,Nil},;
								{"D3_GRUPO"  , SB1->B1_GRUPO	,Nil},;
								{"D3_YNFPASY", RIGHT(_aLin[1],9),Nil}})

							AADD(_aPick,{_aLin[1],SB1->B1_COD,SB1->B1_UM,SB1->B1_LOCPAD,'',_nQtOri})

						Else
							AADD(_aErro,{_aLin[1],_aLin[2],SB1->B1_UM,SB1->B1_LOCPAD,Val(_aLin[3]),'Saldo Insuficiente!'})
							_lBKP := .F.
							FT_FSKIP()
							Loop
						Endif
					Endif

					FT_FSKIP()

				Endif
			EndDo

			FT_FUSE()

			If _lBKP
				If Len(_aItD3) > 0
					lMSHelpAuto := .t.
					lMsErroAuto := .f.

					MSExecAuto({|x,y| MATA241(x,y)},_aCabD3,_aItD3,3)

					If !lMsErroAuto
						_cData    := GravaData(dDataBase,.f.,8)
						_cHora    := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

						__CopyFile( _cDir +_cFile, _cDir+"BKP\"+_cFile )
						FErase(_cDir +_cFile)
						//					MostraErro()
						PickList('R',_aPick)

					Else
						MostraErro()
					EndIf
				Endif

			Else
				MailErro(_aErro)
			Endif

		Else

			SD3->(dbOrderNickName('INDSD33'))
			If SD3->(msSeek(xFilial('SD3')+Substr(_cFile,3,9)))

				AAdd(_aCabD3,{"D3_DOC" 		,  SD3->D3_DOC	,NIL})
				_aItem := {}

				While SD3->(!EOF()) .And. SD3->D3_YNFPASY == Substr(_cFile,3,9)

					If SD3->D3_ESTORNO = 'S'
						SD3->(dbSkip())
						Loop
					Endif

					_aItem := {	{"D3_COD"		,SD3->D3_COD	,NIL},;
						{"D3_UM"		,SD3->D3_UM		,NIL},;
						{"D3_QUANT"		,SD3->D3_QUANT	,NIL},;
						{"D3_LOCAL"		,SD3->D3_LOCAL	,NIL},;
						{"D3_LOCALIZ"	,SD3->D3_LOCALIZ,NIL},;
						{"D3_ESTORNO"	,"S"			,NIL}}

					AADD(_aPick,{SD3->D3_YNFPASY,SD3->D3_COD,SD3->D3_UM,SD3->D3_LOCAL,SD3->D3_LOCALIZ,SD3->D3_QUANT})

					SD3->(dbSkip())
				EndDo

				If !Empty(_aItem)
					SD3->(dbOrderNickName('INDSD33'))
					SD3->(msSeek(xFilial('SD3')+Substr(_cFile,3,9)))

					lMsErroAuto := .f.

					MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCabD3,{_aItem},6) //estorno

					If !lMsErroAuto
						_cData    := GravaData(dDataBase,.f.,8)
						_cHora    := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

						__CopyFile( _cDir +_cFile, _cDir+"BKP\"+_cFile )
						FErase(_cDir +_cFile)
						//					MostraErro()
						PickList('D',_aPick)
					Else
						MostraErro()
					Endif
				Endif
			Endif
		Endif

	Next NI

	Conout('Fim Baixa Estoque - CR0075')

Return



Static Function PickList(_cTp,_aPick)

	ConOut("Inicio E-Mail Pick List - CR0075")

	oProcess := TWFProcess():New( "CR075P", "Pick List Estoque" )
	oProcess:NewTask( "CR075P", "\WORKFLOW\CR075P.htm" )
	oHTML := oProcess:oHTML

	oProcess:fDesc := "Pick List NF Pasy"

	If _cTp = 'R'
		_cSubject := "Pick List NF Pasy "
		_cCor		:= '153, 255, 153'
	Else
		_cSubject := "Cancelamento Pick List NF Pasy "
		_cCor		:= '255, 255, 0' //Amarelo
	Endif

	oProcess:cSubject := _cSubject

	For P := 1 To Len(_aPick)

		_cNF := _aPick[P][1]

		AADD( (oHtml:ValByName( "it.prod"   )), _aPick[P][2])
		AADD( (oHtml:ValByName( "it.um"    	)), _aPick[P][3])
		AADD( (oHtml:ValByName( "it.local"  )), _aPick[P][4])
		AADD( (oHtml:ValByName( "it.localiz")), _aPick[P][5])
		AADD( (oHtml:ValByName( "it.qtde"  	)), TRANSFORM( _aPick[P][6],   '@E 99,999.99' ))

	Next P

	If !Empty(_cNF)


		oHtml:ValByName( "nf" ,_cNF)
		oHtml:ValByName( "cor",	_cCor)

		Private _cTo := _cCC := ""

		SZG->(dbsetOrder(1))
		SZG->(dbGotop())

		While SZG->(!EOF())

			If 'N1' $ SZG->ZG_ROTINA
				_cTo += If(Empty(_cTo),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
			ElseIf 'N2' $ SZG->ZG_ROTINA
				_cCC += If(Empty(_cCC),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
			Endif

			SZG->(dbSkip())
		Enddo

		oProcess:cTo := _cTo
		oProcess:cCC := _cCC

		oProcess:Start()

		oProcess:Finish()


	Endif

	ConOut("Fim E-Mail Pick List - CR0075")

Return



Static Function MailErro(_aErro)

	ConOut("Inicio E-Mail Erro Baixa Estoque - CR0075")

	oProcess := TWFProcess():New( "CR075E", "Erro Baixa Estoque" )
	oProcess:NewTask( "CR075E", "\WORKFLOW\CR075E.htm" )
	oHTML := oProcess:oHTML

	oProcess:fDesc := "Erro Baixa Estoque NF Pasy"

	_cSubject := "Erro Baixa Estoque NF Pasy"

	oProcess:cSubject := _cSubject

	For P := 1 To Len(_aErro)

		_cNF := _aErro[P][1]

		AADD( (oHtml:ValByName( "it.prod"   )), _aErro[P][2])
		AADD( (oHtml:ValByName( "it.um"    	)), _aErro[P][3])
		AADD( (oHtml:ValByName( "it.local"  )), _aErro[P][4])
		AADD( (oHtml:ValByName( "it.qtde"  	)), TRANSFORM( _aErro[P][5],   '@E 99,999.99' ))
		AADD( (oHtml:ValByName( "it.erro"	)), _aErro[P][6])

	Next P

	If !Empty(_cNF)

		oHtml:ValByName( "nf",_cNF)

		Private _cTo := _cCC := ""

		SZG->(dbsetOrder(1))
		SZG->(dbGotop())

		While SZG->(!EOF())

			If 'O1' $ SZG->ZG_ROTINA
				_cTo += If(Empty(_cTo),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
			ElseIf 'O2' $ SZG->ZG_ROTINA
				_cCC += If(Empty(_cCC),ALLTRIM(SZG->ZG_EMAIL),';'+ALLTRIM(SZG->ZG_EMAIL))
			Endif

			SZG->(dbSkip())
		Enddo

		oProcess:cTo := _cTo
		If !Empty(_cCC)
			oProcess:cCC := _cCC
		Endif

		oProcess:Start()

		oProcess:Finish()

	Endif

	ConOut("Fim E-Mail Erro Baixa Estoque - CR0075")

Return
