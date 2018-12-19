#Include "TOTVS.CH"
#Include "TOPCONN.CH"
#INCLUDE "FWPrintSetup.ch"

/*
Programa	: MZ0146
Autor		: Fabiano da Silva
Data		: 20/02/14
Descrição	: Controle de Tele-Cobranças
*/

User Function MZ0146()

	lUser := u_ChkAcesso("MZ0146",6,.F.) // ZZZ_ESPEC1

	AtuSX1()

	If !Pergunte("MZ0146",.T.)
		Return
	Endif

	Private oLayer  	:= FWLayer():new()
	Private aCoors  	:= FWGetDialogSize( oMainWnd )
	Private oDlgPrinc
	Private oPanel1, oPanel2, oPanel3, oPanel4
	Private aHead1 		:= {}
	Private aListFil1  	:= {}
	Private aListFil2  	:= {}
	Private oListArq1
	Private oListArq2
	Private _cSeek      := Space(6)
	Private nUsad3  	:= 0
	Private oGetDad3
	//	Private _nSaldo 	:= _nPerMulta := _nMulta := _nPerJuros := _nJuros := _nDespesas := _nTotal := 0 // MARCUS
	//Private _nPerMulta 	:= 2                                                                            // MARCUS
	//Private _nPerJuros 	:= 8                                                                            // MARCUS

	Private _nPerMulta 	:= GETMV("MZ_MULTA")
	Private _nPerJuros 	:= GETMV("MZ_JUROS")

	Private _nSaldo 	:= _nMulta := _nJuros := _nDespesas := _nTotal := 0	                            // MARCUS
	Private _oSaldo,_oPerMulta,_oMulta,_oPerJuros,_oJuros,_oDespesas,_oTotal,_oDtBase
	Private _dDtBase	:= dDataBase
	Private _lEnt 		:= .F.
	Private _cCliLj 	:= SPACE(08)
	Private _cDuplic 	:= ''
	Private _nCont      := 0
	Private lSortOrd 	:= .F.

	Private _n01  		:= 35 //30% da tela
	Private _n02  		:= 20 //30% da tela
	Private _n03  		:= 20 //20% da tela
	Private _n04  		:= 25 //20% da tela

	Private aHead3 		:= {}
	Private acols3 		:= {}
	Private _lVM		:= .F.
	Private _lVJ		:= .F.

	Define MsDialog oDlgPrinc Title 'Controle de Tele-Cobranças' From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel

	oLayer:init(oDlgPrinc,.F.)//Cria as colunas do Layer

	oLayer:AddLine( '01L' , _n01 , .F. )
	oLayer:AddLine( '02L' , _n02 , .F. )
	oLayer:AddLine( '03L' , _n03 , .F. )
	oLayer:AddLine( '04L' , _n04 , .F. )

	oLayer:AddCollumn( '01C' , 100, .F., '01L' )
	oPanel1 := oLayer:GetColPanel( '01C', '01L' )
	oLayer:AddCollumn( '02C' , 100, .F., '02L' )
	oPanel2 := oLayer:GetColPanel( '02C', '02L' )
	oLayer:AddCollumn( '03C' , 100, .F., '03L' )
	oPanel3 := oLayer:GetColPanel( '03C', '03L' )
	oLayer:AddCollumn( '04C' , 100, .F., '04L' )
	oPanel4 := oLayer:GetColPanel( '04C', '04L' )

	Panel01(oPanel1)

	If Empty(aListFil1)
		oDlgPrinc:End()
		Return
	Endif

	Panel02(oPanel2)
	Panel03(oPanel3)
	Panel04(oPanel4)

	bOk 		:= "{ || U_MZ146B(@aListFil1,@oListArq1,@aListFil2,@oListArq2),oDlgPrinc:End() }"
	bCancel 	:= "{ || oDlgPrinc:End() }"

	ACTIVATE MSDIALOG oDlgPrinc CENTERED ON INIT EnchoiceBar(oDlgPrinc,&(bOk),&(bCancel))

Return



Static Function Panel01( oPanel1 )

	Local cTitulo  := ""			// Titulo da FormBatch
	Local cList    := ""			// Variavel auxiliar para montagem da ListBox
	Local nOpc     := 0				// Opcao selecionada pelo usuario na FormBatch
	Local oOk     					// Objeto referente a marca da linha da ListBox quando marcada
	Local oNo     					// Objeto referente a marca da linha da ListBox quando desmarcada

	oScroll1 := TScrollArea():New(oPanel1,0,0,100,36,.T.,.T.,.T.)
	oScroll1:Align := CONTROL_ALIGN_TOP

	@ 000,000 MSPANEL oPanel1A OF oScroll1 SIZE 640,100// 143,247

	oScroll1:SetFrame( oPanel1A )

	oOk  := LoadBitmap(GetResources(), "LBOK")
	oNo  := LoadBitmap(GetResources(), "LBNO")

	cTitulo := "Seleciona o Cliente"

	nOpc:= 0

	MZ146A()

	If Empty(aListFil1)

		ApMsgStop("Não existe dados para os Parâmetros Selecionados.","Atenção")
		Return

	Else

		@ 001, 005 Say 'Procurar:' 	Size 025, 008 Of oPanel1A Pixel
		@ 001, 035 MsGet _cSeek	   	Size 025, 008 Of oPanel1A Pixel

		DEFINE SBUTTON oBtn1 FROM 001,075 TYPE 11 ACTION PesqCpo(_cSeek,@aListFil1,@oListArq1,3) Message "Pesquisando o Cliente" ENABLE Of oPanel1A
		oBtn1:cCaption := 'Localizar'
		oBtn1:cToolTip := 'Localizar'

		DEFINE SBUTTON oBtn1 FROM 001,110 TYPE 15 ACTION MZ146D(aListFil1) MESSAGE "Visualizar Cliente" ENABLE Of oPanel1A
		oBtn1:cCaption := 'Cliente'
		oBtn1:cToolTip := 'Cliente'

		DEFINE SBUTTON oBtn1 FROM 001,145 TYPE 15 ACTION MZ146E(aListFil2,oListArq2) MESSAGE "Imprimir Boleto" ENABLE Of oPanel1A
		oBtn1:cCaption := 'Boleto'
		oBtn1:cToolTip := 'Boleto'

		DEFINE SBUTTON oBtn1 FROM 001,180 TYPE 15 ACTION U_MZ0162(_nTotal,_nSaldo) MESSAGE "Gerar Fatura" ENABLE Of oPanel1A
		oBtn1:cCaption := 'Fatura'
		oBtn1:cToolTip := 'Fatura'

		DEFINE SBUTTON oBtn1 FROM 001,215 TYPE 15 ACTION U_MZ0182(aListFil2[oListArq2:nAt,3], aListFil2[oListArq2:nAt,4],aListFil2[oListArq2:nAt,22]) MESSAGE "Gerar Danfe" ENABLE Of oPanel1A
		oBtn1:cCaption := 'Danfe'
		oBtn1:cToolTip := 'Danfe'

		DEFINE SBUTTON oBtn1 FROM 001,250 TYPE 15 ACTION MZ146F(aListFil2[oListArq2:nAt,22],aListFil2[oListArq2:nAt,3], aListFil2[oListArq2:nAt,4],aListFil2[oListArq2:nAt,5],aListFil2[oListArq2:nAt,6]) MESSAGE "Título" ENABLE Of oPanel1A
		oBtn1:cCaption := 'Título'
		oBtn1:cToolTip := 'Contas a Receber'

		@ 13,3 LISTBOX  oListArq1 VAR cList FIELDS HEADER "", "Filial","Codigo","Loja","Nome","Saldo","Telefone","Celular SMS","E-mail Cobr.";
		SIZE 660, 083 OF oPanel1A PIXEL ;//SIZE 660, 083 OF oPanel1A PIXEL ;
		On DBLCLICK ( _aListBkp := aClone(aListFil1) , ;
		If(oListArq1:ColPos==7, lEditCell( aListFil1, oListArq1, "@9 ", oListArq1:ColPos ).And. UpdCli(@aListFil1,@oListArq1,"A1_TEL",7,_aListBkp),;
		If(oListArq1:ColPos==8, lEditCell( aListFil1, oListArq1, "@9 ", oListArq1:ColPos ).And. UpdCli(@aListFil1,@oListArq1,"A1_YCELSMS",8,_aListBkp),;
		If(oListArq1:ColPos==9, lEditCell( aListFil1, oListArq1, "@! ", oListArq1:ColPos ).And. UpdCli(@aListFil1,@oListArq1,"A1_YEMAILC",9,_aListBkp),;
		(u_MZ146G(@aListFil1,@oListArq1,@aListFil2,@oListArq2) )))),oListArq1:Refresh() )

		oListArq1:SetArray( aListFil1 )

		oListArq1:bLine	:= { || { If( aListFil1[oListArq1:nAt,1],oOk,oNo ),;
		aListFil1[oListArq1:nAt,2],;
		aListFil1[oListArq1:nAt,3],;
		aListFil1[oListArq1:nAt,4],;
		aListFil1[oListArq1:nAt,5],;
		Transform(aListFil1[oListArq1:nAt,6],"@E 999,999,999.99"),;
		aListFil1[oListArq1:nAt,7],;
		aListFil1[oListArq1:nAt,8],;
		aListFil1[oListArq1:nAt,9]} }

	EndIf

Return



Static Function Panel02( oPanel2 )

	Local cTitulo  := ""			// Titulo da FormBatch
	Local cList2    := ""			// Variavel auxiliar para montagem da ListBox
	Local nOpc     := 0				// Opcao selecionada pelo usuario na FormBatch
	Local oOk     					// Objeto referente a marca da linha da ListBox quando marcada
	Local oNo     					// Objeto referente a marca da linha da ListBox quando desmarcada

	oScroll2 := TScrollArea():New(oPanel2,0,0,067,36,.T.,.T.,.T.)
	oScroll2:Align := CONTROL_ALIGN_TOP

	@ 000,000 MSPANEL oPanel2A OF oScroll2 SIZE 640,067

	oScroll2:SetFrame( oPanel2A )

	aListFil2 := {}

	AADD(aListFil2,{.F.,'','','','','','',cTod('  /  /  '),cTod('  /  /  '),cTod('  /  /  '),0,0,0,0,0,0,0,0,0,'','',''})

	oOk  := LoadBitmap(GetResources(), "LBOK")
	oNo  := LoadBitmap(GetResources(), "LBNO")

	cTitulo := "Títulos em Aberto"

	@ 1,3 LISTBOX oListArq2 VAR cList2 FIELDS HEADER "", "Filial","Prefixo","Titulo","Parcela","Tipo","Portador","Situação","Natureza",;
	"Emissão","Vencimento","Vencto Real","Valor","Acrescimo","Decrescimo","Saldo","Filial Orig";
	SIZE 660, 055 OF oPanel2A PIXEL ON DBLCLICK (;
	If(oListArq2:ColPos==1,MudaMarc2(@aListFil1,@oListArq1,@aListFil2,@oListArq2),nil),;
	If(oListArq2:ColPos==8,MZ146H(aListFil2[oListArq2:nAt,22],aListFil2[oListArq2:nAt,3], aListFil2[oListArq2:nAt,4],aListFil2[oListArq2:nAt,5],aListFil2[oListArq2:nAt,6]),nil),;
	oListArq2:Refresh() )

	oListArq2:SetArray( aListFil2 )
	oListArq2:bLine	:= { || { If( aListFil2[oListArq2:nAt,1],oOk,oNo ),aListFil2[oListArq2:nAt,2], aListFil2[oListArq2:nAt,3],aListFil2[oListArq2:nAt,4],;
	aListFil2[oListArq2:nAt,5],aListFil2[oListArq2:nAt,6],aListFil2[oListArq2:nAt,20],aListFil2[oListArq2:nAt,21],;
	aListFil2[oListArq2:nAt,7],aListFil2[oListArq2:nAt,8],aListFil2[oListArq2:nAt,9],;
	aListFil2[oListArq2:nAt,10],aListFil2[oListArq2:nAt,11],aListFil2[oListArq2:nAt,18],aListFil2[oListArq2:nAt,19],aListFil2[oListArq2:nAt,12],aListFil2[oListArq2:nAt,22] } }

	oListArq2:bHeaderClick := {|oListArq2,nCol | If(nCol = 1,Marcatudo(aListFil2,oListArq2),'' )}

Return


Static Function Panel03(oPanel3)

	oScroll3 := TScrollArea():New(oPanel3,0,0,057,36,.T.,.T.,.T.)
	oScroll3:Align := CONTROL_ALIGN_TOP

	@ 000,000 MSPANEL oPanel3A OF oScroll3 SIZE 640,057// 143,247

	oScroll3:SetFrame( oPanel3A )

	_aCamp3 := {'ZS_ITEM','ZS_USUARIO','ZS_DATA','ZS_DUPLICA','ZS_TEXTO'}
	_aEdit  := {}

	For C := 1 To Len(_aCamp3)
		SX3->(dbsetOrder(2))
		If SX3->(msSeek(_aCamp3[C]))
			nUsad3++

			If _aCamp3[C] == 'ZS_TEXTO'
				aAdd(aHead3, {AllTrim(	X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,'U_MZ146GT()',SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )
				AADD(_aEdit,_aCamp3[C])
			Else
				aAdd(aHead3, {AllTrim(	X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT } )
			Endif
		Endif
	Next C

	AADD(acols3,Array(nUsad3+1))

	For nI := 1 To nUsad3
		acols3[1][nI] := CriaVar(aHead3[nI][2])
	Next

	_nPosItem := aScan(_aCamp3,{|x| x == "ZS_ITEM"})
	_nPosData := aScan(_aCamp3,{|x| x == "ZS_DATA"})

	acols3[1][_nPosItem]	:= '01'
	acols3[1][_nPosData]	:= dDataBase
	acols3[1][nUsad3+1] 	:= .F.

	oGetDad3 := MsNewGetDados():New(1,3,055,660, GD_UPDATE,"AllwaysTrue()", "AllwaysTrue()",,_aEdit,,,,,,oPanel3A,aHead3,aCols3)

Return



Static Function PANEL04(oPanel4)

	oScroll4 := TScrollArea():New(oPanel4,0,0,045,36,.T.,.T.,.T.)
	oScroll4:Align := CONTROL_ALIGN_TOP

	@ 000,000 MSPANEL oPanel4A OF oScroll4 SIZE 640,045// 143,247

	oScroll4:SetFrame( oPanel4A )

	@ 000, 001  TO 042,130 LABEL '' OF oPanel4A PIXEL
	@ 008, 005 Say 'Saldo Títulos:' 															Size 045, 008 Of oPanel4A Pixel
	@ 008, 045 MsGet _oSaldo 	VAR _nSaldo		When .F. 		Picture("@E 99,999,999.99")   	Size 045, 008 Of oPanel4A Pixel

	@ 023, 005 Say 'Total:' 																	Size 045, 008 Of oPanel4A Pixel
	@ 023, 045 MsGet _oTotal 	VAR _nTotal		When .F. 		Picture("@E 99,999,999.99")   	Size 045, 008 Of oPanel4A Pixel

	@ 000, 131  TO 042,320 LABEL '' OF oPanel4A PIXEL
	@ 003, 150 Say 'Multa %:' 																	Size 045, 008 Of oPanel4A Pixel
	@ 003, 180 MsGet _oPerMulta VAR _nPerMulta  When lUser	VALID MZ146C('PM')	Picture("@E 999.99")   		Size 045, 008 Of oPanel4A Pixel	// When lUser MARCUS
	@ 003, 230 Say 'Valor Multa:' 																Size 045, 008 Of oPanel4A Pixel
	@ 003, 260 MsGet _oMulta 	VAR _nMulta		When _lVM   VALID MZ146C('VM')	Picture("@E 99,999,999.99") Size 045, 008 Of oPanel4A Pixel

	@ 016, 150 Say 'Juros %:' 																	Size 045, 008 Of oPanel4A Pixel
	@ 016, 180 MsGet _oPerJuros VAR _nPerJuros  When lUser	VALID MZ146C('PJ')	Picture("@E 999.99")   		Size 045, 008 Of oPanel4A Pixel // When lUser MARCUS
	@ 016, 230 Say 'Valor Juros:' 																Size 045, 008 Of oPanel4A Pixel
	@ 016, 260 MsGet _oJuros 	VAR _nJuros		When _lVJ   VALID MZ146C('VJ')	Picture("@E 99,999,999.99") Size 045, 008 Of oPanel4A Pixel

	@ 028, 212 Say 'Despesas Cartório:' 														Size 105, 008 Of oPanel4A Pixel
	@ 028, 260 MsGet _oDespesas VAR _nDespesas	VALID MZ146C('DC')	Picture("@E 99,999,999.99") Size 045, 008 Of oPanel4A Pixel

	@ 000, 321  TO 042,390 LABEL '' OF oPanel4A PIXEL
	@ 003, 330 Say 'Data Pagamento:' 															Size 045, 008 Of oPanel4A Pixel
	@ 016, 330 MsGet _oDtBase VAR _dDtBase	VALID MZ146C('PJ')		   							Size 045, 008 Of oPanel4A Pixel

	//	DEFINE SBUTTON oBtn1 FROM 010,330 TYPE 15 ACTION MZ146_ATU() MESSAGE "Atualiza" ENABLE Of oPanel4A
	//	oBtn1:cCaption := 'Atualizar'
	//	oBtn1:cToolTip := 'Atualizar Valores'

Return




Static Function MZ146A()

	Local nI      := 0
	Local cUpload := ""
	Local aFiles  := {}
	Local lSeek   := .F.

	Pergunte("MZ0146",.F.)

	_cQuery := " SELECT E1_FILIAL,E1_CLIENTE,E1_LOJA,A1_NOME,A1_NREDUZ,A1_TEL,A1_YCELSMS,A1_YEMAILC,SUM(E1_SALDO) AS SALDO FROM "+RetSqlName("SE1")+" E1 "
	_cQuery += " INNER JOIN "+RetSqlName("SA1")+" A1 ON E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA "
	_cQuery += " WHERE E1.D_E_L_E_T_ = '' AND A1.D_E_L_E_T_ = '' "
	//	_cQuery += " AND E1_FILIAL = '"+xFilial("SE1")+"' AND A1_FILIAL = '"+xFilial("SA1")+"'"
	_cQuery += " AND E1_SALDO > 0 AND E1_TIPO NOT IN ('RA','PR') "
	_cQuery += " AND E1_EMISSAO BETWEEN '"+dTos(MV_PAR01)+"' AND '"+dTos(MV_PAR02)+"' "
	_cQuery += " AND E1_VENCREA BETWEEN '"+dTos(MV_PAR03)+"' AND '"+dTos(MV_PAR04)+"' "
	_cQuery += " AND E1_CLIENTE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	_cQuery += " AND E1_LOJA BETWEEN 	'"+MV_PAR07+"' AND '"+MV_PAR08+"' "
	_cQuery += " AND E1_SITUACA BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' "
	_cQuery += " AND E1_FILIAL BETWEEN  '"+MV_PAR13+"' AND '"+MV_PAR14+"' "
	_cQuery += " GROUP BY E1_FILIAL,E1_CLIENTE,E1_LOJA,A1_NOME,A1_NREDUZ,A1_TEL,A1_YCELSMS,A1_YEMAILC"
	_cQuery += " ORDER BY SALDO DESC "

	TCQUERY _cQuery NEW ALIAS "TRB1"

	TRB1->(dbGotop())

	While TRB1->(!eof())

		//		Aadd( aListFil1, {.F.,TRB1->E1_FILIAL,TRB1->E1_CLIENTE,TRB1->E1_LOJA,TRB1->A1_NOME,TRB1->A1_NREDUZ,TRB1->SALDO, lSeek} )
		Aadd( aListFil1, {.F.,TRB1->E1_FILIAL,TRB1->E1_CLIENTE,TRB1->E1_LOJA,TRB1->A1_NOME,TRB1->SALDO,TRB1->A1_TEL,TRB1->A1_YCELSMS,TRB1->A1_YEMAILC, lSeek} )

		TRB1->(dbSkip())
	EndDo

	TRB1->(dbCloseArea())
Return



User Function MZ146B(aVet,oObj,aVet2,oObj2) //Grava Registros

	Private  _nPIT  := Ascan(oGetDad3:aHeader,{|x|Alltrim(Upper(x[2]))=="ZS_ITEM"})
	Private  _nPDT  := Ascan(oGetDad3:aHeader,{|x|Alltrim(Upper(x[2]))=="ZS_DATA"})
	Private  _nPDU  := Ascan(oGetDad3:aHeader,{|x|Alltrim(Upper(x[2]))=="ZS_DUPLICA"})
	Private  _nPTX  := Ascan(oGetDad3:aHeader,{|x|Alltrim(Upper(x[2]))=="ZS_TEXTO"})
	Private  _nPUS  := Ascan(oGetDad3:aHeader,{|x|Alltrim(Upper(x[2]))=="ZS_USUARIO"})

	_nNxGr 		:= GetMv("MZ_GRCOBRA")
	_cGrCobra 	:= ""
	_cIt        := oGetDad3:aCols[1,_nPIT]
	If !Empty(oGetDad3:aCols[1,_nPTX])
		SZS->(RecLock('SZS',.T.))
		SZS->ZS_FILIAL 	:= xFilial('SZS')
		SZS->ZS_ITEM 	:= _cIt
		SZS->ZS_DATA 	:= oGetDad3:aCols[1,_nPDT]
		SZS->ZS_TEXTO 	:= oGetDad3:aCols[1,_nPTX]
		SZS->ZS_SALDO 	:= _nSaldo
		SZS->ZS_PMULTA	:= _nPerMulta
		SZS->ZS_VMULTA	:= _nMulta
		SZS->ZS_PJUROS	:= _nPerJuros
		SZS->ZS_VJUROS	:= _nJuros
		SZS->ZS_DESPESA	:= _nDespesas
		SZS->ZS_TOTAL 	:= _nTotal
		SZS->ZS_CLIENTE := Left(_cCliLj,6)
		SZS->ZS_LOJA    := Right(_cCliLj,2)
		SZS->ZS_DUPLICA := _cDuplic
		SZS->ZS_USUARIO := alltrim(USRRETNAME(RETCODUSR()))
		SZS->(MsUnLock())
	Endif
Return



Static Function MZ146C(_cOpt)

	_dDtVenc   := CTOD("")
	_dDtEmis   := CTOD("")

	_nMarcado := 0
	_cDuplic  := ""
	For nInd:=1 To Len(aListFil2)

		If aListFil2[nInd][1]
			_nMarcado	++
			_cDuplic 	+= If(_nMarcado = 1,Alltrim(aListFil2[nInd][4])+'-'+Alltrim(aListFil2[nInd][5]),'|'+Alltrim(aListFil2[nInd][4])+'-'+Alltrim(aListFil2[nInd][5]))
		Endif

	Next nInd

	If Empty(_cOpt)
		_nMulta 	:= 0
		_nJuros 	:= 0
		_nDespesas  := 0
		_lVJ		:= .F.
		_lVM		:= .F.
	ElseIf _cOpt = 'PM'
		_nMulta 	:= 0
	ElseIf _cOpt = 'VM'
		_nPerMulta  := 0
	ElseIf _cOpt = 'PJ'
		_nJuros 	:= 0
	ElseIf _cOpt = 'VJ'
		_nPerJuros 	:= 0
	ElseIf _cOpt = 'DC'
		//	_nDespesas := 0
	Endif

	//	_nTotal := 0
	For nInd:=1 To Len(aListFil2)

		If aListFil2[nInd][1]

			_nDias := _dDtBase - aListFil2[nInd][9]

			SE1->(dbSetOrder(1))
			SE1->(MsSeek(aListFil2[nInd][2] + aListFil2[nInd][3] + aListFil2[nInd][4] + aListFil2[nInd][5] + aListFil2[nInd][6]))
			//			SE1->(MsSeek(xFilial('SE1') + aListFil2[nInd][3] + aListFil2[nInd][4] + aListFil2[nInd][5] + aListFil2[nInd][6]))

			SE1->(RecLock("SE1",.F.))

			If _nDias > 0

				If _cOpt $ "PM"
					_nMulta          	+= (SE1->E1_SALDO * (_nPerMulta/100))
					aListFil2[nInd][16] := (SE1->E1_SALDO * (_nPerMulta/100))
					SE1->E1_YVLMULT  	:= (SE1->E1_SALDO * (_nPerMulta/100))
					If _nPerMulta > 0 .And. lUser
						_lVM				:= .T.
					Else
						_lVM				:= .F.
					Endif
				ElseIf _cOpt $ "PJ"
					_nJuros          	+= (SE1->E1_SALDO * (_nPerJuros/100))  / 30 * _nDias
					aListFil2[nInd][14] := (SE1->E1_SALDO * (_nPerJuros/100))  / 30 * _nDias
					SE1->E1_YVLJURO  	:= (SE1->E1_SALDO * (_nPerJuros/100))  / 30 * _nDias
					If _nJuros > 0 .And. lUser
						_lVJ				:= .T.
					Else
						_lVJ				:= .F.
					Endif
				ElseIf _cOpt $ "VM"
					_nPerMulta 			:= Round(((aListFil2[nInd][17] * _nMulta) / SE1->E1_SALDO),2)
					SE1->E1_YVLMULT  	:= _nMulta * aListFil2[nInd][17]
				ElseIf _cOpt $ "VJ"
					_nPerJuros 			:= Round(((((aListFil2[nInd][15] * _nJuros)/_nDias)*30)/SE1->E1_SALDO),2)
					SE1->E1_YVLJURO  	:= _nJuros * aListFil2[nInd][15]
				Endif
			Endif

			If _cOpt $ "DC"
				SE1->E1_YDESPES     := ((SE1->E1_SALDO) / _nSaldo) * _nDespesas
			Endif
			SE1->E1_YTOTAL   := SE1->E1_YVLMULT + SE1->E1_YVLJURO + SE1->E1_YDESPES + SE1->E1_SALDO
			SE1->(MsUnlock())

		Endif
	Next

	If _cOpt $ "PM|PJ"
		For nInd:=1 To Len(aListFil2)
			If _cOpt = "PM"
				aListFil2[nInd][17] := (aListFil2[nInd][16] / _nMulta ) * 100
			Else
				aListFil2[nInd][15] := (aListFil2[nInd][14] / _nJuros) * 100
			Endif
		Next nInd
	Endif

	_nTotal := _nSaldo + _nJuros + _nMulta + _nDespesas

	_oPerMulta:Refresh()
	_oMulta:Refresh()
	_oPerJuros:Refresh()
	_oJuros:Refresh()
	_oDespesas:Refresh()
	_oTotal:Refresh()

Return


Static Function MZ146D(_aCli)

	Local _oDlg := Nil
	Local _cTit := 'Clientes'
	Local _nOpt := 0

	Private aRotAuto   	:= Nil
	Private Inclui		:= .F.
	Private Altera		:= .T.

	For nInd:=1 To Len(_aCli)

		If _aCli[nInd][1]
			_cCliLj := _aCli[nInd][3] + _aCli[nInd][4]
		Endif
	Next

	_aAliSA1 := SA1->(GetArea())

	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+_cCliLj))

		CCADASTRO := "Clientes"

		aRotina := {{"Pesquisar","PesqBrw"    , 0 , 1,0 ,.F.}}

		aAdd(aRotina,{"Visualizar" ,"A030Visual" , 0 , 2,0  ,NIL})
		aAdd(aRotina,{"Incluir"    ,"A030Inclui" , 0 , 3,81 ,NIL})
		aAdd(aRotina,{"Alterar"    ,"A030Altera" , 0 , 4,143,NIL})
		aAdd(aRotina,{"Excluir"    ,"A030Deleta" , 0 , 5,144,NIL})
		aAdd(aRotina,{"Contatos"   ,"FtContato"	 , 0 , 4,0  ,NIL})
		aadd(aRotina,{"Referencias","Mata030Ref" , 0 , 3,0  ,NIL})


		DEFINE MSDIALOG _oDlg TITLE _cTit FROM 0,0 TO 100,390 OF oMainWnd PIXEL

		@ 05,05 TO 40,190 OF _oDlg PIXEL

		@ 10,10  SAY 'Selecione abaixo a opção desejada:' 	OF _oDlg PIXEL

		_oTButton1 := TButton():New( 025, 020, "Visualizar"		,_oDlg,{||_nOpt:=1,_oDlg:END()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		_oTButton2 := TButton():New( 025, 080, "Alterar"		,_oDlg,{||_nOpt:=2,_oDlg:END()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		_oTButton2 := TButton():New( 025, 140, "Conhecimento"	,_oDlg,{||_nOpt:=3,_oDlg:END()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

		ACTIVATE MSDIALOG _oDlg CENTERED

		DBSELECTAREA("SA1")                             		// Marcus Vinicius - 23/03/2016 - Selecionando a tabela do cadastro do cliente.

		If _nOpt = 1 .AND. u_ChkAcesso("MATA030",2,.T.)			// Marcus Vinicius - 23/03/2016 - Incluído validação de acesso para visualizar cadastro de clientes.
			A030VISUAL("SA1",SA1->(Recno()),2)
		ElseIf _nOpt = 2 .AND. u_ChkAcesso("MATA030",4,.T.)		// Marcus Vinicius - 23/03/2016 - Incluído validação de acesso para alterar cadastro de clientes.
			A030Altera("SA1",SA1->(Recno()),4)
		ElseIf _nOpt = 3 .AND. u_ChkAcesso("MATA030",6,.T.)		// Marcus Vinicius - 23/03/2016 - Incluído validação de acesso para conhecimento de cadastro de clientes.
			MsDocument("SA1",SA1->(RecNo()),4)
		Endif

	Endif

	RestArea(_aAliSA1)

Return


/*
Impressão do Boleto
*/
Static Function MZ146E(_aTitulo,oObj2)

	For A := 1 To Len(_aTitulo)

		If _aTitulo[A][1]

			_cPrefixo := _aTitulo[A][3]
			_cNumero  := _aTitulo[A][4]
			_cParcela := _aTitulo[A][5]
			_cTipo    := _aTitulo[A][6]
			_nTitMul  := _aTitulo[A][16]
			_nTitJur  := _aTitulo[A][14]
			_dTitVen  := _dDtBase

			awParam:={  2,;	//Filtrar por         1=Bordero ou 2=Titulo Expecif
			""			,;	//Bordero
			_cPrefixo	,;	//Do Prefixo
			_cPrefixo	,;	//Ate o Prefixo
			_cNumero	,;	//Do Numero
			_cNumero	,;	//Ate o Numero
			"" 			,;	//Mensagem Adicional
			_nTitMul 	,;	//Valor Multa
			_nTitJur 	,;	//Valor Juros
			_dTitVen 	}	//Data Vencto

			_cSA1Bco := Posicione("SA1",1,xFilial("SA1")+_cCliLj,"A1_BCO1")

			If _cSA1Bco = '021' .Or. _aTitulo[A][20] = '021'
				U_MZ0238(awParam)
			Else
				U_MZ0159(awParam)
			Endif
		Endif
	Next A

Return



/*
Alteração Contas a Receber
*/
Static Function MZ146F(_cFil,_cSerie,_cDoc,_cParc,_cTipo)

	Local aArea     	:= GetArea()
	Local aAreaSM0  	:= SM0->(GetArea())
	Local _oDlg 		:= Nil
	Local _cTit 		:= 'Titulos a Receber'
	Local _nOpt 		:= 0

	If !Empty(_cDoc)
		Private aRotAuto	:= Nil
		Private Inclui		:= .F.
		Private Altera		:= .T.
		PRIVATE lIntegracao := IF(GetMV("MV_EASY")=="S",.T.,.F.)

		Private cFilAnt_bkp := cFilAnt

		cFilAnt := _cFil

		SM0->(MsSeek(cEmpAnt+cFilAnt))

		_aAliSA1 := SE1->(GetArea())

		SE1->(dbSetOrder(1))
		If SE1->(msSeek(xFilial("SE1")+_cSerie+_cDoc+_cParc+_cTipo))

			CCADASTRO := "Títulos a Receber"

			aRotina := {{"Pesquisar","PesqBrw"    , 0 , 1,0 ,.F.}}

			aAdd(aRotina,{"Visualizar" ,"FA280Visua" , 0 , 2,0  ,NIL})
			aAdd(aRotina,{"Incluir"    ,"FA040Inclu" , 0 , 3,81 ,NIL})
			aAdd(aRotina,{"Alterar"    ,"FA040Alter" , 0 , 4,143,NIL})
			aAdd(aRotina,{"Excluir"    ,"FA040Delet" , 0 , 5,144,NIL})
			aAdd(aRotina,{"Transferir" ,"FA060Trans" , 0 , 2,0  ,NIL})

			DEFINE MSDIALOG _oDlg TITLE _cTit FROM 0,0 TO 100,290 OF oMainWnd PIXEL

			@ 05,05 TO 40,140 OF _oDlg PIXEL

			@ 10,10  SAY 'Selecione abaixo a opção desejada:' OF _oDlg PIXEL

			_oTButton1 := TButton():New( 025, 020, "Visualizar"	,_oDlg,{||_nOpt:=1,_oDlg:END()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
			_oTButton2 := TButton():New( 025, 080, "Alterar"	,_oDlg,{||_nOpt:=2,_oDlg:END()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

			ACTIVATE MSDIALOG _oDlg CENTERED

			If _nOpt = 1 .AND. u_ChkAcesso("FINA040",2,.T.)			// Marcus Vinicius - 23/03/2016 - Incluído validação de acesso para visualizar título a receber.
				FA280VISUA("SE1",SE1->(Recno()),2)
			ElseIf _nOpt = 2 .AND. u_ChkAcesso("FINA040",4,.T.)		// Marcus Vinicius - 23/03/2016 - Incluído validação de acesso para alterar título a receber.
				FA040Alter("SE1",SE1->(Recno()),4)
			Endif

		Endif

		cFilAnt := cFilAnt_bkp
		RestArea(aAreaSM0)
	Else
		MsgAlert("Nenhum título encontrado!")
	Endif

Return



User Function MZ146G(aVet,oObj,aVet2,oObj2)

	Local oOk  := LoadBitmap(GetResources(), "LBOK")
	Local oNo  := LoadBitmap(GetResources(), "LBNO")
	Local _nPTX  := Ascan(oGetDad3:aHeader,{|x|Alltrim(Upper(x[2]))=="ZS_TEXTO"})
	Local _nPIT  := Ascan(oGetDad3:aHeader,{|x|Alltrim(Upper(x[2]))=="ZS_ITEM"})
	Local _nPDT  := Ascan(oGetDad3:aHeader,{|x|Alltrim(Upper(x[2]))=="ZS_DATA"})
	Local _nPDU  := Ascan(oGetDad3:aHeader,{|x|Alltrim(Upper(x[2]))=="ZS_DUPLICA"})
	Local _nPUS  := Ascan(oGetDad3:aHeader,{|x|Alltrim(Upper(x[2]))=="ZS_USUARIO"})

	Pergunte("MZ0146",.F.)

	For nInd:=1 To Len(aVet)

		If aVet[nInd][1]
			aVet[nInd][1] := .F.
			_cCliLj := aVet[nInd][3] + aVet[nInd][4]
		Endif
	Next

	If !Empty(_cCliLj) .And. !Empty(oGetDad3:aCols[1,_nPTX])
		If MsgYesNo('Deseja gravar a observação cadastrada?')
			U_MZ146B(aVet,oObj,aVet2,oObj2) //Grava Registros
		Endif
	Endif

	aVet[ oObj:nAt, 1 ] := !aVet[ oObj:nAt, 1 ]

	oObj:Refresh()

	_cCliLj := aVet[ oObj:nAt, 3 ]+aVet[ oObj:nAt, 4 ]

	aListFil2 := {}

	_cQuery := " SELECT * FROM "+RetSqlName("SE1")+" E1 "
	_cQuery += " WHERE E1.D_E_L_E_T_ = '' "
	//	_cQuery += " AND E1_FILIAL = '"+xFilial("SE1")+"' "
	_cQuery += " AND E1_SALDO > 0 AND E1_TIPO NOT IN ('RA','PR') "
	_cQuery += " AND E1_CLIENTE+E1_LOJA = '"+_cCliLj+"' "
	_cQuery += " AND E1_EMISSAO BETWEEN '"+dTos(MV_PAR01)+"' AND '"+dTos(MV_PAR02)+"' "
	_cQuery += " AND E1_VENCREA BETWEEN '"+dTos(MV_PAR03)+"' AND '"+dTos(MV_PAR04)+"' "
	_cQuery += " AND E1_CLIENTE BETWEEN '"+MV_PAR05+"'       AND '"+MV_PAR06+"' "
	_cQuery += " AND E1_LOJA BETWEEN    '"+MV_PAR07+"'       AND '"+MV_PAR08+"' "
	_cQuery += " AND E1_SITUACA BETWEEN '"+MV_PAR11+"'       AND '"+MV_PAR12+"' "
	_cQuery += " AND E1_FILIAL BETWEEN  '"+MV_PAR13+"'       AND '"+MV_PAR14+"' "
	_cQuery += " ORDER BY E1_VENCREA "
	//	_cQuery += " ORDER BY E1_SALDO DESC "//VENCREA "

	If Select("TRB") > 0 //Verifica se a Tabela existe
		TRB->(dbClosearea())
	Endif

	TCQUERY _cQuery NEW ALIAS "TRB"

	TCSETFIELD("TRB","E1_EMISSAO"  ,"D",08)
	TCSETFIELD("TRB","E1_VENCTO"   ,"D",08)
	TCSETFIELD("TRB","E1_VENCREA"  ,"D",08)

	TRB->(dbGotop())

	While TRB->(!EOF())

		If !Empty(TRB->E1_SITUACA)
			_cSitua := Alltrim(TRB->E1_SITUACA)+'-'+Tabela('07',TRB->E1_SITUACA)
		Else
			_cSitua := ''
		Endif

		AADD(aListFil2,{;
		.F.,; 											//01 - Marcado?
		TRB->E1_FILIAL,;									//02 - Filial
		TRB->E1_PREFIXO,;									//03 - Prefixo
		TRB->E1_NUM,;										//04 - Tipo
		TRB->E1_PARCELA,;									//05 - Parcela
		TRB->E1_TIPO,;										//06 - Tipo
		TRB->E1_NATUREZ,;									//07 - Natureza
		TRB->E1_EMISSAO,;									//08 - Emissão
		TRB->E1_VENCTO,;									//09 - Vencimento
		TRB->E1_VENCREA,;									//10 - Vencimento Real
		Transform(TRB->E1_VALOR,"@E 999,999,999.99"),;		//11 - Valor
		Transform(TRB->E1_SALDO,"@E 999,999,999.99"),;		//12 - Saldo - Caracter
		TRB->E1_SALDO,;										//13 - Saldo - valor
		0,; 												//14 - Valor Juros
		0,; 												//15 - Proporção Juros
		0,; 												//16 - Valor Multa
		0,; 												//17 - Proporção Multa
		Transform(TRB->E1_ACRESC,"@E 999,999,999.99"),;		//18 - Acréscimo
		Transform(TRB->E1_DECRESC,"@E 999,999,999.99"),;	//19 - Decréscimo
		TRB->E1_PORTADO,;									//20 - Portador
		_cSitua,;											//21 - Situacao
		TRB->E1_FILORIG})									//22 - Filial Origem

		TRB->(dbSkip())
	EndDo

	TRB->(dbClosearea())

	oObj2:SetArray( aListFil2 )
	oListArq2:bLine	:= { || { If( aListFil2[oListArq2:nAt,1],oOk,oNo ),aListFil2[oListArq2:nAt,2], aListFil2[oListArq2:nAt,3],aListFil2[oListArq2:nAt,4],;
	aListFil2[oListArq2:nAt,5],aListFil2[oListArq2:nAt,6],aListFil2[oListArq2:nAt,20],aListFil2[oListArq2:nAt,21],;
	aListFil2[oListArq2:nAt,7],aListFil2[oListArq2:nAt,8],aListFil2[oListArq2:nAt,9],;
	aListFil2[oListArq2:nAt,10],aListFil2[oListArq2:nAt,11],aListFil2[oListArq2:nAt,18],aListFil2[oListArq2:nAt,19],aListFil2[oListArq2:nAt,12],aListFil2[oListArq2:nAt,22] } }

	oObj2:nAt := 1
	oObj2:Refresh()

	oGetDad3:aCols := {}
	AADD(oGetDad3:aCols,Array(nUsad3+1))

	For nI := 1 To nUsad3
		oGetDad3:aCols[1][nI] := CriaVar(oGetDad3:aHeader[nI][2])
	Next

	_cQrZS := " SELECT * FROM "+RetSqlName('SZS')+" ZS "
	_cQrZS += " WHERE ZS.D_E_L_E_T_ = '' "
	//	_cQrZS += " AND ZS_FILIAL = '"+xFilial('SZS')+"' "
	_cQrZS += " AND ZS_CLIENTE +ZS_LOJA = '"+_cCliLj+"' "
	_cQrZS += " AND ZS_DATA 	BETWEEN '"+DTOS(MV_PAR09)+"' AND '"+DTOS(MV_PAR10)+"' "
	_cQrZS += " AND ZS_FILIAL 	BETWEEN '"+MV_PAR13+"'       AND '"+MV_PAR14+"' "
	_cQrZS += " ORDER BY ZS_ITEM DESC "

	TcQuery _cQrZS new alias 'TSZS'

	TcSetField('TSZS','ZS_DATA','D')

	Count tO _nRec

	TSZS->(dbGoTop())

	_lEncont := .F.
	_nCont   := 0
	oGetDad3:aCols := {}

	If _nRec > 0

		_nCont++
		AADD(oGetDad3:aCols,Array(nUsad3+1))

		oGetDad3:aCols[_nCont][_nPIT]		:= SOMA1(TSZS->ZS_ITEM)
		oGetDad3:aCols[_nCont][_nPDT]		:= dDataBase
		oGetDad3:aCols[_nCont][_nPTX]		:= Space(250)
		oGetDad3:aCols[_nCont][_nPDU]		:= Space(50)
		oGetDad3:aCols[_nCont][_nPUS]		:= Space(20)
		oGetDad3:aCols[_nCont][nUsad3+1] 	:= .F.

		While !TSZS->(EOF())

			_nCont++
			_lEncont := .T.

			AADD(oGetDad3:aCols,Array(nUsad3+1))

			oGetDad3:aCols[_nCont][_nPIT]	 := TSZS->ZS_ITEM
			oGetDad3:aCols[_nCont][_nPDT]	 := TSZS->ZS_DATA
			oGetDad3:aCols[_nCont][_nPTX]	 := TSZS->ZS_TEXTO
			oGetDad3:aCols[_nCont][_nPDU]	 := TSZS->ZS_DUPLICA
			oGetDad3:aCols[_nCont][_nPUS]	 := TSZS->ZS_USUARIO
			oGetDad3:aCols[_nCont][nUsad3+1] := .F.

			TSZS->(dbSkip())
		EndDo
	Else

		AADD(oGetDad3:aCols,Array(nUsad3+1))

		oGetDad3:aCols[_nCont+1][_nPIT]		:= '01'
		oGetDad3:aCols[_nCont+1][_nPDT]		:= dDataBase
		oGetDad3:aCols[_nCont+1][_nPTX]		:= Space(250)
		oGetDad3:aCols[_nCont+1][nUsad3+1]  := .F.

	Endif

	TSZS->(dbCloseArea())

	oGetDad3:Refresh()

	_nSaldo := _nDespesas := _nTotal := 0
	//	_nSaldo := _nPerMulta := _nMulta := _nPerJuros := _nJuros := _nDespesas := _nTotal := 0
	_lEnt   := .T.

	_oSaldo:Refresh()
	_oPerMulta:Refresh()
	_oMulta:Refresh()
	_oPerJuros:Refresh()
	_oJuros:Refresh()
	_oDespesas:Refresh()
	_oTotal:Refresh()

Return



/*
Função  	: MZ146H
Descrição	: Transferencia de Títulos
*/
Static Function MZ146H(_cFil,_cSerie,_cDoc,_cParc,_cTipo)

	Local aArea     	:= GetArea()
	Local aAreaSM0  	:= SM0->(GetArea())
	Local _aAliSE1 		:= SE1->(GetArea())
	Local cFilAnt_bkp 	:= cFilAnt

	cFilAnt := _cFil

	SM0->(MsSeek(cEmpAnt+cFilAnt))

	dbselectArea("SE1")

	SE1->(dbSetOrder(1))
	If SE1->(MsSeek(xFilial("SE1")+_cSerie+_cDoc+_cParc+_cTipo))

		/*
		aRotina := {{"Pesquisar","PesqBrw"    , 0 , 1, ,.F.}}

		aAdd(aRotina,{"Transferir" ,"FA060Trans" 	, 0 , 2})
		aAdd(aRotina,{"Bordero"    ,"FA060Borde" 	, 0 , 3})
		aAdd(aRotina,{"Cancelar"   ,"FA060Canc" 	, 0 , 3})
		aAdd(aRotina,{"Legenda"    ,"FA060Legend" 	, 0 , 2,,.F.})
		*/

		PRIVATE lInverte := .F.
		PRIVATE nPrazo   := 0			  //para ponto de entrda
		PRIVATE nPrazoMed:= 0			  //idem
		PRIVATE nTaxaDesc:= 0			  //idem
		PRIVATE VALOR	 := 0
		PRIVATE VALOR2   := 0
		PRIVATE nValdesc := 0
		PRIVATE dDataMov	:= dDataBase
		PRIVATE nIndice	:= SE1->(Indexord())
		PRIVATE lconsBco := GetMv("MV_CONSBCO")
		PRIVATE nMoeda:=1
		Private nMoedaBco:=1
		Private nDecs :=2
		Private nTxmoeda :=0
		PRIVATE cPict06014:= PesqPict("SE1","E1_VALOR",16,nMoeda)
		PRIVATE cPict06018:= PesqPict("SE1","E1_VALOR",TamSx3("E1_VALOR")[1],nMoeda)
		PRIVATE nAbatim	:= 0
		PRIVATE nDescont	:= 0
		PRIVATE nJuros		:= 0
		PRIVATE nMoedaBor	:= 1
		PRIVATE IOF	  := 0
		PRIVATE nValCred  	:= 0
		PRIVATE nValor 		:= 0

		FA060Trans("SE1",SE1->(Recno()),2)

		u_MZ146G(@aListFil1,@oListArq1,@aListFil2,@oListArq2)

	Endif

	cFilAnt := cFilAnt_bkp

	RestArea(_aAliSE1)
	RestArea(aAreaSM0)

Return


/*
Função  	: PesqCpo
Descrição	: Pesquisa o campo informado na listbox
*/
Static Function PesqCpo(cString,aVet,oObj,nElem)

	Local nPos	:= 0
	Local nLen	:= 0
	Local lRet	:= .T.

	//³Realiza a pesquisa³
	cString := AllTrim(Upper(cString))
	nLen	:= Len(cString)
	nPos	:= aScan(aVet,{|x| AllTrim(Upper(SubStr(x[nElem],1,nLen))) == cString })
	lRet	:= (nPos != 0)

	//³Se encontrou, posiciona o objeto ³
	If lRet
		oObj:nAt := nPos
		oObj:Refresh()
	EndIf

Return lRet



Static Function Marcatudo(aVet2,oObj2,nCol)

	_nSaldo := 0
	_lOk := aVet2[ oObj2:nAt, 1 ]

	For nInd:=1 To Len(aVet2)

		aVet2[nInd][1] := !_lOk

		If aVet2[nInd][1]
			_nSaldo += aVet2[nInd][13]
		Endif

	Next nInd

	_oSaldo:Refresh()

	MZ146C('')   //Cálculo
	MZ146C('PM') //Cálculo Multa
	MZ146C('PJ') //Cálculo Juros

	oObj2:Refresh()

	oGetDad3:Refresh()

	_oPerMulta:Refresh()
	_oMulta:Refresh()
	_oPerJuros:Refresh()
	_oJuros:Refresh()
	_oDespesas:Refresh()
	_oTotal:Refresh()

Return


Static Function MudaMarc2(aVet,oObj,aVet2,oObj2)

	If !Empty(aVet2[oObj2:nAt][4])
		aVet2[ oObj2:nAt, 1 ] := !aVet2[ oObj2:nAt, 1 ]
	Endif

	_lDesmarca := .F.
	If !aVet2[ oObj2:nAt, 1 ]
		_lDesmarca := .T.
	Endif

	_nSaldo := 0
	For nInd:=1 To Len(aVet2)

		If aVet2[nInd][1]
			_nSaldo += aVet2[nInd][13]
		Endif
	Next

	If 	_nSaldo = 0

		_nDespesas := _nTotal := 0
		//		_nPerMulta := _nMulta := _nPerJuros := _nJuros := _nDespesas := _nTotal := 0

		_oPerMulta:Refresh()
		_oMulta:Refresh()
		_oPerJuros:Refresh()
		_oJuros:Refresh()
		_oDespesas:Refresh()
		_oTotal:Refresh()

	Endif
	_oSaldo:Refresh()

	MZ146C('') //Cálculo
	MZ146C('PM') //Cálculo Multa
	MZ146C('PJ') //Cálculo Juros

	oObj2:Refresh()

	oGetDad3:Refresh()

	_oPerMulta:Refresh()
	_oMulta:Refresh()
	_oPerJuros:Refresh()
	_oJuros:Refresh()
	_oDespesas:Refresh()
	_oTotal:Refresh()

Return






//Gatilho
User Function MZ146GT()

	Private  _nPIT  := Ascan(oGetDad3:aHeader,{|x|Alltrim(Upper(x[2]))=="ZS_ITEM"})

	_lOk := .F.
	For nInd:=1 To Len(aListFil2)
		If aListFil2[nInd][1]
			_lOk := .T.
			Exit
		Endif
	Next

	_lMZ146GT := .T.
	If !_lOk
		MsgAlert("Para preencher este campo é necessário marcar ao menos 01 título!")
		_lMZ146GT := .F.
	Endif

	If _nCont > Val(oGetDad3:aCols[oGetDad3:nAt][_nPIT])
		MsgAlert("Não é permitido a edição deste registro!")
		_lMZ146GT := .F.
	Endif

Return (_lMZ146GT)



Static Function ATUSX1()

	cPerg := "MZ0146"

	//    	   Grupo/Ordem/Pergunta          /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     /Var01     /Def01  	/defspa1/defeng1/Cnt01/Var02/Def02  /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(cPerg,"01","Emissao de       ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR01",""  	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
	U_CRIASX1(cPerg,"02","Emissao Ate      ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR02",""  	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
	U_CRIASX1(cPerg,"03","Vencimento De    ?",""       ,""      ,"mv_ch3","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR03",""  	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
	U_CRIASX1(cPerg,"04","Vencimento Ate   ?",""       ,""      ,"mv_ch4","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR04",""  	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
	U_CRIASX1(cPerg,"05","Cliente De       ?",""       ,""      ,"mv_ch5","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR05",""  	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"SA1")
	U_CRIASX1(cPerg,"06","Cliente Ate      ?",""       ,""      ,"mv_ch6","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR06",""  	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"SA1")
	U_CRIASX1(cPerg,"07","Loja De          ?",""       ,""      ,"mv_ch7","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR07",""  	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
	U_CRIASX1(cPerg,"08","Loja Ate         ?",""       ,""      ,"mv_ch8","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR08",""  	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
	U_CRIASX1(cPerg,"09","Data Observ De   ?",""       ,""      ,"mv_ch9","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR09",""  	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
	U_CRIASX1(cPerg,"10","Data Observ Ate  ?",""       ,""      ,"mv_cha","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR10",""  	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
	U_CRIASX1(cPerg,"11","Situacao De      ?",""       ,""      ,"mv_chb","C" ,01     ,0      ,0     ,"G",""        ,"MV_PAR11",""  	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"07")
	U_CRIASX1(cPerg,"12","Situacao Ate     ?",""       ,""      ,"mv_chc","C" ,01     ,0      ,0     ,"G",""        ,"MV_PAR12",""  	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"07")
	U_CRIASX1(cPerg,"13","Filial De        ?",""       ,""      ,"mv_chd","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR13",""  	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
	U_CRIASX1(cPerg,"14","Filial Ate       ?",""       ,""      ,"mv_che","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR14",""  	,""     ,""     ,""   ,""   ,""   	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")

Return



Static Function UpdCli(_aVet,_oObj,_cCampo,_nField,_aVetBkp)

	Local _aMATA030 := {}

	PRIVATE lMsErroAuto := .F.

	If u_ChkAcesso("MATA030",4,.T.)

		SA1->(dbSetOrder(1))
		If SA1->(msSeek(xFilial("SA1")+_aVet[ _oObj:nAt, 3 ] + _aVet[ _oObj:nAt, 4 ] ))

			_aMATA030 := { ;
			{"A1_COD"       , SA1->A1_COD				,Nil},; // Codigo
			{"A1_LOJA"      , SA1->A1_LOJA		 		,Nil},; // Loja
			{_cCampo	    ,_aVet[ _oObj:nAt, _nField ],Nil}}  // Campo Alterado

			MSExecAuto({|x,y| Mata030(x,y)},_aMATA030,4) //3- Inclusão, 4- Alteração, 5- Exclusão

			If lMsErroAuto
				Mostraerro()

				MsgAlert("Alteração não foi gravada no cadastro de Clientes!")

				_aVet[_oObj:nAt,_nField] := _aVetBkp[_oObj:nAt,_nField]

			Endif
		Endif
	Else
		_aVet[_oObj:nAt,_nField] := _aVetBkp[_oObj:nAt,_nField]
	Endif

Return

