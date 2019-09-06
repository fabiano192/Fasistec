#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ PA0156  ³ Autor ³ Fabiano da Silva       ³ Data ³ 27/02/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relacao de Pedidos aptos a faturar(Excel)                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0156()

_aAliOri := GetArea()
Private _cDescPa := ""
_cLocPad   := _cQtCav := ""
_nSdoAcab  := 0                                        
_nMedida   := 0
_cComposto := _cMolde := _cInserto := ""
_nOpc      := 0

Atu_SX1()

@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Pedidos a Faturar")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina criado para Gerar Pedidos a Faturar "     SIZE 160,7
@ 18,18 SAY "                                           "     SIZE 160,7
@ 26,18 SAY "                                           "     SIZE 160,7
@ 34,18 SAY "Programa PA0156.PRW                        "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0156")
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

_cArqNovo := "\SPOOL\PA0156.DBF"
dbSelectArea("TRB")

Copy all to &_cArqNovo
dbCloseArea()

If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf

If UPPER(ALLTRIM(SUBSTR(cUsuario,7,15))) $ "PSILVA"
	CpyS2T( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\SPOOL\PA0156.DBF", "C:\TOTVS", .F. )
	MsgInfo("Arquiv PA0156.DBF gerado na pasta C:\Totvs com sucesso!! Para abrir este arquivo utilize o Excel.")
Else

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\SPOOL\PA0156.DBF" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)

Endif


Return


Static Function Proc1(_lFim)

Pergunte("PA0156",.F.)

Private _nNiv := 0
Private _lGravou := .F.

aStru := {}
AADD(aStru,{"EMISSAO"     , "D" , 08, 0 })
AADD(aStru,{"CLIENTE"     , "C" , 06, 0 })
AADD(aStru,{"LOJA"        , "C" , 02, 0 })
AADD(aStru,{"NOMECLI"     , "C" , 40, 0 })
AADD(aStru,{"PRODUTO"     , "C" , 15, 0 })
AADD(aStru,{"DTENTR"      , "C" , 08, 0 })
//AADD(aStru,{"DTENTR"      , "D" , 08, 0 })
AADD(aStru,{"PRODCLI"     , "C" , 15, 0 })
AADD(aStru,{"PEDIDO"      , "C" , 06, 0 })
AADD(aStru,{"ITEMPV"      , "C" , 02, 0 })
AADD(aStru,{"TIPOPV"      , "C" , 01, 0 })
AADD(aStru,{"QTDPED"      , "N" , 12, 4 })
AADD(aStru,{"QTDENT"      , "N" , 12, 4 })
AADD(aStru,{"QTDSDO"      , "N" , 12, 4 })
AADD(aStru,{"PRUNIT"      , "N" , 12, 5 })
AADD(aStru,{"PRUSAL"      , "N" , 12, 4 })
AADD(aStru,{"PEDCLI"      , "C" , 20, 0 })
AADD(aStru,{"RELEASE"     , "C" , 15, 0 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "CLIENTE+PRODUTO+PEDIDO"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

_cQuery  := " SELECT C6_NUM,C6_ITEM,C6_PRODUTO,C6_CPROCLI,C6_PEDAMOS,C6_CLI,C6_LOJA,B1_DESC,A1_NOME,C5_EMISSAO,C6_ENTREG,C6_PEDCLI,C6_REVPED, "
_cQuery  += " SUM(C6_QTDVEN) AS QTDVEN,SUM(C6_QTDENT) AS QTDENT,SUM(C6_PRCVEN) AS PRCVEN,SUM(C6_PRUNIT) AS PRUNIT, SUM(C6_VALDESC) AS VALDESC FROM SC6010 C6 "
_cQuery  += " INNER JOIN SC5010 C5 ON C5_NUM = C6_NUM "
_cQuery  += " INNER JOIN SB1010 B1 ON B1_COD = C6_PRODUTO "
_cQuery  += " INNER JOIN SA1010 A1 ON A1_COD+A1_LOJA = C6_CLI+C6_LOJA "
_cQuery  += " INNER JOIN SF4010 F4 ON F4_CODIGO = C6_TES "
_cQuery  += " WHERE C6.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' AND C5.D_E_L_E_T_ = '' AND A1.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' "
_cQuery  += " AND C6_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
_cQuery  += " AND C6_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_cQuery  += " AND C6_ENTREG BETWEEN '"+DTOS(MV_PAR06)+"' AND '"+DTOS(MV_PAR07)+"' "
_cQuery  += " AND C6_CLI BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' "
_cQuery  += " AND C6_BLQ <> 'R' "
_cQuery  += " AND C6_QTDVEN > C6_QTDENT "
_cQuery  += " AND B1_GRUPO BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"' "
_cQuery  += " AND B1_SUBGR BETWEEN '"+MV_PAR14+"' AND '"+MV_PAR15+"' "
If MV_PAR05 = 1
	_cQuery  += " AND F4_DUPLIC = 'S' "
ElseIf MV_PAR05 = 2
	_cQuery  += " AND F4_DUPLIC <> 'S' "
Endif
_cQuery  += " GROUP BY C6_NUM,C6_ITEM,C6_PRODUTO,C6_CPROCLI,C6_PEDAMOS,C6_CLI,C6_LOJA,B1_DESC,A1_NOME,C5_EMISSAO,C6_ENTREG,C6_PEDCLI,C6_REVPED "
_cQuery  += " ORDER BY C6_NUM,C6_ITEM,C6_PRODUTO "

TCQUERY _cQuery NEW ALIAS "QC6"

TCSETFIELD("QC6","C6_ENTREG","D")
TCSETFIELD("QC6","C5_EMISSAO","D")
TCSETFIELD("QC6","QTDVEN","N",12,4)
TCSETFIELD("QC6","QTDENT","N",12,4)
TCSETFIELD("QC6","PRCVEN","N",12,5)
TCSETFIELD("QC6","VALDESC","N",12,4)

QC6->(dbGotop())

ProcRegua(QC6->(U_CONTREG()))

nAg1      := nAg2     :=  nAg3   := _nGeDesc  := _nGeaFat := _nGeIPI := 0
nValIpi   := nTotIpi  := nQtlib  := nQtBloq   := _nToPed  := nValIpi := 0
lContinua := .T.
        
While QC6->(!Eof()) .And. lContinua
	
	IF lEnd
		@ Prow()+1,001 Psay "CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	Endif
	
	IncProc()
	
	_cPed   := ""			
	For Ax:= 1 To Len(MV_PAR16)
		If Substr(MV_PAR16,AX,1) != "*"
		   _cPed += Substr(MV_PAR16,AX,1)+ "/"
	    Endif
	Next AX         
		                               

	If QC6->C6_PEDAMOS != "N"
		_lPare := .T.
	Endif
		      
	If QC6->C6_NUM = "011633" .AND. QC6->C6_ITEM = "TP"
		_lPare := .T.
	Endif		
		
	If !QC6->C6_PEDAMOS $ _cPed
		dbSelectArea("QC6")
		dbSkip()
		Loop
	Endif				
					       	
	If QC6->PRUNIT > 0
		nRet :=(QC6->PRUNIT-QC6->PRCVEN)*(QC6->QTDVEN-QC6->QTDENT)
	Else
		nRet := QC6->VALDESC
	EndIf

   	_nDesc  := nRet
   	_nValor := (QC6->QTDVEN-QC6->QTDENT)*QC6->PRCVEN
					
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->EMISSAO	:= QC6->C5_EMISSAO
	TRB->CLIENTE	:= QC6->C6_CLI
	TRB->LOJA		:= QC6->C6_LOJA
	TRB->NOMECLI	:= QC6->A1_NOME
	TRB->PRODUTO	:= QC6->C6_PRODUTO
	TRB->DTENTR		:= DTOC(QC6->C6_ENTREG)
	TRB->PRODCLI	:= QC6->C6_CPROCLI
	TRB->PEDIDO		:= QC6->C6_NUM
	TRB->ITEMPV		:= QC6->C6_ITEM
	TRB->PEDCLI		:= QC6->C6_PEDCLI
	TRB->RELEASE	:= QC6->C6_REVPED
	TRB->TIPOPV		:= QC6->C6_PEDAMOS
	TRB->QTDPED		:= QC6->QTDVEN
	TRB->QTDENT		:= QC6->QTDENT
	TRB->QTDSDO		:= QC6->QTDVEN - QC6->QTDENT
	TRB->PRUNIT		:= QC6->PRCVEN
	TRB->PRUSAL		:= QC6->PRCVEN * TRB->QTDSDO
	MsUnlock()
	
	dbSelectArea("QC6")
	dbSkip()
Enddo

dbSelectArea("QC6")
dbCloseArea()

Return


Static Function Atu_SX1()

cPerg := "PA0156"
aRegs :={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                            ³
//³ mv_par01        	// Do Pedido                                ³
//³ mv_par02        	// Ate o Pedido                             ³
//³ mv_par03        	// Do Produto                               ³
//³ mv_par04 	     	// Ate o Produto                            ³
//³ mv_par05 	     	// Quanto ao Tes- Gera Dupl, Nao Gera, Todos³
//³ mv_par10 	     	// Data de Entrega De                       ³
//³ mv_par11 	     	// Data de Entrega Ate                      ³
//³ mv_par12 	     	// Cliente De                               ³
//³ mv_par13 	     	// Cliente Ate                              ³
//³ mv_par14 	     	// Loja De                                  ³
//³ mv_par15 	     	// Loja Ate                                 ³
//³ mv_par16 	     	// Grupo De                                 ³
//³ mv_par17 	     	// Grupo Ate                                ³
//³ mv_par18 	     	// SubGrupo De                              ³
//³ mv_par19 	     	// SubGrupo Ate                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄ¿


//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Pedido de             ?",""       ,""      ,"mv_ch1","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Pedido Ate            ?",""       ,""      ,"mv_ch2","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"03","Produto De            ?",""       ,""      ,"mv_ch3","C" ,15     ,0      ,0     ,"G",""            ,"MV_PAR03",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
U_CRIASX1(cPerg,"04","Produto Ate           ?",""       ,""      ,"mv_ch4","C" ,15     ,0      ,0     ,"G",""            ,"MV_PAR04",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
U_CRIASX1(cPerg,"05","Quanto ao Tes         ?",""       ,""      ,"mv_ch5","N" ,01     ,0      ,0     ,"C",""            ,"MV_PAR05","Gera Duplic."   ,""     ,""     ,""   ,""   ,"Nao Gera Duplic",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"06","Entrega De            ?",""       ,""      ,"mv_ch6","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR06",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"07","Entrega Ate           ?",""       ,""      ,"mv_ch7","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR07",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"08","Cliente De            ?",""       ,""      ,"mv_ch8","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR08",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CLI")
U_CRIASX1(cPerg,"09","Cliente Ate           ?",""       ,""      ,"mv_ch9","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR09",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CLI")
U_CRIASX1(cPerg,"10","Loja De               ?",""       ,""      ,"mv_cha","C" ,02     ,0      ,0     ,"G",""            ,"MV_PAR10",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"11","Loja Ate              ?",""       ,""      ,"mv_chb","C" ,02     ,0      ,0     ,"G",""            ,"MV_PAR11",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"12","Grupo De              ?",""       ,""      ,"mv_chc","C" ,04     ,0      ,0     ,"G",""            ,"MV_PAR12",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SBM")
U_CRIASX1(cPerg,"13","Grupo Ate             ?",""       ,""      ,"mv_chd","C" ,04     ,0      ,0     ,"G",""            ,"MV_PAR13",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SBM")
U_CRIASX1(cPerg,"14","SubGrupo De           ?",""       ,""      ,"mv_che","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR14",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"Z1")
U_CRIASX1(cPerg,"15","SubGrupo Ate          ?",""       ,""      ,"mv_chf","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR15",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"Z1")
U_CRIASX1(cPerg,"16","Quais Pedidos         ?",""       ,""      ,"mv_chg","C" ,06     ,0      ,0     ,"G","U_FTIPOPED()","MV_PAR16",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return
