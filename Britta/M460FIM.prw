
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460FIM   ºAutor  ³MARCIO AFLITOS      º Data ³  31/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PONTO DE ENTRADA EXECUTADO APOS A GERACAO E GRAVACAO DO    º±±
±±º          ³ DOCUMENTO DE SAIDA (NF)                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M460Fim()

    LOCAL _cSerie  :=SF2->F2_SERIE
    LOCAL _cNotaIni:=SF2->F2_DOC
    LOCAL _cNotafim:=SF2->F2_DOC
    LOCAL _dDtIni  :=SF2->F2_EMISSAO
    LOCAL _dDtFim  :=SF2->F2_EMISSAO

    LOCAL cRet

    IF Empty(_cSerie) .OR. Empty(_cNotaIni)
        Alert("NOTA FISCAL INVALIDA. NUMERO OU SERIE ESTðO EM BRANCO")
        RETURN .F.
    ENDIF


    U_BRI137()

    //U_GRLOG(Procname(),cModulo,__CUSERID,Ddatabase,Time(),cEmpAnt,cFilAnt)

    If _cSerie $ ("FAT/NDS/ECF")
        RETURN .T.
    Endif
    If Alltrim(SF2->F2_ESPECIE) == "SPED" //.And. UPPER(Alltrim(cUserName)) != "ALE"
        U_MyDanfeProc(_cSerie,_cNotaIni,_dDtIni)
    Endif

RETURN .T.