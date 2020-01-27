#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "SPEDNFE.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"

#DEFINE WS_CODRET 1  //COD SEFAZ DE RETORNO
#DEFINE WS_MSG    2  //MENSAGEM COMPLETA MONTADA PELA FUNCAO STATUS
#DEFINE WS_MSGSEF 3  //DESCRICAO DA MENSAGEM SEFAZ

#DEFINE WS1_LCONTG  1  //ESTÁ EM CONTINGENCIA ?
#DEFINE WS1_DESCMOD 2  //DESCRICAO DA MODALIDADE

User Function MyDACTEProc( _cSerie, _cNota,_dDtIni)

    LOCAL _cMsg:="Processando Transmissão"

    AutoCTeEnv(cEmpAnt,SF2->F2_FILIAL,"0","1",SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_DOC)

    _lParar := .T.

    Processa({|| __MyDACTEPr(_cSerie,_cNota, @_cMsg)}, "Aguardando Autorizacao da CT-e...",_cMsg,.F.)

RETURN



Static Function __MyDACTEP(_cSerie, _cNota, _cMsgSt)

    Local _aArea:={}
    LOCAL _oDACTE, _oSetup
    Local _cIdEnt:=""
    Local _cFilePrint := ""
    Local _nFlags:=0
    LOCAL _aWSStat:={"","",""}
    LOCAL _aWSCfg:={"",""}
    LOCAL nVezes, lTEnta
    LOCAL lImprime:=.T.
    Local cModalidade:= ""
    Local nX,_nTenta

    _cIdEnt := GetIdEnt()
    _aArea  := GetArea()

    IF (SF2->F2_SERIE+SF2->F2_DOC)<>(_cSerie+_cNota)
        SF2->(OrdSetFocus(1))
        IF .NOT. (SF2->(DbSeek(xFilial("SF2")+_cNota+_cSerie)))
            Alert("NOTA FISCAL NÃO ENCONTRADA")
            RETURN
        ENDIF
    ENDIF

    aNotas := {}
    aadd(aNotas,{})
    aadd(Atail(aNotas),.F.)
    aadd(Atail(aNotas),"S")
    aadd(Atail(aNotas),SF2->F2_EMISSAO)
    aadd(Atail(aNotas),SF2->F2_SERIE)
    aadd(Atail(aNotas),SF2->F2_DOC)
    aadd(Atail(aNotas),SF2->F2_CLIENTE)
    aadd(Atail(aNotas),SF2->F2_LOJA)

    If IsReady()
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Obtem o codigo da entidade                                              ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        cIdEnt := GetIdEnt()
    else
        return
    endif

    cNaoAut := ""
    aXml := GetXML(cIdEnt,aNotas,@cModalidade)

// 1 tentativa a cada segundo, até que a nf esteja autorizada, máximo de 2 min
    for _nTenta:=1 to 120
        _lPassou:=.f.
        _cMensagem:=""
        nLenNotas := Len(aNotas)
        For nX := 1 To nLenNotas

            If !Empty(aXML[nX][2])

                If !Empty(aXml[nX])
                    cAutoriza   := aXML[nX][1]
                    cCodAutDPEC := aXML[nX][5]
                Else
                    cAutoriza   := ""
                    cCodAutDPEC := ""
                EndIf
                //If (!Empty(cAutoriza) .Or. !Empty(cCodAutDPEC) .Or. !cModalidade$"1,4,5,6")
                If (!Empty(cAutoriza) .Or. !Empty(cCodAutDPEC) .Or. Alltrim(aXML[nX][8]) $ "2,5,7")

                    cAviso := ""
                    cErro  := ""
                    oCTe := XmlParser(aXML[nX][2],"_",@cAviso,@cErro)

                    oCTeDPEC := XmlParser(aXML[nX][4],"_",@cAviso,@cErro)
                    If Empty(cAviso) .And. Empty(cErro)
                        // ImpDet(@oDACTE,oCTe,cAutoriza,cModalidade,oCTeDPEC,cCodAutDPEC,aXml[nX][6])
                        _lPassou:=.t.
                    EndIf
                Else
                    _cMensagem:=aNotas[nX][04]+aNotas[nX][05]+CRLF
                EndIf
            EndIf

            if _lPassou
                exit
            else
                // Aguarda antes de tentar de novo
                _nSeconds:=seconds()
                do while seconds()-_nSeconds<1
                enddo
                aXml := GetXML(cIdEnt,aNotas,@cModalidade)
            endif

        Next _nTenta
        cNaoAut+=_cMensagem
    Next NX


    _cFilePrint := "DACTE_"+_cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")

    _oDACTE := FWMSPrinter():New(_cFilePrint, IMP_PDF, .F., /*cPathInServer*/, .T.)
    _oDACTE:nDevice := IMP_PDF
    _oDACTE:cPathPDF := "C:\RELPROTHEUS\"
    _oDACTE:lInJob:=.T.

    IF lImprime
        u_PrtCTeSef(_cIdEnt,_cSerie,_cNota,_oDACTE, _oSetup, _cFilePrint)
    ENDIF

    RestArea(_aArea)

RETURN NIL


/*/
    ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
    ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
    ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
    ±±³Programa  ³STATUSCTe ³ Autor ³Eduardo Riera          ³ Data ³18.10.2007³±±
    ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
    ±±³Descri‡…o ³Rotina de monitoramento da CTe - Consulta CTe               ³±±
    ±±³          ³COPIA DE SpedCTe4Mn TIRADA DE SPEDCTe.PRX                   ³±±
    ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
    ±±³Retorno   ³Nenhum                                                      ³±±
    ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
    ±±³Parametros³Nenhum                                                      ³±±
    ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
    ±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
    ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
    ±±³          ³               ³                                            ³±±
    ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
    ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function StatusCTe(_cAlias, _cIdEnt, _cSerie, _cDoc)

//Local _cIdEnt     := ""
    Local cURL       := PadR(GetNewPar("MV_SPEDURL","http://"),250)
    Local cMensagem  := ""
    Local oWS
    LOCAL aReturn:={"","",""}

    If .T. //IsReady()
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Obtem o codigo da entidade                                              ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        //_cIdEnt := GetIdEnt()
        If !Empty(_cIdEnt)
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Instancia a classe                                                      ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If !Empty(_cIdEnt)

                oWs:= WsCTeSBra():New()
                oWs:cUserToken   := "TOTVS"
                oWs:cID_ENT      := _cIdEnt
                oWs:_URL         := AllTrim(cURL)+"/CTeSBRA.apw"
                oWs:cCTeCONSULTAPROTOCOLOID := _cSerie+_cDoc //IIF(_cAlias=="SF1",SF1->F1_SERIE+SF1->F1_DOC,SF2->F2_SERIE+SF2->F2_DOC)

                If oWs:ConsultaProtocoloCTe()
                    cMensagem := ""
                    If !Empty(oWs:oWSCONSULTAPROTOCOLOCTeRESULT:cVERSAO)
                        cMensagem += "STR0129"+": "+oWs:oWSCONSULTAPROTOCOLOCTeRESULT:cVERSAO+CRLF
                    EndIf
                    cMensagem += STR0035+": "+IIf(oWs:oWSCONSULTAPROTOCOLOCTeRESULT:nAMBIENTE==1,STR0056,STR0057)+CRLF //"Produção"###"Homologação"
                    cMensagem += STR0068+": "+oWs:oWSCONSULTAPROTOCOLOCTeRESULT:cCODRETCTe+CRLF
                    cMensagem += STR0069+": "+oWs:oWSCONSULTAPROTOCOLOCTeRESULT:cMSGRETCTe+CRLF
                    If !Empty(oWs:oWSCONSULTAPROTOCOLOCTeRESULT:cPROTOCOLO)
                        cMensagem += STR0050+": "+oWs:oWSCONSULTAPROTOCOLOCTeRESULT:cPROTOCOLO+CRLF
                    EndIf
                    //Aviso(STR0107,cMensagem,{STR0114},3)
                    If !Empty(oWs:oWSCONSULTAPROTOCOLOCTeRESULT:cPROTOCOLO)
                        Do Case
                        Case _cAlias == "SF1" .And. SF1->(FieldPos("F1_FIMP"))<>0
                            RecLock("SF1")
                            SF1->F1_FIMP := "S"
                            MsUnlock()
                        Case _cAlias == "SF2"
                            RecLock("SF2")
                            SF2->F2_FIMP := "S"
                            MsUnlock()
                        EndCase
                    EndIf
                    If oWs:oWSCONSULTAPROTOCOLOCTeRESULT:cCODRETCTe$"110,301,302,303,304,305,306" // Uso Denegado
                        Do Case
                        Case _cAlias == "SF1" .And. SF1->(FieldPos("F1_FIMP"))<>0
                            RecLock("SF1")
                            SF1->F1_FIMP := "D"
                            MsUnlock()
                        Case _cAlias == "SF2"
                            RecLock("SF2")
                            SF2->F2_FIMP := "D"
                            MsUnlock()
                        EndCase
                    EndIf
                Else
                    //Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{STR0114},3)
                    cMensagem:=IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
                EndIf
            EndIf
        Else
            Aviso("SPED","STR0021",{"STR0114"},3)	 //"Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!"
        EndIf
    Else
        Aviso("SPED","STR0021",{"STR0114"},3) //"Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!"
    EndIf

    aReturn[WS_CODRET]:= oWs:oWSCONSULTAPROTOCOLOCTeRESULT:cCODRETCTe
    aReturn[WS_MSG]   := cMensagem
    aReturn[WS_MSGSEF]:= oWs:oWSCONSULTAPROTOCOLOCTeRESULT:cMSGRETCTe

Return(aReturn)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o ambiente de execucao do Totvs Services SPED                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
STATIC FUNCTION SpedCfg(_cIdEnt)
    LOCAL oWs1

    Local cURL := PadR(GetNewPar("MV_SPEDURL","http://"),250)
    LOCAL aReturn:={"",""}

    oWS1:= WsSpedCfgCTe():New()
    oWS1:cUSERTOKEN := "TOTVS"
    oWS1:cID_ENT    := _cIdEnt
    oWS1:_URL       := AllTrim(cURL)+"/SPEDCFGCTe.apw"

    oWs1:nModalidade:= 0
    oWS1:CFGModalidade()
    aReturn[WS1_LCONTG] :=("CONTING"$UPPER(oWS1:cCfgModalidadeResult))

    oWS1:nAmbiente  := 0
    oWS1:CFGAMBIENTE()
    aReturn[WS1_DESCMOD]:=oWS1:cCfgAmbienteResult

RETURN (aReturn)




/*/
    ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
    ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
    ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
    ±±³Programa  ³GetIdEnt  ³ Autor ³Eduardo Riera          ³ Data ³18.06.2007³±±
    ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
    ±±³Descri‡…o ³Obtem o codigo da entidade apos enviar o post para o Totvs  ³±±
    ±±³          ³Service                                                     ³±±
    ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
    ±±³Retorno   ³ExpC1: Codigo da entidade no Totvs Services                 ³±±
    ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
    ±±³Parametros³Nenhum                                                      ³±±
    ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
    ±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
    ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
    ±±³          ³               ³                                            ³±±
    ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
    ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GetIdEnt()

    Local _aArea  := GetArea()
    Local _cIdEnt := ""
    Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
    Local oWs
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    oWS := WsSPEDAdm():New()
    oWS:cUSERTOKEN := "TOTVS"

    oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
    oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
    oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
    oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
    oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
    oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
    oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
    oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
    oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
    oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
    oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
    oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
    oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
    oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
    oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
    oWS:oWSEMPRESA:cCEP_CP     := Nil
    oWS:oWSEMPRESA:cCP         := Nil
    oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
    oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
    oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
    oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
    oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
    oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
    oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
    oWS:oWSEMPRESA:cINDSITESP  := ""
    oWS:oWSEMPRESA:cID_MATRIZ  := ""
    oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
    oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
    If oWs:ADMEMPRESAS()
        _cIdEnt  := oWs:cADMEMPRESASRESULT
    Else
        Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"?"},3)
    EndIf

    RestArea(_aArea)
Return(_cIdEnt)


user Function TrSemWiz(cSerie,cNotaIni,cNotaFim)

    Local aArea       := GetArea()
    Local aPerg       := {}
    Local aParam      := {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC))}
    Local aTexto      := {}
    Local aXML        := {}
    Local cRetorno    := ""
    Local cIdEnt      := ""
    Local cModalidade := ""
    Local cAmbiente   := ""
    Local cVersao     := ""
    Local cVersaoCTe  := ""
    Local cVersaoDpec := ""
    Local cMonitorSEF := ""
    Local cSugestao   := ""
    Local cURL        := PadR(GetNewPar("MV_SPEDURL","http://"),250)
    Local nX          := 0
    Local lOk         := .T.
    Local oWs
    Local oWizard

    If cSerie == Nil
        MV_PAR01 := aParam[01] := PadR(ParamLoad("SPEDCTeREM",aPerg,1,aParam[01]),Len(SF2->F2_SERIE))
        MV_PAR02 := aParam[02] := PadR(ParamLoad("SPEDCTeREM",aPerg,2,aParam[02]),Len(SF2->F2_DOC))
        MV_PAR03 := aParam[03] := PadR(ParamLoad("SPEDCTeREM",aPerg,3,aParam[03]),Len(SF2->F2_DOC))
    Else
        MV_PAR01 := aParam[01] := cSerie
        MV_PAR02 := aParam[02] := cNotaIni
        MV_PAR03 := aParam[03] := cNotaFim
    EndIf

    aadd(aPerg,{1,STR0010,aParam[01],"",".T.","",".T.",30,.F.})	//"Serie da Nota Fiscal"
    aadd(aPerg,{1,STR0011,aParam[02],"",".T.","",".T.",30,.T.})	//"Nota fiscal inicial"
    aadd(aPerg,{1,STR0012,aParam[03],"",".T.","",".T.",30,.T.}) //"Nota fiscal final"

    If .T. //IsReady()
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Obtem o codigo da entidade                                              ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        cIdEnt := GetIdEnt()
        If !Empty(cIdEnt)
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Obtem o ambiente de execucao do Totvs Services SPED                     ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            oWS := WsSpedCfgCTe():New()
            oWS:cUSERTOKEN := "TOTVS"
            oWS:cID_ENT    := cIdEnt
            oWS:nAmbiente  := 0
            oWS:_URL       := AllTrim(cURL)+"/SPEDCFGCTe.apw"
            lOk := oWS:CFGAMBIENTE()
            cAmbiente := oWS:cCfgAmbienteResult
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Obtem a modalidade de execucao do Totvs Services SPED                   ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If lOk
                oWS:cUSERTOKEN := "TOTVS"
                oWS:cID_ENT    := cIdEnt
                oWS:nModalidade:= 0
                oWS:_URL       := AllTrim(cURL)+"/SPEDCFGCTe.apw"
                lOk := oWS:CFGModalidade()
                cModalidade    := oWS:cCfgModalidadeResult
            EndIf
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Obtem a versao de trabalho da CTe do Totvs Services SPED                ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If lOk
                oWS:cUSERTOKEN := "TOTVS"
                oWS:cID_ENT    := cIdEnt
                oWS:cVersao    := "0.00"
                oWS:_URL       := AllTrim(cURL)+"/SPEDCFGCTe.apw"
                lOk := oWS:CFGVersao()
                cVersao        := oWS:cCfgVersaoResult
            EndIf
            If lOk
                oWS:cUSERTOKEN := "TOTVS"
                oWS:cID_ENT    := cIdEnt
                oWS:cVersao    := "0.00"
                oWS:_URL       := AllTrim(cURL)+"/SPEDCFGCTe.apw"
                lOk := oWS:CFGVersaoCTe()
                cVersaoCTe     := oWS:cCfgVersaoCTeResult
            EndIf
            If lOk
                oWS:cUSERTOKEN := "TOTVS"
                oWS:cID_ENT    := cIdEnt
                oWS:cVersao    := "0.00"
                oWS:_URL       := AllTrim(cURL)+"/SPEDCFGCTe.apw"
                lOk := oWS:CFGVersaoDpec()
                cVersaoDpec	   := oWS:cCfgVersaoDpecResult
            EndIf
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Verifica o status na SEFAZ                                              ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If lOk
                oWS:= WSCTeSBRA():New()
                oWS:cUSERTOKEN := "TOTVS"
                oWS:cID_ENT    := cIdEnt
                oWS:_URL       := AllTrim(cURL)+"/CTeSBRA.apw"
                lOk := oWS:MONITORSEFAZMODELO()
                If lOk
                    aXML := oWS:oWsMonitorSefazModeloResult:OWSMONITORSTATUSSEFAZMODELO
                    For nX := 1 To Len(aXML)
                        Do Case
                        Case aXML[nX]:cModelo == "55"
                            cMonitorSEF += "- CTe"+CRLF
                            cMonitorSEF += STR0017+cVersao+CRLF	//"Versao do layout: "
                            If !Empty(aXML[nX]:cSugestao)
                                cSugestao += "Sugestão (CTe)"+": "+aXML[nX]:cSugestao+CRLF //"Sugestão"
                            EndIf

                        Case aXML[nX]:cModelo == "57"
                            cMonitorSEF += "- CTe"+CRLF
                            cMonitorSEF += STR0017+cVersaoCTe+CRLF	//"Versao do layout: "
                            If !Empty(aXML[nX]:cSugestao)
                                cSugestao += "Sugestao(CTe)"+": "+aXML[nX]:cSugestao+CRLF //"Sugestão"
                            EndIf
                        EndCase
                        cMonitorSEF += Space(6)+"Versao da mensagem: "+aXML[nX]:cVersaoMensagem+CRLF //"Versão da mensagem"
                        cMonitorSEF += Space(6)+"Codigo de Status: "+aXML[nX]:cStatusCodigo+"-"+aXML[nX]:cStatusMensagem+CRLF //"Código do Status"
                        cMonitorSEF += Space(6)+"UF Origem: "+aXML[nX]:cUFOrigem //"UF Origem"
                        If !Empty(aXML[nX]:cUFResposta)
                            cMonitorSEF += "("+aXML[nX]:cUFResposta+")"+CRLF //"UF Resposta"
                        Else
                            cMonitorSEF += CRLF
                        EndIf
                        If aXML[nX]:nTempoMedioSEF <> Nil
                            cMonitorSEF += Space(6)+"Tempo de Espera: "+Str(aXML[nX]:nTempoMedioSEF,6)+CRLF //"Tempo de espera"
                        EndIf
                        If !Empty(aXML[nX]:cMotivo)
                            cMonitorSEF += Space(6)+"Motivo: "+aXML[nX]:cMotivo+CRLF //"Motivo"
                        EndIf
                        If !Empty(aXML[nX]:cObservacao)
                            cMonitorSEF += Space(6)+"Observação: "+aXML[nX]:cObservacao+CRLF //"Observação"
                        EndIf
                    Next nX
                EndIf
            EndIf
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Montagem da Interface                                                  ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If (lOk == .T. .or. lOk == Nil)
                aadd(aTexto,{})
                aTexto[1] := STR0013+" " //"Esta rotina tem como objetivo auxilia-lo na transmissão da Nota Fiscal eletrônica para o serviço Totvs Services SPED. "
                aTexto[1] += STR0014+CRLF+CRLF //"Neste momento o Totvs Services SPED, está operando com a seguinte configuração: "
                aTexto[1] += STR0015+cAmbiente+CRLF //"Ambiente: "
                aTexto[1] += STR0016+cModalidade+CRLF	//"Modalidade de emissão: "
                If !Empty(cSugestao)
                    aTexto[1] += CRLF
                    aTexto[1] += cSugestao
                    aTexto[1] += CRLF
                EndIf
                aTexto[1] += cMonitorSEF

                aadd(aTexto,{})
			/*
			DEFINE WIZARD oWizard ;
			TITLE STR0018;
			HEADER STR0019;
			MESSAGE STR0020;
			TEXT aTexto[1] ;
            NEXT {|| .T.} ;
			FINISH {||.T.}
			
			CREATE PANEL oWizard  ;
			HEADER STR0018 ;//"Assistente de transmissão da Nota Fiscal Eletrônica"
			MESSAGE ""	;
			BACK {|| .T.} ;
            NEXT {|| ParamSave("SPEDCTeREM",aPerg,"1"),Processa({|lEnd| cRetorno := SpedCTeTrf(aArea[1],aParam[1],aParam[2],aParam[3],cIdEnt,cAmbiente,cModalidade,cVersao,@lEnd)}),aTexto[02]:= cRetorno,.T.} ;
			PANEL
			ParamBox(aPerg,"SPED - CTe",@aParam,,,,,,oWizard:oMPanel[2],"SPEDCTeREM",.T.,.T.)
			
			CREATE PANEL oWizard  ;
			HEADER STR0018;//"Assistente de configuração da Nota Fiscal Eletrônica"
			MESSAGE "";
			BACK {|| .T.} ;
			FINISH {|| .T.} ;
			PANEL
			@ 010,010 GET aTexto[2] MEMO SIZE 270, 115 READONLY PIXEL OF oWizard:oMPanel[3]
			ACTIVATE WIZARD oWizard CENTERED
			*/

        cRetorno := SpedCTeTrf(aArea[1],aParam[1],aParam[2],aParam[3],cIdEnt,cAmbiente,cModalidade,cVersao,@lEnd)
        aTexto[02]:= cRetorno

    EndIf
EndIf
Else

    Aviso("SPED","Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!",{'STR0114'},3) //"Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!"

EndIf

RestArea(aArea)
Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³SpedDACTE ³ Autor ³Eduardo Riera          ³ Data ³27.06.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de chamada do WS de impressao da DACTE               ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function mySpedDACTE(cIdEnt,_cSerie,_cNota)

    Local oDACTE
    Local nDevice
    Local cFilePrint := "DACTE_"+cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")
    Local oSetup
    Local aDevice  := {}
    Local cSession     := GetPrinterSession()

//AADD(aDevice,"DISCO") // 1
    AADD(aDevice,"SPOOL") // 2
//AADD(aDevice,"EMAIL") // 3
//AADD(aDevice,"EXCEL") // 4
//AADD(aDevice,"HTML" ) // 5
    AADD(aDevice,"PDF"  ) // 6

    nLocal       	:= If(GetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
    nOrientation 	:= If(GetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
    cDevice     	:= GetProfString(cSession,"PRINTTYPE","SPOOL",.T.)
    nPrintType      := aScan(aDevice,{|x| x == cDevice })

    If .T. //IsReady()

        dbSelectArea("SF2")
        RetIndex("SF2")
        dbClearFilter()

        lAdjustToLegacy := .F. // Inibe legado de resolução com a TMSPrinter
        oDACTE := FWMSPrinter():New(cFilePrint, IMP_PDF, lAdjustToLegacy, /*cPathInServer*/, .T.)

        // ----------------------------------------------
        // Cria e exibe tela de Setup Customizavel
        // OBS: Utilizar include "FWPrintSetup.ch"
        // ----------------------------------------------
        //nFlags := PD_ISTOTVSPRINTER+ PD_DISABLEORIENTATION + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
        nFlags := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
        oSetup := FWPrintSetup():New(nFlags, "DACTE")
        // ----------------------------------------------
        // Define saida
        // ----------------------------------------------
        oSetup:SetPropert(PD_PRINTTYPE   , nPrintType)
        oSetup:SetPropert(PD_ORIENTATION , nOrientation)
        oSetup:SetPropert(PD_DESTINATION , nLocal)
        oSetup:SetPropert(PD_MARGIN      , {60,60,60,60})
        oSetup:SetPropert(PD_PAPERSIZE   , DMPAPER_A4)

        // ----------------------------------------------
        // Pressionado botão OK na tela de Setup
        // ----------------------------------------------
        If oSetup:Activate() == PD_OK // PD_OK =1
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Salva os Parametros no Profile             ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

            WriteProfString( cSession, "LOCAL"      , If(oSetup:GetProperty(PD_DESTINATION)==1 ,"SERVER"    ,"CLIENT"    ), .T. )
            WriteProfString( cSession, "PRINTTYPE"  , If(oSetup:GetProperty(PD_PRINTTYPE)==1   ,"SPOOL"     ,"PDF"       ), .T. )
            WriteProfString( cSession, "ORIENTATION", If(oSetup:GetProperty(PD_ORIENTATION)==1 ,"PORTRAIT"  ,"LANDSCAPE" ), .T. )

            If oSetup:GetProperty(PD_ORIENTATION) == 1
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³DACTE Retrato DACTEII.PRW                  ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                u_PrtCTeSef(cIdEnt,_cSerie,_cNota,oDACTE, oSetup, cFilePrint)

            Else
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³DACTE Paisagem DACTEIII.PRW                ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                u_DACTE_P1(cIdEnt,_cSerie,_cNota,oDACTE, oSetup)
            EndIf

        Else
            MsgInfo("Relatório cancelado pelo usuário.")
            Return
        Endif
    EndIf
    oDACTE := Nil
    oSetup := Nil

Return()


Static Function GetXML(cIdEnt,aIdCTe,cModalidade)

    Local cURL       := PadR(GetNewPar("MV_SPEDURL","http://localhost:8080/sped"),250)
    Local oWS
    Local cRetorno   := ""
    Local cProtocolo := ""
    Local cRetDPEC   := ""
    Local cProtDPEC  := ""
    Local nX         := 0
    Local nY         := 0
    Local aRetorno   := {}
    Local aResposta  := {}
    Local aFalta     := {}
    Local aExecute   := {}
    Local nLenCTe
    Local nLenWS
    Local cDHRecbto  := ""
    Local cDtHrRec   := ""
    Local cDtHrRec1	 := ""
    Local nDtHrRec1  := 0
    Local dDtRecib	 :=	CToD("")
    Local cModTrans	 := ""
    Local cAviso	 := ""
    Local cErro		 := ""

    Private oDHRecbto

    If Empty(cModalidade)
        oWS := WsSpedCfgCTe():New()
        oWS:cUSERTOKEN := "TOTVS"
        oWS:cID_ENT    := cIdEnt
        oWS:nModalidade:= 0
        oWS:_URL       := AllTrim(cURL)+"/SPEDCFGCTe.apw"
        If oWS:CFGModalidade()
            cModalidade    := SubStr(oWS:cCfgModalidadeResult,1,1)
        Else
            cModalidade    := ""
        EndIf
    EndIf
    oWS:= WSCTeSBRA():New()
    oWS:cUSERTOKEN        := "TOTVS"
    oWS:cID_ENT           := cIdEnt
    oWS:oWSCTeID          := CTeSBRA_CTeS2():New()
    oWS:oWSCTeID:oWSNotas := CTeSBRA_ARRAYOFCTeSID2():New()
    nLenCTe := Len(aIdCTe)
    For nX := 1 To nLenCTe
        //aadd(aRetorno,{"","",aIdCTe[nX][4]+aIdCTe[nX][5],"","",""})
        aadd(aRetorno,{"","",aIdCTe[nX][4]+aIdCTe[nX][5],"","","",CToD(""),""})
        aadd(oWS:oWSCTeID:oWSNotas:oWSCTeSID2,CTeSBRA_CTeSID2():New())
        Atail(oWS:oWSCTeID:oWSNotas:oWSCTeSID2):cID := aIdCTe[nX][4]+aIdCTe[nX][5]
    Next nX
    oWS:nDIASPARAEXCLUSAO := 0
    oWS:_URL := AllTrim(cURL)+"/CTeSBRA.apw"

    If oWS:RETORNANOTASNX()
        If Len(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSCTeS5) > 0

            For nX := 1 To Len(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSCTeS5)
                cRetorno        := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSCTeS5[nX]:oWSCTe:CXML
                cProtocolo      := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSCTeS5[nX]:oWSCTe:CPROTOCOLO
                cDHRecbto  		:= oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSCTeS5[nX]:oWSCTe:CXMLPROT
                ///////
                oCTeRet			:= XmlParser(cRetorno,"_",@cAviso,@cErro)
                cModTrans		:= IIf(Type("oCTeRet:_CTe:_INFCTe:_IDE:_TPEMIS:TEXT") <> "U",IIf (!Empty("oCTeRet:_CTe:_INFCTe:_IDE:_TPEMIS:TEXT"),oCTeRet:_CTe:_INFCTe:_IDE:_TPEMIS:TEXT,1),1)
                //////

                If ValType(oWs:OWSRETORNANOTASNXRESULT:OWSNOTAS:OWSCTeS5[nX]:OWSDPEC)=="O"
                    cRetDPEC        := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSCTeS5[nX]:oWSDPEC:CXML
                    cProtDPEC       := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSCTeS5[nX]:oWSDPEC:CPROTOCOLO
                EndIf
                //Tratamento para gravar a hora da transmissao da CTe
                If !Empty(cProtocolo)
                    oDHRecbto		:= XmlParser(cDHRecbto,"","","")
                    cDtHrRec		:= oDHRecbto:_ProtCTe:_INFPROT:_DHRECBTO:TEXT
                    nDtHrRec1		:= RAT("T",cDtHrRec)

                    If nDtHrRec1 <> 0
                        cDtHrRec1 := SubStr(cDtHrRec,nDtHrRec1+1)
                        dDtRecib  := SToD(StrTran(SubStr(cDtHrRec,1,AT("T",cDtHrRec)-1),"-",""))
                    EndIf

                    dbSelectArea("SF2")
                    dbSetOrder(1)
                    If MsSeek(xFilial("SF2")+aIdCTe[nX][5]+aIdCTe[nX][4]+aIdCTe[nX][6]+aIdCTe[nX][7])
                        If SF2->(FieldPos("F2_HORA"))<>0 .And. Empty(SF2->F2_HORA)
                            RecLock("SF2")
                            SF2->F2_HORA := cDtHrRec1
                            MsUnlock()
                        EndIf
                    EndIf
                    dbSelectArea("SF1")
                    dbSetOrder(1)
                    If MsSeek(xFilial("SF1")+aIdCTe[nX][5]+aIdCTe[nX][4]+aIdCTe[nX][6]+aIdCTe[nX][7])
                        If SF1->(FieldPos("F1_HORA"))<>0 .And. Empty(SF1->F1_HORA)
                            RecLock("SF1")
                            SF1->F1_HORA := cDtHrRec1
                            MsUnlock()
                        EndIf
                    EndIf
                EndIf
                nY := aScan(aIdCTe,{|x| x[4]+x[5] == SubStr(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSCTeS5[nX]:CID,1,Len(x[4]+x[5]))})
                If nY > 0
                    aRetorno[nY][1] := cProtocolo
                    aRetorno[nY][2] := cRetorno
                    aRetorno[nY][4] := cRetDPEC
                    aRetorno[nY][5] := cProtDPEC
                    aRetorno[nY][6] := cDtHrRec1
                    ///
                    aRetorno[nY][7] := dDtRecib
                    aRetorno[nY][8] := cModTrans
                    //

                    aadd(aResposta,aIdCTe[nY])
                EndIf
                cRetDPEC := ""
                cProtDPEC:= ""
            Next nX
            For nX := 1 To Len(aIdCTe)
                If aScan(aResposta,{|x| x[4] == aIdCTe[nX,04] .And. x[5] == aIdCTe[nX,05] })==0
                    aadd(aFalta,aIdCTe[nX])
                EndIf
            Next nX
            If Len(aFalta)>0
                aExecute := GetXML(cIdEnt,aFalta,@cModalidade)
            Else
                aExecute := {}
            EndIf
            For nX := 1 To Len(aExecute)
                nY := aScan(aRetorno,{|x| x[3] == aExecute[nX][03]})
                If nY == 0
                    aadd(aRetorno,{aExecute[nX][01],aExecute[nX][02],aExecute[nX][03]})
                Else
                    aRetorno[nY][01] := aExecute[nX][01]
                    aRetorno[nY][02] := aExecute[nX][02]
                EndIf
            Next nX
        EndIf
    EndIf

Return(aRetorno)


Static Function IsReady(cURL,nTipo,lHelp)

    Local nX       := 0
    Local cHelp    := ""
    Local oWS
    Local lRetorno := .F.
    DEFAULT nTipo := 1
    DEFAULT lHelp := .F.
    If !Empty(cURL) .And. !PutMV("MV_SPEDURL",cURL)
        RecLock("SX6",.T.)
        SX6->X6_FIL     := xFilial( "SX6" )
        SX6->X6_VAR     := "MV_SPEDURL"
        SX6->X6_TIPO    := "C"
        SX6->X6_DESCRIC := "URL SPED CTe"
        MsUnLock()
        PutMV("MV_SPEDURL",cURL)
    EndIf
    SuperGetMv() //Limpa o cache de parametros - nao retirar
    DEFAULT cURL      := PadR(GetNewPar("MV_SPEDURL","http://"),250)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o servidor da Totvs esta no ar                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    oWs := WsSpedCfgCTe():New()
    oWs:cUserToken := "TOTVS"
    oWS:_URL := AllTrim(cURL)+"/SPEDCFGCTe.apw"
    If oWs:CFGCONNECT()
        lRetorno := .T.
    Else
        If lHelp
            Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"ATENCAO"},3)
        EndIf
        lRetorno := .F.
    EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o certificado digital ja foi transferido                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If nTipo <> 1 .And. lRetorno
        oWs:cUserToken := "TOTVS"
        oWs:cID_ENT    := GetIdEnt()
        oWS:_URL := AllTrim(cURL)+"/SPEDCFGCTe.apw"
        If oWs:CFGReady()
            lRetorno := .T.
        Else
            If nTipo == 3
                cHelp := IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
                If lHelp .And. !"003" $ cHelp
                    Aviso("SPED",cHelp,{"ATENCAO"},3)
                    lRetorno := .F.
                EndIf
            Else
                lRetorno := .F.
            EndIf
        EndIf
    EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o certificado digital ja foi transferido                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If nTipo == 2 .And. lRetorno
        oWs:cUserToken := "TOTVS"
        oWs:cID_ENT    := GetIdEnt()
        oWS:_URL := AllTrim(cURL)+"/SPEDCFGCTe.apw"
        If oWs:CFGStatusCertificate()
            If Len(oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE) > 0
                For nX := 1 To Len(oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE)
                    If oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE[nx]:DVALIDTO-30 <= Date()

                        Aviso("SPED","O certificado digital irá vencer em: "+Dtoc(oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE[nX]:DVALIDTO),{"ATENCAO"},3) //

                    EndIf
                Next nX
            EndIf
        EndIf
    EndIf

Return(lRetorno)

Static Function TRNF(cSerie,cNotaIni,cNotaFim,dDtIni,dDtfim)

    Local cURL     := PadR(GetNewPar("MV_SPEDURL","http://"),250)
    Local aArea    := GetArea()
    Local cSerie   := cSerie
    Local cNotaIni := cNotaIni
    Local cNotaFim := cNotaFim
    Local dDtIni   := dDtIni
    Local dDtFim   := dDtFim

    Local lCTe     := .T.
    Local lRetorno := .F.
    Local cModalidade	:= ""
    Local cVersao		:= ""

    cIdEnt := GetIdEnt()

    oWS := WsSpedCfgCTe():New()
    oWS:cUSERTOKEN := "TOTVS"
    oWS:cID_ENT    := cIdEnt
    oWS:nAmbiente  := 0
    oWS:_URL       := AllTrim(cURL)+"/SPEDCFGCTe.apw"
    lOk := oWS:CFGAMBIENTE()
    cAmbiente := oWS:cCfgAmbienteResult
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem a modalidade de execucao do Totvs Services SPED                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If lOk
        oWS:cUSERTOKEN := "TOTVS"
        oWS:cID_ENT    := cIdEnt
        oWS:nModalidade:= 0
        oWS:_URL       := AllTrim(cURL)+"/SPEDCFGCTe.apw"
        //lOk := oWS:CFGModalidade()
        lOk   := .T.
        //cModalidade    := oWS:cCfgModalidadeResult
        cModalidade    := "1"//oWS:cCfgModalidadeResult
    EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem a versao de trabalho da CTe do Totvs Services SPED                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If lOk
        oWS:cUSERTOKEN := "TOTVS"
        oWS:cID_ENT    := cIdEnt
        oWS:cVersao    := "0.00"
        oWS:_URL       := AllTrim(cURL)+"/SPEDCFGCTe.apw"
        lOk := oWS:CFGVersao()
        cVersao        := oWS:cCfgVersaoResult
    EndIf

    SpedCTeTrf(aArea[1],cSerie   ,cNotaIni ,cNotaFim ,cIdEnt,cAmbiente,cModalidade,cVersao,.T.  ,lCTe,.T.)
//SpedCTeTrf("SF2"   ,aParam[1],aParam[2],aParam[3],cIdEnt,cAmbiente,cModalidade,cVersao,@lEnd,.F. ,.T.)

Return


