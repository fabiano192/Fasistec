#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACESB1    º Autor ³ Fabiano da Silva º   Data ³  15/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualizaçao PRODUTO                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Sigaest                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ACESB1()

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Atualização do Cadastro de Produtos ")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina Para Atualizar Cadastro de Produtos          "     SIZE 160,7
@ 18,18 SAY "												     "     SIZE 160,7
@ 26,18 SAY "                                                    "     SIZE 160,7
@ 34,18 SAY "                                                    "     SIZE 160,7

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

SB1->(dbsetOrder(1))

SB1->(dbGotop())

ProcRegua(SB1->(U_CONTREG()))

While SB1->(!Eof()) .And. !_lFim
	
	IncProc()
	
	If _lFim
		REturn
	Endif	
	
	_aAreaSB1 := SB1->(GetArea())

	_cProd   := SB1->B1_COD
	
	If SB1->B1_GRUPO = 'PA'
		NECESC6(_cProd,SB1->B1_POSIPI)
	Endif
	            
	RestArea(_aAreaSB1)

	SB1->(dbSkip())
EndDo

MsgInfo("ATUALIZADO COM SUCESSO","INFO","INFORMACAO")

Return


Static Function NECESC6(_cProd,_cPosIPI)

Local _nReg := 0

dbSelectArea("SG1")
dbSetOrder(1)
If dbSeek(xFilial("SG1")+_cProd)
	
	While !Eof() .And. SG1->G1_FILIAL + SG1->G1_COD == xFilial("SG1") + _cProd
		
		_nReg := Recno()
		
		dbSelectArea("SG1")
		dbSetOrder(1)
		
		dbSelectArea("SB1")
		
		aAreaSB1 := GetArea()
		
		dbSeek(xFilial("SB1")+SG1->G1_COMP)
		
		If SB1->B1_GRUPO $ "PIPB"
			
			SB1->(RecLock("SB1",.F.))
			SB1->B1_POSIPI := _cPosIPI
			SB1->(MsUnlock())
			RestArea(aAreaSB1)
			
			Return
		Endif
		
		RestArea(aAreaSB1)
		
		dbSelectArea("SG1")
		dbSetOrder(1)
		dbSeek(xFilial("SG1")+SG1->G1_COMP)
		
		IF Found()
			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+SG1->G1_COD)
			
			NECESC6(SG1->G1_COD,_cPosIPI)
		EndIf
		
		SG1->(dbSelectArea("SG1"))
		SG1->(dbGoto(_nReg))
		
		SG1->(dbSkip())
	EndDo
	
Endif

Return
