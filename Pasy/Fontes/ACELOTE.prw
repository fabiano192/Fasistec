#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ACELOTE   º Autor ³ Fabiano da Silva º Data ³   29/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Acerta campo Lote (Rastro)   	                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFAT                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ACELOTE()

ATUSX1()

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Acerto Campo Lote")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina para acertar o campo RASTRO no cadastro de produto   "     SIZE 160,7
@ 18,18 SAY "Conforme parametros Informados pelo Usuario		 "     SIZE 160,7
@ 26,18 SAY "                                                    "     SIZE 160,7
@ 34,18 SAY "Programa ACELOTE.PRW                                 "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("ACELOTE")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	
	Pergunte("ACELOTE",.F.)
	
	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| AC_A(@_lFim) }
	Private _cTitulo01 := 'Selecionado Registros!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
Endif

Return (Nil)


Static Function AC_A(_lFim)

_cq3  := " UPDATE SB1010 SET B1_RASTRO = 'N' "
_cq3  += " WHERE D_E_L_E_T_ = '' AND B1_COD = '"+MV_PAR01+"' "

TCSQLEXEC(_cq3)

SB1->(dbSetOrder(1))
If SB1->(dbseek(xfilial("SB1")+MV_PAR01))
	If SB1->B1_RASTRO = 'N'
		MSGINFO("Produto "+Alltrim(MV_PAR01)+" alterado com sucesso!! Lembre-se de voltar ao cadastro de produtos e deixar o campo RASTRO como LOTE apos fazer as NFs.")
	Endif
Endif		

Return (Nil)


Static Function AtuSX1()

cPerg := "ACELOTE"
aRegs := {}

///////////////////////////////////////////
/////  GRUPO DE PERGUNTAS /////////////////
///// MV_PAR01 - Produto    	       ////
///////////////////////////////////////////

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Produto                ?",""       ,""      ,"mv_ch1","C" ,15     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")

Return (Nil)