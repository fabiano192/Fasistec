#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PXH006 ³ Autor ³ Alexandro Silva         ³ Data ³06/12/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ MANUTENÇAO REGRAS DE CONTABILIZACAO                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PXH006                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CONTABILIDADE                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PXH006()

Private	oNATUREZ, _cNATUREZ, oDESVER ,_cDESVER
PRIVATE aIndexSX5	:= {}
PRIVATE bFilSX5Brw := {|| Nil}
PRIVATE cXFiltraSX5


PRIVATE aRotina	:= {{OemToAnsi("Pesquisar") ,"AxPesqui()", 0 , 1, 0, .F.},;
{OemToAnsi("Visualizar")     ,"U_PX06_01",  0 , 2, 0, nil},;
{OemToAnsi("Incluir")        ,"U_PX06_01",  0 , 3, 0, nil},;
{OemToAnsi("Alterar")        ,"U_PX06_01",  0 , 4, 0, nil},;
{OemToAnsi("Excluir")        ,"U_PX06_01",  0 , 5, 0, nil}}

PRIVATE cCadastro := OemToAnsi("Entidade X Conta Contabil")
             
MBROWSE( 6, 1,22,75,"SZ6")


Return Nil



User Function PX06_01(cAlias,nReg,_nOpcx)

Private VISUAL  := (_nOpcX == 2)
Private INCLUI  := (_nOpcX == 3)
Private ALTERA  := (_nOpcX == 4)
Private EXCLUI  := (_nOpcX == 5)
Private   Acols	:= {}
Private aHeader := {}
Private _nOpcao := _nOpcX

_nOpcE          := _nOpcX
_nOpcG          := _nOpcX
_aCampos        := {"Z2_GREMP","Z2_EMPRESA","Z2_CONTA"}

For AX:= 1 TO Len(_aCampos)
	dbSelectArea("Sx3")
	dbSetOrder(2)
	If dbSeek(_aCampos[AX])
		AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,x3_valid,;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
	Endif
Next Ax

Private _nPGREMP  := aScan( aHeader, { |x| Alltrim(x[2])== "Z2_GREMP" } )
Private _nPEMPRESA:= aScan( aHeader, { |x| Alltrim(x[2])== "Z2_EMPRESA" } )
Private _nPCONTA  := aScan( aHeader, { |x| Alltrim(x[2])== "Z2_CONTA"   } )

aCols   := {}
_lEdit  := .F.

If INCLUI
	_lEdit  := .F.

	SZ2->(dbSetOrder(1))
	If SZ2->(dbSeek(xFilial("SZ2") + SZ6->Z6_CODIGO ))
	    MSGINFO("ENTIDADE JA CADASTRADA, FAVOR ESCOLHER A OPCAO 'ALTERAR' !!")
	    Return                    
	Endif
	
	aCols:={Array(Len(_aCampos)+1)}
	aCols[1,Len(_aCampos)+1]:=.F.
	For _ni:=1 to Len(_aCampos)
		aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
	Next
	
	_cTIPO    := SZ6->Z6_CODIGO
	_cDESVER  := SZ6->Z6_DESCRIC
Else
	SZ2->(dbSetOrder(1))
	If SZ2->(dbSeek(xFilial("SZ2") + SZ6->Z6_CODIGO ))

		_cTipo    := SZ2->Z2_TIPO
		_cDESVER  := SZ2->Z2_DESC
			
		_cChavSZ2 := SZ2->Z2_TIPO    
		
		While SZ2->(!Eof()) .And. _cChavSZ2 == SZ2->Z2_TIPO    
			
			AADD(aCols,Array(Len(_aCampos)+1))
			
			aCols[Len(aCols),_NPGREMP]       := SZ2->Z2_GREMP
			aCols[Len(aCols),_NPEMPRESA]     := SZ2->Z2_EMPRESA
			aCols[Len(aCols),_NPCONTA]       := SZ2->Z2_CONTA
			aCols[Len(aCols),Len(_aCampos)+1]:= .F.
			
			SZ2->(dbSkip())
		EndDo
	Else
		Return		
	Endif
Endif

cTitulo       := "RELACIONAMENTO ENTIDADE X CONTA CONTABIL"
cAliasGetD    := "SZ2"
cLinOk        := "AllwaysTrue()"
cTudOk        := "AllwaysTrue()"
cFieldOk      := "AllwaysTrue()"

_lRetMod2     := PX06_02(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)

If _lRetMod2 .And. !VISUAL
	PX06_07()
Endif

Return

Static Function PX06_02(cTitulo,cAlias2,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)

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

@ 1.5,002 Say "Tipo: "
@ 1.5,006 MSGET oTipo    VAR _cTipo     when _lEdit  F3 "SZ6" VALID (ExistCpo("SZ6",_cTIPO) .And. ExistChav("SZ2",_cTIPO) .And. PX06_03()) PICTURE "@!" SIZE 40,10

@ 1.5,012 Say "Descrição: "
@ 1.5,016 MSGET oDESVER  VAR _cDESVER When .f. PICTURE "@!" SIZE 150,10

nGetLin   := aPosObj[3,1]
oGetDados := MsGetDados():New(aPosObj[2,1]+10,aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],_nOpcao,"U_PX06_05()","PX06_06",,.T.)

ACTIVATE MSDIALOG oDlg centered ON INIT EnchoiceBar(oDlg,{||_nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),_nOpca := 0,oDlg:End()),_nOpca := 0)},{||oDlg:End()},,aButtons)

_lRet := (_nOpca==1)

Return(_lRet)


Return


Static Function PX06_03()

If Empty(_cTIPO)
	MsgAlert("TIPO EM BRANCO!!")
	Return(.F.)
Endif

SZ6->(dbSetOrder(1))
SZ6->(dbSeek(xFilial("SZ6")+_cTipo))

_cDESVER := SZ6->Z6_DESCRIC

Return(.T.)



User Function PX06_04(_cDC)

_aAliOri := GetArea()
_aAliCT1 := CT1->(GetArea())
_lRet    := .F.

_cCtaDeb := M->Z2_CONTA

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


User Function PX06_05()

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


Static Function PX06_06()

Private _lRetorno := .t.

Return(_lRetorno)



Static Function PX06_07()

If ALTERA .Or. EXCLUI
	SZ2->(dbSetOrder(1))
	If SZ2->(dbSeek(xFilial("SZ2")+_cTIPO))
		
		While SZ2->(!Eof()) .And. SZ2->Z2_TIPO    == _cTIPO   
			
			SZ2->(RecLock("SZ2",.F.))
			SZ2->(dbDelete())
			SZ2->(MsUnlock())
			
			SZ2->(dbSkip())
		EndDo
	Endif
Endif

If !EXCLUI
	For AX:= 1 To Len(ACOLS)
		
		_cFim := (Len(aHeader)+1)
		If !aCols[AX,_cFim]
			SZ2->(RecLock("SZ2",.T.))
			SZ2->Z2_FILIAL  := xFilial("SZ2")
			SZ2->Z2_TIPO    := _cTIPO
			SZ2->Z2_DESC    := _cDESVER
			SZ2->Z2_GREMP   := ACOLS[AX,_NPGREMP]
			SZ2->Z2_EMPRESA := ACOLS[AX,_NPEMPRESA]
			SZ2->Z2_CONTA   := ACOLS[AX,_NPCONTA]
			SZ2->(MsUnlock())
		Endif
	Next Ax
Endif

Return

User Function PX06_10()

_aAliORI := GetArea()
_aAliSM0 := SM0->(GetArea())

_lRet10 := .T.

SM0->(dbSetOrder(1))
If SM0->(!dbSeek(ACOLS[N,_NPGREMP]+M->Z2_EMPRESA))
	//_cEmp := Space(03)
	_lRet10 := .F.
Endif

RestArea(_aAliSM0)
RestArea(_aAliORI)

Return(_lRet10)


User Function PX06_11()

_aAliORI := GetArea()

_cGrEmp11 := ACOLS[N,_NPGREMP]

ACOLS[N,_NPEMPRESA] := Space(03)
ACOLS[N,_NPCONTA]   := Space(20)

RestArea(_aAliORI)


Return(_cGrEmp11)