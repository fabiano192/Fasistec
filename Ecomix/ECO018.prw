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

	_cQry2 += " SELECT RIGHT('00'+RTRIM(CAST(A.CODCOLIGADA AS CHAR(02))),2) AS COLIGADA, A.CHAPA, B.NOME,B.NOMESOCIAL,B.CPF,A.PISPASEP,B.CARTIDENTIDADE AS RG,B.ORGEMISSORIDENT AS RGORG, B.UFCARTIDENT AS RGUF, B.DTEMISSAOIDENT AS RGEMI,  " + CRLF
	_cQry2 += " B.CARTEIRATRAB AS CP,B.SERIECARTTRAB AS CPSER,B.UFCARTTRAB AS CPUF,B.DTCARTTRAB AS CPDT,B.CARTMOTORISTA AS CNH,B.TIPOCARTHABILIT AS CNHTP,B.DTVENCHABILIT AS CNHVCTO, " + CRLF
	_cQry2 += " B.DTEMISSAOCNH AS CNHEMI,B.ORGEMISSORCNH AS CNHORI, B.UFCNH AS CNHUF,B.CERTIFRESERV AS RESERV,B.TITULOELEITOR AS TITELE,B.ZONATITELEITOR AS ZONAELE, " + CRLF
	_cQry2 += " B.SECAOTITELEITOR AS SECAOELE,B.DTTITELEITOR AS DTTITELE, B.RUA AS RUA, B.COMPLEMENTO AS COMPLEM, B.NUMERO AS NUMEND, B.CODMUNICIPIO AS CODMUN,B.ESTADO AS ESTADO, " + CRLF
	_cQry2 += " B.CEP AS CEP, B.CIDADE AS CIDADE, B.BAIRRO AS BAIRRO, B.TELEFONE1 AS FONE1, B.NATURALIDADE AS NATURAL,B.ESTADOCIVIL AS ESTCIVIL,B.SEXO AS SEXO, A.NRODEPIRRF AS DEPIR, A.NRODEPSALFAM AS DEPSF, " + CRLF
	_cQry2 += " B.DTNASCIMENTO AS DTNASC,A.DATAADMISSAO AS DTADMISSA,A.DTOPCAOFGTS AS DTOPCAO,A.DATADEMISSAO AS DTDEMISSA, " + CRLF
	_cQry2 += " A.CODBANCOPAGTO AS PGTOBCO ,A.CODAGENCIAPAGTO AS PGTOAGE, A.CONTAPAGAMENTO AS PGTOCTA, " + CRLF
	_cQry2 += " A.CODBANCOFGTS AS BCOFGTS,A.CONTAFGTS AS CTAFGTS,A.CODSITUACAO AS SITFOL,A.CODFUNCAO AS CODFUNC, " + CRLF
	_cQry2 += " C.ID AS FUNID,C.NOME AS FUNNOME,C.CBO,C.CBO2002, " + CRLF
	_cQry2 += " A.CODSINDICATO AS CODSIND,D.NOME AS SINDNOME,D.CNPJ AS SINDCNPJ,D.RUA AS SINDRUA,D.NUMERO AS SINDNRO,D.COMPLEMENTO AS SINDCOMPL, " + CRLF
	_cQry2 += " D.BAIRRO AS SINDBAIR,D.ESTADO AS SINDUF,D.CEP AS SINDCEP,D.CIDADE AS SINDMUN,D.TELEFONE AS SINDFONE,COALESCE(A.PERCENTADIANT,0) AS PERCADTO, " + CRLF
	_cQry2 += " A.SALARIO,A.SITUACAORAIS AS SITRAIS,A.VINCULORAIS AS VINCRAIS,B.APELIDO,B.CORRACA,B.EMAIL,A.CODTIPO, " + CRLF
	_cQry2 += " A.CODRECEBIMENTO AS RECBTO,A.CODSECAO,F.DESCRICAO AS DESCCC, " + CRLF
	_cQry2 += " E.CODIGO AS TURNCOD,E.DESCRICAO AS TURNDESC " + CRLF
	_cQry2 += " FROM       [10.140.1.5].[CorporeRM].dbo.PFUNC	 A (NOLOCK) " + CRLF
	_cQry2 += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.PPESSOA	 B (NOLOCK) ON A.CODPESSOA = B.CODIGO " + CRLF
	_cQry2 += " LEFT JOIN  [10.140.1.5].[CorporeRM].dbo.PFUNCAO	 C (NOLOCK) ON A.CODCOLIGADA = C.CODCOLIGADA AND A.CODFUNCAO = C.CODIGO " + CRLF
	_cQry2 += " LEFT JOIN  [10.140.1.5].[CorporeRM].dbo.PSINDIC  D (NOLOCK) ON A.CODCOLIGADA = D.CODCOLIGADA AND A.CODSINDICATO = D.CODIGO " + CRLF
	_cQry2 += " LEFT JOIN  [10.140.1.5].[CorporeRM].dbo.AHORARIO E (NOLOCK) ON A.CODCOLIGADA = E.CODCOLIGADA AND A.CODHORARIO = E.CODIGO " + CRLF
	_cQry2 += " LEFT JOIN  [10.140.1.5].[CorporeRM].dbo.PSECAO   F (NOLOCK) ON A.CODCOLIGADA = F.CODCOLIGADA AND A.CODSECAO = F.CODIGO " + CRLF
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
	_aEmp:= {{'A','0101','91'},{'A','0102','92'},{'A','0103','93'}}

	ProcRegua(Len(_aEmp))

	For AX:= 1 To Len(_aEmp)

		IncProc("Importando Movimento RH")

		_cEmp   := Left(_aEmp[AX][2],2)
		_cFil   := Right(_aEmp[AX][2],2)
		_cFilRM := _aEmp[AX][3]

		ECO18_02(_cEmp,_cFil,_cFilRM)

	Next AX

	TFUN->(dbCloseArea())

Return(Nil)



Static Function ECO18_02(_cEmp,_cFil,_cFilRM)

	Local _aArea     := GetArea()
	Local _aAreaSRA  := SRA->( GetArea() )
	Local _aAreaSRB  := SRB->( GetArea() )
	Local _aAreaRCE  := RCE->( GetArea() )
	Local _aAreaCTT  := CTT->( GetArea() )

	Local _aAreaRFQ  := RFQ->( GetArea() )
	Local _aAreaRCH  := RCH->( GetArea() )
	Local _aAreaRCF  := RCF->( GetArea() )
	Local _aAreaRCG  := RCG->( GetArea() )

	Local _aAreaSRJ  := SRJ->( GetArea() )
	Local _aAreaSR6  := SR6->( GetArea() )
	Local _aAreaSRV  := SRV->( GetArea() )
	Local _aAreaZF6  := ZF6->( GetArea() )
	Local _aAreaSRD  := SRD->( GetArea() )
	Local _cAliasSRA := ''
	Local _cAliasSRB := ''
	Local _cAliasRCE := ''
	Local _cAliasRFQ := ''
	Local _cAliasRCH := ''
	Local _cAliasRCF := ''
	Local _cAliasRCG := ''
	Local _cAliasCTT := ''
	Local _cAliasSRJ := ''
	Local _cAliasSR6 := ''
	Local _cAliasSRV := ''
	Local _cAliasZF6 := ''
	Local _cAliasSRD := ''
	Local _cModo
	Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
	Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
	Local _lOutSRA   := .F.
	Local _lOutSRB   := .F.
	Local _lOutRCE   := .F.
	Local _lOutRFQ   := .F.
	Local _lOutRCH   := .F.
	Local _lOutRCF   := .F.
	Local _lOutRCG   := .F.
	Local _lOutCTT   := .F.
	Local _lOutSRJ   := .F.
	Local _lOutSR6   := .F.
	Local _lOutSRV   := .F.
	Local _lOutZF6   := .F.
	Local _lOutSRD   := .F.
	Local _cQry       := ''

	Private _cColigada := ''

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	Endif

	_cQry += " SELECT RIGHT('00'+RTRIM(CAST(A.CODCOLIGADA AS CHAR(02))),2) AS COLIGADA, A.CHAPA AS CHAPA, A.ANOCOMP AS ANOCOMP, A.MESCOMP AS MESCOMP, A.CODEVENTO AS CODEVEN,  " + CRLF
	_cQry += " A.DTPAGTO AS DTPAGTO, A.REF AS HORAS, A.VALOR AS VALOR, A.NROPERIODO AS PERIODO," + CRLF
	_cQry += " B.CODIGO AS RVCOD,B.PROVDESCBASE AS RVTIPOCOD,B.VALHORDIAREF AS RVTIPO,B.PORCINCID AS RVPERC,B.INCINSS AS RVINSS,B.INCIRRF AS RVIR, " + CRLF
	_cQry += " B.INCFGTS AS RVFGTS,B.INCRAIS AS RVRAIS,B.INCIRRFFERIAS AS RVINSSFER,B.INCINSS13 AS RVREF13,B.INCIRRF13,B.DESCRICAO AS RVDESC,B.ID AS RVCODFOL,B.NATRUBRICA AS RVNATUREZ" + CRLF
	_cQry += " FROM [10.140.1.5].[CorporeRM].dbo.PFFINANC A (NOLOCK) " + CRLF
	_cQry += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.PEVENTO B (NOLOCK) ON A.CODCOLIGADA = B.CODCOLIGADA AND A.CODEVENTO = B.CODIGO " + CRLF
	_cQry += " WHERE RTRIM(A.CODCOLIGADA) = '9'  " + CRLF

	// _cQry += " AND LEFT(CONVERT(char(15), A.DTPAGTO, 23),4) + " + CRLF
	// _cQry += " SUBSTRING(CONVERT(char(15), A.DTPAGTO, 23),6,2) + " + CRLF
	// _cQry += " SUBSTRING(CONVERT(char(15), A.DTPAGTO, 23),9,2)  " + CRLF
	// _cQry += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + CRLF
	_cQry += " AND CAST(A.ANOCOMP AS CHAR(4))+RIGHT('00'+RTRIM(CAST(A.MESCOMP AS CHAR(2))),2) " + CRLF
	_cQry += " BETWEEN '"+LEFT(DTOS(MV_PAR01),6)+"' AND '"+LEFT(DTOS(MV_PAR02),6)+"'  " + CRLF
	// _cQry += " AND A.CHAPA = '00001'


	_cQry += " ORDER BY COLIGADA,ANOCOMP,MESCOMP,CHAPA,CODEVEN " + CRLF

	Memowrite("D:\_Temp\ECO018A.txt",_cQry)

	TcQuery _cQry New Alias "TRB"

	_nReg := Contar("TRB","!EOF()")

	_cTabSRD:=  "SRD"+_cEmp+"0"
	If Alltrim(cEmpAnt) = _cEmp
		_cAliasSRA := "SRA"
		_cAliasSRB := "SRB"
		_cAliasRCE := "RCE"
		_cAliasRFQ := "RFQ"
		_cAliasRCH := "RCH"
		_cAliasRCF := "RCF"
		_cAliasRCG := "RCG"
		_cAliasCTT := "CTT"
		_cAliasSRJ := "SRJ"
		_cAliasSR6 := "SR6"
		_cAliasSRV := "SRV"
		_cAliasZF6 := "ZF6"
		_cAliasSRD := "SRD"
	Else
		If EmpOpenFile("TSRA","SRA",1,.T., _cEmp,@_cModo)
			_cAliasSRA  := "TSRA"
			_lOutSRA := .T.
		Endif
		If EmpOpenFile("TSRB","SRB",1,.T., _cEmp,@_cModo)
			_cAliasSRB  := "TSRB"
			_lOutSRB := .T.
		Endif
		If EmpOpenFile("TRCE","RCE",1,.T., _cEmp,@_cModo)
			_cAliasRCE  := "TRCE"
			_lOutRCE := .T.
		Endif
		If EmpOpenFile("TRFQ","RFQ",1,.T., _cEmp,@_cModo)
			_cAliasRFQ  := "TRFQ"
			_lOutRFQ := .T.
		Endif
		If EmpOpenFile("TRCH","RCH",1,.T., _cEmp,@_cModo)
			_cAliasRCH  := "TRCH"
			_lOutRCH := .T.
		Endif
		If EmpOpenFile("TRCF","RCF",1,.T., _cEmp,@_cModo)
			_cAliasRCF  := "TRCF"
			_lOutRCF := .T.
		Endif
		If EmpOpenFile("TRCG","RCG",1,.T., _cEmp,@_cModo)
			_cAliasRCG  := "TRCG"
			_lOutRCG := .T.
		Endif
		If EmpOpenFile("TCTT","CTT",1,.T., _cEmp,@_cModo)
			_cAliasCTT  := "TCTT"
			_lOutCTT := .T.
		Endif
		If EmpOpenFile("TSRJ","SRJ",1,.T., _cEmp,@_cModo)
			_cAliasSRJ  := "TSRJ"
			_lOutSRJ := .T.
		Endif
		If EmpOpenFile("TSR6","SR6",1,.T., _cEmp,@_cModo)
			_cAliasSR6  := "TSR6"
			_lOutSR6 := .T.
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

	If !Empty(_cAliasSRA) .And. !Empty(_cAliasSRB) .And. !Empty(_cAliasRCE)  .And. !Empty(_cAliasRFQ) .And. !Empty(_cAliasRCH) .And. !Empty(_cAliasRCF) .And. !Empty(_cAliasRCG) .And.;
			!Empty(_cAliasCTT) .And. !Empty(_cAliasSRJ) .And. !Empty(_cAliasSR6) .And. !Empty(_cAliasSRV) .And. !Empty(_cAliasZF6) .And. !Empty(_cAliasSRD)

		//Exclui daddos da tabela SRD
		_cUpd := " DELETE "+_cTabSRD+ " FROM "+_cTabSRD+" WHERE RD_FILIAL = '"+_cFil+"' "
		// _cUpd += " AND RD_DATPGT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
		_cQry += " AND RD_DATARQ BETWEEN '"+LEFT(DTOS(MV_PAR01),6)+"' AND '"+LEFT(DTOS(MV_PAR02),6)+"'  " + CRLF

		TCSQLEXEC(_cUpd )

		TRB->(dbGoTop())

		While TRB->(!EOF())

			_cKey1   := TRB->COLIGADA
			While TRB->(!EOF())  .And. _cKey1 == TRB->COLIGADA

				(_cAliasSRV)->(dbOrderNickName("INDSRVRM"))
				If !(_cAliasSRV)->(MsSeek(xFilial("SRV")+Alltrim(TRB->CODEVEN)))
					GeraVerba(_cAliasSRV,_cFil,TRB->CODEVEN)
				Endif

				_cVerba   := (_cAliasSRV)->RV_COD

				(_cAliasSRA)->(dbSetOrder(1))
				If !(_cAliasSRA)->(MsSeek(xFilial("SRA")+Alltrim(TRB->CHAPA)))
					If !GeraFun(_CALIASSRA,_cAliasSRJ,_cAliasRCE,_cAliasSR6,_cAliasZF6,_cAliasCTT,_cAliasSRB)
						Return(Nil)
					Endif
				Endif

				_cMes     := PadL(cValToChar(TRB->MESCOMP),2,"0")
				_cAno     := cValToChar(TRB->ANOCOMP)
				_cPeriodo := _cAno+_cMes
				If (_cAliasSRA)->RA_CATFUNC <> 'A'
					_cSemana := '01'
					If TRB->PERIODO = 1
						_cRoteiro := 'ADI'
					ElseIf TRB->PERIODO = 2
						_cRoteiro := 'FOL'
					ElseIf TRB->PERIODO = 3
						_cRoteiro := '132' //?
					ELSE
						_cRoteiro := '?1'
					Endif
				Else
					_cRoteiro := '?2'
					_cSemana :=  PadL(cValToChar(TRB->PERIODO),2,"0")
					CheckPer(_cSemana,_cAno,_cMes,(_cAliasSRA)->RA_PROCES,_cPeriodo,_cAliasRFQ,_cAliasRCH,_cAliasRCF,_cAliasRCG)
				Endif

				(_cAliasSRD)->(RecLock(_cAliasSRD,.T.))
				(_cAliasSRD)->RD_FILIAL    := _cFil
				(_cAliasSRD)->RD_MAT       := TRB->CHAPA
				(_cAliasSRD)->RD_DATARQ    := _cPeriodo
				(_cAliasSRD)->RD_MES       := _cMes
				(_cAliasSRD)->RD_PD        := _cVerba
				(_cAliasSRD)->RD_DATPGT    := TRB->DTPAGTO
				(_cAliasSRD)->RD_HORAS     := TRB->HORAS
				(_cAliasSRD)->RD_VALOR     := TRB->VALOR
				(_cAliasSRD)->RD_SEMANA    := _cSemana
				// (_cAliasSRD)->RD_SEMANA    := PadL(cValToChar(TRB->PERIODO),2,"0")
				(_cAliasSRD)->RD_CC        := (_cAliasSRA)->RA_CC
				(_cAliasSRD)->RD_STATUS    := "A"
				(_cAliasSRD)->RD_PROCES    := (_cAliasSRA)->RA_PROCES
				(_cAliasSRD)->RD_PERIODO   := _cPeriodo
				(_cAliasSRD)->RD_ROTEIR    := "FOL"
				(_cAliasSRD)->(MsUnLock())

				TRB->(dbSkip())
			EndDo
		EndDo

		cFilAnt := _cSvFilAnt
		cEmpAnt := _cSvEmpAnt

		RestArea( _aAreaSRA )
		RestArea( _aAreaSRB )
		RestArea( _aAreaRCE )
		RestArea( _aAreaRFQ )
		RestArea( _aAreaRCH )
		RestArea( _aAreaRCF )
		RestArea( _aAreaRCG )
		RestArea( _aAreaCTT )
		RestArea( _aAreaSRJ )
		RestArea( _aAreaSR6 )
		RestArea( _aAreaSRV )
		RestArea( _aAreaZF6 )
		RestArea( _aAreaSRD )

		RestArea( _aArea )

	Endif

	If _lOutSRA
		TSRA->(dbCloseArea())
	ENDIF
	If _lOutSRB
		TSRB->(dbCloseArea())
	ENDIF
	If _lOutRCE
		TRCE->(dbCloseArea())
	ENDIF
	If _lOutRFQ
		TRFQ->(dbCloseArea())
	ENDIF
	If _lOutRCH
		TRCH->(dbCloseArea())
	ENDIF
	If _lOutRCF
		TRCF->(dbCloseArea())
	ENDIF
	If _lOutRCG
		TRCG->(dbCloseArea())
	ENDIF
	If _lOutCTT
		TCTT->(dbCloseArea())
	ENDIF
	If _lOutSRJ
		TSRJ->(dbCloseArea())
	ENDIF
	If _lOutSR6
		TSR6->(dbCloseArea())
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




Static Function GeraVerba(_cAliasSRV,_cFil,_cCodEve)

	Local _cQryNxt := ''
	Local _cCod    := ''

	_cQryNxt := " SELECT COALESCE(MAX(RV_COD),'') AS COD FROM "+RetSqlName("SRV")+" RV (NOLOCK) " +CRLF
	_cQryNxt += " WHERE RV.D_E_L_E_T_ = '' AND RV_FILIAL = '"+xFilial("SRV")+"' " +CRLF
	If TRB->RVTIPOCOD = 'P'
		_cQryNxt += " AND RV_COD < '400' " +CRLF
	ElseIf TRB->RVTIPOCOD = 'D'
		_cQryNxt += " AND RV_COD BETWEEN '401' AND '799' " +CRLF
	Else
		_cQryNxt += " AND RV_COD > '800' " +CRLF
	Endif

	TcQuery _cQryNxt New Alias "TNEXT"

	TNEXT->(dbGoTop())

	If !Empty(TNEXT->COD)
		_cCod := SOMA1(TNEXT->COD)
	Else
		If TRB->RVTIPOCOD = 'P'
			_cCod := '001'
		ElseIf TRB->RVTIPOCOD = 'D'
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
	(_cAliasSRV)->RV_INSS       := If(TRB->RVINSS=0,'N','S')
	(_cAliasSRV)->RV_IR         := If(TRB->RVIR=0,'N','S')
	(_cAliasSRV)->RV_FGTS       := If(TRB->RVFGTS=0,'N','S')
	// (_cAliasSRV)->RV_RAIS       := TRB->RVRAIS
	(_cAliasSRV)->RV_INSSFER    := If(TRB->RVINSSFER=0,"2","1")
	(_cAliasSRV)->RV_REF13      := If(TRB->RVREF13=0,"N","S")
	(_cAliasSRV)->RV_DESC       := TRB->RVDESC
	// (_cAliasSRV)->RV_CODFOL     := TRB->RVCODFOL
	(_cAliasSRV)->RV_NATUREZ    := TRB->RVNATUREZ
	(_cAliasSRV)->RV_YCODRM     := TRB->RVCOD
	(_cAliasSRV)->(MsUnLock())

Return(NIL)



Static Function GeraFun(_CALIASSRA,_cAliasSRJ,_cAliasRCE,_cAliasSR6,_cAliasZF6,_cAliasCTT,_cAliasSRB)

	Local _lRet      := .T.
	Local a
	Local _aStrSRA   := {}
	Local _cCorRaca  := ''

	If TFUN->(MsSeek(TRB->COLIGADA + Alltrim(TRB->CHAPA)))

		_aStrSRA := SRA->(dbStruct())
				/* 
		RM		Protheus	Desc
		0		1			INDIGENA
		2		2			Branca
		4		4			Preta/Negra
		6		6			Amarela
		8		8			Parda
		9		9			Não informado
		10		9			Não declarado
		*/

		If cValToChar(TFUN->CORRACA) = "0"
			_cCorRaca   := "1"
		ElseIf cValToChar(TFUN->CORRACA) = "10" .Or. Empty(cValToChar(TFUN->CORRACA))
			_cCorRaca    := "9"
		Else
			_cCorRaca    := cValToChar(TFUN->CORRACA)
		Endif


		/*
		A	A  Autonomo
		D	N  Diretor
		N	N  Normal
		T	E  Estagiario
		Z	N  Aprendiz
		*/

		If TFUN->CODTIPO $ 'D|Z|N'
			_cCatFunc := 'N'
		ElseIf TFUN->CODTIPO = 'A'
			_cCatFunc := 'A'
		ElseIf TFUN->CODTIPO = 'T'
			_cCatFunc := 'E'
		Else
			_cCatFunc := ''
		Endif


		(_cAliasSRA)->(RecLock(_cAliasSRA,.T.))
		(_cAliasSRA)->RA_FILIAL     := xFilial("SRA")
		(_cAliasSRA)->RA_MAT        := TFUN->CHAPA
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
		(_cAliasSRA)->RA_NATURAL    := UPPER(TFUN->NATURAL)
		(_cAliasSRA)->RA_NACIONA    := '10'
		(_cAliasSRA)->RA_ESTCIVI    := TFUN->ESTCIVIL
		(_cAliasSRA)->RA_SEXO       := TFUN->SEXO
		(_cAliasSRA)->RA_DEPIR      := PadL(cValToChar(TFUN->DEPIR),2,"0")
		(_cAliasSRA)->RA_DEPSF      := PadL(cValToChar(TFUN->DEPSF),2,"0")
		(_cAliasSRA)->RA_NASC       := TFUN->DTNASC
		(_cAliasSRA)->RA_ADMISSA    := TFUN->DTADMISSA
		(_cAliasSRA)->RA_OPCAO      := TFUN->DTOPCAO
		(_cAliasSRA)->RA_DEMISSA    := TFUN->DTDEMISSA
		(_cAliasSRA)->RA_BCDEPSA    := Alltrim(TFUN->PGTOBCO) + Alltrim(TFUN->PGTOAGE)
		(_cAliasSRA)->RA_CTDEPSA    := Alltrim(TFUN->PGTOCTA)
		(_cAliasSRA)->RA_BCDPFGT    := Alltrim(TFUN->BCOFGTS)
		(_cAliasSRA)->RA_CTDPFGT    := Alltrim(TFUN->CTAFGTS)
		(_cAliasSRA)->RA_SITFOLH    := GetSitFol(TFUN->SITFOL)
		(_cAliasSRA)->RA_HRSMES     := 220
		(_cAliasSRA)->RA_HRSEMAN    := 44
		(_cAliasSRA)->RA_CHAPA      := TFUN->CHAPA
		(_cAliasSRA)->RA_TNOTRAB    := GetTurno(_cAliasSR6,_cAliasZF6,TFUN->TURNCOD)
		(_cAliasSRA)->RA_CODFUNC    := GetFuncao(_cAliasSRJ,TFUN->CODFUNC)
		(_cAliasSRA)->RA_CBO        := TFUN->CBO
		(_cAliasSRA)->RA_ALTCBO     := 'N'
		(_cAliasSRA)->RA_SINDICA    := GetSind(_cAliasRCE,TFUN->CODSIND)
		(_cAliasSRA)->RA_PROCES     := If(_cCatFunc='A','00003','00001')
		(_cAliasSRA)->RA_PERCADT    := TFUN->PERCADTO
		(_cAliasSRA)->RA_CATFUNC    := _cCatFunc
		(_cAliasSRA)->RA_TIPOPGT    := TFUN->RECBTO
		(_cAliasSRA)->RA_SALARIO    := TFUN->SALARIO
		(_cAliasSRA)->RA_ALTEND     := 'N'
		(_cAliasSRA)->RA_ALTCP      := 'N'
		(_cAliasSRA)->RA_ALTPIS     := 'N'
		(_cAliasSRA)->RA_ALTADM     := 'N'
		(_cAliasSRA)->RA_ALTOPC     := 'N'
		(_cAliasSRA)->RA_ALTNOME    := 'N'
		(_cAliasSRA)->RA_CODRET     := '0561'
		(_cAliasSRA)->RA_CRACHA     := TFUN->CHAPA
		(_cAliasSRA)->RA_APELIDO    := TFUN->APELIDO
		(_cAliasSRA)->RA_PERCSAT    := 0
		(_cAliasSRA)->RA_ACUMBH     := 'N'
		(_cAliasSRA)->RA_RACACOR    := _cCorRaca
		(_cAliasSRA)->RA_RECMAIL    := 'N'
		(_cAliasSRA)->RA_EMAIL      := TFUN->EMAIL
		(_cAliasSRA)->RA_PERFGTS    := 0
		(_cAliasSRA)->RA_TPMAIL     := '1'
		(_cAliasSRA)->RA_MSBLQL     := If(Empty(TFUN->DTDEMISSA),"2","1")
		(_cAliasSRA)->RA_TPDEFFI    := '0'
		(_cAliasSRA)->RA_RESEXT     := '2'
		(_cAliasSRA)->RA_CLAURES    := '1'
		(_cAliasSRA)->RA_HOPARC     := '2'
		(_cAliasSRA)->RA_COMPSAB    := '2'
		(_cAliasSRA)->RA_HRSDIA     := 7.333
		(_cAliasSRA)->RA_ADCPERI    := "1
		(_cAliasSRA)->RA_ADCINS     := "1"
		(_cAliasSRA)->RA_REGRA      := "01"
		(_cAliasSRA)->RA_CTPCD      := '2'
		(_cAliasSRA)->RA_CC         := GetCC(_cAliasCTT)
		// (_cAliasSRA)->RA_CATCNH     := TFUN->CNHTP
		// (_cAliasSRA)->RA_PAI        := TFUN->
		// (_cAliasSRA)->RA_MAE        := TFUN->
		// (_cAliasSRA)->RA_VCTOEXP    := TFUN->
		// (_cAliasSRA)->RA_VCTEXP2    := TFUN->
		// (_cAliasSRA)->RA_PGCTSIN    :=
		// (_cAliasSRA)->RA_ADTPOSE    :=
		// (_cAliasSRA)->RA_CESTAB     := TFUN->
		// (_cAliasSRA)->RA_VALEREF    := TFUN->
		// (_cAliasSRA)->RA_SEGUROV    := TFUN->
		// (_cAliasSRA)->RA_PENSALI    := TFUN->
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
		// (_cAliasSRA)->RA_REGRA      := TFUN->
		// (_cAliasSRA)->RA_SEQTURN    := TFUN->
		// (_cAliasSRA)->RA_SENHA      := TFUN->
		// (_cAliasSRA)->RA_TPCONTR    := TFUN->
		// (_cAliasSRA)->RA_BHFOL      := TFUN->
		// (_cAliasSRA)->RA_BRPDH      := TFUN->
		// (_cAliasSRA)->RA_MUNNASC    := TFUN->
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
		For a := 1 to Len(_aStrSRA)
			If !Alltrim(_aStrSRA[a][1]) $ '|RA_FILIAL|RA_MAT|RA_NOME|RA_CIC|RA_PIS|RA_RG|RA_RGORG|RA_RGEXP|RA_ORGEMRG|RA_RGUF|RA_DTRGEXP|RA_NUMCP|RA_SERCP|RA_UFCP|RA_DTCPEXP|RA_HABILIT|RA_CNHORG|RA_DTEMCNH|RA_DTVCCNH|RA_UFCNH|RA_RESERVI|RA_TITULOE|RA_ZONASEC|RA_ENDEREC|RA_NUMENDE|RA_COMPLEM|RA_BAIRRO|RA_MUNICIP|RA_CODMUN|RA_ESTADO|RA_CEP|RA_TELEFON|RA_NATURAL|RA_NACIONA|RA_ESTCIVI|RA_SEXO|RA_DEPIR|RA_DEPSF|RA_NASC|RA_ADMISSA|RA_OPCAO|RA_DEMISSA|RA_BCDEPSA|RA_CTDEPSA|RA_BCDPFGT|RA_CTDPFGT|RA_SITFOLH|RA_HRSMES|RA_HRSEMAN|RA_CHAPA|RA_TNOTRAB|RA_CODFUNC|RA_CBO|RA_ALTCBO|RA_SINDICA|RA_PROCES|RA_PERCADT|RA_CATFUNC|RA_TIPOPGT|RA_SALARIO|RA_ALTEND|RA_ALTCP|RA_ALTPIS|RA_ALTADM|RA_ALTOPC|RA_ALTNOME|RA_CODRET|RA_CRACHA|RA_APELIDO|RA_PERCSAT|RA_ACUMBH|RA_RACACOR|RA_RECMAIL|RA_EMAIL|RA_PERFGTS|RA_TPMAIL|RA_MSBLQL|RA_TPDEFFI|RA_RESEXT|RA_CLAURES|RA_HOPARC|RA_COMPSAB|RA_HRSDIA|RA_ADCPERI|RA_ADCINS|RA_REGRA|RA_CTPCD'
				&((_cAliasSRA)+"->"+_aStrSRA[a][1]) := CriaVar(_aStrSRA[a][1])
			Endif
		Next a
		(_cAliasSRA)->(MsUnLock())

		LoadDependentes(_cAliasSRB,TFUN->COLIGADA,TFUN->CHAPA)

		LoadFerias(_cAliasSRF,TFUN->COLIGADA,TFUN->CHAPA)

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



Static Function GetFuncao(_cAliasSRJ,_cCod)

	Local a
	Local _cCodFun := PADL(Alltrim(TFUN->CODFUNC),TAMSX3("RJ_FUNCAO")[1],"0")
	Local _aStrSRJ := {}

	(_cAliasSRJ)->(dbSetOrder(1))
	If !(_cAliasSRJ)->(MsSeek( xFilial("SRJ")+_cCodFun))

		_aStrSRJ := SRJ->(dbStruct())

		(_cAliasSRJ)->(RecLock(_cAliasSRJ,.T.))
		(_cAliasSRJ)->RJ_FILIAL  := xFilial("SRJ")
		(_cAliasSRJ)->RJ_FUNCAO  := _cCodFun
		(_cAliasSRJ)->RJ_DESC    := Alltrim(TFUN->FUNNOME)
		(_cAliasSRJ)->RJ_CODCBO  := Alltrim(StrTran(TFUN->CBO2002,"-",""))
		(_cAliasSRJ)->RJ_CBO     := Alltrim(StrTran(TFUN->CBO,"-",""))
		For a := 1 to Len(_aStrSRJ)
			If !Alltrim(_aStrSRJ[a][1]) $ 'RJ_FILIAL|RJ_FUNCAO|RJ_DESC|RJ_CODCBO|RJ_CBO'
				&((_cAliasSRJ)+"->"+_aStrSRJ[a][1]) := CriaVar(_aStrSRJ[a][1])
			Endif
		Next a
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



Static Function GetSind(_cAliasRCE,_cCodSind)

	Local a
	Local _aStrRCE := {}

	(_cAliasRCE)->(dbSetOrder(1))
	If !(_cAliasRCE)->(MsSeek(xFilial(_cAliasRCE)+_cCodSind))

		_aStrRCE := RCE->(dbStruct())

		(_cAliasRCE)->(RecLock(_cAliasRCE,.T.))
		(_cAliasRCE)->RCE_FILIAL := xFilial(_cAliasRCE)
		(_cAliasRCE)->RCE_CODIGO := _cCodSind
		(_cAliasRCE)->RCE_DESCRI := TFUN->SINDNOME
		(_cAliasRCE)->RCE_CGC    := Alltrim(StrTran(StrTran(StrTran(TFUN->SINDCNPJ,".",""),"-",""),"/",""))
		(_cAliasRCE)->RCE_ENDER  := TFUN->SINDRUA
		(_cAliasRCE)->RCE_NUMER  := TFUN->SINDNRO
		(_cAliasRCE)->RCE_COMPLE := TFUN->SINDCOMPL
		(_cAliasRCE)->RCE_BAIRRO := TFUN->SINDBAIR
		(_cAliasRCE)->RCE_CEP    := TFUN->SINDCEP
		(_cAliasRCE)->RCE_UF     := TFUN->SINDUF
		(_cAliasRCE)->RCE_MUNIC  := TFUN->SINDMUN
		(_cAliasRCE)->RCE_FONE   := TFUN->SINDFONE

		For a := 1 to Len(_aStrRCE)
			If !Alltrim(_aStrRCE[a][1]) $ '|RCE_FILIAL|RCE_CODIGO|RCE_DESCRI|RCE_CGC|RCE_ENDER|RCE_NUMER|RCE_COMPLE|RCE_BAIRRO|RCE_CEP|RCE_UF|RCE_MUNIC|RCE_FONE'
				&((_cAliasRCE)+"->"+_aStrRCE[a][1]) := CriaVar(_aStrRCE[a][1])
			Endif
		Next a


		// (_cAliasRCE)->RCE_ENTSIN
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





Static Function GetTurno(_cAliasSR6,_cAliasZF6,_cCod)

	Local a
	Local _cCodTur := ''
	Local _aStrSR6 := {}
	Local _cQryNxt := ''

	(_cAliasSR6)->(dbSetOrder(3))
	If !(_cAliasSR6)->(MsSeek(xFilial("SR6")+Alltrim(_cCod)))

		_aStrSR6 := SR6->(dbStruct())

		_cQryNxt := " SELECT COALESCE(MAX(R6_TURNO),'') AS COD FROM "+RetSqlName("SR6")+" R6 (NOLOCK) " +CRLF
		_cQryNxt += " WHERE R6.D_E_L_E_T_ = '' AND R6_FILIAL = '"+xFilial("SR6")+"' " +CRLF

		TcQuery _cQryNxt New Alias "TNEXT"

		TNEXT->(dbGoTop())

		If !Empty(TNEXT->COD)
			_cCodTur := SOMA1(TNEXT->COD)
		Else
			_cCodTur := '001'
		Endif

		TNEXT->(dbCloseArea())

		(_cAliasSR6)->(RecLock(_cAliasSR6,.T.))
		(_cAliasSR6)->R6_FILIAL  := xFilial("SR6")
		(_cAliasSR6)->R6_TURNO   := _cCodTur
		(_cAliasSR6)->R6_DESC    := Alltrim(TFUN->TURNDESC)
		(_cAliasSR6)->R6_YCODRM  := _cCod
		For a := 1 to Len(_aStrSR6)
			If !Alltrim(_aStrSR6[a][1]) $ 'R6_FILIAL|R6_TURNO|R6_DESC|R6_YCODRM'
				&((_cAliasSR6)+"->"+_aStrSR6[a][1]) := CriaVar(_aStrSR6[a][1])
			Endif
		Next a
		(_cAliasSR6)->(MsUnLock())

		// (_cAliasZF6)->(RecLock(_cAliasZF6,.T.))
		// (_cAliasZF6)->ZF6_FILIAL := _cFil
		// (_cAliasZF6)->ZF6_TABELA := "SR6"
		// (_cAliasZF6)->ZF6_CAMPO  := "R6_TURNO"
		// (_cAliasZF6)->ZF6_CODRM  := _cCod
		// (_cAliasZF6)->ZF6_IDRM   := _cCod
		// (_cAliasZF6)->ZF6_TOTVS  := _cCodTur
		// (_cAliasZF6)->ZF6_DESC   := Alltrim(TFUN->TURNDESC)
		// (_cAliasZF6)->(MsUnLock())

	Else
		_cCodTur := (_cAliasSR6)->R6_TURNO
	Endif

Return(_cCodTur)




Static Function GetCC(_cAliasCTT)

	Local a
	Local _aStrCTT := {}
	Local _cCodCC  := Alltrim(TFUN->COLIGADA)+Alltrim(TFUN->CODSECAO)

	(_cAliasCTT)->(dbSetOrder(1))
	If !(_cAliasCTT)->(MsSeek( xFilial("CTT")+_cCodCC))

		_aStrCTT := CTT->(dbStruct())

		(_cAliasCTT)->(RecLock(_cAliasCTT,.T.))
		(_cAliasCTT)->CTT_FILIAL  := xFilial("CTT")
		(_cAliasCTT)->CTT_CUSTO   := _cCodCC
		(_cAliasCTT)->CTT_CCLP    := _cCodCC
		(_cAliasCTT)->CTT_CLASSE  := '2'
		(_cAliasCTT)->CTT_DESC01  := Alltrim(UPPER(TFUN->DESCCC))
		For a := 1 to Len(_aStrCTT)
			If !Alltrim(_aStrCTT[a][1]) $ 'CTT_FILIAL|CTT_CUSTO|CTT_CLASSE|CTT_DESC01|CTT_CCLP'
				&((_cAliasCTT)+"->"+_aStrCTT[a][1]) := CriaVar(_aStrCTT[a][1])
			Endif
		Next a
		(_cAliasCTT)->(MsUnLock())
	Endif

Return(_cCodCC)




Static Function CheckPer(_cSemana,_cAno,_cMes,_cProces,_cPeriodo,_cAliasRFQ,_cAliasRCH,_cAliasRCF,_cAliasRCG)

	Local a
	Local _aStrRFQ := {}

	(_cAliasRFQ)->(dbSetorder(1))
	If !(_cAliasRFQ)->(MsSeek(xFilial("RFQ")+_cProces+_cPeriodo+_cSemana))
		// RFQ_FILIAL, RFQ_PROCES, RFQ_PERIOD, RFQ_NUMPAG, RFQ_DTINI, RFQ_DTFIM, RFQ_MODULO, R_E_C_N_O_, D_E_L_E_T_

		If (_cAliasRFQ)->(MsSeek(xFilial("RFQ")+_cProces+_cPeriodo+"01"))

			_aStrRFQ := RFQ->(dbStruct())

			_aInfo := {}
			For a := 1 to Len(_aStrRFQ)
				AAdd(_aInfo,{Alltrim(_aStrRFQ[a][1]) ,&((_cAliasRFQ)+"->"+_aStrRFQ[a][1])})
			Next a

			(_cAliasRFQ)->(RecLock(_cAliasRFQ,.T.))
			(_cAliasRFQ)->RFQ_NUMPAG := _cSemana
			For a := 1 to Len(_aStrRFQ)
				If !Alltrim(_aStrRFQ[a][1]) $ 'RFQ_NUMPAG'
					_nPosInfo := aScan(_aInfo,{|x|x[1] = Alltrim(_aStrRFQ[a][1]) })
					&((_cAliasRFQ)+"->"+_aStrRFQ[a][1]) := _aInfo[_nPosInfo][2]
				Endif
			Next a
			(_cAliasRFQ)->(MsUnLock())


			(_cAliasRCH)->(RecLock(_cAliasRCH,.T.))
			// (_cAliasRCH)->RCH_FILIAL :=
			(_cAliasRCH)->RCH_PER    := _cPeriodo
			(_cAliasRCH)->RCH_NUMPAG := _cSemana
			(_cAliasRCH)->RCH_PROCES := _cProces
			(_cAliasRCH)->RCH_ROTEIR := 'AUT'
			(_cAliasRCH)->RCH_MES    := _cMes
			(_cAliasRCH)->RCH_ANO    := _cAno
			(_cAliasRCH)->RCH_DTINI  := cTod( '01/' +_cMes+ '/' +_cAno)
			(_cAliasRCH)->RCH_DTFIM  := LastDay(cTod( '01/' +_cMes+ '/' +_cAno))
			(_cAliasRCH)->RCH_DTPAGO := LastDay(cTod( '01/' +_cMes+ '/' +_cAno))
			(_cAliasRCH)->RCH_DTFECH := LastDay(cTod( '01/' +_cMes+ '/' +_cAno))+1
			(_cAliasRCH)->RCH_DTCONT := LastDay(cTod( '01/' +_cMes+ '/' +_cAno))
			(_cAliasRCH)->RCH_PERSEL := '2'
			(_cAliasRCH)->RCH_STATUS := '5'
			(_cAliasRCH)->RCH_MODULO := 'GPE'
			// (_cAliasRCH)->RCH_DTPGAD :=
			// (_cAliasRCH)->RCH_DTPG13 :=
			// (_cAliasRCH)->RCH_DTCORT :=
			// (_cAliasRCH)->RCH_ACUM1  :=
			// (_cAliasRCH)->RCH_ACUM2  :=
			// (_cAliasRCH)->RCH_ACUM3  :=
			// (_cAliasRCH)->RCH_ACUM4  :=
			// (_cAliasRCH)->RCH_PDPERI :=
			// (_cAliasRCH)->RCH_DIAUTI :=
			// (_cAliasRCH)->RCH_COND1  :=
			// (_cAliasRCH)->RCH_COND2  :=
			// (_cAliasRCH)->RCH_CRITER :=
			// (_cAliasRCH)->RCH_SEQUE  :=
			// (_cAliasRCH)->RCH_TARINI :=
			// (_cAliasRCH)->RCH_TARFIM :=
			// (_cAliasRCH)->RCH_DTINTE :=
			// (_cAliasRCH)->RCH_COMPL  :=
			// (_cAliasRCH)->RCH_BLOQ   :=
			(_cAliasRCH)->(MsUnLock())


			(_cAliasRCF)->(dbSetorder(3))
			If (_cAliasRCF)->(MsSeek(xFilial("RCF")+_cProces+_cPeriodo+"01"))

				_aStrRCF := RCF->(dbStruct())

				_aInfo := {}
				For a := 1 to Len(_aStrRCF)
					AAdd(_aInfo,{Alltrim(_aStrRCF[a][1]) ,&((_cAliasRCF)+"->"+_aStrRCF[a][1])})
				Next a

				(_cAliasRCF)->(RecLock(_cAliasRCF,.T.))
				(_cAliasRCF)->RCF_SEMANA := _cSemana
				For a := 1 to Len(_aStrRCF)
					If !Alltrim(_aStrRCF[a][1]) $ 'RCF_SEMANA'
						_nPosInfo := aScan(_aInfo,{|x|x[1] = Alltrim(_aStrRCF[a][1]) })
						&((_cAliasRCF)+"->"+_aStrRCF[a][1]) := _aInfo[_nPosInfo][2]
					Endif
				Next a
				(_cAliasRCF)->(MsUnLock())
			Endif


			(_cAliasRCG)->(dbSetorder(2))
			If (_cAliasRCG)->(MsSeek(xFilial("RCG")+_cProces+_cPeriodo+"01"))

				_aStrRCG := RCG->(dbStruct())

				_cKey := (_cAliasRCG)->RCG_FILIAL+(_cAliasRCG)->RCG_PROCES+(_cAliasRCG)->RCG_PER+(_cAliasRCG)->RCG_SEMANA

				While (_cAliasRCG)->(!EOF()) .And. _cKey == (_cAliasRCG)->RCG_FILIAL+(_cAliasRCG)->RCG_PROCES+(_cAliasRCG)->RCG_PER+(_cAliasRCG)->RCG_SEMANA

					_aInfo := {}
					For a := 1 to Len(_aStrRCG)
						AAdd(_aInfo,{Alltrim(_aStrRCG[a][1]) ,&((_cAliasRCG)+"->"+_aStrRCG[a][1])})
					Next a

					(_cAliasRCG)->(RecLock(_cAliasRCG,.T.))
					(_cAliasRCG)->RCG_SEMANA := _cSemana
					For a := 1 to Len(_aStrRCG)
						If !Alltrim(_aStrRCG[a][1]) $ 'RCG_SEMANA'
							_nPosInfo := aScan(_aInfo,{|x|x[1] = Alltrim(_aStrRCG[a][1]) })
							&((_cAliasRCG)+"->"+_aStrRCG[a][1]) := _aInfo[_nPosInfo][2]
						Endif
					Next a
					(_cAliasRCG)->(MsUnLock())

					(_cAliasRCG)->(dbSkip())
				EndDo
			Endif


		Endif
	Endif

Return(Nil)



Static Function LoadDependentes(_cAliasSRB,_cColigada,_cChapa)

	// Local a
	Local _cQryDep := ''
	Local _aStrSRB := {}
	Local _aGrauP  := ''

	If Select("TDEPEN") > 0
		TDEPEN->(dbCloseArea())
	Endif

	_cQryDep += " SELECT A.CHAPA,A.NRODEPEND AS NRODEPE, A.NOME, A.DTNASCIMENTO AS DTNASCIM, A.SEXO, A.CPF, A.GRAUPARENTESCO AS GRAUP, A.CARTORIO,A.NROREGISTRO AS NROREGIST,A.NROLIVRO,A.NROFOLHA, " + CRLF
	_cQryDep += " A.LOCALNASCIMENTO AS LOCALNAS " +CRLF
	_cQryDep += " FROM [10.140.1.5].[CorporeRM].dbo.PFDEPEND A (NOLOCK) " +CRLF
	// _cQryDep += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.PFUNC B (NOLOCK) ON A.CODCOLIGADA = B.CODCOLIGADA AND A.CHAPA = B.CHAPA " +CRLF
	_cQryDep += " WHERE A.CHAPA = '"+Alltrim(_cChapa)+"' " +CRLF
	_cQryDep += " AND A.CODCOLIGADA = "+cValToChar(Val(_cColigada))+" " +CRLF
	_cQryDep += " ORDER BY A.NRODEPEND " +CRLF

	TcQuery _cQryDep New Alias "TDEPEN"

	If Contar("TDEPEN","!EOF()") > 0

		_aStrSRB := SRB->(dbStruct())

		TDEPEN->(dbGoTop())

		While TDEPEN->(!EOF())

			_aGrauP := GetGrauP(TDEPEN->GRAUP)

			(_cAliasSRB)->(RecLock(_cAliasSRB,.T.))
			(_cAliasSRB)->RB_FILIAL  := xFilial("SRB")
			(_cAliasSRB)->RB_MAT     := TDEPEN->CHAPA
			(_cAliasSRB)->RB_COD     := PadL(cValToChar(TDEPEN->NRODEPE),2,"0")
			(_cAliasSRB)->RB_NOME    := Alltrim(Upper(TDEPEN->NOME))
			(_cAliasSRB)->RB_DTNASC  := TDEPEN->DTNASCIM
			(_cAliasSRB)->RB_SEXO    := TDEPEN->SEXO
			(_cAliasSRB)->RB_GRAUPAR := _aGrauP[1]
			// (_cAliasSRB)->RB_TIPIR   :=
			// (_cAliasSRB)->RB_TIPSF   :=
			(_cAliasSRB)->RB_LOCNASC := TDEPEN->LOCALNAS
			(_cAliasSRB)->RB_CARTORI := TDEPEN->CARTORIO
			(_cAliasSRB)->RB_NREGCAR := TDEPEN->NROREGIST
			(_cAliasSRB)->RB_NUMLIVR := TDEPEN->NROLIVRO
			(_cAliasSRB)->RB_NUMFOLH := TDEPEN->NROFOLHA
			(_cAliasSRB)->RB_CIC     := TDEPEN->CPF
			(_cAliasSRB)->RB_TPDEP   := _aGrauP[2]
			// (_cAliasSRB)->RB_DTENTRA :=
			// (_cAliasSRB)->RB_DTBAIXA :=
			// (_cAliasSRB)->RB_TPDEPAM :=
			// (_cAliasSRB)->RB_TIPAMED :=
			// (_cAliasSRB)->RB_CODAMED :=
			// (_cAliasSRB)->RB_VBDESAM :=
			// (_cAliasSRB)->RB_DTINIAM :=
			// (_cAliasSRB)->RB_DTFIMAM :=
			// (_cAliasSRB)->RB_TPDPODO :=
			// (_cAliasSRB)->RB_TPASODO :=
			// (_cAliasSRB)->RB_ASODONT :=
			// (_cAliasSRB)->RB_VBDESAO :=
			// (_cAliasSRB)->RB_DTINIAO :=
			// (_cAliasSRB)->RB_DTFIMAO :=
			// (_cAliasSRB)->RB_AUXCRE  :=
			// (_cAliasSRB)->RB_VLRCRE  :=
			// (_cAliasSRB)->RB_NUMAT   :=
			// (_cAliasSRB)->RB_PLSAUDE :=
			// (_cAliasSRB)->RB_INCT    :=
			// (_cAliasSRB)->RB_DTINIAC :=
			(_cAliasSRB)->(MsUnLock())

			TDEPEN->(dbSkip())
		EndDo
	Endif

	TDEPEN->(dbCloseArea())

Return(Nil)



Static Function GetGrauP(_cGrau)

	Local _aRet := {}

	/*
	RM	Protheus	E-Social	Descicao
	1	F			03			Filho(a) Valido
	3	F			03			Filho(a) Invalido
	5	C			01			Conjuge
	6	P			09			Pai
	7	P			09			Mae
	8	O			13			Sogro(a)
	9	O			13			Outros
	A	O			09			Avô(ó)
	B	O			11			Incapaz
	C	C			02			Companheiro(a)
	D	E			03			Enteado(a)
	E	O			13			Excluido
	G	O			12			Ex-conjuge
	I	O			06			Irma(o) Valido
	M	O			10			Menor pobre
	N	O			06			Irma(o) Invalido
	P	O			12			Ex-companheiro(a)
	S	O			13			Ex-sogro(a)
	T	O			06			Neto(a)
	X	O			13			Ex-enteado(a)

	C=Conjuge/Companheiro;F=Filho;E=Enteado;P=Pai/Mae;O=Agregado/Outros

	"01=Cônjuge;"
	"02=Companheiro(a) com o(a) qual tenha filho ou viva há mais de 5 (cinco) anos ou possua Declaração de União Estável; "
	"03=Filho(a) ou enteado(a);"
	"04=Filho(a) ou enteado(a) universitário(a) ou cursando escola técnica de 2º grau; "
	"05=Filho(a) ou enteado(a) em qualquer idade, quando incapacitado física e/ou mentalmente para o trabalho; "
	"06=Irmão(ã), neto(a) ou bisneto(a) sem arrimo dos pais, do(a) qual detenha a guarda judicial; "
	"07=Irmão(ã), neto(a) ou bisneto(a) sem arrimo dos pais se ainda estiver cursando estabelecimento de nível superior ou escola técnica de 2º grau, desde que tenha detido sua guarda judicial; "
	"08=Irmão(ã), neto(a) ou bisneto(a) sem arrimo dos pais, do(a) qual detenha a guarda judicial, em qualquer idade, quando incapacitado física e/ou mentalmente para o trabalho; "
	"09=Pais, avós e bisavós;"
	"10=Menor pobre que crie e eduque e do qual detenha a guarda judicial; "
	"11=A pessoa absolutamente incapaz, da qual seja tutor ou curador; "
	"12=Ex-cônjuge."
	"13=AGregado\Outros"
	*/


	If _cGrau = '1'
		AAdd(_aRet,'F')
		AAdd(_aRet,'03')
	ElseIf _cGrau = '3'
		AAdd(_aRet,'F')
		AAdd(_aRet,'03')
	ElseIf _cGrau = '5'
		AAdd(_aRet,'C')
		AAdd(_aRet,'01')
	ElseIf _cGrau = '6'
		AAdd(_aRet,'P')
		AAdd(_aRet,'09')
	ElseIf _cGrau = '7'
		AAdd(_aRet,'P')
		AAdd(_aRet,'09')
	ElseIf _cGrau = '8'
		AAdd(_aRet,'O')
		AAdd(_aRet,'13')
	ElseIf _cGrau = '9'
		AAdd(_aRet,'O')
		AAdd(_aRet,'13')
	ElseIf _cGrau = 'A'
		AAdd(_aRet,'O')
		AAdd(_aRet,'09')
	ElseIf _cGrau = 'B'
		AAdd(_aRet,'O')
		AAdd(_aRet,'11')
	ElseIf _cGrau = 'C'
		AAdd(_aRet,'C')
		AAdd(_aRet,'02')
	ElseIf _cGrau = 'D'
		AAdd(_aRet,'E')
		AAdd(_aRet,'03')
	ElseIf _cGrau = 'E'
		AAdd(_aRet,'O')
		AAdd(_aRet,'13')
	ElseIf _cGrau = 'G'
		AAdd(_aRet,'O')
		AAdd(_aRet,'12')
	ElseIf _cGrau = 'I'
		AAdd(_aRet,'O')
		AAdd(_aRet,'06')
	ElseIf _cGrau = 'M'
		AAdd(_aRet,'O')
		AAdd(_aRet,'10')
	ElseIf _cGrau = 'N'
		AAdd(_aRet,'O')
		AAdd(_aRet,'06')
	ElseIf _cGrau = 'P'
		AAdd(_aRet,'O')
		AAdd(_aRet,'12')
	ElseIf _cGrau = 'S'
		AAdd(_aRet,'O')
		AAdd(_aRet,'13')
	ElseIf _cGrau = 'T'
		AAdd(_aRet,'O')
		AAdd(_aRet,'06')
	ElseIf _cGrau = 'X'
		AAdd(_aRet,'O')
		AAdd(_aRet,'13')
	Endif

Return(_aRet)




Static Function LoadFerias(_cAliasSRF,_cColigada,_cChapa)

	Local _cQryFer := ''
	Local _aStrSRF := {}

	If Select("TFERIAS") > 0
		TFERIAS->(dbCloseArea())
	Endif

	_cQryFer += " SELECT A.CHAPA, A.INICIOPERAQUIS AS DTINI, A.FIMPERAQUIS AS DTFIM, A.SALDO, A.FALTAS, A.RECCREATEDON AS DTCREATE,A.PERIODOABERTO AS STATPER " + CRLF
	_cQryFer += " FROM [10.140.1.5].[CorporeRM].dbo.PFUFERIAS A (NOLOCK) " +CRLF
	_cQryFer += " WHERE A.CHAPA = '"+Alltrim(_cChapa)+"' " +CRLF
	_cQryFer += " AND A.CODCOLIGADA = "+cValToChar(Val(_cColigada))+" " +CRLF
	_cQryFer += " ORDER BY A.INICIOPERAQUIS " +CRLF

	TcQuery _cQryFer New Alias "TFERIAS"

	If Contar("TFERIAS","!EOF()") > 0

		_aStrSRF := SRF->(dbStruct())

		TFERIAS->(dbGoTop())

		While TFERIAS->(!EOF())

			(_cAliasSRF)->(RecLock(_cAliasSRF,.T.))
			(_cAliasSRF)->RF_FILIAL  := xFilial( 'SRF' )
			(_cAliasSRF)->RF_MAT     := _cChapa
			(_cAliasSRF)->RF_DATABAS := TFERIAS->DTINI
			(_cAliasSRF)->RF_DFERANT := 0
			(_cAliasSRF)->RF_DFERVAT := 0
			(_cAliasSRF)->RF_PD      := '018'
			(_cAliasSRF)->RF_DATAATU := TFERIAS->DTCREATE
			(_cAliasSRF)->RF_DATAFIM := TFERIAS->DTFIM
			(_cAliasSRF)->RF_DIASDIR := 30
			(_cAliasSRF)->RF_STATUS  := If(TFERIAS->STATPER = 0,"3","1")

			For a := 1 to Len(_aStrSRF)
				If !Alltrim(_aStrSRF[a][1]) $ 'RF_FILIAL|RF_MAT|RF_DATABAS|RF_DFERANT|RF_DFERVAT|RF_PD|RF_DATAATU|RF_DATAFIM|RF_DIASDIR|RF_STATUS'
					_nPosInfo := aScan(_aInfo,{|x|x[1] = Alltrim(_aStrSRF[a][1]) })
					&((_cAliasSRF)+"->"+_aStrSRF[a][1]) := _aInfo[_nPosInfo][2]
				Endif
			Next a
			(_cAliasSRF)->(MsUnLock())

			TFERIAS->(dbSkip())
		EndDo
	Endif

	TFERIAS->(dbCloseArea())

Return(Nil)
