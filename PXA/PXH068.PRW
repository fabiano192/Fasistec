#INCLUDE "RECIBO.CH"
#INCLUDE "TOTVS.CH"

#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF

/*
Programa	: 	PXH068
Autor		:	Fabiano da Silva
Data		:	14/01/15
Descrição	:	Recibo de Pagamento Gráfico
Obs			:	Fonte base Padrão Totvs GPER030.prx

*/
User Function PXH068()
	
	Local cIndCond
	Private cSem_De  	:= "  /  /    "
	Private cSem_Ate 	:= "  /  /    "
	Private nAteLim , nBaseFgts , nFgts , nBaseIr , nBaseIrFe
	Private aLanca 		:= {}
	Private aProve 		:= {}
	Private aDesco 		:= {}
	Private aBases 		:= {}
	Private aInfo  		:= {}
	Private aCodFol		:= {}
	Private li     		:= 0
	Private liAux		:= 0
	Private _cVia		:= ''
	Private Titulo 		:= "Emissão de recibo de Pagamentos"
	Private cIRefSem	:= GetMv("MV_IREFSEM",,"S")
	Private _cCombo 	:= ""
	Private _aOrd   	:= {"Matricula","C.Custo","Nome","Chapa","C.Custo + Nome","Depto.","Depto. + Nome"}
	Private nTermina  	:= 0
	Private _nQtVerb	:= 13
	
	AtuSX1()
	
	_nOpc := 0
	DEFINE MSDIALOG oDlg TITLE "Recibo de Pagamento Gráfico" From 0,0 to 200,400 of oMainWnd PIXEL
	
	@ 05,05 to 40,200 of oDlg pixel
	
	@ 15,10  Say "Emissão de Recibo de Pagamento Gráfico." of oDlg pixel
	@ 25,10  Say "Será impresso de acordo com os parametros solicitados pelo usuário." of oDlg pixel
	
	@ 41,05 to 65,200 of oDlg pixel
	
	@ 50,10 Say "Ordem:" 		SIZE 60,20 of oDlg pixel
	@ 50,35 COMBOBOX _cCombo    	ITEMS _aOrd  SIZE 50,20 of oDlg pixel
	
	@ 66,05 to 95,200 of oDlg pixel
	DEFINE SBUTTON FROM 080,020 TYPE 5 ACTION Pergunte("PXH068") 	ENABLE Of oDlg
	DEFINE SBUTTON FROM 080,060 TYPE 2 ACTION oDlg:End() 		 	ENABLE Of oDlg
	DEFINE SBUTTON FROM 080,100 TYPE 1 ACTION (_nOpc:=1,oDlg:END()) ENABLE Of oDlg
	
	ACTIVATE MSDIALOG oDlg centered
	
	If _nOpc = 1
		
		oFont08    := TFont():New( "Arial",,08,,.F.,,,,,.F. )
		oFont08n   := TFont():New( "Arial",,08,,.T.,,,,,.F. )
		oFont10n   := TFont():New( "Arial",,10,,.T.,,,,,.F. )
		oFont11    := TFont():New( "Arial",,11,,.F.,,,,,.F. )
		oFont12    := TFont():New( "Arial",,12,,.F.,,,,,.F. )
		oFont14n   := TFont():New( "Arial",,14,,.T.,,,,,.T. )
		oFont15    := TFont():New( "Arial",,15,,.F.,,,,,.F. )
		oPrn       := TMSPrinter():New()
		
		nOrdem := ascan(_aOrd,_cCombo)
		
		Pergunte("PXH068",.F.)
		
		cSemanaTerminal := Space( TamSx3("RC_SEMANA")[1] )
		dDataRef   		:= mv_par01			//Data de Referencia para a impressao
		Esc        		:= mv_par02			//Emitir Recibos(Adto/Folha/1¦/2¦/V.Extra)
		Semana     		:= mv_par03			//Numero da Semana
		cFilDe     		:= mv_par04			//Filial De
		cFilAte    		:= mv_par05			//Filial Ate
		cCcDe      		:= mv_par06			//Centro de Custo De
		cCcAte     		:= mv_par07			//Centro de Custo Ate
		cMatDe     		:= mv_par08			//Matricula Des
		cMatAte    		:= mv_par09			//Matricula Ate
		cNomDe     		:= mv_par10			//Nome De
		cNomAte    		:= mv_par11			//Nome Ate
		ChapaDe    		:= mv_par12			//Chapa De
		ChapaAte   		:= mv_par13			//Chapa Ate
		Mensag1    		:= mv_par14		 	//Mensagem 1
		Mensag2    		:= mv_par15			//Mensagem 2
		Mensag3    		:= mv_par16			//Mensagem 3
		cSituacao  		:= mv_par17			//Situacoes a Imprimir
		cCategoria 		:= mv_par18			//Categorias a Imprimir
		cBaseAux   		:= mv_par19			//Imprimir Bases
		cDeptoDe   		:= mv_par20			//Depto. De
		cDeptoAte  		:= mv_par21			//Depto. Ate
		nVias  			:= mv_par22			//Vias
		
		cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
		
		RptStatus({|lEnd| R030Imp(@lEnd,cMesAnoRef,.f.)},Titulo)  // Chamada do Relatorio
		
	Endif
	
Return( NIL )




Static Function R030Imp(lEnd,cMesAnoRef)
	
	Local aOrdBag     := {}
	Local cMesArqRef  := If(Esc == 4,"13"+Right(cMesAnoRef,4),cMesAnoRef)
	Local cArqMov     := ""
	Local aCodBenef   := {}
	Local aTInss	  := {}
	Local cAcessaSR1  := &("{ || " + ChkRH("GPER030","SR1","2") + "}")
	Local cAcessaSRA  := &("{ || " + ChkRH("GPER030 ","SRA","2") + "}")
	Local cAcessaSRC  := &("{ || " + ChkRH("GPER030","SRC","2") + "}")
	Local cAcessaSRI  := &("{ || " + ChkRH("GPER030","SRI","2") + "}")
	Local cNroHoras   := &("{ || If(SRC->RC_QTDSEM > 0 .And. cIRefSem == 'S', SRC->RC_QTDSEM, SRC->RC_HORAS) }")
	Local cHtml		  := ""
	Local nHoras      := 0
	Local nMes, nAno
	Local nX
	Local nBInssPA	  := 0 //Teto da base de INSS dos pro-labores/autonomos
	Local cMesCorrente:= If(GetMv("MV_TCFMFEC",,"2")=="2",getmv("MV_FOLMES"),mesano(dDataRef))
	Local cAnoMesCorr := cMesCorrente
	Local dDataLibRh
	Local cBkDtRef      :=""
	Local n             := 0
	Local nDias         := 0
	Local lFound		:= .F.
	
	Private nGera		:= 0
	Private tamanho     := "M"
	Private limite		:= 132
	Private cAliasMov 	:= ""
	Private cDtPago     := ""
	Private dBkDtRef 	:= cTod("")
	
	If Esc == 4
		cMesArqRef := "13" + Right(cMesAnoRef,4)
	Else
		cMesArqRef := cMesAnoRef
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Verifica se existe o arquivo de fechamento do mes informado  |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !OpenSrc( cMesArqRef, @cAliasMov, @aOrdBag, @cArqMov, @dDataRef , NIL ,.f. )
		Return(Nil)
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Selecionando a Ordem de impressao escolhida no parametro.    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "SRA")
	
	If nOrdem == 1			//"Matricula"
		dbSetOrder(1)
	ElseIf nOrdem == 2		//"C.Custo"
		dbSetOrder(2)
	ElseIf nOrdem == 3		//"Nome"
		dbSetOrder(3)
	Elseif nOrdem == 4		//"Chapa"
		cArqNtx  := CriaTrab(NIL,.f.)
		cIndCond :="RA_Filial + RA_Chapa + RA_Mat"
		IndRegua("SRA",cArqNtx,cIndCond,,,STR0012)		//"Selecionando Registros..."
		
	ElseIf nOrdem == 5		//"C.Custo + Nome"
		dbSetOrder(8)
	ElseIf nOrdem == 6		//"Depto"
		dbSetOrder(21)
	ElseIf nOrdem == 7		//"Depto. + Nome"
		dbSetOrder(22)
	Endif
	
	dbGoTop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Selecionando o Primeiro Registro e montando Filtro.          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOrdem == 1
		cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
		dbSeek(cFilDe + cMatDe,.T.)
		cFim    := cFilAte + cMatAte
	ElseIf nOrdem == 2
		dbSeek(cFilDe + cCcDe + cMatDe,.T.)
		cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
		cFim     := cFilAte + cCcAte + cMatAte
	ElseIf nOrdem == 3
		dbSeek(cFilDe + cNomDe + cMatDe,.T.)
		cInicio := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
		cFim    := cFilAte + cNomAte + cMatAte
	ElseIf nOrdem == 4
		dbSeek(cFilDe + ChapaDe + cMatDe,.T.)
		cInicio := "SRA->RA_FILIAL + SRA->RA_CHAPA + SRA->RA_MAT"
		cFim    := cFilAte + ChapaAte + cMatAte
	ElseIf nOrdem == 5
		dbSeek(cFilDe + cCcDe + cNomDe,.T.)
		cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
		cFim     := cFilAte + cCcAte + cNomAte
	ElseIf nOrdem == 6
		dbSeek(cFilDe + cDeptoDe + cMatDe,.T.)
		cInicio  := "SRA->RA_FILIAL + SRA->RA_DEPTO + SRA->RA_MAT"
		cFim     := cFilAte + cDeptoAte + cMatAte
	ElseIf nOrdem == 7
		dbSeek(cFilDe + cDeptoDe + cNomDe,.T.)
		cInicio  := "SRA->RA_FILIAL + SRA->RA_DEPTO + SRA->RA_NOME"
		cFim     := cFilAte + cDeptoAte + cNomAte
	Endif
	
	dbSelectArea("SRA")
	
	cAliasTMP := "QNRO"
	BeginSql alias cAliasTMP
		SELECT COUNT(*) as NROREG
		FROM %table:SRA% SRA
		WHERE      SRA.RA_FILIAL BETWEEN %exp:cFilDe%   AND %exp:cFilAte%
		AND SRA.RA_MAT    BETWEEN %exp:cMatDe%   AND %exp:cMatAte%
		AND SRA.RA_CC     BETWEEN %exp:cCCDe%    AND %exp:cCCAte%
		AND SRA.RA_DEPTO  BETWEEN %exp:cDeptoDe% AND %exp:cDeptoAte%
		AND SRA.%notDel%
	EndSql
	
	nRegProc := (cAliasTMP)->(NROREG)
	( cAliasTMP )->( dbCloseArea() )
	SetRegua(nRegProc)	// Total de elementos da regua
	
	dbSelectArea("SRA")
	
	TOTVENC:= TOTDESC:= FLAG:= CHAVE := 0
	
	Desc_Fil := Desc_End := DESC_CC:= DESC_FUNC:= ""
	Desc_Comp:= Desc_Est := Desc_Cid:= ""
	DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
	cFilialAnt := Space(FWGETTAMFILIAL)
	Vez        := 0
	OrdemZ     := 0
	
	While SRA->( !Eof() .And. &cInicio <= cFim )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Movimenta Regua Processamento                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		IncRegua()  // Anda a regua
		
		If lEnd
			@Prow()+1,0 PSAY cCancel
			Exit
		Endif
		
		If (SRA->RA_CHAPA < ChapaDe)   .Or. (SRA->RA_CHAPa > ChapaAte) .Or. ;
				(SRA->RA_NOME < cNomDe)    .Or. (SRA->RA_NOME > cNomAte)   .Or. ;
				(SRA->RA_MAT < cMatDe)     .Or. (SRA->RA_MAT > cMatAte)    .Or. ;
				(SRA->RA_CC < cCcDe)       .Or. (SRA->RA_CC > cCcAte)      .Or. ;
				(SRA->RA_DEPTO < cDeptoDe) .Or. (SRA->RA_DEPTO > cDeptoAte)
			
			SRA->(dbSkip(1))
			Loop
		EndIf
		
		
		aLanca:={}         // Zera Lancamentos
		aProve:={}         // Zera Lancamentos
		aDesco:={}         // Zera Lancamentos
		aBases:={}         // Zera Lancamentos
		nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00
		
		Ordem_rel := 1     // Ordem dos Recibos
		
		cSitFunc := SRA->RA_SITFOLH
		dDtPesqAf:= CTOD("01/" + Left(cMesAnoRef,2) + "/" + Right(cMesAnoRef,4),"DDMMYY")
		If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
			cSitFunc := " "
		Endif
		
		If !( cSitFunc $ cSituacao ) .OR.  ! ( SRA->RA_CATFUNC $ cCategoria )
			dbSkip()
			Loop
		Endif
		If cSitFunc $ "D" .And. Mesano(SRA->RA_DEMISSA) # Mesano(dDataRef)
			dbSkip()
			Loop
		Endif
		
		If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
			dbSkip()
			Loop
		EndIf
		
		If SRA->RA_Filial # cFilialAnt
			If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. ! fInfo(@aInfo,Sra->Ra_Filial)
				Exit
			Endif
			Desc_Fil := aInfo[3]
			Desc_End := aInfo[4] 	// Dados da Filial
			Desc_CGC := If( Len(aInfo) >= 27 .And. !Empty( aInfo[27] ), aInfo[27], aInfo[8] )
			DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
			Desc_Est := Substr(fDesc("SX5","12"+aInfo[6] ,"X5DESCRI()"),1,12)
			Desc_Comp:= aInfo[14] 	// Complemento Cobranca
			Desc_Cid := aInfo[5]
		End_Compl:= aInfo[4] + " " + aInfo[13] + " " + aInfo[05] + " " +;
			aInfo[06] + " " + aInfo[07]//endereço + bairro + cidade + estado + cep
		Desc_EndC:= End_Compl
		// MENSAGENS
		If !Empty(MENSAG1)
			If FPHIST82(SRA->RA_FILIAL, "06", RHTamFilial(SRA->RA_FILIAL)+MENSAG1)
				DESC_MSG1 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL, "06", RhTamFilial(Space(FWGETTAMFILIAL))+MENSAG1)
				DESC_MSG1 := Left(SRX->RX_TXT,30)
			Endif
		Endif
		
		If !Empty(MENSAG2)
			If FPHIST82(SRA->RA_FILIAL, "06", RHTamFilial(SRA->RA_FILIAL)+MENSAG2)
				DESC_MSG2 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL, "06",  RhTamFilial(Space(FWGETTAMFILIAL))+MENSAG2)
				DESC_MSG2 := Left(SRX->RX_TXT,30)
			Endif
		Endif
		
		If !Empty(MENSAG3)
			If FPHIST82(SRA->RA_FILIAL, "06", RHTamFilial(SRA->RA_FILIAL)+MENSAG3)
				DESC_MSG3 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL, "06",  RhTamFilial(Space(FWGETTAMFILIAL))+MENSAG3)
				DESC_MSG3 := Left(SRX->RX_TXT,30)
			Endif
		Endif
		dbSelectArea("SRA")
		cFilialAnt := SRA->RA_FILIAL
	Endif
	
	Totvenc := Totdesc := 0
	
	//Carrega tabela de INSS para utilizacao nos pro-labores/autonomos
	If !cPaisLoc $ "CHI|PAR"
		Car_inss(@aTInss,MesAno(dDataRef))
	EndIf
	
	If Len(aTinss) > 0
		nBInssPA := aTinss[Len(aTinss),1]
	EndIf
	
	If Esc == 1 .OR. Esc == 2
		DbSelectArea("SRC")
		dbSetOrder(1)
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
			While !Eof() .And. SRC->RC_FILIAL+SRC->RC_MAT == SRA->RA_FILIAL+SRA->RA_MAT
				If SRC->RC_SEMANA # Semana
					dbSkip()
					Loop
				Endif
				If !Eval(cAcessaSRC)
					dbSkip()
					Loop
				EndIf
				If (Esc == 1) .And. (Src->Rc_Pd == aCodFol[7,1])      // Desconto de Adto
					fSomaPdRec("P",aCodFol[6,1],Eval(cNroHoras),SRC->RC_VALOR)
					TOTVENC += Src->Rc_Valor
				Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[12,1])
					fSomaPdRec("D",aCodFol[9,1],Eval(cNroHoras),SRC->RC_VALOR)
					TOTDESC += SRC->RC_VALOR
				Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[8,1])
					fSomaPdRec("P",aCodFol[8,1],Eval(cNroHoras),SRC->RC_VALOR)
					TOTVENC += SRC->RC_VALOR
				Else
					If PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
						If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
							nHoras := Eval(cNroHoras)
							fSomaPdRec("P",SRC->RC_PD,nHoras,SRC->RC_VALOR)
							TOTVENC += Src->Rc_Valor
						Endif
					Elseif SRV->RV_TIPOCOD == "2"
						If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
							fSomaPdRec("D",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR)
							TOTDESC += Src->Rc_Valor
						Endif
					Elseif SRV->RV_TIPOCOD == "3"
						If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
							fSomaPdRec("B",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR)
						Endif
					Endif
				Endif
				If ESC = 1
					If SRC->RC_PD == aCodFol[10,1]
						nBaseIr := SRC->RC_VALOR
					Endif
				ElseIf SRC->RC_PD == aCodFol[13,1]
					nAteLim += SRC->RC_VALOR
				ElseIf SRC->RC_PD == aCodFol[221,1]
					nAteLim += SRC->RC_VALOR
					nAteLim := Min( nAteLim, nBInssPA )
					// BASE FGTS SAL, 13.SAL E DIF DISSIDIO E DIF DISSIDIO 13
				Elseif SRC->RC_PD$ aCodFol[108,1]+'*'+aCodFol[17,1]+'*'+ aCodFol[337,1]+'*'+aCodFol[398,1]
					nBaseFgts += SRC->RC_VALOR
					// VALOR FGTS SAL, 13.SAL E DIF DISSIDIO E DIF.DISSIDIO 13
				Elseif SRC->RC_PD$ aCodFol[109,1]+'*'+aCodFol[18,1]+'*'+aCodFol[339,1]+'*'+aCodFol[400,1]
					nFgts += SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[15,1]
					nBaseIr += SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[16,1]
					nBaseIrFe += SRC->RC_VALOR
				Endif
				dbSelectArea("SRC")
				dbSkip()
			Enddo
		Endif
	Elseif Esc == 3 .And. !(cPaisLoc $ "URU|ARG|PAR")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Busca os codigos de pensao definidos no cadastro beneficiario³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		fBusCadBenef(@aCodBenef, "131",{aCodfol[172,1]})
		dbSelectArea("SRC")
		dbSetOrder(1)
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT == SRC->RC_FILIAL + SRC->RC_MAT
				If !Eval(cAcessaSRC)
					dbSkip()
					Loop
				EndIf
				If SRC->RC_PD == aCodFol[22,1] .And. !(SRC->RC_TIPO2 $ "K/R")
					fSomaPdRec("P",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR)
					TOTVENC += SRC->RC_VALOR
				Elseif Ascan(aCodBenef, { |x| x[1] == SRC->RC_PD }) > 0
					fSomaPdRec("D",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR)
					TOTDESC += SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[108,1] .Or. SRC->RC_PD == aCodFol[109,1] .Or. SRC->RC_PD == aCodFol[173,1] .or. SRC->RC_PD ==aCodFol[398,1] .Or. SRC->RC_PD == aCodFol[400,1] // acresc.dif.dissidio.13.sal
					fSomaPdRec("B",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR)
				Endif
				
				If SRC->RC_PD == aCodFol[108,1] .or. SRC->RC_PD == aCodFol[398,1] // base fgts 13.sal e base fgts dif.dissidio 13.sal.
					nBaseFgts := SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[109,1] .or. SRC->RC_PD == aCodFol[400,1] // vlr fgts 13.sal e vlr fgts dif. dissidio 13.sal.
					nFgts     := SRC->RC_VALOR
				Endif
				dbSelectArea("SRC")
				dbSkip()
			Enddo
		Endif
	Elseif Esc == 4 .or. If(cPaisLoc $ "URU|ARG|PAR", Esc ==3,.F.)
		dbSelectArea("SRI")
		dbSetOrder(1)
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT == SRI->RI_FILIAL + SRI->RI_MAT
				If !Eval(cAcessaSRI)
					dbSkip()
					Loop
				EndIf
				If PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPdRec("P",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
					TOTVENC = TOTVENC + SRI->RI_VALOR
				Elseif SRV->RV_TIPOCOD == "2"
					fSomaPdRec("D",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
					TOTDESC = TOTDESC + SRI->RI_VALOR
				Elseif SRV->RV_TIPOCOD == "3"
					fSomaPdRec("B",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
				Endif
				
				If SRI->RI_PD == aCodFol[19,1]
					nAteLim += SRI->RI_VALOR
				Elseif SRI->RI_PD$ aCodFol[108,1] .or.  SRI->RI_PD$ aCodFol[398,1] // acrescido base fgts dif.dissidio 13.sal.
					nBaseFgts += SRI->RI_VALOR
				Elseif SRI->RI_PD$ aCodFol[109,1] .or.  SRI->RI_PD$ aCodFol[400,1] // acrescido vlr fgts dif.dissidio 13.sal.
					nFgts += SRI->RI_VALOR
				Elseif SRI->RI_PD == aCodFol[27,1]
					nBaseIr += SRI->RI_VALOR
				Endif
				dbSkip()
			Enddo
		Endif
	Elseif Esc == 5
		dbSelectArea("SR1")
		dbSetOrder(2)
		dBkDtRef:= dDataRef
		nDias:= F_ULTDIA(dBkDtRef)
		
		For n:=1 to nDias
			If lFound	:= dbSeek (SRA->RA_FILIAL + SRA->RA_MAT + dTos(dBkDtRef))
				Exit
			Endif
			dBkDtRef:= dBkDtRef + 1
		Next
		
		If ( !lFound )
			dbSeek (SRA->RA_FILIAL + SRA->RA_MAT + MesAno(dBkDtRef))
		EndIf
		
		cBkDtRef:=MesAno(dBkDtRef)
		
		While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT + cBkDtRef ==	SR1->R1_FILIAL + SR1->R1_MAT + MesAno(SR1->R1_DATA)
			If Semana # "99"
				If SR1->R1_SEMANA # Semana
					dbSkip()
					Loop
				Endif
			Endif
			If !Eval(cAcessaSR1)
				dbSkip()
				Loop
			EndIf
			If PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
				fSomaPdRec("P",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
				TOTVENC = TOTVENC + SR1->R1_VALOR
			Elseif SRV->RV_TIPOCOD == "2"
				fSomaPdRec("D",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
				TOTDESC = TOTDESC + SR1->R1_VALOR
			Elseif SRV->RV_TIPOCOD == "3"
				fSomaPdRec("B",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
			Endif
			dbskip()
			If ( lFound .AND. !(cBkDtRef == MesAno(SR1->R1_DATA)) )
				cBkDtRef:=MesAno(SR1->R1_DATA)
			EndIf
		Enddo
		
	Endif
	
	dbSelectArea("SRA")
	
	If TOTVENC = 0 .And. TOTDESC = 0
		dbSkip()
		Loop
	Endif
	
	If Vez == 0  .And.  Esc == 2 //--> Verifica se for FOLHA.
		PerSemana() // Carrega Datas referentes a Semana.
	EndIf
	
	fImpreZebr()
	
	ASize(AProve,0)
	ASize(ADesco,0)
	ASize(aBases,0)
	
	dbSelectArea("SRA")
	SRA->( dbSkip() )
	TOTDESC := TOTVENC := 0
	nGera++
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona arq. defaut do Siga caso Imp. Mov. Anteriores      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty( cAliasMov )
	fFimArqMov( cAliasMov , aOrdBag , cArqMov )
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SRC")
dbSetOrder(1)          // Retorno a ordem 1
dbSelectArea("SRI")
dbSetOrder(1)          // Retorno a ordem 1
dbSelectArea("SRA")
SET FILTER TO
RetIndex("SRA")

If !(Type("cArqNtx") == "U")
	fErase(cArqNtx + OrdBagExt())
Endif

//	Set Device To Screen

oPrn:Preview()


Return( cHtml )




/*
Função		:	fImpreZebr
Autor 		: 	R.H. - Ze Maria
Data 		: 	14.03.95
Descrição 	: 	IMRESSAO DO RECIBO FORMULARIO ZEBRADO
Sintaxe   	:	fImpreZebr()
*/
Static Function fImpreZebr()
	
	Local nConta    := nContr := nContrT:=0
	
	nTermina  	:= 0
	
	Li := 20
	
	_cVia := ''
	If nVias = 2
		_cVia := '1ª Via : Empregador'
	Endif
	
	nTermina := Max(Max(LEN(aProve),LEN(aDesco)),LEN(aBases))
	
	oPrn:StartPage()
	
	fCabecZ()
	fLancaZ(nConta)
		
	If nVias = 2
		If nTermina <= _nQtVerb
			oPrn:Say (li, 030,Replicate("-",130), oFont15)
			li+=50
		Else
			oPrn:EndPage()
			oPrn:StartPage()
			Li := 20
		Endif
		_cVia := '2ª Via : Empregado'
		fCabecZ()
		fLancaZ(nConta)
	Endif
	
	oPrn:EndPage()
	
	ASize(AProve,0)
	ASize(ADesco,0)
	ASize(aBases,0)
	
Return Nil


Static Function fCabecZ()   // Cabecalho do Recibo Zebrado
	
	cBitMap:= "lgrl"+Alltrim(SM0->M0_CODIGO+SM0->M0_CODFIL)+".bmp"
	
	If !Empty(_cVia)
		oPrn:Line(li+10,2000,li+60,2000)
		oPrn:Line(li+60,2000,li+60,2320)
		oPrn:Say(li+20, 2010, _cVia, ofont08,100)
	Endif
	oPrn:Box(li+10,030,li+460,2320)
	If nTermina <= _nQtVerb
		oPrn:Box(li+470,030,li+1220,2320)
		oPrn:Line(li+470,790,li+1220,790)
		oPrn:Line(li+470,1590,li+1220,1590)
		oPrn:Box(li+1230,030,li+1500,2320)
		oPrn:Line(li+1230,790,li+1500,790)
		oPrn:Line(li+1230,1590,li+1500,1590)
		liAux := li+1230
	Else
		oPrn:Box(li+470,030,li+2720,2320)
		oPrn:Line(li+470,790,li+2720,790)
		oPrn:Line(li+470,1590,li+2720,1590)
		oPrn:Box(li+2730,030,li+3000,2320)
		oPrn:Line(li+2730,790,li+3000,790)
		oPrn:Line(li+2730,1590,li+3000,1590)
		liAux := li+2730
	Endif

	li+=110
	
	oPrn:Say (li, 880, "RECIBO DE PAGAMENTO", ofont14n,100)
	//                    Altura /comprimento
	oPrn:SayBitmap( li-80,050,cBitMap,320,150 )
	li+=110
	oPrn:Say (li, 050, "CNPJ   : "+Transform(Desc_CGC,"@R 99.999.999/9999-99"), ofont08,100)
	li+=50
	oPrn:Say (li, 050, "Empresa: "+Desc_Fil, ofont08,100)
	If !Empty(Semana) .And. Semana # "99" .And.  Upper(SRA->RA_TIPOPGT) == "S"
		oPrn:Say (li, 1600, 'Sem.' + Semana + " (" + cSem_De + ' a ' + cSem_Ate + ")", ofont08,100)
	Else
		oPrn:Say (li, 1600, MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4), ofont08,100)
	EndIf
	ORDEMZ ++
	li+=50
	oPrn:Say (li, 050, "C Custo   : " + SRA->RA_CC + " - " + DescCc(SRA->RA_CC,SRA->RA_FILIAL), ofont08,100)
	oPrn:Say (li, 1600, "Ordem : "+StrZero(ORDEMZ,4), ofont08,100)
	LI+= 50
	oPrn:Say (li, 050, "Matricula : " + SRA->RA_MAT+" - "+ "Nome : "+SRA->RA_NOME, ofont08,100)
	oPrn:Say (li, 1600, "Local : "+SRA->RA_FILIAL, ofont08,100)
	LI += 50
	oPrn:Say (li, 050, "Funcao    : "+SRA->RA_CODFUNC+" - "+DescFun(SRA->RA_CODFUNC,SRA->RA_FILIAL), ofont08,100)
	LI += 70
	oPrn:Say (li, 050, "P R O V E N T O S", ofont08n,100)
	oPrn:Say (li, 0800, "D E S C O N T O S", ofont08n,100)
	oPrn:Say (li, 1600, "B A S E S", ofont08n,100)
	LI += 70
	
Return Nil


Static Function fLancaZ(nConta)   // Impressao dos Lancamentos
	
	Local nCont     := 0
	
	For nCont := 1 To nTermina
		
		IF nCont <= LEN(aProve)
			oPrn:Say (li, 050, aProve[nCont,1], ofont08,100)
			oPrn:Say (li, 500, TRANSFORM(aProve[nCont,2],'999.99'), ofont08,100,,,1)
			oPrn:Say (li, 700, TRANSFORM(aProve[nCont,3],"@E 999,999.99"), ofont08,100,,,1)
		ENDIF
		IF nCont <= LEN(aDesco)
			oPrn:Say (li, 800, aDesco[nCont,1], ofont08,100,,,0)
			oPrn:Say (li, 1250, TRANSFORM(aDesco[nCont,2],'999.99'), ofont08,100,,,1)
			oPrn:Say (li, 1450, TRANSFORM(aDesco[nCont,3],"@E 999,999.99"), ofont08,100,,,1)
		ENDIF
		IF nCont <= LEN(aBases)
			oPrn:Say (li, 1600, aBases[nCont,1], ofont08,100,,,0)
			oPrn:Say (li, 2050, TRANSFORM(aBases[nCont,2],'999.99'), ofont08,100,,,1)
			oPrn:Say (li, 2250, TRANSFORM(aBases[nCont,3],"@E 999,999.99"), ofont08,100,,,1)
		ENDIF

		Li += 50
		
	Next
	
	Li := liAux + 30
	oPrn:Say (li, 0050,DESC_MSG1, ofont08,100)
	oPrn:Say (li, 0800,"TOTAL BRUTO     "+SPACE(10)+TRANS(TOTVENC,"@E 999,999,999.99"), ofont08,100)
	oPrn:Say (li, 1600,"TOTAL DESCONTOS     "+SPACE(07)+TRANS(TOTDESC,"@E 999,999,999.99")	, ofont08,100)
	LI += 60
	oPrn:Say (li, 025,DESC_MSG2, ofont08,100)
	LI += 60
	oPrn:Say (li, 0025,DESC_MSG3, ofont08,100)
	oPrn:Say (li, 0800,"CREDITO:"+SRA->RA_BCDEPSAL+"-"+DescBco(SRA->RA_BCDEPSAL,SRA->RA_FILIAL), ofont08,100)
	oPrn:Say (li, 1600,"LIQUIDO A RECEBER     "+SPACE(05)+TRANS((TOTVENC-TOTDESC),"@E 999,999,999.99"), ofont08,100)
	LI += 60
	oPrn:Say (li, 0800,"CONTA:" + SRA->RA_CTDEPSAL		, ofont08,100)
	li+=100
	If cBaseAux = 1
		oPrn:Say (li, 050,"Sal.Contr.Inss: " + Transform(nAteLim,"@E 999,999,999.99")+space(30)+"Base Fgts: "+Transform(nBaseFgts,"@E 999,999,999.99")+space(30)+" Fgts Mes: "+Transform(nFgts,"@e 999,999.99"), ofont08,100)
	Endif
	LI += 080
	oPrn:Say (li, 050,"Recebi o valor acima em       ___/___/___      " + Replicate("_",40), ofont08,100)
	
	li+=50
	
Return Nil



Static Function PerSemana() // Pesquisa datas referentes a semana.
	Local cChaveSem	:= ""
	
	dbSelectArea( "RCF" )
	
	If !Empty(Semana)
		
		cChaveSem := StrZero(Year(dDataRef),4)+StrZero(Month(dDataRef),2)+SRA->RA_TNOTRAB
		
		If !dbSeek(xFilial("RCF") + cChaveSem + Semana, .T. )
			cChaveSem := StrZero(Year(dDataRef),4)+StrZero(Month(dDataRef),2)+"   "
			If !dbSeek(xFilial("RCF") + cChaveSem + Semana  )
				HELP( " ",1,"GPCALEND",  )						//--Nao existe periodo cadastrado
				Return(NIL)
			Endif
		Endif
		cSem_De  := DtoC(RCF->RCF_DTINI,'DDMMYY')
		cSem_Ate := DtoC(RCF->RCF_DTFIM,'DDMMYY')
	EndIf
	
Return Nil

/*
Funçãoo  	:	fSomaPdRec
Autor 		: 	R.H. - Mauro
Data 		:	24.09.95
Descrição 	:	Somar as Verbas no Array
Sintaxe		:	fSomaPdRec(Tipo,Verba,Horas,Valor)
*/
Static Function fSomaPdRec(cTipo,cPd,nHoras,nValor)
	
	Local Desc_paga
	
	Desc_paga := DescPd(cPd,Sra->Ra_Filial)  // mostra como pagto
	
	If cTipo # 'B'
		//--Array para Recibo Pre-Impresso
		nPos := Ascan(aLanca,{ |X| X[2] = cPd })
		If nPos == 0
			Aadd(aLanca,{cTipo,cPd,Desc_Paga,nHoras,nValor})
		Else
			aLanca[nPos,4] += nHoras
			aLanca[nPos,5] += nValor
		Endif
	Endif
	
	//--Array para o Recibo Pre-Impresso
	If cTipo = 'P'
		cArray := "aProve"
	Elseif cTipo = 'D'
		cArray := "aDesco"
	Elseif cTipo = 'B'
		cArray := "aBases"
	Endif
	
	nPos := Ascan(&cArray,{ |X| X[1] = cPd })
	If nPos == 0
		Aadd(&cArray,{cPd+"-"+Desc_Paga,nHoras,nValor })
	Else
		&cArray[nPos,2] += nHoras
		&cArray[nPos,3] += nValor
	Endif
Return



Static Function AtuSX1()
	
	cPerg  := "PXH068"
	
	//    	  Grupo/Ordem/Pergunta    				/perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid     		/Var01     /Def01    	/defspa1/defeng1/Cnt01  /Var02/Def02			/Defspa2/defeng2/Cnt02/Var03/Def03		/defspa3/defeng3/Cnt03/Var04/Def04		/defspa4/defeng4/Cnt04/Var05/Def05			/deefspa5/defeng5/Cnt05/F3		/cPyme	/cGrpSxg/cHelp
	U_CRIASX1(cPerg,"01" ,"Data de Referencia ?"    ,""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G","naovazio"		,"MV_PAR01",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,""		,		,		,".RHDTREF.")
	U_CRIASX1(cPerg,"02" ,"Imprimir Recibos ?"		,""       ,""      ,"mv_ch2","N" ,01     ,0      ,0     ,"C",""        		,"MV_PAR02","Adto."   	,""     ,""     ,""     ,""   ,"Folha"			,""     ,""     ,""   ,""   ,"1ªParc."  ,""     ,""     ,""   ,""   ,"2ªParc."  ,""     ,""     ,""   ,""   ,"Val.Extras"   ,""      ,""     ,""   ,""		,		,		,		)
	U_CRIASX1(cPerg,"03" ,"Numero da Semana ?"		,""       ,""      ,"mv_ch3","C" ,02     ,0      ,0     ,"G",""        		,"MV_PAR03",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,""		,		,		,".RHSEMAN.")
	U_CRIASX1(cPerg,"04" ,"Filial De ?"				,""       ,""      ,"mv_ch4","C" ,05     ,0      ,0     ,"G","naovazio"		,"MV_PAR04",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,"XM0"	,		,		,".RHFILDE.")
	U_CRIASX1(cPerg,"05" ,"Filial Ate ?"			,""       ,""      ,"mv_ch5","C" ,05     ,0      ,0     ,"G","naovazio"		,"MV_PAR05",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,"XM0"	,		,		,".RHFILAT.")
	U_CRIASX1(cPerg,"06" ,"Centro de Custo De ?"	,""       ,""      ,"mv_ch6","C" ,09     ,0      ,0     ,"G","naovazio"		,"MV_PAR06",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,"CTT"	,		,		,".RHCCDE.")
	U_CRIASX1(cPerg,"07" ,"Centro de Custo Ate ?"	,""       ,""      ,"mv_ch7","C" ,09     ,0      ,0     ,"G","naovazio"		,"MV_PAR07",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,"CTT"	,		,		,".RHCCAT.")
	U_CRIASX1(cPerg,"08" ,"Matricula De ?"			,""       ,""      ,"mv_ch8","C" ,06     ,0      ,0     ,"G","naovazio"		,"MV_PAR08",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,"SRA"	,		,		,".RHMATD.")
	U_CRIASX1(cPerg,"09" ,"Matricula Ate ?"			,""       ,""      ,"mv_ch9","C" ,06     ,0      ,0     ,"G","naovazio"		,"MV_PAR09",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,"SRA"	,		,		,".RHMATA.")
	U_CRIASX1(cPerg,"10" ,"Nome De ?"				,""       ,""      ,"mv_cha","C" ,30     ,0      ,0     ,"G","naovazio"		,"MV_PAR10",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,""		,		,		,".RHNOMED.")
	U_CRIASX1(cPerg,"11" ,"Nome Ate ?"				,""       ,""      ,"mv_chb","C" ,30     ,0      ,0     ,"G","naovazio"		,"MV_PAR11",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,""		,		,		,".RHNOMEA.")
	U_CRIASX1(cPerg,"12" ,"Chapa De ?"				,""       ,""      ,"mv_chc","C" ,05     ,0      ,0     ,"G",""        		,"MV_PAR12",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,""		,		,		,".RHCHAPAD.")
	U_CRIASX1(cPerg,"13" ,"Chapa Ate ?"				,""       ,""      ,"mv_chd","C" ,05     ,0      ,0     ,"G",""        		,"MV_PAR13",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,""		,		,		,".RHCHAPAT.")
	U_CRIASX1(cPerg,"14" ,"Mensagem 1 ?"			,""       ,""      ,"mv_che","C" ,01     ,0      ,0     ,"G",""        		,"MV_PAR14",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,""		,		,		,		)
	U_CRIASX1(cPerg,"15" ,"Mensagem 2 ?"			,""       ,""      ,"mv_chf","C" ,01     ,0      ,0     ,"G",""        		,"MV_PAR15",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,""		,		,		,		)
	U_CRIASX1(cPerg,"16" ,"Mensagem 3 ?"			,""       ,""      ,"mv_chg","C" ,01     ,0      ,0     ,"G",""        		,"MV_PAR16",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,""		,		,		,		)
	U_CRIASX1(cPerg,"17" ,"Situacoes a Imp. ?"		,""       ,""      ,"mv_chh","C" ,05     ,0      ,0     ,"G","fSituacao"	,"MV_PAR17",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,""		,		,		,".RHSITUA.")
	U_CRIASX1(cPerg,"18" ,"Categorias a Imp. ?"		,""       ,""      ,"mv_chi","C" ,15     ,0      ,0     ,"G","fCategoria"	,"MV_PAR18",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,""		,		,		,".RHCATEG.")
	U_CRIASX1(cPerg,"19" ,"Imprime Bases ?"			,""       ,""      ,"mv_chj","N" ,01     ,0      ,0     ,"C",""        		,"MV_PAR19","Sim"      	,""     ,""     ,""     ,""   ,"Nao"   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,""		,		,		,		)
	U_CRIASX1(cPerg,"20" ,"Depto. De ?"				,""       ,""      ,"mv_chk","C" ,09     ,0      ,0     ,"G",""        		,"MV_PAR20",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,"SQB"	,		,		,".RHDPTDE.")
	U_CRIASX1(cPerg,"21" ,"Depto. Ate ?"			,""       ,""      ,"mv_chl","C" ,09     ,0      ,0     ,"G",""        		,"MV_PAR21",""        	,""     ,""     ,""     ,""   ,""   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,"SQB"	,		,		,".RHDPTAT.")
	U_CRIASX1(cPerg,"22" ,"Qtde Vias ?"				,""       ,""      ,"mv_chm","N" ,01     ,0      ,0     ,"C",""        		,"MV_PAR22","1"        	,""     ,""     ,""     ,""   ,"2"   			,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   			,""      ,""     ,""   ,""		,		,		,		)
	
Return (Nil)
