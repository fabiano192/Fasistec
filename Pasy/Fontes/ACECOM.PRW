#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"

USER FUNCTION ACECOM()

LOCAL oDlg := NIL

PRIVATE cTitulo    	:= "Lista de Compostos"
PRIVATE oPrn       	:= NIL
PRIVATE oFont1     	:= NIL
PRIVATE oFont2     	:= NIL
PRIVATE oFont3     	:= NIL
PRIVATE oFont4     	:= NIL
PRIVATE oFont5     	:= NIL
PRIVATE oFont6     	:= NIL
PRIVATE _nCont     	:= 0
Private aRadio  	:= {}
Private nRadio  	:= 1
Private oRadio  	:= Nil
Private _cChav 		:= ""

//aAdd( aRadio, "Relatório" )
aAdd( aRadio, "Excel" )

DEFINE FONT oFont1 NAME "Arial" SIZE 0,10 OF oPrn BOLD
DEFINE FONT oFont2 NAME "Arial" SIZE 0,13 OF oPrn BOLD
DEFINE FONT oFont3 NAME "Arial" SIZE 0,14 OF oPrn BOLD UNDERLINE
DEFINE FONT oFont4 NAME "Arial" SIZE 0,10 OF oPrn
DEFINE FONT oFont5 NAME "Arial" SIZE 0,14 OF oPrn
DEFINE FONT oFont6 NAME "Courier New" BOLD

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 010,017 SAY "Esta rotina tem por objetivo gerar o relatório  " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 020,017 SAY "de maior preço de venda sem impostos conforme   " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 030,017 SAY "parâmetros informados pelo usuário. Caso opte   " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 040,017 SAY "por gerar o arquivo em Excel, será o seguinte   " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 050,017 SAY "arquivo \SPOOL\PA0173.DBF                       " OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_BLUE
@ 070,017 SAY "Programa PA0173.PRW                             " OF oDlg PIXEL Size 150,010 FONT oFont5 COLOR CLR_RED

@ 004,165 TO 028,205 LABEL "" OF oDlg PIXEL
@ 08,167 RADIO oRadio VAR nRadio ITEMS "Excel" SIZE 33,10 PIXEL OF oDlg

@ 50,167 BUTTON "OK" SIZE 036,012 ACTION (ACEC_01(),oDlg:End()) OF oDlg PIXEL
@ 65,167 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)


Static Function ACEC_01()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| ACEC_02(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

QB1->(dbCloseArea())

Return(Nil)


Static Function ACEC_02()

aStru := {}
AADD(aStru,{"PROD_PR" 	, "C" , 15, 0 })
AADD(aStru,{"QTD_PF" 	, "N" , 14, 4 })
AADD(aStru,{"PROD_CO" 	, "C" , 15, 0 })
AADD(aStru,{"QTD1"   	, "N" , 14, 4 })
AADD(aStru,{"QTD2"  	, "N" , 15, 4 })

cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "PROD_PR+PROD_CO"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

_cQuery	:= " SELECT * FROM SB1010 B1 (NOLOCK) "
_cQuery	+= " WHERE B1.D_E_L_E_T_ = '' AND B1_TIPO = 'PA' "
//_cQuery	+= " AND B1_COD < '000200         ' "
_cQuery	+= " ORDER BY B1_COD"

TCQUERY _cQuery NEW ALIAS "QB1"

ProcRegua(LastRec())

While QB1->(!EOF())
	
	IncProc()
	
	dbSelectArea("SG1")
	dbSetOrder(1)
	If dbSeek(xFilial("SG1")+QB1->B1_COD)
		
		_cProd   := SG1->G1_COD
		nNivel   := 2
		
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+_cProd)
		
		NECESC6(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
	Endif
	
	QB1->(dbSkip())
EndDo

If nRadio == 1
	
	_cArqNovo := "\SPOOL\ACECOM.DBF"
	dbSelectArea("TRB")
	Copy all to &_cArqNovo
	
	TRB->(dbCloseArea())
	
	If ! ApOleClient( 'MsExcel' )
		MsgStop('MsExcel nao instalado')
		Return
	EndIf
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\spool\ACECOM.DBF" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	
Endif

Return (Nil)


Static Function NECESC6(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev)

Local _nReg    := 0
Local _nRegTrb := 0


dbSelectArea("SG1")
dbSetOrder(1)

While !Eof() .And. SG1->G1_FILIAL + SG1->G1_COD == xFilial("SG1") + _cProd
	
	_nReg := Recno()
	
	nQuantItem := ExplEstr(_nQtPai,,_cOpc,_cRev)
	dbSelectArea("SG1")
	dbSetOrder(1)
	
	If nQuantItem > 0
		
		dbSelectArea("SB1")
		aAreaSB1:=GetArea()
		dbSeek(xFilial("SB1")+SG1->G1_COMP)
		
		_nRegTRb := Recno()
				
		If SB1->B1_GRUPO $ "PIPF"   // Pre formado utilizado
		
			TRB->(RecLock("TRB",.T.))
			TRB->PROD_PR	:= SB1->B1_COD
			TRB->QTD_PF		:= SG1->G1_QUANT
			TRB->QTD1		:= SG1->G1_PEPFFIM
			TRB->(MsUnlock())
		
			_cChav := SB1->B1_COD
			
		ElseIf SB1->B1_GRUPO $ "PIC /MPVZ/MPC /MPL "   // Material Utilizado

			If TRB->(dbSeek(_cChav))
				If EMPTY(TRB->PROD_CO)
					TRB->(RecLock("TRB",.F.))
					TRB->PROD_CO    := SB1->B1_COD
					TRB->QTD2		:= SG1->G1_QUANT
					TRB->(MsUnlock())
				Else
					_cCod2   := TRB->PROD_PR
					_nQtd_pf := TRB->QTD_PF
					_nQtd1	 := TRB->QTD1
					
					TRB->(RecLock("TRB",.T.))			
					TRB->PROD_PR	:= _cCod2
					TRB->QTD_PF		:= _nQtd_PF
					TRB->QTD1       := _nQtd1
					TRB->PROD_CO    := SB1->B1_COD
					TRB->QTD2		:= SG1->G1_QUANT
					TRB->(MsUnlock())						
				Endif
			Else
			
				TRB->(RecLock("TRB",.T.))
				TRB->PROD_CO    := SB1->B1_COD
				TRB->QTD2		:= SG1->G1_QUANT
				TRB->(MsUnlock())
				
			Endif
		Endif
		
		RestArea(aAreaSB1)
		
		dbSelectArea("SG1")
		dbSetOrder(1)
		dbSeek(xFilial("SG1")+SG1->G1_COMP)
		IF Found()
			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+SG1->G1_COD)
			
			NECESC6(SG1->G1_COD,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
		EndIf
		
		dbSelectArea("SG1")
		dbGoto(_nReg)
		
		dbSelectArea("SG1")
	Endif
	dbSkip()
EndDo

Return(Nil)
