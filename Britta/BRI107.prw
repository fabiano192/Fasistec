#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BRI107   ºAutor  ³ Alexandro da Silva º Data ³  14/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualização Base Consolidada                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFis                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BRI107()

	If cEmpAnt != "80"
		MSGSTOP("Favor Entrar Na Empresa Correta!")
		Return
	Endif

	Private _cEmpresaD := cEmpAnt
	Private _cFilialD  := cFilAnt
	Private	_MV_PAR01  := CTOD("")
	Private	_MV_PAR02  := CTOD("")

	ATUSX1()

	_nOpc := 0
	@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Atualização Base Consolidada ")
	@ 02,10 TO 080,220
	@ 10,18 SAY "Rotina Para Atualizar a Base Consolidada com os Dados"    SIZE 160,7
	@ 18,18 SAY "do Ambiente Oficial, Dados do Movimento Fiscal      "     SIZE 160,7
	@ 26,18 SAY "                                                    "     SIZE 160,7
	@ 34,18 SAY "                                                    "     SIZE 160,7

	@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("BRI107")
	@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
	@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

	Activate Dialog oDlg Centered

	If _nOpc == 1
		Pergunte("BRI107",.F.)

		_MV_PAR01 := MV_PAR01
		_MV_PAR02 := MV_PAR02

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ mv_par01 -> Data De                                                 ³
		//³ mv_par02 -> Data Ate                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		Private _cMsg01    := ''
		Private _lFim      := .F.
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| BRI107A(@_lFim) }
		Private _cTitulo01 := 'Exportando Movimentos - IRO - Britta!!!!'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

		Private _cMsg01    := ''
		Private _lFim      := .F.
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| BRI107B(@_lFim) }
		Private _cTitulo01 := 'Importando Movimentos - IRO - Britta!!!!'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

		Private _cMsg01    := ''
		Private _lFim      := .F.
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| BRI107C(@_lFim) }
		Private _cTitulo01 := 'Exportando Movimentos - IRO - PXA!!!!'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

		Private _cMsg01    := ''
		Private _lFim      := .F.
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| BRI107D(@_lFim) }
		Private _cTitulo01 := 'Importando Movimentos - IRO - PXA!!!!'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )


	Endif

Return


Static Function BRI107A(_lFim)

	_aTabela := {"CT1","CTT","CVB","SA1","SA2","SA3","SA4","SAH","SB1","SD1","SD2","SE4","SE6","SED","SF1","SF2","SF3","SF4","SFQ","SFT"}

	ProcRegua(Len(_aTabela))

	For AX:= 1 To Len(_aTabela)

		IncProc()

		(_cAlias) := _aTabela[AX]
		_cEmp     := "130"

		IncProc("Processando Empresa : "+_cEmp+" TABELA : "+(_cAlias))

		If (_cAlias) $ "SA1/SA2/SA3/SA4/SAH/SB1/CT1/CTT/CVB/SE4/SED/SF4"
			_cEmp := "010"
		Endif

		dbSelectArea(_cAlias)
		_aStru := dbStruct()

		_cTabela:= (_cAlias) + _cEmp

		_cQ := " SELECT * FROM "+_cTabela+" A "

		If (_cAlias)     == "SA1"
			_cQ += " WHERE EXISTS (SELECT * FROM SF2130 B WHERE F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND B.D_E_L_E_T_ = '') AND A.D_E_L_E_T_ = '' "
		ElseIf (_cAlias)     == "SA2"
			_cQ += " WHERE EXISTS (SELECT * FROM SF1130 B WHERE F1_FORNECE = A2_COD AND F1_LOJA = A2_LOJA AND B.D_E_L_E_T_ = '') AND A.D_E_L_E_T_ = '' "
		ElseIf (_cAlias)     == "SB1"
			_cQ += " WHERE ( EXISTS (SELECT * FROM SD1130 B WHERE D1_COD = B1_COD AND B.D_E_L_E_T_ = '') AND A.D_E_L_E_T_ = '' OR "
			_cQ += "         EXISTS (SELECT * FROM SD2130 B WHERE D2_COD = B1_COD AND B.D_E_L_E_T_ = '') AND A.D_E_L_E_T_ = '' )  "
			_cQ += " ORDER BY B1_COD "
		ElseIf (_cAlias)     == "SD1"
			_cQ += " WHERE A.D_E_L_E_T_ = '' "
			_cQ += " AND D1_DTDIGIT BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' "
		ElseIf (_cAlias) == "SD2"
			_cQ += " WHERE A.D_E_L_E_T_ = '' "
			_cQ += " AND D2_EMISSAO BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' "
		ElseIf (_cAlias) == "SE1"
			_cQ += " WHERE A.D_E_L_E_T_ = '' "
			_cQ += " AND E1_EMISSAO BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' "
		ElseIf (_cAlias) == "SE2"
			_cQ += " WHERE A.D_E_L_E_T_ = '' "
			_cQ += " AND E2_EMIS1   BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' "
		ElseIf (_cAlias) == "SE5"
			_cQ += " WHERE A.D_E_L_E_T_ = '' "
			_cQ += " AND E5_DATA    BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' "
		ElseIf (_cAlias) == "SF1"
			_cQ += " WHERE A.D_E_L_E_T_ = '' "
			_cQ += " AND F1_DTDIGIT BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' "
		ElseIf (_cAlias) == "SF2"
			_cQ += " WHERE A.D_E_L_E_T_ = '' "
			_cQ += " AND F2_EMISSAO BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' "
		ElseIf (_cAlias) == "SF3"
			_cQ += " WHERE A.D_E_L_E_T_ = '' "
			_cQ += " AND F3_ENTRADA BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' "
		ElseIf (_cAlias) == "SFT"
			_cQ += " WHERE A.D_E_L_E_T_ = '' "
			_cQ += " AND FT_ENTRADA BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' "
		Else
			_cQ += " WHERE A.D_E_L_E_T_ = '' "
		Endif

		If Select("ZZALE") > 0
			ZZALE->(dbCloseArea())
		Endif

		TCQUERY _cQ NEW ALIAS "ZZALE"

		If Left((_cAlias),1) == "S"
			_cCampo   := Right((_cAlias),2)+"_FILIAL"
		Else
			_cCampo   := (_cAlias)+"_FILIAL"
		Endif

		For ni := 1 to Len(_aStru)
			If _aStru[ni,2] = 'D'
				TCSetField("ZZALE", _aStru[ni,1], _aStru[ni,2],_aStru[ni,3],_aStru[ni,4])
			ElseIf _aStru[ni,2] = 'N'
				TCSetField("ZZALE", _aStru[ni,1], _aStru[ni,2],17,2)
			Endif
		Next

		dbSelectArea("ZZALE")

		_cArq    := CriaTrab(NIL,.F.)
		Copy To &_cArq

		ZZALE->(dbCloseArea())

		dbUseArea(.T.,,_cArq,"ZZALE",.T.)

		_cArqNew := "\FISCAL\BRITTA\"+_cTabela+".DTC"

		dbSelectArea("ZZALE")
		COPY ALL TO &_cArqNew  //VIA "DBFCDXADS"

		ZZALE->(dbCloseArea())

	Next AX

Return



Static Function BRI107B(_lFim)

	_aTabela := {"CT1","CTT","CVB","SA1","SA2","SA3","SA4","SAH","SB1","SD1","SD2","SE4","SE6","SED","SF1","SF2","SF3","SF4","SFQ","SFT"}

	ProcRegua(Len(_aTabela))

	For AX:= 1 To Len(_aTabela)

		(_cAlias) := _aTabela[AX]
		_cEmp     := "13"

		IncProc("Processando Empresa : "+_cEmp+" TABELA : "+(_cAlias))

		If (_cAlias) $ "SA1/SA2/SA3/SA4/SAH/SB1/CT1/CTT/CVB/SE4/SED/SF4"
			_cEmp     := "01"
		Endif

		_cTabela2:= (_cAlias) + _cEmp+"0"

		_cTrab   := "\FISCAL\BRITTA\"+_cTabela2+".DTC"

		If File(_cTrab)

			_cQ := "DELETE DADOS12.dbo."+_cAlias+"800" "
			If (_cAlias)         == "CT1"
				_cQ += " WHERE CT1_FILIAL IN ('01','02','03','04','06','07','08')"
			ElseIf (_cAlias)     == "CTT"
				_cQ += " WHERE CTT_FILIAL IN ('01','02','03','04','06','07','08')"
			ElseIf (_cAlias)     == "CVB"
				_cQ += " WHERE CVB_FILIAL IN ('01','02','03','04','06','07','08')"
			ElseIf (_cAlias)     == "SA1"
				_cQ += " WHERE A1_FILIAL  IN ('01','02','03','04','06','07','08')"
			ElseIf (_cAlias)     == "SA2"
				_cQ += " WHERE A2_FILIAL  IN ('01','02','03','04','06','07','08')"
			ElseIf (_cAlias)     == "SA3"
				_cQ += " WHERE A3_FILIAL  IN ('01','02','03','04','06','07','08')"
			ElseIf (_cAlias)     == "SA4"
				_cQ += " WHERE A4_FILIAL  IN ('01','02','03','04','06','07','08')"
			ElseIf (_cAlias)     == "SAH"
				_cQ += " WHERE AH_FILIAL  IN ('01','02','03','04','06','07','08')"
			ElseIf (_cAlias)     == "SB1"
				_cQ += " WHERE B1_FILIAL  IN ('01','02','03','04','06','07','08')"
			ElseIf (_cAlias)     == "SE4"
				_cQ += " WHERE E4_FILIAL  IN ('01','02','03','04','06','07','08')"
			ElseIf (_cAlias)     == "SE6"
				_cQ += " WHERE E6_FILIAL  IN ('01','02','03','04','06','07','08')"
			ElseIf (_cAlias)     == "SED"
				_cQ += " WHERE ED_FILIAL  IN ('01','02','03','04','06','07','08')"
			ElseIf (_cAlias)     == "SF4"
				_cQ += " WHERE F4_FILIAL  IN ('01','02','03','04','06','07','08')"
			ElseIf (_cAlias)     == "SD1"
				_cQ += " WHERE D1_DTDIGIT BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' AND D1_FILIAL IN ('01','02','03','04','06','07','08')"
			ElseIf (_cAlias) == "SD2"
				_cQ += " WHERE D2_EMISSAO BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' AND D2_FILIAL IN ('01','02','03','04','06','07','08')"
			ElseIf (_cAlias) == "SF1"
				_cQ += " WHERE F1_DTDIGIT BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' AND F1_FILIAL IN ('01','02','03','04','06','07','08')"
			ElseIf (_cAlias) == "SF2"
				_cQ += " WHERE F2_EMISSAO BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' AND F2_FILIAL IN ('01','02','03','04','06','07','08')"
			ElseIf (_cAlias) == "SF3"
				_cQ += " WHERE F3_ENTRADA BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' AND F3_FILIAL IN ('01','02','03','04','06','07','08')"
			ElseIf (_cAlias) == "SFT"
				_cQ += " WHERE FT_ENTRADA BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' AND FT_FILIAL IN ('01','02','03','04','06','07','08')"
			Endif

			TCSQLEXEC(_cQ)

			If Select("ZZALE") > 0
				ZZALE->(dbCloseArea())
			Endif

			dbUseArea(.T.,,_cTrab,"ZZALE",.F.,.F.)

			ZZALE->(dbGotop())

			While ZZALE->(!Eof()) .And. !_lFim

				If _lFim
					Alert("Cancelado pelo Operador!!")
					Return
				Endif

				_aCampos:= {}

				dbSelectArea("ZZALE")
				For _W := 1 To FCount()
					AADD(_aCampos,{FieldName(_W),FieldGet(_W)})
				Next

				If Left((_cAlias),1) == "S"
					_cCampFil  := Right((_cAlias),2)+"_FILIAL"
					_cCampEmp  := Right((_cAlias),2)+"_MSEMP"
					_cCampFil2 := Right((_cAlias),2)+"_MSFIL"
				Else
					_cCampFil  := (_cAlias)+"_FILIAL"
					_cCampEmp  := (_cAlias)+"_MSEMP"
					_cCampFil2 := (_cAlias)+"_MSFIL"
				Endif

				dbSelectArea( (_cAlias) )
				DbGotop()

				SM0->(dbSetOrder(1))
				If SM0->(dbSeek("80"))

					_cChav := SM0->M0_CODIGO

					_lSair :=.F.

					While SM0->(!Eof()) .And. _cChav == SM0->M0_CODIGO .And. !_lSair

						If SM0->M0_CODFIL == "05"
							SM0->(dbSkip())
							Loop
						Endif

						dbSelectArea( (_cAlias) )
						RecLock( (_cAlias) ,.T.)

						For _W:= 1 to Len(_aCampos)
							_nPos := (_cAlias)->(FieldPos(_aCampos[_W,1]))
							If _nPos > 0 //.and. Alltrim(_aCampos[_W,1]) != "A1_VEND"
								(_cAlias)->(FieldPut(_nPos,_aCampos[_W,2]))
							Endif
						Next

						If (_cAlias) $ "SA1/SA2/SA3/SA4/SAH/SB1/CT1/CTT/CVB/SE4/SED/SF4"
							If FieldPos(_cCampFil) > 0
								&((_cAlias)+"->"+_cCampFil):= SM0->M0_CODFIL
							Endif

							If FieldPos(_cCampFil2) > 0
								&((_cAlias)+"->"+_cCampFil2):= SM0->M0_CODFIL
							Endif
						Else
							_lSair := .T.
						Endif

						If FieldPos(_cCampEmp) > 0
							&((_cAlias)+"->"+_cCampEmp):= _cEmp
						Endif


						(_cAlias)->(MsUnlock())

						SM0->(dbSkip())
					EndDo
				Endif

				ZZALE->(dbSkip())
			EndDo

			If Select("ZZALE") > 0
				ZZALE->(dbCloseArea())
			Endif

			FErase(_cTrab)

			If File(_cTrab )
				Aviso( "Problema", "Não foi possível excluir o arquivo. O arquivo pode estar em uso."+Chr(13)+Chr(10)+Chr(13)+Chr(10), {"Ok"} )
			Endif
		Endif
	Next AX


	If Select("ZZALE") > 0
		ZZALE->(dbCloseArea())
	Endif

Return



Static Function BRI107C(_lFim) // EXPORTANDO MOVIMENTO DA IRO - PXA

	TCConType("TCPIP")

	_nPXA  := TCLINK("MSSQL/DADOS12","10.150.1.6",7890)

	If (_nPXA < 0)
		CONOUT("Falha Conexao DADOSPXA: "+ str(_nPXA, 10, 0))
		return .F.
	EndIf

	TCSETCONN(_nPXA)

	_aTabela := {"CT1","CTT","CVB","SA1","SA2","SA3","SA4","SAH","SB1","SD1","SD2","SE4","SE6","SED","SF1","SF2","SF3","SF4","SFQ","SFT"}

	ProcRegua(Len(_aTabela))

	For AX:= 1 To Len(_aTabela)

		IncProc()

		(_cAlias) := _aTabela[AX]
		_cEmp     := "010"

		IncProc("Processando Empresa : "+_cEmp+" TABELA : "+(_cAlias))

		//If (_cAlias) $ "SA1/SA2/SA3/SA4/SAH/SB1/CT1/CTT/CVB/SE4/SED/SF4"
		//	_cEmp := "010"
		//Endif

		dbSelectArea(_cAlias)
		_aStru := dbStruct()

		_cTabela:= (_cAlias) + _cEmp

		_cQ := " SELECT * FROM "+_cTabela+" A "

		If (_cAlias)     == "SA1"
			_cQ += " WHERE EXISTS (SELECT * FROM SF2010 B WHERE F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND B.D_E_L_E_T_ = '') AND A.D_E_L_E_T_ = '' "
		ElseIf (_cAlias)     == "SA2"
			_cQ += " WHERE EXISTS (SELECT * FROM SF1010 B WHERE F1_FORNECE = A2_COD AND F1_LOJA = A2_LOJA AND B.D_E_L_E_T_ = '') AND A.D_E_L_E_T_ = '' "
		ElseIf (_cAlias)     == "SB1"
			_cQ += " WHERE ( EXISTS (SELECT * FROM SD1010 B WHERE D1_COD = B1_COD AND B.D_E_L_E_T_ = '') AND A.D_E_L_E_T_ = '' OR "
			_cQ += "         EXISTS (SELECT * FROM SD2010 B WHERE D2_COD = B1_COD AND B.D_E_L_E_T_ = '') AND A.D_E_L_E_T_ = '' )  "
			_cQ += " ORDER BY B1_COD "
		ElseIf (_cAlias)     == "SD1"
			_cQ += " WHERE A.D_E_L_E_T_ = '' "
			_cQ += " AND D1_DTDIGIT BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' "
		ElseIf (_cAlias) == "SD2"
			_cQ += " WHERE A.D_E_L_E_T_ = '' "
			_cQ += " AND D2_EMISSAO BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' "
		ElseIf (_cAlias) == "SF1"
			_cQ += " WHERE A.D_E_L_E_T_ = '' "
			_cQ += " AND F1_DTDIGIT BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' "
		ElseIf (_cAlias) == "SF2"
			_cQ += " WHERE A.D_E_L_E_T_ = '' "
			_cQ += " AND F2_EMISSAO BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' "
		ElseIf (_cAlias) == "SF3"
			_cQ += " WHERE A.D_E_L_E_T_ = '' "
			_cQ += " AND F3_ENTRADA BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' "
		ElseIf (_cAlias) == "SFT"
			_cQ += " WHERE A.D_E_L_E_T_ = '' "
			_cQ += " AND FT_ENTRADA BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' "
		Else
			_cQ += " WHERE A.D_E_L_E_T_ = '' "
		Endif

		If Select("ZZALE") > 0
			ZZALE->(dbCloseArea())
		Endif

		TCQUERY _cQ NEW ALIAS "ZZALE"

		If Left((_cAlias),1) == "S"
			_cCampo   := Right((_cAlias),2)+"_FILIAL"
		Else
			_cCampo   := (_cAlias)+"_FILIAL"
		Endif

		For ni := 1 to Len(_aStru)
			If _aStru[ni,2] = 'D'
				TCSetField("ZZALE", _aStru[ni,1], _aStru[ni,2],_aStru[ni,3],_aStru[ni,4])
			ElseIf _aStru[ni,2] = 'N'
				TCSetField("ZZALE", _aStru[ni,1], _aStru[ni,2],17,2)
			Endif
		Next

		dbSelectArea("ZZALE")

		_cArq    := CriaTrab(NIL,.F.)
		Copy To &_cArq

		ZZALE->(dbCloseArea())

		dbUseArea(.T.,,_cArq,"ZZALE",.T.)

		_cArqNew := "\FISCAL\PXA\"+_cTabela+".DTC"

		dbSelectArea("ZZALE")
		COPY ALL TO &_cArqNew

		ZZALE->(dbCloseArea())

	Next AX

	TCUNLINK(_nPXA)

	TCConType("TCPIP")
	_nBRITTA := TCLINK("MSSQL/DADOS12","10.160.1.5")

	If (_nBRITTA < 0)
		CONOUT("Falha Conexao BRITTA: "+ str(_nBRITTA, 10, 0))
		return .F.
	EndIf

	TCSETCONN(_nBRITTA)

Return


Static Function BRI107D(_lFim)

	_aTabela := {"CT1","CTT","CVB","SA1","SA2","SA3","SA4","SAH","SB1","SD1","SD2","SE4","SE6","SED","SF1","SF2","SF3","SF4","SFQ","SFT"}

	ProcRegua(Len(_aTabela))

	For AX:= 1 To Len(_aTabela)

		(_cAlias) := _aTabela[AX]
		_cEmp     := "01"

		IncProc("Processando Empresa : "+_cEmp+" TABELA : "+(_cAlias))

		If (_cAlias) $ "SA1/SA2/SA3/SA4/SAH/SB1/CT1/CTT/CVB/SE4/SED/SF4"
			_cEmp     := "01"
		Endif

		_cTabela2:= (_cAlias) + _cEmp+"0"

		_cTrab   := "\FISCAL\PXA\"+_cTabela2+".DTC"

		If File(_cTrab)

			_cQ := "DELETE DADOS12.dbo."+_cAlias+"800" "
			If (_cAlias)         == "CT1"
				_cQ += " WHERE CT1_FILIAL IN ('05')
			ElseIf (_cAlias)     == "CTT"
				_cQ += " WHERE CTT_FILIAL IN ('05')
			ElseIf (_cAlias)     == "CVB"
				_cQ += " WHERE CVB_FILIAL IN ('05')
			ElseIf (_cAlias)     == "SA1"
				_cQ += " WHERE A1_FILIAL  IN ('05')
			ElseIf (_cAlias)     == "SA2"
				_cQ += " WHERE A2_FILIAL  IN ('05')
			ElseIf (_cAlias)     == "SA3"
				_cQ += " WHERE A3_FILIAL  IN ('05')
			ElseIf (_cAlias)     == "SA4"
				_cQ += " WHERE A4_FILIAL  IN ('05')
			ElseIf (_cAlias)     == "SAH"
				_cQ += " WHERE AH_FILIAL  IN ('05')
			ElseIf (_cAlias)     == "SB1"
				_cQ += " WHERE B1_FILIAL  IN ('05')
			ElseIf (_cAlias)     == "SE4"
				_cQ += " WHERE E4_FILIAL  IN ('05')
			ElseIf (_cAlias)     == "SE6"
				_cQ += " WHERE E6_FILIAL  IN ('05')
			ElseIf (_cAlias)     == "SED"
				_cQ += " WHERE ED_FILIAL  IN ('05')
			ElseIf (_cAlias)     == "SF4"
				_cQ += " WHERE F4_FILIAL  IN ('05')
			ElseIf (_cAlias)     == "SD1"
				_cQ += " WHERE D1_DTDIGIT BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' AND D1_FILIAL IN ('05')"
			ElseIf (_cAlias) == "SD2"
				_cQ += " WHERE D2_EMISSAO BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' AND D2_FILIAL IN ('05')"
			ElseIf (_cAlias) == "SF1"
				_cQ += " WHERE F1_DTDIGIT BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' AND F1_FILIAL IN ('05')"
			ElseIf (_cAlias) == "SF2"
				_cQ += " WHERE F2_EMISSAO BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' AND F2_FILIAL IN ('05')"
			ElseIf (_cAlias) == "SF3"
				_cQ += " WHERE F3_ENTRADA BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' AND F3_FILIAL IN ('05')"
			ElseIf (_cAlias) == "SFT"
				_cQ += " WHERE FT_ENTRADA BETWEEN '"+DTOS(_MV_PAR01)+"' AND '"+DTOS(_MV_PAR02)+"' AND FT_FILIAL IN ('05')"
			Endif

			TCSQLEXEC(_cQ)

			If Select("ZZALE") > 0
				ZZALE->(dbCloseArea())
			Endif

			dbUseArea(.T.,,_cTrab,"ZZALE",.F.,.F.)

			ZZALE->(dbGotop())

			While ZZALE->(!Eof()) .And. !_lFim

				If _lFim
					Alert("Cancelado pelo Operador!!")
					Return
				Endif

				_aCampos:= {}

				dbSelectArea("ZZALE")
				For _W := 1 To FCount()
					AADD(_aCampos,{FieldName(_W),FieldGet(_W)})
				Next

				If Left((_cAlias),1) == "S"
					_cCampFil  := Right((_cAlias),2)+"_FILIAL"
					_cCampEmp  := Right((_cAlias),2)+"_MSEMP"
					_cCampFil2 := Right((_cAlias),2)+"_MSFIL"
				Else
					_cCampFil  := (_cAlias)+"_FILIAL"
					_cCampEmp  := (_cAlias)+"_MSEMP"
					_cCampFil2 := (_cAlias)+"_MSFIL"
				Endif

				dbSelectArea( (_cAlias) )
				DbGotop()

				SM0->(dbSetOrder(1))
				If SM0->(dbSeek("80"))

					_cChav := SM0->M0_CODIGO

					_lSair :=.F.

					While SM0->(!Eof()) .And. _cChav == SM0->M0_CODIGO .And. !_lSair

						If SM0->M0_CODFIL != "05"
							SM0->(dbSkip())
							Loop
						Endif

						dbSelectArea( (_cAlias) )
						RecLock( (_cAlias) ,.T.)

						For _W:= 1 to Len(_aCampos)
							_nPos := (_cAlias)->(FieldPos(_aCampos[_W,1]))
							If _nPos > 0 //.and. Alltrim(_aCampos[_W,1]) != "A1_VEND"
								(_cAlias)->(FieldPut(_nPos,_aCampos[_W,2]))
							Endif
						Next

						If !(_cAlias) $ "SA1/SA2/SA3/SA4/SAH/SB1/CT1/CTT/CVB/SE4/SED/SF4"
							_lSair := .T.
						Endif

						If FieldPos(_cCampFil) > 0
							&((_cAlias)+"->"+_cCampFil):= SM0->M0_CODFIL
						Endif

						If FieldPos(_cCampFil2) > 0
							&((_cAlias)+"->"+_cCampFil2):= SM0->M0_CODFIL
						Endif

						If FieldPos(_cCampEmp) > 0
							&((_cAlias)+"->"+_cCampEmp):= _cEmp
						Endif

						(_cAlias)->(MsUnlock())

						SM0->(dbSkip())
					EndDo
				Endif

				ZZALE->(dbSkip())
			EndDo

			If Select("ZZALE") > 0
				ZZALE->(dbCloseArea())
			Endif

			FErase(_cTrab)

			If File(_cTrab )
				Aviso( "Problema", "Não foi possível excluir o arquivo. O arquivo pode estar em uso."+Chr(13)+Chr(10)+Chr(13)+Chr(10), {"Ok"} )
			Endif
		Endif
	Next AX


	If Select("ZZALE") > 0
		ZZALE->(dbCloseArea())
	Endif

Return



Static Function ATUSX1()

	cPerg := "BRI107"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 -> Data De                                                 ³
//³ mv_par02 -> Data Ate                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01        /defspa1/defeng1/Cnt01/Var02/Def02               /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(cPerg,"01","Data De              	   ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR01","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
	U_CRIASX1(cPerg,"02","Data Ate             	   ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")

Return