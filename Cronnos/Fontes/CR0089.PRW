#include "TOTVS.ch"
#include "TOPCONN.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CR0089   ³ Autor ³ Fabiano da Silva      ³ Data ³ 22.03.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatório de Ocorrencias                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaEst                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ-±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CR0089()
	
	LOCAL titulo      := "Relatorio de Ocorrencias"
	LOCAL cDesc1      := "Este programa ira emitir as ocorrencias em relacao         "
	LOCAL cDesc2      := "A producao conforme lançamentos  "
	LOCAL cDesc3      := "Conforme Parametros informados.  Programa CR0089       "
	LOCAL CbCont,cabec1,cabec2
	tamanho           := "M"
	Limite            := 132
	cString           := "SD3"
	Private aOrd      := {"Por Data","Por Prensa","Por Ocorrencia","Por Nome"}
	PRIVATE aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
	PRIVATE nomeprog  := "CR0089"
	PRIVATE aLinha    := { },nLastKey := 0
	PRIVATE cPerg     := "CR0089"
	Private cArqLog
	
	cbtxt             := SPACE(10)
	cbcont            := 0
	li                := 80
	m_pag             := 1
	wnrel             := "CR0089"
	
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)
	
	_nOrdem := aReturn[8]
	
	Pergunte("CR0089",.F.)
	
	If nLastKey==27
		Set Filter to
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey==27
		Set Filter to
		Return
	Endif
	
	//  PERGUNTE CR0089
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01            // Emissao De                            ³
	//³ mv_par02            // Emissao Ate                           ³
	//³ mv_par03            // Prensa De                             ³
	//³ mv_par04            // Prensa Ate                            ³
	//  mv_par05            // Ocorrencia de                         ³
	//  mv_par06            // Ocorrencia ate                        ³
	//  mv_par07            // Operador de                           ³
	//  mv_par08            // Operador ate                          ³
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	
	_lFim      := .F.
	_cMsg01    := ''
	_lAborta01 := .T.
	_bAcao01   := {|_lFim| CR089A(@_lFim) }
	_cTitulo01 := 'Processando'
	RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
//	_cArqNew := "\relato\CR0089.dbf"
	dbSelectArea("TRB")
//	Copy All to &_cArqNew
	dbCloseArea()
	
	Ferase(cArqLog+".dbf")
	Ferase(cArqLog+OrdbagExt())
	
Return


Static Function CR089A(_lFim)    // PRENSA
	
	aStru := {}
	AADD(aStru,{"CODOP"    , "C" , 06, 0 })
	AADD(aStru,{"NOMOP"    , "C" , 20, 0 })
	AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
	AADD(aStru,{"DTEMIS"   , "D" ,  8, 0 })// DATA DE EMISSAO PEDIDO
	AADD(aStru,{"OCORRE"   , "C" , 06, 0 })// Ocorrencia
	AADD(aStru,{"NOMOCO"   , "C" , 30, 0 })// Nome da Ocorrencia
	AADD(aStru,{"PRENSA"   , "C" , 06, 0 })// PRENSA
	AADD(aStru,{"HORAS"    , "N" , 12, 2 })// Horas Perdidas
	AADD(aStru,{"PORCEN"   , "N" , 07, 2 })// Porcentagem
	AADD(aStru,{"EXTRA"    , "C" , 03, 0 })// Hora Extra
	AADD(aStru,{"HRPADR"   , "N" , 10, 2 })// Hora Padrão
	
	cArqLOG := CriaTrab(aStru,.T.)
	If _nOrdem == 1    // DATA
		cIndLOG := "DTOS(DTEMIS)+OCORRE+PRENSA+PRODUTO+NOMOP+EXTRA"
	ElseIf _nOrdem == 2      // PRENSA
		cIndLOG := "PRENSA+DTOS(DTEMIS)+OCORRE+PRODUTO+NOMOP+EXTRA"
	ElseIf _nOrdem == 3      // OCORRENCIA
		cIndLOG := "OCORRE+DTOS(DTEMIS)+PRENSA+PRODUTO+NOMOP+EXTRA"
	ElseIf _nOrdem == 4      // OPERADOR
		cIndLOG := "NOMOP+DTOS(DTEMIS)+OCORRE+PRENSA+PRODUTO+EXTRA"
	Endif
	
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
	_cQuery += " AND D3_YRECURS BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	_cQuery += " AND ZE_YOCORR 	BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	_cQuery += " AND D3_YOPPREN BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
	_cQuery += " AND Z6_TURNO 	BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"' "
	_cQuery += " AND D3_LOCAL IN ('20','45') "
	_cQuery += " AND LEFT(D3_CF,2) = 'PR' "
//	_cQuery += " AND ZE_YOCORR NOT IN ('019','020') "
	
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
			
			_nZaHI := _nZaHF := 0
			
			If !Empty(TSD3->D3_YTURNO)
				dbSelectArea("SZA")
				dbSetOrder(1)
				dbSeek(xFilial("SZA")+TSD3->D3_YTURNO)
				
				If SZA->ZA_ATIVO != "1"
					dbSelectArea("SD3")
					dbSkip()
					Loop
				Endif
				
				If (MV_PAR09 = 1 .And. SZA->ZA_LOCAL = "2") .Or.;
						(MV_PAR09 = 2 .And. SZA->ZA_LOCAL = "1")
					dbSelectArea("SD3")
					dbSkip()
					Loop
				Endif
				
				_nReI01 := Val(Substr(StrZero(SZA->ZA_HRINIRE,5,2),1,2))
				_nReI02 := Val(Substr(StrZero(SZA->ZA_HRINIRE,5,2),4,2))
				_nReF01 := Val(Substr(StrZero(SZA->ZA_HRFIMRE,5,2),1,2))
				_nReF02 := Val(Substr(StrZero(SZA->ZA_HRFIMRE,5,2),4,2))
				
				_nRefei := (((_nReF01 - _nReI01) * 60) - _nReI02) + _nReF02
				
				_nHIP01 := Val(Substr(StrZero(SZA->ZA_HRINI,5,2),1,2))
				_nHIP02 := Val(Substr(StrZero(SZA->ZA_HRINI,5,2),4,2))
				_nHFP01 := Val(Substr(StrZero(SZA->ZA_HRFIM,5,2),1,2))
				_nHFP02 := Val(Substr(StrZero(SZA->ZA_HRFIM,5,2),4,2))
				
				If SZA->ZA_HRINI > SZA->ZA_HRFIM
					_nHFP01 += 24
				Endif
				
				_nHCaf01 := Val(Substr(StrZero(SZA->ZA_CAFECON,5,2),1,2))
				_nHCaf02 := Val(Substr(StrZero(SZA->ZA_CAFECON,5,2),4,2))
				
				_nhrCafe := (_nHCaf01 * 60) + _nHCaf02
				
				_nHrsPad := (((((_nHFP01 - _nHIP01) * 60) - _nHIP02) + _nHFP02) - _nRefei) - _nhrCafe
				_nZaHI   := SZA->ZA_HRINIRE
				_nZaHF   := SZA->ZA_HRFIMRE
				_cExtra  := "NAO"
				
			Else
				_nHExIn1 := Val(Substr(StrZero(TSD3->D3_YHREXIN,5,2),1,2))
				_nHExIn2 := Val(Substr(StrZero(TSD3->D3_YHREXIN,5,2),4,2))
				_nHExFi1 := Val(Substr(StrZero(TSD3->D3_YHREXFI,5,2),1,2))
				_nHExFi2 := Val(Substr(StrZero(TSD3->D3_YHREXFI,5,2),4,2))
				
				If TSD3->D3_YHREXIN > TSD3->D3_YHREXFI
					_nHExFi1 += 24
				Endif
				
				// Desconto Hora Extra
				_nHDeE01 := Val(Substr(StrZero(TSD3->D3_YHREXDE,5,2),1,2))
				_nHDeE02 := Val(Substr(StrZero(TSD3->D3_YHREXDE,5,2),4,2))
				
				_nhrExDe := (_nHDeE01 * 60) + _nHDeE02
				
				_nHrsPad  := ((((_nHExFi1 - _nHExIn1) * 60) - _nHExIn2) + _nHExFi2) - _nhrExDe
				_cExtra   := "SIM"
				
			Endif
			
			//Ocorrências
			
			_cQrySZE := " SELECT * FROM "+RetSqlName("SZE")+" ZE "
			_cQrySZE += " WHERE ZE.D_E_L_E_T_ = '' AND ZE_FILIAL = '"+xFilial("SZE")+"' "
			_cQrySZE += " AND ZE_COD     = '"+TSD3->D3_COD+"' "
			_cQrySZE += " AND ZE_OP      = '"+TSD3->D3_OP+"' "
			_cQrySZE += " AND ZE_DOC     = '"+TSD3->D3_DOC+"' "
			_cQrySZE += " AND ZE_LOCAL   = '"+TSD3->D3_LOCAL+"' "
			_cQrySZE += " AND ZE_EMISSAO = '"+DTOS(TSD3->D3_EMISSAO)+"' "
			_cQrySZE += " AND ZE_YTURNO  = '"+TSD3->D3_YTURNO+"' "
			
			TcQuery _cQrySZE New alias "TSZE"
			
			TcSetField("TSZE","ZE_EMISSAO","D")
			
			Count to _nTSZE
			
			TSZE->(dbGoTop())
			
			_cOcorr := U_SetHora(0,'S')
			If _nTSZE > 0
				While !TSZE->(EOF())
					
					_cHorIni := U_SetHora(TSZE->ZE_YHORINI,'S')
					_cHorFim := U_SetHora(TSZE->ZE_YHORFIN,'S')
					
					_cOcorr := U_SetHora(SomaHoras(U_SetHora(SubHoras(_cHorFim,_cHorIni),'S'),_cOcorr),'S')
					
					TSZE->(dbSkip())
				EndDo
				
			Endif
			
			TSZE->(dbCloseArea())
			
			_nOcorr := GeramMin(_cOcorr)
			
			If _nOrdem == 1    // DATA
				_cSeek := DTOS(TSD3->D3_EMISSAO)+TSD3->ZE_YOCORR+TSD3->D3_YRECURS+TSD3->D3_COD+TSD3->Z6_NOME+_cExtra
			ElseIf _nOrdem == 2      // PRENSA
				_cSeek := TSD3->D3_YRECURS+DTOS(TSD3->D3_EMISSAO)+TSD3->ZE_YOCORR+TSD3->D3_COD+TSD3->Z6_NOME+_cExtra
			ElseIf _nOrdem == 3      // OCORRENCIA
				_cSeek := TSD3->ZE_YOCORR+DTOS(TSD3->D3_EMISSAO)+TSD3->D3_YRECURS+TSD3->D3_COD+TSD3->Z6_NOME+_cExtra
			ElseIf _nOrdem == 4      // OPERADOR
				_cSeek := TSD3->Z6_NOME+DTOS(TSD3->D3_EMISSAO)+TSD3->ZE_YOCORR+TSD3->D3_YRECURS+TSD3->D3_COD+_cExtra
			Endif
			
			_cDesOco := Alltrim(Posicione("SX5",1,xFilial("SX5")+'Z4'+TSD3->ZE_YOCORR,"X5_DESCRI"))
			dbSelectArea("TRB")
			If !dbSeek(_cSeek)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->CODOP    := TSD3->D3_YOPPRENA
				TRB->NOMOP    := TSD3->Z6_NOME
				TRB->PRODUTO  := TSD3->D3_COD
				TRB->DTEMIS   := TSD3->D3_EMISSAO
				TRB->OCORRE   := TSD3->ZE_YOCORR
				TRB->NOMOCO   := Substr(_cDesOco,1,30)
				TRB->PRENSA   := TSD3->D3_YRECURS
				TRB->HORAS    := Val(StrTran(_cOcorr,":","."))
				TRB->PORCEN   := (_nOcorr / _nHrsPad) * 100
				TRB->HRPADR   := _nHrsPad
				TRB->EXTRA    := _cExtra
				MsUnLock()
			Else
				_nMin2 := GeramMin(cValtoChar(TRB->HORAS))
				
				_nOcor1 := _nOcorr + _nMin2
				
				_nOcor2 := SomaHoras(_cOcorr, U_SetHora(TRB->HORAS,'S'))
				
				RecLock("TRB",.F.)
				TRB->HORAS    := _nOcor2
				TRB->PORCEN   := (_nOcor1 / _nHrsPad) * 100
				MsUnLock()
			Endif
			
			TSD3->(dbSkip())
		EndDo
		
		TSD3->(dbCloseArea())
		
		/*
		DATA       PRENSA  PRODUTO          OPERADOR               CODIGO   NOME OCORRENCIA                   HORAS PERD.       PORC  H.E
		99999999   999999  999999999999999  99999999999999999999   999999   999999999999999999999999999999    9999,999.99    9999.99  999
		0          11      19               36                     59       68                                102            117      126
		*/
		
		nTipo  := IIF(aReturn[4]==1,15,18)
		li     := 80
		titulo := "Relatorio de Ocorrencias"
		Cabec1 := "DATA       PRENSA  PRODUTO          OPERADOR               CODIGO   NOME OCORRENCIA                   HORAS PERD.       PORC  H.E"
		Cabec2 := ""
		
		If _nOrdem == 1    // DATA
			OrdData()
		ElseIf _nOrdem == 2      // PRENSA
			OrdPren()
		ElseIf _nOrdem == 3      // OCORRENCIA
			OrdOcor()
		ElseIf _nOrdem == 4      // OPERADOR
			OrdOper()
		Endif
	Endif
	
	If aReturn[5] = 1
		Set Printer to
		dbCommit()
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	
Return


Static Function OrdData(_lFim)
	
	_nTHoras  := _nQtHoras := _nTPorc := _nQtPorc := _nHora7:= 0
	_lDia    := .F.
	_dData   := ""
	_nTMin := 0
	
	dbSelectArea("TRB")
	dbGotop()
	
	SetRegua(LastRec())
	
	While !Eof() .And. !_lFim
		
		If _lFim
			Alert("Cancelado Pelo Usuario!!")
			Return
		Endif
		
		IncRegua("Imprimindo....")
		
		IF li > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		If _dData <> dToc(TRB->DTEMIS) .and. _lDia
			Li++
			@Li, 00  Psay "TOTAL DIA : "+_dData+"   -------->"
			@Li, 102 Psay _nQtHoras          			Picture TM(_nQtHoras,11,2)
			@Li, 117 Psay (_nHora7 /_nQtPorc )* 100    	Picture "@E 9999.99"
			
			_nTHoras  += _nQtHoras
			_nTPorc   += _nQtPorc
			_nTMin    += _nHora7
			_nQtHoras := _nQtPorc := 0
			Li += 2
		Endif
		
		_dData   := dToc(TRB->DTEMIS)
		_lDia    := .T.
		
		@Li, 00  PSay TRB->DTEMIS
		@Li, 11  Psay TRB->PRENSA
		@Li, 19  PSay TRB->PRODUTO
		@Li, 36  PSay TRB->NOMOP
		@Li, 59  PSay TRB->OCORRE
		@Li, 68  PSay TRB->NOMOCO
		@Li, 102 Psay TRB->HORAS            Picture TM(TRB->HORAS,11,2)
		@Li, 117 Psay TRB->PORCEN			Picture "@E 9999.99"
		@Li, 126 Psay TRB->EXTRA
		
		_nHora1   := (Val(Substr(StrZero(_nQtHoras,5,2),1,2))) * 60
		_nHora2   := Val(Substr(StrZero(_nQtHoras,5,2),4,2))
		_nHora3   := _nHora1 + _nHora2
		
		_nHora4   := (Val(Substr(StrZero(TRB->HORAS,5,2),1,2))) * 60
		_nHora5   := Val(Substr(StrZero(TRB->HORAS,5,2),4,2))
		_nHora6   := _nHora4 + _nHora5
		
		_nHora7   := _nHora3 + _nHora6
		_nHora8   := Val(Substr(StrZero((_nHora7 / 60),5,2),1,2))
		_nHora9   := (_nHora7 - (_nHora8 * 60)) / 100
		
		_nHoraA   := _nHora8 + _nHora9
		_nQtHoras := _nHoraA
		
		_nQtPorc  += TRB->HRPADR
		Li++
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	Li++
	
	@Li, 00  Psay "TOTAL DIA : "+_dData+"   -------->"
	@Li, 102 Psay _nQtHoras          			Picture TM(_nQtHoras,11,2)
	@Li, 117 Psay ( _nHora7 /_nQtPorc ) * 100	Picture "@E 9999.99"
	
	_nTHoras += _nQtHoras
	_nTPorc  += _nQtPorc
	_nTMin   += _nHora7
	
	Li += 2
	@Li,00 PSAY Replicate("-",limite)
	Li += 2
	
	@Li,000  PSAY "TOTAL GERAL   -------------------->"
	@Li, 102 Psay _nTHoras          			Picture TM(_nTHoras,11,2)
	@Li, 117 Psay (_nTMin /_nTPorc)* 100 		Picture "@E 9999.99"
	
Return


Static Function OrdPren(_lFim)
	
	_nTHoras  := _nQtHoras := _nTPorc := _nQtPorc := _nHora7:= 0
	_lDia     := .F.
	_cPrensa  := ""
	_nTMin    := 0
	_aData    := {}
	_nCont    := 0
	
	dbSelectArea("TRB")
	dbGotop()
	
	SetRegua(LastRec())
	
	While !Eof() .And. !_lFim
		
		If _lFim
			Alert("Cancelado Pelo Usuario!!")
			Return
		Endif
		
		IncRegua("Imprimindo....")
		
		IF li > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		If _cPrensa <> TRB->PRENSA .and. _lDia
			Li++
			@Li, 00  Psay "TOTAL PRENSA : "+_cPrensa+"   -------->"
			@Li, 102 Psay _nQtHoras          			Picture TM(_nQtHoras,11,2)
			@Li, 117 Psay (_nHora7 /_nQtPorc )* 100    	Picture "@E 9999.99"
			
			_nTHoras  += _nQtHoras
			_nTPorc   += _nQtPorc
			_nTMin    += _nHora7
			_nQtHoras := _nQtPorc := 0
			_aData    := {}
			_nCont    := 0
			Li += 2
		Endif
		
		_cPrensa := TRB->PRENSA
		_lDia    := .T.
		
		
		@Li, 00  PSay TRB->DTEMIS
		@Li, 11  Psay TRB->PRENSA
		@Li, 19  PSay TRB->PRODUTO
		@Li, 36  PSay TRB->NOMOP
		@Li, 59  PSay TRB->OCORRE
		@Li, 68  PSay TRB->NOMOCO
		@Li, 102 Psay TRB->HORAS            Picture TM(TRB->HORAS,11,2)
		@Li, 117 Psay TRB->PORCEN			Picture "@E 9999.99"
		@Li, 126 Psay TRB->EXTRA
		
		_nHora1   := (Val(Substr(StrZero(_nQtHoras,5,2),1,2))) * 60
		_nHora2   := Val(Substr(StrZero(_nQtHoras,5,2),4,2))
		_nHora3   := _nHora1 + _nHora2
		
		_nHora4   := (Val(Substr(StrZero(TRB->HORAS,5,2),1,2))) * 60
		_nHora5   := Val(Substr(StrZero(TRB->HORAS,5,2),4,2))
		_nHora6   := _nHora4 + _nHora5
		
		_nHora7   := _nHora3 + _nHora6
		_nHora8   := Val(Substr(StrZero((_nHora7 / 60),5,2),1,2))
		_nHora9   := (_nHora7 - (_nHora8 * 60)) / 100
		
		_nHoraA   := _nHora8 + _nHora9
		_nQtHoras := _nHoraA
		
		_nCont ++
		AADD(_aData,{TRB->DTEMIS,TRB->EXTRA,_nCont})
		
		For F := 1 To Len(_aData)
			If (_aData[f,1] == TRB->DTEMIS .And. _aData[f,2] == "SIM") .Or. _aData[f,1] != TRB->DTEMIS .Or. _aData[f,3] = 1
				_nQtPorc  += TRB->HRPADR
			Endif
		Next F
		
		_lPrim := .F.
		
		Li++
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	Li++
	
	@Li, 00  Psay "TOTAL PRENSA : "+_cPrensa+"   -------->"
	@Li, 102 Psay _nQtHoras          			Picture TM(_nQtHoras,11,2)
	@Li, 117 Psay ( _nHora7 /_nQtPorc ) * 100	Picture "@E 9999.99"
	
	_nTHoras += _nQtHoras
	_nTPorc  += _nQtPorc
	_nTMin   += _nHora7
	
	Li += 2
	@Li,00 PSAY Replicate("-",limite)
	Li += 2
	
	@Li,000  PSAY "TOTAL GERAL   -------------------->"
	@Li, 102 Psay _nTHoras          			Picture TM(_nTHoras,11,2)
	@Li, 117 Psay (_nTMin /_nTPorc)* 100 		Picture "@E 9999.99"
	
Return


Static Function OrdOcor(_lFim)
	
	_nTHoras  := _nQtHoras := _nTPorc := _nQtPorc := _nHora7:= 0
	_lDia     := .F.
	_cOcor    := ""
	_nTMin    := 0
	
	dbSelectArea("TRB")
	dbGotop()
	
	SetRegua(LastRec())
	
	While !Eof() .And. !_lFim
		
		If _lFim
			Alert("Cancelado Pelo Usuario!!")
			Return
		Endif
		
		IncRegua("Imprimindo....")
		
		IF li > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		If _cOcor <> TRB->OCORRE .and. _lDia
			Li++
			@Li, 00  Psay "TOTAL OCORRENCIA : "+_cOcor+"   -------->"
			@Li, 102 Psay _nQtHoras          			Picture TM(_nQtHoras,11,2)
			@Li, 117 Psay (_nHora7 /_nQtPorc )* 100    	Picture "@E 9999.99"
			
			_nTHoras  += _nQtHoras
			_nTPorc   += _nQtPorc
			_nTMin    += _nHora7
			_nQtHoras := _nQtPorc := 0
			Li += 2
		Endif
		
		_cOcor   := TRB->OCORRE
		_lDia    := .T.

		@Li, 00  PSay TRB->DTEMIS
		@Li, 11  Psay TRB->PRENSA
		@Li, 19  PSay TRB->PRODUTO
		@Li, 36  PSay TRB->NOMOP
		@Li, 59  PSay TRB->OCORRE
		@Li, 68  PSay TRB->NOMOCO
		@Li, 102 Psay TRB->HORAS            Picture TM(TRB->HORAS,11,2)
		@Li, 117 Psay TRB->PORCEN			Picture "@E 9999.99"
		@Li, 126 Psay TRB->EXTRA
		
		_nHora1   := (Val(Substr(StrZero(_nQtHoras,5,2),1,2))) * 60
		_nHora2   := Val(Substr(StrZero(_nQtHoras,5,2),4,2))
		_nHora3   := _nHora1 + _nHora2
		
		_nHora4   := (Val(Substr(StrZero(TRB->HORAS,5,2),1,2))) * 60
		_nHora5   := Val(Substr(StrZero(TRB->HORAS,5,2),4,2))
		_nHora6   := _nHora4 + _nHora5
		
		_nHora7   := _nHora3 + _nHora6
		_nHora8   := Val(Substr(StrZero((_nHora7 / 60),5,2),1,2))
		_nHora9   := (_nHora7 - (_nHora8 * 60)) / 100
		
		_nHoraA   := _nHora8 + _nHora9
		_nQtHoras := _nHoraA
		
		_nQtPorc  += TRB->HRPADR
		Li++
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	Li++
	
	@Li, 00  Psay "TOTAL OCORRENCIA : "+_cOcor+"   -------->"
	@Li, 102 Psay _nQtHoras          			Picture TM(_nQtHoras,11,2)
	@Li, 117 Psay ( _nHora7 /_nQtPorc ) * 100	Picture "@E 9999.99"
	
	_nTHoras += _nQtHoras
	_nTPorc  += _nQtPorc
	_nTMin   += _nHora7
	
	Li += 2
	@Li,00 PSAY Replicate("-",limite)
	Li += 2
	
	@Li,000  PSAY "TOTAL GERAL   -------------------->"
	@Li, 102 Psay _nTHoras          			Picture TM(_nTHoras,11,2)
	@Li, 117 Psay (_nTMin /_nTPorc)* 100 		Picture "@E 9999.99"
	
Return


Static Function OrdOper(_lFim)
	
	_nTHoras  := _nQtHoras := _nTPorc := _nQtPorc := _nHora7:= 0
	_lDia     := .F.
	_cOper    := ""
	_nTMin    := 0
	
	dbSelectArea("TRB")
	dbGotop()
	
	SetRegua(LastRec())
	
	While !Eof() .And. !_lFim
		
		If _lFim
			Alert("Cancelado Pelo Usuario!!")
			Return
		Endif
		
		IncRegua("Imprimindo....")
		
		IF li > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		If _cOper <> TRB->NOMOP .and. _lDia
			Li++
			@Li, 00  Psay "TOTAL OPERADOR : "+_coper+"   -------->"
			@Li, 102 Psay _nQtHoras          			Picture TM(_nQtHoras,11,2)
			@Li, 117 Psay (_nHora7 /_nQtPorc )* 100    	Picture "@E 9999.99"
			
			_nTHoras  += _nQtHoras
			_nTPorc   += _nQtPorc
			_nTMin    += _nHora7
			_nQtHoras := _nQtPorc := 0
			Li += 2
		Endif
		
		_cOper   := TRB->NOMOP
		_lDia    := .T.
		
		@Li, 00  PSay TRB->DTEMIS
		@Li, 11  Psay TRB->PRENSA
		@Li, 19  PSay TRB->PRODUTO
		@Li, 36  PSay TRB->NOMOP
		@Li, 59  PSay TRB->OCORRE
		@Li, 68  PSay TRB->NOMOCO
		@Li, 102 Psay TRB->HORAS            Picture TM(TRB->HORAS,11,2)
		@Li, 117 Psay TRB->PORCEN			Picture "@E 9999.99"
		@Li, 126 Psay TRB->EXTRA
		
		_nHora1   := (Val(Substr(StrZero(_nQtHoras,5,2),1,2))) * 60
		_nHora2   := Val(Substr(StrZero(_nQtHoras,5,2),4,2))
		_nHora3   := _nHora1 + _nHora2
		
		_nHora4   := (Val(Substr(StrZero(TRB->HORAS,5,2),1,2))) * 60
		_nHora5   := Val(Substr(StrZero(TRB->HORAS,5,2),4,2))
		_nHora6   := _nHora4 + _nHora5
		
		_nHora7   := _nHora3 + _nHora6
		_nHora8   := Val(Substr(StrZero((_nHora7 / 60),5,2),1,2))
		_nHora9   := (_nHora7 - (_nHora8 * 60)) / 100
		
		_nHoraA   := _nHora8 + _nHora9
		_nQtHoras := _nHoraA
		
		_nQtPorc  += TRB->HRPADR
		Li++
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	Li++
	
	@Li, 00  Psay "TOTAL OPERADOR : "+_cOper+"   -------->"
	@Li, 102 Psay _nQtHoras          			Picture TM(_nQtHoras,11,2)
	@Li, 117 Psay ( _nHora7 /_nQtPorc ) * 100	Picture "@E 9999.99"
	
	_nTHoras += _nQtHoras
	_nTPorc  += _nQtPorc
	_nTMin   += _nHora7
	
	Li += 2
	@Li,00 PSAY Replicate("-",limite)
	Li += 2
	
	@Li,000  PSAY "TOTAL GERAL   -------------------->"
	@Li, 102 Psay _nTHoras          			Picture TM(_nTHoras,11,2)
	@Li, 117 Psay (_nTMin /_nTPorc)* 100 		Picture "@E 9999.99"
	
Return


Static Function GeramMin(_cHora)
	
	_nHora1 := Val(SubStr(_cHora, 1, At(':', _cHora)-1))
	_nHora2 := Val(SubStr(_cHora, At(':', _cHora)+1, 2))
	
	_nMin := (_nHora1 * 60) + _nHora2
	
Return(_nMin)

