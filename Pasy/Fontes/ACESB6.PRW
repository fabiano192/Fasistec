#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACEDIVER  บ Autor ณ Alexandro da Silva บ Data ณ  06/03/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Atualiza็ao Produto X Cliente                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SigaFat                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ACESB6()

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("limpeza Poder Em Terceiros!! ")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina Para Efetuar a Libera็ใo Dos Itens de Produ- "     SIZE 160,7
@ 18,18 SAY "็ao enviados para o C.Q., conforme parametros infor-"     SIZE 160,7
@ 26,18 SAY "mados pelo Usuario                                  "     SIZE 160,7
@ 34,18 SAY "                                                    "     SIZE 160,7

//@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("ACEDIVER")
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

cChave := "D2_IDENTB6+D2_CLIENTE+D2_LOJA+D2_COD"
cNomArq :=CriaTrab("",.F.)
IndRegua("SD2",cNomArq,cChave,,, OemToAnsi("Selecionando Registros..."))
nIndex := RetIndex("SD2")
DbSelectArea("SD2")
DbSetOrder(nIndex+1)

//_cq := " SELECT * FROM "+RetSqlName("SB6")+" A WHERE A.D_E_L_E_T_ = '' AND B6_QUANT = B6_SALDO "
//_cQ += " AND B6_CLIFOR <> '001109' and B6_TIPO = 'E' AND B6_PODER3 = 'R' "
//_cQ += " ORDER BY B6_IDENT "

_cq := " SELECT * FROM "+RetSqlName("SB6")+" A WHERE A.D_E_L_E_T_ = '' AND B6_QUANT = B6_SALDO "
_cQ += " AND B6_TIPO = 'E' AND B6_PODER3 = 'R' "
_cQ += " ORDER BY B6_IDENT "

TCQUERY _cQ NEW ALIAS "ZZ"

ZZ->(dbGotop())

ProcRegua(ZZ->(U_CONTREG()))

While ZZ->(!Eof()) .And. !_lFim
	
	IncProc()
	
	If _lFim
		REturn
	Endif
	
	If SD2->(dbSeek(ZZ->B6_IDENT+ZZ->B6_CLIFOR + ZZ->B6_LOJA+ZZ->B6_PRODUTO))
		If SD2->D2_TES == "509"
			SD2->(RecLock("SD2",.F.))
			SD2->D2_TES := "606"
			SD2->(MsUnLock())
		Endif
	Endif
	
	ZZ->(dbSkip())
EndDo

dbSelectArea("SD2")
RetIndex("SD2")
dbSetOrder(1)
Set Filter To

cExt := OrdBagExt()
fErase(cNomArq+cExt)

ZZ->(dbCloseArea())

MsgInfo("ATUALIZADO COM SUCESSO","INFO","INFORMACAO")

Return