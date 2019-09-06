#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SD3250I   ºAutor  ³Alexandro da Silva  º Data ³  11/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função Utilizada para incluir os movimentos de Perda       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaEst                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SD3250E()

                   
	_lParar := .T.

	If SD3->D3_PERDA == 0
		Return
	Endif

	If SD3->D3_CF != "ER0"
		Return
	Endif

	_aAliOri := GetArea()
	_aAliSB2 := SB2->(GetArea())
	_aAliSBC := SBC->(GetArea())
	_aAliSD3 := SD3->(GetArea())
   
	_cNumSeq := SD3->D3_NUMSEQ

	dbSelectArea("SD3")
	dbOrderNickName("INDSD31")
	If dbSeek(xFilial() + _cNumSeq)

		_cChav := SD3->D3_CHAVPER
	
		While !Eof() .And.	_cChav == SD3->D3_CHAVPER

			dbSelectArea("SBC")
			dbOrderNickName("INDSBC2")
			If dbSeek(xfilial()+SD3->D3_NUMSEQ )//+ SD3->D3_OP )//+ SD3->D3_COD)
				dbSelectArea("SB2")
				dbSetOrder(1)
				If dbSeek(xFilial()+SBC->BC_PRODUTO + SBC->BC_LOCORIG)
					dbSelectArea("SB2")
					RecLock("SB2",.F.)
					SB2->B2_QATU  -= SD3->D3_QUANT
					SB2->B2_VATU1 := SB2->B2_QATU * SB2->B2_CM1
					MsUnlock()
				Else
					CriaSB2(SBC->BC_PRODUTO,SBC->BC_LOCORIG)
					dbSelectArea("SB2")
					RecLock("SB2",.F.)
					SB2->B2_QATU  -= SD3->D3_QUANT
					SB2->B2_VATU1 := SB2->B2_QATU * SB2->B2_CM1
					MsUnlock()
				Endif
	
				dbSelectArea("SBC")
				RecLock("SBC",.F.)
				dbDelete()
				MsUnlock()
			Endif
	
			dbSelectArea("SD3")
			RecLock("SD3",.F.)
			dbDelete()
			MsUnlock()
		    			
			dbSelectArea("SD3")
			dbSkip()
		EndDo
	Endif
		
	RestArea(_aAliSB2)
	RestArea(_aAliSBC)
	RestArea(_aAliSD3)
	RestArea(_aAliOri)

Return