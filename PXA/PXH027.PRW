#Include "rwmake.ch"
#Include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ BRI009   ³ Autor ³Alexandro da Silva     ³ Data ³ 03/07/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ CNAB A PAGAR - PAGFOR                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINANCEIRO                   -                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PGFOR001()

If  len(alltrim(SA2->A2_CGC)) == 14
	cCampo := "0" + SA2->A2_CGC
Else
	cCampo := subs(SA2->A2_CGC,1,9) + "0000" + subs(SA2->A2_CGC,10,2)
Endif

Return(cCampo)


User Function PGFOR002()

_CTACED := "0000000000000"

IF Substr(SE2->E2_CODBAR,1,3) == "237"
	_Ctaced  :=  STRZERO(VAL(SUBSTR(SE2->E2_CODBAR,37,7)),13,0)
ElseIf SUBSTR(SE2->E2_XLINDIG,1,3) == "237"
	
	_Ctaced  :=  STRZERO(VAL(SUBSTR(SE2->E2_XLINDIG,24,7)),13,0)
ElseIf !Empty(SE2->E2_XCONTA)
	
	_Ctaced  :=  STRZERO(VAL(SE2->E2_XCONTA),13,0)
EndIf

Return(_Ctaced)


User Function PGFOR003() //Pagcep()

SetPrvt("CALIAS,_CEP,")

cALIAS  :=  Alias()

_CEP  :=  STRZERO(VAL(SUBSTR(SA2->A2_CEP,1,5)),5,0)+STRZERO(VAL(SUBSTR(SA2->A2_CEP,6,3)),5,0)

Return(_CEP)

User Function PGFOR004() //Pagban()

SetPrvt("_BANCO,")

_BANCO := "000"

IF !EMPTY(SUBSTR(SE2->E2_CODBAR,1,3))
	_BANCO  :=  SUBSTR(SE2->E2_CODBAR,1,3)
ElseIf !EMPTY(SUBSTR(SE2->E2_XLINDIG,1,3))
	_BANCO  :=  SUBSTR(SE2->E2_XLINDIG,1,3)
ElseIf Empty(SE2->E2_CODBAR)
	_BANCO  :=  SE2->E2_XBANCO
EndIf

Return(_BANCO)


User Function PGFOR005() //Pagagen()

SetPrvt("_AGENCIA,")

_Agencia  :=  "00000"

If SubStr(SE2->E2_CODBAR,1,3) == "237"
	
	_Agencia  :=  StrZero(Val(SubStr(SE2->E2_CODBAR,20,4)),5)
	
ElseIf SUBSTR(SE2->E2_XLINDIG,1,3) == "237"
	
	_Agencia  :=  StrZero(Val(SubStr(SE2->E2_XLINDIG,05,4)),5)
	
ElseIf Empty(SE2->E2_CODBAR)
	If !Empty(SE2->E2_XAGEN)
		_Agencia  := StrZero(Val(SE2->E2_XAGEN),5)
	Endif
EndIf

Return(_Agencia)


User Function PGFOR006() //Pagdgag()

_RETDIG  := "0"

IF SUBSTR(SE2->E2_CODBAR,1,3) == "237"
	
	_RETDIG := " "
	_DIG1   := SUBSTR(SE2->E2_CODBAR,20,1)
	_DIG2   := SUBSTR(SE2->E2_CODBAR,21,1)
	_DIG3   := SUBSTR(SE2->E2_CODBAR,22,1)
	_DIG4   := SUBSTR(SE2->E2_CODBAR,23,1)
	
	_MULT   := (VAL(_DIG1)*5) +  (VAL(_DIG2)*4) +  (VAL(_DIG3)*3) +   (VAL(_DIG4)*2)
	_RESUL  := INT(_MULT /11 )
	_RESTO  := INT(_MULT % 11)
	_DIGITO := 11 - _RESTO
	
	_RETDIG := IF( _RESTO == 0,"0",IF(_RESTO == 1,0,_DIGITO))
	
ElseIf SUBSTR(SE2->E2_XLINDIG,1,3) == "237"
	
	_RETDIG := " "
	_DIG1   := SUBSTR(SE2->E2_XLINDIG,05,1)
	_DIG2   := SUBSTR(SE2->E2_XLINDIG,06,1)
	_DIG3   := SUBSTR(SE2->E2_XLINDIG,07,1)
	_DIG4   := SUBSTR(SE2->E2_XLINDIG,08,1)
	
	_MULT   := (VAL(_DIG1)*5) +  (VAL(_DIG2)*4) +  (VAL(_DIG3)*3) +   (VAL(_DIG4)*2)
	_RESUL  := INT(_MULT /11 )
	_RESTO  := INT(_MULT % 11)
	_DIGITO := 11 - _RESTO
	
	_RETDIG := IF( _RESTO == 0,"0",IF(_RESTO == 1,0,_DIGITO))
	
	
ELSEIF !EMPTY(SE2->E2_XDVAGEN)
	
	_RETDIG := AllTrim(SE2->E2_XDVAGEN)
	
ENDIF

Return(_RETDIG)


User Function PGFOR007() //Pagdgct()

_RETDIG := "00"

IF SUBSTR(SE2->E2_CODBAR,1,3) == "237"
	
	_RETDIG := " "
	_DIG1   := SUBSTR(SE2->E2_CODBAR,37,1)
	_DIG2   := SUBSTR(SE2->E2_CODBAR,38,1)
	_DIG3   := SUBSTR(SE2->E2_CODBAR,39,1)
	_DIG4   := SUBSTR(SE2->E2_CODBAR,40,1)
	_DIG5   := SUBSTR(SE2->E2_CODBAR,41,1)
	_DIG6   := SUBSTR(SE2->E2_CODBAR,42,1)
	_DIG7   := SUBSTR(SE2->E2_CODBAR,43,1)
	
	_MULT   := (VAL(_DIG1)*2) +  (VAL(_DIG2)*7) +  (VAL(_DIG3)*6) +   (VAL(_DIG4)*5) +  (VAL(_DIG5)*4) +  (VAL(_DIG6)*3)  + (VAL(_DIG7)*2)
	_RESUL  := INT(_MULT /11 )
	_RESTO  := INT(_MULT % 11)
	_DIGITO := STRZERO((11 - _RESTO),1,0)
	
	_RETDIG := IF( _resto == 0,"0",IF(_resto == 1,"P",_DIGITO))
	
ELSEIF SUBSTR(SE2->E2_XLINDIG,1,3) == "237"
	
	_RETDIG := " "
	_DIG1   := SUBSTR(SE2->E2_XLINDIG,24,1)
	_DIG2   := SUBSTR(SE2->E2_XLINDIG,25,1)
	_DIG3   := SUBSTR(SE2->E2_XLINDIG,26,1)
	_DIG4   := SUBSTR(SE2->E2_XLINDIG,27,1)
	_DIG5   := SUBSTR(SE2->E2_XLINDIG,28,1)
	_DIG6   := SUBSTR(SE2->E2_XLINDIG,29,1)
	_DIG7   := SUBSTR(SE2->E2_XLINDIG,30,1)
	
	_MULT   := (VAL(_DIG1)*2) +  (VAL(_DIG2)*7) +  (VAL(_DIG3)*6) +   (VAL(_DIG4)*5) +  (VAL(_DIG5)*4) +  (VAL(_DIG6)*3)  + (VAL(_DIG7)*2)
	_RESUL  := INT(_MULT /11 )
	_RESTO  := INT(_MULT % 11)
	_DIGITO := STRZERO((11 - _RESTO),1,0)
	
	_RETDIG := IF( _resto == 0,"0",IF(_resto == 1,"P",_DIGITO))
	
	//ELSEIF !Empty(Right(ALLTRIM(SE2->E2_XCONTA),1))
ELSEIF !Empty(ALLTRIM(SE2->E2_XCONTA))
	
	//_RETDIG := Right(ALLTRIM(SE2->E2_XCONTA),1)
	_RETDIG := SE2->E2_XDVCON
	
ENDIF

Return(_RETDIG)


User Function PGFOR008() //Pagcar()

SetPrvt("_RETCAR,")

_RetCar := "000"

If SubStr(SE2->E2_CODBAR,01,3) == "237"
	
	_RetCar := StrZero(Val(SubStr(SE2->E2_CODBAR,24,2)),3)
	
ElseIf SubStr(SE2->E2_XLINDIG,01,3) == "237"
	
	_RetCar := SubStr(SE2->E2_XLINDIG,09,01)+SubStr(SE2->E2_XLINDIG,11,01)
	_RetCar := StrZero(Val(_RetCar),3)
	
EndIf

Return(_Retcar)


User Function PGFOR009() //Pagano()

_RETANO  :=  "000"

If SubStr(SE2->E2_CODBAR,1,3) == "237"
	
	_RETANO  := StrZero(Val(SubStr(SE2->E2_CODBAR,26,2)),3)
	
ElseIf SubStr(SE2->E2_XLINDIG,1,3) == "237"
	
	_RETANO  := StrZero(Val(SubStr(SE2->E2_XLINDIG,12,2)),3)
	
EndIf

Return(_RETANO)


User Function PGFOR010() //Pagnos()


If SUBSTR(SE2->E2_CODBAR,1,3) == "237"
	_RETNOS := SUBS(SE2->E2_CODBAR,28,9)
ElseIf SubStr(SE2->E2_XLINDIG,1,3) == "237"
	_RETNOS := SUBS(SE2->E2_XLINDIG,14,9)
Else
	_RETNOS := "000000000"
EndIf

Return(_RETNOS)


User Function PGFOR011() //Pagseun()


_RETSEUN  :=  SE2->E2_PREFIXO + SUBSTR(SE2->E2_NUM,1,6) + SE2->E2_FORNECE

Return(_RETSEUN)


User Function PGFOR012() //Pdtdes()

_DTDES  := "      "

IF SUBSTR(SE2->E2_CODBAR,6,14) == "00000000000000" .AND. SUBSTR(SE2->E2_CODBAR,1,3) #"   "
	_DTDES := "00000000"
Else
	_DTDES := DTOS(SE2->E2_VENCREA)
Endif

Return(_DTDES)


User Function PGFOR013() //Pagval()

_Valor :="000000000000000"

IF !Empty(SE2->E2_CODBAR)
	//_Valor  := Val(SubStr(SE2->E2_CODBAR,06,14))/100 //- SE2->E2_ACRESC
	_Valor := StrZero(Val(SubStr(SE2->E2_CODBAR,06,14)),15)
	//_Valor := StrZero(_nVal * 100,15)
	//_Valor   := STRZERO((SE2->E2_SALDO) * 100,15)
ElseIf !Empty(SE2->E2_XLINDIG)
	IF Val(SubStr(SE2->E2_XLINDIG,34,14)) <> 0
		_Valor := StrZero(Val(SubStr(SE2->E2_XLINDIG,34,14)),15)
		//_nVal  := Val(SubStr(SE2->E2_XLINDIG,34,14)) / 100 - SE2->E2_ACRESC
		//_Valor := StrZero(_nVal * 100,15)
		//_Valor := STRZERO((SE2->E2_SALDO) * 100,15)
	Endif
ElseIf SE2->E2_ACRESC > 0
	_Valor := STRZERO((SE2->E2_SALDO) * 100,15)
Endif


Return(_Valor)


User Function PGFOR014() //Pagvalor()

_nValor  := SE2->E2_SALDO + SE2->E2_ACRESC - SE2->E2_DECRESC
_cValor  := STRZERO((_nValor)*100,15)
_cAlias  := Alias()

//MSUnlock()

dbSelectArea(_cAlias)

Return(_cValor)


User Function PGFOR015() //Pagdes()

_RETDES  := "               "

IF SUBSTR(SE2->E2_CODBAR,6,14) == "00000000000000" .AND. ;
	SUBSTR(SE2->E2_CODBAR,1,3) #"   "
	_RETDES := "000000000000000"
Else
	_retdes := STRZERO(SE2->E2_DECRESC*100,15)
END

Return(_RETDES)


User Function PGFOR016() //Pagmod()

/*
IF SE2->E2_XMODPGT $ "01,03"
If SE2->E2_BANCO == "237"
_aModel := "01"
Else
_aModel := "03"
Endif
Else
_aModel := SE2->E2_XMODPGT
EndIf
*/
Return(_aModel)



User Function PGFOR017() //Pagdoc()

cALIAS  :=  Alias()

_Doc  := Space(25)

If Substr(SE2->E2_XMODPGT,1,2) $ "01"
	_Doc   :=  "C00000001"+Space(31)
ElseIf SubStr(SE2->E2_XMODPGT,1,2) $ "03"
	_Doc   :=  "C00000003"+Space(31)
ElseIf SubStr(SE2->E2_XMODPGT,1,2) $ "31"
	If !Empty(SE2->E2_CODBAR)
		_Doc  :=  SUBSTR(SE2->E2_CODBAR,20,25)
	ElseIf !Empty(SE2->E2_XLINDIG)
		ExtrLinDig()
	EndIf
ElseIf SubStr(SE2->E2_XMODPGT,1,2) $ "07,08"
	//_Doc   :=  "C00000003" + IIF(SA2->A2_YTPCTA == "2","02","01")+"              "+Space(31)
	_Doc   :=  "C00000003" + "01"+"              "+Space(31)
EndIf

Return(_DOC)


Static Function ExtrLinDig()

_cLinDig := SE2->E2_XLINDIG
_cCampo1 := SubStr(_cLinDig,05,05)
_cCampo2 := SubStr(_cLinDig,11,10)
_cCampo3 := SubStr(_cLinDig,22,10)
_Doc     := _cCampo1+_cCampo2+_cCampo3

Return(nil)


User Function PGFOR018() //Pagdigv()

SetPrvt("_CDIGVER,")

_cDigVer := "0"

If !Empty(SE2->E2_CODBAR)
	_cDigVer := SubStr(SE2->E2_CODBAR,5,1)
ElseIf !Empty(SE2->E2_XLINDIG)
	_cDigVer := SubStr(SE2->E2_XLINDIG,33,1)
ElseIf Empty(SE2->E2_CODBAR)
	_cDigVer := " "
ElseIf Empty(SE2->E2_XLINDIG)
	_cDigVer := " "
Endif

Return(_cDigVer)


User Function PGFOR019() //Pagmoeda()

SetPrvt("_CMOEDA,")

_cMoeda := "0"

If !Empty(SE2->E2_CODBAR)
	_cMoeda := SubStr(SE2->E2_CODBAR,4,1)
ElseIf !Empty(SE2->E2_XLINDIG)
	_cMoeda := SubStr(SE2->E2_XLINDIG,4,1)
ElseIf Empty(SE2->E2_CODBAR)
	_cMoeda := " "
ElseIf Empty(SE2->E2_XLINDIG)
	_cMoeda := " "
Endif

Return(_cMoeda)


User Function PGFOR020() //Pagtotal()

_nValTot := SEE->EE_VALTOT
_cValTot := STRZERO((_nValTot)*100,17)
_cAlias  := Alias()

dbSelectArea("SEE")

If Reclock("SEE", .F.)
	SEE->EE_VALTOT := 0
Endif

MSUnlock()

dbSelectArea(_cAlias)

Return(_cValTot)


User Function PGFOR021() //CodBar()

If ALLTRIM(FUNNAME()) == "FINA050"
	IF VALTYPE(M->E2_CODBAR) == NIL .OR. EMPTY(M->E2_CODBAR)
		RETURN
		(.T.)
	ENDIF
	
	cStr := LTRIM(RTRIM(M->E2_CODBAR))
ElseIf ALLTRIM(FUNNAME()) == "MATA103"
	Return(.T.)
Else
	cStr := LTRIM(RTRIM(_cCodBar))
	If Empty(cStr)
		Return(.T.)
	Endif
Endif

lRet := IF(LEN(cStr)==45 .OR. LEN(cStr)==46,.F.,.T.)

cStr := IF(LEN(cStr)<44,cStr+REPL("0",47-LEN(cStr)),cStr)

// Verifica se a LD é de (B)loquetos ou (C)oncessionárias/IPTU. Se for CB retorna (I)ndefinido.
cTipo := IF(LEN(cStr)==47,"B",IF(LEN(cStr)==48,"C","I"))

// Verifica se todos os dígitos são numérios.
FOR i := LEN(cStr) TO 1 STEP -1
	lRet := IF(SUBSTR(cStr,i,1) $ "0123456789",lRet,.F.)
NEXT

IF LEN(cStr) == 47 .AND. lRet
	// Consiste os três DV´s de Bloquetos pelo Módulo 10.
	nConta  := 1
	WHILE nConta <= 3
		nMult  := 2
		nVal   := 0
		nDV    := VAL(SUBSTR(cStr,IF(nConta==1,10,IF(nConta==2,21,32)),1))
		cCampo := SUBSTR(cStr,IF(nConta==1,1,IF(nConta==2,11,22)),IF(nConta==1,9,10))
		FOR i := LEN(cCampo) TO 1 STEP -1
			nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
			nVal  := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
			nMult := IF(nMult==2,1,2)
		NEXT
		nDVCalc := 10-MOD(nVal,10)
		// Se o DV Calculado for 10 é assumido 0 (Zero).
		nDVCalc := IF(nDVCalc==10,0,nDVCalc)
		lRet    := IF(lRet,(nDVCalc==nDV),.F.)
		nConta  := nConta + 1
	ENDDO
	cStr := IF(lRet,SUBSTR(cStr,1,4)+SUBSTR(cStr,33,15)+SUBSTR(cStr,5,5)+SUBSTR(cStr,11,10)+SUBSTR(cStr,22,10),cStr)
ENDIF

IF LEN(cStr) == 48 .AND. lRet
	nConta  := 1
	WHILE nConta <= 4
		nMult  := 2
		nVal   := 0
		nDV    := VAL(SUBSTR(cStr,IF(nConta==1,12,IF(nConta==2,24,IF(nConta==3,36,48))),1))
		cCampo := SUBSTR(cStr,IF(nConta==1,1,IF(nConta==2,13,IF(nConta==3,25,37))),11)
		FOR i := 11 TO 1 STEP -1
			nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
			nVal  := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
			nMult := IF(nMult==2,1,2)
		NEXT
		nDVCalc := 10-MOD(nVal,10)
		nDVCalc := IF(nDVCalc==10,0,nDVCalc)
		lRet    := IF(lRet,(nDVCalc==nDV),.F.)
		nConta  := nConta + 1
	ENDDO
	// Se os DV´s foram consistidos com sucesso (lRet=.T.), converte o número para CB para consistir o DVG.
	cStr := IF(lRet,SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11),cStr)
ENDIF

IF LEN(cStr) == 44 .AND. lRet
	IF cTipo $ "BI"
		// Consiste o DVG do CB de Bloquetos pelo Módulo 11.
		nMult  := 2
		nVal   := 0
		nDV    := VAL(SUBSTR(cStr,5,1))
		cCampo := SUBSTR(cStr,1,4)+SUBSTR(cStr,6,39)
		FOR i := 43 TO 1 STEP -1
			nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
			nVal  := nVal + nMod
			nMult := IF(nMult==9,2,nMult+1)
		NEXT
		nDVCalc := 11-MOD(nVal,11)
		// Se o DV Calculado for 0,10 ou 11 é assumido 1 (Um).
		nDVCalc := IF(nDVCalc==0 .OR. nDVCalc==10 .OR. nDVCalc==11,1,nDVCalc)
		lRet    := IF(lRet,(nDVCalc==nDV),.F.)
		// Se o Tipo é (I)ndefinido E o DVG NÂO foi consistido com sucesso (lRet=.F.), tentará
		// consistir como CB de Título de Concessionárias/IPTU no IF abaixo.
	ENDIF
	IF cTipo == "C" .OR. (cTipo == "I" .AND. !lRet)
		// Consiste o DVG do CB de Títulos de Concessionárias pelo Módulo 10.
		lRet   := .T.
		nMult  := 2
		nVal   := 0
		nDV    := VAL(SUBSTR(cStr,4,1))
		cCampo := SUBSTR(cStr,1,3)+SUBSTR(cStr,5,40)
		FOR i := 43 TO 1 STEP -1
			nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
			nVal  := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
			nMult := IF(nMult==2,1,2)
		NEXT
		nDVCalc := 10-MOD(nVal,10)
		// Se o DV Calculado for 10 é assumido 0 (Zero).
		nDVCalc := IF(nDVCalc==10,0,nDVCalc)
		lRet    := IF(lRet,(nDVCalc==nDV),.F.)
	ENDIF
ENDIF

IF !lRet
	HELP(" ",1,"ONLYNUM")
ENDIF

RETURN(lRet)


USER FUNCTION PGFOR022()

SETPRVT("cStr")

If ALLTRIM(FUNNAME()) == "FINA050"
	cStr := LTRIM(RTRIM(M->E2_CODBAR))
	
	IF VALTYPE(M->E2_CODBAR) == NIL .OR. EMPTY(M->E2_CODBAR)
		cStr := ""
	ELSE
		cStr := IF(LEN(cStr)<44,cStr+REPL("0",47-LEN(cStr)),cStr)
	ENDIF
	
Else
	cStr := LTRIM(RTRIM(_cCodBar))
Endif

DO CASE
	CASE LEN(cStr) == 47
		cStr := SUBSTR(cStr,1,4)+SUBSTR(cStr,33,15)+SUBSTR(cStr,5,5)+SUBSTR(cStr,11,10)+SUBSTR(cStr,22,10)
	CASE LEN(cStr) == 48
		cStr := SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11)
	OTHERWISE
		cStr := cStr+SPACE(48-LEN(cStr))
ENDCASE

RETURN(cStr)