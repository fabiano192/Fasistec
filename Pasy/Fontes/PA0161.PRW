#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PA0161 บ Autor ณ Alexandro da Silva   บ Data ณ  21/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Acerto de Estoque SB9                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SigaEst                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PA0161()

ATUSX1()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private _dDtInic
Private _nQtdPodE    := 0
Private _nVlPodE     := 0
Private _nQtdPod     := 0
Private _nVlPod      := 0
Private _nQtEl       := 0
Private _nVlEl       := 0
Private _nQtDiv      := 0
Private _nVlDiv      := 0
Private cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2       := "de acordo com os parametros informados pelo usuario."
Private cDesc3       := "Saldo Em Estoque"
Private cPict        := ""
Private titulo       := "Saldo Em Estoque"
Private nLin         := 80
Private Cabec1       := "Codigo          Descricao                                                         UM    Saldo Inic.        Entradas          Saidas           Saldo       Prc.Medio          R$ Estoque"
Private Cabec2       := ""
Private imprime      := .T.
Private aOrd         := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "G"
Private nomeprog     := "PA0161"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "PA0161"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PA0161"
Private cString      := "SB1"

dbSelectArea("SB1")
dbSetOrder(1)

Pergunte(cPerg,.F.)

Wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

_nMes    := Month(MV_PAR01)
_nAno    := Year(MV_PAR01)
If _nMes == 12
	_nMesF := 1
	_nAnoF := Year(MV_PAR02)+1
Else
	_nMesF   := Month(MV_PAR02)+1
	_nAnoF   := Year(MV_PAR02)
Endif

_dDtInic := CTOD("01/"+StrZero(_nMes,2)+"/"+STRZERO(_nAno))-1

nTipo := If(aReturn[4]==1,15,18)

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| GeraSD2(@_lFim) }
Private _cTitulo01 := 'Gerando Saidas!!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cMsg01    := ''
_lAborta01 := .T.
_bAcao01   := {|_lFim| GERASD1(@_lFim) }
_cTitulo01 := 'Gerando Entradas!!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cMsg01    := ''
_lAborta01 := .T.
_bAcao01   := {|_lFim| GERASD3(@_lFim) }
_cTitulo01 := 'Gerando Movimentacao Interna Do Mes !!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cMsg01    := ''
_lAborta01 := .T.
_bAcao01   := {|_lFim| GERSDOINI(@_lFim) }
_cTitulo01 := 'Atualizando Saldo Inicial !!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cMsg01    := ''
_lAborta01 := .T.
_bAcao01   := {|_lFim| Imprime(@_lFim) }
_cTitulo01 := 'Imprimindo Mov Estoque'
RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cMsg01    := ''
_lAborta01 := .T.
_bAcao01   := {|_lFim| Resumo(@_lFim) }
_cTitulo01 := 'Imprimindo Resumo'
RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cArqNew := "\SPOOL\PA0161.DBF"

dbSelectArea("TRB")
COPY TO &_cArqNew


dbSelectArea("TB9")
dbCloseArea()

dbSelectArea("TD1")
dbCloseArea()

dbSelectArea("TD2")
dbCloseArea()

dbSelectArea("TD3")
dbCloseArea()

dbSelectArea("TRB")
dbCloseArea()

Return


Static Function GeraSD2(_lFim)

aStru := {}
AADD(aStru,{"PRODUTO"   , "C" , 15, 0 })
AADD(aStru,{"GRUPO"     , "C" ,  4, 0 })
AADD(aStru,{"TIPO"      , "C" ,  2, 0 })
AADD(aStru,{"LOCPAD"    , "C" , 02, 0 })
AADD(aStru,{"DESPROD"   , "C" , 65, 0 })
AADD(aStru,{"UM"        , "C" ,  2, 0 })
AADD(aStru,{"SDOINIC"   , "N" , 12, 2 })
AADD(aStru,{"ENTRADA"   , "N" , 12, 2 })
AADD(aStru,{"SAIDA"     , "N" , 12, 2 })
AADD(aStru,{"SALDOFIM"  , "N" , 12, 2 })
AADD(aStru,{"PRCMEDIO"  , "N" , 16, 4 })
AADD(aStru,{"VLESTOQ"   , "N" , 17, 2 })
AADD(aStru,{"DESGRUPO"  , "C" , 30, 0 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "GRUPO+PRODUTO+LOCPAD"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

_cQ := " SELECT D2_COD,D2_TIPO,B1_DESC,B1_TIPO,B1_GRUPO,B1_UM,D2_LOCAL, SUM(D2_QUANT) AS QTSAID "
_cQ += " FROM "+RetSqlName("SD2")+ " TSD2 INNER JOIN "+RetSqlName("SB1")+ " TSB1 ON D2_COD=B1_COD "
_cQ += " INNER JOIN "+RetSqlName("SF4")+ " TSF4 ON D2_TES=F4_CODIGO "
_cQ += " WHERE D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
_cQ += " AND D2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
_cQ += " AND F4_ESTOQUE = 'S' AND TSB1.D_E_L_E_T_= '' AND TSD2.D_E_L_E_T_= ''AND TSF4.D_E_L_E_T_='' "
_cQ += " GROUP BY B1_GRUPO,B1_TIPO,D2_COD,B1_DESC,B1_UM,D2_LOCAL,D2_TIPO"
_cQ += " ORDER BY B1_GRUPO,D2_COD"

TCQUERY _cQ NEW ALIAS "TD2"

dbSelectArea("TD2")
dbGotop()

ProcRegua(U_CONTREG())

While !Eof()
	
	IncProc()
	
	If _lFim
		Alert("Cancelado pelo Usuario!!!!")
		Return
	Endif
	
	_nVlSaid := TD2->QTSAID
	_nVlEntr := 0
	
	_nSdoIni := 0
	_nPrMed  := 0
	
	dbSelectArea("TRB")
	If !dbSeek(TD2->B1_GRUPO+TD2->D2_COD+TD2->D2_LOCAL)
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->PRODUTO := TD2->D2_COD
		TRB->LOCPAD  := TD2->D2_LOCAL
		TRB->GRUPO   := TD2->B1_GRUPO
		TRB->DESPROD := TD2->B1_DESC
		TRB->UM      := TD2->B1_UM
		TRB->TIPO    := TD2->B1_TIPO
		TRB->SAIDA   := _nVlSaid
		TRB->ENTRADA := _nVlEntr
		MsUnlock()
	Else
		RecLock("TRB",.F.)
		TRB->SAIDA   += _nVlSaid
		TRB->ENTRADA += _nVlEntr
		MsUnlock()
	Endif
	
	dbSelectArea("TD2")
	dbSkip()
EndDo

Return


Static Function GeraSD1(_lFim)

_cQ := " SELECT D1_TIPO,D1_COD,B1_DESC,B1_TIPO,B1_GRUPO,B1_UM,D1_LOCAL, SUM(D1_QUANT) AS QTENTR "
_cQ += " FROM "+RetSqlName("SD1")+ " TSD1 INNER JOIN "+RetSqlName("SB1")+ " TSB1 ON D1_COD=B1_COD "
_cQ += " INNER JOIN "+RetSqlName("SF4")+ " TSF4 ON D1_TES=F4_CODIGO"
_cQ += " WHERE D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQ += " AND D1_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
_cQ += " AND F4_ESTOQUE = 'S' AND TSB1.D_E_L_E_T_='' AND TSD1.D_E_L_E_T_=''AND TSF4.D_E_L_E_T_=''"
_cQ += " GROUP BY D1_TIPO,B1_GRUPO,B1_TIPO,D1_COD,B1_DESC,B1_UM,D1_LOCAL"
_cQ += " ORDER BY B1_GRUPO,D1_COD"

TCQUERY _cQ NEW ALIAS "TD1"

dbSelectArea("TD1")
dbGotop()

ProcRegua(U_CONTREG())

While !Eof()
	
	IncProc()
	
	If _lFim
		Alert("Cancelado pelo Usuario!!!!")
		Return
	Endif
	
	_nVlSaid := 0
	_nVlEntr := TD1->QTENTR
	
	_nSdoIni := 0
	_nPrMed  := 0
	dbSelectArea("TRB")
	If !dbSeek(TD1->B1_GRUPO+TD1->D1_COD+TD1->D1_LOCAL)
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->PRODUTO := TD1->D1_COD
		TRB->GRUPO   := TD1->B1_GRUPO
		TRB->LOCPAD  := TD1->D1_LOCAL
		TRB->DESPROD := TD1->B1_DESC
		TRB->UM      := TD1->B1_UM
		TRB->TIPO    := TD1->B1_TIPO
		TRB->ENTRADA := _nVlEntr
		TRB->SAIDA   := _nVlSaid
		MsUnlock()
	Else
		RecLock("TRB",.F.)
		TRB->ENTRADA += _nVlEntr
		TRB->SAIDA   += _nVlSaid
		MsUnlock()
	Endif
	
	dbSelectArea("TD1")
	dbSkip()
EndDo

Return

Static Function GeraSD3(_lFim)


_cQ := " SELECT D3_COD,D3_CF,B1_DESC,B1_TIPO,B1_GRUPO,B1_UM,D3_LOCAL , SUM(D3_QUANT) AS QTMOV "
_cQ += " FROM "+RetSqlName("SD3")+ " TSD3 INNER JOIN "+RetSqlName("SB1")+ " TSB1 ON D3_COD=B1_COD "
_cQ += " WHERE D3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQ += " AND D3_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
_cQ += " AND TSB1.D_E_L_E_T_='' AND TSD3.D_E_L_E_T_='' AND D3_ESTORNO = ''"
_cQ += " GROUP BY B1_GRUPO,B1_TIPO,D3_COD,D3_CF,B1_DESC,B1_UM,D3_LOCAL "
_cQ += " ORDER BY B1_GRUPO,D3_COD"

TCQUERY _cQ NEW ALIAS "TD3"

dbSelectArea("TD3")
dbGotop()

ProcRegua(U_CONTREG())

While !Eof()
	
	IncProc()
	
	If _lFim
		Alert("Cancelado pelo Usuario!!!!")
		Return
	Endif
	
	If Substr(TD3->D3_CF,1,2) $ "PR/DE"
		_nVlEnt := TD3->QTMOV
		_nVlSai := 0
	Else
		_nVlEnt := 0
		_nVlSai := TD3->QTMOV
	Endif
	
	_nSdoIni := 0
	_nPrMed  := 0
	dbSelectArea("TRB")
	If !dbSeek(TD3->B1_GRUPO+TD3->D3_COD+TD3->D3_LOCAL)
		
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->PRODUTO := TD3->D3_COD
		TRB->GRUPO   := TD3->B1_GRUPO
		TRB->LOCPAD  := TD3->D3_LOCAL
		TRB->DESPROD := TD3->B1_DESC
		TRB->UM      := TD3->B1_UM
		TRB->TIPO    := TD3->B1_TIPO
		TRB->ENTRADA := _nVlEnt
		TRB->SAIDA   := _nVlSai
		MsUnlock()
	Else
		RecLock("TRB",.F.)
		TRB->ENTRADA += _nVlEnt
		TRB->SAIDA   += _nVlSai
		MsUnlock()
	Endif
	
	dbSelectArea("TD3")
	dbSkip()
EndDo

Return


Static Function GERSDOINI(_lFim)

_cQ := " SELECT B1_GRUPO,B1_DESC,B1_TIPO,B1_UM,B1_LOCPAD,B9_COD,B9_LOCAL,B9_DATA,B9_QINI,B9_VINI1 "
_cQ += " FROM "+RetSqlName("SB9")+ " TSB9 INNER JOIN "+RetSqlName("SB1")+ " TSB1 ON B9_COD=B1_COD "
_cQ += " WHERE B9_DATA = '"+DTOS(MV_PAR01-1)+"' "
_cQ += " AND B9_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_cQ += " AND TSB1.D_E_L_E_T_='' AND TSB9.D_E_L_E_T_=''"
_cQ += " ORDER BY B1_GRUPO,B9_COD,B9_LOCAL"

TCQUERY _cQ NEW ALIAS "TB9B"

dbSelectArea("TB9B")
dbGotop()

ProcRegua(U_CONTREG())

While !Eof()
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	IncProc()
	
	_nPrMed := 0
	dbSelectArea("SB2")
	dbSetOrder(1)
	If dbSeek(xFilial()+TB9B->B9_COD +TB9B->B9_LOCAL)
		_nPrMed := SB2->B2_CM1
	Endif
	
	dbSelectArea("TRB")
	If !dbSeek(TB9B->B1_GRUPO+TB9B->B9_COD+TB9B->B9_LOCAL)
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->PRODUTO  := TB9B->B9_COD
		TRB->GRUPO    := TB9B->B1_GRUPO
		TRB->LOCPAD   := TB9B->B9_LOCAL
		TRB->DESPROD  := TB9B->B1_DESC
		TRB->UM       := TB9B->B1_UM
		TRB->TIPO     := TB9B->B1_TIPO
		TRB->SDOINIC  := TB9B->B9_QINI
		TRB->PRCMEDIO := _nPrMed
		TRB->VLESTOQ  := TRB->SDOINIC * _nPrMed
		TRB->SALDOFIM := TRB->SDOINIC + TRB->ENTRADA - TRB->SAIDA
		MsUnlock()
	Else
		dbSelectArea("TRB")
		RecLock("TRB",.f.)
		TRB->SDOINIC  := TB9B->B9_QINI
		TRB->PRCMEDIO := _nPrMed
		TRB->SALDOFIM := TRB->SDOINIC + TRB->ENTRADA - TRB->SAIDA
		TRB->VLESTOQ  := TRB->SALDOFIM * _nPrMed
		MsUnlock()
	Endif
	
	dbSelectArea("TB9B")
	dbSkip()
EndDo

dbSelectArea("TB9B")
dbCloseArea()


Return



Static Function Imprime(_lFim)


/*
Codigo          Descricao                                                         UM    Saldo Inic.        Entradas          Saidas           Saldo       Prc.Medio          R$ Estoque
999999999999999 99999999999999999999999999999999999999999999999999999999999999999 99 99999999999999  99999999999999  99999999999999  99999999999999  99999999999999  999999999999999999
0               16                                                                82 85              101             117             133             149             165
*/

titulo   := "Saldo Em Estoque Periodo :"+DTOC(MV_PAR01)+ " Ate "+DTOC(MV_PAR02)
_nToSdoI := 0
_nToSdoF := 0
_nToEnt  := 0
_nToSaida:= 0
_nToVlEst:= 0
_cDesGr  := ""
_nSdoIni := 0

dbSelectArea("TRB")
dbGotop()

SetRegua(RecCount())

While !EOF()
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!!")
		Return
	Endif
	
	_cGrupo  := TRB->GRUPO
	_nGrSdoI := 0
	_nGrSdoF := 0
	_nGrEnt  := 0
	_nGrSaida:= 0
	_nGrVlEst:= 0
	
	If nLin > 65
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	dbSelectArea("SBM")
	dbSetOrder(1)
	If dbSeek(xFilial()+TRB->GRUPO)
		_cDesGr := SBM->BM_DESC
	Endif
	
	@nLin,00 PSAY TRB->GRUPO + " - "+Alltrim(_cDesGr)
	nLin+= 2
	
	dbSelectArea("TRB")
	
	_lImprime := .F.
	
	While !Eof() .And. _cGrupo == TRB->GRUPO
		
		IncRegua()
		
		If _lFim
			Return
		Endif
		
		_nPrMed  := TRB->PRCMEDIO
		
		_nSdoFim := TRB->SDOINIC + TRB->ENTRADA - TRB->SAIDA
		
//		If _nSdoFim != 0
			
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+TRB->PRODUTO))
			
			SB9->(dbSetOrder(1))
			If SB9->(!dbSeek(xFilial("SB9")+TRB->PRODUTO + TRB->LOCPAD + Dtos(MV_PAR02)))
				SB9->(RecLock("SB9",.T.))
				SB9->B9_FILIAL  := xFilial("SB9")
				SB9->B9_COD     := TRB->PRODUTO
				SB9->B9_LOCAL   := TRB->LOCPAD
				SB9->B9_QINI    := _nSdoFim
				SB9->B9_VINI1   := _nSdoFim * _nPrMed
				SB9->B9_DATA  	:= MV_PAR02
				SB9->B9_MCUSTD  := "1"
				SB9->(MsUnLock())
			Endif

			SB2->(dbSetOrder(1))
			If SB2->(dbSeek(xFilial("SB2")+TRB->PRODUTO + TRB->LOCPAD))
				SB2->(RecLock("SB2",.F.))
				SB2->B2_QFIM  := _nSdoFim
				SB2->B2_VFIM1 := _nSdoFim * _nPrMed
				SB2->(MsUnlock())
			Endif
//		Endif
		
		If nLin > 65
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		_lImprime := .T.
		
		@nLin,00   PSAY TRB->PRODUTO
		@nLin,16   PSAY Alltrim(TRB->DESPROD)
		@nLin,82   PSAY TRB->UM
		@nLin,85   PSAY TRB->SDOINIC                           Picture PesqPict("SB9","B9_QINI",14)
		@nLin,101  PSAY TRB->ENTRADA                           Picture PesqPict("SB9","B9_QINI",14)
		@nLin,117  PSAY TRB->SAIDA                             Picture PesqPict("SB9","B9_QINI",14)
		@nLin,133  PSAY _nSdoFim                               Picture PesqPict("SB9","B9_QINI",14)
		@nLin,149  PSAY _nPrMed                                Picture PesqPict("SB2","B2_CM1",14)
		@nLin,165  PSAY TRB->VLESTOQ                           Picture PesqPict("SB9","B9_QINI",18)
		
		nLin++
		
		_nGrSdoI  += TRB->SDOINIC
		_nGrEnt   += TRB->ENTRADA
		_nGrSaida += TRB->SAIDA
		_nGrSdoF  += _nSdoFim
		_nGrVlEst += TRB->VLESTOQ
		
		dbSelectArea("TRB")
		dbSkip()
		
	EndDo
	
	If !_lImprime
		nLin-=2
		@nLin,00 PSAY space(132)
		Loop
	Endif
	
	nLin++
	If nLin > 65
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@nLin,00   PSAY "TOTAL DO GRUPO "+_cGrupo+" ----> "
	@nLin,85   PSAY _nGrSdoI                              Picture PesqPict("SB9","B9_QINI",14)
	@nLin,101  PSAY _nGrEnt                               Picture PesqPict("SB9","B9_QINI",14)
	@nLin,117  PSAY _nGrSaida                             Picture PesqPict("SB9","B9_QINI",14)
	@nLin,133  PSAY _nGrSdoF                              Picture PesqPict("SB9","B9_QINI",14)
	@nLin,165  PSAY _nGrVlEst                             Picture PesqPict("SB9","B9_QINI",18)
	
	nLin+=2
	
	_nToSdoI  += _nGrSdoI
	_nToEnt   += _nGrEnt
	_nToSaida += _nGrSaida
	_nToSdof  += _nGrSdoF
	_nToVlEst += _nGrVlEst
	
	dbSelectArea("TRB")
EndDo

@nLin,00   PSAY "TOTAL GERAL    ----> "
@nLin,85   PSAY _nToSdoI                              Picture PesqPict("SB9","B9_QINI",14)
@nLin,101  PSAY _nToEnt                               Picture PesqPict("SB9","B9_QINI",14)
@nLin,117  PSAY _nToSaida                             Picture PesqPict("SB9","B9_QINI",14)
@nLin,133  PSAY _nToSdoF                              Picture PesqPict("SB9","B9_QINI",14)
@nLin,165  PSAY _nToVlEst                             Picture PesqPict("SB9","B9_QINI",18)

nLin++
@nLin,00  PSAY ""

Return






Static Function Resumo(_lFim)

Cabec1 := "Codigo          Descricao                                                         UM    Saldo Inic.        Entradas          Saidas           Saldo       Prc.Medio          R$ Estoque"


_nMes    := Month(MV_PAR01)
_nAno    := Year(MV_PAR01)
_dDtInic := CTOD("01/"+StrZero(_nMes,2)+"/"+STRZERO(_nAno))-1
_nSdoIni := 0
nLin     := 80
_nToSdoI := 0
_nToSdoF := 0
_nToEnt  := 0
_nToSaida:= 0
_nToVlEst:= 0

_cArqTrb := CriaTrab(nil,.f.)
dbSelectArea("TRB")
_cIndTrb := "TIPO+PRODUTO"

dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Novo Indice...")

dbSelectArea("TRB")
dbGotop()

SetRegua(RecCount())

While !Eof()
	
	If _lFim
		Return
	Endif
	
	_ctipo := TRB->TIPO
	If Empty(_cTipo)
		dbSelectArea("TRB")
		dbSkip()
		Loop
	Endif
	
	_nTpSdoI := 0
	_nTpEnt  := 0
	_nTpSaida:= 0
	_nTpSdoF := 0
	_nTpVlEst:= 0
	
	dbSelectArea("TRB")
	
	While !Eof() .And. _ctipo == TRB->TIPO
		
		IncRegua()
		
		If _lFim
			Return
		Endif
		_nSdoIni := TRB->SDOINIC
		_nPrMed  := TRB->PRCMEDIO
		
		_nSdoFim := TRB->SDOINIC + TRB->ENTRADA - TRB->SAIDA
		
		If Round(_nSdoFim,2) == 0
			dbSelectArea("TRB")
			dbSkip()
			Loop
		Endif
		
		If Round(_nSdoFim,2) >= 0
			dbSelectArea("TRB")
			dbSkip()
			Loop
		Endif
		
		_nSdoFim   := _nSdoIni + TRB->ENTRADA - TRB->SAIDA
		_nTpSdoI   += _nSdoIni
		_nTpEnt    += TRB->ENTRADA
		_nTpSaida  += TRB->SAIDA
		_nTpSdoF   += _nSdoFim
		_nTpVlEst  += TRB->VLESTOQ
		
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	dbSelectArea("SX5")
	dbSeek(xFilial()+"02"+_cTipo)
	_cDescTipo := Rtrim(SX5->X5_DESCRI)
	
	If nLin > 65
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 10
		@nLin,82   PSAY "RESUMO POR TIPO DE PRODUTO"
		nLin+=3
	Endif
	
	@nLin,00   PSAY _cTipo
	@nLin,16   PSAY _cDescTipo
	@nLin,85   PSAY _nTpSdoI                              Picture PesqPict("SB9","B9_QINI",14)
	@nLin,101  PSAY _nTpEnt                               Picture PesqPict("SB9","B9_QINI",14)
	@nLin,117  PSAY _nTpSaida                             Picture PesqPict("SB9","B9_QINI",14)
	@nLin,133  PSAY _nTpSdoF                              Picture PesqPict("SB9","B9_QINI",14)
	@nLin,165  PSAY _nTpVlEst                             Picture PesqPict("SB9","B9_QINI",18)
	
	nLin++
	
	_nToSdoI  += _nTpSdoI
	_nToEnt   += _nTpEnt
	_nToSaida += _nTpSaida
	_nToSdof  += _nTpSdoF
	_nToVlEst += _nTpVlEst
	
EndDo

nLin+= 3
If nLin > 65
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

@nLin,00   PSAY "SUB-TOTAL   ----> "
@nLin,85   PSAY _nToSdoI                              Picture PesqPict("SB9","B9_QINI",14)
@nLin,101  PSAY _nToEnt                               Picture PesqPict("SB9","B9_QINI",14)
@nLin,117  PSAY _nToSaida                             Picture PesqPict("SB9","B9_QINI",14)
@nLin,133  PSAY _nToSdoF + _nQtdPodE + _nQtdPod      Picture PesqPict("SB9","B9_QINI",14)
@nLin,165  PSAY _nToVlEst + _nVlPodE + _nVlPod        Picture PesqPict("SB9","B9_QINI",18)

nLin+= 2
@nLin,16   PSAY " Resumo da Movimentacao em Terceiros ELESYS"
@nLin,133  PSAY _nQtEl                              Picture PesqPict("SB9","B9_QINI",14)
@nLin,165  PSAY _nVlEl                              Picture PesqPict("SB9","B9_QINI",18)

nLin++
@nLin,16   PSAY " Resumo da Movimentacao em Terceiros DIVERSOS"
@nLin,133  PSAY _nQtDiv                              Picture PesqPict("SB9","B9_QINI",14)
@nLin,165  PSAY _nVlDiv                              Picture PesqPict("SB9","B9_QINI",18)

nLin+= 2
@nLin,00   PSAY "TOTAL GERAL    ----> "
@nLin,85   PSAY _nToSdoI                              Picture PesqPict("SB9","B9_QINI",14)
@nLin,101  PSAY _nToEnt                               Picture PesqPict("SB9","B9_QINI",14)
@nLin,117  PSAY _nToSaida                             Picture PesqPict("SB9","B9_QINI",14)
@nLin,133  PSAY _nToSdoF  + _nQtEL + _nQtDiv          Picture PesqPict("SB9","B9_QINI",14)
@nLin,165  PSAY _nToVlEst + _nVlEl + _nVlDiv          Picture PesqPict("SB9","B9_QINI",18)

nLin++
@nLin,00  PSAY ""

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function ATUSX1()  //FUNวรO QUE CRIA PERGUNTAS NO SX1

cPerg := "PA0161"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros                         ณ
//ณ mv_par01        // Data de                  		         ณ
//ณ mv_par02        // Data ate  					       		 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

U_CRIASX1(cPerg,"01","Data Emissao De          ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,2     ,"G",""        ,"MV_PAR01",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""           ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Data Emissao Ate         ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,2     ,"G",""        ,"MV_PAR02",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""           ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"03","Produto De               ?",""       ,""      ,"mv_ch3","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR03",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""           ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
U_CRIASX1(cPerg,"04","Produto Ate              ?",""       ,""      ,"mv_ch4","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR04",""         ,""     ,""     ,""   ,""   ,""         ,""     ,""     ,""   ,""   ,""           ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")

Return