#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0122   ³ Autor ³ Fabiano da Silva      ³ Data ³ 22.03.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatório de Ocorrencias                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaEst                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ-±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0122()

LOCAL titulo      := "Relatorio de Ocorrencias"
LOCAL cDesc1      := "Este programa ira emitir as ocorrencias em relacao         "
LOCAL cDesc2      := "A producao conforme lançamentos  "
LOCAL cDesc3      := "Conforme Parametros informados.  Programa PA0122       "
LOCAL CbCont,cabec1,cabec2
tamanho           := "M"
Limite            := 132
cString           := "SD3"
Private aOrd      := {"Por Data","Por Prensa","Por Ocorrencia","Por Nome"}
PRIVATE aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
PRIVATE nomeprog  := "PA0122"
PRIVATE aLinha    := { },nLastKey := 0
PRIVATE cPerg     := "PA0122"
Private cArqLog

cbtxt             := SPACE(10)
cbcont            := 0
li                := 80
m_pag             := 1
wnrel             := "PA0122"

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

_nOrdem := aReturn[8]

Pergunte("PA0122",.F.)

If nLastKey==27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

//  PERGUNTE PA0122
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
_bAcao01   := {|_lFim| PA122A(@_lFim) }
_cTitulo01 := 'Processando'
RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cArqNew := "\relato\pa0122.dbf"
dbSelectArea("TRB")
Copy All to &_cArqNew
dbCloseArea()

Ferase(cArqLog+".dbf")
Ferase(cArqLog+OrdbagExt())

Return


Static Function PA122A(_lFim)    // PRENSA

aStru := {}
AADD(aStru,{"CODOP"    , "C" , 06, 0 } )
AADD(aStru,{"NOMOP"    , "C" , 20, 0 } )
AADD(aStru,{"DTEMIS"   , "D" ,  8, 0 })    // DATA DE EMISSAO PEDIDO
AADD(aStru,{"OCORRE"   , "C" , 06, 0 })    // Ocorrencia
AADD(aStru,{"NOMOCO"   , "C" , 30, 0 })    // Nome da Ocorrencia
AADD(aStru,{"PRENSA"   , "C" , 06, 0 })    // PRENSA
AADD(aStru,{"HORAS"    , "N" , 12, 2 })    // Horas Perdidas
AADD(aStru,{"PORCEN"   , "N" , 07, 2 })    // Porcentagem
AADD(aStru,{"EXTRA"    , "C" , 03, 0 })    // Hora Extra
AADD(aStru,{"HRPADR"   , "N" , 10, 2 })    // Hora Padrão

cArqLOG := CriaTrab(aStru,.T.)
If _nOrdem == 1    // DATA
	cIndLOG := "DTOS(DTEMIS)+OCORRE+PRENSA+NOMOP+EXTRA"
ElseIf _nOrdem == 2      // PRENSA
	cIndLOG := "PRENSA+DTOS(DTEMIS)+OCORRE+NOMOP+EXTRA"
ElseIf _nOrdem == 3      // OCORRENCIA
	cIndLOG := "OCORRE+DTOS(DTEMIS)+PRENSA+NOMOP+EXTRA"
ElseIf _nOrdem == 4      // OPERADOR
	cIndLOG := "NOMOP+DTOS(DTEMIS)+OCORRE+PRENSA+EXTRA"
Endif

dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

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

	If SD3->D3_RECURSO < MV_PAR03  .Or. SD3->D3_RECURSO  > MV_PAR04 .Or.;
		SD3->D3_OCORR < MV_PAR05  .Or. SD3->D3_OCORR  > MV_PAR06 .Or.;
		SD3->D3_OPPRENSA < MV_PAR07 .Or. SD3->D3_OPPRENSA > MV_PAR08 .Or. SD3->D3_LOCAL != "20"
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif

	If Substr(SD3->D3_CF,1,2) != "PR"
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif
                        
	If Empty(SD3->D3_OCORR) .Or. SD3->D3_OCORR $ "019   /020   "
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif

	dbSelectArea("SZ6")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ6")+SD3->D3_OPPRENS)
		
		If SZ6->Z6_ATIVO != "1"
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif

		If (MV_PAR09 = 1 .And. SZ6->Z6_LOCAL = "2") .Or.;
			(MV_PAR09 = 2 .And. SZ6->Z6_LOCAL = "1")
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		If SZ6->Z6_TURNO < MV_PAR10 .Or. SZ6->Z6_TURNO > MV_PAR11
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
	Endif
	             
   	_nZaHI := _nZaHF := 0
                        	                                     
	If !Empty(SD3->D3_TURNO)
	    dbSelectArea("SZA")
	    dbSetOrder(1)
	    dbSeek(xFilial("SZA")+SD3->D3_TURNO)
	    
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
		_cExtra   := "SIM"

	Endif

	If _nOrdem == 1    // DATA
		_cSeek := DTOS(SD3->D3_EMISSAO)+SD3->D3_OCORR+SD3->D3_RECURSO+SZ6->Z6_NOME+_cExtra
	ElseIf _nOrdem == 2      // PRENSA
		_cSeek := SD3->D3_RECURSO+DTOS(SD3->D3_EMISSAO)+SD3->D3_OCORR+SZ6->Z6_NOME+_cExtra
	ElseIf _nOrdem == 3      // OCORRENCIA
		_cSeek := SD3->D3_OCORR+DTOS(SD3->D3_EMISSAO)+SD3->D3_RECURSO+SZ6->Z6_NOME+_cExtra
	ElseIf _nOrdem == 4      // OPERADOR
		_cSeek := SZ6->Z6_NOME+DTOS(SD3->D3_EMISSAO)+SD3->D3_OCORR+SD3->D3_RECURSO+_cExtra
	Endif

	_nHIni1 := Val(Substr(StrZero(SD3->D3_HORINIC,5,2),1,2))
	_nHFim1 := Val(Substr(StrZero(SD3->D3_HORFINA,5,2),1,2))
	_nHIni2 := Val(Substr(StrZero(SD3->D3_HORINIC,5,2),4,2))
	_nHFim2 := Val(Substr(StrZero(SD3->D3_HORFINA,5,2),4,2))
	
	If SD3->D3_HORINIC > SD3->D3_HORFINA
		_nHFim1 += 24
	Endif
	
	_nOcorr := (((_nHFim1 - _nHIni1) * 60) - _nHIni2) + _nHFim2
	
	If SD3->D3_TURNO $ "02    /05    "
//		_nZaHI += 24
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
		                        
    _nOcor0 := _nOcorr / 60           
	_nOcor1 := Val(Substr(StrZero(_nOcor0,5,2),1,2))
	_nOcor2 := (_nOcorr - (_nOcor1 * 60)) / 100
	_nOcor3 := _nOcor1 + _nOcor2       
			
	_cDesOco := Tabela("Z4",SD3->D3_OCORR)
	dbSelectArea("TRB")
	If !dbSeek(_cSeek)
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->CODOP    := SD3->D3_OPPRENSA
		TRB->NOMOP    := SZ6->Z6_NOME
		TRB->DTEMIS   := SD3->D3_EMISSAO
		TRB->OCORRE   := SD3->D3_OCORR
		TRB->NOMOCO   := Substr(_cDesOco,1,30)
		TRB->PRENSA   := SD3->D3_RECURSO
		TRB->HORAS    := _nOcor3
		TRB->PORCEN   := (_nOcorr / _nHrsPad) * 100
		TRB->HRPADR   := _nHrsPad
		TRB->EXTRA    := _cExtra
		MsUnLock()
	Else
		_nHora1 := (Val(Substr(StrZero(TRB->HORAS,5,2),1,2))) * 60
		_nHora2 := Val(Substr(StrZero(TRB->HORAS,5,2),4,2))
		_nHora3 := _nHora1 + _nHora2
		
		_nOcor4 := _nOcorr + _nHora3
		_nOcor5 := Val(Substr(StrZero((_nOcor4 / 60),5,2),1,2))
		_nOcor6 := (_nOcor4 - (_nOcor5 * 60)) / 100
		
		_nOcor7 := _nOcor5 + _nOcor6

		RecLock("TRB",.F.)
		TRB->HORAS    := _nOcor7
		TRB->PORCEN   := (_nOcor4 / _nHrsPad) * 100
		MsUnLock()
	Endif
	
	dbSelectArea("SD3")
	dbSkip()
EndDo

/*
DATA       PRENSA  OPERADOR                                   CODIGO   NOME OCORRENCIA                   HORAS PERD.       PORC  H.E
99999999   999999  9999999999999999999999999999999999999999   999999   999999999999999999999999999999    9999,999.99    9999.99  999
0          11      19                                         62       71                                105            120      129
*/

nTipo  := IIF(aReturn[4]==1,15,18)
li     := 80
titulo := "Relatorio de Ocorrencias"
Cabec1 := "DATA       PRENSA  OPERADOR                                   CODIGO   NOME OCORRENCIA                   HORAS PERD.       PORC  H.E"
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
		@Li, 106 Psay _nQtHoras          			Picture TM(_nQtHoras,11,2)
		@Li, 120 Psay (_nHora7 /_nQtPorc )* 100    	Picture "@E 9999.99"
		
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
	@Li, 19  PSay TRB->NOMOP
	@Li, 62  PSay TRB->OCORRE
	@Li, 71  PSay TRB->NOMOCO
	@Li, 105 Psay TRB->HORAS            Picture TM(TRB->HORAS,11,2)
	@Li, 120 Psay TRB->PORCEN			Picture "@E 9999.99"
	@Li, 129 Psay TRB->EXTRA
	
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
@Li, 105 Psay _nQtHoras          			Picture TM(_nQtHoras,11,2)
@Li, 120 Psay ( _nHora7 /_nQtPorc ) * 100	Picture "@E 9999.99"

_nTHoras += _nQtHoras
_nTPorc  += _nQtPorc
_nTMin   += _nHora7

Li += 2
@Li,00 PSAY Replicate("-",limite)
Li += 2

@Li,000  PSAY "TOTAL GERAL   -------------------->"
@Li, 105 Psay _nTHoras          			Picture TM(_nTHoras,11,2)
@Li, 120 Psay (_nTMin /_nTPorc)* 100 		Picture "@E 9999.99"

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
		@Li, 106 Psay _nQtHoras          			Picture TM(_nQtHoras,11,2)
		@Li, 120 Psay (_nHora7 /_nQtPorc )* 100    	Picture "@E 9999.99"
		
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
	@Li, 19  PSay TRB->NOMOP
	@Li, 62  PSay TRB->OCORRE
	@Li, 71  PSay TRB->NOMOCO
	@Li, 105 Psay TRB->HORAS            Picture TM(TRB->HORAS,11,2)
	@Li, 120 Psay TRB->PORCEN			Picture "@E 9999.99"
	@Li, 129 Psay TRB->EXTRA
	
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
@Li, 105 Psay _nQtHoras          			Picture TM(_nQtHoras,11,2)
@Li, 120 Psay ( _nHora7 /_nQtPorc ) * 100	Picture "@E 9999.99"

_nTHoras += _nQtHoras
_nTPorc  += _nQtPorc
_nTMin   += _nHora7

Li += 2
@Li,00 PSAY Replicate("-",limite)
Li += 2

@Li,000  PSAY "TOTAL GERAL   -------------------->"
@Li, 105 Psay _nTHoras          			Picture TM(_nTHoras,11,2)
@Li, 120 Psay (_nTMin /_nTPorc)* 100 		Picture "@E 9999.99"

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
		@Li, 106 Psay _nQtHoras          			Picture TM(_nQtHoras,11,2)
		@Li, 120 Psay (_nHora7 /_nQtPorc )* 100    	Picture "@E 9999.99"
		
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
	@Li, 19  PSay TRB->NOMOP
	@Li, 62  PSay TRB->OCORRE
	@Li, 71  PSay TRB->NOMOCO
	@Li, 105 Psay TRB->HORAS            Picture TM(TRB->HORAS,11,2)
	@Li, 120 Psay TRB->PORCEN			Picture "@E 9999.99"
	@Li, 129 Psay TRB->EXTRA
	
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
@Li, 105 Psay _nQtHoras          			Picture TM(_nQtHoras,11,2)
@Li, 120 Psay ( _nHora7 /_nQtPorc ) * 100	Picture "@E 9999.99"

_nTHoras += _nQtHoras
_nTPorc  += _nQtPorc
_nTMin   += _nHora7

Li += 2
@Li,00 PSAY Replicate("-",limite)
Li += 2

@Li,000  PSAY "TOTAL GERAL   -------------------->"
@Li, 105 Psay _nTHoras          			Picture TM(_nTHoras,11,2)
@Li, 120 Psay (_nTMin /_nTPorc)* 100 		Picture "@E 9999.99"

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
		@Li, 106 Psay _nQtHoras          			Picture TM(_nQtHoras,11,2)
		@Li, 120 Psay (_nHora7 /_nQtPorc )* 100    	Picture "@E 9999.99"
		
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
	@Li, 19  PSay TRB->NOMOP
	@Li, 62  PSay TRB->OCORRE
	@Li, 71  PSay TRB->NOMOCO
	@Li, 105 Psay TRB->HORAS            Picture TM(TRB->HORAS,11,2)
	@Li, 120 Psay TRB->PORCEN			Picture "@E 9999.99"
	@Li, 129 Psay TRB->EXTRA
	
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
@Li, 105 Psay _nQtHoras          			Picture TM(_nQtHoras,11,2)
@Li, 120 Psay ( _nHora7 /_nQtPorc ) * 100	Picture "@E 9999.99"

_nTHoras += _nQtHoras
_nTPorc  += _nQtPorc
_nTMin   += _nHora7

Li += 2
@Li,00 PSAY Replicate("-",limite)
Li += 2

@Li,000  PSAY "TOTAL GERAL   -------------------->"
@Li, 105 Psay _nTHoras          			Picture TM(_nTHoras,11,2)
@Li, 120 Psay (_nTMin /_nTPorc)* 100 		Picture "@E 9999.99"

Return