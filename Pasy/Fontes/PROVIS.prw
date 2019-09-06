#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PROVIS   บ Autor ณ Fabiano da Silva บ Data ณ    12/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Dados da NF (Fiscal)	    		                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFIS                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PROVIS()

ATUSX1()

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Relat๓rio Em Excel")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina Gerar o Relat๓rio em excel dos dados da NF   "     SIZE 160,7
@ 18,18 SAY "Conforme parametros Informados pelo Usuario		 "     SIZE 160,7
@ 26,18 SAY "                                                    "     SIZE 160,7
@ 34,18 SAY "Programa PROVIS.PRW                                 "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PROVIS")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	
	Pergunte("PROVIS",.F.)
	
	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| PROV_A(@_lFim) }
	Private _cTitulo01 := 'Selecionado Registros!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
	_cArqNew := "\SPOOL\PROVIS.DBF"

	dbSelectArea("ZZ")
	COPY ALL TO &_cArqNew
	
	dbCloseArea("ZZ")
	
//	If ! ApOleClient( 'MsExcel' )
//		MsgStop('MsExcel nao instalado')
//		Return
//	EndIf
	
//	MSGINFO("RELATORIO GERADO COM SUCESSO!!")
	
//	oExcelApp := MsExcel():New()
//	oExcelApp:WorkBooks:Open( "\\NSSRV-MSGA\ERP\MP_DATA\SPOOL\PROVIS.DBF" ) // Abre uma planilha
//	oExcelApp:SetVisible(.T.)

//	If UPPER(ALLTRIM(SUBSTR(cUsuario,7,15))) $ "PSILVA"
//		CpyS2T( "\\NSSRV-MSGA\ERP\MP_DATA\SPOOL\PROVIS.DBF", "C:\TOTVS", .F. )
//		MsgInfo("Arquiv PROVIS.DBF gerado na pasta C:\Totvs com sucesso!! Para abrir este arquivo utilize o Excel.")
//	ENDIF

Endif

Return (Nil)


Static Function PROV_A(_lFim)

_cQ := " SELECT D2_EMISSAO AS EMISSAO,D2_DOC AS DOC,D2_SERIE AS SERIE,D2_COD AS PRODUTO,B1_POSIPI AS NCM,B1_DESC AS DESCRICAO, "
_cQ += " D2_CLIENTE AS CLIENTE,D2_LOJA AS LOJA,A1_PESSOA AS TIPO,A1_NOME AS NOME,A1_CGC AS CNPJ,A1_INSCR AS IE,A1_EST AS UF,D2_CF AS CFOP, "
_cQ += " D2_QUANT AS QUANT,D2_PRCVEN AS UNIT,TOT_PROD = D2_QUANT * D2_PRCVEN,D2_TOTAL AS TOTAL,D2_BASEIPI AS BASE_IPI,D2_IPI AS PORC_IPI, "
_cQ += " D2_VALIPI AS VAL_IPI,D2_BASEICM AS BASE_ICM,D2_PICM AS POR_ICM,D2_VALICM AS VAL_ICM,D2_ICMSRET AS ICMS_RET,D2_BRICMS AS B_ICMS_R "
_cQ += " FROM "+RetSqlName("SD2")+" D2 "
_cQ += " INNER JOIN "+RetSqlName("SB1")+" B1 ON D2_COD = B1_COD "
_cQ += " INNER JOIN "+RetSqlName("SA1")+" A1 ON D2_CLIENTE+D2_LOJA = A1_COD+A1_LOJA "
_cQ += " WHERE D2.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' AND A1.D_E_L_E_T_ = '' AND D2_TIPO = 'N' "
_cQ += " AND A1_COD     BETWEEN '"+MV_PAR01+"'       AND '"+MV_PAR02+"' "
_cQ += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
_cQ += " ORDER BY A1_COD,A1_LOJA "

TCQUERY _cQ NEW ALIAS "ZZ"

TCSETFIELD("ZZ","DTINCL","D")

dbSelectArea("ZZ")

_cArq := CriaTrab(NIL,.F.)
Copy To &_cArq

dbCloseArea()

dbUseArea(.T.,,_cArq,"ZZ",.T.)

Return (Nil)


Static Function AtuSX1()

cPerg := "PROVIS"
aRegs := {}

////////////////////////////////////////////
/////  GRUPO DE PERGUNTAS //////////////////
///// MV_PAR01 - Cliente de		       	////
///// MV_PAR02 - Cliente ate	       	////
///// MV_PAR03 - Emissao De     		////
///// MV_PAR04 - Emissao Ate    		////
////////////////////////////////////////////

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Cliente De            ?",""       ,""      ,"mv_ch1","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SA1")
U_CRIASX1(cPerg,"02","Cliente Ate           ?",""       ,""      ,"mv_ch2","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SA1")
U_CRIASX1(cPerg,"03","Emissao De            ?",""       ,""      ,"mv_ch3","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR03",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"04","Emissao Ate           ?",""       ,""      ,"mv_ch4","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR04",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"05","Produto De            ?",""       ,""      ,"mv_ch5","C" ,15     ,0      ,0     ,"G",""            ,"MV_PAR05",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
U_CRIASX1(cPerg,"06","Produto Ate           ?",""       ,""      ,"mv_ch6","C" ,15     ,0      ,0     ,"G",""            ,"MV_PAR06",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")

Return (Nil)