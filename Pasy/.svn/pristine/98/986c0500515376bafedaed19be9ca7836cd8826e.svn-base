#include "rwmake.ch"  


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FA080TIT ³ Autor ³ Alexandro da Silva    ³ Data ³ 07.03.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina Para informar o valor do desconto no momento da BX. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN - Especifico Irmaos Lopes                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FA080POS()


SetPrvt("_CALIORI,_NORDORI,_NRECORI,_CDESD,_AVALOR,_NSOMA")
SetPrvt("_CALISE2,_NORDSE2,_NRECSE2,_NRECNO,_ACAMPOSE2,_W")
SetPrvt("_I,_NVALOR,_DDATA,_NPOS,_CPARC,_CALISEA")
SetPrvt("_NORDSEA,_NRECSEA,")

_cAliORI := Alias()
_nOrdORI := IndexOrd()
_nRecORI := Recno()

dbSelectArea("SEF")
_cAliSEF := Alias()
_nOrdSEF := IndexOrd()
_nRecSEF := Recno()
dbOrderNickName("INDSEF1")
If dbSeek(xFilial("SE2")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
   cBanco   := SEF->EF_BANCO
   cAgencia := SEF->EF_AGENCIA
   cConta   := SEF->EF_CONTA
   cCheque  := IIf (ALLTRIM(SEF->EF_ORIGEM) == "FINA080",space(15),SEF->EF_NUM)
Endif

If SE2->E2_VLDESC > 0 .Or. SE2->E2_VLJUROS > 0
   nDescont := SE2->E2_VLDESC
   nMulta   := SE2->E2_VLJUROS
   nValPgto := nValPgto - SE2->E2_VLDESC + SE2->E2_VLJUROS
Endif   

dbSelectArea(_cAliSEF)
dbSetorder(_nOrdSEF)    
dbGoto(_nRecSEF)

dbSelectArea(_cAliOri)
dbSetorder(_nOrdOri)    
dbGoto(_nRecOri)

Return .T.