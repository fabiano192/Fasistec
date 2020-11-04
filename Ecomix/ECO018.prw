#Include "Protheus.ch"
#include "topconn.ch"
#Include "RWMAKE.CH"
#Include "Xmlxfun.ch"
#include "tbiconn.ch"

/*/{Protheus.doc} ECO018
EXPORTA MOVIMENTO RH
@type function
@version 
@author Fabiano
@since 07/10/2020
@return return_type, return_description
/*/
User Function ECO018()

	ATUSX1()

	_nOpc := 0
	@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Importa Movimento RH ")
	@ 02,10 TO 080,220
	@ 10,18 SAY "Importacao do Movimento de Funcionários             "     SIZE 160,7
	@ 18,18 SAY "                                                    "     SIZE 160,7
	@ 26,18 SAY "                                                    "     SIZE 160,7
	@ 34,18 SAY "                                                    "     SIZE 160,7

	@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("ECO018")
	@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
	@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

	ACTIVATE DIALOG oDlg Centered

	Pergunte("ECO018",.F.)

	If _nOpc == 1

		Private _lFim      := .F.
		Private _cTitulo01 := 'Importando Movimento RH!!!'

		Processa( {|| ECO18_01() } , _cTitulo01, "Processando ...",.T.)
	Endif

Return (Nil)



Static Function ECO18_01()

	Local AX
    Local _cQry2 := ''

	// _cQry2 := " SELECT * FROM  [10.140.1.5].[CorporeRM].dbo.PFUNC A (NOLOCK) " + CRLF
	// _cQry2 += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.PPESSOA B (NOLOCK) ON A.CODPESSOA = B.CODIGO " + CRLF
	// _cQry2 += " ORDER BY CODCOLIGADA,CHAPA " + CRLF

    _cQry2 += " SELECT A.CODCOLIGADA AS COLIGADA, A.CHAPA, B.NOME,B.NOMESOCIAL,B.CPF,A.PISPASEP,B.CARTIDENTIDADE AS RG,B.ORGEMISSORIDENT AS RGORG, B.UFCARTIDENT AS RGUF, B.DTEMISSAOIDENT AS RGEMI,  " + CRLF
    _cQry2 += " B.CARTEIRATRAB AS CP,B.SERIECARTTRAB AS CPSER,B.UFCARTTRAB AS CPUF,B.DTCARTTRAB AS CPDT,B.CARTMOTORISTA AS CNH,B.TIPOCARTHABILIT AS CNHTP,B.DTVENCHABILIT AS CNHVCTO, " + CRLF
    _cQry2 += " B.DTEMISSAOCNH AS CNHEMI,B.ORGEMISSORCNH AS CNHORI, B.UFCNH AS CNHUF,B.CERTIFRESERV AS RESERV,B.TITULOELEITOR AS TITELE,B.ZONATITELEITOR AS ZONAELE, " + CRLF
    _cQry2 += " B.SECAOTITELEITOR AS SECAOELE,B.DTTITELEITOR AS DTTITELE, B.RUA AS RUA, B.COMPLEMENTO AS COMPLEM, B.NUMERO AS NUMEND, B.CODMUNICIPIO AS CODMUN,B.ESTADO AS ESTADO, " + CRLF
    _cQry2 += " B.CEP AS CEP, B.CIDADE AS CIDADE, B.TELEFONE1 AS FONE1, B.NATURALIDADE AS NATURAL,B.ESTADOCIVIL AS ESTCIVIL,B.SEXO AS SEXO, A.NRODEPIRRF AS DEPIR, A.NRODEPSALFAM AS DEPSF, " + CRLF
    _cQry2 += " B.DTNASCIMENTO AS DTNASC,A.DATAADMISSAO AS DTADMISSA,A.DTOPCAOFGTS AS DTOPCAO,A.DATADEMISSAO AS DTDEMISSA, " + CRLF
    _cQry2 += " A.CODBANCOPAGTO AS PGTOBCO ,A.CODAGENCIAPAGTO AS PGTOAGE, A.CONTAPAGAMENTO AS PGTOCTA, " + CRLF
    _cQry2 += " A.CODBANCOFGTS AS BCOFGTS,A.CONTAFGTS AS CTAFGTS,A.CODSITUACAO AS SITFOL,A.CODFUNCAO AS CODFUNC, " + CRLF
    _cQry2 += " C.ID AS FUNID,C.NOME AS FUNNOME,C.CBO,C.CBO2002, " + CRLF
    _cQry2 += " A.CODSINDICATO AS CODSIND,D.NOME AS SINDNOME,D.CNPJ AS SINDCNPJ,D.RUA AS SINDRUA,D.NUMERO AS SINDNRO,D.COMPLEMENTO AS SINDCOMPL, " + CRLF
    _cQry2 += " D.BAIRRO AS SINDBAIR,D.ESTADO AS SINDUF,D.CEP AS SINDCEP,D.CIDADE AS SINDMUN,D.TELEFONE AS SINDFONE,COALESCE(A.PERCENTADIANT,0) AS PERCADTO, " + CRLF
    _cQry2 += " A.SALARIO,A.SITUACAORAIS AS SITRAIS,A.VINCULORAIS AS VINCRAIS,B.APELIDO,B.CORRACA,B.EMAIL, " + CRLF
    _cQry2 += " A.CODRECEBIMENTO AS RECBTO " + CRLF
    _cQry2 += " FROM [10.140.1.5].[CorporeRM].dbo.PFUNC		A (NOLOCK) " + CRLF
    _cQry2 += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.PPESSOA	B (NOLOCK) ON A.CODPESSOA = B.CODIGO " + CRLF
    _cQry2 += " LEFT JOIN  [10.140.1.5].[CorporeRM].dbo.PFUNCAO	C (NOLOCK) ON A.CODCOLIGADA = C.CODCOLIGADA AND A.CODFUNCAO = C.CODIGO " + CRLF
    _cQry2 += " LEFT JOIN  [10.140.1.5].[CorporeRM].dbo.PSINDIC D (NOLOCK) ON A.CODCOLIGADA = D.CODCOLIGADA AND A.CODSINDICATO = D.CODIGO " + CRLF
    _cQry2 += " ORDER BY A.CODCOLIGADA,A.CHAPA " + CRLF

	TcQuery _cQry2 New Alias "TFUN"

/*

SELECT A.CHAPA, B.NOME,B.NOMESOCIAL,B.CPF,A.PISPASEP,B.CARTIDENTIDADE AS RG,B.ORGEMISSORIDENT AS RGORG, B.UFCARTIDENT AS RGUF, B.DTEMISSAOIDENT AS RGEMI, 
B.CARTEIRATRAB AS CP,B.SERIECARTTRAB AS CPSER,B.UFCARTTRAB AS CPUF,B.DTCARTTRAB AS CPDT,B.CARTMOTORISTA AS CNH,B.TIPOCARTHABILIT AS CNHTP,B.DTVENCHABILIT AS CNHVCTO,
B.DTEMISSAOCNH AS CNHEMI,B.ORGEMISSORCNH AS CNHORI, B.UFCNH AS CNHUF,B.CERTIFRESERV AS RESERV,B.TITULOELEITOR AS TITELE,B.ZONATITELEITOR AS ZONAELE,
B.SECAOTITELEITOR AS SECAOELE,B.DTTITELEITOR AS DTTITELE, B.RUA AS RUA, B.COMPLEMENTO AS COMPLEM, B.NUMERO AS NUMEND, B.CODMUNICIPIO AS CODMUN,B.ESTADO AS ESTADO,
B.CEP AS CEP, B.CIDADE AS CIDADE, B.TELEFONE1 AS FONE1, B.NATURALIDADE AS NATURAL,B.ESTADOCIVIL AS ESTCIVIL,B.SEXO AS SEXO, A.NRODEPIRRF AS DEPIR, A.NRODEPSALFAM AS DEPSF,
B.DTNASCIMENTO AS DTNASC,A.DATAADMISSAO AS DTADMISSA,A.DTOPCAOFGTS AS DTOPCAO,A.DATADEMISSAO AS DTDEMISSA,
A.CODBANCOPAGTO AS PGTOBCO ,A.CODAGENCIAPAGTO AS PGTOAGE, A.CONTAPAGAMENTO AS PGTOCTA,
A.CODBANCOFGTS AS BCOFGTS,A.CONTAFGTS AS CTAFGTS,A.CODSITUACAO AS SITFOL,A.CODFUNCAO AS CODFUNC,
C.ID AS FUNID,C.NOME AS FUNNOME,C.CBO,C.CBO2002,
A.CODSINDICATO AS CODSIND,D.NOME AS SINDNOME,D.CNPJ AS SINDCNPJ,D.RUA AS SINDRUA,D.NUMERO AS SINDNRO,D.COMPLEMENTO AS SINDCOMPL,
D.BAIRRO AS SINDBAIR,D.ESTADO AS SINDUF,D.CEP AS SINDCEP,D.CIDADE AS SINDMUN,D.TELEFONE AS SINDFONE,COALESCE(A.PERCENTADIANT,0) AS PERCADTO,
A.SALARIO,A.SITUACAOFGTS,A.SITUACAORAIS,a.VINCULORAIS,B.APELIDO,B.CORRACA,B.EMAIL,
A.CODRECEBIMENTO AS RECBTO
FROM	PFUNC		A (NOLOCK)
INNER JOIN	PPESSOA	B (NOLOCK) ON A.CODPESSOA = B.CODIGO
LEFT JOIN	PFUNCAO	C (NOLOCK) ON A.CODCOLIGADA = C.CODCOLIGADA AND A.CODFUNCAO = C.CODIGO
LEFT JOIN   PSINDIC D (NOLOCK) ON A.CODCOLIGADA = D.CODCOLIGADA AND A.CODSINDICATO = D.CODIGO
ORDER BY A.CODCOLIGADA,A.CHAPA
*/

	_cArq := CriaTrab(NIL,.F.)
	Copy To &_cArq

	dbCloseArea()

	dbUseArea(.T.,,_cArq,"TFUN",.T.)
	_cInd := "COLIGADA + CHAPA "
	IndRegua("TFUN",_cArq,_cInd,,,"Selecionando Arquivo Trabalho")

	// _aEmp:= {{'A','0101','91'},{'A','0102','92'},{'A','0103','93'},{'B','0201','101'},{'B','0203','103'},{'B','0204','104'},{'C','0301','111'},{'C','0303','113'}}
	_aEmp:= {{'A','0103','93'}}

	ProcRegua(Len(_aEmp))

	For AX:= 1 To Len(_aEmp)

		IncProc("Importando Movimento RH")

		_cEmp   := Left(_aEmp[AX][2],2)
		_cFil   := Right(_aEmp[AX][2],2)
		_cFilRM := _aEmp[AX][3]

		ECO18_02(_cEmp,_cFil,_cFilRM)

	Next AX

	TFUN->(dbCloseArea())
Return



Static Function ECO18_02(_cEmp,_cFil,_cFilRM)

	Local _aArea     := GetArea()
	Local _aAreaSRA  := SRA->( GetArea() )
	Local _aAreaRCE  := RCE->( GetArea() )
	Local _aAreaSRJ  := SRJ->( GetArea() )
	Local _aAreaSRV  := SRV->( GetArea() )
	Local _aAreaZF6  := ZF6->( GetArea() )
	Local _aAreaSRD  := SRD->( GetArea() )
	Local _cAliasSRA := ''
	Local _cAliasRCE := ''
	Local _cAliasSRJ := ''
	Local _cAliasSRV := ''
	Local _cAliasZF6 := ''
	Local _cAliasSRD := ''
	Local _cModo
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _lOutSRA   := .F.
	Local _lOutRCE   := .F.
	Local _lOutSRJ   := .F.
	Local _lOutSRV   := .F.
	Local _lOutZF6   := .F.
	Local _lOutSRD   := .F.
	Local _cQry       := ''

	Private _cColigada := ''

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	Endif

	_cQry += " SELECT RIGHT('00'+RTRIM(CAST(A.CODCOLIGADA AS CHAR(02))),2) AS COLIGADA, A.CHAPA AS CHAPA, A.ANOCOMP AS ANOCOMP, A.MESCOMP AS MESCOMP, A.CODEVENTO AS CODEVEN,  " + CRLF
	_cQry += " A.DTPAGTO AS DTPAGTO, A.REF AS HORAS, A.VALOR AS VALOR, " + CRLF
	_cQry += " B.CODIGO AS RVCOD,B.PROVDESCBASE AS RVTIPOCOD,B.VALHORDIAREF AS RVTIPO,B.PORCINCID AS RVPERC,B.INCINSS AS RVINSS,B.INCIRRF AS RVIR, " + CRLF
	_cQry += " B.INCFGTS AS RVFGTS,B.INCRAIS AS RVRAIS,B.INCIRRFFERIAS AS RVINSSFER,B.INCINSS13 AS RVREF13,B.INCIRRF13,B.DESCRICAO AS RVDESC,B.ID AS RVCODFOL,B.NATRUBRICA AS RVNATUREZ" + CRLF
	_cQry += " FROM [10.140.1.5].[CorporeRM].dbo.PFFINANC A (NOLOCK) " + CRLF
	_cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.PEVENTO B (NOLOCK) ON A.CODCOLIGADA = B.CODCOLIGADA AND A.CODEVENTO = B.CODIGO " + CRLF
	_cQry += " WHERE RTRIM(A.CODCOLIGADA) = '9'  " + CRLF
	_cQry += " AND LEFT(CONVERT(char(15), A.DTPAGTO, 23),4) + " + CRLF
	_cQry += " SUBSTRING(CONVERT(char(15), A.DTPAGTO, 23),6,2) + " + CRLF
	_cQry += " SUBSTRING(CONVERT(char(15), A.DTPAGTO, 23),9,2)  " + CRLF
	_cQry += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + CRLF
	_cQry += " ORDER BY COLIGADA,ANOCOMP,MESCOMP,CHAPA,CODEVEN " + CRLF

	Memowrite("D:\_Temp\ECO018A.txt",_cQry)

	TcQuery _cQry New Alias "TRB"

	_nReg := Contar("TRB","!EOF()")

	_cTabSRD:=  "SRD"+_cEmp+"0"
	If Alltrim(cEmpAnt) = _cEmp
		_cAliasSRA := "SRA"
		_cAliasRCE := "RCE"
		_cAliasSRJ := "SRJ"
		_cAliasSRV := "SRV"
		_cAliasZF6 := "ZF6"
		_cAliasSRD := "SRD"
	Else
		If EmpOpenFile("TSRA","SRA",1,.T., _cEmp,@_cModo)
			_cAliasSRA  := "TSRA"
			_lOutSRA := .T.
		Endif
		If EmpOpenFile("TRCE","RCE",1,.T., _cEmp,@_cModo)
			_cAliasRCE  := "TRCE"
			_lOutRCE := .T.
		Endif
		If EmpOpenFile("TSRJ","SRJ",1,.T., _cEmp,@_cModo)
			_cAliasSRJ  := "TSRJ"
			_lOutSRJ := .T.
		Endif
		If EmpOpenFile("TSRV","SRV",1,.T., _cEmp,@_cModo)
			_cAliasSRV := "TSRV"
			_lOutSRV := .T.
		Endif
		If EmpOpenFile("TZF6","ZF6",1,.T., _cEmp,@_cModo)
			_cAliasZF6  := "TZF6"
			_lOutZF6 := .T.
		Endif
		If EmpOpenFile("TSRD","SRD",1,.T., _cEmp,@_cModo)
			_cAliasSRD  := "TSRD"
			_lOutSRD := .T.
		Endif
	Endif

	If !Empty(_cAliasSRA) .And. !Empty(_cAliasRCE) .And. !Empty(_cAliasSRJ) .And. !Empty(_cAliasSRV) .And. !Empty(_cAliasZF6) .And. !Empty(_cAliasSRD)

		//Exclui daddos da tabela SRD
		_cUpd := " DELETE "+_cTabSRD+ " FROM "+_cTabSRD+" WHERE E1_FILIAL = '"+_cFil+"' "
		_cUpd += " AND RD.DATPGT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

		TCSQLEXEC(_cUpd )

		TRB->(dbGoTop())

		While TRB->(!EOF())

			_cKey1   := TRB->COLIGADA
			While TRB->(!EOF())  .And. _cKey1 == TRB->COLIGADA

				(_cAliasSRV)->(dbOrderNickName("INDSRVRM"))
				If !(_cAliasSRV)->(MsSeek(xFilial("SRV")+Alltrim(TRB->CODEVEN)))
					GeraVerba(_cFil,TRB->CODEVEN)
				Endif

				_cVerba   := (_cAliasSRV)->RV_COD

				(_cAliasSRA)->(dbSetOrder(1))
				If !(_cAliasSRA)->(MsSeek(xFilial("SRA")+Alltrim(TRB->CHAPA)))
					If !GeraFun()
						Return(Nil)
					Endif
				Endif

				(_cAliasSRD)->(RecLock(_cAliasSRD,.T.))
				(_cAliasSRD)->RD_FILIAL    := _cFil
				(_cAliasSRD)->RD_MAT       := TRB->CHAPA
				(_cAliasSRD)->RD_DATARQ    := TRB->ANOCOMP
				(_cAliasSRD)->RD_MES       := TRB->MESCOMP
				(_cAliasSRD)->RD_PD        := _cVerba
				(_cAliasSRD)->DATPGT       := TRB->DTPAGTO
				(_cAliasSRD)->RD_HORAS     := TRB->HORAS
				(_cAliasSRD)->RD_VALOR     := TRB->VALOR
				(_cAliasSRD)->(MsUnLock())

				TRB->(dbSkip())
			EndDo
		EndDo

		cFilAnt := _cSvFilAnt
		cEmpAnt := _cSvEmpAnt

		RestArea( _aAreaSRA )
		RestArea( _aAreaRCE )
		RestArea( _aAreaSRJ )
		RestArea( _aAreaSRV )
		RestArea( _aAreaZF6 )
		RestArea( _aAreaSRD )

		RestArea( _aArea )

	Endif

	If _lOutSRA
		TSRA->(dbCloseArea())
	ENDIF
	If _lOutRCE
		TRCE->(dbCloseArea())
	ENDIF
	If _lOutSRJ
		TSRJ->(dbCloseArea())
	ENDIF
	If _lOutSRV
		TSRV->(dbCloseArea())
	ENDIF
	If _lOutZF6
		TZF6->(dbCloseArea())
	ENDIF
	If _lOutSRD
		TSRD->(dbCloseArea())
	ENDIF

	TRB->(dbCloseArea())

Return(Nil)



Static Function ATUSX1()

	cPerg := "ECO018"
	aRegs := {}

//    	   Grupo/Ordem/Pergunta                /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01    /Def01            /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
	U_CRIASX1(cPerg,"01","Data De?                ",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
	U_CRIASX1(cPerg,"02","Data Ate ?              ",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return (Nil)




Static Function GeraVerba(_cFil,_cCodEve)

	Local _cQryNxt := ''
	Local _cCod    := ''

	_cQryNxt := " SELECT MAX(RV_COD) AS COD FROM "+RetSqlName("SRV")+" RV (NOLOCK) " +CRLF
	_cQryNxt += " WHERE RV.D_E_L_E_T_ = '' AND RV_FILIAL = '"+xFilial("SRV")+"' " +CRLF
	If TRB->PROVDESCBASE = 'P'
		_cQryNxt += " AND A2_COD < '400' " +CRLF
	ElseIf TRB->PROVDESCBASE = 'D'
		_cQryNxt += " AND A2_COD BETWEEN '401' AND '799' " +CRLF
	Else
		_cQryNxt += " AND A2_COD > '800' " +CRLF
	Endif

	TcQuery _cQryNxt New Alias "TNEXT"

	If Contar("TNEXT","!EOF()")  > 0
		TNEXT->(dbGoTop())

		_cCod := SOMA1(TNEXT->COD)
	Else
		If TRB->PROVDESCBASE = 'P'
			_cCod := '001'
		ElseIf TRB->PROVDESCBASE = 'D'
			_cCod := '401'
		Else
			_cCod := '801'
		Endif
	Endif

	TNEXT->(dbCloseArea())

	(_cAliasSRV)->(RecLock(_cAliasSRV,.T.))
	(_cAliasSRV)->RV_FILIAL     := xFilial("SRV")
	(_cAliasSRV)->RV_COD        := _cCod
	(_cAliasSRV)->RV_TIPOCOD    := TRB->RVTIPOCOD
	(_cAliasSRV)->RV_TIPO       := TRB->RVTIPO
	(_cAliasSRV)->RV_PERC       := TRB->RVPERC
	(_cAliasSRV)->RV_INSS       := TRB->RVINSS
	(_cAliasSRV)->RV_IR         := TRB->RVIR
	(_cAliasSRV)->RV_FGTS       := TRB->RVFGTS
	(_cAliasSRV)->RV_RAIS       := TRB->RVRAIS
	(_cAliasSRV)->RV_INSSFER    := TRB->RVINSSFER
	(_cAliasSRV)->RV_REF13      := TRB->RVREF13
	// (_cAliasSRV)->RV_REF13      := TRB->RVREF13
	(_cAliasSRV)->RV_DESC       := TRB->RVDESC
	(_cAliasSRV)->RV_CODFOL     := TRB->RVCODFOL
	(_cAliasSRV)->RV_NATUREZ    := TRB->RVNATUREZ
	(_cAliasSRV)->RV_YCODRM     := TRB->RVCOD
	(_cAliasSRV)->(MsUnLock())

Return(NIL)



Static Function GeraFun()

	Local _lRet := .T.

	If TFUN->(MsSeek(TRB->COLIGADA + Alltrim(TRB->CHAPA)))

		(_cAliasSRA)->(RecLock(_cAliasSRA,.T.))
		(_cAliasSRA)->RA_FILIAL     := xFilial("SRA")
		(_cAliasSRA)->RA_MAT        := TFUN->CHAPA
		// (_cAliasSRA)->RA_CC         := TFUN->
		(_cAliasSRA)->RA_NOME       := TFUN->NOME
		(_cAliasSRA)->RA_CIC        := TFUN->CPF
		(_cAliasSRA)->RA_PIS        := TFUN->PISPASEP
		(_cAliasSRA)->RA_RG         := TFUN->RG
		(_cAliasSRA)->RA_RGORG      := TFUN->RGORG
		(_cAliasSRA)->RA_RGEXP      := TFUN->RGORG
		(_cAliasSRA)->RA_ORGEMRG    := TFUN->RGORG
		(_cAliasSRA)->RA_RGUF       := TFUN->RGUF
		(_cAliasSRA)->RA_DTRGEXP    := TFUN->RGEMI
		(_cAliasSRA)->RA_NUMCP      := TFUN->CP
		(_cAliasSRA)->RA_SERCP      := TFUN->CPSER
		(_cAliasSRA)->RA_UFCP       := TFUN->CPUF
		(_cAliasSRA)->RA_DTCPEXP    := TFUN->CPDT
		(_cAliasSRA)->RA_HABILIT    := TFUN->CNH
		(_cAliasSRA)->RA_CNHORG     := TFUN->CNHORI
		(_cAliasSRA)->RA_DTEMCNH    := TFUN->CNHEMI
		(_cAliasSRA)->RA_DTVCCNH    := TFUN->CNHVCTO
		// (_cAliasSRA)->RA_CATCNH     := TFUN->CNHTP
		(_cAliasSRA)->RA_UFCNH      := TFUN->CNHUF

		(_cAliasSRA)->RA_RESERVI    := TFUN->RESERV
		(_cAliasSRA)->RA_TITULOE    := TFUN->TITELE
		(_cAliasSRA)->RA_ZONASEC    := Alltrim(TFUN->ZONAELE)+'/'+Alltrim(TFUN->SECAOELE)
		(_cAliasSRA)->RA_ENDEREC    := Alltrim(TFUN->RUA)
		(_cAliasSRA)->RA_NUMENDE    := TFUN->NUMEND
		(_cAliasSRA)->RA_COMPLEM    := TFUN->COMPLEM
		(_cAliasSRA)->RA_BAIRRO     := TFUN->BAIRRO
		(_cAliasSRA)->RA_MUNICIP    := TFUN->CIDADE
		(_cAliasSRA)->RA_CODMUN     := TFUN->CODMUN
		(_cAliasSRA)->RA_ESTADO     := TFUN->ESTADO
		(_cAliasSRA)->RA_CEP        := TFUN->CEP
		(_cAliasSRA)->RA_TELEFON    := TFUN->FONE1
		// (_cAliasSRA)->RA_PAI        := TFUN->
		// (_cAliasSRA)->RA_MAE        := TFUN->
		(_cAliasSRA)->RA_NATURAL    := UPPER(TFUN->NATURAL)
		(_cAliasSRA)->RA_NACIONA    := '10'
		(_cAliasSRA)->RA_ESTCIVI    := TFUN->ESTCIVIL
		(_cAliasSRA)->RA_SEXO       := TFUN->SEXO
		(_cAliasSRA)->RA_DEPIR      := TFUN->DEPIR
		(_cAliasSRA)->RA_DEPSF      := TFUN->DEPSF
		(_cAliasSRA)->RA_NASC       := TFUN->DTNASC
		(_cAliasSRA)->RA_ADMISSA    := TFUN->DTADMISSA
		(_cAliasSRA)->RA_OPCAO      := TFUN->DTOPCAO
		(_cAliasSRA)->RA_DEMISSA    := TFUN->DTDEMISSA
		// (_cAliasSRA)->RA_VCTOEXP    := TFUN->
		// (_cAliasSRA)->RA_VCTEXP2    := TFUN->
		(_cAliasSRA)->RA_BCDEPSA    := Alltrim(TFUN->PGTOBCO) + Alltrim(TFUN->PGTOAGE)
		(_cAliasSRA)->RA_CTDEPSA    := Alltrim(TFUN->PGTOCTA)
		(_cAliasSRA)->RA_BCDPFGT    := Alltrim(TFUN->BCOFGTS)
		(_cAliasSRA)->RA_CTDPFGT    := Alltrim(TFUN->CTAFGTS)

		(_cAliasSRA)->RA_SITFOLH    := GetSitFol(TFUN->SITFOL)
		(_cAliasSRA)->RA_HRSMES     := 220
		(_cAliasSRA)->RA_HRSEMAN    := 44
		(_cAliasSRA)->RA_CHAPA      := TFUN->CHAPA
		// (_cAliasSRA)->RA_TNOTRAB    := TFUN->
		(_cAliasSRA)->RA_CODFUNC    := GetFuncao(TFUN->CODFUNC)
		(_cAliasSRA)->RA_CBO        := TFUN->CBO
		// (_cAliasSRA)->RA_PGCTSIN    := 
		(_cAliasSRA)->RA_ALTCBO     := 'N'
		(_cAliasSRA)->RA_SINDICA    := GetSind(TFUN->CODSIND)
		(_cAliasSRA)->RA_PROCESS    := "00001"
		(_cAliasSRA)->RA_PERCADT    := TFUN->PERCADTO
		// (_cAliasSRA)->RA_ADTPOSE    :=
		// (_cAliasSRA)->RA_CESTAB     := TFUN->
		// (_cAliasSRA)->RA_VALEREF    := TFUN->
		// (_cAliasSRA)->RA_SEGUROV    := TFUN->
		// (_cAliasSRA)->RA_PENSALI    := TFUN->
		(_cAliasSRA)->RA_CATFUNC    := 'M'
		(_cAliasSRA)->RA_TIPOPGT    := TFUN->RECBTO
		(_cAliasSRA)->RA_SALARIO    := TFUN->SALARIO
		// (_cAliasSRA)->RA_PERICUL    := TFUN->
		// (_cAliasSRA)->RA_INSMIN     := TFUN->
		// (_cAliasSRA)->RA_INSMED     := TFUN->
		// (_cAliasSRA)->RA_INSMAX     := TFUN->
		// (_cAliasSRA)->RA_TIPOADM    := TFUN->
		// (_cAliasSRA)->RA_AFASFGT    := TFUN->
		// (_cAliasSRA)->RA_VIEMRAI    := TFUN->
		// (_cAliasSRA)->RA_GRINRAI    := TFUN->
		// (_cAliasSRA)->RA_RESCRAI    := TFUN->
		// (_cAliasSRA)->RA_MESTRAB    := TFUN->
		(_cAliasSRA)->RA_ALTEND     := 'N'
		(_cAliasSRA)->RA_ALTCP      := 'N'
		(_cAliasSRA)->RA_ALTPIS     := 'N'
		(_cAliasSRA)->RA_ALTADM     := 'N'
		(_cAliasSRA)->RA_ALTOPC     := 'N'
		(_cAliasSRA)->RA_ALTNOME    := 'N'
		(_cAliasSRA)->RA_CODRET     := '0561'
		(_cAliasSRA)->RA_CRACHA     := TFUN->CHAPA
		// (_cAliasSRA)->RA_REGRA      := TFUN->
		// (_cAliasSRA)->RA_SEQTURN    := TFUN->
		// (_cAliasSRA)->RA_SENHA      := TFUN->
		// (_cAliasSRA)->RA_TPCONTR    := TFUN->
		(_cAliasSRA)->RA_APELIDO    := TFUN->APELIDO
		(_cAliasSRA)->RA_PERCSAT    := 0
		// (_cAliasSRA)->RA_BHFOL      := TFUN->
		// (_cAliasSRA)->RA_BRPDH      := TFUN->
		(_cAliasSRA)->RA_ACUMBH     := 'N'
		// (_cAliasSRA)->RA_RACACOR    := TFUN->
		(_cAliasSRA)->RA_RECMAIL    := 'N'
		(_cAliasSRA)->RA_EMAIL      := TFUN->EMAIL
		(_cAliasSRA)->RA_PERFGTS    := 0
		(_cAliasSRA)->RA_TPMAIL     := '1'
		(_cAliasSRA)->RA_MSBLQL     := If(Empty(TFUN->DTDEMISSA),2,1)
		(_cAliasSRA)->RA_TPDEFFI    := '0'
		(_cAliasSRA)->RA_RESEXT     := '2'
		(_cAliasSRA)->RA_CLAURES    := '1'
		(_cAliasSRA)->RA_HOPARC     := '2'
		(_cAliasSRA)->RA_COMPSAB    := '2'
		// (_cAliasSRA)->RA_MUNNASC    := TFUN->
		(_cAliasSRA)->RA_HRSDIA     := 7.333
		(_cAliasSRA)->RA_ADCPERI    := 1
		(_cAliasSRA)->RA_ADCINS     := 1
		// (_cAliasSRA)->RA_
		// (_cAliasSRA)->RA_
		// (_cAliasSRA)->RA_
		// (_cAliasSRA)->RA_
		// (_cAliasSRA)->RA_
		// (_cAliasSRA)->RA_
		// (_cAliasSRA)->RA_
		// (_cAliasSRA)->RA_
		// (_cAliasSRA)->RA_
		// (_cAliasSRA)->RA_
		(_cAliasSRA)->(MsUnLock())


	Else
		MsgAlert('Chapa '+Alltrim(TRB->CHAPA)+' não encontrada nas tabelas PFUNC/PPESSOA.')
		_lRet := .F.
	Endif

Return(_lRet)



Static Function GetSitFol(_cSit)

	Local _cSitFol := _cSit

	If Alltrim(_cSit) $ 'E|I|L|M|O|P|Q|R|T|U|W|Y'
		_cSitFol := 'F'
	ElseIf Alltrim(_cSit) $ 'A|Z|C'
		_cSitFol := ''
	ElseIf Alltrim(_cSit) $ 'D'
		_cSitFol := 'D'
	ElseIf Alltrim(_cSit) $ 'F'
		_cSitFol := 'F'
	Endif
    /*
    CODSITUACAO	A	Ativo
    CODSITUACAO	C	Contrato Suspenso
    CODSITUACAO	D	Demitido
    CODSITUACAO	E	Licença Maternidade
    CODSITUACAO	F	Férias
    CODSITUACAO	G	Recesso Rem. Estágio
    CODSITUACAO	I	Aposentado Invalidez
    CODSITUACAO	K	Cessão / Requisição
    CODSITUACAO	L	Licença s/ Vencimento
    CODSITUACAO	M	Serviço Militar
    CODSITUACAO	N	Mandato Sindical
    CODSITUACAO	O	Doença Ocupacional
    CODSITUACAO	P	Afastado Previdência
    CODSITUACAO	Q	Prisão / Cárcere
    CODSITUACAO	R	Licença Remunerada
    CODSITUACAO	S	Mandato Sindical
    CODSITUACAO	T	Afastado Ac. Trabalho
    CODSITUACAO	U	Outros
    CODSITUACAO	V	Aviso Prévio
    CODSITUACAO	W	Licença Mat. Compl.
    CODSITUACAO	X	C/ Demissão no Mês
    CODSITUACAO	Y	Licença Paternidade
    CODSITUACAO	Z	Admissão Próx. Mês
    */

Return(_cSitFol)



Static Function GetFuncao(_cCod)

	Local _cCodFun := PADL(Alltrim(TFUN->CODFUNC),TAMSX3("RJ_FUNCAO")[1],"0")

	// (_cAliasZF6)->(dbSetOrder(1))
	// If !(_cAliasZF6)->(MsSeek(xFilial("ZF6")+"SRJ"+PADR("RJ_FUNCAO",TAMSX3("ZF6_CAMPO")[1])+Alltrim(TFUN->CODFUNC)))

	(_cAliasSRJ)->(dbSetOrder(1))
	If !(_cAliasSRJ)->(MsSeek( xFilial("SRJ")+_cCodFun))

		(_cAliasSRJ)->(RecLock(_cAliasSRJ,.T.))
		(_cAliasSRJ)->RJ_FILIAL  := xFilial("SRJ")
		(_cAliasSRJ)->RJ_FUNCAO  := _cCodFun
		(_cAliasSRJ)->RJ_DESC    := Alltrim(TFUN->FUNNOME)
		(_cAliasSRJ)->RJ_CODCBO  := Alltrim(TFUN->CBO2002)
		(_cAliasSRJ)->RJ_CBO     := Alltrim(TFUN->CBO)
		// (_cAliasSRJ)->RJ_MAOBRA  :=
		// (_cAliasSRJ)->RJ_CARGO   :=
		// (_cAliasSRJ)->RJ_SALARIO :=
		// (_cAliasSRJ)->RJ_VALDIA  :=
		// (_cAliasSRJ)->RJ_DESCREQ :=
		// (_cAliasSRJ)->RJ_PPPIMP  :=
		// (_cAliasSRJ)->RJ_LIDER   :=
		// (_cAliasSRJ)->RJ_RHEXP   :=
		// (_cAliasSRJ)->RJ_ADTPFUN :=
		// (_cAliasSRJ)->RJ_ADTPJU  :=
		// (_cAliasSRJ)->RJ_ADTPESC :=
		// (_cAliasSRJ)->RJ_ADATIV  :=
		// (_cAliasSRJ)->RJ_ADTPROV :=
		// (_cAliasSRJ)->RJ_ADHORAS :=
		// (_cAliasSRJ)->RJ_ADDATA  :=
		// (_cAliasSRJ)->RJ_ACUM    :=
		// (_cAliasSRJ)->RJ_CTESP   :=
		// (_cAliasSRJ)->RJ_DEDEXC  :=
		// (_cAliasSRJ)->RJ_LEI     :=
		// (_cAliasSRJ)->RJ_DTLEI   :=
		// (_cAliasSRJ)->RJ_SIT     :=
		// (_cAliasSRJ)->RJ_CUMADIC :=
		(_cAliasSRJ)->(MsUnLock())

		// (_cAliasZF6)->(RecLock(_cAliasZF6,.T.))
		// (_cAliasZF6)->ZF6_FILIAL := _cFil
		// (_cAliasZF6)->ZF6_TABELA := "SRJ"
		// (_cAliasZF6)->ZF6_CAMPO  := "RJ_FUNCAO"
		// (_cAliasZF6)->ZF6_CODRM  := TFUN->CODFUNC
		// (_cAliasZF6)->ZF6_IDRM   := TFUN->FUNID
		// (_cAliasZF6)->ZF6_TOTVS  := _cCodFun
		// (_cAliasZF6)->ZF6_DESC   := TFUN->FUNNOME
		// (_cAliasZF6)->(MsUnLock())

	Endif

Return(_cCodFun)



Static Function GetSind(_cCodSind)

	(_cAliasRCE)->(dbSetOrder(1))
	If !(_cAliasRCE)->(MsSeek(xFilial(_cAliasRCE)+_cCodSind))

		(_cAliasRCE)->(RecLock(_cAliasRCE,.T.))
		(_cAliasRCE)->RCE_FILIAL := ''
		(_cAliasRCE)->RCE_CODIGO := _cCodSind
		(_cAliasRCE)->RCE_DESCRI := TFUN->SINDNOME
		(_cAliasRCE)->RCE_CGC    := Alltrim(StrTran(StrTran(StrTran(TFUN->SINDCNPJ,".",""),"-",""),"/",""))
		// (_cAliasRCE)->RCE_ENTSIN
		(_cAliasRCE)->RCE_ENDER  := TFUN->SINDRUA
		(_cAliasRCE)->RCE_NUMER  := TFUN->SINDNRO
		(_cAliasRCE)->RCE_COMPLE := TFUN->SINDCOMPL
		(_cAliasRCE)->RCE_BAIRRO := TFUN->SINDBAIR
		(_cAliasRCE)->RCE_CEP    := TFUN->SINDCEP
		(_cAliasRCE)->RCE_UF     := TFUN->SINDUF
		(_cAliasRCE)->RCE_MUNIC  := TFUN->SINDMUN
		(_cAliasRCE)->RCE_FONE   := TFUN->SINDFONE
		// (_cAliasRCE)->RCE_MESDIS
		// (_cAliasRCE)->RCE_MESANT
		// (_cAliasRCE)->RCE_MED01
		// (_cAliasRCE)->RCE_MED02
		// (_cAliasRCE)->RCE_MED03
		// (_cAliasRCE)->RCE_MED04
		// (_cAliasRCE)->RCE_NROSEM
		// (_cAliasRCE)->RCE_DSR
		// (_cAliasRCE)->RCE_HSATIV
		// (_cAliasRCE)->RCE_GCOMIS
		// (_cAliasRCE)->RCE_INI1SM
		// (_cAliasRCE)->RCE_FIM1SM
		// (_cAliasRCE)->RCE_DDD
		// (_cAliasRCE)->RCE_FAX
		// (_cAliasRCE)->RCE_EMAIL
		// (_cAliasRCE)->RCE_INI2SM
		// (_cAliasRCE)->RCE_FIM2SM
		// (_cAliasRCE)->RCE_PISO
		// (_cAliasRCE)->RCE_ASSJAN
		// (_cAliasRCE)->RCE_ASSFEV
		// (_cAliasRCE)->RCE_ASSMAR
		// (_cAliasRCE)->RCE_ASSABR
		// (_cAliasRCE)->RCE_ASSMAI
		// (_cAliasRCE)->RCE_ASSJUN
		// (_cAliasRCE)->RCE_ASSJUL
		// (_cAliasRCE)->RCE_ASSAGO
		// (_cAliasRCE)->RCE_ASSSET
		// (_cAliasRCE)->RCE_ASSOUT
		// (_cAliasRCE)->RCE_ASSNOV
		// (_cAliasRCE)->RCE_ASSDEZ
		// (_cAliasRCE)->RCE_ASSREF
		// (_cAliasRCE)->RCE_ASSSAL
		// (_cAliasRCE)->RCE_ASSMIN
		// (_cAliasRCE)->RCE_ASSMAX
		// (_cAliasRCE)->RCE_CONJAN
		// (_cAliasRCE)->RCE_CONFEV
		// (_cAliasRCE)->RCE_CONMAR
		// (_cAliasRCE)->RCE_CONABR
		// (_cAliasRCE)->RCE_CONMAI
		// (_cAliasRCE)->RCE_CONJUN
		// (_cAliasRCE)->RCE_CONJUL
		// (_cAliasRCE)->RCE_CONAGO
		// (_cAliasRCE)->RCE_CONSET
		// (_cAliasRCE)->RCE_CONOUT
		// (_cAliasRCE)->RCE_CONNOV
		// (_cAliasRCE)->RCE_CONDEZ
		// (_cAliasRCE)->RCE_CONREF
		// (_cAliasRCE)->RCE_CONSAL
		// (_cAliasRCE)->RCE_CONMIN
		// (_cAliasRCE)->RCE_CONMAX
		// (_cAliasRCE)->RCE_MENSIN
		// (_cAliasRCE)->RCE_MENREF
		// (_cAliasRCE)->RCE_MENSAL
		// (_cAliasRCE)->RCE_MENMIN
		// (_cAliasRCE)->RCE_MENMAX
		// (_cAliasRCE)->RCE_DIADIS
		// (_cAliasRCE)->RCE_DIASAV
		// (_cAliasRCE)->RCE_RHEXP
		// (_cAliasRCE)->RCE_PRJAVT
		// (_cAliasRCE)->RCE_FPAS
		// (_cAliasRCE)->RCE_TERC
		// (_cAliasRCE)->RCE_DESAFA
		// (_cAliasRCE)->RCE_PLRTPC
		// (_cAliasRCE)->RCE_PLRBSC
		// (_cAliasRCE)->RCE_PLRVLR
		// (_cAliasRCE)->RCE_PLRPER
		// (_cAliasRCE)->RCE_PLRVMI
		// (_cAliasRCE)->RCE_PLRVMA
		// (_cAliasRCE)->RCE_PLRMAS
		// (_cAliasRCE)->RCE_PLRARC
		// (_cAliasRCE)->RCE_PLRPAR
		// (_cAliasRCE)->RCE_TPCATS
		// (_cAliasRCE)->RCE_PLRQTD
		// (_cAliasRCE)->RCE_BASCAT
		// (_cAliasRCE)->RCE_VLRAN
		// (_cAliasRCE)->RCE_PERAN
		// (_cAliasRCE)->RCE_LIMAN
		// (_cAliasRCE)->RCE_DTIAN
		// (_cAliasRCE)->RCE_DTFAN
		// (_cAliasRCE)->RCE_ACUAN
		// (_cAliasRCE)->RCE_CARAN
		// (_cAliasRCE)->RCE_VLRBI
		// (_cAliasRCE)->RCE_PERBI
		// (_cAliasRCE)->RCE_LIMBI
		// (_cAliasRCE)->RCE_DTIBI
		// (_cAliasRCE)->RCE_DTFBI
		// (_cAliasRCE)->RCE_ACUBI
		// (_cAliasRCE)->RCE_CARBI
		// (_cAliasRCE)->RCE_VLRTR
		// (_cAliasRCE)->RCE_PERTR
		// (_cAliasRCE)->RCE_LIMTR
		// (_cAliasRCE)->RCE_DTITR
		// (_cAliasRCE)->RCE_DTFTR
		// (_cAliasRCE)->RCE_ACUTR
		// (_cAliasRCE)->RCE_CARTR
		// (_cAliasRCE)->RCE_VLRQR
		// (_cAliasRCE)->RCE_PERQR
		// (_cAliasRCE)->RCE_LIMQR
		// (_cAliasRCE)->RCE_DTIQR
		// (_cAliasRCE)->RCE_DTFQR
		// (_cAliasRCE)->RCE_ACUQR
		// (_cAliasRCE)->RCE_CARQR
		// (_cAliasRCE)->RCE_VLRQN
		// (_cAliasRCE)->RCE_PERQN
		// (_cAliasRCE)->RCE_LIMQN
		// (_cAliasRCE)->RCE_DTIQN
		// (_cAliasRCE)->RCE_DTFQN
		// (_cAliasRCE)->RCE_ACUQN
		// (_cAliasRCE)->RCE_CARQN
		// (_cAliasRCE)->RCE_BCALPE
		// (_cAliasRCE)->RCE_PERPE
		// (_cAliasRCE)->RCE_BCALIN
		// (_cAliasRCE)->RCE_PINSMI
		// (_cAliasRCE)->RCE_PINSME
		// (_cAliasRCE)->RCE_PINSMA
		// (_cAliasRCE)->RCE_LIMPAN
		// (_cAliasRCE)->RCE_LIMPBI
		// (_cAliasRCE)->RCE_LIMPTR
		// (_cAliasRCE)->RCE_LIMPQR
		// (_cAliasRCE)->RCE_LIMPQN
		// (_cAliasRCE)->RCE_PDRESC
		(_cAliasRCE)->(MsUnLock())

	Endif

Return(_cCodSind)
