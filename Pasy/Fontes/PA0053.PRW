#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PA0053   � Autor � Alexandro da Silva � Data �  17/02/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Operadores,Prensistas e Inspetores             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SigaEst                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PA0053()


Local cVldAlt := ".T."
Local cVldExc := ".T."

Private cString := "SZ8"

dbSelectArea("SZ8")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Inspetores ",cVldAlt,cVldExc)

Return