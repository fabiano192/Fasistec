#include "Totvs.ch"
#include "Topconn.ch"
#include "TbiConn.ch"

/*
Programa	:	CR0057
Autor		:	Fabiano da Silva
Data		:	07/05/2014
:	24/07/2017
Descrição	:	Programa para gerar OP's conforme arquivo .CSV
Obs			:	Alterado o programa para gerar OP conforme os pedidos do sistema.
Revisão		:	02
*/

User Function CR0057(lAut)

	Local _oDlg := Nil
	Local _lAut := lAut <> Nil

//	If !_lAut

//		nOpc := 0
//
//		DEFINE MSDIALOG _oDlg TITLE "Gerar OP" FROM 0,00 TO 185,330 OF oMainWnd PIXEL
//
//		@ 004,008 TO 070,160 LABEL "" OF _oDlg PIXEL
//
//		@ 010 , 010 SAY "Este programa tem o objetivo de gerar OPs conforme os " 	OF _oDlg PIXEL
//		@ 020 , 010 SAY "Pedidos no sistema."										OF _oDlg PIXEL
//
//		@ 055,065 BUTTON "Sair" 		SIZE 030, 010 OF _oDlg PIXEL ACTION (nOpc := 0,_oDlg:End())
//		@ 055,120 BUTTON "Gerar" 		SIZE 030, 010 OF _oDlg PIXEL ACTION (nOpc := 1,_oDlg:End())
//
//		ACTIVATE MSDIALOG _oDlg CENTERED
//
//		If nOpc == 1
//			LjMsgRun('Gerando OP.','Aguarde...',{||GeraOPAux(_lAut)})
//		Endif
//	Else
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

		GeraOPAux(_lAut)
//	Endif

Return



//Função auxiliar para gerar a regua
Static Function GeraOPAux(_lAut)

	If Select("TRB_C2") > 0
		TRB_C2->(dbCloseArea())
	Endif

	_cQuery := " SELECT C2_PRODUTO AS PRODUTO,SUM(C2_QUANT-C2_QUJE) AS SALDO FROM "+RetSqlName("SC2")+" C2 " + CRLF
	_cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 ON C2_PRODUTO = B1_COD " + CRLF
	_cQuery += " WHERE C2.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' " + CRLF
	_cQuery += " AND B1_TIPO = 'PA' " + CRLF
	_cQuery += " AND C2_DATRF = '' " + CRLF
	_cQuery += " GROUP BY C2_PRODUTO " + CRLF

//	Memowrite("D:/CR057A.txt",_cQuery)

	TCQUERY _cQuery NEW ALIAS "TRB_C2"

	dbSelectArea("TRB_C2")

	_cArq2 := CriaTrab(NIL,.F.)
	Copy To &_cArq2

	dbCloseArea()

	dbUseArea(.T.,,_cArq2,"TRB_C2",.T.)
	_cInd := "PRODUTO"
	IndRegua("TRB_C2",_cArq2,_cInd,,,"Gerando Arquivo Trabalho")


	If Select("TSC6") > 0
		TSC6->(dbCloseArea())
	Endif

	_cPed := " SELECT C6_PRODUTO,SUM(C6_QTDVEN-C6_QTDENT) AS QTDE FROM "+RetSqlName("SC6")+" C6 " +CRLF
	_cPed += " INNER JOIN "+RetSqlName("SC5")+" C5 ON C6_NUM = C5_NUM " +CRLF
	_cPed += " INNER JOIN "+RetSqlName("SF4")+" F4 ON C6_TES = F4_CODIGO " +CRLF
	_cPed += " WHERE C6.D_E_L_E_T_ = '' AND C5.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' " +CRLF
	_cPed += " AND C6_FILIAL = '"+xFilial("SC6")+"' " +CRLF
	_cPed += " AND C5_FILIAL = '"+xFilial("SC5")+"' " +CRLF
	_cPed += " AND F4_FILIAL = '"+xFilial("SF4")+"' " +CRLF
	_cPed += " AND C5_TIPO = 'N' " +CRLF
	_cPed += " AND F4_ESTOQUE = 'S' " +CRLF
	_cPed += " AND C6_BLQ <> 'S' " +CRLF
	_cPed += " AND C6_QTDVEN > C6_QTDENT " +CRLF
	_cPed += " AND C6_PEDAMOS IN ('N','A') " +CRLF
	_cPed += " GROUP BY C6_PRODUTO " +CRLF
	_cPed += " ORDER BY C6_PRODUTO " +CRLF

//	Memowrite("D:/CR057B.txt",_cPed)

	TcQuery _cPed New Alias "TSC6"

	TSC6->(dbgoTop())

	While TSC6->(!EOF())

		_nQtde := Round(TSC6->QTDE * (GETMV("CR_OPPERDA") / 100) + TSC6->QTDE,0)

		SB1->(dbsetOrder(1))
		SB1->(msSeek(xFilial('SB1')+TSC6->C6_PRODUTO))

		If SB1->B1_MSBLQL != '1' .And. SB1->B1_FANTASM != "S" .And. SB1->B1_TIPO = "PA"
			dbSelectArea("TRB_C2")
			If TRB_C2->(msSeek(TSC6->C6_PRODUTO))
				_nQtde -= TRB_C2->SALDO
			Endif

			If _nQtde > 0

				cNumOp := GetNumSC2()

				aVetor :={ 	{"C2_NUM" 		,cNumOp 			,NIL},;
				{"C2_ITEM" 		,"01" 				,NIL},;
				{"C2_SEQUEN" 	,"001" 				,NIL},;
				{"C2_PRODUTO" 	,SB1->B1_COD 		,NIL},;
				{"C2_LOCAL" 	,SB1->B1_LOCPAD 	,Nil},;
				{"C2_QUANT" 	, _nQtde			,NIL},;
				{"C2_DATPRI" 	,dDatabase 			,NIL},;
				{"AUTEXPLODE"	,"S" 				,NIL},;
				{"C2_DATPRF" 	,dDatabase+365 		,NIL}}
				//			{"C2_XDTPREV" 	,cToD(aLin[3]) 		,NIL},;
				//			{"C2_OBS" 		,Alltrim(aLin[4]) 	,NIL}}

				lMSHelpAuto := .T.
				lMsErroAuto := .F.

				MSExecAuto({|x,y| mata650(x,y)},aVetor,3) //Inclusao

				If lMsErroAuto //.And. _lAut
					MostraErro()
				Endif

			Endif
		Endif

		TSC6->(dbskip())

	EndDo

	TRB_C2->(dbCloseArea())
	TSC6->(dbCloseArea())

Return
