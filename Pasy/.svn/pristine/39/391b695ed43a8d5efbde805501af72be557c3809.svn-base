#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ PA0157  ³ Autor ³ Fabiano da Silva       ³ Data ³ 27/02/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Eficiencia de entrega (Pedido de Vendas)                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0157()

Private _cAlias
Private _cDescPa := ""
_aAliOri   := GetArea()
_cLocPad   := _cQtCav := ""
_nSdoAcab  := 0
_nMedida   := 0
_cComposto := _cMolde := _cInserto := ""
_nOpc      := 0

Atu_SX1()

@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Eficiencia de entrega")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina criado para Gerar Eficiencia de Entrega "     SIZE 160,7
@ 18,18 SAY "                                               "     SIZE 160,7
@ 26,18 SAY "                                               "     SIZE 160,7
@ 34,18 SAY "Programa PA0157.PRW                            "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0157")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	PA157A()
Endif

Return


Static Function PA157A()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA157B(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cArqNovo := "\SPOOL\PA0157.DBF"
dbSelectArea(_cAlias)

Copy all to &_cArqNovo
dbCloseArea()

If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\SPOOL\PA0157.DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return


Static Function PA157B(_lFim)

Pergunte("PA0157",.F.)

Private _nNiv := 0
Private _lGravou := .F.

aStru := {}
AADD(aStru,{"CLIENTE" , "C" , 06, 0 })
AADD(aStru,{"LOJA"    , "C" , 02, 0 })
AADD(aStru,{"NOMECLI" , "C" , 40, 0 })
AADD(aStru,{"QTDPROG" , "N" , 12, 4 })
AADD(aStru,{"ENTR_AN" , "N" , 12, 4 })
AADD(aStru,{"ENTR_OK" , "N" , 12, 4 })
AADD(aStru,{"ENTR_AT" , "N" , 12, 4 })
AADD(aStru,{"NENT_OK" , "N" , 12, 4 })
AADD(aStru,{"NENT_AT" , "N" , 12, 4 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "CLIENTE+LOJA"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

//Pedidos em aberto atrasados
_cQuery  := " SELECT C6_CLI,C6_LOJA,A1_NOME,C5_EMISSAO,C6_NUM,C6_ITEM,C6_QTDVEN AS QTDVEN,C6_QTDENT AS QTDENT,C6_ENTREG,COALESCE(F2_DTENTR,'') AS F2_DTENTR "
_cQuery  += " FROM "+RetSqlName("SC6")+" C6 "
_cQuery  += " INNER JOIN "+RetSqlName("SC5")+" C5 ON C5_NUM = C6_NUM "
_cQuery  += " INNER JOIN "+RetSqlName("SA1")+" A1 ON A1_COD+A1_LOJA = C6_CLI+C6_LOJA "
_cQuery  += " INNER JOIN "+RetSqlName("SF4")+" F4 ON F4_CODIGO = C6_TES "
_cQuery  += " LEFT  JOIN "+RetSqlName("SD2")+" D2 ON D2_PEDIDO+D2_ITEMPV = C6_NUM+C6_ITEM AND D2.D_E_L_E_T_ = '' "
_cQuery  += " LEFT  JOIN "+RetSqlName("SF2")+" F2 ON D2_SERIE+D2_DOC = F2_SERIE+F2_DOC AND F2.D_E_L_E_T_ = '' "
_cQuery  += " WHERE C6.D_E_L_E_T_ = '' AND C5.D_E_L_E_T_ = '' AND A1.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' "
_cQuery  += " AND C5_TIPO = 'N' "
_cQuery  += " AND C6_ENTREG BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
//_cQuery  += " AND C6_QTDVEN > C6_QTDENT AND C6_BLQ <> 'R' AND C6_PEDAMOS = 'N' "
_cQuery  += " AND C6_BLQ <> 'R' AND C6_PEDAMOS = 'N' "
_cQuery  += " AND C6_CLI BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND C6_LOJA BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
_cQuery  += " AND F4_DUPLIC = 'S' "
//_cQuery  += " AND F2_DTENTR <> '' "
_cQuery  += " ORDER BY C6_CLI,C6_LOJA "

TCQUERY _cQuery NEW ALIAS "ZZ"

TCSETFIELD("ZZ","C6_ENTREG","D")
TCSETFIELD("ZZ","F2_DTENTR","D")
TCSETFIELD("ZZ","QTDVEN","N",12,2)
TCSETFIELD("ZZ","QTDENT","N",12,2)

If MV_PAR09 = 1
	
	ZZ->(dbGotop())
	
	ProcRegua(ZZ->(U_CONTREG()))
	
	lContinua := .T.
	
	While ZZ->(!Eof()) .And. lContinua
		
		IncProc()
		
		IF lEnd
			@ Prow()+1,001 Psay "CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		Endif
		
		dbSelectArea("TRB")
		If !dbSeek(ZZ->C6_CLI+ZZ->C6_LOJA)
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->CLIENTE	:= ZZ->C6_CLI
			TRB->LOJA		:= ZZ->C6_LOJA
			TRB->NOMECLI	:= ZZ->A1_NOME
			TRB->QTDPROG	:= 1
			If !Empty(ZZ->F2_DTENTR) .And. ZZ->QTDENT = ZZ->QTDVEN
				If ZZ->C6_ENTREG < (ZZ->F2_DTENTR - 2)
					TRB->ENTR_AN	:= 1
					TRB->ENTR_OK	:= 0
					TRB->ENTR_AT	:= 0
					TRB->NENT_OK	:= 0
					TRB->NENT_AT	:= 0
				ElseIf (ZZ->C6_ENTREG = ZZ->F2_DTENTR) .Or. (ZZ->C6_ENTREG >= (ZZ->F2_DTENTR -2) .And. ZZ->C6_ENTREG <= ZZ->F2_DTENTR)
					TRB->ENTR_AN	:= 0
					TRB->ENTR_OK	:= 1
					TRB->ENTR_AT	:= 0
					TRB->NENT_OK	:= 0
					TRB->NENT_AT	:= 0
				Else
					TRB->ENTR_AN	:= 0
					TRB->ENTR_OK	:= 0
					TRB->ENTR_AT	:= 1
					TRB->NENT_OK	:= 0
					TRB->NENT_AT	:= 0
				Endif
			Else
				If ZZ->C6_ENTREG >= dDatabase
					TRB->ENTR_AN	:= 0
					TRB->ENTR_OK	:= 0
					TRB->ENTR_AT	:= 0
					TRB->NENT_OK	:= 1
					TRB->NENT_AT	:= 0
				Else
					TRB->ENTR_AN	:= 0
					TRB->ENTR_OK	:= 0
					TRB->ENTR_AT	:= 0
					TRB->NENT_OK	:= 0
					TRB->NENT_AT	:= 1
				Endif
			Endif
			MsUnlock()
		Else
			dbSelectArea("TRB")
			RecLock("TRB",.F.)
			TRB->QTDPROG	++
			If !Empty(ZZ->F2_DTENTR)
				If ZZ->C6_ENTREG < (ZZ->F2_DTENTR - 2)
					TRB->ENTR_AN	++
				ElseIf (ZZ->C6_ENTREG = ZZ->F2_DTENTR) .Or. (ZZ->C6_ENTREG >= (ZZ->F2_DTENTR -2) .And. ZZ->C6_ENTREG <= ZZ->F2_DTENTR)
					TRB->ENTR_OK	++
				Else
					TRB->ENTR_AT	++
				Endif
			Else
				If ZZ->C6_ENTREG >= dDatabase
					TRB->NENT_OK	++
					
				Else
					TRB->NENT_AT	++
				Endif
			Endif
			
			MsUnlock()
		Endif
		
		dbSelectArea("ZZ")
		dbSkip()
	Enddo
	
	ZZ->(dbcloseArea())
	
	_cAlias := "TRB"
	
Else
	
	_cAlias := "ZZ"
	
Endif

Return


Static Function Atu_SX1()

cPerg := "PA0157"
aRegs :={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                            ³
//³ mv_par01        	// Do Pedido                                ³
//³ mv_par02        	// Ate o Pedido                             ³
//³ mv_par03 	     	// Data de Entrega De                       ³
//³ mv_par04 	     	// Data de Entrega Ate                      ³
//³ mv_par05 	     	// Cliente De                               ³
//³ mv_par06 	     	// Cliente Ate                              ³
//³ mv_par07 	     	// Loja De                                  ³
//³ mv_par08 	     	// Loja Ate                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄ¿

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02	/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Pedido de             ?",""       ,""      ,"mv_ch1","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   		,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Pedido Ate            ?",""       ,""      ,"mv_ch2","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   		,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"03","Entrega De            ?",""       ,""      ,"mv_ch3","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR03",""               ,""     ,""     ,""   ,""   		,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"04","Entrega Ate           ?",""       ,""      ,"mv_ch4","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR04",""               ,""     ,""     ,""   ,""   		,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"05","Cliente De            ?",""       ,""      ,"mv_ch5","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR05",""               ,""     ,""     ,""   ,""   		,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CLI")
U_CRIASX1(cPerg,"06","Cliente Ate           ?",""       ,""      ,"mv_ch6","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR06",""               ,""     ,""     ,""   ,""   		,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CLI")
U_CRIASX1(cPerg,"07","Loja De               ?",""       ,""      ,"mv_ch7","C" ,02     ,0      ,0     ,"G",""            ,"MV_PAR07",""               ,""     ,""     ,""   ,""   		,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"08","Loja Ate              ?",""       ,""      ,"mv_ch8","C" ,02     ,0      ,0     ,"G",""            ,"MV_PAR08",""               ,""     ,""     ,""   ,""   		,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"09","Tipo                  ?",""       ,""      ,"mv_ch9","N" ,01     ,0      ,0     ,"C",""            ,"MV_PAR09","Sintetico"      ,""     ,""     ,""   ,""         ,"Analítico"      ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return
