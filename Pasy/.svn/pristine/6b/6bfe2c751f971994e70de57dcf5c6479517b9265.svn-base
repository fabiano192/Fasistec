#include "rwmake.ch"

User Function PA0068()

Private _cRevis := _cComp := ""
_cPorta  := "LPT1"
_cCOD    := SPACE(15)
_cPedido := Space(6)
_cNota   := Space(6)
_nQuant  := 00000
_nQuant2 := 00000
_cDescp  := ""
_dData   := dDataBase
_cNome   := SPACE(40)
_cCliente:= SPACE(6)
_cCodCli := SPACE(15)
_cRev    := SPACE(3)
_cOP     := SPACE(8)
_cPedCli := SPACE(8)


Private _cPedItem  := Space(08)

@ 0  ,0 TO 550,550 DIALOG oDlg1 TITLE "Impressão Logo Pasy"
/*
@ 10 ,10 SAY "Data"
@ 10 ,70 GET _dData  PICTURE "@!" SIZE 70,10 OBJECT _oData
@ 30 ,10 SAY "Nome Cliente"
@ 30 ,70 GET _cNome  PICTURE "@!" SIZE 70,10 OBJECT _oCliente

@ 70 ,10 SAY "Cód. Produto Cliente"
@ 70 ,70 GET _cCodCli  PICTURE "@!" SIZE 70,10 OBJECT _oCodCli
@ 90 ,10 SAY "Revisão"
@ 90 ,70 GET _cRev  PICTURE "@!" SIZE 70,10 OBJECT _oRev
@ 110 ,10 SAY "Codigo:"
@ 110 ,70 GET _cCod     PICTURE "@!" SIZE 70,10 F3 "SB1" Valid verprod() OBJECT _OWCOD
@ 130 ,10 GET _cDescP   SIZE 165,10 WHEN .F. OBJECT _OWDESCP    
@ 150,10 SAY "O.P. "
@ 150,70 GET _cOP PICTURE "@!" SIZE 70,10 OBJECT _oOP
@ 170,10 SAY "Pedido Cliente"                      
@ 170,70 GET _cPedCli PICTURE "@!" SIZE 70,10 OBJECT _oPedCli
@ 190 ,10 SAY "Nota Fiscal:"
@ 190 ,70 GET _cNota  PICTURE "@!" SIZE 70,10 OBJECT _oNota
@ 210,10 SAY "Qtd. Pecas:"
@ 210,70 GET _nQuant2  PICTURE "@E 9999" SIZE 50,10 OBJECT _oQtPc
*/
@ 150,10 SAY "Qtd. Etiquetas:"
@ 150,70 GET _nQuant   PICTURE "@E 9999" SIZE 50,10 OBJECT _oQtEtiq

@ 20,185 BMPBUTTON TYPE 1 ACTION Processa({|| ImpEt() })
@ 45,185 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER

Return




Static Function ImpEt()

_nQtEt := _nQuant


MSCBPRINTER("ARGOX",_cPorta,,,.f.)
MSCBCHKSTATUS(.f.)

MSCBLOADGRF("\SIGAADV\logteste.bmp")


MSCBBEGIN(_nQtEt,6)

MSCBGRAFIC(05,25,"logteste")

MSCBEND()

MSCBClosePrinter()

Return                                                          