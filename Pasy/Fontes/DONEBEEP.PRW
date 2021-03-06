#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DONEBEEP �Autor  � JULIO STORINO      � Data �  21/09/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � FUNCAO PARA TOCAR UM SOM WAV/MP3/MID A PARTIR DO PROTHEUS  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Feito para P10 (Nao testado em outras versoes)            ���
��           � Feito para P10 (Nao testado em outras versoes)            ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function DoneBeep(cSom)

Local   cDirCli := GetClientDir()
Local   cDirSrv := '\Media\'
Default cSom    := 'Ave_maria.wav'

//Verifica a existencia dos arquivos necess�rio localmente
If !File(cDirCli+'SndRec32.exe')
	//Tenta copiar do servidor
	CPYS2T(cDirSrv+'SndRec32.exe',cDirCli,.F.)
EndIF

If !File(cDirCli+'RunProcess.exe')
	//Tenta copiar do servidor
	CPYS2T(cDirSrv+'RunProcess.exe',cDirCli,.F.)
EndIF

//Verifica a existencia do som solicitado
If !File(cDirCli+'cSom')
	//Tenta copiar do servidor
	CPYS2T(cDirSrv+cSom,cDirCli,.F.)
EndIF

WINEXEC(cDirCli+'Runprocess.exe /k:60s SndRec32.exe /play /close /embedding '+cDirCli+cSom,0)

RETURN( Nil )
