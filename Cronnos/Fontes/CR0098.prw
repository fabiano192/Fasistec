#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'

User Function CR0098()
	
	Local _oDlg1  	:= Nil
	Local _oSay 	:= Nil
	Local _oTButOK	:= _oTButCanc	:= Nil
	
	DEFINE DIALOG _oDlg1 TITLE OemToAnsi("Integração XML CTE") FROM 0,0 TO 160,300	OF _oDlg1 PIXEL //Style nOR(WS_VISIBLE,WS_POPUP)//Style DS_MODALFRAME
	
	@ 005,005 TO 065,145 LABEL "" OF _oDlg1 PIXEL
	
	_oDlg1:lEscClose := .F. //Não permite fechar a janela pelo botão "ESC"
	
	_oSay:= TSay():New(10,10,{||'ESTA ROTINA TEM POR OBJETO INTEGRAR XML'},_oDlg1,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
	
	_oTButOk	:= TButton():New( 050, 010, "OK"		,_oDlg1,{||CR098XML(),_oDlg1:End()}	, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	_oTButCanc 	:= TButton():New( 050, 100, "Cancelar"	,_oDlg1,{||_oDlg1:End()}					, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	ACTIVATE MSDIALOG _oDlg1 CENTERED
	
Return(Nil)



/*/{Protheus.doc} CR098XML
Traz em tela os XMLs encontrados no diretório, para serem escolhidos para integração.
@type function
@author Fabiano
@since 24/06/2016
@version 1.0
@param _nOpcRad, ${Numérico}, (Número do Radio selecionado)
/*/
Static Function CR098XML()
	
	Local _oSize,_oDlg
	Local _cList 	:= ""			// Variavel auxiliar para montagem da ListBox
	Local _aButtons	:= {}
	Local _nOpc 	:= 0
	
	Local _oOK 		:= LoadBitmap(GetResources(),'LBOK')
	Local _oNO 		:= LoadBitmap(GetResources(),'LBNO')
	
	Default _nOpcRad	:= 1
	
	Private _aListFile	:= {}									// Array utilizados pela ListBox com arquivos a serem importados
	Private _oListBox	:= nIL									// Objeto referente a janela da ListBox
	Private _cDir		:= SuperGetMv('CR_DIRXML',,'C:\TOTVS\XML')	// Diretório onde estão os arquivos XML
	
	If !ExistDir( _cDir )
		If MakeDir( _cDir ) <> 0
			MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
			Return
		EndIf
	EndIf
		
/*
	If _nOpcRad = 1
		If !U_ChkAcesso("CR098COM",1,.T.)
			Return(Nil)
		Endif
	Else
		If !U_ChkAcesso("CR098FAT",1,.T.)
			Return(Nil)
		Endif
	Endif
*/	
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
		
		//	_oListbox:bLDblClick := {|| _aListFile[_oListbox:nAt][1] := !_aListFile[_oListbox:nAt][1],_oListbox:DrawSelect()}
		
		ACTIVATE MSDIALOG _oDlg CENTERED ON INIT EnchoiceBar( _oDlg, {|| },{|| _oDlg:End() },, @_aButtons,,,,.F.,.F.,.F.,.F. )
		//		ACTIVATE MSDIALOG _oDlg CENTERED ON INIT EnchoiceBar( _oDlg, {|| _nOpc := 1, _oDlg:End() },{|| _oDlg:End() },, @_aButtons,,,,.F.,.F.,.F.,.F. )
		
		If _nOpc == 1
			LjMsgRun( "Integrando XML CTE de Compras, aguarde...", "CTE", {|| CR098COM() } )
		Endif
	Else
		MsgAlert('Não foi encontrado nennhum arquivo para ser integrado!')
	Endif
	
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



/*/{Protheus.doc} CR098COM
Integrar o XML de Compras
@type function
@author Fabiano
@since 29/06/2016
@version 1.0
/*/
Static Function CR098COM()
	
	Local _cErro  	:= ""
	Local _cAviso 	:= ""
	Local _cDirRede	:= "\XML\CTECOM\"
	
	Local _aCabCTR	:= {}
	Local _aItCTR	:= {}
	Local _aLinha	:= {}
	Local _cFilSF1	:= ""
	Local _cDoc		:= ""
	
	Private lMsErroAuto  := .F.
	Private lMsHelpAuto  := .T.
	
	For F:=1 to Len(_aListFile)
		
		_aCabec	:= {}
		_aItens	:= {}
		_aLinha	:= {}
		
		If !_aListFile[F][1]
			Loop
		Endif
		
		_lCpy := .F.		
		For A := 1 to 10
			If !__CopyFile(_cDir+_aListFile[F][4],_cDirRede+_aListFile[F][4])
				MsgAlert('Arquivo não foi copiado da estação para o servidor!'+CRLF+CRLF+'Tentativa '+cValToChar(A))
				Loop
			Else
				_lCpy := .T.
				Exit
			Endif
		Next A
		
		If !_lCpy
			MsgAlert('Não foi possívell a cópia do arquivo para o servidor, portanto o processo será interrompido!')
			Return(Nil)
		Endif
		
		_cFile	:= _cDirRede+"\"+_aListFile[F][4]
		
		_oCte	:= XmlParserFile(_cFile,"_",@_cErro,@_cAviso)
		
		If !Empty(_cErro) .Or. !Empty(_cAviso)
			MSGSTOP("Arquivo XML Nao Pode Ser Importado :"+_aListFile[F][4])
			_cArq := "\XML\CTECOM\"+_aListFile[F][4]
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
		
		_cCNPJDest		:= Alltrim(_oDest:_CNPJ:TEXT)
		_cCNPJRem		:= Alltrim(_oRem:_CNPJ:TEXT)
		
		If _cCNPJRem == Alltrim(SM0->M0_CGC)
			
			_cCNPJEmis	:= Alltrim(_oEmit:_CNPJ:TEXT)
			_cNrCTE		:= Padl(Alltrim(_oIde:_nCT:TEXT),9,'0')
			_cSerie		:= Padr(Alltrim(_oIde:_serie:TEXT),3,'')
			_cTipoNF	:= "C"
			_dEmis		:= Ctod(Substr(_oIde:_dhEmi:TEXT,9,2)+"/"+Substr(_oIde:_dhEmi:TEXT,6,2)+"/"+Left(_oIde:_dhEmi:TEXT,4))
			_cChave		:= Alltrim(_oProtCTE:_chCTe:TEXT)
			
			IF Type("_oImp:_ICMS:_ICMS00:_vBC") == "U"
				_nBaseICMS	:= 0
				_nPercICMS	:= 0
				_nValICMS	:= 0
			Else
				_nBaseICMS	:= Val(Alltrim(_oImp:_ICMS:_ICMS00:_vBC:TEXT))
				_nPercICMS	:= Val(Alltrim(_oImp:_ICMS:_ICMS00:_pICMS:TEXT))
				_nValICMS	:= Val(Alltrim(_oImp:_ICMS:_ICMS00:_vICMS:TEXT))
			Endif
			
			SA2->(dbSetOrder(3))
			If !SA2->(msSeek(xFilial('SA2')+_cCNPJEmis))
				MsgAlert("Não encontrado o Fornecedor do CTE "+_cNrCTE+"!")
//				CpyS2T(_cDirRede+_aListFile[F][4],_cDir,.T.)
				FErase(_cDirRede+_aListFile[F][4])
				Loop
			Endif
			
			SF1->(dbSetOrder(1))
			If SF1->(msSeek(xFilial("SF1")+_cNrCTE+_cSerie+SA2->A2_COD+SA2->A2_LOJA+_cTipoNF))
				MsgAlert("CTE "+_cNrCTE+" ja Cadastrado Para Esse Fornecedor!")
//				CpyS2T(_cDirRede+_aListFile[F][4],_cDir,.T.)
				FErase(_cDirRede+_aListFile[F][4])
				Loop
			EndIf
			
			IF SA2->A2_YFORCTR <> "S"
				MsgAlert("O fornecedor:[ "+SA2->A2_COD+' - '+Alltrim(SA2->A2_NOME)+" ]. "+CRLF+;
					"Não está cadastrado como fornecedor de transporte"+CRLF+;
					"Solicitar ao responsável pelo setor acertar o campo: 'Forn CTR'")
//				CpyS2T(_cDirRede+_aListFile[F][4],_cDir,.T.)
				FErase(_cDirRede+_aListFile[F][4])
				Loop
			EndIf
			
			_nTotal := Val(Alltrim(_oVPrest:_vTPrest:TEXT))
			
			_aPedido := CR098PC(SA2->A2_COD,SA2->A2_LOJA,SA2->A2_NREDUZ,_nTotal)
			
			If Empty(_aPedido)
				MsgAlert('Não foi encontrado Pedido de Compras para integração deste XML! Processo Cancelado!')
//				CpyS2T(_cDirRede+_aListFile[F][4],_cDir,.T.)
				FErase(_cDirRede+_aListFile[F][4])
				Loop
			Endif
			
			SC7->(dbSetOrder(1))
			SC7->(msSeek(xFilial("SC7")+_aPedido[1]+_aPedido[2]))
			
			For A := 1 to Len(_oInfCteNorm:_InfDoc:_InfNFE)
				
				_cKeyFor  	:= _oInfCteNorm:_InfDoc:_InfNFE[A]:_chave:TEXT
				_cCNPJFor 	:= Substr(_cKeyFor,7,14)
				_cNFForn 	:= Substr(_cKeyFor,26,9)
				//				_cSerForn 	:= Substr(_cKeyFor,23,3)
				_cSerForn 	:= ''
				For B := 23 To 25
					If Substr(_cKeyFor,B,1) != '0' .Or. !Empty(_cSerForn)
						_cSerForn += Substr(_cKeyFor,B,1)
					Endif
				Next B
				
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
				
				SF1->(dbSetOrder(1))
				If SF1->(msSeek(xFilial("SF1")+_cNFForn+_cSerForn+SA2->A2_COD+SA2->A2_LOJA))
					//					aadd(aItens,{{"PRIMARYKEY",AllTrim(SubStr(&(IndexKey()),nTamFilial + 1))}}) //Tratamento para Gestao Empresas
					//					aadd(_aItCTR,{{SF1->F1_FORNECE,SF1->F1_DOC,NIL}})
					AAdd(_aItCTR,{{"PRIMARYKEY",SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA}} )
					//					aadd(_aItCTR,{{SF1->F1_FORNECE,SF1->F1_DOC,NIL}})
				Endif
				RestArea(_aAliasSA2)
				
			Next A
			
			If Len(_aItCTR)>0
				
				aadd(_aCabCTR,{""			,dDataBase-90	}) //Data Inicial
				aadd(_aCabCTR,{""			,dDataBase		}) //Data Final
				aadd(_aCabCTR,{""			,2				}) //2-Inclusao;1=Exclusao
				aadd(_aCabCTR,{""			,""				}) //Fornecedor do documento de Origem
				aadd(_aCabCTR,{""			,""				}) //Loja de origem
				aadd(_aCabCTR,{""			,1				}) //Tipo da nota de origem: 1=Normal;2=Devol/Benef
				aadd(_aCabCTR,{""			,1				}) //1=Aglutina;2=Nao aglutina
				aadd(_aCabCTR,{"F1_EST"		,""				}) //Estado do Fornecedor Origem
				//				aadd(_aCabCTR,{""	,_nTotal				}) //Valor do conhecimento
				aadd(_aCabCTR,{"F1_VALBRUT"	,_nTotal		}) //Valor do conhecimento
				aadd(_aCabCTR,{"F1_FORMUL"	,2				}) //Formula
				aadd(_aCabCTR,{"F1_DOC"		,_cNrCTE		}) //F1_DOC - Numero do CTR
				aadd(_aCabCTR,{"F1_SERIE"	,_cSerie		}) //F1_SERIE - Serie do CTR
				aadd(_aCabCTR,{"F1_FORNECE"	,SA2->A2_COD	}) //F1_FORNECE - Transportador - Fornecedor CTR
				aadd(_aCabCTR,{"F1_LOJA"	,SA2->A2_LOJA	}) //F1_LOJA - Transportador - LOJA       CTR
				//				aadd(_aCabCTR,{""			,SC7->C7_TES	}) //TES
				aadd(_aCabCTR,{"F1_TES"		,SC7->C7_TES	}) //TES
				aadd(_aCabCTR,{"F1_BRICMS"	,_nBaseICMS		}) //BASE ICMS
				aadd(_aCabCTR,{"F1_ICMRET"	,0				}) //ICMS Ret
				aadd(_aCabCTR,{"F1_COND"	,SC7->C7_COND	}) //Condicao de pagamento
				aadd(_aCabCTR,{"F1_EMISSAO"	,dDataBase		}) //BASE ICMS
				aadd(_aCabCTR,{"F1_ESPECIE"	,"CTE"			}) //Espécie
				aadd(_aCabCTR,{"E2_NATUREZ"	,SA2->A2_NATUREZ}) //Espécie
				aadd(_aCabCTR,{"F1_CHVNFE"	, _cChave		})
				
				lMsErroAuto := .F.
				
				MsExecAuto({|x,y| MATA116(x,y)},_aCabCTR,_aItCTR)
				
				If lMsErroAuto
					Mostraerro()
				Else
					If __CopyFile(_cDirRede+_aListFile[F][4],_cDirRede+'bkp\'+_aListFile[F][4])
						FErase(_cDirRede+_aListFile[F][4])
						FErase(_cDir+_aListFile[F][4])
					Endif
				EndIf
				
			Endif
			
		Else
			MsgAlert('O CNPJ '+_cCNPJDest+' no CTE '+_cNumCTE+' é diferente da Filial Atual!')
//			CpyS2T(_cDirRede+_aListFile[F][4],_cDir,.T.)
			FErase(_cDirRede+_aListFile[F][4])
			Return(Nil)
		Endif
	Next F
	
Return(Nil)



/*/{Protheus.doc} CR098PC
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
Static Function CR098PC(_cForCod,_cForLoj,_cForNom,_nTotal)
	
	Local _aListPed	:= {}
	Local _oOk	 	:= LoadBitmap(GetResources(), "LBOK")
	Local _oNo		:= LoadBitmap(GetResources(), "LBNO")
	Local _oDlg2	:= Nil
	Local _oListPed	:= Nil
	Local F			:= 0
	
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
		
		_oTSay2 := TSay():New( 10,180,{||'Valor XML:'},_oDlg2,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,20)
		_oTGet2 := TGet():New( 10,220,{||_nTotal},_oDlg2,50,10,"@e 9,999,999.99",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,Str(_nTotal),,,, )
		
		_oListPed := TWBrowse():New( 30,10,305,100,,{'','Pedido','Item','Produto','Quantidade','Valor','Entrega'},,_oDlg2,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
		
		_oListPed:SetArray(_aListPed)
		_oListPed:bLine := {||{If(_aListPed[_oListPed:nAt,1],_oOk,_oNo ),_aListPed[_oListPed:nAt,2],_aListPed[_oListPed:nAt,3],_aListPed[_oListPed:nAt,4],;
			Transform(_aListPed[_oListPed:nAt,5],"@e 9,999,999.99"),;
			Transform(_aListPed[_oListPed:nAt,6],"@e 9,999,999.99"),;
			_aListPed[_oListPed:nAt,7] } }
		
		_oListPed:bLDblClick := {||If( _aListPed[_oListPed:nAt,6] <> _nTotal,MsgAlert("Valor do pedido diferente do XML"),CheckBox(_aListPed,_oListPed))}
		
		_oTButOk	:= TButton():New( 140, 010, "OK"		,_oDlg2,{||If(CheckList(2,_aListPed),_oDlg2:End(),MsgAlert("Não foi marcado nenhum Pedido!"))}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		_oTButOk	:= TButton():New( 140, 060, "Cancelar"	,_oDlg2,{||_oDlg2:End()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		
		ACTIVATE MSDIALOG _oDlg2 CENTERED
		
	Endif
	
Return(_aPedido)



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
