#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0120A  ³ Autor ³ Alexandro da Silva    ³ Data ³ 26.02.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para gerar n.fiscal complementar                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0120A()

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

dbSelectArea("QD2")                   
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
//AADD(aStru,{"EMISSAO"     , "D" , 08, 0 })
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
                     
_cQ   := " SELECT * FROM SD2010 D2 WHERE D2.D_E_L_E_T_ = '' AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"'AND '"+DTOS(MV_PAR02)+"' "
_cQ   += " AND D2_TIPO = 'C' AND D2_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND D2_LOJA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
_cQ   += " AND D2_COD BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
_cQ   += " ORDER BY D2_COD "

TCQUERY _cQ NEW ALIAS "QD2"

dbSelectArea("QD2")
dbGotop()

ProcRegua(U_CONTREG())

While !Eof() .And. !_lFim
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	IncProc()
	
	dbSelectArea("SD2")
	dbSetOrder(3)
	If dbSeek(xFilial("SD2")+QD2->D2_NFORI+ QD2->D2_SERIORI + QD2->D2_CLIENTE + QD2->D2_LOJA + QD2->D2_COD)		
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
		
		    _cDoc     := SD2->D2_DOC
		    _cSerie   := SD2->D2_SERIE
		    _cCliente := SD2->D2_CLIENTE
		    _cLoja    := SD2->D2_LOJA
		    _cProd    := SD2->D2_COD 
		    _cProdCli := SD2->D2_PROCLI
		    _cChavSd2 := SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD
		    _nQtOri   := 0              
		    _nVltotal := 0
		    _nPrcVen  := SD2->D2_PRCVEN

	    	dbSelectArea("SD2")
		    
		    While !Eof()  .And.  _cChavSd2 == SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD
		    
		    	_nQtOri   += SD2->D2_QUANT
		    	_nVlTotal += SD2->D2_TOTAL
		    	
		    	dbSelectArea("SD2")
		    	dbSkip()
		    EndDo
		    
			dbSelectArea("TRB")
			If !dbSeek(QD2->D2_DOC + _cProd)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->CLIENTE  := _cCliente
				TRB->LOJA     := _cLoja
				TRB->PRODUTO  := _cProd
				TRB->PRODCLI  := _cProdCli
				TRB->NFCOMPL  := QD2->D2_DOC
				TRB->NFISCAL  := _cDoc
				TRB->QTDVEN   := _nQtori
				TRB->PRUNANT  := _nPrcVen
				TRB->VLTOTANT := _nVlTotal
				TRB->PRUNNEW  := _nValor
				TRB->VLTOTNEW := _nQtOri * _nValor
				TRB->DIFTOT   := TRB->VLTOTNEW - TRB->VLTOTANT
				TRB->VALCOMP  := QD2->D2_TOTAL
				MsUNlock()
			Endif
		Endif
	Endif
	
	dbSelectArea("QD2")
	dbSkip()
EndDo

Return