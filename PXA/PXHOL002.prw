#Include "PROTHEUS.Ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PXHOL002 ³ Autor ³ Alexandro da Silva    ³ Data ³ 24/04/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Lan‡amentos Cont beis Off-Line TXT             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PXHOL002)                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGACTB                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PXHOL002()

Local aSays 	:= {}
Local aButtons	:= {}
Local dDataSalv := dDataBase
Local nOpca 	:= 0

Private cCadastro := OemToAnsi(OemtoAnsi("Contabiliza‡„o de Arquivos TXT"))
Private lAtureg:= .T.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01 // Mostra Lan‡amentos Cont beis                     ³
//³ mv_par02 // Aglutina Lan‡amentos Cont beis                   ³
//³ mv_par03 // Arquivo a ser importado                          ³
//³ mv_par04 // Numero do Lote                                   ³
//³ mv_par05 // Quebra Linha em Doc.							 ³
//³ mv_par06 // Tamanho da linha	 							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("CTB500",.f.)

AADD(aSays,OemToAnsi( "  O  objetivo  deste programa  e  o  de  gerar  lancamentos  contabeis" ) )
AADD(aSays,OemToAnsi( "a partir de arquivo texto importados de outros sistemas." ) )

AADD(aButtons, { 5,.T.,{|| Pergunte("CTB500",.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca:= 1, If( CTBOk(), FechaBatch(), nOpca:=0 ) }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

IF nOpca == 1
	Processa({|lEnd| PXH002_A()})
Endif

dDataBase := dDataSalv

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CTB500Proc³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 29.01.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento do lancamento contabil TXT                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTB500Proc()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PXH002_A()

Local cLote		:= CriaVar("CT2_LOTE")
Local cArquivo
Local cPadrao
Local lHead		:= .F.					// Ja montou o cabecalho?
Local lPadrao
Local lAglut
Local nTotal	:=0
Local nHdlPrv	:=0
Local nBytes	:=0
Local nHdlImp
Local nTamArq
Local nTamLinha := Iif(Empty(mv_par06),512,mv_par06)

PRIVATE xBuffer	:=Space(nTamLinha)
Private aRotina := {	{ "","" , 0 , 1},;
{ "","" , 0 , 2 },;
{ "","" , 0 , 3 },;
{ "","" , 0 , 4 } }
Private Inclui := .T.

If Empty(mv_par03)
	Help(" ",1,"NOFLEIMPOR")
	Return
End

nHdlImp:=FOpen(Mv_Par03,0)

If nHdlImp == -1
	Help(" ",1,"NOFLEIMPOR")
	Return
Endif

cLote := mv_par04
If Empty(cLote)
	Help(" ",1,"NOCT210LOT")
	Return
EndIf

/*
aLin[1] - CODIGO LANÇAMENTO PADRAO
aLin[2] - DATA
aLin[3] - CONTA DEBITO
aLin[4] - CONTA CREDITO
aLin[5] - VALOR
aLin[6] - HISTORICO
*/

PRIVATE CTADEB,CTACRE,VALOR,HIST,DTLANC,CRDEB,CRCRE

FT_FUSE( MV_PAR03)
FT_FGOTOP()

While !FT_FEOF()
	
	_cLinha  := FT_FREADLN()
	
	If Upper(substr(_cLinha,1,3)) == "LAN"
		FT_FSKIP()
		Loop
	Endif
	    
	_cLinha	 := StrTran(_cLinha,';;','; ;')	 
	_cLinha	 := StrTran(_cLinha,';;','; ;')	
	_cLinha	 := StrTran(_cLinha,';;','; ;')	
	_aLin    := StrTokArr(_cLinha, ";" )
	
	/*
	If Empty(_aLin[1])
	MSGSTOP("CODIGO LANÇAMENTO NAO PREENCHIDO!")
	Return
	Endif
	
	If _aLin[1] >= "499"
	FT_FSKIP()
	Loop
	Endif
	*/
	
	If Empty(_aLin[2])
		MSGSTOP("DATA NAO PREENCHIDA!")
		Return
	Endif
	
	lHead    := .F.
	_dDtLanc := _aLin[2]
	dDataBase:= ctod(_aLin[2])
	
	While !FT_FEOF() .And. 	_dDtLanc == _aLin[2]
				
		If Empty((_aLin[2]))
			MSGSTOP("DATA NAO PREENCHIDA!")
			Return
		Endif
				
		If Empty(Alltrim(_aLin[5]))
			MSGSTOP("VALOR NAO PREENCHIDO!")
			Return
		Endif
		
		If Empty(Alltrim(_aLin[6]))
			MSGSTOP("HISTORICO NAO PREENCHIDO!")
			Return
		Endif
		
		cPadrao	:= "001"//_aLin[1]
		DTLANC  := CTOD(_aLin[2])
		CTADEB  := IIf (Empty(Alltrim(_aLin[3])),Space(20),_aLin[3])
		CTACRE  := IIf (Empty(Alltrim(_aLin[4])),Space(20),_aLin[4]) 
		CLASDEB := CLASCRE := ITEMDEB:= ITEMCRE:= Space(09)
		_cValor := StrTran(_aLin[5], ".","")
		VALOR   := VAL(StrTran(_cValor, ",","."))	 
		//VALOR   := 10
		HIST    := UPPER(_aLin[6])
	   
		/*CRDEB   := IIf (Empty(Alltrim(_aLin[7])),Space(09),_aLin[7])
		CRCRE   := IIf (Empty(Alltrim(_aLin[8])),Space(09),_aLin[8])
		ITEMDEB := IIf (Empty(Alltrim(_aLin[9])),Space(09),_aLin[9])
		ITEMCRE := IIf (Empty(Alltrim(_aLin[10])),Space(09),_aLin[10])
		CLASDEB := IIf (Empty(Alltrim(_aLin[11])),Space(09),_aLin[11])
		CLASCRE := IIf (Empty(Alltrim(_aLin[12])),Space(09),_aLin[12])
	    */
		If Len(_aLin) >= 7
			CRDEB   := IIf (Empty(Alltrim(_aLin[7])),Space(09),_aLin[7])
		Endif

		If Len(_aLin) >= 8		
			CRCRE   := IIf (Empty(Alltrim(_aLin[8])),Space(09),_aLin[8])
		Endif

		If Len(_aLin) >= 09
			ITEMDEB   := IIf (Empty(Alltrim(_aLin[09])),Space(09),_aLin[09])
		Endif

		If Len(_aLin) >= 10	
			ITEMCRE   := IIf (Empty(Alltrim(_aLin[10])),Space(09),_aLin[10])
		Endif
		
		If Len(_aLin) >= 11
			CLASDEB   := IIf (Empty(Alltrim(_aLin[11])),Space(09),_aLin[11])
		Endif

		If Len(_aLin) >= 12	
			CLASCRE   := IIf (Empty(Alltrim(_aLin[12])),Space(09),_aLin[12])
		Endif
	
		lPadrao	:= VerPadrao(cPadrao)
		
		IF lPadrao
			IF !lHead
				lHead := .T.
				nHdlPrv:=HeadProva(cLote,"CTBA500",Substr(cUsuario,7,6),@cArquivo)
			End
			nTotal += DetProva(nHdlPrv,cPadrao,"CTBA500",cLote)
			If mv_par05 == 1			// Cada linha contabilizada sera um documento
				RodaProva(nHdlPrv,nTotal)
				
				lDigita	:=IIF(mv_par01==1,.T.,.F.)
				lAglut 	:=IIF(mv_par02==1,.T.,.F.)
				cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut)
			EndIf
		EndIf
		
		FT_FSKIP()
		
		_cLinha  := FT_FREADLN()

		_cLinha	 := StrTran(_cLinha,';;','; ;')	
		_cLinha	 := StrTran(_cLinha,';;','; ;')	
		_cLinha	 := StrTran(_cLinha,';;','; ;')	
		_aLin    := StrTokArr(_cLinha, ";" )
				
	EndDo
	
	If lHead
		lHead	:= .F.
		RodaProva(nHdlPrv,nTotal)
		
		lDigita := IIF(mv_par01==1,.T.,.F.)
		lAglut  := IIF(mv_par02==1,.T.,.F.)
		cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut)
	Endif
	
EndDo

FClose(nHdlImp)


Return