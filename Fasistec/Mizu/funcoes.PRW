#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Funcoes  ³ Autor ³ Alexandro da Silva    ³ Data ³04/08/10  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao Diversas                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ IDiversos                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CRIASX6(aSX6)

Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local lSX6	 := .F.
Local cAlias := ''

cTexto  := ""
aEstrut := {"X6_FIL","X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1","X6_DSCENG1","X6_DESC2","X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA","X6_CONTENG","X6_PROPRI"}

ProcRegua(Len(ASX6))

dbSelectArea("SX6")
dbSetOrder(1)
For i:= 1 To Len(aSX6)
	If !Empty(aSX6[i][2])
		If !dbSeek("  "+aSX6[i,2]) .And. !dbSeek(cFilAnt+aSX6[i,2])
			lSX6	:= .T.
			If !(aSX6[i,2]$cAlias)
				cAlias += aSX6[i,2] //+ ":"+aSX6[i,4]+aSX6[i,7]+aSX6[i,10]+CHR(13)+CHR(10)
			EndIf
			RecLock("SX6",.T.)
			For j:=1 To Len(aSX6[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX6[i,j])
				EndIf
			Next j

			dbCommit()
			MsUnLock()
			//cTexto += "Incluido o parametro " + aSX6[i,2] + Chr(13) + Chr(10)
		//Else
		//	cTexto += "O parametro " + aSX6[i,2] + " ja existe e nao foi alterado." + Chr(13) + Chr(10)
		EndIf

	EndIf
Next i
Return

/*
User Function AfterLogin()

Local cId	:= ParamIXB[1]
Local cNome := ParamIXB[2]

ApMsgAlert("Usuário "+ cId + " - " + Alltrim(cNome)+" efetuou login às "+Time())
Return
*/

/*
User Function PSWDATE()

Local _dData := ParamIXB[1]
Local _cID   := ParamIXB[2]

ApMsgAlert("Usuário "+ _cId + " - " + Alltrim(cNome)+" efetuou login às "+Dtc(_dData))

Return
*/
/*
User Function PswSize()

Local aUsers
Local nFind
Local aReturn
Local cUser := Trim(ParamIxb[1])
Local cPsw  := Trim(ParamIxb[2])

_aUser  := {}
_aUser2 := {}

PswOrder (2)
If PswSeek(cUser)

	_aUser  := PswRet(1)
	_aUser2 := PswRet(2)
Endif

_dDtValid := _aUser[1][6]
_nDias    := _aUser[1][7]

ApMsgAlert("Usuário "+ cUser+ " Validade "+Dtoc(_dDtValid)+" NUMERO DIAS "+Alltrim(Str(_nDias)))

Return({cUser,cPsw})
*/

#include "rwmake.ch"

User Function FINALSPF()


Return(SPF_CLOSE("SIGAPSS.SPF"))

User Function GeraExcel(aExport)

Local aArea		 := GetArea()
Local aStru2	 := {}
Local ny		 := 0
Local nX         := 0
Local nz		 := 0
Local xValue     := ""
Local cBuffer    := ""
Local oExcelApp  := Nil
Local nHandle    := 0
Local aAuxRet    := {}
Local aCfgTab	 := {50}
Local aHeader	 := {}
Local aCols		 := {}
Local cTitle     := ""
Local aGets      := {}
Local aTela      := {}
Local cAuxTxt
Local aParamBox	 := {}
LOcal aRet		 := {}
Local aList
Local cGetDb
Local cTabela
Local lRet	     :=	.T.
Local lArqLocal  := ExistBlock("DIRDOCLOC")
Local nPosPrd	 := 0
Local _cDirDocs  := "\DOCS"//MsDocPath()
Local _cNomArq2  := ""

Local cPath		 := "C:\TEMP\"//AllTrim(GetTempPath())
//If !ExistDir( cPath )
//	If MakeDir( cPath ) <> 0
//		CONOUT("Impossível criar diretorio ( "+cPath+" ) - MZ0097 " )
//		Return
//	EndIf
//Endif

Private _cArquivo   := CriaTrab(,.F.)

If Type("cCadastro") == "U"
	cCadastro := ""
EndIf

If Len(aExport[1]) == 5
	_cNomArq2  := aExport[1][5]
Else
	_cNomArq2  := ""
Endif

For nz := 1 to Len(aExport)
	cAuxTxt := If(nz==1,"Selecione os dados :","")
	Do Case
		Case aExport[nz,1] == "CABECALHO"
			aCols	:= aExport[nz,4]
			If !Empty(aCols)
				If Empty(aExport[nz,2])
					aAdd(aParamBox,{4,cAuxTxt,.T.,"Cabecalho",90,,.F.}) //
				Else
					aAdd(aParamBox,{4,cAuxTxt,.T.,AllTrim(aExport[nz,2]),90,,.F.})
				EndIf
			EndIf
		Case aExport[nz,1] == "ENCHOICE"
			If Empty(aExport[nz,2])
				aAdd(aParamBox,{4,cAuxTxt,.T.,"Campos",90,,.F.}) //
			Else
				aAdd(aParamBox,{4,cAuxTxt,.T.,AllTrim(aExport[nz,2]),90,,.F.})
			EndIf
		Case aExport[nz,1] == "GETDADOS"
			aCols	:= aExport[nz,4]
			If !Empty(aCols)
				If Empty(aExport[nz,2])
					aAdd(aParamBox,{4,cAuxTxt,.T.,"Lista de Itens",90,,.F.}) //
				Else
					aAdd(aParamBox,{4,cAuxTxt,.T.,AllTrim(aExport[nz,2]),90,,.F.})
					aAdd(aParamBox,{4,cAuxTxt,.T.,AllTrim(aExport[nz,2]),90,,.F.})
				EndIf
			EndIf
		Case aExport[nz,1] == "ARRAY"
			aList		:= aExport[nz,4]
			If !Empty(aList)
				If Empty(aExport[nz,2])
					aAdd(aParamBox,{4,cAuxTxt,.T.,"Detalhes",90,,.F.}) //
				Else
					aAdd(aParamBox,{4,cAuxTxt,.T.,AllTrim(aExport[nz,2]),90,,.F.})
				EndIf
			EndIf
		Case aExport[nz,1] == "GETDB"
			If Empty(aExport[nz,2])
				aAdd(aParamBox,{4,cAuxTxt,.T.,"Lista de Itens",90,,.F.}) //
			Else
				aAdd(aParamBox,{4,cAuxTxt,.T.,AllTrim(aExport[nz,2]),90,,.F.})
			EndIf
		Case aExport[nz,1] == "TABELA"
			If Empty(aExport[nz,2])
				aAdd(aParamBox,{4,cAuxTxt,.T.,"Lista de Itens",90,,.F.}) //
			Else
				aAdd(aParamBox,{4,cAuxTxt,.T.,AllTrim(aExport[nz,2]),90,,.F.})
			EndIf
	EndCase
Next nz

SAVEINTER()

If Len(aExport)==1 .Or. ParamBox(aParamBox,"Exportar para MS-Excel",aRet,,,,,,,,.F.)  //
	// gera o arquivo em formato .CSV
	_cArquivo += ".CSV"

	If !Empty(_cNomArq2)
		nHandle := FCreate(_cNomarq2)
	ElseIf lArqLocal
		nHandle := FCreate(cPath + "\" + _cArquivo)
	Else
		nHandle := FCreate(_cDirDocs + "\" + _cArquivo)
	Endif

	If nHandle == -1
		MsgStop("Erro na criacao do arquivo na estacao local. Contate o administrador do sistema") //
		CONOUT("Erro na criacao do arquivo na estacao local. Contate o administrador do sistema") //
		RESTINTER()
		Return
	EndIf

	For nz := 1 to Len(aExport)
		If Len(aExport)>1 .And. !aRet[nz]
			Loop
		EndIf
		Do Case
			Case aExport[nz,1] == "CABECALHO"
				cBuffer := AllTrim(cCadastro)
				FWrite(nHandle, cBuffer)
				FWrite(nHandle, CRLF)
				FWrite(nHandle, CRLF)
				cBuffer	:= ""
				aHeader	:= aExport[nz,3]
				aCols	:= aExport[nz,4]
				If !Empty(aCols)
					cBuffer := AllTrim(aExport[nz,2]	)
					FWrite(nHandle, cBuffer)
					FWrite(nHandle, CRLF)
					FWrite(nHandle, CRLF)
					cBuffer	:= ""
					For nx := 1 To Len(aHeader)
						If nx == Len(aHeader)
							cBuffer += ToXlsFormat(aHeader[nx])
						Else
							cBuffer += ToXlsFormat(aHeader[nx]) + ";"
						EndIf
					Next nx
					FWrite(nHandle, cBuffer)
					FWrite(nHandle, CRLF)
					cBuffer	:= ""
					For nx := 1 To Len(aCols)
						If nx == Len(aCols)
							cBuffer += ToXlsFormat(aCols[nx])
						Else
							cBuffer += ToXlsFormat(aCols[nx]) + ";"
						EndIf
					Next nx
					FWrite(nHandle, cBuffer)
					FWrite(nHandle, CRLF)
					FWrite(nHandle, CRLF)
				EndIf
			Case aExport[nz,1] == "ENCHOICE"
				cBuffer := AllTrim(cCadastro)
				FWrite(nHandle, cBuffer)
				FWrite(nHandle, CRLF)
				FWrite(nHandle, CRLF)
				cBuffer := AllTrim(aExport[nz,2]	)
				FWrite(nHandle, cBuffer)
				FWrite(nHandle, CRLF)
				FWrite(nHandle, CRLF)
				cBuffer	:= ""
				aGets := aExport[nz,3]
				aTela := aExport[nz,3]
				For nx := 1 to Len(aGets)
					dbSelectArea("SX3")
					dbSetOrder(2)
					dbSeek(Substr(aGets[nx],9,10))
					If nx == Len(aGets)
						cBuffer += ToXlsFormat(Alltrim(X3TITULO()))
					Else
						cBuffer += ToXlsFormat(Alltrim(X3TITULO())) + ";"
					EndIf
				Next nx
				FWrite(nHandle, cBuffer)
				FWrite(nHandle, CRLF)
				cBuffer := ""
				For nx := 1 to Len(aGets)
					If nx == Len(aGets)
						cBuffer += ToXlsFormat(  &("M->"+AllTrim(Substr(aGets[nx],9,10))), Substr(aGets[nx],9,10) )
					Else
						cBuffer += ToXlsFormat( &("M->"+AllTrim(Substr(aGets[nx],9,10))) ,Substr(aGets[nx],9,10) ) + ";"
					EndIf
				Next nx
				FWrite(nHandle, cBuffer)
				FWrite(nHandle, CRLF)
				FWrite(nHandle, CRLF)
				cBuffer := ""
			Case aExport[nz,1] == "GETDADOS"
				cBuffer	:= ""
				aHeader	:= aExport[nz,3]
				aCols		:= aExport[nz,4]
				nPosPrd := aScan(aHeader, {|x| Alltrim(x[2]) $ "C1_PRODUTO*C7_PRODUTO"})
				If !Empty(aCols)
					cBuffer := AllTrim(aExport[nz,2]	)
					FWrite(nHandle, cBuffer)
					FWrite(nHandle, CRLF)
					FWrite(nHandle, CRLF)
					cBuffer	:= ""
					For nx := 1 To Len(aHeader)
						If nx == Len(aHeader)
							cBuffer += ToXlsFormat(Alltrim(aHeader[nx,1]))
						Else
							cBuffer += ToXlsFormat(Alltrim(aHeader[nx,1])) + ";"
						EndIf
					Next nx
					FWrite(nHandle, cBuffer)
					FWrite(nHandle, CRLF)
					cBuffer := ""
					For nx := 1 to Len(aCols)
						If Valtype(aCols[nx][Len(aCols[nx])]) # "L" .Or. (Valtype(aCols[nx][Len(aCols[nx])]) == "L" .And. !aCols[nx][Len(aCols[nx])])
							For ny := 1 to Len(aCols[nx])-1
								If ny == Len(aCols[nx])-1
									cBuffer += ToXlsFormat(aCols[nx,ny],aHeader[ny,2])
								ElseIf nPosPrd > 0 .And. ny == nPosPrd
									cBuffer += "=" + ToXlsFormat(aCols[nx,ny],aHeader[ny,2]) + ";"
								Else
									If aHeader[ny,2] == "C"
										cBuffer += "=" + ToXlsFormat(aCols[nx,ny],aHeader[ny,2]) + ";"
									Else
										cBuffer += ToXlsFormat(aCols[nx,ny],aHeader[ny,2]) + ";"
									Endif
								EndIf
							Next ny
							FWrite(nHandle, cBuffer)
							FWrite(nHandle, CRLF)
							cBuffer := ""
						EndIf
					Next nx
					FWrite(nHandle, CRLF)
				EndIf
			Case aExport[nz,1] == "ARRAY"
				cBuffer := AllTrim(cCadastro)
				FWrite(nHandle, cBuffer)
				FWrite(nHandle, CRLF)
				FWrite(nHandle, CRLF)
				cBuffer	:= ""
				aHeader	:= aExport[nz,3]
				aList		:= aExport[nz,4]
				If !Empty(aList)
					cBuffer := AllTrim(aExport[nz,2]	)
					FWrite(nHandle, cBuffer)
					FWrite(nHandle, CRLF)
					FWrite(nHandle, CRLF)
					cBuffer	:= ""
					For nx := 1 To Len(aHeader)
						If nx == Len(aHeader)
							cBuffer += ToXlsFormat(Alltrim(aHeader[nx]))
						Else
							cBuffer += ToXlsFormat(Alltrim(aHeader[nx])) + ";"
						EndIf
					Next nx
					FWrite(nHandle, cBuffer)
					FWrite(nHandle, CRLF)
					cBuffer := ""
					For nx := 1 to Len(aList)
						For ny := 1 to Len(aList[nx])
							If ny == Len(aList[nx])
								cBuffer += ToXlsFormat(aList[nx,ny])
							Else
								cBuffer += ToXlsFormat(aList[nx,ny]) + ";"
							EndIf
						Next ny
						FWrite(nHandle, cBuffer)
						FWrite(nHandle, CRLF)
						cBuffer := ""
					Next nx
					FWrite(nHandle, CRLF)
				EndIf
			Case aExport[nz,1] == "GETDB"
				cBuffer	:= ""
				aHeader	:= aExport[nz,3]
				cGetDb	:= aExport[nz,4]
				cBuffer := AllTrim(aExport[nz,2]	)
				FWrite(nHandle, cBuffer)
				FWrite(nHandle, CRLF)
				FWrite(nHandle, CRLF)
				cBuffer	:= ""
				For nx := 1 To Len(aHeader)
					If nx == Len(aHeader)
						cBuffer += ToXlsFormat(Alltrim(aHeader[nx,1]))
					Else
						cBuffer += ToXlsFormat(Alltrim(aHeader[nx,1])) + ";"
					EndIf
				Next nx
				FWrite(nHandle, cBuffer)
				FWrite(nHandle, CRLF)
				cBuffer := ""
				dbSelectArea(cGetDb)
				aAuxArea	:= GetArea()
				dbGotop()
				While !Eof()
					For nx := 1 to Len(aHeader)
						If nx == Len(aHeader)
							cBuffer += ToXlsFormat(FieldGet(FieldPos(AllTrim(aHeader[nx,2]))),AllTrim(aHeader[nx,2]))
						Else
							cBuffer += ToXlsFormat(FieldGet(FieldPos(AllTrim(aHeader[nx,2]))),AllTrim(aHeader[nx,2]))+";"
						EndIf
					Next
					FWrite(nHandle, cBuffer)
					FWrite(nHandle, CRLF)
					cBuffer := ""
					dbSkip()
				End
				FWrite(nHandle, CRLF)
				RestArea(aAuxArea)
			Case aExport[nz,1] == "TABELA"
				if !ParamBox( { { 1,"STR0051" ,50,"@E 99999" 	 ,""  ,""    ,"" ,30 ,.T. } }, "STR0052", aCfgTab ,,,,,,,,.F.)
					RESTINTER()
					Return
				endif
				cBuffer	:= ""
				aHeader	:= aExport[nz,3]
				cTabela	:= aExport[nz,4]
				cBuffer := AllTrim(aExport[nz,2]	)
				FWrite(nHandle, cBuffer)
				FWrite(nHandle, CRLF)
				FWrite(nHandle, CRLF)
				cBuffer	:= ""
				For nx := 1 To Len(aHeader)
					//	If aHeader[nx,3]
					If nx == Len(aHeader)
						cBuffer += ToXlsFormat(Alltrim(aHeader[nx,1]))
					Else
						cBuffer += ToXlsFormat(Alltrim(aHeader[nx,1])) + ";"
					EndIf
					//	EndIf
				Next nx
				FWrite(nHandle, cBuffer)
				FWrite(nHandle, CRLF)
				cBuffer := ""
				dbSelectArea(cTabela)
				aAuxArea	:= GetArea()
				While !Eof() .And. aCfgTab[1] > 0
					For nx := 1 to Len(aHeader)
						//	If aHeader[nx,3]
						If nx == Len(aHeader)
							cBuffer += ToXlsFormat(FieldGet(FieldPos(AllTrim(aHeader[nx,2]))),AllTrim(aHeader[nx,2]))
						Else
							cBuffer += ToXlsFormat(FieldGet(FieldPos(AllTrim(aHeader[nx,2]))),AllTrim(aHeader[nx,2]))+";"
						EndIf
						//	EndIf
					Next
					FWrite(nHandle, cBuffer)
					FWrite(nHandle, CRLF)
					cBuffer := ""
					dbSkip()
					aCfgTab[1]--
				End
				FWrite(nHandle, CRLF)
				RestArea(aAuxArea)
		EndCase
	Next nz

	FClose(nHandle)

	If !Empty(_cNomArq2)

		_cDir := "C:\TOTVS"

		//If !ExistDir( _cDir )
		//	If MakeDir( _cDir ) <> 0
		//		MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
		//		Return
		//	EndIf
		//EndIf

		_cArq    := _cDirDocs + "\" + _cArquivo

		//__CopyFile(_cArq,_cNomArq2)

	Else
		// copia o arquivo do servidor para o remote
		If !lArqLocal
			CpyS2T(_cDirDocs + "\" + _cArquivo, cPath, .T.)
		Endif

		If ApOleClient("MsExcel")
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open(cPath + "\" + _cArquivo)
			oExcelApp:SetVisible(.T.)
			oExcelApp:Destroy()
		Else
			MsgStop("Microsoft Excel nao instalado." + CRLF + "("+cPath+"\"+_cArquivo+")")
		EndIf
	Endif

EndIf

RESTINTER()

RestArea(aArea)

Return