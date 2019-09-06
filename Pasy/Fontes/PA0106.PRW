#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PA0106    º Autor ³ Fabiano da Silva   º Data ³  12/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Balancete de verificacao por natureza                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Sigafin(SE2)                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PA0106()

Private _aMes     := {}
Private _cAno     := ""
Private _dDtI     := _dDtF    := Ctod("")
Private _lImprime := .T.
_cNomBco := ""
_nOpc := 0

@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Relatorio Balancete por Natureza")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina para apurar a movimentacao Financeira        "     SIZE 160,7
@ 18,18 SAY "Previsao e Realizado conforme parametros informados "     SIZE 160,7
@ 26,18 SAY "Pelo usuario. Programa PA0106.PRW                   "     SIZE 160,7
@ 34,18 SAY "                                                    "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0106")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	PA106A()
Endif

Return(.T.)

/* PERGUNTA (PA0106)
MV_PAR01 DATA DE
MV_PAR02 DATA ATE
MV_PAR03 NATUREZA DE
MV_PAR04 NATUREZA ATE
*/

Static Function PA106A()

Pergunte("PA0106",.F.)

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.

_cArqNew   := "\CRYSTAL\PA0106.DBF"

_bAcao01   := {|_lFim| GeraTrb(@_lFim) }
_cTitulo01 := 'Criando Arquivo de Trabalho...!!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_bAcao01   := {|_lFim| SALDOATU(@_lFim) }  // SALDO ATUAL
_cTitulo01 := 'Selecionando Saldo Atual!!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

dbSelectArea("TRB")
Copy All To &_cArqNew
dbCloseArea()
               
_cMod    := cModulo
cModulo  := "EEC"
_lRet    := E_ARQCRW()

Public cSeqRel := ""

If _lImprime
	AVGCRW32("PA0106.RPT","BALANCETE POR NATUREZA",) //(mensal)
Endif

cModulo  := _cMod

Return


Static Function GeraTrb(_lFim)

aStru := {}
AADD(aStru,{"PA010601"  , "C" , 10, 0 })  // Natureza
AADD(aStru,{"PA010602"  , "C" , 30, 0 })  // Descrição da Natureza
AADD(aStru,{"PA010603"  , "C" ,  3, 0 })  // Grupo
AADD(aStru,{"PA010604"  , "C" , 40, 0 })  // Nome do Grupo
AADD(aStru,{"PA010605"  , "D" ,  8, 0 })  // Data DE
AADD(aStru,{"PA010606"  , "D" ,  8, 0 })  // Data ATE
AADD(aStru,{"PA010607"  , "C" , 40, 0 })  // Descrição
AADD(aStru,{"PA010608"  , "C" , 01, 0 })  // Tipo da Conta Debito ou Credito
AADD(aStru,{"PA010609"  , "C" , 01, 0 })  // SubGrupo da Conta
AADD(aStru,{"VLSALDOD"  , "N" , 14, 2 })  // Saldo Debito
AADD(aStru,{"VLSALDOC"  , "N" , 14, 2 })  // Saldo Credito
AADD(aStru,{"VALOR01"   , "N" , 14, 2 })  // Valor 01
AADD(aStru,{"VALORD"    , "N" , 14, 2 })   // Valor Debito
AADD(aStru,{"VALORC"    , "N" , 14, 2 })   // Valor Credito
AADD(aStru,{"VALOR04"   , "N" , 14, 2 })  // Valor 04
AADD(aStru,{"VALOR05"   , "N" , 14, 2 })  // Valor 05
AADD(aStru,{"VALOR06"   , "N" , 14, 2 })  // Valor 06
AADD(aStru,{"VALOR07"   , "N" , 14, 2 })  // Valor 07 Total Geral
AADD(aStru,{"VALOR08"   , "N" , 14, 2 })  // Valor 07 Total Geral
AADD(aStru,{"VALOR09"   , "N" , 14, 2 })  // Valor 07 Total Geral

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "PA010603 +  PA010601"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

_dUltFech := GETMV("MV_PA0108")  // Data da Ultima Apuração do resultado
_dDtInic := _dUltFech + 1

_lmvpar03 := _lmvpar04 := .F.

If Alltrim(MV_PAR03) $ "1086/1087"
	//	MV_PAR03  := ""
	_lmvpar03 := .T.
Endif

If Alltrim(MV_PAR04) $ "1086/1087"
	//	MV_PAR04  := "ZZZZZ"
	_lmvpar04 := .T.
Endif

dbSelectArea("SED")
dbSetOrder(1)
dbSeek(xFilial("SED")+MV_PAR03,.T.)

ProcRegua(LastRec())

While !Eof() .And. !_lFim .And. SED->ED_CODIGO <= MV_PAR04
	
	IncProc("Processando Natureza: "+SED->ED_CODIGO)
	
	_cChavSE1 := SED->ED_CODIGO
	_lEntr    := .F.
	dbSelectArea("SE1")
	dbOrderNickName("INDSE13")
	dbSeek(xFilial("SE1")+_cChavSE1,.T.)
	
	_cNaturez := SED->ED_CODIGO
	
	If SED->ED_CODIGO = "1020"
		_lPare := .T.
	Endif	

	While !Eof() .And. !_lFim .And. _cNaturez == SE1->E1_NATUREZ .And. SE1->E1_EMISSAO <= MV_PAR02
		                             		
//		If !Empty(SE1->E1_FATURA).And. SE1->E1_FATURA != "NOTFAT"
		If !Empty(SE1->E1_FATURA).And. SE1->E1_FATURA == "NOTFAT"
			dbSelectArea("SE1")
			dbSkip()
			Loop
		Endif
		
		If ALLTRIM(SED->ED_CODIGO) $ "1086/1087/2304" .And. SE1->E1_EMISSAO < MV_PAR01
			dbSelectArea("SE1")
			dbSkip()
			Loop
		Endif
		
		If SE1->E1_TIPO == "AB-"
			dbSelectArea("SE1")
			dbSkip()
			Loop
		Endif
		
		_lEntr  := .T.
		_cGrup  := ""
		If SUBSTR(SED->ED_GRGEREN,1,1) == "1"
			_cGrup  := "1- ATIVO"
		ElseIf SUBSTR(SED->ED_GRGEREN,1,1) == "2"
			_cGrup  := "2- PASSIVO"
		ElseIf SUBSTR(SED->ED_GRGEREN,1,1) $ "3/4"
			_cGrup  := "3-4 DEMONSTRATIVO DE RESULTADO"
		ElseIf SUBSTR(SED->ED_GRGEREN,1,1) == "5"
			_cGrup  := "5- RESULTADO FINANCEIRO"
		ElseIf SUBSTR(SED->ED_GRGEREN,1,1) == "6"
			_cGrup  := "6- RESULTADO NAO OPERACIONAL"
		Else
			_cGrup  := "9- LANCAMENTOS DO PASSADO"
		Endif
		
		_cDesSub := Tabela("Z9",SED->ED_GRGEREN)
		
		If SE1->E1_EMISSAO < MV_PAR01

			_nValSE5 := 0
			_nMesSE5 := 0
			If 	!SUBSTR(SED->ED_GRGEREN,1,1) $ "3/4/5" .And. SED->ED_CONSBX != "N"
				dbSelectArea("SE5")
				dbSetOrder(7)
				If dbSeek(xFilial("SE5")+SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO + SE1->E1_CLIENTE + SE1->E1_LOJA)
					
					_cChavSE5 := SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR  + SE5->E5_LOJA
					
					While !Eof() .And. _cChavSE5 == SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR  + SE5->E5_LOJA
						
						If !Empty(SE5->E5_SITUACA )
							dbSelectArea("SE5")
							dbSkip()
							Loop
						Endif
						
//						IF SE5->E5_TIPODOC $ "ES/MT/JR/DC/D2/J2/TL/M2/CM/C2/TR/TE/CH/CA/EC/E2/BD/TE/RA/CB"
						IF SE5->E5_TIPODOC $ "ES/MT/JR/DC/D2/J2/TL/M2/CM/C2/CH/CA/EC/E2/BD/RA/CB"
								dbSelectArea("SE5")
							dbSkip()
							Loop
						Endif
						
						If SE5->E5_DTDISPO >= MV_PAR01
							If SE5->E5_TIPODOC $ "ES"
								_nMesSE5 -= (SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA)
							Else
								_nMesSE5 += (SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA)
							Endif
						Else
							If SE5->E5_TIPODOC $ "ES"
								_nValSE5 -= (SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA)
							Else
								_nValSE5 += (SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA)
							Endif
						Endif
						
						dbSelectArea("SE5")
						dbSkip()
					EndDo
				Endif
			Endif
			
			dbSelectArea("TRB")
			If !dbseek(SED->ED_GRGEREN +_cNaturez)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PA010601    := SE1->E1_NATUREZ
				TRB->PA010602    := SED->ED_DESCRIC
				TRB->PA010603    := SED->ED_GRGEREN
				TRB->PA010609    := Substr(SED->ED_GRGEREN,1,1)
				TRB->PA010604    := Substr(_cDesSub,1,30)
				TRB->PA010605    := MV_PAR01
				TRB->PA010606    := MV_PAR02
				TRB->PA010607    := _cGrup
				TRB->PA010608    := SED->ED_CLASSE
				If SE1->E1_TIPO $ "RA /NCC/AB-/VNR"
					TRB->VLSALDOD  := SE1->E1_VALOR   // Debito
					TRB->VLSALDOC  := _nValSE5
					TRB->VALORC    := _nMesSE5        // Credito
				Else
					TRB->VLSALDOC  := SE1->E1_VALOR   // Credito
					TRB->VLSALDOD  := _nValSE5
					TRB->VALORD    := _nMesSE5        // Debito
				Endif
				MsUnlock()
				
			Else
				RecLock("TRB",.F.)
				If SE1->E1_TIPO $ "NCC/AB-/VNR"
					TRB->VLSALDOD  += SE1->E1_VALOR   // Debito
					TRB->VLSALDOC  += _nValSE5
					TRB->VALORC    += _nMesSE5        // Credito
				Else
					TRB->VLSALDOC  += SE1->E1_VALOR   // Credito
					TRB->VLSALDOD  += _nValSE5
					TRB->VALORD    += _nMesSE5        // Debito
				Endif
				MsUnlock()
			Endif				        
		Else
				
			_nValSE5 := 0
			If 	!SUBSTR(SED->ED_GRGEREN,1,1) $ "3/4/5" .And. SED->ED_CONSBX != "N"
				dbSelectArea("SE5")
				dbSetOrder(7)
				If dbSeek(xFilial("SE5")+SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO + SE1->E1_CLIENTE + SE1->E1_LOJA)
					
					_cChavSE5 := SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR  + SE5->E5_LOJA
					
					While !Eof() .And. _cChavSE5 == SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR  + SE5->E5_LOJA
						
						If !Empty(SE5->E5_SITUACA )
							dbSelectArea("SE5")
							dbSkip()
							Loop
						Endif
						
//						IF SE5->E5_TIPODOC $ "ES/MT/JR/DC/D2/J2/TL/M2/CM/C2/TR/TE/CH/CA/EC/E2/BD/TE/RA/CB"
						IF SE5->E5_TIPODOC $ "ES/MT/JR/DC/D2/J2/TL/M2/CM/C2/CH/CA/EC/E2/BD/RA/CB"
							dbSelectArea("SE5")
							dbSkip()
							Loop
						Endif
						
						If SE5->E5_DTDISPO > MV_PAR02
							dbSelectArea("SE5")
							dbSkip()
							Loop
						Endif
						
						IF SE5->E5_TIPODOC $ "ES"
							_nValSE5 -= (SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA)
						Else
							_nValSE5 += (SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA)
						Endif
						
						dbSelectArea("SE5")
						dbSkip()
					EndDo
				Endif
			Endif
			
			dbSelectArea("TRB")
			If !dbseek(SED->ED_GRGEREN +_cNaturez)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PA010601    := SE1->E1_NATUREZ
				TRB->PA010602    := SED->ED_DESCRIC
				TRB->PA010603    := SED->ED_GRGEREN
				TRB->PA010609    := Substr(SED->ED_GRGEREN,1,1)
				TRB->PA010604    := Substr(_cDesSub,1,30)
				TRB->PA010605    := MV_PAR01
				TRB->PA010606    := MV_PAR02
				TRB->PA010607    := _cGrup
				TRB->PA010608    := SED->ED_CLASSE
				If SE1->E1_TIPO $ "NCC/AB-/VNR"
					TRB->VALORD  := SE1->E1_VALOR   // Debito
					TRB->VALORC  := _nValSE5        // Credito
				Else
					TRB->VALORC  := SE1->E1_VALOR   // Credito
					TRB->VALORD  := _nValSE5        // Debito
				Endif
				MsUnlock()
			Else
				RecLock("TRB",.F.)
				If SE1->E1_TIPO $ "NCC/AB-/VNR"
					TRB->VALORD  += SE1->E1_VALOR   // Debito
					TRB->VALORC  += _nValSE5        // Credito
				Else
					TRB->VALORC  += SE1->E1_VALOR   // Credito
					TRB->VALORD  += _nValSE5        // Debito
				Endif
				MsUnlock()
			Endif            
		Endif
				
		dbSelectArea("SE1")
		dbSkip()
	EndDo

	_cChavSE2 := SED->ED_CODIGO
	
	dbSelectArea("SE2")
	dbOrderNickName("INDSE22")
	dbSeek(xFilial("SE2")+_cChavSE2,.T.)
	
	_cNaturez := SED->ED_CODIGO
	
	While !Eof() .And. !_lFim .And. _cNaturez == SE2->E2_NATUREZ .And. SE2->E2_EMIS1 <= MV_PAR02

    	If dtos(SE2->E2_EMIS1)  > "31/01/07"
    		_lPare := .T.
    	Endif	
			
//		If !Empty(SE2->E2_FATURA) .And. SE2->E2_FATURA != "NOTFAT"
		If !Empty(SE2->E2_FATURA) .And. SE2->E2_FATURA == "NOTFAT"
			dbSelectArea("SE2")
			dbSkip()
			Loop
		Endif
		
		If SED->ED_CODIGO $ "2304      " .And. SE2->E2_EMIS1 < MV_PAR01
			dbSelectArea("SE2")
			dbSkip()
			Loop
		Endif
		
		_lEntr := .T.
		
		If SUBSTR(SED->ED_GRGEREN,1,1) == "1"
			_cGrup  := "1- ATIVO"
		ElseIf SUBSTR(SED->ED_GRGEREN,1,1) == "2"
			_cGrup  := "2- PASSIVO"
		ElseIf SUBSTR(SED->ED_GRGEREN,1,1) $ "3/4"
			_cGrup  := "3-4 DEMONSTRATIVO DE RESULTADO"
		ElseIf SUBSTR(SED->ED_GRGEREN,1,1) == "5"
			_cGrup  := "5- RESULTADO FINANCEIRO"
		ElseIf SUBSTR(SED->ED_GRGEREN,1,1) == "6"
			_cGrup  := "6- RESULTADO NAO OPERACIONAL"
		Else
			_cGrup  := "9- LANCAMENTOS DO PASSADO"
		Endif
		
		_cDesSub := Tabela("Z9",SED->ED_GRGEREN)
        
        If SE2->E2_NUM = "009550"
        	_lPare := .T.
        Endif	                         
		
		If SE2->E2_EMIS1 < MV_PAR01
  			_nValSE5 := 0
			_nMesSE5 := 0
			
			If !SUBSTR(SED->ED_GRGEREN,1,1) $ "3/4/5" .And. SED->ED_CONSBX != "N"
				dbSelectArea("SE5")
				dbSetOrder(7)
				If dbSeek(xFilial("SE5")+SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA)
					
					_cChavSE5 := SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR  + SE5->E5_LOJA
					
					While !Eof() .And. _cChavSE5 == SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR  + SE5->E5_LOJA
						
						If !Empty(SE5->E5_SITUACA )
							dbSelectArea("SE5")
							dbSkip()
							Loop
						Endif
						
//						IF SE5->E5_TIPODOC $ "ES/MT/JR/DC/D2/J2/TL/M2/CM/C2/TR/TE/CH/CA/EC/E2/BD/TE/PA/CB"
						IF SE5->E5_TIPODOC $ "ES/MT/JR/DC/D2/J2/TL/M2/CM/C2/CH/CA/EC/E2/BD/PA/CB"
							dbSelectArea("SE5")
							dbSkip()
							Loop
						Endif
						
						If SE5->E5_DTDISPO >= MV_PAR01
							IF SE5->E5_TIPODOC $ "ES"
								_nMesSE5 -= (SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA)
							Else
								_nMesSE5 += (SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA)
							Endif
						Else
							IF SE5->E5_TIPODOC $ "ES"
								_nValSE5 -= (SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA)
							Else
								_nValSE5 += (SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA)
							Endif
						Endif
						
						dbSelectArea("SE5")
						dbSkip()
					EndDo
				Endif
			Endif
			            
			If SE2->E2_VALOR != _nValSE5
				_lParar := .T.
			Endif
			
			dbSelectArea("TRB")
			If !dbseek(SED->ED_GRGEREN +_cNaturez)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PA010601    := SE2->E2_NATUREZ
				TRB->PA010602    := SED->ED_DESCRIC
				TRB->PA010603    := SED->ED_GRGEREN
				TRB->PA010609    := Substr(SED->ED_GRGEREN,1,1)
				TRB->PA010604    := Substr(_cDesSub,1,30)
				TRB->PA010605    := MV_PAR01
				TRB->PA010606    := MV_PAR02
				TRB->PA010607    := _cGrup
				TRB->PA010608    := SED->ED_CLASSE
				If SE2->E2_TIPO $ "NDF/AB-/VNP"
					TRB->VLSALDOC  := SE2->E2_VALOR
					TRB->VLSALDOD  := _nValSe5
					TRB->VALORD    := _nMesSE5
				Else
					TRB->VLSALDOD  := SE2->E2_VALOR
					TRB->VLSALDOC  := _nValSe5
					TRB->VALORC    := _nMesSE5
				Endif
				MsUnlock()
			Else
				RecLock("TRB",.F.)
				If SE2->E2_TIPO $ "NDF/AB-/VNP"
					TRB->VLSALDOC  += SE2->E2_VALOR
					TRB->VLSALDOD  += _nValSe5
					TRB->VALORD    += _nMesSE5
				Else
					TRB->VLSALDOD  += SE2->E2_VALOR
					TRB->VLSALDOC  += _nValSe5
					TRB->VALORC    += _nMesSE5
				Endif
				MsUnlock()
			Endif
			 
		Else

			_nValSE5 := 0
			If 	!SUBSTR(SED->ED_GRGEREN,1,1) $ "3/4/5" .And. SED->ED_CONSBX != "N"
				dbSelectArea("SE5")
				dbSetOrder(7)
				If dbSeek(xFilial("SE5")+SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA)
					
					_cChavSE5 := SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR  + SE5->E5_LOJA
					
					While !Eof() .And. _cChavSE5 == SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR  + SE5->E5_LOJA
						
						If !Empty(SE5->E5_SITUACA )
							dbSelectArea("SE5")
							dbSkip()
							Loop
						Endif
						
//						IF SE5->E5_TIPODOC $ "ES/MT/JR/DC/D2/J2/TL/M2/CM/C2/TR/TE/CH/CA/EC/E2/BD/TE/PA/CB"
						IF SE5->E5_TIPODOC $ "ES/MT/JR/DC/D2/J2/TL/M2/CM/C2/CH/CA/EC/E2/BD/PA/CB"
							dbSelectArea("SE5")
							dbSkip()
							Loop
						Endif
						
						If SE5->E5_DTDISPO > MV_PAR02
							dbSelectArea("SE5")
							dbSkip()
							Loop
						Endif
						
						IF SE5->E5_TIPODOC $ "ES"
							_nValSE5 -= (SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA)
						Else
							_nValSE5 += (SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA)
						Endif
						
						dbSelectArea("SE5")
						dbSkip()
					EndDo
				Endif
			Endif
			
			dbSelectArea("TRB")
			If !dbseek(SED->ED_GRGEREN +_cNaturez)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PA010601    := SE2->E2_NATUREZ
				TRB->PA010602    := SED->ED_DESCRIC
				TRB->PA010603    := SED->ED_GRGEREN
				TRB->PA010609    := Substr(SED->ED_GRGEREN,1,1)
				TRB->PA010604    := Substr(_cDesSub,1,30)
				TRB->PA010605    := MV_PAR01
				TRB->PA010606    := MV_PAR02
				TRB->PA010607    := _cGrup
				TRB->PA010608    := SED->ED_CLASSE
				If SE2->E2_TIPO $ "NDF/AB-/VNP"
					TRB->VALORC  := SE2->E2_VALOR
					TRB->VALORD  := _nValSE5
				Else
					TRB->VALORD  := SE2->E2_VALOR
					TRB->VALORC  := _nValSE5
				Endif
			Else
				RecLock("TRB",.F.)
				If SE2->E2_TIPO $ "NDF/AB-/VNP"
					TRB->VALORC  += SE2->E2_VALOR
					TRB->VALORD  += _nValSE5
				Else
					TRB->VALORD  += SE2->E2_VALOR
					TRB->VALORC  += _nValSE5
				Endif
				MsUnlock()
			Endif
			
		Endif
		
		dbSelectArea("SE2")
		dbSkip()
	EndDo

	If _lmvpar03 .and. _lmvpar04
		_cCond1   := "SE5->E5_NATUREZ <= 'ZZZZZ'"
		
		dbSelectArea("SE5")
		dbOrderNickName("INDSE56")
		dbGotop()
	Else
		_cCond1   := "SED->ED_CODIGO == SE5->E5_NATUREZ .And. SE5->E5_DTDISPO <= MV_PAR02"
		
		dbSelectArea("SE5")
		dbOrderNickName("INDSE56")
		dbSeek(xFilial("SE5")+SED->ED_CODIGO,.T.)
	Endif
	
	dbSelectArea("SE5")
	While !Eof() .And. !_lFim .And. &_cCond1

		If Alltrim(SE5->E5_DOCUMEN) = "EX0305"
			_lPare := .T.
		Endif

		If !Empty(SE5->E5_SITUACA )
			dbSelectArea("SE5")
			dbSkip()
			Loop
		Endif
		
		IF SE5->E5_TIPODOC $ "ES/TL/M2/CM/C2/CH/EC/RA/PA/CP"
			dbSelectArea("SE5")
			dbSkip()
			Loop
		Endif
		
		If SE5->E5_DTDISPO > MV_PAR02
			dbSelectArea("SE5")
			dbSkip()
			Loop
		Endif
		
		If SED->ED_CODIGO $ "2304      " .And. SE5->E5_DTDISPO  < MV_PAR01
			dbSelectArea("SE5")
			dbSkip()
			Loop
		Endif
	
		_lEntr   := .T.
		_cNatur  := ""
		_cNatAb  := ""
		
		_aAliSED := SED->(GETAREA())
		
		_nValMov := (SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA)
		
		If SE5->E5_TIPODOC $ "VL/BA"
			dbSelectArea("SE1")
			dbSetOrder(1)
			If dbSeek(xFilial("SE1")+SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + "AB-")
				_cNatAb := SE1->E1_NATOUT2
			Else
				dbSelectArea("SE5")
				dbSkip()
				Loop
			Endif
			
			_nValMov := SE1->E1_VALOR
			
			If SE5->E5_DTDISPO < MV_PAR01

				dbSelectArea("SED")
				dbSetOrder(1)
				dbSeek(xFilial("SED")+SE1->E1_NATUREZ)
				
				_cGrup   := "1- ATIVO"
				_cDesSub := Tabela("Z9",SED->ED_GRGEREN)
				
				dbSelectArea("TRB")
				If !dbseek(SED->ED_GRGEREN +SED->ED_CODIGO)
					dbSelectArea("TRB")
					RecLock("TRB",.T.)
					TRB->VLSALDOD  := _nValMov
					TRB->PA010601    := SED->ED_CODIGO
					TRB->PA010602    := SED->ED_DESCRIC
					TRB->PA010603    := SED->ED_GRGEREN
					TRB->PA010609    := Substr(SED->ED_GRGEREN,1,1)
					TRB->PA010604    := Substr(_cDesSub,1,30)
					TRB->PA010605    := MV_PAR01
					TRB->PA010606    := MV_PAR02
					TRB->PA010607    := _cGrup
					TRB->PA010608    := SED->ED_CLASSE
					MsUnlock()
				Else
					RecLock("TRB",.F.)
					TRB->VLSALDOD  += _nValMov
					MsUnlock()
				Endif					            
			Else
				dbSelectArea("SED")
				dbSetOrder(1)
//				dbSeek(xFilial("SED")+"1086")         
				dbSeek(xFilial("SED")+SE1->E1_NATUREZ)				
				
				_cGrup   := "1- ATIVO"
				_cDesSub := Tabela("Z9",SED->ED_GRGEREN)
				
				dbSelectArea("TRB")
				If !dbseek(SED->ED_GRGEREN +SED->ED_CODIGO)
					dbSelectArea("TRB")
					RecLock("TRB",.T.)
					TRB->VALORD  := _nValMov
					TRB->PA010601    := SED->ED_CODIGO
					TRB->PA010602    := SED->ED_DESCRIC
					TRB->PA010603    := SED->ED_GRGEREN
					TRB->PA010609    := Substr(SED->ED_GRGEREN,1,1)
					TRB->PA010604    := Substr(_cDesSub,1,30)
					TRB->PA010605    := MV_PAR01
					TRB->PA010606    := MV_PAR02
					TRB->PA010607    := _cGrup
					TRB->PA010608    := SED->ED_CLASSE
					MsUnlock()
				Else
					RecLock("TRB",.F.)
					TRB->VALORD  += _nValMov
					MsUnlock()
				Endif
				
			Endif
		Endif
		If !SE5->E5_TIPODOC $ "VL/BA"
			If SE5->E5_RECPAG == "R" .And. !Empty(SE5->E5_TIPO)
				If SE5->E5_TIPO $ "PA /NDF"
					dbSelectArea("SE2")
					dbSetOrder(1)
					If dbSeek(xFilial("SE2")+SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR + SE5->E5_LOJA)
						If SE5->E5_TIPODOC $ "DC/D2"
							_cNatur := SE2->E2_NATOUT2
						ElseIf SE5->E5_TIPODOC $ "MT/JR/M2/J2"
							_cNatur := SE2->E2_NATOUT
						Endif
					Endif
				Else
					dbSelectArea("SE1")
					dbSetOrder(1)
					If dbSeek(xFilial("SE1")+SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO )
						If SE5->E5_TIPODOC $ "DC/D2"
							_cNatur := SE1->E1_NATOUT2
						ElseIf SE5->E5_TIPODOC $ "MT/JR/M2/J2"
							_cNatur := SE1->E1_NATOUT
						Endif
					Endif
					
					dbSelectArea("SE1")
					dbSetOrder(1)
					If dbSeek(xFilial("SE1")+SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + "AB-")
						_cNatAb := SE1->E1_NATOUT2
					Endif
				Endif
			ElseIf SE5->E5_RECPAG == "P" .And. !Empty(SE5->E5_TIPO)
				If !SE5->E5_TIPO $ "RA /NCC"
					dbSelectArea("SE2")
					dbSetOrder(1)
					If dbSeek(xFilial("SE2")+SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR + SE5->E5_LOJA)
						If SE5->E5_TIPODOC $ "DC/D2"
							_cNatur := SE2->E2_NATOUT2
						ElseIf SE5->E5_TIPODOC $ "MT/JR/M2/J2"
							_cNatur := SE2->E2_NATOUT
						Endif
					Endif
				Else
					dbSelectArea("SE1")
					dbSetOrder(1)
					If dbSeek(xFilial("SE1")+SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO )
						If SE5->E5_TIPODOC $ "DC/D2"
							_cNatur := SE1->E1_NATOUT2
						ElseIf SE5->E5_TIPODOC $ "MT/JR/M2/J2"
							_cNatur := SE1->E1_NATOUT
						Endif
					Endif
				Endif
			Endif
			
			_nValMov := (SE5->E5_VALOR + SE5->E5_VLDESCO - SE5->E5_VLJUROS - SE5->E5_VLMULTA)
			
			If !Empty(_cNatur)
				dbSelectArea("SED")
				dbSetOrder(1)
				dbSeek(xFilial("SED")+_cNatur)
			Else
				If SE5->E5_TIPODOC $ "MT/M2/JR/J2"
					If SE5->E5_RECPAG == "P"
						dbSelectArea("SED")
						dbSetOrder(1)
						dbSeek(xFilial("SED")+"4781")
					Else
						dbSelectArea("SED")
						dbSetOrder(1)
						dbSeek(xFilial("SED")+"3121")
					Endif
				ElseIf SE5->E5_TIPODOC $ "DC/D2"
					If SE5->E5_RECPAG == "P"
						dbSelectArea("SED")
						dbSetOrder(1)
						dbSeek(xFilial("SED")+"3180")
					Else
						dbSelectArea("SED")
						dbSetOrder(1)
						dbSeek(xFilial("SED")+"4780")
					Endif
				ElseIf SE5->E5_TIPODOC $ "V2"
					dbSelectArea("SED")
					dbSetOrder(1)
					dbSeek(xFilial("SED")+"1085")
				Endif
			Endif
			
			If SUBSTR(SED->ED_GRGEREN,1,1) == "1"
				_cGrup  := "1- ATIVO"
			ElseIf SUBSTR(SED->ED_GRGEREN,1,1) == "2"
				_cGrup  := "2- PASSIVO"
			ElseIf SUBSTR(SED->ED_GRGEREN,1,1) $ "3/4"
				_cGrup  := "3-4 DEMONSTRATIVO DE RESULTADO"
			ElseIf SUBSTR(SED->ED_GRGEREN,1,1) == "5"
				_cGrup  := "5- RESULTADO FINANCEIRO"
			ElseIf SUBSTR(SED->ED_GRGEREN,1,1) == "6"
				_cGrup  := "6- RESULTADO NAO OPERACIONAL"
			Else
				_cGrup  := "9- LANCAMENTOS DO PASSADO"
			Endif
			
			_cDesSub := Tabela("Z9",SED->ED_GRGEREN)
			
			If SE5->E5_DTDISPO < MV_PAR01
				//				If !_lmvpar03 .Or. !_lmvpar04
				dbSelectArea("TRB")
				If !dbseek(SED->ED_GRGEREN +SED->ED_CODIGO)
					dbSelectArea("TRB")
					RecLock("TRB",.T.)
					If SE5->E5_TIPODOC $ "MT/M2/JR/J2"
						If SE5->E5_RECPAG == "P"
							TRB->VLSALDOD  := _nValMov
						Else
							TRB->VLSALDOC  := _nValMov
						Endif
					ElseIf SE5->E5_TIPODOC $ "DC/D2"
						If SE5->E5_RECPAG == "P"
							TRB->VLSALDOC  := _nValMov
						Else
							TRB->VLSALDOD  := _nValMov
						Endif
					ElseIf SE5->E5_TIPODOC $ "V2"
						TRB->VLSALDOD      := _nValMov
					Else
						If SE5->E5_RECPAG == "R"
							TRB->VLSALDOC  := _nValMov
						Else
							TRB->VLSALDOD  := _nValMov
						Endif
					Endif
					
					TRB->PA010601    := SED->ED_CODIGO
					TRB->PA010602    := SED->ED_DESCRIC
					TRB->PA010603    := SED->ED_GRGEREN
					TRB->PA010609    := Substr(SED->ED_GRGEREN,1,1)
					TRB->PA010604    := Substr(_cDesSub,1,30)
					TRB->PA010605    := MV_PAR01
					TRB->PA010606    := MV_PAR02
					TRB->PA010607    := _cGrup
					TRB->PA010608    := SED->ED_CLASSE
					MsUnlock()
					              
				Else
					RecLock("TRB",.F.)
					If SE5->E5_TIPODOC $ "MT/M2/JR/J2"
						If SE5->E5_RECPAG == "P"
							TRB->VLSALDOD  += _nValMov
						Else
							TRB->VLSALDOC  += _nValMov
						Endif
					ElseIf SE5->E5_TIPODOC $ "DC/D2"
						If SE5->E5_RECPAG == "P"
							TRB->VLSALDOC  += _nValMov
						Else
							TRB->VLSALDOD  += _nValMov
						Endif
					ElseIf SE5->E5_TIPODOC $ "V2"
						TRB->VLSALDOD  += _nValMov
					Else
						If SE5->E5_RECPAG == "R"
							TRB->VLSALDOC  += _nValMov
						Else
							TRB->VLSALDOD  += _nValMov
						Endif
					Endif
					MsUnlock()                        
					                  
				Endif
				          
			Else
				//				If !_lmvpar03 .Or. !_lmvpar04
				dbSelectArea("TRB")
				If !dbseek(SED->ED_GRGEREN +SED->ED_CODIGO)
					dbSelectArea("TRB")
					RecLock("TRB",.T.)
					If SE5->E5_TIPODOC $ "MT/M2/JR/J2"
						If SE5->E5_RECPAG == "P"
							TRB->VALORD  := _nValMov
						Else
							TRB->VALORC  := _nValMov
						Endif
					ElseIf SE5->E5_TIPODOC $ "DC/D2"
						If SE5->E5_RECPAG == "P"
							TRB->VALORC  := _nValMov
						Else
							TRB->VALORD  := _nValMov
						Endif
					ElseIf SE5->E5_TIPODOC $ "V2"
						TRB->VALORD  := _nValMov
					Else
						If SE5->E5_RECPAG == "R"
							TRB->VALORC  := _nValMov
						Else
							TRB->VALORD  := _nValMov
						Endif
					Endif
					
					TRB->PA010601    := SED->ED_CODIGO
					TRB->PA010602    := SED->ED_DESCRIC
					TRB->PA010603    := SED->ED_GRGEREN
					TRB->PA010609    := Substr(SED->ED_GRGEREN,1,1)
					TRB->PA010604    := Substr(_cDesSub,1,30)
					TRB->PA010605    := MV_PAR01
					TRB->PA010606    := MV_PAR02
					TRB->PA010607    := _cGrup
					TRB->PA010608    := SED->ED_CLASSE
					MsUnlock()
				Else
					dbSelectArea("TRB")
					RecLock("TRB",.F.)
					If SE5->E5_TIPODOC $ "MT/M2/JR/J2"
						If SE5->E5_RECPAG == "P"
							TRB->VALORD  += _nValMov
						Else
							TRB->VALORC  += _nValMov
						Endif
					ElseIf SE5->E5_TIPODOC $ "DC/D2"
						If SE5->E5_RECPAG == "P"
							TRB->VALORC  += _nValMov
						Else
							TRB->VALORD  += _nValMov
						Endif
					ElseIf SE5->E5_TIPODOC $ "V2"
						TRB->VALORD  += _nValMov
					Else
						If SE5->E5_RECPAG == "R"
							TRB->VALORC  += _nValMov
						Else
							TRB->VALORD  += _nValMov
						Endif
					Endif
					MsUnlock()
       			Endif
			Endif
		Endif
		
		RestArea(_aAliSED)
		
		dbSelectArea("SE5")
		dbSkip()
	Enddo

	If !_lEntr
		If SUBSTR(SED->ED_GRGEREN,1,1) == "1"
			_cGrup  := "1- ATIVO"
		ElseIf SUBSTR(SED->ED_GRGEREN,1,1) == "2"
			_cGrup  := "2- PASSIVO"
		ElseIf SUBSTR(SED->ED_GRGEREN,1,1) $ "3/4"
			_cGrup  := "3-4 DEMONSTRATIVO DE RESULTADO
		ElseIf SUBSTR(SED->ED_GRGEREN,1,1) == "5"
			_cGrup  := "5- RESULTADO FINANCEIRO"
		ElseIf SUBSTR(SED->ED_GRGEREN,1,1) == "6"
			_cGrup  := "6- RESULTADO NAO OPERACIONAL"
		Else
			_cGrup  := "9- LANCAMENTOS DO PASSADO"
		Endif
		
		_cDesSub := Tabela("Z9",SED->ED_GRGEREN)
		dbSelectArea("TRB")
		If !dbseek(SED->ED_GRGEREN + SED->ED_CODIGO)
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->PA010601    := SED->ED_CODIGO
			TRB->PA010602    := SED->ED_DESCRIC
			TRB->PA010603    := SED->ED_GRGEREN
			TRB->PA010609    := Substr(SED->ED_GRGEREN,1,1)
			TRB->PA010604    := Substr(_cDesSub,1,30)
			TRB->PA010605    := MV_PAR01
			TRB->PA010606    := MV_PAR02
			TRB->PA010607    := _cGrup
			TRB->PA010608    := SED->ED_CLASSE
		Endif
	Endif
	
	dbSelectArea("SED")
	dbSkip()
Enddo

Return


Static Function SALDOATU(_lFim)

dbSelectArea("TRB")
dbGotop()

_nTot01 := _nTot02 := _nTot34 := _nTotGr1 := _nTotGrD :=  _nTotGrC := 0

While !EOF()
	
	//	If TRB->PA010601  $  "1012      /1013      "
	//		_nSalAnt := (TRB->VLSALDOD - TRB->VLSALDOC)
	//		_nSalAtu := _nSalAnt  + TRB->VALORD - TRB->VALORC
	//	Else
	_nSalAnt := (TRB->VLSALDOC - TRB->VLSALDOD)
	_nSalAtu := _nSalAnt  + TRB->VALORC - TRB->VALORD
	//	Endif
	
	If Substr(TRB->PA010603,1,1) == "1"
		_nTot01  += _nSalAtu
	ElseIf Substr(TRB->PA010603,1,1) == "2"
		_nTot02  += _nSalAtu
	ElseIf Substr(TRB->PA010603,1,1) $ "3"
		_nTot34  += _nSalAtu
		_nTotGrD += TRB->VALORD
		_nTotGrC += TRB->VALORC
	Else
		_nTotGrD += TRB->VALORD
		_nTotGrC += TRB->VALORC
	Endif
	
	_nHoriz := ((_nSalAtu -_nSalAnt)/_nSalAnt)*100
	
	dbSelectArea("TRB")
	RecLock("TRB",.F.)
	TRB->VALOR01 := _nSalAnt
	TRB->VALOR04 := _nSalAtu
	TRB->VALOR05 := _nHoriz
	MsUnlock()
	
	dbSelectArea("TRB")
	dbSkip()
Enddo

dbSelectArea("TRB")
dbGotop()

While !EOF()
	
	_nSalAtu := TRB->VALOR04
	_nVer    := 0
	If Substr(TRB->PA010603,1,1) == "1"
		_nVer := (_nSalAtu / _nTot01 ) * 100
	ElseIf Substr(TRB->PA010603,1,1) == "2"
		_nVer := (_nSalAtu / _nTot02 ) * 100
	ElseIf Substr(TRB->PA010603,1,1) $ "345"
		_nVer := (_nSalAtu / _nTot34 ) * 100
	Endif
	
	dbSelectArea("TRB")
	RecLock("TRB",.F.)
	TRB->VALOR06 := _nVer
	TRB->VALOR07 := _nTotGrD
	TRB->VALOR08 := _nTotGrC
	MsUnlock()
	
	dbSelectArea("TRB")
	dbSkip()
Enddo

Return
