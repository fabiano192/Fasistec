#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PXH007 ³ Autor ³ Alexandro Silva         ³ Data ³06/12/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ MANUTENÇAO REGRAS DE CONTABILIZACAO                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PXH006                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CONTABILIDADE                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PXH007()

Private	oNATUREZ, _cNATUREZ, oDESVER ,_cDESVER

PRIVATE aRotina	:= {{OemToAnsi("Pesquisar") ,"AxPesqui()", 0 , 1, 0, .F.},;
{OemToAnsi("Visualizar")     ,"U_PX07_01",  0 , 2, 0, nil},;
{OemToAnsi("Incluir")        ,"U_PX07_01",  0 , 3, 0, nil},;
{OemToAnsi("Alterar")        ,"U_PX07_01",  0 , 4, 0, nil},;
{OemToAnsi("Excluir")        ,"U_PX07_01",  0 , 5, 0, nil}}

PRIVATE cCadastro := OemToAnsi("Produto x Conta Contabil")

MBrowse( 6, 1,22,75,"SZ3",,,,,,,,,,,,,,NIL)

Return Nil



User Function PX07_01(cAlias,nReg,_nOpcx)

Private VISUAL  := (_nOpcX == 2)
Private INCLUI  := (_nOpcX == 3)
Private ALTERA  := (_nOpcX == 4)
Private EXCLUI  := (_nOpcX == 5)
Private   Acols	:= {}
Private aHeader := {}
Private _nOpcao := _nOpcX

_nOpcE          := _nOpcX
_nOpcG          := _nOpcX
_aCampos        := {"Z3_GREMP","Z3_EMPRESA","Z3_CONTA"}

For AX:= 1 TO Len(_aCampos)
	dbSelectArea("Sx3")
	dbSetOrder(2)
	If dbSeek(_aCampos[AX])
		AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,x3_valid,;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
	Endif
Next Ax

Private _nPGREMP  := aScan( aHeader, { |x| Alltrim(x[2])== "Z3_GREMP" } )
Private _nPEMPRESA:= aScan( aHeader, { |x| Alltrim(x[2])== "Z3_EMPRESA" } )
Private _nPCONTA  := aScan( aHeader, { |x| Alltrim(x[2])== "Z3_CONTA"   } )

aCols   := {}
_lEdit  := .F.

If INCLUI
	_lEdit  := .T.
	
	aCols:={Array(Len(_aCampos)+1)}
	aCols[1,Len(_aCampos)+1]:=.F.
	For _ni:=1 to Len(_aCampos)
		aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
	Next
	
	_cPRODUTO := Space(15)
	_cDESVER  := Space(30)
Else
	_cPRODUTO := SZ3->Z3_PRODUTO
	_cDESVER  := SZ3->Z3_DESC
	
	SZ3->(dbSetOrder(2))
	If SZ3->(dbSeek(xFilial("SZ3") + _cPRODUTO ))
		
		_cChavSZ3 := SZ3->Z3_PRODUTO
		
		While SZ3->(!Eof()) .And. _cChavSZ3 == SZ3->Z3_PRODUTO
			
			AADD(aCols,Array(Len(_aCampos)+1))
			
			aCols[Len(aCols),_NPGREMP]       := SZ3->Z3_GREMP
			aCols[Len(aCols),_NPEMPRESA]     := SZ3->Z3_EMPRESA
			aCols[Len(aCols),_NPCONTA]       := SZ3->Z3_CONTA
			aCols[Len(aCols),Len(_aCampos)+1]:= .F.
			
			SZ3->(dbSkip())
		EndDo
	Endif
Endif

cTitulo       := "RELACIONAMENTO PRODUTO X CONTA CONTABIL"
cAliasGetD    := "SZ3"
cLinOk        := "AllwaysTrue()"
cTudOk        := "AllwaysTrue()"
cFieldOk      := "AllwaysTrue()"

_lRetMod2     := PX07_02(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)

If _lRetMod2 .And. !VISUAL
	PX07_07()
Endif

Return

Static Function PX07_02(cTitulo,cAlias2,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)

Local _nOpca := 0,cSaveMenuh,oDlg

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

@ 1.5,002 Say "Produto: "
@ 1.5,006 MSGET oProduto VAR _cProduto  when _lEdit  F3 "SB1" VALID (ExistCpo("SB1",_cPRODUTO) .And. ExistChav("SZ3",_cPRODUTO,2) .And. PX07_03()) PICTURE "@!" SIZE 60,10

@ 1.5,014 Say "Descrição: "
@ 1.5,018 MSGET oDESVER  VAR _cDESVER When .f. PICTURE "@!" SIZE 150,10

nGetLin   := aPosObj[3,1]
oGetDados := MsGetDados():New(aPosObj[2,1]+10,aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],_nOpcao,"U_PX07_05()","PX07_06",,.T.)

ACTIVATE MSDIALOG oDlg centered ON INIT EnchoiceBar(oDlg,{||_nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),_nOpca := 0,oDlg:End()),_nOpca := 0)},{||oDlg:End()},,aButtons)

_lRet := (_nOpca==1)

Return(_lRet)


Return


Static Function PX07_03()

If Empty(_cPRODUTO)
	MsgAlert("PRODUTO EM BRANCO!!")
	Return(.F.)
Endif

SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1") + _cPRODUTO ))

_cDESVER := SB1->B1_DESC

Return(.T.)



User Function PX07_04(_cDC)

_aAliOri := GetArea()
_aAliCT1 := CT1->(GetArea())
_lRet    := .F.

_cCtaDeb := M->Z3_CONTA

If Empty(_cCtaDeb)
	_lRet := .T.
Else
	CT1->(dbSetOrder(1))
	If CT1->(!dbSeek(xFilial("CT1")+ _cCtaDeb))
		MSGSTOP("Conta Contabil Nao Cadastrada!! "+_cCtaDeb)
		_lRet := .F.
	Else
		If CT1->CT1_CLASSE == "1"
			MSGSTOP("Favor Utilizar Conta Analitica!! "+_cCtaDeb)
			_lRet := .F.
		Else
			_lRet := .T.
		Endif
	Endif
Endif

RestArea(_aAliCT1)
RestArea(_aAliOri)

Return(_lRet)


User Function PX07_05()

_aVerDup  := {}
lOk       := .T.

If Empty(aCols[N,_NPGREMP]) .And.  Empty(aCols[N,_NPEMPRESA])
	MSGSTOP(" Empresa Em Branco!!!")
	lOK := .F.
Endif

For AX := 1 to Len(aCols)
	
	_cFim := (Len(aHeader)+1)
	If !aCols[AX,_cFim]
		_cEmp    := aCols[AX,_NPEMPRESA]
		_cGrEmp  := aCols[AX,_NPGREMP]
		_cConta  := aCols[AX,_NPCONTA]		
				
		If ASCAN( _aVerDup,{|x| x[1] + x[2]  == _cGrEmp + _cEmp }) == 0
			AADD( _aVerDup,{_cGrEmp,_cEmp })
		Else
			MSGSTOP(" Dados Ja lançado!!!")
			lOK := .F.
		Endif
	Endif
Next

Return(lOk)


Static Function PX07_06()

Private _lRetorno := .t.

Return(_lRetorno)



Static Function PX07_07()

If ALTERA .Or. EXCLUI
	SZ3->(dbSetOrder(2))
	If SZ3->(dbSeek(xFilial("SZ3")+_cPRODUTO))
		
		While SZ3->(!Eof()) .And. SZ3->Z3_PRODUTO    == _cPRODUTO
			
			SZ3->(RecLock("SZ3",.F.))
			SZ3->(dbDelete())
			SZ3->(MsUnlock())
			
			SZ3->(dbSkip())
		EndDo
	Endif
Endif

If !EXCLUI
	For AX:= 1 To Len(ACOLS)
		
		_cFim := (Len(aHeader)+1)
		If !aCols[AX,_cFim]
			SZ3->(RecLock("SZ3",.T.))
			SZ3->Z3_FILIAL  := xFilial("SZ3")
			SZ3->Z3_PRODUTO := _cPRODUTO
			SZ3->Z3_DESC    := _cDESVER
			SZ3->Z3_GREMP   := ACOLS[AX,_NPGREMP]
			SZ3->Z3_EMPRESA := ACOLS[AX,_NPEMPRESA]
			SZ3->Z3_CONTA   := ACOLS[AX,_NPCONTA]
			SZ3->(MsUnlock())
		Endif
	Next Ax
Endif

Return



User Function PX07_10()

_aAliORI := GetArea()
_aAliSM0 := SM0->(GetArea())

_lRet10 := .T.

SM0->(dbSetOrder(1))
If SM0->(!dbSeek(ACOLS[N,_NPGREMP]+M->Z3_EMPRESA))
	_lRet10 := .F.
Endif

RestArea(_aAliSM0)
RestArea(_aAliORI)

Return(_lRet10)


User Function PX07_11()

_aAliORI := GetArea()

_cGrEmp11 := ACOLS[N,_NPGREMP]

ACOLS[N,_NPEMPRESA] := Space(03)
ACOLS[N,_NPCONTA]   := Space(20)

RestArea(_aAliORI)


Return(_cGrEmp11)