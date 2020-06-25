#include "Totvs.ch"
#include "TbiConn.ch"
#include "Topconn.ch"
#include "TbiCode.ch"

/*
Autor		: Fabiano da Silva
Data		: 25/02/15
Programa 	: PXH069
Descrição	: Liberação Pedido de Compras
*/

User Function PXH069( oProcess,_lRet,_cNivel,_lPed )

Local aCond:={},nTotal := 0

PRIVATE nDias := 0, nHoras := 0, nMinutos := 05
PRIVATE _cNomeFor,_cCond

_cMailAp := ""
_cMail   := ""

Private _cPedCompra := SC7->C7_NUM

dbSelectArea('SA2')
dbSetOrder(1)
dbSeek(xFilial('SA2')+SC7->C7_FORNECE)
_cNomeFor := SA2->A2_NREDUZ

SE4->(dbSetOrder(1))
SE4->(dbSeek(xFilial('SE4') + SC7->C7_COND))

_cCond   := SE4->E4_DESCRI
_cNumEmp := SM0->M0_CODIGO
_aAprov  := {}

If _lPed
	dbSelectArea('SCR')
	SCR->(dbSetOrder(1))
	If SCR->(dbSeek(xFilial('SCR') + "PC"+PADR(SC7->C7_NUM,50)+ _cNivel))
		_cChavSCR := SCR->CR_NUM
		_cAprov   := _cMail   := _cName := ""
		
		While SCR->(!Eof()) .And.   _cChavSCR == SCR->CR_NUM .And. 	_cNivel == SCR->CR_NIVEL
			
			SAK->(dbSetOrder(2))
			If SAK->(dbSeek(xFilial("SAK")+SCR->CR_USER))
				_cAprov  := SCR->CR_USER
				_cMail   := ""
				
				PswOrder(1)
				If PswSeek(_cAprov,.t.)
					aInfo   := PswRet(1)
					If !Empty(alltrim(aInfo[1,14]))
						_cMail   := alltrim(aInfo[1,14])+";"
						_cName   := UsrFullName(_cAprov)
						
						nScan := aScan(_aAprov,{|x| x[1] == _cAprov})
						If ( nScan==0 )
							aadd(_aAprov,{ _cAprov, _cMail,_cName})
						EndIf
					Endif
				Endif
			Endif
			
			If SCR->CR_STATUS == "01"
				SCR->(RecLock("SCR",.F.))
				SCR->CR_STATUS := "02"
				SCR->(MsUnlock())
			Endif
			
			SCR->(dbSkip())
		EndDo
		
	Endif
Else
	SCR->(RetIndex("SCR"))
	SCR->(dbClearFilter())
	
	_cNivel := "01"
	
	//Msginfo("Ponto Entrada --> Linha 77")
	dbSelectArea('SCR')
	SCR->(dbSetOrder(1))
	If SCR->(dbSeek(xFilial('SCR') + "PC" + PADR(SC7->C7_NUM,50)+ _cNivel))
		
		If SCR->CR_STATUS == "04"
		   Return
		Endif
		
		//Msginfo("Ponto Entrada --> Linha 82")
		_cChavSCR := SCR->CR_NUM
		_cAprov   := _cMail   := _cName := ""
		
		While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_NUM
			
			_cNivel := SCR->CR_NIVEL
			
			While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_NUM .And. _cNivel == SCR->CR_NIVEL
				
				If !SCR->CR_STATUS $ "01/02"
					SCR->(dbSkip())
					Loop
				Endif
				
				SAK->(dbSetOrder(2))
				If SAK->(dbSeek(xFilial("SAK")+SCR->CR_USER))
					_cAprov  := SCR->CR_USER
					_cMail   := ""
					
					PswOrder(1)
					If PswSeek(_cAprov,.t.)
						aInfo   := PswRet(1)
						If !Empty(alltrim(aInfo[1,14]))
							_cMail   := alltrim(aInfo[1,14])+";"
							_cName   := UsrFullName(_cAprov)
							
							nScan := aScan(_aAprov,{|x| x[1] == _cAprov})
							If ( nScan==0 )
								aadd(_aAprov,{ _cAprov, _cMail,_cName})
							EndIf
						Endif
					Endif
				Endif
				
				//SCR->(RecLock("SCR",.F.))
				//SCR->CR_STATUS  := "02"
				//SCR->(MsUnlock())
				
				SCR->(dbSkip())
			EndDo
		EndDo
	Endif
Endif

For AX:= 1 To Len(_aAprov)
	
	oProcess := ""
	WFNEWPROC(AX,_cNivel)
	
Next AX

Return



User Function WFRET01( oProcess )

//	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10002','Respondendo o E-mail.',"BI")

/*
{ 'CR_STATUS== "01"', 'BR_AZUL' },;   //Bloqueado p/ sistema (aguardando outros niveis)
{ 'CR_STATUS== "02"', 'DISABLE' },;   //Aguardando Liberacao do usuario
{ 'CR_STATUS== "03"', 'ENABLE'  },;   //Pedido Liberado pelo usuario
{ 'CR_STATUS== "04"', 'BR_PRETO'},;   //Pedido Bloqueado pelo usuario
{ 'CR_STATUS== "05"', 'BR_CINZA'} }   //Pedido Liberado por outro usuario

1o
QUANDO TEM MAIS DE UMA APROVAÇÃO,NA PRIMEIRA APROVAÇÃO NAO É ATUALIZADO NADA NA TABELA SC7

CAMPOS -> CR_VALLIB,CR_TIPOLIM,CR_LIBAPRO,CR_DATALIB,CR_OBS,CR_USERLIB,CR_STATUS

2o

*/

conout("(RETORNO)Processo: " + oProcess:fProcessID + " - Task: " + oProcess:fTaskID )

Private lLast := .T.,_oProc,nTotal

_cNumSCR := ""

ConOut('Pedido:'+oProcess:oHtml:RetByName('Pedido'))

_cNivel     := oProcess:oHtml:RetByName("CNIVEL")
_cAprovador := oProcess:oHtml:RetByName("CAPROVADOR")
_cPedCom    := oProcess:oHtml:RetByName('Pedido')
_cEmissao   := oProcess:oHtml:RetByName('Emissao')
_cFornece   := oProcess:oHtml:RetByName('lb_nome')
_nTotal    	:= oProcess:oHtml:RetByName('lbtotal')
_cMotivo   	:= oProcess:oHtml:RetByName('lbmotivo')
_cComprador	:= oProcess:oHtml:RetByName('comprador')

_oRetProc:=TWFProcess():New("000002","RETORNO ANALISE PC")

_cAnalAnt:= ''

If oProcess:oHtml:RetByName("Aprovacao") = "S"
	_cStatus := "Aprovado"
	
	_oRetProc:NewTask('Inicio',"\WORKFLOW\EMP"+cEmpAnt+"\PC_APROV.htm")
	ConOut("Aprovando o pedido")
	
	//		RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10006','Aprovando o Pedido.',"BI")
	dbSelectarea("SCR")                   // Posiciona a Liberacao
	dbSetorder(1)
	If dbSeek(xFilial("SCR")+"PC"+PADR(oProcess:oHtml:RetByName('Pedido'),50)+_cNivel)
		
		_cChavSCR := SCR->CR_NUM + SCR->CR_NIVEL
		_cNumSCR  := SCR->CR_NUM
		
		While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_NUM+SCR->CR_NIVEL
			
			If SCR->CR_STATUS $ '01|02'
				
				SCR->(RecLock("SCR",.f.))
				SCR->CR_DATALIB := dDataBase
				SCR->CR_OBS     := ""
				SCR->CR_USERLIB := _cAprovador//Subs(cUsuario,7,15)
				If SCR->CR_USER == _cAprovador
					SCR->CR_STATUS  := "03"
					SAK->(dbSetOrder(2))
					If SAK->(dbSeek(xFilial("SAK")+SCR->CR_USER))
						SCR->CR_VALLIB  := SCR->CR_TOTAL
						SCR->CR_TIPOLIM := SAK->AK_TIPO
						SCR->CR_LIBAPRO := SAK->AK_COD
					Endif
				Else
					//						SCR->CR_STATUS  := "05"
				Endif
				MsUnLock()
			ElseIf SCR->CR_STATUS = '04'
				
				_cStatus   := "Reprovado"
				_cAnalAnt  :=	SCR->CR_USERLIB
				_oRetProc:NewTask('Inicio',"\WORKFLOW\EMP"+cEmpAnt+"\PC_ANALI.htm")
				ConOut("Enviando Pedido já analisado!!")
			Endif
			
			SCR->(dbSkip())
		EndDo
	Endif
	
	SC7->(dbSetOrder(1))
	SC7->(dbSeek(xFilial("SC7")+_cPedCom))
	
	oProcess:Finish()
	
	_aAliSCR := SCR->(GetArea())
	
	_cQr := " SELECT * FROM "+RetSqlName('SCR')+" CR "
	_cQr += " WHERE CR.D_E_L_E_T_ = '' AND RTRIM(CR_NUM) = '"+_cPedCom+"' AND CR_TIPO = 'PC' "
	_cQr += " AND CR_STATUS IN ('01','02') AND CR_NIVEL = '"+_cNivel+"' "
	
	TCQUERY _cQr New ALIAS "ZZ"
	
	Count TO _nRec
	
	ZZ->(dbCloseArea())
	
	RestArea(_aAliSCR)
	
	If _cNumSCR  == SCR->CR_NUM .And. _nRec = 0
		
		_oRetProc:NewTask('Inicio',"\WORKFLOW\EMP"+cEmpAnt+"\PC_AGUA.htm")
		ConOut("Enviando para o Proximo Aprovador!!")
		//U_PXH069("",.T.,SCR->CR_NIVEL)
		U_PXH069("",.T.,SCR->CR_NIVEL,.T.)
	Else
		If _nRec = 0
			While SC7->(!EOF()) .and. SC7->C7_NUM == _cPedCom
				SC7->(RecLock("SC7",.f.))
				SC7->C7_CONAPRO := "L"
				SC7->(MsUnLock())
				SC7->(dbSkip())
			Enddo
		Else
			//_cQ := "UPDATE "+RetSqlName("SCR")+" SET CR_STATUS = '02' WHERE D_E_L_E_T_ = '' AND CR_STATUS = '01' AND CR_NUM '"+_cPedCom+"' AND CR_NIVEL = '"+_cNivel+"' "
			//MemoWrit("C:\Temp\PXH069.SQL",_cQ)
			
			//TCSQLEXEC(_cQ)
			
			_oRetProc:NewTask('Inicio',"\WORKFLOW\EMP"+cEmpAnt+"\PC_AGUA.htm")
		Endif
	Endif
Else
	_oRetProc:NewTask('Inicio',"\WORKFLOW\EMP"+cEmpAnt+"\PC_REPRO.htm")
	
	dbSelectarea("SCR")                   // Posiciona a Liberacao
	dbSetorder(1)
	If dbSeek(xFilial("SCR")+"PC"+PADR(oProcess:oHtml:RetByName('Pedido'),50)+_cNivel)
		
		_cChavSCR := SCR->CR_NUM + SCR->CR_NIVEL
		_cNumSCR  := SCR->CR_NUM
		
		While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_NUM+SCR->CR_NIVEL
			
			If SCR->CR_STATUS $ '01|02'
				
				SCR->(RecLock("SCR",.f.))
				SCR->CR_DATALIB := dDataBase
				SCR->CR_OBS     := ""
				SCR->CR_USERLIB := _cAprovador//Subs(cUsuario,7,15)
				SCR->CR_STATUS  := "04"
				SCR->CR_VALLIB  := SCR->CR_TOTAL
				SCR->CR_TIPOLIM := "D"
				SCR->CR_LIBAPRO := _cAprovador//Subs(cUsuario,7,15)
				MsUnLock()
				
			ElseIf SCR->CR_STATUS = '04'
				
				_cStatus   := "Reprovado"
				_cAnalAnt  :=	SCR->CR_USERLIB
				_oRetProc:NewTask('Inicio',"\WORKFLOW\EMP"+cEmpAnt+"\PC_ANALI.htm")
				ConOut("Enviando Pedido já analisado!!")
				Exit
			Endif
			
			SCR->(dbSkip())
		EndDo
	Endif
	
	oProcess:Finish()
Endif

_oHtml   := _oRetProc:oHtml

_oHtml:valbyname("Pedido"	, _cPedCom)
_oHtml:valbyname("Emissao"  , _cEmissao)
If Empty(_cAnalAnt)
	_cCC := UsrRetMail(_cComprador)
	_oHtml:valbyname("Aprov"	, UsrFullName(_cAprovador))
	_oHtml:valbyname("cMotivo"  , _cMotivo)
Else
	_cCC := ""
	_oHtml:valbyname("Aprov"	, UsrFullName(_cAnalAnt))
	_oHtml:valbyname("Status"   , _cStatus)
Endif
_oHtml:valbyname("Fornece"	, _cFornece)
_oHtml:valbyname("Total"	, _nTotal)

_oRetProc:ClientName(_cAprovador)

_oRetProc:cTo  		:= UsrRetMail(_cAprovador)
_oRetProc:cCC  		:= _cCC
_oRetProc:cSubject  := "Retorno Análise Pedido: "+_cPedCom
_oRetProc:cBody     := ""
_oRetProc:bReturn   := ""
_oRetProc:Start()

_oRetProc:Free()
_oRetProc:Finish()
_oRetProc:= Nil

Return



User Function WFTIM01( oProcess )

ConOut("Funcao de TIMEOUT executada")
oProcess:NewTask('Time Out',"\workflow\EMP"+cEmpAnt+"\timeout.htm")
oHtml:=oProcess:oHtml
oHtml:RetByName("Titulo","Usuario não respondeu e-mail")
oHtml:RetByName("numPed",_cPedido)
oHtml:RetByName("cliente",_ccliente)
_cUser = Subs(cUsuario,7,15)
oHtml:RetByName("usuario",_cUser)
subj := "Pedido"+ _cPedido + " por " + _ccliente
oProcess:Start()

Return


Static Function WFNEWPROC(AX_,_cNiv)

SC7->(dbSetOrder(1))
SC7->(dbSeek(xFilial('SC7')+_cPedCompra))

nTotal          := 0
cUsuarioProtheus:= SubStr(cUsuario,7,15)

cCodProcesso    := "000001"

cHtmlModelo     := "\WORKFLOW\EMP"+cEmpAnt+"\PC_MAIL.HTM"
cAssunto        := "Lib. PC "+SC7->C7_NUM+" - "+Alltrim(SM0->M0_FILIAL)+" NIV.: "+_cNiv
oProcess        := TWFProcess():New(cCodProcesso, cAssunto)
oProcess:NewTask(cAssunto, cHtmlModelo)
oHTML := oProcess:oHTML

//	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Processo Iniciao',"BI")

cTexto     := "Iniciando o Processo de " + cAssunto+" Nivel--> "+_cNiv//+" Aprov: "+Alltrim(_cAp)
cCodStatus := "10001"

ConOUt(cTexto)

oHtml:ValByName( "EMISSAO"   , SC7->C7_EMISSAO )
oHtml:ValByName( "FORNECEDOR", SC7->C7_FORNECE )
oHtml:ValByName( "CNIVEL"    , _cNiv   )
oHtml:ValByName( "CAPROVADOR", _aAprov[AX][1] )
oHtml:ValByName( "lb_nome"   , _cNomeFor)
oHtml:ValByName( "lb_cond"   , _cCond )
oHtml:ValByName( "PEDIDO"    , SC7->C7_NUM )
oHtml:ValByName( "comprador" , SC7->C7_USER )
_cSolicit :=  If(!Empty(SC7->C7_YSOLICIT),Posicione("SZJ",1,xFilial("SZJ")+SC7->C7_YSOLICIT,'ZJ_NOME'),Space(50))
oHtml:ValByName( "solicit"   , _cSolicit )

oProcess:fDesc := "Pedido de Compras No "+ SC7->C7_NUM

dbSelectArea("SC7")

SC7->(dbSetOrder(1))
If SC7->(dbSeek(xFilial('SC7')+_cPedCompra))
	
	While SC7->(!Eof()) .And. _cPedCompra == SC7->C7_NUM
		
		nTotal := nTotal + C7_TOTAL
		
		AAdd( (oHtml:ValByName( "it.item" ))  ,SC7->C7_ITEM )
		AAdd( (oHtml:ValByName( "it.codigo" )),SC7->C7_PRODUTO )
		
		dbSelectArea('SB1')
		dbSetOrder(1)
		dbSeek(xFilial('SB1')+SC7->C7_PRODUTO)
		
		dbSelectArea('SC7')
		//		AAdd( (oHtml:ValByName( "it.descricao" )),SB1->B1_DESC )
		AAdd( (oHtml:ValByName( "it.descricao" )),SC7->C7_DESCRI )
		AAdd( (oHtml:ValByName( "it.quant" )),TRANSFORM( SC7->C7_QUANT,'@E 999,999.99' ) )
		AAdd( (oHtml:ValByName( "it.preco" )),TRANSFORM( SC7->C7_PRECO,'@E 999,999.99' ) )
		AAdd( (oHtml:ValByName( "it.total" )),TRANSFORM( SC7->C7_TOTAL,'@E 999,999.99' ) )
		AAdd( (oHtml:ValByName( "it.obs"   )),SC7->C7_OBS)
		//		AAdd( (oHtml:ValByName( "it.unid"  )),SB1->B1_UM )
		AAdd( (oHtml:ValByName( "it.unid"  )),SC7->C7_UM )
		
		SC7->(RecLock("SC7",.F.))
		//		SC7->C7_WFID   := oProcess:fProcessID
		SC7->C7_FILENT := C7_FILIAL
		SC7->(MsUnlock())
		
		SC7->(dbSkip())
	Enddo
Endif

oHtml:ValByName( "lbValor" ,TRANSFORM( nTotal,'@E 999,999.99' ) )
oHtml:ValByName( "lbFrete" ,TRANSFORM( 0,'@E 999,999.99' ) )
oHtml:ValByName( "lbTotal" ,TRANSFORM( nTotal,'@E 999,999.99' ) )

oProcess:cSubject := cAssunto
oProcess:cTo      := "LIBPEDIDO"
oProcess:UserSiga := WFCodUser(Alltrim(Subs(cUsuario,7,15)))
oProcess:bReturn  := "U_WFRET01()"
//oProcess:bTimeOut := {{"U_WFTIM01()", nDias, nHoras, nMinutos}}
cMailID           := oProcess:Start()

cHtmlModelo       := "\workflow\EMP"+cEmpAnt+"\PC_LINK.htm"

oProcess:NewTask(cAssunto, cHtmlModelo)
oHTML := oProcess:oHTML

//	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10005','Antes de Enviar o E-mail',"BI")
conout("(INICIO Processo: " + oProcess:fProcessID + " - Task: " + oProcess:fTaskID )

oProcess:cSubject := cAssunto
oProcess:cTo      := _aAprov[AX][2]
oProcess:oHtml:ValByName("usuario"  , _aAprov[AX][3]  )
oProcess:ohtml:ValByName("proc_link","http://siga.polimixambiental.com.br:6002/messenger/emp"+cEmpAnt+"/LIBPEDIDO/" + cMailID + ".htm")

cTexto     := "Enviando solicitação..."
cCodStatus := "100300"
oProcess:Start()

cTexto     := "Aguardando retorno..."
cCodStatus := "10004"
//	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10004','Aguardando o Retorno...',"BI")

Return