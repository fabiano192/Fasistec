#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACESB7    º Autor ³ Fabiando da Silva º Data ³  16/01/08    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualizaçao Lançamentos do Inventário                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ACEETI2()


@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Rotina Para gerar Etiqueta")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina Para Gerar Etiquetas		                 "     SIZE 160,7
@ 18,18 SAY "                                                    "     SIZE 160,7
@ 26,18 SAY "Programa ACEETI2                                    "     SIZE 160,7
@ 34,18 SAY "                                                    "     SIZE 160,7

@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	Private _cMsg01    := ''
	Private _lFim      := .F.
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| Proc1(@_lFim) }
	Private _cTitulo01 := 'Selecionando Registros !!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
Endif

Return


Static Function Proc1(_lFim)

_cArqTrb:= "CODIGO.DBF"
_cArqInd:= "CODIGO"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

_cInd := "CODIGO"
IndRegua("TRB",_cArqInd,_cInd,,,"Selecionando Arquivo Trabalho")

TRB->(dbGotop())

ProcRegua(TRB->(U_CONTREG()))

_nCont := 0
While TRB->(!Eof()) .And. !_lFim
	
	IncProc()
	
	If _lFim
		REturn
	Endif
	
	SB1->(dbSelectArea(1))
	If SB1->(dbSeek(xFilial("SB1")+TRB->CODIGO))
		SB1->(RecLock("SB1",.F.))
		SB1->B1_IMPETIQ = "S"
		SB1->(MsUnlock())
				
		SG1->(dbSetOrder(1))
		If SG1->(dbSeek(xFilial("SG1")+TRB->CODIGO))
			_cProd   := SG1->G1_COD
			nNivel   := 2
			
			SB1->(dbSeek(xFilial("SB1")+_cProd))
			
			NECES(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
			
		Endif
	Endif
		
	TRB->(dbSkip())
EndDo

TRB->(dbCloseArea())

Return()



Static Function NECES(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev)

Local _nReg := 0
Local _nRegTrb := 0

SG1->(dbSetOrder(1))

While SG1->(!Eof()) .And. SG1->G1_COD == _cProd
	
	_nReg := SG1->(Recno())
	
	dbSelectArea("SG1")
	dbSetOrder(1)
	
	aAreaSB1:=SB1->(GetArea())
	SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))
	
	_nRegTRb := SB1->(Recno())
	
	If SB1->B1_GRUPO $ "PIPF"
		SB1->(RecLock("SB1",.F.))
		SB1->B1_IMPETIQ = "S"
		SB1->(MsUnlock())
	Endif
	
	RestArea(aAreaSB1)
	
	SG1->(dbSetOrder(1))
	If SG1->(dbSeek(xFilial("SG1")+SG1->G1_COMP))
		SB1->(dbSeek(xFilial("SB1")+SG1->G1_COD))
		NECES(SG1->G1_COD,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
	EndIf
	
	SG1->(dbGoto(_nReg))
	
	SG1->(dbSkip())
EndDo

Return
