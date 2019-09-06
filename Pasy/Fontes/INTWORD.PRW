/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ INTWORD  ³   Adalberto Moreno Batista    ³ Data ³03.04.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Faz a integracao do Protheus com o MS Word                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
O objetivo eh fazer a integracao entre o Protheus e o MS Word.

/*/
#include "rwmake.ch"          

User Function intword()
@ 96,012 TO 250,400 DIALOG oDlg TITLE OemToAnsi("Integracao com MS-Word")
@ 08,005 TO 048,190
@ 18,010 SAY OemToAnsi("Esta rotina ira imprimir os orcamentos conforme os parametros digitados.")

@ 56,130 BMPBUTTON TYPE 1 ACTION WordImp()
@ 56,160 BMPBUTTON TYPE 2 ACTION Close(oDlg)

ACTIVATE DIALOG oDlg CENTERED

Return()



Static Function WordImp()
Local wcOrcam, wcData, wcCliente, wcNroLinha
Local waCod		:= {}
Local waDescr	:= {}
Local waVTot	:= {}
Local nAuxTot	:= 0
Local nK
Local cPathDot		:= "\\SERVER2\erp\Protheus10\INTWORD.DOT"
Private	hWord

Close(oDlg)

wcNumero	:= "121212"
wcData		:= AllTrim(Str(Day(dDataBase),2))+' de '+AllTrim(MesExtenso(dDataBase))+' de '+AllTrim(Str(Year(dDataBase),4))
wcCliente	:= "CLIENTE TESTE INTEGRACAO WORD"

for nK := 1 to 10
	aAdd(waCod,"PR"+strZero(nK,3))
	aAdd(waDescr,"PRODUTO NRO "+strZero(nK,3))
	aAdd(waVTot,Transform(nK*100,"@E 999,999,999.99"))
	nAuxTot += nK*100
next

//Conecta ao word
hWord	:= OLE_CreateLink()
OLE_NewFile(hWord, cPathDot )

//Montagem das variaveis do cabecalho		
OLE_SetDocumentVar(hWord, 'Prt_numero', wcNumero)
OLE_SetDocumentVar(hWord, 'Prt_Data', wcData)
OLE_SetDocumentVar(hWord, 'Prt_Cliente', wcCliente)
OLE_SetDocumentVar(hWord, 'Prt_nroitens',str(Len(waCod)))	//variavel para identificar o numero total de
															//linhas na parte variavel
															//Sera utilizado na macro do documento para execucao 
															//do for next

//Montagem das variaveis dos itens. No documento word estas variaveis serao criadas dinamicamente da seguinte forma:
// prt_cod1, prt_cod2 ... prt_cod10
for nK := 1 to Len(waCod)
	OLE_SetDocumentVar(hWord,"Prt_Cod"+AllTrim(Str(nK)),waCod[nK])
	OLE_SetDocumentVar(hWord,"Prt_Descr"+AllTrim(Str(nK)),waDescr[nK])
	OLE_SetDocumentVar(hWord,"Prt_VTot"+AllTrim(Str(nK)),waVTot[nK])
next

OLE_ExecuteMacro(hWord,"tabitens")

OLE_SetDocumentVar(hWord, 'prt_totorc', Transform(nAuxTot,"@E 999,999,999.99"))
		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizando as variaveis do documento do Word                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_UpdateFields(hWord)
If MsgYesNo("Imprime o Documento ?")
	Ole_PrintFile(hWord,"ALL",,,1)
EndIf
		
If MsgYesNo("Fecha o Word e Corta o Link ?")
	OLE_CloseFile( hWord )
	OLE_CloseLink( hWord )
Endif	
Return()
