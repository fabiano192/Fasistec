#INCLUDE "TmsA200.ch"
#INCLUDE "Protheus.ch"

Static cMv_Estado  := ''
Static lPrdDiv
Static lPrcProd
Static nKmP
Static aNFTipVei   := {}
Static __aFilDes   := {}

Static lTM200SEQ   := ExistBlock("TM200SEQ")
Static lTM200PER   := ExistBlock("TM200PER")
Static lTm200Fis   := ExistBlock("TM200FIS")
Static lTM200ICT   := ExistBlock("TM200ICT")
Static lTm200Cpg   := ExistBlock("TM200CPG")
Static lTM200DEB   := ExistBlock("TM200DEB")
Static lCHGSX5FIL  := ExistBlock("CHGX5FIL")
Static lTM200BLQ   := ExistBlock("TM200BLQ")
Static lTm200Fil   := ExistBlock("TM200FIL")	//-- Adiciona um filtro na query de selecao de Notas Fiscais do Cliente.
Static lTM200CUB   := ExistBlock("TM200CUB")	//-- Pto que permite a alteraÁ„o do Peso Cubado
Static lTM200SER   := ExistBlock("TM200SER")	//-- Pto que permite alterar o numero de serie da nota fiscal
Static lTM200PRD   := ExistBlock("TM200PRD")	//-- Pto que permite alterar o produto de imposto
Static lTM200COT   := ExistBlock("TM200COT")
Static lTM200CTR   := ExistBlock("TM200CTR")
Static lTM200SCTE  := ExistBlock("TM200SCTE")	//-- Pto que permite alterar a serie para gerar o CTE
Static lTM200NFC   := ExistBlock("TM200NFC")
Static lTM200PRC   := ExistBlock("TM200PRC")
Static lTM200OK    := ExistBlock("TM200OK" )
Static lTM200QBR   := ExistBlock("TM200QBR")
Static lTM200ISS   := ExistBlock("TM200ISS")
Static lTM200THR   := ExistBlock("TM200THR")
Static lTM200Exc   := ExistBlock("TM200EXC")
Static lTM200REM   := ExistBlock("TM200REM")
Static lTM200EST   := ExistBlock("TM200EST")
Static lTM200BICM  := ExistBlock("TM200BICM")
Static lTM200TES   := ExistBlock("TM200TES")
Static lPETM200D   := ExistBlock("TM200DT")
Static lCalISS     := ExistBlock("TM200IISS")	//-- Ponto de entrada para utilizar a funÁ„o TMSA040IMP
Static lTM200CAL   := ExistBlock("TM200CAL")
Static lTM200DOC   := ExistBlock("TM200DOC")	//-- Ponto de entrada para troca do documento de transporte
Static lTM200LOT   := ExistBlock("TM200LOT") //-- Ponto de entrada para determinar o agrupamento das Notas Fiscais da SolicitaÁ„o de Coleta (DTC_NUMSOL).
Static lTM200PW01  := ExistBlock("TM200PW01")	//-- Ponto de entrada que possibilita alterar os dados do preview.
Static lTm200NUM   := ExistBlock("TM200NUM")
Static lTM200CLR   := ExistBlock("TM200CLR") //-- Ponto de entrada para determinar criterios especificos nas quebras por classe de risco de produtos
Static lTM200GLO   := ExistBlock("TM200GLO") //-- Ponto de entrada impede a quebra de lote (que contem varios docs) ao realizar estorno do calculo de apenas um doc, para um determinado cliente.

Static aCliRecno  	:= {}   ////cache do SA1
Static aGrRegRec  	:= {}   ////cache do DUY
Static lValCol    	:= .F.  //-- Vari·vel De IdentificaÁ„o De ValorizaÁ„o De Coletas
Static cMV_TMSRRE	:= "" 	//-- Controle RRE: 1=Calculo Frete, 2=CotaÁ„o, 3=Viagem, 4=Sol. Coleta, Em Branco=N„o Controla
Static cCont340  	:= ""  	//-- N˙mero Do Contrato Oriundo Do TMSA340
Static cLotePosic	:= ""	//-- Lote

//-- Diretivas para o vetor aLote
#define LTCLIREM	1
#define LTLOJREM	2
#define LTCLIDES	3
#define LTLOJDES	4
#define LTCLIDEV	5
#define LTLOJDEV	6
#define LTCLICAL	7
#define LTLOJCAL	8
#define LTCLIAGR	9
#define LTLOJAGR	10
#define LTNUMCOT	11
#define LTCODPRO	12
#define LTLOCPAD	13
#define LTUNIMED	14
#define LTTIPO		15
#define LTSEGUM		16
#define LTDSCPRO	17
#define LTNUMNFC	18
#define LTSERNFC	19
#define LTQTDVOL	20
#define LTVALOR		21
#define LTPESO		22
#define LTPESOM3	23
#define LTBASSEG	24
#define LTCDRORI	25
#define LTCDRDES	26
#define LTCDRCAL	27
#define LTTIPFRE	28
#define LTSERVIC	29
#define LTDOCTMS	30
#define LTSERDOC	31
#define LTSERTMS	32
#define LTTIPTRA	33
#define LTNFCTRC	34
#define LTPESCTR	35
#define LTCPAGPV	36
#define LTNCONTR	37
#define LTTABFRE	38
#define LTTIPTAB	39
#define LTTABALT	40
#define LTTIPALT	41
#define LTAJUSTE	42
#define LTPRDIMP	43
#define LTCDRPER	44
#define LT1oNFCT	45
#define LT1oPESC	46
#define LT1oCPAG	47
#define LT1oNCON	48
#define LT1oTABF	49
#define LT1oTIPT	50
#define LT1oTABA	51
#define LT1oTIPA	52
#define LT1oAJUS	53
#define LTDEVFRE	54
#define LTMETRO3	55
#define LTQTDUNI	56
#define LTVALDPC	57
#define LTCLICON	58
#define LTLOJCON	59
#define LTCLIDPC	60
#define LTLOJDPC	61
#define LTFILDPC	62
#define LTCTRDPC	63
#define LTCLIGEN	64
#define LTAGRNFC	65
#define LT1oAGRN	66
#define LTVALINF	67
#define LTNUMSOL	68
#define LTTIPVEI	69
#define LTTIPNFC	70
#define LTKM		71
#define LTFILCFS	72
#define LTSQEDES	73
#define LTPESCUB	74
#define LTSEQINS	75
#define LTPESLIQ	76
#define LTMOEDA		77
#define LTMOENFC	78
#define LTEXCTDA	79
#define LTDEVTDA	80
#define LTREMTDA	81
#define LTDESTDA	82
#define LTSEQINSD	83
#define LTIPLOT		84
#define LTRECISS	85
#define LTTAXCTR	86
#define LTNUMAGD	87			//-- N˙mero do Agendamento de Entrega.
#define LTITEAGD	88			//-- Item do Agendamento de Entrega.
#define LTCHDANFE   89          //--Chave da DANFE
#define LTQBRCALC	90
#define LTQBRDIVG	91
#define LTDATAGD 	92			// Data de Agendamento
#define LTCTEANT   	93     		//-- chave do Cte redespacho Anterior
#define LTCLIEXP   	94     		//-- Codigo Cliente Expedidor
#define LTLOJEXP   	95     		//-- Loja Cliente Expedidor
#define LTCODNEG   	96			//-- Codigo da negociaÁ„o comercial
#define LTPESCOL   	97			//-- Peso Coleta
#define LTVALCOL   	98			//-- Valoriza Coleta nao Realizada
#define LTCRDVHV   	99			//-- Criterio Rateio Herda Valor (CRDVHV)
#define LTCLIREC   100
#define LTLOJREC   101
#define LTFREINF   102          //-- Indica se o Frete foi informado(digitado) **j· com imposto
#define LTRETIRA   103 			//-- TAG Retira

//-- Diretivas para o vetor aNFCTR
#define LTPESONF	 7

//-- Diretivas repetiÁ„o thread
#Define NTRYMAX		1000

//-- Diretivas indicando as colunas dos documentos da viagem Do TMSA141
#define CTSTATUS		1
#define CTSTROTA		2
#define CTMARCA			3
#define CTSEQUEN		4
#define CTARMAZE		5
#define CTLOCALI		6
#define CTFILDOC		7
#define CTDOCTO			8
#define CTSERIE			9
#define CTREGDES		10
#define CTDATEMI		11
#define CTPRZENT		12
#define CTNOMREM		13
#define CTNOMDES		14
#define CTQTDVOL		15
#define CTVOLORI		16
#define CTPLIQUI		17
#define CTPESOM3		18
#define CTVALMER		19
#define CTVIAGEM		20
#define CTSEQDA7		21
#define CTSOLICI		22			//-- DUE_NOME
#define CTENDERE		23			//-- DUE_END
#define CTBAIRRO		24			//-- DUE_BAIRRO
#define CTMUNICI		25			//-- DUE_MUN
#define CTDATSOL		26			//-- DT5_DATSOL
#define CTHORSOL		27			//-- DT5_HORSOL
#define CTDATPRV		28			//-- DT5_DATPRV
#define CTHORPRV		29			//-- DT5_HORPRV
#define CTDOCROT		30			//-- Codigo que identifica a q rota pertence o documento
#define CTBLQDOC		31			//-- Tipos de bloqueio do documento
#define CTNUMAGE		32			//-- Numero do Agendamento( Carga Fechada ).
#define CTITEAGE		33			//-- Item do Agendamento( Carga Fechada ).
#define CTSERTMS		34			//-- Tipo do Servico.
#define CTDESSVT		35			//-- Descricao do Servico.

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥ TMSA200  ≥ Autor ≥ Alex Egydio           ≥ Data ≥06.02.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Calculo do frete                                           ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA200(ExpC1,ExpC2,ExpN1)                                 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥          ≥ ExpC1 = String com expressao inicial para mbrowse.         ≥±±
±±≥          ≥ ExpC2 = String com expressao final   para mbrowse.         ≥±±
±±≥          ≥ ExpN1 = Indice do DTP que interage com ExpC2 e ExpC3.      ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥                                                            ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TMSA200(cTop200,cBot200,nInd200)

Local aCores      := {}
Local aSetKey     := {}
Local lTMB200     := ExistBlock("TMB200")
Local lTMB200per  := .T.
Local lPainel     := .F.
Local cFilBrwTop  := " DTP_TIPLOT <> '5' " //-- Exclui Da ApresentaÁ„o Do mBrowse Lotes Do Tipo '5' (Coleta).

Private cCadastro	:= STR0001 //'Calculo de Frete'
Private aPedBlq		:= {}
Private lIsImpDoc	:= .F.
Private lTmsCFec	:= TmsCFec()
Private aRotina		:= MenuDef()
Private nNumCTRC    := 0

DEFAULT nInd200   := 2

TmsCxTabFer() // Cria arquivo temporario no banco para armazenar Feriados Municip. e Regionais
TmsCriaProc() // Cria Procedures din‚micas

MaNfsInit() //Cache MATA461
If IsInCallStack("TMSAF76") .And. Type("aPanAgeTMS") == "U"
	aPanAgeTMS := Array(6)
EndIf

lPainel := IsInCallStack("TMSAF76") .And. !Empty(aPanAgeTMS)

ACores := TMSA200Cor()

If lTMB200
	lTMB200per := ExecBlock("TMB200",.F.,.F.)	// Permite desabilitar o F12 (Parametros)
	If ValType(lTMB200per) # "L"				// para que qualquer usuario nao mude a pergunta
		lTMB200per := .T.						// "Transmite CT-e?" de Nao p/ Sim e vice versa.
	EndIf
EndIf

//-- Indice 2 DTP_FILIAL + DTP_STATUS, para interagir com o top, bottom da mbrowse.
DbSelectArea('DTP')
DbSetOrder( nInd200 )
AAdd(aSetKey, { VK_F12 , { || Pergunte("TMB200",lTMB200per) } } )

//-- Inicializa Teclas de Atalhos
TmsKeyOn(aSetKey)
//-- Calcular somente os lotes com status "2 - Digitado".
If lPainel
	If AllTrim(aPanAgeTMS[6]) == "TMSAE70(1)"
		&(aPanAgeTMS[6])
	Else
		&(aPanAgeTMS[6] + "('" + aPanAgeTMS[1] + "'," + StrZero(aPanAgeTMS[2],10) + "," + StrZero(aPanAgeTMS[3],2) + ")")
	EndIf
Else
	mBrowse( 6 ,1 ,22 ,75 ,'DTP' , , , , , ,aCores , cTop200 , cBot200 , , , , , , cFilBrwTop , , , )
EndIf

RetIndex('DTP')

TmsKeyOff(aSetKey)

//-- Limpa cache
ResetArr(@__aFilDes  , .T. )
ResetArr(@aGrRegRec , .T. )
ResetArr(@__aPrdImp	,.T. )
ResetArr(@__aTaxa	, .T.)
ResetArr(@__aEstOri ,.T.	)
ResetArr(@__aEstCal , .T.	)
ResetArr(@__aAvalCred , .T.	)
ResetArr(@__aServic, .T. )
ResetArr(@aCliRecno , .T.)

//-- Limpa arrays locais
ResetArr(@aCores)
ResetArr(@aSetKey)

//-- Exclui procedures din‚micas
TmsDelProc()

Return( Nil )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200Mnt≥ Autor ≥ Alex Egydio           ≥ Data ≥06.02.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Tela principal do calculo                                  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA200Mnt(ExpC1,ExpN1,ExpN2)                              ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpC1 = Alias do arquivo                                   ≥±±
±±≥          ≥ ExpN1 = Numero do registro                                 ≥±±
±±≥          ≥ ExpN2 = Opcao selecionada                                  ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TMSA200Mnt(cAlias,nReg,nOpcx,lReserv,lConfirma, cContrato )

Local dDataOri  := dDataBase
Local aSays     := {}
Local aButtons  := {}
Local nOpca     := 0
Local lTM200CAN := ExistBlock("TM200CAN")
Local lPETM200D := ExistBlock("TM200DT")
Local lRet      := .T.
Local lPainel   := .f.

Default lConfirma := .T.
Default cContrato := ""

lPainel := IsInCallStack("TMSAF76") //-- .And. !Empty(aPanAgeTMS)
lValCol := DTP->DTP_TIPLOT == StrZero(5,Len(DTP->DTP_TIPLOT))
SaveInter()

//-- Carrega Vari·vel De Contrato Oriundo Do TMSA340
If !Empty(cContrato)
	cCont340 := cContrato
EndIf

If ValType(lConfirma) != 'L'
	lConfirma := .T.
EndIf

//-- Verifica o tipo de lote
// Opcao de Calculo so podera ser executado para Lotes Normal, Eletronico e CTe ⁄nico.
If nOpcx == 2 .And. DTP->DTP_TIPLOT <> StrZero(1,Len(DTP->DTP_TIPLOT)) .And. DTP->DTP_TIPLOT <> StrZero(3,Len(DTP->DTP_TIPLOT)) .And. DTP->DTP_TIPLOT <> StrZero(4,Len(DTP->DTP_TIPLOT));
.And. !(lValCol) //-- Permite Processamento De Lotes De Coleta
	Help(" ",1,"TMSA20034",,,5,11) // Este n„o È um lote normal. Verifique o tipo do lote.
	Return( .F. )
EndIf
If nOpcx == 5 .AND. DTP->DTP_TIPLOT <> StrZero(2,Len(DTP->DTP_TIPLOT)) //-- Lote de Refaturamento?
	Help(" ",1,"TMSA20035",,,5,11) // Este n„o È um lote de refaturamento. Verifique o tipo do lote.
	Return( .F. )
EndIf

If !Empty(DTP->DTP_FILORI)
	If DTP->DTP_FILORI != cFilAnt
		Help(' ', 1, 'TMSA20019',,STR0047 + DTP->DTP_FILORI + ' / ' + DTP->DTP_LOTNFC,5,11)			//-- Este lote nao pertence a esta filial !###"Filial / Lote : "
		Return( .F. )
	EndIf
EndIf

If (SuperGetMv("MV_TMSTHRC", , 0) > 0) .And. (SuperGetMV("MV_TPNRNFS") != "3") .And. nOpcx == 2
	Help( ' ', 1, STR0074,, STR0124,5,11) // Configure o parametro MV_TPNRNFS igual a 3 (SD9) para habilitar o uso de multi-threads
	Return( .F. )
EndIf

//-- Tratamento Para Lotes Com Campo DTP_CRIRAT = 'A'
If !lPainel
	If DTP->(ColumnPos("DTP_CRIRAT")) > 0 .And. DTP->DTP_CRIRAT == "A"
		Help(' ', 1, 'TMSA20056',,,5,11)			//-- Lotes Com CritÈrio De C·lculo De Rateio Igual a 'A' Devem Ser Processados Somente No Painel De Agendamento.
		Return( .F. )
	EndIf
EndIf

//-- Executa ponto de entrada para alterar a database do sistema
If lPETM200D
	dDataBase := ExecBlock("TM200DT",.F.,.F.,dDataBase)
	If ValType(dDataBase) # "D"
		dDataBase := dDataOri
	EndIf
EndIf

If nOpcx == 2
	If lConfirma
		AAdd( aSays, STR0007 ) //'Este programa tem como objetivo, gerar documentos para cobranáa de frete, a '
		AAdd( aSays, STR0008 ) //'partir de c†lculos efetuados atravÇs da tabela de frete, contida no contrato '
		AAdd( aSays, STR0009 ) //'de cada cliente. '

		AAdd( aButtons, { 1, .T., {|o| lRet := TMSA200Prc( DTP->DTP_FILORI, DTP->DTP_LOTNFC ), nOpca:= 1, o:oWnd:End() } } )
		AAdd( aButtons, { 2, .T., {|o| o:oWnd:End() } } )

		//-- Ponto de Entrada para habilitar o bot„o do Controle de Serie/Nota
		If lTm200NUM
			lRet:= ExecBlock("TM200NUM",.F.,.F.)
			If ValType(lRet) # "L"
				lRet := .T.
			EndIf
			If lRet
				AAdd( aButtons, { 5, .T., {|| Sx5NumNota(,SuperGetMV("MV_TPNRNFS")) } } )
			EndIf
		EndIf

		FormBatch( cCadastro, aSays, aButtons )
	Else
		lRet := TMSA200Prc( DTP->DTP_FILORI, DTP->DTP_LOTNFC )
	EndIf
Else
	TMSA500Ref(DTP->DTP_FILORI,DTP->DTP_LOTNFC)
EndIf

If nOpcx == 2 .And. nOpca <> 1
	If lTM200CAN
		ExecBlock("TM200CAN",.F.,.F.)
	EndIf
EndIf

//-- Restaura a database do sistema
If lPETM200D
	dDataBase := dDataOri
EndIf
RestInter()

ResetArr(@aButtons)
ResetArr(@aSays)
Return( lRet )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200Prc≥ Autor ≥ Alex Egydio           ≥ Data ≥06.02.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Executa o processamento da rotinas                         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpC1 = Filial de Origem                                   ≥±±
±±≥          ≥ ExpC2 = Numero do lote                                     ≥±±
±±≥          ≥ ExpL1 = .T. Qd disparado pelo recalculo                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TMSA200Prc( cFilOri, cLotNfc, lRecalculo, lSelLote )

Local aAreaAnt	:= GetArea()
Local aAreaDTP	:= DTP->(GetArea())
Local aAreaDTC	:= DTC->(GetArea())
Local aAreaDC5  := DC5->(GetArea())
Local lEnd		:= .F.
Local lRet		:= .T.
Local aMsgErr	:= {}
Local aVisErr   := {}
Local lRTMSR01  := ExistBlock("RTMSR01")
Local lRTMSR17  := ExistBlock("RTMSR17")
Local dDatFTMS  := GetMv("MV_DATATMS",.F.,CtoD(''))
Local dDatFFIN  := GetMV("MV_DATAFIN",.F.,CtoD(''))
Local cFilLot	:= ""
Local cLotCot	:= ""
Local cQuery	:= ""
Local cAliasQry	:= ""
//-- PE TM200CTR
Local nNumCTRC	:= 0
Local nCntFor	:= 0
Local cTipTra	:= ''
Local cNumCot	:= ''
Local nNfCTRC	:= 0
Local nPesCTR	:= 0
Local nPeso		:= 0
Local lUltimo	:= .F.
Local cCodPro	:= ''
Local cNextPro	:= ''
Local cNumNfc	:= ''
Local cSerNfc	:= ''
Local lAddNfc	:= .T.
Local n1Cnt		:= 0
Local n2Cnt		:= 0
Local n3Cnt		:= 0
Local lTaxa		:= .F.
Local nSeek		:= 0
Local aFrete	:= {}
Local aProduto	:= {}
Local aNfCTRC	:= {}
Local lOk		:= .F.
Local lIdentDoc := DTC->(ColumnPos("DTC_DOCTMS")) > 0
Local aDUMVlrs := {0,0,0,0,0,0}
//-- Inicio Ct-e
Local lTMSCTe   := SuperGetMv( "MV_TMSCTE",  .F., .F. ) //-- Parametro do CT-e ativo.
Local cAliasDT6 := ''
Local lLotExpress := .F.
Local nTotDoc	:= 0
Local nTotnTran	:= 0
//-- Fim Ct-e
Local lCTeUnico	:= .F.
Local cTipEmite	:= ''
Local aVetDiv     := {}  //-- Vetor Para Controle Das Sequencias De Quebra De Documentos Por Incompatibilidades De Classe Risco / Grupo Embalagens
Local aRatTDA     := {}
Local lTabAlt     := .F. // Utiliza para indicar ao Rateio que foi utilizada Tabela de Frete Alternativa
Local lDocto      := .F.
Local lBlq        := .F.

Local aFreteCol   := {}

Local aErrEst     := {}

Private aLote     := {}
Private aDocto    := {}
Private cRet      := {}
Private lImpDoc   := .T. //-- Variavel Private para permitir que o P.E. TM200PRC possa alterar o seu conteudo
Private aDelDocto := {}
Private cMark

DEFAULT lRecalculo := .F.
Default lSelLote   := .F.

lValCol   := DTP->DTP_TIPLOT == StrZero(5,Len(DTP->DTP_TIPLOT))

cFilOri 	:= Padr(cFilOri,Len(DTP->DTP_FILORI))
cLotePosic	:= cLotNfc //-- Alimenta Static

If	!lRecalculo
	//-- Posiciona no lote de notas fiscais do cliente.
	DTP->(DbSetOrder(2)) //DTP_FILIAL+DTP_FILORI+DTP_LOTNFC
	If	DTP->( ! MsSeek( xFilial('DTP') + cFilOri + cLotNfc, .F. ) )
		Help( ' ', 1, 'TMSA20001',,STR0006 + cLotNfc,5,11) //-- Lote de notas fiscais do cliente nao encontrado (DTP). //'Lote : '
		Return( .F. )
	EndIf

	If	DTP->DTP_STATUS != '2'
		Help(' ', 1, 'TMSA20002',,STR0006 + DTP->DTP_LOTNFC,5,11) //-- Status do lote diferente de digitado. (DTP) //'Lote : '
		Return( .F. )
	EndIf

	If DTP->DTP_FILORI != cFilAnt
		Help(' ', 1, 'TMSA20019',,STR0047 + DTP->DTP_FILORI + ' / ' + DTP->DTP_LOTNFC,5,11) //-- Este lote nao pertence a esta filial !###"Filial / Lote : "
		Return( .F. )
	EndIf

	//-- Verifica a data de execucao
	If GetNewPar("MV_NFCHGDT",.F.) //Informa se a data base do sistema deve ser alterada, se a data do sistema operacional for alterada, na preparacao do documento de saida.
		If MsDate()==dDataBase+1
			If MsgYesNo(STR0125,OemToAnsi(STR0074)) //"O sistema identificou a troca da data do sistema operacional, deseja atualizar a data base do sistema?"###"Aviso"
				dDataBase := MsDate()
			EndIf
		EndIf
	EndIf

	//-- Nao permite emissao/estorno de documentos com data menor que o fechamento do estoque
	If dDataBase <= MVUlmes()
		Help ( " ", 1, "FECHTO" ) //"Nao pode ser digitado movimento com data anterior a ultima data de fechamento (virada de saldos)"
		Return( .F. )
	EndIf

	If !Empty(dDatFTMS)
		If dDataBase <= dDatFTMS
			Help ( " ", 1, "FECHATMS" )
			Return( .F. )
		EndIf
	EndIf

	If !Empty(dDatFFIN)
		If dDataBase < dDatFFIN
			Help ( " ", 1, "DTMOVFIN" )
			Return( .F. )
		EndIf
	EndIf

	If !Empty(GetMV("MV_DATAFIS",,""))
		If !FisChkDt(dDataBase)
			Return( .F. )
		EndIf
	EndIf

	//-- Verifica se o agendamento est· sendo utilizado por outro usu·rio no painel de agendamentos
	If !TMSAVerAge("5",,,,,,,,,,,,"2",.T.,.T.,cLotNFc,,StrZero(ThreadId(),20))
		Return (.F.)
	EndIf

	//--- Verifica se as Notas estao vinculadas a uma ProgramaÁ„o de Carregamento
	If !IsInCallStack(AllTrim('TMSA146'))
		DbSelectArea("DF8")
		If DF8->(ColumnPos("DF8_SEQPRG")) > 0
			cAliasQry := GetNextAlias()
			cQuery := " SELECT	DISTINCT	DTC_NUMNFC, DTC_SERNFC, DTC_CLIREM, DTC_LOJREM, DD9_FILORI, DD9_NUMPRG "
			cQuery += " FROM " 		+ RetSqlName("DTC") + " DTC "
			cQuery += " INNER JOIN " + RetSqlName("DD9") + " DD9 "
			cQuery += " ON 			DD9.DD9_FILIAL = '" + xFilial('DD9') + "' "
			cQuery += " AND 			DD9.DD9_NUMNFC = DTC.DTC_NUMNFC "
			cQuery += " AND 			DD9.DD9_SERNFC = DTC.DTC_SERNFC "
			cQuery += " AND 			DD9.DD9_CLIREM = DTC.DTC_CLIREM "
			cQuery += " AND 			DD9.DD9_LOJREM = DTC.DTC_LOJREM "
			cQuery += " AND 			DD9.D_E_L_E_T_ = ' ' "
			cQuery += " INNER JOIN " + RetSqlName("DF8") + " DF8 "
			cQuery += " ON 			DF8.DF8_FILIAL = '" + xFilial('DF8') + "' "
			cQuery += " AND 			DF8.DF8_FILORI = DD9.DD9_FILORI "
			cQuery += " AND 			DF8.DF8_NUMPRG = DD9.DD9_NUMPRG "
			cQuery += " AND 			DF8.DF8_STATUS = '" + StrZero(1,Len(DF8->DF8_STATUS)) + "' "
			cQuery += " AND 			DF8.D_E_L_E_T_ = ' ' "
			cQuery += " WHERE 		DTC.DTC_FILIAL = '" + xFilial('DTC') + "' "
			cQuery += " AND 			DTC.DTC_FILORI = '" + DTP->DTP_FILORI + "' "
			cQuery += " AND 			DTC.DTC_LOTNFC = '" + DTP->DTP_LOTNFC + "' "
			cQuery += " AND 			DTC.D_E_L_E_T_ = ' ' "
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
			While (cAliasQry)->(!Eof())
				Aadd(aVisErr,{STR0065 + ": " + (cAliasQry)->DTC_NUMNFC + " - " + (cAliasQry)->DTC_SERNFC + " " + STR0015 + " " +  (cAliasQry)->DTC_CLIREM + " - " + (cAliasQry)->DTC_LOJREM ;
					           + " " + STR0162 + " " + (cAliasQry)->DD9_FILORI  +" - "+ (cAliasQry)->DD9_NUMPRG })
				(cAliasQry)->(DbSkip())
			EndDo
			(cAliasQry)->(DbCloseArea())
			If Len(aVisErr) > 0
				TmsMsgErr(aVisErr)
				aVisErr:= {}
				//-- Limpa marcas dos agendamentos
				//-- Analisar a inserÁ„o desta rotina antes de cada Return( .F. ) ou ( .T. ), quando utilizado TmsVerAge
				If !IsInCallStack("TMSAF76")
					TMSALimAge(StrZero(ThreadId(),20))
				EndIf
				Return( .F. )
			EndIf
		EndIf
	EndIf

	//-- Cotacao do Lote
	cFilLot := DTP->DTP_FILORI
	cLotCot := DTP->DTP_NUMCOT

	cAliasQry := GetNextAlias()
	cQuery := " SELECT		DISTINCT DC5.DC5_DOCTMS "
	cQuery += " FROM " 		+ RetSqlName("DTC") + " DTC "
	cQuery += " INNER JOIN " + RetSqlName("DC5") + " DC5 "
	cQuery += " ON 			DC5.DC5_FILIAL = '" + xFilial('DC5') + "' "
	cQuery += " AND 			DC5.DC5_SERVIC = DTC.DTC_SERVIC "
	cQuery += " AND 			DC5.DC5_DOCTMS = '3' "
	cQuery += " AND 			DC5.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE 		DTC.DTC_FILIAL = '" + xFilial('DTC') + "' "
	cQuery += " AND 			DTC.DTC_FILORI = '" + cFilOri + "' "
	cQuery += " AND 			DTC.DTC_LOTNFC = '" + cLotNfc + "' "
	cQuery += " AND 			DTC.D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
	If (cAliasQry)->(!Eof())
		Help( "" , 1 ,"TMSA20038") //Neste lote existe um servico para tipo de documento AWB, nao existe calculo de frete para este documento.
		(cAliasQry)->(DbCloseArea())
		RestArea(aAreaDTC)
		RestArea(aAreaDC5)
		//-- Limpa marcas dos agendamentos
		//-- Analisar a inserÁ„o desta rotina antes de cada Return( .F. ) ou ( .T. ), quando utilizado TmsVerAge
		If !IsInCallStack("TMSAF76")
			TMSALimAge(StrZero(ThreadId(),20))
		EndIf
		Return( .F. )
	EndIf
	(cAliasQry)->(DbCloseArea())
	RestArea(aAreaDTC)
	RestArea(aAreaDC5)

	//-- Inicializa array de pedidos bloqueados
	aPedBlq  := {}

EndIf

//-- PE utilizado para validar a execucao da rotina.
If lTM200OK
	lRet := ExecBlock("TM200OK",.F.,.F.,{If(lRecalculo,2,1)})
	If ValType(lRet) # "L"
		lRet := .T.
	EndIf
	If !lRet
		//-- Limpa marcas dos agendamentos
		//-- Analisar a inserÁ„o desta rotina antes de cada Return( .F. ) ou ( .T. ), quando utilizado TmsVerAge
		If !IsInCallStack("TMSAF76")
			TMSALimAge(StrZero(ThreadId(),20))
		EndIf
		Return( .F. )
	EndIf
EndIf

//Verifica se a viagem j· est· encerrada.
If !Empty(DTP->DTP_VIAGEM) .And. !(lValCol) .And. !( TMSChkViag( cFilOri, DTP->DTP_VIAGEM,.F.,.F.,.F.,.F.,.F.,.F.,,.F.,,@aMsgErr,,.T. ) )
	lRet := .F.
	AaddMsgErr( aMsgErr, @aVisErr)
Endif

If DTP->( SimpleLock() )
	lLotExpress := (TmsExp() .And. !Empty(DTP->DTP_VIAGEM))
	RecLock('DTP',.F.)

	If lRet .And. !(lValCol)
		Processa( {|lEnd| lRet := TmsA200Srv(@lEnd, cFilOri, cLotNfc, @aVisErr, lRecalculo ) }, cCadastro,STR0048, .F. ) //"Aguarde..."
	EndIf

	//-- Atualiza o status do lote como bloqueado
	DTP->DTP_STATUS := StrZero(4 ,Len(DTP->DTP_STATUS))

	If lRet .And. !lEnd
		Processa( {|lEnd| lRet := TmsA200NfC(@lEnd, cLotNfc, @aVisErr, @aVetDiv ) }, cCadastro,STR0010, .F. ) //'Ordenando Notas Fiscais do Cliente...'
	EndIf

	If (DTP->DTP_TIPLOT == '4')  // Tipo do Lote Igual a CTe ⁄nico
		lCTeUnico := TmsA200UNI()
		If !lCTeUnico
			If	MsgYesNo(STR0127,OemToAnsi(STR0128)) // "O lote n„o atende as necessidades para geraÁ„o do CTe ⁄nico, gerar o lote como eletrÙnico?"
				RecLock("DTP",.F.)
				DTP->DTP_TIPLOT := '3'
				MsUnLock()
			Else
   				lRet := .F.
				//-- Limpa marcas dos agendamentos
				//-- Analisar a inserÁ„o desta rotina antes de cada Return( .F. ) ou ( .T. ), quando utilizado TmsVerAge
				If !IsInCallStack("TMSAF76")
					TMSALimAge(StrZero(ThreadId(),20))
				EndIf
				Return(lRet)
			EndIf
		EndIF
	EndIF

	If lRet .And. !lEnd
		Processa( {|lEnd| lRet := TmsA2001Nf(@lEnd, cLotNfc, @aVisErr ) }, cCadastro,STR0037, .F. ) //'Ordenando Notas Fiscais do Cliente 1o percurso...'
	EndIf

	If lRet .And. !lEnd
		If !lEnd
			Processa( {|lEnd| lRet := TmsA2001Ct(@lEnd, cLotNfc, @aVisErr, @aRatTda, @lTabAlt ) }, cCadastro,STR0036, .F. ) //'Calculando Frete 1o.Percurso...'
		EndIf
	EndIf

	If	lRet .And. !lEnd
		If !lEnd
			Processa( {|lEnd| lRet := TmsA200Grv(@aVisErr, lRecalculo,,,,,,,,,lCTeUnico, aRatTda, lTabAlt) }, cCadastro,STR0045, .F. ) //'Gerando Documentos de 1o. percurso...'
		EndIf
	EndIf

	If lRet .And. !lEnd
		If !lEnd
			Processa( {|lEnd| lRet := TmsA200Ctr(@lEnd, cLotNfc, @aVisErr, cFilLot, cLotCot, @aRatTda, @lTabAlt ) }, cCadastro,STR0012, .F. ) //'Calculando Frete...'
		EndIf
	EndIf

	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±Verifica quantidade de CTRC's que ser„o gerados.±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	*/
	If lRet
		If lTM200CTR

			nNumCTRC := 0

			For nCntFor := 1 To Len( aDocto )
				aProduto:= {}
				aNfCTRC := {}
				cTipTra := aDocto[nCntFor,10,22]
				cNumCot := aDocto[nCntFor,8]
				nNfCTRC := aDocto[nCntFor,10,1]
				nPesCTR := aDocto[nCntFor,10,2]


				For n1Cnt := 1 To Len(aDocto[nCntFor,9])
					nValFre := 0
					nPeso   += aDocto[nCntFor,9,n1Cnt,6]
					lUltimo	:= (n1Cnt == Len(aDocto[nCntFor,9]))
					cCodPro	:= aDocto[nCntFor,9,n1Cnt,1]
					cNextPro := IIf(n1Cnt < Len(aDocto[nCntFor,9]), aDocto[nCntFor,9,n1Cnt+1,1], aDocto[nCntFor,9,n1Cnt,1])

					//-- Composicao do frete
					//-- Aglutino a composicao de frete de cada produto no vetor a frete
					For n2Cnt := 1 To Len(aDocto[nCntFor,9,n1Cnt,2])
						//-- Somente componentes diferente de zero e diferente da linha totalizadora. TF = Total Frete
						If	aDocto[nCntFor,9,n1Cnt,2,n2Cnt,3] != 'TF'
							//--Se for Internacional nao pode desprezar os itens zerados, precisa ser gravado
							If (aDocto[nCntFor,9,n1Cnt,2,n2Cnt,2] > 0 ) .Or. (aDocto[nCntFor,9,n1Cnt,2,n2Cnt,2] == 0 .And. ("TMSAI70" $ AllTrim(FunName())) )
								nSeek := ASCan(aFrete,{|x|x[3]==aDocto[nCntFor,9,n1Cnt,2,n2Cnt,3]})
								If Empty(nSeek)
									AAdd(aFrete,AClone(aDocto[nCntFor,9,n1Cnt,2,n2Cnt]))
									nValFre += aDocto[nCntFor,9,n1Cnt,2,n2Cnt,2]
								Else
									lTaxa := TMSAComTax(aFrete[nSeek,3])
									//-- Taxa por documento 1=Sim, todos os documentos serao taxados
									//-- Taxa por documento 2=Nao, somente o ultimo documento sera taxado, Soma do valor do frete se no ultimo item do array
									If	lTaxa .And. cTaxCtr == StrZero(1,Len(DUO->DUO_TAXCTR))
										aFrete[nSeek,2] := aDocto[nCntFor,9,n1Cnt,2,n2Cnt,2]
										aFrete[nSeek,5] := aDocto[nCntFor,9,n1Cnt,2,n2Cnt,5]
										aFrete[nSeek,6] := aDocto[nCntFor,9,n1Cnt,2,n2Cnt,6]
									ElseIf !lTaxa .Or. (cTaxCtr == StrZero(2,Len(DUO->DUO_TAXCTR)) .And. lUltimo .And. (n2Cnt == Len(aDocto[nCntFor,9,n1Cnt,2])))
										aFrete[nSeek,2] += aDocto[nCntFor,9,n1Cnt,2,n2Cnt,2]
										aFrete[nSeek,5] += aDocto[nCntFor,9,n1Cnt,2,n2Cnt,5]
										aFrete[nSeek,6] += aDocto[nCntFor,9,n1Cnt,2,n2Cnt,6]
									EndIf
									nValFre += aDocto[nCntFor,9,n1Cnt,2,n2Cnt,2]
								EndIf
							EndIf
						EndIf
					Next

					AAdd(aProduto,{cCodPro,AClone(aDocto[nCntFor,9,n1Cnt,2]),{}})

					//-- Notas fiscais do cliente
					For n2Cnt := 1 To Len(aDocto[nCntFor,9,n1Cnt,3])
						cNumNfc	:= aDocto[nCntFor,9,n1Cnt,3,n2Cnt,1]
						cSerNfc	:= aDocto[nCntFor,9,n1Cnt,3,n2Cnt,2]
						lAddNfc	:= .T.
						//-- Adiciona a nota fiscal do cliente apenas 1 vez no vetor aNfCTRC
						If	n1Cnt+1 <= Len(aDocto[nCntFor,9])
							For n3Cnt := n1Cnt+1 To Len(aDocto[nCntFor,9])
								If AScan(aDocto[nCntFor,9,n3Cnt,3],{|x|x[1]+x[2]==cNumNfc+cSerNfc})>0
									lAddNfc := .F.
									Exit
								EndIf
							Next
						EndIf
						If lAddNfc
							AAdd(aNfCTRC,{cNumNfc,cSerNfc})
						EndIf
						AAdd(aProduto[Len(aProduto),3],{cNumNfc,cSerNfc})
					Next

					If TmsA200Qb1(	aDocto[nCntFor,9],;
									aDocto[nCntFor,10,39],;
									aDocto[nCntFor,10,37],;
									aDocto[nCntFor,10,38],;
									Iif(cTipTra == '4',Replicate('z',Len(DT4->DT4_NUMCOT)),cNumCot),;
									n1Cnt,;
									Len(aNfCTRC),;
									nPeso,;
									nNfCTRC,;
									nPesCTR,;
									lUltimo,;
									cCodPro,;
									cNextPro,;
									aDocto )


						nNumCTRC++

					EndIf

					aFrete   := {}
					aNfCTRC  := {}
					aProduto := {}
					nPeso    := 0
					aFreteCol:= {}

				Next
			Next

			//--Processa o ponto de entrada
			aRet := ExecBlock("TM200CTR",.F.,.F.,{ nNumCTRC })
			If ValType(aRet) == "A" .And. Len( aRet ) == 2
				If ValType( aRet[1] ) == "L" .And. !aRet[1]
					lRet := aRet[1]
					If ValType( aRet[2] ) == "A"

						If Len(aRet[2]) == 2
							AaddMsgErr( aRet[2], @aVisErr)
						EndIf

						If Empty( aVisErr )
							AaddMsgErr( {{ STR0178 }}, @aVisErr) //-- BLOQUEADO PELO PONTO DE ENTRADA TM200CTR
						EndIf

					EndIf
				EndIf
			EndIf

		EndIf //lTM200CTR
	EndIf //lRet

	/*
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±Final da verificacao da quantidade de CTRC's que ser„o gerados. ±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	*/
	If	lRet .And. !lEnd
		If !lEnd
			Processa( {|lEnd| lRet := TmsA200Grv(@aVisErr, lRecalculo,,,,,,,,,lCTeUnico, aRatTda, lTabAlt,@lBlq) }, cCadastro,STR0046, .F. ) //"Gerando documentos..."
		EndIf
	EndIf

	Begin Transaction
		If lRet .And. !lEnd
			If Len(aVisErr) > 0 .And. TmsaExCd1P(DTP->(Recno()))
				MsgAlert(STR0165) //"Houve erros durante a geracao do CTRC de segundo percurso. Devido a este problema, o CTRC do primeiro percurso ser· excluido."
				cFilOri	:= DTP->DTP_FILORI
				cLotNfc	:= DTP->DTP_LOTNFC
				cMark		:= GetMark()
				TmsA200Cmp(, aDelDocto, .T., .T., , , , , , , , , @aErrEst)
				Processa( {|lEnd| lRet := TMSA200Exc( aDelDocto, cLotNfc, @lEnd, @lDocto,, .T.,.T. ) }, cCadastro,STR0166, .F. ) //"Excluindo CTRC do primeiro percurso..."
			EndIf

			//-- Se encontrou algum erro no calculo deixa o Lote com Status = 4-'Bloqueado'
			Processa( {|lEnd| lRet := TmsA200Sta(@lEnd, cLotNfc, StrZero(Iif(Empty(aPedBlq) .And. Empty(aVisErr) .AND. !lBlq, 3, 4), Len(DTP->DTP_STATUS))) }, cCadastro,STR0013, .F. ) //'Atualizando Status do Lote...'
		EndIf
	End Transaction

	//-- Exibe pedidos com bloqueio de credito
	//-- Se encontrou algum erro no calculo deixa o Lote com Status  'Bloqueado'
	If	!Empty( aPedBlq )
		TMSC010( aPedBlq )
		lRet := .F.

		//-- Alerta para quando chamada do calculo for via Painel do Agendamento e o calculo e realizado na inclus„o da viagem.
		If IsInCallStack("TMSF76Via") .And. IsInCallStack("TMSA144grv")

               Aviso(STR0181, STR0180 ,{"&OK"},2) //-- AtenÁ„o # 'H· Documentos bloqueados por an·lise de crÈditos. Solicite liberaÁ„o ao departamento Financeiro. ApÛs liberaÁ„o inclua-os em nova viagem.'

		EndIf
	EndIf
	RestArea(aAreaDTP)

	//-- Se encontrou algum erro no calculo deixa o Lote com Status  'Bloqueado'
	If	Len( aVisErr ) > 0
		TmsMsgErr( aVisErr )
		lRet := .F.
	EndIf

Else
	Help(' ', 1, 'TMSA20027')	//"Lote sendo utilizado por outro usu·rio"
	lRet := .F.
EndIf

//-- Transmite Ct-e apos calculo
If lRet .And. !lSelLote
	lRet := TMSA200Tra(lLotExpress,cFilAnt,cLotNfc,nTotDoc,nTotnTran,aMsgErr,aVisErr,"TMSA200")
EndIf

//--Desbloqueia solicitaÁ„o de coleta e gera documento de coleta(DT6), implementaÁ„o realizada para Cargolift.
//--verificar posteriormente a necessidade de implementar fora do painel de agendamento.
If  IsInCallStack("TMSAF76") .And. lRet .And. lRecalculo .And. Empty( aPedBlq )
     TMSA200GDC(DTP->DTP_FILORI,DTP->DTP_LOTNFC)
EndIf

RestArea(aAreaDTP)

If lTM200PRC
	ExecBlock("TM200PRC",.F.,.F.,{cFilOri, cLotNfc, lRet, lRecalculo, (lRTMSR01 .Or. lRTMSR17) })
EndIf

lImpDoc := .F.
/////////////////////////////////////////////////////////////////////
// Caso exista o relatorio de impressao de CTRC ou CRT chama no    //
// final do processo.                                              //
// Rotina so executara processo de impressao caso o lote nao seja  //
// do tipo "3" - Eletronico.                                       //
/////////////////////////////////////////////////////////////////////
If lRet .And. lImpDoc

	If ( (lRTMSR01 .Or. lRTMSR17) .And. (DTP->DTP_TIPLOT <> StrZero(3,Len(DTP->DTP_TIPLOT))) .And. (DTP->DTP_TIPLOT <> StrZero(4,Len(DTP->DTP_TIPLOT))) )
		If DTP->DTP_LOTNFC != cLotNfc
			DTP->(MsSeek( xFilial('DTP')  + cFilOri + cLotNfc, .F. ) )
		EndIf
		Tmsa200Imp(,,,,.F.)
	EndIf
EndIf

//-- Limpa marcas dos agendamentos
If !IsInCallStack("TMSAF76")
	TMSALimAge(StrZero(ThreadId(),20))
EndIf

//-- Limpa vari·veis est·ticas
A200ClrVar()

ResetArr(@aFrete)
ResetArr(@aProduto)
ResetArr(@aNfCTRC)
ResetArr(@aDUMVlrs)
ResetArr(@aVetDiv)
ResetArr(@aRatTDA)
ResetArr(@aFreteCol)

RestArea(aAreaDTP)
RestArea(aAreaAnt)

Return( lRet )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200NfC≥ Autor ≥ Alex Egydio           ≥ Data ≥06.02.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Ordena as notas fiscais do cliente                         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA200NfC()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpL1 = Cancela processamento                              ≥±±
±±≥          ≥ ExpC1 = Numero do lote                                     ≥±±
±±≥          ≥ ExpA1 = Array contendo as Mensagens de Erro                ≥±±
±±≥          ≥ ExpA2 = Array contendo as Divergencias de Produtos (ONU)   ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TMSA200NfC( lEnd, cLotNfc, aVisErr, aVetDiv )

Local aAreaAnt		:= GetArea()
Local aAreaDC5		:= DC5->( GetArea() )
Local aAreaDTC		:= DTC->( GetArea() )
Local aAreaSB1		:= SB1->( GetArea() )
Local aContrt		:= {}
Local cSeek			:= ''
Local cCliAgr		:= ''
Local cLojAgr		:= ''
Local cCPAGPV		:= ''
Local cDocTms		:= ''
Local cSerTms		:= ''
Local cTipTra		:= ''
Local cSerie		:= ''
Local cPaisDes	:= ''
Local cSerieOLD		:= ''
Local cCodPro		:= Space(Len(SB1->B1_COD))
Local cCodProOld	:= ''
Local cCliCal		:= ''
Local cLojCal		:= ''
Local cTipFre		:= ''
Local cDocPE		:= ''
Local cFilPE		:= ''
Local lRet			:= .T.
Local nNfCTRC		:= 0
Local nDocTms		:= Len( DC5->DC5_DOCTMS )
Local nX			:= 0
Local cAliasDTC		:= "DTC"
Local lQuery		:= .F.
Local cQuery		:= ""
Local cCampos		:= ""
Local aStruDTC		:= {}
Local cFilSX5		:= xFilial("SX5")
Local cTipNfc		:= '0'
Local nNfCTRCPE		:= 0
Local lAgdEntr		:= Iif(FindFunction("TMSA018Agd"),TMSA018Agd(),.F.)   //-- Agendamento de Entrega.
Local cFilDes		:= ''
Local lExped 		:= DTC->(ColumnPos("DTC_CLIEXP")) > 0
Local lRecebedor    := DTC->(ColumnPos("DTC_CLIREC")) > 0
Local lIdentDoc  	:= DTC->(ColumnPos("DTC_DOCTMS")) > 0
Local lRetira       := DTC->(ColumnPos("DTC_RETIRA")) > 0
Local aPerfil		:= {}

DEFAULT lEnd		:= .F.
DEFAULT cLotNfc		:= ''

lValCol   := DTP->DTP_TIPLOT == StrZero(5,Len(DTP->DTP_TIPLOT))

If	cMv_Estado == ""
	cMv_Estado := SuperGetMV("MV_ESTADO",.F.,"")
EndIf

//-- Adiciona um filtro na query de selecao de Notas Fiscais do Cliente.
If lTm200Fil
	cRet := ExecBlock("TM200FIL",.F.,.F.)
EndIf

ResetArr(@aLote )
ResetArr(@aNFTipVei )
aLote     := {}
aNFTipVei := {}

If !lValCol

	ProcRegua(DTC->(LastRec()))

	DTC->(DbSetOrder(1)) //DTC_FILIAL+DTC_FILORI+DTC_CLIREM+DTC_LOJREM+DTC_CLIDES+DTC_LOJDES+DTC_SERVIC+DTC_CODPRO+DTC_NUMNFC+DTC_SERNFC+DTC_NUMSOL
	cSeek := xFilial('DTC') + cFilAnt + cLotNfc

	aStruDTC  := DTC->(dbStruct())
	lQuery    := .T.
	cAliasDTC := GetNextAlias()
	cCampos := "DTC_FILIAL, DTC_FILORI, DTC_FILDPC, DTC_FILCFS, DTC_LOTNFC, DTC_NUMNFC, DTC_TIPNFC, DTC_SERNFC, DTC_NUMCOT, DTC_NUMSOL, DTC_DOC,    DTC_SERIE,  "
	cCampos += "DTC_CLIREM, DTC_LOJREM, DTC_CLIDES, DTC_LOJDES, DTC_CLIDEV, DTC_LOJDEV, DTC_CLICAL, DTC_LOJCAL, DTC_CLICON, DTC_LOJCON, DTC_CLIDPC, DTC_LOJDPC, "
	cCampos += "DTC_SERTMS, DTC_SERVIC, DTC_TIPNFC, DTC_TIPTRA, DTC_DEVFRE, DTC_TIPFRE, DTC_CDRDES, DTC_CDRCAL, DTC_CDRORI, DTC_CDRPER, DTC_SQEDES, DTC_SQICON, "
	cCampos += "DTC_SQIDES, DTC_SQIDPC, DTC_SQIREM, DTC_CTRDPC, DTC_CODPRO, DTC_BASSEG, DTC_KM,     DTC_METRO3, DTC_PESO,   DTC_PESOM3, DTC_QTDUNI, DTC_QTDVOL, "
	cCampos += "DTC_VALDPC, DTC_VALOR,  DTC_NFEID,  DTC_CTEANT, DTC_VLRINF, R_E_C_N_O_  DTC_RECNO  "
	cCampos += ", DTC_RECISS"
	cCampos += ", DTC_PESLIQ"
	cCampos += ", DTC_MOEDA"
	cCampos += ", DTC_MOENFC"
	cCampos += ", DTC_EXCTDA"
	If lAgdEntr
		cCampos += ",DTC_DATAGD, DTC_NUMAGD, DTC_ITEAGD  "
	EndIf
	If lIdentDoc
		cCampos += ", DTC_DOCTMS"
	EndIf
	If lExped
		cCampos += ",DTC_CLIEXP, DTC_LOJEXP  "
	EndIf
	If lRecebedor
	    cCampos += ",DTC_CLIREC, DTC_LOJREC "
	EndIf
	If lRetira
		 cCampos += ",DTC_RETIRA"
	EndIf
	cCampos += ", DTC_CODNEG"

	cQuery := " SELECT " + cCampos
	cQuery += " FROM "  + RetSqlName("DTC") + " DTC "
	cQuery += " WHERE DTC_FILIAL = '" + xFilial("DTC") + "'"
	cQuery += "   AND DTC_FILORI = '" + cFilAnt + "'"
	cQuery += "   AND DTC_LOTNFC = '" + cLotNfc + "'"
	cQuery += "   AND DTC_DOC    = ' '" //-- Desconsidera documentos ja calculados
	cQuery += "   AND DTC_SERIE <> 'PED'"
	cQuery += "   AND D_E_L_E_T_ = ' '"
	If lTm200Fil .And. ValType(cRet) == "C" .And. !Empty(cRet)
		cQuery += cRet
	EndIf

	cQuery += " ORDER BY DTC_FILIAL,DTC_FILORI,DTC_CLIREM,DTC_LOJREM,DTC_CLIDES,DTC_LOJDES,DTC_CODNEG,DTC_SERVIC,DTC_CODPRO,DTC_NUMNFC,DTC_SERNFC,DTC_NUMSOL"

Else

	ProcRegua(DT5->(LastRec()))

	DT5->(DbSetOrder(7)) //-- DT5_FILIAL+DT5_NCONTR+DT5_CODNEG+DT5_SERVIC

	cSeek 	   := FWxFilial('DT5') + cFilAnt + cLotNfc
	aStruDTC  := DTC->(dbStruct())
	lQuery    := .T.
	cAliasDTC := GetNextAlias()
	cQuery    := Tmsa200Qry( cLotNfc , Iif( lTm200Fil .And. ValType(cRet) == "C" .And. !Empty(cRet), cRet , "" ))

EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDTC)
If lAgdEntr
	TcSetField(cAliasDTC,"DTC_DATAGD","D",8,0)
EndIf

For nX := 1 To Len(aStruDTC)
	If aStruDTC[nX][2]<>"C" .And. aStruDTC[nX][1] $ cCampos
		TcSetField(cAliasDTC,aStruDTC[nX][1],aStruDTC[nX][2],aStruDTC[nX][3],aStruDTC[nX][4])
	EndIf
Next nX

While (cAliasDTC)->( !Eof() .And. (cAliasDTC)->DTC_FILIAL + (cAliasDTC)->DTC_FILORI + (cAliasDTC)->DTC_LOTNFC == cSeek  .And. !lEnd )

	IncProc()

	cCPAGPV	:= ''
	cCliAgr	:= ''
	cLojAgr	:= ''
	cCliCal	:= (cAliasDTC)->DTC_CLICAL
	cLojCal	:= (cAliasDTC)->DTC_LOJCAL
	cTipFre	:= (cAliasDTC)->DTC_TIPFRE
	//-- Se este campo estiver zerado, sera considerado uma nota por conhecimento
	nNfCTRC	:= 0

	//-- Se houver nr. de solicitacao de frete nao sera necessario verificar o cliagr
	If	Empty( (cAliasDTC)->DTC_NUMCOT )

		//-- Posiciona no perfil do cliente remetente, para obter o cliente agrupamento.
		aPerfil := TmsPerfil( (cAliasDTC)->DTC_CLIREM, (cAliasDTC)->DTC_LOJREM )

		If !Empty( aPerfil )
			cCliAgr	:= aPerfil[ 1 ]
			cLojAgr	:= aPerfil[ 2 ]
		Else
			//-- Nao continua o processamento, se nao encontrou perfil para o Cliente Remetente...
			//-- A funcao TmsPerfil() exibe o Help na Tela
			lRet := .F.
			Exit
		EndIf

	EndIf

	If Empty( cCliAgr )
		cCliAgr	:= (cAliasDTC)->DTC_CLIREM
		cLojAgr	:= (cAliasDTC)->DTC_LOJREM
	EndIf

	//-- Posiciona no servico
	DC5->(DbSetOrder(1)) //DC5_FILIAL+DC5_SERVIC+DC5_ORDEM
	If	DC5->(!MsSeek( xFilial("DC5")+(cAliasDTC)->DTC_SERVIC, .F.))
		Help( ' ', 1, 'TMSA20007',,STR0018 + (cAliasDTC)->DTC_CODNEG + "/" + (cAliasDTC)->DTC_SERVIC,5,11)	//"Servico nao encontrado (DC5)"###" Servico : "
		lRet := .F.
		Exit
	EndIf

	//-- A entrada de nota fiscal do cliente sera '0 Normal' ou '1 Devolucao Parcial' conforme o campo DTC_TIPNFC
	cTipNfc := (cAliasDTC)->DTC_TIPNFC
	If	cTipNfc == StrZero(1,Len(cTipNfc))
		cDocTms := StrZero(6,nDocTms)
	ElseIf lIdentDoc .And. Empty(DC5->DC5_DOCTMS)
		cDocTms := (cAliasDTC)->DTC_DOCTMS
	Else
		cDocTms := DC5->DC5_DOCTMS
		If Empty(cTipNfc)
			cTipNfc := StrZero(0,Len(cTipNfc))
		EndIf
	EndIf
	cSerTms := DC5->DC5_SERTMS
	cTipTra := DC5->DC5_TIPTRA

	If lTM200DOC
		cDocPE := ExecBlock("TM200DOC",.F.,.F.,{cDocTms,(cAliasDTC)->DTC_CDRORI, (cAliasDTC)->DTC_CDRDES, (cAliasDTC)->DTC_CDRCAL })
		If Valtype(cDocPE) == "C" .And. !Empty(cDocPE)
			cDocTms := cDocPE
		EndIf
	EndIf

	//-- Devolucao. Inverte o tipo de frete para pesquisar o contrato utilizado na geracao do documento original
	If	cDocTms == StrZero(6,nDocTms)
		If	cTipFre == StrZero(1,Len(cTipFre))
			cTipFre := StrZero(2,Len(cTipFre))
		Else
			cTipFre := StrZero(1,Len(cTipFre))
		EndIf
	EndIf
	aContrt := TMSContrat( cCliCal, cLojCal,, (cAliasDTC)->DTC_SERVIC, .F., cTipFre,,,(cAliasDTC)->DTC_CLIREM,(cAliasDTC)->DTC_LOJREM,(cAliasDTC)->DTC_CLIDES,(cAliasDTC)->DTC_LOJDES,,(cAliasDTC)->DTC_CLIDEV,(cAliasDTC)->DTC_LOJDEV,(cAliasDTC)->DTC_TIPNFC,,,,,,(cAliasDTC)->DTC_CODNEG)
	If Empty( aContrt )
		Help( ' ', 1, 'TMSA20005',,STR0015 + cCliCal + ' / ' + cLojCal + ' / ' + STR0049 + TmsRetCbx('AAM_TIPFRE',cTipFre),5,11) //"Contrato nao encontrado (AAM)"###"Cliente : "###"Tp.Frete: "
		lRet := .F.
		Exit
	EndIf

	//-- Se nao encontrou a tabela de frete
	If	Empty((cAliasDTC)->DTC_NUMCOT) .And. Empty( aContrt[ 1, 3 ] )
		//-- Servico ou Tabela de Frete nao especificada no contrato (DUX)
		Help('',1,'TMSA20022',,;
		STR0040 + Iif( aContrt[ 1, 17 ], STR0041, STR0042 + cCliCal +'/'+ cLojCal ) + CRLF +;
		STR0017 + aContrt[1,1]				+ CRLF +;
		STR0018 + (cAliasDTC)->DTC_CODNEG + "/" + (cAliasDTC)->DTC_SERVIC	+ CRLF +;
		STR0049 + TmsRetCbx('AAM_TIPFRE',cTipFre),4,1) //"Tabela de frete n„o especificada no contrato (AAP)"
		lRet := .F.
		Exit
	EndIf

	nNfCTRC := aContrt[ 1, 8 ]

	If lTM200NFC
		nNfCTRCPE := ExecBlock("TM200NFC",.F.,.F.,{	(cAliasDTC)->DTC_NUMNFC,(cAliasDTC)->DTC_SERNFC,(cAliasDTC)->DTC_CLIREM,(cAliasDTC)->DTC_LOJREM,(cAliasDTC)->DTC_CLIDES,(cAliasDTC)->DTC_LOJDES, ;
														(cAliasDTC)->DTC_CLIDEV,(cAliasDTC)->DTC_LOJDEV,(cAliasDTC)->DTC_CLICON,(cAliasDTC)->DTC_LOJCON,(cAliasDTC)->DTC_CLIDPC,(cAliasDTC)->DTC_LOJDPC, ;
														(cAliasDTC)->DTC_SERTMS,(cAliasDTC)->DTC_SERVIC,(cAliasDTC)->DTC_CODNEG })
		If Valtype(nNfCTRCPE) == "N" .And. nNfCTRCPE > 0
			nNfCTRC := nNfCTRCPE
		EndIf
	EndIf

	cCPAGPV	:= aContrt[ 1, 9 ]

	If lTM200Cpg //PE permite alterar a condicao de pagamento
		cCPAGPV:= ExecBlock("TM200CPG",.F.,.F.,{cCliCal,cLojCal,cCPAGPV,(cAliasDTC)->DTC_SERVIC,(cAliasDTC)->DTC_CODNEG})
		SE4->( DbSetOrder( 1 ) )
		If ValType(cCPAGPV) <> "C" .Or. SE4->(!MsSeek(xFilial('SE4') + cCPAGPV, .F.))
			cCPAGPV := aContrt[ 1, 9 ]
		Endif
	Endif

	//-- Verifica se foi informado a condicao de pagamento utilizada no pedido de venda.
	If	Empty( cCPAGPV )
		Help( ' ', 1, 'TMSA20006',,STR0015 + cCliCal + ' / ' + cLojCal + STR0016 + aContrt[1,1] + ' / ' + STR0049 + TmsRetCbx('AAM_TIPFRE',cTipFre),5,11)	//-- Condicao de pagamento do cliente nao foi especificada no contrato (AAM). //'Cliente : '###' Contrato : '
		lRet := .F.
		Exit
	EndIf

	//-- N„o Executa ValidaÁıes Se For ValorizaÁ„o Da Coleta
	If !lValCol

		//-- Estamos calculando documentos de transporte tipo: CTRC/CTRC Devolucao/CTRC Cortesia/NOTA FISCAL
		//-- Se nao encontrar nenhum documento sera apresentado o help TMSA20008
		If	 cDocTms == StrZero( 1, nDocTms ) .Or. cDocTms == StrZero( 4, nDocTms ) //-- Coleta ou Baixa de Estoque
			Help( ' ', 1, 'TMSA20008',,STR0018 + (cAliasDTC)->DTC_CODNEG + "/" + (cAliasDTC)->DTC_SERVIC,5,11) //"Documento de transporte tipo CTRC nao encontrado.###"Servico :"
			lRet := .F.
			Exit
		EndIf

		//-- Posiciona configuracao de documentos para obter a Serie do Documento.
		DUI->(DbSetOrder(1)) //DUI_FILIAL+DUI_DOCTMS
		If	DUI->(!MsSeek(xFilial('DUI') + cDocTms, .F.))
			Help( ' ', 1, 'TMSA20009',,STR0038 + cDocTms,5,1)	//"Documento nao encontrado na configuracao de documentos (DUI)"###"Documento :"
			lRet := .F.
			Exit
		EndIf

		cSerie := DUI->DUI_SERIE
		cCodPro:= DUI->DUI_CODPRO

		//-- Verifica se informou serie para origem em outra filial.
		If	!Empty(DUI->DUI_SEROUT)
			TMSA200CdRg((cAliasDTC)->DTC_CDRORI)   //Posiciona no grupo de Regiao
			If	cMv_Estado <> DUY->DUY_EST
				cSerie := DUI->DUI_SEROUT
			EndIf
		EndIf

		//-- Permite alterar o Produto de Imposto
		If lTM200PRD
			cCodProOld := ExecBlock("TM200PRD",.F.,.F.,{cCodPro,cDocTms, ((cAliasDTC)->DTC_CDRORI), ((cAliasDTC)->DTC_CDRDES), ((cAliasDTC)->DTC_CDRCAL), ((cAliasDTC)->DTC_RECNO)})
			If Valtype(cCodProOld) == "C" .And. !Empty(cCodProOld)
				cCodPro := cCodProOld
			EndIf
		EndIf

		If cTipTra == StrZero(4,Len(DC5->DC5_TIPTRA)) //-- Rodoviario Internacional
			cFilOri := (cAliasDTC)->DTC_FILORI
			TMSA200CdRg((cAliasDTC)->DTC_CDRCAL)   //Posiciona no grupo de Regiao
			cFilDes := DUY->DUY_FILDES
			cPaisDes := DUY->DUY_PAIS
			//--Procuro por Regiao de Calculo, depois Regiao de Destino, e por ultimo sem Regiao
			DI0->(DbSetOrder(1))
			If DI0->(!MsSeek(xFilial("DI0")+cFilOri+cFilDes+cPaisDes))
				TMSA200CdRg((cAliasDTC)->DTC_CDRDES)   //Posiciona no grupo de Regiao
				cFilDes := DUY->DUY_FILDES
				cPaisDes := DUY->DUY_PAIS
				If DI0->(!MsSeek(xFilial("DI0")+cFilOri+cFilDes+cPaisDes))
					If DI0->(!MsSeek(xFilial("DI0")+cFilOri+Space(Len(DI0->DI0_FILDES))+cPaisDes)) //Busca sem a Filial de Destino, pois existem permissos desta forma
						//-- "Permisso n„o localizado para a filial de origem: "
						MsgAlert(STR0071+cFilOri)
						lRet := .F.
						Exit
					EndIf
				EndIf
			EndIf
			cSerie := DI0->DI0_SERIE
		Else
			//--Utiliza SUB SERIE no Conhecimento
			If DC5->DC5_UTSUBS == StrZero(1, Len(DC5->DC5_UTSUBS)) .AND. !Empty(DUI->DUI_SUBSER)
				cSerie := DUI->DUI_SUBSER
			EndIf
		EndIf

		//-- Permite a troca da Serie do Documento de Transporte.
		If lTM200SER
			cSerieOld := ExecBlock("TM200SER",.F.,.F.,{cCliCal,cLojCal,cDocTms})
			If Valtype(cSerieOld) == "C" .And. !Empty(cSerieOld)
				cSerie := cSerieOld
			EndIf
		EndIf

		//-- Permite utilizar uma Tabela 01 exclusiva em um SX5 compartilhado.
		If lCHGSX5FIL
			cFilPE := ExecBlock("CHGX5FIL",.F.,.F.)
			If Valtype(cFilPE) == "C"
				cFilSX5 := cFilPE
			EndIf
		EndIf

		//--Tratamento para considerar os espacos, tanto da configuracao de documentos como vindo do ponto de entrada
		cSerie := Padr(cSerie,Len(DUI->DUI_SERIE))
		//-- Verifica se a serie esta cadastrada na tabela 01 - Series de notas fiscais.
		SX5->(DbSetOrder(1)) //X5_FILIAL+X5_TABELA+X5_CHAVE
		If	SX5->(!MsSeek( cFilSX5 + '01' + cSerie, .F.))
			Help( ' ', 1, 'TMSA20020',,STR0029 + cSerie,5,1)	//-- Serie nao encontrada na tabela 01 - Serie de N. Fiscais. (SX5)###"Serie :"
			lRet := .F.
			Exit
		EndIf

		//-- Este produto sera gravado no SD2 para calculo de impostos de transporte
		If Empty( cCodPro )
			Help( ' ', 1, 'TMSA20010',,STR0038 + cDocTms,5,1)	//-- Produto para calculo de impostos nao informado na configuracao de documentos (DUI)###"Documento :"
			lRet := .F.
			Exit
		EndIf

		//-- Posiciona o produto.
		SB1->(DbSetOrder(1)) //B1_FILIAL+B1_COD
		If	SB1->(!MsSeek(xFilial('SB1') + cCodPro, .F.))
			Help( ' ', 1, 'TMSA20011',,STR0021 + cCodPro,5,11)		//-- Produto nao encontrado (SB1). //'Produto : '
			lRet := .F.
			Exit
		EndIf
	EndIf

	//-- Se este campo estiver zerado, sera considerado uma nota por conhecimento
	nNfCTRC := Iif( nNfCTRC == 0, 1, nNfCTRC )

	//-- Define o vetor aLote
	TmsA200Lot(aContrt,,cCliCal,cLojCal,cCliAgr,cLojAgr,cDocTms,cSerie,cSerTms,cTipTra,cCPAGPV,cCodPro,'2',,nNfCTRC,cAliasDTC,cTipNfc,@aVetDiv)

	If !lRet
		Exit
	EndIf

	(cAliasDTC)->( DbSkip() )

EndDo

If lQuery
	DbSelectArea(cAliasDTC)
	dbCloseArea()
EndIf

RestArea( aAreaDC5 )
RestArea( aAreaDTC )
RestArea( aAreaSB1 )
RestArea( aAreaAnt )

Return( lRet )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA2001Nf≥ Autor ≥ Alex Egydio           ≥ Data ≥10.07.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Ordena as notas fiscais do cliente 1o percurso             ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA2001Nf()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpL1 = Cancela processamento                              ≥±±
±±≥          ≥ ExpC1 = Numero do lote                                     ≥±±
±±≥          ≥ ExpA1 = Array contendo as Mensagens de Erro                ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TMSA2001Nf( lEnd, cLotNfc, aVisErr )

Local aAreaAnt	:= GetArea()
Local aContrt	:= {}
Local cCPAGPV	:= ''
Local cDocTms	:= ''
Local cCliente	:= ''
Local cLoja		:= ''
Local lRet		:= .T.
Local nNfCTRC	:= 0
Local nCntFor	:= 0
Local nNfCTRCPE	:= 0

DEFAULT lEnd	:= .F.
DEFAULT cLotNfc	:= ''

ResetArr(@aNFTipVei )
aNFTipVei := {}

ProcRegua( Len( aLote ) )

For nCntFor := 1 To Len( aLote )

	IncProc()

	If	lEnd
		lRet := .F.
		Exit
	EndIf
	//-- Trata apenas notas com servico de 1o percurso
	If !TMSSegPerc(aLote[ nCntFor, LTSERVIC ])
		Loop
	EndIf

	cCPAGPV := ''
	cCliente:= aLote[ nCntFor, LTCLIREM ]
	cLoja   := aLote[ nCntFor, LTLOJREM ]
	cDocTms := aLote[ nCntFor, LTDOCTMS ]
	//-- Se este campo estiver zerado, sera considerado uma nota por conhecimento
	nNfCTRC := 0
	//-- Posiciona no contrato do cliente.
	aContrt := TMSContrat( cCliente, cLoja,, aLote[ nCntFor, LTSERVIC ], .F., StrZero(1,Len(DTC->DTC_TIPFRE)),,,aLote[nCntFor,LTCLIREM],aLote[nCntFor,LTLOJREM],aLote[nCntFor,LTCLIDES],aLote[nCntFor,LTLOJDES],,aLote[nCntFor,LTCLIDEV],aLote[nCntFor,LTLOJDEV],aLote[nCntFor,LTTIPNFC],,,,,,aLote[nCntFor,LTCODNEG])
	If Empty( aContrt )
		Help( ' ', 1, 'TMSA20005',,STR0015 + cCliente + ' / ' + cLoja,5,11)			//-- Contrato nao encontrado (AAM). //'Cliente : '
		lRet := .F.
		Exit
	EndIf
	//-- Se nao encontrou a tabela de frete.
	If	Empty(aLote[nCntFor,LTNUMCOT]) .And. Empty( aContrt[ 1, 3 ] )
		//-- Servico ou Tabela de Frete nao especificada no contrato (DUX)
		Help('',1,'TMSA20022',,;
		STR0040 + Iif( aContrt[ 1, 17 ], STR0041, STR0042 + cCliente +'/'+ cLoja ) + CRLF +;
		STR0017 + aContrt[1,1]				+ CRLF +;
		STR0018 + aLote[nCntFor,LTCODNEG] + "/" + aLote[nCntFor,LTSERVIC]	+ CRLF +;
		STR0049 + TmsRetCbx('AAM_TIPFRE',StrZero(1,Len(DTC->DTC_TIPFRE))),4,1)
		lRet := .F.
		Exit
	EndIf

	nNfCTRC := aContrt[ 1, 8 ]

	If lTM200NFC
		nNfCTRCPE := ExecBlock("TM200NFC",.F.,.F.,{	aLote[ nCntFor, LTNUMNFC ], aLote[ nCntFor, LTSERNFC ], aLote[ nCntFor, LTCLIREM ], aLote[ nCntFor, LTLOJREM ], aLote[ nCntFor, LTCLIDES ], ;
													aLote[ nCntFor, LTLOJDES ], aLote[ nCntFor, LTCLIDEV ], aLote[ nCntFor, LTLOJDEV ], aLote[ nCntFor, LTCLICON ], aLote[ nCntFor, LTLOJCON ], ;
													aLote[ nCntFor, LTCLIDPC ], aLote[ nCntFor, LTLOJDPC ], aLote[ nCntFor, LTSERTMS ], aLote[ nCntFor, LTSERVIC ], aLote[ nCntFor, LTCODNEG ], ;
													aLote[ nCntFor, LTCLIEXP ], aLote[ nCntFor, LTLOJEXP ], aLote[ nCntFor, LTCLIREC ], aLote[ nCntFor, LTLOJREC ] })
		If Valtype(nNfCTRCPE) == "N" .And. nNfCTRCPE > 0
			nNfCTRC := nNfCTRCPE
		EndIf
	EndIf

	cCPAGPV := aContrt[ 1, 9 ]

	If lTM200Cpg //PE permite alterar a condicao de pagamento
		cCPAGPV:= ExecBlock("TM200CPG",.F.,.F.,{cCliente,cLoja,cCPAGPV,(cAliasDTC)->DTC_SERVIC,(cAliasDTC)->DTC_CODNEG})
		SE4->( DbSetOrder( 1 ) )
		If ValType(cCPAGPV) <> "C" .Or. SE4->(!MsSeek(xFilial('SE4') + cCPAGPV, .F.))
			cCPAGPV	:= aContrt[ 1, 9 ]
		Endif
	Endif

	//-- Verifica se foi informado a condicao de pagamento utilizada no pedido de venda.
	If	Empty( cCPAGPV )
		Help( ' ', 1, 'TMSA20006',,STR0015 + cCliente + ' / ' + cLoja + STR0016 + aContrt[1,1],5,11)	//-- Condicao de pagamento do cliente nao foi especificada no contrato (AAM). //'Cliente : '###' Contrato : '
		lRet := .F.
		Exit
	EndIf
	//-- Se este campo estiver zerado, sera considerado uma nota por conhecimento
	nNfCTRC := Iif( nNfCTRC == 0, 1, nNfCTRC )
	//-- Define o vetor aLote
	TmsA200Lot(aContrt,,,,,,,,,,cCPAGPV,,'1',nCntFor,nNfCTRC)

	If !lRet
		Exit
	EndIf
Next

ResetArr(@aContrt)
RestArea( aAreaAnt )

Return( lRet )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA2001Ct≥ Autor ≥ Alex Egydio           ≥ Data ≥10.07.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Gera documentos do 1o percurso                             ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA2001Ct()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpL1 = Cancela processamento                              ≥±±
±±≥          ≥ ExpC1 = Numero do lote                                     ≥±±
±±≥          ≥ ExpA1 = Array contendo as Mensagens de Erro                ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TMSA2001Ct( lEnd, cLotNfc, aVisErr, aRatTda, lTabAlt )

Local aAreaAnt	:= GetArea()
Local aFrete	:= {}
Local aFrtAlt	:= {}
Local aMsgErr	:= {}
Local aNfCTRC	:= {}
Local aValInf	:= {}
Local aTipVei	:= {}
Local aPesCub	:= {}
Local cChave	:= ''
Local cTabFre	:= ''
Local cTipTab	:= ''
Local cSeqTab	:= ''
Local cTabAlt	:= ''
Local cTipAlt	:= ''
Local cSeqAlt	:= ''
Local lRet		:= .T.
Local nCntFor	:= 0
Local n1Cnt		:= 0
Local nQtdVol	:= 0
Local nSeek		:= 0
Local nTotAlt	:= 0
Local nTotFre	:= 0
Local nValor	:= 0
Local nPeso		:= 0
Local nPesoM3	:= 0
Local nMetro3	:= 0
Local nPesoCob	:= 0
Local nSeguro	:= 0
Local nQtdUni	:= 0
Local cCdrPer	:= ''
Local lDevedor	:= .F.
Local aPrcPdg	:= {}
Local lPrcPdg	:= .T.
Local nPesoPto	:= 0
Local nValorMd	:= 0
Local nMoedaTb	:= 1
Local nSeqDoc	:= 0
Local aSeqPFre  := {}
Local lRateio	:= .F.
Local nKMNF		:= 0
Local nValDPC   := 0
Local aCteAnt   := {}
Local lCamposRat:= DTP->(ColumnPos("DTP_RATEIO")) > 0
Local aVlrInf   := {}
Local nPesoCol  := 0
Local aTaxDev	:= {}
Local aFreteCol := {}
Local cNumCmp   := ""
Local aContrCli := {}
Local lTMSVLINF	:= Existblock("TMSVLINF")
Local lCbrCol := .T.
Local lBlqCol := .F.
Local nAdiDoc := 0

Default aRatTda := {}
Default lTabAlt := .F.
If lPrcProd ==  Nil
	lPrcProd := GetMV('MV_PRCPROD',,.T.)
EndIf

If lCamposRat
	lRateio	:= TMSLRateio( DTP->DTP_FILORI, DTP->DTP_LOTNFC )
EndIf

aRatTDA := {}
aDocto	:= {}
//-- Ordena o vetor aLote
TmsA200Lot(,,,,,,,,,,,,'4')

ProcRegua( Len( aLote ) )

For nCntFor := 1 To Len( aLote )

	//-- Quando encontrar o primeiro cliente que agrupa por devedor,
	//-- re-ordena por devedor e nota fiscal.
	If !lDevedor .And. aLote[nCntFor, LTAGRNFC ] == "5"
		TmsA200Lot(,,,,,,,,,,,,'10')
		nCntFor  := Ascan( aLote, { |x| x[LTAGRNFC] == "5" } )
		lDevedor := .T.
	EndIf

	IncProc()

	If	lEnd
		lRet := .F.
		Exit
	EndIf

	//-- Trata apenas notas com servico de 1o percurso
	If !TMSSegPerc(aLote[ nCntFor, LTSERVIC ])
		Loop
	EndIf

	//-- Retorna string, utilizado no preenchimento da variavel cChave
	If !Empty(aLote[ nCntFor, LTFILDPC ]) .And. !Empty(aLote[ nCntFor, LTCTRDPC ])
		cChave	:= TmsA200Lot(,,,,,,,,,,,,'8',nCntFor)
	ElseIf aLote[nCntFor, LTAGRNFC ] == '5' //-- Por Devedor
		cChave	:= TmsA200Lot(,,,,,,,,,,,,'11',nCntFor)
	Else
		cChave	:= TmsA200Lot(,,,,,,,,,,,,'5',nCntFor)
	EndIf

	//--Adiciona a chave do documento anterior redespacho
    If AScan(aCteAnt,{|x| x == aLote[ nCntFor, LTCTEANT ] })== 0
    	nValDPC += aLote[ nCntFor, LTVALDPC ]
    	Aadd(aCteAnt, aLote[ nCntFor, LTCTEANT])
    EndIf

	nQtdVol  += aLote[ nCntFor, LTQTDVOL ]
	nValor   += aLote[ nCntFor, LTVALOR  ]
	nPeso    += aLote[ nCntFor, LTPESO   ]
	nPesoM3  += aLote[ nCntFor, LTPESOM3 ]
	nMetro3  += aLote[ nCntFor, LTMETRO3 ]
	nSeguro  += aLote[ nCntFor, LTBASSEG ]
	nQtdUni  += aLote[ nCntFor, LTQTDUNI ]
	cCdrPer  := aLote[ nCntFor, LTCDRPER ]
	nKMNF    += aLote[ nCntFor, LTKM ]
	nPesoCol += aLote[ nCntFor, LTPESCOL ]

	//-- Retorna o percurso para calculo.
	If lTM200PER
		cCdrPer := ExecBlock("TM200PER",.F.,.F.,{ .T., aLote[ nCntFor, LTCDRORI ], aLote[ nCntFor, LTCDRDES ], aLote[ nCntFor, LTCLIDEV ], aLote[ nCntFor, LTLOJDEV ],nCntFor })
		If ValType(cCdrPer) # "C" .Or. Empty(cCdrPer)
			cCdrPer  := aLote[ nCntFor, LTCDRPER ]
		EndIf
	EndIf

	For n1Cnt := 1 To Len(aLote[ nCntFor, LTVALINF ])
		nSeek := AScan(aValInf,{|x|x[1]==aLote[ nCntFor, LTVALINF, n1Cnt, 1 ] })
		If	nSeek > 0
			aValInf[nSeek,2]+=aLote[ nCntFor, LTVALINF, n1Cnt, 2 ]
		Else
			AAdd(aValInf,{aLote[ nCntFor, LTVALINF, n1Cnt, 1 ],aLote[ nCntFor, LTVALINF, n1Cnt, 2 ],aLote[ nCntFor, LTVALINF, n1Cnt, 3 ]})
		EndIf
	Next

	//Ponto de entrada para montar vetor com componentes de Valor Informado
	If lTMSVLINF
			aVlrInf := ExecBlock('TMSVLINF',.F.,.F.,{aLote[nCntFor,LTCLICAL], aLote[nCntFor,LTLOJCAL], aLote[nCntFor,LTSERVIC], aLote[nCntFor,LTCODNEG], aLote[ nCntFor, LTTIPFRE ], DTP->DTP_FILORI, aLote[ nCntFor, LTNUMNFC ], aLote[ nCntFor, LTSERNFC ], aLote[ nCntFor, LTCODPRO ]})
			If ValType(aValInf) == 'A' .And. Len(aVlrInf) > 0
				aValInf := aClone(aVlrInf)
			EndIf
	EndIf
	For n1Cnt := 1 To Len(aLote[ nCntFor, LTTIPVEI ])
		nSeek := AScan(aTipVei,{|x|x[1]==aLote[ nCntFor, LTTIPVEI, n1Cnt, 1 ] })
		If	nSeek > 0
			aTipVei[nSeek,2]+=aLote[ nCntFor, LTTIPVEI, n1Cnt, 2 ]
		Else
			AAdd(aTipVei,{aLote[ nCntFor, LTTIPVEI, n1Cnt, 1 ],aLote[ nCntFor, LTTIPVEI, n1Cnt, 2 ]})
		EndIf
	Next

	//-- Formato do vetor aPesCub
	//-- [01] = Fil.Origem
	//-- [02] = No.da Nota Fiscal
	//-- [03] = Serie da Nota Fiscal
	//-- [04] = Cliente Remetente
	//-- [05] = Loja Cliente Remetente
	//-- [06] = Produto
	//-- [07] = Altura
	//-- [08] = Largura
	//-- [09] = Comprimento
	For n1Cnt := 1 To Len(aLote[ nCntFor, LTPESCUB ])
		nSeek := AScan(aPesCub,{|x|x[1]+x[2]+x[3]+x[4]+x[5]+x[6]==aLote[nCntFor,LTPESCUB,n1Cnt,1]+aLote[nCntFor,LTPESCUB,n1Cnt,2]+aLote[nCntFor,LTPESCUB,n1Cnt,3]+;
											aLote[nCntFor,LTPESCUB,n1Cnt,4]+aLote[nCntFor,LTPESCUB,n1Cnt,5]+aLote[nCntFor,LTPESCUB,n1Cnt,6]})
		If	nSeek > 0
			aPesCub[nSeek,7]+=aLote[ nCntFor, LTPESCUB, n1Cnt, 7 ]
			aPesCub[nSeek,8]+=aLote[ nCntFor, LTPESCUB, n1Cnt, 8 ]
			aPesCub[nSeek,9]+=aLote[ nCntFor, LTPESCUB, n1Cnt, 9 ]
		Else
			AAdd(aPesCub,{	aLote[ nCntFor, LTPESCUB, n1Cnt, 1 ],aLote[ nCntFor, LTPESCUB, n1Cnt, 2 ],aLote[ nCntFor, LTPESCUB, n1Cnt, 3 ],;
							aLote[ nCntFor, LTPESCUB, n1Cnt, 4 ],aLote[ nCntFor, LTPESCUB, n1Cnt, 5 ],aLote[ nCntFor, LTPESCUB, n1Cnt, 6 ],;
							aLote[ nCntFor, LTPESCUB, n1Cnt, 7 ],aLote[ nCntFor, LTPESCUB, n1Cnt, 8 ],aLote[ nCntFor, LTPESCUB, n1Cnt, 9 ]})
		EndIf
	Next

	//-- Define o numero de sequencia de composicao (DT6_NUMCMP) que relaciona
	//-- os documentos que serao gerados e fazem parte do mesmo agrupamento de calculo
	If Empty(aNfCTRC)
		cNumCmp   := ""
		aContrCli := TMSContrat(aLote[nCntFor, LTCLICAL], aLote[nCntFor, LTLOJCAL],, aLote[nCntFor, LTSERVIC], .F., aLote[nCntFor, LTTIPFRE],,, aLote[nCntFor, LTCLIREM], aLote[nCntFor, LTLOJREM], aLote[nCntFor, LTCLIDES], aLote[nCntFor, LTLOJDES], aLote[nCntFor, LTTIPTRA], aLote[nCntFor, LTCLIDEV], aLote[nCntFor, LTLOJDEV], aLote[nCntFor, LTTIPNFC],,,,,, aLote[nCntFor, LTCODNEG])
		If Len(aContrCli) > 0
			If Len(aContrCli[1]) >= 52 .And. aContrCli[1,52] == '2' //-- Estorno Frete Agrupado
				cNumCmp   := GetSX8Num('DT6', 'DT6_NUMCMP', , 9)
				Iif(__lSX8, ConfirmSX8(),)
			EndIf
		EndIf
	Endif

	//-- Formato do vetor aNfCTRC
	//-- [01] = Numero da nota fiscal do cliente
	//-- [02] = Serie da nota fiscal do cliente
	//-- [03] = Cliente remetente
	//-- [04] = Loja do cliente remetente
	//-- [05] = Volume
	//-- [06] = Valor da mercadoria
	//-- [07] = Peso real
	//-- [08] = Peso cubado
	//-- [09] = Metro cubico
	//-- [10] = Base de seguro
	//-- [11] = Numero do contrato
	//-- [12] = Tipo de servico
	//-- [13] = Tipo de transporte
	//-- [14] = Codigo da regiao de origem
	//-- [15] = Codigo da regiao de destino						P/ 1o percurso
	//-- [16] = Codigo do servico
	//-- [17] = Cliente agrupamento
	//-- [18] = Loja do cliente agrupamento
	//-- [19] = Cliente destinatario
	//-- [20] = Loja do cliente destinatario
	//-- [21] = Cliente devedor
	//-- [22] = Loja do cliente devedor
	//-- [23] = Codigo do produto
	//-- [24] = Numero da cotacao
	//-- [25] = Qtde de notas fiscais por conhecimento			P/ 1o percurso
	//-- [26] = Peso maximo por conhecimento					P/ 1o percurso
	//-- [27] = Quantidade de unitizadores
	//-- [28] = Valor do frete despachante
	//-- [29] = Filial despachante
	//-- [30] = CTRC despachante
	//-- [31] = Considera ou nao as quebras por numero de notas fiscais por CTRC e peso maximo por CTRC	p/ 1o percurso
	//-- [32] = Numero da solicitacao de coleta
	//-- [33] = Tipo nfc
	//-- [34] = Peso Informado (0=Nao; 1=Sim)
	//-- [35] = Condicao de Pagamento
	//-- [36] = Sequencia de Endereco  Destinatario
	//-- [37] = Sequencia de Inscricao Devedor
	//-- [38] = Peso Liquido
	//-- [39] = Moeda
	//-- [40] = Desconsidera TDA (1-Coleta, 2-Entrega ou 3-Ambas)
	//-- [41] = Devedor      Paga TDA
	//-- [42] = Rementente   Paga TDA
	//-- [43] = Destinatario Paga TDA
	//-- [44] = Sequencia de Inscricao Destinatario
	//-- [45] = Regiao de Calculo
	//-- [46] = Taxa por CTRC ?
	//-- [47] = Indice do array aLote
	//-- [48] = Elemento para Definir quebra do Calculo ( aLote[ nCntFor, LTQBRCALC ] )
	//-- [49] = Elemento para quebra por data de Agendamento
	//-- [50] = Codigo da Negociacao
	//-- [51] = Elemento para Definir quebra do Calculo Por Divergencia De Classe De Risco ( aLote[ nCntFor, LTQBRDIVG] )
	//-- [52] = KM
	//-- [53] = Peso Coleta
	//-- [54] = Criterio Herda Valor (CRVDHV)
	//-- [55] = Estorno Frete Agrupado
	//-- [56] = N˙mero do Lote (cLotNfc)
	AAdd( aNfCTRC, {	aLote[ nCntFor, LTNUMNFC ], aLote[ nCntFor, LTSERNFC ], aLote[ nCntFor, LTCLIREM ],;
						aLote[ nCntFor, LTLOJREM ], aLote[ nCntFor, LTQTDVOL ], aLote[ nCntFor, LTVALOR  ],;
						aLote[ nCntFor, LTPESO   ], aLote[ nCntFor, LTPESOM3 ], aLote[ nCntFor, LTMETRO3 ],;
						aLote[ nCntFor, LTBASSEG ], aLote[ nCntFor, LTNCONTR ], aLote[ nCntFor, LTSERTMS ],;
						aLote[ nCntFor, LTTIPTRA ], aLote[ nCntFor, LTCDRORI ], cCdrPer ,;
						aLote[ nCntFor, LTSERVIC ], aLote[ nCntFor, LTCLIAGR ], aLote[ nCntFor, LTLOJAGR ],;
						aLote[ nCntFor, LTCLIDES ], aLote[ nCntFor, LTLOJDES ], aLote[ nCntFor, LTCLIDEV ],;
						aLote[ nCntFor, LTLOJDEV ], aLote[ nCntFor, LTCODPRO ], aLote[ nCntFor, LTNUMCOT ],;
						aLote[ nCntFor, LT1oNFCT ], aLote[ nCntFor, LT1oPESC ], aLote[ nCntFor, LTQTDUNI ],;
						aLote[ nCntFor, LTVALDPC ], aLote[ nCntFor, LTFILDPC ], aLote[ nCntFor, LTCTRDPC ],;
						aLote[ nCntFor, LT1oAGRN ], aLote[ nCntFor, LTNUMSOL ], aLote[ nCntFor, LTTIPNFC ],;
						If(Empty(aLote[nCntFor,LTPESO]),"0","1"),;
						aLote[ nCntFor, LT1oCPAG ], aLote[ nCntFor, LTSQEDES ], aLote[ nCntFor, LTSEQINS ],;
						aLote[ nCntFor, LTPESLIQ ], aLote[ nCntFor, LTMOEDA  ], aLote[ nCntFor, LTEXCTDA ],;
						aLote[ nCntFor, LTDEVTDA ], aLote[ nCntFor, LTREMTDA ], aLote[ nCntFor, LTDESTDA ],; //--41-Devedor Paga TDA|42-Remetente paga TDA| 43-Destinatario paga TDA
						aLote[ nCntFor, LTSEQINSD], aLote[ nCntFor, LTCDRCAL ], aLote[ nCntFor, LTTAXCTR ],;
						nCntFor , aLote[ nCntFor, LTQBRCALC], aLote[ nCntFor, LTDATAGD] ,;
						aLote[ nCntFor, LTCODNEG ],aLote[ nCntFor, LTQBRDIVG], aLote[ nCntFor, LTKM ],;
						aLote[ nCntFor, LTPESCOL], aLote[ nCntFor, LTCRDVHV] , cNumCmp, cLotNfc} )

	//-- Neste momento o sistema soma os valores, 'que e a base de calculo principal' enquanto nao houver quebra de
	//-- cliente agrupamento ou cliente remetente
	If TMSA200Qbr( cChave, nCntFor, Len( aNfCTRC ), aLote[ nCntFor, LT1oNFCT ], nPeso, aLote[ nCntFor, LT1oPESC ], ,aNfCTRC, aLote[ nCntFor, LT1oAGRN ], !Empty(aLote[ nCntFor, LTNUMCOT ]))
		// A sequencia para cobranÁa da Taxa Adicional È definida por Pagador de Frete //
		nSeqDoc := Ascan(aSeqPFre, { |x| x[1]+x[2] == aLote[nCntFor,LTCLIDEV]+aLote[nCntFor,LTLOJDEV] } )

		If nSeqDoc == 0
			AAdd( aSeqPFre, { aLote[nCntFor,LTCLIDEV], aLote[nCntFor,LTLOJDEV], 1 } )
			nSeqDoc := 1
		Else
			aSeqPFre[nSeqDoc][03]	+= 1
			nSeqDoc					:= aSeqPFre[nSeqDoc][03]
		EndIf

		//-- Calcula a composicao do frete, baseado na tabela de frete especificada no contrato.

		//-- Formato do vetor aFrete
		//--
		//-- [01] = Descricao do componente
		//-- [02] = Valor do componente
		//-- [03] = Codigo do componente
		//-- [04] = Item SD2. Atualizado pelas funcoes que geram o SD2
		//-- [05] = Na cotacao eh gravado o valor do imposto do componente
		//-- [06] = Total do componente ( valor + imposto )
		//-- [07] = Codigo da regiao origem
		//-- [08] = Codigo da regiao destino
		//-- [09] = Tabela de Frete
		//-- [10] = Tipo da Tabela de Frete
		//-- [11] = Sequencia da Tabela de Frete
		//-- Formato do vetor aFreteCol
		//[01]- Filial Coleta
		//[02]- Numero Sol.Coleta
		//[03]- Array com os componentes de Frete
		//[03][01]- Componente
		//[03][02]- Valor do componente
		//[04]- Array com as Notas Fiscais
		//[04][01]- Numero da Nota
		//[04][02]- Serie da Nota
		//[04][03]- Cliente Remetente
		//[04][04]- Loja Remetente
		//[04][05]- Volumes
		//[04][06]- Vlr.Mercadoria
		//[04][07]- Peso
		//[04][08]- Peso Cubado
		//[04][09]- M3
		//------------------------------------------------
		cTabFre := aLote[ nCntFor, LT1oTABF ]
		cTipTab := aLote[ nCntFor, LT1oTIPT ]
		cSeqTab := StrZero(0,TamSx3("DVC_SEQTAB")[1])
		lPrcPdg := .T.

		DTL->(dbSetOrder(1)) //DTL_FILIAL+DTL_TABFRE+DTL_TIPTAB
		If DTL->(MsSeek(xFilial("DTL")+cTabFre+cTipTab))
			nMoedaTb := DTL->DTL_MOEDA
		EndIf
		If nMoedaTb == 0
			nMoedaTb := 1
		EndIf
		nValorMd := Iif(aLote[ nCntFor, LTMOENFC ]==nMoedaTb, nValor, xMoeda(nValor, aLote[ nCntFor, LTMOENFC ], nMoedaTb))

		//-- Desconsidera Notas Fiscais com Valores Zerados
		If	Empty( nQtdVol ) .And. Empty( nPeso ) .And. Empty( nValor )
			Loop
		EndIf
		If lTM200CUB
			nPesoPto := ExecBlock("TM200CUB",.F.,.F.,{aLote[ nCntFor, LTCLIDEV ], aLote[ nCntFor, LTLOJDEV ], nPesoM3, nPeso, aLote[ nCntFor, LTTIPFRE ], aLote[ nCntFor, LTSERVIC ], aLote[ nCntFor, LTTIPTRA ], aLote[ nCntFor, LTSERTMS ], aLote[nCntFor,LTCLICAL],aLote[nCntFor,LTLOJCAL],aLote[nCntFor,LTCODNEG] })
			If ValType(nPesoPto) == "N"
				nPesoM3 := nPesoPto
			EndIf
		EndIf
		//-- Verifica se ja foi calculado o componente praca de pedagio para
		lPrcPdg := Ascan(aPrcPdg, { |x| x[1]+x[2] == aLote[nCntFor,LTCLIDEV]+aLote[nCntFor,LTLOJDEV] } ) == 0


		If lRateio
			Aadd( aRatTDA, { aLote[ nCntFor, LTEXCTDA ], aLote[ nCntFor, LTDEVTDA ], aLote[ nCntFor, LTREMTDA ], aLote[ nCntFor, LTDESTDA ] } )
		EndIf
		aFrete  := {}
		aFretCol:= {}
		aMsgErr := {}

		If aLote[ nCntFor, LTSERTMS ] == "1"
			If DDA->(ColumnPos("DDA_BLQCOL")) > 0 .And. DDC->(ColumnPos("DDC_BLQCOL")) > 0
				lBlqCol := (TmsSobServ('BLQCOL',.T.,.T.,aLote[nCntFor,LT1oNCON],aLote[nCntFor,LTCODNEG],aLote[nCntFor,LTSERVIC],"0",@nAdiDoc) $ " 1")
			EndIf
		Else
			If DDA->(ColumnPos("DDA_CBRCOL")) > 0 .And. DDC->(ColumnPos("DDC_CBRCOL")) > 0
				lCbrCol := (TmsSobServ('CBRCOL',.T.,.T.,aLote[nCntFor,LT1oNCON],aLote[nCntFor,LTCODNEG],aLote[nCntFor,LTSERVIC],"0",@nAdiDoc) $ " 1")
			EndIf
		EndIf

		aFrete  := TMSCalFret(cTabFre,cTipTab,@cSeqTab,aLote[nCntFor,LTCDRORI],cCdrPer,;
		aLote[ nCntFor, LTCLIREM ], aLote[nCntFor,LTLOJREM],If(lPrcProd,aLote[nCntFor,LTCODPRO],Space(Len(SB1->B1_COD))),aLote[nCntFor,LTSERVIC],;
		aLote[ nCntFor, LTSERTMS ], aLote[nCntFor,LTTIPTRA],aLote[nCntFor,LT1oNCON],aMsgErr,aNfCTRC,nValorMd,nPeso,nPesoM3,;
		@nPesoCob,nQtdVol,0,nSeguro,nMetro3,0,0,Iif(DTP->DTP_CRIRAT == 'A',DTP->DTP_KM,aLote[nCntFor,LTKM]),0,,aLote[nCntFor,LTCLIGEN],;
		aLote[nCntFor,LTAJUSTE],0,nQtdUni, nValDPC,0,0,aValInf,aTipVei,,,,,,,,,,cLotNfc,aPesCub,@lPrcPdg,aLote[ nCntFor, LTCLIDEV ],;
		aLote[ nCntFor, LTLOJDEV ], aLote[ nCntFor, LTMOEDA ], aLote[ nCntFor, LTEXCTDA ], aLote[ nCntFor, LTDEVTDA ],;
		aLote[ nCntFor, LTREMTDA ], aLote[ nCntFor, LTDESTDA ],,aLote[ nCntFor, LTCLIDES ], aLote[ nCntFor, LTLOJDES ], aLote [nCntFor, LTSQEDES],;
		nSeqDoc, lRateio, , , aLote [nCntFor, LTCODNEG],@aTaxDev,@aFretCol,lCbrCol,lBlqCol )
			If nPesoCob == 0
				nPesoCob := Iif( nPesoM3 > nPeso, nPesoM3, nPeso)
			EndIf

		nSeek := Ascan( aFrete,{|x| x[3] == 'TF' })

		If	Empty( nSeek ) .Or. Empty(Round(aFrete[ nSeek, 2 ], 2)) .Or. nSeek != Len(aFrete) .Or. Len( aMsgErr ) > 0
			If !Empty( nSeek ) .And. Empty(Round(aFrete[ nSeek, 2 ], 2))
				AAdd(aMsgErr,{STR0050,'00',''}) //"Valor do frete zerado"
			ElseIf nSeek != Len(aFrete)
				AAdd(aMsgErr,{STR0051,'00',''}) //"Falha na linha totalizadora da composiÁ„o do frete"
			EndIf

			If Len( aMsgErr ) > 0
				AaddMsgErr( aMsgErr, @aVisErr)
			EndIf
			aNfCTRC := {}
			aValInf := {}
			aTipVei := {}
			aPesCub := {}
			aCteAnt := {}
			nQtdVol := 0
			nValor  := 0
			nPeso   := 0
			nPesoM3 := 0
			nMetro3 := 0
			nSeguro := 0
			nQtdUni := 0
			nKMNF   := 0
			nValDPC := 0
			nPesoCol:= 0
			Loop
		EndIf

		//-- Verifica se devera ser calculado novamente o calculo do componente praca por pedagio.
		If !lPrcPdg
			If Ascan(aPrcPdg, { |x| x[1]+x[2] == aLote[nCntFor,LTCLIDEV]+aLote[nCntFor,LTLOJDEV] } ) == 0
				AAdd( aPrcPdg, { aLote[nCntFor,LTCLIDEV], aLote[nCntFor,LTLOJDEV] } )
			EndIf
		EndIf


		//-- Calcula com a tabela alternativa
		If ! Empty( aLote[ nCntFor, LT1oTABA ] )
			//-- Guardar o total do frete em ntotfre da composicao obtida acima
			If nSeek > 0
				nTotFre := aFrete[ nSeek, 2 ]
			EndIf
			aFrtAlt := {}
			aFreteCol:= {}
			aMsgErr := {}
			cTabAlt := aLote[ nCntFor, LT1oTABA ]
			cTipAlt := aLote[ nCntFor, LT1oTIPA ]
			cSeqAlt := StrZero(0,TamSx3("DVC_SEQTAB")[1])
			DTL->(dbSetOrder(1)) //DTL_FILIAL+DTL_TABFRE+DTL_TIPTAB
			If DTL->(MsSeek(xFilial("DTL")+cTabAlt+cTipAlt))
				nMoedaTb := DTL->DTL_MOEDA
			EndIf
			If nMoedaTb == 0
				nMoedaTb := 1
			EndIf
			nValorMd := Iif(aLote[ nCntFor, LTMOENFC ]==nMoedaTb, nValor, xMoeda(nValor, aLote[ nCntFor, LTMOENFC ], nMoedaTb))

			//-- Verifica se ja foi calculado o componente praca de pedagio para
			lPrcPdg := Ascan(aPrcPdg, { |x| x[1]+x[2] == aLote[nCntFor,LTCLIDEV]+aLote[nCntFor,LTLOJDEV] } ) == 0


			aFrtAlt := TMSCalFret(cTabAlt,cTipAlt,@cSeqAlt,aLote[nCntFor,LTCDRORI],cCdrPer,;
			aLote[ nCntFor, LTCLIREM ], aLote[ nCntFor, LTLOJREM ],If(lPrcProd,aLote[nCntFor,LTCODPRO],Space(Len(SB1->B1_COD))),aLote[nCntFor,LTSERVIC],;
			aLote[ nCntFor, LTSERTMS ], aLote[ nCntFor, LTTIPTRA ],aLote[nCntFor,LT1oNCON],aMsgErr,aNfCTRC,nValorMd,nPeso,;
			nPesoM3,@nPesoCob,nQtdVol,0,nSeguro,nMetro3,0,0,Iif(DTP->DTP_CRIRAT == 'A',DTP->DTP_KM,aLote[nCntFor,LTKM]),0,,aLote[nCntFor,LTCLIGEN],;
			aLote[nCntFor,LTAJUSTE],0,nQtdUni, nValDPC, 0,0,aValInf,aTipVei,,,,,,,,,,cLotNFc,aPesCub,@lPrcPdg,aLote[ nCntFor, LTCLIDEV ],;
			aLote[ nCntFor, LTLOJDEV ], aLote[ nCntFor, LTMOEDA  ], aLote[ nCntFor, LTEXCTDA ], aLote[ nCntFor, LTDEVTDA ],;
			aLote[ nCntFor, LTREMTDA ], aLote[ nCntFor, LTDESTDA ],,aLote[ nCntFor, LTCLIDES ], aLote[ nCntFor, LTLOJDES ],aLote [nCntFor, LTSQEDES],;
			nSeqDoc, lRateio, , , aLote [nCntFor, LTCODNEG], @aTaxDev, @aFreteCol, lCbrCol, lBlqCol )
				If nPesoCob == 0
					nPesoCob := Iif( nPesoM3 > nPeso, nPesoM3, nPeso)
				EndIf

			//-- Total do frete, obtido com a tabela alternativa
			nSeek := Ascan( aFrtAlt,{|x| x[3] == 'TF' })
			//-- Qd for tabela alternativa
			//-- Envia a mensagem somente se a linha totalizadora nao for o ultimo elemento
			//-- ou nao for encontrada no vetor aFrtAlt.
			If	Empty( nSeek ) .Or. nSeek != Len(aFrtAlt)
				If nSeek != Len(aFrtAlt)
					AAdd(aMsgErr,{STR0051,'00',''}) //"Falha na linha totalizadora da composiÁ„o do frete"
				EndIf
				If	Len( aMsgErr ) > 0
					AaddMsgErr( aMsgErr, @aVisErr)
				EndIf
				aNfCTRC := {}
				aValInf := {}
				aTipVei := {}
				aPesCub := {}
				aCteAnt := {}
				nQtdVol := 0
				nValor  := 0
				nPeso   := 0
				nPesoM3 := 0
				nMetro3 := 0
				nSeguro := 0
				nQtdUni := 0
				nKMNF   := 0
				nValDPC := 0
				nPesoCol:= 0
				Loop
			EndIf

			//-- Verifica se devera ser calculado novamente o calculo do componente praca por pedagio.
			If !lPrcPdg
				If Ascan(aPrcPdg, { |x| x[1]+x[2] == aLote[nCntFor,LTCLIDEV]+aLote[nCntFor,LTLOJDEV] } ) == 0
					AAdd( aPrcPdg, { aLote[nCntFor,LTCLIDEV], aLote[nCntFor,LTLOJDEV] } )
				EndIf
			EndIf


			//-- Total do frete, obtido com a tabela alternativa
			If nSeek > 0
				nTotAlt := aFrtAlt[ nSeek, 2 ]
			EndIf

			lTabAlt := .F.
			//-- Considera o maior valor obtido entre as tabelas de frete e alternativa.
			If nTotAlt > nTotFre
				aFrete	:= {}
				aFrete	:= aClone( aFrtAlt )
				cTabFre	:= cTabAlt
				cTipTab	:= cTipAlt
				cSeqTab	:= cSeqAlt
				lTabAlt := .T.
			EndIf
		EndIf
		//-- Analisa agrupamento de clientes para documentos do 1o percurso
		TmsA200Agr(aFrete,aNfCTRC,@aVisErr,cLotNfc,cTabFre,cTipTab,cSeqTab,aLote[nCntFor,LT1oNCON ],aLote[nCntFor,LTSERVIC],.T.,.F.,nQtdVol,nValor,nPeso,nPesoM3,nPesoCob,nMetro3,nSeguro,nCntFor,aValInf,aTipVei,aPesCub,nKMNF,aLote[nCntFor,LTCODNEG],nPesoCol,aFreteCol)
		aNfCTRC := {}
		aValInf := {}
		aTipVei := {}
		aPesCub := {}
		aCteAnt := {}
		nQtdVol := 0
		nValor  := 0
		nPeso   := 0
		nPesoM3 := 0
		nMetro3 := 0
		nSeguro := 0
		nQtdUni := 0
		nValDPC := 0

	EndIf

Next

//-- Limpa array
aMsgErr	:= {}

ResetArr(@aFrete	)
ResetArr(@aFrtAlt	)
ResetArr(@aNfCTRC	)
ResetArr(@aValInf	)
ResetArr(@aTipVei	)
ResetArr(@aPesCub	)
ResetArr(@aPrcPdg	)
ResetArr(@aSeqPFre  )
ResetArr(@aCteAnt   )
ResetArr(@aVlrInf   )
ResetArr(@aTaxDev	)
ResetArr(@aFreteCol )
ResetArr(@aContrCli )

RestArea( aAreaAnt )

Return( lRet )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200Ctr≥ Autor ≥ Alex Egydio           ≥ Data ≥06.02.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Gera documentos (Obtem a base de calculo principal)        ≥±±
±±≥          ≥ A composicao de frete obtida aqui, servira como base para  ≥±±
±±≥          ≥ proporcionar os documentos                                 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA200Ctr()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpL1 = Cancela processamento                              ≥±±
±±≥          ≥ ExpC1 = Numero do lote                                     ≥±±
±±≥          ≥ ExpA1 = Array contendo as Mensagens de Erro                ≥±±
±±≥          ≥ ExpC2 = Filial de Origem do Lote                           ≥±±
±±≥          ≥ ExpC3 = Nr da cotacao do Lote                              ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TMSA200Ctr( lEnd, cLotNfc, aVisErr, cFilLot, cLotCot, aRatTda, lTabAlt )
Local aAreaAnt		:= GetArea()
Local aFrete		:= {}
Local aFrtAlt		:= {}
Local aMsgErr		:= {}
Local aNfCTRC		:= {}
Local aValInf		:= {}
Local aTipVei		:= {}
Local aPesCub		:= {}
Local cChave		:= ''
Local cTipoCli		:= ''
Local cSeek			:= ''
Local cTabFre		:= ''
Local cTipTab		:= ''
Local cSeqTab		:= ''
Local cSeqTCot		:= ''
Local cTabAlt		:= ''
Local cTipAlt		:= ''
Local cSeqAlt		:= ''
Local cDscComp		:= ''
Local cCliGen		:= ''
Local cLojGen		:= ''
Local cNContr		:= ''
Local cFilAtu		:= ''
Local cSeekDT4		:= ''
Local cFilDT4		:= xFilial('DT4')
Local cFilDT8		:= xFilial('DT8')
Local lAplDes		:= .F.
Local lRet			:= .T.
Local lCotacao		:= .F.
Local nCntFor		:= 0
Local n1Cnt			:= 0
Local nQtdVol		:= 0
Local nSeek			:= 0
Local nTotAlt		:= 0
Local nTotFre		:= 0
Local nValor		:= 0
Local nPeso			:= 0
Local nPesoM3		:= 0
Local nMetro3		:= 0
Local nPesoCob		:= 0
Local nSeguro		:= 0
Local nQtdUni		:= 0
Local nOldValSImp	:= 0
Local nOldValCImp	:= 0
Local nNewValSImp	:= 0
Local nNewValCImp	:= 0
Local lCliCot		:= SuperGetMV("MV_CLICOT",Nil,.F.) //-- Utiliza o cliente informado no Cadastro de Solicitantes
Local nPercent		:= 0
Local nValTot		:= 0
Local nValImp		:= 0
Local nValDif		:= 0
Local nValComp		:= 0
Local nVlTotCot		:= 0
Local cCdrOri		:= ''
Local nTotCot		:= 0
Local nTotLot		:= 0
Local nPesoPto		:= 0
Local nSeqDoc		:= 0
Local aSeqPFre      := {}
Local lIdentDoc  	:= DTC->(ColumnPos("DTC_DOCTMS")) > 0
Local cDocTms		:= ""

//-- Variaveis que comparam a igualdade da nota com a cotacao
Local nA			:= 0
Local nPosVei		:= 0
Local aTpvCot		:= {}
Local cSeekDVU		:= ''
Local lIgualCot		:= .F.
Local lTmsCFec		:= TmsCFec()
Local lCligen		:= .F.
Local lDevedor		:= .F.
Local lPrcPdg		:= .T.
Local aPrcPdg		:= {}
Local lAcumCot		:= .T.
Local aAcumCot		:= {}
Local cAliasQry		:= GetNextAlias()
Local nMoedaTb		:= 1
Local nValorMd		:= 0
Local lCalFret		:= .T.
Local lCRTAuto		:= .F.
Local aContrt		:= {}
Local nVlCot		:= 0
Local nVlRat		:= 0 // Usado para calcular o restante do rateio para diferenca de centavos
Local lRatCot		:= .F.
Local lRateio		:= .F.
Local aBaseRat		:= {}
Local nKMNF			:= 0
Local nValDPC       := 0
Local aCteAnt       := {}
Local lCamposRat    := DTP->(ColumnPos("DTP_RATEIO")) > 0
Local nPesoCol      := 0
Local aTaxDev       := {}
Local aVlrInf  		:= {}
Local aFreteCol		:= {}
Local cMsg          := ""
Local nMsgPos       := 0
Local cNumCmp  		:= ""
Local aContrCli		:= {}
Local cPrefixErr    := ""  // Em casos de Rateio, prefixa o erro dados da 1™ Nf para facilitar identificaÁ„o do erro
Local cFilRest		:= ""
Local lCbrCol 		:= .T.
Local lBlqCol 		:= .F.
Local nAdiDoc 		:= 0
Local lTMSVLINF	:= Existblock("TMSVLINF")
Local cMV_CliGen := SuperGetMV('MV_CLIGEN')
Local nY      := 1

Private cProGen     := Padr(SuperGetMV('MV_PROGEN',,''),Len(SB1->B1_COD))

Default cFilLot	:= ''
Default cLotCot	:= ''
Default aRatTda     := {}
Default lTabAlt     := .F.

aRatTDA				:= {}
aDocto				:= {}

If lCamposRat
	lRateio:= TMSLRateio( DTP->DTP_FILORI, DTP->DTP_LOTNFC )
EndIf
If lPrcProd ==  Nil
	lPrcProd := GetMV('MV_PRCPROD',,.T.)
EndIf
If cProGen == Nil
	cProGen := Padr(SuperGetMV('MV_PROGEN',,''),Len(SB1->B1_COD))
EndIf

//-- Ordena o vetor aLote
TmsA200Lot(,,,,,,,,,,,,'4')

ProcRegua( Len( aLote ) )

If lRateio
	// Estrutura do vetor aBaseRat
	// [01] - Quantidade de Notas Fiscais
	// [02] - Quantidade Total de Volumes
	// [03] - Quantidade Total de Peso
	// [04] - Quantidade Total de PesoM3
	// [05] - Quantidade Total de Vlr.Mercadoria
	// [06] - Quantidade Total de M3
	// [07] - Quantidade Total de KM
	// [08] - Regras do Rateio informados no Lote (DTP)
	// [08][01] - Base Calc.Rat. (DTP_BACRAT)
	// [08][02] - Criterio Calc.Rat. (DTP_CRIRAT)
	// [08][03] - Criterio Rateio (DTP_PRORAT)
	// [08][04] - Cod.Origem Rateio (DTP_ORIRAT)
	// [08][05] - Cod.Calc. Rateio (DTP_CALRAT)
	// [08][06] - Tabela de Frete Rat. (DTP_TABRAT)
	// [08][07] - Tipo Tab.Fre.Rat. (DTP_TIPRAT)
	// [08][08] - Tabela Alternativa Rat. (DTP_TBARAT)
	// [08][09] - Tipo Tab.Alternat.Rat. (DTP_TPARAT)
	// [09] - Peso Previsto
	// [10] - Peso Previsto x Realizado
	//////////////////////////////////////////////////////
	Aadd( aBaseRat, 0 )
	Aadd( aBaseRat, 0 )
	Aadd( aBaseRat, 0 )
	Aadd( aBaseRat, 0 )
	Aadd( aBaseRat, 0 )
	Aadd( aBaseRat, 0 )
	Aadd( aBaseRat, 0 )
	Aadd( aBaseRat, {	DTP->DTP_BACRAT,	DTP->DTP_CRIRAT,	DTP->DTP_PRORAT,	DTP->DTP_ORIRAT,;
						DTP->DTP_CALRAT,	DTP->DTP_TABRAT,	DTP->DTP_TIPRAT, 	DTP->DTP_TBARAT,;
						DTP->DTP_TPARAT } )
	Aadd( aBaseRat, 0 )
	Aadd( aBaseRat, 0 )

	// Quando Calculo do rateio for ìPONTO A PONTOî e com Base na Regra de ì2=Orig/Destî	//
	// a rotina estara obtendo as Regioes de Origem (DTP_ORIRAT) e Destino (DTP_CALRAT) do	//
	// Rateio (LOTE) e as utilizar„o para o Calculo dos Componentes de Frete com Rateio =SIM//
	// Exemplo : Existindo 4 NFS de 10 KGs, cada NF ser· calculada pela utilizando-se como	//
	// base de Calculo so 10KGs porÈm utilizando-se da ORIGEM e DESTINO do Rateio e n„o a 	//
	// ORIGEM e DESTINO informada na NF em quest„o. Essa troca de ORIGEM e DESTINO ser·		//
	// aplicada somente para o CALCULO DE FRETE e nao para a parte FISCAL.					//
	// Base Calc.Ra : 2=Ponto a Ponto														//
	// If DTP->DTP_BACRAT == StrZero(2, Len(DTP->DTP_BACRAT))								//
	//////////////////////////////////////////////////////////////////////////////////////////

	// Quando Calculo do rateio for ìCONSOLIDADOî e com Base em uma Regra de ìMAIOR VALORî	//
	// a rotina estara obtendo o TOTAL DAS BASES DE CALCULO (soma de PESO, VLR, VOLUMES de 	//
	// cada Nota Fiscal) e esse TOTAL DE BASE ser· utilizado para o calculo de frete a rece-//
	// ber de cada um dos componentes, onde nesse caso a ORIGEM/DESTINO permanece o informa-//
	// do na Nota Fiscal. Exemplo : Existindo 4 NFS de 10 KGs, cada NF ser· calculada pela 	//
	// ORIGEM e DESTINO individualmente mas com 40 KG. Se fosse ìPONTO A PONTOî, seriam cal-//
	// culadas considerando 10 KG. A soma aqui obtida sera utilizada pela funcao TMSCalFret.//
	// Base Calc.Ra : 3=Consolidado
	If DTP->DTP_BACRAT == StrZero(3, Len(DTP->DTP_BACRAT))
		// 1=Nao Utiliza;2=Orig/Dest;3=Maior Vlr.Comp;4=Maior Peso Real		 //
		// 5=Maior Peso M3;6=Maior Vlr.Merc;7=Maior Vol;8=Maior KM;9=Maior M3//
		// A=Orig/Dest Vge;B=Peso Previsto;C=Peso Previsto x Realizado
		//----If (Val(DTP->DTP_CRIRAT) >= 4) .And. (Val(DTP->DTP_CRIRAT) <= 9)
		If DTP->DTP_CRIRAT $ "4/5/6/7/8/9/B/C"
			aBaseRat[01] := Len( aLote )

			For	nCntFor := 1 To Len( aLote )
				aBaseRat[02]	+= aLote[ nCntFor, LTQTDVOL ] // 02 - Quantidade Total de Volumes
				aBaseRat[03]	+= aLote[ nCntFor, LTPESO   ] // 03 - Quantidade Total de Peso
				aBaseRat[04]	+= aLote[ nCntFor, LTPESOM3 ] // 04 - Quantidade Total de PesoM3
				aBaseRat[05]	+= aLote[ nCntFor, LTVALOR  ] // 05 - Quantidade Total de Vlr.Mercadoria
				aBaseRat[06]	+= aLote[ nCntFor, LTMETRO3 ] // 06 - Quantidade Total de M3
				aBaseRat[07]	+= aLote[ nCntFor, LTKM] 	  // 07 - Quantidade Total de KM
				aBaseRat[09]	+= aLote[ nCntFor, LTPESCOL ] // 09 - Quantidade Total Previsto
				aBaseRat[10]	+= Iif(aLote[ nCntFor, LTPESO ]>aLote[ nCntFor, LTPESCOL ],aLote[ nCntFor, LTPESO ] ,aLote[ nCntFor, LTPESCOL ] ) // 10 - Quantidade Total Previsto x Realizado
			Next nCntFor
		EndIf
	EndIf
EndIf
For nCntFor := 1 To Len( aLote )

	//-- Quando encontrar o primeiro cliente que agrupa por devedor,
	//-- re-ordena por devedor e nota fiscal.
	If !lDevedor .And. aLote[nCntFor, LTAGRNFC ] == "5"
		TmsA200Lot(,,,,,,,,,,,,'10')
		nCntFor  := Ascan( aLote, { |x| x[LTAGRNFC] == "5" } )
		lDevedor := .T.
	EndIf

	IncProc()

	If	lEnd
		lRet := .F.
		Exit
	EndIf
	//-- Retorna string utilizado no preenchimento da variavel cChave
	If !Empty(aLote[ nCntFor, LTFILDPC ]) .And. !Empty(aLote[ nCntFor, LTCTRDPC ])
		cChave	:= TmsA200Lot(,,,,,,,,,,,,'8',nCntFor)
	ElseIf aLote[nCntFor, LTAGRNFC ] == '5' //-- Por Devedor
		cChave	:= TmsA200Lot(,,,,,,,,,,,,'11',nCntFor)
	Else
		cChave	:= TmsA200Lot(,,,,,,,,,,,,'5',nCntFor)
	EndIf

	//--Adiciona a chave do documento anterior redespacho
   If AScan(aCteAnt,{|x| x == aLote[ nCntFor, LTCTEANT ] })== 0
    	nValDPC += aLote[ nCntFor, LTVALDPC ] //-- 57
    	Aadd(aCteAnt, aLote[ nCntFor, LTCTEANT]) //-- 93
    EndIf

	nQtdVol	+= aLote[ nCntFor, LTQTDVOL ]
	nValor	+= aLote[ nCntFor, LTVALOR  ]
	nPeso	+= aLote[ nCntFor, LTPESO   ]
	nPesoM3	+= aLote[ nCntFor, LTPESOM3 ]
	nMetro3	+= aLote[ nCntFor, LTMETRO3 ]
	nSeguro	+= aLote[ nCntFor, LTBASSEG ]
	nQtdUni	+= aLote[ nCntFor, LTQTDUNI ]
	nKMNF   	+= aLote[ nCntFor, LTKM ]
	nPesoCol  	+= aLote[ nCntFor, LTPESCOL ]

	lIgualCot := .F.
	cCdrOri   := Iif(TMSSegPerc(aLote[ nCntFor, LTSERVIC ]),aLote[nCntFor,LTCDRPER],aLote[nCntFor,LTCDRORI])
	lCliGen   := aLote[nCntFor,LTCLIGEN]
	lCRTAuto  := .F.

	//-- Retorna o percurso para calculo.
	If lTM200PER
		cCdrOri := ExecBlock("TM200PER",.F.,.F.,{ .F., aLote[ nCntFor, LTCDRORI ], aLote[ nCntFor, LTCDRDES ], aLote[ nCntFor, LTCLIDEV ], aLote[ nCntFor, LTLOJDEV ], nCntFor })
		If ValType(cCdrOri) # "C" .Or. Empty(cCdrOri)
			cCdrOri  := Iif(TMSSegPerc(aLote[ nCntFor, LTSERVIC ]),aLote[nCntFor,LTCDRPER],aLote[nCntFor,LTCDRORI])
		EndIf
	EndIf

	If lTM200CUB
		nPesoPto := ExecBlock("TM200CUB",.F.,.F.,{aLote[ nCntFor, LTCLIDEV ], aLote[ nCntFor, LTLOJDEV ], nPesoM3, nPeso, aLote[ nCntFor, LTTIPFRE ], aLote[ nCntFor, LTSERVIC ], aLote[ nCntFor, LTTIPTRA ], aLote[ nCntFor, LTSERTMS ], aLote[nCntFor,LTCLICAL],aLote[nCntFor,LTLOJCAL],aLote[nCntFor,LTCODNEG] })
		If ValType(nPesoPto) == "N"
			nPesoM3 := nPesoPto
		EndIf
	EndIf
	//-- Formato do vetor aValInf
	//-- [01] = Codigo do Componente
	//-- [02] = Qtde. do valor informado
	//-- [03] = .T.(Deletado) - .F.(Nao Deletado)

	For n1Cnt := 1 To Len(aLote[ nCntFor, LTVALINF ])
		nSeek := AScan(aValInf,{|x|x[1]==aLote[ nCntFor, LTVALINF, n1Cnt, 1 ] })
		If	nSeek > 0
			aValInf[nSeek,2]+=aLote[ nCntFor, LTVALINF, n1Cnt, 2 ]
		Else
			AAdd(aValInf,{aLote[ nCntFor, LTVALINF, n1Cnt, 1 ],aLote[ nCntFor, LTVALINF, n1Cnt, 2 ],aLote[ nCntFor, LTVALINF, n1Cnt, 3 ]})
		EndIf
	Next

	//Ponto de entrada para montar vetor com componentes de Valor Informado
	If lTMSVLINF
		aVlrInf := ExecBlock('TMSVLINF',.F.,.F.,{aLote[nCntFor,LTCLICAL], aLote[nCntFor,LTLOJCAL], aLote[nCntFor,LTSERVIC], aLote[nCntFor,LTCODNEG], aLote[ nCntFor, LTTIPFRE ], DTP->DTP_FILORI, aLote[ nCntFor, LTNUMNFC ], aLote[ nCntFor, LTSERNFC ], aLote[ nCntFor, LTCODPRO ]})
		If ValType(aValInf) == 'A' .And. Len(aVlrInf) > 0
			aValInf := aClone(aVlrInf)
		EndIf
	EndIf

	//-- Formato do vetor aTipVei
	//-- [01] = Tipo do Veiculo
	//-- [02] = Qtde.

	For n1Cnt := 1 To Len(aLote[ nCntFor, LTTIPVEI ])
		nSeek := AScan(aTipVei,{|x|x[1]==aLote[ nCntFor, LTTIPVEI, n1Cnt, 1 ] })
		If	nSeek > 0
			aTipVei[nSeek,2]+=aLote[ nCntFor, LTTIPVEI, n1Cnt, 2 ]
		Else
			AAdd(aTipVei,{aLote[ nCntFor, LTTIPVEI, n1Cnt, 1 ],aLote[ nCntFor, LTTIPVEI, n1Cnt, 2 ]})
		EndIf
	Next

	//-- Formato do vetor aPesCub
	//-- [01] = Fil.Origem
	//-- [02] = No.da Nota Fiscal
	//-- [03] = Serie da Nota Fiscal
	//-- [04] = Cliente Remetente
	//-- [05] = Loja Cliente Remetente
	//-- [06] = Produto
	//-- [07] = Altura
	//-- [08] = Largura
	//-- [09] = Comprimento
	For n1Cnt := 1 To Len(aLote[ nCntFor, LTPESCUB ])
		nSeek := AScan(aPesCub,{|x|x[1]+x[2]+x[3]+x[4]+x[5]+x[6]==aLote[nCntFor,LTPESCUB,n1Cnt,1]+aLote[nCntFor,LTPESCUB,n1Cnt,2]+aLote[nCntFor,LTPESCUB,n1Cnt,3]+;
											aLote[nCntFor,LTPESCUB,n1Cnt,4]+aLote[nCntFor,LTPESCUB,n1Cnt,5]+aLote[nCntFor,LTPESCUB,n1Cnt,6]})
		If	nSeek > 0
			aPesCub[nSeek,7]+=aLote[ nCntFor, LTPESCUB, n1Cnt, 7 ]
			aPesCub[nSeek,8]+=aLote[ nCntFor, LTPESCUB, n1Cnt, 8 ]
			aPesCub[nSeek,9]+=aLote[ nCntFor, LTPESCUB, n1Cnt, 9 ]
		Else
			AAdd(aPesCub,{	aLote[ nCntFor, LTPESCUB, n1Cnt, 1 ],aLote[ nCntFor, LTPESCUB, n1Cnt, 2 ],aLote[ nCntFor, LTPESCUB, n1Cnt, 3 ],;
							aLote[ nCntFor, LTPESCUB, n1Cnt, 4 ],aLote[ nCntFor, LTPESCUB, n1Cnt, 5 ],aLote[ nCntFor, LTPESCUB, n1Cnt, 6 ],;
							aLote[ nCntFor, LTPESCUB, n1Cnt, 7 ],aLote[ nCntFor, LTPESCUB, n1Cnt, 8 ],aLote[ nCntFor, LTPESCUB, n1Cnt, 9 ]})
		EndIf
	Next

	//-- Define o numero de sequencia de composicao (DT6_NUMCMP) que relaciona
	//-- os documentos que serao gerados e fazem parte do mesmo agrupamento de calculo
	If Empty(aNfCTRC)
		cNumCmp   := ""
		aContrCli := TMSContrat(aLote[nCntFor, LTCLICAL], aLote[nCntFor, LTLOJCAL],, aLote[nCntFor, LTSERVIC], .F., aLote[nCntFor, LTTIPFRE],,, aLote[nCntFor, LTCLIREM], aLote[nCntFor, LTLOJREM], aLote[nCntFor, LTCLIDES], aLote[nCntFor, LTLOJDES], aLote[nCntFor, LTTIPTRA], aLote[nCntFor, LTCLIDEV], aLote[nCntFor, LTLOJDEV], aLote[nCntFor, LTTIPNFC],,,,,, aLote[nCntFor, LTCODNEG])
		If Len(aContrCli) > 0
			If Len(aContrCli[1]) >= 52 .And. aContrCli[1,52] == '2' //-- Estorno Frete Agrupado
				cNumCmp   := GetSX8Num('DT6', 'DT6_NUMCMP', , 9)
				Iif(__lSX8, ConfirmSX8(),)
			EndIf
		EndIf
	Endif

	//-- Formato do vetor aNfCTRC
	//-- [01] = Numero da nota fiscal do cliente
	//-- [02] = Serie da nota fiscal do cliente
	//-- [03] = Cliente remetente
	//-- [04] = Loja do cliente remetente
	//-- [05] = Volume
	//-- [06] = Valor da mercadoria
	//-- [07] = Peso real
	//-- [08] = Peso cubado
	//-- [09] = Metro cubico
	//-- [10] = Base de seguro
	//-- [11] = Numero do contrato
	//-- [12] = Tipo de servico
	//-- [13] = Tipo de transporte
	//-- [14] = Codigo da regiao de origem
	//-- [15] = Codigo da regiao de destino
	//-- [16] = Codigo do servico
	//-- [17] = Cliente agrupamento
	//-- [18] = Loja do cliente agrupamento
	//-- [19] = Cliente destinatario
	//-- [20] = Loja do cliente destinatario
	//-- [21] = Cliente devedor
	//-- [22] = Loja do cliente devedor
	//-- [23] = Codigo do produto
	//-- [24] = Numero da cotacao
	//-- [25] = Qtde de notas fiscais por conhecimento
	//-- [26] = Peso maximo por conhecimento
	//-- [27] = Quantidade de unitizadores
	//-- [28] = Valor do frete despachante
	//-- [29] = Filial despachante
	//-- [30] = CTRC despachante
	//-- [31] = Considera ou nao as quebras por numero de notas fiscais por CTRC e peso maximo por CTRC
	//-- [32] = Numero da solicitacao de coleta
	//-- [33] = Tipo nfc
	//-- [34] = Peso Informado (0=Nao; 1=Sim)
	//-- [35] = Condicao de Pagamento
	//-- [36] = Sequencia de Endereco  Destinatario
	//-- [37] = Sequencia de Inscricao Devedor
	//-- [38] = Peso Liquido
	//-- [39] = Moeda
	//-- [40] = Desconsidera TDA (1-Coleta, 2-Entrega ou 3-Ambas)
	//-- [41] = Devedor      Paga TDA
	//-- [42] = Rementente   Paga TDA
	//-- [43] = Destinatario Paga TDA
	//-- [44] = Sequencia de Inscricao Destinatario
	//-- [45] = Regiao de Calculo
	//-- [46] = Taxa por CTRC ?
	//-- [47] = Indice do array aLote
	//-- [48] = Elemento para Definir quebra do Calculo ( aLote[ nCntFor, LTQBRCALC ] )
	//-- [49] = Elemento para quebra por data de Agendamento
	//-- [50] = Codigo da Negociacao
	//-- [51] = Elemento para Definir quebra do Calculo Por Divergencia De Classe De Risco ( aLote[ nCntFor, LTQBRDIVG] )
	//-- [52] = KM
	//-- [53] = Peso Coleta
	//-- [54] = Criterio Rateio Herda Valor (CRDVHV)
	//-- [55] = Estorno Frete Agrupado
	//-- [56] = N˙mero do Lote (cLotNfc)
	AAdd( aNfCTRC, {	aLote[ nCntFor, LTNUMNFC ], aLote[ nCntFor, LTSERNFC ], aLote[ nCntFor, LTCLIREM ],;
						aLote[ nCntFor, LTLOJREM ], aLote[ nCntFor, LTQTDVOL ], aLote[ nCntFor, LTVALOR  ],;
						aLote[ nCntFor, LTPESO   ], aLote[ nCntFor, LTPESOM3 ], aLote[ nCntFor, LTMETRO3 ],;
						aLote[ nCntFor, LTBASSEG ], aLote[ nCntFor, LTNCONTR ], aLote[ nCntFor, LTSERTMS ],;
						aLote[ nCntFor, LTTIPTRA ], cCdrOri                   , aLote[ nCntFor, LTCDRDES ],;
						aLote[ nCntFor, LTSERVIC ], aLote[ nCntFor, LTCLIAGR ], aLote[ nCntFor, LTLOJAGR ],;
						aLote[ nCntFor, LTCLIDES ], aLote[ nCntFor, LTLOJDES ], aLote[ nCntFor, LTCLIDEV ],;
						aLote[ nCntFor, LTLOJDEV ], aLote[ nCntFor, LTCODPRO ], aLote[ nCntFor, LTNUMCOT ],;
						aLote[ nCntFor, LTNFCTRC ], aLote[ nCntFor, LTPESCTR ], aLote[ nCntFor, LTQTDUNI ],;
						aLote[ nCntFor, LTVALDPC ], aLote[ nCntFor, LTFILDPC ], aLote[ nCntFor, LTCTRDPC ],;
						aLote[ nCntFor, LTAGRNFC ], aLote[ nCntFor, LTNUMSOL ], aLote[ nCntFor, LTTIPNFC ],;
						If(Empty(aLote[nCntFor,LTPESO]),"0","1"),;
						aLote[ nCntFor, LTCPAGPV ], aLote[ nCntFor, LTSQEDES ], aLote[ nCntFor, LTSEQINS ],;
						aLote[ nCntFor, LTPESLIQ ], aLote[ nCntFor, LTMOEDA  ], aLote[ nCntFor, LTEXCTDA ],;
						aLote[ nCntFor, LTDEVTDA ], aLote[ nCntFor, LTREMTDA ], aLote[ nCntFor, LTDESTDA ],;
						aLote[ nCntFor, LTSEQINSD], aLote[ nCntFor, LTCDRCAL ], aLote[ nCntFor, LTTAXCTR ],;
						nCntFor, 					aLote[ nCntFor, LTQBRCALC], aLote[ nCntFor, LTDATAGD] ,;
						aLote[ nCntFor, LTCODNEG ],aLote[ nCntFor, LTQBRDIVG], aLote[ nCntFor, LTKM ] ,;
						aLote[ nCntFor, LTPESCOL ],aLote[ nCntFor, LTCRDVHV ], cNumCmp, cLotNfc } )

	If aLote[nCntFor,LTTIPTRA] == '4' //-- Rodoviario Internacional
		// CRT - Conhecimento Internacional
		DIK->(DbSetOrder(1)) //DIK_FILIAL+DIK_FILORI+DIK_LOTNFC
		If DIK->(MsSeek(xFilial('DIK')+cFilAnt+cLotNfc))
			lCRTAuto := .T.
		EndIf
	EndIf

	If !Empty(cFilLot) .And. !Empty(cLotCot)
		lRatCot := .T. // Rateio por Cotacao de Frete
	EndIf

	//-- Neste momento o sistema soma os valores, 'que e a base de calculo principal' enquanto nao houver quebra de
	//-- cliente agrupamento ou cliente remetente

	If TMSA200Qbr( cChave, nCntFor, Len( aNfCTRC ), aLote[ nCntFor , LTNFCTRC ], nPeso, aLote[ nCntFor, LTPESCTR ], ,aNfCTRC , aLote[ nCntFor, LTAGRNFC ], Iif(aLote[nCntFor,LTTIPTRA] == '4',.T.,!Empty(aLote[ nCntFor, LTNUMCOT ])), aLote[ nCntFor, LTMOEDA ],lRatCot)
		// A sequencia para cobranÁa da Taxa Adicional È definida por Pagador de Frete //
		nSeqDoc := Ascan(aSeqPFre, { |x| x[1]+x[2] == aLote[nCntFor,LTCLIDEV]+aLote[nCntFor,LTLOJDEV] } )

		If nSeqDoc == 0
			AAdd( aSeqPFre, { aLote[nCntFor,LTCLIDEV], aLote[nCntFor,LTLOJDEV], 1 } )
			nSeqDoc := 1
		Else
			aSeqPFre[nSeqDoc][03]	+= 1
			nSeqDoc					:= aSeqPFre[nSeqDoc][03]
		EndIf

		//-- Calcula a composicao do frete, baseado na tabela de frete especificada no contrato.

		//-- Formato do vetor aFrete
		//--
		//-- [01] = Descricao do componente
		//-- [02] = Valor do componente
		//-- [03] = Codigo do componente
		//-- [04] = Item SD2. Atualizado pelas funcoes que geram o SD2
		//-- [05] = Na cotacao eh gravado o valor do imposto do componente
		//-- [06] = Total do componente ( valor + imposto )
		//-- [07] = Codigo da regiao origem
		//-- [08] = Codigo da regiao destino
		//-- [09] = Tabela de Frete
		//-- [10] = Tipo da Tabela de Frete
		//-- [11] = Sequencia da Tabela de Frete
		aFrete := {}
		aFreteCol:= {}
		lCotacao := ! Empty( aLote[ nCntFor, LTNUMCOT ] )
		lPrcPdg  := .T.

		//-- Valida cotacao x nota fiscal
		If lCotacao
			lIgualCot := TM200VerCot(nQtdVol,nValor,nPeso,nPesoM3,nSeguro,nQtdUni,aValInf,aTipVei,nCntFor,@nVlTotCot)

			DT4->(DbSetOrder(1)) //DT4_FILIAL+DT4_FILORI+DT4_NUMCOT
			If  !Empty(aLote[ nCntFor, LTFILCFS ])
				cSeekDT4 := cFilDT4 + aLote[ nCntFor, LTFILCFS ] + aLote[ nCntFor, LTNUMCOT ]
			Else
				cSeekDT4 := cFilDT4 + cFilAnt + aLote[ nCntFor, LTNUMCOT ]
			EndIf
			If	DT4->(MsSeek(cSeekDT4))
			
				cTabFre:= DT4->DT4_TABFRE
				cTipTab:= DT4->DT4_TIPTAB
				cSeqTab:= DT4->DT4_SEQTAB
				//-- Ha casos em que a sequencia da tabela usada na cotacao de frete eh alterada, se ligualcot igual a .t.
				//-- retorna o conteudo original
				cSeqTCot:=cSeqTab
				If	lCliCot
					//-- Utiliza o contrato do cliente
					cNContr:= aLote[nCntFor,LTNCONTR]
				Else
					//-- Utiliza o contrato do cliente generico
					cCliGen := cMV_CliGen
					lCligen := .T.
					If	TMSA200Cli(cCliGen)       //posiciona na tabela SA1
						cCliGen := SA1->A1_COD
						cLojGen := SA1->A1_LOJA
						aContrt := TMSContrat(cCliGen,cLojGen,,DT4->DT4_SERVIC,.F.,DT4->DT4_TIPFRE,,,,,,,,,,,,,,,,DT4->DT4_CODNEG)
						If !Empty(aContrt) //--Verifica se o achou o contrato.
							cNContr := aContrt[1,1]
						EndIf
						If	Empty(cNContr)
							cNContr := aLote[nCntFor,LTNCONTR]						
						EndIf
					Else
						cNContr := aLote[nCntFor,LTNCONTR]
					EndIf
				EndIf
			EndIf
		//-- Calcular a composicao do frete utilizando a tabela do contrato do cliente de calculo
		Else
			cTabFre:= aLote[nCntFor,LTTABFRE]
			cTipTab:= aLote[nCntFor,LTTIPTAB]
			cSeqTab:= StrZero(0,TamSx3("DVC_SEQTAB")[1])
			cNContr:= aLote[nCntFor,LTNCONTR]
		EndIf

		//-- Desconsidera itens das Notas Fiscais com valores baixos
		If	nQtdVol <= 0 .And. nPeso <= 0 .And. nValor <= 0
			aNfCTRC	:= {}
			aValInf	:= {}
			aTipVei	:= {}
			aPesCub	:= {}
			nQtdVol	:= 0
			nValor	:= 0
			nPeso	:= 0
			nPesoM3	:= 0
			nMetro3	:= 0
			nSeguro	:= 0
			nQtdUni	:= 0
			nKMNF      := 0
			nPesoCol   := 0

			AAdd(aMsgErr,{ STR0191 + ; //-- "Valor do frete zerado. Verifique a quantidade de volumes, peso e valor dos documentos do cliente. "
				STR0192 + AllTrim(aLote[nCntFor,LTSERNFC]) + STR0193 + AllTrim(aLote[nCntFor,LTNUMNFC]),'00',''}) //-- "SÈrie: " ", Documento: "
			AaddMsgErr(aMsgErr, @aVisErr)

			Loop
		EndIf

		//-- Calcula a composicao do frete
		aFrete := {}
		aMsgErr:= {}
		aFreteCol:= {}
		If lIgualCot
			If !Empty(aLote[nCntFor,LTFILCFS])
				cFilAtu := aLote[nCntFor,LTFILCFS]
			Else
				cFilAtu := cFilAnt
			EndIf
			//-- Obtem a composicao de frete da cotacao
			TmsViewFrt('4',cFilAtu,aLote[nCntFor,LTNUMCOT],,aLote[nCntFor,LTCODPRO],,,aFrete)
		//-- Rateia o valor do frete defindo no lote
		ElseIf !Empty(cFilLot) .And. !Empty(cLotCot)
			If !Empty(cLotCot)
				//-- Documento de Transporte
				DC5->(dbSetOrder(1)) //DC5_FILIAL+DC5_SERVIC+DC5_ORDEM
				DC5->(MsSeek(xFilial("DC5")+aLote[nCntFor,LTSERVIC]))

				//-- Calcula o ICMS da cotacao
				aFrete := {}
				If lIdentDoc .And. Empty(DC5->DC5_DOCTMS)
					cDocTms := aLote[ nCntFor, LTDOCTMS ] 
					TmsA200Cot(aFrete,cLotCot,aLote[nCntFor,LTCLIDEV],aLote[nCntFor,LTLOJDEV],cDocTms,aLote[nCntFor,LTTIPFRE],aLote[nCntFor,LTCDRDES],cProGen,cTipoCli,aLote[nCntFor,LTCDRORI],aLote[nCntFor,LTCLIREM],aLote[nCntFor,LTLOJREM],aLote[nCntFor,LTCLIDES],aLote[nCntFor,LTLOJDES],cFilLot,aLote[nCntFor,LTTIPNFC],aLote[nCntFor,LTCDRCAL])
				Else
					TmsA200Cot(aFrete,cLotCot,aLote[nCntFor,LTCLIDEV],aLote[nCntFor,LTLOJDEV],DC5->DC5_DOCTMS,aLote[nCntFor,LTTIPFRE],aLote[nCntFor,LTCDRDES],cProGen,cTipoCli,aLote[nCntFor,LTCDRORI],aLote[nCntFor,LTCLIREM],aLote[nCntFor,LTLOJREM],aLote[nCntFor,LTCLIDES],aLote[nCntFor,LTLOJDES],cFilLot,aLote[nCntFor,LTTIPNFC],aLote[nCntFor,LTCDRCAL])
				EndIf
				aContrt := TMSContrat( aLote[nCntFor,LTCLICAL],aLote[nCntFor,LTLOJCAL],, aLote[nCntFor,LTSERVIC], .F., aLote[nCntFor,LTTIPFRE],,,aLote[nCntFor,LTCLIREM],aLote[nCntFor,LTLOJREM],aLote[nCntFor,LTCLIDES],aLote[nCntFor,LTLOJDES],aLote[nCntFor,LTTIPTRA],aLote[nCntFor,LTCLIDEV],aLote[nCntFor,LTLOJDEV],aLote[nCntFor,LTTIPNFC],,,,,,aLote[nCntFor,LTCODNEG])
				nVlCot  := TM200ValCot(cFilLot,cLotCot,nPeso,nValor,nQtdVol)
				For nA := 1 To Len(aFrete)
					lTaxa    := TMSAComTax(aFrete[nA,3])
					nPercent := Round(aFrete[nA,2]/aFrete[nA,6],2)

					If nCntFor <> Len(aLote)

						If !lTaxa .Or. (lTaxa .And. (Len(aContrt) > 0 .And. aContrt[1,23] <> "2"))
							aFrete[nA,2] := Round(aFrete[nA,2]*nVlCot,2)
							aFrete[nA,6] := Round(aFrete[nA,2]/nPercent,2)
						EndIf

						If lAcumCot
							AAdd( aAcumCot, { aFrete[nA,2], aFrete[nA,6] } )
						Else
							aAcumCot[nA,1] += aFrete[nA,2]
							aAcumCot[nA,2] += aFrete[nA,6]
						Endif
					Else
						If !Empty(aAcumCot)
							nVlRat := Round(IIF(	aFrete[nA,2] >= aAcumCot[nA,1],;
													aFrete[nA,2]  - aAcumCot[nA,1],;
													aAcumCot[nA,1] - aFrete[nA,2])/nPercent,2)

							If !lTaxa .Or. (lTaxa .And. (Len(aContrt) > 0 .And. aContrt[1,23] <> "2"))
								aFrete[nA,2] := IIF(	aFrete[nA,2] >= aAcumCot[nA,1],;
														aFrete[nA,2]  - aAcumCot[nA,1],;
														aAcumCot[nA,1] - aFrete[nA,2])
								aFrete[nA,6] := Round(aFrete[nA,2]/nPercent,2)
							EndIf
						EndIf
					EndIf

					If aFrete[nA,3] <> 'TF'
						If nVlRat <> 0
							nTotLot += nVlRat
							nVlRat  := 0
						Else
							If !lTaxa .Or. (lTaxa .And. (Len(aContrt) > 0 .And. aContrt[1,23] <> "2"))
								nTotLot += aFrete[nA,6]
							EndIf
						EndIf
					EndIf
				Next nA

				lAcumCot := .F.
				//-- Efetua o acerto na diferenca do rateio
				If nCntFor == Len(aLote)
					cQuery := " SELECT SUM(DT8_VALTOT) DT8_VALTOT "
					cQuery += " 	FROM " + RetSqlName("DT8")
					cQuery += " 	WHERE DT8_FILIAL = '" + xFilial("DT8") + "' "
					cQuery += " 		AND DT8_FILORI = '" + cFilLot + "' "
					cQuery += " 		AND DT8_NUMCOT = '" + cLotCot + "' "
					cQuery += " 		AND DT8_CODPAS = 'TF' "
					cQuery += " 		AND D_E_L_E_T_ = ' ' "
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
					nTotCot := (cAliasQry)->DT8_VALTOT
					(cAliasQry)->(DbCloseArea())
					RestArea( aAreaAnt )
					If nTotCot <> nTotLot
						For nA := 1 To Len(aFrete)
							nValDif := nTotCot-nTotLot
							nTotLot -= aFrete[nA,6]
							aFrete[nA,2] := Round(( aFrete[nA,6]+nValDif ) * (nPercent),2)
							aFrete[nA,6] := 0
							nTotLot += Round(aFrete[nA,2]/nPercent,2)
						Next nA
					EndIf
				EndIf
			EndIf
		Else
			If lCRTAuto
				lCalFret := .F.
				//-- Obtem a composicao de frete do CRT
				TMSFrtCRT(cFilAnt,cLotNfc,aLote[nCntFor,LTTIPFRE],cTabFre,cTipTab,@cSeqTab,aLote[nCntFor,LTCODPRO],cCdrOri,aLote[nCntFor,LTCDRCAL],aFrete)
			Else
				lCalFret := .T.
			EndIf
			If lCalFret
				DTL->(dbSetOrder(1)) //DTL_FILIAL+DTL_TABFRE+DTL_TIPTAB
				If DTL->(MsSeek(xFilial("DTL")+cTabFre+cTipTab))
					nMoedaTb := DTL->DTL_MOEDA
				EndIf
				If nMoedaTb == 0
					nMoedaTb := 1
				EndIf
				If lRateio
					Aadd( aRatTDA, { aLote[ nCntFor, LTEXCTDA ], aLote[ nCntFor, LTDEVTDA ], aLote[ nCntFor, LTREMTDA ], aLote[ nCntFor, LTDESTDA ] } )
				EndIf
				nValorMd := Iif(aLote[ nCntFor, LTMOENFC ]==nMoedaTb, nValor, xMoeda(nValor, aLote[ nCntFor, LTMOENFC ], nMoedaTb))
				//-- Verifica se ja foi calculado o componente praca de pedagio para
				lPrcPdg := Ascan(aPrcPdg, { |x| x[1]+x[2] == aLote[nCntFor,LTCLIDEV]+aLote[nCntFor,LTLOJDEV] } ) == 0

				If aLote[ nCntFor, LTSERTMS ] == "1"
					If DDA->(ColumnPos("DDA_BLQCOL")) > 0 .And. DDC->(ColumnPos("DDC_BLQCOL")) > 0
						lBlqCol := (TmsSobServ('BLQCOL',.T.,.T.,cNContr,aLote[nCntFor,LTCODNEG],aLote[nCntFor,LTSERVIC],"0",@nAdiDoc) $ " 1")
					EndIf
				Else
					If DDA->(ColumnPos("DDA_CBRCOL")) > 0 .And. DDC->(ColumnPos("DDC_CBRCOL")) > 0
						lCbrCol := (TmsSobServ('CBRCOL',.T.,.T.,cNContr,aLote[nCntFor,LTCODNEG],aLote[nCntFor,LTSERVIC],"0",@nAdiDoc) $ " 1")
					EndIf
				EndIf

				aFrete  := TMSCalFret(cTabFre,cTipTab,@cSeqTab,cCdrOri,;
				aLote[ nCntFor, LTCDRCAL ],aLote[nCntFor,LTCLICAL],aLote[nCntFor,LTLOJCAL],If(lPrcProd,aLote[nCntFor,LTCODPRO],Space(Len(SB1->B1_COD))),;
				aLote[ nCntFor, LTSERVIC ],aLote[nCntFor,LTSERTMS],aLote[nCntFor,LTTIPTRA],cNContr,aMsgErr,aNfCTRC,nValorMd,nPeso,;
				nPesoM3,@nPesoCob,nQtdVol,0,nSeguro,nMetro3,0,0,Iif(DTP->DTP_CRIRAT == 'A',DTP->DTP_KM,aLote[nCntFor,LTKM]),0,,lCliGen,;
				aLote[nCntFor,LTAJUSTE],0,nQtdUni,nValDPC,0,0,aValInf,aTipVei,aLote[nCntFor,LTDOCTMS],,,,,,,,,cLotNfc,aPesCub,@lPrcPdg,aLote[ nCntFor, LTCLIDEV ],;
				aLote[ nCntFor, LTLOJDEV ], aLote[ nCntFor, LTMOEDA  ], aLote[ nCntFor, LTEXCTDA ], aLote[ nCntFor, LTDEVTDA ],;
				aLote[ nCntFor, LTREMTDA ], aLote[ nCntFor, LTDESTDA ],,aLote[ nCntFor, LTCLIDES ], aLote[ nCntFor, LTLOJDES ],aLote [nCntFor, LTSQEDES],;
				nSeqDoc, lRateio, aBaseRat, , aLote [nCntFor, LTCODNEG], @aTaxDev, @aFreteCol, lCbrCol, lBlqCol)

				//-- Prefixa as mensagens de erro quando Rateio, para facilitar a identificaÁ„o.
				cPrefixErr := ""
				If Len( aMsgErr ) > 0 .And. Len(aNfCTRC) > 0 .And. ValType(aNfCTRC[1]) == "A" .And. Len(aNfCTRC[1]) > 0 .And. ValType(aNfCTRC[1][1]) == "C" .And. ValType(aNfCTRC[1][2]) == "C"
					cPrefixErr := Iif(lRateio, STR0182 + "-[","[" ) +STR0029 + aNfCTRC[1][2] +", " + STR0038 + aNfCTRC[1][1]+Iif(Len(aNfCTRC)>1,"/...","")+"] " //-- "Rateio" ## "Serie : " ## "Documento: "
					aEval(aMsgErr,{|x,y| aMsgErr[y][1] := cPrefixErr + aMsgErr[y][1] })
				EndIf

				If nPesoCob == 0
					nPesoCob := Iif( nPesoM3 > nPeso, nPesoM3, nPeso)
				EndIf

				//Neste trecho, verifica se teve erro em algum componente TDA calculado no TMSCalFret e caso tenha, mostra aviso para usuario e com possiveis erros.
				For nY := 1 to Len(aFrete)
				    If (Len(aFrete[nY]) > 23)
				         If(aFrete[nY][24])
					         If (Aviso( 'N„o foi possÌvel calcular o componente TDA',;
					                    STR0167 + CRLF + ' - ' +;             //"Verifica os seguintes campos:"
					                    STR0168 + CRLF + ' - ' +;             //"Paga TDA no perfil do cliente"
					                    STR0169 + CRLF + ' - ' +;             //"TDA no cadastro de cliente"
					                    STR0170 + CRLF + ' - ' +;             //"Descon. TDA na entrada do documento"
					                    STR0171 + CRLF + ' - ' +;             //"Se Paga TDA no perfil do cliente estiver preenchido com 3 (Coleta e Entrega) ser· obrigatÛrio informar a SequÍncia de endereÁo do destinat·rio para calcular o TDA."
					                    STR0176 + CRLF + ' - ' +;             //"Se Paga TDA no perfil do cliente estiver preenchido com 3 (Coleta e Entrega)   È obrigatÛrio informar TDA no endereÁo de solicitante."
					                    STR0175 + CRLF + CHR(13) + CHR(10) +; //"TDA no EndereÁo do solicitante"
					                    STR0174,;                             //"Deseja continuar"
					                    {'Sim','N„o'}, 3) == 2)
						           nX := (Len(aFrete) + 1)
						           Return .F.
						     EndIf
						EndIf
					EndIf
				Next nY

			EndIf
		EndIf

		nSeek := Ascan( aFrete,{|x| x[3] == 'TF' })

		If	Empty( nSeek ) .Or. Empty(Round(aFrete[ nSeek, 2 ], 2)) .Or. nSeek != Len(aFrete) .Or. Len( aMsgErr ) > 0
			If !Empty( nSeek ) .And. Empty(Round(aFrete[ nSeek, 2 ], 2))
				//-- Prefixa as mensagens de erro quando Rateio, para facilitar a identificaÁ„o.
				cPrefixErr := ""
				If Len(aNfCTRC) > 0 .And. ValType(aNfCTRC[1]) == "A" .And. Len(aNfCTRC[1]) > 0 .And. ValType(aNfCTRC[1][1]) == "C" .And. ValType(aNfCTRC[1][2]) == "C"

					cPrefixErr := Iif( lRateio, STR0182+"-[","[") +STR0029 + aNfCTRC[1][2] +", " + STR0038 + aNfCTRC[1][1]+Iif(Len(aNfCTRC)>1,"/...","")+"] " //-- "Rateio" ## "Serie : " ## "Documento: "
				EndIf
				If aLote[nCntFor,LTSERTMS] != "1" .Or. lBlqCol
					AAdd(aMsgErr,{cPrefixErr + STR0050,'00',''}) //"Valor do frete zerado"
				EndIf
			ElseIf nSeek != Len(aFrete)
				AAdd(aMsgErr,{cPrefixErr + STR0051,'00',''}) //"Falha na linha totalizadora da composiÁ„o do frete"
			EndIf
			//-- Informa que nao localizou o contrato
			If Len(aContrCli) <= 0
				Aadd(aMsgErr,{STR0195 + aLote[nCntFor,LTCLICAL] + "-" + aLote[nCntFor, LTLOJCAL],'00',''}) //"Contrato do Cliente n„o localizado"
			EndIf

			If Len( aMsgErr ) > 0
				AaddMsgErr( aMsgErr, @aVisErr)
			EndIf

			aNfCTRC := {}
			aValInf := {}
			aTipVei := {}
			aPesCub := {}
			aCteAnt := {}
			nQtdVol := 0
			nValor  := 0
			nPeso   := 0
			nPesoM3 := 0
			nMetro3 := 0
			nSeguro := 0
			nQtdUni := 0
			nKMNF   := 0
			nValDPC := 0
			nPesoCol := 0
			Loop
		EndIf

		//-- Verifica se devera ser calculado novamente o calculo do componente praca por pedagio.
		If !lPrcPdg
			If Ascan(aPrcPdg, { |x| x[1]+x[2] == aLote[nCntFor,LTCLIDEV]+aLote[nCntFor,LTLOJDEV] } ) == 0
				AAdd(aPrcPdg, { aLote[nCntFor,LTCLIDEV], aLote[nCntFor,LTLOJDEV] } )
			EndIf
		EndIf


		//-- Calcula com a tabela alternativa
		//-- Obs: A tabela alternativa sera considerada somente se nao houver cotacao
		If !Empty( aLote[ nCntFor, LTTABALT ] ) .And. !lCotacao .And. !lCRTAuto
			//-- Guardar o total do frete em ntotfre da composicao obtida acima
			If nSeek > 0
				nTotFre := aFrete[ nSeek, 2 ]
			EndIf
			aFrtAlt := {}
			aMsgErr := {}
			cTabAlt := aLote[ nCntFor, LTTABALT ]
			cTipAlt := aLote[ nCntFor, LTTIPALT ]
			cSeqAlt := StrZero(0,TamSx3("DVC_SEQTAB")[1])

			If lIgualCot
				If !Empty(aLote[nCntFor,LTFILCFS])
					cFilAtu := aLote[nCntFor,LTFILCFS]
				Else
					cFilAtu := cFilAnt
				EndIf
				//-- Obtem a composicao de frete da cotacao
				TmsViewFrt('4',cFilAtu,aLote[nCntFor,LTNUMCOT],,aLote[nCntFor,LTCODPRO],,,aFrtAlt)
			//-- Rateia o valor do frete defindo no lote
			ElseIf !Empty(cFilLot) .And. !Empty(cLotCot)
				If !Empty(cLotCot)
					//-- Documento de Transporte
					DC5->(dbSetOrder(1)) //DC5_FILIAL+DC5_SERVIC+DC5_ORDEM
					DC5->(MsSeek(xFilial("DC5")+aLote[nCntFor,LTSERVIC]))
					//-- Calcula o ICMS da cotacao
					If lIdentDoc .And. Empty(DC5->DC5_DOCTMS)
						cDocTms := aLote[ nCntFor, LTDOCTMS ] 
						TmsA200Cot(aFrtAlt,cLotCot,aLote[nCntFor,LTCLIDEV],aLote[nCntFor,LTLOJDEV],cDocTms,aLote[nCntFor,LTTIPFRE],aLote[nCntFor,LTCDRDES],aLote[nCntFor,LTCODPRO],cTipoCli,aLote[nCntFor,LTCDRORI],aLote[nCntFor,LTCLIREM],aLote[nCntFor,LTLOJREM],aLote[nCntFor,LTCLIDES],aLote[nCntFor,LTLOJDES],cFilLot,aLote[nCntFor,LTTIPNFC],aLote[nCntFor,LTCDRCAL])
					Else
						TmsA200Cot(aFrtAlt,cLotCot,aLote[nCntFor,LTCLIDEV],aLote[nCntFor,LTLOJDEV],DC5->DC5_DOCTMS,aLote[nCntFor,LTTIPFRE],aLote[nCntFor,LTCDRDES],aLote[nCntFor,LTCODPRO],cTipoCli,aLote[nCntFor,LTCDRORI],aLote[nCntFor,LTCLIREM],aLote[nCntFor,LTLOJREM],aLote[nCntFor,LTCLIDES],aLote[nCntFor,LTLOJDES],cFilLot,aLote[nCntFor,LTTIPNFC],aLote[nCntFor,LTCDRCAL])
					EndIf
					For nA := 1 To Len(aFrtAlt)
						aFrtAlt[nA,2] := Round(TM200ValCot(cFilLot,cLotCot,nPeso,nValor,nQtdVol)*aFrtAlt[nA,2],2)
						aFrtAlt[nA,5] := Round(TM200ValCot(cFilLot,cLotCot,nPeso,nValor,nQtdVol)*aFrtAlt[nA,5],2)
						aFrtAlt[nA,6] := Round(TM200ValCot(cFilLot,cLotCot,nPeso,nValor,nQtdVol)*aFrtAlt[nA,6],2)
					Next nA
				EndIf
			Else
				If lTM200CUB
					nPesoPto := ExecBlock("TM200CUB",.F.,.F.,{aLote[ nCntFor, LTCLIDEV ], aLote[ nCntFor, LTLOJDEV ], nPesoM3, nPeso, aLote[ nCntFor, LTTIPFRE ], aLote[ nCntFor, LTSERVIC ], aLote[ nCntFor, LTTIPTRA ], aLote[ nCntFor, LTSERTMS ], aLote[nCntFor,LTCLICAL],aLote[nCntFor,LTLOJCAL],aLote[nCntFor,LTCODNEG] })
					If ValType(nPesoPto) == "N"
						nPesoM3 := nPesoPto
					EndIf
				EndIf
				DTL->(dbSetOrder(1)) //DTL_FILIAL+DTL_TABFRE+DTL_TIPTAB
				If DTL->(MsSeek(xFilial("DTL")+cTabAlt+cTipAlt))
					nMoedaTb := DTL->DTL_MOEDA
				EndIf
				If nMoedaTb == 0
					nMoedaTb := 1
				EndIf
				nValorMd := Iif(aLote[ nCntFor, LTMOENFC ]==nMoedaTb, nValor, xMoeda(nValor, aLote[ nCntFor, LTMOENFC ], nMoedaTb))
				//-- Verifica se ja foi calculado o componente praca de pedagio para
				lPrcPdg := Ascan(aPrcPdg, { |x| x[1]+x[2] == aLote[nCntFor,LTCLIDEV]+aLote[nCntFor,LTLOJDEV] } ) == 0


				aFrtAlt := TMSCalFret(cTabAlt,cTipAlt,@cSeqAlt,cCdrOri,aLote[nCntFor,LTCDRCAL],;
				aLote[ nCntFor, LTCLICAL ], aLote[nCntFor,LTLOJCAL],If(lPrcProd,aLote[nCntFor,LTCODPRO],Space(Len(SB1->B1_COD))),aLote[nCntFor,LTSERVIC],;
				aLote[ nCntFor, LTSERTMS ], aLote[nCntFor,LTTIPTRA],aLote[nCntFor,LTNCONTR],aMsgErr,aNfCTRC,nValorMd,nPeso,nPesoM3,;
				@nPesoCob,nQtdVol,0,nSeguro,nMetro3,0,0,Iif(DTP->DTP_CRIRAT == 'A',DTP->DTP_KM,aLote[nCntFor,LTKM]),0,,lCliGen,aLote[nCntFor,LTAJUSTE],0,;
				nQtdUni,nValDPC, 0,0,aValInf,aTipVei,aLote[nCntFor,LTDOCTMS],,,,,,,,,cLotNfc,aPesCub,@lPrcPdg,aLote[ nCntFor, LTCLIDEV ],;
				aLote[ nCntFor, LTLOJDEV ], aLote[ nCntFor, LTMOEDA  ], aLote[ nCntFor, LTEXCTDA ], aLote[ nCntFor, LTDEVTDA ],;
				aLote[ nCntFor, LTREMTDA ], aLote[ nCntFor, LTDESTDA ],,aLote[ nCntFor, LTCLIDES ], aLote[ nCntFor, LTLOJDES ],aLote [nCntFor, LTSQEDES],;
				nSeqDoc, lRateio, aBaseRat, , aLote [nCntFor, LTCODNEG], @aTaxDev, @aFreteCol, lCbrCol, lBlqCol)
					If nPesoCob == 0
						nPesoCob := Iif( nPesoM3 > nPeso, nPesoM3, nPeso)
					EndIf
			EndIf

			//-- Total do frete, obtido com a tabela alternativa
			nSeek := Ascan( aFrtAlt,{|x| x[3] == 'TF' })
			//-- Qd for tabela alternativa
			//-- Envia a mensagem somente se a linha totalizadora nao for o ultimo elemento
			//-- ou nao for encontrada no vetor aFrtAlt.
			If	Empty( nSeek ) .Or. nSeek != Len(aFrtAlt)
				If nSeek != Len(aFrtAlt)
					AAdd(aMsgErr,{STR0051,'00',''}) //"Falha na linha totalizadora da composiÁ„o do frete"
				EndIf
				If	Len( aMsgErr ) > 0
					AaddMsgErr( aMsgErr, @aVisErr)
				EndIf
				aNfCTRC	:= {}
				aValInf	:= {}
				aTipVei	:= {}
				aPesCub	:= {}
				aCteAnt := {}
				nQtdVol	:= 0
				nValor	:= 0
				nPeso	:= 0
				nPesoM3	:= 0
				nMetro3	:= 0
				nSeguro	:= 0
				nQtdUni	:= 0
				nKMNF   	:= 0
				nValDPC 	:= 0
				nPesoCol    := 0
				Loop
			EndIf

			//-- Verifica se devera ser calculado novamente o calculo do componente praca por pedagio.
			If !lPrcPdg
				If Ascan(aPrcPdg, { |x| x[1]+x[2] == aLote[nCntFor,LTCLIDEV]+aLote[nCntFor,LTLOJDEV] } ) == 0
					AAdd( aPrcPdg, { aLote[nCntFor,LTCLIDEV], aLote[nCntFor,LTLOJDEV] } )
				EndIf
			EndIf


			If nSeek > 0
				nTotAlt := aFrtAlt[ nSeek, 2 ]
			EndIf

			lTabAlt := .F.
			//-- Considera o maior valor obtido entre as tabelas de frete e alternativa
			If nTotAlt > nTotFre
				aFrete	:= {}
				aFrete	:= aClone( aFrtAlt )
				cTabFre	:= cTabAlt
				cTipTab	:= cTipAlt
				cSeqTab	:= cSeqAlt
				lTabAlt := .T.
				aFreteCol	:= {}
			EndIf
		EndIf

		//-- Compara o total da composicao de frete; Cotacao de frete X documento, para aplicar o calculo do ICMS da cotacao
		If	lCotacao
			//-- Aplica na composicao do Frete, o desconto dado na Cotacao de Frete
			If !lIgualCot
				If DT4->DT4_DESC > 0 .Or. DT4->DT4_ACRESC > 0
					For n1Cnt := 1 To Len(aFrete)
						If aFrete[ n1Cnt, 3 ] != 'TF'
							If DT4->DT4_DESC > 0
								//-- Verifica se o componente aceita desconto
								DT3->(DbSetOrder(1)) //B1_FILIAL+B1_COD
								DT3->(MsSeek(xFilial("DT3")+aFrete[ n1Cnt, 3]))
								lAplDes  := DT3->DT3_APLDES==StrZero( 1, Len( DT3->DT3_APLDES ) )
								nValComp := TmsA040Pct(lAplDes, aFrete[ n1Cnt, 2 ], DT4->DT4_DESC)
							ElseIf DT4->DT4_ACRESC > 0
								nValComp := TmsA200Acr(aFrete[ n1Cnt, 2 ], DT4->DT4_ACRESC)
							EndIf
							//-- Atualiza o Valor do Componente
							aFrete[ n1Cnt , 2 ] := nValComp
							nValTot += nValComp
						Else
							//-- Atualiza o Valor Total do Frete
							aFrete[ n1Cnt , 2 ] := nValTot
						EndIf
					Next
				EndIf
				nValTot := 0
				DT8->(DbSetOrder(1)) //DT8_FILIAL+DT8_FILORI+DT8_NUMCOT+DT8_CODPRO+DT8_CODPAS
				cQuery := " SELECT DT8_CODPAS,DT8_DESC,DT8_ACRESC "
				cQuery += " 	FROM " + RetSqlName("DT8")
				If !Empty(aLote[ nCntFor, LTFILCFS ])
					cQuery += " WHERE DT8_FILIAL = '" + xFilial("DT8") + "' "
					cQuery += "   AND DT8_FILORI = '" + aLote[ nCntFor, LTFILCFS ] + "' "
				Else
					cQuery += " WHERE DT8_FILIAL = '" + xFilial("DT8") + "' "
					cQuery += "   AND DT8_FILORI = '" + cFilAnt + "' "
				EndIf
				cQuery += " AND DT8_NUMCOT = '" + aLote[ nCntFor, LTNUMCOT ] + "' "
				cQuery += " AND DT8_CODPRO = '" + aLote[ nCntFor, LTCODPRO ] + "' "
				cQuery += " AND D_E_L_E_T_ = ' ' "
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
				Do While !(cAliasQry)->(Eof())
					nSeek := Ascan(aFrete, {|x| x[3] == (cAliasQry)->DT8_CODPAS })
					If nSeek > 0
						If aFrete[ nSeek, 3 ] != 'TF'
							nValComp := aFrete[ nSeek, 2 ]
							//-- Se o componente teve % de desconto informado
							If (cAliasQry)->DT8_DESC > 0
								nValComp := TmsA040Pct(.T., aFrete[ nSeek, 2 ], (cAliasQry)->DT8_DESC)
							//-- Se o componente teve % de acrescimo informado
							ElseIf (cAliasQry)->DT8_ACRESC > 0
								nValComp := TmsA200Acr(aFrete[ nSeek, 2 ], (cAliasQry)->DT8_ACRESC)
							EndIf
							//-- Atualiza o Valor do Componente
							aFrete[ nSeek , 2 ] := nValComp
							nValTot += nValComp
						Else
							//-- Atualiza o Valor Total do Frete
							aFrete[ nSeek , 2 ] := nValTot
						EndIf
					EndIf
					(cAliasQry)->(dbSkip())
				EndDo
				(cAliasQry)->(DbCloseArea())
			Else
				If	!Empty(cSeqTCot)
					cSeqTab := cSeqTCot
				EndIf
				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Assume o Tipo de Cliente( Consumidor Final/Solidario/Etc ) ≥
				//≥do destinatario do documento para calculo dos impostos com ≥
				//≥as informacoes da regiao destino.                          ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				//-- Tipo do Cliente Destinatario - Conforme solicitacao do bops 102588
				TMSA200Cli( aLote[nCntFor,LTCLIDES], aLote[nCntFor,LTLOJDES])   //posiciona na tabela SA1
				cTipoCli := SA1->A1_TIPO

				//-- Documento de Transporte
				DC5->(dbSetOrder(1)) //DC5_FILIAL+DC5_SERVIC+DC5_ORDEM
				DC5->(MsSeek(xFilial("DC5")+aLote[nCntFor,LTSERVIC]))

				//-- Calcula o ICMS da cotacao
				If lIdentDoc .And. Empty(DC5->DC5_DOCTMS)
					cDocTms := aLote[ nCntFor, LTDOCTMS ] 
					TmsA200Cot(aFrete,aLote[ nCntFor, LTNUMCOT ],aLote[nCntFor,LTCLIDEV],aLote[nCntFor,LTLOJDEV],cDocTms,aLote[nCntFor,LTTIPFRE],aLote[nCntFor,LTCDRDES],aLote[nCntFor,LTCODPRO],cTipoCli,aLote[nCntFor,LTCDRORI],aLote[nCntFor,LTCLIREM],aLote[nCntFor,LTLOJREM],aLote[nCntFor,LTCLIDES],aLote[nCntFor,LTLOJDES],aLote[nCntFor,LTFILCFS],aLote[nCntFor,LTTIPNFC],aLote[nCntFor,LTCDRCAL])
				Else
					TmsA200Cot(aFrete,aLote[ nCntFor, LTNUMCOT ],aLote[nCntFor,LTCLIDEV],aLote[nCntFor,LTLOJDEV],DC5->DC5_DOCTMS,aLote[nCntFor,LTTIPFRE],aLote[nCntFor,LTCDRDES],aLote[nCntFor,LTCODPRO],cTipoCli,aLote[nCntFor,LTCDRORI],aLote[nCntFor,LTCLIREM],aLote[nCntFor,LTLOJREM],aLote[nCntFor,LTCLIDES],aLote[nCntFor,LTLOJDES],aLote[nCntFor,LTFILCFS],aLote[nCntFor,LTTIPNFC],aLote[nCntFor,LTCDRCAL])
				EndIf
				//-- Total do frete, obtido com a cotacao de frete
				nSeek := Ascan( aFrete,{|x| x[3] == 'TF' })

				//-- Se o Valor Calculado for diferente que o Valor Cotado, recalcular os valores
				//-- para manter o valor Cotado
				If nSeek > 0 .And. aFrete[ nSeek, 6 ] <> nVlTotCot
					//-- Inicializa variaveis totalizadoras
					nValTot  := 0
					nValImp  := 0
					nValComp := 0
					For n1Cnt:=1 To Len(aFrete)
						If aFrete[n1Cnt,3] <> 'TF'
							If !Empty(aLote[ nCntFor, LTFILCFS ])
								cSeek   := xFilial("DT8") + aLote[ nCntFor, LTFILCFS ] + aLote[ nCntFor, LTNUMCOT ] + aLote[nCntFor,LTCODPRO]
							Else
								cSeek   := xFilial("DT8") + cFilAnt + aLote[ nCntFor, LTNUMCOT ] + aLote[nCntFor,LTCODPRO]
							EndIf
							DT8->(DbSetOrder(1)) //DT8_FILIAL+DT8_FILORI+DT8_NUMCOT+DT8_CODPRO+DT8_CODPAS
							DT8->(MsSeek(cSeek+aFrete[n1Cnt,3]))
							nOldValCImp := DT8->DT8_VALTOT
							nOldValSImp := aFrete[n1Cnt,2] // Valor do Frete sem Imposto
							nNewValCImp := aFrete[n1Cnt,6] // Valor do Frete com Imposto
							If nNewValCImp > nOldValSImp
								nPercent :=  ( 1 - Round(nOldValSImp/nNewValCImp,2) )
								aFrete[n1Cnt,5] := Round(nOldValSImp/(1-nPercent),2) - aFrete[n1CNt,2]  //Round(nOldValCImp * nPercent,2)
								aFrete[n1Cnt,2] := nOldValCImp - aFrete[n1Cnt,5]
							//-- Se nao houver imposto, assume o valor com imposto da cotacao
							ElseIf aFrete[n1Cnt,5] == 0
								aFrete[n1Cnt,2] := nOldValCImp // Novo Valor do Frete sem Imposto
							EndIf
							nValImp  += aFrete[n1Cnt,5]
							nValComp += aFrete[n1Cnt,2]
							nValTot  += aFrete[n1Cnt,2] + aFrete[n1Cnt,5]
						Else
							aFrete[n1Cnt,2] := nValComp
							aFrete[n1Cnt,5] := nValImp
							aFrete[n1Cnt,6] := nValTot
							nValDif := nVlTotCot - Round(nValComp/(nValComp/nValTot),2)
						EndIf
					Next
					//-- Verifica se existe diferenca de arredondamento
					If nValDif <> 0
						//-- Procura o 1o. componente que tenha valor e subtrai a diferenca
						nSeek := Ascan(aFrete, { |x| x[3] <> 'TF' .And. x[2] <> 0 })
						If nSeek > 0
							aFrete[nSeek,2] += nValDif // Valor do componente sem Imposto
						EndIf
						//-- Total do frete
						nSeek := Ascan(aFrete,{|x| x[3] == 'TF' })
						If nSeek > 0
							aFrete[nSeek,2] += nValDif	// Valor Total do Frete sem Imposto
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf

		lRet := .T.

		// Sendo um Processo de Rateio e Existindo Algum Erro no Calculo //
		// do Frete de qualquer Nota Fiscal, todo o processamento devera //
		// ser abortado pois para Rateio se faz necessario o calculo de  //
		// todas as Notas Fiscais do Lote.                               //
		If lRateio .And. Len(aVisErr) > 0
        	lRet := .F.
		EndIf

		If lRet
			//-- Analisa agrupamento de clientes
			lRet := TmsA200Agr(aFrete,aNfCTRC,@aVisErr,cLotNfc,cTabFre,cTipTab,cSeqTab,aLote[nCntFor,LTNCONTR],aLote[nCntFor,LTSERVIC],.F.,.F.,nQtdVol,nValor,nPeso,nPesoM3,nPesoCob,nMetro3,nSeguro,nCntFor,aValInf,aTipVei,aPesCub,nKMNF,aLote[nCntFor,LTCODNEG],nPesoCol, aFreteCol)
		EndIf

		aNfCTRC	:= {}
		aValInf	:= {}
		aTipVei	:= {}
		aPesCub	:= {}
		aCteAnt	:= {}
		nQtdVol	:= 0
		nValor	:= 0
		nPeso	:= 0
		nPesoM3	:= 0
		nMetro3	:= 0
		nSeguro	:= 0
		nQtdUni	:= 0
		nKMNF   := 0
		nValDPC := 0
		nPesoCol := 0
	EndIf

Next
If lRateio .And. (Len(aVisErr) > 0)
	aMsgErr := {}

	AAdd( aMsgErr, {STR0140, '99', 'TMSA200()' } ) // Para EfetivaÁ„o do Calculo de Rateio TODAS as Notas Fiscais devem ser Calculadas

	If	Len( aMsgErr ) > 0
		AaddMsgErr( aMsgErr, @aVisErr)
	EndIf
	lRet:= .F.
EndIf

//-- Suprime mensagens repetidas
nCntFor := 1
aMsgErr := {}
If Len(aVisErr) > 1
    While nCntFor <= (Len(aVisErr)-1)
          cMsg := aVisErr[nCntFor][1]
          nMsgPos := AScan(aVisErr, {|y| y[1] == cMsg},nCntFor+1)
          If nMsgPos > 0
              aDel(aVisErr,nMsgPos)
              aSize(aVisErr,Len(aVisErr)-1)
          EndIf
          nCntFor++
    EndDo
EndIf

ResetArr(@aFrete		)
ResetArr(@aFrtAlt		)
ResetArr(@aNfCTRC		)
ResetArr(@aValInf		)
ResetArr(@aTipVei		)
ResetArr(@aPesCub		)
ResetArr(@aSeqPFre      )
ResetArr(@aTpvCot		)
ResetArr(@aPrcPdg		)
ResetArr(@aAcumCot		)
ResetArr(@aContrt		)
ResetArr(@aBaseRat		)
ResetArr(@aCteAnt       )
ResetArr(@aTaxDev       )
ResetArr(@aVlrInf  )
ResetArr(@aFreteCol		)
ResetArr(@aContrCli		)
RestArea( aAreaAnt )

Return( lRet )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200Qbr≥ Autor ≥ Alex Egydio           ≥ Data ≥06.02.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Controla a quebra da sequencia de notas fiscais do cliente ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA200Qbr()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpC1 = Chave de sequencia de notas fiscais do cliente     ≥±±
±±≥          ≥ ExpN1 = Item do lote de notas fiscais do cliente           ≥±±
±±≥          ≥ ExpN2 = Qtde de notas fiscais do cliente                   ≥±±
±±≥          ≥ ExpN3 = Qtde maxima de notas fiscais por conhecimento      ≥±±
±±≥          ≥ ExpN4 = Total do peso real das notas fiscais do cliente    ≥±±
±±≥          ≥ ExpN5 = Peso maximo por conhecimento                       ≥±±
±±≥          ≥ ExpL1 = .T. Considera quebra por Numero de notas por CTRC, ≥±±
±±≥          ≥         peso maximo por CTRC, etc...                       ≥±±
±±≥          ≥ ExpA1 = Notas fiscais                                      ≥±±
±±≥          ≥ ExpC2 = Interfere no agrupamento de notas qd ExpL1 = .T.   ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TMSA200Qbr( cChave, nCntFor, nQtNotas, nNfCTRC, nPeso, nPesCTRC, lAgrupa, aNfCTRC, cAgrNfc, lCotacao, nMoeda, lRatCot )
Local lRet     := .F.
Local nItem    := nCntFor + 1
Local lTmsCFec := TmsCFec()

//-- Variaveis para controle de rateio de peso
Local nX       := 0
Local nTotPeso := 0
Local nSalPeso := 0
Local lRetorna := .F. // Utilizado para quebra por cotacao de Frete

DEFAULT lAgrupa  := .F.
DEFAULT cAgrNfc  := "1"
DEFAULT lCotacao := .F.
DEFAULT lRatCot  := .F. // Rateio por Cotacao de Frete

lValCol   := DTP->DTP_TIPLOT == StrZero(5,Len(DTP->DTP_TIPLOT))

//-- Em Caso De ValorizaÁ„o De Coleta Retornar Sempre .t.
If lValCol
	Return(.t.)
EndIf

If lAgrupa
	//-- Se no perfil do cliente o campo agrupa notas igual a 'Nao', despreza as quebras
	//-- e considera 1 nota por CTRC
	If !lCotacao .And. cAgrNfc == '2'
		lRet := .T.
	ElseIf !Empty( aNfCTRC[ nCntFor, 29 ]) .And. !Empty( aNfCTRC[ nCntFor, 30 ])
		//-- Se a Filial de Alianca (2o. Percurso) estiver preenchida e o CTRC do Despachante estiver preenchido,
		//-- a quebra das Notas Fiscais sera' feita somente por Filial de Alianca+CTRC do Despachante
		If	nItem > Len( aNfCTRC )
			lRet := .T.
		ElseIf cChave != TmsA200Lot(,aNfCTRC,,,,,,,,,,,'7',nItem)
			lRet := .T.
		EndIf
	Else
		If	nItem > Len( aNfCTRC )
			lRet := .T.
		ElseIf cChave != TmsA200Lot(,aNfCTRC,,,,,,,,,,,'6',nItem)
			lRet := .T.
		ElseIf !lCotacao
			If	Empty( aNfCTRC[ nCntFor, 24 ] ) //-- Numero da Cotacao
				//-- Atingiu o numero de notas por conhecimento e o peso da mercadoria esta informado.
				If	nQtNotas >= nNfCTRC .And. aNfCTRC[ nCntFor, 34 ] == "1" //-- Peso Informado (0=Nao; 1=Sim)
					lRet := .T.
				//-- Atingiu o peso maximo por conhecimento
				Else
					If nPesCTRC > 0
						If	nPeso + aNfCTRC[ nItem, 7 ] > nPesCTRC
							lRet := .T.
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	//-- Verifica a quebra na Carga Fechada
	If !lRet .And. !lCotacao .And. lTmsCFec
		lRet := TmsCFecQbr(aNfCTRC)
	EndIf

Else
	//-- Despachantes diferentes devem permanecer separados
    If  Len(aLote) >= nItem
        If aLote[ nCntFor, LTCLIDPC ] + aLote[ nCntFor, LTLOJDPC ] != aLote[ nItem, LTCLIDPC ] + aLote[ nItem, LTLOJDPC ]
       		lRet := .T.
        EndIf
    EndIf

	//-- Se a Filial de Alianca (2o. Percurso) estiver preenchida e o CTRC do Despachante estiver preenchido,
	//-- a quebra das Notas Fiscais sera' feita somente por Filial de Alianca+CTRC do Despachante
	If !Empty(aLote[ nCntFor, LTFILDPC ]) .And. !Empty(aLote[ nCntFor, LTCTRDPC ])
		//-- Verifica se houve quebra da Filial de Alianca (2o.Percurso) e CTRC do Despachante
		If nItem > Len( aLote )
			lRet := .T.
		ElseIf cChave != TmsA200Lot(,,,,,,,,,,,,'8',nItem)	//-- Retorna string, utilizado no preenchimento da variavel cChave
			lRet := .T.
		EndIf
	Else
		//-- Se no perfil do cliente o campo agrupa notas igual a 'Nao', despreza as quebras
		//-- e considera 1 nota por CTRC
		If !lCotacao .And. cAgrNfc == '2'
			lRet := .T.
		//-- Verifica se houve quebra do cliente agrupamento ou cliente remetente
		ElseIf nItem > Len( aLote )
			lRet := .T.
		ElseIf cAgrNfc <> '5' .And. cChave != TmsA200Lot(,,,,,,,,,,,,'5',nItem)	//-- Retorna string, utilizado no preenchimento da variavel cChave
			lRet := .T.
		ElseIf cAgrNfc == '5' .And. cChave != TmsA200Lot(,,,,,,,,,,,,'11',nItem)	//-- Retorna string, utilizado no preenchimento da variavel cChave
			lRet := .T.
		ElseIf Empty( aLote[ nCntFor, LTNUMCOT ] )
			//-- Atingiu o numero de notas por conhecimento e o peso da mercadoria esta informado.
			If cAgrNfc == '3' //-- Agrupa por documento
				If	nQtNotas >= nNfCTRC
					lRet := .T.
				Else
					//-- Atingiu o peso maximo por conhecimento
					If nPesCTRC > 0
						If	nPeso + aLote[ nCntFor, LTPESO ] > nPesCTRC
							lRet := .T.
						EndIf
					EndIf
				EndIf
			Else
				If cAgrNfc == '1' .And. nQtNotas >= nNfCTRC .And. lRatCot
					lRetorna := .T. // Variavel apenas para retornar sem rodar a qtde de quebra de rateio por peso
				EndIf
			EndIf
		EndIf
	EndIf
EndIf
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ-ƒƒƒƒƒƒƒƒƒƒ-ƒƒƒƒƒƒƒ-ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ-ƒƒƒƒƒƒ-ƒƒƒƒƒƒƒ-ƒƒƒƒƒƒƒ-ƒƒƒƒƒƒƒ-ƒƒ--ƒƒƒƒƒƒƒø±±
±±≥ Realiza rateio de peso quando exitir notas fiscais sem peso informado. Isso È necess·rio devido≥±±
±±≥ ao rateio do frete por peso que depende do peso das notas fiscais depedendo da condiÁ„o  de  a-≥±±
±±≥ grupamento do cliente.                                                                         ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ-ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
If lRet .And. Len(aNfCTRC) > 0 .And. !lRetorna
	If Ascan(aNfCTRC, {| e | e[LTPESONF] == 0}) > 0 // -- Existe alguma Nota com Peso Zerado
		nTotPeso:= 0
		For nX  := 1 To Len(aNfCTRC) // -- Qual o Peso Total da Nota dos clientes
			nTotPeso += aNfCTRC[nX,LTPESONF]
		Next nX
		If nTotPeso > 0
			nSalPeso:= nTotPeso
			nTotPeso:= Round(nTotPeso / Len(aNfCTRC),TamSX3("DT6_PESO")[2]) // -- Total do Peso / Qtde Total de Notas Fiscais
			For nX  := 1 To Len(aNfCTRC) // -- Re-gravando rateio de peso para as notas fiscais
				If nX == Len(aNfCTRC)
					aNfCTRC[nX][LTPESONF] := nSalPeso
				Else
					aNfCTRC[nX][LTPESONF] := nTotPeso
				EndIf
				nSalPeso -= nTotPeso
			Next nX
		EndIf
	EndIf
Else
	If lRetorna
		lRet := .T.
	EndIf
EndIf
Return( lRet )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200Sta≥ Autor ≥ Alex Egydio           ≥ Data ≥20.02.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Atualizando o Status do Lote                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA200Sta()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpL1 = Cancela processamento                              ≥±±
±±≥          ≥ ExpC1 = Numero do lote                                     ≥±±
±±≥          ≥ ExpC2 = Status - 1=Aberto;                                 ≥±±
±±≥          ≥                  2=Digitado;                               ≥±±
±±≥          ≥                  3=Calculado;                              ≥±±
±±≥          ≥                  4=Bloqueado;                              ≥±±
±±≥          ≥                  5=Erro de Gravacao.                       ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TMSA200Sta( lEnd, cLotNfc, cStatus, lLotBlq )

Local aAreaAnt	:= GetArea()
Local aAreaDTP	:= DTP->(GetArea())
Local cSeek		:= ''
Local lRet		:= .T.
Local cQuery	:= ""
Local cAliasQry	:= ""

DEFAULT lEnd	:= .F.
DEFAULT cLotNfc	:= ''
DEFAULT cStatus	:= ''
DEFAULT lLotBlq	:= .F.

//-- Avalia se ha documentos bloqueados no lote
If	lLotBlq
	SC9->(DbSetOrder(8)) //C9_FILIAL+C9_LOTNFC+C9_PEDIDO+C9_ITEM
	cAliasQry := GetNextAlias()
	cQuery := "   SELECT C9_BLCRED, C9_BLTMS "
	cQuery += "     FROM " + RetSqlName("SC9")
	cQuery += "    WHERE C9_FILIAL = '" + xFilial("SC9") + "' "
	cQuery += "      AND C9_LOTNFC = '" + cLotNfc + "' "
	cQuery += "      AND ( C9_BLCRED <> ' ' OR C9_BLTMS <> ' ')"
	cQuery += "      AND D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY " + SqlOrder(SC9->(IndexKey()))
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
	While (cAliasQry)->(!Eof())
		//-- Se nao liberou todos os pedidos, o status do lote permanece como bloqueado
		If	!Empty((cAliasQry)->C9_BLCRED) .And. (cAliasQry)->C9_BLCRED != '10'
			cStatus := StrZero(4,Len(DTP->DTP_STATUS))
			Exit
		EndIf
		//-- Bloqueio de transporte, se nao liberou todos os pedidos, o status do lote permanece como bloqueado
		If	! Empty( (cAliasQry)->C9_BLTMS )
			cStatus := StrZero(4,Len(DTP->DTP_STATUS))
			Exit
		EndIf
		(cAliasQry)->(DbSkip())
	EndDo
	(cAliasQry)->(DbCloseArea())
EndIf

DTP->(DbSetOrder(2)) //DTP_FILIAL+DTP_FILORI+DTP_LOTNFC
If	DTP->(MsSeek(cSeek := xFilial("DTP") + cFilAnt + cLotNfc, .F.))
	RecLock("DTP",.F.)
	DTP->DTP_STATUS := cStatus
	MsUnLock()
Else
	lRet := .F.
EndIf

RestArea( aAreaDTP )
RestArea( aAreaAnt )

Return( lRet )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200Est≥ Autor ≥ Alex Egydio           ≥ Data ≥20.02.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Dispara o processamento do estorno                         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA200Est()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpC1 = Alias do arquivo                                   ≥±±
±±≥          ≥ ExpN1 = Numero do registro                                 ≥±±
±±≥          ≥ ExpN2 = Opcao selecionada                                  ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
















Function TMSA200Est( cAlias, nReg, nOpcx, lConfirma, l2Percurso )

Local aAreaAnt	:= GetArea()
Local aAreaDTC	:= DTC->( GetArea() )
Local aAreaDT6	:= DT6->( GetArea() )
Local aSays		:= {}
Local aButtons	:= {}
Local aDelDocto	:= {}
Local lDocto	:= .F.
Local lRet		:= .T.
Local nOpca		:= 0
Local cLotEst	:= ''
Local lDelDoc	:= ExistBlock("TM200DEL")
Local lTM200CAN	:= ExistBlock("TM200CAN")
Local lTM200OK	:= ExistBlock("TM200OK")
Local dDatFTMS	:= GetMv("MV_DATATMS",.F.,CtoD(''))
Local dDatFFIN	:= GetMv("MV_DATAFIN",.F.,CtoD(''))
Local dDataEmi	:= dDatabase
Local nCntFor  	:= 0
Local lCONTDOC	:= SuperGetMv("MV_CONTDOC",.F.,.F.) .And. FindFunction("TmsConTran") //--Parametro para controle de TransaÁıes da Viagem mod2,
					//-- o documento ficara locado atÈ confirmar ou fechar a viagem impossibilitando o uso do documento por outras EstaÁıes.
Default l2Percurso := .F.

DT6->(DbSetOrder(2))
If DT6->(DBSeek(xFilial('DT6')+DTP->DTP_FILORI+DTP->DTP_LOTNFC+DTC->DTC_FILDOC+DTC->DTC_DOC+DTC->DTC_SERIE)) .And. DT6->DT6_SITCTE == '1' 
	Help(' ', 1, "TMSA20057",,,5,11 ) //N„o È possÌvel estornar o documento. Aguardando retorno da SEFAZ.
	RestArea( aAreaDT6 )
	Return ( .F. )
EndIf

If lConfirma == Nil .Or. ValType(lConfirma) != 'L'
	lConfirma := .T.
EndIf

//-- Verifica se o agendamento est· sendo utilizado por outro usu·rio no painel de agendamentos
If !TMSAVerAge("5",,,,,,,,,,,,"2",.T.,.T.,DTP->DTP_LOTNFC,,StrZero(ThreadId(),20))
	Return (.F.)
EndIf

If	DTP->DTP_STATUS != StrZero(3,Len(DTP->DTP_STATUS)) .And. DTP->DTP_STATUS != StrZero(4,Len(DTP->DTP_STATUS))
	//-- Limpa marcas dos agendamentos
	//-- Analisar a inserÁ„o desta rotina antes de cada Return( .F. ) ou ( .T. ), quando utilizado TmsVerAge
	If !IsInCallStack("TMSAF76")
		TMSALimAge(StrZero(ThreadId(),20))
	EndIf
	Help(' ', 1, 'TMSA20017',,STR0006 + DTP->DTP_LOTNFC,5,11)		//-- Somente lotes com status calculado podem ser estornados. //'Lote : '
	Return( .F. )
EndIf

If	DTP->DTP_FILORI != cFilAnt
	//-- Limpa marcas dos agendamentos
	//-- Analisar a inserÁ„o desta rotina antes de cada Return( .F. ) ou ( .T. ), quando utilizado TmsVerAge
	If !IsInCallStack("TMSAF76")
		TMSALimAge(StrZero(ThreadId(),20))
	EndIf
	Help(' ', 1, 'TMSA20025',, STR0043 + DTP->DTP_FILORI + ' / ' + STR0006 + DTP->DTP_LOTNFC,5,11)		//-- Exclusao permitida somente na filial de origem  //'Filial Origem : '###'Lote : '
	Return( .F. )
EndIf

//VALIDACAO PARA BLOQUEIO DE ACORDO COM OS PARAMETROS ABAIXO
DT6->(DbSetOrder(2))
If (DT6->(MsSeek(xFilial('DT6')+ DTP->DTP_FILORI + DTP->DTP_LOTNFC )))
	dDataEmi := DT6->DT6_DATEMI
Endif

If !Empty(dDatFTMS)
	If dDataEmi <= dDatFTMS
		//-- Limpa marcas dos agendamentos
		//-- Analisar a inserÁ„o desta rotina antes de cada Return( .F. ) ou ( .T. ), quando utilizado TmsVerAge
		If !IsInCallStack("TMSAF76")
			TMSALimAge(StrZero(ThreadId(),20))
		EndIf
		Help ( " ", 1, "FECHATMS" )
		Return( .F. )
	EndIf
EndIf

If !Empty(dDatFFIN)
	If dDataEmi < dDatFFIN
		//-- Limpa marcas dos agendamentos
		//-- Analisar a inserÁ„o desta rotina antes de cada Return( .F. ) ou ( .T. ), quando utilizado TmsVerAge
		If !IsInCallStack("TMSAF76")
			TMSALimAge(StrZero(ThreadId(),20))
		EndIf
		Help ( " ", 1, "DTMOVFIN" )
		Return( .F. )
	EndIf
EndIf

If !Empty(GetMV("MV_DATAFIS",,""))
	If !FisChkDt(dDataEmi)
		//-- Limpa marcas dos agendamentos
		//-- Analisar a inserÁ„o desta rotina antes de cada Return( .F. ) ou ( .T. ), quando utilizado TmsVerAge
		If !IsInCallStack("TMSAF76")
			TMSALimAge(StrZero(ThreadId(),20))
		EndIf
		Return( .F. )
	EndIf
EndIf

//-- PE utilizado para validar a execucao da rotina.
If lTM200OK
	lRet := ExecBlock("TM200OK",.F.,.F.,{3})
	If ValType(lRet) # "L"
		lRet := .T.
	EndIf
	If !lRet
		//-- Limpa marcas dos agendamentos
		//-- Analisar a inserÁ„o desta rotina antes de cada Return( .F. ) ou ( .T. ), quando utilizado TmsVerAge
		If !IsInCallStack("TMSAF76")
			TMSALimAge(StrZero(ThreadId(),20))
		EndIf
		Return( .F. )
	EndIf
EndIf

DT6->(DbSetOrder(2))
If DTP->DTP_STATUS == StrZero(4,Len(DTP->DTP_STATUS)) .And. ;
	( !DT6->(MsSeek(xFilial('DTC')+DTP->DTP_FILORI + DTP->DTP_LOTNFC )) )
	If !MsgYesNo(STR0052 + DTP->DTP_LOTNFC + STR0053) //"Nao foram gerados Documentos para o Lote Bloqueado: "###". Altera o Status do Lote para 'Em Aberto' ? "
		RestArea( aAreaDT6 )
		//-- Limpa marcas dos agendamentos
		//-- Analisar a inserÁ„o desta rotina antes de cada Return( .F. ) ou ( .T. ), quando utilizado TmsVerAge
		If !IsInCallStack("TMSAF76")
			TMSALimAge(StrZero(ThreadId(),20))
		EndIf
		Return( .T. )
	Else
		RecLock("DTP", .F.)
		DTP->DTP_STATUS := StrZero(2,Len(DTP->DTP_STATUS)) 	// Em Aberto
		DTP->(MsUnLock())
		RestArea( aAreaDT6 )
		//-- Limpa marcas dos agendamentos
		//-- Analisar a inserÁ„o desta rotina antes de cada Return( .F. ) ou ( .T. ), quando utilizado TmsVerAge
		If !IsInCallStack("TMSAF76")
			TMSALimAge(StrZero(ThreadId(),20))
		EndIf
		Return( .T. )
	EndIf
EndIf

If lRet
	If lConfirma
		AAdd( aSays, STR0023 ) //'Este programa tem como objetivo, efetuar o estorno do calculo'
		AAdd( aSays, STR0024 ) //'Nao sera permitido estornar lotes que ja tenham conhecimentos'
		AAdd( aSays, STR0025 ) //'associados a uma viagem. '

		AAdd( aButtons, { 1, .T., {|o| nOpcA := 1, o:oWnd:End() } } )
		AAdd( aButtons, { 2, .T., {|o| o:oWnd:End() } } )

		FormBatch( cCadastro, aSays, aButtons )
	Else
		nOpcA := 1
	EndIf
	If nOpcA == 1
			//-- Selecione os documentos para estorno
			lRet := TmsA200Mrk(aDelDocto,,,,l2Percurso)
		Begin Transaction
			If	lRet
				//-- Estorna :
				//-- Movimento de viagem.
				//-- Documento de transporte.
				//-- Conhecimento de frete.
				//-- Composicao de frete do conhecimento.
				//-- Pedidos de venda, gerados para o conhecimento de frete.
				//-- Averbacao de seguro.
				//-- Apaga o numero do conhecimento da nota fiscal do cliente.
				Processa( {|lEnd| lRet := TMSA200Exc( aDelDocto, DTP->DTP_LOTNFC, @lEnd, @lDocto, @cLotEst,, ) }, cCadastro,STR0026, .F. ) //'Estornando conhecimento de frete...'
			EndIf
			//-- lDocto igual a .F. indica que todos os documentos do lote foram estornados, entao o status do lote passa para digitado.
			//-- lDocto igual a .T. indica que alguns documentos do lote nao foram estornados, entao o status do lote permanece como calculado.
			If lRet .And. ! lDocto
				//-- Atualiza o status do lote para ( 2 - Digitado )
				Processa( {|lEnd| lRet := TMSA200Sta(@lEnd, DTP->DTP_LOTNFC, StrZero(2,Len(DTP->DTP_STATUS)) ) }, cCadastro,STR0013, .F. ) //'Atualizando Status do Lote...'
			EndIf
			If lDelDoc .And. lRet
				ExecBlock("TM200DEL",.F.,.F.,aDelDocto)
			EndIf
			If !lRet .And. InTransaction()
				DisarmTransaction()
			EndIf
		End Transaction
		// Se Gerou um Novo Lote
		If !Empty(cLotEst)
			Help(' ', 1, 'TMSA20028',,cLotEst,2,1) //"Numero do Novo Lote Gerado : "
		EndIf
	Else
		If lTM200CAN
			Begin Transaction
				ExecBlock("TM200CAN",.F.,.F.)
			End Transaction
		EndIf
	EndIf
Endif

If lCONTDOC .And. !lRet
	For nCntFor := 1 To Len(aDelDocto)
		TmsConTran(aDelDocto[nCntFor,1],aDelDocto[nCntFor,2],aDelDocto[nCntFor,3], .F.)
	Next nCntFor
EndIf

//-- Limpa marcas dos agendamentos
If !IsInCallStack("TMSAF76")
	TMSALimAge(StrZero(ThreadId(),20))
EndIf

//--Finalizado o Estorno pelo Painel de Agendamento verifica se existe viagem informado no lote
//-- e pergunta se o usu·rio deseja estornar desde que n„o exista documentos vinculados.
If IsInCallStack("TMSAF76")
     If !Empty(DTP->DTP_VIAGEM)
         If Aviso("AtenÁ„o", "Existe uma viagem aberta vinculada ao lote. Deseja excluÌ-la para liberar os veÌculos?",{"&SIM","&NAO"}) == 1
              TmsLibVeic(DTP->DTP_FILORI,DTP->DTP_VIAGEM,.T.)
         EndIf
     EndIf
EndIf

RestArea( aAreaDTC )
RestArea( aAreaDT6 )
RestArea( aAreaAnt )

Return( lRet )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200Exc≥ Autor ≥ Alex Egydio           ≥ Data ≥20.02.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Estorna documentos                                         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA200Exc()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpA1 = Array contendo os documentos                       ≥±±
±±≥          ≥ ExpC1 = Lote da Nota Fiscal                                ≥±±
±±≥          ≥ ExpL1 = Cancela processamento                              ≥±±
±±≥          ≥ ExpL2 = .T. indica que ha documentos calculados no lote e  ≥±±
±±≥          ≥         nao muda o status do lote para digitado.           ≥±±
±±≥          ≥ ExpC2 = No. do Novo Lote gerado                            ≥±±
±±≥          ≥ ExpL3 = .T. - Manutencao de Documentos                     ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TMSA200Exc( aDelDocto, cLotNfc, lEnd, lDocto, cLotEst, l500Doc, lExc2Pe )

Local aAreaAnt	:= GetArea()
Local aAreaDTC	:= DTC->(GetArea())
Local aAreaSF2	:= {}
Local aAreaDT6	:= {}
Local aCab		:= {}
Local cPedido	:= ''
Local cSeek		:= ''
Local cChave	:= ''
Local lRet		:= .F.
Local lHelpCte	:= .F.
Local lGerLot 	:= SuperGetMv( "MV_GERLOT", .F., .T. )  //-- Par‚metro que determina se o sistema deve gerar novo lote ao estornar o c·lculo
Local nCntFor	:= 0
Local nQtdDig	:= 0
Local nSeek		:= 0
Local aNfDig	:= {}
Local aContrt	:= {}
Local dDtdigit	:= dDataBase
Local cLotAnt	:= ""
Local cQuery	:= ""
Local cAliasQry	:= ""
Local cAliasDVR	:= ""
Local lTMSCTe	:= SuperGetMv( "MV_TMSCTE", .F., .F. ) //-- Parametro do CT-e ativo.
Local lCTECan	:= SuperGetMv( "MV_CTECAN", .F., .F. ) //-- Cancelamento CTE - .F.-Padrao .T.-Apos autorizacao
Local lAgdEntr	:= Iif(FindFunction("TMSA018Agd"),TMSA018Agd(),.F.)   //-- Agendamento de Entrega.
Local lCTCFsda	:= SuperGetMv( "MV_CTCFSDA", .F., .F. ) //-- Parametro do CT-e Cancelamento FSDA.
Local lDTCRee 	:= DTC->(FieldPos("DTC_DOCREE")) > 0
Local lContDoc	:= SuperGetMv("MV_CONTDOC",.F.,.F.) //--Parametro para controle de TransaÁıes da Viagem mod2,
					//-- o documento ficara locado atÈ confirmar ou fechar a viagem impossibilitando o uso do documento por outras EstaÁıes.
Local lUsaColab	:= UsaColaboracao("2")
Local lTmsCFec  := Iif(Type("lTmsCFec") = "U", TmsCFec(),lTmsCFec)
Local cIsenSub	:= GetMV("MV_ISENSUB",,"") 
Local lTabDLT   := TableIndic("DLT")
Local cAtvChgCli:= SuperGetMv('MV_ATVCHGC',,'') //-- Atividade de Chegada em Cliente
Local lEstDLT   := .F.

DEFAULT l500Doc	:= .F.
Default lExc2Pe	:= .F. //Indica se a exclus„o est· sendo chamada apÛs erro durante a geraÁ„o de um CTRC de 2∫ Percurso.

ProcRegua(Len(aDelDocto))
For nCntFor := 1 To Len(aDelDocto)
	IncProc()
	//-- Se nao estiver marcado
	If !aDelDocto[ nCntFor, 5 ]
		Loop
	EndIf
	cSeek := aDelDocto[nCntFor,1] + aDelDocto[nCntFor,2] + aDelDocto[nCntFor,3]
	//-- Posiciona no documento
	DT6->(DbSetOrder(2)) //DT6_FILIAL+DT6_FILORI+DT6_LOTNFC+DT6_FILDOC+DT6_DOC+DT6_SERIE
	If	DT6->(!MsSeek( xFilial('DT6') + cFilAnt + cLotNfc + cSeek ))
		lRet := .F.
		Loop
	EndIf
	//-- Trava o registro que est· sendo usado por outra estaÁ„o
	If lContDoc
		If !TmsConTran(aDelDocto[nCntFor,1],aDelDocto[nCntFor,2],aDelDocto[nCntFor,3], .T.)
			lRet := .F.
			Exit
		Else
			TmsConTran(aDelDocto[nCntFor,1],aDelDocto[nCntFor,2],aDelDocto[nCntFor,3], .F.)
		EndIf
	EndIf

	//-- Nao permitir estorno caso tenha fechamento de seguro para o documento
	If	! Empty( DT6->DT6_DOCSEG )
		Help(' ', 1, 'TMSA20021',,STR0038 + aDelDocto[nCntFor,2] +' / '+ aDelDocto[nCntFor,3] + STR0039 + DT6->DT6_DOCSEG,5,11)		//-- Ha fechamento de seguro para este docto.	//'Documento: '###' Documento de Seguro: '
		lRet := .F.
		Exit
	EndIf
	// N„o permitir o estorno quando a modalidade for EPEC, o estorno sÛ pode ser feito apÛs a validaÁ„o do evento EPEC conforme manual da da SEFAZ
	If DT6->DT6_IDRCTE $ '136/639/640/641/642/643/644/645/695/696/697/698/756'
		Help(' ', 1, "TMSA20043",, ,5,11 )
		lRet := .F.
		Exit
	EndIf
	// N„o permitir o estorno quando a modalidade for EPEC, o estorno sÛ pode ser feito apÛs a validaÁ„o do evento EPEC conforme manual da da SEFAZ
	If Substr(DT6->DT6_CHVCTE,35,1) = '4' .AND. DT6->DT6_SITCTE = '1'
		Help(' ', 1, 'TMSA20044',, ,5,11 )
		lRet := .F.
		Exit
	EndIf

	// Consumo indevido n„o permitir o estorno quando o MV_CTECAN estiver habilitado e o retorno da SEFAZ for 678
	If DT6->DT6_IDRCTE $ '678/999' .And. lCTECan
		Help(' ', 1, "TMSA20055",, ,5,11 )
		lRet := .F.
		Exit
	EndIf

	//--N„o permitir o estorno quando o MV_CTECAN estiver habilitado e o retorno da SEFAZ for 103
	If DT6->DT6_IDRCTE == "103" .And. lCTECan
		Help(' ', 1, "TMSA20044",, ,5,11 )
		lRet := .F.
		Exit
	EndIf

	//--Nao permitir estornar o Calculo do Frete,
	//--validando o parametro MV_DATAFIS,
	//--validando se houver CC-e nao permite estonar o calculo.
	aAreaSF2 := SF2->(GetArea())
	SF2->(DbSetOrder(1)) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
	If	SF2->(MsSeek( xFilial('SF2') + aDelDocto[nCntFor,2] + aDelDocto[nCntFor,3], .F. ))
		dDtdigit := IIf(!Empty(SF2->F2_DTDIGIT),SF2->F2_DTDIGIT,SF2->F2_EMISSAO)
		If !FisChkDt(dDtDigit)
			lRet := .F.
			Exit
		EndIf
		If !Empty(SF2->F2_IDCCE)
			Help(' ', 1, 'TMSA20053',, ,5,11 )
			lRet := .F.
			Exit
        EndIf
	EndIf
	RestArea(aAreaSF2)

	// Caso MV_CTECAN = .T. e MV_GERLOT = .F. e lote possuir mais de um documento, e n„o for de rateio, ser· gerado um novo lote ao estornar o calculo.
	If !lGerLot .And. lCTECan .And. Len(aDelDocto) > 1 .And. DTP->DTP_TIPLOT == StrZero(3,Len(DTP->DTP_TIPLOT)) ;
			.Or. DTP->DTP_TIPLOT == StrZero(4,Len(DTP->DTP_TIPLOT)) .And. DTP->DTP_RATEIO <> StrZero(1, Len(DTP->DTP_RATEIO))
		lGerLot := .T.
	Else
		// Caso MV_CTECAN = .T. e MV_GERLOT = .T. e lote possuir mais de um documento, e o lote for de rateio, n„o ser·  gerado um novo lote ao estornar o calculo.
		If lGerLot .And. lCTECan .And. DTP->DTP_RATEIO == StrZero(1, Len(DTP->DTP_RATEIO))
			lGerLot := .F.
		EndIf
	EndIf

	If lAgdEntr .And. !Empty(DT6->DT6_NUMAGD) //-- cancelar os agendamentos
		DbSelectArea("DTC")
		DbSetOrder(3)
		If DTC->(DbSeek(xFilial("DTC")+aDelDocto[nCntFor,1] + aDelDocto[nCntFor,2] + aDelDocto[nCntFor,3]))
		    DbSelectArea("DYD")
		    DbSetOrder(2)
		    DYD->(DbSeek(cSeek := xFilial("DYD")+aDelDocto[nCntFor,1] + aDelDocto[nCntFor,2] + aDelDocto[nCntFor,3]))
		    While DYD->(!EoF()) .And. cSeek == DYD->DYD_FILIAL+DYD->DYD_FILDOC+DYD->DYD_DOC+DYD->DYD_SERIE
 				TMSA200AGD(5) //Exclui
	        	DYD->(DbSkip())
		    EndDo
		EndIf
	EndIf

	aAreaDT6 := DT6->(GetArea())
	cChave   := xFilial('DT6')+DT6->DT6_FILDOC+DT6->DT6_DOC+DT6->DT6_SERIE
	DT6->(DbSetOrder(8)) //DT6_FILIAL+DT6_FILDCO+DT6_DOCDCO+DT6_SERDCO
	If DT6->(MsSeek(cChave)) .And. !(DT6->DT6_DOCTMS == 'J' .And. DT6->DT6_TIPFRE == '3')
		RestArea(aAreaDT6)
		Help(' ', 1, 'TMSA20029',,DT6->DT6_FILDOC + "/" + DT6->DT6_DOC + "/" + DT6->DT6_SERIE + CRLF + STR0062,2,13) //"Existe Manutencao de Doctos. feita para o CTRC : "###". A Exclusao nao sera efetuada .... "
		lRet :=.F.
		Exit
	EndIf
	RestArea(aAreaDT6)

	lRet := .T.

	//-- Se docto nao for de 2o. percurso
	If	aDelDocto[nCntFor,6] == StrZero(2,Len(DT6->DT6_PRIPER))
		DTC->(DbSetOrder(3)) //DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE+DTC_SERVIC+DTC_CODPRO
		cAliasQry := GetNextAlias()
		cQuery := " SELECT DTC_CLIREM, DTC_LOJREM, DTC_SERVIC, DTC_NUMNFC, DTC_SERNFC "
		cQuery += "   FROM " + RetSqlName("DTC") + " DTC "
		cQuery += "  WHERE DTC.DTC_FILIAL = '" + xFilial('DTC')  + "' "
		cQuery += "    AND DTC.DTC_FILDOC = '" + aDelDocto[nCntFor,1] + "' "
		cQuery += "    AND DTC.DTC_DOC    = '" + aDelDocto[nCntFor,2] + "' "
		cQuery += "    AND DTC.DTC_SERIE  = '" + aDelDocto[nCntFor,3] + "' "
		cQuery += "    AND DTC.D_E_L_E_T_ = ' ' "
		cQuery += "    UNION "
		cQuery += " SELECT DTC_CLIREM, DTC_LOJREM, DTC_SERVIC, DTC_NUMNFC, DTC_SERNFC "
		cQuery += "   FROM " + RetSqlName("DY4") + " DY4 "
		cQuery += "   INNER JOIN " + RetSqlName("DTC") + " DTC "
		cQuery += "		ON  DTC.DTC_FILIAL = '"+xFilial('DTC')+"'"
		cQuery += "    	AND DTC.D_E_L_E_T_ = ' ' "
		cQuery += "		AND DTC.DTC_LOTNFC = DY4.DY4_LOTNFC "
		cQuery += "		AND DTC.DTC_NUMNFC = DY4.DY4_NUMNFC "
		cQuery += "		AND DTC.DTC_SERNFC = DY4.DY4_SERNFC "
		cQuery += "		AND DTC.DTC_CODPRO = DY4.DY4_CODPRO "
		cQuery += "  WHERE DY4.DY4_FILIAL = '" + xFilial('DY4')  + "' "
		cQuery += "    AND DY4.DY4_FILDOC = '" + aDelDocto[nCntFor,1] + "' "
		cQuery += "    AND DY4.DY4_DOC    = '" + aDelDocto[nCntFor,2] + "' "
		cQuery += "    AND DY4.DY4_SERIE  = '" + aDelDocto[nCntFor,3] + "' "
		cQuery += "    AND DY4.D_E_L_E_T_ = ' ' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
		While (cAliasQry)->(!Eof())
			nSeek := Ascan(aNfDig, {|x| x[1] == (cAliasQry)->DTC_CLIREM + (cAliasQry)->DTC_LOJREM + (cAliasQry)->DTC_NUMNFC + (cAliasQry)->DTC_SERNFC } )
			If nSeek == 0
				AAdd(aNFDig, { (cAliasQry)->DTC_CLIREM + (cAliasQry)->DTC_LOJREM + (cAliasQry)->DTC_NUMNFC + (cAliasQry)->DTC_SERNFC } )
			EndIf
			(cAliasQry)->(DbSkip())
		EndDo
		(cAliasQry)->(DbCloseArea())
	EndIf
Next

If	lRet
	//-- Se tipo do lote for refaturamento, retorna a situaÁ„o dos documentos originais,
	//-- e exclui o apontamento do registro de ocorrencias.
	If DTP->DTP_TIPLOT == StrZero(2,Len(DTP->DTP_TIPLOT))
		TMSA500Exc(DTP->DTP_FILORI,DTP->DTP_LOTNFC)
	EndIf


	//-- Ponto de entrada impede a quebra de lote (que contem varios docs) ao realizar estorno do calculo de apenas um doc, para um determinado cliente.
	If lTM200GLO
		lQbrLot := ExecBlock("TM200GLO",.F.,.F.,{aDelDocto})
		If ValType(lQbrLot) == "L"
			lGerLot := lQbrLot
		End
	End

	ProcRegua(Len(aDelDocto))
	For nCntFor := 1 To Len(aDelDocto)
		IncProc()
		If ! aDelDocto[ nCntFor, 5 ]
			Loop
		EndIf
		cSeek:= aDelDocto[nCntFor,1] + aDelDocto[nCntFor,2] + aDelDocto[nCntFor,3]
		DT6->(DbSetOrder(2)) //DT6_FILIAL+DT6_FILORI+DT6_LOTNFC+DT6_FILDOC+DT6_DOC+DT6_SERIE
		If	DT6->(DbSeek(xFilial('DT6') + cFilAnt + cLotNfc + cSeek ))

			//-- Ajuste Lote Inicio

			DTP->(dbSetOrder(2)) //DTP_FILIAL+DTP_FILORI+DTP_LOTNFC
			If	DTP->(MsSeek(xFilial("DTP")+cFilAnt+cLotNfc))
				If !lUsaColab
					If DTP->DTP_TIPLOT == StrZero(1,Len(DTP->DTP_TIPLOT)).Or.;
						( (DTP->DTP_TIPLOT == StrZero(3,Len(DTP->DTP_TIPLOT)).Or.;
						DTP->DTP_TIPLOT == StrZero(4,Len(DTP->DTP_TIPLOT))) .And. (!lCTECan .Or. ;
						(lCTECan .And. (DT6->DT6_STATUS = 'C' .or. ( SubStr(DT6->DT6_RETCTE,1,3)<> "100" .And. SubStr(DT6->DT6_RETCTE,1,3) <> "004" )))) )
						nQtdDig := DTP->DTP_QTDDIG
						//-- Gera lote de estorno
						If !l500Doc .And. nQtdDig <> Len(aNfDig) .And. AllTrim(FunName()) != 'TMSA200A' .And. lGerLot
							//-- Indica que o status do lote permanecera calculado.
							lDocto  := .T.
							If Empty(cLotEst)
								cLotEst := TmsA200Lte(cLotNfc,StrZero(2,Len(DTP->DTP_STATUS)),Len(aNfDig))
								nQtdDig := DTP->DTP_QTDDIG
							EndIf
						EndIf
					EndIf
				Else
					If DTP->DTP_TIPLOT == StrZero(1,Len(DTP->DTP_TIPLOT)).Or.;
						( (DTP->DTP_TIPLOT == StrZero(3,Len(DTP->DTP_TIPLOT)).Or.;
						DTP->DTP_TIPLOT == StrZero(4,Len(DTP->DTP_TIPLOT))) .And. (!lCTECan .Or. ;
						(lCTECan .And. (DT6->DT6_STATUS = 'C' .or. ( SubStr(DT6->DT6_RETCTE,1,3)<> "001" .And. SubStr(DT6->DT6_RETCTE,1,3) <> "002" )))) )
						nQtdDig := DTP->DTP_QTDDIG
						//-- Gera lote de estorno
						If !l500Doc .And. nQtdDig <> Len(aNfDig) .And. AllTrim(FunName()) != 'TMSA200A' .And. lGerLot
							//-- Indica que o status do lote permanecera calculado.
							lDocto  := .T.
							If Empty(cLotEst)
								cLotEst := TmsA200Lte(cLotNfc,StrZero(2,Len(DTP->DTP_STATUS)),Len(aNfDig))
								nQtdDig := DTP->DTP_QTDDIG
							EndIf
						EndIf
					EndIf
				EndIf

				//-- Controle para estornar os dados da OperaÁ„o do Documento da Viagem em Transito (DLT e DTW)
				lEstDLT:= .F.	
				If lTabDLT .And. ExistFunc("TMSA351Exc") .And. !Empty(cAtvChgCli) .And. !Empty(DTP->DTP_VIAGEM) 
					DTQ->(DbSetOrder(2))
					If DTQ->(MsSeek(xFilial('DTQ') + DTP->(DTP_FILORI+DTP_VIAGEM))) .And. DTQ->DTQ_STATUS == StrZero( 2, Len( DTQ->DTQ_STATUS ) ) //-- Viagem em Tr‚nsito
						lEstDLT:= .T.
					EndIf
				EndIf
			EndIf

			//-- Fim do Ajuste Lote

			//////////////////////////////////////////////////////////////////////
			//-- Exclusao CTE somente apos envio e autorizacao da SEFAZ - Nao efetua exclusao somente altera Status!
			If !lUsaColab
				If	lTMSCTe .And. lCTECan .And. (!Empty(DT6->DT6_CHVCTE) .Or. !Empty(DT6->DT6_CHVCTG)) .And. ( SubStr(DT6->DT6_RETCTE,1,3)= "100" .Or. SubStr(DT6->DT6_RETCTE,1,3)= "004" )
					//Incluido para tratamento FSDA, para permitir cancelar em modalidade FSDA quando o parametro (MV_CTECAN e MV_CTCFSDA) estiver com True
					If !(lCTCFSDA .And. (SubStr(DT6->DT6_CHVCTE,35,1)= "5" .And. SubStr(DT6->DT6_RETCTE,1,3)<> "100"))
						If !DT6->DT6_STATUS $ "B/C"	//-- B- Cancelamento SEFAZ Aguardando, C- Cancelamento SEFAZ Autorizado, D- Cancelamento SEFAZ nao autorizado
							RecLock("DT6",.F.)
							DT6->DT6_BLQDOC	:= StrZero(1, Len(DT6->DT6_BLQDOC)) //-- Bloqueio: 1-Sim
							DT6->DT6_STATUS := "B"	//-- B- Cancelamento SEFAZ Aguardando
							MsUnLock()
							//-- Altera registro SF3 para excluido para permitir transmitir para SEFAZ!
							dbSelectArea("SF3")
							SF3->(DbSetOrder(4)) //F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE
							If	SF3->(DbSeek(xFilial("SF3")+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV+DT6->DT6_DOC+DT6->DT6_SERIE))
								While SF3->(!Eof()) .And. SF3->(F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE) == xFilial("SF3")+DT6->(DT6_CLIDEV+DT6_LOJDEV+DT6_DOC+DT6_SERIE)
									If (Substr(SF3->F3_CFO,1,1) >= "5")
										RecLock("SF3",.F.)
										SF3->F3_DTCANC := dDataBase
										MsUnlock()
									EndIf
									SF3->(dbSkip())
								EndDo
							EndIf
							//-- Nao efetua exclusao somente altera Status!
							lHelpCte := .T.
							lDocto   := .T.
							Loop
						EndIf
					EndIf
				EndIf
			Else
				If	lTMSCTe .And. lCTECan .And. (!Empty(DT6->DT6_CHVCTE) .Or. !Empty(DT6->DT6_CHVCTG)).And. ( SubStr(DT6->DT6_RETCTE,1,3)= "001" .Or. SubStr(DT6->DT6_RETCTE,1,3)= "002" )
					//Incluido para tratamento FSDA, para permitir cancelar em modalidade FSDA quando o parametro (MV_CTECAN e MV_CTCFSDA) estiver com True
					If !(lCTCFSDA .And. (SubStr(DT6->DT6_CHVCTE,35,1)= "5" .And. SubStr(DT6->DT6_RETCTE,1,3)<> "001"))
						If !DT6->DT6_STATUS $ "B/C"	//-- B- Cancelamento SEFAZ Aguardando, C- Cancelamento SEFAZ Autorizado, D- Cancelamento SEFAZ nao autorizado
							RecLock("DT6",.F.)
							DT6->DT6_BLQDOC	:= StrZero(1, Len(DT6->DT6_BLQDOC)) //-- Bloqueio: 1-Sim
							DT6->DT6_STATUS := "B"	//-- B- Cancelamento SEFAZ Aguardando
							MsUnLock()
							//-- Altera registro SF3 para excluido para permitir transmitir para SEFAZ!
							dbSelectArea("SF3")
							SF3->(DbSetOrder(4)) //F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE
							If	SF3->(DbSeek(xFilial("SF3")+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV+DT6->DT6_DOC+DT6->DT6_SERIE))
								While SF3->(!Eof()) .And. SF3->(F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE) == xFilial("SF3")+DT6->(DT6_CLIDEV+DT6_LOJDEV+DT6_DOC+DT6_SERIE)
									If (Substr(SF3->F3_CFO,1,1) >= "5")
										RecLock("SF3",.F.)
										SF3->F3_DTCANC := dDataBase
										MsUnlock()
									EndIf
									SF3->(dbSkip())
								EndDo
							EndIf
							//-- Nao efetua exclusao somente altera Status!
							lHelpCte := .T.
							lDocto   := .T.
							Loop
						EndIf
					EndIf
				EndIf
			EndIf
			If lExc2Pe //Exclus„o direta da DT6 para o CTRC do 1∫ Percurso.
				RecLock("DT6",.F.)
				DT6->( DbDelete() )
				MsUnLock()
			EndIf
			//////////////////////////////////////////////////////////////////////
			aCab	:= {}
			cPedido	:= ''
			If aDelDocto[ nCntFor, 3 ] == 'PED'
				cPedido := aDelDocto[ nCntFor, 2 ]
			Else
				//////////////////////////////////////////////////////////////////////
				//-- Guarda o nr. do pedido de venda gerado para a geracao de conhecimento de frete
				cAliasQry := GetNextAlias()
				cQuery := "   SELECT C9_PEDIDO "
				cQuery += "     FROM " + RetSqlName("SC9") + " SC9 "
				cQuery += "    WHERE SC9.C9_FILIAL  = '" + xFilial("SC9") + "' "
				cQuery += "      AND SC9.C9_SERIENF = '" + DT6->DT6_SERIE + "' "
				cQuery += "      AND SC9.C9_NFISCAL = '" + DT6->DT6_DOC + "' "
				cQuery += "      AND SC9.D_E_L_E_T_ = ' ' "
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
				If (cAliasQry)->(!Eof())
					cPedido := (cAliasQry)->C9_PEDIDO
				EndIf
				(cAliasQry)->(DbCloseArea())
				//////////////////////////////////////////////////////////////////////
				//-- Estorna documentos
				lRet := TMSDelNFS( aDelDocto[ nCntFor, 2 ], aDelDocto[ nCntFor, 3 ] )
			EndIf

			//////////////////////////////////////////////////////////////////////
			//-- Posiciona movimento de viagem.
			cAliasQry := GetNextAlias()
			cQuery := " SELECT R_E_C_N_O_ DUD_RECNO "
			cQuery += "   FROM " + RetSqlName("DUD") + " DUD "
			cQuery += "  WHERE DUD.DUD_FILIAL = '" + xFilial('DUD') + "' "
			cQuery += "    AND DUD.DUD_FILDOC = '" + DT6->DT6_FILDOC + "' "
			cQuery += "    AND DUD.DUD_DOC    = '" + DT6->DT6_DOC + "' "
			cQuery += "    AND DUD.DUD_SERIE  = '" + DT6->DT6_SERIE + "' "
			cQuery += "    AND DUD.DUD_FILORI = '" + cFilAnt + "' "
			cQuery += "    AND DUD.D_E_L_E_T_ = ' ' "
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
			If (cAliasQry)->(!Eof())
				DUD->(MsGoto( (cAliasQry)->DUD_RECNO ))
				RecLock('DUD',.F.)
				DUD->( DbDelete() )
				MsUnLock()
			EndIf
			(cAliasQry)->(DbCloseArea())
			//////////////////////////////////////////////////////////////////////

			//-- Estorna a composicao de frete do documento
			cAliasQry := GetNextAlias()
			cQuery := " SELECT R_E_C_N_O_ DT8_RECNO "
			cQuery += "   FROM " + RetSqlName("DT8") + " DT8 "
			cQuery += "  WHERE DT8.DT8_FILIAL = '" + xFilial('DT8') + "' "
			cQuery += "    AND DT8.DT8_FILDOC = '" + DT6->DT6_FILDOC + "' "
			cQuery += "    AND DT8.DT8_DOC    = '" + DT6->DT6_DOC + "' "
			cQuery += "    AND DT8.DT8_SERIE  = '" + DT6->DT6_SERIE + "' "
			cQuery += "    AND DT8.D_E_L_E_T_ = ' ' "
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
			While (cAliasQry)->(!Eof())
				DT8->(MsGoto((cAliasQry)->DT8_RECNO))
				RecLock('DT8',.F.)
				DT8->(DbDelete())
				MsUnLock()
				(cAliasQry)->(DbSkip())
			EndDo
			(cAliasQry)->(DbCloseArea())
			//////////////////////////////////////////////////////////////////////

			//-- Estorna pedidos de venda, gerados para o conhecimento de frete
			If !Empty(cPedido)
				AAdd( aCab, { 'C5_NUM', cPedido, Nil } )
				TMSPedido( aCab, , 5 )
			EndIf

			//-- Estorna averbacao de seguro
			DU7->(DbSetOrder(1)) //DU7_FILIAL+DU7_FILDOC+DU7_DOC+DU7_SERIE
			While DU7->(MsSeek(xFilial('DU7') + DT6->DT6_FILDOC + DT6->DT6_DOC + DT6->DT6_SERIE))
				RecLock('DU7',.F.)
				DU7->(DbDelete())
				MsUnLock()
			EndDo

			//--AtualizaÁ„o do status do estorno da averbaÁ„o de seguro na tabela DL5 para NFS normal e/ou NFS de reentrega
			If FindFunction ("AvbeGrvCte") .AND. AliasInDic("DL5") .AND. (DT6->DT6_DOCTMS $ "5D")
				AvbeGrvCte( DT6->DT6_FILDOC, DT6->DT6_DOC, DT6->DT6_SERIE,DT6->DT6_DATEMI,DT6->DT6_HOREMI,'102',DT6->DT6_DOCTMS, DT6->DT6_CLIDEV, DT6->DT6_LOJDEV)
			EndIF

			//////////////////////////////////////////////////////////////////////
			//-- Apaga o numero do documento da nota fiscal do cliente
			cAliasQry := GetNextAlias()
			cQuery := " SELECT DTC_CLICAL, DTC_LOJCAL, DTC_SERVIC, DTC_TIPFRE, DTC_SERTMS, DTC_FILDOC, DTC_DOC, DTC_SERIE, "
			cQuery += "        DTC_LOTNFC, DTC_DOCPER, DTC_FILORI, DTC_CLIREM, DTC_LOJREM, DTC_CLIDES, "
			cQuery += "        DTC_LOJDES, DTC_SERVIC, DTC_NUMNFC, DTC_SERNFC, DTC_CODPRO, R_E_C_N_O_ DTC_RECNO "
			cQuery += ",DTC_CODNEG "

			cQuery += "   FROM " + RetSqlName("DTC") + " DTC "
			cQuery += "  WHERE DTC.DTC_FILIAL = '" + xFilial('DTC')  + "' "
			cQuery += "    AND DTC.DTC_FILDOC = '" + DT6->DT6_FILDOC + "' "
			If lExc2Pe
				cQuery += "    AND ((DTC.DTC_DOC    = '" + DT6->DT6_DOC    + "' "
				cQuery += "    AND   DTC.DTC_SERIE  = '" + DT6->DT6_SERIE  + "') "
				cQuery += "     OR   DTC.DTC_DOCPER = '" + DT6->DT6_DOC    + "') "
			Else
				cQuery += "    AND DTC.DTC_DOC    = '" + DT6->DT6_DOC    + "' "
				cQuery += "    AND DTC.DTC_SERIE  = '" + DT6->DT6_SERIE  + "' "
			EndIf
			cQuery += "    AND DTC.D_E_L_E_T_ = ' ' "
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
			While (cAliasQry)->(!Eof())
				aContrt := TMSContrat( (cAliasQry)->DTC_CLICAL, (cAliasQry)->DTC_LOJCAL, , (cAliasQry)->DTC_SERVIC, .F., (cAliasQry)->DTC_TIPFRE,,,,,,,,,,,,,,,,(cAliasQry)->DTC_CODNEG )
				DTC->(MsGoto((cAliasQry)->DTC_RECNO))
				cLotAnt := (cAliasQry)->DTC_LOTNFC

				//-- Carga Fechada - Estorna ocorrencia de entrega automatica,
				//   Estorna geracao automatica de viagens e atualizacao do status do documento.
				If lTmsCFec .And. (cAliasQry)->DTC_SERTMS == StrZero(3,Len((cAliasQry)->DTC_SERTMS)) //-- Entrega
					A200EstCFec(DT6->DT6_FILDOC, DT6->DT6_DOC, DT6->DT6_SERIE)
				EndIf

				RecLock('DTC',.F.)
				If	! Empty( cLotEst )
					DTC->DTC_LOTNFC := cLotEst
				EndIf
				DTC->DTC_FILDOC := Space(Len(DTC->DTC_FILDOC))
				DTC->DTC_DOC    := Space(Len(DTC->DTC_DOC))
				DTC->DTC_SERIE  := Space(Len(DTC->DTC_SERIE))
				DTC->DTC_DOCPER := Space(Len(DTC->DTC_DOCPER))
				DTC->DTC_NFELET := Space(Len(DTC->DTC_NFELET))
				DTC->DTC_EMINFE := CtoD('  /  /  ')
				DTC->DTC_CODNFE := Space(Len(DTC->DTC_CODNFE))
				If ! Empty( aContrt )
					If aContrt[ 1, 21 ] == StrZero(2,Len(AAM->AAM_SELSER)) //-- Servico Automatico
						DTC->DTC_SERVIC := Space(Len(DTC->DTC_SERVIC))
					EndIf
				EndIf
				MsUnLock()

				//-- Exclui as chaves dos Documentos de SubcontrataÁ„o
				If TableInDic("DLR") .And. !Empty(cIsenSub) 
					DLR->(DbSetOrder(1))
					DLR->(MsSeek(xFilial('DLR')+DT6->DT6_FILDOC+DT6->DT6_DOC+DT6->DT6_SERIE))
					While DLR->(!Eof()) .And. DLR->(DLR_FILIAL+DLR_FILDOC+DLR_DOC+DLR_SERIE) == xFilial('DLR')+DT6->(DT6_FILDOC+DT6_DOC+DT6_SERIE)
						RecLock('DLR',.F.)
						dbDelete()
						MsUnLock()
						DLR->(dbSkip())
					EndDo
				EndIf 

				//--Muda os componentes de valor informado de lote
				If !Empty(cLotEst)
					cAliasDVR := GetNextAlias()
					cQuery := "   SELECT R_E_C_N_O_ DVR_RECNO "
					cQuery += "     FROM " + RetSqlName("DVR")  + " DVR "
					cQuery += "    WHERE DVR.DVR_FILIAL = '" + xFilial('DVR') + "' "
					cQuery += "      AND DVR.DVR_FILORI = '" + (cAliasQry)->DTC_FILORI + "' "
					cQuery += "      AND DVR.DVR_LOTNFC = '" + cLotAnt + "' "
					cQuery += "      AND DVR.DVR_CLIREM = '" + (cAliasQry)->DTC_CLIREM + "' "
					cQuery += "      AND DVR.DVR_LOJREM = '" + (cAliasQry)->DTC_LOJREM + "' "
					cQuery += "      AND DVR.DVR_CLIDES = '" + (cAliasQry)->DTC_CLIDES + "' "
					cQuery += "      AND DVR.DVR_LOJDES = '" + (cAliasQry)->DTC_LOJDES + "' "
					cQuery += "      AND DVR.DVR_SERVIC = '" + (cAliasQry)->DTC_SERVIC + "' "
					cQuery += "      AND DVR.DVR_NUMNFC = '" + (cAliasQry)->DTC_NUMNFC + "' "
					cQuery += "      AND DVR.DVR_SERNFC = '" + (cAliasQry)->DTC_SERNFC + "' "
					cQuery += "      AND DVR.DVR_CODPRO = '" + (cAliasQry)->DTC_CODPRO + "' "
					cQuery += "      AND DVR.DVR_CODNEG = '" + (cAliasQry)->DTC_CODNEG + "' "
					cQuery += "      AND D_E_L_E_T_ = ' ' "
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDVR)
					While (cAliasDVR)->(!Eof())
						DVR->(MsGoto( (cAliasDVR)->DVR_RECNO ))
						RecLock('DVR',.F.)
						DVR->DVR_LOTNFC := cLotEst
						MsUnLock()
						(cAliasDVR)->(DbSkip())
					EndDo
					(cAliasDVR)->(DbCloseArea())
				EndIf

				//--Muda os tipos de veÌculo de lote
				If !Empty(cLotEst)
					cAliasDVU := GetNextAlias()
					cQuery := "   SELECT R_E_C_N_O_ DVU_RECNO "
					cQuery += "     FROM " + RetSqlName("DVU")  + " DVU "
					cQuery += "    WHERE DVU.DVU_FILIAL = '" + xFilial('DVU') + "' "
					cQuery += "      AND DVU.DVU_FILORI = '" + (cAliasQry)->DTC_FILORI + "' "
					cQuery += "      AND DVU.DVU_LOTNFC = '" + cLotAnt + "' "
					cQuery += "      AND DVU.DVU_CLIREM = '" + (cAliasQry)->DTC_CLIREM + "' "
					cQuery += "      AND DVU.DVU_LOJREM = '" + (cAliasQry)->DTC_LOJREM + "' "
					cQuery += "      AND DVU.DVU_NUMNFC = '" + (cAliasQry)->DTC_NUMNFC + "' "
					cQuery += "      AND DVU.DVU_SERNFC = '" + (cAliasQry)->DTC_SERNFC + "' "
					cQuery += "      AND D_E_L_E_T_ = ' ' "
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDVU)
					While (cAliasDVU)->(!Eof())
						DVU->(MsGoto( (cAliasDVU)->DVU_RECNO ))
						RecLock('DVU',.F.)
						DVU->DVU_LOTNFC := cLotEst
						MsUnLock()
						(cAliasDVU)->(DbSkip())
					EndDo
					(cAliasDVU)->(DbCloseArea())
				EndIf

				If lTM200Exc
					ExecBlock('TM200EXC',.F.,.F.)
				EndIf
				(cAliasQry)->(DbSkip())
			EndDo
			(cAliasQry)->(DbCloseArea())
			//////////////////////////////////////////////////////////////////////
			//-- Atualiza campo DTC_DOCREE
			If !Empty(DT6->DT6_FILDCO) .AND. !Empty(DT6->DT6_DOCDCO) //verifica se eh doc de reentrega/devolucao
				If FindFunction("TmsPsqDY4") .And. TmsPsqDY4( DT6->DT6_FILDOC, DT6->DT6_DOC, DT6->DT6_SERIE ) .AND. lDTCRee
					If FindFunction('A360AtuRee')
						A360AtuRee(DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE, .T./*Estorno*/)
					EndIf
				Endif
			EndIf
			//////////////////////////////////////////////////////////////////////

			//-- Ponto de Entrada antes da exclusao do DT6
			If lTM200REM
				ExecBlock('TM200REM',.F.,.F.)
			EndIf

			//-- Excluir DY4 caso seja reentrega
			If !Empty(DT6->DT6_FILDCO) .AND. !Empty(DT6->DT6_DOCDCO) // Verifica se eh doc de reentrega/devolucao
				If FindFunction("TmsPsqDY4") .And. TmsPsqDY4( DT6->DT6_FILDOC, DT6->DT6_DOC, DT6->DT6_SERIE )
					DY4->(DbSetOrder(1))
					While DY4->(MsSeek(xFilial("DY4") + DT6->DT6_FILDOC + DT6->DT6_DOC + DT6->DT6_SERIE))
						RecLock("DY4",.F.)
						DY4->(DbDelete())
						MsUnLock()
					EndDo
				Endif
			EndIf
			//-- CTRC Complemento, excluir a digitacao do Valor informado x Complemento
			DbSelectArea("DT6")
			If	DT6->DT6_DOCTMS == StrZero(8,Len(DT6->DT6_DOCTMS))
				DVS->(DbSetOrder(1))
				While DVS->(MsSeek(xFilial("DVS") + DT6->DT6_FILDOC + DT6->DT6_DOC + DT6->DT6_SERIE))
					RecLock("DVS",.F.)
					DVS->(DbDelete())
					MsUnLock()
				EndDo
				//Estorna a observacao
				If !Empty(DT6->DT6_CODOBS)
					MSMM(DT6->DT6_CODOBS,,,,2,,,"DT6","DT6_CODOBS")
				EndIf
			EndIf

			//--Se for CRT Complemento nao pode excluir o CRT pesquisando pelo Lote
			//--pois no CRT Complemento o lote e o mesmo do documento original
			//--O CRT Complemento nao tem DIK, somente DT6 e tabelas relacionadas
			If DT6->DT6_TIPTRA == '4' .And. DT6->DT6_DOCTMS != Replicate('L',Len(DT6->DT6_DOCTMS)) //-- Rodoviario Internacional, se nao for CRT Complemento
				//-- Exclui documentos do cliente para transporte do CRT - Conhecimento Internacional
				DIK->(DbSetOrder(1)) //DIK_FILIAL+DIK_FILORI+DIK_LOTNFC
				If DIK->(MsSeek(xFilial('DIK')+DT6->(DT6_FILORI+DT6_LOTNFC)))
					If DIK->DIK_STATUS != '9' //--Cancelado
						DIN->(DbSetOrder(1))
						DIN->(MsSeek(xFilial('DIN')+DT6->(DT6_FILORI+DT6_LOTNFC)))
						While DIN->(!Eof()) .And. DIN->(DIN_FILIAL+DIN_FILORI+DIN_LOTNFC) == xFilial('DIN')+DT6->(DT6_FILORI+DT6_LOTNFC)
							RecLock('DIN',.F.)
							dbDelete()
							MsUnLock()
							DIN->(dbSkip())
						EndDo
						//-- Exclui Frete CIF/FOB
						DIA->(DbSetOrder(1))
						DIA->(MsSeek(xFilial('DIA')+DT6->(DT6_FILORI+DT6_LOTNFC)))
						While DIA->(!Eof()) .And. DIA->(DIA_FILIAL+DIA_FILORI+DIA_LOTNFC) == xFilial('DIA')+DT6->(DT6_FILORI+DT6_LOTNFC)
							RecLock('DIA',.F.)
							dbDelete()
							MsUnLock()
							DIA->(dbSkip())
						EndDo
						//-- Frete por pais
						DI9->(DbSetOrder(1))
						DI9->(MsSeek(xFilial('DI9')+DT6->(DT6_FILORI+DT6_LOTNFC)))
						While DI9->(!Eof()) .And. DI9->(DI9_FILIAL+DI9_FILORI+DI9_LOTNFC) == xFilial('DIA')+DT6->(DT6_FILORI+DT6_LOTNFC)
							RecLock('DI9',.F.)
							dbDelete()
							MsUnLock()
							DI9->(dbSkip())
						EndDo
						//-- Exclui CRT
						RecLock('DIK',.F.)
						dbDelete()
						MsUnLock()
					EndIf
				EndIf
			EndIf

			If !(DT6->DT6_IDRCTE $ '100/101/102') .And. !Empty(DT6->DT6_CHVCTE) //Limpa os campos das tabelas SF3 e SFT (F3_CHVNFE, FT_CHVNFE) quando o documento foi gerando Chave n„o foi transmitido. Nos casos de inutilizaÁ„o n„o teremos problemas na geraÁ„o do sped
				dbSelectArea("SF3")
				SF3->(DbSetOrder(4)) //F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE
				If	SF3->(DbSeek(xFilial("SF3")+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV+DT6->DT6_DOC+DT6->DT6_SERIE))
					RecLock("SF3",.F.)
					SF3->F3_CHVNFE := ""
					MsUnlock()
				EndIf
				dbSelectArea("SFT")
				SFT->(dbSetOrder(1))
				If SFT->(Dbseek(xFilial("SFT")+"S"+DT6->DT6_SERIE+DT6->DT6_DOC+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV))
					While SFT->(!Eof()) .And. SFT->(FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA)  == DT6->DT6_FILDOC+"S"+DT6->(DT6_SERIE+DT6_DOC+DT6_CLIDEV+DT6_LOJDEV)
						RecLock("SFT",.F.)
						SFT->FT_CHVNFE := ""
						MsUnlock()
						SFT->(DbSkip())
					EndDo
				EndIf
			EndIf
			//-- Estorna dados da OperaÁ„o do Documento da Viagem em Transito (DLT e DTW)
			If lEstDLT
				aAreaDT6:= DT6->(GetArea())
				TMSA351Exc(DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE,DTP->DTP_FILORI,DTP->DTP_VIAGEM)
				RestArea(aAreaDT6)
			EndIf	
			RecLock('DT6',.F.)
			DT6->(DbDelete())
			MsUnLock()
		EndIf
	Next

	If lRet .And. lCTECan .And. lGerLot
		nQdtDTC := TMSA200STU(cLotNfc, cFilAnt)
		If nQdtDTC <> 0 .And. nQdtDTC = nQtdDig
			DTP->(dbSetOrder(2)) //DTP_FILIAL+DTP_FILORI+DTP_LOTNFC
			If	DTP->(MsSeek(xFilial("DTP")+cFilAnt+cLotNfc))
				RecLock('DTP',.F.)
				DTP->DTP_STATUS := StrZero(2,Len(DTP->DTP_STATUS))
				MsUnLock()
			EndIf
		EndIf
	ElseIf lRet .And. lCTECan .And. !lGerLot
		nQdtDTC := TMSA200STU(cLotNfc, cFilAnt)
		If nQdtDTC <> 0
			DTP->(dbSetOrder(2)) //DTP_FILIAL+DTP_FILORI+DTP_LOTNFC
			If	DTP->(MsSeek(xFilial("DTP")+cFilAnt+cLotNfc))
				RecLock('DTP',.F.)
				DTP->DTP_STATUS := StrZero(2,Len(DTP->DTP_STATUS))
				MsUnLock()
			EndIf
		EndIf
	EndIf

	//-- Exclusao CTE somente apos envio e autorizacao da SEFAZ - Exibe Help se existem cancelamentos aguardando autorizacao SEFAZ!
	If	lTMSCTe .And. lCTECan .And. lHelpCte
		Help(' ', 1, 'TMSA20042') //"Cancelamento sem autorizacao da SEFAZ"
	EndIf
EndIf

RestArea( aAreaDTC )
RestArea( aAreaAnt )

Return( lRet )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TmsA200Mrk≥ Autor ≥ Alex Egydio           ≥ Data ≥07.05.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Seleciona documentos para estorno                          ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TmsA200Mrk()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpC1 = Numero do lote                                     ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TmsA200Mrk(aDelDocto,cFilDoc,cDoc,cSerie,lImpDoc)

Local oDlgEsp
Local aObjects  := {}
Local aInfo     := {}
Local aPosObj   := {}
Local aSize     := MsAdvSize()
Local nOpca     := 0
Local lRet      := .F.
Local cQuery    := ""
Local cAliasQry := GetNextAlias()
Local aDocExc   := {}
Local aArea     := GetArea()
Local cCampos   := ""
Local cCpos     := ""
Local aCpos     := {}
Local aHDocExc  := {}
Local aPict     := {}
Local aStruDT6  := {}
Local nPos      := 0
Local nPosFil   := 0
Local nPosDoc   := 0
Local nPosSer   := 0
Local nTotDoc   := 0
Local nTotMrc   := 0
Local nLinDoc   := 0
Local aButtons  := {}
Local lRotAut   := {}
Local lRateio		:= .F.
Local lCTECan		:= SuperGetMv( "MV_CTECAN", .F., .F. ) //-- Cancelamento CTE - .F.-Padrao .T.-Apos autorizacao
Local lCamposRat	:= DTP->(ColumnPos("DTP_RATEIO")) > 0
Local aStatusS	:= {}
Local cStatusS	:= ""
Local nX			:= 0
Local lGerLot		:= SuperGetMv( "MV_GERLOT", .F., .T. )  //-- Par‚metro que determina se o sistema deve gerar novo lote ao estornar o c·lculo
Local aFldDT6		:= {}

Local lPrimeiro := .T.
Local aMsgErr   := {}
Local aAreaDT6  := {}

DEFAULT cFilDoc := ""
DEFAULT cDoc    := ""
DEFAULT cSerie  := ""
DEFAULT lImpDoc := .F.

If lCamposRat
	lRateio	:= TMSLRateio( DTP->DTP_FILORI, DTP->DTP_LOTNFC )
EndIf
lRotAut := Iif(lImpDoc .Or. !Empty(cFilDoc+cDoc+cSerie),.T.,.F.)

//-- Coluna para marcar o documento
AAdd(aHDocExc," ")
AAdd(aPict   ," ")

//-- Coluna com situaÁ„o de marcar o documento
AAdd(aHDocExc,.T.)
AAdd(aPict   ,"")

//-- Coluna do status do documento (quando par‚metro MV_CTECAN estiver ligado)
lCTECan := .T.
If lCTECan .And. DT6->(ColumnPos("DT6_STATUS")) > 0
	cCampos := "DT6_STATUS" + ","
	AAdd(aHDocExc, "Status CTe")
	AAdd(aPict, PesqPict("DT6","DT6_STATUS"))
EndIf

//-- Demais campos
aFldDT6 := ApBuildHeader("DT6")
For nX := 1 To Len(aFldDT6)
	If aFldDT6[nX][10] <> "V" .AND. GetSX3Cache(aFldDT6[nX][2], "X3_BROWSE") == "S"
		//-- Campos que deverao ser apresentados
		cCampos += aFldDT6[nX][2] + ","
		//-- Titulos dos campos que deverao ser apresentados
		AAdd(aHDocExc, aFldDT6[nX][1])
		//-- Picture dos campos que deverao ser apresentados
		AAdd(aPict, AllTrim(GetSX3Cache(aFldDT6[nX][2], "X3_PICTURE")))
		//-- Verifica a posicao do documento
		If AllTrim(aFldDT6[nX][2]) == "DT6_FILDOC"
			nPosFil := Len(aHDocExc)
		ElseIf AllTrim(aFldDT6[nX][2]) == "DT6_DOC"
			nPosDoc := Len(aHDocExc)
		ElseIf AllTrim(aFldDT6[nX][2]) == "DT6_SERIE"
			nPosSer := Len(aHDocExc)
		EndIf
		//-- Armazena campo que nao e do tipo caracter para atualizacao no topconnect
		If aFldDT6[nX][8] <> "C"
			AAdd( aStruDT6, { aFldDT6[nX][2], aFldDT6[nX][8], aFldDT6[nX][4], aFldDT6[nX][5] } )
		EndIf
	EndIf
Next

aSize(aFldDT6, 0)
aFldDT6 := Nil

cCampos := SubStr(cCampos,1,Len(cCampos)-1)

cQuery := " SELECT "
cQuery += cCampos
cQuery += " FROM " + RetSqlName("DT6")
cQuery += " WHERE DT6_FILIAL = '" + xFilial("DT6") + "' "
cQuery += " 	AND DT6_FILORI = '" + DTP->DTP_FILORI + "' "
cQuery += " 	AND DT6_LOTNFC = '" + DTP->DTP_LOTNFC + "' "
//cQuery += " 	AND DT6_PRIPER = '" + StrZero(2,Len(DT6->DT6_PRIPER)) + "' " //-- somente documentos do 2o Percurso
cQuery += " 	AND DT6_FILDOC = '" + cFilAnt + "' "
cQuery += " 	AND DT6_DOCTMS IN ('" + StrZero(2,Len(DT6->DT6_DOCTMS)) + "',"
cQuery += "'"+StrZero(5,Len(DT6->DT6_DOCTMS))+ "',"
cQuery += "'"+StrZero(6,Len(DT6->DT6_DOCTMS))+ "',"
cQuery += "'"+StrZero(9,Len(DT6->DT6_DOCTMS))+ "',"
cQuery += "'"+Replicate('A',Len(DT6->DT6_DOCTMS))+ "',"
cQuery += "'"+Replicate('B',Len(DT6->DT6_DOCTMS))+ "',"
cQuery += "'"+Replicate('C',Len(DT6->DT6_DOCTMS))+ "',"
cQuery += "'"+Replicate('E',Len(DT6->DT6_DOCTMS))+ "',"
cQuery += "'"+Replicate('H',Len(DT6->DT6_DOCTMS))+ "',"
cQuery += "'"+Replicate('I',Len(DT6->DT6_DOCTMS))+ "',"
cQuery += "'"+Replicate('F',Len(DT6->DT6_DOCTMS))+ "',"
cQuery += "'"+Replicate('G',Len(DT6->DT6_DOCTMS))+ "',"
cQuery += "'"+Replicate('J',Len(DT6->DT6_DOCTMS))+ "',"
cQuery += "'"+Replicate('N',Len(DT6->DT6_DOCTMS))+ "',"
cQuery += "'"+Replicate('O',Len(DT6->DT6_DOCTMS))+ "')"
cQuery += "		AND D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)

//-- Atualizacao dos campos no topconnect
For nPos := 1 To Len(aStruDT6)
	If aStruDT6[nPos][2]<>"C"
		TcSetField(cAliasQry,aStruDT6[nPos][1],aStruDT6[nPos][2],aStruDT6[nPos][3],aStruDT6[nPos][4])
	EndIf
Next nPos

If (cAliasQry)->(Eof())
	Help(" ",1,"TMSA20040",,,5,11)// Este lote nao pode ser excluido por esta rotina. Favor verifique a sua origem.
	(cAliasQry)->(DbCloseArea())
	RestArea( aArea )
	Return( lRet )
EndIf

While (cAliasQry)->(!Eof())
	aCpos := {}
	AAdd( aCpos, .F. )
	cCpos := cCampos
	lPrimeiro := .T.
	While !Empty(cCpos)
		nPos := At(",",cCpos)
		If nPos <> 0
			If lPrimeiro
				aAreaDT6 := DT6->(GetArea())
				DT6->(DbSetOrder(1))
				If DT6->(DbSeek(xFilial("DT6") + (cAliasQry)->(DT6_FILDOC + DT6_DOC + DT6_SERIE)))
					Aadd(aCpos,Iif(TM200VlCmp(@aMsgErr,.F.,0,,),.F.,.T.))
				Else
					Aadd(aCpos,.T.)
				EndIf
				RestArea(aAreaDT6)
				lPrimeiro := .F.
			EndIf
			// Incluido para Informar na Tela de Estorno o Status do documento conforme o parametro MV_CTECAN e o status da SEFAZ..
			If lCTECan .And. (SubStr(cCpos,1,At(",",cCpos)-1) $ "DT6_STATUS")
				aStatusS := TMSValField("DT6_STATUS", .F., .F., .F., .T., .F., .F.)
				nX := Ascan(aStatusS, {|x| x[1] == AllTrim((cAliasQry)->DT6_STATUS)})
				If nX > 0
					cStatusS := aStatusS[nX, 2]
				EndIf
				AAdd(aCpos,cStatusS)
				cCpos := SubStr(cCpos,nPos+1)
			Else
				AAdd(aCpos,(cAliasQry)->&(SubStr(cCpos,1,At(",",cCpos)-1)))
				cCpos := SubStr(cCpos,nPos+1)
			EndIf
		Else
			cCpos := ""
		EndIf
	EndDo
	nTotDoc ++
	AAdd( aDocExc, aClone(aCpos) )
	(cAliasQry)->(DbSkip())
EndDo
(cAliasQry)->(DbCloseArea())
RestArea( aArea )

//-- Controle de dimensoes de objetos
If !lRotAut
	aAdd(aObjects, { 100, 100, .T., .T. })
	aAdd(aObjects, { 100, 020, .T., .F. })
	aInfo  := { aSize[1],aSize[2],aSize[3],aSize[4], 5, 5 }
	aPosObj:= MsObjSize( aInfo, aObjects,.T. )

	AAdd(aButtons,{'RELATORIO', {|| Iif(!Empty(aDocExc),TM200VDoc(aDocExc[oListBox:nAt,nPosFil],aDocExc[oListBox:nAt,nPosDoc],aDocExc[oListBox:nAt,nPosSer]),.F.) } , STR0066, STR0065 }) //'Documento'
	AAdd(aButtons,{'PESQUISA' , {|| TMSA200Psq(aDocExc,oListBox,nPosFil,nPosDoc,nPosSer)},STR0067,STR0067})	//'Pesquisa'

	DEFINE MSDIALOG oDlgEsp TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] PIXEL

	oListBox := TWBrowse():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,4]-aPosObj[1,2],aPosObj[1,3]-aPosObj[1,1], Nil, ;
			                               aHDocExc, Nil, oDlgEsp, Nil, Nil, Nil,,,,,,,,,, "ARRAY", .T. )

	oListBox:bLDblClick  := { || Iif( (lRateio .Or. !lGerLot),	(aMsgErr := {},TmsA200All(oListBox,aDelDocto,,,aDocExc,nPosFil,nPosDoc,nPosSer,,oTotMrc,@nTotMrc,@aMsgErr)),;
												(aMsgErr := {},TmsA200Cmp(oListBox,aDelDocto,,,aDocExc,nPosFil,nPosDoc,nPosSer,,,oTotMrc,@nTotMrc,@aMsgErr)) ) }
	oListBox:bHeaderClick:= {|oObj,nCol| If(nCol==1,(aMsgErr := {},TmsA200All(oListBox,aDelDocto,,,aDocExc,nPosFil,nPosDoc,nPosSer,,oTotMrc,@nTotMrc,@aMsgErr)),)}
	oListBox:SetArray( aDocExc )
	oListBox:bLine := &('{ || TM200DExbL(oListBox:nAT,aDocExc,aPict) }')
	//-- Rodape
	@ aPosObj[2,1],   aPosObj[2,2] TO aPosObj[2,3],aPosObj[2,4] LABEL "" OF oDlgEsp PIXEL
	@ aPosObj[2,1]+05,aPosObj[2,2]+005 SAY "Total de Documentos:"	SIZE 75,7 OF oDlgEsp PIXEL
	@ aPosObj[2,1]+05,aPosObj[2,2]+065 MSGET oTotDoc	VAR nTotDoc	SIZE 30,7 OF oDlgEsp PIXEL
	@ aPosObj[2,1]+05,aPosObj[2,2]+105 SAY "Documentos Marcados:"	SIZE 75,7 OF oDlgEsp PIXEL
	@ aPosObj[2,1]+05,aPosObj[2,2]+165 MSGET oTotMrc	VAR nTotMrc	SIZE 30,7 OF oDlgEsp PIXEL

	ACTIVATE MSDIALOG oDlgEsp ON INIT EnchoiceBar(oDlgEsp,{|| nOpca := 1,If(Tms200MOK(aDocExc), oDlgEsp:End(),nOpca := 0) },{|| oDlgEsp:End() },, aButtons )

Else
	nLinDoc := Ascan(aDocExc,{|x| x[nPosFil] + x[nPosDoc] + x[nPosSer] == cFilDoc + cDoc + cSerie})
	If nLinDoc > 0
		nOpca := 1
		TmsA200Cmp(,aDelDocto,,,aDocExc,nPosFil,nPosDoc,nPosSer,nLinDoc)
	EndIf
EndIf

If	nOpca == 1
	If Empty(aMsgErr)
		lRet := .T.
	Else
		If lRateio .Or. !lGerLot
			TmsMsgErr(aMsgErr)
			lRet := .F.
		Else
			lRet := .T.
		EndIf
	EndIf
EndIf

Return( lRet )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TmsA200All≥ Autor ≥ N3-DL/Sustentacao     ≥ Data ≥22.10.2011≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Marca / desmarca todos documentos                          ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpO1 = Objeto da msselect                                 ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TmsA200All(oListBox,aDelDocto,l200Marca,l500Doc,aDocExc,nPosFil,nPosDoc,nPosSer,nLinDoc,oTotMrc,nTotMrc,aMsgErr)
Local nCntFor := 0
Local lMarca  := aDocExc[1,1]

For nCntFor := 1 To Len( aDocExc )
	If (!lMarca .And. !aDocExc[nCntFor,1]) .Or. (lMarca .And. aDocExc[nCntFor,1])
		oListBox:nAt := nCntFor
		TmsA200Cmp(oListBox,aDelDocto,l200Marca,l500Doc,aDocExc,nPosFil,nPosDoc,nPosSer,nLinDoc,.T.,oTotMrc,@nTotMrc,@aMsgErr)
	EndIf
Next nCntFor

If Len(aMsgErr) > 0
	TmsMsgErr(aMsgErr)
EndIf

oListBox:nAt := 1
oListBox:Refresh(.T.)
Return( .T. )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TmsA200Cmp≥ Autor ≥ Alex Egydio           ≥ Data ≥17.02.2003≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Marca todos os documentos com o mesmo numero de composicao ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpO1 = Objeto da msselect                                 ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TmsA200Cmp(oListBox,aDelDocto,l200Marca,l500Doc,aDocExc,nPosFil,nPosDoc,nPosSer,nLinDoc,lMarkAll,oTotMrc,nTotMrc,aMsgErr)

Local aAreaDT6      := DT6->(GetArea())
Local aAreaDTC      := DTC->(GetArea())
Local cSeekDT6      := ''
Local cCompLot      := ''
Local cFilDco       := ''
Local cDocto        := ''
Local cSerie        := ''
Local nSeek         := 0
Local nCntFor       := 0
Local lMostra       := .F.
Local bWhile
Local lOcoNfc       := .F.

Local lContDoc      := SuperGetMv("MV_CONTDOC",.F.,.F.) .And. FindFunction("TmsConTran")	//-- Parametro para controle de TransaÁıes da Viagem
Local lCont         := .T.
Local lTemErro      := .T.

DEFAULT l500Doc     := .F.
DEFAULT nPosFil     := 0
DEFAULT nPosDoc     := 0
DEFAULT nPosSer     := 0
DEFAULT l200Marca   := .T.
DEFAULT nLinDoc     := 0
DEFAULT lMarkAll    := .F.

//-- Posiciona no item atual
DT6->(DbSetOrder(1)) //DT6_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE
If	ValType(oListBox)=='O'
	DT6->(MsSeek(xFilial("DT6")+aDocExc[oListBox:nAt,nPosFil]+aDocExc[oListBox:nAt,nPosDoc]+aDocExc[oListBox:nAt,nPosSer]))
ElseIf nLinDoc > 0
	DT6->(MsSeek(xFilial("DT6")+aDocExc[nLinDoc,nPosFil]+aDocExc[nLinDoc,nPosDoc]+aDocExc[nLinDoc,nPosSer]))
EndIf

If !l500Doc
	DT6->(DbSetOrder(9)) //DT6_FILIAL+DT6_NUMCMP+DTC_FILDOC
	cSeekDT6 := DT6->(xFilial('DT6')) + DT6->DT6_NUMCMP + DT6->DT6_FILDOC
	bWhile   := { || DT6->( ! Eof() .And. DT6->DT6_FILIAL + DT6->DT6_NUMCMP + DT6->DT6_FILDOC == cSeekDT6 ) }
	cCompLot := DT6->(xFilial('DT6') + DT6_FILORI + DT6_LOTNFC)
Else
	DT6->(DbSetOrder(1)) //DT6_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE
	cSeekDT6 := DT6->(xFilial('DT6')) + DT6->DT6_FILDOC + DT6->DT6_DOC + DT6->DT6_SERIE
	bWhile   := { || DT6->( ! Eof() .And. DT6->DT6_FILIAL + DT6->DT6_FILDOC + DT6->DT6_DOC + DT6->DT6_SERIE == cSeekDT6 ) }
EndIf

//-- Marcar/desmarcar os documentos
If DT6->(MsSeek(cSeekDT6)) //DT6_FILIAL+DT6_NUMCMP+DTC_FILDOC
	While Eval( bWhile )
	
		//--Controle de transaÁıes, trava o registro que est· sendo usado por outra estaÁ„o
		If lContDoc
			If l200Marca
				If !TmsConTran(DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE,.T.)
					lCont := .F.
				EndIf
			Else
				TmsConTran(DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE,.F.)
			EndIf
		EndIf

		If lCont
			lMostra := .F.
			//-- Se o Status do Documento for diferente de 'Em Aberto', mostra help somente uma vez
			If !l500Doc
	
				//-- Verificar se pertence ao mesmo lote!
				If cCompLot <> DT6->(xFilial('DT6') + DT6_FILORI + DT6_LOTNFC)
					DT6->(DbSkip())
					Loop
				EndIf
	
				//-- Carga Fechada - Verifica se o status 'Entregue'
				//   foi gerado automaticamente pela Nota Fiscal do Cliente.
				If	lTmsCFec .And. DT6->DT6_STATUS == StrZero( 7, Len( DT6->DT6_STATUS ) )   //-- Entregue
					//-- Verifica se o status foi gerado pela nota fiscal
					DTC->(DbSetOrder(3))
					If DTC->(MsSeek(xFilial('DTC')+DT6->DT6_FILDOC+DT6->DT6_DOC+DT6->DT6_SERIE))
						If !Empty(DTC->DTC_DTENTR) .Or. !Empty(DTC->DTC_HORENT)
							lOcoNfc := .T.
						EndIf
					Else
						lMostra :=.T.
					EndIf
				EndIf
		
				//-- Valida estorno do documento
				TM200VlCmp(@aMsgErr,lMostra,nLinDoc,lOcoNfc,)
	
				If lTM200EST .And. nLinDoc == 0
					lRet := ExecBlock("TM200EST",.F.,.F.)
					If ValType(lRet) == "L" .And. !lRet
						Aadd(aMsgErr,{STR0200,"00",""})	//-- "Estorno bloqueado por rotina de usu·rio."
						l200Marca := .F.
					EndIf
				EndIf
			EndIf
			
			//-- Marca para Exclusao
			If Empty(aMsgErr)
				If nPosFil > 0 .And. nPosDoc > 0 .And. nPosSer > 0
					nSeek := Ascan(aDocExc,{|x| x[nPosFil] + x[nPosDoc] + x[nPosSer] == DT6->DT6_FILDOC + DT6->DT6_DOC + DT6->DT6_SERIE})
					If nSeek > 0
						aDocExc[nSeek,1] := !aDocExc[nSeek,1]
						l200Marca := aDocExc[nSeek,1]
					EndIf
				EndIf
			EndIf
	
			nSeek := AScan(aDelDocto,{|x| x[1] + x[2] + x[3] == DT6->DT6_FILDOC + DT6->DT6_DOC + DT6->DT6_SERIE })
			If	Empty( nSeek )
				If	DT6->DT6_PRIPER == StrZero(1,Len(DT6->DT6_PRIPER))
					DTC->(DbSetOrder(4)) //DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE+DTC_SERVIC+DTC_CODPRO
				Else
					DTC->(DbSetOrder(3)) //DTC_FILIAL+DTC_FILDOC+DTC_DOCPER+DTC_SERIE+DTC_SERVIC+DTC_CODPRO
				EndIf
				AAdd( aDelDocto, {DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE,'',l200Marca,DT6->DT6_PRIPER} )
				nSeek := Len( aDelDocto )
				//-- Pesquisa documentos do primeiro percurso associado a este documento
				If	DTC->(MsSeek(xFilial('DTC') + aDelDocto[nSeek,1] + aDelDocto[nSeek,2] + aDelDocto[nSeek,3]))
					If	! Empty(DTC->DTC_DOCPER)
						//-- Documento do primeiro percurso
						AAdd( aDelDocto, {DTC->DTC_FILDOC,DTC->DTC_DOCPER,DTC->DTC_SERIE,DTC->DTC_DOC,l200Marca,StrZero(1,Len(DT6->DT6_PRIPER))} )
					EndIf
				EndIf
			Else
				cFilDco	:= aDelDocto[ nSeek, 1 ]
				cDocto	:= aDelDocto[ nSeek, 2 ]
				cSerie	:= aDelDocto[ nSeek, 3 ]
				For nCntFor := 1 To Len( aDelDocto )
					If	aDelDocto[ nCntFor, 1 ] + aDelDocto[ nCntFor, 2 ] + aDelDocto[ nCntFor, 3 ] == cFilDco + cDocto + cSerie .Or.;
						aDelDocto[ nCntFor, 1 ] + aDelDocto[ nCntFor, 4 ] + aDelDocto[ nCntFor, 3 ] == cFilDco + cDocto + cSerie
						aDelDocto[ nCntFor, 5 ] := l200Marca
					EndIf
				Next
			EndIf
			If Empty(aMsgErr)
				If l200Marca
					nTotMrc ++
				Else
					nTotMrc --
				EndIf
			EndIf
		EndIf
		DT6->(DbSkip())
	EndDo
EndIf

If Len(aMsgErr) > 0 .And. !IsInCallStack("TMSA200All")
	TmsMsgErr(aMsgErr)
EndIf

RestArea(aAreaDTC)
RestArea(aAreaDT6)

If	ValType(oListBox)=='O'
	oListBox:Refresh(.T.)
	oTotMrc:Refresh()
EndIf

Return( .T. )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TmsA200Lte≥ Autor ≥ Alex Egydio           ≥ Data ≥17.02.2003≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Cria lote de estorno e atualiza a quantidade digitada do   ≥±±
±±≥          ≥ lote original                                              ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpC1 = Lote de notas fiscais do cliente                   ≥±±
±±≥          ≥ ExpC2 = Status do lote de estorno                          ≥±±
±±≥          ≥ ExpN1 = Qtde de notas fiscais do cliente                   ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function TmsA200Lte(cLotNfc,cStatus,nQtdNfc)

Local aAreaDTP  := DTP->(GetArea())
Local cNumLot   := ''
Local cTipLot   := ''
Local cViagem   := ''
Local cRateio   := ""
Local cBacRat   := ""
Local cCriRat   := ""
Local cProRat   := ""
Local cTabRat   := ""
Local cTipRat   := ""
Local cTbaRat   := ""
Local cTpaRat   := ""
Local cCrdVfa   := ""
Local cCrdVdc   := ""
Local cNContr   := ""
Local cCodNeg   := ""
Local cServic   := ""

//-- Atualiza a quantidade de notas digitadas do lote original
DTP->(DbSetOrder(1))
If	DTP->(MsSeek(xFilial('DTP') + cLotNfc))
	cTipLot := DTP->DTP_TIPLOT
	cViagem := DTP->DTP_VIAGEM
	//-- Copia dados projeto carga fechada
    cRateio := DTP->DTP_RATEIO
    cBacRat := DTP->DTP_BACRAT
    cCriRat := DTP->DTP_CRIRAT
    cProRat := DTP->DTP_PRORAT
    cTabRat := DTP->DTP_TABRAT
    cTipRat := DTP->DTP_TIPRAT
    cTbaRat := DTP->DTP_TBARAT
    cTpaRat := DTP->DTP_TPARAT
    cCrdVfa := DTP->DTP_CRDVFA
    cCrdVdc := DTP->DTP_CRDVDC
    cNContr := DTP->DTP_NCONTR
    cCodNeg := DTP->DTP_CODNEG
    cServic := DTP->DTP_SERVIC
	RecLock('DTP',.F.)
	If DTP->DTP_QTDLOT - nQtdNfc == 0
		DTP->(DbDelete())
	Else
		DTP->DTP_QTDLOT -= nQtdNfc
		DTP->DTP_QTDDIG -= nQtdNfc
	EndIf
	MsUnLock()
EndIf

cNumLot := CriaVar("DTP_LOTNFC")
ConfirmSX8()

RecLock('DTP',.T.)
DTP->DTP_FILIAL := xFilial('DTP')
DTP->DTP_FILORI := cFilAnt
DTP->DTP_LOTNFC := cNumLot
DTP->DTP_DATLOT := dDataBase
DTP->DTP_HORLOT := StrTran(Left(Time(),5),":","")
DTP->DTP_QTDLOT := nQtdNfc
DTP->DTP_QTDDIG := nQtdNfc
DTP->DTP_STATUS := cStatus
DTP->DTP_TIPLOT := cTipLot
DTP->DTP_VIAGEM := cViagem
//-- Copia dados projeto carga fechada
DTP->DTP_RATEIO := cRateio
DTP->DTP_BACRAT := cBacRat
DTP->DTP_CRIRAT := cCriRat
DTP->DTP_PRORAT := cProRat
DTP->DTP_TABRAT := cTabRat
DTP->DTP_TIPRAT := cTipRat
DTP->DTP_TBARAT := cTbaRat
DTP->DTP_TPARAT := cTpaRat
DTP->DTP_CRDVFA := cCrdVfa
DTP->DTP_CRDVDC := cCrdVdc
DTP->DTP_NCONTR := cNContr
DTP->DTP_CODNEG := cCodNeg
DTP->DTP_SERVIC := cServic
MsUnlock()

If	ExistBlock('TM200LTE')
	ExecBlock('TM200LTE',.F.,.F., { cLotNfc })
EndIf

RestArea(aAreaDTP)

Return( cNumLot )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200Rec≥ Autor ≥ Alex Egydio           ≥ Data ≥22.05.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Gera documento a partir dos pedidos liberados              ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA200Rec()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpC1 = Alias do arquivo                                   ≥±±
±±≥          ≥ ExpN1 = Numero do registro                                 ≥±±
±±≥          ≥ ExpN2 = Opcao selecionada                                  ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TMSA200Rec( cAlias, nReg, nOpcx, lConfirma, lBlqInter )

Local aSays     := {}
Local aButtons  := {}
Local nOpca     := 0
Local lTM200CAN := ExistBlock("TM200CAN")
Local lPETM200D := ExistBlock("TM200DT")
Local dDatFTMS  := GetMv("MV_DATATMS",.F.,CtoD(''))
Local dDataOri  := dDataBase
Local lContinua := .T.

Default lConfirma := .T.
Default lBlqInter := .F.

If ValType(lConfirma) != 'L'
	lConfirma := .T.
EndIf

//-- Inicializa array de pedidos bloqueados
aPedBlq  := {}

If	DTP->DTP_STATUS != '4' .And. !lBlqInter	//-- Diferente de bloqueado
	Return( Nil )
EndIf

//-- Verifica se o agendamento est· sendo utilizado por outro usu·rio no painel de agendamentos
If !TMSAVerAge("5",,,,,,,,,,,,"2",.T.,.T.,DTP->DTP_LOTNFC,,StrZero(ThreadId(),20))
	Return (.F.)
EndIf

If DTP->DTP_FILORI != cFilAnt
	//-- Limpa marcas dos agendamentos
	//-- Analisar a inserÁ„o desta rotina antes de cada Return( .F. ) ou ( .T. ), quando utilizado TmsVerAge
	If !IsInCallStack("TMSAF76")
		TMSALimAge(StrZero(ThreadId(),20))
	EndIf
	Help(' ', 1, 'TMSA20019',,STR0047 + DTP->DTP_FILORI + ' / ' + DTP->DTP_LOTNFC,5,11)			//-- Este lote nao pertence a esta filial !
	Return( .F. )
EndIf

If lPETM200D
	dDataBase := ExecBlock("TM200DT",.F.,.F.,dDataBase)
	If ValType(dDataBase) # "D"
		dDataBase := dDataOri
	EndIf
EndIf

If (SuperGetMv("MV_TMSTHRC", , 0) > 0) .And. (SuperGetMV("MV_TPNRNFS") != "3") .And. nOpcx == 4
	//-- Limpa marcas dos agendamentos
	//-- Analisar a inserÁ„o desta rotina antes de cada Return( .F. ) ou ( .T. ), quando utilizado TmsVerAge
	If !IsInCallStack("TMSAF76")
		TMSALimAge(StrZero(ThreadId(),20))
	EndIf
	Help( ' ', 1, STR0074,, STR0124,5,11) // Configure o parametro MV_TPNRNFS igual a 3 (SD9) para habilitar o uso de multi-threads
	Return( .F. )
EndIf

//-- Nao permite a emissao/estorno de documentos com data menor que o fechamento do estoque
If dDataBase <= MVUlmes()
	//-- Limpa marcas dos agendamentos
	//-- Analisar a inserÁ„o desta rotina antes de cada Return( .F. ) ou ( .T. ), quando utilizado TmsVerAge
	If !IsInCallStack("TMSAF76")
		TMSALimAge(StrZero(ThreadId(),20))
	EndIf
	Help ( " ", 1, "FECHTO" ) //"Nao pode ser digitado movimento com data anterior a ultima data de fechamento (virada de saldos)"
	Return( .F. )
EndIf

If !Empty(dDatFTMS)
	If dDataBase <= dDatFTMS
		//-- Limpa marcas dos agendamentos
		//-- Analisar a inserÁ„o desta rotina antes de cada Return( .F. ) ou ( .T. ), quando utilizado TmsVerAge
		If !IsInCallStack("TMSAF76")
			TMSALimAge(StrZero(ThreadId(),20))
		EndIf
		Help ( " ", 1, "FECHATMS" )
		Return( .F. )
	EndIf
EndIf

If lConfirma
	AAdd( aSays, STR0034 ) //'Este programa tem como objetivo, gerar documentos de transporte'
	AAdd( aSays, STR0035 ) //'apos a liberacao do credito.'

	AAdd( aButtons, { 1, .T., {|o| nOpcA := 1, o:oWnd:End() } } )
	AAdd( aButtons, { 2, .T., {|o| o:oWnd:End() } } )

	FormBatch( cCadastro, aSays, aButtons )
Else
	nOpcA := 1
EndIf

If nOpca == 1
	If DTP->( SimpleLock() )
		RecLock('DTP',.F.)
		Processa( {|lEnd| lContinua := TMSA200Lib(DTP->DTP_FILORI,DTP->DTP_LOTNFC,.T.,@lEnd) }, cCadastro,STR0012, .F. ) //'Gerando Conhecimentos do primeiro percurso...'
		Processa( {|lEnd| lContinua := lContinua .And. TMSA200Lib(DTP->DTP_FILORI,DTP->DTP_LOTNFC,.F.,@lEnd) }, cCadastro,STR0012, .F. ) //'Gerando Conhecimentos...'
		If lContinua
			TMSA200Prc(DTP->DTP_FILORI,DTP->DTP_LOTNFC,.T.)
		EndIf
		DTP->(MsUnlock())
	Else
		Help(' ', 1, 'TMSA20027') //"Lote sendo utilizado por outro usuario"
	EndIf
Else
	If lTM200CAN
		ExecBlock("TM200CAN",.F.,.F.)
	EndIf
EndIf

//-- Restaura a database do sistema
If lPETM200D
	dDataBase := dDataOri
EndIf

//-- Limpa marcas dos agendamentos
If !IsInCallStack("TMSAF76")
	TMSALimAge(StrZero(ThreadId(),20))
EndIf

Return .T.

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200Lib≥ Autor ≥ Alex Egydio           ≥ Data ≥22.05.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Gera documentos a partir dos pedidos liberados             ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥          ≥ ExpC1 = Filial de origem                                   ≥±±
±±≥          ≥ ExpC2 = Numero do lote                                     ≥±±
±±≥          ≥ ExpL1 = .T. = Documento do primeiro percurso               ≥±±
±±≥          ≥ ExpL2 = Cancela processamento                              ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TMSA200Lib(cFilOri,cLotNfc,l1oPerc,lEnd)
Local aAreaAnt	:= GetArea()
Local aAreaSC9	:= SC9->(GetArea())
Local aAreaDTP	:= DTP->(GetArea())
Local lRet      := .T.
Local aProduto	:= {}
Local aTmsA200	:= {}
Local aFrete	:= {}
Local aMsgErr	:= {}
Local bWhile	:= {||.T.}
Local cSeek		:= ''
Local cSeekDTC	:= ''
Local cSeekSC9	:= ''
Local cServic	:= ''
Local cCodPro	:= Space(Len(SB1->B1_COD))
Local nOrdDTC	:= 0
Local nPosDTC	:= 0
Local nSeek		:= 0
Local cFilSol	:= ''
Local cNumSol	:= ''
Local cTes		:= ''
Local lCalcISS	:= .F.
Local cSerie	:= ''
Local cPaisDes	:= ''
Local cTMSMFat	:= GetMV("MV_TMSMFAT",,"") //-- Modo de Faturamento:1-Faturamento a partir do SE1;2=Faturamento a partir do DT6
Local aPerfil	:= {}
Local cDocFat	:= ''
Local bFatSE1	:= {|| }
Local cFilDes	:= ""
Local aFreteCol := {}
Local lDT6TipVei := DT6->(ColumnPos("DT6_TIPVEI")) > 0
Local cSeqDes	:= ''

If lPrcProd ==  Nil
	lPrcProd := GetMV('MV_PRCPROD',,.T.)
EndIf
If	cMv_Estado == ""
	cMv_Estado := SuperGetMV("MV_ESTADO",.F.,"")
EndIf

DTC->(DbSetOrder(1)) //DTC_FILIAL+DTC_FILORI+DTC_LOTNFC+DTC_CLIREM+DTC_LOJREM+DTC_CLIDES+DTC_LOJDES+DTC_SERVIC+DTC_CODPRO+DTC_NUMNFC+DTC_SERNFC+DTC_NUMSOL
ProcRegua(DTC->(RecCount()))

If	DTC->(MsSeek(cSeek := xFilial('DTC') + cFilOri + cLotNfc))
	While Empty(aMsgErr) .And. DTC->( ! Eof() .And. DTC->DTC_FILIAL + DTC->DTC_FILORI + DTC->DTC_LOTNFC == cSeek )
		IncProc()
		If	lEnd
			Exit
		EndIf

		If DTC->DTC_SERIE <> 'PED'
			DTC->(DbSkip())
			Loop
		EndIf

		If	l1oPerc
			//-- Se preencher a regiao do primeiro percurso, gerar documentos para o primeiro percurso
			If	Empty(DTC->DTC_CDRPER)
				DTC->(DbSkip())
				Loop
			EndIf
			bWhile   := {|| DTC->(! Eof() .And. DTC->DTC_FILIAL + DTC->DTC_FILDOC + DTC->DTC_DOCPER == cSeekDTC) }
			cSeekSC9 := xFilial('SC9') + DTC->DTC_CLIREM + DTC->DTC_LOJREM + PADR(DTC->DTC_DOCPER,Len(SC9->C9_PEDIDO))
			nOrdDTC  := 4 //DTC_FILIAL+DTC_FILDOC+DTC_DOCPER+DTC_SERIE+DTC_SERVIC+DTC_CODPRO
		Else
			bWhile   := {|| DTC->(! Eof() .And. DTC->DTC_FILIAL + DTC->DTC_FILDOC + DTC->DTC_DOC == cSeekDTC) }
			cSeekSC9 := xFilial('SC9') + DTC->DTC_CLIDEV + DTC->DTC_LOJDEV + PADR(DTC->DTC_DOC,Len(SC9->C9_PEDIDO))
			nOrdDTC  := 3 //DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE+DTC_SERVIC+DTC_CODPRO
		EndIf

		//-- Liberado o credito, vai direto para a etapa de geracao dos documentos
		SC9->(DbSetOrder(2)) //C9_FILIAL+C9_CLIENTE+C9_LOJA+C9_PEDIDO+C9_ITEM
		If	SC9->(!MsSeek(cSeekSC9))
			DTC->(DbSkip())
			Loop
		EndIf
		//-- Se nao liberou todos os pedidos (credito ou transporte), o status do lote permanece como bloqueado
		If	! Empty( SC9->C9_BLCRED ) .Or. ! Empty( SC9->C9_BLTMS )
			//-- Tipo do Cliente Destinatario - Conforme solicitacao do bops 102588
			TMSA200Cli( SC9->C9_CLIENTE, SC9->C9_LOJA)   //posiciona na tabela SA1
			AAdd( aPedBlq, { SC9->C9_LOTNFC, SC9->C9_PEDIDO, SC9->C9_ITEM, SC9->C9_BLCRED, SC9->C9_BLTMS, SC9->C9_CLIENTE, SC9->C9_LOJA, SA1->A1_NREDUZ, SC9->C9_PRODUTO, SC9->C9_QTDLIB, SC9->C9_PRCVEN, SC9->C9_SERVIC, SC9->C9_BLINF } )
			DTC->(DbSkip())
			Loop
		EndIf

		If Empty(cTes)
			SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
			If SC6->(MsSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM))
				cTes := SC6->C6_TES
				SF4->(DbSetOrder(1))
				If SF4->(MsSeek(xFilial("SF4")+cTes)) .And. SF4->F4_ISS == "S"
					lCalcISS := .T.
				EndIf
			EndIf
		EndIf

		cServic  := DTC->DTC_SERVIC
		cSeqDes	 := DTC->DTC_SQEDES
		aProduto := {}

		If Empty(cNumSol)
			If !Empty(DTC->DTC_FILCFS)
				cFilSol := DTC->DTC_FILCFS
			Else
				cFilSol := DTC->DTC_FILORI
			EndIf
			cNumSol := DTC->DTC_NUMSOL
		EndIf

		//-- Cliente utiliza preco por produto
		If !lPrcProd
			aContrt := TMSContrat(DTC->DTC_CLICAL,DTC->DTC_LOJCAL,,DTC->DTC_SERVIC,.F.,DTC->DTC_TIPFRE,,,DTC->DTC_CLIREM,DTC->DTC_LOJREM,DTC->DTC_CLIDES,DTC->DTC_LOJDES,,DTC->DTC_CLIDEV,DTC->DTC_LOJDEV,DTC->DTC_TIPNFC,,,,,,DTC->DTC_CODNEG)
			If !Empty( aContrt ) .And. aContrt[1,24] == "1"
				lPrcProd := .T.
			EndIf
		EndIf

		//-- Neste ponto estou posicionado no proximo numero de pedido, e nao devo perder este ponteiro
		nPosDTC := DTC->(Recno())

		DTC->(DbSetOrder( nOrdDTC ))
		If	DTC->(MsSeek( xFilial('DTC') + cFilOri + PADR(SC9->C9_PEDIDO,Len(DTC->DTC_DOC)) + 'PED' + cServic))
			cSeekDTC := DTC->DTC_FILIAL + DTC->DTC_FILDOC + DTC->DTC_DOC
			While Eval(bWhile)
				If DTC->DTC_SERIE <> 'PED' .Or. DTC->DTC_SERVIC <> cServic
					DTC->(dbSkip())
					Loop
				EndIf
				If lPrcProd
					cCodPro := DTC->DTC_CODPRO
				EndIf
				aFrete := {}
				TmsViewFrt('3',cFilOri,PADR(SC9->C9_PEDIDO,Len(DTC->DTC_DOC)),'PED',cCodPro,,,aFrete)  //FNC recalculo

				If	( nSeek := ASCan(aProduto,{ |x| x[1] == cCodPro }) ) == 0
					AAdd(aProduto,{cCodPro,AClone(aFrete),{}})
					nSeek := Len(aProduto)
				EndIf

				If	ASCan(aProduto[nSeek,3],{|x|x[1]+x[2]==DTC->DTC_NUMNFC+DTC->DTC_SERNFC})<=0
					AAdd(aProduto[nSeek,3],{DTC->DTC_NUMNFC, DTC->DTC_SERNFC})
				EndIf

				DTC->(DbSkip())
			EndDo
		Else
			DTC->(DbSkip())
			Loop
		EndIf

		DT6->(DbSetOrder( 2 ))
		If	DT6->(MsSeek(xFilial('DT6') + cFilOri + cLotNfc + cFilAnt + PADR(SC9->C9_PEDIDO,Len(DTC->DTC_DOC)) + 'PED'))
			DUI->(DbSetOrder(1)) //DUI_FILIAL+DUI_DOCTMS
			DUI->(MsSeek(xFilial('DUI') + DT6->DT6_DOCTMS))

			cSerie := DUI->DUI_SERIE
			//-- Verifica se informou serie para origem em outra filial.
			If	!Empty(DUI->DUI_SEROUT)
				TMSA200CdRg(DT6->DT6_CDRORI) //Posiciona no grupo de Regiao
				If	cMv_Estado <> DUY->DUY_EST
					cSerie := DUI->DUI_SEROUT
				EndIf
			EndIf

			If DT6->DT6_TIPTRA == StrZero(4,Len(DC5->DC5_TIPTRA)) //-- Rodoviario Internacional
				//--Procuro por Regiao de Calculo, depois Regiao de Destino, e por ultimo sem Regiao
				DI0->(DbSetOrder(1)) //DI0_FILIAL+DI0_FILORI+DI0_FILDES
				TMSA200CdRg(DT6->DT6_CDRCAL)   //Posiciona no grupo de Regiao
				cFilDes := DUY->DUY_FILDES
				cPaisDes := DUY->DUY_PAIS
				If DI0->(MsSeek(xFilial("DI0")+cFilOri+cFilDes+cPaisDes))
					cSerie := DI0->DI0_SERIE
				Else
					TMSA200CdRg(DT6->DT6_CDRDES)   //Posiciona no grupo de Regiao
					cFilDes := DUY->DUY_FILDES
					cPaisDes := DUY->DUY_PAIS
					If DI0->(MsSeek(xFilial("DI0")+cFilOri+cFilDes+cPaisDes))
						cSerie := DI0->DI0_SERIE
					Else
						If DI0->(MsSeek(xFilial("DI0")+cFilOri+Space(Len(DI0->DI0_FILDES))+cPaisDes)) //Busca sem a Filial de Destino, pois existem permissos desta forma
							cSerie := DI0->DI0_SERIE
						EndIf
					EndIf
				EndIf
			Else
				//-- Utiliza SUB SERIE no Conhecimento
				DC5->(dbSetOrder(1)) //DC5_FILIAL+DC5_SERVIC+DC5_ORDEM
				If	DC5->(MsSeek(xFilial("DC5")+DT6->DT6_SERVIC, .F. ) )
					If DC5->DC5_UTSUBS == StrZero(1 ,Len(DC5->DC5_UTSUBS)) .AND. !Empty(DUI->DUI_SUBSER)
						cSerie := DUI->DUI_SUBSER
					EndIf
				EndIf
			EndIf

			aTmsA200 := {}
			AAdd(aTmsA200,SC9->C9_PEDIDO)			//-- 01 Pedido
			AAdd(aTmsA200,SC9->C9_CLIENTE)			//-- 02 Cliente devedor
			AAdd(aTmsA200,SC9->C9_LOJA)				//-- 03 Loja
			AAdd(aTmsA200,cLotNfc)					//-- 04 Lote
			AAdd(aTmsA200,cSerie)					//-- 05 Serie do documento
			AAdd(aTmsA200,{})						//-- 06 Parametros passados pelo tmsa500
			AAdd(aTmsA200,AClone(aProduto))			//-- 07 Composicao de frete e Nfc por produto
			AAdd(aTmsA200,DT6->DT6_CLIREM)			//-- 08 Cliente remetente
			AAdd(aTmsA200,DT6->DT6_LOJREM)			//-- 09 Loja
			AAdd(aTmsA200,l1oPerc)					//-- 10 l1oPerc .T. = documento primeiro percurso
			AAdd(aTmsA200,.F.)						//-- 11 lAtzPed .T. = Grava DT8/DT6
			AAdd(aTmsA200,.F.)						//-- 12 Indica ultimo documento
			AAdd(aTmsA200,'')						//-- 13 Taxa por documento
			AAdd(aTmsA200,DT6->DT6_CLIDES)			//-- 14 Cliente destinatario
			AAdd(aTmsA200,DT6->DT6_LOJDES)			//-- 15 Loja
			AAdd(aTmsA200,DT6->DT6_SERTMS)			//-- 16 Tipo de servico
			AAdd(aTmsA200,DT6->DT6_TIPTRA)			//-- 17 Tipo de transporte
			AAdd(aTmsA200,DT6->DT6_CDRORI)			//-- 18 Regiao origem
			AAdd(aTmsA200,DT6->DT6_CDRDES)			//-- 19 Regiao destino
			AAdd(aTmsA200,'')						//-- 20 Cliente consignatario
			AAdd(aTmsA200,'')						//-- 21 Loja
			AAdd(aTmsA200,'')						//-- 22 Cliente despachante
			AAdd(aTmsA200,'')						//-- 23 Loja
			AAdd(aTmsA200,0)						//-- 24 Qtde de volumes
			AAdd(aTmsA200,0)						//-- 25 Valor da mercadoria
			AAdd(aTmsA200,0)						//-- 26 Peso real
			AAdd(aTmsA200,0)						//-- 27 Peso cubado
			AAdd(aTmsA200,0)						//-- 28 Metro cubico
			AAdd(aTmsA200,0)						//-- 29 Base RR
			AAdd(aTmsA200,0)						//-- 30 Qtde de unitizadores
			AAdd(aTmsA200,'')						//-- 31 Tabela de frete
			AAdd(aTmsA200,'')						//-- 32 Tipo da tabela de frete
			AAdd(aTmsA200,'')						//-- 33 Sequencia da tabela de frete
			AAdd(aTmsA200,DT6->DT6_CDRCAL)			//-- 34 Codigo da regiao de calculo
			AAdd(aTmsA200,DT6->DT6_TIPFRE)			//-- 35 Tipo do frete
			AAdd(aTmsA200,'')						//-- 36 Nr. do contrato de prestacao de servicos
			AAdd(aTmsA200,DT6->DT6_DOCTMS)			//-- 37 Tipo de documento
			AAdd(aTmsA200,'')						//-- 38 Devedor do frete
			AAdd(aTmsA200,DT6->DT6_SERVIC)			//-- 39 Codigo do servico
			AAdd(aTmsA200,'')						//-- 40 Codigo da Mensagem Fiscal
			AAdd(aTmsA200,'')						//-- 41 Numero da composicao
			AAdd(aTmsA200,'')						//-- 42 Codigo do cliente de calculo
			AAdd(aTmsA200,'')						//-- 43 Loja do cliente de calculo

			AAdd(aTmsA200,'')						//-- 44 Peso cobrado
			AAdd(aTmsA200,DUI->DUI_CODPRO)			//-- 45 Produto de imposto
			AAdd(aTmsA200,Iif(lDT6TipVei,DT6->DT6_TIPVEI,'')) //-- 46 Tipo do Veiculo
			AAdd(aTmsA200,{})						//-- 47 Valor Informado
			AAdd(aTmsA200,0)						//-- 48 Valor CTRC Despachante
			AAdd(aTmsA200,'')						//-- 49 Condicao de Pagamento
			AAdd(aTmsA200,cSeqDes)					//-- 50 Seq. Endereco do Destinatario
			AAdd(aTmsA200,0) 						//-- 51 Peso Liquido
			AAdd(aTmsA200,'') 						//-- 52 - CLiente Expedidor
			AAdd(aTmsA200,'') 						//-- 53 - Loja Expedidor
			Aadd(aTmsA200,'')                  		//-- 54 - Codigo Negociacao
			Aadd(aTmsA200,'')                  		//-- 55 - Cliente Recebedor
			Aadd(aTmsA200,'')					   	//-- 56 - Loja Recebedor

			If cTMSMFat == '2'
				bFatSE1 := {|| .F. }
				//-- Obtem o perfil do cliente para verificar quais documentos possuem tratamento diferenciado no
				//-- faturamento:
				aPerfil := TmsPerfil(DT6->DT6_CLICAL,DT6->DT6_LOJCAL,,,DT6->DT6_CLIREM,DT6->DT6_LOJREM,DT6->DT6_CLIDES,DT6->DT6_LOJDES)
				cDocFat := aPerfil[47]
				If AllTrim(cDocFat) <> '*' .And. (DT6->DT6_DOCTMS $ cDocFat)
						bFatSE1 := {|| .T. }
				ElseIf AllTrim(cDocFat) == '*'
					bFatSE1 := {|| .T. }
				EndIf
			Else
				bFatSE1 := {|| .T. }
			EndIf

			TmsA200Atz(aTmsA200,,,DT6->DT6_CDRCAL,cNumSol,lCalcISS,cFilSol,bFatSE1,@aMsgErr)
		EndIf
		//-- Posiciono o ponteiro do DTC para garantir que estou no ultimo ponto de parada e continuar o processamento
		DTC->(DbSetOrder( 1 ))
		DTC->(MsGoto(nPosDTC))

	EndDo
EndIf

If !Empty(aMsgErr)
	TmsMsgErr(aMsgErr)
	lRet := .F.
EndIf

ResetArr(@aProduto	)
ResetArr(@aTmsA200	)
ResetArr(@aFrete	)
ResetArr(@aMsgErr	)
ResetArr(@aFreteCol )

RestArea(aAreaDTP)
RestArea(aAreaSC9)
RestArea(aAreaAnt)

Return( lRet )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TmsA200Srv≥ Autor ≥ Alex Egydio           ≥ Data ≥19.11.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Identifica o servico (Servico Automatico)                  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpL1 = .F. Interrompe o processamento                     ≥±±
±±≥          ≥ ExpC1 = Filial de origem                                   ≥±±
±±≥          ≥ ExpC2 = Numero do lote                                     ≥±±
±±≥          ≥ ExpA1 = Array contendo as Mensagens de Erro                ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Retorno   ≥                                                            ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TmsA200Srv(lEnd,cFilOri,cLotNfc,aVisErr,lRecalculo)

Local nx
Local aAreaAnt    := GetArea()
Local aAreaDTC    := DTC->(GetArea())
Local aAreaDTP    := DTP->(GetArea())
Local aContrt     := {}
Local aNfCTRC     := {}
Local cChave      := ''
Local cCliAgr     := ''
Local cLojAgr     := ''
Local cCliCal     := ''
Local cLojCal     := ''
Local cSeek       := ''
Local lRet        := .T.
Local nCntFor     := 0
Local n1Cnt       := 0
Local nQtdVol     := 0
Local nValor      := 0
Local nPeso       := 0
Local nPesoM3     := 0
Local nMetro3     := 0
Local nSeguro     := 0
Local nQtdUni     := 0
Local cAliasDTC   := "DTC"
Local cQuery      := ""
Local cCampos     := ""
Local aStruDTC    := {}
Local lDevedor    := .F.
Local lAgdEntr	:= Iif(FindFunction("TMSA018Agd"),TMSA018Agd(),.F.)   //-- Agendamento de Entrega.
Local aCteAnt     := {}
Local nValDPC     := 0
Local lExped      := DTC->(ColumnPos("DTC_CLIEXP")) > 0
Local lRecebedor  := DTC->(ColumnPos("DTC_CLIREC")) > 0
Local lIdentDoc   := DTC->(ColumnPos("DTC_DOCTMS")) > 0
Local aFreteCol   := {}
Local aContrCli   := {}
Local cNumCmp     := ""

Default lEnd      := .F.

lValCol   := DTP->DTP_TIPLOT == StrZero(5,Len(DTP->DTP_TIPLOT))

If lTm200Fil
	cRet := ExecBlock("TM200FIL",.F.,.F.)
EndIf

ResetArr(@aNFTipVei )
aNFTipVei := {}
nNumCTRC  := 0

If	!lRecalculo
	//-- Somente lotes com status 2 - digitado
	DTP->(DbSetOrder(2)) //DTP_FILIAL+DTP_FILORI+DTP_LOTNFC
	DTP->(MsSeek( xFilial('DTP') + cFilOri + cLotNfc ))
	If	DTP->DTP_STATUS != StrZero(2,Len(DTP->DTP_STATUS))
		RestArea(aAreaDTC)
		RestArea(aAreaDTP)
		RestArea(aAreaAnt)
		Return( .F. )
	EndIf
	ResetArr(@aLote )
	ResetArr(@aPedblq )
	aLote  := {}
	aPedido:= {}
	aPedblq:= {}
EndIf

If !lValCol
	ProcRegua(DTC->(RecCount()))

	DTC->(DbSetOrder(1)) //DTC_FILIAL+DTC_FILORI+DTC_CLIREM+DTC_LOJREM+DTC_CLIDES+DTC_LOJDES+DTC_SERVIC+DTC_CODPRO+DTC_NUMNFC+DTC_SERNFC+DTC_NUMSOL
	cSeek := xFilial('DTC') + cFilAnt + cLotNfc

	aStruDTC  := DTC->(dbStruct())
	lQuery    := .T.
	cAliasDTC := GetNextAlias()
	cCampos := "DTC_FILIAL, DTC_FILORI, DTC_FILDPC, DTC_FILCFS, DTC_LOTNFC, DTC_NUMNFC, DTC_TIPNFC, DTC_SERNFC, DTC_NUMCOT, DTC_NUMSOL, DTC_DOC,    DTC_SERIE,  "
	cCampos += "DTC_CLIREM, DTC_LOJREM, DTC_CLIDES, DTC_LOJDES, DTC_CLIDEV, DTC_LOJDEV, DTC_CLICAL, DTC_LOJCAL, DTC_CLICON, DTC_LOJCON, DTC_CLIDPC, DTC_LOJDPC, "
	cCampos += "DTC_SERTMS, DTC_SERVIC, DTC_TIPNFC, DTC_TIPTRA, DTC_DEVFRE, DTC_TIPFRE, DTC_CDRDES, DTC_CDRCAL, DTC_CDRORI, DTC_CDRPER, DTC_SQEDES, DTC_SQICON, "
	cCampos += "DTC_SQIDES, DTC_SQIDPC, DTC_SQIREM, DTC_CTRDPC, DTC_CODPRO, DTC_BASSEG, DTC_KM,     DTC_METRO3, DTC_PESO,   DTC_PESOM3, DTC_QTDUNI, DTC_QTDVOL, "
	cCampos += "DTC_VALDPC, DTC_VALOR , DTC_NFEID , DTC_CTEANT, R_E_C_N_O_ DTC_RECNO  "
	cCampos += ", DTC_RECISS"
	cCampos += ", DTC_PESLIQ"
	cCampos += ", DTC_MOEDA"
	cCampos += ", DTC_MOENFC"
	cCampos += ", DTC_EXCTDA"
	If lAgdEntr
		cCampos += ", DTC_DATAGD, DTC_NUMAGD, DTC_ITEAGD  "
	EndIf
	cCampos += ", DTC_CODNEG"

	If lExped
		cCampos += ", DTC_CLIEXP, DTC_LOJEXP "
	EndIf
	If lRecebedor
		cCampos += ", DTC_CLIREC, DTC_LOJREC "
	EndIf

	//-- Frete Informado...
	cCampos += " , "
	cCampos += " DTC_VLRINF "

	cQuery := "SELECT " + cCampos
	cQuery += " FROM "  + RetSqlName("DTC") + " DTC "
	cQuery += " WHERE DTC_FILIAL = '" + xFilial("DTC") + "'"
	cQuery += "   AND DTC_FILORI = '" + cFilAnt + "'"
	cQuery += "   AND DTC_LOTNFC = '" + cLotNfc + "'"
	cQuery += "   AND DTC_DOC    = ' '" //-- Desconsidera documentos ja calculados
	cQuery += "   AND DTC_SERVIC = ' '"
	cQuery += "   AND D_E_L_E_T_ = ' '"
	If lTm200Fil .And. ValType(cRet) == "C" .And. !Empty(cRet)
		cQuery += cRet
	EndIf
	cQuery += " ORDER BY DTC_FILIAL,DTC_FILORI,DTC_CLIREM,DTC_LOJREM,DTC_CLIDES,DTC_LOJDES,DTC_CODNEG,DTC_SERVIC,DTC_CODPRO,DTC_NUMNFC,DTC_SERNFC,DTC_NUMSOL"

Else

	ProcRegua(DT5->(LastRec()))

	DT5->(DbSetOrder(7)) //-- DT5_FILIAL+DT5_NCONTR+DT5_CODNEG+DT5_SERVIC

	cSeek 	   := FWxFilial('DT5') + cFilAnt + cLotNfc //-- DT5_FILIAL+DT5_FILORI+DT5_NUMSOL
	aStruDTC  := DTC->(dbStruct())
	lQuery    := .T.
	cAliasDTC := GetNextAlias()
	cQuery    := Tmsa200Qry( cLotNfc , Iif( lTm200Fil .And. ValType(cRet) == "C" .And. !Empty(cRet), cRet , "" ))

EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDTC)

For nX := 1 To Len(aStruDTC)
	If aStruDTC[nX][2]<>"C" .And. aStruDTC[nX][1] $ cCampos
		TcSetField(cAliasDTC,aStruDTC[nX][1],aStruDTC[nX][2],aStruDTC[nX][3],aStruDTC[nX][4])
	EndIf
Next nX

While (cAliasDTC)->( !Eof() .And. (cAliasDTC)->DTC_FILIAL + (cAliasDTC)->DTC_FILORI + (cAliasDTC)->DTC_LOTNFC == cSeek  .And. !lEnd )

	IncProc()

	//-- Somente notas sem codigo de servico, pois o servico sera encontrado de acordo com a faixa de volume, peso e valor
	If	! Empty( (cAliasDTC)->DTC_SERVIC )
		(cAliasDTC)->( DbSkip() )
		Loop
	EndIf

	cCliAgr	:= ''
	cLojAgr	:= ''
	cCliCal	:= (cAliasDTC)->DTC_CLICAL
	cLojCal	:= (cAliasDTC)->DTC_LOJCAL

	//-- Se houver nr. de solicitacao de frete nao sera necessario verificar o cliagr
	If	Empty( (cAliasDTC)->DTC_NUMCOT )
		//-- Posiciona no contrato do cliente remetente, para obter o cliente agrupamento
		aContrt := TMSContrat( (cAliasDTC)->DTC_CLIREM, (cAliasDTC)->DTC_LOJREM,,,.F., (cAliasDTC)->DTC_TIPFRE,,,,,,,,,,,,,,,,(cAliasDTC)->DTC_CODNEG )
		If	! Empty( aContrt )
			cCliAgr	:= aContrt[ 1, 6 ]
			cLojAgr	:= aContrt[ 1, 7 ]
		EndIf
	EndIf

	If Empty( cCliAgr )
		cCliAgr	:= (cAliasDTC)->DTC_CLIREM
		cLojAgr	:= (cAliasDTC)->DTC_LOJREM
	EndIf

	aContrt := TMSContrat( cCliCal, cLojCal,,,.F.,(cAliasDTC)->DTC_TIPFRE,,,(cAliasDTC)->DTC_CLIREM,(cAliasDTC)->DTC_LOJREM,(cAliasDTC)->DTC_CLIDES,(cAliasDTC)->DTC_LOJDES,,(cAliasDTC)->DTC_CLIDEV,(cAliasDTC)->DTC_LOJDEV,(cAliasDTC)->DTC_TIPNFC,,,,,,(cAliasDTC)->DTC_CODNEG)
	If Empty( aContrt )
		Help( ' ', 1, 'TMSA20005',,STR0015 + cCliCal + ' / ' + cLojCal,5,11)			//-- Contrato nao encontrado (AAM). //'Cliente : '
		lRet := .F.
		Exit
	EndIf

	//-- Define o vetor aLote
	TmsA200Lot(aContrt,,,,cCliAgr,cLojAgr,,,,,,,'3',,,cAliasDTC)

	(cAliasDTC)->( DbSkip() )
EndDo

If	lRet .And. Len(aLote) > 0
	//-- Ordena o vetor aLote
	TmsA200Lot(,,,,,,,,,,,,'4')

	ProcRegua( Len( aLote ) )

	For nCntFor := 1 To Len( aLote )

		//-- Quando encontrar o primeiro cliente que agrupa por devedor,
		//-- re-ordena por devedor e nota fiscal.
		If !lDevedor .And. aLote[nCntFor, LTAGRNFC ] == "5"
			TmsA200Lot(,,,,,,,,,,,,'10')
			nCntFor  := Ascan( aLote, { |x| x[LTAGRNFC] == "5" } )
			lDevedor := .T.
		EndIf

		IncProc()

		If	lEnd
			Exit
		EndIf

		//-- Retorna string, utilizado no preenchimento da variavel cChave
		If !Empty(aLote[ nCntFor, LTFILDPC ]) .And. !Empty(aLote[ nCntFor, LTCTRDPC ])
			cChave	:= TmsA200Lot(,,,,,,,,,,,,'8',nCntFor)
		ElseIf aLote[nCntFor, LTAGRNFC ] == '5' //-- Por Devedor
			cChave	:= TmsA200Lot(,,,,,,,,,,,,'11',nCntFor)
		Else
			cChave	:= TmsA200Lot(,,,,,,,,,,,,'5',nCntFor)
		EndIf

		//--Adiciona a chave do documento anterior redespacho
	   If AScan(aCteAnt,{|x| x == aLote[ nCntFor, LTCTEANT ] })== 0
	    	nValDPC += aLote[ nCntFor, LTVALDPC ]
	    	Aadd(aCteAnt, aLote[ nCntFor, LTCTEANT])
   	   EndIf

		nQtdVol  += aLote[ nCntFor, LTQTDVOL ]
		nValor   += aLote[ nCntFor, LTVALOR  ]
		nPeso    += aLote[ nCntFor, LTPESO   ]
		nPesoM3  += aLote[ nCntFor, LTPESOM3 ]
		nMetro3  += aLote[ nCntFor, LTMETRO3 ]
		nSeguro  += aLote[ nCntFor, LTBASSEG ]
		nQtdUni  += aLote[ nCntFor, LTQTDUNI ]

		//-- Define o numero de sequencia de composicao (DT6_NUMCMP) que relaciona
		//-- os documentos que serao gerados e fazem parte do mesmo agrupamento de calculo
		If Empty(aNfCTRC)
			cNumCmp   := ""
			If !Empty(aLote[nCntFor, LTCLICAL])
				aContrCli := TMSContrat(aLote[nCntFor, LTCLICAL], aLote[nCntFor, LTLOJCAL],, aLote[nCntFor, LTSERVIC], .F., aLote[nCntFor, LTTIPFRE],,, aLote[nCntFor, LTCLIREM], aLote[nCntFor, LTLOJREM], aLote[nCntFor, LTCLIDES], aLote[nCntFor, LTLOJDES], aLote[nCntFor, LTTIPTRA], aLote[nCntFor, LTCLIDEV], aLote[nCntFor, LTLOJDEV], aLote[nCntFor, LTTIPNFC],,,,,, aLote[nCntFor, LTCODNEG])
			Else
				aContrCli := TMSContrat(aLote[nCntFor, LTCLIAGR], aLote[nCntFor, LTLOJAGR] ,, aLote[nCntFor, LTSERVIC], .F., aLote[nCntFor, LTTIPFRE],,, aLote[nCntFor, LTCLIREM], aLote[nCntFor, LTLOJREM], aLote[nCntFor, LTCLIDES], aLote[nCntFor, LTLOJDES], aLote[nCntFor, LTTIPTRA], aLote[nCntFor, LTCLIDEV], aLote[nCntFor, LTLOJDEV], aLote[nCntFor, LTTIPNFC],,,,,, aLote[nCntFor, LTCODNEG])
			EndIf
			If !Empty(aContrCli) .And. Len(aContrCli[1]) >= 52 .And. aContrCli[1,52] == '2' //-- Estorno Frete Agrupado
				cNumCmp   := GetSX8Num('DT6', 'DT6_NUMCMP', , 9)
				Iif(__lSX8, ConfirmSX8(),)
			EndIf
		Endif

		//-- Formato do vetor aNfCTRC
		//-- [01] = Numero da nota fiscal do cliente
		//-- [02] = Serie da nota fiscal do cliente
		//-- [03] = Cliente remetente
		//-- [04] = Loja do cliente remetente
		//-- [05] = Volume
		//-- [06] = Valor da mercadoria
		//-- [07] = Peso real
		//-- [08] = Peso cubado
		//-- [09] = Metro cubico
		//-- [10] = Base de seguro
		//-- [11] = Numero do contrato
		//-- [12] = Tipo de servico
		//-- [13] = Tipo de transporte
		//-- [14] = Codigo da regiao de origem
		//-- [15] = Codigo da regiao de destino
		//-- [16] = Codigo do servico
		//-- [17] = Cliente agrupamento
		//-- [18] = Loja do cliente agrupamento
		//-- [19] = Cliente destinatario
		//-- [20] = Loja do cliente destinatario
		//-- [21] = Cliente devedor
		//-- [22] = Loja do cliente devedor
		//-- [23] = Codigo do produto
		//-- [24] = Numero da cotacao
		//-- [25] = Qtde de notas fiscais por conhecimento
		//-- [26] = Peso maximo por conhecimento
		//-- [27] = Quantidade de unitizadores
		//-- [28] = Valor do frete despachante
		//-- [29] = Filial despachante
		//-- [30] = CTRC despachante
		//-- [31] = Considera ou nao as quebras por numero de notas fiscais por CTRC e peso maximo por CTRC
		//-- [32] = Numero da solicitacao de coleta
		//-- [33] = Tipo nfc
		//-- [34] = Peso Informado (0=Nao; 1=Sim)
		//-- [35] = Condicao de Pagamento
		//-- [36] = Sequencia de Endereco  Destinatario
		//-- [37] = Sequencia de Inscricao Devedor
		//-- [38] = Peso Liquido
		//-- [39] = Moeda
		//-- [40] = Desconsidera TDA (1-Coleta, 2-Entrega ou 3-Ambas)
		//-- [41] = Devedor      Paga TDA
		//-- [42] = Rementente   Paga TDA
		//-- [43] = Destinatario Paga TDA
		//-- [44] = Sequencia de Inscricao Destinatario
		//-- [45] = Regiao de Calculo
		//-- [46] = Taxa por CTRC ?
		//-- [47] = Indice do array aLote
		//-- [48] = Elemento para Definir quebra do Calculo ( aLote[ nCntFor, LTQBRCALC ] )
		//-- [49] = Elemento para quebra por data de Agendamento
		//-- [50] = Codigo da Negociacao
		//-- [51] = Elemento para Definir quebra do Calculo Por Divergencia De Classe De Risco ( aLote[ nCntFor, LTQBRDIVG] )
		//-- [52] = KM
		//-- [53] = Peso Coleta
		//-- [54] = Criterio Rateio Herda Valor (CRDVHV)
		//-- [55] = Estorno Frete Agrupado
		//-- [56] = N˙mero do Lote (cLotNfc)
		AAdd( aNfCTRC, {	aLote[ nCntFor, LTNUMNFC ], aLote[ nCntFor, LTSERNFC ], aLote[ nCntFor, LTCLIREM ],;
							aLote[ nCntFor, LTLOJREM ], aLote[ nCntFor, LTQTDVOL ], aLote[ nCntFor, LTVALOR  ],;
							aLote[ nCntFor, LTPESO   ], aLote[ nCntFor, LTPESOM3 ], aLote[ nCntFor, LTMETRO3 ],;
							aLote[ nCntFor, LTBASSEG ], aLote[ nCntFor, LTNCONTR ], aLote[ nCntFor, LTSERTMS ],;
							aLote[ nCntFor, LTTIPTRA ], aLote[ nCntFor, LTCDRORI ], aLote[ nCntFor, LTCDRDES ],;
							aLote[ nCntFor, LTSERVIC ], aLote[ nCntFor, LTCLIAGR ], aLote[ nCntFor, LTLOJAGR ],;
							aLote[ nCntFor, LTCLIDES ], aLote[ nCntFor, LTLOJDES ], aLote[ nCntFor, LTCLIDEV ],;
							aLote[ nCntFor, LTLOJDEV ], aLote[ nCntFor, LTCODPRO ], aLote[ nCntFor, LTNUMCOT ],;
							aLote[ nCntFor, LTNFCTRC ], aLote[ nCntFor, LTPESCTR ], aLote[ nCntFor, LTQTDUNI ],;
							aLote[ nCntFor, LTVALDPC ], aLote[ nCntFor, LTFILDPC ], aLote[ nCntFor, LTCTRDPC ],;
							aLote[ nCntFor, LTAGRNFC ], aLote[ nCntFor, LTNUMSOL ], aLote[ nCntFor, LTTIPNFC ],;
							If(Empty(aLote[nCntFor,LTPESO]),"0","1"),;
							aLote[ nCntFor, LTCPAGPV ], aLote[ nCntFor, LTSQEDES ], aLote[ nCntFor, LTSEQINS ],;
							aLote[ nCntFor, LTPESLIQ ], aLote[ nCntFor, LTMOEDA  ], aLote[ nCntFor, LTEXCTDA ],;
							aLote[ nCntFor, LTDEVTDA ], aLote[ nCntFor, LTREMTDA ], aLote[ nCntFor, LTDESTDA ],;
							aLote[ nCntFor, LTSEQINSD], aLote[ nCntFor, LTCDRCAL ], aLote[ nCntFor, LTTAXCTR ],;
							nCntFor, 					aLote[ nCntFor, LTQBRCALC], aLote[ nCntFor, LTDATAGD ],;
							aLote[ nCntFor, LTCODNEG ], aLote[ nCntFor, LTQBRDIVG], aLote[ nCntFor, LTKM ],;
							aLote[ nCntFor, LTPESCOL ], aLote[ nCntFor, LTCRDVHV ], cNumCmp, cLotNfc } )

		//-- Verifica se houve quebra
		If TMSA200Qbr( cChave, nCntFor, Len( aNfCTRC ), aLote[ nCntFor , LTNFCTRC ], nPeso, aLote[ nCntFor, LTPESCTR ], ,aNfCTRC , aLote[ nCntFor, LTAGRNFC ], !Empty(aLote[ nCntFor, LTNUMCOT ]), aLote[ nCntFor, LTMOEDA ] )

			nNumCTRC++

			//-- Analisa agrupamento de clientes
			TmsA200Agr(,aNfCTRC,@aVisErr,cLotNfc,,,,aLote[nCntFor,LTNCONTR],,.F.,.T.,nQtdVol,nValor,nPeso,nPesoM3,,nMetro3,nSeguro,nCntFor,,,,aLote[nCntFor,LTCODNEG], aFreteCol)

			aNfCTRC := {}
			cServic := ''
			nQtdVol := 0
			nValor  := 0
			nPeso   := 0
			nPesoM3 := 0
			nMetro3 := 0
			nSeguro := 0
			nQtdUni := 0
		EndIf

	Next
EndIf

If lQuery
	DbSelectArea(cAliasDTC)
	dbCloseArea()
EndIf

ResetArr(@aContrt     )
ResetArr(@aNfCTRC     )
ResetArr(@aStruDTC    )
ResetArr(@aFreteCol   )
ResetArr(@aContrCli   )

RestArea(aAreaDTC)
RestArea(aAreaDTP)
RestArea(aAreaAnt)

Return( lRet )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TmsA200Lot≥ Autor ≥ Alex Egydio           ≥ Data ≥28.11.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Define o vetor aLote                                       ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpA1 = Contrato                                           ≥±±
±±≥          ≥ ExpA2 = Todos os clientes p/agrupamento                    ≥±±
±±≥          ≥ ExpC1 = Cliente de calculo                                 ≥±±
±±≥          ≥ ExpC2 = Loja                                               ≥±±
±±≥          ≥ ExpC3 = Cliente p/ agrupamento                             ≥±±
±±≥          ≥ ExpC4 = Loja                                               ≥±±
±±≥          ≥ ExpC5 = Tipo do documento                                  ≥±±
±±≥          ≥ ExpC6 = Serie do documento                                 ≥±±
±±≥          ≥ ExpC7 = Tipo do servico                                    ≥±±
±±≥          ≥ ExpC8 = Tipo de transporte                                 ≥±±
±±≥          ≥ ExpC9 = Condicao de pagameto p/documento                   ≥±±
±±≥          ≥ ExpCA = Codigo do produto p/calculo de impostos            ≥±±
±±≥          ≥ ExpCB = Executado pelos processamentos:                    ≥±±
±±≥          ≥         1 = Ordena as notas fiscais do cliente 1o percurso ≥±±
±±≥          ≥         2 = Ordena as notas fiscais do cliente             ≥±±
±±≥          ≥         3 = Identifica o servico (Servico Automatico)      ≥±±
±±≥          ≥         4 = Apenas ordenar o vetor aLote                   ≥±±
±±≥          ≥         5 = Apenas p/preencher a var. cChave               ≥±±
±±≥          ≥ ExpN1 = Elemento do vetor aLote se ExpCB = 1               ≥±±
±±≥          ≥ ExpN2 = Nr.de notas fiscais por conhecimento               ≥±±
±±≥          ≥ ExpCC = Alias do arquivo DTC                               ≥±±
±±≥          ≥ ExpCD = Tipo nfc 0=Normal / 1=Devolucao Parcial            ≥±±
±±≥          ≥ ExpCI = Vetor Contendo As Divergencias Do Processamento(18)≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Retorno   ≥                                                            ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TmsA200Lot(aContrt,aNfCTRC,cCliCal,cLojCal,cCliAgr,cLojAgr,cDocTms,cSerie,cSerTms,cTipTra,cCPAGPV,cPrdImp,cAcao,nCntFor,nNfCTRC,cAliasDTC,cTipNfc,aVetDiv)

Local aCampos		:= {}
Local aValInf		:= {}
Local aTipVei		:= {}
Local aPesCub		:= {}
Local cRet			:= ''
Local lRet			:= .T.
Local cSeqIns		:= ''
Local cChaveDVU		:= ''
Local cQuery		:= ""
Local cAliasQry		:= ""
Local aAreaDVU		:= DVU->(GetArea())
Local aAreaDTE		:= DTE->(GetArea())
Local lAgdEntr		:= Iif(FindFunction("TMSA018Agd"),TMSA018Agd(),.F.)   //-- Agendamento de Entrega.
Local cQBRCALC		:= "" // //-- 90 Elemento para Definir quebra do Calculo (LTQBRCALC)
Local lExped		:= DTC->(ColumnPos("DTC_CLIEXP")) > 0
Local lRecebedor    := DTC->(ColumnPos("DTC_CLIREC")) > 0
Local lRetira       := DTC->(ColumnPos("DTC_RETIRA")) > 0
Local nPesoDUM		:= 0
Local lCmpDUX		:= DUX->(ColumnPos('DUX_VALCOL')) > 0
Local cQBRDIVG	  	:= "" // //-- 91 Elemento para Definir quebra do Calculo De Divergencias De Classes De Risco (LTQBRDIVG)
Local cQBRDIVG2	  	:= ""
Local cMV_TMSINCO  	:= SuperGetMv("MV_TMSINCO",.F.,"") // Controla Incompatibilidade de Produtos (ONU).
Local lQuebr       	:= .t.
Local lCamposRat   	:= DTP->(ColumnPos("DTP_RATEIO")) > 0
Local cAltVei       := "" //| 0=Nao Utiliza;1=Da Viagem;2=Da Nota;3=Viagem/Nota (DDA/DDC_ALTVEI) localizado no contrato do cliente.
DEFAULT cAliasDTC	:= "DTC"
DEFAULT cTipNfc		:= '0'
DEFAULT aVetDiv		:= {}

//-- Verifica se no contrato do cliente esta calculando o preco por produto.
If !Empty(aContrt) .And. aContrt[1,24] <> "1"
	lPrcProd := GetMV('MV_PRCPROD',,.T.)
Else
	If lPrcProd ==  Nil
		lPrcProd := GetMV('MV_PRCPROD',,.T.)
	EndIf
EndIf

lValCol   := DTP->DTP_TIPLOT == StrZero(5,Len(DTP->DTP_TIPLOT))

//-- Formato do vetor aLote
If cAcao == '1'				//-- Primeiro percurso

	//-- Formato do vetor aLote.
	aLote[ nCntFor, LT1oNFCT ] := nNfCTRC			//-- 45 Qtde de notas fiscais por conhecimento			P/ 1o percurso
	aLote[ nCntFor, LT1oPESC ] := aContrt[ 1, 20 ]	//-- 46 Peso maximo por conhecimento					P/ 1o percurso
	aLote[ nCntFor, LT1oCPAG ] := cCPAGPV 			//-- 47 Condicao de pagamento para o pedido de venda	p/ 1o percurso
	aLote[ nCntFor, LT1oNCON ] := aContrt[ 1,  1 ]	//-- 48 Contrato										p/ 1o percurso
	aLote[ nCntFor, LT1oTABF ] := aContrt[ 1,  3 ]	//-- 49 Tabela de frete									p/ 1o percurso
	aLote[ nCntFor, LT1oTIPT ] := aContrt[ 1,  4 ]	//-- 50 Tipo da tabela de frete							p/ 1o percurso
	aLote[ nCntFor, LT1oTABA ] := aContrt[ 1, 15 ]	//-- 51 Tabela alternativa								p/ 1o percurso
	aLote[ nCntFor, LT1oTIPA ] := aContrt[ 1, 16 ]	//-- 52 Tipo da tabela alternativa						p/ 1o percurso
	aLote[ nCntFor, LT1oAJUS ] := aContrt[ 1, 17 ]	//-- 53 Tabela de frete do cliente generico nao verifica ajuste no calculo	p/ 1o percurso
	aLote[ nCntFor, LT1oAGRN ] := aContrt[ 1, 22 ]	//-- 66 Considera ou nao as quebras por numero de notas fiscais por CTRC e peso maximo por CTRC	p/ 1o percurso

	//-- Existe negociacao do contrato
	If ! Empty(aContrt[1, 43]) //-- aContrt[1, 43] Vetor com o ServiÁo de NegociaÁ„o do Contrato
		aLote[ nCntFor, LTCODNEG ] := aContrt[1, 43, 1, 2]	//-- 96 CÛdigo da NegociaÁ„o
	Else
		aLote[ nCntFor, LTCODNEG ] := ""					//-- 96 CÛdigo da NegociaÁ„o
	EndIf

	//-- Cliente utiliza preco por produto
	If !lPrcProd
		If aContrt[1,24] == "1"
			lPrcProd := .T.
		EndIf
	EndIf
	//-- Nao adicionar no vetor aLote
	lRet := .F.

ElseIf cAcao == '2'			//-- Segundo Percurso ou Documento normal

	AAdd( aCampos, (cAliasDTC)->DTC_CLIREM	)	//-- 01 Cliente remetente
	AAdd( aCampos, (cAliasDTC)->DTC_LOJREM	)	//-- 02 Loja remetente
	AAdd( aCampos, (cAliasDTC)->DTC_CLIDES	)	//-- 03 Cliente destinatario
	AAdd( aCampos, (cAliasDTC)->DTC_LOJDES	)	//-- 04 Loja destinatario
	AAdd( aCampos, (cAliasDTC)->DTC_CLIDEV	)	//-- 05 Cliente devedor
	AAdd( aCampos, (cAliasDTC)->DTC_LOJDEV	)	//-- 06 Loja devedor
	AAdd( aCampos, cCliCal					)	//-- 07 Cliente para calculo
	AAdd( aCampos, cLojCal					)	//-- 08 Loja cliente para calculo
	AAdd( aCampos, cCliAgr					)	//-- 09 Cliente p/agrupamento
	AAdd( aCampos, cLojAgr					)	//-- 10 Loja cliente p/agrupamento
	AAdd( aCampos, (cAliasDTC)->DTC_NUMCOT	)	//-- 11 Solicitacao de frete
	AAdd( aCampos, (cAliasDTC)->DTC_CODPRO	)	//-- 12 Produto
	AAdd( aCampos, RetFldProd(SB1->B1_COD,"B1_LOCPAD"))	//-- 13 Armazem padrao
	AAdd( aCampos, SB1->B1_UM				)	//-- 14 Unidade de medida
	AAdd( aCampos, SB1->B1_TIPO				)	//-- 15 Tipo
	AAdd( aCampos, SB1->B1_SEGUM			)	//-- 16 2a. unidade de medida
	AAdd( aCampos, SB1->B1_DESC				)	//-- 17 Descricao do produto
	AAdd( aCampos, (cAliasDTC)->DTC_NUMNFC	)	//-- 18 Nota fiscal do cliente
	AAdd( aCampos, (cAliasDTC)->DTC_SERNFC	)	//-- 19 Serie da nota fiscal do cliente
	AAdd( aCampos, (cAliasDTC)->DTC_QTDVOL	)	//-- 20 Volume
	AAdd( aCampos, (cAliasDTC)->DTC_VALOR	) 	//-- 21 Valor
	AAdd( aCampos, (cAliasDTC)->DTC_PESO	)	//-- 22 Peso
	AAdd( aCampos, (cAliasDTC)->DTC_PESOM3	)	//-- 23 Peso cubado
	AAdd( aCampos, (cAliasDTC)->DTC_BASSEG	)	//-- 24 Base de seguro
	AAdd( aCampos, (cAliasDTC)->DTC_CDRORI	)	//-- 25 Codigo da regiao origem
	AAdd( aCampos, (cAliasDTC)->DTC_CDRDES	)	//-- 26 Codigo da regiao destino
	AAdd( aCampos, (cAliasDTC)->DTC_CDRCAL	)	//-- 27 Codigo da regiao de calculo
	AAdd( aCampos, (cAliasDTC)->DTC_TIPFRE	)	//-- 28 Tipo do frete
	AAdd( aCampos, (cAliasDTC)->DTC_SERVIC	)	//-- 29 Servico
	AAdd( aCampos, cDocTms					)	//-- 30 Tipo de documento de transporte
	AAdd( aCampos, cSerie					)	//-- 31 Serie do documento
	AAdd( aCampos, cSerTms					)	//-- 32 Tipo do servico
	AAdd( aCampos, cTipTra					)	//-- 33 Tipo de transporte
	AAdd( aCampos, nNfCTRC					)	//-- 34 Qtde de notas fiscais por conhecimento
	AAdd( aCampos, aContrt[ 1, 20 ]			)	//-- 35 Peso maximo por conhecimento
	AAdd( aCampos, cCPAGPV					)	//-- 36 Condicao de pagamento para o pedido de venda
	AAdd( aCampos, aContrt[ 1,  1 ]			)	//-- 37 Contrato
	AAdd( aCampos, aContrt[ 1,  3 ]			)	//-- 38 Tabela de frete
	AAdd( aCampos, aContrt[ 1,  4 ]			)	//-- 39 Tipo da tabela de frete
	AAdd( aCampos, aContrt[ 1, 15 ]			)	//-- 40 Tabela alternativa
	AAdd( aCampos, aContrt[ 1, 16 ]			)	//-- 41 Tipo da tabela alternativa
	AAdd( aCampos, aContrt[ 1, 18 ]==StrZero(1,Len(DUO->DUO_AJUOBR)))	//-- 42 Verifica se o Ajuste e' Obrigatorio
	AAdd( aCampos, cPrdImp					)	//-- 43 Produto para calculo de impostos de transporte
	AAdd( aCampos, (cAliasDTC)->DTC_CDRPER	)	//-- 44 Codigo da regiao 								p/ 1o percurso
	AAdd( aCampos, 0						)	//-- 45 Qtde de notas fiscais por conhecimento			P/ 1o percurso
	AAdd( aCampos, 0						)	//-- 46 Peso maximo por conhecimento					P/ 1o percurso
	AAdd( aCampos, ''						)	//-- 47 Condicao de pagamento para o pedido de venda	p/ 1o percurso
	AAdd( aCampos, ''						)	//-- 48 Contrato										p/ 1o percurso
	AAdd( aCampos, ''						)	//-- 49 Tabela de frete									p/ 1o percurso
	AAdd( aCampos, ''						)	//-- 50 Tipo da tabela de frete							p/ 1o percurso
	AAdd( aCampos, ''						)	//-- 51 Tabela alternativa								p/ 1o percurso
	AAdd( aCampos, ''						)	//-- 52 Tipo da tabela alternativa						p/ 1o percurso
	AAdd( aCampos, ''						)	//-- 53 Tabela de frete do cliente generico nao verifica ajuste no calculo	p/ 1o percurso
	AAdd( aCampos, (cAliasDTC)->DTC_DEVFRE	)	//-- 54 Devedor do frete
	AAdd( aCampos, (cAliasDTC)->DTC_METRO3	)	//-- 55 Metro cubico
	AAdd( aCampos, (cAliasDTC)->DTC_QTDUNI	)	//-- 56 Quantidade de unitizadores
	AAdd( aCampos, (cAliasDTC)->DTC_VALDPC	)	//-- 57 Valor do frete do despachante
	AAdd( aCampos, (cAliasDTC)->DTC_CLICON	)	//-- 58 Cliente consignatario
	AAdd( aCampos, (cAliasDTC)->DTC_LOJCON	)	//-- 59 Loja consignatario
	AAdd( aCampos, (cAliasDTC)->DTC_CLIDPC	)	//-- 60 Cliente despachante
	AAdd( aCampos, (cAliasDTC)->DTC_LOJDPC	)	//-- 61 Loja despachante
	AAdd( aCampos, (cAliasDTC)->DTC_FILDPC	)	//-- 62 Filial de Alianca (2o. Percurso)
	AAdd( aCampos, (cAliasDTC)->DTC_CTRDPC	)	//-- 63 CTRC Despachante
	AAdd( aCampos, aContrt[ 1, 17 ]			)	//-- 64 Tabela de frete do cliente generico nao verifica ajuste no calculo
	AAdd( aCampos, aContrt[ 1, 22 ]			)	//-- 65 Considera ou nao as quebras por numero de notas fiscais por CTRC e peso maximo por CTRC
	AAdd( aCampos, "")							//-- 66 p/ 1o percurso Considera ou nao as quebras por numero de notas fiscais por CTRC e peso maximo por CTRC

	TmsValInf(aValInf,'5',(cAliasDTC)->DTC_FILORI,,(cAliasDTC)->DTC_LOTNFC,(cAliasDTC)->DTC_CLIREM,(cAliasDTC)->DTC_LOJREM,(cAliasDTC)->DTC_CLIDES,(cAliasDTC)->DTC_LOJDES,(cAliasDTC)->DTC_SERVIC,(cAliasDTC)->DTC_NUMNFC,(cAliasDTC)->DTC_SERNFC,(cAliasDTC)->DTC_CODPRO,,,,,,(cAliasDTC)->DTC_CODNEG)
	AAdd(aCampos, AClone(aValInf)			)	//-- 67 Valor Informado x documento
	AAdd(aCampos, (cAliasDTC)->DTC_NUMSOL	)	//-- 68 Solicitacao de Coleta

	//-- Se o parametro MV_TMSCFEC (Carga Fechada) estiver habilitado,
	//-- verifica se foi gerado "Tipos de Veiculo" com origem "2" (Nota Fiscal).
	If TMSCFec()
		//-- Cliente utiliza preco por produto
		If !lPrcProd
			If aContrt[1,24] == "1"
				lPrcProd := .T.
			EndIf
		EndIf

		cChaveDVU := (cAliasDTC)->DTC_FILORI+(cAliasDTC)->DTC_NUMNFC+(cAliasDTC)->DTC_SERNFC+(cAliasDTC)->DTC_CLIREM+(cAliasDTC)->DTC_LOJREM
		If Ascan(aNFTipVei, { |x| IIF(lPrcProd, x[1]+x[2]+x[3]+x[4]+x[5]+x[6], x[1]+x[2]+x[3]+x[4]+x[5]) == cChaveDVU } ) == 0
			DVU->(DbSetOrder(1)) //DVU_FILIAL+DVU_FILORI+DVU_NUMNFC+DVU_SERNFC+DVU_CLIREM+DVU_LOJREM+DVU_ITEM
			cAliasQry := GetNextAlias()
			cQuery := "   SELECT DVU_TIPVEI, DVU_QTDVEI, DVU_FILIAL, DVU_FILORI, DVU_NUMNFC, DVU_SERNFC, DVU_CLIREM, DVU_LOJREM "
			cQuery += "     FROM " + RetSqlName("DVU")
			cQuery += "    WHERE DVU_FILIAL = '" + xFilial('DVU') + "' "
			cQuery += "      AND DVU_FILORI = '" + (cAliasDTC)->DTC_FILORI + "' "
			cQuery += "      AND DVU_NUMNFC = '" + (cAliasDTC)->DTC_NUMNFC + "' "
			cQuery += "      AND DVU_SERNFC = '" + (cAliasDTC)->DTC_SERNFC + "' "
			cQuery += "      AND DVU_CLIREM = '" + (cAliasDTC)->DTC_CLIREM + "' "
			cQuery += "      AND DVU_LOJREM = '" + (cAliasDTC)->DTC_LOJREM + "' "
			cQuery += "      AND DVU_LOTNFC = '" + (cAliasDTC)->DTC_LOTNFC + "' "
			cQuery += "      AND D_E_L_E_T_ = ' ' "
			cQuery += " ORDER BY " + SqlOrder(DVU->(IndexKey()))
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
			If (cAliasQry)->(!Eof())
				//-- Guarda nota fiscal do tipo de veiculo para ser calculado apenas uma vez.
				aAdd(aNFTipVei, { (cAliasDTC)->DTC_FILORI, (cAliasDTC)->DTC_NUMNFC, (cAliasDTC)->DTC_SERNFC, (cAliasDTC)->DTC_CLIREM, (cAliasDTC)->DTC_LOJREM, "" } )
				While (cAliasQry)->(!Eof())
					AAdd(aTipVei, {(cAliasQry)->DVU_TIPVEI,(cAliasQry)->DVU_QTDVEI})
					(cAliasQry)->(DbSkip())
				EndDo
			ElseIf lValCol //-- Carrega Vetor aTipVei Para ValorizaÁ„o Da Coleta
				//-- Posiciona Na Tipo VeÌculo Coleta / CotaÁ„o
				DbSelectArea("DVT")
				DbSetOrder(1)	//-- DVT_FILIAL+DVT_FILORI+DVT_NUMSOL+DVT_NUMCOT+DVT_ORIGEM+DVT_ITEM
				If MsSeek( FWxFilial("DVT") + (cAliasDTC)->DTC_FILORI + (cAliasDTC)->DTC_NUMNFC + (cAliasDTC)->DTC_NUMCOT + "1" + (cAliasDTC)->DUM_ITEM , .F. )

					aAdd(aNFTipVei, { (cAliasDTC)->DTC_FILORI, (cAliasDTC)->DTC_NUMNFC, (cAliasDTC)->DTC_SERNFC, (cAliasDTC)->DTC_CLIREM, (cAliasDTC)->DTC_LOJREM, "" } )
					aAdd(aTipVei, { DVT->DVT_TIPVEI, DVT->DVT_QTDVEI })
				EndIf
			EndIf

			//| verifica se considera veiculo da viagem ou da nota fiscal ou ambos
			//| 0=Nao Utiliza;1=Da Viagem;2=Da Nota;3=Viagem/Nota  
			cAltVei := TmsSobServ("ALTVEI",.T.,.T.,aContrt[ 1,  1 ],(cAliasDTC)->DTC_CODNEG,(cAliasDTC)->DTC_SERVIC,/*cNaoUtil*/,/*nAdiDoc*/,.F.)

			// Painel de Agendamento - Quando for nota balc„o, o c·lculo È executado durante a geraÁ„o da viagem (e antes de sua gravaÁ„o) e n„o h· obrigatoriedade de informar
			// o tipo de veÌculo na nota fiscal, desta forma È usado o da viagem.
			If Len(aTipVei) == 0 .And. IsInCallStack("TMSAF76") .And. (cAltVei $ "1|3")
				dbSelectArea("DTP")
				dbSetOrder(1)
				If dbSeek(xFilial("DTP") + (cAliasDTC)->DTC_LOTNFC)
					cViagem := DTP->DTP_VIAGEM
					If Empty(cViagem)
						cViagem := M->DTQ_VIAGEM
					EndIf

					If !Empty(cViagem)
						DTR->(dbSetOrder(1))
						If DTR->(MsSeek(xFilial('DTR') + DTP->DTP_FILORI + cViagem))
							While !DTR->(Eof()) .And. ;
								   DTR->DTR_FILIAL == xFilial('DTR')  .And. ;
								   DTR->DTR_FILORI == DTP->DTP_FILORI .And. ;
								   DTR->DTR_VIAGEM == cViagem

								// Verifica se h· ou n„o composiÁ„o
								If Empty(DTR->DTR_CODCPO)
									DA3->(dbSetOrder(1))
									If DA3->(MsSeek(xFilial("DA3") + DTR->DTR_CODVEI))
										aAdd(aTipVei, { DA3->DA3_TIPVEI, 1 })
									EndIf
								Else
									aAdd(aTipVei, { DTR->DTR_CODCPO, 1 })
								EndIf

								DTR->(dbSkip())
							EndDo

							If Len(aTipVei) > 0
								aAdd(aNFTipVei, { (cAliasDTC)->DTC_FILORI, (cAliasDTC)->DTC_NUMNFC, (cAliasDTC)->DTC_SERNFC, (cAliasDTC)->DTC_CLIREM, (cAliasDTC)->DTC_LOJREM, "" } )
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf

			(cAliasQry)->(DbCloseArea())
			RestArea(aAreaDVU)
		EndIf
	EndIf

	DTE->(DbSetOrder(1)) //DTE_FILIAL+DTE_FILORI+DTE_NUMNFC+DTE_SERNFC+DTE_CLIREM+DTE_LOJREM+DTE_CODPRO
	cAliasQry := GetNextAlias()
	cQuery := "   SELECT DTE_FILORI, DTE_NUMNFC, DTE_SERNFC, DTE_CLIREM, DTE_LOJREM, DTE_CODPRO, DTE_ALTURA, DTE_LARGUR, DTE_COMPRI "
	cQuery += "     FROM " + RetSqlName("DTE")
	cQuery += "    WHERE DTE_FILIAL = '" + xFilial('DTE') + "' "
	cQuery += "      AND DTE_FILORI = '" + (cAliasDTC)->DTC_FILORI + "' "
	cQuery += "      AND DTE_NUMNFC = '" + (cAliasDTC)->DTC_NUMNFC + "' "
	cQuery += "      AND DTE_SERNFC = '" + (cAliasDTC)->DTC_SERNFC + "' "
	cQuery += "      AND DTE_CLIREM = '" + (cAliasDTC)->DTC_CLIREM + "' "
	cQuery += "      AND DTE_LOJREM = '" + (cAliasDTC)->DTC_LOJREM + "' "
	cQuery += "      AND DTE_CODPRO = '" + (cAliasDTC)->DTC_CODPRO + "' "
	cQuery += "      AND D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY " + SqlOrder(DTE->(IndexKey()))
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
	While (cAliasQry)->(!Eof())
		AAdd(aPesCub,{	(cAliasQry)->DTE_FILORI, (cAliasQry)->DTE_NUMNFC, (cAliasQry)->DTE_SERNFC, (cAliasQry)->DTE_CLIREM, (cAliasQry)->DTE_LOJREM,;
						(cAliasQry)->DTE_CODPRO, (cAliasQry)->DTE_ALTURA, (cAliasQry)->DTE_LARGUR, (cAliasQry)->DTE_COMPRI } )
		(cAliasQry)->(DbSkip())
	EndDo
	(cAliasQry)->(DbCloseArea())
	RestArea(aAreaDTE)

	AAdd( aCampos, AClone(aTipVei)			)	//-- 69 Tipo de Veiculo
	AAdd( aCampos, cTipNfc					)	//-- 70 Tipo NFC
	AAdd( aCampos, (cAliasDTC)->DTC_KM		)	//-- 71 Quilometragem
	AAdd( aCampos, (cAliasDTC)->DTC_FILCFS )	//-- 72 Filial de Origem da Sol. Coleta / Cotacao
	AAdd( aCampos, (cAliasDTC)->DTC_SQEDES )	//-- 73 Sequencia de Endereco Destinatario
	AAdd( aCampos, AClone(aPesCub) 			)	//-- 74 Altura/Largura/Comprimento informados na Nota

	If (cAliasDTC)->DTC_DEVFRE == "1"
		cSeqIns := (cAliasDTC)->DTC_SQIREM
	ElseIf (cAliasDTC)->DTC_DEVFRE == "2"
		cSeqIns := (cAliasDTC)->DTC_SQIDES
	ElseIf (cAliasDTC)->DTC_DEVFRE == "3"
		cSeqIns := (cAliasDTC)->DTC_SQICON
	ElseIf (cAliasDTC)->DTC_DEVFRE == "4"
		cSeqIns := (cAliasDTC)->DTC_SQIDPC
	EndIf
	AAdd( aCampos, cSeqIns )										//-- 75 Sequencia da Inscricao estadual do cliente
	AAdd( aCampos, (cAliasDTC)->DTC_PESLIQ)							//-- 76 Peso Liquido
	AAdd( aCampos, (cAliasDTC)->DTC_MOEDA)							//-- 77 Moeda
	AAdd( aCampos, (cAliasDTC)->DTC_MOENFC)							//-- 78 Moeda Doc.Cliente
	AAdd( aCampos, (cAliasDTC)->DTC_EXCTDA)							//-- 79 Descosidera TDA
	AAdd( aCampos, aContrt[ 1, 28 ] )								//-- 80 Devedor Paga TDA

	//-- 81 Rementente TEM TDA
	If TMSA200Cli( (cAliasDTC)->DTC_CLIREM, (cAliasDTC)->DTC_LOJREM )   //posiciona na tabela SA1
		AAdd( aCampos, SA1->A1_TDA )	//-- 81 Rementente TEM TDA
	Else
		AAdd( aCampos, ""  )			//-- 81 Rementente TEM TDA
	EndIf

	//-- 82 Destinatario TEM TDA
	//-- *** Observacao: Quando o campo DTC_CLIREC e DTC_LOJREC assim como seus correspondentes na tabela DT6 estiverem padronizados,
	//--     o trecho do cÛdigo referente ao DTC_SQEDES(Sequencia Endereco do destinat·rio) dever· ser removido, pois assume-se que
	//--     o 'recebedor' substitui o uso desse campo.
	If !Empty((cAliasDTC)->DTC_SQEDES)
		DUL->(dbSetOrder(2))
		If DUL->(MsSeek(xFilial("DUL") + (cAliasDTC)->DTC_CLIDES + (cAliasDTC)->DTC_LOJDES + (cAliasDTC)->DTC_SQEDES))
			AAdd( aCampos, DUL->DUL_TDA )	//-- 82 Destinatario TEM TDA - Sequencia
		Else
			AAdd( aCampos, ""  )  //-- 82 Destinatario TEM TDA - Sequencia
		EndIf
	//-- [ **  Esse trecho abaixo nao deve ser removido somente o acima quando o recebedor ficar padronizado na liberaÁ„o do release **]
	Else
		If TMSA200Cli( (cAliasDTC)->DTC_CLIDES, (cAliasDTC)->DTC_LOJDES ) //posiciona na tabela SA1
			AAdd( aCampos, SA1->A1_TDA )  //-- 82 Destinatario TEM TDA
		Else
			AAdd( aCampos, ""  )  //-- 82 Destinatario TEM TDA
		EndIf
	EndIf
	//--Recebedor tem TDA - atualiza a posiÁ„o 82 substituindo o flag de TDA do destinatario pelo do recebedor.
	If lRecebedor
		If !Empty((cAliasDTC)->DTC_CLIREC)
			//-- Se regi„o do Recebedor for de difÌcil acesso atualiza parametro TDA do destinat·rio
			If TMSA200Cli( (cAliasDTC)->DTC_CLIREC, (cAliasDTC)->DTC_LOJREC )   //posiciona na tabela SA1
				aCampos[82] := SA1->A1_TDA //-- 82 Destinatario TEM TDA
			Else
				aCampos[82] := ""          //-- 82 Destinatario TEM TDA
			EndIf
		EndIf
	EndIf

	DTP->(dbSetOrder(2)) //DTP_FILIAL+DTP_FILORI+DTP_LOTNFC
	DTP->(MsSeek(xFilial("DTP")+(cAliasDTC)->DTC_FILORI+(cAliasDTC)->DTC_LOTNFC))

	AAdd( aCampos, (cAliasDTC)->DTC_SQIDES	)						//-- 83 Sequencia de Inscricao Estadual Destinatario
	AAdd( aCampos, DTP->DTP_TIPLOT			)						//-- 84 Tipo do Lote (Normal / Eletronico / CTe Unico)
	AAdd( aCampos, (cAliasDTC)->DTC_RECISS)							//-- 85 Recolhe ISS
	AAdd( aCampos, aContrt[ 1, 23 ]			)						//-- 86 Taxa por CTRC ?
	//-- Agendamento de entrega
	Aadd( aCampos, IIF(lAgdEntr,(cAliasDTC)->DTC_NUMAGD,"") )		//-- 87 CÛdigo do Agendamento
	Aadd( aCampos, IIF(lAgdEntr,(cAliasDTC)->DTC_ITEAGD,"") )		//-- 88 Item do Agendamento
	Aadd( aCampos, (cAliasDTC)->DTC_NFEID )							//-- 89 Chave da DANFE

	//-- Cliente utiliza preco por produto
	If !lPrcProd
		If aContrt[1,24] == "1"
			lPrcProd := .T.
		EndIf
	EndIf
	nKmP := (cAliasDTC)->DTC_KM		//-- Leva a quilometragem para casos de Pauta Frete

	//-- Reserva a posicao de numero 90 para definir quebra via PE abaixo
	AAdd( aCampos, ""	) //-- 90 Elemento para Definir quebra do Calculo (LTQBRCALC)

	// Tratamento Para Inclusao Da Quebra Por Classe De Risco / Grupo Embalagens
	cQBRDIVG := ""

	//-- MV_TMSINCO -> Define Rotinas Que Tratam Incompatibilidade De Produtos.
	//-- A = Todas;
	//-- B = Calculo Do Frete;
	//-- C = Viagem;
	//-- D = SolicitaÁ„o De Coleta;
	//-- E = Agendamento;
	//-- F = CotaÁ„o;
	//-- Em Branco = Nao Controla.

	If "A" $ cMV_TMSINCO .Or. "B" $ cMV_TMSINCO

		//-- Verifica Qual Modalidade de AÁ„o Do Calculo De Divergencia Ser· Utilizado
		If !Empty((cAliasDTC)->DTC_NUMCOT) .Or. (lCamposRat .And. DTP->DTP_RATEIO == StrZero(1, Len(DTP->DTP_RATEIO)))
			lQuebr := .f. //-- Se Houver CotaÁ„o/Rateio Bloqueia Independente Do Perfil Do Cliente
		Else

			//-- Perfil Do Cliente - '1' = Bloqueia Lote NFs, '2' = Separa Documentos
			If FindFunction("TmsModInco")
				lQuebr := Iif( TmsModInco( "INC" , (cAliasDTC)->DTC_CLIDEV , (cAliasDTC)->DTC_LOJDEV ) == '1' ,.f. ,.t.)
			Else
				If DUO->(ColumnPos("DUO_INCOMP")) > 0
					lQuebr := Iif(DUO->DUO_INCOMP == '1',.f.,.t.) //-- Se campo Existir Define Pelo Conteudo Do Campo
				Else
					lQuebr := .T. //-- Se N„o Existir o Campo, Separa Documentos (Padr„o)
				EndIf
			EndIf

		EndIf

		If lQuebr

			// ForÁa Posicionamento No DTC Para UtilizaÁ„o Do TMSA200 Para Divergencia de Produtos
			DbSelectArea("DTC")
			DbSetOrder(2)
			MsSeek(xFilial("DTC") + (cAliasDTC)->DTC_NUMNFC + (cAliasDTC)->DTC_SERNFC + (cAliasDTC)->DTC_CLIREM + (cAliasDTC)->DTC_LOJREM + (cAliasDTC)->DTC_CODPRO )

			cQBRDIVG := TmsClrQb(@aVetDiv,.f.,(cAliasDTC)->DTC_CODPRO, (cAliasDTC)->DTC_NUMNFC, (cAliasDTC)->DTC_SERNFC, (cAliasDTC)->DTC_DOC,(cAliasDTC)->DTC_SERIE,DTC->(Recno()),0)

			//-- Permite Tratamento Usuario No Conteudo Da Quebra Por Classe De Risco
			If lTM200CLR

				cQBRDIVG2 := ExecBlock("TM200CLR",.F.,.F.,{ (cAliasDTC)->DTC_CODPRO, (cAliasDTC)->DTC_NUMNFC, (cAliasDTC)->DTC_SERNFC, (cAliasDTC)->DTC_DOC,(cAliasDTC)->DTC_SERIE,@aVetDiv,cQBRDIVG })

				If ValType(cQBRDIVG2) == "C"
					cQBRDIVG := cQBRDIVG2
				EndIf
			EndIf
		EndIf
	EndIf

	AAdd( aCampos, cQBRDIVG	) //-- 91 Elemento para Definir quebra do Calculo Por Divergencia De Classe De Risco (LTQBRDIVG)
	AAdd( aCampos, Iif( lAgdEntr,DTOS((cAliasDTC)->DTC_DATAGD),"")) //-- 92 Data de Agendamento de Entrega
	AAdd( aCampos,(cAliasDTC)->DTC_CTEANT) //--93 Chave do documento interior
	If lExped
		AAdd( aCampos,(cAliasDTC)->DTC_CLIEXP) //--94 Codigo do Cliente Expedidor
		AAdd( aCampos,(cAliasDTC)->DTC_LOJEXP) //--95 Loja do Cliente Expedidor
		//-- Se regi„o do Expedidor for de difÌcil acesso atualiza parametro TDA do remetente.
		If TMSA200Cli( (cAliasDTC)->DTC_CLIEXP, (cAliasDTC)->DTC_LOJEXP )
			aCampos[81] := SA1->A1_TDA //--TDA do Cliente Remetente 1=SIM;2=NAO
		EndIf
	Else
		AAdd( aCampos,"") //--94 Codigo do Cliente Expedidor
		AAdd( aCampos,"") //--95 Loja do Cliente Expedidor
	EndIf
	Aadd( aCampos,(cAliasDTC)->DTC_CODNEG)	//-- 96 CÛdigo da NegociaÁ„o

	If lCamposRat .And. DTP->DTP_RATEIO == '1' .And. lCmpDUX
		If !Empty((cAliasDTC)->DTC_NUMSOL)
			nPesoDUM:= TMSPesoRat((cAliasDTC)->DTC_FILCFS,(cAliasDTC)->DTC_NUMSOL,(cAliasDTC)->DTC_CODPRO)
		EndIf
	EndIf
	Aadd( aCampos, nPesoDUM)								//-- 97 Peso Previsto
	Aadd( aCampos, Iif(lCmpDUX,aContrt[ 1, 48 ],''))	//-- 98 Valoriza Coleta Nao Realizada
	AAdd( aCampos, Iif(Len(aContrt[1])>=51,aContrt[ 1, 51 ],'0'))	//-- 99 Criterio Rateio Herda Valor (CRDVHV)

	If lRecebedor
		AAdd( aCampos,(cAliasDTC)->DTC_CLIREC) //--100 Codigo do Cliente Recebedor
		AAdd( aCampos,(cAliasDTC)->DTC_LOJREC) //--101 Loja do Cliente Recebedor
	Else
		AAdd( aCampos,"") //--100 Codigo do Cliente Recebedor
		AAdd( aCampos,"") //--101 Loja do Cliente Recebedor
	EndIf

    //-- Indica se o Frete È Informado
	//-- LTFREINF
	Aadd( aCampos,((cAliasDTC)->DTC_VLRINF > 0)) //-- 102 Retorna .T. se Frete Informado pela Entrada de NF Cliente(TMSA050)
	cQBRCALC := ""

	If lRetira
		AAdd( aCampos,(cAliasDTC)->DTC_RETIRA) //--103 Indicador se o Recebedor retira no Aeroporto, Filial, Porto ou EstaÁ„o de Destino? 0=SIM;1=NAO
	Else
		AAdd( aCampos,"")
	EndIf

	If lTM200LOT
		cQBRCALC := ExecBlock("TM200LOT", .F., .F., { aClone(aCampos) } )

		If Valtype(cQBRCALC) != "C"
			cQBRCALC := ""
		EndIf
	EndIf

	aCampos[90] := cQBRCALC	//-- Elemento para Definir quebra do Calculo (LTQBRCALC) - Posicao reservada acima

ElseIf cAcao == '3'			//-- Servico Automatico

	AAdd( aCampos, (cAliasDTC)->DTC_CLIREM	)	//-- 01 Cliente remetente
	AAdd( aCampos, (cAliasDTC)->DTC_LOJREM	)	//-- 02 Loja remetente
	AAdd( aCampos, (cAliasDTC)->DTC_CLIDES	)	//-- 03 Cliente destinatario
	AAdd( aCampos, (cAliasDTC)->DTC_LOJDES	)	//-- 04 Loja destinatario
	AAdd( aCampos, (cAliasDTC)->DTC_CLIDEV	)	//-- 05 Cliente devedor
	AAdd( aCampos, (cAliasDTC)->DTC_LOJDEV	)	//-- 06 Loja devedor
	AAdd( aCampos, ''						)	//-- 07 Cliente para calculo
	AAdd( aCampos, ''						)	//-- 08 Loja cliente para calculo
	AAdd( aCampos, cCliAgr					)	//-- 09 Cliente p/agrupamento
	AAdd( aCampos, cLojAgr					)	//-- 10 Loja cliente p/agrupamento
	AAdd( aCampos, (cAliasDTC)->DTC_NUMCOT	)	//-- 11 Solicitacao de frete
	AAdd( aCampos, (cAliasDTC)->DTC_CODPRO	)	//-- 12 Produto
	AAdd( aCampos, ''						)	//-- 13 Armazem padrao
	AAdd( aCampos, ''						)	//-- 14 Unidade de medida
	AAdd( aCampos, ''						)	//-- 15 Tipo
	AAdd( aCampos, ''						)	//-- 16 2a. unidade de medida
	AAdd( aCampos, ''						)	//-- 17 Descricao do produto
	AAdd( aCampos, (cAliasDTC)->DTC_NUMNFC	)	//-- 18 Nota fiscal do cliente
	AAdd( aCampos, (cAliasDTC)->DTC_SERNFC	)	//-- 19 Serie da nota fiscal do cliente
	AAdd( aCampos, (cAliasDTC)->DTC_QTDVOL	)	//-- 20 Volume
	AAdd( aCampos, (cAliasDTC)->DTC_VALOR	)	//-- 21 Valor
	AAdd( aCampos, (cAliasDTC)->DTC_PESO	)	//-- 22 Peso
	AAdd( aCampos, (cAliasDTC)->DTC_PESOM3	)	//-- 23 Peso cubado
	AAdd( aCampos, (cAliasDTC)->DTC_BASSEG	)	//-- 24 Base de seguro
	AAdd( aCampos, (cAliasDTC)->DTC_CDRORI	)	//-- 25 Codigo da regiao origem
	AAdd( aCampos, (cAliasDTC)->DTC_CDRDES	)	//-- 26 Codigo da regiao destino
	AAdd( aCampos, (cAliasDTC)->DTC_CDRCAL	)	//-- 27 Codigo da regiao de calculo
	AAdd( aCampos, (cAliasDTC)->DTC_TIPFRE	)	//-- 28 Tipo do frete
	AAdd( aCampos, ''						)	//-- 29 Servico
	AAdd( aCampos, ''						)	//-- 30 Tipo de documento de transporte
	AAdd( aCampos, ''						)	//-- 31 Serie do documento
	AAdd( aCampos, (cAliasDTC)->DTC_SERTMS	)	//-- 32 Tipo de servico
	AAdd( aCampos, (cAliasDTC)->DTC_TIPTRA	)	//-- 33 Tipo de transporte
	AAdd( aCampos, aContrt[ 1,  8 ]			)	//-- 34 Qtde de notas fiscais por conhecimento
	AAdd( aCampos, aContrt[ 1, 20 ]			)	//-- 35 Peso maximo por conhecimento
	AAdd( aCampos, ''						)	//-- 36 Condicao de pagamento para o pedido de venda
	AAdd( aCampos, aContrt[ 1,  1 ]			)	//-- 37 Contrato
	AAdd( aCampos, ''						)	//-- 38 Tabela de frete
	AAdd( aCampos, ''						)	//-- 39 Tipo da tabela de frete
	AAdd( aCampos, ''						)	//-- 40 Tabela alternativa
	AAdd( aCampos, ''						)	//-- 41 Tipo da tabela alternativa
	AAdd( aCampos, .F.						)	//-- 42 Verifica se o Ajuste e' Obrigatorio
	AAdd( aCampos, ''						)	//-- 43 Produto para calculo de impostos de transporte
	AAdd( aCampos, (cAliasDTC)->DTC_CDRPER	)	//-- 44 Codigo da regiao 								p/ 1o percurso
	AAdd( aCampos, 0						)	//-- 45 Qtde de notas fiscais por conhecimento			P/ 1o percurso
	AAdd( aCampos, 0						)	//-- 46 Peso maximo por conhecimento					P/ 1o percurso
	AAdd( aCampos, ''						)	//-- 47 Condicao de pagamento para o pedido de venda	p/ 1o percurso
	AAdd( aCampos, ''						)	//-- 48 Contrato										p/ 1o percurso
	AAdd( aCampos, ''						)	//-- 49 Tabela de frete									p/ 1o percurso
	AAdd( aCampos, ''						)	//-- 50 Tipo da tabela de frete							p/ 1o percurso
	AAdd( aCampos, ''						)	//-- 51 Tabela alternativa								p/ 1o percurso
	AAdd( aCampos, ''						)	//-- 52 Tipo da tabela alternativa						p/ 1o percurso
	AAdd( aCampos, ''						)	//-- 53 Tabela de frete do cliente generico nao verifica ajuste no calculo	p/ 1o percurso
	AAdd( aCampos, ''						)	//-- 54 Devedor do frete
	AAdd( aCampos, (cAliasDTC)->DTC_METRO3	)	//-- 55 Metro cubico
	AAdd( aCampos, (cAliasDTC)->DTC_QTDUNI	)	//-- 56 Quantidade de unitizadores
	AAdd( aCampos, (cAliasDTC)->DTC_VALDPC	)	//-- 57 Valor do frete do despachante
	AAdd( aCampos, ''						)	//-- 58 Cliente consignatario
	AAdd( aCampos, ''						)	//-- 59 Loja consignatario
	AAdd( aCampos, ''						)	//-- 60 Cliente despachante
	AAdd( aCampos, ''						)	//-- 61 Loja despachante
	AAdd( aCampos, (cAliasDTC)->DTC_FILDPC	)	//-- 62 Filial de Alianca (2o. Percurso)
	AAdd( aCampos, (cAliasDTC)->DTC_CTRDPC	)	//-- 63 CTRC Despachante
	AAdd( aCampos, aContrt[ 1, 17 ]			)	//-- 64 Tabela de frete do cliente generico nao verifica ajuste no calculo
	AAdd( aCampos, aContrt[ 1, 22 ]			)	//-- 65 Considera ou nao as quebras por numero de notas fiscais por CTRC e peso maximo por CTRC
	AAdd( aCampos, ''					 	)	//-- 66 p/ 1o percurso Considera ou nao as quebras por numero de notas fiscais por CTRC e peso maximo por CTRC
	AAdd( aCampos, AClone(aValInf)			)	//-- 67 Valor Informado x documento
	AAdd( aCampos, (cAliasDTC)->DTC_NUMSOL	)	//-- 68 Solicitacao de Coleta
	AAdd( aCampos, AClone(aTipVei)			)	//-- 69 Tipo de Veiculo
	AAdd( aCampos, cTipNfc					)	//-- 70 Tipo nfc
	AAdd( aCampos, (cAliasDTC)->DTC_KM		)	//-- 71 Quilometragem
	AAdd( aCampos, (cAliasDTC)->DTC_FILCFS )	//-- 72 Filial de Origem da Sol. Coleta / Cotacao
	AAdd( aCampos, (cAliasDTC)->DTC_SQEDES )	//-- 73 Sequencia de Endereco Destinatario
	AAdd( aCampos, AClone(aPesCub)			)	//-- 74 Altura/Largura/Comprimento informados na Nota

	If (cAliasDTC)->DTC_DEVFRE == "1"
		cSeqIns := (cAliasDTC)->DTC_SQIREM
	ElseIf (cAliasDTC)->DTC_DEVFRE == "2"
		cSeqIns := (cAliasDTC)->DTC_SQIDES
	ElseIf (cAliasDTC)->DTC_DEVFRE == "3"
		cSeqIns := (cAliasDTC)->DTC_SQICON
	ElseIf (cAliasDTC)->DTC_DEVFRE == "4"
		cSeqIns := (cAliasDTC)->DTC_SQIDPC
	EndIf
	AAdd( aCampos, cSeqIns )										//-- 75 Sequencia da Inscricao estadual do cliente
	AAdd( aCampos, (cAliasDTC)->DTC_PESLIQ)							//-- 76 Peso Liquido
	AAdd( aCampos, (cAliasDTC)->DTC_MOEDA)							//-- 77 Moeda
	AAdd( aCampos, (cAliasDTC)->DTC_MOENFC)							//-- 78 Moeda Doc.Cliente
	AAdd( aCampos, (cAliasDTC)->DTC_EXCTDA)							//-- 79 Descosidera TDA
	AAdd( aCampos, aContrt[ 1, 28 ] )								//-- 80 Devedor Paga TDA

	//-- 81 Rementente TEM TDA
	If TMSA200Cli( (cAliasDTC)->DTC_CLIREM, (cAliasDTC)->DTC_LOJREM )   //posiciona na tabela SA1
		AAdd( aCampos, SA1->A1_TDA )	//-- 81 Rementente TEM TDA
	Else
		AAdd( aCampos, ""  )			//-- 81 Rementente TEM TDA
	EndIf

	//-- 82 Destinatario TEM TDA
	If !Empty((cAliasDTC)->DTC_SQEDES)
		DUL->(dbSetOrder(2))
		If DUL->(MsSeek(xFilial("DUL") + (cAliasDTC)->DTC_CLIDES + (cAliasDTC)->DTC_LOJDES + (cAliasDTC)->DTC_SQEDES))
			AAdd( aCampos, DUL->DUL_TDA )	//-- 82 Destinatario TEM TDA - Sequencia
		Else
			AAdd( aCampos, ""  )  //-- 82 Destinatario TEM TDA - Sequencia
		EndIf
	Else
		If TMSA200Cli( (cAliasDTC)->DTC_CLIDES, (cAliasDTC)->DTC_LOJDES ) //posiciona na tabela SA1
			AAdd( aCampos, SA1->A1_TDA )  //-- 82 Rementente TEM TDA
		Else
			AAdd( aCampos, ""  )  //-- 82 Rementente TEM TDA
		EndIf
	EndIf

	DTP->(dbSetOrder(2)) //DTP_FILIAL+DTP_FILORI+DTP_LOTNFC
	DTP->(MsSeek(xFilial("DTP")+(cAliasDTC)->DTC_FILORI+(cAliasDTC)->DTC_LOTNFC))

	AAdd( aCampos, (cAliasDTC)->DTC_SQIDES	)						//-- 83 Sequencia de Inscricao Estadual Destinatario
	AAdd( aCampos, DTP->DTP_TIPLOT			)						//-- 84 Tipo do Lote (Normal / Eletronico)
	AAdd( aCampos, (cAliasDTC)->DTC_RECISS)							//-- 85 Recolhe ISS
	AAdd( aCampos, aContrt[ 1, 23 ]			)						//-- 86 Taxa por CTRC ?
	//-- Agendamento de entrega
	Aadd( aCampos, IIF(lAgdEntr,(cAliasDTC)->DTC_NUMAGD,"") )		//-- 87 CÛdigo do Agendamento
	Aadd( aCampos, IIF(lAgdEntr,(cAliasDTC)->DTC_ITEAGD,"") )		//-- 88 Item do Agendamento
	Aadd( aCampos, (cAliasDTC)->DTC_NFEID )							//-- 89 Chave da DANFE

	//-- Cliente utiliza preco por produto
	If !lPrcProd
		If aContrt[1,24] == "1"
			lPrcProd := .T.
		EndIf
	EndIf
	nKmP := (cAliasDTC)->DTC_KM		//-- Leva a quilometragem para casos de Pauta Frete

	//-- Reserva a posicao de numero 90 para definir quebra via PE abaixo
	AAdd( aCampos, ""	) //-- 90 Elemento para Definir quebra do Calculo (LTQBRCALC)

	// Tratamento Para Inclusao Da Quebra Por Classe De Risco / Grupo Embalagens
	cQBRDIVG := ""

	//-- MV_TMSINCO -> Define Rotinas Que Tratam Incompatibilidade De Produtos.
	//-- A = Todas;
	//-- B = Calculo Do Frete;
	//-- C = Viagem;
	//-- D = SolicitaÁ„o De Coleta;
	//-- E = Agendamento;
	//-- F = CotaÁ„o;
	//-- Em Branco = Nao Controla.

	If "A" $ cMV_TMSINCO .Or. "B" $ cMV_TMSINCO

		//-- Verifica Qual Modalidade de AÁ„o Do Calculo De Divergencia Ser· Utilizado
		If !Empty(DTC->DTC_NUMCOT) .Or. (lCamposRat .And. DTP->DTP_RATEIO == StrZero(1, Len(DTP->DTP_RATEIO)))
			lQuebr := .f. //-- Se Houver CotaÁ„o/Rateio Bloqueia Independente Do Perfil Do Cliente
		Else
			//-- Perfil Do Cliente - '1' = Bloqueia Lote NFs, '2' = Separa Documentos
			If FindFunction("TmsModInco")
				lQuebr := Iif( TmsModInco( "INC", (cAliasDTC)->DTC_CLIDEV , (cAliasDTC)->DTC_LOJDEV ) == '1' ,.f. ,.t.)
			Else
				If DUO->(ColumnPos("DUO_INCOMP")) > 0
					lQuebr := Iif(DUO->DUO_INCOMP == '1',.f.,.t.) //-- Se campo Existir Define Pelo Conteudo Do Campo
				Else
					lQuebr := .t. //-- Se N„o Existir o Campo, Separa Documentos (Padr„o)
				EndIf
			EndIf
		EndIf

		If lQuebr

			cQBRDIVG := TmsClrQb(@aVetDiv,.f.,(cAliasDTC)->DTC_CODPRO, (cAliasDTC)->DTC_NUMNFC, (cAliasDTC)->DTC_SERNFC, (cAliasDTC)->DTC_DOC,(cAliasDTC)->DTC_SERIE,0)

			//-- Permite Tratamento Usuario No Conteudo Da Quebra Por Classe De Risco
			If lTM200CLR

				cQBRDIVG2 := ExecBlock("TM200CLR",.F.,.F.,{ (cAliasDTC)->DTC_CODPRO, (cAliasDTC)->DTC_NUMNFC, (cAliasDTC)->DTC_SERNFC, (cAliasDTC)->DTC_DOC,(cAliasDTC)->DTC_SERIE,@aVetDiv,cQBRDIVG })

				If ValType(cQBRDIVG2) == "C"
					cQBRDIVG := cQBRDIVG2
				EndIf
			EndIf
		EndIf
	EndIf

	AAdd( aCampos, cQBRDIVG	) //-- 91 Elemento para Definir quebra do Calculo Por Divergencia De Classe De Risco (LTQBRDIVG)
	AAdd( aCampos, Iif( lAgdEntr,DTOS((cAliasDTC)->DTC_DATAGD),"") ) //-- 92 Data de Agendamento de Entrega
	AAdd( aCampos,(cAliasDTC)->DTC_CTEANT) //--93 Chave do documento interior
	If lExped
		AAdd( aCampos,(cAliasDTC)->DTC_CLIEXP) //--94 Codigo do Cliente Expedidor
		AAdd( aCampos,(cAliasDTC)->DTC_LOJEXP) //--95 Loja do Cliente Expedidor
	Else
		AAdd( aCampos,"") //--94 Codigo do Cliente Expedidor
		AAdd( aCampos,"") //--95 Loja do Cliente Expedidor
	EndIf
	Aadd( aCampos,(cAliasDTC)->DTC_CODNEG)	//-- 96 CÛdigo da NegociaÁ„o

	If lCamposRat .And. DTP->DTP_RATEIO == '1' .And. lCmpDUX
		If !Empty((cAliasDTC)->DTC_NUMSOL)
			nPesoDUM:= TMSPesoRat((cAliasDTC)->DTC_FILCFS,(cAliasDTC)->DTC_NUMSOL,(cAliasDTC)->DTC_CODPRO)
		EndIf
	EndIf
	Aadd( aCampos, nPesoDUM)				//-- 97 Peso Previsto
	Aadd( aCampos, Iif(lCmpDUX,aContrt[ 1, 48 ],''))	//-- 98 Valoriza Coleta Nao Realizada
	AAdd( aCampos, Iif(Len(aContrt[1])>=51,aContrt[ 1, 51 ],'0'))	//-- 99 Criterio Rateio Herda Valor (CRDVHV)

	cQBRCALC := ""

	//-- Inclus„o dos campos Recebedor e Loja no vetor aLote
	If lRecebedor
		Aadd( aCampos,(cAliasDTC)->DTC_CLIREC) //-- 100 - codigo do recebedor
		Aadd( aCampos,(cAliasDTC)->DTC_LOJREC) //-- 101 - loja   do recebedor
	Else
		Aadd( aCampos,"")
		Aadd( aCampos,"")
	EndIf

	If lTM200LOT
		cQBRCALC := ExecBlock("TM200LOT", .F., .F., { aClone(aCampos) } )

		If Valtype(cQBRCALC) != "C"
			cQBRCALC := ""
		EndIf
	EndIf

	aCampos[90] := cQBRCALC	//-- Elemento para Definir quebra do Calculo (LTQBRCALC) - Posicao reservada acima

ElseIf cAcao == '4'			//-- Ordena o vetor aLote
	//-- A T E N C A O   Alteracoes na chave abaixo tambem devem ser feitas na funcao TMSA200QB1
	//-- O n˙mero e sÈrie da nota fiscal devem ficar no final da ordenaÁ„o para que o sistema n„o duplique o valor do frete indevidamente
	//--						Se Preco por Produto, Nao retire o NUMNFC e SERNFC do asort pois a funcao TMSA200GRV necessita que as nfc's iguais estejam ordenadas
	If lPrcProd //-- Preco por Produto
		ASort( aLote,,,{|x,y| x[ LTQBRCALC ] + x[ LTDATAGD ] + x[ LTQBRDIVG] + x[ LTAGRNFC ] + x[ LTTIPNFC ] + x[ LTCODNEG ] + x[ LTSERVIC ] + x[ LTCLIAGR ] + x[ LTLOJAGR ] + x[ LTCLIDES ] + x[ LTLOJDES ] + x[ LTSQEDES ] + x[ LTCLIDEV ] + x[ LTLOJDEV ] + x[ LTCLIEXP ] + x[ LTLOJEXP ] + x[ LTCODPRO ] + x[ LTNUMCOT ] + x[ LTSEQINS ] + x[ LTSEQINSD ] + x[ LTCDRORI ] + x[ LTCDRCAL ] + x[ LTNUMNFC ] + x[ LTSERNFC ]  < y[ LTQBRCALC ] + y[ LTDATAGD ] + y[ LTQBRDIVG] + y[ LTAGRNFC ] + y[ LTTIPNFC ] + y[ LTCODNEG ] + y[ LTSERVIC ] + y[ LTCLIAGR ] + y[ LTLOJAGR ] + y[ LTCLIDES ] + y[ LTLOJDES ] + y[ LTSQEDES ] + y[ LTCLIDEV ] + y[ LTLOJDEV ] + y[ LTCLIEXP ] + y[ LTLOJEXP ] + y[ LTCODPRO ] + y[ LTNUMCOT ] + y[ LTSEQINS ] + y[ LTSEQINSD ] + y[ LTCDRORI ] + y[ LTCDRCAL ] + y[ LTNUMNFC ] + y[ LTSERNFC ]})
	Else
		ASort( aLote,,,{|x,y| x[ LTQBRCALC ] + x[ LTDATAGD ] + x[ LTQBRDIVG] + x[ LTAGRNFC ] + x[ LTTIPNFC ] + x[ LTCODNEG ] + x[ LTSERVIC ] + x[ LTCLIAGR ] + x[ LTLOJAGR ] + x[ LTCLIDES ] + x[ LTLOJDES ] + x[ LTSQEDES ] + x[ LTCLIDEV ] + x[ LTLOJDEV ] + x[ LTCLIEXP ] + x[ LTLOJEXP ] + x[ LTNUMCOT ] + x[ LTSEQINS ] + x[ LTSEQINSD ] + x[ LTCDRORI ] + x[ LTCDRCAL ] + x[ LTNUMNFC ] + x[ LTSERNFC ] < y[ LTQBRCALC ] + y[ LTDATAGD ] + y[ LTQBRDIVG] + y[ LTAGRNFC ] + y[ LTTIPNFC ] + y[ LTCODNEG ] + y[ LTSERVIC ] + y[ LTCLIAGR ] + y[ LTLOJAGR ] + y[ LTCLIDES ] + y[ LTLOJDES ] + y[ LTSQEDES ] + y[ LTCLIDEV ] + y[ LTLOJDEV ] + y[ LTCLIEXP ] + y[ LTLOJEXP ] + y[ LTNUMCOT ] + y[ LTSEQINS ] + y[ LTSEQINSD ] + y[ LTCDRORI ] + y[ LTCDRCAL ] + y[ LTNUMNFC ] + y[ LTSERNFC ] })
	EndIf

	//-- Nao adicionar no vetor aLote
	lRet := .F.

ElseIf cAcao == '5'			//-- Retorna string, utilizado no preenchimento da variavel cChave
	//-- A T E N C A O   Alteracoes na chave abaixo tambem devem ser feitas na funcao TMSA200QB1
	If lPrcProd //-- Preco por Produto
		cRet := aLote[ nCntFor, LTQBRCALC ] + aLote[ nCntFor, LTDATAGD ] + aLote[ nCntFor, LTQBRDIVG] + aLote[ nCntFor, LTTIPNFC ] + aLote[ nCntFor, LTCODNEG ] + aLote[ nCntFor, LTSERVIC ] + aLote[ nCntFor, LTCLIAGR ] + aLote[ nCntFor, LTLOJAGR ] + aLote[ nCntFor, LTCLIDES ] + aLote[ nCntFor, LTLOJDES ] + aLote[ nCntFor, LTSQEDES ] + aLote[ nCntFor, LTCLIDEV ] + aLote[ nCntFor, LTLOJDEV ] + aLote[ nCntFor, LTCLIEXP ] + aLote[ nCntFor, LTLOJEXP ] + aLote[ nCntFor, LTCODPRO ] + aLote[ nCntFor, LTNUMCOT ] + aLote[ nCntFor, LTFILDPC ] + aLote[ nCntFor, LTSEQINS ] + aLote[ nCntFor, LTSEQINSD ] + aLote[ nCntFor, LTCDRORI ] + aLote[ nCntFor, LTCDRCAL ]
	Else
		cRet := aLote[ nCntFor, LTQBRCALC ] + aLote[ nCntFor, LTDATAGD ] + aLote[ nCntFor, LTQBRDIVG] + aLote[ nCntFor, LTTIPNFC ] + aLote[ nCntFor, LTCODNEG ] + aLote[ nCntFor, LTSERVIC ] + aLote[ nCntFor, LTCLIAGR ] + aLote[ nCntFor, LTLOJAGR ] + aLote[ nCntFor, LTCLIDES ] + aLote[ nCntFor, LTLOJDES ] + aLote[ nCntFor, LTSQEDES ] + aLote[ nCntFor, LTCLIDEV ] + aLote[ nCntFor, LTLOJDEV ] + aLote[ nCntFor, LTCLIEXP ] + aLote[ nCntFor, LTLOJEXP ] + aLote[ nCntFor, LTNUMCOT ] + aLote[ nCntFor, LTFILDPC ] + aLote[ nCntFor, LTSEQINS ] + aLote[ nCntFor, LTSEQINSD ] + aLote[ nCntFor, LTCDRORI ] + aLote[ nCntFor, LTCDRCAL ]
	EndIf

	//-- Agendamento de entrega
	If lAgdEntr
		cRet += aLote[ nCntFor, LTNUMAGD ] + aLote[ nCntFor, LTITEAGD ]
	EndIf

	//-- Nao adicionar no vetor aLote
	lRet := .F.

ElseIf cAcao == '6'			//-- Retorna string, utilizado no preenchimento da variavel cChave, baseado no vetor aNfCTRC
	If lPrcProd //-- Preco por Produto
		//-- Tipo NFC + Servico + Cliente Remetente + Loja Remetente + Cliente Agrup.+Loja Cli. Agrup.+Cliente Destinat+Loja Cli. Destinat.+Seq. Endereco Destinat.+ Cliente Devedor+Loj.Cli.Devedor+Produto+Cotacao+Seq.Inscricao
		cRet := aNfCTRC[ nCntFor, 48 ] + aNfCTRC[ nCntFor, 49 ] + aNfCTRC[ nCntFor, 51 ] + aNfCTRC[ nCntFor, 33 ] + aNfCTRC[ nCntFor, 50 ] + aNfCTRC[ nCntFor, 16 ] + aNfCTRC[ nCntFor, 3 ] + aNfCTRC[ nCntFor, 4 ] + aNfCTRC[ nCntFor, 17 ] + aNfCTRC[ nCntFor, 18 ] + aNfCTRC[ nCntFor, 19 ] + aNfCTRC[ nCntFor, 20 ]  + aNfCTRC[ nCntFor, 36 ] + aNfCTRC[ nCntFor, 21 ] + aNfCTRC[ nCntFor, 22 ] + aNfCTRC[ nCntFor, 23 ] + aNfCTRC[ nCntFor, 24 ] + aNfCTRC[ nCntFor, 37 ] + aNfCTRC[ nCntFor, 44 ] + aNfCTRC[ nCntFor, 14 ] + aNfCTRC[ nCntFor, 45 ]
	Else
		//-- Tipo NFC + Servico + Cliente Remetente + Loja Remetente + Cliente Agrup.+Loja Cli. Agrup.+Cliente Destinat+Loja Cli. Destinat.+Seq. Endereco Destinat.+ Cliente Devedor+Loj.Cli.Devedor+Cotacao+Seq.Inscricao
		cRet := aNfCTRC[ nCntFor, 48 ] + aNfCTRC[ nCntFor, 49 ] +  aNfCTRC[ nCntFor, 51 ] + aNfCTRC[ nCntFor, 33 ] + aNfCTRC[ nCntFor, 50 ] + aNfCTRC[ nCntFor, 16 ] + aNfCTRC[ nCntFor, 3 ] + aNfCTRC[ nCntFor, 4 ] + aNfCTRC[ nCntFor, 17 ] + aNfCTRC[ nCntFor, 18 ] + aNfCTRC[ nCntFor, 19 ] + aNfCTRC[ nCntFor, 20 ]  + aNfCTRC[ nCntFor, 36 ] + aNfCTRC[ nCntFor, 21 ] + aNfCTRC[ nCntFor, 22 ] + aNfCTRC[ nCntFor, 24 ] + aNfCTRC[ nCntFor, 37 ] + aNfCTRC[ nCntFor, 44 ] + aNfCTRC[ nCntFor, 14 ] + aNfCTRC[ nCntFor, 45 ]
	EndIf

	//-- Agendamento de entrega
	If lAgdEntr
		cRet += aLote[ nCntFor, LTNUMAGD ] + aLote[ nCntFor, LTITEAGD ]
	EndIf

	lRet := .F.

ElseIf cAcao == '7'			//-- Retorna string, utilizado no preenchimento da variavel cChave, baseado no vetor aNfCTRC
	If lPrcProd //-- Preco por Produto
		//--Filial Despachante+CTRC Despachante+Tipo NFC+Servico+ Cliente Agrup.+Loja Cli. Agrup.+Cliente Destinat+Loja Cli. Destinat.+Seq. Endereco Destinat.+Cliente Devedor+Loj.Cli.Devedor+Produto+Cotacao+Seq.Incricao
		cRet := aNfCTRC[ nCntFor, 48 ] + aNfCTRC[ nCntFor, 49 ] + aNfCTRC[ nCntFor, 51 ] + aNfCTRC[ nCntFor, 29 ] + aNfCTRC[ nCntFor, 30 ] + aNfCTRC[ nCntFor, 33 ] + aNfCTRC[ nCntFor, 50 ] + aNfCTRC[ nCntFor, 16 ] + aNfCTRC[ nCntFor, 17 ] + aNfCTRC[ nCntFor, 18 ] + aNfCTRC[ nCntFor, 19 ] + aNfCTRC[ nCntFor, 20 ] + aNfCTRC[ nCntFor, 36] + aNfCTRC[ nCntFor, 21 ] + aNfCTRC[ nCntFor, 22 ] + aNfCTRC[ nCntFor, 23 ] + aNfCTRC[ nCntFor, 24 ] + aNfCTRC[ nCntFor, 37 ] + aNfCTRC[ nCntFor, 44 ] + aNfCTRC[ nCntFor, 14 ] + aNfCTRC[ nCntFor, 45 ]
	Else
		//--Filial Despachante+CTRC Despachante+Tipo NFC+Servico+ Cliente Agrup.+Loja Cli. Agrup.+Cliente Destinat+Loja Cli. Destinat.+Seq. Endereco Destinat.+Cliente Devedor+Loj.Cli.Devedor+Cotacao+Seq.Inscricao
		cRet := aNfCTRC[ nCntFor, 48 ] + aNfCTRC[ nCntFor, 49 ] + aNfCTRC[ nCntFor, 51 ] + aNfCTRC[ nCntFor, 29 ] + aNfCTRC[ nCntFor, 30 ] + aNfCTRC[ nCntFor, 33 ] + aNfCTRC[ nCntFor, 50 ] + aNfCTRC[ nCntFor, 16 ] + aNfCTRC[ nCntFor, 17 ] + aNfCTRC[ nCntFor, 18 ] + aNfCTRC[ nCntFor, 19 ] + aNfCTRC[ nCntFor, 20 ] + aNfCTRC[ nCntFor, 36] + aNfCTRC[ nCntFor, 21 ] + aNfCTRC[ nCntFor, 22 ] + aNfCTRC[ nCntFor, 24 ] + aNfCTRC[ nCntFor, 37 ] + aNfCTRC[ nCntFor, 44 ] + aNfCTRC[ nCntFor, 14 ] + aNfCTRC[ nCntFor, 45 ]
	EndIf

	//-- Agendamento de entrega
	If lAgdEntr
		cRet += aLote[ nCntFor, LTNUMAGD ] + aLote[ nCntFor, LTITEAGD ]
	EndIf

	lRet := .F.

ElseIf cAcao == '8'			//-- Retorna string, utilizado no preenchimento da variavel cChave
	If lPrcProd //-- Preco por Produto
		cRet := aLote[ nCntFor, LTQBRCALC ] + aLote[ nCntFor, LTDATAGD ] + aLote[ nCntFor, LTQBRDIVG] + aLote[ nCntFor, LTFILDPC ] + aLote[ nCntFor, LTCTRDPC ] + aLote[ nCntFor, LTTIPNFC ] + aLote[ nCntFor, LTCODNEG ] + aLote[ nCntFor, LTSERVIC ] + aLote[ nCntFor, LTCLIAGR ] + aLote[ nCntFor, LTLOJAGR ] + aLote[ nCntFor, LTCLIDES ] + aLote[ nCntFor, LTLOJDES ] + aLote[ nCntFor, LTSQEDES ]  + aLote[ nCntFor, LTCLIEXP ] + aLote[ nCntFor, LTLOJEXP ] + aLote[ nCntFor, LTCODPRO ] + aLote[ nCntFor, LTSEQINS ] + aLote[ nCntFor, LTSEQINSD ] + aLote[ nCntFor, LTCDRORI ] + aLote[ nCntFor, LTCDRCAL ]
	Else
		cRet := aLote[ nCntFor, LTQBRCALC ] + aLote[ nCntFor, LTDATAGD ] + aLote[ nCntFor, LTQBRDIVG] + aLote[ nCntFor, LTFILDPC ] + aLote[ nCntFor, LTCTRDPC ] + aLote[ nCntFor, LTTIPNFC ] + aLote[ nCntFor, LTCODNEG ] + aLote[ nCntFor, LTSERVIC ] + aLote[ nCntFor, LTCLIAGR ] + aLote[ nCntFor, LTLOJAGR ] + aLote[ nCntFor, LTCLIDES ] + aLote[ nCntFor, LTLOJDES ] + aLote[ nCntFor, LTSQEDES ]  + aLote[ nCntFor, LTCLIEXP ] + aLote[ nCntFor, LTLOJEXP ] + aLote[ nCntFor, LTSEQINS ] + aLote[ nCntFor, LTSEQINSD ] + aLote[ nCntFor, LTCDRORI ] + aLote[ nCntFor, LTCDRCAL ]
	EndIf

	//-- Agendamento de entrega
	If lAgdEntr
		cRet += aLote[ nCntFor, LTNUMAGD ] + aLote[ nCntFor, LTITEAGD ]
	EndIf

	lRet := .F.

ElseIf cAcao == '9'			//-- Ordena o vetor aLote
	ASort( aLote,,,{|x,y| x[ LTQBRCALC ] + x[ LTDATAGD ] + x[ LTQBRDIVG ] + x[ LTAGRNFC ] + x[ LTCLIREM ] + x[ LTLOJREM ] + x[ LTCLIEXP ] + x[ LTLOJEXP ] + x[ LTNUMNFC ] + x[ LTSERNFC ] < y[ LTQBRCALC ] + y[ LTDATAGD ] + y[ LTQBRDIVG ] + y[ LTAGRNFC ] + y[ LTCLIREM ] + y[ LTLOJREM ] + y[ LTNUMNFC ] + y[ LTSERNFC ] })
	lRet := .F.

ElseIf cAcao == '10'		//-- Ordena o vetor aLote
	ASort( aLote,,,{|x,y| x[ LTQBRCALC ] + x[ LTDATAGD ] + x[ LTQBRDIVG ] + x[ LTAGRNFC ] + x[ LTCLIDEV ] + x[ LTLOJDEV ] + x[ LTCLIEXP ] + x[ LTLOJEXP ] + x[ LTNUMNFC ] + x[ LTSERNFC ] < y[ LTQBRCALC ] + y[ LTDATAGD ] + y[ LTQBRDIVG ] + y[ LTAGRNFC ] + y[ LTCLIDEV ] + y[ LTLOJDEV ] +  y[ LTCLIEXP ] + y[ LTLOJEXP ] + y[ LTNUMNFC ] + y[ LTSERNFC ] })
	lRet := .F.

ElseIf cAcao == '11'		//-- Retorna string, utilizado no preenchimento da variavel cChave
	cRet := aLote[ nCntFor, LTQBRCALC ] + aLote[ nCntFor, LTDATAGD ] + aLote[ nCntFor, LTQBRDIVG ] + aLote[ nCntFor, LTTIPNFC ] + aLote[ nCntFor, LTCODNEG ] + aLote[ nCntFor, LTSERVIC ] + aLote[ nCntFor, LTCLIDEV ] + aLote[ nCntFor, LTLOJDEV ] + aLote[ nCntFor, LTCLIEXP ] + aLote[ nCntFor, LTLOJEXP ] + aLote[ nCntFor, LTNUMCOT ]
	lRet := .F.

ElseIf cAcao == '12'
	If lPrcProd //-- Preco por Produto
		cRet := aLote[ nCntFor, LTQBRCALC ] + aLote[ nCntFor, LTDATAGD ] +  aLote[ nCntFor, LTQBRDIVG ] + aLote[ nCntFor, LTTIPNFC ] + aLote[ nCntFor, LTCODNEG ] + aLote[ nCntFor, LTSERVIC ] + aLote[ nCntFor, LTCLIAGR ] + aLote[ nCntFor, LTLOJAGR ] + aLote[ nCntFor, LTCLIDES ] + aLote[ nCntFor, LTLOJDES ] + aLote[ nCntFor, LTSQEDES ] + aLote[ nCntFor, LTCLIDEV ] + aLote[ nCntFor, LTLOJDEV ] + aLote[ nCntFor, LTCLIEXP ] + aLote[ nCntFor, LTLOJEXP ] + aLote[ nCntFor, LTNUMNFC ] + aLote[ nCntFor, LTSERNFC ] + aLote[ nCntFor, LTCODPRO ]
	Else
		cRet := aLote[ nCntFor, LTQBRCALC ] + aLote[ nCntFor, LTDATAGD ] + aLote[ nCntFor, LTQBRDIVG ] + aLote[ nCntFor, LTTIPNFC ] + aLote[ nCntFor, LTCODNEG ] + aLote[ nCntFor, LTSERVIC ] + aLote[ nCntFor, LTCLIAGR ] + aLote[ nCntFor, LTLOJAGR ] + aLote[ nCntFor, LTCLIDES ] + aLote[ nCntFor, LTLOJDES ] + aLote[ nCntFor, LTSQEDES ] + aLote[ nCntFor, LTCLIDEV ] + aLote[ nCntFor, LTLOJDEV ] + aLote[ nCntFor, LTCLIEXP ] + aLote[ nCntFor, LTLOJEXP ] + aLote[ nCntFor, LTNUMNFC ] + aLote[ nCntFor, LTSERNFC ]
	EndIf

	//-- Agendamento de entrega
	If lAgdEntr
		cRet += aLote[ nCntFor, LTNUMAGD ] + aLote[ nCntFor, LTITEAGD ]
	EndIf

	//-- Nao adicionar no vetor aLote
	lRet := .F.
EndIf

If lRet
	AAdd( aLote, aClone( aCampos ) )
EndIf

ResetArr(@aCampos		)
ResetArr(@aValInf		)
ResetArr(@aTipVei		)
ResetArr(@aPesCub		)

Return( cRet )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TmsA200Cot≥ Autor ≥ Alex Egydio           ≥ Data ≥12.03.2003≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Calcula o ICMS da cotacao                                  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥                                                            ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TmsA200Cot(aFrete,cNumCot,cCliDev,cLojDev,cDocTms,cTipFre,cCdrDes,cCodPro,cTipoCli,cCdrOri,cCliRem,cLojRem,cCliDes,cLojDes,cFilCFS,cTipNFC,cCdrCal,lFretInf)

Local aAreaAnt   := GetArea()
Local aAreaDT8   := DT8->(GetArea())
Local cA1_IncIss := ""
Local cFilAtu    := cFilAnt

Default cCdrOri  := ""
Default cCliRem  := ""
Default cLojRem  := ""
Default cCliDes  := ""
Default cLojDes  := ""
Default cFilCFS  := ""
Default cTipNFC  := "0"
Default cCodPro  := Space(Len(SB1->B1_COD))
Default lFretInf := .F.

If !Empty(cFilCFS)
	cFilAtu := cFilCFS
EndIf

If lTM200CAL
	cCdrCal := ExecBlock( "TM200CAL" , .F. , .F. , {cCdrCal} )
Endif

//-- forÁa a regi„o de calculo no calculo do imposto
IF Empty( cCdrCal )
	cCdrCal := cCdrDes
Endif

//-- Obtem a composicao de frete da cotacao
TmsViewFrt('4',cFilAtu,cNumCot,,cCodPro,,,aFrete)

TMSA200Cli( cCliDev, cLojDev)   //posiciona na tabela SA1
cA1_IncIss := Iif(SA1->A1_INCISS == "S","S","N")

//-- Calcula impostos
TmsA040Imp(aFrete,cCliDev,cLojDev,cDocTms,cTipFre,cCdrCal,.T.,,,cTipoCli,,cCdrOri,,cA1_IncIss,cCliRem,cLojRem,cCliDes,cLojDes,,,cTipNFC,cCodPro)

RestArea(aAreaAnt)
RestArea(aAreaDT8)
Return( Nil )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TmsA200Agr≥ Autor ≥ Alex Egydio           ≥ Data ≥05.12.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Analisa documentos com agrupamento de clientes             ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpA1 = Vetor com a composicao de frete                    ≥±±
±±≥          ≥ ExpA2 = Vetor com as notas fiscais do cliente              ≥±±
±±≥          ≥ ExpA3 = Array contendo as mensagens de Erro                ≥±±
±±≥          ≥ ExpC1 = Numero do lote de entrada de n.fiscais do cliente  ≥±±
±±≥          ≥ ExpC2 = Tabela de frete                                    ≥±±
±±≥          ≥ ExpC3 = Tipo da tabela de frete                            ≥±±
±±≥          ≥ ExpC4 = Sequencia da tabela                                ≥±±
±±≥          ≥ ExpC5 = Contrato                                           ≥±±
±±≥          ≥ ExpC6 = Servico                                            ≥±±
±±≥          ≥ ExpC7 = Numero da composicao                               ≥±±
±±≥          ≥ ExpL1 = .T. gera documento do 1o percurso                  ≥±±
±±≥          ≥ ExpL2 = .T. identificar servico automatico                 ≥±±
±±≥          ≥ ExpN1 = Quantidade de volumes                              ≥±±
±±≥          ≥ ExpN2 = Valor da mercadoria                                ≥±±
±±≥          ≥ ExpN3 = Peso real                                          ≥±±
±±≥          ≥ ExpN4 = Peso cubado                                        ≥±±
±±≥          ≥ ExpN5 = Peso cobrado                                       ≥±±
±±≥          ≥ ExpN6 = Metro cubico                                       ≥±±
±±≥          ≥ ExpN7 = Base de seguro                                     ≥±±
±±≥          ≥ ExpA4 = Valor Informado                                    ≥±±
±±≥          ≥ ExpA5 = Tipo do Veiculo                                    ≥±±
±±≥          ≥ ExpA6 = Altura/Largura/Comprimento                         ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function TmsA200Agr(aFrete,aNfCTRC,aVisErr,cLotNfc,cTabFre,cTipTab,cSeqTab,cNContr,cServic,l1oPerc,lSrvAut,nQtdVol,nValor,nPeso,nPesoM3,nPesoCob,nMetro3,nSeguro,nCntFor,aValInf,aTipVei,aPesCub,nKMNF,cCodNeg,nPesoCol,aFreteCol)
Local aFreOri	:= {}
Local aFreTot	:= {}
Local aNfCAgr	:= {}
Local cSrvAgr	:= ''
Local cChave	:= ''
Local cCodPro	:= Space(Len(SB1->B1_COD))
Local nBaseDoc	:= 0
Local nBaseOri	:= 0
Local n1Cnt		:= 0
Local n2Cnt		:= 0
Local nQtdAgr	:= 0
Local nValAgr	:= 0
Local nPesAgr	:= 0
Local nPe3Agr	:= 0
Local nMe3Agr	:= 0
Local nSegAgr	:= 0
Local nUniAgr	:= 0
Local nPLiAgr	:= 0
Local nTotal	:= 0
Local nDife		:= 0
Local nPosAtu	:= nCntFor - Len(aNfCTRC) //-- Posicao da Nota Fiscal no aLote
Local lUnico	:= .F.
Local lTodosTax	:= .T.
Local cTaxCtr	:= ''
Local cCliRem	:= ''
Local cLojRem	:= ''
Local cCliDes	:= ''
Local cLojDes	:= ''
Local cCliCal	:= ''
Local cLojCal	:= ''
Local lCRTAuto	:= .F.
Local lRet		:= .T.
Local cDocTms 	:= ''
Local lIdentDoc := DTC->(ColumnPos("DTC_DOCTMS")) > 0
Local lRetViag  := .T.
Local n3Cnt		:= 0
Local lTabDDA	:= Iif(FindFunction("TmsUniNeg"),TmsUniNeg(),.F.)
Local nPos      := 0

DEFAULT aFrete  	:= {}
DEFAULT aValInf 	:= {}
DEFAULT aTipVei 	:= {}
DEFAULT aPesCub 	:= {}
DEFAULT lSrvAut 	:= .F.
Default nKMNF   	:= 0
Default nPesoCol 	:= 0
Default aFreteCol	:= {}

aFreOri := AClone( aFrete )
aFreTot := AClone( aFrete )
For n1Cnt := 1 To Len(aFreTot)
	aFreTot[n1Cnt, 2] := 0
Next

//-- Ordena por Peso zerado/informado + Agrupa + Cliente Agrupamento + Loja Agrupamento + Nota + Serie
aNfCTRC := ASort( aNfCTRC,,,{|x,y| x[48] + x[49] + x[51] + x[34] + x[31] + x[17] + x[18] + x[01] + x[02] < y[48] + y[49] + y[51] + y[34] + y[31] + y[17] + y[18] + y[01] + y[02] })

For n1Cnt := 1 To Len(aNfCTRC)
	nPosAtu := aNfCTRC[n1Cnt,47] //-- Indice do array aLote
	//-- Retorna string utilizado no preenchimento da variavel cChave
	If !Empty(aNfCTRC[n1Cnt,29]) .And. !Empty(aNfCTRC[n1Cnt,30])
		cChave := TmsA200Lot(,aNfCTRC,,,,,,,,,,,'7',n1Cnt)
	Else
		cChave := TmsA200Lot(,aNfCTRC,,,,,,,,,,,'6',n1Cnt)
	EndIf

	nQtdAgr += aNfCTRC[n1Cnt,5 ]
	nValAgr += aNfCTRC[n1Cnt,6 ]
	nPesAgr += aNfCTRC[n1Cnt,7 ]
	nPe3Agr += aNfCTRC[n1Cnt,8 ]
	nMe3Agr += aNfCTRC[n1Cnt,9 ]
	nSegAgr += aNfCTRC[n1Cnt,10]
	nUniAgr += aNfCTRC[n1Cnt,27]
	nPLiAgr += aNfCTRC[n1Cnt,38]
	cCliRem := aNfCTRC[n1Cnt,03]
	cLojRem := aNfCTRC[n1Cnt,04]
	cCliDes := aNfCTRC[n1Cnt,19]
	cLojDes := aNfCTRC[n1Cnt,20]
	cCliCal := aNfCTRC[n1Cnt,21]
	cLojCal := aNfCTRC[n1Cnt,22]

	//-- Formato dos vetores aNfCTRC e aNfCAgr
	//-- [01] = Numero da nota fiscal do cliente
	//-- [02] = Serie da nota fiscal do cliente
	//-- [03] = Cliente remetente
	//-- [04] = Loja do cliente remetente
	//-- [05] = Volume
	//-- [06] = Valor da mercadoria
	//-- [07] = Peso real
	//-- [08] = Peso cubado
	//-- [09] = Metro cubico
	//-- [10] = Base de seguro
	//-- [11] = Numero do contrato
	//-- [12] = Tipo de servico
	//-- [13] = Tipo de transporte
	//-- [14] = Codigo da regiao de origem
	//-- [15] = Codigo da regiao de destino
	//-- [16] = Codigo do servico
	//-- [17] = Cliente agrupamento
	//-- [18] = Loja do cliente agrupamento
	//-- [19] = Cliente destinatario
	//-- [20] = Loja do cliente destinatario
	//-- [21] = Cliente devedor
	//-- [22] = Loja do cliente devedor
	//-- [23] = Codigo do produto
	//-- [24] = Numero da cotacao
	//-- [25] = Qtde de notas fiscais por conhecimento
	//-- [26] = Peso maximo por conhecimento
	//-- [27] = Quantidade de unitizadores
	//-- [28] = Valor do frete despachante
	//-- [29] = Filial despachante
	//-- [30] = CTRC despachante
	//-- [31] = Considera ou nao as quebras por numero de notas fiscais por CTRC e peso maximo por CTRC
	//-- [32] = Numero da solicitacao de coleta
	//-- [33] = Tipo nfc
	//-- [34] = Tipo nfc
	//-- [35] = Peso Informado (0=Nao; 1=Sim)
	//-- [36] = Condicao de Pagamento
	//-- [37] = Seq. Endereco  Destinatario
	//-- [38] = Seq. Inscricao Devedor
	//-- [39] = Peso Liquido
	//-- [40] = Moeda
	//-- [41] = Desconsidera TDA (1-Coleta, 2-Entrega ou 3-Ambas)
	//-- [42] = Elemento para Definir quebra do Calculo ( aLote[ nCntFor, LTQBRCALC ] )
	//-- [43] =
	//-- [44] = Codigo da Negociacao
	//-- [45] = Quebra do Calculo De Divergencias De Classes De Risco
	//-- [46] = Estorno Frete Agrupado
	AAdd( aNfCAgr, {	aNfCTRC[n1Cnt, 1],	aNfCTRC[n1Cnt, 2],	aNfCTRC[n1Cnt, 3],;
						aNfCTRC[n1Cnt, 4],	aNfCTRC[n1Cnt, 5],	aNfCTRC[n1Cnt, 6],;
						aNfCTRC[n1Cnt, 7],	aNfCTRC[n1Cnt, 8],	aNfCTRC[n1Cnt, 9],;
						aNfCTRC[n1Cnt,10],	aNfCTRC[n1Cnt,11],	aNfCTRC[n1Cnt,12],;
						aNfCTRC[n1Cnt,13],	aNfCTRC[n1Cnt,14],	aNfCTRC[n1Cnt,15],;
						aNfCTRC[n1Cnt,16],	aNfCTRC[n1Cnt,17],	aNfCTRC[n1Cnt,18],;
						aNfCTRC[n1Cnt,19],	aNfCTRC[n1Cnt,20],	aNfCTRC[n1Cnt,21],;
						aNfCTRC[n1Cnt,22],	aNfCTRC[n1Cnt,23],	aNfCTRC[n1Cnt,24],;
						aNfCTRC[n1Cnt,25],	aNfCTRC[n1Cnt,26],	aNfCTRC[n1Cnt,27],;
						aNfCTRC[n1Cnt,28],	aNfCTRC[n1Cnt,29],	aNfCTRC[n1Cnt,30],;
						aNfCTRC[n1Cnt,31],	aNfCTRC[n1Cnt,32],	aNfCTRC[n1Cnt,33],;
						aNfCTRC[n1Cnt,33],	aNfCTRC[n1Cnt,34],	aNfCTRC[n1Cnt,35],;
						aNfCTRC[n1Cnt,36],	aNfCTRC[n1Cnt,37],	aNfCTRC[n1Cnt,38],;
						aNfCTRC[n1Cnt,39],	aNfCTRC[n1Cnt,40],	aNfCTRC[n1Cnt,48],;
						aNfCTRC[n1Cnt,49],  aNfCTRC[n1Cnt,50],  aNfCTRC[n1Cnt,51],; //--aNfCTRC[n1Cnt,51] -> Quebra do Calculo De Divergencias De Classes De Risco.
                        aNfCTRC[n1Cnt,55]} )

	lCRTAuto := .F.
	If aNfCTRC[n1Cnt,13] == '4' //-- Rodoviario Internacional
		DIK->(DbSetOrder(1)) //DIK_FILIAL+DIK_FILORI+DIK_LOTNFC
		If DIK->(MsSeek(xFilial('DIK')+cFilAnt+cLotNfc))
			lCRTAuto := .T.
		EndIf
	EndIf

	//-- Analisa se houve quebras no vetor aNfCTRC
	If	TMSA200Qbr( cChave, n1Cnt, Len( aNfCAgr ), aNfCTRC[ n1Cnt, 25 ], nPesAgr , aNfCTRC[ n1Cnt, 26 ], .T., aNfCTRC, aNfCTRC[ n1Cnt, 31 ], Iif(aNfCTRC[ n1Cnt, 13 ] == '4',.T.,!Empty(aNfCTRC[ n1Cnt, 24 ])) )
		cTaxCtr := aNfCTRC[ n1Cnt, 46 ] //Taxa por CTRC ?

		lTodosTax := .T.
		//-- se for a ultima nota que entrou na quebra e nao gerou nenhum documento ainda, significa
		//-- que sera calculado apenas um conhecimento
		lUnico    := n1Cnt == Len(aNfCtrc) .And. Len(aDocto) == 0
		For n2Cnt := 1 To Len(aFrete)
			If aFrete[n2Cnt,3] <> 'TF' .And. !TMSAComTax(aFrete[n2Cnt,3]) .And. aFrete[n2Cnt,2] > 0
				lTodosTax := .F.
				Exit
			EndIf
		Next n2Cnt
		//Se todos os componentes da tabela de frete sao taxa e o perfil esta configurado
		//para taxar somente o ultimo ctrc e ha mais de um ctrc para ser calculado
		//informa o usuario que ha problema de configuracao
		If cTaxCtr == StrZero(2,Len(DUO->DUO_TAXCTR)) .And. lTodosTax .And. !lUnico
			If Ascan( aVisErr, { |x| x[2] == '25' } ) == 0
				AAdd( aVisErr, {STR0017 + ':' + cNContr + STR0068 +  STR0069 , '25', "TMSA200()" } ) //"O contrato: 0000000001 esta configurado para taxar apenas o ultimo ctrc do lote, e a tabela de frete: 5000/01 possui apenas componentes taxa"
			EndIf
			Exit
		EndIf
		//-- Identifica servico automatico
		If lSrvAut
			//-- Identifica o servico
			cSrvAgr := TmsRetServ( aNfCTRC[n1Cnt,11], aNfCTRC[n1Cnt,12], aNfCTRC[n1Cnt,13], (aNfCTRC[n1Cnt,14]==aNfCTRC[n1Cnt,15]), nQtdAgr, nValAgr, nPesAgr, nPe3Agr, aNfCTRC[n1Cnt,14], aNfCTRC[n1Cnt,15], aNfCTRC[n1Cnt,45], aNfCTRC[n1Cnt,50] )
			If	! Empty( cSrvAgr )
				//-- Grava o codigo do servico nas notas fiscais do cliente
				For n2Cnt := 1 To Len( aNfCAgr )
					DC5->(DbSetOrder(1))
					DC5->(MsSeek( xFilial('DC5') + cSrvAgr ))
					If lIdentDoc .And. Empty(DC5->DC5_DOCTMS)
						cDocTms := TMSTipDoc(aLote[ nCntFor, LTCDRORI ],aLote[ nCntFor, LTCDRCAL ])
					Else
						cDocTms := DC5->DC5_DOCTMS
					EndIf
					DTC->(DbSetOrder(2)) //DTC_FILIAL+DTC_NUMNFC+DTC_SERNFC+DTC_CLIREM+DTC_LOJREM+DTC_CODPRO+DTC_FILORI+DTC_LOTNFC
					If	DTC->(MsSeek(xFilial('DTC') + aNfCAgr[ n2Cnt, 1] + aNfCAgr[ n2Cnt, 2] + aNfCAgr[ n2Cnt, 3] + aNfCAgr[ n2Cnt, 4] + aNfCTRC[ n1Cnt, 23]))
						RecLock('DTC',.F.)
						DTC->DTC_SERVIC := cSrvAgr
						If lIdentDoc
							DTC->DTC_DOCTMS := cDocTms
						EndIf
						MsUnLock()
					EndIf
					lRetViag :=TmsRetViag(aNfCAgr[ n2Cnt, 32], aNfCAgr[ n2Cnt, 11], aNfCAgr[ n2Cnt, 16],aNfCAgr[ n2Cnt, 44])
				Next
			Else
				Help( '', 1, 'TMSA20024',,STR0017 + aNfCTRC[n1Cnt,11],5,11)	//-- Nao ha servico especificado para esta faixa de volume, peso e valor.
				Exit
			EndIf
		Else
			If	nValor != nValAgr .Or. Empty(aFrete)
				//-- Formato do vetor aFrete
				//--
				//-- [01] = Descricao do componente
				//-- [02] = Valor do componente
				//-- [03] = Codigo do componente
				//-- [04] = Item SD2. Atualizado pelas funcoes que geram o SD2
				//-- [05] = Na cotacao eh gravado o valor do imposto do componente
				//-- [06] = Total do componente ( valor + imposto )
				//-- [07] = Codigo da regiao origem
				//-- [08] = Codigo da regiao destino
				//-- [09] = Tabela de Frete
				//-- [10] = Tipo da Tabela de Frete
				//-- [11] = Sequencia da Tabela de Frete
				aFrete := {}
				//-- Nao altera o valor do frete para notas fiscais com valores zerados.
				If	!( Empty( nQtdAgr ) .And. Empty( nValAgr ) .And. Empty( nPesAgr ) )
					aFrete := AClone( aFreOri )
					nTotal := 0
					For n2Cnt := 1 To Len( aFrete )
						If	aFrete[ n2Cnt, 3 ] <> 'TF'
							//---- Para o componente 16- Herda Valor o valor devera sempre ser rateado independente de ser um Lote de Rateio ou n„o.
							If lTabDDA .And. aFrete[ n2Cnt, 16 ] == '16' .And. aNfCTRC[n1Cnt,54] <> '0' .And. Len(aFreteCol) > 0
								TmsRatHer(@aFrete,aFreteCol,n2Cnt,aNfCTRC[n1Cnt,54],aNfCTRC[n1Cnt,32],nPesAgr, nPe3Agr,nValAgr,nQtdAgr,nMe3Agr)

								aFreTot[n2Cnt, 2 ] += aFrete[ n2Cnt, 2 ]
								nTotal += aFrete[ n2Cnt, 2 ]
							Else
								//-- Calcula a proporcao utilizando o peso caso tenha componentes de frete misto ( componentes taxa e nao taxa )
								//-- e so faz a proporcao de peso somente naqueles componentes que nao sao taxa
								//-- Ou Calcula a proporcao utilizando o peso caso tenha apenas componentes de frete taxa
								If	( !lTodosTax .And. !TMSAComTax(aFrete[ n2Cnt, 3 ]) ) .Or. lTodosTax
									aFrete[ n2Cnt, 2 ] := Round(( nPesAgr / nPeso ) * aFreOri[ n2Cnt, 2 ], 2)
									aFreTot[n2Cnt, 2 ] += aFrete[ n2Cnt, 2 ]
									nTotal += aFrete[ n2Cnt, 2 ]
								EndIf
							EndIf
						ElseIf nTotal > 0
							aFrete[ n2Cnt, 2 ] := nTotal
							aFreTot[n2Cnt, 2 ] += nTotal
						EndIf
					Next
					//-- Ultimo documento: comparar totais -> somar diferenca entre aFreOri e aFreTot
					If n1Cnt == Len(aNfCTRC)
						For n2Cnt := 1 To Len( aFreOri )
							nDife :=  aFreOri[ n2Cnt, 2 ] -  aFreTot[ n2Cnt, 2 ]
							If nDife <> 0
								//-- Se no Contrato esta como Taxa p/CTRC igual a nao e o componente Taxa, assume o valor da diferena e nao incrementa no valor
								If cTaxCtr == StrZero(2,Len(DUO->DUO_TAXCTR)) .And. TMSAComTax(aFrete[n2Cnt,3])
									aFrete[ n2Cnt, 2 ] := nDife
								Else
									aFrete[ n2Cnt, 2 ] += nDife
								EndIf
							EndIf
						Next
					EndIf
				EndIf
			Else
				//--- Rateia o valor do componente Herda Valor
				If lTabDDA .And. aNfCTRC[n1Cnt,54] <> '0' .And. Len(aFreteCol) > 0
					//-- Verifica posicao da Solicitacao de Coleta no vetor aFreteCol
					nPos:= Ascan(aFreteCol, {|x| x[2] == aNfCTRC[n1Cnt,32] })

					If nPos > 0
						//--- Se existir mais de uma Nota, o valor do componente 16-Herda Valor devera ser rateado
						If Len(aFreteCol[nPos][4]) > 1
							nTotal:= 0
							For n2Cnt := 1 To Len( aFrete )
								If	aFrete[ n2Cnt, 3 ] <> 'TF'
									If aFrete[ n2Cnt, 16 ] == '16'
										TmsRatHer(@aFrete,aFreteCol,n2Cnt,aNfCTRC[n1Cnt,54],aNfCTRC[n1Cnt,32],nPesAgr, nPe3Agr,nValAgr,nQtdAgr,nMe3Agr)
									EndIf
									nTotal += aFrete[ n2Cnt, 2 ]
								Else
									If nTotal > 0
										aFrete[ n2Cnt, 2 ] := nTotal
									EndIf
								EndIf
							Next n2Cnt
						EndIf
					EndIf
				EndIf
			EndIf
			//Rateio de coleta, verifica se esta encerrada a viagem de coleta referente a solicitaÁ„o de coleta informada na nota, desde que,
			// tenhamos componente do tipo herda valor (16) configurado na tabela de utilizada no calculo.
			// Caso nao tenhamos o componente herda valor na tabela de frete, geramos o documento normalmente.
			For n3Cnt := 1 To Len( aNfCAgr )
				lRetViag :=TmsRetViag(aNfCAgr[ n3Cnt, 32], aNfCAgr[ n3Cnt, 11], aNfCAgr[ n3Cnt, 16],aNfCAgr[ n3Cnt, 44])
			Next n3Cnt
			If lRetViag
				//-- Gera documentos
				TmsA200Doc(aFrete,aNfCAgr,,cLotNfc,cTabFre,cTipTab,cSeqTab,l1oPerc,nQtdAgr,nValAgr,nPesAgr,nPe3Agr,nMe3Agr,nSegAgr,nUniAgr,nPesoCob,nPosAtu,aValInf,aTipVei,aPesCub,cCodPro,nPLiAgr,nKMNF,nPesoCol)
			Else
				lRet := .F.
			Endif
		EndIf
		aNfCAgr := {}
		nQtdAgr := 0
		nValAgr := 0
		nPesAgr := 0
		nPe3Agr := 0
		nMe3Agr := 0
		nSegAgr := 0
		nUniAgr := 0
	EndIf

Next n1Cnt

ResetArr(@aFreOri	)
ResetArr(@aFreTot	)
ResetArr(@aNfCAgr	)

Return( lRet )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TmsA200Doc≥ Autor ≥ Alex Egydio           ≥ Data ≥03.12.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Gera documentos                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpA1 = Vetor com a composicao de frete                    ≥±±
±±≥          ≥ ExpA2 = Vetor com as notas fiscais do cliente              ≥±±
±±≥          ≥ ExpA3 = Vetor qd executado da manut.de documentos          ≥±±
±±≥          ≥ ExpC1 = Numero do lote de entrada de n.fiscais do cliente  ≥±±
±±≥          ≥ ExpC2 = Tabela de frete                                    ≥±±
±±≥          ≥ ExpC3 = Tipo da tabela de frete                            ≥±±
±±≥          ≥ ExpC4 = Sequencia da tabela                                ≥±±
±±≥          ≥ ExpL1 = .T. gera documento do 1o percurso                  ≥±±
±±≥          ≥ ExpN1 = Quantidade de volumes                              ≥±±
±±≥          ≥ ExpN2 = Valor da mercadoria                                ≥±±
±±≥          ≥ ExpN3 = Peso real                                          ≥±±
±±≥          ≥ ExpN4 = Peso cubado                                        ≥±±
±±≥          ≥ ExpN5 = Peso cobrado                                       ≥±±
±±≥          ≥ ExpN6 = Metro cubico                                       ≥±±
±±≥          ≥ ExpN7 = Base de seguro                                     ≥±±
±±≥          ≥ ExpN8 - Qtde de Unitizador                                 ≥±±
±±≥          ≥ ExpC5 = Numero da composicao                               ≥±±
±±≥          ≥ ExpA4 = Valor Informado                                    ≥±±
±±≥          ≥ ExpA5 = Tipo de Veiculo                                    ≥±±
±±≥          ≥ ExpA6 = Altura/Largura/Comprimento                         ≥±±
±±≥          ≥ ExpC6 = Produto da Nota Fiscal (Utilizado qdo. o parametro ≥±±
±±≥          ≥         MV_PRCPROD estiver Desabilitado                    ≥±±
±±≥          ≥ ExpN9 = Peso Liquido                                       ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TmsA200Doc(aFrete,aNfCTRC,aTmsA500,cLotNfc,cTabFre,cTipTab,cSeqTab,l1oPerc,nQtdVol,nValor,nPeso,nPesoM3,nMetro3,nSeguro,nQtdUni,nPesoCob,nCntFor,aValInf,aTipVei,aPesCub,cCodPro,nPesLiq, nKMNF,nPesoCol)
Local cAgrNfc	:= ''
Local cCliente	:= ''
Local cLoja		:= ''
Local cCliDev	:= ''
Local cLojDev	:= ''
Local cCliCal	:= ''
Local cLojCal	:= ''
Local cCondPag	:= ''
Local cDevFre	:= ''
Local cCdrOri	:= ''
Local cCdrDes	:= ''
Local cCdrCal	:= ''
Local cNContr	:= ''
Local cTipFre	:= ''
Local cTipNfc	:= '0'
Local cTpFrete	:= ''
Local cServic	:= ''
Local cCliAgr	:= ''
Local cLojAgr	:= ''
Local cCliDes	:= ''
Local cLojDes	:= ''
Local cSqEDes	:= ''
Local cCliRec   := ''
Local cLojRec   := ''
Local cNumCot	:= ''
Local nCnt1		:= 0
Local nNfCTRC	:= 0
Local nPesCTR	:= 0
Local nSeek		:= 0
Local nSeek1	:= 0
Local nSeek2	:= 0
Local cFilSol	:= ''
Local cNumSol	:= ''
Local cSequen	:= ''
Local lInvCtr	:= .F.
Local cSeqIns	:= ''
Local cFilDpc	:= ''
Local cCtrDpc	:= ''
Local nMoeda	:= 1
Local cSeqInsD	:= ''
Local cCliDpc	:= ''
Local cLojDpc   := ''
Local cQBRCALC	:= ""
Local cDATAGD	:= ""
Local cCodNeg   := ""
Local cQBRDIVG	:= ""
Local cRetira   := ""

DEFAULT aNfCTRC	:= {}
DEFAULT aTmsA500:= {}
DEFAULT aValInf	:= {}
DEFAULT aTipVei	:= {}
DEFAULT aPesCub	:= {}
DEFAULT cCodPro	:= aLote[nCntFor,LTCODPRO]
DEFAULT nPesLiq	:= 0
Default nKMNF   := 0
Default nPesoCol := 0

If lPrcProd ==  Nil
	lPrcProd := GetMV('MV_PRCPROD',,.T.)
EndIf

//-- Retorna a sequencia de calculo.
If lTM200SEQ
	cSequen := ExecBlock("TM200SEQ",.F.,.F.,{ aNfCtrc, cLotNfc })
	If ValType(cSequen) # "C"
		cSequen := ''
	EndIf
EndIf

//-- Indica se inverte ou n„o a geracao de CTRC de 1o. percurso, 1o. FOB e 2o. CIF
If lTm200ICT
	lInvCtr := ExecBlock("TM200ICT",.F.,.F.,{ aLote[nCntFor,LTSERVIC], aLote[nCntFor,LTCODNEG] }) .And.;
						aLote[nCntFor,LTDOCTMS] <> StrZero( 8, Len( DT6->DT6_DOCTMS ) )
	If ValType(lInvCtr) == "L" .And. lInvCtr
		l1oPerc := !l1oPerc
	EndIf

EndIf

//-- Primeiro percurso
If	l1oPerc
	cTipFre	:= StrZero(1,Len(DTC->DTC_TIPFRE))
	cCliente:= aLote[nCntFor,LTCLIDES]
	cLoja	:= aLote[nCntFor,LTLOJDES]
	cCliDev	:= aLote[nCntFor,LTCLIREM]
	cLojDev	:= aLote[nCntFor,LTLOJREM]
	cCliCal	:= aLote[nCntFor,LTCLICAL]
	cLojCal	:= aLote[nCntFor,LTLOJCAL]
	cCdrOri	:= aLote[nCntFor,LTCDRORI]
	cCdrDes	:= aLote[nCntFor,LTCDRPER]
	//-- Retorna o percurso para calculo.
	If lTM200PER
		cCdrDes := ExecBlock("TM200PER",.F.,.F.,{ .T., aLote[ nCntFor, LTCDRORI ], aLote[ nCntFor, LTCDRDES ], aLote[ nCntFor, LTCLIDEV ], aLote[ nCntFor, LTLOJDEV ],nCntFor })
		If ValType(cCdrDes) # "C" .Or. Empty(cCdrDes)
			cCdrDes  := aLote[ nCntFor, LTCDRPER ]
		EndIf
	EndIf
	cCdrCal	:= cCdrDes
	cCondPag:= aLote[nCntFor,LT1oCPAG]
	nNfCTRC	:= aLote[nCntFor,LT1oNFCT]
	nPesCTR	:= aLote[nCntFor,LT1oPESC]
	cTpFrete:= 'C'
	cNContr	:= aLote[nCntFor,LT1oNCON]
	cDevFre	:= StrZero(1,Len(DTC->DTC_DEVFRE))
	cAgrNfc	:= aLote[nCntFor,LT1oAGRN]
Else
	cTipFre  := aLote[nCntFor,LTTIPFRE]
	cCliente := aLote[nCntFor,LTCLIDEV]
	cLoja    := aLote[nCntFor,LTLOJDEV]
	cCliDev  := aLote[nCntFor,LTCLIDEV]
	cLojDev  := aLote[nCntFor,LTLOJDEV]
	cCliCal  := aLote[nCntFor,LTCLICAL]
	cLojCal  := aLote[nCntFor,LTLOJCAL]
	cCdrOri  := Iif(TMSSegPerc(aLote[ nCntFor, LTSERVIC ]),aLote[nCntFor,LTCDRPER],aLote[nCntFor,LTCDRORI])
	//-- Retorna o percurso para calculo.
	If lTM200PER
		cCdrOri := ExecBlock("TM200PER",.F.,.F.,{ .F., aLote[ nCntFor, LTCDRORI ], aLote[ nCntFor, LTCDRDES ], aLote[ nCntFor, LTCLIDEV ], aLote[ nCntFor, LTLOJDEV ],nCntFor })
		If ValType(cCdrOri) # "C" .Or. Empty(cCdrOri)
			cCdrOri  := Iif(TMSSegPerc(aLote[ nCntFor, LTSERVIC ]),aLote[nCntFor,LTCDRPER],aLote[nCntFor,LTCDRORI])
		EndIf
	EndIf
	cCdrDes  := aLote[nCntFor,LTCDRDES]
	cCdrCal  := aLote[nCntFor,LTCDRCAL]
	cCondPag := aLote[nCntFor,LTCPAGPV]
	nNfCTRC  := aLote[nCntFor,LTNFCTRC]
	nPesCTR  := aLote[nCntFor,LTPESCTR]
	cTpFrete := Iif(aLote[ nCntFor, LTTIPFRE ]=='1','C',Iif(aLote[ nCntFor, LTTIPFRE ]=='2','F',aLote[ nCntFor, LTTIPFRE ]))
	cNContr  := aLote[nCntFor,LTNCONTR]
	cDevFre  := aLote[nCntFor,LTDEVFRE]
	cAgrNfc  := aLote[nCntFor,LTAGRNFC]
EndIf

cServic  := aLote[nCntFor,LTSERVIC]
cCliAgr  := aLote[nCntFor,LTCLIREM]
cLojAgr  := aLote[nCntFor,LTLOJREM]
cCliDes  := aLote[nCntFor,LTCLIDES]
cSqEDes  := aLote[nCntFor,LTSQEDES]
cLojDes  := aLote[nCntFor,LTLOJDES]
cNumCot  := aLote[nCntFor,LTNUMCOT]
cFilSol  := aLote[nCntFor,LTFILCFS]
cNumSol  := aLote[nCntFor,LTNUMSOL]
cTipNfc  := aLote[nCntFor,LTTIPNFC]
cSeqIns  := aLote[nCntFor,LTSEQINS]
cFilDpc  := aLote[nCntFor,LTFILDPC]
cCtrDpc  := aLote[nCntFor,LTCTRDPC]
nMoeda   := aLote[nCntFor,LTMOEDA]
cSeqInsD := aLote[nCntFor,LTSEQINSD]
cRecISS  := aLote[nCntFor,LTRECISS]
cCliDpc  := aLote[nCntFor,LTCLIDPC]
cLojDpc  := aLote[nCntFor,LTLOJDPC]
cQBRCALC := aLote[nCntFor,LTQBRCALC]
cQBRDIVG := aLote[nCntFor,LTQBRDIVG]
cDATAGD  := aLote[nCntFor,LTDATAGD]
cCliExp  := aLote[nCntFor,LTCLIEXP]
cLojExp  := aLote[nCntFor,LTLOJEXP]
cCodNeg  := aLote[nCntFor,LTCODNEG]
cCliRec  := aLote[nCntFor,LTCLIREC]
cLojRec  := aLote[nCntFor,LTLOJREC]
lFretInf := aLote[nCntFor,LTFREINF] //--Tem Frete Informado = .T.
cRetira  := aLote[nCntFor,LTRETIRA]

If nMoeda == 0
	nMoeda := 1
EndIf

//-- Se o preco for por produto, o produto sera o que estiver no aLote posicionado; Caso contrario,
//-- sera o da NF, pois qdo. o parametro MV_PRCPROD estiver .F. a quebra do aLote nao sera por produto
//-- e o produto do alote nem sempre sera o posicionado (Ex: Varias NF com o mesmo no. e produtos diferentes)
If lPrcProd
	cCodPro := aLote[nCntFor,LTCODPRO]
EndIf

//-- A T E N C A O   Mantenha a chave abaixo conforme a acao 5 da funcao tmsa200lot
//-- Cliente
If IsInCallStack("TMSA310GRV")
    nSeek := Ascan(aDocto,{|x|x[26]+x[27]+x[28]+x[12]+x[1]+x[2]+x[3]+x[4]+x[5]+x[15]+x[6]+x[7]+x[8]+x[17]+x[16]+x[19]+x[24]+x[25]+x[22]+x[23]+x[29]+x[30]+x[14]+x[11]==cQBRCALC+ cDATAGD +cQBRDIVG+cTipNfc+cServic+cCliAgr+cLojAgr+cCliDes+cLojDes+cSqEDes+cCliDev+cLojDev+cNumCot+cFilDpc+cSeqIns+cSeqInsD+cCdrOri+cCdrCal+cCliDpc+cLojDpc+cCliExp+cLojExp+cFilSol+cNumSol})
Else
    nSeek := Ascan(aDocto,{|x|x[26]+x[27]+x[28]+x[12]+x[1]+x[2]+x[3]+x[4]+x[5]+x[15]+x[6]+x[7]+x[8]+x[17]+x[16]+x[19]+x[24]+x[25]+x[22]+x[23]+x[29]+x[30]==cQBRCALC+ cDATAGD +cQBRDIVG+cTipNfc+cServic+cCliAgr+cLojAgr+cCliDes+cLojDes+cSqEDes+cCliDev+cLojDev+cNumCot+cFilDpc+cSeqIns+cSeqInsD+cCdrOri+cCdrCal+cCliDpc+cLojDpc+cCliExp+cLojExp})
EndIf

If Empty(nSeek)

	AAdd(aDocto,{	cServic,;	// 01
					cCliAgr,;	// 02
					cLojAgr,;	// 03
					cCliDes,;	// 04
					cLojDes,;	// 05
					cCliDev,;	// 06
					cLojDev,;	// 07
					cNumCot,;	// 08
					{},;		// 09
					{},;		// 10
					cNumSol,;	// 11
					cTipNfc,;	// 12
					cSequen,;	// 13
					cFilSol,;	// 14
					cSqEDes,;	// 15
					cSeqIns,;	// 16
					cFilDpc,;	// 17
					cCtrDpc,;	// 18
					cSeqInsD,;	// 19
					aLote[nCntFor,LTIPLOT],;	// 20
					cRecISS,;	// 21
					cCliDpc,;	// 22
					cLojDpc,;	// 23
					cCdrOri,;	// 24
					cCdrCal,;	// 25
					cQBRCALC,;	// 26
					cDATAGD,;	// 27
					cQBRDIVG,;	// 28
					aLote[nCntFor,LTCLIEXP],; // 29
					aLote[nCntFor,LTLOJEXP],; // 30
					cCodNeg,; // 31
					Iif(Len(aNfCTRC) >= 1 .And. Len(aNfCTRC[1]) >= 46, aNfCTRC[1,46], ""),; // 32
					cCliRec,;   // 33- Codigo Recebedor
					cLojRec,;   // 34- Loja   Recebedor
					lFretInf,;   //35- Frete Informado? .T. = SIM
					cRetira })  // 36- Retira

	nSeek := Len(aDocto)
	//-- Parametros
	AAdd(aDocto[nSeek,10],nNfCTRC)						//-- 01
	AAdd(aDocto[nSeek,10],nPesCTR)						//-- 02
	AAdd(aDocto[nSeek,10],aLote[nCntFor,LTDOCTMS])		//-- 03
	AAdd(aDocto[nSeek,10],cTipFre)						//-- 04
	AAdd(aDocto[nSeek,10],cCliente)						//-- 05
	AAdd(aDocto[nSeek,10],cLoja)						//-- 06
	AAdd(aDocto[nSeek,10],cCdrDes)						//-- 07
	AAdd(aDocto[nSeek,10],cCondPag)						//-- 08
	AAdd(aDocto[nSeek,10],cTpFrete)						//-- 09
	AAdd(aDocto[nSeek,10],aLote[nCntFor,LTPRDIMP])		//-- 10 Produto de imposto
	AAdd(aDocto[nSeek,10],aLote[nCntFor,LTUNIMED])		//-- 11 Unidade de medida do produto de imposto
	AAdd(aDocto[nSeek,10],aLote[nCntFor,LTSEGUM ])		//-- 12
	AAdd(aDocto[nSeek,10],aLote[nCntFor,LTLOCPAD])		//-- 13
	AAdd(aDocto[nSeek,10],aLote[nCntFor,LTDSCPRO])		//-- 14
	AAdd(aDocto[nSeek,10],AClone(aTmsA500))			//-- 15 Parametros passados qd executado do TmsA500
	AAdd(aDocto[nSeek,10],cLotNfc)						//-- 16
	AAdd(aDocto[nSeek,10],aLote[nCntFor,LTSERDOC])		//-- 17
	AAdd(aDocto[nSeek,10],aLote[nCntFor,LTCLIREM])		//-- 18
	AAdd(aDocto[nSeek,10],aLote[nCntFor,LTLOJREM])		//-- 19
	AAdd(aDocto[nSeek,10],l1oPerc)						//-- 20
	AAdd(aDocto[nSeek,10],aLote[nCntFor,LTSERTMS])		//-- 21 Tipo de servico
	AAdd(aDocto[nSeek,10],aLote[nCntFor,LTTIPTRA])		//-- 22 Tipo de transporte
	AAdd(aDocto[nSeek,10],cCdrOri)						//-- 23
	AAdd(aDocto[nSeek,10],aLote[nCntFor,LTCLICON])		//-- 24
	AAdd(aDocto[nSeek,10],aLote[nCntFor,LTLOJCON])		//-- 25
	AAdd(aDocto[nSeek,10],aLote[nCntFor,LTCLIDPC])		//-- 26
	AAdd(aDocto[nSeek,10],aLote[nCntFor,LTLOJDPC])		//-- 27
	AAdd(aDocto[nSeek,10],cTabFre)						//-- 28
	AAdd(aDocto[nSeek,10],cTipTab)						//-- 29
	AAdd(aDocto[nSeek,10],cSeqTab)						//-- 30
	AAdd(aDocto[nSeek,10],cCdrCal)						//-- 31
	AAdd(aDocto[nSeek,10],cNContr)						//-- 32
	AAdd(aDocto[nSeek,10],cDevFre)						//-- 33
	AAdd(aDocto[nSeek,10],cCliCal)						//-- 34
	AAdd(aDocto[nSeek,10],cLojCal)						//-- 35
	AAdd(aDocto[nSeek,10],nPesoCob)						//-- 36 Peso cobrado
	AAdd(aDocto[nSeek,10],aLote[nCntFor,LTFILDPC])		//-- 37 Filial de Alianca (2o. Percurso)
	AAdd(aDocto[nSeek,10],aLote[nCntFor,LTCTRDPC])		//-- 38 CTRC Despachante
	AAdd(aDocto[nSeek,10],cAgrNfc)						//-- 39 Considera ou nao as quebras por numero de notas fiscais por CTRC e peso maximo por CTRC
	AAdd(aDocto[nSeek,10],AClone(aTipVei))				//-- 40 Tipo do Veiculo
	AAdd(aDocto[nSeek,10],AClone(aValInf))				//-- 41 Valor Informado
	AAdd(aDocto[nSeek,10],aLote[nCntFor,LTVALDPC])		//-- 42 Valor CTRC Despachante
	AAdd(aDocto[nSeek,10],AClone(aPesCub))				//-- 43 Altura/Largura/Comprimento
	AAdd(aDocto[nSeek,10],nMoeda)						//-- 44 Moeda
EndIf
//-- Produto
//-- Acrescentada a ultima posicao neste vetor para utilizacao na regra de tributacao
//-- A clientes que possuem regra de tributacao por produto como o cCodpro esta vazio nao acha a regra
//-- Entao foi passado a ultima posicao independente da regra o codigo do produto
AAdd(aDocto[nSeek,9],{cCodPro,AClone(aFrete),{},nQtdVol,nValor,nPeso,nPesoM3,nMetro3,nSeguro,nQtdUni,'','',nPesLiq,aLote[nCntFor,LTCODPRO], nKMNF,nPesoCol, nPesoCob})

nSeek1 := Len(aDocto[nSeek,9])
//-- Nota fiscal do cliente
For nCnt1 := 1 To Len(aNfCTRC)
	nSeek2:=ASCan(aDocto[nSeek,9,nSeek1,3],{|x|x[1]+x[2]==aNfCTRC[nCnt1,1]+aNfCTRC[nCnt1,2]})
	If Empty(nSeek2)
		aDocto[nSeek,9,nSeek1,11] := aNfCTRC[nCnt1,1]
		aDocto[nSeek,9,nSeek1,12] := aNfCTRC[nCnt1,2]
		AAdd(aDocto[nSeek,9,nSeek1,3],{aNfCTRC[nCnt1,1],aNfCTRC[nCnt1,2]})
	EndIf
Next

Return( Nil )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200Grv≥ Autor ≥ Alex Egydio           ≥ Data ≥06.02.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Dispara rotina de geracao de pedidos e documentos          ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA200Grv()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥                                                            ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TmsA200Grv(aVisErr, lRecalculo, aNfs, lRefatur, lCalImp, nPerImp, nTipImp, aNumDoc, aICMSol, aTeste, lCTeUnico, aRatTda, lTabAlt,lblq)

Static __aPrdImp	:= {}
Static __aTaxa		:= {}
Static __aEstOri	:= {}
Static __aEstCal	:= {}
Static __nVendTms	:= 0
Static __cBarra		:= ""
Static __cStartPath	:= ""

Local aPrm200THR	:= {}
Local nRet			:= 0
Local aTmCalFr		:= {}
Local aFrete		:= {}
Local aLinha		:= {}
Local aNfCTRC		:= {}
Local aContrt		:= {}
Local aPerfil		:= {}
Local aAuxPerfil	:= {}
Local aProduto		:= {}
Local aRegra		:= {}
Local aTmsA200		:= {}
Local aTmsA500		:= {}
Local cCdrDes		:= ''
Local cCliente		:= ''
Local cLoja			:= ''
Local cCliDes		:= ''
Local cLojDes		:= ''
Local cCliDev		:= ''
Local cLojDev		:= ''
Local cCodPro		:= Space(Len(SB1->B1_COD))
Local cNextPro		:= ''
Local cCondPag		:= ''
Local cDscPro		:= ''
Local cDocTms		:= ''
Local cLocPad		:= ''
Local cNumCot		:= ''
Local cNumNfc		:= ''
Local cNumPed		:= ''
Local cPrdImp		:= ''
Local cSerNfc		:= ''
Local cServic		:= ''
Local cTaxCtr		:= ''
Local cTes			:= ''
Local cTipFre		:= ''
Local cTipoFrt		:= ''
Local cTpFrete		:= ''
Local cUniMed		:= ''
Local cSegUm		:= ''
Local lAddNfc		:= .T.
Local lRet			:= .T.
Local lTaxa			:= .F.
Local lUltimo		:= .F.
Local lRegPorComp	:= .T.
Local n1Cnt			:= 0
Local n2Cnt			:= 0
Local n3Cnt			:= 0
Local nCntFor		:= 0
Local nNfCTRC		:= 0
Local nPesCTR		:= 0
Local nQtdVol		:= 0
Local nValor		:= 0
Local nPeso			:= 0
Local nPesoP 		:= 0
Local nPesoM3		:= 0
Local nMetro3		:= 0
Local nSeguro		:= 0
Local nQtdUni		:= 0
Local nSeek			:= 0
Local cEstOri		:= ''
Local cEstDes		:= ''
Local cCdrOri		:= ''
Local cBlTms		:= ''
Local cTipoPrd		:= ""
Local nPos			:= 0
Local nQuant		:= 0
Local cIncISS		:= Iif(SuperGetMv("MV_INCISS",,.T.),"S","N") //-- TES Incide ISS (S/N)
Local cMVALIQISS	:= SuperGetMv("MV_ALIQISS",,0)
Local nPerISS		:= cMVALIQISS
Local cMVTMSRRE		:= SuperGetMv("MV_TMSRRE" ,.F.,"")
Local cF4_ISS		:= ""
Local nPrcVen		:= 0
Local cSerPed		:= Nil
Local cLotNfc		:= ""
Local cTipTra		:= ""
Local aValInf		:= {}
Local nValFre		:= 0
Local nProcReg		:= 0
Local cCliCon		:= ''
Local cLojCon		:= ''
Local cCliRem		:= ''
Local cLojRem		:= ''
Local cCliCal		:= ''
Local cLojCal		:= ''
Local cTipNFC		:= ''
Local lConsig		:= .F. //-- Verifica se o devedor eh o consignatario.
Local nAliqISS		:= 0
Local cA1_INCISS	:= ''
Local cEstDev		:= ''
Local cTipoNF		:= ''
Local cNfOri		:= ''
Local cSeriOri		:= ''
Local cEstRem		:= ''
Local cTesEsp		:= ''
Local cFilSol		:= ''
Local cNumSol		:= ''
Local cCdrCal		:= ''
Local lCalcISS		:= .F.
Local cEstCal		:= ''
Local cCodISS		:= ''
Local cVendSA1		:= ''
Local aVendDw3		:= {}
Local cSeqIns		:= ''
Local cTipoCli		:= ''
Local nCntPro		:= 0
Local nPesLiq		:= 0
Local nPesoCob		:= 0
Local cDocFat		:= ''
Local bFatSE1		:= {|| }
Local cTabFre		:= ''
Local cTipTab		:= ''
Local cCodProIT		:= Space(Len(SB1->B1_COD))
Local cRecISS		:= ''
Local nPerPE		:= 0
Local nCont1		:= 0
Local nQtdDif		:= 0
Local nQtdRst		:= 0
Local lTMSINTER		:= ( Left(FunName(),7) == "TMSAI70" ) //Rodoviario Internacional
Local lIdentDoc  	:= DTC->(ColumnPos("DTC_DOCTMS")) > 0
//-- Parametro do Ct-e.
Local cTipLot		:= ''
Local nAlqICM

// variaveis do processamento com multiplas threads
Local nQtdMnt		:= 0 // Quantidade de Threads processadas pelo Monitoramento
Local nQtdDef		:= 0 // Quantidade de CTe gerados por Thread
Local lFim1			:= .F.
Local lFim2			:= .F.
Local cJobFile		:= ""
Local cJobThr		:= ""
Local cCodUser		:= __cUserID
Local lRateio      := .F.
Local aRateio      := {}
Local aCompFrt     := {}
Local nCount       := 0
Local nTOTKM       := 0
Local aMsgErr      := {}
Local cAliasQry    := ""
Local cQuery       := ""
Local lRatTDA      := .F.
Local cSeqTab      := ""
Local aVetItmRRE   := {}
Local aVetBlq      := {}
Local aVetBlqRRE   := {}
Local aVetMsgRRE   := {}
Local aVetBlqDVP   := {}
Local aVetMsgDVP   := {}
Local cMotBlqRRE   := ""
Local cMotBlqDVP   := ""
Local lDP          := .f.
Local aPrdDP       := {}
Local aPrdDPDet    := {}
Local nX           := 0
Local lCamposRat   := DTP->(ColumnPos("DTP_RATEIO")) > 0
Local nCntCte      := 0
Local aPerFix      := {}
Local nPerFix      := 0
Local nPosFix      := 0
Local nPesCol      := 0
Local nPesRea      := 0
Local aItRat       := {}
Local cArqCol      := ""
Local nPesDUM      := 0
Local nPesDUA      := 0
Local nPesDTC      := 0
Local aVetPes      := {}
Local cStReg       := ""
Local lPreview     := Tmsa200Gpv() //-- Preview Do C·lculo Do Frete
Local aPreview     := {}
Local lContinua    := .t.
Local aPEPvw       := {}
Local nMark        := 0
Local nNfsl        := 0
Local cLotEst      := ""
Local cAliasDVR    := ""
Local cAliasDVU    := ""
Local cCliGenDUO   := SuperGetMV('MV_CLIGEN')

Local aValInfAc  := {}
Local nAdiDoc    := 0
Local nCntFor1   := 0
Local nValFrePrd := 0
Local nValFreFre := 0
Local nValFreDoc := 0
Local lCbrCol    := .T.
Local lBlqCol    := .F.
Local cSerTms    := ""
//-- Vari·veis Threads
Local nThreads		:= SuperGetMv("MV_TMSTHRC", , 0) // Numero de threads para processamento simultaneos
Local nAuxThr	 	:= 0
Local nCountThr		:= 0
Local aJobThr		:= {} // Vetor contendo informacoes das Threads.
Local lThread		:= .F.
Local cSemaforo		:= AllTrim( Str( ThreadID() ) )
Local aStruct		:= {}
Local nIpcCount		:= 0
Local cTabSQLite	:= ""
Local aObs			:= {}
Local lProcThread	:= .F.
Local nAux			:= 0
Local aAreaDTC      := {}

Default lRecalculo := .F.
Default lRefatur   := .F.
Default aNfs       := {}
Default lCalImp    := .T.
Default nPerImp    := 0
Default nTipImp    := 0
Default aNumDoc    := {}
Default aICMSol    := {}
Default aTeste     := {}
Default lCTeUnico  := .F.
Default aRatTda    := {}
Default lTabAlt    := .F.
Default lblq       := .F.

lValCol   := DTP->DTP_TIPLOT == StrZero(5,Len(DTP->DTP_TIPLOT))

If lCamposRat
	lRateio	:= TMSLRateio( DTP->DTP_FILORI, DTP->DTP_LOTNFC )
EndIf

If	Type("nNumCTRC") == "U"
	Private nNumCTRC := 0
EndIf
If	Type("aPedBlq") == "U"
	Private aPedBlq := {}
EndIf
If	Type("lImpDoc") == "U"
	Private lImpDoc := IsInCallStack("TMSIMPDOC")
EndIf

If Len(aTeste) > 0
	aDocto := aTeste
EndIf
If Len(aDocto) == 0
	Return( lRet )
EndIf

If	cMv_Estado == ""
	cMv_Estado := SuperGetMV("MV_ESTADO",.F.,"")//O tratamento especÌfico abaixo para o estado do Parana foi retirado de acordo com conformidade do art. 11, II e IV da LC n∫ 87/96.
EndIf

If lTM200THR
	nThreads := ExecBlock("TM200THR",.F.,.F.,{nThreads})
	If ValType(nThreads) # "N"
		nThreads := SuperGetMv("MV_TMSTHRC", , 0)
	EndIf
EndIf

//Esse Bloco de Codigo devera ser retirado devido ao problema que foi identificado quando a execucar da Thread e chamado do TMSEXPRESS
If  TmsExp() .And. Substr(FunName(),1,7) == "TMSA144"
	lThread := .F.
Else
	nAux	:= Len(aLote)
	lThread := (nThreads > 0) .And. nAux > 9

	If lThread .And. nAux > 9

		nAux	:= Round( (nAux / 9) , 0 )

		If nAux == 1
			nAux :=	2
		EndIf

		If nThreads > nAux
			nThreads	:= nAux
		EndIf
	EndIf

EndIf
//---------------------------------------
If	lThread .And. Empty(__cStartPath)
	__cBarra     := If(IsSrvUnix(), "/", "\")
	__cStartPath := __cStartPath := GetSrvProfString("StartPath","") + If(Right(GetSrvProfString("StartPath",""),1) == __cBarra,"",__cBarra)
	If	SubStr(__cStartPath, Len(__cStartPath), 1 ) != '\' .And. SubStr(__cStartPath, Len(__cStartPath), 1 ) != '/'
		__cStartPath := __cStartPath + '\'
	EndIf
EndIf

//-- Calcula quantidade de CTe que ser„o gerados por Thread
If	lThread
	lProcThread	:= .T.
	//--------------------------------------------------------------------------------
	//-- Tabela de logs - SQLLITE - APENAS PROTHEUS 12
	//--------------------------------------------------------------------------------
	aAdd(aStruct,{"CLIENTE"	,	"C", TamSX3("A1_COD")[1]		, 00})
	aAdd(aStruct,{"LOJA"	,	"C", TamSX3("A1_LOJA")[1]		, 00})
	aAdd(aStruct,{"MEMO"	,	"M", 50							, 00})

	cJobFile 	:= CriaTrab(Nil,.F.)
	cTabSQLite	:= "LOGTMS" + cSemaforo

	DBCreate( cJobFile , aStruct, 'SQLITE_SYS' )

	// Coloca a tabela cJobFile em uso
	DBUseArea( .T., 'SQLITE_SYS', cJobFile , cTabSQLite  , .F., .F. )

	//-----------------------------------------------------------------
	//-- Sobe Threads
	//-----------------------------------------------------------------
	For nAuxThr := 1 To nThreads

		cJobThr		:= "cThr" + cSemaforo + cValToChar(nAuxThr)

		StartJob("TMSA200THE", GetEnvServer() , .F. , cSemaforo , cEmpAnt , cFilAnt ,  cJobThr , cJobFile , cLotePosic )

		//-----------------------------------------------------------------
		//-- Array contendo o nome da thread
		//-----------------------------------------------------------------
		aAdd(aJobThr, { cJobThr, cJobFile, .T., .F., "", TIME(), TIME(), "", "", {} } )


	Next nAuxThr

EndIf

//-- Filial de Negociacao Cliente
If	__nVendTms == 0
	__nVendTms ++
	For nPos := 1 To 35
		If	FieldPos("DW3_VEND" + Str(nPos,1) ) > 0 .And. ;
			FieldPos("C5_VEND"  + Str(nPos,1) ) > 0 .And. ;
			FieldPos("F2_VEND"  + Str(nPos,1) ) > 0
			__nVendTms ++
		Else
			Exit
		EndIf
	Next nPos
	nPos := 0
EndIf

If lTM200SEQ
	aSort( aDocto,,,{ |x,y| x[13] < y[13] } )
EndIf

nProcReg := Len(aDocto)
ProcRegua( nProcReg )

For nCntFor := 1 To Len(aDocto)

	IncProc()
	lFim1 := nCntFor == nProcReg
	//-- Ordena por NF+Serie+Produto, para que nao ocorra problemas de quebra .. NAO RETIRAR !!!!
	aSort(aDocto[nCntFor][9],,, { |x,y| x[11]+x[12]+x[1] < y[11]+y[12]+y[1]})

	cServic  := aDocto[nCntFor,1]
	cCodNeg  := aDocto[nCntFor,31]
	cCliDes  := aDocto[nCntFor,4]
	cLojDes  := aDocto[nCntFor,5]
	cSqEDes  := aDocto[nCntFor,15]
	cCliDev  := aDocto[nCntFor,6]
	cLojDev  := aDocto[nCntFor,7]
	cNumCot  := aDocto[nCntFor,8]
	cFilSol  := aDocto[nCntFor,14]
	cTipNFC  := aDocto[nCntFor,12]
	nNfCTRC  := aDocto[nCntFor,10,1]
	nPesCTR  := aDocto[nCntFor,10,2]
	cTipFre  := aDocto[nCntFor,10,4]
	cCdrDes  := aDocto[nCntFor,10,7]
	cLotNfc  := aDocto[nCntFor,10,16]
	cCliRem  := aDocto[nCntFor,10,18]
	cLojRem  := aDocto[nCntFor,10,19]
	cTipTra  := aDocto[nCntFor,10,22]
	cCdrOri  := aDocto[nCntFor,10,23]
	cCliCon  := aDocto[nCntFor,10,24]
	cLojCon  := aDocto[nCntFor,10,25]
	cTabFre  := aDocto[nCntFor,10,28]
	cTipTab  := aDocto[nCntFor,10,29]
	cCdrCal  := aDocto[nCntFor,10,31]
	cCliCal  := aDocto[nCntFor,10,34]
	cLojCal  := aDocto[nCntFor,10,35]
	lConsig  := .F.
	aTmsA500 := AClone(aDocto[nCntFor,10,15])
	aValInf  := AClone(aDocto[nCntFor,10,41])
	//-- Acumula o valor informado dos documentos
	For nCntFor1 := 1 To Len(aValInf)
		Aadd(aValInfAc,Aclone(aValInf[nCntFor1]))
	Next nCntFor1

	//-- Armazena o estado da origem do documento.
	If (nPos := Ascan(__aEstOri, { |x| x[1] == cCdrOri })) == 0
		//cEstOri := Posicione("DUY",1,xFilial("DUY")+cCdrOri,"DUY_EST")
		TMSA200CdRg(cCdrOri)   //Posiciona no grupo de Regiao
		cEstOri := DUY->DUY_EST
		AAdd( __aEstOri, { cCdrOri, cEstOri } )
	Else
		cEstOri := __aEstOri[nPos,2]
	EndIf

	//-- Armazena o estado de calculo do documento.
	If (nPos := Ascan(__aEstCal, { |x| x[1] == cCdrCal })) == 0
		//cEstCal := Posicione("DUY",1,xFilial("DUY")+cCdrCal,"DUY_EST")
		TMSA200CdRg(cCdrCal)   //Posiciona no grupo de Regiao
		cEstCal := DUY->DUY_EST
		AAdd( __aEstCal, { cCdrCal, cEstCal } )
	Else
		cEstCal := __aEstCal[nPos,2]
	EndIf

	//-- Verifica se o devedor eh o consignatario e nao eh remetente ou destinatario.
	If	cCliRem+cLojRem <> cCliCon+cLojcon .And. ;
			cCliDes+cLojDes <> cCliCon+cLojcon .And. ;
			cCliDev+cLojDev == cCliCon+cLojcon
		lConsig := .T.
	EndIf

	//-- Verifica se foi informada a aliquota do ISS para regiao
	//nAliqISS := Posicione("DUY",1,xFilial("DUY")+cCdrCal,"DUY_ALQISS")
	TMSA200CdRg(cCdrCal)   //Posiciona no grupo de Regiao
	nAliqISS := DUY->DUY_ALQISS
	If	nAliqISS == 0
		nPerISS := cMVALIQISS //-- Aliquota do ISS
	Else
		nPerISS := nAliqISS
	EndIf
	If lTM200ISS
		nPerPE:= ExecBlock("TM200ISS",.F.,.F.,{cServic,cTipTra,cLotNfc,cCliCal,cLojCal,cCliRem,cLojRem,cCliDes,cLojDes,cCodNeg})
		If ValType(nPerPE) == "N"
			nPerISS := nPerPE
		EndIf
	EndIf

	//-- Obtem o perfil do cliente ou cliente generico
	aPerfil := TmsPerfil(cCliCal,cLojCal,,,cCliRem,cLojRem,cCliDes,cLojDes)
	aAuxPerfil	:= aClone(aPerfil)
	cTipoFrt := cTipFre

	//-- A entrada de nota fiscal do cliente sera '0 Normal' ou '1 Devolucao Parcial' conforme o campo DTC_TIPNFC
	If	aDocto[ nCntFor, 12 ] == StrZero(1,Len(DTC->DTC_TIPNFC))
		If	cTipFre == StrZero(1,Len(cTipFre))
			cTipFre := StrZero(2,Len(cTipFre))
		Else
			cTipFre := StrZero(1,Len(cTipFre))
		EndIf
	EndIf
	aContrt := TMSContrat( cCliCal, cLojCal,, cServic, .F., cTipFre,,, cCliRem, cLojRem, cCliDes, cLojDes,, cCliDev, cLojDev, cTipNFC,,,,,, cCodNeg, cCont340 )
	cTaxCtr := Iif( Len(aContrt) > 0, aContrt[1][23], '' )

	///////////////////////////////////////////////////////////////////////////////////////////////////
	//-------------------------------------------------------------------------------------------------
	//-- Tratamento RRE Para Bloqueio De Lotes (Inicio)
	//-------------------------------------------------------------------------------------------------
	///////////////////////////////////////////////////////////////////////////////////////////////////
	cMotBlqRRE := ""
	cMotBlqDVP := ""
	aVetMsgRRE := {}
	aVetMsgDVP := {}
	If Empty(cMV_TMSRRE)
		cMV_TMSRRE   := cMVTMSRRE // 1=Calculo Frete, 2=CotaÁ„o, 3=Viagem, 4=Sol. Coleta, Em Branco= Nao Utiliza
	EndIf

	// Verifica Se Divergencia De Produtos Esta Ativa
	If FindFunction("Tmsa029Use")
		Tmsa029Use("TMSA200",@lDP)
	EndIf

	aVetItmRRE := {}
	If "1" $ cMV_TMSRRE .Or. lDP //-- 1=Calculo Frete, 2=CotaÁ„o, 3=Viagem, 4=Sol.Coleta, Em Branco= Nao Utiliza

		For n1Cnt := 1 To Len(aDocto[nCntFor,9])

			//--- aDocto[nCntFor,9,n1Cnt,14] - Quando o parametro lPrcProd est· Falso, a posiÁ„o 1 vem vazio.
			cCodPro   := aDocto[nCntFor,9,n1Cnt,14] //-- Era aDocto[nCntFor,9,n1Cnt,01]
			cNextPro  := IIf(n1Cnt < Len(aDocto[nCntFor,9]), aDocto[nCntFor,9,n1Cnt+1,1], aDocto[nCntFor,9,n1Cnt,14])
			lUltimo   := (n1Cnt == Len(aDocto[nCntFor,9]))		//-- Ultimo documento que sera gerado
			nValor    += aDocto[nCntFor,9,n1Cnt,5]
			nPeso     += aDocto[nCntFor,9,n1Cnt,6]

			//-- Notas fiscais do cliente
			For n2Cnt := 1 To Len(aDocto[nCntFor,9,n1Cnt,3])
				cNumNfc	:= aDocto[nCntFor,9,n1Cnt,3,n2Cnt,1]
				cSerNfc	:= aDocto[nCntFor,9,n1Cnt,3,n2Cnt,2]
				lAddNfc	:= .T.
				//-- Adiciona a nota fiscal do cliente apenas 1 vez no vetor aNfCTRC
				If	n1Cnt+1 <= Len(aDocto[nCntFor,9])
					For n3Cnt := n1Cnt+1 To Len(aDocto[nCntFor,9])
						If AScan(aDocto[nCntFor,9,n3Cnt,3],{|x|x[1]+x[2]==cNumNfc+cSerNfc})>0
							lAddNfc := .F.
							Exit
						EndIf
					Next
				EndIf
				If lAddNfc
					AAdd(aNfCTRC,{cNumNfc,cSerNfc})
				EndIf
			Next
			
			aAreaDTC := GetArea("DTC")
			//-- Determina Produtos (Todos) Para Tratamento RRE e Incomp. Produtos
			For n2Cnt := 1 To Len(aNfCTRC)

				//-- Posiciona Nos Documentos Do Cliente
				DbSelectArea("DTC")
				DbSetOrder(2) //-- DTC_FILIAL+DTC_NUMNFC+DTC_SERNFC+DTC_CLIREM+DTC_LOJREM+DTC_CODPRO+DTC_FILORI+DTC_LOTNFC
				MsSeek( FWxFilial("DTC") + aNfCTRC[n2Cnt,01] + aNfCTRC[n2Cnt,02] + cCliRem + cLojRem , .f. )

				While !DTC->(Eof()) .And. ( DTC->(DTC_FILIAL+DTC_NUMNFC+DTC_SERNFC+DTC_CLIREM+DTC_LOJREM) == FWxFilial("DTC") + aNfCTRC[n2Cnt,01] + aNfCTRC[n2Cnt,02] + cCliRem + cLojRem )

					//-- Incrementa Vetor De Detalhes Produtos X Nfs Clientes
					If aScan( aPrdDPDet , {|x| x[1]+x[2]+x[3] ==  DTC->DTC_CODPRO+DTC->DTC_NUMNFC+DTC->DTC_SERNFC  } ) == 0
						aAdd( aPrdDPDet , { DTC->DTC_CODPRO, DTC->DTC_NUMNFC, DTC->DTC_SERNFC })
					EndIf

					If aScan( aPrdDP , DTC->DTC_CODPRO ) == 0
						aAdd( aPrdDP    , DTC->DTC_CODPRO )
					EndIf

					aAdd(aVetItmRRE,{;
										cCliDev,;									//-- 01- ITM - Cliente
										cLojDev,;									//-- 02- ITM - Loja
										DTC->DTC_CODPRO,;							//-- 03- ITM - Produto
										DTC->DTC_QTDVOL,;							//-- 04- ITM - Qtde Volume
										DTC->DTC_PESO,;							//-- 05- ITM - Peso
										DTC->DTC_PESOM3,;							//-- 06- ITM - Peso Cubado
										DTC->DTC_VALOR,;							//-- 07- ITM - Valor Mercadoria
										'',;										//-- 08- Codigo RRE
										0 ,;										//-- 09- TOT - Valor Tot. Ctr
										{DTC->DTC_NUMNFC, DTC->DTC_SERNFC}  })	//-- 10- Vetor Contendo As NFs Que Compıe o Produto No CTR

					DTC->(DbSkip())
				EndDo

			Next n2Cnt			
			RestArea(aAreaDTC)
			
			//-- Analisar a quebra e gerar o documento
			If	TmsA200Qb1( aDocto[nCntFor,9], aDocto[nCntFor,10,39], aDocto[nCntFor,10,37], aDocto[nCntFor,10,38], Iif(cTipTra == '4',Replicate('z',Len(DT4->DT4_NUMCOT)),cNumCot), n1Cnt, Len(aNfCTRC), nPeso, nNfCTRC, nPesCTR, lUltimo, cCodPro, cNextPro, aDocto, lCTeUnico, lFim1 )

				aVetBlq    := {}

				//-- Verifica Qual Modalidade de AÁ„o Do Calculo Do RRE Ser· Utilizado
				cModRRE := ''
				If '1' $ cMV_TMSRRE //-- 1 - Calculo do frete
					If !Empty(cNumCot)
						cModRRE := '1' //-- Se Houver CotaÁ„o Bloqueia (Caso Haja RRE) Independente Do Perfil Do Cliente
					Else
						If FindFunction("TmsModInco")
							//-- Perfil Do Cliente (DEVEDOR) - '1' = Bloqueia Lote NFs, '2' = Separa Documentos
							cModRRE := TmsModInco( "RRE", cCliDev, cLojDev )

							If Empty(cModRRE) .And. !Empty(cCliGenDUO)   //Procura pelo Cliente Generico
								cModRRE := TmsModInco( "RRE", Left(Alltrim(cCliGenDUO),Len(DTC->DTC_CLIDEV)), Right(Alltrim(cCliGenDUO),Len(DTC->DTC_LOJDEV)))
							EndIf
						EndIf
					EndIf
				EndIf

				//-- Verifica Qual Modalidade de AÁ„o Do Calculo De Divergencia Ser· Utilizado
				cModDiverg := ' '
				If lDP
					If !Empty(cNumCot)
						cModDiverg := '1' //-- Se Houver CotaÁ„o Bloqueia Independente Do Perfil Do Cliente
					Else
						//-- Perfil Do Cliente - '1' = Bloqueia Lote NFs, '2' = Separa Documentos
						If FindFunction("TmsModInco")
							cModDiverg := TmsModInco( "INC", cCliDev, cLojDev )
						Else
							If DUO->(ColumnPos("DUO_INCOMP")) > 0
								cModDiverg := DUO->DUO_INCOMP //-- Se campo Existir Define Pelo Conteudo Do Campo
							Else
								cModDiverg := '2' //-- Se N„o Existir o Campo, Separa Documentos (Padr„o)
							EndIf
						EndIf
					EndIf
				EndIf
				If FindFunction ('Tmsa029Blq') .And. cModRRE == '1' .Or. cModDiverg == '1'  //-- '1' = Bloqueia Lote NFs, '2' = Separa Documentos

					nCntCte ++
					//-- Verifica Status Dos Registros De Bloqueio (RRE e Diverg Produtos)
					cStReg := Tmsa029Blq( 9  ,'TMSA200', ''  ,DTP->DTP_FILORI, 'DTP' , '1' ,DTP->(DTP_FILIAL + DTP_LOTNFC), DTP->DTP_LOTNFC , "" )

					If cStReg <> 'L' //-- Diferente De Liberado

						If cModRRE == '1'

							// Carrega PosiÁ„o 9 Do Vetor Com Valor Total Do Lote
							If Len(aVetItmRRE) > 0
								aEval(aVetItmRRE,{|x| x[9] := nValor})
							EndIf

							// Calcula As RestriÁıes De RRE Para o Ctr Calculado
							aVetBlq := TmsRetRRE(aVetItmRRE,{},{},"TMSA200",{})

							For nX := 1 To Len(aVetBlq)
								cMotBlqRRE += STR0154 +; //-- "Ordem Ctr: "
												"#" + StrZero(nCntCte,5) +;
												"#" + STR0155 +; //-- "Motivo"
												"#" + aVetBlq[nX,06] + "|"
							Next nX

							If Len(aVetBlq) > 0
								aAdd(aVetBlqRRE,{	StrZero(nCntCte,5) 	,; //-- Ordem CTR
													DTP->DTP_FILORI		,; //-- Filial Origem
													DTP->DTP_LOTNFC		,; //-- Numero Lote NF
													aClone(aVetBlq)		,; //-- Vetor Bloqueios))
													aClone(aVetItmRRE) 	}) //--

								aAdd(aVetMsgRRE, aClone(TMSA200Fmt({aVetBlqRRE[Len(aVetBlqRRE)]})))

							EndIf
						EndIf

						// Calcula Divergencia De Produtos
						If cModDiverg == '1'

							//-- Se Existir Mais De Uma Sequencia Existem Incompatibilidades
							aPrdDP  := TmsRtDvP(aPrdDP) //-- Determina Divergencias entre os Produtos Do Vetor

							If Len(aPrdDP) > 0

								For nX := 1 To Len(aPrdDP)

									DbSelectArea("SB5")
									DbSetOrder(1)
									MsSeek(xFilial("SB5") + aPrdDP[nX,01],.F.)

									DbSelectArea("DY3")
									DbSetOrder(1)
									MsSeek(xFilial("DY3") + SB5->(B5_ONU + B5_ITEM),.F.)

									cMotBlqDVP +=	( 	STR0154																		+"#"+; //-- "Ordem CTR: "
														StrZero(nCntCte,5)															+"#"+;
														STR0141 																		+"#"+; //-- "Risco"
														Alltrim(DY3->DY3_NRISCO) + "-" + DY3->DY3_ITEM							+"#"+;
														STR0021																		+"#"+; //-- "Produto: "
														aPrdDP[nX,01]																	+"#"+;
														STR0156																		+"#"+; //-- "IncompatÌveis: "
														aPrdDP[nX,2]																	+"#"+;
														STR0147																		+"#"+; //-- "NFs Relacionadas "
														Tmsa200iDP( aPrdDP[nX,01], aPrdDPDet )	+"|" )


									aAdd(aVetMsgDVP,{	StrZero(nCntCte,5),;
														STR0021 + aPrdDP[nX,01] +;	//-- "Produto: "
														STR0141 + " " + Alltrim(DY3->DY3_NRISCO) + "-" + DY3->DY3_ITEM +; //-- "Risco"
														" " + STR0156 + aPrdDP[nX,2] +; //-- "IncompatÌveis: "
														" " + STR0147 + Tmsa200iDP( aPrdDP[nX,01], aPrdDPDet ) }) //-- "NFs Relacionadas "

								Next nX
							EndIf
							aPrdDP := {}
						EndIf
					EndIf
				EndIf

				aFrete   := {}
				aNfCTRC  := {}
				aProduto := {}
				nQtdVol  := 0
				nValor   := 0
				nPeso    := 0
				nPesoM3  := 0
				aVetItmRRE := {}

			EndIf
		Next n1Cnt

		//-- Dialog Para Notificar o Bloqueio Do Lote
		If Len(aVetMsgRRE) > 0 .Or. Len(aVetMsgDVP) > 0

			// Mostra Dialog De Bloqueios De Divergencia Produtos Ou RestriÁ„o Embarque
			Tmsa200nRe(aVetMsgRRE,aVetMsgDVP)

			// Bloqueia RRE
			If Len(aVetMsgRRE) > 0

				//-- Tmsa029Blq(nOpc,cRotina  ,cTipBlq,cFilOri        ,cTab   ,cInd ,cChave                        ,cCod             ,cDetalhe , nOpcRot )
				If Tmsa029Blq( 3  ,'TMSA200', 'RR'  ,DTP->DTP_FILORI, 'DTP' , '1' ,DTP->(DTP_FILIAL + DTP_LOTNFC), DTP->DTP_LOTNFC , cMotBlqRRE,  )

					//-- Confirma Bloqueio
					RecLock("DTP",.F.)
					Replace DTP->DTP_STATUS With StrZero(4 ,Len(DTP->DTP_STATUS))
					DTP->(MsUnlock())
					lRet := .f. //-- Aborta A GeraÁ„o Dos Documentos
					lblq := .T.
				EndIf
			EndIf

			// Bloqueia Diverg Produto
			If Len(aVetMsgDVP) > 0

				//-- Tmsa029Blq(nOpc,cRotina  ,cTipBlq,cFilOri        ,cTab   ,cInd ,cChave                        ,cCod             ,cDetalhe , nOpcRot )
				If Tmsa029Blq( 3  ,'TMSA200', 'CR'  ,DTP->DTP_FILORI, 'DTP' , '1' ,DTP->(DTP_FILIAL + DTP_LOTNFC), DTP->DTP_LOTNFC , cMotBlqDVP,  )

					//-- Confirma Bloqueio
					RecLock("DTP",.F.)
					Replace DTP->DTP_STATUS With StrZero(4 ,Len(DTP->DTP_STATUS))
					DTP->(MsUnlock())
					lRet := .F. //-- Aborta A GeraÁ„o Dos Documentos
					lblq := .T.
				EndIf
			EndIf
		ElseIf cStReg <> 'L'
			//-- Caso Existam Bloqueios Antigos, Limpa Referencia
			Tmsa029Blq( 5  ,'TMSA200', ''  ,"", 'DTP' , '1' ,DTP->(DTP_FILIAL + DTP_LOTNFC), "" , "" )
		EndIf
	EndIf
	///////////////////////////////////////////////////////////////////////////////////////////////////
	//-------------------------------------------------------------------------------------------------
	//-- FIM Tratamento RRE/Diverg. Produtos Para Bloqueio De Lotes
	//-------------------------------------------------------------------------------------------------
	///////////////////////////////////////////////////////////////////////////////////////////////////

	If Empty(aVetMsgRRE) .And. Empty(aVetMsgDVP)

		//-- Produto
		For n1Cnt := 1 To Len(aDocto[nCntFor,9])
			lFim2 	:= n1Cnt == Len(aDocto[nCntFor,9])
			nValFre   := 0
			cCodPro   := aDocto[nCntFor,9,n1Cnt,1]
			cCodProIT := aDocto[nCntFor,9,n1Cnt,14]
			cNextPro  := IIf(n1Cnt < Len(aDocto[nCntFor,9]), aDocto[nCntFor,9,n1Cnt+1,1], aDocto[nCntFor,9,n1Cnt,1])
			lUltimo   := (n1Cnt == Len(aDocto[nCntFor,9]))		//-- Ultimo documento que sera gerado
			nQtdVol   += aDocto[nCntFor,9,n1Cnt,4]
			nValor    += aDocto[nCntFor,9,n1Cnt,5]
			nPeso     += aDocto[nCntFor,9,n1Cnt,6]    //Peso Documento
			nPesoP    := aDocto[nCntFor,9,n1Cnt,6]
			nPesoM3   += aDocto[nCntFor,9,n1Cnt,7]
			nMetro3   += aDocto[nCntFor,9,n1Cnt,8]
			nSeguro   += aDocto[nCntFor,9,n1Cnt,9]
			nQtdUni   += aDocto[nCntFor,9,n1Cnt,10]
			nPesLiq   += aDocto[nCntFor,9,n1Cnt,13]
			//-- Se nao agrupa notas e existe o peso cobrado por nota
			If aDocto[nCntFor,10,39] == '2' .And. !Empty(aDocto[nCntFor,9,n1Cnt,17])
				nPesoCob  := aDocto[nCntFor,9,n1Cnt,17]
			Else
				nPesoCob  := aDocto[nCntFor,10,36]
			EndIf
			nTOTKM    += aDocto[nCntFor,9,n1Cnt,15]
			nPesCol   += aDocto[nCntFor,9,n1Cnt,16]   //Peso Previsto
			nPesRea   += Iif(aDocto[nCntFor,9,n1Cnt,6]>aDocto[nCntFor,9,n1Cnt,16],Iif(aDocto[nCntFor,9,n1Cnt,6]>aDocto[nCntFor,9,n1Cnt,7],aDocto[nCntFor,9,n1Cnt,6],aDocto[nCntFor,9,n1Cnt,7]),aDocto[nCntFor,9,n1Cnt,16])   //Peso Previsto x Realizado

			//-- Composicao do frete
			//-- Aglutino a composicao de frete de cada produto no vetor a frete
			For n2Cnt := 1 To Len(aDocto[nCntFor,9,n1Cnt,2])
				//-- Somente componentes diferente de zero e diferente da linha totalizadora. TF = Total Frete
				If	aDocto[nCntFor,9,n1Cnt,2,n2Cnt,3] != 'TF'
					//--Se for Internacional nao pode desprezar os itens zerados, precisa ser gravado
					If (aDocto[nCntFor,9,n1Cnt,2,n2Cnt,2] > 0 ) .Or. (aDocto[nCntFor,9,n1Cnt,2,n2Cnt,2] == 0 .And. lTMSINTER)
						nSeek := ASCan(aFrete,{|x|x[3]==aDocto[nCntFor,9,n1Cnt,2,n2Cnt,3]})
						If Empty(nSeek)
							AAdd(aFrete,AClone(aDocto[nCntFor,9,n1Cnt,2,n2Cnt]))
							nValFre += aDocto[nCntFor,9,n1Cnt,2,n2Cnt,2]
						Else
							lTaxa := TMSAComTax(aFrete[nSeek,3])
							//-- Taxa por documento 1=Sim, todos os documentos serao taxados
							//-- Taxa por documento 2=Nao, somente o ultimo documento sera taxado, Soma do valor do frete se no ultimo item do array
							If	lTaxa .And. cTaxCtr == StrZero(1,Len(DUO->DUO_TAXCTR))
								aFrete[nSeek,2] := aDocto[nCntFor,9,n1Cnt,2,n2Cnt,2]
								aFrete[nSeek,5] := aDocto[nCntFor,9,n1Cnt,2,n2Cnt,5]
								aFrete[nSeek,6] := aDocto[nCntFor,9,n1Cnt,2,n2Cnt,6]
							ElseIf !lTaxa .Or. (cTaxCtr == StrZero(2,Len(DUO->DUO_TAXCTR)) .And. lUltimo .And. (n2Cnt == Len(aDocto[nCntFor,9,n1Cnt,2])))
								aFrete[nSeek,2] += aDocto[nCntFor,9,n1Cnt,2,n2Cnt,2]
								aFrete[nSeek,5] += aDocto[nCntFor,9,n1Cnt,2,n2Cnt,5]
								aFrete[nSeek,6] += aDocto[nCntFor,9,n1Cnt,2,n2Cnt,6]
							EndIf
							nValFre += aDocto[nCntFor,9,n1Cnt,2,n2Cnt,2]
						EndIf
					EndIf
				EndIf
			Next n2Cnt

			AAdd(aProduto,{cCodPro,AClone(aDocto[nCntFor,9,n1Cnt,2]),{},nPesoP})

			//-- Notas fiscais do cliente
			For n2Cnt := 1 To Len(aDocto[nCntFor,9,n1Cnt,3])
				cNumNfc	:= aDocto[nCntFor,9,n1Cnt,3,n2Cnt,1]
				cSerNfc	:= aDocto[nCntFor,9,n1Cnt,3,n2Cnt,2]
				lAddNfc	:= .T.
				//-- Adiciona a nota fiscal do cliente apenas 1 vez no vetor aNfCTRC
				If	n1Cnt+1 <= Len(aDocto[nCntFor,9])
					For n3Cnt := n1Cnt+1 To Len(aDocto[nCntFor,9])
						If AScan(aDocto[nCntFor,9,n3Cnt,3],{|x|x[1]+x[2]==cNumNfc+cSerNfc})>0
							lAddNfc := .F.
							Exit
						EndIf
					Next
				EndIf
				If lAddNfc
					AAdd(aNfCTRC,{cNumNfc,cSerNfc})
				EndIf
				AAdd(aProduto[Len(aProduto),3],{cNumNfc,cSerNfc})
			Next

			//-- Carrega Vetor De Itens Da NF Para Rateio
			aAdd( aItRat , aDocto[nCntFor,9,n1Cnt] )

			//-- Analisar a quebra e gerar o documento
			If	TmsA200Qb1( aDocto[nCntFor,9], aDocto[nCntFor,10,39], aDocto[nCntFor,10,37], aDocto[nCntFor,10,38], Iif(cTipTra == '4',Replicate('z',Len(DT4->DT4_NUMCOT)),cNumCot), n1Cnt, Len(aNfCTRC), nPeso, nNfCTRC, nPesCTR, lUltimo, cCodPro, cNextPro, aDocto, lCTeUnico, lFim1 )

				aAdd(aPrm200THR,{	cTaxCtr,    cEstOri,  cEstCal,  cTipoFrt, cCodPro,   cCodProIT,  	nQtdVol,  nValor,  			nPeso,     nPesoM3,  ;
									nMetro3,    nSeguro,  nNfCTRC,  nQtdUni,  nCntFor,   nTipImp,    	nPerImp,  nPesLiq,  		lTM200QBR, lTaxa,    ;
									lRecalculo, lUltimo,  lConsig,  lCalImp,  lRefatur,  Nil,        	lThread,  aClone(aProduto), aNfCTRC,   aValInf,  ;
									aTmsA500,   aFrete,   aVisErr,  aNumDoc,  aICMSol,   aPerfil,		aNFS,     aDocto,   		cJobThr,   cJobFile, ;
									cEmpAnt,    cFilAnt,  nPesoCob, aPedBlq,  dDataBase, lImpDoc,    	nPerISS,  cIncISS,  		cUserName, cCodUser })

				// Rateio
				If lRateio .And. aDocto[nCntFor,10,3] != '8'//complementar n„o entra no Rateio

					aCompFrt:= {}
					aLinha	:= {}
					For nCount := 1 To Len(aFrete)
						If aFrete[nCount,2] > 0
							AAdd( aCompFrt, aClone(aFrete[nCount]) )
						EndIf
					Next

					//--- Quando o Criterio de Calculo de Rateio È por A= %Fixo, nao pode haver servicos e ou negociacoes diferente no lote
					If DTP->DTP_PRORAT == 'A' //%Fixo

						//---- Armazena todos os percentuais dos Clientes Devedores
						If nPosFix:= Ascan(aPerFix,{|x| x[1] == aDocto[nCntFor,6] }) == 0 //Cliente Devedor
							aPerFix:= TMSPFxDDP(aDocto[nCntFor,10,32],aDocto[nCntFor,1],aDocto[nCntFor,31]) //Contrato,Servico,Negociacao
						EndIf

						//---- Verifica o Percentual Fixo do Cliente+Loja Devedor
						If Len(aPerFix) > 0
							nPosFix:= Ascan(aPerFix,{|x| x[1]+x[2] == aDocto[nCntFor,6]+aDocto[nCntFor,7] })  //Cliente Devedor + Loja Devedor
							If nPosFix > 0
								nPerFix:= aPerFix[nPosFix][3]
							EndIf
						EndIf
					EndIf

		          //----------------------------------------------------------------------------------
		          //-- EAlberti - Se For ValorizaÁ„o Da Coleta, Determina Pesos Conforme Contrato
	    	      //----------------------------------------------------------------------------------
					If lValCol

						//-- Determina Pesos Do Processamento Da Coleta
						cArqCol := Tmsa200Pes( DTP->DTP_LOTNFC , aNfCtrc[1,1] , aNfCtrc[1,2] )

						If Select( cArqCol ) > 0

							nPesDUM      := Max( (cArqCol)->DUM_PESOM3 , (cArqCol)->DUM_PESO   )
							nPesDUA      := Max( (cArqCol)->DUA_PM3OCO , (cArqCol)->DUA_PESOCO )
							nPesDTC      := Max( (cArqCol)->DTC_PESOM3 , (cArqCol)->DTC_PESO   )

							//-- Determina Maior Peso Previsto
							nPesCol := nPesDUM

							//-- Determina Maior Peso Previsto X Realizado
							aVetPes := { nPesDUM , nPesDUA , nPesDUA }
							nPesRea := 0

							For nCount := 1 To Len(aVetPes)
								nPesRea := Max( nPesRea , aVetPes[nCount] )
							Next nCount

							//-- Fecha Arquivo Tempor·rio Aberto Pelo Tmsa200Pes
							(cArqCol)->(DbCloseArea())

						EndIf
					EndIf

					Aadd( aLinha, { Len(aNfCTRC),; 		// 01 - Quantidade de Notas Fiscais
						nQtdVol,;	  					// 02 - Quantidade Total de Volumes
						nPeso,;			  				// 03 - Quantidade Total de Peso
						nPesoM3,;		  				// 04 - Quantidade Total de PesoM3
						nValor,;						// 05 - Quantidade Total de Vlr.Mercadoria
						nMetro3,;						// 06 - Quantidade Total de M3
						nTOTKM,; 						// 07 - Quantidade Total de KM
						AClone(aCompFrt),;	   			// 08 - Componentes de Frete ja Calculados
						nPesCol,;						// 09 - Quantidade Total de Peso Previsto
						nPesRea,;						// 10 - Quantidade Total de Peso Previsto x Realizado
						aDocto[nCntFor,10,18],;			// 11 - Codigo do Remetente
						aDocto[nCntFor,10,19],;			// 12 - Loja do Remetente
						aDocto[nCntFor,4],;	   			// 13 - Codigo do Destinatario
						aDocto[nCntFor,5],;	   			// 14 - Loja do Destinatario
						aDocto[nCntFor,6],;	   			// 15 - Codigo do Devedor
						aDocto[nCntFor,7],;	   			// 16 - Loja do Devedor
						aDocto[nCntFor,10,34],;			// 17 - Codigo do Cliente de Calculo
						aDocto[nCntFor,10,35],;			// 18 - Loja do Cliente de Calculo
						aDocto[nCntFor,10,32],;			// 19 - Numero do Contrato
						aDocto[nCntFor,01],; 			// 20 - Codigo do Servico
						aDocto[nCntFor,10,22],;			// 21 - Tipo de Transporte
						AClone(aDocto[nCntFor,10,40]),; // 22 - Tipo de veiculo
						aDocto[nCntFor,15] ,;			// 23 - Sequencia Endereco Destinatario
						aDocto[nCntFor,31],;	   		// 24 - Cod.Negociacao
						nPerFix,;   					// 25 - Percentual Fixo
						aDocto[nCntFor,10,23],;         // 26 - Regiao Origem
						aDocto[nCntFor,10,7],;          // 27 - Regiao Destino
						aDocto[nCntFor,10,31] } )       // 28 - Regiao Calculo

					Aadd( aRateio, { 	AClone(aLinha[01]),		AClone(aPrm200THR[ len(aPrm200THR) ] ),		aJobThr,;
											cJobThr,			cJobFile,									cCliDev,;
											cLojDev,			nCountThr,									nQtdMnt,;
											nThreads,			aVisErr,									lThread,;
											aItRat } )

					//-- Limpa Vari·vel Para PrÛximo Documento
					aItRat := {}
				Else

					//-- Preview a Receber
					If lPreview

						Tmsa200VPr(	@aPreview,;
										@lContinua,;
										aClone(aFrete),;
										aClone(aDocto),;
										nCntFor,;
										cCliDev,;
										cLojDev,;
										cCodPro,;
										nQtdVol,;
										nPeso,;
										nPesoM3,;
										nPesoCob,;
										nValor,;
										aPrm200THR,;
										aJobThr,;
										cJobThr,;
										cJobFile,;
										nCountThr,;
										nQtdMnt,;
										nThreads,;
										nProcReg,;
										aVisErr,;
										lThread,;
										nCont1,;
										nQtdDef,;
										nQtdDif,;
										lFim1,;
										lFim2,;
										nQtdRst  )

					Else
						If !(lValCol)
							TMSA200Ger(@aPrm200THR,@aJobThr,@cJobThr,@cJobFile,@cCliDev,@cLojDev,@nCountThr,@nQtdMnt,@nThreads,@aVisErr,@lThread, @nCont1, @nQtdDef, @nQtdDif, @lFim1, @lFim2, @nQtdRst,cSemaforo)
						Else
							//-- Se For Coleta, Valoriza Viagem e Gera DT8 (Sem GeraÁ„o De CTR).
							Tmsa200Col( aPrm200THR )
						EndIf
					EndIf
				EndIf

				aPerfil  := aClone(aAuxPerfil)

				nQtdVol  := 0
				nValor   := 0
				nPeso    := 0
				nPesoM3  := 0
				nMetro3  := 0
				nSeguro  := 0
				nQtdUni  := 0
				nPesCol  := 0
				nPesRea  := 0
				nTOTKM   := 0

				//-- Limpa memÛria de arrays
				ResetArr(@aFrete )
				ResetArr(@aNfCTRC )
				ResetArr(@aProduto )

				aFrete   := {}
				aNfCTRC  := {}
				aProduto := {}
				aFreteCol:= {}
			EndIf
		Next n1Cnt
	EndIf
Next nCntFor

If lRateio .And. ValType(aRateio) == "A" .And. Len(aRateio) > 0

	//-- Limpa memÛria de arrays
	ResetArr(@aLinha )
	ResetArr(@aCompFrt )

	aLinha   := {}
	aCompFrt := {}
	aCompFrt := TMSCalcRat( aRateio, DTP->DTP_FILORI, DTP->DTP_LOTNFC, aPerFix, aValInfAc )

	// Avaliar a Configuracao de Tabela de Frete buscando Componentes//
	// configurados com o Calcula sobre como:                        //
	// 13 - TDA (Dificuldade de Acesso)                              //
	// 14 - Com base no Total de Frete sem Impostos                  //
	DVE->( DbSetOrder( 1 ) ) //-- DVE_FILIAL + DVE_TABFRE + DVE_TIPTAB + DVE_ITEM
	cAliasQry := GetNextAlias()

	cQuery := "   SELECT DVE.DVE_CODPAS, DT3.DT3_TIPFAI"
	cQuery += "     FROM " + RetSqlName("DVE") + " DVE, " + RetSqlName("DT3") + " DT3 "
	cQuery += "    WHERE DVE_FILIAL = '" + xFilial('DVE') + "' "
	cQuery += "      AND DVE_TABFRE = '" + Iif( lTabAlt, DTP->DTP_TBARAT, DTP->DTP_TABRAT) + "' "
	cQuery += "      AND DVE_TIPTAB = '" + Iif( lTabAlt, DTP->DTP_TPARAT, DTP->DTP_TIPRAT) + "' "
	cQuery += "      AND DVE.D_E_L_E_T_ = ' ' "
	cQuery += "      AND DT3.DT3_FILIAL = '" + xFilial('DT3') + "' "
	cQuery += "      AND DT3.DT3_CODPAS = DVE_CODPAS"
	cQuery += "      AND DT3.DT3_TIPFAI IN( '"+ StrZero(13, Len(DT3->DT3_TIPFAI)) + "', '" + StrZero(14, Len(DT3->DT3_TIPFAI)) + "')"
	cQuery += "      AND DT3.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY " + SqlOrder(DVE->(IndexKey()))
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)

	If (cAliasQry)->(!Eof())

		While (cAliasQry)->(!Eof())

			Aadd( aLinha, (cAliasQry)->DVE_CODPAS )

			If !lRatTDA
				lRatTDA := Iif( (cAliasQry)->DT3_TIPFAI == StrZero(13, Len(DT3->DT3_TIPFAI)), .T., .F. )
			EndIf

			For n1Cnt := 1 To Len(aCompFrt)
				nCount := Ascan( aCompFrt[n1Cnt],{|x| x[03] == (cAliasQry)->DVE_CODPAS })

				If nCount > 0
				   	aDel( aCompFrt[n1Cnt], nCount )
				   	aSize( aCompFrt[n1Cnt], Len(aCompFrt[n1Cnt]) - 1 )
				EndIf
			Next n1Cnt

			(cAliasQry)->( dbSkip() )
		EndDo

		Aadd( aLinha, {} )

	EndIf

	(cAliasQry)->( DbCloseArea() )


	If (Len(aCompFrt) > 0) .And. (Len(aLinha) > 0)

		DC5->(dbSetOrder(1)) //DC5_FILIAL+DC5_SERVIC
		DC5->(MsSeek(xFilial("DC5")+ cServic))

		If lIdentDoc .And. Empty(DC5->DC5_DOCTMS)
			cDocTms := aLote[ nCntFor, LTDOCTMS ]
		Else
			cDocTms := Posicione('DC5', 1, xFilial('DC5') + cServic, 'DC5_DOCTMS' )
		EndIf

		For n1Cnt := 1 To Len(aCompFrt)
			aLinha[ Len(aLinha) ] := {}
			aLinha[ Len(aLinha) ] := AClone(aCompFrt[n1Cnt])
			aFreteCol             := {}

			If (cSerTms := Posicione('DC5', 1, xFilial('DC5') + aRateio[n1Cnt][01][20], 'DC5_SERTMS' )) == "1"
				If DDA->(ColumnPos("DDA_BLQCOL")) > 0 .And. DDC->(ColumnPos("DDC_BLQCOL")) > 0
					lBlqCol := (TmsSobServ('BLQCOL',.T.,.T.,aRateio[n1Cnt][01][19],cCodNeg,aRateio[n1Cnt][01][20],"0",@nAdiDoc) $ " 1")
				EndIf
			Else
				If DDA->(ColumnPos("DDA_CBRCOL")) > 0 .And. DDC->(ColumnPos("DDC_CBRCOL")) > 0
					lCbrCol := (TmsSobServ('CBRCOL',.T.,.T.,aRateio[n1Cnt][01][19],cCodNeg,aRateio[n1Cnt][01][20],"0",@nAdiDoc) $ " 1")
				EndIf
			EndIf

			aFrete := TMSCalFret(	Iif( lTabAlt, DTP->DTP_TBARAT, DTP->DTP_TABRAT),;
									Iif( lTabAlt, DTP->DTP_TPARAT, DTP->DTP_TIPRAT),	@cSeqTab,;
									DTP->DTP_ORIRAT,		DTP->DTP_CALRAT,			aRateio[n1Cnt][01][17],;
									aRateio[n1Cnt][01][18],	Space(Len(SB1->B1_COD)),	aRateio[n1Cnt][01][20],;
									cSerTms,;
									aRateio[n1Cnt][01][21],	aRateio[n1Cnt][01][19],		aMsgErr,;
									/*aNfCTRC*/,			aRateio[n1Cnt][01][05],		aRateio[n1Cnt][01][03],;
									aRateio[n1Cnt][01][04],	/*nPesoCob*/,				aRateio[n1Cnt][01][02],;
									/*nDesconto*/,			/*nSeguro*/,				/*nMetro3*/,;
									/*nQtdDco*/,			/*nDiaSem*/,				Iif(DTP->DTP_CRIRAT == 'A', DTP->DTP_KM, aRateio[n1Cnt][01][07]) ,;
									/*nPerNoi*/,			/*lMinimo*/,				.F.,;
									.F.,					/*nQtdEnt*/,				0,;
									/*nValDpc*/,			/*nDocSImp*/,				/*nDocCImp*/,;
									/*aValInf*/,			aRateio[n1Cnt][01][22], cDocTms,;
									/*nDiaFimSem*/,			/*nPesoVge*/,				/*nPesoM3Vge*/,;
									/*nMetro3Vge*/,			/*nValMerVge*/,				/*nQtdVolVge*/,;
									/*nDiaArm*/,			/*aFaixaTab*/,				DTP->DTP_LOTNFC,;
									/*aPesCub*/,			.T.,						aRateio[n1Cnt][01][15],;
									aRateio[n1Cnt][01][16],	/*nMoeda*/,					Iif(lRatTDA, aRatTDA[n1Cnt][01], ""),;
									Iif(lRatTDA, aRatTDA[n1Cnt][02], ""),				Iif(lRatTDA, aRatTDA[n1Cnt][03], ""),;
									Iif(lRatTDA, aRatTDA[n1Cnt][04], ""),				/*nQtdCol*/,;
									aRateio[n1Cnt][01][13], aRateio[n1Cnt][01][14], aRateio[n1Cnt][01][23],	/*nSeqDoc*/,;
									lRateio, 				/*aBaseRat*/,				aLinha,;
									cCodNeg ,/*aTaxDev*/, @aFreteCol, lCbrCol, lBlqCol)

			If Len(aFrete) > 0
				aCompFrt[n1Cnt] := {}
				aCompFrt[n1Cnt] := aFrete
			EndIf

		Next n1Cnt

		//--- Remove o componente TF para nao duplicar valores abaixo
		For n1Cnt := 1 To Len(aCompFrt)
			nCount := Ascan( aCompFrt[n1Cnt],{|x| x[03] == 'TF' })

			If nCount > 0
			   	aDel( aCompFrt[n1Cnt], nCount )
			   	aSize( aCompFrt[n1Cnt], Len(aCompFrt[n1Cnt]) - 1 )
			EndIf
		Next n1Cnt

		aRatTDA := {}
		aFrete  := {}
		aLinha  := {}
	EndIf

	If Len(aCompFrt) > 0

		For n1Cnt := 1 To Len(aCompFrt)

			For n2Cnt := 1 To Len(aCompFrt[n1Cnt])

				nSeek := Ascan(aRateio[n1Cnt][01][08], { |x| x[3] == aCompFrt[n1Cnt][n2Cnt][03] })

				// Para os casos em que o Componente Rateado nao for encontrado na	//
				// Composicao Original, esse sera INSERIDO a Composicao Original.	//
				If nSeek == 0
					Aadd( aRateio[n1Cnt][01][08], aClone(aCompFrt[n1Cnt][n2Cnt]) )

				// Existindo o o Componente Rateado na Composicao Original, sera	//
				// sobreposto o valor Original pelo valor Rateado do Componente.	//
				Else
					If !lValcol .Or. (lValCol .And. IsInCallStack("TMSA310Grv"))   //Quando a valorizacao for pelo Encerramento da Coleta, o erro sera exibido no TMSA310Vlr()
						//--- Verifica se o Componente Obrigatorio est· com valor zerado
						If aCompFrt[n1Cnt][n2Cnt][02]<=0 .And. aCompFrt[n1Cnt][n2Cnt][23] == StrZero(1,Len(DVE->DVE_COMOBR))
							AAdd( aMsgErr, { STR0161 + " : " + aCompFrt[n1Cnt][n2Cnt][01], '00', 'TMSA010()' } ) //""Devido ao rateio, o componente obrigatorio ficou com valor zerado. "
							lRet:= .F.
							Exit
						EndIf
						//------
					EndIf
					aRateio[n1Cnt][01][08][nSeek][02] := aCompFrt[n1Cnt][n2Cnt][02] // Vlr.Componente Rateado
					aRateio[n1Cnt][01][08][nSeek][21] := aCompFrt[n1Cnt][n2Cnt][21] // Percentual de Rateio
				EndIf
			Next n2Cnt

		Next n1Cnt
	EndIf

	If lRet
		For n1Cnt := 1 To Len(aRateio)

			//-- Limpa cache dos arrays
			ResetArr(@aCompFrt )
			ResetArr(@aPrm200THR )


			aCompFrt	:= {}
			aPrm200THR	:= {}
			aVisErr		:= {}
			cJobThr		:= ""
			cJobFile	:= ""
			cCliDev		:= ""
			cLojDev		:= ""
			nCountThr	:= 0
			nQtdMnt		:= 0

			lThread		:= .F.

			Aadd( aPrm200THR, aClone(aRateio[n1Cnt][02]))

			aCompFrt	:= aClone( aRateio[n1Cnt][01][08] )
			cJobThr		:= aRateio[n1Cnt][04]
			cJobFile	:= aRateio[n1Cnt][05]
			cCliDev		:= aRateio[n1Cnt][06]
			cLojDev		:= aRateio[n1Cnt][07]
			nCountThr	:= aRateio[n1Cnt][08]
			nQtdMnt		:= aRateio[n1Cnt][09]

			aVisErr		:= aClone(aRateio[n1Cnt][11])
			lThread		:= aRateio[n1Cnt][12]

			//-- Pedidos Bloqueados
			If Len(aPedBlq) > 0 .And. ValType(aPrm200THR[01][44]) == 'A'
	 			aPrm200THR[01][44]:= aClone(aPedBlq)
			EndIf

			//-- Carrega elementos rateados que n„o existiam anteriormente (Rateio de frete informado inicialmente n„o em todos documentos)
			nValFrePrd := 0
			nValFreFre := 0
			For n2Cnt := 1 To Len(aCompFrt)
		        //-- Elemento : [01][28] --> aProduto
				nSeek := Ascan(aPrm200THR[01][28][01][02], { |x| x[03] == aCompFrt[n2Cnt][03] })
				If nSeek == 0
					
					If aTail(aPrm200THR[01][28][01][02])[3] == "TF" // Se o ˘ltimo È o TF
							//-- Guarda o tamanho atual do aFrete 
						nSeek := Len(aPrm200THR[01][28][01][02])
							//-- Aumenta 1 Linha no aFrete com Nil
						aSize(aPrm200THR[01][28][01][02],nSeek+1)
							//-- Insere 1 linha com Nil no aFrete na pen˙ltima posiÁ„o, "empurrando" o TF para ˙ltima posiÁ„o 
						aIns(aPrm200THR[01][28][01][02], nSeek)
							//-- Atribui ‡ pen˙ltima linha do aFrete o conte˙do
						aPrm200THR[01][28][01][02][nSeek] := Aclone(aCompFrt[n2Cnt])
						
					Else
						Aadd(aPrm200THR[01][28][01][02],Aclone(aCompFrt[n2Cnt]))
					EndIf
					nValFrePrd += aCompFrt[n2Cnt][02]
				EndIf

		        //-- Elemento : [01][32] --> aFrete
				nSeek := Ascan(aPrm200THR[01][32], { |x| x[03] == aCompFrt[n2Cnt][03] })
				If nSeek == 0
					Aadd(aPrm200THR[01][32],Aclone(aCompFrt[n2Cnt]))
					nValFreFre += aCompFrt[n2Cnt][02]
				EndIf
			Next n2Cnt

			// Buscar o "TF" para Ajustar seu Valor //
	        //-- Elemento : [01][28] --> aProduto
			nSeek := Ascan(aPrm200THR[01][28][01][02], { |x| x[03] == "TF" })
			If nSeek > 0
				aPrm200THR[01][28][01][02][nSeek][02] += nValFrePrd
			EndIf
	        //-- Elemento : [01][32] --> aFrete
			nSeek := Ascan(aPrm200THR[01][32], { |x| x[03] == "TF" })
			If nSeek > 0
				aPrm200THR[01][32][nSeek][02] += nValFreFre
			EndIf

	        //-- Elemento : [01][38] --> aDocto
			For n2Cnt := 1 To Len(aPrm200THR[01][38])
				For n3Cnt := 1 To Len(aPrm200THR[01][38][n2Cnt][09])
					nValFreDoc := 0
					For nCntFor := 1 To Len(aCompFrt)
						nSeek := Ascan(aPrm200THR[01][38][n2Cnt][09][n3Cnt][02], { |x| x[03] == aCompFrt[nCntFor][03] })
						If nSeek == 0
							If aTail(aPrm200THR[01][38][n2Cnt][09][n3Cnt][02])[3] == "TF" // Se o ˘ltimo È o TF
								//-- Guarda o tamanho atual do aFrete 
								nSeek := Len(aPrm200THR[01][38][n2Cnt][09][n3Cnt][02])
								//-- Aumenta 1 Linha no aFrete com Nil
								aSize(aPrm200THR[01][38][n2Cnt][09][n3Cnt][02],nSeek+1)
								//-- Insere 1 linha com Nil no aFrete na pen˙ltima posiÁ„o, "empurrando" o TF para ˙ltima posiÁ„o 
								aIns(aPrm200THR[01][38][n2Cnt][09][n3Cnt][02], nSeek)
								//-- Atribui ‡ pen˙ltima linha do aFrete o conte˙do
								aPrm200THR[01][38][n2Cnt][09][n3Cnt][02][nSeek] := Aclone(aCompFrt[nCntFor])
							Else
								Aadd(aPrm200THR[01][38][n2Cnt][09][n3Cnt][02],Aclone(aCompFrt[nCntFor]))
							EndIf
							nValFreDoc += aCompFrt[nCntFor][02]
						EndIf
					Next nCntFor

					// Buscar o "TF" para Ajustar seu Valor //
					nSeek := Ascan(aPrm200THR[01][38][n2Cnt][09][n3Cnt][02], { |x| x[03] == "TF" })
					If nSeek > 0
						aPrm200THR[01][38][n2Cnt][09][n3Cnt][02][nSeek][02] += nValFreDoc
					EndIf
				Next n3Cnt
			Next n2Cnt

	        // Buscar por Elementos do vetor aPrm200THR que contenham a Composi-//
	        // cao de Frete Original, onde se faz necessario ajustar esses ele-	//
	        // mentos, sobrepondo com o valor do Componente Rateado.			//
	        //																	//
	        // Elemento : [01][28] --> aProduto									//
			If ValType(aPrm200THR[01][28][01][02]) == 'A' .And. Len(aDocto) > 1
				nValFre := 0

				For n2Cnt := 1 To Len(aPrm200THR[01][28][01][02])
					nSeek := 0
					nSeek := Ascan(aCompFrt, { |x| x[03] == aPrm200THR[01][28][01][02][n2Cnt][03] })

					If nSeek > 0
						aPrm200THR[01][28][01][02][n2Cnt][02] := aCompFrt[nSeek][02]
						nValFre	+= aCompFrt[nSeek][02]

						If Len(aPrm200THR[01][28][01][02][n2Cnt]) >= 21
							aPrm200THR[01][28][01][02][n2Cnt][21] := aCompFrt[nSeek][21]
						EndIf
					EndIf
				Next n2Cnt

				// Buscar o "TF" para Ajustar seu Valor //
				nSeek := 0
				nSeek := Ascan(aPrm200THR[01][28][01][02], { |x| x[03] == "TF" })

				If nSeek > 0
					aPrm200THR[01][28][01][02][nSeek][02] := nValFre
				EndIf
			EndIf

	        // Elemento : [01][32] --> aFrete									//
			If ValType(aPrm200THR[01][32]) == 'A'
				nValFre := 0

				For n2Cnt := 1 To Len(aPrm200THR[01][32])
					nSeek := 0
					nSeek := Ascan(aCompFrt, { |x| x[03] == aPrm200THR[01][32][n2Cnt][03] })

					If nSeek > 0
						aPrm200THR[01][32][n2Cnt][02] := aCompFrt[nSeek][02]
						nValFre	+= aCompFrt[nSeek][02]

						If Len(aPrm200THR[01][32][n2Cnt]) >= 21
							aPrm200THR[01][32][n2Cnt][21] := aCompFrt[nSeek][21]
						EndIf
					EndIf
				Next n2Cnt

				// Buscar o "TF" para Ajustar seu Valor //
				nSeek := 0
				nSeek := Ascan(aPrm200THR[01][32], { |x| x[03] == "TF" })

				If nSeek > 0
					aPrm200THR[01][32][nSeek][02] := nValFre
				EndIf
			EndIf

	        // Elemento : [01][38] --> aDocto									//
			If ValType(aPrm200THR[01][38]) == 'A'
				nValFre := 0

				For n2Cnt := 1 To Len(aPrm200THR[01][38])
					nValor   := 0
					nPeso    := 0
					nPesoM3  := 0
					nPesoCob := 0
					nQtdVol  := 0

					For n3Cnt := 1 To Len(aPrm200THR[01][38][n2Cnt][09])
						nValFre := 0
						If  n2Cnt == 1
							cCodPro   := aPrm200THR[01][38][n2Cnt][09][n3Cnt][1]
							nQtdVol   += aPrm200THR[01][38][n2Cnt][09][n3Cnt][4]
							nPeso     += aPrm200THR[01][38][n2Cnt][09][n3Cnt][6]    //Peso Documento
							nPesoM3   += aPrm200THR[01][38][n2Cnt][09][n3Cnt][7]
							If aPrm200THR[01][38][n2Cnt][10][39] == '2' .And. !Empty(aPrm200THR[01][38][n2Cnt][09][n3Cnt][17])
								nPesoCob  := aPrm200THR[01][38][n2Cnt][09][n3Cnt][17]
							Else
								nPesoCob  := aPrm200THR[01][38][n2Cnt][10][36]
							EndIf
							nValor    += aPrm200THR[01][38][n2Cnt][09][n3Cnt][5]
						EndIf

						For nCntFor := 1 To Len(aPrm200THR[01][38][n2Cnt][09][n3Cnt][02])

							nSeek := 0
							nSeek := Ascan(aCompFrt, { |x| x[03] == aPrm200THR[01][38][n2Cnt][09][n3Cnt][02][nCntFor][03] })

							If nSeek > 0
								aPrm200THR[01][38][n2Cnt][09][n3Cnt][02][nCntFor][02] := aCompFrt[nSeek][02]
								nValFre	+= aCompFrt[nSeek][02]

								If Len(aPrm200THR[01][38][n2Cnt][09][n3Cnt][02][nCntFor]) >= 21
									aPrm200THR[01][38][n2Cnt][09][n3Cnt][02][nCntFor][21] := aCompFrt[nSeek][21]
								EndIf
							EndIf

						Next nCntFor

						// Buscar o "TF" para Ajustar seu Valor //
						nSeek := 0
						nSeek := Ascan(aPrm200THR[01][38][n2Cnt][09][n3Cnt][02], { |x| x[03] == "TF" })

						If nSeek > 0
							aPrm200THR[01][38][n2Cnt][09][n3Cnt][02][nSeek][02] := nValFre
						EndIf

					Next n3Cnt

				Next n2Cnt

				If lPreview

					Tmsa200VPr(	@aPreview,;
									@lContinua,;
									aClone(aPrm200THR[01][32]),; // aFrete
									aClone(aPrm200THR[01][38]),; // aDocto
									aPrm200THR[01][15],;
									cCliDev,;
									cLojDev,;
									cCodPro,;
									aRateio[n1CNt,1,2],;	// Qtde Volume
									aRateio[n1CNt,1,3],;	// Peso
									aRateio[n1CNt,1,4],;	// Peso M3
									aPrm200THR[01][43],;	// Peso Cobrado
									aRateio[n1CNt,1,5],;	// Valor Mercadoria
									aClone(aPrm200THR),;
									aJobThr,;
									cJobThr,;
									cJobFile,;
									nCountThr,;
									nQtdMnt,;
									nThreads,;
									nProcReg,;
									aVisErr,;
									lThread,;
									nCont1,;
									nQtdDef,;
									nQtdDif,;
									lFim1,;
									lFim2,;
									nQtdRst  )
					EndIF
			EndIf

			//-- Preview a Receber
			If !lPreview
				If !(lValCol)
					TMSA200Ger(@aPrm200THR,@aJobThr,@cJobThr,@cJobFile,@cCliDev,@cLojDev,@nCountThr,@nQtdMnt,@nThreads,@aVisErr,@lThread, @nCont1, @nQtdDef, @nQtdDif, @lFim1, @lFim2, @nQtdRst,cSemaforo)
				Else
					//-- Se For Coleta, Valoriza Viagem e Gera DT8 (Sem GeraÁ„o De CTR).
					Tmsa200Col( aPrm200THR )
				EndIf
			EndIf

		Next n1Cnt
	Else
		AaddMsgErr( aMsgErr, @aVisErr)
		lThread:= .F.
	EndIf

	aRateio := {}
EndIf

//----------------------------------------------------------------------------------
//-- Inicio - Tratamento De ApresentaÁ„o Do Vetor aPreview
//----------------------------------------------------------------------------------
lRet := lContinua

//-- Exibe Preview a Receber
If lPreview .And. lContinua

	If ValType(aPreview) == "A" .And. Len(aPreview) > 0

		//-- Ponto de entrada que possibilita alterar os dados do preview.
		If	lTM200PW01
			aPEPvw := ExecBlock('TM200PW01',.F.,.F.,{aClone(aPreview),cLotNfc})
			If ValType(aPEPvw) == "A"
				aPreview := aClone(aPEPvw)
			EndIf
		EndIf

		//-- Chama Rotina Que Mostra Tela Do Preview
		If Tms200bScr(aPreview)

			For n1Cnt := 1 To Len(aPreview)

				//-- Calculos selecionados
				If aPreview[n1Cnt][14]

					If aPreview[n1Cnt][13][01][13] > 0

						If !(lValCol)
							//-- Gera documento
							TMSA200Ger(	aPreview[n1Cnt][01],; //--@aPrm200THR,
											aPreview[n1Cnt][02],; //--@aJobThr,
											aPreview[n1Cnt][03],; //--@cJobThr,
											aPreview[n1Cnt][04],; //--@cJobFile,
											aPreview[n1Cnt][05],; //--@cCliDev,
											aPreview[n1Cnt][06],; //--@cLojDev,
											aPreview[n1Cnt][07],; //--@nCountThr,
											aPreview[n1Cnt][08],; //--@nQtdMnt,
											aPreview[n1Cnt][09],; //--@nThreads,
											@aVisErr           ,; //--@aVisErr,
											aPreview[n1Cnt][12],; //--@lThread,
											aPreview[n1Cnt][16],; //--@nCont1,
											aPreview[n1Cnt][17],; //--@nQtdDef,
											aPreview[n1Cnt][18],; //--@nQtdDif,
											aPreview[n1Cnt][19],; //--@lFim1,
											aPreview[n1Cnt][20],; //--@lFim2,
											aPreview[n1Cnt][21],; //--@nQtdRst)
											cSemaforo			) //--cSemaforo
						Else
							//-- Se For Coleta, Valoriza Viagem e Gera DT8 (Sem GeraÁ„o De CTR).
							Tmsa200Col( aPreview[n1Cnt][01] )
						EndIf

						nMark++

					Else

						Help(' ', 1, 'TMSA20055',,cValToChar(n1Cnt),2,1) //-- "Valor Do Frete Zerado na Linha: "

						aPreview[n1Cnt][14] := !aPreview[n1Cnt][14]

						//-- Armazena quantidade de notas por calculo que nao foi selecionado
						nNfsl += Len(aPreview[n1Cnt][01][01][29])
					EndIf
				Else
					//-- Armazena quantidade de notas por calculo que nao foi selecionado
					nNfsl += Len(aPreview[n1Cnt][01][01][29])
				EndIf
			Next n1Cnt

			//-- Se nenhum calculo foi marcado retorna falso
			If nMark == 0
				lRet	:= .F.
			Else
				//-- Se nao foi selecionado todos os calculos
				If nMark != Len(aPreview)
					//-- Gera novo lote
					cLotEst := TmsA200Lte(cLotNfc,StrZero(2,Len(DTP->DTP_STATUS)),nNfsl)

					If !Empty(cLotEst)
						//-- Deixa o status do novo lote como bloqueado
						DTP->(DbSetOrder(1))
						If	DTP->(MsSeek(xFilial('DTP') + cLotEst))
							RecLock('DTP',.F.)
							DTP->DTP_STATUS := "4"
							MsUnLock()
						EndIf

						For n1Cnt := 1 To Len(aPreview)

							//-- Calculos nao selecionados
							If !aPreview[n1Cnt][14]

								//-- Notas fiscais desse calculo
								For n2Cnt := 1 To Len(aPreview[n1Cnt][01][01][29])

									//-- Altera lote
									//-- DTC
									cQuery := ""
									cQuery += " SELECT		DTC.R_E_C_N_O_ AS REGDTC "
									cQuery += " FROM 			" + RetSqlName("DTC") + "  DTC "
									cQuery += " WHERE 		DTC.DTC_FILIAL =  '"+xFilial("DTC")+"' "
									cQuery += " AND 			DTC.D_E_L_E_T_ =  ' ' "
									cQuery += " AND 			DTC.DTC_FILORI =  '" + cFilAnt + "' "
									cQuery += " AND 			DTC.DTC_LOTNFC =  '" + cLotNfc + "' "
									cQuery += " AND 			DTC.DTC_NUMNFC =  '" + PadR(aPreview[n1Cnt][01][01][29][n2Cnt][1],TamSx3("DTC_NUMNFC")[1])+"' "
									cQuery += " AND 			DTC.DTC_SERNFC =  '" + PadR(aPreview[n1Cnt][01][01][29][n2Cnt][2],TamSx3("DTC_SERNFC")[1])+"' "

									cQuery 	:= ChangeQuery(cQuery)
									cAliasQry	:= GetNextAlias()
									dbUseArea( .T., "TOPCONN", TCGENQRY(, ,cQuery), cAliasQry, .F., .T.)

									If !(cAliasQry)->( Eof() )

										DTC->(DbGoTo((cAliasQry)->REGDTC))

										//-- DVR
										cQuery := ""
										cQuery += " SELECT		DVR.R_E_C_N_O_ AS REGDVR "
										cQuery += " FROM 			" + RetSqlName("DVR") + "  DVR "
										cQuery += " WHERE			DVR.DVR_FILIAL =  '" + xFilial('DVR') + "' "
										cQuery += " AND 			DVR.DVR_FILORI =  '" + DTC->DTC_FILORI + "' "
										cQuery += " AND 			DVR.DVR_LOTNFC =  '" + DTC->DTC_LOTNFC + "' "
										cQuery += " AND 			DVR.DVR_CLIREM =  '" + DTC->DTC_CLIREM + "' "
										cQuery += " AND 			DVR.DVR_LOJREM =  '" + DTC->DTC_LOJREM + "' "
										cQuery += " AND 			DVR.DVR_CLIDES =  '" + DTC->DTC_CLIDES + "' "
										cQuery += " AND 			DVR.DVR_LOJDES =  '" + DTC->DTC_LOJDES + "' "
										cQuery += " AND 			DVR.DVR_SERVIC =  '" + DTC->DTC_SERVIC + "' "
										cQuery += " AND 			DVR.DVR_NUMNFC =  '" + DTC->DTC_NUMNFC + "' "
										cQuery += " AND 			DVR.DVR_SERNFC =  '" + DTC->DTC_SERNFC + "' "
										cQuery += " AND 			DVR.DVR_CODPRO =  '" + DTC->DTC_CODPRO + "' "
										cQuery += " AND 			DVR.D_E_L_E_T_ =  ' ' "

										cQuery 	:= ChangeQuery(cQuery)
										cAliasDVR	:= GetNextAlias()
										dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDVR)

										If (cAliasDVR)->(!Eof())
											While (cAliasDVR)->(!Eof())
												DVR->(DbGoTo( (cAliasDVR)->REGDVR ))

												RecLock('DVR',.F.)
												DVR->DVR_LOTNFC := cLotEst
												DVR->(MsUnLock())

												(cAliasDVR)->(DbSkip())
											EndDo
										EndIf
										(cAliasDVR)->(DbCloseArea())

										//-- DVU
										cQuery := ""
										cQuery += " SELECT		DVU.R_E_C_N_O_ AS REGDVU "
										cQuery += " FROM 			" + RetSqlName("DVU") + "  DVU "
										cQuery += " WHERE			DVU.DVU_FILIAL =  '" + xFilial('DVU') + "' "
										cQuery += " AND 			DVU.DVU_FILORI = '" + DTC->DTC_FILORI + "' "
										cQuery += " AND 			DVU.DVU_NUMNFC = '" + DTC->DTC_NUMNFC + "' "
										cQuery += " AND 			DVU.DVU_SERNFC = '" + DTC->DTC_SERNFC + "' "
										cQuery += " AND 			DVU.DVU_CLIREM = '" + DTC->DTC_CLIREM + "' "
										cQuery += " AND 			DVU.DVU_LOJREM = '" + DTC->DTC_LOJREM + "' "
										cQuery += " AND 			DVU.DVU_LOTNFC = '" + DTC->DTC_LOTNFC + "' "
										cQuery += " AND 			DVU.D_E_L_E_T_ = ' ' "

										cQuery 	:= ChangeQuery(cQuery)
										cAliasDVU	:= GetNextAlias()
										dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDVU)

										If (cAliasDVU)->(!Eof())
											While (cAliasDVU)->(!Eof())
												DVU->(DbGoTo( (cAliasDVU)->REGDVU ))

												RecLock('DVU',.F.)
												DVU->DVU_LOTNFC := cLotEst
												DVU->(MsUnLock())

												(cAliasDVU)->(DbSkip())
											EndDo
										EndIf
										(cAliasDVU)->(DbCloseArea())

										RecLock('DTC',.F.)
										DTC->DTC_LOTNFC := cLotEst
										DTC->(MsUnLock())

									EndIf
									(cAliasQry)->(DbCloseArea())

								Next n2Cnt
							EndIf
						Next n1Cnt

						Help(' ', 1, 'TMSA20028',,cLotEst,2,1) //"Numero do Novo Lote Gerado : "
					EndIf
				EndIf
			EndIf

			nNfsl := 0
			nMark := 0
		Else
			lRet	:= .F.
			//--Preview cancelado pelo usuario retorna o status do lote para 2-digitado
			DTP->(RecLock("DTP",.F.))
			DTP->DTP_STATUS := StrZero(2,Len(DTP->DTP_STATUS))
			DTP->(MsUnlock())

		EndIf
	Else
		lRet	:= .F.
	EndIf
EndIf

//-- Limpa cache dos arrays
ResetArr(@aPreview )
aPreview := {}

//----------------------------------------------------------------------------------
//-- Fim    - Tratamento Do Vetor aPreview
//----------------------------------------------------------------------------------
If lProcThread

	//--------------------------------------------------------------------------------
	//-- Tratamento para monitorar e derrubar threads em looping de rotina
	//--------------------------------------------------------------------------------
	nX	:= MonitorThg( aJobThr, cJobFile , .F. )

	//--------------------------------------------------------------------------------
	//-- Thread total - quantidade de threads que cairam
	//--------------------------------------------------------------------------------
	nThreads	:= nThreads - nX

	//--------------------------------------------------------------------------------
	//-- Tratamento para derrubar threads
	//--------------------------------------------------------------------------------
	nX	:= 0
	While .T. .And. nThreads > 0
		//----------------------------------------------------------------------
		//-- Verifico se existe Thread disponÌvel para realizar a chamada do IPCGO
		//----------------------------------------------------------------------
		nIpcCount := IPCCount( cSemaforo )

		If nIpcCount > 0
			IncProc( STR0186 ) //-- "Aguardando geraÁ„o de documentos..."
			nX++
			IPCGo( cSemaforo,,"EXIT" )
			If nX < nThreads
				Sleep(120) //-- Aguarda tÈrmino do processamento
			Else
				Exit
			EndIf
		Else
			MonitorThg( aJobThr, cJobFile , .F. )
			Exit
		EndIf
	EndDo

	//-----------------------------------------------------------------
	//-- Limpa vari·veis globais
	//-----------------------------------------------------------------
	For nX := 1 To Len(aJobThr)
		cJobThr		:= aJobThr[nX][1]
		ClearGlbValue(cJobThr)
	Next nX

	//-- Tratativa para aguardar gravaÁ„o do SQLite
	Sleep(500)

	//-----------------------------------------------------------------
	//-- Recupera mensagens do log
	//-----------------------------------------------------------------
	If DBSqlExec( "TMPLOG" , "SELECT * FROM " + cJobFile , 'SQLITE_SYS')

		IncProc(STR0185) //-- "Verificando mensagens de erro"

		While ("TMPLOG")->( !Eof() )

			cCodCli		:= ("TMPLOG")->CLIENTE
			cLojCli		:= ("TMPLOG")->LOJA
			aObs		:= STRTOKARR( ("TMPLOG")->MEMO , "<#>" )

			For nX := 1 To Len(aObs)
				aAdd(aVisErr, { aObs[nX] , "00", "" } )
			Next nX

			("TMPLOG")->(dbSkip())
		EndDo

		("TMPLOG")->(dbCloseArea())
	EndIf

	//-- Fecha tabela de log
	(cTabSQLite)->(dbCloseArea())
	DBSqlExec(cJobFile, 'DROP TABLE ' + cJobFile , 'SQLITE_SYS')

	//-- Se nao encontrou erro verifica se existe documento sem ctrc
	If !(Empty(aPedBlq) .And. Len(aVisErr)==0 )
		cAliasQry := GetNextAlias()
		cQuery := "   SELECT 1 "
		cQuery += "       FROM " + RetSqlName("DTC") + " DTC "
		cQuery += "    WHERE DTC.DTC_FILIAL = '" + xFilial('DTC') + "' "
		cQuery += "      AND DTC.DTC_FILORI = '" + cFilAnt + "' "
		cQuery += "      AND DTC.DTC_LOTNFC = '" + cLotNfc + "' "
		cQuery += "      AND DTC.DTC_FILDOC = '" + Space(Len(DTC->DTC_FILDOC)) + "' "
		cQuery += "      AND DTC.DTC_DOC    = '" + Space(Len(DTC->DTC_DOC))    + "' "
		cQuery += "      AND DTC.D_E_L_E_T_ = ' ' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
		If (cAliasQry)->(!EOF())
			Aadd( aVisErr, { STR0177 , "00", "" } ) //-- "Existem documentos sem conhecimento gerado. Verificar e recalcular este lote."
		EndIf
		(cAliasQry)->(DbCloseArea())
	EndIf
EndIf

ResetArr(@aTmCalFr	)
ResetArr(@aFrete	)
ResetArr(@aLinha	)
ResetArr(@aNfCTRC	)
ResetArr(@aContrt	)
ResetArr(@aProduto	)
ResetArr(@aRegra	)
ResetArr(@aTmsA200	)
ResetArr(@aTmsA500	)
ResetArr(@aValInf	)
ResetArr(@aVendDw3	)
ResetArr(@aRateio   )
ResetArr(@aCompFrt  )
ResetArr(@aMsgErr   )
ResetArr(@aVetItmRRE   )
ResetArr(@aVetBlq   )
ResetArr(@aVetBlqRRE   )
ResetArr(@aVetMsgRRE   )
ResetArr(@aVetBlqDVP   )
ResetArr(@aVetMsgDVP   )
ResetArr(@aPrdDP    )
ResetArr(@aPrdDPDet    )
ResetArr(@aPerFix   )
ResetArr(@aItRat    )
ResetArr(@aVetPes   )
ResetArr(@aPreview  )
ResetArr(@aPEPvw    )
ResetArr(@aValInfAc )
ResetArr(@aJobThr	)
ResetArr(@aStruct	)
ResetArr(@aObs		)

Return( lRet )

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200THG≥ Autor ≥Adalberto S.M          ≥ Data ≥24.10.2014≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Funcao responsavel por efetuar a geracao dos documentos de ≥±±
±±≥          ≥ transporte												  ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Function TMSA200Ger( aPrm200THR, aJobThr, cJobThr, cJobFile, cCliDev, cLojDev, nCountThr, nQtdMnt,;
					 nThreads,	 aVisErr, lThread, nCont1, nQtdDef, nQtdDif, lFim1, lFim2, nQtdRst,cSemaforo)

Local nX		:= 1
Local nIpcCount := 1

Default aPrm200THR	:= {}
Default aJobThr		:= {}
Default aVisErr		:= {}
Default cJobThr		:= ""
Default cJobFile	:= ""
Default cCliDev		:= ""
Default cLojDev		:= ""
Default nCountThr	:= 0
Default nQtdMnt		:= 0
Default nThreads	:= 0
Default lThread		:= .F.
Default nCont1 		:= 0
Default nQtdDef 	:= 0
Default nQtdDif 	:= 0
Default lFim1 		:= .F.
Default lFim2 		:= .F.
Default nQtdRst 	:= 0
Default cSemaforo	:= ""

If	lThread

	//--------------------------------------------------------------------------------
	//-- Tratamento para verificar se existe thread disponÌvel para processamento
	//--------------------------------------------------------------------------------
	For nX := 1 To NTRYMAX

		//----------------------------------------------------------------------
		//-- Verifico se existe Thread disponÌvel para realizar a chamada do IPCGO
		//----------------------------------------------------------------------
		nIpcCount := IPCCount( cSemaforo )
		If nIpcCount > 0
			IPCGo( cSemaforo, aClone(aPrm200THR) )
			Exit
			//---------------------------------------------------------------------------
			//-- Caso n„o exista Thread aguardo um perÌodo antes de tentar novamente o IPCGO
			//---------------------------------------------------------------------------
		Else
			Sleep( 120 )
		Endif
	Next nX

	ResetArr(@aPrm200THR,.T.)
	aPrm200THR := {}

Else
	TMSA200THG( @aPrm200THR )
	//-- Recupera erros encontrados no processamento.
	If	Len(aPrm200THR[ Len(aPrm200THR), 33]) > 0
		AaddMsgErr(aPrm200THR[ Len(aPrm200THR), 33],  @aVisErr)
	EndIf
	ResetArr(@aPrm200THR,.T.)
	aPrm200THR := {}
EndIf

Return( Nil )
/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200THE≥ Autor ≥Adalberto S.M          ≥ Data ≥14.04.2011≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Funcao responsavel por efetuar a geracao dos documentos com≥±±
±±≥          ≥ base na quebra existente na funcao TmsA200Grv(). Essa fun- ≥±±
±±≥          ≥ cao tambem eh responsavel por instanciar as threads caso o ≥±±
±±≥          ≥ sistema esteja configurado para sua utilizacao.            ≥±±
±±≥          ≥ ( MV_TMSTHRC maior que ZERO )                              ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Function TMSA200THE( cSemaforo , cEmp , cFil , cJobThr , cJobFile , cAuxLote )
Local nCont1  	:= 0
Local aThrDoc 	:= {}
Local uParm1
Local cExit		:= ""
Local aAux		:= {}
Local aMsgErr	:= {}

Default cSemaforo	:= ""
Default cEmp		:= ""
Default cFil		:= ""
Default cJobThr		:= ""
Default cJobFile	:= ""
DEfault cAuxLote	:= ""

//-- Abre o ambiente
RpcSetType(3)
RpcSetEnv( cEmp, cFil,,,'TMS')
cLotePosic	:= cAuxLote

PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )

BEGIN SEQUENCE

	While !KillApp()

		//-----------------------------------------------------------------
		//-- Vari·vel global
		//-----------------------------------------------------------------
		PutGlbValue(cJobThr, "BEGIN" )

		If IpcWaitEx(cSemaforo,10000, @uParm1, @cExit )

			If cExit == "EXIT"
				TmsSQlExec( cJobFile, aMsgErr )
				PutGlbValue( cJobThr , "EXIT" )

				Exit
			Else

				PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )

				For nCont1 := 1 To Len(uParm1)
					ResetArr(@aThrDoc , .T. )

					aAdd(aThrDoc, aClone(uParm1[nCont1]))

					PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )

					aAux	:= TMSA200THG( aClone(aThrDoc), cJobThr )

					PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )

					If Len(aAux) > 0
						Aadd( aMsgErr , aClone(aAux) )
						aAux	:= {}
					EndIf
				Next nCont1

				If Len(uParm1) > 0
					ResetArr(@uParm1 , .T. )
				EndIf

				If Len(aMsgErr) > 500
					TmsSQlExec( cJobFile, aMsgErr )
					ResetArr(@aMsgErr , .T. )
					aMsgErr	:= {}
				EndIf

				PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )

			EndIf

		EndIf

	EndDo

END SEQUENCE

ResetArr(@aAux		)
ResetArr(@aMsgErr	)
ResetArr(@aThrDoc 	)

Return(Nil)

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200THG≥ Autor ≥Adalberto S.M          ≥ Data ≥14.04.2011≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Funcao responsavel por efetuar a geracao dos documentos com≥±±
±±≥          ≥ base na quebra existente na funcao TmsA200Grv(). Essa fun- ≥±±
±±≥          ≥ cao tambem eh responsavel por instanciar as threads caso o ≥±±
±±≥          ≥ sistema esteja configurado para sua utilizacao.            ≥±±
±±≥          ≥ ( MV_TMSTHRC maior que ZERO )                              ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Function TMSA200THG( aPrm200THR , cJobThr )

Static cTMSMFat
Static cIncISS
Static lCAT83
Static lD2Aglut
Static __aAvalCred	:= {}

Local nRet	   		:= 0
Local nCntPro  		:= 0
Local nPos	   		:= 0
Local nPos2   		:= 0
Local nPosProd 		:= 0
Local nPosTes 		:= 0
Local nPosItem 		:= 0
Local nPosPrcVen 	:= 0
Local nPosTotal 	:= 0
Local nPosPrUnit 	:= 0
Local nPosPPrc 		:= 0
Local nPosValICM	:= 0
Local nPosBasICM	:= 0
Local nPosICMRet	:= 0
Local nPosValIss	:= 0
Local nPosBasIss	:= 0
Local n1Cnt			:= 0
Local n2Cnt			:= 0
Local n3Cnt			:= 0
Local nSeek			:= 0
Local nValFre  		:= 0
Local nQuant   		:= 0
Local nMoeda		:= 1
Local nPrcVen  		:= 0
Local nAlqICM		:= 0
Local nPerISS		:= 0
Local nAliqISS 		:= 0
Local nLinSol 		:= 0
Local nPosPISS 		:= 0
Local lCalMin		:= .F.
Local lRegPorComp	:= .T.
Local l1oPerc  		:= .F.
Local lPedido  		:= .T.
Local lAvalCred		:= .T.
Local lPrdCIF  		:= .F.
Local lCalcISS		:= .F.
Local lErroGrv 		:= .F.
Local lRetCalISS	:= .F.
Local aTmCalFr 		:= {}
Local aRegra   		:= {}
Local aVendDw3 		:= {}
Local aItens		:= {}
Local aCab			:= {}
Local aLinha   		:= {}
Local aTmsA200		:= {}
Local aMsgErr		:= {}
Local bFatSE1		:= {|| }
Local bTTS
Local cCdrOri  		:= ''
Local cCliDev  		:= ''
Local cLojDev  		:= ''
Local cNumCot  		:= ''
Local cCdrDes  		:= ''
Local cServic  		:= ''
Local cPrdImp  		:= ''
Local cTipoPrd 		:= ''
Local cCodISS  		:= ''
Local cTipCar  		:= ''
Local cBlTms   		:= ''
Local cCliente 		:= ''
Local cLoja			:= ''
Local cLotNfc  		:= ''
Local cSerTms  		:= ''
Local cTipTra  		:= ''
Local cCliRem  		:= ''
Local cLojRem  		:= ''
Local cCliDes  		:= ''
Local cLojDes  		:= ''
Local cTpFrete 		:= ''
Local cDocTms  		:= ''
Local cTipFre  		:= ''
Local cCdrCal  		:= ''
Local cTipNFC		:= ''
Local cSeqIns  		:= ''
Local cTesEsp  		:= ''
Local cTes 			:= ''
Local cF4_ISS  		:= ''
Local cTipLot  		:= ''
Local cSerCte  		:= ''
Local cFilSX5		:= ''
Local cCodMsg  		:= ''
Local cEstDes  		:= ''
Local cTipoNF  		:= ''
Local cNfOri   		:= ''
Local cSeriOri 		:= ''
Local cItemOri		:= ''
Local cVendSA1 		:= ''
Local cTipoCli		:= ''
Local cA1_INCISS	:= ''
Local cEstDev  		:= ''
Local cEstVei  		:= ''
Local cRecISS  		:= ''
Local cEstRem  		:= ''
Local cCondPag 		:= ''
Local cIncISS		:= ''
Local cItem  		:= ''
Local cConta  		:= ''
Local cUniMed  		:= ''
Local cSegUm  		:= ''
Local cLocPad  		:= ''
Local cDscPro  		:= ''
Local cNumCmp  		:= ''
Local cNumPed		:= ''
Local cCliExp 		:= ''
Local cLojExp  		:= ''
Local cCliRec 		:= ''
Local cLojRec  		:= ''
Local cCliCal  		:= ''
Local cLojCal  		:= ''
Local cDocFat  		:= ''
Local cNumSol  		:= ''
Local cFilSol  		:= ''
Local cSerPed  		:= ''
Local cSqEDes		:= ''
Local cMVALIQISS	:= SuperGetMv("MV_ALIQISS",,0)
Local cMVICPAUTA	:= SuperGetMv("MV_ICPAUTA", .F., "1")
///////////////////////////////////////////////
// Variaveis que receberam valores vindos da //
// funcao que invocara a thread (TmsA200Grv) //
///////////////////////////////////////////////
Local cTaxCtr  		:= ''
Local cEstOri		:= ''
Local cEstCal  		:= ''
Local cTipoFrt  	:= ''
Local cCodPro  		:= ''
Local cCodProIT		:= ''
Local cJobFile		:= ''
Local cEmp	   		:= ''
Local cFil			:= ''
Local nQtdVol  		:= 0
Local nValor   		:= 0
Local nPeso	   		:= 0
Local nPesoM3  		:= 0
Local nMetro3  		:= 0
Local nSeguro  		:= 0
Local nNfCTRC  		:= 0
Local nQtdUni  		:= 0
Local nCntFor 		:= 0
Local nTipImp  		:= 0
Local nPerImp 		:= 0
Local nPesLiq 		:= 0
Local nPesoCob		:= 0
Local nLenThr		:= 0
Local lTM200QBR		:= .F.
Local lTaxa	   		:= .F.
Local lRecalculo	:= .F.
Local lUltimo  		:= .F.
Local lConsig		:= .F.
Local lCalImp		:= .F.
Local lRefatur		:= .F.
Local lClient  		:= .F.
Local lThread		:= .F.
Local lMayIUseDisk	:= .F.
Local aProduto		:= {}
Local aTipCar		:= {}
Local nTotFreteP	:= 0
Local aNfCTRC  		:= {}
Local aValInf  		:= {}
Local aTmsA500 		:= {}
Local aFrete   		:= {}
Local aVisErr  		:= {}
Local aNumDoc		:= {}
Local aICMSol		:= {}
Local aPerfil		:= {}
Local aNFS  		:= {}
Local aDocto  		:= {}
Local dDataOri		:= CToD('  /  /  ')
Local dDataDoc		:= CToD('  /  /  ')
Local aPeItens		:= {}
Local lAgrISS 		:= .F.  //Nova Regra para calcula ISS
Local cCodNeg        := ""
Local lAgrISS 		:= .F.
Local lF4_AgrISS 	:= .F.	//Nova Regra para calcula ISS
Local aMsgAux		:= {}
Local nX			:= 0
Local lFretInf      := .F.
Local nContFrt      := 0
Local nTotFre       := 0

Default aPrm200THR 	:= {}
Default cJobThr		:= ""

If Type("lTmsCFec") <> "U"
	Private lTmsCFec  := .F.
EndIf
PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )

nLenThr		:= Len(aPrm200THR)
cTaxCtr		:= aPrm200THR[ nLenThr,  1]
cEstOri		:= aPrm200THR[ nLenThr,  2]
cEstCal		:= aPrm200THR[ nLenThr,  3]
cTipoFrt	:= aPrm200THR[ nLenThr,  4]
cCodPro		:= aPrm200THR[ nLenThr,  5]
cCodProIT	:= aPrm200THR[ nLenThr,  6]
nQtdVol		:= aPrm200THR[ nLenThr,  7]
nValor		:= aPrm200THR[ nLenThr,  8]
nPeso		:= aPrm200THR[ nLenThr,  9]
nPesoM3		:= aPrm200THR[ nLenThr, 10]
nMetro3		:= aPrm200THR[ nLenThr, 11]
nSeguro		:= aPrm200THR[ nLenThr, 12]
nNfCTRC		:= aPrm200THR[ nLenThr, 13]
nQtdUni		:= aPrm200THR[ nLenThr, 14]
nCntFor		:= aPrm200THR[ nLenThr, 15]
nTipImp		:= aPrm200THR[ nLenThr, 16]
nPerImp		:= aPrm200THR[ nLenThr, 17]
nPesLiq		:= aPrm200THR[ nLenThr, 18]
lTM200QBR	:= aPrm200THR[ nLenThr, 19]
lTaxa		:= aPrm200THR[ nLenThr, 20]
lRecalculo	:= aPrm200THR[ nLenThr, 21]
lUltimo		:= aPrm200THR[ nLenThr, 22]
lConsig		:= aPrm200THR[ nLenThr, 23]
lCalImp		:= aPrm200THR[ nLenThr, 24]
lRefatur	:= aPrm200THR[ nLenThr, 25]
lClient		:= aPrm200THR[ nLenThr, 26]
lThread		:= aPrm200THR[ nLenThr, 27]
aProduto	:= aPrm200THR[ nLenThr, 28]
aNfCTRC		:= aPrm200THR[ nLenThr, 29]
aValInf		:= aPrm200THR[ nLenThr, 30]
aTmsA500	:= aPrm200THR[ nLenThr, 31]
aFrete		:= aPrm200THR[ nLenThr, 32]
aVisErr		:= aPrm200THR[ nLenThr, 33]
aNumDoc		:= aPrm200THR[ nLenThr, 34]
aICMSol		:= aPrm200THR[ nLenThr, 35]
aPerfil		:= aPrm200THR[ nLenThr, 36]
aNFS		:= aPrm200THR[ nLenThr, 37]
aDocto		:= aPrm200THR[ nLenThr, 38]
cJobFile	:= aPrm200THR[ nLenThr, 40]
cEmp		:= aPrm200THR[ nLenThr, 41]
cFil		:= aPrm200THR[ nLenThr, 42]
nPesoCob	:= aPrm200THR[ nLenThr, 43]
aPedBlq		:= aPrm200THR[ nLenThr, 44]
dDataDoc	:= aPrm200THR[ nLenThr, 45]
lIsImpDoc	:= aPrm200THR[ nLenThr, 46]
nPerISS		:= aPrm200THR[ nLenThr, 47]
cIncISS		:= aPrm200THR[ nLenThr, 48]

nMoeda		:= aDocto[nCntFor,10,44]
l1oPerc		:= aDocto[nCntFor,10,20]
cCdrOri		:= aDocto[nCntFor,10,23]
cCliDev		:= aDocto[nCntFor,6]
cLojDev		:= aDocto[nCntFor,7]
cNumCot		:= aDocto[nCntFor,8]
cCdrDes		:= aDocto[nCntFor,10,7]
cServic		:= aDocto[nCntFor,1]
cPrdImp		:= aDocto[nCntFor,10,10]
cCliente	:= aDocto[nCntFor,10,5]
cLoja		:= aDocto[nCntFor,10,6]
cLotNfc		:= aDocto[nCntFor,10,16]
cSerTms		:= aDocto[nCntFor,10,32]
cTipTra		:= aDocto[nCntFor,10,22]
cCliRem		:= aDocto[nCntFor,10,18]
cLojRem		:= aDocto[nCntFor,10,19]
cCliDes		:= aDocto[nCntFor,4]
cLojDes		:= aDocto[nCntFor,5]
cTpFrete	:= aDocto[nCntFor,10,9]
cDocTms		:= aDocto[nCntFor,10,3]
cTipFre		:= aDocto[nCntFor,10,4]
cCdrCal		:= aDocto[nCntFor,10,31]
cTipNFC		:= aDocto[nCntFor,12]
cSeqIns		:= aDocto[nCntFor,16]
cTipLot		:= aDocto[nCntFor,20]
cCondPag	:= aDocto[nCntFor,10,8]
cUniMed		:= aDocto[nCntFor,10,11]
cSegUm		:= aDocto[nCntFor,10,12]
cLocPad		:= aDocto[nCntFor,10,13]
cDscPro		:= aDocto[nCntFor,10,14]
cCliCal		:= aDocto[nCntFor,10,34]
cLojCal		:= aDocto[nCntFor,10,35]
cFilSol		:= aDocto[nCntFor,14]
cNumSol		:= aDocto[nCntFor,11]
cSqEDes		:= aDocto[nCntFor,15]
cCliExp		:= aDocto[nCntFor,29]
cLojExp		:= aDocto[nCntFor,30]
lFretInf    := aDocto[nCntFor,35]
cRetira		:= aDocto[nCntFor,36]

//-- Inclus„o do campo recebedor...
If DT6->(ColumnPos("DT6_CLIREC")) .And. DT6->(ColumnPos("DT6_LOJREC"))
	cCliRec := aDocto[nCntFor,33]
	cLojRec := aDocto[nCntFor,34]
EndIf

cDocFat		:= aPerfil[47]

cCodNeg     := aDocto[nCntFor,31]
cNumCmp     := Iif(Len(aDocto[nCntFor]) >= 32, aDocto[nCntFor,32], "")

If lThread
	cUserName	:= aPrm200THR[ nLenThr, 49]
	__cUserId	:= aPrm200THR[ nLenThr, 50]
EndIf

lAgrISS 	:= SF4->(ColumnPos("F4_AGRISS")) > 0 //Nova Regra para calcula ISS
lF4_AgrISS 	:= SF4->(ColumnPos("F4_AGRISS")) > 0 .And. SF4->F4_AGRISS == "1"	//Nova Regra para calcula ISS
lTmsCFec 	:= TmsCFec()
cItem    	:= StrZero(0,Len(SC6->C6_ITEM)) //-- Aglutina itens da tabela SD2 ou SC6 ao efetuar Calculo de Frete e Geracao de Fatura

If ValType(lTM200BICM) == "U"
	lTM200BICM  := ExistBlock("TM200BICM")
EndIf
If ValType(lTM200TES) == "U"
	lTM200TES	:= ExistBlock("TM200TES")
EndIf
If ValType(lPETM200D) == "U"
	lPETM200D	:= ExistBlock("TM200DT")
EndIf
If ValType(lCalISS) == "U"
	lCalISS		:= ExistBlock("TM200IISS")	//-- Ponto de entrada para utilizar a funÁ„o TMSA040IMP
EndIf

If ValType(cTMSMFat) == "U"
	cTMSMFat	:= SuperGetMv("MV_TMSMFAT",,"") //-- Modo de Faturamento:1-Faturamento a partir do SE1;2=Faturamento a partir do DT6
EndIf
If ValType(cIncISS) == "U"
	cIncISS		:= Iif(SuperGetMv("MV_INCISS"),"S","N") //-- TES Incide ISS (S/N)
EndIf
If ValType(lCAT83) == "U"
	lCAT83		:= SuperGetMV("MV_CAT8309",,.T.)
EndIf
If ValType(lD2Aglut) == "U"
	lD2Aglut	:= SuperGetMv("MV_TMSAGD2",,.F.)
EndIf

If	nMoeda == 0
	nMoeda := 1
EndIf

dDataOri  := dDataBase	//-- database original
dDataBase := dDataDoc	//-- data definida na exec. da rotina origem

//-- Ponto de entrada para alterar database antes do calculo do frete
If lPETM200D
	dDataBase := ExecBlock("TM200DT",.F.,.F.,dDataBase)
	If ValType(dDataBase) # "D"
		dDataBase := dDataOri
	EndIf
EndIf

PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )
//-- Ponto de entrada para calcular componentes com valores especificos
//(so chamara o ponto de entrada para alterar o valor se o ctrc nao for proveniente de cotacao)
If	lTM200QBR .And. Empty(cNumCot)
	PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )
	For nCntPro := 1 To Len(aProduto)
		//-- Parametros passados para o ponto de entrada
		//-- [01]			= Vetor com a composicao do frete
		//-- [02 ate 10]	= Base de calculo
		//-- [11]			= Codigo do cliente devedor
		//-- [12]			= Loja do cliente devedor
		//-- [13]			= Codigo da regiao de origem
		//-- [14]			= Codigo da regiao de destino
		//-- [15]			= Codigo do produto
		//-- [16]			= Codigo do servico de negociacao
		//-- [17]			= Tabela de Frete
		//-- [18]			= Tipo da Tabela de Frete
		//-- [19]			= Sequencia da Tabela de Frete
		//-- [20]			= Notas Fiscais (aNfCTRC)
		//-- [21]			= Codigo da Negociacao
		aTmCalFr:=ExecBlock('TM200QBR',.F.,.F.,{aProduto[nCntPro,2],nQtdVol,nValor,nPeso,nPesoM3,nMetro3,nSeguro,nNfCTRC,nQtdUni,aDocto[nCntFor,10,42],cCliDev,cLojDev,cCdrOri,cCdrDes,aProduto[nCntPro,1],cServic,aDocto[nCntFor,10,28],aDocto[nCntFor,10,29],aDocto[nCntFor,10,30],aNfCTRC,cCodNeg})
		If	ValType(aTmCalFr)=='A'
			//-- Formato do vetor aTmCalFr. Retorno do ponto de entrada TM200QBR
			//-- [01] = Codigo do componente
			//-- [02] = Valor do componente
			//-- Preenche o vetor aret com o retorno do ponto de entrada
			DT3->(dbSetOrder(1)) //DT3_FILIAL+DT3_CODPAS
			For nRet := 1 To Len(aTmCalFr)
				If	ValType(aTmCalFr[nRet,1])=='C' .And. ValType(aTmCalFr[nRet,2])=='N'
					//-- Pesquisa o componente no vetor aFrete
					nSeek := AScan(aProduto[nCntPro,2],{|x|x[3]==aTmCalFr[nRet,1]})
					If	nSeek <= 0
						//-- Posiciona o componente de frete
						If DT3->(!MsSeek(xFilial('DT3') + aTmCalFr[nRet,1]))
							Loop
						EndIf
						AAdd( aProduto[nCntPro,2], { '', 0, '', '', 0, 0, Space(Len(cCdrOri)), Space(Len(cCdrDes)), '', '', '','00', 0, 0 , StrZero(2,Len(DT8->DT8_CALMIN)) } )
						nSeek := Len(aProduto[nCntPro,2])
						aProduto[nCntPro,2,nSeek,01] := AllTrim(DT3->DT3_DESCRI)
					EndIf
					aProduto[nCntPro,2,nSeek,02] := aTmCalFr[nRet,2]
					aProduto[nCntPro,2,nSeek,03] := aTmCalFr[nRet,1]
					aProduto[nCntPro,2,nSeek,15] := StrZero(2,Len(DT8->DT8_CALMIN))
				EndIf
			Next nRet
		EndIf
	Next nCntPro
	aFrete := {}
	nValFre:= 0
	//-- Composicao do frete
	//-- Aglutino a composicao de frete de cada produto no vetor a frete
	For nCntPro := 1 To Len(aProduto)
		For nRet := 1 To Len(aProduto[nCntPro,2])
			//-- Somente componentes diferente de zero e diferente da linha totalizadora. TF = Total Frete
			If	aProduto[nCntPro,2,nRet,2] > 0 .And. aProduto[nCntPro,2,nRet,3] <> 'TF'
				nSeek := ASCan(aFrete,{|x|x[3] == aProduto[nCntPro,2,nRet,3] } )
				If Empty(nSeek)
					AAdd(aFrete,AClone( aProduto[nCntPro,2,nRet] ))
					nValFre += aProduto[nCntPro,2,nRet,2]
				Else
					lTaxa := TMSAComTax(aFrete[nSeek,3])
					//-- Taxa por documento 1=Sim, todos os documentos serao taxados
					//-- Taxa por documento 2=Nao, somente o ultimo documento sera taxado, Soma do valor do frete se no ultimo item do array
					If	cTaxCtr == StrZero(1,Len(DUO->DUO_TAXCTR)) .Or. !lTaxa .Or. (cTaxCtr == StrZero(2,Len(DUO->DUO_TAXCTR)) .AND. (nCntPro == Len(aProduto)))
						aFrete[nSeek,2]+=aProduto[nCntPro,2,nRet,2]
						aFrete[nSeek,5]+=aProduto[nCntPro,2,nRet,5]
						aFrete[nSeek,6]+=aProduto[nCntPro,2,nRet,6]
						nValFre += aProduto[nCntPro,2,nRet,2]
					EndIf
				EndIf
			EndIf
		Next nRet
	Next nCntPro
EndIf
lRegPorComp := .T.

PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )
//-- Verifica se o produto possui rastro ou endereco.
If (nPos := Ascan(__aPrdImp, { |x| x[1] == cPrdImp })) == 0
	SB1->(dbSetOrder(1))
	If SB1->(MsSeek(xFilial("SB1")+cPrdImp))
		cTipoPrd := SB1->B1_TIPO
		cCodISS  := SB1->B1_CODISS
		cConta   := SB1->B1_CONTA
		AAdd( __aPrdImp, { SB1->B1_COD, cTipoPrd, ( RetFldProd(cPrdImp,"B1_LOCALIZ") == "S" .Or. SB1->B1_RASTRO <> "N" ) , cCodISS, cConta } )
		nPos     := Len(__aPrdImp)
	EndIf
Else
	cTipoPrd := __aPrdImp[nPos,2]
	cCodISS  := __aPrdImp[nPos,4]
	cConta   := __aPrdImp[nPos,5]
EndIf

//-- Verifica se devera ser gerado pedido.
If (nPos2 := Ascan(__aAvalCred, { |x| x[1] == cCliDev+cLojDev })) == 0
	If !Empty(aFrete)
		For nContFrt := 1 To Len(aFrete)
			nTotFre += aFrete[nContFrt][2]
		Next nContFrt
	EndIf
	lAvalCred := MaAvalCred(cCliDev,cLojDev,nTotFre,,.F.) //-- Avalia credito do devedor
	AAdd( __aAvalCred, { cCliDev+cLojDev, lAvalCred } )
Else
	lAvalCred := __aAvalCred[nPos2,2]
EndIf
PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )
If lAvalCred
	If Empty(cBlTms := TmsA200Blq(nValFre,cCliente,cLoja,l1oPerc,cLotNfc,cServic,cSerTms,;
		cTipTra,nQtdVol,nValor,nPeso,nPesoM3,nMetro3,nSeguro,nQtdUni,aValInf,Empty(aTmsA500),;
		lRecalculo,aNfCTRC,cCliRem,cLojRem,cCliDes,cLojDes,cCodNeg)) //-- Avalia bloqueio do TMS
		//-- Verifica se o produto possui rastro ou endereco.
		lPedido := __aPrdImp[nPos,3]
	EndIf
EndIf

//-- Forca para nao gerar pedido quando for importacao do documento
If lPedido .And. Len(aNumDoc) > 0
	lPedido := .F.
EndIf
If cTpFrete == 'C' //-- CIF
	DUI->(dbSetOrder(1))
	If DUI->(MsSeek(xFilial('DUI')+cDocTms)) .And. !Empty(DUI->DUI_PRDCIF)
		cPrdImp := DUI->DUI_PRDCIF
		SB1->(dbSetOrder(1))
		If SB1->(MsSeek(xFilial("SB1")+cPrdImp))
			cCodISS := SB1->B1_CODISS
			cConta  := SB1->B1_CONTA
		EndIf
	EndIf
EndIf

//-- Busca o estado do veÌculo quando o lote possuir viagem vinculada
If !(cDocTms$'7/6/D') //-- Devoluc„o/Reentrega
	If !Empty(DTP->DTP_VIAGEM)
		DTR->(dbSetOrder(1))
		If DTR->(MsSeek(xFilial('DTR')+DTP->DTP_FILORI+DTP->DTP_VIAGEM))
			DA3->(dbSetOrder(1))
			If DA3->(MsSeek(xFilial("DA3")+DTR->DTR_CODVEI))
				cEstVei := DA3->DA3_ESTPLA
			EndIf
		EndIf
	EndIf
EndIf

PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )
//-- Frete da Pauta - Art. 87 Insiso XXXI ß 27 do RICMS/RN (http://www.set.rn.gov.br/set/leis/regulamentoicms.asp)
If SuperGetMv("MV_ICPAUTA", .F., "1")=="2"
	//-- Acumula Pesos x Tipo de Carga
	For nCntPro := 1 To Len(aProduto)
		cTipCar := ""
		SB1->(DbSetOrder(1)) //B1_FILIAL+B1_COD
		If	SB1->(MsSeek(xFilial('SB1') + aProduto[nCntPro][1], .F.))
			cTipCar := SB1->B1_TIPCAR
		EndIf
		nPos := aScan(aTipCar, { |x| x[ 1 ] == cTipCar } )
		If nPos == 0
			aAdd(aTipCar, {cTipCar, 0 })
			nPos := Len(aTipCar)
		EndIf
		aTipCar[nPos,2] += aProduto[nCntPro][4]
	Next nCntPro
	//-- Calcula base ICMS sobre pauta de frete para cada Tipo de Carga
	nTotFreteP := 0
	CriaVar('M->C5_KM',     .F.)
	CriaVar('M->C5_PBRUTO' ,.F.)
	CriaVar('M->C5_VLR_FRT',.F.)
	For nCntPro := 1 To Len(aTipCar)
		cTipCar := aTipCar[nCntPro, 1]
		M->C5_PBRUTO  := aTipCar[nCntPro, 2]
		M->C5_KM      := nKmP
		M->C5_VLR_FRT := 0
		//-- Funcao que verifica uso de Pauta Frete
		If FindFunction("a545FreteP")
			a545FreteP(cTipCar, Space(TamSX3("DV9_UF")[1]))
		Else
			a410FreteP()
		EndIf
		nTotFreteP += M->C5_VLR_FRT
	Next nCntPro
	M->C5_VLR_FRT := nTotFreteP
EndIf

//-- Preenche aCab e aItens para gerar o documento
If !Empty(aFrete)
	PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )
	For n2Cnt := 1 To Len(aFrete)
		PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )

		//-- Verifica se o componente eh taxa
		lTaxa := TMSAComTax(aFrete[n2Cnt,3])

		//-- Taxa por documento 1=Sim, todos os documentos serao taxados
		//-- Taxa por documento 2=Nao, somente o ultimo documento sera taxado, Soma do valor do frete se no ultimo item do array
		If	cTaxCtr == StrZero(1,Len(DUO->DUO_TAXCTR)) .Or. !lTaxa .Or. (cTaxCtr == StrZero(2,Len(DUO->DUO_TAXCTR)) .AND. lUltimo)
			//-- Analisa a regra de tributacao
			//-- Se Encontrar na Regra algum componente cadastrado, analisa a regra para todos os componentes
			//-- do Frete, caso contrario, executara' a TMSRegTrib() uma unica vez, pois a regra de tributacao
			//-- sera' a mesma para todos os componentes.
			If lRegPorComp
				aRegra:= {}

				//-- Pesquisa primeiro a Regra de Tributacao por Produto
				If !Empty(cCodProIT) .And. !lPrcProd
					aRegra  := TmsRegTrib(cDocTms,cTipFre,aFrete[n2Cnt,3],cCliente,cLoja,cCdrCal,,cCodProIT,@lRegPorComp,cEstOri,lConsig,cTipNFC,cSeqIns,cEstVei)
				EndIf

				If Len(aRegra) == 0
					aRegra  := TmsRegTrib(cDocTms,cTipFre,aFrete[n2Cnt,3],cCliente,cLoja,cCdrCal,,cCodPro,  @lRegPorComp,cEstOri,lConsig,cTipNFC,cSeqIns,cEstVei)
				EndIf

				If	! Empty( aRegra )
					If lTM200TES
						cTesEsp := ExecBlock('TM200TES',.F.,.F.,{aNFCTRC, cCliRem, cLojRem, aRegra[ 1 ], aFrete[n2Cnt,3], cCliDev, cLojDev })
						If ValType(cTesEsp) == "C" .And. !Empty(cTesEsp)
							aRegra[ 1 ] := cTesEsp
						EndIf
					EndIf

					cTes    := aRegra[ 1 ]
					cF4_ISS := aRegra[ 3 ]

					//-- Inicio - Se Lote for Eletronico
					If cTipLot == StrZero(3,Len(DTP->DTP_TIPLOT)) .Or. cTipLot == StrZero(4,Len(DTP->DTP_TIPLOT))

						If lTM200SCTE .And. Empty(cSerCte)
							cSerCte := ExecBlock("TM200SCTE",.F.,.F.,{cCliDev,cLojDev,cDocTms,cTes})
							If Valtype(cSerCte) <> "C"
								cSerCte := ""
							EndIf
						EndIf

						cFilSX5		:= xFilial("SX5")
						If lCHGSX5FIL
							cFilSX5 := ExecBlock("CHGX5FIL",.F.,.F.)
						EndIf

						cSerCte := Padr(cSerCte,Len(DUI->DUI_SERIE))

						//-- Verifica se a serie esta cadastrada na tabela 01 - Series de notas fiscais.
						SX5->(dbSetOrder(1))
						If !Empty(cSerCte)
							If	SX5->(!MsSeek(cFilSX5 + "01" + cSerCte, .F.))
								Help( ' ', 1, 'TMSA20020',,STR0029 + cSerCte,5,1)	//-- Serie nao encontrada na tabela 01 - Serie de N. Fiscais. (SX5)###"Serie :"
								cSerCte := ""
							EndIf
						EndIf
					EndIf
					//-- Fim - Se Lote for Eletronico

					If	Empty( cCodMsg )
						cCodMsg := aRegra[ 2 ]
					EndIf

					//-- Se o Faturamento for a partir do DT6, nao permitir utilizar um TES que gere duplicata
					SF4->(dbSetOrder(1))
					If SF4->(MsSeek(xFilial('SF4')+cTes))
						If !lCalcISS .And. SF4->F4_ISS == 'S'
							lCalcISS := .T.
						EndIf
					EndIf
				Else
					//-- Seta a variavel para .T., para que valide novamente a funcao TmsRegTrib()
					lPedido     := .T.
					lRegPorComp := .T.

					If Ascan( aMsgErr, { |x| x[ 2 ] == '22' } ) == 0
						//cEstDes := Posicione("DUY",1,xFilial("DUY")+cCdrDes,"DUY_EST")
						TMSA200CdRg(cCdrDes)   //Posiciona no grupo de Regiao
						cEstDes := DUY->DUY_EST
						DUG->(DbSetOrder(1))
						//--Posiciona na TES
						If (DUG->(MsSeek(xFilial('DUG')+DUF->DUF_REGTRI+DUF->DUF_TIPFRE)))
							cTes := DUG->DUG_TES
						EndIf
						SF4->(DbSetOrder(1))
						If SF4->(MsSeek(xFilial('SF4')+cTes))
							If	SF4->F4_MSBLQL == '1' .And. !Empty(cTes) //--TES Bloqueadas nao podem ser utilizadas.
								AAdd( aMsgErr, {STR0164 + cTes , '22', "TMSA410()" } )
								lErroGrv := .T.
							Else
								AAdd( aMsgErr, {STR0058 + cDocTms + ' / ' + STR0015 + cCliente + ' - ' + cLoja + ' / ' + STR0059 + cEstOri + ' / ' + STR0060 + cEstDes + ' / ' + STR0049 + TMSRetCbx('DUF_TIPFRE',cTipFre), '22', "TMSA410()" } ) //"Regra de Tributacao Nao Encontrada ... Docto.Transp: "
								lErroGrv := .T.
							EndIf
						EndIf
					EndIf

					Loop
				EndIf
			EndIf

			If !Empty(aTMSA500) .And. Len(aTMSA500) >= 9
				cTipoNF  := aTMSA500[9]
				cNfOri   := aTMSA500[5]
				cSeriOri := aTMSA500[6]
				cItemOri := StrZero(1, Len(SD2->D2_ITEM))
				nQuant   := 1
			Else
				cTipoNF  := "N"
				nQuant   := 1
			EndIf

			PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )
			//-- Tipo do Cliente Destinatario - Conforme solicitacao do bops 102588
			TMSA200Cli( cCliDes, cLojDes)   //posiciona na tabela SA1
			cTipoCli	:= SA1->A1_TIPO

			//-- Cliente Devedor
			TMSA200Cli( cCliDev, cLojDev)   //posiciona na tabela SA1
			cA1_INCISS	:= Iif(SA1->A1_INCISS == "S","S","N")
			cEstDev		:= SA1->A1_EST

			//-- Filial de Negociacao Cliente
			DW3->(dbSetOrder(1))
			If DW3->(MsSeek(xFilial("DW3") + cCliDev + cLojDev + cTipTra))
				For nPos := 1 To __nVendTms
					If nPos == 1
						AAdd( aVendDw3, DW3->DW3_VEND  )
					Else
						AAdd( aVendDw3, &('DW3->DW3_VEND' + Str(nPos,1) )  )
					EndIf
				Next nPos
			Else
				cVendSA1 := SA1->A1_VEND //-- Cliente Devedor
			EndIf

			If  Empty(aCab) .And. !Empty(aDocto[nCntFor][21])
				cRecISS := aDocto[nCntFor][21]//Recolhe ISS 1 = sim , 2 = nao
			Else
				cRecISS := SA1->A1_RECISS //-- Cliente Devedor
			EndIf

			If !lPedido
				PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )
				//-- Cliente Remetente
				TMSA200Cli( cCliRem, cLojRem )    //posiciona na tabela SA1
				cEstRem := SA1->A1_EST

				//-- Quando a transportadora estiver no parana e o devedor for o parana,
				//   a aliquota e CFOP sera tratada para o parana.
				If cMv_Estado == "PR" .And. cEstRem == "PR" .And. cEstDev == "PR"
					cEstOri := "PR"
				EndIf

				If Empty( aCab )
					AAdd( aCab, { 'F2_FILIAL'	, xFilial("SF2")		, Nil } )
					AAdd( aCab, { 'F2_CLIENTE'	, cCliDev				, Nil } )
					AAdd( aCab, { 'F2_LOJA'		, cLojDev				, Nil } )
					AAdd( aCab, { 'F2_TIPO'		, cTipoNF				, Nil } )
					AAdd( aCab, { 'F2_TIPOCLI'	, cTipoCli				, Nil } )
					AAdd( aCab, { 'F2_COND'		, cCondPag				, Nil } )
					AAdd( aCab, { 'F2_VOLUME1'	, nQtdVol				, Nil } )
					AAdd( aCab, { 'F2_PLIQUI'	, nPeso					, Nil } )
					AAdd( aCab, { 'F2_PBRUTO'	, nPeso					, Nil } )
					AAdd( aCab, { 'F2_EMISSAO'	, dDataBase				, Nil } )
					AAdd( aCab, { 'F2_HORA'		, SubStr(Time(),1,5)	, Nil } )
					AAdd( aCab, { 'F2_REGIAO'	, cCdrCal				, Nil } )
					AAdd( aCab, { 'F2_EST'		, cEstCal				, Nil } )
					AAdd( aCab, { 'F2_NFORI'	, cNfOri				, Nil } )	// NF Origem
					AAdd( aCab, { 'F2_SERIORI'	, cSeriOri				, Nil } )	// Serie da NF Origem
					AAdd( aCab, { 'F2_ITEMORI'	, cItemOri				, Nil } )	// Item da NF Origem
					AAdd( aCab, { 'F2_RECISS'	, cRecIss				, Nil } )	// Recolhe ISS
					AAdd( aCab, { 'F2_MOEDA'	, nMoeda				, Nil } )
					AAdd( aCab, { 'F2_CLIENT'	, cCliDes				, Nil } )	//--Cliente Destinatario
					AAdd( aCab, { 'F2_LOJENT'	, cLojDes				, Nil } )	//--Loja Destinatario
					If Len(aVendDw3) > 0		// Vendedor da Filial de Negociacao ou do Cliente
						For nPos := 1 To __nVendTms
							AAdd( aCab, { 'F2_VEND' + Str(nPos,1)		, aVendDw3[nPos]	, Nil } )
						Next nPos
					Else
						AAdd(aCab,{'F2_VEND1',cVendSa1 , Nil } )
					EndIf
				EndIf

				aLinha  := {}
				nPrcVen := A410Arred(aFrete[n2Cnt,2],"C6_PRCVEN")

				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Calculo do Preco com ISS                                                ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				//-- Quando for chamado pelo rotina ImpDoc, nao deve recalcular os impostos.
				//-- Ponto de entrada para utilizar a funÁ„o TMSA040IMP
				//-- para calcular o ISS conforme calculo efetuado
				//-- na COTA«√O DO FRETE seguindo a ordem de
				//-- ISS no Produto > Regi„o > MV_ALIQISS.
				If(lCalISS) .And. nTipImp == 0
					lRetCalISS := ExecBlock("TM200IISS",.F.,.F.,{aFrete,cDocTms})
					If (Valtype(lRetCalISS)!="L")
						lRetCalISS := .F.
					EndIf
					PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )
					If (lRetCalISS)
						//--//////////////////////////////////////////////////////////////
						//--|Funcao TMSA040IMP utilizada para calcular o ISS corretamente|
						//--|conforme calculo efetuado na COTACAO DO FRETE seguindo a    |
						//--|ordem de ISS no Produto > Regi„o > MV_ALIQISS. CH: SCQDTY.  |
						//--//////////////////////////////////////////////////////////////
						//-- Verifica se foi informado alicota de ISS para o produto.
						TmsA040Imp( aFrete, cCliDev, cLojDev, cDocTms, cTipFre, cCdrDes, .T.,@nAlqICM, /*FilDes*/, /*Pessoa*/, ;
						, cCdrOri, /*FilOri*/, /*IncISS*/, cCliRem, cLojRem, cCliDes, cLojDes, cTipoNF)
						If !Empty(aFrete[ n2Cnt, 5 ])
							nPerISS := nAlqICM
						EndIf
						//-- Verifica se j· foi calculado o ISS para o produto.
						If Empty(aFrete[ n2Cnt, 5 ])
							//-- Verifica se foi informada a aliquota do ISS para regiao.
							//nAliqISS := Posicione("DUY",1,xFilial("DUY")+cCdrCal,"DUY_ALQISS")
							TMSA200CdRg(cCdrCal)   //Posiciona no grupo de Regiao
							nAliqISS := DUY->DUY_ALQISS
							//-- Verifica se foi informado alicota de ISS no par‚metro.
							If nAliqISS == 0 .And. !Empty(cMVALIQISS)
								nPerISS := cMVALIQISS
							Else
								nPerISS := nAliqISS
							EndIf
						EndIf
					EndIf
				EndIf
				DbSelectArea("SF4")

				If cF4_ISS == "S"
					If (SF4->(ColumnPos('F4_AGRISS'))) > 0
						If Empty(SF4->F4_AGRISS)
							If cIncISS == "N" .And. cA1_INCISS == "N"
								nPrcVen := a410Arred(nPrcVen/(1-(nPerISS/100)),"D2_PRCVEN")
							Else
								If aFrete[n2Cnt,6] > 0
									nPrcVen := A410Arred(aFrete[n2Cnt,6],"D2_PRCVEN")
								Else
									nPrcVen := A410Arred(aFrete[n2Cnt,2],"D2_PRCVEN")
								EndIf
							EndIf
						EndIf
					Else
						If cIncISS == "N" .And. cA1_INCISS == "N"
							nPrcVen := a410Arred(nPrcVen/(1-(nPerISS/100)),"D2_PRCVEN")
						Else
							If aFrete[n2Cnt,6] > 0
								nPrcVen := A410Arred(aFrete[n2Cnt,6],"D2_PRCVEN")
							Else
								nPrcVen := A410Arred(aFrete[n2Cnt,2],"D2_PRCVEN")
							EndIf
						EndIf
					EndIf
				EndIf

				If lD2Aglut
					If !Empty(aItens)
						nPosProd := aScan( aItens[Len(aItens)] , {|x| x[1] = 'D2_COD' } )
						nPosTes  := aScan( aItens[Len(aItens)] , {|x| x[1] = 'D2_TES' } )
						nPosItem := AScan( aItens, {|x| x[nPosProd][2] = cPrdImp .And. x[nPosTes][2] = cTes } )
					EndIf
					If	nPosItem > 0
						nPosPrcVen := aScan( aItens[nPosItem] , {|x| x[1] == 'D2_PRCVEN' } )
						nPosTotal  := aScan( aItens[nPosItem] , {|x| x[1] == 'D2_TOTAL'  } )
						nPosPrUnit := aScan( aItens[nPosItem] , {|x| x[1] == 'D2_PRUNIT' } )
						nPosValICM := aScan( aItens[nPosItem] , {|x| x[1] == 'D2_VALICM' } )
						nPosBasICM := aScan( aItens[nPosItem] , {|x| x[1] == 'D2_BASEICM'} )
						nPosICMRet := aScan( aItens[nPosItem] , {|x| x[1] == 'D2_ICMSRET'} )
						nPosValISS := aScan( aItens[nPosItem] , {|x| x[1] == 'D2_VALISS' } )
						nPosBasIss := aScan( aItens[nPosItem] , {|x| x[1] == 'D2_BASEISS' } )
					EndIf
				EndIf

				If nPosItem == 0
					cItem := SomaIt( cItem )
					AAdd( aLinha, { 'D2_FILIAL'		, xFilial("SD2")	, Nil } )	// Filial
					AAdd( aLinha, { 'D2_TIPO'		, cTipoNF			, Nil } )	// Tipo
					AAdd( aLinha, { 'D2_CLIENTE'	, cCliDev			, Nil } )	// Cliente
					AAdd( aLinha, { 'D2_LOJA'		, cLojDev			, Nil } )	// Loja
					AAdd( aLinha, { 'D2_ITEM'		, cItem				, Nil } )	// Item
					AAdd( aLinha, { 'D2_COD'		, cPrdImp			, Nil } )	// Material
					AAdd( aLinha, { 'D2_TP'			, cTipoPrd			, Nil } )	// Tipo do Material
					AAdd( aLinha, { 'D2_UM'			, cUniMed			, Nil } )	// Unidade de medida
					AAdd( aLinha, { 'D2_SEGUM'		, cSegUm			, Nil } )	// Segunda unidade de medida
					AAdd( aLinha, { 'D2_LOCAL'		, cLocPad			, Nil } )	// Armazem padrao
					AAdd( aLinha, { 'D2_SERVIC'		, cServic			, Nil } )	// Servico
					AAdd( aLinha, { 'D2_QUANT'		, nQuant			, Nil } )	// Quantidade
					AAdd( aLinha, { 'D2_PRCVEN'		, nPrcVen			, Nil } )	// Preco unitario
					AAdd( aLinha, { 'D2_TOTAL'		, nPrcVen			, Nil } )	// Valor total do item
					AAdd( aLinha, { 'D2_PRUNIT'		, nPrcVen			, Nil } )	// Preco unitario
					AAdd( aLinha, { 'D2_EMISSAO'	, dDataBase			, Nil } )	// Emissao
					AAdd( aLinha, { 'D2_EST'		, cEstCal			, Nil } )	// Estado
					AAdd( aLinha, { 'D2_TES'		, cTes				, Nil } )	// TES
					AAdd( aLinha, { 'D2_ALIQISS'	, nPerISS			, Nil } )	// Aliq. ISS
					AAdd( aLinha, { 'D2_NFORI'		, cNfOri			, Nil } )	// NF Origem
					AAdd( aLinha, { 'D2_SERIORI'	, cSeriOri			, Nil } )	// Serie da NF Origem
					AAdd( aLinha, { 'D2_ITEMORI'	, cItemOri			, Nil } )	// Item da NF Origem
					AAdd( aLinha, { 'D2_CONTA'		, cConta			, Nil } )	// Conta Contabil
					AAdd( aLinha, { 'D2_CODISS'		, cCodISS			, Nil } )	// Codigo do ISS
					//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
					//≥ Atualiza CAT/83                                         ≥
					//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
					If lCAT83
						AAdd( aLinha, { 'D2_CODLAN'	,IIF(cTes == SF4->F4_CODIGO,SF4->F4_CODLAN,Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CODLAN"))	, Nil	} )		// Codigo do CAT/83
					EndIf

					//-- Utilizado em rotinas que importam o documento
					If nTipImp > 0 .And. !lCalImp
						If nTipImp == 1 //-- ICMS
							nPosPPrc := Ascan(aLinha,{ | e | e[1] == 'D2_PRCVEN' } )
							If nPosPPrc > 0
								aLinha[nPosPPrc,2] := aFrete[n2Cnt,2]
							EndIf
							AAdd( aLinha, { 'D2_PICM',		Iif(aFrete[n2Cnt,5] > 0,nPerImp,0),			Nil	} )	// Percentual do imposto ICMS
							AAdd( aLinha, { 'D2_VALICM',	aFrete[n2Cnt,5],	Nil	} )	// Valor do imposto ICMS
							AAdd( aLinha, { 'D2_BASEICM',	aFrete[n2Cnt,6],	Nil	} )	// Valor total com imposto
							If (nLinSol := Ascan(aICMSol,{|x| x[1] == aFrete[n2Cnt,3]})) > 0 .And. !Empty(aICMSol[nLinsol,2])
								AAdd( aLinha, { 'D2_ICMSRET'  , aICMSol[nLinsol,2] , Nil } )
							EndIf
						ElseIf nTipImp == 2 //-- ISS
							nPosPPrc := Ascan(aLinha,{ | e | e[1] == 'D2_PRCVEN' } )
							If nPosPPrc > 0
								aLinha[nPosPPrc,2] := aFrete[n2Cnt,2]
							EndIf
							nPosPISS := Ascan(aLinha,{ | e | e[1] == 'D2_ALIQISS' } )
							If nPosPISS > 0
								aLinha[nPosPISS,2] := nPerImp
							EndIf
							AAdd( aLinha, { 'D2_VALISS',	aFrete[n2Cnt,5],	Nil	} )	// Valor do imposto ISS
							AAdd( aLinha, { 'D2_BASEISS',	aFrete[n2Cnt,6],	Nil	} )	// Valor total com imposto
						EndIf
					EndIf
					AAdd(aItens,AClone(aLinha))
				Else
					aItens[nPosItem][nPosPrcVen][2] += nPrcVen
					aItens[nPosItem][nPosTotal ][2] += nPrcVen
					aItens[nPosItem][nPosPrUnit][2] += nPrcVen
					If nTipImp > 0 .And. !lCalImp
						If nTipImp == 1 //-- ICMS
							If nPosPrcVen > 0
								aItens[nPosItem][nPosPrcVen][2] += aFrete[n2Cnt,2]
							EndIf
							aItens[nPosItem][nPosValICM][2] += aFrete[n2Cnt,5]
							aItens[nPosItem][nPosBasICM][2] += aFrete[n2Cnt,6]
							If (nLinSol := Ascan(aICMSol,{|x| x[1] == aFrete[n2Cnt,3]})) > 0 .And. !Empty(aICMSol[nLinsol,2])
								aItens[nPosItem][nPosICMRet][2] += aICMSol[nLinsol,2]
							EndIf
						ElseIf nTipImp == 2 //-- ISS
							If nPosPrcVen > 0
								aItens[nPosItem][nPosPrcVen][2] += aFrete[n2Cnt,2]
							EndIf
							aItens[nPosItem][nPosValIss][2] += aFrete[n2Cnt,5]
							aItens[nPosItem][nPosBasIss][2] += aFrete[n2Cnt,6]
						EndIf
					EndIf
				EndIf
			Else
				If Empty( aCab )
					If cIncISS == "N" .And. cA1_INCISS == "S"
						cIncISS := "S"
					EndIf

					AAdd( aCab, { 'C5_CLIENTE'		,	cCliDev			, Nil } )
					AAdd( aCab, { 'C5_LOJAENT'		,	cLojDev			, Nil } )
					AAdd( aCab, { 'C5_LOJACLI'		,	cLojDev			, Nil } )
					AAdd( aCab, { 'C5_TIPO'			,	cTipoNF			, Nil } )
					AAdd( aCab, { 'C5_TIPOCLI'		,	cTipoCli		, Nil } )
					AAdd( aCab, { 'C5_TABELA'		,	'1'				, Nil } )
					AAdd( aCab, { 'C5_DESC1'		,	0				, Nil } )
					AAdd( aCab, { 'C5_DESC2'		,	0				, Nil } )
					AAdd( aCab, { 'C5_DESC3'		,	0				, Nil } )
					AAdd( aCab, { 'C5_DESC4'		,	0				, Nil } )
					AAdd( aCab, { 'C5_TPCARGA'		,	'1'				, Nil } )
					AAdd( aCab, { 'C5_CONDPAG'		,	cCondPag		, Nil } )
					AAdd( aCab, { 'C5_VOLUME1'		,	nQtdVol			, Nil } )
					AAdd( aCab, { 'C5_KM'			,	nKmP			, Nil } )
					AAdd( aCab, { 'C5_PESOL'		,	nPeso			, Nil } )
					AAdd( aCab, { 'C5_PBRUTO'		,	nPeso			, Nil } )
					AAdd( aCab, { 'C5_TPFRETE'		,	cTpFrete		, Nil } )
					AAdd( aCab, { 'C5_INCISS'		,	cIncISS			, Nil } )
					AAdd( aCab, { 'C5_MOEDA'		,	nMoeda			, Nil } )
					AAdd( aCab, { 'C5_RECISS'		,	cRecISS			, Nil } )
					AAdd( aCab, { 'C5_CLIENT'		,	cCliDes			, Nil } )
					AAdd( aCab, { 'C5_LOJAENT'		,	cLojDes			, Nil } )
					If cMVICPAUTA == "2"
						AAdd( aCab, { 'C5_VLR_FRT'		,	M->C5_VLR_FRT	, Nil } )
					EndIf

					//-- Tratamento de regra de tributacao para o cliente.
					If lTm200Fis
						AAdd( aCab, { 'C5_GRPCLI', ExecBlock("TM200FIS",.f.,.f., { cCliDev, cLojDev, 1, .T. } ) , Nil } )
					EndIf

					//-- Codigo da Natureza
					DC5->(dbSetOrder(1)) //DC5_FILIAL+DC5_SERVIC+DC5_ORDEM
					DC5->(MsSeek(xFilial("DC5")+cServic))
					AAdd( aCab, { 'C5_NATUREZ',DC5->DC5_NATURE , Nil } )

					If Len(aVendDw3) > 0		// Vendedor da Filial de Negociacao ou do Cliente
						For nPos := 1 To __nVendTms
							AAdd( aCab, { 'C5_VEND' + Str(nPos,1)		, aVendDw3[nPos]		, Nil } )
						Next nPos
					Else
						AAdd(aCab,{'C5_VEND1',cVendSa1 , Nil } )
					EndIf
				EndIf

				aLinha  := {}
				nPrcVen := A410Arred(aFrete[n2Cnt,2],"C6_PRCVEN")

				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Calculo do Preco com ISS                                                ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				If cF4_ISS == "S"
					If !( cIncISS == "N" .And. cA1_INCISS  == "N" )
						If aFrete[n2Cnt,6] > 0
							nPrcVen := A410Arred(aFrete[n2Cnt,6],"C6_PRCVEN")
						EndIf
					EndIf
				EndIf

				If lD2Aglut
					If !Empty(aItens)
						nPosProd := aScan( aItens[Len(aItens)] , {|x| x[1] = 'C6_PRODUTO' } )
						nPosTes  := aScan( aItens[Len(aItens)] , {|x| x[1] = 'C6_TES' } )
						nPosItem := AScan( aItens, {|x| x[nPosProd][2] = cPrdImp .And. x[nPosTes][2] = cTes } )
					EndIf
					If nPosItem > 0
						nPosPrcVen := aScan( aItens[nPosItem] , {|x| x[1] = 'C6_VALOR'   } )
						nPosPrUnit := aScan( aItens[nPosItem] , {|x| x[1] = 'C6_PRCVEN'  } )
					EndIf
				EndIf

				If nPosItem == 0
					cItem := SomaIt( cItem )
					AAdd(aLinha,{'C6_ITEM'		, cItem		,Nil})	//-- Item
					AAdd(aLinha,{'C6_PRODUTO'	, cPrdImp	,Nil})	//-- Material
					AAdd(aLinha,{'C6_UM'		, cUniMed	,Nil})	//-- Unidade de medida
					AAdd(aLinha,{'C6_SEGUM'		, cSegUm	,Nil})	//-- Segunda unidade de medida
					AAdd(aLinha,{'C6_LOCAL'		, cLocPad	,Nil})	//-- Armazem padrao
					AAdd(aLinha,{'C6_DESCRI'	, cDscPro	,Nil})	//-- Descricao do material
					AAdd(aLinha,{'C6_VALOR'		, nPrcVen	,Nil})	//-- Valor total do item
					AAdd(aLinha,{'C6_ENTREG'	, dDataBase	,Nil})	//-- Data da entrega
					AAdd(aLinha,{'C6_PEDCLI'	, cNumCot	,Nil})	//-- Numero do pedido do cliente
					AAdd(aLinha,{'C6_QTDVEN'	, nQuant	,Nil})	//-- Quantidade
					AAdd(aLinha,{'C6_PRCVEN'	, nPrcVen	,Nil})	//-- Preco unitario
					AAdd(aLinha,{'C6_SERVIC'	, cServic	,Nil})	//-- Servico
					AAdd(aLinha,{'C6_TES'		, cTes		,Nil})	//-- TES
					AAdd(aLinha,{'C6_CODISS'	, cCodISS	,Nil})	//-- Codigo do ISS

					//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
					//≥ Atualiza CAT/83                                         ≥
					//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
					If lCAT83
						AAdd(aLinha,{'C6_CODLAN',IIF(cTes == SF4->F4_CODIGO,SF4->F4_CODLAN,Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CODLAN"))	,Nil})		// Codigo do CAT/83
					EndIf
					If	Empty(aTmsA500) .Or. cDocTms == "8"
						AAdd(aLinha,{'C6_QTDLIB', 1					,Nil})		// Quantidade liberada
					Else
						//-- Ao confirmar a geracao do documento, o sistema nao pode gerar bloqueio de credito, entao o
						//-- pedido de venda eh gerado com quantidade liberada igual a zero, para o sistema nao criar SC9 e
						//-- antes de gerar o SF2/SD2 chamo a funcao MaLibDoFat() com parametros para nao avaliar credito.
						AAdd(aLinha,{'C6_QTDLIB', 0					,Nil})		// Quantidade liberada
					EndIf
					//-- Aliquota do ISS
					AAdd( aLinha, { 'C6_ALIQISS'	,	nPerISS , Nil } )
					AAdd(aItens,AClone(aLinha))
				Else
					aItens[nPosItem][nPosPrcVen][2] += nPrcVen
					aItens[nPosItem][nPosPrUnit][2] += nPrcVen
				EndIf
			EndIf

			//-- Ponto de entrada criado para alterar a base de ICMS.
			If	lTM200BICM
				aPeItens := ExecBlock('TM200BICM',.F.,.F.,{aItens})
				If ValType(aPeItens) == "A"
					aItens := aPeItens
				EndIf
			EndIf

			//-- Guarda o numero do item, que sera gravado posteriormente no DT8_ITEMD2
			For n3Cnt := 1 To Len(aProduto)
				nSeek := ASCan(aProduto[n3Cnt,2],{|x|x[3]==aFrete[n2Cnt,3]})
				If nSeek > 0
					If nPosItem > 0 .And. lD2Aglut
						aProduto[n3Cnt,2,nSeek,4] := StrZero(nPosItem, Len(SD2->D2_ITEM))
					Else
						aProduto[n3Cnt,2,nSeek,4] := cItem
					EndIf
				EndIf
			Next
		EndIf
	Next

	If !lErroGrv

		PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )
		//-- Numero da composicao
		If !lRefatur .And. ( Empty(cNumCmp) .Or. aDocto[nCntFor,10,39] <> "1" ) //-- Agrupa Notas Fiscais
			cNumCmp := GetSX8Num( 'DT6', 'DT6_NUMCMP',, 9 )
			If __lSX8
				ConfirmSX8()
			EndIf
		EndIf

		//-- Gera Documento
		cNumPed 	:= ""
		aTmsA200	:= {}
		AAdd(aTmsA200,cNumPed)						//-- 01 Pedido
		AAdd(aTmsA200,cCliDev)						//-- 02 Cliente devedor
		AAdd(aTmsA200,cLojDev)						//-- 03 Loja
		AAdd(aTmsA200,aDocto[nCntFor,10,16])		//-- 04 Lote
		AAdd(aTmsA200,IIF(Empty(cSerCte),aDocto[nCntFor,10,17],cSerCte))	//-- 05 Serie do documento
		AAdd(aTmsA200,AClone(aTmsA500))				//-- 06 Parametros passados pelo tmsa500
		AAdd(aTmsA200,AClone(aProduto))				//-- 07 Composicao de frete e Nf do cliente por produto
		AAdd(aTmsA200,aDocto[nCntFor,10,18])		//-- 08 Cliente remetente
		AAdd(aTmsA200,aDocto[nCntFor,10,19])		//-- 09 Loja
		AAdd(aTmsA200,aDocto[nCntFor,10,20])		//-- 10 l1oPerc .T. = documento primeiro percurso
		AAdd(aTmsA200,.T.)							//-- 11 lAtzPed .T. = Grava DT8/DT6
		AAdd(aTmsA200,lUltimo)						//-- 12 Indica ultimo documento
		AAdd(aTmsA200,cTaxCtr)						//-- 13 Taxa por documento
		AAdd(aTmsA200,cCliDes)						//-- 14 Cliente destinatario
		AAdd(aTmsA200,cLojDes)						//-- 15 Loja
		AAdd(aTmsA200,aDocto[nCntFor,10,21])		//-- 16 Tipo de servico
		AAdd(aTmsA200,aDocto[nCntFor,10,22])		//-- 17 Tipo de transporte
		AAdd(aTmsA200,aDocto[nCntFor,10,23])		//-- 18 Regiao origem
		AAdd(aTmsA200,cCdrDes)						//-- 19 Regiao destino
		AAdd(aTmsA200,aDocto[nCntFor,10,24])		//-- 20 Cliente consignatario
		AAdd(aTmsA200,aDocto[nCntFor,10,25])		//-- 21 Loja
		AAdd(aTmsA200,aDocto[nCntFor,10,26])		//-- 22 Cliente consignatario
		AAdd(aTmsA200,aDocto[nCntFor,10,27])		//-- 23 Loja
		AAdd(aTmsA200,nQtdVol)						//-- 24 Qtde de volumes
		AAdd(aTmsA200,nValor)						//-- 25 Valor da mercadoria
		AAdd(aTmsA200,nPeso)						//-- 26 Peso real
		AAdd(aTmsA200,nPesoM3)						//-- 27 Peso cubado
		AAdd(aTmsA200,nMetro3)						//-- 28 Metro cubico
		AAdd(aTmsA200,nSeguro)						//-- 29 Base RR
		AAdd(aTmsA200,nQtdUni)						//-- 30 Qtde de unitizadores
		AAdd(aTmsA200,aDocto[nCntFor,10,28])		//-- 31 Tabela de frete
		AAdd(aTmsA200,aDocto[nCntFor,10,29])		//-- 32 Tipo da tabela de frete
		AAdd(aTmsA200,aDocto[nCntFor,10,30])		//-- 33 Sequencia da tabela de frete
		AAdd(aTmsA200,aDocto[nCntFor,10,31])		//-- 34 Codigo da regiao de calculo
		AAdd(aTmsA200,cTipoFrt)						//-- 35 Tipo do frete
		AAdd(aTmsA200,aDocto[nCntFor,10,32])		//-- 36 Nr. do contrato de prestacao de servicos
		AAdd(aTmsA200,cDocTms)						//-- 37 Tipo de documento
		AAdd(aTmsA200,aDocto[nCntFor,10,33])		//-- 38 Devedor do frete
		AAdd(aTmsA200,cServic)						//-- 39 Codigo do servico
		AAdd(aTmsA200,cCodMsg)						//-- 40 Codigo da Mensagem Fiscal
		AAdd(aTmsA200,cNumCmp)						//-- 41 Numero da composicao
		AAdd(aTmsA200,aDocto[nCntFor,10,34])		//-- 42 Codigo do cliente de calculo
		AAdd(aTmsA200,aDocto[nCntFor,10,35])		//-- 43 Loja do cliente de calculo
		AAdd(aTmsA200,nPesoCob)						//-- 44 Peso cobrado
		AAdd(aTmsA200,cPrdImp)						//-- 45 Produto de imposto
		AAdd(aTmsA200,aDocto[nCntFor,10,40])		//-- 46 Tipo do Veiculo
		AAdd(aTmsA200,aDocto[nCntFor,10,41])		//-- 47 Valor Informado
		AAdd(aTmsA200,aDocto[nCntFor,10,42])		//-- 48 Valor CTRC Despachante
		AAdd(aTmsA200,aDocto[nCntFor,10,8])			//-- 49 Condicao de Pagamento
		AAdd(aTmsA200,cSqEDes )						//-- 50 Sequencia do Endereco Destinatario
		AAdd(aTmsA200,nPesLiq )						//-- 51 Peso Liquido
		AAdd(aTmsA200,cCliExp)						//-- 52 Cliente Expedidor
		AAdd(aTmsA200,cLojExp)						//-- 53 Loja
		AAdd(aTmsA200,cCodNeg)						//-- 54 Codigo da Negociacao
		AAdd(aTmsA200,cCliRec)						//-- 55 Cliente Recebedor
		AAdd(aTmsA200,cLojRec)						//-- 56 Loja
		AAdd(aTmsA200,cRetira)						//-- 57 Retira
		PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )
		If cTMSMFat == '2'
			bFatSE1 := {|| .F. }

			//-- Obtem o perfil do cliente para verificar quais documentos possuem tratamento diferenciado no
			//-- faturamento:
			aPerfil := TmsPerfil(cCliCal,cLojCal,,,cCliRem,cLojRem,cCliDes,cLojDes)
			cDocFat := aPerfil[47]

			If AllTrim(cDocFat) <> '*' .And. (cDocTms $ cDocFat)
				bFatSE1 := {|| .T. }
			ElseIf AllTrim(cDocFat) == '*'
				bFatSE1 := {|| .T. }
			EndIf
		Else
			bFatSE1 := {|| .T. }
		EndIf

		PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )
		If !lPedido
			bTTS := {|| TMSA200Atu(aTmsA200,{},{},cNumNFS,cSerieNFS,bFatSE1,@aMsgErr) }
			PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )
			aNFS := TmsGeraDoc(	cCliDev, cLojDev, cDocTms, aItens, aCab, cCdrCal, cNumSol, lCalcISS, cEstOri, cEstCal,;
								cEstDev, cFilSol, bTTS, IIF(Empty(cSerCte),aDocto[nCntFor,10,17],cSerCte), bFatSE1, aNumDoc, cTipFre )
			If !Empty(aNFS)
				cNumPed     := aNFS[1]
				cSerPed     := aNFS[2]
				aTmsA200[1] := cNumPed
			EndIf
		EndIf

		PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )
		//-- Verifica a necessidade de gerar pedido
		If Empty(cNumPed)
			If cDocTms == "8"
				TMSPedido(aCab,aItens,3,, {|x|cNumPed:=x, .F.})
			Else
				TMSPedido(aCab,aItens,3, ,{|x|cNumPed:=x, Iif(Empty(aTmsA500),.T.,TmsA500Lib( cNumPed ))})
			EndIf
			aTmsa200[1] := cNumPed
		EndIf

		PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )
		If lPedido
			TmsA200Atz(aTmsA200,Empty(aTmsA500),cBlTms,cCdrCal,cNumSol,lCalcISS,cFilSol,bFatSE1,@aMsgErr)
		EndIf

		PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )
	EndIf
EndIf

If lThread
	PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )

	Aadd( aMsgAux , { cCliente , cLoja  }  )

	For nX := 1 To Len(aMsgErr)
		Aadd( aMsgAux , AClone( aMsgErr[nX] ) )
	Next nX

	aMsgErr		:= {}
	aMsgErr		:= AClone(aMsgAux)

Else
	//-- Retorna erros encontrados no processamento.
	aPrm200THR[ Len(aPrm200THR), 33] := AClone(aMsgErr)
EndIf

//-- Restaura a database do sistema
If lPETM200D
	dDataBase := dDataOri
EndIf

ResetArr(@aTmCalFr )
ResetArr(@aRegra   )
ResetArr(@aVendDw3 )
ResetArr(@aItens	)
ResetArr(@aCab		)
ResetArr(@aLinha   	)
ResetArr(@aTmsA200	)
ResetArr(@aNfCTRC  )
ResetArr(@aValInf  )
ResetArr(@aTmsA500 )
ResetArr(@aFrete   )
ResetArr(@aNumDoc	)
ResetArr(@aICMSol	)
ResetArr(@aNFS  )
ResetArr(@aProduto	)
ResetArr(@aTipCar	)
ResetArr(@aPeItens	)
Return aMsgErr

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200Atz≥ Autor ≥ Alex Egydio           ≥ Data ≥06.02.2002≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Atualiza documentos e executa a geracao de notas fiscais de≥±±
±±≥          ≥ saida                                                      ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA200Atz()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpA1 = Parametros da funcao                               ≥±±
±±≥          ≥ ExpL1 = .T. = Avalia Bloqueio de Transporte                ≥±±
±±≥          ≥ ExpC1 = Codigo do Bloqueio de Transporte                   ≥±±
±±≥          ≥ ExpC2 = Regiao de Calculo                                  ≥±±
±±≥          ≥ ExpC3 = No. Solicitacao de Coleta                          ≥±±
±±≥          ≥ ExpL2 = Indica de Calcula ISS ou nao                       ≥±±
±±≥          ≥ ExpC4 = Estado Origem                                      ≥±±
±±≥          ≥ ExpC5 = Estado Calculo                                     ≥±±
±±≥          ≥ ExpC6 = Estado Devedor                                     ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TmsA200Atz(aTmsA200,lBlTms,cBlTms,cCdrCal,cNumSol,lCalcISS,cFilSol,bFatSE1,aMsgErr)

Local aFrete	:= {}
Local aPedido	:= {}
Local aBlqDoc	:= {}
Local cSeek		:= ''
Local cNumPed	:= aTmsA200[1]
Local cCliDev	:= aTmsA200[2]
Local cLojDev	:= aTmsA200[3]
Local cLotNfc	:= aTmsA200[4]
Local cSerie	:= aTmsA200[5]
Local bA200Atu	:= {|| TMSA200Atu( aTmsA200,aFrete,aPedido,cNumNFS,,bFatSE1,aMsgErr) }
Local bA200Pvl	:= {|| .T. }
Local nSeek		:= 0
Local nValPas	:= 0			//-- Valor do frete sem imposto
Local cTexto	:= ""
Local cCliRem	:= aTmsA200[8]
Local cLojRem	:= aTmsA200[9]
Local cCliDes	:= aTmsA200[14]
Local cLojDes	:= aTmsA200[15]
Local cCdrOri	:= aTmsA200[18]
Local cEstDev
Local cEstRem
Local cEstOri
Local cEstCal
Local lInscr	:= .F.
Local cQuery	:= ""
Local cAliasQry	:= ""
Local aAreaSC9	:= SC9->(GetArea())

DEFAULT lBlTms	:= .F.
DEFAULT cBlTms	:= ''
DEFAULT cFilSol	:= cFilAnt
DEFAULT aMsgErr	:= {}

TMSA200Cli(cCliDev,cLojDev)  //posiciona no cliente/loja
cEstDev := SA1->A1_EST

TMSA200Cli(cCliRem,cLojRem)  //posiciona no cliente/loja
cEstRem := SA1->A1_EST

TMSA200CdRg(cCdrOri)   //Posiciona no grupo de Regiao
cEstOri := DUY->DUY_EST

TMSA200CdRg(cCdrCal)   //Posiciona no grupo de Regiao
cEstCal := DUY->DUY_EST

If cMv_Estado ==  ''
	cMv_Estado := SuperGetMV("MV_ESTADO",.F.,"")//O tratamento especÌfico abaixo para o estado do Parana foi retirado de acordo com conformidade do art. 11, II e IV da LC n∫ 87/96.
EndIf

//-- Grava o nr do lote no pedido
SC9->(DbSetOrder(2))
cAliasQry := GetNextAlias()
cQuery := "   SELECT C9_LOTNFC, C9_BLTMS, R_E_C_N_O_ C9_RECNO "
cQuery += "     FROM " + RetSqlName("SC9")
cQuery += "    WHERE C9_FILIAL  = '" + xFilial('SC9') + "' "
cQuery += "      AND C9_CLIENTE = '" + cCliDev + "' "
cQuery += "      AND C9_LOJA    = '" + cLojDev + "' "
cQuery += "      AND C9_PEDIDO  = '" + cNumPed + "' "
cQuery += "      AND D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY " + SqlOrder(SC9->(IndexKey()))
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
While (cAliasQry)->(!Eof())
	SC9->(MsGoto( (cAliasQry)->C9_RECNO ))
	RecLock('SC9',.F.)
	SC9->C9_LOTNFC := cLotNfc
	//-- Grava o bloqueio de transporte
	If	lBlTms .And. !Empty(cBlTms)
		SC9->C9_BLTMS := cBlTms
	EndIf
	MsUnLock()
	//-- Gravacao adicional no bloqueio de transporte
	If	lTM200BLQ .And. lBlTms .And. !Empty(cBlTms)
		ExecBlock("TM200BLQ",.F.,.F.)
	EndIf
	(cAliasQry)->(DbSkip())
EndDo
(cAliasQry)->(DbCloseArea())

RestArea(aAreaSC9)

If lCalcISS .And. TM200Mun(cCdrCal,cFilSol,cNumSol)
	cTexto := 'MaFisAlt("NF_RECISS","2",nItem,.F.),'
EndIf

//----------------------------------------------------------------------
//O tratamento especÌfico abaixo para o estado do Parana foi retirado de
//acordo com conformidade do art. 11, II e IV da LC n∫ 87/96.
//-- Quando a transportadora estiver no parana e o devedor for o parana,
//   a aliquota e CFOP sera tratada para o parana.
//If cMv_Estado == "PR" .And. cEstRem == "PR" .And. cEstDev == "PR"
//	cEstCal := "PR"
//EndIf

cTexto += 'MaFisAlt("NF_UFORIGEM","'+cEstOri+'",nItem,.T.),MaFisAlt("NF_UFDEST","'+cEstCal+'",nItem,.T.)'

If !Empty(cCliDes) .And. !Empty(cLojDes)
	If TMSA200Cli( cCliDes, cLojDes)   //posiciona na tabela SA1

		lInscr := IIf((Empty(SA1->A1_INSCR).Or."ISENT"$SA1->A1_INSCR.Or."RG"$SA1->A1_INSCR).Or.SA1->A1_CONTRIB=="2",.T.,.F.)
		If lInscr
			cTexto += ',MaFisAlt("NF_LINSCR",.T.,nItem,.T.)'
		Else
			cTexto += ',MaFisAlt("NF_LINSCR",.F.,nItem,.F.)'
		EndIf
	EndIf
EndIf

bA200Pvl := &('{||'+cTexto+'}')

//-- Gera nota fiscal de saida a partir do TMS
TMSGeraNFS( cNumPed, cSerie, cCliDev, cLojDev, aPedido, bA200Atu, bA200Pvl, bFatSE1, aMsgErr )

ResetArr(@aFrete	)
ResetArr(@aPedido	)
ResetArr(@aBlqDoc	)

Return( Nil )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200Atu≥ Autor ≥ Eduardo de Souza      ≥ Data ≥ 12/04/04 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Grava os documentos apos a geracao das notas de saida.     ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA200Atu()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpA1 = Vetor com a composicao de frete                    ≥±±
±±≥          ≥ ExpA1 = Vetor com a composicao de frete                    ≥±±
±±≥          ≥ ExpA4 = Vetor de pedidos com bloqueio de credito           ≥±±
±±≥          ≥ ExpCP = Numero do Documento                                ≥±±
±±≥          ≥ ExpCQ = Serie do Pedido                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TMSA200Atu(aTmsA200,aFrete,aPedido,cDocto,cSerPed,bFatSE1,aMsgErr)
Static __aFilDes := {}
Static __cUsrTms := ""
Static __nTamSX3 := 0

Local aAreaAnt   := GetArea()
Local aAreaDTC   := DTC->( GetArea() )
Local aAreaSC9   := SC9->( GetArea() )
Local aAreaSM0   := {}
Local aCliPrz    := {}
Local aProduto   := AClone(aTmsA200[7])
Local aTmpEnt    := {}
Local aTmsA500   := AClone(aTmsA200[6])
Local bCampo     := {|x| FieldName(x) }
Local cAlianca   := ''
Local cCliRem    := aTmsA200[8]
Local cLojRem    := aTmsA200[9]
Local cCliDes    := aTmsA200[14]
Local cLojDes    := aTmsA200[15]
Local cSqEDes    := aTmsA200[50]
Local cCliDev    := aTmsA200[2]
Local cLojDev    := aTmsA200[3]
Local cCliCal    := aTmsA200[42]
Local cLojCal    := aTmsA200[43]
Local cCliCon    := aTmsA200[20]
Local cLojCon    := aTmsA200[21]
Local cCliDpc    := aTmsA200[22]
Local cLojDpc    := aTmsA200[23]
Local cCodMsg    := aTmsA200[40]
Local cCodPro    := Space(Len(SB1->B1_COD))
Local cLotNfc    := aTmsA200[4]
Local cCdrOri    := aTmsA200[18]
Local cCdrDes    := aTmsA200[19]
Local cCdrCal    := aTmsA200[34]
Local cCdrPrz    := ""
Local dDataEnt   := dDataBase
Local cDevFre    := aTmsA200[38]
Local cDocTms    := aTmsA200[37]
Local cFilDeb    := ''
Local aDataBase  := {} //--Array da funcao FwTimeUF
Local cHoraBase  := StrTran(Left(Time(),5),':','')
Local dDT6DtBase := dDataBase
Local cNContr    := aTmsA200[36]
Local cNumCmp    := aTmsA200[41]
Local cNumPed    := PadR( Iif( Empty(aTmsA200[1]),cDocto,aTmsA200[1] ), Len(DT6->DT6_DOC) )
Local cPrefixo   := ''
Local cPrdImp    := aTmsA200[45]
Local cRedLocal  := ''
Local cSeek      := ''
Local cSerie     := aTmsA200[5]
Local cSerTms    := aTmsA200[16]
Local cServic    := aTmsA200[39]
Local cTabFre    := aTmsA200[31]
Local cTaxCtr    := aTmsA200[13]
Local cTipFre    := aTmsA200[35]
Local cTipTab    := aTmsA200[32]
Local cTipTra    := aTmsA200[17]
Local l1oPerc    := aTmsA200[10]
Local lAlianca   := TmsAlianca() //-- Verifica se utiliza Alianca
Local lAtzPed    := aTmsA200[11]
Local lUltimo    := aTmsA200[12]
Local lTM200DT6  := ExistBlock('TM200DT6')
Local lTM200Fim  := ExistBlock('TM200FIM')
Local lTM200DUD  := ExistBlock('TM200DUD')
Local lTM200SE1  := ExistBlock('TM200SE1')
Local lTm200DAT  := ExistBlock('Tm200DAT')
Local lTm200Prz  := ExistBlock('Tm200PRZ')
Local nCampos    := 0
Local nDocTms    := Len(DC5->DC5_DOCTMS)
Local nPercurso  := 0
Local nPesoCob   := aTmsA200[44]
Local nQtdVol    := aTmsA200[24]
Local nValBrut   := 0
Local nValMerc   := 0
Local nValTot    := 0
Local nValImp    := 0
Local nValor     := aTmsA200[25]
Local nPeso      := aTmsA200[26]
Local nPesoM3    := aTmsA200[27]
Local nMetro3    := aTmsA200[28]
Local nSeguro    := aTmsA200[29]
Local cSeqTab    := aTmsA200[33]
Local nQtdUni    := aTmsA200[30]
Local n1Cnt      := 0
Local n2Cnt      := 0
Local dDtEntr    := CToD('  /  /  ')
Local cHrEntr    := ''
Local dDtCol     := CToD('  /  /  ')
Local cHrCol     := ''
Local cFilOri    := ''
Local cNumSol    := ''
Local cRecebe    := ''
Local cFilCFS    := ''
Local aAJustRat  := {}
Local cAliasTRB  := ""
Local lTmsExp    := TmsExp()
Local c1DupRef   := SuperGetMv('MV_1DUPREF')
Local cTMSMFat   := SuperGetMV("MV_TMSMFAT",,"") //-- Modo de Faturamento:1-Faturamento a partir do SE1;2=Faturamento a partir do DT6
Local nPos       := 0
Local cCondPag   := ''
Local nValPas    := 0
Local aAreaSE1   := {}
Local aVenc      := {}
Local dUltVenc
Local cIncISS    := Iif(SuperGetMv('MV_INCISS'),'S','N') //-- TES Incide ISS (S/N)
Local cChave     := ""
Local cA1_INCISS := ""
Local cTipoNF    := ""
Local nValFat    := 0
Local aChvSD2    := {}
Local aRegiao    := {}
Local aRegRot    := {}
Local nElem      := {}
Local lAchou     := .F.
Local cObsDoc    := ""
Local nRecDVS    := 0
Local nLenProd   := 0
Local cZona      := ''
Local cSetor     := ''
Local cAliasDTC  := ''
Local cQuery     := ''
Local cAliasQry  := ''
Local cProduto   := ''
Local cFilAux    := ''
Local lFatSE1    := cTMSMFat == "1"
Local lTaxa      := .F.
Local nValCrdPre := 0
Local nD2CrdPre  := 0
Local nValTotSF3 := 0
Local aAreaSF3   := {}
Local aValCrdPre := {}
Local cFilDoc		:= If(Type("DT6->DT6_FILDOC") != 'U', DT6->DT6_FILDOC, "")
Local cDoc			:= If(Type("DT6->DT6_DOC") != 'U', DT6->DT6_DOC, "")

//-- Variaveis Internacional
Local nPesLiq    := aTmsA200[51]
Local cRota      := ''
Local cIncote    := ''
Local cNumCot    := ''
Local nSldFrt    := 0
Local nFrtPais   := 0
Local aFrtPais   := {}
Local nFrtDAF    := 0
Local aFrtDAF    := {}
Local cCodPas    := ''
Local nTotPas    := 0
Local nValCIF    := 0
Local nValFOB    := 0
Local nTF        := 0
Local nCnt       := 0
Local cFilDes    := ''
Local cSerDeb    := ''
Local aCampos    := {}
Local aAreaDT6   := {}
Local aAreaDT8   := {}
Local cSeekDT8   := ''
Local aCompPrd   := {}
Local nPosComp   := 0
Local cSeekDI9   := ''
Local cSeekDIA   := ''
Local cPaisDes   := ''
Local dNovaData  := CToD('  /  /  ')
Local nValPISCOF := 0
Local aCpoImpost := {}
Local nCpoImpost := 0
Local lTMSCTe    := SuperGetMv( "MV_TMSCTE", .F., .F. )		//-- Parametro do CT-e ativo.
Local cRotEnt    := Padr(GetMv("MV_ROTGENT",,""),Len(DTQ->DTQ_ROTA))
Local aRota      := {}
Local nRecDt8Ant := 0
Local nRecDt8Atu := 0
Local nVALIMP2   := 0
Local nVALIMP3   := 0
Local lHVerao    := SuperGetMV("MV_TMSHRVR",,.F.)	//-- Define se encontra-se no periodo de horario de verao.
Local cHVerFil   := SuperGetMV("MV_TMSHRFL",,"")	//-- Define Filiais que nao aderiram ao horario de verao e/ou possuem diferenca de fuso.
Local cUF        := cMV_Estado
Local nVal_Dif   := 0
Local aAreaSD2   := SD2->(GetArea())
Local lDocRee    := SuperGetMV('MV_DOCREE',,.F.) .And. TMSChkVer('11','R7')
Local lAgdEntr   := Iif(FindFunction("TMSA018Agd"),TMSA018Agd(),.F.)   //-- Agendamento de Entrega.
Local cCodEmit   := ""
Local cLojEmit   := ""
Local lCTeUnico  := Iif(DTP->DTP_TIPLOT == '4', TMSA200UNI(), .F.)
Local aValuesAGD := {} // Recebe os Itens do Agendamento de Entrega
Local cNumAgd    := "" // Recebe o numero do Agendamento de Entrega
Local aTabDest   := {} // Recebe os dados da tabela de frete por destinatario
Local lExecAGD   := .T.	// Agendamento de Entrega
Local cObsUni    := "Procedimento efetuado nos termos da Portaria CAT 121/2013" // Conteudo Gerado para CT-e Unico
Local aModFat    := {}
Local lExped     := DTC->(ColumnPos("DTC_CLIEXP")) > 0
Local lRecebedor := DTC->(ColumnPos("DTC_CLIREC")) > 0 .And. DT6->(ColumnPos("DT6_CLIREC")) .And. DT6->(ColumnPos("DT6_LOJREC")) > 0
Local cCodNeg    := Iif( Len(aTmsA200) >= 54 , aTmsA200[54], "" )
Local cCliExp    := ""
Local cLojExp    	:= ""
Local cCliRec    := ""
Local cLojRec    	:= ""
Local lF4_AgrISS 	:= SF4->(ColumnPos("F4_AGRISS")) > 0 .And. SF4->F4_AGRISS == "1"	//Nova Regra para calcula ISS
Local lAgrISS		:= .F.
Local lOriCal    	:= DT6->(ColumnPos('DT6_ORICAL')) > 0
Local lTMS3GFE   	:= Iif(FindFunction('TmsIntGFE'),TmsIntGFE('02'),.F.)
Local aRetGFE    	:= {}
Local nValDifal		:= 0
Local nVfcpDif		:= 0
Local nCrdTran		:= 0
Local nDifal 		:= 0
Local nICMSCOM      := 0
Local lErrDT8TOT    := .F.
Local cRetira 		:= ""
Local lRetira       := DT6->(ColumnPos("DT6_RETIRA")) > 0
Local cUfOri		:= ""
Local cIsenSub		:= GetMV("MV_ISENSUB",,"")

//-- Vari·veis para controle de diferenÁa de centavos
Local nLenAux       := 0
Local nDecValPas    := TamSx3("DT8_VALPAS")[2]
Local nDecValImp    := TamSx3("DT8_VALIMP")[2]
Local nDecValTot    := TamSx3("DT8_VALTOT")[2]
Local nDifValPas    := 0
Local nDifValImp    := 0
Local nDifValTot    := 0
Local nQtdDT8       := 0

Local lITmsDmd    := SuperGetMv("MV_ITMSDMD",,.F.)

//Utilizada pelo TMSA144, para viagens de Coleta e Entrega
Private lColeta   := .F.
Private aDifCr	  := {} 	//-- variavel com diferenca no rateio do credito presumido

DEFAULT cSerPed := 'PED'
DEFAULT aMsgErr := {}

Pergunte("TMA500",.F.)
If  MV_PAR03 == 1 .AND. IsInCallStack("TMSA500")  //GeraÁ„o por NF
	A200ReeDev(cfilDoc, cDoc,@aTmsA200)
EndIf
//-- CÛdigo do Expedidor
If Len(aTmsA200) > 51
	cCliExp	:= aTmsA200[52]
	cLojExp 	:= aTmsA200[53]
EndIf

If Len(aTmsA200) > 56
	cRetira	:= aTmsA200[57]
EndIf

//-- CÛdigo do Recebedor
If Len(aTmsA200) > 54
	cCliRec := aTmsA200[55]
	cLojRec := aTmsA200[56]
EndIf

If	__cUsrTms == ""
	__cUsrTms  := __cUserID
EndIf
If	__nTamSX3 == 0
	__nTamSX3 := TamSX3("DT6_VALIMP")[2]
EndIf

If	Len(cDocto) <> Len(DT6->DT6_DOC)
	cDocto := PadR(cDocto, Len(DT6->DT6_DOC) )
EndIf

If	lPrcProd ==  Nil
	lPrcProd := GetMV('MV_PRCPROD',,.T.)
EndIf

If	lPrdDiv ==  Nil
	// Verifica se permitira a inclusao de um ou mais produtos
	lPrdDiv := GetMV("MV_PRDDIV",,.F.)
EndIf

If	!Empty(aTmsA500)
	cCondPag := aTMSA500[8]
	If Len(aTMSA500) >= 9
		cTipoNF := aTMSA500[9]
	EndIf
Else
	cCondPag := aTMSA200[49]
EndIf

//-- ISS no Preco
TMSA200Cli( cCliDev, cLojDev)   //posiciona na tabela SA1
cA1_INCISS := Iif(SA1->A1_INCISS=="S","S","N")

//-- Busca data e hora de emissao do conhecimento - Data / Hora
If	!Empty(cHVerFil) .And. cFilAnt $ cHVerFil
	If	FindFunction("FwTimeUF")
		//-- Depois de oito anos sem adota-lo, o estado da Bahia, no Nordeste, o adotou em 2011.
		//-- Em 2012, no entanto, a Bahia voltou atras nessa decisao.
		cUF := IIF(cUF == "BA", "PE", cUF)
		aDataBase := FwTimeUF(cUF,,lHVerao)
		cHoraBase := StrTran(Left(aDataBase[2],5),':','')
		dDT6DtBase	:= STOD(aDataBase[1])
	EndIf
EndIf

Begin Transaction
	If !Empty(aTmsA500)
		//-- Obtem dados do cliente qd executado do programa manutencao de documentos
		cObsDoc := aTMSA500[11]
	EndIf
	//-- .T. = Grava DT6/DT8 somente na geracao de documentos
	//-- .F. = Nao grava DT6/DT8 quando for geracao de documentos a partir dos pedidos liberados
	If	lAtzPed
		//-- Exclui a composicao de frete
		DT8->(DbSetOrder(2))
		While DT8->(MsSeek(xFilial('DT8')+ cFilAnt + cNumPed + cSerPed))
			RecLock('DT8',.F.)
			DT8->(DbDelete())
			MsUnLock()
		EndDo

		//-- Grava a composicao de cada produto do documento
		aFrete   := {}
		nLenProd := 0
		aProduto := aSort( aProduto,,,{ |x,y| x[1] < y[1] } )

		//-- Verifica no array a maior quantidade de componentes.
		If Len(aProduto) > 0
			cCodPro := aProduto[1,1]
			For n1Cnt := 1 To Len(aProduto)
				If cCodPro == aProduto[n1Cnt,1]
					If	nLenProd <  Len(aProduto[n1Cnt,2])
						nLenProd := Len(aProduto[n1Cnt,2])
						nPos     := n1Cnt
					EndIf
				Else
					Exit
				EndIf
			Next n1Cnt
			If nPos > 0
				cCodPro := aProduto[nPos,1]
				AAdd(aFrete,{cCodPro,AClone(aProduto[nPos,2])})
				For n1Cnt := 1 To Len(aFrete[1,2])
					aFrete[1,2,n1Cnt,2] := 0 //-- Valor
					aFrete[1,2,n1Cnt,5] := 0 //-- Impostos
					aFrete[1,2,n1Cnt,6] := 0 //-- Total
				Next n1Cnt
			EndIf
		EndIf

		For n1Cnt := 1 To Len(aProduto)
			If cCodPro == aProduto[n1Cnt,1]
				For n2Cnt := 1 To Len(aProduto[n1Cnt,2])
					If (nPos := Ascan(aFrete[1,2], { |x| AllTrim(x[3]) == AllTrim(aProduto[n1Cnt,2,n2Cnt,3]) } )) > 0
						lTaxa := TMSAComTax(aFrete[1,2,nPos,3])
						//-- Taxa por documento 1=Sim, todos os documentos serao taxados
						//-- Taxa por documento 2=Nao, somente o ultimo documento sera taxado, Soma do valor do frete se no ultimo item do array
						If	(lTaxa .And. cTaxCtr == StrZero(1,Len(DUO->DUO_TAXCTR)))
							aFrete[1,2,nPos,2] := aProduto[n1Cnt,2,n2Cnt,2]
							aFrete[1,2,nPos,5] := aProduto[n1Cnt,2,n2Cnt,5]
							aFrete[1,2,nPos,6] := aProduto[n1Cnt,2,n2Cnt,6]
						ElseIf !lTaxa .Or. (cTaxCtr == StrZero(2,Len(DUO->DUO_TAXCTR)) .And. (n1Cnt == Len(aProduto)))
							aFrete[1,2,nPos,2] += aProduto[n1Cnt,2,n2Cnt,2]
							aFrete[1,2,nPos,5] += aProduto[n1Cnt,2,n2Cnt,5]
							aFrete[1,2,nPos,6] += aProduto[n1Cnt,2,n2Cnt,6]
						EndIf
					EndIf
				Next n2Cnt
			Else
				//-- grava a composicao de frete
				cChave  := xFilial("DT8")+cFilAnt+cNumPed+cSerPed+cCodPro
				TmsGrvDT8( 'TMSA200', cFilAnt, cNumPed, cSerPed, cTaxCtr, lUltimo, aFrete, ,2, cChave )
				aFrete  := {}
				cCodPro := aProduto[n1Cnt,1]
				AAdd(aFrete,{cCodPro,AClone(aProduto[n1Cnt,2])})
			EndIf
			//-- grava a composicao de frete
			If Len(aProduto) == n1Cnt
				cChave  := xFilial("DT8")+cFilAnt+cNumPed+cSerPed+cCodPro
				TmsGrvDT8( 'TMSA200', cFilAnt, cNumPed, cSerPed, cTaxCtr, lUltimo, aFrete, ,2, cChave )
			EndIf
		Next

		//-- Se informado Seq.Endereco para destinatario retornar codigo regiao para calculo do prazo de entrega
		cCdrPrz := cCdrDes
		If !Empty(cSqEDes)
			DUL->(dbSetOrder(2))
			If DUL->(MsSeek(xFilial("DUL") + cCliDes + cLojDes + cSqEDes) .And. !Empty(DUL_CDRDES))
				cCdrPrz := DUL->DUL_CDRDES
			EndIf
		EndIf
		//-- Se alterada regiao de calculo deve usar esta para calculo do prazo de entrega.
		If	cCdrDes <> cCdrCal
			cCdrPrz := cCdrCal
		EndIf
		//-- Obtem o cliente para calculo do prazo de entrega
		aCliPrz := TmsCliCalc( cCliRem, cLojRem, cCliDes, cLojDes, .T. )
		//-- Calcula tempo de entrega
		If	lTm200Prz
			dDtTM200 := ExecBlock('TM200PRZ',.F.,.F.,{cCdrOri,cCdrPrz,cTipTra,;
						Iif(Empty(aCliPrz),cCliDev,aCliPrz[1]),;
						Iif(Empty(aCliPrz),cLojDev,aCliPrz[2]),dDataEnt,cHoraBase,cCdrCal})
			If ValType(dDtTM200) == "D"
				dDataEnt := dDtTM200
			EndIf
		Else
			//-- Calcula tempo de entrega
			If	Empty(aCliPrz)
				aTmpEnt := TmsTmpEntr( cTipTra, cCdrOri, cCdrPrz, cCliDev, cLojDev )
			Else
				aTmpEnt := TmsTmpEntr( cTipTra, cCdrOri, cCdrPrz, aCliPrz[1], aCliPrz[2] )
			EndIf
			If	! Empty( aTmpEnt )
				//-- Calcula a data de entrega
				SomaDiaHor( @dDataEnt, cHoraBase, TmsHrToInt( aTmpEnt[ 2 ] ) )
				dNovaData := TmsHrFer(dDataEnt,cCdrPrz)
				If	dDataEnt <> dNovaData
					dDataEnt := dNovaData
				EndIf
				//Este ponto de entrada 'TM200DAT' foi uma solicitaÁ„o
				//pois o modelo atual quando se faz um c·lculo no SAB
				//e o sistema est· configurado para aceitar apenas dias
				//˙teis, a contagem È feita como se o c·lculo fosse de
				//feito na SEG.
				If	lTm200DAT
					dDtTM200 := ExecBlock('TM200DAT',.F.,.F.,{dDataEnt,cCdrPrz,cHoraBase,aTmpEnt,cTipTra,cCdrOri,;
											(Iif(Empty(aCliPrz),cCliDev,aCliPrz[1])),;
											(Iif(Empty(aCliPrz),cLojDev,aCliPrz[2])),cCdrCal})
					If ValType(dDtTM200) == "D"
						dDataEnt := dDtTM200
					EndIf
				EndIf
			EndIf
		EndIf

		If (nPos := Ascan(__aFilDes, { |x| x[1] == cCdrCal })) == 0
			TMSA200CdRg(cCdrCal)   //Posiciona no grupo de Regiao
			cFilDes 	:= DUY->DUY_FILDES
			cPaisDes	:= DUY->DUY_PAIS
			AAdd( __aFilDes, { cCdrCal, cFilDes } )
		Else
			cFilDes := __aFilDes[nPos,2]
			cPaisDes:= Posicione('DUY', 1, xFilial('DUY') + __aFilDes[nPos,1], 'DUY_PAIS')
		EndIf

		//-- busca a filial destino alianca
		If lAlianca .And. !Empty(aProduto[1,3]) //-- Qdo nao for chamado da manutencao de documentos
			cNumNfc := aProduto[1,3,1,1]
			cSerNfc := aProduto[1,3,1,2]
			DTC->(DbSetOrder(2)) //DTC_FILIAL+DTC_NUMNFC+DTC_SERNFC+DTC_CLIREM+DTC_LOJREM+DTC_CODPRO+DTC_FILORI+DTC_LOTNFC
			DTC->(MsSeek(xFilial('DTC') + cNumNfc + cSerNfc + cCliRem + cLojRem))
			If !Empty(DTC->DTC_ALIANC)
				cAlianca := DTC->DTC_ALIANC
				cAliasTRB := GetNextAlias()
				cQuery := " SELECT DVK_FILALI "
				cQuery += "   FROM "
				cQuery += RetSqlName("DVK") + " DVK, "
				cQuery += RetSqlName("DVL") + " DVL "
				cQuery += "   WHERE DVK.DVK_FILIAL = '" + xFilial("DVK") + "' "
				cQuery += "     AND DVK.DVK_GRPVEN = '" + cCdrCal + "' "
				cQuery += "     AND DVK.D_E_L_E_T_ = ' ' "
				cQuery += "     AND DVL.DVL_FILIAL = '" + xFilial("DVL") + "' "
				cQuery += "     AND DVL.DVL_FILALI = DVK.DVK_FILALI "
				cQuery += "     AND DVL.DVL_ALIANC = '" + cAlianca + "' "
				cQuery += "     AND DVL.D_E_L_E_T_ = ' ' "
				cQuery := ChangeQuery(cQuery)
				dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasTRB, .F., .T.)
				If (cAliasTRB)->(!Eof())
					If !Empty((cAliasTRB)->DVK_FILALI)
						cFilDes := (cAliasTRB)->DVK_FILALI
					EndIf
				EndIf
				(cAliasTRB)->(DbCloseArea())
			EndIf
		EndIf
		//-- Grava documento de transporte
		RecLock('DT6',.T.)
		DT6->DT6_FILIAL	:= xFilial('DT6')
		DT6->DT6_FILDOC	:= cFilAnt
		DT6->DT6_DOC	:= cNumPed
		DT6->DT6_SERIE	:= cSerPed
		//Na gravacao do campo DT6_FILDES, considera a variavel cFilAnt quando a variavel cFildes estiver em branco.
		//Para os caso onde forem utilizados uma regiao que nao esta atrelada a uma Filial na estrutura de Regioes
		DT6->DT6_FILDES	:= Iif(Empty(cFilDes),cFilAnt,cFilDes)
		DT6->DT6_DATEMI	:= dDT6DtBase
		DT6->DT6_HOREMI	:= cHoraBase
		Pergunte("TMA500",.F.)
		If MV_PAR03 == 1 //GeraÁ„o por NF
			DT6->DT6_QTDVOL	:= aTmsA200[24]
			DT6->DT6_VALMER	:= aTmsA200[25]
			DT6->DT6_PESO	:= aTmsA200[26]
			DT6->DT6_QTDUNI	:= aTmsA200[30]
			DT6->DT6_PESOM3	:= aTmsA200[27]
			DT6->DT6_METRO3	:= aTmsA200[28]
			DT6->DT6_BASSEG	:= aTmsA200[29]
			DT6->DT6_VOLORI	:= aTmsA200[24] //recebe a qtd. de volumes
		Else
			DT6->DT6_QTDVOL	:= nQtdVol
			DT6->DT6_VALMER	:= nValor
			DT6->DT6_PESO	:= nPeso
			DT6->DT6_QTDUNI	:= nQtdUni
			DT6->DT6_PESOM3	:= nPesoM3
			DT6->DT6_METRO3	:= nMetro3
			DT6->DT6_BASSEG	:= nSeguro
			DT6->DT6_VOLORI	:= nQtdVol
		Endif
		DT6->DT6_PESCOB := nPesoCob
		DT6->DT6_PESLIQ	:= nPesLiq
		DT6->DT6_TABFRE	:= cTabFre
		DT6->DT6_TIPTAB	:= cTipTab
		DT6->DT6_SEQTAB	:= cSeqTab
		DT6->DT6_CDRORI	:= cCdrOri
		DT6->DT6_CDRDES	:= cCdrDes
		DT6->DT6_CDRCAL	:= cCdrCal
		DT6->DT6_TIPFRE	:= cTipFre
		DT6->DT6_NCONTR	:= cNContr
		DT6->DT6_PRZENT	:= dDataEnt
		DT6->DT6_FILORI	:= cFilAnt
		DT6->DT6_LOTNFC	:= cLotNfc
		DT6->DT6_DOCTMS	:= cDocTms
		If lCTeUnico //Quando For CTe - ⁄nico preencher com o emitente o remetente ou destinatario conforne retorno da funÁ„o TMSA200EMI.
		    cTipEmite := TMSA200EMI(cCliDev, CLojDev, cTipFre)

			DbSelectArea("SA1")
			SA1->(dbSetOrder(3)) //A1_FILIAL+A1_CGC
			If	SA1->(MsSeek(xFilial("SA1")+SM0->M0_CGC))
				cCodEmit	:= SA1->A1_COD
				cLojEmit	:= SA1->A1_LOJA
			EndIf

		MSMM(,,,TMSA200OBS(),1,,,"DT6","DT6_CODOBS")

			If cTipEmite = "REMETENTE"
				DT6->DT6_CLIREM	:= cCliRem
				DT6->DT6_LOJREM	:= cLojRem
				DT6->DT6_CLIDES	:= cCodEmit
				DT6->DT6_LOJDES	:= cLojEmit
				DT6->DT6_CDRDES	:= SA1->A1_CDRDES
				DT6->DT6_CDRCAL	:= SA1->A1_CDRDES
				DT6->DT6_CDRORI	:= cCdrOri
			EndIf
			If cTipEmite = "DESTINATARIO"
				DT6->DT6_CLIREM	:= cCodEmit
				DT6->DT6_LOJREM	:= cLojEmit
				DT6->DT6_CLIDES	:= cCliDes
				DT6->DT6_LOJDES	:= cLojDes
               	DT6->DT6_CDRORI := SA1->A1_CDRDES
				DT6->DT6_CDRDES	:= cCdrDes
				DT6->DT6_CDRCAL	:= cCdrCal
			EndIf
		Else
			DT6->DT6_CDRDES	:= cCdrDes
			DT6->DT6_CDRCAL	:= cCdrCal
			DT6->DT6_CLIREM	:= cCliRem
			DT6->DT6_LOJREM	:= cLojRem
			DT6->DT6_CLIDES	:= cCliDes
			DT6->DT6_LOJDES	:= cLojDes
			DT6->DT6_CDRORI	:= cCdrOri
		EndIf
		DT6->DT6_CLICON	:= cCliCon
		DT6->DT6_LOJCON	:= cLojCon
		DT6->DT6_CLIDPC	:= cCliDpc
		DT6->DT6_LOJDPC	:= cLojDpc
		DT6->DT6_CLIDEV	:= cCliDev
		DT6->DT6_LOJDEV	:= cLojDev
		DT6->DT6_DEVFRE	:= cDevFre
		DT6->DT6_SERTMS	:= cSerTms
		DT6->DT6_TIPTRA	:= cTipTra
		DT6->DT6_SERVIC	:= cServic
		If lExped
			DT6->DT6_CLIEXP := cCliExp
			DT6->DT6_LOJEXP := cLojExp
        EndIf
		If lRecebedor
			DT6->DT6_CLIREC := cCliRec
			DT6->DT6_LOJREC := cLojRec
		EndIf
		If DT6->(ColumnPos("DT6_SQEDES")) > 0
			DT6->DT6_SQEDES := aTMSA200[50]
		EndIf

		If lRetira
			DT6->DT6_RETIRA := cRetira
		EndIf

		DT6->DT6_CODNEG := cCodNeg

		aRota := TMSRetRota( cCliDes, cLojDes, , StrZero(3,Len(DT6->DT6_SERTMS))  )  //Rota Entrega
		If DT6->(FieldPos("DT6_MODFAT")) > 0
			aModFat := TmsPerfil(cCliCal, cLojCal,,,cCliRem, cLojRem, cLojRem, cCliDes, cLojDes)
			If cTMSMFat == "2" .And. !Empty(aModFat[47])
			 	DT6->DT6_MODFAT := "1"
			Else
				DT6->DT6_MODFAT := cTMSMFat
			EndIf
		EndIf
		cRota := aRota[1,2]
		If Len(aRota) > 1 .And. !Empty(cRotEnt)
			For nCnt:= 1 To Len(aRota)
				If aRota[nCnt,2] <> cRotEnt
					cRota:= aRota[nCnt,2]
					Exit
				EndIf
			Next nCnt
		EndIf
		DT6->DT6_ROTENT	:= cRota
		DT6->DT6_CODMSG	:= cCodMsg
		DT6->DT6_NUMCMP	:= cNumCmp
		DT6->DT6_STATUS	:= StrZero(1, Len(DT6->DT6_STATUS))	// Em Aberto
		DT6->DT6_BLQDOC	:= StrZero(2, Len(DT6->DT6_BLQDOC))	// Nao
		DT6->DT6_PRIPER	:= StrZero(2, Len(DT6->DT6_PRIPER))	// Nao
		DT6->DT6_FIMP	:= StrZero(0, Len(DT6->DT6_FIMP))		// Nao Impresso
		DT6->DT6_CLICAL	:= cCliCal
		DT6->DT6_LOJCAL	:= cLojCal
		If	! Empty(aTmsA500)
			If lDocRee
				If cDocTms == '6' //-- Se DevoluÁ„o, o Status È operacional, n„o nasce entregue
					DT6->DT6_STATUS := aTmsA500[01]
				ElseIf cDocTms == '7' .And. lDocRee //-- EAlberti -> Qdo MV_DOCREE == .T. Reentrega Ser· '1' ( Em Aberto )
					DT6->DT6_STATUS := StrZero(1, Len(DT6->DT6_STATUS))
				Else
					DT6->DT6_STATUS := StrZero(7, Len(DT6->DT6_STATUS)) // aberto e nao grava data entrega
				EndIf
				DT6->DT6_PERDCO := Round( aTmsA500[03] , TamSX3("DT6_PERDCO")[2] )
				DT6->DT6_FILDCO := aTmsA500[04]
				DT6->DT6_DOCDCO := aTmsA500[05]
				DT6->DT6_SERDCO := aTmsA500[06]
			Else
				DT6->DT6_STATUS := aTmsA500[01]
				DT6->DT6_DATENT := aTmsA500[02]
				DT6->DT6_PERDCO := Round( aTmsA500[03] , TamSX3("DT6_PERDCO")[2] )
				DT6->DT6_FILDCO := aTmsA500[04]
				DT6->DT6_DOCDCO := aTmsA500[05]
				DT6->DT6_SERDCO := aTmsA500[06]
			EndIf
			If lOriCal .And. Len(aTmsA500) >= 13
				DT6->DT6_ORICAL := aTmsA500[13]
				DT6->DT6_DESCAL := aTmsA500[14]
			EndIf
			If DT6->(ColumnPos('DT6_SQEDES')) > 0 .And. Len(aTmsA500) >= 15
				DT6->DT6_SQEDES := aTmsA500[15]
			EndIf
		EndIf
		//-- Filial de Negociacao Cliente
		DW3->(DbSetOrder(1))
		If DW3->(MsSeek(xFilial("DW3") + cCliDev + cLojDev + cTipTra))
			DT6->DT6_FILNEG := DW3->DW3_FILNEG
		Else
			DT6->DT6_FILNEG := Iif(cTipFre == "1",cFilAnt,cFilDes)
		EndIf
		If lAlianca
			DT6->DT6_ALIANC := cAlianca
		EndIf

		//-- Verifica se foi rodado o segundo Update do CTE.
		If lTMSCTe
			DT6->DT6_SITCTE := '0'
			DT6->DT6_RETCTE := STR0117 //'003 - O CT-e ainda n„o foi transmitida - aguarde a transmissao'
		EndIf


		DT6->( MsUnLock() )

		//-- Atualiza Gest„o de Demandas
		If lITmsDmd .And. FindFunction("TmMontaDmd") .And. TableInDic("DL8")
			If DT6->DT6_DOCTMS $ "67D"	//-- CTe DevoluÁ„o / CTe Reentrega / NFSTe Reentrega
				TmMontaDmd(DT6->DT6_DOCTMS,DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE,STR0196 + DToC(dDataBase) + " " + Left(Time(),5) + ;
							Iif(DT6->DT6_DOCTMS == "6",STR0198,STR0197) + DT6->DT6_FILDOC + "-" + DT6->DT6_DOC + "/" + DT6->DT6_SERIE + STR0199,.F.,,,.F.,.F.)	//-- Bloqueada ## "Demanda bloqueada em " ## " por conta de reentrega do documento " ou " por conta de devoluÁ„o do documento " ## " do TMS"
			Endif
		EndIf

		If __lSX8
			ConfirmSX8()
		EndIf

		//-- Gravacao do valor informado x documento de complemento
		If ! Empty(aTmsA500) .And. ! Empty(aTmsA500[7])
			aTmsA500[7,1,4]:=cNumPed
			aTmsA500[7,1,5]:=cSerPed
			TmsGrvInf(aTmsA500[7],'3',cFilAnt)
		EndIf

	EndIf

	If !lAtzPed
		//-- Se informado Seq.Endereco para destinatario retornar codigo regiao para calculo do prazo de entrega
		cCdrPrz := cCdrDes
		If !Empty(cSqEDes)
			DUL->(dbSetOrder(2))
			If DUL->(MsSeek(xFilial("DUL") + cCliDes + cLojDes + cSqEDes) .And. !Empty(DUL_CDRDES))
				cCdrPrz := DUL->DUL_CDRDES
			EndIf
		EndIf
		//-- Se alterada regiao de calculo deve usar esta para calculo do prazo de entrega.
		If	cCdrDes <> cCdrCal
			cCdrPrz := cCdrCal
		EndIf
		//-- Obtem o cliente para calculo do prazo de entrega
		aCliPrz := TmsCliCalc( cCliRem, cLojRem, cCliDes, cLojDes, .T. )
		//-- Calcula tempo de entrega
		If	Empty(aCliPrz)
			aTmpEnt := TmsTmpEntr( cTipTra, cCdrOri, cCdrPrz, cCliDev, cLojDev )
		Else
			aTmpEnt := TmsTmpEntr( cTipTra, cCdrOri, cCdrPrz, aCliPrz[1], aCliPrz[2] )
		EndIf
		If	! Empty( aTmpEnt )
			//-- Calcula a data de entrega
			SomaDiaHor( @dDataEnt, cHoraBase, TmsHrToInt( aTmpEnt[ 2 ] ) )
			dNovaData := TmsHrFer(dDataEnt,cCdrPrz)
			If	dDataEnt <> dNovaData
				dDataEnt := dNovaData
			EndIf
			//Este ponto de entrada 'TM200DAT' foi uma solicitaÁ„o
			//pois o modelo atual quando se faz um c·lculo no SAB
			//e o sistema est· configurado para aceitar apenas dias
			//˙teis, a contagem È feita como se o c·lculo fosse de
			//feito na SEG.
			If	lTm200DAT
				dDataEnt := Iif (ValType(dDtTM200 := ExecBlock('TM200DAT',.F.,.F.,{dDataEnt,cCdrPrz,cHoraBase,aTmpEnt,cTipTra,cCdrOri,cCliDev,cLojDev,cCdrCal }))=="D",dDtTM200,dDataEnt )
			EndIf
		EndIf

		RecLock('DT6',.F.)
		DT6->DT6_PRZENT := dDataEnt
		DT6->( MsUnLock() )

	EndIf

	If	! Empty( cDocto )
		//-- Posiciona no documento
		SF2->(DbSetOrder(1)) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
		If	SF2->(MsSeek(xFilial("SF2") + cDocto + cSerie + cCliDev + cLojDev))
			//-- Obtem valor da mercadoria, valor bruto e impostos( icm + iss ), estes valores serao gravados
			//-- no DT6 como um facilitador para os relatorios

			SD2->(DbSetOrder( 3 )) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
			cAliasQry := GetNextAlias()
			cQuery := "   SELECT DISTINCT SD2.D2_FILIAL, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_TES "
			cQuery += "       FROM " + RetSqlName("SD2") + " SD2 "
			cQuery += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
			cQuery += "      ON  SF4.F4_FILIAL = '"+xFilial('SF4')+"'"
			cQuery += "      AND SF4.F4_CODIGO = SD2.D2_TES "
			cQuery += "      AND (SF4.F4_ICM = 'S' OR SF4.F4_ISS = 'S') "
			cQuery += "      AND SF4.D_E_L_E_T_ = ' ' "
			cQuery += "    WHERE SD2.D2_FILIAL  = '" + xFilial('SD2') + "' "
			cQuery += "      AND SD2.D2_DOC     = '" + cDocto + "' "
			cQuery += "      AND SD2.D2_SERIE   = '" + cSerie + "' "
			cQuery += "      AND SD2.D2_CLIENTE = '" + cCliDev + "' "
			cQuery += "      AND SD2.D2_LOJA    = '" + cLojDev + "' "
			cQuery += "      AND SD2.D_E_L_E_T_ = ' ' "
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
			If (cAliasQry)->(!Eof())
				SF4->(DbSetOrder(1)) //F4_FILIAL+F4_CODIGO
				SF4->(MsSeek(xFilial("SF4") + (cAliasQry)->D2_TES))
			EndIf
			(cAliasQry)->(DbCloseArea())
			RestArea(aAreaSD2)

			If SF4->F4_AGRPIS == "P" .Or. SF4->F4_AGRCOF == "C"
				aCpoImpost := TMSA200PC("TMSA200",{"SF2"})

				nValPISCOF := 0

				For nCpoImpost := 1 To Len(aCpoImpost)
					nValPISCOF += SF2->(&(aCpoImpost[nCpoImpost]))
				Next nCpoImpost
			EndIf

			If SF4->F4_ISS=='S'
				If SF4->(ColumnPos('F4_AGRISS')) > 0
					If Empty(SF4->F4_AGRISS)
						If cIncISS == "N" .And. cA1_INCISS == "N"
							nValMerc := ( SF2->F2_VALMERC - SF2->F2_VALISS )
						Else
							nValMerc := SF2->F2_VALMERC
						EndIf
					Else
						nValMerc := SF2->F2_VALMERC
					EndIf
				Else
					If cIncISS == "N" .And. cA1_INCISS == "N"
						nValMerc := ( SF2->F2_VALMERC - SF2->F2_VALISS )
					Else
						nValMerc := SF2->F2_VALMERC
					EndIf
				EndIf
			Else
				nValMerc := SF2->F2_VALMERC
			EndIf
			nValBrut := SF2->F2_VALBRUT
			aAreaSF3 := SF3->(GetArea())

			DbSelectArea("SF3")
			DbSetOrder(4) //F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE
			//--Pesquisa valor total de Credito Presumido
			If	SF3->(MsSeek( xFilial("SF3")+SF2->(F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE)))
				nValCrdPre := Round(SF3->F3_CRPRST , __nTamSX3)
				nValTotSF3 := Round(SF3->F3_VALCONT, __nTamSX3)
				nValDifal  := Round(SF3->F3_DIFAL  , __nTamSX3) //-- ref 80% difal
				nVfcpDif   := Round(SF3->F3_VFCPDIF, __nTamSX3)
				nCrdTran   := Round(SF3->F3_CRDTRAN, __nTamSX3)
				nICMSCOM   := Round(SF3->F3_ICMSCOM, __nTamSX3) //-- ref 20% difal
			EndIf

			RestArea(aAreaSF3)

			If (SF4->F4_ICM=='S' .Or. SF4->F4_ISS=='S') .And. SF2->F2_VALICM > 0
				nValImp := SF2->F2_VALICM
			ElseIf (SF4->F4_ICM=='S' .Or. SF4->F4_ISS=='S') .And. SF2->F2_VALISS > 0
				nValImp := SF2->F2_VALISS //  Qdo era feito NF de servico pelo TMS, o campo
			Else                           //  DT6_VALIMP ficava 0(zero) por nao tratar o F2_VALISS
				nValImp := SF2->F2_ICMSRET //  Em fonte de 27/08/10 o campo era tratado.
			EndIf
			nValImp := nValImp+nValPISCOF+nValDifal+nICMSCOM+nVfcpDif	// Validar os 20% do difal pela variavel 'nICMSCOM'
			nValFat := SF2->F2_VALFAT

			//-- Obtem a filial de debito, informada no cliente ou na regiao de calculo
			If	TMSA200Cli( cCliDev, cLojDev)    //posiciona na tabela SA1

				cFilDeb := SA1->A1_FILDEB
				If Empty(cFilDeb)
					If cTipFre == '1' //-- CIF
						cFilDeb := cFilAnt
					Else
						If (nPos := Ascan(__aFilDes, { |x| x[1] == cCdrCal })) == 0
							TMSA200CdRg(cCdrCal)   //Posiciona no grupo de Regiao
							cFilDeb := DUY->DUY_FILDES
							AAdd( __aFilDes, { cCdrCal, cFilDeb } )
						Else
							cFilDeb := __aFilDes[nPos,2]
						EndIf
						//-- Mesmo quando FOB, se a filial de debito estiver em branco, considera a filial atual
						//-- como filial de debito
						If Empty(cFilDeb)
							cFilDeb := cFilAnt
						EndIf
					EndIf
				EndIf
				If lTm200Deb
					aAreaSM0:= SM0->( GetArea() )
					cFilAux := ExecBlock("TM200DEB",.F.,.F.,{cCliDev,cLojDev,cTiptra,cTipFre,cFilDeb})
					If ValType(cFilAux) == "C" .And. SM0->(MsSeek(SM0->M0_CODIGO+cFilAux))
						cFilDeb := cFilAux
					EndIf
					RestArea( aAreaSM0 )
				EndIf
				If	cTMSMFat <> '2'
					//-- Grava a filial de debito
					cPrefixo := PadR(Iif(Empty(SF2->F2_PREFIXO),&(c1DupRef),SF2->F2_PREFIXO),Len(SE1->E1_PREFIXO))
					SE1->(DbSetOrder(2)) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
					aAreaSE1 := SE1->(GetArea())
					cAliasQry := GetNextAlias()
					cQuery := "   SELECT E1_VENCREA, R_E_C_N_O_ SE1_RECNO "
					cQuery += "     FROM " + RetSqlName("SE1")
					cQuery += "    WHERE E1_FILIAL  = '" + xFilial('SE1') + "' "
					cQuery += "      AND E1_CLIENTE = '" + cCliDev + "' "
					cQuery += "      AND E1_LOJA    = '" + cLojDev + "' "
					cQuery += "      AND E1_PREFIXO = '" + cPrefixo + "' "
					cQuery += "      AND E1_NUM     = '" + SF2->F2_DOC + "' "
					cQuery += "      AND D_E_L_E_T_ = ' ' "
					cQuery += " ORDER BY " + SqlOrder(SE1->(IndexKey()))
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
					If (cAliasQry)->(!Eof())
						While (cAliasQry)->(!Eof())
							SE1->(MsGoto((cAliasQry)->SE1_RECNO))

							RecLock('SE1',.F.)
							SE1->E1_FILDEB := cFilDeb
							MsUnLock()
							dUltVenc := SE1->E1_VENCREA

							(cAliasQry)->(DbSkip())
						EndDo
						If	lTM200SE1
							ExecBlock('TM200SE1',.F.,.F.,{cCliDev,cLojDev,cPrefixo,SF2->F2_DOC})
						EndIf
					EndIf
					RestArea(aAreaSE1)
					(cAliasQry)->(DbCloseArea())
				EndIf
			EndIf
		EndIf

		//-- Substitui o numero do pedido pelo numero do documento
		If cNumPed + cSerPED <> cDocto + cSerie
			DT8->(DbSetOrder(2))
			cAliasQry := GetNextAlias()

			cQuery := ""
			cQuery := "   SELECT R_E_C_N_O_ DT8_RECNO "
			cQuery += "     FROM " + RetSqlName("DT8")
			cQuery += "    WHERE DT8_FILIAL = '" + xFilial('DT8') + "' "
			cQuery += "      AND DT8_FILDOC = '" + cFilAnt + "' "
			cQuery += "      AND DT8_DOC    = '" + cNumPed + "' "
			cQuery += "      AND DT8_SERIE  = '" + cSerPed + "' "
			cQuery += "      AND D_E_L_E_T_ = ' ' "
			cQuery += " ORDER BY " + SqlOrder(DT8->(IndexKey()))
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)

			While (cAliasQry)->(!Eof())
				DT8->(MsGoto((cAliasQry)->DT8_RECNO))

				RecLock('DT8',.F.)
				DT8->DT8_DOC	:= cDocto
				DT8->DT8_SERIE	:= cSerie
				MsUnLock()

				(cAliasQry)->(DbSkip())
			EndDo

			(cAliasQry)->(DbCloseArea())
		EndIf

		//-- Substitui o numero do pedido pelo numero do documento
		DT6->(DbSetOrder(2)) //DT6_FILIAL+DT6_FILORI+DT6_LOTNFC+DT6_FILDOC+DT6_DOC+DT6_SERIE
		If	DT6->(MsSeek(xFilial('DT6') + cFilAnt + cLotNfc + cFilAnt + cNumPed + cSerPed))
			RecLock('DT6',.F.)
			DT6->DT6_DOC    := cDocto
			DT6->DT6_SERIE  := cSerie
			DT6->DT6_VALFRE := nValMerc
			DT6->DT6_VALTOT := nValBrut
			DT6->DT6_VALIMP := nValImp
			DT6->DT6_DATEMI := dDT6DtBase
			DT6->DT6_HOREMI	:= cHoraBase
			DT6->DT6_PRIPER := IIf(l1oPerc,StrZero(1,Len(DT6->DT6_PRIPER)),StrZero(2,Len(DT6->DT6_PRIPER)))
			DT6->DT6_FILDEB := IIf(Empty(cFilDeb),cFilAnt,cFilDeb)
			DT6->DT6_USRGER := __cUsrTms // TMS Internacional
			If	cTipTra == StrZero(4,Len(DC5->DC5_TIPTRA)) //-- Rodoviario Internacional
				//--Procuro por Regiao de Calculo, depois Regiao de Destino, e por ultimo sem Regiao
				DI0->(DbSetOrder(1))
				If DI0->(MsSeek(xFilial("DI0")+cFilAnt+cFilDes+cPaisDes))
					DT6->DT6_SIGTRA := DI0->DI0_SIGTRA
					DT6->DT6_NUMPER := DI0->DI0_NUMPER
				Else
					TMSA200CdRg(cCdrDes)   //Posiciona no grupo de Regiao
					cFilDes := DUY->DUY_FILDES
					cPaisDes := DUY->DUY_PAIS
					If DI0->(MsSeek(xFilial("DI0")+cFilAnt+cFilDes+cPaisDes))
						DT6->DT6_SIGTRA := DI0->DI0_SIGTRA
						DT6->DT6_NUMPER := DI0->DI0_NUMPER
					Else
						If DI0->(MsSeek(xFilial("DI0")+cFilAnt+Space(Len(DI0->DI0_FILDES))+cPaisDes )) //Busca sem a Filial de Destino, pois existem permissos desta forma
							DT6->DT6_SIGTRA := DI0->DI0_SIGTRA
							DT6->DT6_NUMPER := DI0->DI0_NUMPER
						EndIf
					EndIf
				EndIf
			EndIf
			DT6->DT6_MOEDA := SF2->F2_MOEDA
			lFatSE1 := Eval(bFatSE1)
			If (lFatSE1 .Or. cTMSMFat == "1") .And. nValFat > 0 //-- Se o Modo de Faturamento for a partir do SE1
				DT6->DT6_PREFIX := SE1->E1_PREFIXO
				DT6->DT6_NUM    := SE1->E1_NUM
				DT6->DT6_TIPO   := SE1->E1_TIPO
				DT6->DT6_VENCTO := dUltVenc //-- Data de Vencimento da Ultima parcela do SE1
			Else
				//-- Se o Modo de Faturamento for a partir do DT6
				aVenc := Condicao(0,cCondPag,0, dDataBase)
				If Len(aVenc) > 0
					DT6->DT6_VENCTO := aVenc[Len(aVenc)][1] //-- Data do Ultimo Vencimento
				EndIf
			EndIf
			//-- Gravacao do valor faturado
			DT6->DT6_VALFAT := Iif(nValFat > 0,nValFat,nValBrut)
			MsUnLock()
		EndIf
		//-- Atualiza valor informado x documento de complemento
		DVS->(DbSetOrder(1)) //DVS_FILIAL+DVS_FILDOC+DVS_DOC+DVS_SERIE+DVS_CODPAS
		If DVS->(MsSeek(xFilial("DVS")+cFilAnt+cNumPed+cSerPed))
			While DVS->(!Eof()) .And. DVS->DVS_FILIAL + DVS->DVS_FILDOC + DVS->DVS_DOC + DVS->DVS_SERIE == ;
										xFilial("DVS") + cFilAnt + cNumPed + cSerPed
				DVS->(DbSkip())
				nRecDVS := DVS->(Recno())
				DVS->(DbSkip(-1))
				RecLock("DVS",.F.)
				DVS->DVS_DOC   := cDocto
				DVS->DVS_SERIE := cSerie
				MsUnLock()
				DVS->(MsGoto(nRecDVS))
			EndDo
		EndIf

		//--Gravacao do documento na tabela DL5 para fins de averbaÁ„o de NFS normal e/ou NFS de reentrega.
		If FindFunction ("AvbeGrvCte") .AND. AliasInDic("DL5") .AND. (DT6->DT6_DOCTMS $ "5D")
			AvbeGrvCte( DT6->DT6_FILDOC, DT6->DT6_DOC, DT6->DT6_SERIE,DT6->DT6_DATEMI,DT6->DT6_HOREMI,'100',DT6->DT6_DOCTMS, DT6->DT6_CLIDEV, DT6->DT6_LOJDEV)
		EndIF

		//-- Atualiza a composicao do frete
		nValImp := 0
		nValTot := 0
		If cNumPed + cSerPED <> cDocto + cSerie
			//-- Posiciona no SC6 para localizar o produto do pedido, pois o ponto de Entrada TMAPEDSC6,
			//-- possibilita alterar o produto informado no cadastro de Documentos.
			SC6->( DbSetOrder( 1 ) )
			cAliasQry := GetNextAlias()
			cQuery := " SELECT DISTINCT C6_FILIAL, C6_NUM, C6_CLI, C6_LOJA, C6_PRODUTO "
			cQuery += "     FROM " + RetSqlName("SC6")
			cQuery += "    WHERE C6_FILIAL = '" + xFilial('SC6') + "' "
			cQuery += "      AND C6_NUM = '" + PADR(cNumPed,Len(SC6->C6_NUM)) + "' "
			cQuery += "      AND C6_CLI = '" + cCliDev + "' "
			cQuery += "      AND C6_LOJA = '" + cLojDev + "' "
			cQuery += "      AND D_E_L_E_T_ = ' ' "
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)

			While (cAliasQry)->(!Eof())
				If !Empty((cAliasQry)->C6_PRODUTO)
					cPrdImp := (cAliasQry)->C6_PRODUTO
					Exit
				EndIf

				(cAliasQry)->(DbSkip())
			EndDo

			(cAliasQry)->(DbCloseArea())

			If Empty(cPrdImp)
				UserException(STR0061 + cDocto + "/" + cSerie) //"Problema na numeracao do pedido, Docto : "
			EndIf
		EndIf

		cCodPro := Space(Len(SB1->B1_COD))
		If cTipoNF <> 'I' //-- Complemento de Imposto (TMSA500)

			//-- Verifica no array a maior quantidade de componentes.
			If Len(aProduto) > 0
				nLenProd := 0
				cCodPro  := aProduto[1,1]
				For n1Cnt := 1 To Len(aProduto)
					If cCodPro == aProduto[n1Cnt,1]
						If nLenProd < Len(aProduto[n1Cnt,2])
							nLenProd := Len(aProduto[n1Cnt,2])
							nPos     := n1Cnt
						EndIf
					Else
						Exit
					EndIf
				Next n1Cnt
			EndIf

			cCodPro := "PRODUTO" //-- Definido para o controle do parametro MV_PRCPROD que apresenta o produto vazio.
			For n1Cnt := nPos To Len(aProduto)
				For n2Cnt := 1 To Len(aProduto[n1Cnt,2])
					//-- Se o valor do componente for zero
					If aProduto[n1Cnt,2,n2Cnt,2] <= 0 .Or. cCodPro == aProduto[n1Cnt,1]
						Loop
					EndIf
					If	aProduto[n1Cnt,2,n2Cnt,3] <> 'TF'
						//-- Atualiza os impostos do componente
						SD2->(DbSetOrder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
						If	SD2->(MsSeek(xFilial('SD2') + cDocto + cSerie + cCliDev + cLojDev + cPrdImp + aProduto[n1Cnt,2,n2Cnt,4]))
							DT8->(DbSetOrder(2))  //DT8_FILIAL+DT8_FILDOC+DT8_DOC+DT8_SERIE+DT8_CODPRO+DT8_CODPAS
							If	DT8->(MsSeek(xFilial('DT8') + cFilAnt + cDocto + cSerie + aProduto[n1Cnt,1] + aProduto[n1Cnt,2,n2Cnt,3]))

								If	SF4->F4_AGRPIS == "P" .Or. SF4->F4_AGRCOF == "C"
									aCpoImpost := TMSA200PC("TMSA200",{"SD2"})
									nValPISCOF := 0
									For nCpoImpost := 1 To Len(aCpoImpost)
										nValPISCOF += SD2->(&(aCpoImpost[nCpoImpost]))
									Next nCpoImpost
								EndIf

								nDifal := 0
								dbSelectArea("DT8")
								RecLock('DT8',.F.)
								DT8->DT8_VALIMP := ( DT8CalImp(cIncISS,cA1_INCISS,nValPISCOF,nValCrdPre,@nD2CrdPre,nPos,aProduto[n1Cnt,2,n2Cnt,4],cCliDev,cLojDev,Len(aProduto), @nDifal ) )
								DT8->DT8_VALIMP += nDifal
								If(TmsSomaImp(SD2->D2_TES,If(cIncISS=="N" .And. cA1_INCISS =="N","N","S"), (SF4->F4_ICM=='N' .AND. SF4->F4_ISS=='N' .AND. (SD2->D2_ICMSRET > 0))) )
									If !lD2Aglut .And. Len(aProduto) == 1
										DT8->DT8_VALTOT := SD2->D2_VALBRUT
									Else
										DT8->DT8_VALTOT := DT8->DT8_VALPAS+DT8->DT8_VALIMP
									EndIf
									If !lD2Aglut
										If SF4->F4_ISS=='S'
											If Empty(SF4->F4_AGRISS)
												If cIncISS == "N" .And. cA1_INCISS == "N"
													lAgrISS := .T.
												EndIf
											Else
												If SF4->F4_AGRISS == '1'
													lAgrISS := .T.
												EndIf
											EndIf
										EndIf
									EndIf
								Else
									DT8->DT8_VALTOT := DT8->DT8_VALPAS
								EndIf
								MsUnLock()

								nValPas += DT8->DT8_VALPAS
								nValImp += DT8->DT8_VALIMP
								nValTot += DT8->DT8_VALTOT

								nVALIMP2 := DT8->DT8_VALIMP			// Guardo o Imposto
								nVALIMP3 := Max(nVALIMP2,nVALIMP3)	// Guardo o maior Imposto
								nRecDt8Ant := DT8->(RECNO())		// com maior imposto para

								// O preenchimento do campo F4_AGRISS para agregar ISS, ou destacar, se campo estiver preenchido, caso contrario calcula da forma antiga.
								If !lD2Aglut
									If !lAgrISS
										If SF4->F4_ISS=='S'
											//-- Armazena o restante do item SD2, utilizado na verificacao final do rateio.
											If (nPos := Ascan(aAJustRat, {|x| x[1] == xFilial('SD2') + cDocto + cSerie + cCliDev + cLojDev + cPrdImp + aProduto[n1Cnt,2,n2Cnt,4]})) == 0
												AAdd(aAJustRat, {;
												xFilial('SD2') + cDocto + cSerie + cCliDev + cLojDev + cPrdImp + aProduto[n1Cnt,2,n2Cnt,4],;
												SD2->D2_TOTAL, SD2->D2_VALICM + nD2CrdPre + nValPISCOF,;
												SD2->D2_VALBRUT,;
												Array(0),;
												0 })
												nPos := Len(aAJustRat)
											EndIf
											//--
										Else
											//-- Armazena o restante do item SD2, utilizado na verificacao final do rateio.
											If (nPos := Ascan(aAJustRat, {|x| x[1] == xFilial('SD2') + cDocto + cSerie + cCliDev + cLojDev + cPrdImp + aProduto[n1Cnt,2,n2Cnt,4]})) == 0
												AAdd(aAJustRat, {;
												xFilial('SD2') + cDocto + cSerie + cCliDev + cLojDev + cPrdImp + aProduto[n1Cnt,2,n2Cnt,4],;
												SD2->D2_TOTAL,;
												Iif(SF4->F4_ICM=='S' .Or. SF4->F4_ISS=='S',SD2->D2_VALICM,SD2->D2_ICMSRET) + nD2CrdPre + nValPISCOF + nDifal ,;
												SD2->D2_VALBRUT,;
												Array(0),;
												0})
												nPos := Len(aAJustRat)
											EndIf
											//--
										EndIf
										aAJustRat[nPos,2] -= DT8->DT8_VALPAS
										aAJustRat[nPos,3] -= DT8->DT8_VALIMP
										aAJustRat[nPos,4] -= DT8->DT8_VALTOT
										Aadd(aAJustRat[nPos,5], nRecDt8Ant)

										aAJustRat[nPos,6] += DT8->DT8_VALPAS //-- posiÁ„o 6 - total do frete para o componente
									EndIf
								EndIf
							EndIf
						EndIf
					Else
						//-- Totais do Frete -> DT8_CODPAS == "TF"
						DT8->(DbSetOrder(2))  //DT8_FILIAL+DT8_FILDOC+DT8_DOC+DT8_SERIE+DT8_CODPRO+DT8_CODPAS
						If	DT8->(MsSeek(xFilial('DT8') + cFilAnt + cDocto + cSerie + aProduto[n1Cnt,1] + aProduto[n1Cnt,2,n2Cnt,3]))
							nRecDt8Atu := DT8->(RECNO()) //Recno do Registro Atual DT8
							RecLock('DT8',.F.)
							DT8->DT8_VALPAS := nValPas
							DT8->DT8_VALIMP := nValImp
							DT8->DT8_VALTOT := nValTot
							MsUnLock() //Destrava o Registro DT8_CODPAS == 'TF'

							nValPas := 0
							nValImp := 0
							nValTot := 0
							cCodPro := aProduto[n1Cnt,1]
						EndIf
					EndIf
				Next n2Cnt
			Next n1Cnt
		EndIf

		//-- Verifica diferencas de arredondamento nos Impostos - sem agrupar SD2
		If !lD2Aglut
			If !lAgrISS
				For n1Cnt := 1 To Len(aAJustRat)
					If aAJustRat[n1Cnt, 2]+aAJustRat[n1Cnt, 3]+aAJustRat[n1Cnt, 4] <> 0

						nLenAux    := Len(aAJustRat[n1Cnt, 5])
						nDifValPas := 0
						nDifValImp := 0
						nDifValTot := 0

						For n2Cnt := 1 To nLenAux
							nRecDt8Ant := aAJustRat[n1Cnt, 5][n2Cnt]

							DT8->(MsGoto(nRecDt8Ant))
							nFator := DT8->DT8_VALPAS / aAJustRat[n1Cnt, 6]
							RecLock('DT8',.F.)
							DT8->DT8_VALPAS += NoRound(aAJustRat[n1Cnt, 2] * nFator , nDecValPas )
							DT8->DT8_VALIMP += NoRound(aAJustRat[n1Cnt, 3] * nFator , nDecValImp )
							DT8->DT8_VALTOT += NoRound(aAJustRat[n1Cnt, 4] * nFator , nDecValTot )

							nDifValPas += NoRound(aAJustRat[n1Cnt, 2] * nFator , nDecValPas )
							nDifValImp += NoRound(aAJustRat[n1Cnt, 3] * nFator , nDecValImp )
							nDifValTot += NoRound(aAJustRat[n1Cnt, 4] * nFator , nDecValTot )

							//-- Joga diferenÁa de arredondamento no ˙ltimo item
							If n2Cnt == nLenAux
								DT8->DT8_VALPAS += aAJustRat[n1Cnt, 2] - nDifValPas
								DT8->DT8_VALIMP += aAJustRat[n1Cnt, 3] - nDifValImp
								DT8->DT8_VALTOT += aAJustRat[n1Cnt, 4] - nDifValTot
							EndIf
							MsUnLock()

							cProduto := DT8->DT8_CODPRO
							//-- Armazena Registro dos Totais, utilizado na verificacao final do rateio.
							DT8->(DbSetOrder(2)) //DT8_FILIAL+DT8_FILDOC+DT8_DOC+DT8_SERIE+DT8_CODPRO+DT8_CODPAS
							If	DT8->(MsSeek(xFilial('DT8') + cFilAnt + cDocto + cSerie + cProduto + "TF"))
								RecLock('DT8',.F.)
								DT8->DT8_VALPAS += NoRound(aAJustRat[n1Cnt, 2] * nFator , nDecValPas )
								DT8->DT8_VALIMP += NoRound(aAJustRat[n1Cnt, 3] * nFator , nDecValImp )
								DT8->DT8_VALTOT += NoRound(aAJustRat[n1Cnt, 4] * nFator , nDecValTot )

								//-- Joga diferenÁa de arredondamento no ˙ltimo item
								If n2Cnt == nLenAux
									DT8->DT8_VALPAS += aAJustRat[n1Cnt, 2] - nDifValPas
									DT8->DT8_VALIMP += aAJustRat[n1Cnt, 3] - nDifValImp
									DT8->DT8_VALTOT += aAJustRat[n1Cnt, 4] - nDifValTot
								EndIf

								MsUnLock()
							EndIf
						Next n2Cnt
					EndIf
				Next n1Cnt
			EndIf

		//-- Verifica diferencas de arredondamento nos Impostos - com SD2 agrupado
		Else

			DT8->(DbCommit()) //-- N„o Retirar - qdo em transaÁ„o, forÁa o envio de "update" ao Banco de dados
			cAliasQry := GetNextAlias()
			cQuery := " SELECT SUM(DT8_VALPAS) DT8_VALPAS, SUM(DT8_VALIMP) DT8_VALIMP, SUM(DT8_VALTOT) DT8_VALTOT "
			cQuery += "   FROM " + RetSqlName("DT8")
			cQuery += "  WHERE  DT8_FILIAL  = '" + xFilial("DT8")  + "'"
			cQuery += " 	AND DT8_FILDOC  = '" + DT6->DT6_FILDOC + "'"
			cQuery += " 	AND DT8_DOC     = '" + DT6->DT6_DOC    + "'"
			cQuery += " 	AND DT8_SERIE   = '" + DT6->DT6_SERIE  + "'"
			cQuery += " 	AND D_E_L_E_T_  = ' ' "
			cQuery += " 	AND DT8_CODPAS  = '" + PadR('TF',TamSx3("DT8_CODPAS")[1]) + "' "
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
			TcSetField(cAliasQry,"DT8_VALPAS","N",TamSX3("DT8_VALPAS")[1],TamSX3("DT8_VALPAS")[2])
			TcSetField(cAliasQry,"DT8_VALIMP","N",TamSX3("DT8_VALIMP")[1],TamSX3("DT8_VALIMP")[2])
			TcSetField(cAliasQry,"DT8_VALTOT","N",TamSX3("DT8_VALTOT")[1],TamSX3("DT8_VALTOT")[2])

			nDifValPas := DT6->DT6_VALFRE - (cAliasQry)->DT8_VALPAS 
			nDifValImp := DT6->DT6_VALIMP - (cAliasQry)->DT8_VALIMP 
			nDifValTot := DT6->DT6_VALTOT - (cAliasQry)->DT8_VALTOT 
			
			//-- Verifica se a diferenÁa È de centavos (considera que o m·ximo È 1 centavo por DT8, no arredondamento)
			nQtdDT8 := 0 
			aEval(aProduto,{|aPrd| aEval(aPrd[2],{|aFretePrd| nQtdDt8 += Iif(aFretePrd[3] <> "TF" .And. !Empty(aFretePrd[2]),1,0)}) })

			If  Abs(nDifValPas) > nQtdDT8 * (1 /10 ^ nDecValPas) .Or. ;
				Abs(nDifValImp) > nQtdDT8 * (1 /10 ^ nDecValImp) .Or. ;
				Abs(nDifValTot) > nQtdDT8 * (1 /10 ^ nDecValTot) 

				nDifValPas := 0 
				nDifValImp := 0 
				nDifValTot := 0 
			EndIf

			For n1Cnt := Len(aProduto) To 1 Step -1

				//-- Se n„o houver mais diferenÁas, para o laÁo
				If Empty(nDifValPas) .And. Empty(nDifValImp) .And. Empty(nDifValTot)
					Exit
				EndIf

				For n2Cnt := 1 To Len(aProduto[n1Cnt,2])

					//-- Se o valor do componente for zero
					If aProduto[n1Cnt,2,n2Cnt,2] <= 0 
						Loop
					EndIf

					//-- Busca DT8 para corrigir diferenÁa
					DT8->(DbSetOrder(2))  //-- DT8_FILIAL+DT8_FILDOC+DT8_DOC+DT8_SERIE+DT8_CODPRO+DT8_CODPAS
					If	DT8->(MsSeek(xFilial('DT8') + cFilAnt + cDocto + cSerie + aProduto[n1Cnt,1] + aProduto[n1Cnt,2,n2Cnt,3]))

						RecLock('DT8',.F.)
						If	aProduto[n1Cnt,2,n2Cnt,3] <> 'TF'

							//-- Aplica diferenÁa mÌnima de arredondamento (de acordo com qtde de casas decimais) ao componente
							DT8->DT8_VALPAS += Iif( !Empty(nDifValPas).And. nDifValPas > 0, 1, -1) * Iif( !Empty(nDifValPas), 1/(10^nDecValPas), 0 )
							DT8->DT8_VALIMP += Iif( !Empty(nDifValImp).And. nDifValImp > 0, 1, -1) * Iif( !Empty(nDifValImp), 1/(10^nDecValImp), 0 )
							DT8->DT8_VALTOT += Iif( !Empty(nDifValTot).And. nDifValTot > 0, 1, -1) * Iif( !Empty(nDifValTot), 1/(10^nDecValTot), 0 )

							//-- Reduz a diferenÁa aplicada do componente
							nDifValPas -= Iif( !Empty(nDifValPas).And. nDifValPas > 0, 1, -1) * Iif( !Empty(nDifValPas), 1/(10^nDecValPas), 0 ) 
							nDifValImp -= Iif( !Empty(nDifValImp).And. nDifValImp > 0, 1, -1) * Iif( !Empty(nDifValImp), 1/(10^nDecValImp), 0 )
							nDifValTot -= Iif( !Empty(nDifValTot).And. nDifValTot > 0, 1, -1) * Iif( !Empty(nDifValTot), 1/(10^nDecValTot), 0 )
						Else

							//-- Aplica diferenÁa ao Total do Frete do Produto
							DT8->DT8_VALPAS += (DT6->DT6_VALFRE - (cAliasQry)->DT8_VALPAS) - (Iif( (DT6->DT6_VALFRE - (cAliasQry)->DT8_VALPAS) > 0, 1, -1) * nDifValPas )
							DT8->DT8_VALIMP += (DT6->DT6_VALIMP - (cAliasQry)->DT8_VALIMP) - (Iif( (DT6->DT6_VALIMP - (cAliasQry)->DT8_VALIMP) > 0, 1, -1) * nDifValImp )
							DT8->DT8_VALTOT += (DT6->DT6_VALTOT - (cAliasQry)->DT8_VALTOT) - (Iif( (DT6->DT6_VALTOT - (cAliasQry)->DT8_VALTOT) > 0, 1, -1) * nDifValTot )
						EndIf
						MsUnlock()
					EndIf

				Next n2Cnt
			Next n1Cnt

			//-- Fecha a area da query para a comparaÁ„o
			(cAliasQry)->(DbCloseArea())
		EndIf

/*
    	// Esta validaÁ„o parou alguns clientes, apesar de estar correta. … preciso avaliar o motivo do erro
		// retirada a validaÁ„o temporariamente.

		//-- Valida se h· problemas no DT8 (exceto transporte internacional)
		If cTipTra != StrZero(4,Len(DT6->DT6_TIPTRA)) //-- Rodoviario Internacional
			DT8->(DbCommit()) //-- N„o Retirar - qdo em transaÁ„o, forÁa o envio de "update" ao Banco de dados
			cAliasQry := GetNextAlias()
			cQuery := " SELECT Count(1) NERR "
			cQuery += "   FROM " + RetSqlName("DT8")
			cQuery += "  WHERE  DT8_FILIAL  = '" + xFilial("DT8")  + "'"
			cQuery += " 	AND DT8_FILDOC  = '" + DT6->DT6_FILDOC + "'"
			cQuery += " 	AND DT8_DOC     = '" + DT6->DT6_DOC    + "'"
			cQuery += " 	AND DT8_SERIE   = '" + DT6->DT6_SERIE  + "'"
			cQuery += " 	AND D_E_L_E_T_  = ' ' "
			cQuery += " 	AND (DT8_VALTOT = 0 OR DT8_VALTOT < DT8_VALPAS) "
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)

			lErrDT8TOT := (cAliasQry)->(!Eof()) .And. !Empty((cAliasQry)->NERR)

			(cAliasQry)->(DbCloseArea())

			If lErrDT8TOT
				AAdd( aMsgErr, {STR0194 + DT6->DT6_FILDOC + ' / ' + DT6->DT6_DOC + ' / ' + DT6->DT6_SERIE, '22', "TMSA410()" } )  //-- 'Documento gerado sob configuraÁ„o tribut·ria ambigua e fora estornado: '
				DisarmTransaction()
				Break
			EndIf
		EndIf
*/
		//-- Ponto de entrada apos a gravacao do documento no DT6
		If lTM200DT6
			ExecBlock('TM200DT6',.F.,.F.,{DT6->DT6_FILDOC, DT6->DT6_DOC, DT6->DT6_SERIE})
		EndIf

		If	! l1oPerc .And. (	cDocTms == StrZero(2,nDocTms)     .Or. cDocTms == StrZero(5,nDocTms)     .Or. ;
								cDocTms == StrZero(6,nDocTms)     .Or. cDocTms == StrZero(9,nDocTms)     .Or. ;
								cDocTms == Replicate('A',nDocTms) .Or. cDocTms == Replicate('B',nDocTms) .Or. ;
								cDocTms == Replicate('C',nDocTms) .Or. cDocTms == Replicate('H',nDocTms) .Or. ;
								cDocTms == Replicate('I',nDocTms) .Or. cDocTms == Replicate('J',nDocTms) .Or. ;
								cDocTms == Replicate('N',nDocTms) .Or. cDocTms == Replicate('O',nDocTms) .Or. ;
								(lDocRee .And. (cDocTms == StrZero(7,nDocTms) .Or. cDocTms == Replicate('D',nDocTms))) )

			//-- Servico Operacional
			DC5->(dbSetOrder(1)) //DC5_FILIAL+DC5_SERVIC+DC5_ORDEM
			DC5->(MsSeek(xFilial("DC5")+cServic))

			//-- Grava movimento de viagem
			RecLock('DUD', .T.)
			DUD->DUD_FILIAL := xFilial('DUD')
			DUD->DUD_FILORI := cFilAnt
			DUD->DUD_FILDOC := cFilAnt
			DUD->DUD_DOC    := cDocto
			DUD->DUD_SERIE  := cSerie
			DUD->DUD_SERTMS := cSerTms
			DUD->DUD_TIPTRA := cTipTra
			DUD->DUD_CDRDES := cCdrDes
			DUD->DUD_CDRCAL := cCdrCal
			DUD->DUD_SERVIC := DC5->DC5_SEROPE
			DUD->DUD_STATUS := StrZero( 1, Len( DUD->DUD_STATUS ) ) //-- Status do documento igual a 1 - Em aberto
			DUD->DUD_GERROM := StrZero( 2, Len( DUD->DUD_GERROM ) ) //-- Nao
			DUD->DUD_ENDERE := IIf (TMSLocaliz(cCodPro,DUD->DUD_FILDOC,DUD->DUD_DOC,DUD->DUD_SERIE),"2","0")
			DUD->DUD_DOCTRF := StrZero( 2, Len( DUD->DUD_DOCTRF ) ) //-- Nao
			//-- A filial atual do documento eh utilizada pela rotina de estorno de operacoes de transporte, para
			//-- nao permitir estornar a operacao de chegada de viagem, se ja foram incluidos documentos nessa viagem
			DUD->DUD_FILATU := cFilAnt
			//-- Verifica se o Documento eh entrega Alianca da mesma regiao de origem
			If lAlianca .And. !Empty(aProduto[1,3]) //-- Qdo nao for chamado da manutencao de documentos
				cNumNfc := aProduto[1,3,1,1]
				cSerNfc := aProduto[1,3,1,2]
				DTC->(DbSetOrder(2)) //DTC_FILIAL+DTC_NUMNFC+DTC_SERNFC+DTC_CLIREM+DTC_LOJREM+DTC_CODPRO+DTC_FILORI+DTC_LOTNFC
				DTC->(MsSeek(xFilial('DTC') + cNumNfc + cSerNfc + cCliRem + cLojRem))
				cAlianca := DTC->DTC_ALIANC
				cRedLocal:= DTC->DTC_DPCLOC
				If ! Empty(cAlianca) .And. cRedLocal == '1'  				//-- Redespacho Local
					TMSDocAli(cFilAnt, cDocto, cSerie, @nPercurso)
					If nPercurso == 1 										//-- Primeiro Percurso
						DUD->DUD_SERTMS := StrZero(3,Len(DUD->DUD_SERTMS))	//-- Entrega Alianca
					EndIf
				EndIf
			EndIf
			//-- Grava o CEP de entrega
			DUD->DUD_CEPENT := TmsCEPEnt(cCliDes,cLojDes,,cSqEDes)

			If lTmsExp .And. !Empty(DTP->DTP_VIAGEM) .And. DT6->DT6_DOCTMS <> StrZero(6,Len(DT6->DT6_DOCTMS))
				DUD->DUD_VIAGEM := DTP->DTP_VIAGEM
				DUD->DUD_GERROM := StrZero( 1, Len( DUD->DUD_GERROM ) ) //-- Sim
				If cSerTms == StrZero(2,Len(DTQ->DTQ_SERTMS)) //-- Transporte
					aRegiao := TMSNivSup(cCdrCal) // Obtem os niveis superiores da regiao de calculo
					//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
					//≥ Retorna as Regioes / Filiais de Destino da Rota                       ≥
					//≥ Elementos contidos por dimensao:                                      ≥
					//≥ 1. Regiao Origem da Rota                                              ≥
					//≥ 2. Regioes de Destino da Rota                                         ≥
					//≥ 3. Filiais de Destino da Rota                                         ≥
					//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
					aRegRot := TMSRegDes(Posicione('DTQ',2,xFilial('DTQ')+DTP->(DTP_FILORI+DTP_VIAGEM),'DTQ_ROTA')) // Obtem as regioes da rota.
					For nElem := 1 To Len(aRegiao)
						/* Verifica se a regiao de destino do CTRC pertence a regiao da rota. */
						lAchou := Ascan(aRegRot, {|x| x[2] == aRegiao[nElem]}) > 0
						If lAchou
							Exit
						EndIf
					Next nElem
					If lAchou
						DUD->DUD_STROTA := "1"  //Da Rota
					Else
						DUD->DUD_STROTA := "3"  //De outra Rota
					EndIf
				Else
					//-- Atualizacao da zona e sertor para permitir a manutencao atraves da viagem modelo 1
					Posicione('DTQ',2,xFilial('DTQ')+DTP->(DTP_FILORI+DTP_VIAGEM),'DTQ_ROTA')
					If DTQ->DTQ_SERTMS == StrZero(1,Len(DTQ->DTQ_SERTMS))
						lColeta := .T.
					EndIf
					If TmsA144DA7(DUD->DUD_FILDOC,DUD->DUD_DOC,DUD->DUD_SERIE,DTQ->DTQ_ROTA,@cZona,@cSetor,.F.,,cTipTra,cSerTms)
						DUD->DUD_ZONA  := cZona
						DUD->DUD_SETOR := cSetor
					EndIf
				EndIf

				If lTMS3GFE .And. DTQ->DTQ_PAGGFE == StrZero(1,Len(DTQ->DTQ_PAGGFE)) .And. !IsInCallStack("TmsA144NFC")   //Sim
					aRetGFE:= Tmsa210GFE(0, DUD->DUD_SERTMS, DTQ->DTQ_FILORI, DTQ->DTQ_VIAGEM, .T.)
					If Len(aRetGFE) > 0
						DUD->DUD_UFORI := aRetGFE[1]
						DUD->DUD_CDMUNO:= aRetGFE[2]
						DUD->DUD_UFDES := aRetGFE[4]
						DUD->DUD_CDMUND:= aRetGFE[5]
						DUD->DUD_CDTPOP:= aRetGFE[7]
						DUD->DUD_CDCLFR:= aRetGFE[9]
					EndIf
				EndIf
				If DUD->(ColumnPos("DUD_DTRNPR")) > 0 .And.  DTQ->DTQ_SERTMS $ '3;1' .And. DTQ->DTQ_STATUS == StrZero(2,Len(DTQ->DTQ_STATUS)) //-- Em Transito
					cHoraReg	:= StrTran(Left(Time(),5),':','')
					DUD->DUD_DTRNPR := dDataBase
					DUD->DUD_HRRNPR := cHoraReg
					DUD->DUD_USURNP := RetCodUsr()
				EndIf
			EndIf

			DUD->( MsUnLock() )

			If lTM200DUD
				ExecBlock('TM200DUD',.F.,.F.,{DUD->DUD_FILDOC, DUD->DUD_DOC, DUD->DUD_SERIE})
			EndIf

		EndIf

		If lCTeUnico //Grava o CT-e ⁄nico na DTC

			cAliasDTC := GetNextAlias()
			cQuery := " SELECT R_E_C_N_O_ DTC_RECNO "
			cQuery += "		FROM " + RetSqlName("DTC")
			cQuery += "		WHERE DTC_FILIAL = '" + xFilial("DTC") + "' "
			cQuery += "		  AND DTC_FILORI = '" + cFilAnt + "' "
			cQuery += "		  AND DTC_LOTNFC = '" + cLotNfc + "' "
			cQuery += "		  AND D_E_L_E_T_ = ' '"
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDTC)

			While (cAliasDTC)->(!Eof())
				DTC->(MsGoto((cAliasDTC)->DTC_RECNO))
				RecLock('DTC',.F.)
				DTC->DTC_FILDOC	:= cFilAnt
				DTC->DTC_DOC	:= cDocto	//-- Numero do documento
				DTC->DTC_SERIE	:= cSerie	//-- Serie do documento
				MsUnLock()
				(cAliasDTC)->(DbSkip())
			EndDo
			(cAliasDTC)->(DbCloseArea())

		Else
			For n1Cnt := 1 To Len(aProduto)
				cCodPro := aProduto[n1Cnt,1]
				//-- Notas fiscais do cliente
				For n2Cnt := 1 To Len(aProduto[n1Cnt,3])
					cNumNfc := aProduto[n1Cnt,3,n2Cnt,1]
					cSerNfc := aProduto[n1Cnt,3,n2Cnt,2]

					cAliasDTC := GetNextAlias()
					cQuery := " SELECT R_E_C_N_O_ DTC_RECNO "
					cQuery += "		FROM " + RetSqlName("DTC")
					cQuery += "		WHERE DTC_FILIAL = '" + xFilial("DTC") + "' "
					cQuery += "		  AND DTC_NUMNFC = '" + cNumNfc + "' "
					cQuery += "		  AND DTC_SERNFC = '" + cSerNfc + "' "
					cQuery += "		  AND DTC_CLIREM = '" + cCliRem + "' "
					cQuery += "		  AND DTC_LOJREM = '" + cLojRem + "' "
					If lPrcProd
						cQuery += "   AND DTC_CODPRO = '" + cCodPro + "' "
					EndIf
					cQuery += "		  AND DTC_FILORI = '" + cFilAnt + "' "
					cQuery += "		  AND DTC_LOTNFC = '" + cLotNfc + "' "
					If lExped .And. !Empty(cCliExp+cLojExp)
						cQuery += " AND DTC_CLIEXP = '" + cCliExp + "' "
						cQuery += " AND DTC_LOJEXP = '" + cLojExp + "' "
					EndIf
					cQuery += "		  AND D_E_L_E_T_ = ' '"
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDTC)

					While (cAliasDTC)->(!Eof())
						DTC->(MsGoto((cAliasDTC)->DTC_RECNO))
						RecLock('DTC',.F.)
						DTC->DTC_FILDOC	:= cFilAnt
						If	l1oPerc
							DTC->DTC_DOCPER:= cDocto
						Else
							DTC->DTC_DOC	:= cDocto	//-- Numero do documento
							DTC->DTC_SERIE	:= cSerie	//-- Serie do documento
						EndIf
						MsUnLock()
						//-- Carga Fechada
						If lTmsCFec
							dDtEntr := iif(DTC->DTC_DTENTR > dDatabase, DTC->DTC_DTENTR,dDatabase) //-- Essa data È utilizada no preenchimento da ocorrencia de entrega automatica, a validacao e necessaria para na ter data retroativa em relacao a emissao do Doc.Transporte.
							cHrEntr := DTC->DTC_HORENT
							dDtCol  := DTC->DTC_DATCOL
							cHrCol  := DTC->DTC_HORCOL
							cFilOri := DTC->DTC_FILORI
							cFilCFS := DTC->DTC_FILCFS
							cNumSol := DTC->DTC_NUMSOL
							cRecebe := DTC->DTC_RECEBE
						EndIf
						(cAliasDTC)->(DbSkip())

						//--Grava DLR - Chave de CTE de SubcontrataÁ„o se utilizar o processo com MV_ISENSUB 
						If TableInDic("DLR") .And. !Empty(cIsenSub) .And. DTC->DTC_TIPNFC == '2'
							cUfOri	:= Posicione("DUY",1, xFilial('DUY')+ DTC->DTC_CDRORI ,"DUY_EST")
							If cUfOri $ cIsenSub
								DLR->(DbSetOrder(1)) 
								If DLR->(!MsSeek(xFilial('DLR')+cFilAnt+cDocto+cSerie+DTC->DTC_CTEANT))
									RecLock('DLR', .T.)
									DLR->DLR_FILDOC	:= cFilAnt
									DLR->DLR_DOC 	:= cDocto
									DLR->DLR_SERIE 	:= cSerie
									DLR->DLR_CHVCTE := DTC->DTC_CTEANT	
									DLR->( MsUnLock() )
								EndIf 
							EndIf 
						EndIf 
					EndDo
					(cAliasDTC)->(DbCloseArea())
				Next
			Next
		EndIf
		RestArea( aAreaAnt )

		//-- Agendamento de Entrega
		If lAgdEntr .AND. DYD->(ColumnPos("DYD_DIAATR")) > 0

			If MV_PAR07 == 1 // Verifica se Gera o Agendamento de entrega
				aTabDest := TMSTabDest(DT6->DT6_CLIDES,DT6->DT6_LOJDES)

				If aTabDest[1]

					If aTabDest[2] == '2' // N„o realiza Agendamento de Entrega
						lExecAGD := .F.

					ElseIf  EMPTY(DTC->DTC_DATAGD) .AND. EMPTY(DTC->DTC_PRDAGD);
								 .AND. EMPTY(DTC->DTC_INIAGD) .AND. EMPTY(DTC->DTC_FIMAGD)  // Se preenchido os campos de agendamento

						If	aTabDest[2] == '3' // Obrigatorio

							// ALtera o tipo para Pendente agendamento
							RecLock("DTC", .F.)
							DTC->DTC_TIPAGD := "4"
							MsUnLock()

							lExecAGD := .T.

						Else
							lExecAGD := .F.
						EndIf

					EndIf

					If lExecAGD

						aAdd( aValuesAGD, { 'DYD_TIPAGD', DTC->DTC_TIPAGD } )
						If DTC->DTC_TIPAGD != '4' 					// Verifica se n„o esta aguardando agendamento.
						    aAdd( aValuesAGD, { 'DYD_DATAGD', DTC->DTC_DATAGD } )
							aAdd( aValuesAGD, { 'DYD_PRDAGD', DTC->DTC_PRDAGD } )
							aAdd( aValuesAGD, { 'DYD_INIAGD', DTC->DTC_INIAGD } )
							aAdd( aValuesAGD, { 'DYD_FIMAGD', DTC->DTC_FIMAGD } )
						Else
							RecLock("DTC",.F.)
							DTC->DTC_DATAGD  := STOD("//")
							DTC->DTC_PRDAGD  := ""
							DTC->DTC_INIAGD  := ""
							DTC->DTC_FIMAGD  := ""
							MsUnLock()
						EndIf
						aAdd( aValuesAGD, { 'DYD_FILDOC', DT6->DT6_FILDOC } )
						aAdd( aValuesAGD, { 'DYD_DOC'   , DT6->DT6_DOC 	  } )
						aAdd( aValuesAGD, { 'DYD_SERIE' , DT6->DT6_SERIE  } )
						aAdd( aValuesAGD, { 'DYD_MOTAGD', DTC->DTC_MOTAGD } )

						cNumAgd := 	TMSA200AGD(3,aValuesAGD)[2] 		// Realiza o Agendamento de Entrega

					EndIF
				EndIf
			EndIf
		EndIf
		//-- Carga Fechada - Geracao automatica de ocorrencias,
		//   Geracao automatica de viagens e atualizacao do status do documento.
		If lTmsCFec .And. cSerTms == StrZero(3,Len(DT6->DT6_SERTMS)) //-- Entrega
			TMSA200CFec(cDocto,cSerie,cFilOri,cNumSol,dDtCol,cHrCol,dDtEntr,cHrEntr,cRecebe,cFilCFS,DT6->DT6_QTDVOL,DT6->DT6_PESO)
		EndIf

		//--Nao pode fazer esta atualizacao, se a chamada for do CRT Complemento, pelo Manutencao de Documentos
		If cTipTra == StrZero(4,Len(DT6->DT6_TIPTRA)) //-- Rodoviario Internacional
			If FunName() != "TMSA500"
				cIncote := DTC->DTC_INCOTE
				DIK->(DbSetOrder(1)) //DIK_FILIAL+DIK_FILORI+DIK_LOTNFC
				If DIK->(MsSeek(xFilial('DIK')+cFilAnt+cLotNfc))
					RecLock('DIK',.F.)
					DIK->DIK_FILDOC := cFilAnt
					DIK->DIK_DOC    := cDocto
					DIK->DIK_SERIE  := cSerie
					MsUnLock()
					//-- Atualiza DI9
					DI9->(DbSetOrder(1))
					If DI9->(MsSeek(cSeekDI9 := xFilial('DI9')+cFilAnt+cLotNfc))
						While DI9->(!Eof()) .And. DI9->(DI9_FILIAL+DI9_FILORI+DI9_LOTNFC) == cSeekDI9
							RecLock('DI9',.F.)
							DI9->DI9_FILDOC := cFilAnt
							DI9->DI9_DOC    := cDocto
							DI9->DI9_SERIE  := cSerie
							MsUnLock()
							DI9->(dbSkip())
						EndDo
					EndIf
					//-- Atualiza DIA
					DIA->(DbSetOrder(1))
					If DIA->(MsSeek(cSeekDIA := xFilial('DIA')+cFilAnt+cLotNfc))
						While DIA->(!Eof()) .And. DIA->(DIA_FILIAL+DIA_FILORI+DIA_LOTNFC) == cSeekDIA
							RecLock('DIA',.F.)
							DIA->DIA_FILDOC := cFilAnt
							DIA->DIA_DOC    := cDocto
							DIA->DIA_SERIE  := cSerie
							MsUnLock()
							DIA->(dbSkip())
						EndDo
					EndIf
				Else
					DTC->(DbSetOrder(3))
					cFilOri := Posicione('DTC',3,xFilial('DTC')+cFilAnt+cDocto+cSerie,'DTC_FILORI')
					cFilOri := DTC->DTC_FILCFS
					cRota   := DTC->DTC_ROTA
					cNumCot := DTC->DTC_NUMCOT
					//-- Atualiza CRT
					RecLock('DIK',.T.)
					DIK->DIK_FILIAL := xFilial('DIK')
					DIK->DIK_FILORI := cFilAnt
					DIK->DIK_LOTNFC := cLotNfc
					DIK->DIK_DATENT := dDataBase
					DIK->DIK_FILDOC := cFilAnt
					DIK->DIK_DOC    := cDocto
					DIK->DIK_SERIE  := cSerie
					DIK->DIK_FILCFS := cFilOri
					DIK->DIK_NUMSOL := DTC->DTC_NUMSOL
					DIK->DIK_DATCOL := DTC->DTC_DATCOL
					DIK->DIK_HORCOL := DTC->DTC_HORCOL
					DIK->DIK_CLIREM := cCliRem
					DIK->DIK_LOJREM := cLojRem
					DIK->DIK_CLIDES := cCliDes
					DIK->DIK_LOJDES := cLojDes
					DIK->DIK_CLICON := cCliCon
					DIK->DIK_LOJCON := cLojCon
					DIK->DIK_CLINOT := DTC->DTC_CLINOT
					DIK->DIK_LOJNOT := DTC->DTC_LOJNOT
					DIK->DIK_PESO   := nPeso
					DIK->DIK_PESOM3 := nPesoM3
					DIK->DIK_PESLIQ := nPesLiq
					DIK->DIK_METRO3 := nMetro3
					DIK->DIK_VALOR  := nValor
					DIK->DIK_INCOTE := DTC->DTC_INCOTE
					DIK->DIK_DEVFRE := cDevFre
					DIK->DIK_SERTMS := cSerTms
					DIK->DIK_CLIDEV := cCliDev
					DIK->DIK_LOJDEV := cLojDev
					DIK->DIK_TIPFRE := cTipFre
					DIK->DIK_SELORI := DTC->DTC_SELORI
					DIK->DIK_SERVIC := cServic
					DIK->DIK_CDRORI := cCdrOri
					DIK->DIK_CDRDES := cCdrDes
					DIK->DIK_CDRCAL := cCdrCal
					DIK->DIK_ROTA   := cRota
					DIK->DIK_VALSEG := DTC->DTC_VALSEG
					DIK->DIK_MOEDA  := DTC->DTC_MOEDA
					DIK->DIK_MOENFC := DTC->DTC_MOENFC
					DIK->DIK_STATUS := '2' //-- CRT Gerado
					DIK->DIK_CODNEG := cCodNeg

					MsUnLock()
					//-- Atualiza DIN
					While DTC->(!Eof()) .And. DTC->(DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE) == xFilial('DTC')+cFilAnt+cDocto+cSerie
						RecLock('DIN',.T.)
						DIN->DIN_FILIAL := xFilial('DIN')
						DIN->DIN_FILORI := cFilAnt
						DIN->DIN_LOTNFC := cLotNfc
						DIN->DIN_NUMNFC := DTC->DTC_NUMNFC
						DIN->DIN_SERNFC := DTC->DTC_SERNFC
						DIN->DIN_CODPRO := DTC->DTC_CODPRO
						DIN->DIN_CODEMB := DTC->DTC_CODEMB
						DIN->DIN_EMINFC := DTC->DTC_EMINFC
						DIN->DIN_QTDVOL := DTC->DTC_QTDVOL
						DIN->DIN_PESO   := DTC->DTC_PESO
						DIN->DIN_PESLIQ := DTC->DTC_PESLIQ
						DIN->DIN_PESOM3 := DTC->DTC_PESOM3
						DIN->DIN_VALOR  := DTC->DTC_VALOR
						DIN->DIN_METRO3 := DTC->DTC_METRO3
						MsUnLock()
						DTC->(dbSkip())
					EndDo
					//-- Composicao do Frete por Pais
					If !Empty(cNumCot)
						cAliasQry := GetNextAlias()
						DI7->(DbSetOrder(1))
						cQuery := "SELECT * FROM "+RetSqlName("DI7")
						cQuery += " WHERE DI7_FILIAL = '"+xFilial("DI7")+"'"
						cQuery += "   AND DI7_FILORI = '"+cFilOri+"'"
						cQuery += "   AND DI7_NUMCOT = '"+cNumCot+"'"
						cQuery += "   AND D_E_L_E_T_ = ' '"
						cQuery += " ORDER BY "+SqlOrder(DI7->(IndexKey()))
						cQuery := ChangeQuery(cQuery)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
						TcSetField(cAliasQry,"DI7_PERFRE","N",TamSX3("DI7_PERFRE")[1],TamSX3("DI7_PERFRE")[2])
						While (cAliasQry)->(!Eof())
							AAdd( aFrtPais, { (cAliasQry)->DI7_ITEM, (cAliasQry)->DI7_PAIS, '', (cAliasQry)->DI7_PERFRE, 0 })
							(cAliasQry)->(dbSkip())
						EndDo
						(cAliasQry)->(dbCloseArea())
					Else
						aFrtPais := TMSFrtPais(cRota,cIncote)
					EndIf
					nSldFrt := nValBrut
					For nCnt := 1 To Len(aFrtPais)
						If nCnt == Len(aFrtPais) .And. nSldFrt > 0
							nFrtPais := nSldFrt
						Else
							nFrtPais := (aFrtPais[nCnt,4] * nValBrut) / 100
							nSldFrt  -= nFrtPais
						EndIf
						aFrtPais[nCnt,5] := nFrtPais
						RecLock("DI9",.T.)
						DI9->DI9_FILIAL := xFilial("DI9")
						DI9->DI9_FILORI := cFilAnt
						DI9->DI9_LOTNFC := cLotNfc
						DI9->DI9_FILDOC := cFilAnt
						DI9->DI9_DOC    := cDocto
						DI9->DI9_SERIE  := cSerie
						DI9->DI9_ITEM   := aFrtPais[nCnt,1]
						DI9->DI9_PAIS   := aFrtPais[nCnt,2]
						DI9->DI9_PERFRE := aFrtPais[nCnt,4]
						DI9->DI9_VALTOT := aFrtPais[nCnt,5]
						MsUnLock()
					Next nCnt
					//-- Composicao do Frete CIF/FOB
					If (cIncote == "DAF" .Or. cIncote == "DDU") //-- Ate a Fronteira
						If !Empty(cNumCot)
							cAliasQry := GetNextAlias()
							DI8->(DbSetOrder(1))
							cQuery := "SELECT * FROM "+RetSqlName("DI8")
							cQuery += " WHERE DI8_FILIAL = '"+xFilial("DI8")+"'"
							cQuery += "   AND DI8_FILORI = '"+cFilOri+"'"
							cQuery += "   AND DI8_NUMCOT = '"+cNumCot+"'"
							cQuery += "   AND D_E_L_E_T_ = ' '"
							cQuery += " ORDER BY "+SqlOrder(DI8->(IndexKey()))
							cQuery := ChangeQuery(cQuery)
							dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
							While (cAliasQry)->(!Eof())
								AAdd(aFrtDAF,{ (cAliasQry)->DI8_CODPAS, '', (cAliasQry)->DI8_PERCIF, (cAliasQry)->DI8_PERFOB, 0, 0 })
								(cAliasQry)->(dbSkip())
							EndDo
							(cAliasQry)->(dbCloseArea())
						Else
							aFrtDAF := TMSFrtDAF(cCliRem,cLojRem,cCliDes,cLojDes)
						EndIf
						cAliasQry:= GetNextAlias()
						For nCnt := 1 To Len(aFrtDAF)
							//-- Calcula o valor do frete CIF/FOB (Incoterm DAF)
							cCodPas := aFrtDAF[nCnt,1]
							nTotPas := 0
							If cCodPas == "TF"
								Loop
							EndIf
							cQuery := " SELECT SUM(DT8_VALTOT) VALTOT "
							cQuery += "   FROM " + RetSqlName("DT8")
							cQuery += "  WHERE DT8_FILIAL = '"+xFilial("DT8")+"'"
							cQuery += " 	AND DT8_FILDOC = '"+cFilAnt+"'"
							cQuery += " 	AND DT8_DOC    = '"+cDocto +"'"
							cQuery += " 	AND DT8_SERIE  = '"+cSerie +"'"
							cQuery += " 	AND DT8_CODPAS = '"+cCodPas+"'"
							cQuery += " 	AND D_E_L_E_T_ = ' ' "
							cQuery := ChangeQuery(cQuery)
							dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
							If (cAliasQry)->(!Eof())
								nTotPas := (cAliasQry)->VALTOT
							EndIf
							(cAliasQry)->(dbCloseArea())
							aFrtDAF[nCnt,5] := (aFrtDAF[nCnt,3] * nTotPas) / 100
							aFrtDAF[nCnt,6] := (aFrtDAF[nCnt,4] * nTotPas) / 100
							nValCIF += aFrtDAF[nCnt,5]
							nValFOB += aFrtDAF[nCnt,6]
						Next nCnt
						If nValCIF > 0 .Or. nValFOB > 0
							nTF := Ascan(aFrtDAF,{ | e | e[1] == "TF" })
							If nTF > 0
								aFrtDAF[nTF,5] := nValCIF
								aFrtDAF[nTF,6] := nValFOB
							EndIf
						EndIf
						For nCnt := 1 To Len(aFrtDAF)
							RecLock("DIA",.T.)
							DIA->DIA_FILIAL := xFilial("DIA")
							DIA->DIA_FILORI := cFilAnt
							DIA->DIA_LOTNFC := cLotNfc
							DIA->DIA_FILDOC := cFilAnt
							DIA->DIA_DOC    := cDocto
							DIA->DIA_SERIE  := cSerie
							DIA->DIA_CODPAS := aFrtDAF[nCnt,1]
							DIA->DIA_PERCIF := aFrtDAF[nCnt,3]
							DIA->DIA_PERFOB := aFrtDAF[nCnt,4]
							DIA->DIA_VALCIF := aFrtDAF[nCnt,5]
							DIA->DIA_VALFOB := aFrtDAF[nCnt,6]
							MsUnLock()
						Next nCnt
					EndIf
				EndIf
				If (cIncote == "DAF" .Or. cIncote == "DDU") //-- Ate a Fronteira
					//-- Gera documento para cobranca do 2o.devedor
					DT6->(DbSetOrder(1))
					If	DT6->(MsSeek(xFilial('DT6')+cFilAnt+cDocto+cSerie))
						RecLock('DT6',.F.)
						DT6->DT6_VALFAT := Posicione('DIA',2,xFilial('DIA')+cFilAnt+cDocto+cSerie+'TF','DIA_VALCIF')
						MsUnLock()
						nValFOB := Posicione('DIA',2,xFilial('DIA')+cFilAnt+cDocto+cSerie+'TF','DIA_VALFOB')
						If nValFOB > 0
							aAreaDT6 := DT6->(GetArea())
							cSerDeb  := 'D01'
							While .T.
								If DT6->(!MsSeek(xFilial('DT6')+cFilAnt+cDocto+cSerDeb))
									Exit
								EndIf
								cSerDeb := Soma1(cSerDeb)
							EndDo
							RestArea(aAreaDT6)
							aCampos  := {}
							AAdd( aCampos, { 'DT6_SERIE' , cSerDeb } )
							AAdd( aCampos, { 'DT6_FILVGA', CriaVar('DT6_FILVGA',.F.) } )
							AAdd( aCampos, { 'DT6_NUMVGA', CriaVar('DT6_NUMVGA',.F.) } )
							AAdd( aCampos, { 'DT6_TIPFRE', '2'     } )
							AAdd( aCampos, { 'DT6_FILDCO', cFilAnt } )
							AAdd( aCampos, { 'DT6_DOCDCO', cDocto  } )
							AAdd( aCampos, { 'DT6_SERDCO', cSerie  } )
							AAdd( aCampos, { 'DT6_VALFRE', nValFOB } )
							AAdd( aCampos, { 'DT6_VALIMP', 0 } )
							AAdd( aCampos, { 'DT6_VALTOT', nValFOB } )
							AAdd( aCampos, { 'DT6_VALFAT', nValFOB } )
							AAdd( aCampos, { 'DT6_CLIDEV', DT6->DT6_CLIDES } )
							AAdd( aCampos, { 'DT6_LOJDEV', DT6->DT6_LOJDES } )
							AAdd( aCampos, { 'DT6_STATUS', '7'  } ) //-- Entregue
							TmsCopyReg(aCampos)
							RestArea(aAreaDT6)
							//-- Atualiza composicao de frete do novo documento
							DbSelectArea('DT8')
							aCompPrd := {}
							DT8->(DbSetOrder(2))
							If DT8->(MsSeek(cSeekDT8 := xFilial('DT8')+cFilAnt+cDocto+cSerie))
								While DT8->(!Eof()) .And. DT8->(DT8_FILIAL+DT8_FILDOC+DT8_DOC+DT8_SERIE) == cSeekDT8
									If (nPosComp:= Ascan(aCompPrd,{ | e | e[1] == DT8->DT8_CODPRO })) == 0
										AAdd(aCompPrd,{ DT8->DT8_CODPRO, 0, 0, 0 })
										nPosComp := Len(aCompPrd)
									EndIf
									aAreaDT8 := DT8->(GetArea())
									aCampos  := {}
									nValImp  := 0
									If DT8->DT8_CODPAS == 'TF'
										nValPas := 0
										nValTot := 0
									Else
										nValPas := Posicione('DIA',2,xFilial('DIA')+cFilAnt+cDocto+cSerie+DT8->DT8_CODPAS,'DIA_VALFOB')
										nValTot := nValPas
									EndIf
									aCompPrd[nPosComp,2] += nValPas
									aCompPrd[nPosComp,3] += nValImp
									aCompPrd[nPosComp,4] += nValTot
									AAdd( aCampos, { 'DT8_SERIE'  , cSerDeb } )
									AAdd( aCampos, { 'DT8_VALPAS' , nValPas } )
									AAdd( aCampos, { 'DT8_VALIMP' , nValImp } )
									AAdd( aCampos, { 'DT8_VALTOT' , nValTot } )
									TmsCopyReg(aCampos)
									RestArea(aAreaDT8)
									DT8->(dbSkip())
								EndDo
							EndIf
							For nCnt := 1 To Len(aCompPrd)
								If DT8->(MsSeek(xFilial('DT8')+cFilAnt+cDocto+cSerDeb+aCompPrd[nCnt,1]+'TF'))
									RecLock('DT8',.F.)
									DT8->DT8_VALPAS := aCompPrd[nCnt,2]
									DT8->DT8_VALIMP := aCompPrd[nCnt,3]
									DT8->DT8_VALTOT := aCompPrd[nCnt,4]
								EndIf
							Next nCnt
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	Else
		//-- Adiciona em aPedBlq os pedidos bloqueados
		For n1Cnt := 1 To Len( aPedido )
			AAdd(aPedBlq,{aPedido[n1Cnt,1],aPedido[n1Cnt,2],aPedido[n1Cnt,3],aPedido[n1Cnt,4],aPedido[n1Cnt,5],aPedido[n1Cnt,6],aPedido[n1Cnt,7],aPedido[n1Cnt,8],aPedido[n1Cnt,9],aPedido[n1Cnt,10],aPedido[n1Cnt,11],aPedido[n1Cnt,12],aPedido[n1Cnt,13]})
		Next

		For n1Cnt := 1 To Len(aProduto)
			cCodPro := aProduto[n1Cnt,1]
			//-- Notas fiscais do cliente
			For n2Cnt := 1 To Len(aProduto[n1Cnt,3])
				cNumNfc := aProduto[n1Cnt,3,n2Cnt,1]
				cSerNfc := aProduto[n1Cnt,3,n2Cnt,2]

				cAliasDTC := GetNextAlias()
				cQuery := " SELECT R_E_C_N_O_ DTC_RECNO "
				cQuery += "		FROM " + RetSqlName("DTC")
				cQuery += "		WHERE DTC_FILIAL = '" + xFilial("DTC") + "' "
				cQuery += "		  AND DTC_NUMNFC = '" + cNumNfc + "' "
				cQuery += "		  AND DTC_SERNFC = '" + cSerNfc + "' "
				cQuery += "		  AND DTC_CLIREM = '" + cCliRem + "' "
				cQuery += "		  AND DTC_LOJREM = '" + cLojRem + "' "
				If lPrcProd
					cQuery += "   AND DTC_CODPRO = '" + cCodPro + "' "
				EndIf
				cQuery += "		  AND DTC_FILORI = '" + cFilAnt + "' "
				cQuery += "		  AND DTC_LOTNFC = '" + cLotNfc + "' "
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDTC)
				While (cAliasDTC)->(!Eof())
					DTC->(MsGoto((cAliasDTC)->DTC_RECNO))
					RecLock('DTC',.F.)
					DTC->DTC_FILDOC	:= cFilAnt
					If	l1oPerc
						DTC->DTC_DOCPER	:= cNumPed
					Else
						DTC->DTC_DOC	:= cNumPed
						DTC->DTC_SERIE	:= cSerPed
					EndIf
					MsUnLock()
					(cAliasDTC)->(DbSkip())
				EndDo
				(cAliasDTC)->(DbCloseArea())
			Next
		Next
		RestArea( aAreaAnt )
	EndIf
End Transaction

//-- Ponto de entrada apos a gravacao de todo o processo
If lTM200Fim
	DT6->(DbSetOrder( 2 ))
	If	DT6->(MsSeek(xFilial('DT6') + cFilAnt + cLotNfc + cFilAnt + cDocto + cSerie))
		ExecBlock('TM200FIM',.F.,.F.,{DT6->DT6_FILDOC, DT6->DT6_DOC, DT6->DT6_SERIE})
	EndIf
EndIf

ResetArr(@aAreaSM0   )
ResetArr(@aCliPrz    )
ResetArr(@aTmpEnt    )
ResetArr(@aDataBase  )
ResetArr(@aAJustRat  )
ResetArr(@aAreaSE1   )
ResetArr(@aVenc      )
ResetArr(@aChvSD2    )
ResetArr(@aRegiao    )
ResetArr(@aRegRot    )
ResetArr(@aAreaSF3   )
ResetArr(@aValCrdPre )
ResetArr(@aFrtPais   )
ResetArr(@aFrtDAF    )
ResetArr(@aCampos    )
ResetArr(@aAreaDT6   )
ResetArr(@aAreaDT8   )
ResetArr(@aCompPrd   )
ResetArr(@aCpoImpost )
ResetArr(@aValuesAGD )
ResetArr(@aTabDest   )
ResetArr(@aModFat    )
ResetArr(@aRetGFE    )
RestArea( aAreaDTC )
RestArea( aAreaSC9 )
RestArea( aAreaAnt )

Return( Nil )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TmsA200Acr≥ Autor ≥ Eduardo de Souza      ≥ Data ≥ 16/04/04 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Aplica acrescimo ao valor do frete                         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥                                                            ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TmsA200Acr(nValor,nAcres)

Local nRet	:= 0

If ! Empty( nAcres )
	nRet := nValor + NoRound(nValor * ( nAcres / 100 ))
EndIf

Return( nRet )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200CFec≥ Autor ≥ Eduardo de Souza     ≥ Data ≥ 30/07/04 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Carga Fechada - Geracao de Viagens e atualizacao de status ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA200CFec()                                              ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpC1 - Documento                                          ≥±±
±±≥          ≥ ExpC2 - Serie do Documento                                 ≥±±
±±≥          ≥ ExpC3 - Filial Origem                                      ≥±±
±±≥          ≥ ExpC4 - Solicitacao de Coleta                              ≥±±
±±≥          ≥ ExpD1 - Data da Coleta                                     ≥±±
±±≥          ≥ ExpC5 - Hora da Coleta                                     ≥±±
±±≥          ≥ ExpD2 - Data da Entrega                                    ≥±±
±±≥          ≥ ExpC6 - Hora da Entrega                                    ≥±±
±±≥          ≥ ExpC7 - Filial de Origem da Solic.Coleta / Cotacao de Frete≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ TMSAF05                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function TMSA200CFec(cDocto,cSerie,cFilOri,cNumSol,dDtCol,cHrCol,dDtEntr,cHrEntr,cRecebe,cFilCFS,nQtdVol,nPeso)

Local cFilCol   := ''
Local cVgeCol   := ''
Local cFilEnt   := ''
Local cVgeEnt   := ''
Local cSeekDT5  := ''
Local cQuery    := ''
Local cAliasDUD := GetNextAlias()
Local cAliasDTC := GetNextAlias()
Local cAliasDF1 := GetNextAlias()
Local aAreaDTC  := DTC->(GetArea())
Local aAreaDTQ  := DTQ->(GetArea())
Local aDocAux   := Array(34)
Local lContinua := .F.
Local lEncerra  := .T.
Local lExistDUH := .F.
Local nCnt      := 0
//parametro que indica se altera o status do documento que tem viagem em aberto para indicado para entrega
Local lTmsVgce  := GetMv("MV_TMSVGCE",.T.) //so verifica se o parametro existe
Local cFilDT5   := xFilial("DT5")
Local cFilDF1   := xFilial("DF1")
Local cFilDF0   := xFilial("DF0")
Local cOcorCan  := SuperGetMv('MV_OCORCAN',,'') //-- Ocorrencia de Cancelamento p/ Viagem de Coleta Planejada em aberto
Local lContVei  := GetMV('MV_CONTVEI',,.T.) // Parametro para verificar se o sistema devera' controlar veiculo/motorista
Local aAgend    := {}
Local aCab      := {}
Local aItens    := {}
Local lTmsExp   := TmsExp() .And. Substr(FunName(),1,7) == "TMSA144"
Local lCancViag := .T.
Local cSerTmsDT6:= ""
Local lAchou	  := .F.
//////////////////////////////////////////////////////////////////////////////////////////////
// Indica se em um Processo de Carga Fechada, o sistema devera Gerar o Processo de Entrega, //
// mesmo nao existindo o processo de Agendamento. Sera utilizado nos casos onde o processo  //
// de Carga Fechada eh feito sem o Agendamento, indo atraves da Sol.Coleta, Coleta e Ent.NF //
//////////////////////////////////////////////////////////////////////////////////////////////
Local lEntSAgen := SuperGetMv( "MV_ENTSAGE", , .T. )
Local lChkAgend := .F.
Local lITmsDmd    := SuperGetMv("MV_ITMSDMD",,.F.)

//-- Variavies utilizadas na viagem de entrega
Private aRota     := {}
Private aDocto    := {}
Private lColeta   := .F.
Private cSerTms   := ''
Private cTipTra   := ''
Private nTipVia   := 3 //-- Planejada
Private aCompViag := {}
Private lLocaliz  := GetMv('MV_LOCALIZ') == 'S'
Private nCarreg   := 2

Default cFilCFS   := ''
Default nQtdVol   := 0
Default nPeso     := 0

If lTmsVgce
	lTmsVgce := GetMv("MV_TMSVGCE" ,.F.,.T.)
	If ValType(lTmsVgce) <> "L"
		lTmsVgce := .T.
	EndIf
Else
	lTmsVgce := .T.
EndIf

//-- Somente atualiza executa a rotina da carga fechada se a data/hora de coleta ou entrega forem informadas.
If !( ( !Empty(dDtCol) .And. !Empty(cHrCol) ) .Or. ( !Empty(dDtEntr) .And. !Empty(cHrEntr) ) )
	Return( .T. )
EndIf

//Verifica dados da Ocorrencia do parametro MV_OCORCAN
lOcorCan:= .F.
DT2->(dbSetOrder(1)) //DT2_FILIAL+DT2_CODOCO
If DT2->(MsSeek(xFilial("DT2")+cOcorCan))
	If !Empty(DT2->DT2_SERTMS)
		If	DT2->DT2_SERTMS == StrZero(1, Len(DT2->DT2_SERTMS)) .And. ;	//Servico Coleta
			DT2->DT2_TIPOCO == StrZero(12,Len(DT2->DT2_TIPOCO ))		//Ocorrencia tipo Cancelamento
			lOcorCan:= .T.
		EndIf
	Else
		//O serviÁo adicional permite DT2_SERTMS em branco

		//-- Retorna o numero da viagem de coleta
		DT5->(dbSetOrder(1)) //DT5_FILIAL+DT5_FILORI_DT5_NUMSOL
		If !Empty(cFilCFS)
			cFilDT5  := IIf(Empty(cFilDT5), cFilDT5, cFilCFS)
			cSeekDT5 := cFilDT5+cFilCFS+cNumSol
		Else
			cSeekDT5 := cFilDT5+cFilOri+cNumSol
		EndIf

		If DT5->(MsSeek(cSeekDT5))
			DbSelectArea("DT6")
			DbSetOrder(1) //Filial+Fil.Doc+Num.Doc+Serie Doc
			If MsSeek(xFilial("DT6")+DT5->DT5_FILDOC+DT5->DT5_DOC+DT5->DT5_SERIE)
				cSerTmsDT6 := DT6->DT6_SERTMS
				lAchou := .T.
			Endif
			If	lAchou .And. cSerTmsDT6 == StrZero(1, Len(DT2->DT2_SERTMS)) .And. ;	//Servico Coleta
				DT2->DT2_TIPOCO == StrZero(12,Len(DT2->DT2_TIPOCO ))		//Ocorrencia tipo Cancelamento
				lOcorCan:= .T.
			EndIf
		Endif
	EndIf
EndIf
//-- Retorna o numero da viagem de coleta
DT5->(dbSetOrder(1)) //DT5_FILIAL+DT5_FILORI_DT5_NUMSOL
If !Empty(cFilCFS)
	cFilDT5  := IIf(Empty(cFilDT5), cFilDT5, cFilCFS)
	cSeekDT5 := cFilDT5+cFilCFS+cNumSol
Else
	cSeekDT5 := cFilDT5+cFilOri+cNumSol
EndIf
If DT5->(MsSeek(cSeekDT5))
	lContinua := .T.
	cQuery := "SELECT DUD_FILORI, DUD_VIAGEM, DUD_SERTMS, DUD_TIPTRA, DUD_STATUS "
	cQuery += "  FROM "+RetSQLName("DUD")
	cQuery += " WHERE DUD_FILIAL = '"+xFilial('DUD') +"'"
	cQuery += "   AND DUD_FILDOC = '"+DT5->DT5_FILDOC+"'"
	cQuery += "   AND DUD_DOC    = '"+DT5->DT5_DOC   +"'"
	cQuery += "   AND DUD_SERIE  = '"+DT5->DT5_SERIE +"'"
	cQuery += "   AND D_E_L_E_T_ = ' '"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDUD)
	While (cAliasDUD)->(!Eof())
		If (cAliasDUD)->DUD_STATUS <> StrZero(9,Len(DUD->DUD_STATUS)) //-- Cancelado
			cFilCol := (cAliasDUD)->DUD_FILORI
			cVgeCol := (cAliasDUD)->DUD_VIAGEM
			cSerTms := (cAliasDUD)->DUD_SERTMS
			cTipTra := (cAliasDUD)->DUD_TIPTRA
			Exit
		EndIf
		(cAliasDUD)->(dbSkip())
	EndDo
	(cAliasDUD)->(dbCloseArea())
EndIf

//-- Gera documento com o status 'Entregue', caso a data/hora de entrega seja informada na nota fiscal.
If !Empty(dDtEntr) .And. !Empty(cHrEntr)
	//-- Cancela Viagem de Coleta Planejada se estiver "Em Aberto"
	If !Empty(cFilCol) .And. !Empty(cVgeCol)
		aAreaDTQ  := DTQ->(GetArea())

		DTQ->(dbSetOrder(2)) //DTQ_FILIAL+DTQ_VIAGEM
		If DTQ->(MsSeek(xFilial("DTQ")+cFilCol+cVgeCol))
		//-- Caso a data de entrega esteja preenchida e a viagem È Planejada e estiver em 'Aberto'.
			If	DTQ->DTQ_TIPVIA == StrZero(3, Len(DTQ->DTQ_TIPVIA)) .And.;         //-- Planejada
				DTQ->DTQ_STATUS == StrZero(1,Len(DTQ->DTQ_STATUS))                 //-- Em aberto

				If lOcorCan
					DUD->(dbSetOrder(1)) //DUD_FILIAL+DUD_FILDOC+DUD_DOC+DUD_SERIE+DUD_FILORI+DUD_VIAGEM
					If DUD->(MsSeek(xFilial("DUD")+DT5->DT5_FILDOC+DT5->DT5_DOC+DT5->DT5_SERIE))
						//-- Cabecalho da Ocorrencia
						AAdd(aCab,{"DUA_FILORI",DTQ->DTQ_FILORI,Nil})
						AAdd(aCab,{"DUA_VIAGEM",DTQ->DTQ_VIAGEM,Nil})
						//-- Itens da Ocorrencia
						aItens:= {}
						AAdd(aItens,{	{"DUA_SEQOCO", StrZero(1,Len(DUA->DUA_SEQOCO)),	Nil},;
										{"DUA_DATOCO", dDtCol,								Nil},;
										{"DUA_HOROCO", cHrCol,								Nil},;
										{"DUA_CODOCO", cOcorCan,							Nil},;
										{"DUA_RECEBE", cRecebe,								Nil},;
										{"DUA_SERTMS", StrZero(1,Len(DUA->DUA_SERTMS)),	Nil},;
										{"DUA_FILDOC", DUD->DUD_FILDOC,						Nil},;
										{"DUA_DOC"   , DUD->DUD_DOC,						Nil},;
										{"DUA_SERIE" , DUD->DUD_SERIE,						Nil},;
										{"DUA_QTDOCO", nQtdVol,								Nil},;
										{"DUA_PESOCO", nPeso,								Nil}})

						//-- Inclusao da Ocorrencia
						MsExecAuto({|x,y,z|Tmsa360(x,y,z)},aCab,aItens,{},3)

						//-- Cancela viagem de coleta, qdo a viagem estiver em aberto ou fechada.
						RecLock("DTQ",.F.)
						DTQ->DTQ_STATUS := StrZero(9,Len(DTQ->DTQ_STATUS))
						MsUnLock()

						//Cancela planejamento de demandas
						If lITmsDmd .And. FindFunction("TMSCanPln") .And. TableInDic("DL9")
							TMSCanPln(DTQ->DTQ_VIAGEM, "8")
						EndIf

						//-- Exclui todas operacoes da viagem
						DTW->(DbSetOrder(3)) //DTW_FILIAL+DTW_FILORI+DTW_VIAGEM+DTW_STATUS+DTW_SEQUEN
						While DTW->(MsSeek(xFilial("DTW")+DTQ->(DTQ_FILORI+DTQ_VIAGEM)))
							RecLock("DTW",.F.)
							DTW->(DbDelete())
							MsUnLock()
						EndDo

						//-- Deixa veiculo/motorista em aberto caso o controle de veiculo esteja ativo
						If lContVei
							TMSA340Sta(DTQ->DTQ_FILORI, DTQ->DTQ_VIAGEM, '3', '1')
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		RestArea(aAreaDTQ)
	EndIf
	//-- Encerra Movimento de Viagem
	DUD->(dbSetOrder(1)) //DUD_FILIAL+DUD_FILDOC+DUD_DOC+DUD_SERIE+DUD_FILORI+DUD_VIAGEM
	If DUD->(MsSeek(xFilial("DUD")+cFilAnt+cDocto+cSerie+cFilAnt))
		RecLock("DUD",.F.)
		DUD->DUD_FILVGE := cFilCol
		DUD->DUD_NUMVGE := cVgeCol
		DUD->DUD_STATUS := StrZero(4,Len(DUD->DUD_STATUS)) //-- Encerrado
		MsUnlock()
	EndIf
	//-- Inclusao da Ocorrencia de Entrega
	DT6->(DbSetOrder(1))
	DT6->(MsSeek(xFilial("DT6")+cFilAnt+cDocto+cSerie))
	aItens := {}
	AAdd(aItens,{	{"DUA_SEQOCO", StrZero(1,Len(DUA->DUA_SEQOCO))	, Nil},;
					{"DUA_DATOCO", dDtEntr							, Nil},;
					{"DUA_HOROCO", cHrEntr							, Nil},;
					{"DUA_CODOCO", GetMV("MV_OCORENT",.F.,"")		, Nil},;
					{"DUA_RECEBE", cRecebe							, Nil},;
					{"DUA_SERTMS", StrZero(3,Len(DUA->DUA_SERTMS))	, Nil},;
					{"DUA_FILDOC", DT6->DT6_FILDOC					, Nil},;
					{"DUA_DOC"   , DT6->DT6_DOC						, Nil},;
					{"DUA_SERIE" , DT6->DT6_SERIE					, Nil},;
					{"DUA_QTDOCO", DT6->DT6_QTDVOL					, Nil},;
					{"DUA_PESOCO", DT6->DT6_PESO					, Nil}})
	MsExecAuto({|x,y,z|Tmsa360(x,y,z)},{},aItens,{},3)
	//-- Atualiza o Status da Entrega no Agendamento
	DT5->(DbSetOrder(1)) //DT5_FILIAL+DT5_FILORI_DT5_NUMSOL
	DF1->(DbSetOrder(3)) //DF1_FILIAL+DF1_FILDOC+DF1_DOC+DF1_SERIE
	DTC->(DbSetOrder(3)) //DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE+DTC_SERVIC+DTC_CODPRO
	cQuery := "SELECT DTC_FILCFS, DTC_FILORI, DTC_NUMSOL "
	cQuery += "  FROM "+RetSQLName("DTC")
	cQuery += " WHERE DTC_FILIAL  = '"+xFilial('DTC') +"'"
	cQuery += "   AND DTC_FILDOC  = '"+DT6->DT6_FILDOC+"'"
	cQuery += "   AND DTC_DOC     = '"+DT6->DT6_DOC   +"'"
	cQuery += "   AND DTC_SERIE   = '"+DT6->DT6_SERIE +"'"
	cQuery += "   AND D_E_L_E_T_  = ' '"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDTC)
	While (cAliasDTC)->(!Eof())
		If !Empty((cAliasDTC)->DTC_FILCFS)
			cFilDT5  := IIf(Empty(cFilDT5), cFilDT5, (cAliasDTC)->DTC_FILCFS)
			cSeekDT5 := cFilDT5+(cAliasDTC)->DTC_FILCFS+(cAliasDTC)->DTC_NUMSOL
		Else
			cSeekDT5 := cFilDT5+(cAliasDTC)->DTC_FILORI+(cAliasDTC)->DTC_NUMSOL
		EndIf
		If DT5->(MsSeek(cSeekDT5))
			If !Empty(cFilDF1)
				cFilDF1 := (cAliasDTC)->DTC_FILCFS
			EndIf
			If DF1->(MsSeek(cFilDF1+DT5->DT5_FILDOC+DT5->DT5_DOC+DT5->DT5_SERIE))
				RecLock("DF1",.F.)
				DF1->DF1_STAENT := StrZero(5,Len(DF1->DF1_STAENT)) //-- Encerrado
				MsUnlock()
				// aAgend[n,1] = Numero Agendamento
				// aAgend[n,2] = Encerrado
				//-- Armazena o numero do agendamento para verificacao do encerramento (DF0_STATUS).
				If Ascan( aAgend, { |x| x[1] == DF1->DF1_NUMAGE } ) == 0
					AAdd( aAgend, { DF1->DF1_NUMAGE, .T. } )
				EndIf
			EndIf
		EndIf
		(cAliasDTC)->(DbSkip())
	EndDo
	(cAliasDTC)->(dbCloseArea())
EndIf

//-- Caso a data/hora de coleta seja informada na nota fiscal,
//   Gera documento com o status 'Indicado para Entrega' para viagem de coleta 'Em Transito'
//   ou Gera Viagem de entrega automaticamente para viagem de coleta 'Em Aberto', 'Chegada em Filial' ou 'Encerrada'.
If !Empty(dDtCol) .And. !Empty(cHrCol) //-- Data e Hora de Coleta

	If lContinua
		//-- Se encontrou viagem de coleta.
		If !Empty(cFilCol) .And. !Empty(cVgeCol)
			DTQ->(DbSetOrder(2)) //DTQ_FILIAL+DTQ_VIAGEM
			If DTQ->(MsSeek(xFilial("DTQ")+cFilCol+cVgeCol))
				//-- Quando nao informar a data/hora de Entrega.
				If Empty(dDtEntr) .And. Empty(cHrEntr)
					//-- Gera documento com o status 'Indicado para Entrega' para viagem de coleta 'Em Transito'
					If DTQ->DTQ_STATUS == StrZero(2,Len(DTQ->DTQ_STATUS)) .And. lTmsVgce //-- Em Transito e o parametro status do documento com agentedamento
						DT6->(DbSetOrder(1))
						DT6->(MsSeek(xFilial("DT6")+cFilAnt+cDocto+cSerie))
						RecLock("DT6",.F.)
						DT6->DT6_STATUS := StrZero(6,Len(DT6->DT6_STATUS)) //-- Indicado para Entrega
						MsUnlock()
						//-- Grava o numero da viagem de coleta e cancela o movimento de viagem para efeito de consulta
						DUD->(DbSetOrder(1)) //DUD_FILIAL+DUD_FILDOC+DUD_DOC+DUD_SERIE+DUD_FILORI+DUD_VIAGEM
						If DUD->(MsSeek(xFilial("DUD")+cFilAnt+cDocto+cSerie+cFilAnt))
							RecLock("DUD",.F.)
							DUD->DUD_FILVGE := cFilOri
							DUD->DUD_NUMVGE := cVgeCol
							DUD->DUD_STATUS := StrZero(9,Len(DUD->DUD_STATUS)) //-- Cancelado
							MsUnlock()
						EndIf
						//-- Atualiza o Status da Entrega no Agendamento
						DT5->(DbSetOrder(1)) //DT5_FILIAL+DT5_FILORI_DT5_NUMSOL
						DF1->(DbSetOrder(3)) //DF1_FILIAL+DF1_FILDOC+DF1_DOC+DF1_SERIE
						DTC->(DbSetOrder(3)) //DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE+DTC_SERVIC+DTC_CODPRO
						cQuery := "SELECT DTC_FILCFS, DTC_FILORI, DTC_NUMSOL "
						cQuery += "  FROM "+RetSQLName("DTC")
						cQuery += " WHERE DTC_FILIAL  = '"+xFilial('DTC') +"'"
						cQuery += "   AND DTC_FILDOC  = '"+DT6->DT6_FILDOC+"'"
						cQuery += "   AND DTC_DOC     = '"+DT6->DT6_DOC   +"'"
						cQuery += "   AND DTC_SERIE   = '"+DT6->DT6_SERIE +"'"
						cQuery += "   AND D_E_L_E_T_  = ' '"
						cQuery := ChangeQuery(cQuery)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDTC)
						While (cAliasDTC)->(!Eof())
							If !Empty((cAliasDTC)->DTC_FILCFS)
								cFilDT5  := IIf(Empty(cFilDT5), cFilDT5, (cAliasDTC)->DTC_FILCFS)
								cSeekDT5 := cFilDT5+(cAliasDTC)->DTC_FILCFS+(cAliasDTC)->DTC_NUMSOL
							Else
								cSeekDT5 := cFilDT5+(cAliasDTC)->DTC_FILORI+(cAliasDTC)->DTC_NUMSOL
							EndIf
							If DT5->(MsSeek(cSeekDT5))
								If !Empty(cFilDF1)
									cFilDF1 := (cAliasDTC)->DTC_FILCFS
								EndIf
								If DF1->(MsSeek(cFilDF1+DT5->DT5_FILDOC+DT5->DT5_DOC+DT5->DT5_SERIE))
									RecLock("DF1",.F.)
									DF1->DF1_STAENT := StrZero(4,Len(DF1->DF1_STAENT)) //-- Em Processo
									MsUnlock()
								EndIf
							EndIf
							(cAliasDTC)->(DbSkip())
						EndDo
						(cAliasDTC)->(dbCloseArea())

					//-- Gera Viagem de entrega automaticamente para viagem de coleta 'Em Aberto', 'Chegada em Filial' ou 'Encerrada'.
					ElseIf	DTQ->DTQ_STATUS == StrZero(1,Len(DTQ->DTQ_STATUS)) .Or. ;	//-- Em Aberto
							DTQ->DTQ_STATUS == StrZero(5,Len(DTQ->DTQ_STATUS)) .Or. ;	//-- Fechada
							DTQ->DTQ_STATUS == StrZero(3,Len(DTQ->DTQ_STATUS)) .Or. ;	//-- Encerrada
							DTQ->DTQ_STATUS == StrZero(4,Len(DTQ->DTQ_STATUS)) .Or. ;	//-- Chegada em Filial
							DTQ->DTQ_STATUS == StrZero(9,Len(DTQ->DTQ_STATUS))			//-- Cancelada

						//-- Verifica se ja foi gerado viagem de entrega relacionada a viagem de coleta
						cQuery := "SELECT DUD_FILORI, DUD_VIAGEM"
						cQuery += "  FROM "+RetSQLName("DUD")
						cQuery += " WHERE DUD_FILIAL  = '"+xFilial('DUD')+"'"
						cQuery += "   AND DUD_FILORI  = '"+cFilAnt+"'"
						cQuery += "   AND DUD_VIAGEM <> ' '"
						cQuery += "   AND DUD_FILVGE  = '"+cFilCol+"'"
						cQuery += "   AND DUD_NUMVGE  = '"+cVgeCol+"'"
						cQuery += "   AND D_E_L_E_T_  = ' '"
						cQuery := ChangeQuery(cQuery)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDUD)
						If (cAliasDUD)->(!Eof())
							cFilEnt := (cAliasDUD)->DUD_FILORI
							cVgeEnt := (cAliasDUD)->DUD_VIAGEM
						EndIf
						(cAliasDUD)->(dbCloseArea())

						//////////////////////////////////////////////////////////////////////////
						// Caso o Parametro indique .F., a rotina devera consistir a existencia //
						// de um agendamento para o respectivo DOCTO/Sol.Coleta e somente gerar //
						// a Viagem de Entrega para os casos onde o retorno abaixo seja .T.     //
						//////////////////////////////////////////////////////////////////////////
						lChkAgend := lEntSAgen
						If !lEntSAgen
							DT5->(DbSetOrder(1)) //DT5_FILIAL+DT5_FILORI_DT5_NUMSOL
							DF1->(DbSetOrder(3)) //DF1_FILIAL+DF1_FILDOC+DF1_DOC+DF1_SERIE
							DTC->(DbSetOrder(3)) //DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE+DTC_SERVIC+DTC_CODPRO
							cQuery := "SELECT DTC_FILCFS, DTC_FILORI, DTC_NUMSOL "
							cQuery += "  FROM "+RetSQLName("DTC")
							cQuery += " WHERE DTC_FILIAL  = '"+xFilial('DTC') +"'"
							cQuery += "   AND DTC_FILDOC  = '"+DT6->DT6_FILDOC+"'"
							cQuery += "   AND DTC_DOC     = '"+DT6->DT6_DOC   +"'"
							cQuery += "   AND DTC_SERIE   = '"+DT6->DT6_SERIE +"'"
							cQuery += "   AND D_E_L_E_T_  = ' '"
							cQuery := ChangeQuery(cQuery)
							dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDTC)
							While (cAliasDTC)->(!Eof())
								If !Empty((cAliasDTC)->DTC_FILCFS)
									cFilDT5  := IIf(Empty(cFilDT5), cFilDT5, (cAliasDTC)->DTC_FILCFS)
									cSeekDT5 := cFilDT5+(cAliasDTC)->DTC_FILCFS+(cAliasDTC)->DTC_NUMSOL
								Else
									cSeekDT5 := cFilDT5+(cAliasDTC)->DTC_FILORI+(cAliasDTC)->DTC_NUMSOL
								EndIf
								If DT5->(MsSeek(cSeekDT5))
									If !Empty(cFilDF1)
										cFilDF1 := (cAliasDTC)->DTC_FILCFS
									EndIf
									If DF1->(MsSeek(cFilDF1+DT5->DT5_FILDOC+DT5->DT5_DOC+DT5->DT5_SERIE))
										lChkAgend := .T.
									EndIf
								EndIf
								If lChkAgend
									Exit
								EndIf
								(cAliasDTC)->(DbSkip())
							EndDo
							(cAliasDTC)->(dbCloseArea())
						EndIf

						DbSelectArea("DUD")
						// aRota[01] = Mark
						// aRota[02] = Codigo da Rota
						// aRota[09] = Permite ou nao desmarcar a rota da tela
						DA8->(DbSetOrder(1))
						If DA8->(MsSeek(xFilial("DA8")+PadR(GetMv('MV_ROTGENT'),Len(DA8->DA8_COD))))
							AAdd( aRota, { .T.,DA8->DA8_COD,,,,,,,.F. } )

							If DTQ->DTQ_STATUS == StrZero(9,Len(DTQ->DTQ_STATUS)) //-- Cancelada
								aCompViag := TmsA240Mnt(,,2,cFilCol,cVgeCol,aCompViag,DA8->DA8_COD,cSerTms,cTipTra,,,,.F.)
							ElseIf DTQ->DTQ_STATUS == StrZero(4,Len(DTQ->DTQ_STATUS)) //-- Chegada em Filial
								aCompViag := TmsA240Mnt(,,2,cFilCol,cVgeCol,aCompViag,DA8->DA8_COD,cSerTms,cTipTra,,,,.F.)
								//-- Encerra viagem e cancela as operacoes em aberto.
								TMSA340Grv(.T.)
							ElseIf	DTQ->DTQ_STATUS == StrZero(1,Len(DTQ->DTQ_STATUS)) .AND. ;
									DTQ->DTQ_TIPVIA == StrZero(3, Len(DTQ->DTQ_TIPVIA))          //-- Planejada

								If !lTmsExp
									aCompViag := TmsA240Mnt(,,2,cFilCol,cVgeCol,aCompViag,DA8->DA8_COD,cSerTms,cTipTra,,,,.F.)
								EndIf

								DA8->(DbSetOrder(1))
								DA8->(MsSeek(xFilial("DA8")+PadR(GetMv('MV_ROTGENT'),Len(DA8->DA8_COD))))

								If lOcorCan
									//-- Cabecalho da Ocorrencia
									AAdd(aCab,{"DUA_FILORI",DTQ->DTQ_FILORI,Nil})
									AAdd(aCab,{"DUA_VIAGEM",DTQ->DTQ_VIAGEM,Nil})
									//-- Itens da Ocorrencia
									aItens:= {}
									AAdd(aItens, {	{"DUA_SEQOCO", StrZero(1,Len(DUA->DUA_SEQOCO))	, Nil},;
													{"DUA_DATOCO", dDtCol							, Nil},;
													{"DUA_HOROCO", cHrCol							, Nil},;
													{"DUA_CODOCO", cOcorCan							, Nil},;
													{"DUA_RECEBE", cRecebe							, Nil},;
													{"DUA_SERTMS", StrZero(1,Len(DUA->DUA_SERTMS))	, Nil},;
													{"DUA_FILDOC", DUD->DUD_FILDOC					, Nil},;
													{"DUA_DOC"   , DUD->DUD_DOC						, Nil},;
													{"DUA_SERIE" , DUD->DUD_SERIE					, Nil},;
													{"DUA_QTDOCO", nQtdVol							, Nil},;
													{"DUA_PESOCO", nPeso							, Nil}})

									//-- Inclusao da Ocorrencia
									MsExecAuto({|x,y,z|Tmsa360(x,y,z)},aCab,aItens,{},3)

									DUD->(DbSetOrder(2)) //DUD_FILIAL+DUD_FILORI+DUD_VIAGEM+DUD_SEQUEN+DUD_FILDOC+DUD_DOC+DUD_SERIE
									cQuery := "SELECT 1 "
									cQuery += "  FROM "+RetSQLName("DUD")
									cQuery += " WHERE DUD_FILIAL = '"+xFilial('DUD') +"'"
									cQuery += "   AND DUD_FILORI = '"+DTQ->DTQ_FILORI+"'"
									cQuery += "   AND DUD_VIAGEM = '"+DTQ->DTQ_VIAGEM+"'"
									cQuery += "   AND D_E_L_E_T_ = ' '"
									cQuery := ChangeQuery(cQuery)
									dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDUD)
									While (cAliasDUD)->(!Eof())
										If DUD->DUD_STATUS <> StrZero(9,Len(DUD->DUD_STATUS))
											lCancViag := .F.
											Exit
										EndIf
										(cAliasDUD)->(dbSkip())
									EndDo
									(cAliasDUD)->(dbCloseArea())
									If lCancViag
										//-- Cancela viagem de coleta, qdo a viagem estiver em aberto ou fechada.
										RecLock("DTQ",.F.)
										DTQ->DTQ_STATUS := StrZero(9,Len(DTQ->DTQ_STATUS))
										MsUnLock()
									EndIf

									//-- Exclui todas operacoes da viagem
									DTW->(DbSetOrder(3)) //DTW_FILIAL+DTW_FILORI+DTW_VIAGEM+DTW_STATUS+DTW_SEQUEN
									While DTW->(MsSeek(xFilial("DTW")+DTQ->(DTQ_FILORI+DTQ_VIAGEM)))
										RecLock("DTW",.F.)
										DTW->(DbDelete())
										MsUnLock()
									EndDo
									//-- Deixa veiculo/motorista em aberto caso o controle de veiculo esteja ativo
									If lContVei
										TMSA340Sta(DTQ->DTQ_FILORI, DTQ->DTQ_VIAGEM, '3', '1')
									EndIf
								EndIf
							EndIf

							If !lTmsExp .And. Substr(FunName(),1,7) == "TMSA200"
								//-- Recalculo do Frete
								If TmsExp() .And. !Empty(DTP->DTP_VIAGEM)
									lTmsExp:= .T.
								EndIf
							EndIf

							If !lTmsExp .And. lChkAgend
								//-- Se nao existir complemento de viagem o carregamento sera manual

								If lOcorCan .Or. Empty(aCompViag)
									nCarreg := 1 //-- Carregamento Manual
								EndIf

								DUD->(DbSetOrder(1)) //DUD_FILIAL+DUD_FILDOC+DUD_DOC+DUD_SERIE+DUD_FILORI+DUD_VIAGEM
								If DUD->(MsSeek(xFilial("DUD")+cFilAnt+cDocto+cSerie+cFilAnt))
									//-- grava o numero da viagem de coleta no movimento da viagem de entrega
									RecLock("DUD",.F.)
									DUD->DUD_FILVGE := cFilCol
									DUD->DUD_NUMVGE := cVgeCol
									MsUnlock()

									//-- Posiciona no documento gerado
									DT6->(DbSetOrder(1))
									DT6->(MsSeek(xFilial("DT6")+cFilAnt+cDocto+cSerie))

									//-- Posiciona em Zonas por Rota para obter zona e setor
									DA9->(DbSetOrder(1))
									DA9->(MsSeek(xFilial("DA9")+DA8->DA8_COD))

									Afill(aDocAux,Nil)

									If lLocaliz //-- Enderecamento
										lExistDUH := .F.
										DUH->(DbSetOrder(1)) //DUH_FILIAL+DUH_FILORI+DUH_NUMNFC+DUH_SERNFC+DUH_CLIREM+DUH_LOJREM+DUH_CODPRO+DUH_LOCAL+DUH_LOCALI
										DTC->(DbSetOrder(3)) //DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE+DTC_SERVIC+DTC_CODPRO
										cQuery := "SELECT DUH_LOCAL, DUH_LOCALI, DUH_QTDVOL "
										cQuery += "       FROM "+RetSQLName("DTC")+" DTC "
										cQuery += " INNER JOIN "+RetSQLName("DUH")+" DUH "
										cQuery += "   ON (DUH_FILIAL = '"+xFilial('DUH') +"' "
										cQuery += "   AND DUH_FILORI = DTC_FILORI "
										cQuery += "   AND DUH_NUMNFC = DTC_NUMNFC "
										cQuery += "   AND DUH_SERNFC = DTC_SERNFC "
										cQuery += "   AND DUH_CLIREM = DTC_CLIREM "
										cQuery += "   AND DUH_LOJREM = DTC_LOJREM "
										cQuery += "   AND DUH_CODPRO = DTC_CODPRO "
										cQuery += "   AND DUH.D_E_L_E_T_ = ' ') "
										cQuery += " WHERE DTC_FILIAL = '"+xFilial('DTC') +"' "
										cQuery += "   AND DTC_FILDOC = '"+DT6->DT6_FILDOC+"' "
										cQuery += "   AND DTC_DOC    = '"+DT6->DT6_DOC   +"' "
										cQuery += "   AND DTC_SERIE  = '"+DT6->DT6_SERIE +"' "
										cQuery += "   AND DTC.D_E_L_E_T_ = ' ' "
										cQuery := ChangeQuery(cQuery)
										dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDTC)
										While (cAliasDTC)->(!Eof())
											lExistDUH := .T.
											aDocAux[CTSTATUS]	:= DUD->DUD_STATUS
											aDocAux[CTSTROTA]	:= ''
											aDocAux[CTMARCA ]	:= .T.
											aDocAux[CTSEQUEN]	:= Replicate('x',Len(DUD->DUD_SEQUEN))
											aDocAux[CTARMAZE]	:= (cAliasDTC)->DUH_LOCAL
											aDocAux[CTLOCALI]	:= (cAliasDTC)->DUH_LOCALI
											aDocAux[CTFILDOC]	:= DUD->DUD_FILDOC
											aDocAux[CTDOCTO ]	:= DUD->DUD_DOC
											aDocAux[CTSERIE ]	:= DUD->DUD_SERIE
											aDocAux[CTQTDVOL]	:= (cAliasDTC)->DUH_QTDVOL
											aDocAux[CTPLIQUI]	:= DT6->DT6_PESO
											aDocAux[CTVIAGEM]	:= .T.
											aDocAux[CTDOCROT]	:= DA8->DA8_COD+DA9->DA9_PERCUR+DA9->DA9_ROTA
											AAdd(aDocto,AClone(aDocAux))
											(cAliasDTC)->(DbSkip())
										EndDo
										(cAliasDTC)->(dbCloseArea())
									EndIf
									If !lLocaliz .Or. !lExistDUH
										aDocAux[CTSTATUS]	:= DUD->DUD_STATUS
										aDocAux[CTSTROTA]	:= ''
										aDocAux[CTMARCA ]	:= .T.
										aDocAux[CTSEQUEN]	:= Replicate('x',Len(DUD->DUD_SEQUEN))
										aDocAux[CTARMAZE]	:= ''
										aDocAux[CTLOCALI]	:= ''
										aDocAux[CTFILDOC]	:= DUD->DUD_FILDOC
										aDocAux[CTDOCTO ]	:= DUD->DUD_DOC
										aDocAux[CTSERIE ]	:= DUD->DUD_SERIE
										aDocAux[CTQTDVOL]	:= DT6->DT6_QTDVOL
										aDocAux[CTPLIQUI]	:= DT6->DT6_PESO
										aDocAux[CTVIAGEM]	:= .T.
										aDocAux[CTDOCROT]	:= DA8->DA8_COD+DA9->DA9_PERCUR+DA9->DA9_ROTA
										AAdd(aDocto,AClone(aDocAux))
									EndIf

									//-- Gera Viagem de Entrega
									DTQ->(DbSetOrder(2)) //DTQ_FILIAL+DTQ_VIAGEM
									If !Empty(cFilEnt) .And. !Empty(cVgeEnt) .And. DTQ->(MsSeek(xFilial('DTQ')+cFilEnt+cVgeEnt))
										RegToMemory('DTQ',.F.)
										cSerTms := M->DTQ_SERTMS
										cTipTra := M->DTQ_TIPTRA
										TmsA141Grv(4)
									Else
										RegToMemory('DTQ',.T.)
										cSerTms       := DUD->DUD_SERTMS
										cTipTra       := DUD->DUD_TIPTRA
										M->DTQ_SERTMS := DUD->DUD_SERTMS
										M->DTQ_TIPTRA := DUD->DUD_TIPTRA
										If lOcorCan
											M->DTQ_TIPVIA:= StrZero(3,Len(DTQ->DTQ_TIPVIA)) //Viagem de Entrega Planejada
										EndIf
										TmsA141Grv(3)
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				Else
					//-- Caso a data de entrega esteja preenchida e a viagem estiver em 'Chegada em Filial'.
					If DTQ->DTQ_STATUS == StrZero(4,Len(DTQ->DTQ_STATUS))
						//-- Encerra viagem e cancela as operacoes em aberto.
						TMSA340Grv(.T.)
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

DF1->(DbSetOrder(1))
DF0->(DbSetOrder(1))
If !Empty(cFilDF0) .And. !Empty(cFilDF1)
	cFilDF0 := DTC->DTC_FILCFS
	cFilDF1 := DTC->DTC_FILCFS
EndIf
For nCnt := 1 To Len(aAgend)
	If aAgend[nCnt,2] //-- Encerrado
		cQuery := "SELECT DF1_STAENT "
		cQuery += "  FROM "+RetSQLName("DF1")
		cQuery += " WHERE DF1_FILIAL = '"+cFilDF1       +"'"
		cQuery += "   AND DF1_NUMAGE = '"+aAgend[nCnt,1]+"'"
		cQuery += "   AND D_E_L_E_T_ = ' '"
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDF1)
		While (cAliasDF1)->(!Eof())
			If	(cAliasDF1)->DF1_STAENT <> StrZero(5,Len(DF1->DF1_STAENT)) .And. ;//-- 5 = Encerrado
				(cAliasDF1)->DF1_STAENT <> StrZero(9,Len(DF1->DF1_STAENT))			//-- 9 = Cancelado
				lEncerra := .F.
				Exit
			EndIf
			(cAliasDF1)->(DbSkip())
		EndDo
		(cAliasDF1)->(dbCloseArea())
		If lEncerra
			If DF0->(MsSeek(cFilDF0+aAgend[nCnt,1]))
				RecLock("DF0",.F.)
				DF0->DF0_STATUS := StrZero( 4, Len( DF0->DF0_STATUS ) )	// 4 = Encerrado
				MsUnlock()
			EndIf
		EndIf
	EndIf
Next nCnt

ResetArr(@aAgend    )
ResetArr(@aCab      )
ResetArr(@aItens    )

RestArea( aAreaDTC )
Return( .T. )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥A200EstCFec≥ Autor ≥ Eduardo de Souza     ≥ Data ≥ 03/08/04 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Carga Fechada - Estorno de Ocorrencias / Status da Viagem  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ A200EstCFec()                                              ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpC1 - Filial Documento                                   ≥±±
±±≥          ≥ ExpC2 - Documento                                          ≥±±
±±≥          ≥ ExpC3 - Serie Documento                                    ≥±±
±±≥          ≥ ExpC4 - Filial Viagem Coleta                               ≥±±
±±≥          ≥ ExpC5 - Viagem de Coleta                                   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ TMSAF05                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function A200EstCFec(cFilDoc,cDocto,cSerie)
Local aCabDUA    := {}
Local aItens     := {}
Local aAgend     := {}
Local cQuery     := ""
Local cAliasDUD  := GetNextAlias()
Local cAliasDTC  := GetNextAlias()
Local aAreaDTC   := DTC->(GetArea())
Local aAreaDT6   := DT6->(GetArea())
Local cFilDT5    := xFilial('DT5')
Local cFilDF1    := xFilial("DF1")
Local cFilDF0    := xFilial("DF0")
Local lPlanejada := .F.
Local nCnt       := 0
Local cOcorCan   := PadR(GetMV("MV_OCORCAN",   ,""),Len(DT2->DT2_CODOCO))  //-- Ocorrencia de Cancelamento p/ Viagem de Coleta Planejada em aberto
Local cCodOco    := PadR(GetMV("MV_OCORENT",.F.,""),Len(DT2->DT2_CODOCO))
Local cSeekDT5   := ""
Local cFilCol    := ""
Local cVgeCol    := ""

//-- Estorna a ocorrencia de Cancelamento automatico da viagem de coleta planejada.
If	!Empty(cOcorCan) .And. !Empty(DTC->DTC_NUMSOL) .And. ;
	!Empty(DTC->DTC_DATCOL) .And. !Empty(DTC->DTC_HORCOL)

	DT5->(DbSetOrder(1)) //DT5_FILIAL+DT5_FILORI_DT5_NUMSOL
	DF1->(DbSetOrder(3)) //DF1_FILIAL+DF1_FILDOC+DF1_DOC+DF1_SERIE
	DTQ->(dbSetOrder(2)) //DTQ_FILIAL+DTQ_VIAGEM
	If !Empty(cFilDF1)
		cFilDF1 := DTC->DTC_FILCFS
	EndIf
	DT5->(DbSetOrder(1))
	If !Empty(DTC->DTC_FILCFS)
		cFilDT5  := IIf(Empty(cFilDT5), cFilDT5, DTC->DTC_FILCFS)
		cSeekDT5 := cFilDT5+DTC->DTC_FILCFS+DTC->DTC_NUMSOL
	Else
		cSeekDT5 := cFilDT5+DTC->DTC_FILORI+DTC->DTC_NUMSOL
	EndIf
	If DT5->(MsSeek(cSeekDT5))
		DUD->(DbSetOrder(1)) //DUD_FILIAL+DUD_FILDOC+DUD_DOC+DUD_SERIE+DUD_FILORI+DUD_VIAGEM
		cQuery := "SELECT DUD_FILORI, DUD_VIAGEM, DUD_STATUS "
		cQuery += "  FROM "+RetSQLName("DUD")
		cQuery += " WHERE DUD_FILIAL = '"+xFilial('DUD') +"'"
		cQuery += "   AND DUD_FILDOC = '"+DT5->DT5_FILDOC+"'"
		cQuery += "   AND DUD_DOC    = '"+DT5->DT5_DOC   +"'"
		cQuery += "   AND DUD_SERIE  = '"+DT5->DT5_SERIE +"'"
		cQuery += "   AND D_E_L_E_T_ = ' '"
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDUD)
		While (cAliasDUD)->(!Eof())
			If	(cAliasDUD)->DUD_STATUS == StrZero(9,Len(DUD->DUD_STATUS)) //-- Cancelado
				If	DTQ->(MsSeek(xFilial("DTQ")+(cAliasDUD)->DUD_FILORI+(cAliasDUD)->DUD_VIAGEM))
					If	DTQ->DTQ_TIPVIA == StrZero(3, Len(DTQ->DTQ_TIPVIA)) .And.;	//-- Planejada
						DTQ->DTQ_STATUS == StrZero(9, Len(DTQ->DTQ_STATUS))		//-- Cancelado
						cFilCol := (cAliasDUD)->DUD_FILORI
						cVgeCol := (cAliasDUD)->DUD_VIAGEM
					EndIf
				EndIf
				Exit
			EndIf
			(cAliasDUD)->(DbSkip())
		EndDo
	EndIf

	//-- Estorna ocorrencia de cancelamento automatico
	If !Empty(cFilCol) .And. !Empty(cVgeCol)
		DUA->(dbSetOrder(3))
		If DUA->(MsSeek(xFilial("DUA")+cOcorCan+DT5->DT5_FILDOC+DT5->DT5_DOC+DT5->DT5_SERIE))
			//-- Cabecalho da Ocorrencia
			AAdd(aCabDUA,	{"DUA_FILOCO", DUA->DUA_FILOCO , Nil})
			AAdd(aCabDUA,	{"DUA_NUMOCO", DUA->DUA_NUMOCO , Nil})
			AAdd(aCabDUA,	{"DUA_FILORI", DUA->DUA_FILORI , Nil})
			AAdd(aCabDUA,	{"DUA_VIAGEM", DUA->DUA_VIAGEM , Nil})
			//-- Itens da Ocorrencia
			AAdd(aItens, {	{"DUA_SEQOCO", DUA->DUA_SEQOCO , Nil},;
							{"DUA_ESTOCO", StrZero( 1, TamSX3("DUA_ESTOCO")[1]), Nil},;
							{"DUA_DATOCO", DUA->DUA_DATOCO , Nil},;
							{"DUA_HOROCO", DUA->DUA_HOROCO , Nil},;
							{"DUA_CODOCO", DUA->DUA_CODOCO , Nil},;
							{"DUA_RECEBE", DUA->DUA_RECEBE , Nil},;
							{"DUA_SERTMS", DUA->DUA_SERTMS , Nil},;
							{"DUA_FILDOC", DUA->DUA_FILDOC , Nil},;
							{"DUA_DOC"   , DUA->DUA_DOC    , Nil},;
							{"DUA_SERIE" , DUA->DUA_SERIE  , Nil},;
							{"DUA_QTDOCO", DUA->DUA_QTDOCO , Nil},;
							{"DUA_PESOCO", DUA->DUA_PESOCO , Nil}})
			//-- Estorno da Ocorrencia
			MsExecAuto({|w,x,y,z|Tmsa360(w,x,y,z)},aCabDUA,aItens,{},6)

			//-- Atualiza o Status da coleta no Agendamento.
			DF1->(dbSetOrder(3)) //DF1_FILIAL+DF1_FILDOC+DF1_DOC+DF1_SERIE
			If DF1->(MsSeek(xFilial("DF1")+DT5->DT5_FILDOC+DT5->DT5_DOC+DT5->DT5_SERIE))
				RecLock("DF1",.F.)
				DF1->DF1_STACOL := StrZero(3,Len(DF1->DF1_STAENT)) //-- Planejado
				MsUnlock()
			EndIf
		EndIf
		cSeekDT5:= ""
	EndIf
EndIf

//-- Carga Fechada - Estorna ocorrencia de entrega automatica
If !Empty(DTC->DTC_DTENTR) .And. !Empty(DTC->DTC_HORENT)
	DUA->(dbSetOrder(3)) //DUA_FILIAL+DUA_CODOCO+DUA_FILDOC+DUA_DOC+DUA_SERIE
	If DUA->(MsSeek(xFilial("DUA")+cCodOco+DTC->DTC_FILDOC+DTC->DTC_DOC+DTC->DTC_SERIE))
		//-- Cabecalho da Ocorrencia
		AAdd(aCabDUA,	{"DUA_FILOCO", DUA->DUA_FILOCO , Nil})
		AAdd(aCabDUA,	{"DUA_NUMOCO", DUA->DUA_NUMOCO , Nil})
		AAdd(aCabDUA,	{"DUA_FILORI", DUA->DUA_FILORI , Nil})
		AAdd(aCabDUA,	{"DUA_VIAGEM", DUA->DUA_VIAGEM , Nil})
		//-- Itens da Ocorrencia
		AAdd(aItens, {	{"DUA_SEQOCO", DUA->DUA_SEQOCO , Nil},;
						{"DUA_ESTOCO", StrZero( 1, TamSX3("DUA_ESTOCO")[1]), Nil},;
						{"DUA_DATOCO", DUA->DUA_DATOCO , Nil},;
						{"DUA_HOROCO", DUA->DUA_HOROCO , Nil},;
						{"DUA_CODOCO", DUA->DUA_CODOCO , Nil},;
						{"DUA_RECEBE", DUA->DUA_RECEBE , Nil},;
						{"DUA_SERTMS", DUA->DUA_SERTMS , Nil},;
						{"DUA_FILDOC", DUA->DUA_FILDOC , Nil},;
						{"DUA_DOC"   , DUA->DUA_DOC    , Nil},;
						{"DUA_SERIE" , DUA->DUA_SERIE  , Nil},;
						{"DUA_QTDOCO", DUA->DUA_QTDOCO , Nil},;
						{"DUA_PESOCO", DUA->DUA_PESOCO , Nil}})
		//-- Estorno da Ocorrencia
		MsExecAuto({|w,x,y,z|Tmsa360(w,x,y,z)},aCabDUA,aItens,{},6)
	EndIf
EndIf

//-- Atualiza o Status da entrega no Agendamento.
DT5->(DbSetOrder(1)) //DT5_FILIAL+DT5_FILORI_DT5_NUMSOL
DF1->(DbSetOrder(3)) //DF1_FILIAL+DF1_FILDOC+DF1_DOC+DF1_SERIE
DTC->(DbSetOrder(3)) //DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE+DTC_SERVIC+DTC_CODPRO
cQuery := "SELECT DTC_FILCFS, DTC_FILORI, DTC_NUMSOL "
cQuery += "  FROM "+RetSQLName("DTC")
cQuery += " WHERE DTC_FILIAL  = '"+xFilial('DTC')+"'"
cQuery += "   AND DTC_FILDOC  = '"+cFilDoc+"'"
cQuery += "   AND DTC_DOC     = '"+cDocto +"'"
cQuery += "   AND DTC_SERIE   = '"+cSerie +"'"
cQuery += "   AND D_E_L_E_T_  = ' '"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDTC)
While (cAliasDTC)->(!Eof())
	If !Empty((cAliasDTC)->DTC_FILCFS)
		cFilDT5  := IIf(Empty(cFilDT5), cFilDT5, (cAliasDTC)->DTC_FILCFS)
		cSeekDT5 := cFilDT5+(cAliasDTC)->DTC_FILCFS+(cAliasDTC)->DTC_NUMSOL
	Else
		cSeekDT5 := cFilDT5+(cAliasDTC)->DTC_FILORI+(cAliasDTC)->DTC_NUMSOL
	EndIf
	If DT5->(MsSeek(cSeekDT5))
		If DF1->(MsSeek(xFilial("DF1")+DT5->DT5_FILDOC+DT5->DT5_DOC+DT5->DT5_SERIE))
				RecLock("DF1",.F.)
				DF1->DF1_STAENT := StrZero(2,Len(DF1->DF1_STAENT)) //-- Confirmado
				MsUnlock()
			// aAgend[n,1] = Numero Agendamento
			// aAgend[n,2] = Encerrado
			//-- Armazena o numero do agendamento para verificacao do encerramento (DF0_STATUS).
			If Ascan( aAgend, { |x| x[1] == DF1->DF1_NUMAGE } ) == 0
				AAdd( aAgend, { DF1->DF1_NUMAGE, .F. } )
			EndIf
		EndIf
	EndIf
	(cAliasDTC)->(DbSkip())
EndDo
(cAliasDTC)->(dbCloseArea())

DF1->(DbSetOrder(1))
DF0->(DbSetOrder(1))
If !Empty(cFilDF0) .And. !Empty(cFilDF1)
	cFilDF0 := DTC->DTC_FILCFS
	cFilDF1 := DTC->DTC_FILCFS
EndIf
For nCnt := 1 To Len(aAgend)
	If !aAgend[nCnt,2] //-- Encerrado
		If DF0->(MsSeek(cFilDF0+aAgend[nCnt,1]))
			RecLock("DF0",.F.)
			DF0->DF0_STATUS := cStatus := StrZero( 3, Len( DF0->DF0_STATUS ) )
			MsUnlock()
		EndIf
	EndIf
Next nCnt

ResetArr(@aCabDUA    )
ResetArr(@aItens     )
ResetArr(@aAgend     )

RestArea( aAreaDT6 )
RestArea( aAreaDTC )
Return( .T. )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TmsCFecQbr ≥ Autor ≥ Eduardo de Souza     ≥ Data ≥ 13/09/04 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Verifica a Quebra na Carga Fechada                         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TmsCFecQbr()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpA1 - Array contendo as notas fiscais                    ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ TMSAF05                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function TmsCFecQbr(aNfCTRC)

Local nCnt     := 0
Local lRet     := .F.
Local aDtEntr  := {}
Local cStatus  := ""
Local cSeekDT5 := ""
Local cFilDT5  := xFilial('DT5')
Local aStatus  := {}
Local aAreaDTC := DTC->(GetArea())
Local aAreaDTQ := DTQ->(GetArea())
Local lSeekDTC := .F.

cStatus := StrZero(1,Len(DTQ->DTQ_STATUS)) + ";" //-- Em Aberto
cStatus += StrZero(5,Len(DTQ->DTQ_STATUS)) + ";" //-- Fechada
cStatus += StrZero(3,Len(DTQ->DTQ_STATUS)) + ";" //-- Encerrada
cStatus += StrZero(4,Len(DTQ->DTQ_STATUS)) + ";" //-- Chegada em Filial
cStatus += StrZero(9,Len(DTQ->DTQ_STATUS)) //-- Cancelada

If Len(aNfCTRC) > 1
	DTC->(DbSetOrder(2)) //DTC_FILIAL+DTC_NUMNFC+DTC_SERNFC+DTC_CLIREM+DTC_LOJREM+DTC_CODPRO+DTC_FILORI+DTC_LOTNFC
	DTQ->(DbSetOrder(2)) //DTQ_FILIAL+DTQ_VIAGEM
	DT5->(DbSetOrder(1)) //DT5_FILIAL+DT5_FILORI_DT5_NUMSOL
	DUD->(DbSetOrder(1)) //DUD_FILIAL+DUD_FILDOC+DUD_DOC+DUD_SERIE+DUD_FILORI+DUD_VIAGEM
	For nCnt := 1 To Len(aNfCTRC)
		lSeekDTC := .F.

		If DTC->(MsSeek(xFilial("DTC") + aNfCTRC[nCnt,1] + aNfCTRC[nCnt,2] + aNfCTRC[nCnt,3] + aNfCTRC[nCnt,4]))
			// Busca por todas as notas com mesmo n˙mero, sÈrie e cliente remetente mas mantÈm posicionado apenas aquela que est· no lote atual
			While !DTC->(Eof()) .And. ;
				   DTC->DTC_FILIAL == xFilial("DTC")  .And. ;
				   DTC->DTC_NUMNFC == aNfCTRC[nCnt,1] .And. ;
				   DTC->DTC_SERNFC == aNfCTRC[nCnt,2] .And. ;
				   DTC->DTC_CLIREM == aNfCTRC[nCnt,3] .And. ;
				   DTC->DTC_LOJREM == aNfCTRC[nCnt,4]
				If DTC->DTC_LOTNFC == aNfCTRC[nCnt, 56]
					lSeekDTC := .T.
					Exit
				EndIf
				DTC->(dbSkip())
			EndDo
		EndIf

		If lSeekDTC
			If !Empty(DTC->DTC_DTENTR)
				//-- Verifica se existe data de entrega diferente entre as notas fiscais.
				If !( !Empty(aDtEntr) .And. Ascan( aDtEntr, { |x| x == DTC->DTC_DTENTR } ) == 0 )
					AAdd( aDtEntr, DTC->DTC_DTENTR )
				EndIf
			EndIf
			//-- Quebra o documento qdo econtrada notas com informacoes distintas
			//-- (data de entrega preenchida em uma e nao preenchida na outra).
			If !Empty(aDtEntr) .And. nCnt > Len(aDtEntr)
				lRet := .T.
				Exit
			EndIf
			//-- (Uma Viagem de coleta 'Em Viagem' e outra nao).
			If !Empty(DTC->DTC_NUMSOL)
				If !Empty(DTC->DTC_FILCFS)
					cFilDT5  := IIf(Empty(cFilDT5), cFilDT5, DTC->DTC_FILCFS)
					cSeekDT5 := cFilDT5+DTC->DTC_FILCFS+DTC->DTC_NUMSOL
				Else
					cSeekDT5 := cFilDT5+DTC->DTC_FILORI+DTC->DTC_NUMSOL
				EndIf
				If DT5->(MsSeek(cSeekDT5))
					If DUD->(MsSeek(xFilial("DUD")+DT5->DT5_FILDOC+DT5->DT5_DOC+DT5->DT5_SERIE+cFilAnt))
						If DTQ->(MsSeek(xFilial("DTQ")+DUD->DUD_FILORI+DUD->DUD_VIAGEM))
							If DTQ->DTQ_STATUS == StrZero(2,Len(DTQ->DTQ_STATUS)) //-- Em Transito
								If Ascan( aStatus, { |x| x == cStatus } ) == 0
									AAdd( aStatus, DTQ->DTQ_STATUS )
								EndIf
							Else
								If Ascan( aStatus, { |x| x == StrZero(2,Len(DTQ->DTQ_STATUS)) } ) == 0
									AAdd( aStatus, cStatus )
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
				If nCnt > Len(aStatus)
					lRet := .T.
					Exit
				EndIf
			EndIf
		EndIf
	Next nCnt
	RestArea( aAreaDTC )
	RestArea( aAreaDTQ )
EndIf

Return( lRet )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TmsA200Qb1≥ Autor ≥ Alex Egydio           ≥ Data ≥29.10.2004≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Controla a quebra da sequencia de notas fiscais do cliente,≥±±
±±≥          ≥ baseado no vetor aDocto                                    ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpA1 = Vetor contendo peso e nf cliente                   ≥±±
±±≥          ≥ ExpC1 = Considera ou nao as quebras por numero de notas    ≥±±
±±≥          ≥         fiscais por CTRC e peso maximo por CTRC            ≥±±
±±≥          ≥ ExpC2 = Filial despachante                                 ≥±±
±±≥          ≥ ExpC3 = CTRC despachante                                   ≥±±
±±≥          ≥ ExpC4 = Cotacao de frete                                   ≥±±
±±≥          ≥ ExpN1 = Item do vetor aPrds                                ≥±±
±±≥          ≥ ExpN2 = Qtde de notas fiscais do cliente                   ≥±±
±±≥          ≥ ExpN3 = Total do peso real das notas fiscais do cliente    ≥±±
±±≥          ≥ ExpN4 = Qtde maxima de notas fiscais por conhecimento      ≥±±
±±≥          ≥ ExpN5 = Peso maximo por conhecimento                       ≥±±
±±≥          ≥ ExpL1 = .T. = Ultimo item                                  ≥±±
±±≥          ≥ ExpC5 = Codigo do Produto ATUAL                            ≥±±
±±≥          ≥ ExpC6 = Codigo do PROXIMO Produto                          ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function TmsA200Qb1( aPrds, cAgrNfc, cFilDpc, cCtrDpc, cNumCot, n1Cnt, nQtNotas, nPeso, nNfCTRC, nPesCTRC, lUltimo, cCodPro, cNextPro, aDocto, lCTeUnico, lFim1 )

Local lRet			:= .F.
Local nItem			:= n1Cnt + 1
Local nSeek			:= Len(aDocto)
Local nSeekPlus		:= 0

Default cCodPro		:= Space(Len(DTC->DTC_CODPRO))
Default cNextPro	:= Space(Len(DTC->DTC_CODPRO))
Default lCTeUnico	:= .F.
Default lFim1		:= .F.

//-- Se no perfil do cliente o campo agrupa notas igual a 'Nao', despreza as quebras
//-- e agrupa apenas notas iguais. Espera-se que o lote de documentos venha ordenado.
If cAgrNfc == '2' .And. !lCTeUnico
	For nSeekPlus := nItem To Len(aDocto[nSeek,9])
		lRet := aDocto[nSeek,9,n1Cnt,3,1,1] + aDocto[nSeek,9,n1Cnt,3,1,2] <> aDocto[nSeek,9,nSeekPlus,3,1,1] + aDocto[nSeek,9,nSeekPlus,3,1,2]
		If lRet     //-- Significa que n„o È mais a mesma nota
			Return( .T. )
		Else
			Exit
		EndIf
	Next
EndIf

//-- Se a Filial de Alianca (2o. Percurso) estiver preenchida e o CTRC do Despachante estiver preenchido,
//-- a quebra das Notas Fiscais sera' feita somente por Filial de Alianca+CTRC do Despachante
If !Empty(cFilDpc) .And. !Empty(cCtrDpc)
	lRet := lUltimo
Else
	If lCTeUnico
		If lFim1 .And. nItem > Len(aPrds)
			lRet := .T.
		EndIf
	ElseIf	nItem > Len(aPrds)
		lRet := .T.
	Else
		If	Empty(cNumCot)
			If cAgrNfc == '4' //-- Faz a Quebra se o Proximo Produto do Documento for Diferente do Atual
				If cCodPro <> cNextPro
					lRet:= .T.
				EndIf
			EndIf

			If !lRet
				//-- Atingiu o numero de notas por conhecimento
				If	nQtNotas == nNfCTRC
					lRet := .T.
				//-- Atingiu o peso maximo por conhecimento
				Else
					If nPesCTRC > 0
						If	nPeso + aPrds[nItem,6] > nPesCTRC
							lRet := .T.
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

Return( lRet )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TmsA200Imp≥ Autor ≥Wellington A Santos    ≥ Data ≥24.11.2005≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥Chama o programa impressao do cliente de acordo com ctrc    ≥±±
±±≥          ≥posicionado                                                 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ExpL1 = Imprime independente do paramentro                  ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TmsA200Imp( cAlias, nReg, nOpcx, aStruct, lImprime, aDoc )

Local cLotNfc   := DTP->DTP_LOTNFC
Local cTipTra   := Posicione('DTC',1,xFilial('DTC')+cFilAnt+cLotNfc,'DTC_TIPTRA')
Local lExistIXB := Iif(cTipTra != "4",ExistBlock("RTMSR01"),ExistBlock("RTMSR17"))
Local cPerg     := Iif(cTipTra != "4","RTMR01","RTMR16")
Local aArea     := GetArea()
Local lRTMSR31  := ExistBlock("RTMSR31",,.T.)

Default cAlias   := ""
Default nReg     := 0
Default nOpcx    := 0
Default aStruct  := {}
Default lImprime := .T.

// projeto de impressao de documento atraves da rotina de manutencao de documentos TMSA500
Default aDoc 	  := {"","",""}  // numero do documento a ser impresso
		// aDoc[1] - FilDoc
		// aDoc[2] - Doc
		// aDoc[3] - Serie

//-- Verifica se o agendamento est· sendo utilizado por outro usu·rio no painel de agendamentos
If !TMSAVerAge("1",aDoc[1],aDoc[2],aDoc[3],,,,,,,,,"2",.T.,.T.,,,StrZero(ThreadId(),20))
	Return .F.
EndIf
// projeto de impressao de documento atraves da rotina de manutencao de documentos TMSA500
if ! Empty(aDoc[2])
	aDoc[1] := Padr(Alltrim(aDoc[1]),Len(DT6->DT6_FILDOC))
	aDoc[2] := Padr(Alltrim(aDoc[2]),Len(DT6->DT6_DOC))
	aDoc[3] := Padr(Alltrim(aDoc[3]),Len(DT6->DT6_SERIE))
Endif

Pergunte("TMB200",.F.)
If ValType(lImprime) == "L" .And. !lImprime
	lImprime := mv_par01 == 1
ElseIf !ValType(lImprime) == "L"
	lImprime := .T.
EndIf
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Variaveis utilizadas como parametros                                  ≥
//√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥
//≥ mv_par01	//Imprimi lote no final do calculo do ctrc ?              ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
If lExistIXB .And. lImprime

	if Empty(aDoc[2])
		DT6->( dbSetOrder(2) )
		DT6->( MsSeek( xFilial("DT6") + DTP->DTP_FILORI + DTP->DTP_LOTNFC ) )
	Else
		// projeto de impressao de documento atraves da rotina de manutencao de documentos TMSA500
		DT6->( dbSetOrder(1) )  // DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE
		DT6->( MsSeek( xFilial("DT6") + aDoc[1] + aDoc[2] + aDoc[3]) )
	Endif

	//LOTE DE
	SetMVValue(cPerg,"MV_PAR01",cLotNfc)

	//LOTE ATE
	SetMVValue(cPerg,"MV_PAR02",cLotNfc)

	//DOCUMENTO DE
	If Empty(aDoc[2])
		SetMVValue(cPerg,"MV_PAR03", Space(TamSX3("DT6_DOC")[1]) )
	Else
		// projeto de impressao de documento atraves da rotina de manutencao de documentos TMSA500
		SetMVValue(cPerg,"MV_PAR03",aDoc[2])
	Endif

	//DOCUMENTO ATE
	If Empty(aDoc[2])
		SetMVValue(cPerg,"MV_PAR04",Replicate("Z",TamSX3("DT6_DOC")[1]))
	Else
		// projeto de impressao de documento atraves da rotina de manutencao de documentos TMSA500
		SetMVValue(cPerg,"MV_PAR04",aDoc[2])
	Endif

	//SERIE DE
	SetMVValue(cPerg,"MV_PAR05", Space(TamSX3("DT6_SERIE")[1]) )

	//SERIE ATE
	SetMVValue(cPerg,"MV_PAR06",Replicate("Z",TamSX3("DT6_SERIE")[1]))

	//IMPRESSAO OU REIMPRESSAO
	DT6->( DbSetOrder(2) )
	DT6->( MsSeek( xFilial("DT6") + DTP->DTP_FILORI + DTP->DTP_LOTNFC ) )
	SetMVValue(cPerg,"MV_PAR07", Iif( DT6->DT6_FIMP <> "1",1,2 ))


	If cTipTra != StrZero(4,Len(DT6->DT6_TIPTRA)) //-- Rodoviario Internacional
		If DTP->DTP_TIPLOT == '3' .Or. DTP->DTP_TIPLOT == '4' //-- Eletronico / CTe Unico
			If lRTMSR31
				ExecBlock("RTMSR31",.F.,.F.)
			EndIf
		Else
			ExecBlock("RTMSR01",.F.,.F.)
		EndIf
	Else
		ExecBlock("RTMSR17",.F.,.F.)
	EndIf
EndIf

//-- Limpa marcas dos agendamentos
If !IsInCallStack("TMSAF76")
	TMSALimAge(StrZero(ThreadId(),20))
EndIf

RestArea(aArea)
Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSSegPerc≥ Autor ≥ Eduardo de Souza      ≥ Data ≥ 03/12/04 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Verifica se o servico eh de segundo percurso               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpC1 - Servico                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ TMSA200                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function TMSSegPerc(cServic)

Static __aServic := {}
Local nPos       := 0
Local l1oPerc    := .F.

If (nPos:= Ascan( __aServic, { |x| x[1] == cServic } )) == 0
	//-- Segundo percurso
	DC5->(dbSetOrder(1)) //DC5_FILIAL+DC5_SERVIC+DC5_ORDEM
	DC5->(MsSeek(xFilial("DC5")+cServic))
	l1oPerc := DC5->DC5_SEGPER == StrZero(1,Len(DC5->DC5_SEGPER)) //-- Primeiro/Segundo Percurso
	AAdd( __aServic, { cServic, l1oPerc } )
Else
	l1oPerc := __aServic[nPos,2]
EndIf

Return( l1oPerc )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TmsA200Blq≥ Autor ≥ Eduardo de Souza      ≥ Data ≥ 06/12/04 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Verifica se existe bloqueio de Transporte                  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TmsA200Blq()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ TMSA200                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function TmsA200Blq(nValFre,cCliente,cLoja,l1oPerc,cLotNfc,cServic,cSerTms,cTipTra,;
									nQtdVol,nValor,nPeso,nPesoM3,nMetro3,nSeguro,nQtdUni,aValInf,lBlTms,;
									lRecalculo,aNfCTRC,cCliRem,cLojRem,cCliDes,cLojDes,cCodNeg , cJobThr )
Local cBlqTms := ""
Local aBlqDoc := {}

Default lRecalculo 	:= .F.
Default cJobThr		:= ""

//-- Bloqueio de Transporte
//-- Nao sera avaliado o bloqueio de transporte no Recalculo e na manutencao de documentos
If	lBlTms
	AAdd(aBlqDoc,'')				//-- 01 Codigo do bloqueio de transporte, preenchido pela funcao TmsBlqDoc
	AAdd(aBlqDoc,cCliente)			//-- 02 Cliente devedor
	AAdd(aBlqDoc,cLoja)				//-- 03 Loja
	AAdd(aBlqDoc,'')				//-- 04 Cliente generico, se houver bloqueio definido para o cliente generico, preenchido pela funcao TmsBlqDoc
	AAdd(aBlqDoc,'')				//-- 05 Loja
	AAdd(aBlqDoc,'')				//-- 06 Pedido
	AAdd(aBlqDoc,l1oPerc)			//-- 07 l1oPerc .T. = documento primeiro percurso
	AAdd(aBlqDoc,cLotNfc)			//-- 08 Lote
	AAdd(aBlqDoc,cServic)			//-- 09 Codigo do servico
	AAdd(aBlqDoc,cSerTms)			//-- 10 Tipo de servico
	AAdd(aBlqDoc,cTipTra)			//-- 11 Tipo de transporte
	AAdd(aBlqDoc,nQtdVol)			//-- 12 Qtde de volumes
	AAdd(aBlqDoc,nValor)			//-- 13 Valor da mercadoria
	AAdd(aBlqDoc,nPeso)				//-- 14 Peso real
	AAdd(aBlqDoc,nPesoM3)			//-- 15 Peso cubado
	AAdd(aBlqDoc,nMetro3)			//-- 16 Metro cubico
	AAdd(aBlqDoc,nSeguro)			//-- 17 Base RR
	AAdd(aBlqDoc,nQtdUni)			//-- 18 Qtde de unitizadores
	AAdd(aBlqDoc,AClone(aValInf))	//-- 19 Valor Informado
	AAdd(aBlqDoc,nValFre)			//-- 20 Total do frete sem imposto
	AAdd(aBlqDoc,0)					//-- 21 Valor CTRC Despachante               usado somente na versao padrao
	AAdd(aBlqDoc,'')				//-- 22 Tipo do Veiculo                      usado somente na versao padrao
	AAdd(aBlqDoc,lRecalculo)		//-- 23 Recalculo
	AAdd(aBlqDoc,aNfCTRC)			//-- 24 Notas fiscais do cliente
	AAdd(aBlqDoc,cCliRem)			//-- 25 Cliente remetente
	AAdd(aBlqDoc,cLojRem)			//-- 26 Loja do cliente Remetente
	AAdd(aBlqDoc,cCliDes)			//-- 27 Cliente Destinatario
	AAdd(aBlqDoc,cLojDes)			//-- 28 Loja do cliente Destinatario
	AAdd(aBlqDoc,cCodNeg)			//-- 29 Codigo da Negociacao
	//-- Um codigo de bloqueio de transporte sera retornado pela funcao TmsBlqDoc nas seguintes condicoes...
	//-- 1. Se encontrar bloqueio de transporte definido para o cliente generico ou cliente devedor
	//-- 2. Se o ponto de entrada TMBLQDOC determinar que deve bloquear
	cBlqTms := TmsBlqDoc(aBlqDoc)
EndIf

ResetArr(@aBlqDoc)

Return( cBlqTms )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TmsGeraDoc≥ Autor ≥ Eduardo de Souza      ≥ Data ≥ 07/12/04 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Geracao de documento sem pedido.                           ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TmsGeraDoc(ExpC1,ExpC2,ExpC3,ExpA1)                        ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpC1 - Cliente                                            ≥±±
±±≥          ≥ ExpC2 - Loja                                               ≥±±
±±≥          ≥ ExpC3 - Documento de Transporte                            ≥±±
±±≥          ≥ ExpA1 - Array contendo os itens do SD2                     ≥±±
±±≥          ≥ ExpC4 - Cliente Destino                                    ≥±±
±±≥          ≥ ExpC5 - Loja Destino                                       ≥±±
±±≥          ≥ ExpC6 - Regiao de Calculo                                  ≥±±
±±≥          ≥ ExpC7 - Numero da Solicitacao de Coleta                    ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ TMSA200                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function TmsGeraDoc(cCliente,cLoja,cDocTms,aDadosSD2,aDadosSF2,cCdrCal,;
									cNumSol,lCalcISS,cEstOri,cEstCal,cEstDev,cFilSol,bTTS,cSerie,bFatSE1,aNumDoc, cTipFre, cJobThr)

Local aStruSD2    := SD2->(dbStruct())
Local aStruSF2    := SF2->(dbStruct())
Local n1Cnt       := 0
Local n2Cnt       := 0
Local nPos        := 0
Local nPosTES     := 0
Local aRegSD2     := {}
Local aSF2        := {}
Local aDocOri     := {}
Local aItemOri    := {}
Local cNumNfs     := ""
Local cTexto      := ""
Local nPosAliqIss := 0
Local bFiscalSF2  := { || .T. }
Local bFiscalSD2  := { || .T. }
Local cTextoSF2   := ""
Local cEspecie    := ""
Local cTipoCli    := ""
Local lMostraCtb  := .F.
Local lAglutCtb   := .F.
Local lCtbOnLine  := .F.
Local cCliDest    := ''
Local cLojDest    := ''

Local nPosPICM    := 0
Local nPosValICM  := 0
Local nPosVBsICM  := 0
Local nPosValISS  := 0
Local nPosVBsISS  := 0
Local nPosPrcVen  := 0
Local nPosICMRet  := 0
Local lValISS     := .F.
Local lVBsISS     := .F.
Local lPICM       := .F.
Local lValICM     := .F.
Local lVBsICM     := .F.
Local lVBsSol     := .F.
Local lPrcVen	  := .F.
Local cNumDoc     := ''
Local cEstExt     := ''
Local lF4_AgrISS 		:= SF4->(ColumnPos("F4_AGRISS")) > 0 .And. SF4->F4_AGRISS == "1"	//Nova Regra para calcula ISS
Local oHashSD2
Local xValHash
Local oHashSF2

Default cNumSol   	:= ''
Default cCdrCal   	:= ''
Default lCalcISS  	:= .F.
Default cFilSol   	:= cFilAnt
Default aNumDoc   	:= {}
Default cTipFre   	:= ''
Default cJobThr		:= ""

PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )

If Len(aNumDoc) > 0
	cNumDoc := aNumDoc[1]
	cSerie  := aNumDoc[2]
EndIf
cEspecie := A460Especie(cSerie)

//--Carrega grupo de perguntas
Pergunte('TMB200',.F.)
lAglutCtb	:= mv_par03 == 1
lCtbOnLine	:= mv_par04 == 1

PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )

//-- Alimenta o array contendo os itens da nota fiscal
For n1Cnt := 1 To Len(aDadosSD2)
	AAdd( aDocOri, 0 )
	AAdd( aItemOri, {} )
	//-- Tabela HASH
	oHashSD2	:= AToHM(aDadosSD2[n1Cnt],1,3)
	For n2Cnt := 1 To Len(aStruSD2)

		//-- Comando para encontrar posiÁ„o na estrutura
		If HMGet(oHashSD2, AllTrim(aStruSD2[n2Cnt][1]), @xValHash )

			If !lValISS .And. 'D2_VALISS'  $ aStruSD2[n2Cnt][1] .And. xValHash[1,2]  > 0
				lValISS := .T.
			ElseIf !lVBsISS .And. 'D2_BASEISS' $ aStruSD2[n2Cnt][1] .And. xValHash[1,2]  > 0
				lVBsISS := .T.
			ElseIf !lPICM   .And. 'D2_PICM'    $ aStruSD2[n2Cnt][1] .And. xValHash[1,2]  > 0
				lPICM   := .T.
			ElseIf !lValICM .And. 'D2_VALICM'  $ aStruSD2[n2Cnt][1] .And. xValHash[1,2]  > 0
				lValICM := .T.
			ElseIf !lVBsICM .And. 'D2_BASEICM' $ aStruSD2[n2Cnt][1] .And. xValHash[1,2] > 0
				lVBsICM := .T.
			ElseIf !lVBsSol .And. 'D2_ICMSRET' $ aStruSD2[n2Cnt][1] .And. xValHash[1,2] > 0
				lVBsSol := .T.
			ElseIf !lPrcVen .And. 'D2_PRCVEN' $ aStruSD2[n2Cnt][1] .And. xValHash[1,2] > 0
				lPrcVen := .T.
			EndIf
			
			AAdd(aItemOri[n1Cnt],xValHash[1,2] )
		Else
			If aStruSD2[n2Cnt][2] $ "C/M"
				AAdd(aItemOri[n1Cnt],"")
			ElseIf aStruSD2[n2Cnt][2] == "N"
				AAdd(aItemOri[n1Cnt],0)
			ElseIf aStruSD2[n2Cnt][2] == "D"
				AAdd(aItemOri[n1Cnt],CtoD("  /  /  "))
			ElseIf aStruSD2[n2Cnt][2] == "L"
				AAdd(aItemOri[n1Cnt],.F.)
			EndIf
		EndIf

		//-- Recupera posiÁıes da estrutura
		If nPosAliqIss == 0 .And. AllTrim(aStruSD2[n2Cnt][1]) == "D2_ALIQISS"

			//-- Aliquota do ISS
			nPosAliqIss		:= n2Cnt

		ElseIf lValISS .And. nPosValISS == 0 .And. AllTrim(aStruSD2[n2Cnt][1]) == "D2_VALISS"

			nPosValISS := n2Cnt

		ElseIf lVBsISS .And. (  AllTrim(aStruSD2[n2Cnt][1]) == "D2_BASEISS" .Or.  AllTrim(aStruSD2[n2Cnt][1]) == "D2_PRCVEN" )

			If nPosVBsISS == 0 .And. AllTrim(aStruSD2[n2Cnt][1]) == "D2_BASEISS"
				nPosVBsISS	:= n2Cnt
			ElseIf nPosPrcVen == 0 .And. AllTrim(aStruSD2[n2Cnt][1]) == "D2_PRCVEN"
				nPosPrcVen	:= n2Cnt
			EndIf

		ElseIf lVBsICM .And. ( AllTrim(aStruSD2[n2Cnt][1]) == "D2_BASEICM" .Or.  AllTrim(aStruSD2[n2Cnt][1]) == "D2_PRCVEN" .Or.  AllTrim(aStruSD2[n2Cnt][1]) == "D2_VALICM" .Or. AllTrim(aStruSD2[n2Cnt][1]) == "D2_ICMSRET" )

			If nPosVBsICM == 0 .And. AllTrim(aStruSD2[n2Cnt][1]) == "D2_BASEICM"
				nPosVBsICM := n2Cnt
			ElseIf nPosPrcVen == 0 .And. AllTrim(aStruSD2[n2Cnt][1]) == "D2_PRCVEN"
				nPosPrcVen	:= n2Cnt
			ElseIf nPosValICM == 0 .And. AllTrim(aStruSD2[n2Cnt][1]) == "D2_VALICM"
				nPosValICM	:= n2Cnt
			ElseIf nPosICMRet == 0 .And. AllTrim(aStruSD2[n2Cnt][1]) == "D2_ICMSRET"
				nPosICMRet := n2Cnt
			EndIf
		
		ElseIf lPrcVen .And. nPosPrcVen == 0 .And. AllTrim(aStruSD2[n2Cnt][1]) == "D2_PRCVEN"
			nPosPrcVen	:= n2Cnt

		ElseIf lPICM .And. nPosPICM == 0 .And. AllTrim(aStruSD2[n2Cnt][1]) == "D2_PICM"
			nPosPICM := n2Cnt
		EndIf

	Next n2Cnt

	//-- Limpa os dados do HashMap
	HMClean(oHashSD2)

Next n1Cnt

//-- Hash Map SF2
oHashSF2	:= AToHM(aDadosSF2,1,3)

//-- Alimenta o array contendo o cabecalho da nota fiscal
For n1Cnt := 1 To Len(aStruSF2)
	//-- Comando para encontrar posiÁ„o na estrutura
	If HMGet(oHashSF2, AllTrim(aStruSF2[n1Cnt][1]) , @xValHash )
		AAdd(aSF2,xValHash[1,2])
	Else
		If aStruSF2[n1Cnt][2] $ "C/M"
			AAdd(aSF2,"")
		ElseIf aStruSF2[n1Cnt][2] == "N"
			AAdd(aSF2,0)
		ElseIf aStruSF2[n1Cnt][2] == "D"
			AAdd(aSF2,CtoD("  /  /  "))
		ElseIf aStruSF2[n1Cnt][2] == "L"
			AAdd(aSF2,.F.)
		EndIf
	EndIf
Next n1Cnt

//-- Aliquota do ISS
If aItemOri[Len(aItemOri),nPosAliqIss] <> SuperGetMv('MV_ALIQISS')
	If !Empty(cTexto)
		cTexto += ', '
	EndIf
	If lValISS
		//-- Caso exista alteraÁ„o do valor do ISS, envia parametro para MaFisAlt para n„o recalcular valores
		cTexto += 'MaFisAlt("IT_ALIQISS",aItemOri[nY,nPosAliqIss],nY,.F.,,,,.F.)'
	Else
		cTexto += 'MaFisAlt("IT_ALIQISS",aItemOri[nY,nPosAliqIss],nY,.F.,,,,.F.)'
	EndIf
EndIf

//-- Utilizado em rotinas que importam o documento
If	lValISS
	If nPosValISS > 0
		If !Empty(cTexto)
			cTexto += ', '
		EndIf
		cTexto += 'MaFisAlt("IT_VALISS",aItemOri[nY,nPosValISS],nY,.F.,,,,.F.)'
	EndIf
EndIf

If	lVBsISS
	If nPosVBsISS > 0
		If !Empty(cTexto)
			cTexto += ', '
		EndIf
		cTexto += 'MaFisAlt("IT_VALMERC",aItemOri[nY,nPosPrcVen],nY,.F.,,,,.F.), '
		cTexto += 'MaFisAlt("IT_BASEISS",aItemOri[nY,nPosVBsISS],nY,.F.,,,,.F.), '
		cTexto += 'MaFisAlt("IT_BASEDUP",aItemOri[nY,nPosVBsISS],nY,.F.,,,,.F.), '
		cTexto += 'MaFisAlt("IT_TOTAL"  ,aItemOri[nY,nPosVBsISS],nY,.F.,,,,.F.)'
	EndIf
EndIf

If	lPICM
	If nPosPICM > 0
		If !Empty(cTexto)
			cTexto += ', '
		EndIf
		cTexto += 'MaFisAlt("IT_ALIQICM",aItemOri[nY,nPosPICM],nY,.F.,,,,.F.)'
	EndIf
EndIf

If	lValICM
	If nPosValICM > 0
		If !Empty(cTexto)
			cTexto += ', '
		EndIf
		cTexto += 'MaFisAlt("IT_VALICM",aItemOri[nY,nPosValICM],nY,.F.,,,,.F.)'
	EndIf
EndIf

If	lVBsICM
	If nPosVBsICM > 0
		If !Empty(cTexto)
			cTexto += ', '
		EndIf
		cTexto += 'MaFisAlt("IT_VALMERC",aItemOri[nY,nPosPrcVen],nY,.F.,,,,.F.), '
		cTexto += 'MaFisAlt("IT_BASEICM",aItemOri[nY,nPosVBsICM],nY,.F.,,,,.F.), '
		cTexto += 'MaFisAlt("IT_BICMORI",aItemOri[nY,nPosVBsICM],nY,.F.,,,,.F.), '
		cTexto += 'MaFisAlt("IT_BASEPS2",aItemOri[nY,nPosVBsICM],nY,.F.,,,,.F.), '
		cTexto += 'MaFisAlt("IT_BASECF2",aItemOri[nY,nPosVBsICM],nY,.F.,,,,.F.), '

		If nPosICMRet > 0 .And. lVBsSol
			cTexto += 'MaFisAlt("IT_BASESOL",aItemOri[nY,nPosVBsICM],nY,.F.,,,,.F.), '
			cTexto += 'MaFisAlt("IT_BASEDUP",(aItemOri[nY,nPosVBsICM] - aItemOri[nY,nPosICMRet]),nY,.F.,,,,.F.), '
			cTexto += 'MaFisAlt("IT_VLCSOL",aItemOri[nY,nPosValICM] ,nY,.F.,,,,.F.), '
			cTexto += 'MaFisAlt("IT_VALSOL",aItemOri[nY,nPosICMRet] ,nY,.F.,,,,.F.), '
		Else
			cTexto += 'MaFisAlt("IT_BASEDUP",aItemOri[nY,nPosVBsICM],nY,.F.,,,,.F.), '
		EndIf

		If lTM200BICM
			cTexto += 'MaFisAlt("IT_TOTAL"  ,aItemOri[nY,nPosPrcVen],nY,.F.,,,,.F.) '
		Else
			cTexto += 'MaFisAlt("IT_TOTAL"  ,aItemOri[nY,nPosVBsICM],nY,.F.,,,,.F.) '
		EndIf
	EndIf
EndIf

If	lValISS .Or. lValICM
	//-- Atualiza informaÁıes do livro
	If !Empty(cTexto)
		cTexto += ', '
	EndIf
	cTexto += 'MaFisTes(SD2->D2_TES,0,nY),MaFisLf(nY,.F.)'
	If IsInCallStack("TMSIMPDOC")
		cTexto += ', MaFisRecal("IT_BASEPS2",nY), '
		cTexto += 'MaFisRecal("IT_BASECF2",nY) '
	EndIf
EndIf

//-- Fim do uso em rotinas que importam o documento
If lCalcISS .And. TM200Mun(cCdrCal,cFilSol,cNumSol)
	//-- Se o servico a ser executado for no mesmo municipio da transportadora, nao deve ser gerado titulo de
	//-- retencao de imposto, pois neste caso, o responsavel pelo recolhimento do imposto e' a propria transportadora
	If !Empty(cTexto)
		cTexto += ', '
	EndIf
	cTexto += 'MaFisAlt("NF_RECISS","2",nY,.F.,,,,.F.)'
EndIf

If TYPE("M->C5_VLR_FRT") <> "U"
	If !Empty(cTexto)
		cTexto += ', '
	EndIf
	cTexto += 'MaFisAlt("NF_VLR_FRT",M->C5_VLR_FRT)' // Envia Valor_frete para alterar base do ICMS PAUTA
EndIf

If lF4_AgrISS .And. lCalcISS
	cTexto += ', MaFisAlt("IT_BASEISS",aItemOri[nY,7],nY,.F.,,,,.T.) '
	cTexto += ', MaFisAlt("IT_TOTAL"  ,aItemOri[nY,7],nY,.F.,,,,.T., )'
	cTexto := ', MaFisRecal("IT_VALISS",nY)'
EndIf

If !Empty(cTexto)
	bFiscalSD2 := &('{||'+cTexto+'}')
EndIf

If lTm200Fis
	cTextoSF2 += 'ExecBlock("TM200FIS",.f.,.f.,{ SF2->F2_CLIENTE, SF2->F2_LOJA, nx, .F. })'
	cTextoSF2 += ','
EndIf

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥TRATAMENTO PARA VERIFICAR SE O DESTINATARIO≥
//≥EH CONTRIBUINTE DO IMPOSTO                 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

//--Obtem o cliente destinatario...
//--Verifica primeiro se existe o "Cliente de Entrega" para
//--considerar como destinatario (SF2). Caso nao exista, sera
//--considerado como destinatario da carga o proprio cliente (F2_CLIENTE)

If HMGet(oHashSF2, "F2_CLIENT", @xValHash )
	cCliDest := xValHash[1,2]
	cLojDest := StrZero( 1, Len( SA1->A1_LOJA ) )
Else
	If HMGet(oHashSF2, "F2_CLIENTE", @xValHash )
		cCliDest := xValHash[1,2]
		cLojDest := StrZero( 1, Len( SA1->A1_LOJA ) )
	EndIf
EndIf

If HMGet(oHashSF2, "F2_LOJENT", @xValHash )
	cLojDest := xValHash[1,2]
Else
	If HMGet(oHashSF2, "F2_LOJA", @xValHash )
		cLojDest := xValHash[1,2]
	EndIf
EndIf

TMSA200Cli( cCliente, cLoja)   //posiciona na tabela SA1
cTipoCli := SA1->A1_TIPO

If Empty(cTipFre) .Or. cTipFre == '1'
	cTextoSF2  += 'MaFisAlt( "NF_TPFRETE","" ),'
Else
	cTextoSF2  += 'MaFisAlt( "NF_TPFRETE","F" ),'
EndIf

aAreaSA1 := SA1->(GetArea())
SA1->(DbSetOrder(1))

If SA1->(MsSeek(xFilial('SA1')+ cCliDest + cLojDest)) .And. SA1->A1_CALCSUF == 'S'
	aAreaDUL := DUL->(GetArea())
	DUL->(DbSetOrder(2))
	If !Empty(DTC->DTC_SQEDES) .And. DUL->(MsSeek(xFilial('DUL')+ cCliDest + cLojDest + DTC->DTC_SQEDES))
		If	AllTrim(DUL->DUL_CODMUN) <>  '02603' //AM - Manaus
			cTextoSF2  += 'MaFisAlt( "NF_SUFRAMA", .F. ),'
		EndIf
	EndIf
	RestArea(aAreaDUL)
EndIf
RestArea(aAreaSA1)

cTextoSF2  += 'MaFisAlt( "NF_UFORIGEM", cEstOri, , , , , , .F./*lRecal*/ ),'
If !Empty(cEstExt) .And. cEstCal == 'EX' //-- Quando for cliente estrangeiro
	cTextoSF2  += 'MaFisAlt( "NF_UFDEST", cEstExt, , , , , , .F./*lRecal*/ ),'
Else
	cTextoSF2  += 'MaFisAlt( "NF_UFDEST", cEstCal, , , , , , .F./*lRecal*/ ),'
EndIf
cTextoSF2  += 'MaFisAlt( "NF_PNF_UF", cEstDev, , , , , , .F./*lRecal*/),'
cTextoSF2  += 'MaFisAlt( "NF_ESPECIE", cEspecie, , , , , , .F./*lRecal*/ ),'
cTextoSF2  += 'MaFisAlt( "NF_PNF_TPCLIFOR", cTipoCli )'

//-- Ponto de entrada para incluir alteracoes no calculo de impostos.
If ExistBlock("TM200NFS")
	cTextoSF2 += ExecBlock("TM200NFS",.F.,.F., {cCliDest,cLojDest})
EndIf

PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )
bFiscalSF2 := &( '{||' + cTextoSF2 + '}' )

cNumNfs    := MaNfs2Nfs(,,cCliente,cLoja,cSerie,lMostraCtb,lAglutCtb,lCtbOnLine,,,,,,,,,{|| aRegSD2 := {} },bTTS,aDocOri,aItemOri,aSF2,.F.,bFiscalSF2,bFiscalSD2,bFatSE1,cNumDoc)

//-- Limpa os dados do HashMap
HMClean(oHashSD2)
HMClean(oHashSF2)

//-- Libera o objeto de HashMap
FreeObj(oHashSD2)
FreeObj(oHashSF2)

//-- DestrÛi objeto
oHashSD2 	:= Nil
oHashSF2	:= Nil

ResetArr(@aRegSD2     )
ResetArr(@aSF2        )
ResetArr(@aDocOri     )
ResetArr(@aItemOri    )

PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )

Return { cNumNfs, cSerie }

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TM200VerCot≥ Autor ≥ Eduardo de Souza     ≥ Data ≥ 14/07/05 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Verifica se as informacoes da nota fiscal eh igual cotacao.≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥TM200VerCot(ExpN1,ExpN2,ExpN3,ExpN4,ExpN5,ExpN6,ExpA1,ExpA2 ≥±±
±±≥          ≥            ExpN7,ExpN8)                                    ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpN1 - Volume                                             ≥±±
±±≥          ≥ ExpN2 - Valor                                              ≥±±
±±≥          ≥ ExpN3 - Peso                                               ≥±±
±±≥          ≥ ExpN4 - Peso Cubado                                        ≥±±
±±≥          ≥ ExpN5 - Seguro                                             ≥±±
±±≥          ≥ ExpN6 - Unitizador                                         ≥±±
±±≥          ≥ ExpA1 - Valor Informado                                    ≥±±
±±≥          ≥ ExpA2 - Tipo Veiculo                                       ≥±±
±±≥          ≥ ExpN7 - Posicao do vetor aLote                             ≥±±
±±≥          ≥ ExpN8 - Valor da cotacao                                   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ TMSA200                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function TM200VerCot(nQtdVol,nValor,nPeso,nPesoM3,nSeguro,nQtdUni,aValInf,aTipVei,nCntFor,nVlTotCot)

Local cSeekDT4  := ''
Local cSeekDT8  := ''
Local cSeekDVF  := ''
Local cSeekDVQ  := ''
Local cSeekDVT  := ''
Local cFilDT4   := xFilial('DT4')
Local cFilDT8   := xFilial('DT8')
Local cFilDVF   := xFilial('DVF')
Local cFilDVQ   := xFilial('DVQ')
Local cFilDVT   := xFilial('DVT')
Local aTpvCot   := {}
Local nPosVei   := 0
Local lIgualCot := .F.
Local lRetPE    := .F.
Local nA        := 0
Local aPerfil   := {}
Local cQuery	:= ""
Local cAliasQry	:= ""

If Type("lTmsCFec") == "U"
	Private lTmsCFec  := TmsCFec()
EndIf
If  !Empty(aLote[ nCntFor, LTFILCFS ])
	cSeekDT4 := cFilDT4 + aLote[ nCntFor, LTFILCFS ] + aLote[ nCntFor, LTNUMCOT ]
	cSeekDT8 := cFilDT8 + aLote[ nCntFor, LTFILCFS ] + aLote[ nCntFor, LTNUMCOT ] + aLote[ nCntFor, LTCODPRO ] + 'TF'
	cSeekDVF := cFilDVF + aLote[ nCntFor, LTFILCFS ] + aLote[ nCntFor, LTNUMCOT ] + aLote[ nCntFor, LTCODPRO ]
Else
	cSeekDT4 := cFilDT4 + cFilAnt + aLote[ nCntFor, LTNUMCOT ]
	cSeekDT8 := cFilDT8 + cFilAnt + aLote[ nCntFor, LTNUMCOT ] + aLote[ nCntFor, LTCODPRO ] + 'TF'
	cSeekDVF := cFilDVF + cFilAnt + aLote[ nCntFor, LTNUMCOT ] + aLote[ nCntFor, LTCODPRO ]
EndIf

//-- Verifica se os valores informados na nota fiscal s„o iguais aos valores informados na cotacao
DT4->(DbSetOrder(1))
DVF->(DbSetOrder(2))
DVQ->(DbSetOrder(1))
DT8->(DbSetOrder(1)) //DT8_FILIAL+DT8_FILORI+DT8_NUMCOT+DT8_CODPRO+DT8_CODPAS
If DT8->(MsSeek(cSeekDT8))
	nVlTotCot := DT8->DT8_VALTOT
	If	DT4->(MsSeek(cSeekDT4)) .And.;
		DVF->(MsSeek(cSeekDVF)) .And.;
		DVF->DVF_QTDVOL == nQtdVol .And. DVF->DVF_VALMER == nValor  .And. DVF->DVF_PESO   == nPeso   .And. ;
		DVF->DVF_PESOM3 == nPesoM3 .And. DVF->DVF_BASSEG == nSeguro .And. DVF->DVF_QTDUNI == nQtdUni

		//-- Verifica valor informado da cotaÁ„o com a Nota Fiscal
		lIgualCot := .T.

		If Len(aValInf) == 0
			If  !Empty(aLote[ nCntFor, LTFILCFS ])
				cSeekDVQ := cFilDVQ + aLote[ nCntFor, LTFILCFS ] + aLote[ nCntFor, LTNUMCOT ] + aLote[ nCntFor, LTCODPRO ]
			Else
				cSeekDVQ := cFilDVQ + cFilAnt + aLote[ nCntFor, LTNUMCOT ] + aLote[ nCntFor, LTCODPRO ]
			EndIf
			lIgualCot := DVQ->( !MsSeek( cSeekDVQ ) )
		Else
			For nA := 1 To Len(aValInf)
				If  !Empty(aLote[ nCntFor, LTFILCFS ])
					cSeekDVQ := cFilDVQ + aLote[ nCntFor, LTFILCFS ] + aLote[ nCntFor, LTNUMCOT ] + aLote[ nCntFor, LTCODPRO ] + aValInf[ nA, 1 ]
				Else
					cSeekDVQ := cFilDVQ + cFilAnt + aLote[ nCntFor, LTNUMCOT ] + aLote[ nCntFor, LTCODPRO ] + aValInf[ nA, 1 ]
				EndIf

				If DVQ->( !MsSeek(cSeekDVQ) ) .Or. ;
					DVQ->DVQ_VALOR != aValInf[ nA, 2 ]
					lIgualCot := .F.
					Exit
				EndIf
			Next
		EndIf

		//-- Verifica tipo de veiculo informado da cotaÁ„o com a Nota Fiscal
		If lIgualCot .And. lTmsCFec
			DVT->(DbSetOrder(1))
			If  !Empty(aLote[ nCntFor, LTFILCFS ])
				cSeekDVT := xFilial('DVT') + aLote[ nCntFor, LTFILCFS ] + aLote[ nCntFor, LTNUMSOL ] + aLote[ nCntFor, LTNUMCOT ] + '1'
			Else
				cSeekDVT := xFilial('DVT') + cFilAnt + aLote[ nCntFor, LTNUMSOL ] + aLote[ nCntFor, LTNUMCOT ] + '1'
			EndIf

			If Len(aTipVei) == 0
				lIgualCot := DVT->( !MsSeek( cSeekDVT ) )
			Else
				aTpvCot := {}
				cAliasQry := GetNextAlias()
				cQuery := "   SELECT DVT_TIPVEI, DVT_QTDVEI "
				cQuery += "     FROM " + RetSqlName("DVT")
				cQuery += "    WHERE DVT_FILIAL = '" + xFilial('DVT') + "' "

				If  !Empty(aLote[ nCntFor, LTFILCFS ])
					cQuery += "  AND DVT_FILORI = '" + aLote[ nCntFor, LTFILCFS ] + "' "
					cQuery += "  AND DVT_NUMSOL = '" + aLote[ nCntFor, LTNUMSOL ] + "' "
					cQuery += "  AND DVT_NUMCOT = '" + aLote[ nCntFor, LTNUMCOT ] + "' "
					cQuery += "  AND DVT_ORIGEM = '1' "
				Else
					cQuery += "  AND DVT_FILORI = '" + cFilAnt + "' "
					cQuery += "  AND DVT_NUMSOL = '" + aLote[ nCntFor, LTNUMSOL ] + "' "
					cQuery += "  AND DVT_NUMCOT = '" + aLote[ nCntFor, LTNUMCOT ] + "' "
					cQuery += "  AND DVT_ORIGEM = '1' "
				EndIf

				cQuery += "      AND D_E_L_E_T_ = ' ' "
				cQuery += " ORDER BY " + SqlOrder(DVT->(IndexKey()))
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)

				While (cAliasQry)->(!Eof())
					AAdd( aTpvCot, { (cAliasQry)->DVT_TIPVEI, (cAliasQry)->DVT_QTDVEI } )
					(cAliasQry)->(DbSkip())
				EndDo

				(cAliasQry)->(DbCloseArea())

				For nA := 1 To Len(aTipVei)
					If ( nPosVei := Ascan( aTpvCot, { | e | e[1] == aTipVei[nA,1] } ) ) == 0 .Or. ;
						aTpvCot[nPosVei,2] != aTipVei[nA,2]
						lIgualCot := .F.
						Exit
					EndIf
				Next
			EndIf
		EndIf
	Else
		aPerfil := TmsPerfil(aLote[nCntFor,LTCLIDEV],aLote[nCntFor,LTLOJDEV],,,aLote[nCntFor,LTCLIREM],aLote[nCntFor,LTLOJREM],aLote[nCntFor,LTCLIDES],aLote[nCntFor,LTLOJDES])
		If aPerfil[24] == "2" //-- Mantem o valor da cotacao mesmo que as informacoes da Nota Fiscal sejam diferentes da cotacao de frete.
			lIgualCot := .T.
		EndIf
	EndIf
	If lTm200Cot
		lRetPE := ExecBlock('TM200COT',.F.,.F.,{nVlTotCot, nQtdVol, nValor, nPeso, nPesoM3, nSeguro, nQtdUni, cSeekDVF})
		If ValType(lRetPE) == 'L'
			lIgualCot := lRetPE
		EndIf
	EndIf
EndIf

ResetArr(@aTpvCot   )

Return( lIgualCot )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥ TM200Mun  ≥ Autor ≥ Richard Anderson     ≥ Data ≥ 02/09/05 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Se o servico a ser executado for no mesmo municipio da     ≥±±
±±≥          ≥ transportadora, nao deve ser gerado titulo de retencao     ≥±±
±±≥          ≥ de imposto, pois neste caso, o responsavel pelo  reco-     ≥±±
±±≥          ≥ lhimento do imposto e' a propria transportadora            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TM200Mun(ExpC1,ExpC2,ExpC3)                                ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpC1 - Regiao de Calculo                                  ≥±±
±±≥          ≥ ExpC2 - Fil.Solicitacao de Coleta                          ≥±±
±±≥          ≥ ExpC3 - No.Solicitacao de Coleta                           ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ TMSA200                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function TM200Mun(cCdrCal,cFilSol,cNumSol)

Local aArea     := GetArea()
Local cQuery    := ""
Local cAliasQry := GetNextAlias()
Local cCdrMun   := SuperGetMv("MV_CDRMUN", .F., "") //-- Codigo da Regiao do Municipio
Local lRet      := .F.
Default cFilSol := cFilAnt
Default cNumSol := ""

If !Empty(cCdrMun)
	//-- Se o Codigo do Municipio da Regiao estiver preenchido
	//-- Se a Regiao do Cliente de C·lculo igual ao conteudo do parametro MV_CDRMUN
	If !Empty(cNumSol)
		cQuery := "SELECT DUY_GRPVEN FROM "
		cQuery += RetSqlName("DT5")+" DT5, "
		cQuery += RetSqlName("DUL")+" DUL, "
		cQuery += RetSqlName("DUY")+" DUY  "
		cQuery += " WHERE DT5.DT5_FILIAL = '"+xFilial("DT5")+"'"
		cQuery += "   AND DT5.DT5_FILORI = '"+cFilSol+"'"
		cQuery += "   AND DT5.DT5_NUMSOL = '"+cNumSol+"'"
		cQuery += "   AND DT5.DT5_SQEDES <>'"+Space(Len(DT5->DT5_SQEDES))+"'"
		cQuery += "   AND DT5.D_E_L_E_T_ = ' '"
		cQuery += "   AND DUL.DUL_FILIAL = '"+xFilial("DUL")+"'"
		cQuery += "   AND DUL.DUL_CODCLI = DT5_CLIDES"
		cQuery += "   AND DUL.DUL_LOJCLI = DT5_LOJDES"
		cQuery += "   AND DUL.DUL_SEQEND = DT5_SQEDES"
		cQuery += "   AND DUL.D_E_L_E_T_ =  ' '"
		cQuery += "   AND DUY.DUY_FILIAL = '"+xFilial("DUY")+"'"
		cQuery += "   AND DUY.DUY_GRPVEN = DUL_CDRDES"
		cQuery += "   AND DUL.D_E_L_E_T_ =  ' '"
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
		If (cAliasQry)->(!Eof()) .And. !Empty((cAliasQry)->DUY_GRPVEN)
			cCdrCal := (cAliasQry)->DUY_GRPVEN
		EndIf
		(cAliasQry)->(dbCloseArea())
	EndIf
	If AllTrim(cCdrCal) == cCdrMun
		lRet := .T.
	EndIf
EndIf

RestArea(aArea)

Return( lRet )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TM200DExbL ≥ Autor ≥ Eduardo de Souza     ≥ Data ≥ 11/07/06 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Atualizacao da bLine                                       ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TM200DExbL(ExpN1,ExpA1)                                    ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpN1 - Posicao da linha no listbox                        ≥±±
±±≥          ≥ Expa1 - Documentos                                         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ SIGATMS                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TM200DExbL(nAt,aDocExc,aPict)

Local abLine  := {}
Local nCnt    := 0
Local oOk     := LoadBitMap(GetResources(),"LBOK")
Local oNo     := LoadBitMap(GetResources(),"LBNO")
Local oSemErr := LoadBitmap(GetResources(),"BR_VERDE")
Local oComErr := LoadBitmap(GetResources(),"BR_VERMELHO")

//-- Utilizado na troca de rotas.
If nAt > Len(aDocExc)
	Return( abLine )
EndIf

AAdd( abLine, If(aDocExc[nAt,1],oOk,oNo) )
AAdd( abLine, If(aDocExc[nAt,2],oSemErr,oComErr) )
For nCnt := 3 To Len(aDocExc[nAt])
	AAdd( abLine, Transform(aDocExc[nAt,nCnt],aPict[nCnt]))
Next nCnt

Return( abLine )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥ TM200VDoc ≥ Autor ≥ Eduardo de Souza     ≥ Data ≥ 11/07/06 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Visualizacao do Documento                                  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TM200VDoc(ExpC1,ExpC2,ExpC3)                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpC1 - Filial do Documento                                ≥±±
±±≥          ≥ ExpC2 - Documento                                          ≥±±
±±≥          ≥ ExpC3 - Serie                                              ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ SIGATMS                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function TM200VDoc(cFilDoc,cDocto,cSerie)

TMSViewDoc(cFilDoc,cDocto,cSerie)

Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200Psq≥ Autor ≥ Eduardo de Souza      ≥ Data ≥ 03/06/05 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Pesquisa documentos                                        ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA200Psq(ExpO1)                                          ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpO1 - List Box                                           ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ TMSA144                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TMSA200Psq(aDocExc,oListBox,nPosFil,nPosDoc,nPosSer)

Local aCbx		:= {}
Local cCampo	:= ''
Local cOrd
Local lSeek		:= .F.
Local nOrdem	:= 1
Local nSeek		:= 0
Local oCbx
Local oDlg
Local oPsqGet

//-- (01) Fil.Docto. + No.Docto. + Serie
cCampo := AllTrim(FWX3Titulo('DT6_FILDOC')) + ' + ' + AllTrim(FWX3Titulo('DT6_DOC')) + ' + ' + AllTrim(FWX3Titulo('DT6_SERIE'))
AAdd( aCbx, cCampo )

cCampo := Space( 40 )

DEFINE MSDIALOG oDlg FROM 00,00 TO 100,490 PIXEL TITLE STR0067 //"Pesquisa"

@ 05,05 COMBOBOX oCbx VAR cOrd ITEMS aCbx SIZE 206,36 PIXEL OF oDlg ON CHANGE nOrdem := oCbx:nAt

@ 22,05 MSGET oPsqGet VAR cCampo SIZE 206,10 PIXEL

DEFINE SBUTTON FROM 05,215 TYPE 1 OF oDlg ENABLE ACTION (lSeek := .T.,oDlg:End())
DEFINE SBUTTON FROM 20,215 TYPE 2 OF oDlg ENABLE ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTERED

If	lSeek
	//-- (01) Fil.Docto. + No.Docto. + Serie
	cCampo := AllTrim( cCampo )
	ASort( aDocExc,,,{|x,y| x[nPosFil] + x[nPosDoc] + x[nPosSer] < y[nPosFil] + y[nPosDoc] + y[nPosSer] })
	nSeek := Ascan( aDocExc,{ | x | PadR( x[nPosFil] + x[nPosDoc] + x[nPosSer], Len( cCampo ) ) == cCampo } )
EndIf

If	nSeek > 0
	oListBox:nAT := nSeek
	oListBox:Refresh()
EndIf

oListBox:SetFocus()

Return( .T. )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TM200ValCot≥ Autor ≥ Eduardo de Souza     ≥ Data ≥ 21/07/06 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Retorna os valores da cotacao de frete                     ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TM200ValCot(ExpC1,ExpC2)                                   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpC1 - Filial Cotacao                                     ≥±±
±±≥          ≥ ExpC2 - Cotacao                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ TMSA200                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function TM200ValCot(cFilLot,cLotCot,nPeso,nValMer,nQtdVol)

Local nValor    := 0
Local aArea     := GetArea()
Local cAliasQry := GetNextAlias()
Local cTipRat   := ""

cQuery := " SELECT SUM(DVF_PESO) PESO, SUM(DVF_VALMER) VALMER, SUM(DVF_QTDVOL) QTDVOL, SUM(DVF_QTDUNI) QTDUNIT, DC5_TIPRAT "
cQuery += " FROM " + RetSqlName("DT4") + " DT4, " + RetSqlName("DVF") + " DVF, " + RetSqlName("DC5") + " DC5 "
cQuery += " WHERE DT4_FILIAL = '" + xFilial("DT4") + "' "
cQuery += "   AND DT4_FILORI = '" + cFilLot + "' "
cQuery += "   AND DT4_NUMCOT = '" + cLotCot + "' "
cQuery += "   AND DT4.D_E_L_E_T_ = ' ' "
cQuery += "   AND DVF_FILIAL = '" + xFilial("DVF") + "' "
cQuery += "   AND DVF_FILORI = DT4_FILORI"
cQuery += "   AND DVF_NUMCOT = DT4_NUMCOT"
cQuery += "   AND DVF.D_E_L_E_T_ = ' '"
cQuery += "   AND DC5_FILIAL = '" + xFilial("DC5") + "' "
cQuery += "   AND DC5_SERVIC = DT4_SERVIC"
cQuery += "   AND DC5.D_E_L_E_T_ = ' '"
cQuery += " GROUP BY DVF_FILORI, DVF_NUMCOT, DC5_TIPRAT"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)

cTipRat := (cAliasQry)->DC5_TIPRAT
If	cTipRat == StrZero(0,Len(DC5->DC5_TIPRAT)) .Or. cTipRat == StrZero(4,Len(DC5->DC5_TIPRAT)) .Or. ;
	cTipRat == StrZero(1,Len(DC5->DC5_TIPRAT)) //-- Peso Mercadoria
	nValor := nPeso / (cAliasQry)->PESO
ElseIf cTipRat == StrZero(2,Len(DC5->DC5_TIPRAT)) //-- Valor Mercadoria
	nValor := nValMer / (cAliasQry)->VALMER
ElseIf cTipRat == StrZero(3,Len(DC5->DC5_TIPRAT)) //-- Volumes
	nValor := nQtdVol / (cAliasQry)->QTDVOL
ElseIf cTipRat == StrZero(5,Len(DC5->DC5_TIPRAT)) //-- Qtde Unitilizador
	nValor := nQtdVol / (cAliasQry)->QTDUNIT
EndIf

(cAliasQry)->(DbCloseArea())
RestArea( aArea )

Return( nValor )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥MenuDef   ≥ Autor ≥ Marco Bianchi         ≥ Data ≥01/09/2006≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Utilizacao de menu Funcional                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Retorno   ≥Array com opcoes da rotina.                                 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥Parametros do array a Rotina:                               ≥±±
±±≥          ≥1. Nome a aparecer no cabecalho                             ≥±±
±±≥          ≥2. Nome da Rotina associada                                 ≥±±
±±≥          ≥3. Reservado                                                ≥±±
±±≥          ≥4. Tipo de TransaáÑo a ser efetuada:                        ≥±±
±±≥          ≥    1 - Pesquisa e Posiciona em um Banco de Dados           ≥±±
±±≥          ≥    2 - Simplesmente Mostra os Campos                       ≥±±
±±≥          ≥    3 - Inclui registros no Bancos de Dados                 ≥±±
±±≥          ≥    4 - Altera o registro corrente                          ≥±±
±±≥          ≥    5 - Remove o registro corrente do Banco de Dados        ≥±±
±±≥          ≥5. Nivel de acesso                                          ≥±±
±±≥          ≥6. Habilita Menu Funcional                                  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥   DATA   ≥ Programador   ≥Manutencao efetuada                         ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function MenuDef()

Local lRTMSR01    := ExistBlock("RTMSR01")
Local lRTMSR31    := ExistBlock("RTMSR31",,.T.)
Local aOpcMenu    := {}
//-- CTe
Local lTMSCTe     := SuperGetMv( "MV_TMSCTE", .F., .F. )

Private aRotina   := {}

If lTMSCTe
	If lRTMSR01
		AAdd(aOpcMenu, { STR0107, 'TMSA200Imp' ,0 ,2})	//-- CTRC
	EndIf
	If lRTMSR31
		AAdd(aOpcMenu, { STR0108, 'U_RTMSR31'  ,0 ,2})	//-- DACTE
	EndIf

	AAdd(aOpcMenu, { STR0109, 'TMSR625'    ,0 ,2})	//-- "Log RejeiÁ„o"

	aRotina	:= {	{ STR0002 ,'AxPesqui'   ,0,1,0,.F.},;	//'Pesquisar'
					{ STR0003 ,'TMSA200Mnt' ,0,2,0,Nil},;	//'Calcular'
					{ STR0004 ,'TMSA200Est' ,0,6,0,Nil},;	//'Estornar'
					{ STR0033 ,'TMSA200Rec' ,0,6,0,Nil},;	//'Recalculo'
					{ STR0075 ,'TMSA200Vis' ,0,6,0,Nil},;	//'Cons.Doc'
					{ STR0064 ,'TMSA200Mnt' ,0,5,0,Nil},;	//'Refaturar'
					{ STR0044 , aOpcMenu    ,0,6,0,Nil},;	//'Impressao'
					{ STR0005 ,'TMSA170Leg' ,0,4,0,.F.},;	//'Legenda'
					{ STR0110 ,'TMSAE70(1)' ,0,2}}			// 'Ct-e'
Else
	aRotina	:= {{ STR0002 ,'AxPesqui'  ,0,1,0,.F.},;	//'Pesquisar'
					{ STR0003 ,'TMSA200Mnt',0,2,0,Nil},;	//'Calcular'
					{ STR0004 ,'TMSA200Est',0,6,0,Nil},;	//'Estornar'
					{ STR0033 ,'TMSA200Rec',0,6,0,Nil},;	//'Recalculo'
					{ STR0075 ,'TMSA200Vis',0,6,0,Nil},;	// 'Cons.Doc'
					{ STR0064 ,'TMSA200Mnt',0,5,0,Nil},;	//'Refaturar'
					{ STR0005 ,'TMSA170Leg',0,4,0,.F.}}	//'Legenda'
	If lRTMSR01
		AAdd(aRotina, 	{ STR0044 ,'TMSA200Imp',0,6,0,Nil} )	//'Impressao'
	EndIf
EndIf

AAdd(aRotina, { STR0126, 'TMSA200A'    ,0 ,2})	// ''Selecionar Lotes'

If ExistBlock("TM200MNU")
	ExecBlock("TM200MNU",.F.,.F.)
EndIf

Return( aRotina )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200Vis≥ Autor ≥Aldo Barbosa dos Santos≥ Data ≥12/05/09  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Visualiza Documento de Transporte                          ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA200Vis()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpC1 = Alias do arquivo                                   ≥±±
±±≥          ≥ ExpN1 = Numero do registro                                 ≥±±
±±≥          ≥ ExpN2 = Opcao selecionada                                  ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TMSA200Vis( cAlias, nReg, nOpcx, lConfirma )

Local aAreaAnt		:= GetArea()
Local aAreaDTC		:= DTC->( GetArea() )
Local aAreaDT6		:= DT6->( GetArea() )

DEFAULT nOpcx := 4

TmsA500( .T. /*lVisual*/, /*cLoteAux*/, nOpcx/*nOpc500*/, /*xAutoCab*/, /*xAutoItens*/, /*xAutoNfs*/, "DT6_LOTNFC = '"+DTP->DTP_LOTNFC+ "' "/*cFilParam*/)

RestArea(aAreaAnt)
RestArea(aAreaDTC)
RestArea(aAreaDT6)

Return( Nil )

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥TMSA200PC ∫Autor  ≥Raphael Zampieri    ∫ Data ≥  01/19/10   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Retorna array com quais campos D2_VALIMP estao sendo       ∫±±
±±∫          ≥ utilizados para gravacao de impostos PIS e COFINS          ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ TMSA200                                                    ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function TMSA200PC(cNomeFunc,aAlias)

Local cCpVlCofSa := ''
Local cCpVlPisSa := ''
Local aRelImp2   := {}
Local nScanPis   := 0
Local nScanCof   := 0
Local aCpoImpost := {}

aRelImp2 := MaFisRelImp(cNomeFunc,aAlias)

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Procura em qual campo D2_VALIMP esta gravado valor de PIS ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
If !Empty( nScanPis := aScan(aRelImp2,{|x| x[1]=="SD2" .And. x[3]=="IT_VALPS2"} ) )
	AAdd(aCpoImpost , aRelImp2[nScanPis,2])
EndIf
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Procura em qual campo D2_VALIMP esta gravado valor de COFINS ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
If !Empty( nScanCof := aScan(aRelImp2,{|x| x[1]=="SD2" .And. x[3]=="IT_VALCF2"} ) )
	AAdd(aCpoImpost ,  aRelImp2[nScanCof,2])
EndIf

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Procura em qual campo D2_VALIMP esta gravado valor de PIS ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
If !Empty( nScanPis := aScan(aRelImp2,{|x| x[1]=="SF2" .And. x[3]=="NF_VALPS2"} ) )
	AAdd(aCpoImpost , aRelImp2[nScanPis,2])
EndIf
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Procura em qual campo D2_VALIMP esta gravado valor de COFINS ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
If !Empty( nScanCof := aScan(aRelImp2,{|x| x[1]=="SF2" .And. x[3]=="NF_VALCF2"} ) )
	AAdd(aCpoImpost ,  aRelImp2[nScanCof,2])
EndIf

Return( aCpoImpost )

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥TMSA200   ∫Autor  ≥Fabricio Pequeno    ∫ Data ≥  03/30/11   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ FunÁ„o que retorna o DT8->DT8_VALIMP.                      ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Obs.      ≥ Caso algum imposto saia zerado verificar em qual SD2->D2_  ∫±±
±±∫          ≥ o imposto foi gravado.                                     ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function DT8CalImp(cIncISS,cA1_INCISS,nValPISCOF,nValCrdPre,nD2CrdPre,nPos,nItem,cCliDev,cLojDev,nQtdProd, nDifal )
Local aArea 		:= GetArea()
Local nDT8Imp		:= 0
Local nImpSe2		:= 0
Local nDecimals		:= 2
Local nRatCrPr		:= 0
Local nDif			:= 0
Local nCnt			:= 0
Local lAdItem		:=.T.
Local cQuery		:= ""
Local cAliasQft	:= ""
Local lF4_AgrISS 	:= SF4->(ColumnPos("F4_AGRISS")) > 0 .And. SF4->F4_AGRISS == "1"	//Nova Regra para calcula ISS
Local lD2Aglut      := GetMv("MV_TMSAGD2",,.F.)
Default nDifal 	:= 0

SF4->(dbSetOrder(1))
If SF4->(MsSeek(xFilial("SF4")+SD2->D2_TES))

	//-- Verificando qual imposto foi calculado.
	If		(SF4->F4_ICM == "S" .Or. SF4->F4_ISS == "S") .And. SD2->D2_VALICM > 0 //-- Para calcular ICM quando nao tem substituicao tributaria.
		nImpSe2 := SD2->D2_VALICM
		nDifal  := SD2->D2_VFCPDIF + SD2->D2_DIFAL + SD2->D2_ICMSCOM
		If lD2Aglut
			nDifal :=  Round((nDifal * DT8->DT8_VALPAS) / SD2->D2_PRCVEN, nDecimals )
		EndIf
	ElseIf	(SF4->F4_ICM == "S" .Or. SF4->F4_ISS == "S") .And. SD2->D2_VALISS > 0 //-- Para calcular ISS quando nao tem substituicao tributaria.
		nImpSe2 := SD2->D2_VALISS
	ElseIf SF4->F4_INCSOL <> "N" //-- Quando existir substituicao tributaria
		nImpSe2 := SD2->D2_ICMSRET
	EndIf

	// O preenchimento do campo para agregar ISS, ou destacar, se campo estiver preenchido, caso contrario calcula da forma antiga.
	//-- Calculos de impostos.
	If cIncISS == "N" .And. cA1_INCISS  == "N" .And. SF4->F4_ISS == "S"
		nDT8Imp := Round(((nImpSe2 + nValPISCOF) * a410Arred(DT8->DT8_VALPAS / (1-(SD2->D2_PICM/100))))/SD2->D2_PRCVEN, nDecimals )
	Else
		nDT8Imp := Round(((nImpSe2 + nValPISCOF) * DT8->DT8_VALPAS)/SD2->D2_PRCVEN, nDecimals )
	EndIf

	If lF4_AgrISS
		nDT8Imp := SD2->D2_VALISS
	EndIf

	If ( nValCrdPre > 0 )
		cAliasQft := GetNextAlias()
		cQuery := "	SELECT FT_FILIAL, FT_NFISCAL, FT_SERIE, FT_VALICM, FT_ITEM, FT_CRPRST, FT_CLIEFOR, FT_LOJA "
		cQuery += " FROM " + RetSqlName("SFT")
		cQuery += " WHERE FT_FILIAL = '" +	xFilial('SFT')	+ "'	 AND "
		cQuery += " 	FT_NFISCAL =  '" +	DT8->DT8_DOC	+ "'  	 AND "
		cQuery += " 	FT_SERIE = 	  '" +	DT8->DT8_SERIE	+ "'   	 AND "
		cQuery += " 	FT_ITEM =  	   " + 		nItem		+ "      AND "
		cQuery += " 	FT_CLIEFOR =  '" + 		cCliDev		+ "'     AND "
		cQuery += " 	FT_LOJA =  	  '" + 		cLojDev 	+ "'     AND "
		cQuery += " 	D_E_L_E_T_ =  ' ' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQft)

		If (cAliasQft)->(!Eof()) .And. !Empty((cAliasQft)->FT_CRPRST)
			nRatCrPr := ((cAliasQft)->FT_CRPRST * DT8->DT8_VALPAS)/SD2->D2_PRCVEN
			nDif     := NoRound(((cAliasQft)->FT_CRPRST * DT8->DT8_VALPAS)/SD2->D2_PRCVEN - nRatCrPr,nDecimals+3)
			If nQtdProd > 1
				For nCnt := 1 To Len(aDifCr)
					If aDifCr[nCnt][1] == nItem  .And. Round(aDifCr[nCnt][2] + nDif,nDecimals+3)   >= 0.01   //mesmo componente
						lAdItem := .F.
					 	aDifCr[nCnt][2]	+= nDif
					 	nRatCrPr		+= Round(aDifCr[nCnt][2],nDecimals+3)
					 	aDifCr[nCnt][2]	-= Round(aDifCr[nCnt][2],nDecimals+3)
					 	Exit
					ElseIf aDifCr[nCnt][1] == nItem  .And. aDifCr[nCnt][2] + nDif < 0.01
						lAdItem := .F.
						aDifCr[nCnt][2]	+= nDif
						Exit
					EndIf
				Next
				IIF(lAdItem,Aadd(aDifCr,{ nItem, nDif }),)  //-- Diferenca apos 2 casa
			EndIf
			nDT8Imp   += nRatCrPr
		EndIf
		nD2CrdPre := (cAliasQft)->FT_CRPRST
		(cAliasQft)->(DbCloseArea())
	EndIf

EndIf
RestArea(aArea)
Return(nDT8Imp)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥TMSA200Cli∫Autor  ≥Microsiga           ∫ Data ≥  20/04/12   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Posiciona na tabela SA1 mas antes procura no cache contido  ∫±±
±±∫          ≥no array STATIC aCliRecno                                   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function TMSA200Cli(cCodCli,cLojCli)
Local nPosCli	:= 0
Local lFoundSA1	:= .F.
Local cAuxEmp	:= cEmpAnt+cFilAnt
Local cAuxFil	:= xFilial("SA1")

Default cCodCli := ""
Default cLojCli := ""

SA1->(dbSetOrder(1))

If ( nPosCli := aScan(aCliRecno,{|x|x[1]+x[2]+x[3]+x[4]==cAuxEmp+cAuxFil+cCodCli+cLojCli}) ) > 0
    SA1->( dbGoto(aCliRecno[nPosCli, 5]) )
    lFoundSA1 := .T.
Else
	If	SA1->(MsSeek(cAuxFil+cCodCli+cLojCli))
		lFoundSA1 := .T.
		aAdd(aCliRecno, { cAuxEmp, SA1->A1_FILIAL,SA1->A1_COD, SA1->A1_LOJA, SA1->(Recno()) } )
	EndIf
EndIf

Return(lFoundSA1)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥TMSA200CdRg ∫Autor  ≥Microsiga         ∫ Data ≥  20/04/12   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Posiciona na tabela DUY mas antes procura no cache contido  ∫±±
±±∫          ≥no array STATIC aGrRegRec                                   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function TMSA200CdRg(cCodReg)
Local nPosDUY 	:= 0
Local lFoundDUY	:= .F.
Local cAuxEmp  	:= cEmpAnt+cFilAnt
Local cAuxFil 	:= xFilial("DUY")

DUY->(dbSetOrder(1))

If ( nPosDUY := aScan(aGrRegRec,{|x|x[1]+x[2]+x[3]==cAuxEmp+cAuxFil+cCodReg}) ) > 0
    DUY->( dbGoto(aGrRegRec[nPosDUY, 4]) )
    lFoundDUY := .T.
Else
	If	DUY->(MsSeek(cAuxFil+cCodReg))   //DUY_FILIAL+DUY_GRPVEN
		lFoundDUY := .T.
		aAdd(aGrRegRec, { cAuxEmp, DUY->DUY_FILIAL, DUY->DUY_GRPVEN, DUY->(Recno()) } )
	EndIf
EndIf

Return(lFoundDUY)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥TMSA200Tra  ∫Autor  ≥Fabricio Pequeno    ∫ Data ≥ 18/10/12  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Transmite Ct-e apos calculo                                ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Obs.      ≥ TambÈm exibe uma msg caso n„o seja transmitido.            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Function TMSA200Tra(lLotExpress,cFilAnt,cLotNfc,nTotDoc,nTotnTran,aMsgErr,aVisErr,cOrigem)

Local lRet			:= .T.
Local lCet			:= .F.
Local lCteExp		:= ExistBlock("TMCteExp") //-- Ponto de Entrada(TMCteExp) , retornando valor booleano false(.F.) impedir· a transmiss„o autom·tica do Cte pela viagem express.
Local lVgeExpr	:= Iif(Type("lVgeExpr") <> "U", lVgeExpr, .F.)
Local lTMSCTe    := SuperGetMv( "MV_TMSCTE", .F., .F. )
Local nMonitCte		:= 0

DEFAULT nTotDoc		:= 0
DEFAULT nTotnTran	:= 0
DEFAULT cOrigem		:= ""
DEFAULT aMsgErr		:= {}
DEFAULT aVisErr		:= {}


If DTP->DTP_TIPLOT == '3' .Or.  DTP->DTP_TIPLOT == '4' //-- Eletronico
	Pergunte("TMB200",.F.)

	If (IsInCallStack("TMSA144") .Or. lLotExpress) .And. lCteExp .And. lVgeExpr
		lRet := ExecBlock("TMCteExp",.F.,.F.)
		If ValType(lRet) <> "L"
			lRet := .T.
		EndIf
		If !lRet
			Return()
		EndIf
	EndIf

	If lRet .And. lLotExpress .Or. mv_par02 == 1  //-- Transmite Ct-e apos calculo
		IIf( cOrigem == "TMSA200", TMSAE70(1,DTP->DTP_FILORI,DTP->DTP_LOTNFC), )

		If IsInCallStack("TMSA144")
			Pergunte("TMB144",.F.)
			nMonitCte := Iif(GetRpoRelease() >= "12.1.023", mv_par07, mv_par08)
			If nMonitCte == 1 //--Exibir Monitor do Cte
				aAreaDT6 := DT6->(GetArea())
				DT6->(dbSetOrder(2))
				If DT6->(dbSeek(xFilial("DT6")+DTP->DTP_FILORI + DTP->DTP_LOTNFC))
					//-- Checar o Status do Documento no Processo CT-e
					//-- DT6_IDRCTE == 100 ("Autorizado o uso do CT-e")
					If lTMSCTe
						lCet := Alltrim(DT6->DT6_IDRCTE) == "100" .Or. ! Empty(DT6->DT6_CHVCTG) .Or. Alltrim(DT6->DT6_IDRCTE) == "136"
					EndIf
				EndIf

				If !lCet  //--Lote ainda n„o Transmitido Verifique o Status na Sefaz.
					TMSAE70(1,DTP->DTP_FILORI,DTP->DTP_LOTNFC,,,,,.T.) //--Monitor Cte.
				EndIf
				RestArea(aAreaDT6)
			EndIF
		EndIf

		If lLotExpress
			cAliasDT6 := GetNextAlias()
			cQuery := " SELECT DT6_FILORI, DT6_FILDOC, DT6_DOC, DT6_SERIE, DT6_IDRCTE, DT6_CHVCTG "
			cQuery += "   FROM " + RetSqlName ("DT6") + " "
			cQuery += "	 WHERE DT6_FILIAL = '" + xFilial("DT6") + "' "
			cQuery += " 	AND DT6_FILORI = '" + cFilAnt + "' "
			cQuery += " 	AND DT6_LOTNFC = '" + cLotNfc + "' "
			cQuery += " 	AND D_E_L_E_T_ = ' '"
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDT6)
			While (cAliasDT6)->(!Eof())
				nTotDoc += 1
				lOk:= Alltrim((cAliasDT6)->DT6_IDRCTE) == "100" .Or. !Empty((cAliasDT6)->DT6_CHVCTG) .Or. Alltrim((cAliasDT6)->DT6_IDRCTE) == "136"
				If !lOk
					nTotnTran += 1
					If Empty(aMsgErr)
						AAdd(aMsgErr,{STR0118,'00',''}) //Documentos relacionados abaixo n„o foram transmitidos para a SEFAZ
					EndIf
					AAdd(aMsgErr,{(cAliasDT6)->DT6_FILDOC+'-'+(cAliasDT6)->DT6_DOC+'/'+(cAliasDT6)->DT6_SERIE,'00',''}) // -- Verfica documentos que n„o foram transmitidos
				EndIf
				(cAliasDT6)->(dbSkip())
			EndDo
			(cAliasDT6)->(dbCloseArea())
			If nTotDoc == nTotnTran
				AaddMsgErr( aMsgErr, @aVisErr)
			ElseIf nTotnTran > 0
				If !MsgYesNo(STR0119 + cValToChar(nTotnTran) + " / " + cValToChar(nTotDoc) + STR0122) //Existem 1/10 documentos n„o transmitos para SEFAZ. Deseja Continuar?
					AaddMsgErr(aMsgErr, @aVisErr)
				EndIf
			EndIf
			If	Len( aVisErr ) > 0
				TmsMsgErr( aVisErr )

				//-- Caso venha do TMSA200+TMSEXPRESS o retorno È sempre T pois tem de carregar na tela o documento.
				//-- Caso venha do TMSA310 o retorno È F pois n„o vai fechar viagem se estiver com documentos eletronicos sem transmitir.
				Iif(cOrigem == "TMSA200",lRet := .T., lRet := .F. )
			EndIf
		EndIf
	EndIf
EndIf

Return (lRet)


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥Tmsa460Cor≥ Autor ≥ Leandro Paulino       ≥ Data ≥30/10/2013≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥Monta Legenda do Browser                                    ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥Tmsa460Cor()                                                ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ TMSA460	                                                  ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Function Tmsa200Cor()

Local aCores := {}
//-- Define as cores do status do lote.
AAdd( aCores,{"DTP_STATUS=='1'",'BR_AMARELO'	})	// Aberto
AAdd( aCores,{"DTP_STATUS=='2'",'BR_VERDE'	})	// Digitado
AAdd( aCores,{"DTP_STATUS=='3'",'BR_AZUL'		})	// Calculado
AAdd( aCores,{"DTP_STATUS=='4'",'BR_VERMELHO'})	// Bloqueado
AAdd( aCores,{"DTP_STATUS=='5'",'BR_LARANJA'	})	// Erro na Gravacao

Return aCores

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200UNI≥ Autor ≥ Fabio Marchiori Sampaio Data ≥06.06.2014≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Valida CTe ⁄nico					                          ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA200UNI()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpL1 = 						                              ≥±±
±±≥          ≥ ExpC1 =                                                    ≥±±
±±≥          ≥ ExpA1 =                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function TMSA200UNI( )

Local lRet			:= .F.
Local nQtdUniCTe	:= 0
Local cCliDev		:= ''
Local cLojDev		:= ''
Local cTipEmite		:= ''
Local cTipFrete		:= ''
Local nQtdDev		:= 0
Local aAreaAnt		:= GetArea()
Local cUFUnico      := ""
Local cUFReg        := ""

	For nQtdUniCTe := 1 To Len( aLote )
		If aLote[nQtdUniCTe][LTIPLOT] <> '4'	// Tipo do Lote CTe ⁄nico
			Help( " " , 1 ,"TMSA20045") //Tipo do Lote n„o È para CT-e ⁄nico
			lRet := .F.
			Exit
		EndIf
		If Empty(aLote[nQtdUniCTe][LTCHDANFE]) 	//Chave da DANFE
			Help( " " , 1 ,"TMSA20046") //Para a GeraÁ„o do CT-e ⁄nico e obrigatÛrio informar a chave da DANFE !!
			lRet := .F.
			Exit
		EndIf
		If !TMSA200UF(aLote[nQtdUniCTe][LTCDRORI], @cUFReg ) //Codigo da Regi„o de Origem
			Help( " " , 1 ,"TMSA20047") //-- todo: ATUSX : UF da Regi„o de Origem, ou da Filial atual n„o permite CT-e Globalizado (CT-e ⁄nico)
			lRet := .F.
			Exit
		EndIf
		//-- Inicializa a vari·vel cUFUnico com a primeira UF das NF's processadas, comparando-a com a UF de destino e origem em todas as casas.
		cUFUnico := IIf(Empty(cUFUnico),cUFReg,cUFUnico)

		//-- Compara a UF de ORIGEM da NF com a UF do CT-e ˙nico
		If cUFReg <> cUFUnico
			Help( " " , 1 ,"TMSA20058") //-- todo: ATUSX : Todas as NF's devem possuir mesma UF de Origem e destino, no CT-e Globalizado (CT-e ⁄nico)
			lRet := .F.
			Exit
		EndIf
		If !TMSA200UF(aLote[nQtdUniCTe][LTCDRCAL], @cUFReg) //Codigo da Regi„o de Calculo
			Help( " " , 1 ,"TMSA20048") //-- todo: ATUSX : UF da Regi„o de Destino, ou da Filial atual n„o permite CT-e Globalizado (CT-e ⁄nico)
			lRet := .F.
			Exit
		EndIf
		//-- Compara a UF de DESTINO da NF com a UF do CT-e ˙nico
		If cUFReg <> cUFUnico
			Help( " " , 1 ,"TMSA20058") //-- todo: ATUSX : Todas as NF's devem possuir mesma UF de Origem e destino, no CT-e Globalizado (CT-e ⁄nico)
			lRet := .F.
			Exit
		EndIf

		If Empty(cCliDev) .And. Empty(cLojDev)
			cCliDev	:= aLote[nQtdUniCTe][LTCLIDEV]  //Codigo do Cliente Devedor
			cLojDev	:= aLote[nQtdUniCTe][LTLOJDEV]  //Loja do Cliente Devedor
			nQtdDev := 1
			cTipFrete:= aLote[nQtdUniCTe][LTTIPFRE]
		Else
			If (cCliDev <> aLote[nQtdUniCTe][LTCLIDEV] .Or. cLojDev <> aLote[nQtdUniCTe][LTLOJDEV])
				Help( " " , 1 ,"TMSA20049") //H· tomador diferentes para o lote de CT-e ⁄nico !!
				lRet := .F.
				Exit
			Else
				nQtdDev += 1
			EndIf
		EndIf
		If (aLote[nQtdUniCTe][LTDEVFRE] <> '1' .And. aLote[nQtdUniCTe][LTDEVFRE] <> '2')
			Help( " " , 1 ,"TMSA20052") //Devedor do Frete sÛ ser· permitido para o Remetente ou Destinatario.
			lRet := .F.
			Exit
		EndIf
	Next

	If nQtdDev >= 5
	    cTipEmite := TMSA200EMI(cCliDev, cLojDev, cTipFrete)
		If (cTipEmite = "REMETENTE" .Or. cTipEmite = "DESTINATARIO")
			lRet := .T.
		Else
			Help( "" , 1 ,"TMSA20050") //Quantidade de remetentes ou destinat·rios deve ser maior ou igual a 5.
			lRet := .F.
		EndIf
	EndIf

	If lRet
		DbSelectArea("SA1")
		SA1->(dbSetOrder(3)) //A1_FILIAL+A1_CGC
		If	SA1->(MsSeek(xFilial("SA1")+SM0->M0_CGC))
			lRet := .T.
		Else
			Help( "" , 1 ,"TMSA20051") //Filial n„o est· cadastrada como cliente!!
			lRet := .F.
		EndIf
	EndIf
RestArea(aAreaAnt)

Return (lRet)

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200UF≥ Autor ≥ Fabio Marchiori Sampaio Data ≥09.06.2014≥ ±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Valida Estados aptos a emitir CTe ⁄nico	                  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA200UNI()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpL1 = 						                              ≥±±
±±≥          ≥ ExpC1 =                                                    ≥±±
±±≥
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function TMSA200UF(cCdrRegiao,cUFRegiao)

Local aAreaAnt		:= GetArea()
Local lRet			:= .F.
Local EstFil 		:= SuperGetMV("MV_ESTADO",.F.,"")
Local cUF			:= 'SP/MG/PR/MS'
Default cCdrRegiao	:= ''

	dbSelectArea("DUY")
	DUY->(DbSetOrder(1))
	If	DUY->(DbSeek(xFilial("DUY")+cCdrRegiao))
		If DUY->DUY_EST $ cUF .And. EstFil $ cUF .And. EstFil == DUY->DUY_EST
			cUFRegiao := DUY->DUY_EST
			lRet := .T.
		EndIf
	EndIf

RestArea(aAreaAnt)
Return(lRet)

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200EMI≥ Autor ≥ Fabio Marchiori Sampaio Data ≥27.06.2014≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Valida o que preencher como Emitente se Remetente ou 	  ≥±±
±±≥destinatario nos casos de CTe ⁄nico                  				  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA200UNI()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpL1 = 						                              ≥±±
±±≥          ≥ ExpC1 =                                                    ≥±±
±±≥          ≥ ExpA1 =                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function TMSA200EMI(cCliDev, cLojDev, cTipFrete)

Local nQtdLot  		:= 0
Local cCliRem		:= ''
Local cLojRem		:= ''
Local cCliDes		:= ''
Local cLojDes		:= ''
Local cRet			:= ''
Local aCliRem		:= {}
Local aCliDes		:= {}

Default cCliDev		:= ''
Default cLojDev     := ''
Default cTipFrete   := ''

	For nQtdLot := 1 To Len( aLote )

		cCliRem	:= aLote[nQtdLot][LTCLIREM]  //Codigo do Cliente Remetente
		cLojRem	:= aLote[nQtdLot][LTLOJREM]  //Loja do Cliente Remetente

		If aScan(aCliRem, {|x| x[1] + x[2] == cCliRem+cLojRem }) == 0
			aAdd(aCliRem, {cCliRem,cLojRem})
		EndIf

		cCliDes	:= aLote[nQtdLot][LTCLIDES]  //Codigo do Cliente Destinatario
		cLojDes	:= aLote[nQtdLot][LTLOJDES]  //Loja do Cliente Destinatario

		If aScan(aCliDes, {|x| x[1] + x[2] == cCliDes+cLojDes }) == 0
			aAdd(aCliDes, {cCliDes,cLojDes})
		EndIf
	Next

	If cTipFrete == '1' .And. Len(aCliDes) >= 5
		cRet := "REMETENTE"
	EndIf

	If cTipFrete == '2' .And. Len(aCliRem) >= 5
		cRet := "DESTINATARIO"
	EndIf

ResetArr(@aCliRem		)
ResetArr(@aCliDes		)

Return (cRet)
/*/-----------------------------------------------------------
/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Funcao    ≥A200ReeDev≥ Autor ≥ Ramon Prado				  Data ≥14.01.2015≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥ Altera o conte˙do de algumas posiÁıes do Array aTMSA200 caso≥±±
±±≥a reentrega ou devoluÁ„o seja parcial	              				    ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpL1 = 						                                ≥±±
±±≥          ≥ ExpC1 =                                                    ≥±±
±±≥          ≥ ExpA1 =                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function A200ReeDev(cfilDoc, cDoc,aTMSA200)
Local aArea		:= getArea()
Local cQuery		:= ""
Local cAliasQry	:= GetNextAlias()
Local lDTCOK 		:= DTC->(FieldPos("DTC_OK")) > 0

If lDTCOK
	cQuery := " SELECT DTC_NUMNFC,DTC_SERNFC,DTC_CLIREM,DTC_LOJREM,DTC_CODPRO,DTC_FILORI,DTC_LOTNFC"
	cQuery += " FROM " + RetSqlTab("DTC")
	cQuery += " WHERE DTC_FILIAL = '" + xFilial("DTC") + "'"
	cQuery += "   AND DTC_FILDOC = '" + cFilDoc + "'"
	cQuery += "   AND DTC_DOC    = '" + cDoc + "'"
	cQuery += "   AND DTC_NFENTR = '2' "
	cQuery += "   AND DTC.D_E_L_E_T_ = '' "

	cQuery := ChangeQuery(cQuery)
	DbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), cAliasQry, .F., .T. )

	If (cAliasQry)->(!EOF())
		aTmsA200[24] := 0
		aTmsA200[25] := 0
		aTmsA200[26] := 0
		aTmsA200[30] := 0
		aTmsA200[27] := 0
		aTmsA200[28] := 0
		aTmsA200[29] := 0


		While (cAliasQry)->(!EOF())

			DbSelectArea("DTC")
			DbSetOrder(2) //Filial + Doc.Cliente + Serie Dc.Cli + Remetente + Loja Remet. + Cod. Produto
			If DTC->(MsSeek(xFilial("DTC")+(cAliasQry)->DTC_NUMNFC+(cAliasQry)->DTC_SERNFC+(cAliasQry)->DTC_CLIREM+(cAliasQry)->DTC_LOJREM+(cAliasQry)->DTC_CODPRO+(cAliasQry)->DTC_FILORI+(cAliasQry)->DTC_LOTNFC))
				If Valtype(cMarca) <> 'U'
					If DTC->DTC_OK == cMarca //verificar se nota fiscal foi marcada na markBrowse
						aTmsA200[24] += DTC->DTC_QTDVOL
						aTmsA200[25] += DTC->DTC_VALOR
						aTmsA200[26] += DTC->DTC_PESO
						aTmsA200[30] += DTC->DTC_QTDUNI
						aTmsA200[27] += DTC->DTC_PESOM3
						aTmsA200[28] += DTC->DTC_METRO3
						aTmsA200[29] += DTC->DTC_BASSEG
					EndIf
				Endif
			EndIf
			(cAliasQry)->(DbSkip())
		EndDo
	EndIf
	(cAliasQry)->(DbCloseArea())
EndIf

RestArea(aArea)
Return

/*/-----------------------------------------------------------
{Protheus.doc} TMSA200AGD()
Realiza a inclus„o do Agendamento de Entrega

Uso: TMSA200

@sample
//TMSA200AGD(nOpc,aValuesAGD)

@author Paulo Henrique CorrÍa Cardoso.
@since 30/07/2014
@version 1.0
-----------------------------------------------------------/*/
Static Function TMSA200AGD(nOpc,aValuesAGD)
Local aCampPai 	 	:= {}		// Array para armazenar os campos e valores do cabeÁalho
Local aErro			:= {}		// Array para armazenar os detalhes do erro de valiaÁ„o
Local aMaster 		:= {}		// Array para armazenar os campos da estrutura de cabaÁalho
Local aRet			:= {}		// Recebe o Retorno
Local cRet 			:= ""		// Recebe o Retorno
Local lContinua		:= .T.		// Verifica se continua o Processamento
Local nCount     	:= 0		// Recebe o contador
Local nLnCab		:= 0		// Rcebe o COntador do For
Local oModel		:= NIL		// Recebe o Modelo Principal
Local oModelMast	:= NIL 		// Recebe o Modelo do CabeÁalho
Local oStrucMast	:= NIL		// Recebe a Estrutura do CabeÁalho
Local nPosFilDoc	:= 0		// Recebe a PosiÁ„o do FilDoc
Local nPosDoc		:= 0		// Recebe a PosiÁ„o do Doc
Local nPosSerie		:= 0		// Recebe a PosiÁ„o da Serie
Local nPosTipAgd	:= 0		// Recebe a PosiÁ„o do Tipo de Agendamento

Default	nOpc		:= 3 		// Recebe a OpÁ„o da rotina --> 3 - Inclus„o / 4 - AlteraÁ„o / 5 - Exclus„o
Default aValuesAGD 	:={}		// Recebe os valores do Cabecalho - DYD

If nOpc != 5
	nPosFilDoc	:=  aScan( aValuesAGD, { |aValue| AllTrim( aValue[1] ) == AllTrim( "DYD_FILDOC" ) } )
	nPosDoc		:=  aScan( aValuesAGD, { |aValue| AllTrim( aValue[1] ) == AllTrim(  "DYD_DOC"   ) } )
	nPosSerie	:=  aScan( aValuesAGD, { |aValue| AllTrim( aValue[1] ) == AllTrim(  "DYD_SERIE" ) } )
	nPosTipAgd  :=  aScan( aValuesAGD, { |aValue| AllTrim( aValue[1] ) == AllTrim(  "DYD_TIPAGD" ) } )

	If nPosFilDoc > 0 .AND. nPosDoc > 0 .AND. nPosSerie > 0 .AND. nPosTipAgd > 0
		If !Empty(aValuesAGD[nPosFilDoc][2]) .AND. !Empty(aValuesAGD[nPosDoc][2]) .AND. !Empty(aValuesAGD[nPosSerie][2]) .AND. !Empty(aValuesAGD[nPosTipAgd][2])

			dbSelectArea("DT6")
			DT6->( dbSetOrder(1) )
			// Adiciona os campos referentes ao documento
			If DT6->( dbSeek(FwxFilial('DT6')+aValuesAGD[nPosFilDoc][2]+aValuesAGD[nPosDoc][2]+aValuesAGD[nPosSerie][2] ) )	//	DYD_FILDOC+DYD_DOC+DYD_SERIE

				aAdd( aValuesAGD, { 'DYD_CLIREM', DT6->DT6_CLIREM  } )
				aAdd( aValuesAGD, { 'DYD_LOJREM', DT6->DT6_LOJREM  } )
				aAdd( aValuesAGD, { 'DYD_CLIDES', DT6->DT6_CLIDES  } )
				aAdd( aValuesAGD, { 'DYD_LOJDES', DT6->DT6_LOJDES  } )

				aAdd( aValuesAGD, { 'DYD_FILORI', DT6->DT6_FILORI  } )
				aAdd( aValuesAGD, { 'DYD_FILDES', DT6->DT6_FILDES  } )
				aAdd( aValuesAGD, { 'DYD_CDRORI', Posicione("SA1",1,xFilial("SA1")+DT6->DT6_CLIREM+DT6->DT6_LOJREM,"A1_CDRDES") } )
				aAdd( aValuesAGD, { 'DYD_CDRORI', Posicione("SA1",1,xFilial("SA1")+DT6->DT6_CLIDES+DT6->DT6_LOJDES,"A1_CDRDES") } )
			EndIf

			// Adiciona os campos de Controle
			aAdd( aValuesAGD, { 'DYD_USUAGD', __cUserID } )
			aAdd( aValuesAGD, { 'DYD_DATEMI', DDATABASE 	} )

			If aValuesAGD[nPosTipAgd][2] == '4'
				aAdd( aValuesAGD, { 'DYD_STATUS', "5" } )
			Else
				aAdd( aValuesAGD, { 'DYD_STATUS', "1" } )
			EndIf
		Else
			lContinua := .F.
			Help('', 1,"TMSA200B2") // "Os dados de agendamento de entega n„o foram preenchidos corretamente."
		EndIf
	Else
		lContinua := .F.
		Help('', 1,"TMSA200B2") //  "Os dados de agendamento de entrega n„o foram preenchidos corretamente."
	EndIf
EndIf

If lContinua
	// Carrega o Model
	oModel := FWLoadModel( 'TMSA018' )
	oModel:SetOperation( nOpc )

	// Ativa o Model
	oModel:Activate()

	If nOpc != 5
		// Carrega o Model Master
		oModelMast := oModel:GetModel( "MdFieldDYD" )
		oStrucMast := oModelMast:GetStruct()
		aMaster    := oStrucMast:GetFields()

		// Insere os valores do CabeÁalho
		For nCount := 1 To Len( aValuesAGD )
			If ( aScan( aMaster, { |x| AllTrim( x[3] ) == AllTrim( aValuesAGD[nCount][1] ) } ) ) > 0
				If !Empty(aValuesAGD[nCount][2])
					If !(oModel:SetValue( "MdFieldDYD" , aValuesAGD[nCount][1], aValuesAGD[nCount][2]))
						lContinua := .F.
						Exit
					EndIf
				EndIf
			EndIf
		Next nCount
	EndIf

	If lContinua
		// Se o dados foram validados faz-se a gravaÁ„o efetiva dos dados (commit)
		If ( lContinua := oModel:VldData() )
			oModel:CommitData()
		EndIf
	EndIf

	If !lContinua
		// Se os dados n„o foram validados obtemos a descriÁ„o do erro para gerar LOG ou mensagem de aviso
		aErro := oModel:GetErrorMessage()

		AutoGrLog( STR0131 + ' [' + AllToChar( aErro[1] ) + ']' ) //"Id do formul·rio de origem:"
		AutoGrLog( STR0132 + ' [' + AllToChar( aErro[2] ) + ']' ) //"Id do campo de origem: "
		AutoGrLog( STR0133 + ' [' + AllToChar( aErro[3] ) + ']' ) //"Id do formul·rio de erro: "
		AutoGrLog( STR0134 + ' [' + AllToChar( aErro[4] ) + ']' ) //"Id do campo de erro: "
		AutoGrLog( STR0135 + ' [' + AllToChar( aErro[5] ) + ']' ) //"Id do erro: "
		AutoGrLog( STR0136 + ' [' + AllToChar( aErro[6] ) + ']' ) //"Mensagem do erro: "
		AutoGrLog( STR0137 + ' [' + AllToChar( aErro[7] ) + ']' ) //"Mensagem da soluÁ„o: "
		AutoGrLog( STR0138 + ' [' + AllToChar( aErro[8] ) + ']' ) //"Valor atribuÌdo: "
		AutoGrLog( STR0139 + ' [' + AllToChar( aErro[9] ) + ']' ) //"Valor anterior: "

		MostraErro()
	ElseIf nOpc != 5
		cRet := FwFldGet("DYD_NUMAGD")
	EndIf

	// Desativa o Model
	oModel:DeActivate()
EndIf

aAdd(aRet,lContinua)
aAdd(aRet,cRet)

ResetArr(@aCampPai )
ResetArr(@aErro			)
ResetArr(@aMaster )
Return aRet

/*/-----------------------------------------------------------
{Protheus.doc} TMSA200STU()
Retorna a quantidade de Notas Fiscais do lote.

Uso: TMSA200

@sample
//TMSA200STU()

@author Fabio Marchiori Sampaio.
@since 14/04/2015
@version 1.0
-----------------------------------------------------------/*/

Static Function TMSA200STU(cLotNfc, cFilOri)

Local cAliasQry	:= GetNextAlias()
Local nQdtDtc		:= 0

	cQuery := "   SELECT COUNT(*) nQdtLot  "
	cQuery += "       FROM " + RetSqlName("DTC") + " DTC "
	cQuery += "    WHERE DTC.DTC_FILIAL = '" + xFilial('DTC') + "' "
	cQuery += "      AND DTC.DTC_FILORI = '" + cFilOri + "' "
	cQuery += "      AND DTC.DTC_LOTNFC = '" + cLotNfc + "' "
	cQuery += "      AND DTC.DTC_DOC 	 = ' ' "
	cQuery += "      AND DTC.D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)

	nQdtDtc := (cAliasQry)->nQdtLot

	(cAliasQry)->(DbCloseArea())

Return(nQdtDtc)
/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥TMSA200OBS≥ Autor ≥ Felipe Barbieri         Data ≥14.09.2015≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Retorna Obs Geral CT-e ⁄nico  				              ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ TMSA200OBS()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ ExpL1 = 						                              ≥±±
±±≥          ≥ ExpC1 =                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function TMSA200OBS()

Local EstFil 	:= SuperGetMV("MV_ESTADO",.F.,"")
Local cObs 	:= ""

If EstFil == 'SP'
	cObs := STR0157
ElseIf EstFil == 'MG'
	cObs := STR0158
ElseIf EstFil == 'PR'
	cObs := STR0159
ElseIf EstFil == 'MS'
	cObs := STR0183 //--  "Procedimento efetuado conforme ResoluÁ„o/SEFAZ n∫ 2.833/2017"
EndIf

Return(cObs)
//-------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Tmsa200Col
@autor		: Eduardo Alberti
@descricao	: Grava Dados Para ValorizaÁ„o De Coletas
@since		: Mar./2015
@using		: Tmsa200
@review	:
@param		: 	aPrm200THR     : Vetor Padr„o De Processamento
/*/
//-------------------------------------------------------------------------------------------------
Static Function Tmsa200Col( aPrm200THR )

	Local aArea 	:= GetArea()
	Local aArDT8	:= DT8->(GetArea())
	Local aArDT6	:= DT6->(GetArea())
	Local bCampo	:= {|x| FieldName(x) }
	Local nCnt01  	:= 0
	Local nCnt02  	:= 0
	Local nCnt03  	:= 0
	Local nCnt04	:= 0
	Local nCampos 	:= 0
	Local aNotas	:= {}
	Local aFrete	:= {}
	Local aTotNfs 	:= {}
	Local lRec		:= .T.
	Local aDocto  	:= {}
	Local nPos    	:= 0
	Local nPosVet 	:= 0
	Local nPosDoc 	:= 0
	Local nCnt05  	:= 0
	Local nCnt06  	:= 0
	Local cProdGen	:= Padr(SuperGetMV('MV_PROGEN',,''),Len(SB1->B1_COD))

	DbSelectArea("DT8")

	//-- Cria Vari·veis De MemÛria
	nCampos := DT8->( FCount() )

	nPosVet    := Len(aPrm200THR)
	aNotas  := aPrm200THR[nPosVet][28]
	aDocto  := aPrm200THR[nPosVet][38]
	aFrete  := {}

	//-- Loop Por NFs
	For nCnt01 := 1 To Len(aNotas)

		aFrete := aNotas[nCnt01,02]

		//-- Grava a ComposiÁ„o Do Frete
		For nCnt02 := 1 To Len( aFrete )

			//-- Somente grava DT8 se o valor calculado do componente for maior que zero.
			//-- O vetor aFrete precisa possuir atÈ o final do c·lculo todos os componentes da tabela devido a rotinas de rateio da viagem.
			//-- Isto porque quando utilizar componente por valor informado o usu·rio poder· informar este valor em apenas uma nota de um CTe da viagem.
			//-- E quando o sistema encontra uma situaÁ„o desta (um CTe da viagem possui nota com valor informado e o outro n„o)
			//-- o sistema n„o consegue distribuir o total do valor informado entre CTes que n„o possuem a linha do componente zerado no vetor aFrete.

			If aFrete[nCnt02,02] > 0

				RegToMemory('DT8',.T.)

				M->DT8_FILIAL		:= FWxFilial("DT8")
				M->DT8_CODPAS		:= aFrete[nCnt02,03]
				M->DT8_VALPAS		:= aFrete[nCnt02,02]
				M->DT8_VALIMP		:= 0
				M->DT8_VALTOT		:= aFrete[nCnt02,02]
				M->DT8_FILDOC		:= cFilAnt
				M->DT8_DOC			:= aNotas[nCnt01,3,1,1]
				M->DT8_SERIE		:= aNotas[nCnt01,3,1,2]
				M->DT8_FILORI		:= cFilAnt
				M->DT8_CDRORI		:= Iif( aFrete[nCnt02,03] == 'TF' , "" , aFrete[nCnt02,07] ) //-- Se For 'TF' Deixar Em Branco
				M->DT8_CDRDES		:= Iif( aFrete[nCnt02,03] == 'TF' , "" , aFrete[nCnt02,08] ) //-- Se For 'TF' Deixar Em Branco
				M->DT8_CODPRO		:= Iif(!Empty(aNotas[nCnt01,1]),aNotas[nCnt01,1],cProdGen)
				M->DT8_TABFRE		:= aFrete[nCnt02,09]
				M->DT8_TIPTAB		:= aFrete[nCnt02,10]
				M->DT8_SEQTAB		:= aFrete[nCnt02,11]
				M->DT8_CALMIN		:= aFrete[nCnt02,15]
				M->DT8_PERRAT		:= Iif( aFrete[nCnt02,03] == 'TF' , 0 , aFrete[nCnt02,21] ) //-- Se For 'TF' Deixar Zerado

				//-- Soma Totais Para GravaÁ„o No DT6
				If aFrete[nCnt02,03] == 'TF'

					nPos := aScan( aTotNfs , {|x| x[1] + x[2] == ( M->DT8_DOC + M->DT8_SERIE ) })

					If nPos == 0
						//---- Posiciona no vetor aDocto da Nota
						nPosDoc:= 0
						For nCnt05 := 1 To Len(aDocto)
							For nCnt06 := 1 To Len(aDocto[nCnt05,9])
								nPos1:= AScan(aDocto[nCnt05,9,nCnt06,3],{|x|x[1]+x[2]==aNotas[nCnt01,3,1,1]+aNotas[nCnt01,3,1,2]})
								If nPos1 > 0
									nPosDoc:= nCnt05
									nCnt05 := Len(aDocto)+1
									Exit
								EndIf
							Next
						Next


						aAdd( aTotNfs , {	M->DT8_DOC 				,;	//-- 01 - Doc
											M->DT8_SERIE 				,;	//-- 02 - SÈrie
											M->DT8_VALTOT				,;	//-- 03 - Valor
											aFrete[01,09] 			,;	//-- 04 - Tabela Do Frete
											aFrete[01,10] 			,;	//-- 05 - Tipo Tabela
											aFrete[01,11] 			,;	//-- 06 - Seq. Tabela
											aPrm200THR[nPosVet,04]	,;	//-- 07 - Tipo Frete (DT6_TIPFRE)
											Iif(nPosDoc>0,aDocto[nPosDoc,10,32],''),;	//-- 08 - Numero Contrato
											DTP->DTP_LOTNFC							,;	//-- 09 - Numero Lote
											Iif(nPosDoc>0,aDocto[nPosDoc,02],'')	,;	//-- 10 - Cliente Remetente
											Iif(nPosDoc>0,aDocto[nPosDoc,03],'')	,;	//-- 11 - Loja Remetente
											Iif(nPosDoc>0,aDocto[nPosDoc,06],'')	,;	//-- 12 - Cliente Calculo
											Iif(nPosDoc>0,aDocto[nPosDoc,07],'')	,;	//-- 13 - Loja Calculo
											Iif(nPosDoc>0,aDocto[nPosDoc,10,33],''),;	//-- 14 - Devedor Frete
											aPrm200THR[nPosVet,14]					,;	//-- 15 - Quant Unitizadores
											aPrm200THR[nPosVet,12]					,;	//-- 16 - DT6_BASSEG
											aPrm200THR[nPosVet,11]					,;	//-- 17 - M3 //-- EAlberti Ajuste Pos M3
											Iif(nPosDoc>0,aDocto[nPosDoc,01],'')	,;	//-- 18 - CÛd. ServiÁo
											aPrm200THR[nPosVet,50]					,;	//-- 19 - CÛd. Usu·rio
											Iif(nPosDoc>0,aDocto[nPosDoc,31],'')	,;	//-- 20 - CÛd. NegociaÁ„o
											Iif(nPosDoc>0,aDocto[nPosDoc,25],'')	})	//-- 21 - CÛd. Regiao Calculo

					Else

						aTotNfs[nPos,03] += M->DT8_VALTOT
						aTotNfs[nPos,15] += aPrm200THR[nPosVet,14]
						aTotNfs[nPos,16] += aPrm200THR[nPosVet,12]
						aTotNfs[nPos,17] += aPrm200THR[nPosVet,11]

					EndIf
				EndIf
					/*
					aAdd(aPrm200THR,{	cTaxCtr,    cEstOri,  cEstCal,  cTipoFrt, cCodPro,   cCodProIT,  nQtdVol,  nValor,   nPeso,     nPesoM3,  ;
										nMetro3,    nSeguro,  nNfCTRC,  nQtdUni,  nCntFor,   nTipImp,    nPerImp,  nPesLiq,  lTM200QBR, lTaxa,    ;
										lRecalculo, lUltimo,  lConsig,  lCalImp,  lRefatur,  Nil,        lThread,  aProduto, aNfCTRC,   aValInf,  ;
										aTmsA500,   aFrete,   aVisErr,  aNumDoc,  aICMSol,   aPerfil,    aNFS,     aDocto,   cJobThr,   cJobFile, ;
										cEmpAnt,    cFilAnt,  nPesoCob, aPedBlq,  dDataBase, lImpDoc,    nPerISS,  cIncISS,  cUserName, cCodUser })

					DT6_TIPFRE		//-- OK Tipo Frete 1=Cif 2=Fob
					DT6_NCONTR 	//-- N˙mero Contrato
					DT6_LOTNFC		//-- Numero Lote TMS
					DT6_CLIREM		//--
					DT6_LOJREM		//--
					DT6_CLICAL		//--
					DT6_LOJCAL		//--
					DT6_DEVFRE		//-- Devedor Frete 1=Remetente;2=Destinatario;3=Consignatario;4=Despachante
					DT6_QTDUNI		//-- Quantidade Unitizadores
					DT6_BASSEG		//--
					DT6_METRO3		//-- M3
					DT6_SERVIC		//-- ServiÁo
					DT6_NUMCMP 	(Obs: este campo precisa ser analisado pois nos conhecimentos de entrega/transferÍncia ele È vital para se fazer alguns controles de cancelamento).
					DT6_STATUS		//--
					DT6_USRGER		//-- Usu·rio
					DT6_CODNEG		//-- CÛdigo da NegociaÁ„o

					AAdd(aDocto,{	cServic,;	// 01
									cCliAgr,;	// 02
									cLojAgr,;	// 03
									cCliDes,;	// 04
									cLojDes,;	// 05
									cCliDev,;	// 06
									cLojDev,;	// 07
									cNumCot,;	// 08
									{},;		// 09
									{},;		// 10
									cNumSol,;	// 11
									cTipNfc,;	// 12
									cSequen,;	// 13
									cFilSol,;	// 14
									cSqEDes,;	// 15
									cSeqIns,;	// 16
									cFilDpc,;	// 17
									cCtrDpc,;	// 18
									cSeqInsD,;	// 19
									aLote[nCntFor,LTIPLOT],;	// 20
									cRecISS,;	// 21
									cCliDpc,;	// 22
									cLojDpc,;	// 23
									cCdrOri,;	// 24
									cCdrCal,;	// 25
									cQBRCALC,;	// 26
									cDATAGD,;	// 27
									cQBRDIVG,; // 28
									aLote[nCntFor,LTCLIEXP],; //29
									aLote[nCntFor,LTLOJEXP],; //30
									cCodNeg }) //31

					*/

				//-- Efetua a gravacao
				DbSelectArea("DT8")
				DbSetOrder(2) //-- DT8_FILIAL+DT8_FILDOC+DT8_DOC+DT8_SERIE+DT8_CODPRO+DT8_CODPAS
				If MsSeek( M->DT8_FILIAL + M->DT8_FILDOC + M->DT8_DOC + M->DT8_SERIE + M->DT8_CODPRO + M->DT8_CODPAS , .f. )

					RecLock('DT8',.F.)
					DT8->DT8_VALPAS += M->DT8_VALPAS
					DT8->DT8_VALIMP += M->DT8_VALIMP
					DT8->DT8_VALTOT += M->DT8_VALTOT
					DT8->(MsUnLock())

				Else

					RecLock('DT8',.T.)
					For nCnt04 := 1 To nCampos
						FieldPut( nCnt04, M->&( Eval( bCampo,nCnt04 ) ) )
					Next
					DT8->(MsUnLock())

				EndIf

			EndIf

		Next nCnt02

		//-- Atualiza Tabela DT6
		For nCnt03 := 1 To Len(aTotNfs)

			DbSelectArea("DT6")
			DbSetOrder(1) //-- DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE
			If MsSeek(FWxFilial("DT6") + cFilAnt + aTotNfs[nCnt03,01] + aTotNfs[nCnt03,02] , .f. ) .And. aTotNfs[nCnt03,02] == 'COL'

				RecLock("DT6", .F. )

				Replace DT6->DT6_VALFRE With aTotNfs[nCnt03,03]		//-- Valor Frete
				Replace DT6->DT6_VALTOT With aTotNfs[nCnt03,03]		//-- Valor Total Calculado
				Replace DT6->DT6_TABFRE With aTotNfs[nCnt03,04]		//-- CÛd. Tab. Frete
				Replace DT6->DT6_TIPTAB With aTotNfs[nCnt03,05]		//-- Tipo Tabela
				Replace DT6->DT6_SEQTAB With aTotNfs[nCnt03,06]		//-- Seq. Tabela
				Replace DT6->DT6_TIPFRE With aTotNfs[nCnt03,07]		//-- Tipo Frete 1=Cif 2=Fob
				Replace DT6->DT6_NCONTR With aTotNfs[nCnt03,08] 		//-- N˙mero Contrato
				Replace DT6->DT6_LOTNFC With aTotNfs[nCnt03,09]		//-- Numero Lote TMS
				Replace DT6->DT6_CLIREM With aTotNfs[nCnt03,10]		//-- Cliente Remetente
				Replace DT6->DT6_LOJREM With aTotNfs[nCnt03,11]		//-- Loja Remetente
				Replace DT6->DT6_CLICAL With aTotNfs[nCnt03,12]		//-- Cliente Calculo
				Replace DT6->DT6_LOJCAL With aTotNfs[nCnt03,13]		//-- Loj Calculo
				Replace DT6->DT6_DEVFRE With aTotNfs[nCnt03,14]		//-- Devedor Frete 1=Remetente;2=Destinatario;3=Consignatario;4=Despachante
				Replace DT6->DT6_QTDUNI With aTotNfs[nCnt03,15]		//-- Quantidade Unitizadores
				Replace DT6->DT6_BASSEG With aTotNfs[nCnt03,16]		//-- TDA
				Replace DT6->DT6_METRO3 With aTotNfs[nCnt03,17]		//-- M3
				Replace DT6->DT6_SERVIC With aTotNfs[nCnt03,18]		//-- ServiÁo
				Replace DT6->DT6_STATUS With "1"						//-- Status DT6
				Replace DT6->DT6_USRGER With aTotNfs[nCnt03,19]		//-- Usu·rio
				Replace DT6->DT6_CODNEG With aTotNfs[nCnt03,20]		//-- CÛdigo da NegociaÁ„o
				Replace DT6->DT6_CDRCAL With aTotNfs[nCnt03,21]		//-- Regiao de Calculo

				DT6->(MsUnlock())

			EndIf
		Next nCnt03
	Next nCnt01

	ResetArr(@aNotas	)
	ResetArr(@aFrete	)
	ResetArr(@aTotNfs )

	RestArea(aArDT8)
	RestArea(aArDT6)
	RestArea(aArea)

Return()
//-------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Tmsa200Qry
@autor		: Eduardo Alberti
@descricao	: Monta Query Da ValorizaÁ„o Das Viagens De Coleta
@since		: Apr./2015
@using		: Tmsa200
@review	:
@param		: 	cLotNfc	: Numero Do Lote De Coleta Constante Na Tabela DTP
				cUsrFil	: Filtro De Usu·rio Conforme Ponto Entrada TM200FIL
/*/
//-------------------------------------------------------------------------------------------------
Static Function Tmsa200Qry( cLotNfc , cUsrFil )

	Local aArea		:= GetArea()
	Local cCampos		:= ""
	Local cQuery		:= ""
	Local lAgdEntr	:= Iif(FindFunction("TMSA018Agd"),TMSA018Agd(),.F.)   //-- Agendamento de Entrega.
	Local lExped 		:= DTC->(ColumnPos('DTC_CLIEXP')) > 0
	Local lRecebedor	:= DTC->(ColumnPos('DTC_CLIREC')) > 0
	Local lRetira       := DTC->(ColumnPos("DTC_RETIRA")) > 0
	Local lFecViag	:= IsInCallStack("TMSA310Grv")
	Local nTamNumSol	:= TamSX3("DTC_NUMSOL")[1]
	Local cMV_CdrOri	:= SuperGetMV("MV_CDRORI",.F.,"")
	Local cProGen		:= Padr(SuperGetMV('MV_PROGEN',,''),Len(SB1->B1_COD))
	Local cTipOpe		:= ""
	Local cCdrDes		:= ""

	//-- Vari·veis De OcorrÍncias
	Local cOco01		:= StrZero( 01 , TamSX3("DT2_TIPOCO")[1])
	Local cOco04		:= StrZero( 04 , TamSX3("DT2_TIPOCO")[1])
	Local cOco12		:= StrZero( 12 , TamSX3("DT2_TIPOCO")[1])
	Local cConf 		:= FormatIn( cOco01                , "," )	//-- Ocorrencias De ConfirmaÁ„o
	Local cCanc		:= FormatIn( cOco04 + "," + cOco12 , "," )	//-- Ocorrencias De Cancelamento

	Default cLotNfc	:= ""
	Default cUsrFil	:= ""

	//-- Determina o Tipo De OperaÁ„o da Coleta
	DbSelectArea("DUD")
	DbSetOrder( 16 ) //-- DUD_FILIAL+DUD_FILORI+DUD_LOTE
	MsSeek( FWxFilial("DUD") + cFilAnt + cLotNfc , .f. )

	DbSelectArea("DT5")
	DT5->(DbSetOrder( 4 )) //-- DT5_FILIAL+DT5_FILDOC+DT5_DOC+DT5_SERIE
	MsSeek( FWxFilial('DT5') + DUD->DUD_FILDOC + DUD->DUD_DOC + DUD->DUD_SERIE, .f. )

	cTipOpe := TmsSobServ('TIPOPE',.T.,.T.,DT5->DT5_NCONTR,DT5->DT5_CODNEG,DT5->DT5_SERVIC,"0", Nil )

	cCampos := " DT5.DT5_FILIAL     DTC_FILIAL, "
	cCampos += " DT5.DT5_FILORI     DTC_FILORI, "
	cCampos += " ' '                DTC_FILDPC, "
	cCampos += " ' '                DTC_FILCFS, "
	cCampos += " DUD.DUD_LOTE       DTC_LOTNFC, "
	cCampos += " DT5.DT5_NUMSOL     DTC_NUMNFC, "
	cCampos += " 'COL'              DTC_SERNFC, "
	cCampos += " DT5.DT5_NUMCOT     DTC_NUMCOT, "
	cCampos += " DUM.DUM_ITEM       DUM_ITEM,   "
	cCampos += " ' '                DTC_DOC,    "
	cCampos += " ' '                DTC_SERIE,  "
	cCampos += " DT5.DT5_CLIREM     DTC_CLIREM, "
	cCampos += " DT5.DT5_LOJREM     DTC_LOJREM, "
	cCampos += " DT5.DT5_CLIDES     DTC_CLIDES, "
	cCampos += " DT5.DT5_LOJDES     DTC_LOJDES, "
	cCampos += " DT5.DT5_CLIDEV     DTC_CLIDEV, "
	cCampos += " DT5.DT5_LOJDEV     DTC_LOJDEV, "
	cCampos += " DT5.DT5_CLIDEV     DTC_CLICAL, "
	cCampos += " DT5.DT5_LOJDEV     DTC_LOJCAL, "
	cCampos += " ' '                DTC_CLICON, "
	cCampos += " ' '                DTC_LOJCON, "
	cCampos += " ' '                DTC_CLIDPC, "
	cCampos += " ' '                DTC_LOJDPC, "
	cCampos += " '1'                DTC_SERTMS, " //-- Coleta
	cCampos += " DT5.DT5_SERVIC     DTC_SERVIC, "
	cCampos += " '0'                DTC_TIPNFC, " //-- 0=Normal;1=Devolucao;2=SubContratacao;3=Nao Fiscal;4=Exportacao;5=Redesp;6=Nao Fiscal 1;7=Nao Fiscal 2;8=Serv Vincul.Multimodal
	cCampos += " DT5.DT5_TIPTRA     DTC_TIPTRA, "
	cCampos += " '1'                DTC_DOCTMS, " //-- Coleta

	//-- Determina Devedor Do Frete
	cCampos += " CASE "
	cCampos += " WHEN DT5.DT5_CLIREM || DT5.DT5_LOJREM = DT5.DT5_CLIDEV || DT5.DT5_LOJDEV THEN '1' "
	cCampos += " WHEN DT5.DT5_CLIDEV || DT5.DT5_LOJDEV = DT5.DT5_CLIDES || DT5.DT5_LOJDES THEN '2' "
	cCampos += " ELSE '1' "
	cCampos += " END DTC_DEVFRE, "

	cCampos += " DT5.DT5_TIPFRE     DTC_TIPFRE, "
	cCampos += " DT5.DT5_CDRORI     DTC_CDRORI, "
	cCampos += " DT5.DT5_CDRDCA     DTC_CDRDES, "

	//-- Determina CDRCAL Conforme OperaÁ„o No Contrato Do Cliente
	cCampos += " '" + DTP->DTP_CALRAT +"'       DTC_CDRCAL, "

	cCampos += " ' '                DTC_CDRPER, "
	cCampos += " DT5.DT5_SQEDES     DTC_SQEDES, "
	cCampos += " ' '                DTC_SQICON, "
	cCampos += " ' '                DTC_SQIDES, "
	cCampos += " ' '                DTC_SQIDPC, "
	cCampos += " ' '                DTC_SQIREM, "
	cCampos += " ' '                DTC_CTRDPC, "
	cCampos += " 0                  DTC_VALDPC, "

	//-- Determina a Base Risco Rodoviario (DTC_BASSEG)
	cCampos += " CASE "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL AND DT2.DT2_TIPOCO IN " + cConf + " THEN DUA.DUA_BASOCO "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL AND DT2.DT2_TIPOCO IN " + cCanc + " THEN SUM(DUM.DUM_BASSEG) "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL                                     THEN SUM(DUM.DUM_BASSEG) "
	cCampos += " ELSE DTC.DTC_BASSEG "
	cCampos += " END  DTC_BASSEG, "

	//-- Determina a Quantidade Unitizador (DTC_QTDUNI)
	cCampos += " CASE "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL AND DT2.DT2_TIPOCO IN " + cConf + " THEN DUA.DUA_QTUOCO "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL AND DT2.DT2_TIPOCO IN " + cCanc + " THEN SUM(DUM.DUM_QTDUNI) "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL                                     THEN SUM(DUM.DUM_QTDUNI) "
	cCampos += " ELSE DTC.DTC_QTDUNI "
	cCampos += " END  DTC_QTDUNI, "

	//-- Determina o Numero Da SolicitaÁ„o De Coleta (DTC_NUMSOL)
	If lFecViag
		cCampos += " DT5.DT5_NUMSOL DTC_NUMSOL, "
	Else //-- Encerramento Viagem
		cCampos += " CASE "
		cCampos += " WHEN DTC.DTC_NUMSOL IS NULL THEN ' ' "
		cCampos += " ELSE DTC.DTC_NUMSOL "
		cCampos += " END  DTC_NUMSOL, "
	EndIf

	//-- Determina o CÛdigo Do Produto (DTC_CODPRO)
	cCampos += " '" + cProGen + "'  DTC_CODPRO, "

	//-- Determina a Kilometragem (DTC_KM)
	If lFecViag
		cCampos += " DT5.DT5_KM DTC_KM, "
	Else //-- Encerramento Viagem
		cCampos += " CASE "
		cCampos += " WHEN DTC.DTC_NUMSOL IS NULL AND DT2.DT2_TIPOCO IN " + cConf + " THEN DUA.DUA_KMDOC  "
		cCampos += " WHEN DTC.DTC_NUMSOL IS NULL AND DT2.DT2_TIPOCO IN " + cCanc + " THEN DT5.DT5_KM     "
		cCampos += " ELSE DTC.DTC_KM "
		cCampos += " END  DTC_KM, "
	EndIf

	//-- Determina o M3 (DTC_METRO3)
	cCampos += " CASE "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL AND DT2.DT2_TIPOCO IN " + cConf + " THEN DUA.DUA_MT3OCO "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL AND DT2.DT2_TIPOCO IN " + cCanc + " THEN SUM(DUM.DUM_METRO3) "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL                                     THEN SUM(DUM.DUM_METRO3) "
	cCampos += " ELSE DTC.DTC_METRO3 "
	cCampos += " END  DTC_METRO3, "

	//-- Determina o Peso (DTC_PESO)
	cCampos += " CASE "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL AND DT2.DT2_TIPOCO IN " + cConf + " THEN DUA.DUA_PESOCO "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL AND DT2.DT2_TIPOCO IN " + cCanc + " THEN SUM(DUM.DUM_PESO)  "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL                                     THEN SUM(DUM.DUM_PESO)  "
	cCampos += " ELSE DTC.DTC_PESO "
	cCampos += " END  DTC_PESO, "

	//-- Determina o M3 (DTC_PESOM3)
	cCampos += " CASE "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL AND DT2.DT2_TIPOCO IN " + cConf + " THEN DUA.DUA_PM3OCO "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL AND DT2.DT2_TIPOCO IN " + cCanc + " THEN SUM(DUM.DUM_PESOM3) "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL                                     THEN SUM(DUM.DUM_PESOM3) "
	cCampos += " ELSE DTC.DTC_PESOM3 "
	cCampos += " END  DTC_PESOM3, "

	//-- Determina a Qtd. Volumes (DTC_QTDVOL)
	cCampos += " CASE "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL AND DT2.DT2_TIPOCO IN " + cConf + " THEN DUA.DUA_QTDOCO "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL AND DT2.DT2_TIPOCO IN " + cCanc + " THEN SUM(DUM.DUM_QTDVOL) "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL                                     THEN SUM(DUM.DUM_QTDVOL) "
	cCampos += " ELSE DTC.DTC_QTDVOL "
	cCampos += " END  DTC_QTDVOL, "

	//-- Determina o Valor (DTC_VALOR)
	cCampos += " CASE "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL AND DT2.DT2_TIPOCO IN " + cConf + " THEN DUA.DUA_VLROCO "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL AND DT2.DT2_TIPOCO IN " + cCanc + " THEN SUM(DUM.DUM_VALMER) "
	cCampos += " WHEN DTC.DTC_NUMSOL IS NULL                                     THEN SUM(DUM.DUM_VALMER) "
	cCampos += " ELSE DTC.DTC_VALOR "
	cCampos += " END  DTC_VALOR, "

	cCampos += " ' '            DTC_NFEID,  "
	cCampos += " ' '            DTC_CTEANT, "
	cCampos += " 0              DTC_RECNO,  "
	cCampos += " ' '            DTC_RECISS, "
	cCampos += " 0              DTC_PESLIQ, "
	cCampos += " 1              DTC_MOEDA,  "
	cCampos += " 1              DTC_MOENFC, "
	cCampos += " ' '            DTC_EXCTDA  "

	If lAgdEntr
		cCampos += " , "
		cCampos += " ' '        DTC_DATAGD, "
		cCampos += " ' '        DTC_NUMAGD, "
		cCampos += " ' '        DTC_ITEAGD  "
	EndIf

	If lExped
		cCampos += " , "
		cCampos += " ' '        DTC_CLIEXP, "
		cCampos += " ' '        DTC_LOJEXP  "
	EndIf
	If lRecebedor
		cCampos += " , "
		cCampos += " ' '        DTC_CLIREC, "
		cCampos += " ' '        DTC_LOJREC  "
	EndIf

	If lRetira
		cCampos += " , "
		cCampos += " ' '        DTC_RETIRA  "
	EndIf

	cCampos += " , "
	cCampos += " DT5.DT5_CODNEG DTC_CODNEG  "

	//-- Frete Informado
	cCampos += " , "
	cCampos += " SUM(DTC.DTC_VLRINF) DTC_VLRINF "

	//-- Montagem efetiva da query
	cQuery := " SELECT "			+ cCampos
	cQuery += " FROM "  			+ RetSqlName("DUD") + " DUD "

	cQuery += " INNER JOIN "  	+ RetSqlName("DT5") + " DT5 "
	cQuery += " ON 				DT5.DT5_FILIAL 	=  '" + FWxFilial("DT5") + "'"
	cQuery += " AND 				DT5.DT5_FILDOC 	=  DUD.DUD_FILDOC "
	cQuery += " AND 				DT5.DT5_DOC    	=  DUD.DUD_DOC "
	cQuery += " AND 				DT5.DT5_SERIE  	=  DUD.DUD_SERIE "

	//-- CL Fase 2 - Processa Somente SolicitaÁıes De Coleta Com CÛdigo De NegociaÁ„o e/ou ServiÁo.
	cQuery += " AND 				(DT5.DT5_CODNEG <> '" + Space(TamSX3("DT5_CODNEG")[1]) + "' OR DT5.DT5_SERVIC <> '" + Space(TamSX3("DT5_SERVIC")[1]) + "') "
	cQuery += " AND 				DT5.D_E_L_E_T_ 	= ' '"

	cQuery += " INNER JOIN "  	+ RetSqlName("DUM") + " DUM "
	cQuery += " ON 				DUM.DUM_FILIAL	=  '" + FWxFilial("DUM") + "'"
	cQuery += " AND 				DUM.DUM_FILORI	=  DT5.DT5_FILORI "
	cQuery += " AND 				DUM.DUM_NUMSOL	=  DT5.DT5_NUMSOL "
	cQuery += " AND 				DUM.D_E_L_E_T_ 	=  ' '"

	cQuery += " LEFT JOIN "     + RetSqlName("DTC") + " DTC "
	cQuery += " ON              DTC.DTC_FILIAL  	=  '" + FWxFilial("DTC") + "'"
	cQuery += " AND             DTC.DTC_NUMSOL  	=  DT5.DT5_NUMSOL "
	cQuery += " AND             DTC.DTC_CODPRO	=  DUM.DUM_CODPRO "
	cQuery += " AND             DTC.DTC_NUMSOL  	<> '" + Space(nTamNumSol) + "'"
	cQuery += " AND             DTC.D_E_L_E_T_  	=  ' ' "

	cQuery += " LEFT JOIN "     + RetSqlName("DUA") + " DUA "
	cQuery += " ON              DUA.DUA_FILIAL  	=  '" + FWxFilial("DUA") + "'"
	cQuery += " AND             DUA.DUA_FILDOC  	=  DT5.DT5_FILDOC "
	cQuery += " AND             DUA.DUA_DOC     	=  DT5.DT5_DOC "
	cQuery += " AND             DUA.DUA_SERIE   	=  DT5.DT5_SERIE "
	cQuery += " AND             DUA.D_E_L_E_T_  	=  ' ' "

	cQuery += " LEFT JOIN " 		+ RetSqlName("DT2") + " DT2 "
	cQuery += " ON          		DT2.DT2_FILIAL	=  '" + FWxFilial("DT2") + "'"
	cQuery += " AND         		DT2.DT2_CODOCO  	=  DUA.DUA_CODOCO "
	cQuery += " AND         		DT2.D_E_L_E_T_  	=  ' ' "

	cQuery += " WHERE 			DUD.DUD_FILIAL 	=  '" + FWxFilial("DUD") + "'"
	cQuery += " AND 				DUD.DUD_FILORI 	=  '" + cFilAnt + "'"
	cQuery += " AND 				DUD.DUD_LOTE   	=  '" + cLotNfc + "'"
	If IsInCallStack("TMSA340GRV")
		cQuery += " AND                 DUD.DUD_VIAGEM  =  '" + DTQ->DTQ_VIAGEM + "'"
	EndIf
	cQuery += " AND 				DUD.D_E_L_E_T_	=  ' ' "

	If !Empty(cRet)
		cQuery += cRet
	EndIf

	cQuery += " GROUP BY    DT5.DT5_FILIAL,DT5.DT5_FILORI,DUD.DUD_LOTE,DT5.DT5_NUMSOL,DT5.DT5_NUMCOT,DUM.DUM_ITEM,DT5.DT5_CLIREM, "
	cQuery += "             DT5.DT5_LOJREM,DT5.DT5_CLIDES,DT5.DT5_LOJDES,DT5.DT5_CLIDEV,DT5.DT5_LOJDEV,DT5.DT5_CLIDEV, "
	cQuery += "             DT5.DT5_LOJDEV,DT5.DT5_SERVIC,DT5.DT5_TIPTRA,DT5.DT5_TIPFRE,DT5.DT5_CDRORI,DT5.DT5_CDRDCA,DT5.DT5_SQEDES, "
	cQuery += "             DT2.DT2_TIPOCO,DUA.DUA_BASOCO,DTC.DTC_NUMSOL,DT5.DT5_KM,DUA.DUA_KMDOC,DTC.DTC_BASSEG,DTC.DTC_QTDUNI, "
	cQuery += "             DTC.DTC_KM,DTC.DTC_METRO3,DTC.DTC_PESO,DTC.DTC_PESOM3,DTC.DTC_QTDVOL,DTC.DTC_VALOR,DUA.DUA_QTUOCO, "
	cQuery += "             DUA.DUA_MT3OCO,DUA.DUA_PESOCO,DUA.DUA_PM3OCO,DUA.DUA_QTDOCO,DUA.DUA_VLROCO "

	//-- Inclui Campos Ocasionais No Group
	If cTipOpe <> '1'
		cQuery += ","
		cQuery += "			DT5.DT5_CDRDCA "
	EndIf

	If lAgdEntr
		cQuery += ","
		cQuery += "          DTC_DATAGD, "
		cQuery += "			DTC_NUMAGD, "
		cQuery += "			DTC_ITEAGD  "
	EndIf

	If lExped
		cQuery += ","
		cQuery += "			DTC_CLIEXP, "
		cQuery += "			DTC_LOJEXP  "
	EndIf
	If lRecebedor
		cQuery += ","
		cQuery += "			DTC_CLIREC, "
		cQuery += "			DTC_LOJREC  "
	EndIf

	cQuery += ","
	cQuery += "			DT5.DT5_CODNEG  "

	cQuery += " ORDER BY    DT5.DT5_FILIAL,DT5.DT5_FILORI,DT5.DT5_CLIREM,DT5.DT5_LOJREM,DT5.DT5_CLIDES,DT5.DT5_LOJDES,"
	cQuery += "             DT5.DT5_CODNEG,DT5.DT5_SERVIC,DT5.DT5_NUMSOL "

	//-- Restaura Posicionamento Original
	RestArea(aArea)

Return(cQuery)

//-------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Tmsa200Pes
@autor		: Eduardo Alberti
@descricao	: Retorna Arquivo Tempor·rio Contendo As ReferÍncias De Pesos Das Coletas
@since		: May./2015
@using		: Tmsa200
@review	:
@param		: 	cLotNfc	: Numero Do Lote De Coleta Constante Na Tabela DTP
				cNfCol		: Numero Nota Fiscal Coleta
				cSerCol	: SÈrie Nota Fiscal Coleta
@Retorno   : Nome Do Arquivo Tempor·rio Contendo Os Campos :
			  DT5_FILIAL,DT5_FILORI,DUD_LOTE,DT5_NUMSOL,DT5_DOC,DT5_SERIE,DTC_NUMSOL,CODPRO,DUA_BASOCO,DUM_BASSEG,DTC_BASSEG,
			  DUA_QTUOCO,DUM_QTDUNI,DTC_QTDUNI,DT5_KM,DTC_KM,DUA_MT3OCO,DUM_METRO3,DTC_METRO3,DUA_PESOCO,DUM_PESO,DTC_PESO,
			  DUA_PM3OCO,DUM_PESOM3,DTC_PESOM3,DUA_QTDOCO,DUM_QTDVOL,DTC_QTDVOL,DUA_VLROCO,DUM_VALMER,DTC_VALOR
/*/
//-------------------------------------------------------------------------------------------------
Function Tmsa200Pes( cLotNfc , cNFCol , cSerCol )

	Local aArea		:= GetArea()
	Local cQuery		:= ""
	Local cProGen		:= Padr(SuperGetMV('MV_PROGEN',,''),Len(SB1->B1_COD))
	Local cDbType		:= TCGetDB()
	Local cFNull		:= ""
	Local cAliasTMP	:= GetNextAlias()
	Local aCposNum	:= {}
	Local nI			:= 0
	Default cLotNFc	:= ""
	Default cNFCol	:= ""
	Default cSerCol	:= ""

	//-- Campos NumÈricos Para FormataÁ„o Na Query
	aAdd( aCposNum , "DT5_KM"     )
	aAdd( aCposNum , "DTC_BASSEG" )
	aAdd( aCposNum , "DTC_KM"     )
	aAdd( aCposNum , "DTC_METRO3" )
	aAdd( aCposNum , "DTC_PESO"   )
	aAdd( aCposNum , "DTC_PESOM3" )
	aAdd( aCposNum , "DTC_QTDUNI" )
	aAdd( aCposNum , "DTC_QTDVOL" )
	aAdd( aCposNum , "DTC_VALOR"  )
	aAdd( aCposNum , "DUA_BASOCO" )
	aAdd( aCposNum , "DUA_MT3OCO" )
	aAdd( aCposNum , "DUA_PESOCO" )
	aAdd( aCposNum , "DUA_PM3OCO" )
	aAdd( aCposNum , "DUA_QTDOCO" )
	aAdd( aCposNum , "DUA_QTUOCO" )
	aAdd( aCposNum , "DUA_VLROCO" )
	aAdd( aCposNum , "DUM_BASSEG" )
	aAdd( aCposNum , "DUM_METRO3" )
	aAdd( aCposNum , "DUM_PESO"   )
	aAdd( aCposNum , "DUM_PESOM3" )
	aAdd( aCposNum , "DUM_QTDUNI" )
	aAdd( aCposNum , "DUM_QTDVOL" )
	aAdd( aCposNum , "DUM_VALMER" )

	// Tratamento para ISNULL em diferentes BD's
	Do Case
	Case cDbType $ "DB2/POSTGRES"
		cFNull	:= "COALESCE"
	Case cDbType $ "ORACLE/INFORMIX"
		cFNull	:= "NVL"
	Otherwise
		cFNull	:= "ISNULL"
	EndCase

	cQuery += " SELECT      DT5.DT5_FILIAL, "
	cQuery += "             DT5.DT5_FILORI, "
	cQuery += "             DUD.DUD_LOTE, "
	cQuery += "             DT5.DT5_NUMSOL, "
	cQuery += "             DT5.DT5_DOC, "
	cQuery += "             DT5.DT5_SERIE, "
	cQuery += "             " + cFNull + "(DTC.DTC_NUMSOL,'')       DTC_NUMSOL, "
	cQuery += "             '" + cProGen + "'                       CODPRO, "

    //-- 01 - Base Risco Rodovi·rio
	cQuery += "             " + cFNull + "(DUA.DUA_BASOCO,0)        DUA_BASOCO, "
	cQuery += "             SUM(DUM.DUM_BASSEG)                     DUM_BASSEG, "
	cQuery += "             " + cFNull + "(DTC.DTC_BASSEG,0)        DTC_BASSEG, "

    //-- 02 - Quantidade Unitizador
	cQuery += "             " + cFNull + "(DUA_QTUOCO,0)            DUA_QTUOCO, "
	cQuery += "             SUM(DUM.DUM_QTDUNI)                     DUM_QTDUNI, "
	cQuery += "             " + cFNull + "(DTC.DTC_QTDUNI,0)        DTC_QTDUNI, "

    //-- 04 - Dist‚ncia Km
	cQuery += "             " + cFNull + "(DT5.DT5_KM,0)            DT5_KM, "
	cQuery += "             " + cFNull + "(DTC.DTC_KM,0)            DTC_KM, "

    //-- 05 - Peso M3
	cQuery += "             " + cFNull + "(DUA.DUA_MT3OCO,0)        DUA_MT3OCO, "
	cQuery += "             SUM(DUM.DUM_METRO3)                     DUM_METRO3, "
	cQuery += "             " + cFNull + "(DTC_METRO3,0)            DTC_METRO3, "

    //-- 06 - Peso
	cQuery += "             " + cFNull + "(DUA.DUA_PESOCO,0)        DUA_PESOCO, "
	cQuery += "             SUM(DUM.DUM_PESO)                       DUM_PESO, "
	cQuery += "             " + cFNull + "(DTC.DTC_PESO,0)          DTC_PESO, "

    //-- 07 - Peso Cubado
	cQuery += "             " + cFNull + "(DUA.DUA_PM3OCO,0)        DUA_PM3OCO, "
	cQuery += "             SUM(DUM.DUM_PESOM3)                     DUM_PESOM3, "
	cQuery += "             " + cFNull + "(DTC.DTC_PESOM3,0)        DTC_PESOM3, "

    //-- 08 - Quantidade Volumes
	cQuery += "             " + cFNull + "(DUA.DUA_QTDOCO,0)        DUA_QTDOCO, "
	cQuery += "             SUM(DUM.DUM_QTDVOL)                     DUM_QTDVOL, "
	cQuery += "             " + cFNull + "(DTC.DTC_QTDVOL,0)        DTC_QTDVOL, "

    //-- 09 - Valor
	cQuery += "             " + cFNull + "(DUA.DUA_VLROCO,0)        DUA_VLROCO, "
	cQuery += "             SUM(DUM.DUM_VALMER)                     DUM_VALMER, "
	cQuery += "             " + cFNull + "(DTC.DTC_VALOR,0)         DTC_VALOR "

	cQuery += " FROM "  		+ RetSqlName("DUD") + " DUD "

	cQuery += " INNER JOIN  " + RetSqlName("DT5") + " DT5 "
	cQuery += " ON 			DT5.DT5_FILIAL 	=  '" + FWxFilial("DT5") + "'"
	cQuery += " AND 			DT5.DT5_FILDOC 	=  DUD.DUD_FILDOC
	cQuery += " AND 			DT5.DT5_DOC    	=  DUD.DUD_DOC
	cQuery += " AND 			DT5.DT5_SERIE  	=  DUD.DUD_SERIE

	//-- Filtra Por NF Quando Informado
	If !Empty( cNFCol + cSerCol )
		cQuery += " AND         DT5.DT5_DOC    =  '" + cNFCol   + "' "
		cQuery += " AND         DT5.DT5_SERIE  =  '" + cSerCol  + "' "
	EndIf

	cQuery += " AND         DT5.D_E_L_E_T_ =  ' ' "

	cQuery += " INNER JOIN  " + RetSqlName("DUM") + " DUM "
	cQuery += " ON          DUM.DUM_FILIAL =  '" + FWxFilial("DUM") + "' "
	cQuery += " AND         DUM.DUM_FILORI =  DT5.DT5_FILORI "
	cQuery += " AND         DUM.DUM_NUMSOL =  DT5.DT5_NUMSOL "
	cQuery += " AND         DUM.D_E_L_E_T_ =  ' '

	cQuery += " LEFT JOIN   " + RetSqlName("DTC") + " DTC "
	cQuery += " ON          DTC.DTC_FILIAL =  '" + FWxFilial("DTC") + "' "
	cQuery += " AND         DTC.DTC_NUMSOL =  DT5.DT5_NUMSOL "
	cQuery += " AND         DTC.DTC_CODPRO =  DUM.DUM_CODPRO "
	cQuery += " AND         DTC.DTC_NUMSOL <> '" + Space(TamSX3("DTC_NUMSOL")[1]) + "' "
	cQuery += " AND         DTC.D_E_L_E_T_ =  ' ' "

	cQuery += " LEFT JOIN   " + RetSqlName("DUA") + " DUA "
	cQuery += " ON          DUA.DUA_FILIAL =  '" + FWxFilial("DUA") + "' "
	cQuery += " AND         DUA.DUA_FILDOC =  DT5.DT5_FILDOC "
	cQuery += " AND         DUA.DUA_DOC    =  DT5.DT5_DOC "
	cQuery += " AND         DUA.DUA_SERIE  =  DT5.DT5_SERIE "
	cQuery += " AND         DUA.D_E_L_E_T_ =  ' ' "

	cQuery += " LEFT JOIN   " + RetSqlName("DT2") + " DT2 "
	cQuery += " ON          DT2.DT2_FILIAL =  '" + FWxFilial("DT2") + "' "
	cQuery += " AND         DT2.DT2_CODOCO =  DUA.DUA_CODOCO "
	cQuery += " AND         DT2.D_E_L_E_T_ =  ' ' "

	cQuery += " WHERE 			DUD.DUD_FILIAL 	=  '" + FWxFilial("DUD") + "'"
	cQuery += " AND 				DUD.DUD_FILORI 	=  '" + cFilAnt + "'"
	cQuery += " AND 				DUD.DUD_LOTE   	=  '" + cLotNfc + "'"
	If IsInCallStack("TMSA340GRV")
		cQuery += " AND                 DUD.DUD_VIAGEM  =  '" + DTQ->DTQ_VIAGEM + "'"
	EndIf
	cQuery += " AND 				DUD.D_E_L_E_T_	=  ' ' "

	cQuery += " GROUP BY    DT5.DT5_FILIAL, "
	cQuery += "             DT5.DT5_FILORI, "
	cQuery += "             DUD.DUD_LOTE, "
	cQuery += "             DT5.DT5_NUMSOL, "
	cQuery += "             DT5.DT5_DOC, "
	cQuery += "             DT5.DT5_SERIE, "
	cQuery += "             DUA.DUA_BASOCO, "
	cQuery += "             DTC.DTC_BASSEG, "
	cQuery += "             DUA.DUA_QTUOCO, "
	cQuery += "             DTC.DTC_QTDUNI, "
	cQuery += "             DTC.DTC_NUMSOL, "
	cQuery += "             DT5.DT5_KM, "
	cQuery += "             DTC.DTC_KM, "
	cQuery += "             DUA.DUA_MT3OCO, "
	cQuery += "             DTC.DTC_METRO3, "
	cQuery += "             DUA.DUA_PESOCO, "
	cQuery += "             DTC.DTC_PESO, "
	cQuery += "             DUA.DUA_PM3OCO, "
	cQuery += "             DTC.DTC_PESOM3, "
	cQuery += "             DUA.DUA_QTDOCO, "
	cQuery += "             DTC.DTC_QTDVOL, "
	cQuery += "             DUA.DUA_VLROCO, "
	cQuery += "             DTC.DTC_VALOR "

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTMP)

	//-- Formata Campos NumÈricos Conforme Dicion·rio De Dados
	For nI := 1 To Len(aCposNum)
		TCSetField( cAliasTMP , aCposNum[nI] , "N" , TamSx3(aCposNum[nI])[1] , TamSx3(aCposNum[nI])[2]	)
	Next nI

	If Select(cAliasTMP) > 0
		DbSelectArea( cAliasTMP )
		(cAliasTMP)->(DbGoTop())
	EndIf

	ResetArr(@aCposNum)

	RestArea( aArea )

Return( cAliasTMP )
//-------------------------------------------------------------------------------------------------
/*/{Protheus.doc} TMSA200Fmt()
@autor		: Eduardo Alberti
@descricao	: Formata Vetor De Mensagens De Bloqueios Do RRE
@since		: Apr./2015
@using		: RRE - Regras De RestriÁ„o De Embarque
@review	:

Argumentos	:
/*/
//-------------------------------------------------------------------------------------------------
Static Function TMSA200Fmt(aVetBlqRRE)

Local aArea    := GetArea()
Local aArSB1   := SB1->(GetArea())
Local aGrdRet  := {}
Local nX       := 0
Local nY       := 0
Local nZ       := 0
Local cNfs     := ""
Local cGrupo   := ""

// Mover este Bloco Para Nova FunÁ„o
For nX := 1 To Len(aVetBlqRRE)

	// Informa Sequencia De GeraÁ„o e Lote
	aAdd(aGrdRet,{aVetBlqRRE[nX,1],STR0006 + aVetBlqRRE[nX,3]}) // "Lote: "
	//aAdd(aGrdRet,{"      ","BLOQUEIOS:"})

	// Informa Erros Encontrados
	For nY := 1 To Len(aVetBlqRRE[nX,4])
		aAdd(aGrdRet,{"Bloq." + StrZero(nY,3) , aVetBlqRRE[nX,4,nY,6] })
	Next nY

	// Adiciona Linha Em Branco
	aAdd(aGrdRet,{"",""})

	// Informa NFs Contidas Na Rotina
	For nY := 1 To Len(aVetBlqRRE[nX,5])

		For nZ := 1 To Len(aVetBlqRRE[nX,5,nY,10])
			If ValType(aVetBlqRRE[nX,5,nY,10,nZ]) == "A"
				cNfs += Iif(!Empty(cNfs),",","") + aVetBlqRRE[nX,5,nY,10,nZ,1] + "/" + aVetBlqRRE[nX,5,nY,10,nZ,2]
			ElseIf ValType(aVetBlqRRE[nX,5,nY,10,nZ]) == "C"
				cNfs += Iif(!Empty(cNfs),",","") + aVetBlqRRE[nX,5,nY,10,1] + "/" + aVetBlqRRE[nX,5,nY,10,2]
				Exit
			EndIf
		Next nZ

		DbSelectArea("SB1")
		DbSetOrder(1)
		MsSeek(xFilial("SB1") + aVetBlqRRE[nX,5,nY,3] ,.F.)

		cGrupo := Iif(!Empty(SB1->B1_GRUPO),SB1->B1_GRUPO,Space(TamSX3("B1_GRUPO")[1]+2))

		aAdd(aGrdRet,{"",	STR0021 	+ aVetBlqRRE[nX,5,nY,3] 																		+; // "Produto: "
							Space(5) + " " + STR0142 + cGrupo 																		+; // " Grupo: "
							Space(5) + " " + STR0143 + StrZero(aVetBlqRRE[nX,5,nY,4],TamSX3("DTC_QTDVOL")[1])				+; // " Qtd Vol: "
							Space(5) + " " + STR0144 + Transform(aVetBlqRRE[nX,5,nY,5],PesqPict("DTC","DTC_PESO")) 			+; // " Peso: "
							Space(5) + " " + STR0145 + Transform(aVetBlqRRE[nX,5,nY,6],PesqPict("DTC","DTC_PESOM3")) 		+; // " Peso Cub: "
							Space(5) + " " + STR0146 + Transform(aVetBlqRRE[nX,5,nY,7],PesqPict("DTC","DTC_VALOR")) 		+; // " Valor: "
							Space(5) + " " + STR0147 + cNfs																			}) // " NFs Relacionadas: "

		cNfs := ""

	Next nY

	// Adiciona Linha Em Branco
	aAdd(aGrdRet,{"",""})
	aAdd(aGrdRet,{"",""})

Next nX

RestArea(aArSB1)
RestArea(aArea)

Return(aGrdRet)
//-------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Tmsa200nRe()
@autor		: Eduardo Alberti
@descricao	: Monta Dialog Com Motivos De Bloqueios Do RRE
@since		: Apr./2015
@using		: RRE - Regras De RestriÁ„o De Embarque
@review	:

Argumentos	:
/*/
//-------------------------------------------------------------------------------------------------
Static Function Tmsa200nRe(aVetMsgRRE,aVetMsgDVP)

Local aArea 		:= GetArea()
Local aArSB1		:= SB1->(GetArea())
Local oDlg    		:= Nil
Local oRestr  		:= Nil
Local aListTot  	:= {}
Local aCoordenadas	:= MsAdvSize(.T.)
Local lOpcClick 	:= .F.
Local aButtons		:= {}
Local aGrdRet		:= {}
Local cTitulo		:= STR0148  		//-- "Detalhes Dos Bloqueios "
Local aCab			:= { STR0149 , STR0150 } 	//-- "Sequencia" , "Detalhes"
Local nX			:= 0
Local nY 			:= 0
Local nZ			:= 0
Local cNfs			:= ""

Default aVetMsgRRE   := {}
Default aVetMsgDVP   := {}

SaveInter()

If Len(aVetMsgRRE) > 0
	aAdd( aGrdRet, {"",STR0151}) //-- "Detalhes"
EndIf

For nX := 1 To Len(aVetMsgRRE)
	For nY := 1 To Len(aVetMsgRRE[nX])
		aAdd( aGrdRet,{aVetMsgRRE[nX,nY,01],aVetMsgRRE[nX,nY,02]})
	Next nY
Next nX

If Len(aVetMsgDVP) > 0
	aAdd( aGrdRet, {"",STR0152}) //-- "DivergÍncias de Produtos"
EndIf

For nX := 1 To Len(aVetMsgDVP)
	aAdd( aGrdRet,{aVetMsgDVP[nX,01],aVetMsgDVP[nX,02]})
Next nX

oDlg   				:= TDialog():New(000,000,aCoordenadas[6],aCoordenadas[5],OemToAnsi(cTitulo ),,,,,,,,oMainWnd,.T.)				// Tela Inteira
//oDlg 				:= TDialog():New(000,000,aCoordenadas[6]/1.5,aCoordenadas[5]/1.5,OemToAnsi(cTitulo ),,,,,,,,oMainWnd,.T.) 	// Tela Menor
oRestr 				:= TWBrowse():New(035,003,oDlg:nClientWidth/2-5,oDlg:nClientHeight/2-45,,aCab,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
//oRestr:lHScroll		:= .F. // Indica se habilita(.T.)/desabilita (.F.) a barra de rolagem horizontal.
//oRestr:lVScroll		:= .F. // Indica se habilita(.T.)/desabilita (.F.) a barra de rolagem vertical.

oRestr:SetArray(aGrdRet)

oRestr:bLine := {||{;
aGrdRet[oRestr:nAt][01],;
aGrdRet[oRestr:nAt][02]}}

Activate MsDialog oDlg On Init EnchoiceBar(oDlg,/*bOk*/ {|| lOpcClick := .t., oDlg:End()} ,/*bCancel*/ {|| oDlg:End() },/*lMsgDel*/,aButtons,/*nRecno*/,/*cAlias*/,/*lMashups*/,/*lImpCad*/,.f. /*lPadrao*/,.f. /*lHasOk*/,/*lWalkThru*/,/*cProfileID*/)

RestInter()

ResetArr(@aButtons			)
ResetArr(@aGrdRet			)

RestArea(aArSB1)
RestArea(aArea)

Return(lOpcClick)

//-------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Tmsa200iDP()
@autor		: Eduardo Alberti
@descricao	: Retorna NFs Dentro De Lote Cujo Produto Exista
@since		: Apr./2015
@using		: RRE - Regras De RestriÁ„o De Embarque e Diverg. Produtos
@review	:

Argumentos	:
/*/
//-------------------------------------------------------------------------------------------------
Static Function Tmsa200iDP( cProd , aPrdDPDet ) //-- Tmsa200iDP( aPrdDP[nX,01], aPrdDPDet )

Local cRet  := ""
Local nA    := 0
Local nB    := 0
Local nPos  := 0

For nA := 1 To Len(aPrdDPDet)

	If aPrdDPDet[nA,01] == cProd

		cRet += Iif(Empty(cRet),"",",") + aPrdDPDet[nA,02] + "/" + aPrdDPDet[nA,03]

	EndIf
Next nA

Return(cRet)
//-------------------------------------------------------------------------------------------------
/*/{Protheus.doc} TmsRatHer()
@autor		: Katia
@descricao	: Retorna o vetor aFrete com os valor rateado do componente 16-Herda Valor
@since		: Maio/2016
@using		: RATEIO
@review	:

Argumentos	:
/*/
//-------------------------------------------------------------------------------------------------

Static Function TmsRatHer(aFrete,aFreteCol,n2Cnt,cCRDVHV,cNumSol,nPesAgr,nPe3Agr,nValAgr,nQtdAgr,nMe3Agr)
Local nPos     := 0
Local nCRDVHV := 0
Local nValFre  := 0
Local nBaseRat := 0
Local lQtdDocT := .F.
Local nBaseNf  := 0
Local nCount1  := 0
Local aCRDVHV  := {}

//----Exemplo do Rateio Herda Valor
//--- Valor da Coleta 000001 = 150,00
//--- DTC_NUMNFC- 010101  DTC_NUMSOL- 000001
//--- DTC_NUMNFC- 020202  DTC_NUMSOL- 000001
//--- DTC_NUMNFC- 030303  DTC_NUMSOL- 000001
//--- Para o componente 16- Herda, o sistema ir· com base no valor da coleta (150,00) ratear entre as NFs vinculadas a SC.
//--- Neste exemplo, cada NF ficara com o componente 16- Herda no valor de 50,00

// O vetor aCRDVHV tem a seguinte estrutura:                       //
// 01 - Codigo do Criterio de Rateio Herda Valor (_CRDVHV)         //
// 02 - Valor Total (100%) utilizado para Rateio/Proporcionar		 //
// 03 - Determinacao por qual Criterio sera executado o Rateio		 //
// 04 - Posicao em que refere-se no vetor aNfCTRC //

Aadd( aCRDVHV, { StrZero(0, Len(DDA->DDA_CRDVHV)), 0, .F., 00 } ) // Nao Utiliza
Aadd( aCRDVHV, { StrZero(1, Len(DDA->DDA_CRDVHV)), 0, .F., 07 } ) // Peso Real
Aadd( aCRDVHV, { StrZero(2, Len(DDA->DDA_CRDVHV)), 0, .F., 08 } ) // Peso Cubado
Aadd( aCRDVHV, { StrZero(3, Len(DDA->DDA_CRDVHV)), 0, .F., 06 } ) // Vlr.Merc
Aadd( aCRDVHV, { StrZero(4, Len(DDA->DDA_CRDVHV)), 0, .F., 05 } ) // Volumes
Aadd( aCRDVHV, { StrZero(5, Len(DDA->DDA_CRDVHV)), 0, .F., 09 } ) // M3
Aadd( aCRDVHV, { StrZero(6, Len(DDA->DDA_CRDVHV)), 0, .F., 99 } ) // Qtd Docto

nPos:= Ascan(aCRDVHV, { |x| x[01] == cCrDvHv })
If nPos > 0
	nCRDVHV:= aCRDVHV[nPos][4]

	//--- Procura a SolicitaÁ„o de Coleta no vetor aFreteCol
	nPos:= Ascan(aFreteCol, {|x| x[2] == cNumSol })

	//--- Busca o valor do componente aFreteCol baseado na Solicitacao de Coleta
	If nPos > 0
		nPos2:= Ascan(aFreteCol[nPos][3], {|x| x[1] == aFrete[ n2Cnt,03 ]  })
		If nPos2 > 0
			nValFre:= aFreteCol[nPos][3][nPos2][2]
		EndIf

		//--- Soma a base para Rateio
		nBaseRat:= 0
		If nCRDVHV == 99
			nBaseRat:= Len(aFreteCol[nPos][4])
			lQtdDocT:= .T.
		Else
			For nCount1:= 1 To Len(aFreteCol[nPos][4])
				nBaseRat+= aFreteCol[nPos][4][nCount1][nCRDVHV]
			Next nCount1
		EndIf

		//---- Busca a base referente ao Criterio de Rateio
		nBaseNf:=0
		If cCRDVHV == '1'      //Peso Real
			nBaseNf:= nPesAgr
		ElseIf cCRDVHV == '2'  //Peso Cubado
			nBaseNf:= nPe3Agr
		ElseIf cCRDVHV == '3'  //Vlr. Mercadoria
			nBaseNf:= nValAgr
		ElseIf cCRDVHV == '4'  //Volumes
			nBaseNf:= nQtdAgr
		ElseIf cCRDVHV == '5'	//M3
			nBaseNf:= nMe3Agr
		EndIf

	EndIf
EndIf

aFrete[ n2Cnt, 2 ] := Iif(lQtdDocT, Round( nValFre / nBaseRat , 2), Round(( nBaseNf / nBaseRat ) * nValFre, 2)  )
aFrete[ n2Cnt, 21 ]:= Iif(lQtdDocT, Round(((nValFre / nBaseRat) / nValFre) * 100, 2),;
							Round(nBaseNf / nBaseRat * 100, 2))// % Rateio

ResetArr(@aCRDVHV)
Return Nil

//-------------------------------------------------------------------------
/*/{Protheus.doc} Tmsa200Gpv
Rotina Que Verifica Se Tela De Preview Do C·lculo Do Frete Deve Ser Mostrada

@author Eduardo Alberti
@since 22/Sep/2016
@version P12.1.15
/*/
//-------------------------------------------------------------------------
Static Function Tmsa200Gpv()

	Local lRet       := .t.
	Local nX         := 0
	Local aNoPreview := {}

	//-- Carrega Perguntas Do TMSA200
	Pergunte("TMB200", .F. )

	//-- Verifica Se Parametro 8 Existe e Se È NumÈrico
	If Type("MV_PAR10") <> "U" .And. ValType(MV_PAR10) == "N"

		//-- Se Estiver Configurado Para Gerar Preview, Verifica Se N„o Est· Sendo Chamado Por Rotinas Que N„o Podem Apresent·-lo

		If MV_PAR10 == 1 //-- Gera Preview

			//-- Cria Vetor Das Rotinas Que N„o Devem Mostrar Preview Do C·lc. Frete
			aAdd( aNoPreview, "TMSA500"   )	//-- Manutencao de documentos
			aAdd( aNoPreview, "TMSA500MNT")	//-- Manutencao de documentos (AtualizaÁıes)
			aAdd( aNoPreview, "TMSA491"   )	//-- GeraÁ„o Faturas Autom.
			aAdd( aNoPreview, "TMSA491MNT")	//-- GeraÁ„o Faturas Autom. (AtualizaÁıes)
			aAdd( aNoPreview, "TMSAE75"   )	//-- EDI - Notas Fiscais Importadas - Automatico
			aAdd( aNoPreview, "TMSA310"   )	//-- Fechamento da viagem
			aAdd( aNoPreview, "TMSA310MNT")	//-- Fechamento da viagem
			aAdd( aNoPreview, "TMSA340"   )	//-- Encerramento da viagem
			aAdd( aNoPreview, "TMSA340MNT")	//-- Encerramento da viagem
			aAdd( aNoPreview, "TMSA340GRV")	//-- Encerramento da viagem

			For nX := 1 To Len(aNoPreview)
				//-- Se Rotina Estiver Na Pilha De Chamada N„o Permite o Preview
				If IsInCallStack( aNoPreview[nX] )
					lRet := .f.
					Exit
				EndIf
			Next nX
		Else
			lRet := .f.
		EndIf
	EndIf

Return(lRet)

//-------------------------------------------------------------------------
/*/{Protheus.doc} Tmsa200VPr
Rotina Para Montagem Do Vetor De GeraÁ„o Do Preview

@author Eduardo Alberti
@since 22/Sep/2016
@version P12.1.15
/*/
//-------------------------------------------------------------------------
Static Function Tmsa200VPr(	aPreview, lContinua, aFrete, aDocumento, nCntFor, cCliDev, cLojDev, cCodPro, nQtdVol, nPeso, nPesoM3, nPesoCob, nValor, aPrm200THR, aJobThr, cJobThr, cJobFile, nCountThr, nQtdMnt, nThreads, nProcReg, aVisErr, lThread, nCont1, nQtdDef, nQtdDif, lFim1, lFim2, nQtdRst )

	Local aArea    := GetArea()
	Local aFrt     := {}
	Local aPvw     := {}
	Local nCont    := 0
	Local nVfret   := 0
	Local nVImpo   := 0
	Local nVTot    := 0
	Local lAgrupaNF:= .T.
	Local aRegra   := {}
	Local lRegPorComp := .F.
	Local lConsig     := .F.
	Default aPreview  := {}
	Default lContinua := .t.
	Default aFrete    := {}
	Default aDocumento:= {}
	Default nCntFor   := 0
	Default cCliDev   := ""
	Default cLojDev   := ""
	Default cCodPro   := ""
	Default nQtdVol   := 0
	Default nPeso     := 0
	Default nPesoM3   := 0
	Default nPesoCob  := 0
	Default nValor    := 0
	Default aPrm200THR:= {}
	Default aJobThr   := {}
	Default cJobThr   := ""
	Default cJobFile  := ""
	Default nCountThr := 0
	Default nQtdMnt   := 0
	Default nThreads  := 0
	Default nProcReg  := 0
	Default aVisErr   := {}
	Default lThread   := .f.
	Default nCont1    := 0
	Default nQtdDef   := 0
	Default nQtdDif   := 0
	Default lFim1     := .F.
	Default lFim2     := .F.
	Default nQtdRst   := 0

	For nCont := 1 To Len(aFrete)
		If aFrete[nCont,2] > 0
			AAdd( aFrt, aClone(aFrete[nCont]) )
		EndIf
	Next

	//-- Calcula imposto
	TmsA040Imp(aFrt,cCliDev,cLojDev,aDocumento[nCntFor,10,3],aDocumento[nCntFor,10,4],aDocumento[nCntFor,10,31],.T.,,,Posicione("SA1",1,xFilial("SA1")+aDocumento[nCntFor,4]+aDocumento[nCntFor,5],"A1_TIPO");
		       ,,aDocumento[nCntFor,10,23],,Iif(Posicione("SA1",1,xFilial("SA1")+cCliDev+cLojDev,"A1_INCISS") == "S","S","N"),aDocumento[nCntFor,10,18],aDocumento[nCntFor,10,19],;
		       aDocumento[nCntFor,4],aDocumento[nCntFor,5],,,aDocumento[nCntFor,12],cCodPro,,,,,aDocumento[nCntFor,10,24], aDocumento[nCntFor,10,25] )

	aEval(aFrt,{|x| nVfret += x[2],nVImpo += x[5],nVTot += x[6]} )

	//-- Verifica se agrupa nf no calculo do frete
	lAgrupaNF := (aDocumento[nCntFor,10, 39] == "1")

	aAdd(aPvw,{;	
					aDocumento[nCntFor,6],;		//-- [01] Devedor
					aDocumento[nCntFor,7],;		//-- [02] Loja devedor
					Posicione("SA1",1,xFilial("SA1")+aDocumento[nCntFor,6]+aDocumento[nCntFor,7],"A1_NOME"),;	//-- [03] Nome devedor
					nQtdVol,;          		//-- [04] Volume original
					nQtdVol,;               	//-- [05] Quantidade de volumes
					nPeso,;					//-- [06] Peso
					nPesoM3,;					//-- [07] Peso cubado
					nPesoCob,;					//-- [08] Peso cobrado
					nValor,;					//-- [09] Valor da mercadoria
					aDocumento[nCntFor,10,28],;	//-- [10] Tabela de frete
					aDocumento[nCntFor,10,29],;	//-- [11] Tipo tabela de frete
					aDocumento[nCntFor,10,30],;	//-- [12] Sequancia tabela de frete
					nVfret,;					//-- [13] Valor do frete
					nVImpo,;					//-- [14] Valor imposto
					nVTot,;						//-- [15] Valor total
					aDocumento[nCntFor,10,18],;	//-- [16] Remetente
					aDocumento[nCntFor,10,19],;	//-- [17] Loja remetente
					Posicione("SA1",1,xFilial("SA1")+aDocumento[nCntFor,10,18]+aDocumento[nCntFor,10,19],"A1_NOME"),;	//-- [18] Nome Remetente
					aDocumento[nCntFor,4],;		//-- [19] Destinatario
					aDocumento[nCntFor,5],;		//-- [20] Loja destinatario
					Posicione("SA1",1,xFilial("SA1")+aDocumento[nCntFor,4]+aDocumento[nCntFor,5],"A1_NOME"),;	//-- [21] Nome destinatario
					aDocumento[nCntFor,24],;		//-- [22] CDR Origem
					aDocumento[nCntFor,25],;		//-- [23] CDR C·lculo
					aDocumento[nCntFor,31],;		//-- [24] Cod. NegociaÁ„o
					aDocumento[nCntFor,01],;		//-- [25] ServiÁo
					aDocumento[nCntFor,10,32],;  	//-- [26] Contrato						
					aDocumento[nCntFor,10,3],;   	//-- [27] Doc.TMS
					aDocumento[nCntFor,10,4],;      //-- [28] Tipo Frete
					lConsig,;                       //-- [29] tem Consignatario?
					aDocumento[nCntFor,12]		})  //-- [30] Tipo NFC

	//-- Armazena quebra no vetor aPreview
	aAdd(aPreview,{aClone(aPrm200THR),aJobThr,cJobThr,cJobFile,cCliDev,cLojDev,nCountThr,nQtdMnt,nThreads,nProcReg,aVisErr,lThread, aClone(aPvw) ,.T., aClone( aFrt) ,nCont1, nQtdDef, nQtdDif, lFim1, lFim2, nQtdRst})

	ResetArr(@aPrm200THR )
	ResetArr(@aFrt     )
	ResetArr(@aPvw     )

	aPrm200THR := {}

	RestArea(aArea)

Return(aPreview)
//-------------------------------------------------------------------------------------------------
/*/{Protheus.doc} TmsaExCd1P(cRecno)
@autor		: Aluizio Fernando Habizenreuter
@descricao	: Valida se o documento teve cidade de 1∫ Percurso informada.
@since		: Dez./2016
@using		:
@review	:

Argumentos	:
/*/
//-------------------------------------------------------------------------------------------------
Static Function TmsaExCd1P(nRecno)
Local lRet    		:= .F.
Local cAliasCd1P 	:= ""
Local aAreaDTC   	:= DTC->(GetArea())

//A funÁ„o valida se foi informada cidade de 1∫ Percurso para algum documento relacionado ao Lote.
cAliasCd1P := GetNextAlias()
cQuery := " SELECT DTC.DTC_NUMNFC "
cQuery +=   " FROM " + RetSqlName("DTC") + " DTC, " + RetSqlName("DTP") + " DTP "
cQuery +=  " WHERE DTP.DTP_FILIAL = '" + xFilial('DTP') + "' "
cQuery +=    " AND DTP.R_E_C_N_O_ = '" + cValToChar(nRecno) + "' "
cQuery +=    " AND DTP.D_E_L_E_T_ = ' ' "
cQuery +=    " AND DTC.DTC_FILIAL = DTP.DTP_FILIAL "
cQuery +=    " AND DTC.DTC_LOTNFC = DTP.DTP_LOTNFC "
cQuery +=    " AND DTC.DTC_CDRPER <> ' ' "
cQuery +=    " AND DTC.D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCd1P)
If (cAliasCd1P)->(!Eof())
	lRet := .T.
EndIf

(cAliasCd1P)->(DbCloseArea())
RestArea(aAreaDTC)

Return lRet

//-------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Tms200MOK()
@autor		: Alex Amaral
@descricao	: Marca OK
@since		: 26/06/2017
@using		: Chamada do PE no estono do documento
@review	:

Argumentos	:
/*/
//-------------------------------------------------------------------------------------------------
Static Function Tms200MOK(aDocExc)

Local lRet 		:= .T.
Local lPETMOK 	:= ExistBlock("TM200MOK")

If lPETMOK
	lRet := ExecBlock("TM200MOK",.F.,.F.,{aDocExc})

	If ValType(lRet) <> "L"
		lRet := .T.
	EndIf
EndIf
Return(lRet)

/*/{Protheus.doc} TMSA200GDC
//TODO DescriÁ„o auto-gerada.
@author tiago.dsantos
@since 02/08/2017
@version undefined
@param cFilori, characters, descricao
@param cLote, characters, descricao
@type function
/*/
Static Function TMSA200GDC(cFilori,cLote)
Local lRet     := .T.
Local aAreas   := { DT5->(GetArea()), DT6->(GetArea()), DTP->(GetArea()) }
Local cDTCAlias := GetNextAlias()

    cQuery := "SELECT DTC.DTC_FILCFS,DTC.DTC_NUMSOL FROM " + RetSQLName("DTC") + " DTC "
    cQuery += " LEFT JOIN " + RetSQLName("DT5") + " DT5 ON "
    cQuery += "       DT5.DT5_FILIAL = '" + xFilial("DT5") + "' "
    cQuery += " AND   DT5.D_E_L_E_T_ = ' ' "
    cQuery += " AND   DT5.DT5_FILDOC = DTC.DTC_FILCFS "
    cQuery += " AND   DT5.DT5_DOC    = DTC.DTC_NUMSOL "
    cQuery += " WHERE DTC.DTC_FILIAL = '" + xFilial("DTC")  + "' "
    cQuery += " AND   DTC.D_E_L_E_T_ = ' ' "
    cQuery += " AND   DTC.DTC_FILORI = '" + cFilori + "' "
    cQuery += " AND   DTC.DTC_LOTNFC = '" + cLote   + "' "
    cQuery += " AND   DTC.DTC_NUMSOL <> ' ' "
    cQuery += " AND   DTC.DTC_DOC <> ' ' "
    cQuery += " AND   DT5.DT5_STATUS = '9' " //| Somente se solicitaÁ„o estiver bloqueada.
    cQuery += " GROUP BY DTC.DTC_FILCFS,DTC.DTC_NUMSOL "

    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cDTCAlias,.F.,.T.)

    While (cDTCAlias)->(!EOF())

        //--posiciona no DT5 e chama rotina de liberaÁ„o do DT5
        DT5->(DbSetOrder(4)) //--DT5_FILIAL+DT5_FILDOC+DT5_DOC+DT5_SERIE
        IF DT5->(MsSeek(xFilial("DT5") + (cDTCAlias)->(DTC_FILCFS+DTC_NUMSOL+"COL")))

               aDUMVlrs := {0,0,0,0,0,0}

               DUM->(dbSetOrder(1))
               If DUM->(MsSeek(xFilial('DUM')+DT5->DT5_FILORI+DT5->DT5_NUMSOL))
                   While DUM->(!Eof()) .And. DUM->DUM_FILIAL + DUM->DUM_FILORI + DUM->DUM_NUMSOL == xFilial('DUM')+DT5->DT5_FILORI+DT5->DT5_NUMSOL
                         aDUMVlrs[1] += DUM->DUM_QTDVOL
                         aDUMVlrs[2] += DUM->DUM_PESO
                         aDUMVlrs[3] += DUM->DUM_PESOM3
                         aDUMVlrs[4] += DUM->DUM_VALMER
                         aDUMVlrs[5] += Iif(DUM->(ColumnPos("DUM_METRO3")) > 0,DUM->DUM_METRO3,0)
						 aDUMVlrs[6] += DUM->DUM_QTDUNI
                         DUM->(DbSkip())
                   EndDo
               EndIf
               
			   TMSA460GDc(aDUMVlrs[1], aDUMVlrs[2], aDUMVlrs[3], aDUMVlrs[4], aDUMVlrs[5],aDUMVlrs[6])

               //-- Ajusta o Status do DT6 relacionado ao DT5 para 9-Cancelado
               DT6->(DbSetOrder(1))//--DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE
               If DT6->(MSSeek(xFilial("DT6") + DT5->(DT5_FILDOC+DT5_DOC+DT5_SERIE)))
                    DT6->(RecLock("DT6",.F.))
                    DT6->DT6_STATUS := "9"
                    DT6->(MSUnlock())
               EndIf

        EndIf

        (cDTCAlias)->(DbSkip())

    EndDo

    (cDTCAlias)->(DbCloseArea())

    AEval(aAreas,{|x,y| RestArea(x) })

Return lRet


/*/{Protheus.doc} TmsSQlExec
//A funÁ„o faz a gravaÁ„o de log utilizando o driver SQLITE - Apenas vers„o 12
@author caio.y
@since 01/09/2017
@version Protheus 12
@param cJobFile, characters, Nome da tabela criada
@param aMsgThread, array, Array de mensagens
@type function
/*/
Static Function TmsSQlExec( cJobFile, aMsgThread , lErrorLog , cJobThr )
Local nCount		:= 1
Local nAux			:= 1
Local cQuery		:= ""
Local cAux			:= ""
Local cObs			:= ""
Local cCodCli		:= ""
Local cLojCli		:= ""
Local lRet			:= .F.

Default cJobFile	:= ""
Default aMsgThread	:= {}
Default lErrorLog	:= .F.
Default cJobThr		:= ""

PutGlbValue( cJobThr , ProcName() + "-" + cValToChar( ProcLine(0)) + "***" + cValToChar(ThreadID())   )

For nCount := 1 To Len(aMsgThread)

	cCodCli		:= ""
	cLojCli		:= ""
	cObs		:= ""

	For nAux := 1 To Len(aMsgThread[nCount])

		If nAux == 1
			cCodCli	:= aMsgThread[nCount][nAux][1]
			cLojCli	:= aMsgThread[nCount][nAux][2]
		ElseIf nAux	> 1
			//-- Caracter utilizado para quebra de linha
			If !Empty(cObs)
				cObs	+= "<#>"
			EndIf

			cObs	+= RTrim( aMsgThread[nCount][nAux][1] )
		EndIf

	Next nAux

	If !Empty(cObs) .And. !Empty(cCodCli)

		cAux	:= "( '"+ cCodCli + "','" + cLojCli + "','"+ cObs + "'  )"

		cQuery	:= " INSERT INTO " + cJobFile
		cQuery	+= " (CLIENTE,LOJA,MEMO) VALUES "
		cQuery	+= cAux
		If DBSqlExec( cJobFile , cQuery , 'SQLITE_SYS')
			lRet	:= .T.
		EndIf

	EndIf

Next nCount

Return lRet
/*/{Protheus.doc} RetJobFree
//TODO DescriÁ„o auto-gerada.
@author caio.y
@since 09/03/2018
@version 1.0
@return ${return}, ${return_description}
@param aJobThr, array, descricao
@type function
/*/
Static Function RetJobFree(aJobThr)
Local cJobThr	:= ""
Local nCount	:= 1
Local cConteudo	:= ""

Default aJobThr		:= {}

For nCount := 1 To Len(aJobThr)

	cJobThr		:= aJobThr[nCount][1]
	cConteudo	:= GetGlbValue(cJobThr)

	If "END" $ cConteudo .Or. Empty( cConteudo )
		Exit
	EndIf

Next nCount

Return cJobThr

/*/{Protheus.doc} RetJobErr
//TODO DescriÁ„o auto-gerada.
@author caio.y
@since 09/03/2018
@version 1.0
@return ${return}, ${return_description}
@param aJobThr, array, descricao
@type function
/*/
Static Function RetJobErr(aJobThr)
Local cError	:= ""
Local nCount	:= 0
Local cJobThr	:= ""
Local cConteudo	:= ""

Default aJobThr	:= {}

For nCount := 1 To Len(aJobThr)

	cJobThr		:= aJobThr[nCount][1]
	cConteudo	:= GetGlbValue(cJobThr)

	If !( "END" $ cConteudo .Or. Empty( cConteudo ) )
		cError	:= cConteudo
		Exit
	Else
		cError	:= ""
	EndIf

	//-- limpa variaveis globais
	ClearGlbValue(cJobThr)

Next nCount

Return

/*/{Protheus.doc} MonitorThg
//TODO DescriÁ„o auto-gerada.
@author caio.y
@since 09/03/2018
@version 1.0
@return ${return}, ${return_description}
@param aJobThr, array, descricao
@type function
/*/
Static Function MonitorThg(aJobThr , cJobFile , lOnlyView)
Local nCount	:= 0
Local cJobThr	:= ""
Local cConteudo	:= ""
Local cAux		:= ""
Local cMsgThg	:= STR0184
Local nAux		:= 1
Local nPos		:= 0
Local nKill		:= 0
Local lKill		:= .F.
Local aUsrArray	:= {}
Local aThreadId	:= {}
Local aAux		:= {}
Local aMsgErr	:= {}

Default aJobThr		:= {}
Default cJobFile	:= ""
Default lOnlyView	:= .T.

For nCount := 1 To Len(aJobThr)
	cJobThr		:= aJobThr[nCount][1]
	cConteudo	:= GetGlbValue(cJobThr)
	nAux		:= 1
	IncProc( cMsgThg + cJobThr ) //-- Monitoramento da thread

	If !Empty(cConteudo) .And. !( "END" $ cConteudo )

		For nAux := 1 To NTRYMAX
			cConteudo	:= GetGlbValue(cJobThr)

			If nAux == 200
				IncProc( cMsgThg + cJobThr + " - " + cConteudo )
			ElseIf nAux == 400
				IncProc( cMsgThg + cJobThr + " - " + cConteudo )
			ElseIf nAux == 600
				IncProc( cMsgThg + cJobThr + " - " + cConteudo )
			ElseIf nAux == 800
				IncProc( cMsgThg + cJobThr + " - " + cConteudo )
			ElseIf nAux == NTRYMAX
				IncProc( cMsgThg + cJobThr + " - " + cConteudo )
			EndIf

			If Empty(cConteudo) .Or. ( "BEGIN" $ cConteudo ) .Or. ( "EXIT" $ cConteudo )
				Exit

			ElseIf nAux == NTRYMAX
				cAux	:= RTrim( SubStr( cConteudo ,  At("***" ,  cConteudo )  )  )
				cAux	:= StrTran(cAux,"***","")

				Aadd( aThreadId , { cAux , cConteudo })

				lKill	:= .T.
			EndIf

			Sleep(90)

		Next nAux

	ElseIf Empty(cConteudo)
		cAux	:= RTrim( SubStr( cConteudo ,  At("***" ,  cConteudo )  )  )
		cAux	:= StrTran(cAux,"***","")

		Aadd( aThreadId , { cAux , cConteudo })

		lKill	:= .T.
	EndIf

Next nCount


If lKill .And. !lOnlyView

	aUsrArray	:= GetUserInfoArray()
	For nCount := 1 to Len(aThreadId)

		nKill++
		cAux	:= aThreadID[nCount][1]
		nPos	:= aScan( aUsrArray , {|x| x[3] == Val(cAux) } )

		ConOut("---------------------------------------------------------------------------")
		ConOut("[THREAD ERROR][TMSA200][MONITORTHG]")
		ConOut("THREADID: " + cAux )
		ConOut("DATE: " + DToS(dDataBase) + " - " + Time())
		ConOut("USER: " + __cUserId  )
		ConOut(aThreadID[nCount][2])

		IncProc( STR0187 + cAux +  STR0188 ) //-- Derrubando thread XPTO por inatividade

		Aadd(aAux , { "[THREAD ERROR][TMSA200][MONITORTHG]",cAux })

		If nPos > 0
			ConOut( STR0189 )	//-- "Looping dentro da rotina : "
			Aadd(aAux , { STR0189 + aThreadID[nCount][2] })	 //-- "Looping dentro da rotina : "

			//-- Mata a thread
			KillUser( aUsrArray[nPos][1],  aUsrArray[nPos][2],  aUsrArray[nPos][3], Iif( !Empty( aUsrArray[nPos][4] ) , aUsrArray[nPos][4] , GetComputerName() )  )

		Else
			Aadd(aAux , { STR0190 + aThreadID[nCount][2]  } ) //-- "Error log na rotina: "
			ConOut( STR0190 ) //-- "Error log na rotina: "
		EndIf

		ConOut("---------------------------------------------------------------------------")

	Next nCount

	Aadd(aMsgErr, aClone( aAux ) )
	TmsSQlExec( cJobFile, aMsgErr )

EndIf

Return nKill


/*/{Protheus.doc} ResetArr
//TODO DescriÁ„o auto-gerada.
@author caio.y
@since 11/04/2018
@version 1.0
@return ${return}, ${return_description}
@param aAux, array, descricao
@type function
/*/
Static Function ResetArr(aAux , lOnlySize )

Default aAux		:= {}
Default lOnlySize	:= .F.

aSize(aAux,0)

If !lOnlySize
	aAux	:= Nil
Else
	aAux	:= {}
EndIf

Return

/*/{Protheus.doc} A200ClrVar
//TODO FunÁ„o que realiza o reset de arrays est·ticos e privates
@author caio.y
@since 17/04/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function A200ClrVar()

//-- Limpa cache TMSXFUNB
If FindFunction("TMSFUNBClr")
	TMSFUNBClr("ADT3CALC")
	TMSFUNBClr("ATMSPERFIL")
EndIf

//-- Limpa cache TMSXFUNA
If FindFunction("TMSFUNAClr")
	TMSFUNAClr("ATMSCONTRAT")
	TMSFUNAClr("ATMSTABELA")
	TMSFUNAClr("ATMSADDREG")
	TMSFUNAClr("ATMSNIVSUP")
EndIf

//-- Limpa variaveis privates
If Type("aLOTE") <> 'U'
	ResetArr(@aLote)
EndIf

If Type("aDocto") <> 'U'
	ResetArr(@aDocto)
EndIf

If Type("aDelDocto") <> 'U'
	ResetArr(@aDelDocto)
EndIf


Return

/*/{Protheus.doc} TM200VlCmp
Rotina para validaÁ„o dos documentos que poder„o ser estornados
@author Valdemar Roberto Mognon
@since 19/03/2019
@version 1.0
@return Logico
@param 
@type function
/*/
Function TM200VlCmp(aMsgErr,lMostra,nLinDoc,lOcoNfc,l200Marca)
Local aAreaDFV   := DFV->(GetArea())
Local aAreaSF3   := SF3->(GetArea())
Local aAreaSF2   := SF2->(GetArea())
Local aAreaSE1   := SE1->(GetArea())
Local aAreaDTC   := DTC->(GetArea())
Local aPerfil    := {}
Local cTMSMFat   := GetMV("MV_TMSMFAT",,"")	//-- Modo de Faturamento:1-Faturamento a partir do SE1;2=Faturamento a partir do DT6
Local cFilSF2    := ""
Local cFilSE1    := ""
Local cPrefixo   := ""
Local cMV1DUPREF := GETMV("MV_1DUPREF")
Local lTMSCTe    := SuperGetMv("MV_TMSCTE",.F.,.F.) //-- Parametro do CT-e ativo.
Local lCTECan    := SuperGetMv("MV_CTECAN",.F.,.F.)	//-- Cancelamento CTE - .F.-Padrao .T.-Apos autorizacao
Local lCanCTE    := .T.
Local lTemErro   := .F.
Local lTmsCFec   := TmsCFec()
Local dDataFec   := MVUlmes()
Local dDatFTMS   := GetMv("MV_DATATMS",.F.,CtoD(""))
Local nCteExcH   := SuperGetMv("MV_CTEEXCH",.F.,0)	//-- Prazo em horas para cancelamento CT-e apos ser autorizado
Local nCteExc    := SuperGetMv("MV_CTEEXC",.F.,0)	//-- Prazo em dias para cancelamento do CT-e apos ser autorizado.
Local nCancExt   := GetNewPar("MV_CANCEXT",0)		//-- Cancelamento Extemporaneo
Local nPrazo     := 0

DEFAULT l200Marca := .T.

If Type("lOcoNfc") == "U"
	//-- Carga Fechada - Verifica se o status 'Entregue'
	//   foi gerado automaticamente pela Nota Fiscal do Cliente.
	If lTmsCFec .And. DT6->DT6_STATUS == StrZero( 7, Len( DT6->DT6_STATUS ) )   //-- Entregue
		//-- Verifica se o status foi gerado pela nota fiscal
		DTC->(DbSetOrder(3))
		If DTC->(MsSeek(xFilial('DTC') + DT6->DT6_FILDOC + DT6->DT6_DOC + DT6->DT6_SERIE)) .And. (!Empty(DTC->DTC_DTENTR) .Or. !Empty(DTC->DTC_HORENT))
			lOcoNfc := .T.
		EndIf
	EndIf
EndIf

//-- Inclui o n˙mero do documento no vetor de mensagens de erro
Aadd(aMsgErr,{"","00",""})
Aadd(aMsgErr,{DT6->DT6_FILDOC + "/" + DT6->DT6_DOC + "/" + DT6->DT6_SERIE,"00",""})

//-- Se o status do documento for diferente de 'Em Aberto', mostra help somente uma vez
//-- Verifica se o documento est· em viagem
If !lMostra
	DUD->(DbSetOrder(1)) //DUD_FILIAL+DUD_FILDOC+DUD_DOC+DUD_SERIE+DUD_FILORI+DUD_VIAGEM
	If DUD->(MsSeek(xFilial("DUD")+DT6->DT6_FILDOC+DT6->DT6_DOC+DT6->DT6_SERIE+cFilAnt))
		While DUD->(!Eof()) .And. DUD->DUD_FILIAL + DUD->DUD_FILDOC + DUD->DUD_DOC + DUD->DUD_SERIE + DUD->DUD_FILORI == ;
			xFilial("DUD") + DT6->DT6_FILDOC + DT6->DT6_DOC + DT6->DT6_SERIE + cFilAnt
			If DUD->DUD_STATUS <> StrZero(9,Len(DUD->DUD_STATUS)) //-- Cancelado
				If !Empty(DUD->DUD_VIAGEM) .And. nLinDoc == 0
					AAdd(aMsgErr,{STR0201 + " (" + DUD->DUD_FILORI + "/" + DUD->DUD_VIAGEM + ").","00",""})	//-- "N„o È possÌvel estornar o c·lculo deste documento pois o mesmo est· vinculado na viagem (filial/viagem)."
					lTemErro  := .T.
					lMostra   := .T.
					l200Marca := .F.
					Exit
				EndIf
			EndIf
			DUD->(DbSkip())
		EndDo
	EndIf
EndIf

//-- Verifica se existem ocorrÍncias apontadas no documento
If !lOcoNfc .And. nLinDoc == 0
	DUA->(DbSetOrder(4))
	If DUA->(MsSeek(xFilial("DUA")+DT6->DT6_FILDOC+DT6->DT6_DOC+DT6->DT6_SERIE))
		AAdd(aMsgErr,{STR0202,"00",""})	//-- "H· ocorrÍncias lanÁadas para este documento."
		lTemErro  := .T.
		lMostra   := .T.
		l200Marca := .F.
	EndIf
EndIf

//-- Se o documento pertence a um redespacho com Status diferente de cancelado o documento nao pode ser excluido.
DFV->(DbSetOrder(2))
If DFV->(MsSeek( xFilial("DFV") + DT6->(DT6_FILDOC+DT6_DOC+DT6_SERIE))) .And. DFV->DFV_STATUS <> StrZero(9,Len(DFV->DFV_STATUS))
	AAdd(aMsgErr,{STR0203,"00",""})	//-- "Exclua o redespacho relacionado ao Documento antes da exclus„o."
	lTemErro  := .T.
	lMostra   := .T.
	l200Marca := .F.
EndIf

//-- Se o modo de faturamento for a partir do DT6, verificar se o CTRC ja foi faturado ...
If cTMSMFat == '2'
	//-- Obtem o perfil do cliente para verificar quais documentos possuem tratamento diferenciado no
	//-- faturamento:
	aPerfil := TmsPerfil(DT6->DT6_CLICAL,DT6->DT6_LOJCAL,,,DT6->DT6_CLIREM,DT6->DT6_LOJREM,DT6->DT6_CLIDES,DT6->DT6_LOJDES)
	If AllTrim(aPerfil[47]) <> "*" .And. !(DT6->DT6_DOCTMS $ aPerfil[47])
		If !Empty(DT6->DT6_NUM) .And. nLinDoc == 0
			AAdd(aMsgErr,{STR0204 + STR0063,"00",""})	//-- "Ja foi gerada Fatura para o CTRC" ### ". A Exclusao deste CTRC nao sera efetuada ... "
			lTemErro  := .T.
			lMostra   := .T.
			l200Marca := .F.
		EndIf
	EndIf
EndIf

//-- Nao permite estorno de documentos com data menor ou igual a do fechamento do estoque
If DT6->DT6_DATEMI <= dDataFec .And. nLinDoc == 0
	AAdd(aMsgErr,{STR0205,"00",""})	//-- "Nao pode ser digitado movimento com data anterior a ultima data de fechamento (virada de saldos)."
	lTemErro  := .T.
	l200Marca := .F.
EndIf

If !Empty(dDatFTMS) .And. DT6->DT6_DATEMI <= dDatFTMS .And. nLinDoc == 0
	AAdd(aMsgErr,{"FECHATMS","00",""})
	lTemErro  := .T.
	l200Marca := .F.
EndIf

//-- Analisa documento eletrÙnico
If l200Marca .And. lTMSCTe .And. DT6->DT6_SITCTE == "2"
    lCanCTE := .T.

    If Empty(Posicione("SF3",6,DT6->(DT6_FILDOC + DT6_DOC + DT6_SERIE),"F3_DTCANC"))

		If nCteExcH > 0
			nPrazo := Round(SubtHoras(DT6->DT6_DATEMI,SubStr(DT6->DT6_HOREMI,1,2) + ":" + SubStr(DT6->DT6_HOREMI,3,2),dDataBase,SubStr(Time(),1,2) + ":" + SubStr(Time(),4,2)),2)	//-- Prazo em Horas
			If nPrazo > nCteExcH
				lCanCTE := .F.
			EndIf
		ElseIf nCteExc > 0
			nPrazo := SubtHoras(DT6->DT6_DATEMI,SubStr(DT6->DT6_HOREMI,1,2) + ":" + SubStr(DT6->DT6_HOREMI,3,2),dDataBase,SubStr(Time(),1,2) + ":" + SubStr(Time(),4,2)) / 24	//-- Prazo em dias
			If nPrazo > nCteExc
				lCanCTE := .F.
			EndIf
		EndIf

		If nCancExt > 0 .And. !lCanCTE
			nPrazo := SubtHoras(DT6->DT6_DATEMI,SubStr(DT6->DT6_HOREMI,1,2) + ":" + SubStr(DT6->DT6_HOREMI,3,2),dDataBase,SubStr(Time(),1,2) + ":" + SubStr(Time(),4,2)) / 24	//-- Prazo em dias
			If nPrazo > nCancExt
				AAdd(aMsgErr,{STR0206 + STR0207 + Iif(nCancExt > 0, Alltrim(STR(nCancExt)) + STR0208,),"00",""})	//-- "N„o foi possivel excluir. Prazo para cancelamento do CT-e ultrapassado."
				lTemErro  := .T.
		   		l200Marca := .F.
			Else
				lCanCTE := .T.
			Endif
		EndIf

		If !lCanCTE
			AAdd(aMsgErr,{STR0206 + STR0209 + Iif(nCteExcH > 0,Alltrim(STR(nCteExcH)) + STR0210,Alltrim(STR(nCteExc)) + STR0211),"00",""})	//-- "N„o foi possivel excluir. Prazo para cancelamento do CT-e ultrapassado."
			lTemErro  := .T.
			l200Marca := .F.
		EndIf
	ElseIf DT6->DT6_STATUS != "C"
		lCanCTE := .F.
	EndIf
EndIf

cFilSF2	 := Iif(Empty(FwFilial("SF2")),xFilial("SF2"),DT6->DT6_FILDOC)
cFilSE1	 := Iif(Empty(FwFilial("SE1")),xFilial("SE1"),DT6->DT6_FILDOC)
SF2->(DbSetOrder(1))
SF2->(MsSeek(cFilSF2 + DT6->DT6_DOC + DT6->DT6_SERIE))
cPrefixo := Padr(Iif(Empty(SF2->F2_PREFIXO),&(cMV1DUPREF),SF2->F2_PREFIXO),Len( SE1->E1_PREFIXO))

//-- Verifica se o documento tem titulo baixado ou que nao esteja mais em carteira
SE1->(DbSetOrder(1))
If SE1->(MsSeek(cFilSE1 + cPrefixo + DT6->DT6_DOC)) .And. !Empty(DT6->DT6_NUM)
	While SE1->(!Eof() .And. SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM == cFilSE1 + cPrefixo + DT6->DT6_DOC)
		If Alltrim(SE1->E1_ORIGEM) == "MATA460" .Or. Left(SE1->E1_ORIGEM,3) == "TMS"
			If ROUND(SE1->E1_SALDO,2) <> ROUND(SE1->E1_VALOR,2) .Or. SE1->E1_SITUACA <> StrZero(0,Len(SE1->E1_SITUACA))
				lMostra := .T.
				Exit
			EndIf
		EndIf
		SE1->(DbSkip())
	EndDo

	If lMostra .And. nLinDoc == 0
		AAdd(aMsgErr,{STR0212,"00",""})	//-- "O tÌtulo do documento esta baixado ou nao esta em carteira. "
		lTemErro := .T.
	 EndIf
EndIf

//-- Exclusao CTE somente apos envio e autorizacao da SEFAZ - Nao permite marcar para exclusao se nao autorizado SEFAZ
If lTMSCTe .And. lCTECan .And. (!Empty(DT6->DT6_CHVCTE) .Or. !Empty(DT6->DT6_CHVCTG))
	If	DT6->DT6_STATUS $ "B/D"	//-- B=Cancelamento SEFAZ Aguardando, D=Cancelamento SEFAZ nao autorizado
		AAdd(aMsgErr,{STR0213,"00",""})	//-- "Cancelamento sem autorizacao SEFAZ."
		lTemErro  := .T.
		l200Marca := .F.
	EndIf
EndIf

//-- Retira o n˙mero documento do vetor de erros quando n„o foram apurados erros para estorno do documento
If !lTemErro
	Adel(aMsgErr,Len(aMsgErr))
	Adel(aMsgErr,Len(aMsgErr) - 1)
	Asize(aMsgErr,Len(aMsgErr) - 2)
EndIf

RestArea(aAreaDTC)
RestArea(aAreaSE1)
RestArea(aAreaSF2)
RestArea(aAreaSF3)
RestArea(aAreaDFV)

Return lTemErro
