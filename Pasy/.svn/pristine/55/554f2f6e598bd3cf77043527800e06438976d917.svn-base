#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PA219A    º Autor ³ Fabiando da Silva º Data ³  30/09/11    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Emissão de Etiquetas PCP (Prensa)	                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaPCP                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function PA219A()

Private _cProd1 := _cProd2 := ""
Private _aProdY   := {}
Private _aPrdY1   := {}
Private _aPrdY2   := {}
Private _aProdW   := {}
Private _aPrdW1   := {}
Private _aPrdW2   := {}
Private _aMolde ´ := {}
Private _aMold1   := {}
Private _aMold2   := {}
Private _aInserto := {}
Private _aInse1   := {}
Private _aInse2   := {}
Private _aGrpo1   := {}
Private _aGrpo2   := {}
Private _aDispo   := {}
Private _aDisp1   := {}
Private _aDisp2   := {}

Private _cPerg  := "PA0219"

Private _nCont := 0

_cQ := " SELECT * FROM SB1010 B1 "
_cQ += " WHERE B1.D_E_L_E_T_ = '' AND B1_TIPO = 'PA' "
_cQ += " AND B1_COD     BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' "
_cQ += " AND B1_IMPETIQ = 'S' "
_cQ += " ORDER BY B1_COD "

TCQUERY _cQ NEW ALIAS "ZB1"

ZB1->(dbGotop())
ProcRegua(ZB1->(U_CONTREG()))

While ZB1->(!Eof())
	
	IncProc()
	
	SB1->(dbSeek(xFilial("SB1")+ZB1->B1_COD))
	
	SG1->(dbSetOrder(1))
	If SG1->(dbSeek(xFilial("SG1")+ZB1->B1_COD))
		_cProd   := SG1->G1_COD
		nNivel   := 2
		
		SB1->(dbSeek(xFilial("SB1")+_cProd))
		
		NECES(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
		
	Endif
	
	_nCont++
	
	If _nCont = 1
		_cProd1 := ZB1->B1_COD
		_aPrdW1 := ACLONE(_aProdW)
		_aMold1 := ACLONE(_aMolde)
		_aPrdY1 := ACLONE(_aProdY)
		_aInse1 := ACLONE(_aInserto)
		_aDisp1 := ACLONE(_aDispo)
		//		_aGrpo1 := {ZB1->B1_GRPRENS,ZB1->B1_GRPREN2,ZB1->B1_GRPREN3}
		//		_aGrpo1 := {ZB1->B1_GRPRENS,ZB1->B1_GRPREN2}
		_aProdY   := {}
		_aProdW   := {}
		_aMolde ´ := {}
		_aInserto := {}
		_aDispo   := {}
		
	ElseIf _nCont == 2
		_cProd2 := ZB1->B1_COD
		_aPrdW2 := ACLONE(_aProdW)
		_aMold2 := ACLONE(_aMolde)
		_aPrdY2 := ACLONE(_aProdY)
		_aInse2 := ACLONE(_aInserto)
		_aDisp2 := ACLONE(_aDispo)
		//		_aGrpo2 := {ZB1->B1_GRPRENS,ZB1->B1_GRPREN2}
		_aProdY   := {}
		_aProdW   := {}
		_aMolde ´ := {}
		_aInserto := {}
		_aDispo   := {}
		
		ImpEt()
		
		_aPrdY1   := {}
		_aPrdY2   := {}
		_aPrdW1   := {}
		_aPrdW2   := {}
		_aMold1   := {}
		_aMold2   := {}
		_aInse1   := {}
		_aInse2   := {}
		_aGrpo1   := {}
		_aGrpo2   := {}
		_aDisp1   := {}
		_aDisp2   := {}
		
		_nCont := 0
		
	Endif
	
	ZB1->(dbSkip())
EndDo

ZB1->(dbCloseArea())

Return


Static Function NECES(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev)

Local _nReg := 0
Local _nRegTrb := 0

SG1->(dbSetOrder(1))

While SG1->(!Eof()) .And. SG1->G1_COD == _cProd
	
	_nReg := SG1->(Recno())
	
	dbSelectArea("SG1")
	dbSetOrder(1)
	
	aAreaSB1:=SB1->(GetArea())
	SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))
	
	_nRegTRb := SB1->(Recno())
	
	If SB1->B1_GRUPO $ "PIPF/PIPM"   					// Componentes
		AADD(_aProdW,{SG1->G1_COD 	, SG1->G1_COMP })
	ElseIf SB1->B1_GRUPO $ "FRVC/FRVI/FRVT"   		// Molde de Vulcanização / Ferramenta
		AADD(_aMolde,{SG1->G1_COD 	, SG1->G1_COMP, SB1->B1_CAV,SB1->B1_CICLO,SB1->B1_GRPRENS,SB1->B1_GRPREN2,"" })
	ElseIf SB1->B1_GRUPO $ "DPV "   					// DISPOSITIVO
		AADD(_aDispo,{SG1->G1_COD 	, SG1->G1_COMP })
//	ElseIf SB1->B1_GRUPO $  "MPIM"   				// PRE FORMADO / INSERTO  METALICO
//		AADD(_aInserto,{SG1->G1_COD , SG1->G1_COMP })
	ElseIf SB1->B1_GRUPO $ "PIPB"   					// Peça Bruta (Y)
		AADD(_aProdY,{SG1->G1_COD   , SG1->G1_COMP, SB1->B1_CICLO })
	Endif
	
	RestArea(aAreaSB1)
	
	SG1->(dbSetOrder(1))
	If SG1->(dbSeek(xFilial("SG1")+SG1->G1_COMP))
		SB1->(dbSeek(xFilial("SB1")+SG1->G1_COD))
		NECES(SG1->G1_COD,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
	EndIf
	
	SG1->(dbGoto(_nReg))
	
	SG1->(dbSkip())
EndDo

Return




Static Function ImpEt()

_lEnt1 := _lEnt2 := .F.

MSCBPRINTER("ARGOX",_cPorta,,,.f.)
MSCBCHKSTATUS(.f.)

MSCBBEGIN(1,6)

//MSCBLINEV(49,02,70,2,"B")
_nLin1 := _nLin2 := 103

MSCBSAY(20,_nLin1,_cProd1				  		    , "N", "4", "1,1" ,.F.) //60
MSCBSAY(70,_nLin2,_cProd2				  			, "N", "4", "1,1" ,.F.)

_nLin1 -= 2
_nLin2 -= 2

MSCBLINEH(05,_nLin1,045,1,"B")
MSCBLINEH(55,_nLin2,095,1,"B") //59.5

_nLin1 -= 4
_nLin2 -= 4

MSCBSAY(05,_nLin1,"PECA BRUTA:"    	              	, "N", "2", "1",.F.)
For A:=1 To Len(_aPrdY1)
	MSCBSAY(28,_nLin1,_aPrdY1[A][2]              	, "N", "2", "1",.F.)
	_nLin1 -= 4
	_lEnt1 := .T.
Next A
MSCBSAY(55,_nLin2,"PECA BRUTA:"    	              	, "N", "2", "1",.F.)
For B:=1 To Len(_aPrdY2)
	MSCBSAY(78,_nLin2,_aPrdY2[B][2]              	, "N", "2", "1",.F.)
	_nLin2 -= 4
	_lEnt2 := .T.
Next B

If _lEnt1
	_nLin1 += 2
Endif
If _lEnt2
	_nLin2 += 2
Endif
_lEnt1 := _lEnt2 := .F.

MSCBLINEH(05,_nLin1,045,1,"B")
MSCBLINEH(55,_nLin2,095,1,"B")

_nLin1 -= 4
_nLin2 -= 4

MSCBSAY(05,_nLin1,"COMPONENTES:"                    , "N", "2", "1",.F.)
For C:=1 To Len(_aPrdW1)
	MSCBSAY(28,_nLin1,_aPrdW1[C][2]              	, "N", "2", "1",.F.)
	_nLin1 -= 4
	_lEnt1 := .T.
Next C
For C:=1 To Len(_aInse1)
	MSCBSAY(28,_nLin1,_aInse1[C][2]              	, "N", "2", "1",.F.)
	_nLin1 -= 4
	_lEnt1 := .T.
Next C


MSCBSAY(55,_nLin2,"COMPONENTES:"                    , "N", "2", "1",.F.)
For D:=1 To Len(_aPrdW2)
	MSCBSAY(78,_nLin2,_aPrdW2[D][2]              	, "N", "2", "1",.F.)
	_nLin2 -= 4
	_lEnt2 := .T.
Next D
For D:=1 To Len(_aInse2)
	MSCBSAY(78,_nLin2,_aInse2[D][2]              	, "N", "2", "1",.F.)
	_nLin2 -= 4
	_lEnt2 := .T.
Next D

If _lEnt1
	_nLin1 += 2
Else
	_nLin1 -= 4
Endif
If _lEnt2
	_nLin2 += 2
Else
	_nLin2 -= 4
Endif
_lEnt1 := _lEnt2 := .F.

MSCBLINEH(05,_nLin1,045,1,"B")
MSCBLINEH(55,_nLin2,095,1,"B")

_nLin1 -= 5
_nLin2 -= 5

MSCBSAY(05,_nLin1,"FERRAMENTAIS-OPC 1"       , "N", "3", "1,1",.F.)
_nLin1 -= 4
MSCBSAY(05,_nLin1,"CODIGO:"       				 , "N", "2", "1",.F.)
If Len(_aMold1) > 0
	
	MSCBSAY(28,_nLin1,_aMold1[1][2]              , "N", "2", "1",.F.)
	_nLin1 -= 4
	For E1:=1 To Len(_aDisp1)
		If _aMold1[1][2] = _aDisp1[E1][1]
			MSCBSAY(28,_nLin1,_aDisp1[E1][2]       , "N", "2", "1",.F.)
			_nLin1 -= 4
		Endif
	Next E1

	_lGo := .F.	
	MSCBSAY(05,_nLin1,"REC.PRODUTIVO:"           , "N", "2", "1",.F.)
	If !Empty(_aMold1[1][5])
		MSCBSAY(78,_nLin1,_aMold1[1][5]              , "N", "2", "1",.F.)
		_nLin1 -= 4
		_lGo := .T.
	Endif
	If !Empty(_aMold1[1][6])
		MSCBSAY(78,_nLin1,_aMold1[1][6]              , "N", "2", "1",.F.)
		_nLin1 -= 4
		_lGo := .T.	
	Endif
	If !Empty(_aMold1[1][7])
		MSCBSAY(78,_nLin1,_aMold1[1][7]              , "N", "2", "1",.F.)
		_nLin1 -= 4
		_lGo := .T.
	Endif
	If !_lGo       
		_nLin1 -= 4
	Endif	
	MSCBSAY(05,_nLin1,"PPH:"           			 , "N", "2", "1",.F.)
	_nPPH := (60 / _aMold1[1][4]) * Val(_aMold1[1][3])
	MSCBSAY(28,_nLin1,Alltrim(TRANSFORM(_nPPH,"@E 9,999.99")), "N", "2", "1",.F.)
	_nLin1 -= 4
	_lEnt1 := .T.
Endif

MSCBSAY(55,_nLin2,"FERRAMENTAIS-OPC 1"       , "N", "3", "1,1",.F.)
_nLin2 -= 4
MSCBSAY(55,_nLin2,"CODIGO:"       				 , "N", "2", "1",.F.)
If Len(_aMold2) > 0
	MSCBSAY(78,_nLin2,_aMold2[1][2]              , "N", "2", "1",.F.)
	_nLin2 -= 4
	For F1:=1 To Len(_aDisp2)
		If _aMold2[1][2] = _aDisp2[F1][1]
			MSCBSAY(78,_nLin2,_aDisp2[F1][2]       , "N", "2", "1",.F.)
			_nLin2 -= 4
		Endif
	Next F1

	_lGo := .F.
	MSCBSAY(55,_nLin2,"REC.PRODUTIVO:"           , "N", "2", "1",.F.)
	If !Empty(_aMold2[1][5])
		MSCBSAY(78,_nLin2,_aMold2[1][5]              , "N", "2", "1",.F.)
		_nLin2 -= 4
		_lGo := .T.
	Endif
	If !Empty(_aMold2[1][6])
		MSCBSAY(78,_nLin2,_aMold2[1][6]              , "N", "2", "1",.F.)
		_nLin2 -= 4
		_lGo := .T.	
	Endif
	If !Empty(_aMold2[1][7])
		MSCBSAY(78,_nLin2,_aMold2[1][7]              , "N", "2", "1",.F.)
		_nLin2 -= 4
		_lGo := .T.
	Endif
	If !_lGo       
		_nLin2 -= 4
	Endif	
	MSCBSAY(55,_nLin2,"PPH:"           			 , "N", "2", "1",.F.)
	_nPPH := (60 / _aMold2[1][4]) * val(_aMold2[1][3])
	MSCBSAY(78,_nLin2,TRANSFORM(_nPPH,"@E 9,999.99"), "N", "2", "1",.F.)
	_nLin2 -= 4
	_lEnt2 := .T.
Endif

If _lEnt1
	_nLin1 += 2
Else
	_nLin1 -= 4
Endif
If _lEnt2
	_nLin2 += 2
Else
	_nLin2 -= 4
Endif
_lEnt1 := _lEnt2 := .F.

MSCBLINEH(05,_nLin1,045,1,"B")
MSCBLINEH(55,_nLin2,095,1,"B")

_nLin1 -= 5
_nLin2 -= 5

If Len(_aMold1) > 1
MSCBSAY(05,_nLin1,"FERRAMENTAIS-OPC 2"       , "N", "3", "1,1",.F.)
_nLin1 -= 4
MSCBSAY(05,_nLin1,"CODIGO:"       				 , "N", "2", "1",.F.)

	MSCBSAY(28,_nLin1,_aMold1[2][2]              , "N", "2", "1",.F.)
	_nLin1 -= 4
	For E1:=1 To Len(_aDisp1)
		If _aMold1[2][2] = _aDisp1[E1][1]
			MSCBSAY(28,_nLin1,_aDisp1[E1][2]       , "N", "2", "1",.F.)
			_nLin1 -= 4
		Endif
	Next E1

	_lGo := .F.	
	MSCBSAY(05,_nLin1,"REC.PRODUTIVO:"           , "N", "2", "1",.F.)
	If !Empty(_aMold1[1][5])
		MSCBSAY(78,_nLin1,_aMold1[1][5]              , "N", "2", "1",.F.)
		_nLin1 -= 4
		_lGo := .T.
	Endif
	If !Empty(_aMold1[1][6])
		MSCBSAY(78,_nLin1,_aMold1[1][6]              , "N", "2", "1",.F.)
		_nLin1 -= 4
		_lGo := .T.	
	Endif
	If !Empty(_aMold1[1][7])
		MSCBSAY(78,_nLin1,_aMold1[1][7]              , "N", "2", "1",.F.)
		_nLin1 -= 4
		_lGo := .T.
	Endif
	If !_lGo       
		_nLin1 -= 4
	Endif	
	MSCBSAY(05,_nLin1,"PPH:"           			 , "N", "2", "1",.F.)
	_nPPH := (60 / _aMold1[2][4]) * Val(_aMold1[2][3])
	MSCBSAY(28,_nLin1,TRANSFORM(_nPPH,"@E 9,999.99"), "N", "2", "1",.F.)
	_nLin1 -= 4
	_lEnt1 := .T.
Endif

If Len(_aMold2) > 1
	MSCBSAY(55,_nLin2,"FERRAMENTAIS-OPC 2"       , "N", "3", "1,1",.F.)
	_nLin2 -= 4
	MSCBSAY(55,_nLin2,"CODIGO:"       				 , "N", "2", "1",.F.)
	MSCBSAY(78,_nLin2,_aMold2[2][2]              , "N", "2", "1",.F.)
	_nLin2 -= 4
	For F1:=1 To Len(_aDisp2)
		If _aMold2[2][2] = _aDisp2[F1][1]
			MSCBSAY(78,_nLin2,_aDisp2[F1][2]       , "N", "2", "1",.F.)
			_nLin2 -= 4
		Endif
	Next F1

	_lGo := .F.	
	MSCBSAY(55,_nLin2,"REC.PRODUTIVO:"           , "N", "2", "1",.F.)
	If !Empty(_aMold2[1][5])
		MSCBSAY(78,_nLin2,_aMold2[1][5]              , "N", "2", "1",.F.)
		_nLin2 -= 4
		_lGo := .T.
	Endif
	If !Empty(_aMold2[1][6])
		MSCBSAY(78,_nLin2,_aMold2[1][6]              , "N", "2", "1",.F.)
		_nLin2 -= 4
		_lGo := .T.	
	Endif
	If !Empty(_aMold2[1][7])
		MSCBSAY(78,_nLin2,_aMold2[1][7]              , "N", "2", "1",.F.)
		_nLin2 -= 4
		_lGo := .T.
	Endif
	If !_lGo       
		_nLin2 -= 4
	Endif	
	MSCBSAY(55,_nLin2,"PPH:"           			 , "N", "2", "1",.F.)
	_nPPH := (60 / _aMold2[2][4]) * Val(_aMold2[2][3])
	MSCBSAY(78,_nLin2,TRANSFORM(_nPPH,"@E 9,999.99"), "N", "2", "1",.F.)
	_nLin2 -= 4
	_lEnt2 := .T.
Endif

If _lEnt1
	_nLin1 += 2
	MSCBLINEH(05,_nLin1,045,1,"B")
	_nLin1 -= 4
Else
	_nLin1 -= 4
Endif
If _lEnt2
	_nLin2 += 2
	MSCBLINEH(55,_nLin2,095,1,"B")
	_nLin2 -= 4
Else
	_nLin2 -= 4
Endif
_lEnt1 := _lEnt2 := .F.

MSCBSAY(05,_nLin1,"QUANTIDADE:"  		            , "N", "2", "1",.F.)
_nLin1 -= 3
MSCBBOX(05,_nLin1-16,44.9,_nLin1,1,"B")

MSCBSAY(55,_nLin2,"QUANTIDADE:"  		            , "N", "2", "1",.F.)
_nLin2 -= 3
MSCBBOX(55,_nLin2-16,095,_nlin2,1,"B")

MSCBEND()

MSCBClosePrinter()

Return

