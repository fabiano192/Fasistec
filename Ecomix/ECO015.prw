#Include "Protheus.ch"
#include "topconn.ch"
#Include "RWMAKE.CH"
#Include "Xmlxfun.ch"
#include "tbiconn.ch"

/*/{Protheus.doc} ECO015
EXPORTA MOVIMENTO FINANCEIRO
@type function
@version 
@author Fabiano
@since 26/08/2020
@return return_type, return_description
/*/
User Function ECO015()

	ATUSX1()

	_nOpc := 0
	@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Importa Movimento Financeiro ")
	@ 02,10 TO 080,220
	@ 10,18 SAY "Importacao do Movimento de Movimento Financeiro     "     SIZE 160,7
	@ 18,18 SAY "                                                    "     SIZE 160,7
	@ 26,18 SAY "                                                    "     SIZE 160,7
	@ 34,18 SAY "                                                    "     SIZE 160,7

	@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("ECO015")
	@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
	@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

	ACTIVATE DIALOG oDlg Centered

	Pergunte("ECO015",.F.)

	If _nOpc == 1

		Private _lFim      := .F.
		Private _cTitulo01 := 'Importando Movimento Financeiro!!!'

		Processa( {|| ECO15_01() } , _cTitulo01, "Processando ...",.T.)
	Endif

Return (Nil)



Static Function ECO15_01()

	Local AX, a, _cQry2

	_cQry2 := " SELECT RIGHT('00'+RTRIM(CAST(CODCOLIGADA AS CHAR(02))),2) AS CODEMP,CAST(CODCFO AS CHAR(07)) AS CODCFO, NOMEFANTASIA AS NREDUZ,NOME,CGCCFO,INSCRESTADUAL AS INSCR,"+ CRLF
	_cQry2 += " CAST(PAGREC AS CHAR(01)) AS PAGREC, RUA,NUMERO,COMPLEMENTO AS COMPLEM,PESSOAFISOUJUR AS PESSOA,CODMUNICIPIO AS COD_MUN,CODETD,CIDADE,"+ CRLF
	_cQry2 += " BAIRRO,CEP,TELEFONE,CONTATO,EMAIL,ATIVO,LIMITECREDITO AS LC,CONTRIBUINTE AS CONTRIB,INSCRMUNICIPAL AS INSCRM, "+ CRLF
	_cQry2 += " IDCFO FROM [10.140.1.5].[CorporeRM].dbo.FCFO "+ CRLF
	_cQry2 += " ORDER BY CODCFO,CODEMP,PAGREC " + CRLF

	TcQuery _cQry2 New Alias "TFOR"

	_cArq := CriaTrab(NIL,.F.)
	Copy To &_cArq

	dbCloseArea()

	dbUseArea(.T.,,_cArq,"TFOR",.T.)
	_cInd := "CODCFO + CODEMP + PAGREC"
	IndRegua("TFOR",_cArq,_cInd,,,"Selecionando Arquivo Trabalho")



	// _aEmp:= {{'A','0101','91'},{'A','0102','92'},{'A','0103','93'},{'B','0201','101'},{'B','0203','103'},{'B','0204','104'},{'C','0301','111'},{'C','0303','113'}}
	_aEmp:= {{'A','0103','93'}}

	ProcRegua(Len(_aEmp))

	For AX:= 1 To Len(_aEmp)

		IncProc("Importando Movimento Financeiro")

		_cEmp   := Left(_aEmp[AX][2],2)
		_cFil   := Right(_aEmp[AX][2],2)
		_cFilRM := _aEmp[AX][3]

		ECO15_02(_cEmp,_cFil,_cFilRM) //SE1
		// ECO15_03(_cEmp,_cFil,_cFilRM) //SE2
		// ECO15_04(_cEmp,_cFil,_cFilRM) //SE5

	Next AX

	TFOR->(dbCloseArea())
Return



Static Function ECO15_02(_cEmp,_cFil,_cFilRM) //SE1

	Local _aArea     := GetArea()
	Local _aAreaSA1  := SA1->( GetArea() )
	Local _aAreaSA6  := SA6->( GetArea() )
	Local _aAreaZF6  := ZF6->( GetArea() )
	Local _aAreaSE1  := SE1->( GetArea() )
	Local _cAliasSA1 := ''
	Local _cAliasSA6 := ''
	Local _cAliasZF6 := ''
	Local _cAliasSE1 := ''
	Local _cModo
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _lOutSA1   := .F.
	Local _lOutSA6   := .F.
	Local _lOutZF6   := .F.
	Local _lOutSE1   := .F.

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	Endif

	_cQry := " SELECT CODFILIAL AS FILIAL,DATAVENCIMENTO AS DTVENC, * FROM  [10.140.1.5].[CorporeRM].dbo.FLAN A " + CRLF
	_cQry += " WHERE RTRIM(A.CODCOLIGADA)+RTRIM(A.CODFILIAL) IN ('"+_cFilRM+"') " + CRLF
	_cQry += " AND PAGREC = '1' " + CRLF
	_cQry += " AND LEFT(CONVERT(char(15), A.DATAEMISSAO, 23),4) + " +CRLF
	_cQry += " SUBSTRING(CONVERT(char(15), A.DATAEMISSAO, 23),6,2) + " +CRLF
	_cQry += " SUBSTRING(CONVERT(char(15), A.DATAEMISSAO, 23),9,2) " +CRLF
	_cQry += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + CRLF
	// _cQry += " AND NOT EXISTS(SELECT * FROM [10.140.1.5].[CorporeRM].dbo.TMOV T WHERE T.CODCOLIGADA = A.CODCOLIGADA And T.IDMOV = A.IDMOV) " + CRLF
	_cQry += " ORDER BY CODCOLIGADA,CODFILIAL " + CRLF

	Memowrite("D:\_Temp\ECO015.txt",_cQry)

	TcQuery _cQry New Alias "TRB"

	_nReg := Contar("TRB","!EOF()")

	_cTabSE1:=  "SE1"+_cEmp+"0"
	If Alltrim(cEmpAnt) = _cEmp
		_cAliasSA1 := "SA1"
		_cAliasSA6 := "SA6"
		_cAliasZF6 := "ZF6"
		_cAliasSE1 := "SE1"
	Else
		If EmpOpenFile("TSA1","SA1",1,.T., _cEmp,@_cModo)
			_cAliasSA1  := "TSA1"
			_lOutSA1 := .T.
		Endif
		If EmpOpenFile("TSA6","SA6",1,.T., _cEmp,@_cModo)
			_cAliasSA6 := "TSA6"
			_lOutSA6 := .T.
		Endif
		If EmpOpenFile("TZF6","ZF6",1,.T., _cEmp,@_cModo)
			_cAliasZF6  := "TZF6"
			_lOutZF6 := .T.
		Endif
		If EmpOpenFile("TSE1","SE1",1,.T., _cEmp,@_cModo)
			_cAliasSE1  := "TSE1"
			_lOutSE1 := .T.
		Endif
	Endif

	If !Empty(_cAliasSA1) .And. !Empty(_cAliasSA6) .And. !Empty(_cAliasZF6) .And. !Empty(_cAliasSE1)

		//Exclui daddos da tabela SE1
		_cUpd := " DELETE "+_cTabSE1+ " FROM "+_cTabSE1+" WHERE E1_FILIAL = '"+_cFil+"' "
		_cUpd += " AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
		_cUpd += " AND E1_TIPO <> 'NF' "

		TCSQLEXEC(_cUpd )

		TRB->(dbGoTop())

		While TRB->(!EOF())

			_cKey1   := Alltrim(cValToChar(TRB->CODCOLIGADA))
			While TRB->(!EOF())  .And. _cKey1 == Alltrim(cValToChar(TRB->CODCOLIGADA))

				//Verifica se o Cliente está cadastrado na tabela ZF6, que relaciona o código RM X Protheus
				_lRet := CheckZF6(2,_cFil,_cAliasZF6,,_cAliasSA1)

				If !_lRet
					Return(Nil)
				Endif

				_cNomCli   := ''
				_cCodCli   := Left((_cAliasZF6)->ZF6_TOTVS,6)
				_cLojCli   := Substr((_cAliasZF6)->ZF6_TOTVS,7,2)

				(_cAliasSA1)->(dbSetOrder(1))
				If (_cAliasSA1)->(MsSeek(xFilial("SA1")+_cCodCli+_cLojCli))
					_cNomCli := (_cAliasSA1)->A1_NREDUZ
					_cUF	 := (_cAliasSA1)->A1_EST
					_cTpCli  := (_cAliasSA1)->A1_TIPO
				Endif

				(_cAliasSE1)->(RecLock(_cAliasSE1,.T.))
				(_cAliasSE1)->E1_FILIAL    := _cFil
				(_cAliasSE1)->E1_PREFIXO   := If(Alltrim(TRB->SERIEDOCUMENTO) = '@@@','',Alltrim(TRB->SERIEDOCUMENTO))
				(_cAliasSE1)->E1_NUM       :=  Alltrim(Left(TRB->NUMERODOCUMENTO,9))

				_cParcela := UPPER(Alltrim(TRB->PARCELA))

				If Empty(_cParcela)
					_nAt := At("-",Alltrim(TRB->NUMERODOCUMENTO))
					If _nAt > 0
						_cParcela := Substr(TRB->NUMERODOCUMENTO,_nAt+1)
					Else
						If Len(TRB->NUMERODOCUMENTO) > 9
							_cParcela := Substr(TRB->NUMERODOCUMENTO,10)
						Endif
					Endif
				Endif

				(_cAliasSE1)->E1_PARCELA   := _cParcela
				(_cAliasSE1)->E1_TIPO      := "NF"
				(_cAliasSE1)->E1_NATUREZ   := "N1001"
				// (_cAliasSE1)->E1_PORTADO   := (TRB->CNABBANCO)
				// (_cAliasSE1)->E1_AGEDEP    := ??

				(_cAliasSE1)->E1_CLIENTE    := _cCodCli
				(_cAliasSE1)->E1_LOJA       := _cLojCli
				(_cAliasSE1)->E1_NOMCLI     := _cNomCli

				(_cAliasSE1)->E1_EMISSAO    := TRB->DATAEMISSAO
				(_cAliasSE1)->E1_EMIS1      := TRB->DATAEMISSAO

				(_cAliasSE1)->E1_VENCTO     := TRB->DTVENC
				(_cAliasSE1)->E1_VENCREA    := TRB->DTVENC
				(_cAliasSE1)->E1_VENCORI    := TRB->DTVENC
				(_cAliasSE1)->E1_BAIXA      := TRB->DATABAIXA

				(_cAliasSE1)->E1_VALOR      := TRB->VALOR
				(_cAliasSE1)->E1_VLCRUZ     := TRB->VALOR
				(_cAliasSE1)->E1_CODBAR     := TRB->CODIGOBARRA
				(_cAliasSE1)->E1_BASEIRF    := TRB->VALORBASEIRRF
				(_cAliasSE1)->E1_IRRF       := TRB->VALORIRRF
				(_cAliasSE1)->E1_VALLIQ     := TRB->VALOR + TRB->JUROS + TRB->MULTA - TRB->DESCONTO
				(_cAliasSE1)->E1_JUROS      := TRB->JUROS
				(_cAliasSE1)->E1_MULTA      := TRB->MULTA
				(_cAliasSE1)->E1_DESCONT    := TRB->DESCONTO
				(_cAliasSE1)->E1_MOEDA      := 1

				(_cAliasSE1)->E1_HIST       := TRB->HISTORICO
				(_cAliasSE1)->E1_SALDO      := If(TRB->VLBAIXA >= TRB->VALOR, 0 , TRB->VALOR - TRB->VLBAIXA)

				(_cAliasSE1)->E1_MODSPB     := "1"
				(_cAliasSE1)->E1_DESDOBR    := "2"
				(_cAliasSE1)->E1_PROJPMS    := "2"
				(_cAliasSE1)->E1_MULTNAT    := "2"

				(_cAliasSE1)->(MsUnLock())

				TRB->(dbSkip())
			EndDo
		EndDo

		cFilAnt := _cSvFilAnt
		cEmpAnt := _cSvEmpAnt

		RestArea( _aAreaSA2 )
		RestArea( _aAreaSA1 )
		RestArea( _aAreaZF6 )
		RestArea( _aAreaSF4 )
		RestArea( _aAreaSE1 )

		RestArea( _aArea )

	Endif

	If _lOutSB1
		TSB1->(dbCloseArea())
	ENDIF
	If _lOutSA2
		TSA2->(dbCloseArea())
	ENDIF
	If _lOutSA1
		TSA1->(dbCloseArea())
	ENDIF
	If _lOutZF6
		TZF6->(dbCloseArea())
	ENDIF
	If _lOutSE1
		TSE2->(dbCloseArea())
	ENDIF

	TRB->(dbCloseArea())

Return(Nil)



Static Function ATUSX1()

	cPerg := "ECO015"
	aRegs := {}

//    	   Grupo/Ordem/Pergunta                /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01    /Def01            /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(cPerg,"01","Data De?                ",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"02","Data Ate ?              ",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return (Nil)



Static Function CheckZF6(_nOpc,_cFil,_cAliasZF6,_cAliasSA2,_cAliasSA1)

	DEFAULT _cAliasSA2 := ''
	DEFAULT _cAliasSA1 := ''

	If _nOpc = 1
		(_cAliasZF6)->(dbSetOrder(1))
		If !(_cAliasZF6)->(MsSeek(xFilial("ZF6")+"SA2"+PADR("A2_COD",TAMSX3("ZF6_CAMPO")[1])+Alltrim(TRB->CODCFO)))

			_lGrava := .F.
			If TFOR->(MsSeek(TRB->CODCFO + STRZERO(TRB->CODCOLIGADA,2)+ "1"))
				_lGrava := .T.
			Else
				If TFOR->(MsSeek(TRB->CODCFO + STRZERO(TRB->CODCOLIGADA,2)) )
					_lGrava := .T.
				Else
					If TFOR->(MsSeek(TRB->CODCFO + "00" ))
						_lGrava := .T.
					Endif
				Endif
			Endif

			If _lGrava
				_cCNPJ := Alltrim(StrTran(StrTran(StrTran(TFOR->CGCCFO,".",""),"-",""),"/",""))
				_cCod  := ''
				_cLoja := ''

				(_cAliasSA2)->(dbSetOrder(3))
				If !(_cAliasSA2)->(MsSeek(xFilial("SA2")+_cCNPJ))
					GeraFOR(_cFil,_cCNPJ,@_cCod,@_cLoja,_cAliasSA2)
				Else
					_cCod  := (_cAliasSA2)->A2_COD
					_cLoja := (_cAliasSA2)->A2_LOJA
				Endif

				(_cAliasZF6)->(RecLock(_cAliasZF6,.T.))
				(_cAliasZF6)->ZF6_FILIAL := _cFil
				(_cAliasZF6)->ZF6_TABELA := "SA2"
				(_cAliasZF6)->ZF6_CAMPO  := "A2_COD"
				(_cAliasZF6)->ZF6_CODRM  := TFOR->CODCFO
				(_cAliasZF6)->ZF6_IDRM   := TFOR->IDCFO
				(_cAliasZF6)->ZF6_TOTVS  := _cCod+_cLoja
				(_cAliasZF6)->(MsUnLock())
			Else
				MSGINFO("Cliente Nao Cadastrado!! "+TRB->CODCFO+" NF: "+Alltrim(TRB->NUMEROMOV))
				TFOR->(dbCloseArea())
				Return(.F.)
			Endif

		Endif
	ElseIf _nOpc = 2
		(_cAliasZF6)->(dbSetOrder(1))
		If !(_cAliasZF6)->(MsSeek(xFilial("ZF6")+"SA1"+PADR("A1_COD",TAMSX3("ZF6_CAMPO")[1])+Alltrim(TRB->CODCFO)))
			// ZF6_FILIAL, ZF6_TABELA, ZF6_CAMPO, ZF6_CODRM, R_E_C_N_O_, D_E_L_E_T_

			_lGrava := .F.
			If TFOR->(MsSeek(TRB->CODCFO + STRZERO(TRB->CODCOLIGADA,2)+ "1"))
				_lGrava := .T.
			Else
				If TFOR->(MsSeek(TRB->CODCFO + STRZERO(TRB->CODCOLIGADA,2)) )
					_lGrava := .T.
				Else
					If TFOR->(MsSeek(TRB->CODCFO + "0" ))
						_lGrava := .T.
					Endif
				Endif
			Endif

			If _lGrava
				_cCNPJ := Alltrim(StrTran(StrTran(StrTran(TFOR->CGCCFO,".",""),"-",""),"/",""))
				_cCod  := ''
				_cLoja := ''

				(_cAliasSA1)->(dbSetOrder(3))
				If !(_cAliasSA1)->(MsSeek(xFilial("SA1")+_cCNPJ))
					GeraCli(_cFil,_cCNPJ,@_cCod,@_cLoja,_cAliasSA1)
				Else
					_cCod  := (_cAliasSA1)->A1_COD
					_cLoja := (_cAliasSA1)->A1_LOJA
				Endif

				(_cAliasZF6)->(RecLock(_cAliasZF6,.T.))
				(_cAliasZF6)->ZF6_FILIAL := _cFil
				(_cAliasZF6)->ZF6_TABELA := "SA1"
				(_cAliasZF6)->ZF6_CAMPO  := "A1_COD"
				(_cAliasZF6)->ZF6_CODRM  := TFOR->CODCFO
				(_cAliasZF6)->ZF6_IDRM   := TFOR->IDCFO
				(_cAliasZF6)->ZF6_TOTVS  := _cCod+_cLoja
				(_cAliasZF6)->(MsUnLock())

			Else
				MSGINFO("Cliente Nao Cadastrado!! "+TRB->CODCFO+" NF: "+Alltrim(TRB->NUMEROMOV))
				TFOR->(dbCloseArea())
				Return(.F.)
			Endif
		Endif
	Endif

Return(Nil)



Static Function GeraFOR(_cFil,_cCNPJ,_cCod,_cLoja,_cAliasSA2)

	If TFOR->PESSOA = "J"
		(_cAliasSA2)->(dbSetOrder(3))
		If (_cAliasSA2)->(MsSeek(xFilial("SA2")+Left(_cCNPJ,8)))
			_cCod := (_cAliasSA2)->A2_COD
		Endif
	Endif

	GetNxtA2(@_cCod,@_cLoja)

	(_cAlias)->(RecLock(_cAlias,.T.))
	(_cAlias)->A2_COD     := _cCod
	(_cAlias)->A2_LOJA    := _cLoja
	(_cAlias)->A2_NOME    := UPPER(U_RM_NoAcento(TFOR->NOME))
	(_cAlias)->A2_NREDUZ  := UPPER(U_RM_NoAcento(TFOR->NREDUZ))
	(_cAlias)->A2_END     := UPPER(U_RM_NoAcento(Alltrim(TFOR->RUA)))+" "+UPPER(U_RM_NoAcento(ALLTRIM(TFOR->NUMERO)))
	(_cAlias)->A2_COMPLEM := UPPER(U_RM_NoAcento(Alltrim(TFOR->COMPLEM)))
	(_cAlias)->A2_TIPO    := TFOR->PESSOA
	(_cAlias)->A2_EST     := TFOR->CODETD
	(_cAlias)->A2_COD_MUN := TFOR->COD_MUN
	(_cAlias)->A2_MUN     := UPPER(U_RM_NoAcento(Alltrim(TFOR->CIDADE)))
	(_cAlias)->A2_BAIRRO  := UPPER(U_RM_NoAcento(Alltrim(TFOR->BAIRRO)))
	(_cAlias)->A2_NATUREZ := "N3002"
	(_cAlias)->A2_CEP     := StrTran(TFOR->CEP,".","")
	(_cAlias)->A2_TEL     := TFOR->TEL
	(_cAlias)->A2_PAIS    := "105"
	(_cAlias)->A2_CGC     := _cCNPJ
	(_cAlias)->A2_CONTATO := TFOR->CONTATO
	(_cAlias)->A2_INSCR   := TFOR->INSCR
	(_cAlias)->A2_CODPAIS := "01058"
	(_cAlias)->A2_EMAIL   := TFOR->EMAIL
	(_cAlias)->A2_MSBLQL  := If(TFOR->ATIVO=1,"2","1")
	(_cAlias)->A2_INSCRM  := TFOR->INSCRM
	(_cAlias)->A2_CONTRIB := If(TFOR->CONTRIB= 1,"2","1")
	(_cAlias)->A2_CONTA   := If(TFOR->CONTRIB= 1,"2","1")
	(_cAlias)->(MsUnLock())

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



Static Function GeraCli(_cFil,_cCNPJ,_cCod,_cLoja,_cAliasSA1)

	If TFOR->PESSOA = "J"
		(_cAliasSA1)->(dbSetOrder(3))
		If (_cAliasSA1)->(MsSeek(xFilial("SA1")+Left(_cCNPJ,8)))
			_cCod := (_cAliasSA1)->A1_COD
		Endif
	Endif

	GetNxtA1(@_cCod,@_cLoja)

	_cCfop:= Left(StrTran(TRB->CODNAT,".",""),4)


	(_cAliasSA1)->(RecLock(_cAliasSA1,.T.))
	(_cAliasSA1)->A1_COD        := _cCod
	(_cAliasSA1)->A1_LOJA       := _cLoja
	(_cAliasSA1)->A1_PESSOA     := TFOR->PESSOA
	(_cAliasSA1)->A1_NOME       := UPPER(U_RM_NoAcento(TFOR->NOME))
	(_cAliasSA1)->A1_NREDUZ     := UPPER(U_RM_NoAcento(TFOR->NREDUZ))
	(_cAliasSA1)->A1_END        := UPPER(U_RM_NoAcento(Alltrim(TFOR->RUA)))+" "+UPPER(U_RM_NoAcento(ALLTRIM(TFOR->NUMERO)))
	(_cAliasSA1)->A1_COMPLEM    := UPPER(U_RM_NoAcento(Alltrim(TFOR->COMPLEM)))
	If Alltrim(_cCFOP ) $ "5401/5403"
		(_cAliasSA1)->A1_TIPO       := "S"
	Else
		(_cAliasSA1)->A1_TIPO       := "R"
	Endif

	(_cAliasSA1)->A1_EST        := TFOR->CODETD
	(_cAliasSA1)->A1_COD_MUN    := TFOR->COD_MUN
	(_cAliasSA1)->A1_MUN        := UPPER(U_RM_NoAcento(Alltrim(TFOR->CIDADE)))
	(_cAliasSA1)->A1_BAIRRO     := UPPER(U_RM_NoAcento(Alltrim(TFOR->BAIRRO)))
	(_cAliasSA1)->A1_NATUREZ    := "N1001"
	(_cAliasSA1)->A1_CEP        := StrTran(TFOR->CEP,".","")
	(_cAliasSA1)->A1_TEL        := TFOR->TELEFONE
	(_cAliasSA1)->A1_PAIS       := "105"
	(_cAliasSA1)->A1_CGC        := _cCNPJ
	(_cAliasSA1)->A1_CONTATO    := TFOR->CONTATO
	(_cAliasSA1)->A1_INSCR      := IIF (Empty(TFOR->INSCR),"ISENTO",TFOR->INSCR)
	(_cAliasSA1)->A1_CODPAIS    := "01058"
	(_cAliasSA1)->A1_SATIV1     := "1"
	(_cAliasSA1)->A1_SATIV2     := "1"
	(_cAliasSA1)->A1_SATIV3     := "1"
	(_cAliasSA1)->A1_SATIV4     := "1"
	(_cAliasSA1)->A1_SATIV5     := "1"
	(_cAliasSA1)->A1_SATIV6     := "1"
	(_cAliasSA1)->A1_SATIV7     := "1"
	(_cAliasSA1)->A1_SATIV8     := "1"
	(_cAliasSA1)->A1_EMAIL      := TFOR->EMAIL
	(_cAliasSA1)->A1_EMAILNF    := TFOR->EMAIL
	(_cAliasSA1)->A1_MSBLQL     := If(TFOR->ATIVO=1,"2","1")
	(_cAliasSA1)->A1_LC         := TFOR->LC
	(_cAliasSA1)->A1_INSCRM     := TFOR->INSCRM
	(_cAliasSA1)->A1_CONTRIB    := If(TFOR->CONTRIB=1,"2","1")
	(_cAliasSA1)->A1_XNOMV      := "."
	(_cAliasSA1)->A1_CONTA      := "10102020000001"
	(_cAliasSA1)->A1_YTPCLI     := "1"
	(_cAliasSA1)->A1_YCTARA     := "20101150000002"
	(_cAliasSA1)->A1_COND       := "001"
	(_cAliasSA1)->(MsUnLock())


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



Static Function ECO15_03(_cEmp,_cFil,_cFilRM) //SE2

	Local _aArea     := GetArea()
	Local _aAreaSA2  := SA2->( GetArea() )
	Local _aAreaSA6  := SA6->( GetArea() )
	Local _aAreaZF6  := ZF6->( GetArea() )
	Local _aAreaSE2  := SE2->( GetArea() )
	Local _cAliasSA2 := ''
	Local _cAliasSA6 := ''
	Local _cAliasZF6 := ''
	Local _cAliasSE2 := ''
	Local _cModo
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _lOutSA2   := .F.
	Local _lOutSA6   := .F.
	Local _lOutZF6   := .F.
	Local _lOutSE2   := .F.

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	Endif

	_cQry := " SELECT CODFILIAL AS FILIAL,DATAVENCIMENTO AS DTVENC, * FROM  [10.140.1.5].[CorporeRM].dbo.FLAN A " + CRLF
	_cQry += " WHERE RTRIM(A.CODCOLIGADA)+RTRIM(A.CODFILIAL) IN ('"+_cFilRM+"') " + CRLF
	_cQry += " AND PAGREC = '2' " + CRLF
	_cQry += " AND LEFT(CONVERT(char(15), A.DATAEMISSAO, 23),4) + " +CRLF
	_cQry += " SUBSTRING(CONVERT(char(15), A.DATAEMISSAO, 23),6,2) + " +CRLF
	_cQry += " SUBSTRING(CONVERT(char(15), A.DATAEMISSAO, 23),9,2) " +CRLF
	_cQry += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + CRLF
	// _cQry += " AND NOT EXISTS(SELECT * FROM [10.140.1.5].[CorporeRM].dbo.TMOV T WHERE T.CODCOLIGADA = A.CODCOLIGADA And T.IDMOV = A.IDMOV) " + CRLF
	_cQry += " ORDER BY CODCOLIGADA,CODFILIAL " + CRLF

	Memowrite("D:\_Temp\ECO015B.txt",_cQry)

	TcQuery _cQry New Alias "TRB"

	_nReg := Contar("TRB","!EOF()")

	_cTabSE2:=  "SE2"+_cEmp+"0"
	If Alltrim(cEmpAnt) = _cEmp
		_cAliasSA2 := "SA2"
		_cAliasSA6 := "SA6"
		_cAliasZF6 := "ZF6"
		_cAliasSE2 := "SE2"
	Else
		If EmpOpenFile("TSA2","SA2",1,.T., _cEmp,@_cModo)
			_cAliasSA2  := "TSA2"
			_lOutSA2 := .T.
		Endif
		If EmpOpenFile("TSA6","SA6",1,.T., _cEmp,@_cModo)
			_cAliasSA6 := "TSA6"
			_lOutSA6 := .T.
		Endif
		If EmpOpenFile("TZF6","ZF6",1,.T., _cEmp,@_cModo)
			_cAliasZF6  := "TZF6"
			_lOutZF6 := .T.
		Endif
		If EmpOpenFile("TSE2","SE2",1,.T., _cEmp,@_cModo)
			_cAliasSE2  := "TSE2"
			_lOutSE2 := .T.
		Endif
	Endif

	If !Empty(_cAliasSA2) .And. !Empty(_cAliasSA6) .And. !Empty(_cAliasZF6) .And. !Empty(_cAliasSE2)

		//Exclui daddos da tabela SE2
		_cUpd := " DELETE "+_cTabSE2+ " FROM "+_cTabSE2+" WHERE E2_FILIAL = '"+_cFil+"' "
		_cUpd += " AND E2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
		// _cUpd += " AND E2_TIPO <> 'NF' "

		TCSQLEXEC(_cUpd )

		TRB->(dbGoTop())

		While TRB->(!EOF())

			_cKey1   := Alltrim(cValToChar(TRB->CODCOLIGADA))
			While TRB->(!EOF())  .And. _cKey1 == Alltrim(cValToChar(TRB->CODCOLIGADA))

				//Verifica se o Cliente está cadastrado na tabela ZF6, que relaciona o código RM X Protheus
				_lRet := CheckZF6(2,_cFil,_cAliasZF6,_cAliasSA2)

				If !_lRet
					Return(Nil)
				Endif

				_cNomFor   := ''
				_cCodFor   := Left((_cAliasZF6)->ZF6_TOTVS,6)
				_cLojFor   := Substr((_cAliasZF6)->ZF6_TOTVS,7,2)

				(_cAliasSA2)->(dbSetOrder(1))
				If (_cAliasSA2)->(MsSeek(xFilial("SA2")+_cCodFor+_cLojFor))
					_cNomFor := (_cAliasSA2)->A2_NREDUZ
					_cUF	 := (_cAliasSA2)->A2_EST
					_cTpFor  := (_cAliasSA2)->A2_TIPO
				Endif

				(_cAliasSE2)->(RecLock(_cAliasSE2,.T.))
				(_cAliasSE2)->E2_FILIAL    := _cFil
				(_cAliasSE2)->E2_PREFIXO   := _F1SERIE
				(_cAliasSE2)->E2_NUM       := _F1DOC

				_cParcela := UPPER(Alltrim(TRB->PARCELA))

				If Empty(_cParcela)
					_nAt := At("-",Alltrim(TRB->NUMERODOCUMENTO))
					If _nAt > 0
						_cParcela := Substr(TRB->NUMERODOCUMENTO,_nAt+1)
					Else
						If Len(TRB->NUMERODOCUMENTO) > 9
							_cParcela := Substr(TRB->NUMERODOCUMENTO,10)
						Endif
					Endif
				Endif

				(_cAliasSE2)->E2_PARCELA   := _cParcela
				(_cAliasSE2)->E2_TIPO      := "NF"
				// (_cAliasSE2)->E2_NATUREZ   := ??
				// (_cAliasSE2)->E2_PORTADO   := (TRB->CNABBANCO)
				// (_cAliasSE2)->E2_AGEDEP    := ??

				(_cAliasSE2)->E2_FORNECE    := _cCodFor
				(_cAliasSE2)->E2_LOJA       := _cLojFor
				(_cAliasSE2)->E2_NOMFOR     := _cNomFor

				(_cAliasSE2)->E2_EMISSAO    := TRB->DATAEMISSAO
				(_cAliasSE2)->E2_EMIS1      := TRB->DATAEMISSAO

				(_cAliasSE2)->E2_VENCTO     := TRB->DTVENC
				(_cAliasSE2)->E2_VENCREA    := TRB->DTVENC
				(_cAliasSE2)->E2_VENCORI    := TRB->DTVENC
				(_cAliasSE2)->E2_BAIXA      := TRB->DATABAIXA

				(_cAliasSE2)->E2_VALOR      := TRB->VALOR
				(_cAliasSE2)->E2_VLCRUZ     := TRB->VALOR
				(_cAliasSE2)->E2_CODBAR     := TRB->CODIGOBARRA
				(_cAliasSE2)->E2_BASEIRF    := TRB->VALORBASEIRRF
				(_cAliasSE2)->E2_IRRF       := TRB->VALORIRRF
				(_cAliasSE2)->E2_VALLIQ     := TRB->VALOR + TRB->JUROS + TRB->MULTA - TRB->DESCONTO
				(_cAliasSE2)->E2_JUROS      := TRB->JUROS
				(_cAliasSE2)->E2_MULTA      := TRB->MULTA
				(_cAliasSE2)->E2_DESCONT    := TRB->DESCONTO
				(_cAliasSE2)->E2_MOEDA      := 1

				(_cAliasSE2)->E2_HIST       := TRB->HISTORICO
				(_cAliasSE2)->E2_SALDO      := If(TRB->VLBAIXA >= TRB->VALOR, 0 , TRB->VALOR - TRB->VLBAIXA)

				(_cAliasSE2)->E2_MODSPB     := "1"
				(_cAliasSE2)->E2_DESDOBR    := "2"
				(_cAliasSE2)->E2_PROJPMS    := "2"
				(_cAliasSE2)->E2_MULTNAT    := "2"

				(_cAliasSE2)->(MsUnLock())

				TRB->(dbSkip())
			EndDo
		EndDo

		cFilAnt := _cSvFilAnt
		cEmpAnt := _cSvEmpAnt

		RestArea( _aAreaSA2 )
		RestArea( _aAreaSA1 )
		RestArea( _aAreaZF6 )
		RestArea( _aAreaSF4 )
		RestArea( _aAreaSE2 )

		RestArea( _aArea )

	Endif

	If _lOutSB1
		TSB1->(dbCloseArea())
	ENDIF
	If _lOutSA2
		TSA2->(dbCloseArea())
	ENDIF
	If _lOutSA1
		TSA1->(dbCloseArea())
	ENDIF
	If _lOutZF6
		TZF6->(dbCloseArea())
	ENDIF
	If _lOutSE2
		TSE2->(dbCloseArea())
	ENDIF

	TRB->(dbCloseArea())

Return(Nil)



Static Function ECO15_04(_cEmp,_cFil,_cFilRM) //SE5

	Local _aArea     := GetArea()
	Local _aAreaSA2  := SA2->( GetArea() )
	Local _aAreaSA1  := SA1->( GetArea() )
	Local _aAreaSA6  := SA6->( GetArea() )
	Local _aAreaZF6  := ZF6->( GetArea() )
	Local _aAreaSE2  := SE2->( GetArea() )
	Local _aAreaSE1  := SE1->( GetArea() )
	Local _aAreaSE5  := SE5->( GetArea() )
	Local _cAliasSA2 := ''
	Local _cAliasSA1 := ''
	Local _cAliasSA6 := ''
	Local _cAliasZF6 := ''
	Local _cAliasSE2 := ''
	Local _cAliasSE1 := ''
	Local _cAliasSE5 := ''
	Local _cModo
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _lOutSA2   := .F.
	Local _lOutSA1   := .F.
	Local _lOutSA6   := .F.
	Local _lOutZF6   := .F.
	Local _lOutSE2   := .F.
	Local _lOutSE1   := .F.
	Local _lOutSE5   := .F.

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	Endif

	_cQry := " SELECT * FROM [10.140.1.5].[CorporeRM].dbo.FLANBAIXA A " + CRLF
	_cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.FLAN B ON A.IDLAN = B.IDLAN AND A.CODCOLIGADA = B.CODCOLIGADA " + CRLF
	_cQry += " WHERE RTRIM(A.CODCOLIGADA)+RTRIM(A.CODFILIAL) IN ('"+_cFilRM+"') " + CRLF
	_cQry += " AND LEFT(CONVERT(char(15), A.DATABAIXA, 23),4) + " + CRLF
	_cQry += " SUBSTRING(CONVERT(char(15), A.DATABAIXA, 23),6,2) + " + CRLF
	_cQry += " SUBSTRING(CONVERT(char(15), A.DATABAIXA, 23),9,2) " + CRLF
	_cQry += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + CRLF
	_cQry += " ORDER BY CODCOLIGADA,CODFILIAL " + CRLF

	Memowrite("D:\_Temp\ECO015C.txt",_cQry)

	TcQuery _cQry New Alias "TRB"

	_nReg := Contar("TRB","!EOF()")

	_cTabSE5:=  "SE5"+_cEmp+"0"
	If Alltrim(cEmpAnt) = _cEmp
		_cAliasSA2 := "SA2"
		_cAliasSA6 := "SA6"
		_cAliasZF6 := "ZF6"
		_cAliasSE2 := "SE2"
		_cAliasSE1 := "SE1"
		_cAliasSE5 := "SE5"
	Else
		If EmpOpenFile("TSA2","SA2",1,.T., _cEmp,@_cModo)
			_cAliasSA2  := "TSA2"
			_lOutSA2 := .T.
		Endif
		If EmpOpenFile("TSA6","SA6",1,.T., _cEmp,@_cModo)
			_cAliasSA6 := "TSA6"
			_lOutSA6 := .T.
		Endif
		If EmpOpenFile("TZF6","ZF6",1,.T., _cEmp,@_cModo)
			_cAliasZF6  := "TZF6"
			_lOutZF6 := .T.
		Endif
		If EmpOpenFile("TSE1","SE1",1,.T., _cEmp,@_cModo)
			_cAliasSE1  := "TSE1"
			_lOutSE1 := .T.
		Endif
		If EmpOpenFile("TSE2","SE2",1,.T., _cEmp,@_cModo)
			_cAliasSE2  := "TSE2"
			_lOutSE2 := .T.
		Endif
		If EmpOpenFile("TSE5","SE5",1,.T., _cEmp,@_cModo)
			_cAliasSE5  := "TSE5"
			_lOutSE5 := .T.
		Endif
	Endif

	If !Empty(_cAliasSA2) .And. !Empty(_cAliasSA6) .And. !Empty(_cAliasZF6) .And. !Empty(_cAliasSE1) .And. !Empty(_cAliasSE2) .And. !Empty(_cAliasSE5)

		//Exclui daddos da tabela SE5
		_cUpd := " DELETE "+_cTabSE5+ " FROM "+_cTabSE5+" WHERE E5_FILIAL = '"+_cFil+"' "
		_cUpd += " AND E5_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
		// _cUpd += " AND E5_TIPO <> 'NF' "

		TCSQLEXEC(_cUpd )
		TRB->(dbGoTop())

		While TRB->(!EOF())

			_cKey1   := Alltrim(cValToChar(TRB->CODCOLIGADA))
			While TRB->(!EOF())  .And. _cKey1 == Alltrim(cValToChar(TRB->CODCOLIGADA))

				//Verifica se o Cliente está cadastrado na tabela ZF6, que relaciona o código RM X Protheus
				// _lRet := CheckZF6(2,_cFil,_cAliasZF6,_cAliasSA2)

				// If !_lRet
				// 	Return(Nil)
				// Endif

				_cNomFor   := ''
				_cCodFor   := Left((_cAliasZF6)->ZF6_TOTVS,6)
				_cLojFor   := Substr((_cAliasZF6)->ZF6_TOTVS,7,2)

				(_cAliasSA2)->(dbSetOrder(1))
				If (_cAliasSA2)->(MsSeek(xFilial("SA2")+_cCodFor+_cLojFor))
					_cNomFor := (_cAliasSA2)->A2_NREDUZ
					_cUF	 := (_cAliasSA2)->A2_EST
					_cTpFor  := (_cAliasSA2)->A2_TIPO
				Endif

				(_cAliasSE5)->(RecLock(_cAliasSE5,.T.))
				(_cAliasSE5)->E2_FILIAL    := _cFil
				(_cAliasSE5)->E2_PREFIXO   := _F1SERIE
				(_cAliasSE5)->E2_NUM       := _F1DOC

				_cParcela := UPPER(Alltrim(TRB->PARCELA))

				If Empty(_cParcela)
					_nAt := At("-",Alltrim(TRB->NUMERODOCUMENTO))
					If _nAt > 0
						_cParcela := Substr(TRB->NUMERODOCUMENTO,_nAt+1)
					Else
						If Len(TRB->NUMERODOCUMENTO) > 9
							_cParcela := Substr(TRB->NUMERODOCUMENTO,10)
						Endif
					Endif
				Endif

				(_cAliasSE5)->E2_PARCELA   := _cParcela
				(_cAliasSE5)->E2_TIPO      := "NF"
				// (_cAliasSE5)->E2_NATUREZ   := ??
				// (_cAliasSE5)->E2_PORTADO   := (TRB->CNABBANCO)
				// (_cAliasSE5)->E2_AGEDEP    := ??

				(_cAliasSE5)->E2_FORNECE    := _cCodFor
				(_cAliasSE5)->E2_LOJA       := _cLojFor
				(_cAliasSE5)->E2_NOMFOR     := _cNomFor

				(_cAliasSE5)->E2_EMISSAO    := TRB->DATAEMISSAO
				(_cAliasSE5)->E2_EMIS1      := TRB->DATAEMISSAO

				(_cAliasSE5)->E2_VENCTO     := TRB->DTVENC
				(_cAliasSE5)->E2_VENCREA    := TRB->DTVENC
				(_cAliasSE5)->E2_VENCORI    := TRB->DTVENC
				(_cAliasSE5)->E2_BAIXA      := TRB->DATABAIXA

				(_cAliasSE5)->E2_VALOR      := TRB->VALOR
				(_cAliasSE5)->E2_VLCRUZ     := TRB->VALOR
				(_cAliasSE5)->E2_CODBAR     := TRB->CODIGOBARRA
				(_cAliasSE5)->E2_BASEIRF    := TRB->VALORBASEIRRF
				(_cAliasSE5)->E2_IRRF       := TRB->VALORIRRF
				(_cAliasSE5)->E2_VALLIQ     := TRB->VALOR + TRB->JUROS + TRB->MULTA - TRB->DESCONTO
				(_cAliasSE5)->E2_JUROS      := TRB->JUROS
				(_cAliasSE5)->E2_MULTA      := TRB->MULTA
				(_cAliasSE5)->E2_DESCONT    := TRB->DESCONTO
				(_cAliasSE5)->E2_MOEDA      := 1

				(_cAliasSE5)->E2_HIST       := TRB->HISTORICO
				(_cAliasSE5)->E2_SALDO      := If(TRB->VLBAIXA >= TRB->VALOR, 0 , TRB->VALOR - TRB->VLBAIXA)

				(_cAliasSE5)->E2_MODSPB     := "1"
				(_cAliasSE5)->E2_DESDOBR    := "2"
				(_cAliasSE5)->E2_PROJPMS    := "2"
				(_cAliasSE5)->E2_MULTNAT    := "2"

				(_cAliasSE5)->(MsUnLock())

				TRB->(dbSkip())
			EndDo
		EndDo

		cFilAnt := _cSvFilAnt
		cEmpAnt := _cSvEmpAnt

		RestArea( _aAreaSA2 )
		RestArea( _aAreaSA1 )
		RestArea( _aAreaZF6 )
		RestArea( _aAreaSF4 )
		RestArea( _aAreaSE1 )
		RestArea( _aAreaSE2 )
		RestArea( _aAreaSE5 )

		RestArea( _aArea )

	Endif

	If _lOutSB1
		TSB1->(dbCloseArea())
	ENDIF
	If _lOutSA2
		TSA2->(dbCloseArea())
	ENDIF
	If _lOutSA1
		TSA1->(dbCloseArea())
	ENDIF
	If _lOutZF6
		TZF6->(dbCloseArea())
	ENDIF
	If _lOutSE1
		TSE1->(dbCloseArea())
	ENDIF
	If _lOutSE2
		TSE2->(dbCloseArea())
	ENDIF
	If _lOutSE5
		TSE5->(dbCloseArea())
	ENDIF

	TRB->(dbCloseArea())

Return(Nil)


