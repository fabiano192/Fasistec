#include "rwmake.ch"

User Function CR0026()

	_nOpc := 0

	@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Rotina de Inventario")
	@ 02,10 TO 080,220
	@ 10,18 SAY "Rotina para Criar os Produtos na tabela SB7 (Inventario)"     SIZE 160,7
	@ 18,18 SAY "Onde os Produtos estao com Saldo Negativo para zerar o  "     SIZE 160,7
	@ 26,18 SAY "Saldo final.					                           "     SIZE 160,7
	@ 34,18 SAY "                Programa CR0026.PRW                 	   "     SIZE 160,7

	@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
	@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

	ACTIVATE DIALOG oDlg Centered

	If _nOpc == 1
		Processa({|lend| CR026A()},"Alterando ")
	Endif

	Return(.T.)



Static Function CR026A()

	_cArqDbf := "EST1.DBF"
	_cArqInd := "EST1"

	_cIndTRB := "CODIGO+ARMZ+LOCALIZ"

	dbUseArea(.T.,,_cArqDBF,"TRB",.F.,.F.)

	dbSelectArea("TRB")
	IndRegua("TRB",_cArqInd,_cIndTRB,,,"Criando Trabalho...")

	TRB->(dbGotop())

	ProcRegua(TRB->(U_CONTREG()))

	While TRB->(!Eof())

		IncProc()

		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+TRB->CODIGO))
			SB7->(RecLock("SB7",.T.))
			SB7->B7_FILIAL  := xFilial("SB7")
			SB7->B7_COD     := TRB->CODIGO
			SB7->B7_LOCAL   := TRB->ARMZ
			SB7->B7_TIPO    := SB1->B1_TIPO
			SB7->B7_DOC     := TRB->DOC
			SB7->B7_DATA    := TRB->DTINV
			SB7->B7_LOCALIZ := TRB->LOCALIZ
			SB7->B7_DTVALID := TRB->DTVALID
			SB7->B7_QUANT   := TRB->QTDE
			SB7->B7_STATUS  := "1"
			SB7->(MsUnlock())
		Endif

		TRB->(dbSkip())
	EndDo

	Return

