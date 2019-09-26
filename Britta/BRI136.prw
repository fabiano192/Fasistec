#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BRI136    ºAutor  ³ Alexandro          º Data ³  21/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Manutenção nos Pagamentos Provisorios                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ sigafin                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BRI136()

    LOCAL aAlias	:={},cSavRegua

    ATUSX1()
    ATUSX1B()

    Private aRotina := {{"Pesquisar" 	,"AxPesqui",0,1} ,;
        {"Visualizar"   ,"U_B13601",0,2} ,;
        {"Incluir"      ,"U_B13601",0,3} ,;
        {"Alterar"      ,"U_B13601",0,4} ,;
        {"Excluir"      ,"U_B13601",0,5} ,;
        {"Prorrogacao"  ,"U_B13606",0,6} ,;
        {"Exclusao Lote","U_B13606",0,7} }

    Private cDelFunc := ".T."
    Private cCadastro:= "Manutenção dos Titulos Provisorios"

    dbSelectArea("SE2")
    SE2->(dbSetOrder(1))

    _cFiltro := "E2_TIPO = 'PR '"
    Set Filter to &_cFiltro

    _aCor := {	{"E2_SALDO = 0"     ,'BR_VERMELHO'},;
        {"E2_SALDO > 0"     ,'BR_VERDE'}}

    MBrowse( 6,1,22,75,"SE2",,,,, 2,_aCor )

Return .T.



User Function B13601(cAlias, nReg, nOpc1)

    _lParar := .T.
    cTitulo := "Mantuençao Provisao"

    Private aSize	  := MsAdvSize()
    Private aObjects  := {}
    Private aPosObj   := {}
    Private aSizeAut  := MsAdvSize() // devolve o tamanho da tela atualmente no micro do usuario

    AAdd( aObjects, { 100, 100, .T., .t. } )
    AAdd( aObjects, { 100, 100, .t., .t. } )
    AAdd( aObjects, { 100, 015, .t., .t. } )

    aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
    aPosObj := MsObjSize( aInfo, aObjects,.T. )

    SA2->(dbSetOrder(1))
    SA2->(dbSeek(xFilial("SA2")+SE2->E2_FORNECE + SE2->E2_LOJA))

    _cPrefixo := SE2->E2_PREFIXO
    _cNum     := SE2->E2_NUM
    _cParcela := SE2->E2_PARCELA
    _cTipo    := SE2->E2_TIPO
    _cFornece := SE2->E2_FORNECE
    _cLoja    := SE2->E2_LOJA
    _cNaturez := SE2->E2_NATUREZ
    _dEmissao := SE2->E2_EMIS1
    _dVencto  := SE2->E2_VENCTO
    _dVencRea := SE2->E2_VENCREA
    _nValor   := SE2->E2_VALOR
    _nSaldo   := SE2->E2_SALDO
    _cNomeFor := SA2->A2_NOME
    _cTpProv  := SE2->E2_XTPPROV
    _cHistor  := SE2->E2_HIST

    _lAlt2 := .F.
    If nOpc1 == 2   // VISUALIZAR
        _lAltera := .F.
    ElseIf nOpc1 == 3  // INCLUIR
        _lAltera := .T.
        _lAlt2   := .T.
        _cPrefixo := "PR "

        _cQ  := " SELECT MAX(E2_NUM) AS NUMERO FROM "+RetSqlName("SE2")+" A WHERE E2_TIPO = 'PR' "
        _cQ  += " AND A.D_E_L_E_T_ = '' "

        TCQUERY _cq NEW ALIAS "ZZ"

        If Empty(ZZ->NUMERO)
            _cNum := "000001"
        Else
            _cNum := Soma1(StrZero(Val(ZZ->NUMERO),6))
        Endif

        ZZ->(dbCloseArea())
        _cParcela := Space(01)
        _cTipo    := "PR "
        _cFornece := Space(06)
        _cLoja    := Space(02)
        _cNaturez := Space(10)
        _dEmissao := dDataBase
        _dVencto  := dDataBase
        _dVencRea := dDataBase
        _nValor   := 0
        _nSaldo   := 0
        _cNomeFor := Space(40)
        _aItem    := {"Fornecedor","Natureza"}
        _cTpProv  := "F"
    ElseIf nOpc1 == 4  // ALTERAR
        _lAltera := .F.
        _lAlt2   := .T.
    ElseIf nOpc1 == 5  // EXCLUIR
        _lAltera := .F.
    Endif

    _nOpc := 0
//DEFINE MSDIALOG oDlg TITLE cTitulo From 10,0 to 190,640 of oMainWnd PIXEL
    DEFINE MSDIALOG oDlg TITLE cTitulo From 10,0 to 210,640 of oMainWnd PIXEL

//@ 05,aPosObj[2,2] TO 85,320
    @ 05,aPosObj[2,2] TO 098,320

    @ 15,010 Say "Prefixo: "
    @ 15,040 GET _cPrefixo        WHEN .F.      Valid B13603() PICTURE "@!"   SIZE 20,20
    @ 15,065 Say "Numero: "
    @ 15,090 Get _cNum            WHEN .F.      Valid B13604()               SIZE 50,20
    @ 15,144 Say "Parc: "
    @ 15,164 GET _cParcela        WHEN .F.      Valid B13603() PICTURE "@!"   SIZE 20,20
    @ 15,190 Say "Fornecedor: "
    @ 15,220 GET _cFornece        WHEN _lAltera Valid B13602() .And. !Empty(_cFornece) F3 "SA2" PICTURE "@!" SIZE 40,20
    @ 15,265 Say "Loja: "
    @ 15,280 GET _cLoja           WHEN _lAltera Valid B13603() SIZE 30,20

    @ 35,010 Say "Natureza:"
    @ 35,040 GET _cNaturez        WHEN _lAlt2   Valid (ExistCpo("SED",_cNaturez)) F3 "SED" PICTURE "@!" SIZE 50,20
    @ 35,095 Say "Emissao:"
    @ 35,125 GET _dEmissao        WHEN _lAltera Valid (!Empty(_dEmissao)) SIZE 50,20
    @ 35,190 Say "Vencimento:"
    @ 35,235 GET _dVencto         WHEN _lAlt2   Valid (!Empty(_dVencto) .And. _dVencto >= _dEmissao)  SIZE 50,20

    @ 55,010 Say "Valor:"
    @ 55,040 GET _nValor          WHEN _lAlt2   Valid B13605()  PICTURE "@E 99,999,999.99" SIZE 50,20
    @ 55,095 Say "Saldo:"
    @ 55,125 GET _nSaldo          WHEN .F.      PICTURE "@E 999,999.99" SIZE 50,20
    @ 55,190 Say "Tp Provisao:"
    @ 55,235 COMBOBOX _cTpProv   ITEMS {"F=Fornecedor","N=Natureza"} SIZE 50,50

    @ 070,010  Say "Nome Fornecedor: "
    @ 070,060  GET _cNomeFor   WHEN .F.    SIZE 150,30

    @ 085,010  Say "Historico: "
    @ 085,060  GET _cHistor    WHEN _lAlt2 SIZE 150,30

    @ 080,240 BMPBUTTON TYPE 1  ACTION (_nOpc:=1,oDlg:END())
    @ 080,280 BMPBUTTON TYPE 2  ACTION oDlg:END()


    ACTIVATE MSDIALOG oDlg Centered

    If _nOpc == 1
        If nOpc1 == 3  // INCLUIR
            SE2->(RecLock("SE2",.T.))
            SE2->E2_FILIAL  := xFilial("SE2")
            SE2->E2_PREFIXO := _cPrefixo
            SE2->E2_NUM     := _cNum
            SE2->E2_PARCELA := _cParcela
            SE2->E2_TIPO    := "PR"
            SE2->E2_FORNECE := _cFornece
            SE2->E2_LOJA    := _cLoja
            SE2->E2_NATUREZ := _cNaturez
            SE2->E2_NOMFOR  := _cNomeFor
            SE2->E2_HIST    := _cHistor
            SE2->E2_EMISSAO := _dEmissao
            SE2->E2_EMIS1   := _dEmissao
            SE2->E2_VENCTO  := _dVencto
            SE2->E2_VENCREA := _dVencto
            SE2->E2_VENCORI := _dVencto
            SE2->E2_VALOR   := _nValor
            SE2->E2_SALDO   := _nValor
            SE2->E2_VLCRUZ  := _nValor
            SE2->E2_MOEDA   := 1
            SE2->E2_OCORREN := "01"
            SE2->E2_ORIGEM  := "BRI136"
            SE2->E2_FLUXO   := "S"
            SE2->E2_FILORIG := cFilAnt
            SE2->E2_XTPPROV := _cTpProv
            SE2->(MsUnlock())
        ElseIf nOpc1 == 4  // ALTERAR
            SE2->(RecLock("SE2",.F.))
            SE2->E2_NATUREZ := _cNaturez
            SE2->E2_VENCTO  := _dVencto
            SE2->E2_VENCREA := _dVencto
            SE2->E2_VALOR   := _nValor
            SE2->E2_SALDO   := _nValor
            SE2->E2_VLCRUZ  := _nValor
            SE2->E2_XTPPROV := _cTpProv
            SE2->E2_HIST    := _cHistor
            SE2->(MsUnlock())
        ElseIf nOpc1 == 5  // EXCLUIR
            SE2->(RecLock("SE2",.F.))
            SE2->(dbDelete())
            SE2->(MsUnlock())
        Endif
    Endif

Return

Static Function ATUSX1()

    cPerg := "BRI136"

//    	   Grupo/Ordem/Pergunta                  /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01        /defspa1/defeng1/Cnt01/Var02/Def02               /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
    U_CRIASX1(cPerg,"01","Fornecedor De        	   ?",""       ,""      ,"mv_ch1","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR01","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"SA2")
    U_CRIASX1(cPerg,"02","Fornecedor Ate       	   ?",""       ,""      ,"mv_ch2","C" ,06     ,0      ,0     ,"G",""        ,"MV_PAR02","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"SA2")
    U_CRIASX1(cPerg,"03","Loja De             	   ?",""       ,""      ,"mv_ch3","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR03","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
    U_CRIASX1(cPerg,"04","Loja Ate             	   ?",""       ,""      ,"mv_ch4","C" ,02     ,0      ,0     ,"G",""        ,"MV_PAR04","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
    U_CRIASX1(cPerg,"05","Natureza De         	   ?",""       ,""      ,"mv_ch5","C" ,10     ,0      ,0     ,"G",""        ,"MV_PAR05","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"SED")
    U_CRIASX1(cPerg,"06","Natureza Ate         	   ?",""       ,""      ,"mv_ch6","C" ,10     ,0      ,0     ,"G",""        ,"MV_PAR06","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"SED")
    U_CRIASX1(cPerg,"07","Emissao De          	   ?",""       ,""      ,"mv_ch7","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR07","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
    U_CRIASX1(cPerg,"08","Emissao Ate          	   ?",""       ,""      ,"mv_ch8","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR08","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
    U_CRIASX1(cPerg,"09","Vencimento De       	   ?",""       ,""      ,"mv_ch9","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR09","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")
    U_CRIASX1(cPerg,"10","Vencimento Ate       	   ?",""       ,""      ,"mv_cha","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR10","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")

Return


Static Function ATUSX1B()

    cPerg := "BRI136B"

//    	   Grupo/Ordem/Pergunta                  /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid          /Var01     /Def01        /defspa1/defeng1/Cnt01/Var02/Def02               /Defspa2/defeng2/Cnt02/Var03/Def03  /defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
    U_CRIASX1(cPerg,"01","Novo Vencimento     	   ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""        ,"MV_PAR01","              ",""     ,""     ,""   ,""   ,"                 ",""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""  ,"")


Return



Static Function B13602()

    _cFornece := UPPER(_cFornece)
    _cLoja    := SA2->A2_LOJA
    _lRet     := .T.


    SA2->(dbSetOrder(1))
    If SA2->(dbSeek(xFilial("SA2")+_cFornece+ _cLoja))
        _cLoja    := SA2->A2_LOJA
        _cNomeFor := SA2->A2_NOME

        If SA2->A2_MSBLQL == "1"
            MSGSTOP("Fornecedor Bloqueado!!!")
            Return(.F.)
        Endif

        SE2->(dbSetOrder(1))
        If SE2->(dbSeek(xFilial("SE2")+ _cPrefixo + _cNum+Space(03) + _cParcela + _cTipo + _cFornece + _cLoja))
            _lRet := .F.
            MSGSTOP("Titulo Ja Cadastrado!!!")
        Endif
    Else
        _lRet := .F.
        MSGSTOP("Fornecedor Nao Cadastrado!!!")
    Endif


Return(_lRet)

Static Function B13603()

    _lRet := .T.

    If !Empty(_cFornece) .And.!Empty(_cLoja)
        SA2->(dbSetOrder(1))
        If SA2->(dbSeek(xFilial("SA2")+_cFornece+ _cLoja))
            _cLoja    := SA2->A2_LOJA
            SE2->(dbSetOrder(1))
            If SE2->(dbSeek(xFilial("SE2")+ _cPrefixo + _cNum+Space(03) + _cParcela + _cTipo + _cFornece + _cLoja))
                _lRet := .F.
                MSGSTOP("Titulo Ja Cadastrado!!!")
            Endif
        Else
            _lRet := .F.
            MSGSTOP("Fornecedor Nao Cadastrado!!!")
        Endif
    Endif

Return(_lRet)


Static Function B13604()

    _lRet := .T.

    If Empty(_cNum)
        _lRet := .F.
    Else
        _cNum := StrZero(Val(_cNum),6)

        If !Empty(_cFornece) .And.!Empty(_cLoja)
            SA2->(dbSetOrder(1))
            If SA2->(dbSeek(xFilial("SA2")+_cFornece+ _cLoja))
                _cLoja    := SA2->A2_LOJA
                SE2->(dbSetOrder(1))
                If SE2->(dbSeek(xFilial("SE2")+ _cPrefixo + _cNum+Space(03) + _cParcela + _cTipo + _cFornece + _cLoja))
                    _lRet := .F.
                    MSGSTOP("Titulo Ja Cadastrado!!!")
                Endif
            Else
                _lRet := .F.
                MSGSTOP("Fornecedor Nao Cadastrado!!!")
            Endif
        Endif
    Endif

Return(_lRet)


Static Function B13605()

    _lRet := .T.

    If _nValor <= 0
        _lRet := .F.
    Else
        _nSaldo := _nValor
    Endif

Return(_lRet)



User Function B13606(cAlias, nReg, nOpc1)

    If !Pergunte("BRI136",.T.)
        Return
    Endif

    _cPAR01 := MV_PAR01
    _cPAR02 := MV_PAR02
    _cPAR03 := MV_PAR03
    _cPAR04 := MV_PAR04
    _cPAR05 := MV_PAR05
    _cPAR06 := MV_PAR06
    _cPAR07 := MV_PAR07
    _cPAR08 := MV_PAR08
    _cPAR09 := MV_PAR09
    _cPAR10 := MV_PAR10

    If nOpc1 == 6  // PRORROGACAO

        If !Pergunte("BRI136B",.T.)
            Return
        Endif

        _cQ := " UPDATE "+RetSqlName("SE2")+" SET E2_VENCTO = '"+DTOS(MV_PAR01)+"', E2_VENCREA = '"+DTOS(MV_PAR01)+"' FROM "+RetSqlName("SE2")+" A "
        _cQ += " WHERE A.D_E_L_E_T_ = '' AND E2_TIPO = 'PR' AND E2_SALDO > 0 "
        _cQ += " AND E2_FORNECE BETWEEN '"+_cPAR01+"' AND '"+_cPAR02+"' AND E2_LOJA   BETWEEN '"+_cPAR03+"'       AND '"+_cPAR04+"' "
        _cQ += " AND E2_NATUREZ BETWEEN '"+_cPAR05+"' AND '"+_cPAR06+"' AND E2_EMIS1  BETWEEN '"+DTOS(_cPAR07)+"' AND '"+DTOS(_cPAR08)+"' "
        _cQ += " AND E2_VENCREA BETWEEN '"+DTOS(_cPAR09)+"' AND '"+DTOS(_cPAR10)+"' AND E2_EMISSAO <= '"+DTOS(MV_PAR01)+"' "

        TcSqlExec(_cQ)

    ElseIf nOpc1 == 7  // EXCLUSAO

        If MSGYESNO("Realmente Deseja Excluir??")

            _cQ := " DELETE "+RetSqlName("SE2")+" WHERE D_E_L_E_T_ = '' AND E2_TIPO = 'PR' "
            _cQ += " AND E2_FORNECE BETWEEN '"+_cPAR01+"' AND '"+_cPAR02+"' AND E2_LOJA   BETWEEN '"+_cPAR03+"'       AND '"+_cPAR04+"' "
            _cQ += " AND E2_NATUREZ BETWEEN '"+_cPAR05+"' AND '"+_cPAR06+"' AND E2_EMIS1  BETWEEN '"+DTOS(_cPAR07)+"' AND '"+DTOS(_cPAR08)+"' "
            _cQ += " AND E2_VENCREA BETWEEN '"+DTOS(_cPAR09)+"' AND '"+DTOS(_cPAR10)+"' "

            TcSqlExec(_cQ)
        Endif
    Endif

Return