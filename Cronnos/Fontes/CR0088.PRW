#INCLUDE "TOTVS.CH"

/*/
Programa	: CR0088
Autor		: Fabiano da Silva
Data		: 16.05.16
Descrição 	: Ocorrencia
/*/

User Function CR0088()
	
	Local _oDlg		:= Nil
	
	Private _nRadio := 1
	
	DEFINE MSDIALOG _oDlg FROM 0,0 TO 110,180 TITLE "Ocorrencias" PIXEL OF _oDlg
	
	@ 03,03 TO 50,50 Label "" PIXEL OF _oDlg
	@ 20,10 RADIO _oRadio VAR _nRadio ITEMS "Relatorio ","Grafico" SIZE 33,10 PIXEL OF _oDlg
	
	@ 10,055 BUTTON "Gerar" 		SIZE 036,012 ACTION (VerProg(),_oDlg:End()) PIXEL OF _oDlg 
	@ 30,055 BUTTON "Sair"			SIZE 036,012 ACTION ( _oDlg:End()) 			PIXEL OF _oDlg
	
	ACTIVATE MSDIALOG _oDlg CENTERED
	
Return


Static Function VerProg()
	
	If _nRadio == 1
		U_CR0089()
	ElseIf _nRadio == 2
		U_CR0090()
	Endif
	
Return
