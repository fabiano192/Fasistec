#include "rwmake.ch"

User Function AceSD3()

SetPrvt("_cAliOri,_nOrdOri,_nRecOri,_aStrREt,_cArqRet")

_cAliOri := Alias()
_nOrdOri := IndexOrd()
_nRecOri := Recno()
_lBx     := .F.

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| ACEFER(@_lFim) }
Private _cTitulo01 := 'Processando Cadastro de Ferramentas'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

MSGINFO("Alteracao Efetuada com Sucesso !!! ")
Return



Static Function ACEFER(_lFim)

dbSelectArea("SB1")
dbSetOrder(9)
If dbSeek(xFilial("SB1")+"FR")
	
	ProcRegua(LastRec())
	
	While !Eof() .And. SB1->B1_TIPO == "FR"
		
		If _lFim
			Alert("cancelado pelo Operador!!")
			Return
		EndIf
		
		IncProc()
		

		If Empty(SB1->B1_CODOLD)
			dbSelectArea("SB1")
			dbSkip()
			Loop
		Endif
		
		_cFerr := Substr(SB1->B1_COD,1,6)
/*		
		dbSelectArea("SH4")
		dbSetOrder(1)
		If !dbSeek(xFilial("SH4")+_cFerr)
			dbSelectArea("SH4")
			RecLock("SH4",.T.)
			SH4->H4_FILIAL   :=   xFilial("SH4")
			SH4->H4_CODIGO   :=   _cFerr+"A1"
			SH4->H4_DESCRI   :=   SB1->B1_DESC
			SH4->H4_IDENFER  :=   Substr(SB1->B1_COD,1,3)
			SH4->H4_VIDAUTI  :=   1
			SH4->H4_TIPOVID  :=   "A"
			SH4->H4_VIDAACU  :=   3
			SH4->H4_DTAQUIS  :=   dDataBase
			SH4->H4_QUANT    :=   1
			MsUnlock()
		Else
			_cCodFer := SH4->H4_CODIGO
			
			While !Eof() .And. _cCodFer == SH4->H4_CODIGO
				_cProxCod := SH4->H4_CODIGO
				dbSkip()
			EndDo
			
			_cCont := StrZero(Val( Substr(_cProxCod,6,1))+1,1)
			dbSelectArea("SH4")
			RecLock("SH4",.T.)
			SH4->H4_FILIAL   :=   xFilial("SH4")
			SH4->H4_CODIGO   :=   _cFerr+"A"+_cCont
			SH4->H4_IDENFER  :=   Substr(SB1->B1_COD,1,3)
			SH4->H4_DESCRI   :=   SB1->B1_DESC
			SH4->H4_VIDAUTI  :=   1
			SH4->H4_TIPOVID  :=   "A"
			SH4->H4_VIDAACU  :=   3
			SH4->H4_DTAQUIS  :=   dDataBase
			SH4->H4_QUANT    :=   1
			MsUnlock()
		Endif
*/		
		dbSelectArea("SH4")
		dbSetOrder(1)
		If dbSeek(xFilial("SH4")+_cFerr)
//			VerSG1()
//			VerSc2()
 //			VerSd1()
 //			VerSd2()
  //			VerSd3()
   //			VerSd4()
	//		VerSB2()
	  //		VerSB6()
		//	VerSB9()

			VerSC1()
			VerSC6()
			VerSC7()
			VerSC9()			
        Endif
/*        

        dbSelectARea("SB1")
        RecLock("SB1",.F.)
        SB1->B1_CODOLD := SB1->B1_COD
        SB1->B1_COD    := SH4->H4_CODIGO
        MsUnlock()
*/		
		dbSelectArea("SB1")
		dbSkip()
	EndDo
Endif

Return



Static Function VerSG1()

dbSelectArea("SG1")
dbSetOrder(2)
If dbSeek(xFilial("SG1")+SB1->B1_COD)
	
	_cCod := SG1->G1_COMP
	
	While !Eof() .And.  _cCod == SG1->G1_COMP
	
		dbSelectArea("SG1")
		RecLock("SG1",.F.)
		SG1->G1_COMP := SH4->H4_CODIGO
		MsUnlock()
		
		dbSelectArea("SG1")
		dbSetOrder(2)
		dbSeek(xFilial("SG1")+SB1->B1_COD)
		
	EndDo
Endif

Return      



Static Function VerSc2()

dbSelectArea("SC2")
dbSetOrder(2)
If dbSeek(xFilial("SC2")+SB1->B1_COD)
	
	_cCod := SC2->C2_PRODUTO
	
	While !Eof() .And.  _cCod == SC2->C2_PRODUTO
		
		dbSelectArea("SC2")
		RecLock("SC2",.F.)
		SC2->C2_PRODUTO := SH4->H4_CODIGO
		MsUnlock()
		
		dbSelectArea("SC2")
		dbSetOrder(2)
		dbSeek(xFilial("SC2")+SB1->B1_COD)
		
	EndDo
Endif

Return


Static Function VerSD1()

dbSelectArea("SD1")
dbSetOrder(2)
If dbSeek(xFilial("SD1")+SB1->B1_COD)
	
	_cCod := SD1->D1_COD
	
	While !Eof() .And.  _cCod == SD1->D1_COD
		
		dbSelectArea("SD1")
		RecLock("SD1",.F.)
		SD1->D1_COD := SH4->H4_CODIGO
		MsUnlock()
		
		dbSelectArea("SD1")
		dbSetOrder(2)
		dbSeek(xFilial("SD1")+SB1->B1_COD)
		
	EndDo
Endif

Return

Static Function VerSD2()

dbSelectArea("SD2")
dbSetOrder(1)
If dbSeek(xFilial("SD2")+SB1->B1_COD)
	
	_cCod := SD2->D2_COD
	
	While !Eof() .And.  _cCod == SD2->D2_COD
		
		dbSelectArea("SD2")
		RecLock("SD2",.F.)
		SD2->D2_COD := SH4->H4_CODIGO
		MsUnlock()
		
		dbSelectArea("SD2")
		dbSetOrder(1)
		dbSeek(xFilial("SD2")+SB1->B1_COD)
		
	EndDo
Endif

Return

Static Function VerSD3()

dbSelectArea("SD3")
dbSetOrder(3)
If dbSeek(xFilial("SD3")+SB1->B1_COD)
	
	_cCod := SD3->D3_COD
	
	While !Eof() .And.  _cCod == SD3->D3_COD
		
		dbSelectArea("SD3")
		RecLock("SD3",.F.)
		SD3->D3_COD := SH4->H4_CODIGO
		MsUnlock()
		
		dbSelectArea("SD3")
		dbSetOrder(3)
		dbSeek(xFilial("SD3")+SB1->B1_COD)
		
	EndDo
Endif

Return


Static Function VerSD4()

dbSelectArea("SD4")
dbSetOrder(3)
If dbSeek(xFilial("SD4")+SB1->B1_COD)
	
	_cCod := SD4->D4_COD
	
	While !Eof() .And.  _cCod == SD4->D4_COD
		
		dbSelectArea("SD4")
		RecLock("SD4",.F.)
		SD4->D4_COD := SH4->H4_CODIGO
		MsUnlock()
		
		dbSelectArea("SD4")
		dbSetOrder(3)
		dbSeek(xFilial("SD4")+SB1->B1_COD)
		
	EndDo
Endif

Return


Static Function VerSB2()

dbSelectArea("SB2")
dbSetOrder(1)
If dbSeek(xFilial("SB2")+SB1->B1_COD)
	
	_cCod := SB2->B2_COD
	
	While !Eof() .And.  _cCod == SB2->B2_COD
		
		dbSelectArea("SB2")
		RecLock("SB2",.F.)
		SB2->B2_COD := SH4->H4_CODIGO
		MsUnlock()
		
		dbSelectArea("SB2")
		dbSetOrder(1)
		dbSeek(xFilial("SB2")+SB1->B1_COD)
		
	EndDo
Endif

Return



Static Function VerSB6()

dbSelectArea("SB6")
dbSetOrder(1)
If dbSeek(xFilial("SB6")+SB1->B1_COD)
	
	_cCod := SB6->B6_PRODUTO
	
	While !Eof() .And.  _cCod == SB6->B6_PRODUTO
		
		dbSelectArea("SB6")
		RecLock("SB6",.F.)
		SB6->B6_PRODUTO := SH4->H4_CODIGO
		MsUnlock()
		
		dbSelectArea("SB6")
		dbSetOrder(1)
		dbSeek(xFilial("SB6")+SB1->B1_COD)
		
	EndDo
Endif

Return

Static Function VerSB9()

dbSelectArea("SB9")
dbSetOrder(1)
If dbSeek(xFilial("SB9")+SB1->B1_COD)
	
	_cCod := SB9->B9_COD
	
	While !Eof() .And.  _cCod == SB9->B9_COD
		
		dbSelectArea("SB9")
		RecLock("SB9",.F.)
		SB9->B9_COD     := SH4->H4_CODIGO
		MsUnlock()
		
		dbSelectArea("SB9")
		dbSetOrder(1)
		dbSeek(xFilial("SB9")+SB1->B1_COD)
		
	EndDo
Endif

Return


Static Function VerSC1()

dbSelectArea("SC1")
dbSetOrder(2)
If dbSeek(xFilial("SC1")+SB1->B1_CODOLD)
	
	_cCod := SC1->C1_PRODUTO
	
	While !Eof() .And.  _cCod == SC1->C1_PRODUTO
		
		dbSelectArea("SC1")
		RecLock("SC1",.F.)
		SC1->C1_PRODUTO  := SH4->H4_CODIGO
		MsUnlock()
		
		dbSelectArea("SC1")
		dbSetOrder(2)
		dbSeek(xFilial("SC1")+SB1->B1_CODOLD)
		
	EndDo
Endif

Return


Static Function VerSC6()

dbSelectArea("SC6")
dbSetOrder(2)
If dbSeek(xFilial("SC6")+SB1->B1_CODOLD)
	
	_cCod := SC6->C6_PRODUTO
	
	While !Eof() .And.  _cCod == SC6->C6_PRODUTO
		
		dbSelectArea("SC6")
		RecLock("SC6",.F.)
		SC6->C6_PRODUTO   := SH4->H4_CODIGO
		MsUnlock()
		
		dbSelectArea("SC6")
		dbSetOrder(2)
		dbSeek(xFilial("SC6")+SB1->B1_CODOLD)
		
	EndDo
Endif

Return


Static Function VerSC9()

dbSelectArea("SC9")
dbSetOrder(7)
If dbSeek(xFilial("SC9")+SB1->B1_CODOLD)
	
	_cCod := SC9->C9_PRODUTO
	
	While !Eof() .And.  _cCod == SC9->C9_PRODUTO
		
		dbSelectArea("SC9")
		RecLock("SC9",.F.)
		SC9->C9_PRODUTO := SH4->H4_CODIGO
		MsUnlock()
		
		dbSelectArea("SC9")
		dbSetOrder(7)
		dbSeek(xFilial("SC9")+SB1->B1_CODOLD)
		
	EndDo
Endif

Return


Static Function VerSC7()

dbSelectArea("SC7")
dbSetOrder(2)
If dbSeek(xFilial("SC7")+SB1->B1_CODOLD)
	
	_cCod := SC7->C7_PRODUTO
	
	While !Eof() .And.  _cCod == SC7->C7_PRODUTO
		
		dbSelectArea("SC7")
		RecLock("SC7",.F.)
		SC7->C7_PRODUTO := SH4->H4_CODIGO
		MsUnlock()
		
		dbSelectArea("SC7")
		dbSetOrder(2)
		dbSeek(xFilial("SC7")+SB1->B1_CODOLD)
		
	EndDo
Endif

Return