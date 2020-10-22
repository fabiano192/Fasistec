#INCLUDE 'TOTVS.CH'
#INCLUDE "TBICONN.CH"
#INCLUDE 'FWMVCDEF.CH'

User Function PXA013(_aSB1,_aSBM,_aZZG,_nOpc)

	// Local _oModelPXA := Nil
	Local _aArea     := Nil
	Local _aAreaSB1  := Nil
	Local _nPrd      := 0

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "00101"

	Private lMsErroAuto := .F.
	Private aRotina := {}

	_aArea     := GetArea()
	_aAreaSB1  := SB1->( GetArea() )
	_aAreaSBM  := SBM->( GetArea() )
	_aAreaZZG  := ZZG->( GetArea() )

	_cCodSb1   := _aSB1[aScan(_aSB1,{|x|x[1] = 'B1_COD'})][2]
	_cCodSbm   := _aSBM[aScan(_aSBM,{|x|x[1] = 'BM_GRUPO'})][2]
	_cCodZzg   := _aZZG[aScan(_aZZG,{|x|x[1] = 'ZZG_COD'})][2]

	SB1->(dbSetOrder(1))
	If SB1->(MsSeek(xFilial("SB1")+_cCodSb1))
		If _nOpc = 3  .Or. _nOpc = 4 //Inclusão - Alteração;
				SB1->(RecLock("SB1",.F.))
			If SB1->(FIELDPOS(Alltrim(_aSB1[_nPrd][1]))) > 0
				&('SB1->'+Alltrim(_aSB1[_nPrd][1])) := _aSB1[_nPrd][2]
			Endif
			SB1->(MsUnLock())
		ElseIf _nOpc = 5 // Exclusão
			// SB1->(RecLock("SB1",.F.))
			// SB1->(dbDelete())
			// SB1->(MsUnLock())
		Endif
	Else
		If _nOpc = 3 .Or. _nOpc = 4 //Inclusão - Alteração;
				// FWMVCRotAuto( _oModelPXA,"SB1",MODEL_OPERATION_INSERT,{{"SB1MASTER", _aSB1}})
			SB1->(RecLock("SB1",.T.))
			For _nPrd := 1 to Len(_aSB1)
				If SB1->(FIELDPOS(Alltrim(_aSB1[_nPrd][1]))) > 0
					&('SB1->'+Alltrim(_aSB1[_nPrd][1])) := _aSB1[_nPrd][2]
				Endif
			Next _nPrd
            SB1->B1_FILIAL := xFilial("SB1")
			SB1->(MsUnLock())
			// ElseIf _nOpc = 5 //exclusão
			//     FWMVCRotAuto( _oModelPXA,"SB1",MODEL_OPERATION_DELETE,{{"SB1MASTER", _aSB1}})
		Endif
	Endif

	SBM->(dbSetOrder(1))
	If !SBM->(MsSeek(xFilial("SBM")+_cCodSbm))
		If _nOpc = 3 .Or. _nOpc = 4 //Inclusão - Alteração;
			SBM->(RecLock("SBM",.T.))
			For _nPrd := 1 to Len(_aSBM)
				If SBM->(FIELDPOS(Alltrim(_aSBM[_nPrd][1]))) > 0
					&('SBM->'+Alltrim(_aSBM[_nPrd][1])) := _aSBM[_nPrd][2]
				Endif
			Next _nPrd
            SBM->BM_FILIAL := xFilial("SBM")
			SBM->(MsUnLock())
		Endif
	Endif

	ZZG->(dbSetOrder(1))
	If !ZZG->(MsSeek(xFilial("ZZG")+_cCodZzg))
		If _nOpc = 3 .Or. _nOpc = 4 //Inclusão - Alteração;
			ZZG->(RecLock("ZZG",.T.))
			For _nPrd := 1 to Len(_aZZG)
				If ZZG->(FIELDPOS(Alltrim(_aZZG[_nPrd][1]))) > 0
					&('ZZG->'+Alltrim(_aZZG[_nPrd][1])) := _aZZG[_nPrd][2]
				Endif
			Next _nPrd
            ZZG->ZZG_FILIAL := xFilial("ZZG")
			ZZG->(MsUnLock())
		Endif
	Endif

	RestArea( _aAreaZZG )
	RestArea( _aAreaSBM )
	RestArea( _aAreaSB1 )
	RestArea( _aArea )

Return(Nil)
