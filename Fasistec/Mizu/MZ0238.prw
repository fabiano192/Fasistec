#INCLUDE "RWMAKE.CH"
#INCLUDE "topconn.ch"

/*/{Protheus.doc} MZ0238
//Boleto Banco BANESTES
@since 25/09/2018
@version 1.0
/*/

User Function MZ0238(aDadosFiltro)

	Local   aCampos 	:= {{"E1_NOMCLI","Cliente","@!"},{"E1_PREFIXO","Prefixo","@!"},{"E1_NUM","Titulo","@!"},;
	{"E1_PARCELA","Parcela","@!"},{"E1_VALOR","Valor","@E 9,999,999.99"},{"E1_VENCTO","Vencimento"}}
	Local   nOpc 		:= 0
	Local   aMarked 	:= {}
	Local   aDesc 		:= {"Este programa imprime os boletos de","cobranca bancaria de do banco BANESTES","de acordo com os parametros informados","pelo usuário."}

	Private nTaxa 		:= GetNewPar("MV_E1JUROS",0)
	Private nMulta		:= GetNewPar("MV_E1MULTA",2)
	Private nDiasProt	:= GetNewPar("MV_E1PROTE"," 3 ")
	Private Exec    	:= .T.
	Private cIndexName  := ''
	Private cIndexKey   := ''
	Private cFilter     := ''
	Private cPerg		:= "RFINF2"
	Private nTitPag     := 0
	Private lBlAuto 	:= aDadosFiltro <> NIL //ParamIXB <> NIL
	Private cBanco		:= "021"//GetNewPar("MZ_YBANCO","237")
	Private _cBarra     := ""

	Private cAgencia	:= Padr('0160',TAMSX3('A6_AGENCIA')[1])//GetNewPar("MZ_YAGENCI","02144")

	//	Private aConta		:=  {{"01"  ,"0045001"},{"02"  ,"2895589"}}
	Private aConta		:=  {{"02"  ,"28955896"}}

	ValidPerg()
	Pergunte (cPerg,.F.)

	If !lBlAuto
		nOpc 		:= FSTelaProc("Impressao de Boleto Banco Banestes",aDesc,cPerg)
	Else
		nOpc 		:= 1
		MV_par01 := aDadosFiltro[1] //Filtra Por?
		MV_PAR02 := aDadosFiltro[2] //Bordero?
		MV_PAR03 := aDadosFiltro[3] //Do Prefixo?
		MV_PAR04 := aDadosFiltro[4] //Ate o Prefixo?
		MV_PAR05 := aDadosFiltro[5] //Do Numero
		MV_PAR06 := aDadosFiltro[6] //Até o Numero
	Endif

	If nOpc == 1

		DbSelectArea('SB1')
		DbSetOrder(1)

		wAliasQRY:= "XSE1"

		cSq02 := " SELECT * "
		cSq02 += " FROM " + RetSqlName("SE1")
		cSq02 += " WHERE D_E_L_E_T_ = '' "
		cSq02 += "   AND E1_FILIAL = '"+xFilial('SE1')+"'"
		Do Case
			Case mv_par01 == 1
			cSq02 += "   AND E1_NUMBOR = '"+MV_PAR02+"' "
			Case mv_par01 == 2
			cSq02 += "   AND E1_PREFIXO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
			cSq02 += "   AND E1_NUM     BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
		EndCase

		If Select(wAliasQRY)>0
			DbSelectArea(wAliasQRY)
			DbCloseArea()
		Endif
		TcQuery cSq02 New Alias (wAliasQRY)

		TCSETFIELD((wAliasQRY),"E1_VALOR" ,"N",14,2)
		TCSETFIELD((wAliasQRY),"E1_SALDO" ,"N",14,2)	           // Marcus Vinicius - 09/08/16 - Adicionado TCSetField
		TCSETFIELD((wAliasQRY),"E1_VLCRUZ","N",14,2)	           // Marcus Vinicius - 09/08/16 - Adicionado TCSetField

		nRecords:= fTransfTrb(wAliasQRY)

		If !lBlAuto
			Exec:=.f.

			@ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecao de Titulos"

			aCampos := {}
			AADD(aCampos,{"E1_OK","Mk","@!"})
			AADD(aCampos,{"E1_PREFIXO","Documento","@!"})
			AADD(aCampos,{"E1_NUM","Serie"})
			AADD(aCampos,{"E1_PARCELA","Cliente"})
			AADD(aCampos,{"E1_CLIENTE","Cliente"})
			AADD(aCampos,{"E1_LOJA","Loja"})
			AADD(aCampos,{"E1_EMISSAO","Emissao","@D"})
			AADD(aCampos,{"E1_VENCTO","Vencto"})
			AADD(aCampos,{"E1_VALOR","Valor","@E 999,999,999.99"})

			@ 6,5 TO 170,330 BROWSE "TRBXXX" FIELDS aCampos MARK "E1_OK"

			@ 180,310 BMPBUTTON TYPE 01 ACTION (Exec := .T.,Close(oDlg))
			@ 180,280 BMPBUTTON TYPE 02 ACTION (Exec := .F.,Close(oDlg))

			ACTIVATE DIALOG oDlg CENTERED

			TRBXXX->(DbGoTop())
			Do While !TRBXXX->(Eof())
				If Marked("E1_OK")
					AADD(aMarked,.T.)
				Else
					AADD(aMarked,.F.)
				Endif
				dbSkip()
			EndDo

		Endif

		dbGoTop()

		If Exec
			Processa({|lEnd|MontaRel(aMarked)})
		Endif

	Endif

Return(Nil)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³ RAIMUNDO PEREIRA      ³ Data ³
01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS
³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ EspecIfico para Clientes Microsiga
³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel(aMarked)

	Local oPrint
	Local lBcoNaoOk
	Local n := 0
	Local aDadosEmp
	Local aDadosTit
	Local aDadosBanco
	Local aDatSacado
	Local aBolText		:= {"APOS VENCIDO COBRAR R$ ",;
	"MULTA DE R$ ",;
	"PROTESTAR APOS "+nDiasProt+"DIAS DO VENCIMENTO.",;
	MV_PAR07}
	Local i           := 1
	Local CB_RN_NN    := {}
	Local nRec        := 0
	Local _nVlrAbat   := 0

	Private _cCart:=''

	aDadosEmp    		:= {	SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
	SM0->M0_ENDCOB                                                            ,; //[2]Endereço
	AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
	"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
	"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
	"C.N.P.J.: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
	Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
	Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
	"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
	Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

	oPrint:= TMSPrinter():New( "Boleto Banco Banestes" )
	oPrint:SetPortrait() // ou SetLandscape()
	oPrint:StartPage()   // Inicia uma nova página

	DbSelectArea("SA6")
	DbSetOrder(1)

	nPosCta   := aScan(aConta,{|x| x[1] == SM0->M0_CODIGO})
	cContaKey := Alltrim(PadR(aConta[nPosCta,2],TAMSX3('A6_NUMCON')[1]))

	SA6->(MsSeek(xFilial("SA6")+cBanco+cAgencia+cContaKey))

	DbSelectArea("SA1")
	DbSetOrder(1)

	DbSelectArea("SEE")
	DbSetOrder(1)

	SEE->(MsSeek(xFilial("SEE")+cBanco+cAgencia+cContaKey ))

	TRBXXX->(dbGoTop())
	ProcRegua(nRecords)

	Do While !TRBXXX->(EOF())

		//Posiciona o SA6 (Bancos)
		DbSelectArea("SE1")
		DbSetOrder(2)
		MsSeek(xFilial('SE1')+TRBXXX->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA))

		If SE1->E1_EMISSAO = SE1->E1_VENCTO .And. SE1->E1_TIPO = "NF"
			TRBXXX->(dbSkip())
			Loop
		Endif

		_cSa1Bco := Posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_BCO1")

		lBcoNaoOk := .T.

		If SE1->E1_PORTADO == "021" .Or. _cSa1Bco == "021"
			lBcoNaoOk := .F.
		Endif

		If lBcoNaoOk
			ApMsgInfo("O código de banco informado no cadastro do cliente não é 021. Esta rotina imprime apenas boletos para o BANESTES. Altere para 021 o banco do cliente e você conseguirar imprimir por aqui.",TRBXXX->(E1_CLIENTE+E1_LOJA+"-"+E1_PREFIXO+E1_NUM+E1_PARCELA) )
			TRBXXX->(dbSkip())
			LOOP
		Endif

		_cCart		:= SEE->EE_CODCOBE
		If EMPTY(_cCart)
			_cCart		:= '09'
		Endif

		nBaseMod	:= 7
		nBaseMod	:= IIf(_cCart=='09',7,9)
		cNossoNum	:= Left(SE1->E1_NUMBCO,08)
		cDVNN 		:= SubStr(SE1->E1_NUMBCO,09,02)

		If Empty(cNossoNum)

			aNum := {"0","1","2","3","4","5","6","7","8","9"}
			aLet := {" ","A","B","C","D","E","F","G","H","I"}

			//Digito_BR(cNossoNum)
			cNossoNum	:= U_NossoNumero(cBanco)

			//cNossoNum	:= Digito_BR(cNossoNum)

			se1->(RecLock("SE1"))
			SE1->E1_NUMBCO := cNossoNum
			SE1->(MsUnLock())

			cDVNN 		:= SubStr(SE1->E1_NUMBCO,12,1)
			cNossoNum	:= Left(SE1->E1_NUMBCO,11)

		ElseIf Empty(cDVNN)

			wNumero 	:= Rtrim(cNossoNum)
			cNossoNum	:= u_Digito_BR() //DIGITO DO BANCO BANESTES
			cDVNN 		:= SubStr(cNossoNum,12,1)
			cNossoNum	:= Left(cNossoNum,11)

			RecLock("SE1")
			SE1->E1_NUMBCO := cNossoNum+cDVNN
			SE1->(MsUnLock())

		Endif

		aDadosBanco:= {SA6->A6_COD             		                    ,; // [1]Numero do Banco
		SA6->A6_NREDUZ    	            	                    ,; // [2]Nome do Banco
		AllTrim(SA6->A6_AGENCIA),;//Substr(AllTrim(SA6->A6_AGENCIA),1,Len(AllTrim(SA6->A6_AGENCIA))-1),; // [3]Agência
		fConta(AllTrim(SA6->A6_NUMCON)) ,;  // [4]Conta Corrente
		Substr(AllTrim(SA6->A6_NUMCON),Len(AllTrim(SA6->A6_NUMCON)),1)    ,; // [5]Dígito da conta corrente
		_cCart												    ,; // [6]Codigo da Carteira
		SA6->A6_TXCOBSI									    ,;//  [7]Multa Atrazo COBRANCA SIMPLES
		nTaxa                                                  ,;
		AllTrim(SA6->A6_DVAGE) }//Subs(AllTrim(SA6->A6_AGENCIA),Len(AllTrim(SA6->A6_AGENCIA)),1)     }// [9]Digito da Agencia

		If Empty(SA1->A1_ENDCOB)
			aDatSacado:= {AllTrim(SA1->A1_NOME)                           ,;      // [1]Razão Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      // [2]Código
			AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      // [3]Endereço
			AllTrim(SA1->A1_MUN )                            ,;      // [4]Cidade
			SA1->A1_EST                                      ,;      // [5]Estado
			SA1->A1_CEP                                      ,;      // [6]CEP
			AllTrim(SA1->A1_CGC)										 }       // [7]CGC
		Else
			aDatSacado:= {AllTrim(SA1->A1_NOME)                           	 ,;   // [1]Razão Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   // [2]Código
			AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   // [3]Endereço
			AllTrim(SA1->A1_MUNC)	                             ,;   // [4]Cidade
			SA1->A1_ESTC	                                     ,;   // [5]Estado
			SA1->A1_CEPC                                        ,;   // [6]CEP
			AllTrim(SA1->A1_CGC)										 }    // [7]CGC
		Endif

		_nVlrAbat   := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],"0",AllTrim(SE1->E1_NUM),(SE1->E1_SALDO-_nVlrAbat),SE1->E1_VENCTO)

		aDadosTit   := {AllTrim(SE1->E1_NUM)+'/'+AllTrim(SE1->E1_PARCELA)	,;  // [1] Número do título
		DToC(SE1->E1_EMISSAO)                              					,;  // [2] Data da emissão do título
		DtoC(Date())                                  					,;  // [3] Data da emissão do boleto
		DToC(SE1->E1_VENCTO)                               					,;  // [4] Data do vencimento
		(SE1->E1_SALDO - _nVlrAbat)                  					,;  // [5] Valor do título
		cNossoNum                           					    ,;  // [6] Nosso número (Ver fórmula para calculo) CB_RN_NN[3]
		SE1->E1_PREFIXO                               					,;  // [7] Prefixo da NF
		SE1->E1_TIPO	                               						,;  // [8] Tipo do Titulo
		0 															,;   // [9] Outros acrescimos
		SE1->E1_VALJUR                                               ,; // [10] Juros de Mora
		cDVNN }  // [11] Digito V. Nosso Numero

		nTitPag := 1
		oPrint:StartPage()   // Inicia uma nova página
		Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
		oPrint:EndPage() // Finaliza a página

		TRBXXX->(dbSkip())
		IncProc()
		i := i + 1
	EndDo

	oPrint:EndPage()     // Finaliza a página
	oPrint:Preview()     // Visualiza antes de imprimir

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ RAIMUNDO PEREIRA      ³ Data ³
01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS
³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ EspecIfico para Clientes Microsiga
³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
	Local oFont8
	Local oFont10
	Local oFont16
	Local oFont16n
	Local oFont14n
	Local oFont13n
	Local oFont24
	Local i := 0
	Local aCoords1 := {}
	Local aCoords2 := {}
	Local aCoords3 := {}
	Local aCoords4 := {}
	Local aCoords5 := {}
	Local aCoords6 := {}
	Local aCoords7 := {}
	Local aCoords8 := {}
	Local oBrush
	Local nLinha   := 50  //0 ----------------------alterei aqui sergio------------------------------
	Local nLinBar  := 50  //0

	If nTitPag == 2
		nLinha := 1750 //1050
		nLinBar:= 80.4 //30.4//14.8//7.4
	Endif

	oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16 := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont14n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont13n:= TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

	aCoords3 := {0690+nLinha,1900,0760+nLinha,2300}
	aCoords4 := {0900+nLinha,1900,0970+nLinha,2300}
	aCoords5 := {1250+nLinha,1900,1320+nLinha,2300}

	oPrint:Line (0050+nLinha,550,0150+nLinha, 550)//coluna 1
	oPrint:Line (0050+nLinha,700,0235+nLinha, 700)//coluna 2
	oPrint:Line (0150+nLinha,300,0235+nLinha, 300)//coluna 3
	oPrint:Line (0150+nLinha,950,0235+nLinha, 950)//coluna 4
	oPrint:Line (0235+nLinha,450,0405+nLinha, 450)//coluna 5
	oPrint:Line (0235+nLinha,800,0405+nLinha, 800)//coluna 6

	oPrint:Line (0150+nLinha,100,0150+nLinha,1150)//linha 1
	oPrint:Line (0235+nLinha,100,0235+nLinha,1150)//linha 2
	oPrint:Line (0320+nLinha,100,0320+nLinha,1150)//linha 3
	oPrint:Line (0405+nLinha,100,0405+nLinha,1150)//linha 4
	oPrint:Line (0490+nLinha,100,0490+nLinha,1150)//linha 5

	oPrint:Say  (0080+nLinha,0780,OemToAnsi("Recibo do Sacado"),oFont16)
	oPrint:Say  (0155+nLinha,0100,OemToAnsi("Vencimento"),oFont8)
	oPrint:Say  (0155+nLinha,0310,OemToAnsi("Agencia / Codigo Cedente"),oFont8)
	oPrint:Say  (0155+nLinha,0710,OemToAnsi("Espécie"),oFont8)
	oPrint:Say  (0155+nLinha,0960,OemToAnsi("Quantidade"),oFont8)
	oPrint:Say  (0240+nLinha,0100,OemToAnsi("(=) Valor do Documento"),oFont8)
	oPrint:Say  (0240+nLinha,0460,OemToAnsi("(-) Desconto / Abatimento"),oFont8)
	oPrint:Say  (0240+nLinha,0810,OemToAnsi("(+) Multa / Juros / Acresc"),oFont8)
	oPrint:Say  (0325+nLinha,0100,OemToAnsi("(=) Valor Cobrado"),oFont8)
	oPrint:Say  (0325+nLinha,0460,OemToAnsi("Nosso Numero"),oFont8)
	oPrint:Say  (0325+nLinha,0810,OemToAnsi("N° do Documento"),oFont8)
	oPrint:Say  (0410+nLinha,0100,OemToAnsi("Sacado"),oFont8)
	oPrint:Say  (0500+nLinha,0450,OemToAnsi("Autenticação mecânica"),oFont8)

	//	oPrint:Say  (0080+nLinha,100,aDadosBanco[2],oFont16n )	                                   //[2]Nome do Banco
	oPrint:SayBitmap(00025+nLinha,130,"banestes.jpg",0315,0120)
	//	oPrint:Say  (0080+nLinha,100,aDadosBanco[2],oFont16n )	                                   //[2]Nome do Banco
	oPrint:Say  (0080+nLinha,560,aDadosBanco[1],oFont14n )	                                   //[1]Numero do Banco
	oPrint:Say  (0190+nLinha,0130,aDadosTit[4],oFont10)                                  //Vencimento
	oPrint:Say  (0190+nLinha,0330,aDadosBanco[3]+"-"+aDadosBanco[9]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)//Agencia/Cod.Cedente
	oPrint:Say  (0190+nLinha,0800,"R$",	oFont10)                                               //aDadosTit[8] Tipo do Titulo
	oPrint:Say  (0190+nLinha,1050,"0,00",	oFont10)                                           //aDadosTit[8] Tipo do Titulo
	oPrint:Say  (0275+nLinha,0300,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)//Valor do documento

	If !Empty(aDadosTit[9])
		oPrint:Say  (0275+nLinha,1000,AllTrim(Transform(aDadosTit[9],"@E 999,999,999.99")),oFont10)
		oPrint:Say  (0360+nLinha,0300,AllTrim(Transform(aDadosTit[5]+aDadosTit[9],"@E 999,999,999.99")),oFont10)
	Endif

	oPrint:Say  (0360+nLinha,0470,aDadosTit[6]+"-"+aDadosTit[11],oFont10)                                        //Nosso Numero  aDadosTit[6]+"-"+Alltrim(Str(Modulo11(aDadosTit[6])))
	oPrint:Say  (0360+nLinha,0860,aDadosTit[7]+aDadosTit[1],oFont10)                           //Prefixo +Numero+Parcela
	oPrint:Say  (0450+nLinha,120 ,aDatSacado[1],oFont10)//Nome
	oPrint:Say  (0050+nLinha,1200,"|",oFont8)
	oPrint:Say  (0100+nLinha,1200,"|",oFont8)
	oPrint:Say  (0150+nLinha,1200,"|",oFont8)
	oPrint:Say  (0200+nLinha,1200,"|",oFont8)
	oPrint:Say  (0250+nLinha,1200,"|",oFont8)
	oPrint:Say  (0300+nLinha,1200,"|",oFont8)
	oPrint:Say  (0350+nLinha,1200,"|",oFont8)
	oPrint:Say  (0400+nLinha,1200,"|",oFont8)
	oPrint:Say  (0450+nLinha,1200,"|",oFont8)
	oPrint:Say  (0500+nLinha,1200,"|",oFont8)
	oPrint:Say  (0550+nLinha,1200,"|",oFont8)

	oPrint:Line (0050+nLinha,1700,0150+nLinha, 1700)//coluna 1
	oPrint:Line (0050+nLinha,1850,0235+nLinha, 1850)//coluna 2
	oPrint:Line (0150+nLinha,1450,0235+nLinha, 1450)//coluna 3
	oPrint:Line (0150+nLinha,2100,0235+nLinha, 2100)//coluna 4
	oPrint:Line (0235+nLinha,1600,0320+nLinha, 1600)//coluna 5
	oPrint:Line (0405+nLinha,1950,0490+nLinha, 1950)//coluna 6

	oPrint:Line (0150+nLinha,1250,0150+nLinha,2300)
	oPrint:Line (0235+nLinha,1250,0235+nLinha,2300)
	oPrint:Line (0320+nLinha,1250,0320+nLinha,2300)
	oPrint:Line (0405+nLinha,1250,0405+nLinha,2300)
	oPrint:Line (0490+nLinha,1250,0490+nLinha,2300)

	oPrint:Say  (0080+nLinha,1930,OemToAnsi("Recibo de Entrega"),oFont16)
	oPrint:Say  (0155+nLinha,1250,OemToAnsi("Vencimento"),oFont8)
	oPrint:Say  (0155+nLinha,1460,OemToAnsi("Agencia / Codigo Cedente"),oFont8)
	oPrint:Say  (0155+nLinha,1860,OemToAnsi("Espécie"),oFont8)
	oPrint:Say  (0155+nLinha,2110,OemToAnsi("Quantidade"),oFont8)
	oPrint:Say  (0240+nLinha,1250,OemToAnsi("(=) Valor do Documento"),oFont8)
	oPrint:Say  (0240+nLinha,1610,OemToAnsi("Nosso Numero"),oFont8)
	oPrint:Say  (0325+nLinha,1250,OemToAnsi("Cedente"),oFont8)
	oPrint:Say  (0405+nLinha,1250,OemToAnsi("Sacado"),oFont8)
	oPrint:Say  (0405+nLinha,1960,OemToAnsi("Data de Entrega"),oFont8)
	oPrint:Say  (0500+nLinha,1250,OemToAnsi("Assinatura do Recebedor"),oFont8)

	//	oPrint:Say  (0080+nLinha,1250,aDadosBanco[2],oFont16n )	                                    //[2]Nome do Banco
	oPrint:SayBitmap(00025+nLinha,1280,"banestes.jpg",0315,0120)
	oPrint:Say  (0080+nLinha,1710,aDadosBanco[1],oFont14n )	                                    //[1]Numero do Banco
	oPrint:Say  (0190+nLinha,1280,aDadosTit[4],oFont10)                                  //Vencimento
	oPrint:Say  (0190+nLinha,1480,aDadosBanco[3]+"-"+aDadosBanco[9]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)//Agencia/Cod.Cedente
	oPrint:Say  (0190+nLinha,1950,"R$",	oFont10)                                               //aDadosTit[8] Tipo do Titulo
	oPrint:Say  (0190+nLinha,2200,"0,00",	oFont10)                                           //aDadosTit[8] Tipo do Titulo
	oPrint:Say  (0275+nLinha,1450,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)//Valor do documento
	oPrint:Say  (0275+nLinha,2010,aDadosTit[6]+"-"+aDadosTit[11],oFont10) //Nosso NumeroSubstr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4)

	oPrint:Say  (0360+nLinha,1250,aDadosEmp[1],oFont10)	                                    //Cedente
	oPrint:Say  (0450+nLinha,1250,aDatSacado[1],oFont10)	                                    //Sacado

	For i := 100 to 2300 step 50
		oPrint:Line( 0580+nLinha, i, 0580+nLinha, i+30)
	Next i

	oPrint:Line (0690+nLinha,100,0690+nLinha,2300)//linha 1
	oPrint:Line (0760+nLinha,100,0760+nLinha,2300 )//linha 2
	oPrint:Line (0830+nLinha,100,0830+nLinha,2300 )//linha 3
	oPrint:Line (0900+nLinha,100,0900+nLinha,2300 )//linha 4
	oPrint:Line (0970+nLinha,100,0970+nLinha,2300 )//linha 5
	oPrint:Line (1040+nLinha,1900,1040+nLinha,2300 )//linha 11
	oPrint:Line (1110+nLinha,1900,1110+nLinha,2300 )//linha 6
	oPrint:Line (1180+nLinha,1900,1180+nLinha,2300 )//linha 7
	oPrint:Line (1250+nLinha,1900,1250+nLinha,2300 )//linha 8
	oPrint:Line (1320+nLinha,100 ,1320+nLinha,2300 )//linha 9
	oPrint:Line (1440+nLinha,100 ,1440+nLinha,2300 )//linha 10

	oPrint:Line (0580+nLinha,550,0690+nLinha, 550)//coluna 1
	oPrint:Line (0580+nLinha,800,0690+nLinha, 800)//coluna 2
	oPrint:Line (0830+nLinha,500,0970+nLinha,500) //coluna 3
	oPrint:Line (0900+nLinha,750,0970+nLinha,750) //coluna 4
	oPrint:Line (0830+nLinha,1000,0900+nLinha,1000)//coluna 5
	oPrint:Line (0830+nLinha,1350,0900+nLinha,1350)//coluna 6
	oPrint:Line (0830+nLinha,1550,0970+nLinha,1550)//coluna 7
	oPrint:Line (0690+nLinha,1900,1320+nLinha,1900 )//coluna 8

	oPrint:Say  (0690+nLinha,100 ,"Local de Pagamento"                             ,oFont8)
	oPrint:Say  (0690+nLinha,1910,"Vencimento"                                     ,oFont8)
	oPrint:Say  (0760+nLinha,100 ,"Cedente"                                        ,oFont8)
	oPrint:Say  (0760+nLinha,1910,"Agência/Código Cedente"                         ,oFont8)
	oPrint:Say  (0830+nLinha,100 ,"Data do Documento"                              ,oFont8)
	oPrint:Say  (0830+nLinha,505 ,"Nro.Documento"                                  ,oFont8)
	oPrint:Say  (0830+nLinha,1005,"Espécie Doc."                                   ,oFont8)
	oPrint:Say  (0830+nLinha,1355,"Aceite"                                         ,oFont8)
	oPrint:Say  (0830+nLinha,1555,"Data do Processamento"                          ,oFont8)
	oPrint:Say  (0830+nLinha,1910,"Nosso Número"                                   ,oFont8)
	oPrint:Say  (0900+nLinha,100 ,"N° da Conta / Respons."                         ,oFont8)
	oPrint:Say  (0900+nLinha,505 ,"Carteira"                                       ,oFont8)
	oPrint:Say  (0900+nLinha,755 ,"Espécie"                                        ,oFont8)
	oPrint:Say  (0900+nLinha,1005,"Quantidade"                                     ,oFont8)
	oPrint:Say  (0900+nLinha,1555,"Valor"                                          ,oFont8)
	oPrint:Say  (0900+nLinha,1910,"Valor do Documento"                          	,oFont8)
	oPrint:Say  (0970+nLinha,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
	oPrint:Say  (1320+nLinha,100 ,"Sacado"                                         ,oFont8)
	oPrint:Say  (0970+nLinha,1910,"(-)Desconto/Abatimento"                         ,oFont8)
	oPrint:Say  (1040+nLinha,1910,"(-)Outras Deduções"                             ,oFont8)
	oPrint:Say  (1110+nLinha,1910,"(+)Mora/Multa"                                  ,oFont8)
	oPrint:Say  (1180+nLinha,1910,"(+)Outros Acréscimos"                           ,oFont8)
	oPrint:Say  (1250+nLinha,1910,"(=)Valor Cobrado"                               ,oFont8)
	oPrint:Say  (1400+nLinha,100 ,"Sacador/Avalista"                               ,oFont8)
	oPrint:Say  (1445+nLinha,1500,"Autenticação Mecânica -"                        ,oFont8)
	oPrint:Say  (0622+nLinha,100,aDadosBanco[2],oFont16n )	// [2]Nome do Banco
	//	oPrint:SayBitmap(00615+nLinha,150,"banestes.jpg",0315,0120)
	oPrint:Say  (0622+nLinha,567,aDadosBanco[1],oFont14n )	// [1]Numero do Banco
	oPrint:Say  (0622+nLinha,820,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras
	oPrint:Say  (0720+nLinha,100 ,"PREFERENCIALMENTE EM QUALQUER AGENCIA BANESTES"        ,oFont10)
	oPrint:Say  (0720+nLinha,2010,aDadosTit[4] ,oFont10)
	oPrint:Say  (0790+nLinha,100 ,Alltrim(aDadosEmp[1])+"  -  "+aDadosEmp[6]	,oFont10) //Nome + CNPJ / CPF
	oPrint:Say  (0790+nLinha,2010,aDadosBanco[3]+"-"+aDadosBanco[9]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
	oPrint:Say  (0860+nLinha,100 ,aDadosTit[2]                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)
	oPrint:Say  (0860+nLinha,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela//oPrint:Say  (0860+nLinha,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
	oPrint:Say  (0860+nLinha,1050,"DM"										,oFont10) //Tipo do Titulo
	oPrint:Say  (0860+nLinha,1455,"NA0"                                            ,oFont10)
	oPrint:Say  (0860+nLinha,1655,aDadosTit[3]                               ,oFont10) // Data impressao
	oPrint:Say  (0860+nLinha,2010,aDadosTit[6]+"-"+aDadosTit[11],oFont10)//Nosso Numero//oPrint:Say  (0960+nLinha,555 ,aDadosBanco[6]                                  	,oFont10)
	oPrint:Say  (0930+nLinha,605,_cCart										,oFont10) //Tipo do Titulo
	oPrint:Say  (0930+nLinha,805,"R$"                                             ,oFont10)
	oPrint:Say  (0930+nLinha,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10) //Valor do Titulo

	If !Empty(aDadosTit[9])
		oPrint:Say  (1205+nLinha,2040,AllTrim(Transform(aDadosTit[9],"@E 999,999,999.99")),oFont10) //Outros Acrescimos
		oPrint:Say  (1275+nLinha,2010,AllTrim(Transform(aDadosTit[5]+aDadosTit[9],"@E 999,999,999.99")),oFont10) //Valor Cobrado
	Endif

	//### Texto do boleto
	oPrint:Say  (1030+nLinha,100 ,aBolText[1]+" "+AllTrim(Transform(aDadosTit[10],"@E 99,999.99"))+" REAIS POR DIA DE ATRASO"  ,oFont10)
	oPrint:Say  (1095+nLinha,100 ,aBolText[2]+" "+alltrim(Transform(nMulta,"@E 99,9" ))+"% R$ "+AllTrim(Transform(aDadosTit[5]*nMulta/100,"@E 99,999.99"))  ,oFont10)
	oPrint:Say  (1160+nLinha,100 ,aBolText[3]  ,oFont10)
	oPrint:Say  (1225+nLinha,100 ,aBolText[4]  ,oFont10)

	//### Dados do Sacado
	oPrint:Say  (1330+nLinha,400 ,aDatSacado[1]+" ("+aDatSacado[2]+") - "+"CPF / CNPJ: "+IIf(Len(aDatSacado[7])>11,TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),TRANSFORM(aDatSacado[7],"@R 999.999.999-99"))             ,oFont10)
	oPrint:Say  (1360+nLinha,400 ,aDatSacado[3]                                    ,oFont10)
	oPrint:Say  (1390+nLinha,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

	If nTitPag==1 //meio da pagina
		MSBAR("INT25"  , 13.7    , 1.25    ,_cBarra,oPrint,.F.,   ,   ,0.025     ,1.3      ,   ,   ,   ,.F.)

		For i := 100 to 2300 step 50
			oPrint:Line( 1770+nLinha, i, 1770+nLinha, i+30)
		Next i
	Else
		MSBAR("INT25"  , val(mv_par09), 1 ,CB_RN_NN[1],oPrint,NIL,NIL,NIL,0.025,1.1,NIL,NIL,"A",.F.)
	Endif


	DbSelectArea("SE1")
	RecLock("SE1",.f.)
	SE1->E1_NUMBCO := aDadosTit[6]+ aDadosTit[11]
	SE1->E1_IDCNAB := Right(ALLTRIM(SE1->E1_NUMBCO),10)
	MsUnlock()


Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³Raimundo Pereira       ³ Data ³
01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ CALCULO DO MODULO 10
³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ EspecIfico para Clientes Microsiga
³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
	Local L,D,P := 0
	Local B     := .F.
	L := Len(cData)
	B := .T.
	D := 0
	While L > 0
		P := Val(SubStr(cData, L, 1))
		If (B)
			P := P * 2
			If P > 9
				P := P - 9
			End
		End
		D := D + P
		L := L - 1
		B := !B
	End
	D := 10 - (Mod(D,10))
	If D = 10
		D := 0
	End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³Raimundo Pereira       ³ Data ³
01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ CALCULO DO MODULO 11
³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ EspecIfico para Clientes Microsiga
³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData,nBase)

	Local Tamanho, Digito, Resto, Peso := 0

	Tamanho := Len(cdata)
	Digito := 0
	Peso := 1
	While Tamanho > 0
		Peso := Peso + 1
		Digito := Digito + (Val(SubStr(cData, Tamanho, 1)) * Peso)
		If Peso = nBase
			Peso := 1
		End
		Tamanho := Tamanho - 1
	End
	Resto  := Mod(Digito,11)
	Digito := 11 - Resto
	Do Case
		Case nBase == 7 // na base 7 antes de atribuir o digito, é verIficado o resto da divisao antes de subtrai-lo de 11
		Do Case
			Case Resto == 10;    Digito := 'P'
			Case Resto == 11;    Digito := 0
			Case Resto ==  0;    Digito := 0
			OtherWise
			Digito := Resto
		Endcase
		Case nBase == 9 // na base 9 o resultado da subtração por 11 já pode ser o DV caso nao atenda a uma das condicoes abaixo
		If (Digito == 0 .Or. Digito == 1 .Or. Digito > 9 )
			Digito := 1
		End
	EndCase

Return(Digito)


//Retorna os strings para inpressão do Boleto
//CB = String para o cód.barras, RN = String com o número digitável
//Cobrança não identIficada, número do boleto = Título + Parcela

//mj Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor)

//					    		   Codigo Banco            Agencia		  C.Corrente     Digito C/C
//					               1-cBancoc               2-Agencia      3-cConta       4-cDacCC       5-cNroDoc              6-nValor
//	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],"175"+AllTrim(E1_NUM),(E1_VALOR-_nVlrAbat) )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³ RAIMUNDO PEREIRA      ³ Data ³
01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calculo da numeração do codigo de barras
³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ EspecIfico para Clientes Microsiga
³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)

	Local bldocnufinal := strzero(val(cNroDoc),8)
	Local blvalorfinal := strzero(int(nValor*100),10)
	Local dvcb         := 0
	Local dv           := 0
	Local NN           := ''
	Local RN           := ''
	Local CB           := ''
	Local s            := ''
	Local _cBsASBACE   := cNossoNum+PadL(cConta,11,"0")+"4"+"021"
	Local _cD1ASBACE   := AllTrim(Str(Modulo10(_cBsASBACE)))
	Local _cD2ASBACE   := AllTrim(Str(Modulo11(_cBsASBACE+_cD1ASBACE,7)))
	Local _cASBACE     := _cBsASBACE+_cD1ASBACE+_cD2ASBACE
	Local _cFator      := strzero(dVencto - ctod("07/10/97"),4)
	Local cCpoLivre    := AllTrim(cAgencia)+_cCart+LEFT(cNossoNum,11)+cConta+'0'

	//	-------- Definicao do CODIGO DE BARRAS
	//s    := cBanco + _cFator + StrZero(Int(nValor * 100),14-Len(_cFator)) + cCpoLivre  // ALTERADO POR ALEXANDRO

//	s    := cBanco + _cFator + StrZero((nValor * 100),14-Len(_cFator)) + cCpoLivre
	s    := cBanco + _cFator + StrZero((nValor * 100),10) + _cASBACE

	dvcb := modulo11(s,9)

	_cBarra :=  Subs(S,1,4)+ AllTrim(Str(dvcb)) + Substr(s,5,43)

	//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
	//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
	//	AAABC.CCCCX		DDDDD.DDDDDY	EEEEE.EEEEEZ	K			UUUUVVVVVVVVVV

	// 	CAMPO 1:
	//	  A	 = Codigo do banco na Camara de Compensacao
	//	  B  = Codigo da moeda, sempre 9
	//    C = As 5(cinco) primeiras posicoes do CAMPO LIVRE
	//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
//	s    := cBanco + Left(cCpoLivre,5)
	s    := cBanco + Left(_cASBACE,5)
	dv   := modulo10(s)
	RN   := SubStr(s, 1, 5) + '.' + SubStr(s, 6, 4) + AllTrim(Str(dv)) + '  '


	// 	CAMPO 2:
	//	 D = Posicoes 6 a 15 do Campo Livre
	s    := SubStr(_cASBACE, 6, 10)
	dv   := modulo10(s)
	RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '

	// 	CAMPO 3:
	//	 E = Posicoes de 16 a 25 do Campo Livre
	s    := SubStr(_cASBACE, 16, 10)
	dv   := modulo10(s)
	RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '

	// 	CAMPO 4:
	//	     K = DAC do Codigo de Barras
	RN   := RN + AllTrim(Str(dvcb)) + '  '

	// 	CAMPO 5:
	//	      UUUU = Fator de Vencimento
	//	VVVVVVVVVV = Valor do Titulo
	RN   := RN + _cFator + StrZero((nValor * 100),10)

Return({CB,RN,NN})



Static Function ValidPerg()
	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)
	aRegs:={}
	//Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs,{cPerg,"01","Filtrar por         ?","","","mv_ch1","C",01,0,1,"C","","mv_par01","1=Bordero","","","","","2=Titulo ExpecIf","","","","","3=Impressos","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Bordero             ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Do Prefixo          ?","","","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Ate o Prefixo       ?","","","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Do Numero           ?","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","Ate o Numero        ?","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07","Mensagem Adcional   ?","","","mv_ch7","C",30,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"08","Pagina              ?","","","mv_ch8","C",05,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"09","tamanho             ?","","","mv_ch9","C",05,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !MsSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	dbSelectArea(_sAlias)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FSTelaProc  ºAutor  ³Peter I Volf      º Data ³  08/10/01
º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta tela inicial de processamento genérico  com opções
º±±
±±º          ³ Padrão: Cancela, Confirma e Parametros
º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5
º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FSTelaProc(cTitulo,aDesc,cPerg)

	Local nOpc := 2
	Local i := 0

	@ 200,1 TO 380,380 DIALOG oDlg TITLE cTitulo

	For i := 1 to Len(aDesc)
		@2+(i*8),018 Say aDesc[i]
	Next i

	@ 02,05 TO 080,185

	@ 15,150 BMPBUTTON TYPE 01 ACTION Continua(@nOpc,oDlg)
	@ 35,150 BMPBUTTON TYPE 02 ACTION Close(oDlg)
	@ 55,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

	ACTIVATE DIALOG oDlg CENTERED

Return nOpc

Static Function Continua(nOpc,oDlg)
	nOpc := 1
	Close(oDlg)
Return


Static Function fConta(wConta)

	Local wRet:=""
	For nx:=1 To Len(wConta)
		If !(SubStr(wConta,nx,1) $ '!@#$%¨&*()_-+=\/?:;.,<>|^~}]{[')
			wRet+=SubStr(wConta,nx,1)
		Endif
	Next

	wRet:=SubStr(wRet,1,Len(wRet)-1) //Retira o Digito VerIficador

Return( StrZero(Val(wRet),7) )




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FTRANSFTRBºAutor  ³ ZAGO               º Data ³  17/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ TRANSFERE OS DADOS DA WORKAREA PARA UM ARQUIVO FISICO EM   º±±
±±º          ³ DISCO, SENDO POSSIVEL CRIACAO DE INDICES PARA O MESMO      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FATURAMENTO MIZU                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fTransfTrb(wAliasQRY)

	Local aFields := {}
	Local nRecs   := 0
	// Cria vetor a partir da estrutura do arquivo principal (query)
	aFields := (wAliasQRY)->(DbStruct())
	//aFields := SE1->(DbStruct())
	// Cria um arquivo de trabalho fisico no disco
	cTrab := CriaTrab(aFields)
	// Associa a área de trabalho a um arquivo fisico
	If Select("TRBXXX") > 1
		TRBXXX->(DbCloseArea())
	Endif
	dbUseArea( .T.,,cTrab, "TRBXXX", .F., .F. )
	//	dbCreateInd(cTrab,cChave,{|| &cChave})

	(wAliasQRY)->(DbGoTop())

	While !(wAliasQRY)->(Eof())
		RecLock("TRBXXX",.T.)
		For i:= 1 to (wAliasQRY)->(FCount())
			If !TRBXXX->(Alltrim(FieldName(i))) $ "R_E_C_N_O_"             // Marcus Vinicius - Chamado 28093 - Campo R_E_C_N_O_ da tabela temporária estava estourando.
				TRBXXX->(FieldPut(i,(wAliasQRY)->(FieldGet(i))))
			Endif
		Next i
		MsUnlock()
		nRecs++
		(wAliasQRY)->(DbSkip())
	EndDo
	TRBXXX->(DbGoTop())

Return nRecs

Static FUNCTION Digito_BR(WNUMERO)

	Local _num1:= WNUMERO
	Local wTipo := 2

	If wtipo == 1
		_num:="19"+ WNUMERO
	Else
		_num:="09"+ WNUMERO
	Endif
	NCDV := 1
	DO WHILE NCDV <= 13

		DO CASE

			CASE NCDV == 1
			CF1 := VAL(SUBS(_num,NCDV,1))*2
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 2
			CF2 := VAL(SUBS(_num,NCDV,1))*7
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 3
			CF3 := VAL(SUBS(_num,NCDV,1))*6
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 4
			CF4 := VAL(SUBS(_num,NCDV,1))*5
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 5
			CF5 := VAL(SUBS(_num,NCDV,1))*4
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 6
			CF6 := VAL(SUBS(_num,NCDV,1))*3
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 7
			CF7 := VAL(SUBS(_num,NCDV,1))*2
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 8
			CF8 := VAL(SUBS(_num,NCDV,1))*7
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 9
			CF9 := VAL(SUBS(_num,NCDV,1))*6
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 10
			CF10:= VAL(SUBS(_num,NCDV,1))*5
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 11
			CF11:= VAL(SUBS(_num,NCDV,1))*4
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 12
			CF12:= VAL(SUBS(_num,NCDV,1))*3
			NCDV := NCDV+1
			LOOP

			CASE NCDV == 13
			CF13:= VAL(SUBS(_num,NCDV,1))*2
			NCDV := NCDV+1
			LOOP
		ENDCASE

	ENDDO
	CF    := CF1+CF2+CF3+CF4+CF5+CF6+CF7+CF8+CF9+CF10+CF11+CF12+CF13
	A     := CF % 11
	RESTO := 11 - A

	If RESTO == 10
		DV := '0'
	ElseIf RESTO == 11
		DV := '0'
	Else
		DV := STR(RESTO,1,0)
	Endif

	_Numero := ALLTRIM(wNumero) + DV
	wNumero := Alltrim(Str(Val(_Num1) + 1))

Return(DV)