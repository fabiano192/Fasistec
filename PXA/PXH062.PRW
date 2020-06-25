#include "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PXH062   º Autor ³ Alexandro          º Data ³  10/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Manutençao SZQ                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CONTABILIDADE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PXH062()

Private cCadastro:= "Manutençao NF Saida"

Private aRotina  := {{"Pesquisar","AxPesqui",0,1},;
{"Visualizar","AxVisual",0,2},;
{"Alterar"   ,"U_PX6201",0,3}}

Private cDelFunc := ".t."

dbSelectArea("ZZD")
dbSetOrder(1)

MBrowse(6,1,22,75,"ZZD")

Return

User Function PX6201()

_aAliOri := GetArea()
_cCr     := Space(09)                   
_nPeso   := 0

@ 090,040 To 270,500 Dialog oDlg1 Title "Manutençao Nota Fiscal de Saida"
@ 003,003 To 034,232

@ 006,005  Say "Filial:"      //COMPRIMENTO, LARGURA
@ 005,020  Get ZZD->ZZD_CODFIL Size 010,010 When .F.

@ 006,050  Say "Nota Fiscal:"
@ 005,080  Get ZZD->ZZD_DOC    Size 030,030 When .F.

@ 006,120  Say "Serie:"
@ 005,135  Get ZZD->ZZD_SERIE  Size 030,010 When .F.

@ 006,170  Say "Emissao:"
@ 005,195  Get ZZD->ZZD_EMIS   Size 030,030 When .F.

@ 021,005  Say "Produto:"
@ 020,030  Get ZZD->ZZD_PROD   Size 050,010 When .F.

@ 021,082  Say "Descrição:"
@ 020,110  Get ZZD->ZZD_DESCPR Size 060,010 When .F.

@ 021,180  Say "TES:"
@ 020,195  Get ZZD->ZZD_TES    Size 010,010 When .F.

//@ 045,15  Say "Centro Custo Anterior:"
//@ 045,100 Get ZZD->ZZD_YCC   Size 50,100 When .F.

//@ 060,15  Say "Novo Centro de Custo:"
//@ 060,100 Get _cCr          F3 "CTT" Valid ExistCpo("CTT",_cCr) .And. CTT->CTT_CLASSE == "2" Size 50,100 When .T.

@ 046,005  Say "Centro Custo Anterior:"
@ 045,060  Get ZZD->ZZD_YCC   Size 050,010 When .F.

@ 061,005  Say "Novo Centro de Custo:"
@ 060,060  Get _cCr          F3 "CTT" Valid ExistCpo("CTT",_cCr) .And. CTT->CTT_CLASSE == "2" Size 050,010 When .T.

@ 046,115  Say "Peso Ouro Fundido Ant.:"
@ 045,180  Get ZZD->ZZD_QTLIQ   When .F. Picture "@E 999,999.9999"  Size 050,010 

@ 061,115  Say "Novo Peso Ouro Fundido:"
@ 060,180  Get _nPeso          When .T. Picture "@E 999,999.9999"   Size 050,010 

@ 075,160 BmpButton Type 1  Action PX6202()
@ 075,200 BmpButton Type 2  Action Close(oDlg1)

Activate Dialog oDlg1 Centered

RestArea(_aAliOri)

Return

Static Function PX6202()

Close(oDlg1)

_aAliSD2 := SD2->(GetArea())

ZZD->(RecLock("ZZD",.F.))
ZZD->ZZD_YCC    := _cCr
ZZD->ZZD_DESCCC := CTT->CTT_DESC01
ZZD->ZZD_QTLIQ  := _nPeso
ZZD->(MsUnlock())

SD2->(dbSetOrder(3))
If SD2->(dbSeek(ZZD->ZZD_CODFIL + ZZD->ZZD_DOC + ZZD->ZZD_SERIE + ZZD->ZZD_CLIE + ZZD->ZZD_LOJA + ZZD->ZZD_PROD + ZZD->ZZD_ITEM ))
	SD2->(RecLock("SD2",.F.))
	SD2->D2_YCR     := _cCr
	SD2->D2_YQTDFUN := _nPeso
	SD2->(MsUnlock())
Endif

RestArea(_aAliSD2)

Return