#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACEDIVER  º Autor ³ Alexandro da Silva º Data ³  06/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualizaçao Produto X Cliente                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0154()

AtuSX1()

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Rotina Para Criar EE8 com Base no SC6")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina Para Criar EE8 com base nos pedidos de Venda "     SIZE 160,7
@ 18,18 SAY "devido erro na importação dos dados.                "     SIZE 160,7
@ 26,18 SAY "Programa PA0154.PRW                                 "     SIZE 160,7
@ 34,18 SAY "                                                    "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0154")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	Private _cMsg01    := ''
	Private _lFim      := .F.
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| PA0154A(@_lFim) }
	Private _cTitulo01 := 'Gerando Pedidos!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
Endif

Return


Static Function PA0154A(_lFim)

Pergunte("PA0154",.F.)

_cQ := " SELECT * FROM SC6010 C6 "
_cQ += " WHERE C6.D_E_L_E_T_ = '' AND C6_BLQ = '' "
_cQ += " AND C6_CLI = '000171' AND C6_NUM  = '"+MV_PAR01+"'AND C6_QTDVEN > C6_QTDENT "
_cQ += " ORDER BY C6_NUM,C6_ITEM "             

TCQUERY _cQ New ALIAS "ZC6"

TCSETFIELD("ZC6","C6_ENTREG","D")

ZC6->(dbGotop())

ProcRegua(ZC6->(U_CONTREG()))

While ZC6->(!Eof()) .And. !_lFim
	
	IncProc()
	
	If _lFim
		REturn
	Endif
	                                                                 
	EE8->(dbOrderNickName("INDEE81"))
	If EE8->(dbSeek(xFilial("EE8")+ZC6->C6_NUM + SPACE(14) + ZC6->C6_ITEM))
		ZC6->(dbSkip())
		Loop
	Endif
                                     
	SC5->(dbSetOrder(1))
	If !SC5->(dbSeek(xFilial("SC5")+ZC6->C6_NUM))               
		ZC6->(dbSkip())
		Loop
	Endif	     
	                              
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek (xFilial("SB1")+ZC6->C6_PRODUTO)
		_nPosIPI := SB1->B1_POSIPI
		_cUM     := SB1->B1_UM
	Endif

	dbSelectArea("EE8")
	RecLock("EE8",.T.)
	EE8->EE8_COD_I  := ZC6->C6_PRODUTO
	_cCodDes        := GETIDMEMO()
	EE8->EE8_DESC   := _cCodDes
	EE8->EE8_TIPPED := ZC6->C6_PEDAMOS
	EE8->EE8_DTENTR := ZC6->C6_ENTREG
	EE8->EE8_DTPREM := SC5->C5_EMISSAO
	EE8->EE8_CODCLI := ZC6->C6_CPROCLI
	EE8->EE8_EMBAL1 := "MC1050"
	EE8->EE8_FABR   := "000211"
	EE8->EE8_FALOJA := "01"
	EE8->EE8_FATIT  := ZC6->C6_ITEM
	EE8->EE8_FOLOJA := "01"
	EE8->EE8_FORN   := "000211"
	EE8->EE8_PART_N := ZC6->C6_CPROCLI
	EE8->EE8_PEDIDO := ZC6->C6_NUM
	EE8->EE8_POSIPI := _nPosIPI
	EE8->EE8_PRCINC := ZC6->C6_VALOR
	EE8->EE8_PRCTOT := ZC6->C6_VALOR
	EE8->EE8_PRECO  := ZC6->C6_PRCVEN
	EE8->EE8_PRECOI := ZC6->C6_PRCVEN
	EE8->EE8_PSLQUN := 0.167
	EE8->EE8_QE	    := ZC6->C6_QTDVEN
	EE8->EE8_QTDEM1 := 1
	EE8->EE8_REFCLI := ZC6->C6_PEDCLI
	EE8->EE8_SEQUEN := ZC6->C6_ITEM
	EE8->EE8_SLDATU := ZC6->C6_QTDVEN
	EE8->EE8_SLDINI := ZC6->C6_QTDVEN
	EE8->EE8_UNPRC  := _cUM
	EE8->EE8_UNPES  := "KG"
	EE8->EE8_UNIDAD := _cUM
	EE8->EE8_CF     := ZC6->C6_CF
	EE8->EE8_TES    := ZC6->C6_TES
	EE8_STATUS      := "A"
	MsUnlock()	       

	ZC6->(dbSkip())
EndDo

ZC6->(dbCloseArea())

MsgInfo("ATUALIZADO COM SUCESSO","INFO","INFORMACAO")

Return


Static Function AtuSX1()

cPerg := "PA0154"
aRegs :={}

///////////////////////////////////////////////
///////////////////////////////////////////////
/////  Grupo de Pergunta PA0154          //////
/////  MV_PAR01 : Pedido    ?            //////
///////////////////////////////////////////////
///////////////////////////////////////////////

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01        /defspa1/defeng1/Cnt01/Var02/Def02  /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Qual Pedido           ?",""       ,""      ,"mv_ch1","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR01",""           ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return