#include "rwmake.ch"
#Define I_CORRECAO_MONETARIA     1
#Define I_DESCONTO               2
#Define I_JUROS                  3
#Define I_MULTA                  4
#Define I_VALOR_RECEBIDO         5
#Define I_VALOR_PAGO             6
#Define I_RECEB_ANT              7
#Define I_PAGAM_ANT              8
#Define I_MOTBX                  9
#Define I_RECPAG_REAIS              10
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR350  ³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Posicao dos Fornecedores                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR350(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FINR350A()


SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,ALINHA,ARETURN")
SetPrvt("CPERG,NLASTKEY,TAMANHO,NOMEPROG,AORD,TITULO")
SetPrvt("CABEC1,CABEC2,WNREL,NMOEDA,NTOTABAT,NTIT1")
SetPrvt("NTIT2,NTIT3,NTIT4,NTIT5,NTIT6,NTIT7")
SetPrvt("NTIT8,NTIT9,NTOT1,NTOT2,NTOT3,NTOT4")
SetPrvt("NTOT5,NTOT6,NTOT7,NTOT8,NTOT9,LCONTINUA")
SetPrvt("LIMITE,CFORANT,NSALDO,AVALOR,ASTRU,CFILTERUSER")
SetPrvt("NDECS,DDATAMOEDA,CBTXT,CBCONT,LI,M_PAG")
SetPrvt("NORDEM,CCHAVE,CCOND1,CCOND2,CORDER,CINDEX")
SetPrvt("NINDEX,CQUERY,N,NI,NCONT,CALIAS")
SetPrvt("LRET,CPICTURE,CRETORNO,APERG,")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDesc1 :=OemToAnsi("Este programa ir  emitir a posi‡„o dos fornecedores")
cDesc2 :=OemToAnsi("referente a data base do sistema.")
cDesc3 :=""
cString:="SE2"
nMoeda := 0

Private aLinha :={}
Private aReturn:={OemToAnsi("Zebrado"),1,OemToAnsi("Administracao"),1,2,1,"",1}
Private cPerg  :="FIN350"
Private cabec1,cabec2,nLastKey:=0,titulo,wnrel,tamanho:="G"
Private nomeprog :="FINR350A"
Private aOrd :={OemToAnsi("Por Codigo"),OemToAnsi("Por Nome") }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo:= OemToAnsi("Posicao dos Fornecedores ")

cabec1:= OemToAnsi("Prf Numero       PC Tip Valor Original Emissao   Vencto   Baixa                          P  A  G  A  M  E  N  T  O  S                                                                                     ")
cabec2:= OemToAnsi("                                                                        Descontos     Abatimentos           Juros            Multa      Corr. Monet       Valor Pago    Pagto.Antecipado       Saldo Atual   Motivo")

pergunte("FIN350",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                     ³
//³ mv_par01            // Do Fornecedor                     ³
//³ mv_par02            // Ate o Fornecedor                  ³
//³ mv_par03            // Da Loja                           ³
//³ mv_par04            // Ate a Loja                        ³
//³ mv_par05            // Da Emissao                        ³
//³ mv_par06            // Ate a Emissao                     ³
//³ mv_par07            // Do Vencimento                     ³
//³ mv_par08            // Ate o Vencimento                  ³
//³ mv_par09            // Imprime os t¡tulos provis¢rios    ³
//³ mv_par10            // Qual a moeda                      ³
//³ mv_par11            // Reajusta pela DataBase ou Vencto  ³
//³ mv_par12            // Considera Faturados               |
//³ mv_par13            // Imprime Outras Moedas             |
//³ mv_par14            // Considera Data Base               |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="FINR350A"
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nMoeda := mv_par10
Titulo += " - " + GetMv("MV_MOEDA"+Str(nMoeda,1))

RptStatus({|lEnd| Fa350Imp(@lEnd,wnRel,cString)},Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FA350Imp ³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Posicao dos Fornecedores                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA350Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FA350Imp(lEnd,wnRel,cString)

Local CbTxt,cbCont
Local nOrdem,nTotAbat:=0
Local nTit1:=0,nTit2:=0,nTit3:=0,nTit4:=0,nTit5:=0,nTit6:=0,nTit7:=0,nTit8:=0,nTit9:=0
Local nTot1:=0,nTot2:=0,nTot3:=0,nTot4:=0,nTot5:=0,nTot6:=0,nTot7:=0,nTot8:=0,nTot9:=0
Local lContinua:=.T.,limite:=220,cForAnt:=Space(6),nSaldo:=0
Local aValor:={0,0,0,0,0,0}
Local nMoeda:=0
Local dDataMoeda
Local cCond1,cCond2,cChave,cIndex, cOrder
Local aStru := SE2->(dbStruct()), ni
Local cFilterUser := aReturn[7]
Local ndecs:=Msdecimais(mv_par10)
dDataMoeda:=dDataBase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt :=Space(10)
cbcont:=00
li    :=80
m_pag :=01
nOrdem := aReturn[8]

nMoeda := mv_par10

dbSelectArea("SE2")
If nOrdem == 1
	dbSetOrder(6)
	cChave := IndexKey()
	dbSeek (xFilial("SE2")+mv_par01+mv_par03,.t.)
	cCond1 :='SE2->E2_FORNECE+SE2->E2_LOJA <= mv_par02+mv_par04 .and. SE2->E2_FILIAL == xFilial("SE2")'
	cCond2 := "SE2->E2_FORNECE+SE2->E2_LOJA"
	#IFDEF TOP
		cOrder := SqlOrder(cChave)
	#ENDIF
Else
	cChave  := "E2_FILIAL+E2_NOMFOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
	#IFDEF TOP
		If TCSrvType() == "AS/400"
			cIndex	:= CriaTrab(nil,.f.)
			dbSelectArea("SE2")
			IndRegua("SE2",cIndex,cChave,,FR350FIL(),OemToAnsi("Selecionando Registros..."))
			nIndex	:= RetIndex("SE2")
			dbSetOrder(nIndex+1)
		Else
			cOrder := SqlOrder(cChave)
		EndIf
	#ELSE
		cIndex	:= CriaTrab(nil,.f.)
		dbSelectArea("SE2")
		IndRegua("SE2",cIndex,cChave,,FR350FIL(),OemToAnsi("Selecionando Registros..."))
		nIndex	:= RetIndex("SE2")
		dbSetIndex(cIndex+OrdBagExt())
		dbSetOrder(nIndex+1)
	#ENDIF
	cCond1 := ".T."
	cCond2 := "SE2->E2_NOMFOR"
	SE2->( dbGoTop() )
EndIf
SetRegua(RecCount())

#IFDEF TOP
	If TcSrvType() != "AS/400"
		cQuery := "SELECT "
		
		dbSelectArea("SE2")
		aStru := dbStruct()
		For n:=1 to Len(aStru)
			cQuery += aStru[n,1] + ","
		Next
		cQuery += " R_E_C_N_O_ Recno "
		cQuery += " FROM " + RetSqlName("SE2")
		cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'"
		cQuery += " AND D_E_L_E_T_ <> '*' "
		cQuery += " AND E2_FORNECE between '" + mv_par01        + "' AND '" + mv_par02       + "'"
		cQuery += " AND E2_LOJA    between '" + mv_par03        + "' AND '" + mv_par04       + "'"
		cQuery += " AND E2_EMISSAO between '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06) + "'"
		cQuery += " AND E2_VENCREA between '" + DTOS(mv_par07)  + "' AND '" + DTOS(mv_par08) + "'"
		cQuery += " AND E2_TIPO NOT LIKE '%-' "
		cQuery += " AND E2_EMISSAO <=  '"     + DTOS(dDataBase) + "'"
		If mv_par09 == 2
			cQuery += " AND E2_TIPO <> '"+MVPROVIS+"'"
		EndIf
		cQuery += " AND E2_FATURA IN('"+Space(Len(E2_FATURA))+"','NOTFAT')"
		
		cQuery += " ORDER BY " + cOrder
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRBSE2', .T., .T.)
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('TRBSE2', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
		
		dbSelectArea("SE2")
		dbGoTo(TRBSE2->Recno)
		
		If (TRBSE2->(EOF()))
			dbSelectArea("TRBSE2")
			dbCloseArea()
			dbSelectArea("SE2")
			Return
		EndIf
		
	EndIf
#ENDIF

While !Eof() .And. lContinua .And. &cCond1
	
	#IFDEF TOP
		dbSelectArea("SE2")
	#ENDIF
	
	IF lEnd
		@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
		Exit
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cFilterUser).and.!(&cFilterUser)
		AndaTRB("TRBSE2")
		#IFDEF TOP
			If TCSrvType() != "AS/400"
				dbSelectArea("TRBSE2")
			Endif
		#ENDIF
		Loop
	Endif
	
	nCont:=1
	nTit1:=nTit2:=nTit3:=nTit4:=nTit5:=nTit6:=nTit7:=nTit8:=nTit9:=0
	cForAnt:= &cCond2
	
	While &cCond2 == cForAnt .And. !Eof()
		
		IF lEnd
			@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
			lContinua := .F.
			Exit
		EndIF
		
		IncRegua()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Considera filtro do usuario                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cFilterUser).and.!(&cFilterUser)
			#IFDEF TOP
				dbSelectArea("SE2")
			#ENDIF
			AndaTRB("TRBSE2")
			#IFDEF TOP
				If TCSrvType() != "AS/400"
					dbSelectArea("TRBSE2")
				Endif
			#ENDIF
			Loop
		Endif
		
		#IFNDEF TOP
			If !Fr350Skip()
				dbSelectArea("SE2")
				AndaTRB()
				Loop
			EndIf
		#ENDIF
		
		dbSelectArea("SA2")
		dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
		
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		EndIF
		
		If nCont = 1
			@li,0 PSAY OemToAnsi("FORNECEDOR : ")+SA2->A2_COD+" "+SA2->A2_NOME
			li+=2
			nCont++
		Endif
		
		dbSelectArea("SE2")
		
		dDataMoeda:=SE2->E2_VENCREA
		
		IF dDataBase > SE2->E2_VENCREA .and. mv_par11 == 1
			dDataMoeda:=dDataBase
		End
		
		nTotAbat:=CalcAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,mv_par10,"P")
		aValor:=Baixas2( SE2->E2_NATUREZA,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,nMoeda,"P",SE2->E2_FORNECE,dDataMoeda,SE2->E2_LOJA)
		
		If mv_par14 == 1
			nSaldo:=SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZA,"P",E2_FORNECE,nMoeda,dDataMoeda,,SE2->E2_LOJA ) - nTotAbat
		Else
			nSaldo := xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,mv_par10)
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se foi gerada fatura, colocar Motbx == Faturado				  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SE2->E2_DTFATUR) .and. SE2->E2_DTFATUR <= dDataBase
			aValor[I_MOTBX] := "Faturado"
		Endif
		
		@li,00 PSAY SE2->E2_PREFIXO+"-"+SE2->E2_NUM
		@li,17 PSAY SE2->E2_PARCELA
		@li,20 PSAY SE2->E2_TIPO
		
		@li,24 PSAY SayValor(Moeda(SE2->E2_VALOR,nMoeda,"P",SE2->E2_EMISSAO),15,;
		alltrim(SE2->E2_TIPO)$"PA ,"+MV_CPNEG,nDecs)
		
		@li,41 PSAY SE2->E2_EMISSAO
		@li,53 PSAY SE2->E2_VENCREA
		
		IF dDataBase >= SE2->E2_BAIXA
			@li,65 PSAY IIF(!Empty(SE2->E2_BAIXA),SE2->E2_BAIXA," ")
		End
		@li, 76 PSAY aValor[I_DESCONTO]           Picture PesqPict("SE2","E2_VALOR",15,MV_PAR10)
		@li, 92 PSAY nTotAbat                     Picture PesqPict("SE2","E2_VALOR",15,MV_PAR10)
		@li,108 PSAY aValor[I_JUROS]    	         Picture PesqPict("SE2","E2_JUROS",15,MV_PAR10)
		@li,124 PSAY aValor[I_MULTA]              Picture PesqPict("SE2","E2_MULTA",15,MV_PAR10)
		@li,140 PSAY aValor[I_CORRECAO_MONETARIA] Picture PesqPict("SE2","E2_VALOR",15,MV_PAR10)
		@li,156 PSAY aValor[I_VALOR_PAGO]         Picture PesqPict("SE2","E2_VALOR",15,MV_PAR10)
		@li,172 PSAY aValor[I_PAGAM_ANT]          Picture PesqPict("SE2","E2_VALOR",15,MV_PAR10)
		
		@li,188 PSAY SayValor(nSaldo,16,alltrim(SE2->E2_TIPO)$"PA ,"+MV_CPNEG,nDecs)
		@li,206 PSAY aValor[I_MOTBX]
		If ! ( SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG )
			nTit1+= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,nMoeda,SE2->E2_EMISSAO,ndecs+1)
			nTit9+=nSaldo
			nTit7+=aValor[I_VALOR_PAGO]
		Else
			nTit1-= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,nMoeda,SE2->E2_EMISSAO,ndecs+1)
			nTit9-=nSaldo
			nTit7-=aValor[I_VALOR_PAGO]
		Endif
		nTit2+=aValor[I_DESCONTO]
		nTit3+=nTotAbat
		nTit4+=aValor[I_JUROS]
		nTit5+=aValor[I_MULTA]
		nTit6+=aValor[I_CORRECAO_MONETARIA]
		nTit8+=aValor[I_PAGAM_ANT]
		
		dbSelectArea("SE2")
		AndaTRB("TRBSE2")
		
		li++
	Enddo
	If ( ABS(nTit1)+ABS(nTit2)+ABS(nTit3)+ABS(nTit4)+ABS(nTit5)+ABS(nTit6)+ABS(nTit7)+ABS(nTit8)+ABS(nTit9) > 0 )
		ImpSubTot(nTit1,nTit2,nTit3,nTit4,nTit5,nTit6,nTit7,nTit8,nTit9)
		li++
	Endif
	nTot1+=nTit1
	nTot2+=nTit2
	nTot3+=nTit3
	nTot4+=nTit4
	nTot5+=nTit5
	nTot6+=nTit6
	nTot7+=nTit7
	nTot8+=nTit8
	nTot9+=nTit9
EndDO

IF li > 55 .and. li != 80
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
EndIF

IF li != 80
	ImpTotG(nTot1,nTot2,nTot3,nTot4,nTot5,nTot6,nTot7,nTot8,nTot9)
	roda(cbcont,cbtxt,tamanho)
EndIF

Set Device To Screen

#IFNDEF TOP
	dbSelectArea("SE2")
	dbClearFil(NIL)
	RetIndex( "SE2" )
	If !Empty(cIndex)
		FErase (cIndex+OrdBagExt())
	Endif
	dbSetOrder(1)
#ENDIF

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ImpSubTot ³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprimir linha de SubTotal do relatorio                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ImpSubTot()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpSubTot(nTit1,nTit2,nTit3,nTit4,nTit5,nTit6,nTit7,nTit8,nTit9)
li++
@li,000 PSAY OemToAnsi("Totais : ")
@li,024 PSAY nTit1  Picture PesqPict("SE2","E2_VALOR",15,MV_PAR10)
@li,076 PSAY nTit2  PicTure PesqPict("SE2","E2_VALOR",15,MV_PAR10)
@li,092 PSAY nTit3  PicTure PesqPict("SE2","E2_VALOR",15,MV_PAR10)
@li,108 PSAY nTit4  PicTure PesqPict("SE2","E2_VALOR",15,MV_PAR10)
@li,124 PSAY nTit5  PicTure PesqPict("SE2","E2_VALOR",15,MV_PAR10)
@li,140 PSAY nTit6  PicTure PesqPict("SE2","E2_VALOR",15,MV_PAR10)
@li,156 PSAY nTit7  PicTure PesqPict("SE2","E2_VALOR",15,MV_PAR10)
@li,172 PSAY nTit8  PicTure PesqPict("SE2","E2_VALOR",15,MV_PAR10)
@li,188 PSAY nTit9  PicTure PesqPict("SE2","E2_VALOR",16,MV_PAR10)
li++
@li,  0 PSAY REPLICATE("-",220)
li++
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpTotG  ³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir linha de Total do Relatorio                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpTotG()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpTotg(nTot1,nTot2,nTot3,nTot4,nTot5,nTot6,nTot7,nTot8,nTot9)
li++
@li,000 PSAY OemToAnsi("TOTAL GERAL ---->")

@li,024 PSAY nTot1  Picture PesqPict("SE2","E2_VALOR",15,MV_PAR10)
@li,076 PSAY nTot2  PicTure PesqPict("SE2","E2_VALOR",15,MV_PAR10)
@li,092 PSAY nTot3  PicTure PesqPict("SE2","E2_VALOR",15,MV_PAR10)
@li,108 PSAY nTot4  PicTure PesqPict("SE2","E2_VALOR",15,MV_PAR10)
@li,124 PSAY nTot5  PicTure PesqPict("SE2","E2_VALOR",15,MV_PAR10)
@li,140 PSAY nTot6  PicTure PesqPict("SE2","E2_VALOR",15,MV_PAR10)
@li,156 PSAY nTot7  PicTure PesqPict("SE2","E2_VALOR",15,MV_PAR10)
@li,172 PSAY nTot8  PicTure PesqPict("SE2","E2_VALOR",15,MV_PAR10)
@li,188 PSAY nTot9  PicTure PesqPict("SE2","E2_VALOR",16,MV_PAR10)
li++
Return(.t.)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FR350FIL  ³ Autor ³ Andreia          	    ³ Data ³ 12.01.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta Indregua para impressao do relat¢rio 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function FR350FIL()

cString := 'E2_FILIAL="'+xFilial("SE2")+'".And.'
cString += 'dtos(E2_EMISSAO)>="'+dtos(mv_par05)+'".and.dtos(E2_EMISSAO)<="'+dtos(mv_par06)+'".And.'
cString += 'dtos(E2_VENCREA)>="'+dtos(mv_par07)+'".and.dtos(E2_VENCREA)<="'+dtos(mv_par08)+'".And.'
cString += 'E2_FORNECE>="'+mv_par01+'".and.E2_FORNECE<="'+mv_par02+'".And.'
cString += 'E2_LOJA>="'+mv_par03+'".and.E2_LOJA<="'+mv_par04+'"'

Return cString

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ AndaTRB	³ Autor ³ Emerson / Sandro      ³ Data ³ 20.09.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Movimenta area temporaria e reposiciona SE1 ou SE2 ou SE5  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³         																	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function AndaTRB(xMyAlias)
Local cAlias:= Alias()
dbSkip()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fr350Skip ³ Autor ³ Pilar S. Albaladejo   |Data  ³ 13.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Pula registros de acordo com as condicoes (AS 400/CDX/ADS)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR350.PRX												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Fr350Skip()

Local lRet := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se esta dentro dos parametros                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF SE2->E2_FORNECE < mv_par01 .OR. SE2->E2_FORNECE > mv_par02 .OR. ;
	SE2->E2_LOJA    < mv_par03 .OR. SE2->E2_LOJA    > mv_par04 .OR. ;
	SE2->E2_EMISSAO < mv_par05 .OR. SE2->E2_EMISSAO > mv_par06 .OR. ;
	SE2->E2_VENCREA < mv_par07 .OR. SE2->E2_VENCREA > mv_par08 .OR. ;
	SE2->E2_TIPO $ MVABATIM
	lRet :=  .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o t¡tulo ‚ provis¢rio                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf (SE2->E2_TIPO $ MVPROVIS .and. mv_par09==2)
	lRet := .F.
	
ElseIF SE2->E2_EMISSAO > dDataBase
	lRet := .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o t¡tulo foi aglutinado em uma fatura            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf !Empty(SE2->E2_FATURA) .and. Substr(SE2->E2_FATURA,1,6)!="NOTFAT" .and. !Empty( SE2->E2_DTFATUR ) .and. DtoS( SE2->E2_DTFATUR ) <= DtoS( mv_par06 )
	lRet  := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se deve imprimir outras moedas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Elseif mv_par13 == 2 // nao imprime
	If SE2->E2_MOEDA != mv_par10 //verifica moeda do campo=moeda parametro
		lret := .F.
	Endif
Endif
Return lRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SayValor  ³ Autor ³ J£lio Wittwer    	  ³ Data ³ 24.06.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna String de valor entre () caso Valor < 0 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR350.PRX																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function SayValor(nNum,nTam,lInvert,nDecs)
Local cPicture,cRetorno
nDecs := IIF(nDecs == NIL, 2, nDecs)

cPicture := tm(nNum,nTam,nDecs)
cRetorno := Transform(nNum,cPicture)
IF nNum<0 .or. lInvert
	cRetorno := "("+substr(cRetorno,2)+")"
Endif
Return cRetorno


Static Function Baixas2 (cNatureza,cPrefixo,cNumero,cParcela,cTipo,nMoeda,cModo,cFornec,dData,cLoja)

Local aRetorno:={0,0,0,0,0,0,0,0,"",0}
Local cArea   :=Alias()
Local cTipoDoc:=""
Local nOrdem  :=0
Local nValor  :=0
Local nMoedaTit
Local lNaoConv
cFornec:=IIF( cFornec == NIL, "", cFornec )
cLoja := IIF( cLoja == NIL, "" , cLoja )
nMoeda:=IIf(nMoeda==NIL,1,nMoeda)
dData:=IIf(dData==NIL,dDataBase,dData)
dbSelectArea("SE5")
nOrdem:=IndexOrd()
dbSetOrder(7)
dbSeek(xFilial("SE5")+cPrefixo+cNumero+cParcela+cTipo,.T.)

nMoedaTit := Iif( cModo == "R", SE1-> E1_MOEDA , SE2 -> E2_MOEDA )

While xFilial("SE5")+cPrefixo+cNumero+cParcela+cTipo==SE5->E5_FILIAL+;
		SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO

	//Nas localizacoes e usada a movimentacao bancaria em mais de uma moeda
	//por isso, quando a baixa for contra um banco, devo pegar a E5_VLMOED2,
	//pois na E5_VALOR, estara grvado o movimento na moeda do banco.
	//Bruno. Paraguay 23/08/00 
	lNaoConv	:=	(nMoeda == 1 .And.(cPaisLoc=="BRA".Or.Empty(E5_BANCO)))
	Do Case
	Case SE5->E5_SITUACA = "C" .or. ;
			SE5->E5_TIPODOC = "ES"
		dbSkip()
		Loop
	// Despresa as movimenta‡oes diferentes do tipo solicitado somente se
	// o tipo for != de RA e PA, pois neste caso o RECPAG sera invertido.		
	Case SE5->E5_RECPAG != cModo .AND. !(SE5->E5_TIPO$MVRECANT+"/"+MVPAGANT)
		dbSkip()
		Loop		
	Case TemBxCanc()
		dbSkip()
		Loop
	Case SE5->E5_CLIFOR+SE5->E5_LOJA != cFornec + cLoja
		dbSkip( )
		Loop
	Case SE5->E5_DATA > dDataBase
		dbSkip()
		Loop
	Case SE5->E5_TIPODOC $ "VLüBA/V2/CP"
		IF cModo == "R"
				aRetorno[5]+=Iif(lNaoConv,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,SE5->E5_DATA))
		Else
				aRetorno[6]+=Iif(lNaoConv,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,SE5->E5_DATA))
		End
		aRetorno[10]+= SE5->E5_VALOR
	Case SE5->E5_TIPODOC $ "DC/D2"
			aRetorno[2]+=Iif(lNaoConv,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,SE5->E5_DATA))
	Case SE5->E5_TIPODOC $ "JR/J2"
			aRetorno[3]+=Iif(lNaoConv,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,SE5->E5_DATA))
	Case SE5->E5_TIPODOC $ "MT/M2"
			aRetorno[4]+=Iif(lNaoConv,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,SE5->E5_DATA))
	Case SE5->E5_TIPODOC $ "CM/C2/CX"
			aRetorno[1]+=Iif(lNaoConv,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,SE5->E5_DATA))
	Case SE5->E5_TIPODOC $ "RA /"+MV_CRNEG
			aRetorno[7]+=Iif(lNaoConv,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,E5_DATA))
	Case SE5->E5_TIPODOC = "PA" .or. SE5->E5_TIPODOC $ MV_CPNEG
			aRetorno[8]+=Iif(lNaoConv,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,E5_DATA))
	EndCase
	If ! Empty(SE5->E5_MOTBX )
		If SE5->E5_MOTBX == "NOR"
			aRetorno[9] := OemToAnsi("Normal")
		Elseif SE5->E5_MOTBX == "DEV"
			aRetorno[9] := OemToAnsi("Devolucao")
		Elseif SE5->E5_MOTBX == "DAC"
			aRetorno[9] := OemToAnsi("DACAO")
		Elseif SE5->E5_MOTBX == "VEN"
			aRetorno[9] := OemToAnsi("VENDOR")
		Elseif SE5->E5_MOTBX == "CMP"
			aRetorno[9] := OemToAnsi("Compensacao")
		Elseif SE5->E5_MOTBX == "CEC"
			aRetorno[9] := OemToAnsi("Comp Carteiras")
		Elseif SE5->E5_MOTBX == "DEB"
			aRetorno[9] := OemToAnsi("Debito C/C")
		Elseif SE5->E5_MOTBX == "LIQ"
			aRetorno[9] := OemToAnsi("Liquidacao")
		Elseif SE5->E5_MOTBX == "FAT"
			aRetorno[9] := OemToAnsi("Faturado")
		End
	End
	dbSkip()
End
dbSetOrder(nOrdem)
dbSelectArea(cArea)
Return(aRetorno) 