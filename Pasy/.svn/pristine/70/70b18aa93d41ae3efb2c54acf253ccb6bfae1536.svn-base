#include "rwmake.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±                     
±±³Fun‡…o    ³          ³ Autor ³ Alexandro da Silva    ³ Data ³ 30/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pontos de Entrada do Modulo Financeiro.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN -                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SACI008()

_aAliOri := GetArea()
_aAliSA1 := SA1->(GetArea())
_aAliSA2 := SA2->(GetArea())
_aAliSA3 := SA3->(GetArea())
_aAliSA6 := SA6->(GetArea())
_aAliSE1 := SE1->(GetArea())
_aAliSE5 := SE5->(GetArea())

//MSGINFO("PONTO SACI008!!!")
_lSair    := .F.
_cFornece := Space(06)
_cLoja    := Space(02)

If SE1->E1_SITUACA = "0" 
	SA6->(dbSetOrder(1))
	IF SA6->(dbSeek(xFilial("SA6")+SE1->E1_BCOBOR + SE1->E1_AGEBOR + SE1->E1_CTABOR))
		If !Empty(SA6->A6_CGC)
			SA2->(dbSetOrder(3))
			IF SA2->(dbSeek(xFilial("SA2")+SA6->A6_CGC))
				_cFornece := SA2->A2_COD
				_cLoja    := SA2->A2_LOJA
			Else
				_lSair := .T.
			Endif
		Else
			_lSair := .T.
		Endif
	Else
		_lSair := .T.
	Endif                         

ElseIf !SE1->E1_SITUACA = "0/1" .And. SE1->E1_PORTADO <> cBanco
	SA6->(dbSetOrder(1))
	IF SA6->(dbSeek(xFilial("SA6")+SE1->E1_PORTADO + SE1->E1_AGEDEP + SE1->E1_CONTA))
		If !Empty(SA6->A6_CGC)
			SA2->(dbSetOrder(3))
			IF SA2->(dbSeek(xFilial("SA2")+SA6->A6_CGC))
				_cFornece := SA2->A2_COD
				_cLoja    := SA2->A2_LOJA
			Else
				_lSair := .T.
			Endif
		Else
			_lSair := .T.
		Endif
	Else
		_lSair := .T.
	Endif
Else
	_lSair := .T.
Endif

If !_lSair
	
	aVetor := {}
	
	lMsErroAuto := .F.
	
	If SE1->E1_VENCREA < dDataBase
		_dVencto := dDataBase
	Else
		_dVencto := SE1->E1_VENCREA
	Endif
	
	aVetor 		:={	{"E2_PREFIXO"   	,SE1->E1_PREFIXO,Nil},;
	{"E2_NUM"		,SE1->E1_NUM    ,Nil},;
	{"E2_PARCELA"	,SE1->E1_PARCELA,Nil},;
	{"E2_TIPO"		,'TDF'          ,Nil},;
	{"E2_FORNECE"	,_cFornece      ,Nil},;
	{"E2_LOJA"		,_cLoja         ,Nil},;
	{"E2_EMISSAO"	,dDataBase      ,NIL},;
	{"E2_VENCTO"	,_dVencto       ,NIL},;
	{"E2_VENCREA"	,_dVencto       ,NIL},;
	{"E2_VALOR"		,SE1->E1_VALOR  ,Nil}}
	
	MSExecAuto({|x,y,z| Fina050(x,y,z)},aVetor,,3)
	
	If lMsErroAuto
		MostraErro()
	Endif
	
Endif
RestArea(_aAliSE5)
RestArea(_aAliSE1)
RestArea(_aAliSA6)
RestArea(_aAliSA3)
RestArea(_aAliSA2)
RestArea(_aAliSA1)
RestArea(_aAliOri)

Return


User Function FA070CAN()

_aAliOri := GetArea()
_aAliSA1 := SA1->(GetArea())
_aAliSA2 := SA2->(GetArea())
_aAliSA3 := SA3->(GetArea())
_aAliSA6 := SA6->(GetArea())
_aAliSE1 := SE1->(GetArea())
_aAliSE5 := SE5->(GetArea())

//MSGINFO("PONTO FA070CAN!!!")
_lSair := .F.

SA6->(dbSetOrder(1))
IF SA6->(dbSeek(xFilial("SA6")+SE1->E1_BCOBOR + SE1->E1_AGEBOR + SE1->E1_CTABOR))
	If !Empty(SA6->A6_CGC)
		SA2->(dbSetOrder(3))
		IF SA2->(dbSeek(xFilial("SA2")+SA6->A6_CGC))
			_cFornece := SA2->A2_COD
			_cLoja    := SA2->A2_LOJA
			
			SE2->(dbSetOrder(1))
			If SE2->(dbSeek(xFilial("SE2")+SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA +"TDF"+_cFornece + _cLoja))
				
				aVetor := {}
				
				lMsErroAuto := .F.
				
				aVetor 		:={	{"E2_PREFIXO"   ,SE1->E1_PREFIXO,Nil},;
				{"E2_NUM"		,SE1->E1_NUM    ,Nil},;
				{"E2_PARCELA"	,SE1->E1_PARCELA,Nil},;
				{"E2_TIPO"		,'TDF'          ,Nil},;
				{"E2_FORNECE"	,SA2->A2_COD    ,Nil},;
				{"E2_LOJA"		,SA2->A2_LOJA   ,Nil}}
				
				MSExecAuto({|x,y,z| Fina050(x,y,z)},aVetor,,5)
				
				If lMsErroAuto
					MostraErro()
				Endif
			Endif
		Endif
	Endif
Endif
RestArea(_aAliSE5)
RestArea(_aAliSE1)
RestArea(_aAliSA6)
RestArea(_aAliSA3)
RestArea(_aAliSA2)
RestArea(_aAliSA1)
RestArea(_aAliOri)

Return

User Function FA070CA3()

_aAliOri := GetArea()
_aAliSA1 := SA1->(GetArea())
_aAliSA2 := SA2->(GetArea())
_aAliSA3 := SA3->(GetArea())
_aAliSA6 := SA6->(GetArea())
_aAliSE1 := SE1->(GetArea())
_aAliSE5 := SE5->(GetArea())

//MSGINFO("PONTO FA070CA3!!!")
_lRet := .T.

SA6->(dbSetOrder(1))
IF SA6->(dbSeek(xFilial("SA6")+SE1->E1_BCOBOR + SE1->E1_AGEBOR + SE1->E1_CTABOR))
	If !Empty(SA6->A6_CGC)
		SA2->(dbSetOrder(3))
		IF SA2->(dbSeek(xFilial("SA2")+SA6->A6_CGC))
			_cFornece := SA2->A2_COD
			_cLoja    := SA2->A2_LOJA
			
			SE2->(dbSetOrder(1))
			If SE2->(dbSeek(xFilial("SE2")+SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA +"TDF"+_cFornece + _cLoja))
				
				If SE2->E2_SALDO <> SE1->E1_VALOR
					MSGSTOP("BAIXA NAO PODE SER CANCELADA, FAVOR EXCLUIR A BAIXA NO CONTAS A PAGAR!!")
					_lRet := .F.
				Endif
			Endif
		Endif
	Endif
Endif
RestArea(_aAliSE5)
RestArea(_aAliSE1)
RestArea(_aAliSA6)
RestArea(_aAliSA3)
RestArea(_aAliSA2)
RestArea(_aAliSA1)
RestArea(_aAliOri)

Return(_lRet)



User Function FA60BDE()

_aAliOri := GetArea()
                  
SE1->(RecLock("SE1",.F.))
SE1->E1_BCOBOR := SE1->E1_PORTADO
SE1->E1_AGEBOR := SE1->E1_AGEDEP
SE1->E1_CTABOR := SE1->E1_CONTA
SE1->(MsUnlock())

RestArea(_aAliOri)

Return
      

User Function F060ACT()

_aAliOri := GetArea()

If SE1->E1_SITUACA != "0"
	SE1->(RecLock("SE1",.F.))
	SE1->E1_BCOBOR := SE1->E1_PORTADO
	SE1->E1_AGEBOR := SE1->E1_AGEDEP
	SE1->E1_CTABOR := SE1->E1_CONTA
	SE1->(MsUnlock())
Endif

RestArea(_aAliOri)

Return