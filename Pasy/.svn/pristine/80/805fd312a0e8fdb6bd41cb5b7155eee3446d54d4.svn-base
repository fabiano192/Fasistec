#include "rwmake.ch"

User Function PA0048C()

Private _cRevis := _cComp := ""
_cPorta  := "LPT1"
//_cPorta  := "LPT3"
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
_cPedCli := SPACE(10)
_cDestino:= SPACE(40)

Private _cPedItem  := Space(08)

@ 0  ,0 TO 300,450 DIALOG oDlg1 TITLE "Etiquetas Clientes Nacionais"
@ 10 ,10 SAY "Data"
@ 10 ,70 GET _dData  PICTURE "@!" SIZE 70,10 OBJECT _oData
@ 30 ,10 SAY "Nome Cliente"
@ 30 ,70 GET _cNome  PICTURE "@!" SIZE 120,10 OBJECT _oCliente
@ 50 ,10 SAY "Destino"
@ 50 ,70 GET _cDestino PICTURE "@!" SIZE 120,10 OBJECT _oDestino                       
@ 70 ,10 SAY "Nota Fiscal:"
@ 70 ,70 GET _cNota  PICTURE "@!" SIZE 70,10 OBJECT _oNota
@ 90,10 SAY "Qtd. Etiquetas:"
@ 90,70 GET _nQuant   PICTURE "@E 9999" SIZE 70,10 OBJECT _oQtEtiq

@ 110,150 BMPBUTTON TYPE 1 ACTION Processa({|| ImpEt() })
@ 110,180 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER

Return

Static Function VerProd()

_lRet    :=.F.
_cDescP  :=""

DBSELECTAREA("SB1")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SB1")+_cCod)
	_cDescP  := SB1->B1_DESC
	_lREt    := .T.
Endif

_oWDESCP :Refresh()
_oWCod   :Refresh()
_oNota   :Refresh()
_oQtEtiq :Refresh()
_oQtPc   :Refresh()

Return(_lRet)

Static Function ImpEt()

_nQtEt := _nQuant
_cData := Strzero(day(_dData),2)+"-"+substr(mes(_dData),1,3)+	"-"+substr(strzero(year(_dData),4),3,2)


MSCBPRINTER("ARGOX",_cPorta,,,.f.)
MSCBCHKSTATUS(.f.)

MSCBLOADGRF("\SYSTEM\logPasy2.bmp")

MSCBBEGIN(_nQtEt,6)

//Logo Tipo
MSCBGRAFIC(05,60,"logPasy2")


// Dados da Empresa
MSCBSAY(28,65,"PASY IND. E COM. DE BORRACHA E PLASTICO LTDA "			  , "N", "2", "1",.F.)
MSCBSAY(28,62,"AV. RAIMUNDO PEREIRA DE MAGALHAES,4100"    	              , "N", "2", "1",.F.)
MSCBSAY(28,59,"CEP: 05145-200   SAO PAULO - SP"                           , "N", "2", "1",.F.)
MSCBSAY(28,56,"C.N.P.J.: 60.675.048/0001-21"                              , "N", "2", "1",.F.) 
MSCBLINEH(05,55,98,2,"B")

// Dados do ProdutO / Cliente
MSCBSAY(05,51,"CLIENTE"                                                   , "N", "2", "1",.F.)
MSCBSAY(05,48,"COSTUMER"                                                  , "N", "2", "1",.F.)
MSCBSAY(25,49,_cNome                                                      , "N", "3", "1",.F.)
MSCBSAY(05,43,"Destino"						                              , "N", "2", "1",.F.)
MSCBSAY(05,40,"COSTUMER P.No"                  		    		          , "N", "2", "1",.F.)
MSCBSAY(25,41,_cDestino                                                   , "N", "3", "1",.F.)
MSCBSAY(05,35,"NOTA FISCAL"											      , "N", "2", "1",.F.)
MSCBSAY(05,32,"INVOICE"												      , "N", "2", "1",.F.)
MSCBSAY(25,33,_CNOta												      , "N", "3", "1",.F.)
MSCBSAY(05,27,"DATA"												      , "N", "2", "1",.F.)
MSCBSAY(05,24,"DATE"												      , "N", "2", "1",.F.)
MSCBSAY(25,25,_cData	                                                  , "N", "3", "1",.F.)

//COD. DE BARRAS
MSCBSAYBAR(10,03,"1234567890123"					                      ,"N","MB04",13,.F.,.T.,.F.,,2,2)
MSCBSAYBAR(50,03,"12345678901234"					                      ,"N","MB07",13,.F.,.T.,.F.,,2,2)

MSCBEND()

MSCBClosePrinter()

_oNota    :Refresh()
_oQtEtiq  :Refresh()
_oData    :Refresh()
_oCliente :Refresh()
_oDestino  :Refresh()


Return                                                          
