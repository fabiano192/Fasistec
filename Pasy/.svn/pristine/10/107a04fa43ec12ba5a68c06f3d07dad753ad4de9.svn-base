#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPA0022     บ Autor ณ Alexandro da Silvaบ Data ณ  10/03/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Pedidos Eliminados X Pedidos Colocados        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Sigafin                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PA0022()

LOCAL oDlg 		:= NIL
_aAliOri := GetArea()
_lAchou  := .F.
_nOpc    := 0


DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE "CONFERENCIA DE PEDIDOS" OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 010,017 SAY "Conferencia de Pedidos Eliminados X Inseridos   " OF oDlg PIXEL Size 150,010
@ 020,017 SAY "Conforme parametros informados  				   " OF oDlg PIXEL Size 150,010
@ 060,017 SAY "                                                " OF oDlg PIXEL Size 150,010
@ 070,017 SAY "Programa PA0022.PRW                             " OF oDlg PIXEL Size 150,010

@ 10,167 BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("PA0022"))	OF oDlg PIXEL
@ 35,167 BUTTON "OK" 		 SIZE 036,012 ACTION (PA022A(),oDlg:End()) 	OF oDlg PIXEL
@ 60,167 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return


Static Function PA022A()

Pergunte("PA0022",.F.)

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA022B(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )


_cArqNovo := "\SPOOL\PA0022.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo

dbCloseArea()

_cDir:= "C:\TOTVS\"

If !ExistDir( _cDir )
	If MakeDir( _cDir ) <> 0
		MsgAlert(  "Impossํvel criar diretorio ( "+_cDir+" ) " )
		Return
	EndIf
EndIf                


CpyS2T( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\SPOOL\PA0022.DBF", "C:\TOTVS", .F. )

If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "C:\TOTVS\PA0022.DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

//FErase(_cArqTrb+".DBF")
//FErase(_cArqTrb+OrdBagExt())

Return


Static Function PA022B(_lFim)

Private _dDtElim := Ctod("")

aStru := {}
AADD(aStru,{"CLIENTE"  , "C" , 06, 0 })
AADD(aStru,{"LOJA"     , "C" , 02, 0 })
AADD(aStru,{"PRODPASY" , "C" , 15, 0 })
AADD(aStru,{"PRODCLI"  , "C" , 15, 0 })
AADD(aStru,{"DESCRIC"  , "C" , 30, 0 })
AADD(aStru,{"PEDVE_ER" , "C" ,  6, 0 })
AADD(aStru,{"ITEM_ER"  , "C" ,  2, 0 })
AADD(aStru,{"EMISS_ER" , "D" ,  8, 0 })
AADD(aStru,{"DTENT_ER" , "D" ,  8, 0 })
AADD(aStru,{"QTDE_ER"  , "N" , 14, 2 })
AADD(aStru,{"DTELIM"   , "D" ,  8, 0 })
AADD(aStru,{"PEDVE_AT" , "C" ,  6, 0 })
AADD(aStru,{"ITEM_AT"  , "C" ,  2, 0 })
AADD(aStru,{"EMISS_AT" , "D" ,  8, 0 })
AADD(aStru,{"DTENT_AT" , "D" ,  8, 0 })
AADD(aStru,{"QTDE_AT"  , "N" , 14, 2 })
AADD(aStru,{"QT_DIFER" , "N" , 14, 2 })
AADD(aStru,{"CONTADOR" , "C" , 01, 0 })

_cArqTRB := CriaTrab(aStru,.T.)
_cIndTRB := "CLIENTE + LOJA + PRODPASY + PRODCLI + DTOS(DTENT_ER) + CONTADOR"
dbUseArea(.T.,,_cArqTRB,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",_cArqTRB,_cIndTRB,,,"Criando Trabalho...")

_Query := " SELECT C6_PRODUTO,C6_BLQ,C6_XDTELIM,C6_NUM,C6_ITEM,C6_CPROCLI,C6_DESCRI,C5_EMISSAO,C5_CLIENTE,C5_LOJACLI,C6_ENTREG,C6_QTDVEN,C6_QTDENT "
_Query += " FROM "+RetSqlName("SC5")+" C5 "
_Query += " INNER JOIN "+RetSqlName("SC6")+" C6 ON C5_NUM = C6_NUM "
_Query += " WHERE C5.D_E_L_E_T_ = '' AND C6.D_E_L_E_T_ = ''"
_Query += " AND C5_CLIENTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
_Query += " AND C5_LOJACLI BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_Query += " AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' "
_Query += " AND C6_PRODUTO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
_Query += " AND C6_ENTREG BETWEEN '"+DTOS(MV_PAR09)+"' AND '"+DTOS(MV_PAR10)+"' "
_Query += " AND C6_QTDVEN > C6_QTDENT "
_Query += " AND C6_PEDAMOS = 'N' "
_Query += " AND (C6_BLQ = '' OR C6_XDTELIM = '"+DTOS(MV_PAR11)+"') "
_Query += " ORDER BY C5_CLIENTE+C5_LOJACLI+C6_PRODUTO+C6_ENTREG+C6_BLQ DESC"

TCQUERY _Query New ALIAS "ZC6"

TcSetField("ZC6","C6_ENTREG" ,"D",8)
TcSetField("ZC6","C5_EMISSAO","D",8)
TcSetField("ZC6","C6_XDTELIM","D",8)

ZC6->(dbGotop())

ProcRegua(ZC6->(U_CONTREG()))

While ZC6->(!Eof())
	
	IncProc()
	
	If EMPTY(ZC6->C6_XDTELIM)
		_cPedElim := ""
		_cItemEL  := ""
		_dDtEmER  := CTOD("")
		_nQtElim  := 0
		_dDtElim  := CTOD("")
		_dDtAntig := CTOD("")
		
		_cPedNovo := ZC6->C6_NUM
		_cItemAt  := ZC6->C6_ITEM
		_dDtEmAt  := ZC6->C5_EMISSAO
		_dDtAtual := ZC6->C6_ENTREG
		_nQtNovo  := ZC6->C6_QTDVEN
	Else
		_cPedElim := ZC6->C6_NUM
		_cItemEL  := ZC6->C6_ITEM
		_dDtEmER  := ZC6->C5_EMISSAO
		_nQtElim  := ZC6->C6_QTDVEN - ZC6->C6_QTDENT
		_dDtElim  := ZC6->C6_XDTELIM
		_dDtAntig := ZC6->C6_ENTREG
		
		_cPedNovo := ""
		_cItemAt  := ""
		_dDtEmAt  :=CTOD("")
		_dDtAtual := CTOD("")
		_nQtNovo  := 0
		
	Endif
	
	dbSelectArea("TRB")
	If !dbSeek(ZC6->C5_CLIENTE+ZC6->C5_LOJACLI+ZC6->C6_PRODUTO+ZC6->C6_CPROCLI+DTOS(ZC6->C6_ENTREG)+"1")
		RecLock("TRB",.T.)
		TRB->CLIENTE  := ZC6->C5_CLIENTE
		TRB->LOJA     := ZC6->C5_LOJACLI
		TRB->PRODPASY := ZC6->C6_PRODUTO
		TRB->PRODCLI  := ZC6->C6_CPROCLI
		TRB->DESCRIC  := ZC6->C6_DESCRI
		TRB->PEDVE_ER := _cPedElim
		TRB->ITEM_ER  := _cItemEL
		TRB->EMISS_ER := _dDtEmER
		TRB->DTENT_ER := _dDtAntig
		TRB->QTDE_ER  := _nQtElim
		TRB->DTELIM   := _dDtElim
		TRB->PEDVE_AT := _cPedNovo
		TRB->ITEM_AT  := _cItemAt
		TRB->EMISS_AT := _dDtEmAt
		TRB->DTENT_AT := _dDtAtual
		TRB->QTDE_AT  := _nQtNovo
		TRB->QT_DIFER := _nQtNovo - _nQtElim
		TRB->CONTADOR := "1"
		MsUnlock()
	Else
		RecLock("TRB",.F.)
		If Empty(TRB->PEDVE_ER)
			TRB->PEDVE_ER := _cPedElim
			TRB->ITEM_ER  := _cItemEL
			TRB->EMISS_ER := _dDtEmER
			TRB->DTENT_ER := _dDtAntig
			TRB->QTDE_ER  := _nQtElim
			TRB->DTELIM   := _dDtElim
		Else
			TRB->PEDVE_AT := _cPedNovo
			TRB->ITEM_AT  := _cItemAt
			TRB->EMISS_AT := _dDtEmAt
			TRB->DTENT_AT := _dDtAtual
			TRB->QTDE_AT  := _nQtNovo
		Endif
		TRB->QT_DIFER := TRB->QTDE_AT - TRB->QTDE_ER
		TRB->CONTADOR := "2"
		MsUnlock()
	Endif
	
	ZC6->(dbSkip())
EndDo

ZC6->(dbCloseArea())

Return      
