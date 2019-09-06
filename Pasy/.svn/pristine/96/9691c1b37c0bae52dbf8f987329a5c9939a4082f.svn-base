#INCLUDE "TOTVS.ch"
#INCLUDE "TOPCONN.CH"


/*
Ponto de Entrada: M410LIOK
Autor			: Fabiano da Silva
Data Criação	: 29/06/15
Descrição 		: VALIDAÇÃO DE LINHA DO PEDIDO VENDA. Validação de linha no pedido de venda.
TDN				: http://tdn.totvs.com/pages/releaseview.action?pageId=6784149 
*/
User Function M410LIOK()

	_aAliOri := GetArea()
	_aAliSC5 := SC5->(GetArea())
	_aAliSC6 := SC6->(GetArea())
	_aAliSA1 := SA1->(GetArea())

	_nPPedCli  := Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_PEDCLI" 	} )
	_nPPOLine  := Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_POLINE" 	} )
	_nPItem    := Ascan(aHeader,{ |x| Upper(Alltrim(x[2])) == "C6_ITEM" 	} )

	_lRet := .T.

	If M->C5_CLIENTE $ GETMV('PA_LINEPO')

		SA1->(dbSetOrder(1))
		SA1->(msSeek(xFilial('SA1')+M->C5_CLIENTE+M->C5_LOJACLI))

		If SA1->A1_EST <> 'EX'
			If Empty(aCols[n][_nPPedCli]) 
				MsgAlert('Preencher o campo "Ped Cliente" para o Item: '+aCols[n][_nPItem])
				_lRet := .F.
			ElseIf Empty(aCols[n][_nPPOLine]) 
				MsgAlert('Preencher o campo "Linha Pedido" para o Item: '+aCols[n][_nPItem])
				_lRet := .F.
			Endif
		Endif
	Endif

	RestArea(_aAliSA1)
	RestArea(_aAliSC6)
	RestArea(_aAliSC5)
	RestArea(_aAliOri)

Return(_lRet)


/*
Ponto de Entrada para Exclusão de NF
*/

User Function SF2520E()

	_aAliOri := GetArea()
	_aAliSD2 := SD2->(GetArea())
	_aAliSF2 := SF2->(GetArea())

	U_CheckEstoq("D_",SF2->F2_DOC,SF2->F2_SERIE)

	RestArea(_aAliSD2)
	RestArea(_aAliSF2)
	RestArea(_aAliOri)

Return
