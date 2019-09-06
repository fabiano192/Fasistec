#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0113   ³ Autor ³ Alexandro da Silva    ³ Data ³ 21.12.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Produto Com Produto e Saldo nos Fases de Apontamento       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaCom                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ-±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0113()

LOCAL titulo      := "Acompanhamento de Producao"
LOCAL cDesc1      := "Este programa ira emitir a relacao dos Acumulados de Pedido,"
LOCAL cDesc2      := "Produto e Clientes e os saldos dos componentes na Estrutura "
LOCAL cDesc3      := "Conforme Parametros informados.                             "
LOCAL CbCont,cabec1,cabec2
tamanho     := "G"
Limite      := 132
cString     := "SC6"

PRIVATE aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }
PRIVATE nomeprog  := "PA0113"
PRIVATE aLinha    := { },nLastKey := 0
PRIVATE cPerg     := "PA0113"
PRIVATE cNumPed   := cNumCli := "", dData:=CtoD("  /  /  ")
Private _nQtdAcab := _nQtdPrep := _nQtdCQ := _nQtdExp :=  _nQtdLoc := _nQtdOP := 0
Private cArqLog

_cQtdCav := ""
cbtxt             := SPACE(10)
cbcont            := 0
li                := 80
m_pag             := 1


Pergunte("PA0113",.F.)

wnrel             := "PA0113"
aOrd              := {}

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

If nLastKey==27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

_lFim      := .F.
_cMsg01    := ''
_lAborta01 := .T.
_bAcao01   := {|_lFim| PA113A(@_lFim) }
_cTitulo01 := 'Processando'
RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_bAcao01   := {|_lFim| PA113B(@_lFim) }
_cTitulo01 := 'Imprimindo'
RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cArqNew :="PA0113.DBF"

dbSelectArea("TRB")
dbCloseArea()

/*                 
dbSelectArea("TRB")
dbCloseArea()
Copy all to &_cArqNew

*/
Ferase(cArqLog+".dbf")
Ferase(cArqLog+OrdbagExt())

Return


Static Function PA113A(_lFim)


//  PERGUNTE PA0113
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Emissao De                            ³
//³ mv_par02            // Emissao Ate                           ³
//³ mv_par03            // Do Produto                            ³
//³ mv_par04            // Ate o Produto                         ³
//³ mv_par05            // Do Cliente                            ³
//³ mv_par06            // Ate o cliente                         ³
//  mv_par07            // Loja     De                           ³
//  mv_par08            // Loja     Ate                          ³
//³ mv_par09            // Da entrega de entrega                 ³
//³ mv_par10            // Ate a data de entrega                 ³
//³ mv_par11            // Grupo De                              ³
//³ mv_par12            // Grupo Ate                             ³
//³ mv_par13            // SubGrupo De                           ³
//³ mv_par14            // SubGrupo Ate                          ³
//³ mv_par15            // Quais Pedidos                         ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

aStru := {}
AADD(aStru,{"CLIENTE"  , "C" ,  6, 0 })    // CLIENTE
AADD(aStru,{"LOJA"     , "C" , 02, 0 })    // LOJA
AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })    // PRODUTO PASY
AADD(aStru,{"DTENT"    , "D" ,  8, 0 })    // DATA DE ENTREGA PEDIDO
AADD(aStru,{"DTEMIS"   , "D" ,  8, 0 })    // DATA DE EMISSAO PEDIDO
AADD(aStru,{"QTDCAV"   , "C" , 03, 0 })    // QUANTIDADE DE CAVIDADE
AADD(aStru,{"MATUTIL"  , "C" , 15, 0 })    // MATERIAL UTILIZADO
AADD(aStru,{"INSERTO"  , "C" , 15, 0 })    // INSERTO METALICO
AADD(aStru,{"QTDPED"   , "N" , 14, 2 })    // QUANTIDADE PEDIDA
AADD(aStru,{"QTDPEND"  , "N" , 14, 2 })    // QUANTIDADE PENDENTE
AADD(aStru,{"QTDOP"    , "N" , 14, 2 })    // QUANTIDADE ORDEM DE PRODUÇÃO
AADD(aStru,{"QTDPREP"  , "N" , 14, 2 })    // SALDO NA PREPARACAO
AADD(aStru,{"QTDACAB"  , "N" , 14, 2 })    // SALDO NO ACABAMENTO
AADD(aStru,{"QTDCQ"    , "N" , 14, 2 })    // SALDO NO C.Q.
AADD(aStru,{"QTDEXP"   , "N" , 14, 2 })    // SALDO NA EXPEDICAO
AADD(aStru,{"QTDEND"   , "N" , 14, 2 })    // SALDO NO ENDERÇO
AADD(aStru,{"NUMEND"   , "C" , 15, 0 })    // NOME DO ENDERECO
AADD(aStru,{"QTDSOL"   , "N" , 14, 4 })    // SALDO À SOLICITAR
AADD(aStru,{"TIPMOV"   , "C" , 01, 0 })    // TIPO DE MOVIMENTO  1= Material Utilizado
// 2= Inserto Metalico
// 3=
cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "CLIENTE+LOJA+PRODUTO+DTOS(DTENT)+TIPMOV+NUMEND"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

dbSelectarea("SC6")
dbOrderNickName("INDSC64")
dbSeek(xFilial("SC6")+MV_PAR03,.T.)

SetRegua(RecCount())

While !Eof() .And. !_lFim .And. SC6->C6_PRODUTO <= MV_PAR04
	
	_cProduto := SC6->C6_PRODUTO
	
	dbSelectarea("SC6")
	dbOrderNickName("INDSC64")
	dbSeek(xFilial("SC6") + _cProduto + DTOS(MV_PAR09),.T.)
	
	_nQtdAcab := _nQtdPrep := _nQtdCQ := _nQtdExp := _nQtdLoc := 0
	_lPrim    := .T.
	_lEntrou  := .F.
	
	dbSelectArea("SC6")
	
	While !Eof() .And. !_lFim .And. _cProduto == SC6->C6_PRODUTO //.And. SC6->C6_ENTREG <= MV_PAR10
		
		_lEntrou := .T.
		IncRegua("Processando Pedido : "+SC6->C6_NUM+" ITEM: "+SC6->C6_ITEM)
		
		If _lFim
			Return
		Endif
		
		IF Alltrim(SC6->C6_BLQ) == "R"
			dbSelectArea("SC6")
			dbSkip()
			Loop
		EndIf

		IF SC6->C6_QTDENT == SC6->C6_QTDVEN
			dbSelectArea("SC6")
			dbSkip()
			Loop
		EndIF

		If SC6->C6_CLI   < MV_PAR05 .Or. SC6->C6_CLI  > MV_PAR06 .Or.;
			SC6->C6_LOJA < MV_PAR07 .Or. SC6->C6_LOJA > MV_PAR08 .Or. SC6->C6_ENTREG > MV_PAR10
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+SC6->C6_PRODUTO)
			If SB1->B1_GRUPO   <  MV_PAR11  .Or. SB1->B1_GRUPO  >  MV_PAR12 .Or.;
				SB1->B1_SUBGR  <  MV_PAR13  .Or. SB1->B1_SUBGR  >  MV_PAR14
				dbSelectArea("SC6")
				dbSkip()
				Loop
			Endif
		Endif
		
		_cQtdCav := SB1->B1_CAV
		
		dbSelectArea("SC5")
		dbSetOrder(1)
		If dbSeek(xFilial("SC5")+SC6->C6_NUM)
			If SC5->C5_EMISSAO <  MV_PAR01  .Or. SC5->C5_EMISSAO >  MV_PAR02
				dbSelectArea("SC6")
				dbSkip()
				Loop
			Endif
		Endif
		
		If SC5->C5_TIPO != "N"
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
/*		
		If MV_PAR15 == 1
			_cPed := "N"
		ElseIf MV_PAR15 == 2
			_cPed := "A"
		ElseIf MV_PAR15 == 3
			_cPed := "Z"
		ElseIf MV_PAR15 == 4
			_cPed := "D"
		Else
			_cPed := " /3/D/N/A/Z"
		Endif
		
		If !SC6->C6_PEDAMOS $ _cPed
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
*/
		_cPed := ""
		For Ax:= 1 To Len(MV_PAR15)
			If Substr(MV_PAR15,AX,1) != "*"
			   _cPed += Substr(MV_PAR15,AX,1)+ "/"
		    Endif
		Next AX         
		
		If !SC6->C6_PEDAMOS $ _cPed
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif		                                 
				
		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4")+SC6->C6_TES)
		
		If SF4->F4_DUPLIC != "S"
			dbSelectArea("SC6")
			dbSkip()
			Loop
		Endif
				
		nSaldo    := SC6->C6_QTDVEN-SC6->C6_QTDENT		
		_nQtdAcab := _nQtdPrep := _nQtdCQ := _nQtdExp := _nQtdLoc := _nQtdOP := 0     
		
		If _lPrim
			VerEstrut()
			VerOP()
			_lPrim := .F.
			
			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek(xFilial("SB2")+SC6->C6_PRODUTO+"98")    // C.Q.
				_nQtdCQ := SB2->B2_QATU
			Endif
			
			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek(xFilial("SB2")+SC6->C6_PRODUTO+"99")    // EXPEDICAO
				_nQtdExp := SB2->B2_QATU
			Endif
			
			dbSelectArea("SBF")
			dbOrderNickName("INDSBF1")
			If dbSeek(xFilial("SBF")+SC6->C6_PRODUTO+"99")    // LOCALIZACAO
				_cChavSBF := SBF->BF_PRODUTO + SBF->BF_LOCAL + SBF->BF_LOCALIZ
				
				While !Eof() .And. !_lFim .And.	_cChavSBF == SBF->BF_PRODUTO + SBF->BF_LOCAL + SBF->BF_LOCALIZ
					
					dbSelectArea("TRB")
					If !dbseek(SC6->C6_CLI+SC6->C6_LOJA + SC6->C6_PRODUTO+ DTOS(SC6->C6_ENTREG)+"1"+SBF->BF_LOCALIZ)
						dbSelectArea("TRB")
						RecLock("TRB",.T.)
						TRB->CLIENTE  := SC6->C6_CLI
						TRB->LOJA     := SC6->C6_LOJA
						TRB->PRODUTO  := SC6->C6_PRODUTO
						TRB->DTENT    := SC6->C6_ENTREG
						TRB->DTEMIS   := SC5->C5_EMISSAO
						TRB->QTDCAV   := _nQtCav
						TRB->NUMEND   := SBF->BF_LOCALIZ
						TRB->QTDEND   := SBF->BF_QUANT
						TRB->TIPMOV   := "1"
						TRB->QTDPED   := SC6->C6_QTDVEN
						TRB->QTDPEND  := SC6->C6_QTDVEN - SC6->C6_QTDENT
						TRB->QTDPREP  := _nQtdPrep
						TRB->QTDOP    := _nQtdOp
						TRB->QTDACAB  := _nQtdAcab
						TRB->QTDCQ    := _nQtdCQ
						TRB->QTDEXP   := _nQtdExp - _nQtdLoc
						MsUnlock()
					Else
						_cChavTRB := TRB->CLIENTE + TRB->LOJA + TRB->PRODUTO  + DTOS(TRB->DTENT)+"1"+SBF->BF_LOCALIZ
						While !Eof() .And. _cChavTRB == TRB->CLIENTE + TRB->LOJA + TRB->PRODUTO  + DTOS(TRB->DTENT)+"1" +TRB->NUMEND
							dbSelectArea("TRB")
							dbSkip()
						EndDo
						
						If _cChavTRB != TRB->CLIENTE + TRB->LOJA + TRB->PRODUTO  + DTOS(TRB->DTENT)+"1"+TRB->NUMEND
							dbSelectArea("TRB")
							RecLock("TRB",.T.)
							TRB->CLIENTE  := SC6->C6_CLI
							TRB->LOJA     := SC6->C6_LOJA
							TRB->PRODUTO  := SC6->C6_PRODUTO
							TRB->DTENT    := SC6->C6_ENTREG
							TRB->DTEMIS   := SC5->C5_EMISSAO
							TRB->QTDCAV   := _nQtCav
							TRB->NUMEND   := SBF->BF_LOCALIZ
							TRB->QTDEND   := SBF->BF_QUANT
							TRB->TIPMOV   := "1"            
							TRB->QTDPED   := SC6->C6_QTDVEN
							TRB->QTDPEND  := SC6->C6_QTDVEN - SC6->C6_QTDENT
							TRB->QTDPREP  := _nQtdPrep
							TRB->QTDACAB  := _nQtdAcab
							TRB->QTDOP    := _nQtdOp
							TRB->QTDCQ    := _nQtdCQ
							TRB->QTDEXP   := _nQtdExp - _nQtdLoc
							MsUnlock()
						Else
							dbSelectArea("TRB")
							RecLock("TRB",.F.)
							TRB->NUMEND   := SBF->BF_LOCALIZ
							TRB->QTDEND   := SBF->BF_QUANT
							MsUnlock()
						Endif
					Endif                    
					_nQtdAcab := _nQtdPrep := _nQtdCQ := _nQtdExp := _nQtdOp :=0     
					_nQtdLoc += SBF->BF_QUANT
					
					dbSelectArea("SBF")
					dbSkip()
				EndDo
			Endif				
		Endif
		
		dbSelectArea("TRB")
		If dbseek(SC6->C6_CLI+SC6->C6_LOJA + SC6->C6_PRODUTO+ DTOS(SC6->C6_ENTREG)+"1")
			dbSelectArea("TRB")
			RecLock("TRB",.F.)
			TRB->QTDPED   += SC6->C6_QTDVEN
			TRB->QTDPEND  += SC6->C6_QTDVEN - SC6->C6_QTDENT
			TRB->QTDPREP  += _nQtdPrep
			TRB->QTDACAB  += _nQtdAcab
			TRB->QTDCQ    += _nQtdCQ                                           
			TRB->QTDOP    := _nQtdOp
			TRB->QTDEXP   += _nQtdExp - _nQtdLoc
			MsUnlock()
		Else
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->CLIENTE  := SC6->C6_CLI
			TRB->LOJA     := SC6->C6_LOJA
			TRB->PRODUTO  := SC6->C6_PRODUTO
			TRB->DTENT    := SC6->C6_ENTREG
			TRB->DTEMIS   := SC5->C5_EMISSAO
			TRB->QTDCAV   := _cQtdCav
			TRB->TIPMOV   := "1"
			TRB->QTDPED   := SC6->C6_QTDVEN
			TRB->QTDPEND  := SC6->C6_QTDVEN - SC6->C6_QTDENT
			TRB->QTDPREP  := _nQtdPrep
			TRB->QTDACAB  := _nQtdAcab
			TRB->QTDCQ    := _nQtdCQ
			TRB->QTDOP    := _nQtdOp
			TRB->QTDEXP   := _nQtdExp - _nQtdLoc
			MsUnlock()
		Endif
		
		dbSelectArea("SC6")
		dbSkip()
	EndDo
	
	If !_lEntrou
		dbSelectArea("SC6")
		dbSkip()
	Endif
EndDo


Static Function VerEstrut()


dbSelectArea("SG1")
dbSetOrder(1)
If dbSeek(xFilial("SG1")+SC6->C6_PRODUTO)
	
	_cProd   := SG1->G1_COD
	nNivel   := 2
	
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+_cProd)
	
	NECESC6(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
	
Endif

Return


Static Function NECESC6(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev)

Local _nReg := 0
Local _nRegTrb := 0
dbSelectArea("SG1")
dbSetOrder(1)
While !Eof() .And. SG1->G1_FILIAL + SG1->G1_COD == xFilial("SG1") + _cProd
	
	_nReg := Recno()
	
	nQuantItem := ExplEstr(_nQtPai,,_cOpc,_cRev)
	dbSelectArea("SG1")
	dbSetOrder(1)
	
	If nQuantItem > 0
		
		dbSelectArea("SB1")
		aAreaSB1:=GetArea()
		dbSeek(xFilial("SB1")+SG1->G1_COMP)
		
		_nRegTRb := Recno()
		
		If SB1->B1_LOCPAD $ "20" //Acabamento
			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD)
				_nQtdAcab += SB2->B2_QATU
			Endif
		ElseIf SB1->B1_LOCPAD $ "15" // PULMAO
			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD)
				_nQtdPrep += SB2->B2_QATU
			Endif
		Endif
		
		If SB1->B1_GRUPO $ "PIC /MPVZ/MPC "   // Material Utilizado
			dbSelectArea("TRB")
			If !dbseek(SC6->C6_CLI+SC6->C6_LOJA + SC6->C6_PRODUTO+ DTOS(SC6->C6_ENTREG)+"1")
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->CLIENTE  := SC6->C6_CLI
				TRB->LOJA     := SC6->C6_LOJA
				TRB->PRODUTO  := SC6->C6_PRODUTO
				TRB->DTENT    := SC6->C6_ENTREG
				TRB->DTEMIS   := SC5->C5_EMISSAO
				TRB->QTDCAV   := _cQtdCav
				TRB->MATUTIL  := SG1->G1_COMP
				TRB->TIPMOV   := "1"
				MsUnlock()
			Else
				_cChavTRB := TRB->CLIENTE + TRB->LOJA + TRB->PRODUTO  + DTOS(TRB->DTENT)+"1"
				While !Eof() .And. _cChavTRB == TRB->CLIENTE + TRB->LOJA + TRB->PRODUTO  + DTOS(TRB->DTENT)+"1" .And. !Empty(TRB->MATUTIL)
					dbSelectArea("TRB")
					dbSkip()
				EndDo
				
				If _cChavTRB != TRB->CLIENTE + TRB->LOJA + TRB->PRODUTO  + DTOS(TRB->DTENT)+"1"
					dbSelectArea("TRB")
					RecLock("TRB",.T.)
					TRB->CLIENTE  := SC6->C6_CLI
					TRB->LOJA     := SC6->C6_LOJA
					TRB->PRODUTO  := SC6->C6_PRODUTO
					TRB->DTENT    := SC6->C6_ENTREG
					TRB->DTEMIS   := SC5->C5_EMISSAO
					TRB->QTDCAV   := _cQtdCav
					TRB->MATUTIL  := SG1->G1_COMP
					TRB->TIPMOV   := "1"
					MsUnlock()
				Else
					dbSelectArea("TRB")
					RecLock("TRB",.F.)
					TRB->MATUTIL := SG1->G1_COMP
					MsUnlock()
				Endif
			Endif
		ElseIf SB1->B1_GRUPO $  "MPIM/PIPM"   // PRE FORMADO / INSERTO  METALICO
			dbSelectArea("TRB")
			If !dbseek(SC6->C6_CLI+SC6->C6_LOJA + SC6->C6_PRODUTO+ DTOS(SC6->C6_ENTREG)+"1")
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->CLIENTE  := SC6->C6_CLI
				TRB->LOJA     := SC6->C6_LOJA
				TRB->PRODUTO  := SC6->C6_PRODUTO
				TRB->DTENT    := SC6->C6_ENTREG
				TRB->DTEMIS   := SC5->C5_EMISSAO
				TRB->QTDCAV   := _cQtdCav
				TRB->INSERTO  := SG1->G1_COMP
				TRB->TIPMOV   := "1"
				MsUnlock()
			Else
				_cChavTRB := TRB->CLIENTE + TRB->LOJA + TRB->PRODUTO  + DTOS(TRB->DTENT)+"1"
				While !Eof() .And. _cChavTRB == TRB->CLIENTE + TRB->LOJA + TRB->PRODUTO  + DTOS(TRB->DTENT)+"1" .And. !Empty(TRB->INSERTO)
					dbSelectArea("TRB")
					dbSkip()
				EndDo
				
				If _cChavTRB != TRB->CLIENTE + TRB->LOJA + TRB->PRODUTO  + DTOS(TRB->DTENT)+"1"
					dbSelectArea("TRB")
					RecLock("TRB",.T.)
					TRB->CLIENTE  := SC6->C6_CLI
					TRB->LOJA     := SC6->C6_LOJA
					TRB->PRODUTO  := SC6->C6_PRODUTO
					TRB->DTENT    := SC6->C6_ENTREG
					TRB->DTEMIS   := SC5->C5_EMISSAO
					TRB->QTDCAV   := _cQtdCav
					TRB->INSERTO  := SG1->G1_COMP
					TRB->TIPMOV   := "1"
					MsUnlock()
				Else
					dbSelectArea("TRB")
					RecLock("TRB",.F.)
					TRB->INSERTO := SG1->G1_COMP
					MsUnlock()
				Endif
			Endif
		Endif
		
		RestArea(aAreaSB1)
		
		dbSelectArea("SG1")
		dbSetOrder(1)
		dbSeek(xFilial("SG1")+SG1->G1_COMP)
		IF Found()
			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+SG1->G1_COD)
			
			NECESC6(SG1->G1_COD,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
		EndIf
		
		dbSelectArea("SG1")
		dbGoto(_nReg)
		
		dbSelectArea("SG1")
	Endif
	dbSkip()
EndDo

Return


Static Function Pa113B(_lFim)


/*
Cliente Lj Produto Pasy    Quant de   Emissao  Data De  Material        Inserto         Quantidade  Quantidade    Solicit.    Saldo no    Saldo no    Saldo no    Saldo na  Quantidade  Nome do Endereco            Saldo a
	                       Cavidade   Pedido   Entrega  Utilizado       Metalico        Ped. Venda  Pendente     Efetuadas      Pulmao  Acabamento        C.Q.   Expedicao  Enderecada                            Solicitar
9999999 99 999999999999999 9999999999 99999999 99999999 999999999999999 999999999999999 9999999999  9999999999  9999999999  9999999999  9999999999  9999999999  9999999999  9999999999  999999999999999999999999 9999999999
0       8  11              27         38       47       56              72              88          100         112         124         136         148         160         172         184                      209
*/

nTipo  := IIF(aReturn[4]==1,15,18)
li     := 80
Titulo := "Acompanhamento da Producao Periodo "+DTOC(MV_PAR01)+ " A "+DTOC(MV_PAR02)
Cabec1 := "Cliente Lj Produto Pasy    Quant de   Emissao  Data De  Material        Inserto         Quantidade  Quantidade    Solicit.    Saldo no    Saldo no    Saldo no    Saldo na  Quantidade  Nome do Endereco            Saldo a"
Cabec2 := "                           Cavidade   Pedido   Entrega  Utilizado       Metalico        Ped. Venda  Pendente     Efetuadas      Pulmao  Acabamento        C.Q.   Expedicao  Enderecada                            Solicitar"

dbSelectArea("TRB")
dbGotop()

SetRegua(LastRec())

While !Eof() .And. !_lFim
	
	_cChavTrb := TRB->CLIENTE + TRB->LOJA + TRB->PRODUTO
	_nSdoSol  := 0
	
	While !Eof() .And. !_lFim  .And. _cChavTrb == TRB->CLIENTE + TRB->LOJA + TRB->PRODUTO
		If _lFim
			Alert("Cancelado Pelo Usuario!!")
			Return
		Endif
		
		IncRegua("Imprimindo....")
		
		IF li > 62
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		             
		_nSdoSol += TRB->QTDPED -TRB->QTDOP - TRB->QTDPREP - TRB->QTDACAB - TRB->QTDCQ - TRB->QTDEXP - TRB->QTDEND
		
		@Li, 00  PSay TRB->CLIENTE
		@Li, 08  PSay TRB->LOJA
		@Li, 11  Psay TRB->PRODUTO
		@Li, 27  Psay TRB->QTDCAV
		@Li, 38  Psay TRB->DTEMIS
		@Li, 47  Psay TRB->DTENT
		@Li, 56  Psay TRB->MATUTIL
		@Li, 72  Psay TRB->INSERTO
		@Li, 88  Psay TRB->QTDPED           Picture TM(TRB->QTDPED,10)
		@Li, 100 Psay TRB->QTDPEND          Picture TM(TRB->QTDPEND,10)
		@Li, 112 Psay TRB->QTDOP            Picture TM(TRB->QTDOP,10)
		@Li, 124 Psay TRB->QTDPREP          Picture TM(TRB->QTDPREP,10)
		@Li, 136 Psay TRB->QTDACAB          Picture TM(TRB->QTDACAB,10)
		@Li, 148 Psay TRB->QTDCQ            Picture TM(TRB->QTDCQ,10)
		@Li, 160 Psay TRB->QTDEXP           Picture TM(TRB->QTDEXP,10)
		@Li, 172 PSay TRB->QTDEND           Picture TM(TRB->QTDEND,10)
		@Li, 184 PSay TRB->NUMEND
//		@Li, 209 PSay 0                     Picture TM(0,10)
		
		Li++
		dbSelectArea("TRB")
		dbSkip()
	EndDo                                                             
	                                                              
	LI--
	@Li, 209 PSay _nSdoSol           Picture TM(_nSdoSol,10)
	Li++	
	
	@Li, 000 PSay Repl("-",220)
	li++
EndDo

li++

If aReturn[5] = 1
	Set Printer to
	dbCommit()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return



Static Function VerOp()

dbSelectArea("SC2")
dbSetOrder(2)
If dbSeek(xFilial("SC2")+SC6->C6_PRODUTO)

	_cChavSC2 := SC2->C2_PRODUTO
	
	While !Eof() .And.	_cChavSC2 == SC2->C2_PRODUTO
	
		If SC2->C2_QUJE == SC2->C2_QUANT
			dbSelectArea("SC2")
			dbSkip()
			Loop
		Endif                                                                  
		
		If SC2->C2_TPOP == "P"
			dbSelectArea("SC2")
			dbSkip()
			Loop
		Endif                                                                  
				
		_nQtdOp += SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA
		
		dbSelectArea("SC2")
		dbSkip()
	EndDo

Endif			

Return