#include "Totvs.ch"
#include "TOPCONN.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CR0092   ³ Autor ³ Fabiano da Silva      ³ Data ³ 15.02.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Produçao Prevista X Produção Realizada                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaEst                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ-±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CR0092()
	
	LOCAL titulo      := "Producao Realizada X Producao Realizada"
	LOCAL cDesc1      := "Este programa ira emitir um comparativo em  relacao         "
	LOCAL cDesc2      := "A producao Prevista entre a Acumulada conforme lançamentos  "
	LOCAL cDesc3      := "PCP. Conforme Parametros informados.  Programa CR0092       "
	LOCAL CbCont,cabec1,cabec2
	tamanho           := "M"
	Limite            := 132
	cString           := "SD3"
	Private aOrd      := {"Por Data","Por Prensa","Por Operador","Por Produto"}
	PRIVATE aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
	PRIVATE nomeprog  := "CR0092"
	PRIVATE aLinha    := { },nLastKey := 0
	PRIVATE cPerg     := "CR0092"
	Private cArqLog
	Private cArLog1
	
	cbtxt             := SPACE(10)
	cbcont            := 0
	li                := 80
	m_pag             := 1
	wnrel             := "CR0092"
	
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)
	
	_nOrdem := aReturn[8]
	
	Pergunte("CR0092",.F.)
	
	If nLastKey==27
		Set Filter to
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey==27
		Set Filter to
		Return
	Endif
	
	//  PERGUNTE CR0092
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01            // Emissao De                            ³
	//³ mv_par02            // Emissao Ate                           ³
	//³ mv_par03            // Do Produto                            ³
	//³ mv_par04            // Ate o Produto                         ³
	//³ mv_par05            // Prensa De                             ³
	//³ mv_par06            // Prensa Ate                            ³
	//  mv_par07            // Operador De                           ³
	//  mv_par08            // Operador Ate                          ³
	//³ mv_par09            // Grupo De                              ³
	//³ mv_par10            // Grupo Ate                             ³
	//³ mv_par11            // SubGrupo De                           ³
	//³ mv_par12            // SubGrupo Ate                          ³
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	
	_lFim      := .F.
	_cMsg01    := ''
	_lAborta01 := .T.
	_bAcao01   := {|_lFim| CR092A(@_lFim) }
	_cTitulo01 := 'Processando'
	RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
	TRB->(dbCloseArea())
	
	//	TMP->(dbCloseArea())
	
	Ferase(cArqLog+".dbf")
	Ferase(cArqLog+OrdbagExt())
	
	//	Ferase(cArLog1+".dbf")
	//	Ferase(cArLog1+OrdbagExt())
	
Return


Static Function CR092A(_lFim)    // PRENSA
	
	_nHExFi1 := 0
	
	aStru := {}
	AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })    // PRODUTO PASY
	AADD(aStru,{"PRENSA"   , "C" , 06, 0 })    // PRENSA
	AADD(aStru,{"OPERADOR" , "C" , 06, 0 })    // OPERADOR DA PRENSA
	AADD(aStru,{"DTEMIS"   , "D" ,  8, 0 })    // DATA DE EMISSAO PEDIDO
	AADD(aStru,{"QTDCAV"   , "C" , 03, 0 })    // QUANTIDADE DE CAVIDADE
	AADD(aStru,{"CICLO"    , "N" ,  6, 2 })    // Ciclo
	//AADD(aStru,{"CICLO"    , "N" ,  5, 2 })    // Ciclo
	AADD(aStru,{"QTDREA"   , "N" , 14, 2 })    // QUANTIDADE DE PRODUCAO REALIZADO
	AADD(aStru,{"QTDPRE"   , "N" , 14, 2 })    // QUANTIDADE DE PRODUCAO PREVISTA
	AADD(aStru,{"PORCEN"   , "N" , 09, 2 })    // Porcentagem
	AADD(aStru,{"VALOR"    , "N" , 14, 2 })    // Valor
	AADD(aStru,{"QTE"      , "N" , 14, 2 })    // Valor
	AADD(aStru,{"OCORRE"   , "N" , 14, 2 })    // Ocorrencia
	AADD(aStru,{"EXTRA"    , "C" , 01, 0 })    // Extra
	AADD(aStru,{"NOMOPERA" , "C" , 30, 0 })    // Nome do OPERADOR DA PRENSA
	
	cArqLOG := CriaTrab(aStru,.T.)
	If _nOrdem == 1    // DATA
		cIndLOG := "DTOS(DTEMIS) + PRENSA + NOMOPERA + PRODUTO + EXTRA + QTDCAV"
	ElseIf _nOrdem == 2      // PRENSA
		cIndLOG := "PRENSA + DTOS(DTEMIS) + NOMOPERA + PRODUTO + EXTRA + QTDCAV"
	ElseIf _nOrdem == 3      // OPERADOR
		cIndLOG := "NOMOPERA + DTOS(DTEMIS) + PRENSA + PRODUTO + EXTRA + QTDCAV"
	ElseIf _nOrdem == 4      // PRODUTO
		cIndLOG := "PRODUTO + DTOS(DTEMIS) + PRENSA + NOMOPERA + EXTRA + QTDCAV"
	Endif
	
	dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)
	
	dbSelectArea("TRB")
	IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")
	
	_cQuery := " SELECT * FROM "+RetSqlName("SD3")+" D3 "
	_cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 ON D3_COD = B1_COD "
	_cQuery += " INNER JOIN "+RetSqlName("SZ6")+" Z6 ON D3_YOPPREN = Z6_CODIGO "
	_cQuery += " WHERE D3.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' AND Z6.D_E_L_E_T_ = '' "
	_cQuery += " AND D3_FILIAL = '"+xFilial("SD3")+"' AND B1_FILIAL = '"+xFilial("SB1")+"' AND Z6_FILIAL = '"+xFilial("SZ6")+"' "
	_cQuery += " AND D3_ESTORNO <> 'S' "
	_cQuery += " AND D3_EMISSAO	BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	_cQuery += " AND D3_COD 	BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	_cQuery += " AND D3_LOCAL IN ('20','45') "
	_cQuery += " AND LEFT(D3_CF,2) = 'PR' "
	_cQuery += " AND D3_YRECURS BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	_cQuery += " AND D3_YOPPREN BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
	_cQuery += " AND B1_GRUPO 	BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
	_cQuery += " AND B1_SUBGR 	BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' "
	_cQuery += " AND Z6_TURNO 	BETWEEN '"+MV_PAR14+"' AND '"+MV_PAR15+"' "
	
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
			
			_cNomOpe  := Substr(TSD3->Z6_NOME,1,30)
			
			_nPrVen  := 0
			_cCodSG1 := ""
			
			dbSelectArea("SG1")
			SG1->(dbSetOrder(2))
			If SG1->(msSeek(xFilial("SG1")+TSD3->D3_COD))
				
				_lWhile := .T.
				While SG1->(!EOF()) .And. _lWhile
					
					SB1->(dbSetOrder(1))
					SB1->(msSeek(xFilial("SB1")+SG1->G1_COD))
					
					If SB1->B1_TIPO = 'PA'
						_lWhile := .F.
						_cCodSG1 := SG1->G1_COD
						
						_cQrySD2 := " SELECT TOP 1 D2_COD,D2_PRCVEN,D2_EMISSAO FROM "+RetSqlName("SD2")+" D2 "
						_cQrySD2 += " INNER JOIN "+RetSqlName("SF4")+" F4 ON D2.D2_TES = F4_CODIGO "
						_cQrySD2 += " WHERE D2.D_E_L_E_T_ = '' AND D2.D2_COD = '"+_cCodSG1+"' "
						_cQrySD2 += " AND F4.D_E_L_E_T_ = '' AND F4_DUPLIC = 'S' "
						_cQrySD2 += " ORDER BY D2_EMISSAO DESC "
						
						TcQuery _cQrySD2 New alias "TSD2"
						
						TcSetField("TSD2","D2_EMISSAO","D")
						
						Count to _nTSD2
						
						If _nTSD2 > 0
							TSD2->(dbGoTop())
							
							_nPrVen := TSD2->D2_PRCVEN
						Endif
						TSD2->(dbCloseArea())
					Endif
					
					SG1->(dbSkip())
				EndDo
			Endif
			
			_nHrsPad := _nZaHI := _nZaHF  := 0
			_cExtra  := "N"
			
			If !Empty(TSD3->D3_YTURNO)
				dbSelectArea("SZA")
				SZA->(dbSetOrder(1))
				SZA->(msSeek(xFilial("SZA")+TSD3->D3_YTURNO))
				
				If SZA->ZA_ATIVO != "1"
					TSD3->(dbSkip())
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
				_cExtra   := "S"
				
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
				_cSeek := DTOS(TSD3->D3_EMISSAO)+TSD3->D3_YRECURS+_cNomOpe+TSD3->D3_COD+_cExtra+ TSD3->D3_YNUMCAV
			ElseIf _nOrdem == 2      // PRENSA
				_cSeek := TSD3->D3_YRECURS+DTOS(TSD3->D3_EMISSAO)+_cNomOpe+TSD3->D3_COD+_cExtra+ TSD3->D3_YNUMCAV
			ElseIf _nOrdem == 3      // OPERADOR
				_cSeek := _cNomOpe+DTOS(TSD3->D3_EMISSAO)+TSD3->D3_YRECURS+TSD3->D3_COD+_cExtra+ TSD3->D3_YNUMCAV
			ElseIf _nOrdem == 4      // PRODUTO
				_cSeek := TSD3->D3_COD+DTOS(TSD3->D3_EMISSAO)+TSD3->D3_YRECURS+_cNomOpe+_cExtra+ TSD3->D3_YNUMCAV
			Endif
			
			dbSelectArea("TRB")
			If TRB->(msSeek(_cSeek))
				TRB->(RecLock("TRB",.F.))
				TRB->OCORRE   += _nOcorr
				TRB->QTE      += TSD3->D3_QUANT
				TRB->VALOR    := TRB->QTE * _nPrVen
				TRB->QTDREA   += (TSD3->D3_QUANT / VAL(TSD3->D3_YNUMCAV))
				TRB->QTDPRE   := (_nHrsPad - TRB->OCORRE) / TSD3->D3_YCICLO
				TRB->PORCEN   := (TRB->QTDREA / TRB->QTDPRE) * 100
				TRB->(MsUnLock())
			Else
				TRB->(RecLock("TRB",.T.))
				TRB->DTEMIS   := TSD3->D3_EMISSAO
				TRB->PRODUTO  := TSD3->D3_COD
				TRB->QTDCAV   := If(Len(TSD3->D3_YNUMCAV) = 1, "0"+TSD3->D3_YNUMCAV , TSD3->D3_YNUMCAV)
				TRB->CICLO    := TSD3->D3_YCICLO
				TRB->PRENSA   := TSD3->D3_YRECURS
				TRB->OPERADOR := TSD3->D3_YOPPREN
				TRB->QTDREA   := (TSD3->D3_QUANT / VAL(TSD3->D3_YNUMCAV))
				TRB->QTDPRE   := (_nHrsPad - _nOcorr) / TSD3->D3_YCICLO
				TRB->PORCEN   := (TRB->QTDREA / TRB->QTDPRE) * 100
				TRB->VALOR    := TSD3->D3_QUANT * _nPrVen
				TRB->QTE      := TSD3->D3_QUANT
				TRB->OCORRE   := _nOcorr
				TRB->EXTRA    := _cExtra
				TRB->NOMOPERA := _cNomOpe
				TRB->(MsUnLock())
			Endif
			
			TSD3->(dbSkip())
		EndDo
	Endif
	
	TSD3->(dbCloseArea())
	
	/*
	DATA       PRODUTO         CICLO QTE.CAV   NR PRENSA   OPERADOR   PRENSADA PREVISTA   PRENSADA REALIZADA    PORC.            VALOR
	99999999   999999999999999 99999     999   999999      999999        999,999,999.99       999,999,999.99  9999.99   999,999,999.99
	0          11              27        37    43          55            69                   90              106       116
	*/
	
	nTipo  := IIF(aReturn[4]==1,15,18)
	li     := 80
	Titulo := "PRENSADA PREVISTA X PRENSADA REALIZADA"
	Cabec1 := "DATA       PRODUTO         CICLO QTE.CAV   NR PRENSA   OPERADOR   PRENSADA PREVISTA   PRENSADA REALIZADA    PORC.            VALOR"
	Cabec2 := ""
	
	If _nOrdem == 1    // DATA
		OrdData()
	ElseIf _nOrdem == 2      // PRENSA
		OrdPren()
	ElseIf _nOrdem == 3      // OPERADOR
		OrdOper()
	ElseIf _nOrdem == 4      // PRODUTO
		OrdProd()
	Endif
	
	If aReturn[5] = 1
		Set Printer to
		dbCommit()
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	
Return


Static Function OrdData(_lFim)
	
	_nTQtPre := _nTQtRea := _nTValor := 0
	_nQtePre := _nQteRea := _nValor  := 0
	_lDia    := .F.
	_dData   := ""
	
	dbSelectArea("TRB")
	dbGotop()
	
	SetRegua(LastRec())
	
	While !Eof() .And. !_lFim
		
		If _lFim
			Alert("Cancelado Pelo Usuario!!")
			Return
		Endif
		
		IncRegua("Imprimindo....")
		
		If TRB->EXTRA == "S"
			dbSelectArea("TRB")
			dbSkip()
			Loop
		Endif
		
		IF li > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		If _dData <> dToc(TRB->DTEMIS) .and. _lDia
			Li++
			@Li, 00  Psay "TOTAL DIA : "+_dData+"   -------->"
			@Li, 69  Psay _nQtePre          			Picture TM(_nQtePre,14,2)
			@Li, 90  Psay _nQteRea           			Picture TM(_nQteRea,14,2)
			@Li,107  Psay (_nQteRea /_nQtePre) * 100	Picture "@E 9999.99"
			@Li,116  Psay _nValor            			Picture TM(_nValor,14,2)
			
			_nTQtPre += _nQtePre
			_nTQtRea += _nQteRea
			_nTValor += _nValor
			_nQtePre := _nQteRea := _nValor := 0
			Li += 2
		Endif
		
		_dData   := dToc(TRB->DTEMIS)
		_lDia    := .T.
		
		@Li, 00  PSay TRB->DTEMIS
		@Li, 11  PSay TRB->PRODUTO
		@Li, 27  Psay TRB->CICLO           Picture TM(TRB->CICLO,6,2)
		@Li, 37  Psay TRB->QTDCAV
		@Li, 43  Psay TRB->PRENSA
		@Li, 55  Psay TRB->OPERADOR
		@Li, 69  Psay TRB->QTDPRE           Picture TM(TRB->QTDPRE,14,2)
		@Li, 90  Psay TRB->QTDREA           Picture TM(TRB->QTDREA,14,2)
		@Li,106  Psay TRB->PORCEN			Picture "@E 9999.99"
		@Li,116  Psay TRB->VALOR            Picture TM(TRB->VALOR,14,2)
		
		_nQtePre += TRB->QTDPRE
		_nQteRea += TRB->QTDREA
		_nValor  += TRB->VALOR
		
		Li++
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	Li++
	
	@Li, 00  Psay "TOTAL DIA : "+_dData+"   -------->"
	@Li, 69  Psay _nQtePre          			Picture TM(_nQtePre,14,2)
	@Li, 90  Psay _nQteRea           			Picture TM(_nQteRea,14,2)
	@Li,107  Psay (_nQteRea /_nQtePre) * 100	Picture "@E 9999.99"
	@Li,116  Psay _nValor            			Picture TM(_nValor,14,2)
	
	_nTQtPre += _nQtePre
	_nTQtRea += _nQteRea
	_nTValor += _nValor
	
	Li += 2
	@Li,00 PSAY Replicate("-",limite)
	Li += 2
	
	@Li,057 PSAY "HORAS EXTRAS"
	Li += 1
	@Li,056 PSAY "=============="
	Li += 3
	
	_nQtePre := _nQteRea := _nValor  := 0
	_lDia    := .F.
	_dData   := ""
	
	dbSelectArea("TRB")
	dbGotop()
	
	SetRegua(LastRec())
	
	While !Eof() .And. !_lFim
		
		If _lFim
			Alert("Cancelado Pelo Usuario!!")
			Return
		Endif
		
		IncRegua("Imprimindo....")
		
		If TRB->EXTRA == "N"
			dbSelectArea("TRB")
			dbSkip()
			Loop
		Endif
		
		IF li > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		If _dData <> dToc(TRB->DTEMIS) .and. _lDia
			Li++
			@Li, 00  Psay "TOTAL DIA : "+_dData+"   -------->"
			@Li, 69  Psay _nQtePre          			Picture TM(_nQtePre,14,2)
			@Li, 90  Psay _nQteRea           			Picture TM(_nQteRea,14,2)
			@Li,107  Psay (_nQteRea /_nQtePre) * 100	Picture "@E 9999.99"
			@Li,116  Psay _nValor            			Picture TM(_nValor,14,2)
			
			_nTQtPre += _nQtePre
			_nTQtRea += _nQteRea
			_nTValor += _nValor
			_nQtePre := _nQteRea := _nValor := 0
			Li += 2
		Endif
		
		_dData   := dToc(TRB->DTEMIS)
		_lDia    := .T.
		
		@Li, 00  PSay TRB->DTEMIS
		@Li, 11  PSay TRB->PRODUTO
		@Li, 27  Psay TRB->CICLO           Picture TM(TRB->CICLO,6,2)
		@Li, 37  Psay TRB->QTDCAV
		@Li, 43  Psay TRB->PRENSA
		@Li, 55  Psay TRB->OPERADOR
		@Li, 69  Psay TRB->QTDPRE           Picture TM(TRB->QTDPRE,14,2)
		@Li, 90  Psay TRB->QTDREA           Picture TM(TRB->QTDREA,14,2)
		@Li,106  Psay TRB->PORCEN			Picture "@E 9999.99"
		@Li,116  Psay TRB->VALOR            Picture TM(TRB->VALOR,14,2)
		
		_nQtePre += TRB->QTDPRE
		_nQteRea += TRB->QTDREA
		_nValor  += TRB->VALOR
		
		Li++
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	Li++
	
	@Li, 00  Psay "TOTAL DIA : "+_dData+"   -------->"
	@Li, 69  Psay _nQtePre          			Picture TM(_nQtePre,14,2)
	@Li, 90  Psay _nQteRea           			Picture TM(_nQteRea,14,2)
	@Li,107  Psay (_nQteRea /_nQtePre) * 100	Picture "@E 9999.99"
	@Li,116  Psay _nValor            			Picture TM(_nValor,14,2)
	
	_nTQtPre += _nQtePre
	_nTQtRea += _nQteRea
	_nTValor += _nValor
	
	Li += 2
	@Li,00 PSAY Replicate("-",limite)
	Li += 2
	
	@Li,000 PSAY "TOTAL GERAL   -------------------->"
	@Li, 69  Psay _nTQtPre          			Picture TM(_nTQtPre,14,2)
	@Li, 90  Psay _nTQtRea           			Picture TM(_nTQtRea,14,2)
	@Li,107  Psay (_nTQtRea / _nTQtPre) * 100	Picture "@E 9999.99"
	@Li,116  Psay _nTValor            			Picture TM(_nValor,14,2)
	
Return


Static Function OrdPren(_lFim)
	
	_nTQtPre := _nTQtRea := _nTValor := 0
	_nQtePre := _nQteRea := _nValor  := 0
	_lPrensa := .F.
	_cPrensa := ""
	
	dbSelectArea("TRB")
	dbGotop()
	
	SetRegua(LastRec())
	
	While !Eof() .And. !_lFim
		
		If _lFim
			Alert("Cancelado Pelo Usuario!!")
			Return
		Endif
		
		IncRegua("Imprimindo....")
		
		If TRB->EXTRA == "S"
			dbSelectArea("TRB")
			dbSkip()
			Loop
		Endif
		
		IF li > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		If _cPrensa <> TRB->PRENSA .and. _lPrensa
			Li++
			@Li, 00  Psay "TOTAL PRENSA : "+_cPrensa+"   -------->"
			@Li, 69  Psay _nQtePre          			Picture TM(_nQtePre,14,2)
			@Li, 90  Psay _nQteRea           			Picture TM(_nQteRea,14,2)
			@Li,107  Psay (_nQteRea /_nQtePre) * 100	Picture "@E 9999.99"
			@Li,116  Psay _nValor            			Picture TM(_nValor,14,2)
			
			_nTQtPre += _nQtePre
			_nTQtRea += _nQteRea
			_nTValor += _nValor
			_nQtePre := _nQteRea := _nValor := 0
			Li += 2
		Endif
		
		_cPrensa := TRB->PRENSA
		_lPrensa := .T.
		
		@Li, 00  PSay TRB->DTEMIS
		@Li, 11  PSay TRB->PRODUTO
		@Li, 27  Psay TRB->CICLO           Picture TM(TRB->CICLO,6,2)
		@Li, 37  Psay TRB->QTDCAV
		@Li, 43  Psay TRB->PRENSA
		@Li, 55  Psay TRB->OPERADOR
		@Li, 69  Psay TRB->QTDPRE           Picture TM(TRB->QTDPRE,14,2)
		@Li, 90  Psay TRB->QTDREA           Picture TM(TRB->QTDREA,14,2)
		@Li,106  Psay TRB->PORCEN			Picture "@E 9999.99"
		@Li,116  Psay TRB->VALOR            Picture TM(TRB->VALOR,14,2)
		
		_nQtePre += TRB->QTDPRE
		_nQteRea += TRB->QTDREA
		_nValor  += TRB->VALOR
		
		Li++
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	Li++
	
	@Li, 00  Psay "TOTAL PRENSA : "+_cPrensa+"   -------->"
	@Li, 69  Psay _nQtePre          			Picture TM(_nQtePre,14,2)
	@Li, 90  Psay _nQteRea           			Picture TM(_nQteRea,14,2)
	@Li,107  Psay (_nQteRea /_nQtePre) * 100	Picture "@E 9999.99"
	@Li,116  Psay _nValor            			Picture TM(_nValor,14,2)
	
	_nTQtPre += _nQtePre
	_nTQtRea += _nQteRea
	_nTValor += _nValor
	
	Li += 2
	@Li,00 PSAY Replicate("-",limite)
	Li += 2
	
	@Li,057 PSAY "HORAS EXTRAS"
	Li += 1
	@Li,056 PSAY "=============="
	Li += 3
	
	_nQtePre := _nQteRea := _nValor  := 0
	_lPrensa := .F.
	_cPrensa := ""
	
	dbSelectArea("TRB")
	dbGotop()
	
	SetRegua(LastRec())
	
	While !Eof() .And. !_lFim
		
		If _lFim
			Alert("Cancelado Pelo Usuario!!")
			Return
		Endif
		
		IncRegua("Imprimindo....")
		
		If TRB->EXTRA == "N"
			dbSelectArea("TRB")
			dbSkip()
			Loop
		Endif
		
		IF li > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		If _cPrensa <> TRB->PRENSA .and. _lPrensa
			Li++
			@Li, 00  Psay "TOTAL PRENSA : "+_cPrensa+"   -------->"
			@Li, 69  Psay _nQtePre          			Picture TM(_nQtePre,14,2)
			@Li, 90  Psay _nQteRea           			Picture TM(_nQteRea,14,2)
			@Li,107  Psay (_nQteRea /_nQtePre) * 100	Picture "@E 9999.99"
			@Li,116  Psay _nValor            			Picture TM(_nValor,14,2)
			
			_nTQtPre += _nQtePre
			_nTQtRea += _nQteRea
			_nTValor += _nValor
			_nQtePre := _nQteRea := _nValor := 0
			Li += 2
		Endif
		
		_cPrensa := TRB->PRENSA
		_lPrensa := .T.
		
		@Li, 00  PSay TRB->DTEMIS
		@Li, 11  PSay TRB->PRODUTO
		@Li, 27  Psay TRB->CICLO           Picture TM(TRB->CICLO,6,2)
		@Li, 37  Psay TRB->QTDCAV
		@Li, 43  Psay TRB->PRENSA
		@Li, 55  Psay TRB->OPERADOR
		@Li, 69  Psay TRB->QTDPRE           Picture TM(TRB->QTDPRE,14,2)
		@Li, 90  Psay TRB->QTDREA           Picture TM(TRB->QTDREA,14,2)
		@Li,106  Psay TRB->PORCEN			Picture "@E 9999.99"
		@Li,116  Psay TRB->VALOR            Picture TM(TRB->VALOR,14,2)
		
		_nQtePre += TRB->QTDPRE
		_nQteRea += TRB->QTDREA
		_nValor  += TRB->VALOR
		
		Li++
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	Li++
	
	@Li, 00  Psay "TOTAL PRENSA : "+_cPrensa+"   -------->"
	@Li, 69  Psay _nQtePre          			Picture TM(_nQtePre,14,2)
	@Li, 90  Psay _nQteRea           			Picture TM(_nQteRea,14,2)
	@Li,107  Psay (_nQteRea /_nQtePre) * 100	Picture "@E 9999.99"
	@Li,116  Psay _nValor            			Picture TM(_nValor,14,2)
	
	_nTQtPre += _nQtePre
	_nTQtRea += _nQteRea
	_nTValor += _nValor
	
	Li += 2
	@Li,00 PSAY Replicate("-",limite)
	Li += 2
	
	@Li,000 PSAY "TOTAL GERAL   -------------------->"
	@Li, 69  Psay _nTQtPre          			Picture TM(_nTQtPre,14,2)
	@Li, 90  Psay _nTQtRea           			Picture TM(_nTQtRea,14,2)
	@Li,107  Psay (_nTQtRea / _nTQtPre) * 100	Picture "@E 9999.99"
	@Li,116  Psay _nTValor            			Picture TM(_nValor,14,2)
	
Return


Static Function OrdOper(_lFim)
	
	_nTQtPre := _nTQtRea := _nTValor := 0
	_nQtePre := _nQteRea := _nValor  := 0
	_lOper   := .F.
	_cOper   := ""
	
	dbSelectArea("TRB")
	dbGotop()
	
	SetRegua(LastRec())
	
	While !Eof() .And. !_lFim
		
		If _lFim
			Alert("Cancelado Pelo Usuario!!")
			Return
		Endif
		
		IncRegua("Imprimindo....")
		
		If TRB->EXTRA == "S"
			dbSelectArea("TRB")
			dbSkip()
			Loop
		Endif
		
		IF li > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		If _cOper <> TRB->NOMOPERA .and. _lOper
			Li++
			@Li, 00  Psay "TOTAL OPERADOR: "+_cOper+" -->"
			@Li, 69  Psay _nQtePre          			Picture TM(_nQtePre,14,2)
			@Li, 90  Psay _nQteRea           			Picture TM(_nQteRea,14,2)
			@Li,107  Psay (_nQteRea /_nQtePre) * 100	Picture "@E 9999.99"
			@Li,116  Psay _nValor            			Picture TM(_nValor,14,2)
			
			_nTQtPre += _nQtePre
			_nTQtRea += _nQteRea
			_nTValor += _nValor
			_nQtePre := _nQteRea := _nValor := 0
			Li += 2
		Endif
		
		_cOper   := TRB->NOMOPERA
		_lOper   := .T.
		
		@Li, 00  PSay TRB->DTEMIS
		@Li, 11  PSay TRB->PRODUTO
		@Li, 27  Psay TRB->CICLO           Picture TM(TRB->CICLO,6,2)
		@Li, 37  Psay TRB->QTDCAV
		@Li, 43  Psay TRB->PRENSA
		@Li, 55  Psay TRB->OPERADOR
		@Li, 69  Psay TRB->QTDPRE           Picture TM(TRB->QTDPRE,14,2)
		@Li, 90  Psay TRB->QTDREA           Picture TM(TRB->QTDREA,14,2)
		@Li,106  Psay TRB->PORCEN			Picture "@E 9999.99"
		@Li,116  Psay TRB->VALOR            Picture TM(TRB->VALOR,14,2)
		
		_nQtePre += TRB->QTDPRE
		_nQteRea += TRB->QTDREA
		_nValor  += TRB->VALOR
		
		Li++
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	Li++
	
	@Li, 00  Psay "TOTAL OPERADOR : "+_cOper+" -->"
	@Li, 69  Psay _nQtePre          			Picture TM(_nQtePre,14,2)
	@Li, 90  Psay _nQteRea           			Picture TM(_nQteRea,14,2)
	@Li,107  Psay (_nQteRea /_nQtePre) * 100	Picture "@E 9999.99"
	@Li,116  Psay _nValor            			Picture TM(_nValor,14,2)
	
	_nTQtPre += _nQtePre
	_nTQtRea += _nQteRea
	_nTValor += _nValor
	
	Li += 2
	@Li,00 PSAY Replicate("-",limite)
	
	Li += 2
	@Li,057 PSAY "HORAS EXTRAS"
	Li += 1
	@Li,056 PSAY "=============="
	Li += 3
	
	_nT2Pre  := _nT2Rea  := _nT2Val  := 0
	_nQtePre := _nQteRea := _nValor  := 0
	_lOper   := .F.
	_cOper   := ""
	
	dbSelectArea("TRB")
	dbGotop()
	
	SetRegua(LastRec())
	
	While !Eof() .And. !_lFim
		
		If _lFim
			Alert("Cancelado Pelo Usuario!!")
			Return
		Endif
		
		IncRegua("Imprimindo....")
		
		If TRB->EXTRA == "N"
			dbSelectArea("TRB")
			dbSkip()
			Loop
		Endif
		
		IF li > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		If _cOper <> TRB->NOMOPERA .and. _lOper
			Li++
			@Li, 00  Psay "TOTAL OPERADOR "+_cOper+" -->"
			@Li, 69  Psay _nQtePre          			Picture TM(_nQtePre,14,2)
			@Li, 90  Psay _nQteRea           			Picture TM(_nQteRea,14,2)
			@Li,107  Psay (_nQteRea /_nQtePre) * 100	Picture "@E 9999.99"
			@Li,116  Psay _nValor            			Picture TM(_nValor,14,2)
			
			_nT2Pre += _nQtePre
			_nT2Rea += _nQteRea
			_nT2Val += _nValor
			_nQtePre := _nQteRea := _nValor := 0
			Li += 2
		Endif
		
		_cOper   := TRB->NOMOPERA
		_lOper   := .T.
		
		@Li, 00  PSay TRB->DTEMIS
		@Li, 11  PSay TRB->PRODUTO
		@Li, 27  Psay TRB->CICLO           Picture TM(TRB->CICLO,6,2)
		@Li, 37  Psay TRB->QTDCAV
		@Li, 43  Psay TRB->PRENSA
		@Li, 55  Psay TRB->OPERADOR
		@Li, 69  Psay TRB->QTDPRE           Picture TM(TRB->QTDPRE,14,2)
		@Li, 90  Psay TRB->QTDREA           Picture TM(TRB->QTDREA,14,2)
		@Li,106  Psay TRB->PORCEN			Picture "@E 9999.99"
		@Li,116  Psay TRB->VALOR            Picture TM(TRB->VALOR,14,2)
		
		_nQtePre += TRB->QTDPRE
		_nQteRea += TRB->QTDREA
		_nValor  += TRB->VALOR
		
		Li++
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	Li++
	
	@Li, 00  Psay "TOTAL OPERADOR : "+_cOper+" -->"
	@Li, 69  Psay _nQtePre          			Picture TM(_nQtePre,14,2)
	@Li, 90  Psay _nQteRea           			Picture TM(_nQteRea,14,2)
	@Li,107  Psay (_nQteRea /_nQtePre) * 100	Picture "@E 9999.99"
	@Li,116  Psay _nValor            			Picture TM(_nValor,14,2)
	
	_nT2Pre += _nQtePre
	_nT2Rea += _nQteRea
	_nT2Val += _nValor
	
	Li += 2
	@Li,00 PSAY Replicate("-",limite)
	Li += 2
	
	_nTotPre := _nTQtPre + _nT2Pre
	_nTotRea := _nTQtRea + _nT2Rea
	_nTotVal := _nTValor + _nT2Val
	
	@Li,000 PSAY "TOTAL GERAL   -------------------->"
	@Li, 69  Psay _nTotPre          			Picture TM(_nTotPre,14,2)
	@Li, 90  Psay _nTotRea           			Picture TM(_nTotRea,14,2)
	@Li,107  Psay (_nTotRea / _nTotPre) * 100	Picture "@E 9999.99"
	@Li,116  Psay _nTotVal            			Picture TM(_nTotVal,14,2)
	
Return


Static Function OrdProd(_lFim)
	
	_nTQtPre := _nTQtRea := _nTValor := 0
	_nQtePre := _nQteRea := _nValor  := 0
	_lProd   := .F.
	_cProd   := ""
	
	dbSelectArea("TRB")
	dbGotop()
	
	SetRegua(LastRec())
	
	While !Eof() .And. !_lFim
		
		If _lFim
			Alert("Cancelado Pelo Usuario!!")
			Return
		Endif
		
		IncRegua("Imprimindo....")
		
		If TRB->EXTRA == "S"
			dbSelectArea("TRB")
			dbSkip()
			Loop
		Endif
		
		IF li > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		If _cProd <> TRB->PRODUTO .and. _lProd
			Li++
			@Li, 00  Psay "TOTAL PRODUTO : "+_cProd+"   -------->"
			@Li, 69  Psay _nQtePre          			Picture TM(_nQtePre,14,2)
			@Li, 90  Psay _nQteRea           			Picture TM(_nQteRea,14,2)
			@Li,107  Psay (_nQteRea /_nQtePre) * 100	Picture "@E 9999.99"
			@Li,116  Psay _nValor            			Picture TM(_nValor,14,2)
			
			_nTQtPre += _nQtePre
			_nTQtRea += _nQteRea
			_nTValor += _nValor
			_nQtePre := _nQteRea := _nValor := 0
			Li += 2
		Endif
		
		_cProd   := TRB->PRODUTO
		_lProd   := .T.
		
		@Li, 00  PSay TRB->DTEMIS
		@Li, 11  PSay TRB->PRODUTO
		@Li, 27  Psay TRB->CICLO           Picture TM(TRB->CICLO,6,2)
		@Li, 37  Psay TRB->QTDCAV
		@Li, 43  Psay TRB->PRENSA
		@Li, 55  Psay TRB->OPERADOR
		@Li, 69  Psay TRB->QTDPRE           Picture TM(TRB->QTDPRE,14,2)
		@Li, 90  Psay TRB->QTDREA           Picture TM(TRB->QTDREA,14,2)
		@Li,106  Psay TRB->PORCEN			Picture "@E 9999.99"
		@Li,116  Psay TRB->VALOR            Picture TM(TRB->VALOR,14,2)
		
		_nQtePre += TRB->QTDPRE
		_nQteRea += TRB->QTDREA
		_nValor  += TRB->VALOR
		
		Li++
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	Li++
	
	@Li, 00  Psay "TOTAL PRODUTO : "+_cProd+"   -------->"
	@Li, 69  Psay _nQtePre          			Picture TM(_nQtePre,14,2)
	@Li, 90  Psay _nQteRea           			Picture TM(_nQteRea,14,2)
	@Li,107  Psay (_nQteRea /_nQtePre) * 100	Picture "@E 9999.99"
	@Li,116  Psay _nValor            			Picture TM(_nValor,14,2)
	
	_nTQtPre += _nQtePre
	_nTQtRea += _nQteRea
	_nTValor += _nValor
	
	Li += 2
	@Li,00 PSAY Replicate("-",limite)
	
	Li += 2
	@Li,057 PSAY "HORAS EXTRAS"
	Li += 1
	@Li,056 PSAY "=============="
	Li += 3
	
	_nQtePre := _nQteRea := _nValor  := 0
	_lProd   := .F.
	_cProd   := ""
	
	dbSelectArea("TRB")
	dbGotop()
	
	SetRegua(LastRec())
	
	While !Eof() .And. !_lFim
		
		If _lFim
			Alert("Cancelado Pelo Usuario!!")
			Return
		Endif
		
		IncRegua("Imprimindo....")
		
		If TRB->EXTRA == "N"
			dbSelectArea("TRB")
			dbSkip()
			Loop
		Endif
		
		IF li > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		If _cProd <> TRB->PRODUTO .and. _lProd
			Li++
			@Li, 00  Psay "TOTAL PRODUTO : "+_cProd+"   -------->"
			@Li, 69  Psay _nQtePre          			Picture TM(_nQtePre,14,2)
			@Li, 90  Psay _nQteRea           			Picture TM(_nQteRea,14,2)
			@Li,107  Psay (_nQteRea /_nQtePre) * 100	Picture "@E 9999.99"
			@Li,116  Psay _nValor            			Picture TM(_nValor,14,2)
			
			_nTQtPre += _nQtePre
			_nTQtRea += _nQteRea
			_nTValor += _nValor
			_nQtePre := _nQteRea := _nValor := 0
			Li += 2
		Endif
		
		_cProd   := TRB->PRODUTO
		_lProd   := .T.
		
		@Li, 00  PSay TRB->DTEMIS
		@Li, 11  PSay TRB->PRODUTO
		@Li, 27  Psay TRB->CICLO           Picture TM(TRB->CICLO,6,2)
		@Li, 37  Psay TRB->QTDCAV
		@Li, 43  Psay TRB->PRENSA
		@Li, 55  Psay TRB->OPERADOR
		@Li, 69  Psay TRB->QTDPRE           Picture TM(TRB->QTDPRE,14,2)
		@Li, 90  Psay TRB->QTDREA           Picture TM(TRB->QTDREA,14,2)
		@Li,106  Psay TRB->PORCEN			Picture "@E 9999.99"
		@Li,116  Psay TRB->VALOR            Picture TM(TRB->VALOR,14,2)
		
		_nQtePre += TRB->QTDPRE
		_nQteRea += TRB->QTDREA
		_nValor  += TRB->VALOR
		
		Li++
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	Li++
	
	@Li, 00  Psay "TOTAL PRODUTO : "+_cProd+"   -------->"
	@Li, 69  Psay _nQtePre          			Picture TM(_nQtePre,14,2)
	@Li, 90  Psay _nQteRea           			Picture TM(_nQteRea,14,2)
	@Li,107  Psay (_nQteRea /_nQtePre) * 100	Picture "@E 9999.99"
	@Li,116  Psay _nValor            			Picture TM(_nValor,14,2)
	
	_nTQtPre += _nQtePre
	_nTQtRea += _nQteRea
	_nTValor += _nValor
	
	Li += 2
	@Li,00 PSAY Replicate("-",limite)
	Li += 2
	
	@Li,000 PSAY "TOTAL GERAL   -------------------->"
	@Li, 69  Psay _nTQtPre          			Picture TM(_nTQtPre,14,2)
	@Li, 90  Psay _nTQtRea           			Picture TM(_nTQtRea,14,2)
	@Li,107  Psay (_nTQtRea / _nTQtPre) * 100	Picture "@E 9999.99"
	@Li,116  Psay _nTValor            			Picture TM(_nValor,14,2)
	
Return


Static Function GeramMin(_cHora)
	
	_nHora1 := Val(SubStr(_cHora, 1, At(':', _cHora)-1))
	_nHora2 := Val(SubStr(_cHora, At(':', _cHora)+1, 2))
	
	_nMin := (_nHora1 * 60) + _nHora2 
	
Return(_nMin)
