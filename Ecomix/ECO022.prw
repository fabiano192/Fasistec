#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} ECO022
Grava Cliente / Fornecedor
@type function
@version 
@author Fabiano
@since 02/12//2020
@return return_type, return_description
/*/
User Function ECO022(_aParam,_lAut)

	Local _oDlg  := Nil
	Local _nOpt  := 0

	Local _cTitulo	:= 'Processando'
	Local _cMsgTit	:= 'Aguarde, analisando Dados...'

	Private _oTipo
	Private _aTipo	:= {'Cliente','Fornecedor'}
	Private _cTipo	:= 'Cliente''

	Private _cCod	:= Space(10)

	Private _oOrig
	Private _aOrig	:= {'00-Global','09-ECOMIX ARGAMASSAS','10-PEGADA FORTE INDÚSTRIA DE ARGAMASSAS LTDA','11-ARGALAGOS'}
	Private _cOrig	:= '00-Global'
	Private _lSched := If(ValType(_lAut) = "U",.F.,_lAut)

	If ValType( _aParam ) <> "U"
		PREPARE ENVIRONMENT EMPRESA _aParam[1] FILIAL _aParam[2]
	Endif

	If !_lSched

		DEFINE MSDIALOG _oDlg FROM 0,0 TO 245,315 TITLE "Cadastro Cliente / Fornecedor" OF _oDlg PIXEL

		_oGrup1	:= TGroup():New( 005,005,030,155,"",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

		@ 009,010 SAY "Esta rotina importa o cadastro de Cliente ou Fornecedor do RM para o Protheus." OF _oGrup1 PIXEL Size 150,020


		_oGrup2 := TGroup():New( 031,005,055,155,"Selecione abaixo o tipo de cadastro à ser importado.",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

		@ 40,010 SAY "Tipo: " 	Size 50,010 OF _oGrup2 PIXEL
		@ 40,040 MsCOMBOBOX _oTipo 	VAR _cTipo ITEMS _aTipo Size 110,04  PIXEL OF _oGrup2


		_oGrup5 := TGroup():New( 056,005,100,155,"Preencha abaixo o codigo RM e a Origem",_oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

		@ 65,010 SAY "Código RM: " 	Size 50,010 OF _oGrup5 PIXEL
		@ 65,040 MsGet _cCod		Picture "@!" Size 110,010  PIXEL OF _oGrup5

		@ 85,010 SAY "Origem " 	Size 70,010 OF _oGrup5 PIXEL
		@ 85,040 MsCOMBOBOX _oOrig 	VAR _cOrig ITEMS _aOrig Size 110,04  PIXEL OF _oGrup5


		_oGrup6:= TGroup():New( 0101,005,120,155,"",_oDlg,CLR_HBLUE,CLR_HGREEN,.T.,.F. )

		@ 105,015 BUTTON "OK" 			SIZE 036,012 ACTION {||_nOpt := 1,_oDlg:END()} OF _oGrup6 PIXEL
		@ 105,109 BUTTON "Sair"			SIZE 036,012 ACTION {||_nOpt := 2,_oDlg:End()} 	OF _oGrup6 PIXEL

		ACTIVATE MSDIALOG _oDlg CENTERED

		If _nOpt = 1
			FWMsgRun(, {|| ECO22A(_lSched,_cTipo) }, _cTitulo, _cMsgTit )
		Endif

	Else
		ECO22A(_lSched,'Cliente')
		ECO22A(_lSched,'Fornecedor')
	Endif

Return(Nil)



Static Function ECO22A(_lSched,_cTipo)

	Local _cQry2 := ''

	_cQry2 := " SELECT RIGHT('00'+RTRIM(CAST(A.CODCOLIGADA AS CHAR(02))),2) AS CODEMP,CAST(A.CODCFO AS CHAR(07)) AS CODCFO, A.NOMEFANTASIA AS NREDUZ,A.NOME,A.CGCCFO,A.INSCRESTADUAL AS INSCR,"+ CRLF
	_cQry2 += " CAST(A.PAGREC AS CHAR(01)) AS PAGREC, A.RUA,A.NUMERO,A.COMPLEMENTO AS COMPLEM,A.PESSOAFISOUJUR AS PESSOA,A.CODMUNICIPIO AS COD_MUN,A.CODETD,A.CIDADE,"+ CRLF
	_cQry2 += " A.BAIRRO,A.CEP,A.TELEFONE,A.CONTATO,A.EMAIL,A.ATIVO,A.LIMITECREDITO AS LC,A.CONTRIBUINTE AS CONTRIB,A.INSCRMUNICIPAL AS INSCRM, "+ CRLF
	_cQry2 += " A.IDCFO,B.NUMEROBANCO AS FORBCO,B.CODIGOAGENCIA AS FORAGE,B.DIGITOAGENCIA AS FORDAG,B.CONTACORRENTE AS FORCTA, B.DIGITOCONTA AS FORDCT  "+ CRLF
	_cQry2 += " FROM [10.140.1.5].[CorporeRM].dbo.FCFO A "+ CRLF
	_cQry2 += " LEFT JOIN [10.140.1.5].[CorporeRM].dbo.FDADOSPGTO B ON B.CODCOLCFO = A.CODCOLIGADA AND B.CODCFO = A.CODCFO "+ CRLF
	If _cTipo = 'Cliente'
		_cQry2 += " WHERE PAGREC <> 2 " + CRLF
		_cQry2 += " AND A.CODCOLIGADA = '"+cValToChar(Val(Left(_cOrig,2)))+"' " + CRLF
	ElseIf _cTipo = 'Fornecedor'
		_cQry2 += " WHERE A.PAGREC <> 1 " + CRLF
		_cQry2 += " AND A.CODCOLIGADA = '"+cValToChar(Val(Left(_cOrig,2)))+"' " + CRLF
	Endif
	If _lSched
		_cQry2 += " AND LEFT(CONVERT(char(15), A.DATACRIACAO, 23),4) + " +CRLF
		_cQry2 += " SUBSTRING(CONVERT(char(15), A.DATACRIACAO, 23),6,2) + " +CRLF
		_cQry2 += " SUBSTRING(CONVERT(char(15), A.DATACRIACAO, 23),9,2) " +CRLF
		_cQry2 += " >= '20201201' " + CRLF
	Else
		_cQry2 += " AND A.CODCFO = '"+Alltrim(_cCod)+"' "+ CRLF
	Endif
	_cQry2 += " ORDER BY CODCFO,CODEMP,PAGREC " + CRLF

	TcQuery _cQry2 New Alias "TCAD"

	If Contar("TCAD","!EOF()") = 0
		If !_lSched
			MsgAlert("Cadastro não encontrado nas tabelas do RM para ser importado.")
			Return(Nil)
		Endif
	Endif

	TCAD->(dbGoTop())

	While TCAD->(!EOF())

		_cCNPJ := Alltrim(StrTran(StrTran(StrTran(TCAD->CGCCFO,".",""),"-",""),"/",""))
		_cCod  := ''
		_cLoja := ''

		If _cTipo = 'Cliente'
			SA1->(dbSetOrder(3))
			If !SA1->(MsSeek(xFilial("SA1")+_cCNPJ))
				GeraCli(_cCNPJ,@_cCod,@_cLoja)
				If !_lSched
					MsgInfo('Código Protheus '+_cCod+'/'+_cLoja+' para o registro '+Alltrim(TCAD->CODCFO)+'.')
				Endif
			Else

				_cCod  := SA1->A1_COD
				_cLoja := SA1->A1_LOJA

				If !_lSched
					MsgAlert('Cadastro para o CNPJ '+_cCNPJ+' já existente com o código Protheus '+_cCod+'/'+_cLoja+'!')
					// If MsgYesNo('Cadastro para o CNPJ '+_cCNPJ+' já existente com o código Protheus '+_cCod+'/'+_cLoja+'! Deseja efetuar um novo cadastro para o mesmo CNPJ?')
					// 	_cCod  := ''
					// 	_cLoja := ''
					// 	GeraCli(_cCNPJ,@_cCod,@_cLoja)
					// Endif
				Endif

			Endif

			// (_cAliasZF6)->(RecLock(_cAliasZF6,.T.))
			// (_cAliasZF6)->ZF6_FILIAL := _cFil
			// (_cAliasZF6)->ZF6_TABELA := "SA1"
			// (_cAliasZF6)->ZF6_CAMPO  := "A1_COD"
			// (_cAliasZF6)->ZF6_CODRM  := TCAD->CODCFO
			// (_cAliasZF6)->ZF6_IDRM   := TCAD->IDCFO
			// (_cAliasZF6)->ZF6_TOTVS  := _cCod+_cLoja
			// (_cAliasZF6)->(MsUnLock())


		ElseIf _cTipo = 'Fornecedor'
			SA2->(dbSetOrder(3))
			If !SA2->(MsSeek(xFilial("SA2")+_cCNPJ))
				GeraFor(_cCNPJ,@_cCod,@_cLoja)
				If !_lSched
					MsgInfo('Código Protheus '+_cCod+'/'+_cLoja+' para o registro '+Alltrim(TCAD->CODCFO)+'.')
				Endif
			Else

				_cCod  := SA2->A2_COD
				_cLoja := SA2->A2_LOJA

				If !_lSched
					MsgAlert('Cadastro para o CNPJ '+_cCNPJ+' já existente com o código Protheus '+_cCod+'/'+_cLoja+'!')
					// If MsgYesNo('Cadastro para o CNPJ '+_cCNPJ+' já existente com o código Protheus '+_cCod+'/'+_cLoja+'! Deseja efetuar um novo cadastro para o mesmo CNPJ?')
					// 	_cCod  := ''
					// 	_cLoja := ''
					// 	GeraFor(_cCNPJ,@_cCod,@_cLoja)
					// Endif
				Endif

			Endif
		Endif

		TCAD->(dbSkip())
	EndDo

	TCAD->(dbCloseArea())

Return(Nil)




Static Function GeraCli(_cCNPJ,_cCod,_cLoja)

	If TCAD->PESSOA = "J"
		SA1->(dbSetOrder(3))
		If SA1->(MsSeek(xFilial("SA1")+Left(_cCNPJ,8)))
			_cCod := SA1->A1_COD
		Endif
	Endif

	GetNxtA1(@_cCod,@_cLoja)

	// _cCfop:= Left(StrTran(TRB->CODNAT,".",""),4)

	SA1->(RecLock("SA1",.T.))
	SA1->A1_COD        := _cCod
	SA1->A1_LOJA       := _cLoja
	SA1->A1_PESSOA     := TCAD->PESSOA
	SA1->A1_NOME       := UPPER(U_RM_NoAcento(TCAD->NOME))
	SA1->A1_NREDUZ     := UPPER(U_RM_NoAcento(TCAD->NREDUZ))
	SA1->A1_END        := UPPER(U_RM_NoAcento(Alltrim(TCAD->RUA)))+" "+UPPER(U_RM_NoAcento(ALLTRIM(TCAD->NUMERO)))
	SA1->A1_COMPLEM    := UPPER(U_RM_NoAcento(Alltrim(TCAD->COMPLEM)))
	// If Alltrim(_cCFOP ) $ "5401/5403"
	// 	SA1->A1_TIPO       := "S"
	// Else
	// 	SA1->A1_TIPO       := "R"
	// Endif
	SA1->A1_EST        := TCAD->CODETD
	SA1->A1_COD_MUN    := TCAD->COD_MUN
	SA1->A1_MUN        := UPPER(U_RM_NoAcento(Alltrim(TCAD->CIDADE)))
	SA1->A1_BAIRRO     := UPPER(U_RM_NoAcento(Alltrim(TCAD->BAIRRO)))
	SA1->A1_NATUREZ    := "N1001"
	SA1->A1_CEP        := StrTran(TCAD->CEP,".","")
	SA1->A1_TEL        := TCAD->TELEFONE
	SA1->A1_PAIS       := "105"
	SA1->A1_CGC        := _cCNPJ
	SA1->A1_CONTATO    := TCAD->CONTATO
	SA1->A1_INSCR      := IIF (Empty(TCAD->INSCR),"ISENTO",TCAD->INSCR)
	SA1->A1_CODPAIS    := "01058"
	SA1->A1_SATIV1     := "1"
	SA1->A1_SATIV2     := "1"
	SA1->A1_SATIV3     := "1"
	SA1->A1_SATIV4     := "1"
	SA1->A1_SATIV5     := "1"
	SA1->A1_SATIV6     := "1"
	SA1->A1_SATIV7     := "1"
	SA1->A1_SATIV8     := "1"
	SA1->A1_EMAIL      := TCAD->EMAIL
	SA1->A1_EMAILNF    := TCAD->EMAIL
	SA1->A1_MSBLQL     := If(TCAD->ATIVO=1,"2","1")
	SA1->A1_LC         := TCAD->LC
	SA1->A1_INSCRM     := TCAD->INSCRM
	SA1->A1_CONTRIB    := If(TCAD->CONTRIB=1,"2","1")
	SA1->A1_XNOMV      := "."
	SA1->A1_CONTA      := "10102020000001"
	SA1->A1_YTPCLI     := "1"
	SA1->A1_YCTARA     := "20101150000002"
	SA1->A1_COND       := "001"
	SA1->(MsUnLock())

RETURN(NIL)



Static Function GetNxtA1(_cCod,_cLoja)

	Local _cQrySA1 := ""

	If Empty(_cCod)

		_cQrySA1 := " SELECT MAX(A1_COD) AS COD FROM "+RetSqlName("SA1")+" A1 " +CRLF
		_cQrySA1 += " WHERE A1.D_E_L_E_T_ = '' AND A1_FILIAL = '"+xFilial("SA1")+"' " +CRLF

		TcQuery _cQrySA1 New Alias "TNEXT"

		TNEXT->(dbGoTop())

		_cCod := "C"+SOMA1(RIGHT(TNEXT->COD,5))
		_cLoja := "01"

		TNEXT->(dbCloseArea())
	Else

		_cQrySA1 := " SELECT MAX(A1_LOJA) AS LOJA FROM "+RetSqlName("SA1")+" A1 " +CRLF
		_cQrySA1 += " WHERE A1.D_E_L_E_T_ = '' AND A1_FILIAL = '"+xFilial("SA1")+"' " +CRLF
		_cQrySA1 += " AND A1_COD = '"+_cCod+"' " +CRLF

		TcQuery _cQrySA1 New Alias "TNEXT"

		TNEXT->(dbGoTop())

		_cLoja := SOMA1(TNEXT->LOJA)

		TNEXT->(dbCloseArea())
	Endif

Return(Nil)






Static Function GeraFOR(_cCNPJ,_cCod,_cLoja)

	If TCAD->PESSOA = "J"
		SA2->(dbSetOrder(3))
		If SA2->(MsSeek(xFilial("SA2")+Left(_cCNPJ,8)))
			_cCod := SA2->A2_COD
		Endif
	Endif

	GetNxtA2(@_cCod,@_cLoja)

	SA2->(RecLock("SA2",.T.))
	SA2->A2_COD     := _cCod
	SA2->A2_LOJA    := _cLoja
	SA2->A2_NOME    := UPPER(U_RM_NoAcento(TCAD->NOME))
	SA2->A2_NREDUZ  := UPPER(U_RM_NoAcento(TCAD->NREDUZ))
	SA2->A2_END     := UPPER(U_RM_NoAcento(Alltrim(TCAD->RUA)))+" "+UPPER(U_RM_NoAcento(ALLTRIM(TCAD->NUMERO)))
	SA2->A2_COMPLEM := UPPER(U_RM_NoAcento(Alltrim(TCAD->COMPLEM)))
	SA2->A2_TIPO    := TCAD->PESSOA
	SA2->A2_EST     := TCAD->CODETD
	SA2->A2_COD_MUN := TCAD->COD_MUN
	SA2->A2_MUN     := UPPER(U_RM_NoAcento(Alltrim(TCAD->CIDADE)))
	SA2->A2_BAIRRO  := UPPER(U_RM_NoAcento(Alltrim(TCAD->BAIRRO)))
	SA2->A2_NATUREZ := "N3002"
	SA2->A2_CEP     := StrTran(TCAD->CEP,".","")
	SA2->A2_TEL     := TCAD->TELEFONE
	SA2->A2_PAIS    := "105"
	SA2->A2_CGC     := _cCNPJ
	SA2->A2_CONTATO := TCAD->CONTATO
	SA2->A2_INSCR   := IIF (EMPTY(TCAD->INSCR),"ISENTO","")
	SA2->A2_CODPAIS := "01058"
	SA2->A2_EMAIL   := TCAD->EMAIL
	SA2->A2_MSBLQL  := If(TCAD->ATIVO=1,"2","1")
	SA2->A2_INSCRM  := TCAD->INSCRM
	SA2->A2_CONTRIB := If(TCAD->CONTRIB = 1,"2","1")
	SA2->A2_BANCO   := TCAD->FORBCO
	SA2->A2_AGENCIA := TCAD->FORAGE
	SA2->A2_XDVAGEN := TCAD->FORDAG
	SA2->A2_NUMCON  := TCAD->FORCTA
	SA2->A2_XDVCON  := TCAD->FORDCT
	SA2->(MsUnLock())

RETURN(NIL)




Static Function GetNxtA2(_cCod,_cLoja)

	Local _cQrySA2 := ""

	If Empty(_cCod)

		_cQrySA2 := " SELECT MAX(A2_COD) AS COD FROM "+RetSqlName("SA2")+" A2 " +CRLF
		_cQrySA2 += " WHERE A2.D_E_L_E_T_ = '' AND A2_FILIAL = '"+xFilial("SA2")+"' " +CRLF

		TcQuery _cQrySA2 New Alias "TNEXT"

		TNEXT->(dbGoTop())

		_cCod := "F"+SOMA1(RIGHT(TNEXT->COD,5))
		_cLoja := "01"

		TNEXT->(dbCloseArea())
	Else

		_cQrySA2 := " SELECT MAX(A2_LOJA) AS LOJA FROM "+RetSqlName("SA2")+" A2 " +CRLF
		_cQrySA2 += " WHERE A2.D_E_L_E_T_ = '' AND A2_FILIAL = '"+xFilial("SA2")+"' " +CRLF
		_cQrySA2 += " AND A2_COD = '"+_cCod+"' " +CRLF

		TcQuery _cQrySA2 New Alias "TNEXT"

		TNEXT->(dbGoTop())

		_cLoja := SOMA1(TNEXT->LOJA)

		TNEXT->(dbCloseArea())
	Endif

Return(Nil)

