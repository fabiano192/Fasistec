#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0119   ³ Autor ³ Alexandro da Silva    ³ Data ³ 15.02.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Produçao Prevista X Produção Realizada                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaEst                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ-±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0119()

LOCAL titulo      := "Producao Realizada X Producao Realizada"
LOCAL cDesc1      := "Este programa ira emitir um comparativo em  relacao         "
LOCAL cDesc2      := "A producao Prevista entre a Acumulada conforme lançamentos  "
LOCAL cDesc3      := "PCP. Conforme Parametros informados.  Programa PA0119       "
LOCAL CbCont,cabec1,cabec2
tamanho           := "M"
Limite            := 132
cString           := "SD3"
Private aOrd      := {"Por Data","Por Prensa","Por Operador","Por Produto"}
PRIVATE aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
PRIVATE nomeprog  := "PA0119"
PRIVATE aLinha    := { },nLastKey := 0
PRIVATE cPerg     := "PA0119"
Private cArqLog
Private cArLog1

cbtxt             := SPACE(10)
cbcont            := 0
li                := 80
m_pag             := 1
wnrel             := "PA0119"

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

_nOrdem := aReturn[8]

Pergunte("PA0119",.F.)

If nLastKey==27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

//  PERGUNTE PA0119
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
_bAcao01   := {|_lFim| PA119A(@_lFim) }
_cTitulo01 := 'Processando'
RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cArqNew := "\relato\pa0119.dbf"
dbSelectArea("TRB")
Copy All to &_cArqNew
dbCloseArea()

dbSelectArea("TMP")
dbCloseArea()

Ferase(cArqLog+".dbf")
Ferase(cArqLog+OrdbagExt())

Ferase(cArLog1+".dbf")
Ferase(cArLog1+OrdbagExt())

Return


Static Function PA119A(_lFim)    // PRENSA

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


aStru := {}
AADD(aStru,{"OPERADOR" , "C" , 06, 0 })    // OPERADOR DA PRENSA
AADD(aStru,{"DTEMIS"   , "D" ,  8, 0 })    // DATA DE EMISSAO PEDIDO

cArLOG1 := CriaTrab(aStru,.T.)
cInLOG1 := "DTOS(DTEMIS) + OPERADOR"

dbUseArea(.T.,,cArLOG1,"TMP",.F.,.F.)

dbSelectArea("TMP")
IndRegua("TMP",cArLog1,cInLog1,,,"Criando Trabalho...")
                        

dbSelectarea("SD3")
dbSetOrder(6)
dbSeek(xFilial("SD3")+DTOS(MV_PAR01),.T.)

SetRegua(RecCount())

While !Eof() .And. !_lFim .And. SD3->D3_EMISSAO <= MV_PAR02
	
	IncRegua("Processando Movimento Interno!!")
	
	If _lFim
		Return
	Endif
	
	If SD3->D3_ESTORNO == "S"
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif
	
	If SD3->D3_COD     < MV_PAR03  .Or. SD3->D3_COD      > MV_PAR04 .Or.;
		SD3->D3_RECURSO < MV_PAR05  .Or. SD3->D3_RECURSO  > MV_PAR06 .Or.;
		SD3->D3_OPPRENS < MV_PAR07  .Or. SD3->D3_OPPRENS  > MV_PAR08 .Or. !SD3->D3_LOCAL $ "20/25"
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+SD3->D3_COD)
		If SB1->B1_GRUPO < MV_PAR09 .Or. SB1->B1_GRUPO > MV_PAR10 .Or.;
			SB1->B1_SUBGR < MV_PAR11 .Or. SB1->B1_SUBGR > MV_PAR12
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
	Endif
	
	If Substr(SD3->D3_CF,1,2) != "PR"
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif
	
	
	 _cNomOpe := ""
	dbSelectArea("SZ6")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ6")+SD3->D3_OPPRENS)

		_cNomOpe  := Substr(SZ6->Z6_NOME,1,30)
		
		If SZ6->Z6_ATIVO != "1"
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		If (MV_PAR13 = 1 .And. SZ6->Z6_LOCAL = "2") .Or.;
			(MV_PAR13 = 2 .And. SZ6->Z6_LOCAL = "1")
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		If SZ6->Z6_TURNO < MV_PAR14 .Or. SZ6->Z6_TURNO > MV_PAR15
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
	Endif
	
	_nNumPlat := 0
	dbSelectarea("SH1")
	dbSelectArea(1)
	If dbSeek(xFilial("SH1")+SD3->D3_RECURSO)
		_nNumPlat := SH1->H1_NUMPLAT   // NUMERO DE PLATORES
	Endif
	
	_nPrVen  := 0
	_cCod    := Substr(SD3->D3_COD,1,6)+Space(9)
	_cCodSG1 := ""
	
	dbSelectArea("SG1")
	dbSetOrder(2)
	If dbSeek(xFilial("SG1")+SD3->D3_COD)
		
		If Substr(SG1->G1_COD,1,2) != "PP" .And. Len(Alltrim(SG1->G1_COD)) != 6
			_cCodEs := SG1->G1_COD
			dbSelectArea("SG1")
			dbSetOrder(2)
			dbSeek(xFilial("SG1")+_cCodEs)
		Endif
		
		_lEstrPP := .F.              
		_nPrcVD := 0
		If 	Substr(SG1->G1_COD,1,2) == "PP"
			_cPP := SG1->G1_COD			
			dbSelectArea("SG1")
			dbSetOrder(2)
			If dbSeek(xFilial("SG1")+_cPP)
				While !EOF() .And. _cPP == SG1->G1_COMP 
				               
					_cCodSG1 := SG1->G1_COD
					
					dbSelectArea("SD2")
					dbSetOrder(6)
					dbSeek(xFilial("SD2")+_cCodSG1+"99"+"99999999",.T.)
					dbSkip(-1)       

					dbSelectArea("SC6")
					dbSetOrder(1)
					If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
						If SC6->C6_PEDAMOS == "D" .Or. SD2->D2_TIPO == "C"
							dbSelectArea("SD2")
							dbSetOrder(6)
							dbSeek(xFilial("SD2")+_cCodSG1+"99"+"99999999",.T.)
							dbSkip(-2)
						
							dbSelectArea("SC6")
							dbSetOrder(1)
							If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
								If SC6->C6_PEDAMOS == "D" .Or. SD2->D2_TIPO == "C"
							
									dbSelectArea("SD2")
									dbSetOrder(6)
									dbSeek(xFilial("SD2")+_cCodSG1+"99"+"99999999",.T.)
									dbSkip(-3)
								Endif
							Endif
						Endif
					Endif
					
					If _nPrcVD < SD2->D2_PRCVEN
						_nPrcVD := SD2->D2_PRCVEN
					Endif	
				         
					dbSelectArea("SG1")
					dbSkip()
				EndDo	
			
				_lEstrPP := .T.
			Endif
		Endif
				
		If !_lEstrPP
			If Alltrim(SG1->G1_COD) == "007150"
				_cCodSG1 := "007151"+Space(9)
			Else
				_cCodSG1 := SG1->G1_COD
			Endif	
			
			dbSelectArea("SD2")
			dbSetOrder(6)
			dbSeek(xFilial("SD2")+_cCodSG1+"99"+"99999999",.T.)
			dbSkip(-1)
			
			dbSelectArea("SC6")
			dbSetOrder(1)
			If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
				If SC6->C6_PEDAMOS == "D" .Or. SD2->D2_TIPO == "C"
					dbSelectArea("SD2")
					dbSetOrder(6)
					dbSeek(xFilial("SD2")+_cCodSG1+"99"+"99999999",.T.)
					dbSkip(-2)
					
					dbSelectArea("SC6")
					dbSetOrder(1)
					If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
						If SC6->C6_PEDAMOS == "D" .Or. SD2->D2_TIPO == "C"
							
							dbSelectArea("SD2")
							dbSetOrder(6)
							dbSeek(xFilial("SD2")+_cCodSG1+"99"+"99999999",.T.)
							dbSkip(-3)
						Endif
					Endif
				Endif
			Endif
			_nPrcVD := SD2->D2_PRCVEN
		Endif

		If SD2->D2_COD == _cCodSG1
			_nPrVen := _nPrcVD
		Else	
			_nPrVen := 0
		Endif	
			
	Endif
	
	_nHrsPad := _nZaHI := _nZaHF  := 0
	_cExtra  := "N"
		
	If !Empty(SD3->D3_TURNO)
	    dbSelectArea("SZA")
	    dbSetOrder(1)
	    dbSeek(xFilial("SZA")+SD3->D3_TURNO)
	    
   		If SZA->ZA_ATIVO != "1"
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		If (MV_PAR13 = 1 .And. SZA->ZA_LOCAL = "2") .Or.;
			(MV_PAR13 = 2 .And. SZA->ZA_LOCAL = "1")
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
		If SD3->D3_TURNO $ "02    /05    "
//			_nZaHI += 24
		Endif		
    Else		
		
		_nHExIn1 := Val(Substr(StrZero(SD3->D3_HREXINI,5,2),1,2))
		_nHExIn2 := Val(Substr(StrZero(SD3->D3_HREXINI,5,2),4,2))
		_nHExFi1 := Val(Substr(StrZero(SD3->D3_HREXFIM,5,2),1,2))
		_nHExFi2 := Val(Substr(StrZero(SD3->D3_HREXFIM,5,2),4,2))
		
		If SD3->D3_HREXINI > SD3->D3_HREXFIM
			_nHExFi1 += 24
		Endif

        // Desconto Hora Extra
		_nHDeE01 := Val(Substr(StrZero(SD3->D3_HREXDES,5,2),1,2))
		_nHDeE02 := Val(Substr(StrZero(SD3->D3_HREXDES,5,2),4,2))

		_nhrExDe := (_nHDeE01 * 60) + _nHDeE02
		
		_nHrsPad  := ((((_nHExFi1 - _nHExIn1) * 60) - _nHExIn2) + _nHExFi2) - _nhrExDe
		_cExtra   := "S"

	Endif
	
	_nHIni1 := Val(Substr(StrZero(SD3->D3_HORINIC,5,2),1,2))
	_nHFim1 := Val(Substr(StrZero(SD3->D3_HORFINA,5,2),1,2))
	_nHIni2 := Val(Substr(StrZero(SD3->D3_HORINIC,5,2),4,2))
	_nHFim2 := Val(Substr(StrZero(SD3->D3_HORFINA,5,2),4,2))
	
	If SD3->D3_HORINIC > SD3->D3_HORFINA
		_nHFim1 += 24
	Endif
	
	_nOcorr := (((_nHFim1 - _nHIni1) * 60) - _nHIni2) + _nHFim2
		
	If SD3->D3_TURNO $ "05    "
		_nZaHI += 24
	Endif		

	If (SD3->D3_HORINIC < _nZaHI .and. SD3->D3_HORFINA > _nZaHF) .Or.;
		(SD3->D3_HORINIC = _nZaHI .and. SD3->D3_HORFINA > _nZaHF) .Or.;
		(SD3->D3_HORINIC < _nZaHI .and. SD3->D3_HORFINA = _nZaHF)
		_nOcorr -= 60
	Endif
	
	If SD3->D3_HORINIC < 9.00 .and. SD3->D3_HORFINA > 9.10
		_nOcorr -= 10
	Endif	

	If SD3->D3_HORINIC < 15.00 .and. SD3->D3_HORFINA > 15.10
		_nOcorr -= 10
	Endif	
	
/*	dbSelectArea("TMP")
	If !dbSeek(DTOS(SD3->D3_EMISSAO)+SD3->D3_OPPRENSA)
		_nOcorr -= 10
	Endif	
  */
	
	If _nOrdem == 1    // DATA
		_cSeek := DTOS(SD3->D3_EMISSAO)+SD3->D3_RECURSO+_cNomOpe+SD3->D3_COD+_cExtra+ SD3->D3_NUMCAV
	ElseIf _nOrdem == 2      // PRENSA
		_cSeek := SD3->D3_RECURSO+DTOS(SD3->D3_EMISSAO)+_cNomOpe+SD3->D3_COD+_cExtra+ SD3->D3_NUMCAV
	ElseIf _nOrdem == 3      // OPERADOR
		_cSeek := _cNomOpe+DTOS(SD3->D3_EMISSAO)+SD3->D3_RECURSO+SD3->D3_COD+_cExtra+ SD3->D3_NUMCAV
	ElseIf _nOrdem == 4      // PRODUTO
		_cSeek := SD3->D3_COD+DTOS(SD3->D3_EMISSAO)+SD3->D3_RECURSO+_cNomOpe+_cExtra+ SD3->D3_NUMCAV
	Endif
	
	dbSelectArea("TRB")
	If dbSeek(_cSeek)
		RecLock("TRB",.F.)
		TRB->OCORRE   += _nOcorr
		TRB->QTE      += SD3->D3_QUANT
		TRB->VALOR    := TRB->QTE * _nPrVen
		TRB->QTDREA   += (SD3->D3_QUANT / VAL(SD3->D3_NUMCAV)) // / _nNumPlat
		TRB->QTDPRE   := (_nHrsPad - TRB->OCORRE) / SD3->D3_CICLO
		TRB->PORCEN   := (TRB->QTDREA / TRB->QTDPRE) * 100
		MsUnLock()
	Else
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->DTEMIS   := SD3->D3_EMISSAO
		TRB->PRODUTO  := SD3->D3_COD
		TRB->QTDCAV   := IIf(Len(SD3->D3_NUMCAV) = 1, "0"+SD3->D3_NUMCAV , SD3->D3_NUMCAV)
		TRB->CICLO    := SD3->D3_CICLO
		TRB->PRENSA   := SD3->D3_RECURSO
		TRB->OPERADOR := SD3->D3_OPPRENSA
		TRB->QTDREA   := (SD3->D3_QUANT / VAL(SD3->D3_NUMCAV)) // / _nNumPlat
		TRB->QTDPRE   := (_nHrsPad - _nOcorr) / SD3->D3_CICLO
		TRB->PORCEN   := (TRB->QTDREA / TRB->QTDPRE) * 100
		TRB->VALOR    := SD3->D3_QUANT * _nPrVen
		TRB->QTE      := SD3->D3_QUANT
		TRB->OCORRE   := _nOcorr
		TRB->EXTRA    := _cExtra
		TRB->NOMOPERA := _cNomOpe
		MsUnLock()
	Endif

	dbSelectArea("TMP")
	If !dbSeek(DTOS(SD3->D3_EMISSAO)+SD3->D3_OPPRENSA)
		RecLock("TMP",.T.)
		TMP->DTEMIS   := SD3->D3_EMISSAO
		TMP->OPERADOR := SD3->D3_OPPRENSA
		MsUnLock()
	Endif	
	
	dbSelectArea("SD3")
	dbSkip()
EndDo

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
