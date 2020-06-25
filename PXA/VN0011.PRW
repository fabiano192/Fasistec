#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE MAXGETDAD 99999
#DEFINE MAXSAVERESULT 999

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VN0011   ³ Autor ³ Alexandro da Silva    ³ Data ³ 12/07/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ CADASTRO DE LIMITE DE CREDITO                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

User Function VN0011()
	
	Private cCadastro := "Limite De Credito "
	Private aRotina   := {}
	Private	_aAliSC6
	
	Private _cGrAprov  := ""
	Private _nSdoLim   := _nSdoTit   := _nValor    := _nValLim  := 0
	Private	_cRiscoAnt := _cTipoAnt  := _cCheiaAnt := _cFicmAnt := _cDifAnt := ""
	Private	_cTesAnt   := _cTesFAnt  := Space(03)
	Private _cCNPJ     := Space(14)
	
	ATUSX6()
	
	_cGrAprov:= GETMV("VN_GRAPROV")
	
	SAL->(dbSetOrder(2))
	If SAL->(!dbSeek(xFilial() + _cGrAprov))
		MSGSTOP("Grupo Nao Cadastrado, Favor Contatar o Administrador do Sistema!")
		Return
	EndIf
	
	aAdd(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
	aAdd(aRotina,{"Visualizar","U_VN01101",0,2})
	aAdd(aRotina,{"Incluir"   ,"U_VN01101",0,3})
	aAdd(aRotina,{"Alterar"   ,"U_VN01101",0,4})
	aAdd(aRotina,{"Legenda"   ,"A410LEGEND",0,5})
	
	
	DbSelectArea("ZA6")
	DbSetOrder(1)
	DbGoTop()
	
	
	MBrowse(6,1,22,75,"ZA6",,,,,,)
	
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ VN01101  ³ Autor  ³ Alexandro da Silva     ³ Data ³08/11/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function VN01101(cAlias,nReg,_nOpcX)
	
	
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
	
	//_aCampos := {"ZA6_ITEM","ZA6_DTBLOQ","ZA6_LIBER","ZA6_DTSCI","ZA6_DTSINT","ZA6_VALOR","ZA6_PRAZO","ZA6_RISCO","ZA6_TIPO","ZA6_TES","ZA6_TESF","ZA6_GRPVEN","ZA6_FICMS","ZA6_INFORM","ZA6_USER","ZA6_USRLIB","ZA6_DTVIG","ZA6_SDOLIM","ZA6_SDOTIT"}
	_aCampos := {"ZA6_ITEM","ZA6_DTBLOQ","ZA6_LIBER","ZA6_DTSCI","ZA6_DTSINT","ZA6_VALOR","ZA6_PRAZO","ZA6_RISCO","ZA6_TIPO","ZA6_GRPVEN","ZA6_INFORM","ZA6_USER","ZA6_USRLIB","ZA6_DTVIG","ZA6_SDOLIM","ZA6_SDOTIT"}
	
	Private _lUsuar  := U_PXH042("VN0011",6,.F.)
	
	For AX:= 1 TO Len(_aCampos)
		dbSelectArea("Sx3")
		dbSetOrder(2)
		If dbSeek(_aCampos[AX])
			If _lUsuar
				//If _aCampos[AX] $ "ZA6_VALOR/ZA6_PRAZO/ZA6_RISCO/ZA6_TIPO/ZA6_TES/ZA6_TESF/ZA6_CHEIA/ZA6_FICMS/ZA6_DIFALI"
				If _aCampos[AX] $ "ZA6_VALOR/ZA6_PRAZO/ZA6_RISCO/ZA6_TIPO/ZA6_GRPVEN"
					SX3->(RecLock("SX3",.F.))
					SX3->X3_VISUAL:= "A"
					SX3->(MsUnLock())
				Endif
				
				AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
					x3_tamanho, x3_decimal,x3_valid,;
					x3_usado, x3_tipo, x3_arquivo, x3_context } )
			Else
				If _aCampos[AX] $ "ZA6_VALOR/ZA6_PRAZO/ZA6_RISCO/ZA6_TIPO/ZA6_GRPVEN"
					SX3->(RecLock("SX3",.F.))
					SX3->X3_VISUAL:="V"
					SX3->(MsUnLock())
				Endif
				
				AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
					x3_tamanho, x3_decimal,x3_valid,;
					x3_usado, x3_tipo, x3_arquivo, x3_context } )
			Endif
		Endif
	Next Ax
	
	Private _nPITEM   := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_ITEM"   } )
	Private _nPDTBLQ  := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_DTBLOQ" } )
	Private _nPSTATUS := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_LIBER"  } )
	Private _nPVALOR  := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_VALOR"  } )
	Private _nPPRAZO  := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_PRAZO"  } )
	Private _nPDTSCI  := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_DTSCI"  } )
	Private _nPDTSIN  := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_DTSINT" } )
	Private _nPDTVIG  := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_DTVIG"  } )
	Private _nPRISCO  := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_RISCO"  } )
	Private _nPTIPO   := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_TIPO"   } )
	Private _NPGRPVEN := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_GRPVEN" } )
	Private _nPINFORM := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_INFORM" } )
	Private _nPUSER   := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_USER"   } )
	Private _nPUSRLIB := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_USRLIB" } )
	Private _nPSdoLim := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_SDOLIM" } )
	Private _nPSdoTit := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_SDOTIT" } )
//	Private _nPTES    := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_TES"    } )
//	Private _nPTESF   := aScan( aHeader, { |x| Alltrim(x[2])== "ZA6_TESF"   } ) 
	
	
	If INCLUI
		
		_nOpcE := 3
		_nOpcG := 3
		_lEdit := .T.
		aCols  := {Array(Len(_aCampos)+1)}
		
		aCols[1,Len(_aCampos)+1]:=.F.
		For _ni:=1 to Len(_aCampos)
			If aHeader[_ni,2] = "ZA6_ITEM"
				aCols[1,_ni]:= "0001"
			Else
				aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
			Endif
		Next
		
		_cCliente := Space(6)
		_cLoja    := Space(2)
		_cNomCli  := Space(30)
		_nSdoLim  := 0
		_nSdoTit  := 0
	Else
		_cCliente := ZA6->ZA6_CLIENT
		_cLoja    := ZA6->ZA6_LOJA
		_nSdoLim  := ZA6->ZA6_SDOLIM
		_nSdoTit  := ZA6->ZA6_SDOTIT
		
		SA1->(dbSetorder(1))
		SA1->(dbSeek(xFilial("SA1") + _cCliente + _cLoja))
		
		_cNomCli := SA1->A1_NOME
		_cCNPJ   := SA1->A1_CGC
		
		aCols:= {}
		
		ZA6->(dbSetOrder(1))
		If ZA6->(dbSeek(xFilial("ZA6") + _cCliente + _cLoja ))
			
			_cChavZA6 := ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA
			
			While ZA6->(!Eof()) .And. _cChavZA6 == ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA
				
				AADD(aCols,Array(Len(_aCampos)+1))
				
				aCols[Len(aCols),_NPITEM]    := ZA6->ZA6_ITEM
				aCols[Len(aCols),_NPSTATUS]  := ZA6->ZA6_LIBER
				aCols[Len(aCols),_NPDTBLQ]   := ZA6->ZA6_DTBLOQ
				aCols[Len(aCols),_NPVALOR]   := ZA6->ZA6_VALOR
				aCols[Len(aCols),_NPPRAZO]   := ZA6->ZA6_PRAZO
				aCols[Len(aCols),_NPSDOTIT]  := ZA6->ZA6_SDOTIT
				aCols[Len(aCols),_NPSDOLIM]  := ZA6->ZA6_SDOLIM
				aCols[Len(aCols),_NPGRPVEN]  := ZA6->ZA6_GRPVEN
				aCols[Len(aCols),_NPTIPO]    := SA1->A1_TIPO
				aCols[Len(aCols),_NPRISCO]   := SA1->A1_RISCO
				aCols[Len(aCols),_NPDTSCI]   := SA1->A1_YBLQSCI
				aCols[Len(aCols),_NPINFORM]  := ZA6->ZA6_INFORM
				aCols[Len(aCols),_NPDTVIG]   := ZA6->ZA6_DTVIG
				aCols[Len(aCols),_NPUSER]    := ZA6->ZA6_USER
				aCols[Len(aCols),_NPUSRLIB]  := ZA6->ZA6_USRLIB
				
				aCols[Len(aCols),Len(_aCampos)+1]:=.F.
				
				If ZA6->ZA6_LIBER == "L"
					_nValLim := ZA6->ZA6_VALOR
				Endif
				
				ZA6->(dbSkip())
			EndDo
		Endif
		
		_lEdit  := .F.
		
	Endif
	
	cTitulo       := "Limite De Credito"
	cAliasGetD    := "ZA6"
	cLinOk        := "AllwaysTrue()"
	cTudOk        := "AllwaysTrue()"
	cFieldOk      := "AllwaysTrue()"
	
	_lRetMod2     := VN011_02(cTitulo,cAliasGetD,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)
	
	If _lRetMod2
		GravTab()
	Endif
	
	
	
Return


Static Function VN011_02(cTitulo,cAlias2,cLinOk,cTudOk,_nOpcE,_nOpcG,cFieldOk)
	
	Local _lRet83A, _nOpca := 0,cSaveMenuh,oDlg
	Local oCombo,oCliente,oLoja,oCond,oCodigo,oTpPedido
	Private aSize	  := MsAdvSize()
	Private aObjects  := {}
	Private aPosObj   := {}
	Private aSizeAut  := MsAdvSize()
	Private aButtons  := {}
	
	aadd(aButtons,{"POSCLI"   ,{|| a450F4Con(),Pergunte("MTA410",.F.)},"Posi‡„o de Cliente","Clientes" })
	
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
	@ 1.0,005 MSGET oCliente VAR _cCliente         When _lEdit F3 "SA1" VALID (!Empty(_cCliente) .And. ExistCpo("SA1",_cCliente) .And. ExistChav("ZA6",_cCliente + _cLoja ) ) PICTURE "@!" SIZE 30,10
	
	@ 1.0,010 Say "Loja: "
	@ 1.0,014 MSGET oLoja    VAR _cLoja            When _lEdit  VALID (!Empty(_cLoja) .And. ExistCpo("SA1",_cCliente+_cLoja) .And. ExistChav("ZA6",_cCliente + _cLoja) .And. VN011_07()) PICTURE "@!" SIZE 30,10
	
	@ 1.0,020 Say "Nome Cliente: "
	@ 1.0,025 MSGET oNomCli  VAR _cNomCli          When .F.     SIZE 120,10
	
	@ 1.0,045 Say "Cnpj: "
	@ 1.0,048 MSGET oCNPJ    VAR _cCNPJ            When .F.     SIZE 120,10
	
	nGetLin := aPosObj[3,1]
	
	oGetDados := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],_nOpcao,"U_VN011_05()","VN011_04","+ZA6_ITEM",.T.)
	
	ACTIVATE MSDIALOG oDlg centered ON INIT EnchoiceBar(oDlg,{||_nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),_nOpca := 0,oDlg:End()),_nOpca := 0)},{||oDlg:End()},,aButtons)
	
	_lRet := (_nOpca==1)
	
Return(_lRet)


Static Function VN011_04()
	
	Private _lRetorno := .t.
	
Return(_lRetorno)


User Function VN011_05()
	
	_aVerDup  := {}
	lOk       := .T.
	
	For AX := 1 to Len(aCols)
		
		_cStatus  := Acols[AX,_NPSTATUS]
		_nValor   := Acols[AX,_NPVALOR]
		
		_cFim := (Len(aHeader)+1)
		If aCols[AX,_cFim]
			If !Empty(_nValor)
				MSGSTOP("LINHA NAO PODE SER DELETADA!!")
				lOK := .F.
			Endif
		Else
			If _cStatus $ "L/B"
				Loop
			Endif
			
			If ASCAN( _aVerDup,{|x| x[1] == _cStatus }) == 0
				AADD( _aVerDup,{_cStatus})
			Else
				MSGSTOP(" Dados Ja lançado!!!")
				lOK := .F.
			Endif
			
			If Empty(_cStatus)
				If Acols[AX,_NPDTSCI] > Date()
					MSGSTOP(" Data do SCI superior a Data Atual!!!")
					lOK := .F.
				Endif
				//If Acols[AX,_NPDTSIN] > Date()
				//	MSGSTOP(" Data do SINTEGRA superior a Data Atual!!!")
				//	lOK := .F.
				//Endif
			Endif
		Endif
	Next
	
Return(lOk)


Static Function VN011_06()
	
	_cLoja  := SA1->A1_LOJA
	_cNomCli:= SA1->A1_NOME
	
	_cQ := " SELECT SUM(E1_SALDO) AS SALDO FROM "+RetSqlName("SE1")+" A WHERE A.D_E_L_E_T_ = '' "
	_cQ += " AND E1_CLIENTE = '"+_cCliente+"' AND E1_LOJA = '"+_cLoja+"' AND E1_TIPO NOT IN ('NCC','RA') "
	_cQ += " GROUP BY E1_CLIENTE,E1_LOJA"
	_cQ += " ORDER BY E1_CLIENTE,E1_LOJA"
	
	TCQUERY _cQ NEW ALIAS "ZZ"
	
	_nSdoTit := ZZ->SALDO
	
	ZZ->(dbCloseArea())
	
Return(_cLoja)


Static Function VN011_07()
	
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+_cCliente + _cLoja))
	
	_cQ := " SELECT SUM(E1_SALDO) AS SALDO FROM "+RetSqlName("SE1")+" A WHERE A.D_E_L_E_T_ = '' "
	_cQ += " AND E1_CLIENTE = '"+_cCliente+"' AND E1_LOJA = '"+_cLoja+"' AND E1_TIPO NOT IN ('NCC','RA') "
	_cQ += " GROUP BY E1_CLIENTE,E1_LOJA"
	_cQ += " ORDER BY E1_CLIENTE,E1_LOJA"
	
	TCQUERY _cQ NEW ALIAS "ZZ"
	
	_nSdoTit := ZZ->SALDO
	
	ZZ->(dbCloseArea())
	
	_cNomCli:= SA1->A1_NOME
	_cCNPJ  := SA1->A1_CGC
	
	For AX := 1 to Len(aCols)
		
		_cStatus  := Acols[AX,_NPSTATUS]
		_nValor   := Acols[AX,_NPVALOR]
		
		_cFim := (Len(aHeader)+1)
		If !aCols[AX,_cFim]
			Acols[AX,_NPPRAZO]  := SA1->A1_COND
			Acols[AX,_NPRISCO]  := SA1->A1_RISCO
			Acols[AX,_NPTIPO]   := SA1->A1_TIPO
			Acols[AX,_nPGRPVEN] := SA1->A1_GRPVEN
			Acols[AX,_NPSDOTIT] := _nSdoTit
			Acols[AX,_NPVALOR]  := SA1->A1_LC
			Acols[AX,_NPSDOLIM] := SA1->A1_LC - _nSdoTit
		Endif
	Next
	
	GetdRefresh()
	
Return(_cNomCli)




Static Function GravTab()
	
	
	If INCLUI
		
		_lGravou := .F.
		_lBloq   := .F.
		
		For AX:= 1 To Len(ACOLS)
			
			_cFim := (Len(aHeader)+1)
			If !aCols[AX,_cFim]
				_lGravou := .T.
				ZA6->(RecLock("ZA6",.T.))
				ZA6->ZA6_FILIAL := xFilial("ZA6")
				ZA6->ZA6_ITEM   := ACOLS[AX,_NPITEM]
				ZA6->ZA6_CLIENT := _cCliente
				ZA6->ZA6_LOJA   := _cLoja
				ZA6->ZA6_NOMCLI := _cNomCli
				ZA6->ZA6_VALOR  := ACOLS[AX,_NPVALOR]
				ZA6->ZA6_PRAZO  := ACOLS[AX,_NPPRAZO]
				ZA6->ZA6_SDOLIM := _nSdoLim
				ZA6->ZA6_SDOTIT := _nSdoTit
				ZA6->ZA6_DTVIG  := ACOLS[AX,_NPDTVIG]
				ZA6->ZA6_LIBER  := ACOLS[AX,_NPSTATUS]
				ZA6->ZA6_DTBLOQ := ACOLS[AX,_NPDTBLQ]
				ZA6->ZA6_TIPO   := ACOLS[AX,_NPTIPO]
				ZA6->ZA6_RISCO	:= ACOLS[AX,_NPRISCO]
				ZA6->ZA6_GRPVEN := ACOLS[AX,_NPGRPVEN]
				ZA6->ZA6_DTSCI  := aCols[AX,_NPDTSCI]
				ZA6->ZA6_INFORM := aCols[AX,_NPINFORM]
				
				If Empty(ZA6->ZA6_LIBER)
					ZA6->ZA6_USER   := cUsername
				Else
					ZA6->ZA6_USER   := aCols[AX,_NPUSER]
				Endif
				ZA6->(MsUnlock())
				
				_lLibera  := .F.
				
				If Empty(aCols[AX,_nPStatus]) .And. ACOLS[AX,_NPVALOR] > 1
					SCR->(dbOrderNickName("INDSCR1"))
					If SCR->(dbSeek(xFilial("SCR")+"05"+ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA + Space(08)))
						
						_cChavSCR := SCR->CR_TIPO + SCR->CR_YCLIENT + SCR->CR_YLOJA + DTOS(SCR->CR_DATALIB)
						/*
						ZAH->(dbSetOrder(6))
						If ZAH->(dbSeek(xFilial("ZAH")+ _cChavSCR  ))
							_cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
							_cCrTipo  := SCR->CR_TIPO
							_cDocSCR  := SCR->CR_NUM
							
							_cCq := " DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+SCR->CR_NUM+"' AND ZAH_TIPO = '"+SCR->CR_TIPO+"' "
							_cCq += " AND ZAH_YCLIEN = '"+SCR->CR_YCLIENT +"' AND ZAH_YLOJA   = '"+SCR->CR_YLOJA+"' "
							_cCq += " AND ZAH_DATALI  = '"+DTOS(SCR->CR_DATALIB)+ "' "
							TcSqlExec(_cCq)
						Endif
						*/
						While SCR->(!Eof())	.And. _cChavSCR == SCR->CR_TIPO + SCR->CR_YCLIENT + SCR->CR_YLOJA + DTOS(SCR->CR_DATALIB)
							
							SCR->(RecLock("SCR",.F.))
							SCR->(dbDelete())
							SCR->(MsUnlock())
							
							SCR->(dbSkip())
						EndDo
					Endif
					
					_cQ := " SELECT MAX(CR_NUM) AS CR_NUM FROM "+RetSqlName("SCR")+" WHERE D_E_L_E_T_ = '' "
					_cQ += " AND CR_FILIAL = '"+xFilial("SCR")+"' AND CR_TIPO = '05' "
					
					TCQUERY _cQ NEW ALIAS "ZZ"
					
					If Empty(ZZ->CR_NUM)
						_cNum := "000001"
					Else
						_cNum := StrZero(Val(ZZ->CR_NUM)+1,6)
					Endif
					
					ZZ->(dbCloseArea())
					
					lFirstNiv   := .T.
					cAuxNivel   := ""
					_lLibera    := .T.
					
					SAL->(dbSetOrder(2))
					If SAL->(dbSeek(xFilial()+_cGrAprov))
						
						While SAL->(!Eof()) .And. xFilial("SAL")+_cGrAprov == SAL->AL_FILIAL+SAL->AL_COD
							
							If lFirstNiv
								cAuxNivel := SAL->AL_NIVEL
								lFirstNiv := .F.
							EndIf
							
							SCR->(Reclock("SCR",.T.))
							SCR->CR_FILIAL	:= xFilial("SCR")
							SCR->CR_NUM		:= _cNum
							SCR->CR_TIPO	:= "05"
							SCR->CR_NIVEL	:= SAL->AL_NIVEL
							SCR->CR_USER	:= SAL->AL_USER
							SCR->CR_APROV	:= SAL->AL_APROV
							SCR->CR_STATUS	:= "02"
							SCR->CR_EMISSAO := dDataBase
							SCR->CR_MOEDA	:= 1
							SCR->CR_TXMOEDA := 1
							SCR->CR_OBS     := Alltrim(SM0->M0_NOME) +" - LIMITE DE CREDITO"
							SCR->CR_TOTAL	:= ZA6->ZA6_VALOR
							SCR->CR_YCLIENT := ZA6->ZA6_CLIENT
							SCR->CR_YLOJA   := ZA6->ZA6_LOJA
							SCR->CR_YCODTAB := ZA6->ZA6_PRAZO
							SCR->(MsUnlock())
							/*
							ZAH->(RecLock("ZAH",.T.))
							ZAH->ZAH_FILIAL:= SCR->CR_FILIAL
							ZAH->ZAH_NUM   := SCR->CR_NUM
							ZAH->ZAH_TIPO  := SCR->CR_TIPO
							ZAH->ZAH_NIVEL := SCR->CR_NIVEL
							ZAH->ZAH_USER  := SCR->CR_USER
							ZAH->ZAH_APROV := SCR->CR_APROV
							ZAH->ZAH_STATUS:= SCR->CR_STATUS
							ZAH->ZAH_TOTAL := SCR->CR_TOTAL
							ZAH->ZAH_EMISSA:= SCR->CR_EMISSAO
							ZAH->ZAH_MOEDA := SCR->CR_MOEDA
							ZAH->ZAH_TXMOED:= SCR->CR_TXMOEDA
							ZAH->ZAH_OBS   := SCR->CR_OBS
							ZAH->ZAH_YREFCI:= SCR->CR_YREFCIF
							ZAH->ZAH_YPRCCI:= SCR->CR_YPRCCIF
							ZAH->ZAH_TOTAL := SCR->CR_TOTAL
							ZAH->ZAH_YREFFO:= SCR->CR_YREFFOB
							ZAH->ZAH_YPRCFO:= SCR->CR_YPRCFOB
							ZAH->ZAH_YREFGE:= SCR->CR_YREFGER
							ZAH->ZAH_YPRCGE:= SCR->CR_YPRCGER
							ZAH->ZAH_YCLIEN:= SCR->CR_YCLIENT
							ZAH->ZAH_YLOJA := SCR->CR_YLOJA
							ZAH->ZAH_YPRODU:= SCR->CR_YPRODUT
							ZAH->ZAH_YOBRA := SCR->CR_YOBRA
							ZAH->ZAH_YCODTA:= SCR->CR_YCODTAB
							ZAH->(MsUnlock())
							
							ZAH->(MsUnlock())
							*/
							SAL->(dbSkip())
						EndDo
					EndIf
				Endif
				
				_aAliZA6 := ZA6->(GetArea())
				_cCliente:= ZA6->ZA6_CLIENT
				_cLoja   := ZA6->ZA6_LOJA
				
				ZA6->(dbSetOrder(1))
				If ZA6->(dbSeek(xFilial("ZA6") + _cCliente + _cLoja + "L" ))
					ZA6->(RecLock("ZA6",.F.))
					ZA6->ZA6_LIBER  := "B"
					ZA6->ZA6_DTBLOQ := Date()
					ZA6->(MsUnLock())
				Endif
				
				RestArea(_aAliZA6)
				
				If !_lLibera
					ZA6->(RecLock("ZA6",.F.))
					ZA6->ZA6_LIBER   := "L"
					ZA6->ZA6_DTBLOQ  := CTOD("")
					ZA6->ZA6_DTVIG   := Date()
					//ZA6->ZA6_USRLIB  := Alltrim(Substr(cUsuario,7,15))
					ZA6->ZA6_USRLIB  := cUsername
					ZA6->(MsUnLock())
					
					SA1->(dbSetOrder(1))
					If SA1->(dbSeek(xFilial("SA1")+ ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA))
						SA1->(RecLock("SA1",.F.))
						SA1->A1_COND   := ZA6->ZA6_PRAZO
						SA1->A1_LC     := ZA6->ZA6_VALOR
						SA1->A1_TIPO   := ZA6->ZA6_TIPO
						SA1->A1_RISCO  := ZA6->ZA6_RISCO
						//SA1->A1_YDIFALI:= ZA6->ZA6_DIFALI
//						SA1->A1_YFICMS := ZA6->ZA6_FICMS
						SA1->A1_GRPVEN := ZA6->ZA6_GRPVEN
						//SA1->A1_YCHEIA := ZA6->ZA6_CHEIA
						SA1->A1_YBLQSCI:= ZA6->ZA6_DTSCI
						SA1->A1_YBLQSIN:= ZA6->ZA6_DTSINT
						SA1->A1_YLIB   := "S"
						SA1->(MsUnlock())
					Endif
				Else
					_lBloq := .T.
				Endif
			Endif
		Next Ax
		
		If _lBloq
			MSGINFO("LIMITE BLOQUEADO, FAVOR SOLICITAR LIBERACAO!!!")
		Else
			MSGINFO("LIMITE LIBERADO!!!")
		Endif
		
	ElseIf ALTERA
		
		ZA6->(dbSetOrder(1))
		If ZA6->(dbSeek(xFilial("ZA6") + _cCliente + _cLoja ))
			
			_cChavZA6 := ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA
			
			While ZA6->(!Eof()) .And. _cChavZA6 == ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA
				
				ZA6->(RecLock("ZA6",.F.))
				ZA6->(dbDelete())
				ZA6->(MsUnlock())
				
				ZA6->(dbSkip())
			EndDo
		Endif
		
		_lGravou   := .F.
		_lBloq     := .F.
		_nValAnt   := 0
		_lValida   := .T.
		_cPrazoAnt := Space(03)
		_cRiscoAnt := _cTipoAnt  := _cCheiaAnt := _cFicmAnt := _cDifAnt := ""
		_cTesAnt   := _cTesFAnt  := Space(03)
		
		For AX:= 1 To Len(ACOLS)
			
			_cFim := (Len(aHeader)+1)
			If aCols[AX,_cFim]
			Else
				_lGravou := .T.
				ZA6->(RecLock("ZA6",.T.))
				ZA6->ZA6_FILIAL := xFilial("ZA6")
				ZA6->ZA6_ITEM   := ACOLS[AX,_NPITEM]
				ZA6->ZA6_CLIENT := _cCliente
				ZA6->ZA6_LOJA   := _cLoja
				ZA6->ZA6_NOMCLI := _cNomCli
				ZA6->ZA6_VALOR  := ACOLS[AX,_NPVALOR]
				If ACOLS[AX,_NPVALOR] = 0.01
					ZA6->ZA6_PRAZO  := "100"
				Else
					ZA6->ZA6_PRAZO  := ACOLS[AX,_NPPRAZO]
				Endif
				ZA6->ZA6_DTVIG  := ACOLS[AX,_NPDTVIG]
				ZA6->ZA6_LIBER  := ACOLS[AX,_NPSTATUS]
				ZA6->ZA6_DTBLOQ := ACOLS[AX,_NPDTBLQ]
				ZA6->ZA6_SDOLIM := ACOLS[AX,_NPSDOLIM]
				ZA6->ZA6_SDOTIT := ACOLS[AX,_NPSDOTIT]
				ZA6->ZA6_TIPO   := ACOLS[AX,_NPTIPO]
				ZA6->ZA6_RISCO	:= ACOLS[AX,_NPRISCO]
				//ZA6->ZA6_FICMS  := aCols[AX,_NPFICMS]
				ZA6->ZA6_GRPVEN	:= ACOLS[AX,_NPGRPVEN]
				ZA6->ZA6_DTSCI  := aCols[AX,_NPDTSCI]
				ZA6->ZA6_DTSINT := aCols[AX,_NPDTSIN]
				ZA6->ZA6_INFORM := aCols[AX,_NPINFORM]
				ZA6->ZA6_USRLIB := aCols[AX,_NPUSRLIB]
				If Empty(ZA6->ZA6_LIBER)
					ZA6->ZA6_USER   := cUsername
				Else
					ZA6->ZA6_USER   := aCols[AX,_NPUSER]
				Endif
				ZA6->(MsUnlock())
				
				If ACOLS[N,_NPITEM] == SOMA1(ACOLS[AX,_NPITEM])
					_nValAnt   := ACOLS[AX,_NPVALOR]
					_cPrazoAnt := ACOLS[AX,_NPPRAZO]
					_cRiscoAnt := ACOLS[AX,_NPRISCO]
					_cTipoAnt  := ACOLS[AX,_NPTIPO]
//					_cTESANT   := ACOLS[AX,_NPTES]
//					_cTesFAnt  := ACOLS[AX,_NPTESF]
				Endif
				
				If ZA6->ZA6_LIBER $ "B"
					Loop
				Endif
				
				_lLibera  := .F.
				
				If Empty(ZA6->ZA6_LIBER)
					If _nValAnt >= ACOLS[AX,_NPVALOR]
						_lValida := .F.
					Endif
					
					If ACOLS[AX,_NPVALOR] < 1
						_lValida := .F.
					ElseIf _cPrazoAnt != ACOLS[AX,_NPPRAZO]
						_lValida := .T.
					ElseIf _cRiscoAnt != ACOLS[AX,_NPRISCO]
						If ACOLS[AX,_NPRISCO] == "S"
							_lValida := .T.
						Else
							_lValida := .F.
						Endif
					ElseIf _cTipoAnt  != ACOLS[AX,_NPTIPO]
						_lValida := .F.
					Endif
				Endif
				
				If Empty(aCols[AX,_nPStatus]) .And. _lValida
					SCR->(dbOrderNickName("INDSCR1"))
					If SCR->(dbSeek(xFilial("SCR")+"05"+ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA + Space(08)))
						
						_cChavSCR := SCR->CR_TIPO + SCR->CR_YCLIENT + SCR->CR_YLOJA + DTOS(SCR->CR_DATALIB)
						/*
						ZAH->(dbSetOrder(6))
						If ZAH->(dbSeek(xFilial("ZAH")+ _cChavSCR  ))
							_cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
							_cCrTipo  := SCR->CR_TIPO
							_cDocSCR  := SCR->CR_NUM
							
							_cCq := " DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+SCR->CR_NUM+"' AND ZAH_TIPO = '"+SCR->CR_TIPO+"' "
							_cCq += " AND ZAH_YCLIEN = '"+SCR->CR_YCLIENT +"' AND ZAH_YLOJA   = '"+SCR->CR_YLOJA+"' "
							_cCq += " AND ZAH_DATALI  = '"+DTOS(SCR->CR_DATALIB)+ "' "
							TcSqlExec(_cCq)
						Endif
						*/
						While SCR->(!Eof())	.And. _cChavSCR == SCR->CR_TIPO + SCR->CR_YCLIENT + SCR->CR_YLOJA + DTOS(SCR->CR_DATALIB)
							
							SCR->(RecLock("SCR",.F.))
							SCR->(dbDelete())
							SCR->(MsUnlock())
							
							SCR->(dbSkip())
						EndDo
					Endif
					
					_cQ := " SELECT MAX(CR_NUM) AS CR_NUM FROM "+RetSqlName("SCR")+" WHERE D_E_L_E_T_ = '' "
					_cQ += " AND CR_FILIAL = '"+xFilial("SCR")+"' AND CR_TIPO = '05' "
					
					TCQUERY _cQ NEW ALIAS "ZZ"
					
					If Empty(ZZ->CR_NUM)
						_cNum := "000001"
					Else
						_cNum := StrZero(Val(ZZ->CR_NUM)+1,6)
					Endif
					
					ZZ->(dbCloseArea())
					
					lFirstNiv   := .T.
					cAuxNivel   := ""
					_lLibera    := .T.
					
					SAL->(dbSetOrder(2))
					If SAL->(dbSeek(xFilial()+_cGrAprov))
						
						While SAL->(!Eof()) .And. xFilial("SAL")+_cGrAprov == SAL->AL_FILIAL+SAL->AL_COD
							
							If lFirstNiv
								cAuxNivel := SAL->AL_NIVEL
								lFirstNiv := .F.
							EndIf
							
							SCR->(Reclock("SCR",.T.))
							SCR->CR_FILIAL	:= xFilial("SCR")
							SCR->CR_NUM		:= _cNum
							SCR->CR_TIPO	:= "05"
							SCR->CR_NIVEL	:= SAL->AL_NIVEL
							SCR->CR_USER	:= SAL->AL_USER
							SCR->CR_APROV	:= SAL->AL_APROV
							SCR->CR_STATUS	:= "02"//IIF(SAL->AL_NIVEL == cAuxNivel,"02","01")
							SCR->CR_EMISSAO := dDataBase
							SCR->CR_MOEDA	:= 1
							SCR->CR_TXMOEDA := 1
							SCR->CR_OBS     := Alltrim(SM0->M0_NOME) +" - LIMITE DE CREDITO"
							SCR->CR_TOTAL	:= ZA6->ZA6_VALOR
							SCR->CR_YCLIENT := ZA6->ZA6_CLIENT
							SCR->CR_YLOJA   := ZA6->ZA6_LOJA
							SCR->CR_YCODTAB := ZA6->ZA6_PRAZO
							SCR->(MsUnlock())
							
							/*
							ZAH->(RecLock("ZAH",.T.))
							ZAH->ZAH_FILIAL:= SCR->CR_FILIAL
							ZAH->ZAH_NUM   := SCR->CR_NUM
							ZAH->ZAH_TIPO  := SCR->CR_TIPO
							ZAH->ZAH_NIVEL := SCR->CR_NIVEL
							ZAH->ZAH_USER  := SCR->CR_USER
							ZAH->ZAH_APROV := SCR->CR_APROV
							ZAH->ZAH_STATUS:= SCR->CR_STATUS
							ZAH->ZAH_TOTAL := SCR->CR_TOTAL
							ZAH->ZAH_EMISSA:= SCR->CR_EMISSAO
							ZAH->ZAH_MOEDA := SCR->CR_MOEDA
							ZAH->ZAH_TXMOED:= SCR->CR_TXMOEDA
							ZAH->ZAH_OBS   := SCR->CR_OBS
							ZAH->ZAH_YREFCI:= SCR->CR_YREFCIF
							ZAH->ZAH_YPRCCI:= SCR->CR_YPRCCIF
							ZAH->ZAH_TOTAL := SCR->CR_TOTAL
							ZAH->ZAH_YREFFO:= SCR->CR_YREFFOB
							ZAH->ZAH_YPRCFO:= SCR->CR_YPRCFOB
							ZAH->ZAH_YREFGE:= SCR->CR_YREFGER
							ZAH->ZAH_YPRCGE:= SCR->CR_YPRCGER
							ZAH->ZAH_YCLIEN:= SCR->CR_YCLIENT
							ZAH->ZAH_YLOJA := SCR->CR_YLOJA
							ZAH->ZAH_YPRODU:= SCR->CR_YPRODUT
							ZAH->ZAH_YOBRA := SCR->CR_YOBRA
							ZAH->ZAH_YCODTA:= SCR->CR_YCODTAB
							ZAH->(MsUnlock())
							*/
							SAL->(dbSkip())
						EndDo
					EndIf
				Endif
				
				_aAliZA6 := ZA6->(GetArea())
				_cCliente:= ZA6->ZA6_CLIENT
				_cLoja   := ZA6->ZA6_LOJA
				
				ZA6->(dbSetOrder(1))
				If ZA6->(dbSeek(xFilial("ZA6") + _cCliente + _cLoja + "L" ))
					ZA6->(RecLock("ZA6",.F.))
					ZA6->ZA6_LIBER  := "B"
					ZA6->ZA6_DTBLOQ := Date()
					ZA6->(MsUnLock())
				Endif
				
				RestArea(_aAliZA6)
				
				If !_lLibera
					ZA6->(RecLock("ZA6",.F.))
					If Empty(ZA6->ZA6_LIBER)
						//ZA6->ZA6_USRLIB  := Alltrim(Substr(cUsuario,7,15))
						ZA6->ZA6_USRLIB  := cUsername
					Endif
					ZA6->ZA6_LIBER   := "L"
					ZA6->ZA6_DTVIG   := Date()
					ZA6->ZA6_DTBLOQ  := CTOD("")
					//ZA6->ZA6_USRLIB  := Alltrim(Substr(cUsuario,7,15))
					ZA6->(MsUnLock())
					
					SA1->(dbSetOrder(1))
					If SA1->(dbSeek(xFilial("SA1")+ ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA))
						SA1->(RecLock("SA1",.F.))
						SA1->A1_COND   := ZA6->ZA6_PRAZO
						SA1->A1_LC     := ZA6->ZA6_VALOR
						SA1->A1_TIPO   := ZA6->ZA6_TIPO
						SA1->A1_RISCO  := ZA6->ZA6_RISCO
//						SA1->A1_YFICMS := ZA6->ZA6_FICMS
						SA1->A1_GRPVEN := ZA6->ZA6_GRPVEN
//						SA1->A1_YBLQSIN:= ZA6->ZA6_DTSINT
						SA1->A1_YLIB   := "S"
						SA1->(MsUnlock())
					Endif
				Else
					_lBloq := .T.
				Endif
			Endif
		Next Ax
		
		If _lBloq
			MSGINFO("LIMITE BLOQUEADO, FAVOR SOLICITAR LIBERACAO!!!")
		Else
			MSGINFO("LIMITE LIBERADO!!!")
		Endif
	Endif
	
Return

User Function VN011_08()
	
	_aAliOri := GetArea()
	_cRet    := ACOLS[N,_NPDTSCI]
	
	If _cRet > Date()
		MSGINFO("Data Do SCI Superior a Data Atual!!")
		Return(CTOD(""))
	Endif
	
	If N > 1
		ACOLS[N,_NPPRAZO] 	:= ACOLS[N-1,_NPPRAZO]
		ACOLS[N,_NPVALOR] 	:= ACOLS[N-1,_NPVALOR]
		ACOLS[N,_NPTIPO]  	:= ACOLS[N-1,_NPTIPO]
		ACOLS[N,_NPRISCO] 	:= ACOLS[N-1,_NPRISCO]
		ACOLS[N,_NPGRPVEN] 	:= ACOLS[N-1,_NPGRPVEN]
	Else
		ACOLS[N,_NPTIPO]  	:= SA1->A1_TIPO
		ACOLS[N,_NPRISCO] 	:= SA1->A1_RISCO
		ACOLS[N,_NPGRPVEN] 	:= SA1->A1_GRPVEN
	Endif
	
	_nValor  := ACOLS[N,_NPVALOR]
	
	_cQ := " SELECT SUM(E1_SALDO) AS SALDO FROM "+RetSqlName("SE1")+" A WHERE A.D_E_L_E_T_ = '' "
	_cQ += " AND E1_CLIENTE = '"+_cCliente+"' AND E1_LOJA = '"+_cLoja+"' AND E1_TIPO NOT IN ('NCC','RA') "
	_cQ += " GROUP BY E1_CLIENTE,E1_LOJA"
	_cQ += " ORDER BY E1_CLIENTE,E1_LOJA"
	
	TCQUERY _cQ NEW ALIAS "ZZ"
	
	_nSdoTit := ZZ->SALDO
	
	ZZ->(dbCloseArea())
	
	_nSdoLim := _nValor - _nSdoTit
	
	ACOLS[N,_NPSDOLIM] := _nSdoLim
	ACOLS[N,_NPSDOTIT] := _nSdoTit
	_cCond := Space(03)
	
	For AX:= 1 To Len(ACOLS)
		
		_cFim := (Len(aHeader)+1)
		If !aCols[AX,_cFim]
			If ACOLS[N,_NPITEM] == SOMA1(ACOLS[AX,_NPITEM])
				_cCond := ACOLS[AX,_NPPRAZO]
			Endif
		Endif
	Next AX
	
	ACOLS[N,_NPPRAZO] 	:= _cCond
	
	If Alltrim(UPPER(FunName())) $ "VN0011"
		If N > 1
			ACOLS[N,_NPVALOR] 	:= ACOLS[N-1,_NPVALOR]
			ACOLS[N,_NPTIPO]  	:= ACOLS[N-1,_NPTIPO]
			ACOLS[N,_NPRISCO] 	:= ACOLS[N-1,_NPRISCO]
			ACOLS[N,_NPGRPVEN] 	:= ACOLS[N-1,_NPGRPVEN]
			ACOLS[N,_NPDTSCI]   := ACOLS[N-1,_NPDTSCI]
		Endif
	Endif
	
	RestArea(_aAliOri)
	
Return(_cRet)

Static Function ATUSX6()
	
	asx62:= {}
	
	//            "X6_FIL","X6_VAR    ","X6_TIPO","X6_DESCRIC"                                        ,"X6_DSCSPA","X6_DSCENG","X6_DESC1"                                          ,"X6_DSCSPA1","X6_DSCENG1","X6_DESC2","X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA","X6_CONTENG","X6_PROPRI"
	//aEstrut := {"X6_FIL","X6_VAR"    ,"X6_TIPO","X6_DESCRIC"                                        ,"X6_DSCSPA","X6_DSCENG","X6_DESC1"                                          ,"X6_DSCSPA1","X6_DSCENG1","X6_DESC2","X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_PROPRI"}
	aAdd(asx62,  {"      ","VN_GRAPROV","C"      ,"Grupo de Aprovacao Para Rotinas Customizadas      ","         ","         ","                                                  ",""          ,""          ,"        ",""          ,""          ,"000099"    ,""          ,""          ,"U"})
	
	U_CRIASX6(asx62)
	
Return
