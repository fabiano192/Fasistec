#INCLUDE "TOTVS.CH"

#Define SEM_PRODUTO 0
#Define SEM_PEDIDO 1
#Define PEDIDO_DIVERGENTE 2
#Define PEDIDO_OK 3
#Define SEM_NF_ORIGINAL 4

#Define NF_OK 1
#Define NF_NOK 2
#Define NF_SEM_FORNECEDOR 3

User Function AS_BAIXAXML()

	Local _cDir		:= SuperGetMv("AS_DIRXML",,"\Gestor_XML\")//"\\SRVCRONNOS01\ERP\EDI\Caterpillar\Exportacao\Download\830\"
	Local _aListXML	:= Directory( _cDir + '*.xml' )
	Local _nI		:= 0
	Local _cFile	:= ""
	Local _cFileBkp	:= ""
	Local _cDir_File:= ""
	Local _cError	:= ""
	Local _cWarning	:= ""
	Local _oXML		:= NIl
	Local _cBuffer	:= ''
	Local _cCod		:= ''
	Local _cTes		:= ''
	Local _cData	:= ''
	Local _cHora	:= ''

	ProcRegua(Len( _aListXML ))

	For _nI :=1 To Len( _aListXML )

		IncProc()

		_cFile		:= AllTrim(_aListXML[_nI][1])
		_cDir_File	:= _cDir+AllTrim(_aListXML[_nI][1])

		FT_FUSE( _cDir_File )
		FT_FGOTOP()

		Do While !FT_FEOF()

			_cBuffer := FT_FREADLN()

			FT_FSKIP()
		EndDo

		FT_FUSE() //Fechar o arquivo

		If !Empty(_cBuffer)

			//Gera o Objeto XML
			_oXML  := XmlParserFile(_cDir_File, "_", @_cError, @_cWarnIng )

			If _oXML != NIL

				_oNFE			:= _oXML:_NFEPROC:_NFE
				_oProtnfe		:= _oXML:_NFEPROC:_PROTNFE

				_cTipo := ""
				If _oNFE:_INFNFE:_IDE:_FINNFE:TEXT = "1"
					_cTipo := "N"
				ElseIf _oNFE:_INFNFE:_IDE:_FINNFE:TEXT = "2"
					_cTipo := "C"
				Elseif _oNFE:_INFNFE:_IDE:_FINNFE:TEXT = "4"
					_cTipo := "D"
				Endif

				_cForn := _cLoja := _cNome := ''

				If _cTipo = "D"
					SA1->(dbSetOrder(3))
					If SA1->(msSeek(xFilial("SA1")+_oNFE:_INFNFE:_EMIT:_CNPJ:TEXT))
						_cForn := SA1->A1_COD
						_cLoja := SA1->A1_LOJA
						_cNome := SA1->A1_NREDUZ
					Endif
				Else
					SA2->(dbSetOrder(3))
					If SA2->(msSeek(xFilial("SA2")+_oNFE:_INFNFE:_EMIT:_CNPJ:TEXT))
						_cForn := SA2->A2_COD
						_cLoja := SA2->A2_LOJA
//						_cNome := SA2->A2_NREDUZ
						_cNome := SA2->A2_NOME
					Endif
				Endif

				ZA1->(RecLock("ZA1",.T.))
				ZA1->ZA1_FILIAL		:= xFilial("ZA1")
				ZA1->ZA1_CHAVE		:= _OPROTNFE:_INFPROT:_CHNFE:TEXT
				ZA1->ZA1_FORNEC		:= _cForn
				ZA1->ZA1_LOJA		:= _cLoja
				ZA1->ZA1_NOME		:= _cNome
				ZA1->ZA1_SERIE		:= _oNFE:_INFNFE:_IDE:_SERIE:TEXT
				ZA1->ZA1_DOC		:= Padl(Alltrim(_oNFE:_INFNFE:_IDE:_NNF:TEXT),9,"0")
				ZA1->ZA1_EMISSAO	:= Ctod(Substr(_oNFE:_INFNFE:_IDE:_DHEMI:TEXT,9,2)+"/"+Substr(_oNFE:_INFNFE:_IDE:_DHEMI:TEXT,6,2)+"/"+Left(_oNFE:_INFNFE:_IDE:_DHEMI:TEXT,4))
				ZA1->ZA1_XML		:= _cBuffer
				ZA1->ZA1_NOMARQ		:= AllTrim(_aListXML[_nI][1])
				ZA1->ZA1_STATUS		:= If(Empty(_cForn),NF_SEM_FORNECEDOR,NF_NOK)
				ZA1->ZA1_USER		:= UsrRetName(RetCodUsr())
				ZA1->ZA1_TIPO		:= "NFE"
				ZA1->ZA1_DTIMP		:= dDataBase
				ZA1->ZA1_TIPO2		:= _cTipo
				ZA1->ZA1_CNPJ		:= _oNFE:_INFNFE:_EMIT:_CNPJ:TEXT
				ZA1->(MsUnlock())

				IF Type("_oNFE:_INFNFE:_DET") == "A"
					_nFor  := Len(_oNFE:_INFNFE:_DET)
					_InfCh := "_oNFE:_INFNFE:_DET[_cB]"
				Else
					_nFor := 1
					_InfCh := "_oNFE:_INFNFE:_DET"
				Endif

				For _cB := 1 To _nFor

					_cCod := _cTes := ''
					SA5->(dbSetOrder(14))
					If SA5->(msSeek(xFilial("SA5")+_cForn+_cLoja+&(_InfCh):_PROD:_CPROD:TEXT))
						_cCod := SA5->A5_PRODUTO
						_cTes := SA5->A5_YTES
					Endif

					_cPed   := ''
					_cItPed := ''
					IF Type(_InfCh+":_PROD:_XPED:TEXT") != "U"
						_cPed := &(_InfCh):_PROD:_XPED:TEXT
						IF Type(_InfCh+":_PROD:_ITEMPED:TEXT") != "U"
							_cItPed := &(_InfCh):_PROD:_ITEMPED:TEXT
						Endif
					Endif

					_nBaseICMS	:= _nPercICMS := _nValICMS := 0
					IF Type(_InfCh+":_IMPOSTO:_ICMS:_ICMS00:_VBC") != "U"
						_nBaseICMS	:= Val(&(_InfCh):_IMPOSTO:_ICMS:_ICMS00:_VBC:TEXT)
						_nPercICMS	:= Val(&(_InfCh):_IMPOSTO:_ICMS:_ICMS00:_PICMS:TEXT)
						_nValICMS	:= Val(&(_InfCh):_IMPOSTO:_ICMS:_ICMS00:_VICMS:TEXT)
					Endif

					_nBasIPI	:= _nAlqIPI := _nValIPI := 0
					IF Type(_InfCh+":_IMPOSTO:_IPI:_IPITRIB:_VBC") != "U"
						_nBasIPI  := Val(&(_InfCh):_IMPOSTO:_IPI:_IPITRIB:_VBC:TEXT)
						_nAlqIPI  := Val(&(_InfCh):_IMPOSTO:_IPI:_IPITRIB:_PIPI:TEXT)
						_nValIPI  := Val(&(_InfCh):_IMPOSTO:_IPI:_IPITRIB:_VIPI:TEXT)
					Endif

					ZA2->(RecLock("ZA2",.T.))
					ZA2->ZA2_FILIAL		:= xFilial("ZA2")
					ZA2->ZA2_SERIE		:= _oNFE:_INFNFE:_IDE:_SERIE:TEXT
					ZA2->ZA2_DOC		:= Padl(Alltrim(_oNFE:_INFNFE:_IDE:_NNF:TEXT),9,"0")
					ZA2->ZA2_ITEM		:= PadL(_cB,TamSx3("ZA2_ITEM")[1],'0')
					ZA2->ZA2_FORNEC		:= _cForn
					ZA2->ZA2_LOJA		:= _cLoja
					ZA2->ZA2_COD		:= _cCod
					ZA2->ZA2_PROCLI		:= &(_InfCh):_PROD:_CPROD:TEXT
					ZA2->ZA2_DESPRO		:= &(_InfCh):_PROD:_XPROD:TEXT
					ZA2->ZA2_UM			:= &(_InfCh):_PROD:_UCOM:TEXT
					ZA2->ZA2_QUANT		:= Val(&(_InfCh):_PROD:_QCOM:TEXT)
					ZA2->ZA2_VUNIT		:= Val(&(_InfCh):_PROD:_VUNCOM:TEXT)
					ZA2->ZA2_VTOTAL		:= Val(&(_InfCh):_PROD:_VPROD:TEXT)
					ZA2->ZA2_TES		:= _cTes
					ZA2->ZA2_CFOP		:= If(Left(&(_InfCh):_PROD:_CFOP:TEXT,1) = "5","1","2")+Right(&(_InfCh):_PROD:_CFOP:TEXT,3)
					ZA2->ZA2_PEDIDO		:= _cPed
					ZA2->ZA2_ITEMPC		:= _cItPed
					ZA2->ZA2_BICMS		:= _nBaseICMS
					ZA2->ZA2_PICMS		:= _nPercICMS
					ZA2->ZA2_VICMS		:= _nValICMS
					ZA2->ZA2_BIPI		:= _nBasIPI
					ZA2->ZA2_PIPI		:= _nAlqIPI
					ZA2->ZA2_VIPI		:= _nValIPI
					ZA2->ZA2_STATUS		:= SEM_PRODUTO
					ZA2->(MsUnlock())
				Next _cB

				_oXML	:= Nil
				_cData	:= GravaData(dDataBase,.f.,8)
				_cHora	:= Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)

				_cFileBkp := Left(_cFile,Len(_cFile)-4)+"_"+_cData+"_"+_cHora+".xml"

				If __CopyFile( _cDir_File, _cDir+"Processado\"+_cFileBkp )
					FErase(_cDir_File)
				Endif
			Endif
		Endif

	Next _nI

	U_AS_GetXML(2)

Return(Nil)

