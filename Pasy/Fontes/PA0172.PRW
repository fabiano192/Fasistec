#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0172   ³ Autor ³ Alexandro da Silva    ³ Data ³ 02.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gerando Tabela Provisoria p/ vENDAS com mp                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat (PAULO)                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0172()

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
@ 34,18 SAY "Programa PA0172.PRW (Tabela PA0172.DBF)  "     SIZE 160,7

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

_cArqNovo := "\SPOOL\PA0172.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo

dbCloseArea()

If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf

oExcelApp:= MsExcel():New()
oExcelApp:WorkBooks:Open("\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\SPOOL\PA0172.DBF" )
oExcelApp:SetVisible(.T.)


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
AADD(aStru,{"GRUPOPA"     , "C" , 04, 0 })
AADD(aStru,{"DESCPA"      , "C" , 40, 0 })
AADD(aStru,{"DESCMP"      , "C" , 40, 0 })
AADD(aStru,{"QTESTR"      , "N" , 14, 4 })
AADD(aStru,{"QTDVENPA"    , "N" , 12, 2 })
AADD(aStru,{"VLVENDPA"    , "N" , 12, 2 })
AADD(aStru,{"QTDVENMP"    , "N" , 12, 2 })
AADD(aStru,{"PRCPROD"     , "N" , 14, 2 })
AADD(aStru,{"VLVENDMP"    , "N" , 12, 2 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "PRODUTO+COMP"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")
    
_cQ := " SELECT * FROM "+RetSqlName("SD2")+" A "
_cQ += " INNER JOIN "+RetSqlName("SB1")+" B ON D2_COD=B1_COD "
_cQ += " INNER JOIN "+RetSqlName("SF4")+" C ON D2_TES=F4_CODIGO "
_cQ += " INNER JOIN "+RetSqlName("SA1")+" D ON D2_CLIENTE+D2_LOJA=A1_COD+A1_LOJA "
_cQ += " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND C.D_E_L_E_T_ = '' AND D.D_E_L_E_T_ = '' "
_cQ += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQ += " AND D2_TIPO = 'N' AND F4_DUPLIC = 'S' AND B1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_cQ += " AND D2_CLIENTE BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
_cQ += " AND D2_COD     BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
_cQ += " ORDER BY D2_COD "
                  
TCQUERY _cQ NEW ALIAS "ZZ"

TCSETFIELD("ZZ","D2_EMISSAO","D")

ProcRegua(U_CONTREG())

While !Eof() .And. !_lFim
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	IncProc()
	
	_lGravou := .F.
	_lGrupo  := .F.
	_lPAV    := .F.
	_lPAC    := .f.
	_lPAM    := .f.
	dbSelectArea("SG1")
	dbSetOrder(1)
	If dbSeek(xFilial("SG1")+ZZ->D2_COD)
		
		_cProd   := SG1->G1_COD
		nNivel   := 2
		
		_nQtAnt   := ZZ->D2_QUANT
		_nSdoIni2 := 0
		
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+_cProd)
		_cDescPa := SB1->B1_DESC
		
		_cGrupoPA := SB1->B1_GRUPO
		NECES(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
	Endif
	
	dbSelectArea("ZZ")
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
		
		If  ALLTRIM(SB1->B1_GRUPO) == "PIC"
			dbSelectArea("TRB")
			If !dbSeek(ZZ->D2_COD+SG1->G1_COMP)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PRODCLI  := ZZ->D2_PROCLI
				TRB->NOMECLI  := ZZ->A1_NOME
				TRB->EMISSAO  := ZZ->D2_EMISSAO
				TRB->CLIENTE  := ZZ->D2_CLIENTE
				TRB->LOJA     := ZZ->D2_LOJA
				TRB->PRODUTO  := ZZ->D2_COD
				TRB->COMP     := SG1->G1_COMP
				TRB->GRUPOPA  := _cGrupoPA
				TRB->DESCPA   := _cDescPa
				TRB->DESCMP   := _cDescMP
				TRB->QTESTR   := nQuantItem
				TRB->QTDVENPA := ZZ->D2_QUANT
				TRB->VLVENDPA := ZZ->D2_TOTAL
				TRB->QTDVENMP := ZZ->D2_QUANT * nQuantItem
				TRB->VLVENDMP := (ZZ->D2_QUANT * nQuantItem )* SB1->B1_UPRC
				TRB->PRCPROD  := SB1->B1_UPRC
				MsUNlock()
			Else
				dbSelectArea("TRB")
				RecLock("TRB",.F.)
				TRB->QTDVENPA += ZZ->D2_QUANT
				TRB->VLVENDPA += ZZ->D2_TOTAL
				TRB->QTDVENMP += (ZZ->D2_QUANT * nQuantItem)
				TRB->VLVENDMP += (ZZ->D2_QUANT * nQuantItem)* SB1->B1_UPRC
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