#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0040   ³ Autor ³ Alexandro da Silva    ³ Data ³ 09.09.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0040()

SetPrvt("TAMANHO,TITULO,CDESC1,CDESC2,CDESC3,NREGISTRO")
SetPrvt("CPERG,ARETURN,NOMEPROG,NLASTKEY,NBEGIN,ALINHA")
SetPrvt("LI,LIMITE,LRODAPE,CPICTQTD,NTOTQTD,NTOTVAL")
SetPrvt("APEDCLI,WNREL,CSTRING,CINDEX,CKEY,CFILTER")
SetPrvt("NINDEX,CPEDIDO,CHEADER,CPICTCGC,CPICCGC,CPEDCLI")
SetPrvt("NPED,I,CCAMPO,CCOMIS,CMOEDA,NIPI")
SetPrvt("NVIPI,NBASEIPI,NVALBASE,NDESPLAZA,LIPIBRUTO,NULTLIB")
SetPrvt("CCHAVED2,NPERRET,CESTADO,TNORTE,CESTCLI,CINSCRCLI")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private wnrel
Private tamanho:= "G"
Private titulo := OemToAnsi("Emissao da Confirmacao do Pedido")
Private cDesc1 := OemToAnsi("Emiss„o da confirmac„o dos pedidos de venda, de acordo com")
Private cDesc2 := OemToAnsi("intervalo informado na op‡„o Parƒmetros.")
Private cDesc3 := " "
Private nRegistro:= 0
private cKey,nIndex,cIndex  && Variaveis para a criacao de Indices Temp.
Private cCondicao

cPerg  :="MTR730"
PRIVATE aReturn := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }			
PRIVATE nomeprog:="PA0040",nLastKey := 0,nBegin:=0,aLinha:={ }
PRIVATE li:=80,limite:=220,lRodape:=.F.,cPictQtd:=""
PRIVATE nTotQtd:=nTotVal:=0
PRIVATE aPedCli:= {}
wnrel    := "PA0040"
cString  := "SC6"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("MTR730",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros			                ³
//³ mv_par01	     	  Do Pedido			                         ³
//³ mv_par02	     	  Ate o Pedido			                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey==27
	Set Filter to
	Return( NIL )
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return( NIL )
Endif

RptStatus({|lEnd| Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C730IMP  ³ Autor ³ Rosane Luciane Chene  ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR730			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Imp(lEnd,WnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private tamanho:="G"
Private titulo:=OemToAnsi("Emissao da Confirmacao do Pedido")
Private cDesc1:=OemToAnsi("Emiss„o da confirmac„o dos pedidos de venda, de acordo com")
Private cDesc2:=OemToAnsi("intervalo informado na op‡„o Parƒmetros.")
Private cDesc3:=" "
Private nRegistro:= 0
Private cKey,nIndex,cIndex  && Variaveis para a criacao de Indices Temp.
Private cCondicao

pergunte("MTR730",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 0,0 psay AvalImp(Limite)

//cIndex := CriaTrab(nil,.f.)
//dbSelectArea("SC5")
//cKey := IndexKey()
//cFilter := dbFilter()
//cFilter += If( Empty( cFilter ),""," .And. " )
//cFilter += 'C5_FILIAL == "'+xFilial("SC5")+'" .And. C5_NUM >= "'+mv_par01+'"'
//IndRegua("SC5",cIndex,cKey,,cFilter,"Selecionando Registros...")

////nIndex := RetIndex("SC5")

//DbSelectArea("SC5")
//DbSetOrder(nIndex+1)
//DbGoTop()

dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial("SC5")+MV_PAR01,.T.)

SetRegua(RecCount())	
While !Eof() .And. C5_NUM <= mv_par02
	
	nTotQtd:=0
	nTotVal:=0
	
	cPedido := C5_NUM
	dbSelectArea("SA4")
	dbSeek(cFilial+SC5->C5_TRANSP)
	dbSelectArea("SA3")
	dbSeek(cFilial+SC5->C5_VEND1)
	dbSelectArea("SE4")
	dbSeek(cFilial+SC5->C5_CONDPAG)
	
	dbSelectArea("SC6")
	dbSeek(cFilial+cPedido)
	cPictQtd := PESQPICTQT("C6_QTDVEN",10)
	nRegistro:= RECNO()
	
	IF lEnd
		@Prow()+1,001 Psay "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta tabela de pedidos do cliente p/ o cabe‡alho            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aPedCli:= {}
	While !Eof() .And. C6_NUM == SC5->C5_NUM
		IF !Empty(SC6->C6_PEDCLI) .and. Ascan(aPedCli,SC6->C6_PEDCLI) = 0
			AAdd(aPedCli,SC6->C6_PEDCLI)
		ENDIF
		dbSkip()
	Enddo
	aSort(aPedCli)
	
	dbGoTo( nRegistro )
	While !Eof() .And. C6_NUM == SC5->C5_NUM
		
		IF lEnd
			@Prow()+1,001 Psay "CANCELADO PELO OPERADOR"
			Exit
		Endif
		
		IF li > 48
			IF lRodape
				ImpRodape()
			Endif
			li := 0
			lRodape := ImpCabec()
		Endif
		ImpItem()
		dbSkip()
		li++
	Enddo
	
	IF lRodape // .or. Eof() .or. !( C6_NUM == SC5->C5_NUM )
		ImpRodape()
		lRodape:=.F.
	Endif
	dbSelectArea("SC5")
	dbSkip()
	
	IncRegua()
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta Arquivo Temporario e Restaura os Indices Nativos.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//RetIndex("SC5")
//Set Filter to

//Ferase(cIndex+OrdBagExt())

dbSelectArea("SC6")
//Set Filter To
dbSetOrder(1)
dbGotop()

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpCabec(void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ImpCabec()

Private cHeader,nPed,cMoeda,cCampo,cComis,cPedCli

cHeader := "It Codigo          Desc. do Material TES UM   Quant.  Valor Unit. IPI   ICM   ISS   Vl.Tot.C/IPI Entrega   Desc Loc.Qtd.a Fat     Saldo  Ult.Fat."
//          				99 xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxx 999 XX99999.99999,999,999.9999,99 99,9999,99 999,999,999.99 99/99/9999 9.9  999999999.999999999.999999999,99
//          				0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
//                      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona registro no cliente do pedido                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF !(SC5->C5_TIPO$"DB")
	dbSelectArea("SA1")
	dbSeek(cFilial+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
Else
	dbSelectArea("SA2")
	dbSeek(cFilial+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
Endif
If cPaisLoc=="ARG" 
	cPictCGC:="@R 99-99.999.999-9"
ElseIf cPaisLoc $ "POR|EUA"
	cPicCgc	:=PesqPict("SA2","A2_CGC")
Else
	cPictCGC:="@R 99.999.999/9999-99"
EndIf
@ 01,000 psay Replicate("-",limite-75)
@ 02,000 psay SM0->M0_NOME
IF !(SC5->C5_TIPO$"DB")
	@ 02,041 psay "| "+Left(SA1->A1_COD+"/"+SA1->A1_LOJA+" "+SA1->A1_NOME, 56)
	@ 02,100 psay "| CONFIRMACAO DO PEDIDO "
	@ 03,000 psay SM0->M0_ENDCOB
	@ 03,041 psay "| "+IF( !Empty(SA1->A1_ENDENT) .And. SA1->A1_ENDENT #SA1->A1_END,;
	Substr(SA1->A1_ENDENT,1,56), Substr(SA1->A1_END,1,56) )
	@ 03,100 psay "|"
	@ 04,000 psay "TEL: "+SM0->M0_TEL			
	@ 04,041 psay "| "+SA1->A1_CEP
	@ 04,053 psay SA1->A1_MUN
	@ 04,077 psay SA1->A1_EST
	@ 04,100 psay "| EMISSAO: "
	@ 04,111 psay SC5->C5_EMISSAO
	@ 05,000 psay "CGC: "
	@ 05,005 psay SM0->M0_CGC    Picture "@R 99.999.999/9999-99"
	@ 05,025 psay Subs(SM0->M0_CIDCOB,1,15)
	@ 05,041 psay "|"
	@ 05,043 psay SA1->A1_CGC    Picture "@R 99.999.999/9999-99"
	@ 05,062 psay "IE: "+SA1->A1_INSCR			
	@ 05,100 psay "| PEDIDO N. "+SC5->C5_NUM			
Else
	@ 02,041 psay "| "+Left((SA2->A2_COD+"/"+SA2->A2_LOJA+" "+SA2->A2_NOME),40)
	@ 02,100 psay "| CONFIRMACAO DO PEDIDO "
	@ 03,000 psay SM0->M0_ENDCOB
	@ 03,041 psay "| "+Substr(SA2->A2_END,1,56)
	@ 03,100 psay "|"
	@ 04,000 psay "TEL: "+SM0->M0_TEL			
	@ 04,041 psay "| "+SA2->A2_CEP
	@ 04,053 psay SA2->A2_MUN
	@ 04,077 psay SA2->A2_EST
	@ 04,100 psay "| EMISSAO: "
	@ 04,111 psay SC5->C5_EMISSAO
	@ 05,000 psay "CGC: "
	@ 05,005 psay SM0->M0_CGC    Picture "@R 99.999.999/9999-99"
	@ 05,025 psay Subs(SM0->M0_CIDCOB,1,15)
	@ 05,041 psay "|"
	@ 05,043 psay SA2->A2_CGC    Picture "@R 99.999.999/9999-99"
	@ 05,062 psay "IE: "+SA2->A2_INSCR			
	@ 05,100 psay "| PEDIDO N. "+SC5->C5_NUM			
Endif
li:= 6
If Len(aPedCli) > 0
	@ li,000 psay Replicate("-",limite-75)
	li++
	@ li,000 psay "PEDIDO(S) DO CLIENTE:"
	cPedCli:=""
	For nPed := 1 To Len(aPedCli)
		cPedCli += aPedCli[nPed]+Space(02)
		If Len(cPedCli) > 100 .or. nPed == Len(aPedCli)
			@ li,23 psay cPedCli
			cPedCli:=""
			li++
		Endif
	Next
Endif
@ li,000 psay Replicate("-",limite-75)
li++
@ li,000 psay "TRANSP...: "+SC5->C5_TRANSP+" - "+SA4->A4_NOME			
li++

For i := 1 to 5
	
	cCampo := "SC5->C5_VEND" + Str(i,1,0)
	cComis := "SC5->C5_COMIS" + Str(i,1,0)
	
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek(cCampo)
	If !Eof()
		Loop
	Endif
	
	If !Empty(&cCampo)
		dbSelectArea("SA3")
		dbSeek(cFilial+&cCampo)
		If i == 1
			@ li,000 psay "VENDEDOR.: "
		EndIf
		@ li,013 psay &cCampo + " - "+SA3->A3_NOME
		If i == 1
			@ li,065 psay "COMISSAO: "
		EndIf
		@ li,075 psay &cComis Picture "99.99"
		li++
	Endif
Next

li++
@ li,000 psay "COND.PGTO: "+SC5->C5_CONDPAG+" - "+SE4->E4_DESCRI			
@ li,065 psay "FRETE...: "
@ li,075 psay SC5->C5_FRETE  Picture "@EZ 999,999,999.99"
If SC5->C5_FRETE > 0
	@ li,090 psay IIF(SC5->C5_TPFRETE="C","(CIF)","(FOB)")
Endif
@ li,100 psay "SEGURO: "
@ li,108 psay SC5->C5_SEGURO Picture "@EZ 999,999,999.99"
li++
@ li,000 psay "TABELA...: "+SC5->C5_TABELA		
@ li,065 psay "VOLUMES.: "
@ li,075 psay SC5->C5_VOLUME1    Picture "@EZ 999,999"
@ li,100 psay "ESPECIE: "+SC5->C5_ESPECI1		
li++
cMoeda:=Strzero(SC5->C5_MOEDA,1,0)
@ li,000 psay "REAJUSTE.: "+SC5->C5_REAJUST+"   Moeda : " +IIF(cMoeda < "2","1",cMoeda)		
@ li,065 psay "BANCO: " + SC5->C5_BANCO					
@ li,100 psay "ACRES.FIN.: "+Str(SC5->C5_ACRSFIN,6,2)		
li++
@ li,000 psay Replicate("-",limite-75)
li++
@ li,000 psay cHeader
li++
@ li,000 psay Replicate("-",limite-75)
li++
Return( .T. )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpItem  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpItem(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ImpItem()

Private nIPI :=0,nVipi:=0,nBaseIPI :=100,nValBase := 0,nDesplaza:=0
Private lIpiBruto:=IIF(GETMV("MV_IPIBRUT")=="S",.T.,.F.)
Private nUltLib  := 0
Private cChaveD2 := ""

dbSelectArea("SB1")
dbSeek(cFilial+SC6->C6_PRODUTO)
dbSelectArea("SF4")
dbSeek(cFilial+SC6->C6_TES)
IF SF4->F4_IPI == "S"
	nBaseIPI := IIF(SF4->F4_BASEIPI > 0,SF4->F4_BASEIPI,100)
	nIPI 		:= SB1->B1_IPI
	nValBase := If(lIPIBruto .And. SC6->C6_PRUNIT > 0,SC6->C6_PRUNIT,SC6->C6_PRCVEN)*SC6->C6_QTDVEN
	nVipi		:= NoRound(nValBase * (nIPI/100)*(nBaseIPI/100),2)
Endif

@li,000 psay SC6->C6_ITEM
@li,003 psay SC6->C6_PRODUTO
@li,019 psay SUBS(IIF(Empty(SC6->C6_DESCRI),SB1->B1_DESC,SC6->C6_DESCRI),1,17)
@li,037 psay SC6->C6_TES
@li,041 psay SC6->C6_UM
@li,043 psay SC6->C6_QTDVEN	Picture cPictQtd
@li,052 psay SC6->C6_PRCVEN	Picture PesqPict("SC6","C6_PRCVEN",12)
@li,065 psay nIPI				   Picture "@e 99.99"

If ( cPaisLoc=="BRA" )
	nPerRet:= a730VerIcm()
	
	@li,071 psay nPerRet Picture "@e 99.99"
	@li,076 psay SB1->B1_ALIQISS	Picture "@e 99.99"
	nDesplaza:=6
EndIf

cChaveD2 := xFilial("SD2")+SC6->(C6_NOTA+C6_SERIE+C6_CLI+C6_LOJA+C6_PRODUTO)
dbSelectArea("SD2")
dbSetOrder(3)
dbSeek(cChaveD2)
While cChaveD2 = xFilial("SD2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD
	nUltLib := D2_QUANT
	dbSkip()
EndDo
dbSetOrder(1)
dbSelectArea("SC6")

@li,076+ndesplaza   psay SC6->C6_VALOR+nVIPI Picture PesqPict("SC6","C6_VALOR",14)
@li,091+ndesplaza   psay SC6->C6_ENTREG
@li,099+ndesplaza+2 psay SC6->C6_DESCONT    Picture "99.9"
@li,105+ndesplaza+2 psay SC6->C6_LOCAL
@li,107+ndesplaza+2 psay SC6->C6_QTDEMP + SC6->C6_QTDLIB + SC6->C6_QTDENT Picture PesqPict("SC6","C6_QTDLIB",10)
@li,117+ndesplaza+2 psay SC6->C6_QTDVEN - SC6->C6_QTDEMP + SC6->C6_QTDLIB - SC6->C6_QTDENT Picture PesqPict("SC6","C6_QTDLIB",10)
@li,127+ndesplaza+2 psay nUltLib Picture PesqPict("SD2","D2_QUANT",10)

nTotQtd += SC6->C6_QTDVEN
nTotVal += SC6->C6_VALOR+nVipi

dbSelectArea("SC6")



Static Function ImpRodape()

@ li,000 psay Replicate("-",limite-75)
li++
@ li,000 psay " T O T A I S "
@ li,043 psay nTotQtd    Picture cPictQtd
If ( cPaisLoc=="BRA" )
	@ li,079 psay nTotVal    Picture PesqPict("SC6","C6_VALOR",17)
Else
	@ li,068 psay nTotVal    Picture PesqPict("SC6","C6_VALOR",17)
EndIf
@ 51,005 psay "PESO BRUTO ------>"+STR(SC5->C5_PBRUTO)	
@ 52,005 psay "PESO LIQUIDO ---->"+STR(SC5->C5_PESOL)	
@ 53,005 psay "VOLUMES --------->"
@ 54,005 psay "SEPARADO POR ---->"
@ 55,005 psay "CONFERIDO POR --->"
@ 56,005 psay "D A T A --------->"

@ 58,000 psay "DESCONTOS: "
@ 58,011 psay SC5->C5_DESC1 Picture "99.99"
@ 58,019 psay SC5->C5_DESC2 picture "99.99"
@ 58,027 psay SC5->C5_DESC3 picture "99.99"
@ 58,035 psay SC5->C5_DESC4 picture "99.99"

@ 60,000 psay "MENSAGEM PARA NOTA FISCAL: "+AllTrim(SC5->C5_MENNOTA)			
@ 61,000 psay ""

li := 80

Return( NIL )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A730verIcm³ Autor ³ Claudinei M. Benzi    ³ Data ³ 11.02.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para verificar qual e o ICM do Estado               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA460                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function A730VerIcm(void)
Private nPerRet:=0		// Percentual de retorno
Private cEstado:=GetMV("mv_estado"),tNorte:=GetMV("MV_NORTE")
Private cEstCli:=IIF(SC5->C5_TIPO$"DB",SA2->A2_EST,SA1->A1_EST)
Private cInscrCli:=IIF(SC5->C5_TIPO$"DB",SA2->A2_INSCR,SA1->A1_INSCR)

If SF4->F4_ICM == "S"
	nPerRet := AliqIcms(	SC5->C5_TIPO,;	// Tipo de Operacao
					"S",;								// Tipo de Nota ('E'ntrada/'S'aida)
					SC5->C5_TIPOCLI)				// Tipo do Cliente ou Fornecedor
EndIf
Return(nPerRet)