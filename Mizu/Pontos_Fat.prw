#Include "rwmake.ch"
#Include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PONTOS_FATº Autor ³ Alexandro          º Data ³  09/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pontos de Entrada do Modulo Faturamento                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Sigafat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function MTASF2()

	_aAliOri := GetArea()

	SF2->F2_YLJTRAN := SC5->C5_YLJTRAN
	SF2->F2_YMOTOR  := SC5->C5_YMOTOR

	RestArea(_aAliOri)

Return()



User Function M460NUM()

	Local cSerNF 	  := cSerie
	Local _MVYSERIE  := GETMV("MV_YSERIE")
	Local _MVYFILKEY := GETMV("MV_YFILKEY")

	//If cEmpAnt $ "12/50" .And. UPPER(Alltrim(FunName())) == "MZ0123" 		Comentado por Alison - 10/10/2016
	If cEmpAnt + cFilAnt $ "1201|5001|0216" .And. UPPER(Alltrim(FunName())) == "MZ0123"
		cNumero := _cNFIBEC
		cSerie  := _cSERIBEC
	Else
		If cFilAnt $ _MVYFILKEY
			cSerNF := PadR(Left(_MVYSERIE,1),3)
			cSerNF := StrTran(cSerNF,"*"," ")
		EndiF

		cSerie  := cSerNF
	Endif

Return

User function M410ICM()

	_aAliOri := GetArea()

	//If cEmpAnt == "30" 		Comentado por Alison - 22/07/2016
	If cEmpAnt + cFilAnt $ '0210|3001'
		If SC5->C5_TIPO == "D" .And. SC5->C5_CLIENTE == "F02784"
			_ALIQICM    := 7
			_VALICM     := _BASEICM * (_ALIQICM / 100)
			MSGINFO("VAL ICM: "+Str(_VALICM)+" Aliquota: "+Str(_ALIQICM))
		Endif
	Endif

	RestArea(_aAliOri)

Return

User function M460ICM()

	_aAliOri := GetArea()

	//If cEmpAnt == "30"              Comentado por Alison - 22/07/2016
	If cEmpAnt + cFilAnt $ '0210|3001'
		If SC5->C5_TIPO == "D" .And. SC5->C5_CLIENTE == "F02784"
			_ALIQICM    := 7
			_VALICM     := _BASEICM * (_ALIQICM / 100)
			MSGINFO("VAL ICM: "+Str(_VALICM)+" Aliquota: "+Str(_ALIQICM))
		Endif
	Endif

	RestArea(_aAliOri)

Return


User Function MTA410()

	_lRet := .T.

	If !Empty(M->C5_VEICULO) .And. Empty(M->C5_YMOTOR)
		MsgAlert("O campo 'Veiculo' está preenchido, porém o campo 'Motorista' está em branco.")
		_lRet := .F.
	Endif

Return(_lRet)



User Function SX5NOTA()

	Local _aSeries:= {}
	Local lReturn := .T.
	Local xx      := 0
	Local nX6REg  := SX6->(Recno())
	Local aX5     := GetArea()
	Local _cMv    := ""
	Local _cSerie := Space(03)
	Local _lMVP16 := .F.

	If ISINCALLSTACK("MATA460A")
		_cSerie := GETMV("MV_YSERIE")
		_lMVP16 := .T.
	ElseIf ISINCALLSTACK("MATA410")
		_cSerie := GETMV("MV_YSERIE")
		_lMVP16 := .F.
	ElseIf ISINCALLSTACK("SPEDMDFE")
		_cSerie := GETMV("MV_YSERMDF")
		_lMVP16  := .f.
	Endif

	If _lMVP16
		//SE O PARAM SELEC FOR PARA CUPOM FISCAL CONSIDERA APENAS A SERIE 'ECF' QUE É PADRAO PARA ESSA SITUACAO
		_aSeries:= IIF( MV_PAR16==2 ,{"ECF"}, _aFilSerie( _cSerie ) )
	Else
		_aSeries := _aFilSerie( _cSerie )
	Endif

	For xx:=1 to Len(_aSeries)
		If (lReturn:=( PadR(sx5->x5_chave,3) == _aSeries[xx]))
			EXIT
		Endif
	Next
	//Endif

	SX6->( DbGoTo( nX6Reg ))
	RestArea(aX5)

Return lReturn




Static Function _AFilSerie( cMV_XSERNF )

	Local _aSeries:= {}
	Local nn      := 0
	Local nLen    := 0
	Local cChar   := ""
	Local _cSerie := ""

	nLen:=Len(Rtrim(cMV_XSERNF))

	For nn:=1 to nLen
		cChar:=Substr(cMV_XSERNF,nn,1)
		If cChar$";,#"
			AAdd(_aSeries,IIF(Len(_cSerie) < 3,PadR(_cSerie,3),_cSerie))
			_cSerie:=""
		Else
			_cSerie += cChar
		Endif
	Next

	If !Empty(_cSerie)
		AAdd(_aSeries,IIF(Len(_cSerie) < 3,PadR(_cSerie,3),_cSerie))
	Endif

Return(_aSeries)