#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT250TOK   º Autor ³ Fabiano da Silva º Data ³   01/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrda Para Lançamento de Produção SD3            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaEST                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT250TOK()

_aAliori := GetArea()
_aAliSD3 := SD3->(GetArea())
_aAliSZ6 := SZ6->(GetArea())
_aAliSZA := SZA->(GetArea())
_cRet := .T.

If M->D3_LOCAL $ "98"
	If Empty(M->D3_OPERACA) .Or. Empty(M->D3_OPPRENSA)
		Alert("Campo Operador de Prensa ou Operador de Acabamento em Branco")
		_cRet := .F.
	Endif
ElseIf M->D3_LOCAL == "20" .Or. M->D3_LOCAL == "25"
	If M->D3_COD = "YPRODU"
		If (Empty(M->D3_RECURSO) .Or. Empty(M->D3_OCORR) .Or.;
			(M->D3_HORINIC = 0 .And. M->D3_HORFINA = 0))
			Alert("Campo - PRENSA / OCORRENCIA / INICIO / FIM - em Branco")
			_cRet := .F.
		ElseIf !Empty(M->D3_OP)
			Alert("Campo - OP não pode ser preenchido para o produto YPRODU")
			_cRet := .F.		
		Endif	
	Else
		If (Empty(M->D3_RECURSO) .Or. Empty(M->D3_TURNO) .Or. Empty(M->D3_NUMCAV) .Or.;
			M->D3_CICLO = 0) .And. (M->D3_HREXINI = 0 .And. M->D3_HREXFIM = 0)
			Alert("Campo - PRENSA / TURNO / NR CAVIDADE / CICLO - em Branco")
			_cRet := .F.
		ElseIf !Empty(M->D3_TURNO) .And. M->D3_HREXINI != 0 .And. M->D3_HREXFIM != 0
			Alert("Para inclusao de Hora Extra nao e necessario colocar o Turno")
			_cRet := .F.
		ElseIf (Empty(M->D3_RECURSO) .Or. Empty(M->D3_NUMCAV) .Or.;
			M->D3_CICLO = 0) .And. (M->D3_HREXINI != 0 .And. M->D3_HREXFIM != 0) .And. Empty(M->D3_TURNO)
			Alert("Campo - PRENSA / NR CAVIDADE / CICLO - em Branco")
			_cRet := .F.
		ElseIf Empty(M->D3_OPPRENSA)
			If !M->D3_OCORR $ "010   /011   "
				Alert("Campo - OPERADOR DE PRENSA - em Branco")
				_cRet := .F.
			Endif
		Endif
	Endif
Endif

dbSelectArea("SZ6")
dbSetOrder(1)
If dbSeek(xFilial("SZ6")+M->D3_OPPRENS)
	If SZ6->Z6_ATIVO = "2"
		Alert("Cadastro de Prensista Inativo")
		_cRet := .F.
	Endif
Endif

dbSelectArea("SZA")
dbSetOrder(1)
If dbSeek(xFilial("SZA")+M->D3_TURNO)
	If SZA->ZA_ATIVO = "2"
		Alert("Cadastro de Turno Inativo")
		_cRet := .F.
	Endif
Endif

If Len(M->D3_NUMCAV) != 3
	Alert("Numero de Cavidades deve conter 03 digitos")
	_cRet := .F.
Endif

RestArea(_aAliSZA)
RestArea(_aAliSZ6)
RestArea(_aAliSD3)
RestArea(_aAliOri)

Return(_cRet)
