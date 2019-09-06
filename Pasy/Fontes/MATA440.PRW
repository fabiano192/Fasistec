#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATA440 ³ Autor ³Alexandro da Silva     ³ Data ³ 11/10/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualizar Pedidos Liberados SC9                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga.                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

/*/

User Function MATA440()

_cAliORI  := Alias()
_nOrdORI  := IndexOrd()
_nRecORI  := Recno()

_wPedido  := M->C5_NUM   
_wItem    := "01"   

dbselectArea("SC9")
_cAliSC9   := Alias()
_nOrdSC9   := IndexOrd()
_nRecSC9   := Recno()
dbSetOrder(1)
dbSeek(xFilial("SC9")+M->C5_NUM+ "01",.T.)  

dbselectArea("SC6")
_cAliSC6 := Alias()
_nOrdSC6 := IndexOrd()
_nRecSC6 := Recno()
dbSelectArea("SC9")

While !Eof() .And. SC9->C9_PEDIDO == M->C5_NUM

   dbselectArea("SC6")
   dbSetorder(1)
   If dbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)
      dbSelectArea("SC9")
      RecLock("SC9",.F.)
         SC9->C9_PEDCLI  := SC6->C6_PEDCLI
         SC9->C9_CPROCLI := SC6->C6_CPROCLI
      MsUnlock()
   Endif      
   
   dbSelectArea("SC9")
   dbSkip()
EndDo   

dbSelectArea(_cAliSC6)
dbSetOrder(_nOrdSC6)
dbGoTo(_nRecSC6)

dbSelectArea(_cAliSC9)
dbSetOrder(_nOrdSC9)
dbGoTo(_nRecSC9)   

dbSelectArea(_cAliORI)
dbSetOrder(_nOrdORI)
dbGoTo(_nRecORI)

Return