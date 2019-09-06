#INCLUDE "Totvs.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa CR0017
Data		: 27/03/12
Uso 		: SIGAFAT - FAT
Descrição 	: Romaneio por produto
*/


User Function CR0017()

LOCAL oDlg := NIL

ATUSX1()

_nOpc := 0
DEFINE MSDIALOG oDlg FROM 0,0 TO 150,370 TITLE OemToAnsi("Relatório Em Excel") OF oDlg PIXEL

@ 05,05 TO 045,180 OF oDlg PIXEL
@ 10,10 SAY "Rotina Gerar o Arquivo DBF referente aos produtos das NF's que    " OF oDlg PIXEL
@ 20,10 SAY "estão no Romaneio conforme os parâmetros informados pelo usuário. " OF oDlg PIXEL
@ 30,10 SAY "Programa CR0017.PRW                                 			   " OF oDlg PIXEL

@ 50,10  BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("CR0017"))	OF oDlg PIXEL
@ 50,60  BUTTON "OK" 		 SIZE 036,012 ACTION (_nOpc:=1,oDlg:End()) 	OF oDlg PIXEL
@ 50,110 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1

	Pergunte("CR0017",.F.)

	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| CR017A(@_lFim) }
	Private _cTitulo01 := 'Selecionado Registros!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
Endif

Return


Static Function CR017A(_lFim)

_cQ1 := " SELECT D2_CLIENTE AS CLIENTE,D2_LOJA AS LOJA,A1_NOME AS NOME,D2_SERIE AS SERIE,D2_DOC AS NF,D2_EMISSAO AS EMISSAO, "
_cQ1 += " F2_DTENTR AS ENTREGA,D2_COD AS PRODUTO,D2_PROCLI AS PROD_CLI,D2_QUANT AS QUANT FROM "+RetSqlName("SD2")+" D2 "
_cQ1 += " INNER JOIN "+RetSqlName("SF2")+" F2 ON D2_SERIE+D2_DOC    = F2_SERIE+F2_DOC "
_cQ1 += " INNER JOIN "+RetSqlName("SA1")+" A1 ON D2_CLIENTE+D2_LOJA = A1_COD+A1_LOJA  "
_cQ1 += " WHERE D2.D_E_L_E_T_ = '' AND F2.D_E_L_E_T_ = '' AND A1.D_E_L_E_T_ = '' "
_cQ1 += " AND F2_DTENTR  BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQ1 += " AND D2_CLIENTE BETWEEN '"+MV_PAR03+"'       AND '"+MV_PAR04+"'       "
_cQ1 += " AND D2_LOJA    BETWEEN '"+MV_PAR05+"'       AND '"+MV_PAR06+"'       "
_cQ1 += " ORDER BY F2_DTENTR,D2_SERIE,D2_DOC,D2_ITEM "

TCQUERY _cQ1 NEW ALIAS "TRB"

TCSETFIELD("TRB","EMISSAO","D")
TCSETFIELD("TRB","ENTREGA","D")

Count To nRec

If nRec > 0
/*
	dbSelectArea("TRB")

	_cArq := CriaTrab(NIL,.F.)
	Copy To &_cArq

	dbCloseArea()

	dbUseArea(.T.,,_cArq,"TRB",.T.)
	*/
	GeraExcel()

Endif

Return (Nil)



static Function GeraExcel()

Local oFwMsEx 		:= NIL
Local cArq 			:= ""
Local cDir 			:= GetSrvProfString("Startpath","")
Local cWorkSheet	:= ""
Local cTable 		:= ""
Local cDirTmp 		:= GetTempPath()

oFwMsEx := FWMsExcel():New()

cWorkSheet 	:= 	"Romaneio"
cTable 		:= 	"Romaneio de Saida de Produto"

oFwMsEx:AddWorkSheet( cWorkSheet )
oFwMsEx:AddTable( cWorkSheet, cTable )

oFwMsEx:AddColumn( cWorkSheet, cTable , "Cliente"   		, 1,1,.F.)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Loja"   			, 1,1,.F.)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Nome"   			, 1,1,.F.)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Serie"				, 1,1,.F.)
oFwMsEx:AddColumn( cWorkSheet, cTable , "NF"  		 		, 1,1,.F.)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Emissão"   		, 1,4,.F.)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Entrega"  			, 1,4,.F.)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto"  			, 1,1,.F.)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Prod.Cliente"		, 1,1,.F.)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Quantidade"		, 3,2,.F.)

TRB->(dbGotop())

While !TRB->(Eof())

	oFwMsEx:AddRow( cWorkSheet, cTable,{;
	TRB->CLIENTE	,;
	TRB->LOJA    	,;
	TRB->NOME   	,;
	TRB->SERIE    	,;
	TRB->NF    		,;
	TRB->EMISSAO    ,;
	TRB->ENTREGA	,;
	TRB->PRODUTO   	,;
	TRB->PROD_CLI   ,;
	TRB->QUANT  	})

	TRB->(dbSkip())
EndDo

TRB->(dbCloseArea())

oFwMsEx:Activate()

cArq := CriaTrab( NIL, .F. ) + ".xml"

MsgRun( "Gerando o arquivo, aguarde...", "Romaneio de Produtos", {|| oFwMsEx:GetXMLFile( cArq ) } )

If __CopyFile( cArq, cDirTmp + cArq )
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cDirTmp + cArq )
	oExcelApp:SetVisible(.T.)
Else
	MsgInfo( "Arquivo não copiado para temporário do usuário." )

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cDir + cArq )
	oExcelApp:SetVisible(.T.)
Endif

Return


Static Function AtuSX1()

cPerg := "CR0017"
aRegs := {}

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Data Entrega De       ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Data Entrega Ate      ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"03","Cliente De            ?",""       ,""      ,"mv_ch3","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR03",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SA1")
U_CRIASX1(cPerg,"04","Cliente Ate           ?",""       ,""      ,"mv_ch4","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR04",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SA1")
U_CRIASX1(cPerg,"05","Loja De               ?",""       ,""      ,"mv_ch5","C" ,02     ,0      ,0     ,"G",""            ,"MV_PAR05",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"06","Loja Ate              ?",""       ,""      ,"mv_ch6","C" ,02     ,0      ,0     ,"G",""            ,"MV_PAR06",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return
