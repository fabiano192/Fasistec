#INCLUDE "PROTHEUS.CH"

//Banco de Horas

USER Function BCOHR()

Local oReport
Local aArea 		:= GetArea()
Private nSaldo	  	:= 0
Private nSaldoAnt 	:= 0
Private nSaldoFil   := 0
Private nSaldoEmp   := 0
Private dDataAux  	:= Ctod('') 	//-- Variavel auxiliar para armazenar a ultima data
									//-- considerada no calculo do Saldo Anterior									
If FindFunction("TRepInUse") .And. TRepInUse()	//Verifica se relatorio personalizal esta disponivel
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("PN100R",.F.)
	oReport := ReportDef()
	oReport:PrintDialog()	
Else
	PONR100R3()	
EndIf  

RestArea( aArea )

Return Nil


Static Function PONR100R3()         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1  := "Relatorio de Banco de Horas"
Local cDesc2  := "Ser  impresso de acordo com os parametros solicitados pelo usuario."
Local cDesc3  := ""
Local cString := "SRA"        				// alias do arquivo principal (Base)
Local aOrd    := {"Matricula","Centro de Custo","Nome","C.Custo+Nome"}		//
Local wnRel
Local aRegs   := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn := { "Zebrado", 1,"Administra‡„o", 1, 2, 1,"",1 }	//
Private nomeprog:= "PONR100"
Private aLinha  := {},nLastKey := 0
Private cPerg   := "PNR100"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Titulo	 := "RELATORIO DE BANCO DE HORAS"
Private cCabec
Private AT_PRG  := "PONR100"
Private wCabec0 := 1
Private wCabec1 := ""	//	STR0013 //"Fil Matr.  Funcionario                               Data     Evento                        Debito    Credito       Saldo  Status"
Private cCabSin := ""	//	STR0015 //"Fil Matr.  Funcionario                                                   Saldo Anterior     Debito    Credito       Saldo  Status"
Private CONTFL  := 1
Private LI      := 0
Private nTamanho:= "M"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nOrdem
Private aInfo 		:= {} 
Private lIdentFu	:=	.T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("PNR100",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="PONR100"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)
Titulo := Titulo + " ( "+DTOC(MV_PAR21)+" a "+DTOC(MV_PAR22)+" )"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna a Ordem do Relatorio                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem   := aReturn[8]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis MV_PAR?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilDe   := MV_PAR01			//Filial  De
cFilAte  := MV_PAR02			//Filial  Ate
cCcDe    := MV_PAR03			//Centro de Custo De
cCcAte   := MV_PAR04			//Centro de Custo Ate
cMatDe   := MV_PAR05			//Matricula De
cMatAte  := MV_PAR06			//Matricula Ate
cNomDe   := MV_PAR07			//Nome De
cNomAte  := MV_PAR08			//Nome Ate
cTurDe	 := MV_PAR09			//Turno De
cTurAte	 := MV_PAR10			//Turno Ate
cRegDe	 := MV_PAR11			//Regra de Apontamento De
cRegAte	 := MV_PAR12			//Regra de Apontamento Ate
cSit     := MV_PAR13			//Situacao
cCat     := MV_PAR14			//Categoria
lSalta   := ( MV_PAR15 == 1 )	//Imprime C.C em outra Pagina
lFuncS   := ( MV_PAR16 == 1 )	//Func. Outra Pagina
lSint    := ( MV_PAR17 == 1 )	//Sintetico ou Analitico
lImpFil  := ( MV_PAR18 == 1 )	//Imprime Total Filial
lImpEmp  := ( MV_PAR19 == 1 )	//Imprime Total Empresa
nImpRel	 := MV_PAR20			//Impr. Eventos (Proventos/Descontos/Ambos) 1-Proventos	2-Descontos	3-Ambos
dPerIni	 := MV_PAR21			//Periodo De
dPerFim	 := MV_PAR22			//Periodo Ate
nHoras	 := MV_PAR23			// Horas Normais/Valorizadas 1-Normais 	2-Valorizadas
nSalBH	 := MV_PAR24			// Imprimir com Saldo (Resultado/Credor/Devedor) 1-Resultado	2-Credor 3-Devedor
nTpEvento:= MV_PAR25			// Imprimir Eventos (Autorizados/N.Autorizados/Ambos) 1-Autorizado	2-N.Autorizado 3-Ambos
lIdentFu := Iif(MV_PAR26==1,.T.,.F.)	// Imprime somente os totais, ou também as linhas detalhe
       
IF lIdentFu
	wCabec1 := "Fil Matr.  Funcionario                               Data     Evento                        Debito    Credito       Saldo  Status"
	cCabSin := "Fil Matr.  Funcionario                                                   Saldo Anterior     Debito    Credito       Saldo  Status"
Else
	wCabec1 := "                                                     Data     Evento                        Debito    Credito       Saldo  Status"
	cCabSin := "                                                                         Saldo Anterior     Debito    Credito       Saldo  Status"
EndIf

If lSint
	wCabec1 := cCabSin
Endif

If	nLastKey = 27
	Return
Endif

SetDefault(aReturn,cString)

If	nLastKey = 27
	Return
Endif

RptStatus({|lEnd| PNR100Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PNR100Imp³ Autor ³ R.H. - Ze Maria       ³ Data ³ 03.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Banco de Horas                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ PNR100Imp(lEnd,wnRel,cString)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd        - A‡Æo do Codelock                             ³±±
±±³          ³ wnRel       - T¡tulo do relat¢rio                          ³±±
±±³Parametros³ cString     - Mensagem                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PNR100Imp(lEnd,WnRel,cString)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aLancaE   := {}
Local aLancaF   := {}
Local aLancaC   := {}
Local aSomaE    := {}
Local aSomaF    := {}
Local aSomaC    := {}
Local aLanca    := {}
Local cAcessaSRA:= &("{ || " + ChkRH("PONR100","SRA","2") + "}")
Local nValor	:=	0 //-- Variavel auxiliar para calculo do Saldo Anterior
Local nSaldComp := 0  //-- Variavel auxiliar para comparacao de saldo

Private nSaldo	  := 0
Private nSaldoAnt := 0
Private nSaldoAC  := 0
Private nSaldoAF  := 0
Private nSaldoAE  := 0
Private lRoda	  := .F.    
Private dDataAux  := Ctod('') 	//-- Variavel auxiliar para armazenar a ultima data
								//-- considerada no calculo do Saldo Anterior

dbSelectArea( "SRA" )
dbGoTop()

If nOrdem == 1
	dbSetOrder( 1 )
	dbSeek(cFilDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim     := cFilAte + cMatAte
ElseIf nOrdem == 2
	dbSetOrder( 2 )
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 3
	dbSetOrder( 3 )
	dbSeek(cFilDe + cNomDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim     := cFilAte + cNomAte + cMatAte
ElseIf nOrdem == 4
	dbSetOrder(8)
	dbSeek(cFilDe + cCcDe + cNomDe,.T.)
	cInicio  := 'SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME'
	cFim     := cFilAte + cCcAte + cNomAte
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua de Processamento                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(SRA->(RecCount()))

cFilAnterior := Space(FWGETTAMFILIAL)
cCcAnt  	 := Space(GetSx3Cache("RA_CC", "X3_TAMANHO"))

While !EOF() .And. &cInicio <= cFim
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua de Processamento                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncRegua()

	If lEnd
		@Prow()+1,0 PSAY "** CANCELADO PELO OPERADOR **"
		Exit
	Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica Quebra de Filial                                    ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If SRA->RA_FILIAL != cFilAnterior
      If !fInfo(@aInfo,Sra->ra_FILIAL)
         Exit
	   Endif
		If !Empty(cFilAnterior)
			fImpFil(@aLancaF)    // Totaliza Filial
	   Endif
		cFilAnterior := SRA->RA_FILIAL
   Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste controle de acessos e filiais validas               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If  SRA->( !(RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA) )
		fTestaTotal(@aLanca,@aLancaC,@aLancaF,@aLancaE,)
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	//³ Consiste Parametrizacao do Intervalo de Impressao            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( SRA->RA_CC   < cCcDe )   .Or. ( SRA->RA_CC > cCcAte ) .Or. ;
	   ( SRA->RA_NOME < cNomDe )  .Or. ( SRA->RA_NOME > cNomAte ) .Or. ;
		( SRA->RA_MAT < cMatDe )   .Or. ( SRA->RA_MAT > cMatAte ) .Or. ;
		( SRA->RA_TNOTRAB < cTurDe).Or. ( SRA->RA_TNOTRAB > cTurAte) .Or. ;
		( SRA->RA_REGRA < cRegDe) 	.Or. ( SRA->RA_REGRA > cRegAte)
		fTestaTotal(@aLanca,@aLancaC,@aLancaF,@aLancaE,)
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Situacao e Categoria do Funcionario                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	!(SRA->RA_SITFOLH $ cSit) .Or. !(SRA->RA_CATFUNC $ cCat)
		fTestaTotal(@aLanca,@aLancaC,@aLancaF,@aLancaE,)
		Loop
	Endif

	// Totalizador do Saldo
	nSaldo    := 0
	nSaldoAnt := 0
	lPrimeira := .T.
	aLanca    := {}
	nValor	  := 0
    dDataAux  := CTOD(SPACE(8))		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica lancamentos no Banco de Horas                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "SPI" )
	dbSetOrder(2)
	dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
	While SPI->( !Eof() .and. PI_FILIAL+PI_MAT == SRA->( RA_FILIAL+RA_MAT ) )

		//-- Verifica tipo de Evento quando for diferente de Ambos
		If nTpEvento <> 3
			If !fBscEven(SPI->PI_PD,2,nTpEvento)
				SPI->(dbSkip())
				Loop
			EndIf
		Else
			PosSP9(SPI->PI_PD,SRA->RA_FILIAL,"P9_TIPOCOD")
		Endif

		// Totaliza Saldo Anterior
		If SPI->PI_DATA < dPerIni
			If SP9->P9_TIPOCOD $  "1*3"
				If nImpRel == 1 .Or. nImpRel == 3
					nValor:=If(SPI->PI_STATUS=="B",0,If(nHoras=1,SPI->PI_QUANT,SPI->PI_QUANTV))
					//-- Para valor nao nulo considera a Data para Referencia do Saldo
				    dDataAux:=If(Empty(nValor),dDataAux,SPI->PI_DATA)
					nSaldoAnt:=__TimeSum(nSaldoAnt,nValor)  
				Endif
			Else
				If nImpRel == 2 .Or. nImpRel == 3
					nValor:=If(SPI->PI_STATUS=="B",0,If(nHoras=1,SPI->PI_QUANT,SPI->PI_QUANTV))
					//-- Para valor nao nulo considera a Data para Referencia do Saldo
					dDataAux:=If(Empty(nValor),dDataAux,SPI->PI_DATA)
					nSaldoAnt:=__TimeSub(nSaldoAnt,nValor)
				Endif
			Endif
			nSaldo   := nSaldoAnt
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica os Lancamentos a imprimir                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If	SPI->PI_DATA < dPerIni .Or. SPI->PI_DATA > dPerFim
			dbSkip()
			Loop
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Acumula os lancamentos de Proventos/Desconto em Array        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FSoma(@aLanca,1)	// Funcionario
		FSoma(@aSomaC,2)	// Centro de Custo
		FSoma(@aSomaF,3)	// Filial
		FSoma(@aSomaE,4)	// Empresa

		dbSelectArea( "SPI" )
		dbSkip()

	Enddo

	dbSelectArea( "SRA" )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Testa total de lancamentos						             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	Len(aLanca) == 0 .AND. EMPTY(nSaldoAnt)     
		fTestaTotal(@aLanca,@aLancaC,@aLancaF,@aLancaE,)
		Loop
	Endif
	//-- Se nao houve movimento no periodo sera comparado o tipo de saldo (credito ou debito
	//-- com o saldo anterior
	//-- Senao sera comparado o resultado do mes
	If	Len(aLanca) == 0 
	    nSaldComp:= nSaldoAnt
	Else
	    nSaldComp:= aLanca[Len(aLanca),5]
	Endif    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Funcionarios                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( nSalBH == 1  .Or. (nSalBH == 2 .And. nSaldComp >= 0) .Or.;
	 	                    (nSalBH == 3 .And. nSaldComp < 0)) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Funcionarios                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nSaldoAC := __TimeSum(nSaldoAC,nSaldoAnt)
		nSaldoAF := __TimeSum(nSaldoAF,nSaldoAnt)
		nSaldoAE := __TimeSum(nSaldoAE,nSaldoAnt)
		fSomaSaldo(@aLancaC,@aSomaC)
		fSomaSaldo(@aLancaF,@aSomaF)
		fSomaSaldo(@aLancaE,@aSomaE)
		If lIdentFu
			fImpFun(@aLanca)
		EndIf
	Else
		aSomaC := {}
		aSomaF := {}
		aSomaE := {}
	Endif

	fTestaTotal(@aLanca,@aLancaC,@aLancaF,@aLancaE)

Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime o RodaPe                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lRoda
	IF LI != 58
		Li := 58
	EndIF
	Impr("","F")
EndIF	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SPI")
dbSetOrder(1)
dbSelectArea("SRA")
dbSetOrder(1)
Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif
MS_FLUSH()


//*----------------------------------------------------------*
// Executa Quebras
//*----------------------------------------------------------*
Static Function fTestaTotal(aLanca,aLancaC,aLancaF,aLancaE)
	cFilAnterior := SRA->RA_FILIAL
	cCcAnt := SRA->RA_CC
	dbSelectArea( "SRA" )
	dbSkip()

	If Eof() .Or. &cInicio > cFim
		fImpCc(@aLancaC)
		fImpFil(@aLancaF)
		fImpEmp(@aLancaE)
	Elseif cFilAnterior != SRA->RA_FILIAL
		fImpCc(@aLancaC)
		fImpFil(@aLancaF)
	Elseif cCcAnt != SRA->RA_CC .And. !Eof()
		fImpCc(@aLancaC)
	Endif
	
	dbSelectArea("SRA")
Return



//*---------------------------------*
// Acumula Lancamentos
//*---------------------------------*
Static Function fSoma(aLanca,nTipo)

Private nPos:=0

IF SP9->( P9_TIPOCOD $ "1*3" .and. nImpRel == 2 .or. P9_TIPOCOD == "2" .and. nImpRel == 1  )
	Return( NIL )
EndIF

If nTipo > 1 .And. (nPos:=aScan(aLanca,{ |x| x[2] == SPI->PI_PD })) > 0
	If SPI->PI_STATUS <> "B"
		If SP9->P9_TIPOCOD $ "1*3"
			aLanca[nPos,4] := __TimeSum(aLanca[nPos,4],If(nHoras==1,SPI->PI_QUANT,SPI->PI_QUANTV))
		Else
			aLanca[nPos,3] := __TimeSum(aLanca[nPos,3],If(nHoras==1,SPI->PI_QUANT,SPI->PI_QUANTV))
		Endif
	Endif
Else
	aAdd(aLanca ,{})
	aAdd(aLanca[Len(aLanca)],SPI->PI_DATA)
	aAdd(aLanca[Len(aLanca)],SPI->PI_PD)
	If SP9->P9_TIPOCOD $ "1*3"
		If nTipo == 1
			nSaldo:=__TimeSum(nSaldo,If(SPI->PI_STATUS=="B",0,If(nHoras==1,SPI->PI_QUANT,SPI->PI_QUANTV)))
		Endif
		aAdd(aLanca[Len(aLanca)],0.00)

		If nTipo > 1 .And. SPI->PI_STATUS == "B"
			aAdd(aLanca[Len(aLanca)],0.00)
		Else
			aAdd(aLanca[Len(aLanca)],If(nHoras==1,SPI->PI_QUANT,SPI->PI_QUANTV))
		Endif

		aAdd(aLanca[Len(aLanca)],nSaldo)
	Else
		If nTipo == 1
			nSaldo:=__TimeSub(nSaldo,If(SPI->PI_STATUS=="B",0,If(nHoras==1,SPI->PI_QUANT,SPI->PI_QUANTV)))
		Endif

		If nTipo > 1 .And. SPI->PI_STATUS == "B"
			aAdd(aLanca[Len(aLanca)],0.00)
		Else
			aAdd(aLanca[Len(aLanca)],If(nHoras==1,SPI->PI_QUANT,SPI->PI_QUANTV))
		Endif

		aAdd(aLanca[Len(aLanca)],0.00)
		aAdd(aLanca[Len(aLanca)],nSaldo)
	Endif
	aAdd(aLanca[Len(aLanca)],If(nTipo==1,SPI->PI_STATUS," "))	//
Endif

Return Nil

*-------------------------------------*
Static Function fSomaSaldo(aLanca,aSoma) // Acumula Lancamentos
*-------------------------------------*
Local nQ := 0

For nQ:=1 to Len(aSoma)
	// Totaliza as colunas do Funcionario Lido com as de  outro funcionario
	If (nPos:=aScan(aLanca,{ |x| x[2] == aSoma[nQ,2] })) > 0
	  	//-- Soma Coluna Credito 
	  	aLanca[nPos,4] := __TimeSum(aLanca[nPos,4],aSoma[nQ,4])
	  	//-- Soma Coluna Debito
		aLanca[nPos,3] := __TimeSum(aLanca[nPos,3],aSoma[nQ,3])
		
	Else
		aAdd(aLanca ,{})
		aAdd(aLanca[Len(aLanca)],aSoma[nQ,1] )
		aAdd(aLanca[Len(aLanca)],aSoma[nQ,2] )
		aAdd(aLanca[Len(aLanca)],aSoma[nQ,3] )
		aAdd(aLanca[Len(aLanca)],aSoma[nQ,4] )
		aAdd(aLanca[Len(aLanca)],aSoma[nQ,5] )
		aAdd(aLanca[Len(aLanca)],aSoma[nQ,6] )

	Endif
Next

aSoma := {}

Return Nil

*-----------------------------*
Static Function fImpFun(aLanca)            // Imprime um Funcionario
*-----------------------------*
If	Len(aLanca) == 0 .AND. EMPTY(nSaldoAnt)
	Return Nil
Endif

fImprime(aLanca,1)

aLanca := {}

Return Nil

*-----------------------------*
Static Function fImpCc(aLancaC)             // Imprime Centro de Custo
*-----------------------------*
If Len(aLancaC) == 0 .AND. EMPTY(nSaldoAC)
	Return Nil
Endif

If nOrdem == 2 .Or. nOrdem == 4
	fImprime(aLancaC,2) // Imprime
Endif

aLancaC := {}
nSaldoAC := 0

Return Nil

*-------------------------------*
Static Function fImpFil(aLancaF)            // Imprime Filial
*-------------------------------*
If	Len(aLancaF) == 0 .AND. EMPTY(nSaldoAF)
	Return Nil
Endif

If	lImpFil
	fImprime(aLancaF,3)
Endif

aLancaF := {}
nSaldoAF := 0

Return Nil

*-------------------------------*
Static Function fImpEmp(aLancaE)            // Imprime Empresa
*-------------------------------*
If Len(aLancaE) == 0 .AND. EMPTY(nSaldoAE)
	Return Nil
Endif

If lImpEmp
	fImprime(aLancaE,4)
Endif

aLancaE := {}
nSaldoAE := 0

Return Nil

*-----------------------------------------------*
Static Function fImprime(aLanca,nTipo)
*-----------------------------------------------*
// nTipo: 1- Funcionario
//        2- Centro de Custo
//        3- Filial
//        4- Empresa

Local nConta := 0
Local nTVP := nTVD := nLIQ := 0   // Totais dos Valores

If nTipo == 1
	If lPrimeira
		Det:= PADR(SRA->RA_FILIAL+"  "+SRA->RA_MAT+" "+Left(SRA->RA_NOME,30),52)
		If !lSint
			cDataAux:=Iif(Empty(dDataAux),SPACE(11),PADR(DTOC(dDataAux),12))
			Det:= PADR(Det+cDataAux+"Saldo Anterior",110)+TransForm(nSaldoAnt,"@e 99999999.99")	//
		Endif
		If !lSint
			IMPR(DET,"C")
		Endif
	Endif
	If !lSint
		Det := Space(52)
	Endif
Elseif nTipo == 2
	DET:= PADR("TOTAL C.CUSTO "+cCcAnt+"-"+DescCc(cCcAnt,cFilAnterior,30),120)	//
Elseif nTipo == 3
	DET:= PADR("TOTAL FILIAL  "+cFilAnterior+"-"+aInfo[1],86)	//
Elseif nTipo == 4
	DET:= PADR("TOTAL EMPRESA "+aInfo[3],86)	//
Endif

If nTipo > 1 .Or. (lSint .And. nTipo == 1) //-- Sintetico ou Totais
	Det := PADR(Det,77)
	For nConta :=1 TO Len(aLanca)
		IF aLanca[nConta,6] <> "B"
			nTVD := __TimeSum(nTVD,aLanca[nConta,3])
			nTVP := __TimeSum(nTVP,aLanca[nConta,4])
		Endif
	Next
	nVal :=IF(nTipo==1,nSaldoAnt,IF(nTipo==2,nSaldoAC,IF(nTipo==3,nSaldoAF,nSaldoAE)))

	If lSint
		Det += Transform(nVal,"@e 9999999.99")+" "
	Else
		Det += SPACE(11)
	Endif
	Det += Transform(nTVD,"@e 9999999.99")+" "
	Det += Transform(nTVP,"@e 9999999.99")+" "
	Det += Transform(__TimeSum(nVal,__TimeSub(nTVP,nTVD)),"@e 99999999.99")

	If nTipo >  1
		IMPR(REPLICATE("-",132) ,"C")
	Endif

	Impr(Det,"C")
	
	IMPR(REPLICATE("-",132) ,"C") 
Else

	If	Li == 60
		Det:= PADR(SRA->RA_FILIAL+"  "+SRA->RA_MAT+" "+Left(SRA->RA_NOME,30),52)
	Endif

	For nConta :=1 TO Len(aLanca)
		Det:= PADR(Det,52)
		Det+= PADR(DTOC(aLanca[nConta,1]),10)+" "+aLanca[nConta,2]+"-"+;
				Left(DescPdPon(aLanca[nConta,2],SRA->RA_FILIAL),20)+" "+;
				Transform(aLanca[nConta,3],'@E 9999999.99')+" "+;
				Transform(aLanca[nConta,4],'@E 9999999.99')+" "+;
				Transform(aLanca[nConta,5],'@E 99999999.99')+"  "+;
				IF(aLanca[nConta,6]=="B","Baixado","Pendente")
		IF lIdentFu
			Impr(Det,"C")
		EndIF
		If	Li == 60
			Det:= PADR(SRA->RA_FILIAL+"  "+SRA->RA_MAT+" "+Left(SRA->RA_NOME,30),52)
		Else
			Det := " "
		Endif
	Next

Endif

If	nTipo == 1
	If	lFuncS
		Impr("","P")            // Salta Pagina a cada funcionario
	Else
		If !lSint
			Impr("","C")
		Endif
	Endif
Elseif nTipo == 2
	If lSalta
		Impr("","P")
	Else
		Impr("","C")
	Endif
Else
	Impr("","P")
Endif

lPrimeira := .F.
lRoda	  := .T.

Return Nil
/*
***********************************************************************************************************************************
*MICROSIGA SOFTWARE S/A                                    																		  Folha:      00001*
*S.I.G.A. / PONR060        Relatorio de Banco de Horas      																	  DT.Ref.: 99/99/99*
*Hora...: 14:45:40                                           																	  Emissao: 09/12/98*
***********************************************************************************************************************************
Fil C.Custo   Matr.  Funcionario                      Data     Evento                       Debito    Credito       Saldo  Status
Fil C.Custo   Matr.  Funcionario                      Data               Saldo Anterior     Debito    Credito       Saldo  Status
***********************************************************************************************************************************
                                                               Saldo Anterior 999999.99       0,00       0,00 99999999,99
99  999999999 999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/9999 999-XXXXXXXXXXXXXXXXXXXX 9999999,99 9999999,99 99999999,99  Baixado
                                                    99/99/9999 999-XXXXXXXXXXXXXXXXXXXX 9999999,99 9999999,99 99999999,99  Pendente
                                                    99/99/9999 999-XXXXXXXXXXXXXXXXXXXX 9999999,99 9999999,99 99999999,99  Baixado
                                                    99/99/9999                999999.99 9999999,99 9999999,99 99999999,99  Baixado

-----------------------------------------------------------------------------------------------------------------------------------
                                                               Saldo Anterior                 0,00       0,00 99999999,99
99  999999999 999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/9999 999-XXXXXXXXXXXXXXXXXXXX 9999999,99 9999999,99 99999999,99  Baixado
                                                    99/99/9999 999-XXXXXXXXXXXXXXXXXXXX 9999999,99 9999999,99 99999999,99  Pendente
                                                    99/99/9999 999-XXXXXXXXXXXXXXXXXXXX 9999999,99 9999999,99 99999999,99  Baixado
                                                    99/99/9999 999-XXXXXXXXXXXXXXXXXXXX 9999999,99 9999999,99 99999999,99  Baixado
-----------------------------------------------------------------------------------------------------------------------------------

TOTAL C.CUSTO 999999999-XXXXXXXXXXXXXXXXXXXX                                            9999999,99 9999999,99 99999999,99
TOTAL FILIAL  99-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                         9999999,99 9999999,99 99999999,99
TOTAL EMPRESA 99-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                         9999999,99 9999999,99 99999999,99



*/
