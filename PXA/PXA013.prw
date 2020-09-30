#INCLUDE 'TOTVS.CH'
#INCLUDE "TBICONN.CH"
#INCLUDE 'FWMVCDEF.CH'

User Function PXA013(_aDados,_nOpc)

    Local _oModelPXA := Nil
    Local _aArea     := Nil
    Local _aAreaSB1  := Nil
    Local _nPrd      := 0

    PREPARE ENVIRONMENT EMPRESA "01" FILIAL "00101"
    // RPCSetEnv("99", "01")

    Private lMsErroAuto := .F.
    Private aRotina := {}

    _aArea     := GetArea()
    _aAreaSB1  := SB1->( GetArea() )

    // _oModelPXA := FWLoadModel( 'MATA010' )
    _cCodSb1   := _aDados[aScan(_aDados,{|x|x[1] = 'B1_COD'})][2]

    SB1->(dbSetOrder(1))
    If SB1->(MsSeek(xFilial("SB1")+_cCodSb1))
        If _nOpc = 3  .Or. _nOpc = 4 //Inclusão - Alteração;
            // FWMVCRotAuto( _oModelPXA,"SB1",MODEL_OPERATION_UPDATE,{{"SB1MASTER", _aDados}})
            SB1->(RecLock("SB1",.F.))
            If SB1->(FIELDPOS(Alltrim(_aDados[_nPrd][1]))) > 0
                &('SB1->'+Alltrim(_aDados[_nPrd][1])) := _aDados[_nPrd][2]
            Endif
            SB1->(MsUnLock())
        ElseIf _nOpc = 5 // Exclusão
            // FWMVCRotAuto( _oModelPXA,"SB1",MODEL_OPERATION_DELETE,{{"SB1MASTER", _aDados}})
            SB1->(RecLock("SB1",.F.))
            SB1->(dbDelete())
            SB1->(MsUnLock())
        Endif
    Else
        If _nOpc = 3 .Or. _nOpc = 4 //Inclusão - Alteração;
                // FWMVCRotAuto( _oModelPXA,"SB1",MODEL_OPERATION_INSERT,{{"SB1MASTER", _aDados}})
            SB1->(RecLock("SB1",.T.))
            For _nPrd := 1 to Len(_aDados)
                If SB1->(FIELDPOS(Alltrim(_aDados[_nPrd][1]))) > 0
                    &('SB1->'+Alltrim(_aDados[_nPrd][1])) := _aDados[_nPrd][2]
                Endif
            Next _nPrd
            SB1->(MsUnLock())
            // ElseIf _nOpc = 5 //exclusão
            //     FWMVCRotAuto( _oModelPXA,"SB1",MODEL_OPERATION_DELETE,{{"SB1MASTER", _aDados}})
        Endif
    Endif

// MSExecAuto({|x,y| Mata010(x,y)},aVetor,3)

// MSExecAuto({|x,y| Mata010(x,y)},aVetor,4)

    RestArea( _aAreaSB1 )
    RestArea( _aArea )

Return(Nil)
