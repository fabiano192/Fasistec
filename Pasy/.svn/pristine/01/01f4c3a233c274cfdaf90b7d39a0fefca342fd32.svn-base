#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PA0028    ºAutor  ³Microsiga           º Data ³  20/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Acerto das Ordens de Producao                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/               


User Function PA0028()


////////////////////////////////////////////////
////////////////////////////////////////////////
/////  Grupo de Pergunta PA0028           //////
/////  MV_PAR01 : Ordem de Producao De ?  //////
/////  MV_PAR02 : Ordem de Producao Ate?  //////
/////  MV_PAR03 : Dt.Entrega De ?         //////
/////  MV_PAR04 : Dt.Entrega Ate?         //////
/////  MV_PAR05 : Dt.Emissao De ?         //////
/////  MV_PAR06 : Dt.Emissao Ate?         //////
////////////////////////////////////////////////
////////////////////////////////////////////////

If !Pergunte("PA0028",.T.)
   Return
Endif

Private _nValor1 := 0
Private _nValor2 := 0

Private _lFim      := .F.
Private _cMsg01    := 'Atualizando Ordem de Producao!!!'
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| RunProc(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )


Return


Static Function RunProc(_lFim)

dbSeLectArea("SC2")
dbSetOrder(1)
dbGotop()

_nRec := LastRec()
ProcRegua(_nRec)

While !Eof() 

   If _lFim
      Alert("Cancelado Pelo Usuario!!!")
      Return
   Endif

   IncProc()
   
   If !Empty(SC2->C2_DATRF)
      dbSelecTarea("SC2")
      dbSkip()
      Loop
   Endif   

   If SC2->C2_QUANT == SC2->C2_QUJE
      dbSelecTarea("SC2")
      dbSkip()
      Loop
   Endif   
   
   _cOp := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN 

   If _cOp            < MV_PAR01 .Or. _cOp            > MV_PAR02  .Or.;
      SC2->C2_DATPRF  < MV_PAR03 .Or. SC2->C2_DATPRF  > MV_PAR04  .Or.;
      SC2->C2_EMISSAO < MV_PAR05 .Or. SC2->C2_EMISSAO > MV_PAR06      
      dbSelecTarea("SC2")
      dbSkip()
      Loop
   Endif
   
   dbSelectArea("SC2")
   RecLock("SC2",.F.)
      SC2->C2_DATRF := dDataBase
      SC2->C2_OBS   := "ELIMINADO"
   MsUnlock()
   
   dbSelectArea("SD4")
   dbSetOrder(2)
   If dbSeek(xFilial("SD4")+_cOp)
      
      While !Eof() .And. _cOp == SD4->D4_OP
      
         dbSelectArea("SD4")
         RecLock("SD4",.F.)
            SD4->D4_QUANT   := SD4->D4_QTDEORI
            SD4->D4_SITUACA := "E" // Eliminado Residuo
         MsUnlock()
         
         dbSkip()
      EndDo
   Endif   
      
   dbSelectArea("SC2")
   dbSkip()
EndDo

Return