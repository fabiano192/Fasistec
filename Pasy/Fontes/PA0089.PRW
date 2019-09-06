#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0089   ³ Autor ³ Alexandro da Silva    ³ Data ³ 02.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gerando Tabela Provisoria p/ vENDAS com mp                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat (PAULO)                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0089()

_aAliOri := GetArea()
Private _cDescPa := ""
_lPAV    := .F.
_lPAC    := .f.
_lPAM    := .f.

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Gerando Tabela de Vendas")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina criado para Gerar tabela de Vendas "     SIZE 160,7
@ 18,18 SAY "dos produtos conforme solicitacao.        "     SIZE 160,7
@ 26,18 SAY "Conforme Relacionamento com a Estrutura.  "     SIZE 160,7
@ 34,18 SAY "Programa PA0089.PRW (Tabela PA0089.DBF)  "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0089")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

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

_cArqNovo := "\RELATO\PA0089.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo

dbCloseArea()

MsgInfo("Arquivo Processado Com Sucesso!!!!","INFO")


Return



Static Function Proc1(_lFim)

Pergunte("PA0089",.F.)

///////////////////////////////////////////
////// GRUPO DE PERGUNTAS /////////////////
///// MV_PAR01 - Emissao De  ?         ////
///// MV_PAR02 - Emissao Ate ?         ////
///// MV_PAR03 - Grupo De              ////
///// MV_PAR04 - Grupo Ate           . ////
///// MV_PAR05 - Produto De ?          ////
///// MV_PAR06 - produto Ate ?         ////
///// MV_PAR07 - Cliente De ?          ////
///// MV_PAR08 - Cliente Ate ?         ////
///////////////////////////////////////////


Private _nNiv := 0
Private _lGravou := .F.
aStru := {}
AADD(aStru,{"EMISSAO"     , "D" , 08, 0 })
AADD(aStru,{"CLIENTE"     , "C" , 06, 0 })
AADD(aStru,{"NOMECLI"     , "C" , 40, 0 })
AADD(aStru,{"LOJA"        , "C" , 02, 0 })
AADD(aStru,{"PRODUTO"     , "C" , 15, 0 })
AADD(aStru,{"PRODCLI"     , "C" , 15, 0 })
AADD(aStru,{"COMP"        , "C" , 15, 0 })
AADD(aStru,{"DESCPA"      , "C" , 40, 0 })
AADD(aStru,{"DESCMP"      , "C" , 40, 0 })
AADD(aStru,{"QTESTR"      , "N" , 14, 4 })
AADD(aStru,{"QTDVENPA"    , "N" , 12, 2 })
AADD(aStru,{"VLVENDPA"    , "N" , 12, 2 })
AADD(aStru,{"QTDVENMP"    , "N" , 12, 2 })
AADD(aStru,{"PRCPROD"     , "N" , 14, 2 })
AADD(aStru,{"VLVENDMP"    , "N" , 12, 2 })
_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "DTOS(EMISSAO)+CLIENTE+LOJA+PRODUTO+COMP"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

dbSelectArea("SD2")
dbSetOrder(5)
dbSeek(xFilial("SD2")+Dtos(MV_PAR01),.T.)

ProcRegua(LastRec())

While !Eof() .And. SD2->D2_EMISSAO <= MV_PAR02
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	IncProc()
	
	If SD2->D2_GRUPO    < MV_PAR03 .Or. SD2->D2_GRUPO    > MV_PAR04 .Or.;
		SD2->D2_COD     < MV_PAR05 .Or. SD2->D2_COD      > MV_PAR06 .Or.;
		SD2->D2_CLIENTE < MV_PAR07 .Or. SD2->D2_CLIENTE  > MV_PAR08 .Or.;
		SD2->D2_TIPO != "N"
		dbSelectArea("SD2")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SF4")
	dbSetOrder(1)
	If dbSeek(xFilial("SF4")+SD2->D2_TES)
		If SF4->F4_DUPLIC != "S"
			dbSelectArea("SD2")
			dbSkip()
			Loop
		Endif
	Endif
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbseek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
	
	_lGravou := .F.
	_lGrupo  := .F.
	_lPAV    := .F.
	_lPAC    := .f.
	_lPAM    := .f.
	dbSelectArea("SG1")
	dbSetOrder(1)
	If dbSeek(xFilial("SG1")+SD2->D2_COD)
		
		_cProd   := SG1->G1_COD
		nNivel   := 2
		
		_nQtAnt :=  SD2->D2_QUANT
		_nSdoIni2 := 0
		
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+_cProd)
		_cDescPa := SB1->B1_DESC

		If ALLTRIM(SB1->B1_GRUPO) == "PAM"
     		_lPAM := .T.
		ElseIf ALLTRIM(SB1->B1_GRUPO) == "PAV"
			_lPAV := .T.
		ElseIf ALLTRIM(SB1->B1_GRUPO) == "PAC"
			_lPAC := .T.
		Endif
		
		NECES(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
	Endif
	
	dbSelectArea("SD2")
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
		dbSeek(xFilial("SB1")+SG1->G1_COMP)
		_cDescMP := SB1->B1_DESC
				
		If _lPAM .And. ALLTRIM(SB1->B1_GRUPO) == "PIC"
			dbSelectArea("TRB")
			If !dbSeek(DTOS(SD2->D2_EMISSAO)+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SG1->G1_COMP)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PRODCLI  := SD2->D2_PROCLI
				TRB->NOMECLI  := SA1->A1_NOME
				TRB->EMISSAO  := SD2->D2_EMISSAO
				TRB->CLIENTE  := SD2->D2_CLIENTE
				TRB->LOJA     := SD2->D2_LOJA
				TRB->PRODUTO  := SD2->D2_COD
				TRB->COMP     := SG1->G1_COMP
				TRB->DESCPA   := _cDescPa
				TRB->DESCMP   := _cDescMP
				TRB->QTESTR   := nQuantItem
				If !_lGravou
					TRB->QTDVENPA := SD2->D2_QUANT
					TRB->VLVENDPA := SD2->D2_TOTAL
				Endif
				TRB->QTDVENMP :=  SD2->D2_QUANT * nQuantItem
				TRB->VLVENDMP := (SD2->D2_QUANT * nQuantItem )* SB1->B1_UPRC
				TRB->PRCPROD  := SB1->B1_UPRC
				MsUNlock()
			Else
				dbSelectArea("TRB")
				RecLock("TRB",.F.)
				If !_lGravou
					TRB->QTDVENPA += SD2->D2_QUANT
					TRB->VLVENDPA += SD2->D2_TOTAL
				Endif
				TRB->QTDVENMP += (SD2->D2_QUANT * nQuantItem)
				TRB->VLVENDMP += (SD2->D2_QUANT * nQuantItem)* SB1->B1_UPRC
				MsUNlock()
			Endif
		Endif
				
		If _lPAV .And. Substr(SB1->B1_COD,1,2) == "LP"
			dbSelectArea("TRB")
			If !dbSeek(DTOS(SD2->D2_EMISSAO)+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SG1->G1_COMP)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PRODCLI  := SD2->D2_PROCLI
				TRB->NOMECLI  := SA1->A1_NOME
				TRB->EMISSAO  := SD2->D2_EMISSAO
				TRB->CLIENTE  := SD2->D2_CLIENTE
				TRB->LOJA     := SD2->D2_LOJA
				TRB->PRODUTO  := SD2->D2_COD
				TRB->COMP     := SG1->G1_COMP
				TRB->DESCPA   := _cDescPa
				TRB->DESCMP   := _cDescMP
				TRB->QTESTR   := nQuantItem
				If !_lGravou
					TRB->QTDVENPA := SD2->D2_QUANT
					TRB->VLVENDPA := SD2->D2_TOTAL
				Endif
				TRB->QTDVENMP :=  SD2->D2_QUANT * nQuantItem
				TRB->VLVENDMP := (SD2->D2_QUANT * nQuantItem )* SB1->B1_UPRC
				TRB->PRCPROD  := SB1->B1_UPRC
				MsUNlock()
			Else
				dbSelectArea("TRB")
				RecLock("TRB",.F.)
				If !_lGravou
					TRB->QTDVENPA += SD2->D2_QUANT
					TRB->VLVENDPA += SD2->D2_TOTAL
				Endif
				TRB->QTDVENMP += (SD2->D2_QUANT * nQuantItem)
				TRB->VLVENDMP += (SD2->D2_QUANT * nQuantItem)* SB1->B1_UPRC
				MsUNlock()
			Endif
		Endif
		
		If _lPAC .And. Substr(SB1->B1_COD,1,2) == "CP"
			dbSelectArea("TRB")
			If !dbSeek(DTOS(SD2->D2_EMISSAO)+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SG1->G1_COMP)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PRODCLI  := SD2->D2_PROCLI
				TRB->NOMECLI  := SA1->A1_NOME
				TRB->EMISSAO  := SD2->D2_EMISSAO
				TRB->CLIENTE  := SD2->D2_CLIENTE
				TRB->LOJA     := SD2->D2_LOJA
				TRB->PRODUTO  := SD2->D2_COD
				TRB->COMP     := SG1->G1_COMP
				TRB->DESCPA   := _cDescPa
				TRB->DESCMP   := _cDescMP
				TRB->QTESTR   := nQuantItem
				If !_lGravou
					TRB->QTDVENPA := SD2->D2_QUANT
					TRB->VLVENDPA := SD2->D2_TOTAL
				Endif
				TRB->QTDVENMP :=  SD2->D2_QUANT * nQuantItem
				TRB->VLVENDMP := (SD2->D2_QUANT * nQuantItem )* SB1->B1_UPRC
				TRB->PRCPROD  := SB1->B1_UPRC
				MsUNlock()
			Else
				dbSelectArea("TRB")
				RecLock("TRB",.F.)
				If !_lGravou
					TRB->QTDVENPA += SD2->D2_QUANT
					TRB->VLVENDPA += SD2->D2_TOTAL
				Endif
				TRB->QTDVENMP += (SD2->D2_QUANT * nQuantItem)
				TRB->VLVENDMP += (SD2->D2_QUANT * nQuantItem)* SB1->B1_UPRC
				MsUNlock()
			Endif
		Endif
			
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
