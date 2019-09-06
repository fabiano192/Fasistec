//#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PA0183   บ Autor ณ Fabiano da Silva บ   Data ณ  10/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rios de Produto X Faturado                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFAT                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PA0183()

ATUSX1()

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Relat๓rio Em Excel")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina Gerar o Relat๓rio em excel dos Produtos       "     SIZE 160,7
@ 18,18 SAY "Faturados conforme parametros Informados pelo Usuario"     SIZE 160,7
@ 26,18 SAY "                                                     "     SIZE 160,7
@ 34,18 SAY "Programa PA0183.PRW                                  "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0183")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	
	Pergunte("PA0183",.F.)
	
	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| PA183_A(@_lFim) }
	Private _cTitulo01 := 'Selecionado Registros!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
Endif

Return


Static Function PA183_A(_lFim)

_cQ := " SELECT D2_COD,B1_DESC,SUM(D2_QUANT) AS QUANT,SUM(D2_TOTAL) AS TOTAL,SUM(D2_VALICM) AS ICMS, SUM(D2_VALIPI) AS IPI, "
_cQ += " SUM(D2_VALIMP5 + D2_VALIMP6) AS PIS_COFINS,SUM(D2_TOTAL-D2_VALICM-D2_VALIPI-D2_VALIMP5-D2_VALIMP6) AS VALOR_MERC FROM SD2010 D2 (NOLOCK) "
_cQ += " INNER JOIN SF4010 F4 (NOLOCK) ON F4_CODIGO = D2_TES "
_cQ += " INNER JOIN SB1010 B1 (NOLOCK)ON B1_COD = D2_COD "
_cQ += " WHERE D2.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' "
_cQ += " AND D2_TIPO = 'N' AND B1_TIPO = 'PA' AND F4_DUPLIC = 'S' AND F4_ESTOQUE = 'S' "
_cQ += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQ += " AND D2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_cQ += " GROUP BY D2_COD,B1_DESC "
_cQ += " ORDER BY D2_COD "

TCQUERY _cQ NEW ALIAS "ZZ"

/*
_cArq := CriaTrab(NIL,.F.)
Copy To &_cArq

dbCloseArea()

dbUseArea(.T.,,_cArq,"ZZ",.T.)
  */

_cArqNew := "\SPOOL\PA0183.DBF"
dbSelectArea("ZZ")

COPY ALL TO &_cArqNew

dbCloseArea("ZZ")
	
If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf
	
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "\\SERVER2\erp\PROTHEUS11\PROTHEUS_DATA\spool\PA0183.DBF" )
oExcelApp:SetVisible(.T.)

Return


Static Function AtuSX1()

cPerg := "PA0183"
aRegs := {}

///////////////////////////////////////////
/////  GRUPO DE PERGUNTAS /////////////////
///////////////////////////////////////////

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Emissao de  ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Emissao ate ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"03","Produto de  ?",""       ,""      ,"mv_ch3","C" ,15     ,0      ,0     ,"G",""            ,"MV_PAR03",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"04","Produto ate ?",""       ,""      ,"mv_ch4","C" ,15     ,0      ,0     ,"G",""            ,"MV_PAR04",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return
