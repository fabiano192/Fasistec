#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPA0219    บ Autor ณ Fabiando da Silva บ Data ณ  19/09/11    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Emissใo de Etiquetas PCP				                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SigaPCP                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PA0219()

Private _cPerg  := "PA0219"

_cPorta  := "LPT1"
_nOpc    := 0

AtuSX1()

Pergunte(_cPerg,.F.)

@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Rotina Para gerar Etiqueta")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina Para Gerar Etiquetas conforme os parโmetros  "     SIZE 160,7
@ 18,18 SAY "informados pelo usuแrio.                            "     SIZE 160,7
@ 26,18 SAY "               				                     "     SIZE 160,7
@ 34,18 SAY "Programa PA0219                                     "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte(_cPerg,.T.)
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	If MV_PAR01 = 1
		U_PA219A() // Etiqueta Prensa
	ElseIf MV_PAR01 = 2
		U_PA219B() // Etiqueta Pre formado
	ElseIf MV_PAR01 = 3
		U_PA219C() // Etiqueta Vazados
	Endif	
Endif

Return


Static Function AtuSX1()

cPerg := "PA0219"

///////////////////////////////////////
////   MV_PAR01  : Tipo Etiqueta    /// Prensa;Prepara็ใo;Vazado
////   MV_PAR02  : Produto De       ///
////   MV_PAR03  : Produto Ate      ///
//////////////////////////// //////////

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid	/Var01      /Def01    	/defspa1/defeng1/Cnt01/Var02/Def02			/Defspa2/defeng2/Cnt02/Var03/Def03		/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Tipo Etiqueta  		?",""       ,""      ,"mv_ch1","N" ,01     ,0      ,0     ,"C",""        ,"MV_PAR01","Prensa"  	,""     ,""     ,""   ,""   ,"Preparacao"	,""     ,""     ,""   ,""   ,"Vazados"  ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Produto De            ?",""       ,""      ,"mv_ch2","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR02",""        	,""     ,""     ,""   ,""   ,""     		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
U_CRIASX1(cPerg,"03","Produto Ate           ?",""       ,""      ,"mv_ch3","C" ,15     ,0      ,0     ,"G",""        ,"MV_PAR03",""        	,""     ,""     ,""   ,""   ,""     		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")

Return
