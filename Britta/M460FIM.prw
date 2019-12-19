
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460FIM   �Autor  �MARCIO AFLITOS      � Data �  31/03/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � PONTO DE ENTRADA EXECUTADO APOS A GERACAO E GRAVACAO DO    ���
���          � DOCUMENTO DE SAIDA (NF)                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M460Fim()

    LOCAL _cSerie  :=SF2->F2_SERIE
    LOCAL _cNotaIni:=SF2->F2_DOC
    LOCAL _cNotafim:=SF2->F2_DOC
    LOCAL _dDtIni  :=SF2->F2_EMISSAO
    LOCAL _dDtFim  :=SF2->F2_EMISSAO

    LOCAL cRet

    IF Empty(_cSerie) .OR. Empty(_cNotaIni)
        Alert("NOTA FISCAL INVALIDA. NUMERO OU SERIE EST�O EM BRANCO")
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