#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ACESC7   � Autor �Alexandro da Silva     � Data � 19.03.04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Acerto dos Registros do SC7                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                   -                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ACESG1()


Processa({|lend| ACESG11()},"Deletando Cadastro de Estrutura ....")

MSGINFO("Alteracao Efetuada com Sucesso !!! ")


Static Function ACESG11()

dbSelectArea("SG1")
dbSetOrder(1)
dbGotop()

ProcRegua(LastRec())

While !Eof()
	
	_cProduto := SG1->G1_COD
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial()+_cProduto)
	
	If Alltrim(SB1->B1_GRUPO) != "PIC"
		dbSelectArea("SG1")
		dbSkip()
		Loop
	Endif
	
	//   NECESG1(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
	
	SG1->(RecLock("SG1",.F.))
	SG1->(dbDelete())
	SG1->G1_OBSERV := "DELETADO"
	SG1->(MsUnlock())
	
	dbSelectArea("SG1")
	dbSkip()
EndDo

Return