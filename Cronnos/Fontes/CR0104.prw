#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"


/*/{Protheus.doc} CR0104
//Gerar o arquivo EDI de Invoice para Caterpillar Exportação.
@author Fabiano
@since 12/02/2018
@version 1.0
/*/
User Function CR0104()
	
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
	
	Conout("CR0104 - Início processo de geração de Invoice")
	
	If Select("TEEC") > 0
		TEEC->(dbCloseArea())
	Endif

	_cQuery := " SELECT * FROM "+RetSqlName("EEC")+" EEC " +CRLF
	_cQuery += " WHERE EEC.D_E_L_E_T_ = '' " +CRLF
	_cQuery += " AND EEC_EDIINV = '' AND EEC_DTEMBA <> '' " +CRLF
	_cQuery += " AND EEC_DTEMBA <= '"+dTos(dDataBase)+"' " +CRLF
	_cQuery += " AND EEC_IMPORT = '000018' " +CRLF
	_cQuery += " ORDER BY EEC_PREEMB " +CRLF

	TcQuery _cQuery New Alias "TEEC"

	TEEC->(dbGotop())

	While TEEC->(!EOF())

		U_CR034A(.F.,TEEC->EEC_PREEMB)

		TEEC->(dbSkip())
	EndDo

	TEEC->(dbCloseArea())

	Conout("CR0104 - Fim processo de geração de Invoice")

Return(Nil)