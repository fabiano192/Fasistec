#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ A710SQL ³ Autor ³Alexandro da Silva     ³ Data ³ 01/12/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Filtra Pedidos de Venda no Calculo do MRP.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SigaPcp                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

/*/

User Function A710SQL()

_cAlias  := PARAMIXB[1]
_cFiltro := PARAMIXB[2]

_nPos    := AT("ORDER BY",_cFiltro)

_cFiltro2:= Substr(_cFiltro,1,_nPos-1)
_cFiltro3:= Substr(_cFiltro,_nPos)

//	_cFiltro := " SELECT C6_BLQ,C6_ITEM,C6_FILIAL,C6_QTDVEN,C6_QTDENT,C6_LOCAL,C6_PRODUTO,C6_TES,C6_ENTREG,C6_NUM,C6_OP,C6_OPC,C6_REVISAO,SC6.R_E_C_N_O_ C6REC FROM SC6010 SC6 , SB1010 SB1 , SF4010 SF4 "
//	_cFiltro += " WHERE SC6.C6_FILIAL='01' AND SC6.C6_QTDENT < SC6.C6_QTDVEN AND C6_LOCAL >= '  ' AND C6_LOCAL <= 'zz' AND (C6_BLQ ='  ' OR C6_BLQ ='N ') "
//	_cFiltro += " AND SC6.D_E_L_E_T_=' ' AND SC6.C6_PRODUTO = SB1.B1_COD AND SF4.F4_FILIAL='01' AND SF4.F4_CODIGO = SC6.C6_TES AND SF4.F4_ESTOQUE = 'S' "
//	_cFiltro += " AND SF4.D_E_L_E_T_=' ' AND SB1.B1_FILIAL='01' AND SB1.B1_FANTASM <>'S' AND SB1.D_E_L_E_T_=' ' AND SB1.B1_MRP IN (' ','S') AND C6_PEDAMOS = 'N' "
//	_cFiltro += " AND C6_LOCAL <> '97' "
//	_cFiltro += " ORDER BY C6_FILIAL,C6_PRODUTO,C6_NUM,C6_ITEM "

_cCond := ""

If _cAlias     == "SB2"
	_cCond := " AND B2_LOCAL NOT IN ('80','97') "
ElseIf _cAlias == "SB6"
	_cCond := " AND B6_LOCAL NOT IN ('80','97') "
ElseIf _cAlias == "SB9"
	_cCond := " AND B9_LOCAL NOT IN ('80','97') "
ElseIf _cAlias == "SC1"
	_cCond := " AND C1_LOCAL NOT IN ('80','97') "
ElseIf _cAlias == "SC2"
	_cCond := " AND C2_LOCAL NOT IN ('80','97') "
ElseIf _cAlias == "SC4"
	_cCond := " AND C4_LOCAL NOT IN ('80','97') "
ElseIf _cAlias == "SC6"
	_cCond := " AND C6_PEDAMOS = 'N' AND C6_LOCAL NOT IN ('80','97') "
ElseIf _cAlias == "SC7"
	_cCond := " AND C7_LOCAL NOT IN ('80','97') "
ElseIf _cAlias == "SD3"
	_cCond := " AND D3_LOCAL NOT IN ('80','97') "
ElseIf _cAlias == "SD4"
	_cCond := " AND D4_LOCAL NOT IN ('80','97') "
Endif

_cFiltro := _cFiltro2+_cCond+_cFiltro3

Return(_cFiltro)