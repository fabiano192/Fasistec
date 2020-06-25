#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PXHOL003 º Autor ³ Alexandro da Silva º Data ³  11/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualizações Diversas                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFIN                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PXHOL003()


_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Rotina Para Atualizaçao Diversas ")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina Para Atualizacões Diversas conforme Neces-   "     SIZE 160,7
@ 18,18 SAY "sidade de correção                                  "     SIZE 160,7
@ 26,18 SAY "                      Programa PXHOL003             "     SIZE 160,7
@ 34,18 SAY "                                                    "     SIZE 160,7

//@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("ASI002")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	
	Private _cMsg01    := ''
	Private _lFim      := .F.
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| ASI_01(@_lFim) }
	Private _cTitulo01 := 'Selecionando Registros !!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
Endif

Return



Static Function ASI_01(_lFim)

//_cq := " SELECT * FROM "+RetSqlName("SE2")+" A WHERE A.D_E_L_E_T_ = '' "
//_cq += " ORDER BY E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA "

//TCQUERY _cq NEW ALIAS "ZZ"

SE2->(dbGotop())

ProcRegua(SE2->(U_CONTREG()))

While SE2->(!Eof()) .And. !_lFim
	
	IncProc()
	
	If _lFim
		REturn
	Endif
	
	SD1->(dbSetOrder(1))
	If SD1->(dbseek(SE2->E2_FILIAL + SE2->E2_NUM + SE2->E2_PREFIXO + SE2->E2_FORNECE + SE2->E2_LOJA))
		_cChavSD1 := SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE +  SD1->D1_FORNECE + SD1->D1_LOJA
		
		_cCusto := ""
		
		While SD1->(!Eof()) .And. _cChavSD1 == SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE +  SD1->D1_FORNECE + SD1->D1_LOJA
			
			_cCusto := SD1->D1_CC
			
			SD1->(dbSkip())
		EndDo
		
		SE2->(RecLock("SE2",.F.))
		SE2->E2_CC := _cCusto
		SE2->(MsUnLock())
	Endif
	
	SE2->(dbSkip())
EndDo

MsgInfo("ATUALIZADO COM SUCESSO ","INFO","INFORMACAO")

Return


Static Function ATUSX1()

cPerg := "ASI002"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 -> Data De                                                 ³
//³ mv_par02 -> Data Ate                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01     /defspa1/defeng1/Cnt01/Var02/Def02     /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Ano Referencia (AAAA) ?",""       ,""      ,"mv_ch1","C" ,04     ,0      ,0     ,"G",""        ,"MV_PAR01","       "   ,""     ,""     ,""   ,""   ,"     "   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")


Return