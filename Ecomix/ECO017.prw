
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*/
Função			:	ECO017
Autor			:	Alexandro da Silva
Data 			: 	21/02/17
Descrição		: 	Atualiza Demonstrativo de Resultado (Tabela ZA5)
/*/

User Function ECO017(_aParam)

    If ValType(_aParam) = 'U'
        Private _lSched := .F.
    Else
        Private _lSched := .T.
    Endif

    Private dPartir := dDtAte := Ctod("  /  /  ")

    If !_lSched

        PRIVATE oDlg := NIL
        PRIVATE cTitulo    	:= "Atualizar DRE"
        PRIVATE _dFirstD,_dLastD
        PRIVATE cPerg   	:= "ECO017"

        Private _cMsg01    	:= ''
        Private _lFim      	:= .F.
        Private _lAborta01 	:= .T.
        Private _lSchedule  := If(_lSched = Nil, .F.,.T.)

        ATUSX1()

        _nOpc := 0
        DEFINE MSDIALOG oDlg FROM 0,0 TO 130,320 TITLE cTitulo OF oDlg PIXEL

        TGroup():New( 005,005,060,155,"",oDlg,CLR_HRED,CLR_WHITE,.T.,.F. )

        @ 015,015 SAY "Esta rotina tem por objetivo gerar os Dados para o   " OF oDlg PIXEL Size 150,010
        @ 025,015 SAY "DEMONSTRATIVO DE RESULTADO - Visao Gerencial.        " OF oDlg PIXEL Size 150,010

        @ 40,015 BUTTON "Parametros" SIZE 040,012 ACTION (Pergunte("ECO017",.T.)) 	OF oDlg PIXEL
        @ 40,060 BUTTON "OK" 		 SIZE 040,012 ACTION (_nOpc := 1,oDlg:End()) 	OF oDlg PIXEL
        @ 40,105 BUTTON "Sair"       SIZE 040,012 ACTION ( oDlg:End()) 				OF oDlg PIXEL

        ACTIVATE MSDIALOG oDlg CENTERED

        If _nOpc = 1

            // Private _bAcao01       := {|_lFim| ECO017A(@_lFim) }    /// CONFORME SZQ VISAO 001
            // Private _cTitulo01 := 'Processando...'
            // Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

            // Private _bAcao01       := {|_lFim| ECO017B(@_lFim) }    /// CONFORME CONTABILIDADE VISAO 002
            // Private _cTitulo01 := 'Processando...'
            // Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

            Private _bAcao01       := {|_lFim| ECO017C(@_lFim) }    /// CONFORME SD2 E SD1 VISAO 003
            Private _cTitulo01 := 'Processando...'
            Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
        Endif
    Else
        ECO17_01(_lSched)
    Endif

Return(Nil)


Static Function ECO17_01(_lSched)

    LOcal AX
    Private dPartir   := dDtAte := Ctod("  /  /  ")
    Private cRevisao  := Space(4)
    Private cFonteZZD := ''
    Private cDoc      := Space(06)
    Private cSerie    := Space(03)
    Private cCliente  := Space(06)
    Private cLoja     := Space(02)

    If Select("SX2") == 0
        RpcSetType(3)
        RpcSetEnv("01","01",,,"COM",GetEnvServer(),{"ZZD"})
    EndIf

//_aEmpresa := {"02","04","09","13","16","50"} 
    _aEmpresa := {"04","13","16","50"}
    _aFiliais := {}

    For AX:= 1 To Len(_aEmpresa)

        _cEmpresa := _aEmpresa[AX]

        SM0->(dbSetOrder(1))
        If SM0->(dbSeek(_cEmpresa))

            _cChavSM0 := SM0->M0_CODIGO

            While SM0->(!Eof()) .And. _cChavSM0 == SM0->M0_CODIGO

                AADD( _aFiliais,{_cEmpresa,SM0->M0_CODFIL})

                SM0->(dbSkip())
            EndDo
        Endif
    Next AX

    For AX:= 1 To Len(_aFiliais)

        _cCodEmp  := Left(_aFiliais[AX],2)
        _cCodFil  := Right(_aFiliais[AX],2)

        If Select('SM0')>0
            nRecno := SM0->(Recno())
            RpcClearEnv()
        Endif

        OpenSM0()

        If SM0->(dbSeek(_cCodEmp + _cCodFil , .F. ) )
            RpcSetType(3)
            RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL,'schedule','schedule','FAT',,{"SZB"})
        Else
            CONOUT("NAO ACHOU EMPRESA ...")
            SM0->(dbGotop())
            dbCloseAll()
            RpcClearEnv()
        Endif

        CONOUT("ATUALIZANDO MAPINHA DA EMPRESA "+_aFiliais[AX][1]+" Filial: "+_aFiliais[AX][2])

        // ECO017A(_lSched,_aFiliais[AX][1],_aFiliais[AX][2])
        // ECO017B(_lSched,_aFiliais[AX][1],_aFiliais[AX][2])
        ECO017C(_lSched,_aFiliais[AX][1],_aFiliais[AX][2])
        CONOUT("ATUALIZADO  MAPINHA DA EMPRESA "+_aFiliais[AX][1]+" Filial: "+_aFiliais[AX][2])

    Next AX

    If _cCodEmp != cEmpAnt .And. _cCodFil != cFilAnt
        If Select("SX2") > 0
            CONOUT("Fechando Ambiente")
            RpcClearEnv()
        Endif
    Endif

Return


Static Function ECO017C(_lSched)

    If !_lSched
        Pergunte("ECO017",.F.)

        _cAno1   := LEFT(DTOS(STOD(LEFT(DTOS(MV_PAR01),4)+"0101")-1),4)
        _cAnoAnt := _cAno1 + "01"
        _cAnoFim := _cAno1 + "12"
    Else
        MV_PAR01 := dDataBase

        _cAno1   := LEFT(DTOS(STOD(LEFT(DTOS(MV_PAR01),4)+"0101")-30),4)
        _cAnoAnt := _cAno1 + "01"
        _cAnoFim := _cAno1 + "12"

        CONOUT(MV_PAR01)
    Endif

    _cVisao  := Alltrim(GetMv("AST_VISAO3"))
    // _cVis1  := Alltrim(GetMv("AST_VISAO3"))
    // _cVisao := "('"

    // For Ax:= 1 To Len(_cVis1)
    //     If Substr(_cVis1,AX,1) != "*"
    //         _cVisao += Substr(_cVis1,AX,1)
    //     Else
    //         _cVisao += "','"
    //     Endif
    // Next AX

    // _cVisao += "')"

    _dFirstD  := FirstDay(MV_PAR01)
    _dLastD   := LastDay(MV_PAR02)

    // _cQ := " DELETE "+RetSqlName("ZA5")+" WHERE ZA5_CODEMP = '"+cEmpAnt+"' "
    // _cQ += " AND ZA5_PERIOD BETWEEN  '"+_cAnoAnt+"' AND '"+_cAnoFim+"' AND ZA5_CODPLA = '"+_cVisao+"' "
    // _cQ += " AND ZA5_PERIOD BETWEEN  '"+_cAnoAnt+"' AND '"+_cAnoFim+"' AND ZA5_CODPLA IN "+_cVisao+" "

    // TCSQLEXEC(_cQ)

    _cQ := " DELETE "+RetSqlName("ZA5")+" WHERE ZA5_CODEMP = '"+cEmpAnt+"' "
    _cQ += " AND ZA5_PERIOD BETWEEN '"+LEFT(DTOS(_dFirstD),6)+"' AND '"+LEFT(DTOS(_dLastD),6)+"' AND ZA5_CODPLA = '"+_cVisao+"' "
    // _cQ += " AND ZA5_PERIOD BETWEEN '"+LEFT(DTOS(_dFirstD),6)+"' AND '"+LEFT(DTOS(_dLastD),6)+"' AND ZA5_CODPLA IN "+_cVisao+" "

    TCSQLEXEC(_cQ)


    If Select("TZ17") > 0
        TZ17->(dbCloseArea())
    Endif

    _cQryZ17 := " SELECT * FROM "+RetSqlName("Z17")+" Z17 (NOLOCK) " + CRLF
    _cQryZ17 += " WHERE Z17.D_E_L_E_T_ = '' " + CRLF
    _cQryZ17 += " AND Z17_ORIGEM = '02' " + CRLF
    _cQryZ17 += " ORDER BY Z17_CODPLA,Z17_ORDEM,Z17_CONTAG,Z17_LINHA " + CRLF

    TcQuery _cQryZ17 New Alias "TZ17"

    If Contar("TZ17","!EOF()") > 0

        TZ17->(dbGoTop())

        While TZ17->(!EOF())

            _cKey1 := TZ17->Z17_CODPLA
            While TZ17->(!EOF()) .And. _cKey1 == TZ17->Z17_CODPLA

                _cKey2 := TZ17->Z17_CODPLA + TZ17->Z17_ORDEM
                While TZ17->(!EOF()) .And. _cKey2 == TZ17->Z17_CODPLA + TZ17->Z17_ORDEM

                    _cKey3 := TZ17->Z17_CODPLA + TZ17->Z17_ORDEM + TZ17->Z17_CONTAG
                    While TZ17->(!EOF()) .And. _cKey3 == TZ17->Z17_CODPLA + TZ17->Z17_ORDEM + TZ17->Z17_CONTAG

                        If Select("TZZD") > 0
                            TZZD->(dbCloseArea())
                        Endif

                        _cQryZZD := " SELECT ZZD_CODEMP AS CODEMP,ZZD_CODFIL AS CODFIL, ZZD_ANOMES AS ANOMES, ZZD_QTLIQ AS QTDE, ZZD_TOTNFG AS TOTAL,ZZD_EMIS AS EMISSAO " + CRLF
                        _cQryZZD += " FROM "+RetSqlName("ZZD")+" ZZD (NOLOCK) " + CRLF
                        _cQryZZD += " WHERE ZZD.D_E_L_E_T_ = '' " + CRLF
                        _cQryZZD += " AND ZZD_EMIS              BETWEEN '"+DTOS(_dFirstD)+"'   AND '"+DTOS(_dLastD)+"'  " + CRLF
                        _cQryZZD += " AND ZZD_CODEMP            BETWEEN '"+TZ17->Z17_EMPINI+"' AND '"+TZ17->Z17_EMPFIM+"' " + CRLF
                        _cQryZZD += " AND ZZD_CODFIL            BETWEEN '"+TZ17->Z17_FILINI+"' AND '"+TZ17->Z17_FILFIM+"' " + CRLF
                        _cQryZZD += " AND ZZD_CFOP              BETWEEN '"+TZ17->Z17_CFOINI+"' AND '"+TZ17->Z17_CFOFIM+"' " + CRLF
                        _cQryZZD += " AND ZZD_GRUPO             BETWEEN '"+TZ17->Z17_GPRINI+"' AND '"+TZ17->Z17_GPRFIM+"' " + CRLF
                        _cQryZZD += " AND ZZD_PROD              BETWEEN '"+TZ17->Z17_PROINI+"' AND '"+TZ17->Z17_PROFIM+"' " + CRLF
                        _cQryZZD += " AND ZZD_CLIE+ZZD_LOJA     BETWEEN '"+TZ17->Z17_CLIINI+"' AND '"+TZ17->Z17_CLIFIM+"' " + CRLF
                        // _cQryZZD += " AND ZZD_                 BETWEEN '"+TZ17->Z17_CLAINI+"' AND '"+TZ17->Z17_CLAFIM+"' " + CRLF
                        // _cQryZZD += " AND ZZD_                 BETWEEN '"+TZ17->Z17_FORINI+"' AND '"+TZ17->Z17_FORFIM+"' " + CRLF
                        // _cQryZZD += " AND ZZD_                 BETWEEN '"+TZ17->Z17_CTAINI+"' AND '"+TZ17->Z17_CTAFIM+"' " + CRLF
                        // _cQryZZD += " AND ZZD_                 BETWEEN '"+TZ17->Z17_CRINI+"'  AND '"+TZ17->Z17_CRFIM+"' " + CRLF
                        // _cQryZZD += " AND ZZD_                 BETWEEN '"+TZ17->Z17_ITEiNI+"' AND '"+TZ17->Z17_ITEFIM+"' " + CRLF
                        _cQryZZD += " ORDER BY CODEMP,CODFIL,EMISSAO " + CRLF

                        TcQuery _cQryZZD New Alias "TZZD"

                        If Contar("TZZD","!EOF()") > 0

                            TZZD->(dbGoTop())

                            While TZZD->(!EOF())

                                _nQtVl := 0
                                If TZ17->Z17_TPVISA = '01' //Quantidade
                                    _nQtVl := TZZD->QTDE
                                ElseIf TZ17->Z17_TPVISA = '01' //Quantidade
                                    _nQtVl := TZZD->TOTAL
                                Endif

                                If _nQtVl <> 0
                                    ZA5->(dbSetorder(2))
                                    If ZA5->(dbSeek(xFilial("ZA5" ) + TZZD->CODEMP + TZZD->CODFIL + TZ17->Z17_CODPLA + TZ17->Z17_LINHA + TZ17->Z17_CONTAG + Left(TZZD->EMISSAO,6) ))
                                        ZA5->(RecLock("ZA5",.F.))
                                        ZA5->ZA5_VALOR	 += _nQtVl
                                        ZA5->(MsUnLock())
                                    Else
                                        ZA5->(RecLock("ZA5",.T.))
                                        ZA5->ZA5_FILIAL	 := xFilial("ZA5")
                                        ZA5->ZA5_CODEMP  := TZZD->CODEMP
                                        ZA5->ZA5_CODFIL  := TZZD->CODFIL
                                        ZA5->ZA5_CODPLA	 := TZ17->Z17_CODPLA
                                        ZA5->ZA5_LINHA	 := TZ17->Z17_LINHA
                                        ZA5->ZA5_CONTAG	 := TZ17->Z17_CONTAG
                                        ZA5->ZA5_DESCCG	 := TZ17->Z17_DESCGE
                                        ZA5->ZA5_VALOR	 := _nQtVl
                                        ZA5->ZA5_PERIOD  := Left(TZZD->EMISSAO,6) 
                                        ZA5->ZA5_DATA    := STOD(TZZD->EMISSAO)
                                        ZA5->ZA5_ORDEM   := TZ17->Z17_ORDEM
                                        ZA5->(MsUnLock())
                                    Endif
                                Endif

                                TZZD->(dbSkip())
                            EndDo
                        Endif

                        TZZD->(dbCloseArea())

                        TZ17->(dbSkip())
                    EndDo
                EndDo
            EndDo
        EndDo

    Endif

    TZ17->(dbCloseArea())

Return(Nil)



Static Function AtuSX1()

    cPerg := "ECO017"
    aRegs := {}

//    	   Grupo/Ordem/Pergunta      /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01             /defspa1/defeng1/Cnt01/Var02/Def02            /Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
    U_CRIASX1(cPerg,"01","Data De ?     ",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR01",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
    U_CRIASX1(cPerg,"02","Data Ate ?    ",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""            ,"MV_PAR02",""               ,""     ,""     ,""   ,""   ,""               ,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return
