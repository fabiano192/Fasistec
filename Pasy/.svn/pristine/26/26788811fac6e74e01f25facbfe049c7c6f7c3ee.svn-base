#include "rwmake.ch"

User Function PA0048()

Private _cRevis := _cComp := ""
_cPorta  := "LPT1"
_cCOD    := SPACE(15)
_cPedido := Space(6)
_cNota   := Space(6)
_nQuant  := 000000
_nQuant2 := 000000
_cDescp  := ""
Private _cPedItem  := Space(08)

@ 0  ,0 TO 350,450 DIALOG oDlg1 TITLE "Etiquetas Clientes Nacionais Logo Novo"
@ 10 ,10 SAY "Codigo:"
@ 10 ,70 GET _cCod     PICTURE "@!" SIZE 70,10 VALID VerProd() F3 "SB1" OBJECT _OWCOD
@ 30 ,10 GET _cDescP   SIZE 165,10 WHEN .F. OBJECT _OWDESCP
@ 70 ,10 SAY "Nota Fiscal:"
@ 70 ,70 GET _cNota  PICTURE "@!" SIZE 70,10 VALID Vernota()  OBJECT _oNota
@ 090,10 SAY "Qtd. Etiquetas:"
@ 090,70 GET _nQuant   PICTURE "@E 9999" SIZE 50,10 VALID VERETI() OBJECT _oQtEtiq
@ 110,10 SAY "Qtd. Pecas:"
@ 110,70 GET _nQuant2  PICTURE "@E 999999" SIZE 50,10 VALID VERQTDE() OBJECT _oQtPc
@ 130,10 SAY "Pedido + Item "
@ 130,70 GET _cPedItem PICTURE "@!" SIZE 70,10 VALID VERPED() OBJECT _oPedItem

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
_oPedItem:Refresh()

Return(_lRet)


Static Function VerETI()

_lRet    :=.t.

If _nQuant == 0
	_lRet := .F.
Endif

Return(_lRet)


Static Function VerQTDE()

_lRet    :=.t.

If _nQuant2 == 0
	_lRet := .F.
Endif

Return(_lRet)



Static Function VERPED()

_lRet    := .f.
/*
dbSelectArea("SC6")
dbSetOrder(1)
If dbSeek(xFilial("SC6")+_cPedItem)
	_lRet := .t.
Endif
*/                             
dbSelectArea("SD2")
dbSetOrder(8)
If dbSeek(xFilial("SD2")+_cPedItem)
	If SD2->D2_DOC == _cNota
		_lRet := .T.
	Endif
Endif

Return(_lRet)


Static Function VerNota()

_lRet := .F.
dbSelectArea("SF2")
dbSetOrder(1)
If dbSeek(xFilial("SF2") +_cNota )
   dbSelectArea("SD2")
   dbSetOrder(3)
   dbSeek(xFilial("SD2")+_cNota + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA + _cCod)
	_lRet := .T.
Endif

dbSelectArea("SZ2")
dbSetOrder(1)
dbSeek(xFilial("SZ2")+SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD + SD2->D2_PROCLI)

If Empty(SZ2->Z2_REVISAO)
   _cRevis := "00"
Else
   _cRevis := Substr(SZ2->Z2_REVISAO,1,3)
Endif

Return(_lRet)



Static Function ImpEt()


dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)

_nQtEt := _nQuant
_dData := SF2->F2_EMISSAO
_cData := Strzero(day(_dData),2)+"-"+substr(mes(_dData),1,3)+	"-"+substr(strzero(year(_dData),4),3,2)


MSCBPRINTER("ARGOX",_cPorta,,,.f.)
MSCBCHKSTATUS(.f.)

MSCBLOADGRF("\SIGAADV\PA0048.BMP")


MSCBBEGIN(_nQtEt,6)

//           x y   Primeira Linha
//       1  2              3                    4    5      6    7

//Logo Tipo
//MSCBGRAFIC(05,56,"PA0048")
MSCBGRAFIC(05,60,"PA0048")


// Dados da Empresa
MSCBSAY(28,65,"PASY IND. E COM. DE BORRACHA E PLASTICO LTDA "			  , "N", "1", "2",.F.)
MSCBSAY(28,62,"AV. RAIMUNDO PEREIRA DE MAGALHAES,4100"    	              , "N", "1", "2",.F.)
MSCBSAY(28,59,"CEP: 05145-200   SAO PAULO - SP"                           , "N", "1", "2",.F.)
MSCBSAY(28,56,"C.N.P.J.: 60.675.048/0001-21"                              , "N", "1", "2",.F.) 
MSCBSAY(80,56,_cData	                                                  , "N", "3", "1",.F.)
MSCBLINEH(05,55,98,2,"B")
// Dados do ProdutO / Cliente
MSCBSAY(05,51,"CLIENTE"                                                   , "N", "1", "2",.F.)
MSCBSAY(05,48,"COSTUMER"                                                  , "N", "1", "2",.F.)
MSCBSAY(22,49,SUBSTR(SA1->A1_NOME,1,40)                                   , "N", "3", "1",.F.)
MSCBSAY(05,44,"COD. CLIENTE"				                              , "N", "1", "2",.F.)
MSCBSAY(05,41,"COSTUMER P.No"                  		    		          , "N", "1", "2",.F.)
MSCBSAY(22,42,SD2->D2_PROCLI                                              , "N", "3", "1",.F.)
MSCBSAY(53,43,"REV."										              , "N", "1", "2",.F.)
MSCBSAY(58,42,_cRevis                                                     , "N", "3", "1",.F.)
//MSCBSAY(05,35,"ESPEC. CLIENTE"				                            , "N", "1", "2",.F.)
//MSCBSAY(05,32,"COSTUMER SPEC."				                            , "N", "1", "2",.F.)
//MSCBSAY(22,33,ALLTRIM(SZ2->Z2_ESPCLIE)                             	    , "N", "3", "1",.F.)
MSCBSAY(68,44,"PEDIDO"  										          , "N", "1", "2",.F.)
MSCBSAY(68,41,"ORDER"  								     		          , "N", "1", "2",.F.)
MSCBSAY(82,42,SC6->C6_PEDCLI  								    		  , "N", "3", "1",.F.)
MSCBSAY(05,37,"PRODUTO PASY"				                              , "N", "1", "2",.F.)
MSCBSAY(05,34,"PASY P.No"                  		        		          , "N", "1", "2",.F.)
MSCBSAY(22,35,SD2->D2_COD                                                 , "N", "3", "1",.F.)
//MSCBSAY(69,33,"MATERIAL"                               		     	    , "N", "1", "2",.F.)
//MSCBSAY(80,33,ALLTRIM(_cComp)                                    	        , "N", "3", "1",.F.)
MSCBSAY(05,30,"O.P" 						        				      , "N", "1", "2",.F.)
MSCBSAY(05,27,"P.O"					     			   		     	      , "N", "1", "2",.F.)
MSCBSAY(22,28,_cPedItem                                            	      , "N", "3", "1",.F.)
MSCBSAY(68,30,"QTDE"												      , "N", "1", "2",.F.)
MSCBSAY(68,27,"QTY"												          , "N", "1", "2",.F.)
MSCBSAY(82,28,Alltrim(TRANSFORM(_nQuant2,"@E 999,999,999 "))+" "+SD2->D2_UM	  , "N", "3", "1",.F.)
MSCBSAY(05,23,"DESCRICAO"                                 		     	  , "N", "1", "2",.F.)
MSCBSAY(05,20,"DESCRIPTION"                                               , "N", "1", "2",.F.)
MSCBSAY(22,21,Substr(SZ2->Z2_DESCCLI,1,30)                                , "N", "3", "1",.F.)
MSCBSAY(68,37,"NOTA FISCAL"											      , "N", "1", "2",.F.)
MSCBSAY(68,34,"INVOICE"												      , "N", "1", "2",.F.)
MSCBSAY(82,35,_CNOta												      , "N", "3", "1",.F.)
//MSCBSAY(68,23,"DATA"						        				        , "N", "1", "2",.F.)
//MSCBSAY(68,20,"DATE"					     			   			        , "N", "1", "2",.F.)
//MSCBSAY(82,21,_cData	                                                    , "N", "3", "1",.F.)

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
_oPedItem :Refresh()

Return