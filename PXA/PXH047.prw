#include "rwmake.ch"
#Include "TOPCONN.CH"
/*/
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PXH047   ³ Autor ³ Edner Alvarenga/Sergio Andre ³ 20-03-10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function PXH047()

SetPrvt("CCADASTRO,AROTINA,")
Private nOrdSC7OC := RetOrdem("SC7","C7_FILIAL+C7_YOC")
Private cfiltro,oDlga,nmarcados:=0

cfiltro := "@C7_FORNECE     = '"+M->ZE_FORNECE+"'"
cfiltro += " and C7_LOJA    = '"+M->ZE_LOJAFOR+"'"
cfiltro += " and C7_TIPO    = '1'"
cfiltro += " and C7_ENCER   = ' '"
cfiltro += " and C7_CONAPRO = 'L'"
cfiltro += " and C7_RESIDUO = ' '"
cfiltro += " and C7_QUJE < C7_QUANT "

aCampos  := {{ "C7_OK"       ,,  "Mark"          ,"@!"},;
			{ "C7_EMISSAO"   ,, "Emissao"        ,"@!"},;
			{ "C7_NUM"       ,, "Pedido"         ,"@!"},;
			{ "C7_ITEM"      ,, "Item"           ,"@!"},;
			{ "C7_FORNECE"   ,, "Cód.For"        ,"@!"},;
			{ "(Posicione('SA2',1,xFilial('SC7')+SC7->C7_FORNECE,'A2_NOME'))"   ,, "Fornecedor"          ,"@!"},;
			{ "C7_PRODUTO"   ,, "Cód.Prod"       ,"@!"},;
			{ "C7_DESCRI"    ,, "Produto"        ,"@!"},;
			{ "C7_QUANT"     ,, "Quantidade"     ,"@E 999,999,999.99"}}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionar arquivo                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SC7")
DbSetOrder(nOrdSC7OC)

Set Filter to &(cfiltro)

DbGotop()

lInverte := .F.
cMarca   := GetMark()
M->Z8_PRODUTO := CriaVar("ZE_PRODUTO")
M->Z8_QUANT   := CriaVar("ZE_QUANT")

While SC7->(!EOF())
	If aScan(apedmark,{|x| x[1] == SC7->C7_NUM}) > 0 .OR. (SC7->C7_YOC == M->ZE_OC)
		If Reclock("SC7",.f.)
			SC7->C7_OK := cmarca
			If Empty(M->ZE_PRODUTO)
				M->ZE_PRODUTO := SC7->C7_DESCRI
			EndIf
			M->ZE_QUANT  += SC7->C7_QUANT
			MsUnlock()
			nmarcados++
		EndIf
	EndIf
	SC7->(dbSkip())
EndDo

Define MSDIALOG oDlga TITLE "Pedidos de Compra em Aberto" From 00,00 To 34,100
oMark := MsSelect():New("SC7","C7_OK","",aCampos,@lInverte,@cMarca,{05,05,225,392})
oMark:bMark := {| | fDisp()}
@237,10   Say "Qtd.Itens de Pedido selecionados:"
@237,95   Get nMarcados  Object oMarcados When .F. Picture "99" Size 020,010
@235,120  BUTTON "Pesquisar" SIZE 35,14  ACTION AxPesqui()
@@235,160 BUTTON "OK" SIZE 35,14   ACTION fOk()

@230,005 TO  252,392

ACTIVATE MSDIALOG oDlga ON INIT Eval({||  oMark:oBrowse:Refresh() })

DbSelectArea("SC7")
Set filter to
dbClearFilter()
DbGotop()

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºAtualizar dados marcados                                               º±±
±±º                                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fDisp()

Local aArea := GetArea()

If Marked("C7_OK")
	
	M->ZE_QUANT  += SC7->C7_QUANT
	
	SZE->(Reclock("SZE",.f.))
	SZE->ZE_QUANT  += SC7->C7_QUANT
	If Empty(M->ZE_PRODUTO)
		M->ZE_PRODUTO 	 := SC7->C7_DESCRI
		SZE->ZE_PRODUTO  := SC7->C7_DESCRI
	EndIf
	SZE->(MsUnlock())
	
	dbSelectArea("SC7")
	nRegAux := SC7->(Recno())
	cNumAux := SC7->C7_NUM
	
	SC7->(dbGotop())
	SC7->(dbSetOrder(1))
	dbseek(xFilial("SC7")+cNumAux)
	While SC7->(!Eof()) .AND. SC7->C7_FILIAL = xFilial("SC7") .AND. SC7->C7_NUM == cNumAux
		If Reclock("SC7",.f.)
			SC7->C7_OK := cmarca
			++nMarcados
			MsUnlock()
		EndIf
		SC7->(dbSkip())
	EndDo
	dbGoTo(nRegAux)
Else
	--nMarcados
	M->ZE_QUANT  -= SC7->C7_QUANT
	SZE->(Reclock("SZE",.f.))
	SZE->ZE_QUANT  -= SC7->C7_QUANT
	If nMarcados = 0
		M->ZE_PRODUTO := " "
		SZE->ZE_PRODUTO  := SC7->C7_DESCRI
	EndIf
	MsUnlock()
	
	If Reclock("SC7",.f.)
		SC7->C7_OK := ""
		MsUnlock()
	EndIf
Endif

RestArea(aArea)
oMarcados:Refresh()
oMark:oBrowse:Refresh()

Return

Static Function fOk()

SC7->(dbGoTop())

While SC7->(!EOF())
	If Marked("C7_OK")
		aAdd(aPedMark,{SC7->C7_NUM})
	EndIf
	SC7->(dbSkip())
EndDo

If Altera
	SC7->(dbGoTop())
	While SC7->(!EOF())
		If !Marked("C7_OK")
			aAdd(aPedDesMar,{SC7->C7_NUM})
		EndIf
		SC7->(dbSkip())
	EndDo
EndIf

If Len(aPedMark) <> 0
	If Altera .AND. SZE->ZE_STATUS <> '2'
		M->ZE_STATUS  := '1'  //Agenciado
	EndIf
Else
	M->ZE_STATUS  := ''  //Não-Agenciado
EndIf

M->ZE_HRAGENC := time()

Close(oDlga)

Return