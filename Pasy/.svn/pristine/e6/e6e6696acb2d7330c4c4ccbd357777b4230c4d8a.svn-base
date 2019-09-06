#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0136   ³ Autor ³ Alexandro da Silva    ³ Data ³ 03.06.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gerando Tabela Provisoria                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0136()

_aAliOri := GetArea()
Private _cDescPa := ""

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Demanda Caterpillar")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina criado para Gerar tabela de Vendas "     SIZE 160,7
@ 18,18 SAY "dos produtos conforme Vendas.             "     SIZE 160,7
@ 26,18 SAY "Conforme Parametros informados pelo       "     SIZE 160,7
@ 34,18 SAY "Usuario. PA0136.PRW \RELATO\PA0136.DBF    "     SIZE 160,7

//@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0136")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	Proces()
Endif

Return


Static Function Proces()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| Proc1(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

//_cArqNovo := "\RELATO\PA0136.DBF"
dbSelectArea("TRB")
//Copy all to &_cArqNovo

dbCloseArea()
                 
dbSelectArea("ZD2")
dbCloseArea()
/*
If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "F:\AP7\AP_DATA\RELATO\PA0136.DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

*/
MsgInfo("Arquivo Processado Com Sucesso!!!!","INFO")


Return



Static Function Proc1(_lFim)

Pergunte("PA0136",.F.)

///////////////////////////////////////////
////// GRUPO DE PERGUNTAS /////////////////
///// MV_PAR01 - Emissao De  ?         ////
///// MV_PAR02 - Emissao Ate ?         ////
///// MV_PAR03 - Cliente De ?          ////
///// MV_PAR04 - Cliente Ate ?         ////
///////////////////////////////////////////


_cArqTrb:="TABCAT.DBF"               
_cArqInd:="TABCAT"               

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)
_cInd := "PRODCLI"
IndRegua("TRB",_cArqInd,_cInd,,,"Selecionando Arquivo Trabalho")

_cQ := " SELECT D2_CLIENTE,D2_LOJA,D2_PROCLI,SUM(D2_QUANT) AS QUANT,SUM(D2_TOTAL) AS VALTOT FROM SD2010 D2 "
_cQ += " INNER JOIN SF4010 F4 ON D2_TES=F4_CODIGO "
_cQ += " WHERE D2_EMISSAO BETWEEN '20060101' AND '20061231' AND D2_CLIENTE = '000008' "
_cQ += " AND D2_TIPO = 'N' AND D2.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = ''AND F4_DUPLIC = 'S' "
_cQ += " GROUP BY D2_CLIENTE,D2_LOJA,D2_PROCLI "
_cQ += " ORDER BY D2_CLIENTE,D2_LOJA,D2_PROCLI "

TCQUERY _cQ NEW ALIAS "ZD2"

dbSelectArea("ZD2")
dbGotop()

ProcRegua(U_CONTREG())

While !Eof() .And. !_lFim
	
	IncProc()

	dDataRef := CTOD("")
	nValor   := 0
		         
	SZ2->(dbSetOrder(6))
	If SZ2->(dbSeek(xFilial("SZ2")+ZD2->D2_CLIENTE + ZD2->D2_LOJA + ZD2->D2_PROCLI + "1"))
		dDataRef := SZ2->Z2_DTREF01
		nValor   := SZ2->Z2_PRECO01
		For i := 2 to 12
			If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= dDataRef
				dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
				nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
			Endif
		Next i
    Endif

	If TRB->(dbSeek(ZD2->D2_PROCLI))
		TRB->(RecLock("TRB",.f.))
		TRB->QTDFAT    := ZD2->QUANT
		TRB->VALFAT    := ZD2->VALTOT
		TRB->ULTPRECO  := nValor
		MsUnlock()
	Else
		TRB->(RecLock("TRB",.T.))
		TRB->PRODCLI   := ZD2->D2_PROCLI
		TRB->NOME      := SZ2->Z2_DESCCLI
		TRB->PEDIDO    := SZ2->Z2_PEDCLI
		TRB->REVIS     := SZ2->Z2_REVISAO
		TRB->QTDFAT    := ZD2->QUANT
		TRB->VALFAT    := ZD2->VALTOT
		TRB->ULTPRECO  := nValor
		MsUnlock()	
	Endif

	dbSelectArea("ZD2")
	dbSkip()
EndDo

Return