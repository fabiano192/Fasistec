#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Pa0046    º Autor ³ Alexandro da Silva º Data ³  09/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍaÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Geração do arquivo do Produto Acabado com seus Compostos   º±±
±±º          ³ conforme tipo de Materia Prima.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0046()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cDescPa          := ""
_cDesMp           := ""
_cComposto        := ""
Private _cPerg    := "PA0046"
Private _oGeraTxt

Private _cString  := "Sb1"


Pergunte(_cPerg,.F.)

dbSelectArea("Sb1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 150,1 TO 380,450 DIALOG _oGeraTxt TITLE OemToAnsi("Geracao de Arquivo Conforme M.P.")
@ 02,10 TO 080,220
@ 10,018 Say " Este programa ira gerar um arquivo TIPOMP.dbf , No Diretorio  " SIZE 160,7
@ 18,018 Say " F:\ap7\ap_data\relato\tiposmp.dbf, conforme os Parametros     " SIZE 160,7
@ 26,018 Say " informados pelo Usuario.                                      " SIZE 160,7
@ 85,128 BMPBUTTON TYPE 01 ACTION Proc1()
@ 85,158 BMPBUTTON TYPE 02 ACTION Close(_oGeraTxt)
@ 85,188 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)

Activate Dialog _oGeraTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKGERATXTº Autor ³ AP5 IDE            º Data ³  07/06/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Proc1()


Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| Proc2(@_lFim) }
Private _cTitulo01 := 'Processando'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Close(_oGeraTxt)

Return


Static Function Proc2(_lFim)

////////////////////////////////////
/////// PA0046 /////////////////////
//// MV_PAR01  : Cliente De    /////
//// MV_PAR02  : Cliente Ate   /////
//// MV_PAR03  : Quais Lojas   /////
//// MV_PAR04  : Produto De    /////
//// MV_PAR05  : Produto Ate   /////
//// MV_PAR06  : Tipo    De    /////
//// MV_PAR07  : Tipo    Ate   /////
//// MV_PAR08  : Grupo   De    /////
//// MV_PAR09  : Grupo   Ate   /////
////                           /////
////////////////////////////////////

aStru := {}
AADD(aStru,{"PRODPASY", "C" ,15, 0 })
AADD(aStru,{"PRODCLI" , "C" ,15, 0 })
AADD(aStru,{"DESCPRO" , "C" ,30, 0 })
AADD(aStru,{"CODCLI"  , "C" ,06, 0 })
AADD(aStru,{"LOJA"    , "C" ,02, 0 })
AADD(aStru,{"NOMCLI"  , "C" ,30, 0 })
AADD(aStru,{"COMPOSTO", "C" ,15, 0 })
AADD(aStru,{"INSERTO" , "C" ,15, 6 })
AADD(aStru,{"NOMEMP"  , "C" ,30, 6 })

cArqTRB := CriaTrab(aStru,.T.)
cIndTRB := "PRODPASY+PRODCLI+CODCLI+LOJA+INSERTO"
dbUseArea(.T.,,cArqTRB,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",cArqTRB,cIndTRB,,,"Criando Trabalho...")

dbSelectArea("SZ2")
dbSetOrder(1)
dbSeek(xFilial("SZ2")+MV_PAR01,.T.)

ProcRegua(LastRec())

While !Eof() .And. SZ2->Z2_CLIENTE <=MV_PAR02
	
	IncProc()
	
	If Alltrim(MV_PAR03) != "*"
		If !SZ2->Z2_LOJA  $ Alltrim(MV_PAR03)
			dbSelectArea("SZ2")
			dbSkip()
			Loop
		Endif
	Endif
	
	If SZ2->Z2_PRODUTO < MV_PAR04 .Or. SZ2->Z2_PRODUTO > MV_PAR05
		dbSelectArea("SZ2")
		dbSkip()
		Loop
	Endif
	                       
	If SZ2->Z2_ATIVO == "2"
		dbSelectArea("SZ2")
		dbSkip()
		Loop
	Endif

	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+SZ2->Z2_CLIENTE+SZ2->Z2_LOJA)
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SZ2->Z2_PRODUTO)
	_cDescPa := SB1->B1_DESC
	
	If SB1->B1_TIPO   < MV_PAR06 .Or. SB1->B1_TIPO  > MV_PAR07 .Or.;
		SB1->B1_GRUPO < MV_PAR08 .Or. SB1->B1_GRUPO > MV_PAR09
		dbSelectArea("SZ2")
		dbSkip()
		Loop
	Endif
	
	_aAliSB12 := GetArea()
	dbSelectArea("SG1")
	dbSetOrder(1)
	If dbSeek(xFilial("SG1")+SZ2->Z2_PRODUTO)
		
		_cProd   := SG1->G1_COD
		nNivel   := 2
		
		VERESTR(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
	Endif
	
	RestArea(_aAliSB12)
	
	dbSelectArea("SZ2")
	dbSkip()
EndDo

_cArqNovo := "\RELATO\TIPOSMP.DBF"

dbSelectArea("TRB")
Copy all to &_cArqNovo

dbCloseArea()

FErase(cArqTrb+".DBF")

Return


Static Function VERESTR(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev)

Local _nReg

dbSelectArea("SG1")
dbSetOrder(1)
While !Eof() .And. SG1->G1_FILIAL + SG1->G1_COD == xFilial("SG1") + _cProd
	
	_nReg := Recno()
	
	nQuantItem := ExplEstr(_nQtPai,,_cOpc,_cRev)
	dbSelectArea("SG1")
	dbSetOrder(1)
	
	If nQuantItem > 0
		dbSelectArea("SB1")
		_aAliSB1 := GetArea()
		dbSeek(xFilial("SB1")+SG1->G1_COMP)
		_cDesProdMP := SB1->B1_DESC
		_lAchou     := .F.
		
		If SB1->B1_TIPO == "PI"
			_cCod := SUBSTR(SB1->B1_COD,1,1)
			If _cCod == "D"
				_cDesMp := "SBR"
				_lAchou := .t.
			ElseIf _cCod == "C"
				_cDesMp := "NEOPLANE"
				_lAchou := .t.
			ElseIf _cCod == "N"
				_cDesMp := "NITRILICA"
				_lAchou := .t.
			ElseIf _cCod == "S"
				_cDesMp := "SILICONE"
				_lAchou := .t.
			ElseIf _cCod == "E"
				_cDesMp := "EPDM"
				_lAchou := .t.
			ElseIf _cCod == "V"
				_cDesMp := "VITON"
				_lAchou := .t.
			ElseIf _cCod == "R"
				_cDesMp := "BORRACHA NATURAL"
				_lAchou := .t.
			Endif
			
			If _lAchou
				_cComposto := SB1->B1_COD
				dbSelectArea("TRB")
				If dbSeek(SZ2->Z2_PRODUTO + SZ2->Z2_CODCLI + SZ2->Z2_CLIENTE+ SZ2->Z2_LOJA)
					RecLock("TRB",.f.)
				Else
					RecLock("TRB",.t.)
				Endif
				TRB->PRODPASY := SZ2->Z2_PRODUTO
				TRB->PRODCLI  := SZ2->Z2_CODCLI
				TRB->DESCPRO  := _cDescPa
				TRB->CODCLI   := SZ2->Z2_CLIENTE
				TRB->LOJA     := SZ2->Z2_LOJA
				TRB->NOMCLI   := SA1->A1_NOME
				TRB->COMPOSTO := _cComposto
				TRB->NOMEMP   := _cDesMP
				MsUnLock()
			Endif
		ElseIf SB1->B1_TIPO == "MP" .And. SUBSTR(SB1->B1_COD,1,2) == "CP"
			dbSelectArea("TRB")
			If dbSeek(SZ2->Z2_PRODUTO + SZ2->Z2_CODCLI + SZ2->Z2_CLIENTE+ SZ2->Z2_LOJA)
				If Empty(TRB->INSERTO)
					RecLock("TRB",.F.)
					TRB->INSERTO   := SB1->B1_COD
					MsUnLock()
				Else
					dbSelectArea("TRB")
					RecLock("TRB",.t.)
					TRB->PRODPASY := SZ2->Z2_PRODUTO
					TRB->PRODCLI  := SZ2->Z2_CODCLI
					TRB->DESCPRO  := _cDescPa
					TRB->CODCLI   := SZ2->Z2_CLIENTE
					TRB->LOJA     := SZ2->Z2_LOJA
					TRB->NOMCLI   := SA1->A1_NOME
					TRB->COMPOSTO := _cComposto
					TRB->NOMEMP   := _cDesMP
					TRB->INSERTO  := SB1->B1_COD					
					MsUnLock()
				Endif
			Endif
		Endif
		
		RestArea(_aAliSB1)
		
		dbSelectArea("SG1")
		dbSetOrder(1)
		dbSeek(xFilial("SG1")+SG1->G1_COMP)
		IF Found()
			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+SG1->G1_COD)
			VERESTR(SG1->G1_COD,nQuantItem,nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
		EndIf
		
		dbSelectArea("SG1")
		dbGoto(_nReg)
	Endif
	dbSkip()
EndDo

Return
