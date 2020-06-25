#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
Programa		: PXH077
Autor			: Fabiano da Silva
Data			: 11/06/15
Uso				: E-mail análise de crédito
Descrição 		: Utilizado no Ponto de Entrada MT410ALT e MT410INC
*/

USER FUNCTION PXH077()

Private  _nItem    := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="C6_ITEM"})
Private  _nProd    := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="C6_PRODUTO"})
Private  _nDescP   := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="C6_DESCRI"})
Private  _nUM  	   := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="C6_UM"})
Private  _nQtdLib  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="C6_QTDLIB"})
Private  _nQtdven  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="C6_QTDVEN"})
Private  _nPrcven  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="C6_PRCVEN"})
Private  _nValor   := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="C6_VALOR"})

_nTot  := 0
_aItem := {}

For I:= 1 to Len(Acols)
	If Acols[I][_nQtdLib] > 0
		SC9->(dbSetOrder(1))
		If SC9->(msSeek(xFilial('SC9')+SC5->C5_NUM+Acols[I][_nItem]))
			If SC9->C9_BLCRED = '01'
				AADD(_aItem,{Acols[I][_nItem],Acols[I][_nProd],Acols[I][_nDescP],Acols[I][_nUM],Acols[I][_nQtdven],Acols[I][_nPrcven],Acols[I][_nValor]})
			Endif
		Endif
	Endif
Next

If Len(_aItem) > 0
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	
	LjMsgRun( "Enviando e-mail análise de crédito, aguarde...", "Análise de crédito",;
	{|| PXH77A(SC5->C5_NUM,SC5->C5_EMISSAO,SC5->C5_CLIENTE,SC5->C5_LOJACLI,_aItem,SA1->A1_NOME,SA1->A1_LC,SA1->A1_SALDUP,SA1->A1_VENCLC) } )
	
Endif

Return(Nil)



STATIC FUNCTION PXH77A(_cPedido,_dEmissao,_cCliente,_cLojaCli,_aItem,_cNome,_nLimite,_nSaldo,_dDtLC)

Local oProcess
Local nDias := 0, nHoras := 0, nMinutos := 10
Local cCodProcesso, cCodStatus, cHtmlModelo, cMailID
Local cUsuarioProtheus, cTexto, cAssunto

CONOUT("Início E-Mail Limite de Crédito: "+_cPedido)

cUsuarioProtheus:= SubStr(cUsuario,7,15)

cCodProcesso 	:= "PXH077"
cHtmlModelo 	:= "\WORKFLOW\EMP"+cEmpAnt+"\PXH077.HTM"
cAssunto 		:= "Análise de Crédito"
oProcess        := TWFProcess():New(cCodProcesso, cAssunto)
oProcess:NewTask(cAssunto, cHtmlModelo)
oHTML 			:= oProcess:oHTML

_nTotal := 0
For F := 1 To Len(_aItem)
	
	_nTotal += _aItem[F][7]
	
	AAdd( (oHtml:ValByName( "it.item"   )),_aItem[F][1] )
	AAdd( (oHtml:ValByName( "it.codigo" )),_aItem[F][2] )
	AAdd( (oHtml:ValByName( "it.descri" )),_aItem[F][3] )
	AAdd( (oHtml:ValByName( "it.um" 	)),_aItem[F][4] )
	AAdd( (oHtml:ValByName( "it.quant"  )),TRANSFORM( _aItem[F][5],'@E 999,999.99' ) )
	AAdd( (oHtml:ValByName( "it.unit"   )),TRANSFORM( _aItem[F][6],'@E 999,999.99' ) )
	AAdd( (oHtml:ValByName( "it.total"  )),TRANSFORM( _aItem[F][7],'@E 999,999.99' ) )
	
Next F

oHtml:ValByName("PEDIDO"  	, _cPedido  	)
oHtml:ValByName("EMISSAO" 	, DTOC(_dEmissao)	)
oHtml:ValByName("DTLC" 		, DTOC(_dDtLC	)	)
oHtml:ValByName("CLIENTE"	, _cCliente 	)
oHtml:ValByName("LOJA"  	, _cLojaCli  	)
oHtml:ValByName("NOME"  	, _cNome  		)
oHtml:ValByName("TOTAL"  	, TRANSFORM(_nTotal , "@E 9,999,999.99" ))
oHtml:ValByName("LIMITE" 	, TRANSFORM(_nLimite, "@E 9,999,999.99" ))
oHtml:ValByName("SALDO"  	, TRANSFORM(_nSaldo, "@E 9,999,999.99" 	))

oProcess:fDesc := "Análise de Crédito: "+ _cPedido

oProcess:cSubject := cAssunto
oProcess:UserSiga := WFCodUser(Alltrim(Subs(cUsuario,7,15)))
oProcess:cTo := "CREDITO"
oProcess:bReturn := "U_PXH77R()"
cMailID := oProcess:Start()

cHtmlModelo := "\WORKFLOW\EMP"+cEmpAnt+"\PXH77L.HTM"

oProcess:NewTask(cAssunto, cHtmlModelo)
oHTML := oProcess:oHTML

oProcess:cSubject := cAssunto

Private _cTo := _cCC := ""

SZ0->(dbsetOrder(1))
SZ0->(dbGotop())

While SZ0->(!EOF())
	
	If 'C1' $ SZ0->Z0_ROTINA
		_cTo += If(Empty(_cTo),ALLTRIM(SZ0->Z0_EMAIL),';'+ALLTRIM(SZ0->Z0_EMAIL))
	ElseIf 'C2' $ SZ0->Z0_ROTINA
		_cCC += If(Empty(_cCC),ALLTRIM(SZ0->Z0_EMAIL),';'+ALLTRIM(SZ0->Z0_EMAIL))
	Endif
	
	SZ0->(dbSkip())
Enddo

oProcess:cTo := _cTo
oProcess:cCC := _cCC

oProcess:oHtml:ValByName("NOMCLI"  , _cNome  )
//oProcess:ohtml:ValByName("proc_link","http://187.60.224.66:90/messenger/emp"+cEmpAnt+"/CREDITO/" + cMailID + ".htm")
oProcess:ohtml:ValByName("proc_link","http://siga.polimixambiental.com.br:6002/messenger/emp"+cEmpAnt+"/CREDITO/" + cMailID + ".htm")


oProcess:Start()

Return




User Function PXH77R(oProcess)

Local cCodStatus, cTexto
Local nC, nDias := 0, nHoras := 0, nMinutos := 10
Local _cPedido
Local _cCliente
Local _cLoja

conout("(RETORNO)Processo: " + oProcess:fProcessID + " - Task: " + oProcess:fTaskID )

_cPedido  := oProcess:oHtml:RetByName("PEDIDO")
_cEmissao := oProcess:oHtml:RetByName("EMISSAO")
_cCliente := oProcess:oHtml:RetByName("CLIENTE")
_cLoja    := oProcess:oHtml:RetByName("LOJA")
_cNome	  := oProcess:oHtml:RetByName("NOME")

SC9->(dbSetOrder(1))
If SC9->(msSeek(xFilial('SC9')+_cPedido))
	
	While SC9->(!EOF()) .And. SC9->C9_PEDIDO = _cPedido
		If SC9->C9_BLCRED = '01'
			SC9->(RECLOCK('SC9',.F.))
			SC9->C9_BLCRED := ''
			SC9->(MSUNLOCK())
		Endif
		SC9->(dbSkip())
	EndDo
	
Endif

_oRetProc:=TWFProcess():New("000002","RETORNO ANALISE AC")

_oRetProc:NewTask('Inicio',"\WORKFLOW\EMP"+cEmpAnt+"\PXH77R.htm")

oProcess:Finish()

_oHtml   := _oRetProc:oHtml

_oHtml:valbyname("Pedido"	, _cPedido)
_oHtml:valbyname("Emissao"  , _cEmissao)
_oHtml:valbyname("CLIENTE"	, _cCliente)
_oHtml:valbyname("LOJA"		, _cLoja)
_oHtml:valbyname("NOME"		, _cNome)

Private _cTo := _cCC := ""

SZ0->(dbsetOrder(1))
SZ0->(dbGotop())

While SZ0->(!EOF())
	
	If 'D1' $ SZ0->Z0_ROTINA
		_cTo += If(Empty(_cTo),ALLTRIM(SZ0->Z0_EMAIL),';'+ALLTRIM(SZ0->Z0_EMAIL))
	ElseIf 'D2' $ SZ0->Z0_ROTINA
		_cCC += If(Empty(_cCC),ALLTRIM(SZ0->Z0_EMAIL),';'+ALLTRIM(SZ0->Z0_EMAIL))
	Endif
	
	SZ0->(dbSkip())
Enddo
_oRetProc:cTo := _cTo
_oRetProc:cCC := _cCC

_oRetProc:cSubject := "Retorno Análise Crédido: "+_cPedido

_oRetProc:cBody    := ""
_oRetProc:bReturn  := ""
_oRetProc:Start()

_oRetProc:Free()
_oRetProc:Finish()
_oRetProc:= Nil

Return