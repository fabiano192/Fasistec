#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.ch"
#INCLUDE "FONT.CH"
#INCLUDE "TBICONN.CH"

/*
Programa  : PXH028
Descrição : Tela de alteração dos dados bancários dos títulos a Pagar
Autor     : Alexandro - AsSystem
Data      : 02/06/13
*/

/*
LOCAL aAlias	:={},cSavRegua

Private _lPonto  := _lAuto <> NIL
Private _lRet    := .T.


_lAlt := .T.
SE2->(dbSetOrder(6))
SE2->(dbSeek(xFilial("SE2")+SF1->F1_FORNECE+ SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC))
//SE2->(dbSeek(xFilial("SE2")+SF1->F1_FORNECE+ SF1->F1_LOJA + SF1->F1_PREFIXO + SF1->F1_DOC))

_lGo := .T.


If _lGo

_aALiOri := GetArea()
_aAliSA2 := SA2->(GetArea())
_aAliSE2 := SE2->(GetArea())
_aAliSE4 := SE4->(GetArea())

Private aSize	  := MsAdvSize()
Private aObjects  := {}
Private aPosObj   := {}
Private aSizeAut  := MsAdvSize() // devolve o tamanho da tela atualmente no micro do usuario

AAdd( aObjects, { 100, 100, .T., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .t. } )

aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects,.T. )

cTitulo   := "Forma de Pagamento"

aRadio2   := {}
nRadio2   := 1

SX5->(dbSetOrder(1))
If SX5->(dbSeek(xFilial("SX5")+"Z8"))

_cChav := SX5->X5_TABELA

While SX5->(!Eof()) .And. 	_cChav == SX5->X5_TABELA

AADD(aRadio2,Substr(SX5->X5_DESCRI,1,20))

SX5->(dbSkip())
EndDo
Endif

_dDt  := DATE()
_lGet := .T.
_nOpc := 0

//						                       TO LINHA SUPERIOR,LINHA DIREITA
DEFINE MSDIALOG oDlg TITLE cTitulo From 10,0 to 180,210 of oMainWnd PIXEL

@ 070,010 BMPBUTTON TYPE 1  ACTION (_nOpc:=1,oDlg:END())
@ 070,050 BMPBUTTON TYPE 2  ACTION oDlg:END()

@ 005,005 TO 059,090 TITLE "Praca de Pagamento"
@ 020,010 RADIO aRadio2 VAR nRadio2

ACTIVATE MSDIALOG oDlg Centered

If _nOpc == 1

SE2->(RecLock("SE2",.F.))
SE2->E2_YPRAPG  := StrZero(nRadio2,3)
SE2->(MsUnlock())

SE2->(dbSetOrder(6))
If SE2->(dbSeek(xFilial("SE2")+SF1->F1_FORNECE+ SF1->F1_LOJA + SF1->F1_PREFIXO + SF1->F1_DOC))

_cChav    := SE2->E2_FILIAL + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM

While SE2->(!Eof()) .And.	_cChav == SE2->E2_FILIAL + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM

SE2->(RecLock("SE2",.F.))
SE2->E2_YPRAPG  := StrZero(nRadio2,3)
SE2->(MsUnlock())

SE2->(dbSkip())
EndDo
Endif
Endif
Endif

Return

Static Function MZ04_A()

//If aRadio[nRadio]
If nRadio == 2
_lAlt     := .T.
_cBanco   := SA2->A2_BANCO
_cAgencia := SA2->A2_AGENCIA
_cAgenDig := SA2->A2_DIGAG
_cConta   := SA2->A2_NUMCON
_cContaDig:= SA2->A2_DIGCTA
_cFavorec := PADR(SA2->A2_NOME,60)
Else
_lAlt     := .F.
_cBanco   := Space(03)
_cAgencia := Space(05)
_cAgenDig := Space(01)
_cConta   := Space(10)
_cContaDig:= Space(01)
_cFavorec := Space(60)
Endif

Return(_lAlt)
*/

User Function PXH028(_lAuto)

_aALiOri := GetArea()
_aAliSA2 := SA2->(GetArea())
_aAliSE2 := SE2->(GetArea())
_aAliSE4 := SE4->(GetArea())

Private aSize	  := MsAdvSize()
Private aObjects  := {}
Private aPosObj   := {}
Private aSizeAut  := MsAdvSize() // devolve o tamanho da tela atualmente no micro do usuario

AAdd( aObjects, { 100, 100, .T., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .t. } )

aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects,.T. )

SE2->(dbSetOrder(6))
SE2->(dbSeek(xFilial("SE2")+SF1->F1_FORNECE+ SF1->F1_LOJA + SF1->F1_PREFIXO + SF1->F1_DOC))

SA2->(dbSetOrder(1))
SA2->(dbSeek(xFilial("SA2")+SE2->E2_FORNECE + SE2->E2_LOJA))

cTitulo   := "Titulos do Contas a Pagar"
_cPrefixo := SE2->E2_PREFIXO
_cNumero  := SE2->E2_NUM
_cParcela := SE2->E2_PARCELA
_cFornece := SE2->E2_FORNECE
_cLoja    := SE2->E2_LOJA
_dEmissao := SE2->E2_EMISSAO
_dVencto  := SE2->E2_VENCTO
_dVencRea := SE2->E2_VENCREA
_nValor   := SE2->E2_VALOR
_cNomeFor := SA2->A2_NOME

aRadio    := {}
nRadio    := 1
aRadio2   := {}
nRadio2   := 1
      
_lAlt 	  := .t.
_lForn    := .f.
_cIPTE    := Space(47)
_cCodBar  := Space(48)
_cBanco   := SA2->A2_BANCO
_cAgencia := SA2->A2_AGENCIA
_cAgenDig := SA2->A2_DIGAG
_cConta   := SA2->A2_NUMCON
_cContaDig:= SA2->A2_DIGCTA

_cFavorec := PADR(SA2->A2_NOME,60)

If !Empty(_cBanco)
	_lForn := .T.
Endif

SX5->(dbSetOrder(1))
If SX5->(dbSeek(xFilial("SX5")+"Z9"))
	
	_cChav := SX5->X5_TABELA
	
	While SX5->(!Eof()) .And. 	_cChav == SX5->X5_TABELA
		
		AADD(aRadio,Substr(SX5->X5_DESCRI,1,20))
		
		SX5->(dbSkip())
	EndDo
Endif

SX5->(dbSetOrder(1))
If SX5->(dbSeek(xFilial("SX5")+"Z8"))
	
	_cChav := SX5->X5_TABELA
	
	While SX5->(!Eof()) .And. 	_cChav == SX5->X5_TABELA
		
		AADD(aRadio2,Substr(SX5->X5_DESCRI,1,20))
		
		SX5->(dbSkip())
	EndDo
Endif

_dDt  := DATE()
_lGet := .T.
_nOpc := 0

DEFINE MSDIALOG oDlg TITLE cTitulo From 10,0 to 390,900 of oMainWnd PIXEL

@ 05,aPosObj[2,2] TO 50,360

@ 15,010  Say "Prefixo: "
@ 15,040  GET _cPrefixo  WHEN .F. SIZE 20,20
@ 15,065  Say "Numero: "
@ 15,090 Get _cNumero   WHEN .F. SIZE 50,20
@ 15,144 Say "Parc: "
@ 15,164 GET _cParcela  WHEN .F. SIZE 20,20
@ 15,190 Say "Fornecedor: "
@ 15,220 GET _cFornece  WHEN .F. SIZE 40,20
@ 15,265 Say "Loja: "
@ 15,280 GET _cLoja     WHEN .F. SIZE 30,20

@ 35,010 Say "Emissao: "
@ 35,030 GET _dEmissao  WHEN .F. SIZE 50,20
@ 35,090 Say "Vencimento:"
@ 35,120 GET _dVencto    WHEN .F. SIZE 50,20
@ 35,175 Say "Vencimento Real:"
@ 35,220 GET _dVencRea   WHEN .F. SIZE 50,20
@ 35,280 Say "Valor:"
@ 35,300 GET _nValor     WHEN .F. PICTURE "@E 999,999.99" SIZE 50,20

@ 130,010  Say "Cod.Barras: "
@ 130,060  GET _cCodBar WHEN .t. SIZE 170,30

@ 150,010  Say "Linha Digitavel: "
@ 150,060  GET _cIPTE  WHEN .t. SIZE 170,30

@ 170,270 BMPBUTTON TYPE 1  ACTION (_nOpc:=1,oDlg:END())
@ 170,320 BMPBUTTON TYPE 2  ACTION oDlg:END()

@ 056,003 TO 100,110 TITLE "Forma de Pagamento"

_cBlValid := "{||MZ04_A()}"

oRadio:= tRadMenu():New(70,10,aRadio,{|u|if(PCount()>0,nRadio:=u,nRadio)},oDlg,,&(_cBlValid),,,,,,100,20,,,,.T.)

@ 056,120 TO 125,265 TITLE "Dados Para Deposito"

@ 065,130 Say "Banco: "
@ 065,170 GET _cBanco    WHEN _lAlt SIZE 20,20

@ 080,130 Say "Agencia/Dig: "
@ 080,170 GET _cAgencia  WHEN _lAlt SIZE 30,20
@ 080,200 GET _cAgenDig  WHEN _lAlt SIZE 15,20

@ 095,130 Say "Conta/Dig:"
@ 095,170 GET _cConta    WHEN _lAlt SIZE 50,20
@ 095,220 GET _cContaDig WHEN _lAlt SIZE 15,20

@ 110,130 Say "Favorecido:"
@ 110,170 GET _cFavorec  WHEN _lAlt SIZE 90,20

@ 056,280 TO 100,360 TITLE "Praca de Pagamento"
@ 070,285 RADIO aRadio2 VAR nRadio2

@ 001,365 TO 187,445 TITLE "Composicao dos Valores"

_nValor := SE2->E2_VALOR + SE2->E2_PIS + SE2->E2_COFINS + SE2->E2_CSLL + SE2->E2_ISS + SE2->E2_INSS + SE2->E2_IRRF + SF1->F1_DESCONT - SF1->F1_FRETE - SF1->F1_DESPESA - SF1->F1_ICMSRET

@ 010,370 Say "VL.TITULO: "
@ 010,410 GET _nValor          WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

@ 025,370 Say "(-)VL.PIS: "
@ 025,410 GET SE2->E2_PIS      WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

@ 040,370 Say "(-)VL.COFINS: "
@ 040,410 GET SE2->E2_COFINS   WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

@ 055,370 Say "(-)VL.CSLL: "
@ 055,410 GET SE2->E2_CSLL     WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

@ 070,370 Say "(-)VL.ISS: "
@ 070,410 GET SE2->E2_ISS      WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

@ 085,370 Say "(-)VL.INSS: "
@ 085,410 GET SE2->E2_INSS     WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

@ 100,370 Say "(-)VL.IRRF: "
@ 100,410 GET SE2->E2_IRRF     WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

@ 115,370 Say "(+)VL.DESCONTO:"
@ 115,410 GET SF1->F1_DESCONT  WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

@ 130,370 Say "(+)VL.FRETE  :"
@ 130,410 GET SF1->F1_FRETE    WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

@ 145,370 Say "(+)VL.DESPESAS:"
@ 145,410 GET SF1->F1_DESPESA  WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

@ 160,370 Say "(+)VL.ICMS ST:"
@ 160,410 GET SF1->F1_ICMSRET  WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

@ 175,370 Say "(=)VL.LIQUIDO:"
@ 175,410 GET SE2->E2_VALOR    WHEN .F. PICTURE "@E 999,999.99" SIZE 30,20

@ 170,010  Say "Nome Fornecedor: "
@ 170,060  GET _cNomeFor WHEN .F. SIZE 150,30


ACTIVATE MSDIALOG oDlg Centered

If _nOpc == 1
	SE2->(RecLock("SE2",.F.))
	SE2->E2_CODBAR  := _cCodBar
	SE2->E2_LINDIG  := _cIPTE
	SE2->E2_YFORMPG := StrZero(nRadio,3)
	SE2->E2_YPRAPG  := StrZero(nRadio2,3)
	SE2->E2_BANCO   := _cBanco
	SE2->E2_AGENCIA := _cAgencia
	SE2->E2_DIGAG   := _cAgenDig
	SE2->E2_NOCTA   := _cConta
	SE2->E2_DIGCTA  := _cContaDig
	SE2->E2_FILORIG := SF1->F1_FILIAL
	SE2->(MsUnlock())
	
	If !_lForn .And. !Empty(_cBanco)
		SA2->(RecLock("SA2",.F.))
		SA2->A2_BANCO    := _cBanco
		SA2->A2_AGENCIA  := _cAgencia
		SA2->A2_DIGAG    := _cAgenDig
		SA2->A2_CONTA    := _cConta
		SA2->A2_DIGCTA   := _cContaDig
		SA2->(MsUnlock())
	Endif
Endif

RestArea(_aAliSA2)
RestArea(_aAliSE2)
RestArea(_aAliSE4)
RestArea(_aALiOri)

Return

Static Function MZ04_A()

If nRadio == 2
	_lAlt     := .T.
	_cBanco   := SA2->A2_BANCO
	_cAgencia := SA2->A2_AGENCIA
	_cAgenDig := SA2->A2_DIGAG
	_cConta   := SA2->A2_NUMCON
	_cContaDig:= SA2->A2_DIGCTA
	_cFavorec := PADR(SA2->A2_NOME,60)
Else
	_lAlt     := .F.
	_cBanco   := Space(03)
	_cAgencia := Space(05)
	_cAgenDig := Space(01)
	_cConta   := Space(10)
	_cContaDig:= Space(01)
	_cFavorec := Space(60)
Endif

Return(_lAlt)