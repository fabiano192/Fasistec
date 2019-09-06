#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/                                 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0134   ³ Autor ³ Alexandro da Silva    ³ Data ³ 03.06.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gerando Tabela Provisoria                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0134()

_aAliOri := GetArea()

Private _cDescPa := _cGrPa   := ""

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Gerando Tabela de Vendas")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina criado para Gerar tabela de Vendas "     SIZE 160,7
@ 18,18 SAY "dos produtos conforme solicitacao.        "     SIZE 160,7
@ 26,18 SAY "Conforme Relacionamento com a Estrutura.  "     SIZE 160,7
@ 34,18 SAY "Programa PA0134.PRW \RELATO\PA0134.DBF    "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0035")
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

_cArqNovo := "\RELATO\PA0134.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo

dbCloseArea()
                 
dbSelectArea("ZD2")
dbCloseArea()

If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "F:\AP7\AP_DATA\RELATO\PA0134.DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

MsgInfo("Arquivo Processado Com Sucesso!!!!","INFO")

Return


Static Function Proc1(_lFim)

Pergunte("PA0035",.F.)

///////////////////////////////////////////
////// GRUPO DE PERGUNTAS /////////////////
///// MV_PAR01 - Emissao De  ?         ////
///// MV_PAR02 - Emissao Ate ?         ////
///// MV_PAR03 - Grupo De              ////
///// MV_PAR04 - Grupo Ate           . ////
///// MV_PAR05 - Produto De ?          ////
///// MV_PAR06 - produto Ate ?         ////
///// MV_PAR07 - Grupo do Componente   ////
///// MV_PAR08 - Cliente De ?          ////
///// MV_PAR09 - Cliente Ate ?         ////
///////////////////////////////////////////

Private _nNiv := 0
Private _lGravou := .F.

aStru := {}
AADD(aStru,{"PRODUTO", "C" , 15, 0 })
AADD(aStru,{"GRUPOPA", "C" , 04, 0 })
AADD(aStru,{"CODCOM1", "C" , 15, 0 })
AADD(aStru,{"QTDCOM1", "N" , 14, 6 })
AADD(aStru,{"VLRCOM1", "N" , 14, 6 })
AADD(aStru,{"CODCOM2", "C" , 15, 0 })
AADD(aStru,{"QTDCOM2", "N" , 14, 6 })
AADD(aStru,{"VLRCOM2", "N" , 14, 6 })
AADD(aStru,{"CODCOM3", "C" , 15, 0 })
AADD(aStru,{"QTDCOM3", "N" , 14, 6 })
AADD(aStru,{"VLRCOM3", "N" , 14, 6 })
AADD(aStru,{"CODCOM4", "C" , 15, 0 })
AADD(aStru,{"QTDCOM4", "N" , 14, 6 })
AADD(aStru,{"VLRCOM4", "N" , 14, 6 })
AADD(aStru,{"CODCOM5", "C" , 15, 0 })
AADD(aStru,{"QTDCOM5", "N" , 14, 6 })
AADD(aStru,{"VLRCOM5", "N" , 14, 6 })
AADD(aStru,{"CODCOM6", "C" , 15, 0 })
AADD(aStru,{"QTDCOM6", "N" , 14, 6 })
AADD(aStru,{"VLRCOM6", "N" , 14, 6 })
AADD(aStru,{"CODINS1", "C" , 15, 0 })
AADD(aStru,{"QTDINS1", "N" , 14, 6 })
AADD(aStru,{"VLRINS1", "N" , 14, 6 })
AADD(aStru,{"CODINS2", "C" , 15, 0 })
AADD(aStru,{"QTDINS2", "N" , 14, 6 })
AADD(aStru,{"VLRINS2", "N" , 14, 6 })
AADD(aStru,{"CODINS3", "C" , 15, 0 })
AADD(aStru,{"QTDINS3", "N" , 14, 6 })
AADD(aStru,{"VLRINS3", "N" , 14, 6 })
AADD(aStru,{"CODINS4", "C" , 15, 0 })
AADD(aStru,{"QTDINS4", "N" , 14, 6 })
AADD(aStru,{"VLRINS4", "N" , 14, 6 })
AADD(aStru,{"CODINS5", "C" , 15, 0 })
AADD(aStru,{"QTDINS5", "N" , 14, 6 })
AADD(aStru,{"VLRINS5", "N" , 14, 6 })
AADD(aStru,{"CODINS6", "C" , 15, 0 })
AADD(aStru,{"QTDINS6", "N" , 14, 6 })
AADD(aStru,{"VLRINS6", "N" , 14, 6 })
AADD(aStru,{"VLPA"   , "N" , 12, 4 })
AADD(aStru,{"VLPAICM", "N" , 12, 4 })
AADD(aStru,{"VLPAIPI", "N" , 12, 4 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "PRODUTO"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

_cQ := " SELECT D2_EMISSAO,D2_COD,D2_QUANT,D2_PRCVEN,D2_TES,D2_VALIPI,D2_VALICM FROM SD2010 D2 "
_cQ += " WHERE D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND D2_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_cQ += " AND D2_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND D2_TIPO = 'N' AND D2.D_E_L_E_T_ = '' AND D2_TP = 'PA'	"
_cQ += " ORDER BY D2_COD,D2_EMISSAO "

TCQUERY _cQ NEW ALIAS "ZD2"

dbSelectArea("ZD2")
dbGotop()

ProcRegua(U_CONTREG())

While !Eof() .And. !_lFim

	_cProdD2   := ZD2->D2_COD
	_nPrcVen   := _nQtSD2  := _nVlICM := _nVlIPI := 0
	
	While !Eof() .And. !_lFim .And. _cProdD2 == ZD2->D2_COD
		
		If _lFim
			Alert("Cancelado Pelo Usuario!!!!")
			Return
		Endif
		
		IncProc()
		
		dbSelectArea("SF4")
		dbSetOrder(1)
		If dbSeek(xFilial("SF4")+ZD2->D2_TES)
			If SF4->F4_DUPLIC != "S"
				dbSelectArea("ZD2")
				dbSkip()
				Loop
			Endif
		Endif
		
		_nPrcVen := ZD2->D2_PRCVEN
//		_nPrcVen := ZD2->D2_PRCVEN +  (ZD2->D2_VALIPI / ZD2->D2_QUANT)
		_nQtSD2  := ZD2->D2_QUANT
		_nVlICM  := (ZD2->D2_VALICM / ZD2->D2_QUANT)
		_nVlIPI  := (ZD2->D2_VALIPI / ZD2->D2_QUANT)
		
		dbSelectArea("ZD2")
		dbSkip()
	EndDo
	
	dbSelectArea("SG1")
	dbSetOrder(1)
	If dbSeek(xFilial("SG1")+_cProdD2)
		
		_cProd    := SG1->G1_COD
		nNivel    := 2
		
		_nQtAnt   := _nQtSD2
		_nSdoIni2 := 0
		
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+_cProd)
		_cDescPa := SB1->B1_DESC  
		_cGrPa   := SB1->B1_GRUPO
		
		NECES(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
	Endif
	
	dbSelectArea("ZD2")
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
		dbSeek(xFilial("SB1")+SG1->G1_COD)

		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+SG1->G1_COMP)
		RestArea(aAreaSB1)
		
		_nPrComp  := 0                  
		dbSelectArea("SD1")
		dbSetOrder(7)
		dbSeek(xFilial("SD1")+SB1->B1_COD+"99"+"99999999",.T.)
		dbSkip(-1)       

		If SD1->D1_TIPO != "N"
			dbSkip(-1)
			If SD1->D1_TIPO != "N"
				dbSkip(-1)
			Endif
		Endif
				
		If SD1->D1_COD == SB1->B1_COD
			_nPrComp  := SD1->D1_VUNIT + (SD1->D1_VALIPI / SD1->D1_QUANT)
		Endif
		            
//		If SB1->B1_TIPO == "MP"		
//		If SB1->B1_GRUPO $ "PIC /MPVZ/MPC /MPL "
		If SB1->B1_GRUPO $ "PIC /MPVZ/MPC /MPL /PIPM"
			dbSelectArea("TRB")
			If !dbSeek(_cProdD2)
				RecLock("TRB",.T.)
				TRB->PRODUTO  := _cProdD2
				TRB->GRUPOPA  := _cGrPa   
				If !SB1->B1_GRUPO $ "PIPM"
					TRB->CODCOM1  := SG1->G1_COMP
					TRB->QTDCOM1  := nQuantItem
					TRB->VLRCOM1  := nQuantItem * _nPrComp
//					TRB->VLRCOM1  := nQuantItem * SB1->B1_UPRC
				Else
					TRB->CODINS1  := SG1->G1_COMP
					TRB->QTDINS1  := nQuantItem
					TRB->VLRINS1  := nQuantItem * _nPrComp
				Endif					
				TRB->VLPA     := _nPrcVen
				TRB->VLPAICM  := _nVlICM
				TRB->VLPAIPI  := _nVlIPI
				MsUnLock()
			Else
				dbSelectArea("TRB")
				RecLock("TRB",.f.)
				If !SB1->B1_GRUPO $ "PIPM"
					If Empty(TRB->CODCOM1)
						TRB->CODCOM1  := SG1->G1_COMP
						TRB->QTDCOM1  := nQuantItem
						TRB->VLRCOM1  := nQuantItem * _nPrComp
					ElseIf Empty(TRB->CODCOM2)
						TRB->CODCOM2  := SG1->G1_COMP
						TRB->QTDCOM2  := nQuantItem
						TRB->VLRCOM2  := nQuantItem * _nPrComp
					ElseIf Empty(TRB->CODCOM3) 
						TRB->CODCOM3  := SG1->G1_COMP
						TRB->QTDCOM3  := nQuantItem
						TRB->VLRCOM3  := nQuantItem * _nPrComp
					ElseIf Empty(TRB->CODCOM4) 
						TRB->CODCOM4  := SG1->G1_COMP
						TRB->QTDCOM4  := nQuantItem
						TRB->VLRCOM4  := nQuantItem * _nPrComp
					ElseIf Empty(TRB->CODCOM5) 
						TRB->CODCOM5  := SG1->G1_COMP
						TRB->QTDCOM5  := nQuantItem
						TRB->VLRCOM5  := nQuantItem * _nPrComp
					ElseIf Empty(TRB->CODCOM6) 
						TRB->CODCOM6  := SG1->G1_COMP
						TRB->QTDCOM6  := nQuantItem
						TRB->VLRCOM6  := nQuantItem * _nPrComp
					Else
						Alert("Faltam Campos Compostos produto: "+_cProdD2)
					Endif	
				Else                            
					If Empty(TRB->CODINS1)
						TRB->CODINS1  := SG1->G1_COMP
						TRB->QTDINS1  := nQuantItem
						TRB->VLRINS1  := nQuantItem * _nPrComp
					ElseIf	Empty(TRB->CODINS2)
						TRB->CODINS2  := SG1->G1_COMP
						TRB->QTDINS2  := nQuantItem
						TRB->VLRINS2  := nQuantItem * _nPrComp
					ElseIf	Empty(TRB->CODINS3)
						TRB->CODINS3  := SG1->G1_COMP
						TRB->QTDINS3  := nQuantItem
						TRB->VLRINS3  := nQuantItem * _nPrComp
					ElseIf	Empty(TRB->CODINS4)
						TRB->CODINS4  := SG1->G1_COMP
						TRB->QTDINS4  := nQuantItem
						TRB->VLRINS4  := nQuantItem * _nPrComp
					ElseIf	Empty(TRB->CODINS5)
						TRB->CODINS5  := SG1->G1_COMP
						TRB->QTDINS5  := nQuantItem
						TRB->VLRINS5  := nQuantItem * _nPrComp
					ElseIf	Empty(TRB->CODINS6)
						TRB->CODINS6  := SG1->G1_COMP
						TRB->QTDINS6  := nQuantItem
						TRB->VLRINS6  := nQuantItem * _nPrComp
					Else
						Alert("Faltam Campos Insertos produto: "+_cProdD2)
					Endif
				Endif									
				MsUnLock()
			Endif	
        Endif        
		
		RestArea(aAreaSB1)
		
		dbSelectArea("SG1")
		dbSetOrder(1)
		dbSeek(xFilial("SG1")+SG1->G1_COMP)
		IF Found()
			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+SG1->G1_COD)
			NECES(SG1->G1_COD,nQuantItem,nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
		EndIf
		
		dbSelectArea("SG1")
		dbGoto(_nReg)
	Endif
	dbSkip()
EndDo

Return