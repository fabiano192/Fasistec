#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0158   ³ Autor ³ Fabiano da Silva      ³ Data ³ 12.03.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relação de itens vendidos com Material                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0158()

_aAliOri := GetArea()
Private _cDescPa := ""
_nOpc      := 0      

Atu_SX1()

@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Gerando Tabela...")
@ 02,10 TO 080,220
@ 10,18 SAY "Relação de itens vendidos com Material    "     SIZE 160,7
@ 18,18 SAY "                                          "     SIZE 160,7
@ 26,18 SAY "                                          "     SIZE 160,7
@ 34,18 SAY "Programa PA0158.PRW                       "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0158")
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

_cArqNovo := "\SPOOL\PA0158.DBF"
dbSelectArea("TRB")

Copy all to &_cArqNovo
dbCloseArea()

If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\SPOOL\PA0158.DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return


Static Function Proc1(_lFim)

Pergunte("PA0158",.F.)

Private _nNiv := 0
Private _lGravou := .F.
aStru := {}
AADD(aStru,{"CLIENTE"     , "C" , 06, 0 })
AADD(aStru,{"NOMECLI"     , "C" , 40, 0 })
AADD(aStru,{"LOJA"        , "C" , 02, 0 })
AADD(aStru,{"PRODUTO"     , "C" , 15, 0 })
AADD(aStru,{"NOMPROD"     , "C" , 50, 0 })
AADD(aStru,{"PRODCLI"     , "C" , 15, 0 })
AADD(aStru,{"COMPOSTO"    , "C" , 45, 0 })
AADD(aStru,{"ULTPRECO"    , "N" , 12, 4 })
AADD(aStru,{"DTULTPRE"    , "D" , 08, 0 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "PRODUTO+CLIENTE+LOJA"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")


_cQ := " SELECT * FROM SZ2010 Z2 INNER JOIN SB1010 B1 ON Z2_PRODUTO=B1_COD "
_cQ += " WHERE B1.D_E_L_E_T_ = '' AND Z2.D_E_L_E_T_ = '' "
_cQ += " AND B1_GRUPO   BETWEEN '"+MV_PAR03+"'       AND '"+MV_PAR04+"' "
_cQ += " AND B1_COD     BETWEEN '"+MV_PAR01+"'       AND '"+MV_PAR02+"' " 
_cQ += " AND Z2_CLIENTE BETWEEN '"+MV_PAR05+"'       AND '"+MV_PAR06+"' "
_cQ += " AND Z2_LOJA    BETWEEN '"+MV_PAR07+"'       AND '"+MV_PAR08+"' "
_cQ += " AND Z2_ATIVO <> '2' "
_cQ += " ORDER BY Z2_PRODUTO,Z2_CLIENTE,Z2_LOJA "

TCQUERY _cQ NEW ALIAS "ZZ2"
              
TCSETFIELD("ZZ2","Z2_DTREF01","D")
TCSETFIELD("ZZ2","Z2_DTREF02","D")
TCSETFIELD("ZZ2","Z2_DTREF03","D")
TCSETFIELD("ZZ2","Z2_DTREF04","D")
TCSETFIELD("ZZ2","Z2_DTREF05","D")
TCSETFIELD("ZZ2","Z2_DTREF06","D")
TCSETFIELD("ZZ2","Z2_DTREF07","D")
TCSETFIELD("ZZ2","Z2_DTREF08","D")
TCSETFIELD("ZZ2","Z2_DTREF09","D")
TCSETFIELD("ZZ2","Z2_DTREF10","D")
TCSETFIELD("ZZ2","Z2_DTREF11","D")
TCSETFIELD("ZZ2","Z2_DTREF12","D")

ZZ2->(dbGotop())
ProcRegua(ZZ2->(U_CONTREG()))
        
While ZZ2->(!Eof()) .And. !_lFim
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	IncProc()
	
	SB1->(dbSeek(xFilial("SB1")+ZZ2->Z2_PRODUTO))
				   
	_nSdoAcab  := 0         
	
	SG1->(dbSetOrder(1))
	If SG1->(dbSeek(xFilial("SG1")+ZZ2->Z2_PRODUTO))
		_cProd   := SG1->G1_COD
		nNivel   := 2				
				
		SB1->(dbSeek(xFilial("SB1")+_cProd))

		_cDescPa   := SB1->B1_DESC
		_cLocPad   := SB1->B1_LOCPAD
		_cComposto := ""

		NECES(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
    Endif

	_dDataRef := ZZ2->Z2_DTREF01
	_nValor   := ZZ2->Z2_PRECO01 
	For i := 2 to 12
		If &("ZZ2->Z2_DTREF"+StrZero(i,2)) >= _dDataRef
			_dDataRef := &("ZZ2->Z2_DTREF"+StrZero(i,2))
			_nValor   := &("ZZ2->Z2_PRECO"+StrZero(i,2))
		Endif
	Next i
	
	SA1->(dbSetOrder(1))
	SA1->(dbseek(xFilial("SA1")+ZZ2->Z2_CLIENTE+ZZ2->Z2_LOJA))				                               				
				
	TRB->(RecLock("TRB",.T.))
	TRB->CLIENTE  := ZZ2->Z2_CLIENTE
	TRB->LOJA     := ZZ2->Z2_LOJA   
	TRB->NOMECLI  := SA1->A1_NOME
	TRB->PRODUTO  := ZZ2->Z2_PRODUTO
	TRB->NOMPROD  := ZZ2->B1_DESC
	TRB->PRODCLI  := ZZ2->Z2_CODCLI
	TRB->COMPOSTO := _cComposto
	TRB->ULTPRECO := _nValor
	TRB->DTULTPRE := _dDataRef
	TRB->(MsUNlock())			
	
	ZZ2->(dbSkip())	
EndDo


Static Function NECES(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev)

Local _nReg := 0
Local _nRegTrb := 0

SG1->(dbSetOrder(1))

While SG1->(!Eof()) .And. SG1->G1_COD == _cProd  .And. !_lFim
	
	_nReg := SG1->(Recno())
	
	nQuantItem := ExplEstr(_nQtPai,,_cOpc,_cRev)
	dbSelectArea("SG1")
	dbSetOrder(1)
	
	If nQuantItem > 0
		
		aAreaSB1:=SB1->(GetArea())
		SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))
		
		_nRegTRb := SB1->(Recno())
		
		If SB1->B1_GRUPO $ "PIC /MPVZ/MPC "   // Material Utilizado
			_cComposto += ALLTRIM(SG1->G1_COMP)+ " "
		Endif
		 		
		RestArea(aAreaSB1)
		
		SG1->(dbSetOrder(1))
		If SG1->(dbSeek(xFilial("SG1")+SG1->G1_COMP))
			SB1->(dbSeek(xFilial("SB1")+SG1->G1_COD))
			NECES(SG1->G1_COD,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
		EndIf
		
		SG1->(dbGoto(_nReg))		
	Endif
	SG1->(dbSkip())
EndDo

Return


Static Function Atu_SX1()

cPerg := "PA0158"
aRegs :={}

///////////////////////////////////////////
////// GRUPO DE PERGUNTAS /////////////////
///// MV_PAR01 - Produto De ?          ////
///// MV_PAR02 - Produto Ate ?         ////
///// MV_PAR03 - Grupo De              ////
///// MV_PAR04 - Grupo Ate           . ////
///// MV_PAR05 - Cliente De ?          ////
///// MV_PAR06 - Cliente Ate ?         ////
///// MV_PAR07 - Loja    De ?          ////
///// MV_PAR08 - Loja    Ate ?         ////
///////////////////////////////////////////

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Produto de            ?",""       ,""      ,"mv_ch1","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
U_CRIASX1(cPerg,"02","Produto ate           ?",""       ,""      ,"mv_ch2","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
U_CRIASX1(cPerg,"03","Grupo de              ?",""       ,""      ,"mv_ch3","C" ,03     ,0      ,0     ,"G",""            ,"MV_PAR03",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SBM")
U_CRIASX1(cPerg,"04","Grupo ate             ?",""       ,""      ,"mv_ch4","C" ,03     ,0      ,0     ,"G",""            ,"MV_PAR04",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SBM")
U_CRIASX1(cPerg,"05","Cliente De            ?",""       ,""      ,"mv_ch6","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR05",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CLI")
U_CRIASX1(cPerg,"06","Cliente Ate           ?",""       ,""      ,"mv_ch7","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR06",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CLI")
U_CRIASX1(cPerg,"07","Loja De               ?",""       ,""      ,"mv_ch8","C" ,02     ,0      ,0     ,"G",""            ,"MV_PAR07",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"08","Loja Ate              ?",""       ,""      ,"mv_ch9","C" ,02     ,0      ,0     ,"G",""            ,"MV_PAR08",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return
