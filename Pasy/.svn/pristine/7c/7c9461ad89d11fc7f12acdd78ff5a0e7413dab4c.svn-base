#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Pa0008   º Autor ³ Alexandro da Silva º Data ³  04/01/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Comparativo entre Datas de Entrega do Pedido X Faturamento º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Sigafat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0008A()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private   cString
Private    aOrd         := {}
Private   CbTxt        := ""
Private   cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Private   cDesc2       := "de acordo com os parametros informados pelo usuario."
Private   cDesc3       := "Comparativo Entre a Data De Entrega e Data Faturada"
Private   cPict        := ""
Private   lEnd         := .F.
Private   lAbortPrint  := .F.
Private   nomeprog     := "PA0008A"
Private   nTipo        := 18
Private   CabecA       := ""
Private   CabecS       := ""
Private   Cabec2       := ""
Private   aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private   nLastKey     := 0
Private   cPerg        := "PA0008"
Private   _nLin         := 80
Private   Cabec2       := ""
Private   cbtxt        := Space(10)
Private   cbcont       := 00
Private   CONTFL       := 01
Private   m_pag        := 01
Private   imprime      := .T.
Private   wnrel        := "PA0008A"
Private   cString      := "SC6"
Private   _nProgAcu    := 0
Private   _nProgAtu    := 0

//////////////////////////////////////////////  
//// MV_PAR01  == Data Entrega De   ?      ///
//// MV_PAR02  == Data Entrega Ate  ?      ///
//// MV_PAR03  == Data Acumulada De ?      /////// MV_PAR04  == Data Acumulada Ate?      ///
//// MV_PAR05  == Cliente De        ?      ///
//// MV_PAR06  == Cliente Ate       ?      ///
//// MV_PAR07  == Loja    De        ?      ///
//// MV_PAR08  == LOja    Ate       ?      ///
//// MV_PAR09  == Pedido  De        ?      ///
//// MV_PAR10  == Pedido  Ate       ?      ///
//// MV_PAR11  == Produto De        ?      ///
//// MV_PAR12  == Produto Ate       ?      ///
//// MV_PAR13  == Analitico/Sint.   ?      ///
/////////////////////////////////////////////

Pergunte("PA0008",.F.)   
       
Private titulo    := "Eficiencia de Entrega"
Private Tamanho   := "P"
Private limite    := 80  

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If MV_PAR13 == 1  // Analítico
   _lAnalit := .T.
Else
   _lAnalit := .F.
Endif

If _lAnalit
   Private CabecA    := "Cliente Pedido It Cod.Cliente     Cod.Pasy        Entrega  Dt.Fatur. Dias"
Else
   Private CabecS    := "Cliente Lj  Nome do Cliente      Qtde Total de Programas "
Endif

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Arquivo Temporário                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aStru := {}
AADD(aStru,{"ACUMUL"   , "C" ,  1, 0 })
AADD(aStru,{"ORDEM"    , "C" ,  1, 0 })
AADD(aStru,{"QTDIA"    , "C" ,  5, 0 })
AADD(aStru,{"CLIENTE"  , "C" ,  6, 0 })
AADD(aStru,{"LOJA"     , "C" , 02, 0 })
AADD(aStru,{"NOMECLI"  , "C" , 20, 0 })
AADD(aStru,{"PEDIDO"   , "C" ,  6, 0 })
AADD(aStru,{"ITEM"     , "C" ,  2, 0 })
AADD(aStru,{"PRODCLI"  , "C" , 15, 0 })
AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
AADD(aStru,{"DTENT"    , "D" ,  8, 0 })
AADD(aStru,{"DTFAT"    , "D" ,  8, 0 })
AADD(aStru,{"QTDPED"   , "N" , 11, 4 })
AADD(aStru,{"QTDENT"   , "N" , 11, 4 })
AADD(aStru,{"QTDFAT"   , "N" , 11, 4 })

cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "ACUMUL+ORDEM+QTDIA+CLIENTE+LOJA+PEDIDO+ITEM+PRODUTO"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

nTipo := If(aReturn[4]==1,15,18)

/*
_cChave  := "D2_FILIAL+D2_PEDIDO+D2_ITEMPV+DTOS(D2_EMISSAO)+D2_COD"
dbSelectArea("SD2")
_cIndex  := CriaTrab(nil,.f.)
dbSelectArea("SD2")
IndRegua("SD2",_cIndex,_cChave,,Nil,"Selecionando Registros...")
_nIndex  := RetIndex("SD2")
dbSetIndex(_cIndex+OrdBagExt())
dbSetOrder(_nIndex+1)
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa( {|| GeraTrb() } )

If _lAnalit
   RptStatus({|| ImpTrb(CabecA,Cabec2,Titulo,_nLin) },Titulo)
Else
   RptStatus({|| ImpTrb(CabecS,Cabec2,Titulo,_nLin) },Titulo)
Endif

//dbSelectArea("SD2")
//RetIndex( "SD2" )
//If !Empty(_cIndex)
//   FErase (_cIndex+OrdBagExt())
//Endif
//dbSetOrder(1)

dbSelectArea("TRB")
dbCloseArea()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³GeraTrb   º Autor ³ Alexandro da Silva º Data ³  04/01/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraTrb()

dbSelectArea("SC6")
dbSetOrder(3)
dbSeek(xFilial("SC6")+Dtos(MV_PAR03),.T.)

_nDiaAtr  := 0
_nDiaAdi  := 0
_cDia     := 0
_cNomeCli := ""

_nRec     := LastRec()
ProcRegua(_nRec)

While !Eof() .And. SC6->C6_ENTREG <= MV_PAR02

   IncProc()
   _lPrim := .T.

   If SC6->C6_CLI     < MV_PAR05 .Or. SC6->C6_CLI     > MV_PAR06 .Or.;
      SC6->C6_LOJA    < MV_PAR07 .Or. SC6->C6_LOJA    > MV_PAR08 .OR.;
      SC6->C6_NUM     < MV_PAR09 .Or. SC6->C6_NUM     > MV_PAR10 .OR.;
      SC6->C6_PRODUTO < MV_PAR11 .Or. SC6->C6_PRODUTO > MV_PAR12 .OR.;
      Alltrim(SC6->C6_BLQ) == "R"
      dbSelectArea("SC6")
      dbSkip()
      Loop
   Endif

   dbSelectarea("SC5")
   dbSetOrder(1)
   If dbSeek(xFilial("SC6")+SC6->C6_NUM)
      If SC5->C5_TIPO != "N"
         dbSelectArea("SC6")
         dbSkip()
         Loop
      Endif
   Endif         
   
   dbSelectArea("SC6")

   While !Eof() .And. SC6->C6_ENTREG < MV_PAR01

      _cPedido := SC6->C6_NUM
      
      dbSelectarea("SC5")
      dbSetOrder(1)
      If dbSeek(xFilial("SC6")+SC6->C6_NUM)
         If SC5->C5_TIPO != "N"
            dbSelectArea("SC6")
            dbSkip()
            Loop
         Endif
      Endif         
      
      dbSelectArea("SA1")
      dbsetorder(1)
      dbSeek(xFilial("SA1")+SC6->C6_CLI + SC6->C6_LOJA)
      _cNomeCli := Substr(SA1->A1_NOME,1,20)

      dbSelectArea("SC6")      
      
      While !Eof() .And. SC6->C6_ENTREG < MV_PAR01 .And. _cPedido == SC6->C6_NUM

         If _lPrim
            _lPrim := .F.
         Else
            IncProc()
         Endif

         If SC6->C6_CLI     < MV_PAR05 .Or. SC6->C6_CLI     > MV_PAR06 .Or.;
			SC6->C6_LOJA    < MV_PAR07 .Or. SC6->C6_LOJA    > MV_PAR08 .OR.;
            SC6->C6_NUM     < MV_PAR09 .Or. SC6->C6_NUM     > MV_PAR10 .OR.;
            SC6->C6_PRODUTO < MV_PAR11 .Or. SC6->C6_PRODUTO > MV_PAR12 .OR.;
            Alltrim(SC6->C6_BLQ) == "R"
            dbSelectArea("SC6")
            dbSkip()
            Loop
         Endif
                
//         If !Vazio(SC6->C6_DATFAT)
         If SC6->C6_QTDVEN == SC6->C6_QTDENT
            If SC6->C6_DATFAT < MV_PAR01 .Or. SC6->C6_DATFAT > MV_PAR02
               dbSelectArea("SC6")
               dbSkip()
               Loop
            Endif  
         Endif
         
         If SC6->C6_QTDVEN == SC6->C6_QTDENT
            _cDia := SC6->C6_DATFAT - SC6->C6_ENTREG
            _cOrdem := "4"
         Else
            _cDia := dDataBase - SC6->C6_ENTREG
            _cOrdem := "1"
         Endif   

         dbSelectArea("TRB")
         RecLock("TRB",.T.)
            TRB->ACUMUL  := "1"
            TRB->ORDEM   := _cOrdem
            TRB->QTDIA   := strZero(_cDia,5)
            TRB->CLIENTE := SC6->C6_CLI
            TRB->LOJA    := SC6->C6_LOJA
            TRB->NOMECLI := _cNomeCli
            TRB->PEDIDO  := SC6->C6_NUM
            TRB->ITEM    := SC6->C6_ITEM
            TRB->PRODCLI := SC6->C6_CPROCLI
            TRB->PRODUTO := SC6->C6_PRODUTO
            TRB->DTENT   := SC6->C6_ENTREG
            TRB->DTFAT   := SC6->C6_DATFAT
            TRB->QTDPED  := SC6->C6_QTDVEN
            TRB->QTDENT  := SC6->C6_QTDENT
         MsUnLock()

         _nProgAcu := _nProgAcu + 1
                           
         dbSelectArea("SC6")
         dbSkip()
      EndDo
   EndDo

   dbSelectArea("SA1")
   dbsetorder(1)
   dbSeek(xFilial("SA1")+SC6->C6_CLI + SC6->C6_LOJA)
   _cNomeCli := Substr(SA1->A1_NOME,1,20)   
   _cPedido := SC6->C6_NUM
      
   dbSelectArea("SC6")
   
   While !Eof() .And. _cPedido == SC6->C6_NUM

      If _lPrim
         _lPrim := .F.
      Else
         IncProc()
      Endif

      If SC6->C6_CLI     < MV_PAR05 .Or. SC6->C6_CLI     > MV_PAR06 .Or.;
	 	 SC6->C6_LOJA    < MV_PAR07 .Or. SC6->C6_LOJA    > MV_PAR08 .OR.;
         SC6->C6_NUM     < MV_PAR09 .Or. SC6->C6_NUM     > MV_PAR10 .OR.;
         SC6->C6_PRODUTO < MV_PAR11 .Or. SC6->C6_PRODUTO > MV_PAR12 .OR.;
         Alltrim(SC6->C6_BLQ) == "R"
         dbSelectArea("SC6")
         dbSkip()
         Loop
      Endif

      _nProgAtu := _nProgAtu + 1

      If SC6->C6_QTDVEN != SC6->C6_QTDENT
         _cDia := dDataBase - SC6->C6_ENTREG
         _cOrdem := "1"
      Else
         _cDia := SC6->C6_DATFAT - SC6->C6_ENTREG
         If _cDia < 0
            _cOrdem := "2"
         ElseIf _cDia == 0
            _cOrdem := "3"
         ElseIf _cDia > 0
            _cOrdem := "4"
         Endif      
      Endif   
        
      dbSelectArea("TRB")
      RecLock("TRB",.T.)
         TRB->ACUMUL  := "2"
         TRB->ORDEM   := _cOrdem
         TRB->QTDIA   := strZero(_cDia,5)
         TRB->CLIENTE := SC6->C6_CLI
         TRB->LOJA    := SC6->C6_LOJA
         TRB->NOMECLI := _cNomeCli
         TRB->PEDIDO  := SC6->C6_NUM
         TRB->ITEM    := SC6->C6_ITEM
         TRB->PRODCLI := SC6->C6_CPROCLI
         TRB->PRODUTO := SC6->C6_PRODUTO
         TRB->DTENT   := SC6->C6_ENTREG
         TRB->DTFAT   := SC6->C6_DATFAT
         TRB->QTDPED  := SC6->C6_QTDVEN
         TRB->QTDENT  := SC6->C6_QTDENT        
      MsUnLock()
   
      dbSelectArea("SC6")
      dbSkip()
   EndDo
EndDo


Return


      
Static Function ImpTrb()



/*
                             Analitico
Periodo Acumulado :  

01 Dia(s)

Cliente Pedido It Cod.Cliente     Cod.Pasy        Entrega  Dt.Fatur. Dias
999999999999999999999999999999999999999999999999999999999999999999999999999
0       8      16 18              34              50       59        69

                              Sintético

Cliente Lj  Nome do Cliente      Qtde Total de Programas 
999999999999999999999999999999999999999999999999999999999
0       8   12                   33


Entregue 02 Dia(s) Antecipado(s) : 05 Programacao(oes)
Entregue 01 Dia(s) Antecipado(s) : 02 Programacao(oes)
Entregue na Data Prevista        : 10 Programacao(oes)
Entregue 01 Dia(s) Atrasado(s)   : 01 Programacao(oes)
Entregue 02 Dia(s) atrasado(s)   : 05 Programacao(oes)

*/
dbSelectArea("TRB")
dbGotop()

SetRegua(RecCount())

While !EOF()

   IncRegua()

   If lAbortPrint
      @_nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   If _lAnalit
      If _nLin > 58 .Or. TRB->ACUMUL == "2"
         Cabec(Titulo,CabecA,Cabec2,NomeProg,tamanho,nTipo)
         _nLin := 8
      Endif

      If TRB->ACUMUL == "1"
         @_nLin,00 PSAY "Periodo Anterior : "+ Dtoc(MV_PAR03) +" Ate " + DTOC(MV_PAR01-1)
      ElseIf TRB->ACUMUL == "2"
         @_nLin,00 PSAY "Periodo Atual : "+ Dtoc(MV_PAR01) +" Ate " + DTOC(MV_PAR02)
      Endif          

      _nLin+=2                
      _nAcumul := TRB->ACUMUL

      While !Eof() .And. _nAcumul == TRB->ACUMUL

         _cDia := TRB->QTDIA                 
         _nLin++
   
         If Val(_cDia) < 0 .And. Empty(TRB->DTFAT)
            @_nLin,00 PSAY "Entrega Futura :"+Transform((Val(_cDia)*-1),"@E 99999") +" A Vencer :              "
         ElseIf Val(_cDia) < 0
			@_nLin,00 PSAY "Entregue       : "+Transform((Val(_cDia)*-1),"@E 99999") +" Dia(S) Antecipado(s) : "
         ElseIf Val(_cDia) == 0 .And. Empty(TRB->DTFAT)
            @_nLin,00 PSAY "Entrega Futura :"+Transform((Val(_cDia)*-1),"@E 99999") +" A Vencer :              "
         ElseIf Val(_cDia) == 0      
            @_nLin,00 PSAY "Entregue na Data Prevista"           
         ElseIf Val(_cDia) > 0
            If TRB->ORDEM == "1"
               _cTexto := "Nao Entregue : "
            Else
               _cTexto := "Entregue : "
            Endif   
            @_nLin,00 PSAY _cTexto + Transform((Val(_cDia)),"@E 99999") +" Dia(S) Atrasado(S)"
         Endif   
         _nLin+=2
                  
         While !Eof() .And.  _cDia == TRB->QTDIA
        
            IncRegua()
            
            If _nLin > 58
               Cabec(Titulo,CabecA,Cabec2,NomeProg,Tamanho,nTipo)
               _nLin := 8
            Endif
         
            @_nLin,00 PSAY TRB->CLIENTE
            @_nLin,08 PSAY TRB->PEDIDO 
            @_nLin,15 PSAY TRB->ITEM
            @_nLin,18 PSAY TRB->PRODCLI
            @_nLin,34 PSAY TRB->PRODUTO
            @_nLin,50 PSAY DTOC(TRB->DTENT)
            @_nLin,59 PSAY DTOC(TRB->DTFAT)
            @_nLin,69 PSAY +Transform((Val(_cDia)),"@E 99999")
            _nLin++
            
            dbSelectArea("TRB")
            dbSkip()
         EndDo
      EndDo
   Else
      If _nLin > 58 
         Cabec(Titulo,CabecS,Cabec2,NomeProg,tamanho,nTipo)
         _nLin := 8
      Endif

      If TRB->ACUMUL == "1"
         @_nLin,00 PSAY "Periodo Anterior : "+ Dtoc(MV_PAR03) +" Ate " + DTOC(MV_PAR01-1)
      ElseIf TRB->ACUMUL == "2"
         _nlin++
         @_nLin,00 PSAY "Periodo Atual : "+ Dtoc(MV_PAR01) +" Ate " + DTOC(MV_PAR02)
      Endif

      _nLin+=2
      @_nLin,00 PSAY TRB->CLIENTE
      @_nLin,08 PSAY TRB->LOJA
      @_nLin,12 PSAY TRB->NOMECLI
      @_nLin,33 PSAY IIf(TRB->ACUMUL == "1",Transform(_nProgAcu,"@E 99999"),Transform(_nProgAtu,"@E 99999")) + " Programacao(oes)"
      _nLin+=2
      
      _nAcumul := TRB->ACUMUL

      While !Eof() .And. _nAcumul == TRB->ACUMUL

         _cDia    := TRB->QTDIA
         _nTotDia := 0
         _nTotFat := 0
         _nTotNFat:= 0
         _nFatAnt := 0

         While !Eof() .And.  _cDia == TRB->QTDIA

            IncRegua()

            _nTotDia++

            If TRB->ORDEM == "4"
               _nTotFat++
			ElseIf TRB->ORDEM == "2"
	            _nFAtAnt++               
            ElseIf TRB->ORDEM == "1"
               _nTotNFat++
            Endif

            dbSelectArea("TRB")
            dbSkip()
         EndDo

         If _nLin > 58
            Cabec(Titulo,CabecS,Cabec2,NomeProg,Tamanho,nTipo)
            _nLin := 8
         Endif

         If Val(_cDia) < 0 .And. Empty(TRB->DTFAT)
            @_nLin,00 PSAY "Entrega Futura :"+Transform((Val(_cDia)*-1),"@E 99999") +" A Vencer :              "+Transform(_nTotDia ,"@E 9999")+" Programacao(oes)"
         ElseIf Val(_cDia) < 0
			@_nLin,00 PSAY "Entregue       : "+Transform((Val(_cDia)*-1),"@E 99999") +" Dia(S) Antecipado(s) : "+Transform(_nFatAnt ,"@E 9999")+" Programacao(oes)"
         ElseIf Val(_cDia) == 0 .And. Empty(TRB->DTFAT)
            @_nLin,00 PSAY "Entrega Futura :"+Transform((Val(_cDia)*-1),"@E 99999") +" A Vencer :              "+Transform(_nTotDia ,"@E 9999")+" Programacao(oes)" 
         ElseIf Val(_cDia) == 0
            @_nLin,00 PSAY "Entregue na Data Prevista :                   "+Transform(_nTotDia ,"@E 9999")+" Programacao(oes)"
         ElseIf Val(_cDia) > 0
            If _nTotFat > 0
               @_nLin,00 PSAY "Entregue       : "+Transform((Val(_cDia)),"@E 99999") +" Dia(S) Atrasado(S)   : "+Transform(_nTotFat ,"@E 9999")+" Programacao(oes)"                                    
            ElseIf _nTotNFat > 0
               @_nLin,00 PSAY "Nao Entregue   : "+Transform((Val(_cDia)),"@E 99999") +" Dia(S) Atrasado(S)   : "+Transform(_nTotNFat ,"@E 9999")+" Programacao(oes)"               
            Endif   
         Endif   

         _nLin++
      EndDo
   Endif
EndDo

If _nLin != 80
   Roda(cbCont,cbTxt,tamanho)
Endif         

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return