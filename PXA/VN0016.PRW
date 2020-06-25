#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ VN0016   ³ Autor ³ Alexandro Silva       ³ Data ³05/05/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ TABELA DE PREÇO                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FATURAMENTO                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VN0016()
	
	Private	oTes, _cTes, oDescTes,_cDescTes
	
	PRIVATE aRotina	:= {{OemToAnsi("Pesquisar") ,"AxPesqui()", 0 , 1, 0, .F.},;
		{OemToAnsi("Visualizar"),"U_VN016_01",  0 , 2, 0, nil},;
		{OemToAnsi("Incluir")   ,"U_VN016_01",  0 , 3, 0, nil},;
		{OemToAnsi("Alterar")   ,"U_VN016_01",  0 , 4, 0, nil},;
		{OemToAnsi("Excluir")   ,"U_VN016_01",  0 , 5, 0, nil},;
		{OemToAnsi("Copiar")    ,"U_VN016_01",  0 , 6, 0, nil}}
	
	PRIVATE cCadastro := OemToAnsi("Tabela de Frete")
	
	MBrowse( 6, 1,22,75,"SZL",,,,,,,,,,,,,,NIL)
	
Return Nil



User Function VN016_01(cAlias,nReg,_nOpcx)
	
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
	
	_aCampos := {"ZL_ITEM","ZL_TRANSP","ZL_GRUPO","ZL_TES","ZL_VALFRET","ZL_PEDAGIO"}
	//	_aCampos := {"ZL_ITEM","ZL_TRANSP","ZL_PRODUTO","ZL_TES","ZL_VALFRET","ZL_PEDAGIO"}
	
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
	Private _nPGrupo   := aScan( aHeader, { |x| Alltrim(x[2])== "ZL_GRUPO"    } )
	//	Private _nPProd    := aScan( aHeader, { |x| Alltrim(x[2])== "ZL_PRODUTO"  } )
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
		
		_cUF      := Space(02)
		_cCODMUN  := Space(05)
		_cMUNIC   := Space(65)
		_cTPCAR   := Space(02)
		_cNOMCAR  := Space(50)
	Else
		_cUF      := SZL->ZL_UF
		_cCODMUN  := SZL->ZL_CODMUN
		_cMUNIC   := SZL->ZL_MUNICIP
		_cTPCAR   := SZL->ZL_TPCAR
		_cNOMCAR  := SZL->ZL_NOMCAR
		
		SZL->(dbSetOrder(1))
		If SZL->(dbSeek(xFilial("SZL") + _cUF + _cCODMUN + _cTPCAR))
			
			_cChavSZL := SZL->ZL_UF + SZL->ZL_CODMUN + SZL->ZL_TPCAR
			
			While SZL->(!Eof()) .And. _cChavSZL == SZL->ZL_UF + SZL->ZL_CODMUN + SZL->ZL_TPCAR
				
				AADD(aCols,Array(Len(_aCampos)+1))
				
				aCols[Len(aCols),_NPITEM]    := SZL->ZL_ITEM
				aCols[Len(aCols),_NPTRANSP]  := SZL->ZL_TRANSP
				aCols[Len(aCols),_NPGRUPO]   := SZL->ZL_GRUPO
				//				aCols[Len(aCols),_NPPROD]    := SZL->ZL_PRODUTO
				aCols[Len(aCols),_NPTES]     := SZL->ZL_TES
				aCols[Len(aCols),_NPFRETE]   := SZL->ZL_VALFRET
				aCols[Len(aCols),_NPPEDAG]   := SZL->ZL_PEDAGIO
				
				aCols[Len(aCols),Len(_aCampos)+1]:=.F.
				
				SZL->(dbSkip())
			EndDo
		Endif
		
		If COPIA
			_cUF      := Space(02)
			_cCODMUN  := Space(05)
			_cMUNIC   := Space(65)
			_cNOMECAR := Space(50)
		Endif
	Endif
	
	cTitulo       := "Tabela de Frete"
	cAliasGetD    := "SZL"
	cLinOk        := "AllwaysTrue()"
	cTudOk        := "AllwaysTrue()"
	cFieldOk      := "AllwaysTrue()"
	
	_lRetMod2     := VN016_02(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)
	
	If _lRetMod2 .And. !VISUAL
		VN016_07()
	Endif
	
Return



Static Function VN016_02(cTitulo,cAlias2,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)
	
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
	
	@ 1.0,0.50  Say "Estado: "
	@ 1.0,3.50  MSGET oEstado   VAR _cUF       when _lEdit  F3 "12" VALID (ExistCpo("SX5","12"+_cUF) .And. VN016_03()) PICTURE "@!" SIZE 30,10
	
	@ 1.0,009   Say "Cod.Municipio: "
	@ 1.0,015   MSGET oCodMun   VAR _cCODMUN   when _lEdit  F3 "CC2SZL" VALID (ExistCpo("CC2",_cUF + _cCODMUN)  .And. ExistChav("SZL",_cUF + _cCODMUN + _cTPCAR) .And. VN016_03()) PICTURE "@!" SIZE 30,10
	
	@ 1.0,021   Say "Municipio: "
	@ 1.0,025   MSGET oMun      VAR _cMUNIC    When .f. PICTURE "@!" SIZE 070,10
	
	@ 1.0,036   Say "Tp.Veiculo: "
	@ 1.0,040   MSGET oTPCAR    VAR _cTPCAR    when _lEdit  F3 "MU" VALID (ExistCpo("SX5","MU" + _cTPCAR)  .And. ExistChav("SZL",_cUF + _cCODMUN + _cTPCAR) .And. VN016_03()) PICTURE "@!" SIZE 30,10
	
	@ 1.0,045   Say "Nome Veiculo: "
	@ 1.0,050   MSGET oNOMCAR   VAR _cNOMCAR   when .F.  PICTURE "@!" SIZE 50,10
	
	nGetLin := aPosObj[3,1]
	
	oGetDados := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],_nOpcao,"U_VN016_05()","VN016_06","+ZL_ITEM",.T.)
	
	ACTIVATE MSDIALOG oDlg centered ON INIT EnchoiceBar(oDlg,{||_nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),_nOpca := 0,oDlg:End()),_nOpca := 0)},{||oDlg:End()},,aButtons)
	
	_lRet := (_nOpca==1)
	
Return(_lRet)


Return


Static Function VN016_03()
	
	If Empty(_cUF)
		MsgAlert("Estado  em Branco!!")
		Return(.F.)
	Endif
	
	_cMUNIC := CC2->CC2_MUN
	
	_cNOMCAR := TABELA("MU",_cTPCAR,.F.)
	
Return(.T.)


User Function VN016_05()
	
	_aVerDup  := {}
	lOk       := .T.
	
	For AX := 1 to Len(aCols)
		
		_cFim := (Len(aHeader)+1)
		If !aCols[AX,_cFim]
			_cTRANSP  := aCols[AX,_nPTRANSP]
			_cGRUPO   := aCols[AX,_NPGRUPO]
			//			_cPRODUTO := aCols[AX,_nPPROD]
			
			If ASCAN( _aVerDup,{|x| x[1]  == _cTRANSP .And. x[2]  == _cGRUPO}) == 0
				AADD( _aVerDup,{_cTransp,_cGRUPO})
			Else
				MSGSTOP("Dados Ja lançado!!!")
				lOK := .F.
			Endif
		Endif
	Next
	
Return(lOk)


Static Function VN016_06()
	
	Private _lRetorno := .t.
	
Return(_lRetorno)



Static Function VN016_07()
	
	If ALTERA .Or. EXCLUI
		SZL->(dbSetOrder(1))
		If SZL->(dbSeek(xFilial("SZL") + _cUF + _cCODMUN + _cTPCAR))
			
			While SZL->(!Eof()) .And. SZL->ZL_UF + SZL->ZL_CODMUN + SZL->ZL_TPCAR == _cUF + _cCODMUN + _cTPCAR
				
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
				SZL->ZL_UF      := _cUF
				SZL->ZL_CODMUN  := _cCODMUN
				SZL->ZL_MUNICIP := _cMUNIC
				SZL->ZL_TPCAR   := _cTPCAR
				SZL->ZL_NOMCAR  := _cNOMCAR
				SZL->ZL_ITEM    := ACOLS[AX,_NPITEM]
				SZL->ZL_TRANSP  := ACOLS[AX,_NPTRANSP]
				SZL->ZL_GRUPO   := ACOLS[AX,_NPGRUPO]
				//				SZL->ZL_PRODUTO := ACOLS[AX,_NPPROD]
				SZL->ZL_TES     := ACOLS[AX,_NPTES]
				SZL->ZL_VALFRET := ACOLS[AX,_NPFRETE]
				SZL->ZL_PEDAGIO := ACOLS[AX,_NPPEDAG]
				SZL->(MsUnlock())
			Endif
		Next Ax
	Endif
	
Return


/*/{Protheus.doc} VN16VLD
Validação do campo ZL_GRUPO
@type function
@author Fabiano
@since 03/08/2016
/*/
User Function VN16VLD()
	
	_lRet := .T.
	
	SBM->(dbSetOrder(1))
	If SBM->(msSeek(xFilial("SBM")+M->ZL_GRUPO))
		If !SBM->BM_YFRETE $ 'S'
			_lRet := .F.
			MsgAlert("Grupo não está cadastrado para ser utilizado na tabela de Frete!")
		Endif
	Else
		_lRet := .F.
		MsgAlert("Grupo não encontrado!")
	Endif
	
Return(_lRet)
