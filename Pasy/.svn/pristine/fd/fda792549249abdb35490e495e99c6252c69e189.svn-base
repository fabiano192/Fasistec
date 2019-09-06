#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0120   ³ Autor ³ Alexandro da Silva    ³ Data ³ 26.02.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para gerar n.fiscal complementar                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0120()

_aAliOri   := GetArea()
_nOpc      := 0

@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Planilha P/ N.F. Complementar")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina criado para Gerar tabela de Vendas com os dados       "     SIZE 160,7
@ 18,18 SAY "necessarios para gerar a Nota Fiscal complementar conforme   "     SIZE 160,7
@ 26,18 SAY "ultimo preco do cadastro Produto x Cliente e as notas fiscais"     SIZE 160,7
@ 34,18 SAY "emitidas. Programa PA0120 (TABELA) PA0120.DBF                "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0120")
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

_cArqNovo := "\RELATO\PA0120.DBF"

dbSelectArea("TRB")
Copy all to &_cArqNovo
dbCloseArea()

//Ferase(_cArqTRB+".dbf")
//Ferase(_cArqTRB+OrdBagExt())

If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "F:\AP7\AP_DATA\RELATO\PA0120.DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return


Static Function Proc1(_lFim)

Pergunte("PA0120",.F.)

///////////////////////////////////////////
////// GRUPO DE PERGUNTAS /////////////////
///// MV_PAR01 - Emissao De  ?         ////
///// MV_PAR02 - Emissao Ate ?         ////
///// MV_PAR03 - Cliente De ?          ////
///// MV_PAR04 - Cliente Ate ?         ////
///// MV_PAR05 - Loja    De ?          ////
///// MV_PAR06 - Loja    Ate ?         ////
///// MV_PAR07 - Produto De ?          ////
///// MV_PAR08 - produto Ate ?         ////
///////////////////////////////////////////

Private _nNiv := 0
Private _lGravou := .F.
aStru := {}
AADD(aStru,{"EMISSAO"     , "D" , 08, 0 })
AADD(aStru,{"CLIENTE"     , "C" , 06, 0 })
AADD(aStru,{"LOJA"        , "C" , 02, 0 })
AADD(aStru,{"PRODUTO"     , "C" , 15, 0 })
AADD(aStru,{"PRODCLI"     , "C" , 15, 0 })
AADD(aStru,{"NFCOMPL"     , "C" , 06, 0 })
AADD(aStru,{"NFISCAL"     , "C" , 06, 0 })
AADD(aStru,{"ITEMNF"      , "C" , 02, 2 })
AADD(aStru,{"QTDVEN"      , "N" , 14, 2 })
AADD(aStru,{"PRUNANT"     , "N" , 14, 2 })
AADD(aStru,{"PRUNNEW"     , "N" , 14, 2 })
AADD(aStru,{"VLTOTANT"    , "N" , 14, 2 })
AADD(aStru,{"VLTOTNEW"    , "N" , 14, 2 })
AADD(aStru,{"DIFTOT"      , "N" , 14, 2 })
AADD(aStru,{"VALCOMP"     , "N" , 14, 2 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "NFISCAL+PRODUTO"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

dbSelectArea("SD2")
dbSetOrder(5)
dbSeek(xFilial("SD2")+Dtos(MV_PAR01),.T.)

ProcRegua(RecCount())

While !Eof() .And. SD2->D2_EMISSAO <= MV_PAR02 .And. !_lFim
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	IncProc()
	
	If  SD2->D2_CLIENTE < MV_PAR03 .Or. SD2->D2_CLIENTE  > MV_PAR04 .Or.;
		SD2->D2_LOJA    < MV_PAR05 .Or. SD2->D2_LOJA     > MV_PAR06 .Or. SD2->D2_TIPO != "N" .Or.;
		SD2->D2_COD     < MV_PAR07 .Or. SD2->D2_COD      > MV_PAR08
		dbSelectArea("SD2")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SF4")
	dbSetOrder(1)
	If dbSeek(xFilial("SF4")+SD2->D2_TES)
		If SF4->F4_DUPLIC != "S"
			dbSelectArea("SD2")
			dbSkip()
			Loop
		Endif
	Endif
	                                                                            
	_cDoc  := SD2->D2_DOC
	_cSer  := SD2->D2_SERIE	                                      
	_cProd := SD2->D2_COD
	_cItem := SD2->D2_ITEM
	
	_cQ   := " SELECT * FROM SD2010 D2 WHERE D2.D_E_L_E_T_ = '' AND D2_NFORI = '"+_cDoc+"' AND D2_SERIORI = '"+_cSer+"' AND D2_TIPO = 'C' "
	_cQ   += " AND D2_COD = '"+_cProd+"' "

	TCQUERY _cQ NEW ALIAS "QD2"
	
	_cNfComp  := QD2->D2_DOC
	_nValComp := QD2->D2_TOTAL
	
	dbSelectArea("QD2")
	dbCloseArea()
		
	dbSelectArea("SZ2")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE+SD2->D2_LOJA + SD2->D2_COD+SD2->D2_PROCLI+"1" )
		_dDataRef := SZ2->Z2_DTREF01
		_nValor   := SZ2->Z2_PRECO01
		For i := 2 to 12
			If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= _dDataRef
				_dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
				_nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
			Endif
		Next i
		
		dbSelectArea("TRB")
		If !dbSeek(SD2->D2_DOC + SD2->D2_COD)
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->EMISSAO  := SD2->D2_EMISSAO
			TRB->CLIENTE  := SD2->D2_CLIENTE
			TRB->LOJA     := SD2->D2_LOJA
			TRB->PRODUTO  := SD2->D2_COD
			TRB->PRODCLI  := SD2->D2_PROCLI
			TRB->NFCOMPL  := _cNfComp
			TRB->NFISCAL  := SD2->D2_DOC
			TRB->ITEMNF   := SD2->D2_ITEM
			TRB->QTDVEN   := SD2->D2_QUANT
			TRB->PRUNANT  := SD2->D2_PRCVEN
			TRB->VLTOTANT := SD2->D2_TOTAL
			TRB->PRUNNEW  := _nValor
			TRB->VLTOTNEW := SD2->D2_QUANT * _nValor
			TRB->DIFTOT   := TRB->VLTOTNEW - TRB->VLTOTANT
			TRB->VALCOMP  := _nValComp
			MsUNlock()
		Else
			dbSelectArea("TRB")
			RecLock("TRB",.F.)
			TRB->QTDVEN   += SD2->D2_QUANT
			TRB->VLTOTANT += SD2->D2_TOTAL
			TRB->VLTOTNEW += (SD2->D2_QUANT * _nValor)
			TRB->DIFTOT   := TRB->VLTOTNEW - TRB->VLTOTANT
			MsUNlock()
		Endif
	Endif
	
	dbSelectArea("SD2")
	dbSkip()
EndDo

Return
