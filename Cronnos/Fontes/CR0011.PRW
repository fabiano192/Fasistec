#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CR0011  ³                               ³ Data ³ 27/02/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exportar Pedido de vendas					             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Faturamento                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CR0011()

PREPARE ENVIRONMENT Empresa "01" Filial "01"

_aAliOri := GetArea()
_aAliSC6 := SC6->(GetArea())
_aAliSC5 := SC5->(GetArea())

_lEnvia    := .F.
_lFim      := .F.
_cMsg01    := ''
_lAborta01 := .T.
_bAcao01   := {|_lFim| 	CR011A(@_lFim) }
_cTitulo01 := 'Exportando Pedidos !!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

RestArea(_aAliSC5)
RestArea(_aAliSC6)
RestArea(_aAliOri)

Return


Static Function CR011A(_lFim)

Private cArq
Private nArq
Private cPath

cPath := "\Pedidos\"

cArq  := CriaTrab(Nil, .F.)
nArq  := FCreate(cPath + cArq + ".txt")

If nArq == -1
	MsgAlert("Não conseguiu criar o arquivo!")
	Return
EndIf

aStru := {}
AADD(aStru,{"CLIENT"    , "C" , 06, 0 })
AADD(aStru,{"LOJA"      , "C" , 02, 0 })
AADD(aStru,{"PEDIDO"    , "C" , 06, 0 })
AADD(aStru,{"PAGTO"     , "C" , 03, 0 })
AADD(aStru,{"DTEMIS"    , "D" , 08, 0 })
AADD(aStru,{"ITEM"      , "C" , 02, 0 })
AADD(aStru,{"PRODPAS"   , "C" , 15, 0 })
AADD(aStru,{"PRODCLI"   , "C" , 15, 0 })
AADD(aStru,{"REFCLI"    , "C" , 15, 0 })
AADD(aStru,{"QUANT"     , "N" , 12, 4 })
AADD(aStru,{"UNIT"      , "N" , 17, 5 })
AADD(aStru,{"TOTAL"     , "N" , 12, 2 })
AADD(aStru,{"DTENTR"    , "D" , 08, 0 })
AADD(aStru,{"TES"       , "C" , 03, 0 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "PEDIDO+ITEM"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

FWrite(nArq, "CLIENTE;LOJA;NOME;SERIE;NF;EMISSAO;COD.PASY;COD.CLIENTE;REF.CLIENTE;QUANTIDADE;UNITARIO;TOTAL" + Chr(13) + Chr(10))

_lEnvia := .F.

_cQuery := " SELECT D2_CLIENTE,D2_LOJA,A1_NOME,D2_EMISSAO,D2_SERIE,D2_DOC,D2_COD,D2_PROCLI,D2_PEDCLI,D2_QUANT,D2_PRCVEN,D2_TOTAL "
_cQuery += " FROM "+RetSqlName("SD2")+" D2 (NOLOCK) "
_cQuery += " INNER JOIN "+RetSqlName("SF2")+" F2 (NOLOCK) ON D2_DOC+D2_SERIE = F2_DOC+F2_SERIE "
_cQuery += " INNER JOIN "+RetSqlName("SA1")+" A1 (NOLOCK) ON D2_CLIENTE+D2_LOJA = A1_COD+A1_LOJA "
_cQuery += " INNER JOIN "+RetSqlName("SF4")+" F4 (NOLOCK) ON D2_TES = F4_CODIGO "
_cQuery += " WHERE D2.D_E_L_E_T_ = '' AND A1.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' AND F2.D_E_L_E_T_ = '' "
_cQuery += " AND F2_ENEMAIL <> 'S' "
_cQuery += " AND F4_DUPLIC = 'S' "
_cQuery += " ORDER BY D2_CLIENTE,D2_LOJA,A1_NOME,D2_EMISSAO,D2_SERIE,D2_DOC,D2_COD"

TCQUERY _cQuery New ALIAS "ZD2"

TcSetField("ZD2","D2_EMISSAO" ,"D",8)

ZD2->(dbGoTop())

While ZD2->(!Eof())

	If !TRB->(dbSeek(ZD2->D2_DOC))
		TRB->(RecLock("TRB",.T.))
		TRB->CLIENT  := ZD2->D2_CLIENTE
		TRB->LOJA    := ZD2->D2_LOJA
		TRB->NOME    := ZD2->A1_NOME
		TRB->SERIE	 := ZD2->D2_SERIE
		TRB->NF		 := ZD2->D2_DOC
		TRB->DTEMIS  := ZD2->D2_EMISSAO
		TRB->(MsUnlock())
	Endif

	_cCli := Alltrim(ZD2->D2_CLIENTE)
	_cLoj := Alltrim(ZD2->D2_LOJA)
	_cNom := Alltrim(ZD2->A1_NOME)
	_cSer := Alltrim(ZD2->D2_SERIE)
	_cNF  := Alltrim(ZD2->D2_DOC)
	_cEmi := dToc(ZD2->D2_EMISSAO)
	_cCPa := Alltrim(ZD2->D2_COD)
	_cCCl := Alltrim(ZD2->D2_PROCLI)
	_cRef := Alltrim(ZD2->D2_PEDCLI)
	_cQte := Alltrim(Transform(ZD2->D2_QUANT,"@ze 9,999,999.99"))
	_cUni := Alltrim(Transform(ZD2->D2_PRCVEN,"@ze 9,999,999.9999"))
	_cTot := Alltrim(Transform(ZD2->D2_TOTAL,"@ze 9,999,999.99"))

	FWrite(nArq, "'"+_cCli+";'"+_cLoj+";"+_cNom+";'"+_cSer+";'"+_cNF+";"+_cEmi+";'"+_cCPa+";'"+_cCCl+";'"+_cRef+";"+_cQte+";"+_cUni+";"+_cTot + Chr(13) + Chr(10))

	_lEnvia := .T.

	ZD2->(dbSkip())
EndDo

FClose(nArq)

If _lEnvia
	PA222B()
Endif

ZD2->(dbCloseArea())
TRB->(dbCloseArea())

Return


Static Function PA222B()

Private _lRet

nOpcao := 0

ConOut("Enviando E-Mail de Notas Fiscais Emitidas:")

oProcess := TWFProcess():New( "ENVEM1", "NF" )
aCond    :={}
_nTotal  := 0

oProcess:NewTask( "EMISSAO_NF", "\WORKFLOW\EMI_NF.HTM" )
oProcess:bReturn  := ""
oProcess:bTimeOut := ""
oHTML := oProcess:oHTML

_nPerIpi  := 0
nValIPI   := 0
nTotal    := 0

oProcess:cSubject := "Notas Fiscais Emitidas - "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

TRB->(dbGoTop())

While TRB->(!Eof())

	AADD( (oHtml:ValByName( "TB.CODIGO"   )), TRB->CLIENT)
	AADD( (oHtml:ValByName( "TB.LOJA"     )), TRB->LOJA)
	AADD( (oHtml:ValByName( "TB.NOME"     )), TRB->NOME)
	AADD( (oHtml:ValByName( "TB.SERIE"    )), TRB->SERIE)
	AADD( (oHtml:ValByName( "TB.NF"  	  )), TRB->NF)
	AADD( (oHtml:ValByName( "TB.DTEMIS"   )), DTOC(TRB->DTEMIS))

	oProcess:fDesc := "NOTAS FISCAIS EMITIDAS"

	SF2->(dbSetOrder(1))
	If SF2->(dbSeek(xFilial("SF2")+TRB->NF+TRB->SERIE+TRB->CLIENT+TRB->LOJA))
		SF2->(RecLock("SF2",.f.))
		SF2->F2_ENEMAIL := "S"
		SF2->(MsUnlock())
   	Endif

	TRB->(dbSkip())
EndDo

_cTo := GETMV("MV_WEMPCP1")
//_cTo := "fabiano@assystem.com.br"
//_cTo := GETMV("MV_WEMTI1")
_cCc := GETMV("MV_WEMDIR1")+";"+GETMV("MV_WEMTI1")
//_cCc := ""

oProcess:AttachFile(cPath + cArq + ".CSV")

oProcess:cTo := _cTo
oProcess:cCC := _cCC

oProcess:Start()

RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Envio Email PNE iniciado!' )

oProcess:Finish()

Return
