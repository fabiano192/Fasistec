#include "rwmake.ch"  


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FA60BDE � Autor � Alexandro da Silva    � Data � 22.11.04  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina Para Altera��o do Fluxo de Caixa                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAFIN - Especifico Irmaos Lopes                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FA60BDE()

_aAliOri := GetArea()
_aAliSA6 := SA6->(GETAREA())

_lFluxo := .F.
dbSelectArea("SA6")
dbSetOrder(1)
If dbSeek(xFilial()+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA)
   If SA6->A6_FLUXCAI != "N"
      _lFluxo := .T.
   Endif
Endif
     
If !_lFluxo
   dbSelectArea("SE1")
   RecLock("SE1",.F.)
   SE1->E1_FLUXO := "N"
   MsUnlock()
Endif

RestArea(_aAliSA6)
RestArea(_aAliOri)

Return