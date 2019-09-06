#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0137   ³ Autor ³ Alexandro da Silva    ³ Data ³ 18.06.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Faturamento Produto x Cliente Sintetico                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0137()

_aAliOri := GetArea()
Private _cDescPa := ""

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Faturamento x Cliente")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina criado para Gerar tabela de Vendas "     SIZE 160,7
@ 18,18 SAY "Faturamento  Produto x Cliente Sintetico  "     SIZE 160,7
@ 26,18 SAY "Conforme Parametros informados pelo       "     SIZE 160,7
@ 34,18 SAY "Usuario. PA0137.PRW \RELATO\PA0137.DBF    "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0137")
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

_cArqNovo := "\SPOOL\PA0137.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo

dbCloseArea()
                 
dbSelectArea("ZD2")
dbCloseArea()

If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\SPOOL\PA0137.DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

MsgInfo("Arquivo Processado Com Sucesso!!!!","INFO")

Return


Static Function Proc1(_lFim)

Pergunte("PA0137",.F.)

///////////////////////////////////////////
////// GRUPO DE PERGUNTAS /////////////////
///// MV_PAR01 - Emissao De  ?         ////
///// MV_PAR02 - Emissao Ate ?         ////
///// MV_PAR03 - Cliente De ?          ////
///// MV_PAR04 - Cliente Ate ?         ////
///// MV_PAR05 - Loja De ?             ////
///// MV_PAR06 - Loja Ate ?            ////
///// MV_PAR07 - Produto De ?          ////
///// MV_PAR08 - Produto Ate ?         ////
///// MV_PAR09 - Prod.Cliente de ?     ////
///// MV_PAR10 - Prod.Cliente Ate?     ////
///// MV_PAR11 - Grupo   De ?          ////
///// MV_PAR12 - Grupo   Ate ?         ////
///// MV_PAR13 - SubGrupo De ?         ////
///// MV_PAR14 - SubGrupo Ate ?        ////
///// MV_PAR15 - Gera Financeiro ?     ////1= SIM;2=NAO;3=AMBOS
///// MV_PAR16 - Atualiza Estoque      ////1= SIM;2=NAO;3=AMBOS
///////////////////////////////////////////

aStru := {}
AADD(aStru,{"CLIENTE"   , "C" , 06, 0 })
AADD(aStru,{"LOJA"      , "C" , 02, 0 })
AADD(aStru,{"PROD_PASY" , "C" , 15, 0 })
AADD(aStru,{"PROD_CLI"  , "C" , 15, 0 })
AADD(aStru,{"DESCRIC"   , "C" , 30, 0 })
AADD(aStru,{"GRUPO"     , "C" , 04, 0 })
AADD(aStru,{"SUBGRUPO"  , "C" , 06, 0 })
AADD(aStru,{"QUANT"     , "N" , 14, 2 })
AADD(aStru,{"VALFAT"    , "N" , 14, 2 })
AADD(aStru,{"REVISAO"   , "C" , 04, 0 })
AADD(aStru,{"ULTPRECO"  , "N" , 14, 2 })
AADD(aStru,{"ATIVO"     , "C" , 20, 0 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "CLIENTE+LOJA+PROD_PASY+PROD_CLI"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")
                      
_cQ := " SELECT D2_CLIENTE,D2_LOJA,D2_COD,D2_PROCLI,B1_DESC,B1_GRUPO,B1_SUBGR, "
_cQ += " SUM(D2_QUANT) AS QUANT,SUM(D2_TOTAL) AS VALFAT FROM "+RetSqlName("SD2")+ " D2 "
_cQ += " INNER JOIN "+RetSqlName("SF4")+" F4 ON D2_TES=F4_CODIGO "
_cQ += " INNER JOIN "+RetSqlName("SB1")+" B1 ON D2_COD=B1_COD "
_cQ += " WHERE D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQ += " AND D2_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND D2_LOJA    BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
_cQ += " AND D2_COD BETWEEN     '"+MV_PAR07+"' AND '"+MV_PAR08+"' AND D2_PROCLI  BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
_cQ += " AND B1_GRUPO BETWEEN   '"+MV_PAR11+"' AND '"+MV_PAR12+"' AND B1_SUBGR   BETWEEN '"+MV_PAR13+"' AND '"+MV_PAR14+"' "
_cQ += " AND D2_TIPO = 'N' AND B1.D_E_L_E_T_ = '' AND D2.D_E_L_E_T_ = ''AND F4.D_E_L_E_T_ = '' "
If MV_PAR15 == 1
	_cQ += " AND F4_DUPLIC = 'S' "
ElseIf MV_PAR15 == 2
	_cQ += " AND F4_DUPLIC = 'N' "
Endif	
If MV_PAR16 == 1
	_cQ += " AND F4_ESTOQUE = 'S' "
ElseIf MV_PAR16 == 2
	_cQ += " AND F4_ESTOQUE = 'N' "
Endif	
_cQ += " GROUP BY D2_CLIENTE,D2_LOJA,D2_COD,D2_PROCLI,B1_DESC,B1_GRUPO,B1_SUBGR "
_cQ += " ORDER BY D2_CLIENTE,D2_LOJA,D2_PROCLI "

 TCQUERY _cQ NEW ALIAS "ZD2"

dbSelectArea("ZD2")
dbGotop()

ProcRegua(U_CONTREG())

While !Eof() .And. !_lFim
	
	IncProc()

	dDataRef := CTOD("")
	nValor   := 0
		         
	SZ2->(dbSetOrder(1))
	If SZ2->(dbSeek(xFilial("SZ2")+ZD2->D2_CLIENTE + ZD2->D2_LOJA + ZD2->D2_COD + ZD2->D2_PROCLI))
		dDataRef := SZ2->Z2_DTREF01
		nValor   := SZ2->Z2_PRECO01
		For i := 2 to 12
			If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= dDataRef
				dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
				nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
			Endif
		Next i
    Endif

	TRB->(RecLock("TRB",.T.))
	TRB->CLIENTE    := ZD2->D2_CLIENTE
	TRB->LOJA       := ZD2->D2_LOJA
	TRB->PROD_PASY  := ZD2->D2_COD
	TRB->PROD_CLI   := ZD2->D2_PROCLI
	TRB->DESCRIC    := ZD2->B1_DESC    
	TRB->GRUPO      := ZD2->B1_GRUPO
	TRB->SUBGRUPO   := ZD2->B1_SUBGR
	TRB->REVISAO    := SZ2->Z2_REVISAO
	TRB->QUANT      := ZD2->QUANT      
	TRB->VALFAT     := ZD2->VALFAT
	TRB->ULTPRECO   := nValor
	If SZ2->Z2_ATIVO  == "1"
		TRB->ATIVO      := "ATIVO"
	Else
		TRB->ATIVO      := "INATIVO"
	Endif
	MsUnlock()	
                         
	dbSelectArea("ZD2")
	dbSkip()
EndDo

Return