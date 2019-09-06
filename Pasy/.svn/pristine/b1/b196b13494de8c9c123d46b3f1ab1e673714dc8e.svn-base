#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Pa0091    º Autor ³ Alexandro da Silva º Data ³  08/05/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programacao de Entrega CATERPILLAR Exportação              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0091()

Private _nPula,_lPrim,_cItem,_lAchou,_nPrcVen,_cNum,_lVerFat, _lIncSC6, _cPedido

Private _lIncSC6 := .F.
Private _nTotQt  := 0
Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := "Programacao de Entrega Periodo:"
Private cPict          := ""
Private titulo         := "Programacao de Entrega Periodo:"
Private nLin           := 80

Private Cabec1         := ""
Private Cabec2         := ""
Private imprime        := .T.
Private aOrd           := {}
Private lEnd           := .F.
Private lAbortPrint    := .F.
Private CbTxt          := ""
Private limite         := 132
Private tamanho        := "M"
Private nomeprog       := "PA0091"
Private nTipo          := 18
Private aReturn        := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey       := 0
Private cPerg          := "PA0062"
Private cbtxt          := Space(10)
Private cbcont         := 00
Private CONTFL         := 01
Private m_pag          := 01
Private wnrel          := "PA0091"
Private cString 	   := "SZ4"

dbSelectArea("SZ4")
dbSetOrder(1)

pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

If aReturn[4]==1
	nTipo := 15
	_nPula := 65
Else
	nTipo := 18
	_nPula := 57
Endif

Private _lNAchou   := .F.
Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| VerMov(@_lFim) }
Private _cTitulo01 := 'Imprimindo Inconsistencia'

RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_bAcao01   := {|_lFim| INTNOV(@_lFim) }
_cTitulo01 := 'Integrando Pedido   !!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_bAcao01   := {|_lFim| Imp1(@_lFim) }
_cTitulo01 := 'Imprimindo'
RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Return


Static Function VerMov()

///////////////////////////////////////////////
////// MV_PAR01    :  Data da Movimento   ? ///
///////////////////////////////////////////////

_lNAchou := .F.

aStru := {}
AADD(aStru,{"PRODCLI"  , "C" , 15, 0 })
cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "PRODCLI"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

dbSelectArea("SZ4")
dbSetOrder(4)
dbSeek(xFilial("SZ4")+DTOS(MV_PAR01),.t.)

ProcRegua(RecCount())

While !Eof() .And. SZ4->Z4_DTDIGIT == MV_PAR01
	
	IncProc()
	
	If SZ4->Z4_CODCLI != "000171"
		dbSelectArea("SZ4")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SZ2")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ2")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA+SZ4->Z4_PRODPAS+SZ4->Z4_PRODCLI)
		dbSelectArea("SZ4")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("TRB")
	If !dbSeek(SZ4->Z4_PRODCLI)
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->PRODCLI := SZ4->Z4_PRODCLI
		MsUnlock()
	Endif
	
	dbSelectArea("SZ4")
	dbSkip()
EndDo

Return
                                                   

Static Function INTNOV(_lFim)

dbSelectArea("SD2")
dbSEtOrder(9)
If dbSeek(xFilial("SD2")+"000171",.F.)
	
	_cChavSD2 := SD2->D2_CLIENTE
	
	ProcRegua(LastRec())
	
	While !Eof() .And. _cChavSD2 == SD2->D2_CLIENTE
		
		IncProc()
		
		dbSelectArea("SD2")
		RecLock("SD2",.F.)
		SD2->D2_PROGENT := 0
		MsUnLock()
		
		dbSelectArea("SD2")
		dbSkip()
	EndDo
Endif

Return



Static Function Imp1(_lFim)

dbSelectArea("TRB")
dbGotop()

ProcRegua(RecCount())

While !Eof()
	
	IncProc()
	
	If nLin > _nPula
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	_lNAchou := .T.
	
	@nLin,00  PSAY "Produto CLIENTE NAO DADASTRADO "+TRB->PRODCLI
	nLin++
	
	dbSelectArea("TRB")
	dbSkip()
EndDo


dbSelectArea("TRB")
dbCloseArea()

Private titulo         := "Programacao de Entrega Do Dia: "+DTOC(MV_PAR01)

/*
Data Mov Cliente  Lj Prod.Cliente    Prod.Pasy       Controle Dest Tp  Dt.Ult.Nf  Ult.NF.  Entrega   Quantidade    Pedido  Alt.Tec.
99999999 99999999 99 999999999999999 999999999999999 99999999 9999 99  999999999  9999999  99999999  999999999999  999999  99999999
0        9        18 21              37              53       62   67  71         82       91        101           115     123
*/
nLIn  := 80
cabec1:= "Data Mov Cliente  Lj Prod.Cliente    Prod.Pasy       Controle Dest Tp  Dt.Ult.Nf  Ult.NF.  Entrega   Quantidade    Pedido  Alt.Tec."
Cabec2:= ""


dbSelectArea("SZ4")
dbSetOrder(4)
dbSeek(xFilial("SZ4")+DTOS(MV_PAR01),.t.)

SetRegua(RecCount())

While !Eof() .And. SZ4->Z4_DTDIGIT == MV_PAR01
	
	_lPrim     := .F.
	_nTotQt    := 0
	_cItem     := "00"
	_cClieLoja := SZ4->Z4_CODCLI + SZ4->Z4_LOJA
	
	dbSelectArea("SZ4")
	
	While !Eof() .And.	_cClieLoja == SZ4->Z4_CODCLI + SZ4->Z4_LOJA
		
		If SZ4->Z4_CODCLI != "000171"
			dbSelectArea("SZ4")
			dbSkip()
			Loop
		Endif
		
		IncRegua()
		
		_cProdCli := SZ4->Z4_PRODCLI
		_nSubQt   := 0
		
		If SZ4->Z4_PRODPAS = "006815"
			_lParar := .T.
		Endif
		
		dbSelectArea("SZ2")
		dbSetOrder(1)
		If !dbSeek(xFilial("SZ2")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA+SZ4->Z4_PRODPAS+SZ4->Z4_PRODCLI+"1")
			dbSelectArea("SZ4")
			dbSkip()
			Loop
		Endif
		
		dDataRef := SZ2->Z2_DTREF01
		nValor   := SZ2->Z2_PRECO01
		For i := 2 to 12
			If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= dDataRef
				dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
				nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
			Endif
		Next i
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SZ4->Z4_PRODPAS)
		
		_nPerDes := 0
		
		If Substr(SZ4->Z4_PEDIDO,1,4) $ "QAPC/QAPP/QHPP"
			If SB1->B1_PICM == 12
				_nPerDes := Val(Tabela("Z8","12"))
			Else
				_nPerDes := Val(Tabela("Z8","18"))
			Endif
		Endif
		
		nValor   := nValor - (nValor * (_nPerDes/100))
		_nPrcVen := Round(nValor,5)
		
		If nLin > _nPula
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		@nLin,00  PSAY "Produdo Cliente "+SZ4->Z4_PRODCLI
		
		nLin+=2
		
		ZERAPED()
		
		dbSelectArea("SZ4")
		_lVerFat := .t.
		
		While !Eof() .And. _cProdCli == SZ4->Z4_PRODCLI
			
			If _lFim
				Alert("Cancelado Pelo Usuario!!!!!!")
				Return
			Endif
			
			IncRegua()
			
			If nLin > _nPula
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			INTSC6C()
			
			dbSelectArea("SZ4")
			RecLock("SZ4",.F.)
			SZ4->Z4_INTEGR := "S"
			SZ4->Z4_IMPRES := "S"
			MsUnlock()
			
			@nLin,00  PSAY SZ4->Z4_DTMOV
			@nLin,09  PSAY SZ4->Z4_CODCLI
			@nLin,18  PSAY SZ4->Z4_LOJA
			@nLin,21  PSAY SZ4->Z4_PRODCLI
			@nLin,37  PSAY SZ4->Z4_PRODPAS
			@nLin,53  PSAY SZ4->Z4_CONTROL
			@nLin,62  PSAY SZ4->Z4_LOCDEST
			@nLin,67  PSAY SZ4->Z4_TIPO
			@nLin,71  PSAY SZ4->Z4_DTULTNF
			@nLin,82  PSAY SZ4->Z4_ULTNF
			@nLin,91  PSAY SZ4->Z4_DTENT
			@nLin,101 PSAY SZ4->Z4_QTENT                    Picture Tm(SZ4->Z4_QTENT,12)
			@nLin,115 PSAY Substr(SZ4->Z4_PEDIDO,1,6)
			If SZ4->Z4_TPPED $ "1"
				_cTipo := "FIRME"
			ElseIf SZ4->Z4_TPPED == "3/4"
				_cTipo := "PREVISAO"
			Else
				_cTipo := "VERIFICAR"
			Endif
			
			@nLin,123 PSAY _cTipo
			
			_nSubQt += SZ4->Z4_QTENT
			
			nLin++
			
			dbSelectArea("SZ4")
			_nRecSz4 := Recno()
			dbSkip()
		EndDo

		dbSelectArea("SZ4")
		dbGoto(_nRecSZ4)
		
		ELIMR()
		
		dbSelectArea("SZ4")
		dbSkip()
		
		nLin+=2
		
		If nLin > _nPula
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		@nLin,00  PSAY "TotaL Do Produto "+_cProdCli
		@nLin,101 PSAY _nSubQt                    Picture Tm(_nSubQt,12)
		
		_nTotQt += _nSubQt
		
		nLin+=2
		
		dbSelectArea("SZ4")
	EndDo
	dbSelectArea("SZ4")
EndDo

nLin+=2

If nLin > _nPula
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

@nLin,53  PSAY "TotaL Geral "
@nLin,101 PSAY _nTotQt                    Picture Tm(_nTotQt,12)

dbSelectArea("SZ4")

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Static Function IntSC6C()

_nFatur := 0

If VAL(SZ4->Z4_ULTNF) > 0
	_cUltNf := SZ4->Z4_ULTNF +"01"
Else
	_cUltNf := "00000101"
Endif

dbSelectArea("SD2")
dbOrderNickName("INDSD26")
dbSeek(xFilial("SD2")+ SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + _cUltNf,.T.)

_cChav  := SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS

While !Eof () .And. _cChav == SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD
	
	If SD2->D2_DOC <= SZ4->Z4_ULTNF
		dbSelectArea("SD2")
		dbSkip()
		Loop
	Endif
	
	If SD2->D2_QUANT == SD2->D2_PROGENT
		dbSelectArea("SD2")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO + SD2->D2_ITEMPV)
		If Alltrim(SC6->C6_PEDCLI) != Alltrim(SZ4->Z4_PEDIDO)
			dbSelectArea("SD2")
			dbSkip()
			Loop
		Endif
	Endif
	
	_nFatur2 := _nFatur
	_nFatur  += SD2->D2_QUANT - SD2->D2_PROGENT
	
	If _nFatur >= SZ4->Z4_QTENT
		_nDif  := SZ4->Z4_QTENT - _nFatur2
	Else
		_nDif  := SD2->D2_QUANT - SD2->D2_PROGENT
	Endif
	
	dbSelectArea("SD2")
	RecLock("SD2",.F.)
	SD2->D2_PROGENT += _nDif
	MsUnlock()
	
	If _nFatur >= SZ4->Z4_QTENT
		Return
	Endif
	
	dbSelectArea("SD2")
	dbSkip()
EndDo

_lAchou   := .F.

dbSelectArea("SC6")
dbOrderNickName("INDSC61")
If dbSeek(xFilial("SC6")+ SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + SZ4->Z4_PRODCLI + DTOS(SZ4->Z4_DTENT))
	
	_cChavSC62 := SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + DTOS(SC6->C6_ENTREG)
	
	While !Eof() .And. 	_cChavSC62 == SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI + DTOS(SC6->C6_ENTREG)
		
		If (SC6->C6_QTDVEN == SC6->C6_QTDENT) .Or. !Empty(SC6->C6_BLQ)
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		If (SC6->C6_QTDVEN - SC6->C6_QTDENT) != SZ4->Z4_QTENT - _nFatur
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SC6")
		RecLock("SC6",.F.)
		SC6->C6_IDENCAT := SZ4->Z4_SEMATU
		If SZ4->Z4_TPPED = "1"
			SC6->C6_PEDAMOS := "N"
		Endif
		MsUnlock()
		
		_lAchou := .T.
		
		dbSelectArea("SC6")
		dbSkip()
	EndDo
Endif

If !_lAchou
	
	_lVerFat := .F.
	_cItem   := SomaIt(_cItem)
	
	If !_lPrim .Or. _cItem == "ZZ"
		_cItem  := "01"
		_cNum  := GETSXENUM("SC5","C5_NUM")
		CONFIRMSX8()
		_lPrim := .T.
		
		_cPedido := _cNum
		_lIncSC6 := .F.
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA)
				                     		
		dbSelectArea("SC5")
		RecLock("SC5",.T.)
		SC5->C5_FILIAL  := xFilial("SC5")
		SC5->C5_NUM     := _cNum
		SC5->C5_TIPO    := "N"
		SC5->C5_CLIENTE := SZ4->Z4_CODCLI
		SC5->C5_LOJAENT := SZ4->Z4_LOJA
		SC5->C5_LOJACLI := SZ4->Z4_LOJA
		SC5->C5_TRANSP  := SA1->A1_TRANSP
		SC5->C5_TIPOCLI := SA1->A1_TIPO
		SC5->C5_CONDPAG := SA1->A1_COND
		SC5->C5_TIPLIB  := "1"
		SC5->C5_VEND1   := SA1->A1_VEND
		SC5->C5_COMIS1  := SA1->A1_COMIS
		SC5->C5_EMISSAO := dDataBase
		SC5->C5_PESOL   := 1
		SC5->C5_MOEDA   := 1
		SC5->C5_TXMOEDA := 1
		SC5->C5_TPCARGA := "2"
        SC5->C5_PEDEXP  := _cNum
		MsUnlock()                                     
		                
		_cCondPgt :=""    
		_cDisPa   :=0
		dbselectArea("SY6")
		dbSetOrder(1)
		If dbSeek(xFilial("SY6")+SA1->A1_CONDPAG)
			_cCondPgt := SY6->Y6_COD   
			_cDisPa   := SY6->Y6_DIAS_PA
		Endif
		
		_cVia     := ""
		_cDestino := ""
		_cOrigem  := ""
		dbselectArea("SYR")
		dbSetOrder(1)
		If dbSeek(xFilial("SYR")+SA1->A1_DEST_1)            
			_cVia     := SYR->YR_VIA  
			_cDestino := SYR->YR_DESTINO
			_cOrigem  := SYR->YR_ORIGEM
		Endif	           
		
		dbselectArea("SA2")
		dbSetOrder(1)
		If dbSeek(xFilial("SA2")+"000211")            
			_cBairro  := Alltrim(SA2->A2_BAIRRO)
		    _cMun     := Alltrim(SA2->A2_MUN)
		    _cEst     := Alltrim(SA2->A2_EST)
		    _cCep     := Alltrim(SA2->A2_CEP)
		    _cEnd2    := SA2->A2_END
		Endif     
		
		dbselectArea("SA1")
		dbSetOrder(1)
		If dbSeek(xFilial("SA1")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA)            
		    _cEnd1    := SA1->A1_END
		    _cLoja    := SA1->A1_LOJA
		    _cNome    := SA1->A1_NOME
		    _cCodCli  := SA1->A1_COD
		    _cEnd1a   := EECMEND("SA1",1,SA1->A1_COD+SA1->A1_LOJA,.T.,,2)
		Endif     

		dbSelectArea("EE7")
		RecLock("EE7",.T.)
        EE7->EE7_AMOSTR := "2"
        EE7->EE7_BELOJA := "01"
        EE7->EE7_BENEDE := "PASY IND. E COM. DE BORRACHA E"
        EE7->EE7_BENEF  := "000211"
        EE7->EE7_BRUEMB := "1"  // Peso da Embalagem
        EE7->EE7_CALCEM := "1"  // sempre "Volume"
//      EE7->EE7_CODMAR := " // Aguardando...
        EE7->EE7_CONDPA := _cCondPgt
        EE7->EE7_DEST   := _cDestino
        EE7->EE7_DIASPA := _cDisPa
        EE7->EE7_DTPEDI := dDataBase
        EE7->EE7_DTPROC := dDataBase
        EE7->EE7_END2BE := _cBairro + " - " + _cMun + " - " + _cEst + " - Brazil - C.E.P " + _cCep
        EE7->EE7_END2IM := _cEnd1a
        EE7->EE7_ENDBEN := _cEnd2             
        EE7->EE7_ENDIMP := _cEnd1
        EE7->EE7_EXLIMP := "2"     
        EE7->EE7_FOLOJA := "01"
        EE7->EE7_FORN   := "000211"        
        EE7->EE7_FRPPCC := "CC"        
        EE7->EE7_IDIOMA := "INGLES-INGLES"              
        EE7->EE7_IMLOJA := _cLoja             
        EE7->EE7_IMPODE := _cNome                      
        EE7->EE7_IMPORT := _cCodCli                                                       
        EE7->EE7_INCOTE := "EXW"                                                               
        EE7->EE7_MOEDA  := "US$"                                                               
        EE7->EE7_MPGEXP := "003"                                                               
        EE7->EE7_ORIGEM := _cOrigem                                                               
        EE7->EE7_PEDFAT := _cNum    
        EE7->EE7_PEDIDO := _cNum                                                         
        EE7->EE7_PGTANT := "2"                                                               
        EE7->EE7_PRECOA := "1"         
        EE7->EE7_REFIMP := SZ4->Z4_PEDIDO
        EE7->EE7_RESPON := "TAVIS MASSAYUKI IWASAKI"                        
        EE7->EE7_STATUS := "B"
        EE7->EE7_STTDES := "AGUARDANDO FATURAMENTO"
        EE7->EE7_TIPCOM := "2"
        EE7->EE7_TIPCVL := "1"
        EE7->EE7_TIPTRA := "3"
//        EE7->EE7_         Qte Item
//        EE7->EE7_         Qte Pedido
        EE7->EE7_VIA    := _cVia                                
        EE7->EE7_DECQTD := 2                                
        EE7->EE7_DECPRC := 3                                
        EE7->EE7_DECPES := 2                                                        
        EE7->EE7_INTERM := "2"                                
        EE7->EE7_COND2  := _cCondPgt                          
        EE7->EE7_DIAS2  :=  _cDisPa                                              
		EE7->EE7_GPV    := "S"
		EE7->EE7_PEDATU := "S"        
		MsUnlock()                                     
	Endif
	
	dbSelectArea("SF4")
	dbSetOrder(1)
	dbSeek(xFilial("SF4")+SZ2->Z2_TES)
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SZ4->Z4_PRODPAS)
	
	dbSelectArea("SC6")
	RecLock("SC6",.T.)
	SC6->C6_FILIAL  := xFilial("SC6")
	SC6->C6_NUM     := _cNUm
	SC6->C6_ITEM    := _cItem
	SC6->C6_CPROCLI := SZ4->Z4_PRODCLI
	SC6->C6_PRODUTO := SZ4->Z4_PRODPAS
	SC6->C6_REVPED  := SZ4->Z4_ALTTEC
	SC6->C6_QTDVEN  := SZ4->Z4_QTENT - _nFatur
	SC6->C6_PRCVEN  := _nPrcVen
	SC6->C6_VALOR   := Round(( (SZ4->Z4_QTENT - _nFatur) * _nPrcVen ),2)
	SC6->C6_ENTREG  := SZ4->Z4_DTENT
	If SZ4->Z4_TPPED == "1"
		SC6->C6_PEDAMOS := "N"
	ElseIf SZ4->Z4_TPPED == "3"
		SC6->C6_PEDAMOS := "M"
	ElseIf SZ4->Z4_TPPED == "4"
		SC6->C6_PEDAMOS := "Z"
	Endif
	
	If SZ4->Z4_TIPO == "A"
		SC6->C6_PEDAMOS := "A"
	Endif
	
	SC6->C6_TES     := SZ2->Z2_TES
	
	If SA1->A1_EST == "SP"
		_cCf         := "5"
	ElseIf SA1->A1_EST == "EX"
		_cCf         := "7"
	Else
		_cCF         := "6"
	Endif
	SC6->C6_CF      := _cCf + Substr(SF4->F4_CF,2,3)
	SC6->C6_UM      := SB1->B1_UM
	SC6->C6_PEDCLI  := SZ4->Z4_PEDIDO
	SC6->C6_DESCRI  := SB1->B1_DESC
	SC6->C6_LOCAL   := SB1->B1_LOCPAD
	SC6->C6_CLI     := SZ4->Z4_CODCLI
	SC6->C6_LOJA    := SZ4->Z4_LOJA
	SC6->C6_PRUNIT  := _nPrcVen
	SC6->C6_TPOP    := "F"
	SC6->C6_IDENCAT := SZ4->Z4_SEMATU
	MsUnlock()
                   
    _nPosIPI := ""               
    _cUM     := ""
                                                                      
    dbSelectArea("SB1")
    dbSetOrder(1)
    If dbSeek (xFilial("SB1")+SZ4->Z4_PRODPAS)
    	_nPosIPI := SB1->B1_POSIPI
    	_cUM     := SB1->B1_UM
    Endif	
                                                       
    dbSelectArea("SZ2")
    dbSetOrder(1)         
    If dbSeek(xFilial("SZ2")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA+SZ4->Z4_PRODPAS)
    	_cPedCli := SZ2->Z2_PEDCLI
    	_cTes    := SZ2->Z2_TES
    Endif	
                          
    dbSelectArea("EE8")
	RecLock("EE8",.T.)
	EE8->EE8_COD_I  := SZ4->Z4_PRODPAS
//	EE8->EE8_DESC   :=         *****
	If SZ4->Z4_TPPED == "1"
		EE8->EE8_TIPPED := "N"
	ElseIf SZ4->Z4_TPPED == "3"
		EE8->EE8_TIPPED := "Z"
	ElseIf SZ4->Z4_TPPED == "4"
		EE8->EE8_TIPPED := "Z"
	Endif
	EE8->EE8_DTENTR := SZ4->Z4_DTENT
	EE8->EE8_CODCLI := SZ4->Z4_PRODCLI
	EE8->EE8_EMBAL1 := "MC1050"
	EE8->EE8_FABR   := "000211"
	EE8->EE8_FALOJA := "01"
	EE8->EE8_FATIT  := _cItem
	EE8->EE8_FOLOJA := "01"
	EE8->EE8_FORN   := "000211"
	EE8->EE8_PART_N := SZ4->Z4_PRODCLI
	EE8->EE8_PEDIDO := _cNUm
	EE8->EE8_POSIPI := _nPosIPI
	EE8->EE8_PRCINC := Round(( (SZ4->Z4_QTENT - _nFatur) * _nPrcVen ),2)
	EE8->EE8_PRCTOT := Round(( (SZ4->Z4_QTENT - _nFatur) * _nPrcVen ),2)
	EE8->EE8_PRECO  := _nPrcVen
	EE8->EE8_PRECOI := _nPrcVen	
	EE8->EE8_PSLQUN := 0.167	
	EE8->EE8_QE	    := SZ4->Z4_QTENT - _nFatur
	EE8->EE8_QTDEM1 := 1	
	EE8->EE8_REFCLI := _cPedCli
	EE8->EE8_SEQUEN := _cItem
	EE8->EE8_SLDATU := SZ4->Z4_QTENT - _nFatur
	EE8->EE8_SLDINI := SZ4->Z4_QTENT - _nFatur	       	
	EE8->EE8_UNPRC  := _cUM     	
	EE8->EE8_UNPES  := "KG"	       	
	EE8->EE8_UNIDAD := _cUM
	EE8->EE8_CF     := _cCf + Substr(SF4->F4_CF,2,3)
	EE8->EE8_TES    := _cTes
	MsUnlock()	
Endif

dbSelectArea("SZ4")

Return


Static Function ELIMR()

_cIdenCat := StrZero(Val(SZ4->Z4_SEMATU)-1,9)

dbSelectArea("SC6")
dbOrderNickName("INDSC61")
If dbSeek(xFilial("SC6")+SZ4->Z4_CODCLI+SZ4->Z4_LOJA+SZ4->Z4_PRODPAS + SZ4->Z4_PRODCLI)//+DTOS(SZ4->Z4_DTENT))
	
	_cChavSC6 := SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO //+ DTOS(SC6->C6_ENTREG)
	
	ProcRegua(LastRec())
	
	While !Eof() .And. _cChavSC6 == SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO //+ DTOS(SC6->C6_ENTREG)
		
		IncProc()
		
		If !Empty(SC6->C6_BLQ) .Or. SC6->C6_PEDAMOS == "D"
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		If SC6->C6_QTDVEN == SC6->C6_QTDENT
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		If	SC6->C6_IDENCAT == SZ4->Z4_SEMATU
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SC6->C6_PRODUTO)
		
		If SB1->B1_TIPO == "FR"
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		                        
		If Alltrim(SC6->C6_PEDCLI) != Alltrim(SZ4->Z4_PEDIDO)
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif

		dbSelectArea("SC6")
		RecLock("SC6",.F.)
		SC6->C6_BLQ     := "R"
		SC6->C6_XDTELIM := dDataBase
		SC6->C6_LOCALIZ := "PA0091"
		MsUnLock()
		                                       
		dbSelectarea("EE8")
        dbSetOrder(1)
        If dbSeek(xFilial("EE8")+SC6->C6_NUM+SC6->C6_ITEM)
			RecLock("EE8",.F.)
			dbDelete()
			MsUnlock()
        Endif
		
		dbSelectArea("SC6")
		dbSkip()
	EndDo
Endif


Return


Static Function ZeraPed()

dbSelectArea("SC6")
dbOrderNickName("INDSC61")
If dbSeek(xFilial("SC6")+ SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS + SZ4->Z4_PRODCLI )
	
	_cChavSC6 := SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI
	While !Eof() .And. 	_cChavSC6 == SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO + SC6->C6_CPROCLI
		
		If (SC6->C6_QTDVEN == SC6->C6_QTDENT) .Or. !Empty(SC6->C6_BLQ)
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SC6")
		RecLock("SC6",.F.)
		SC6->C6_IDENCAT := ""
		MsUnlock()
		
		dbSelectArea("SC6")
		dbSkip()
	EndDo
Endif

Return
