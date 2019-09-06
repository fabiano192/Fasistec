#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PA0204   บ Autor ณ Fabiano da Silva บ Data ณ    03/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Romaneio por produto                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFAT                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PA0204()

ATUSX1()

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Relat๓rio Em Excel")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina Gerar o Arquivo DBF referente aos produtos das NF's que    "     SIZE 160,7
@ 18,18 SAY "estใo no Romaneio conforme os parโmetros informados pelo usuแrio. "     SIZE 160,7
@ 26,18 SAY "     										                       "     SIZE 160,7
@ 34,18 SAY "Programa PA0204.PRW                                 			   "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0204")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	
	Pergunte("PA0204",.F.)
	
	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| PA204A(@_lFim) }
	Private _cTitulo01 := 'Selecionado Registros!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	        
	_cDir:= "C:\TOTVS\"
	
	If !ExistDir( _cDir )
		If MakeDir( _cDir ) <> 0
			MsgAlert(  "Impossํvel criar diretorio ( "+_cDir+" ) " )
			Return
		EndIf
	EndIf

	_cData   := DTOS(dDataBase)
	_cHora   := Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

	_cNomArq := "\SPOOL\ROMANEIO_"+_cData+"_"+_cHora+".XLS"
	
	dbSelectArea("ZZ")
	COPY ALL TO &_cNomArq
	
	dbCloseArea("ZZ")
	
	If !__CopyFile(_cNomArq, "C:\TOTVS\ROMANEIO_"+_cData+"_"+_cHora+".xls" )
		MSGAlert("O arquivo nใo foi copiado!", "AQUIVO NรO COPIADO!")
	Else

		FErase(_cNomArq)
		
		If ! ApOleClient( 'MsExcel' )
			MsgStop('MsExcel nao instalado')
			Return
		EndIf
	
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( "C:\TOTVS\ROMANEIO_"+_cData+"_"+_cHora+".xls" )
		oExcelApp:SetVisible(.T.)	
	Endif
Endif

Return


Static Function PA204A(_lFim)

_cQ1 := " SELECT D2_CLIENTE AS CLIENTE,D2_LOJA AS LOJA,A1_NOME AS NOME,D2_SERIE AS SERIE,D2_DOC AS NF,D2_EMISSAO AS EMISSAO, "
_cQ1 += " F2_DTENTR AS ENTREGA,D2_COD AS PRODUTO,D2_PROCLI AS PROD_CLI,D2_QUANT AS QUANT FROM "+RetSqlName("SD2")+" D2 "
_cQ1 += " INNER JOIN "+RetSqlName("SF2")+" F2 ON D2_SERIE+D2_DOC    = F2_SERIE+F2_DOC "
_cQ1 += " INNER JOIN "+RetSqlName("SA1")+" A1 ON D2_CLIENTE+D2_LOJA = A1_COD+A1_LOJA  "
_cQ1 += " WHERE D2.D_E_L_E_T_ = '' AND F2.D_E_L_E_T_ = '' AND A1.D_E_L_E_T_ = '' "
_cQ1 += " AND F2_DTENTR  BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQ1 += " AND D2_CLIENTE BETWEEN '"+MV_PAR03+"'       AND '"+MV_PAR04+"'       "
_cQ1 += " AND D2_LOJA    BETWEEN '"+MV_PAR05+"'       AND '"+MV_PAR06+"'       "
_cQ1 += " ORDER BY F2_DTENTR,D2_SERIE,D2_DOC,D2_ITEM "

TCQUERY _cQ1 NEW ALIAS "ZZ"

TCSETFIELD("ZZ","EMISSAO","D")
TCSETFIELD("ZZ","ENTREGA","D")

dbSelectArea("ZZ")

_cArq := CriaTrab(NIL,.F.)
Copy To &_cArq

dbCloseArea()

dbUseArea(.T.,,_cArq,"ZZ",.T.)

Return (Nil)


Static Function AtuSX1()

cPerg := "PA0204"
aRegs := {}

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Data Entrega De       ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Data Entrega Ate      ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"03","Cliente De            ?",""       ,""      ,"mv_ch3","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR03",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SA1")
U_CRIASX1(cPerg,"04","Cliente Ate           ?",""       ,""      ,"mv_ch4","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR04",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SA1")
U_CRIASX1(cPerg,"05","Loja De               ?",""       ,""      ,"mv_ch5","C" ,02     ,0      ,0     ,"G",""            ,"MV_PAR05",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"06","Loja Ate              ?",""       ,""      ,"mv_ch6","C" ,02     ,0      ,0     ,"G",""            ,"MV_PAR06",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return
