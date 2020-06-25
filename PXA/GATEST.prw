#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
Gatilho		: GEST001
Autor		: Fabiano da Silva
Data		: 19/05/2015
Descrição	: Atualizar o campo Conta contábil conforme o cadastro de Indicadores (BZ_YCONTA)	
*/

User Function GEST001()

	_aAliOri := GetArea()
	_aAliSCP := SCP->(GetArea())
	_aAliSB1 := SB1->(GetArea())
	_aAliSBZ := SBZ->(GetArea())

	_nPProduto := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "CP_PRODUTO" } )
	_nPConta   := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "CP_CONTA" } )

	_cProduto  := Acols[n][_nPProduto]
	_cConta    := Space(20)

	SBZ->(dbSetOrder(1))
	If SBZ->(msSeek(xFilial("SBZ")+_cProduto))
		_cConta := SBZ->BZ_YCONTA
	Endif

	If Empty(_cConta) 
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+_cProduto))
			_cConta := SB1->B1_CONTA
		Endif
	Endif

	RestArea(_aAliSBZ)
	RestArea(_aAliSB1)
	RestArea(_aAliSCP)
	RestArea(_aAliOri)

Return(_cConta)
