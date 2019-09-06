#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ PA0015	³ Autor ³ Alexandro da Silva      Data ³ 02.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Posi‡„o dos Titulos a Pagar								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR150(void)							  			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parƒmetros³ 													   	      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PA0015()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1 :=OemToAnsi("Imprime a posi‡„o dos titulos a pagar relativo a data base")
Local cDesc2 :=OemToAnsi("do sistema.")
LOCAL cDesc3 :=""
LOCAL wnrel
LOCAL cString:="SE2"

PRIVATE aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 2, 1, "",1 }
PRIVATE nomeprog:="PA0015"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg	 :="PA0015"
PRIVATE nJuros  :=0
PRIVATE nDesc   :=0
PRIVATE tamanho:="G"

PRIVATE titulo  := ""
PRIVATE cabec1
PRIVATE cabec2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabe‡alhos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := OemToAnsi("Posicao dos Titulos a Pagar")
cabec1 := OemToAnsi("Codigo Nome do Fornecedor   PRF-Numero         Tp  Natureza    Data de   Vencto  Vencto   Valor Original |Titulos vencidos |Titulos a vencer | Porta-| Vlr.juros ou   |Vlr.Desconto    Total a Pagar   Atraso Historico")
cabec2 := OemToAnsi("                            Parcela                            Emissao    Orig.   Real                   |Valor nominal    |Valor nominal    | dor   | permanencia    |                                                ")
//cabec2 := OemToAnsi("                            Parcela                            Emissao  Digit.    Real                   |Valor nominal    |Valor nominal    | dor   | permanencia    |                                                ")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("PA0015",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros  ³
//³ mv_par01	  // do Numero 			  ³
//³ mv_par02	  // at‚ o Numero 		  ³
//³ mv_par03	  // do Prefixo			  ³
//³ mv_par04	  // at‚ o Prefixo		  ³
//³ mv_par05	  // da Natureza		  ³
//³ mv_par06	  // at‚ a Natureza		  ³
//³ mv_par07	  // do Banco		  	  ³
//³ mv_par08	  // at‚ o Banco		  ³
//³ mv_par09	  // do Vencimento		  ³
//³ mv_par10	  // at‚ o Vencimento	  ³
//³ mv_par11	  // do Fornecedor		  ³
//³ mv_par12	  // at‚ o Fornecedor	  ³
//³ mv_par13	  // Da Emiss„o			  ³
//³ mv_par14	  // Ate a Emiss„o		  ³
//³ mv_par15	  // qual Moeda			  ³
//³ mv_par16	  // Imprime Provis¢rios  ³
//³ mv_par17	  // Reajuste pelo vencto ³
//³ mv_par18	  // Da data contabil	  ³
//³ mv_par19	  // Ate data contabil	  ³
//³ mv_par20	  // Imprime Rel anal/sint³
//³ mv_par21	  // Considera  Data Base?³
//³ mv_par22	  // Considera  Adiantamentos"
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "PA0015"
aOrd	:= {OemToAnsi("Por Numero"),OemToAnsi("Por Natureza"),OemToAnsi("Por Vencimento") ,;
OemToAnsi("Por Banco"),OemToAnsi("Fornecedor"),OemToAnsi("Por Emissao"),OemToAnsi("Por Cod.Fornec.") }
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| PA0015A(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA150Imp ³ Autor ³ Wagner Xavier		    ³ Data ³ 02.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Posi‡„o dos Titulos a Pagar								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA150Imp(lEnd,wnRel,cString)								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd	  - A‡Æo do Codeblock								  ³±±
±±³			 ³ wnRel   - T¡tulo do relat¢rio 							  ³±±
±±³			 ³ cString - Mensagem										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PA0015A(lEnd,wnRel,cString)

LOCAL CbCont
LOCAL CbTxt

LOCAL limite := 220
LOCAL nOrdem :=0
LOCAL nQualIndice := 0
LOCAL lContinua := .T.
LOCAL nTit0:=0,nTit1:=0,nTit2:=0,nTit3:=0,nTit4:=0
LOCAL nTot0:=0,nTot1:=0,nTot2:=0,nTot3:=0,nTot4:=0,nTotTit:=0,nTotJ:=0,nTotD:=0,nTotJur:=0,nTotDesc:=0
LOCAL cCond1,cCond2,cCarAnt,nTotAbat:=0,nSaldo:=0,nAtraso:=0,nSaldoNom:=0
LOCAL aCampos:={},aTam:={}
LOCAL dDataReaj
LOCAL dDataAnt := dDataBase , lQuebra
LOCAL nMestit0:= nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := nMesTitD := 0
LOCAL dDtContab

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impress„o do Cabe‡alho e Rodap‚ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt  := OemToAnsi("* indica titulo provisorio, P indica Saldo Parcial")
cbcont := 0
li     := 80
m_pag  := 1

nOrdem := aReturn[8]
cMoeda := Str(mv_par15,1)
Titulo += " em " +mv_moeda&cMoeda

dbSelectArea ( "SE2" )
Set Softseek On

IF nOrdem == 1
	dbSetOrder(1)
	dbSeek(xFilial("SE2")+mv_par03+mv_par01,.T.)
	cCond1 := "E2_PREFIXO <= mv_par04"
	cCond2 := "E2_PREFIXO"
	titulo += OemToAnsi(" - Por Numero")
	nQualIndice := 1
Elseif nOrdem == 2
	dbSetOrder(2)
	dbSeek(xFilial("SE2")+mv_par05,.T.)
	cCond1 := "E2_NATUREZ <= mv_par06"
	cCond2 := "E2_NATUREZ"
	titulo += OemToAnsi(" - Por Natureza")
	nQualIndice := 2
Elseif nOrdem == 3
	dbSetOrder(3)
	DbSeek(xFilial("SE2")+Dtos(mv_par07),.T.)
	cCond1 := "E2_VENCREA <= mv_par08"
	cCond2 := "E2_VENCREA"
	titulo += OemToAnsi(" - Por Vencimento")
	nQualIndice := 3
Elseif nOrdem == 4
	dbSetOrder(4)
	dbSeek(xFilial("SE2")+mv_par09,.T.)
	cCond1 := "E2_PORTADO <= mv_par10"
	cCond2 := "E2_PORTADO"
	titulo += OemToAnsi(" - Por Banco")
	nQualIndice := 4
Elseif nOrdem == 6
	dbSetOrder(5)
	dbSeek(xFilial("SE2")+DTOS(mv_par13),.T.)
	cCond1 := "E2_EMISSAO <= mv_par14"
	cCond2 := "E2_EMISSAO"
	titulo += OemToAnsi(" - Por Emissao")
	nQualIndice := 5
Elseif nOrdem == 7
	dbSetOrder(6)
	dbSeek(xFilial("SE2")+mv_par11,.T.)
	cCond1      := "E2_FORNECE <= mv_par12"
	cCond2      := "E2_FORNECE"
	titulo      += OemToAnsi(" - Por Cod.Fornecedor")
	nQualIndice := 6
Else
	aTam:=TamSX3("E2_NUM")
	aCampos:={ 	{"FILIAL" ,"C", 2,0},;
	{"PREFIXO","C", 3,0},;
	{"NUMERO" ,"C", aTam[1],aTam[2]},;
	{"PARCELA","C", 3,0},;
	{"TIPO"   ,"C", 3,0},;
	{"FORNECE","C", 6,0},;
	{"LOJA"   ,"C", 2,0},;
	{"NOMEFOR","C",20,0} }
	
	cNomeArq:=CriaTrab(aCampos)
	dbUseArea(.T.,,cNomeArq,"TRB",.F.,.F.)
	dbSelectArea("TRB")
	
	IndRegua("TRB",cNomeArq,"NOMEFOR+FILIAL+PREFIXO+NUMERO+PARCELA+TIPO",,,;
	OemToAnsi("Selecionando Registros..."))
	
	dbSelectArea("SE2")
	dbSetOrder(6)
	dbSeek(xFilial("SE2")+mv_par01)
	While !EOF() .and. E2_FORNECE <= mv_par12
		
		dDtContab := SE2->E2_EMIS1
		
		IF E2_NUM < mv_par01      .OR. E2_NUM     > mv_par02 .OR. ;
			E2_PREFIXO < mv_par03  .OR. E2_PREFIXO > mv_par04 .OR. ;
			E2_NATUREZ < mv_par05  .OR. E2_NATUREZ > mv_par06 .OR. ;
			E2_VENCREA < mv_par07  .OR. E2_VENCREA > mv_par08 .OR. ;
			E2_PORTADO < mv_par09  .OR. E2_PORTADO > mv_par10 .OR. ;
			E2_EMISSAO < mv_par13  .OR. E2_EMISSAO > mv_par14 .OR. ;
			E2_EMISSAO > dDataBase .OR. dDtContab  < mv_par18 .OR. ;
			dDtContab  > mv_par19
			dbSkip()
			Loop
		EndIF
		
		IF !Empty(E2_FATURA) .and. Substr(E2_FATURA,1,6) != "NOTFAT"
			dbSkip()
			Loop
		End
		
		If SE2->E2_FILIAL != xFilial("SE2")
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		Replace TRB->FILIAL		With SE2->E2_FILIAL
		Replace TRB->PREFIXO 	With SE2->E2_PREFIXO
		Replace TRB->NUMERO		With SE2->E2_NUM
		Replace TRB->PARCELA 	With SE2->E2_PARCELA
		Replace TRB->TIPO 		With SE2->E2_TIPO
		Replace TRB->FORNECE 	With SE2->E2_FORNECE
		Replace TRB->LOJA 		With SE2->E2_LOJA
		Replace TRB->NOMEFOR 	With SE2->E2_NOMFOR
		MsUnlock()
		DbSelectArea("SE2")
		dbSkip()
	EndDO
	cCond1 := "FORNECE <= mv_par12"
	cCond2 := "FORNECE"
	titulo += OemToAnsi(" - Por Fornecedor")
	nQualIndice := 6
EndIF

If mv_par20 == 1
	titulo += OemToAnsi(" - Analitico")
Else
	titulo += OemToAnsi(" - Sintetico")
	cabec1 := OemToAnsi("                                                                                          Valor Original |Titulos vencidos |Titulos a vencer |         Vlr.juros ou   |Vlr.Desconto   |Total a Pagar         ")
	cabec2 := OemToAnsi("                                                                                                         |Valor nominal    |Valor nominal    |         permanencia    |                                      ")
EndIf

/*
Codigo Nome do Fornecedor   PRF-Numero         Tp  Natureza    Data de  Vencto   Vencto   Valor Original |Titulos vencidos |Titulos a vencer | Porta-| Vlr.juros ou   |Vlr.Desconto    Total a Pagar   Atraso Historico
9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999 9999999999999
0      7                    28                 47  51          63       72       81       90              106               124                143     151             167             183             199    206
Parcela                            Emissao  Titulo    Real                   |Valor nominal    |Valor nominal    | dor   | permanencia    |
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999

*/


IF nOrdem == 5
	DbSelectArea("TRB")
	dbGoTop()
Else
	DbSelectArea("SE2")
EndIF

Set Softseek Off

SetRegua(RecCount())

While &cCond1 .and. !Eof() .and. lContinua
	
	IF nOrdem != 5
		IF SE2->E2_FILIAL > xFilial("SE2")
			Exit
		End
	End
	
	IF lEnd
		@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
		Exit
	End
	
	IncRegua()
	
	dbSelectArea("SE2")
	IF nOrdem == 5
		SE2->(dbSetOrder(1))
		dbSeek(xFilial("SE2")+TRB->PREFIXO+TRB->NUMERO+TRB->PARCELA+TRB->TIPO+TRB->FORNECE)
		SE2->(DbSetOrder(6))
	EndIF
	
	Store 0 To nTit1,nTit2
	
	IF nOrdem == 5
		dbSelectArea("TRB")
	Else
		dbSelectArea("SE2")
	End
	
	dDataAnt := Iif(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)
	
	cCarAnt := &cCond2
	
	While &cCond2 == cCarAnt .and. !Eof() .and. lContinua
		
		IF lEnd
			@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
			Exit
		End
		
		IncRegua()
		
		If SE2->E2_NUM == "127   "
			_lPare := .T.
		Endif			
		
		dbSelectArea("SE2")
		IF nOrdem == 5
			dbSetOrder(1)
			dbSeek(xFilial("SE2")+TRB->PREFIXO+TRB->NUMERO+TRB->PARCELA+TRB->TIPO+TRB->FORNECE)
			dbSetOrder(6)
		EndIF
		
		If nOrdem != 5
			IF !Empty(E2_FATURA) .and. Substr(E2_FATURA,1,6) != "NOTFAT" .and. SE2->E2_DTFATUR <= dDataBase
				dbSkip()
				Loop
			Endif
		Endif
		
		IF SubStr ( SE2 -> E2_TIPO,3,1) == "-"  .Or. ;
			SE2 -> E2_EMISSAO > dDataBase .OR. ;
			(!Empty(E2_FATURA).and.SubStr(E2_FATURA,1,6)!="NOTFAT")
			IF nOrdem == 5
				dbSelectArea("TRB")
			Else
				dbSelectArea("SE2")
			EndIF
			dbSkip()
			Loop
		EndIF
		
		IF SubStr(E2_TIPO,1,2) == "PR" .and. mv_par16 == 2
			IF nOrdem == 5
				dbSelectArea("TRB")
			Else
				DbSelectArea("SE2")
			EndIF
			dbSkip()
			Loop
		EndIF
		
		IF SubStr(E2_TIPO,1,2) == "PA" .and. mv_par22 == 2
			IF nOrdem == 5
				dbSelectArea("TRB")
			Else
				DbSelectArea("SE2")
			EndIF
			dbSkip()
			Loop
		EndIF
		
		dDtContab := SE2->E2_EMIS1
		
		If 	nOrdem != 5
			IF E2_NUM < mv_par01      .OR. E2_NUM > mv_par02 .OR. ;
				E2_PREFIXO < mv_par03  .OR. E2_PREFIXO > mv_par04 .OR. ;
				E2_NATUREZ < mv_par05  .OR. E2_NATUREZ > mv_par06 .OR. ;
				E2_VENCREA < mv_par07  .OR. E2_VENCREA > mv_par08 .OR. ;
				E2_PORTADO < mv_par09  .OR. E2_PORTADO > mv_par10 .OR. ;
				E2_FORNECE < mv_par11  .OR. E2_FORNECE > mv_par12 .OR. ;
				E2_EMISSAO < mv_par13  .OR. E2_EMISSAO > mv_par14 .OR. ;
				E2_EMISSAO > dDataBase .OR. dDtContab  < mv_par18 .OR. ;
				dDtContab  > mv_par19
				dbSkip()
				Loop
			Endif
		Endif
		
		nSaldo    := 0
		nSaldoNom := 0
		
		If MV_PAR23 == 1
			dbSelectArea("SE2")
			IF !Empty(SE2->E2_BAIXA) .and. SE2 -> E2_BAIXA <= dDataBase .and. ;
				SE2 -> E2_SALDO == 0
				IF nOrdem == 5
					dbSelectArea("TRB")
				EndIF
				dbSkip()
				Loop
			EndIF
		Endif
		
		If dDataBase > SE2->E2_VENCREA 		//vencidos
			dDataReaj := IIF(mv_par17=1,dDataBase,SE2->E2_VENCREA)
			If mv_par21 == 1
				nSaldoNom := SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,mv_par15,dDataReaj,,SE2->E2_LOJA)
			Else
				nSaldoNom := xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,mv_par15)
			Endif
		Else
			If mv_par21 == 1
				nSaldo:=SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,mv_par15,dDataReaj,,SE2->E2_LOJA)
			Else
				nSaldo:=xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,mv_par15)
			Endif
		Endif
		
		If MV_PAR23 == 1
			dbSelectArea("SE2")
			If nSaldo == 0 .And. nSaldoNom == 0
				IF nOrdem == 5
					dbSelectArea("TRB")
				EndIF
				dbSkip()
				Loop
			Endif
		Endif
			
		dbSelectArea("SA2")
		dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
		dbSelectArea("SA6")
		dbSeek(xFilial("SA6")+SE2->E2_PORTADO)
		dbSelectArea("SE2")
		
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
		EndIF
		
		nJuros:= SE2->E2_VLJUROS
		nDesc := SE2->E2_VLDESC
		
		If mv_par20 == 1
			@li,0   PSAY SE2->E2_FORNECE
			@li,7   PSAY SubStr( SE2->E2_NOMFOR, 1, 20 )
			@li, 28 PSAY SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA
			@li, 47 PSAY SE2->E2_TIPO
			@li, 51 PSAY SE2->E2_NATUREZ
			@li, 63 PSAY SE2->E2_EMISSAO
			@Li, 72 PSAY SE2->E2_VENCTO  
//			@Li, 72 PSAY SE2->E2_EMIS1  
			@li, 81 PSAY SE2->E2_VENCREA
			@li, 90 PSAY SE2->E2_VALOR Picture tm ( SE2->E2_VALOR, 14 )
		EndIf
		dbSetOrder( nQualIndice )
		If dDataBase > SE2->E2_VENCREA 		//vencidos
			dDataReaj := IIF(mv_par17=1,dDataBase,SE2->E2_VENCREA)
			If mv_par21 == 1
				nSaldoNom := SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,mv_par15,dDataReaj,,SE2->E2_LOJA)
			Else
				nSaldoNom := xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,mv_par15)
			Endif
			If Substr(SE2->E2_TIPO,1,2)!="PA" .and. SE2->E2_TIPO != "NDF"
				nTotAbat:=CalcAbat(E2_PREFIXO,E2_NUM,E2_PARCELA,mv_par15,"P")
			Endif
			If mv_par20 == 1
				@ li, 106 PSAY nSaldoNom Picture tm ( nSaldoNom, 14 )
			EndIf
			nJuros:= SE2->E2_VLJUROS
			nDesc := SE2->E2_VLDESC
			dBaixa:=dDataBase
			dbSelectArea("SE2")
			If SE2->E2_TIPO $ "PA /NDF"
				nTit0 -= SE2->E2_VALOR
				nTit1 -= (nSaldoNom-nTotAbat+nJuros-nDesc)
				nMesTit0 -= SE2->E2_VALOR
				nMesTit1 -= (nSaldoNom-nTotAbat+nJuros-nDesc)
			Else
				nTit0 += SE2->E2_VALOR
				nTit1 += (nSaldoNom-nTotAbat)
				nMesTit0 += SE2->E2_VALOR
				nMesTit1 += (nSaldoNom-nTotAbat)
			Endif
		Else				  //a vencer
			If mv_par21 == 1
				nSaldo:=SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,mv_par15,dDataReaj,,SE2->E2_LOJA)
			Else
				nSaldo:=xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,mv_par15)
			Endif
			If mv_par20 == 1
				@li,124 PSAY nSaldo Picture tm ( nSaldo, 14 )
			EndIf
			If ( SE2->E2_TIPO != "NDF" )
				nTotAbat:=CalcAbat(E2_PREFIXO,E2_NUM,E2_PARCELA,mv_par15,"P")
			Endif
			
			If SE2->E2_TIPO == "NDF" .or. Subs(SE2->E2_TIPO,1,2) == "PA"
				nTit0 -= SE2->E2_VALOR
				nTit2 -= (nSaldo-nTotAbat)
				nMesTit0 += SE2->E2_VALOR
				nMesTit2 -= (nSaldo-nTotAbat)
			Else
				nTit0 += SE2->E2_VALOR
				nTit2 += (nSaldo-nTotAbat)
				nMesTit0 += SE2->E2_VALOR
				nMesTit2 += (nSaldo-nTotAbat)
			Endif
		Endif
		
		nTotJur += nJuros
		nTotDesc += nDesc
		nMesTitJ += nJuros
		nMesTitD += nDesc
		
		If mv_par20 == 1
			@Li,143 PSAY SE2 -> E2_PORTADO
		EndIf
		
		If mv_par20 == 1
			@Li,151 PSAY SE2->E2_VLJUROS Picture Tm(SE2->E2_VLJUROS,14)
			@Li,167 PSAY SE2->E2_VLDESC  Picture Tm(SE2->E2_VLDESC,14)
		EndIf
		
		If mv_par20 == 1
			@li,183 PSAY nSaldo + nSaldoNom + SE2->E2_VLJUROS  - SE2->E2_VLDESC Picture Tm(SE2->E2_VLJUROS,14)
		EndIf
		
		IF dDataBase > E2_VENCREA
			nAtraso:=dDataBase-E2_VENCTO
			IF Dow(E2_VENCTO) == 1 .Or. Dow(E2_VENCTO) == 7
				IF Dow(dBaixa) == 2 .and. nAtraso <= 2
					nAtraso:=0
				EndIF
			EndIF
			nAtraso:=IIF(nAtraso<0,0,nAtraso)
			IF nAtraso>0
				If mv_par20 == 1
					@li,199 PSAY nAtraso Picture "9999"
				EndIf
			EndIF
		EndIF
		
		If mv_par20 == 1
			@li,206 PSAY SubStr(SE2->E2_HIST,1,13)
		EndIf
		
		If Subs(SE2->E2_TIPO,1,2)!="PA" .and. SE2->E2_TIPO != "NDF"
			nTotAbat:=Abatimentos(E2_PREFIXO,E2_NUM,E2_PARCELA,E2_FORNECE,nSaldo,mv_par15,Iif(dDataBase > E2_VENCREA,92,126),"P")
		Endif
		
		IF nOrdem == 5
			dbSelectArea("TRB")
		EndIF
		IF nTotAbat > 0 .and. mv_par20 == 1
			DevPos ( ++ li, 00 )
			DevOut("")
		End
		nTotAbat := 0
		
		dDataAnt := Iif(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)
		
		dbSkip()
		nTotTit ++
		nMesTTit ++
		
		If mv_par20 == 1
			li ++
		EndIf
		
	EndDO
	
	If 	nTit0 == 0
		Loop
	Endif
	
	IF nOrdem != 1
		SubTot150(nTit0,nTit1,nTit2,nOrdem,cCarAnt,nTotJur,nTotDesc)
		If mv_par20 == 1
			li++
		EndIf
	EndIF
	
	lQuebra := .F.
	
	If nOrdem == 3 .and. Month(SE2->E2_VENCREA) #Month(dDataAnt)
		lQuebra := .T.
	Elseif nOrdem == 6 .and. Month(SE2->E2_EMISSAO) #Month(dDataAnt)
		lQuebra := .T.
	Endif
	If lQuebra .and. nMesTTit #0
		ImpMes150(nMesTit0,nMesTit1,nMesTit2,nMesTTit,nMesTitJ,nMestitD)
		nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := nMesTitD := 0
	Endif
	
	dbSelectArea("SE2")
	If nOrdem == 5
		DbSelectArea("TRB")
	EndIF
	
	nTot0 += nTit0
	nTot1 += nTit1
	nTot2 += nTit2
	nTotJ += nTotJur
	nTotD += nTotDesc
	
	Store 0 To nTit0,nTit1,nTit2,nTotJur,nTotDesc,nTotAbat
	
EndDO

IF li != 80
	If mv_par20 == 1
		Li ++
		Li ++
	Endif
	If (nOrdem == 3 .Or. nOrdem == 6 ).And. !lQuebra
		ImpMes150(nMesTit0,nMesTit1,nMesTit2,nMesTTit,nMesTitJ,nMestitD)
		nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := nMesTitD := 0
	Endif
	
	ImpTot150(nTot0,nTot1,nTot2,nTotTit,nTotJ,nTotD)
	roda(cbcont,cbtxt,"G")
EndIF
IF nOrdem == 5
	dbSelectArea("TRB")
	dbCloseArea()
	Ferase(cNomeArq+".DBF")    // Elimina arquivos de Trabalho
	Ferase(cNomeArq+OrdBagExt())	  // Elimina arquivos de Trabalho
EndIF

Set Device TO Screen
dbSelectArea("SE2")
dbSetOrder(1)
dbClearFilter(NIL)

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SubTot150 ³ Autor ³ Wagner Xavier 	    ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR SUBTOTAL DO RELATORIO 							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ SubTot150() 								  			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 														      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC Function SubTot150(nTit0,nTit1,nTit2,nOrdem,cCarAnt,nTotJur,nTotDesc)
If mv_par20 == 1
	li++
EndIf

IF li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
EndIF

if nOrdem == 1 .Or. nOrdem == 3 .Or. nOrdem == 4 .Or. nOrdem == 6
	@li,000 PSAY OemToAnsi("S U B - T O T A L ----> ")
	@li,030 PSAY cCarAnt
ElseIf nOrdem == 2
	dbSelectArea("SED")
	dbSeek(xFilial("SED")+cCarAnt)
	@li,000 PSAY cCarAnt +" "+SED->ED_DESCRIC
Elseif nOrdem == 5
	@Li,000 PSAY SA2->A2_NOME+" "+ALLTRIM(SA2->A2_TEL)
ElseIf nOrdem == 7
	@li,000 PSAY SA2->A2_COD+" "+SA2->A2_NOME+" "+ALLTRIM(SA2->A2_TEL)
Endif
@li,090 PSAY nTit0		 Picture TM(nTit0,14)
@li,106 PSAY nTit1		 Picture TM(nTit1,14)
@li,124 PSAY nTit2		 Picture TM(nTit2,14)
@li,151 PSAY nTotJur     Picture TM(nTotJur,14)
@li,167 PSAY nTotDesc 	 Picture TM(nTotDesc,14)
@li,183 PSAY nTit1+nTit2+nTotJur-NTotDesc Picture TM(nTit1+nTit2+nTotJur-NTotDesc,14)
li++
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ImpTot150 ³ Autor ³ Wagner Xavier 	    ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR TOTAL DO RELATORIO 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpTot150() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 								  			      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC Function ImpTot150(nTot0,nTot1,nTot2,nTotTit,nTotJ,nTotD)

IF li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
EndIF
li++
@li,000 PSAY OemToAnsi("T O T A L   G E R A L ----> ")
@li,030 PSAY "("+ALLTRIM(STR(nTotTit))+" "+IIF(nTotTit > 1,OemToAnsi("TITULOS"),OemToAnsi("TITULO"))+")"
@li,090 PSAY nTot0		 Picture TM(nTot0,14)
@li,106 PSAY nTot1		 Picture TM(nTot1,14)
@li,124 PSAY nTot2		 Picture TM(nTot2,14)
@li,151 PSAY nTotj		 Picture TM(nTotj,14)
@li,167 PSAY nTotD		 Picture TM(nTotd,14)
@li,183 PSAY nTot1 + nTot2+nTotj-nTotd	 Picture TM(nTot1 + nTot2+nTotj-nTotd,14)

li+=2
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ImpMes150 ³ Autor ³ Vinicius Barreira	  ³ Data ³ 12.12.94   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR TOTAL DO RELATORIO - QUEBRA POR MES				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpMes150() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC Function ImpMes150(nMesTot0,nMesTot1,nMesTot2,nMesTTit,nMesTotJ,nMesTotD)

li++
IF li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
EndIF
@li,000 PSAY OemToAnsi("T O T A L   D O  M E S ---> ")
@li,030 PSAY "("+ALLTRIM(STR(nMesTTit))+" "+IIF(nMesTTit > 1,OemToAnsi("TITULOS"),OemToAnsi("TITULO"))+")"
@li,090 PSAY nMesTot0   Picture TM(nMesTot0,14)
@li,106 PSAY nMesTot1	Picture TM(nMesTot1,14)
@li,124 PSAY nMesTot2   Picture TM(nMesTot2,14)
@li,151 PSAY nMesTotJ	Picture TM(nMesTotJ,14)
@li,167 PSAY nMesTotD	Picture TM(nMesTotD,14)
@li,183 PSAY nMesTot1+nMesTot2+nMesTotJ-nMesTotD Picture TM(nMesTot1+nMesTot2+nMesTotJ-nMesTotD,14)
li+=2
Return(.T.)
