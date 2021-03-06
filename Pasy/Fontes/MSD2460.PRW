#INCLUDE "rwmake.ch"

/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � MSD2460 � Autor �Alexandro da Silva     � Data � 31/08/01 ���
������������������������������������������������������������������������Ĵ��
���Descri��o �                                                           ���
������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga.                       ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������

/*/

User Function MSD2460()

_aAliORI  := GetArea()
_aAliSZ2  := SZ2->(GetArea())

SZ2->(dbSetOrder(1))
If SZ2->(dbSeek(xFilial("SZ2") + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD + SC6->C6_CPROCLI+"1"))
	If SZ2->Z2_TPAPROV == "2"
		SZ2->(RecLock("SZ2",.F.))
		SZ2->Z2_TPAPROV := "4"
		SZ2->(MsUnLock())
	Endif
Endif

dbSelectArea("SD2")
RecLock("SD2",.F.)
SD2->D2_PROCLI := SC6->C6_CPROCLI
SD2->D2_PEDCLI := SC6->C6_PEDCLI
If SD2->D2_EST == "EX"
	SD2->D2_DESCON := 0
Endif
SD2->D2_REVPED := SC6->C6_REVPED
MsUnlock()

RestArea(_aAliSZ2)
RestArea(_aAliOri)

Return