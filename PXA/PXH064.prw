#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "AP5MAIL.CH"

/*
Função			:	PXH064
Autor			:	Alexandro Silva
Data 			: 	17.07.2012
Descrição		: 	Inventário Rotativo
*/

User Function PXH064(_cMd)
	
	LOCAL oDlg := NIL
	
	Private _cModo
	
	If _cMd == Nil
		_cModo := {2}
	Else
		_cModo := _cMd
	Endif
	
	PRIVATE cTitulo    	:= "Inventario Rotativo"
	Private _dFirstD,_dLastD
	Private cPerg   	:= "PXH064"
	Private cNomeArq
	
	If _cModo[1] == 2
		
		_aEmp := {cEmpAnt}
		_nOpc := 0
		DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
		
		@ 010,017 SAY "Esta rotina tem por objetivo gerar os Registros  " OF oDlg PIXEL Size 150,010
		@ 020,017 SAY "que ainda nao Foram Inventariados conforme ultima" OF oDlg PIXEL Size 150,010
		@ 030,017 SAY "Selecao.                                         " OF oDlg PIXEL Size 150,010
		
		@ 50,167 BUTTON "OK" 		  SIZE 036,012 ACTION (_nOpc := 1,oDlg:End()) 	OF oDlg PIXEL
		@ 65,167 BUTTON "Sair"        SIZE 036,012 ACTION ( oDlg:End()) 				OF oDlg PIXEL
		
		ACTIVATE MSDIALOG oDlg CENTERED
		
		If _nOpc = 1
			Private _cMsg01    := ''
			Private _lFim      := .F.
			Private _lAborta01 := .T.
			Private _bAcao01       := {|_lFim| U_PXH64A(@_lFim) }    /// PARAMETROS
			Private _cTitulo01 := 'Processando...'
			Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
			
		Endif
	Else
		
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "00101"
		
		//		_aEmp := {"16"}
		_aEmp := {"01"}
		
		U_PXH64A()
		
		RESET ENVIRONMENT
		
	Endif
	
Return(Nil)



User Function PXH64A()
	
	Private cMailConta	:= NIL
	Private cMailServer	:= NIL
	Private cMailSenha	:= NIL
	Private _cAnexo
	Private cMailFrom
	Private lMailAuth
	
	For AX:= 1 to Len(_aEmp)
		
		_cEmpresa := _aEmp[AX]
		
		//		If Select('SM0')>0
		//			nRecno := SM0->(Recno())
		//			RpcClearEnv()
		//		Endif
		
		//		OpenSM0()
		
		//		IF SM0->(DBSEEK(left(_cEmpresa+"01", 4) , .F. ) )
		//			RpcSetType(3)
		//			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL,'schedule','schedule','FIN',,{"ZAF","SB1","SB2","SBM","SBZ","ZZG"})
		//		ELSE
		//			CONOUT("NAO ACHOU EMPRESA ...")
		//			SM0->(DBGOTOP())
		//			DBCLOSEALL()
		//			RpcClearEnv()
		//		ENDIF
		
		//		ATUSX6()
		
		CONOUT("SETADA EMPRESA: "+_cEmpresa)
		CONOUT("ROTINA --> PXH064 :"+DTOS(DDATABASE)+" HORA: "+TIME())
		
		ZAF->(dbSetOrder(2))
		ZAF->(dbGoBottom())
		
		_cCodZAF := RIGHT(ZAF->ZAF_CODIGO,6)
		
		If ZAF->(Eof())
			_cControle := Left(Dtos(dDataBase),4) + "000001"
		Else
			_cControle := Left(Dtos(dDataBase),4) + Soma1(_cCodZAF)
		Endif
		
		_nQtInv   := GETMV("PXH_QTDINV")
		_nDiaHora := Day(dDataBase) + Val(Left(Time(),2))
		_nSeq     := Day(dDataBase) + 15 + Val(Substr(Time(),4,2))
		//		_nSeq     := Day(dDataBase) + 300 + Val(Substr(Time(),4,2))
		_nCont    := 0
		
		SBZ->(dbSetOrder(1))
		SBZ->(dbSeek( xFilial('SBZ')))
		//		SBZ->(dbSeek("01"))
		
		_lTodos  := .T.
		_cSeqSBZ := "000001"
		
		While SBZ->(!Eof()) .And. SBZ->BZ_FILIAL = xFilial('SBZ')
			
			SBZ->(RecLock("SBZ",.F.))
			SBZ->BZ_YORDEM := _cSeqSBZ
			SBZ->(MsUnlock())
			
			If Empty(SBZ->BZ_YSEQINV)
				_lTodos := .F.
			Endif
			
			_cSeqSBZ := Soma1(_cSeqSBZ)
			
			SBZ->(dbSkip())
		EndDo
		
		_lInvent := .F.
		
		For Azz:= 1 TO 2
			
			If _lTodos
				_cq := "UPDATE "+RetSqlName("SBZ")+" SET BZ_YSEQINV = '' WHERE D_E_L_E_T_ = '' "
				
				TcSQLExec(_cQ)
			Endif
			
			_cq := "SELECT MAX(BZ_YSEQINV) AS ULTSBZ FROM "+RetSqlName("SBZ")+" A WHERE A.D_E_L_E_T_ = '' "
			
			TCQUERY _cQ NEW ALIAS "ZZ"
			
			If Empty(ZZ->ULTSBZ)
				_cUltSBZ := "0000001"
			Else
				_cUltSBZ := StrZero(Val(ZZ->ULTSBZ)+1,7)
			Endif
			
			ZZ->(dbCloseArea())
			
			SBZ->(dbOrderNickName("INDSBZ1"))
			SBZ->(dbseek(xFilial(xFilial('SBZ'))))
			//			SBZ->(dbseek(xFilial("01")))
			
			_nCont   := 0
			
			ProcRegua(_nQtInv)
			
			For AZ:= 1 TO _nQtInv
				
				IncProc()
				
				SBZ->(dbOrderNickName("INDSBZ1"))
				If SBZ->(dbSeek(xFilial('SBZ')+StrZero(_nSeq,6)))
					//				If SBZ->(dbSeek("01"+StrZero(_nSeq,6)))
					
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
					
					_lInvent := .T.
					
					_aAliSB1 := SB1->(GetArea())
					
					SB1->(dbSetOrder(1))
					If SB1->(msSeek(xFilial("SB1")+SBZ->BZ_COD))
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
							ZAF->ZAF_PRAT   := SB1->B1_YPRAT
							//						ZAF->ZAF_PRAT   := SBZ->BZ_YPRAT
							ZAF->(MsUnLock())
						Endif
					Endif
					
					RestArea(_aAliSB1)
					
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
		
		_cQ := " SELECT '"+_cEmpresa+"' AS EMPRESA,ZAF_PRODUT AS PRODUTO,ZAF_ALMOX AS LOCAL ,ZAF_DESC AS DESCRIC,ZAF_PRAT AS PRATILEIRA,' ' AS PRIM_CONT,'' AS SEG_CONT FROM "+RetSqlName("ZAF")+" A "
		_cQ += " WHERE D_E_L_E_T_ = '' AND ZAF_CODIGO = '"+_cControle+"' "
		_cQ += " ORDER BY ZAF_PRODUT "
		
		TCQUERY _cQ NEW ALIAS "ZZ"
		
		_cArq := CriaTrab(NIL,.F.)
		Copy To &_cArq
		
		dbCloseArea()
		dbUseArea(.T.,,_cArq,"ZZ",.T.)
		
		_cArqNew := "\SPOOL\INV_"+_cEmpresa+"_"+DTOS(DDATABASE)+".XLS"
		
		dbSelectArea("ZZ")
		COPY ALL TO &_cArqNew
		
		dbCloseArea("ZZ")
		
		If _cModo[1] == 2
			CpyS2T( _cArqNew, "C:\TOTVS", .F. )
		Endif
		
		_cAnexo:= "\SPOOL\INV_"+_cEmpresa+"_"+DTOS(DDATABASE)+".XLS"
		U_PXH64B()
	Next AX
	
Return


User Function PXH64B(cSubject,cMensagem,cEMail,aFiles)
	
	Local lOk    := .F.			// Variavel que verifica se foi conectado OK
	Local lResult:= .F.			// Variavel que verifica se foi conectado OK
	
	//	If _cEmpresa == "16"
	If _cEmpresa == "01"
		cMailConta	:= GETMV("MV_RELACNT")
		cMailFrom 	:= GETMV("MV_RELFROM")
		cMailServer	:= GETMV("MV_RELSERV")
		cMailSenha	:= GETMV("MV_RELAPSW")
		lMailAuth	:= GETMV("MV_RELAUTH")
	Endif
	
	cSubject    := "INVENTARIO ROTATIVO"
	
	_cEmail     := ""
	
	ZAG->(dbSetOrder(1))
	ZAG->(dbGotop())
	
	CONOUT(RetSqlName("ZAG"))
	
	While ZAG->(!Eof())
		
		_cEmail += Alltrim(ZAG->ZAG_EMAIL)+";"
		
		ZAG->(dbSkip())
	EndDo
	
//	_cEmail := "fabiano@assystem.com.br"
	
	If Empty(_cEmail)
		Return
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe o SMTP Server                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(cMailServer)
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
					
					//					MSGINfO("NAO AUTENTICADO!!")
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
			
			//			MSGINfO("NAO CONECTADO!!")
			
			CONOUT("NAO CONECTADO!!")
		EndIf
	EndIf
	
Return(lOk)



Static Function ATUSX6()
	
	//asx61:= {}
	asx62:= {}
	//asx63:= {}
	
	//         "X6_FIL","X6_VAR"   ,"X6_TIPO","X6_DESCRIC"                                        ,"X6_DSCSPA","X6_DSCENG","X6_DESC1"                                          ,"X6_DSCSPA1","X6_DSCENG1","X6_DESC2"              ,"X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA","X6_CONTENG","X6_PROPRI"
	
	//aAdd(asx61,{"  "    ,"MZ_PERINV","C"      ,"Utilizado para identificar a periocidade do       ","         ","         ","inventario Rotativo (D=Diario;S=Semanal;          ",""          ,""          ,"Q=Quinzenal;M=Mensal. ",""          ,""          ,"S"         ,""          ,""          ,"U"})
	aAdd(asx62,{"  "    ,"PXH_QTDINV","N"      ,"Utilizado para identificar a Quantidade de itens  ","         ","         ","que serão selecionadas em cada inventario.        ",""          ,""          ,"                      ",""          ,""          ,"20"        ,""          ,""          ,"U"})
	//aAdd(asx63,{"  "    ,"MZ_DIAINV","N"      ,"Dia Inicial para comecar o calculo aleatorio      ","         ","         ","do inventario (2=Segunda;3=Segunda;4-quarta,      ",""          ,""          ,"5-Quinta e 6=Sexta.   ",""          ,""          ,"2"         ,""          ,""          ,"U"})
	
	//U_CRIASX6(asx61)
	U_CRIASX6(asx62)
	//U_CRIASX6(asx63)
	
Return
