#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Pa0082    º Autor ³ Alexandro da Silva º Data ³  03/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍaÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Geração do arquivo do Produto Acabado com o Ult.Preço de   º±±
±±º          ³ Venda com o Ultimo preço de compra das M.Primas            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0082()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private _cPerg    := "PA0081"
Private _oGeraTxt,_cProdPri,cArqTRB,cIndTemp1,cIndTemp2,_lGravou,_cCav

Private _cString  := "Sb1"


Pergunte(_cPerg,.F.)

dbSelectArea("Sb1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 150,1 TO 380,450 DIALOG _oGeraTxt TITLE OemToAnsi("Geracao de Arquivo P/ 6_Sigma")
@ 02,10 TO 080,220
@ 10,018 Say " Este programa ira gerar um arquivo compras2.dbf no diretorio   " SIZE 160,7
@ 18,018 Say " F:\AP7\AP_DATA\RELATO\PA0082.DBF, conforme os parametros defi- " SIZE 160,7
@ 26,018 Say " nidos pelo usuario. PROGRAMA PA0082.PRW.                       " SIZE 160,7
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
Private _cTitulo01 := 'Processando Solicitacao de Compras'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cArqNovo := "\RELATO\PA0082.DBF"
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
AADD(aStru,{"DTCOMPRA" , "D" ,08, 0 })
AADD(aStru,{"PRODUTO"  , "C" ,15, 0 })
AADD(aStru,{"COMP"     , "C" ,15, 0 })
AADD(aStru,{"LOCCOMP"  , "C" ,02, 0 })
AADD(aStru,{"CAV"      , "C" ,03, 0 })
AADD(aStru,{"FORNECE"  , "C" ,06, 0 })
AADD(aStru,{"LOJA"     , "C" ,02, 0 })
AADD(aStru,{"NOMFOR"   , "C" ,30, 0 })
AADD(aStru,{"SDOEST"   , "N" ,14, 2 })
AADD(aStru,{"NUMSOL"   , "C" ,06, 0 })
AADD(aStru,{"ITEMSOL"  , "C" ,06, 0 })
AADD(aStru,{"DTSOL"    , "D" ,08, 0 })
AADD(aStru,{"QTDSOL"   , "N" ,14, 2 })
AADD(aStru,{"QTDLM"    , "N" ,14, 2 })
AADD(aStru,{"QTDENT"   , "N" ,14, 2 })
AADD(aStru,{"QTDPED"   , "N" ,14, 2 })
AADD(aStru,{"VALENT"   , "N" ,14, 2 })
cArqTRB := CriaTrab(aStru)

//cArqTemp:=CriaTrab(aArqTemp)
cIndTemp1:=Substr(CriaTrab(NIL,.F.),1,7)+"1"
cIndTemp2:=Substr(CriaTrab(NIL,.F.),1,7)+"2"

dbUseArea(.T.,,cArqTrb,"TRB",.T.,.F.)

cIndTRB1 := "PRODUTO+COMP"
//cIndTRB2 := "COMP+DTOS(DTSOL)+NUMSOL+ITEMSOL+FORNECE+DTOS(DTCOMPRA)"
cIndTRB2 := "COMP+NUMSOL+ITEMSOL+FORNECE+DTOS(DTCOMPRA)"
IndRegua("TRB",cIndTemp1,cIndTRb1,,,"Indice Temporario...")
IndRegua("TRB",cIndTemp2,cIndTrb2,,,"Indice Temporario...")

Set Cursor Off
DbClearIndex()
DbSetIndex(cIndTemp1+OrdBagExt())
DbSetIndex(cIndTemp2+OrdBagExt())

dbSelectArea("SB1")
dbSetOrder(2)
dbSeek(xFilial("SB1")+"PA"+MV_PAR05,.T.)

ProcRegua(LastRec())

While !Eof() .And. SB1->B1_TIPO == "PA" .And. SB1->B1_COD <=MV_PAR06
	
	IncProc()
	
	_lGravou  := .F.
	_cCav     := ""
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
	
	If _lGravou
		dbSelectArea("TRB")
		If dbSeek(_cProdPri)
			_cChav2 := TRB->PRODUTO
			
			While !Eof() .And. _cChav2 == TRB->PRODUTO
				
				dbSelectArea("TRB")
				RecLock("TRB",.F.)
				TRB->CAV     := _cCav
				MsUnlock()
				dbSelectArea("TRB")
				dbSkip()
			EndDo
		Endif
	Endif
	
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
	
	If SB1->B1_TIPO == "FR"
		_cCav := SB1->B1_CAV
	Endif
	
//	If SB1->B1_GRUPO == "MPIM"
		If (SG1->G1_COMP >= MV_PAR07 .And. SG1->G1_COMP <= MV_PAR08) .And.;
			SB1->B1_TIPO >= MV_PAR03 .And. SB1->B1_TIPO <= MV_PAR04  .And.;
			SB1->B1_GRUPO >= MV_PAR11 .And. SB1->B1_GRUPO <= MV_PAR12
			_lGravou := .T.
			dbSelectArea("TRB")
			If !dbSeek(_cProdPri + SG1->G1_COMP)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->COMP    := SG1->G1_COMP
				TRB->LOCCOMP := SB1->B1_LOCPAD
				TRB->PRODUTO := _cProdPri
				TRB->QTDLM   := SB1->B1_LM
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
	
	dbSelectArea("SC1")
	dbOrderNickName("INDSC11")
	dbSeek(xFilial("SC1")+_cComp + DTOS(MV_PAR01),.T.)
	
	_cChavSC1 := SC1->C1_PRODUTO
	
	While !Eof() .And. !_lFim .And.	_cComp == SC1->C1_PRODUTO .And. SC1->C1_EMISSAO <= MV_PAR02
		
		_aSaldo   := CalcEst(SB1->B1_COD,SB1->B1_LOCPAD,SC1->C1_EMISSAO)
		_nSdoEst  := _aSaldo[1]
		
		dbSelectArea("TRB")
//		If !dbSeek(SC1->C1_PRODUTO + DTOS(SC1->C1_DATPRF)+SC1->C1_NUM+SC1->C1_ITEM)
		If !dbSeek(SC1->C1_PRODUTO + SC1->C1_NUM + SC1->C1_ITEM)
			If dbSeek(SC1->C1_PRODUTO + Space(8)+Space(6))
				dbSelectArea("TRB")
				RecLock("TRB",.F.)
				TRB->NUMSOL   := SC1->C1_NUM
				TRB->ITEMSOL  := SC1->C1_ITEM
				TRB->DTSOL    := SC1->C1_DATPRF
				TRB->QTDSOL   += SC1->C1_QUANT
				TRB->SDOEST   := _nSdoEst
				MsUnlock()
			Else
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PRODUTO := "999999"
				TRB->COMP    := SC1->C1_PRODUTO
				TRB->LOCCOMP := SC1->C1_LOCAL
				TRB->NUMSOL  := SC1->C1_NUM
				TRB->ITEMSOL := SC1->C1_ITEM
				TRB->DTSOL   := SC1->C1_DATPRF
				TRB->QTDSOL  := SC1->C1_QUANT
				TRB->SDOEST  := _nSdoEst
				MsUnlock()
			Endif
		Else
			dbSelectArea("TRB")
			RecLock("TRB",.F.)
			TRB->QTDSOL   += SC1->C1_QUANT
			MsUnlock()
		Endif
		
		dbSelectArea("SC7")
		dbOrderNickName("INDSC72")
		If dbSeek(xFilial("SC7")+SC1->C1_NUM + SC1->C1_ITEM + SC1->C1_PRODUTO)
			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek(xFilial("SA2")+SC7->C7_FORNECE + SC7->C7_LOJA)
			
			dbSelectArea("TRB")
			If dbSeek(SC1->C1_PRODUTO+SC1->C1_NUM+SC1->C1_ITEM)
				dbSelectArea("TRB")
				RecLock("TRB",.F.)
				TRB->QTDPED   := SC7->C7_QUANT
				MsUnlock()
			Endif
			
			dbSelectArea("SD1")
			dbOrderNickname("INDSD12")
			If dbSeek(xFilial("SD1")+SC7->C7_NUM + SC7->C7_ITEM + SC7->C7_PRODUTO)
				_cChavSD1 := SD1->D1_PEDIDO + SD1->D1_ITEMPC + SD1->D1_COD
				
				While !Eof() .And. 	_cChavSD1 == SD1->D1_PEDIDO + SD1->D1_ITEMPC + SD1->D1_COD
					
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
					
					dbSelectArea("TRB")
					If !dbSeek(SC1->C1_PRODUTO+SC1->C1_NUM+SC1->C1_ITEM+SD1->D1_FORNECE)
						If dbSeek(SC1->C1_PRODUTO+SC1->C1_NUM+SC1->C1_ITEM+Space(8))
							dbSelectArea("TRB")
							RecLock("TRB",.F.)
							TRB->FORNECE   := SD1->D1_FORNECE
							TRB->LOJA      := SD1->D1_LOJA
							TRB->NOMFOR    := SA2->A2_NOME
							TRB->QTDENT    := SD1->D1_QUANT                  
							TRB->VALENT    := (SD1->D1_TOTAL - SD1->D1_VALICM)
							TRB->DTCOMPRA  := SD1->D1_DTDIGIT
							MsUnlock()
						Else  
							dbSelectArea("TRB")
							RecLock("TRB",.T.)
							TRB->PRODUTO  := "999999"
							TRB->DTCOMPRA := SD1->D1_DTDIGIT
							TRB->COMP     := SD1->D1_COD
							TRB->LOCCOMP  := SD1->D1_LOCAL
							TRB->NUMSOL   := SC1->C1_NUM
							TRB->ITEMSOL  := SC1->C1_ITEM
							TRB->DTSOL    := SC1->C1_DATPRF
							TRB->FORNECE  := SD1->D1_FORNECE
							TRB->LOJA     := SD1->D1_LOJA
							TRB->NOMFOR   := SA2->A2_NOME
							TRB->QTDENT   += SD1->D1_QUANT
							TRB->VALENT   += (SD1->D1_TOTAL - SD1->D1_VALICM)
							TRB->SDOEST   := _nSdoEst
							MsUnlock()
						Endif
					Else
						dbSelectArea("TRB")
						RecLock("TRB",.F.)
						TRB->QTDENT   += SD1->D1_QUANT                       
						TRB->VALENT   += (SD1->D1_TOTAL - SD1->D1_VALICM)
						TRB->DTCOMPRA := SD1->D1_DTDIGIT
						MsUnlock()
					Endif
					
					dbSelectArea("SD1")
					dbSkip()
				EndDo
			Endif
		Endif
		
		dbSelectArea("SC1")
		dbSkip()
	EndDo
	
	dbSelectArea("TRB")
	dbSeek(_cComp2)
EndDo

Return