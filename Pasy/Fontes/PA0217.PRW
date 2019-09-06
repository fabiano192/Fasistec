#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PA01217   º Autor ³ Fabiano da Silva    ºData ³  25/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatórios de Compras po Fornecedor                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFAT                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0217()

ATUSX1()

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Relatório Em Excel")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina Gerar o Relatório de Compras por Fornecedor  "     SIZE 160,7
@ 18,18 SAY "conforme Parametros informados pelo usuario         "     SIZE 160,7
@ 26,18 SAY "                                                    "     SIZE 160,7
@ 34,18 SAY "Programa PA0217.PRW                                 "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0217")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	
	Pergunte("PA0217",.F.)
	
	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| PA217A(@_lFim) }
	Private _cTitulo01 := 'Selecionado Registros!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
	_cArqNew := "\SPOOL\PA0217.DBF"
	
	dbSelectArea("ZZ")
	COPY ALL TO &_cArqNew
	
	dbCloseArea("ZZ")
	
	If ! ApOleClient( 'MsExcel' )
		MsgStop('MsExcel nao instalado')
		Return
	EndIf
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\SPOOL\PA0217.DBF" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
Endif

Return (Nil)


Static Function PA217A(_lFim)

_cFilial := SM0->M0_CODFIL

_cQ := " SELECT D1_TIPO AS TIPO,D1_FORNECE AS FORNECE,D1_LOJA AS LOJA,A2_NOME AS NOME,SUM(D1_TOTAL) AS VAL_MERC,SUM(D1_VALIPI) AS VAL_IPI, "
_cQ += " SUM(D1_VALICM) AS VAL_ICMS,SUM(D1_TOTAL+D1_VALIPI) AS TOTAL FROM "+RetSqlName("SD1")+" A"
_cQ += " INNER JOIN "+RetSqlName("SA2")+" B ON D1_FORNECE+D1_LOJA = A2_COD+A2_LOJA  "
_cQ += " INNER JOIN "+RetSqlName("SF4")+" C ON D1_TES=F4_CODIGO "
_cQ += " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND C.D_E_L_E_T_ = ''"
_cQ += " AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND D1_TIPO = 'N' "
_cQ += " AND D1_FORNECE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_cQ += " AND A.D1_FILIAL = '"+_cFilial+"' "
If MV_PAR05 = 1
	_cQ += " AND F4_DUPLIC = 'S' "
ElseIf MV_PAR07 = 2
	_cQ += " AND F4_DUPLIC = 'N' "
Endif
_cQ += " GROUP BY D1_TIPO,D1_FORNECE,D1_LOJA,A2_NOME "
_cQ += " ORDER BY TIPO,FORNECE,LOJA "

TCQUERY _cQ NEW ALIAS "ZZ"

TCSETFIELD("ZZ","VAL_MERC" ,"N",14,2)
TCSETFIELD("ZZ","VAL_IPI"  ,"N",14,2)
TCSETFIELD("ZZ","VAL_ICMS" ,"N",14,2)
TCSETFIELD("ZZ","TOTAL"    ,"N",14,2)

dbSelectArea("ZZ")
_cArq := CriaTrab(NIL,.F.)
Copy To &_cArq

dbCloseArea()

dbUseArea(.T.,,_cArq,"ZZ",.T.)

If MV_PAR06 = 1
		
	_cQ1 := " SELECT D2_TIPO AS TIPO,D2_CLIENTE AS FORNECE,D2_LOJA AS LOJA,A2_NOME AS NOME,SUM(D2_TOTAL) AS VAL_MERC,SUM(D2_VALIPI) AS VAL_IPI, "
	_cQ1 += " SUM(D2_VALICM) AS VAL_ICMS,SUM(D2_TOTAL+D2_VALIPI) AS TOTAL FROM "+RetSqlName("SD2")+" A"
	_cQ1 += " INNER JOIN "+RetSqlName("SA2")+" B ON D2_CLIENTE+D2_LOJA = A2_COD+A2_LOJA  "
	_cQ1 += " INNER JOIN "+RetSqlName("SF4")+" C ON D2_TES=F4_CODIGO "
	_cQ1 += " WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND C.D_E_L_E_T_ = ''"
	_cQ1 += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND D2_TIPO = 'D' "
	_cQ1 += " AND D2_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	_cQ1 += " AND A.D2_FILIAL = '"+_cFilial+"' "
	If MV_PAR05 = 1
		_cQ1 += " AND F4_DUPLIC = 'S' "
	ElseIf MV_PAR07 = 2
		_cQ1 += " AND F4_DUPLIC = 'N' "
	Endif
	_cQ1 += " GROUP BY D2_TIPO,D2_CLIENTE,D2_LOJA,A2_NOME "
	_cQ1 += " ORDER BY TIPO,FORNECE,LOJA "
	
	TCQUERY _cQ1 NEW ALIAS "ZD"
	
	TCSETFIELD("ZD","VAL_MERC" ,"N",14,2)
	TCSETFIELD("ZZ","VAL_IPI"  ,"N",14,2)
	TCSETFIELD("ZZ","VAL_ICMS" ,"N",14,2)
	TCSETFIELD("ZZ","TOTAL"    ,"N",14,2)
		
	ZD->(dbGotop())
	
	While ZD->(!EOF())
		
		ZZ->(RecLock("ZZ",.T.))
		ZZ->TIPO    	:= ZD->TIPO
		ZZ->FORNECE  	:= ZD->FORNECE
		ZZ->LOJA	   	:= ZD->LOJA
		ZZ->NOME		:= ZD->NOME
		ZZ->VAL_MERC	:= (ZD->VAL_MERC * -1)
		ZZ->VAL_IPI		:= (ZD->VAL_IPI * -1)
		ZZ->VAL_ICMS	:= (ZD->VAL_ICMS * -1)
		ZZ->TOTAL   	:= (ZD->TOTAL * -1)
		ZZ->(MsUnlock())
		
		ZD->(dbSkip())
	EndDo
	
	ZD->(dbCloseArea())
Endif

Return (Nil)


Static Function AtuSX1()

cPerg := "PA0217"
aRegs := {}

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Emissao De            ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Emissao Ate           ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"03","Fornecedor De         ?",""       ,""      ,"mv_ch3","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR03",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SA2")
U_CRIASX1(cPerg,"04","Fornecedor Ate        ?",""       ,""      ,"mv_ch4","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR04",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SA2")
U_CRIASX1(cPerg,"05","Gera Duplicata        ?",""       ,""      ,"mv_ch5","N" ,01     ,0      ,0     ,"C",""            ,"MV_PAR05","Sim"            ,""     ,""     ,""   ,""   ,"Nao"            ,""     ,""     ,""   ,""   ,"Ambos",""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"06","Considera Devolucao   ?",""       ,""      ,"mv_ch6","N" ,01     ,0      ,0     ,"C",""            ,"MV_PAR06","Sim"            ,""     ,""     ,""   ,""   ,"Nao"            ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return (Nil)
