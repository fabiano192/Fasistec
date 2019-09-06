#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ PA0017   ³ Autor ³ Alexandro da Silva    ³ Data ³ 10.07.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impress„o de Cheques                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Pa0017                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function Pa0017()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
SetPrvt("NCASAS,NCOLANO,NTAMCHQ,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,TITULO,ARETURN,NOMEPROG,NLASTKEY,CPERG")
SetPrvt("LCOMP,LLAYOUT,NLINVLR,WNREL,MV_PAR01,MV_PAR02")
SetPrvt("MV_PAR03,MV_PAR04,CNUMCHEQ,CCOND1,NPOSTOT,NSAVREC")
SetPrvt("CBENEF,NLIN,LFIRST,AMES,CEXTENSO,NPOSANT")
SetPrvt("LMOVBCO,CNATGPE,NSALTO,NCOLVLR,NLIN1EXT,NCOL1EXT")
SetPrvt("NLIN2EXT,NCOL2EXT,NTAMEXT,NLINFAV,NCOLFAV,NLINDAT")
SetPrvt("NCOLVIR,CEXT1,NLOOP,CEXT2,CSIMB,CVALOR")
SetPrvt("NREPETE,NTAMANHO,CCHEQANT,NREGCHEQ,NREGPROX,LI")
SetPrvt("NOPCA,CSAVSCR1,CSAVCOR1,CRESP,CTESTE,LRET")
*/

Private nColVlr
Private nLin1Ext
Private nCol1Ext
Private nLin2Ext
Private nCol2Ext
Private nLinFav
Private nColFav
Private nLinDat
Private nColVir
Private cExt
Private nCasas  :=0
Private nColAno :=0
Private nTamChq	:=0
Private nTamExt
Private nTamLin
Private cValor
Private nSalto

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cDesc1    := OemToAnsi("Este programa ira imprimir os Cheques do Banco, atraves de")
Private cDesc2    := OemToAnsi("formulario pre-impresso.")
Private cDesc3    := ""
Private CbTxt
Private CbCont
Private cString   := "SEF"

PRIVATE wnrel
PRIVATE titulo  := OemToAnsi("Emissao de Cheques em Formulario Continuo")
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn := { OemToAnsi("Cheque"), 1, OemToAnsi("Administracao"), 1, 2, 1, "",1 }  
PRIVATE nomeprog:= "PA0017"
PRIVATE nLastKey:= 0
PRIVATE cPerg   := "FIN480"
PRIVATE lComp   := .T.
PRIVATE lLayOut := .F.
PRIVATE nLinVlr := 0
PRIVATE cNumCheq
PRIVATE cBenef

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN480",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Codigo do Banco                       ³
//³ mv_par02            // Agencia                               ³
//³ mv_par03            // Conta                                 ³
//³ mv_par04            // Do Cheque                             ³
//³ mv_par05            // Ate o Cheque                          ³
//³ mv_par06            // Numera cheque automaticamente (S/N)   ³
//³ mv_par07            // Numero do 1.Cheque                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "PA0017"

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| VerCheq(@lEnd,wnRel,cString)},Titulo)


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VerCheq  ³ Autor ³ Alexandro da Silva    ³ Data ³ 10/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de Cheques                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA600                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VerCheq()

If !( "DEFAULT" $ Upper( __DRIVER ) )
	SetPrc(000,000)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe o Banco                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA6")
dbSeek(cFilial+mv_par01+mv_par02+mv_par03)
IF !Found()
	Help(" ",1,"BCONOEXIST")
	Return
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se j  existe o cheque inicial                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par06 == 1
	dbSelectArea("SEF")
	If (dbSeek(cFilial+mv_par01+mv_par02+mv_par03+mv_par07))
		Help( " ",1,"A460CHEQUE")
		Return
	 EndIf
EndIf

mv_par01:=mv_par01+Space( 3-Len(mv_par01))
mv_par02:=mv_par02+Space( 5-Len(mv_par02))
mv_par03:=mv_par03+Space(10-Len(mv_par03))
mv_par04:=mv_par04+Space(15-Len(mv_par04))

cNumCheq := mv_par07

IF !Empty( mv_par07 ) .and. mv_par06 == 1   //Cheques n„o gerados
	dbSelectArea( "SEF" )
	dbSeek( cFilial )
	cCond1 := ".T."
Else
	dbSelectArea("SEF")
	dbSeek( cFilial+mv_par01+mv_par02+mv_par03+mv_par04,.T. )
	cCond1:="SEF->EF_BANCO==mv_par01.and.SEF->EF_AGENCIA==mv_par02.and.SEF->EF_CONTA==mv_par03.and.EF_NUM<=mv_par05"
EndIF

SetRegua(RecCount())

While !SEF->(Eof()) .and. SEF->EF_FILIAL = cFilial .and. &cCond1
	IncRegua()
	nPosTot:=1
	IF SEF->EF_IMPRESS $ "SAC" 
		SEF->(dbSkip( ))
		Loop
	Endif

	If !Empty( EF_BANCO)
		If EF_BANCO != mv_par01
			dbSkip( )
			Loop
		EndIf
	EndIf

	IF mv_par06 == 2 .and. ( Empty( SEF->EF_NUM ) .or. SubStr( SEF->EF_NUM,1,1 ) = "*" )
		SEF->(dbSkip( ))
		Loop
	EndIF

	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³ Se houver selecao de banco, filtra o banco escolhido.    ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	 If !Empty(SEF->EF_BANCO)
		 If SEF->EF_BANCO #mv_par01 .or. ;
			 SEF->EF_AGENCIA #mv_par02 .or. ;
			 SEF->EF_CONTA #mv_par03     
			 SEF->(dbSkip())
			 Loop
		 Endif
	 Endif

	 *ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	 *³ Recupera o extenso do cheque e monta as linhas           ³
	 *ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	 dbSkip( )
	 nSavRec := RecNo()
	 dbSkip( -1 )
	 cBenef := SEF->EF_BENEF
	 IF Empty(SEF->EF_BENEF) .and. !(SEF->EF_ORIGEM $ "FINA390AVU#FINA100PAG")
        dbSelectArea("SE2")
        dbSetOrder(1)
 		If dbSeek(cFilial+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA)
    	   IF !Empty( SE2->E2_PORTADO )
		      dbSelectArea( "SA6" )
			  dbSeek( cFilial + SE2->E2_PORTADO )
			  cBenef := SA6->A6_NOME
		   Else
		      dbSelectArea( "SA2" )
			  dbSeek( cFilial + SE2->E2_FORNECE + SE2->E2_LOJA )
			  cBenef := SA2->A2_NOME
   		   Endif
   		Endif   
	Endif

	If !ImpCheq(mv_par01,mv_par02,mv_par03)
		Exit
	Endif

	dbSelectArea( "SEF" )
	dbGoTo( nSavRec )
	
Enddo

//@nLinVlr, 0 PSAY Chr(27)+Chr(48)  // (48 = 1/8)  (64 = 1/6)
//@nLinVlr, 0 PSAY Chr(18)+" "



Set Device To Screen
dbSelectArea("SEF")
dbSetOrder(1)
dbSelectArea("SA6")
dbSetOrder(1)
Set Filter To

Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
Endif
MS_FLUSH()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ImpCheq   ³ Autor ³ Wagner Xavier         ³ Data ³ 09.07.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Imprime um determinado cheque                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ImpCheq                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpCheq(cBanco,cAgencia,cConta,lMovBco)

LOCAL cValor
LOCAL nPosTot   :=1
LOCAL nSavRec
LOCAL nLin      :=0
LOCAL lFirst    :=.T.
LOCAL cCheqAnt
LOCAL nRegProx
LOCAL nRegCheq
LOCAL aMes      := { OemToAnsi("Janeiro"),OemToAnsi("Fevereiro"),OemToAnsi("Marco"),;
			         OemToAnsi("Abril"),OemToAnsi("Maio"),OemToAnsi("Junho"),;
  			         OemToAnsi("Julho"),OemToAnsi("Agosto"),OemToAnsi("Setembro"),;  
			         OemToAnsi("Outubro"),OemToAnsi("Novembro"),OemToAnsi("Dezembro") }   

Local cExtenso  := Extenso( SEF->EF_VALOR,.F.,1 )
Local cExt1
Local cExt2
Local nPosAnt := 1
Local nTamanho
Local nLoop
Local nRepete
lMovBco := Iif(lMovbco=Nil,.f.,.t.)
cNatGpe := GETMV("MV_CHQGPE")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se cheque foi configurado.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF Empty( SA6->A6_LAYOUT )
	Help(" ",1,"CHEQNAOCONF")
	Return .f.
Endif

If ! lLayout
	nTamChq :=Val(Substr(SA6->A6_LAYOUT,1,2))
	nSalto  :=Val(Substr(SA6->A6_LAYOUT,3,1))
	nLinVlr :=Val(SubStr(SA6->A6_LAYOUT,4,1))
	nColVlr :=Val(SubStr(SA6->A6_LAYOUT,25, 3))
	nColVlr :=IIF(nColVlr==0,93,nColVlr)
	nLin1Ext:=Val(SubStr(SA6->A6_LAYOUT,5,1))-nLinVlr
	nCol1Ext:=Val(SubStr(SA6->A6_LAYOUT,6,2))
	nLin2Ext:=Val(SubStr(SA6->A6_LAYOUT,8,1))-Val(SubStr(SA6->A6_LAYOUT,5,1))
	nCol2Ext:=Val(SubStr(SA6->A6_LAYOUT,9,2))
	nTamExt :=Val(SubStr(SA6->A6_LAYOUT,23, 2))
	nTamExt :=IIF(nTamExt==0,95,nTamExt)
	nLinFav :=Val(SubStr(SA6->A6_LAYOUT,11,2))-Val(SubStr(SA6->A6_LAYOUT,8,1))
	nColFav :=Val(SubStr(SA6->A6_LAYOUT,13,2))
	nLinDat :=Val(SubStr(SA6->A6_LAYOUT,15,2))-Val(SubStr(SA6->A6_LAYOUT,11,2))
	nColVir :=Val(SubStr(SA6->A6_LAYOUT,17,2))
	nCasas  :=Val(SubStr(SA6->A6_LAYOUT,19,1))
	nCasas  :=IIF(nCasas==0,2,nCasas)
	nColAno :=Val(SubStr(SA6->A6_LAYOUT,20,3))
	lComp   :=(SubStr(SA6->A6_LAYOUT,28, 1)=="S" .or. SubStr(SA6->A6_LAYOUT,28, 1)==" ")
	lLayOut := .T.

//	nLinVlr :=FA480Test(nColVlr)

	If  nLinVlr == 99
		 Return .f.
	Endif

Endif

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Verifica se o extenso ultrapassa o tamanho de colunas    ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cExt1 := SubStr (cExtenso,1,nTamExt ) // 1.a linha do extenso
nLoop := Len(cExt1)

While .T.

	If Len(cExtenso) == Len(cExt1) .And. Len(cExt1)+nCol1Ext <= nTamExt
		Exit
	EndIf

	If SubStr(cExtenso,Len(cExt1),1) == " " .And. Len(cExt1)+nCol1Ext <= nTamExt
		Exit
	EndIf

	cExt1 := SubStr( cExtenso,1,nLoop )
	nLoop --
Enddo

cExt2 := SubStr(cExtenso,Len(cExt1)+1,nTamExt) // 2.a linha do extenso
cExt1 += Replicate( "*",nTamExt - Len(cExt1) - nCol1Ext )
cExt2 += Replicate( "*",nTamExt - Len(cExt2) - nCol2Ext )

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Imprime o cheque                                         ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lFirst
	@nLinVlr, 0 PSAY Chr(27)+Chr(64)
	If nSalto = 8
		@nLinVlr, 0 PSAY Chr(27)+Chr(48)
	Endif
	If lComp
	 @nLinVlr,0 PSAY Chr(15)
	Endif
Endif

cSimb  :=GETMV("MV_SIMB1")
cValor :=Alltrim(Transform(SEF->EF_VALOR,PesqPict("SEF","EF_VALOR",17)))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Ajuste do posicionamento da impressora: compactada: 1 posi‡„o ;  ³
//³  sem compactar: 2 posi‡”es; segunda impress„o em diante: sem      ³
//³  ajuste. Lembrete: ajuste apenas no primeiro cheque.              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
__LogPages()
If lFirst
	If lComp
		@nLinVlr,nColVlr+1 PSAY cSimb
	Else
		@nLinVlr,nColVlr+2 PSAY cSimb
	Endif
	lFirst := .F.
Else
	@nLinVlr,nColVlr PSAY cSimb
Endif

nRepete := pCol()+Len(cValor)+17-Len(cValor) - nTamExt

If nRepete > 0
	cValor += Replicate("*",17-Len(cValor)-nRepete)
Else
	cValor += Replicate("*",17-Len(cValor))
EndIf

@nLinVlr,PCOL()             PSAY cValor
@Prow()+nLin1Ext,nCol1Ext   PSAY cExt1
@Prow()+nLin2Ext,nCol2Ext   PSAY cExt2
@Prow()+nLinFav ,nColFav    PSAY IIF(cBenef==NIL,SEF->EF_BENEF,cBenef)
nTamanho    :=1+Len(Trim(SA6->A6_MUN))
@Prow()+nLinDat,nColVir-nTamanho  PSAY SA6->A6_MUN
@Prow(),nColVir+1           PSAY Day(SEF->EF_DATA)  PicTure "99"
@Prow(),Pcol()+6            PSAY aMes[Month(SEF->EF_DATA)]
IF nCasas=1
	@Prow(),nColAno         PSAY SubStr(Str(Year(SEF->EF_DATA),4),4,1)
Else
	@Prow(),nColAno         PSAY SubStr(Str(Year(SEF->EF_DATA),4),3,2)
Endif
dbSelectArea("SEF")
nLinVlr+=nTamChq

Reclock("SEF")
Replace EF_IMPRESS With "S"
MsUnlock( )

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Caso cheque n„o tenha sido gerado, ira gravar a movimen-³
*³ ‡„o banc ria e atualizar cheque emitido                 ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF (Empty( SEF->EF_NUM ) .or. SubStr(SEF->EF_NUM, 1, 1 ) = "*") .Or. nModulo == 7   //GPE
	lMovbco := .T.
	cCheqAnt := SEF->EF_NUM
	If nModulo != 7     // GPE, o cheque j  foi gerado pelo GPER280
		Reclock( "SEF" )
		Replace 	EF_NUM     With cNumCheq,;
					EF_BANCO   With mv_par01,;
					EF_AGENCIA With mv_par02,;
					EF_CONTA   With mv_par03,;
					EF_BENEF   With cBenef
		MsUnlock( )
	Endif    
	nRegCheq := RecNo( )
	If ( Empty(cCheqAnt) )
		 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		 //³ Grava o numero do cheque no SE2 - para contabilizacao   ³
		 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		 If nModulo != 7          //GPE         
			dbSelectArea( "SE2" )
			If SE2->(dbSeek(cFilial+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA))
				RecLock("SE2")
				Replace E2_NUMBCO With  cNumCheq
				MsUnlock()              
			Endif
			dbSelectArea("SE5")
			dbSetOrder(4)
			dbSeek(xFilial("SE5")+SE2->E2_NATUREZ+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO,.T.)
			While ( !Eof() .And. xFilial("SE5") == SE5->E5_FILIAL .And.;
						SE2->E2_NATUREZ == SE5->E5_NATUREZ .And.;
						SE2->E2_PREFIXO == SE5->E5_PREFIXO .And.;
						SE2->E2_NUM     == SE5->E5_NUMERO  .And.;
						SE2->E2_PARCELA == SE5->E5_PARCELA .And.;
						SE2->E2_TIPO    == SE5->E5_TIPO )
				If ( SE2->E2_FORNECE+SE2->E2_LOJA == SE5->E5_CLIFOR+SE5->E5_LOJA )
					RecLock("SE5",.F.)
					SE5->E5_BANCO   := mv_par01 
					SE5->E5_AGENCIA := mv_par02 
					SE5->E5_CONTA   := mv_par03 
					SE5->E5_NUMCHEQ := SE2->E2_NUMBCO
					MsUnlock()
				EndIf
				dbSelectArea("SE5")
				dbSkip()
			EndDo
			dbSelectArea("SEF")
		Endif
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso cheque tenha sido gerado, ir  regravar novo numero ³
	//³ nos elementos do cheque.                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SubStr(cCheqAnt,1,1) = "*"
		dbSelectArea( "SEF" )
		dbSetOrder(1)
		dbSeek( cFilial + mv_par01 + mv_par02 + mv_par03 + cCheqAnt )
		While !Eof() .and. mv_par01+mv_par02+mv_par03+cCheqAnt == EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM .And.;
			SEF->EF_FILIAL == xFilial("SEF")
			dbSkip( )
			nRegProx := RecNo()
			dbSkip( -1 )
			Reclock( "SEF" )
			Replace EF_NUM   With cNumCheq
			Replace EF_BENEF With cBenef
			MsUnlock( )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava o numero do cheque no SE2 - para contabilizacao   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nModulo != 7          //GPE         
				dbSelectArea( "SE2" )
				If SE2->(dbSeek(cFilial+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA))
					RecLock("SE2")
					Replace E2_NUMBCO With  cNumCheq
					MsUnlock()              
				Endif
			Endif
			dbSelectArea( "SEF" )
			dbSetOrder(1)        
			dbGoTo( nRegProx )
		EndDO
	Endif
	dbGoTo( nRegCheq )
Endif

If lMovBco
	Reclock( "SE5",.T. )
	Replace	E5_FILIAL      With cFilial ,;
				E5_BANCO       With cBanco  ,;
				E5_AGENCIA     With cAgencia,;
				E5_CONTA       With cConta  ,;
				E5_BENEF       With SEF->EF_BENEF,;
				E5_DATA        With SEF->EF_DATA,;
				E5_NUMCHEQ     With SEF->EF_NUM,;
				E5_DTDIGIT     With SEF->EF_DATA,;
				E5_HISTOR      With SEF->EF_HIST,;
				E5_RECPAG      With "P",;
				E5_TIPODOC     With "CH",;
				E5_DTDISPO     With SEF->EF_DATA,;
				E5_VALOR       With SEF->EF_VALOR
	If nModulo == 7      //GPE
		Replace E5_NATUREZ     With &cNatGpe
	Endif
	MsUnlock()

	If nModulo != 7          //GPE
		If SE2 -> E2_TIPO != "PA "
			Reclock("SE5")
			Replace E5_NATUREZ     With SE2->E2_NATUREZ
			MsUnlock()
		Endif
	Endif 

	If nModulo != 7  .Or. (nModulo = 7 .And. Select("SE8") > 0)         //GPE
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o Saldo Bancario                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AtuSalBco( cBanco,cAgencia,cConta,SEF->EF_DATA,SEF->EF_VALOR,"-")
	Endif
	cNumCheq:=Soma1(Trim(cNumCheq),Len(Trim(cNumCheq)))
Endif
Return .t.

/*

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ fa480Test³ Autor ³ Wagner Xavier         ³ Data ³ 14/02/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Teste da emissao do cheque                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fa480test                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Static Function FA480TEST(nColVlr)

Local nOpca
Local oDlg
LOCAL li:=nLinVlr        

DEFINE MSDIALOG oDlg TITLE OemToAnsi(titulo) RESOURCE "PROCESS" OF oMainWnd

REDEFINE PSAY PROMPT OemToAnsi("Antes de iniciar a impress„o, verifique se o formul rio continuo est  ajustado.") ID 101 OF oDlg  
REDEFINE PSAY PROMPT OemToAnsi("O teste ser  impresso na coluna do valor.")  ID 102 OF oDlg  
REDEFINE PSAY PROMPT OemToAnsi("Clique no botao impressora para teste de posicionamento.")  ID 103 OF oDlg  
REDEFINE PSAY PROMPT OemToAnsi("Formulario posicionado corretamente ?")  ID 104 OF oDlg  

REDEFINE SBUTTON TYPE 1 ID 301 ACTION (nOpca := 1,oDlg:End())      ENABLE OF oDlg
REDEFINE SBUTTON TYPE 6 ID 302 ACTION (li:=CKIMP(nColVlr),nOpca:=0)   ENABLE OF oDlg 

ACTIVATE MSDIALOG oDlg  

Return li


±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CKIMP    ³ Autor ³ Marcos Patricio       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime caracter para teste                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ CKIMP                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINR480                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß


Static Function CKIMP(nColVlr)

LOCAL cTeste
LOCAL li :=nLinVlr
cTeste := "."
If lComp
	cTeste:=Chr(15)+"."
Endif
@li,00      PSAY cTeste
@li,nColVlr PSAY "."
Return li
*/