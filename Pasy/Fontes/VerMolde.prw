#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function VerMolde()

aStru := {}
AADD(aStru,{"CLIENTE"   , "C" , 06, 0 })
AADD(aStru,{"LOJA"      , "C" , 02, 0 })
AADD(aStru,{"CODPASY"   , "C" , 15, 0 })
AADD(aStru,{"CODCLI"    , "C" , 15, 0 })
AADD(aStru,{"DESCRIC"   , "C" , 30, 0 })
AADD(aStru,{"MOLDE"     , "C" , 15, 0 })
AADD(aStru,{"GRUPO"     , "C" ,  4, 0 })
AADD(aStru,{"SUBGRU"    , "C" ,  6, 0 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "CLIENTE+LOJA+CODPASY+CODCLI"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

_cQ := " SELECT Z2_CLIENTE,Z2_LOJA,B1_COD,Z2_CODCLI,Z2_DESCCLI,B1_GRUPO,B1_SUBGR FROM SB1010 B1 "
_cQ += " INNER JOIN SZ2010 Z2 ON Z2_PRODUTO = B1_COD "
_cQ += " WHERE Z2_CLIENTE = '000071' AND Z2.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' AND Z2_ATIVO = '1' "

TCQUERY _cQ NEW ALIAS "TZ1"

dbSelectArea("TZ1")
dbGoTop()

While TZ1->(!EOF())

	nEstru 		:= 0
	aEstru    	:= Estrut(TZ1->B1_COD)
	
	dbSelectarea("SB1")
	_cAliSB1 := Alias()
	_nOrdSB1 := IndexOrd()
	_nRecSB1 := Recno()

	For E:= 1 To Len(aEstru)
	
		dbSelectarea("SB1")
		dbSetOrder(1)
		If dbseek(xFilial("SB1")+aEstru[E,3])
		
			If SB1->B1_SUBGR = 'FRVCC'
			
				TRB->(RecLock("TRB",.T.))
				TRB->CLIENTE	:= TZ1->Z2_CLIENTE
				TRB->LOJA   	:= TZ1->Z2_LOJA
				TRB->CODPASY	:= TZ1->B1_COD
				TRB->CODCLI		:= TZ1->Z2_CODCLI
				TRB->DESCRIC	:= TZ1->Z2_DESCCLI
				TRB->MOLDE		:= SB1->B1_COD
				TRB->GRUPO		:= SB1->B1_GRUPO
				TRB->SUBGRU		:= SB1->B1_SUBGR
				TRB->(MsUnlock())
			Endif
		Endif
	Next E
    TZ1->(dbSkip())
EndDo

TZ1->(dbCloseArea())

_cArqNovo := "\SPOOL\VERMOLDE.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo

dbCloseArea()

If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\SPOOL\VERMOLDE.DBF" ) // ABRE UMA PLANILHA
oExcelApp:SetVisible(.T.)

Return