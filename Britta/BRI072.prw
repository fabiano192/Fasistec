#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BRI072   ³Revisor³AlexandrO              ³Data  ³15/09/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pedidos de Compra / Autorizacao de Entrega                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void MATA120(ExpN1,ExpA1,ExpA2,ExpN2,ExpL1)                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACOM                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function BRI072(_cEmp,_cFil,_cAprovador,_cMod,CA097USER)

    Local 	_ValLib	:=	0//GETMV("MV_VALLIB")	// Valor utilizado para confirmação de liberação de pedido de compra
    Private _aErro 	:= {}

    dbSelectArea("SAK")  /// APROVADORES
    dbSetOrder(1)
    dbSeek(xFilial("SAK")+_cAprovador)

    dbSelectArea("SCR")
    cAuxNivel := SCR->CR_NIVEL

    If SCR->CR_TIPO $ "PC/NF"

        Private nReg      := SCR->(RecNo())
        Private aArea	  := GetArea()
        Private aCposObrig:= {"D1_ITEM","D1_COD","D1_QUANT","D1_VUNIT","D1_PEDIDO","D1_ITEMPC","C7_QUANT","C7_PRECO","C7_QUJE","Divergência"}
        Private aHeadCpos := {}
        Private aHeadSize := {}
        Private aArrayNF  := {}
        Private aCampos   := {}
        Private aRetSaldo := {}

        Private cObs 	  := IIF(!Empty(SCR->CR_OBS),SCR->CR_OBS,CriaVar("CR_OBS"))
        Private ca097User := RetCodUsr()
        Private cTipoLim  := ""
        Private CRoeda    := ""
        Private cAprov    := ""
        Private cName     := ""
        Private cSavColor := ""
        Private cGrupo	  := ""
        Private cCodLiber := SCR->CR_APROV
        Private cDocto    := SCR->CR_NUM
        Private cTipo     := SCR->CR_TIPO
        Private dRefer 	  := dDataBase
        Private cPCLib	  := ""
        Private cPCUser	  := ""
        Private lAprov    := .F.
        Private lLiberou  := .F.
        Private lLibOk    := .F.
        Private lContinua := .T.
        Private lShowBut  := .T.
        Private lOGpaAprv := SuperGetMv("MV_OGPAPRV",.F.,.F.)

        Private nSavOrd   := IndexOrd()
        Private nSaldo    := 0
        Private nOpc      := 0
        Private nSalDif	  := 0
        Private nTotal    := 0
        Private nMoeda	  := 1
        Private nX        := 1
        Private nRecnoAS400:= 1

        Private oDlg
        Private oDataRef
        Private oSaldo
        Private oSalDif
        Private oBtn1
        Private oBtn2
        Private oBtn3
        Private oQual
        Private aSize   := {0,0}
        Private lUsaACC := If(FindFunction("WebbConfig"),WebbConfig(),.F.)

        If lContinua .And. !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#05"
            Help(" ",1,"A097LIB")
            lContinua := .F.
        ElseIf lContinua .And. SCR->CR_STATUS$"01"
            lContinua := .F.
            Aviso("A097BLQ","Esta operação não poderá ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)",{"Atencao"})

            _aErro := {{"04","Aguardando Liberaçao de Outros Niveis"}}
            Return(_aErro)
        EndIf

        //CONOUT("LINHA 96")

        If lContinua
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Monta o Header com os titulos do TWBrowse             ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            dbSelectArea("SX3")
            dbSetOrder(2)
            For nx	:= 1 to Len(aCposObrig)
                If MsSeek(aCposObrig[nx])
                    AADD(aHeadCpos,AllTrim(X3Titulo()))
                    AADD(aHeadSize,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))
                    AADD(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
                Else
                    AADD(aHeadCpos,"Divergencia")
                    AADD(aCampos,{" ","C"})
                EndIf
            Next

            dbSelectArea("SAL")
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Inicializa as variaveis utilizadas no Display.               ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            aRetSaldo := MaSalAlc(cCodLiber,dRefer)
            nSaldo 	  := aRetSaldo[1]
            CRoeda 	  := A097Moeda(aRetSaldo[2])
            cName  	  := UsrRetName(ca097User)
            nTotal    := xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)

            Do Case
            Case SAK->AK_TIPO == "D"
                cTipoLim :=OemToAnsi("Diario")
            Case  SAK->AK_TIPO == "S"
                cTipoLim := OemToAnsi("Semanal")
            Case  SAK->AK_TIPO == "M"
                cTipoLim := OemToAnsi("Mensal")
            Case  SAK->AK_TIPO == "A"
                cTipoLim := OemToAnsi("Anual")
            EndCase

            Do Case

            Case SCR->CR_TIPO == "NF"

                dbSelectArea("SF1")
                dbSetOrder(1)
                //MsSeek(xFilial("SF1")+Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))
                MsSeek(SCR->CR_FILIAL + Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))
                cGrupo := SF1->F1_APROV

                dbSelectArea("SD1")
                dbSetOrder(1)
                MsSeek(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

                While ( !Eof().And. SD1->D1_FILIAL == SF1->F1_FILIAL .And. SD1->D1_DOC     == SF1->F1_DOC     .And. ;
                        SD1->D1_SERIE  == SF1->F1_SERIE  .And. SD1->D1_FORNECE == SF1->F1_FORNECE .And. SD1->D1_LOJA == SF1->F1_LOJA )

                    Aadd(aArrayNF,Array(Len(aCampos)))

                    If !Empty(SD1->D1_PEDIDO)
                        dbSelectArea("SC7")
                        dbSetOrder(1)
                        MsSeek(xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC)
                    EndIf

                    For nX := 1 to Len(aCampos)

                        If Substr(aCampos[nX][1],1,2) == "D1"
                            If aCampos[nX][2] == "N"
                                aArrayNF[Len(aArrayNF)][nX] := Transform(SD1->(FieldGet(FieldPos(aCampos[nX][1]))),PesqPict("SD1",aCampos[nX][1]))
                            Else
                                aArrayNF[Len(aArrayNF)][nX] := SD1->(FieldGet(FieldPos(aCampos[nX][1])))
                            Endif
                        Elseif Substr(aCampos[nX][1],1,2) == "C7"
                            If !Empty(SD1->D1_PEDIDO)
                                If aCampos[nX][2] == "N"
                                    aArrayNF[Len(aArrayNF)][nX] := Transform(SC7->(FieldGet(FieldPos(aCampos[nX][1]))),PesqPict("SC7",aCampos[nX][1]))
                                Else
                                    aArrayNF[Len(aArrayNF)][nX] := SC7->(FieldGet(FieldPos(aCampos[nX][1])))
                                Endif
                            Else
                                aArrayNF[Len(aArrayNF)][nX] := " "
                            EndIf
                        Else
                            If !Empty(SD1->D1_PEDIDO)
                                If SD1->D1_QUANT <> SC7->C7_QUANT .And. SD1->D1_VUNIT == SC7->C7_PRECO
                                    aArrayNF[Len(aArrayNF)][nX] := OemToAnsi("Quantidade")
                                ElseIf SD1->D1_QUANT <> SC7->C7_QUANT .And. SD1->D1_VUNIT <> SC7->C7_PRECO
                                    aArrayNF[Len(aArrayNF)][nX] := OemToAnsi("Qtde/Preco")
                                ElseIf SD1->D1_QUANT == SC7->C7_QUANT .And. SD1->D1_VUNIT <> SC7->C7_PRECO
                                    aArrayNF[Len(aArrayNF)][nX] := OemToAnsi("Preco     ")
                                Else
                                    aArrayNF[Len(aArrayNF)][nX] := OemToAnsi("OK        ")
                                Endif
                            Else
                                aArrayNF[Len(aArrayNF)][nX] := OemToAnsi("Sem Pedido")
                            EndIf
                        EndIf

                    Next nX

                    SD1->( dbSkip() )
                EndDo

                dbSelectArea("SA2")
                dbSetOrder(1)
                MsSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)

                dbSelectArea("SAL")
                dbSetOrder(3)
                MsSeek(xFilial("SAL")+SF1->F1_APROV+SAK->AK_COD)

                If Eof()
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Posiciona a Tabela SAL pelo Aprovador de Origem caso o Documento tenha sido ³
                    //| transferido por Ausência Temporária ou Transferência superior e o aprovador |
                    //| de destino não fizer parte do Grupo de Aprovação.                           |
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    If !Empty(SCR->(FieldPos("CR_USERORI")))
                        dbSeek(xFilial("SAL")+SF1->F1_APROV+SCR->CR_APRORI)
                    EndIf
                EndIf

                If lOGpaAprv
                    If Eof()
                        Aviso("A097NOAPRV","O aprovador não foi encontrado no grupo de aprovação deste documento, verifique e se necessário inclua novamente o aprovador no grupo de aprovação "+SF1->F1_APROV+CRLF+"STR0090",{"Ok"})
                        lContinua := .F.
                    EndIf
                EndIf

            Case SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"

                dbSelectArea("SC7")
                dbSetOrder(1)
                MsSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
                cGrupo := SC7->C7_APROV

                dbSelectArea("SA2")
                dbSetOrder(1)
                MsSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)

                dbSelectArea("SAL")
                dbSetOrder(3)
                MsSeek(xFilial("SAL")+SC7->C7_APROV+SAK->AK_COD)

                If Eof()
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Posiciona a Tabela SAL pelo Aprovador de Origem caso o Documento tenha sido ³
                    //| transferido por Ausência Temporária ou Transferência superior e o aprovador |
                    //| de destino não fizer parte do Grupo de Aprovação.                           |
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    If !Empty(SCR->(FieldPos("CR_USERORI")))
                        dbSeek(xFilial("SAL")+SC7->C7_APROV+SCR->CR_APRORI)
                    EndIf
                EndIf

                If lOGpaAprv
                    If Eof()
                        Aviso("A097NOAPRV","O aprovador não foi encontrado no grupo de aprovação deste documento, verifique e se necessário inclua novamente o aprovador no grupo de aprovação "+SC7->C7_APROV+CRLF+"Aviso",{"Ok"})
                        lContinua := .F.
                        _aErro := {{"05","Aprovador Nao Encontrado no Grupo de Documento"}}
                        Return(_aErro)
                    EndIf
                Endif
            EndCase

            If SAL->AL_LIBAPR != "A"
                lAprov := .T.
                cAprov := OemToAnsi("VISTO / LIVRE")
            EndIf
            nSalDif := nSaldo - IIF(lAprov,0,nTotal)
        EndIf

        If lContinua

            If _cMod == "B"
                nOpc:=3
            Else
                nOpc:=2
            Endif

            If nOpc == 2 .Or. nOpc == 3
                SCR->(dbClearFilter())
                SCR->(dbGoTo(nReg))

                If ( SCR->CR_TIPO == "NF" )
                    lLibOk := .T.//A097Lock(Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)),SCR->CR_TIPO)
                ElseIf SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
                    lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(SC7->C7_NUM)),SCR->CR_TIPO)
                EndIf
                If lLibOk
                    Begin Transaction
                        lLiberou := U_MZ130_01({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,If(nOpc==2,4,6))
                        _lParar  := .T.

                        If lLiberou

                            If SCR->CR_TIPO == "NF"
                                dbSelectArea("SF1")
                                Reclock("SF1",.F.)
                                SF1->F1_STATUS := If(SF1->F1_STATUS=="B"," ",SF1->F1_STATUS)
                                MsUnlock()
                            ElseIf SCR->CR_TIPO == "PC"
                                dbSelectArea("SC7")
                                cPCLib := SC7->C7_NUM
                                cPCUser:= SC7->C7_USER
                                While !Eof() .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM))
                                    Reclock("SC7",.F.)
                                    SC7->C7_CONAPRO := "L"
                                    MsUnlock()

                                    _aErro := {{"01","Liberado com Sucesso"}}
                                    dbSkip()
                                EndDo

                                dbSkip(-1)
                                If lUsaACC .And. !Empty(SC7->(FieldPos("C7_ACCNUM")))
                                    If IsBlind()
                                        Webb533(SC7->C7_NUM)
                                    Else
                                        MsgRun("Aguarde, comunicando aprovação ao portal...","Portal ACC",{|| Webb533(SC7->C7_NUM)})
                                    EndIf
                                EndIf

                            EndIf
                        EndIf
                    End Transaction
                Else
                    Help(" ",1,"A097LOCK")
                Endif
                If cTipo == "PC" .Or. cTipo == "AE"
                    SC7->(MsUnlockAll())
                EndIf
            EndIf
            dbSelectArea("SCR")
            dbSetOrder(1)

        EndIf
        dbSelectArea("SC7")
        RestArea(aArea)

    ElseIf SCR->CR_TIPO == "02"

        _cDocSCR := SCR->CR_NUM
        _cTpDoc  := SCR->CR_TIPO

        nReg     := SCR->(Recno())

        SCR->(dbClearFilter())
        SCR->(dbGoTo(nReg))

        SCR->(dbSetOrder(1))
        If SCR->(dbseek(xFilial("SCR")+ _cTpDoc + _cDocSCR))

            SC6->(dbSetOrder(1))
            If SC6->(dbSeek(SCR->CR_FILIAL + Left(SCR->CR_NUM,8)))
                SC6->(Reclock("SC6",.F.))
                SC6->C6_YBLQPRC := "N"
                SC6->(MsUnlock())
            Endif

            _cChavSCR := SCR->CR_TIPO + SCR->CR_NUM

            ZAH->(dbSetOrder(1))
            If ZAH->(dbSeek(xFilial("ZAH")+ SCR->CR_TIPO + SCR->CR_NUM))
                _cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
                _cCrTipo  := SCR->CR_TIPO
                _cDocSCR  := SCR->CR_NUM
                _cFilZAH  := SCR->CR_FILIAL

                _cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_FILIAL = '"+_cFilZAH+"' AND ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "

                TcSqlExec(_cCq)
            Endif

            While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM

                SCR->(Reclock("SCR",.F.))
                SCR->CR_STATUS	:= "03"
                SCR->CR_DATALIB	:= Date()
                SCR->CR_USERLIB	:= SAK->AK_USER
                SCR->CR_LIBAPRO	:= SAK->AK_COD
                SCR->CR_APROV	:= _cAprovador
                SCR->CR_VALLIB	:= SCR->CR_TOTAL
                SCR->CR_TIPOLIM	:= SAK->AK_TIPO
                SCR->(MsUnlock())

                SCR->(dbSkip())
            EndDo
        Endif

        dbSelectArea("SCR")
        dbSetOrder(1)

    ElseIf SCR->CR_TIPO == "03"

        _cDocSCR := SCR->CR_NUM
        _cTpDoc  := SCR->CR_TIPO

        nReg     := SCR->(Recno())

        SCR->(dbClearFilter())
        SCR->(dbGoTo(nReg))

        SCR->(dbSetOrder(1))
        If SCR->(dbseek(xFilial("SCR")+ _cTpDoc + _cDocSCR))

            _nTam	 := Len(Space(TAMSX3("ZF1_FILIAL")[1])+Space(TAMSX3("ZF1_CLIENT")[1])+Space(TAMSX3("ZF1_LOJA")[1])+;
                Space(TAMSX3("ZF1_PROCES")[1])+Space(TAMSX3("ZF1_PRODUT")[1]))

            ZF1->(dbsetOrder(1))
            If ZF1->(MsSeek(PadR(_cDocSCR,_nTam)+"P"))
                ZF1->(Reclock("ZF1",.F.))
                ZF1->ZF1_STATUS := "L"
                ZF1->(MsUnlock())

                SZ2->(dbSetOrder(4))
                If SZ2->(Msseek(ZF1->ZF1_FILIAL+ZF1->ZF1_CLIENT+ZF1->ZF1_LOJA+ZF1->ZF1_PRODUT))
                    SZ2->(RecLock("SZ2",.F.))
                    SZ2->Z2_PRECO   := SZ2->Z2_PRCBLQ
                    SZ2->Z2_LIBERAD := 'L'
                    SZ2->(MsUnlock())
                Endif

            Endif

            _cChavSCR := SCR->CR_TIPO + SCR->CR_NUM

            ZAH->(dbSetOrder(1))
            If ZAH->(dbSeek(xFilial("ZAH")+ SCR->CR_TIPO + SCR->CR_NUM))
                _cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
                _cCrTipo  := SCR->CR_TIPO
                _cDocSCR  := SCR->CR_NUM
                _cFilZAH  := SCR->CR_FILIAL

                _cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_FILIAL = '"+_cFilZAH+"' AND ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "

                TcSqlExec(_cCq)
            Endif

            While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM

                SCR->(Reclock("SCR",.F.))
                SCR->CR_STATUS	:= "03"
                SCR->CR_DATALIB	:= Date()
                SCR->CR_USERLIB	:= SAK->AK_USER
                SCR->CR_LIBAPRO	:= SAK->AK_COD
                SCR->CR_APROV	:= _cAprovador
                SCR->CR_VALLIB	:= SCR->CR_TOTAL
                SCR->CR_TIPOLIM	:= SAK->AK_TIPO
                SCR->(MsUnlock())

                SCR->(dbSkip())
            EndDo
        Endif

        dbSelectArea("SCR")
        dbSetOrder(1)

    ElseIf SCR->CR_TIPO == "04"

        _cDocSCR := SCR->CR_NUM
        _cFornece:= SCR->CR_YFORNEC
        _cLojaFor:= SCR->CR_YLOJFOR
        _cTabPrc := SCR->CR_YCODTAB
        _cTpDoc  := SCR->CR_TIPO
        _cProduto:= SCR->CR_YPRODUT

        nReg     := SCR->(Recno())
        SCR->(dbClearFilter())
        SCR->(dbGoTo(nReg))

        SCR->(dbSetOrder(1))
        If SCR->(dbseek(xFilial("SCR")+ _cTpDoc + _cDocSCR))

            AIB->(dbOrderNickName("INDAIB2"))
            If AIB->(dbSeek(SCR->CR_FILIAL + SCR->CR_YFORNEC  + SCR->CR_YLOJFOR + SCR->CR_YCODTAB + SCR->CR_YPRODUT + "L"))
                AIB->(RecLock("AIB",.F.))
                If !Empty(AIB->AIB_YLIB01) .And. !Empty(AIB->AIB_YLIB02)
                    AIB->AIB_YLIBER := "B"
                    AIB->AIB_YDTBLQ := Date()
                Endif
                AIB->(MsUnlock())
            Endif

            _lPrim    := .F.

            AIB->(dbOrderNickName("INDAIB2"))
            If AIB->(dbSeek(SCR->CR_FILIAL + SCR->CR_YFORNEC  + SCR->CR_YLOJFOR + SCR->CR_YCODTAB + SCR->CR_YPRODUT + Space(01)))
                AIB->(RecLock("AIB",.F.))
                If Empty(AIB->AIB_YLIB01)
                    //AIB->AIB_YLIB01 := Substr(cUsuario,7,15)
                    AIB->AIB_YLIB01 := cUsername
                    _lPrim          := .T.
                Else
                    //AIB->AIB_YLIB02 := Substr(cUsuario,7,15)
                    AIB->AIB_YLIB02 := cUsername
                Endif

                If !Empty(AIB->AIB_YLIB01) .And. !Empty(AIB->AIB_YLIB02)
                    AIB->AIB_YLIBER := "L"
                    AIB->AIB_DATVIG := Date()
                    //AIB->AIB_USRLIB := Substr(cUsuario,7,15)
                    AIB->AIB_USRLIB := cUsername
                Endif

                AIB->(MsUnlock())

                _aErro := {{"01","Liberado com Sucesso"}}
            Else
                _aErro := {{"07","Documento Ja Liberado Anteriormente"}}
            Endif

            If _lPrim
                ZAH->(dbSetOrder(1))
                If ZAH->(dbSeek(xFilial("ZAH")+ SCR->CR_TIPO + SCR->CR_NUM  ))
                    _cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
                    _cCrTipo  := SCR->CR_TIPO
                    _cDocSCR  := SCR->CR_NUM
                    _cFilZAH  := SCR->CR_FILIAL

                    //If cEmpAnt == "02"
                    _cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_FILIAL = '"+_cFilZAH+"' AND ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' AND ZAH_USER = '"+CA097USER+"' "
                    //Else
                    //	_cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' AND ZAH_USER = '"+CA097USER+"' "
                    //Endif

                    TcSqlExec(_cCq)
                Endif

                SCR->(dbSetOrder(2))
                If SCR->(dbSeek(xFilial("SCR") + _cTpDoc + _cDocSCR + CA097USER))
                    SCR->(Reclock("SCR",.F.))
                    SCR->CR_STATUS	:= "03"
                    SCR->CR_DATALIB	:= Date()
                    SCR->CR_USERLIB	:= SAK->AK_USER
                    SCR->CR_LIBAPRO	:= SAK->AK_COD
                    SCR->CR_APROV	:= _cAprovador
                    SCR->CR_VALLIB	:= SCR->CR_TOTAL
                    SCR->CR_TIPOLIM	:= SAK->AK_TIPO
                    SCR->(MsUnlock())
                Endif
            Else
                _cChavSCR := SCR->CR_TIPO + SCR->CR_NUM
                ZAH->(dbSetOrder(1))
                If ZAH->(dbSeek(xFilial("ZAH")+ SCR->CR_TIPO + SCR->CR_NUM  ))
                    _cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
                    _cCrTipo  := SCR->CR_TIPO
                    _cDocSCR  := SCR->CR_NUM
                    _cFilZAH  := SCR->CR_FILIAL

                    //If cEmpAnt == "02"
                    _cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_FILIAL = '"+_cFilZAH+"' AND ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "
                    //Else
                    //	_cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "
                    //Endif

                    TcSqlExec(_cCq)
                Endif

                While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM

                    SCR->(Reclock("SCR",.F.))
                    SCR->CR_STATUS	:= "03"
                    SCR->CR_DATALIB	:= Date()
                    SCR->CR_USERLIB	:= SAK->AK_USER
                    SCR->CR_LIBAPRO	:= SAK->AK_COD
                    SCR->CR_APROV	:= _cAprovador
                    SCR->CR_VALLIB	:= SCR->CR_TOTAL
                    SCR->CR_TIPOLIM	:= SAK->AK_TIPO
                    SCR->(MsUnlock())

                    SCR->(dbSkip())
                EndDo
            Endif
        Endif

        dbSelectArea("SCR")
        dbSetOrder(1)

    ElseIf SCR->CR_TIPO == "05"
        _cDocSCR := SCR->CR_NUM
        _cCliente:= SCR->CR_YCLIENT
        _cLoja   := SCR->CR_YLOJA
        _cTpDoc  := SCR->CR_TIPO

        nReg     := SCR->(Recno())
        SCR->(dbClearFilter())
        SCR->(dbGoTo(nReg))

        SCR->(dbSetOrder(1))
        If SCR->(dbseek(xFilial("SCR")+ _cTpDoc + _cDocSCR))

            ZA6->(dbSetOrder(1))
            If ZA6->(dbSeek(xFilial("ZA6") + SCR->CR_YCLIENT + SCR->CR_YLOJA + "L"))

                ZA6->(RecLock("ZA6",.F.))
                ZA6->ZA6_LIBER := "B"
                ZA6->ZA6_DTBLOQ:= Date()
                ZA6->(MsUnlock())
            Endif

            ZA6->(dbSetOrder(1))
            If ZA6->(dbSeek(xFilial("ZA6") + SCR->CR_YCLIENT + SCR->CR_YLOJA + Space(01)))
                ZA6->(RecLock("ZA6",.F.))
                ZA6->ZA6_LIBER  := "L"
                ZA6->ZA6_DTVIG  := Date()
                ZA6->ZA6_USRLIB := cUsername
                ZA6->(MsUnlock())
                _aErro := {{"01","Liberado com Sucesso"}}

                SA1->(dbSetOrder(1))
                SA1->(dbSeek(xFilial("SA1") +SCR->CR_YCLIENT + SCR->CR_YLOJA))

                SA1->(RecLock("SA1",.F.))
                SA1->A1_COND   := ZA6->ZA6_PRAZO
                SA1->A1_LC     := ZA6->ZA6_VALOR
                SA1->A1_TIPO   := ZA6->ZA6_TIPO
                SA1->A1_RISCO  := ZA6->ZA6_RISCO
                SA1->A1_YDIFALI:= ZA6->ZA6_DIFALI
                SA1->A1_YFICMS := ZA6->ZA6_FICMS
                SA1->A1_YCHEIA := ZA6->ZA6_CHEIA
                SA1->A1_YBLQSCI:= ZA6->ZA6_DTSCI
                SA1->A1_YBLQSIN:= ZA6->ZA6_DTSINT
                SA1->A1_YTES   := ZA6->ZA6_TES
                SA1->A1_YTESF  := ZA6->ZA6_TESF
                SA1->A1_YLIB   := "S"
                SA1->(MsUnlock())
            Else
                _aErro := {{"07","Documento Ja Liberado Anteriormente"}}
            Endif

            _cChavSCR := SCR->CR_TIPO + SCR->CR_NUM

            ZAH->(dbSetOrder(1))
            If ZAH->(dbSeek(xFilial("ZAH")+ SCR->CR_TIPO + SCR->CR_NUM  ))
                _cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
                _cCrTipo  := SCR->CR_TIPO
                _cDocSCR  := SCR->CR_NUM

                _cFilZAH  := SCR->CR_FILIAL

                If cEmpAnt == "02"
                    _cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_FILIAL = '"+_cFilZAH+"' AND ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "
                Else
                    _cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "
                Endif

                TcSqlExec(_cCq)
            Endif

            While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM

                SCR->(Reclock("SCR",.F.))
                SCR->CR_STATUS	:= "03"
                SCR->CR_DATALIB	:= Date()
                SCR->CR_USERLIB	:= SAK->AK_USER
                SCR->CR_LIBAPRO	:= SAK->AK_COD
                SCR->CR_APROV	:= _cAprovador
                SCR->CR_VALLIB	:= SCR->CR_TOTAL
                SCR->CR_TIPOLIM	:= SAK->AK_TIPO
                SCR->(MsUnlock())

                SCR->(dbSkip())
            EndDo
        Endif

        dbSelectArea("SCR")
        dbSetOrder(1)

    ElseIf SCR->CR_TIPO == "06"   // BORDERO DE PAGAMENTO

        _cNomeUsr:= UsrRetName(CA097USER)

        _cFilZAH := SCR->CR_FILIAL
        _cDocSCR := SCR->CR_NUM
        _cTpDoc  := SCR->CR_TIPO

        nReg     := SCR->(Recno())
        SCR->(dbClearFilter())
        SCR->(dbGoTo(nReg))

        CONOUT("BRI072-> LINHA 796")
        SCR->(dbSetOrder(1))
        If SCR->(dbseek(_cFilZAH + _cTpDoc + _cDocSCR))

            CONOUT("BRI072-> LINHA 800")

            SEA->(dbSetOrder(2))
            If SEA->(dbSeek(_cFilZAH + Left(_cDocSCR,6) + "P"))

                CONOUT("BRI072-> LINHA 805")
                _cNumBor  := SEA->EA_NUMBOR
                _lPrim    := .F.

                While SEA->(!Eof()) .And. _cNumBor == SEA->EA_NUMBOR //.And. !_lPrim

                    SEA->(RecLock("SEA",.F.))
                    If Empty(SEA->EA_YLIB01)
                        SEA->EA_YLIB01 := _cNomeUsr
                        _lPrim         := .T.
                    Else
                        SEA->EA_YLIB02 := _cNomeUsr
                    Endif

                    SEA->(MsUnlock())

                    SEA->(dbSkip())
                EndDo

                If _lPrim

                    ZAH->(dbSetOrder(1))
                    If ZAH->(dbSeek(SCR->CR_FILIAL + SCR->CR_TIPO + SCR->CR_NUM  ))
                        _cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
                        _cCrTipo  := SCR->CR_TIPO
                        _cDocSCR  := SCR->CR_NUM
                        _cFilZAH  := SCR->CR_FILIAL
                        //If cEmpAnt == "02"
                        _cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_FILIAL = '"+_cFilZAH+"' AND ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' AND ZAH_USER = '"+CA097USER+"' "
                        //Else
                        //	_cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' AND ZAH_USER = '"+CA097USER+"' "
                        //Endif

                        TcSqlExec(_cCq)
                    Endif

                    SCR->(dbSetOrder(2))
                    If SCR->(dbSeek(_cFilZAH + _cTpDoc + _cDocSCR + CA097USER))
                        SCR->(Reclock("SCR",.F.))
                        SCR->CR_STATUS	:= "03"
                        SCR->CR_DATALIB	:= Date()
                        SCR->CR_USERLIB	:= SAK->AK_USER
                        SCR->CR_LIBAPRO	:= SAK->AK_COD
                        SCR->CR_APROV	:= _cAprovador
                        SCR->CR_VALLIB	:= SCR->CR_TOTAL
                        SCR->CR_TIPOLIM	:= SAK->AK_TIPO
                        SCR->(MsUnlock())
                    Endif
                Else
                    _cChavSCR := SCR->CR_TIPO + SCR->CR_NUM

                    ZAH->(dbSetOrder(1))
                    If ZAH->(dbSeek(_cFilZAH + SCR->CR_TIPO + SCR->CR_NUM  ))
                        _cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
                        _cCrTipo  := SCR->CR_TIPO
                        _cDocSCR  := SCR->CR_NUM

                        _cFilZAH  := SCR->CR_FILIAL

                        //If cEmpAnt == "02"
                        _cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_FILIAL = '"+_cFilZAH+"' AND ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "
                        //Else
                        //	_cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "
                        //Endif

                        TcSqlExec(_cCq)
                    Endif

                    While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM

                        If SCR->CR_STATUS == "03"
                            SCR->(dbSkip())
                            Loop
                        Endif

                        SCR->(Reclock("SCR",.F.))
                        SCR->CR_STATUS	:= "03"
                        SCR->CR_DATALIB	:= Date()
                        SCR->CR_USERLIB	:= SAK->AK_USER
                        SCR->CR_LIBAPRO	:= SAK->AK_COD
                        SCR->CR_APROV	:= _cAprovador
                        SCR->CR_VALLIB	:= SCR->CR_TOTAL
                        SCR->CR_TIPOLIM	:= SAK->AK_TIPO
                        SCR->(MsUnlock())

                        SCR->(dbSkip())
                    EndDo
                Endif
            Endif
        Endif

        dbSelectArea("SCR")
        dbSetOrder(1)

    ElseIf SCR->CR_TIPO == "07"  // PEDIDO DE VENDA
        _cDocSCR := SCR->CR_NUM
        //_cCliente:= SCR->CR_YCLIENT
        //_cLoja   := SCR->CR_YLOJA
        _cTpDoc  := SCR->CR_TIPO

        nReg     := SCR->(Recno())
        SCR->(dbClearFilter())
        SCR->(dbGoTo(nReg))

        SCR->(dbSetOrder(1))
        If SCR->(dbseek(xFilial("SCR")+ _cTpDoc + _cDocSCR))

            _cNewFil:="z"+substr(cFilAnt,2,1)
            SC9->(dbOrderNickName("INDSC92"))
            If SC9->(dbSeek(_cNewFil + Left(SCR->CR_NUM,15)))

                SC9->(Reclock("SC9",.F.))
                SC9->C9_YLIBER := "L"
                SC9->C9_BLCRED := ""
                SC9->(MsUnlock())

                SZA->(dbSetorder(2))
                If SZA->(dbSeek(SCR->CR_FILIAL + SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_PDOC ))
                    SZA->(RecLock("SZA",.F.))
                    SZA->ZA_BLCRED:= ""
                    SZA->(MsUnlock())
                Endif
            Endif

            _cChavSCR := SCR->CR_TIPO + SCR->CR_NUM

            ZAH->(dbSetOrder(1))
            If ZAH->(dbSeek(xFilial("ZAH")+ SCR->CR_TIPO + SCR->CR_NUM  ))
                _cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
                _cCrTipo  := SCR->CR_TIPO
                _cDocSCR  := SCR->CR_NUM
                _cFilZAH  := SCR->CR_FILIAL

                _cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_FILIAL = '"+_cFilZAH+"' AND ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "

                TcSqlExec(_cCq)
            Endif

            While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM

                SCR->(Reclock("SCR",.F.))
                SCR->CR_STATUS	:= "03"
                SCR->CR_DATALIB	:= Date()
                SCR->CR_USERLIB	:= SAK->AK_USER
                SCR->CR_LIBAPRO	:= SAK->AK_COD
                SCR->CR_APROV	:= _cAprovador
                SCR->CR_VALLIB	:= SCR->CR_TOTAL
                SCR->CR_TIPOLIM	:= SAK->AK_TIPO
                SCR->(MsUnlock())

                SCR->(dbSkip())
            EndDo
        Endif

        dbSelectArea("SCR")
        dbSetOrder(1)

    ElseIf SCR->CR_TIPO == "08"  // DESCONTO CONTAS A RECEBER
        _cDocSCR := SCR->CR_NUM
        _cCliente:= SCR->CR_YCLIENT
        _cLoja   := SCR->CR_YLOJA
        _cTpDoc  := SCR->CR_TIPO

        nReg     := SCR->(Recno())
        SCR->(dbClearFilter())
        SCR->(dbGoTo(nReg))

        SCR->(dbSetOrder(1))
        If SCR->(dbseek(xFilial("SCR")+ _cTpDoc + _cDocSCR))

            SZ1->(dbSetOrder(1))
            If SZ1->(dbSeek(SCR->CR_FILIAL + Left(SCR->CR_NUM,6)))

                SZ1->(Reclock("SZ1",.F.))
                SZ1->Z1_LIBER := "S"
                //SZ1->Z1_NLIB  := Subs(alltrim(cusuario),7,15)
                SZ1->Z1_NLIB  := cUsername
                SZ1->Z1_HLIB  := Left(time(),5)
                SZ1->Z1_YDTLIB:= If(SZ1->Z1_YDTLIB < dDataBase,dDataBase,SZ1->Z1_YDTLIB)
                SZ1->(MsUnlock())
            Endif

            _cChavSCR := SCR->CR_TIPO + SCR->CR_NUM

            ZAH->(dbSetOrder(1))
            If ZAH->(dbSeek(xFilial("ZAH")+ SCR->CR_TIPO + SCR->CR_NUM  ))
                _cChavZAH := ZAH->ZAH_TIPO + ZAH->ZAH_NUM
                _cCrTipo  := SCR->CR_TIPO
                _cDocSCR  := SCR->CR_NUM
                _cFilZAH  := SCR->CR_FILIAL

                If cEmpAnt == "02"
                    _cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_FILIAL = '"+_cFilZAH+"' AND ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "
                Else
                    _cCq := "DELETE "+RetSqlName("ZAH")+ " WHERE ZAH_NUM = '"+_cDocSCR+"' AND ZAH_TIPO = '"+_cCrTipo+"' "
                Endif

                TcSqlExec(_cCq)
            Endif

            While SCR->(!Eof()) .And. _cChavSCR == SCR->CR_TIPO + SCR->CR_NUM

                SCR->(Reclock("SCR",.F.))
                SCR->CR_STATUS	:= "03"
                SCR->CR_DATALIB	:= Date()
                SCR->CR_USERLIB	:= SAK->AK_USER
                SCR->CR_LIBAPRO	:= SAK->AK_COD
                SCR->CR_APROV	:= _cAprovador
                SCR->CR_VALLIB	:= SCR->CR_TOTAL
                SCR->CR_TIPOLIM	:= SAK->AK_TIPO
                SCR->(MsUnlock())

                SCR->(dbSkip())
            EndDo
        Endif

        dbSelectArea("SCR")
        dbSetOrder(1)

    Endif


Return(_aErro)


Static Function ValidPcoLan()

    Local lRet	   := .T.
    Local aArea    := GetArea()
    Local aAreaSC7 := SC7->(GetArea())
    If SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
        dbSelectArea("SC7")
        DbSetOrder(1)
        DbSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
    Endif


    RestArea(aAreaSC7)
    RestArea(aArea)

Return lRet


User Function MZ130_01(aDocto,dDataRef,nOper,cDocSF1,lResiduo)

    //Function MaAlcDoc(aDocto,dDataRef,nOper,cDocSF1,lResiduo)

    Local cDocto	:= aDocto[1]
    Local cTipoDoc	:= aDocto[2]
    Local nValDcto	:= aDocto[3]
    Local cAprov	:= If(aDocto[4]==Nil,"",aDocto[4])
    Local cUsuario	:= If(aDocto[5]==Nil,"",aDocto[5])
    Local nMoeDcto	:= If(Len(aDocto)>7,If(aDocto[8]==Nil, 1,aDocto[8]),1)
    Local nTxMoeda	:= If(Len(aDocto)>8,If(aDocto[9]==Nil, 0,aDocto[9]),0)
    Local cObs      := If(Len(aDocto)>10,If(aDocto[11]==Nil, "",aDocto[11]),"")
    Local aArea		:= GetArea()
    Local aAreaSCS	:= SCS->(GetArea())
    Local aAreaSCR	:= SCR->(GetArea())
    Local aRetPe	:= {}
    Local nSaldo	:= 0
    Local cGrupo	:= If(aDocto[6]==Nil,"",aDocto[6])
    Local lFirstNiv:= .T.
    Local cAuxNivel:= ""
    Local cNextNiv := ""
    Local cNivIgual:= ""
    Local cStatusAnt:= ""
    Local cAprovOri := ""
    Local cUserOri  := ""
    Local lAchou	:= .F.
    Local nRec		:= 0
    Local lRetorno	:= .T.
    Local aSaldo	:= {}
    Local aMTALCGRU := {}
    Local lDeletou := .F.
    Local dDataLib := IIF(dDataRef==Nil,dDataBase,dDataRef)
    DEFAULT dDataRef := dDataBase
    DEFAULT cDocSF1 := cDocto
    DEFAULT lResiduo := .F.
    cDocto := cDocto+Space(Len(SCR->CR_NUM)-Len(cDocto))
    cDocSF1:= cDocSF1+Space(Len(SCR->CR_NUM)-Len(cDocSF1))

    If ExistBlock("MT097GRV")
        lRetorno := (Execblock("MT097GRV",.F.,.F.,{aDocto,dDataRef,nOper,cDocSF1,lResiduo}))
        If Valtype( lRetorno ) <> "L"
            lRetorno := .T.
        EndIf
    Endif

    If lRetorno

        If Empty(cUsuario) .And. (nOper != 1 .And. nOper != 6) //nao e inclusao ou estorno de liberacao
            dbSelectArea("SAK")
            dbSetOrder(1)
            dbSeek(xFilial()+cAprov)
            cUsuario :=	AK_USER
            nMoeDcto :=	AK_MOEDA
            nTxMoeda	:=	0
        EndIf
        If nOper == 1  //Inclusao do Documento
            cGrupo := If(!Empty(aDocto[6]),aDocto[6],cGrupo)
            dbSelectArea("SAL")
            dbSetOrder(2)
            If !Empty(cGrupo) .And. dbSeek(xFilial("SAL")+cGrupo)
                While !Eof() .And. xFilial("SAL")+cGrupo == AL_FILIAL+AL_COD

                    If cTipoDoc <> "NF"
                        If SAL->AL_AUTOLIM == "S" .And. !MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda)
                            dbSelectArea("SAL")
                            dbSkip()
                            Loop
                        EndIf
                    EndIf

                    If lFirstNiv
                        cAuxNivel := SAL->AL_NIVEL
                        lFirstNiv := .F.
                    EndIf

                    Do Case
                    Case cTipoDoc == "NF"
                        SF1->(FkCommit())
                    Case cTipoDoc == "PC" .Or.cTipoDoc == "AE"
                        SC7->(FkCommit())
                    Case cTipoDoc == "CP"
                        SC3->(FkCommit())
                    Case cTipoDoc == "SC"
                        SC1->(FkCommit())
                    Case cTipoDoc == "CO"
                        SC8->(FkCommit())
                    Case cTipoDoc == "MD"
                        CND->(FkCommit())
                    EndCase

                    Reclock("SCR",.T.)
                    SCR->CR_FILIAL	:= xFilial("SCR")
                    SCR->CR_NUM		:= cDocto
                    SCR->CR_TIPO	:= cTipoDoc
                    SCR->CR_NIVEL	:= SAL->AL_NIVEL
                    SCR->CR_USER	:= SAL->AL_USER
                    SCR->CR_APROV	:= SAL->AL_APROV
                    SCR->CR_STATUS	:= IIF(SAL->AL_NIVEL == cAuxNivel,"02","01")
                    SCR->CR_TOTAL	:= nValDcto
                    SCR->CR_EMISSAO:= aDocto[10]
                    SCR->CR_MOEDA	:=	nMoeDcto
                    SCR->CR_TXMOEDA:= nTxMoeda
                    MsUnlock()
                    dbSelectArea("SAL")
                    dbSkip()
                EndDo
            EndIf
            lRetorno := lFirstNiv
        EndIf

        If nOper == 2  //Transferencia da Alcada para o Superior
            //dbSelectArea("SCR")
            //dbSetOrder(1)
            //dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
            // O SCR deve estar posicionado, para que seja transferido o atual para o Superior
            If !Eof() .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == xFilial("SCR")+cTipoDoc+cDocto
                // Carrega dados do Registro a ser tranferido e exclui
                cTipoDoc := SCR->CR_TIPO
                cAuxNivel:= SCR->CR_STATUS
                nValDcto := SCR->CR_TOTAL
                nMoeDcto :=	SCR->CR_MOEDA
                cNextNiv := SCR->CR_NIVEL
                nTxMoeda := SCR->CR_TXMOEDA
                dDataRef := SCR->CR_EMISSAO
                cAprovOri:= SCR->CR_APROV
                cUserOri := SCR->CR_USER
                Reclock("SCR",.F.,.T.)
                dbDelete()
                MsUnlock()
                // Inclui Registro para Aprovador Superior
                Reclock("SCR",.T.)
                SCR->CR_FILIAL	:= xFilial("SCR")
                SCR->CR_NUM		:= cDocto
                SCR->CR_TIPO	:= cTipoDoc
                SCR->CR_NIVEL	:= cNextNiv
                SCR->CR_USER	:= cUsuario
                SCR->CR_APROV	:= cAprov
                SCR->CR_STATUS	:= cAuxNivel
                SCR->CR_TOTAL	:= nValDcto
                SCR->CR_EMISSAO:= dDataRef
                SCR->CR_MOEDA	:=	nMoeDcto
                SCR->CR_TXMOEDA:= nTxMoeda
                SCR->CR_OBS 	:= cObs

                //Aplicar UPDCOM10 se não existir campos na base //
                If !Empty(SCR->(FieldPos("CR_APRORI"))) .And. !Empty(SCR->(FieldPos("CR_USERORI")))
                    SCR->CR_APRORI  := cAprovOri
                    SCR->CR_USERORI := cUserOri
                EndIf
                MsUnlock()
            EndIf
            lRetorno := .T.
        EndIf

        If nOper == 3  //exclusao do documento
            dbSelectArea("SAK")
            dbSetOrder(1)
            dbSelectArea("SCR")
            dbSetOrder(1)
            dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Efetua uma nova busca caso o cDocto nao for encontrado no SCR³
            //³ pois seu conteudo em caso de NF foi alterado para chave unica³
            //³ do SF1, o cDocSF1 sera a busca alternativa com o conteudo ori³
            //³ ginal do lancamento da versao que poderia causar duplicidades³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If SCR->( Eof() ) .And. cTipoDoc == "NF"
                dbSeek(xFilial("SCR")+cTipoDoc+cDocSF1)
                cDocto := cDocSF1
            EndIf

            While !Eof() .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == xFilial("SCR")+cTipoDoc+cDocto
                If SCR->CR_STATUS == "03"
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Reposiciona o usuario aprovador.               ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    dbSelectArea("SAK")
                    dbSeek(xFilial("SAK")+SCR->CR_LIBAPRO)
                    dbSelectArea("SAL")
                    dbSetOrder(3)
                    dbSeek(xFilial("SAL")+cGrupo+SAK->AK_COD)
                    If SAL->AL_LIBAPR == "A"
                        dbSelectArea("SCS")
                        dbSetOrder(2)
                        If dbSeek(xFilial("SCS")+SAK->AK_COD+DTOS(MaAlcDtRef(SCR->CR_LIBAPRO,SCR->CR_DATALIB,SCR->CR_TIPOLIM)))
                            RecLock("SCS",.F.)
                            SCS->CS_SALDO := SCS->CS_SALDO + SCR->CR_VALLIB
                            MsUnlock()
                        EndIf
                    EndIf
                EndIf
                Reclock("SCR",.F.,.T.)
                dbDelete()
                MsUnlock()
                dbSkip()
            EndDo
        EndIf

        If nOper == 4 //Aprovacao do documento
            dbSelectArea("SCS")
            dbSetOrder(2)
            aSaldo := MaSalAlc(cAprov,dDataRef,.T.)
            nSaldo 	:= aSaldo[1]
            dDataRef	:= aSaldo[3]
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Atualiza o saldo do aprovador.                 ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            dbSelectArea("SAK")
            dbSetOrder(1)
            dbSeek(xFilial("SAK")+cAprov)

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Posiciona a Tabela SAL pelo Aprovador de Origem caso o Documento tenha sido ³
            //| transferido por Ausência Temporária ou Transferência superior e o aprovador |
            //| de destino não fizer parte do Grupo de Aprovação.                           |
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            dbSelectArea("SAL")
            dbSetOrder(3)
            dbSeek(xFilial("SAL")+cGrupo+cAprov)
            If !Empty(SCR->(FieldPos("CR_USERORI"))) .And. !Empty(SCR->(FieldPos("CR_APRORI"))) .And. !Empty(SCR->CR_APRORI)
                dbSeek(xFilial("SAL")+cGrupo+SCR->CR_APRORI)
            EndIf

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Libera o pedido pelo aprovador.                     ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            dbSelectArea("SCR")
            cAuxNivel := CR_NIVEL
            Reclock("SCR",.F.)
            dbSetOrder(1)
            CR_STATUS	:= "03"
            CR_OBS		:= If(Len(aDocto)>10,aDocto[11],"")
            CR_DATALIB	:= dDataLib
            CR_USERLIB	:= SAK->AK_USER
            CR_LIBAPRO	:= SAK->AK_COD
            CR_VALLIB	:= nValDcto
            CR_TIPOLIM	:= SAK->AK_TIPO
            MsUnlock()
            dbSeek(xFilial("SCR")+cTipoDoc+cDocto+cAuxNivel)
            nRec := RecNo()
            While !Eof() .And. xFilial("SCR")+cDocto+cTipoDoc == CR_FILIAL+CR_NUM+CR_TIPO

                If cAuxNivel == CR_NIVEL .And. CR_STATUS != "03" .And. SAL->AL_TPLIBER$"U "
                    Exit
                EndIf

                If cAuxNivel == CR_NIVEL .And. CR_STATUS != "03" .And. SAL->AL_TPLIBER$"NP"
                    Reclock("SCR",.F.)
                    CR_STATUS	:= "05"
                    CR_DATALIB	:= dDataLib
                    CR_USERLIB	:= SAK->AK_USER
                    CR_APROV	   := cAprov
                    CR_OBS		:= ""
                    MsUnlock()
                EndIf

                If CR_NIVEL > cAuxNivel .And. CR_STATUS != "03" .And. !lAchou
                    lAchou := .T.
                    cNextNiv := CR_NIVEL
                EndIf

                If lAchou .And. CR_NIVEL == cNextNiv .And. CR_STATUS != "03"
                    Reclock("SCR",.F.)
                    CR_STATUS := If(SAL->AL_TPLIBER=="P","05",If(( Empty(cNivIgual) .Or. cNivIgual == CR_NIVEL ) .And. cStatusAnt <> "01" ,"02",CR_STATUS))

                    If CR_STATUS == "05"
                        CR_DATALIB	:= dDataLib
                    EndIf
                    MsUnlock()
                    cNivIgual := CR_NIVEL
                    lAchou    := .F.
                Endif

                cStatusAnt := SCR->CR_STATUS

                dbSkip()
            EndDo
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Reposiciona e verifica se ja esta totalmente liberado.       ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            dbGoto(nRec)
            While !Eof() .And. xFilial("SCR")+cTipoDoc+cDocto == CR_FILIAL+CR_TIPO+CR_NUM
                If CR_STATUS != "03" .And. CR_STATUS != "05"
                    lRetorno := .F.
                EndIf
                dbSkip()
            EndDo
            If SAL->AL_LIBAPR == "A"
                dbSelectArea("SCS")
                If dbSeek(xFilial()+cAprov+dToS(dDataRef))
                    Reclock("SCS",.F.)
                Else
                    Reclock("SCS",.T.)
                EndIf
                CS_FILIAL := xFilial("SCS")
                CS_SALDO  := CS_SALDO - nValDcto
                CS_APROV  := cAprov
                CS_USER	 := cUsuario
                CS_MOEDA  := nMoeDcto
                CS_DATA	 := dDataRef
                MsUnlock()
            EndIf
        EndIf

        If nOper == 5  //Estorno da Aprovacao
            cGrupo := If(!Empty(aDocto[6]),aDocto[6],cGrupo)
            dbSelectArea("SAK")
            dbSetOrder(1)
            dbSelectArea("SCR")
            dbSetOrder(1)
            dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
            nMoeDcto := SCR->CR_MOEDA
            nTxMoeda := SCR->CR_TXMOEDA
            While !Eof() .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == xFilial("SCR")+cTipoDoc+cDocto
                If SCR->CR_STATUS == "03"
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Reposiciona o usuario aprovador.               ³
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    dbSelectArea("SAK")
                    dbSeek(xFilial("SAK")+SCR->CR_LIBAPRO)

                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                    //³ Posiciona a Tabela SAL pelo Aprovador de Origem caso o Documento tenha sido ³
                    //| transferido por Ausência Temporária ou Transferência superior e o aprovador |
                    //| de destino não fizer parte do Grupo de Aprovação.                           |
                    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                    dbSelectArea("SAL")
                    dbSetOrder(3)
                    dbSeek(xFilial("SAL")+cGrupo+SAK->AK_COD)
                    If Eof()
                        If !Empty(SCR->(FieldPos("CR_USERORI")))
                            dbSeek(xFilial("SAL")+cGrupo+SCR->CR_APRORI)
                        EndIf
                    EndIf

                    If SAL->AL_LIBAPR == "A"
                        dbSelectArea("SCS")
                        dbSetOrder(2)
                        If dbSeek(xFilial("SCS")+SAK->AK_COD+DTOS(MaAlcDtRef(SAK->AK_COD,SCR->CR_DATALIB)))
                            RecLock("SCS",.F.)
                            SCS->CS_SALDO := SCS->CS_SALDO + If(nValDcto>0 .And. nValDcto < SCR->CR_VALLIB,nValDcto,SCR->CR_VALLIB)
                            If SCS->CS_SALDO > SAK->AK_LIMITE
                                SCS->CS_SALDO := SAK->AK_LIMITE
                            EndIf
                            MsUnlock()
                        EndIf
                    EndIf
                EndIf
                Reclock("SCR",.F.,.T.)
                If nValDcto > 0 .And. nValDcto < SCR->CR_TOTAL
                    SCR->CR_TOTAL	:= SCR->CR_TOTAL - nValDcto
                    SCR->CR_VALLIB	:= SCR->CR_VALLIB - nValDcto
                Else
                    If lResiduo
                        lDeletou := IF(SCR->CR_TOTAL - nValDcto > 0,.T.,.F.)
                    Else
                        lDeletou := .T.
                    EndIf
                    dbDelete()
                EndIf
                MsUnlock()
                dbSkip()
            EndDo

            dbSelectArea("SAL")
            dbSetOrder(2)
            If	(!Empty(cGrupo) .And. dbSeek(xFilial("SAL")+cGrupo) .And. nValDcto > 0 .And. lDeletou) .Or. ;
                    (!Empty(cGrupo) .And. dbSeek(xFilial("SAL")+cGrupo) .And. cTipoDoc == "NF" .And. lDeletou)

                While !Eof() .And. xFilial("SAL")+cGrupo == AL_FILIAL+AL_COD

                    If cTipoDoc <> "NF"
                        If SAL->AL_AUTOLIM == "S" .And. !MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda)
                            dbSelectArea("SAL")
                            dbSkip()
                            Loop
                        EndIf
                    EndIf

                    If lFirstNiv
                        cAuxNivel := SAL->AL_NIVEL
                        lFirstNiv := .F.
                    EndIf
                    Reclock("SCR",.T.)
                    SCR->CR_FILIAL	:= xFilial("SCR")
                    SCR->CR_NUM		:= cDocto
                    SCR->CR_TIPO	:= cTipoDoc
                    SCR->CR_NIVEL	:= SAL->AL_NIVEL
                    SCR->CR_USER	:= SAL->AL_USER
                    SCR->CR_APROV	:= SAL->AL_APROV
                    SCR->CR_STATUS	:= IIF(SAL->AL_NIVEL == cAuxNivel,"02","01")
                    SCR->CR_TOTAL	:= nValDcto
                    SCR->CR_EMISSAO:= dDataRef
                    SCR->CR_MOEDA	:=	nMoeDcto
                    SCR->CR_TXMOEDA:= nTxMoeda
                    MsUnlock()
                    dbSelectArea("SAL")
                    dbSkip()
                EndDo
            EndIf
            lRetorno := lFirstNiv
        EndIf

        If nOper == 6  //Bloqueio manual
            dbSelectArea("SAK")
            dbSetOrder(1)
            dbSeek(xFilial("SAK")+cAprov)

            Reclock("SCR",.F.)
            CR_STATUS   := "04"
            CR_OBS	    := Alltrim(Funname())+"-"+Alltrim(RetCodUsr())+" | "+If(Len(aDocto)>10,aDocto[11],"")
            //		CR_OBS	    := If(Len(aDocto)>10,aDocto[11],"")
            CR_DATALIB  := dDataRef
            CR_USERLIB	:= SAK->AK_USER
            CR_LIBAPRO	:= SAK->AK_COD
            cAuxNivel   := CR_NIVEL
            MsUnlock()
            lRetorno 	:= .F.

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Bloqueia todos os Aprovadores do Nível  ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

            dbSeek(xFilial("SCR")+cTipoDoc+cDocto+cAuxNivel)
            nRec := RecNo()
            While !Eof() .And. xFilial("SCR")+cDocto+cTipoDoc+cAuxNivel == CR_FILIAL+CR_NUM+CR_TIPO+CR_NIVEL
                If CR_STATUS != "04"
                    Reclock("SCR",.F.)
                    CR_STATUS	:= "05"
                    CR_OBS	   := "Bloqueio "+SAK->AK_COD
                    CR_DATALIB	:= dDataRef
                    CR_USERLIB	:= SAK->AK_USER
                    CR_LIBAPRO	:= SAK->AK_COD
                    MsUnlock()
                EndIf

                dbSkip()
            EndDo
        EndIf

        If ExistBlock("MTALCDOC")
            Execblock("MTALCDOC",.F.,.F.,{aDocto,dDataRef,nOper})
        Endif
    EndIf

    dbSelectArea("SCR")
    RestArea(aAreaSCR)
    dbSelectArea("SCS")
    RestArea(aAreaSCS)
    RestArea(aArea)

Return(lRetorno)

Return