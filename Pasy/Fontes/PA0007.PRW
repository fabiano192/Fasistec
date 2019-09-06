#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Pa0007   บ Autor ณ Alexandro da Silva บ Data ณ  26/12/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio de Pedido de Compra                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Sigacom                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PA0007()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private _lFim
Private _cMsg01
Private _lAborta01
Private _bAcao01
Private _cTitulo01
Private   cString
Private   aOrd         := {}
Private   CbTxt        := ""
PRIVATE   cDesc1       := "Este programa tem como objetivo imprimir relatorio "
PRIVATE   cDesc2       := "de acordo com os parametros informados pelo usuario."
PRIVATE   cDesc3       := "Relacao de Pedido de Compra Emitido"
PRIVATE   cPict        := ""
Private   lEnd         := .F.
Private   lAbortPrint  := .F.
Private   Tamanho      := "P"
Private   nomeprog     := "PA0007"
Private   nTipo        := 15
Private   Cabec1       := ""
Private   Cabec2       := ""
Private   aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private   nLastKey     := 0
Private   cPerg        := "PA0007"
Private   nLin         := 80
Private   cbtxt        := Space(10)
Private   cbcont       := 00
Private   CONTFL       := 01
Private   m_pag        := 01
PRIVATE   imprime      := .T.
Private   wnrel        := "PA0007"
Private   cString      := "SC7"

/////////////////////////////////////////////
//// MV_PAR01  == Data De ?               ///
//// MV_PAR02  == Data Ate?               ///
//// MV_PAR03  == Pedido De ?             ///
//// MV_PAR04  == Pedido Ate?             ///
//// MV_PAR05  == Produto De?             ///
//// MV_PAR06  == Produto Ate?            ///
//// MV_PAR07  == Tipo De ?               ///
//// MV_PAR08  == Tipo Ate ?              ///
//// MV_PAR09  == Grupo De?               ///
//// MV_PAR10  == Grupo Ate?              ///
//// MV_PAR11  == Sintetico / Analitico ? ///
/////////////////////////////////////////////

Pergunte("PA0007",.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private titulo    := "Acumulado de Pedidos de Compra "


wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,tamanho,,.F.)

_lSintet := .T.

Private CabecA    := " Dia      Tipo   Grupo  Descricao do Grupo                       Valor        "
Private CabecB    := " Tipo Descricao do Tipo         Grupo Descricao do Grupo       Valor          "
Private limite    := 80

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)


nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o Arquivo Temporแrio                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If MV_PAR11 == 1 // Sintetico
	aStru := {}
	AADD(aStru,{"EMISSAO"  , "D" ,  8, 0 })
	AADD(aStru,{"TIPO"     , "C" ,  2, 0 })
	AADD(aStru,{"DESTIPO"  , "C" ,  30, 0 })
	AADD(aStru,{"GRUPO"    , "C" ,  4, 0 })
	AADD(aStru,{"DESGRUPO" , "C" ,  30, 0 })
	AADD(aStru,{"SUBGRUPO" , "C" ,  6, 0 })
	AADD(aStru,{"DESSUBGR" , "C" , 30, 0 })
	AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
	AADD(aStru,{"PEDIDO"   , "C" ,  6, 0 })
	AADD(aStru,{"ITEM"     , "C" ,  2, 0 })
	AADD(aStru,{"NOMEFOR"  , "C" , 40, 0 })
	AADD(aStru,{"VALOR"    , "N" , 17, 2 })
	
	cArqLOG := CriaTrab(aStru,.T.)
	cIndLOG := "TIPO"
	
	dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)
	dbSelectArea("TRB")
	IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")
	
	aRes := {}
	AADD(aRes,{"TIPO"     , "C" ,  2, 0 })
	AADD(aRes,{"DESTIPO"  , "C" ,  30, 0 })
	AADD(aRes,{"GRUPO"    , "C" ,  4, 0 })
	AADD(aRes,{"DESGRUPO" , "C" ,  30, 0 })
	AADD(aRes,{"VALOR"    , "N" ,  14, 2 })
	
	cArqRes := CriaTrab(aRes,.T.)
	cIndRes := "TIPO+GRUPO"
	dbUseArea(.T.,,cArqRes,"RES",.F.,.F.)
	dbSelectArea("RES")
	IndRegua("RES",cArqRes,cIndRes,,,"Criando Trabalho...")
	
	_lFim      := .F.
	_cMsg01    := ''
	_lAborta01 := .T.
	_bAcao01   := {|_lFim| GeraTrb(@_lFim) }
	_cTitulo01 := 'Processando'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
	_bAcao01   := {|_lFim| ImpTrb(@_lFim) }
	_cTitulo01 := 'Imprimindo'
	RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
	_bAcao01   := {|_lFim| ImpRes(@_lFim) }
	_cTitulo01 := 'Imprimindo Resumo'
	RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
	dbSelectArea("TRB")
	dbCloseArea("TRB")
	fErase(cArqLog+".DBF")
	FErase(cArqLog+OrdBagExt())
	
	dbSelectArea("RES")
	dbCloseArea("RES")
	
	fErase(cArqRes+".DBF")
	FErase(cArqRes+OrdBagExt())
	
Else   // Analitico
	aStru := {}
	AADD(aStru,{"EMISSAO"  , "D" ,  8, 0 })
	AADD(aStru,{"TIPO"     , "C" ,  2, 0 })
	AADD(aStru,{"DESTIPO"  , "C" ,  30, 0 })
	AADD(aStru,{"GRUPO"    , "C" ,  4, 0 })
	AADD(aStru,{"DESGRUPO" , "C" ,  30, 0 })
	AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
	AADD(aStru,{"DESPRODU" , "C" , 30, 0 })
	AADD(aStru,{"PEDIDO"   , "C" ,  6, 0 })
	AADD(aStru,{"ITEM"     , "C" ,  4, 0 })
	AADD(aStru,{"VALOR"    , "N" , 17, 2 })
	
	cArqLOG2 := CriaTrab(aStru,.T.)
	cIndLOG2 := "TIPO+GRUPO+DTOS(EMISSAO)+PEDIDO+PRODUTO"
	
	dbUseArea(.T.,,cArqLOG2,"ANA",.F.,.F.)
	dbSelectArea("ANA")
	IndRegua("ANA",cArqLog2,cIndLog2,,,"Criando Trabalho...")
	
	_lFim      := .F.
	_cMsg01    := ''
	_lAborta01 := .T.
	_bAcao01   := {|_lFim| GeraTrb2(@_lFim) }
	_cTitulo01 := 'Processando'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
	_bAcao01   := {|_lFim| ImpTrb2(@_lFim) }
	_cTitulo01 := 'Imprimindo'
	RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
	dbSelectArea("ANA")
	dbCloseArea("ANA")
	fErase(cArqLog2+".DBF")
	FErase(cArqLog2+OrdBagExt())
Endif


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณGeraTrb   บ Autor ณ Alexandro da Silva บ Data ณ  26/12/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraTrb(_lFim)


Local nOrdem

dbSelectArea("SC7")
dbSetOrder(5)
dbSeek(xFilial("SC7")+Dtos(MV_PAR01),.T.)

_nRec  := LastRec()
ProcRegua(_nRec)
_cTipo  := ""
_cGrupo := ""
_cSubGr := ""

While !Eof() .And. SC7->C7_EMISSAO <= MV_PAR02 .And. !_lFim
	
	IncProc()
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	_nValor   := 0
	
	If SC7->C7_NUM     <  MV_PAR03 .OR. SC7->C7_NUM     > MV_PAR04 .Or.;
		SC7->C7_PRODUTO <  MV_PAR05 .OR. SC7->C7_PRODUTO > MV_PAR06
		dbSelectArea("SC7")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+SC7->C7_PRODUTO)
		_cTipo  := SB1->B1_TIPO
		_cGrupo := SB1->B1_GRUPO
		_cSubGr := SB1->B1_SUBGR
	Else
		dbSelectArea("SC7")
		dbSkip()
		Loop
	Endif
	
	If _cTipo  <  MV_PAR07 .OR. _cTipo  > MV_PAR08 .Or.;
		_cGrupo <  MV_PAR09 .OR. _cGrupo > MV_PAR10
		dbSelectArea("SC7")
		dbSkip()
		Loop
	Endif
	
	_cDesTipo  := ""
	_cDesSubGr := ""
	_cDesGrupo := ""
	
	dbSelectArea("SX5")
	dbSetOrder(1)
	If dbSeek(xFilial("SX5")+"02"+_cTipo+space(4))
		_cDesTipo := SX5->X5_DESCRI
	Endif
	
	dbSelectArea("SX5")
	dbSetOrder(1)
	If dbSeek(xFilial("SX5")+"Z1"+_cSubGr)
		_cDesSubGr := SX5->X5_DESCRI
	Endif
	
	dbSelectArea("SBM")
	dbSetOrder(1)
	If dbSeek(xFilial("SBM")+ _cGrupo)
		_cDesGrupo := SBM->BM_DESC
	Endif
	
	If SC7->C7_RESIDUO == "S"
		_nValor := SC7->C7_QUJE * SC7->C7_PRECO
	Else
		_nValor := SC7->C7_TOTAL
	Endif
	
	dbSelectArea("TRB")
	If !dbSeek(DTOS(SC7->C7_EMISSAO) + _cTipo + _cGrupo + _cSubGr)
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->EMISSAO   := SC7->C7_EMISSAO
		TRB->TIPO      := _cTipo
		TRB->DESTIPO   := Substr(_cDesTipo,1,30)
		TRB->GRUPO     := _cGrupo
		TRB->DESGRUPO  := Substr(_cDesGrupo,1,30)
		TRB->SUBGRUPO  := _cSubGr
		TRB->DESSUBGR  := Substr(_cDesSubGr,1,30)
		TRB->VALOR     := _nValor
		MsUnLock()
	Else
		dbSelectArea("TRB")
		RecLock("TRB",.F.)
		TRB->VALOR  += _nValor
		MsUnLock()
	Endif
	
	dbSelectArea("RES")
	If !dbSeek(_cTipo+_cGrupo)
		dbSelectArea("RES")
		RecLock("RES",.T.)
		RES->TIPO     := _cTipo
		RES->DESTIPO  := Substr(_cDesTipo,1,25)
		RES->GRUPO    := _cGrupo
		RES->DESGRUPO := Substr(_cDesGrupo,1,25)
		RES->VALOR    := _nValor
		MsUnlock()
	Else
		dbSelectArea("RES")
		RecLock("RES",.F.)
		RES->VALOR  += _nValor
		MsUnlock()
	Endif
	
	dbSelectArea("SC7")
	dbSkip()
EndDo


Return


Static Function ImpTrb(_lFim)


/*
Analitico
Data     Pedido Fornecedor(29)               Valor Total      Valor Acumulado
99999999999999999999999999999999999999999999999999999999999999999999999999999999
1        10     17                           46               63




*/
dbSelectArea("TRB")
dbGotop()

_nQuebra  := TRB->TIPO
_nVlAcu   := 0
_nTotQuim := 0
_nTotVaz  := 0
_nTotDo   := 0
_nTotFerr := 0
_nTotInv  := 0
_nTotGer  := 0

SetRegua(RecCount())

If nLin > 55
	Cabec(Titulo,CabecA,Cabec2,NomeProg,"P",nTipo)
	nLin := 8
Endif

_nTotGer := 0
While !EOF() .And. !_lFim
	
	_dEmissao := TRB->EMISSAO
	_nVlEmis := 0
	
	@nLin,00 PSAY TRB->EMISSAO
	
	While !Eof() .And.  _dEmissao == TRB->EMISSAO
		_cTp     := TRB->TIPO
		_nVlTipo := 0
		
		If nLin > 55
			Cabec(Titulo,CabecA,Cabec2,NomeProg,"P",nTipo)
			nLin := 8
			@nLin,00 PSAY TRB->EMISSAO
			@nLin,10 PSAY TRB->TIPO
			@nLin,17 PSAY TRB->GRUPO
			@nLin,35 PSAY TRB->DESGRUPO
			nLin++
		Endif
		
		@nLin,10 PSAY TRB->TIPO
		@nLin,17 PSAY TRB->DESTIPO
		nLin ++
		
		While !Eof() .And. (_dEmissao == TRB->EMISSAO) .And. (_cTp == TRB->TIPO )
			_cGR     := TRB->GRUPO
			_nVlGrupo := 0
			
			If nLin > 55
				Cabec(Titulo,CabecA,Cabec2,NomeProg,"P",nTipo)
				nLin := 8
				@nLin,00 PSAY TRB->EMISSAO
				@nLin,10 PSAY TRB->TIPO
				@nLin,17 PSAY TRB->GRUPO
				@nLin,35 PSAY TRB->DESGRUPO
				nLin++
			Endif
			
			@nLin,17 PSAY TRB->GRUPO
			@nLin,24 PSAY TRB->DESGRUPO+ " --->"
			
			While !Eof() .And. (_dEmissao == TRB->EMISSAO) .And. ( _cTp == TRB->TIPO ) .And. _cGr == TRB->GRUPO
				
				IncRegua()
				
				If lAbortPrint
					@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
					Exit
				Endif
				
				_nVlGrupo  += TRB->VALOR
				_cGrup2    := TRB->GRUPO
				_cDesGrup2 := TRB->DESGRUPO
				_cTipo2    := TRB->TIPO
				_cDesTipo2 := TRB->DESTIPO
				_cEmissao2 := DTOC(TRB->EMISSAO)
				
				dbSelectArea("TRB")
				dbSkip()
			EndDo
			
			@nLin,65 PSAY _nVlGrupo         Picture "@E 999,999,999.99"
			nLin ++
			_nVlTipo   += _nVlGrupo
			
		EndDo
		
		nLin ++
		@nLin,10 PSAY "TOTAL DO TIPO: "+_cTipo2+" ( "+RTrim(_cDesTipo2)+" ) ---> "
		@nLin,65 PSAY _nVlTipo         Picture "@E 999,999,999.99"
		nLin +=2
		
		_nVlEmis += _nVlTipo
	EndDo
	
	@nLin,00 PSAY "TOTAL DO DIA: "+_cEmissao2+ " ---> "
	@nLin,65 PSAY _nVlEmis        Picture "@E 999,999,999.99"
	nLin ++
	@nLin,00 PSAY Replicate("-",80)
	nLin +=2
	
	_nTotGer += _nVlEmis
	
EndDo

@nLin,00 PSAY "TOTAL GERAL:  --->"
@nLin,65 PSAY _nTotGer        Picture "@E 999,999,999.99"

/*
Roda(cbCont,cbTxt,"P")


SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
dbCommitAll()
SET PRINTER TO
OurSpool(wnrel)
Endif

MS_FLUSH()
*/

Return


Static Function ImpRes(_lFim)


/*
Sint้tico
Tipo Descricao do Tipo         Grupo Descricao do Grupo          Valor
01234567890123456789012345678901234567890123456789012345678901234567890123456789
0    6                         32    38                          66
0        1         2         3         4         5         6         7         8

*/

nlin := 80
dbSelectArea("RES")
dbGotop()

SetRegua(RecCount())

If nLin > 55
	Cabec(Titulo,CabecB,Cabec2,NomeProg,"P",nTipo)
	nLin := 8
Endif

_nTotGer := 0
While !EOF() .And. !_lFim
	
	_cTp     := RES->TIPO
	_cDesTp  := RES->DESTIPO
	_nVlTipo := 0
	
	@nLin,00 PSAY _cTp
	@nLin,06 PSAY Substr(_cDesTp,1,25)
	nLin ++
	
	While !Eof() .And.  _cTp == RES->TIPO
		
		IncRegua()
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 55
			Cabec(Titulo,CabecB,Cabec2,NomeProg,"P",nTipo)
			nLin := 8
			@nLin,00 PSAY RES->TIPO
			@nLin,06 PSAY Substr(RES->DESTIPO,1,25)
			nLin++
		Endif
		
		@nLin,32 PSAY RES->GRUPO
		@nLin,38 PSAY Substr(RES->DESGRUPO,1,24)+ "-->"
		@nLin,66 PSAY RES->VALOR              Picture "@E 999,999,999.99"
		nLin ++
		_nVlTipo   += RES->VALOR
		
		dbSelectArea("RES")
		dbSkip()
		
	EndDo
	
	nLin ++
	@nLin,00 PSAY "TOTAL DO TIPO: "+_cTp+" ( "+RTrim(_cDesTp)+" ) --> "
	@nLin,66 PSAY _nVlTipo         Picture "@E 999,999,999.99"
	nLin +=2
	
	_nTotGer += _nVlTipo
EndDo

@nLin,00 PSAY "TOTAL GERAL:  -->"
@nLin,66 PSAY _nTotGer        Picture "@E 999,999,999.99"

Roda(cbCont,cbTxt,"P")


SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Static Function GeraTrb2(_lFim)


Local nOrdem

dbSelectArea("SC7")
dbSetOrder(5)
dbSeek(xFilial("SC7")+Dtos(MV_PAR01),.T.)

_nRec  := LastRec()
ProcRegua(_nRec)
_cTipo  := ""
_cGrupo := ""
_cSubGr := ""

While !Eof() .And. SC7->C7_EMISSAO <= MV_PAR02 .And. !_lFim
	
	IncProc()
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	_nValor   := 0
	
	If SC7->C7_NUM     <  MV_PAR03 .OR. SC7->C7_NUM     > MV_PAR04 .Or.;
		SC7->C7_PRODUTO <  MV_PAR05 .OR. SC7->C7_PRODUTO > MV_PAR06
		dbSelectArea("SC7")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+SC7->C7_PRODUTO)
		_cTipo     := SB1->B1_TIPO
		_cGrupo    := SB1->B1_GRUPO
		_cDescProd := Substr(SB1->B1_DESC,1,30)
	Else
		dbSelectArea("SC7")
		dbSkip()
		Loop
	Endif
	
	If _cTipo  <  MV_PAR07 .OR. _cTipo  > MV_PAR08 .Or.;
		_cGrupo <  MV_PAR09 .OR. _cGrupo > MV_PAR10
		dbSelectArea("SC7")
		dbSkip()
		Loop
	Endif
	
	_cDesTipo  := ""
	_cDesGrupo := ""
	
	dbSelectArea("SX5")
	dbSetOrder(1)
	If dbSeek(xFilial("SX5")+"02"+_cTipo+space(4))
		_cDesTipo := SX5->X5_DESCRI
	Endif
	
	dbSelectArea("SBM")
	dbSetOrder(1)
	If dbSeek(xFilial("SBM")+ _cGrupo)
		_cDesGrupo := SBM->BM_DESC
	Endif
	
	If SC7->C7_RESIDUO == "S"
		_nValor := SC7->C7_QUJE * SC7->C7_PRECO
	Else
		_nValor := SC7->C7_TOTAL
	Endif
	
	dbSelectArea("ANA")
	If !dbSeek(_cTipo + _cGrupo +DTOS(SC7->C7_EMISSAO) + SC7->C7_NUM + SC7->C7_PRODUTO)
		dbSelectArea("ANA")
		RecLock("ANA",.T.)
		ANA->TIPO      := _cTipo
		ANA->DESTIPO   := Substr(_cDesTipo,1,30)
		ANA->GRUPO     := _cGrupo
		ANA->DESGRUPO  := Substr(_cDesGrupo,1,30)
		ANA->EMISSAO   := SC7->C7_EMISSAO
		ANA->PRODUTO   := SC7->C7_PRODUTO
		ANA->DESPRODU  := _cDescProd
		ANA->PEDIDO    := SC7->C7_NUM
		ANA->ITEM      := SC7->C7_ITEM
		ANA->VALOR     := _nValor
		MsUnLock()
	Else
		dbSelectArea("ANA")
		RecLock("ANA",.F.)
		ANA->VALOR  += _nValor
		MsUnLock()
	Endif
	
	dbSelectArea("SC7")
	dbSkip()
EndDo


Return


Static Function ImpTrb2(_lFim)


/*
Data     Produto         Descricao Produto              Pedido Item        Valor
99999999 999999999999999 999999999999999999999999999999 999999 9999 999999999999
0        9               25                             56     63   68




*/
dbSelectArea("ANA")
dbGotop()

_nQuebra  := ANA->TIPO
_nVlAcu   := 0
_nTotQuim := 0
_nTotVaz  := 0
_nTotDo   := 0
_nTotFerr := 0
_nTotInv  := 0
_nTotGer  := 0

SetRegua(RecCount())

_nTotGer := 0
While !EOF() .And. !_lFim
	
	If nLin > 57
		Cabec(Titulo,CabecA,Cabec2,NomeProg,"P",nTipo)
		nLin := 9
	Endif
	
	_cTp     := ANA->TIPO
	_nVlTipo := 0
	
	@nLin,00 PSAY ANA->TIPO
	@nLin,09 PSAY ANA->DESTIPO
	nLin +=2
	
	While !Eof() .And. _cTp == ANA->TIPO
		
		If nLin > 57
			Cabec(Titulo,CabecA,Cabec2,NomeProg,"P",nTipo)
			nLin := 9
		Endif
		
		_cGR     := ANA->GRUPO
		_nVlGrupo := 0
		
		@nLin,00 PSAY ANA->GRUPO
		@nLin,24 PSAY ANA->DESGRUPO
		nLin+=2
		
		While !Eof() .And. ( _cTp == ANA->TIPO ) .And. _cGr == ANA->GRUPO
			
			IncRegua()
			
			If _lFim
				Return
			Endif
			
			If nLin > 57
				Cabec(Titulo,CabecA,Cabec2,NomeProg,"P",nTipo)
				nLin := 9
			Endif
			
			@nLin,00 PSAY ANA->EMISSAO
			@nLin,09 PSAY ANA->PRODUTO
			@nLin,25 PSAY ANA->DESPRODU
			@nLin,56 PSAY ANA->PEDIDO
			@nLin,63 PSAY ANA->ITEM
			@nLin,68 PSAY ANA->VALOR        Picture TM(ANA->VALOR,12)
			
			nLin++
			_nVlGrupo  += ANA->VALOR
			
			dbSelectArea("ANA")
			dbSkip()
		EndDo
		
		nLin++
		
		If nLin > 57
			Cabec(Titulo,CabecA,Cabec2,NomeProg,"P",nTipo)
			nLin := 9
		Endif
		
		@nLin,24 PSAY "TOTAL DO GRUPO ----> "+_cGr
		@nLin,68 PSAY _nVlGrupo         Picture TM(_nVlGrupo,12)
		
		nLin +=2
		_nVlTipo   += _nVlGrupo
		
	EndDo
	
	If nLin > 57
		Cabec(Titulo,CabecA,Cabec2,NomeProg,"P",nTipo)
		nLin := 9
	Endif
	
	@nLin,10 PSAY "TOTAL DO TIPO ----> "+_cTp
	@nLin,68 PSAY _nVlTipo         Picture TM(_nVlTipo,12)
	nLin +=2
	
	_nTotGer += _nVlTipo
	
EndDo

If nLin > 57
	Cabec(Titulo,CabecA,Cabec2,NomeProg,"P",nTipo)
	nLin := 9
Endif

@nLin,00 PSAY "TOTAL GERAL ----> "
@nLin,68 PSAY _nTotGer         Picture TM(_nTotGer,12)

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return