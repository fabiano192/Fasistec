#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "RWMAKE.CH" 	//MARCUS VINICIUS - 13/11/2018
#INCLUDE "TBICONN.CH"	//MARCUS VINICIUS - 13/11/2018

/*
Função			:	MZ0097
Autor			:	Alexandro  Silva
Data 			: 	17.07.2012
Descrição		: 	Inventario Rotativo
*/

User Function MZ0097(_cMd)

	LOCAL oDlg := NIL

	Private _cModo

	If _cMd == Nil
		//_cModo := {2}
		_cModo := {1}  // MANUALMENTE
	Else
		_cModo := _cMd
	Endif

	PRIVATE cTitulo    	:= "Inventario Rotativo"
	Private _dFirstD,_dLastD
	Private cPerg   	:= "MZ0097"
	Private cNomeArq

	If _cModo[1] == 2

		_aEmp := {cEmpAnt+cFilant}
		_nOpc := 0
		DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

		@ 010,017 SAY "Esta rotina tem por objetivo gerar os Registros  " OF oDlg PIXEL Size 150,010
		@ 020,017 SAY "que ainda nao Foram Inventariados conforme ultima" OF oDlg PIXEL Size 150,010
		@ 040,017 SAY "Selecao.                                         " OF oDlg PIXEL Size 150,010

		@ 50,167 BUTTON "OK" 		  SIZE 036,012 ACTION (_nOpc := 1,oDlg:End()) 	OF oDlg PIXEL
		@ 65,167 BUTTON "Sair"        SIZE 036,012 ACTION ( oDlg:End()) 				OF oDlg PIXEL

		ACTIVATE MSDIALOG oDlg CENTERED

		If _nOpc = 1
			Private _cMsg01    := ''
			Private _lFim      := .F.
			Private _lAborta01 := .T.
			Private _bAcao01       := {|_lFim| U_MZ97A(@_lFim) }    /// PARAMETROS
			Private _cTitulo01 := 'Processando...'
			Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

		Endif
	Else
		//			   MZVI   PXMN   PXBA  	PXPA   PXIB   PXAB   PXMO
		//_aEmp := {"0101","0203","0210","0213","0216","0218","0223","0226"}
		_aEmp := {"0203","0210","0213","0216","0218","0223","0226"}
		//_aEmp := {"0101"}

		U_MZ97A()
	Endif

Return(Nil)

User Function MZ97A()

	Private cMailConta	:= NIL
	Private cMailServer	:= NIL
	Private cMailSenha	:= NIL
	Private _cAnexo
	Private cMailFrom
	Private lMailAuth
	//Private _cDirDocs   := MsDocPath()

	For AX:= 1 to Len(_aEmp)

		_cEmpresa := _aEmp[AX]
		_cFilial  := Substr(_aEmp[AX],3,2)

		If Select('SM0')>0
			nRecno := SM0->(Recno())
			RpcClearEnv()
		Endif

		OpenSM0()

		IF SM0->(DBSEEK(left(_cEmpresa, 4) , .F. ) )
			RpcSetType(3)
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL,'schedule','schedule','FIN',,{"ZAF","SB1","SB2","SBM","SBZ","ZZG"})
		ELSE
			CONOUT("NAO ACHOU EMPRESA ...")
			SM0->(DBGOTOP())
			DBCLOSEALL()
			RpcClearEnv()
		ENDIF

		CONOUT("SETADA EMPRESA : "+_cEmpresa)
		CONOUT("ROTINA --> MZ0097 :"+DTOS(DDATABASE)+" HORA: "+TIME())

		_cQuery := " SELECT TOP 1 * FROM "+RetSqlName("ZAF")+" "
		_cQuery += " WHERE ZAF_FILIAL = '"+xFilial("ZAF")+"' "
		_cQuery += " ORDER BY ZAF_FILIAL DESC, ZAF_CODIGO DESC "

		TCQUERY _cQuery NEW ALIAS "ZZAF"

		Count to _nRec

		ZZAF->(dbGoTop())

		If _nRec = 0
			_cControle := Left(Dtos(dDataBase),4) + "000001"
		Else
			_cControle := Left(Dtos(dDataBase),4) + Soma1(RIGHT(ZZAF->ZAF_CODIGO,6))
		Endif

		ZZAF->(dbCloseArea())

		_nQtInv   := GETMV("MZ_QTDINV")
		_nDiaHora := Day(dDataBase) + Val(Left(Time(),2))
		_nSeq     := Day(dDataBase) + 300 + Val(Substr(Time(),4,2))
		_nCont    := 0

		SBZ->(dbSetOrder(1))
		SBZ->(dbSeek(xFilial("SBZ")))

		_lTodos  := .T.
		_cSeqSBZ := "000001"

		While SBZ->(!Eof()) .And. SBZ->BZ_FILIAL = _cFilial

			SBZ->(RecLock("SBZ",.F.))
			SBZ->BZ_YORDEM := _cSeqSBZ
			SBZ->(MsUnlock())

			If Empty(SBZ->BZ_YSEQINV)
				_lTodos := .F.
			Endif

			_cSeqSBZ := Soma1(_cSeqSBZ)

			SBZ->(dbSkip())
		EndDo

		//CONOUT("MZ0097 LINHA 152: "+_cEmpresa+" - "+TIME())

		_lInvent := .F.

		For Azz:= 1 TO 2

			If _lTodos
				_cq := "UPDATE "+RetSqlName("SBZ")+" SET BZ_YSEQINV = '' WHERE D_E_L_E_T_ = '' AND BZ_FILIAL = '"+xFilial("SBZ")+"' "

				TcSQLExec(_cQ)
			Endif

			_cq := "SELECT MAX(BZ_YSEQINV) AS ULTSBZ FROM "+RetSqlName("SBZ")+" A WHERE A.D_E_L_E_T_ = '' AND BZ_FILIAL = '"+xFilial("SBZ")+"' "

			TCQUERY _cQ NEW ALIAS "ZZ"

			If Empty(ZZ->ULTSBZ)
				_cUltSBZ := "0000001"
			Else
				_cUltSBZ := StrZero(Val(ZZ->ULTSBZ)+1,7)
			Endif

			ZZ->(dbCloseArea())

			SBZ->(dbOrderNickName("INDSBZ1"))
			SBZ->(dbseek(xFilial(_cFilial)))

			_nCont   := 0

			//CONOUT("MZ0097 LINHA 183: "+_cEmpresa+" - "+TIME())

			ProcRegua(_nQtInv)

			For AZ:= 1 TO _nQtInv

				IncProc()

				SBZ->(dbOrderNickName("INDSBZ1"))
				If SBZ->(dbSeek(_cFilial+StrZero(_nSeq,6)))

					SB1->(dbSetorder(1))
					SB1->(dbSeek(xFilial("SB1")+SBZ->BZ_COD))

					If SB1->B1_TIPO $ "PA/PI/MP" .OR. SB1->B1_YINVROT == "2"
						AZ--
						_nSeq ++
						_nCont++

						If _nCont == Val(_cSeqSBZ)
							Exit
						Endif

						If _nSeq >= Val(_cSeqSBZ)
							_nSeq := 1
						Endif

						Loop
					Endif

					SB2->(dbSetorder(1))
					If SB2->(!dbSeek(xFilial("SB2")+SBZ->BZ_COD)) .Or. SBZ->BZ_YINVROT == "2"
						AZ--
						_nSeq ++
						_nCont++

						If _nCont == Val(_cSeqSBZ)
							Exit
						Endif

						If _nSeq >= Val(_cSeqSBZ)
							_nSeq := 1
						Endif

						Loop
					Else
						If SB2->B2_QATU <= 0
							AZ--
							_nSeq ++
							_nCont++

							If _nCont == Val(_cSeqSBZ)
								Exit
							Endif

							If _nSeq >= Val(_cSeqSBZ)
								_nSeq := 1
							Endif

							Loop
						Endif
					Endif

					If !Empty(SBZ->BZ_YSEQINV)
						AZ--
						_nSeq ++
						_nCont++

						If _nCont == Val(_cSeqSBZ)
							Exit
						Endif

						If _nSeq >= Val(_cSeqSBZ)
							_nSeq := 1
						Endif

						Loop
					Endif

					ZZG->(dbSetorder(1))
					If ZZG->(dbSeek(xFilial("ZZG") + SB1->B1_SUBGRUP))
						If ZZG->ZZG_INVROT == "2"
							AZ--
							_nSeq ++
							_nCont++

							If _nCont == Val(_cSeqSBZ)
								Exit
							Endif

							If _nSeq >= Val(_cSeqSBZ)
								_nSeq := 1
							Endif

							Loop
						Else
							SBM->(dbSetorder(1))
							If SBM->(dbSeek(xFilial("SBM")+SB1->B1_GRUPO))
								If SBM->BM_YINVROT == "2"
									AZ--
									_nSeq ++
									If _nSeq >= Val(_cSeqSBZ)
										_nSeq := 1
									Endif

									Loop
								Endif
							Endif
						Endif
					Endif

					_nCont:= 0
					_nSeq += 100

					//CONOUT("MZ0097 LINHA 297: "+_cEmpresa+" - "+TIME())

					_lInvent := .T.
					ZAF->(dbSetOrder(2))
					If ZAF->(!dbSeek(xFilial("ZAF") + SBZ->BZ_COD + _cControle))
						ZAF->(RecLock("ZAF",.T.))
						ZAF->ZAF_FILIAL := xFilial("ZAF")
						ZAF->ZAF_CODIGO := _cControle
						ZAF->ZAF_PRODUT := SBZ->BZ_COD
						ZAF->ZAF_ALMOX  := SB1->B1_LOCPAD
						ZAF->ZAF_DESC   := SB1->B1_DESC
						ZAF->ZAF_GRUPO  := SB1->B1_GRUPO
						ZAF->ZAF_DESGR  := SBM->BM_DESC
						ZAF->ZAF_SUBGR 	:= SB1->B1_SUBGRUP
						ZAF->ZAF_DESUBG := ZZG->ZZG_DESGRP
						ZAF->ZAF_DTINV  := dDataBase
						ZAF->ZAF_DOC    := "I"+DTOS(dDataBase)
						ZAF->ZAF_PRAT   := SBZ->BZ_YPRAT
						ZAF->(MsUnLock())
					Endif

					SBZ->(RecLock("SBZ",.F.))
					SBZ->BZ_YSEQINV := _cUltSBZ
					SBZ->(MsUnlock())

				Endif

				If _nSeq > Val(_cSeqSBZ)
					_nSeq := _nSeq - Val(_cSeqSBZ)
				Endif

			Next AZ

			If _lInvent
				AZZ:= 2
			Endif

			_lTodos := .T.
		Next AZZ

		//CONOUT("MZ0097 LINHA 337: "+_cEmpresa+" - "+TIME())

		_cQ := " SELECT '"+_cEmpresa+"' AS EMPRESA,ZAF_PRODUT AS PRODUTO,ZAF_ALMOX AS LOCAL ,ZAF_DESC AS DESCRIC,ZAF_PRAT AS PRATILEIRA,' ' AS PRIM_CONT,'' AS SEG_CONT FROM "+RetSqlName("ZAF")+" A "
		_cQ += " WHERE D_E_L_E_T_ = '' AND ZAF_CODIGO = '"+_cControle+"' AND ZAF_FILIAL = '"+_cFilial+"' "
		_cQ += " ORDER BY ZAF_PRODUT "

		TCQUERY _cQ NEW ALIAS "ZZ"

		//CONOUT(_cQ)

		Private _aCabec := {}
		Private _aItens := {}

		aCols    := MZ97C()//, aDeletados)

		_cArqNew := "\SPOOL\INV_"+_cEmpresa+"_"+DTOS(DDATABASE)+".CSV"

		//CONOUT(_cArqNew)
		cMailSenha	:= GetMv("MV_MAILSEN")               // GETMV("MZ_RELAPSW")

		U_GERAEXCEL({{"GETDADOS","Inventário Relatorio SYS", _aCabec, _aItens,_cArqNew}})

//		ZZ->(dbCloseArea())

		_cAnexo:= "\SPOOL\INV_"+_cEmpresa+"_"+DTOS(DDATABASE)+".CSV"

		U_MZ97B()

	Next AX

Return


User Function MZ97B(cSubject,cMensagem,cEMail,aFiles)

	Local lOk    := .F.			// Variavel que verifica se foi conectado OK
	Local lResult:= .F.			// Variavel que verifica se foi conectado OK

	cMailConta	:= "inventario.rotativo@mizu.com.br" // GETMV("MZ_RELACNT")
	cMailFrom 	:= "inventario.rotativo@mizu.com.br" // GETMV("MZ_RELFROM")
	cMailServer	:= "smtp.mizu.com.br:587"            // GETMV("MZ_RELSERV")
	cMailSenha	:= GetMv("MV_MAILSEN")               // GETMV("MZ_RELAPSW")
	lMailAuth	:= .T.	                             // GETMV("MZ_RELAUTH")

	// Alterado pois estamos utilizando o grupo de email de inventário pelo Microsoft Exchange, caso precise acrescentar mais destinatários, inclua pelo office 365.
	_cEmail := GetMv("MV_MAILINV")//+";alexandro@assystem.com.br"
	//_cEmail := "alexandro@assystem.com.br"

	cSubject    := "INVENTARIO ROTATIVO"

	/*_cEmail     := ""

	/*ZAG->(dbSetOrder(1))
	ZAG->(dbGotop())

	CONOUT(RetSQLName("ZAG"))

	While ZAG->(!Eof())

	If ZAG->ZAG_FILIAL = xFilial("ZAG")
	_cEmail += Alltrim(ZAG->ZAG_EMAIL)+";"
	Endif

	ZAG->(dbSkip())
	EndDo
	*/

	CONOUT(_cEmail)

	If Empty(_cEmail)
		Return
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe o SMTP Server                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If 	Empty(cMailServer)
		Help(" ",1,"SEMSMTP")//"O Servidor de SMTP nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe a CONTA                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If 	Empty(cMailServer)
		Help(" ",1,"SEMCONTA")//"A Conta do email nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf

	cError := ""

	If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha)
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lOk
		If 	lOk

			If lMailAuth
				If ( "@" $ cMailConta )
					cMailAuth := Subs(cMailConta,1,At("@",cMailConta)-1)
				Else
					cMailAuth := cMailConta
				EndIf
				//--> Testa o email completo ou apenas o usuario
				If MailAuth(cMailConta,cMailSenha) .Or. MailAuth(cMailAuth,cMailSenha)
					lResult := .T.
				ELSE
					//MSGINfO("NAO AUTENTICADO!!")
					CONOUT("NAO AUTENTICADO!!")
				EndIf
			Endif

			If lResult
				SEND MAIL 	FROM cMailConta	TO _cEmail  SUBJECT cSubject              BODY "Segue Inventário Numero: "+ _cControle+" De "+DTOC(dDataBase) ATTACHMENT _cAnexo RESULT lOK
				//SEND MAIL 	FROM cMailConta	TO "alexandro@assystem.com.br"  SUBJECT cSubject              BODY "Segue Inventário Numero: "+ _cControle+" De "+DTOC(dDataBase) ATTACHMENT _cAnexo RESULT lOK

				If !lOk
					GET MAIL ERROR cError
					//MsgInfo(cError,OemToAnsi("Erro no envio de Email"))
					CONOUT(cError,OemToAnsi("Erro no envio de Email"))
				Else
					//MSGINfO("EMAIL ENVIADO COM SUCCESSO!!")
				EndIf
				DISCONNECT SMTP SERVER
			Endif
			//MailSmtpOff()
		Else
			//MSGINfO("NAO CONECTADO!!")
			CONOUT("NAO CONECTADO!!")
		EndIf
	EndIf

Return(lOk)



Static Function ATUSX6()

	asx61:= {}
	asx62:= {}
	asx63:= {}

	//         "X6_FIL","X6_VAR"   ,"X6_TIPO","X6_DESCRIC"                                        ,"X6_DSCSPA","X6_DSCENG","X6_DESC1"                                          ,"X6_DSCSPA1","X6_DSCENG1","X6_DESC2"              ,"X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA","X6_CONTENG","X6_PROPRI"

	aAdd(asx61,{"  "    ,"MZ_PERINV","C"      ,"Utilizado para identificar a periocidade do       ","         ","         ","inventario Rotativo (D=Diario;S=Semanal;          ",""          ,""          ,"Q=Quinzenal;M=Mensal. ",""          ,""          ,"S"         ,""          ,""          ,"U"})
	aAdd(asx62,{"  "    ,"MZ_QTDINV","N"      ,"Utilizado para identificar a Quantidade de itens  ","         ","         ","que serão selecionadas em cada inventario.        ",""          ,""          ,"                      ",""          ,""          ,"30"        ,""          ,""          ,"U"})
	aAdd(asx63,{"  "    ,"MZ_DIAINV","N"      ,"Dia Inicial para comecar o calculo aleatorio      ","         ","         ","do inventario (2=Segunda;3=Segunda;4-quarta,      ",""          ,""          ,"5-Quinta e 6=Sexta.   ",""          ,""          ,"2"         ,""          ,""          ,"U"})

	U_CRIASX6(asx61)
	U_CRIASX6(asx62)
	U_CRIASX6(asx63)

Return


Static Function MZ97C()

	Local aRet:= {}
	Local nCont, i
	Local aTemp:= {}
	Local nTamArray
	Local nTamWork
	Local aCabecalho   := {}

	AADD(_aCabec,{"EMPRESA"   ,"C",002,0})
	AADD(_aCabec,{"PRODUTO"   ,"C",015,0})
	AADD(_aCabec,{"ALMOX"     ,"C",002,0})
	AADD(_aCabec,{"DESCRIC"   ,"C",150,0})
	AADD(_aCabec,{"PRATILEIRA","C",008,0})
	AADD(_aCabec,{"PRIM_CONT" ,"C",001,0})
	AADD(_aCabec,{"SEG_CONT"  ,"C",001,0})

	ZZ->(DbGotop())

	nTamWork:= ZZ->(FCount())

	ProcRegua(ZZ->(U_CONTREG()))

	While ZZ->(!EOF())

		IncProc()

		For nCont:= 1 to nTamWork
			_cDesc := ""
			If _aCabec[nCont][1] ==	"DESCRIC"
				_cDesc := StrTran(ZZ->(FieldGet(nCont)), ";","-")
				Aadd(aTemp," "+CVALTOCHAR(_cDesc))
			ElseIf _aCabec[nCont][2] == "C"
				Aadd(aTemp," "+CVALTOCHAR(ZZ->(FieldGet(nCont))))
			Else
				Aadd(aTemp,ZZ->(FieldGet(nCont)))
			Endif
		Next

		//Compatibilidade para aparecer a ultima coluna no excel
		AAdd(aTemp,'')
		//
		Aadd(_aItens, aTemp)
		aTemp:= {}

		ZZ->(Dbskip())
	EndDo

	ZZ->(dbCloseArea())

Return