#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºExecblock ³PA0050  Autor³ Fabiano da Silva        º Data ³  24/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressão de Etiquetas de Embalagem (Exportação)           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Sigafat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0050()


_cPorta  := "LPT1"
_cCOD    := SPACE(15)
_cPedido := Space(6)
_cNota   := Space(9)
_nQtEtiq := 00000
_nQtPcEmb:= 00000
_nQtPeca := 00000
_cDescp  := ""
_nQtdEmb := 0000

@ 0  ,0 TO 390,520 DIALOG oDlg1 TITLE "Etiquetas Clientes Exportaçao"
@ 10 ,10 SAY "Codigo:"
@ 10 ,70 GET _cCod     PICTURE "@!" SIZE 70,10 VALID VerProd() F3 "SB1" OBJECT OWCOD
@ 30 ,10 GET _cDescP   SIZE 165,10 WHEN .F. OBJECT OWDESCP
@ 70 ,10 SAY "Pedido de Venda:"
@ 70 ,70 GET _cPedido  PICTURE "@!" SIZE 70,10 VALID VerPed()  OBJECT oPedido
@ 90 ,10 SAY "Nota Fiscal:"
@ 90 ,70 GET _cNota PICTURE "@!" SIZE 70,10 VALID VerNota()  OBJECT oNota
@ 110,10 SAY "Qtd. Total Pecas:"
@ 110,70 GET _nQtPeca   PICTURE "@E 99999" SIZE 50,10 VALID VERQTPC()
@ 130,10 SAY "Qtd. Copias:"
@ 130,70 GET _nQtEtiq   PICTURE "@E 99999" SIZE 50,10 VALID VERETI()
@ 150,10 SAY "Qtd. Pecas P/ Emb:"
@ 150,70 GET _nQtPcEmb  PICTURE "@E 99999" SIZE 50,10 VALID VERQTEM()
@ 170,10 SAY "Qtd. de Embalagem:"
@ 170,70 GET _nQtdEmb  PICTURE "@E 9999" SIZE 50,10 VALID VERQTEMB()

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

oWDESCP :Refresh()

Return(_lRet)


Static Function VerETI()

_lRet    :=.t.

If _nQtEtiq == 0
	_lRet := .F.
Endif

Return(_lRet)


Static Function VerQTEM()

_lRet    :=.t.

If _nQtPcEmb == 0
	_lRet := .F.
Endif

Return(_lRet)


Static Function VerQTEMB()

_lRet    :=.t.

If _nQtdEmb == 0
	_lRet := .F.
Endif

Return(_lRet)


Static Function VerQTPC()

_lRet    :=.t.

If _nQTPECA == 0
	_lRet := .F.
Endif

Return(_lRet)


Static Function VerPed()

_lRet := .F.
dbSelectArea("SC6")
dbSetOrder(2)
If dbSeek(xFilial("SC6") + _cCod + _cPedido )
	_lRet := .T.
Endif

Return(_lRet)


Static Function VerNota()

_lRet := .F.
dbSelectArea("SD2")
dbSetOrder(3)
If dbSeek(xFilial("SD2") + _cNota)
	_lRet := .T.
Endif
                
Return(_lRet)


Static Function ImpEt()

DBSELECTAREA("SA1")
DBSETORDER(1)
DBSEEK(XFILIAL("SA1")+SC6->C6_CLI+SC6->C6_LOJA)

DBSELECTAREA("SZ2")
DBSETORDER(4)
DBSEEK(XFILIAL("SZ2")+SC6->C6_CPROCLI+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_PRODUTO)

_cPais := ""
dbSelectArea("SYA")
dbSetOrder(1)
If dbSeek(xFilial("SYA")+SA1->A1_PAIS)
	_cPais := SYA->YA_NOIDIOM
Endif

_cPorta:= "LPT1"

MSCBPRINTER("ARGOX",_cPorta,,,.f.)
MSCBCHKSTATUS(.f.)
MSCBLOADGRF("\SYSTEM\LOGPASY.BMP")

_nQtPeca2 := 0
_cProdCli := SZ2->Z2_CODCLI
_nQtde    := 0
_nCont    := 0

For I:= 1  to _nQtPeca
	_nCont++
	
	MSCBBEGIN(_nQtEtiq,6)
	
	//Logo Tipo
	MSCBGRAFIC(18,128,"logpasy")
//	MSCBGRAFIC(18,128,"PA0050")
	
	// Dados da Empresa
	MSCBSAY(06,120,"PASY IND. E COM. DE BORRACHA E PLASTICO LTDA"  , "N", "3", "1,1",.F.)
	MSCBSAY(06,116,"AV. RAIMUNDO PEREIRA DE MAGALHAES,4100"        , "N", "2", "1,1",.F.)
	MSCBSAY(06,112,"05145-200 - SAO PAULO - SP - BRAZIL"           , "N", "2", "1,1",.F.)
	MSCBLINEH(06,108,98,2,"B")
	
	// Dados do Cliente
	MSCBSAY(40,103,"SHIP TO"                                      , "N", "3", "1,1" ,.F.)
	
	MSCBSAY(06,95, Alltrim(SA1->A1_NOME)                      , "N", "5", "1,1" ,.F.)
/*
	If Len(Alltrim(SA1->A1_NOME))<=35
		MSCBSAY(06,95, Alltrim(SA1->A1_NOME)                      , "N", "5", "1,1" ,.F.)
	Else
		MSCBSAY(06,95, Alltrim(SA1->A1_NOME)                      , "N", "3", "2"   ,.F.)
	Endif
	*/
	MSCBSAY(06,90, SUBSTR(SA1->A1_END,1,40)                       , "N", "3", "1,1" ,.F.)
	MSCBSAY(06,85, SUBSTR(SA1->A1_MUN,1,40)                       , "N", "3", "1,1" ,.F.)
	MSCBSAY(06,80, SUBSTR(_cPais,1,100)                           , "N", "3", "1,1" ,.F.)
	MSCBLINEH(06,77,98,2,"B")
	
	// DADOS DA PEÇA
	MSCBSAY(06,72,"PART NUMBER:"                                  , "N", "3", "1,1" ,.F.)
	MSCBSAY(41,72,"EC: "                                          , "N", "3", "1,1" ,.F.)
	MSCBSAY(64,72,"PURCHASE ORDER:"                               , "N", "3", "1,1" ,.F.)
	MSCBLINEV(61,13,77,2,"B")
	MSCBSAY(06,66, SUBSTR(_cProdCli,1,40)                         , "N", "4", "1,1" ,.F.)
	MSCBSAY(41,66, SUBSTR(SZ2->Z2_REVISAO,1,40)                   , "N", "4", "1,1" ,.F.)
	MSCBSAY(64,66, SUBSTR(SZ2->Z2_PEDCLI,1,40)                    , "N", "4", "1,1" ,.F.)
	MSCBLINEH(06,47,98,2,"B")
	MSCBSAYBAR(06,50,alltrim(_cProdCli)                  ,"N","MB07",10,.F.,.T.,.F.,,3,2)
	MSCBSAYBAR(41,50,alltrim(SZ2->Z2_REVISAO)            ,"N","MB07",10,.F.,.T.,.F.,,3,2)
	MSCBSAYBAR(64,50,alltrim(SZ2->Z2_PEDCLI)             ,"N","MB07",10,.F.,.T.,.F.,,3,2)
	
	MSCBSAY(25,42,"DESCRIPTION:"                                  , "N", "3", "1,1" ,.F.)
	MSCBSAY(75,42,"QUANTITY:"                                     , "N", "3", "1,1" ,.F.)
	MSCBSAY(06,35, SUBSTR(SZ2->Z2_DESCCLI,1,40)                   , "N", "4", "1,1" ,.F.)
	
	_nQtPeca2 += _nQtPcEmb
	If _nQtPeca > _nQtPeca2
		_nQtImp   := _nQtPcEmb
	Else
		_nQtImp   := ((_nQtPeca2-_nQtPcEmb) - _nQtPeca) * -1
		i         := _nQtPeca
	Endif
	MSCBSAY(75,35,TRANSFORM(_nQtImp,"@E 999,999,999")             , "N", "4", "1,1" ,.F.)
	MSCBLINEH(06,30,98,2,"B")
	          	           
    _dData := SD2->D2_EMISSAO
	_cData := Strzero(day(_dData),2)+"-"+substr(mes(_dData),1,3)+	"-"+substr(strzero(year(_dData),4),1,4)
	                          
	MSCBSAY(25,25,"SHIP DATE:"                     				  , "N", "3", "1,1" ,.F.)
	MSCBSAY(06,18, _cData				            			  , "N", "4", "1,1" ,.F.)

	MSCBSAY(75,25,"N.F.: "                         				  , "N", "3", "1,1" ,.F.)
	MSCBSAY(70,18, _cNota           	            			  , "N", "4", "1,1" ,.F.)

	MSCBLINEH(06,12,98,2,"B")
	
	MSCBSAY(24,06,"BOX:"                         				  , "N", "4", "1,1" ,.F.)
	MSCBSAY(46,06, Str(_nCont)+"  OF  "+alltrim(Str(_nQtdEmb))    , "N", "4", "1,1" ,.F.)
	
	MSCBEND()
	
	MSCBClosePrinter()
	
Next A
//Next I

Return


////////////////////////////////////////////
////////////////////////////////////////////
///////- Grupo de Perguntas - PA0031 ///////
/// Variavel     // Descricao        ///////
/// MV_PAR01     // Nota Fiscal De?  ///////
/// MV_PAR02     // Nota Fiscal Ate? ///////
/// MV_PAR03     // Serie          ? ///////
/// MV_PAR04     // Produto De     ? ///////
/// MV_PAR05     // Produto Ate    ? ///////
/// MV_PAR06     // Quantidade Por Emb.? ///
/// MV_PAR07     // Quantidade Copias? /////
/// MV_PAR08     // Quantidade Embal.? /////
////////////////////////////////////////////
////////////////////////////////////////////


/////////////////////////////////////////////////
/////////////////////////////////////////////////
///////- Grupo de Perguntas - PA0050      ///////
/// Variavel     // Descricao             ///////
/// MV_PAR01     // PRODUTO ?             ///////
/// MV_PAR02     // PEDIDO ?              ///////
/// MV_PAR03     // QUANTID. TOTAL        ///////
/// MV_PAR04     // QUANTID. P/ EMBALAGEM ///////
/// MV_PAR05     // QUANTID. DE EMBALAGEM ///////
/// MV_PAR06     // Quantidade Copias?    ///////
/////////////////////////////////////////////////
/////////////////////////////////////////////////
