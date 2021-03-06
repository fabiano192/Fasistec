/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PXH040    �Autor  �MARCIO AFLITOS      � Data �  09/08/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �CADASTRO DE CONTROLE DE ACESSO AS ROTINAS  E FUNCOES DO     ���
���          �SISTEMA                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER Function PXH040()

Local cVldAlt := ".T." // Operacao: ALTERACAO
Local cVldExc := ".T." // Operacao: EXCLUSAO

ZZZ->(dbSetOrder(1))

AxCadastro("ZZZ","Controle de Acesso a Rotinas e Fun��es", cVldExc, cVldAlt)

RETURN NIL


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

USER FUNCTION ChkUsu()

LOCAL lReturn:=.F.
LOCAL _VR:=""
LOCAL _cId
LOCAL _lUsu

_VR:=IIF( Type("M->ZZZ_CODUSU")<>"C", "ZZZ","M")
_cId:=M->ZZZ_CODUSU
_lUsu:= (M->ZZZ_TIPO=="U")

PswOrder(1)
IF PswSeek( _cId ,_lUsu )
	lReturn:=.T.
	IIF( _VR=="M", M->ZZZ_NOME := PswRet()[1][2], NIL )
ELSE
	Alert("USU�RIO ou GRUPO N�O CADASTRADO")
ENDIF

RETURN lReturn
