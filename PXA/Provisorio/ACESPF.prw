#include "rwmake.ch"
#include "topconn.ch"

User Function ACESPF()

	_nOpc := 0
	@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Rotina Para Atualizaçao")
	@ 02,10 TO 080,220
	@ 10,18 SAY "Rotina Para Atualizacao da Troca de Turno		     "     SIZE 160,7
	@ 18,18 SAY "                                                    "     SIZE 160,7
	@ 26,18 SAY "                                                    "     SIZE 160,7
	@ 34,18 SAY "Programa ACESPF.prw                                 "     SIZE 160,7

	@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
	@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

	ACTIVATE DIALOG oDlg Centered

	If _nOpc == 1
		Private _lFim      := .F.
		Private _cMsg01    := ''
		Private _lAborta01 := .T.
		Private _bAcao01   := {|_lFim| ACESPF1(@_lFim) }
		Private _cTitulo01 := 'Atualizando Cadastros!!!!'
		Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )                      
	Endif

Return


Static Function ACESPF1()

	_cQuery := "SELECT * FROM SPF160 WHERE PF_DATA = '20150321' AND D_E_L_E_T_ = '' AND PF_TURNOPA <> '079' "

	TCQUERY _cQuery NEW ALIAS "TRB"


	TRB->(dbGotop())

	ProcRegua(RecCount())

	While TRB->(!Eof())

		SPF->(RECLOCK('SPF',.T.))
		SPF->PF_FILIAL 	:= TRB->PF_FILIAL
		SPF->PF_MAT 	:= TRB->PF_MAT
		SPF->PF_DATA    := CTOD('13/04/2015')
		SPF->PF_TURNODE := TRB->PF_TURNOPA
		SPF->PF_SEQUEDE := TRB->PF_SEQUEPA
		SPF->PF_REGRADE := TRB->PF_REGRAPA
		SPF->PF_TURNOPA := "079"
		SPF->PF_SEQUEPA := "01"
		SPF->PF_REGRAPA := TRB->PF_REGRAPA
		SPF->(MSUNLOCK())

		TRB->(dbSkip())
	EndDo

	TRB->(dbCloseArea())

	MSGINFO("Alteracao Efetuada com Sucesso !!! ")

Return
