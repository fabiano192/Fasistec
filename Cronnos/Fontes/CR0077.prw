#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
Programa:	CR0077
Autor:		FABIANO DA SILVA
Data:		25/08/10
Descrição: 	Programa utilizado para validar se o fornecedor é homologado e se a data de validade está correta.
*/

User Function CR0077()

	Private _lRet := .T.

	_cChav := ""
	_lGo   := .T.
	If FunName() = "MATA121"
		//	_cChav := M->C7_FORNECE//+M->C7_LOJA
		_cChav := CA120FORN
//	ElseIf FunName() = "MATA103" .Or. FunName() = "MATA140"
	ElseIf Alltrim(FunName()) $ "MATA103|MATA140|AS_XML"
		If cTipo = 'N'
			_cChav := M->F1_FORNECE//+M->F1_LOJA
		Else
			_lGo   := .F.
		Endif
	Endif

	If _lGo
		SA2->(dbsetOrder(1))
		If SA2->(dbSeek(xFilial("SA2")+_cChav))

			If SA2->A2_HOMOLOG = '1' .And. (SA2->A2_DTVALHO < dDataBase .Or. SA2->A2_PONENOK = '2')
				_lRet := .F.
				Alert("Homologação do Fornecedor está com a data de validade expirada.")
			Endif

		Endif
	Endif

Return (_lRet)
