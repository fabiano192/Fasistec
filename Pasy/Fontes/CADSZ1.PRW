#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Cad. SZ1  � Autor � Ivan M. Tore       � Data �  30/01/01   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Tipo de Produtos x Mensagens (SZ1)             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CADSZ1


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cString
Private cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Private cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private cString := "SZ1"

dbSelectArea("SZ1")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Tipos Produtos x Mensagens",cVldAlt,cVldExc)

Return
