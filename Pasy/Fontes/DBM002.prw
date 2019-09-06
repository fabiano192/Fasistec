#INCLUDE "PROTHEUS.CH"

#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF

/*
Programa: 	DBM002
Descrição: 	Recibo de Pagamneto via E-mail               
Autor:		Fabiano da Silva
Data:		16/06/2012                                    
*/
                                              
User Function DBM002()

LOCAL oDlg := NIL
Private aCodFol	   	:= {}

ATUSX1()()

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE "Recibo de Pagamento via e-mail" OF oDlg PIXEL

@ 010,017 SAY "Esta rotina tem por objetivo gerar o Recibo     " OF oDlg PIXEL Size 150,010 //FONT oFont2 COLOR CLR_BLUE
@ 020,017 SAY "de Pagamento via e-mail conforme os parâmetros  " OF oDlg PIXEL Size 150,010 //FONT oFont2 COLOR CLR_BLUE
@ 030,017 SAY "informados pelo usuário.                        " OF oDlg PIXEL Size 150,010 //FONT oFont2 COLOR CLR_BLUE
@ 040,017 SAY "                                                " OF oDlg PIXEL Size 150,010 //FONT oFont2 COLOR CLR_BLUE
@ 050,017 SAY "Programa DBM002.PRW                             " OF oDlg PIXEL Size 150,010 //FONT oFont1 COLOR CLR_RED

@ 70,030 BUTTON "Parametros" 	SIZE 036,012 ACTION ( Pergunte("DBM002"))    OF oDlg PIXEL
@ 70,090 BUTTON "OK" 			SIZE 036,012 ACTION (_nOpc:=1,oDlg:End()) OF oDlg PIXEL
@ 70,150 BUTTON "Sair"       	SIZE 036,012 ACTION (_nOpc:=0,oDlg:End()) OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

If _nOpc == 1
	
	Pergunte("DBM002",.F.)
	
	Private dDataRef   	:= MV_PAR02 			//Data de Referencia para a impressao
	//nTipRel    := MV_PAR01 , 3					)	//Tipo de Recibo (Pre/Zebrado/EMail)
	Private Esc        	:= MV_PAR01 			//Emitir Recibos(Adto/Folha/1¦/2¦)
	Private cMatDe     	:= mv_par03			//Matricula Des
	Private cMatAte    	:= mv_par04			//Matricula Ate
	Private cCcDe      	:= mv_par05			//Centro de Custo De
	Private cCcAte     	:= mv_par06			//Centro de Custo Ate
	Private cSituacao  	:= mv_par07			//Situacoes a Imprimir
	Private cCategoria 	:= mv_par08			//Categorias a Imprimir
	Private cBaseAux   	:= "S"				//Imprimir Bases
	Private cFilDe      := mv_par09			//Filial De
	Private cFilAte     := mv_par10			//Filial ate

	Private aLanca 	   	:= {}
	Private aProve 	   	:= {}
	Private aDesco 	   	:= {}
	Private aBases 	   	:= {}
	Private aInfo  	   	:= {}
	Private lEnvioOk   	:= .F.
	Private lRetCanc	:= .t.
	Private cIRefSem    := GetMv("MV_IREFSEM",,"S")
	Private	cMesAnoRef  := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
	Private Semana      := Space( TamSx3("RC_SEMANA")[1] )

	Private _lFim      	:= .F.
	Private _cMsg01    	:= ''
	Private _lAborta01 	:= .T.
	Private _bAcao01   	:= {|_lFim| DBM02A(@_lFim) }
	Private _cTitulo01 	:= 'Selecionado Registros!!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
Endif

Return(Nil)


Static Function DBM02A()

Local lIgual                 //Vari vel de retorno na compara‡ao do SRC
Local cArqNew                //Vari vel de retorno caso SRC # SX3
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
Local nTcfDadt		:= 0		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfDfol		:= 0		// indica a quantidade de dias a somar ou diminuir no ultimo dia do mes corrente para liberar a consulta do TCF
Local nTcfD131		:= 0		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfD132		:= 0		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfDext		:= 0		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local lNaoChkDFol	:= ( valtype(ntcfdfol)=="C" .And. Empty(alltrim(nTcfDFol)) )

Private nGera		:= 0
Private tamanho     := "M"
Private limite		:= 132
Private cAliasMov 	:= ""
Private cDtPago     := ""
Private cPict1	:=	"@E 999,999,999.99"
Private cPict2 := "@E 99,999,999.99"
Private cPict3 :=	"@E 999,999.99"

If MsDecimais(1) == 0
	cPict1	:=	"@E 99,999,999,999"
	cPict2 	:=	"@E 9,999,999,999"
	cPict3 	:=	"@E 99,999,999"
Endif

// Ajuste do tipo da variavel
nTcfDadt	:= if(valtype(ntcfdadt)=="C",val(ntcfdadt),ntcfdadt)
nTcfD131	:= if(valtype(nTcfD131)=="C",val(nTcfD131),nTcfD131)
nTcfD132	:= if(valtype(nTcfD132)=="C",val(nTcfD132),nTcfD132)
nTcfDfol	:= if(valtype(ntcfdfol)=="C",val(ntcfdfol),ntcfdfol)
nTcfDext	:= if(valtype(ntcfdext)=="C",val(ntcfdext),ntcfdext)

If Esc == 4
	cMesArqRef := "13" + Right(cMesAnoRef,4)
Else
	cMesArqRef := cMesAnoRef
Endif

If !OpenSrc( cMesArqRef, @cAliasMov, @aOrdBag, @cArqMov, @dDataRef , NIL )
	Return( NIL )
Endif

dbSelectArea( "SRA")
dbSetOrder(1)

dbGoTop()

cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
dbSeek(cFilDe + cMatDe,.T.)
cFim    := cFilAte + cMatAte

dbSelectArea("SRA")

cAliasTMP := "QNRO"
BeginSql alias cAliasTMP
	SELECT COUNT(*) as NROREG
	FROM %table:SRA% SRA
	WHERE      SRA.RA_FILIAL BETWEEN %exp:cFilDe% AND %exp:cFilAte%
	AND SRA.RA_MAT    BETWEEN %exp:cMatDe% AND %exp:cMatAte%
	AND SRA.RA_CC     BETWEEN %exp:cCCDe%  AND %exp:cCCAte%
	AND SRA.%notDel%
EndSql

nRegProc := (cAliasTMP)->(NROREG)
( cAliasTMP )->( dbCloseArea() )

//GPProcRegua(nRegProc)// Total de elementos da regua

dbSelectArea("SRA")


TOTVENC:= TOTDESC:= FLAG:= CHAVE := 0

Desc_Fil := Desc_End := DESC_CC:= DESC_FUNC:= ""
Desc_Comp:= Desc_Est := Desc_Cid:= ""
DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
cFilialAnt := Space(FWGETTAMFILIAL)
Vez        := 0
OrdemZ     := 0

While SRA->( !Eof() .And. &cInicio <= cFim )
	
//	GPIncProc(SRA->RA_FILIAL+" - "+SRA->RA_MAT+" - "+SRA->RA_NOME)
	
	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif
	
	If (SRA->RA_MAT < cMatDe)     .Or. (SRA->Ra_MAT > cMatAte)     .Or. ;
		(SRA->RA_CC < cCcDe)       .Or. (SRA->Ra_CC > cCcAte)
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
	
	If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. ! fInfo(@aInfo,Sra->Ra_Filial)
		Exit
	Endif

	Totvenc := Totdesc := 0
	Desc_Fil := aInfo[3]
	Desc_End := aInfo[4] 	// Dados da Filial
	Desc_CGC := aInfo[8]
	DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
	Desc_Est := Substr(fDesc("SX5","12"+aInfo[6] ,"X5DESCRI()"),1,12)
	Desc_Comp:= aInfo[14] 	// Complemento Cobranca
	Desc_Cid := aInfo[5] 
	End_Compl:= aInfo[4] + " " + aInfo[13] + " " + aInfo[05] + " " +;
				aInfo[06] + " " + aInfo[07]//endereço + bairro + cidade + estado + cep
	Desc_EndC:= End_Compl
	
	//Carrega tabela de INSS para utilizacao nos pro-labores/autonomos
	Car_inss(@aTInss,MesAno(dDataRef))
	
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
	Elseif Esc == 3
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
	Elseif Esc == 4
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
	Endif
	dbSelectArea("SRA")
	
	If TOTVENC = 0 .And. TOTDESC = 0
		dbSkip()
		Loop
	Endif
	
	cHtml := fSendDPgto()   //Monta o corpo do e-mail e envia-o
	
	dbSelectArea("SRA")
	SRA->( dbSkip() )
	
	TOTDESC := TOTVENC := 0
	nGera++
EndDo

If !Empty( cAliasMov )
	fFimArqMov( cAliasMov , aOrdBag , cArqMov )
EndIf

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

Set Device To Screen

If lEnvioOK
	APMSGINFO("Email enviado com sucesso ")
Else
	APMSGINFO("Email nao pode ser enviado ")
EndIf

SeTPgEject(.F.)
nlin:= 0

MS_FLUSH()

Return( cHtml )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fSomaPdRec³ Autor ³ R.H. - Mauro          ³ Data ³ 24.09.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Somar as Verbas no Array                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fSomaPdRec(Tipo,Verba,Horas,Valor)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fSomaPdRec(cTipo,cPd,nHoras,nValor)

Local Desc_paga

Desc_paga := DescPd(cPd,Sra->Ra_Filial)  // mostra como pagto

If cTipo # 'B'
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
	Aadd(&cArray,{cPd+" "+Desc_Paga,nHoras,nValor })
Else
	&cArray[nPos,2] += nHoras
	&cArray[nPos,3] += nValor
Endif

Return




/*
Envio de E-mail -Demonstrativo de Pagamento
*/
Static Function fSendDPgto()

Local aSvArea		:= GetArea()
Local aGetArea		:= {}
Local cEmail		:= If(SRA->RA_RECMAIL=="S",SRA->RA_EMAIL,"    ")
Local cHtml			:= ""
Local cHtmlAux		:= NIL
Local cSubject		:= " DEMONSTRATIVO DE PAGAMENTO "
Local cMesComp		:= IF( Month(dDataRef) + 1 > 12 , 01 , Month(dDataRef) )
Local cTipo			:= ""
Local cReferencia	:= ""
Local cVerbaLiq		:= ""
Local dDataPagto	:= Ctod("//")
Local nZebrado		:= 0.00
Local nResto		:= 0.00
Local nProv
Local nDesco
Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario

Private cMailConta	:= NIL
Private cMailServer	:= NIL
Private cMailSenha	:= NIL
Private nSalario		:= 0

IF Esc == 1
	aGetArea	:= SRC->( GetArea() )
	cTipo		:= "Adiantamento" //
	cVerbaLiq	:= PosSrv( "007ADT" , xFilial("SRA") , "RV_COD" , RetOrdem("SRV","RV_FILIAL+RV_CODFOL") , .F. )
	SRC->( dbSetOrder( RetOrdem("SRC","RC_FILIAL+RC_MAT+RC_PD+RC_CC+RC_SEMANA+RC_SEQ") ) )
	IF SRC->( dbSeek( SRA->( RA_FILIAL + RA_MAT ) + cVerbaLiq ) )
		While SRC->( !Eof() .and. RC_FILIAL + RC_MAT == SRA->( RA_FILIAL + RA_MAT ) )
			IF Empty( Semana ) .or. ( SRC->RC_SEMANA == Semana )
				dDataPagto := SRC->RC_DATA
				Exit
			EndIF
			SRC->( dbSkip() )
		End While
	EndIF
	RestArea( aGetArea )
ElseIF Esc == 2
	aGetArea	:= SRC->( GetArea() )
	cTipo := "Folha"
	cVerbaLiq	:= PosSrv( "047CAL" , xFilial("SRA") , "RV_COD" , RetOrdem("SRV","RV_FILIAL+RV_CODFOL") , .F. )
	SRC->( dbSetOrder( RetOrdem("SRC","RC_FILIAL+RC_MAT+RC_PD+RC_CC+RC_SEMANA+RC_SEQ") ) )
	IF SRC->( dbSeek( SRA->( RA_FILIAL + RA_MAT ) + cVerbaLiq ) )
		While SRC->( !Eof() .and. RC_FILIAL + RC_MAT == SRA->( RA_FILIAL + RA_MAT ) )
			IF Empty( Semana ) .or. ( SRC->RC_SEMANA == Semana )
				dDataPagto := SRC->RC_DATA
				Exit
			EndIF
			SRC->( dbSkip() )
		End While
	EndIF
	RestArea( aGetArea )
ElseIF Esc == 3
	aGetArea	:= SRC->( GetArea() )
	cTipo := "1a. Parcela do 13o."
	cVerbaLiq	:= PosSrv( "022C13" , xFilial("SRA") , "RV_COD" , RetOrdem("SRV","RV_FILIAL+RV_CODFOL") , .F. )
	SRC->( dbSetOrder( RetOrdem("SRC","RC_FILIAL+RC_MAT+RC_PD+RC_CC+RC_SEMANA+RC_SEQ") ) )
	IF SRC->( dbSeek( SRA->( RA_FILIAL + RA_MAT ) + cVerbaLiq ) )
		While SRC->( !Eof() .and. RC_FILIAL + RC_MAT == SRA->( RA_FILIAL + RA_MAT ) )
			IF Empty( Semana ) .or. ( SRC->RC_SEMANA == Semana )
				dDataPagto := SRC->RC_DATA
				Exit
			EndIF
			SRC->( dbSkip() )
		End While
	EndIF
	RestArea( aGetArea )
ElseIF Esc == 4
	aGetArea	:= SRI->( GetArea() )
	cTipo := "2a. Parcela do 13o."
	cVerbaLiq	:= PosSrv( "021C13" , xFilial("SRA") , "RV_COD" , RetOrdem("SRV","RV_FILIAL+RV_CODFOL") , .F. )
	SRI->( dbSetOrder( RetOrdem("SRI","RI_FILIAL+RI_MAT+RI_PD") ) )
	IF SRI->( dbSeek( SRA->( RA_FILIAL + RA_MAT ) + cVerbaLiq ) )
		dDataPagto := SRI->RI_DATA
	EndIF
EndIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busca parametros                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMailConta	:=If(cMailConta == NIL,GETMV("MV_EMCONTA"),cMailConta)             //Conta utilizada p/envio do email
cMailServer	:=If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer)           //Server
cMailSenha	:=If(cMailSenha == NIL,GETMV("MV_EMSENHA"),cMailSenha)

If Empty(cEmail)
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe o SMTP Server                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If 	Empty(cMailServer)
	Help(" ",1,"SEMSMTP")//"O Servidor de SMTP nao foi configurado !!!" ,"Atencao"
	Return(.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe a CONTA                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If 	Empty(cMailServer)
	Help(" ",1,"SEMCONTA")//"A Conta do email nao foi configurado !!!" ,"Atencao"
	Return(.F.)
EndIf


cReferencia	:= AllTrim( MesExtenso(Month(dDataRef))+"/"+STR(YEAR(dDataRef),4) ) + " - ( " + cTipo + " )"

IF !Empty( cAliasMov )
	nSalario := fBuscaSal( dDataRef,,,.F. )
	IF ( nSalario == 0 )
		nSalario := SRA->RA_SALARIO
	EndIf
Else
	nSalario := SRA->RA_SALARIO
EndIF


cHtml +=	'<?xml version="1.0" encoding="iso-8859-1"?>'
cHtml +=	'<!doctype html public "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
cHtml +=	'<html xmlns="http://www.w3.org/1999/xhtml">'
cHtml +=		'<head>'
cHtml += 		'<title>DEMONSTRATIVO DE PAGAMENTO</title>'
cHtml +=	'</head>'
cHtml +=		'<body bgcolor="#F0F0F0"  topmargin="0" leftmargin="0">'
cHtml +=			'<center>'
cHtml +=				'<table  border="1" cellpadding="0" cellspacing="0" bordercolor="#000082" bgcolor="#000082" width=598 height="637">'

//Cabecalho
cHtml +=    				'<td width="598" height="181" bgcolor="#FFFFFF">'
cHtml += 					'<center>'
cHtml += 					'<font color="#000000">'
cHtml +=					'<b>'
cHtml += 					'<h4 size="03">'
cHtml +=					'<br>'
cHtml += 					" DEMONSTRATIVO DE PAGAMENTO "
cHtml += 					'<br>'

If !Empty(Semana) .And. Semana # "99" .And.  Upper(SRA->RA_TIPOPGT) == "S"
	cHtml += cReferencia
Else
	cHtml += cReferencia
EndIf

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Carrega Funcao do Funcion. de acordo com a Dt Referencia     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )


cHtml += '</b></h4></font></center>'
cHtml += '<hr width = 100% align=right color="#000082">'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dados da Empresa	                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cHtml += '<!Dados da Empresa>'
cHtml += '<p align=left  style="margin-top: 0">'
cHtml +=   '<font color="#000082" face="Courier New"><i><b>'
cHtml +=  	'&nbsp;&nbsp;&nbsp;' + Desc_Fil+'</i></b></font><br>'  //Empresa
cHtml += 	'<font color="#000082" face="Courier New" size="2">'
cHtml += 	'&nbsp;&nbsp;&nbsp;&nbsp;Endere&ccedil;o : ' + Desc_End	+'<br>'		//Endereço
cHtml += 	'&nbsp;&nbsp;&nbsp;&nbsp;Cidade: '  + Desc_Cid	+ '&nbsp;&nbsp;&nbsp;Estado: '+Desc_Est+'<br>'
cHtml +=  	'&nbsp;&nbsp;&nbsp;&nbsp;CNPJ: ' + Transform( Desc_CGC , "@R 99.999.999/9999-99")  	//CNPJ
cHtml += '</p></font>'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dados do funcionario                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cHtml += '<hr width = 100% align=right color="#FF812D">'
cHtml += '<hr width = 100% align=right color="#000082">'
cHtml += '<!Dados do Funcionario>'
cHtml += '<p align=left  style="margin-top: 0">'
cHtml +=   '<font color="#000082" face="Courier New"><i><b>'
cHtml +=  	'&nbsp;&nbsp;&nbsp;' + SRA->RA_NOME + "- " + SRA->RA_MAT+'</i></b></font><br>'
cHtml += 	'<font color="#000082" face="Courier New" size="2">'
cHtml += 	'&nbsp;&nbsp;&nbsp;&nbsp;Funcao: ' + cCodFunc + "  "+cDescFunc	+'<br>' //"Funcao    - "
cHtml +=  	'&nbsp;&nbsp;&nbsp;&nbsp;C.Custo: ' + SRA->RA_CC + " - " + DescCc(SRA->RA_CC,SRA->RA_FILIAL) +'<br>' //"C.Custo   - "
cHtml +=    '&nbsp;&nbsp;&nbsp;&nbsp;Bco/Conta: ' + SRA->RA_BCDEPSAL+" - "+DescBco(SRA->RA_BCDEPSAL,SRA->RA_FILIAL)+ '&nbsp;'+  SRA->RA_CTDEPSAL //"Bco/Conta - "
cHtml += '</p></font>'

cHtml += '<!Proventos e Desconto>'
cHtml += '<div align="center">'
cHtml += '<Center>'
cHtml += '<Table bgcolor="#F0F8FF" style="border: 1px #003366 solid;" border="0" cellpadding ="1" cellspacing="0" width="553" height="296">'
cHtml +=    '<tr bgcolor="A2B5CD">'
cHtml += 	'<td><font face="Arial" size="02" color="#000082"><b>Cod  Descricao</b></font></td>' //"Cod  Descricao "
cHtml += 	'<td align="right"><font face="Arial" size="02" color="#000082"><b>Referência</b></font></td>' //"Referencia"
cHtml += 	'<td align="right"><font face="Arial" size="02" color="#000082"><b>Valores</b></font></td>' //"Valores"
cHtml += 	'<td>&nbsp;</td>'
cHtml += 	'</tr>'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Espacos Entre os Cabecalho e os Proventos/Descontos          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cHtml += 	'<tr>'
cHtml += 		'<td class="tdPrinc"></td>'
cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp</td>'
cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp</td>'
cHtml += 		'<td class="td18_18_AlignL"></td>'
cHtml += 	'</tr>'


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Proventos                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nProv:=1 To Len( aProve )
	
	nResto := ( ++nZebrado % 2 )
	
	
	cHtml += '<tr>'
	cHtml += 	'<td class="tdPrinc">' + aProve[nProv,1] + '</td>'
	cHtml += 	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(aProve[nProv,2],'999.99')+'</b></font></td>'
	cHtml += 	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(aProve[nProv,3],cPict3) + '</b></font></td>'
	cHtml +=    '<td class="td18_18_AlignL"></td>'
	cHtml += '</tr>'
	
Next nProv

For nDesco := 1 to Len(aDesco)
	
	nResto := ( ++nZebrado % 2 )
	
	
	cHtml += '<tr>'
	cHtml += 	'<td class="tdPrinc">' + aDesco[nDesco,1] + '</td>'
	cHtml += 	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(aDesco[nDesco,2],'999.99') + '</b></font></td>'
	cHtml += 	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(aDesco[nDesco,3],cPict3) + '</b></font></td>'
	cHtml += 	'<td class="td18_18_AlignL">-</td>'
	cHtml += '</tr>'
	
Next nDesco


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Espacos Entre os Proventos e Descontos e os Totais           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cHtml += 	'<tr>'
cHtml += 		'<td class="tdPrinc"></td>'
cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp</td>'
cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp</td>'
cHtml += 		'<td class="td18_18_AlignL"></td>'
cHtml += 	'</tr>'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Totais                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cHtml += '<!Totais >'
cHtml +=	'<b><i>'
cHtml += 	'<tr>'
cHtml += 		'<td class="tdPrinc">Total Bruto </td>' //"Total Bruto "
cHtml += 		'<td class="td18_94_AlignR"></td>'
cHtml += 		'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(TOTVENC,cPict3) + '</b></font></td>'
cHtml += 		'<td class="td18_18_AlignL"></td>'
cHtml +=	'</tr>'
cHtml += 	'<tr>'
cHtml += 		'<td class="tdPrinc">Total Descontos </td>' //"Total Descontos "
cHtml += 		'<td class="td18_94_AlignR"></Td>'
cHtml += 		'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(TOTDESC,cPict3) +  '</b></font></td>'
cHtml += 		'<td class="td18_18_AlignL">-</td>'
cHtml += 	'</tr>'
cHtml += 	'<tr>'
cHtml += 		'<td class="tdPrinc">Liquido a Receber </td>' //"Liquido a Receber "
cHtml += 		'<td align="right"><font face="Arial" size="02" color="#000082"><b>'
cHtml += 		'<td align=right height="18" width="95" Style=border-top:1px solid #000082 bgcolor=#4B87C2">'
cHtml +=        '<font color="#000082">' + Transform((TOTVENC-TOTDESC),cPict3) + '</font></td>'
cHtml += 	'</tr>'
cHtml += '<!Bases>'
cHtml += 	'<tr>'


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Espacos Entre os Totais e as Bases                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cHtml += 	'<tr>'
cHtml += 		'<td class="tdPrinc"></td>'
cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp</td>'
cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp</td>'
cHtml += 		'<td class="td18_18_AlignL"></td>'
cHtml += 	'</tr>'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salario Base                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cHtml +=	'<tr>'
cHtml +=		'<td class="tdPrinc"><p class="pStyle1">Salario Base</p></td>' //"Salario Base
cHtml +=		'<td class="td26_94_AlignR"><p></p></td>'
cHtml +=		'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nSalario,cPict1)+ '</b></font></td>'
cHtml += '</tr>'


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Base de Adiantamento                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Esc = 1
	If cBaseAux = "S" .And. nBaseIr # 0
		cHtml +=	'<tr>'
		cHtml +=		'<td class="tdPrinc"><p class="pStyle1"><font color=#000082 face="Courier new" size=2><i>Base IR Adiantamento</i></p></td></font>' //""
		cHtml +=		'<td class="td26_94_AlignR"><p></td>'
		cHtml +=		'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nBaseIr,cPict1)+ '</b></font></td>'
		cHtml +=		'<td class="td26_18_AlignL"><p></td>'
		cHtml += 	'</tr>'
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Base de Folha e de 13o 20 Parc.                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf Esc = 2 .Or. Esc = 4
	
	IF cBaseAux = "S"
		
		
		cHtml += '<tr>'
		cHtml +=	'<td class="tdPrinc">'
		cHtml +=    '<p class="pStyle1">Base FGTS/Valor FGTS</p></td>'//""
		cHtml +=	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nBaseFgts,cPict3)+ '</b></font></td>'
		cHtml +=	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nFgts    ,cPict3)+ '</b></font></td>'
		cHtml += '</tr>'
		cHtml += '<tr>'
		cHtml +=	'<td class="tdPrinc">'
		cHtml +=    '<p class="pStyle1">Base IRRF Folha/Ferias</p></td>'//""
		cHtml +=	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nBaseIr,cPict3)+ '</b></font></td>'
		cHtml +=	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nBaseIrfe,cPict3)+ '</b></font></td>'
		cHtml += '</tr>'
		cHtml += '<tr>'
		cHtml +=	'<td class="tdPrinc">'
		cHtml +=    '<p class="pStyle1">Base INSS</p></td>'//""
		cHtml +=	'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nAteLim,cPict3)+ '</b></font></td>'
		cHtml += '</tr>'
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Motivo: Permitir que possam ser exibidos no rodape do recibo de pagamento valores de verbas especificas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("GP30BASEHTM")
			cHtmlAux := ExecBlock("GP30BASEHTM",.F.,.F.)
			If ValType(cHtmlAux) = "C"
				cHtml  += cHtmlAux
			Endif
		Endif
	EndIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Bases de FGTS e FGTS Depositado da 1¦ Parcela                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf Esc = 3
	
	If cBaseAux = "S"
		
		
		cHtml += 	'<tr>'
		cHtml += 		'<td class="tdPrinc">'
		cHtml +=		'<p class="pStyle1">Base FGTS / Valor FGTS</td>' //"
		cHtml += 		'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nBaseFgts,cPict1) + '</b></font></td>'
		cHtml += 		'<td align="right"><font face="Arial" size="02" color="#000082"><b>' + Transform(nFgts,cPict2) + '</b></font></td>'
		cHtml +=		'<td align=right height="26" width="95"  style="border-left: 0px solid #FF9B06; border-right:0px solid #FF9B06; border-bottom:1px solid #FF9B06 ; border-top: 0px solid #FF9B06 bgcolor=#6F9ECE"></td>'
		cHtml += 	'</tr>'
		
		
	Endif
	
EndIF


cHtml += '</font></i></b>'
cHtml += '</table>'
cHtml += '</center>'
cHtml += '</div>'
cHtml += '<hr whidth = 100% align=right color="#000082">'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Espaco para Observacoes/mensagens                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cHtml += '<!Mensagem>'
cHtml += '<Table bgColor="#FFFFFF" border=0 cellPadding=0 cellSpacing=0 height=100 width=598>'
cHtml += 	'<TBody>'
cHtml +=	'<tr>'
cHtml +=	'<td align=left height=18 width=574 ><i><font face="Arial" size="2" color="#000082"><b>Mensagens: </b></font></td></tr>'
cHtml +=	'<tr>'
cHtml +=	'<td align=left height=18 width=574 ><i><font face="Arial" size="2" color="#000082">'+DESC_MSG1+ '</font></td></tr>'
cHtml +=	'<tr>'
cHtml +=	'<td align=left height=18 width=574 ><i><font face="Arial" size="2" color="#000082">'+DESC_MSG2+ '</font></td></tr>'
cHtml +=	'<tr>'
cHtml += 	'<td align=left height=18 width=574 ><i><font face="Arial" size="2" color="#000082">'+DESC_MSG3+ '</font></td></tr>'
IF cMesComp == Month(SRA->RA_NASC)
	cHtml += '<TD align=left height=18 width=574 bgcolor="#FFFFFF"><EM><B><CODE>      <font face="Arial" size="4" color="#000082">'
	cHtml += '<MARQUEE align="middle" bgcolor="#FFFFFF">"F E L I Z &nbsp;&nbsp  A N I V E R S A R I O !!!! </marquee><code></b></font></td></tr>' //"
EndIF
cHtml += '</TBody>'
cHtml += '</Table>'
cHtml += '</table>'
cHtml += '</body>'
cHtml += '</html>'

lEnvioOK := EnvMail(cSubject,cHtml,cEMail)

RestArea( aSvArea )

Return( NIL )


Static Function EnvMail(cSubject,cMensagem,cEMail,aFiles)

Local lOk:= .F.			// Variavel que verifica se foi conectado OK

If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha)
	If ( MailSmtpOn(cMailServer,cMailConta,cMailSenha) )
		If(MailSend(cMailConta,{cEmail},{},{},cSubject,cMensagem,aFiles))
			lOk	:= .T.
		EndIf
		MailSmtpOff()
	EndIf
EndIf

Return(lOk)




/*
³Fun‡…o	   ³CabecHtml  		³Autor³Marinaldo de Jesus ³ Data ³18/09/2003³
*/

Static Function CabecHtml( cReferencia , dDataPagto , dDataRef )

Local cHtml 		:= ""
Local cLogoEmp		:= RetLogoEmp()
Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
Local cAltLogo		:= SUPERGETMV("MV_GPALTLOGO",,"30")
Local cLarLogo		:= SUPERGETMV("MV_GPLARLOGO",,"206")

DEFAULT cReferencia	:= ""

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Carrega Funcao do Funcion. de acordo com a Dt Referencia     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc  )

//Logo e Titulo
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY class='fundo'>"
cHtml +=			"<img src='" + cLogoEmp +"' width='"+cLarLogo+"' height='"+cAltLogo+"'align=left hspace=30>" + CRLF
cHtml +=					"<b>" + CRLF
cHtml += 						"<span class='titulo_opcao'>" + Capital( "DEMONSTRATIVO DE PAGAMENTO" ) + "</span>" + CRLF //
cHtml +=					"</b>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Empresa
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'> Empresa: "  + CRLF //""
cHtml += 						"</span>" + CRLF
cHtml +=	        			 "<span class='dados'>" + CRLF
cHtml +=								Capital( AllTrim( Desc_Fil ) ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Endereco e CNPJ
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='65%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>Endereço: " + CRLF //""
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>"
cHtml +=								Capital( AllTrim( Desc_End ) ) + "</span>" + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='35%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>CNPJ: " + CRLF	//""
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Transform( Desc_CGC , "@R 99.999.999/9999-99") + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Data do Credito e Conta Corrente
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=				"<TD vAlign=top width='40%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>Crédito em:"+ CRLF //""
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Dtoc(dDataPagto) + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='60%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>Banco/Agência/Conta:"  + CRLF //"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								AllTrim( Transform( SRA->RA_BCDEPSA , "@R 999/999999" ) ) + "/" + SRA->RA_CTDEPSA + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Referencia
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>Referência: "+ CRLF //""
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								cReferencia + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=5>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Nome e Matricula
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='75%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>Nome: " + CRLF //"Nome:
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Capital( AllTrim( SRA->RA_NOME ) ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='25%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>Matricula: " + CRLF //""
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								SRA->RA_MAT + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//CTPS, Serie e CPF
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>CTPS:" + CRLF	//""
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=							SRA->RA_NUMCP + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='100' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>Série:" + CRLF //"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								SRA->RA_SERCP + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='172' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>CPF:" + CRLF //"CPF:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Transform( SRA->RA_CIC , "@R 999.999.999-99" ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='60%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>Funcao: " + CRLF //Funcao
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Capital( AllTrim( cDescFunc ) ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='40%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>Salário Nominal: " + CRLF //
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Transform( nSalario , cPict1 ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Centro de Custo
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>Centro de Custo: " + CRLF //
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								AllTrim( SRA->RA_CC ) + " - " + Capital( AllTrim(fDesc("SI3",SRA->RA_CC,"I3_DESC",TamSx3("I3_DESC")[1]) ) ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Admissao
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='329' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>Admissão: " + CRLF //""
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Dtoc( SRA->RA_ADMISSA ) + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='231' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>Dependente(s) IR: " + CRLF //""
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								SRA->RA_DEPIR + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='390' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>Dependente(s) Salário Família: " + CRLF //""
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								SRA->RA_DEPSF + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

Return( cHtml )

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o	   ³RodaHtml  		³Autor³Marinaldo de Jesus ³ Data ³18/09/2003³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Retorna Rodape HTML para o RHOnLine                         ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Retorno   ³cHtml  														³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso	   ³GPER030       										    	³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function RodaHtml()

Local cHtml	:= ""

cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top height=1>" + CRLF
cHtml +=					"<P align=center>" + CRLF
cHtml += 							"Válido como Comprovante Mensal de Rendimentos" + CRLF //''
cHtml +=						"<br>" + CRLF
cHtml += 							"( Artigo no. 41 e 464 da CLT, Portaria MTPS/GM 3.626 de 13/11/1991 )" + CRLF //
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

Return( cHtml )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fTrocaCar      ³ Autor ³ Alceu Pereira    ³ Data ³10/12/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Troca carecter da string passada como parametro            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPER030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fTrocaCar(cTexto)

Local aAcento:={}
Local aAcSubs:={}
Local cImpCar := Space(01)
Local cImpLin :=""
Local cAux 	  :=""
Local cAux1	  :=""
Local nTamTxt := Len(cTexto)
Local nCount  := 0
Local nPos

aAcento := 	{	"€","‡","","","…","†"," ","„","¦",;
"","ˆ","‚","¡","“","”","•","¢","§",;
"£","a","b","c","d","e","f","g","h",;
"i","j","k","l","m","n","o","p","q",;
"r","s","t","u","v","x","z","w","y",;
"A","B","C","D","E","F","G","H","I",;
"J","K","L","M","N","O","P","Q","R",;
"S","T","U","V","X","Z","W","Y","0",;
"1","2","3","4","5","6","7","8","9",;
"&"}

aAcSubs := 	{	"C","c","A","A","a","a","a","a","a",;
"E","e","e","i","o","o","o","o","o",;
"u","a","b","c","d","e","f","g","h",;
"i","j","k","l","m","n","o","p","q",;
"r","s","t","u","v","x","z","w","y",;
"A","B","C","D","E","F","G","H","I",;
"J","K","L","M","N","O","P","Q","R",;
"S","T","U","V","X","Z","W","Y","0",;
"1","2","3","4","5","6","7","8","9",;
"E"}

For nCount :=1 TO Len(AllTrim(cTexto))
	cImpCar	:=SubStr(cTexto,nCount,1)
	cAux	:=Space(01)
	nPos 	:= 0
	nPos 	:= Ascan(aAcento,cImpCar)
	If nPos > 0
		cAux := aAcSubs[nPos]
	Elseif (cAux1 == Space(1) .And. cAux == space(1)) .Or. Len(cAux1) == 0
		cAux :=	""
	EndIf
	cAux1 	:= 	cAux
	cImpCar	:=	cAux
	cImpLin	:=	cImpLin+cImpCar
	
Next nCount

cImpLin := Left(cImpLin+Space(nTamTxt),nTamTxt)

Return cImpLin



Static Function AtuSX1()

cPerg := "DBM002"
aRegs := {}

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03        /defspa3/defeng3/Cnt03/Var04/Def04		/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3

U_CRIASX1(cPerg,"01","Tipo                  ?",""       ,""      ,"mv_ch1","N" ,01     ,0      ,0     ,"C",""            ,"MV_PAR01","Adiantamento"   ,""     ,""     ,""   ,""   ,"Folha"          ,""     ,""     ,""   ,""   ,"13-1aParc"	,""     ,""     ,""   ,""   ,"13-2aParc",""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Data referencia       ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""         	,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"03","Matriclula de         ?",""       ,""      ,"mv_ch3","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR03",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SRA")
U_CRIASX1(cPerg,"04","Matricula ate         ?",""       ,""      ,"mv_ch4","C" ,06     ,0      ,0     ,"G",""            ,"MV_PAR04",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SRA")
U_CRIASX1(cPerg,"05","Centro de Custo de    ?",""       ,""      ,"mv_ch5","C" ,09     ,0      ,0     ,"G",""            ,"MV_PAR05",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CTT")
U_CRIASX1(cPerg,"06","Centro de Custo ate   ?",""       ,""      ,"mv_ch6","C" ,09     ,0      ,0     ,"G",""            ,"MV_PAR06",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CTT")
U_CRIASX1(cPerg,"07","Situacoes a Imprimir  ?",""       ,""      ,"mv_ch7","C" ,05     ,0      ,0     ,"G","fSituacao"   ,"MV_PAR07",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CTT")
U_CRIASX1(cPerg,"08","Categorias a Imprimir ?",""       ,""      ,"mv_ch8","C" ,15     ,0      ,0     ,"G","fCategoria"  ,"MV_PAR08",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CTT")
U_CRIASX1(cPerg,"09","Filial de 			?",""       ,""      ,"mv_ch9","C" ,02     ,0      ,0     ,"G","naovazio" 	 ,"MV_PAR09",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"XM0")
U_CRIASX1(cPerg,"10","Filial ate			?",""       ,""      ,"mv_cha","C" ,02     ,0      ,0     ,"G","naovazio"	 ,"MV_PAR10",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     		,""     ,""     ,""   ,""   ,""   		,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"XM0")

Return

