#include "rwmake.ch"

User Function CR0062()

	_nOpc := 0

	@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Rotina de Inventario")
	@ 02,10 TO 080,220
	@ 10,18 SAY "Rotina para Criar os Produtos na tabela SB7 (Inventario)"     SIZE 160,7
	@ 18,18 SAY "Onde os Produtos estao com Saldo Zerado Conforme lanca- "     SIZE 160,7
	@ 26,18 SAY "Mento efetuados Pelo Usuario.                           "     SIZE 160,7
	@ 34,18 SAY "                Programa CR0062.PRW                 "     SIZE 160,7

	@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("CR0062")
	@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
	@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

	ACTIVATE DIALOG oDlg Centered

	If _nOpc == 1
		Processa({|lend| CR062A()},"Alterando ")
	Endif

Return(.T.)



Static Function CR062A()

///   PERGUNTE CR0062                  ///
//  MV_PAR01   : Data para Selecao     ///
//  MV_PAR02   : Quais ALMOXARIFADOS   ///

	dbSelectArea("SB2")
	dbGotop()

	ProcRegua(LastRec())

	While !Eof()
	
		IncProc()
	
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+SB2->B2_COD + SB2->B2_LOCAL)
			If SB2->B2_LOCAL == "98" .And. SB1->B1_LOCPAD == "01"
				dbSelectArea("SB2")
				dbSkip()
				Loop
			Endif
			
			If !SB1->B1_TIPO $ MV_PAR03
				dbSelectArea("SB2")
				dbSkip()
				Loop
			Endif
		
			dbSelectArea("SB7")
			dbSetOrder(1)
			If !dbSeek(xFilial("SB7")+DTOS(MV_PAR01)+SB2->B2_COD + SB2->B2_LOCAL)
		
				If SB2->B2_LOCAL $ MV_PAR02
					dbSelectArea("SB1")
					dbSetOrder(1)
					If dbSeek(xFilial("SB1")+SB2->B2_COD)
						dbSelectArea("SB7")
						RecLock("SB7",.T.)
						SB7->B7_FILIAL := xFilial("SB7")
						SB7->B7_COD    := SB2->B2_COD
						SB7->B7_LOCAL  := SB2->B2_LOCAL
						SB7->B7_TIPO   := SB1->B1_TIPO
						SB7->B7_DOC    := "000001"
						SB7->B7_DATA   := MV_PAR01
						SB7->B7_DTVALID:= MV_PAR01
						SB7->B7_QUANT  := 0
						MsUnlock()
					Endif
				Endif
			Endif
		Endif
	
		dbSelectArea("SB2")
		dbSkip()
	EndDo

Return