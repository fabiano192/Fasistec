#include "rwmake.ch"
//#DEFINE MAXPASSO 1600
//#DEFINE MAXPASSO1 1700

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_REGUAS   �Autor  � Renato K. Ikeda    � Data �  06/13/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Exemplo de 2 reguas de processamento                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Regua()
oProcess := MsNewProcess():New({|| CtRe190Proc(oProcess)},"","",.F.)
oProcess:cTitle:="Teste Regua"  //T�tulo da Tela de Processamento
oProcess:Activate()		
Return


Static Function CtRe190Proc(oProcess)
//Local i
//Local j
oProcess:SetRegua1(50)	
For i:=1 to 50
	oProcess:IncRegua1("Atualizando Regua1:  "+STR(i))//Incrementa primeira r�gua
	
	oProcess:SetRegua2(1700)
	For j:=1 to 1700
		oProcess:IncRegua2("Atualizando Regua2:  "+STR(j))//Incrementa segunda r�gua
	Next J
Next I

//oProcess:SetRegua2(6000)
//For j:=1 to 6000
//	oProcess:IncRegua2("Atualizando Regua2:  "+STR(j))//Incrementa segunda r�gua
//Next

Return