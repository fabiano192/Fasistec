#Include "Protheus.ch"
#include "rwmake.ch"
#INCLUDE 'COLORS.CH'
#Include "TOPCONN.CH"
#XCommand ROLLBACK TRANSACTION => DisarmTransaction()

/*
Programa	: VN0004
Autor		: 
Data		:
Descrição	: Cupom de Pesagem (Entrada)
*/

User Function VN0004()

	Local cAlias := "SZH"

	Private cCadastro := "Cupom de Pesagem"
	Private aCores  := {}
	Private aRotina := {}
	Private aFixe	:= {}
	Private aAcho	:= {}
	Private aCpos	:= {}

	AADD(aRotina,{"Pesquisar"     ,"AxPesqui",0,1})
	AADD(aRotina,{"Visualizar"    ,"U_VN004Vis",0,2})
	AADD(aRotina,{"Incluir"       ,"U_VN004Inc",0,3})
	AADD(aRotina,{"Alterar"       ,"U_VN004Alt",0,4})
	AADD(aRotina,{"Legenda"       ,"U_VN004Leg",0,6})
	AADD(aRotina,{"Imprimir Tickt","U_VN000204",0,7})

	AADD(aCores,{'if(sZH->ZH_pesini<=0,.t.,.f.)',"BR_VERDE" })
	AADD(aCores,{'if(sZH->ZH_pesini>0.and.sZH->ZH_pesfin<=0,.t.,.f.)' ,"BR_AMARELO" })
	AADD(aCores,{'if(sZH->ZH_pesliq>0,.t.,.f.)',"BR_VERMELHO" })

	dbSelectArea(cAlias)
	dbSetOrder(1)

	mBrowse(6,1,22,75,cAlias,/*Fixe*/,,,,,aCores)

Return Nil




//** Inclui **//
User Function VN004Inc(cAlias, nReg, nOpc)

	Local nOpcao := 0
	Local aButtons := {}

	AADD( aButtons, {"CARGA", {|| U_VN000201('2', 'D')    },"Peso inicial"} )

	nOpcao := AxInclui(cAlias,nReg,nOpc,aAcho,/*aCpos*/,,"u_VN004Vld()",,,aButtons) // Identifica corretamente a opção definida para o função em aRotinas com mais // do que os 5 elementos padrões.

Return Nil



User Function VN004Alt(cAlias, nReg, nOpc)

	Local nOpcao := 0
	Local aButtons := {}

	if sZH->ZH_pesliq >0
		ALERT("ALTERAÇÃO NÃO PERMITIDA: Pesagem finalizada! ")
		Return Nil
	EndIf

	AADD( aButtons, {"CARGA", {|| U_VN000203('6', 'D')    },"Peso final"} )

	nOpcao := AxAltera(cAlias,nReg,nOpc,aAcho,/*aCpos*/,,,"u_VN004Vld()",,,aButtons) // Identifica corretamente a opção definida para o função em aRotinas com mais // do que os 5 elementos padrões.

	If SZH->ZH_PESFIN > 0
		U_VN0003(SZH->ZH_NUM ,'SZH')
	Endif

Return Nil


//** Inclui **//
User Function VN004Vis(cAlias, nReg, nOpc)
	Local nOpcao := 0

	nOpcao := AxVisual(cAlias,nReg,nOpc,aAcho,/*aCpos*/,,) // Identifica corretamente a opção definida para o função em aRotinas com mais // do que os 5 elementos padrões.
Return Nil


User Function VN004Vld()

	Local lRes := .T.

Return(lRes)



/** BOTAO LEGENDA - MOSTRA AS CORES **/
/*
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//

#define CLR_BLACK             0               // RGB(   0,   0,   0 )
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 )
#define CLR_GREEN         32768               // RGB(   0, 128,   0 )
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 )
#define CLR_RED             128               // RGB( 128,   0,   0 )
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 )
#define CLR_BROWN         32896               // RGB( 128, 128,   0 )
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 )
#define CLR_LIGHTGRAY
*/
User Function VN004Leg()

	/*
	Brwlegenda(cCadastro, "Legenda",{{"BR_BRANCO"  ,"Não Agenciado"},;
	{"BR_LARANJA" ,"Agenciado - Programado"},;
	{"BR_AMARELO" ,"Agenciado - No Patio"},;
	{"BR_VERDE"   ,"Chamado"},;
	{"BR_PINK"    ,"Pesado na Entrada"},;
	{"BR_AZUL"    ,"Início Carga/Descarga"},;
	{"BR_PRETO"   ,"Fim Carga/Descarga"},;
	{"BR_VERMELHO","Em Espera"},;
	{"BR_MARROM"  ,"F a t u r a d a"}})
	*/
	Brwlegenda(cCadastro, "Legenda",{{"BR_VERDE"   ,"Sem peso"},;
	{"BR_AMARELO" ,"Pesado inicio"},;
	{"BR_VERMELHO","Finalizado"}})

Return .T.
