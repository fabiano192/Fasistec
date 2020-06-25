#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PXH0005  ³ Autor ³ Alexandro Silva       ³ Data ³06/12/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ MANUTENÇAO REGRAS DE CONTABILIZACAO (NATUREZAS)            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PXHOL005                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CONTABILIDADE                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PXH005()

Private	oNATUREZ, _cNATUREZ, oDESVER ,_cDESVER

PRIVATE aRotina	:= {{OemToAnsi("Pesquisar") ,"AxPesqui()", 0 , 1, 0, .F.},;
{OemToAnsi("Visualizar")     ,"U_PX05_01",  0 , 2, 0, nil},;
{OemToAnsi("Incluir")        ,"U_PX05_01",  0 , 3, 0, nil},;
{OemToAnsi("Alterar")        ,"U_PX05_01",  0 , 4, 0, nil},;
{OemToAnsi("Excluir")        ,"U_PX05_01",  0 , 5, 0, nil}}

PRIVATE cCadastro := OemToAnsi("Amarração Natureza x Conta Contabil")

MBrowse( 6, 1,22,75,"SZ1",,,,,,,,,,,,,,NIL)

Return Nil



User Function PX05_01(cAlias,nReg,_nOpcx)

Private VISUAL  := (_nOpcX == 2)
Private INCLUI  := (_nOpcX == 3)
Private ALTERA  := (_nOpcX == 4)
Private EXCLUI  := (_nOpcX == 5)
Private   Acols	:= {}
Private aHeader := {}
Private _nOpcao := _nOpcX

_nOpcE          := _nOpcX
_nOpcG          := _nOpcX
_aCampos        := {"Z1_GREMP","Z1_EMPRESA","Z1_CONTA","Z1_NATSYS","Z1_JUROPAG","Z1_DESCOBT"}

For AX:= 1 TO Len(_aCampos)
	dbSelectArea("Sx3")
	dbSetOrder(2)
	If dbSeek(_aCampos[AX])
		AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,x3_valid,;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
	Endif
Next Ax

Private _nPGREMP  := aScan( aHeader, { |x| Alltrim(x[2])== "Z1_GREMP"   } )
Private _nPEMPRESA:= aScan( aHeader, { |x| Alltrim(x[2])== "Z1_EMPRESA" } )
Private _nPCONTA  := aScan( aHeader, { |x| Alltrim(x[2])== "Z1_CONTA"   } ) 
Private _nPNATSYS := aScan( aHeader, { |x| Alltrim(x[2])== "Z1_NATSYS"  } ) 
Private _nPCTAJUR := aScan( aHeader, { |x| Alltrim(x[2])== "Z1_JUROPAG" } ) 
Private _nPCTADES := aScan( aHeader, { |x| Alltrim(x[2])== "Z1_DESCOBT" } )

aCols   := {}
_lEdit  := .F.

If INCLUI
	_lEdit  := .T.
	
	aCols:={Array(Len(_aCampos)+1)}
	aCols[1,Len(_aCampos)+1]:=.F.
	For _ni:=1 to Len(_aCampos)
		aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
	Next
	
	_cNATUREZ := Space(10)
	_cDESVER  := Space(30)
Else
	_cNATUREZ := SZ1->Z1_NATUREZ
	_cDESVER  := SZ1->Z1_DESC
	
	SZ1->(dbSetOrder(2))
	If SZ1->(dbSeek(xFilial("SZ1") + _cNATUREZ))
		
		_cChavSZ1 := SZ1->Z1_NATUREZ
		
		While SZ1->(!Eof()) .And. _cChavSZ1 == SZ1->Z1_NATUREZ
			
			AADD(aCols,Array(Len(_aCampos)+1))
			
			aCols[Len(aCols),_NPGREMP]       := SZ1->Z1_GREMP
			aCols[Len(aCols),_NPEMPRESA]     := SZ1->Z1_EMPRESA
			aCols[Len(aCols),_NPCONTA]       := SZ1->Z1_CONTA
			aCols[Len(aCols),_NPNATSYS]      := SZ1->Z1_NATSYS 
			aCols[Len(aCols),_NPCTAJUR]      := SZ1->Z1_JUROPAG 
			aCols[Len(aCols),_NPCTADES]      := SZ1->Z1_DESCOBT
			aCols[Len(aCols),Len(_aCampos)+1]:= .F.
			
			SZ1->(dbSkip())
		EndDo
	Endif
Endif

cTitulo       := "RELACIONAMENTO NATUREZA X CONTA CONTABIL"
cAliasGetD    := "SZ1"
cLinOk        := "AllwaysTrue()"
cTudOk        := "AllwaysTrue()"
cFieldOk      := "AllwaysTrue()"

_lRetMod2     := PX05_02(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)

If _lRetMod2 .And. !VISUAL
	PX05_07()
Endif

Return

Static Function PX05_02(cTitulo,cAlias2,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)

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

@ 1.5,002 Say "Natureza: "
@ 1.5,006 MSGET oNaturez VAR _cNATUREZ  when _lEdit  F3 "SEDSZ1" VALID (ExistCpo("SED",_cNATUREZ) .And. ExistChav("SZ1",_cNATUREZ,2) .And. PX05_03()) PICTURE "@!" SIZE 40,10

@ 1.5,012 Say "Descrição: "
@ 1.5,016 MSGET oDESVER  VAR _cDESVER When .f. PICTURE "@!" SIZE 150,10

nGetLin   := aPosObj[3,1]
oGetDados := MsGetDados():New(aPosObj[2,1]+10,aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],_nOpcao,"U_PX05_05()","PX05_06",,.T.)

ACTIVATE MSDIALOG oDlg centered ON INIT EnchoiceBar(oDlg,{||_nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),_nOpca := 0,oDlg:End()),_nOpca := 0)},{||oDlg:End()},,aButtons)

_lRet := (_nOpca==1)

Return(_lRet)


Return


Static Function PX05_03()

If Empty(_cNATUREZ)
	MsgAlert("NATUREZA EM BRANCO!!")
	Return(.F.)
Endif

SED->(dbSetOrder(1))
SED->(dbSeek(xFilial("SED") + _cNATUREZ ))

_cDESVER := SED->ED_DESCRIC

Return(.T.)



User Function PX05_04(_cConta)

_aAliOri := GetArea()
_aAliCT1 := CT1->(GetArea())
_lRet    := .F.

_cCtaDeb := _cConta

If Empty(_cCtaDeb)
//	_lRet := .T.
Else
	CT1->(dbSetOrder(1))
	If CT1->(!dbSeek(xFilial("CT1")+ _cCtaDeb))
		MSGSTOP("Conta Contabil Nao Cadastrada!! "+_cCtaDeb)
		_lRet := .F.
		_cCtaDeb := Space(20)
	Else
		If CT1->CT1_CLASSE == "1"
			MSGSTOP("Favor Utilizar Conta Analitica!! "+_cCtaDeb)
			_lRet := .F.     
			_cCtaDeb := Space(20)
		//Else
		//	_lRet := .T.
		Endif
	Endif
Endif


RestArea(_aAliCT1)
RestArea(_aAliOri)

Return(_cCtaDeb)


User Function PX05_05()

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
			AADD( _aVerDup,{_cGrEmp,_cEmp  })
		Else
			MSGSTOP(" Dados Ja lançado!!!")
			lOK := .F.
		Endif
	Endif
Next

Return(lOk)


Static Function PX05_06()

Private _lRetorno := .t.

Return(_lRetorno)



Static Function PX05_07()

If ALTERA .Or. EXCLUI
	SZ1->(dbSetOrder(2))
	If SZ1->(dbSeek(xFilial("SZ1")+_cNATUREZ))
		
		While SZ1->(!Eof()) .And. SZ1->Z1_NATUREZ == _cNATUREZ
			
			SZ1->(RecLock("SZ1",.F.))
			SZ1->(dbDelete())
			SZ1->(MsUnlock())
			
			SZ1->(dbSkip())
		EndDo
	Endif
Endif

If !EXCLUI
	For AX:= 1 To Len(ACOLS)
		
		_cFim := (Len(aHeader)+1)
		If !aCols[AX,_cFim]
			SZ1->(RecLock("SZ1",.T.))
			SZ1->Z1_FILIAL  := xFilial("SZ1")
			SZ1->Z1_NATUREZ := _cNATUREZ
			SZ1->Z1_DESC    := _cDESVER
			SZ1->Z1_GREMP   := ACOLS[AX,_NPGREMP]
			SZ1->Z1_EMPRESA := ACOLS[AX,_NPEMPRESA]
			SZ1->Z1_CONTA   := ACOLS[AX,_NPCONTA] 
			SZ1->Z1_NATSYS  := ACOLS[AX,_NPNATSYS]		
			SZ1->Z1_JUROPAG := ACOLS[AX,_NPCTAJUR]
			SZ1->Z1_DESCOBT := ACOLS[AX,_NPCTADES]			
			SZ1->(MsUnlock())
		Endif
	Next Ax
Endif

Return



User Function PX05_08(cAlias,nReg,_nOpcx)

REPCC  := (_nOpcX == 6)
EXCCR  := (_nOpcX == 7)
EXCVER := (_nOpcX == 8)

If REPCC
	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| PX05_09(@_lFim) }
	Private _cTitulo01 := 'Selecionado Registros!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
ElseIf EXCCR
	ATUSX1B()
	If PERGUNTE("PXHOL05B",.T.)
		_cQ := " DELETE "+RetSqlName("SZ1")+" WHERE Z1_CC = '"+MV_PAR01+"' "
		TCSQLEXEC(_cQ)
	Endif
ElseIf EXCVER
	ATUSX1C()
	If PERGUNTE("PXHOL05C",.T.)
		_cQ := " DELETE "+RetSqlName("SZ1")+" WHERE Z1_NATUREZ = '"+MV_PAR01+"' "
		TCSQLEXEC(_cQ)
	Endif
Endif

Return


Static Function PX05_09()

ATUSX1A()
If PERGUNTE("PXHOL05A",.T.)
	If Empty(MV_PAR01)
		MSGINFO("Favor Colocar Parametro Valido!!")
		Return
	Endif
	
	_cCCRef := MV_PAR01
	_cTpCR  := ""
	
	CTT->(dbSetOrder(1))
	If CTT->(dbseek(xFilial("CTT")+ _cCCREF))
		_cTpCR := CTT->CTT_YTPCR
	Else
		MSGINFO("Centro de Custo Nao Cadastrado!!")
		Return
	Endif
	
	SZ1->(dbSetOrder(3))
	If SZ1->(dbseek(xFilial("SZ1") + _cCCREF))
		
		_cChavSZ1 := SZ1->Z1_CC
		
		ProcRegua(SZ1->(LASTREC()))
		
		While SZ1->(!Eof()) .And. _cChavSZ1 == SZ1->Z1_CC
			
			IncProc()
			
			_aAliSZ1 := SZ1->(GetArea())
			_cCR     := SZ1->Z1_CC
			_cVerba  := SZ1->Z1_NATUREZ
			_cEmpresa:= SZ1->Z1_EMPRESA
			
			_aCampos:= {}
			dbSelectArea("SZ1")
			For _W := 1 To FCount()
				AADD(_aCampos,{FieldName(_W),FieldGet(_W)})
			Next
			
			CTT->(dbSetOrder(1))
			CTT->(dbGotop())
			
			While CTT->(!Eof())
				
				If CTT->CTT_FILIAL != xFilial("CTT")
					CTT->(dbSkip())
					Loop
				Endif
				
				If CTT->CTT_YTIPO != "S"
					CTT->(dbSkip())
					Loop
				Endif
				
				If CTT->CTT_CUSTO == MV_PAR01
					CTT->(dbSkip())
					Loop
				Endif
				
				If CTT->CTT_CUSTO <  MV_PAR02 .Or. CTT->CTT_CUSTO > MV_PAR03
					CTT->(dbSkip())
					Loop
				Endif
				
				If _cTpCR != CTT->CTT_YTPCR
					CTT->(dbSkip())
					Loop
				Endif
				
				SZ1->(dbSetorder(3))
				If SZ1->(!dbSeek(xFilial("SZ1") + CTT->CTT_CUSTO + _cNATUREZ + _cEmpresa ))
					dbSelectArea("SZ1")
					RecLock("SZ1",.T.)
					For _W:= 1 to Len(_aCampos)
						_nPos := FieldPos(_aCampos[_W,1])
						FieldPut(_nPos,_aCampos[_W,2])
					Next
					SZ1->Z1_CC := CTT->CTT_CUSTO
					SZ1->(MsUnlock())
				Endif
				
				CTT->(dbSkip())
			EndDo
			
			RestArea(_aAliSZ1)
			
			SZ1->(dbSkip())
		EndDo
	Endif
Endif

Return


User Function PX05_10()

_aAliORI := GetArea()
_aAliSM0 := SM0->(GetArea())

_lRet10 := .T.

SM0->(dbSetOrder(1))
If SM0->(!dbSeek(ACOLS[N,_NPGREMP]+M->Z1_EMPRESA))
	//_cEmp := Space(03)
	_lRet10 := .F.
Endif

RestArea(_aAliSM0)
RestArea(_aAliORI)

Return(_lRet10)


User Function PX05_11()

_aAliORI := GetArea()

_cGrEmp11 := ACOLS[N,_NPGREMP]

ACOLS[N,_NPEMPRESA] := Space(03)
ACOLS[N,_NPCONTA]   := Space(20) 
ACOLS[N,_NPCTAJUR]  := Space(20)
ACOLS[N,_NPCTADES]  := Space(20)

RestArea(_aAliORI)


Return(_cGrEmp11)

Static Function AtuSX1A()

aRegs := {}
cPerg := "PXHOL05A"

//////////////////////////////////////////////
/////  GRUPO DE PERGUNTAS ////////////////////
///// MV_PAR01 - Centro Custo Referencia  ////
///// MV_PAR02 - Para Centro Inicial      ////
///// MV_PAR03 - Para Centro Final        ////
//////////////////////////////////////////////

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Centro Custo Referencia ?",""       ,""      ,"mv_ch1","C" ,09     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CTT")
U_CRIASX1(cPerg,"02","Para Natureza Inicial   ?",""       ,""      ,"mv_ch2","C" ,10     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SED")
U_CRIASX1(cPerg,"03","Para Natureza Final     ?",""       ,""      ,"mv_ch3","C" ,10     ,0      ,0     ,"G",""            ,"MV_PAR03",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SED")

Return


Static Function AtuSX1B()

aRegs := {}
cPerg := "PXHOL05B"

//////////////////////////////////////////////
/////  GRUPO DE PERGUNTAS ////////////////////
///// MV_PAR01 - Centro Custo Referencia  ////
///// MV_PAR02 - Para Centro Inicial      ////
///// MV_PAR03 - Para Centro Final        ////
//////////////////////////////////////////////

//    	   Grupo/Ordem/Pergunta                  /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Centro Custo Referencia  ?",""       ,""      ,"mv_ch1","C" ,09     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CTT")

Return

Static Function AtuSX1C()

aRegs := {}
cPerg := "PXHOL05C"

//////////////////////////////////////////////
/////  GRUPO DE PERGUNTAS ////////////////////
///// MV_PAR01 - Centro Custo Referencia  ////
///// MV_PAR02 - Para Centro Inicial      ////
///// MV_PAR03 - Para Centro Final        ////
//////////////////////////////////////////////

//    	   Grupo/Ordem/Pergunta                  /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Natureza Referencia         ?",""       ,""      ,"mv_ch1","C" ,10     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SED")

Return