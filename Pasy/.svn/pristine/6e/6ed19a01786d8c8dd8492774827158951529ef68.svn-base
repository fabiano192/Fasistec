#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Pa0081    º Autor ³ Alexandro da Silva º Data ³  01/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍaÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Geração do arquivo do Produto Acabado com o Ult.Preço de   º±±
±±º          ³ Venda com o Ultimo preço de compra das M.Primas            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0081()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private _cPerg    := "PA0081"
Private _oGeraTxt,_cProdPri,cArqTRB,cIndTemp1,cIndTemp2

Private _cString  := "Sb1"


Pergunte(_cPerg,.F.)

dbSelectArea("Sb1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 150,1 TO 380,450 DIALOG _oGeraTxt TITLE OemToAnsi("Geracao de Arquivo de Composto")
@ 02,10 TO 080,220
@ 10,018 Say " Este programa ira gerar um arquivo no diretorio               " SIZE 160,7
@ 18,018 Say " F:\AP7\AP_DATA\RELATO\PA0081.DBF, valorizado pelo saldo em     " SIZE 160,7
@ 26,018 Say " estoque mais os dias que o produto fica                        " SIZE 160,7
@ 34,018 Say " em estoque.PA0081.PRW                                          " SIZE 160,7
@ 85,128 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)
@ 85,158 BMPBUTTON TYPE 01 ACTION Proc1()
@ 85,188 BMPBUTTON TYPE 02 ACTION Close(_oGeraTxt)

Activate Dialog _oGeraTxt Centered

Return


Static Function Proc1()

Close(_oGeraTxt)

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| Proc2(@_lFim) }
Private _cTitulo01 := 'Processando Estrutura'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Private _bAcao01   := {|_lFim| Proc3(@_lFim) }
Private _cTitulo01 := 'Processando Compras'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cArqNovo := "\RELATO\PA0081.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo

dbSelectArea("TRB")
dbCloseArea()

FErase(cArqTrb+".DBF")
Ferase(cIndTemp1+OrdBagExt())
Ferase(cIndTemp2+OrdBagExt())

Return


Static Function Proc2(_lFim)

/////////////////////////////////////
/////// PA0081 //////////////////////
//// MV_PAR01  : Data    De     /////
//// MV_PAR02  : Data    Ate    /////
//// MV_PAR03  : Tipo De        /////
//// MV_PAR04  : Tipo Ate       /////
//// MV_PAR05  : Produto Pai de /////
//// MV_PAR06  : Produto Pai Ate/////
//// MV_PAR07  : Composto De    /////
//// MV_PAR08  : Composto Ate   /////
//// MV_PAR09  : Fornecedor de  /////
//// MV_PAR10  : Fornecedor Ate /////
//// MV_PAR11  : Grupo De       /////
//// MV_PAR12  : Grupo Ate      /////

////                            /////
/////////////////////////////////////

aStru := {}
AADD(aStru,{"DTCOMPRA", "D" ,08, 0 })
AADD(aStru,{"PRODUTO" , "C" ,15, 0 })
AADD(aStru,{"COMP"    , "C" ,15, 0 })
AADD(aStru,{"LOCCOMP" , "C" ,02, 0 })
AADD(aStru,{"FORNECE" , "C" ,06, 0 })
AADD(aStru,{"LOJA"    , "C" ,02, 0 })
AADD(aStru,{"NOMFOR"  , "C" ,30, 0 })
AADD(aStru,{"PRCCOMP" , "N" ,14, 2 })
AADD(aStru,{"QTDENT"  , "N" ,14, 2 })
AADD(aStru,{"NUMCOMP" , "N" ,14, 2 })
AADD(aStru,{"DIASENT" , "N" ,14, 2 })
AADD(aStru,{"OBS"     , "C" ,50, 0 })
AADD(aStru,{"VLPAGO"  , "N" ,14, 2 })

cArqTRB := CriaTrab(aStru)

//cArqTemp:=CriaTrab(aArqTemp)
cIndTemp1:=Substr(CriaTrab(NIL,.F.),1,7)+"1"
cIndTemp2:=Substr(CriaTrab(NIL,.F.),1,7)+"2"

dbUseArea(.T.,,cArqTrb,"TRB",.T.,.F.)

cIndTRB1 := "COMP+PRODUTO"
cIndTRB2 := "COMP+FORNECE"
IndRegua("TRB",cIndTemp1,cIndTRb1,,,"Indice Temporario...")
IndRegua("TRB",cIndTemp2,cIndTrb2,,,"Indice Temporario...")

Set Cursor Off
DbClearIndex()
DbSetIndex(cIndTemp1+OrdBagExt())
DbSetIndex(cIndTemp2+OrdBagExt())

/*
cIndTRB := "COMP+PRODUTO"
dbUseArea(.T.,,cArqTRB,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",cArqTRB,cIndTRB,,,"Criando Trabalho...")
*/

dbSelectArea("SB1")
dbSetOrder(2)
dbSeek(xFilial("SB1")+"PA"+MV_PAR05,.T.)

ProcRegua(LastRec())

While !Eof() .And. SB1->B1_TIPO == "PA" .And. SB1->B1_COD <=MV_PAR06
	
	IncProc()
	
	_cProdPri := SB1->B1_COD
	_aAliSB12 := GetArea()
	dbSelectArea("SG1")
	dbSetOrder(1)
	If dbSeek(xFilial("SG1")+SB1->B1_COD)
		
		_cProd   := SG1->G1_COD
		nNivel   := 2
		
		VERESTR(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
	Endif
	
	RestArea(_aAliSB12)
	
	dbSelectArea("SB1")
	dbSkip()
EndDo


Return



Static Function VERESTR(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev)

Local _nReg,nQuantItem := 0
Local _nRegTrb := 0
dbSelectArea("SG1")
dbSetOrder(1)
While !Eof() .And. SG1->G1_FILIAL + SG1->G1_COD == xFilial("SG1") + _cProd
	
	_nReg := Recno()
	
	nQuantItem := ExplEstr(_nQtPai,,_cOpc,_cRev)
	dbSelectArea("SG1")
	dbSetOrder(1)
	
	dbSelectArea("SB1")
	_aAliSB1 := GetArea()
	dbSeek(xFilial("SB1")+SG1->G1_COMP)
	
	//	If SB1->B1_GRUPO == "MPIM"
	If (SG1->G1_COMP  >= MV_PAR07 .And. SG1->G1_COMP  <= MV_PAR08) .And.;
		SB1->B1_TIPO  >= MV_PAR03 .And. SB1->B1_TIPO  <= MV_PAR04  .And.;
		SB1->B1_GRUPO >= MV_PAR11 .And. SB1->B1_GRUPO <= MV_PAR12
		dbSelectArea("TRB")
		If !dbSeek(SG1->G1_COMP + _cProdPri)
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->COMP    := SG1->G1_COMP
			TRB->LOCCOMP := SB1->B1_LOCPAD
			TRB->PRODUTO := _cProdPri
			MsUnlock()
		Endif
	Endif
	//	Endif
	
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
	
	dbSkip()
EndDo

Return


Static Function Proc3(_lFim)

dbSelectArea("TRB")
dbSetOrder(2)
dbGotop()

ProcRegua(LastRec())

While !Eof() .And. !_lFim
	
	_cComp := TRB->COMP
	
	While !Eof() .And. !_lFim .And. _cComp == TRB->COMP
		
		IncProc()
		
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	_cComp2 := TRB->COMP
	dbSelectArea("TRB")
	dbSkip(-1)
	
	dbSelectArea("SD1")
	dbSetOrder(7)
	dbSeek(xFilial("SD1")+TRB->COMP + TRB->LOCCOMP + DTOS(MV_PAR01),.T.)
	
	_cChavSD1 := TRB->COMP
	
	While !Eof() .And. !_lFim .And.	_cChavSD1 == SD1->D1_COD .And. SD1->D1_DTDIGIT >= MV_PAR01.And. SD1->D1_DTDIGIT <= MV_PAR02
		
		If SD1->D1_TIPO != "N"
			dbSelectArea("SD1")
			dbSkip()
			Loop
		Endif
		
		If SD1->D1_FORNECE < MV_PAR09 .Or. SD1->D1_FORNECE > MV_PAR10
			dbSelectArea("SD1")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea("SF4")
		dbSetOrder(1)
		If dbSeek(xFilial("SF4")+SD1->D1_TES)
			If SF4->F4_DUPLIC != "S"
				dbSelectArea("SD1")
				dbSkip()
				Loop
			Endif
		Endif
		
		_nEnt := 0
		dbSelectArea("SC7")
		dbSetOrder(1)
		If dbSeek(xFilial("SC7")+SD1->D1_PEDIDO + SD1->D1_ITEMPC)
			_nEnt := SD1->D1_DTDIGIT - SC7->C7_DATPRF
		Endif
		
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2")+SD1->D1_FORNECE + SD1->D1_LOJA)
		
		dbSelectArea("TRB")
		If !dbSeek(SD1->D1_COD + SD1->D1_FORNECE)
			If dbSeek(SD1->D1_COD+Space(6))
				dbSelectArea("TRB")
				RecLock("TRB",.F.)
				TRB->FORNECE := SD1->D1_FORNECE
				TRB->LOJA    := SD1->D1_LOJA
				TRB->NOMFOR  := SA2->A2_NOME
				MsUnlock()
			Else
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PRODUTO := "999999"
				TRB->COMP    := SD1->D1_COD
				TRB->LOCCOMP := SD1->D1_LOCAL
				TRB->FORNECE := SD1->D1_FORNECE
				TRB->LOJA    := SD1->D1_LOJA
				TRB->NOMFOR  := SA2->A2_NOME
				MsUnlock()
			Endif
		Endif
		
		dbSelectArea("TRB")
		RecLock("TRB",.F.)
		TRB->QTDENT  += SD1->D1_QUANT
		_nValor   	 := (SD1->D1_TOTAL - SD1->D1_VALICM)// + SD1->D1_VALIPI)
		TRB->VLPAGO  += _nValor
		TRB->PRCCOMP := TRB->VLPAGO / TRB->QTDENT
		TRB->NUMCOMP += 1
		TRB->DIASENT += _nEnt
		MsUnlock()
		
		dbSelectArea("SD1")
		dbSkip()
	EndDo
	
	dbSelectArea("TRB")
	dbSeek(_cComp2)
EndDo

Return
