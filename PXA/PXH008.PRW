#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PXH008   ³ Autor ³ Alexandro Silva       ³ Data ³26/09/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ MANUTENÇAO REGRAS DE CONTABILIZACAO                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PXH008                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CONTABILIDADE                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PXH008()

Private	oTes, _cTes, oDescTes,_cDescTes

PRIVATE aRotina	:= {{OemToAnsi("Pesquisar") ,"AxPesqui()", 0 , 1, 0, .F.},;
{OemToAnsi("Visualizar"),"U_PXH08_01",  0 , 2, 0, nil},;
{OemToAnsi("Incluir")   ,"U_PXH08_01",  0 , 3, 0, nil},;
{OemToAnsi("Alterar")   ,"U_PXH08_01",  0 , 4, 0, nil},;
{OemToAnsi("Excluir")   ,"U_PXH08_01",  0 , 5, 0, nil},;
{OemToAnsi("Copiar")    ,"U_PXH08_01",  0 , 6, 0, nil}}


PRIVATE cCadastro := OemToAnsi("Amarração TES x Contabilidade")

MBrowse( 6, 1,22,75,"SZ4",,,,,,,,,,,,,,NIL)

Return Nil



User Function PXH08_01(cAlias,nReg,_nOpcx)

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

_aCampos := {"Z4_ITEM","Z4_TIPO","Z4_NOMTIPO","Z4_CTADEB","Z4_NOMDEB","Z4_CTACRD","Z4_NOMCRD","Z4_HIST","Z4_VALDEB","Z4_FORMDEB","Z4_VALCRD","Z4_FORMCRD"}

For AX:= 1 TO Len(_aCampos)
	dbSelectArea("Sx3")
	dbSetOrder(2)
	If dbSeek(_aCampos[AX])
		AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,x3_valid,;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
	Endif
Next Ax

Private _nPITEM   := aScan( aHeader, { |x| Alltrim(x[2])== "Z4_ITEM"     } )
Private _nPTIPO   := aScan( aHeader, { |x| Alltrim(x[2])== "Z4_TIPO"     } )
Private _nPNOMTIPO:= aScan( aHeader, { |x| Alltrim(x[2])== "Z4_NOMTIPO"  } )
Private _nPCTADEB := aScan( aHeader, { |x| Alltrim(x[2])== "Z4_CTADEB"   } )
Private _nPNOMDEB := aScan( aHeader, { |x| Alltrim(x[2])== "Z4_NOMDEB"   } )
Private _nPCTACRD := aScan( aHeader, { |x| Alltrim(x[2])== "Z4_CTACRD"   } )
Private _nPNOMCRD := aScan( aHeader, { |x| Alltrim(x[2])== "Z4_NOMCRD"   } )
Private _nPHIST   := aScan( aHeader, { |x| Alltrim(x[2])== "Z4_HIST"     } )
Private _nPVALDEB := aScan( aHeader, { |x| Alltrim(x[2])== "Z4_VALDEB"   } )
Private _nPVALCRD := aScan( aHeader, { |x| Alltrim(x[2])== "Z4_VALCRD"   } )
Private _nPFORDEB := aScan( aHeader, { |x| Alltrim(x[2])== "Z4_FORMDEB"  } )
Private _nPFORCRD := aScan( aHeader, { |x| Alltrim(x[2])== "Z4_FORMCRD"  } )

aCols   := {}
_lEdit  := .F.

If INCLUI

	_lEdit2 := .T.		
	_lEdit  := .T.
	
	aCols:={Array(Len(_aCampos)+1)}
	aCols[1,Len(_aCampos)+1]:=.F.
	For _ni:=1 to Len(_aCampos)
		If aHeader[_ni,2] = "Z4_ITEM"
			aCols[1,_ni]:= "0001"
		Else
			aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
		Endif
	Next
	
	_cTES     := Space(3)
	_cDescTES := Space(30)
Else
	_lEdit2   := .F.
	
	If COPIA
		_lEdit2 := .T.
	Endif
	_cTES     := SZ4->Z4_TES
	_cDescTES := SZ4->Z4_DESC
	
	SZ4->(dbSetOrder(1))
	If SZ4->(dbSeek(xFilial("SZ4") + _cTes))
		
		_cChavSZ4 := SZ4->Z4_TES
		
		While SZ4->(!Eof()) .And. _cChavSZ4 == SZ4->Z4_TES
			
			AADD(aCols,Array(Len(_aCampos)+1))
			
			aCols[Len(aCols),_NPITEM]    := SZ4->Z4_ITEM
			aCols[Len(aCols),_NPTIPO]    := SZ4->Z4_TIPO
			aCols[Len(aCols),_NPNOMTIPO] := SZ4->Z4_NOMTIPO
			aCols[Len(aCols),_NPCTADEB]  := SZ4->Z4_CTADEB
			aCols[Len(aCols),_NPNOMDEB]  := SZ4->Z4_NOMDEB			
			aCols[Len(aCols),_NPCTACRD]  := SZ4->Z4_CTACRD
			aCols[Len(aCols),_NPNOMCRD]  := SZ4->Z4_NOMCRD
			aCols[Len(aCols),_NPHIST]    := SZ4->Z4_HIST
			aCols[Len(aCols),_NPVALDEB]  := SZ4->Z4_VALDEB			
			aCols[Len(aCols),_NPVALCRD]  := SZ4->Z4_VALCRD
			aCols[Len(aCols),_NPFORDEB]  := SZ4->Z4_FORMDEB		
			aCols[Len(aCols),_NPFORCRD]  := SZ4->Z4_FORMCRD
			
			aCols[Len(aCols),Len(_aCampos)+1]:=.F.
			
			SZ4->(dbSkip())
		EndDo
	Endif
	
	If COPIA
		_cTES     := Space(3)
		_cDescTES := Space(30)
	Endif
	
Endif

cTitulo       := "RELACIONAMENTO TES X CONTABILIDADE"
cAliasGetD    := "SZ4"
cLinOk        := "AllwaysTrue()"
cTudOk        := "AllwaysTrue()"
cFieldOk      := "AllwaysTrue()"

_lRetMod2     := PXH08_02(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)

If _lRetMod2 .And. !VISUAL
	PXH08_07()
Endif

Return

Static Function PXH08_02(cTitulo,cAlias2,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)

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


@ 1.5,002 Say "Tes: "
@ 1.5,005 MSGET oTes VAR _cTES  when _lEdit2  F3 "SF4" VALID (ExistCpo("SF4",_cTes) .And. ExistChav("SZ4",_cTes) .And. PXH08_03()) PICTURE "@!" SIZE 30,10

@ 1.5,010 Say "Descrição: "
@ 1.5,014 MSGET oDescTEs VAR _cDescTes When .f. PICTURE "@!" SIZE 150,10

nGetLin := aPosObj[3,1]

oGetDados := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],_nOpcao,"U_PXH08_05()","PXH08_06","+Z4_ITEM",.T.)

ACTIVATE MSDIALOG oDlg centered ON INIT EnchoiceBar(oDlg,{||_nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),_nOpca := 0,oDlg:End()),_nOpca := 0)},{||oDlg:End()},,aButtons)

_lRet := (_nOpca==1)

Return(_lRet)


Return


Static Function PXH08_03()

If Empty(_cTes)
	MsgAlert("TES EM BRANCO!!")
	Return(.F.)
Endif

SF4->(dbSetOrder(1))
SF4->(dbSeek(xFilial("SF4") + _cTes ))

_cDescTES := SF4->F4_TEXTO

Return(.T.)



User Function PXH08_04(_cDC)

_aAliOri := GetArea()
_aAliCT1 := CT1->(GetArea())
_lRet    := .F.

If _cDC == "D"
	_cCtaDeb := M->Z4_CTADEB
	
	If Alltrim(_cCtaDeb) $ "PRODUTO/FORNECEDOR/CLIENTE"
		_lRet := .T.
	Else
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
	Endif
ElseIf _cDC == "C"
	
	_cCtaCrd := M->Z4_CTACRD
	
	If Alltrim(_cCtaCrd) $ "PRODUTO/FORNECEDOR/CLIENTE"
		_lRet := .T.
	Else
		If Empty(_cCtaCrd)
			_lRet := .T.
		Else
			CT1->(dbSetOrder(1))
			If CT1->(!dbSeek(xFilial("CT1")+ _cCtaCrd))
				MSGSTOP("Conta Contabil Nao Cadastrada!! "+_cCtaCrd)
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
	Endif
Endif

RestArea(_aAliCT1)
RestArea(_aAliOri)

Return(_lRet)


User Function PXH08_05()

_aVerDup  := {}
lOk       := .T.

For AX := 1 to Len(aCols)
	
	_cFim := (Len(aHeader)+1)
	If !aCols[AX,_cFim]
		_cTipo:= aCols[AX,_NPTIPO]
		
		If ASCAN( _aVerDup,{|x| x[1]  == _cTipo }) == 0
			AADD( _aVerDup,{_cTipo})
		Else
			MSGSTOP(" Dados Ja lançado!!!")
			lOK := .F.
		Endif
	Endif
Next

Return(lOk)


Static Function PXH08_06()

Private _lRetorno := .t.

Return(_lRetorno)



Static Function PXH08_07()

If ALTERA .Or. EXCLUI
	SZ4->(dbSetOrder(1))
	If SZ4->(dbSeek(xFilial("SZ4")+_cTes))
		
		While SZ4->(!Eof()) .And. SZ4->Z4_TES == _cTes
			
			SZ4->(RecLock("SZ4",.F.))
			SZ4->(dbDelete())
			SZ4->(MsUnlock())
			
			SZ4->(dbSkip())
		EndDo
	Endif
Endif

If !EXCLUI
	For AX:= 1 To Len(ACOLS)
		
		_cFim := (Len(aHeader)+1)
		If !aCols[AX,_cFim]
			SZ4->(RecLock("SZ4",.T.))
			SZ4->Z4_FILIAL  := xFilial("SZ4")
			SZ4->Z4_TES     := _cTes
			SZ4->Z4_DESC    := _cDescTEs
			SZ4->Z4_ITEM    := ACOLS[AX,_NPITEM]
			SZ4->Z4_TIPO    := ACOLS[AX,_NPTIPO]
			SZ4->Z4_NOMTIPO := ACOLS[AX,_NPNOMTIPO]
			SZ4->Z4_CTADEB  := ACOLS[AX,_NPCTADEB]
			SZ4->Z4_NOMDEB  := ACOLS[AX,_NPNOMDEB]			
			SZ4->Z4_CTACRD  := ACOLS[AX,_NPCTACRD]
			SZ4->Z4_NOMCRD  := ACOLS[AX,_NPNOMCRD]						
			SZ4->Z4_HIST    := ACOLS[AX,_NPHIST]                  
			SZ4->Z4_VALDEB  := ACOLS[AX,_NPVALDEB]			
			SZ4->Z4_VALCRD  := ACOLS[AX,_NPVALCRD]			
			SZ4->Z4_FORMDEB := ACOLS[AX,_NPFORDEB]			
			SZ4->Z4_FORMCRD := ACOLS[AX,_NPFORCRD]			

			SZ4->(MsUnlock())
		Endif
	Next Ax
Endif

Return