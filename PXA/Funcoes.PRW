#INCLUDE "rwmake.ch"
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


User Function CRIASX6(_aSX6)

Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local lSX6	 := .F.
Local cAlias := ''

aEstrut := {"X6_FIL","X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1","X6_DSCENG1","X6_DESC2","X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA","X6_CONTENG","X6_PROPRI"}

ProcRegua(Len(_ASX6))

dbSelectArea("SX6")
dbSetOrder(1)
For i:= 1 To Len(_ASX6)
	If !Empty(_ASX6[i][2])
		If !dbSeek("  "+_ASX6[i,2]) .And. !dbSeek(cFilAnt+_ASX6[i,2])
			lSX6	:= .T.
			If !(_ASX6[i,2]$cAlias)
				cAlias += _ASX6[i,2]+":"+_ASX6[i,4]+_ASX6[i,7]+_ASX6[i,10]+CHR(13)+CHR(10)
			EndIf
			RecLock("SX6",.T.)
			For j:=1 To Len(_ASX6[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),_ASX6[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
		EndIf
	EndIf
Next i

Return



User Function FTIPOMAIL(l1Elem)

Local cTitulo 	:=""
Local MvPar

Local MvParDef 	:=""
Local oWnd
Local cCpos			:= "M->Z0_ROTINA"
Local cVar			:= Upper( Alltrim( ReadVar() ) )

IF ( cVar $ cCpos )
	
	Private aMail:={}
	
	oWnd := GetWndDefault()
	
	cAlias := Alias() 					 // Salva Alias Anterior
	
	MvPar:=&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
	MvRet:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
	
	dbSelectArea("SX5")
	If dbSeek(cFilial+"Z0")
		cTitulo := Alltrim(Left(SX5->X5_DESCRI,20))
	Endif
	
	If dbSeek(xFilial("SX5")+"Z0")
		While !Eof() .And. SX5->X5_Tabela == "Z0"
			
			Aadd(aMail,Alltrim(SX5->X5_Descri))
			MvParDef+=Left(SX5->X5_Chave,2)
			
			SX5->(dbSkip())
		Enddo
	Endif
	
	f_Opcoes(@MvPar,cTitulo,aMail,MvParDef,12,49,l1Elem,2)  // Chama funcao f_Opcoes
	
	&MvRet := mvpar										 // Devolve Resultado
	
	dbSelectArea(cAlias) 								 // Retorna Alias
	
Endif

Return( .T. )
