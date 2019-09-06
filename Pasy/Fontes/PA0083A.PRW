#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Pa0083A    º Autor ³ Alexandro da Silva º Data ³  09/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍaÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Geração do arquivo do Produto Acabado com o Ult.Preço de   º±±
±±º          ³ Venda com o Ultimo preço de compra das M.Primas            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaFat                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Pa0083A()

Private _dDtFim
Private _nQtEst0 := _nQtEst1 := _nQtEst2 := 0
Private _dDtRef0 := _dDtRef1 := _dDtRef2 := Ctod("")
Private _lSdo    := _lEnt    := .T.

Private _cPerg    := "PA0083"
Private _oGeraTxt,_cProdPri,cArqTRB,cIndTemp1,cIndTemp2,_lGravou,_cCav
Private _cString  := "Sb1"

Pergunte(_cPerg,.F.)

dbSelectArea("Sb1")
dbSetOrder(1)

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Geracao de Arquivo P/ 6_Sigma")
@ 02,10 TO 080,220
@ 10,018 Say " Este programa ira gerar um arquivo no diretorio                " SIZE 160,7
@ 18,018 Say " F:\AP7\AP_DATA\RELATO\PA0083.DBF, valorizado pelo saldo em     " SIZE 160,7
@ 26,018 Say " estoque mais os dias que o produto fica                        " SIZE 160,7
@ 34,018 Say " em estoque.PA0083A.PRW                                         " SIZE 160,7
//@ 85,128 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)
//@ 85,158 BMPBUTTON TYPE 01 ACTION Proc1()
//@ 85,188 BMPBUTTON TYPE 02 ACTION Close(_oGeraTxt)

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte(_cPerg,.T.)
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered
                             
If _nOpc == 1
	Proc1()
Endif

Return


Static Function Proc1()

_dDtIni  := MV_PAR01-1
_dDtFim  := MV_PAR02

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| Proc2(@_lFim) }
Private _cTitulo01 := 'Processando Estrutura'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

Private _bAcao01   := {|_lFim| Proc3(@_lFim) }
Private _cTitulo01 := 'Processando Notas Fiscais de Compra'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cArqNovo := "\RELATO\PA0083.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo

dbSelectArea("TRB")
dbCloseArea()

FErase(cArqTrb+".DBF")
Ferase(cIndTemp1+OrdBagExt())
Ferase(cIndTemp2+OrdBagExt())


If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "F:\AP7\AP_DATA\RELATO\PA0083.DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)



Return


Static Function Proc2(_lFim)

/////////////////////////////////////
/////// PA0083 //////////////////////
//// MV_PAR01  : Data    De     /////
//// MV_PAR02  : Data    Ate    /////
//// MV_PAR03  : Tipo De        /////
//// MV_PAR04  : Tipo Ate       /////
//// MV_PAR05  : Composto De    /////
//// MV_PAR06  : Composto Ate   /////
//// MV_PAR07  : Grupo De       /////
//// MV_PAR08  : Grupo Ate      /////
//// MV_PAR09  : Fornecedor de  /////
//// MV_PAR10  : Fornecedor Ate /////
////                            /////
/////////////////////////////////////

aStru := {}
AADD(aStru,{"ORDEM"    , "C" ,01, 0 })
AADD(aStru,{"DTREF"    , "D" ,08, 0 })
AADD(aStru,{"COMP"     , "C" ,15, 0 })
AADD(aStru,{"LOCCOMP"  , "C" ,02, 0 })
AADD(aStru,{"QTDEST"   , "N" ,14, 0 })
AADD(aStru,{"VLEST"    , "N" ,14, 2 })
AADD(aStru,{"QTDENT"   , "N" ,14, 0 })
AADD(aStru,{"VLENT"    , "N" ,14, 2 })
AADD(aStru,{"QTDSAI"   , "N" ,14, 0 })
AADD(aStru,{"VLSAI"    , "N" ,14, 2 })
AADD(aStru,{"QTDSDOEST", "N" ,14, 0 })
AADD(aStru,{"VLSDOEST" , "N" ,14, 2 })
AADD(aStru,{"QTDIATR"  , "N" ,14, 0 })
AADD(aStru,{"VLDIATR"  , "N" ,14, 2 })

cArqTRB   := CriaTrab(aStru)
cIndTemp1 := Substr(CriaTrab(NIL,.F.),1,7)+"1"
cIndTemp2 := Substr(CriaTrab(NIL,.F.),1,7)+"2"

dbUseArea(.T.,,cArqTrb,"TRB",.T.,.F.)

cIndTRB1  := "COMP+ORDEM+DTOS(DTREF)"
cIndTRB2  := "ORDEM+COMP+DTOS(DTREF)"
IndRegua("TRB",cIndTemp1,cIndTRb1,,,"Indice Temporario...")
IndRegua("TRB",cIndTemp2,cIndTrb2,,,"Indice Temporario...")

Set Cursor Off
dbClearIndex()
dbSetIndex(cIndTemp1+OrdBagExt())
dbSetIndex(cIndTemp2+OrdBagExt())

dbSelectArea("SB1")
dbSetOrder(4)
dbSeek(xFilial("SB1")+MV_PAR07+MV_PAR05,.T.)

ProcRegua(LastRec())

While !Eof() .And. SB1->B1_GRUPO <= MV_PAR08 .And. SB1->B1_COD <=MV_PAR06
	
	IncProc()

	If SB1->B1_SUBGR  < MV_PAR11 .Or. SB1->B1_SUBGR > MV_PAR12
		dbSelectArea("SB1")
		dbSkip()
		Loop
	Endif
	
	If SB1->B1_TIPO < MV_PAR03 .Or. SB1->B1_TIPO > MV_PAR04
		dbSelectArea("SB1")
		dbSkip()
		Loop
	Endif
	
	_aSaldo   := CalcEst(SB1->B1_COD,SB1->B1_LOCPAD,MV_PAR01)
	
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->ORDEM     := "0"
	TRB->DTREF     := MV_PAR01-1
	TRB->QTDEST    := _aSaldo[1] // Quantidade
	TRB->VLEST     := _aSaldo[2] // Valor
	TRB->QTDSDOEST := _aSaldo[1] // Quantidade
	TRB->VLSDOEST  := _aSaldo[2] // Valor
	TRB->COMP      := SB1->B1_COD
	TRB->LOCCOMP   := SB1->B1_LOCPAD
	TRB->QTDIATR   := IIf (_aSaldo[2] > 0,_dDtFim  -  _dDtIni,0)
	TRB->VLDIATR   := _aSaldo[2] // Valor
	
	MsUnlock()
	
	dbSelectArea("SB1")
	dbSkip()
EndDo


Return

Static Function Proc3(_lFim)

dbSelectArea("TRB")
dbSetOrder(1)
dbGotop()

ProcRegua(LastRec())

While !Eof() .And. !_lFim
	
	_cComp  := TRB->COMP
	_cLocal := TRB->LOCCOMP
	
	IncProc()
	
	dbSelectArea("TRB")
	dbSkip()
	
	_cComp2 := TRB->COMP
	dbSelectArea("TRB")
	dbSkip(-1)
	
	dbSelectArea("SD1")
	dbSetOrder(7)
	dbSeek(xFilial("SD1")+_cComp + _cLocal + DTOS(MV_PAR01),.T.)
	
	_cChavSD1 := _cComp + _cLocal
	_nPrc     := 0
	
	While !Eof() .And. !_lFim .And.	_cChavSD1 == SD1->D1_COD + SD1->D1_LOCAL .And. SD1->D1_DTDIGIT <= MV_PAR02
		
		If SD1->D1_DTDIGIT < MV_PAR01
			dbSelectArea("SD1")
			dbSkip()
			Loop
		Endif
		
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
		
		If SD1->D1_LOCAL != "01"
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
		If dbSeek(SD1->D1_COD +"1"+DTOS(SD1->D1_DTDIGIT))
			dbSelectArea("TRB")
			RecLock("TRB",.F.)
			TRB->QTDENT    += SD1->D1_QUANT
			TRB->VLENT     += SD1->D1_TOTAL - SD1->D1_VALICM
			TRB->QTDSDOEST += SD1->D1_QUANT
			TRB->VLSDOEST  += SD1->D1_TOTAL - SD1->D1_VALICM
			TRB->QTDIATR   := _dDtFim - SD1->D1_DTDIGIT
			TRB->VLDIATR   := SD1->D1_TOTAL - SD1->D1_VALICM
			MsUnlock()
		Else
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->ORDEM     := "1"
			TRB->DTREF     := SD1->D1_DTDIGIT
			TRB->COMP      := SD1->D1_COD
			TRB->LOCCOMP   := SD1->D1_LOCAL
			TRB->QTDENT    := SD1->D1_QUANT
			TRB->VLENT     := SD1->D1_TOTAL - SD1->D1_VALICM
			TRB->QTDSDOEST := SD1->D1_QUANT
			TRB->VLSDOEST  := SD1->D1_TOTAL - SD1->D1_VALICM 
			TRB->QTDIATR   := _dDtFim - SD1->D1_DTDIGIT
			TRB->VLDIATR   := SD1->D1_TOTAL - SD1->D1_VALICM
			MsUnlock()
		Endif
		
		_nPrc := (SD1->D1_TOTAL - SD1->D1_VALICM) / SD1->D1_QUANT
		dbSelectArea("SD1")
		dbSkip()
	EndDo
	
	If _nPrc == 0
		dbSelectArea("SB2")
		dbSetOrder(1)
		dbSeek(xFilial("SB2")+_cComp + _cLocal)
		_nPrc := SB2->B2_CM1
	Endif
	
	dbSelectArea("SD3")
	dbSetOrder(7)
	dbSeek(xFilial("SD3")+_cComp + _cLocal + DTOS(MV_PAR01),.T.)
	
	_cChavSD3 := _cComp + _cLocal
	
	While !Eof() .And. !_lFim .And.	_cChavSD3 == SD3->D3_COD+SD3->D3_LOCAL .And. SD3->D3_EMISSAO <= MV_PAR02
		
		If SD3->D3_EMISSAO < MV_PAR01
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		If !Substr(SD3->D3_CF,1,2) $ "RE"
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif
		
		If SD3->D3_ESTORNO == "S"
			dbSelectArea("SD3")
			dbSkip()
			Loop
		Endif

		If SD1->D1_LOCAL != "01"
			dbSelectArea("SD1")
			dbSkip()
			Loop
		Endif

		dbSelectArea("TRB")
		If dbSeek(SD3->D3_COD + "2"+DTOS(SD3->D3_EMISSAO))
			dbSelectArea("TRB")
			RecLock("TRB",.F.)
			TRB->QTDSAI    += SD3->D3_QUANT
			TRB->QTDSDOEST += SD3->D3_QUANT
			TRB->VLSDOEST  := TRB->QTDSDOEST * _nPrc
			MsUnlock()
		Else
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->ORDEM     := "2"
			TRB->DTREF     := SD3->D3_EMISSAO
			TRB->COMP      := SD3->D3_COD
			TRB->LOCCOMP   := SD3->D3_LOCAL
			TRB->QTDSAI    := SD3->D3_QUANT
			TRB->QTDSDOEST := SD3->D3_QUANT
			TRB->VLSDOEST  := TRB->QTDSDOEST * _nPrc
			MsUnlock()
		Endif
		
		dbSelectArea("SD3")
		dbSkip()
	EndDo
	
	dbSelectArea("TRB")
	dbSeek(_cComp2)
EndDo

dbSelectArea("TRB")
dbSetOrder(2)
dbSeek("0")

ProcRegua(LastRec())

While !Eof() .And. !_lFim .And. TRB->ORDEM == "0"
	
	IncProc()
	
	_dDtRef0  := TRB->DTREF
	_nQtEst0  := TRB->QTDEST
	_cProd0   := TRB->COMP
	_nPrc0    := TRB->VLSDOEST / TRB->QTDSDOEST
	_lSair    := .F.
	_lSdo     := .T.
	_lEnt     := .T.
	
	dbSelectArea("TRB")
	If dbSeek("2"+_cProd0)
		
		_cChav2 := TRB->ORDEM + TRB->COMP
		
		While !Eof()  .And. !_lFim .And. (_cChav2 == TRB->ORDEM + TRB->COMP) .And. !_lSair
			
			_nQtEst2 := TRB->QTDSDOEST
			_dDtRef2 := TRB->DTREF
			_nQtEst0 := _nQtEst0 - TRB->QTDSDOEST
			
			If _nQtEst0 >= 0				
				If _lSdo    
					dbSelectArea("TRB")
					RecLock("TRB",.F.)
					TRB->QTDSDOEST := 0
					TRB->VLSDOEST  := 0
					TRB->QTDIATR   := IIF(_nQtEst2 > 0,_dDtRef2     -  _dDtRef0,0)
					TRB->VLDIATR   := _nQtEst2     *  _nPrc0
					MsUnlock()

					dbSelectArea("TRB")
					If dbSeek("0"+_cProd0)
						dbSelectArea("TRB")
						RecLock("TRB",.F.)
						TRB->QTDSDOEST := _nQtEst0
						TRB->VLSDOEST  := _nQtEst0 *  _nPrc0
						TRB->QTDIATR   := IIF(_nQtEst2 > 0,_dDtFim     -  _dDtRef0,0)						
						TRB->VLDIATR   := _nQtEst0 *  _nPrc0
						MsUnlock()
					Endif				
				Else
					VerEnt()
				Endif
			Else
				If _lSdo
					dbSelectArea("TRB")
					If dbSeek("0"+_cProd0)
						dbSelectArea("TRB")
						RecLock("TRB",.F.)
						TRB->QTDSDOEST := 0
						TRB->VLSDOEST  := 0
						TRB->QTDIATR   := 0
						TRB->VLDIATR   := 0
						MsUnlock()
					Endif
				Endif    
				
				VerEnt()     				
				_nQtEst0 := 0				
			Endif
			
			dbSelectArea("TRB")
			dbSeek("2" + _cProd0 + Dtos(_dDtRef2))
			        			
			dbSelectArea("TRB")
			dbSkip()
		EndDo
	Endif
	
	dbSelectArea("TRB")
	dbSeek("0"+_cProd0)
	dbSkip()
Enddo

Return

Static Function VerEnt()
                               
_lSair2 := .F.
dbSelectArea("TRB")
If dbSeek("1"+_cProd0)
	
	_cChav1 := TRB->ORDEM + TRB->COMP
	
	While !Eof()  .And. !_lFim .And. (_cChav1 == TRB->ORDEM + TRB->COMP) .And. !_lSair2
		
		_lSdo := .F.
		If TRB->QTDSDOEST == 0
			dbSelectArea("TRB")
			dbSkip()
			Loop
		Endif
		
		_nPrc1   := TRB->VLSDOEST / TRB->QTDSDOEST
		_nQtEst1 := TRB->QTDSDOEST
		_dDtRef1 := TRB->DTREF
		_nQtSdo0 := _nQtEst0
		_nQtEst0 := _nQtEst0 + TRB->QTDSDOEST
		
		If _nQtEst0 <= 0
			If _nQtEst0 == 0
				_lSair2 := .T.
			Endif
			dbSelectArea("TRB")    // Entrada
			RecLock("TRB",.F.)
			TRB->QTDSDOEST := 0
			TRB->VLSDOEST  := 0
			TRB->QTDIATR   := 0
			TRB->VLDIATR   := 0
			MsUnlock()			
			
			dbSelectArea("TRB")   // Saida
			If dbSeek("2" + _cProd0 + Dtos(_dDtRef2))
				dbSelectArea("TRB")	
				RecLock("TRB",.F.)
				TRB->QTDSDOEST := (_nQtEst0 * -1)
				TRB->VLSDOEST  := (_nQtEst0 * -1)  *  _nPrc1
				TRB->QTDIATR   := _dDtRef2  -  _dDtRef1
				If _nQtEst0 == 0
					TRB->VLDIATR   := (_nQtSdo0 * -1)  *  _nPrc1
				Else                                     
					TRB->VLDIATR   := (_nQtEst0 * -1)  *  _nPrc1
				Endif
				MsUnlock()
			Endif
		ElseIf	_nQtEst0 > 0
			_lSair2 := .T.
			dbSelectArea("TRB")    // Entrada
			RecLock("TRB",.F.)        			
			TRB->QTDSDOEST := _nQtEst0
			TRB->VLSDOEST  := _nQtEst0  *  _nPrc1
			TRB->QTDIATR   := IIF(_nQtEst2 > 0,dDatabase - _dDtRef1,_dDtFim   -  _dDtRef1)
			TRB->VLDIATR   := _nQtEst0  *  _nPrc1
			MsUnlock()			
	
			dbSelectArea("TRB")   // Saida
			If dbSeek("2" + _cProd0 + Dtos(_dDtRef2))
				dbSelectArea("TRB")	
				RecLock("TRB",.F.)
				TRB->QTDSDOEST := 0
				TRB->VLSDOEST  := 0
				TRB->QTDIATR   := _dDtRef2  -  _dDtRef1
				TRB->VLDIATR   := _nQtEst2  *  _nPrc1
				MsUnlock()
			Endif
		Endif
		   
		dbSelectArea("TRB")
	    dbSeek("1"+_cProd0 + Dtos(_dDtRef1))
			
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	_lEnt := .T.
Endif

Return