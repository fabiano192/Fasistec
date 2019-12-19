#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} SZ2010
Manutenção de dados em SZ2-TAB. CLI X PROD X PRECO.
/*/

User Function SZ2010()

    //Indica a permissão ou não para a operação (pode-se utilizar 'ExecBlock')
    Local _cVldAlt	:= "U_VldAltSZ2()" // Operacao: ALTERACAO
    Local _cVldExc	:= "U_VldExcSZ2(1)" // Operacao: EXCLUSAO
    Local _aRotAdic	:= {{ "Histórico","U_Z2HIST", 0 , 6 }}

    chkFile("SZ2")

    SZ2->(dbSetOrder(1))

    axCadastro("SZ2", "TAB. CLI X PROD X PRECO", _cVldExc, _cVldAlt,_aRotAdic)

Return(Nil)



User Function Z2HIST()

    Local _oDlg1	:= Nil
    Local _cQry		:= ''
    Local _oFont2	:= Nil
    Local _oTBut5	:= Nil

    Local _oOK		:= LoadBitmap(GetResources(),'BR_VERDE')
    Local _oNO		:= LoadBitmap(GetResources(),'BR_AZUL')

    If Select("TSB") > 0
        TSB->(dbCloseArea())
    Endif

    _cQry := " SELECT ZF1.R_E_C_N_O_ AS ZF1RECNO,* FROM "+RetSqlName("ZF1")+" ZF1 " + CRLF
    _cQry += " WHERE ZF1.D_E_L_E_T_ = '' " + CRLF
    _cQry += " AND ZF1_FILIAL 	= '"+SZ2->Z2_FILIAL+"' " + CRLF
    _cQry += " AND ZF1_PRODUT 	= '"+SZ2->Z2_PRODUTO+"' " + CRLF
    _cQry += " AND ZF1_CLIENT 	= '"+SZ2->Z2_CLIENTE+"' " + CRLF
    _cQry += " AND ZF1_LOJA 	= '"+SZ2->Z2_LOJA+"' " + CRLF
    _cQry += " ORDER BY ZF1_FILIAL, ZF1_CLIENT,ZF1_LOJA,ZF1_PRODUT,ZF1_DTEMIS "	+ CRLF

    TcQuery _cQry New Alias "TSB"

    Count to _nTSB

    If _nTSB = 0
        MsgAlert("Não foi encontrado Histórico de alteração de preço!")
        TSB->(dbCloseArea())
        Return(Nil)
    Endif

    TcSetField("TSB","ZF1_DTEMIS","D")

    TSB->(dbGoTop())

    _aBlq := {}

    While TSB->(!EOF())

        _lStat := If(TSB->ZF1_STATUS = 'L',.T.,.F.)

        AADD(_aBlq,{;
            _lStat,; //01
        TSB->ZF1_FILIAL	,; //02
        TSB->ZF1_CLIENT	,; //03
        TSB->ZF1_LOJA	,; //04
        TSB->ZF1_NOME	,; //05
        TSB->ZF1_PRODUT	,; //06
        TSB->ZF1_DTEMIS	,; //07
        TSB->ZF1_PRCANT	,; //08
        TSB->ZF1_PRCATU	,; //09
        TSB->ZF1_PRCATU - TSB->ZF1_PRCANT ,; //10
        TSB->ZF1_USUARI	,; //11
        TSB->ZF1RECNO	,; //12
        TSB->ZF1_PROCES	}) //13

        TSB->(dbSkip())
    EndDo

    TSB->(dbCloseArea())

    DEFINE MSDIALOG _oDlg1 TITLE OemToAnsi("Histórico") FROM 0,0 TO 300,1000 OF _oDlg1 PIXEL

    DEFINE FONT _oTFont2 NAME "Arial" BOLD SIZE 0,14 OF _oDlg1

    _oSay1	:= TSay():New(05,05,{||'Abaixo o Histórico de alteração de preço.'},_oDlg1,,_oTFont2,,,,.T.,CLR_BLUE,CLR_WHITE,150,10,,,,,.T.)
    _oSay1:lTransparent := .F.

    _oTBitmap1	:= TBitmap():New(05, 200, 10, 10, NIL, "BR_VERDE"   , .T., _oDlg1,{|| }, NIL, .F., .F., NIL, NIL, .F., NIL, .T., NIL, .F.)
    _oTSay1		:= TSay():New(05,211,{||'Liberado'},_oDlg1,,_oTFont2,,,,.T.,CLR_BLACK,CLR_HGREEN,40,08,,,,,.T.)

    _oTBitmap2	:= TBitmap():New(05, 260, 10, 10, NIL, "BR_AZUL"   , .T., _oDlg1,{|| }, NIL, .F., .F., NIL, NIL, .F., NIL, .T., NIL, .F.)
    _oTSay2		:= TSay():New(05,271,{||'Pendente Liberação'},_oDlg1,,_oTFont2,,,,.T.,CLR_BLACK,CLR_HGREEN,60,08,,,,,.T.)

    _oTBut5	:= TButton():New( 05, 400, "Sair" ,_oDlg1,{||_oDlg1:End() },60,12,,_oTFont2,.F.,.T.,.F.,,.F.,,,.F. )
    _oTBut5 :cTooltip = "Sair"

    _aFields := {'','Filial','Cliente','Loja','Nome','Produto','Emissão','Preço Atual','Preço Calculado','Diferença','Usuário','Processo'}

    _oBlq := TwBrowse():New( 20, 05,490,125,,_aFields,,_oDlg1,,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)

    _oBlq:SetArray(_aBlq)

    _oBlq:bLine := {||{If(_aBlq[_oBlq:nAt,1],_oOk,_oNo ),; //1 - Marcador
    _aBlq[_oBlq:nAt,2],;
        _aBlq[_oBlq:nAt,3],;
        _aBlq[_oBlq:nAt,4],;
        _aBlq[_oBlq:nAt,5],;
        _aBlq[_oBlq:nAt,6],;
        _aBlq[_oBlq:nAt,7],;
        Transform(_aBlq[_oBlq:nAt,8],"@E 9,999,999.99"),;
        Transform(_aBlq[_oBlq:nAt,9],"@E 9,999,999.99"),;
        Transform(_aBlq[_oBlq:nAt,10],"@E 9,999,999.99"),;
        _aBlq[_oBlq:nAt,11],;
        _aBlq[_oBlq:nAt,13]}}

    _oBlq:nAt := 1
    _oBlq:Refresh()

    ACTIVATE MSDIALOG _oDlg1 CENTERED

Return(Nil)



User Function VldAltSZ2()

    Local _lRet		:= .F.
    Local _cProcLib	:= GetSxeNum('ZF1','ZF1_PROCES')
    Local _cGrAprov	:= SuperGetMV("ASC_GRPRPV",.F.,'')
    Local _nPNew	:= M->Z2_PRECO
    Local _cFil		:= xFilial("SZ2")
    Local _cCli		:= M->Z2_CLIENTE
    Local _cLoja	:= M->Z2_LOJA
    Local _cProd	:= M->Z2_PRODUTO
    Local _nPrcAt	:= 0
    Local _nDif		:= M->Z2_PRECO
    LOcal _cNome	:= M->Z2_NOME
    Local _cCodBlq	:= '03'
    Local lFirstNiv	:= .T.
    Local cAuxNivel	:= ""
    Local _AreaOri	:= GetArea()

    If Altera
        _nPrcAt		:= SZ2->Z2_PRECO
        If M->Z2_PRCBLQ <> _nPrcAt
            U_VldExcSZ2(2)
        Endif
    Endif

    _nDif		:= _nPrcAt -_nPNew
    If _nDif > 0 .Or. Inclui

        SAL->(dbSetOrder(2))
        If SAL->(!dbSeek(xFilial() + _cGrAprov))
            MSGSTOP("Grupo Não Cadastrado, Favor Contatar o Administrador do Sistema!")
            Return(_lRet)
        EndIf

        SAL->(dbSetOrder(2))
        If SAL->(dbSeek(xFilial() + _cGrAprov))

            While SAL->(!Eof()) .And. xFilial("SAL")+_cGrAprov == SAL->AL_FILIAL+SAL->AL_COD

                If lFirstNiv
                    cAuxNivel := SAL->AL_NIVEL
                    lFirstNiv := .F.
                EndIf

                SCR->(Reclock("SCR",.T.))
                SCR->CR_FILIAL	:= xFilial("SCR")
                SCR->CR_NUM		:= _cFil + _cCli + _cLoja + _cProcLib + Alltrim(_cProd)
                SCR->CR_TIPO	:= _cCodBlq
                SCR->CR_NIVEL	:= SAL->AL_NIVEL
                SCR->CR_USER	:= SAL->AL_USER
                SCR->CR_APROV	:= SAL->AL_APROV
                SCR->CR_STATUS	:= "02"
                SCR->CR_EMISSAO := dDataBase
                SCR->CR_MOEDA	:= 1
                SCR->CR_TXMOEDA := 1
                SCR->CR_OBS     := Alltrim(SM0->M0_NOME) +" - TABELA DE PREÇO"
                SCR->CR_TOTAL	:= _nPNew
                SCR->(MsUnlock())

                ZAH->(RecLock("ZAH",.T.))
                ZAH->ZAH_FILIAL:= SCR->CR_FILIAL
                ZAH->ZAH_NUM   := SCR->CR_NUM
                ZAH->ZAH_TIPO  := SCR->CR_TIPO
                ZAH->ZAH_NIVEL := SCR->CR_NIVEL
                ZAH->ZAH_USER  := SCR->CR_USER
                ZAH->ZAH_APROV := SCR->CR_APROV
                ZAH->ZAH_STATUS:= SCR->CR_STATUS
                ZAH->ZAH_TOTAL := SCR->CR_TOTAL
                ZAH->ZAH_EMISSA:= SCR->CR_EMISSAO
                ZAH->ZAH_MOEDA := SCR->CR_MOEDA
                ZAH->ZAH_TXMOED:= SCR->CR_TXMOEDA
                ZAH->ZAH_OBS   := SCR->CR_OBS
                ZAH->ZAH_TOTAL := SCR->CR_TOTAL
                ZAH->(MsUnlock())

                SAL->(dbSkip())
            EndDo
        EndIf

        ShowHelpDlg("SZ2010_1", {'Tabela de Preço Bloqueada!',;
            'Filial+Cliente+Loja: '+_cFil+"-"+_cCli +"-"+_cLoja,;
            'Produto: '+_cProd,;
            'Preço Digitado: '+Alltrim(Transform(_nPNew,"@e 999,999.99"))},4,;
            {'Solicite a liberação junto ao setor responsável.'},1)

        ZF1->(RecLock("ZF1",.T.))
        ZF1->ZF1_FILIAL	:= _cFil
        ZF1->ZF1_CLIENT	:= _cCli
        ZF1->ZF1_LOJA	:= _cLoja
        ZF1->ZF1_NOME	:= _cNome
        ZF1->ZF1_PRODUT	:= _cProd
        ZF1->ZF1_PROCES	:= _cProcLib
        ZF1->ZF1_DTEMIS	:= dDataBase
        ZF1->ZF1_PRCANT	:= _nPrcAt
        ZF1->ZF1_PRCATU	:= _nPNew
        ZF1->ZF1_STATUS	:= 'P'
        ZF1->ZF1_USUARI	:= UsrRetName(RetCodUsr())
        ZF1->(MsUnLock())

        ConfirmSX8()

        M->Z2_PRECO := _nPrcAt
        M->Z2_PROCES := _cProcLib
        M->Z2_PRCBLQ := _nPNew

        If Inclui
            M->Z2_LIBERAD:= 'B'
        Endif

        _lRet := .T.

    ElseIf _nDif < 0

        ZF1->(RecLock("ZF1",.T.))
        ZF1->ZF1_FILIAL	:= _cFil
        ZF1->ZF1_CLIENT	:= _cCli
        ZF1->ZF1_LOJA	:= _cLoja
        ZF1->ZF1_NOME	:= _cNome
        ZF1->ZF1_PRODUT	:= _cProd
        ZF1->ZF1_PROCES	:= _cProcLib
        ZF1->ZF1_DTEMIS	:= dDataBase
        ZF1->ZF1_PRCANT	:= _nPrcAt
        ZF1->ZF1_PRCATU	:= _nPNew
        ZF1->ZF1_STATUS	:= 'L'
        ZF1->ZF1_USUARI	:= UsrRetName(RetCodUsr())
        ZF1->(MsUnLock())

        ConfirmSX8()

        M->Z2_PROCES := _cProcLib
        M->Z2_PRCBLQ := _nPNew

        _lRet := .T.
    Endif

    RestArea(_AreaOri)

    _lRet := .T.

Return(_lRet)



User Function VldExcSZ2(_nOpc)

    Local _lRet		:= .T.
    Local _cFil		:= xFilial("SZ2")
    Local _cCli		:= SZ2->Z2_CLIENTE
    Local _cLoja	:= SZ2->Z2_LOJA
    Local _cProd	:= SZ2->Z2_PRODUTO
    Local _nPrcAt	:= 0
    Local _nPCalc	:= SZ2->Z2_PRECO
    Local _nDif		:= SZ2->Z2_PRECO
    LOcal _cNome	:= SZ2->Z2_NOME
    LOcal _cProcLib	:= SZ2->Z2_PROCES
    Local _cCodBlq	:= '03'
    Local _cNum		:= _cFil + _cCli + _cLoja + _cProcLib + Alltrim(_cProd)

    If _nOpc = 1
        If SZ2->Z2_LIBERAD = 'S'
            Return(_lRet)
        Endif
    Endif

    _cUpd := "DELETE "+RetSqlName("ZF1")+ " WHERE ZF1_CLIENT = '"+_cCli+"' AND ZF1_LOJA = '"+_cLoja+"' AND D_E_L_E_T_ = '' "
    _cUpd += "AND ZF1_PRODUT = '"+_cProd+"' AND ZF1_PROCES = '"+_cProcLib+"' "
    TcSqlExec(_cUpd)

    _cUpd := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cNum+"' AND ZAH_TIPO = '"+_cCodBlq+"' AND D_E_L_E_T_ = '' "
    TcSqlExec(_cUpd)

    _cUpd := "DELETE "+RetSqlName("SCR")+ " WHERE CR_NUM = '"+_cNum+"' AND CR_TIPO = '"+_cCodBlq+"'  AND D_E_L_E_T_ = '' "
    TcSqlExec(_cUpd)

Return(_lRet)
