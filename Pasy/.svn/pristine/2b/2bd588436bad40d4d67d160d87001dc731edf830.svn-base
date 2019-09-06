#include "rwmake.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FinA390	³ Autor ³ Wagner Xavier 	    ³ Data ³ 27/02/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera‡„o de Cheques sobre titulos s/baixa de titulos ou	  ³±±
±±³			 ³ cheques avulsos.											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FinA390()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGAFIN													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alessandro ³20/11/97³verif.³ Verificar MV_LIBCHEQ nos cheques avulsos ³±±
±±³ Eduardo    ³26/11/97³verif.³ Verificar MV_LIBCHEQ nos cheques avulsos ³±±
±±³ Alessandro ³05/12/97³verif.³ Acerto na string da indregua. fa390chec()³±±
±±³ Alessandro ³08/12/97³verif.³ Acerto na string da indregua. fa390chec()³±±
±±³ Alessandro ³08/12/97³verif.³ Mostrar ou nao Lancto. Contabil.         ³±±
±±³ Eduardo    ³26/01/98³      ³ Atualizacao de ef_origem                 ³±±
±±³ MAURICIO   ³24/08/98³      ³ Acerto get beneficiario                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function Pa0014()


Private aTELA[0][0],aGETS[0]
PRIVATE aRotina := { {OemToAnsi("Pesquisar"), "AxPesqui", 0 , 1},;  
					 {OemToAnsi("Chq s/Tit"), "U_PA0014A()", 0 , 2},;  
					 {OemToAnsi("Avulsos"), "fA390Avu", 0 , 3},;  
					 {OemToAnsi("Redeposito"), "fa390Red", 0 , 2},;  
					 {OemToAnsi("caNcelar"), "U_PA0014H()", 2 , 4} }  

Private cBanco390, cAgencia390, cConta390, cCheque390, dVencIni, dVencFim
Private nLimite, cNatur390, cBenef390, cForn390, cHist390

pergunte("FIN390",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabe‡alho principal do programa.						  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := OemToAnsi("Cheques a Pagar")  
PRIVATE cMarca 	:= GetMark( )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o numero do Lote 											  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cLote
dbSelectArea( "SX5" )
dbSeek( cFilial+"09FIN" )
cLote := Substr(X5_DESCRI,1,4)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a Fun‡„o de BROWSE											  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mBrowse( 6, 1,22,75,"SE2",,"E2_IMPCHEQ" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE2")
dbSetOrder(1)


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ fA390Tit ³ Autor ³ Wagner Xavier 	    ³ Data ³ 26/05/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Escolha dos titulos para gera‡„o do chequE				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fa390Tit()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PA0014A(cAlias,cCampo,nOpcE)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis 														  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local oDlg,oDlg1
Local oValor		:= 0
Local oQtdTit		:= 0
LOCAL lRet			:=.F.
LOCAL nSaldo
LOCAL cArquivo
LOCAL nTotal		:=0
LOCAL nHdlPrv		:=0
LOCAL lPadrao,cPadrao:="566"
LOCAL nRec			:= Recno()
LOCAL nSavOrd1 	:= IndexOrd()
LOCAL nTotAbat
LOCAL cNumero
LOCAL cPrefixo
LOCAL cTipo
LOCAL cParcela
LOCAL cFornece
LOCAL cIndex		:= " "
Local cLiberado	:= GetMv("MV_LIBCHEQ")
Local nOpca 		:= 0
Local lEntrada 	:= .F. //FILE(NameInt("A390CHEQ"))

Private lInverte	:= .F.
Private cMarca 	:= GetMark()
Private nValor 	:= 0
Private nQtdTit	:= 0

cBanco390	:= Space( 3)
cAgencia390 := Space( 5)
cConta390	:= Space(10)
cCheque390	:= Space(15)
dVencIni 	:= dDataBase
dVencFim 	:= dDataBase
nLimite		:= 0
cNatur390	:= Space(10)
cBenef390	:= Space(40)
cForn390 	:= Space( 6)
cHist390 	:= Space(40)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se data do movimento n„o ‚ menor que data limite de ³
//³ movimentacao no financeiro    										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !DtMovFin()
	Return
Endif	


While .T.

		DEFINE MSDIALOG oDlg FROM 85,71 TO 420,565 TITLE OemToAnsi("Pagamentos com Cheques") PIXEL  		

		@ 003, 004 TO 037, 196 //OF oDlg	PIXEL
		@ 042, 004 TO 076, 196 //OF oDlg	PIXEL
		@ 082, 004 TO 115, 196 //OF oDlg	PIXEL
		@ 122, 004 TO 155, 196 //OF oDlg	PIXEL

		@ 010, 011 SAY 	OemToAnsi("Banco") 							  	SIZE 21, 07// OF oDlg PIXEL  
		@ 020, 011 GET	cBanco390	F3 "SA6" Valid Fa390Banco(1)    SIZE 21, 11// OF oDlg PIXEL
		@ 010, 047 SAY 	OemToAnsi("Agˆncia")                            SIZE 28, 07// OF oDlg PIXEL  
		@ 020, 047 GET	cAgencia390 			Valid Fa390Banco(2) SIZE 28, 11// OF oDlg PIXEL		
		@ 010, 082 SAY 	OemToAnsi("Conta")                              SIZE 25, 07// OF oDlg PIXEL  
		@ 020, 082 GET	cConta390				Valid Fa390Banco(3) SIZE 39, 11// OF oDlg PIXEL		
		@ 010, 128 SAY 	OemToAnsi("Numero Cheque")                      SIZE 46, 07// OF oDlg PIXEL  
		@ 020, 128 GET	cCheque390				Valid Fa390Cheq(1)	SIZE 46, 11 //OF oDlg PIXEL		

		@ 049, 011 SAY 	OemToAnsi("Vencidos")                           SIZE 53, 07 //OF oDlg PIXEL  
		@ 060, 011 SAY 	OemToAnsi("Entre")                              SIZE 32, 07 //OF oDlg PIXEL  
		@ 059, 027 GET	dVencIni 									SIZE 32, 11 //OF oDlg PIXEL		
		@ 060, 063 SAY 	OemToAnsi("e")                                  SIZE 32, 07 //OF oDlg PIXEL  
		@ 059, 070 GET	dVencFim 		Valid  dVencFim>=dVencIni	SIZE 32, 11 //OF oDlg PIXEL		
		@ 049, 109 SAY 	OemToAnsi("Valor do Cheque") 	                SIZE 53, 07 //OF oDlg PIXEL  
		@ 059, 109 GET	nLimite		 Picture"@E 9,999,999,999.99"   SIZE 57, 11 //OF oDlg PIXEL		

		@ 088, 011 SAY 	OemToAnsi("Fornecedor")                         SIZE 35, 07 //OF oDlg PIXEL  
		@ 098, 011 GET	cForn390 	F3 "SA2" Valid fa390Fornece()   SIZE 28, 11 //OF oDlg PIXEL		
		@ 088, 054 SAY 	OemToAnsi("Natureza")                          SIZE 32, 07 //OF oDlg PIXEL  
		@ 098, 054 GET	cNatur390	F3 "SED" Picture "@!" Valid fa390Natur()  SIZE 40, 11 //OF oDlg PIXEL
		@ 088, 109 SAY 	OemToAnsi("Beneficiario")                       SIZE 53, 07 //OF oDlg PIXEL
		@ 098, 109 GET	cBenef390		Picture "@!S30"             SIZE 84, 11 //OF oDlg PIXEL

		@ 127, 011 SAY 	OemToAnsi("Historico")                          SIZE 35, 07 //OF oDlg PIXEL
		@ 137, 011 GET	cHist390 	When cLiberado == "S"           SIZE 128, 11 //OF oDlg PIXEL

		DEFINE SBUTTON FROM 07, 211 TYPE 1 ACTION (nOpca := 1,;
						Iif(U_PA0014E(),oDlg:End(),nOpca:=0)) ENABLE OF oDlg
		DEFINE SBUTTON FROM 20, 211 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

		ACTIVATE MSDIALOG oDlg

		If nOpca == 0 .or. nOpca == 2
			Exit
		Endif
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta express„o do Filtro para sele‡„o							  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cIndex := CriaTrab(nil,.f.)
	cChave := IndexKey( )
	IndRegua("SE2",cIndex,cChave,,U_PA0014F(),OemToAnsi("Selecionando Registros..."))  
	nIndex := RetIndex("SE2")
	dbSelectArea("SE2")
	#IFNDEF TOP
		dbSetIndex(cIndex+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex+1)

	dbGoTop()
	If BOF() .and. EOF()
		Help(" ",1,"RECNO")
		Exit
	End

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Mostra browse com os titulos que irao compor o cheque		  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nValor	:= 0	// valor total dos titulos,mostrado no rodape do browse
	nQtdTit	:= 0	// quantidade de titulos,mostrado no rodape do browse

		nOpcA := 0
		oValor:=0
		oQtdTit := 0
		cAlias := "SE2"
		dbSelectArea(cAlias)
		dbSetOrder(nIndex+1)

		DEFINE MSDIALOG oDlg1 TITLE OemToAnsi("Gera‡„o de Cheques") From 11,30 To 30,110 OF oMainWnd

		@ 14 , 1 To 41,170 
		@ 17 , 4  SAY OemToAnsi("Banco: ")+cBanco390                   SIZE 063, 11
		@ 27 , 4  Say OemToAnsi("Agencia: ")+cAgencia390               SIZE 063, 11
		@ 17 , 60 SAY OemToAnsi("Conta: ")+cConta390                   SIZE 063, 11
		@ 27 , 60 SAY OemToAnsi("Nº Cheque: ")+SubStr(cCheque390,1,15) SIZE 063, 11

		@ 14 , 172 To 41,310 
		@ 17 , 175	 Say OemToAnsi("Nº Titulos Selecionados: ")  	
		@ 17 , 240	 Say nQtdTit Picture "999" object oQtdTit           SIZE 063, 11      
		@ 27 , 175	 Say OemToAnsi("Valor Total: ")                		

		@ 27 , 240	 Say nValor Picture "@E 999,999,999.99" Object oValor SIZE 063, 11  

		oMark 		:=MsSelect():New(cAlias,"E2_OK","E2_IMPCHEQ",,@lInverte,@cMarca,{45,1,143,315})
		oMark:bMark := {||U_PA0014G(cMarca,oValor,oQtdTit,1)}
		oMark:oBrowse:lhasMark = .t.
		oMark:oBrowse:lCanAllmark := .t.
		oMark:oBrowse:bAllMark := { || U_PA0014D(cMarca,oValor,oQtdTit,1) }


		ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{|| nOpca := 1,oDlg1:End()},{|| nOpca := 2,oDlg1:End()})


	If nValor == 0
		Exit
	EndIF

	If nOpca == 1
		dbSelectArea("SE2")
		dbGoTop( )
		While !Eof( )
			If E2_FILIAL != cFilial
				dbSkip( )
				Loop
			End
			nOrdem := IndexOrd( )
			If E2_OK == cMarca .and. SubStr(E2_TIPO,3,1) != "-"
				cChave		:= &(IndexKey())
				cPrefixo := E2_PREFIXO
				cNumero	:= E2_NUM
				cParcela := E2_PARCELA
				cTipo 		:= E2_TIPO
				cFornece := E2_FORNECE
				*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				*³Soma Titulos Abatimentos 								³
				*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea( "SE2" )
				dbSetOrder( 1 )
				dbSeek( cFilial+cPrefixo+cNumero+cParcela )
				nTotAbat := 0

				While !Eof( ) .And. E2_FILIAL==cFilial .And. E2_PREFIXO=cPrefixo ;
					.And. E2_NUM==cNumero .And. E2_PARCELA==cParcela .And.;
					E2_FORNECE==cFornece

					IF Substr(E2_TIPO,3,1)="-" .And. E2_SALDO >0
						nTotAbat+=E2_SALDO+E2_VLJUROS-E2_VLDESC
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza flag do arquivo		  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						RecLock("SE2",.F.)
						Replace E2_IMPCHEQ With "S"
						MsUnlock( )
					EndIf
					dbSkip()
				EndDo

				dbSetOrder( nOrdem )
				dbSeek( cChave, .T. )
				If E2_SALDO > 0
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza arquivo de cheques. 						  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea( "SEF" )
					Reclock( "SEF", .T. )
					SEF -> EF_FILIAL	:= cFilial
					SEF -> EF_NUM		:= cCheque390
					SEF -> EF_BANCO	    := cBanco390
					SEF -> EF_AGENCIA   := cAgencia390
					SEF -> EF_CONTA	    := cConta390
					SEF -> EF_DATA 	    := dDataBase
					SEF -> EF_VALOR	    := SE2->E2_SALDO + SE2->E2_VLJUROS - SE2->E2_VLDESC - nTotAbat
					SEF -> EF_BENEF	    := cBenef390
					SEF -> EF_IMPRESS   := "A"
					SEF -> EF_PREFIXO   := SE2->E2_PREFIXO
					SEF -> EF_TITULO	:= SE2->E2_NUM
					SEF -> EF_PARCELA   := SE2->E2_PARCELA
					SEF -> EF_TIPO 	    := SE2->E2_TIPO
					SEF -> EF_FORNECE   := SE2->E2_FORNECE
					SEF -> EF_LOJA 	    := SE2->E2_LOJA
					SEF -> EF_HIST 	    := cHist390
					SEF -> EF_LIBER	    := cLiberado
					SEF -> EF_ORIGEM    := "FINA390TIT"
					MsUnlock()
				Else
					cChave := " "
				EndIF
				Reclock( "SE2" )
				SE2 -> E2_IMPCHEQ  := "S"
				SE2 -> E2_NUMBCO	 := cCheque390
				MsUnlock( )
			Else
				cChave := " "
			End
			dbSelectArea( "SE2" )
			dbSetOrder( nOrdem )
			If Empty( cChave )
				dbSkip( )
			Else
				dbSeek (cChave,.T.)
			EndIf
		EndDo

		If nValor > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza arquivo de cheques. 						  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea( "SEF" )
			Reclock( "SEF", .T. )
			SEF -> EF_FILIAL	:= cFilial
			SEF -> EF_NUM		:= cCheque390
			SEF -> EF_BANCO	:= cBanco390
			SEF -> EF_AGENCIA := cAgencia390
			SEF -> EF_CONTA	:= cConta390
			SEF -> EF_DATA 	:= dDataBase
			SEF -> EF_VALOR	:= nValor
			SEF -> EF_BENEF	:= cBenef390
			SEF -> EF_HIST 	:= cHist390
			SEF -> EF_LIBER	:= cLiberado
			SEF -> EF_ORIGEM  := "FINA390TIT"
			MsUnlock()
		EndIf

		If nValor > 0 .And. cLiberado == "S"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava registro referente a movimenta‡„o Banc ria ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Reclock("SE5",.T.)
			Replace E5_FILIAL 	With cFilial
			Replace E5_BENEF		With cBenef390
			Replace E5_VALOR		With nValor
			Replace E5_DATA		With dDataBase
			Replace E5_NATUREZ	With cNatur390
			Replace E5_RECPAG 	With "P"
			Replace E5_DTDIGIT	With dDataBase
			Replace E5_TIPODOC	With "CH"
			Replace E5_DTDIGIT	With dDataBase
			Replace E5_BANCO		With cBanco390
			Replace E5_AGENCIA	With cAgencia390
			Replace E5_CONTA		With cConta390
			Replace E5_NUMCHEQ	With cCheque390
			Replace E5_CLIFOR 	With cForn390
			Replace E5_HISTOR 	With cHist390
			Replace E5_DTDISPO	With E5_DATA
			MsUnlock( )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza saldo bancario.								  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			AtuSalBco(cBanco390,cAgencia390,cConta390,SE5->E5_DATA,SE5->E5_VALOR,"-")
		Endif

		If nValor > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ativa um ponto de entrada para eventual execblock³
			//³ chamado A390CHEQ 										  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lEntrada
				ExecBlock("A390CHEQ",.F.,.F.)
			Endif

			If (lPadrao := VerPadrao( cPadrao ) )
				nHdlPrv:=HeadProva(cLote,"FINA390",Substr(cUsuario,7,6),@cArquivo)
				nTotal+=DetProva(nHdlPrv,cPadrao,"FINA390",cLote)
				RodaProva(nHdlPrv,nTotal)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Envia para Lan‡amento Contabil							  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cA100Incl(cArquivo,nHdlPrv,3,cLote,Iif(mv_par02==1,.T.,.F.),.F.)
			EndIf

		EndIf
		dbSelectArea( "SE2" )
	ElseIf nOpca == 2
		RetIndex("SE2")
		Set Filter to
		Loop
	EndIf
	Exit
EndDo

MsUnlockAll()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura os indices 													  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SE2")
Set Filter To
If !Empty( cIndex )
	dbSelectArea("SE2")
	dbSetOrder(nSavOrd1)
	dbGoTo( nRec )
	FErase (cIndex+OrdBagExt())
Endif
Return (.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fa390Can	³ Autor ³ Alessandro Freire	    ³ Data ³ 18/04/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Cancela cheques sobre titulo								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³fa390can()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³FINA390									  			      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function PA0014H()

LOCAL oDlg

LOCAL cAlias	:= Alias()
LOCAL nOrder	:= dbSetOrder()
LOCAL nRec		:= Recno()
LOCAL lRetorna := .F.

PRIVATE cBanco390
PRIVATE cAgencia390
PRIVATE cConta390
PRIVATE cCheque390
PRIVATE nOpcA

cBanco390		:= Space( 3 )
cAgencia390 	:= Space( 5 )
cConta390		:= Space( 10 )
cCheque390		:= Space( 15 )

While .T.

	If !DtMovFin()
		Exit
	Endif	

	dbSelectArea( "SEF" )
	dbSetOrder( 3 )
	dbSeek( xFilial("SEF")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO	)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Procura no SEF o registro que contem o No. do Cheque ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof() .And. SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO == ;
	                   SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO .And. Empty( SEF->EF_NUM )
		dbSkip()
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recebe dados do cheque a ser cancelado.							  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cBanco390	:= SEF->EF_BANCO
	cAgencia390 := SEF->EF_AGENCIA
	cConta390	:= SEF->EF_CONTA
	cCheque390	:= SEF->EF_NUM
	dData390 	:= SEF->EF_DATA
		nOpca := 0
   	    DEFINE MSDIALOG oDlg FROM 10, 30 TO 22, 71 TITLE OemToAnsi("Cancelar Cheque")  
		@ 02 ,5 TO 70, 160

		@ 10, 10 Say OemToAnsi("Banco : ")  
		@ 10, 60 GET cBanco390 F3 "SA6" Valid Fa390Banco(1)
		@ 25, 10 Say OemToAnsi("Agencia : ")  
		@ 25, 60 GET cAgencia390	Valid Fa390Banco(2)
		@ 40, 10 Say OemToAnsi("Conta : ")  
		@ 40, 60 GET cConta390	Valid Fa390Banco(3)
		@ 55, 10 Say OemToAnsi("Num Cheque:")  
		@ 55, 60 GET cCheque390 	Valid Fa390Cheq(2)

		DEFINE SBUTTON FROM 072,097 TYPE 1 ACTION (nOpca := 1,If(!Empty(cBanco390),oDlg:End(),nOpca:=0)) ENABLE OF oDlg
		DEFINE SBUTTON FROM 072,124.1 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

		ACTIVATE MSDIALOG oDlg


	If nOpca == 1
		U_PA0014I()
	ElseIf nOpca  == 2 .Or. nOpca == 0
		Exit
	Else
		Loop
	EndIf
EndDo

dbSelectArea( cAlias )
dbSetOrder( nOrder )
dbGoto( nRec )

Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fA390Perg ³ Autor ³ Wagner Xavier		    ³ Data ³ 26/05/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Ativa Parametros do Programa				 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 								   			      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fA390Perg()
pergunte("FIN390",.T.)

Return(nil)
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fa390Chec ³ Autor ³ Wagner Xavier 	    ³ Data ³ 21/03/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna Condi‡„o para Indice Condicional	  			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³fa390Chec () 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³FINA390									  			      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PA0014F()
Local cFiltro := ""

cFiltro += 'E2_SALDO > 0'
cFiltro += '.AND.DTOS(E2_VENCREA)>= "' + dTos(dVencIni) + '"'
cFiltro += '.AND.DTOS(E2_VENCREA)<= "' + dTos(dVencFim) + '"'

cFIltro += '.AND. E2_TIPO != "PR "'
cFiltro += '.AND. E2_TIPO != "PA "'
cFiltro += '.AND. E2_TIPO != "NDF"'
cFiltro += '.AND. E2_TIPO != "NCC"'

cFiltro += '.AND.E2_IMPCHEQ="' + Space(Len(E2_IMPCHEQ)) +'"'

If ! Empty( cForn390 )
	cFiltro += '.AND.E2_FORNECE="' + cForn390 + '"'
EndIf

If mv_par01 == 2
	cFiltro += '.AND.E2_NUMBOR="' + Space(Len(E2_NUMBOR)) + '"'
End

Return( cFiltro )

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fa390Chec1³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 16/05/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna Condi‡„o para Indice Condicional					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³fa390Chec1() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³FINA390													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Fa390Chec1()

LOCAL cFiltro := ""

cFiltro += 'EF_NUM = "' + cCheque390 + '"'
cFiltro += ' .AND. EF_BANCO = "' + cBanco390 + '"'
cFiltro += ' .AND. EF_AGENCIA = "' + cAgencia390 + '"'
cFIltro += ' .AND. EF_CONTA = "' + cConta390 + '"'
cFiltro += ' .AND. EF_IMPRESS = "A"'

Return cFiltro

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fa390Natur³ Autor ³ Wagner Xavier 		³ Data ³ 21/03/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida natureza digitada.									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³fa390Natur() 											      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³FINA390													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function fa390Natur( )

Local cAlias := Alias( )
Local lRet	 := .t.

If Empty( cNatur390 )
	Return ( .f. )
Endif

dbSelectArea( "SED" )
If !(dbSeek( cFilial + cNatur390 ) )
	 Help( " ",1,"fa390Natur" )
	 lRet := .f.
End

dbSelectArea( cAlias )
Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fa390Forn ³ Autor ³ Wagner Xavier 		³ Data ³ 21/03/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida fornecedor digitado								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³fa390Forn()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³FINA390													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function fa390Fornece( )
Local cAlias := Alias( )
Local lRet	 := .t.
If Empty( cForn390 )
	Return ( .T. )
End
dbSelectArea( "SA2" )
If !(dbSeek( cFilial + cForn390 ) )
	Help( " ",1,"fa390Forn" )
	lRet := .f.
End
cBenef390 := SA2->A2_NOME
dbSelectArea( cAlias )
Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³FA390Exibe³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 07/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exibe Totais de titulos selecionados						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA390Exibe()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA390											   	      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PA0014C(cMarca,oValor,oQtdTit,nNum)

If nNum == 1 // Gera
	If SE2->E2_OK == cMarca .And. SE2->E2_FILIAL == cFilial
		IF SubStr(E2_TIPO,3,1) != "-"
			nValor += E2_SALDO+E2_VLJUROS-E2_VLDESC
		Else
			nValor -= E2_SALDO+E2_VLJUROS-E2_VLDESC
		End
		nQtdTit++
	Else
		If SE2->E2_FILIAL == cFilial
			IF SubStr(E2_TIPO,3,1) != "-"
				nValor -= E2_SALDO+E2_VLJUROS-E2_VLDESC
			Else
				nValor += E2_SALDO+E2_VLJUROS-E2_VLDESC
			End
			nQtdTit--
			nValor := Iif(nValor<0,0,nValor)
			nQtdTit:= Iif(nQtdTit<0,0,nQtdTit)
		Endif
	EndIf
Else // Cancela
	If SEF->EF_OK == cMarca .And. SEF->EF_FILIAL == cFilial
		IF SubStr(EF_TIPO,3,1) != "-"
			nValor += EF_VALOR
		Else
			nValor -= EF_VALOR
		End
		nQtdTit++
	Else
		If SEF->EF_FILIAL == cFilial
			IF SubStr(EF_TIPO,3,1) != "-"
				nValor -= EF_VALOR
			Else
				nValor += EF_VALOR
			End
			nQtdTit--
			nValor := Iif(nValor<0,0,nValor)
			nQtdTit:= Iif(nQtdTit<0,0,nQtdTit)
		Endif
	EndIf
EndIf

oValor:Refresh()
oQtdTit:Refresh()

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FA390Inver³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 20/12/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Inverte marcacoes - Windows								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA390													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0014D(cMarca,oValor,oQtdTit,nNum)


Local nReg
Local cAlias := Alias()

If nNum == 1					// Fa390Tit chamou esta rotina (nNum == 1)
	dbSelectArea("SE2")
	nReg := Recno()
	dbSeek(cFilial)
	While !Eof() .and. cFilial == E2_FILIAL
		RecLock("SE2")
		SE2->E2_OK := IIF(E2_OK == "  ",cMarca,"  ")
		If E2_OK == cMarca
			nValor	+=E2_SALDO+E2_VLJUROS-E2_VLDESC
			nQtdTit++
		Else
		   nValor  -= E2_SALDO+E2_VLJUROS-E2_VLDESC
		   nValor  := Iif(nValor<0,0,nValor)
		   nQtdTit--
		   nQtdTit:= Iif(nQtdTit<0,0,nQtdTit)
		EndIF
		dbSkip()
	End
	SE2->(dbGoto(nReg))
Else
	dbSelectArea("SEF")
	nReg := Recno()
	dbSeek(cFilial)
	While !Eof() .and. cFilial == EF_FILIAL
		RecLock("SEF")
		SEF->EF_OK := IIF(EF_OK == "  ",cMarca,"  ")
		If EF_OK == cMarca
			If Subs(SEF->EF_TIPO,3,1) == "-"
				nValor	-= EF_VALOR
			Else
				nValor	+= EF_VALOR
			EndIf
			nQtdTit++
		Else
			If Substr(SEF->EF_TIPO,3,1) == "-"
				nValor	+= EF_VALOR
			Else
				nValor	-= EF_VALOR
			EndIf
			nQtdTit--
			nQtdTit:= Iif(nQtdTit<0,0,nQtdTit)
		End
		dbSkip()
	End
	SEF->(dbGoto(nReg))
EndIf

dbSelectArea(cAlias)
oValor:SetText(nValor)
oQtdTit:SetText(nQtdTit)

oValor:Refresh()
oQtdTit:Refresh()

oMark:oBrowse:Refresh(.t.)

Return Nil



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FA390Inver³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 20/12/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Inverte marcacoes - Windows								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA390													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function PA0014G(cMarca,oValor,oQtdTit,nNum)


nValor  := 0
nQtdTit := 0

Private nReg
Private cAlias := Alias()

If nNum == 1					// Fa390Tit chamou esta rotina (nNum == 1)
	dbSelectArea("SE2")
	nReg := Recno()
	dbSeek(cFilial)
	While !Eof() .and. cFilial == E2_FILIAL

	   If Marked("E2_OK")
	      nValor	+= E2_SALDO+E2_VLJUROS-E2_VLDESC
		  nQtdTit++
	   EndIF
	   dbSkip()
	EndDo
	SE2->(dbGoto(nReg))
Else
	dbSelectArea("SEF")
	nReg := Recno()
	dbSeek(cFilial)
	While !Eof() .and. cFilial == EF_FILIAL
		RecLock("SEF")
		SEF->EF_OK := IIF(EF_OK == "  ",cMarca,"  ")
		If EF_OK == cMarca
			If Subs(SEF->EF_TIPO,3,1) == "-"
				nValor	-= EF_VALOR
			Else
				nValor	+= EF_VALOR
			EndIf
			nQtdTit++
		Else
			If Substr(SEF->EF_TIPO,3,1) == "-"
				nValor	+= EF_VALOR
			Else
				nValor	-= EF_VALOR
			EndIf
			nQtdTit--
			nQtdTit:= Iif(nQtdTit<0,0,nQtdTit)
		End
		dbSkip()
	End
	SEF->(dbGoto(nReg))
EndIf

dbSelectArea(cAlias)
oValor:SetText(nValor)
oQtdTit:SetText(nQtdTit)
oValor:Refresh()
oQtdTit:Refresh()
oMark:oBrowse:Refresh(.t.)

Return Nil


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FA390Ok	³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 20/12/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se dados essenciais foram digitados 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA390													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0014E()

Local lRet	:= .T.

If Empty(cNatur390) .or. Empty(cBanco390) .Or. Empty(cAgencia390) .Or.;
	Empty(cConta390) .Or. Empty(cCheque390)
	Help(" ",1,"Fa390Erro1")
	lRet := .F.
Endif

Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fa390Ver	³ Autor ³ Alessandro Freire	  ³ Data ³ 18/04/96 ³  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Faz a busca nos bancos de dados para o cancelamento		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³fa390ver()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³FINA390													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PA0014I()

LOCAL nRegSEF		:= 0
LOCAL nRegSE2		:= 0
LOCAL lEstorna 	:= .F.
LOCAL cPadrao		:= "568"
LOCAL cArquivo 	:= ""
LOCAL nTotal		:= 0
LOCAL nHdlPrv		:= 0
LOCAL cString		:= ""
LOCAL lCancela 	:= .F.
LOCAL aSE5			:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no cheque do banco selecionado.						  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SEF" )
dbSetOrder( 1 )
dbSeek(xFilial("SEF")+cBanco390+cAgencia390+cConta390+cCheque390 )
dData390 := SEF->EF_DATA
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica no SE2 se o cheque foi gerado pelo fina390. Caso	  ³
//³ sim, nÆo deixa cancelar pelo FINA190. 							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE2")
dbSetOrder(1)
cString := xFilial("SE2") +SEF->EF_PREFIXO +SEF->EF_TITULO +SEF->EF_PARCELA +SEF->EF_TIPO +SEF->EF_FORNECE +SEF->EF_LOJA

If dbSeek( cString )
	If Empty( SE2-> E2_IMPCHEQ )
		Help( " ", 1, "ORIGEM390" )
		Return( .F. )
	EndIf
EndIf
nRegSE2 := Recno()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Cancela os cheques.															  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SEF")
dbSetOrder(1)
nRegSEF := Recno()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se deve cancelar ou deletar o cheque. 	 ³
//³ Deve ser cancelado quando o cheque j  foi impresso.³
//³ Deve ser deletado quando ainda nao foi impresso.	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Na ordem 1 do SEF o cheque ‚ o ultimo registro e os³
//³ primeiros sao os titulos aglutinados. Portanto de- ³
//³ ve-se ir ao ultimo registro e verificar se o cheque³
//³ foi impresso ou nao, retornando depois ao primeiro ³
//³ para o resto do processamento.							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While (	xFilial( "SEF" )  == SEF-> EF_FILIAL .And.SEF-> EF_NUM	== cCheque390 .And.;
			                 SEF-> EF_BANCO  == cBanco390   .And.;
			                 SEF->EF_AGENCIA == cAgencia390 .And.;
			                 SEF->EF_CONTA	 == cConta390 ) .And. ! Eof()

		If SEF->EF_IMPRESS == "C"
			Help( " ", 1, "JA CANCELA")
			Return( .F. )
		ElseIf SEF->EF_IMPRESS == "S"
			RecLock("SEF",.F.)
			SEF->EF_IMPRESS := "C"
			lCancela := .T.  // Deve ser cancelado e nao deletado.
			MsUnlock()
		EndIf
		dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona no registro do fornecedor. (Para contabiliza‡ƒo)				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA2")
dbSetOrder(1)
dbSeek( xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna para o registro inicial.				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SEF")
dbGoto( nRegSEF )
While (	xFilial( "SEF" )  == SEF-> EF_FILIAL  .And.;
			                 SEF-> EF_NUM    == cCheque390  .And.;
			                 SEF-> EF_BANCO  == cBanco390   .And.;
			                 SEF->EF_AGENCIA == cAgencia390 .And.;
                  			 SEF->EF_CONTA	 == cConta390 ) .And. ! Eof()

	If SEF->EF_IMPRESS != "A"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Contabiliza o cancelamento do cheque sobre titulos			  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If VerPadrao(cPadrao)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se nHdlPrv for zero, o cabecalho do lancamento contabil 	³
			//³ ainda nao foi feito. Caso contrario, deve-se incluir no 	³
			//³ lancamento os detalhes do lancamento. 							³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nHdlPrv == 0
				nHdlPrv:=HeadProva(cLote,"FINA390",Substr(cUsuario,7,6),@cArquivo)
			End
			If nHdlPrv > 0
				nTotal+=DetProva(nHdlPrv,cPadrao,"FINA390",cLote)
			End
		End
	End

	If SEF->EF_LIBER == "S"
		lEstorna := .T.
	End

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Desbloqueia a inclusao de novo cheque no titulo				  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  dado o dbseek porque v rios t¡tulos podem ter  ³
	//³ sido aglutinados no mesmo cheque.					  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE2")
	dbSetOrder( 1 )
	If dbSeek(	xFilial("SE2")    +;
					SEF->EF_PREFIXO	+;
					SEF->EF_TITULO 	+;
					SEF->EF_PARCELA	+;
					SEF->EF_TIPO		+;
					SEF->EF_FORNECE	+;
					SEF->EF_LOJA  )
		RecLock( "SE2" )
		SE2->E2_IMPCHEQ	:= CriaVar( "E2_IMPCHEQ" )
		SE2->E2_NUMBCO 	:= CriaVar( "E2_NUMBCO" )
		MsUnlock()
	End
	dbSelectArea("SEF")
	dbSkip()
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estorno do cheque cancelado no SE5 ( se houve movimenta‡„o )			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna ao primeiro titulo aglutinado no cheque³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SEF")
dbGoto(nRegSEF)

dbSelectArea( "SE5" )
dbSetOrder( 1 )
If dbSeek(xFilial("SE5") + DtoS(dData390) + SEF->EF_BANCO + SEF->EF_AGENCIA	+ SEF->EF_CONTA)

	While ( !Eof() .And.SE5->E5_DATA	== dData390 .And. ;
      			        SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA == ;
			            SEF->EF_BANCO + SEF->EF_AGENCIA + SEF->EF_CONTA )
			
		If ( SE5->E5_NUMCHEQ == SEF->EF_NUM .and. SE5->E5_TIPODOC $ "CA/CH" .And.;
			SE5->E5_SITUACA != "C" )
			If SE5->E5_LA == "S " .or. lCancela .or. SE5->E5_DTDISPO < dDataBase
				For nX := 1 to SE5->( Fcount() )
					AAdd( aSE5, SE5->( FieldGet(nX) ) )
				Next
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava o registro de estorno                     	  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				RecLock("SE5" ,.T.)
				For nX := 1 to SE5->(Fcount())
					SE5->( FieldPut( nX,aSE5[nX]))
				Next
				SE5->E5_TIPODOC := "EC"
				SE5->E5_RECPAG  := "R"
				SE5->E5_HISTOR	 := OemToAnsi("Cancelamento de Cheque")
				SE5->E5_DATA    := dDatabase
				SE5->E5_DTDIGIT := dDataBase
				SE5->E5_DTDISPO := dDataBase
				SE5->E5_SEQ		 := SEF->EF_SEQUENC
				MsUnlock()
			Else
				RecLock( "SE5", .F. )
				SE5->E5_SITUACA := "C"
				MsUnlock()
			Endif
		
			AtuSalBco(	SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,dDataBase,SE5->E5_VALOR	, "+" )

			Exit
		End
		dbSkip()
	EnddO

End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga ou cancela regitros do cadastro de cheques							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SEF")
dbSetOrder(1)
dbSeek( xFilial("SEF") + cBanco390 + cAgencia390 + cConta390 + cCheque390 )
While (	xFilial("SEF") == SEF->EF_FILIAL 	.And.;
			         SEF->EF_NUM     == cCheque390 .And.;
			         SEF->EF_BANCO   == cBanco390	 .And.;
      			     SEF->EF_AGENCIA == cAgencia390 		.And.;
   			         SEF->EF_CONTA	 == cConta390 )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se o titulo ja foi baixado, nao se pode exclui-lo do SEF, pois	 ³
	//³ o usu rio pode querer junt -lo a um novo cheque.						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE5")
	dbSetOrder( 3 )
	If dbSeek( xFilial("SE5")+ Space(3)       +;
										Space(5) 		+;
										Space(10)		+;
										SEF->EF_PREFIXO+;
										SEF->EF_TITULO +;
										SEF->EF_PARCELA+;
										SEF->EF_TIPO )
		RecLock("SEF",.F.)
		SEF->EF_IMPRESS := " "
		SEF->EF_NUM 	 := Space( Len(SEF->EF_NUM) )
		msUnlock()
	EndIf
	dbSelectArea("SEF")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga o cheque se ainda nao foi impresso 								 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SEF->EF_IMPRESS == "A"
		RecLock( "SEF" )
		dbDelete()
		WriteSX2( "SEF" )
		MsUnlock()
	EndIf
	dbSkip()
End
dbSkip( -1 )
If Empty( SEF->EF_TITULO ) .And. Empty( SEF->EF_IMPRESS )
	RecLock( "SEF" )
	dbDelete()
	WriteSX2( "SEF" )
	MsUnlock()
EndIf
// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Executa a contabilizacao 									 ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nHdlPrv != 0 .and. nTotal > 0
	RodaProva(nHdlPrv,nTotal)
	cA100Incl(cArquivo,nHdlPrv,3,cLote,.T.,.F.)
End

dbSelectArea("SE2")
dbGoTo( nRegSE2 )

Return( Nil )