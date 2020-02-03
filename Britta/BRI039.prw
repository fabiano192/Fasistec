#INCLUDE 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BRI039   �Autor  �MARCIO AFLITOS      � Data �  09/08/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �CADASTRO DE CONTROLE DE ACESSO AS ROTINAS  E FUNCOES DO     ���
���          �SISTEMA                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER Function BRI039()


Local cVldAlt := ".T." // Operacao: ALTERACAO
Local cVldExc := ".T." // Operacao: EXCLUSAO

ZZZ->(dbSetOrder(1))

AxCadastro("ZZZ","Controle de Acesso a Rotinas e Fun��es", cVldExc, cVldAlt)

Return 


USER FUNCTION ConPadChk()

LOCAL _cConPad:="" , lCP
LOCAL aPsw

PRIVATE cRetCons:=M->ZZZ_NOME

_cConPad:=IIF( M->ZZZ_TIPO ==  "G", "CHKGRP" , "CHKUSU")

lCP:=CONPAD1(,,,(_cConPad),"cRetCons",.T.,.T.) 

IF lCP .AND. .NOT. Empty(cRetCons)
	M->ZZZ_NOME := cRetCons
ENDIF
	
RETURN cRetCons	                    	