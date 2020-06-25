#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VN0012   ³ Autor ³ Alexandro Silva       ³ Data ³19/06/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de liberacao de Documentos                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ VN0012                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Financeiro                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VN0012()

/*
VN12_01-A097Libera
VN12_02-A097Estorna
VN12_03-
VN12_04-Legenda

*/

Local cFiltraSCR
Local cFitroUs  := ""
local lFiltroUs1:=.T.
Local aCoresUsr    := {}
Local cFilQuery := ""
Local cFilQry   := ""
/*
Local aCores       := { { 'CR_TIPO== "PC"', 'BR_VERMELHO' },;
{ 'CR_TIPO== "02"', 'BR_AZUL' },;
{ 'CR_TIPO== "03"', 'BR_AMARELO' },;
{ 'CR_TIPO== "04"', 'BR_VERDE'  },;
{ 'CR_TIPO== "05"', 'BR_CINZA'},;
{ 'CR_TIPO== "06"', 'BR_PINK'},;
{ 'CR_TIPO== "07"', 'BR_LARANJA'},;
{ 'CR_TIPO== "08"', 'BR_MARRON'},;
{ 'CR_TIPO== "NF"', 'BR_BRANCO'}}

Local aLegenda   := {       {"BR_VERMELHO", "Pedido de Compra"},;
{"BR_AZUL"    , "Tabela de Preço (Vendas)"},;
{"BR_AMARELO" , "Tabela de Frete (Vendas)"  },;
{"BR_VERDE"   , "Preco MP / Frete MP"},;
{"BR_CINZA"   , "Limite de Credito"},;
{"BR_PINK"    , "Bordero de Pagamento"},;
{"BR_LARANJA" , "Pedido de Venda"},;
{"BR_MARRON"  , "Desconto Contas a Receber"},;
{"BR_BRANCO"  , "Devolucao de Vendas"}}
*/

Local aCores     := { { 'CR_TIPO== "PC"', 'BR_VERMELHO' },;
                      { 'CR_TIPO== "05"', 'BR_AMARELO'}}

Local aLegenda   := { {"BR_VERMELHO", "Pedido de Compra"},;
					  {"BR_AMARELO" , "Limite de Credito"  }}

PRIVATE ca097User
PRIVATE aIndexSCR	:= {}
PRIVATE bFilSCRBrw := {|| Nil}
PRIVATE cXFiltraSCR
Private _cAprovador
Private _cTpDoc
Private	oEstado,oGetDados, oCliente, oLoja, _cCliente,_cLoja,oPedido,oBordero,oTotBor,oLimite,_nLimite,oTitFat,_nTitFat
Private oCombo,oCliente,oLoja,oCond,oCodigo,oCliente, _cCliente, oLoja, _cLoja,oNomCli,_cNomCli,_nValMin,_nValMax

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aRotina := MenuDef()
PRIVATE cCadastro := OemToAnsi("Liberacao de Documentos")

ca097User := RetCodUsr()
dbSelectArea("SAK")
dbSetOrder(2)
If !MsSeek(xFilial("SAK")+ca097User)
	Help(" ",1,"A097APROV")
	dbSelectArea("SCR")
	dbSetOrder(1)
Else
	/*
	_nValMin:= SAK->AK_YMINCRE
	_nValMax:= SAK->AK_YMAXCRE
	
	_cTpDoc := Alltrim(STRTRAN( SAK->AK_YTPLIB, "*", "" ))
	_cTp    := "('"
	
	If Len(_cTpDoc) == 2
		_cTp    := "('"+_cTpdoc+"')"
	Else
		For AZ:= 1 TO Len(_cTpDoc) step 2
			_cTp += Substr(_cTpDoc,AZ,2)+"',"
		Next AZ
		
		_cTp := Substr(_cTp,1,Len(_cTp)-1)
		_cTp := _cTp+")"
	Endif
	
	_cTp    := STRTRAN(_cTp,'01','PC')
	_cTp    := STRTRAN(_cTp,'09','NF')
	_cTpDoc := Alltrim(STRTRAN( SAK->AK_YTPLIB, '01', 'PC' ))
	_cTpDoc := Alltrim(STRTRAN( _cTpDoc, '09', 'NF' ))
	*/         
	
	_cTpDoc 	:= "05"
	_cAprovador := SAK->AK_COD
	
	If Pergunte("MTA097",.T.)
		
		dbSelectArea("SCR")
		dbSetOrder(1)
		
		If cFiltraSCR==nil
			cFiltraSCR  := 'CR_FILIAL=="'+xFilial("SCR")+'"'+'.And.CR_USER == "'+ca097User
			cFilQry     := " CR_FILIAL='"+xFilial("SCR")+"' AND CR_USER='"+ca097User+"'"
		endIf
		
		Do Case
			Case mv_par01 == 1
				cFiltraSCR += '".And.CR_STATUS=="02"'
				cFilQry    += " AND CR_STATUS='02' "
			Case mv_par01 == 2
				cFiltraSCR += '".And.(CR_STATUS=="03".OR.CR_STATUS=="05")'
				cFilQry    += " AND (CR_STATUS='03' OR CR_STATUS='05') "
			Case mv_par01 == 3
				cFiltraSCR += '"'
				cFilQry    += " "
			OtherWise
				cFiltraSCR += '".And.(CR_STATUS=="01".OR.CR_STATUS=="04")'
				cFilQry    += " AND (CR_STATUS='01' OR CR_STATUS='04' ) "
		EndCase
		
		cFiltraSCR += '.And.(CR_TIPO $ "'+_cTpdoc+'")'
		cFilQry    += "  AND (CR_TIPO IN '"+_cTpDoc+"') "
		
		bFilSCRBrw 	:= {|| FilBrowse("SCR",@aIndexSCR,@cFiltraSCR) }
		Eval(bFilSCRBrw)
		
		MBrowse( 6, 1,22,75,"SCR",,,,,,aCores,,,,,,,,IIF(!Empty(cFilQuery),cFilQuery, NIL))
		
	EndIf
EndIf

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³VN12_01   ³ Autor ³ Edson Maricate        ³ Data ³15.10.1998³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Liberacao de Pedidos de Compra.                ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void VN12_01(ExpC1,ExpN1,ExpN2)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Opcao selecionada                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VN12_01(cAlias,nReg,nOpcx)

_lParar := .T.

If SCR->CR_TIPO == "05"
	//If SCR->CR_TOTAL < _nValMin .Or. SCR->CR_TOTAL > _nValMax
	//	MSGINFO("VALOR FORA DOS LIMITES PERMITIDOS PARA LIBERAÇÃO!!!")
	//	Return
	//Endif
Endif

If SCR->CR_STATUS == "03"
	MSGINFO("DOCUMENTO JA LIBERADO!!!")
	Return
Endif

If U_VN12_03(cAlias,nReg,nOpcx)
	
EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³VN12_02    ³ Autor ³ Edson Maricate       ³ Data ³16.11.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Estorna a liberacao de todo o pedido.                       ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA097                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VN12_02()

Local aArea		:= GetArea()
Local aAreaSC7	:= SC7->(GetArea())
Local aAreaSCR	:= SCR->(GetArea())

Local cNumero	:= ""
Local cChave    := ""
Local cAlias    := "SC7"
Local cTipo     := SCR->CR_TIPO

Local lEstorna	:= .T.
Local lContinua := .T.
Local lLibOk    := .F.

Local nOpc      := 0
Local nReg		:= SCR->(Recno())

RestArea(aAreaSCR)
RestArea(aAreaSC7)
RestArea(aArea)

dbSelectArea("SCR")
dbSetOrder(1)

SCR->(Eval(bFilSCRBrw))

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ma097Pesq ³ Autor ³Eduardo Riera          ³ Data ³23.01.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Tratamento do Filtro na Pesquisa                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.	                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ma097Pesq()

AxPesqui()

Eval(bFilSCRBrw)

Return(.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A097Legend³ Autor ³ Aline Correa do Vale  ³ Data ³ 07.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria uma janela contendo a legenda da mBrowse               ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA097                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VN12_04()

Local aLegeUsr   := {}
/*
Local aLegenda   := {       {"BR_VERMELHO", "Pedido de Compra"},;
{"BR_AZUL"    , "Tabela de Preço (Vendas)"},;
{"BR_AMARELO" , "Tabela de Frete (Vendas)"  },;
{"BR_VERDE"   , "Preco MP / Frete MP"},;
{"BR_CINZA"   , "Limite de Credito"},;
{"BR_PINK"    , "Bordero de Pagamento"},;
{"BR_LARANJA" , "Pedido de Venda"},;
{"BR_MARRON"  , "Desconto Contas a Receber"},;
{"BR_BRANCO"  , "Devolucao de Vendas"}}
*/

Local aLegenda   := {   {"BR_VERMELHO", "Pedido de Compra"},;
						{"BR_AMARELO" , "Limite de Credito"  }}

BrwLegenda(cCadastro,"Tipo de Documentos",aLegenda)

Return(.T.)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A097Lock ³ Autor ³ Nereu Humberto Junior ³ Data ³ 01.09.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se o pedido de compra nao esta com lock           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpL1 := A097Lock(ExpC1,ExpC2)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do Documento                                ³±±
±±³          ³ ExpC2 = Tipo do Documento                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA097                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function A097Lock(cNumero,cTipo)

Local aArea    := {}
Local lRet     := .F.

If cTipo == "NF"
	aArea := SF1->(GetArea())
	dbSelectArea("SF1")
	dbSetOrder(1)
	If MsSeek(SCR->CR_MSFIL+cNumero)
		If Reclock("SF1")
			lRet := .T.
		Else
			lRet := .F.
		EndIf
	EndIf
ElseIf cTipo == "PC"
	aArea := SC7->(GetArea())
	dbSelectArea("SC7")
	dbSetOrder(1)
	If MsSeek(xFilial("SC7")+cNumero)
		While !Eof() .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial("SC7")+cNumero
			If RecLock("SC7")
				lRet := .T.
			Else
				lRet := .F.
				Exit
			Endif
			dbSkip()
		EndDo
	EndIf
	RestArea(aArea)
Endif


Return(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Fabio Alves Silva     ³ Data ³08/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MenuDef()

PRIVATE aRotina	:= {{OemToAnsi("Pesquisar"),"Ma097Pesq",   0 , 1, 0, .F.},;
{OemToAnsi("Consulta Documento"),"U_VN12_03",  0 , 2, 0, nil},;
{OemToAnsi("Liberar"),"U_VN12_01",  0 , 4, 0, nil},;
{OemToAnsi("Legenda"),"U_VN12_04",  0 , 2, 0, .F.}}


Return(aRotina)




User Function VN12_03(cAlias,nReg,nOpcx)

_lParar   := .T.
_nSdoLim  := 0
_nSdoTit  := 0

If SCR->CR_TIPO == "PC"
	dbSelectArea("SC7")
	dbSetOrder(1)
	If MsSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
		Mata120(NIL,NIL,NIL,2)
	EndIf
	
	If nOpcx == 3
		U_VN0013(.F.)
	Endif
ElseIf SCR->CR_TIPO == "NF"
	dbSelectArea("SF1")
	dbSetOrder(1)
	If MsSeek(SCR->CR_MSFIL+Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))
		If nOpcx <> 3
			Pergunte("MTA103",.F.)
			Mata103(NIL,NIL,2)
		Endif
	EndIf
	
	If nOpcx == 3
		U_VN0013(.F.)
	Endif
	
ElseIf SCR->CR_TIPO == "02" // TABELA DE PRECO CIMENTO
	Private _cGrAprov:= ""
	wOpcao      := 	"V"
	Do Case
		Case wOpcao == "V" ; lVisualizar := .T. ; nOpcE := 2 ; nOpcG := 2 ; cOpcao := "VISUALIZAR"
	EndCase
	
	RegToMemory("SZH",(cOpcao=="INCLUIR"))
	nUsado  := 0
	aHeader := {}
	
	If Empty(SCR->CR_YOBRA)
		If nOpcx == 2  // CONSULTA
			_aCampos := {"ZI_PRODUTO","ZI_DESC","ZI_PRECOF","ZA4_VLMCIF","ZI_PRECO","ZA4_VLMFOB","ZI_PGER","ZA4_VLMGER"}
		Else           // LIBERA
			_aCampos := {"ZI_PRODUTO","ZI_DESC","ZI_PRECOF","ZI_PRECO","ZI_PGER"}
		Endif
	Else
		If nOpcx == 2  // CONSULTA
			_aCampos := {"ZA2_PRODUT","ZA2_DESPRO","ZA2_OBRA","ZA2_PRC01F","ZA4_VLMCIF","ZA2_PRC01","ZA4_VLMFOB","ZA2_PRCGER","ZA4_VLMGER"}
		Else           // LIBERA
			_aCampos := {"ZA2_PRODUT","ZA2_DESPRO","ZA2_OBRA","ZA2_PRC01F","ZA2_PRC01","ZA2_PRCGER"}
		Endif
	Endif
	
	For AX:= 1 TO Len(_aCampos)
		dbSelectArea("Sx3")
		dbSetOrder(2)
		If dbSeek(_aCampos[AX])
			If  X3USO(SX3->X3_USADO) .and. SX3->X3_NIVEL <= cNivel
				nUsado := nUsado + 1
				aadd(aHeader,{ trim(SX3->X3_TITULO),SX3->X3_CAMPO   , ;
				SX3->X3_PICTURE     ,SX3->X3_TAMANHO , ;
				SX3->X3_DECIMAL     ,"AllwaysTrue()" , ;
				SX3->X3_USADO       ,SX3->X3_TIPO    , ;
				SX3->X3_ARQUIVO     ,SX3->X3_CONTEXT } )
			Endif
		Endif
	Next AX
	
	If Empty(SCR->CR_YOBRA)
		Private _nPProd   := aScan( aHeader, { |x| Alltrim(x[2])=="ZI_PRODUTO" } )
		Private _nPDesc   := aScan( aHeader, { |x| Alltrim(x[2])=="ZI_DESC"    } )
		Private _nPVlCif  := aScan( aHeader, { |x| Alltrim(x[2])=="ZI_PRECO"   } )
		Private _nPVlFob  := aScan( aHeader, { |x| Alltrim(x[2])=="ZI_PRECOF"  } )
		Private _nPVlGer  := aScan( aHeader, { |x| Alltrim(x[2])=="ZI_PGER"    } )
	Else
		Private _nPProd   := aScan( aHeader, { |x| Alltrim(x[2])=="ZA2_PRODUT" } )
		Private _nPDesc   := aScan( aHeader, { |x| Alltrim(x[2])=="ZA2_DESPRO" } )
		Private _nPOBRA   := aScan( aHeader, { |x| Alltrim(x[2])=="ZA2_OBRA"   } )
		Private _nPVlCif  := aScan( aHeader, { |x| Alltrim(x[2])=="ZA2_PRC01"  } )
		Private _nPVlFob  := aScan( aHeader, { |x| Alltrim(x[2])=="ZA2_PRC01F" } )
		Private _nPVlGer  := aScan( aHeader, { |x| Alltrim(x[2])=="ZA2_PRCGER" } )
	Endif
	
	If nOpcx == 2
		Private _nPRefCif := aScan( aHeader, { |x| Alltrim(x[2])=="ZA4_VLMCIF"   } )
		Private _nPRefFob := aScan( aHeader, { |x| Alltrim(x[2])=="ZA4_VLMFOB"   } )
		Private _nPRefGer := aScan( aHeader, { |x| Alltrim(x[2])=="ZA4_VLMGER"   } )
	Endif
	
	aCols:={}
	
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SCR->CR_YCLIENT + SCR->CR_YLOJA))
	
	SZH->(dbSetorder(1))
	//	SZH->(dbSeek(xFilial("SZH")+SCR->CR_YCLIENT + SCR->CR_YLOJA))
	SZH->(dbSeek(SCR->CR_MSFIL+SCR->CR_YCLIENT + SCR->CR_YLOJA))
	
	If Empty(SCR->CR_YOBRA)
		SZI->(dbSetOrder(1))
		If SZI->(dbSeek(SCR->CR_MSFIL+SCR->CR_YCLIENT + SCR->CR_YLOJA+ SCR->CR_YPRODUT+ Space(01)))
			_cChavSZI := SZI->ZI_CLIENTE + SZI->ZI_LOJA + SZI->ZI_PRODUTO + Space(01)
			
			While SZI->(!Eof()) .And. _cChavSZI == SZI->ZI_CLIENTE + SZI->ZI_LOJA + SZI->ZI_PRODUTO + Space(01)
				
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+SZI->ZI_PRODUTO))
				
				If !Empty(SZI->ZI_LIBER)
					SZI->(dbSkip())
					Loop
				Endif
				
				aadd(aCols,array(nUsado+1))
				
				ACOLS[Len(Acols),_NPPROD] := SZI->ZI_PRODUTO
				ACOLS[Len(Acols),_NPDESC] := SZI->ZI_DESC
				ACOLS[Len(Acols),_NPVLCIF]:= SZI->ZI_PRECO
				ACOLS[Len(Acols),_NPVLFOB]:= SZI->ZI_PRECOF
				ACOLS[Len(Acols),_NPVLGER]:= SZI->ZI_PGER
				
				If nOpcx == 2
					_lEncont := .F.
					ZA4->(dbSetOrder(2))
					If ZA4->(!dbSeek(xFilial("ZA4")+SA1->A1_EST  + SB1->B1_COD + SA1->A1_ATIVIDA + SA1->A1_MUN))
						If ZA4->(!dbSeek(xFilial("ZA4")+SA1->A1_EST  + SB1->B1_COD + SA1->A1_ATIVIDA ))
							If ZA4->(dbSeek(xFilial("ZA4")+SA1->A1_EST  + SB1->B1_COD ))
								_lEncont :=.T.
							Endif
						Else
							_lEncont :=.T.
						Endif
					Else
						_lEncont :=.T.
					Endif
					
					If _lEncont
						ACOLS[Len(Acols),_NPREFCIF]:= ZA4->ZA4_VLMCIF
						ACOLS[Len(Acols),_NPREFFOB]:= ZA4->ZA4_VLMFOB
						ACOLS[Len(Acols),_NPREFGER]:= ZA4->ZA4_VLMGER
					Else
						ACOLS[Len(Acols),_NPREFCIF]:= 0
						ACOLS[Len(Acols),_NPREFFOB]:= 0
						ACOLS[Len(Acols),_NPREFGER]:= 0
					Endif
				Endif
				
				aCols[len(aCols),nUsado+1] := .F.
				SZI->(dbSkip())
			EndDo
		Endif
	Else
		ZA2->(dbSetOrder(2))
		If ZA2->(dbSeek(xFilial("ZA2")+SCR->CR_YCLIENT + SCR->CR_YLOJA+ SCR->CR_YPRODUT+ SCR->CR_YOBRA+Space(01)))
			_cChavZA2 := ZA2->ZA2_CLIENT + ZA2->ZA2_LOJA + ZA2->ZA2_PRODUT + ZA2->ZA2_OBRA + Space(01)
			
			While ZA2->(!Eof()) .And. _cChavZA2 == ZA2->ZA2_CLIENT + ZA2->ZA2_LOJA + ZA2->ZA2_PRODUT + ZA2->ZA2_OBRA + Space(01)
				
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+ZA2->ZA2_PRODUT))
				
				If !Empty(ZA2->ZA2_LIBER)
					ZA2->(dbSkip())
					Loop
				Endif
				
				aadd(aCols,array(nUsado+1))
				
				ACOLS[Len(Acols),_NPPROD] := ZA2->ZA2_PRODUT
				ACOLS[Len(Acols),_NPDESC] := ZA2->ZA2_DESPRO
				ACOLS[Len(Acols),_NPOBRA] := ZA2->ZA2_OBRA
				ACOLS[Len(Acols),_NPVLCIF]:= ZA2->ZA2_PRC01
				ACOLS[Len(Acols),_NPVLFOB]:= ZA2->ZA2_PRC01F
				ACOLS[Len(Acols),_NPVLGER]:= ZA2->ZA2_PRCGER
				
				If nOpcx == 2
					_lEncont := .F.
					ZA4->(dbSetOrder(2))
					If ZA4->(!dbSeek(xFilial("ZA4")+ZA2->ZA2_ESTENT + SB1->B1_COD + SA1->A1_ATIVIDA + ZA2->ZA2_MUNENT))
						If ZA4->(!dbSeek(xFilial("ZA4")+ ZA2->ZA2_ESTENT + SB1->B1_COD + SA1->A1_ATIVIDA ))
							If ZA4->(dbSeek(xFilial("ZA4")+ ZA2->ZA2_ESTENT  + SB1->B1_COD ))
								_lEncont :=.T.
							Endif
						Else
							_lEncont :=.T.
						Endif
					Else
						_lEncont :=.T.
					Endif
					
					If _lEncont
						ACOLS[Len(Acols),_NPREFCIF]:= ZA4->ZA4_VLMCIF
						ACOLS[Len(Acols),_NPREFFOB]:= ZA4->ZA4_VLMFOB
						ACOLS[Len(Acols),_NPREFGER]:= ZA4->ZA4_VLMGER
					Else
						ACOLS[Len(Acols),_NPREFCIF]:= 0
						ACOLS[Len(Acols),_NPREFFOB]:= 0
						ACOLS[Len(Acols),_NPREFGER]:= 0
					Endif
				Endif
				
				aCols[len(aCols),nUsado+1] := .F.
				ZA2->(dbSkip())
			EndDo
		Endif
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa variaveis                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTitulo        := "Cadastro da Tabela de Precos"
	cAliasEnchoice := "SZH"
	cAliasGetD     := "SZI"
	cLinOk         := "AllwaysTrue()"
	cTudOk         := "AllwaysTrue()"
	cFieldOk       := "AllwaysTrue()"
	aCpoEnchoice   := {"ZH_CLIENTE","ZH_LOJA","ZH_NOME"}
	
	lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)
	
	If lRet .And. nOpcx == 3
		U_VN0013(.F.)
	Endif
	
ElseIf SCR->CR_TIPO == "03" // TABELA DE PRECO FRETE
	Private _cGrAprov:= ""
	Private   Acols	 := {}
	Private _nOpcX   := 2
	Private VISUAL   := (_nOpcX == 2)
	Private aHeader  := {}
	Private _nOpcao  := _nOpcX
	
	_nOpcE := _nOpcX
	_nOpcG := _nOpcX
	
	If nOpcx == 2  // CONSULTA
		_aCampos := {"ZA5_MUN","ZG_FORN","ZG_LOJA","ZA5_DIST","ZG_VALOR","ZA5_VLMAXG","ZG_FRETE","ZA5_VLMAXE","ZG_FAGRTRA","ZA5_VLMAXA"}
	Else           // LIBERA
		_aCampos := {"ZA5_MUN","ZG_FORN","ZG_LOJA","ZA5_DIST","ZG_VALOR","ZG_FRETE"  ,"ZG_FAGRTRA"}
	Endif
	
	For AX:= 1 TO Len(_aCampos)
		dbSelectArea("Sx3")
		dbSetOrder(2)
		If dbSeek(_aCampos[AX])
			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal,"AllwaysTrue()",;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )
		Endif
	Next Ax
	
	Private _NPITEM   := aScan( aHeader, { |x| Alltrim(x[2])=="ZA5_ITEM"  } )
	Private _NPEST    := aScan( aHeader, { |x| Alltrim(x[2])=="ZA5_ESTADO"} )
	Private _NPMUN    := aScan( aHeader, { |x| Alltrim(x[2])=="ZA5_MUN"   } )
	Private _NPDIST   := aScan( aHeader, { |x| Alltrim(x[2])=="ZA5_DIST"  } )
	Private _NPVALOR  := aScan( aHeader, { |x| Alltrim(x[2])=="ZG_VALOR"  } )
	Private _NPFORN   := aScan( aHeader, { |x| Alltrim(x[2])=="ZG_FORN"   } )
	Private _NPLOJA   := aScan( aHeader, { |x| Alltrim(x[2])=="ZG_LOJA"   } )
	Private _NPFRETE  := aScan( aHeader, { |x| Alltrim(x[2])=="ZG_FRETE"  } )
	Private _NPFAGRTRA:= aScan( aHeader, { |x| Alltrim(x[2])=="ZG_FAGRTRA"} )
	Private _NPVLMAXG := aScan( aHeader, { |x| Alltrim(x[2])=="ZA5_VLMAXG"} )
	Private _NPVLMAXE := aScan( aHeader, { |x| Alltrim(x[2])=="ZA5_VLMAXE"} )
	Private _NPVLMAXA := aScan( aHeader, { |x| Alltrim(x[2])=="ZA5_VLMAXA"} )
	
	aCols:={}
	_cEstado  := SCR->CR_YESTADO
	_cMun     := SCR->CR_YMUN
	
	SZ4->(dbSetOrder(1))
	SZ4->(dbSeek(SCR->CR_MSFIL + SCR->CR_YESTADO  + SCR->CR_YMUN))
	_cDist    := Alltrim(Str(SZ4->Z4_DIST))
	
	SZG->(dbSetOrder(1))
	If SZG->(dbSeek(SCR->CR_MSFIL + SCR->CR_YESTADO  + SCR->CR_YMUN + SCR->CR_YFORNEC  + SCR->CR_YLOJFOR +Space(01)))
		
		_cChavSZG := SZG->ZG_EST   + SZG->ZG_MUN  + SZG->ZG_FORN + SZG->ZG_LOJA + Space(01)
		
		While SZG->(!Eof()) .And. _cChavSZG == SZG->ZG_EST   + SZG->ZG_MUN  + SZG->ZG_FORN + SZG->ZG_LOJA + Space(01)
			
			If !Empty(SZG->ZG_LIBER)
				SZG->(dbSkip())
				Loop
			Endif
			
			AADD(aCols,Array(Len(_aCampos)+1))
			
			ACOLS[Len(Acols),_NPDIST]   := SZG->ZG_DIST
			ACOLS[Len(Acols),_NPMUN]    := SZG->ZG_MUN
			ACOLS[Len(Acols),_NPFORN]   := SZG->ZG_FORN
			ACOLS[Len(Acols),_NPLOJA]   := SZG->ZG_LOJA
			ACOLS[Len(Acols),_NPVALOR]  := SZG->ZG_VALOR
			ACOLS[Len(Acols),_NPFRETE]  := SZG->ZG_FRETE
			ACOLS[Len(Acols),_NPFAGRTRA]:= SZG->ZG_FAGRTRA
			
			If nOpcx == 2
				ZA5->(dbSetOrder(1))
				If ZA5->(!dbSeek(xFilial("ZA5")+SZG->ZG_EST  + SZG->ZG_MUN))
					If ZA5->(dbSeek(xFilial("ZA5")+SZG->ZG_EST  + Space(35)))
						ZA5->(dbSeek(xFilial("ZA5")+SZG->ZG_EST  + Space(35) + SZG->ZG_DIST,.T.))
						If ZA5->ZA5_ESTADO == SZG->ZG_EST
							ACOLS[Len(Acols),_NPVLMAXG]:= ZA5->ZA5_VLMAXG
							ACOLS[Len(Acols),_NPVLMAXE]:= ZA5->ZA5_VLMAXE
							ACOLS[Len(Acols),_NPVLMAXA]:= ZA5->ZA5_VLMAXA
						Endif
					Endif
				Endif
			Endif
			
			aCols[Len(aCols),Len(_aCampos)+1]:=.F.
			
			SZG->(dbSkip())
		EndDo
	Endif
	
	_lEdit        := .F.
	cTitulo       := "Cadastro da Tabela de Precos"
	cAliasGetD    := "SZG"
	cLinOk        := "AllwaysTrue()"
	cTudOk        := "AllwaysTrue()"
	cFieldOk      := "AllwaysTrue()"
	
	_lRetMod2     := VN12_06(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)
	
	If _lRetMod2 .And. nOpcx == 3
		U_VN0013(.F.)
	Endif
ElseIf SCR->CR_TIPO == "04" // TABELA DE PRECO DE COMPRAS
	Private _cGrAprov:= ""
	wOpcao      := 	"V"
	Do Case
		Case wOpcao == "V" ; lVisualizar := .T. ; nOpcE := 2 ; nOpcG := 2 ; cOpcao := "VISUALIZAR"
	EndCase
	
	RegToMemory("AIA",(cOpcao=="INCLUIR"))
	
	nUsado  := 0
	aHeader := {}
	
	_aCampos := {"AIB_ITEM","AIB_YLIBER","AIB_YDTBLQ","AIB_CODPRO","AIB_YDESC","AIB_PRCCOM","AIB_QTDLOT","AIB_MOEDA","AIB_DATVIG","AIB_FRETE","AIB_YLIB01","AIB_YLIB02"}
	
	For AX:= 1 TO Len(_aCampos)
		dbSelectArea("Sx3")
		dbSetOrder(2)
		If dbSeek(_aCampos[AX])
			If  X3USO(SX3->X3_USADO) .and. SX3->X3_NIVEL <= cNivel
				nUsado := nUsado + 1
				aadd(aHeader,{ trim(SX3->X3_TITULO),SX3->X3_CAMPO   , ;
				SX3->X3_PICTURE     ,SX3->X3_TAMANHO , ;
				SX3->X3_DECIMAL     ,"AllwaysTrue()" , ;
				SX3->X3_USADO       ,SX3->X3_TIPO    , ;
				SX3->X3_ARQUIVO     ,SX3->X3_CONTEXT } )
			Endif
		Endif
	Next AX
	
	Private _nPITEM   := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_ITEM"   } )
	Private _nPSTATUS := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_YLIBER" } )
	Private _nPDTBLQ  := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_YDTBLQ" } )
	Private _nPCODPRO := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_CODPRO" } )
	Private _nPDESC   := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_YDESC"  } )
	Private _nPPRCCOM := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_PRCCOM" } )
	Private _nPQTDLOT := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_QTDLOT" } )
	Private _nPMOEDA  := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_MOEDA"  } )
	Private _nPDATVIG := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_DATVIG" } )
	Private _nPFRETE  := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_FRETE"  } )
	Private _nPLib01  := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_YLIB01" } )
	Private _nPLIb02  := aScan( aHeader, { |x| Alltrim(x[2])== "AIB_YLIB02" } )
	
	aCols:={}
	
	AIA->(dbSetOrder(1))
	AIA->(dbSeek(SCR->CR_MSFIL + SCR->CR_YFORNEC + SCR->CR_YLOJFOR + SCR->CR_YCODTAB))
	
	_cFornece := AIA->AIA_CODFOR
	_cLoja    := AIA->AIA_LOJFOR
	_cTabPrc  := AIA->AIA_CODTAB
	_cDesPrc  := AIA->AIA_DESCRI
	_dVigDe   := AIA->AIA_DATDE
	_dVigAte  := AIA->AIA_DATATE
	
	aCols:= {}
	
	AIB->(dbOrderNickName("INDAIB3"))
	If AIB->(dbSeek(SCR->CR_MSFIL + _cFornece + _cLoja + _cTabPrc + Space(01)))
		
		_cChavAIB := AIB->AIB_CODFOR + AIB->AIB_LOJFOR + AIB->AIB_CODTAB + AIB->AIB_YLIBER + AIB->AIB_CODPRO
		
		While AIB->(!Eof()) .And. _cChavAIB == AIB->AIB_CODFOR + AIB->AIB_LOJFOR + AIB->AIB_CODTAB + AIB->AIB_YLIBER + AIB->AIB_CODPRO
			
			AADD(aCols,Array(Len(_aCampos)+1))
			
			aCols[Len(aCols),_NPITEM]    := AIB->AIB_ITEM
			aCols[Len(aCols),_NPSTATUS]  := AIB->AIB_YLIBER
			aCols[Len(aCols),_NPDTBLQ]   := AIB->AIB_YDTBLQ
			aCols[Len(aCols),_NPCODPRO]  := AIB->AIB_CODPRO
			aCols[Len(aCols),_NPDESC]    := AIB->AIB_YDESC
			aCols[Len(aCols),_NPPRCCOM]  := AIB->AIB_PRCCOM
			aCols[Len(aCols),_NPQTDLOT]  := AIB->AIB_QTDLOT
			aCols[Len(aCols),_NPMOEDA]   := AIB->AIB_MOEDA
			aCols[Len(aCols),_NPDATVIG]  := AIB->AIB_DATVIG
			aCols[Len(aCols),_NPFRETE]   := AIB->AIB_FRETE
			aCols[Len(aCols),_NPMOEDA]   := AIB->AIB_MOEDA
			aCols[Len(aCols),_NPLIB01]   := AIB->AIB_YLIB01
			aCols[Len(aCols),_NPLIB02]   := AIB->AIB_YLIB02
			aCols[Len(aCols),Len(_aCampos)+1]:=.F.
			
			AIB->(dbSkip())
		EndDo
	Endif
	
	_lEdit  := .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa variaveis                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTitulo        := "Tabela de Preco de Compras"
	cAliasEnchoice := "AIA"
	cAliasGetD     := "AIB"
	cLinOk         := "AllwaysTrue()"
	cTudOk         := "AllwaysTrue()"
	cFieldOk       := "AllwaysTrue()"
	aCpoEnchoice   := {"AIA_CODFOR","AIA_LOJFOR","AIA_CODTAB","AIA_DESCRI"}
	
	lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)
	
	If lRet .And. nOpcx == 3
		U_VN0013(.F.)
	Endif
ElseIf SCR->CR_TIPO == "05" // LIMITE DE CREDITO
	
	Private   Acols	:={}
	Private _nOpcX := 2
	
	Private VISUAL := (_nOpcX == 2)
	
	Private aHeader := {}
	Private _nOpcao := _nOpcX
	
	_nOpcE := _nOpcX
	_nOpcG := _nOpcX
	
	_aCampos := {"ZA6_ITEM","ZA6_DTBLOQ","ZA6_LIBER","ZA6_VALOR","ZA6_PRAZO","ZA6_DTVIG"}
	
	For AX:= 1 TO Len(_aCampos)
		dbSelectArea("Sx3")
		dbSetOrder(2)
		If dbSeek(_aCampos[AX])
			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal,x3_valid,;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )
		Endif
	Next Ax
	
	Private _nPITEM   := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_ITEM"   } )
	Private _nPSTATUS := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_LIBER"  } )
	Private _nPDTBLQ  := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_DTBLOQ" } )
	Private _nPDTVIG  := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_DTVIG"  } )
	Private _nPVALOR  := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_VALOR"  } )
	Private _nPPRAZO  := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_PRAZO"  } )
	Private _nPDATA   := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_DATA"   } )
	
	_cCliente := SCR->CR_YCLIENT
	_cLoja    := SCR->CR_YLOJA
	aCols     := {}
	
	SA1->(dbSetorder(1))
	SA1->(dbSeek(xFilial("SA1")+_cCliente + _cLoja))
	
	_cNomCli := SA1->A1_NOME
	
	ZA6->(dbSetOrder(1))
	If ZA6->(dbSeek(xFilial("ZA6") + _cCliente + _cLoja + Space(01)))
		
		_nSdoLim  := ZA6->ZA6_SDOLIM
		_nSdoTit  := ZA6->ZA6_SDOTIT
		
		_cChavZA6 := ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA + ZA6->ZA6_LIBER
		
		While ZA6->(!Eof()) .And. _cChavZA6 == ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA + ZA6->ZA6_LIBER
			
			AADD(aCols,Array(Len(_aCampos)+1))
			
			aCols[Len(aCols),_NPITEM]    := ZA6->ZA6_ITEM
			aCols[Len(aCols),_NPSTATUS]  := ZA6->ZA6_LIBER
			aCols[Len(aCols),_NPDTBLQ]   := ZA6->ZA6_DTBLOQ
			aCols[Len(aCols),_NPVALOR]   := ZA6->ZA6_VALOR
			aCols[Len(aCols),_NPPRAZO]   := ZA6->ZA6_PRAZO
			aCols[Len(aCols),_NPDTVIG]   := ZA6->ZA6_DTVIG
			
			aCols[Len(aCols),Len(_aCampos)+1]:=.F.
			
			ZA6->(dbSkip())
		EndDo
	Endif
	
	_lEdit  := .F.
	
	cTitulo       := "LIMITE DE CREDITO"
	cAliasGetD    := "ZA6"
	cLinOk        := "AllwaysTrue()"
	cTudOk        := "AllwaysTrue()"
	cFieldOk      := "AllwaysTrue()"
	
	_lRetMod2     := VN12_06(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)
	
	If _lRetMod2 .And. nOpcx == 3
		U_VN0013(.F.)
	Endif
ElseIf SCR->CR_TIPO == "06" // BORDERO DE PAGAMENTO
	
	Private   Acols	:={}
	Private _nOpcX := 2
	
	Private VISUAL := (_nOpcX == 2)
	
	Private aHeader := {}
	Private _nOpcao := _nOpcX
	
	_nOpcE := _nOpcX
	_nOpcG := _nOpcX
	
	_aCampos := {"EA_PREFIXO","EA_NUM","EA_PARCELA","EA_TIPO","EA_FORNECE","EA_LOJA","E2_VENCREA","A2_NOME","E2_VALOR","E2_HIST"}
	
	For AX:= 1 TO Len(_aCampos)
		dbSelectArea("Sx3")
		dbSetOrder(2)
		If dbSeek(_aCampos[AX])
			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal,x3_valid,;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )
		Endif
	Next Ax
	
	Private _nPPREFIXO := aScan( aHeader, { |x| Alltrim(x[2])== "EA_PREFIXO" } )
	Private _nPNUM     := aScan( aHeader, { |x| Alltrim(x[2])== "EA_NUM"     } )
	Private _nPPARCELA := aScan( aHeader, { |x| Alltrim(x[2])== "EA_PARCELA" } )
	Private _nPTIPO    := aScan( aHeader, { |x| Alltrim(x[2])== "EA_TIPO"    } )
	Private _nPFORNECE := aScan( aHeader, { |x| Alltrim(x[2])== "EA_FORNECE" } )
	Private _nPLOJA    := aScan( aHeader, { |x| Alltrim(x[2])== "EA_LOJA"    } )
	Private _nPVENCREA := aScan( aHeader, { |x| Alltrim(x[2])== "E2_VENCREA" } )
	Private _nPNOME    := aScan( aHeader, { |x| Alltrim(x[2])== "A2_NOME"    } )
	Private _nPVALOR   := aScan( aHeader, { |x| Alltrim(x[2])== "E2_VALOR"   } )
	Private _nPHist    := aScan( aHeader, { |x| Alltrim(x[2])== "E2_HIST"    } )
	
	aCols     := {}
	_cBordero := Substr(SCR->CR_NUM,1,TAMSX3("EA_NUMBOR")[1])
	
	SEA->(dbSetOrder(1))
	If SEA->(dbSeek(xFilial("SEA") + _cBordero))
		
		_cChavSEA := SEA->EA_NUMBOR
		
		While SEA->(!Eof()) .And. _cChavSEA == SEA->EA_NUMBOR
			
			AADD(aCols,Array(Len(_aCampos)+1))
			
			SA2->(dbSetorder(1))
			SA2->(dbSeek(xFilial("SA2")+ SEA->EA_FORNECE + SEA->EA_LOJA))
			
			SE2->(dbSetOrder(1))
			SE2->(dbSeek(xFilial("SE2")+ SEA->EA_PREFIXO + SEA->EA_NUM + SEA->EA_PARCELA +SEA->EA_TIPO + SEA->EA_FORNECE + SEA->EA_LOJA))
			
			aCols[Len(aCols),_NPPREFIXO] := SEA->EA_PREFIXO
			aCols[Len(aCols),_NPNUM]     := SEA->EA_NUM
			aCols[Len(aCols),_NPPARCELA] := SEA->EA_PARCELA
			aCols[Len(aCols),_NPTIPO]    := SEA->EA_TIPO
			aCols[Len(aCols),_NPFORNECE] := SEA->EA_FORNECE
			aCols[Len(aCols),_NPLOJA]    := SEA->EA_LOJA
			aCols[Len(aCols),_NPVENCREA] := SE2->E2_VENCREA
			aCols[Len(aCols),_NPNOME]    := SA2->A2_NOME
			aCols[Len(aCols),_NPVALOR]   := SE2->E2_SALDO
			aCols[Len(aCols),_NPHIST]    := SE2->E2_HIST
			aCols[Len(aCols),Len(_aCampos)+1]:=.F.
			
			SEA->(dbSkip())
		EndDo
	Endif
	
	_lEdit  := .F.
	
	cTitulo       := "BORDERO DE PAGAMENTO"
	cAliasGetD    := "SEA"
	cLinOk        := "AllwaysTrue()"
	cTudOk        := "AllwaysTrue()"
	cFieldOk      := "AllwaysTrue()"
	
	_lRetMod2     := VN12_06(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)
	
	If _lRetMod2 .And. nOpcx == 3
		U_VN0013(.F.)
	Endif
ElseIf SCR->CR_TIPO == "07" // PEDIDO DE VENDA
	
	Private   Acols	:={}
	Private _nOpcX := 2
	
	Private VISUAL := (_nOpcX == 2)
	
	Private aHeader := {}
	Private _nOpcao := _nOpcX
	
	_nOpcE := _nOpcX
	_nOpcG := _nOpcX
	
	_aCampos := {"Z1_PRODUTO","B1_DESC","Z1_QUANT","Z1_PCOREF","Z1_FRETE","Z1_VLLISTA","Z1_TES","F4_TEXTO"}
	
	For AX:= 1 TO Len(_aCampos)
		dbSelectArea("Sx3")
		dbSetOrder(2)
		If dbSeek(_aCampos[AX])
			If Alltrim(SX3->X3_CAMPO) == "Z1_VLLISTA"
				AADD(aHeader,{ TRIM("Valor Total"), x3_campo, x3_picture,;
				x3_tamanho, x3_decimal,x3_valid,;
				x3_usado, x3_tipo, x3_arquivo, x3_context } )
			ElseIf Alltrim(SX3->X3_CAMPO) == "B1_DESC"
				AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
				30, x3_decimal,x3_valid,;
				x3_usado, x3_tipo, x3_arquivo, x3_context } )
			ElseIf Alltrim(SX3->X3_CAMPO) == "Z1_FRETE"
				AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
				05, x3_decimal,x3_valid,;
				x3_usado, x3_tipo, x3_arquivo, x3_context } )
			Else
				AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
				x3_tamanho, x3_decimal,x3_valid,;
				x3_usado, x3_tipo, x3_arquivo, x3_context } )
			Endif
		Endif
	Next Ax
	
	Private _nPPRODUTO := aScan( aHeader, { |x| Alltrim(x[2])== "Z1_PRODUTO" } )
	Private _nPDESC    := aScan( aHeader, { |x| Alltrim(x[2])== "B1_DESC"    } )
	Private _nPQUANT   := aScan( aHeader, { |x| Alltrim(x[2])== "Z1_QUANT"   } )
	Private _nPPCOREF  := aScan( aHeader, { |x| Alltrim(x[2])== "Z1_PCOREF"  } )
	Private _nPTES     := aScan( aHeader, { |x| Alltrim(x[2])== "Z1_TES"     } )
	Private _nPDESTES  := aScan( aHeader, { |x| Alltrim(x[2])== "F4_TEXTO"   } )
	Private _nPTOTAL   := aScan( aHeader, { |x| Alltrim(x[2])== "Z1_VLLISTA" } )
	Private _nPTPFRET  := aScan( aHeader, { |x| Alltrim(x[2])== "Z1_FRETE"   } )
	
	_cCliente := SCR->CR_YCLIENT
	_cLoja    := SCR->CR_YLOJA
	aCols     := {}
	_cPedido  := Substr(SCR->CR_NUM,1,TAMSX3("Z1_NUM")[1])
	
	SA1->(dbSetorder(1))
	SA1->(dbSeek(xFilial("SA1") + _cCliente + _cLoja))
	
	_cNomCli := SA1->A1_NOME
	_nLimite := 0
	_nSdoTit := 0
	
	ZA6->(dbSetOrder(1))
	If ZA6->(dbSeek(xFilial("ZA6") + _cCliente + _cLoja + "L"))
		
		_nLimite  := ZA6->ZA6_VALOR
		_nSdoTit  := ZA6->ZA6_SDOTIT
		_nSdoLim  := ZA6->ZA6_SDOLIM
	Endif
	
	SZ1->(dbSetOrder(1))
	If SZ1->(dbSeek(SCR->CR_MSFIL + _cPedido))
		
		_cChavSZ1 := SZ1->Z1_NUM
		
		While SZ1->(!Eof()) .And. _cChavSZ1 == SZ1->Z1_NUM
			
			AADD(aCols,Array(Len(_aCampos)+1))
			
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+ SZ1->Z1_PRODUTO))
			
			SF4->(dbSetOrder(1))
			SF4->(dbSeek(xFilial("SF4")+ SZ1->Z1_TES))
			
			aCols[Len(aCols),_NPPRODUTO] := SZ1->Z1_PRODUTO
			aCols[Len(aCols),_NPDESC]    := SB1->B1_DESC
			aCols[Len(aCols),_NPQUANT]   := SZ1->Z1_QUANT
			aCols[Len(aCols),_NPPCOREF]  := SZ1->Z1_PCOREF
			aCols[Len(aCols),_NPTPFRET]  := IIF (SZ1->Z1_FRETE = "C","C=CIF","F=FOB")
			aCols[Len(aCols),_NPTES]     := SZ1->Z1_TES
			aCols[Len(aCols),_NPDESTES]  := SF4->F4_TEXTO
			aCols[Len(aCols),_NPTOTAL]   := SZ1->Z1_QUANT * SZ1->Z1_PCOREF
			aCols[Len(aCols),Len(_aCampos)+1]:=.F.
			
			SZ1->(dbSkip())
		EndDo
	Endif
	
	_lEdit  := .F.
	
	cTitulo       := "PEDIDO DE VENDA"
	cAliasGetD    := "SZ1"
	cLinOk        := "AllwaysTrue()"
	cTudOk        := "AllwaysTrue()"
	cFieldOk      := "AllwaysTrue()"
	
	_lRetMod2     := VN12_06(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)
	
	If _lRetMod2 .And. nOpcx == 3
		U_VN0013(.F.)
	Endif
ElseIf SCR->CR_TIPO == "08" // DESCONTO CONTAS A RECEBER
	
	Private   Acols	:={}
	Private	oDescric,oGetDados, oCodigo
	Private _lVlMan   := .F.
	_nOpcX := 2
	
	_nOpcE := _nOpcX
	_nOpcG := _nOpcX
	Private _nOpcao := _nOpcX
	
	Private VISUAL := (_nOpcX == 2)
	Private INCLUI := (_nOpcX == 3)
	Private ALTERA := (_nOpcX == 4)
	Private DELETA := (_nOpcX == 5)
	
	Private aHeader := {}
	
	_aCampos := {"ZAD_ITEM","ZAD_DESC","ZAD_HISTOR","ZAD_DTMOV","ZAD_LIBER"}
	
	For AX:= 1 TO Len(_aCampos)
		dbSelectArea("Sx3")
		dbSetOrder(2)
		If dbSeek(_aCampos[AX])
			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal,x3_valid,;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )
		Endif
	Next Ax
	
	Private _nPITEM   := aScan( aHeader, { |x| Alltrim(x[2])== "ZAD_ITEM"   } )
	Private _nPDESC   := aScan( aHeader, { |x| Alltrim(x[2])== "ZAD_DESC"   } )
	Private _nPDTMOV  := aScan( aHeader, { |x| Alltrim(x[2])== "ZAD_DTMOV"  } )
	Private _nPHISTOR := aScan( aHeader, { |x| Alltrim(x[2])== "ZAD_HISTOR" } )
	Private _nPLIBER  := aScan( aHeader, { |x| Alltrim(x[2])== "ZAD_LIBER"  } )
	
	_cPrefixo := ZAD->ZAD_PREFIX
	_cNum     := ZAD->ZAD_NUM
	_cParcela := ZAD->ZAD_PARCEL
	_cTipo    := ZAD->ZAD_TIPO
	_cCliente := ZAD->ZAD_CLIENT
	_cLoja    := ZAD->ZAD_LOJA
	
	ZAD->(dbSetOrder(1))
	If ZAD->(dbSeek(xFilial("ZAD") + _cPrefixo + _cNum + _cParcela + _cTipo + _cCliente + _cLoja ))
		
		aCols     := {}
		
		_cChavZAD := ZAD->ZAD_PREFIX + ZAD->ZAD_NUM + ZAD->ZAD_PARCEL + ZAD->ZAD_TIPO + ZAD->ZAD_CLIENT + ZAD->ZAD_LOJA
		
		While ZAD->(!Eof()) .And. _cChavZAD == ZAD->ZAD_PREFIX + ZAD->ZAD_NUM + ZAD->ZAD_PARCEL + ZAD->ZAD_TIPO + ZAD->ZAD_CLIENT + ZAD->ZAD_LOJA
			
			AADD(aCols,Array(Len(_aCampos)+1))
			
			aCols[Len(aCols),_NPITEM]    := ZAD->ZAD_ITEM
			aCols[Len(aCols),_NPDESC]    := ZAD->ZAD_DESC
			aCols[Len(aCols),_NPDTMOV]   := ZAD->ZAD_DTMOV
			aCols[Len(aCols),_NPHISTOR]  := ZAD->ZAD_HISTOR
			aCols[Len(aCols),_NPLIBER]   := ZAD->ZAD_LIBER
			
			aCols[Len(aCols),Len(_aCampos)+1]:=.F.
			
			ZAD->(dbSkip())
		EndDo
	Endif
	
	cTitulo       := "DESCONTO FINANCEIRO"
	cAliasGetD    := "ZAD"
	cLinOk        := "AllwaysTrue()"
	cTudOk        := "AllwaysTrue()"
	cFieldOk      := "AllwaysTrue()"
	
	_lRetMod2     := VN12_06(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)
	
	If _lRetMod2 .And. nOpcx == 3
		U_VN0013(.F.)
	Endif
	
Endif

Return



Static Function VN12_06(cTitulo,cAlias2,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)

Local _nOpca := 0,cSaveMenuh,oDlg,oEstado,oMun,oDist

Private aSize	  := MsAdvSize()
Private aObjects  := {}
Private aPosObj   := {}
Private aSizeAut  := MsAdvSize()
Private aButtons  := {}

AAdd( aObjects, { 0,    25, .T., .F. })
AAdd( aObjects, { 100, 100, .T., .T. })
AAdd( aObjects, { 0,    3, .T., .F. })

aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects,.T. )

aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{10,35,100,135,205,255},{10,45,105,145,225,265,210,255}})

Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0

DEFINE MSDIALOG oDlg TITLE cTitulo From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_nTop := aPosObj[2,1]

If SCR->CR_TIPO == "03"
	@ 1.5,002 Say "Estado: "
	@ 1.5,005 MSGET oEstado  VAR _cEstado          When .F.     PICTURE "@!" SIZE 30,10
	
	@ 1.5,010 Say "Municipo: "
	@ 1.5,014 MSGET oMun     VAR _cMun             When .F.     PICTURE "@!" SIZE 50,10
	
	@ 1.5,025 Say "Distancia: "
	@ 1.5,030 MSGET oDist    VAR _cDist            When .F.     PICTURE "@!" SIZE 50,10
	
ElseIf SCR->CR_TIPO == "05"
	@ 1.5,002 Say "Cliente: "
	@ 1.5,005 MSGET oCliente VAR _cCliente         When .F.     PICTURE "@!" SIZE 30,10
	
	@ 1.5,010 Say "Loja: "
	@ 1.5,014 MSGET oLoja    VAR _cLoja            When .F.     PICTURE "99" SIZE 30,10
	
	@ 1.5,020 Say "Nome Cliente: "
	@ 1.5,025 MSGET oNomCli  VAR _cNomCli          When .F.     SIZE 120,10
	
	@ 1.5,041 Say "Saldo Limite: "
	@ 1.5,045 MSGET oSdoLim  VAR _nSdoLim          When .F.     PICTURE "@E 999,999,999.99" SIZE 50,10
	
	@ 1.5,053 Say "Saldo Titulo: "
	@ 1.5,057 MSGET oSdoTit  VAR _nSdoTit          When .F.     PICTURE "@E 999,999,999.99" SIZE 50,10
ElseIf SCR->CR_TIPO == "06"
	@ 1.5,002 Say "Bordero: "
	@ 1.5,005 MSGET oBordero VAR _cBordero         When .F.     PICTURE "@!" SIZE 30,10
	@ 1.5,023 Say "Total do Bordero: "
	@ 1.5,030 MSGET oTotBor  VAR SCR->CR_TOTAL     When .F.     PICTURE "@E 999,999,999.99" SIZE 50,10
ElseIf SCR->CR_TIPO == "07"
	@ 1.5,002 Say "Pedido: "
	@ 1.5,005 MSGET oPedido VAR _cPedido           When .F.     PICTURE "@!" SIZE 30,10
	
	@ 1.5,010 Say "Cliente: "
	@ 1.5,014 MSGET oCliente VAR _cCliente         When .F.     PICTURE "@!" SIZE 30,10
	
	@ 1.5,020 Say "Loja: "
	@ 1.5,023 MSGET oLoja    VAR _cLoja            When .F.     PICTURE "99" SIZE 30,10
	
	@ 1.5,027 Say "Nome Cliente: "
	@ 1.5,032 MSGET oNomCli  VAR _cNomCli          When .F.     SIZE 150,10
	
	@ 2.8,002 Say "Limite de Credito: "
	@ 2.8,010 MSGET oLimite  VAR _nLimite          When .F.     PICTURE "@E 999,999,999.99" SIZE 50,10
	
	@ 2.8,020 Say "Titulos Em Aberto: "
	@ 2.8,027 MSGET oTitFat  VAR _nSdoTit          When .F.     PICTURE "@E 999,999,999.99" SIZE 50,10
	
	@ 2.8,036 Say "Saldo do Limite: "
	@ 2.8,041 MSGET oSdoLim  VAR _nSdoLim          When .F.     PICTURE "@E 999,999,999.99" SIZE 50,10
	
	_nTop := aPosObj[2,1] + 7
Else
	@ 1.5,001 Say "Prefixo: "
	@ 1.5,004 MSGET oPrefixo  VAR _cPrefixo   When .F.  PICTURE "@!"  SIZE 30,10
	
	@ 1.5,010 Say "Numero: "
	@ 1.5,013 MSGET oNumero   VAR _cNum       When .F.  PICTURE "@!"  SIZE 50,10
	
	@ 1.5,022 Say "Parcela: "
	@ 1.5,025 MSGET oParcela  VAR _cParcela   When .F.  PICTURE "@!"  SIZE 10,10
	
	@ 1.5,029 Say "Cliente: "
	@ 1.5,032 MSGET oCliente  VAR _cCliente   When .F.  PICTURE "@!"  SIZE 30,10
	
	@ 1.5,039 Say "Loja: "
	@ 1.5,041 MSGET oLoja     VAR _cLoja      When .F.  PICTURE "@!"  SIZE 10,10
	
Endif

nGetLin := aPosObj[3,1]
//  									43			3	        285       675
//oGetDados := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],_nOpcao,"U_VN13_05()","MZ61_04","+AIB_ITEM",.T.)
oGetDados   := MsGetDados():New(_nTop,aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],_nOpcao,"U_VN13_05()","VN13_04","+AIB_ITEM",.T.)

ACTIVATE MSDIALOG oDlg centered ON INIT EnchoiceBar(oDlg,{||_nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),_nOpca := 0,oDlg:End()),_nOpca := 0)},{||oDlg:End()},,aButtons)

_lRet := (_nOpca==1)

Return(_lRet)



User Function VN0013(_lPortal,_cAprov,_cTipoDoc,_aDados)

Private _aErro := {}

If _lPortal
	
	_cAprovador := _cAprov
	_cCrTipo    := _cTipoDoc
	
	dbSelectArea("SAK")
	dbSetOrder(2)
	If !MsSeek(xFilial("SAK") + _cAprovador)
		Help(" ",1,"A097APROV")
		dbSelectArea("SCR")
		dbSetOrder(1)
		_aErro := {{"02","Aprovador Nao Cadastrado"}}
		Return(_aErro)
	Endif
	
	_cAprovador := SAK->AK_COD
	
	SCR->(dbSetOrder(1))
	If SCR->(!dbSeek(xFilial("SCR") + _cTipoDoc + _aDados[1]))
		MSGSTOP("DOCUMENTO NAO CADASTRADO!!!")
		_aErro := {{"03","Documento Nao Encontrado"}}
		Return(_aErro)
	Endif
Endif

dbSelectArea("SAK")  /// APROVADORES
dbSetOrder(1)
dbSeek(xFilial("SAK")+_cAprovador)

dbSelectArea("SCR")
cAuxNivel := SCR->CR_NIVEL

If SCR->CR_TIPO $ "PC/NF"
	
	Private nReg      := SCR->(RecNo())
	Private aArea	  := GetArea()
	Private aCposObrig:= {"D1_ITEM","D1_COD","D1_QUANT","D1_VUNIT","D1_PEDIDO","D1_ITEMPC","C7_QUANT","C7_PRECO","C7_QUJE","Divergência"}
	Private aHeadCpos := {}
	Private aHeadSize := {}
	Private aArrayNF  := {}
	Private aCampos   := {}
	Private aRetSaldo := {}
	
	Private cObs 	  := IIF(!Empty(SCR->CR_OBS),SCR->CR_OBS,CriaVar("CR_OBS"))
	Private ca097User := RetCodUsr()
	Private cTipoLim  := ""
	Private CRoeda    := ""
	Private cAprov    := ""
	Private cName     := ""
	Private cSavColor := ""
	Private cGrupo	  := ""
	Private cCodLiber := SCR->CR_APROV
	Private cDocto    := SCR->CR_NUM
	Private cTipo     := SCR->CR_TIPO
	Private dRefer 	  := dDataBase
	Private cPCLib	  := ""
	Private cPCUser	  := ""
	Private lAprov    := .F.
	Private lLiberou  := .F.
	Private lLibOk    := .F.
	Private lContinua := .T.
	Private lShowBut  := .T.
	Private lOGpaAprv := SuperGetMv("MV_OGPAPRV",.F.,.F.)
	
	Private nSavOrd   := IndexOrd()
	Private nSaldo    := 0
	Private nOpc      := 0
	Private nSalDif	  := 0
	Private nTotal    := 0
	Private nMoeda	  := 1
	Private nX        := 1
	Private nRecnoAS400:= 1
	
	Private oDlg
	Private oDataRef
	Private oSaldo
	Private oSalDif
	Private oBtn1
	Private oBtn2
	Private oBtn3
	Private oQual
	Private aSize   := {0,0}
	Private lUsaACC := If(FindFunction("WebbConfig"),WebbConfig(),.F.)
	
	If lContinua .And. !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#05"
		Help(" ",1,"A097LIB")
		lContinua := .F.
	ElseIf lContinua .And. SCR->CR_STATUS$"01"
		lContinua := .F.
		Aviso("A097BLQ","Esta operação não poderá ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)",{"Atencao"})
		
		_aErro := {{"04","Aguardando Liberaçao de Outros Niveis"}}
		Return(_aErro)
	EndIf
	
	If lContinua
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta o Header com os titulos do TWBrowse             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SX3")
		dbSetOrder(2)
		For nx	:= 1 to Len(aCposObrig)
			If MsSeek(aCposObrig[nx])
				AADD(aHeadCpos,AllTrim(X3Titulo()))
				AADD(aHeadSize,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))
				AADD(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
			Else
				AADD(aHeadCpos,"Divergencia")
				AADD(aCampos,{" ","C"})
			EndIf
		Next
		
		dbSelectArea("SAL")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicializa as variaveis utilizadas no Display.               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aRetSaldo := MaSalAlc(cCodLiber,dRefer)
		nSaldo 	  := aRetSaldo[1]
		CRoeda 	  := A097Moeda(aRetSaldo[2])
		cName  	  := UsrRetName(ca097User)
		nTotal    := xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)
		
		Do Case
			Case SAK->AK_TIPO == "D"
				cTipoLim :=OemToAnsi("Diario")
			Case  SAK->AK_TIPO == "S"
				cTipoLim := OemToAnsi("Semanal")
			Case  SAK->AK_TIPO == "M"
				cTipoLim := OemToAnsi("Mensal")
			Case  SAK->AK_TIPO == "A"
				cTipoLim := OemToAnsi("Anual")
		EndCase
		
		Do Case
			
			Case SCR->CR_TIPO == "NF"
				
				dbSelectArea("SF1")
				dbSetOrder(1)
				//MsSeek(xFilial("SF1")+Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))
				MsSeek(SCR->CR_MSFIL + Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))
				cGrupo := SF1->F1_APROV
				
				dbSelectArea("SD1")
				dbSetOrder(1)
				MsSeek(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
				
				While ( !Eof().And. SD1->D1_FILIAL == SF1->F1_FILIAL .And. SD1->D1_DOC     == SF1->F1_DOC     .And. ;
					SD1->D1_SERIE  == SF1->F1_SERIE  .And. SD1->D1_FORNECE == SF1->F1_FORNECE .And. SD1->D1_LOJA == SF1->F1_LOJA )
					
					Aadd(aArrayNF,Array(Len(aCampos)))
					
					If !Empty(SD1->D1_PEDIDO)
						dbSelectArea("SC7")
						dbSetOrder(1)
						MsSeek(xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC)
					EndIf
					
					For nX := 1 to Len(aCampos)
						
						If Substr(aCampos[nX][1],1,2) == "D1"
							If aCampos[nX][2] == "N"
								aArrayNF[Len(aArrayNF)][nX] := Transform(SD1->(FieldGet(FieldPos(aCampos[nX][1]))),PesqPict("SD1",aCampos[nX][1]))
							Else
								aArrayNF[Len(aArrayNF)][nX] := SD1->(FieldGet(FieldPos(aCampos[nX][1])))
							Endif
						Elseif Substr(aCampos[nX][1],1,2) == "C7"
							If !Empty(SD1->D1_PEDIDO)
								If aCampos[nX][2] == "N"
									aArrayNF[Len(aArrayNF)][nX] := Transform(SC7->(FieldGet(FieldPos(aCampos[nX][1]))),PesqPict("SC7",aCampos[nX][1]))
								Else
									aArrayNF[Len(aArrayNF)][nX] := SC7->(FieldGet(FieldPos(aCampos[nX][1])))
								Endif
							Else
								aArrayNF[Len(aArrayNF)][nX] := " "
							EndIf
						Else
							If !Empty(SD1->D1_PEDIDO)
								If SD1->D1_QUANT <> SC7->C7_QUANT .And. SD1->D1_VUNIT == SC7->C7_PRECO
									aArrayNF[Len(aArrayNF)][nX] := OemToAnsi("Quantidade")
								ElseIf SD1->D1_QUANT <> SC7->C7_QUANT .And. SD1->D1_VUNIT <> SC7->C7_PRECO
									aArrayNF[Len(aArrayNF)][nX] := OemToAnsi("Qtde/Preco")
								ElseIf SD1->D1_QUANT == SC7->C7_QUANT .And. SD1->D1_VUNIT <> SC7->C7_PRECO
									aArrayNF[Len(aArrayNF)][nX] := OemToAnsi("Preco     ")
								Else
									aArrayNF[Len(aArrayNF)][nX] := OemToAnsi("OK        ")
								Endif
							Else
								aArrayNF[Len(aArrayNF)][nX] := OemToAnsi("Sem Pedido")
							EndIf
						EndIf
						
					Next nX
					
					SD1->( dbSkip() )
				EndDo
				
				dbSelectArea("SA2")
				dbSetOrder(1)
				MsSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
				
				dbSelectArea("SAL")
				dbSetOrder(3)
				MsSeek(xFilial("SAL")+SF1->F1_APROV+SAK->AK_COD)
				
				If Eof()
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona a Tabela SAL pelo Aprovador de Origem caso o Documento tenha sido ³
					//| transferido por Ausência Temporária ou Transferência superior e o aprovador |
					//| de destino não fizer parte do Grupo de Aprovação.                           |
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !Empty(SCR->(FieldPos("CR_USERORI")))
						dbSeek(xFilial("SAL")+SF1->F1_APROV+SCR->CR_APRORI)
					EndIf
				EndIf
				
				If lOGpaAprv
					If Eof()
						Aviso("A097NOAPRV","O aprovador não foi encontrado no grupo de aprovação deste documento, verifique e se necessário inclua novamente o aprovador no grupo de aprovação "+SF1->F1_APROV+CRLF+"STR0090",{"Ok"})
						lContinua := .F.
					EndIf
				EndIf
				
			Case SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
				
				dbSelectArea("SC7")
				dbSetOrder(1)
				MsSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
				cGrupo := SC7->C7_APROV
				
				dbSelectArea("SA2")
				dbSetOrder(1)
				MsSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
				
				dbSelectArea("SAL")
				dbSetOrder(3)
				MsSeek(xFilial("SAL")+SC7->C7_APROV+SAK->AK_COD)
				
				If Eof()
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona a Tabela SAL pelo Aprovador de Origem caso o Documento tenha sido ³
					//| transferido por Ausência Temporária ou Transferência superior e o aprovador |
					//| de destino não fizer parte do Grupo de Aprovação.                           |
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !Empty(SCR->(FieldPos("CR_USERORI")))
						dbSeek(xFilial("SAL")+SC7->C7_APROV+SCR->CR_APRORI)
					EndIf
				EndIf
				
				If lOGpaAprv
					If Eof()
						Aviso("A097NOAPRV","O aprovador não foi encontrado no grupo de aprovação deste documento, verifique e se necessário inclua novamente o aprovador no grupo de aprovação "+SC7->C7_APROV+CRLF+"Aviso",{"Ok"})
						lContinua := .F.
						_aErro := {{"05","Aprovador Nao Encontrado no Grupo de Documento"}}
						Return(_aErro)
					EndIf
				Endif
		EndCase
		
		If SAL->AL_LIBAPR != "A"
			lAprov := .T.
			cAprov := OemToAnsi("VISTO / LIVRE")
		EndIf
		nSalDif := nSaldo - IIF(lAprov,0,nTotal)
		If (nSalDif) < 0
			Help(" ",1,"A097SALDO")
			lContinua := .F.
			_aErro := {{"06","Saldo Insuficiente"}}
			Return(_aErro)
		EndIf
	EndIf
	
	If lContinua
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicializa a gravacao dos lancamentos do SIGAPCO          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PcoIniLan("000055")
		
		If SCR->CR_TIPO <> "NF"
			aSize := {290,410}
			
			DEFINE MSDIALOG oDlg FROM 0,0 TO aSize[1],aSize[2] TITLE OemToAnsi("Liberacao do PC") PIXEL
			@ 0.5,01 TO 44,204 LABEL "" OF oDlg PIXEL
			@ 45,01  TO 128,204 LABEL "" OF oDlg PIXEL
			@ 07,06  Say OemToAnsi("Numero do Pedido ") OF oDlg PIXEL
			@ 07,120 Say OemToAnsi("Emissao ") OF oDlg SIZE 50,9 PIXEL
			@ 19,06  Say OemToAnsi("Fonecedor ") OF oDlg PIXEL
			@ 31,06  Say OemToAnsi("Aprovador ") OF oDlg PIXEL SIZE 30,9
			@ 31,120 Say OemToAnsi("Data de ref.  ") SIZE 60,9 OF oDlg PIXEL
			@ 53,06  Say OemToAnsi("Limite min.  ") +CRoeda OF oDlg PIXEL
			@ 53,110 Say OemToAnsi("Limite max. ")+CRoeda SIZE 60,9 OF oDlg PIXEL
			@ 65,06  Say OemToAnsi("Limite  ")+CRoeda  OF oDlg PIXEL
			@ 65,110 Say OemToAnsi("Tipo lim.") OF oDlg PIXEL
			@ 77,06  Say OemToAnsi("Saldo na data  ")+CRoeda OF oDlg PIXEL
			If lAprov .Or. SCR->CR_MOEDA == aRetSaldo[2]
				@ 89,06 Say OemToAnsi("Total do documento ")+CRoeda OF oDlg PIXEL
			Else
				@ 89,06 Say OemToAnsi("Total do documento, convertido em ")+CRoeda OF oDlg PIXEL
			EndIf
			@ 101,06 Say OemToAnsi("Saldo disponivel apos liberacao  ") +CRoeda SIZE 130,10 OF oDlg PIXEL
			@ 113,06 Say OemToAnsi("Observa‡äes ") SIZE 100,10 OF oDlg PIXEL
			@ 07,58  MSGET SCR->CR_NUM     When .F. SIZE 28 ,9 OF oDlg PIXEL
			@ 07,155 MSGET SCR->CR_EMISSAO When .F. SIZE 45 ,9 OF oDlg PIXEL
			@ 19,45  MSGET SA2->A2_NOME    When .F. SIZE 155,9 OF oDlg PIXEL
			@ 31,45  MSGET cName           When .F. SIZE 50 ,9 OF oDlg PIXEL
			@ 31,155 MSGET oDataRef VAR dRefer When .F. SIZE 45 ,9 OF oDlg PIXEL
			@ 53,50  MSGET SAK->AK_LIMMIN Picture "@E 999,999,999.99" When .F. SIZE 55,9 OF oDlg PIXEL RIGHT
			@ 53,155 MSGET SAK->AK_LIMMAX Picture "@E 999,999,999.99" When .F. SIZE 45,9 OF oDlg PIXEL RIGHT
			@ 65,50  MSGET SAK->AK_LIMITE Picture "@E 999,999,999.99" When .F. SIZE 55,9 OF oDlg PIXEL RIGHT
			@ 65,155 MSGET cTipoLim When .F. SIZE 45,9 OF oDlg PIXEL CENTERED
			@ 77,115 MSGET oSaldo VAR nSaldo Picture "@E 999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
			If lAprov
				@ 89,115 MSGET cAprov Picture "@!" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
			Else
				@ 89,115 MSGET nTotal Picture "@E 999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
			EndIf
			@ 101,115 MSGET oSaldif VAR nSalDif Picture "@E 999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
			@ 113,115 MSGET cObs Picture "@!" SIZE 85,9 OF oDlg PIXEL
			
			If lShowBut
				@ 132, 39 BUTTON OemToAnsi("Data de ref.  ") SIZE 40 ,11  FONT oDlg:oFont ACTION A097Data(oDataRef,oSaldo,oSalDif,@dRefer,aRetSaldo,@cCodLiber,@nSaldo,@cRoeda,@cName,@ca097User,@nTotal,@nSalDif,lAprov) OF oDlg PIXEL
			Endif
			
			@ 132, 80 BUTTON OemToAnsi("Libera Docto") SIZE 40 ,11  FONT oDlg:oFont ACTION If(ValidPcoLan() .And. A097ValObs(cObs),(nOpc:=2,oDlg:End()),Nil)  OF oDlg PIXEL
			@ 132,121 BUTTON OemToAnsi("Cancelar") SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End())  OF oDlg PIXEL
			@ 132,162 BUTTON OemToAnsi("Bloqueia Docto") SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=3,oDlg:End())  OF oDlg PIXEL
			
			ACTIVATE MSDIALOG oDlg CENTERED
		Else
			aSize := {400,780}
			
			DEFINE MSDIALOG oDlg FROM 000,000 TO aSize[1],aSize[2] TITLE OemToAnsi("Liberacao de Documentos") PIXEL
			
			@ 001,001  TO 050,425 LABEL "" OF oDlg PIXEL
			
			@ 007,006 Say OemToAnsi("Numero do Pedido ") OF oDlg PIXEL SIZE 080,009
			@ 007,120 Say OemToAnsi("Emissao ")          OF oDlg PIXEL SIZE 050,009
			@ 007,216 Say OemToAnsi("Aprovador ")        OF oDlg PIXEL SIZE 030,009
			@ 021,006 Say OemToAnsi("Fonecedor ")        OF oDlg PIXEL SIZE 030,009
			@ 021,216 Say OemToAnsi("Data de ref.  ")    OF oDlg PIXEL SIZE 060,009
			@ 035,006 Say OemToAnsi("Observa‡äes ")      OF oDlg PIXEL SIZE 100,010
			@ 035,216 Say OemToAnsi("Liberacao do docto") OF oDlg PIXEL SIZE 100,010
			
			@ 007,058 MSGET SCR->CR_NUM        When .F. SIZE 028,009 OF oDlg PIXEL
			@ 007,155 MSGET SCR->CR_EMISSAO    When .F. SIZE 045,009 OF oDlg PIXEL
			@ 007,270 MSGET cName              When .F. SIZE 050,009 OF oDlg PIXEL RIGHT
			@ 021,045 MSGET SA2->A2_NOME       When .F. SIZE 155,009 OF oDlg PIXEL
			@ 021,270 MSGET oDataRef VAR dRefer When .F. SIZE 050,009 OF oDlg PIXEL RIGHT
			@ 035,115 MSGET cObs           Picture "@!" SIZE 085,009 OF oDlg PIXEL
			@ 035,270 MSGET OemToAnsi("VISTO / LIVRE") When .F. SIZE 050,009 OF oDlg PIXEL RIGHT
			
			oQual:= TWBrowse():New( 051,001,389,133,,aHeadCpos,aHeadSize,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
			oQual:SetArray(aArrayNF)
			oQual:bLine := { || aArrayNF[oQual:nAT] }
			
			@ 187,258 BUTTON OemToAnsi("Libera Docto")   SIZE 040,011 FONT oDlg:oFont ACTION If(ValidPcoLan() .And. A097ValObs(cObs),(nOpc:=2,oDlg:End()),Nil)  OF oDlg PIXEL
			@ 187,299 BUTTON OemToAnsi("Cancelar")       SIZE 040,011 FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End()) OF oDlg PIXEL
			@ 187,340 BUTTON OemToAnsi("Bloqueia Docto") SIZE 040,011 FONT oDlg:oFont ACTION (nOpc:=3,oDlg:End())  OF oDlg PIXEL
			
			ACTIVATE MSDIALOG oDlg CENTERED
		Endif
		
		If nOpc == 2 .Or. nOpc == 3
			SCR->(dbClearFilter())
			SCR->(dbGoTo(nReg))
			
			If ( SCR->CR_TIPO == "NF" )
				lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)),SCR->CR_TIPO)
			ElseIf SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
				lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(SC7->C7_NUM)),SCR->CR_TIPO)
			EndIf
			If lLibOk
				Begin Transaction
				lLiberou := U_VN13_01({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,If(nOpc==2,4,6))
				_lParar  := .T.
				
				If lLiberou
					PcoDetLan("000055","02","MATA097")
					
					If SCR->CR_TIPO == "NF"
						dbSelectArea("SF1")
						Reclock("SF1",.F.)
						SF1->F1_STATUS := If(SF1->F1_STATUS=="B"," ",SF1->F1_STATUS)
						MsUnlock()
					ElseIf SCR->CR_TIPO == "PC"
						dbSelectArea("SC7")
						cPCLib := SC7->C7_NUM
						cPCUser:= SC7->C7_USER
						While !Eof() .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM))
							Reclock("SC7",.F.)
							SC7->C7_CONAPRO := "L"
							MsUnlock()
							
							PcoDetLan("000055","01","MATA097")
							
							_aErro := {{"01","Liberado com Sucesso"}}
							dbSkip()
						EndDo
						
						dbSkip(-1)
						If lUsaACC .And. !Empty(SC7->(FieldPos("C7_ACCNUM")))
							If IsBlind()
								Webb533(SC7->C7_NUM)
							Else
								MsgRun("Aguarde, comunicando aprovação ao portal...","Portal ACC",{|| Webb533(SC7->C7_NUM)})
							EndIf
						EndIf
						
						MEnviaMail("034",{cPCLib,SCR->CR_TIPO},cPCUser)
					EndIf
				EndIf
				End Transaction
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Finaliza a gravacao dos lancamentos do SIGAPCO            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PcoFinLan("000055")
			Else
				Help(" ",1,"A097LOCK")
			Endif
			If cTipo == "PC" .Or. cTipo == "AE"
				SC7->(MsUnlockAll())
			EndIf
		EndIf
		dbSelectArea("SCR")
		dbSetOrder(1)
		
		If !_lPortal
			SCR->(Eval(bFilSCRBrw))
		Endif
		
		PcoFreeBlq("000055")
	EndIf
	dbSelectArea("SC7")
	RestArea(aArea)
	
ElseIf SCR->CR_TIPO == "02"
	
	_cDocSCR := SCR->CR_NUM
	_cCliente:= SCR->CR_YCLIENT
	_cLoja   := SCR->CR_YLOJA
	_cProduto:= SCR->CR_YPRODUT
	_cTpDoc  := SCR->CR_TIPO
	_cObra   := SCR->CR_YOBRA
	
	nReg     := SCR->(Recno())
	SCR->(dbClearFilter())
	SCR->(dbGoTo(nReg))
	
	SCR->(dbSetOrder(1))
	If SCR->(dbseek(xFilial("SCR")+ _cTpDoc + _cDocSCR))
		
		If Empty(_cObra)
			SZI->(dbSetOrder(1))
			If SZI->(dbSeek(SCR->CR_MSFIL+ SCR->CR_YCLIENT + SCR->CR_YLOJA + SCR->CR_YPRODUT + "L"))
				SZI->(RecLock("SZI",.F.))
				SZI->ZI_LIBER := "B"
				SZI->ZI_DTBLOQ := Date()
				SZI->(MsUnLock())
			Endif
			
			SZI->(dbSetOrder(1))
			If SZI->(dbSeek(SCR->CR_MSFIL + SCR->CR_YCLIENT + SCR->CR_YLOJA + SCR->CR_YPRODUT + Space(01)))
				SZI->(RecLock("SZI",.F.))
				SZI->ZI_LIBER  := "L"
				SZI->ZI_DTVIGEN:= Date()
				SZI->ZI_USRLIB := Substr(cUsuario,7,15)
				SZI->(MsUnLock())
				_aErro := {{"01","Liberado com Sucesso"}}
			Else
				_aErro := {{"07","Documento Ja Liberado Anteriormente"}}
			Endif
		Else
			ZA2->(dbSetOrder(2))
			If ZA2->(dbSeek(xFilial("ZA2")+ SCR->CR_YCLIENT + SCR->CR_YLOJA + SCR->CR_YPRODUT + SCR->CR_YOBRA + "L"))
				ZA2->(RecLock("ZA2",.F.))
				ZA2->ZA2_LIBER := "B"
				ZA2->ZA2_DTBLOQ := Date()
				ZA2->(MsUnLock())
			Endif
			
			ZA2->(dbSetOrder(2))
			If ZA2->(dbSeek(xFilial("ZA2")+ SCR->CR_YCLIENT + SCR->CR_YLOJA + SCR->CR_YPRODUT + SCR->CR_YOBRA + Space(01)))
				ZA2->(RecLock("ZA2",.F.))
				ZA2->ZA2_LIBER  := "L"
				ZA2->ZA2_DTVIG  := Date()
				ZA2->(MsUnLock())
				_aErro := {{"01","Liberado com Sucesso"}}
			Else
				_aErro := {{"07","Documento Ja Liberado Anteriormente"}}
			Endif
		Endif
		
		_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM
		
		ZAH->(dbSetOrder(1))
		If ZAH->(dbSeek(xFilial("ZAH")+ SCR->CR_TIPO + SCR->CR_NUM  ))
			_cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
			_cCrTipo  := SCR->CR_TIPO
			_cDocSCR  := SCR->CR_NUM
			
			_cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "
			
			TcSqlExec(_cCq)
		Endif
		
		While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM
			
			SCR->(Reclock("SCR",.F.))
			SCR->CR_STATUS	:= "03"
			SCR->CR_DATALIB	:= Date()
			SCR->CR_USERLIB	:= SAK->AK_USER
			SCR->CR_LIBAPRO	:= SAK->AK_COD
			SCR->CR_APROV	:= _cAprovador
			SCR->CR_VALLIB	:= SCR->CR_TOTAL
			SCR->CR_TIPOLIM	:= SAK->AK_TIPO
			SCR->(MsUnlock())
			
			SCR->(dbSkip())
		EndDo
	Endif
	
	dbSelectArea("SCR")
	dbSetOrder(1)
	
	If !_lPortal
		SCR->(Eval(bFilSCRBrw))
	Endif
ElseIf SCR->CR_TIPO == "03"
	_cDocSCR := SCR->CR_NUM
	_cFornece:= SCR->CR_YFORNEC
	_cLojaFor:= SCR->CR_YLOJFOR
	_cEstado := SCR->CR_YESTADO
	_cTpDoc  := SCR->CR_TIPO
	_cMun    := SCR->CR_YMUN
	
	nReg     := SCR->(Recno())
	SCR->(dbClearFilter())
	SCR->(dbGoTo(nReg))
	
	SCR->(dbSetOrder(1))
	If SCR->(dbseek(xFilial("SCR")+ _cTpDoc + _cDocSCR))
		
		SZG->(dbSetOrder(1))
		If SZG->(dbSeek(SCR->CR_MSFIL + SCR->CR_YESTADO  + SCR->CR_YMUN + SCR->CR_YFORNEC + SCR->CR_YLOJFOR + "L"))
			SZG->(RecLock("SZG",.F.))
			SZG->ZG_LIBER := "B"
			SZG->ZG_DTBLOQ := Date()
			SZG->(MsUnlock())
		Endif
		
		SZG->(dbSetOrder(1))
		If SZG->(dbSeek(SCR->CR_MSFIL + SCR->CR_YESTADO  + SCR->CR_YMUN + SCR->CR_YFORNEC + SCR->CR_YLOJFOR + Space(01)))
			SZG->(RecLock("SZG",.F.))
			SZG->ZG_LIBER  := "L"
			SZG->ZG_DTVIG  := Date()
			SZG->(MsUnLock())
			_aErro := {{"01","Liberado com Sucesso"}}
		Else
			_aErro := {{"07","Documento Ja Liberado Anteriormente"}}
		Endif
		
		_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM
		
		ZAH->(dbSetOrder(1))
		If ZAH->(dbSeek(xFilial("ZAH")+ SCR->CR_TIPO + SCR->CR_NUM  ))
			_cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
			_cCrTipo  := SCR->CR_TIPO
			_cDocSCR  := SCR->CR_NUM
			
			_cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "
			
			TcSqlExec(_cCq)
		Endif
		
		While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM
			
			SCR->(Reclock("SCR",.F.))
			SCR->CR_STATUS	:= "03"
			SCR->CR_DATALIB	:= Date()
			SCR->CR_USERLIB	:= SAK->AK_USER
			SCR->CR_LIBAPRO	:= SAK->AK_COD
			SCR->CR_APROV	:= _cAprovador
			SCR->CR_VALLIB	:= SCR->CR_TOTAL
			SCR->CR_TIPOLIM	:= SAK->AK_TIPO
			SCR->(MsUnlock())
			
			SCR->(dbSkip())
		EndDo
	Endif
	
	dbSelectArea("SCR")
	dbSetOrder(1)
	
	If !_lPortal
		SCR->(Eval(bFilSCRBrw))
	Endif
	
ElseIf SCR->CR_TIPO == "04"
	_cDocSCR := SCR->CR_NUM
	_cFornece:= SCR->CR_YFORNEC
	_cLojaFor:= SCR->CR_YLOJFOR
	_cTabPrc := SCR->CR_YCODTAB
	_cTpDoc  := SCR->CR_TIPO
	_cProduto:= SCR->CR_YPRODUT
	
	nReg     := SCR->(Recno())
	SCR->(dbClearFilter())
	SCR->(dbGoTo(nReg))
	
	SCR->(dbSetOrder(1))
	If SCR->(dbseek(xFilial("SCR")+ _cTpDoc + _cDocSCR))
		
		AIB->(dbOrderNickName("INDAIB2"))
		If AIB->(dbSeek(SCR->CR_MSFIL + SCR->CR_YFORNEC  + SCR->CR_YLOJFOR + SCR->CR_YCODTAB + SCR->CR_YPRODUT + "L"))
			AIB->(RecLock("AIB",.F.))
			If !Empty(AIB->AIB_YLIB01) .And. !Empty(AIB->AIB_YLIB02)
				AIB->AIB_YLIBER := "B"
				AIB->AIB_YDTBLQ := Date()
			Endif
			AIB->(MsUnlock())
		Endif
		
		_lPrim    := .F.
		
		AIB->(dbOrderNickName("INDAIB2"))
		If AIB->(dbSeek(SCR->CR_MSFIL + SCR->CR_YFORNEC  + SCR->CR_YLOJFOR + SCR->CR_YCODTAB + SCR->CR_YPRODUT + Space(01)))
			AIB->(RecLock("AIB",.F.))
			If Empty(AIB->AIB_YLIB01)
				//AIB->AIB_YLIB01 := Substr(cUsuario,7,15)
				AIB->AIB_YLIB01 := cUsername
				_lPrim          := .T.      
			Else
				//AIB->AIB_YLIB02 := Substr(cUsuario,7,15)
				AIB->AIB_YLIB02 := cUsername
			Endif
			
			If !Empty(AIB->AIB_YLIB01) .And. !Empty(AIB->AIB_YLIB02)
				AIB->AIB_YLIBER := "L"
				AIB->AIB_DATVIG := Date()
				//AIB->AIB_USRLIB := Substr(cUsuario,7,15)
				AIB->AIB_USRLIB := cUsername
			Endif
			
			AIB->(MsUnlock())
			
			_aErro := {{"01","Liberado com Sucesso"}}
		Else
			_aErro := {{"07","Documento Ja Liberado Anteriormente"}}
		Endif
		
		If _lPrim
			ZAH->(dbSetOrder(1))
			If ZAH->(dbSeek(xFilial("ZAH")+ SCR->CR_TIPO + SCR->CR_NUM  ))
				_cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
				_cCrTipo  := SCR->CR_TIPO
				_cDocSCR  := SCR->CR_NUM
				
				_cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' AND ZAH_USER = '"+CA097USER+"' "
				
				TcSqlExec(_cCq)
			Endif
			
			SCR->(dbSetOrder(2))
			If SCR->(dbSeek(xFilial("SCR") + _cTpDoc + _cDocSCR + CA097USER))
				SCR->(Reclock("SCR",.F.))
				SCR->CR_STATUS	:= "03"
				SCR->CR_DATALIB	:= Date()
				SCR->CR_USERLIB	:= SAK->AK_USER
				SCR->CR_LIBAPRO	:= SAK->AK_COD
				SCR->CR_APROV	:= _cAprovador
				SCR->CR_VALLIB	:= SCR->CR_TOTAL
				SCR->CR_TIPOLIM	:= SAK->AK_TIPO
				SCR->(MsUnlock())
			Endif
		Else
			_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM
			ZAH->(dbSetOrder(1))
			If ZAH->(dbSeek(xFilial("ZAH")+ SCR->CR_TIPO + SCR->CR_NUM  ))
				_cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
				_cCrTipo  := SCR->CR_TIPO
				_cDocSCR  := SCR->CR_NUM
				
				_cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "
				
				TcSqlExec(_cCq)
			Endif
			
			While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM
				
				SCR->(Reclock("SCR",.F.))
				SCR->CR_STATUS	:= "03"
				SCR->CR_DATALIB	:= Date()
				SCR->CR_USERLIB	:= SAK->AK_USER
				SCR->CR_LIBAPRO	:= SAK->AK_COD
				SCR->CR_APROV	:= _cAprovador
				SCR->CR_VALLIB	:= SCR->CR_TOTAL
				SCR->CR_TIPOLIM	:= SAK->AK_TIPO
				SCR->(MsUnlock())
				
				SCR->(dbSkip())
			EndDo
		Endif
	Endif
	
	dbSelectArea("SCR")
	dbSetOrder(1)
	
	If !_lPortal
		SCR->(Eval(bFilSCRBrw))
	Endif
	
ElseIf SCR->CR_TIPO == "05"
	_cDocSCR := SCR->CR_NUM
	_cCliente:= SCR->CR_YCLIENT
	_cLoja   := SCR->CR_YLOJA
	_cTpDoc  := SCR->CR_TIPO
	
	nReg     := SCR->(Recno())
	SCR->(dbClearFilter())
	SCR->(dbGoTo(nReg))
	
	SCR->(dbSetOrder(1))
	If SCR->(dbseek(xFilial("SCR")+ _cTpDoc + _cDocSCR))
		
		ZA6->(dbSetOrder(1))
		If ZA6->(dbSeek(xFilial("ZA6") + SCR->CR_YCLIENT + SCR->CR_YLOJA + "L"))
			
			ZA6->(RecLock("ZA6",.F.))
			ZA6->ZA6_LIBER := "B"
			ZA6->ZA6_DTBLOQ:= Date()
			ZA6->(MsUnlock())
		Endif
		
		ZA6->(dbSetOrder(1))
		If ZA6->(dbSeek(xFilial("ZA6") + SCR->CR_YCLIENT + SCR->CR_YLOJA + Space(01)))
			ZA6->(RecLock("ZA6",.F.))
			ZA6->ZA6_LIBER  := "L"
			ZA6->ZA6_DTVIG  := Date()
			//ZA6->ZA6_USRLIB := Alltrim(Substr(cUsuario,7,15))
			ZA6->ZA6_USRLIB := cUsername
			ZA6->(MsUnlock())
			_aErro := {{"01","Liberado com Sucesso"}}
			
			SA1->(dbSetOrder(1))
			SA1->(dbSeek(xFilial("SA1") +SCR->CR_YCLIENT + SCR->CR_YLOJA))
			
			// ALTERADO EM 12/12/12
			SA1->(RecLock("SA1",.F.))
			SA1->A1_COND   := ZA6->ZA6_PRAZO
			SA1->A1_LC     := ZA6->ZA6_VALOR
			SA1->A1_TIPO   := ZA6->ZA6_TIPO
			SA1->A1_RISCO  := ZA6->ZA6_RISCO
			SA1->A1_YBLQSCI:= ZA6->ZA6_DTSCI
			SA1->A1_YLIB   := "S"
			SA1->(MsUnlock())
		Else
			_aErro := {{"07","Documento Ja Liberado Anteriormente"}}
		Endif
		
		_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM
		/*
		ZAH->(dbSetOrder(1))
		If ZAH->(dbSeek(xFilial("ZAH")+ SCR->CR_TIPO + SCR->CR_NUM  ))
			_cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
			_cCrTipo  := SCR->CR_TIPO
			_cDocSCR  := SCR->CR_NUM
			
			_cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "
			
			TcSqlExec(_cCq)
		Endif
		*/
		While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM
			
			SCR->(Reclock("SCR",.F.))
			SCR->CR_STATUS	:= "03"
			SCR->CR_DATALIB	:= Date()
			SCR->CR_USERLIB	:= SAK->AK_USER
			SCR->CR_LIBAPRO	:= SAK->AK_COD
			SCR->CR_APROV	:= _cAprovador
			SCR->CR_VALLIB	:= SCR->CR_TOTAL
			SCR->CR_TIPOLIM	:= SAK->AK_TIPO
			SCR->(MsUnlock())
			
			SCR->(dbSkip())
		EndDo
	Endif
	
	dbSelectArea("SCR")
	dbSetOrder(1)
	
	If !_lPortal
		SCR->(Eval(bFilSCRBrw))
	Endif
ElseIf SCR->CR_TIPO == "06"   // BORDERO DE PAGAMENTO
	
	_cNomeUsr:= UsrRetName(CA097USER)
	
	_cDocSCR := SCR->CR_NUM
	_cTpDoc  := SCR->CR_TIPO
	
	nReg     := SCR->(Recno())
	SCR->(dbClearFilter())
	SCR->(dbGoTo(nReg))
	
	SCR->(dbSetOrder(1))
	If SCR->(dbseek(xFilial("SCR")+ _cTpDoc + _cDocSCR))
		
		SEA->(dbSetOrder(2))
		If SEA->(dbSeek(xFilial("SEA")+ Left(_cDocSCR,6) + "P"))
			
			_cNumBor  := SEA->EA_NUMBOR
			_lPrim    := .F.
			
			While SEA->(!Eof()) .And. _cNumBor == SEA->EA_NUMBOR //.And. !_lPrim
				
				SEA->(RecLock("SEA",.F.))
				If Empty(SEA->EA_YLIB01)
					SEA->EA_YLIB01 := _cNomeUsr
					_lPrim         := .T.
				Else
					SEA->EA_YLIB02 := _cNomeUsr
				Endif
				
				SEA->(MsUnlock())
				
				SEA->(dbSkip())
			EndDo
			
			If _lPrim
				
				ZAH->(dbSetOrder(1))
				If ZAH->(dbSeek(xFilial("ZAH")+ SCR->CR_TIPO + SCR->CR_NUM  ))
					_cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
					_cCrTipo  := SCR->CR_TIPO
					_cDocSCR  := SCR->CR_NUM
					
					_cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' AND ZAH_USER = '"+CA097USER+"' "
					
					TcSqlExec(_cCq)
				Endif
				
				SCR->(dbSetOrder(2))
				If SCR->(dbSeek(xFilial("SCR") + _cTpDoc + _cDocSCR + CA097USER))
					SCR->(Reclock("SCR",.F.))
					SCR->CR_STATUS	:= "03"
					SCR->CR_DATALIB	:= Date()
					SCR->CR_USERLIB	:= SAK->AK_USER
					SCR->CR_LIBAPRO	:= SAK->AK_COD
					SCR->CR_APROV	:= _cAprovador
					SCR->CR_VALLIB	:= SCR->CR_TOTAL
					SCR->CR_TIPOLIM	:= SAK->AK_TIPO
					SCR->(MsUnlock())
				Endif
			Else
				_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM
				
				ZAH->(dbSetOrder(1))
				If ZAH->(dbSeek(xFilial("ZAH")+ SCR->CR_TIPO + SCR->CR_NUM  ))
					_cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
					_cCrTipo  := SCR->CR_TIPO
					_cDocSCR  := SCR->CR_NUM
					
					_cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "
					
					TcSqlExec(_cCq)
				Endif
				
				While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM
					
					If SCR->CR_STATUS == "03"
						SCR->(dbSkip())
						Loop
					Endif
					
					SCR->(Reclock("SCR",.F.))
					SCR->CR_STATUS	:= "03"
					SCR->CR_DATALIB	:= Date()
					SCR->CR_USERLIB	:= SAK->AK_USER
					SCR->CR_LIBAPRO	:= SAK->AK_COD
					SCR->CR_APROV	:= _cAprovador
					SCR->CR_VALLIB	:= SCR->CR_TOTAL
					SCR->CR_TIPOLIM	:= SAK->AK_TIPO
					SCR->(MsUnlock())
					
					SCR->(dbSkip())
				EndDo
			Endif
		Endif
	Endif
	
	dbSelectArea("SCR")
	dbSetOrder(1)
	
	If !_lPortal
		SCR->(Eval(bFilSCRBrw))
	Endif
ElseIf SCR->CR_TIPO == "07"  // PEDIDO DE VENDA
	_cDocSCR := SCR->CR_NUM
	_cCliente:= SCR->CR_YCLIENT
	_cLoja   := SCR->CR_YLOJA
	_cTpDoc  := SCR->CR_TIPO
	
	nReg     := SCR->(Recno())
	SCR->(dbClearFilter())
	SCR->(dbGoTo(nReg))
	
	SCR->(dbSetOrder(1))
	If SCR->(dbseek(xFilial("SCR")+ _cTpDoc + _cDocSCR))
		
		SZ1->(dbSetOrder(1))
		If SZ1->(dbSeek(SCR->CR_MSFIL + Left(SCR->CR_NUM,6)))
			
			SZ1->(Reclock("SZ1",.F.))
			SZ1->Z1_LIBER := "S"
			//SZ1->Z1_NLIB  := Subs(alltrim(cusuario),7,15)
			SZ1->Z1_NLIB  := cUsername
			SZ1->Z1_HLIB  := Left(time(),5)
			SZ1->Z1_YDTLIB:= If(SZ1->Z1_YDTLIB < dDataBase,dDataBase,SZ1->Z1_YDTLIB)
			SZ1->(MsUnlock())
		Endif
		
		_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM
		
		ZAH->(dbSetOrder(1))
		If ZAH->(dbSeek(xFilial("ZAH")+ SCR->CR_TIPO + SCR->CR_NUM  ))
			_cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
			_cCrTipo  := SCR->CR_TIPO
			_cDocSCR  := SCR->CR_NUM
			
			_cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "
			TcSqlExec(_cCq)
		Endif
		
		While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM
			
			SCR->(Reclock("SCR",.F.))
			SCR->CR_STATUS	:= "03"
			SCR->CR_DATALIB	:= Date()
			SCR->CR_USERLIB	:= SAK->AK_USER
			SCR->CR_LIBAPRO	:= SAK->AK_COD
			SCR->CR_APROV	:= _cAprovador
			SCR->CR_VALLIB	:= SCR->CR_TOTAL
			SCR->CR_TIPOLIM	:= SAK->AK_TIPO
			SCR->(MsUnlock())
			
			SCR->(dbSkip())
		EndDo
	Endif
	
	dbSelectArea("SCR")
	dbSetOrder(1)
	
	If !_lPortal
		SCR->(Eval(bFilSCRBrw))
	Endif
ElseIf SCR->CR_TIPO == "08"  // DESCONTO CONTAS A RECEBER
	_cDocSCR := SCR->CR_NUM
	_cCliente:= SCR->CR_YCLIENT
	_cLoja   := SCR->CR_YLOJA
	_cTpDoc  := SCR->CR_TIPO
	
	nReg     := SCR->(Recno())
	SCR->(dbClearFilter())
	SCR->(dbGoTo(nReg))
	
	SCR->(dbSetOrder(1))
	If SCR->(dbseek(xFilial("SCR")+ _cTpDoc + _cDocSCR))
		
		SZ1->(dbSetOrder(1))
		If SZ1->(dbSeek(SCR->CR_MSFIL + Left(SCR->CR_NUM,6)))
			
			SZ1->(Reclock("SZ1",.F.))
			SZ1->Z1_LIBER := "S"
			//SZ1->Z1_NLIB  := Subs(alltrim(cusuario),7,15)
			SZ1->Z1_NLIB  := cUsername
			SZ1->Z1_HLIB  := Left(time(),5)
			SZ1->Z1_YDTLIB:= If(SZ1->Z1_YDTLIB < dDataBase,dDataBase,SZ1->Z1_YDTLIB)
			SZ1->(MsUnlock())
		Endif
		
		_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM
		
		ZAH->(dbSetOrder(1))
		If ZAH->(dbSeek(xFilial("ZAH")+ SCR->CR_TIPO + SCR->CR_NUM  ))
			_cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
			_cCrTipo  := SCR->CR_TIPO
			_cDocSCR  := SCR->CR_NUM
			
			_cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "
			
			TcSqlExec(_cCq)
		Endif
		
		While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM
			
			SCR->(Reclock("SCR",.F.))
			SCR->CR_STATUS	:= "03"
			SCR->CR_DATALIB	:= Date()
			SCR->CR_USERLIB	:= SAK->AK_USER
			SCR->CR_LIBAPRO	:= SAK->AK_COD
			SCR->CR_APROV	:= _cAprovador
			SCR->CR_VALLIB	:= SCR->CR_TOTAL
			SCR->CR_TIPOLIM	:= SAK->AK_TIPO
			SCR->(MsUnlock())
			
			SCR->(dbSkip())
		EndDo
	Endif
	
	dbSelectArea("SCR")
	dbSetOrder(1)
	
	If !_lPortal
		SCR->(Eval(bFilSCRBrw))
	Endif
Endif

Return(_aErro)


Static Function ValidPcoLan()

Local lRet	   := .T.
Local aArea    := GetArea()
Local aAreaSC7 := SC7->(GetArea())
If SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
	dbSelectArea("SC7")
	DbSetOrder(1)
	DbSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
Endif
If lRet	:=	PcoVldLan('000055','02','MATA097')
	While lRet .And. !Eof() .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM))
		lRet	:=	PcoVldLan("000055","01","MATA097")
		dbSelectArea("SC7")
		dbSkip()
	EndDo
Endif
If !lRet
	PcoFreeBlq("000055")
Endif

RestArea(aAreaSC7)
RestArea(aArea)

Return lRet


User Function VN13_01(aDocto,dDataRef,nOper,cDocSF1,lResiduo)

//Function MaAlcDoc(aDocto,dDataRef,nOper,cDocSF1,lResiduo)
                     
Local cDocto	:= aDocto[1]
Local cTipoDoc	:= aDocto[2]
Local nValDcto	:= aDocto[3]
Local cAprov	:= If(aDocto[4]==Nil,"",aDocto[4])
Local cUsuario	:= If(aDocto[5]==Nil,"",aDocto[5])
Local nMoeDcto	:= If(Len(aDocto)>7,If(aDocto[8]==Nil, 1,aDocto[8]),1)
Local nTxMoeda	:= If(Len(aDocto)>8,If(aDocto[9]==Nil, 0,aDocto[9]),0)
Local cObs      := If(Len(aDocto)>10,If(aDocto[11]==Nil, "",aDocto[11]),"")
Local aArea		:= GetArea()
Local aAreaSCS	:= SCS->(GetArea())
Local aAreaSCR	:= SCR->(GetArea())
Local aRetPe	:= {}
Local nSaldo	:= 0
Local cGrupo	:= If(aDocto[6]==Nil,"",aDocto[6])
Local lFirstNiv:= .T.
Local cAuxNivel:= ""
Local cNextNiv := ""
Local cNivIgual:= ""
Local cStatusAnt:= ""
Local cAprovOri := ""
Local cUserOri  := ""
Local lAchou	:= .F.
Local nRec		:= 0
Local lRetorno	:= .T.
Local aSaldo	:= {}
Local aMTALCGRU := {}
Local lDeletou := .F.
Local dDataLib := IIF(dDataRef==Nil,dDataBase,dDataRef)
DEFAULT dDataRef := dDataBase
DEFAULT cDocSF1 := cDocto
DEFAULT lResiduo := .F.
cDocto := cDocto+Space(Len(SCR->CR_NUM)-Len(cDocto))
cDocSF1:= cDocSF1+Space(Len(SCR->CR_NUM)-Len(cDocSF1))

If ExistBlock("MT097GRV")
	lRetorno := (Execblock("MT097GRV",.F.,.F.,{aDocto,dDataRef,nOper,cDocSF1,lResiduo}))
	If Valtype( lRetorno ) <> "L"
		lRetorno := .T.
	EndIf
Endif

If lRetorno
	
	If Empty(cUsuario) .And. (nOper != 1 .And. nOper != 6) //nao e inclusao ou estorno de liberacao
		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSeek(xFilial()+cAprov)
		cUsuario :=	AK_USER
		nMoeDcto :=	AK_MOEDA
		nTxMoeda	:=	0
	EndIf
	If nOper == 1  //Inclusao do Documento
		cGrupo := If(!Empty(aDocto[6]),aDocto[6],cGrupo)
		dbSelectArea("SAL")
		dbSetOrder(2)
		If !Empty(cGrupo) .And. dbSeek(xFilial("SAL")+cGrupo)
			While !Eof() .And. xFilial("SAL")+cGrupo == AL_FILIAL+AL_COD
				
				If cTipoDoc <> "NF"
					If SAL->AL_AUTOLIM == "S" .And. !MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda)
						dbSelectArea("SAL")
						dbSkip()
						Loop
					EndIf
				EndIf
				
				If lFirstNiv
					cAuxNivel := SAL->AL_NIVEL
					lFirstNiv := .F.
				EndIf
				
				Do Case
					Case cTipoDoc == "NF"
						SF1->(FkCommit())
					Case cTipoDoc == "PC" .Or.cTipoDoc == "AE"
						SC7->(FkCommit())
					Case cTipoDoc == "CP"
						SC3->(FkCommit())
					Case cTipoDoc == "SC"
						SC1->(FkCommit())
					Case cTipoDoc == "CO"
						SC8->(FkCommit())
					Case cTipoDoc == "MD"
						CND->(FkCommit())
				EndCase
				
				Reclock("SCR",.T.)
				SCR->CR_FILIAL	:= xFilial("SCR")
				SCR->CR_NUM		:= cDocto
				SCR->CR_TIPO	:= cTipoDoc
				SCR->CR_NIVEL	:= SAL->AL_NIVEL
				SCR->CR_USER	:= SAL->AL_USER
				SCR->CR_APROV	:= SAL->AL_APROV
				SCR->CR_STATUS	:= IIF(SAL->AL_NIVEL == cAuxNivel,"02","01")
				SCR->CR_TOTAL	:= nValDcto
				SCR->CR_EMISSAO:= aDocto[10]
				SCR->CR_MOEDA	:=	nMoeDcto
				SCR->CR_TXMOEDA:= nTxMoeda
				MsUnlock()
				dbSelectArea("SAL")
				dbSkip()
			EndDo
		EndIf
		lRetorno := lFirstNiv
	EndIf
	
	If nOper == 2  //Transferencia da Alcada para o Superior
		//dbSelectArea("SCR")
		//dbSetOrder(1)
		//dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
		// O SCR deve estar posicionado, para que seja transferido o atual para o Superior
		If !Eof() .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == xFilial("SCR")+cTipoDoc+cDocto
			// Carrega dados do Registro a ser tranferido e exclui
			cTipoDoc := SCR->CR_TIPO
			cAuxNivel:= SCR->CR_STATUS
			nValDcto := SCR->CR_TOTAL
			nMoeDcto :=	SCR->CR_MOEDA
			cNextNiv := SCR->CR_NIVEL
			nTxMoeda := SCR->CR_TXMOEDA
			dDataRef := SCR->CR_EMISSAO
			cAprovOri:= SCR->CR_APROV
			cUserOri := SCR->CR_USER
			Reclock("SCR",.F.,.T.)
			dbDelete()
			MsUnlock()
			// Inclui Registro para Aprovador Superior
			Reclock("SCR",.T.)
			SCR->CR_FILIAL	:= xFilial("SCR")
			SCR->CR_NUM		:= cDocto
			SCR->CR_TIPO	:= cTipoDoc
			SCR->CR_NIVEL	:= cNextNiv
			SCR->CR_USER	:= cUsuario
			SCR->CR_APROV	:= cAprov
			SCR->CR_STATUS	:= cAuxNivel
			SCR->CR_TOTAL	:= nValDcto
			SCR->CR_EMISSAO:= dDataRef
			SCR->CR_MOEDA	:=	nMoeDcto
			SCR->CR_TXMOEDA:= nTxMoeda
			SCR->CR_OBS 	:= cObs
			
			//Aplicar UPDCOM10 se não existir campos na base //
			If !Empty(SCR->(FieldPos("CR_APRORI"))) .And. !Empty(SCR->(FieldPos("CR_USERORI")))
				SCR->CR_APRORI  := cAprovOri
				SCR->CR_USERORI := cUserOri
			EndIf
			MsUnlock()
		EndIf
		lRetorno := .T.
	EndIf
	
	If nOper == 3  //exclusao do documento
		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSelectArea("SCR")
		dbSetOrder(1)
		dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Efetua uma nova busca caso o cDocto nao for encontrado no SCR³
		//³ pois seu conteudo em caso de NF foi alterado para chave unica³
		//³ do SF1, o cDocSF1 sera a busca alternativa com o conteudo ori³
		//³ ginal do lancamento da versao que poderia causar duplicidades³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SCR->( Eof() ) .And. cTipoDoc == "NF"
			dbSeek(xFilial("SCR")+cTipoDoc+cDocSF1)
			cDocto := cDocSF1
		EndIf
		
		While !Eof() .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == xFilial("SCR")+cTipoDoc+cDocto
			If SCR->CR_STATUS == "03"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Reposiciona o usuario aprovador.               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SAK")
				dbSeek(xFilial("SAK")+SCR->CR_LIBAPRO)
				dbSelectArea("SAL")
				dbSetOrder(3)
				dbSeek(xFilial("SAL")+cGrupo+SAK->AK_COD)
				If SAL->AL_LIBAPR == "A"
					dbSelectArea("SCS")
					dbSetOrder(2)
					If dbSeek(xFilial("SCS")+SAK->AK_COD+DTOS(MaAlcDtRef(SCR->CR_LIBAPRO,SCR->CR_DATALIB,SCR->CR_TIPOLIM)))
						RecLock("SCS",.F.)
						SCS->CS_SALDO := SCS->CS_SALDO + SCR->CR_VALLIB
						MsUnlock()
					EndIf
				EndIf
			EndIf
			Reclock("SCR",.F.,.T.)
			dbDelete()
			MsUnlock()
			dbSkip()
		EndDo
	EndIf
	
	If nOper == 4 //Aprovacao do documento
		dbSelectArea("SCS")
		dbSetOrder(2)
		aSaldo := MaSalAlc(cAprov,dDataRef,.T.)
		nSaldo 	:= aSaldo[1]
		dDataRef	:= aSaldo[3]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o saldo do aprovador.                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSeek(xFilial("SAK")+cAprov)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona a Tabela SAL pelo Aprovador de Origem caso o Documento tenha sido ³
		//| transferido por Ausência Temporária ou Transferência superior e o aprovador |
		//| de destino não fizer parte do Grupo de Aprovação.                           |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SAL")
		dbSetOrder(3)
		dbSeek(xFilial("SAL")+cGrupo+cAprov)
		If !Empty(SCR->(FieldPos("CR_USERORI"))) .And. !Empty(SCR->(FieldPos("CR_APRORI"))) .And. !Empty(SCR->CR_APRORI)
			dbSeek(xFilial("SAL")+cGrupo+SCR->CR_APRORI)
		EndIf
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Libera o pedido pelo aprovador.                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SCR")
		cAuxNivel := CR_NIVEL
		Reclock("SCR",.F.)
		dbSetOrder(1)
		CR_STATUS	:= "03"
		CR_OBS		:= If(Len(aDocto)>10,aDocto[11],"")
		CR_DATALIB	:= dDataLib
		CR_USERLIB	:= SAK->AK_USER
		CR_LIBAPRO	:= SAK->AK_COD
		CR_VALLIB	:= nValDcto
		CR_TIPOLIM	:= SAK->AK_TIPO
		MsUnlock()
		dbSeek(xFilial("SCR")+cTipoDoc+cDocto+cAuxNivel)
		nRec := RecNo()
		While !Eof() .And. xFilial("SCR")+cDocto+cTipoDoc == CR_FILIAL+CR_NUM+CR_TIPO
			
			If cAuxNivel == CR_NIVEL .And. CR_STATUS != "03" .And. SAL->AL_TPLIBER$"U "
				Exit
			EndIf
			
			If cAuxNivel == CR_NIVEL .And. CR_STATUS != "03" .And. SAL->AL_TPLIBER$"NP"
				Reclock("SCR",.F.)
				CR_STATUS	:= "05"
				CR_DATALIB	:= dDataLib
				CR_USERLIB	:= SAK->AK_USER
				CR_APROV	   := cAprov
				CR_OBS		:= ""
				MsUnlock()
			EndIf
			
			If CR_NIVEL > cAuxNivel .And. CR_STATUS != "03" .And. !lAchou
				lAchou := .T.
				cNextNiv := CR_NIVEL
			EndIf
			
			If lAchou .And. CR_NIVEL == cNextNiv .And. CR_STATUS != "03"
				Reclock("SCR",.F.)
				CR_STATUS := If(SAL->AL_TPLIBER=="P","05",If(( Empty(cNivIgual) .Or. cNivIgual == CR_NIVEL ) .And. cStatusAnt <> "01" ,"02",CR_STATUS))
				
				If CR_STATUS == "05"
					CR_DATALIB	:= dDataLib
				EndIf
				MsUnlock()
				cNivIgual := CR_NIVEL
				lAchou    := .F.
			Endif
			
			cStatusAnt := SCR->CR_STATUS
			
			dbSkip()
		EndDo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Reposiciona e verifica se ja esta totalmente liberado.       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbGoto(nRec)
		While !Eof() .And. xFilial("SCR")+cTipoDoc+cDocto == CR_FILIAL+CR_TIPO+CR_NUM
			If CR_STATUS != "03" .And. CR_STATUS != "05"
				lRetorno := .F.
			EndIf
			dbSkip()
		EndDo
		If SAL->AL_LIBAPR == "A"
			dbSelectArea("SCS")
			If dbSeek(xFilial()+cAprov+dToS(dDataRef))
				Reclock("SCS",.F.)
			Else
				Reclock("SCS",.T.)
			EndIf
			CS_FILIAL := xFilial("SCS")
			CS_SALDO  := CS_SALDO - nValDcto
			CS_APROV  := cAprov
			CS_USER	 := cUsuario
			CS_MOEDA  := nMoeDcto
			CS_DATA	 := dDataRef
			MsUnlock()
		EndIf
	EndIf
	
	If nOper == 5  //Estorno da Aprovacao
		cGrupo := If(!Empty(aDocto[6]),aDocto[6],cGrupo)
		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSelectArea("SCR")
		dbSetOrder(1)
		dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
		nMoeDcto := SCR->CR_MOEDA
		nTxMoeda := SCR->CR_TXMOEDA
		While !Eof() .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == xFilial("SCR")+cTipoDoc+cDocto
			If SCR->CR_STATUS == "03"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Reposiciona o usuario aprovador.               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SAK")
				dbSeek(xFilial("SAK")+SCR->CR_LIBAPRO)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona a Tabela SAL pelo Aprovador de Origem caso o Documento tenha sido ³
				//| transferido por Ausência Temporária ou Transferência superior e o aprovador |
				//| de destino não fizer parte do Grupo de Aprovação.                           |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SAL")
				dbSetOrder(3)
				dbSeek(xFilial("SAL")+cGrupo+SAK->AK_COD)
				If Eof()
					If !Empty(SCR->(FieldPos("CR_USERORI")))
						dbSeek(xFilial("SAL")+cGrupo+SCR->CR_APRORI)
					EndIf
				EndIf
				
				If SAL->AL_LIBAPR == "A"
					dbSelectArea("SCS")
					dbSetOrder(2)
					If dbSeek(xFilial("SCS")+SAK->AK_COD+DTOS(MaAlcDtRef(SAK->AK_COD,SCR->CR_DATALIB)))
						RecLock("SCS",.F.)
						SCS->CS_SALDO := SCS->CS_SALDO + If(nValDcto>0 .And. nValDcto < SCR->CR_VALLIB,nValDcto,SCR->CR_VALLIB)
						If SCS->CS_SALDO > SAK->AK_LIMITE
							SCS->CS_SALDO := SAK->AK_LIMITE
						EndIf
						MsUnlock()
					EndIf
				EndIf
			EndIf
			Reclock("SCR",.F.,.T.)
			If nValDcto > 0 .And. nValDcto < SCR->CR_TOTAL
				SCR->CR_TOTAL	:= SCR->CR_TOTAL - nValDcto
				SCR->CR_VALLIB	:= SCR->CR_VALLIB - nValDcto
			Else
				If lResiduo
					lDeletou := IF(SCR->CR_TOTAL - nValDcto > 0,.T.,.F.)
				Else
					lDeletou := .T.
				EndIf
				dbDelete()
			EndIf
			MsUnlock()
			dbSkip()
		EndDo
		
		dbSelectArea("SAL")
		dbSetOrder(2)
		If	(!Empty(cGrupo) .And. dbSeek(xFilial("SAL")+cGrupo) .And. nValDcto > 0 .And. lDeletou) .Or. ;
			(!Empty(cGrupo) .And. dbSeek(xFilial("SAL")+cGrupo) .And. cTipoDoc == "NF" .And. lDeletou)
			
			While !Eof() .And. xFilial("SAL")+cGrupo == AL_FILIAL+AL_COD
				
				If cTipoDoc <> "NF"
					If SAL->AL_AUTOLIM == "S" .And. !MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda)
						dbSelectArea("SAL")
						dbSkip()
						Loop
					EndIf
				EndIf
				
				If lFirstNiv
					cAuxNivel := SAL->AL_NIVEL
					lFirstNiv := .F.
				EndIf
				Reclock("SCR",.T.)
				SCR->CR_FILIAL	:= xFilial("SCR")
				SCR->CR_NUM		:= cDocto
				SCR->CR_TIPO	:= cTipoDoc
				SCR->CR_NIVEL	:= SAL->AL_NIVEL
				SCR->CR_USER	:= SAL->AL_USER
				SCR->CR_APROV	:= SAL->AL_APROV
				SCR->CR_STATUS	:= IIF(SAL->AL_NIVEL == cAuxNivel,"02","01")
				SCR->CR_TOTAL	:= nValDcto
				SCR->CR_EMISSAO:= dDataRef
				SCR->CR_MOEDA	:=	nMoeDcto
				SCR->CR_TXMOEDA:= nTxMoeda
				MsUnlock()
				dbSelectArea("SAL")
				dbSkip()
			EndDo
		EndIf
		lRetorno := lFirstNiv
	EndIf
	
	If nOper == 6  //Bloqueio manual
		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSeek(xFilial("SAK")+cAprov)
		
		Reclock("SCR",.F.)
		CR_STATUS   := "04"
		CR_OBS	    := If(Len(aDocto)>10,aDocto[11],"")
		CR_DATALIB  := dDataRef
		CR_USERLIB	:= SAK->AK_USER
		CR_LIBAPRO	:= SAK->AK_COD
		cAuxNivel   := CR_NIVEL
		MsUnlock()
		lRetorno 	:= .F.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Bloqueia todos os Aprovadores do Nível  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		dbSeek(xFilial("SCR")+cTipoDoc+cDocto+cAuxNivel)
		nRec := RecNo()
		While !Eof() .And. xFilial("SCR")+cDocto+cTipoDoc+cAuxNivel == CR_FILIAL+CR_NUM+CR_TIPO+CR_NIVEL
			If CR_STATUS != "04"
				Reclock("SCR",.F.)
				CR_STATUS	:= "05"
				CR_OBS	   := "Bloqueio "+SAK->AK_COD
				CR_DATALIB	:= dDataRef
				CR_USERLIB	:= SAK->AK_USER
				CR_LIBAPRO	:= SAK->AK_COD
				MsUnlock()
			EndIf
			
			dbSkip()
		EndDo
	EndIf
	
	If ExistBlock("MTALCDOC")
		Execblock("MTALCDOC",.F.,.F.,{aDocto,dDataRef,nOper})
	Endif
EndIf

dbSelectArea("SCR")
RestArea(aAreaSCR)
dbSelectArea("SCS")
RestArea(aAreaSCS)
RestArea(aArea)

Return(lRetorno)

Return