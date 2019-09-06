#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0035   ³ Autor ³ Alexandro da Silva    ³ Data ³ 01.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gerando Tabela Provisoria p/Marcos Pestana Das Vendas      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0095()

_aAliOri := GetArea()
Private _cDescPa := ""

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Gerando Tabela de Compras")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina criado para Gerar tabela de Compras"     SIZE 160,7
@ 18,18 SAY "dos Tapetes  conforme solicitacao.        "     SIZE 160,7
@ 26,18 SAY "Conforme Relacionamento com a Estrutura.  "     SIZE 160,7
@ 34,18 SAY "Programa PA0095.PRW (Tabela COMTAPETE.DBF)"     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0095")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered  //Valid Close(odlg)

If _nOpc == 1
	Proces()
Endif

Return


Static Function Proces()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| Proc1(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cArqNovo := "\RELATO\COMTAPETE.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo

dbCloseArea()

MsgInfo("Arquivo Processado Com Sucesso!!!!","INFO")


Return



Static Function Proc1(_lFim)

Pergunte("PA0095",.F.)

///////////////////////////////////////////
////// GRUPO DE PERGUNTAS /////////////////
///// MV_PAR01 - Emissao De  ?         ////
///// MV_PAR02 - Emissao Ate ?         ////
///// MV_PAR03 - Grupo De              ////
///// MV_PAR04 - Grupo Ate           . ////
///// MV_PAR05 - Produto De ?          ////
///// MV_PAR06 - produto Ate ?         ////
///// MV_PAR07 - Desc do Produto       ////
///// MV_PAR08 - Fornecedor De ?       ////
///// MV_PAR09 - Fornecedor Ate?       ////
///////////////////////////////////////////


Private _nNiv := 0
Private _lGravou := .F.

aStru := {}
AADD(aStru,{"DTENT"       , "D" , 08, 0 })
AADD(aStru,{"FORNECE"     , "C" , 06, 0 })
AADD(aStru,{"NOMEFOR"     , "C" , 40, 0 })
AADD(aStru,{"LOJA"        , "C" , 02, 0 })
AADD(aStru,{"PRODUTO"     , "C" , 15, 0 })
AADD(aStru,{"DESCPA"      , "C" , 40, 0 })
AADD(aStru,{"COMP"        , "C" , 15, 0 })
AADD(aStru,{"DESCMP"      , "C" , 40, 0 })
AADD(aStru,{"QTDEPA"      , "N" , 14, 4 })
AADD(aStru,{"QTDEMP"      , "N" , 14, 2 })
AADD(aStru,{"VLCOMPPA"    , "N" , 14, 2 })
AADD(aStru,{"VLUNITPA"    , "N" , 14, 2 })
AADD(aStru,{"PESOPROD"    , "N" , 14, 2 })
AADD(aStru,{"PESOMP"      , "N" , 14, 2 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "DTOS(DTENT)+FORNECE+LOJA+PRODUTO+COMP"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

dbSelectArea("SD1")
dbSetOrder(6)
dbSeek(xFilial("SD1")+Dtos(MV_PAR01),.T.)

ProcRegua(LastRec())

While !Eof() .And. SD1->D1_DTDIGIT <= MV_PAR02
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	IncProc()
	
	If  SD1->D1_GRUPO   < MV_PAR03 .Or. SD1->D1_GRUPO    > MV_PAR04 .Or.;
		SD1->D1_COD     < MV_PAR05 .Or. SD1->D1_COD      > MV_PAR06 .Or.;
		SD1->D1_FORNECE < MV_PAR08 .Or. SD1->D1_FORNECE  > MV_PAR09 .Or.;
		SD1->D1_TIPO != "N"
		dbSelectArea("SD1")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+SD1->D1_COD)
	
	If  !"TAPETE"  $ UPPER(SB1->B1_DESC) 
		dbSelectArea("SD1")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SF4")
	dbSetOrder(1)
	If dbSeek(xFilial("SF4")+SD1->D1_TES)
		If SF4->F4_DUPLIC != "S"
			dbSelectArea("SD1")
			dbSkip()
			Loop
		Endif
	Endif
	
	_lGravou := .F.
	_lVazado := .F.
	dbSelectArea("SG1")
	dbSetOrder(1)
	If dbSeek(xFilial("SG1")+SD1->D1_COD)
		
		_cProd   := SG1->G1_COD
		nNivel   := 2
		
		_nQtAnt :=  SD1->D1_QUANT
		_nSdoIni2 := 0
		
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+_cProd)
		_cDescPa := SB1->B1_DESC
		
		NECES(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
	Endif
	
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbseek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA)
	
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+SD1->D1_COD)
	
	If !_lVazado
		dbSelectArea("TRB")
		If !dbSeek(DTOS(SD1->D1_DTDIGIT)+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD)
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->NOMEFOR  := SA2->A2_NOME
			TRB->DTENT    := SD1->D1_DTDIGIT
			TRB->FORNECE  := SD1->D1_FORNECE
			TRB->LOJA     := SD1->D1_LOJA
			TRB->PRODUTO  := SD1->D1_COD
			TRB->DESCPA   := _cDescPa
			TRB->QTDEPA   := SD1->D1_QUANT
			TRB->VLCOMPPA := SD1->D1_TOTAL
			TRB->VLUNITPA := SD1->D1_VUNIT 
			TRB->PESOPROD := SB1->B1_PESO
			MsUNlock()
		Else
			dbSelectArea("TRB")
			RecLock("TRB",.F.)
			TRB->QTDEPA   += SD1->D1_QUANT
			TRB->VLCOMPPA += SD1->D1_TOTAL
			MsUnlock()
		Endif
	Endif
	
	dbSelectArea("SD1")
	dbSkip()
	
EndDo


Static Function NECES(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev)

Local _nReg := 0
Local _nRegTrb := 0
dbSelectArea("SG1")
dbSetOrder(1)
While !Eof() .And. SG1->G1_FILIAL + SG1->G1_COD == xFilial("SG1") + _cProd
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	_nReg := Recno()
	
	nQuantItem := ExplEstr(_nQtPai,,_cOpc,_cRev)
	dbSelectArea("SG1")
	dbSetOrder(1)
	
	If nQuantItem > 0
		
		_nNiv++
		
		dbSelectArea("SB1")
		aAreaSB1:=GetArea()
		
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+SG1->G1_COMP)
		_cDescMP := SB1->B1_DESC
		
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbseek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA)
		
		_lVazado := .t.
		RestArea(aAreaSB1)
		dbSelectArea("TRB")
		If !dbSeek(DTOS(SD1->D1_DTDIGIT)+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SG1->G1_COMP)
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->NOMEFOR  := SA2->A2_NOME
			TRB->DTENT    := SD1->D1_DTDIGIT
			TRB->FORNECE  := SD1->D1_FORNECE
			TRB->LOJA     := SD1->D1_LOJA
			TRB->PRODUTO  := SD1->D1_COD
			TRB->DESCPA   := _cDescPa
			TRB->COMP     := SG1->G1_COMP
			TRB->DESCMP   := _cDescMP
			TRB->PESOMP   := nQuantItem
			If !_lGravou
				TRB->QTDEPA   := SD1->D1_QUANT
				TRB->VLCOMPPA := SD1->D1_TOTAL
			Endif
			TRB->QTDEMP   := SD1->D1_QUANT * nQuantItem
			TRB->PESOPROD := (SD1->D1_QUANT * nQuantItem )
			MsUNlock()
		Else
			dbSelectArea("TRB")
			RecLock("TRB",.F.)
			If !_lGravou
				TRB->QTDEPA   += SD1->D1_QUANT
				TRB->VLCOMPPA += SD1->D1_TOTAL
			Endif
			MsUNlock()
		Endif
		_lGravou := .T.
		
		
		RestArea(aAreaSB1)
		
		dbSelectArea("SG1")
		dbSetOrder(1)
		dbSeek(xFilial("SG1")+SG1->G1_COMP)
		IF Found()
			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+SG1->G1_COD)
			NECES(SG1->G1_COD,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
		EndIf
		
		dbSelectArea("SG1")
		dbGoto(_nReg)
	Endif
	dbSkip()
EndDo

Return