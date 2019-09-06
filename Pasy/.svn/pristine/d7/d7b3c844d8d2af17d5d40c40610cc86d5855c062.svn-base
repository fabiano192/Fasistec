#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºExecblock ³PA0013  Autor³ Alexandro da Silva      º Data ³  17/04/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressão de Etiquetas de Embalagem                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Sigafat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0013()

If !Pergunte("PA0013",.T.)
  Return
Endif             

dbSelectArea("SF2")

RptStatus({|| RunReport()})
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP5 IDE            º Data ³  17/04/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport()

Private oFont, cCode
nHeight    :=15
lBold      := .F.
lUnderLine := .F.
lPixel     := .T.
lPrint     :=.F.
nSedex     := 1

/*
oFont      := TFont():New( "Arial",,nHeight,,lBold,,,,,lUnderLine )
oFont3     := TFont():New( "Arial",,12,,.t.,,,,,.f. )
oFont5     := TFont():New( "Arial",,10,,.f.,,,,,.f. )
oFont9     := TFont():New( "Arial",,8,,.f.,,,,,.f. )

oFont1     := TFont():New( "Times New Roman",,28,,.t.,,,,,.t. )
oFont2     := TFont():New( "Times New Roman",,14,,.t.,,,,,.f. )
oFont4     := TFont():New( "Times New Roman",,20,,.t.,,,,,.f. )
oFont7     := TFont():New( "Times New Roman",,18,,.t.,,,,,.f. )
oFont11    :=TFont():New( "Times New Roman",,18,,.t.,,,,,.t. )

oFont6     := TFont():New( "HAETTENSCHWEILLER",,10,,.t.,,,,,.f. )

oFont8     :=  TFont():New( "Free 3 of 9",,44,,.t.,,,,,.f. )
oFont10    := TFont():New( "Free 3 of 9",,38,,.t.,,,,,.f. )
*/
oFont      := TFont():New( "Arial",,nHeight,,lBold,,,,,lUnderLine )
oFont1     := TFont():New( "Times New Roman",,08,,.t.,,,,,.F. )
oFont2     := TFont():New( "Times New Roman",,10,,.t.,,,,,.F. )
oFont3     := TFont():New( "Times New Roman",,12,,.t.,,,,,.F. )
oPrn       := TMSPrinter():New()

_cPedOld   := ""


////////////////////////////////////////////
////////////////////////////////////////////
///////- Grupo de Perguntas - PA0013 ///////
/// Variavel     // Descricao        ///////
/// MV_PAR01     // Nota Fiscal De?  ///////
/// MV_PAR02     // Nota Fiscal Ate? ///////
/// MV_PAR03     // Serie          ? ///////
/// MV_PAR04     // Produto De     ? ///////
/// MV_PAR05     // Produto Ate    ? ///////
/// MV_PAR06     // Quantidade     ? ///////
////////////////////////////////////////////
////////////////////////////////////////////



dbSelectArea("SF2")
dbSetOrder(1)
dbSeek(xFilial("SF2")+MV_PAR01+MV_PAR03,.T.)

nLin  := 0
ImpCabPed()  // impressao do cabeçalho

dbSelectArea("SF2")

SetRegua(RecCount())

While !EOF() .And. SF2->F2_DOC <= MV_PAR02 .And. SF2->F2_SERIE == MV_PAR03
	
   IncRegua()
	
	
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
   If lAbortPrint
   	  @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	  Exit
   Endif
	
   dbSelectArea("SD2")
   dbSetOrder(3)
   dbSeek(xfilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+MV_PAR04,.t.)
	
   While !Eof() .And. SD2->D2_DOC <= MV_PAR02 .And. SD2->D2_COD <= MV_PAR05
	   
      _nQtde := MV_PAR06				
	  If _nQtde == 0
   	     _cCod := SD2->D2_COD
	     
	     _cAliSD2 := Alias()
	     _nOrdSD2 := IndexOrd()
	     _nRecSD2 := Recno()
	     While !Eof() .And. _cCod == SD2->D2_COD
	   
            _nQtde += SD2->D2_QUANT
             
            dbSelectarea("SD2")
            dbSkip()
         EndDo
         dbSelectArea(_cAliSD2)
         dbSetOrder(_nOrdSD2)
         dbGoto(_nRecSD2)   
      Endif 

      _cDescProd := ""
	  dbSelectArea("SZ2")
	  dbSetOrder(2)
	  If dbSeek(xFilial("SZ2")+SD2->D2_COD+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_PROCLI+"1")
         _cDescProd := Substr(SZ2->Z2_DESCCLI,1,30)
      Endif   

 	  dbSelectArea("SA1")
 	  dbSetOrder(1)
 	  dbSeek(xfilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
 	  _cNomeCli := SA1->A1_NREDUZ

/* 	  
 	  If nlin > 690// Salto de Página. Neste caso o formulario com 10 itens...
		 oPrn:EndPage()
		 oPrn:StartPage()
		 nLin  := 0
		 ImpCabPed()
		 nPeso := 0
		 n     := 0
	  Endif
*/	
      ImpDet()

      SetPrc(0,0)	
      nLin:=nLinIni+nTamNF    // Posiciona proximo formulario
	  p_cnt:=nTamNf           //
       
      dbSelectArea("SD2")
      dbSkip()       
   EndDo
    
   dbSelectArea("SF2")
   dbSkip()
EndDo    
    
/*
IF MsgYesNo("Fomulario Ok? ")
   nOpc := 1
Else
   nOpc := 2
Endif
*/

oPrn:Setup() // para configurar impressora
oPrn:Print() // descomentar esta linha para imprimir


MS_FLUSH()


Return



Static Function ImpCabPed()

cBitMap:= "LogoPasy.Bmp" 
                             //400,80
oPrn:SayBitmap( 10,10,cBitMap,450,100 )
nLin += 100
oPrn:Say( 20, 20, " ",oFont,100 ) // startando a impressora

Return



Static function ImpDet()


DbSelectArea("SD2")

oPrn:Say( nLin, 10, Repl("_",29),oFont1,100  )
nLin += 50
oPrn:Say( nLin, 10, "Cliente:",oFont1,100  )
nLin += 50
oPrn:Say( nLin, 10, _cNomeCli,oFont2,100  )
nLin += 20
oPrn:Say( nLin, 10, Repl("_",29),oFont1,100  )
nLin += 50
oPrn:Say( nLin, 10, "Descricao do Produto:",oFont1,100  )
nLin += 50
oPrn:Say( nLin, 10, _cDescProd,oFont2,100  )
nLin += 20
oPrn:Say( nLin, 10, Repl("_",29),oFont1,100  )
nLin += 50
oPrn:Say( nLin, 10, "Codigo Pasy",oFont1,100  )
oPrn:Say( nLin, 250, "Codigo Cliente",oFont1,100  )
nLin += 50
oPrn:Say( nLin, 10, SD2->D2_COD,oFont2,100  )
oPrn:Say( nLin, 250, SD2->D2_PROCLI,oFont2,100  )
nLin += 20
oPrn:Say( nLin, 10, Repl("_",29),oFont1,100  )
nLin += 50
oPrn:Say( nLin, 10,  "Qtde :",oFont1,100  )
oPrn:Say( nLin, 250, "Nota Fiscal",oFont1,100  )
nLin += 50
oPrn:Say( nLin, 10, Trans(_nQtde, "@e 999.999"),oFont3,100  )
oPrn:Say( nLin, 250, SD2->D2_DOC,oFont3,100  )
nLin += 20
oPrn:Say( nLin, 10, Repl("_",29),oFont1,100  )
nLin += 50
oPrn:Say( nLin, 10,  "Lote:",oFont1,100  )
nLin += 50
oPrn:Say( nLin, 10,  SD2->D2_PEDIDO+SD2->D2_ITEMPV,oFont3,100  )
nLin += 20
oPrn:Say( nLin, 10, Repl("_",29),oFont1,100  )


Return