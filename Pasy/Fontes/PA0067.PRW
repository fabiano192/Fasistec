#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0067   ³ Autor ³ Alexandro da Silva    ³ Data ³ 27.06.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gerando Tabela Provisoria p/Marcos Pestana Das Vendas      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0067()

_aAliOri := GetArea()
Private _cDescPa := ""
        
_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Gerando Tabela de Vendas p/ 6-SIGMA")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina criado para Gerar tabela de Vendas       "   SIZE 160,7
@ 18,18 SAY "Para o Projeto 6-Sigma.                         "   SIZE 160,7
@ 26,18 SAY "Conforme Arquivo Informado com o produtos       "   SIZE 160,7
@ 34,18 SAY "Necessarios no Diretorio \sigaadv\prodsigma.dbf "   SIZE 160,7

//@ 85,158 BMPBUTTON TYPE 1 ACTION Proces()
//@ 85,188 BMPBUTTON TYPE 2 ACTION Close(oDlg)
                                    
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

_cArqNovo := "PRODSIGMA.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo

dbSelectArea("TMP")
dbCloseArea()
             
dbSelectArea("TRB")
dbCloseArea()


MsgInfo("Arquivo Processado Com Sucesso!!!!","INFO")


Return



Static Function Proc1(_lFim)


cArqLOG := "PRODSIG"
cIndLOG := "PRODUTO"
dbUseArea(.T.,,cArqLOG,"TMP",.F.,.F.)

Private _nNiv := 0
Private _lGravou := .F.
aStru := {}
AADD(aStru,{"CLIENTE"     , "C" , 06, 0 })
AADD(aStru,{"NOMECLI"     , "C" , 40, 0 })
AADD(aStru,{"LOJA"        , "C" , 02, 0 })
AADD(aStru,{"PRODUTO"     , "C" , 15, 0 })
AADD(aStru,{"MPRIMA"      , "C" , 15, 0 })
AADD(aStru,{"PRODCLI"     , "C" , 15, 0 })
AADD(aStru,{"DESCPA"      , "C" , 40, 0 })
AADD(aStru,{"VLVEND"      , "N" , 14, 2 })
AADD(aStru,{"PERCICM "    , "N" , 14, 2 })
AADD(aStru,{"PERCIPI"     , "N" , 14, 2 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "CLIENTE+LOJA+PRODUTO"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

dbSelectArea("TMP")
dbGotop()

ProcRegua(LastRec())

While !Eof()  .And. !_lFim
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	IncProc()
	
	dbSelectArea("SB1")
	dbSetorder(1)
	If !dbSeek(xFilial("SB1")+TMP->PRODUTO)
		dbSelectArea("TMP")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SZ2")
	dbSetOrder(2)
	If dbSeek(xFilial("SZ2")+TMP->PRODUTO)
		_cProd := SZ2->Z2_PRODUTO
		
		While !Eof() .And. _cProd == SZ2->Z2_PRODUTO
			
			_dDataRef := SZ2->Z2_DTREF01
			_nValor   := SZ2->Z2_PRECO01
			For i := 2 to 12
				If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= _dDataRef
					_dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
					_nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
				Endif
			Next i
			
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+SZ2->Z2_CLIENTE + SZ2->Z2_LOJA)
			
			dbSelectArea("TRB")
			If !dbSeek(SZ2->Z2_PRODUTO+ SZ2->Z2_CLIENTE + SZ2->Z2_LOJA)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PRODUTO := SZ2->Z2_PRODUTO
				TRB->MPRIMA  := TMP->COMP
				TRB->DESCPA  := SB1->B1_DESC
				TRB->CLIENTE := SZ2->Z2_CLIENTE
				TRB->LOJA    := SZ2->Z2_LOJA
				TRB->NOMECLI := SA1->A1_NOME
				TRB->PRODCLI := SZ2->Z2_CODCLI
				TRB->VLVEND  := _nValor
				If !Empty(SB1->B1_PICM)
					TRB->PERCICM := SB1->B1_PICM
				Else
					TRB->PERCICM := ALIQICMS("N","S","C")
				Endif
				TRB->PERCIPI  := SB1->B1_IPI
				MsUnlock()
			Endif
			
			dbSelectArea("SZ2")
			dbSkip()
		EndDo
	Endif
	
	dbSelectArea("TMP")
	dbSkip()
EndDo


Return