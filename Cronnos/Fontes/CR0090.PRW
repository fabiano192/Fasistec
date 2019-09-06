#include "rwmake.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
'±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CR0090A  ³ Autor ³ Fabiano da Silva      ³ Data ³ 23.03.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gráfico de Ocorrencias                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaEst                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ-±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CR0090()
	
	_aAliOri := GetArea()
	_lAchou  := .F.
	_nOpc    := 0
	
	@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Graficos de Ocorrencia ")
	@ 02,10 TO 080,220
	@ 10,18 SAY "Graficos de Ocorrencia                           "    SIZE 160,7
	@ 18,18 SAY "Conforme parametros informados                   "    SIZE 160,7
	@ 26,18 SAY "                                                 "    SIZE 160,7
	@ 34,18 SAY "Programa CR0090A.PRW                             "    SIZE 160,7
	
	@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("CR0090")
	@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
	@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()
	
	ACTIVATE DIALOG oDlg Centered
	
	If _nOpc == 1
		CR090A()
	Endif
	
Return


Static Function CR090A()
	
	_nTotHr := 0
	
	Pergunte("CR0090",.F.)
	
	///////////////////////////////////////
	///// MV_PAR01 : Data De ?         ////
	///// MV_PAR02 : Data Ate ?        ////
	///////////////////////////////////////
	
	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| CR090B(@_lFim) }
	Private _cTitulo01 := 'Processando'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
Return


Static Function CR090B(_lFim)
	
	aStru := {}
	AADD(aStru,{"OCORRE"   , "C" , 06, 0 })    // Ocorrencia
	AADD(aStru,{"NOMOCO"   , "C" , 30, 0 })    // Nome da Ocorrencia
	AADD(aStru,{"HORAS"    , "N" , 12, 2 })    // Horas Perdidas
	AADD(aStru,{"THORAS"   , "N" , 12, 2 })    // Total Horas Perdidas
	AADD(aStru,{"PHORAS"   , "N" , 12, 2 })    // Porcentagem Horas Perdidas
	AADD(aStru,{"DATADE"   , "D" , 08, 0 })    // Data emissão de
	AADD(aStru,{"DATATE"   , "D" , 08, 0 })    // Data emissão até
	
	cArqLOG := CriaTrab(aStru,.T.)
	cIndLOG := "OCORRE"
	
	dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)
	
	dbSelectArea("TRB")
	IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")
	
	
	_cQuery := " SELECT * FROM "+RetSqlName("SD3")+" D3 "
	_cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 ON D3_COD = B1_COD "
	_cQuery += " INNER JOIN "+RetSqlName("SZ6")+" Z6 ON D3_YOPPREN = Z6_CODIGO "
	_cQuery += " INNER JOIN "+RetSqlName("SZE")+" ZE ON ZE_COD = D3_COD AND ZE_OP = D3_OP AND ZE_DOC = D3_DOC AND ZE_LOCAL = D3_LOCAL "
	_cQuery += " AND ZE_EMISSAO = D3_EMISSAO AND ZE_YTURNO = D3_YTURNO "
	_cQuery += " WHERE D3.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' AND Z6.D_E_L_E_T_ = '' AND ZE.D_E_L_E_T_ = '' "
	_cQuery += " AND D3_FILIAL = '"+xFilial("SD3")+"' AND B1_FILIAL = '"+xFilial("SB1")+"' AND Z6_FILIAL = '"+xFilial("SZ6")+"' AND ZE_FILIAL = '"+xFilial("SZE")+"' "
	_cQuery += " AND D3_ESTORNO <> 'S' "
	_cQuery += " AND D3_EMISSAO	BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	_cQuery += " AND Z6_TURNO 	BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "
	_cQuery += " AND D3_LOCAL IN ('20','45') "
	_cQuery += " AND LEFT(D3_CF,2) = 'PR' "
	_cQuery += " AND ZE_YOCORR NOT IN ('019','020') "
	
	TcQuery _cQuery New alias "TSD3"
	
	TcSetField("TSD3","D3_EMISSAO","D")
	
	Count to _nTSD3
	
	If _nTSD3 > 0
		TSD3->(dbGoTop())
		
		SetRegua(_nTSD3)
		
		While !TSD3->(Eof()) .And. !_lFim
			
			IncRegua("Processando Movimento Interno!!")
			
			If _lFim
				Return
			Endif
			
			_nHIni1 := Val(Substr(StrZero(TSD3->ZE_YHORINI,5,2),1,2))
			_nHFim1 := Val(Substr(StrZero(TSD3->ZE_YHORFIN,5,2),1,2))
			_nHIni2 := Val(Substr(StrZero(TSD3->ZE_YHORINI,5,2),4,2))
			_nHFim2 := Val(Substr(StrZero(TSD3->ZE_YHORFIN,5,2),4,2))
			
			If TSD3->ZE_YHORINI > TSD3->ZE_YHORFIN
				_nHFim1 += 24
			Endif
			
			_nOcorr := (((_nHFim1 - _nHIni1) * 60) - _nHIni2) + _nHFim2
			
			dbSelectArea("SZA")
			SZA->(dbSetOrder(1))
			If SZA->(msSeek(xFilial("SZA")+SD3->D3_TURNO))
				
				_nZaHI := SZA->ZA_HRINIRE
				_nZaHF := SZA->ZA_HRFIMRE
				
				If SZA->ZA_ATIVO != "1"
					TSD3->(dbSkip())
					Loop
				Endif
				
				If (MV_PAR03 = 1 .And. SZA->ZA_LOCAL = "2") .Or.;
						(MV_PAR03 = 2 .And. SZA->ZA_LOCAL = "1")
					TSD3->(dbSkip())
					Loop
				Endif
				
				If SZA->ZA_CODIGO < MV_PAR04 .Or. SZA->ZA_CODIGO > MV_PAR05
					TSD3->(dbSkip())
					Loop
				Endif
			Endif
			
			_nOcor0 := _nOcorr / 60
			_nOcor1 := Int(_nOcor0)
			_nOcor2 := (_nOcorr - (_nOcor1 * 60)) / 100
			_nOcor3 := _nOcor1 + _nOcor2
			
			_cDesOco := Alltrim(Posicione("SX5",1,xFilial("SX5")+'Z4'+TSD3->ZE_YOCORR,"X5_DESCRI"))
			
			dbSelectArea("TRB")
			If !TRB->(msSeek(TSD3->D3_OCORR))
				TRB->(RecLock("TRB",.T.))
				TRB->OCORRE   := TSD3->D3_OCORR
				TRB->NOMOCO   := Substr(_cDesOco,1,30)
				TRB->HORAS    := _nOcor3
				TRB->DATADE   := MV_PAR01
				TRB->DATATE   := MV_PAR02
				TRB->(MsUnLock())
				_nTotHr       += _nOcor3
			Else
				_nHora1 := Int(TRB->HORAS) * 60
				_nHora2 := TRB->HORAS - Int(TRB->HORAS)
				_nHor21 := Val(Substr(StrZero(_nHora2,5,2),4,2))
				_nHora3 := _nHora1 + _nHor21
				
				_nOcor4 := _nOcorr + _nHora3
				_nOcor5 := Int(_nOcor4 / 60)
				_nOcor6 := (_nOcor4 - (_nOcor5 * 60)) / 100
				
				_nOcor7 := _nOcor5 + _nOcor6
				
				TRB->(RecLock("TRB",.F.))
				TRB->HORAS    := _nOcor7
				TRB->(MsUnLock())
				_nTotHr       += _nOcor3
			Endif
			
			TSD3->(dbSkip())
		EndDo
		
		TSD3->(dbCloseArea())
		
		TRB->(dbGotop())
		
		_aDados := {}
		While !TRB->(EOF())
			
			AADD(_aDados,{((TRB->HORAS / TRB->THORAS) * 100),TRB->NOMOCO})
			
			TRB->(dbSkip())
		EndDo
		
		TRB->(dbCloseArea())
		
		If !Empty(_aDados)
			U_FSGRAFICO("Gráfico de Ocorrências",_aDados,"CR0090")
		Else
			MsgInfo("Não existem dados para geração do gráifco!")
		Endif
	Endif
	
Return (NIL)
