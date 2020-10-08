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

    Local AX, a, _cQry2

    _cQry2 := " SELECT * FROM  [10.140.1.5].[CorporeRM].dbo.PFUNC A (NOLOCK) " + CRLF
    _cQry2 += " INNER JOIN [10.140.1.5].[CorporeRM].dbo.PPESSOA B (NOLOCK) ON A.CODPESSOA = B.CODIGO " + CRLF
    _cQry2 += " ORDER BY CODCOLIGADA,CHAPA " + CRLF

    TcQuery _cQry2 New Alias "TFUN"




SELECT A.CHAPA, B.NOME,B.NOMESOCIAL,B.CPF,A.PISPASEP,B.CARTIDENTIDADE AS RG,B.ORGEMISSORIDENT AS RGORG, B.UFCARTIDENT AS RGUF, B.DTEMISSAOIDENT AS RGEMI, 
--B.CARTEIRATRAB AS CP,B.SERIECARTTRAB AS CPSER,B.UFCARTTRAB AS CPUF,B.DTCARTTRAB AS CPDT,B.CARTMOTORISTA AS CNH,B.TIPOCARTHABILIT AS CNHTP,B.DTVENCHABILIT AS CNHVCTO,
--B.DTEMISSAOCNH AS CNHEMI,B.ORGEMISSORCNH AS CNHORI, B.UFCNH AS CNHUF,B.CERTIFRESERV AS RESERV,B.TITULOELEITOR AS TITELE,B.ZONATITELEITOR AS ZONAELE,
--B.SECAOTITELEITOR AS SECAOELE,B.DTTITELEITOR AS DTTITELE, B.RUA AS RUA, B.COMPLEMENTO AS COMPLEM, B.NUMERO AS NUMEND, B.CODMUNICIPIO AS CODMUN,B.ESTADO AS ESTADO,
--B.CEP AS CEP, B.CIDADE AS CIDADE, B.TELEFONE1 AS FONE1, B.NATURALIDADE AS NATURAL,B.ESTADOCIVIL AS ESTCIVIL,B.SEXO AS SEXO, A.NRODEPIRRF AS DEPIR, A.NRODEPSALFAM AS DEPSF,
B.DTNASCIMENTO AS DTNASC,A.DATAADMISSAO AS DTADMISSA,A.DTOPCAOFGTS AS DTOPCAO,A.DATADEMISSAO AS DTDEMISSA,
A.CODBANCOPAGTO AS PGTOBCO ,A.CODAGENCIAPAGTO AS PGTOAGE, A.CONTAPAGAMENTO AS PGTOCTA,

A.CODRECEBIMENTO AS RECBTO,
A.* FROM	PFUNC		A (NOLOCK)
INNER JOIN	PPESSOA	B (NOLOCK) ON A.CODPESSOA = B.CODIGO
--ORDER BY CODCOLIGADA,CHAPA



    _cArq := CriaTrab(NIL,.F.)
    Copy To &_cArq

    dbCloseArea()

    dbUseArea(.T.,,_cArq,"TFUN",.T.)
    _cInd := "CODCOLIGADA + CHAPA "
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
    Local _aAreaSRV  := SRV->( GetArea() )
    Local _aAreaZF6  := ZF6->( GetArea() )
    Local _aAreaSRD  := SRD->( GetArea() )
    Local _cAliasSRA := ''
    Local _cAliasSRV := ''
    Local _cAliasZF6 := ''
    Local _cAliasSRD := ''
    Local _cModo
    Local _cSvEmpAnt := cEmpAnt //Salva a Empresa Anterior
    Local _cSvFilAnt := cFilAnt //Salva a Filial Anterior
    Local _lOutSRA   := .F.
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
        _cAliasSRV := "SRV"
        _cAliasZF6 := "ZF6"
        _cAliasSRD := "SRD"
    Else
        If EmpOpenFile("TSRA","SRA",1,.T., _cEmp,@_cModo)
            _cAliasSRA  := "TSRA"
            _lOutSRA := .T.
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

    If !Empty(_cAliasSRA) .And. !Empty(_cAliasSRV) .And. !Empty(_cAliasZF6) .And. !Empty(_cAliasSRD)

        //Exclui daddos da tabela SRD
        _cUpd := " DELETE "+_cTabSRD+ " FROM "+_cTabSRD+" WHERE E1_FILIAL = '"+_cFil+"' "
        _cUpd += " AND RD.DATPGT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

        TCSQLEXEC(_cUpd )

        TRB->(dbGoTop())

        While TRB->(!EOF())

            _cKey1   := TRB->COLIGADA
            While TRB->(!EOF())  .And. _cKey1 == TRB->COLIGADA

                (_cAliasSRV)->(dbOrderNickName("INDSRVRM"))
                If !(_cAliasSRV)->(MsSeek(xFilial("SRV")+Alltrim(TRB->CODEVEN))
                    GeraVerba(_cFil,TRB->CODEVEN)
                Endif

                _cVerba   := (_cAliasSRV)->RV_COD

                (_cAliasSRA)->(dbSetOrder(1))
                If !(_cAliasSRA)->(MsSeek(xFilial("SRA")+Alltrim(TRB->CHAPA))
                    

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
        RestArea( _aAreaSRV )
        RestArea( _aAreaZF6 )
        RestArea( _aAreaSRD )

        RestArea( _aArea )

    Endif

    If _lOutSRA
        TSRA->(dbCloseArea())
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
        (_cAliasSRA)->RA_BCDDEPSA   := TFUN->PGTOBCO
        (_cAliasSRA)->RA_CTDEPSA    := TFUN->PGTOAGE - PGTOCTA
        (_cAliasSRA)->RA_BCDPFGTS   := TFUN->
        (_cAliasSRA)->RA_CTDPFGTS   := TFUN->
        (_cAliasSRA)->RA_SITFOLH    := TFUN->
        (_cAliasSRA)->RA_HRSMES     := TFUN->
        (_cAliasSRA)->RA_HRSEMAN    := TFUN->
        (_cAliasSRA)->RA_CHAPA      := TFUN->CHAPA
        (_cAliasSRA)->RA_TNOTRAB    := TFUN->
        (_cAliasSRA)->RA_CODFUNC    := TFUN->
        (_cAliasSRA)->RA_CBO        := TFUN->
        (_cAliasSRA)->RA_PGCTSIN    := TFUN->
        (_cAliasSRA)->RA_ALTCBO     := 'N'
        (_cAliasSRA)->RA_SINDICA    := 
        (_cAliasSRA)->RA_PROCESS    := 
        (_cAliasSRA)->RA_ADTPOSE    := 
        (_cAliasSRA)->RA_CESTAB     := TFUN->
        (_cAliasSRA)->RA_VALEREF    := TFUN->
        (_cAliasSRA)->RA_SEGUROV    := TFUN->
        (_cAliasSRA)->RA_PENSALI    := TFUN->
        (_cAliasSRA)->RA_PERCADT    := TFUN->
        (_cAliasSRA)->RA_CATFUNC    := 'M'
        (_cAliasSRA)->RA_TIPOPGT    := TFUN->RECBTO
        (_cAliasSRA)->RA_SALARIO    := TFUN->
        (_cAliasSRA)->RA_PERICUL    := TFUN->
        (_cAliasSRA)->RA_INSMIN     := TFUN->
        (_cAliasSRA)->RA_INSMED     := TFUN->
        (_cAliasSRA)->RA_INSMAX     := TFUN->
        (_cAliasSRA)->RA_TIPOADM    := TFUN->
        (_cAliasSRA)->RA_AFASFGT    := TFUN->
        (_cAliasSRA)->RA_VIEMRAI    := TFUN->
        (_cAliasSRA)->RA_GRINRAI    := TFUN->
        (_cAliasSRA)->RA_RESCRAI    := TFUN->
        (_cAliasSRA)->RA_MESTRAB    := TFUN->
        (_cAliasSRA)->RA_ALTEND     := 'N'
        (_cAliasSRA)->RA_ALTCP      := 'N'
        (_cAliasSRA)->RA_ALTPIS     := 'N'
        (_cAliasSRA)->RA_ALTADM     := 'N'
        (_cAliasSRA)->RA_ALTOPC     := 'N'
        (_cAliasSRA)->RA_ALTNOME    := 'N'
        (_cAliasSRA)->RA_CODRET     := '0561'
        (_cAliasSRA)->RA_CRACHA     := TFUN->
        (_cAliasSRA)->RA_REGRA      := TFUN->
        (_cAliasSRA)->RA_SEQTURN    := TFUN->
        (_cAliasSRA)->RA_SENHA      := TFUN->
        (_cAliasSRA)->RA_TPCONTR    := TFUN->
        (_cAliasSRA)->RA_APELIDO    := TFUN->
        (_cAliasSRA)->RA_PERCSAT    := 0
        (_cAliasSRA)->RA_BHFOL      := TFUN->
        (_cAliasSRA)->RA_BRPDH      := TFUN->
        (_cAliasSRA)->RA_ACUMBH     := 'N'
        (_cAliasSRA)->RA_RACACOR    := TFUN->
        (_cAliasSRA)->RA_RECMAIL    := 'N'
        (_cAliasSRA)->RA_EMAIL      := TFUN->
        (_cAliasSRA)->RA_PERFGTS    := 0
        (_cAliasSRA)->RA_TPMAIL     := '1'
        (_cAliasSRA)->RA_MSBLQL     := TFUN->
        (_cAliasSRA)->RA_TPDEFFI    := '0'
        (_cAliasSRA)->RA_RESEXT     := '2'
        (_cAliasSRA)->RA_CLAURES    := '1'
        (_cAliasSRA)->RA_HOPARC     := '2'
        (_cAliasSRA)->RA_COMPSAB    := '2'
        (_cAliasSRA)->RA_MUNNASC    := TFUN->
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
