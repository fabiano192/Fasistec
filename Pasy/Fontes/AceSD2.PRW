#include "rwmake.ch"

User Function AceSd2()

SetPrvt("_cAliOri,_nOrdOri,_nRecOri,_aStrREt,_cArqRet")

_cAliOri := Alias()
_nOrdOri := IndexOrd()
_nRecOri := Recno()
_lBx     := .F.

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| ACESD21(@_lFim) }
Private _cTitulo01 := 'Processando Notas de Saida!!!'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

MSGINFO("Alteracao Efetuada com Sucesso !!! ")
Return



Static Function ACESD21(_lFim)

dbSelectArea("SZ4")
dbSetOrder(9)
dbGotop()

ProcRegua(LastRec())

While !Eof()
	
	IncProc("Produto :"+SZ4->Z4_PRODPAS)              
		   
	If SZ4->Z4_CODCLI != "000171"
		dbSelectArea("SZ4")
		dbSkip()
		Loop
	Endif
			
	_cChavZ4 := SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS
	
	While !Eof() .And. _cChavZ4 == SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS
		dbSelectArea("SZ4")
		dbSkip()
	EndDo
          
	dbSelectArea("SZ4")
	dbSkip(-1)	
	                           
	If SZ4->Z4_CODCLI != "000171"
		dbSelectArea("SZ4")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SC6")
	dbSetOrder(9)
	If dbSeek(xFilial("SC6")+SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS )
	
		_cChavSC6 := SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO
		
		While !Eof() .And. _cChavSC6 == SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_PRODUTO

			dbSelectArea("SC6")
			RecLock("SC6",.F.)
            SC6->C6_PEDCLI := SZ4->Z4_PEDIDO
			MsUnLock()
			
			dbSelectArea("SC6")
			dbSkip()			
		EndDo
	Endif	                     

	dbSelectArea("SZ2")
	dbSetOrder(6)
	If dbSeek(xFilial("SZ2")+ SZ4->Z4_CODCLI  + SZ4->Z4_LOJA + SZ4->Z4_PRODCLI+"1")
		dbSelectArea("SZ2")
		RecLock("SZ2",.F.)
        SZ2->Z2_PEDCLI := SZ4->Z4_PEDIDO
		MsUnLock()
	Endif	
	
	dbSelectArea("SD2")
	dbOrderNickName("INDSD21")
	If dbSeek(xFilial("SD2")+SZ4->Z4_CODCLI + SZ4->Z4_LOJA + SZ4->Z4_PRODPAS +SZ4->Z4_PEDIDO)
	
		_cChavSD2 := SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD    
		
		While !Eof() .And. _cChavSD2 == SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD     

			dbSelectArea("SD2")
			RecLock("SD2",.F.)
            SD2->D2_PEDCLI := SZ4->Z4_PEDIDO
			MsUnLock()
			
			dbSelectArea("SD2")
			dbSkip()			
		EndDo
	Endif	                     
	
	dbSelectArea("SZ4")
	dbSkip()
EndDo

Return