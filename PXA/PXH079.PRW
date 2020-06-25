#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PXH079   ³ Autor ³ Alexandro Silva       ³ Data ³19/06/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de liberacao de Documentos                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ BRI016                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Faturamento                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PXH079()

Local cFiltraSCR
Local cFitroUs  := ""
local lFiltroUs1:=.T.
Local aCoresUsr    := {}
Local cFilQuery := ""
Local cFilQry   := ""
/*Local aCores       := { { 'CR_TIPO== "PC"', 'BR_VERMELHO' },;
{ 'CR_TIPO== "02"', 'BR_AZUL' },;
{ 'CR_TIPO== "03"', 'BR_AMARELO' },;
{ 'CR_TIPO== "04"', 'BR_VERDE'  },;
{ 'CR_TIPO== "05"', 'BR_CINZA'},;
{ 'CR_TIPO== "06"', 'BR_PINK'},;
{ 'CR_TIPO== "07"', 'BR_LARANJA'},;
{ 'CR_TIPO== "08"', 'BR_MARRON'}}
*/

//Local aCores       := {{ 'CR_TIPO== "06"', 'BR_PINK'}} 
Local aCores       := {{ 'CR_TIPO== "06" .And. EMPTY(CR_DATALIB)', 'BR_PINK'},;
							  { 'CR_TIPO== "06" .And. !EMPTY(CR_DATALIB)', 'BR_VERDE'}}

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
	_nValMin:= 0//SAK->AK_YMINCRE
	_nValMax:= 0//SAK->AK_YMAXCRE
	
	/*
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
	_cTpDoc := Alltrim(STRTRAN( SAK->AK_YTPLIB, "01", "PC" ))
	*/
	_cAprovador := SAK->AK_COD
	
	If Pergunte("MTA097",.T.)
		
		dbSelectArea("SCR")
		dbSetOrder(1)
		
		If cFiltraSCR==nil
			cFiltraSCR  := 'CR_FILIAL=="'+xFilial("SCR")+'"'+'.And.CR_USER=="'+ca097User
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
		
		cFiltraSCR += '.And.(CR_TIPO = "06" )'
		cFilQry    += "  AND (CR_TIPO = '06') "
		
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
±±³Fun‡…o    ³MZ56_01   ³ Autor ³ Edson Maricate        ³ Data ³15.10.1998³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Liberacao de Pedidos de Compra.                ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void MZ56_01(ExpC1,ExpN1,ExpN2)                            ³±±
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

User Function MZ56_01(cAlias,nReg,nOpcx)

_lParar := .T.

If SCR->CR_STATUS == "03"
	MSGINFO("DOCUMENTO JA LIBERADO!!!")
	Return
Endif

If U_MZ56_03(cAlias,nReg,nOpcx)
	
EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MZ56_02    ³ Autor ³ Edson Maricate       ³ Data ³16.11.2000³±±
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
Static Function MZ56_02()

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

User Function MZ56_04()

Local aLegeUsr   := {}
/*
Local aLegenda   := {       {"BR_VERMELHO", "Pedido de Compra"},;
{"BR_AZUL"    , "Tabela de Preço (Vendas)"},;
{"BR_AMARELO" , "Tabela de Frete (Vendas)"  },;
{"BR_VERDE"   , "Preco MP / Frete MP"},;
{"BR_CINZA"   , "Limite de Credito"},;
{"BR_PINK"    , "Bordero de Pagamento"},;
{"BR_LARANJA" , "Pedido de Venda"},;
{"BR_MARRON"  , "Desconto Contas a Receber"}}
*/

Local aLegenda   := {{"BR_PINK"    , "Bordero de Pagamento Nao Liberado"},; 
							{"BR_VERDE"   , "Bordero de Pagamento Liberado"}}

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
{OemToAnsi("Consulta Documento"),"U_MZ56_03",  0 , 2, 0, nil},;
{OemToAnsi("Liberar"),"U_MZ56_01",  0 , 4, 0, nil},;
{OemToAnsi("Legenda"),"U_MZ56_04",  0 , 2, 0, .F.}}


Return(aRotina)




User Function MZ56_03(cAlias,nReg,nOpcx)

_lParar   := .T.
_nSdoLim  := 0
_nSdoTit  := 0

If SCR->CR_TIPO == "06" // BORDERO DE PAGAMENTO
	
	Private   Acols	:={}
	Private _nOpcX := 2
	
	Private VISUAL := (_nOpcX == 2)
	
	Private aHeader := {}
	Private _nOpcao := _nOpcX
	
	_nOpcE := _nOpcX
	_nOpcG := _nOpcX
	
	_aCampos := {"EA_PREFIXO","EA_NUM","EA_PARCELA","EA_TIPO","EA_FORNECE","EA_LOJA","E2_VENCREA","A2_NOME","E2_VALOR","E2_HIST","EA_YLIB01","EA_YLIB02"}
	
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
	Private _nPLib01   := aScan( aHeader, { |x| Alltrim(x[2])== "EA_YLIB01"  } )
	Private _nPLib02   := aScan( aHeader, { |x| Alltrim(x[2])== "EA_YLIB02"  } )

	Private _nTotBor  := 0
		
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
			aCols[Len(aCols),_NPVALOR]   := SE2->E2_SALDO + SE2->E2_ACRESC
			aCols[Len(aCols),_NPHIST]    := SE2->E2_HIST
			aCols[Len(aCols),_NPLIB01]   := SEA->EA_YLIB01
			aCols[Len(aCols),_NPLIB02]   := SEA->EA_YLIB02				
			aCols[Len(aCols),Len(_aCampos)+1]:=.F.
			      
			_nTotBor  += (SE2->E2_SALDO + SE2->E2_ACRESC)
			
			SEA->(dbSkip())
		EndDo
	Endif
	
	_lEdit        := .F.
	cTitulo       := "BORDERO DE PAGAMENTO"
	cAliasGetD    := "SEA"
	cLinOk        := "AllwaysTrue()"
	cTudOk        := "AllwaysTrue()"//MZ2002()
	cFieldOk      := "AllwaysTrue()"
	
	_lRetMod2     := MZ56_06(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)
	
	If _lRetMod2 .And. nOpcx == 3
		U_MZ0062(.F.)
	Endif
Endif

Return



Static Function MZ56_06(cTitulo,cAlias2,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)

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

If SCR->CR_TIPO == "06"
	@ 1.5,002 Say "Bordero: "
	@ 1.5,005 MSGET oBordero VAR _cBordero         When .F.     PICTURE "@!" SIZE 30,10
	@ 1.5,023 Say "Total do Bordero: "
	@ 1.5,030 MSGET oTotBor  VAR _nTotBor          When .F.     PICTURE "@E 999,999,999.99" SIZE 50,10
Endif

nGetLin := aPosObj[3,1]

oGetDados   := MsGetDados():New(_nTop,aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],_nOpcao,"U_MZ61_05()","MZ61_04","+AIB_ITEM",.T.)

ACTIVATE MSDIALOG oDlg centered ON INIT EnchoiceBar(oDlg,{||_nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),_nOpca := 0,oDlg:End()),_nOpca := 0)},{||oDlg:End()},,aButtons)

_lRet := (_nOpca==1)

Return(_lRet)



User Function MZ0062(_lPortal,_cAprov,_cTipoDoc,_aDados)

Private _aErro := {}

dbSelectArea("SAK")  /// APROVADORES
dbSetOrder(1)
dbSeek(xFilial("SAK")+_cAprovador)

dbSelectArea("SCR")
cAuxNivel := SCR->CR_NIVEL

If SCR->CR_TIPO == "06"   // BORDERO DE PAGAMENTO
	
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
			
			While SEA->(!Eof()) .And. _cNumBor == SEA->EA_NUMBOR
				
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
				SCR->(dbSetOrder(2))
				If SCR->(dbSeek(xFilial("SCR") + _cTpDoc + _cDocSCR + CA097USER))
					SCR->(Reclock("SCR",.F.))
					SCR->CR_STATUS	   := "03"
					SCR->CR_DATALIB	:= Date()
					SCR->CR_USERLIB	:= SAK->AK_USER
					SCR->CR_LIBAPRO	:= SAK->AK_COD
					SCR->CR_APROV	   := _cAprovador
					SCR->CR_VALLIB	   := SCR->CR_TOTAL
					SCR->CR_TIPOLIM	:= SAK->AK_TIPO
					SCR->(MsUnlock())
				Endif
			Else
				_cChavSCR := SCR->CR_TIPO + SCR->CR_NUM
				
				While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM
					
					If SCR->CR_STATUS == "03"
						SCR->(dbSkip())
						Loop
					Endif
					
					SCR->(Reclock("SCR",.F.))
					SCR->CR_STATUS	   := "03"
					SCR->CR_DATALIB	:= Date()
					SCR->CR_USERLIB	:= SAK->AK_USER
					SCR->CR_LIBAPRO	:= SAK->AK_COD
					SCR->CR_APROV	   := _cAprovador
					SCR->CR_VALLIB	   := SCR->CR_TOTAL
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