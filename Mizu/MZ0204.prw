#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'

/*/{Protheus.doc} MZ0204
Integração de XML de CTE de Compras e Faturamento.
@type function
@author Fabiano
@since 29/06/2016
@version 1.0
/*/
User Function MZ0204()

	Local _oDlg1  	:= Nil
	Local _oRadio 	:= Nil
	Local _oSay 	:= Nil
	Local _oTButOK	:= _oTButCanc	:= Nil

	Local _nRadio := 1
	Local _aItRad := {'Compras','Faturamento'}

	Public _nMZ204ICM := 0
	Public _nMZ204TOT := 0

	DEFINE DIALOG _oDlg1 TITLE OemToAnsi("Integração XML CTE") FROM 0,0 TO 160,300	OF _oDlg1 PIXEL //Style nOR(WS_VISIBLE,WS_POPUP)//Style DS_MODALFRAME

	@ 005,005 TO 065,145 LABEL "" OF _oDlg1 PIXEL

	_oDlg1:lEscClose := .F. //Não permite fechar a janela pelo botão "ESC"

	_oSay:= TSay():New(10,10,{||'Escolha abaixo qual o tipo de CTE que deseja Integrar:'},_oDlg1,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)

	_oRadio := TRadMenu():New (22,10,_aItRad,,_oDlg1,,,,,,,,100,12,,,,.T.)
	_oRadio:bSetGet := {|u|Iif (PCount()==0,_nRadio,_nRadio:=u)}

	_oTButOk	:= TButton():New( 050, 010, "OK"		,_oDlg1,{||MZ204XML(_nRadio),_oDlg1:End()}	, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	_oTButCanc 	:= TButton():New( 050, 100, "Cancelar"	,_oDlg1,{||_oDlg1:End()}					, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE MSDIALOG _oDlg1 CENTERED

Return(Nil)



/*/{Protheus.doc} MZ204XML
Traz em tela os XMLs encontrados no diretório, para serem escolhidos para integração.
@type function
@author Fabiano
@since 24/06/2016
@version 1.0
@param _nOpcRad, ${Numérico}, (Número do Radio selecionado)
/*/
Static Function MZ204XML(_nOpcRad)

	Local _oSize,_oDlg
	Local _cList 	:= ""			// Variavel auxiliar para montagem da ListBox
	Local _aButtons	:= {}
	Local _nOpc 	:= 0

	Local _oOK 		:= LoadBitmap(GetResources(),'LBOK')
	Local _oNO 		:= LoadBitmap(GetResources(),'LBNO')

	Default _nOpcRad	:= 1

	Private _aListFile	:= {}									// Array utilizados pela ListBox com arquivos a serem importados
	Private _oListBox	:= nIL									// Objeto referente a janela da ListBox
	Private _cDir		:= SuperGetMv('AS_DIRXML',,'C:\TOTVS\XML')	// Diretório onde estão os arquivos XML

	If !ExistDir( _cDir )
		If MakeDir( _cDir ) <> 0
			MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
			Return
		EndIf
	EndIf


	If _nOpcRad = 1
		If !U_ChkAcesso("MZ204COM",1,.T.)
			Return(Nil)
		Endif
	Else
		If !U_ChkAcesso("MZ204FAT",1,.T.)
			Return(Nil)
		Endif
	Endif

	_cDir += If(Right(Alltrim(_cDir), 1 ) <> '\', '\', '' )	// Joga a "\" no final do diretório

	//	_cDir += If(_nOpcRad = 1, 'Compras','Faturamento')

	//	_cDir += If(Right(Alltrim(_cDir), 1 ) <> '\', '\', '' )	// Joga a "\" no final do diretório

	_aListFile := GetFile(_cDir)								// Busca os arquivoc XML

	If !Empty(_aListFile)

		//Calcula tamanho da tela
		_oSize := FwDefSize():New( .T. )							// Com enchoicebar
		_oSize:AddObject( "P1", 100, 100, .t., .t., .t. )
		_oSize:lProp := .t.
		_oSize:aMargins := { 3, 3, 3, 3 }							// Margens
		_oSize:lLateral := .F.  									// Calculo vertical
		_oSize:Process()

		Aadd( _aButtons, {"PROCESSA", {|| If(CheckList(1,_aListFile),(_nOpc := 1, _oDlg:End()),MsgAlert("Não foi marcado nenhum XML!"))},;
		"Processa", "Processa" , {|| .T.}} )
		Aadd( _aButtons, {"SELECTALL", {|| InvertMarc()}, "Marcar/Descamarcar", "Marcar/Descamarcar" , {|| .T.}} )

		DEFINE DIALOG _oDlg TITLE OemToAnsi("Integração XML CTE") FROM _oSize:aWindSize[1],_oSize:aWindSize[2] TO _oSize:aWindSize[3],_oSize:aWindSize[4] ;
		OF _oDlg PIXEL Style DS_MODALFRAME // Este estilo retira o botão de fechar no canto superior direito[X]

		_oDlg:lEscClose := .F. //Não permite fechar a janela pelo botão "ESC"

		_oListbox := TWBrowse():New( _oSize:GetDimension( "P1", "LININI" ) , _oSize:GetDimension( "P1", "COLINI" ),;
		_oSize:GetDimension( "P1", "XSIZE" ),_oSize:GetDimension( "P1", "YSIZE" ),,{'','Numero','Fornecedor','Arquivo'},,_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

		_oListbox:SetArray(_aListFile)
		_oListbox:bLine := {||{If(_aListFile[_oListbox:nAt,1],_oOk,_oNo ),_aListFile[_oListbox:nAt,2],_aListFile[_oListbox:nAt,3],_aListFile[_oListbox:nAt,4] } }

		// Troca a imagem no duplo click do mouse
		//	_oListbox:bLDblClick := {|| Check(_aListFile,_oListbox)}
		_oListbox:bLDblClick := {|| If(_aListFile[_oListbox:nAt][5],_aListFile[_oListbox:nAt][1] := !_aListFile[_oListbox:nAt][1],;
		MsgAlert('Fornecedor não Encontrado, portanto CTE não pode ser Integrado!')),_oListbox:DrawSelect()}

		_oListBox:bHeaderClick := {|o, _nCol| If(_nCol = 1,MarkAll(),Nil) }
		//	_oListbox:bLDblClick := {|| _aListFile[_oListbox:nAt][1] := !_aListFile[_oListbox:nAt][1],_oListbox:DrawSelect()}

		ACTIVATE MSDIALOG _oDlg CENTERED ON INIT EnchoiceBar( _oDlg, {|| },{|| _oDlg:End() },, @_aButtons,,,,.F.,.F.,.F.,.F. )
		//		ACTIVATE MSDIALOG _oDlg CENTERED ON INIT EnchoiceBar( _oDlg, {|| _nOpc := 1, _oDlg:End() },{|| _oDlg:End() },, @_aButtons,,,,.F.,.F.,.F.,.F. )

		If _nOpc == 1
			If _nOpcRad = 1
				LjMsgRun( "Integrando XML CTE de Compras, aguarde...", "CTE", {|| MZ204COM() } )
			Else
				LjMsgRun( "Integrando XML CTE de Faturamento, aguarde...", "CTE", {|| MZ204FAT() } )
			Endif
		Endif
	Else
		MsgAlert('Não foi encontrado nennhum arquivo para ser integrado!')
	Endif

Return(Nil)




Static Function MarkAll()

	Local _nInd		:= 1 	// Conteudo de retorno
	Local _lMark	:= !_aListFile[1][1]

	For _nInd := 1 To Len(_aListFile)
		_aListFile[_nInd][1] := _lMark
	Next

	_oListBox:Refresh()

Return(Nil)


/*/{Protheus.doc} GetFile
Busca os arquivos XML na pasta indicada
@type Function
@author Fabiano
@since 22/06/2016
@version 1.0
@param _cDir	, ${Caracter}	, (Nome do caminho que contém os arquivos XML)
@return _aFile	, ${array}		, (Array com os arquivo}
/*/
Static Function GetFile(_cDir)

	Local _aFile 	:= Directory(_cDir+'*.xml')
	Local _cForncec := ''
	Local _cNrCte 	:= ''
	Local _lFornec	:= .F.
	Local O

	For O := 1 To Len(_aFile)

		SA2->(dbSetOrder(3))
		If SA2->(msSeek(xFilial('SA2')+Substr(_aFile[O][1],7,14)))
			_cFornec := SA2->A2_COD+'/'+SA2->A2_LOJA+'-'+Alltrim(SA2->A2_NOME)
			_lFornec := .T.
		Else
			_cFornec := 'Fornecedor não encontrado'
			_lFornec := .F.
		Endif

		_cNrCte := Substr(_aFile[O][1],23,3)+'-'+Substr(_aFile[O][1],26,9)

		Aadd( _aListFile, {.F.,_cNrCte,_cFornec,_aFile[O][1],_lFornec})
	Next O

Return(_aListFile)



/*/{Protheus.doc} InvertMarc
Inverte a marca de selecao do item da ListBox
@type function
@author Fabiano
@since 24/06/2016
@version 1.0
/*/
Static Function InvertMarc()

	Local _nInd 	:= 1 	// Conteudo de retorno

	For _nInd:=1 To Len(_aListFile)
		If _aListFile[_nInd][5]
			_aListFile[_nInd][1] := !_aListFile[_nInd][1]
		Endif
	Next

	_oListBox:Refresh()

Return Nil



/*/{Protheus.doc} MZ204FAT
Integrar o XML de Faturamento
@type function
@author Fabiano
@since 24/06/2016
@version 1.0
/*/
Static Function MZ204FAT()

	Local _cErro  	:= ""
	Local _cAviso 	:= ""
	Local _cDirRede	:= "\XML\CTEFAT\"+Alltrim(cEmpAnt)+Alltrim(cFilAnt)+"\"

	Local _aCabec := {}
	Local _aItens := {}
	Local _aLinha := {}
	Local _cDoc   := ""

	Local _cFa

	If cEmpAnt == "02"
		If !cEmpAnt+cFilAnt $ SuperGetMV("MV_YCTEXML",,"")
			MsgAlert('Filial não está cadastrada para importação do XML de CT-e!')
			Return(Nil)
		Endif
	Endif

	For _cFa :=1 to Len(_aListFile)

		If !_aListFile[_cFa][1]
			Loop
		Endif

		_lCpy := .F.
		For A := 1 to 10
			If !__CopyFile(_cDir+_aListFile[_cFa][4],_cDirRede+_aListFile[_cFa][4])
				MsgAlert( 'Arquivo não foi copiado da estação para o servidor!'+CRLF+CRLF+'Tentativa '+cValToChar(A))
				Loop
			Else
				_lCpy := .T.
				Exit
			Endif
		Next A

		If !_lCpy
			MsgAlert('Não foi possível a cópia do arquivo para o servidor, portanto o processo será interrompido!')
			Return(Nil)
		Endif

		_cFile	:= _cDirRede+_aListFile[_cFa][4]

		_oCte	:= XmlParserFile(_cFile,"_",@_cErro,@_cAviso)

		If !Empty(_cErro) .Or. !Empty(_cAviso)
			MSGSTOP("Arquivo XML Nao Pode Ser Importado :"+_aListFile[_cFa][4])
			_cArq := _cDirRede+_aListFile[_cFa][4]
			//			_cArq := "\XML\CTEFAT\"+_aListFile[_cFa][4]
			FErase(_cArq)

			Exit
		Endif

		_oProtCTE		:= _oCte:_CteProc:_ProtCTE:_InfProt
		_oCte 			:= _oCte:_CteProc:_Cte:_InfCte
		_oIde			:= _oCte:_IDE
		_oEmit			:= _oCte:_Emit
		_oRem			:= _oCte:_Rem
		_oDest			:= _oCte:_Dest
		_oVPrest		:= _oCte:_vPrest
		_oImp			:= _oCte:_Imp
		_oInfCteNorm	:= _oCte:_InfCteNorm

		_cNumCTE		:= PadL(_oIde:_nCT:TEXT,9,'0')

		_cCNPJRem		:= Alltrim(_oRem:_CNPJ:TEXT)

		If _cCNPJRem == Alltrim(SM0->M0_CGC)

			_cCNPJEmis	:= Alltrim(_oEmit:_CNPJ:TEXT)
			_cNrCTE		:= Padl(Alltrim(_oIde:_nCT:TEXT),9,'0')
			_cSeCte		:= Padr(Alltrim(_oIde:_serie:TEXT),3,'')
			_cTipoNF	:= "C"
			_dEmis		:= Ctod(Substr(_oIde:_dhEmi:TEXT,9,2)+"/"+Substr(_oIde:_dhEmi:TEXT,6,2)+"/"+Left(_oIde:_dhEmi:TEXT,4))
			_cChave		:= Alltrim(_oProtCTE:_chCTe:TEXT)

			If Type("_oImp:_ICMS:_ICMS00:_vBC") == "U"
				_nBaseICMS	:= 0
				_nPercICMS	:= 0
				_nMZ204ICM	:= 0
			Else
				_nBaseICMS	:= Val(Alltrim(_oImp:_ICMS:_ICMS00:_vBC:TEXT))
				_nPercICMS	:= Val(Alltrim(_oImp:_ICMS:_ICMS00:_pICMS:TEXT))
				_nMZ204ICM	:= Val(Alltrim(_oImp:_ICMS:_ICMS00:_vICMS:TEXT))
			Endif

			SA2->(dbSetOrder(3))
			If !SA2->(msSeek(xFilial('SA2')+_cCNPJEmis))
				MsgAlert("Não encontrado o Fornecedor do CTE "+_cNrCTE+"!")
				//				CpyS2T(_cDirRede+_aListFile[F][4],_cDir,.T.)
				FErase(_cDirRede+_aListFile[_cFa][4])
				Loop
			Endif

			SF1->(dbSetOrder(1))
			If SF1->(msSeek(xFilial("SF1")+_cNrCTE+_cSeCte+SA2->A2_COD+SA2->A2_LOJA+_cTipoNF))
				MsgAlert("CTE "+_cNrCTE+" ja Cadastrado Para Esse Fornecedor!")
				FErase(_cDirRede+_aListFile[_cFa][4])
				Loop
			EndIf

			IF SA2->A2_YFORCTR <> "S"
				MsgAlert("O fornecedor:[ "+SA2->A2_COD+' - '+Alltrim(SA2->A2_NOME)+" ]. "+CRLF+;
				"Não está cadastrado como fornecedor de transporte"+CRLF+;
				"Solicitar ao responsável pelo setor acertar o campo: 'Forn CTR'")
				FErase(_cDirRede+_aListFile[_cFa][4])
				Loop
			EndIf

			If cEmpAnt = "02"
				_cSerOri := Substr(_OINFCTENORM:_INFDOC:_INFNFE:_chave:TEXT,23,3)
			Else
				_cSerOri := Padr(Substr(_OINFCTENORM:_INFDOC:_INFNFE:_chave:TEXT,25,1),3)
			Endif

			_cNFOri  := Padr(Substr(_OINFCTENORM:_INFDOC:_INFNFE:_chave:TEXT,29,6),9)

			SD2->(dbSetOrder(3))
			If !SD2->(dbSeek(xFilial("SD2")+_cNFOri+_cSerOri))
				MsgAlert('NF Original: '+Alltrim(_cNFOri)+' não encontrada! Processo Cancelado!')
				FErase(_cDirRede+_aListFile[_cFa][4])
				Exit
			Endif

			_cQuery := " SELECT * FROM "+RetSqlName("SD1")+" D1 " +CRLF
			_cQuery += " WHERE D1.D_E_L_E_T_ = '' 				" +CRLF
			_cQuery += " AND D1_FORNECE = '"+SA2->A2_COD+"' 	" +CRLF
			_cQuery += " AND D1_LOJA 	= '"+SA2->A2_LOJA+"' 	" +CRLF
			_cQuery += " AND D1_NFORI 	= '"+_cNFOri+"' 		" +CRLF
			_cQuery += " AND D1_SERIORI = '"+_cSerOri+"' 		" +CRLF

			TcQuery _cQuery new Alias "TSD1"

			Count to _nRec

			If _nRec > 0
				TSD1->(dbGoTop())
				MsgAlert('NF '+Alltrim(_cSerOri)+'-'+Alltrim(_cNFOri)+' já utilizada no CT-e '+Alltrim(TSD1->D1_SERIE)+'-'+Alltrim(TSD1->D1_DOC)+'!')
				FErase(_cDirRede+_aListFile[_cFa][4])
				TSD1->(dbCloseArea())
				Exit
			Else
				TSD1->(dbCloseArea())
			Endif

			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD))

			If Empty(SB1->B1_TIPCAR)
				MsgAlert('Tipo de Carga não vinculada no cadastro do produto: '+SD2->D2_COD+'! Processo Cancelado!')
				FErase(_cDirRede+_aListFile[_cFa][4])
				Return(Nil)
			Endif

			SX5->(dbSetOrder(1))
			If !SX5->(dbSeek(xFilial("SX5")+"Z7"+SB1->B1_TIPCAR))
				MsgInfo("Não encontrado o produto "+Alltrim(SB1->B1_TIPCAR)+" na tabela Genérica(SX5).")
				FErase(_cDirRede+_aListFile[_cFa][4])
				Return(Nil)
			Endif

			_cCodigo := Alltrim(SX5->X5_DESCRI)

			SA5->(dbsetOrder(1))
			If !SA5->(dbSeek(xFilial("SA5")+SA2->A2_COD+SA2->A2_LOJA+SX5->X5_DESCRI))
				MsgInfo("Não encontrado cadastro de Produto X Fornecedor: "+CRLF+;
				"Produto: "+_cCodigo+CRLF+;
				"Fornecedor: "+SA2->A2_COD+"-"+SA2->A2_LOJA)
				FErase(_cDirRede+_aListFile[_cFa][4])
				Return(Nil)
			Endif

			If Empty(SA5->A5_YCONDPG)
				MsgInfo("O fornecedor: [ "+SA2->A2_COD+' - '+Alltrim(SA2->A2_NOME)+" ]. "+Chr(13)+Chr(10)+;
				"Nao tem condicao de pagamento cadastrada para este produto ("+SD2->D2_DOC+"). Favor cadastrar em Produto X Fornecedor!")
				FErase(_cDirRede+_aListFile[_cFa][4])
				Return(Nil)
			Endif

			If SA5->(FieldPos("A5_YTESFRE")) > 0
				If Empty(SA5->A5_YTESFRE)
					MsgInfo("O campo TES Frete não está preenchido no cadastro de Produto X Fornecedor: "+CRLF+;
					"Produto: "+_cCodigo+CRLF+;
					"Fornecedor: "+SA2->A2_COD+"-"+SA2->A2_LOJA)
					FErase(_cDirRede+_aListFile[_cFa][4])
					Return(Nil)
				Endif
			Else
				MsgInfo("Não foi encontrado o campo TES Frete no cadastro de Produto X Fornecedor."+CRLF+;
				"Contate o Administrador.")
				FErase(_cDirRede+_aListFile[_cFa][4])
				Return(Nil)
			Endif

			_cTES := SA5->A5_YTESFRE

			SF4->(dbSetOrder(1))
			SF4->(dbSeek(xFilial("SF4")+_cTES))

			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+_cCodigo))

			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA))

			SF2->(DbSetOrder(1))
			SF2->(DbSeek(xFilial("SF2")+_cNFOri+_cSerOri))

			_nTotal := Val(Alltrim(_oVPrest:_vTPrest:TEXT))
			_nPedag := 0
			If cfilAnt $ ('23|26')
				_nPedag := SF2->F2_YPEDAG
			Endif

			_nVlSF2 := SF2->F2_FRETE + _nPedag
			//			If _nTotal <> SF2->F2_FRETE
			If _nTotal <> _nVlSF2
				MsgAlert("Valor do CT-E diferente do valor de Frete da NF de Faturamento:"+CRLF+CRLF+;
				"Valor CTE ("+Alltrim(_cSeCte)+"-"+Alltrim(_cNrCTE)+"): "+Alltrim(Transform(_nTotal, "@E 999,999,999.99"))+CRLF+;
				"Valor Frete NF ("+Alltrim(_cSerOri)+"-"+Alltrim(_cNFOri)+"): "+Alltrim(Transform(SF2->F2_FRETE,"@E 999,999,999.99"))+CRLF+;
				If(_nPedag > 0,"Valor Pedágio NF ("+Alltrim(_cSerOri)+"-"+Alltrim(_cNFOri)+"): "+Alltrim(Transform(_nPedag,"@E 999,999,999.99")),''))
				FErase(_cDirRede+_aListFile[_cFa][4])
				Return(Nil)
			Endif

			If SD2->D2_UM == "TL"
				If  SA1->A1_YFGRA > 0
					_nValUnit := SA1->A1_YFGRA
				Else
					_nValUnit := Round((_nTotal-_nPedag) / SD2->D2_QUANT,4)
				EndIf
			ElseIf SA1->A1_YFRECLI > 0
				_nValUnit := SA1->A1_YFRECLI
			Else
				_nValUnit := Round((_nTotal-_nPedag) / SD2->D2_QUANT,4)
			EndIf


			CTT->(dbSetOrder(1))
			CTT->(dbSeek(xFilial("CTT")+SB1->B1_CC))

			Private lMsHelpAuto := .T.
			PRIVATE lMsErroAuto := .F.

			_aCabec  := {}
			_aItens   := {}
			_nCredCOF := _nCredPIS := 0

			If GetMV("MV_ESTADO") == "RJ"
				_nPICMS := If(SF4->F4_ICM=="S",20,0)
			Else
				_nPICMS := If(SF4->F4_ICM=="S",12,0)
			Endif

			_aLinha := {}
			aadd(_aLinha,{"D1_COD"		,SB1->B1_COD	,Nil})
			//			aadd(_aLinha,{"D1_QUANT"	,1				,Nil})
			aadd(_aLinha,{"D1_UM"		,SB1->B1_UM		,Nil})
			aadd(_aLinha,{"D1_VUNIT"	,_nTotal		,Nil})
			aadd(_aLinha,{"D1_TOTAL"	,_nTotal		,Nil})
			aadd(_aLinha,{"D1_TES"		,_cTES			,Nil})
			aadd(_aLinha,{"D1_DESCRI"	,SB1->B1_DESC	,Nil})
			aadd(_aLinha,{"D1_BASEICM"	,_nBaseICMS		,Nil})
			aadd(_aLinha,{"D1_PICM"		,_nPercICMS		,Nil})
			aadd(_aLinha,{"D1_VALICM"	,_nMZ204ICM		,Nil})

			_nCF := IF(Alltrim(GetMV("MV_ESTADO")) == SA2->A2_EST,SF4->F4_CF,"2"+SUBS(SF4->F4_CF,2,3))
			aadd(_aLinha,{"D1_CF"		,_nCF			,Nil})
			aadd(_aLinha,{"D1_CONTA"	,SB1->B1_CONTA	,Nil})
			aadd(_aLinha,{"D1_FORNECE"	,SA2->A2_COD	,Nil})
			aadd(_aLinha,{"D1_LOJA"		,SA2->A2_LOJA	,Nil})
			aadd(_aLinha,{"D1_LOCAL"	,SB1->B1_LOCPAD	,Nil})
			aadd(_aLinha,{"D1_EMISSAO"	,_dEmis			,Nil})
			aadd(_aLinha,{"D1_DOC"		,_cNrCTE		,Nil})
			aadd(_aLinha,{"D1_SERIE"	,_cSeCte		,Nil})
			aadd(_aLinha,{"D1_DTDIGIT"	,dDataBase		,Nil})
			aadd(_aLinha,{"D1_TP"		,"GG"			,Nil})
			aadd(_aLinha,{"D1_ITEM"		,"01"			,Nil})
			aadd(_aLinha,{"D1_RATEIO"	,"2"			,Nil})

			If SF4->F4_PISCOF $ '23' .And. SF4->F4_PISCRED == '1' // Gera COF?  e Se credita de COF?
				_nCredCOF	+= Round(_nTotal*GETMV("MV_TXCOFIN")/100,2)
				aadd(_aLinha,{"D1_BASIMP5"	,_nTotal		,Nil})
				aadd(_aLinha,{"D1_VALIMP5"	,_nCredCOF		,Nil})
			Endif

			If SF4->F4_PISCOF $ '13' .And. SF4->F4_PISCRED == '1' // Gera PIS?  e Se credita de PIS?
				_nCredPIS	+= Round(_nTotal*GETMV("MV_TXPIS")/100,2)
				aadd(_aLinha,{"D1_BASIMP6"	,_nTotal		,Nil})
				aadd(_aLinha,{"D1_VALIMP6"	,_nCredPIS		,Nil})
			Endif

			_nCusto := _nTotal - (_nMZ204ICM+_nCredPIS+_nCredCOF)
			aadd(_aLinha,{"D1_CUSTO"	,_nCusto			,Nil})
			aadd(_aLinha,{"D1_CC"		,SB1->B1_CC			,Nil})
			aadd(_aLinha,{"D1_CLVL"		,SB1->B1_CLVL		,Nil})
			aadd(_aLinha,{"D1_ITEMCTA"	,SB1->B1_ITEMCC		,Nil})
			aadd(_aLinha,{"D1_CLASFIS"	,"000"				,Nil})

			_cDescCC := POSICIONE("ZZ7",1,xFilial("ZZ7")+CTT->CTT_YGRDE,"ZZ7_GDESPE") //Descricao CCusto Nivel 1
			aadd(_aLinha,{"D1_YDESCN1"	,_cDescCC			,Nil})

			IF  !(xFILIAL("SZC") $ "01/07") .AND. ALLTRIM(SB1->B1_CC) $ "0604"
				_cCodVisao := "105"

				ZZ8->(DBSETORDER(1)) // ZZ8_FILIAL+ZZ8_CODIGO
				ZZ8->(DBSEEK(xFILIAL("ZZ8")+_cCodVisao))

				aadd(_aLinha,{"D1_VISAO"	,_cCodVisao			,Nil})
				aadd(_aLinha,{"D1_DESCVI"	,ZZ8->ZZ8_DESPES	,Nil})
			EndIf

			ZZ4->(dbSetOrder(1)) //ZZ4_FILIAL+ZZ4_CODIGO
			ZZ4->(dbSeek(xFilial("ZZ4")+CTT->CTT_YSBDE))

			While !ZZ4->(Eof()) .And. CTT->CTT_YSBDE == ZZ4->ZZ4_CODIGO
				If CTT->CTT_YGRDE+" " == ZZ4->ZZ4_GRDESP
					aadd(_aLinha,{"D1_YDESCN2"	,ZZ4->ZZ4_GERENC,Nil})
					Exit
				EndIf
				ZZ4->(dbSkip())
			End

			_cDesCC3 := POSICIONE("ZZ8",2,xFilial("ZZ8")+CTT->CTT_YSBDE+CTT->CTT_YDESP,"ZZ8_DESPES") //Descricao CCusto Nivel 3
			aadd(_aLinha,{"D1_YDESCN3"	,_cDesCC3		,Nil})

			aadd(_aLinha,{"D1_NFORI"	,_cNFOri		,Nil})
			aadd(_aLinha,{"D1_SERIORI"	,_cSerOri		,Nil})

			aadd(_aItens,_aLinha)

			aadd(_aCabec,{"F1_TIPO"			, "C"				})
			aadd(_aCabec,{"F1_FORMUL"		, "N"				})
			aadd(_aCabec,{"F1_DOC"			, _cNrCTE			})
			aadd(_aCabec,{"F1_SERIE"		, _cSeCte			})
			aadd(_aCabec,{"F1_FORNECE"		, SA2->A2_COD		})
			aadd(_aCabec,{"F1_LOJA"			, SA2->A2_LOJA		})
			aadd(_aCabec,{"F1_EMISSAO"		, _dEmis			})
			aadd(_aCabec,{"F1_ESPECIE"		, "CTE"				})
			//			aadd(_aCabec,{"F1_COND"			, SA5->A5_YCONDPG	})
			aadd(_aCabec,{"F1_COND"			, SA2->A2_COND		})  // Marcus Vinicius - 07/06/2017 - Alterado a forma de uso da condição de pagamento buscando diretamente do cadastro do fornecedor quando fore referente ao faturamento
			aadd(_aCabec,{"F1_EST"			, SA2->A2_EST		})
			aadd(_aCabec,{"F1_BASEICM"		, _nBaseICMS		})
			aadd(_aCabec,{"F1_VALICM"		, _nMZ204ICM		})
			aadd(_aCabec,{"F1_VALMERC"		, _nTotal			})
			aadd(_aCabec,{"F1_VALBRUT"		, _nTotal			})
			aadd(_aCabec,{"F1_DTDIGIT"		, dDataBase			})
			aadd(_aCabec,{"F1_PREFIXO"		, _cSeCte			})
			aadd(_aCabec,{"F1_RECBMTO"		, _dEmis			})
			aadd(_aCabec,{"F1_STATUS"		, 'A'				})
			aadd(_aCabec,{"F1_CHVNFE"		, _cChave			})
			aadd(_aCabec,{"F1_TPCTE"		, "N"				})
			aadd(_aCabec,{"E2_NATUREZ"		, SA2->A2_NATUREZ	})

			If _nCredCOF >= 0
				aadd(_aCabec,{"F1_BASIMP5"		,_nTotal		})
				aadd(_aCabec,{"F1_VALIMP5"		,_nCredCOF		})
			Endif

			If _nCredPIS >= 0
				aadd(_aCabec,{"F1_BASIMP6"		,_nTotal		})
				aadd(_aCabec,{"F1_VALIMP6"		,_nCredPIS		})
			Endif

			MSExecAuto({|x,y| mata103(x,y)},_aCabec,_aItens)

			If lMsErroAuto
				MostraErro()
				FErase(_cDirRede+_aListFile[_cFa][4])
			Else

				SZC->(RecLock("SZC",.T.))
				SZC->ZC_FILIAL  := xFilial("SZC")
				SZC->ZC_NUM     := _cNrCTE
				SZC->ZC_FORNECE := SA2->A2_COD
				SZC->ZC_LOJA    := SA2->A2_LOJA
				SZC->ZC_SERIE   := _cSerOri
				SZC->ZC_NOTA    := _cNFOri
				SZC->ZC_QTE     := SD2->D2_QUANT
				SZC->ZC_TES     := _cTES
				SZC->ZC_VALUNIT := _nValUnit
				SZC->ZC_VALTOT  := _nTotal - _nPedag
				SZC->ZC_EMISSAO := _dEmis
				SZC->ZC_DTDIGIT := dDataBase
				SZC->ZC_PEDAGIO := _nPedag
				SZC->ZC_SERCTR  := _cSeCte
				SZC->(msUnLock())

				//³ Gravar numero do CTR no cabecalho da NF de saida
				SF2->(RecLock("SF2",.F.))
				SF2->F2_YCTR   := _cNrCTE
				SF2->F2_YSERCTR:= _cSeCte
				SF2->F2_YFCTR  := SA2->A2_COD
				SF2->F2_YLCTR  := SA2->A2_LOJA
				SF2->(MsUnlock())

				SZB->(RecLock("SZB",.T.))
				SZB->ZB_FILIAL  := xFilial("SZB")
				SZB->ZB_NUM     := _cNrCTE
				SZB->ZB_SERIE   := _cSeCte
				SZB->ZB_FORNECE := SA2->A2_COD
				SZB->ZB_LOJA    := SA2->A2_LOJA
				SZB->ZB_NOME    := SA2->A2_NOME
				SZB->ZB_TOTAL   := _nTotal
				SZB->ZB_EMISSAO := _dEmis
				SZB->ZB_DTDIGIT := dDataBase
				SZB->ZB_BICMS   := _nBaseICMS
				SZB->ZB_CHVNFE  := _cChave
				If SZB->(FieldPos("ZB_ORIGEM")) > 0
					SZB->ZB_ORIGEM  := 'MZ0204'
				Endif
				SZB->(msUnLock())

				If Findfunction("U_MIZ871")
					U_MIZ871(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,1)
				Endif

				__CopyFile(_cDirRede+_aListFile[_cFa][4],_cDirRede+'bkp\'+_aListFile[_cFa][4])
				FErase(_cDirRede+_aListFile[_cFa][4])
				FErase(_cDir+_aListFile[_cFa][4])
			EndIf

		Else
			MsgAlert('O CNPJ '+_cCNPJRem+' no CTE '+_cNumCTE+' é diferente da Filial Atual!')
			FErase(_cDirRede+_aListFile[_cFa][4])
			Return(Nil)
		Endif
	Next _cFa

Return(Nil)



/*/{Protheus.doc} MZ204COM
Integrar o XML de Compras
@type function
@author Fabiano
@since 29/06/2016
@version 1.0
/*/
Static Function MZ204COM()

	Local _cErro  	:= ""
	Local _cAviso 	:= ""
	//	Local _cDirRede	:= "\XML\CTECOM\"
	Local _cDirRede	:= "\XML\CTECOM\"+Alltrim(cEmpAnt)+Alltrim(cFilAnt)+"\"

	Local _aCabCTR	:= {}
	Local _aItCTR	:= {}
	Local _cFilSF1	:= ""
	Local _cDoc		:= ""
	Local _cF,A,_cA

	//	Local _oProtCTE	:= Nil
	//	Local _oCte		:= Nil

	If cEmpAnt == "02"
		If !cEmpAnt+cFilAnt $ SuperGetMV("MV_YCTEXML",,"")
			MsgAlert('Filial não está cadastrada para importação do XML de CT-e!')
			Return(Nil)
		Endif
	Endif

	Private _cB

	Private lMsErroAuto  := .F.
	Private lMsHelpAuto  := .T.

	For _cF := 1 to Len(_aListFile)

		_aCabCTR	:= {}
		_aItCTR		:= {}

		If !_aListFile[_cF][1]
			Loop
		Endif

		_lCpy := .F.
		For _cA := 1 to 10
			If !__CopyFile(_cDir+_aListFile[_cF][4],_cDirRede+_aListFile[_cF][4])
				MsgAlert('Arquivo não foi copiado da estação para o servidor!'+CRLF+CRLF+'Tentativa '+cValToChar(_cA))
				Loop
			Else
				_lCpy := .T.
				Exit
			Endif
		Next _cA

		If !_lCpy
			MsgAlert('Não foi possívell a cópia do arquivo para o servidor, portanto o processo será interrompido!')
			Return(Nil)
		Endif

		_cFile	:= _cDirRede+_aListFile[_cF][4]

		_oCte	:= XmlParserFile(_cFile,"_",@_cErro,@_cAviso)

		If !Empty(_cErro) .Or. !Empty(_cAviso)
			MSGSTOP("Arquivo XML Nao Pode Ser Importado :"+_aListFile[_cF][4])
			_cArq := _cDirRede+_aListFile[_cF][4]
			FErase(_cArq)

			Exit
		Endif


		/*		// Incluso validação para considerar as duas versões do xml - Alison
		_oVers2	:= type("_oCte:_CteProc")
		_oVers3	:= type("_oCte:_enviCte")

		IF _oVers2 <> "U"
		_oProtCTE		:= _oCte:_CteProc:_ProtCTE:_InfProt
		_oCte			:= _oCte:_CteProc:_Cte:_InfCte
		Elseif _oVers3 <> "U"
		_oProtCTE		:= _oCte:_enviCte:_retConsReciCte:_ProtCte:_InfProt
		_oCte			:= _oCte:_enviCte:_Cte:_InfCte
		Endif*/

		If Type("_oCte:_CteProc") = 'O'
			If type("_oCte:_CteProc:_ProtCTE") <> 'U'
				_oProtCTE := _oCte:_CteProc:_ProtCTE:_InfProt
			ElseIf type("_oCte:_CteProc:_retConsSitCte:_ProtCTE") <> 'U'
				_oProtCTE := _oCte:_CteProc:_retConsSitCte:_ProtCTE:_InfProt
			Endif
			_oCte	:= _oCte:_CteProc:_Cte:_InfCte
		ElseIf type("_oCte:_enviCte") <> 'U'
			_oProtCTE	:= _oCte:_enviCte:_retConsReciCte:_ProtCte:_InfProt
			_oCte		:= _oCte:_enviCte:_Cte:_InfCte
		Endif

		If Type("_oProtCTE") = 'U'
			ShowHelpDlg("MZ0204_1", {'Estrutura do arquivo XML não configurado para importação.'},1,{'Entre em contato com o departamento de TI.'},1)
			_cArq := _cDirRede+_aListFile[_cF][4]
			FErase(_cArq)
			Exit
		Endif

		_oIde			:= _oCte:_IDE
		_oEmit			:= _oCte:_Emit
		_oRem			:= _oCte:_Rem
		_oDest			:= _oCte:_Dest
		_oVPrest		:= _oCte:_vPrest
		_oImp			:= _oCte:_Imp
		_oInfCteNorm	:= _oCte:_InfCteNorm

		_cNumCTE		:= PadL(_oIde:_nCT:TEXT,9,'0')

		_cCNPJDest		:= Alltrim(_oDest:_CNPJ:TEXT)
		_cCNPJRem		:= Alltrim(_oRem:_CNPJ:TEXT)

		If _cCNPJDest == Alltrim(SM0->M0_CGC)

			_cCNPJEmis	:= Alltrim(_oEmit:_CNPJ:TEXT)
			_cNrCTE		:= Padl(Alltrim(_oIde:_nCT:TEXT),9,'0')
			_cSeCte		:= Padr(Alltrim(_oIde:_serie:TEXT),3,'')
			_cTipoNF	:= "C"
			_dEmis		:= Ctod(Substr(_oIde:_dhEmi:TEXT,9,2)+"/"+Substr(_oIde:_dhEmi:TEXT,6,2)+"/"+Left(_oIde:_dhEmi:TEXT,4))
			_cChave		:= Alltrim(_oProtCTE:_chCTe:TEXT)

			If Type("_oImp:_ICMS:_ICMSSN:indSN") == "U" .and. Type("_oImp:_ICMS:_ICMS00:_vBC") == "U" .and. Type("_oImp:_ICMS:_ICMS20:_vBC") == "U"    // Marcus Vinicius - 09/09/2017 - Incluido Tag referente a fornecedor simples nacional.
				_nBaseICMS	:= 0
				_nPercICMS	:= 0
				_nMZ204ICM	:= 0
			ElseIF Type("_oImp:_ICMS:_ICMS00:_vBC") == "U" .And. Type("_oImp:_ICMS:_ICMS90") <> "U"
				If _oImp:_ICMS:_ICMS90:_CST:TEXT == "90"
					_nBaseICMS	:= Val(Alltrim(_oImp:_ICMS:_ICMS90:_vBC:TEXT))
					_nPercICMS	:= Val(Alltrim(_oImp:_ICMS:_ICMS90:_pICMS:TEXT))
					_nMZ204ICM	:= Val(Alltrim(_oImp:_ICMS:_ICMS90:_vICMS:TEXT))
				EndIf
			ElseIF Type("_oImp:_ICMS:_ICMS00:_vBC") == "U" .And. Type("_oImp:_ICMS:_ICMS20") <> "U"
				If _oImp:_ICMS:_ICMS20:_CST:TEXT == "20"
					_nBaseICMS	:= Val(Alltrim(_oImp:_ICMS:_ICMS20:_vBC:TEXT))
					_nPercICMS	:= Val(Alltrim(_oImp:_ICMS:_ICMS20:_pICMS:TEXT))
					_nMZ204ICM	:= Val(Alltrim(_oImp:_ICMS:_ICMS20:_vICMS:TEXT))
				EndIf
			ElseIf Type("_oImp:_ICMS:_ICMS00:_vBC") == "U"
				_nBaseICMS	:= 0
				_nPercICMS	:= 0
				_nMZ204ICM	:= 0
			Else
				_nBaseICMS	:= Val(Alltrim(_oImp:_ICMS:_ICMS00:_vBC:TEXT))
				_nPercICMS	:= Val(Alltrim(_oImp:_ICMS:_ICMS00:_pICMS:TEXT))
				_nMZ204ICM	:= Val(Alltrim(_oImp:_ICMS:_ICMS00:_vICMS:TEXT))
			Endif

			SA2->(dbSetOrder(3))
			If !SA2->(msSeek(xFilial('SA2')+_cCNPJEmis))
				MsgAlert("Não encontrado o Fornecedor do CTE "+_cNrCTE+"!")
				FErase(_cDirRede+_aListFile[_cF][4])
				Loop
			Endif

			SF1->(dbSetOrder(1))
			If SF1->(msSeek(xFilial("SF1")+_cNrCTE+_cSeCte+SA2->A2_COD+SA2->A2_LOJA+_cTipoNF))
				MsgAlert("CTE "+_cNrCTE+" ja Cadastrado Para Esse Fornecedor!")
				FErase(_cDirRede+_aListFile[_cF][4])
				Loop
			EndIf

			IF SA2->A2_YFORCTR <> "S"
				MsgAlert("O fornecedor:[ "+SA2->A2_COD+' - '+Alltrim(SA2->A2_NOME)+" ]. "+CRLF+;
				"Não está cadastrado como fornecedor de transporte"+CRLF+;
				"Solicitar ao responsável pelo setor acertar o campo: 'Forn CTR'")
				FErase(_cDirRede+_aListFile[_cF][4])
				Loop
			EndIf

			//_nTotal := Val(Alltrim(_oVPrest:_vTPrest:TEXT))
			_nTotal := Val(Alltrim(_oVPrest:_vRec:TEXT))

			_aPedido := MZ204PC(SA2->A2_COD,SA2->A2_LOJA,SA2->A2_NREDUZ,_nTotal)

			If Empty(_aPedido)
				MsgAlert('Não foi encontrado Pedido de Compras para integração deste XML! Processo Cancelado!')
				FErase(_cDirRede+_aListFile[_cF][4])
				Loop
			Endif

			SC7->(dbSetOrder(1))
			SC7->(msSeek(xFilial("SC7")+_aPedido[1]+_aPedido[2]))

			IF Type("_oInfCteNorm:_InfDoc:_InfNFE") == "A"
				_nFor  := Len(_oInfCteNorm:_InfDoc:_InfNFE)
				_InfCh := "_oInfCteNorm:_InfDoc:_InfNFE[_cB]"
			Else
				_nFor := 1
				_InfCh := "_oInfCteNorm:_InfDoc:_InfNFE"
			Endif

			For _cB := 1 to _nFor

				_cKeyFor  	:= &(_InfCh):_chave:TEXT
				//				_cKeyFor  	:= _oInfCteNorm:_InfDoc:_InfNFE[A]:_chave:TEXT
				_cCNPJFor 	:= Substr(_cKeyFor,7,14)
				_cNFForn 	:= Substr(_cKeyFor,26,9)
				//				_cSerForn 	:= Substr(_cKeyFor,23,3)
				_cSerForn 	:= ''
				_cSerChve 	:= Substr(_cKeyFor,23,3)

				//				If Substr(_cKeyFor,23,2) == '00'       // Adicionado para extrair série da chave quando série conter 00 no inicio - Raphael Moura - Chamado 45969
				//					_cSerForn:= Substr(_cKeyFor,23,3)
				//				Else
				For B := 23 To 25
					If Substr(_cKeyFor,B,1) != '0' .Or. !Empty(_cSerForn)
						_cSerForn += Substr(_cKeyFor,B,1)
					Endif
				Next B
				//				Endif

				If Empty(_cSerForn)
					_cSerForn := '0'
				Endif

				_cSerForn := Padr(_cSerForn,3)

				_aAliasSA2 := SA2->(GetArea())
				SA2->(dbSetOrder(3))
				If !SA2->(msSeek(xFilial('SA2')+_cCNPJFor))
					MsgAlert("O Fornecedor da NF "+Alltrim(_cSerForn)+"-"+Alltrim(_cNFForn)+" não encontrado."+CRLF+;
					"CNPJ: "+Alltrim(Transform(_cCNPJFor,"@R 99.999.999/9999-99")))
				Endif

				SF1->(dbOrderNickName("INDSF12"))
				If SF1->(DbSeek(xFilial("SF1")+ _cNFForn + _cSerForn + "S" ))
					AAdd(_aItCTR,{{"PRIMARYKEY",SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA}} )
				Else
					SF1->(dbSetOrder(1))
					If SF1->(msSeek(xFilial("SF1")+_cNFForn+_cSerForn+SA2->A2_COD+SA2->A2_LOJA))
						AAdd(_aItCTR,{{"PRIMARYKEY",SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA}} )
					Endif
				Endif

				If Empty(_aItCTR)
					SF1->(dbOrderNickName("INDSF12"))
					If SF1->(DbSeek(xFilial("SF1")+ _cNFForn + _cSerChve + "S" ))
						AAdd(_aItCTR,{{"PRIMARYKEY",SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA}} )
					Else
						SF1->(dbSetOrder(1))
						If SF1->(msSeek(xFilial("SF1")+_cNFForn+_cSerChve+SA2->A2_COD+SA2->A2_LOJA))
							AAdd(_aItCTR,{{"PRIMARYKEY",SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA}} )
						Endif
					Endif
				Endif

				RestArea(_aAliasSA2)

			Next A

			If Len(_aItCTR)>0

				c116NumNF	:= _cNrCTE
				c116SerNF	:= _cSeCte
				c116Fornece	:= SA2->A2_COD
				c116Loja	:= SA2->A2_LOJA

				aadd(_aCabCTR,{""			,dDataBase-90	}) //Data Inicial
				aadd(_aCabCTR,{""			,dDataBase		}) //Data Final
				aadd(_aCabCTR,{""			,2				}) //2-Inclusao;1=Exclusao
				aadd(_aCabCTR,{""			,""				}) //Fornecedor do documento de Origem
				aadd(_aCabCTR,{""			,""				}) //Loja de origem
				aadd(_aCabCTR,{""			,1				}) //Tipo da nota de origem: 1=Normal;2=Devol/Benef
				aadd(_aCabCTR,{""			,1				}) //1=Aglutina;2=Nao aglutina
				aadd(_aCabCTR,{"F1_EST"		,SA2->A2_EST	}) //Estado do Fornecedor Origem
				aadd(_aCabCTR,{"F1_VALBRUT"	,_nTotal		}) //Valor do conhecimento
				aadd(_aCabCTR,{"F1_FORMUL"	,1				}) //Formulario
				aadd(_aCabCTR,{"F1_DOC"		,_cNrCTE		}) //F1_DOC - Numero do CTR
				aadd(_aCabCTR,{"F1_SERIE"	,_cSeCte		}) //F1_SERIE - Serie do CTR
				aadd(_aCabCTR,{"F1_FORNECE"	,SA2->A2_COD	}) //F1_FORNECE - Transportador - Fornecedor CTR
				aadd(_aCabCTR,{"F1_LOJA"	,SA2->A2_LOJA	}) //F1_LOJA - Transportador - LOJA       CTR
				aadd(_aCabCTR,{"F1_TES"		,SC7->C7_TES	}) //TES
				aadd(_aCabCTR,{"F1_BRICMS"	,_nBaseICMS		}) //BASE ICMS
				aadd(_aCabCTR,{"F1_ICMRET"	,0				}) //ICMS Ret
				aadd(_aCabCTR,{"F1_COND"	,SC7->C7_COND	}) //Condicao de pagamento
				aadd(_aCabCTR,{"F1_EMISSAO"	, _dEmis		})
				aadd(_aCabCTR,{"F1_ESPECIE"	,"CTE"			}) //Espécie
				aadd(_aCabCTR,{"E2_NATUREZ"	,SA2->A2_NATUREZ}) //Espécie
				aadd(_aCabCTR,{"F1_TPCTE"	,"N"			}) //Tipo Cte
				aadd(_aCabCTR,{"F1_CHVNFE"	,_cChave		})
				aadd(_aCabCTR,{"F1_DTDIGIT"	, dDataBase		})
				aadd(_aCabCTR,{"F1_VALICM"	,SC7->C7_VALICM	})

				lMsErroAuto := .F.

				MsExecAuto({|x,y| MATA116(x,y)},_aCabCTR,_aItCTR)

				If lMsErroAuto
					Mostraerro()
					FErase(_cDirRede+_aListFile[_cF][4])
				Else
					If _nMZ204ICM <> _nMZ204TOT
						//If !(_nMZ204TOT + 0.01) == _nMZ204ICM    // Ajustado Fonte PONTOS_COM
						MsgAlert("O valor do ICMS importado do CTE "+_cNrCTE+" está diferente do XML. "+;
						CRLF+CRLF+;
						"Processo Cancelado." +CRLF+;
						CRLF+;
						"Valor ICMS XML: "+cValtoChar(_nMZ204ICM)+;
						CRLF+;
						"Valor ICMS Importado: "+cValToChar(_nMZ204TOT))
						FErase(_cDirRede+_aListFile[_cF][4])
					Else

						MsgInfo('Importação do CT-e '+_cNrCTE+' concluída com sucesso!')

						__CopyFile(_cDirRede+_aListFile[_cF][4],_cDirRede+'bkp\'+_aListFile[_cF][4])
						FErase(_cDirRede+_aListFile[_cF][4])
						FErase(_cDir+_aListFile[_cF][4])
					Endif
				Endif

			Else
				MsgAlert('Não foi encontrado NF de Origem para a o CT-e: '+Alltrim(_cNrCTE))
				FErase(_cDirRede+_aListFile[_cF][4])
				Return(Nil)
			Endif

		Else
			MsgAlert('O CNPJ '+_cCNPJDest+' no CTE '+_cNumCTE+' é diferente da Filial Atual!'+CRLF+CRLF+;
			'CNPJ Filial atual: '+Alltrim(SM0->M0_CGC))
			FErase(_cDirRede+_aListFile[_cF][4])
			Return(Nil)
		Endif
	Next _cF

Return(Nil)



/*/{Protheus.doc} MZ204PC
Busca os Pedidos de Compras para a Integração do XML de Compras
@type function
@author Fabiano
@since 29/06/2016
@version 1.0
@param _cForCod, ${param_type}, (Código do Fornecedor)
@param _cForLoj, ${param_type}, (Loja do Fornecedor)
@param _cForNom, ${param_type}, (Nome do Fornecedor)
@param _nTotal, ${param_type}, (Valor do XML)
@return ${_aPedido}, ${Pedido selecionado}
/*/
Static Function MZ204PC(_cForCod,_cForLoj,_cForNom,_nTotal)

	Local _aListPed	:= {}
	Local _oOk	 	:= LoadBitmap(GetResources(), "LBOK")
	Local _oNo		:= LoadBitmap(GetResources(), "LBNO")
	Local _oDlg2	:= Nil
	Local _oListPed	:= Nil
	Local F			:= 0
	Local _cSeek	:= Space(TamSx3("C7_NUM")[1])

	Private _aPedido	:= {}

	_cQuery := " SELECT C7_NUM,C7_ITEM,C7_PRODUTO,C7_QUANT,C7_TOTAL,C7_DATPRF FROM "+RetSqlName("SC7")+" C7 (NOLOCK) " +CRLF
	_cQuery += " WHERE C7.D_E_L_E_T_ = '' AND C7_FILIAL = '"+xFilial("SC7")+"' "+CRLF
	_cQuery += " AND C7_FORNECE = '"+_cForCod+"' "+CRLF
	_cQuery += " AND C7_LOJA = '"+_cForLoj+"' "+CRLF
	_cQuery += " AND C7_RESIDUO = '' "+CRLF
	_cQuery += " AND C7_QUJE = 0 "+CRLF
	_cQuery += " ORDER BY C7_NUM,C7_ITEM "+CRLF

	TcQuery _cQuery new Alias "TRBC7"

	TcSetField("TRBC7","C7_DATPRF","D")

	TRBC7->(dbGotop())

	While !TRBC7->(EOF())

		AADD(_aListPed,{.F.		,; //01
		TRBC7->C7_NUM			,; //02
		TRBC7->C7_ITEM			,; //03
		TRBC7->C7_PRODUTO		,; //04
		TRBC7->C7_QUANT			,; //05
		TRBC7->C7_TOTAL			,; //06
		TRBC7->C7_DATPRF		}) //07

		TRBC7->(dbSkip())
	EndDo

	TRBC7->(dbCloseArea())

	If !Empty(_aListPed)

		DEFINE DIALOG _oDlg2 TITLE "Pedidos de Compras" FROM 0,0 TO 310,650	OF _oDlg2 PIXEL Style DS_MODALFRAME

		@ 005,005 TO 135,320 LABEL "" OF _oDlg2 PIXEL

		_oDlg2:lEscClose := .F. //Não permite fechar a janela pelo botão "ESC"

		_cFornecedor := _cForCod+'-'+_cForLoj+' '+Alltrim(_cForNom)
		_oTSay1 := TSay():New( 10,10,{||'Fornecedor:'},_oDlg2,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,20)
		_oTGet1 := TGet():New( 10,50,{||_cFornecedor},_oDlg2,100,10,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,_cFornecedor,,,, )
		_oTGet1:Disable()

		_oTSay2 := TSay():New( 10,180,{||'Valor XML:'},_oDlg2,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,20)
		_oTGet2 := TGet():New( 10,220,{||_nTotal},_oDlg2,50,10,"@e 9,999,999.99",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,Str(_nTotal),,,, )
		_oTGet2:Disable()

		_oListPed := TWBrowse():New( 30,10,305,100,,{'','Pedido','Item','Produto','Quantidade','Valor','Entrega'},,_oDlg2,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

		_oListPed:SetArray(_aListPed)
		_oListPed:bLine := {||{If(_aListPed[_oListPed:nAt,1],_oOk,_oNo ),_aListPed[_oListPed:nAt,2],_aListPed[_oListPed:nAt,3],_aListPed[_oListPed:nAt,4],;
		Transform(_aListPed[_oListPed:nAt,5],"@e 9,999,999.99"),;
		Transform(_aListPed[_oListPed:nAt,6],"@e 9,999,999.99"),;
		_aListPed[_oListPed:nAt,7] } }

		_oListPed:bLDblClick := {||If( _aListPed[_oListPed:nAt,6] <> _nTotal,MsgAlert("Valor do pedido diferente do XML"),CheckBox(_aListPed,_oListPed))}

		_oTButOk	:= TButton():New( 140, 010, "OK"		,_oDlg2,{||If(CheckList(2,_aListPed),_oDlg2:End(),MsgAlert("Não foi marcado nenhum Pedido!"))}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		_oTButOk	:= TButton():New( 140, 060, "Cancelar"	,_oDlg2,{||_oDlg2:End()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

		_oTSay3 := TSay():New(139,210,{||' Pedido:'},_oDlg2,,,,,,.T.,CLR_WHITE,CLR_RED,30,12,,,,,.T.)
		_oTSay3:lTransparent := .F.
		@ 139, 245 MsGet _cSeek				Size 030, 010 Of _oDlg2 Pixel
		_oTBut2	:= TButton():New( 139, 280, "Pesquisar"	,_oDlg2,{|| PesqCpo(_cSeek,_aListPed,_oListPed,2)}	, 30,12,,,.F.,.T.,.F.,,.F.,,,.F. )

		ACTIVATE MSDIALOG _oDlg2 CENTERED

	Endif

Return(_aPedido)



//Pesquisar o campo informado na listbox
Static Function PesqCpo(_cString,_aVet,_oObj,_nElem)

	Local _nPos	:= 0
	Local _nLen	:= 0
	//	Local _lRet	:= .T.

	//³Realiza a pesquisa³
	_cString := AllTrim(Upper(_cString))
	_nLen	:= Len(_cString)
	//	_nPos	:= aScan(_aVet,{|x| AllTrim(Upper(SubStr(x[_nElem],1,_nLen))) == _cString })
	_nPos	:= aScan(_aVet,{|x| Alltrim(_cString) $ Upper(x[_nElem]) })
	_lRet	:= (_nPos != 0)

	//³Se encontrou, posiciona o objeto ³
	If _lRet
		_oObj:nAt := _nPos
		_oObj:Refresh()
	EndIf

Return(Nil)



/*/{Protheus.doc} CheckBox
(long_description)
@type function
@author Fabiano
@since 29/06/2016
@version 1.0
@param _aListPed, ${param_type}, (Descrição do parâmetro)
@param _oListPed, ${param_type}, (Descrição do parâmetro)
/*/
Static Function CheckBox(_aListPed,_oListPed)

	Local N

	_aListPed[_oListPed:nAt][1] := !_aListPed[_oListPed:nAt][1]

	For N := 1 To Len(_aListPed)
		If N <> _oListPed:nAt
			_aListPed[N][1] := .F.
		Endif
	Next N

	_oListPed:Refresh()

Return



/*/{Protheus.doc} CheckList
Verifica se foi marcado algum item do ListBox
@type function
@author Fabiano
@since 01/07/2016
@version 1.0
@param _nOpc, ${numérico}, (Define onde foi chamado a rotina, sendo 1 na tela inicial ou 2 na tela de Pedido)
@param _aListPed, ${Array}, (Array com os dados do ListBox)
@return ${_lList}, ${Retorno lógico que define se foi encontrado algum item da ListBox}
/*/
Static Function CheckList(_nOpc,_aListPed)

	Local _lList := .F.
	Local I

	For I := 1 To Len(_aListPed)
		If _aListPed[I][1]
			If _nOpc = 2
				AADD(_aPedido,_aListPed[I][2])
				AADD(_aPedido,_aListPed[I][3])
			Endif
			_lList := .T.
		Endif
	Next I

Return(_lList)
