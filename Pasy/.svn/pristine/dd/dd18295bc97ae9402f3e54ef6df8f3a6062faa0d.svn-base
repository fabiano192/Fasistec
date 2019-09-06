#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPA0106    บ Autor ณ Fabiano da Silva   บ Data ณ  12/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Balancete de verificacao por natureza                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Sigafin(SE2)                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PA0106A()

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
@ 26,18 SAY "Pelo usuario. Programa PA0106A.PRW                  "     SIZE 160,7
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

_cArqNew1 := "\spool\PA0106.DBF"
dbSelectArea("TMP")
Copy All To &_cArqNew1
dbCloseArea()
/*
If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf
  */
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\spool\PA0106.DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)



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
AADD(aStru,{"PA010602"  , "C" , 30, 0 })  // Descri็ใo da Natureza
AADD(aStru,{"PA010603"  , "C" ,  3, 0 })  // Grupo
AADD(aStru,{"PA010604"  , "C" , 40, 0 })  // Nome do Grupo
AADD(aStru,{"PA010605"  , "D" ,  8, 0 })  // Data DE
AADD(aStru,{"PA010606"  , "D" ,  8, 0 })  // Data ATE
AADD(aStru,{"PA010607"  , "C" , 40, 0 })  // Descri็ใo
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

aCampos := {}  
AADD(aCampos,{"NATUREZA"	, "C" , 10, 0 })
AADD(aCampos,{"DESC_NAT"	, "C" , 40, 0 })
AADD(aCampos,{"COD_LOJA"	, "C" , 09, 0 })
AADD(aCampos,{"CLIFORN"		, "C" , 60, 0 })
AADD(aCampos,{"VALORD" 	    , "N" , 14, 2 })
AADD(aCampos,{"VALORC" 	    , "N" , 14, 2 })

_cArqTMP := CriaTrab(aCampos,.T.)
_cIndTMP := "NATUREZA+COD_LOJA"

dbUseArea(.T.,,_cArqTMP,"TMP",.F.,.F.)
dbSelectArea("TMP")
IndRegua("TMP",_cArqTMP,_cIndTMP,,,"Criando Trabalho...")

_dUltFech := GETMV("MV_PA0108")  // Data da Ultima Apura็ใo do resultado
_dDtInic := _dUltFech + 1

_lmvpar03 := _lmvpar04 := .F.

If Alltrim(MV_PAR03) $ "1086/1087"
	_lmvpar03 := .T.
Endif

If Alltrim(MV_PAR04) $ "1086/1087"
	_lmvpar04 := .T.
Endif
   
_cQuery := " SELECT * FROM SE1010 E1 "
_cQuery += " INNER JOIN SED010 ED ON E1_NATUREZ = ED_CODIGO "
_cQuery += " WHERE E1.D_E_L_E_T_ = ''  AND ED.D_E_L_E_T_ = '' "
_cQuery += " AND E1_NATUREZ BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_cQuery += " AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
_cQuery += " AND E1_TIPO <> 'AB-' "
_cQuery += " ORDER BY E1_NATUREZ "

TCQUERY _cQuery NEW ALIAS "ZE1"

TCSETFIELD("ZE1","E1_EMISSAO","D")                   

ZE1->(dbGotop())

ProcRegua(ZE1->(U_CONTREG()))

While ZE1->(!Eof()) .And. !_lFim
	                                                
	IncProc("Natureza - Receber: "+ZE1->ED_CODIGO)
	
	_cNaturez := ZE1->ED_CODIGO
	_lEntr    := .F.
		
//	If !Empty(ZE1->E1_FATURA).And. ZE1->E1_FATURA != "NOTFAT"
	If !Empty(ZE1->E1_FATURA).And. ZE1->E1_FATURA == "NOTFAT"
		dbSelectArea("ZE1")
		dbSkip()
		Loop
	Endif
		
	If ALLTRIM(ZE1->ED_CODIGO) $ "1086/1087/2304" .And. ZE1->E1_EMISSAO < MV_PAR01
		dbSelectArea("ZE1")
		dbSkip()
		Loop
	Endif

	_cGrup  := ""
	If SUBSTR(ZE1->ED_GRGEREN,1,1) == "1"
		_cGrup  := "1- ATIVO"
	ElseIf SUBSTR(ZE1->ED_GRGEREN,1,1) == "2"
		_cGrup  := "2- PASSIVO"
	ElseIf SUBSTR(ZE1->ED_GRGEREN,1,1) $ "3/4"
		_cGrup  := "3-4 DEMONSTRATIVO DE RESULTADO"
	ElseIf SUBSTR(ZE1->ED_GRGEREN,1,1) == "5"
		_cGrup  := "5- RESULTADO FINANCEIRO"
	ElseIf SUBSTR(ZE1->ED_GRGEREN,1,1) == "6"
		_cGrup  := "6- RESULTADO NAO OPERACIONAL"
	Else
		_cGrup  := "9- LANCAMENTOS DO PASSADO"
	Endif
		
	_cDesSub := ""
	dbSelectArea("SX5")
	If dbSeek(xFilial("SX5")+"Z9"+ZE1->ED_GRGEREN)
		_cDesSub := SX5->X5_DESCRI
	Endif	
							
	_nValSE5 := 0
	If 	!SUBSTR(ZE1->ED_GRGEREN,1,1) $ "3/4/5" .And. ZE1->ED_CONSBX != "N"
		dbSelectArea("SE5")
		dbSetOrder(7)
		If dbSeek(xFilial("SE5")+ZE1->E1_PREFIXO + ZE1->E1_NUM + ZE1->E1_PARCELA + ZE1->E1_TIPO + ZE1->E1_CLIENTE + ZE1->E1_LOJA)
					
			_cChavSE5 := SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR  + SE5->E5_LOJA
					
			While !Eof() .And. _cChavSE5 == SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR  + SE5->E5_LOJA
						
				If !Empty(SE5->E5_SITUACA )
					dbSelectArea("SE5")
					dbSkip()
					Loop
				Endif
					
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
		       
	If ZE1->E1_NATUREZ = "2140"
		_lPare := .T.
	Endif

	dbSelectArea("TRB")
	If !dbseek(ZE1->ED_GRGEREN +ZE1->E1_NATUREZ)
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->PA010601    := ZE1->E1_NATUREZ
		TRB->PA010602    := ZE1->ED_DESCRIC
		TRB->PA010603    := ZE1->ED_GRGEREN
		TRB->PA010609    := Substr(ZE1->ED_GRGEREN,1,1)
		TRB->PA010604    := Substr(_cDesSub,1,30)
		TRB->PA010605    := MV_PAR01
		TRB->PA010606    := MV_PAR02
		TRB->PA010607    := _cGrup
		TRB->PA010608    := ZE1->ED_CLASSE
		If ZE1->E1_TIPO $ "NCC/AB-/VNR"
			TRB->VALORD  := ZE1->E1_VALOR   // Debito
			TRB->VALORC  := _nValSE5        // Credito
		Else
			TRB->VALORC  := ZE1->E1_VALOR   // Credito
			TRB->VALORD  := _nValSE5        // Debito
		Endif
		MsUnlock()
	Else
		RecLock("TRB",.F.)
		If ZE1->E1_TIPO $ "NCC/AB-/VNR"
			TRB->VALORD  += ZE1->E1_VALOR   // Debito
			TRB->VALORC  += _nValSE5        // Credito
		Else
			TRB->VALORC  += ZE1->E1_VALOR   // Credito
			TRB->VALORD  += _nValSE5        // Debito
			Endif
		MsUnlock()
	Endif

	dbSelectArea("SA1")
	dbsetOrder(1)
	If dbSeek(xFilial("SA1")+ZE1->E1_CLIENTE+ZE1->E1_LOJA)

		dbSelectArea("TMP")
		If !dbseek(ZE1->E1_NATUREZ+ZE1->E1_CLIENTE+"/"+ZE1->E1_LOJA)
			RecLock("TMP",.T.)
			TMP->NATUREZA	:= ZE1->E1_NATUREZ
			TMP->DESC_NAT	:= ZE1->ED_DESCRIC
			TMP->COD_LOJA	:= ZE1->E1_CLIENTE+"/"+ZE1->E1_LOJA
			TMP->CLIFORN	:= SA1->A1_NOME
			If SE1->E1_TIPO $ "NCC/AB-/VNR"
				TMP->VALORD		:= ZE1->E1_VALOR
				TMP->VALORC		:= _nValSE5
			Else
				TMP->VALORC		:= ZE1->E1_VALOR
				TMP->VALORD		:=  _nValSE5 		
    		Endif
			MsUnlock()
		Else
			RecLock("TMP",.F.)
			If SE1->E1_TIPO $ "NCC/AB-/VNR"
				TMP->VALORD		+= ZE1->E1_VALOR
				TMP->VALORC		+= _nValSE5
			Else
				TMP->VALORC		+= ZE1->E1_VALOR
				TMP->VALORD		+=  _nValSE5 		
    		Endif
			MsUnlock()				
		Endif	
    Endif

	dbSelectArea("ZE1")
	dbSkip()
EndDo
	
dbSelectArea("ZE1")
dbCloseArea()

_cQuery := " SELECT * FROM SE2010 E2 "
_cQuery += " INNER JOIN SED010 ED ON E2_NATUREZ = ED_CODIGO "
_cQuery += " WHERE E2.D_E_L_E_T_ = '' AND ED.D_E_L_E_T_ = '' "
_cQuery += " AND E2_NATUREZ BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_cQuery += " AND E2_EMIS1 BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " ORDER BY E2_NATUREZ "

TCQUERY _cQuery NEW ALIAS "ZE2"
                   
TCSETFIELD("ZE2","E2_EMIS1","D")

ZE2->(dbGotop())

ProcRegua(ZE2->(U_CONTREG()))

While ZE2->(!Eof()) .And. !_lFim
	       
	IncProc("Natureza - Pagar: "+ZE2->ED_CODIGO)
			
	If ZE2->E2_NUM = "009550"
		_lPare := .T.
	Endif	

//	If !Empty(ZE2->E2_FATURA) .And. ZE2->E2_FATURA != "NOTFAT"
	If !Empty(ZE2->E2_FATURA) .And. ZE2->E2_FATURA == "NOTFAT"
		dbSelectArea("ZE2")
		dbSkip()
		Loop
	Endif

	If ZE2->ED_CODIGO $ "2304      " .And. ZE2->E2_EMIS1 < MV_PAR01
		dbSelectArea("ZE2")
		dbSkip()
		Loop
	Endif

	_lEntr := .T.

	If SUBSTR(ZE2->ED_GRGEREN,1,1) == "1"
		_cGrup  := "1- ATIVO"
	ElseIf SUBSTR(ZE2->ED_GRGEREN,1,1) == "2"
		_cGrup  := "2- PASSIVO"
	ElseIf SUBSTR(ZE2->ED_GRGEREN,1,1) $ "3/4"
		_cGrup  := "3-4 DEMONSTRATIVO DE RESULTADO"
	ElseIf SUBSTR(ZE2->ED_GRGEREN,1,1) == "5"
		_cGrup  := "5- RESULTADO FINANCEIRO"
	ElseIf SUBSTR(ZE2->ED_GRGEREN,1,1) == "6"
		_cGrup  := "6- RESULTADO NAO OPERACIONAL"
	Else
		_cGrup  := "9- LANCAMENTOS DO PASSADO"
	Endif
		                                  
	_cDesSub := ""
	dbSelectArea("SX5")
	If dbSeek(xFilial("SX5")+"Z9"+ZE2->ED_GRGEREN)
		_cDesSub := SX5->X5_DESCRI
	Endif	

	_nValSE5 := 0
	If 	!SUBSTR(ZE2->ED_GRGEREN,1,1) $ "3/4/5" .And. ZE2->ED_CONSBX != "N"

		dbSelectArea("SE5")
		dbSetOrder(7)
		If dbSeek(xFilial("SE5")+ZE2->E2_PREFIXO + ZE2->E2_NUM + ZE2->E2_PARCELA + ZE2->E2_TIPO + ZE2->E2_FORNECE + ZE2->E2_LOJA)
					
			_cChavSE5 := SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR  + SE5->E5_LOJA
					
			While !Eof() .And. _cChavSE5 == SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR  + SE5->E5_LOJA
						
				If !Empty(SE5->E5_SITUACA )
					dbSelectArea("SE5")
					dbSkip()
					Loop
				Endif

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
			       
	If ZE2->E2_NATUREZ = "2140"
		_lPare := .T.
	Endif
		
	dbSelectArea("TRB")
	If !dbseek(ZE2->ED_GRGEREN +ZE2->E2_NATUREZ)
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->PA010601    := ZE2->E2_NATUREZ
		TRB->PA010602    := ZE2->ED_DESCRIC
		TRB->PA010603    := ZE2->ED_GRGEREN
		TRB->PA010609    := Substr(ZE2->ED_GRGEREN,1,1)
		TRB->PA010604    := Substr(_cDesSub,1,30)
		TRB->PA010605    := MV_PAR01
		TRB->PA010606    := MV_PAR02
		TRB->PA010607    := _cGrup
		TRB->PA010608    := ZE2->ED_CLASSE
		If ZE2->E2_TIPO $ "NDF/AB-/VNP"
			TRB->VALORC  := ZE2->E2_VALOR
			TRB->VALORD  := _nValSE5
		Else
			TRB->VALORD  := ZE2->E2_VALOR
			TRB->VALORC  := _nValSE5
		Endif
	Else
		RecLock("TRB",.F.)
		If ZE2->E2_TIPO $ "NDF/AB-/VNP"
			TRB->VALORC  += ZE2->E2_VALOR
			TRB->VALORD  += _nValSE5
		Else
			TRB->VALORD  += ZE2->E2_VALOR
			TRB->VALORC  += _nValSE5
		Endif
	MsUnlock()
	Endif

	dbSelectArea("SA2")
	dbsetOrder(1)
	If dbSeek(xFilial("SA2")+ZE2->E2_FORNECE+ZE2->E2_LOJA)

		dbSelectArea("TMP")
		If !dbseek(ZE2->E2_NATUREZ+ZE2->E2_FORNECE+"/"+ZE2->E2_LOJA)
			RecLock("TMP",.T.)
			TMP->NATUREZA	:= ZE2->E2_NATUREZ
			TMP->DESC_NAT	:= ZE2->ED_DESCRIC
			TMP->COD_LOJA	:= ZE2->E2_FORNECE+"/"+ZE2->E2_LOJA
			TMP->CLIFORN	:= SA2->A2_NOME
			If SE2->E2_TIPO $ "NDF/AB-/VNP"
				TMP->VALORC  := ZE2->E2_VALOR
				TMP->VALORD  := _nValSE5
			Else
				TMP->VALORD  := ZE2->E2_VALOR
				TMP->VALORC  := _nValSE5
    		Endif
			MsUnlock()
		Else
			RecLock("TMP",.F.)
			If SE2->E2_TIPO $ "NDF/AB-/VNP"
				TMP->VALORC  += ZE2->E2_VALOR
				TMP->VALORD  += _nValSE5
			Else
				TMP->VALORD  += ZE2->E2_VALOR
				TMP->VALORC  += _nValSE5
    		Endif
			MsUnlock()				
		Endif	
  	Endif
	
	dbSelectArea("ZE2")
	dbSkip()
EndDo

dbSelectArea("ZE2")
dbCloseArea()

_cQuery := " SELECT * FROM SE5010 E5 "
_cQuery += " WHERE E5.D_E_L_E_T_ = '' "
_cQuery += " AND E5_DTDISPO >= '"+DTOS(MV_PAR01)+"' "
_cQuery += " AND E5_SITUACA = '' "
_cQuery += " AND E5_TIPODOC NOT IN ('ES','MT','JR','DC','D2','J2','TL','M2','CM','C2','CH','CA','EC','E2','BD','PA','CB') "
_cQuery += " ORDER BY E5_NATUREZ "

TCQUERY _cQuery NEW ALIAS "ZE5A"
                   
TCSETFIELD("ZE5A","E5_DTDISPO","D")

ZE5A->(dbGotop())

ProcRegua(ZE5A->(U_CONTREG()))

While ZE5A->(!Eof()) .And. !_lFim
	       
	IncProc("Natureza-MB")
					  
	If ZE5A->E5_RECPAG = "P"
		dbSelectArea("SE2")
		dbSetOrder(1)
		If dbSeek(xFilial("SE2")+ZE5A->E5_PREFIXO + ZE5A->E5_NUMERO + ZE5A->E5_PARCELA + ZE5A->E5_TIPO + ZE5A->E5_CLIFOR  + ZE5A->E5_LOJA)
                                 
			IF SE2->E2_EMIS1 >= MV_PAR01
				dbSelectArea("ZE5A")
				dbSkip()
				Loop
			Endif
			
			dbSelectArea("SED")
			dbSetOrder(1)
			If !dbSeek(xFilial("SED")+SE2->E2_NATUREZ)
				dbSelectArea("ZE5A")
				dbSkip()
				Loop
			Endif
										
//			If !Empty(SE2->E2_FATURA) .And. SE2->E2_FATURA != "NOTFAT"
			If !Empty(SE2->E2_FATURA) .And. SE2->E2_FATURA == "NOTFAT"
				dbSelectArea("ZE5A")
				dbSkip()
				Loop
			Endif

			If SED->ED_CODIGO $ "2304      " .And. SE2->E2_EMIS1 < MV_PAR01
				dbSelectArea("ZE5A")
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
		                                 
			_cDesSub := ""
			dbSelectArea("SX5")
			If dbSeek(xFilial("SX5")+"Z9"+SED->ED_GRGEREN)
				_cDesSub := SX5->X5_DESCRI
			Endif	
										
			_nMesSE5 := (ZE5A->E5_VALOR + ZE5A->E5_VLDESCO - ZE5A->E5_VLJUROS - ZE5A->E5_VLMULTA)
											
			If !SUBSTR(SED->ED_GRGEREN,1,1) $ "3/4/5" .And. SED->ED_CONSBX != "N"

				If SED->ED_CODIGO = "2140"
					_lPare := .T.
				Endif

				dbSelectArea("TRB")
				If !dbseek(SED->ED_GRGEREN + SE2->E2_NATUREZ)
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
						TRB->VALORD    := _nMesSE5
					Else
						TRB->VALORC    := _nMesSE5
					Endif
					MsUnlock()
				Else
					RecLock("TRB",.F.)
					If SE2->E2_TIPO $ "NDF/AB-/VNP"
						TRB->VALORD    += _nMesSE5
					Else
						TRB->VALORC    += _nMesSE5
					Endif
					MsUnlock()					
				Endif
				
				dbSelectArea("SA2")
				dbsetOrder(1)
				If dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)

					dbSelectArea("TMP")
					If !dbseek(SE2->E2_NATUREZ+SE2->E2_FORNECE+"/"+SE2->E2_LOJA)
						RecLock("TMP",.T.)
						TMP->NATUREZA	:= SE2->E2_NATUREZ
						TMP->DESC_NAT	:= SED->ED_DESCRIC
						TMP->COD_LOJA	:= SE2->E2_FORNECE+"/"+SE2->E2_LOJA
						TMP->CLIFORN	:= SA2->A2_NOME
						If SE2->E2_TIPO $ "NDF/AB-/VNP"
							TMP->VALORD  := _nMesSE5
						Else
							TMP->VALORC  := _nMesSE5
						Endif
						MsUnlock()
					Else
						RecLock("TMP",.F.)
						If SE2->E2_TIPO $ "NDF/AB-/VNP"
							TMP->VALORD  += _nMesSE5
						Else
							TMP->VALORC  += _nMesSE5
						Endif
						MsUnlock()				
					Endif	
    	        Endif
			Endif
        Endif
    Else
							
		dbSelectArea("SE1")
		dbSetOrder(1)
		If dbSeek(xFilial("SE1")+ZE5A->E5_PREFIXO + ZE5A->E5_NUMERO + ZE5A->E5_PARCELA + ZE5A->E5_TIPO + ZE5A->E5_CLIFOR  + ZE5A->E5_LOJA)
                                 
			IF SE1->E1_EMISSAO >= MV_PAR01
				dbSelectArea("ZE5A")
				dbSkip()
				Loop
			Endif
			
			dbSelectArea("SED")
			dbSetOrder(1)
			If !dbSeek(xFilial("SED")+SE1->E1_NATUREZ)
				dbSelectArea("ZE5A")
				dbSkip()
				Loop
			Endif
										
//			If !Empty(SE1->E1_FATURA) .And. SE1->E1_FATURA != "NOTFAT"
			If !Empty(SE1->E1_FATURA) .And. SE1->E1_FATURA == "NOTFAT"
				dbSelectArea("ZE5A")
				dbSkip()
				Loop
			Endif

			If SED->ED_CODIGO $ "2304      " .And. SE1->E1_EMISSAO < MV_PAR01
				dbSelectArea("ZE5A")
				dbSkip()
				Loop
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
		                                 
			_cDesSub := ""
			dbSelectArea("SX5")
			If dbSeek(xFilial("SX5")+"Z9"+SED->ED_GRGEREN)
				_cDesSub := SX5->X5_DESCRI
			Endif	
										
			_nMesSE5 := (ZE5A->E5_VALOR + ZE5A->E5_VLDESCO - ZE5A->E5_VLJUROS - ZE5A->E5_VLMULTA)
											
			If !SUBSTR(SED->ED_GRGEREN,1,1) $ "3/4/5" .And. SED->ED_CONSBX != "N"

				dbSelectArea("TRB")
				If !dbseek(SED->ED_GRGEREN + SE1->E1_NATUREZ)
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
						TRB->VALORD    := _nMesSE5
					Else
						TRB->VALORC    := _nMesSE5
					Endif
					MsUnlock()
				Else
					RecLock("TRB",.F.)
					If SE1->E1_TIPO $ "RA /NCC/AB-/VNR"
						TRB->VALORD    += _nMesSE5
					Else
						TRB->VALORC    += _nMesSE5
					Endif
					MsUnlock()					
				Endif

				dbSelectArea("SA1")
				dbsetOrder(1)
				If dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)

					dbSelectArea("TMP")
					If !dbseek(SED->ED_CODIGO+SE1->E1_CLIENTE+"/"+SE1->E1_LOJA)
						RecLock("TMP",.T.)
						TMP->NATUREZA	:= SED->ED_CODIGO
						TMP->DESC_NAT	:= SED->ED_DESCRIC
						TMP->COD_LOJA	:= SE1->E1_CLIENTE+"/"+SE1->E1_LOJA
						TMP->CLIFORN	:= SA1->A1_NOME
						If SE1->E1_TIPO $ "RA /NCC/AB-/VNR"
							TMP->VALORD    := _nMesSE5
						Else
							TMP->VALORC    := _nMesSE5
						Endif
						MsUnlock()
					Else
						RecLock("TMP",.F.)
						If SE1->E1_TIPO $ "RA /NCC/AB-/VNR"
							TMP->VALORD    += _nMesSE5
						Else
							TMP->VALORC    += _nMesSE5
						Endif
						MsUnlock()				
					Endif	
    	       	Endif

			Endif	
        Endif        
    Endif
        
	dbSelectArea("ZE5A")
	dbSkip()
EndDo

dbSelectArea("ZE5A")
dbCloseArea()

_lGo := .F.
If !_lmvpar03 .and. !_lmvpar04
	_lGo := .T.
Endif	

_cq := " SELECT * FROM SE5010 E5 "
_cq += " INNER JOIN SED010 ED ON ED_CODIGO = E5_NATUREZ "
_cq += " WHERE E5.D_E_L_E_T_ = '' AND ED.D_E_L_E_T_ = '' "
If _lGo
	_cq += " AND E5_NATUREZ BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
Endif	
//_cq += " AND E5_DTDISPO <= '"+DTOS(MV_PAR02)+"' "
_cq += " AND E5_DTDISPO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
_cq += " AND E5_SITUACA = ''"
_cq += " AND E5_TIPODOC NOT IN ('ES','TL','M2','CM','C2','CH','EC','RA','PA','CP') "
_cq += " ORDER BY E5_NATUREZ,E5_DTDISPO "

TCQUERY _cQ NEW ALIAS "ZE5"

TCSETFIELD("ZE5","E5_DTDISPO","D")

ZE5->(dbGotop())

ProcRegua(ZE5->(U_CONTREG()))

While ZE5->(!Eof()) .And. !_lFim
	
	IncProc("Natureza - Movto Bancario: "+ZE5->ED_CODIGO)
										
	If ZE5->ED_CODIGO $ "2304      " .And. ZE5->E5_DTDISPO  < MV_PAR01
		dbSelectArea("ZE5")
		dbSkip()
		Loop
	Endif
		
	_lEntr   := .T.
	_cNatur  := ""
	_cNatAb  := ""
		
	_nValMov := (ZE5->E5_VALOR + ZE5->E5_VLDESCO - ZE5->E5_VLJUROS - ZE5->E5_VLMULTA)
		
	If ZE5->E5_TIPODOC $ "VL/BA"
		dbSelectArea("SE1")
		dbSetOrder(1)
		If dbSeek(xFilial("SE1")+ZE5->E5_PREFIXO + ZE5->E5_NUMERO + ZE5->E5_PARCELA + "AB-")
			_cNatAb := SE1->E1_NATOUT2
		Else
			dbSelectArea("ZE5")
			dbSkip()
			Loop
		Endif
	
		_nValMov := SE1->E1_VALOR
			
		If ZE5->E5_DTDISPO < MV_PAR01
			dbSelectArea("SED")
			dbSetOrder(1)
			dbSeek(xFilial("SED")+SE1->E1_NATUREZ)
			         
			If SE1->E1_NATUREZ = "1020"
				_lPare := .T.
			Endif
				
			_cGrup   := "1- ATIVO"
			_cDesSub := Tabela("Z9",SED->ED_GRGEREN)
				
			dbSelectArea("TRB")
			If !dbseek(SED->ED_GRGEREN +SED->ED_CODIGO)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
//				TRB->VLSALDOD  := _nValMov
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
//				TRB->VLSALDOD  += _nValMov
				MsUnlock()
			Endif        
		Else
			dbSelectArea("SED")
			dbSetOrder(1)
			dbSeek(xFilial("SED")+SE1->E1_NATUREZ)
				
			_cGrup   := "1- ATIVO"
			_cDesSub := Tabela("Z9",SED->ED_GRGEREN)

			If SED->ED_CODIGO = "2140"
				_lPare := .T.
			Endif

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

			dbSelectArea("SA1")
			dbsetOrder(1)
			If dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
				dbSelectArea("TMP")
				If !dbseek(SED->ED_CODIGO+SE1->E1_CLIENTE+"/"+SE1->E1_LOJA)
					RecLock("TMP",.T.)
					TMP->NATUREZA	:= SED->ED_CODIGO
					TMP->DESC_NAT	:= SED->ED_DESCRIC
					TMP->COD_LOJA	:= SE1->E1_CLIENTE+"/"+SE1->E1_LOJA
					TMP->CLIFORN	:= SA1->A1_NOME
			 		TMP->VALORD		:= _nValMov
					MsUnlock()
				Else
					RecLock("TMP",.F.)
					TMP->VALORD		+= _nValMov
					MsUnlock()				
				Endif	
   	       Endif

		Endif
	Endif
	
	If !ZE5->E5_TIPODOC $ "VL/BA"
		If ZE5->E5_RECPAG == "R" .And. !Empty(ZE5->E5_TIPO)
			If ZE5->E5_TIPO $ "PA /NDF"
				dbSelectArea("SE2")
				dbSetOrder(1)
				If dbSeek(xFilial("SE2")+ZE5->E5_PREFIXO + ZE5->E5_NUMERO + ZE5->E5_PARCELA + ZE5->E5_TIPO + ZE5->E5_CLIFOR + ZE5->E5_LOJA)
					If ZE5->E5_TIPODOC $ "DC/D2"
						_cNatur := SE2->E2_NATOUT2
					ElseIf ZE5->E5_TIPODOC $ "MT/JR/M2/J2"
						_cNatur := SE2->E2_NATOUT
					Endif
				Endif
			Else
				dbSelectArea("SE1")
				dbSetOrder(1)
				If dbSeek(xFilial("SE1")+ZE5->E5_PREFIXO + ZE5->E5_NUMERO + ZE5->E5_PARCELA + ZE5->E5_TIPO )
					If ZE5->E5_TIPODOC $ "DC/D2"
						_cNatur := SE1->E1_NATOUT2
					ElseIf ZE5->E5_TIPODOC $ "MT/JR/M2/J2"
						_cNatur := SE1->E1_NATOUT
					Endif
				Endif
				
				dbSelectArea("SE1")
				dbSetOrder(1)
				If dbSeek(xFilial("SE1")+ZE5->E5_PREFIXO + ZE5->E5_NUMERO + ZE5->E5_PARCELA + "AB-")
					_cNatAb := SE1->E1_NATOUT2
				Endif
			Endif
		ElseIf ZE5->E5_RECPAG == "P" .And. !Empty(ZE5->E5_TIPO)
			If !ZE5->E5_TIPO $ "RA /NCC"
				dbSelectArea("SE2")
				dbSetOrder(1)
				If dbSeek(xFilial("SE2")+ZE5->E5_PREFIXO + ZE5->E5_NUMERO + ZE5->E5_PARCELA + ZE5->E5_TIPO + ZE5->E5_CLIFOR + ZE5->E5_LOJA)
					If ZE5->E5_TIPODOC $ "DC/D2"
						_cNatur := SE2->E2_NATOUT2
					ElseIf ZE5->E5_TIPODOC $ "MT/JR/M2/J2"
						_cNatur := SE2->E2_NATOUT
					Endif
				Endif
			Else
				dbSelectArea("SE1")
				dbSetOrder(1)
				If dbSeek(xFilial("SE1")+ZE5->E5_PREFIXO + ZE5->E5_NUMERO + ZE5->E5_PARCELA + ZE5->E5_TIPO )
					If ZE5->E5_TIPODOC $ "DC/D2"
						_cNatur := SE1->E1_NATOUT2
					ElseIf ZE5->E5_TIPODOC $ "MT/JR/M2/J2"
						_cNatur := SE1->E1_NATOUT
					Endif
				Endif
			Endif
		Endif
			
		_nValMov := (ZE5->E5_VALOR + ZE5->E5_VLDESCO - ZE5->E5_VLJUROS - ZE5->E5_VLMULTA)
		
		If !Empty(_cNatur)
			dbSelectArea("SED")
			dbSetOrder(1)
			dbSeek(xFilial("SED")+_cNatur)
		Else
			If ZE5->E5_TIPODOC $ "MT/M2/JR/J2"
				If ZE5->E5_RECPAG == "P"
					dbSelectArea("SED")
					dbSetOrder(1)
					dbSeek(xFilial("SED")+"4781")
				Else
					dbSelectArea("SED")
					dbSetOrder(1)
					dbSeek(xFilial("SED")+"3121")
				Endif
			ElseIf ZE5->E5_TIPODOC $ "DC/D2"
				If ZE5->E5_RECPAG == "P"
					dbSelectArea("SED")
					dbSetOrder(1)
					dbSeek(xFilial("SED")+"3180")
				Else
					dbSelectArea("SED")
					dbSetOrder(1)
					dbSeek(xFilial("SED")+"4780")
				Endif
			ElseIf ZE5->E5_TIPODOC $ "V2"
				dbSelectArea("SED")
				dbSetOrder(1)
				dbSeek(xFilial("SED")+"1085")
			Else
				dbSelectArea("SED")
				dbSetOrder(1)
				dbSeek(xFilial("SED")+ZE5->ED_CODIGO)			
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
			
		If ZE5->E5_DTDISPO < MV_PAR01

			If SED->ED_CODIGO = "1020"
				_lPare := .T.
			Endif

			dbSelectArea("TRB")
			If !dbseek(SED->ED_GRGEREN +SED->ED_CODIGO)

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
				MsUnlock()

			Endif	
		Else  

			If SED->ED_CODIGO = "2140"
				_lPare := .T.
			Endif

			dbSelectArea("TRB")
			If !dbseek(SED->ED_GRGEREN +SED->ED_CODIGO)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				If ZE5->E5_TIPODOC $ "MT/M2/JR/J2"
					If ZE5->E5_RECPAG == "P"
						TRB->VALORD  := _nValMov
					Else
						TRB->VALORC  := _nValMov
					Endif
				ElseIf ZE5->E5_TIPODOC $ "DC/D2"
					If ZE5->E5_RECPAG == "P"
						TRB->VALORC  := _nValMov
					Else
						TRB->VALORD  := _nValMov
					Endif
				ElseIf ZE5->E5_TIPODOC $ "V2"
					TRB->VALORD  := _nValMov
				Else
					If ZE5->E5_RECPAG == "R"
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

				_cNome := ""
				If ZE5->E5_RECPAG = 'R'	
					dbSelectArea("SA1")
					dbsetOrder(1)
					If dbSeek(xFilial("SA1")+ZE5->E5_CLIFOR+ZE5->E5_LOJA)
						_cNome := SA1->A1_NOME
					Endif
				ElseIf ZE5->E5_RECPAG = 'P'	
					dbSelectArea("SA1")
					dbsetOrder(1)
					If dbSeek(xFilial("SA1")+ZE5->E5_CLIFOR+ZE5->E5_LOJA)
						_cNome := SA1->A1_NOME
					Endif
                Endif
				
				dbSelectArea("TMP")
				If !dbseek(SED->ED_CODIGO+ZE5->E5_CLIFOR+"/"+ZE5->E5_LOJA)
					RecLock("TMP",.T.)
					TMP->NATUREZA	:= SED->ED_CODIGO
					TMP->DESC_NAT	:= SED->ED_DESCRIC
					TMP->COD_LOJA	:= ZE5->E5_CLIFOR+"/"+ZE5->E5_LOJA
					TMP->CLIFORN	:= _cNome
					If ZE5->E5_TIPODOC $ "MT/M2/JR/J2"
						If ZE5->E5_RECPAG == "P"
							TMP->VALORD  := _nValMov
						Else
							TMP->VALORC  := _nValMov
						Endif
					ElseIf ZE5->E5_TIPODOC $ "DC/D2"
						If ZE5->E5_RECPAG == "P"
							TMP->VALORC  := _nValMov
						Else
							TMP->VALORD  := _nValMov
						Endif
					ElseIf ZE5->E5_TIPODOC $ "V2"
						TMP->VALORD  := _nValMov
					Else
						If ZE5->E5_RECPAG == "R"
							TMP->VALORC  := _nValMov
						Else
							TMP->VALORD  := _nValMov
						Endif
					Endif
					MsUnlock()
				Else
					RecLock("TMP",.F.)
					If ZE5->E5_TIPODOC $ "MT/M2/JR/J2"
						If ZE5->E5_RECPAG == "P"
							TMP->VALORD  += _nValMov
						Else
							TMP->VALORC  += _nValMov
						Endif
					ElseIf ZE5->E5_TIPODOC $ "DC/D2"
						If ZE5->E5_RECPAG == "P"
							TMP->VALORC  += _nValMov
						Else
							TMP->VALORD  += _nValMov
						Endif
					ElseIf ZE5->E5_TIPODOC $ "V2"
						TMP->VALORD  += _nValMov
					Else
						If ZE5->E5_RECPAG == "R"
							TMP->VALORC  += _nValMov
						Else
							TMP->VALORD  += _nValMov
						Endif
					Endif
					MsUnlock()				
				Endif	

			Else
				dbSelectArea("TRB")
				RecLock("TRB",.F.)
				If ZE5->E5_TIPODOC $ "MT/M2/JR/J2"
					If ZE5->E5_RECPAG == "P"
						TRB->VALORD  += _nValMov
					Else
						TRB->VALORC  += _nValMov
					Endif
				ElseIf ZE5->E5_TIPODOC $ "DC/D2"
					If ZE5->E5_RECPAG == "P"
						TRB->VALORC  += _nValMov
					Else
						TRB->VALORD  += _nValMov
					Endif
				ElseIf ZE5->E5_TIPODOC $ "V2"
					TRB->VALORD  += _nValMov
				Else
					If ZE5->E5_RECPAG == "R"
						TRB->VALORC  += _nValMov
					Else
						TRB->VALORD  += _nValMov
					Endif
				Endif
				MsUnlock()

				_cNome := ""
				If ZE5->E5_RECPAG = 'R'	
					dbSelectArea("SA1")
					dbsetOrder(1)
					If dbSeek(xFilial("SA1")+ZE5->E5_CLIFOR+ZE5->E5_LOJA)
						_cNome := SA1->A1_NOME
					Endif
				ElseIf ZE5->E5_RECPAG = 'P'	
					dbSelectArea("SA1")
					dbsetOrder(1)
					If dbSeek(xFilial("SA1")+ZE5->E5_CLIFOR+ZE5->E5_LOJA)
						_cNome := SA1->A1_NOME
					Endif
                Endif
				
				dbSelectArea("TMP")
				If !dbseek(SED->ED_CODIGO+ZE5->E5_CLIFOR+"/"+ZE5->E5_LOJA)
					RecLock("TMP",.T.)
					TMP->NATUREZA	:= SED->ED_CODIGO
					TMP->DESC_NAT	:= SED->ED_DESCRIC
					TMP->COD_LOJA	:= ZE5->E5_CLIFOR+"/"+ZE5->E5_LOJA
					TMP->CLIFORN	:= _cNome
					If ZE5->E5_TIPODOC $ "MT/M2/JR/J2"
						If ZE5->E5_RECPAG == "P"
							TMP->VALORD  := _nValMov
						Else
							TMP->VALORC  := _nValMov
						Endif
					ElseIf ZE5->E5_TIPODOC $ "DC/D2"
						If ZE5->E5_RECPAG == "P"
							TMP->VALORC  := _nValMov
						Else
							TMP->VALORD  := _nValMov
						Endif
					ElseIf ZE5->E5_TIPODOC $ "V2"
						TMP->VALORD  := _nValMov
					Else
						If ZE5->E5_RECPAG == "R"
							TMP->VALORC  := _nValMov
						Else
							TMP->VALORD  := _nValMov
						Endif
					Endif
					MsUnlock()
				Else
					RecLock("TMP",.F.)
					If ZE5->E5_TIPODOC $ "MT/M2/JR/J2"
						If ZE5->E5_RECPAG == "P"
							TMP->VALORD  += _nValMov
						Else
							TMP->VALORC  += _nValMov
						Endif
					ElseIf ZE5->E5_TIPODOC $ "DC/D2"
						If ZE5->E5_RECPAG == "P"
							TMP->VALORC  += _nValMov
						Else
							TMP->VALORD  += _nValMov
						Endif
					ElseIf ZE5->E5_TIPODOC $ "V2"
						TMP->VALORD  += _nValMov
					Else
						If ZE5->E5_RECPAG == "R"
							TMP->VALORC  += _nValMov
						Else
							TMP->VALORD  += _nValMov
						Endif
					Endif
					MsUnlock()				
				Endif	

			Endif
		Endif
	Endif
		
//	RestArea(_aAliSED)
	
	dbSelectArea("ZE5")
	dbSkip()
Enddo

dbSelectArea("ZE5")
dbCloseArea()
	      
Return


Static Function SALDOATU(_lFim)

dbSelectArea("TRB")
dbGotop()

_nTot01 := _nTot02 := _nTot34 := _nTotGr1 := _nTotGrD :=  _nTotGrC := 0

While !EOF()
	
	_nSalAnt := (TRB->VLSALDOC - TRB->VLSALDOD)
	_nSalAtu := _nSalAnt  + TRB->VALORC - TRB->VALORD
	
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