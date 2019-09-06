#include "rwmake.ch"                                               
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*
FABRICIO AMARO - 06/06/2011
ROTINA PARA REGISTRAR A APLICAÇÃO DOS UPDATES
RESUMO: PARA CADA UPDATE O SISTEMA IRÁ GRAVAR UM ARQUIVO COM O MESMO NOME DO UPDATE MAIS (+) A DATA DO FONTE DESSE UPDATE
SE NA PROXIMA APLICACAO O SISTEMA VERIFICAR QUE A DATA É DIFERENTE, IRA APLICAR NOVAMENTE
OBS.: SE CLICADO EM SIM PARA EXECUTAR O UPDATE, E DEPOIS CANCELAR O UPDATE (ROTINA PADRAO) FICARÁ GRAVADO NESSE LOG QUE ELE JÁ FOI EXECUTADO,
PORTANTO, PARA ESSE CASO, IR NA PASTA DO LOG E APAGAR O ARQUIVO PARA QUE ELE POSSA SER EXECUTADO NOVAMENTE.
*/

User Function MeusUpds()

Private oGera2

p11 := .T.
cLocUpd := "UPDS\" //PASTA NA SYSTEM QUE FICARÁ GUARDADO O LOG DOS UPDATES - SUGESTÃO: CRIE ESSA PASTA
cUpd := SPACE(15)

If p11
	cLocSystem := "D:\Protheus11\Protheus_data\system\" //CAMINHO COMPLETO DA PASTA SYSTEM
	cLocSmart := "D:\Protheus11\Config\bin\smartclient\" //CAMINHO COMPLETO DA PASTA SMARTCLIENT
	cTCP := "TCP" //COMUNICAÇÃO TCP COM O SERVIDOR
	cAmbiente := "CRONNOS" //AMBIENTE
	cProgCli := "SmartClient.exe" //NOME DO PROGRAMA DO SMARTCLIENT (PROTHEUS10 = TOTVSSMARTCLIENT.EXE | PROTHEUS 11 = SMARTCLIENT.EXE)
EndIf

cLog := ""
cLog2 := ""
nCont1 := 0

//VARIAVEIS ESPECIFICAS PARA A PESQUISA DAS FUNÇÕES NO RPO
aType := {}
aFile := {}
aLine := {}
aDate := {}
aTime := {}

//MONTAGEM DA TELA PARA PASSAGEM DOS PARAMETROS
@ 200,1 TO 400,400 DIALOG oGera2 TITLE OemToAnsi("Aplicação dos Updates")
@ 10,018 Say "INFORME AS INICIAIS DO UPDATE - EXEMPLO: UPDCOM | UPDEST" PIXEL OF oGera2
@ 70,018 MSGET oVar VAR cUpd Picture "@!" SIZE 040,10 PIXEL OF oGera2
@ 80,170 BMPBUTTON TYPE 01 ACTION {Close(oGera2)}

Activate Dialog oGera2 Centered

cUpd := Alltrim(cUpd)
IF Alltrim(cUpd) == ""
	Alert("Não foi informado nenhum UPDATE!")
	Return
EndIf

If MsgBox("Será iniado a execução dos UPDs. Deseja continuar?","Atenção","YESNO")

	cNomFunc := "U_"+cUpd+"*" //O * SERVE PRA PESQUISAR O RESTANTE DA STRING

	//PESQUISA AS FUNÇÕES NO RPO
	aRet := GetFuncArray(cNomFunc, @aType, @aFile, @aLine, @aDate, @aTime)

	For nCont := 1 To Len(aRet)

		//PRIMEIRO VERIFICA SE ESSE ARQUIVO JÁ EXISTE NA PASTA \SYSTEM\UPDS OU NO CAMINHO ESPECIFICADO
		cArqUpd := aRet[nCont] +"_"+ StrTran(dtoc(aDate[nCont]),"/","_")
		cArqUpd := cLocSystem + cLocUpd + cArqUpd + ".UPDATE"
		cTemArq := FOPEN(cArqUpd)
		//SE O ARQUIVO JÁ EXISTIR

		If !(cTemArq <= 0)
			cLog2 += aRet[nCont] +";"
		Else
			nCont1++
			If MsgBox("Executa "+aRet[nCont]+"?","Atenção","YESNO")
				//EXECUTA O SMARTCLIENT COM OS PARAMETROS DO UPDATE
				WinExec(cLocSmart+cPROgCli+" -P="+aRet[nCont]+" -C="+cTCP+" -E="+cAmbiente+" -M")
				//ARMAZENA O LOG GERAL
				cLog += aRet[nCont] +";"
				//CRIA NA PASTA SYSTEM O UPDATE PARA DIZER QUE ELE JÁ FOI EXECUTADO
				MemoWrite(cArqUpd,cArqUpd)
			EndIf
		EndIf
	Next

	cArq := cLocSystem + cLocUpd + cUpd + ".TXT"
	MemoWrite(cArq,cLog)

	If nCont1 > 0
		cMsg := "Compatibilizadores executado com sucesso! Foi gravado os LOG's na pasta SYSTEM"
	Else
		cMsg := "Não foi executado nenhum compatibilizador!"
	EndIf

	MsgBox(cMsg,"Acabou","INFO")

	If MsgBox("Deseja executar novamente a rotina MeusUpd's?","Meus Upds","YESNO")
		U_MEUSUPDS()
	EndIf
EndIf

Return
