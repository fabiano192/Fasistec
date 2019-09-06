#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PA0045   ºAutor  ³Alexandro da Silva  º Data ³  02/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Com base na amarracao Produto x Cliente este programa      º±±
±±º          ³ atraves do codigo do Produto no cliente localiza o cod. do º±±
±±º          ³ produto na Pasy                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Itens do Pedido de Venda                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PA0045()


Private _cPerg    := "PA0045"
Private _oGeraTxt

Private _cString  := "Sb1"


Pergunte(_cPerg,.F.)

dbSelectArea("Sb1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 150,1 TO 380,450 DIALOG _oGeraTxt TITLE OemToAnsi("Geracao de Arquivo do Prod x Cliente")
@ 02,10 TO 080,220
@ 10,018 Say " Este programa ira gerar um arquivo no Diretório               " SIZE 160,7
@ 18,018 Say " F:\ap7\ap_data\relato\prcvenda.dbf .dbf , conforme os parame- " SIZE 160,7
@ 26,018 Say " tros informados pelo Usuario.                                 " SIZE 160,7
@ 85,128 BMPBUTTON TYPE 01 ACTION Proc1()
@ 85,158 BMPBUTTON TYPE 02 ACTION Close(_oGeraTxt)
@ 85,188 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)

Activate Dialog _oGeraTxt Centered

Return



Static Function Proc1()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| Proc2(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )


Close(_oGeraTxt)

Return


Static Function Proc2(_lFim)


//////////////////////////////////
/////// PA0044 ///////////////////
//// MV_PAR01  : Cliente De  /////
//// MV_PAR02  : Cliente Ate /////
//// MV_PAR03  : Loja De     /////
//// MV_PAR04  : Loja Ate    /////
//// MV_PAR05  : Produto De  /////
//// MV_PAR06  : Produto Ate /////
////                         /////
//////////////////////////////////

aStru := {}
AADD(aStru,{"CODCLI"  , "C" ,06, 0 })
AADD(aStru,{"LOJA"    , "C" ,02, 0 })
AADD(aStru,{"PRODPASY", "C" ,15, 0 })
AADD(aStru,{"DESCPRO" , "C" ,45, 0 })
AADD(aStru,{"PRODCLI" , "C" ,15, 0 })
AADD(aStru,{"PRCVENDA", "N" ,14, 6 })

cArqTRB := CriaTrab(aStru,.T.)
cIndTRB := "CODCLI+LOJA+PRODPASY+PRODCLI"

dbUseArea(.T.,,cArqTRB,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",cArqTRB,cIndTRB,,,"Criando Trabalho...")

Pergunte("PA0045",.F.)

dbSelectArea("SZ2")
dbSetOrder(1)
dbSeek(xFilial("SZ2")+MV_PAR01+MV_PAR03,.T.)

ProcRegua(LastRec())

While !Eof() .And. SZ2->Z2_CLIENTE <= MV_PAR02 .And. SZ2->Z2_LOJA <= MV_PAR04
	
	IncProc()
	
	_dDataRef := SZ2->Z2_DTREF01
	_nValor   := SZ2->Z2_PRECO01
	For i := 2 to 12
		If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= _dDataRef
			_dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
			_nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
		Endif
	Next i

	If SZ2->Z2_ATIVO == "2"
		dbSelectArea("SZ2")
		dbSkip()
		Loop
	Endif

    dbSelectArea("SB1")
    dbSetOrder(1)
    dbSeek(xFilial("SB1")+SZ2->Z2_PRODUTO)
	
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->CODCLI   := SZ2->Z2_CLIENTE
	TRB->LOJA     := SZ2->Z2_LOJA
	TRB->PRODPASY := SZ2->Z2_PRODUTO
	TRB->DESCPRO  := SB1->B1_DESC
	TRB->PRODCLI  := SZ2->Z2_CODCLI
	TRB->PRCVENDA := _nValor
	MsUnlock()
	
	dbSelectArea("SZ2")
	dbSkip()
	
EndDo

_cArqNovo := "\RELATO\PRCVENDA.DBF"

dbSelectArea("TRB")
Copy all to &_cArqNovo

dbCloseArea()

FErase(cArqTrb+".DBF")

Return