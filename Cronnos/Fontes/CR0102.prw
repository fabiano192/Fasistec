#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} CR0102
//Validar o número da NF digitada
@author Fabiano
@since 18/09/2017
@version undefined
@type function
/*/
User Function CR0102()

	Local nX

	If dDataBase < cTod("01/10/2017")
		Return(.T.)
	Endif

	If ValType(cNFiscal)=="C"
		cNFiscal := AllTrim(cNFiscal)
		For nX := 1 To Len(cNFiscal)
			If !(SubStr(cNFiscal, nX, 1) $ "0123456789")
				Return(.F.)
			EndIf
		Next

		cNFiscal := If(!Empty(cNFiscal),PadL(Alltrim(cNFiscal),9,"0"),Space(TamSX3("F1_DOC")[1]))
	EndIf

Return(.T.)
