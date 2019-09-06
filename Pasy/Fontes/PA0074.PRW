#include "rwmake.ch"

User Function PA0074()

SetPrvt("_cAliOri,_nOrdOri,_nRecOri,_aStrREt,_cArqRet")

_cAliOri := Alias()
_nOrdOri := IndexOrd()
_nRecOri := Recno()
_lBx     := .F.

@ 150,1 TO 380,450 DIALOG _oGeraTxt TITLE OemToAnsi("Processando Notas Fiscais Caterpillar!!!")
@ 02,10 TO 080,220
@ 10,018 Say " Este programa ira Corrigir Os Itens das Notas fiscais que   -  " SIZE 160,7
@ 18,018 Say " Estão com o codigo do produto X Cliente Em Branco (Caterpillar)" SIZE 160,7
@ 26,018 Say " Programa PA0074.                                               " SIZE 160,7
@ 85,128 BMPBUTTON TYPE 05 ACTION Pergunte("PA0074",.T.)
@ 85,158 BMPBUTTON TYPE 02 ACTION Close(_oGeraTxt)
@ 85,188 BMPBUTTON TYPE 01 ACTION GeraMov()

Activate Dialog _oGeraTxt Centered

Return

Static Function GeraMov()                    
                         
Close(_oGeraTxt)
              
Pergunte("PA0074",.F.)

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA0074A(@_lFim) }
Private _cTitulo01 := 'Processando Notas Fiscais Caterpillar!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Private _bAcao01   := {|_lFim| PA0074B(@_lFim) }
Private _cTitulo01 := 'Processando Pedidos!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )


MSGINFO("Alteracao Efetuada com Sucesso !!! ")
Return



Static Function PA0074A(_lFim)

dbSelectArea("SD2")
dbSetOrder(5)
dbSeek(xFilial("SD2")+Dtos(MV_PAR01),.T.)

ProcRegua(LastRec())

While !Eof() .And. !_lfim  .And. SD2->D2_EMISSAO <= MV_PAR02
	
	IncProc()

	If SD2->D2_CLIENTE != "000008"	
		dbSelectArea("SD2")
		dbSkip()
		Loop
	Endif
	
   	If !Empty(SD2->D2_PROCLI)
		dbSelectArea("SD2")
		dbSkip()
		Loop
	Endif
    
	_cProdCli := ""
	dbSelectArea("SZ2")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ2") + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD )
		_cProdCli := SZ2->Z2_CODCLI
	Endif
	   		              
	dbSelectArea("SD2")
	RecLock("SD2",.F.)
	SD2->D2_PROCLI := _cProdCli
	MsUnlock()

	dbSelectArea("SD2")
	dbSkip()	
EndDo		
   		
Return


Static Function PA0074B(_lFim)

dbSelectArea("SC6")
dbSetOrder(5)
dbSeek(xFilial("SC6")+"000008")

ProcRegua(LastRec())

While !Eof() .And. !_lfim .And. SC6->C6_CLI == "000008"
	
	IncProc()

   	If !Empty(SC6->C6_CPROCLI)
		dbSelectArea("SC6")
		dbSkip()
		Loop
	Endif
    
	_cProdCli := ""
	dbSelectArea("SZ2")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ2") + SC6->C6_CLI  + SC6->C6_LOJA + SC6->C6_PRODUTO)
		_cProdCli := SZ2->Z2_CODCLI
	Endif
	   		              
	dbSelectArea("SC6")
	RecLock("SC6",.F.)
	SC6->C6_CPROCLI := _cProdCli
	MsUnlock()

	dbSelectArea("SC6")
	dbSkip()	
EndDo		
   		
Return