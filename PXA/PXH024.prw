#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �  PXH024  � Autor � NILTON CESAR          � Data � 04.05.02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Executa fun��o AXCADASTRO para alterar alguns parametros   ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAFAT - Menu atualiza��es                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function PXH024()

local nlin:=0
local nlnDlg:= 100
local nspForm:=60

Private xfil := space(5)
Private dtafat01,dtafat02,dtafat03,dtafat04,dtafat05,dtafat06,dtafat08,dtafat21,dtafin,dtafis,qtdiasnf,dtvirada

DbSelectArea("SX6")
DbSetorder(1)

//If	dbSeek(xFilial("SX6")+"MV_DATAFIN")
	dtafin   := GetMv("MV_DATAFIN")
	nlnDlg+=nspForm
//endif

//DbSeek(xFilial("SX6")+"MV_DATAFIS")
dtafis   := GetMv("MV_DATAFIS")
nlnDlg+=nspForm

dtvirada  := GetMv("MV_ULMES")
nlnDlg+=nspForm

@ 090,40 to nlnDlg /*430*/,500 Dialog oDlg1 Title "Parametros de fechamento de financeiro,faturamento e fiscal"

nlin:= 020

@ nlin,15 say "Financeiro:"
@ nlin,100 get dtafin   Size 50,100 when .T.//cNivel > 7
nlin+=20

@ nlin,15 say "Fiscal:"
@ nlin,100 get dtafis   Size 50,100 when .T. //cNivel > 5
nlin+=20

@ nlin,15 say "Virada do Estoque...:"
@ nlin,100 get dtvirada Size 50,100 when .T.//cNivel > 7
nlin+=20

@ nlin,100 BmpButton Type 1  Action fGrava()
@ nlin,140 BmpButton Type 2  Action Close(oDlg1)
nlin+=20

Activate Dialog oDlg1 Centered

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � fgrava   � Autor � NILTON CESAR          � Data � 04.05.02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gravar as alteracoes nos parametros                        ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAFAT - Menu atualiza��es                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static function fgrava()
//If cNivel < 6
//	Alert('Nivel de usu�rio nao permitido!')
//	Return
//Endif
Close(oDlg1)

DbSelectArea("SX6")
DbSetorder(1)

If DbSeek(xFilial("SX6")+"MV_DATAFIN")
	While !Reclock("SX6",.f.);EndDo
	SX6->X6_CONTEUD := Alltrim(Dtoc(dtafin))
	MsUnlock()
Endif

If DbSeek(xFilial("SX6")+"MV_DATAFIS")
	While !Reclock("SX6",.f.);EndDo
	SX6->X6_CONTEUD := Alltrim(Dtoc(dtafis))
	MsUnlock()
endif
                          
PutMV("MV_DATAFIN",dtafin)
PutMV("MV_DATAFIS",dtafis)
PutMV("MV_ULMES",dtvirada)

Return