#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Pa0012    º Autor ³ Alexandro da Silva º Data ³  12/04/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Demonstrativo de Consumo                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaCom                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0012()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cString
Private aOrd           := {}
Private CbTxt        := ""
Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := "Ranking de Compras"
Private cPict          := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
//Private limite       := 80
Private limite       := 132
Private tamanho      := " "
Private nomeprog     := "PA0012" 
Private nTipo        := 15//18
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "PA0012"
Private titulo         := "Ranking de Materiais Por $ Compras"
Private nLin           := 80
Private Cabec1         := "Produto         Desc. do Produto                                  Valor      Valor IPI        Qtde UM      Valor/Qtde Ranking"
Private Cabec2         := ""
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private imprime        := .T.
Private wnrel        := "PA0012"

Private cString := "SD1"
Private cArqLog := ""

dbSelectArea("SD1")
dbSetOrder(1)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±±       ºGrupo de Perguntas ³Pa0012       º±±
±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//////////////////////////////////////////////
//////////////////////////////////////////////
///   Variavel     /// Descricao        //////
///   MV_PAR01     /// Data De       ?  //////
///   MV_PAR02     /// Data Ate      ?  ////// 
///   MV_PAR03     /// Tipo De       ?  //////
///   MV_PAR04     /// Tipo Ate      ?  //////
///   MV_PAR05     /// Grupo De      ?  ////// 
///   MV_PAR06     /// Grupo Ate     ?  //////
///   MV_PAR07     /// SubGrupo De   ?  //////
///   MV_PAR08     /// SubGrupo Ate  ?  //////
///   MV_PAR09     /// Produto De    ?  ////// 
///   MV_PAR10     /// Produto Ate   ?  //////
///   MV_PAR11     /// Fornecedor De ?  ////// 
///   MV_PAR10     /// Fornecedor Ate?  //////
//////////////////////////////////////////////
*/

pergunte(cPerg,.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,"")
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,"",,.F.)

nTipo  := If(aReturn[4]==1,15,18)
_nCont := If(aReturn[4]==1,70,57)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                         
Processa( {|| GeraTrb() } )
RptStatus({|| ImpRel(Cabec1,Cabec2,Titulo,nLin) },Titulo)

dbSelectArea("TRB")
dbCloseArea("TRB")

fErase(cArqLog+".DBF")
FErase(cArqLog+OrdBagExt())
//FErase(cArqLog2+OrdBagExt())
/*
dbSelectArea("RES")
dbCloseArea("RES")
fErase(cArqRes+".DBF")
FErase(cArqRes+OrdBagExt())
*/  

Return



Static Function GeraTrb()

aStru := {}
AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
AADD(aStru,{"DESCRIC"  , "C" , 50, 0 })
AADD(aStru,{"QTDE"     , "N" , 11, 2 })
AADD(aStru,{"UM"       , "C" ,  2, 0 })
AADD(aStru,{"VALOR"    , "N" , 14, 2 })
AADD(aStru,{"VLIPI"    , "N" , 14, 2 })
AADD(aStru,{"VLMEDIA"  , "N" , 14, 2 })
AADD(aStru,{"VLTOTAL"  , "N" , 14, 2 })

cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "PRODUTO"

dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

/*
aRes := {}
AADD(aRes,{"TIPO"     , "C" ,  2, 0 })
AADD(aRes,{"DESTIPO"  , "C" ,  30, 0 })
AADD(aRes,{"GRUPO"    , "C" ,  4, 0 })
AADD(aRes,{"DESGRUPO" , "C" ,  30, 0 })
AADD(aRes,{"VALOR"    , "N" ,  14, 2 })

cArqRes := CriaTrab(aRes,.T.)
cIndRes := "TIPO+GRUPO"
dbUseArea(.T.,,cArqRes,"RES",.F.,.F.)
dbSelectArea("RES")
IndRegua("RES",cArqRes,cIndRes,,,"Criando Trabalho...")
*/

dbSelectArea("SD1")
dbSetOrder(6)
dbSeek(xFilial("SD1")+Dtos(MV_PAR01),.T.)

Procregua(Lastrec())

While !Eof() .And. SD1->D1_DTDIGIT <= MV_PAR02

   IncProc()
   
   If nLastKey == 27
      Return
   Endif

   If SD1->D1_TIPO != "N"
      dbSelectArea("SD1")
      dbSkip()
      Loop
   Endif  
   
   If SD1->D1_DTDIGIT < MV_PAR01 .Or. SD1->D1_DTDIGIT > MV_PAR02 .Or.;
      SD1->D1_COD     < MV_PAR09 .Or. SD1->D1_COD     > MV_PAR10 .Or.;
      SD1->D1_FORNECE < MV_PAR11 .Or. SD1->D1_FORNECE > MV_PAR12
      dbSelectArea("SD1")
      dbSkip()
      Loop
   Endif   
      
   
   dbSelectarea("SB1")
   dbSetOrder(1)
   dbSeek(xFilial("SB1")+SD1->D1_COD)
   
   If SB1->B1_TIPO  < MV_PAR03 .Or. SB1->B1_TIPO  > MV_PAR04 .Or.;
      SB1->B1_GRUPO < MV_PAR05 .Or. SB1->B1_GRUPO > MV_PAR06 .Or.;
      SB1->B1_SUBGR < MV_PAR07 .Or. SB1->B1_SUBGR > MV_PAR08
      dbSelectArea("SD1")
      dbSkip()
      Loop
   Endif   
      
   dbSelectArea("SF4")
   dbSetOrder(1)
   If dbSeek(xFilial("SF4")+SD1->D1_TES)
      If SF4->F4_DUPLIC != "S"
         dbSelectArea("SD1")
         dbSkip()
         Loop
      Endif   
   Endif      

   dbSelectArea("TRB")
   If !dbSeek(SD1->D1_COD)
      dbSelectArea("TRB")
      RecLock("TRB",.T.)
         TRB->PRODUTO := SD1->D1_COD
         TRB->DESCRIC := SB1->B1_DESC
         TRB->VALOR   := SD1->D1_TOTAL
         TRB->VLIPI   := SD1->D1_VALIPI
         TRB->QTDE    := SD1->D1_QUANT
         TRB->UM      := SB1->B1_UM
         TRB->VLTOTAL := SD1->D1_TOTAL + SD1->D1_VALIPI
      MsUnlock()
   Else
      dbSelectArea("TRB")
      RecLock("TRB",.F.)
         TRB->VALOR   += SD1->D1_TOTAL
         TRB->VLIPI   += SD1->D1_VALIPI
         TRB->QTDE    += SD1->D1_QUANT
         TRB->VLTOTAL += (SD1->D1_TOTAL + SD1->D1_VALIPI)
      MsUnlock()
   Endif   
         
   dbSelectArea("SD1")
   dbSkip()
EndDo   

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ImpRel    º Autor ³ AP5 IDE            º Data ³  12/04/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ImpRel(Cabec1,Cabec2,Titulo,nLin)

/*
Produto(15)     Desc. do Produto(40)                     Valor(14)      Valor Ipi(14)  Qtde(11)    UM  Media(14)      Ranking(5)
Produto         Desc. do Produto                                  Valor      Valor Ipi        Qtde UM      Valor/Qtde Ranking   
999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
0               16                                       57             72             87          99  103            118
                Total Geral ---------> "
*/


dbSelectArea("TRB")
cArqLog2 := CriaTrab("",.F.)
cInd     := "DESCEND(STR(TRB->VALOR,17,2))"
IndRegua("TRB",cArqLog2,cInd,,,"Criando Trabalho...")

dbSelectArea("TRB")
dbGoTop()

SetRegua(RecCount())
nRank     := 1
_nValor   := 0
_nVlIPI   := 0
_nVlQtde  := 0

While !EOF()

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > _nCont //55
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
      @nLin,16  PSAY "Periodo de "+Dtoc(mv_par01) +" Ate "+ Dtoc(MV_PAR02) 
      nLin +=2
   Endif

   @nLin,00  PSAY TRB->PRODUTO
   @nLin,16  PSAY Substr(TRB->DESCRIC,1,40)
   @nLin,57  PSAY TRB->VALOR                        Picture "@E 999,999,999.99"
   @nLin,72  PSAY TRB->VLIPI                        Picture "@E 999,999,999.99"
   @nLin,87  PSAY TRB->QTDE                         Picture "@E 99999999.99"      
   @nLin,99  PSAY TRB->UM     
   @nLin,103 PSAY Round((TRB->VALOR / TRB->QTDE),2) Picture "@E 999,999,999.99"      
   @nLin,118 PSAY nRank                             Picture "@E 99999"         
   nLin ++
   
   _nValor   += TRB->VALOR
   _nVlIPI   += TRB->VLIPI
   _nVlQtde  += TRB->QTDE
   
   nRank++
   dbSelectArea("TRB")
   dbSkip() 
EndDo

nLin ++


If nLin > 57 
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   nLin := 8
   @nLin,16  PSAY "Periodo de "+Dtoc(mv_par01) +" Ate "+ Dtoc(MV_PAR02) 
   nLin +=2
   @nLin,16  PSAY " Total Geral ---------> "
   @nLin,57  PSAY _nValor      Picture "@E 999,999,999.99"
   @nLin,72  PSAY _nVlIPI      Picture "@E 999,999,999.99"
   @nLin,87  PSAY _nVlQtde     Picture "@E 99999999.99"      
Else
   @nLin,16  PSAY " Total Geral ---------> "
   @nLin,57  PSAY _nValor      Picture "@E 999,999,999.99"
   @nLin,72  PSAY _nVlIPI      Picture "@E 999,999,999.99"
   @nLin,87  PSAY _nVlQtde     Picture "@E 99999999.99"      
Endif

Roda(cbCont,cbTxt,tamanho)   

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return