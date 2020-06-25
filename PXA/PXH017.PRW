#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PXH017   º Autor ³ Magnago            º Data ³  13/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para regravar a tabela ZZD                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Geracao do arquivo ZZD - EXPORTA PARA BI                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PXH017(_cSched)

Private dPartir 	:= dDtAte := Ctod("  /  /  ")
Private _lSchedule  := If(_cSched = Nil, .F.,.T.)

//Private cRevisao:=Space(4)
//cRevisao:="R01"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Janela principal                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _lSchedule
	PREPARE ENVIRONMENT EMPRESA "16" FILIAL "09201"
	
	CONOUT("Início Atualização ZZD")
	dPartir	:= dDatabase-1
	dDtAte	:= dDatabase-1
	
	fGeraTRB()
	
	CONOUT("Fim Atualização ZZD")
	
	RESET ENVIRONMENT
	
Else
	Private lop := MsgBox("Regravar os Dados da Tabela ZZD ?","Atencao","YESNO")
	If lop
		@ 90,40  To 250,300 Dialog oDlg1 Title "Regrava Tabela ZZD"
		@ 08,10  To 60,120
		@ 20,15  Say "A Partir De :"
		@ 20,55  Get dPartir Picture "@D"
		
		@ 30,15  Say "Até a Data:"
		@ 30,55  Get dDtAte  Picture "@D"
		
		//@ 40,15  Say "Revidao Nr:"
		//@ 40,55  Get cRevisao  Picture "@!" Valid(!Empty(Posicione('SX5',1,xFilial('SX5')+'ZD'+cRevisao,"X5_DESCENG")))	 F3 "ZD"
		
		@ 65,20  BmpButton Type 1 Action FRegZZD()
		@ 65,80  BmpButton Type 2 Action Close(oDlg1)
		Activate Dialog oDlg1 Centered
	EndIf
	
	ExecBlock("BrowseZZD")
Endif

Return



Static Function FRegZZD()

//If Empty(Posicione('SX5',1,xFilial('SX5')+'ZD'+cRevisao,"X5_DESCENG")); Return; Endif

_lEnd   := .f.
LjMsgRun(OemToAnsi("Aguarde, Regravando ZZD..."),("Atencao"),{| _lEnd | fGeraTRB() } )

Return

Static Function fGeraTRB()

Local cFonteZZD:=''

If !_lSchedule
	Close(oDlg1)
Endif

Private cDoc     := Space(06)
Private cSerie   := Space(03)
Private cCliente := Space(06)
Private cLoja    := Space(02)
Private aLogErr  := {}
Private _cProduto:= Space(15)

cQuery := "DELETE "
cQuery += "FROM "+RetSqlName("ZZD")+" "
cQuery += "WHERE ZZD_FILIAL    = '"+xFilial("ZZD")+ "'"
cQuery += "  AND ZZD_CODEMP    = '"+cEmpAnt+"'"
cQuery += "  AND ZZD_CODFIL    = '"+cFilAnt+"'"
cQuery += "  AND ZZD_SERIE  BETWEEN '   '      AND 'ZZZ'
cQuery += "  AND ZZD_DOC    BETWEEN '      '   AND 'ZZZZZZ'
cQuery += "  AND ZZD_EMIS   BETWEEN '"+Dtos(dPartir)+"' AND '"+Dtos(dDtAte)+"'"
//memowrite("\cfglog\reproszzd2.txt",cQuery)
TCSQLExec(cQuery)

cQry := ""
cQry += " SELECT * "
cQry += " FROM "+RetSqlName("SF2")+", "+ RetSqlName("SD2")
cQry += " WHERE "+RetSqlName("SF2")+".D_E_L_E_T_ =  '' AND "+ RetSqlName("SD2")+".D_E_L_E_T_ =  ''"
cQry += "       AND F2_FILIAL  =  '"+xFilial("SF2")+"'"
cQry += "       AND F2_FILIAL  =  D2_FILIAL "
cQry += "       AND F2_DOC  =  D2_DOC "
cQry += "       AND F2_SERIE  =  D2_SERIE "
cQry += "       AND F2_CLIENTE  =  D2_CLIENTE "
cQry += "       AND F2_LOJA  =  D2_LOJA "
cQry += "       AND F2_EMISSAO BETWEEN '"+Dtos(dPartir)+"'	AND '"+Dtos(dDtAte)+"'"

cQry += "ORDER BY F2_EMISSAO,F2_SERIE,F2_DOC "

//memowrite("\cfglog\reproszzd.txt",cqry)

TcQuery cQry New Alias "QRYSF2"
While !QRYSF2->(Eof())
	cDoc     := QRYSF2->F2_DOC
	cSerie   := QRYSF2->F2_SERIE
	cCliente := QRYSF2->F2_CLIENTE
	cLoja    := QRYSF2->F2_LOJA
	_cProduto:= QRYSF2->D2_COD
	
	U_PXH018()//MAX1100()
	
	dbSelectArea("QRYSF2")
	QRYSF2->(dbSkip())
Enddo

dbCloseArea("QRYSF2")

cQry := ""
cQry += " SELECT * "
cQry += " FROM "+RetSqlName("SF1")+", "+ RetSqlName("SD1")
cQry += " WHERE "+RetSqlName("SF1")+".D_E_L_E_T_ =  '' AND "+ RetSqlName("SD1")+".D_E_L_E_T_ =  ''"
cQry += "       AND F1_FILIAL   =  '"+xFilial("SF1")+"'"
cQry += "       AND F1_FILIAL   =  D1_FILIAL "
cQry += "       AND F1_DOC      =  D1_DOC "
cQry += "       AND F1_SERIE    =  D1_SERIE "
cQry += "       AND F1_FORNECE  =  D1_FORNECE "
cQry += "       AND F1_LOJA     =  D1_LOJA "
cQry += "       AND F1_DTDIGIT BETWEEN '"+Dtos(dPartir)+"'	AND '"+Dtos(dDtAte)+"' AND F1_TIPO = 'D' "
cQry += "ORDER BY F1_DTDIGIT,F1_SERIE,F1_DOC "

//memowrite("\cfglog\reproszzd1.txt",cqry)

TcQuery cQry New Alias "QRYSF1"

While !QRYSF1->(Eof())
	cDoc     := QRYSF1->F1_DOC
	cSerie   := QRYSF1->F1_SERIE
	cCliente := QRYSF1->F1_FORNECE
	cLoja    := QRYSF1->F1_LOJA
	_cProduto:= QRYSF1->D1_COD
	
	//	U_MAX010()
	
	dbSelectArea("QRYSF1")
	QRYSF1->(dbSkip())
	
Enddo
dbCloseArea("QRYSF1")

if len(alogerr)>0
	if upper( alltrim( substr( cusuario,7,15 ) ) ) == 'ADMINISTRADOR'
		Alert( 'ATENCAO!  Foram encontradadas inconsistencias durante o processamento. Consulte o arquivo:  \cfglog\zzd_erros.txt' )
		u_setLogErr(alogErr)
		cCaminho:= GetSrvProfString("RootPath","")+"\cfglog\zzd_erros.txt"
		WinExec("NOTEPAD "+ cCaminho ,1)
	endif
Endif

Return
  

User Function BrowseZZD

Private cCadastro:= "Tabela do Exporta - ZZD"
Private aRotina  := {{"Pesquisar","AxPesqui",0,1},;
{"Visualizar","AxVisual",0,2},;
{"Incluir","AxInclui",0,3},;
{"Alterar","AxAltera",0,4},;
{"Excluir","AxDeleta",0,5}}

Private cDelFunc := ".t."

dbSelectArea("ZZD")
dbSetOrder(1)

MBrowse(6,1,22,75,"ZZD")

Return
