#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ PA0150     Autor ³ Alexandro da Silva      Data ³ 26.11.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Posicao dos Titulos a Receber Pelo Saldo                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ PA0150       							  			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parƒmetros³ 													   	      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGAFIN  												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PA0150()


Local cDesc1 := OemToAnsi("Imprime a posi‡„o dos titulos a Receber relativo a data base")
Local cDesc2 := OemToAnsi("do sistema.")
LOCAL cDesc3 := ""
LOCAL wnrel     
LOCAL cString:= "SE1"

Private _cArq
PRIVATE aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 2, 1, "",1 }
PRIVATE nomeprog:= "PA0150"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg	:= "PA0150"
PRIVATE nJuros  := 0
PRIVATE nDesc   := 0
PRIVATE tamanho := "G"

PRIVATE titulo  := ""
PRIVATE cabec1
PRIVATE cabec2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabe‡alhos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := OemToAnsi("Posicao dos Titulos a Receber")
cabec1 := OemToAnsi("Codigo Nome do Cliente      Prf-Numero         Tp  Natureza    Data de   Vencto  Vencto   Valor Original |Titulos vencidos |Titulos a vencer | Porta-| Vlr.juros ou   |Vlr.Desconto    Total a Receb   Atraso Historico")
cabec2 := OemToAnsi("                            Parcela                            Emissao    Orig.   Real                   |Valor nominal    |Valor nominal    | dor   | permanencia    |                                                ")

pergunte("PA0150",.F.)

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
//³ mv_par11	  // do Cliente    	      ³
//³ mv_par12	  // at‚ o Cliente        ³
//³ mv_par13	  // Da Emiss„o			  ³
//³ mv_par14	  // Ate a Emiss„o		  ³
//³ mv_par15	  // qual Moeda			  ³
//³ mv_par16	  // Imprime Provis¢rios  ³
//³ mv_par17	  // Reajuste pelo vencto ³
//³ mv_par18	  // Imprime Rel anal/sint³
//³ mv_par19	  // Considera  Adiantamentos"
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel   := "PA0150"
aOrd	:= {OemToAnsi("Por Numero"),OemToAnsi("Por Natureza"),OemToAnsi("Por Vencimento") ,;
OemToAnsi("Por Banco"),OemToAnsi("Cliente"),OemToAnsi("Por Emissao"),OemToAnsi("Por Cod.Cliente") }
wnrel   := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| PA0150A(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA150Imp ³ Autor ³ Wagner Xavier		    ³ Data ³ 02.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Posi‡„o dos Titulos a Receber							  ³±±
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

Static Function PA0150A(lEnd,wnRel,cString)

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

cbtxt  := OemToAnsi("* indica titulo provisorio, P indica Saldo Parcial")
cbcont := 0
li     := 80
m_pag  := 1

nOrdem := aReturn[8]
cMoeda := Str(mv_par15,1)
Titulo += " em " +mv_moeda&cMoeda

dbSelectArea ( "SE1" )
Set Softseek On

IF nOrdem == 1
	_cOrd   := "E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_CLIENTE,E1_LOJA "
	_cIndex := "E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO + E1_CLIENTE + E1_LOJA "
	cCond1  := "E1_PREFIXO <= mv_par04"
	cCond2  := "E1_PREFIXO"
	titulo  += OemToAnsi(" - Por Numero")
Elseif nOrdem == 2                                              
	_cOrd   := "E1_NATUREZ,E1_NOMFOR,E1_PREFIXO,E1_NUM,E1_PARCELA"
	_cIndex := "E1_NATUREZ + E1_NOMFOR + E1_PREFIXO + E1_NUM + E1_PARCELA"
	cCond1  := "E1_NATUREZ <= mv_par06"
	cCond2  := "E1_NATUREZ"
	titulo  += OemToAnsi(" - Por Natureza")
Elseif nOrdem == 3
	_cOrd   := "E1_VENCREA,E1_NOMFOR,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"
	_cIndex := "DTOS(E1_VENCREA)+E1_NOMFOR+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
	cCond1  := "E1_VENCREA <= mv_par08"
	cCond2  := "E1_VENCREA"
	titulo  += OemToAnsi(" - Por Vencimento")
Elseif nOrdem == 4                                                
	_cOrd   := "E1_PORTADO,E1_NOMFOR,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"
	_cIndex := "E1_PORTADO+E1_NOMFOR+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
	cCond1  := "E1_PORTADO <= mv_par10"
	cCond2  := "E1_PORTADO"
	titulo  += OemToAnsi(" - Por Banco")
Elseif nOrdem == 5                                                
	_cOrd   := "E1_NOMFOR,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"
	_cIndex := "E1_NOMFOR+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
	cCond1  := "E1_NOMFOR <= mv_par10"
	cCond2  := "E1_NOMFOR"
	titulo  += OemToAnsi(" - Por Nome")
Elseif nOrdem == 6
	_cOrd   := "E1_EMISSAO,E1_NOMFOR,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"
	_cIndex := "DTOS(E1_EMISSAO)+E1_NOMFOR+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
	cCond1  := "E1_EMISSAO <= mv_par14"
	cCond2  := "E1_EMISSAO"
	titulo  += OemToAnsi(" - Por Emissao")
Elseif nOrdem == 7                                                      
	_cOrd   := "E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"
	_cIndex := "E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
	cCond1  := "E1_CLIENTE <= mv_par12"
	cCond2  := "E1_CLIENTE"
	titulo  += OemToAnsi(" - Por Cod.Cliente")
EndIF

_cQ := " SELECT * FROM "+RETSQLNAME("SE1")+" E1 "
_cQ += " WHERE E1_NUM BETWEEN   '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND E1_PREFIXO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_cQ += " AND E1_NATUREZ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND E1_VENCREA BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
_cQ += " AND E1_PORTADO BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' AND E1_CLIENTE BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' "
_cQ += " AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR13)+"' AND '"+DTOS(MV_PAR14)+"'  "
_cQ += " AND E1_SALDO > 0 AND E1.D_E_L_E_T_ = ''"
//_cQ += " AND E1_SALDO > 0 "
_cQ += " ORDER BY "+_cOrd

TCQUERY _cQ NEW ALIAS "ZE1"

TCSETFIELD("ZE1","E1_EMISSAO","D")
TCSETFIELD("ZE1","E1_EMIS1","D")
TCSETFIELD("ZE1","E1_VENCTO","D")
TCSETFIELD("ZE1","E1_VENCREA","D")
/*
_cArq := CriaTrab(NIL,.F.)
Copy To &_cArq

dbCloseArea()

dbUseArea(.T.,,_cArq,"ZE1",.T.)
IndRegua("ZE1",_cArq,_cIndEX,,,"Selecionando Arquivo Trabalho")
*/
If mv_par18 == 1
	titulo += OemToAnsi(" - Analitico")
Else
	titulo += OemToAnsi(" - Sintetico")
	cabec1 := OemToAnsi("                                                                                          Valor Original |Titulos vencidos |Titulos a vencer |         Vlr.juros ou   |Vlr.Desconto   |Total a Receber       ")
	cabec2 := OemToAnsi("                                                                                                         |Valor nominal    |Valor nominal    |         permanencia    |                                      ")
EndIf

/*
Codigo Nome do Cliente      PRF-Numero         Tp  Natureza    Data de  Vencto   Vencto   Valor Original |Titulos vencidos |Titulos a vencer | Porta-| Vlr.juros ou   |Vlr.Desconto    Total a Receber Atraso Historico
9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999 9999999999999
0      7                    28                 47  51          63       72       81       90              106               124                143     151             167             183             199    206
Parcela                            Emissao  Titulo    Real                   |Valor nominal    |Valor nominal    | dor   | permanencia    |
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999

*/

dbSelectArea("ZE1")
dbGotop()

Set Softseek Off

SetRegua(U_CONTREG())

While &cCond1 .and. !Eof() .and. lContinua
	
	IF lEnd
		@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
		Exit
	End
	
	IncRegua()
	
	dbSelectArea("ZE1")
	
	Store 0 To nTit1,nTit2
	
	dDataAnt := Iif(nOrdem == 3, ZE1->E1_VENCREA, ZE1->E1_EMISSAO)
	
	cCarAnt := &cCond2
	
	While &cCond2 == cCarAnt .and. !Eof() .and. lContinua
		
		IF lEnd
			@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
			Exit
		End
		
		IncRegua()
		
		dbSelectArea("ZE1")
		IF !Empty(E1_FATURA) .and. Substr(E1_FATURA,1,6) != "NOTFAT" .and. ZE1->E1_DTFATUR <= dDataBase
			dbSkip()
			Loop
		Endif
		
		IF SubStr ( ZE1->E1_TIPO,3,1) == "-"  .Or. ;
			dbSelectArea("ZE1")
			dbSkip()
			Loop
		EndIF
		
		IF SubStr(ZE1->E1_TIPO,1,2) == "PR" .and. mv_par16 == 2
			DbSelectArea("ZE1")
			dbSkip()
			Loop
		EndIF
		
		IF SubStr(ZE1->E1_TIPO,1,2) == "RA" .and. mv_par19 == 2
			DbSelectArea("ZE1")
			dbSkip()
			Loop
		EndIF
		
		dDtContab := ZE1->E1_EMIS1
		nSaldo    := 0
		nSaldoNom := 0
		
		If dDataBase > ZE1->E1_VENCREA 		//vencidos
			dDataReaj := IIF(mv_par17=1,dDataBase,ZE1->E1_VENCREA)
			nSaldoNom := ZE1->E1_SALDO
		Else
			nSaldo:=  ZE1->E1_SALDO
		Endif
		
		dbSelectArea("SA1")
		dbSeek(xFilial("SA1")+ZE1->E1_CLIENTE+ZE1->E1_LOJA)
		dbSelectArea("SA6")
		dbSeek(xFilial("SA6")+ZE1->E1_PORTADO)
		dbSelectArea("ZE1")
		
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
		EndIF
		
		nJuros:= 0
		nDesc := 0
		
		If mv_par18 == 1
			@li,0   PSAY ZE1->E1_CLIENTE
			@li,7   PSAY SubStr( ZE1->E1_NOMFOR, 1, 20 )
			@li, 28 PSAY ZE1->E1_PREFIXO+"-"+ZE1->E1_NUM+"-"+ZE1->E1_PARCELA
			@li, 47 PSAY ZE1->E1_TIPO
			@li, 51 PSAY ZE1->E1_NATUREZ
			@li, 63 PSAY ZE1->E1_EMISSAO
			@Li, 72 PSAY ZE1->E1_VENCTO
			@li, 81 PSAY ZE1->E1_VENCREA
			@li, 90 PSAY ZE1->E1_VALOR Picture tm ( ZE1->E1_VALOR, 14 )
		EndIf
		If dDataBase > ZE1->E1_VENCREA 		//vencidos
			dDataReaj := IIF(mv_par17=1,dDataBase,ZE1->E1_VENCREA)
			nSaldoNom := ZE1->E1_SALDO
			
			If Substr(ZE1->E1_TIPO,1,2)!="RA" .and. ZE1->E1_TIPO != "NCC"
				nTotAbat:=CalcAbat(E1_PREFIXO,E1_NUM,E1_PARCELA,mv_par15,"R")
			Endif
			If mv_par18 == 1
				@ li, 106 PSAY nSaldoNom Picture tm ( nSaldoNom, 14 )
			EndIf
			nJuros:= 0
			nDesc := 0
			dBaixa:=dDataBase
			dbSelectArea("ZE1")
			If ZE1->E1_TIPO $ "RA /NCC"
				nTit0 -= ZE1->E1_VALOR
				nTit1 -= (nSaldoNom-nTotAbat+nJuros-nDesc)
				nMesTit0 -= ZE1->E1_VALOR
				nMesTit1 -= (nSaldoNom-nTotAbat+nJuros-nDesc)
			Else
				nTit0 += ZE1->E1_VALOR
				nTit1 += (nSaldoNom-nTotAbat)
				nMesTit0 += ZE1->E1_VALOR
				nMesTit1 += (nSaldoNom-nTotAbat)
			Endif
		Else				  //a vencer
			nSaldo:= ZE1->E1_SALDO
			
			If mv_par18 == 1
				@li,124 PSAY nSaldo Picture tm ( nSaldo, 14 )
			EndIf
			If ( ZE1->E1_TIPO != "NCC" )
				nTotAbat:=CalcAbat(E1_PREFIXO,E1_NUM,E1_PARCELA,mv_par15,"R")
			Endif
			
			If ZE1->E1_TIPO == "NCC" .or. Subs(ZE1->E1_TIPO,1,2) == "RA"
				nTit0    -= ZE1->E1_VALOR
				nTit2    -= (nSaldo-nTotAbat)
				nMesTit0 += ZE1->E1_VALOR
				nMesTit2 -= (nSaldo-nTotAbat)
			Else
				nTit0    += ZE1->E1_VALOR
				nTit2    += (nSaldo-nTotAbat)
				nMesTit0 += ZE1->E1_VALOR
				nMesTit2 += (nSaldo-nTotAbat)
			Endif
		Endif
		
		nTotJur  += nJuros
		nTotDesc += nDesc
		nMesTitJ += nJuros
		nMesTitD += nDesc
		
		If mv_par18 == 1
			@Li,143 PSAY ZE1 -> E1_PORTADO
		EndIf
		
		If mv_par18 == 1
			@Li,151 PSAY 0           Picture Tm(0,14)
			@Li,167 PSAY 0           Picture Tm(0,14)
		EndIf
		
		If mv_par18 == 1
			@li,183 PSAY nSaldo + nSaldoNom   Picture Tm(nSaldo,14)
		EndIf
		
		IF dDataBase > E1_VENCREA
			nAtraso:=dDataBase-E1_VENCTO
			IF Dow(E1_VENCTO) == 1 .Or. Dow(E1_VENCTO) == 7
				IF Dow(dBaixa) == 2 .and. nAtraso <= 2
					nAtraso:=0
				EndIF
			EndIF
			nAtraso:=IIF(nAtraso<0,0,nAtraso)
			IF nAtraso>0
				If mv_par18 == 1
					@li,199 PSAY nAtraso Picture "9999"
				EndIf
			EndIF
		EndIF
		
		If mv_par18 == 1
			@li,206 PSAY SubStr(ZE1->E1_HIST,1,13)
		EndIf
		
		If Subs(ZE1->E1_TIPO,1,2)!="RA" .and. ZE1->E1_TIPO != "NCC"
			nTotAbat:=Abatimentos(E1_PREFIXO,E1_NUM,E1_PARCELA,E1_CLIENTE,nSaldo,mv_par15,Iif(dDataBase > E1_VENCREA,92,126),"R")
		Endif
		
		IF nTotAbat > 0 .and. mv_par18 == 1
			DevPos ( ++ li, 00 )
			DevOut("")
		End
		nTotAbat := 0
		
		dDataAnt := Iif(nOrdem == 3, ZE1->E1_VENCREA, ZE1->E1_EMISSAO)
		
		ZE1->(dbSkip())
		nTotTit ++
		nMesTTit ++
		
		If mv_par18 == 1
			li ++
		EndIf
		
	EndDO
	
	If 	nTit0 == 0
		Loop
	Endif
	
	IF nOrdem != 1
		SubTot150(nTit0,nTit1,nTit2,nOrdem,cCarAnt,nTotJur,nTotDesc)
		If mv_par18 == 1
			li++
		EndIf
	EndIF
	
	lQuebra := .F.
	
	If nOrdem == 3 .and. Month(ZE1->E1_VENCREA) #Month(dDataAnt)
		lQuebra := .T.
	Elseif nOrdem == 6 .and. Month(ZE1->E1_EMISSAO) #Month(dDataAnt)
		lQuebra := .T.
	Endif
	If lQuebra .and. nMesTTit #0
		ImpMes150(nMesTit0,nMesTit1,nMesTit2,nMesTTit,nMesTitJ,nMestitD)
		nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := nMesTitD := 0
	Endif
	
	dbSelectArea("ZE1")
	
	nTot0 += nTit0
	nTot1 += nTit1
	nTot2 += nTit2
	nTotJ += nTotJur
	nTotD += nTotDesc
	
	Store 0 To nTit0,nTit1,nTit2,nTotJur,nTotDesc,nTotAbat
	
EndDO

IF li != 80
	If mv_par18 == 1
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

dbSelectArea("ZE1")
dbCloseArea()
//Ferase(_cArq+".DBF")    // Elimina arquivos de Trabalho
//Ferase(_cArq+OrdBagExt())	  // Elimina arquivos de Trabalho

Set Device TO Screen

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
If mv_par18 == 1
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
	@Li,000 PSAY SA1->A1_NOME+" "+ALLTRIM(SA1->A1_TEL)
ElseIf nOrdem == 7
	@li,000 PSAY SA1->A1_COD+" "+SA1->A1_NOME+" "+ALLTRIM(SA1->A1_TEL)
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