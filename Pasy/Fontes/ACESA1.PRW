#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACEDIVER  º Autor ³ Alexandro da Silva º Data ³  06/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualizaçao Produto X Cliente                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ACESA1()

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Acertos Diversos")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina Para Efetuar Acertos Diveros "     SIZE 160,7
                                           
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	Private _cMsg01    := ''
	Private _lFim      := .F.
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| PROC1(@_lFim) }
	Private _cTitulo01 := 'Acerto Diversos!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
Endif

Return


Static Function PROC1(_lFim)

_cArqDbf := "CLIENT.DBF"
_cArqInd := "CLIENT"

_cIndTRB := "CODIGO+LOJA"

dbUseArea(.T.,,_cArqDBF,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",_cArqInd,_cIndTRB,,,"Criando Trabalho...")

TRB->(dbGotop())

ProcRegua(TRB->(U_CONTREG()))

While TRB->(!Eof()) .And. !_lFim
	
	IncProc()
	
	If _lFim
		REturn
	Endif
	                    
	SA3->(dbSetOrder(1))
	If SA3->(dbSeek(xFilial("SA3")+TRB->VEND))
		
		_cQuery1 := " UPDATE SA1010 SET A1_VEND = '"+TRB->VEND+"' "
		_cQuery1 += " WHERE D_E_L_E_T_ = '' AND A1_COD+A1_LOJA = '"+TRB->CODIGO+TRB->LOJA+"' "

		TCSQLEXEC(_cQuery1)
         
		_cQuery2 := " UPDATE SC5010 SET C5_VEND1 = '"+TRB->VEND+"'  "
		_cQuery2 += " WHERE D_E_L_E_T_ = '' AND C5_CLIENTE+C5_LOJACLI = '"+TRB->CODIGO+TRB->LOJA+"' AND C5_EMISSAO > '20120101' "

		TCSQLEXEC(_cQuery2)

		_cQuery4 := " UPDATE SC6010 SET C6_COMIS1 = '"+STR(SA3->A3_COMIS)+"' "
		_cQuery4 += " WHERE D_E_L_E_T_ = '' AND C6_CLI+C6_LOJA = '"+TRB->CODIGO+TRB->LOJA+"'  AND C6_ENTREG > '20120101' "

		TCSQLEXEC(_cQuery4)

		_cQuery3 := " UPDATE SE1010 SET E1_VEND1 = '"+TRB->VEND+"',E1_COMIS1 = '"+STR(SA3->A3_COMIS)+"' "
		_cQuery3 += " WHERE D_E_L_E_T_ = '' AND E1_CLIENTE+E1_LOJA = '"+TRB->CODIGO+TRB->LOJA+"' "

		TCSQLEXEC(_cQuery3)
	
	Endif
		
	TRB->(dbSkip())
EndDo

TRB->(dbCloseArea())

MsgInfo("ATUALIZADO COM SUCESSO","INFO","INFORMACAO")

Return