#INCLUDE "TOTVS.CH"

/*/
Programa	: CR0091
Autor		: Fabiano da Silva
Data		: 16.05.16
Descrição 	: Produtividade
/*/

User Function CR0091()
	
	
	Local _oDlg		:= Nil
	
	Private _nRadio := 1
	
	DEFINE MSDIALOG _oDlg FROM 0,0 TO 110,230 TITLE "Produtividade" PIXEL OF _oDlg
	
	@ 03,03 TO 050,077 Label "" PIXEL OF _oDlg
	@ 15,08 RADIO _oRadio VAR _nRadio ITEMS "Relatorio ","Grafico Individual","Grafico Prensa (Valor)" SIZE 70,10 PIXEL OF _oDlg
	
	@ 10,080 BUTTON "Gerar" 		SIZE 036,012 ACTION (VerProg(),_oDlg:End()) PIXEL OF _oDlg 
	@ 30,080 BUTTON "Sair"			SIZE 036,012 ACTION ( _oDlg:End()) 			PIXEL OF _oDlg
	
	ACTIVATE MSDIALOG _oDlg CENTERED
	
Return


Static Function VerProg()
	
	If _nRadio == 1
		U_CR0092()
	ElseIf _nRadio == 2
		U_CR0093()
	ElseIf _nRadio == 3
		U_CR0094()
	Endif
	
Return
