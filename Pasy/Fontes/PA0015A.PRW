#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � PA0015A    Autor � Alexandro da Silva      Data � 05.11.07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Posi��o dos Titulos a Pagar	pELO SALDO                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � PA0015A      							  			      ���
�������������������������������������������������������������������������Ĵ��
���Par�metros� 													   	      ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � SIGAFIN  												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PA0015A()


Local cDesc1 := OemToAnsi("Imprime a posi��o dos titulos a pagar relativo a data base")
Local cDesc2 := OemToAnsi("do sistema.")
LOCAL cDesc3 := ""
LOCAL wnrel     
LOCAL cString:= "SE2"

Private _cArq
PRIVATE aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 2, 1, "",1 }
PRIVATE nomeprog:= "PA0015A"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg	:= "PA0015"
PRIVATE nJuros  := 0
PRIVATE nDesc   := 0
PRIVATE tamanho := "G"

PRIVATE titulo  := ""
PRIVATE cabec1
PRIVATE cabec2

//��������������������������Ŀ
//� Definicao dos cabe�alhos �
//����������������������������
titulo := OemToAnsi("Posicao dos Titulos a Pagar")
cabec1 := OemToAnsi("Codigo Nome do Fornecedor   PRF-Numero         Tp  Natureza    Data de   Vencto  Vencto   Valor Original |Titulos vencidos |Titulos a vencer | Porta-| Vlr.juros ou   |Vlr.Desconto    Total a Pagar   Atraso Historico")
cabec2 := OemToAnsi("                            Parcela                            Emissao    Orig.   Real                   |Valor nominal    |Valor nominal    | dor   | permanencia    |                                                ")
//cabec2 := OemToAnsi("                            Parcela                            Emissao  Digit.    Real                   |Valor nominal    |Valor nominal    | dor   | permanencia    |                                                ")

//������������������������������������Ŀ
//� Verifica as perguntas selecionadas �
//��������������������������������������
pergunte("PA0015",.F.)
//��������������������������������������Ŀ
//� Variaveis utilizadas para parametros  �
//� mv_par01	  // do Numero 			  �
//� mv_par02	  // at� o Numero 		  �
//� mv_par03	  // do Prefixo			  �
//� mv_par04	  // at� o Prefixo		  �
//� mv_par05	  // da Natureza		  �
//� mv_par06	  // at� a Natureza		  �
//� mv_par07	  // do Banco		  	  �
//� mv_par08	  // at� o Banco		  �
//� mv_par09	  // do Vencimento		  �
//� mv_par10	  // at� o Vencimento	  �
//� mv_par11	  // do Fornecedor		  �
//� mv_par12	  // at� o Fornecedor	  �
//� mv_par13	  // Da Emiss�o			  �
//� mv_par14	  // Ate a Emiss�o		  �
//� mv_par15	  // qual Moeda			  �
//� mv_par16	  // Imprime Provis�rios  �
//� mv_par17	  // Reajuste pelo vencto �
//� mv_par18	  // Da data contabil	  �
//� mv_par19	  // Ate data contabil	  �
//� mv_par20	  // Imprime Rel anal/sint�
//� mv_par21	  // Considera  Data Base?�
//� mv_par22	  // Considera  Adiantamentos"
//����������������������������������������
//���������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT �
//�����������������������������������������
wnrel   := "PA0015"
aOrd	:= {OemToAnsi("Por Numero"),OemToAnsi("Por Natureza"),OemToAnsi("Por Vencimento") ,;
OemToAnsi("Por Banco"),OemToAnsi("Fornecedor"),OemToAnsi("Por Emissao"),OemToAnsi("Por Cod.Fornec.") }
wnrel   := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FA150Imp � Autor � Wagner Xavier		    � Data � 02.10.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Posi��o dos Titulos a Pagar								  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FA150Imp(lEnd,wnRel,cString)								  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd	  - A��o do Codeblock								  ���
���			 � wnRel   - T�tulo do relat�rio 							  ���
���			 � cString - Mensagem										  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Gen�rico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//�����������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impress�o do Cabe�alho e Rodap� �
//�������������������������������������������������������������
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
	_cOrd   := "E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA "
	_cIndex := "E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA "
	cCond1  := "E2_PREFIXO <= mv_par04"
	cCond2  := "E2_PREFIXO"
	titulo  += OemToAnsi(" - Por Numero")
Elseif nOrdem == 2                                              
	_cOrd   := "E2_NATUREZ,E2_NOMFOR,E2_PREFIXO,E2_NUM,E2_PARCELA"
	_cIndex := "E2_NATUREZ + E2_NOMFOR + E2_PREFIXO + E2_NUM + E2_PARCELA"
	cCond1  := "E2_NATUREZ <= mv_par06"
	cCond2  := "E2_NATUREZ"
	titulo  += OemToAnsi(" - Por Natureza")
Elseif nOrdem == 3
	_cOrd   := "E2_VENCREA,E2_NOMFOR,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO"
	_cIndex := "DTOS(E2_VENCREA)+E2_NOMFOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
	cCond1  := "E2_VENCREA <= mv_par08"
	cCond2  := "E2_VENCREA"
	titulo  += OemToAnsi(" - Por Vencimento")
Elseif nOrdem == 4                                                
	_cOrd   := "E2_PORTADO,E2_NOMFOR,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO"
	_cIndex := "E2_PORTADO+E2_NOMFOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
	cCond1  := "E2_PORTADO <= mv_par10"
	cCond2  := "E2_PORTADO"
	titulo  += OemToAnsi(" - Por Banco")
Elseif nOrdem == 5                                                
	_cOrd   := "E2_NOMFOR,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO"
	_cIndex := "E2_NOMFOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
	cCond1  := "E2_NOMFOR <= mv_par10"
	cCond2  := "E2_NOMFOR"
	titulo  += OemToAnsi(" - Por Nome")
Elseif nOrdem == 6
	_cOrd   := "E2_EMISSAO,E2_NOMFOR,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO"
	_cIndex := "DTOS(E2_EMISSAO)+E2_NOMFOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
	cCond1  := "E2_EMISSAO <= mv_par14"
	cCond2  := "E2_EMISSAO"
	titulo  += OemToAnsi(" - Por Emissao")
Elseif nOrdem == 7                                                      
	_cOrd   := "E2_FORNECE,E2_LOJA,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO"
	_cIndex := "E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
	cCond1  := "E2_FORNECE <= mv_par12"
	cCond2  := "E2_FORNECE"
	titulo  += OemToAnsi(" - Por Cod.Fornecedor")
EndIF

_cQ := " SELECT * FROM "+RETSQLNAME("SE2")+" E2 "
_cQ += " WHERE E2_NUM BETWEEN   '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND E2_PREFIXO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_cQ += " AND E2_NATUREZ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND E2_VENCREA BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
_cQ += " AND E2_PORTADO BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' AND E2_FORNECE BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' "
_cQ += " AND E2_EMISSAO BETWEEN '"+DTOS(MV_PAR13)+"' AND '"+DTOS(MV_PAR14)+"' AND E2_EMIS1 BETWEEN '"+DTOS(MV_PAR18)+"' AND '"+DTOS(MV_PAR19)+"' "
_cQ += " AND E2_SALDO > 0 AND E2.D_E_L_E_T_ = ''"
//_cQ += " AND E2_SALDO > 0 "
_cQ += " ORDER BY "+_cOrd

TCQUERY _cQ NEW ALIAS "ZE2"

TCSETFIELD("ZE2","E2_EMISSAO","D")
TCSETFIELD("ZE2","E2_EMIS1","D")
TCSETFIELD("ZE2","E2_VENCTO","D")
TCSETFIELD("ZE2","E2_VENCREA","D")
/*
_cArq := CriaTrab(NIL,.F.)
Copy To &_cArq

dbCloseArea()

dbUseArea(.T.,,_cArq,"ZE2",.T.)
IndRegua("ZE2",_cArq,_cIndEX,,,"Selecionando Arquivo Trabalho")
*/
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

DbSelectArea("ZE2")

Set Softseek Off

SetRegua(U_CONTREG())

While &cCond1 .and. !Eof() .and. lContinua
	
	IF lEnd
		@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
		Exit
	End
	
	IncRegua()
	
	dbSelectArea("ZE2")
	
	Store 0 To nTit1,nTit2
	
	dDataAnt := Iif(nOrdem == 3, ZE2->E2_VENCREA, ZE2->E2_EMISSAO)
	
	cCarAnt := &cCond2
	
	While &cCond2 == cCarAnt .and. !Eof() .and. lContinua
		
		IF lEnd
			@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
			Exit
		End
		
		IncRegua()
		
		dbSelectArea("ZE2")
		IF !Empty(E2_FATURA) .and. Substr(E2_FATURA,1,6) != "NOTFAT" .and. ZE2->E2_DTFATUR <= dDataBase
			dbSkip()
			Loop
		Endif
		
		IF SubStr ( ZE2->E2_TIPO,3,1) == "-"  .Or. ;
			dbSelectArea("ZE2")
			dbSkip()
			Loop
		EndIF
		
		IF SubStr(ZE2->E2_TIPO,1,2) == "PR" .and. mv_par16 == 2
			DbSelectArea("ZE2")
			dbSkip()
			Loop
		EndIF
		
		IF SubStr(ZE2->E2_TIPO,1,2) == "PA" .and. mv_par22 == 2
			DbSelectArea("ZE2")
			dbSkip()
			Loop
		EndIF
		
		dDtContab := ZE2->E2_EMIS1
		nSaldo    := 0
		nSaldoNom := 0
		
		If dDataBase > ZE2->E2_VENCREA 		//vencidos
			dDataReaj := IIF(mv_par17=1,dDataBase,ZE2->E2_VENCREA)
			nSaldoNom := ZE2->E2_SALDO
		Else
			nSaldo:=  ZE2->E2_SALDO
		Endif
		
		dbSelectArea("SA2")
		dbSeek(xFilial("SA2")+ZE2->E2_FORNECE+ZE2->E2_LOJA)
		dbSelectArea("SA6")
		dbSeek(xFilial("SA6")+ZE2->E2_PORTADO)
		dbSelectArea("ZE2")
		
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
		EndIF
		
		nJuros:= ZE2->E2_VLJUROS
		nDesc := ZE2->E2_VLDESC
		
		If mv_par20 == 1
			@li,0   PSAY ZE2->E2_FORNECE
			@li,7   PSAY SubStr( ZE2->E2_NOMFOR, 1, 20 )
			@li, 28 PSAY ZE2->E2_PREFIXO+"-"+ZE2->E2_NUM+"-"+ZE2->E2_PARCELA
			@li, 47 PSAY ZE2->E2_TIPO
			@li, 51 PSAY ZE2->E2_NATUREZ
			@li, 63 PSAY ZE2->E2_EMISSAO
			@Li, 72 PSAY ZE2->E2_VENCTO
			@li, 81 PSAY ZE2->E2_VENCREA
			@li, 90 PSAY ZE2->E2_VALOR Picture tm ( ZE2->E2_VALOR, 14 )
		EndIf
		If dDataBase > ZE2->E2_VENCREA 		//vencidos
			dDataReaj := IIF(mv_par17=1,dDataBase,ZE2->E2_VENCREA)
			nSaldoNom := ZE2->E2_SALDO+ZE2->E2_ACRESC-ZE2->E2_DECRESC
			
			If Substr(ZE2->E2_TIPO,1,2)!="PA" .and. ZE2->E2_TIPO != "NDF"
				nTotAbat:=CalcAbat(E2_PREFIXO,E2_NUM,E2_PARCELA,mv_par15,"P")
			Endif
			If mv_par20 == 1
				@ li, 106 PSAY nSaldoNom Picture tm ( nSaldoNom, 14 )
			EndIf
			nJuros:= ZE2->E2_VLJUROS
			nDesc := ZE2->E2_VLDESC
			dBaixa:= dDataBase
			dbSelectArea("ZE2")
			If ZE2->E2_TIPO $ "PA /NDF"
				nTit0    -= ZE2->E2_VALOR
				nTit1    -= (nSaldoNom-nTotAbat+nJuros-nDesc)
				nMesTit0 -= ZE2->E2_VALOR
				nMesTit1 -= (nSaldoNom-nTotAbat+nJuros-nDesc)
			Else
				nTit0    += ZE2->E2_VALOR
				nTit1    += (nSaldoNom-nTotAbat)
				nMesTit0 += ZE2->E2_VALOR
				nMesTit1 += (nSaldoNom-nTotAbat)
			Endif
		Else				  //a vencer
			nSaldo:= ZE2->E2_SALDO+ZE2->E2_ACRESC-ZE2->E2_DECRESC
			
			If mv_par20 == 1
				@li,124 PSAY nSaldo Picture tm ( nSaldo, 14 )
			EndIf
			If ( ZE2->E2_TIPO != "NDF" )
				nTotAbat:=CalcAbat(E2_PREFIXO,E2_NUM,E2_PARCELA,mv_par15,"P")
			Endif
			
			If ZE2->E2_TIPO == "NDF" .or. Subs(ZE2->E2_TIPO,1,2) == "PA"
				nTit0    -= ZE2->E2_VALOR
				nTit2    -= (nSaldo-nTotAbat)
				nMesTit0 += ZE2->E2_VALOR
				nMesTit2 -= (nSaldo-nTotAbat)
			Else
				nTit0    += ZE2->E2_VALOR
				nTit2    += (nSaldo-nTotAbat)
				nMesTit0 += ZE2->E2_VALOR
				nMesTit2 += (nSaldo-nTotAbat)
			Endif
		Endif
		
		nTotJur  += nJuros
		nTotDesc += nDesc
		nMesTitJ += nJuros
		nMesTitD += nDesc
		
		If mv_par20 == 1
			@Li,143 PSAY ZE2 -> E2_PORTADO
		EndIf
		
		If mv_par20 == 1
			@Li,151 PSAY ZE2->E2_VLJUROS Picture Tm(ZE2->E2_VLJUROS,14)
			@Li,167 PSAY ZE2->E2_VLDESC  Picture Tm(ZE2->E2_VLDESC,14)
		EndIf
		
		If mv_par20 == 1
			@li,183 PSAY nSaldo + nSaldoNom + ZE2->E2_VLJUROS  - ZE2->E2_VLDESC Picture Tm(ZE2->E2_VLJUROS,14)
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
			@li,206 PSAY SubStr(ZE2->E2_HIST,1,13)
		EndIf
		
		If Subs(ZE2->E2_TIPO,1,2)!="PA" .and. ZE2->E2_TIPO != "NDF"
			nTotAbat:=Abatimentos(E2_PREFIXO,E2_NUM,E2_PARCELA,E2_FORNECE,nSaldo,mv_par15,Iif(dDataBase > E2_VENCREA,92,126),"P")
		Endif
		
		IF nTotAbat > 0 .and. mv_par20 == 1
			DevPos ( ++ li, 00 )
			DevOut("")
		End
		nTotAbat := 0
		
		dDataAnt := Iif(nOrdem == 3, ZE2->E2_VENCREA, ZE2->E2_EMISSAO)
		
		ZE2->(dbSkip())
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
	
	If nOrdem == 3 .and. Month(ZE2->E2_VENCREA) #Month(dDataAnt)
		lQuebra := .T.
	Elseif nOrdem == 6 .and. Month(ZE2->E2_EMISSAO) #Month(dDataAnt)
		lQuebra := .T.
	Endif
	If lQuebra .and. nMesTTit #0
		ImpMes150(nMesTit0,nMesTit1,nMesTit2,nMesTTit,nMesTitJ,nMestitD)
		nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := nMesTitD := 0
	Endif
	
	dbSelectArea("ZE2")
	
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

dbSelectArea("ZE2")
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �SubTot150 � Autor � Wagner Xavier 	    � Data � 01.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �IMPRIMIR SUBTOTAL DO RELATORIO 							  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � SubTot150() 								  			      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 														      ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �ImpTot150 � Autor � Wagner Xavier 	    � Data � 01.06.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �IMPRIMIR TOTAL DO RELATORIO 								  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � ImpTot150() 												  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 															  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 								  			      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �ImpMes150 � Autor � Vinicius Barreira	  � Data � 12.12.94   ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �IMPRIMIR TOTAL DO RELATORIO - QUEBRA POR MES				  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � ImpMes150() 												  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 															  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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