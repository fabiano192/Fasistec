#include "Protheus.ch"
#include "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ PA0170   ³ Autor ³ Fabiano da Silva      ³ Data ³ 06.01.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Peças por Hora                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaEst                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ-±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0170()

LOCAL titulo      := "Peças por Hora"
LOCAL cDesc1      := "Este programa ira emitir um comparativo em  relacao a"
LOCAL cDesc2      := "quantidade de peças por hora conforme Parametros informados."
LOCAL cDesc3      := ""
LOCAL cDesc4      := "Programa PA0170"
LOCAL CbCont,cabec1,cabec2
tamanho           := "P"
Limite            := 80
cString           := "SD3"
Private aOrd      := {}
PRIVATE aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
PRIVATE nomeprog  := "PA0170"
PRIVATE aLinha    := { },nLastKey := 0
PRIVATE cPerg     := "PA0170"
Private cArqLog,cArLog1
cbtxt             := SPACE(10)
cbcont            := 0
li                := 80
m_pag             := 1
wnrel             := "PA0170"

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

_nOrdem := aReturn[8]

Pergunte("PA0170",.F.)

If nLastKey==27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

//  PERGUNTE PA0170
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Emissao De                            ³
//³ mv_par02            // Emissao Ate                           ³
//³ mv_par03            // Do Produto                            ³
//³ mv_par04            // Ate o Produto                         ³
//³ mv_par05            // Prensa De                             ³
//³ mv_par06            // Prensa Ate                            ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

_lFim      := .F.
_cMsg01    := ''
_lAborta01 := .T.
_bAcao01   := {|_lFim| PA170A(@_lFim) }
_cTitulo01 := 'Processando'
RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cArqNew := "\spool\pa0170.dbf"
dbSelectArea("TRB")
Copy All to &_cArqNew
dbCloseArea()

Ferase(cArqLog+".dbf")
Ferase(cArqLog+OrdbagExt())

Return (Nil)


Static Function PA170A(_lFim)

_nHExFi1 := 0

aStru := {}
AADD(aStru,{"PRODUTO"  , "C" , 15, 0 }) // PRODUTO PASY
AADD(aStru,{"QTE"      , "N" , 14, 2 }) // Valor
AADD(aStru,{"TEMPO"    , "N" , 14, 2 }) // Extra

cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "PRODUTO"

dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")                        

aStr1 := {}
AADD(aStr1,{"DATAE"  	, "D" , 08, 0 }) // Data Emissão
AADD(aStr1,{"PRODUTO"  	, "C" , 15, 0 }) // Produto Pasy
AADD(aStr1,{"PRENSA"    , "C" , 06, 0 }) // Prensa
AADD(aStr1,{"OPERAD"    , "C" , 06, 0 }) // Operador de Prensa
AADD(aStr1,{"TURNO"    	, "C" , 06, 0 }) // Turno
AADD(aStr1,{"QTE"      	, "N" , 14, 2 }) // Valor
AADD(aStr1,{"TEMPO"    	, "N" , 14, 2 }) // Extra

cArqLOG1 := CriaTrab(aStr1,.T.)
cIndLOG1 := "DTOS(DATAE)+PRODUTO+PRENSA+OPERAD+TURNO"

dbUseArea(.T.,,cArqLOG1,"TMP",.F.,.F.)

dbSelectArea("TMP")
IndRegua("TMP",cArqLog1,cIndLog1,,,"Criando Trabalho...")                        

_cQuery := " SELECT * FROM SD3010 D3 "
_cQuery += " INNER JOIN SZA010 ZA ON ZA_CODIGO = D3_TURNO "
_cQuery += " WHERE D3.D_E_L_E_T_ = '' AND ZA.D_E_L_E_T_ = '' "
_cQuery += " AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND D3_ESTORNO <> 'S' AND D3_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_cQuery += " AND D3_RECURSO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND D3_LOCAL IN ('20','25')"
_cQuery += " AND SUBSTRING(D3_CF,1,2) = 'PR' "
_cQuery += " ORDER BY D3_COD "

TCQUERY _cQuery New ALIAS "TD3"

TCSETFIELD("TD3","D3_EMISSAO","D")

TD3->(dbGotop())

ProcRegua(TD3->(U_CONTREG()))

While TD3->(!Eof()) .And. !_lFim
	
	IncProc("Processando Movimento Interno!!")
	
	If _lFim
		Return
	Endif
					
	_nHrsPad := _nZaHI := _nZaHF  := _nRefei := 0
		
	If !Empty(TD3->D3_TURNO)
	    
		_nReI01 := Val(Substr(StrZero(TD3->ZA_HRINIRE,5,2),1,2))
		_nReI02 := Val(Substr(StrZero(TD3->ZA_HRINIRE,5,2),4,2))
		_nReF01 := Val(Substr(StrZero(TD3->ZA_HRFIMRE,5,2),1,2))
		_nReF02 := Val(Substr(StrZero(TD3->ZA_HRFIMRE,5,2),4,2))   
		
		_nRefei := (((_nReF01 - _nReI01) * 60) - _nReI02) + _nReF02			
		
		_nHIP01 := Val(Substr(StrZero(TD3->ZA_HRINI,5,2),1,2))
		_nHIP02 := Val(Substr(StrZero(TD3->ZA_HRINI,5,2),4,2))
		_nHFP01 := Val(Substr(StrZero(TD3->ZA_HRFIM,5,2),1,2))
		_nHFP02 := Val(Substr(StrZero(TD3->ZA_HRFIM,5,2),4,2))
	
		If TD3->ZA_HRINI > TD3->ZA_HRFIM
			_nHFP01 += 24
		Endif

		_nHCaf01 := Val(Substr(StrZero(TD3->ZA_CAFECON,5,2),1,2))
		_nHCaf02 := Val(Substr(StrZero(TD3->ZA_CAFECON,5,2),4,2))

		_nhrCafe := (_nHCaf01 * 60) + _nHCaf02

		_nHrsPad := (((((_nHFP01 - _nHIP01) * 60) - _nHIP02) + _nHFP02) - _nRefei) - _nhrCafe
		_nZaHI   := TD3->ZA_HRINIRE
		_nZaHF   := TD3->ZA_HRFIMRE
    Else		
		
		_nHExIn1 := Val(Substr(StrZero(TD3->D3_HREXINI,5,2),1,2))
		_nHExIn2 := Val(Substr(StrZero(TD3->D3_HREXINI,5,2),4,2))
		_nHExFi1 := Val(Substr(StrZero(TD3->D3_HREXFIM,5,2),1,2))
		_nHExFi2 := Val(Substr(StrZero(TD3->D3_HREXFIM,5,2),4,2))
		
		If TD3->D3_HREXINI > TD3->D3_HREXFIM
			_nHExFi1 += 24
		Endif

        // Desconto Hora Extra
		_nHDeE01 := Val(Substr(StrZero(TD3->D3_HREXDES,5,2),1,2))
		_nHDeE02 := Val(Substr(StrZero(TD3->D3_HREXDES,5,2),4,2))

		_nhrExDe := (_nHDeE01 * 60) + _nHDeE02
		
		_nHrsPad  := ((((_nHExFi1 - _nHExIn1) * 60) - _nHExIn2) + _nHExFi2) - _nhrExDe

	Endif
	
	_nHIni1 := _nHFim1 := _nHIni2 := _nHFim2 := 0

	If !TD3->D3_OCORR $ "019/020"
		_nHIni1 := Val(Substr(StrZero(TD3->D3_HORINIC,5,2),1,2))
		_nHFim1 := Val(Substr(StrZero(TD3->D3_HORFINA,5,2),1,2))
		_nHIni2 := Val(Substr(StrZero(TD3->D3_HORINIC,5,2),4,2))
		_nHFim2 := Val(Substr(StrZero(TD3->D3_HORFINA,5,2),4,2))
	
		If TD3->D3_HORINIC > TD3->D3_HORFINA
			_nHFim1 += 24
		Endif
	Endif	
	
	_nOcorr := (((_nHFim1 - _nHIni1) * 60) - _nHIni2) + _nHFim2
		
	If TD3->D3_TURNO $ "05    "
		_nZaHI += 24
	Endif		

	If (TD3->D3_HORINIC < _nZaHI .and. TD3->D3_HORFINA > _nZaHF) .Or.;
		(TD3->D3_HORINIC = _nZaHI .and. TD3->D3_HORFINA > _nZaHF) .Or.;
		(TD3->D3_HORINIC < _nZaHI .and. TD3->D3_HORFINA = _nZaHF)
//		_nOcorr -= 60
		_nOcorr -= _nRefei
	Endif
	
	If TD3->D3_HORINIC < 9.00 .and. TD3->D3_HORFINA > 9.10
		_nOcorr -= 10
	Endif

	If TD3->D3_HORINIC < 15.00 .and. TD3->D3_HORFINA > 15.10
		_nOcorr -= 10
	Endif

	dbSelectArea("TMP")
	If TMP->(dbSeek(dTOs(TD3->D3_EMISSAO)+TD3->D3_COD+TD3->D3_RECURSO+TD3->D3_OPPRENS+TD3->D3_TURNO))

		_nOcorr -= 10

		TMP->(RecLock("TMP",.F.))
		TMP->QTE      += TD3->D3_QUANT
//		TMP->TEMPO    += (_nHrsPad - _nOcorr)
		TMP->TEMPO    -= _nOcorr
		TMP->(MsUnLock())
	Else
		TMP->(RecLock("TMP",.T.))
		TMP->DATAE	  := TD3->D3_EMISSAO
		TMP->PRODUTO  := TD3->D3_COD
		TMP->PRENSA   := TD3->D3_RECURSO
		TMP->OPERAD	  := TD3->D3_OPPRENS
		TMP->TURNO	  := TD3->D3_TURNO
		TMP->TEMPO    := (_nHrsPad - _nOcorr)
		TMP->QTE      := TD3->D3_QUANT
		TMP->(MsUnLock())
	Endif

	TD3->(dbSkip())
EndDo

TD3->(dbCloseArea())

dbSelectArea("TMP")
dbGotop()

While TMP->(!EOF())

	dbSelectArea("TRB")
	If dbSeek(TMP->PRODUTO)
		TRB->(RecLock("TRB",.F.))
		TRB->QTE      += TMP->QTE
		TRB->TEMPO    += TMP->TEMPO
		TRB->(MsUnLock())
	Else
		TRB->(RecLock("TRB",.T.))
		TRB->PRODUTO  := TMP->PRODUTO
		TRB->TEMPO    := TMP->TEMPO
		TRB->QTE      := TMP->QTE
		TRB->(MsUnLock())
	Endif

	TMP->(dbSkip())
EndDo

TMP->(dbCloseArea())

/*
PRODUTO                   TEMPO      QUANTIDADE  PEÇAS P/ MINUTO   PEÇAS P/ HORA
999999999999999  999,999,999.99  999,999,999.99   999,999,999.99  999,999,999.99
0                17              33               50              66
*/

nTipo  := IIF(aReturn[4]==1,15,18)
li     := 80
Titulo := "PEÇAS POR HORA: "+Dtoc(MV_PAR01)+" A "+Dtoc(MV_PAR02)
Cabec1 := "PRODUTO                   TEMPO      QUANTIDADE  PEÇAS P/ MINUTO   PEÇAS P/ HORA"
Cabec2 := ""

PA170B()  //Impressão do Relatório


If aReturn[5] = 1
	Set Printer to
	dbCommit()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return (Nil)


Static Function PA170B(_lFim)

_nTQTem := _nTQte := 0
_lProd   := .F.
_cProd   := ""
_lEntr 	 := .f.

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

	@Li, 00  PSay TRB->PRODUTO
	@Li, 17  Psay TRB->TEMPO           			Picture TM(TRB->TEMPO,14,2)
	@Li, 33  Psay TRB->QTE           			Picture TM(TRB->QTE,14,2)
	@Li, 50  Psay TRB->QTE / TRB->TEMPO 		Picture TM(TRB->QTE,14,2)
	@Li, 66  Psay (TRB->QTE / TRB->TEMPO) * 60 	Picture TM(TRB->QTE,14,2)
	
	_lEntr  := .T.
	_nTQTem += TRB->TEMPO
	_nTQte  += TRB->QTE
	
	Li++
	dbSelectArea("TRB")
	dbSkip()
EndDo

If _lEntr 

	Li += 2
	@Li,00 PSAY Replicate("-",limite)

	Li += 2
	@Li,000 PSAY "TOTAL GERAL"

	@Li, 17  Psay _nTQTem	          			Picture TM(_nTQTem,14,2)
	@Li, 33  Psay _nTQte 	          			Picture TM(_nTQte,14,2)
	@Li, 50  Psay (_nTQte / _nTQTem)			Picture TM(_nTQte,14,2)
	@Li, 66  Psay (_nTQte / _nTQTem) * 60		Picture TM(_nTQte,14,2)

Endif

Return (Nil)