#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'

/*/{Protheus.doc} AS_XML
Importação de XML para as tabelas SDS e SDT
@type function
@author Fabiano
@since 08/11/2016
@version 1.0
@return ${return}, ${return_description}
/*/

User Function AS_IMPXML(_cTipo)
	
	Local _oDlg
	Local _lGo 		:= .F.
	Local _oSay
	Local _cDirXML	:= SuperGetMv('AS_DIRXML',,'\XML')
	Local _nXML		:= 0
	Local _cAviso	:= ""
	Local _cErro	:= ""
	
	Default _cTipo := 'M'
	
	
	// Joga a "\" no final do diretório
	_cDirXML += If(Right(Alltrim(_cDirXML), 1 ) <> '\', '\', '' )
	
	If _cTipo == 'M'
		
		DEFINE DIALOG _oDlg TITLE OemToAnsi("Importação XML") FROM 0,0 TO 200,300 Of _oDlg PIXEL
		
		_oDlg:lEscClose := .F. //Não permite fechar a janela pelo botão "ESC"
		
		//		@ 005,005 TO 065,145 LABEL "" OF _oDlg PIXEL
		
		_oSay := TSay():New(10,10,{||'Este programa tem a finalidade de Importação dos arquivos XML:'},_oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
		
		_oTButOk	:= TButton():New( 050, 010, "OK"		,_oDlg,{||_lGo := .T.,_oDlg:End()}	, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		_oTButCanc 	:= TButton():New( 050, 100, "Cancelar"	,_oDlg,{||_oDlg:End()}				, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		
		ACTIVATE MSDIALOG _oDlg CENTERED
		
	Else
		_lGo := .T.
	Endif
	
	If !_lGo
		Return(Nil)
	Endif
	
	//Verifica se existe arquivo para ser importado
	_aXML := Directory(_cDirXML+'*.xml')
	
	If Empty(_aXML)
		If _cTipo == "M"
			MsgAlert("Não existem arquivos para serem importados no momento!")
		Else
			Conout("Não existem arquivos para serem importados no momento!")
		Endif
		Return(Nil)
	Endif
	
	For _nXML := 1 To Len(_aXML)
		
		Private oNfeXML 	:= XmlParserFile(_cDirSrv+_aXml[_nXML],"_",@_cErro,@_cAviso)
		Private oNfe 		:= oNfeXML:_NFeProc
		Private oDPEC		:= oNfeDPEC
		Private oNF			:= oNFe:_NFe
		Private oProtNF		:= oNFe:_ProtNfe
		Private oInfNFe		:= oNF:_InfNfe
		Private oEmitente	:= oInfNFe:_Emit
		Private oIdent		:= oInfNFe:_IDE
		Private oDestino	:= oInfNFe:_Dest
		Private oTotal		:= oInfNFe:_Total
		Private oTransp		:= oInfNFe:_Transp
		Private oDet		:= oInfNFe:_Det
		Private oFatura		:= IIf(Type("oNF:_InfNfe:_Cobr")=="U",Nil,oInfNFe:_Cobr)
		Private oImposto
		
		_cCNPJDest	:= Alltrim(oDestino:_CNPJ:TEXT)
		
		If _cCNPJRem != Alltrim(SM0->M0_CGC)
			If _cTipo == "M"
				MsgAlert('CNPJ do Destinatário do XML '+aXml+' não é o mesmo da Filial corrente!')
			Else
				Conout('CNPJ do Destinatário do XML '+aXml+' não é o mesmo da Filial corrente!')
			Endif
			Loop
		Endif
		
		If Type("oNFe:_NFeProc") == "U"
			If _cTipo == "M"
				MsgAlert('O xml '+aXml+' não é referente à uma NF-e!')
			Else
				Conout('O xml '+aXml+' não é referente à uma NF-e!')
			Endif
			Loop
		Endif
		
		_nFaturas	:= If(oFatura<>Nil,IIf(ValType(oInfNFe:_Cobr:_Dup)=="A",Len(oInfNFe:_Cobr:_Dup),1),0)
		oDet		:= If(ValType(oDet)=="O",{oDet},oDet)
		_cCNPJ		:= oEmitente:_CNPJ:Text
		
		//Verifica se o Fornecedor existe
		SA2->(dbSelectArea(3))
		If !SA2->(msSeek(xFilial("SA2")+oEmitente:_CNPJ:Text))
			If _cTipo == "M"
				MsgAlert('Fornecedor não encontrado!')
			Else
				Conout('Fornecedor não encontrado!')
			Endif
			Loop
		Endif
		
		//Verifica se a Transportadora existe
		SA4->(dbSelectArea(3))
		If !SA4->(msSeek(xFilial("SA4")+oEmitente:_Transporta:_CNPJ:Text))
			If _cTipo == "M"
				MsgAlert('Fornecedor não encontrado!')
			Else
				Conout('Fornecedor não encontrado!')
			Endif
			Loop
		Endif
		
		//Cabeçalho XML
		SDS->(RecLock("SDS",.T.))
		SDS->DS_FILIAL	:= xFilial("SDS")									//C-2		Filial
		SDS->DS_VERSAO	:= oInfNFe:_VERSAO:TEXT								//C-5		Versao Layout da NFe
		SDS->DS_CHAVENF	:= oProtNF:_InfProt:_chNFE:Text						//C-44		Chave de Acesso da NF
		//		SDS->DS_TIPO												//C-1		Tipo da Nota
		SDS->DS_DOC		:= PadL(oIdent:_serie:Text,9,"0")					//C-9		Num.Doc
		SDS->DS_SERIE	:= PadR(oIdent:_nNF:Text,3)							//C-3		Série
		SDS->DS_FORNEC	:= SA2->A2_COD										//C-6		Fornecedor
		SDS->DS_LOJA	:= SA2->A2_LOJA										//C-2		Loja
		SDS->DS_NOMEFOR	:= SA2->A2_NOME										//C-40		Nome
		SDS->DS_CNPJ	:= SA2->A2_CGC										//C-14		CNPJ
		_dDataEmi := cTod(Substr(oIDENT:_DHEMI:Text,9,2) +'/'+ Substr(oIDENT:_DHEMI:Text,6,2) +'/'+ Left(oIDENT:_DHEMI:Text,4))
		SDS->DS_EMISSA	:= _dDataEmi										//D-8		Emissao
		SDS->DS_HORNFE	:= Substr(oIDENT:_DHEMI:Text,12,5)					//C-6		Hora da emissao da NF-e
		SDS->DS_FORMUL	:= 'N'												//C-1		Formulário Próprio
		SDS->DS_ESPECI	:= "SPED"											//C-5		Espécie
		SDS->DS_EST		:= SA2->A2_EST										//C-2		UF de Emissão
		//SDS->DS_STATUS	- C-1		Status do Registro
		SDS->DS_ARQUIVO	:= _aXml[_nXML]										//C-80		Nome do Arquivo XML
		SDS->DS_USERIMP	:= UsrRetName(RetCodUsr())							//C-25		Usuario na importacao
		SDS->DS_DATAIMP	:= dDataBase										//D-8		Data importacao do XML
		SDS->DS_HORAIMP	:= Time()											//C-5		Hora importacao XML
		//		SDS->DS_USERPRE	- C-25		Usuario gerou pre-nota
		//		SDS->DS_DATAPRE	- C-8		Data de geracao de Pre-NF
		//		SDS->DS_HORAPRE	- C-5		Hora geracao Pre-NF
		If Type("oTotal:_ICMSTot:_vFrete") <> "U"
			SDS->DS_FRETE	:= Val(oTotal:_ICMSTot:_vFrete:Text)			//N-14,2	Valor do Frete
		Endif
		If Type("oTotal:_ICMSTot:_vSeg") <> "U"
			SDS->DS_SEGURO	:= Val(oTotal:_ICMSTot:_vSeg:Text)				//N-14,2	Vlr.Seguro
		Endif
		If Type("oTotal:_ICMSTot:_vOutro") <> "U"
			SDS->DS_DESPESA	:= Val(oTotal:_ICMSTot:_vOutro:Text)			//N-14,2	Valor das despesas
		Endif
		If Type("oTotal:_ICMSTot:_vDesc") <> "U"
			SDS->DS_DESCONT	:= Val(oTotal:_ICMSTot:_vDesc:Text)				//N-14,2	Descontos da nota fiscal
		Endif
		SDS->DS_BASEICM	:= Val(oTotal:_ICMSTot:_vBC:Text)					//N-14,2	Base de calculo para ICMS
		SDS->DS_VALICM	:= Val(oTotal:_ICMSTot:_vICMS:Text)					//N-14,2	Valor do ICMS
		SDS->DS_VALMERC	:= Val(oTotal:_ICMSTot:_vProd:Text)					//N-14,2	Valor da mercadoria
		SDS->DS_TPFRETE	:= oTransp:_ModFrete:Text							//C-1		Indica Tipo de Frete
		SDS->DS_TRANSP	:= SA4->A4_COD										//C-6		Codigo da Transportadora
		If Type("oTransp:_Vol:_Pesol") <> "U"
			SDS->DS_PLIQUI	:= Val(oTransp:_Vol:_Pesol:Text)				//N-11,4	Peso Liquido da N.F.
		Endif
		If Type("oTransp:_Vol:_PesoB") <> "U"
			SDS->DS_PBRUTO	:= Val(oTransp:_Vol:_PesoB:Text)				//N-11,4	Peso Bruto da N.F.
		Endif
		If Type("oTransp:_Vol:_esp") <> "U"
			SDS->DS_ESPECI1	:= oTransp:_Vol:_esp:Text						//C-10		Especie 1
		Endif
		If Type("oTransp:_Vol:_qVol") <> "U"
			SDS->DS_VOLUME1	:= Val(oTransp:_Vol:_qVol:Text)					//N-6		Volume 1
		Endif
		If Type("oTransp:_veicTransp:_placa") <> "U"
			SDS->DS_PLACA	:= oTransp:_veicTransp:_placa:Text				//C-8		Placa Veiculo
		Endif
		//		SDS->DS_ESPECI2	- C-10		Especie 2
		//		SDS->DS_ESPECI3	- C-10		Especie 3
		//		SDS->DS_ESPECI4	- C-10		Especie 4
		//		SDS->DS_VOLUME2	- N-6		Volume 2
		//		SDS->DS_VOLUME3	- N-6		Volume 3
		//		SDS->DS_VOLUME4	- N-6		Volume 4
		//		SDS->DS_DOCLOG	- M-10		Log. da Ocorrencia
		//		SDS->DS_OK		- C-2		OK
		//		SDS->DS_SDOC	- C-3		Serie do Documento Fiscal
		//		SDS->DS_CODNFE	- C-50		Codigo verificacao NF-e
		//		SDS->DS_NUMRPS	- C-12		Numero do RPS
		*/
		
		oDet := If(ValType(oDet)=="O",{oDet},oDet)
		
		For _nDet := 1 To Len(oDet)
			
			_cProd := PadR(oDet[_nDet]:_Prod:_cProd:Text,15)
			
			SA5->(dbSetOredr(1))
			If !SA5->(msSeek(xFilial("SA5")+SA2->A2_COD+SA2->A2_LOJA+_cProd))
				If _cTipo == "M"
					MsgAlert('Produto X Fornecedor não encontrado - '+Alltrim(_cProd)+'.')
				Else
					Conout('Produto X Fornecedor não encontrado - '+Alltrim(_cProd)+'.')
				Endif
				Loop
			Endif
			
			SB1->(dbSetOrder(1))
			If !SB1->(msSeek(xFilial("SB1")+SA5->A5_PRODUTO))
				If _cTipo == "M"
					MsgAlert('Produto não encontrado - '+Alltrim(SA5->A5_PRODUTO)+'.')
				Else
					Conout('Produto não encontrado - '+Alltrim(SA5->A5_PRODUTO)+'.')
				Endif
				Loop
			Endif
			
			//Itens do XML
			SDT->(RecLock("SDT",.T.))
			SDT->DT_FILIAL	:= xFilial("SDT")							//C-2		Filial
			SDT->DT_ITEM	:= PadL(cValToChar(_nDet),4,"0")			//C-4		Item
			SDT->DT_COD		:= SA5->A5_PRODUTO							//C-15		Produto
			SDT->DT_DESC	:= oDet[_nDet]:_Prod:_xProd:Text			//C-30		Descrição do Produto
			SDT->DT_PRODFOR	:= _cProd									//C-15		Cod. Prod. do Forn/Cli
			SDT->DT_DESCFOR	:= oDet[_nDet]:_Prod:_xProd:Text			//C-30		Desc. Produto Forn/Cli
			SDT->DT_FORNEC	:= SA2->A2_COD								//C-6		Codigo do Forn/Cliente
			SDT->DT_LOJA	:= SA2->A2_LOJA								//C-2		Loja do Forn/Cliente
			SDT->DT_DOC		:= PadL(oIdent:_serie:Text,9,"0")			//C-9		Numero do Documento/Nota
			SDT->DT_SERIE	:= PadR(oIdent:_nNF:Text,3)					//C-3		Serie da Nota Fiscal
			SDT->DT_CNPJ	:= SA2->A2_CGC								//C-14		CNPJ Fornecedor/Cliente
			SDT->DT_QUANT	:= Val(oDet[_nDet]:_Prod:_qCom:Text)		//N-14,2	Quantidade do Produto
			SDT->DT_VUNIT	:= Val(oDet[_nDet]:_Prod:_vUnCom:Text)		//N-14,2	Valor Unitario
			SDT->DT_TOTAL	:= Val(oDet[_nDet]:_Prod:_vProd:Text)		//N-14,2	Valor Total
			If Type("oDet[_nDet]:_Prod:_xPed") <> "U"
				SDT->DT_PEDIDO	:= oDet[_nDet]:_Prod:_xPed:Text			//C-6		Numero do Pedido Compra
			Endif
			If Type("oDet[_nDet]:_Prod:_nItemPed") <> "U"
				SDT->DT_ITEMPC	:= oDet[_nDet]:_Prod:_nItemPed:Text		//C-4		Item Pedido de Compra
			Endif
			//			SDT->DT_NFORI	- C-9		Documento Original
			//			SDT->DT_SERIORI	- C-3		Serie do Doc. Original
			//			SDT->DT_ITEMORI	- C-4		Item do Docto. de Origem
			
			If Type("oDet[_nDet]:_Prod:_vFrete") <> "U"
				SDT->DT_VALFRE	:= Val(oDet[_nDet]:_Prod:_vFrete:Text)	//N-14,2	Valor do Frete
			Endif
			If Type("oDet[_nDet]:_Prod:_vSeg") <> "U"
				SDT->DT_SEGURO	:= Val(oDet[_nDet]:_Prod:_vSeg:Text)	//N-14,2	Vlr.Seguro
			Endif
			If Type("oDet[_nDet]:_Prod:_vOutro") <> "U"
				SDT->DT_DESPESA	:= Val(oDet[_nDet]:_Prod:_vOutro:Text)	//N-14,2	Valor das despesas
			Endif
			If Type("oDet[_nDet]:_Prod:_vDesc") <> "U"
				SDT->DT_VALDESC	:= Val(oDet[_nDet]:_Prod:_vDesc:Text)	//N-14,2	Valor do Desconto no Item
			Endif
			
			If Type("oDet[_nDet]:_Imposto:_ICMS") <> "U"
				If Type("oDet[_nDet]:_Imposto:_ICMS:ICMS00") <> "U"//Tributada integralmente
					//					SDT->DT_??????	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS00:_vBc:Text)		//N-14,2	Base ICMS?
					SDT->DT_XALQICM	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS00:_pICMS:Text)	//N-6,2		Aliquota ICMS do XML
					SDT->DT_XMLICM	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS00:_vICMS:Text)	//N-14,2	ICMS importado do XML
				Endif
				If Type("oDet[_nDet]:_Imposto:_ICMS:ICMS10") <> "U"//Tributada e com cobrança do ICMS por substituição tributária
					//					SDT->DT_??????	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS10:_vBc:Text)		//N-14,2	Base ICMS?
					SDT->DT_XALQICM	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS10:_pICMS:Text)	//N-6,2		Aliquota ICMS do XML
					SDT->DT_XMLICM	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS10:_vICMS:Text)	//N-14,2	ICMS importado do XML
					//					SDT->DT_?????	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS10:_vBCST:Text)	//N-14,2	Base ICMS ST
					//					SDT->DT_?????	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS10:_pICMS:Text)	//N-14,2	Alíquota ICMS ST importado do XML
					//					SDT->DT_?????	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS10:_vICMSST:Text)	//N-14,2	ICMS ST importado do XML
				Endif
				If Type("oDet[_nDet]:_Imposto:_ICMS:ICMS20") <> "U" //Tributação com redução de base de cálculo
					//					SDT->DT_??????	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS20:_vBc:Text)		//N-14,2	Base ICMS?
					SDT->DT_XALQICM	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS20:_pICMS:Text)	//N-6,2		Aliquota ICMS do XML
					SDT->DT_XMLICM	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS20:_vICMS:Text)	//N-14,2	ICMS importado do XML
				Endif
				If Type("oDet[_nDet]:_Imposto:_ICMS:ICMS30") <> "U" //Tributação Isenta ou não tributada e com cobrança do ICMS por substituição tributária
					//					SDT->DT_?????	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS30:_vBCST:Text)	//N-14,2	Base ICMS ST
					//					SDT->DT_?????	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS30:_pICMS:Text)	//N-14,2	Alíquota ICMS ST importado do XML
					//					SDT->DT_?????	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS30:_vICMSST:Text)	//N-14,2	ICMS ST importado do XML
				Endif
				If Type("oDet[_nDet]:_Imposto:_ICMS:ICMS70") <> "U" //Tributação ICMS com redução de base de cálculo e cobrança do ICMS por substituição tributária
					//					SDT->DT_??????	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS70:_vBc:Text)		//N-14,2	Base ICMS?
					SDT->DT_XALQICM	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS70:_pICMS:Text)	//N-6,2		Aliquota ICMS do XML
					SDT->DT_XMLICM	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS70:_vICMS:Text)	//N-14,2	ICMS importado do XML
					//					SDT->DT_?????	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS70:_vBCST:Text)	//N-14,2	Base ICMS ST
					//					SDT->DT_?????	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS70:_pICMS:Text)	//N-14,2	Alíquota ICMS ST importado do XML
					//					SDT->DT_?????	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS70:_vICMSST:Text)	//N-14,2	ICMS ST importado do XML
				Endif
				If Type("oDet[_nDet]:_Imposto:_ICMS:ICMS90") <> "U"//Tributação ICMS: Outros
					//					SDT->DT_??????	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS90:_vBc:Text)		//N-14,2	Base ICMS?
					SDT->DT_XALQICM	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS90:_pICMS:Text)	//N-6,2		Aliquota ICMS do XML
					SDT->DT_XMLICM	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS90:_vICMS:Text)	//N-14,2	ICMS importado do XML
					//					SDT->DT_?????	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS90:_vBCST:Text)	//N-14,2	Base ICMS ST
					//					SDT->DT_?????	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS90:_pICMS:Text)	//N-14,2	Alíquota ICMS ST importado do XML
					//					SDT->DT_?????	:= Val(oDet[_nDet]:_Imposto:_ICMS:ICMS90:_vICMSST:Text)	//N-14,2	ICMS ST importado do XML
				Endif
			Endif
			If Type("oDet[_nDet]:_Imposto:_IPI") <> "U"
				If Type("oDet[_nDet]:_Imposto:_IPI:_IPITrib") <> "U"
					//SDT->DT_??????	:= Val(oDet[_nDet]:_Imposto:_IPI:_IPITrib:_vBC:Text)	//N-14,2	Base IPI do XML
					SDT->DT_XALQIPI	:= Val(oDet[_nDet]:_Imposto:_IPI:_IPITrib:_pIPI:Text)	//N-6,2		Alíquota IPI importado do XML
					SDT->DT_XMLIPI	:= Val(oDet[_nDet]:_Imposto:_IPI:_IPITrib:_vIPI:Text)	//N-14,2	IPI importado do XML
				Endif
			Endif
			If Type("oDet[_nDet]:_Imposto:_PIS") <> "U"
				If Type("oDet[_nDet]:_Imposto:_PIS:_PISAliq") <> "U"
					//SDT->DT_??????	:= := Val(oDet[_nDet]:_Imposto:_PIS:_PISAliq:_vBC:Text)		//N-14,2	Base PIS importado do XML
					SDT->DT_XALQPIS	:= Val(oDet[_nDet]:_Imposto:_PIS:_PISAliq:_pPIS:Text)			//N-6,2		Aliquota PIS do XML
					SDT->DT_XMLPIS	:= Val(oDet[_nDet]:_Imposto:_PIS:_PISAliq:_vPIS:Text)			//N-14,2	PIS importado do XML
				Endif
			Endif
			If Type("oDet[_nDet]:_Imposto:_COFINS") <> "U"
				If Type("oDet[_nDet]:_Imposto:_COFINS:COFINSAliq") <> "U"
					//SDT->DT_???????	:= Val(oDet[_nDet]:_Imposto:_COFINS:_COFINSAliq:_vBC:Text)	//N-14,2	Base COFINS importado do XML
					SDT->DT_XALQCOF	:= Val(oDet[_nDet]:_Imposto:_COFINS:_COFINSAliq:_pCOFINS:Text)	//N-6,2		Aliquota COFINS do XML
					SDT->DT_XMLCOF	:= Val(oDet[_nDet]:_Imposto:_COFINS:_COFINSAliq:_vCOFINS:Text)	//N-14,2	COFINS importado do XML
				Endif
			Endif
			If Type("oDet[_nDet]:_Imposto:_ISSQN") <> "U"
				//SDT->DT_??????	:= Val(oDet[_nDet]:_Imposto:_ISSQN:_vBC:Text)					//N-14,2	Base ISS importado do XML
				SDT->DT_XALQISS		:= Val(oDet[_nDet]:_Imposto:_ISSQN:_vAliq:Text)					//N-6,2		Aliquota ISS do XML
				SDT->DT_XMLISS		:= Val(oDet[_nDet]:_Imposto:_ISSQN:_vISSQN:Text)				//N-14,2	ISS importado do XML
			Endif
			
			//			SDT->DT_ORIGIN	- C-1		Registro Original
			//			SDT->DT_FCICOD	- C-36		Codigo FCI
			//			SDT->DT_TES		- C-3		Tipo de Entrada/Saida
			//			SDT->DT_CODCFOP	- C-4		Codigo CFOP do Item
			//			SDT->DT_PICM	- N-5,2		Aliquota de ICMS
			//			SDT->DT_TESICM	- N-14,2	ICMS calculado pela TES
			//			SDT->DT_TESISS	- N-14,2	ISS Calculado pela TES
			//			SDT->DT_TESPIS	- N-14,2	PIS calculado pela TES
			//			SDT->DT_TESCOF	- N-14,2	COFINS Calculado TES
			//			SDT->DT_ALIQIPI	- N-6,2		Aliquota IPI
			//			SDT->DT_ALIQICM	- N-6,2		Aliquota ICMS
			//			SDT->DT_ALIQISS	- N-6,2		Aliquota ISS
			//			SDT->DT_ALIQPIS	- N-6,2		Aliquota PIS
			//			SDT->DT_ALIQCOF	- N-6,2		Aliquota COFINS
			//			SDT->DT_LOCAL	- N-6,2		Armazem
			//			SDT->DT_LOTE	- C-10		Numero do Lote
			//			SDT->DT_DTVALID	- D-8		Validade do Lote
			//			SDT->DT_SDOC	- C-3		Serie do Documento Fiscal
			//			SDT->DT_SDOCORI	- C-3		Serie da N.F. Original
			//			SDT->DT_CFOP	- C-4		Valida o CFOP Ret.Ben
			
		Next _nDet
	Next _nXML
	
Return(Nil)
