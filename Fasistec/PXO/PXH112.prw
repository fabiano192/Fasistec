#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ BRI106 º Autor ³ Alexandro Silva º Data ³ 07/11/17 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Fechamento Mensal Final - Contabil º±±
±±º ³ º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso ³ Sigactb º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PXH112()

	Private cCadastro := "Bloqueio Fiscal / Compras / Estoque / Financeiro"
	Private aRotina := {}
	Private	_aAliSC6

	Private _cGrAprov:= ""
	Private nSdoLim := nSdoTit := nValor := nValLim := 0

	aAdd(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
	aAdd(aRotina,{"Visualizar","U_PXH1121",0,2})
	aAdd(aRotina,{"Incluir" ,"U_PXH1121",0,3})
	aAdd(aRotina,{"Alterar" ,"U_PXH1121",0,4})
	aAdd(aRotina,{"Legenda" ,"A410LEGEND",0,5})

	Private Acols	:={}
	Private	oEstado,oGetDados, oFornece, oLoja, oTabPrc, _cDesPrc,oVigDe, oVigAte

	Private INCLUI := .T.

	PRIVATE	_cEstado

	Private aHeader := {}

	lUser := U_ChkAcesso("PXH112",6,.T.)

	If !lUser
		Return(.F.)
	Endif

	Private _nOpcao := 3
	Private _nOpcX := 3

	_nOpcE := _nOpcX
	_nOpcG := _nOpcX

	//_aCampos := {"Z04_ITEM","Z04_CODEMP","Z04_CODFIL","Z04_NOMFIL","Z04_DTCTB","Z04_DTFIS","Z04_DTFIN","Z04_DTEST"}
	_aCampos := {"Z04_ITEM","Z04_CODEMP","Z04_CODFIL","Z04_NOMFIL","Z04_DTCTB","Z04_DTFIS","Z04_DTFIN"}

	For AX:= 1 TO Len(_aCampos)
		dbSelectArea("Sx3")
		dbSetOrder(2)
		If dbSeek(_aCampos[AX])

			If Alltrim(SX3->X3_CAMPO) == "Z04_DTCTB"
				AADD(aHeader,{ "Fechto Geral", x3_campo, x3_picture,;
				x3_tamanho, x3_decimal,x3_valid,;
				x3_usado, x3_tipo, x3_arquivo, x3_context } )	
			Else
				AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
				x3_tamanho, x3_decimal,x3_valid,;
				x3_usado, x3_tipo, x3_arquivo, x3_context } )	
			Endif
		Endif
	Next Ax

	Private _nPITEM := aScan( aHeader, { |x| Alltrim(x[2])== "Z04_ITEM" } )
	Private _nPCODEMP := aScan( aHeader, { |x| Alltrim(x[2])== "Z04_CODEMP" } )
	Private _nPCODFIL := aScan( aHeader, { |x| Alltrim(x[2])== "Z04_CODFIL" } )
	Private _nPNOMFIL := aScan( aHeader, { |x| Alltrim(x[2])== "Z04_NOMFIL" } )
	Private _nPDTCTB := aScan( aHeader, { |x| Alltrim(x[2])== "Z04_DTCTB" } ) 
	Private _nPDTFIS := aScan( aHeader, { |x| Alltrim(x[2])== "Z04_DTFIS" } )
	Private _nPDTFIN := aScan( aHeader, { |x| Alltrim(x[2])== "Z04_DTFIN" } )
	//Private _nPDTEST := aScan( aHeader, { |x| Alltrim(x[2])== "Z04_DTEST" } )
	//Private _nPVAZIO := aScan( aHeader, { |x| Alltrim(x[2])== "Z04_VAZIO" } )

	aCols:= {}

	_aAliOri := GetArea()
	_aAliSM0 := SM0->(GetArea())

	SM0->(dbSetOrder(1))
	If SM0->(dbSeek(cEmpAnt + cFilAnt))

		_cChavSM0 := SM0->M0_CODIGO
		_cCont := "0000"

		While SM0->(!Eof()) .And. _cChavSM0 == SM0->M0_CODIGO

			AADD(aCols,Array(Len(_aCampos)+1))

			// {"X6_FIL"	,"X6_VAR" ,"X6_TIPO","X6_DESCRIC ","X6_CONTEUD"
			//U_CRIASX6(SM0->M0_CODFIL,"MV_YDTCTB","D" ,"Data de Fechamento Contabil ","" )

			_dDtCtb := CTOD("")
			_dDtFis := CTOD("")
			_dDtFin := CTOD("")
			//_dDtEst := CTOD("")

			SX6->(dbSetOrder(1))
			If SX6->(dbSeek(Alltrim(SM0->M0_CODFIL) + "MV_YDTCTB"))
				_dDtCtb := CTOD(Alltrim(SX6->X6_CONTEUD))
			Endif

			SX6->(dbSetOrder(1))
			If SX6->(dbSeek(Alltrim(SM0->M0_CODFIL) + "MV_DATAFIS"))
				_dDtFis := STOD(ALLTRIM(SX6->X6_CONTEUD))
			Else
				If SX6->(dbSeek(Space(05) + "MV_DATAFIS"))
					_dDtFis := STOD(ALLTRIM(SX6->X6_CONTEUD)) 
				Endif
			Endif

			SX6->(dbSetOrder(1))
			If SX6->(dbSeek(Alltrim(SM0->M0_CODFIL) + "MV_DATAFIN"))
				_dDtFin := CTOD(Alltrim(SX6->X6_CONTEUD)) 
			Else
				If SX6->(dbSeek(Space(02) + "MV_DATAFIN"))
					_dDtFin := CTOD(Alltrim(SX6->X6_CONTEUD)) 
				Endif
			Endif

			_cCont := Soma1(_cCont)

			aCols[Len(aCols),_NPITEM] := _cCont
			aCols[Len(aCols),_NPCODEMP] := SM0->M0_CODIGO
			aCols[Len(aCols),_NPCODFIL] := Alltrim(SM0->M0_CODFIL)
			aCols[Len(aCols),_NPNOMFIL] := SM0->M0_FILIAL
			aCols[Len(aCols),_NPDTCTB] := _dDtCtb 
			aCols[Len(aCols),_NPDTFIS] := _dDtFis
			aCols[Len(aCols),_NPDTFIN] := _dDtFin
			//aCols[Len(aCols),_NPDTEST] := _dDtEst

			aCols[Len(aCols),Len(_aCampos)+1]:=.F.

			SM0->(dbSkip())
		EndDo
	Endif

	cTitulo := "Bloqueio Fiscal / Compras / Estoque / Financeiro"
	cAliasGetD := "Z04"
	cLinOk := "AllwaysTrue()"
	cTudOk := "AllwaysTrue()"
	cFieldOk := "AllwaysTrue()"

	_lRetMod2 := PXH112_02(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)

	If _lRetMod2
		GravTab()
	Endif


Return


Static Function PXH112_02(cTitulo,cAlias2,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)

	Local lRet83A, nOpca := 0,cSaveMenuh,oDlg
	Local oCombo,oCliente,oLoja,oCond,oCodigo,oTpPedido
	Private aSize	:= MsAdvSize()
	Private aObjects := {}
	Private aPosObj := {}
	Private aSizeAut := MsAdvSize()
	Private aButtons := {}

	AAdd( aObjects, { 0, 25, .T., .F. })
	AAdd( aObjects, { 100, 100, .T., .T. })
	AAdd( aObjects, { 0, 3, .T., .F. })

	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects,.T. )

	aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{10,35,100,135,205,255},{10,45,105,145,225,265,210,255}})

	Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
	bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
	Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0

	DEFINE MSDIALOG oDlg TITLE cTitulo From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

	@ 1.0,025 Say "BLOQUEIO FECHAMENTO - FINANCEIRO, FISCAL E ESTOQUE "

	nGetLin := aPosObj[3,1]

	oGetDados := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],_nOpcao,"U_PXH112_05()","U_PXH112_04()","+Z04_ITEM",.T.)

	ACTIVATE MSDIALOG oDlg centered ON INIT EnchoiceBar(oDlg,{||_nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),_nOpca := 0,oDlg:End()),_nOpca := 0)},{||oDlg:End()},,aButtons)

//	lRet := (nOpca==1)
	lRet := .T.

Return(lRet)


User Function PXH112_05()

	LOCAL AX
	_aVerDup := {}
	lOk := .T.

Return(lOk)


Static Function GravTab()

	LOCAL AX

	For AX:= 1 To Len(ACOLS)

		_cFim := (Len(aHeader)+1)
		If !aCols[AX,_cFim]

			_cFil := ACOLS[AX,_NPCODFIL]
			_dDtCtb := ACOLS[AX,_NPDTCTB] 
			_dDtFis := ACOLS[AX,_NPDTFIS]
			_dDtFin := ACOLS[AX,_NPDTFIN]
			//_dDtEst := ACOLS[AX,_NPDTEST]

			_lAchou := .F.

			SX6->(dbSetOrder(1))
			If SX6->(dbSeek(_cFil + "MV_YDTCTB"))
				SX6->(RecLock("SX6",.F.))
				SX6->X6_CONTEUD := DTOC(_dDtCtb)
				SX6->(MsUnlock())
			Endif

			_lAchou := .F.

			SX6->(dbSetOrder(1))
			If SX6->(dbSeek(_cFil + "MV_DATAFIS"))
				_lAchou := .T.
			Else
				If SX6->(dbSeek(Space(05) + "MV_DATAFIS"))
					_lAchou := .T.
				Endif
			Endif

			If _lAchou
				SX6->(RecLock("SX6",.F.))
				SX6->X6_CONTEUD := DTOS(_dDtFis)
				SX6->(MsUnlock())
			Endif 

			_lAchou := .F.

			SX6->(dbSetOrder(1))
			If SX6->(dbSeek(_cFil + "MV_DATAFIN"))
				_lAchou := .T.
			Else
				If SX6->(dbSeek(Space(05) + "MV_DATAFIN"))
					_lAchou := .T.
				Endif
			Endif

			If _lAchou
				SX6->(RecLock("SX6",.F.))
				SX6->X6_CONTEUD := DTOC(_dDtFin + 1)
				SX6->(MsUnlock())
			Endif

		Endif
	Next Ax

Return