#include "rwmake.ch"

User Function PA0048B()

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
_cPedCli := SPACE(10)


Private _cPedItem  := Space(08)

@ 0  ,0 TO 550,550 DIALOG oDlg1 TITLE "Etiquetas Clientes Nacionais"
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
@ 230,10 SAY "Qtd. Etiquetas:"
@ 230,70 GET _nQuant   PICTURE "@E 9999" SIZE 50,10 OBJECT _oQtEtiq

@ 20,185 BMPBUTTON TYPE 1 ACTION Processa({|| ImpEt() })
@ 45,185 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
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



/*Static Function VerCliente()

_lRet    :=.F.
_cNome  :=""


DBSELECTAREA("SA1")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SA1")+_cCliente)
	_cNome  := SA1->A1_Nome
	_lREt    := .T.
Endif

_oWDESCP :Refresh()
_oWCod   :Refresh()
_oNota   :Refresh()
_oQtEtiq :Refresh()
_oQtPc   :Refresh()


Return(_lRet)
*/

Static Function ImpEt()

_nQtEt := _nQuant
_cData := Strzero(day(_dData),2)+"-"+substr(mes(_dData),1,3)+	"-"+substr(strzero(year(_dData),4),3,2)


MSCBPRINTER("ARGOX",_cPorta,,,.f.)
MSCBCHKSTATUS(.f.)

MSCBLOADGRF("\SYSTEM\logPasy2.bmp")

MSCBBEGIN(_nQtEt,6)

//           x y   Primeira Linha
//       1  2              3                    4    5      6    7

//Logo Tipo
MSCBGRAFIC(05,60,"logPasy2")

// Dados da Empresa
MSCBSAY(28,65,"PASY IND. E COM. DE BORRACHA E PLASTICO LTDA "			  , "N", "2", "1",.F.)
MSCBSAY(28,62,"AV. RAIMUNDO PEREIRA DE MAGALHAES,4100"    	              , "N", "2", "1",.F.)
MSCBSAY(28,59,"CEP: 05145-200   SAO PAULO - SP"                           , "N", "2", "1",.F.)
MSCBSAY(28,56,"C.N.P.J.: 60.675.048/0001-21"                              , "N", "2", "1",.F.) 
MSCBSAY(80,56,_cData	                                                  , "N", "3", "1",.F.)
MSCBLINEH(05,55,98,2,"B")

// Dados do ProdutO / Cliente
MSCBSAY(05,51,"CLIENTE"                                                   , "N", "2", "1",.F.)
MSCBSAY(05,48,"COSTUMER"                                                  , "N", "2", "1",.F.)
MSCBSAY(25,49,_cNome                                                      , "N", "3", "1",.F.)
MSCBSAY(05,44,"COD. CLIENTE"				                              , "N", "2", "1",.F.)
MSCBSAY(05,41,"COSTUMER P.No"                  		    		          , "N", "2", "1",.F.)
MSCBSAY(25,42,_cCodCli                                                    , "N", "3", "1",.F.)
MSCBSAY(53,43,"REV."										              , "N", "2", "1",.F.)
MSCBSAY(58,42,_cRev                                                       , "N", "3", "1",.F.)
MSCBSAY(65,44,"PEDIDO"  										          , "N", "2", "1",.F.)
MSCBSAY(65,41,"ORDER"  								     		          , "N", "2", "1",.F.)
MSCBSAY(83,42,_cPedCli       								    		  , "N", "3", "1",.F.)
MSCBSAY(05,37,"PRODUTO PASY"				                              , "N", "2", "1",.F.)
MSCBSAY(05,34,"PASY P.No"                  		        		          , "N", "2", "1",.F.)
MSCBSAY(25,35,SB1->B1_COD                                                 , "N", "3", "1",.F.)
MSCBSAY(05,30,"O.P" 						        				      , "N", "2", "1",.F.)
MSCBSAY(05,27,"P.O"					     			   		     	      , "N", "2", "1",.F.)
MSCBSAY(25,28,_cOP                                              	      , "N", "3", "1",.F.)
MSCBSAY(65,30,"QTDE"												      , "N", "2", "1",.F.)
MSCBSAY(65,27,"QTY"												          , "N", "2", "1",.F.)
MSCBSAY(83,28,Alltrim(TRANSFORM(_nQuant2,"@E 999,999,999 "))+" "+SB1->B1_UM	  , "N", "3", "1",.F.)
MSCBSAY(05,23,"DESCRICAO"                                 		     	  , "N", "2", "1",.F.)
MSCBSAY(05,20,"DESCRIPTION"                                               , "N", "2", "1",.F.)
MSCBSAY(25,21,SB1->B1_Desc                                               , "N", "3", "1",.F.)
MSCBSAY(65,37,"NOTA FISCAL"											      , "N", "2", "1",.F.)
MSCBSAY(65,34,"INVOICE"												      , "N", "2", "1",.F.)
MSCBSAY(83,35,_CNOta												      , "N", "3", "1",.F.)

//COD. DE BARRAS
MSCBSAYBAR(10,03,alltrim(SB1->B1_CBAR14)                      ,"N","MB04",13,.F.,.T.,.F.,,2,2)
MSCBSAYBAR(50,03,alltrim(SB1->B1_CODETIQ)                      ,"N","MB07",13,.F.,.T.,.F.,,2,2)

MSCBEND()



MSCBClosePrinter()

_cDescP   := ""
_cCod     := space(15)

_oWDESCP  :Refresh()
_oWCod    :Refresh()
_oNota    :Refresh()
_oQtEtiq  :Refresh()
_oQtPc    :Refresh()
_oData    :Refresh()
_oCliente :Refresh()
_oCodCli  :Refresh()
_oRev     :Refresh()
_oPedCli  :Refresh()
_oOP      :Refresh()

Return                                                          
