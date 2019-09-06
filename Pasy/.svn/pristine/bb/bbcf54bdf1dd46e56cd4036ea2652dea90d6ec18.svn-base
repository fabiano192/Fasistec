#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function LOTEMIN()

Private _cPerg    := "PA0044"
Private _oGeraTxt
Private _cString  := "Sb1"
Pergunte(_cPerg,.F.)

dbSelectArea("Sb1")
dbSetOrder(1)

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Geracao de Arquivo do P.A")
@ 02,10 TO 080,220
@ 10,018 Say " Este programa ira gerar um arquivo .dbf , conforme os parame- " SIZE 160,7
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de " SIZE 160,7
@ 26,018 Say " Produtos.LOTEMIN.PRW  \RELATO\LOTEMIN.DBF                     " SIZE 160,7
@ 85,122 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,158 BMPBUTTON TYPE 2 ACTION oDlg:END()
@ 85,188 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)

ACTIVATE DIALOG oDlg Centered  //Valid Close(odlg)

If _nOpc == 1	
	LOTE()
Endif
	
Return


Static Function LOTE()

aStru := {}
AADD(aStru,{"CLIENTE"  , "C" ,  6, 0 })
AADD(aStru,{"LOJA"     , "C" ,  2, 0 })
AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
AADD(aStru,{"PRODCLI"  , "C" , 15, 0 })
AADD(aStru,{"LOTEMIN"  , "N" , 10, 0 })
AADD(aStru,{"QTDCAV"   , "C" , 05, 0 })

cArqTRB := CriaTrab(aStru,.T.)
cIndTRB := "PRODUTO+PRODCLI"
dbUseArea(.T.,,cArqTRB,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqTRB,cIndTRB,,,"Criando Trabalho...")

dbSelectArea("SZ2")
dbGoTop()

While !EOF() 

	If SZ2->Z2_CLIENTE != "000008"
		dbSelectArea("SZ2")
		dbSkip()
		Loop
	Endif	
	                       
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->CLIENTE := SZ2->Z2_CLIENTE
	TRB->LOJA    := SZ2->Z2_LOJA
	TRB->PRODUTO := SZ2->Z2_PRODUTO
	TRB->PRODCLI := SZ2->Z2_CODCLI
	TRB->LOTEMIN := SZ2->Z2_LOTEMIN
	MsUnlock()
	
	Verestrut()
	
	dbSelectArea("SZ2")
	dbSkip()
EndDo

_cArqNovo := "\RELATO\LOTEMIN.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo

dbCloseArea()

FErase(cArqTrb+".DBF")

If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "F:\AP8\DADOS\RELATO\LOTEMIN.DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return


Static Function VerEstrut()

dbSelectArea("SG1")
dbSetOrder(1)
If dbSeek(xFilial("SG1")+SZ2->Z2_PRODUTO)
	
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
		
		If SB1->B1_GRUPO $ "FRVC/FRVI/FRVT"   // Molde de Vulcanização / Ferramenta
			dbSelectArea("TRB")
			If dbSeek(SZ2->Z2_PRODUTO+SZ2->Z2_CODCLI)
				RecLock("TRB",.f.)
				TRB->QTDCAV  := SB1->B1_CAV
				MsUnlock()
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