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

	Private _cColigada := ''

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	Endif


	// _cQry := " SELECT A.CODCOLIGADA AS COLIGADA,A.CODFILIAL AS FILIAL,A.SERIEDOCUMENTO AS SERIE, A.NUMERODOCUMENTO AS DOCUMENTO,A.PARCELA,A.DATAEMISSAO AS EMISSAO,A.CODCFO, " + CRLF
	_cQry := " SELECT RIGHT('00'+RTRIM(CAST(A.CODCOLIGADA AS CHAR(02))),2) AS COLIGADA,A.CODFILIAL AS FILIAL,A.SERIEDOCUMENTO AS SERIE, A.NUMERODOCUMENTO AS DOCUMENTO,A.PARCELA,A.DATAEMISSAO AS EMISSAO,CAST(A.CODCFO AS CHAR(07)) AS CODCFO, " + CRLF
	_cQry += " A.DATAVENCIMENTO AS DTVENC,A.DATABAIXA,A.VALORORIGINAL AS VALOR,A.CODIGOBARRA AS CODBARRA,A.VALORBASEIRRF AS VLRBSIRRF,A.VALORIRRF,A.VALORJUROS AS JUROS, " + CRLF
	_cQry += " A.VALORMULTA AS MULTA,A.VALORDESCONTO AS DESCONTO,A.HISTORICO,A.VALORBAIXADO AS VLBAIXA,COALESCE(T.IDMOV,'') AS TMOV,A.IDLAN " + CRLF
	_cQry += " FROM  [10.140.1.5].[CorporeRM].dbo.FLAN A " + CRLF
	_cQry += " LEFT JOIN [10.140.1.5].[CorporeRM].dbo.TMOV T ON T.CODCOLIGADA = A.CODCOLIGADA And T.IDMOV = A.IDMOV " + CRLF
	_cQry += " WHERE RTRIM(A.CODCOLIGADA)+RTRIM(A.CODFILIAL) IN ('"+_cFilRM+"') " + CRLF
	_cQry += " AND PAGREC = '1' " + CRLF
	_cQry += " AND LEFT(CONVERT(char(15), A.DATAEMISSAO, 23),4) + " +CRLF
	_cQry += " SUBSTRING(CONVERT(char(15), A.DATAEMISSAO, 23),6,2) + " +CRLF
	_cQry += " SUBSTRING(CONVERT(char(15), A.DATAEMISSAO, 23),9,2) " +CRLF
	_cQry += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + CRLF
	// _cQry += " AND NOT EXISTS(SELECT * FROM [10.140.1.5].[CorporeRM].dbo.TMOV T WHERE T.COLIGADA = A.COLIGADA And T.IDMOV = A.IDMOV) " + CRLF
	_cQry += " ORDER BY COLIGADA,FILIAL " + CRLF

	Memowrite("D:\_Temp\ECO015A.txt",_cQry)

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

			_cKey1   := TRB->COLIGADA
			While TRB->(!EOF())  .And. _cKey1 == TRB->COLIGADA

				//Verifica se o Cliente está cadastrado na tabela ZF6, que relaciona o código RM X Protheus
				_lRet := CheckZF6(2,_cFil,_cAliasZF6,,_cAliasSA1)

				If !_lRet
					Return(Nil)
				Endif

				_cNomCli   := ''
				_cCodCli   := Left((_cAliasZF6)->ZF6_TOTVS,6)
				_cLojCli   := Substr((_cAliasZF6)->ZF6_TOTVS,7,2)
				_cTipo     := If(!Empty(TRB->TMOV),"NF","FT")
				_cPref     := If(Alltrim(TRB->SERIE) = '@@@','',Alltrim(TRB->SERIE))

				(_cAliasSA1)->(dbSetOrder(1))
				If (_cAliasSA1)->(MsSeek(xFilial("SA1")+_cCodCli+_cLojCli))
					_cNomCli := (_cAliasSA1)->A1_NREDUZ
					_cUF	 := (_cAliasSA1)->A1_EST
					_cTpCli  := (_cAliasSA1)->A1_TIPO
				Endif

				(_cAliasSE1)->(RecLock(_cAliasSE1,.T.))
				(_cAliasSE1)->E1_YNROTRM   := Alltrim(TRB->DOCUMENTO)+If(!Empty(TRB->PARCELA),' | '+Alltrim(TRB->PARCELA),'')
				(_cAliasSE1)->E1_FILIAL    := _cFil
				(_cAliasSE1)->E1_PREFIXO   := _cPref

				_aNumParc := GetNumParc("E1",_cFil,_cCodCli,_cLojCli,_cTipo,_cPref,TRB->DOCUMENTO,TRB->PARCELA)

				(_cAliasSE1)->E1_NUM       := _aNumParc[1]
				(_cAliasSE1)->E1_PARCELA   := _aNumParc[2]
				(_cAliasSE1)->E1_TIPO      := _cTipo
				(_cAliasSE1)->E1_NATUREZ   := "N1001"
				// (_cAliasSE1)->E1_PORTADO   := (TRB->CNABBANCO)
				// (_cAliasSE1)->E1_AGEDEP    := ??

				(_cAliasSE1)->E1_CLIENTE    := _cCodCli
				(_cAliasSE1)->E1_LOJA       := _cLojCli
				(_cAliasSE1)->E1_NOMCLI     := _cNomCli

				(_cAliasSE1)->E1_EMISSAO    := TRB->EMISSAO
				(_cAliasSE1)->E1_EMIS1      := TRB->EMISSAO

				(_cAliasSE1)->E1_VENCTO     := TRB->DTVENC
				(_cAliasSE1)->E1_VENCREA    := TRB->DTVENC
				(_cAliasSE1)->E1_VENCORI    := TRB->DTVENC
				(_cAliasSE1)->E1_BAIXA      := TRB->DATABAIXA

				(_cAliasSE1)->E1_VALOR      := TRB->VALOR
				(_cAliasSE1)->E1_VLCRUZ     := TRB->VALOR
				(_cAliasSE1)->E1_CODBAR     := TRB->CODBARRA
				(_cAliasSE1)->E1_BASEIRF    := TRB->VLRBSIRRF
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

				(_cAliasSE1)->E1_IDRM       := Alltrim(Str(Val(TRB->COLIGADA)))+Alltrim(Str(TRB->FILIAL))+Alltrim(Str(TRB->IDLAN))

				(_cAliasSE1)->(MsUnLock())

				TRB->(dbSkip())
			EndDo
		EndDo

		cFilAnt := _cSvFilAnt
		cEmpAnt := _cSvEmpAnt

		RestArea( _aAreaSA1 )
		RestArea( _aAreaSA6 )
		RestArea( _aAreaZF6 )
		RestArea( _aAreaSE1 )

		RestArea( _aArea )

	Endif


	If _lOutSA1
		TSA1->(dbCloseArea())
	ENDIF
	If _lOutSA6
		TSA6->(dbCloseArea())
	ENDIF
	If _lOutZF6
		TZF6->(dbCloseArea())
	ENDIF
	If _lOutSE1
		TSE1->(dbCloseArea())
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

	Local _lRet2 := .T.

	DEFAULT _cAliasSA2 := ''
	DEFAULT _cAliasSA1 := ''

	If _nOpc = 1
		_lGrava := .T.

		(_cAliasZF6)->(dbSetOrder(1))
		If !(_cAliasZF6)->(MsSeek(xFilial("ZF6")+"SA2"+PADR("A2_COD",TAMSX3("ZF6_CAMPO")[1])+Alltrim(TRB->CODCFO)))

			If _lGrava
				_cCNPJ := Alltrim(StrTran(StrTran(StrTran(TFOR->CGCCFO,".",""),"-",""),"/",""))
				_cCod  := ''
				_cLoja := ''

				// 00 F000267 - PIS
				// 00 F000268 - COFINS
				// 00 F04463 - CSLL
				// 09 F00445 - CSLL
				// 09 F00446 - IRPJ
				// 11 F00197 - CSLL
				// 11 F00400 - CSLL
				// 11 F00399 - IRPJ

				If (_cColigada = "00" .And. Alltrim(TFOR->CODCFO) $ "F000267|F000268|F04463") .Or.;
						(_cColigada = "09" .And. Alltrim(TFOR->CODCFO) $ "F00445|F00446") .Or.;
						(_cColigada = "11" .And. Alltrim(TFOR->CODCFO) $ "F00197|F00400|F00399")

					_cCod  := "UNIAO "
					_cLoja := "00"
				ElseIf Alltrim(TFOR->CODCFO) $ 'F000237|F000225|F000226|F000250|F000280|F000281|F000282|F000299|F000306|F000307|F000339|F000340|F000341|F00310|F00313|F00319|'
					_cCod  := "SALARI"
					_cLoja := "00"
				ElseIf Alltrim(TFOR->CODCFO) $ 'F000256|F000287|F000288|F000289|F000290|F00312'
					_cCod  := "FGTS  "
					_cLoja := "00"
				ElseIf Alltrim(TFOR->CODCFO) $ 'F000163|F000291|F000292|F000293|F000294|F00226|F00314'
					_cCod  := "INSS  "
					_cLoja := "00"
				ElseIf Alltrim(TFOR->CODCFO) $ 'F000164|F03591'
					_cCod  := "IRRF  "
					_cLoja := "00"
				Else
					(_cAliasSA2)->(dbSetOrder(3))
					If !(_cAliasSA2)->(MsSeek(xFilial("SA2")+_cCNPJ))
						GeraFOR(_cFil,_cCNPJ,@_cCod,@_cLoja,_cAliasSA2)
					Else
						_cCod  := (_cAliasSA2)->A2_COD
						_cLoja := (_cAliasSA2)->A2_LOJA
					Endif
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
				MSGINFO("Fornecedor Nao Cadastrado!! "+TRB->CODCFO+" NF: "+Alltrim(TRB->DOCUMENTO))
				TFOR->(dbCloseArea())
				Return(.F.)
			Endif
		Endif
	ElseIf _nOpc = 2
		(_cAliasZF6)->(dbSetOrder(1))
		If !(_cAliasZF6)->(MsSeek(xFilial("ZF6")+"SA1"+PADR("A1_COD",TAMSX3("ZF6_CAMPO")[1])+Alltrim(TRB->CODCFO)))
			// ZF6_FILIAL, ZF6_TABELA, ZF6_CAMPO, ZF6_CODRM, R_E_C_N_O_, D_E_L_E_T_

			_lGrava := .F.
			If TFOR->(MsSeek(TRB->CODCFO + TRB->COLIGADA + "1"))
				_lGrava := .T.
			Else
				If TFOR->(MsSeek(TRB->CODCFO + TRB->COLIGADA) )
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
				MSGINFO("Cliente Nao Cadastrado!! "+TRB->CODCFO+" NF: "+Alltrim(TRB->DOCUMENTO))
				TFOR->(dbCloseArea())
				Return(.F.)
			Endif
		Endif
	Endif

Return(_lRet2)



Static Function GeraFOR(_cFil,_cCNPJ,_cCod,_cLoja,_cAliasSA2)

	If TFOR->PESSOA = "J"
		(_cAliasSA2)->(dbSetOrder(3))
		If (_cAliasSA2)->(MsSeek(xFilial("SA2")+Left(_cCNPJ,8)))
			_cCod := (_cAliasSA2)->A2_COD
		Endif
	Endif

	GetNxtA2(@_cCod,@_cLoja)

	(_cAliasSA2)->(RecLock(_cAliasSA2,.T.))
	(_cAliasSA2)->A2_COD     := _cCod
	(_cAliasSA2)->A2_LOJA    := _cLoja
	(_cAliasSA2)->A2_NOME    := UPPER(U_RM_NoAcento(TFOR->NOME))
	(_cAliasSA2)->A2_NREDUZ  := UPPER(U_RM_NoAcento(TFOR->NREDUZ))
	(_cAliasSA2)->A2_END     := UPPER(U_RM_NoAcento(Alltrim(TFOR->RUA)))+" "+UPPER(U_RM_NoAcento(ALLTRIM(TFOR->NUMERO)))
	(_cAliasSA2)->A2_COMPLEM := UPPER(U_RM_NoAcento(Alltrim(TFOR->COMPLEM)))
	(_cAliasSA2)->A2_TIPO    := TFOR->PESSOA
	(_cAliasSA2)->A2_EST     := TFOR->CODETD
	(_cAliasSA2)->A2_COD_MUN := TFOR->COD_MUN
	(_cAliasSA2)->A2_MUN     := UPPER(U_RM_NoAcento(Alltrim(TFOR->CIDADE)))
	(_cAliasSA2)->A2_BAIRRO  := UPPER(U_RM_NoAcento(Alltrim(TFOR->BAIRRO)))
	(_cAliasSA2)->A2_NATUREZ := "N3002"
	(_cAliasSA2)->A2_CEP     := StrTran(TFOR->CEP,".","")
	(_cAliasSA2)->A2_TEL     := TFOR->TELEFONE
	(_cAliasSA2)->A2_PAIS    := "105"
	(_cAliasSA2)->A2_CGC     := _cCNPJ
	(_cAliasSA2)->A2_CONTATO := TFOR->CONTATO
	(_cAliasSA2)->A2_INSCR   := TFOR->INSCR
	(_cAliasSA2)->A2_CODPAIS := "01058"
	(_cAliasSA2)->A2_EMAIL   := TFOR->EMAIL
	(_cAliasSA2)->A2_MSBLQL  := If(TFOR->ATIVO=1,"2","1")
	(_cAliasSA2)->A2_INSCRM  := TFOR->INSCRM
	(_cAliasSA2)->A2_CONTRIB := If(TFOR->CONTRIB= 1,"2","1")
	(_cAliasSA2)->A2_CONTA   := If(TFOR->CONTRIB= 1,"2","1")
	(_cAliasSA2)->(MsUnLock())

RETURN(NIL)



Static Function GetNxtA2(_cCod,_cLoja)

	Local _cQrySA2 := ""

	If Empty(_cCod)

		_cQrySA2 := " SELECT MAX(A2_COD) AS COD FROM "+RetSqlName("SA2")+" A2 " +CRLF
		_cQrySA2 += " WHERE A2.D_E_L_E_T_ = '' AND A2_FILIAL = '"+xFilial("SA2")+"' " +CRLF
		_cQrySA2 += " AND A2_COD NOT IN ('UNIAO ','SALARI','FGTS  ','INSS  ','IRRF  ') " +CRLF

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

	// _cCfop:= Left(StrTran(TRB->CODNAT,".",""),4)

	(_cAliasSA1)->(RecLock(_cAliasSA1,.T.))
	(_cAliasSA1)->A1_COD        := _cCod
	(_cAliasSA1)->A1_LOJA       := _cLoja
	(_cAliasSA1)->A1_PESSOA     := TFOR->PESSOA
	(_cAliasSA1)->A1_NOME       := UPPER(U_RM_NoAcento(TFOR->NOME))
	(_cAliasSA1)->A1_NREDUZ     := UPPER(U_RM_NoAcento(TFOR->NREDUZ))
	(_cAliasSA1)->A1_END        := UPPER(U_RM_NoAcento(Alltrim(TFOR->RUA)))+" "+UPPER(U_RM_NoAcento(ALLTRIM(TFOR->NUMERO)))
	(_cAliasSA1)->A1_COMPLEM    := UPPER(U_RM_NoAcento(Alltrim(TFOR->COMPLEM)))
	// If Alltrim(_cCFOP ) $ "5401/5403"
	(_cAliasSA1)->A1_TIPO       := "S"
	// Else
	// 	(_cAliasSA1)->A1_TIPO       := "R"
	// Endif
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

	_cQry := " SELECT RIGHT('00'+RTRIM(CAST(A.CODCOLIGADA AS CHAR(02))),2) AS COLIGADA,A.CODFILIAL AS FILIAL,A.SERIEDOCUMENTO AS SERIE, A.NUMERODOCUMENTO AS DOCUMENTO,A.PARCELA,A.DATAEMISSAO AS EMISSAO,CAST(A.CODCFO AS CHAR(07)) AS CODCFO, " + CRLF
	_cQry += " A.DATAVENCIMENTO AS DTVENC,A.DATABAIXA,A.VALORORIGINAL AS VALOR,A.CODIGOBARRA AS CODBARRA,A.VALORBASEIRRF AS VLRBSIRRF,A.VALORIRRF,A.VALORJUROS AS JUROS, " + CRLF
	_cQry += " A.VALORMULTA AS MULTA,A.VALORDESCONTO AS DESCONTO,A.HISTORICO,A.VALORBAIXADO AS VLBAIXA,COALESCE(T.IDMOV,'') AS TMOV,A.IDLAN " + CRLF
	_cQry += " FROM  [10.140.1.5].[CorporeRM].dbo.FLAN A " + CRLF
	_cQry += " LEFT JOIN [10.140.1.5].[CorporeRM].dbo.TMOV T ON T.CODCOLIGADA = A.CODCOLIGADA And T.IDMOV = A.IDMOV " + CRLF
	_cQry += " WHERE RTRIM(A.CODCOLIGADA)+RTRIM(A.CODFILIAL) IN ('"+_cFilRM+"') " + CRLF
	_cQry += " AND PAGREC = '2' " + CRLF
	_cQry += " AND LEFT(CONVERT(char(15), A.DATAEMISSAO, 23),4) + " +CRLF
	_cQry += " SUBSTRING(CONVERT(char(15), A.DATAEMISSAO, 23),6,2) + " +CRLF
	_cQry += " SUBSTRING(CONVERT(char(15), A.DATAEMISSAO, 23),9,2) " +CRLF
	_cQry += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + CRLF
	// _cQry += " AND NOT EXISTS(SELECT * FROM [10.140.1.5].[CorporeRM].dbo.TMOV T WHERE T.COLIGADA = A.COLIGADA And T.IDMOV = A.IDMOV) " + CRLF
	_cQry += " ORDER BY COLIGADA,FILIAL " + CRLF

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

			_cKey1   := TRB->COLIGADA
			While TRB->(!EOF())  .And. _cKey1 == TRB->COLIGADA


				If Alltrim(Left(TRB->DOCUMENTO,9)) = '062020001'
					_lPare := .T.
				Endif

				_cColigada := TRB->COLIGADA
				If TFOR->(MsSeek(TRB->CODCFO + TRB->COLIGADA + "2"))
					_lGrava := .T.
				Else
					If TFOR->(MsSeek(TRB->CODCFO + TRB->COLIGADA ) )
						_lGrava := .T.
					Else
						If TFOR->(MsSeek(TRB->CODCFO + "00" ))
							_lGrava := .T.
							_cColigada := "00"
						Endif
					Endif
				Endif

				//Verifica se o Fornecedor está cadastrado na tabela ZF6, que relaciona o código RM X Protheus
				If _lGrava
					_lRet := CheckZF6(1,_cFil,_cAliasZF6,_cAliasSA2)
				Else
					MSGINFO("Fornecedor Nao Cadastrado!! "+TRB->CODCFO+" NF: "+Alltrim(TRB->DOCUMENTO))
					TFOR->(dbCloseArea())
					Return(.F.)
				Endif

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
				(_cAliasSE2)->E2_YNROTRM   := TRB->DOCUMENTO
				(_cAliasSE2)->E2_FILIAL    := _cFil
				(_cAliasSE2)->E2_PREFIXO   := If(Alltrim(TRB->SERIE) = '@@@','',Alltrim(TRB->SERIE))
				(_cAliasSE2)->E2_NUM       := Alltrim(Right(Alltrim(TRB->DOCUMENTO),9))

				_cTipo    := If(!Empty(TRB->TMOV),"NF","FT")
				_cParcela := UPPER(Alltrim(TRB->PARCELA))

				If Empty(_cParcela)
					_nAt := At("-",Alltrim(TRB->DOCUMENTO))
					If _nAt > 0
						_cParcela := Substr(TRB->DOCUMENTO,_nAt+1)
					Else
						If Len(TRB->DOCUMENTO) > 9
							_cParcela := Substr(TRB->DOCUMENTO,10)
						Endif
					Endif
				Endif

				// 00 F000267 - PIS
				// 00 F000268 - COFINS
				// 00 F04463 - CSLL
				// 09 F00445 - CSLL
				// 09 F00446 - IRPJ
				// 11 F00197 - CSLL
				// 11 F00400 - CSLL
				// 11 F00399 - IRPJ

				If (_cColigada = "00" .And. Alltrim(TRB->CODCFO) = "F000267") //PIS
					_cTipo    := 'TX'
					_cParcela := 'A'
				ElseIf (_cColigada = "00" .And. Alltrim(TRB->CODCFO) = "F000268") //COFINS
					_cTipo    := 'TX'
					_cParcela := 'B'
				ElseIf (_cColigada = "00" .And. Alltrim(TRB->CODCFO) = "F04463") .Or.; //CSLL
					(_cColigada = "09" .And. Alltrim(TRB->CODCFO) = "F00445") .Or.;
						(_cColigada = "11" .And. Alltrim(TRB->CODCFO) $ "F00197|F00400")
					_cTipo    := 'TX'
					_cParcela := 'C'
				ElseIf (_cColigada = "09" .And. Alltrim(TRB->CODCFO) = "F00446") .Or.; //IRPJ
					(_cColigada = "11" .And. Alltrim(TRB->CODCFO) = "F00399")
					_cTipo    := 'TX'
					_cParcela := 'D'
				Endif

				(_cAliasSE2)->E2_PARCELA   := _cParcela
				(_cAliasSE2)->E2_TIPO      := _cTipo
				// (_cAliasSE2)->E2_NATUREZ   := ??
				// (_cAliasSE2)->E2_PORTADO   := (TRB->CNABBANCO)
				// (_cAliasSE2)->E2_AGEDEP    := ??

				(_cAliasSE2)->E2_FORNECE    := _cCodFor
				(_cAliasSE2)->E2_LOJA       := _cLojFor
				(_cAliasSE2)->E2_NOMFOR     := _cNomFor

				(_cAliasSE2)->E2_EMISSAO    := TRB->EMISSAO
				(_cAliasSE2)->E2_EMIS1      := TRB->EMISSAO

				(_cAliasSE2)->E2_VENCTO     := TRB->DTVENC
				(_cAliasSE2)->E2_VENCREA    := TRB->DTVENC
				(_cAliasSE2)->E2_VENCORI    := TRB->DTVENC
				(_cAliasSE2)->E2_BAIXA      := TRB->DATABAIXA

				(_cAliasSE2)->E2_VALOR      := TRB->VALOR
				(_cAliasSE2)->E2_VLCRUZ     := TRB->VALOR
				(_cAliasSE2)->E2_CODBAR     := TRB->CODBARRA
				(_cAliasSE2)->E2_BASEIRF    := TRB->VLRBSIRRF
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

				(_cAliasSE2)->E2_IDRM       := Alltrim(Str(Val(TRB->COLIGADA)))+Alltrim(Str(TRB->FILIAL))+Alltrim(Str(TRB->IDLAN))

				(_cAliasSE2)->(MsUnLock())

				TRB->(dbSkip())
			EndDo
		EndDo

		cFilAnt := _cSvFilAnt
		cEmpAnt := _cSvEmpAnt

		RestArea( _aAreaSA2 )
		RestArea( _aAreaSA6 )
		RestArea( _aAreaZF6 )
		RestArea( _aAreaSE2 )

		RestArea( _aArea )
	Endif

	If _lOutSA2
		TSA2->(dbCloseArea())
	ENDIF
	If _lOutSA6
		TSA6->(dbCloseArea())
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

	_cQry := " SELECT  RIGHT('00'+RTRIM(CAST(A.CODCOLIGADA AS CHAR(02))),2) AS COLIGADA,A.CODFILIAL AS FILIAL,B.CODCFO,C.CODCXA,C.DESCRICAO,C.NUMBANCO,C.NUMAGENCIA,C.NROCONTA, " + CRLF
	_cQry += " A.DATABAIXA,A.VALORBAIXA,A.VALORORIGINAL,A.VALORDESCONTO,A.VALORMULTA,A.VALORJUROS,A.IDLAN " + CRLF
	_cQry += " FROM [10.140.1.5].[CorporeRM].dbo.FLANBAIXA A " + CRLF
	_cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.FLAN B ON A.IDLAN = B.IDLAN AND A.CODCOLIGADA = B.CODCOLIGADA " + CRLF
	_cQry += " LEFT JOIN [10.140.1.5].[CorporeRM].dbo.TMOV T ON T.CODCOLIGADA = A.CODCOLIGADA And T.IDMOV = B.IDMOV " + CRLF
	_cQry += " LEFT JOIN [10.140.1.5].[CorporeRM].dbo.FCXA C ON A.CODCOLCXA = C.CODCOLIGADA AND A.CODCXA = C.CODCXA " + CRLF
	_cQry += " WHERE RTRIM(A.CODCOLIGADA)+RTRIM(A.CODFILIAL) IN ('"+_cFilRM+"') " + CRLF
	_cQry += " AND A.DATACANCELBAIXA IS NULL " + CRLF
	_cQry += " AND A.PAGREC = '1' " + CRLF // RECEBER
	_cQry += " AND LEFT(CONVERT(char(15), A.DATABAIXA, 23),4) + " + CRLF
	_cQry += " SUBSTRING(CONVERT(char(15), A.DATABAIXA, 23),6,2) + " + CRLF
	_cQry += " SUBSTRING(CONVERT(char(15), A.DATABAIXA, 23),9,2) " + CRLF
	_cQry += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + CRLF
	_cQry += " ORDER BY COLIGADA,FILIAL " + CRLF

	Memowrite("D:\_Temp\ECO015C.txt",_cQry)

	TcQuery _cQry New Alias "TRB"

	_nReg := Contar("TRB","!EOF()")

	_cTabSE5:=  "SE5"+_cEmp+"0"
	If Alltrim(cEmpAnt) = _cEmp
		_cAliasSA2 := "SA2"
		_cAliasSA1 := "SA1"
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
		If EmpOpenFile("TSE2","SE2",1,.T., _cEmp,@_cModo)
			_cAliasSE2  := "TSE2"
			_lOutSE2 := .T.
		Endif
		If EmpOpenFile("TSE5","SE5",1,.T., _cEmp,@_cModo)
			_cAliasSE5  := "TSE5"
			_lOutSE5 := .T.
		Endif
	Endif

	If !Empty(_cAliasSA2) .And. !Empty(_cAliasSA2) .And. !Empty(_cAliasSA6) .And. !Empty(_cAliasZF6) .And. !Empty(_cAliasSE1) .And. !Empty(_cAliasSE2) .And. !Empty(_cAliasSE5)

		//Exclui daddos da tabela SE5
		_cUpd := " DELETE "+_cTabSE5+ " FROM "+_cTabSE5+" WHERE E5_FILIAL = '"+_cFil+"' "
		_cUpd += " AND E5_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
		// _cUpd += " AND E5_TIPO <> 'NF' "

		TCSQLEXEC(_cUpd )
		TRB->(dbGoTop())

		While TRB->(!EOF())

			_cKey1   := TRB->COLIGADA
			While TRB->(!EOF())  .And. _cKey1 == TRB->COLIGADA

				_cColigada := TRB->COLIGADA
				If TFOR->(MsSeek(TRB->CODCFO + TRB->COLIGADA + TRB->PAGREC))
					_lGrava := .T.
				Else
					If TFOR->(MsSeek(TRB->CODCFO + TRB->COLIGADA ) )
						_lGrava := .T.
					Else
						If TFOR->(MsSeek(TRB->CODCFO + "00" ))
							_lGrava := .T.
							_cColigada := "00"
						Endif
					Endif
				Endif

				//Verifica se o Fornecedor/Cliente está cadastrado na tabela ZF6, que relaciona o código RM X Protheus
				If _lGrava
					If TRB->PAGREC = "2"
						_lRet := CheckZF6(1,_cFil,_cAliasZF6,_cAliasSA2)
					ElseIf TRB->PAGREC = "1"
						_lRet := CheckZF6(2,_cFil,_cAliasZF6,,_cAliasSA1)
					Endif
				Else
					MSGINFO("Fornecedor/Cliente Nao Cadastrado!! "+TRB->CODCFO+" NF: "+Alltrim(TRB->DOCUMENTO))
					TFOR->(dbCloseArea())
					Return(.F.)
				Endif

				If !_lRet
					Return(Nil)
				Endif

				_A6COD     := Padr(TRB->NUMBANCO  ,TamSx3('A6_COD')[1])
				_A6AGENCIA := Padr(TRB->NUMAGENCIA,TamSx3('A6_AGENCIA')[1])
				_A6NUMCON  := Padr(TRB->NROCONTA  ,TamSx3('A6_NUMCON')[1])
				_A6NOME    := Padr(TRB->DESCRICAO ,TamSx3('A6_NOME')[1])

				(_cAliasSA6)->(dbSetOrder(1))
				If !(_cAliasSA6)->(MsSeek(xFilial(_cAliasSA6)+_A6COD+_A6AGENCIA+_A6NUMCON))
					(_cAliasSA6)->(RecLock(_cAliasSA6,.T.))
					(_cAliasSA6)->A6_FILIAL  := xFilial(_cAliasSA6)
					(_cAliasSA6)->A6_COD     := _A6COD
					(_cAliasSA6)->A6_AGENCIA := _A6AGENCIA
					(_cAliasSA6)->A6_NUMCON  := _A6NUMCON
					(_cAliasSA6)->A6_NOME    := _A6NOME
					(_cAliasSA6)->A6_NREDUZ  := _A6NOME
					(_cAliasSA6)->A6_MOEDA   := 1
					(_cAliasSA6)->(MsUnLock())
				Endif

				_cNomE5   := ''
				_cCodE5   := Left((_cAliasZF6)->ZF6_TOTVS,6)
				_cLojE5   := Substr((_cAliasZF6)->ZF6_TOTVS,7,2)

				// (_cAliasSA2)->(dbSetOrder(1))
				// If (_cAliasSA2)->(MsSeek(xFilial("SA2")+_cCodFor+_cLojFor))
				// 	_cNomFor := (_cAliasSA2)->A2_NREDUZ
				// 	_cUF	 := (_cAliasSA2)->A2_EST
				// 	_cTpFor  := (_cAliasSA2)->A2_TIPO
				// Endif

				// If

				(_cAliasSE5)->(RecLock(_cAliasSE5,.T.))
				(_cAliasSE5)->E5_YNROTRM :=
				(_cAliasSE5)->E5_FILIAL  := _cFil
				(_cAliasSE5)->E5_DATA    :=
				(_cAliasSE5)->E5_TIPO    :=
				(_cAliasSE5)->E5_MOEDA   :=
				(_cAliasSE5)->E5_VALOR   :=
				(_cAliasSE5)->E5_NATUREZ :=
				(_cAliasSE5)->E5_BANCO   :=
				(_cAliasSE5)->E5_AGENCIA :=
				(_cAliasSE5)->E5_CONTA   :=
				(_cAliasSE5)->E5_NUMCHEQ :=
				(_cAliasSE5)->E5_DOCUMEN :=
				(_cAliasSE5)->E5_VENCTO  :=
				(_cAliasSE5)->E5_RECPAG  :=
				(_cAliasSE5)->E5_BENEF   :=
				(_cAliasSE5)->E5_HISTOR  :=
				(_cAliasSE5)->E5_TIPODOC :=
				(_cAliasSE5)->E5_VLMOED2 :=
				(_cAliasSE5)->E5_PREFIXO :=
				(_cAliasSE5)->E5_NUMERO  :=
				(_cAliasSE5)->E5_PARCELA :=
				(_cAliasSE5)->E5_CLIFOR  :=
				(_cAliasSE5)->E5_LOJA    :=
				(_cAliasSE5)->E5_DTDIGIT :=
				(_cAliasSE5)->E5_MOTBX   :=
				(_cAliasSE5)->E5_DTDISPO :=
				(_cAliasSE5)->E5_FILORIG :=

				// _cParcela := UPPER(Alltrim(TRB->PARCELA))

				// If Empty(_cParcela)
				// 	_nAt := At("-",Alltrim(TRB->NUMERODOCUMENTO))
				// 	If _nAt > 0
				// 		_cParcela := Substr(TRB->NUMERODOCUMENTO,_nAt+1)
				// 	Else
				// 		If Len(TRB->NUMERODOCUMENTO) > 9
				// 			_cParcela := Substr(TRB->NUMERODOCUMENTO,10)
				// 		Endif
				// 	Endif
				// Endif

				// (_cAliasSE5)->E2_PARCELA   := _cParcela

				(_cAliasSE5)->E5_IDRM       := Alltrim(Str(Val(TRB->COLIGADA)))+Alltrim(Str(TRB->FILIAL))+Alltrim(Str(TRB->IDLAN))

				(_cAliasSE5)->(MsUnLock())

				TRB->(dbSkip())
			EndDo
		EndDo

		cFilAnt := _cSvFilAnt
		cEmpAnt := _cSvEmpAnt

		RestArea( _aAreaSA2 )
		RestArea( _aAreaSA1 )
		RestArea( _aAreaSA6 )
		RestArea( _aAreaZF6 )
		RestArea( _aAreaSE1 )
		RestArea( _aAreaSE2 )
		RestArea( _aAreaSE5 )

		RestArea( _aArea )

	Endif


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




Static Function GetNumParc(_cTab,_cFil,_cCodCli,_cLojCli,_cTipo,_cPref,_cDoc,_cParcAux)

	Local _aParc    := {}
	Local _cNum     := ''
	Local _cParc    := ''

	_nAt := At("-",Alltrim(_cDoc))
	If _nAt > 0
		_cNum  := Alltrim(Left(_cDoc,_nAt-1))
		_cParcAux := Substr(_cDoc,_nAt+1)
	Else
		_cNum  := Left(_cDoc,9)
		If Len(_cDoc) > 9
			_cParcAux := Substr(_cDoc,10)
		Endif
	Endif

	If !Empty(_cParcAux)
		_cParc := GetNxtParc(_cTab,_cFil,_cCodCli,_cLojCli,_cTipo,_cPref,_cDoc)
	Endif

	AAdd(_aParc,_cNum)
	AAdd(_aParc,_cParc)

Return(_aParc)



Static Function GetNxtParc(_cTab,_cFil,_cCodCli,_cLojCli,_cTipo,_cPref,_cDoc)

	Local _cParce := ''
	Local _cQryPa := ""

	_cQryPa := " SELECT MAX(E1_PARCELA) AS PARC FROM "+RetSqlName("S"+_cTab)+" "+_cTab+" " +CRLF
	_cQryPa += " WHERE "+_cTab+".D_E_L_E_T_ = '' AND "+_cTab+"_FILIAL = '"+_cFil+"'  " +CRLF
	If _cTab = "E1"
		_cQryPa += " AND "+_cTab+"."+_cTab+"_CLIENTE 	= '"+_cCodCli+"'  " +CRLF
	ElseIf _cTab = "E2"
		_cQryPa += " AND "+_cTab+"."+_cTab+"_FORNECE 	= '"+_cCodCli+"'  " +CRLF
	ElseIf _cTab = "E5"
		_cQryPa += " AND "+_cTab+"."+_cTab+"_CLIFOR 	= '"+_cCodCli+"'  " +CRLF
	Endif
	_cQryPa += " AND "+_cTab+"."+_cTab+"_LOJA 		= '"+_cLojCli+"'  " +CRLF
	_cQryPa += " AND "+_cTab+"."+_cTab+"_TIPO 		= '"+_cTipo+"'  " +CRLF
	_cQryPa += " AND "+_cTab+"."+_cTab+"_NUM 		= '"+_cDoc+"'  " +CRLF
	_cQryPa += " AND "+_cTab+"."+_cTab+"_PREFIXO 	= '"+_cPref+"'  " +CRLF

	TcQuery _cQryPa New Alias "TNEXT"

	If Contar("TNEXT","!EOF()") > 0

		TNEXT->(dbGoTop())

		_cParce := SOMA1(TNEXT->PARC)

	Else
		_cParce := '01'
	Endif

	TNEXT->(dbCloseArea())

Return(_cParce)
