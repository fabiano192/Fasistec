#Include 'Totvs.ch'

/*
Ponto de Entrada	:	MNTA280BT
Autor				:	Fabiano da Silva
Data				:	11/08/15
Descri��o			:	Ponto de Entrada que adiciona bot�es na rotina de Solicita��o de Servi�o.
Link TDN			:	http://tdn.totvs.com/pages/releaseview.action?pageId=6793713
*/
User Function MNTA280BT()

	Local aRet   := {}

	aAdd( aRet , { "Imprimir",   "U_ChkMntr120()"   , 0 , 6} )

Return aRet



//Fun��o chamada pelo Ponto de Entrada MNTA280BT
User Function ChkMntr120()

	Local aImpSS := {}

	If MsgYesNo("Deseja Imprimir a SS: "+TQB->TQB_SOLICI+" ?")
		AAdd(aImpSS, {TQB->TQB_FILIAL, TQB->TQB_SOLICI})

		MNTR120(aImpSS)
	Endif

Return(nil)


/*
Ponto de Entrada	:	MNTA280E
Autor				:	Fabiano da Silva
Data				:	12/08/15
Descri��o			:	Ponto de entrada possibilita ao cliente, validar se pode excluir as solicita��es de servi�o.
Link TDN			:	http://tdn.totvs.com/pages/releaseview.action?pageId=118885622
*/
User Function MNTA280E()

	Local _lRet := .T.

	If !FwIsAdmin() //Verifica se o usuario � administrador
		MsgAlert( "N�o � permitido a exclus�o de Solicita��o de Servi�o, contate o Administrador!" )
		_lRet := .F.
	EndIf

Return(_lRet)



/*
Ponto de Entrada	:	IMPOSMNT
Autor				:	Fabiano da Silva
Data				:	01/10/15
Descri��o			:	Este ponto de entrada, chamado ap�s a gera��o de uma Ordem de Servi�o com situa��o de liberada, tem o objetivo de fazer a chamada de um relat�rio padr�o ou espec�fico do cliente, para a impress�o da Ordem de Servi�o que foi inclusa.
Link TDN			:	http://tdn.totvs.com/pages/releaseview.action;jsessionid=09BA5672B14E496120A0C9BB87D1C95A?pageId=6793740
*/
User Function IMPOSMNT(lVPERG,cDEPLANO,cATEPLANO,aMATOS,nTipo,avMatSX1,nRecOs)

	U_MNTR675(lVPERG,cDEPLANO,cATEPLANO,aMATOS,nTipo,avMatSX1,nRecOs)

Return(.T.)



/*
Ponto de Entrada	:	MNTA9902
Autor				:	Fabiano da Silva
Data				:	30/09/15
Descri��o			:	Ponto de entrada para adicionar campos no browse de O.S a programar
Link TDN			:	http://tdn.totvs.com/pages/releaseview.action?pageId=187532080
*/

User Function MNTA9902()

	//Carrega variaveis de Entrada e Saida
	aTRB1	:= ParamIXB[1]
	aDBF 	:= ParamIXB[2]
	aTRB2	:= ParamIXB[3]
	aDBFa	:= ParamIXB[4]

	nPosDBF := aScan( aDBF ,{ |x| Upper(Alltrim(x[1])) == "YDESMNT" } )
	If nPosDBF = 0
		aSize( aDBF, Len( aDBF ) + 1 )
		aIns( aDBF, 3 )
		aDBF[3] := { "YDESMNT", "C", 40, 0 }
	EndIf

	nPOsAtu := aScan( aTRB1,{ |x| Upper(Alltrim(x[1])) == "YDESMNT" } )
	If nPOsAtu = 0
		aSize( aTRB1, Len( aTRB1 ) + 1 )
		aIns( aTRB1, 3 )
		aTRB1[3] := { "YDESMNT", Nil, "Descri��o Manuten��o" }
	EndIf

	nPosDBF := aScan( aDBFa, {|x| upper(x[1]) == "YDESMNT" } )
	If nPosDBF = 0
		aSize( aDBFa, Len( aDBFa ) + 1 )
		aIns( aDBFa, 3  )
		aDBFa[3] := { "YDESMNT", "C", 40, 0 }
	EndIf

	nPOsAtu := aScan( aTRB2,{ |x| Upper(Alltrim(x[1])) == "YDESMNT" } )
	If nPOsAtu = 0
		aSize( aTRB2, Len( aTRB2 ) + 1 )
		aIns( aTRB2, 3 )
		aTRB2[3] := { "YDESMNT", Nil, "Descri��o Manuten��o" }
	EndIf



	nPosDBF := aScan( aDBF  ,{ |x| Upper(Alltrim(x[1])) == "BEMPAI" } )
	If nPosDBF = 0
		aSize( aDBF, Len( aDBF ) + 1 )
		aIns( aDBF, 3 )
		aDBF[3] := { "BEMPAI", "C", TamSx3('TC_CODBEM')[1], 0 }
	EndIf

	nPOsAtu := aScan( aTRB1,{ |x| Upper(Alltrim(x[1])) == "BEMPAI" } )
	If nPOsAtu = 0
		aSize( aTRB1, Len( aTRB1 ) + 1 )
		aIns( aTRB1, 3 )
		aTRB1[3] := { "BEMPAI", Nil, "Bem Pai" }
	EndIf

	nPosDBF := aScan( aDBFa, {|x| upper(x[1]) == "BEMPAI" } )
	If nPosDBF = 0
		aSize( aDBFa, Len( aDBFa ) + 1 )
		aIns( aDBFa, 3  )
		aDBFa[3] := { "BEMPAI", "C", TamSx3('TC_CODBEM')[1], 0 }
	EndIf

	nPOsAtu := aScan( aTRB2,{ |x| Upper(Alltrim(x[1])) == "BEMPAI" } )
	If nPOsAtu = 0
		aSize( aTRB2, Len( aTRB2 ) + 1 )
		aIns( aTRB2, 3 )
		aTRB2[3] := { "BEMPAI", Nil, "Bem Pai" }
	EndIf

Return




/*
Ponto de Entrada	:	MNTA9904
Autor				:	Fabiano da Silva
Data				:	30/09/15
Descri��o			:	Carrega campos criado pelo ponto de entrada MNTA9902
Link TDN			:	http://tdn.totvs.com/display/public/mp/MNTA9904+-+Carrega+campos+criado+pelo+ponto+de+entrada+MNTA9902;jsessionid=808ED2ED9E1E8B0D8EB83698AF535973
*/
User Function MNTA9904()

	//Carrega vari�veis de Entrada e Sa�da
	c990TRB1 := ParamIXB[1]

	cChvSTF := If( NgVerify("STJ") , (c990TRB1)->SEQRELA , Str((c990TRB1)->SEQUENC,3) )

	aTam := TamSX3("TF_NOMEMAN")
	_cDescMnt := Space(aTam[1])

	STF->(dbSetOrder(1))
	If STF->(msSeek(xFilial("STF")+(c990TRB1)->CODBEM+(c990TRB1)->CODSER+cChvSTF))
		_cDescMnt := STF->TF_NOMEMAN
	EndIf

	(c990TRB1)->YDESMNT := _cDescMnt


	_cBemPai := Space(TamSX3("TC_CODBEM")[1])
	STC->(dbSetOrder(3))
	If STC->(MsSeek(xFilial("STC")+(c990TRB1)->CODBEM))
		_cBemPai := STC->TC_CODBEM
	Endif

	(c990TRB1)->BEMPAI := _cBemPai

Return



/*
Ponto de Entrada	:	MNTA9905
Autor				:	Fabiano da Silva
Data				:	30/09/15
Descri��o			:	MNTA9905 - Carrega campos do ponto de entrada MNTA9902 na altera��o da Programa��o
Link TDN			:	http://tdn.totvs.com/display/public/mp/MNTA9904+-+Carrega+campos+criado+pelo+ponto+de+entrada+MNTA9902;jsessionid=808ED2ED9E1E8B0D8EB83698AF535973
*/
User Function MNTA9905()


	//Carrega vari�veis de Entrada e Sa�da
	c990TRB1 := ParamIXB[1]

	cChvSTF := If( NgVerify("STJ"),(c990TRB1)->SEQRELA,Str((c990TRB1)->SEQUENC,3) )

	aTam := TamSX3("TF_NOMEMAN")
	_cDescMnt := Space(aTam[1])

	STF->(dbSetOrder(1))
	If STF->(msSeek(xFilial("STF")+(c990TRB1)->CODBEM+(c990TRB1)->CODSER+cChvSTF))
		_cDescMnt := STF->TF_NOMEMAN
	EndIf

	(c990TRB1)->YDESMNT := _cDescMnt

	_cBemPai := Space(TamSX3("TC_CODBEM")[1])
	STC->(dbSetOrder(3))
	If STC->(MsSeek(xFilial("STC")+(c990TRB1)->CODBEM))
		_cBemPai := STC->TC_CODBEM
	Endif

	(c990TRB1)->BEMPAI := _cBemPai

Return



/*
Ponto de Entrada	:	MNTA9906
Autor				:	Fabiano da Silva
Data				:	14/08/18
Descri��o			:	Carrega campos criado pelo ponto de entrada MNTA9902
Link TDN			:	http://tdn.totvs.com/pages/releaseview.action?pageId=42041593
*/
User Function MNTA9906()


	//Carrega vari�veis de Entrada e Sa�da
	c990TRB3 := ParamIXB[1]

	cChvSTF := If( NgVerify("STJ"),(c990TRB3)->SEQRELA,Str((c990TRB3)->SEQUENC,3) )

	aTam := TamSX3("TF_NOMEMAN")
	_cDescMnt := Space(aTam[1])

	STF->(dbSetOrder(1))
	If STF->(msSeek(xFilial("STF")+(c990TRB3)->CODBEM+(c990TRB3)->CODSER+cChvSTF))
		_cDescMnt := STF->TF_NOMEMAN
	EndIf

	//Carrega o campo de usu�rio criado pelo ponto de entrada MNTA9902
	(c990TRB3)->YDESMNT := _cDescMnt


	_cBemPai := Space(TamSX3("TC_CODBEM")[1])
	STC->(dbSetOrder(3))
	If STC->(MsSeek(xFilial("STC")+(c990TRB3)->CODBEM))
		_cBemPai := STC->TC_CODBEM
	Endif

	(c990TRB3)->BEMPAI := _cBemPai

Return



/*
Ponto de Entrada	:	MNTA990A
Autor				:	Fabiano da Silva
Data				:	30/09/15
Descri��o			:	Ponto de Entrada que inclui novo campo na rotina de Progtrama��o de OS.
Link TDN			:	http://tdn.totvs.com/pages/releaseview.action?pageId=134152333
*/
User Function MNTA990A()

	Local cEstrut := Space(4)

	@ nwVerBt1,138 Button "Etapas" Size 40,10 Of oPanelBAll Pixel Action U_MZ0180()

Return cEstrut


/*
Ponto de Entrada	:	MNTA420I
Descri��o			:	Ponto de entrada que possibilita a cria��o de um bot�o espec�fico no mbrowse de ordem de servi�o corretiva. Deve ser passado como par�metro o aRotina.
*/
User Function MNTA420I()

	Local aRot := aClone(ParamIXB[1])

	aAdd(aRot,{"Relat�rio OS", "U_MNTR675A()" , 0 , 9,0})

Return aRot



/*
Ponto de Entrada	:	MNTA400I
Descri��o			:	Ponto de entrada que adiciona bot�es na rotina de retorno de ordem de servi�o. Deve ser passado como par�metro o aRotina.
*/
User Function MNTA400I()

	Local aRot := aClone(ParamIXB[1])

	aAdd(aRot,{"Relat�rio OS","U_MNTR675A()" ,0,4,,.F.})

Return aRot



/*
Ponto de Entrada	:	MNTA420J
Descri��o			:	Ponto de entrada para ajustar o campo TJ_TIPOOS na abertura de OS de Localiza��o.
*/
User Function MNTA420J()

	Local _aAreaST9 := ST9->(GetArea())

	If UPPER(Alltrim(FUNNAME())) == "MNTA902"
		dbSelectArea("ST9")
		ST9->(dbSetOrder(1))
		If !ST9->(msSeek(xFilial("ST9")+M->TJ_CODBEM))
			M->TJ_TIPOOS := "L"
		Endif
	Endif

	RestArea(_aAreaST9)

Return
