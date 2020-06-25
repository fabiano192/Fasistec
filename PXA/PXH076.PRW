#include "TOTVS.CH"

/*
Programa	: PXH076
Autor		: Fabiano da Silva
Data		: 21/01/2014
Descrição	: Programa utilizado para desbloquear o Pedido de Vendas
*/

User Function PXH076()  

	If SC5->C5_BLQ <> "B"
		MsgAlert("Pedido não está Bloqueado!")
		Return
	Endif
	
	Private _lRet 		:= .T.
	Private	_cSenDig   	:= Space(6)
	Private	_cSenPad   	:= GETMV("PXH_SENBLQ")

	_nOpca   := 0
	DEFINE MSDIALOG _oSenhas FROM 00, 00 TO 10,38 TITLE "SENHA"

	@ 01,01  TO 60,130 OF _oSenhas PIXEL

	@ 10,05  Say "Digite a Senha para liberar o Pedido de Vendas! " OF _oSenhas PIXEL

	@ 25,05  Say "Senha: " 								OF _oSenhas PIXEL
	@ 25,30  MsGet _cSenDig   PASSWORD Size 030, 007 	OF _oSenhas PIXEL

	@ 40, 05 BUTTON "OK" 			SIZE 036,012 ACTION  (_nOpca:=1,_oSenhas:END()) OF _oSenhas PIXEL
	@ 40, 45 BUTTON "Sair"       	SIZE 036,012 ACTION  (_nOpca:=2,_oSenhas:END()) OF _oSenhas PIXEL

	_lOK := U_PXH042("PXH076",6,.F.)
	If _lOK
		@ 40, 85 BUTTON "Alterar Senha"	SIZE 036,012 ACTION  (_nOpca:=3,_oSenhas:END()) OF _oSenhas PIXEL
	Endif

	ACTIVATE DIALOG _oSenhas CENTERED

	If _nOpca == 1
		If AllTrim(_cSenDig) == Alltrim(_cSenPad)
			//_cItem := PXH76ITEM()
//			If !Empty(_cItem)
//				SC6->(dbsetOrder(1))
//				If SC6->(msSeek(xFilial('SC6')+SC5->C5_NUM+_cItem))
					SC5->(RecLock('SC5',.F.))
					SC5->C5_BLQ := ''
					SC5->(MsUnlock())
	//			Endif
	//		Endif
		Else
			MSGSTOP( "Senha Incorreta" )
			_lRet :=.F.
		Endif
	ElseIf _nOpca == 2

	ElseIf _nOpca == 3
		Atualiza()
	Endif

Return



Static Function ATUALIZA()

	_cSenDig   := Space(6)
	_cSenPad   := GETMV("PXH_SENBLQ")

	_cGet3     := Space(6)
	_cGet4     := Space(6)

	_nOpc     := 0

	DEFINE MSDIALOG _oSenha FROM 00, 00 TO 11,26 TITLE "ALTERAR SENHA"

	@ 01,01  TO 75,100 OF _oSenha PIXEL

	@ 03,04 Say "Senha Atual: " OF _oSenha PIXEL
	@ 18,04 Say "Nova Senha  : " OF _oSenha PIXEL
	@ 33,04 Say "Redigita Nova Senha  : " OF _oSenha PIXEL

	@ 03,65 MsGet _cSenDig  PASSWORD Valid VerSenha() 	Size 030, 007 OF _oSenha PIXEL
	@ 18,65 MsGet _cGet3    PASSWORD 					Size 030, 007 OF _oSenha PIXEL
	@ 33,65 MsGet _cGet4    PASSWORD Valid VerSenha2() 	Size 030, 007 OF _oSenha PIXEL

	DEFINE SBUTTON FROM 055, 005 TYPE 1 ACTION (_nOpc:=1,_oSenha:END()) ENABLE OF _oSenha
	DEFINE SBUTTON FROM 055, 045 TYPE 2 ACTION (_nOpc:=2,_oSenha:END()) ENABLE OF _oSenha
	
	ACTIVATE DIALOG _oSenha CENTERED

	If _nOpc == 1
		If !Empty(_cGet4)
			SX6->(dbSetOrder(1))
			If SX6->(msSeek(cFilAnt+"PXH_SENBLQ"))
				SX6->(RecLock("SX6",.F.))
				SX6->X6_CONTEUD := Alltrim(_cGet3)
				SX6->(MsUnlock())
				
				MSGINFO("Senha Alterada com sucesso!")
			Endif
		Else
			MSGSTOP("Nova senha incorreta!")
		Endif
	Endif

Return(_lRet)


Static Function VerSenha()

	If AllTrim(_cSenDig) == Alltrim(_cSenPad) //.And. !Empty(_cSenDig)
		_lRet :=.T.
	Else
		MSGSTOP( "Senha incorreta" )
		_lRet :=.F.
	Endif

Return(_lRet)


Static Function VerSenha2()

	_lRet :=.F.
	If (AllTrim(_cGet3) == Alltrim(_cGet4)) .And. !Empty(_cGet3)
		_lRet :=.T.
	Else
		MSGSTOP( "Nova Senha incorreta" )
	Endif

Return(_lRet)

/*
STATIC FUNCTION PXH76ITEM()

	Local _stru			:= {}
	Local aCpoBro 		:= {}
	Local aCores 		:= {}

	Private _oDlg1
	Private lInverte 	:= .F.
	Private cMark   	:= GetMark()   
	Private oMark
	Private _cIt    	:= Space(2)
	Private _lGo		:= .F.

	AADD(_stru,{"OK"     	,"C"	,2		,0		})
	AADD(_stru,{"ITEM"    	,"C"	,2		,0		})
	AADD(_stru,{"PRODUTO"   ,"C"	,15		,0		})
	AADD(_stru,{"DESCRIC"   ,"C"	,20		,0		})
	AADD(_stru,{"ENTREGA" 	,"D"	,8		,0		})
	AADD(_stru,{"QTDVEN"	,"N"	,12		,2		})
	AADD(_stru,{"QTDENT"	,"N"	,12		,2		})
	AADD(_stru,{"UNIT"    	,"N"	,12		,2		})
	AADD(_stru,{"TOTAL" 	,"N"	,12		,2		})
	AADD(_stru,{"STATUS" 	,"C"	,1		,0		})

	cArq:=Criatrab(_stru,.T.)
	_cIndTrb := "ITEM"
	DBUSEAREA(.t.,,carq,"TTRB")

	dbSelectArea("TTRB")
	IndRegua("TTRB",cArq,_cIndTrb,,,"Criando Trabalho...")

	SC6->(dbSetOrder(1))
	SC6->(msSeek(xFilial('SC6')+SC5->C5_NUM))

	While  SC6->(!Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM == SC5->C5_FILIAL+SC5->C5_NUM	

		TTRB->(RecLock("TTRB",.T.))		
		TTRB->ITEM    :=  SC6->C6_ITEM		
		TTRB->PRODUTO :=  SC6->C6_PRODUTO		
		TTRB->DESCRIC :=  SC6->C6_DESCRI	
		TTRB->ENTREGA :=  SC6->C6_ENTREG	
		TTRB->QTDVEN  :=  SC6->C6_QTDVEN		
		TTRB->QTDENT  :=  SC6->C6_QTDENT		
		TTRB->UNIT 	  :=  SC6->C6_PRCVEN		
		TTRB->TOTAL	  :=  SC6->C6_VALOR	
		If SC6->C6_QTDVEN > SC6->C6_QTDENT
			If Empty(SC6->C6_BLQ)
				TTRB->STATUS  := "1"    //Verde
			Else
				TTRB->STATUS  := "3"    //Amarelo
			Endif
		Else
			TTRB->STATUS  := "2"    //Vermelho
		Endif
		TTRB->(MsunLock())	

		SC6->(DbSkip())
	Enddo//Define as cores dos itens de legenda.

	aCores := {}
	aAdd(aCores,{"TTRB->STATUS == '1'","BR_VERDE"	})
	aAdd(aCores,{"TTRB->STATUS == '2'","BR_VERMELHO"})
	aAdd(aCores,{"TTRB->STATUS == '3'","BR_AMARELO"})

	//Define quais colunas (campos da TTRB) serao exibidas na MsSelect

	aCpoBro	:= {;
	{ "OK"			,, " "           	,"@!"},;
	{ "ITEM"		,, "Item"         	,"@!"},;
	{ "PRODUTO"		,, "Codigo"         ,"@!"},;
	{ "DESCRIC"		,, "Descrição"      ,"@!"},;
	{ "ENTREGA"		,, "Dt. Entrega"    ,"@!"},;
	{ "QTDVEN"		,, "Quantidade"     ,"@E 999,999,999.99"},;
	{ "QTDENT"		,, "Entregue"   	,"@E 999,999,999.99"},;
	{ "UNIT"		,, "Unitário"   	,"@E 999,999,999.99"},;
	{ "TOTAL"		,, "Total"   		,"@E 999,999,999.99"}}

	//Cria uma Dialog

	_cTit := 'Itens Pedido'

	DEFINE MSDIALOG _oDlg1 TITLE _cTit From 0,0 To 400,850 PIXEL

	@ 05, 10 SAY "Pedido: " 				Size 020,010 OF _oDlg1 PIXEL
	@ 05, 35 MsGet SC5->C5_NUM  When .F.   	Size 040,008 Of _oDlg1 Pixel

	_cCli := SC5->C5_CLIENTE+'/'+SC5->C5_LOJAENT+' - '+Alltrim(Posicione('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJAENT,"A1_NOME"))

	@ 05, 90 SAY "Cliente: " 				Size 020,010 OF _oDlg1 PIXEL
	@ 05, 115 MsGet _cCli  		When .F.   	Size 140,008 Of _oDlg1 Pixel

	TTRB->(DbGotop())

	oMark := MsSelect():New("TTRB","OK","",aCpoBro,@lInverte,@cMark,{17,1,150,400},,,,,aCores)

	oMark:bMark := {| | Disp()} //Exibe a Dialog

	ACTIVATE MSDIALOG _oDlg1 CENTERED ON INIT EnchoiceBar(_oDlg1,{|| If(_lGo,_oDlg1:End(),MsgAlert('Nenhum Item marcado!'))},{|| _cIt := Space(2),_oDlg1:End()})

	//Fecha a Area e elimina os arquivos de apoio criados em disco.
	TTRB->(DbCloseArea())

	Iif(File(cArq + GetDBExtension()),FErase(cArq  + GetDBExtension()) ,Nil)

RETURN(_cIt)



Static Function Disp()

	_cIt := TTRB->ITEM
	_lGo := .F.

	TTRB->(dbGotop())

	WHILE !TTRB->(EOF())

		If TTRB->STATUS = '3'

			TTRB->(RecLock("TTRB",.F.))
			If TTRB->ITEM = _cIt
				If Marked("OK")
					TTRB->OK := cMark
					_lGo := .T.
				Endif
			Else
				TTRB->OK := ""
			Endif
			TTRB->(MSUNLOCK())
		ELse
			If TTRB->ITEM = _cIt
				If TTRB->STATUS $ '1'
					MsgAlert('Item sem Bloqueio!')
				Else
					MsgAlert('Item já Faturado!')				
				Endif
			Endif			

			TTRB->(RecLock("TTRB",.F.))
			TTRB->OK := ""
			TTRB->(MSUNLOCK())
		Endif

		TTRB->(dbskip())
	EndDo

	oMark:oBrowse:Refresh()

	If !_lGo
		_cIt := Space(2)
	Endif

Return()
*/