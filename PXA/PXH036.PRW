#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PXH036   º Autor ³ Alexandro Silva    º Data ³  31/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Integração contabil da folha de pagamento                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Sigagpe                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PXH036()

Private cCadastro := "VERBAS X CONTABILIDADE "
Private aRotina   := {}
Private	_aAliSC6

Private _cGrAprov:= ""
Private _nSdoLim := _nSdoTit := _nValor := _nValLim := 0


aAdd(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
aAdd(aRotina,{"Visualizar","U_PXH36_01",0,2})
aAdd(aRotina,{"Incluir"   ,"U_PXH36_01",0,3})
aAdd(aRotina,{"Alterar"   ,"U_PXH36_01",0,4})
aAdd(aRotina,{"Legenda"   ,"A410LEGEND",0,6})


DbSelectArea("SZ9")
DbSetOrder(1)
DbGoTop()


MBrowse(6,1,22,75,"SZ9",,,,,,)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ PXH36_01 ³ Autor  ³ Alexandro da Silva     ³ Data ³08/11/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function PXH36_01(cAlias,nReg,_nOpcX)


Private   Acols	:={}
Private	oEstado,oGetDados, oFornece, oLoja, oTabPrc, _cDesPrc,oVigDe, oVigAte

Private VISUAL := (_nOpcX == 2)
Private INCLUI := (_nOpcX == 3)
Private ALTERA := (_nOpcX == 4)
Private DELETA := (_nOpcX == 5)
PRIVATE	_cEstado

Private aHeader := {}
Private _nOpcao := _nOpcX

_nOpcE := _nOpcX
_nOpcG := _nOpcX

_aCampos := {"Z9_GREMP","Z9_EMPRESA","Z9_TPCUSTO","Z9_CONTAD","Z9_DCONTAD","Z9_CONTAC","Z9_DCONTAC"}

For AX:= 1 TO Len(_aCampos)
	dbSelectArea("Sx3")
	dbSetOrder(2)
	If dbSeek(_aCampos[AX])
		AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,x3_valid,;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
	Endif
Next Ax

Private _nPGREMP   := aScan( aHeader, { |x| Alltrim(x[2])== "Z9_GREMP"   } )  
Private _nPEMPRESA := aScan( aHeader, { |x| Alltrim(x[2])== "Z9_EMPRESA" } ) 
Private _nPTPCUSTO := aScan( aHeader, { |x| Alltrim(x[2])== "Z9_TPCUSTO" } )
Private _nPCONTAD  := aScan( aHeader, { |x| Alltrim(x[2])== "Z9_CONTAD"  } )
Private _nPTPCUSTO := aScan( aHeader, { |x| Alltrim(x[2])== "Z9_TPCUSTO" } )
Private _nPCONTAD  := aScan( aHeader, { |x| Alltrim(x[2])== "Z9_CONTAD"  } )
Private _nPDESCTAD := aScan( aHeader, { |x| Alltrim(x[2])== "Z9_DCONTAD" } )
Private _nPCONTAC  := aScan( aHeader, { |x| Alltrim(x[2])== "Z9_CONTAC"  } )
Private _nPDESCTAC := aScan( aHeader, { |x| Alltrim(x[2])== "Z9_DCONTAC" } )

If INCLUI
	
	_nOpcE := 3
	_nOpcG := 3
	
	_lEdit := .T.
	aCols:={Array(Len(_aCampos)+1)}
	aCols[1,Len(_aCampos)+1]:=.F.
	For _ni:=1 to Len(_aCampos)
		aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
	Next
	
	_cVerba   := Space(3)
	_cDesVerba:= Space(30)
Else
	_cVerba   := SZ9->Z9_VERBA
	SRV->(dbSetOrder(1))
	SRV->(dbSeek(xFilial("SRV") + _cVerba))
	
	_cDesVerba:= SRV->RV_DESC
	
	aCols:= {}
	
	SZ9->(dbSetOrder(1))
	If SZ9->(dbSeek(xFilial("SZ9") + _cVerba))
		
		_cChavSZ9 := SZ9->Z9_VERBA
		
		While SZ9->(!Eof()) .And. _cChavSZ9 == SZ9->Z9_VERBA
			
			AADD(aCols,Array(Len(_aCampos)+1))
			
			ACols[Len(aCols),_NPGREMP]   := SZ9->Z9_GREMP
			ACols[Len(aCols),_NPEMPRESA] := SZ9->Z9_EMPRESA
			aCols[Len(aCols),_NPTPCUSTO] := SZ9->Z9_TPCUSTO
			aCols[Len(aCols),_NPCONTAD]  := SZ9->Z9_CONTAD
			aCols[Len(aCols),_NPDESCTAD] := SZ9->Z9_DCONTAD
			aCols[Len(aCols),_NPCONTAC]  := SZ9->Z9_CONTAC
			aCols[Len(aCols),_NPDESCTAC] := SZ9->Z9_DCONTAC
			aCols[Len(aCols),Len(_aCampos)+1]:=.F.
			
			SZ9->(dbSkip())
		EndDo
	Endif
	
	_lEdit  := .F.
	
Endif

cTitulo       := "VERBA X CONTABILIDADE"
cAliasGetD    := "SZ9"
cLinOk        := "AllwaysTrue()"
cTudOk        := "AllwaysTrue()"
cFieldOk      := "AllwaysTrue()"

_lRetMod2     := NS68_02(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)

If _lRetMod2
	GravTab()
Endif



Return


Static Function NS68_02(cTitulo,cAlias2,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)

Local _lRet83A, _nOpca := 0,cSaveMenuh,oDlg
Local oCombo,oCliente,oLoja,oCond,oCodigo,oTpPedido
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


@ 1.5,002 Say "Verba: "
@ 1.5,005 MSGET oVerba   VAR _cVerba           When _lEdit F3 "SRV" VALID (!Empty(_cVerba) .And. ExistCpo("SRV",_cVerba) .And. ExistChav("SZ9",_cVerba ) .And. NS68_06() ) PICTURE "@!" SIZE 30,10

@ 1.5,010 Say "Nome da Verba:"
@ 1.5,015 MSGET oNomVerba VAR _cDesVerba       When .F.     SIZE 120,10

nGetLin := aPosObj[3,1]

oGetDados := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],_nOpcao,"U_NS68_05()","NS68_04",,.T.)

ACTIVATE MSDIALOG oDlg centered ON INIT EnchoiceBar(oDlg,{||_nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),_nOpca := 0,oDlg:End()),_nOpca := 0)},{||oDlg:End()},,aButtons)

_lRet := (_nOpca==1)

Return(_lRet)


Static Function NS68_04()

Private _lRetorno := .t.

Return(_lRetorno)


User Function NS68_05()

_aVerDup  := {}
lOk       := .T.

For AX := 1 to Len(aCols)
	
	_cGrEmp   := Acols[AX,_NPGREMP]
	_cEmpresa := Acols[AX,_NPEMPRESAO]
	_cCCusto  := Acols[AX,_NPTPCUSTO]	                                
	
	_cFim := (Len(aHeader)+1)
	If !aCols[AX,_cFim]
		If ASCAN( _aVerDup,{|x| x[1] == _cGrEmp .And. x[2] == _cEmpresa .And. x[3] == _cCCusto }) == 0
			AADD( _aVerDup,{_cGrEmp,_cEmpresa,_cCCUSTO})
		Else
			MSGSTOP(" Dados Ja lançado!!!")
			lOK := .F.
		Endif
	Endif
Next

Return(lOk)


Static Function NS68_06()

SRV->(dbSetOrder(1))
SRV->(dbSeek(xFilial("SRV")+ _cVerba))

_cDesVerba:= SRV->RV_DESC

Return(.T.)




Static Function GravTab()


If INCLUI
	
	For AX:= 1 To Len(ACOLS)
		
		_cFim := (Len(aHeader)+1)
		If !aCols[AX,_cFim]
			SZ9->(RecLock("SZ9",.T.))
			SZ9->Z9_FILIAL  := xFilial("SZ9")
			SZ9->Z9_VERBA   := _cVerba
			SZ9->Z9_DVERBA  := _cDesVerba
			SZ9->Z9_GREMP   := ACOLS[AX,_NPGREMP]
			SZ9->Z9_EMPRESA := ACOLS[AX,_NPEMPRESA]
			SZ9->Z9_TPCUSTO := ACOLS[AX,_NPTPCUSTO]
			SZ9->Z9_CONTAD  := ACOLS[AX,_NPCONTAD]  			
			SZ9->Z9_DCONTAD := ACOLS[AX,_NPDESCTAD]
			SZ9->Z9_CONTAC  := ACOLS[AX,_NPCONTAC]
			SZ9->Z9_DCONTAC := ACOLS[AX,_NPDESCTAC]
			SZ9->(MsUnlock())
		Endif
	Next Ax
ElseIf ALTERA
	SZ9->(dbSetOrder(1))
	If SZ9->(dbSeek(xFilial("SZ9") + _cVerba ))
		
		_cChavSZ9 := SZ9->Z9_VERBA
		
		While SZ9->(!Eof()) .And. _cChavSZ9 == SZ9->Z9_VERBA
			
			SZ9->(RecLock("SZ9",.F.))
			SZ9->(dbDelete())
			SZ9->(MsUnlock())
			
			SZ9->(dbSkip())
		EndDo
	Endif
	
	For AX:= 1 To Len(ACOLS)
		
		_cFim := (Len(aHeader)+1)
		If !aCols[AX,_cFim]
			SZ9->(RecLock("SZ9",.T.))
			SZ9->Z9_FILIAL  := xFilial("SZ9")
			SZ9->Z9_VERBA   := _cVerba
			SZ9->Z9_DVERBA  := _cDesVerba
			SZ9->Z9_GREMP   := ACOLS[AX,_NPGREMP]
			SZ9->Z9_EMPRESA := ACOLS[AX,_NPEMPRESA]
			SZ9->Z9_TPCUSTO := ACOLS[AX,_NPTPCUSTO]
			SZ9->Z9_CONTAD  := ACOLS[AX,_NPCONTAD]
			SZ9->Z9_DCONTAD := ACOLS[AX,_NPDESCTAD]
			SZ9->Z9_CONTAC  := ACOLS[AX,_NPCONTAC]
			SZ9->Z9_DCONTAC := ACOLS[AX,_NPDESCTAC]
			SZ9->(MsUnlock())
		Endif
	Next Ax
ElseIf DELETA
	SZ9->(dbSetOrder(1))
	If SZ9->(dbSeek(xFilial("SZ9") + _cVerba ))
		
		_cChavSZ9 := SZ9->Z9_VERBA
		
		While SZ9->(!Eof()) .And. _cChavSZ9 == SZ9->Z9_VERBA
			
			SZ9->(RecLock("SZ9",.F.))
			SZ9->(dbDelete())
			SZ9->(MsUnlock())
			
			SZ9->(dbSkip())
		EndDo
	Endif
Endif

Return

User Function PX36_10()

_aAliORI := GetArea()
_aAliSM0 := SM0->(GetArea())

_lRet10 := .T.

SM0->(dbSetOrder(1))
If SM0->(!dbSeek(ACOLS[N,_NPGREMP]+M->Z9_EMPRESA))
	_lRet10 := .F.
Endif

RestArea(_aAliSM0)
RestArea(_aAliORI)

Return(_lRet10)
