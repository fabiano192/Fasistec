#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"

#DEFINE IMP_SPOOL 2

#DEFINE VBOX       080
#DEFINE VSPACE     008
#DEFINE HSPACE     010
#DEFINE SAYVSPACE  008
#DEFINE SAYHSPACE  008
#DEFINE HMARGEM    030
#DEFINE VMARGEM    030
#DEFINE MAXITEM    022                                                // Máximo de produtos para a primeira página
#DEFINE MAXITEMP2  049                                                // Máximo de produtos para a pagina 2 em diante
#DEFINE MAXITEMP2F 069                                                // Máximo de produtos para a página 2 em diante quando a página não possui informações complementares
#DEFINE MAXITEMP3  049                                                // Máximo de produtos para a pagina 2 em diante (caso utilize a opção de impressao em verso) - Tratamento implementado para atender a legislacao que determina que a segunda pagina de ocupar 50%.
#DEFINE MAXITEMC   038                                                // Máxima de caracteres por linha de produtos/serviços
#DEFINE MAXMENLIN  090                                                // Máximo de caracteres por linha de dados adicionais
#DEFINE MAXMSG     013                                                // Máximo de dados adicionais por página
#DEFINE MAXVALORC  009                                                // Máximo de caracteres por linha de valores numéricos

/*/{Protheus.doc} AS_Danfe
Impressão da Danfe conforme XML
@type function
@author Fabiano
@since 21/10/2016
@version 1.0
@param ${_aDanfe, ${Array}, ${Vetor com os XML's à serem impressos}
@return ${return}, ${return_description}
/*/

User Function AS_Danfe(_aDanfe,_aFldCab)

	Local aArea     	:= GetArea()
	Local lExistNfe 	:= .F.

	Private nConsNeg 	:= 0.4 // Constante para concertar o cálculo retornado pelo GetTextWidth para fontes em negrito.
	Private nConsTex 	:= 0.5 // Constante para concertar o cálculo retornado pelo GetTextWidth.
	Private	_cDirSrv	:= '\XMLDFE\'


	_cLocal := GetnewPar("MV_YNFEPDF","C:\DANFEPDF\")
	lPreview := .T.

	If !ExistDir( _cLocal )
		If MakeDir( _cLocal ) <> 0
			MsgAlert(  "Impossível criar diretorio ( "+_cLocal+" ) " )
			Return
		EndIf
	EndIf

	Private _cNome	:= "DANFE_"+dTos(dDataBase)+"_"+Left(Time(),2)+Substr(Time(),4,2)+Right(Time(),2)

	Private _oDanfe	:= FWMSPrinter():New(_cNome    , 6       ,.F.,       ,.T. ,.F. , , ,.F. ,.F., ,.T. )

	_oDanfe:SetResolution(78) //Tamanho estipulado para a Danfe
	_oDanfe:SetPortrait()
	_oDanfe:SetPaperSize(DMPAPER_A4)
	_oDanfe:SetMargin(60,60,60,60)
	_oDanfe:lServer := .F.
	// ----------------------------------------------
	// Define saida de impressão
	// ----------------------------------------------
	//	_oDanfe:nDevice := IMP_PDF
	_oDanfe:cPathPDF := _cLocal

	Private PixelX := _oDanfe:nLogPixelX()
	Private PixelY := _oDanfe:nLogPixelY()

	RptStatus({|lEnd| DanfeProc(@_oDanfe,@lEnd,,,@lExistNfe,_aDanfe,_aFldCab)},"Imprimindo Danfe...")

	If lExistNfe
		_oDanfe:Preview()//Visualiza antes de imprimir
	Else
		Aviso("DANFE","Nenhuma NF-e a ser impressa nos parametros utilizados.",{"OK"},3)
	EndIf

	FreeObj(_oDanfe)
	_oDanfe := Nil
	RestArea(aArea)

Return(.T.)



Static Function DanfeProc(_oDanfe,lEnd,cVal1,cVal2,lExistNfe,_aDanfe,_aFldCab)

	Local aArea     := GetArea()
	Local aXML      := {}

	Local cAviso    := ""
	Local cErro     := ""
	Local nX        := 0
	Local nI		:= 0

	Private oNfe	:= Nil

	For _nDanfe := 1 To Len(_aDanfe)

		If !_aDanfe[_nDanfe][1]
			Loop
		Endif

		_AreaZA1 := ZA1->(GetArea())

		//		ZA1->(dbGoTo(_aDanfe[_nDanfe][12]))
		ZA1->(dbGoTo(_aDanfe[_nDanfe][aScan(_aFldCab,{|x| x[1] == 'ZA1_RECNO' })]))

		aXml := ZA1->ZA1_XML

		RestArea(_AreaZA1)

		oXML := XmlParser(aXml,"_",@cErro,@cAviso)
		oNfeDPEC := Nil

		oNFE	:= oXML:_NFEPROC

		If Type("oNFe:_NFE:_INFNFE") == "U"
			MsgAlert('O xml '+aXml+' não é referente à uma NF-e!')
			Loop
		Endif

		ImpDet(@_oDanfe,oNFe,oNfeDPEC)

		lExistNfe := .T.

		delClassIntF()

	Next _nDanfe

	RestArea(aArea)

Return(.T.)


Static Function ImpDet(_oDanfe,oNfe,oNfeDPEC)

	Local aAuxCabec     := {} // Array que conterá as strings de cabeçalho das colunas de produtos/serviços.
	Local aTamanho      := {}
	Local aTamCol       := {} // Array que conterá o tamanho das colunas dos produtos/serviços.
	Local aSitTrib      := {}
	Local aSitSN        := {}
	Local aTransp       := {}
	Local aDest         := {}
	Local aHrEnt        := {}
	Local aFaturas      := {}
	Local aItens        := {}
	Local aISSQN        := {}
	Local aSimpNac		:= {}
	Local aTotais       := {}
	Local aAux          := {}
	Local aUF           := {}
	Local aMensagem     := {}
	Local aEspVol       := {}
	Local aResFisco     := {}
	Local aEspecie      := {}
	Local aIndImp	    := {}
	Local aIndAux	    := {}
	Local aLote         := {}

	Local nHPage        := 0
	Local nVPage        := 0
	Local nPosV         := 0
	Local nPosVOld      := 0
	Local nPosH         := 0
	Local nPosHOld      := 0
	Local nAuxH         := 0
	Local nAuxH2        := 0
	Local nAuxV         := 0
	Local nSnBaseIcm	 := 0
	Local nSnValIcm    := 0
	Local nDetImp		 := 0
	Local nS			 := 0
	Local nX            := 0
	Local nY            := 0
	Local nL            := 0
	Local nJ            := 0
	Local nW            := 0
	Local nTamanho      := 0
	Local nFolha        := 1
	Local nFolhas       := 0
	Local nItem         := 0
	Local nMensagem     := 0
	Local nBaseICM      := 0
	Local nValICM       := 0
	Local nValIPI       := 0
	Local nPICM         := 0
	Local nPIPI         := 0
	Local nFaturas      := 0
	Local nVTotal       := 0
	Local nQtd          := 0
	Local nVUnit        := 0
	Local nVolume	    := 0
	Local nLenFatura
	Local nLenVol
	Local nLenDet
	Local nLenSit
	Local nLenItens     := 0
	Local nLenMensagens := 0
	Local nLen          := 0
	Local nColuna	    := 0
	Local nLinSum	    := 0
	Local nRecSF3		:= 0
	Local nE		    := 0
	Local nPag
	Local nItensRes
	Local nSoma
	Local nZ		    := 0
	Local nMaxCod	    := 10
	Local nMaxDes	    := MAXITEMC
	Local nLinhavers    := 0
	Local nMaxItemP2    := MAXITEM // Variável utilizada para tratamento de quantos itens devem ser impressos na página corrente

	Local cAux          := ""
	Local cSitTrib      := ""
	Local cUF		 	:= ""
	Local cMVCODREG		:= " "
	Local cChaveCont 	:= ""
	Local cGuarda       := ""
	Local cEsp		    := ""
	local cEndDest      := ""
	local cStartPath 	:= GetSrvProfString("Startpath","")

	Local lPreview      := .F.
	Local lFlag         := .T.
	Local lConverte     := .F.
	Local lImpAnfav     := .F.
	Local lImpInfAd   	:= .F.
	Local lPagPar
	Local lMv_ItDesc    := .F.
	Local lNFori2 	    := .T.
	Local lFimpar	    := .T.
	Local lCompleECF    := .F.
	Local lEntIpiDev   	:= .F.
	Local cDhCont		:= ""
	Local cXJust		:= ""

	Local cGrpCompany	:= ""
	Local cCodEmpGrp	:= ""
	Local cUnitGrp		:= ""
	Local cFilGrp		:= ""

	Local lPontilhado	:= .F.

	Local aAuxCom		:= {}
	Local cUnCom		:= ""
	Local nQtdCom		:= 0
	Local nVUnitCom		:= 0

	Local lUf_MG		:= ( SuperGetMv("MV_ESTADO") $ "MG" )	// Criado esta variavel para atender o RICMS de MG para totalizar por CFOP
	Local nSequencia	:= 0
	Local nSubTotal		:= 0
	Local cCfop			:= ""
	Local cCfopAnt		:= ""
	Local aItensAux     := {}
	Local aArray		:= {}

	PRIVATE oFont10N   := TFontEx():New(_oDanfe,"Times New Roman",08,08,.T.,.T.,.F.)// 1
	PRIVATE oFont07N   := TFontEx():New(_oDanfe,"Times New Roman",06,06,.T.,.T.,.F.)// 2
	PRIVATE oFont07    := TFontEx():New(_oDanfe,"Times New Roman",06,06,.F.,.T.,.F.)// 3
	PRIVATE oFont08    := TFontEx():New(_oDanfe,"Times New Roman",07,07,.F.,.T.,.F.)// 4
	PRIVATE oFont08N   := TFontEx():New(_oDanfe,"Times New Roman",06,06,.T.,.T.,.F.)// 5
	PRIVATE oFont09N   := TFontEx():New(_oDanfe,"Times New Roman",08,08,.T.,.T.,.F.)// 6
	PRIVATE oFont09    := TFontEx():New(_oDanfe,"Times New Roman",08,08,.F.,.T.,.F.)// 7
	PRIVATE oFont10    := TFontEx():New(_oDanfe,"Times New Roman",09,09,.F.,.T.,.F.)// 8
	PRIVATE oFont11    := TFontEx():New(_oDanfe,"Times New Roman",10,10,.F.,.T.,.F.)// 9
	PRIVATE oFont12    := TFontEx():New(_oDanfe,"Times New Roman",11,11,.F.,.T.,.F.)// 10
	PRIVATE oFont11N   := TFontEx():New(_oDanfe,"Times New Roman",10,10,.T.,.T.,.F.)// 11
	PRIVATE oFont18N   := TFontEx():New(_oDanfe,"Times New Roman",17,17,.T.,.T.,.F.)// 12
	PRIVATE OFONT12N   := TFontEx():New(_oDanfe,"Times New Roman",11,11,.T.,.T.,.F.)// 12
	PRIVATE lUsaColab	  :=  UsaColaboracao("1")

	Private aInfNf    := {}
	Private oDPEC     := oNfeDPEC
	Private oNF       := oNFe:_NFe
	Private oEmitente := oNF:_InfNfe:_Emit
	Private oIdent    := oNF:_InfNfe:_IDE
	Private oDestino  := oNF:_InfNfe:_Dest
	Private oTotal    := oNF:_InfNfe:_Total
	Private oTransp   := oNF:_InfNfe:_Transp
	Private oDet      := oNF:_InfNfe:_Det
//	Private oFatura   := IIf(Type("oNF:_InfNfe:_Cobr")=="U",Nil,oNF:_InfNfe:_Cobr)
	Private oFatura   := IIf(Type("oNF:_InfNfe:_Cobr:_Dup")=="U",Nil,oNF:_InfNfe:_Cobr)
	Private oImposto
	Private nPrivate  := 0
	Private nPrivate2 := 0
	Private nXAux	  := 0

	nFaturas := IIf(oFatura<>Nil,IIf(ValType(oNF:_InfNfe:_Cobr:_Dup)=="A",Len(oNF:_InfNfe:_Cobr:_Dup),1),0)
	oDet := IIf(ValType(oDet)=="O",{oDet},oDet)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega as variaveis de impressao                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aSitTrib,"00")
	aadd(aSitTrib,"10")
	aadd(aSitTrib,"20")
	aadd(aSitTrib,"30")
	aadd(aSitTrib,"40")
	aadd(aSitTrib,"41")
	aadd(aSitTrib,"50")
	aadd(aSitTrib,"51")
	aadd(aSitTrib,"60")
	aadd(aSitTrib,"70")
	aadd(aSitTrib,"90")
	aadd(aSitTrib,"PART")

	aadd(aSitSN,"101")
	aadd(aSitSN,"102")
	aadd(aSitSN,"201")
	aadd(aSitSN,"202")
	aadd(aSitSN,"500")
	aadd(aSitSN,"900")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quadro Destinatario                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cEndDest := NoChar(oDestino:_EnderDest:_Xlgr:Text,lConverte)
	If  " SN" $ (UPPER (oDestino:_EnderDest:_Xlgr:Text)) .Or. ",SN" $ (UPPER (oDestino:_EnderDest:_Xlgr:Text)) .Or. ;
	"S/N" $ (UPPER (oDestino:_EnderDest:_Xlgr:Text))

		cEndDest += IIf(Type("oDestino:_EnderDest:_xcpl")=="U","",", " + NoChar(oDestino:_EnderDest:_xcpl:Text,lConverte))
	Else
		cEndDest += +","+NoChar(oDestino:_EnderDest:_NRO:Text,lConverte) + IIf(Type("oDestino:_EnderDest:_xcpl")=="U","",", "+ NoChar(oDestino:_EnderDest:_xcpl:Text,lConverte))
	Endif

	aDest := {cEndDest,;
	NoChar(oDestino:_EnderDest:_XBairro:Text,lConverte),;
	IIF(Type("oDestino:_EnderDest:_Cep")=="U","",Transform(oDestino:_EnderDest:_Cep:Text,"@r 99999-999")),;
	IIF(oNF:_INFNFE:_VERSAO:TEXT >= "3.10",IIF(Type("oIdent:_DHSaiEnt")=="U","",oIdent:_DHSaiEnt:Text),IIF(Type("oIdent:_DSaiEnt")=="U","",oIdent:_DSaiEnt:Text)),;
	oDestino:_EnderDest:_XMun:Text,;
	IIF(Type("oDestino:_EnderDest:_fone")=="U","",oDestino:_EnderDest:_fone:Text),;
	oDestino:_EnderDest:_UF:Text,;
	IIF(Type("oDestino:_IE")=="U","",oDestino:_IE:Text),;
	""}

	If oNF:_INFNFE:_VERSAO:TEXT >= "3.10"
		aadd(aHrEnt,IIF(Type("oIdent:_dhSaiEnt")=="U","",SubStr(oIdent:_dhSaiEnt:TEXT,12,8)))
	Else
		If Type("oIdent:_DSaiEnt")<>"U" .And. Type("oIdent:_HSaiEnt:Text")<>"U"
			aAdd(aHrEnt,oIdent:_HSaiEnt:Text)
		Else
			aAdd(aHrEnt,"")
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calculo do Imposto                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTotais := {"","","","","","","","","","",""}
	aTotais[01] := Transform(Val(oTotal:_ICMSTOT:_vBC:TEXT),"@e 9,999,999,999,999.99")
	aTotais[02] := Transform(Val(oTotal:_ICMSTOT:_vICMS:TEXT),"@e 9,999,999,999,999.99")
	aTotais[03] := Transform(Val(oTotal:_ICMSTOT:_vBCST:TEXT),"@e 9,999,999,999,999.99")
	aTotais[04] := Transform(Val(oTotal:_ICMSTOT:_vST:TEXT),"@e 9,999,999,999,999.99")
	aTotais[05] := Transform(Val(oTotal:_ICMSTOT:_vProd:TEXT),"@e 9,999,999,999,999.99")
	aTotais[06] := Transform(Val(oTotal:_ICMSTOT:_vFrete:TEXT),"@e 9,999,999,999,999.99")
	aTotais[07] := Transform(Val(oTotal:_ICMSTOT:_vSeg:TEXT),"@e 9,999,999,999,999.99")
	aTotais[08] := Transform(Val(oTotal:_ICMSTOT:_vDesc:TEXT),"@e 9,999,999,999,999.99")
	aTotais[09] := Transform(Val(oTotal:_ICMSTOT:_vOutro:TEXT),"@e 9,999,999,999,999.99")

	aTotais[10] := 	Transform(Val(oTotal:_ICMSTOT:_vIPI:TEXT),"@e 9,999,999,999,999.99")

	aTotais[11] := 	Transform(Val(oTotal:_ICMSTOT:_vNF:TEXT),"@e 9,999,999,999,999.99")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quadro Faturas                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nFaturas > 0
		For nX := 1 To 3
			aAux := {}
			For nY := 1 To Min(9, nFaturas)
				Do Case
					Case nX == 1
					If nFaturas > 1
						AAdd(aAux, AllTrim(oFatura:_Dup[nY]:_nDup:TEXT))
					Else
						AAdd(aAux, AllTrim(oFatura:_Dup:_nDup:TEXT))
					EndIf
					Case nX == 2
					If nFaturas > 1
						AAdd(aAux, AllTrim(ConvDate(oFatura:_Dup[nY]:_dVenc:TEXT)))
					Else
						AAdd(aAux, AllTrim(ConvDate(oFatura:_Dup:_dVenc:TEXT)))
					EndIf
					Case nX == 3
					If nFaturas > 1
						AAdd(aAux, AllTrim(TransForm(Val(oFatura:_Dup[nY]:_vDup:TEXT), "@E 9,999,999,999,999.99")))
					Else
						AAdd(aAux, AllTrim(TransForm(Val(oFatura:_Dup:_vDup:TEXT), "@E 9,999,999,999,999.99")))
					EndIf
				EndCase
			Next nY
			If nY <= 9
				For nY := 1 To 9
					AAdd(aAux, Space(20))
				Next nY
			EndIf
			AAdd(aFaturas, aAux)
		Next nX
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quadro transportadora                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTransp := {"","0","","","","","","","","","","","","","",""}

	If Type("oTransp:_ModFrete")<>"U"
		aTransp[02] := IIF(Type("oTransp:_ModFrete:TEXT")<>"U",oTransp:_ModFrete:TEXT,"0")
	EndIf
	If Type("oTransp:_Transporta")<>"U"
		aTransp[01] := IIf(Type("oTransp:_Transporta:_xNome:TEXT")<>"U",NoChar(oTransp:_Transporta:_xNome:TEXT,lConverte),"")
		//	aTransp[02] := IIF(Type("oTransp:_ModFrete:TEXT")<>"U",oTransp:_ModFrete:TEXT,"0")
		aTransp[03] := IIf(Type("oTransp:_VeicTransp:_RNTC")=="U","",oTransp:_VeicTransp:_RNTC:TEXT)
		aTransp[04] := IIf(Type("oTransp:_VeicTransp:_Placa:TEXT")<>"U",oTransp:_VeicTransp:_Placa:TEXT,"")
		aTransp[05] := IIf(Type("oTransp:_VeicTransp:_UF:TEXT")<>"U",oTransp:_VeicTransp:_UF:TEXT,"")
		If Type("oTransp:_Transporta:_CNPJ:TEXT")<>"U"
			aTransp[06] := Transform(oTransp:_Transporta:_CNPJ:TEXT,"@r 99.999.999/9999-99")
		ElseIf Type("oTransp:_Transporta:_CPF:TEXT")<>"U"
			aTransp[06] := Transform(oTransp:_Transporta:_CPF:TEXT,"@r 999.999.999-99")
		EndIf
		aTransp[07] := IIf(Type("oTransp:_Transporta:_xEnder:TEXT")<>"U",NoChar(oTransp:_Transporta:_xEnder:TEXT,lConverte),"")
		aTransp[08] := IIf(Type("oTransp:_Transporta:_xMun:TEXT")<>"U",oTransp:_Transporta:_xMun:TEXT,"")
		aTransp[09] := IIf(Type("oTransp:_Transporta:_UF:TEXT")<>"U",oTransp:_Transporta:_UF:TEXT,"")
		aTransp[10] := IIf(Type("oTransp:_Transporta:_IE:TEXT")<>"U",oTransp:_Transporta:_IE:TEXT,"")
	ElseIf Type("oTransp:_VEICTRANSP")<>"U"
		aTransp[03] := IIf(Type("oTransp:_VeicTransp:_RNTC")=="U","",oTransp:_VeicTransp:_RNTC:TEXT)
		aTransp[04] := IIf(Type("oTransp:_VeicTransp:_Placa:TEXT")<>"U",oTransp:_VeicTransp:_Placa:TEXT,"")
		aTransp[05] := IIf(Type("oTransp:_VeicTransp:_UF:TEXT")<>"U",oTransp:_VeicTransp:_UF:TEXT,"")
	EndIf
	If Type("oTransp:_Vol")<>"U"
		If ValType(oTransp:_Vol) == "A"
			nX := nPrivate
			nLenVol := Len(oTransp:_Vol)
			For nX := 1 to nLenVol
				nXAux := nX
				nVolume += IIF(!Type("oTransp:_Vol[nXAux]:_QVOL:TEXT")=="U",Val(oTransp:_Vol[nXAux]:_QVOL:TEXT),0)
			Next nX
			aTransp[11]	:= AllTrim(str(nVolume))
			aTransp[12]	:= IIf(Type("oTransp:_Vol:_Esp")=="U","Diversos","")
			aTransp[13] := IIf(Type("oTransp:_Vol:_Marca")=="U","",NoChar(oTransp:_Vol:_Marca:TEXT,lConverte))
			aTransp[14] := IIf(Type("oTransp:_Vol:_nVol:TEXT")<>"U",oTransp:_Vol:_nVol:TEXT,"")
			If  Type("oTransp:_Vol[1]:_PesoB") <>"U"
				nPesoB := Val(oTransp:_Vol[1]:_PesoB:TEXT)
				aTransp[15] := AllTrim(str(nPesoB))
			EndIf
			If Type("oTransp:_Vol[1]:_PesoL") <>"U"
				nPesoL := Val(oTransp:_Vol[1]:_PesoL:TEXT)
				aTransp[16] := AllTrim(str(nPesoL))
			EndIf
		Else
			aTransp[11] := IIf(Type("oTransp:_Vol:_qVol:TEXT")<>"U",oTransp:_Vol:_qVol:TEXT,"")
			aTransp[12] := IIf(Type("oTransp:_Vol:_Esp")=="U","",oTransp:_Vol:_Esp:TEXT)
			aTransp[13] := IIf(Type("oTransp:_Vol:_Marca")=="U","",NoChar(oTransp:_Vol:_Marca:TEXT,lConverte))
			aTransp[14] := IIf(Type("oTransp:_Vol:_nVol:TEXT")<>"U",oTransp:_Vol:_nVol:TEXT,"")
			aTransp[15] := IIf(Type("oTransp:_Vol:_PesoB:TEXT")<>"U",oTransp:_Vol:_PesoB:TEXT,"")
			aTransp[16] := IIf(Type("oTransp:_Vol:_PesoL:TEXT")<>"U",oTransp:_Vol:_PesoL:TEXT,"")
		EndIf
		aTransp[15] := strTRan(aTransp[15],".",",")
		aTransp[16] := strTRan(aTransp[16],".",",")
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

	aEspecie := {}

	cEsp := ""
	nx 	 := 0

	cGuarda := ""
	cGuarda := cEsp

	aadd(aEspVol,{cGuarda,"",""})

	If Type("oTransp:_ModFrete") <> "U"
		cModFrete := oTransp:_ModFrete:TEXT
	Else
		cModFrete := "1"
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quadro Dados do Produto / Serviço                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLenDet := Len(oDet)
	If lMv_ItDesc
		For nX := 1 To nLenDet
			Aadd(aIndAux, {nX, SubStr(NoChar(oDet[nX]:_Prod:_xProd:TEXT,lConverte),1,MAXITEMC)})
		Next

		aIndAux := aSort(aIndAux,,, { |x, y| x[2] < y[2] })

		For nX := 1 To nLenDet
			Aadd(aIndImp, aIndAux[nX][1] )
		Next
	EndIf

	For nZ := 1 To nLenDet

		If lMv_ItDesc
			nX := aIndImp[nZ]
		Else
			nX := nZ
		EndIf

		nPrivate := nX

		nVTotal  := Val(oDet[nX]:_Prod:_vProd:TEXT)//-Val(IIF(Type("oDet[nPrivate]:_Prod:_vDesc")=="U","",oDet[nX]:_Prod:_vDesc:TEXT))
		nVUnit   := Val(oDet[nX]:_Prod:_vUnTrib:TEXT)

		nQtd     	:= Val(oDet[nX]:_Prod:_qTrib:TEXT)
		nBaseICM 	:= 0
		nValICM  	:= 0
		nValIPI  	:= 0
		nPICM    	:= 0
		nPIPI    	:= 0
		oImposto 	:= oDet[nX]
		cSitTrib 	:= ""

		lPontilhado	:= .F.

		If Type("oImposto:_Imposto")<>"U"
			If Type("oImposto:_Imposto:_ICMS")<>"U"
				nLenSit := Len(aSitTrib)
				For nY := 1 To nLenSit
					nPrivate2 := nY
					If Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2])<>"U"
						If Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_VBC:TEXT")<>"U"
							nBaseICM := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_VBC:TEXT"))
							nValICM  := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vICMS:TEXT"))
							nPICM    := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_PICMS:TEXT"))
						ElseIf Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_MOTDESICMS") <> "U" .And. Type("oImposto:_PROD:_VDESC:TEXT") <> "U"   //SINIEF 25/12, efeitos a partir de 20.12.12
							If oNF:_INFNFE:_VERSAO:TEXT >= "3.10" .and. &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_CST:TEXT") <> "40"
								If AllTrim(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_motDesICMS:TEXT")) == "7" .And. &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_CST:TEXT") == "30"
									nValICM  := 0
								Else
									nValICM  := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vICMSDESON:TEXT"))
								EndIf
							Elseif &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_CST:TEXT") <> "40"
								If AllTrim(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_motDesICMS:TEXT")) == "7" .And. &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_CST:TEXT") == "30"
									nValICM  := 0
								Else
									nValICM  := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vICMS:TEXT"))
								EndIf
							EndIf
						EndIf
						cSitTrib := &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_ORIG:TEXT")
						cSitTrib += &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_CST:TEXT")
					EndIf
				Next nY

				//Tratamento para o ICMS para optantes pelo Simples Nacional
				If Type("oEmitente:_CRT") <> "U" .And. oEmitente:_CRT:TEXT == "1"
					nLenSit := Len(aSitSN)
					For nY := 1 To nLenSit
						nPrivate2 := nY
						If Type("oImposto:_Imposto:_ICMS:_ICMSSN"+aSitSN[nPrivate2])<>"U"
							If Type("oImposto:_Imposto:_ICMS:_ICMSSN"+aSitSN[nPrivate2]+":_VBC:TEXT")<>"U"
								nBaseICM := Val(&("oImposto:_Imposto:_ICMS:_ICMSSN"+aSitSN[nY]+":_VBC:TEXT"))
								nValICM  := Val(&("oImposto:_Imposto:_ICMS:_ICMSSN"+aSitSN[nY]+":_vICMS:TEXT"))
								nPICM    := Val(&("oImposto:_Imposto:_ICMS:_ICMSSN"+aSitSN[nY]+":_PICMS:TEXT"))
							EndIf
							cSitTrib := &("oImposto:_Imposto:_ICMS:_ICMSSN"+aSitSN[nY]+":_ORIG:TEXT")
							cSitTrib += &("oImposto:_Imposto:_ICMS:_ICMSSN"+aSitSN[nY]+":_CSOSN:TEXT")
						EndIf
					Next nY
				EndIf

			EndIf
			If Type("oImposto:_Imposto:_IPI")<>"U"
				If Type("oImposto:_Imposto:_IPI:_IPITrib:_vIPI:TEXT")<>"U"
					nValIPI := Val(oImposto:_Imposto:_IPI:_IPITrib:_vIPI:TEXT)
				EndIf
				If Type("oImposto:_Imposto:_IPI:_IPITrib:_pIPI:TEXT")<>"U"
					nPIPI   := Val(oImposto:_Imposto:_IPI:_IPITrib:_pIPI:TEXT)
				EndIf
			EndIf
		EndIf

		nMaxCod := MaxCod(oDet[nX]:_Prod:_cProd:TEXT, 50)

		// Tratamento para quebrar os digitos dos valores
		aAux := {}
		AADD(aAux, AllTrim(TransForm(nQtd,TM(nQtd,TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]))))
		AADD(aAux, AllTrim(TransForm(nVUnit,TM(nVUnit,TamSX3("D2_PRCVEN")[1],TamSX3("D2_PRCVEN")[2]))))
		AADD(aAux, AllTrim(TransForm(nVTotal,TM(nVTotal,TamSX3("D2_TOTAL")[1],TamSX3("D2_TOTAL")[2]))))
		AADD(aAux, AllTrim(TransForm(nBaseICM,TM(nBaseICM,TamSX3("D2_BASEICM")[1],TamSX3("D2_BASEICM")[2]))))
		AADD(aAux, AllTrim(TransForm(nValICM,TM(nValICM,TamSX3("D2_VALICM")[1],TamSX3("D2_VALICM")[2]))))
		AADD(aAux, AllTrim(TransForm(nValIPI,TM(nValIPI,TamSX3("D2_VALIPI")[1],TamSX3("D2_BASEIPI")[2]))))

		aadd(aItens,{;
		SubStr(oDet[nX]:_Prod:_cProd:TEXT,1,nMaxCod),;
		SubStr(NoChar(oDet[nX]:_Prod:_xProd:TEXT,lConverte),1,nMaxDes),;
		IIF(Type("oDet[nPrivate]:_Prod:_NCM")=="U","",oDet[nX]:_Prod:_NCM:TEXT),;
		cSitTrib,;
		oDet[nX]:_Prod:_CFOP:TEXT,;
		oDet[nX]:_Prod:_utrib:TEXT,;
		SubStr(aAux[1], 1, PosQuebrVal(aAux[1])),;
		SubStr(aAux[2], 1, PosQuebrVal(aAux[2])),;
		SubStr(aAux[3], 1, PosQuebrVal(aAux[3])),;
		SubStr(aAux[4], 1, PosQuebrVal(aAux[4])),;
		SubStr(aAux[5], 1, PosQuebrVal(aAux[5])),;
		SubStr(aAux[6], 1, PosQuebrVal(aAux[6])),;
		AllTrim(TransForm(nPICM,"@r 99.99%")),;
		AllTrim(TransForm(nPIPI,"@r 99.99%"));
		})

		// Tratamento somente para o estado de MG, para totalizar por CFOP conforme RICMS-MG
		If lUf_MG
			aadd(aItensAux,{;
			SubStr(oDet[nX]:_Prod:_cProd:TEXT,1,nMaxCod),;
			SubStr(NoChar(oDet[nX]:_Prod:_xProd:TEXT,lConverte),1,nMaxDes),;
			IIF(Type("oDet[nPrivate]:_Prod:_NCM")=="U","",oDet[nX]:_Prod:_NCM:TEXT),;
			cSitTrib,;
			oDet[nX]:_Prod:_CFOP:TEXT,;
			oDet[nX]:_Prod:_utrib:TEXT,;
			SubStr(aAux[1], 1, PosQuebrVal(aAux[1])),;
			SubStr(aAux[2], 1, PosQuebrVal(aAux[2])),;
			SubStr(aAux[3], 1, PosQuebrVal(aAux[3])),;
			SubStr(aAux[4], 1, PosQuebrVal(aAux[4])),;
			SubStr(aAux[5], 1, PosQuebrVal(aAux[5])),;
			SubStr(aAux[6], 1, PosQuebrVal(aAux[6])),;
			AllTrim(TransForm(nPICM,"@r 99.99%")),;
			AllTrim(TransForm(nPIPI,"@r 99.99%")),;
			StrZero( ++nSequencia, 4 ),;
			nVTotal;
			})
		Endif

		// Tramento quando houver diferença entre as unidades uCom e uTrib ( SEFAZ MT )
		If "MT" $ Alltrim( Upper( SuperGetMv("MV_ESTADO") ) ) .And. ( oDet[nX]:_Prod:_uTrib:TEXT <> oDet[nX]:_Prod:_uCom:TEXT )

			lPontilhado := IIf( nLenDet > 1, .T., lPontilhado )

			cUnCom		:= oDet[nX]:_Prod:_uCom:TEXT
			nQtdCom		:= Val(oDet[nX]:_Prod:_qCom:TEXT)
			nVUnitCom	:= Val(oDet[nX]:_Prod:_vUnCom:TEXT)

			aAuxCom := {}
			AADD(aAuxCom, AllTrim(TransForm(nQtdCom,TM(nQtdCom,TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]))))
			AADD(aAuxCom, AllTrim(TransForm(nVUnitCom,TM(nVUnitCom,TamSX3("D2_PRCVEN")[1],TamSX3("D2_PRCVEN")[2]))))

			aadd(aItens,{;
			"",;
			"",;
			"",;
			"",;
			"",;
			cUnCom,;
			SubStr(aAuxCom[1], 1, PosQuebrVal(aAuxCom[1])),;
			SubStr(aAuxCom[2], 1, PosQuebrVal(aAuxCom[2])),;
			"",;
			"",;
			"",;
			"",;
			"",;
			"";
			})

		Endif

		cAuxItem := AllTrim(SubStr(oDet[nX]:_Prod:_cProd:TEXT,nMaxCod+1))
		cAux     := AllTrim(SubStr(NoChar(oDet[nX]:_Prod:_xProd:TEXT,lConverte),(nMaxDes+1)))
		aAux[1]  := SubStr(aAux[1], PosQuebrVal(aAux[1]) + 1)
		aAux[2]  := SubStr(aAux[2], PosQuebrVal(aAux[2]) + 1)
		aAux[3]  := SubStr(aAux[3], PosQuebrVal(aAux[3]) + 1)
		aAux[4]  := SubStr(aAux[4], PosQuebrVal(aAux[4]) + 1)
		aAux[5]  := SubStr(aAux[5], PosQuebrVal(aAux[5]) + 1)
		aAux[6]  := SubStr(aAux[6], PosQuebrVal(aAux[6]) + 1)

		While !Empty(cAux) .Or. !Empty(cAuxItem) .Or. !Empty(aAux[1]) .Or. !Empty(aAux[2]) .Or. !Empty(aAux[3]) .Or. !Empty(aAux[4]) .Or. !Empty(aAux[5]) .Or. !Empty(aAux[6])
			nMaxCod := MaxCod(cAuxItem, 50)

			aadd(aItens,{;
			SubStr(cAuxItem,1,nMaxCod),;
			SubStr(cAux,1,nMaxDes),;
			"",;
			"",;
			"",;
			"",;
			SubStr(aAux[1], 1, PosQuebrVal(aAux[1])),;
			SubStr(aAux[2], 1, PosQuebrVal(aAux[2])),;
			SubStr(aAux[3], 1, PosQuebrVal(aAux[3])),;
			SubStr(aAux[4], 1, PosQuebrVal(aAux[4])),;
			SubStr(aAux[5], 1, PosQuebrVal(aAux[5])),;
			SubStr(aAux[6], 1, PosQuebrVal(aAux[6])),;
			"",;
			"";
			})

			If lUf_MG
				aadd(aItensAux,{;
				SubStr(cAuxItem,1,nMaxCod),;
				SubStr(cAux,1,nMaxDes),;
				"",;
				"",;
				oDet[nX]:_Prod:_CFOP:TEXT,;
				"",;
				SubStr(aAux[1], 1, PosQuebrVal(aAux[1])),;
				SubStr(aAux[2], 1, PosQuebrVal(aAux[2])),;
				SubStr(aAux[3], 1, PosQuebrVal(aAux[3])),;
				SubStr(aAux[4], 1, PosQuebrVal(aAux[4])),;
				SubStr(aAux[5], 1, PosQuebrVal(aAux[5])),;
				SubStr(aAux[6], 1, PosQuebrVal(aAux[6])),;
				"",;
				"",;
				StrZero( ++nSequencia, 4 ),;
				0;
				})
			Endif

			// Popula as informações para as próximas linhas adicionais
			cAux        := SubStr(cAux,(nMaxDes+1))
			cAuxItem    := SubStr(cAuxItem,nMaxCod+1)
			aAux[1]     := SubStr(aAux[1], PosQuebrVal(aAux[1]) + 1)
			aAux[2]     := SubStr(aAux[2], PosQuebrVal(aAux[2]) + 1)
			aAux[3]     := SubStr(aAux[3], PosQuebrVal(aAux[3]) + 1)
			aAux[4]     := SubStr(aAux[4], PosQuebrVal(aAux[4]) + 1)
			aAux[5]     := SubStr(aAux[5], PosQuebrVal(aAux[5]) + 1)
			aAux[6]     := SubStr(aAux[6], PosQuebrVal(aAux[6]) + 1)
			lPontilhado := .T.
		EndDo

		If (Type("oNf:_infnfe:_det[nPrivate]:_Infadprod:TEXT") <> "U" .Or. Type("oNf:_infnfe:_det:_Infadprod:TEXT") <> "U") .And. ( lImpAnfav .Or. lImpInfAd )
			If at("<", AllTrim(SubStr(oDet[nX]:_Infadprod:TEXT,1))) <> 0
				cAux := stripTags(AllTrim(SubStr(oDet[nX]:_Infadprod:TEXT,1)), .T.) + " "
				cAux += stripTags(AllTrim(SubStr(oDet[nX]:_Infadprod:TEXT,1)), .F.)
			else
				cAux := stripTags(AllTrim(SubStr(oDet[nX]:_Infadprod:TEXT,1)), .T.)
			endIf

			While !Empty(cAux)
				aadd(aItens,{;
				"",;
				SubStr(cAux,1,nMaxDes),;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"";
				})

				If lUf_MG
					aadd(aItensAux,{;
					"",;
					SubStr(cAux,1,nMaxDes),;
					"",;
					"",;
					oDet[nX]:_Prod:_CFOP:TEXT,;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					StrZero( ++nSequencia, 4 ),;
					0;
					})
				Endif

				cAux := SubStr(cAux,(nMaxDes + 1))
				lPontilhado := .T.
			EndDo
		EndIf

		If lPontilhado
			aadd(aItens,{;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-",;
			"-";
			})

			If lUf_MG
				aadd(aItensAux,{;
				"-",;
				"-",;
				"-",;
				"-",;
				oDet[nX]:_Prod:_CFOP:TEXT,;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				StrZero( ++nSequencia, 4 ),;
				0;
				})
			Endif

		EndIf

	Next nZ

	//----------------------------------------------------------------------------------
	// Tratamento somente para o estado de MG, para totalizar por CFOP conforme RICMS-MG
	//----------------------------------------------------------------------------------
	If lUf_MG

		If 	Len( aItensAux ) > 0

			aItensAux	:= aSort( aItensAux,,, { |x,y| x[5]+x[15] < y[5]+y[15] } )

			nSubTotal	:= 0

			aItens		:= {}

			cCfop		:= aItensAux[1,5]
			cCfopAnt	:= aItensAux[1,5]

			For nX := 1 To Len( aItensAux )

				aArray		:= ARRAY(14)

				aArray[01]	:= aItensAux[nX,01]
				aArray[02]	:= aItensAux[nX,02]
				aArray[03]	:= aItensAux[nX,03]
				aArray[04]	:= aItensAux[nX,04]

				If Empty( aItensAux[nX,03] ) .Or. aItensAux[nX,03] == "-"
					aArray[05] := ""
				Else
					aArray[05] := aItensAux[nX,05]
				Endif

				aArray[06]	:= aItensAux[nX,06]
				aArray[07]	:= aItensAux[nX,07]
				aArray[08]	:= aItensAux[nX,08]
				aArray[09]	:= aItensAux[nX,09]
				aArray[10]	:= aItensAux[nX,10]
				aArray[11]	:= aItensAux[nX,11]
				aArray[12]	:= aItensAux[nX,12]
				aArray[13]	:= aItensAux[nX,13]
				aArray[14]	:= aItensAux[nX,14]

				If aItensAux[nX,5] == cCfop

					aadd( aItens, {;
					aArray[01],;
					aArray[02],;
					aArray[03],;
					aArray[04],;
					aArray[05],;
					aArray[06],;
					aArray[07],;
					aArray[08],;
					aArray[09],;
					aArray[10],;
					aArray[11],;
					aArray[12],;
					aArray[13],;
					aArray[14];
					} )

					nSubTotal += aItensAux[nX,16]

				Else

					aadd(aItens,{;
					"-",;
					"-",;
					"-",;
					"-",;
					"-",;
					"-",;
					"-",;
					"-",;
					"-",;
					"-",;
					"-",;
					"-",;
					"-",;
					"-";
					})

					aadd(aItens,{;
					"",;
					"SUB-TOTAL",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					AllTrim(TransForm(nSubTotal,TM(nSubTotal,TamSX3("D2_TOTAL")[1],TamSX3("D2_TOTAL")[2]))),;
					"",;
					"",;
					"",;
					"",;
					"";
					})

					aadd(aItens,{;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"";
					})

					cCfop 		:= aItensAux[nX,05]
					nSubTotal 	:= aItensAux[nX,16]

					aadd( aItens, {;
					aArray[01],;
					aArray[02],;
					aArray[03],;
					aArray[04],;
					aArray[05],;
					aArray[06],;
					aArray[07],;
					aArray[08],;
					aArray[09],;
					aArray[10],;
					aArray[11],;
					aArray[12],;
					aArray[13],;
					aArray[14];
					} )

				Endif

			Next nX

			If cCfopAnt <> cCfop .And. nSubTotal > 0

				aadd(aItens,{;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-",;
				"-";
				})

				aadd(aItens,{;
				"",;
				"SUB-TOTAL",;
				"",;
				"",;
				"",;
				"",;
				"",;
				"",;
				AllTrim(TransForm(nSubTotal,TM(nSubTotal,TamSX3("D2_TOTAL")[1],TamSX3("D2_TOTAL")[2]))),;
				"",;
				"",;
				"",;
				"",;
				"";
				})

			Endif

		Endif

	Endif


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quadro ISSQN                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aISSQN := {"","","",""}
	If Type("oEmitente:_IM:TEXT")<>"U"
		aISSQN[1] := oEmitente:_IM:TEXT
	EndIf
	If Type("oTotal:_ISSQNtot")<>"U"
		If Type("oTotal:_ISSQNtot:_vServ:TEXT") <> "U"
			aISSQN[2] := Transform(Val(oTotal:_ISSQNtot:_vServ:TEXT),"@e 999,999,999.99")
		Endif
		If Type("oTotal:_ISSQNtot:_vBC:TEXT") <> "U"
			aISSQN[3] := Transform(Val(oTotal:_ISSQNtot:_vBC:TEXT),"@e 999,999,999.99")
		Endif
		If Type("oTotal:_ISSQNtot:_vISS:TEXT") <> "U"
			aISSQN[4] := Transform(Val(oTotal:_ISSQNtot:_vISS:TEXT),"@e 999,999,999.99")
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quadro de informacoes complementares                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Type("oIdent:_DHCONT:TEXT")<>"U"
		cDhCont:= oIdent:_DHCONT:TEXT
	EndIf
	If Type("oIdent:_XJUST:TEXT")<>"U"
		cXJust:=oIdent:_XJUST:TEXT
	EndIf

	aMensagem := {}
	If Type("oIdent:_tpAmb:TEXT")<>"U" .And. oIdent:_tpAmb:TEXT=="2"
		cAux := "DANFE emitida no ambiente de homologação - SEM VALOR FISCAL"
		While !Empty(cAux)
			aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
			cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
		EndDo
	EndIf

	If Type("oNF:_InfNfe:_infAdic:_infAdFisco:TEXT")<>"U"
		cAux := oNF:_InfNfe:_infAdic:_infAdFisco:TEXT
		While !Empty(cAux)
			aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
			cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
		EndDo
	EndIf

	If Type("oNF:_InfNfe:_infAdic:_infCpl:TEXT")<>"U"
		If at("<", oNF:_InfNfe:_infAdic:_InfCpl:TEXT) <> 0
			cAux := stripTags(oNF:_InfNfe:_infAdic:_InfCpl:TEXT, .T.) + " "
			cAux += stripTags(oNF:_InfNfe:_infAdic:_InfCpl:TEXT, .F.)
		else
			cAux := stripTags(oNF:_InfNfe:_infAdic:_InfCpl:TEXT, .T.)
		endIf
		While !Empty(cAux)
			aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
			cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
		EndDo
	EndIf

	For Nx := 1 to Len(aMensagem)
		NoChar(aMensagem[Nx],lConverte)
	Next

	If Type("oNF:_INFNFE:_IDE:_NFREF")<>"U"
		If Type("oNF:_INFNFE:_IDE:_NFREF") == "A"
			aInfNf := oNF:_INFNFE:_IDE:_NFREF
		Else
			aInfNf := {oNF:_INFNFE:_IDE:_NFREF}
		EndIf

		cAux1 := ""
		cAux2 := ""

		cAux	:=	""
		If !Empty(cAux1)
			cAux1	:=	Left(cAux1,Len(cAux1)-1)
			cAux 	+= cAux1
		EndIf
		If !Empty(cAux2)
			cAux2	:=	Left(cAux2,Len(cAux2)-1)
			cAux 	+= 	Iif(!Empty(cAux),CRLF,"")+cAux2
		EndIf

		While !Empty(cAux)
			aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
			cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
		EndDo

		For Nx := 1 to Len(aMensagem)
			NoChar(aMensagem[Nx],lConverte)
		Next

	EndIf

	//³Quadro "RESERVADO AO FISCO"                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aResFisco := {}
	nBaseIcm  := 0

	If GetNewPar("MV_BCREFIS",.F.) .And. SuperGetMv("MV_ESTADO")$"PR"
		If Val(&("oTotal:_ICMSTOT:_VBCST:TEXT")) <> 0
			cAux := "Substituição Tributária: Art. 471, II e §1º do RICMS/PR: "
			nLenDet := Len(oDet)
			For nX := 1 To nLenDet
				oImposto := oDet[nX]
				If Type("oImposto:_Imposto")<>"U"
					If Type("oImposto:_Imposto:_ICMS")<>"U"
						nLenSit := Len(aSitTrib)
						For nY := 1 To nLenSit
							nPrivate2 := nY
							If Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2])<>"U"
								If Type("oImposto:_IMPOSTO:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_VBCST:TEXT")<>"U"
									nBaseIcm := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_VBCST:TEXT"))
									cAux += oDet[nX]:_PROD:_CPROD:TEXT + ": BCICMS-ST R$" + AllTrim(TransForm(nBaseICM,TM(nBaseICM,TamSX3("D2_BASEICM")[1],TamSX3("D2_BASEICM")[2]))) + " / "
								Endif
							Endif
						Next nY
					Endif
				Endif
			Next nX
		Endif
		While !Empty(cAux)
			aadd(aResFisco,SubStr(cAux,1,60))
			cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, 59, MAXMENLIN) +2)
		EndDo
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calculo do numero de folhas                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nFolhas	  := 1
	nLenItens := Len(aItens) - MAXITEM // Todos os produtos/serviços excluindo a primeira página
	nMsgCompl := Len(aMensagem) - MAXMSG // Todas as mensagens complementares excluindo a primeira página
	lFlag     := .T.
	While lFlag
		// Caso existam produtos/serviços e mensagens complementares a serem escritas
		If nLenItens > 0 .And. nMsgCompl > 0
			nFolhas++
			// Se estiver habilitado frente e verso e for uma página impar
			nLenItens -= MAXITEMP2
			nMsgCompl -= MAXMSG
			// Caso existam apenas mensagens complementares a serem escritas
		ElseIf nLenItens <= 0 .And. nMsgCompl > 0
			nFolhas++
			nMsgCompl := 0
			// Caso existam apenas produtos/serviços a serem escritos
		ElseIf nLenItens > 0 .And. nMsgCompl <= 0
			nFolhas++
			// Se estiver habilitado frente e verso e for uma página impar
			nLenItens -= MAXITEMP2F
			// Se não tiver mais nada a ser escrito fecha a contagem
		Else
			lFlag := .F.
		EndIf
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicializacao do objeto grafico                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _oDanfe == Nil
		lPreview := .T.
		_oDanfe 	:= FWMSPrinter():New("DANFE", IMP_SPOOL)
		_oDanfe:SetPortrait()
		_oDanfe:Setup()
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicializacao da pagina do objeto grafico                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_oDanfe:StartPage()
	nHPage := _oDanfe:nHorzRes()
	nHPage *= (300/PixelX)
	nHPage -= HMARGEM
	nVPage := _oDanfe:nVertRes()
	nVPage *= (300/PixelY)
	nVPage -= VBOX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Definicao do Box - Recibo de entrega                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	_oDanfe:Box(000,000,010,501)
	_oDanfe:Say(006, 002, "RECEBEMOS DE "+NoChar(oEmitente:_xNome:Text,lConverte)+" OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO", oFont07:oFont)
	_oDanfe:Box(009,000,037,101)
	_oDanfe:Say(017, 002, "DATA DE RECEBIMENTO", oFont07N:oFont)
	_oDanfe:Box(009,100,037,500)
	_oDanfe:Say(017, 102, "IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR", oFont07N:oFont)
	_oDanfe:Box(000,500,037,603)
	_oDanfe:Say(007, 542, "NF-e", oFont08N:oFont)
	_oDanfe:Say(017, 510, "N. "+StrZero(Val(oIdent:_NNf:Text),9), oFont08:oFont)
	_oDanfe:Say(027, 510, "SÉRIE "+oIdent:_Serie:Text, oFont08:oFont)


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quadro 1 IDENTIFICACAO DO EMITENTE                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_oDanfe:Box(042,000,137,250)
	_oDanfe:Say(052,002, "Identificação do emitente",oFont12N:oFont)
	nLinCalc	:=	065
	cStrAux		:=	AllTrim(NoChar(oEmitente:_xNome:Text,lConverte))
	nForTo		:=	Len(cStrAux)/45
	nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
	For nX := 1 To nForTo
		_oDanfe:Say(nLinCalc,002,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*45)+1),45), oFont12N:oFont )
		nLinCalc+=10
	Next nX

	cStrAux		:=	AllTrim(NoChar(oEmitente:_EnderEmit:_xLgr:Text,lConverte))+", "+AllTrim(oEmitente:_EnderEmit:_Nro:Text)
	nForTo		:=	Len(cStrAux)/60
	nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
	For nX := 1 To nForTo
		_oDanfe:Say(nLinCalc,002,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*60)+1),60),oFont08N:oFont)
		nLinCalc+=10
	Next nX

	If Type("oEmitente:_EnderEmit:_xCpl") <> "U"
		cStrAux		:=	"Complemento: "+AllTrim(NoChar(oEmitente:_EnderEmit:_xCpl:TEXT,lConverte))
		nForTo		:=	Len(cStrAux)/60
		nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
		For nX := 1 To nForTo
			_oDanfe:Say(nLinCalc,002,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*60)+1),60),oFont08N:oFont)
			nLinCalc+=10
		Next nX

		cStrAux		:=	AllTrim(oEmitente:_EnderEmit:_xBairro:Text)
		If Type("oEmitente:_EnderEmit:_Cep")<>"U"
			cStrAux		+=	" Cep:"+TransForm(oEmitente:_EnderEmit:_Cep:Text,"@r 99999-999")
		EndIf
		nForTo		:=	Len(cStrAux)/60
		nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
		For nX := 1 To nForTo
			_oDanfe:Say(nLinCalc,002,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*60)+1),60),oFont08N:oFont)
			nLinCalc+=10
		Next nX
		_oDanfe:Say(nLinCalc,002, oEmitente:_EnderEmit:_xMun:Text+"/"+oEmitente:_EnderEmit:_UF:Text,oFont08N:oFont)
		nLinCalc+=10
		_oDanfe:Say(nLinCalc,002, "Fone: "+IIf(Type("oEmitente:_EnderEmit:_Fone")=="U","",oEmitente:_EnderEmit:_Fone:Text),oFont08N:oFont)
	Else
		_oDanfe:Say(nLinCalc,002, NoChar(oEmitente:_EnderEmit:_xBairro:Text,lConverte)+" Cep:"+TransForm(IIF(Type("oEmitente:_EnderEmit:_Cep")=="U","",oEmitente:_EnderEmit:_Cep:Text),"@r 99999-999"),oFont08N:oFont)
		nLinCalc+=10
		_oDanfe:Say(nLinCalc,002, oEmitente:_EnderEmit:_xMun:Text+"/"+oEmitente:_EnderEmit:_UF:Text,oFont08N:oFont)
		nLinCalc+=10
		_oDanfe:Say(nLinCalc,002, "Fone: "+IIf(Type("oEmitente:_EnderEmit:_Fone")=="U","",oEmitente:_EnderEmit:_Fone:Text),oFont08N:oFont)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quadro 2                                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	_oDanfe:Box(042,248,137,351)
	_oDanfe:Say(055,275, "DANFE",oFont18N:oFont)
	_oDanfe:Say(065,258, "DOCUMENTO AUXILIAR DA",oFont07:oFont)
	_oDanfe:Say(075,258, "NOTA FISCAL ELETRÔNICA",oFont07:oFont)
	_oDanfe:Say(085,266, "0-ENTRADA",oFont08:oFont)
	_oDanfe:Say(095,266, "1-SAÍDA"  ,oFont08:oFont)
	_oDanfe:Box(078,315,095,325)
	_oDanfe:Say(089,318, oIdent:_TpNf:Text,oFont08N:oFont)
	_oDanfe:Say(110,255,"N. "+StrZero(Val(oIdent:_NNf:Text),9),oFont10N:oFont)
	_oDanfe:Say(120,255,"SÉRIE "+oIdent:_Serie:Text,oFont10N:oFont)
	_oDanfe:Say(130,255,"FOLHA "+StrZero(nFolha,2)+"/"+StrZero(nFolhas,2),oFont10N:oFont)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Preenchimento do Array de UF                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aUF,{"RO","11"})
	aadd(aUF,{"AC","12"})
	aadd(aUF,{"AM","13"})
	aadd(aUF,{"RR","14"})
	aadd(aUF,{"PA","15"})
	aadd(aUF,{"AP","16"})
	aadd(aUF,{"TO","17"})
	aadd(aUF,{"MA","21"})
	aadd(aUF,{"PI","22"})
	aadd(aUF,{"CE","23"})
	aadd(aUF,{"RN","24"})
	aadd(aUF,{"PB","25"})
	aadd(aUF,{"PE","26"})
	aadd(aUF,{"AL","27"})
	aadd(aUF,{"MG","31"})
	aadd(aUF,{"ES","32"})
	aadd(aUF,{"RJ","33"})
	aadd(aUF,{"SP","35"})
	aadd(aUF,{"PR","41"})
	aadd(aUF,{"SC","42"})
	aadd(aUF,{"RS","43"})
	aadd(aUF,{"MS","50"})
	aadd(aUF,{"MT","51"})
	aadd(aUF,{"GO","52"})
	aadd(aUF,{"DF","53"})
	aadd(aUF,{"SE","28"})
	aadd(aUF,{"BA","29"})
	aadd(aUF,{"EX","99"})

	nHPage := _oDanfe:nHorzRes()
	nHPage *= (300/PixelX)
	nHPage -= HMARGEM
	nVPage := _oDanfe:nVertRes()
	nVPage *= (300/PixelY)
	nVPage -= VBOX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Codigo de barra                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	_oDanfe:Box(042,350,088,603)
	_oDanfe:Box(075,350,110,603)
	_oDanfe:Say(095,355,TransForm(SubStr(oNF:_InfNfe:_ID:Text,4),"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"),oFont12N:oFont)
	_oDanfe:Box(105,350,137,603)

	If nFolha == 1
		_oDanfe:Say(085,355,"CHAVE DE ACESSO DA NF-E",oFont12N:oFont)
		nFontSize := 28
		_oDanfe:Code128C(072,370,SubStr(oNF:_InfNfe:_ID:Text,4), nFontSize )
	EndIf

	If (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"4"
		cDataEmi := Iif(oNF:_INFNFE:_VERSAO:TEXT >= "3.10",Substr(oNFe:_NFE:_INFNFE:_IDE:_DHEMI:Text,9,2),Substr(oNFe:_NFE:_INFNFE:_IDE:_DEMI:Text,9,2))
		cTPEmis  := "4"

		If Type("oDPEC:_ENVDPEC:_INFDPEC:_RESNFE") <> "U"
			cUF      := aUF[aScan(aUF,{|x| x[1] == oDPEC:_ENVDPEC:_INFDPEC:_RESNFE:_UF:Text})][02]
			cValIcm := StrZero(Val(StrTran(oDPEC:_ENVDPEC:_INFDPEC:_RESNFE:_VNF:TEXT,".","")),14)
			cICMSp := iif(Val(oDPEC:_ENVDPEC:_INFDPEC:_RESNFE:_VICMS:TEXT)>0,"1","2")
			cICMSs := iif(Val(oDPEC:_ENVDPEC:_INFDPEC:_RESNFE:_VST:TEXT)>0,"1","2")
		ElseIf type ("oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST") <> "U" //EPEC NFE
			If Type ("oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_UF:TEXT") <> "U"
				cUF := aUF[aScan(aUF,{|x| x[1] == oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_UF:TEXT})][02]
			EndIf
			If Type ("oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_VNF:TEXT") <> "U"
				cValIcm := StrZero(Val(StrTran(oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_VNF:TEXT,".","")),14)
			EndIf
			If 	Type ("oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_VICMS:TEXT") <> "U"
				cICMSp:= IIf(Val(oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_VICMS:TEXT) > 0,"1","2")
			EndIf
			If 	Type ("oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_VST:TEXT") <> "U"
				cICMSs := IIf(Val(oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_VST:TEXT )> 0,"1","2")
			EndIf
		EndIf

	ElseIF (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"25" .Or. ( (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"4"  )
		cUF      := aUF[aScan(aUF,{|x| x[1] == oNFe:_NFE:_INFNFE:_DEST:_ENDERDEST:_UF:Text})][02]
		cDataEmi := Iif(oNF:_INFNFE:_VERSAO:TEXT >= "3.10",Substr(oNFe:_NFE:_INFNFE:_IDE:_DHEMI:Text,9,2),Substr(oNFe:_NFE:_INFNFE:_IDE:_DEMI:Text,9,2))
		cTPEmis  := oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT
		cValIcm  := StrZero(Val(StrTran(oNFe:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT,".","")),14)
		cICMSp   := iif(Val(oNFe:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VICMS:TEXT)>0,"1","2")
		cICMSs   :=iif(Val(oNFe:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VST:TEXT)>0,"1","2")
	EndIf
	If !Empty(cUF) .And. !Empty(cDataEmi) .And. !Empty(cTPEmis) .And. !Empty(cValIcm) .And. !Empty(cICMSp) .And. !Empty(cICMSs)
		If Type("oNF:_InfNfe:_DEST:_CNPJ:Text")<>"U"
			cCNPJCPF := oNF:_InfNfe:_DEST:_CNPJ:Text
			If cUf == "99"
				cCNPJCPF := STRZERO(val(cCNPJCPF),14)
			EndIf
		ElseIf Type("oNF:_INFNFE:_DEST:_CPF:Text")<>"U"
			cCNPJCPF := oNF:_INFNFE:_DEST:_CPF:Text
			cCNPJCPF := STRZERO(val(cCNPJCPF),14)
		Else
			cCNPJCPF := ""
		EndIf
		cChaveCont += cUF+cTPEmis+cCNPJCPF+cValIcm+cICMSp+cICMSs+cDataEmi
		cChaveCont := cChaveCont+Modulo11(cChaveCont)
	EndIf

	// inicio do segundo codigo de barras ref. a transmissao CONTIGENCIA OFF LINE
	If !Empty(cChaveCont) .And. !(Val(oNF:_INFNFE:_IDE:_SERIE:TEXT) >= 900)
		If nFolha == 1
			If !Empty(cChaveCont)
				nFontSize := 28
				_oDanfe:Code128C(135,370,cChaveCont, nFontSize )
			EndIf
		Else
			If !Empty(cChaveCont)
				nFontSize := 28
				_oDanfe:Code128C(112,370,cChaveCont, nFontSize )
			EndIf
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quadro 4                                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	_oDanfe:Box(139,000,162,603)
	_oDanfe:Box(139,000,162,350)
	_oDanfe:Say(148,002,"NATUREZA DA OPERAÇÃO",oFont08N:oFont)
	_oDanfe:Say(158,002,oIdent:_NATOP:TEXT,oFont08:oFont)



	If (((Val(oNF:_INFNFE:_IDE:_SERIE:TEXT) >= 900).And.(oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"23") .Or. (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"1|6|7")
		_oDanfe:Say(148,352,"PROTOCOLO DE AUTORIZAÇÃO DE USO",oFont08N:oFont)
	Endif
	If((oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"25")
		_oDanfe:Say(148,352,"DADOS DA NF-E",oFont08N:oFont)
	Endif
	_oDanfe:Say(158,354,TransForm(cChaveCont,"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999"),oFont08:oFont)

	nFolha++


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quadro 5                                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_oDanfe:Box(164,000,187,603)
	_oDanfe:Box(164,000,187,200)
	_oDanfe:Box(164,200,187,400)
	_oDanfe:Box(164,400,187,603)
	_oDanfe:Say(172,002,"INSCRIÇÃO ESTADUAL",oFont08N:oFont)
	_oDanfe:Say(180,002,IIf(Type("oEmitente:_IE:TEXT")<>"U",oEmitente:_IE:TEXT,""),oFont08:oFont)
	_oDanfe:Say(172,205,"INSC.ESTADUAL DO SUBST.TRIB.",oFont08N:oFont)
	_oDanfe:Say(180,205,IIf(Type("oEmitente:_IEST:TEXT")<>"U",oEmitente:_IEST:TEXT,""),oFont08:oFont)
	_oDanfe:Say(172,405,"CNPJ",oFont08N:oFont)
	_oDanfe:Say(180,405,TransForm(oEmitente:_CNPJ:TEXT,IIf(Len(oEmitente:_CNPJ:TEXT)<>14,"@r 999.999.999-99","@r 99.999.999/9999-99")),oFont08:oFont)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quadro destinatário/remetente                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do Case
		Case Type("oDestino:_CNPJ")=="O"
		cAux := TransForm(oDestino:_CNPJ:TEXT,"@r 99.999.999/9999-99")
		Case Type("oDestino:_CPF")=="O"
		cAux := TransForm(oDestino:_CPF:TEXT,"@r 999.999.999-99")
		OtherWise
		cAux := Space(14)
	EndCase


	_oDanfe:Say(195,002,"DESTINATARIO/REMETENTE",oFont08N:oFont)
	_oDanfe:Box(197,000,217,450)
	_oDanfe:Say(205,002, "NOME/RAZÃO SOCIAL",oFont08N:oFont)
	_oDanfe:Say(215,002,NoChar(oDestino:_XNome:TEXT,lConverte),oFont08:oFont)
	_oDanfe:Box(197,280,217,500)
	_oDanfe:Say(205,283,"CNPJ/CPF",oFont08N:oFont)
	_oDanfe:Say(215,283,cAux,oFont08:oFont)

	_oDanfe:Box(217,000,237,500)
	_oDanfe:Box(217,000,237,260)
	_oDanfe:Say(224,002,"ENDEREÇO",oFont08N:oFont)
	_oDanfe:Say(234,002,aDest[01],oFont08:oFont)
	_oDanfe:Box(217,230,237,380)
	_oDanfe:Say(224,232,"BAIRRO/DISTRITO",oFont08N:oFont)
	_oDanfe:Say(234,232,aDest[02],oFont08:oFont)
	_oDanfe:Box(217,380,237,500)
	_oDanfe:Say(224,382,"CEP",oFont08N:oFont)
	_oDanfe:Say(234,382,aDest[03],oFont08:oFont)

	_oDanfe:Box(236,000,257,500)
	_oDanfe:Box(236,000,257,180)
	_oDanfe:Say(245,002,"MUNICIPIO",oFont08N:oFont)
	_oDanfe:Say(255,002,aDest[05],oFont08:oFont)
	_oDanfe:Box(236,150,257,256)
	_oDanfe:Say(245,152,"FONE/FAX",oFont08N:oFont)
	_oDanfe:Say(255,152,aDest[06],oFont08:oFont)
	_oDanfe:Box(236,255,257,341)
	_oDanfe:Say(245,257,"UF",oFont08N:oFont)
	_oDanfe:Say(255,257,aDest[07],oFont08:oFont)
	_oDanfe:Box(236,340,257,500)
	_oDanfe:Say(245,342,"INSCRIÇÃO ESTADUAL",oFont08N:oFont)
	_oDanfe:Say(255,342,aDest[08],oFont08:oFont)


	_oDanfe:Box(197,502,217,603)
	_oDanfe:Say(205,504,"DATA DE EMISSÃO",oFont08N:oFont)
	_oDanfe:Say(215,504,Iif(oNF:_INFNFE:_VERSAO:TEXT >= "3.10",ConvDate(oIdent:_DHEmi:TEXT),ConvDate(oIdent:_DEmi:TEXT)),oFont08:oFont)
	_oDanfe:Box(217,502,237,603)
	_oDanfe:Say(224,504,"DATA ENTRADA/SAÍDA",oFont08N:oFont)
	_oDanfe:Say(233,504,Iif( Empty(aDest[4]),"",ConvDate(aDest[4]) ),oFont08:oFont)
	_oDanfe:Box(236,502,257,603)
	_oDanfe:Say(243,503,"HORA ENTRADA/SAÍDA",oFont08N:oFont)
	_oDanfe:Say(252,503,aHrEnt[01],oFont08:oFont)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quadro fatura                                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAux := {{{},{},{},{},{},{},{},{},{}}}
	nY := 0
	For nX := 1 To Len(aFaturas)
		nY++
		aadd(Atail(aAux)[nY],aFaturas[nX][1])
		nY++
		aadd(Atail(aAux)[nY],aFaturas[nX][2])
		nY++
		aadd(Atail(aAux)[nY],aFaturas[nX][3])
		nY++
		aadd(Atail(aAux)[nY],aFaturas[nX][4])
		nY++
		aadd(Atail(aAux)[nY],aFaturas[nX][5])
		nY++
		aadd(Atail(aAux)[nY],aFaturas[nX][6])
		nY++
		aadd(Atail(aAux)[nY],aFaturas[nX][7])
		nY++
		aadd(Atail(aAux)[nY],aFaturas[nX][8])
		nY++
		aadd(Atail(aAux)[nY],aFaturas[nX][9])
		If nY >= 9
			nY := 0
		EndIf
	Next nX

	_oDanfe:Say(263,002,"FATURA",oFont08N:oFont)
	_oDanfe:Box(265,000,296,068)
	_oDanfe:Box(265,067,296,134)
	_oDanfe:Box(265,134,296,202)
	_oDanfe:Box(265,201,296,268)
	_oDanfe:Box(265,268,296,335)
	_oDanfe:Box(265,335,296,403)
	_oDanfe:Box(265,402,296,469)
	_oDanfe:Box(265,469,296,537)
	_oDanfe:Box(265,536,296,603)

	nColuna := 002
	If Len(aFaturas) >0
		For nY := 1 To 9
			_oDanfe:Say(273,nColuna,aAux[1][nY][1],oFont08:oFont)
			_oDanfe:Say(281,nColuna,aAux[1][nY][2],oFont08:oFont)
			_oDanfe:Say(289,nColuna,aAux[1][nY][3],oFont08:oFont)
			nColuna:= nColuna+67
		Next nY
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calculo do imposto                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_oDanfe:Say(305,002,"CALCULO DO IMPOSTO",oFont08N:oFont)
	_oDanfe:Box(307,000,330,121)
	_oDanfe:Say(316,002,"BASE DE CALCULO DO ICMS",oFont08N:oFont)
	_oDanfe:Say(326,002,aTotais[01],oFont08:oFont)
	_oDanfe:Box(307,120,330,200)
	_oDanfe:Say(316,125,"VALOR DO ICMS",oFont08N:oFont)
	_oDanfe:Say(326,125,aTotais[02],oFont08:oFont)
	_oDanfe:Box(307,199,330,360)
	_oDanfe:Say(316,200,"BASE DE CALCULO DO ICMS SUBSTITUIÇÃO",oFont08N:oFont)
	_oDanfe:Say(326,202,aTotais[03],oFont08:oFont)
	_oDanfe:Box(307,360,330,490)
	_oDanfe:Say(316,363,"VALOR DO ICMS SUBSTITUIÇÃO",oFont08N:oFont)
	_oDanfe:Say(326,363,aTotais[04],oFont08:oFont)
	_oDanfe:Box(307,490,330,603)
	_oDanfe:Say(316,491,"VALOR TOTAL DOS PRODUTOS",oFont08N:oFont)
	_oDanfe:Say(327,491,aTotais[05],oFont08:oFont)


	_oDanfe:Box(330,000,353,110)
	_oDanfe:Say(339,002,"VALOR DO FRETE",oFont08N:oFont)
	_oDanfe:Say(349,002,aTotais[06],oFont08:oFont)
	_oDanfe:Box(330,100,353,190)
	_oDanfe:Say(339,102,"VALOR DO SEGURO",oFont08N:oFont)
	_oDanfe:Say(349,102,aTotais[07],oFont08:oFont)
	_oDanfe:Box(330,190,353,290)
	_oDanfe:Say(339,194,"DESCONTO",oFont08N:oFont)
	_oDanfe:Say(349,194,aTotais[08],oFont08:oFont)
	_oDanfe:Box(330,290,353,415)
	_oDanfe:Say(339,295,"OUTRAS DESPESAS ACESSÓRIAS",oFont08N:oFont)
	_oDanfe:Say(349,295,aTotais[09],oFont08:oFont)
	_oDanfe:Box(330,414,353,500)
	_oDanfe:Say(339,420,"VALOR DO IPI",oFont08N:oFont)
	_oDanfe:Say(349,420,aTotais[10],oFont08:oFont)
	_oDanfe:Box(330,500,353,603)
	_oDanfe:Say(339,506,"VALOR TOTAL DA NOTA",oFont08N:oFont)
	_oDanfe:Say(349,506,aTotais[11],oFont08:oFont)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transportador/Volumes transportados                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_oDanfe:Say(361,002,"TRANSPORTADOR/VOLUMES TRANSPORTADOS",oFont08N:oFont)
	_oDanfe:Box(363,000,386,603)
	_oDanfe:Say(372,002,"RAZÃO SOCIAL",oFont08N:oFont)
	_oDanfe:Say(382,002,aTransp[01],oFont08:oFont)
	_oDanfe:Box(363,245,386,315)
	_oDanfe:Say(372,247,"FRETE POR CONTA",oFont08N:oFont)
	If cModFrete =="0"
		_oDanfe:Say(382,247,"0-EMITENTE",oFont08:oFont)
	ElseIf cModFrete =="1"
		_oDanfe:Say(382,247,"1-DEST/REM",oFont08:oFont)
	ElseIf cModFrete =="2"
		_oDanfe:Say(382,247,"2-TERCEIROS",oFont08:oFont)
	ElseIf cModFrete =="9"
		_oDanfe:Say(382,247,"9-SEM FRETE",oFont08:oFont)
	Else
		_oDanfe:Say(382,247,"",oFont08:oFont)
	Endif
	//_oDanfe:Say(382,102,"0-EMITENTE/1-DESTINATARIO       [" + aTransp[02] + "]",oFont08:oFont)
	_oDanfe:Box(363,315,386,370)
	_oDanfe:Say(372,317,"CÓDIGO ANTT",oFont08N:oFont)
	_oDanfe:Say(382,319,aTransp[03],oFont08:oFont)
	_oDanfe:Box(363,370,386,490)
	_oDanfe:Say(372,375,"PLACA DO VEÍCULO",oFont08N:oFont)
	_oDanfe:Say(382,375,aTransp[04],oFont08:oFont)
	_oDanfe:Box(363,450,386,510)
	_oDanfe:Say(372,452,"UF",oFont08N:oFont)
	_oDanfe:Say(382,452,aTransp[05],oFont08:oFont)
	_oDanfe:Box(363,510,386,603)
	_oDanfe:Say(372,512,"CNPJ/CPF",oFont08N:oFont)
	_oDanfe:Say(382,512,aTransp[06],oFont08:oFont)

	_oDanfe:Box(385,000,409,603)
	_oDanfe:Box(385,000,409,241)
	_oDanfe:Say(393,002,"ENDEREÇO",oFont08N:oFont)
	_oDanfe:Say(404,002,aTransp[07],oFont08:oFont)
	_oDanfe:Box(385,240,409,341)
	_oDanfe:Say(393,242,"MUNICIPIO",oFont08N:oFont)
	_oDanfe:Say(404,242,aTransp[08],oFont08:oFont)
	_oDanfe:Box(385,340,409,440)
	_oDanfe:Say(393,342,"UF",oFont08N:oFont)
	_oDanfe:Say(404,342,aTransp[09],oFont08:oFont)
	_oDanfe:Box(385,440,409,603)
	_oDanfe:Say(393,442,"INSCRIÇÃO ESTADUAL",oFont08N:oFont)
	_oDanfe:Say(404,442,aTransp[10],oFont08:oFont)


	_oDanfe:Box(408,000,432,603)
	_oDanfe:Box(408,000,432,101)
	_oDanfe:Say(418,002,"QUANTIDADE",oFont08N:oFont)
	_oDanfe:Say(428,002,aTransp[11],oFont08:oFont)
	_oDanfe:Box(408,100,432,200)
	_oDanfe:Say(418,102,"ESPECIE",oFont08N:oFont)
	_oDanfe:Say(428,102,Iif(!Empty(aTransp[12]),aTransp[12],Iif(Len(aEspVol)>0,aEspVol[1][1],"")),oFont08:oFont)
	//_oDanfe:Say(428,102,aEspVol[1][1],oFont08:oFont)
	_oDanfe:Box(408,200,432,301)
	_oDanfe:Say(418,202,"MARCA",oFont08N:oFont)
	_oDanfe:Say(428,202,aTransp[13],oFont08:oFont)
	_oDanfe:Box(408,300,432,400)
	_oDanfe:Say(418,302,"NUMERAÇÃO",oFont08N:oFont)
	_oDanfe:Say(428,302,aTransp[14],oFont08:oFont)
	_oDanfe:Box(408,400,432,501)
	_oDanfe:Say(418,402,"PESO BRUTO",oFont08N:oFont)
	_oDanfe:Say(428,402,Iif(!Empty(aTransp[15]),aTransp[15],Iif(Len(aEspVol)>0 .And. Val(aEspVol[1][3])>0,Transform(Val(aEspVol[1][3]),"@E 999999.9999"),"")),oFont08:oFont)
	//_oDanfe:Say(428,402,Iif (!Empty(aEspVol[1][3]),Transform(val(aEspVol[1][3]),"@E 999999.9999"),""),oFont08:oFont)
	_oDanfe:Box(408,500,432,603)
	_oDanfe:Say(418,502,"PESO LIQUIDO",oFont08N:oFont)
	_oDanfe:Say(428,502,Iif(!Empty(aTransp[16]),aTransp[16],Iif(Len(aEspVol)>0 .And. Val(aEspVol[1][2])>0,Transform(Val(aEspVol[1][2]),"@E 999999.9999"),"")),oFont08:oFont)
	//_oDanfe:Say(428,502,Iif (!Empty(aEspVol[1][2]),Transform(val(aEspVol[1][2]),"@E 999999.9999"),""),oFont08:oFont)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calculo do ISSQN                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	_oDanfe:Say(686,000,"CALCULO DO ISSQN",oFont08N:oFont)
	_oDanfe:Box(688,000,711,151)
	_oDanfe:Say(696,002,"INSCRIÇÃO MUNICIPAL",oFont08N:oFont)
	_oDanfe:Say(706,002,aISSQN[1],oFont08:oFont)
	_oDanfe:Box(688,150,711,301)
	_oDanfe:Say(696,152,"VALOR TOTAL DOS SERVIÇOS",oFont08N:oFont)
	_oDanfe:Say(706,152,aISSQN[2],oFont08:oFont)
	_oDanfe:Box(688,300,711,451)
	_oDanfe:Say(696,302,"BASE DE CÁLCULO DO ISSQN",oFont08N:oFont)
	_oDanfe:Say(706,302,aISSQN[3],oFont08:oFont)
	_oDanfe:Box(688,450,711,603)
	_oDanfe:Say(696,452,"VALOR DO ISSQN",oFont08N:oFont)
	_oDanfe:Say(706,452,aISSQN[4],oFont08:oFont)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Dados Adicionais                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_oDanfe:Say(719,000,"DADOS ADICIONAIS",oFont08N:oFont)
	_oDanfe:Box(721,000,865,351)
	_oDanfe:Say(729,002,"INFORMAÇÕES COMPLEMENTARES",oFont08N:oFont)

	nLenMensagens:= Len(aMensagem)
	nLin:= 741
	nMensagem := 0
	For nX := 1 To Min(nLenMensagens, MAXMSG)
		_oDanfe:Say(nLin,002,aMensagem[nX],oFont08:oFont)
		nLin:= nLin+10
	Next nX
	nMensagem := nX

	_oDanfe:Box(721,350,865,603)
	_oDanfe:Say(729,352,"RESERVADO AO FISCO",oFont08N:oFont)

	nLenMensagens:= Len(aResFisco)
	nLin:= 741
	For nX := 1 To Min(nLenMensagens, MAXMSG)
		_oDanfe:Say(nLin,351,aResFisco[nX],oFont08:oFont)
		nLin:= nLin+10
	Next

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Dados do produto ou servico                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAux := {{{},{},{},{},{},{},{},{},{},{},{},{},{},{}}}
	nY := 0
	nLenItens := Len(aItens)

	For nX :=1 To nLenItens
		nY++
		aadd(Atail(aAux)[nY],aItens[nX][01])
		nY++
		aadd(Atail(aAux)[nY],NoChar(aItens[nX][02],lConverte))
		nY++
		aadd(Atail(aAux)[nY],aItens[nX][03])
		nY++
		aadd(Atail(aAux)[nY],aItens[nX][04])
		nY++
		aadd(Atail(aAux)[nY],aItens[nX][05])
		nY++
		aadd(Atail(aAux)[nY],aItens[nX][06])
		nY++
		aadd(Atail(aAux)[nY],aItens[nX][07])
		nY++
		aadd(Atail(aAux)[nY],aItens[nX][08])
		nY++
		aadd(Atail(aAux)[nY],aItens[nX][09])
		nY++
		aadd(Atail(aAux)[nY],aItens[nX][10])
		nY++
		aadd(Atail(aAux)[nY],aItens[nX][11])
		nY++
		aadd(Atail(aAux)[nY],aItens[nX][12])
		nY++
		aadd(Atail(aAux)[nY],aItens[nX][13])
		nY++
		aadd(Atail(aAux)[nY],aItens[nX][14])
		If nY >= 14
			nY := 0
		EndIf
	Next nX
	For nX := 1 To nLenItens
		nY++
		aadd(Atail(aAux)[nY],"")
		nY++
		aadd(Atail(aAux)[nY],"")
		nY++
		aadd(Atail(aAux)[nY],"")
		nY++
		aadd(Atail(aAux)[nY],"")
		nY++
		aadd(Atail(aAux)[nY],"")
		nY++
		aadd(Atail(aAux)[nY],"")
		nY++
		aadd(Atail(aAux)[nY],"")
		nY++
		aadd(Atail(aAux)[nY],"")
		nY++
		aadd(Atail(aAux)[nY],"")
		nY++
		aadd(Atail(aAux)[nY],"")
		nY++
		aadd(Atail(aAux)[nY],"")
		nY++
		aadd(Atail(aAux)[nY],"")
		nY++
		aadd(Atail(aAux)[nY],"")
		nY++
		aadd(Atail(aAux)[nY],"")
		If nY >= 14
			nY := 0
		EndIf

	Next nX

	// Popula o array de cabeçalho das colunas de produtos/serviços.
	aAuxCabec := {;
	"COD. PROD",;
	"DESCRIÇÃO DO PROD./SERV.",;
	"NCM/SH",;
	IIf( cMVCODREG == "1", "CSOSN","CST" ),;
	"CFOP",;
	"UN",;
	"QUANT.",;
	"V.UNITARIO",;
	"V.TOTAL",;
	"BC.ICMS",;
	"V.ICMS",;
	"V.IPI",;
	"A.ICMS",;
	"A.IPI";
	}

	// Retorna o tamanho das colunas baseado em seu conteudo
	aTamCol := RetTamCol(aAuxCabec, aAux, _oDanfe, oFont08:oFont, oFont08N:oFont)

	_oDanfe:Say(440,002,"DADOS DO PRODUTO / SERVIÇO",oFont08N:oFont)
	_oDanfe:Box(442,000,678,603)
	nAuxH := 0
	_oDanfe:Box(442, nAuxH, 678, nAuxH + aTamCol[1])
	_oDanfe:Say(450, nAuxH + 2, "COD. PROD",oFont08N:oFont)
	nAuxH += aTamCol[1]
	_oDanfe:Box(442, nAuxH, 678, nAuxH + aTamCol[2])
	_oDanfe:Say(450, nAuxH + 2, "DESCRIÇÃO DO PROD./SERV.", oFont08N:oFont)
	nAuxH += aTamCol[2]
	_oDanfe:Box(442, nAuxH, 678, nAuxH + aTamCol[3])
	_oDanfe:Say(450, nAuxH + 2, "NCM/SH", oFont08N:oFont)
	nAuxH += aTamCol[3]
	_oDanfe:Box(442, nAuxH, 678, nAuxH + aTamCol[4])

	If cMVCODREG == "1"
		_oDanfe:Say(450, nAuxH + 2, "CSOSN", oFont08N:oFont)
	Else
		_oDanfe:Say(450, nAuxH + 2, "CST", oFont08N:oFont)
	Endif

	nAuxH += aTamCol[4]
	_oDanfe:Box(442, nAuxH, 678, nAuxH + aTamCol[5])
	_oDanfe:Say(450, nAuxH + 2, "CFOP", oFont08N:oFont)
	nAuxH += aTamCol[5]
	_oDanfe:Box(442, nAuxH, 678, nAuxH + aTamCol[6])
	_oDanfe:Say(450, nAuxH + 2, "UN", oFont08N:oFont)
	nAuxH += aTamCol[6]
	_oDanfe:Box(442, nAuxH, 678, nAuxH + aTamCol[7])
	_oDanfe:Say(450, nAuxH + 2, "QUANT.", oFont08N:oFont)
	nAuxH += aTamCol[7]
	_oDanfe:Box(442, nAuxH, 678, nAuxH + aTamCol[8])
	_oDanfe:Say(450, nAuxH + 2, "V.UNITARIO", oFont08N:oFont)
	nAuxH += aTamCol[8]
	_oDanfe:Box(442, nAuxH, 678, nAuxH + aTamCol[9])
	_oDanfe:Say(450, nAuxH + 2, "V.TOTAL", oFont08N:oFont)
	nAuxH += aTamCol[9]
	_oDanfe:Box(442, nAuxH, 678, nAuxH + aTamCol[10])
	_oDanfe:Say(450, nAuxH + 2, "BC.ICMS", oFont08N:oFont)
	nAuxH += aTamCol[10]
	_oDanfe:Box(442, nAuxH, 678, nAuxH + aTamCol[11])
	_oDanfe:Say(450, nAuxH + 2, "V.ICMS", oFont08N:oFont)
	nAuxH += aTamCol[11]
	_oDanfe:Box(442, nAuxH, 678, nAuxH + aTamCol[12])
	_oDanfe:Say(450, nAuxH + 2, "V.IPI", oFont08N:oFont)
	nAuxH += aTamCol[12]
	_oDanfe:Box(442, nAuxH, 678, nAuxH + aTamCol[13])
	_oDanfe:Say(450, nAuxH + 2, "A.ICMS", oFont08N:oFont)
	nAuxH += aTamCol[13]
	_oDanfe:Box(442, nAuxH, 678, nAuxH + aTamCol[14])
	_oDanfe:Say(450, nAuxH + 2, "A.IPI", oFont08N:oFont)

	If nFolhas>1
		_oDanfe:Say(875,497,"CONTINUA...")
	Endif

	// INICIANDO INFORMAÇÕES PARA O CABEÇALHO DA PAGINA 2
	nLinha	:= 460
	nL	:= 0
	lFlag	:= .T.

	For nY := 1 To nLenItens
		nL++

		nLin:= 741
		nCont := 0

		If lflag
			If nL > nMaxItemP2
				_oDanfe:EndPage()
				_oDanfe:StartPage()
				nLinhavers := 0
				nLinha    	:=	181 + IIF(nFolha >=3 ,0, nLinhavers)

				_oDanfe:Box(000+nLinhavers,000,095+nLinhavers,250)
				_oDanfe:Say(010+nLinhavers,002, "Identificação do emitente",oFont12N:oFont)

				nLinCalc	:=	023 + nLinhavers
				cStrAux		:=	AllTrim(NoChar(oEmitente:_xNome:Text,lConverte))
				nForTo		:=	Len(cStrAux)/45
				nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
				For nX := 1 To nForTo
					_oDanfe:Say(nLinCalc,002,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*45)+1),45), oFont12N:oFont )
					nLinCalc+=10
				Next nX

				cStrAux		:=	AllTrim(NoChar(oEmitente:_EnderEmit:_xLgr:Text,lConverte))+", "+AllTrim(oEmitente:_EnderEmit:_Nro:Text)
				nForTo		:=	Len(cStrAux)/60
				nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
				For nX := 1 To nForTo
					_oDanfe:Say(nLinCalc,002,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*60)+1),60),oFont08N:oFont)
					nLinCalc+=10
				Next nX

				If Type("oEmitente:_EnderEmit:_xCpl") <> "U"
					cStrAux		:=	"Complemento: "+AllTrim(NoChar(oEmitente:_EnderEmit:_xCpl:TEXT,lConverte))
					nForTo		:=	Len(cStrAux)/60
					nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
					For nX := 1 To nForTo
						_oDanfe:Say(nLinCalc,002,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*60)+1),60),oFont08N:oFont)
						nLinCalc+=10
					Next nX

					cStrAux		:=	AllTrim(NoChar(oEmitente:_EnderEmit:_xBairro:Text,lConverte))
					If Type("oEmitente:_EnderEmit:_Cep")<>"U"
						cStrAux		+=	" Cep:"+TransForm(oEmitente:_EnderEmit:_Cep:Text,"@r 99999-999")
					EndIf
					nForTo		:=	Len(cStrAux)/60
					nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
					For nX := 1 To nForTo
						_oDanfe:Say(nLinCalc,002,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*60)+1),60),oFont08N:oFont)
						nLinCalc+=10
					Next nX
					_oDanfe:Say(nLinCalc,002, oEmitente:_EnderEmit:_xMun:Text+"/"+oEmitente:_EnderEmit:_UF:Text,oFont08N:oFont)
					nLinCalc+=10
					_oDanfe:Say(nLinCalc,002, "Fone: "+IIf(Type("oEmitente:_EnderEmit:_Fone")=="U","",oEmitente:_EnderEmit:_Fone:Text),oFont08N:oFont)
				Else
					_oDanfe:Say(nLinCalc,002, NoChar(oEmitente:_EnderEmit:_xBairro:Text,lConverte)+" Cep:"+TransForm(IIF(Type("oEmitente:_EnderEmit:_Cep")=="U","",oEmitente:_EnderEmit:_Cep:Text),"@r 99999-999"),oFont08N:oFont)
					nLinCalc+=10
					_oDanfe:Say(nLinCalc,002, oEmitente:_EnderEmit:_xMun:Text+"/"+oEmitente:_EnderEmit:_UF:Text,oFont08N:oFont)
					nLinCalc+=10
					_oDanfe:Say(nLinCalc,002, "Fone: "+IIf(Type("oEmitente:_EnderEmit:_Fone")=="U","",oEmitente:_EnderEmit:_Fone:Text),oFont08N:oFont)
				EndIf

				_oDanfe:Box(000+nLinhavers,248,095+nLinhavers,351)
				_oDanfe:Say(013+nLinhavers,255, "DANFE",oFont18N:oFont)
				_oDanfe:Say(023+nLinhavers,255, "DOCUMENTO AUXILIAR DA",oFont07:oFont)
				_oDanfe:Say(033+nLinhavers,255, "NOTA FISCAL ELETRÔNICA",oFont07:oFont)
				_oDanfe:Say(043+nLinhavers,255, "0-ENTRADA",oFont08:oFont)
				_oDanfe:Say(053+nLinhavers,255, "1-SAÍDA"  ,oFont08:oFont)
				_oDanfe:Box(037+nLinhavers,305,047+nLinhavers,315)
				_oDanfe:Say(045+nLinhavers,307, oIdent:_TpNf:Text,oFont08N:oFont)
				_oDanfe:Say(062+nLinhavers,255,"N. "+StrZero(Val(oIdent:_NNf:Text),9),oFont10N:oFont)
				_oDanfe:Say(072+nLinhavers,255,"SÉRIE "+oIdent:_Serie:Text,oFont10N:oFont)
				_oDanfe:Say(082+nLinhavers,255,"FOLHA "+StrZero(nFolha,2)+"/"+StrZero(nFolhas,2),oFont10N:oFont)

				_oDanfe:Box(000+nLinhavers,350,095+nLinhavers,603)
				_oDanfe:Box(000+nLinhavers,350,040+nLinhavers,603)
				_oDanfe:Box(040+nLinhavers,350,062+nLinhavers,603)
				_oDanfe:Box(063+nLinhavers,350,095+nLinhavers,603)
				_oDanfe:Say(058+nLinhavers,355,TransForm(SubStr(oNF:_InfNfe:_ID:Text,4),"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"),oFont12N:oFont)

				_oDanfe:Say(048+nLinhavers,355,"CHAVE DE ACESSO DA NF-E",oFont12N:oFont)
				nFontSize := 28
				_oDanfe:Code128C(036+nLinhavers,370,SubStr(oNF:_InfNfe:_ID:Text,4), nFontSize )





				_oDanfe:Box(100+nLinhavers,000,123+nLinhavers,603)
				_oDanfe:Box(100+nLinhavers,000,123+nLinhavers,300)
				_oDanfe:Say(109+nLinhavers,002,"NATUREZA DA OPERAÇÃO",oFont08N:oFont)
				_oDanfe:Say(119+nLinhavers,002,oIdent:_NATOP:TEXT,oFont08:oFont)

				nFolha++

				_oDanfe:Box(126+nLinhavers,000,153+nLinhavers,603)
				_oDanfe:Box(126+nLinhavers,000,153+nLinhavers,200)
				_oDanfe:Box(126+nLinhavers,200,153+nLinhavers,400)
				_oDanfe:Box(126+nLinhavers,400,153+nLinhavers,603)
				_oDanfe:Say(135+nLinhavers,002,"INSCRIÇÃO ESTADUAL",oFont08N:oFont)
				_oDanfe:Say(143+nLinhavers,002,IIf(Type("oEmitente:_IE:TEXT")<>"U",oEmitente:_IE:TEXT,""),oFont08:oFont)
				_oDanfe:Say(135+nLinhavers,205,"INSC.ESTADUAL DO SUBST.TRIB.",oFont08N:oFont)
				_oDanfe:Say(143+nLinhavers,205,IIf(Type("oEmitente:_IEST:TEXT")<>"U",oEmitente:_IEST:TEXT,""),oFont08:oFont)
				_oDanfe:Say(135+nLinhavers,405,"CNPJ",oFont08N:oFont)
				_oDanfe:Say(143+nLinhavers,405,TransForm(oEmitente:_CNPJ:TEXT,IIf(Len(oEmitente:_CNPJ:TEXT)<>14,"@r 999.999.999-99","@r 99.999.999/9999-99")),oFont08:oFont)

				nLenMensagens:= Len(aMensagem)

				nColLim		:=	Iif(nMensagem <= nLenMensagens,680,865)
				//				nColLim		:=	435
				_oDanfe:Say(161+nLinhavers,002,"DADOS DO PRODUTO / SERVIÇO",oFont08N:oFont)
				_oDanfe:Box(163+nLinhavers,000,nColLim,603)

				nAuxH := 0
				_oDanfe:Box(163+nLinhavers, nAuxH, nColLim, nAuxH + aTamCol[1])
				_oDanfe:Say(171+nLinhavers, nAuxH + 2, "COD. PROD",oFont08N:oFont)
				nAuxH += aTamCol[1]
				_oDanfe:Box(163+nLinhavers, nAuxH, nColLim, nAuxH + aTamCol[2])
				_oDanfe:Say(171+nLinhavers, nAuxH + 2, "DESCRIÇÃO DO PROD./SERV.", oFont08N:oFont)
				nAuxH += aTamCol[2]
				_oDanfe:Box(163+nLinhavers, nAuxH, nColLim, nAuxH + aTamCol[3])
				_oDanfe:Say(171+nLinhavers, nAuxH + 2, "NCM/SH", oFont08N:oFont)
				nAuxH += aTamCol[3]
				_oDanfe:Box(163+nLinhavers, nAuxH, nColLim, nAuxH + aTamCol[4])

				_oDanfe:Say(171+nLinhavers, nAuxH + 2, "CST", oFont08N:oFont)

				nAuxH += aTamCol[4]
				_oDanfe:Box(163+nLinhavers, nAuxH, nColLim, nAuxH + aTamCol[5])
				_oDanfe:Say(171+nLinhavers, nAuxH + 2, "CFOP", oFont08N:oFont)
				nAuxH += aTamCol[5]
				_oDanfe:Box(163+nLinhavers, nAuxH, nColLim, nAuxH + aTamCol[6])
				_oDanfe:Say(171+nLinhavers, nAuxH + 2, "UN", oFont08N:oFont)
				nAuxH += aTamCol[6]
				_oDanfe:Box(163+nLinhavers, nAuxH, nColLim, nAuxH + aTamCol[7])
				_oDanfe:Say(171+nLinhavers, nAuxH + 2, "QUANT.", oFont08N:oFont)
				nAuxH += aTamCol[7]
				_oDanfe:Box(163+nLinhavers, nAuxH, nColLim, nAuxH + aTamCol[8])
				_oDanfe:Say(171+nLinhavers, nAuxH + 2, "V.UNITARIO", oFont08N:oFont)
				nAuxH += aTamCol[8]
				_oDanfe:Box(163+nLinhavers, nAuxH, nColLim, nAuxH + aTamCol[9])
				_oDanfe:Say(171+nLinhavers, nAuxH + 2, "V.TOTAL", oFont08N:oFont)
				nAuxH += aTamCol[9]
				_oDanfe:Box(163+nLinhavers, nAuxH, nColLim, nAuxH + aTamCol[10])
				_oDanfe:Say(171+nLinhavers, nAuxH + 2, "BC.ICMS", oFont08N:oFont)
				nAuxH += aTamCol[10]
				_oDanfe:Box(163+nLinhavers, nAuxH, nColLim, nAuxH + aTamCol[11])
				_oDanfe:Say(171+nLinhavers, nAuxH + 2, "V.ICMS", oFont08N:oFont)
				nAuxH += aTamCol[11]
				_oDanfe:Box(163+nLinhavers, nAuxH, nColLim, nAuxH + aTamCol[12])
				_oDanfe:Say(171+nLinhavers, nAuxH + 2, "V.IPI", oFont08N:oFont)
				nAuxH += aTamCol[12]
				_oDanfe:Box(163+nLinhavers, nAuxH, nColLim, nAuxH + aTamCol[13])
				_oDanfe:Say(171+nLinhavers, nAuxH + 2, "A.ICMS", oFont08N:oFont)
				nAuxH += aTamCol[13]
				_oDanfe:Box(163+nLinhavers, nAuxH, nColLim, nAuxH + aTamCol[14])
				_oDanfe:Say(171+nLinhavers, nAuxH + 2, "A.IPI", oFont08N:oFont)

				// FINALIZANDO INFORMAÇÕES PARA O CABEÇALHO DA PAGINA 2
				nL	:= 1
				lFlag	:= .F.

				//Verifico se ainda existem Dados Adicionais a serem impressos
				IF nMensagem <= nLenMensagens
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Dados Adicionais                                                        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					_oDanfe:Say(719+nLinhavers,000,"DADOS ADICIONAIS",oFont08N:oFont)
					_oDanfe:Box(721+nLinhavers,000,865+nLinhavers,351)
					_oDanfe:Say(729+nLinhavers,002,"INFORMAÇÕES COMPLEMENTARES",oFont08N:oFont)

					nLin:= 741
					nLenMensagens:= Len(aMensagem)
					--nMensagem
					For nX := 1 To Min(nLenMensagens - nMensagem, MAXMSG)
						_oDanfe:Say(nLin,002,aMensagem[nMensagem+nX],oFont08:oFont)
						nLin:= nLin+10
					Next nX
					nMensagem := nMensagem+nX

					_oDanfe:Box(721+nLinhavers,350,865+nLinhavers,603)
					_oDanfe:Say(729+nLinhavers,352,"RESERVADO AO FISCO",oFont08N:oFont)

					// Seta o máximo de itens para o MAXITEMP2
					nMaxItemP2 := MAXITEMP2
				Else
					// Seta o máximo de itens para o MAXITEMP2F
					nMaxItemP2 := MAXITEMP2F
				EndIF
			Endif
		Endif

		// INICIANDO INFORMAÇÕES PARA O CABEÇALHO DA PAGINA 3 E DIANTE
		If	nL > Iif( (nfolha-1)%2==0,MAXITEMP3,nMaxItemP2)
			_oDanfe:EndPage()
			_oDanfe:StartPage()
			nLenMensagens:= Len(aMensagem)
			nColLim		:=	Iif(!(nfolha-1)%2==0 ,435,Iif(nMensagem <= nLenMensagens,680,865))
			lFimpar		:=  ((nfolha-1)%2==0)
			nLinha    	:=	181
			If nfolha >= 3
				nLinhavers := 0
			EndIf
			_oDanfe:Box(000,000,095,250)
			_oDanfe:Say(010,098, "Identificação do emitente",oFont12N:oFont)
			nLinCalc	:=	023
			cStrAux		:=	AllTrim(NoChar(oEmitente:_xNome:Text,lConverte))
			nForTo		:=	Len(cStrAux)/45
			nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
			For nX := 1 To nForTo
				_oDanfe:Say(nLinCalc,002,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*45)+1),45), oFont12N:oFont )
				nLinCalc+=10
			Next nX

			cStrAux		:=	AllTrim(NoChar(oEmitente:_EnderEmit:_xLgr:Text,lConverte))+", "+AllTrim(oEmitente:_EnderEmit:_Nro:Text)
			nForTo		:=	Len(cStrAux)/60
			nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
			For nX := 1 To nForTo
				_oDanfe:Say(nLinCalc,002,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*60)+1),60),oFont08N:oFont)
				nLinCalc+=10
			Next nX

			If Type("oEmitente:_EnderEmit:_xCpl") <> "U"
				cStrAux		:=	"Complemento: "+AllTrim(NoChar(oEmitente:_EnderEmit:_xCpl:TEXT,lConverte))
				nForTo		:=	Len(cStrAux)/60
				nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
				For nX := 1 To nForTo
					_oDanfe:Say(nLinCalc,002,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*60)+1),60),oFont08N:oFont)
					nLinCalc+=10
				Next nX

				cStrAux		:=	AllTrim(NoChar(oEmitente:_EnderEmit:_xBairro:Text,lConverte))
				If Type("oEmitente:_EnderEmit:_Cep")<>"U"
					cStrAux		+=	" Cep:"+TransForm(oEmitente:_EnderEmit:_Cep:Text,"@r 99999-999")
				EndIf
				nForTo		:=	Len(cStrAux)/60
				nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
				For nX := 1 To nForTo
					_oDanfe:Say(nLinCalc,002,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*60)+1),60),oFont08N:oFont)
					nLinCalc+=10
				Next nX
				_oDanfe:Say(nLinCalc,002, oEmitente:_EnderEmit:_xMun:Text+"/"+oEmitente:_EnderEmit:_UF:Text,oFont08N:oFont)
				nLinCalc+=10
				_oDanfe:Say(nLinCalc,002, "Fone: "+IIf(Type("oEmitente:_EnderEmit:_Fone")=="U","",oEmitente:_EnderEmit:_Fone:Text),oFont08N:oFont)
			Else
				_oDanfe:Say(nLinCalc,002, NoChar(oEmitente:_EnderEmit:_xBairro:Text,lConverte)+" Cep:"+TransForm(IIF(Type("oEmitente:_EnderEmit:_Cep")=="U","",oEmitente:_EnderEmit:_Cep:Text),"@r 99999-999"),oFont08N:oFont)
				nLinCalc+=10
				_oDanfe:Say(nLinCalc,002, oEmitente:_EnderEmit:_xMun:Text+"/"+oEmitente:_EnderEmit:_UF:Text,oFont08N:oFont)
				nLinCalc+=10
				_oDanfe:Say(nLinCalc,002, "Fone: "+IIf(Type("oEmitente:_EnderEmit:_Fone")=="U","",oEmitente:_EnderEmit:_Fone:Text),oFont08N:oFont)
			EndIf

			_oDanfe:Box(000,248,095,351)
			_oDanfe:Say(013,255, "DANFE",oFont18N:oFont)
			_oDanfe:Say(023,255, "DOCUMENTO AUXILIAR DA",oFont07:oFont)
			_oDanfe:Say(033,255, "NOTA FISCAL ELETRÔNICA",oFont07:oFont)
			_oDanfe:Say(043,255, "0-ENTRADA",oFont08:oFont)
			_oDanfe:Say(053,255, "1-SAÍDA"  ,oFont08:oFont)
			_oDanfe:Box(037,305,047,315)
			_oDanfe:Say(045,307, oIdent:_TpNf:Text,oFont08N:oFont)
			_oDanfe:Say(062,255,"N. "+StrZero(Val(oIdent:_NNf:Text),9),oFont10N:oFont)
			_oDanfe:Say(072,255,"SÉRIE "+oIdent:_Serie:Text,oFont10N:oFont)
			_oDanfe:Say(082,255,"FOLHA "+StrZero(nFolha,2)+"/"+StrZero(nFolhas,2),oFont10N:oFont)

			_oDanfe:Box(000,350,095,603)
			_oDanfe:Box(000,350,040,603)
			_oDanfe:Box(040,350,062,603)
			_oDanfe:Box(063,350,095,603)
			_oDanfe:Say(058,355,TransForm(SubStr(oNF:_InfNfe:_ID:Text,4),"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"),oFont12N:oFont)

			_oDanfe:Say(048,355,"CHAVE DE ACESSO DA NF-E",oFont12N:oFont)
			nFontSize := 28
			_oDanfe:Code128C(036,370,SubStr(oNF:_InfNfe:_ID:Text,4), nFontSize )


			_oDanfe:Box(100,000,123,603)
			_oDanfe:Box(100,000,123,300)
			_oDanfe:Say(109,002,"NATUREZA DA OPERAÇÃO",oFont08N:oFont)
			_oDanfe:Say(119,002,oIdent:_NATOP:TEXT,oFont08:oFont)
			If(((Val(oNF:_INFNFE:_IDE:_SERIE:TEXT) >= 900).And.(oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"2") .Or. (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"1")
				_oDanfe:Say(109,302,"PROTOCOLO DE AUTORIZAÇÃO DE USO",oFont08N:oFont)
			Endif
			If((oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"25")
				_oDanfe:Say(109,300,"DADOS DA NF-E",oFont08N:oFont)
			Endif
			_oDanfe:Say(119,302,TransForm(cChaveCont,"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999"),oFont08:oFont)

			nFolha++

			_oDanfe:Box(126,000,153,603)
			_oDanfe:Box(126,000,153,200)
			_oDanfe:Box(126,200,153,400)
			_oDanfe:Box(126,400,153,603)
			_oDanfe:Say(135,002,"INSCRIÇÃO ESTADUAL",oFont08N:oFont)
			_oDanfe:Say(143,002,IIf(Type("oEmitente:_IE:TEXT")<>"U",oEmitente:_IE:TEXT,""),oFont08:oFont)
			_oDanfe:Say(135,205,"INSC.ESTADUAL DO SUBST.TRIB.",oFont08N:oFont)
			_oDanfe:Say(143,205,IIf(Type("oEmitente:_IEST:TEXT")<>"U",oEmitente:_IEST:TEXT,""),oFont08:oFont)
			_oDanfe:Say(135,405,"CNPJ",oFont08N:oFont)
			_oDanfe:Say(143,405,TransForm(oEmitente:_CNPJ:TEXT,IIf(Len(oEmitente:_CNPJ:TEXT)<>14,"@r 999.999.999-99","@r 99.999.999/9999-99")),oFont08:oFont)

			_oDanfe:Say(161,002,"DADOS DO PRODUTO / SERVIÇO",oFont08N:oFont)
			_oDanfe:Box(163,000,nColLim,603)

			nAuxH := 0
			_oDanfe:Box(163, nAuxH, nColLim, nAuxH + aTamCol[1])
			_oDanfe:Say(171, nAuxH + 2, "COD. PROD",oFont08N:oFont)
			nAuxH += aTamCol[1]
			_oDanfe:Box(163, nAuxH, nColLim, nAuxH + aTamCol[2])
			_oDanfe:Say(171, nAuxH + 2, "DESCRIÇÃO DO PROD./SERV.", oFont08N:oFont)
			nAuxH += aTamCol[2]
			_oDanfe:Box(163, nAuxH, nColLim, nAuxH + aTamCol[3])
			_oDanfe:Say(171, nAuxH + 2, "NCM/SH", oFont08N:oFont)
			nAuxH += aTamCol[3]
			_oDanfe:Box(163, nAuxH, nColLim, nAuxH + aTamCol[4])

			_oDanfe:Say(171, nAuxH + 2, "CST", oFont08N:oFont)

			nAuxH += aTamCol[4]
			_oDanfe:Box(163, nAuxH, nColLim, nAuxH + aTamCol[5])
			_oDanfe:Say(171, nAuxH + 2, "CFOP", oFont08N:oFont)
			nAuxH += aTamCol[5]
			_oDanfe:Box(163, nAuxH, nColLim, nAuxH + aTamCol[6])
			_oDanfe:Say(171, nAuxH + 2, "UN", oFont08N:oFont)
			nAuxH += aTamCol[6]
			_oDanfe:Box(163, nAuxH, nColLim, nAuxH + aTamCol[7])
			_oDanfe:Say(171, nAuxH + 2, "QUANT.", oFont08N:oFont)
			nAuxH += aTamCol[7]
			_oDanfe:Box(163, nAuxH, nColLim, nAuxH + aTamCol[8])
			_oDanfe:Say(171, nAuxH + 2, "V.UNITARIO", oFont08N:oFont)
			nAuxH += aTamCol[8]
			_oDanfe:Box(163, nAuxH, nColLim, nAuxH + aTamCol[9])
			_oDanfe:Say(171, nAuxH + 2, "V.TOTAL", oFont08N:oFont)
			nAuxH += aTamCol[9]
			_oDanfe:Box(163, nAuxH, nColLim, nAuxH + aTamCol[10])
			_oDanfe:Say(171, nAuxH + 2, "BC.ICMS", oFont08N:oFont)
			nAuxH += aTamCol[10]
			_oDanfe:Box(163, nAuxH, nColLim, nAuxH + aTamCol[11])
			_oDanfe:Say(171, nAuxH + 2, "V.ICMS", oFont08N:oFont)
			nAuxH += aTamCol[11]
			_oDanfe:Box(163, nAuxH, nColLim, nAuxH + aTamCol[12])
			_oDanfe:Say(171, nAuxH + 2, "V.IPI", oFont08N:oFont)
			nAuxH += aTamCol[12]
			_oDanfe:Box(163, nAuxH, nColLim, nAuxH + aTamCol[13])
			_oDanfe:Say(171, nAuxH + 2, "A.ICMS", oFont08N:oFont)
			nAuxH += aTamCol[13]
			_oDanfe:Box(163, nAuxH, nColLim, nAuxH + aTamCol[14])
			_oDanfe:Say(171, nAuxH + 2, "A.IPI", oFont08N:oFont)

			//Verifico se ainda existem Dados Adicionais a serem impressos
			nLenMensagens:= Len(aMensagem)
			IF nMensagem <= nLenMensagens
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Dados Adicionais                                                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				_oDanfe:Say(719,000,"DADOS ADICIONAIS",oFont08N:oFont)
				_oDanfe:Box(721,000,865,351)
				_oDanfe:Say(729,002,"INFORMAÇÕES COMPLEMENTARES",oFont08N:oFont)

				nLin:= 741
				nLenMensagens:= Len(aMensagem)
				--nMensagem
				For nX := 1 To Min(nLenMensagens - nMensagem, MAXMSG)
					_oDanfe:Say(nLin,002,aMensagem[nMensagem+nX],oFont08:oFont)
					nLin:= nLin+10
				Next nX
				nMensagem := nMensagem+nX

				_oDanfe:Box(721+nLinhavers,350,865+nLinhavers,603)
				_oDanfe:Say(729+nLinhavers,352,"RESERVADO AO FISCO",oFont08N:oFont)

				// Seta o máximo de itens para o MAXITEMP2
				nMaxItemP2 := MAXITEMP2
			Else
				// Seta o máximo de itens para o MAXITEMP2F
				nMaxItemP2 := MAXITEMP2F
			EndIF
			If (!(nfolha-1)%2==0)
				If nY+69<nLenItens
					_oDanfe:Say(875+nLinhavers,497,"CONTINUA...")
				Endif
			End

			nL := 1
		EndIf

		nAuxH := 0

		If aAux[1][1][nY] == "-"
			_oDanfe:Say(nLinha, nAuxH, Replicate("- ", 150), oFont08:oFont)
		Else
			_oDanfe:Say(nLinha, nAuxH + 2, aAux[1][1][nY], oFont08:oFont )
			nAuxH += aTamCol[1]
			_oDanfe:Say(nLinha, nAuxH + 2, aAux[1][2][nY], oFont08:oFont) // DESCRICAO DO PRODUTO
			nAuxH += aTamCol[2]
			_oDanfe:Say(nLinha, nAuxH + 2, aAux[1][3][nY], oFont08:oFont) // NCM
			nAuxH += aTamCol[3]
			_oDanfe:Say(nLinha, nAuxH + 2, aAux[1][4][nY], oFont08:oFont) // CST
			nAuxH += aTamCol[4]
			_oDanfe:Say(nLinha, nAuxH + 2, aAux[1][5][nY], oFont08:oFont) // CFOP
			nAuxH += aTamCol[5]
			_oDanfe:Say(nLinha, nAuxH + 2, aAux[1][6][nY], oFont08:oFont) // UN
			nAuxH += aTamCol[6]
			// Workaround para falha no FWMSPrinter:GetTextWidth()

			nAuxH2 := len(aAux[1][7][nY]) + (nAuxH + (aTamCol[7]) - RetTamTex(aAux[1][7][nY], oFont08:oFont, _oDanfe))
			_oDanfe:Say(nLinha, nAuxH2, aAux[1][7][nY], oFont08:oFont) // QUANT
			nAuxH += aTamCol[7]

			nAuxH2 := len(aAux[1][8][nY]) + (nAuxH + (aTamCol[8]) - RetTamTex(aAux[1][8][nY], oFont08:oFont, _oDanfe))
			_oDanfe:Say(nLinha, nAuxH2, aAux[1][8][nY], oFont08:oFont) // V UNITARIO
			nAuxH += aTamCol[8]

			nAuxH2 := len(aAux[1][9][nY]) + (nAuxH + (aTamCol[9]) - RetTamTex(aAux[1][9][nY], oFont08:oFont, _oDanfe))
			_oDanfe:Say(nLinha, nAuxH2, aAux[1][9][nY], oFont08:oFont) // V. TOTAL
			nAuxH += aTamCol[9]

			nAuxH2 := len(aAux[1][10][nY]) + (nAuxH + (aTamCol[10]) - RetTamTex(aAux[1][10][nY], oFont08:oFont, _oDanfe))
			_oDanfe:Say(nLinha, nAuxH2, aAux[1][10][nY], oFont08:oFont) // BC. ICMS
			nAuxH += aTamCol[10]

			nAuxH2 := len(aAux[1][11][nY]) + (nAuxH + (aTamCol[11]) - RetTamTex(aAux[1][11][nY], oFont08:oFont, _oDanfe))
			_oDanfe:Say(nLinha, nAuxH2, aAux[1][11][nY], oFont08:oFont) // V. ICMS
			nAuxH += aTamCol[11]

			nAuxH2 := len(aAux[1][12][nY]) + (nAuxH + (aTamCol[12]) - RetTamTex(aAux[1][12][nY], oFont08:oFont, _oDanfe))
			_oDanfe:Say(nLinha, nAuxH2, aAux[1][12][nY], oFont08:oFont) // V.IPI
			nAuxH += aTamCol[12]

			nAuxH2 := len(aAux[1][13][nY]) + (nAuxH + (aTamCol[13]) - RetTamTex(aAux[1][13][nY], oFont08:oFont, _oDanfe))
			_oDanfe:Say(nLinha, nAuxH2, aAux[1][13][nY], oFont08:oFont) // A.ICMS
			nAuxH += aTamCol[13]

			nAuxH2 := len(aAux[1][14][nY]) + (nAuxH + (aTamCol[14]) - RetTamTex(aAux[1][14][nY], oFont08:oFont, _oDanfe))
			_oDanfe:Say(nLinha, nAuxH2, aAux[1][14][nY], oFont08:oFont) // A.IPI
		EndIf

		nLinha :=nLinha + 10
	Next nY

	nLenMensagens := Len(aMensagem)
	While nMensagem <= nLenMensagens
		cCodAutDPEC := ''
		DanfeCpl(_oDanfe,aItens,aMensagem,@nItem,@nMensagem,oNFe,oIdent,oEmitente,@nFolha,nFolhas,oNfeDPEC,cCodAutDPEC,aUF)
	EndDo

	_oDanfe:EndPage()

Return(.T.)


//³Impressao do Complemento da NFe                                         ³
Static Function DanfeCpl(_oDanfe,aItens,aMensagem,nItem,nMensagem,oNFe,oIdent,oEmitente,nFolha,nFolhas,oNfeDPEC,cCodAutDPEC,aUF)

	Local nX            := 0
	Local nLinha        := 0
	Local nLenMensagens := Len(aMensagem)
	Local nItemOld	    := nItem
	Local nMensagemOld  := nMensagem
	Local nForMensagens := 0
	Local lMensagens    := .F.
	Local cChaveCont 	:= ""
	Local lConverte     := .F.

	Local 	cCNPJCPF :=  ""
	Local 	cUF      :=  ""
	Local 	cDataEmi :=  ""
	Local 	cTPEmis  :=  ""
	Local 	cValIcm  :=  ""
	Local 	cICMSp   :=  ""
	Local 	cICMSs   :=  ""
	local cStartPath := GetSrvProfString("Startpath","")

	If (nLenMensagens - (nMensagemOld - 1)) > 0
		lMensagens := .T.

	EndIf

	//³Dados Adicionais segunda parte em diante³
	If lMensagens
		nLenMensagens := Len(aMensagem)
		nForMensagens := Min(nLenMensagens, MAXITEMP2 + (nMensagemOld - 1) - (nItem - nItemOld))
		_oDanfe:EndPage()
		_oDanfe:StartPage()
		nLinha    :=180
		_oDanfe:Say(160,000,"DADOS ADICIONAIS",oFont08N:oFont)
		_oDanfe:Box(172,000,865,351)
		_oDanfe:Say(170,002,"INFORMAÇÕES COMPLEMENTARES",oFont08N:oFont)
		_oDanfe:Box(172,350,865,603)
		_oDanfe:Say(170,352,"RESERVADO AO FISCO",oFont08N:oFont)


		_oDanfe:Box(000,000,095,250)
		_oDanfe:Say(010,098, "Identificação do emitente",oFont12N:oFont)
		nLinCalc	:=	023
		cStrAux		:=	AllTrim(NoChar(oEmitente:_xNome:Text,lConverte))
		nForTo		:=	Len(cStrAux)/45
		nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
		For nX := 1 To nForTo
			_oDanfe:Say(nLinCalc,002,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*45)+1),45), oFont12N:oFont )
			nLinCalc+=10
		Next nX

		cStrAux		:=	AllTrim(NoChar(oEmitente:_EnderEmit:_xLgr:Text,lConverte))+", "+AllTrim(oEmitente:_EnderEmit:_Nro:Text)
		nForTo		:=	Len(cStrAux)/60
		nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
		For nX := 1 To nForTo
			_oDanfe:Say(nLinCalc,002,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*60)+1),60),oFont08N:oFont)
			nLinCalc+=10
		Next nX

		If Type("oEmitente:_EnderEmit:_xCpl") <> "U"
			cStrAux		:=	"Complemento: "+AllTrim(NoChar(oEmitente:_EnderEmit:_xCpl:TEXT,lConverte))
			nForTo		:=	Len(cStrAux)/60
			nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
			For nX := 1 To nForTo
				_oDanfe:Say(nLinCalc,002,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*60)+1),60),oFont08N:oFont)
				nLinCalc+=10
			Next nX

			cStrAux		:=	AllTrim(NoChar(oEmitente:_EnderEmit:_xBairro:Text,lConverte))
			If Type("oEmitente:_EnderEmit:_Cep")<>"U"
				cStrAux		+=	" Cep:"+TransForm(oEmitente:_EnderEmit:_Cep:Text,"@r 99999-999")
			EndIf
			nForTo		:=	Len(cStrAux)/60
			nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
			For nX := 1 To nForTo
				_oDanfe:Say(nLinCalc,002,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*60)+1),60),oFont08N:oFont)
				nLinCalc+=10
			Next nX
			_oDanfe:Say(nLinCalc,002, oEmitente:_EnderEmit:_xMun:Text+"/"+oEmitente:_EnderEmit:_UF:Text,oFont08N:oFont)
			nLinCalc+=10
			_oDanfe:Say(nLinCalc,002, "Fone: "+IIf(Type("oEmitente:_EnderEmit:_Fone")=="U","",oEmitente:_EnderEmit:_Fone:Text),oFont08N:oFont)
		Else
			_oDanfe:Say(nLinCalc,002, oEmitente:_EnderEmit:_xBairro:Text+" Cep:"+TransForm(IIF(Type("oEmitente:_EnderEmit:_Cep")=="U","",oEmitente:_EnderEmit:_Cep:Text),"@r 99999-999"),oFont08N:oFont)
			nLinCalc+=10
			_oDanfe:Say(nLinCalc,002, oEmitente:_EnderEmit:_xMun:Text+"/"+oEmitente:_EnderEmit:_UF:Text,oFont08N:oFont)
			nLinCalc+=10
			_oDanfe:Say(nLinCalc,002, "Fone: "+IIf(Type("oEmitente:_EnderEmit:_Fone")=="U","",oEmitente:_EnderEmit:_Fone:Text),oFont08N:oFont)
		EndIf

		_oDanfe:Box(000,248,095,351)
		_oDanfe:Say(013,255, "DANFE",oFont18N:oFont)
		_oDanfe:Say(023,255, "DOCUMENTO AUXILIAR DA",oFont07:oFont)
		_oDanfe:Say(033,255, "NOTA FISCAL ELETRÔNICA",oFont07:oFont)
		_oDanfe:Say(043,255, "0-ENTRADA",oFont08:oFont)
		_oDanfe:Say(053,255, "1-SAÍDA"  ,oFont08:oFont)
		_oDanfe:Box(037,305,047,315)
		_oDanfe:Say(045,307, oIdent:_TpNf:Text,oFont08N:oFont)
		_oDanfe:Say(062,255,"N. "+StrZero(Val(oIdent:_NNf:Text),9),oFont10N:oFont)
		_oDanfe:Say(072,255,"SÉRIE "+oIdent:_Serie:Text,oFont10N:oFont)
		_oDanfe:Say(082,255,"FOLHA "+StrZero(nFolha,2)+"/"+StrZero(nFolhas,2),oFont10N:oFont)

		_oDanfe:Box(000,350,095,603)
		_oDanfe:Box(000,350,040,603)
		_oDanfe:Box(040,350,062,603)
		_oDanfe:Box(063,350,095,603)
		_oDanfe:Say(058,355,TransForm(SubStr(oNF:_InfNfe:_ID:Text,4),"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"),oFont12N:oFont)

		_oDanfe:Say(048,355,"CHAVE DE ACESSO DA NF-E",oFont12N:oFont)
		nFontSize := 28
		_oDanfe:Code128C(036,370,SubStr(oNF:_InfNfe:_ID:Text,4), nFontSize )


		_oDanfe:Box(100,000,123,603)
		_oDanfe:Box(100,000,123,300)
		_oDanfe:Say(109,002,"NATUREZA DA OPERAÇÃO",oFont08N:oFont)
		_oDanfe:Say(119,002,oIdent:_NATOP:TEXT,oFont08:oFont)
		If(!Empty(cCodAutDPEC))
			_oDanfe:Say(109,300,"NÚMERO DE REGISTRO DPEC",oFont08N:oFont)
		Endif
		If(((Val(oNF:_INFNFE:_IDE:_SERIE:TEXT) >= 900).And.(oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"2") .Or. (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"1")
			_oDanfe:Say(109,302,"PROTOCOLO DE AUTORIZAÇÃO DE USO",oFont08N:oFont)
		Endif
		If((oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"25")
			_oDanfe:Say(109,300,"DADOS DA NF-E",oFont08N:oFont)
		Endif

		If !Empty(cCodAutDPEC) .And. (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"4"
			cDataEmi := Iif(oNF:_INFNFE:_VERSAO:TEXT >= "3.10",Substr(oNFe:_NFE:_INFNFE:_IDE:_DHEMI:Text,9,2),Substr(oNFe:_NFE:_INFNFE:_IDE:_DEMI:Text,9,2))
			cTPEmis  := "4"

			If Type("oDPEC:_ENVDPEC:_INFDPEC:_RESNFE") <> "U"
				cUF      := aUF[aScan(aUF,{|x| x[1] == oDPEC:_ENVDPEC:_INFDPEC:_RESNFE:_UF:Text})][02]
				cValIcm := StrZero(Val(StrTran(oDPEC:_ENVDPEC:_INFDPEC:_RESNFE:_VNF:TEXT,".","")),14)
				cICMSp := iif(Val(oDPEC:_ENVDPEC:_INFDPEC:_RESNFE:_VICMS:TEXT)>0,"1","2")
				cICMSs := iif(Val(oDPEC:_ENVDPEC:_INFDPEC:_RESNFE:_VST:TEXT)>0,"1","2")
			ElseIf type ("oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST") <> "U" //EPEC NFE
				If Type ("oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_UF:TEXT") <> "U"
					cUF := aUF[aScan(aUF,{|x| x[1] == oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_UF:TEXT})][02]
				EndIf
				If Type ("oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_VNF:TEXT") <> "U"
					cValIcm := StrZero(Val(StrTran(oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_VNF:TEXT,".","")),14)
				EndIf
				If 	Type ("oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_VICMS:TEXT") <> "U"
					cICMSp:= IIf(Val(oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_VICMS:TEXT) > 0,"1","2")
				EndIf
				If 	Type ("oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_VST:TEXT") <> "U"
					cICMSs := IIf(Val(oDPEC:_EVENTO:_INFEVENTO:_DETEVENTO:_DEST:_VST:TEXT )> 0,"1","2")
				EndIf
			EndIf

		ElseIF (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"25"
			cUF      := aUF[aScan(aUF,{|x| x[1] == oNFe:_NFE:_INFNFE:_DEST:_ENDERDEST:_UF:Text})][02]
			cDataEmi := Iif(oNF:_INFNFE:_VERSAO:TEXT >= "3.10",Substr(oNFe:_NFE:_INFNFE:_IDE:_DHEMI:Text,9,2),Substr(oNFe:_NFE:_INFNFE:_IDE:_DEMI:Text,9,2))
			cTPEmis  := oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT
			cValIcm  := StrZero(Val(StrTran(oNFe:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT,".","")),14)
			cICMSp   := iif(Val(oNFe:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VICMS:TEXT)>0,"1","2")
			cICMSs   :=iif(Val(oNFe:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VST:TEXT)>0,"1","2")
		EndIf
		If !Empty(cUF) .And. !Empty(cDataEmi) .And. !Empty(cTPEmis) .And. !Empty(cValIcm) .And. !Empty(cICMSp) .And. !Empty(cICMSs)
			If Type("oNF:_InfNfe:_DEST:_CNPJ:Text")<>"U"
				cCNPJCPF := oNF:_InfNfe:_DEST:_CNPJ:Text
				If cUf == "99"
					cCNPJCPF := STRZERO(val(cCNPJCPF),14)
				EndIf
			ElseIf Type("oNF:_INFNFE:_DEST:_CPF:Text")<>"U"
				cCNPJCPF := oNF:_INFNFE:_DEST:_CPF:Text
				cCNPJCPF := STRZERO(val(cCNPJCPF),14)
			Else
				cCNPJCPF := ""
			EndIf
			cChaveCont += cUF+cTPEmis+cCNPJCPF+cValIcm+cICMSp+cICMSs+cDataEmi
			cChaveCont := cChaveCont+Modulo11(cChaveCont)
		EndIf

		_oDanfe:Say(119,302,TransForm(cChaveCont,"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999"),oFont08:oFont)
		nFolha++

		_oDanfe:Box(126,000,153,603)
		_oDanfe:Box(126,000,153,200)
		_oDanfe:Box(126,200,153,400)
		_oDanfe:Box(126,400,153,603)
		_oDanfe:Say(135,002,"INSCRIÇÃO ESTADUAL",oFont08N:oFont)
		_oDanfe:Say(143,002,IIf(Type("oEmitente:_IE:TEXT")<>"U",oEmitente:_IE:TEXT,""),oFont08:oFont)
		_oDanfe:Say(135,205,"INSC.ESTADUAL DO SUBST.TRIB.",oFont08N:oFont)
		_oDanfe:Say(143,205,IIf(Type("oEmitente:_IEST:TEXT")<>"U",oEmitente:_IEST:TEXT,""),oFont08:oFont)
		_oDanfe:Say(135,405,"CNPJ",oFont08N:oFont)
		_oDanfe:Say(143,405,TransForm(oEmitente:_CNPJ:TEXT,IIf(Len(oEmitente:_CNPJ:TEXT)<>14,"@r 999.999.999-99","@r 99.999.999/9999-99")),oFont08:oFont)

		For nX := nMensagem To nForMensagens
			_oDanfe:Say(nlinha,002,aMensagem[nX],oFont08:oFont)
			nMensagem++
			nLinha:= nLinha+ 10
		Next nX
	EndIf
	//³Finalizacao da pagina do objeto grafico                                 ³
	_oDanfe:EndPage()

Return(.T.)


Static Function ConvDate(cData)

	Local dData
	cData  := StrTran(cData,"-","")
	dData  := Stod(cData)
Return PadR(StrZero(Day(dData),2)+ "/" + StrZero(Month(dData),2)+ "/" + StrZero(Year(dData),4),15)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DANFE     ºAutor  ³Marcos Taranta      º Data ³  10/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Pega uma posição (nTam) na string cString, e retorna o      º±±
±±º          ³caractere de espaço anterior.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EspacoAt(cString, nTam)

	Local nRetorno := 0
	Local nX       := 0

	/**
	* Caso a posição (nTam) for maior que o tamanho da string, ou for um valor
	* inválido, retorna 0.
	*/
	If nTam > Len(cString) .Or. nTam < 1
		nRetorno := 0
		Return nRetorno
	EndIf

	/**
	* Procura pelo caractere de espaço anterior a posição e retorna a posição
	* dele.
	*/
	nX := nTam
	While nX > 1
		If Substr(cString, nX, 1) == " "
			nRetorno := nX
			Return nRetorno
		EndIf

		nX--
	EndDo

	/**
	* Caso não encontre nenhum caractere de espaço, é retornado 0.
	*/
	nRetorno := 0

Return nRetorno


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DANFE_V   ³ Autor ³ Luana Ferrari        ³ Data ³ 20/07/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao utilizada para verificar a ultima versao do fonte   ³±±
±±³			 ³ DANFEII..PRW aplicado no rpo do cliente, assim verificando ³±±
±±³			 ³ a necessidade de uma atualizacao neste fonte.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FAT/FIS                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

User Function DANFE_V
Local nRet := 20130417 // 17 de Abril de 2013 # Rafael Iaquinto
Return nRet
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DANFE     ºAutor  ³Fabio Santana	     º Data ³  04/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Converte caracteres espceiais						          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
STATIC FUNCTION NoChar(cString,lConverte)

	Default lConverte := .F.

	If lConverte
		cString := (StrTran(cString,"&lt;","<"))
		cString := (StrTran(cString,"&gt;",">"))
		cString := (StrTran(cString,"&amp;","&"))
		cString := (StrTran(cString,"&quot;",'"'))
		cString := (StrTran(cString,"&#39;","'"))
	EndIf

Return(cString)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DANFEIII  ºAutor  ³Microsiga           º Data ³  12/17/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tratamento para o código do item                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION MaxCod(cString,nTamanho)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para saber quantos caracteres irão caber na linha ³
	//³ visto que letras ocupam mais espaço do que os números.      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local nMax	:= 0
	Local nY   	:= 0
	Default nTamanho := 45

	For nMax := 1 to Len(cString)
		If IsAlpha(SubStr(cString,nMax,1)) .And. SubStr(cString,nMax,1) $ "MOQW"  // Caracteres que ocupam mais espaço em pixels
			nY += 7
		Else
			nY += 5
		EndIf

		If nY > nTamanho   // é o máximo de espaço para uma coluna
			nMax--
			Exit
		EndIf
	Next

Return nMax

//-----------------------------------------------------------------------
/*/{Protheus.doc} RetTamCol
Retorna um array do mesmo tamanho do array de entrada, contendo as
medidas dos maiores textos para cálculo de colunas.

@author Marcos Taranta
@since 24/05/2011
@version 1.0

@param  aCabec     Array contendo as strings de cabeçalho das colunas
aValores   Array contendo os valores que serão populados nas
colunas.
oPrinter   Objeto de impressão instanciado para utilizar o método
nativo de cálculo de tamanho de texto.
oFontCabec Objeto da fonte que será utilizada no cabeçalho.
oFont      Objeto da fonte que será utilizada na impressão.

@return aTamCol  Array contendo os tamanhos das colunas baseados nos
valores.
/*/
//-----------------------------------------------------------------------
Static Function RetTamCol(aCabec, aValores, oPrinter, oFontCabec, oFont)

	Local aTamCol    := {}
	Local nAux       := 0

	Local nX         := 0
	Local nY         := 0

	Local oFontSize	 := FWFontSize():new()

	For nX := 1 To Len(aCabec)

		AADD(aTamCol, {})
		//aTamCol[nX] := Round(oPrinter:GetTextWidth(aCabec[nX], oFontCabec) * nConsNeg + 4, 0)
		aTamCol[nX] := oFontSize:getTextWidth( alltrim(aCabec[nX]), oFontCabec:Name, oFontCabec:nWidth, oFontCabec:Bold, oFontCabec:Italic )

	Next nX

	For nX := 1 To Len(aValores[1])

		nAux := 0

		For nY := 1 To Len(aValores[1][nX])

			If (oPrinter:GetTextWidth(aValores[1][nX][nY], oFont) * nConsTex) > nAux
				//nAux := Round(oPrinter:GetTextWidth(aValores[1][nX][nY], oFont) * nConsTex + 4, 0)
				nAux := oFontSize:getTextWidth( Alltrim(aValores[1][nX][nY]), oFontCabec:Name, oFontCabec:nWidth, oFontCabec:Bold, oFontCabec:Italic )
			EndIf

		Next nY

		If aTamCol[nX] < nAux
			aTamCol[nX] := nAux
		EndIf

	Next nX

	// Checa se os campos completam a página, senão joga o resto na coluna da
	//   descrição de produtos/serviços
	nAux := 0
	For nX := 1 To Len(aTamCol)

		nAux += aTamCol[nX]

	Next nX
	If nAux < 603
		aTamCol[2] += 603 - nAux
	EndIf
	If nAux > 603
		aTamCol[2] -= nAux - 603
	EndIf

Return aTamCol

//-----------------------------------------------------------------------
/*/{Protheus.doc} RetTamTex
Retorna o tamanho em pixels de uma string. (Workaround para o GetTextWidth)

@author Marcos Taranta
@since 24/05/2011
@version 1.0

@param  cTexto   Texto a ser medido.
oFont    Objeto instanciado da fonte a ser utilizada.
oPrinter Objeto de impressão instanciado.

@return nTamanho Tamanho em pixels da string.
/*/
//-----------------------------------------------------------------------
Static Function RetTamTex(cTexto, oFont, oPrinter)

	Local nTamanho := 0
	//Local oFontSize:= FWFontSize():new()
	Local cAux := ""

	Local cValor := "0123456789"
	Local cVirgPonto := ",."
	Local cPerc := "%"
	Local nX := 0

	//nTamanho := oPrinter:GetTextWidth(cTexto, oFont)
	//nTamanho := oFontSize:getTextWidth( cTexto, oFont:Name, oFont:nWidth, oFont:Bold, oFont:Italic )
	/*O calculo abaixo é o mesmo realizado pela oFontSize:getTextWidth
	Retorna 5 para numeros (0123456789), 2 para virgula e ponto (, .) e 7 para percentual (%)
	O ajuste foi realizado para diminuir o tempo na impressão de um danfe com muitos itens*/
	For nX:= 1 to len(cTexto)
		cAux:= Substr(cTexto,nX,1)
		If cAux $ cValor
			nTamanho += 5
		ElseIf cAux $ cVirgPonto
			nTamanho += 2
		ElseIf cAux $ cPerc
			nTamanho += 7
		EndIf
	Next nX

	nTamanho := Round(nTamanho, 0)

Return nTamanho

//-----------------------------------------------------------------------
/*/{Protheus.doc} PosQuebrVal
Retorna a posição onde um valor deve ser quebrado

@author Marcos Taranta
@since 27/05/2011
@version 1.0

@param  cTexto Texto a ser medido.

@return nPos   Posição aonde o valor deve ser quebrado.
/*/
//-----------------------------------------------------------------------
Static Function PosQuebrVal(cTexto)

	Local nPos := 0

	If Empty(cTexto)
		Return 0
	EndIf

	If Len(cTexto) <= MAXVALORC
		Return Len(cTexto)
	EndIf

	If SubStr(cTexto, MAXVALORC, 1) $ ",."
		nPos := MAXVALORC - 2
	Else
		nPos := MAXVALORC
	EndIf

Return nPos

