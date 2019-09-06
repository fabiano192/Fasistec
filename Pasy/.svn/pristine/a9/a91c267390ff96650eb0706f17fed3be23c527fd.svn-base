#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ME4_COND ³ Autor ³Alexandro da Silva    ³ Data ³ 29/11/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajuste na Condicao de  Pagamento                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFAT                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

/*/

User Function ME4_COND()

_aAliOri := GetArea()
_aAliSE4 := SE4->(GetArea())
Private _aCond[6]
/*
If SC5->C5_CLIENTE == "000008"

	_nDia  := Day(dDataBase)
	
	If _nDia >= 1 .And. _nDia <= 6
		_cCond := "162"
	ElseIf _nDia >= 7  .And. _nDia <= 21
		_cCond := "163"
	ElseIf _nDia >= 22 .And. _nDia <= 31
		_cCond := "162"
	Endif
	
	dbSelectArea("SE4")
	dbSetOrder(1)
	dbSeek(xFilial("SE4")+_cCond)
	
	_aCond[1] := SE4->E4_CODIGO
	_aCond[2] := SE4->E4_COND
	_aCond[3] := SE4->E4_TIPO
	_aCond[4] := SE4->E4_DDD
	_aCond[5] := SE4->E4_IPI
	_aCond[6] := SE4->E4_SOLID

  */
/*
ElseIf SC5->C5_CLIENTE == "000071"
	_nDia  := Day(dDataBase)
	
	If _nDia >= 1 .And. _nDia <= 10
		_cCond := "201"
	ElseIf _nDia >= 11 .And. _nDia <= 20
		_cCond := "275"
	ElseIf _nDia >= 21 .And. _nDia <= 31
		_cCond := "276"
	Endif
	
	dbSelectArea("SE4")
	dbSetOrder(1)
	dbSeek(xFilial("SE4")+_cCond)

	_aCond[1] := SE4->E4_CODIGO
	_aCond[2] := SE4->E4_COND
	_aCond[3] := SE4->E4_TIPO
	_aCond[4] := SE4->E4_DDD
	_aCond[5] := SE4->E4_IPI
	_aCond[6] := SE4->E4_SOLID	*/
//Else
	dbSelectArea("SE4")
	dbSetOrder(1)
	dbSeek(xFilial("SE4")+SC5->C5_CONDPAG)
	
	_aCond[1] := SE4->E4_CODIGO
	_aCond[2] := SE4->E4_COND
	_aCond[3] := SE4->E4_TIPO
	_aCond[4] := SE4->E4_DDD
	_aCond[5] := SE4->E4_IPI
	_aCond[6] := SE4->E4_SOLID
//Endif

RestArea(_aAliSE4)
RestArea(_aAliOri)

Return(_aCond)