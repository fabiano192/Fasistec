#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VN0009   ³ Autor ³ Alexandro Silva       ³ Data ³05/05/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ MANUTENÇAO REGRAS DE CONTABILIZACAO                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FATURAMENTO                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VN0009()

Private	oTes, _cTes, oDescTes,_cDescTes

PRIVATE aRotina	:= {{OemToAnsi("Pesquisar") ,"AxPesqui()", 0 , 1, 0, .F.},;
{OemToAnsi("Visualizar"),"U_VN009_01",  0 , 2, 0, nil},;
{OemToAnsi("Incluir")   ,"U_VN009_01",  0 , 3, 0, nil},;
{OemToAnsi("Alterar")   ,"U_VN009_01",  0 , 4, 0, nil},;
{OemToAnsi("Excluir")   ,"U_VN009_01",  0 , 5, 0, nil},;
{OemToAnsi("Copiar")    ,"U_VN009_01",  0 , 6, 0, nil}}


PRIVATE cCadastro := OemToAnsi("Tabela de Frete")

MBrowse( 6, 1,22,75,"SZL",,,,,,,,,,,,,,NIL)

Return Nil



User Function VN009_01(cAlias,nReg,_nOpcx)

Private VISUAL := (_nOpcX == 2)
Private INCLUI := (_nOpcX == 3)
Private ALTERA := (_nOpcX == 4)
Private EXCLUI := (_nOpcX == 5)
Private COPIA  := (_nOpcX == 6)

Private   Acols	:={}

Private aHeader := {}
Private _nOpcao := _nOpcX

_nOpcE := _nOpcX
_nOpcG := _nOpcX

_aCampos := {"ZL_ITEM","ZL_TRANSP","ZL_TES","ZL_VALFRET","ZL_PEDAGIO"}

For AX:= 1 TO Len(_aCampos)
	dbSelectArea("Sx3")
	dbSetOrder(2)
	If dbSeek(_aCampos[AX])
		AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,x3_valid,;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
	Endif
Next Ax

Private _nPITEM    := aScan( aHeader, { |x| Alltrim(x[2])== "ZL_ITEM"     } )
Private _nPTRANSP  := aScan( aHeader, { |x| Alltrim(x[2])== "ZL_TRANSP"   } ) 
Private _nPTES     := aScan( aHeader, { |x| Alltrim(x[2])== "ZL_TES"      } )
Private _nPFRETE   := aScan( aHeader, { |x| Alltrim(x[2])== "ZL_VALFRET"  } )
Private _nPPEDAG   := aScan( aHeader, { |x| Alltrim(x[2])== "ZL_PEDAGIO"  } )

aCols   := {}
_lEdit  := .F.

If INCLUI
              
	_lEdit  := .t.
	aCols:={Array(Len(_aCampos)+1)}
	aCols[1,Len(_aCampos)+1]:=.F.
	For _ni:=1 to Len(_aCampos)
		If aHeader[_ni,2] = "ZL_ITEM"
			aCols[1,_ni]:= "0001"
		Else
			aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
		Endif
	Next
	
	_cCLIENTE := Space(06)
	_cLOJA    := Space(02)
	_cNOME    := Space(40)
Else
	_cCLIENTE := SZL->ZL_CLIENTE
	_cLOJA    := SZL->ZL_LOJA
	
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+ _cCliente + _cLoja ))

	_cNOME    := SA1->A1_NOME
	
	SZL->(dbSetOrder(1))
	If SZL->(dbSeek(xFilial("SZL") + _cCliente + _cLoja))
		
		_cChavSZL := SZL->ZL_CLIENTE + SZL->ZL_LOJA
		
		While SZL->(!Eof()) .And. _cChavSZL == SZL->ZL_CLIENTE + SZL->ZL_LOJA
			
			AADD(aCols,Array(Len(_aCampos)+1))
			
			aCols[Len(aCols),_NPITEM]    := SZL->ZL_ITEM
			aCols[Len(aCols),_NPTRANSP]  := SZL->ZL_TRANSP
			aCols[Len(aCols),_NPTES]     := SZL->ZL_TES			
			aCols[Len(aCols),_NPFRETE]   := SZL->ZL_VALFRET
			aCols[Len(aCols),_NPPEDAG]   := SZL->ZL_PEDAGIO 
			
			aCols[Len(aCols),Len(_aCampos)+1]:=.F.
			
			SZL->(dbSkip())
		EndDo
	Endif
	
	If COPIA
		_cCLIENTE := Space(06)
		_cLOJA    := Space(02)
		_cNOME    := Space(40)
	Endif
Endif

cTitulo       := "Tabela de Frete"
cAliasGetD    := "SZL"
cLinOk        := "AllwaysTrue()"
cTudOk        := "AllwaysTrue()"
cFieldOk      := "AllwaysTrue()"

_lRetMod2     := VN009_02(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)

If _lRetMod2 .And. !VISUAL
	VN009_07()
Endif

Return

Static Function VN009_02(cTitulo,cAlias2,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)

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

@ 1.0,002 Say "Cliente: "
@ 1.0,005 MSGET oCliente VAR _cCLIENTE  when _lEdit  F3 "SA1" VALID (ExistCpo("SA1",_cCLIENTE) .And. VN009_03()) PICTURE "@!" SIZE 30,10

@ 1.0,010 Say "Loja: "
@ 1.0,014 MSGET oLoja    VAR _cLOJA     when _lEdit  F3 "SA1" VALID (ExistCpo("SA1",_cCLIENTE + _cLOJA)  .And. ExistChav("SZL",_cCliente + _CLOJA) .And. VN009_03()) PICTURE "@!" SIZE 30,10

@ 1.0,020 Say "Nome Cliente: "
@ 1.0,025 MSGET oNome    VAR _cNOME     When .f. PICTURE "@!" SIZE 150,10

nGetLin := aPosObj[3,1]

oGetDados := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],_nOpcao,"U_VN009_05()","VN009_06","+ZL_ITEM",.T.)

ACTIVATE MSDIALOG oDlg centered ON INIT EnchoiceBar(oDlg,{||_nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),_nOpca := 0,oDlg:End()),_nOpca := 0)},{||oDlg:End()},,aButtons)

_lRet := (_nOpca==1)

Return(_lRet)


Return


Static Function VN009_03()

If Empty(_cCLIENTE)
	MsgAlert("Cliente em Branco!!")
	Return(.F.)
Endif                 

SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1") + _cCLIENTE + Alltrim(_cLOJA)))

_cNOME := SA1->A1_NOME

Return(.T.)


User Function VN009_05()

_aVerDup  := {}
lOk       := .T.

For AX := 1 to Len(aCols)
	
	_cFim := (Len(aHeader)+1)
	If !aCols[AX,_cFim]
		_cTransp:= aCols[AX,_nPTRANSP]
		
		If ASCAN( _aVerDup,{|x| x[1]  == _cTransp }) == 0
			AADD( _aVerDup,{_cTransp})
		Else
			MSGSTOP(" Dados Ja lançado!!!")
			lOK := .F.
		Endif
	Endif
Next

Return(lOk)


Static Function VN009_06()

Private _lRetorno := .t.

Return(_lRetorno)



Static Function VN009_07()

If ALTERA .Or. EXCLUI
	SZL->(dbSetOrder(1))
	If SZL->(dbSeek(xFilial("SZL") + _cCliente + _cLoja))
		
		While SZL->(!Eof()) .And. SZL->ZL_CLIENTE + SZL->ZL_LOJA == _cCLIENTE + _cLOJA
					
			SZL->(RecLock("SZL",.F.))
			SZL->(dbDelete())
			SZL->(MsUnlock())
			
			SZL->(dbSkip())
		EndDo
	Endif
Endif

If !EXCLUI
	For AX:= 1 To Len(ACOLS)
		
		_cFim := (Len(aHeader)+1)
		If !aCols[AX,_cFim]
			SZL->(RecLock("SZL",.T.))
			SZL->ZL_FILIAL  := xFilial("SZL")
			SZL->ZL_CLIENTE := _cCLIENTE
			SZL->ZL_LOJA    := _cLOJA   
			SZL->ZL_ITEM    := ACOLS[AX,_NPITEM]
			SZL->ZL_TRANSP  := ACOLS[AX,_NPTRANSP] 
			SZL->ZL_TES     := ACOLS[AX,_NPTES]			
			SZL->ZL_VALFRET := ACOLS[AX,_NPFRETE]          
			SZL->ZL_PEDAGIO := ACOLS[AX,_NPPEDAG]
			SZL->(MsUnlock())
		Endif
	Next Ax
Endif

Return