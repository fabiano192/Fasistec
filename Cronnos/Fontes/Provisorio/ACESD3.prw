#INCLUDE 'TOTVS.ch'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

User Function ACESD3()

	_nOpc := 0
	@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("")
	@ 02,10 TO 080,220
	@ 10,18 SAY "Rotina Para Gerar Saldo Inicial (SD3)       		"     SIZE 160,7
	@ 18,18 SAY "                                                    "     SIZE 160,7
	@ 26,18 SAY "                                                    "     SIZE 160,7
	@ 34,18 SAY "Programa ACESD3.prw                                 "     SIZE 160,7

	@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
	@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

	ACTIVATE DIALOG oDlg Centered

	If _nOpc == 1
		Private _lFim      := .F.
		Private _cMsg01    := ''
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| ACESD31(@_lFim) }
		Private _cTitulo01 := 'Gerando ajuste de Estoque !!!!'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	Endif

Return


Static Function ACESD31()

	Private _aItD3   := {}
	Private _aCabD3  := {}
	Private _aSB1	 := {}

	_cArqTrb:="CR_EST.DBF"
	_cArqInd:="CR_EST"

	dbUseArea(.T.,,_cArqTrb,"ZZ",.F.,.F.)
	_cInd := "TIPO+PRODUTO"
	IndRegua("ZZ",_cArqInd,_cInd,,,"Selecionando Arquivo Trabalho")

	ZZ->(dbGotop())

	ProcRegua(U_CONTREG())
	_nCount := 0
	_nDoc   := "B"

	While ZZ->(!EOF())

		IncProc()

		_aItD3  := {}
		_aCabD3 := {}
		_aSB1   := {}
		_aFan   := {}
		
		_cTM    := If(ZZ->TIPO = "D","003","502")
		_cTipo	:= ZZ->TIPO

	 		AAdd(_aCabD3,{"D3_DOC" 		, "20171201"+Alltrim(Soma1(_nDoc))			,NIL})
			AAdd(_aCabD3,{"D3_TM" 		, _cTM				,NIL})
			AAdd(_aCabD3,{"D3_EMISSAO"  , cTod("01/12/2017")	,NIL})

		_nCount := 0

		While ZZ->(!EOF()) .And. _cTipo == ZZ->TIPO .And. _nCount < 500

			If !Empty(ZZ->TIPO)

				SB1->(dbSetOrder(1))
				If SB1->(MsSeek(xFilial("SB1")+ZZ->PRODUTO))

					SB2->(dbSetOrder(1))
					IF !SB2->(MsSeek(xFilial("SB2") + ZZ->PRODUTO + ZZ->LOCPAD))
						CriaSB2(ZZ->PRODUTO,ZZ->LOCPAD)
					Endif
					
					aadd(_aItD3,   {{"D3_COD"    , ZZ->PRODUTO	,NIL},;
					{"D3_QUANT"  , 0							,NIL},;
					{"D3_LOCAL"  , ZZ->LOCPAD					,Nil},;
					{"D3_GRUPO"  , SB1->B1_GRUPO				,Nil},;
					{"D3_CUSTO1" , ABS(ZZ->VALOR)				,Nil}})

					If SB1->B1_MSBLQL = "1"
						SB1->(RecLock("SB1",.F.))
						SB1->B1_MSBLQL := "2"
						SB1->(MsUnLock())
						AADD(_aSB1,SB1->B1_COD)
					Endif

					If SB1->B1_FANTASM = "S"
						SB1->(RecLock("SB1",.F.))
						SB1->B1_FANTASM := "N"
						SB1->(MsUnLock())
						AADD(_aFan,SB1->B1_COD)
					Endif

				Endif
			Endif

//			_cUpd := " UPDATE "+RetSqlName("SB9")+" SET B9_CM1 = "+Alltrim(Str(ZZ->CUSTOUN))+", B9_VINI1 = "+Alltrim(Str(ZZ->CUSTOTO))
//			_cUpd += " WHERE B9_COD = '"+ZZ->PRODUTO+"' AND B9_LOCAL = '"+ZZ->LOCPAD+"' "
//			_cUpd += " AND B9_DATA = '20170531' "
//
//			TCSQLEXEC(_cUpd)

			_nCount ++

			ZZ->(dbskip())
		EndDo

		If Len(_aItD3) > 0
			lMSHelpAuto := .t.
			lMsErroAuto := .f.

			MSExecAuto({|x,y| MATA241(x,y)},_aCabD3,_aItD3,3)

			If lMsErroAuto
				MostraErro()
			EndIf
		Endif

		If !Empty(_aSB1)
			For F := 1 To Len(_aSB1)
				SB1->(dbSetOrder(1))
				If SB1->(MsSeek(xFilial("SB1")+_aSB1[F]))
					SB1->(RecLock("SB1",.F.))
					SB1->B1_MSBLQL := "1"
					SB1->(MsUnLock())
				Endif
			Next F
		Endif

		If !Empty(_aFan)
			For F := 1 To Len(_aFan)
				SB1->(dbSetOrder(1))
				If SB1->(MsSeek(xFilial("SB1")+_aFan[F]))
					SB1->(RecLock("SB1",.F.))
					SB1->B1_FANTASM := "S"
					SB1->(MsUnLock())
				Endif
			Next F
		Endif

	EndDo

	ZZ->(dbClosearea())

	MSGINFO("Alteracao Efetuada com Sucesso !!! ")

Return
