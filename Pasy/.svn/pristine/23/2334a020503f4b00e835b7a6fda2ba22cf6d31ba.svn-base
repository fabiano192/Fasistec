#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0038  ³ Autor ³ Alexandro da Silva     ³ Data ³ 30.08.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Espelho do Ponto - Talentos                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico   - SigaPON                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PA0038()

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,AORD,AREGS")
SetPrvt("ARETURN,NOMEPROG,ALINHA,NLASTKEY,CPERG,AIMP")
SetPrvt("ATOTAIS,AABONADOS,NIMPHRS,ADRIVER,TITULO,CCABEC")
SetPrvt("AT_PRG,WCABEC0,WCABEC1,CONTFL,LI,NTAMANHO")
SetPrvt("CMENPAD1,CMENPAD2,CINDCOND,CFOR,NORDEM,AINFO")
SetPrvt("ATURNOS,WNREL,FILIALDE,FILIALATE,CCDE,CCATE")
SetPrvt("TURDE,TURATE,MATDE,MATATE,NOMDE,NOMATE")
SetPrvt("CSIT,CCAT,NIMPAUT,NCOPIAS,LSEMMARC,CINIPER")
SetPrvt("CFIMPER,LIMPACUM,LSEXACENT,LIMPRES,CCODEXTRAS,CFIL")
SetPrvt("CMAT,CTNO,CFILANT,CTNOANT,CSEQANT,CULTDIA")
SetPrvt("NCOUNT,NCOLUNAS,LLOOP,ATABORIGIN,DDATA,NX")
SetPrvt("NY,CACESSASRA,CSEQ,CTURNO,CHEADER,DPERINI")
SetPrvt("DPERFIM,ATABPADRAO,ATABCALEND,AMARCACOES,NCOLUMAX,CINICIO")
SetPrvt("CFIM,CMES,CANO,NLIN,NCOL,NMCOL")
SetPrvt("NUSADO,CORDEM,NORDER,DDATAOK,NPOS,NFOR")
SetPrvt("NCOLMARC,NTAMLIN,CDET,CAUTORIZA,NMETADE,NDIA")
SetPrvt("NMARC,NTAB,NCONTMARC,ADESCABONO,CTIPAFAS,CDESCAFAS")
SetPrvt("COCORR,CTIPDIA,LRET,LFERIADO,LTRABAFER,LAFASTA")
SetPrvt("DDTBASE,DDTRET,DDTAFAS,CDESCCC,NPASS,NHORASCAL")
SetPrvt("NHORASINF,ATOTSPC,ACODABONO,AJUSTIFICA,CFILSP9,CFILSPC")
SetPrvt("CFILSPH,CIMPHORAS,NCOLSPC,NCTSPC,NQUASPC,CACESSASPC")
SetPrvt("CACESSASPH,CACESSASPB,")

Private cDesc1     := "Espelho do Ponto"
Private cDesc2     := "Ser  impresso de acordo com os parametros solicitados pelo"
Private cDesc3     := "usuario."
Private cString    := "SRA"
Private aOrd       := {"Matricula","Centro de Custo","Nome","Turno","C.Custo + Nome"}
Private aRegs      := {}

Private aReturn  := {"Zebrado", 1, "Administracao", 2, 2, 1, "",1 }
Private nomeprog := "PA0038"
Private aLinha   := {}
Private nLastKey := 0
Private cPerg    := "PA0038"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define variaveis Private utilizadas no programa RDMAKE ImpEsp³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aImp      := {}
Private aTotais   := {}
Private aAbonados := {}
Private nImpHrs   := 0
Private aDriver   := LeDriver()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Titulo   := "Espelho do Ponto"
Private cCabec   := ""
Private AT_PRG   := "PONR010"
Private wCabec0  := 1
Private wCabec1  := ""
Private CONTFL   := 1
Private LI       := 0
Private nTamanho := "P"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis PRIVATE(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cMenPad1 := Space(30)
Private cMenPad2 := Space(19)
Private cIndCond := ""
Private cFor     := ""
Private nOrdem   := ""
Private aInfo    := {}
Private aTurnos  := {}

Pergunte("PA0038",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        //  Filial  De                               ³
//³ mv_par02        //  Filial  Ate                              ³
//³ mv_par03        //  Centro de Custo De                       ³
//³ mv_par04        //  Centro de Custo Ate                      ³
//³ mv_par05        //  Turno De                                 ³
//³ mv_par06        //  Turno Ate                                ³
//³ mv_par07        //  Matricula De                             ³
//³ mv_par08        //  Matricula Ate                            ³
//³ mv_par09        //  Nome De                                  ³
//³ mv_par10        //  Nome Ate                                 ³
//³ mv_par11        //  Situacao                                 ³
//³ mv_par12        //  Categoria                                ³
//³ mv_par13        //  Imprimir horas Calculadas/Inform/Ambas/NA³
//³ mv_par14        //  Demonstrar horas Autoriz/Nao Autorizadas ³
//³ mv_par15        //  N£mero de C¢pias                         ³
//³ mv_par16        //  Imprime para Funcion rios sem Marca‡oes  ³
//³ mv_par17        //  Mensagem padr„o anterior a Assinatura    ³
//³ mv_par18        //  Mens. padr„o anterior a Assinatura(Cont.)³
//³ mv_par19        //  Periodo Inicial				             ³
//³ mv_par20        //  Periodo Final  				             ³
//³ mv_par21        //  Impressao (Movimento/Acumulado)          ³
//³ mv_par22        //  Horas em  (Sexagenal/Centesimal)         ³
//³ mv_par23        //  Imprime eventos a partir do resultado ?  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := "PA0038"
wnrel := SetPrint(cString, wnrel, cPerg, Titulo, cDesc1, cDesc2, cDesc3, .F., aOrd, .F.,nTamanho)

nOrdem    := aReturn[8]
FilialDe  := mv_par01
FilialAte := mv_par02
CcDe      := mv_par03
CcAte     := mv_par04
TurDe     := mv_par05
TurAte    := mv_par06
MatDe     := mv_par07
MatAte    := mv_par08
NomDe     := mv_par09
NomAte    := mv_par10
cSit      := mv_par11
cCat      := mv_par12
nImpHrs   := mv_par13
nImpAut   := mv_par14
nCopias   := If(mv_par15>0, mv_par15, 1)
lSemMarc  := If(mv_par16==1, .T., .F.)
cMenPad1  := mv_par17
cMenPad2  := mv_par18
_cMes1    := StrZero(Month(MV_PAR19),2)
_cAno1    := StrZero(Month(MV_PAR19),4)
cIniPer	  := _cMes1 + _cAno1// SubStr(mv_par19,3,4)+SubStr(mv_par19,1,2)	// Ano + Mes
_cMes2    := StrZero(Month(MV_PAR20),2)
_cAno2    := StrZero(Month(MV_PAR20),4)
cFimPer	  := _cMes2 + _cAno2 //SubStr(mv_par20,3,4)+SubStr(mv_par20,1,2)	// Ano + Mes
lImpAcum  := IF(mv_par21==1,.F.,.T.)
lSexaCent := mv_par22
lImpRes   := If(mv_par23==1,.T.,.F.)

If nLastKey == 27
	Break
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Break
Endif

RptStatus({|lEnd| POR010Imp(@lEnd, wNRel, cString)}, Titulo)


Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ POR010Imp³ Autor ³ J.Ricardo             ³ Data ³ 07.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Espelho do Ponto                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ POR010Imp(lEnd,wnRel,cString)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd        - A‡Æo do Codelock                             ³±±
±±³          ³ wnRel       - T¡tulo do relat¢rio                          ³±±
±±³Parametros³ cString     - Mensagem                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function POR010Imp(lEnd,WnRel,cString)

//-- Variaveis Locais
Local cCodExtras := ""
Local cFil       := ""
Local cMat       := ""
Local cTno       := ""
Local cFilAnt    := "úú"
Local cTnoAnt    := "úúú"
Local cSeqAnt    := "úú"
Local cUltDia	 := ""
Local nCount     := 0
Local nColunas   := 0
Local lLoop      := .F.
Local aTabOrigin := {}
Local dData		 := Ctod("  /  /  ")
Local nX         := 0
Local nY         := 0
Local cAcessaSRA := &("{ || " + ChkRH("PONR010","SRA","2") + "}")
Local cSeq       := ''
Local cTurno     := ''

//-- Variaveis Private
Private cHeader    := ''
Private dPerIni    := CtoD('  /  /  ')
Private dPerFim    := CtoD('  /  /  ')
Private aTabPadrao := {}
Private aTabCalend := {}
Private aMarcacoes := {}
Private nColuMax   := 0

//-- Parƒmetro MV_COLMARC
nColunas := Getmv('MV_COLMARC')
If nColunas == Nil
	Help(' ', 1, 'MVCOLNCAD')
	Return (.F.)
Endif
nColunas *= 2
nColuMax := nColunas

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega todas as tabelas de hor rio                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !fTabTurno(aTabPadrao)
	Help(' ',1,'TPADNCAD')
	Return Nil
EndIf

dbSelectArea('SRA')
dbSetOrder(nOrdem)
If nOrdem == 1
	dbSeek(FilialDe + MatDe,.T.)
	cInicio  := 'SRA->RA_FILIAL + SRA->RA_MAT'
	cFim     := FilialAte + MatAte
ElseIf nOrdem == 2
	dbSeek(FilialDe + CcDe + MatDe,.T.)
	cInicio  := 'SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT'
	cFim     := FilialAte + CcAte + MatAte
ElseIf nOrdem == 3
	dbSeek(FilialDe + NomDe + MatDe,.T.)
	cInicio  := 'SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT'
	cFim     := FilialAte + NomAte + MatAte
ElseIf nOrdem == 4
	dbSeek(FilialDe + TurDe,.T.)
	cInicio  := 'SRA->RA_FILIAL + SRA->RA_TNOTRAB'
	cFim     := FilialAte + TurAte
ElseIf nOrdem == 5
	dbSetOrder(8)
	dbSeek(FilialDe + CcDe + NomDe,.T.)
	cInicio  := 'SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME'
	cFim     := FilialAte + CcAte + NomAte
Endif

SetRegua(SRA->(RecCount()))


//Begin Sequence

Do While !SRA->(Eof()) .And. &(cInicio) <= cFim
	
	IncRegua()
	
	If lEnd
		IMPR(cCancela,'C')
		Break
	EndIF
	
	If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
		SRA->(dbSkip())
		Loop
	EndIf
	
	If (SRA->RA_TNOTRAB < Turde) .Or. (SRA->RA_TNOTRAB > TurAte) .Or. ;
		(SRA->Ra_NOME < NomDe) .Or. (SRA->RA_NOME > NomAte) .Or. ;
		(SRA->Ra_MAT < MatDe) .Or. (SRA->RA_MAT > MatAte)  .Or. ;
		(SRA->Ra_CC < CCDe) .Or. (SRA->RA_CC > CCAte)
		Sra->(dbSkip())
		Loop
	Endif
	
	//-- Consiste Preenchimento de Cracha e data de Demiss„o
	If Empty(SRA->RA_CRACHA) .Or. ;
		!Empty(SRA->RA_DEMISSA) .And. SRA->RA_DEMISSA < dPerIni
		SRA->(DbSkip())
		Loop
	Endif
	
	//-- Consiste Situacao e Categoria
	If	!(Sra->Ra_SitFolh $ cSit) .Or. ;
		!(Sra->Ra_CatFunc $ cCat)
		SRA->(DbSkip())
		Loop
	Endif
	
	If SRA->RA_FILIAL #cFilAnt
		cFilAnt    := SRA->RA_Filial
		cTnoAnt    := 'úúú'
		cSeqAnt    := 'úú'
		cCodExtras := ''
		
		//-- Atualiza o Array de Informa‡”es sobre a Empresa.
		aInfo := {}
		fInfo(@aInfo, SRA->RA_Filial)
		
		//-- Atualiza C¢digos de Hora Extra (SP4)
		cFil := ''
		cTno := ''
		If SP4->( dbSeek( ( cFil := If(Empty(xFilial('SP4')), xFilial('SP4'), SRA->RA_Filial) ) + ( cTno := SRA->RA_TnoTrab ), .F.) ) .Or. ;
			SP4->( dbSeek( ( cFil := If(Empty(xFilial('SP4')), xFilial('SP4'), SRA->RA_Filial) ) + ( cTno := Space(3)        ), .F.) )
			Do While !SP4->(Eof()) .And. cFil + cTno == SP4->P4_FILIAL + SP4->P4_TURNO
				
				If !Empty(SP4->P4_CodAut) .And. nImpAut == 1 .Or. ;
					!Empty(SP4->P4_CodAut) .And. nImpAut == 3
					If SP9->( dbSeek(If(Empty(xFilial('SP9')), xFilial('SP9'), SRA->RA_Filial)+SP4->P4_CodAut, .F.) )
						If RIGHT(SP9->P9_CODFOL,1) == "A"
							cCodExtras += SP4->P4_CodAut + 'A'
						Else
							cCodExtras += SP4->P4_CodAut + 'N'
						Endif
					EndIf
				EndIf
				
				//-- N„o Autorizadas ou Ambas
				If !Empty(SP4->P4_CodNAut) .And. nImpAut == 2 .Or. ;
					!Empty(SP4->P4_CodNAut) .And. nImpAut == 3
					If SP9->( dbSeek(If(Empty(xFilial('SP9')), xFilial('SP9'), SRA->RA_Filial)+SP4->P4_CodNAut, .F.) )
						If RIGHT(SP9->P9_CODFOL,1) == "A"
							cCodExtras += SP4->P4_CodNAut + 'A'
						Else
							cCodExtras += SP4->P4_CodNAut + 'N'
						Endif
					EndIf
				EndIf
				
				SP4->(dbSkip())
			Enddo
		Endif
	Endif
		
//	cIniPer	 := SubStr(mv_par19,3,4)+SubStr(mv_par19,1,2)	// Ano + Mes
//	cFimPer	 := SubStr(mv_par20,3,4)+SubStr(mv_par20,1,2)	// Ano + Mes
	
	cIniPer	  := _cMes1 + _cAno1// SubStr(mv_par19,3,4)+SubStr(mv_par19,1,2)	// Ano + Mes
	cFimPer	  := _cMes2 + _cAno2 //SubStr(mv_par20,3,4)+SubStr(mv_par20,1,2)	// Ano + Mes
	
	While cIniPer <= cFimPer
		
		If lEnd
			Exit
		EndIF
		
		aTabOrigin := {}
		aTabCalend := {}
		aMarcacoes := {}
		dPerIni := CTOD('  /  /  ')
		dPerFim := CTOD('  /  /  ')
		cTnoAnt    := 'úúú'
		cSeqAnt    := 'úú'
		
		If lImpAcum
			If Left(GETMV('MV_PAPONTA'),2) < Right(GETMV('MV_PAPONTA'),2)
				// Pega o Ultimo dia Mes
				cUltDia := StrZero(f_UltDia(Ctod("01/"+StrZero(Val(SubStr(cIniPer,5,2)),2)+"/"+SubStr(cIniPer,1,4))),2)
				dData := Ctod(cUltDia+'/'+StrZero(Val(SubStr(cIniPer,5,2)),2)+"/"+SubStr(cIniPer,1,4),'ddmmyy')
			Else
				// Pega o dia do parametro
				dData := CtoD(Right(GETMV('MV_PAPONTA'),2)+"/"+SubStr(cIniPer,5,2)+"/"+SubStr(cIniPer,1,4),'ddmmyy')
			Endif
			
			//-- Parƒmetro MV_PAPONTA
			If !PerAponta(@dPerIni,@dPerFim,dData)
				Help(' ',1,'PERNCAD')
				Break
			Endif
		Else
			//-- Parƒmetro MV_PAPONTA
			If !PerAponta(@dPerIni,@dPerFim)
				Help(' ',1,'PERNCAD')
				Break
			Endif
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria Calendario de Marca‡oes do Periodo                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cTnoAnt + cSeqAnt #SRA->RA_TNOTRAB + SRA->RA_SEQTURN
			cTnoAnt    := SRA->RA_TNOTRAB
			cSeqAnt    := SRA->RA_SEQTURN
			aTabOrigin := {}
			aTabCalend := {}
			If !CriaCalend(dPerIni, dPerFim, SRA->RA_TNOTRAB, SRA->RA_SEQTURN, aTabPadrao, @aTabCalend)
				cTnoAnt := 'úúú'
				cSeqAnt := 'úú'
				cMes 	 := StrZero(Val(SubStr(cIniPer,5,2))+1,2)
				cAno   := SubStr(cIniPer,1,4)
				IF cMes == "13"
					cMes := "01"
					cAno := StrZero(Val(SubStr(cIniPer,1,4))+1,4)
				Endif
				
				// Se nao for Acumulado Imprime apenas o mes do movimento
				cIniPer:= If(lImpAcum,cAno+cMes,"999999")
				Loop
			EndIf
			aTabOrigin := aClone(aTabCalend)
		Endif
		
		//-- Monta Array com os Turnos utilizados no Periodo
		aTurnos    := {}
		fTrocaTno(dPerIni, dPerFim, @aTurnos)
		
		cTurno := SRA->RA_TNOTRAB
		cSeq   := SRA->RA_SEQTURN
		
		//-- Cria Calendario com o periodo completo com Trocas de Turno
		If Len(aTurnos) > 0
			aTabCalend := {}
			If !CriaCalend(dPerIni, dPerFim, aTurnos[1,1], aTurnos[1,3], aTabPadrao, @aTabCalend, SRA->RA_FILIAL, SRA->RA_MAT, SRA->RA_CC,aTurnos)
				cTnoAnt := 'úúú'
				cSeqAnt := 'úú'
				cMes 	 := StrZero(Val(SubStr(cIniPer,5,2))+1,2)
				cAno   := SubStr(cIniPer,1,4)
				IF cMes == "13"
					cMes := "01"
					cAno := StrZero(Val(SubStr(cIniPer,1,4))+1,4)
				Endif
				
				// Se nao for Acumulado Imprime apenas o mes do movimento
				cIniPer:= If(lImpAcum,cAno+cMes,"999999")
				Loop
			EndIf
		Else
			If RetSeq(cSeq,@cTurno,dPerIni,dPerFim,dDataBase,aTabPadrao,@cSeq)
				aTabCalend := {}
				If !CriaCalend(dPerIni, dPerFim, cTurno, cSeq, aTabPadrao, @aTabCalend, SRA->RA_FILIAL, SRA->RA_MAT, SRA->RA_CC)
					cTnoAnt := 'úúú'
					cSeqAnt := 'úú'
					cMes 	 := StrZero(Val(SubStr(cIniPer,5,2))+1,2)
					cAno   := SubStr(cIniPer,1,4)
					If cMes == "13"
						cMes := "01"
						cAno := StrZero(Val(SubStr(cIniPer,1,4))+1,4)
					Endif
					
					// Se nao for Acumulado Imprime apenas o mes do movimento
					cIniPer:= If(lImpAcum,cAno+cMes,"999999")
					Loop
				EndIf
			Else
				aTabCalend := aClone(aTabOrigin)
			Endif
			aAdd(aTurnos, { cTurno, dPerIni, cSeq, 0 } )
		EndIf
		
		Set Device to Printer
		
		//-- Carrega as Marcacoes do Funcionario.
		fMarc(SRA->RA_Filial, SRA->RA_TNOTRAB, SRA->RA_Mat, @aMarcacoes)
		
		//-- Gera a folga automatica
//		fDiasFolga(aMarcacoes,@aTabCalend,dPerIni,aTurnos,cTurno,cSeq)
		
		//-- Carrega os Totais de Horas e Abonos.
		aTotais   := {}
		aAbonados := {}
		CarAboTot(@aTotais,@aAbonados,cCodExtras)
		
		//-- Carrega o Array a ser utilizado na Impress„o.
		If !FMontaaImp(aTabCalend, aMarcacoes, @aImp) .And. !lSemMarc
			cMes 	 := StrZero(Val(SubStr(cIniPer,5,2))+1,2)
			cAno   := SubStr(cIniPer,1,4)
			IF cMes == "13"
				cMes := "01"
				cAno := StrZero(Val(SubStr(cIniPer,1,4))+1,4)
			Endif
			
			// Se nao for Acumulado Imprime apenas o mes do movimento
			cIniPer:= If(lImpAcum,cAno+cMes,"999999")
			Loop
		EndIf
		
		//-- Imprime o Espelho para um Funcionario.
		For nCount := 1 To nCopias
			fImpFun(aImp, nColunas)
		Next nCount
		
		//-- Reinicializa Variaveis
		aImp      := {}
		aTotais   := {}
		aAbonados := {}
		
		cMes 	 := StrZero(Val(SubStr(cIniPer,5,2))+1,2)
		cAno   := SubStr(cIniPer,1,4)
		IF cMes == "13"
			cMes := "01"
			cAno := StrZero(Val(SubStr(cIniPer,1,4))+1,4)
		Endif
		
		// Se nao for Acumulado Imprime apenas o mes do movimento
		cIniPer:= If(lImpAcum,cAno+cMes,"999999")
		
	Enddo
	
	SRA->(dbSkip())
	
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea('SRA')
dbSetOrder(1)
Set Device To Screen
If aReturn[5] == 1
	Set Printer To
	dbCommit()
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fMarcacoes³ Autor ³ Fernando Joly         ³ Data ³ 12/04/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Carrega o Array aMarcacoes, com as marca‡oes do Funcionario³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function fMarc(cFil, cTno, cMat, aMarcacoes)

//-- Variaveis Locais.
Local nX      := 0
Local nY      := 0
Local nLin    := 0
Local nCol    := 0
Local nMCol   := 0
Local nUsado  := 0
Local cOrdem  := 'úú'
Local cTurno  := ''
Local nOrder  := SP8->(IndexOrd())
Local dDataOk := CtoD('  /  /  ')

//-- Variaveis j  inicializadas.
aMarcacoes := {}

If lImpAcum // Impressao do Acumulado
	
	cFil := If(Empty(xFilial('SPG')),xFilial('SPG'),cFil)
	
	SPG->(dbSetorder(2))
	
	For nX := 1 to Len(aTurnos)
		cTurno := aTurnos[nX,1]
		
		If SPG->(DbSeek(cFil + cTurno + cMat, .F.))
			Do While !SPG->(Eof()) .And. cFil + cTurno + cMat == SPG->PG_Filial + SPG->PG_Turno + SPG->PG_Mat
				
				//-- Nao considera Datas fora do Periodo ou se diferenca entre
				//-- Data Gravada e Data da Tabela for maior que 2.
				dDataOk := If( ( nPos := aScan(aTabCalend, { |x| x[2] == SPG->PG_Ordem .And. x[4] == '1E' }) ) > 0, aTabCalend[nPos,1], SPG->PG_Data )
				If Abs(SPG->PG_Data - dDataOk) > 2 .Or. ;
					Abs(SPG->PG_Data - dDataOk) <= 2 .And. dDataOk < dPerIni .Or. ;
					Abs(SPG->PG_Data - dDataOk) <= 2 .And. dDataOk > dPerFim
					SPG->(dbSkip())
					Loop
				EndIf
				
				//-- Monta o array aMarcacoes.
				aAdd(aMarcacoes,{})
				aAdd(aMarcacoes[Len(aMarcacoes)], SPG->PG_DATA)
				aAdd(aMarcacoes[Len(aMarcacoes)], SPG->PG_HORA)
				aAdd(aMarcacoes[Len(aMarcacoes)], SPG->PG_ORDEM)
				aAdd(aMarcacoes[Len(aMarcacoes)], SPG->PG_FLAG)
				aAdd(aMarcacoes[Len(aMarcacoes)], .F.)
				
				SPG->(dbSkip(1))
			EndDo
		EndIf
		
	Next nX
	
	SPG->(dbSetOrder(nOrder))
	
Else
	
	cFil := If(Empty(xFilial('SP8')),xFilial('SP8'),cFil)
	
	SP8->(dbSetorder(2))
	
	For nX := 1 to Len(aTurnos)
		cTurno := aTurnos[nX,1]
		
		If SP8->(DbSeek(cFil + cTurno + cMat, .F.))
			Do While !SP8->(Eof()) .And. cFil + cTurno + cMat == SP8->P8_Filial + SP8->P8_Turno + SP8->P8_Mat
				
				//-- Nao considera Datas fora do Periodo ou se diferenca entre
				//-- Data Gravada e Data da Tabela for maior que 2.
				dDataOk := If( ( nPos := aScan(aTabCalend, { |x| x[2] == SP8->P8_Ordem .And. x[4] == '1E' }) ) > 0, aTabCalend[nPos,1], SP8->P8_Data )
				If Abs(SP8->P8_Data - dDataOk) > 2 .Or. ;
					Abs(SP8->P8_Data - dDataOk) <= 2 .And. dDataOk < dPerIni .Or. ;
					Abs(SP8->P8_Data - dDataOk) <= 2 .And. dDataOk > dPerFim
					SP8->(dbSkip())
					Loop
				EndIf
				
				//-- Monta o array aMarcacoes.
				aAdd(aMarcacoes,{})
				aAdd(aMarcacoes[Len(aMarcacoes)], SP8->P8_DATA)
				aAdd(aMarcacoes[Len(aMarcacoes)], SP8->P8_HORA)
				aAdd(aMarcacoes[Len(aMarcacoes)], SP8->P8_ORDEM)
				aAdd(aMarcacoes[Len(aMarcacoes)], SP8->P8_FLAG)
				aAdd(aMarcacoes[Len(aMarcacoes)], .F.)
				
				SP8->(dbSkip(1))
			EndDo
		EndIf
		
	Next nX
	
	SP8->(dbSetOrder(nOrder))
	
Endif

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FImpFun   ³ Autor ³ J.Ricardo             ³ Data ³ 09/04/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o espelho do ponto do funcionario                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ POR010IMP                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


Static Function fImpFun(aImp, nColunas)

//-- Variaveis Locais
Local nX        := 0
Local nY        := 0
Local nFor      := 0
Local nCol      := 0
Local nColMarc  := 0
Local nTamLin   := 0
Local cDet      := ''
Local cAutoriza := ''

//-- Reinicializa Variaveis Private
cMenpad1 := If(Len(cMenPad1)==0,Space(30),cMenPad1)
cMenpad2 := If(Len(cMenPad2)==0,Space(19),cMenPad2)

//-- Define o tamanho da linha com base no MV_ColMarc.
aEval(aImp, { |x| nColMarc := If(Len(x)-3>nColMarc, Len(x)-3, nColMarc) } )
nColMarc += If(nColMarc%2 == 0, 0, 1)
nColunas := Max(nColunas, nColMarc)

//-- Define configura‡”es da impress„o
nTamLin    := If((19+(nColunas*6)+29)<=80,80,132)
aReturn[4] := If(nTamLin>80,1,2) //-- 1=Comprimido 2=Normal
nTamanho   := If(aReturn[4]==1,'G','P')

//-- Inicializa Li com 1 para n„o imprimir cabecalho padrao
Li := 01

//-- Imprime Cabecalho Especifico.
Imp_Cabec(nTamLin, nColunas, nTamanho)

//-- Imprime Marca‡”es
For nX := 1 To Len(aImp)
	cDet := PADR(DtoC(aImp[nX,1]),10) + Space(1) + DiaSemana(aImp[nX,1],8)
	If Len(aImp[nX]) >= 4
		For nY := 4 To Min(nColunas+4,Len(aImp[nX]))
			cDet += aImp[nX,nY] + Space(1)
		Next nY
	Else
		cDet += aImp[nX,2]
	Endif
	cDet := Left(cDet+Space(19+(nColunas*6)), 19+(nColunas*6)) + aImp[nX,3]
	cDet := Left(AllTrim(cDet)+Space(nTamLin),nTamLin)
	Impr(cDet, 'C')
Next nX

Impr(Repl('-',nTamLin), 'C')
Impr(' ','C')
Impr(cMenPad1 + cMenPad2 + Repl('_',31), 'C')
Impr(Space(52) + 'Assinatura do Funcionario' , 'C') 

//-- Se existirem totais, e se for selecionada sua impress„o, ser„o impressos.
If Len(aTotais) > 0 .And. nImpHrs #4
	Impr(Repl('-',nTamLin),'C')
	cDet := 'T O T A I S'
	Impr(cDet,'C')
	Impr(' ','C')
	If Len(aTotais) % 2 #0
		Aadd (aTotais, Space(Len(aTotais[1])))
	Endif
	If nImpHrs == 1
		cDet := 'Cod Descricao             Calc.           Cod Descricao             Calc.       '
	ElseIf nImpHrs == 2
		cDet := 'Cod Descricao                   Infor.    Cod Descricao                   Infor.'
	Else
		cDet := 'Cod Descricao             Calc. Infor.    Cod Descricao             Calc. Infor.'
	Endif
	
	Impr(cDet,'C')
	Impr(Repl('=',38)+Space(4)+Repl('=',38),'C')
	nMetade := Len(aTotais) / 2
	For nX := 1 To Len(aTotais)/2
		cDet := aTotais[nX]+Space(4)+aTotais[nX+nMetade]
		Impr(cDet,'C')
	Next
Endif

Impr(Repl('-',nTamLin),'C')

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FMontaaIMP³ aUTOR ³ j.rICARDO             ³ dATA ³ 09/04/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta o Vetor aImp , utilizado na impressao do espelho     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ POR010IMP                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FMontaAimp(aTabCalend, aMarcacoes, aImp)

//-- Variaveis Locais
Local nX         := 0
Local nDia       := 0
Local nMarc      := 0
Local nTab       := 0
Local nContMarc  := 0
Local aDescAbono := {}
Local dData      := CtoD('  /  /  ')
Local cTipAfas   := ''
Local cDescAfas  := ''
Local cOcorr     := ''
Local cOrdem     := ''
Local cTipDia    := ''
Local lRet       := .T.
Local lFeriado   := .T.
Local lTrabaFer  := .F.
Local lAfasta    := .T.
Local dDtBase    := IF(lImpAcum,dPerFim,dDataBase)

//-- Variaveis ja inicializadas.
aImp := {}

For nDia := 0 To (dDtBase - dPerIni)
	
	//-- Reinicializa Variaveis.
	dData      := dPerIni + nDia
	dDtRet     := Ctod('  /  /  ')
	dDtAfas    := Ctod('  /  /  ')
	aDescAbono := {}
	cOcorr     := ''
	cTipAfas   := ''
	cDescAfas  := ''
	
	//-- Consiste Afastamentos, Demissoes ou Transferencias.
	If fAfasta( SRA->RA_Filial,SRA->RA_Mat,dData,@dDtafas,@dDtRet,@cTipAfas) .Or. ;
		SRA->RA_SitFolh $ 'DúT' .And. dData > SRA->RA_DEMISSA
		lAfasta   := .T.
		cDescAfas := fDescAfast(If(!Empty(cTipAfas),cTipAfas,SRA->RA_SitFolha))
	Else
		lAfasta := .F.
	Endif
	
	//-- Consiste Feriados.
	lFeriado := If( fFeriado(SRA->RA_Filial,dData,@cOcorr), .T., .F.)
	
	//-- Verifica Regra de Apontamento ( Trabalha Feriado ? )
	If SPA->(dbSeek(xFilial('SPA')+SRA->RA_Regra,.F.))
		If SPA->PA_Feriado == 'S'
			lTrabaFer := .T.
		Else
			lTrabaFer := .F.
		EndIf
	EndIf
	
	//-- o Array aTabcalend ‚ setado para a 1a Entrada do dia em quest„o.
	nTab := aScan(aTabCalend, {|x| x[1] == dData .And. x[4] == '1E' })
	
	//-- o Array aMarcacoes ‚ setado para a 1a Marca‡„o do dia em quest„o.
	nMarc := aScan(aMarcacoes, { |x| x[3] == aTabCalend[nTab, 2] })
	
	//-- Carrega Array aDescAbono com os Abonos ocorridos no Dia
	For nX := 1 to Len(aAbonados)
		If aAbonados[nX,1] == dData
			aAdd(aDescAbono, aAbonados[nX,2] + Space(1) + aAbonados[nX,3])
		EndIf
	Next nX
	
	//-- Ordem e Tipo do dia em quest„o.
	cOrdem  := aTabCalend[nTab,2]
	cTipDia := aTabCalend[nTab,6]
	
	If lAfasta
		cOcorr := cDescAfas
	ElseIf aTabCalend[nTab,10] == 'E' .And. cTipDia #'S'
		If !Empty(aTabCalend[nTab,11])
			cOcorr := Left(AllTrim(aTabCalend[nTab,11]), Min(Len(AllTrim(aTabCalend[nTab,11])),23))
		Else
			cOcorr := '** Excecao nao Trabalhada **'
		EndIf
	ElseIf lFeriado .And. !lTrabaFer
		cOcorr := If(!Empty(cOcorr),cOcorr,'** Feriado **')
	ElseIf cTipDia == 'S' .And. nMarc == 0 .And. dData >= SRA->RA_ADMISSA
		cOcorr := '** Ausente **'
	ElseIf cTipDia #'S'
		If cTipDia == 'D'
			cOcorr := '** D.S.R. **'
		ElseIf cTipDia == 'C'
			cOcorr := '** Compensado **'
		ElseIf cTipDia == 'N'
			cOcorr := '** Nao Trabalhado **'
		EndIf
	EndIf
	cOcorr := If(!Empty(cOcorr),Space( Int((23-Len(cOcorr))/2) ) + cOcorr,'')
	
	//-- Adiciona Nova Data a ser impressa.
	aAdd(aImp,{})
	aAdd(aImp[Len(aImp)], aTabCalend[nTab,1])
	
	//-- Ocorrencia na Data.
	aAdd( aImp[Len(aImp)], cOcorr)
	
	//-- Abono na Data.
	If Len(aDescAbono) > 0
		For nX := 1 To Len(aDescAbono)
			If nX == 1
				aAdd( aImp[Len(aImp)], aDescAbono[nX])
			Else
				aAdd(aImp, {})
				aAdd(aImp[Len(aImp)], aTabCalend[nTab,1])
				aAdd(aImp[Len(aImp)], Space(Len(cOcorr)-13)+Replic('.',13))
				aAdd(aImp[Len(aImp)], aDescAbono[nX])
			Endif
		Next nX
	Else
		aAdd( aImp[Len(aImp)], '' )
	Endif
	
	//-- Marca‡oes ocorridas na data.
	If nMarc > 0
		Do While nMarc <= Len(aMarcacoes) .And. cOrdem == aMarcacoes[nMarc,3]
			nContMarc ++
			aAdd( aImp[Len(aImp)], StrTran(StrZero(aMarcacoes[nMarc,2],5,2),'.',':'))
			nMarc ++
		EndDo
	EndIf
	
Next nDia

lRet := If(nContMarc>=1,.T.,.F.)

Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Imp_Cabec ³ Autor ³ J.Ricardo             ³ Data ³ 09/04/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o cabecalho do espelho do ponto                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ POR010IMP                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Imp_Cabec(nTamLin ,nColunas, nTamanho)

Local cDet      := ''
Local cDescCc   := ''

//-- Inicializa a impress„o
If aReturn[4] == 1  //-- Comprimido
	@ 0,0 PSAY &(if(nTamanho=='P',aDriver[1],if(nTamanho=='G',aDriver[5],aDriver[3])))
Else					  //-- Normal
	@ 0,0 PSAY &(if(nTamanho=='P',aDriver[2],if(nTamanho=='G',aDriver[6],aDriver[4])))
Endif

dbSelectArea("SA2")
dbSetOrder(1)
dbSeek(xFilial("SA2")+MV_PAR25+MV_PAR26)

//cDet := "Emp...: "+ Left( If(Len(aInfo)>0,aInfo[03],SM0->M0_NomeCom) + Space(33), 33) 
//cDet += " Matr..: " + SRA->RA_Filial + "-" + SRA->RA_Mat  
//cDet += "  Chapa : " + SRA->RA_Chapa 

cDet := "Emp...: "+Substr(SA2->A2_NOME,1,40)+ " Matr..: " + SRA->RA_Filial + "-" + SRA->RA_Mat + "  Chapa : " + SRA->RA_Chapa 

Impr(cDet,'C')

//cDet := "End...: " + Left( If(Len(aInfo)>0,aInfo[04],SM0->M0_EndCob) + Space(33), 33) 
//cDet += " Nome..: " + Left(SRA->RA_Nome + Space(30), 30)  

cDet := "End...: " +Substr(SA2->A2_END,1,40) +" Nome..: " + Left(SRA->RA_Nome + Space(20), 30)  
Impr(cDet,'C')

//cDet := "CGC...: " + Transform( If(Len(aInfo)>0,aInfo[08],SM0->M0_CGC),'@R ##.###.###/####-##') + Space(16)  
//cDet +=  "Funcao: " + SRA->RA_CodFunc + "-" + Left(DescFun(SRA->RA_CodFunc , SRA->RA_Filial) + Space(20), 20) 

cDet :=  "CGC...: " + Transform(SA2->A2_CGC,'@R ##.###.###/####-##') + Space(23)  
cDet +=  "Funcao: " + SRA->RA_CodFunc + "-" + Left(DescFun(SRA->RA_CodFunc , SRA->RA_Filial) + Space(10), 20) 
Impr(cDet,'C')

cDet := "C.C...: "  + Left(AllTrim(SRA->RA_CC) + '-' + Left(DescCc(SRA->RA_CC, SRA->RA_FILIAL) + Space(23), 23) + Space(40), 40) 
cDet += " Categ.: " + DescCateg(SRA->RA_CatFunc,15) 
Impr(cDet,'C')

cDet := "Turno.: "  + AllTrim(SRA->RA_TnoTrab) + '-' + fDescTno(SRA->RA_Filial,SRA->RA_TnoTrab) 
Impr(cDet,'C')

cHeader := "   DATA    DIA     "

For nX := 1 to (nColunas/2)
	cHeader += StrZero(nX,1) + 'a E. ' + StrZero(nX,1) + 'a S. '
Next nX
cHeader += 'Motivo de Abono           Horas'

Impr(Replicate('-',nTamLin), 'C')
Impr(cHeader, 'C')
Impr(Replicate('-',nTamLin), 'C')

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CarAboTot ³ Autor ³ J.Ricardo             ³ Data ³ 08/08/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carrega os totais do SPC e os abonos                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ POR010IMP                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


Static Function CarAboTot(aTotais,aAbonados,cCodExtras)

//-- Variaveis Locais.
Local nPass     := 0
Local nHorasCal := 0
Local nHorasInf := 0
Local nX        := 0
Local aTotSpc   := {} //-- 1-SPC->PC_PD/2-SPC->PC_QUANTC/3-SPC->PC_QUANTI/4-SPC->PC_QTABONO
Local aCodAbono := {}
Local aJustifica:= {} //-- Retorno fAbonos() c/Cod abono e horas abonadas.
Local cString   := ''
Local cFilSP9   := If(Empty(xFilial('SP9')), xFilial('SP9'), SRA->RA_Filial)
Local cFilSPC   := If(Empty(xFilial('SPC')), xFilial('SPC'), SRA->RA_Filial)
Local cFilSPH   := If(Empty(xFilial('SPH')), xFilial('SPH'), SRA->RA_Filial)
Local cImpHoras := If(nImpHrs==1,'C',If(nImpHrs==2,'I','*')) //-- Calc/Info/Ambas
Local cAutoriza := If(nImpAut==1,'A',If(nImpAut==2,'N','*')) //-- Aut./N.Aut./Ambas
Local nColSpc   := 0
Local nCtSpc    := 0
Local nQuaSpc	:= 0
Local cAcessaSPC := &("{ || " + ChkRH("PONR010","SPC","2") + "}")
Local cAcessaSPH := &("{ || " + ChkRH("PONR010","SPH","2") + "}")
Local cAcessaSPB := &("{ || " + ChkRH("PONR010","SPB","2") + "}")

//-- Variaveis ja inicializadas.
aTotais   := If(aTotais==Nil,{},aTotais)
aAbonados := If(aAbonados==Nil,{},aAbonados)

If lImpAcum .And. !lImpRes // Acumulado
	fTotAcumu(@aTotSpc,SRA->RA_Filial,SRA->RA_Mat,cAcessaSPH)
ElseIf lImpRes
	fTotalSPB(@aTotSpc,SRA->RA_Filial,SRA->RA_Mat,dPerIni,dPerFim,cAcessaSPB)
Else
	fTotaliza(@aTotSpc,SRA->RA_Filial,SRA->RA_Mat,cAcessaSPC)
Endif

//-- Converte as horas para sexagenal quando impressao for a partir
//-- do resultado e para centesimal quando impressao for a partir do
//-- apontamento.
If lImpRes
	If lSexaCent == 1	// Sexagenal
		For nCtSpc:=1 to Len(aTotSpc)
			For nColSpc:=2 to 4
				aTotSpc[nCtSpc,nColSpc]:=fConvHr(aTotSpc[nCtSpc,nColSpc],'H')
			Next
		Next
	Endif
Else
	// Converte as horas para Centesimal
	If lSexaCent == 2	// Centesimal
		For nCtSpc:=1 to Len(aTotSpc)
			For nColSpc:=2 to 4
				aTotSpc[nCtSpc,nColSpc]:=fConvHr(aTotSpc[nCtSpc,nColSpc],'D')
			Next
		Next
	Endif
Endif

//-- Monta Array com Totais de Horas
If nImpHrs #4
	For nPass := 1 to Len(aTotSpc)
		If SP9->(dbSeek(cFilSP9+aTotSpc[nPass,1],.F.)) .Or. aTotSpc[nPass,1] $ cCodExtras
			If cAutoriza == '*' .Or. cAutoriza == Right(SP9->P9_CodFol,1) .Or. aTotSpc[nPass,1] $ cCodExtras
				nHorasCal := aTotSpc[nPass,2] //-- Calculado - Abonado
				nHorasInf := aTotSpc[nPass,3] //-- Informado
				If nHorasCal > 0 .And. cImpHoras $ 'Cú*' .Or. nHorasInf > 0 .And. cImpHoras $ 'Iú*'
					cString := If(cImpHoras$'Cú*',Transform(nHorasCal, '@E 999.99'),Space(6)) + Space(1)
					cString += If(cImpHoras$'Iú*',Transform(nHorasInf, '@E 999.99'),Space(6))
					aAdd(aTotais, aTotSpc[nPass,1] + Space(1) + DescPDPon(aTotSpc[nPass,1], cFilSP9 ) + Space(1) + cString )
				EndIf
			EndIf
		EndIf
	Next nPass
EndIf

//-- Monta Array com Abonos.
aCodAbono := {}
If lImpAcum 	// Acumulado
	
	If SPH->(dbSeek(cFilSPH+SRA->RA_Mat,.F.))
		While !SPH->(Eof()) .And. SPH->PH_Filial+SPH->PH_Mat == cFilSPH+SRA->RA_Mat
			If dPerIni <= SPH->PH_DATA .And. SPH->PH_DATA <= dPerFim
				aJustifica := {} //-- Reinicializa aJustifica
				If fAbonos(SPH->PH_DATA,SPH->PH_PD,,@aJustifica) > 0 .And. SPH->PH_QUANTI == 0
					
					//-- Emite n abonos existentes para um mesmo dia.
					For nX := 1 To Len(aJustifica)
						
						nQuaSpc := aJustifica[nX,2] //@@SPH->PH_QtAbono
						// Converte as horas para Centesimal
						If lSexaCent == 2	// Centesimal
							nQuaSpc:=fConvHr(nQuaSpc,'D')
						Endif
						
						//-- Quando existir mais de um abono no mesmo dia
						//-- emitir a descricao do abono na proxima linha
						//-- mesma coluna, sem data.
						aAdd( aAbonados, {})
						aAdd( aAbonados[Len(aAbonados)], SPH->PH_Data)
						aAdd( aAbonados[Len(aAbonados)], DescAbono(aJustifica[nX,1],'C'))
						aAdd( aAbonados[Len(aAbonados)], StrTran(StrZero(nQuaSpc,5,2),'.',':'))
						
						If SP6->(dbSeek(xFilial('SP6')+aJustifica[nX,1],.F.))	.And. ;
							!Empty(SP6->P6_Evento)
							If ( nPos := aScan(aCodAbono, {|x| x[1] == SP6->P6_Evento}) ) > 0
								IF lSexaCent == 2	// Centesimal
									aCodAbono[nPos,2] += nQuaSpc
								Else
									aCodAbono[nPos,2] := SomaHoras(aCodAbono[nPos,2], nQuaSpc)
								Endif
							Else
								aAdd(aCodAbono, {SP6->P6_Evento, nQuaSpc})
							EndIf
						EndIf
					Next nX
				Endif
			Endif
			SPH->(dbSkip(1))
		EndDo
		If nImpHrs == 2 .Or. nImpHrs == 3
			For nX := 1 to Len(aCodAbono)
				aAdd(aTotais, aCodAbono[nX,1] + Space(1) + DescPDPon(aCodAbono[nX,1], cFilSP9) + '   0,00 '  + Transform(aCodAbono[nX,2],'@E 999.99') )
			Next nX
		EndIf
	EndIf
Else
	If SPC->(dbSeek(cFilSPC+SRA->RA_Mat,.F.))
		While !SPC->(Eof()) .And. SPC->PC_Filial+SPC->PC_Mat == cFilSPC+SRA->RA_Mat
			If dPerIni <= SPC->PC_DATA .And. SPC->PC_DATA <= dPerFim
				aJustifica := {} //-- Reinicializa aJustifica
				If fAbonos(SPC->PC_DATA,SPC->PC_PD,,@aJustifica) > 0 .And. SPC->PC_QUANTI == 0
					
					For nX := 1 To Len(aJustifica)
						nQuaSpc := aJustifica[nX,2] //@@SPC->PC_QtAbono
						// Converte as horas para Centesimal
						If lSexaCent == 2	// Centesimal
							nQuaSpc:= fConvHr(nQuaSpc,'D')
						Endif
						
						aAdd( aAbonados, {} )
						aAdd( aAbonados[Len(aAbonados)], SPC->PC_Data )
						aAdd( aAbonados[Len(aAbonados)], DescAbono(aJustifica[nX,1],'C') )
						aAdd( aAbonados[Len(aAbonados)], StrTran(StrZero(nQuaSpc,5,2),'.',':') )
						
						If SP6->(dbSeek(xFilial('SP6')+aJustifica[nX,1],.F.))	.And. ;
							!Empty(SP6->P6_Evento)
							If ( nPos := aScan(aCodAbono, {|x| x[1] == SP6->P6_Evento}) ) > 0
								IF lSexaCent == 2	// Centesimal
									aCodAbono[nPos,2] += nQuaSpc
								Else
									aCodAbono[nPos,2] := SomaHoras(aCodAbono[nPos,2], nQuaSpc)
								Endif
							Else
								aAdd(aCodAbono, {SP6->P6_Evento, nQuaSpc})
							EndIf
						EndIf
					Next nX
				Endif
			Endif
			SPC->(dbSkip(1))
		EndDo
		If nImpHrs == 2 .Or. nImpHrs == 3
			For nX := 1 to Len(aCodAbono)
				aAdd(aTotais, aCodAbono[nX,1] + Space(1) + DescPDPon(aCodAbono[nX,1], cFilSP9) + '   0,00 '  + Transform(aCodAbono[nX,2],'@E 999.99') )
			Next nX
		EndIf
	EndIf
Endif
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³fTotAcumu ³ Autor ³ Aldo Marini Junior    ³ Data ³ 31/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Totalizar as Verbas do SPH - Acumulado do SPC-Apontamentos ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fTotAcumu(aTotais,cFil,cMat,cAcessaSPH)

cfil    := If( cFil    == Nil, SRA->RA_FILIAL, cFil )
cMat    := If( cMat    == Nil, SRA->RA_MAT,    cMat )
aTotais := If( aTotais == Nil, {},          aTotais )
cAcessaSPH := If(cAcessaSPH == Nil, "", cAcessaSPH)

If SPH->(dbSeek(cFil+cMat))
	Do While !SPH->(Eof()) .And. cFil+cMat == SPH->PH_FILIAL+SPH->PH_MAT
		
		If SPH->PH_DATA < dPerIni .Or. SPH->PH_DATA > dPerFim
			SPH->(dbSkip())
			Loop
		Endif
		
		If !Empty(cAcessaSPH) .And. !Eval(cAcessaSPH)
			SPH->(dbSkip())
			Loop
		EndIf
		
		If ( nPos := Ascan(aTotais,{|x| x[1] = If(!Empty(SPH->PH_PDI),SPH->PH_PDI,SPH->PH_PD)  }) ) > 0
			aTotais[nPos,2] := SomaHoras(aTotais[nPos,2],If(SPH->PH_QUANTI>0,0,SubHoras(SPH->PH_QUANTC,SPH->PH_QTABONO)))
			aTotais[nPos,3] := SomaHoras(aTotais[nPos,3],SPH->PH_QUANTI)
			aTotais[nPos,4] := SomaHoras(aTotais[nPos,4],SPH->PH_QTABONO)
		Else
			aAdd(aTotais,{If(!Empty(SPH->PH_PDI),SPH->PH_PDI,SPH->PH_PD),If(SPH->PH_QUANTI>0,0,SubHoras(SPH->PH_QUANTC,SPH->PH_QTABONO)),SPH->PH_QUANTI,SPH->PH_QTABONO })
		Endif
		SPH->(dbSkip())
	EndDo
Endif
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³fTotalSPB ³ Autor ³ Alexsandro Pereira    ³ Data ³ 05/06/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Totaliza eventos a partir do SPB.                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/


Static Function fTotalSPB(aTotais,cFil,cMat,dDataIni,dDataFim,cAcessaSPB)

cfil    := If( cFil    == Nil, SRA->RA_FILIAL, cFil )
cMat    := If( cMat    == Nil, SRA->RA_MAT,    cMat )
aTotais := If( aTotais == Nil, {},          aTotais )
cAcessaSPB := If(cAcessaSPB == Nil, "", cAcessaSPB)

If SPB->(dbSeek(cFil+cMat))
	Do While !SPB->(Eof()) .And. cFil+cMat == SPB->PB_FILIAL+SPB->PB_MAT
		
		If SPB->PB_DATA < dDataIni .Or. SPB->PB_DATA > dDataFim
			SPB->(dbSkip())
			Loop
		Endif
		
		If !Empty(cAcessaSPB) .And. !Eval(cAcessaSPB)
			SPB->(dbSkip())
			Loop
		EndIf
		
		If ( nPos := Ascan(aTotais,{|x| x[1] = SPB->PB_PD }) ) > 0
			aTotais[nPos,2] := SomaHoras(aTotais[nPos,2],SPB->PB_HORAS)
		Else
			aAdd(aTotais,{SPB->PB_PD,SPB->PB_HORAS,0,0 })
		Endif
		SPB->(dbSkip())
	EndDo
Endif
Return Nil