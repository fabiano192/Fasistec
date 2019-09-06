//STATIC lFirst
//#include "FIVEWIN.CH"
//#INCLUDE "GPEXFUN.CH"
//#define HorSep "ÄÂÄ"
//#define VerSep " ³ "
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Alexandro da Silva           Data	³ 22/12/05  		  ³±±
±±³                                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Observacao ³ Teste de Impressão                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ImpRel(Detalhe,Fimfolha,Pos_cabec)

LOCAL Colunas,nLin:=0, aDriver := LEDriver()

lFirst := Iif(lFirst=Nil .OR. CONTFL <=1,.T.,.F.)
Colunas := IIF(nTamanho=="P",80,IIF(nTamanho=="G",220,132))

IF FIMFOLHA = "F"
	@ 61 ,000		 PSAY REPLICATE("*",COLUNAS)
	@ 62 ,000		 PSAY "*" + " Microsiga "
	@ 62 ,PCOL()	 PSAY " - Software S/A. "
	@ 62 ,COLUNAS-1 PSAY "*"
	@ 63 ,000		 PSAY REPLICATE("*",COLUNAS)
	@ 64 ,000		 PSAY "       "
	EJECT
	RETURN Nil
Endif
IF FIMFOLHA = "P" .OR. LI >= 60
	@ LI,00 PSAY REPLICATE("*",COLUNAS)
	LI := 00
	IF FIMFOLHA = "P"
		RETURN Nil
	Endif
Endif
IF LI=00
	If aReturn[4] == 1  // Comprimido
		@ 0,0 PSAY &(if(nTamanho=="P",aDriver[1],if(nTamanho=="G",aDriver[5],aDriver[3])))
	Else					  // Normal
		@ 0,0 PSAY &(if(nTamanho=="P",aDriver[2],if(nTamanho=="G",aDriver[6],aDriver[4])))
	Endif

	If Type("cPerg")!="U" .and. GetMv("MV_PERGRH") == "S" .and. Substr(cAcesso,101,1) == "S"
		If lFirst
			lFirst := .F.
			@(nLin:=0),0 PSAY REPLI("*",COLUNAS)
			@(++nLin),0 PSAY "*"+AllTrim(SM0->M0_NOME)
			@(++nLin),0 PSAY "*"+RptParam+" "+Titulo
			@(++nLin),0 PSAY "*SIGA /"+At_Prg+"/v."
			If __SetCentury()
				@ nLin,COLUNAS-20  PSAY RptDtRef
				@ nLin,COLUNAS-11  PSAY dDataBase
			Else
				@ nLin,COLUNAS-18  PSAY RptDtRef
				@ nLin,COLUNAS- 9  PSAY dDataBase
			EndIf
			@ nLin,COLUNAS- 1  PSAY "*"
			@ (++nLin),0 PSAY Iif(lFirst,"*"+RptHora+" "+time(),"*")
			If __SetCentury()
				@ nLin,COLUNAS-20  PSAY RptEmiss
				@ nLin,COLUNAS-11  PSAY MsDate()
			Else
				@ nLin,COLUNAS-18  PSAY RptEmiss
				@ nLin,COLUNAS- 9  PSAY MsDate()
			EndIf
			@ nLin,COLUNAS-1 PSAY "*"
			@ (++nLin),0 PSAY Replicate("*",COLUNAS)
			cAlias := Alias()
			dbSelectArea("SX1")
			dbSeek(cPerg)
			While !EOF() .AND. X1_GRUPO = cPerg
				cVar := "MV_PAR"+StrZero(Val(X1_ORDEM),2,0)
				@(nLin+=2),5 PSAY RptPerg+" "+ X1_ORDEM + " : "+ AllTrim(X1_PERGUNTA)
				If X1_GSC == "C"
					xStr:=StrZero(&cVar,2)
					@ nLin,Pcol()+3 PSAY Iif(&(cVar)>0,X1_DEF&xStr,"")
				Else
					uVar := &(cVar)
					If ValType(uVar) == "N"
						cPicture:= "@E "+Replicate("9",X1_TAMANHO-X1_DECIMAL-1)
						If( X1_DECIMAL>0 )
							cPicture+="."+Replicate("9",X1_DECIMAL)
						Else
							cPicture+="9"
						EndIf
						@nLin,Pcol()+3 PSAY &(cVar) Picture cPicture
					Else
						@nLin,Pcol()+3 PSAY &(cVar)
					EndIf
				EndIf
				DbSkip()
			End
		
			cFiltro := Iif(!Empty(aReturn[7]),MontDescr(cAlias,aReturn[7]),"")
			nCont := 1
			If !Empty(cFiltro)
				@(nLin+=2),5  PSAY  "Filtro      : " + Substr(cFiltro,nCont,COLUNAS-19)  
				While Len(AllTrim(Substr(cFiltro,nCont))) > (COLUNAS-19)
					nCont += COLUNAS - 19
					@(nLin+=1),19  PSAY  Substr(cFiltro,nCont,COLUNAS-19)
				End
				nLin++
			EndIf
			@(++nLin),00  PSAY REPLI("*",COLUNAS)
			dbSelectArea(cAlias)
		EndIf
	EndIf
	@ 00,000 PSAY REPLICATE("*",COLUNAS)
	@ 01,000 PSAY "*" + SM0->m0_NomeCom
	COL_AUX = IF(COLUNAS = 220,210,COLUNAS)
	WCOL	  = INT((COL_AUX - (LEN(TRIM(TITULO))))/2)
	WPAGINA = SUBSTR(STR(CONTFL+100000,6),2,5)
	IF TYPE("POS_CABEC")= "U"
		@ 01,COLUNAS-20 PSAY "Folha:        " + WPAGINA + "*"  
	Else
		@ 01,COLUNAS-26 PSAY "*"
	Endif
	@ 02,000 PSAY "*" + CHR(83) + CHR(46) + CHR(73) + CHR(46) + CHR(71) + CHR(46) + CHR(65) + CHR(46) + " / "  + AT_PRG
	@ 02,WCOL		 PSAY TRIM(TITULO)
	IF TYPE("POS_CABEC")= "U"
		@ 02,COLUNAS-20 PSAY "DT.Ref.:"
		@ 02,COLUNAS-11 PSAY PADL(dDataBase,10)
		@ 02,COLUNAS-01 PSAY "*"
	Else
		@ 02,COLUNAS-26 PSAY "*"
	Endif
	@ 03,000 PSAY "*Hora...: " + TIME()  
	IF TYPE("POS_CABEC")= "U"
		@ 03,COLUNAS-20 PSAY "Emissao:"
		@ 03,COLUNAS-11 PSAY PADL(DATE(),10)
		@ 03,COLUNAS-01 PSAY "*"
	Else
		@ 03,COLUNAS-26 PSAY "*"
	Endif
	@ 04,000 PSAY REPLICATE("*",IIF(TYPE("POS_CABEC")="U",COLUNAS,COLUNAS-25))
	IF TYPE("POS_CABEC") # "U"
		@ 05,00 PSAY "*"
		@ 05,COLUNAS-26 PSAY "*"
		LI_WCABEC = 6
	Else
		IF WCABEC0 == 0
			LI_WCABEC = 4
		Else
			LI_WCABEC = 5
		EndIF
	Endif
	IF WCABEC0 == 0
		IF TYPE("POS_CABEC") # "U"
			@ 06,00 PSAY "*Folha:       " + WPAGINA  
			@ 06,COLUNAS-26 PSAY "*"
			@ 07,00 PSAY "*DT.Ref.:  "
			@ 07,14 PSAY dDataBase
			@ 07,COLUNAS-26 PSAY "*"
			@ 08,00 PSAY "*Emissao:"
			@ 08,14 PSAY DATE()
			@ 08,COLUNAS-26 PSAY "*"
			@ 09,00 PSAY "*"
			@ 09,COLUNAS-26 PSAY "*"
			LI_WCABEC = 10
			@ LI_WCABEC,000 PSAY REPLICATE("*",COLUNAS)
		Endif
	Endif
	IF WCABEC0 # 0
		FOR X_IMPR = 1 TO WCABEC0
			IF TYPE("POS_CABEC") # "U"
				IF X_IMPR = 1
					@ LI_WCABEC,00 PSAY "*Folha:       " + WPAGINA  
					@ LI_WCABEC,COLUNAS-26 PSAY "*"
				ElseIf X_IMPR = 2
					@ LI_WCABEC,00 PSAY "*DT.Ref.:  "
					@ LI_WCABEC,14 PSAY dDataBase
					@ LI_WCABEC,COLUNAS-26 PSAY "*"
				ElseIf X_IMPR = 3
					@ LI_WCABEC,00 PSAY "*Emissao:"
					@ LI_WCABEC,14 PSAY DATE()
					@ LI_WCABEC,COLUNAS-26 PSAY "*"
				Endif
			Endif
			AUX_IMPR = "WCABEC" + ALLTRIM(STR(X_IMPR))
			IF X_IMPR <= 3
				@ LI_WCABEC,IIF(TYPE("POS_CABEC")="U",000,025) PSAY &AUX_IMPR
			Else
				@ LI_WCABEC,000 PSAY &AUX_IMPR
			Endif
			LI_WCABEC = LI_WCABEC + 1
		NEXT
		IF TYPE("POS_CABEC") # "U"
			IF X_IMPR <=3
				FOR XTMP = X_IMPR-1 TO 3
					IF XTMP = 2
						@ LI_WCABEC,00 PSAY "*DT.Ref.:  "
						@ LI_WCABEC,14 PSAY dDataBAse
						@ LI_WCABEC,COLUNAS-26 PSAY "*"
					Else
						@ LI_WCABEC,00 PSAY "*Emissao:"
						@ LI_WCABEC,14 PSAY DATE()
						@ LI_WCABEC,COLUNAS-26 PSAY "*"
					Endif
					LI_WCABEC = LI_WCABEC + 1
				NEXT
			Endif
		Endif
		@ LI_WCABEC,000 PSAY REPLICATE("*",COLUNAS)
	Endif
	LI 	 = LI_WCABEC+1
	CONTFL = CONTFL+1

	__LogPages()

Endif
@ LI,00 PSAY DETALHE
LI = LI+1
RETURN Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³CONFIMPR 	³ Autor ³ Alexandro da Silva    ³ Data ³ 12/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Controlar o Tipo de Impressora e Impressao				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³Acionada pela Funcao Impr									  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ConfIMpr()

Local aSettings := {}
Local cStr, cLine, i

if !File(__DRIVER)
	aSettings := {"CHR(15)","CHR(18)","CHR(15)","CHR(18)","CHR(15)","CHR(15)"}
Else
	cStr := MemoRead(__DRIVER)
	For i:= 2 to 7
		cLine := AllTrim(MemoLine(cStr,254,i))
		AADD(aSettings,SubStr(cLine,7))
	Next
Endif
Return aSettings