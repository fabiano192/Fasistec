#Include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#Include "topconn.ch"
//#Define LF chr(10)


User function MT100TOK()

	_cNaturez := MaFisRet(,"NF_NATUREZA")                     
	_cCusto   := ACOLS[_nL,_nPosCCus]
	cCC 	  := _CCusto
	_cConta   := ACOLS[_nL,_nPosCta]
	                      
	
	If Empty (Alltrim(_cNaturez))
		MSGSTOP("ATENCAO, NATUREZA DO TITULO NAO PREENCHIDA")
		lRet:=.F.
		EXIT
	Endif
	
Return(lRet)