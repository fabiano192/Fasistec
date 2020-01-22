//#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Funcoes   º Autor ³ Alexandro          º Data ³  10/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Diversas Funcoes                                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ContReg()

Local _nQtReg := 0
While !Eof()
	_nQtReg++
	dbSkip()
EndDo

dbGotop()

Return(_nQtReg)

User Function CONTLPAD(_cLp,_cDc)

_aAliOri := GetArea()
_cConta  := ""

If _cLp == "66601" .Or. Alltrim(_cLp) == "666"
	If _cDc == "D"   // Debito
		If Substr(SD3->D3_GRUPO,1,2) == "03"        // Materia Prima
			_cConta := "481000102"
		ElseIf Substr(SD3->D3_GRUPO,1,2) == "04"    // Embalagens
			_cConta := "481000103"
		ElseIf Substr(SD3->D3_GRUPO,1,2) == "02"    // Componetes acessorios
			_cConta := "481000104"
		Endif
	ElseIf _cDc == "C"  // Credito
		If Substr(SD3->D3_GRUPO,1,2) == "03"        // Materia Prima
			_cConta := "112030901"
		ElseIf Substr(SD3->D3_GRUPO,1,2) == "04"    // Embalagens
			_cConta := "112030903"
		ElseIf Substr(SD3->D3_GRUPO,1,2) == "02"    // Componetes acessorios
			_cConta := "112030904"
		Endif
	Endif
Endif

Return(_cConta)


User Function Saldo3(_cAlias,cCod,cLocal,cTipo,dDtIni,dDtFech)

Local cArq   := _cAlias
Local aSaldo := Array(2)

Afill(aSaldo,0)
IF cTipo=="T"
	cTipo:="E"
Endif//,cTipo)

dbSelectArea("SF4")
nRegSF4 := RecNo()
dbSelectArea(_cAlias)
dbSeek(cCod+cLocal+cTipo+Dtos(dDtIni),.T.)

dbSelectArea("TB6")
While !Eof() .And. B6_PRODUTO+B6_LOCAL+B6_TIPO+Dtos(B6_DTDIGIT) <= cCod+cLocal+cTipo+Dtos(dDtFech)
	
	_cTes := B6_TES
	dbSelectArea("SF4")
	dbSeek(cFilial+_cTes)
	If SF4->F4_ESTOQUE == "S"
		dbSelectArea(_cAlias)
		If SF4->F4_PODER3 == "R"
			aSaldo[1] += B6_QUANT
			aSaldo[2] += B6_CUSTO1
		Else
			aSaldo[1] -= B6_QUANT
			aSaldo[2] -= B6_CUSTO1
		Endif
	Endif
	
	dbSelectArea(_cAlias)
	dbSkip()
EndDo

dbSelectArea("SF4")
dbGoto(nRegSF4)
dbSelectArea(cArq)

Return( aSaldo )


User Function Calc3(_cAlias,cOrd,cCod,cClIfor,cLoja,cIdentB6,cTesB6,cTipo,dDtIni,dDtFim,_dDtDevI,_dDtDevF)

Local cArq		 := _cAlias
Local aSaldo	 := Array(2)
Local nRegF4	 := 0
Local nRegB6	:= 0
Afill(aSaldo,0)
DbSelectArea("SF4")
nRegF4:= Recno()
DbSelectArea(_cAlias)

If !Empty(cOrd )
	DbSetOrder(cOrd)
Endif
If !Empty(cIdentB6)
	DbSeek(xFilial()+cIdentB6+cCod)
Else
	DbSeek(xFilial()+cCod+cClIfor+cLoja)
EndIf

While !Eof() .And. cIdentB6+cCod == B6_IDENT+B6_PRODUTO
	If !Empty(cIdentB6) .And. cIdentB6 != B6_IDENT
		Exit
	EndIf
	_cTes := B6_TES
	DbSelectArea("SF4")
	DbSeek(xFilial()+_cTes)
	
	dbSelectArea(_cAlias)
	If SF4->F4_PODER3 == "R"
		If B6_DTDIGIT < dDtIni .Or. B6_DTDIGIT > dDtFim
			DbSelectArea(_cAlias)
			DbSkip()
			Loop
		EndIf
	Else
		If B6_DTDIGIT < _dDtDevI .Or. B6_DTDIGIT > _dDtDevF
			DbSelectArea(_cAlias)
			DbSkip()
			Loop
		EndIf
	Endif
	
	If Val(cTesB6) <= 500
		If (cTipo == "B" .And. B6_TPCF != "C") .Or. (cTipo == "N" .And. B6_TPCF != "F")
			DbSelectArea(_cAlias)
			DbSkip()
			Loop
		EndIf
	Else
		If (cTipo == "B" .And. B6_TPCF != "F") .Or. (cTipo == "N" .And. B6_TPCF != "C")
			DbSelectArea(_cAlias)
			DbSkip()
			Loop
		EndIf
	EndIf
	If SF4->F4_PODER3 == "R"
		aSaldo[1]+= B6_QUANT
		aSaldo[2]+= B6_QULIB
	ElseIf SF4->F4_PODER3 == "D"
		aSaldo[1]-= B6_QUANT
	EndIf
	DbSelectArea(_cAlias)
	DbSkip()
End
DbSelectArea("SF4")
DbGoTo(nRegF4)
DbSelectArea(_cAlias)
DbGoTo(nRegB6)

DbSelectArea(cArq)

Return(aSaldo)


User Function CancBx(cChave,_cAlias)

LOCAL lRet 	   := .F.
LOCAL cQuery   := ""
LOCAL cAlias   := ""

dbSelectArea(_cAlias)
aArea    := GetArea()

While !Eof() .and. cChave == E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO + E5_CLIFOR +E5_LOJA + E5_SEQ
	If E5_TIPODOC =="ES"
		lRet := .T.
		Exit
	EndIf
	dbSelectArea(_cAlias)
	dbSkip()
EndDo

RestArea(aArea)

Return lRet

User Function FILUSER(cFilADV)

cFilADV := Upper(cFilADV)

cFilADV := StrTran(cFilADV,".AND."," AND ")
cFilADV := StrTran(cFilADV,".OR."," OR ")
cFilADV := StrTran(cFilADV,"=="," = ")
cFilADV := StrTran(cFilADV,'"',"'")
cFilADV := StrTran(cFilADV,'$'," IN ")
cFilADV := StrTran(cFilADV,"ALLTRIM","  ")

Return(cFilADV)




User Function CRIASX1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo,nTamanho,nDecimal,nPresel,cGSC,;
cValid,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
cVar02,cDef02,cDefSpa2,cDefEng2,cCnt02,;
cVar03,cDef03,cDefSpa3,cDefEng3,cCnt03,;
cVar04,cDef04,cDefSpa4,cDefEng4,cCnt04,;
cVar05,cDef05,cDefSpa5,cDefEng5,cCnt05,;
cF3,cPyme,cGrpSxg,cHelp)


_aAliOri := GetArea()
cPyme    := Iif(cPyme   == Nil, " " , cPyme )
cF3      := Iif(cF3     == NIl, " " , cF3 )
cGrpSxg  := Iif(cGrpSxg == Nil, " " , cGrpSxg )
cCnt01   := Iif(cCnt01  == Nil, ""  , cCnt01 )
cHelp	 := If(cHelp    == Nil, ""  , cHelp)

dbSelectArea("SX1")
dbSetOrder(1)

_nTam := Len(cGrupo)
_nTam2:= Len(SX1->X1_GRUPO)

If _nTam < _nTam2
	cGrupo := cGrupo+Space(_nTam2-_nTam)
Endif



If !(dbSeek(cGrupo + cOrdem ))
	Reclock("SX1" , .T. )
	Replace X1_GRUPO   With cGrupo
	Replace X1_ORDEM   With cOrdem
	Replace X1_PERGUNT With cPergunt
	Replace X1_PERSPA  With cPerSpa
	Replace X1_PERENG  With cPerEng
	Replace X1_VARIAVL With cVar
	Replace X1_TIPO    With cTipo
	Replace X1_TAMANHO With nTamanho
	Replace X1_DECIMAL With nDecimal
	Replace X1_PRESEL  With nPresel
	Replace X1_GSC     With cGSC
	Replace X1_VALID   With cValid
	
	Replace X1_VAR01   With cVar01
	
	Replace X1_F3      With cF3
	Replace X1_GRPSXG  With cGrpSxg
	
	Replace X1_CNT01   With cCnt01
	If cGSC == "C"			// Mult Escolha
		Replace X1_DEF01   With cDef01
		Replace X1_DEFSPA1 With cDefSpa1
		Replace X1_DEFENG1 With cDefEng1
		
		Replace X1_DEF02   With cDef02
		Replace X1_DEFSPA2 With cDefSpa2
		Replace X1_DEFENG2 With cDefEng2
		
		Replace X1_DEF03   With cDef03
		Replace X1_DEFSPA3 With cDefSpa3
		Replace X1_DEFENG3 With cDefEng3
		
		Replace X1_DEF04   With cDef04
		Replace X1_DEFSPA4 With cDefSpa4
		Replace X1_DEFENG4 With cDefEng4
		
		Replace X1_DEF05   With cDef05
		Replace X1_DEFSPA5 With cDefSpa5
		Replace X1_DEFENG5 With cDefEng5
	Endif
	
	Replace X1_HELP  With cHelp
	
	MsUnlock()
Endif

RestArea(_aAliOri)

Return


User Function CRIASX6(_cFil,_cVar,_cTipo,_cDesc,_cConteud)

SX6->(dbSetOrder(1))
If !SX6->(dbSeek(_cFil + _cVar))
	SX6->(RecLock("SX6",.T.))
	SX6->X6_FIL     := _cFil
	SX6->X6_TIPO    := _cTipo
	SX6->X6_VAR     := _cVar
	SX6->X6_CONTEUD := _cConteud
	SX6->X6_DESCRIC := memoline(_cDesc,50,1)
	SX6->X6_DESC1   := memoline(_cDesc,50,2)
	SX6->X6_DESC2   := memoline(_cDesc,50,3)
	SX6->X6_PROPRI  := 'U'
	SX6->(MsUnlock())
Endif

Return



User Function FTIPOSER()

Local cTitulo:=""
Local MvPar
Local MvParDef:=""
Local oWnd

Private aCat:={}
l1Elem := .F.

oWnd := GetWndDefault()

cAlias := Alias() 					 // Salva Alias Anterior

MvPar:=&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
mvRet:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno

cTitulo := "Tipo de Serviço"

Aadd(aCat,"Por Quilo")
MvParDef+="Q"

Aadd(aCat,"Self Service")
MvParDef+="S"

Aadd(aCat,"Rodizio")
MvParDef+="R"

Aadd(aCat,"A La Carte")
MvParDef+="A"

f_Opcoes(@MvPar,cTitulo,aCat,MvParDef,12,49,l1Elem,1)  // Chama funcao f_Opcoes

&MvRet := mvpar										 // Devolve Resultado

dbSelectArea(cAlias) 								 // Retorna Alias

Return( .T. )

User Function GeraExcel(aExport)

Local aArea		 := GetArea()
Local cDirDocs   := MsDocPath()
Local aStru2	 := {}
Local cPath		 := AllTrim(GetTempPath())
Local ny		 := 0
Local nX         := 0
Local nz		 := 0
Local xValue     := ""
Local cBuffer    := ""
Local oExcelApp  := Nil
Local nHandle    := 0
Local cArquivo   := CriaTrab(,.F.)
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

If !VerSenha(170)
	Help(" ",1,"SEMPERM")
	Return
Endif

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
	cArquivo += ".CSV"
	
	If lArqLocal
		nHandle := FCreate(cPath + "\" + cArquivo)
	Else
		nHandle := FCreate(cDirDocs + "\" + cArquivo)
	Endif
	
	If nHandle == -1
		MsgStop("Erro na criacao do arquivo na estacao local. Contate o administrador do sistema") //
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
	
	// copia o arquivo do servidor para o remote
	If !lArqLocal
		CpyS2T(cDirDocs + "\" + cArquivo, cPath, .T.)
	Endif
	
	If !Empty(_cNomArq2)

		_cDir := "C:\TOTVS"

		If !ExistDir( _cDir )
			If MakeDir( _cDir ) <> 0
				MsgAlert(  "Impossível criar diretorio ( "+_cDir+" ) " )
				Return
			EndIf
		EndIf
		           
		_cArq    := cDirDocs + "\" + cArquivo
		
		//CpyS2T(_cArq, _cDir, .T.)	
		
		__CopyFile(_cArq,_cNomArq2)
	
	Else
		If ApOleClient("MsExcel")
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open(cPath + "\" + cArquivo)
			oExcelApp:SetVisible(.T.)
			oExcelApp:Destroy()
		Else
			MsgStop("Microsoft Excel nao instalado." + CRLF + "("+cPath+"\"+cArquivo+")")
		EndIf
	Endif
	
EndIf

RESTINTER()

RestArea(aArea)

Return

User Function ASSELEMP()

Local cTitulo := ""
Local MvParDef:= ""
Local MvPar	  := ""
Local oWnd,AX,nReg

_aAliOri:= GetArea()
_aAliSM0:= SM0->(GetArea())

Private _aEmp:= {}

l1Elem      := .f.
oWnd        := GetWndDefault()
cAlias      := Alias()

lMultSelect := .T.
lComboBox   := .F.
cCampo      := ""
lOrdena     := .T.
lPesq       := .T.
nTamElem    := 2

cTitulo     := "Selecao de Empresas"
//_aEmpresa   := {"01","02","04","05","06","09","13","16","50","80"} 
_aEmpresa   := {"04","05","06","08","13","16","50","80"}

_nCont      := 0

For AX:= 1 To Len(_aEmpresa)
	
	_cEmpresa := _aEmpresa[AX]
	
	SM0->(dbSetOrder(1))
	If SM0->(dbSeek(_cEmpresa))
		
		Aadd(_aEmp,Alltrim(SM0->M0_NOME),Transform(SM0->M0_CGC,PesqPict("SA1","A1_CGC")))
		MvParDef+=Substr(SM0->M0_CODIGO,1,2)
		
		_nCont    ++
		_cChavSM0 := SM0->M0_CODIGO
		
		While SM0->(!Eof()) .And. _cChavSM0 == SM0->M0_CODIGO
			
			SM0->(dbSkip())
		EndDo
	Endif
Next AX

_aEmp2 := {}

If f_Opcoes (@MvPar,cTitulo,_aEmp,MvParDef,12,49,.F.,nTamElem,Len(_aEmp) ,.T.,lComboBox,cCampo,lOrdena,lPesq)
	nSit := 1
	For nReg := 1 To len(mvpar) Step nTamElem
		If SubSTR(mvpar, nReg, nTamElem) <> Replicate("*",nTamElem)
			AADD(_aEmp2, SubSTR(mvpar, nReg, nTamElem) )
		Endif
		nSit++
	Next
	
	If Empty(_aEmp2)
		Help(" ",1,"ADMFILIAL",,"Por favor selecionar pelo menos uma Empresa",1,0)
	EndIF
	
	If Len(_aEmp) == Len(_aEmp2)
		lTodasFil := .T.
	EndIf
	
Endif

RestArea(_aAliSM0)
RestArea(_aAliOri)

Return(_aEmp2)

User Function ASSELFIL()

Local cTitulo := ""
Local MvParDef:= ""
Local MvPar	  := ""
Local oWnd,nReg

_aAliOri:= GetArea()
_aAliSM0:= SM0->(GetArea())

Private _aEmp:= {}

l1Elem      := .f.
oWnd        := GetWndDefault()
cAlias      := Alias()

lMultSelect := .T.
lComboBox   := .F.
cCampo      := ""
lOrdena     := .T.
lPesq       := .T.
nTamElem    := 2

cTitulo     := "Selecao de Empresas"
_cEmpresa   := aSelEmp[1]

SM0->(dbSetOrder(1))
If SM0->(dbSeek(_cEmpresa))
	
	_cChavSM0 := SM0->M0_CODIGO
	
	While SM0->(!Eof()) .And. _cChavSM0 == SM0->M0_CODIGO
		
		Aadd(_aEmp,Alltrim(SM0->M0_FILIAL),Transform(SM0->M0_CGC,PesqPict("SA1","A1_CGC")))
		MvParDef+=Substr(SM0->M0_CODFIL,1,2)
		
		SM0->(dbSkip())
	EndDo
Endif

_aEmp2 := {}

If f_Opcoes (@MvPar,cTitulo,_aEmp,MvParDef,12,49,.F.,nTamElem,Len(_aEmp) ,.T.,lComboBox,cCampo,lOrdena,lPesq)
	nSit := 1
	For nReg := 1 To len(mvpar) Step nTamElem
		If SubSTR(mvpar, nReg, nTamElem) <> Replicate("*",nTamElem)
			AADD(_aEmp2, SubSTR(mvpar, nReg, nTamElem) )
		Endif
		nSit++
	Next
	
	If Empty(_aEmp2)
		Help(" ",1,"ADMFILIAL",,"Por favor selecionar pelo menos uma Empresa",1,0)
	EndIF
	
	If Len(_aEmp) == Len(_aEmp2)
		lTodasFil := .T.
	EndIf
	
Endif

RestArea(_aAliSM0)
RestArea(_aAliOri)

Return(_aEmp2)

User Function FINALSPF()


Return(SPF_CLOSE("SIGAPSS.SPF"))