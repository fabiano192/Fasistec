#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PA219C    º Autor ³ Fabiando da Silva º Data ³  26/10/11    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Emissão de Etiquetas PCP (Preparacao)                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaPCP                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function PA219C()

Private _cProd1 := _cProd2 := ""
Private _aMater   := {}
Private _aMate1   := {}
Private _aMate2   := {}
Private _aMolde   := {}
Private _aMold1   := {}
Private _aMold2   := {}
Private _aComp    := {}
Private _aComp1   := {}
Private _aComp2   := {}
	
Private _nCont := 0

_cQ := " SELECT * FROM SB1010 B1 "
_cQ += " INNER JOIN "+RetSqlName("SG1")+" G1 ON B1_COD = G1_COMP "
_cQ += " WHERE B1.D_E_L_E_T_ = '' AND G1.D_E_L_E_T_ = '' AND B1_GRUPO = 'PAV' "
_cQ += " AND B1_COD     BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' "
//_cQ += " AND B1_IMPETIQ = 'S' "
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
		_aMate1 := ACLONE(_aMater)
		_aMold1 := ACLONE(_aMolde)
		_aComp1 := ACLONE(_aComp)
		
		_aMater   := {}
		_aMolde   := {}
		_aComp    := {}
		
	ElseIf _nCont == 2
		_cProd2 := ZB1->B1_COD

		_aMate2 := ACLONE(_aMater)
		_aMold2 := ACLONE(_aMolde)
		_aComp2 := ACLONE(_aComp)

		_aMater   := {}
		_aMolde   := {}
		_aComp    := {}
		
		ImpEt()
		
		_aMate1   := {}
		_aMate2   := {}
		_aMold1   := {}
		_aMold2   := {}
		_aComp1   := {}
		_aComp2   := {}
		
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
	
	If SB1->B1_GRUPO $ "PIBK"   // Material Utilizado
			
		AADD(_aMater,{SG1->G1_COD , SG1->G1_COMP })

	ElseIf SB1->B1_GRUPO $ "FRFG/DPA "   		// Ferramenta / DISPOSITIVOS
		AADD(_aMolde,{SG1->G1_COD 	, SG1->G1_COMP, SB1->B1_CAV,SB1->B1_CICLO,SB1->B1_GRPRENS,SB1->B1_GRPREN2,"" })
		
	ElseIf SB1->B1_GRUPO $ "MPVZ/MPG"             // Componentes
		AADD(_aComp,{SG1->G1_COD 	, SG1->G1_COMP })
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

For A:=1 To Len(_aMate1)
	MSCBSAY(23,_nLin1,_aMate1[A][2]   		           	, "N", "2", "1",.F.)
	_nLin1 -= 4
	
	_lEnt1 := .T.
Next A

For A:=1 To Len(_aMate2)
	MSCBSAY(73,_nLin2,_aMate2[A][2]   		           	, "N", "2", "1",.F.)
	_nLin2 -= 4
	
	_lEnt2 := .T.
Next A

If _lEnt1
	_nLin1 += 2
	MSCBLINEH(05,_nLin1,045,1,"B")
	_nLin1 -= 4
Else
	_nLin1 -= 2
Endif
If _lEnt2
	_nLin2 += 2
	MSCBLINEH(55,_nLin2,095,1,"B")
	_nLin2 -= 4
Else
	_nLin2 -= 2
Endif
_lEnt1 := _lEnt2 := .F.

MSCBSAY(05,_nLin1,"COMPONENTES:"    	           	, "N", "2", "1",.F.)
For A:=1 To Len(_aComp1)
	MSCBSAY(28,_nLin1,_aComp1[A][2]   		           	, "N", "2", "1",.F.)
	_nLin1 -= 4
	
	_lEnt1 := .T.
Next A

MSCBSAY(55,_nLin2,"COMPONENTES:"    	           	, "N", "2", "1",.F.)
For A:=1 To Len(_aComp2)
	MSCBSAY(78,_nLin2,_aComp2[A][2]   		           	, "N", "2", "1",.F.)
	_nLin2 -= 4
	
	_lEnt2 := .T.
Next A

If _lEnt1
	_nLin1 += 2
Else
	_nLin1 -= 2
Endif
If _lEnt2
	_nLin2 += 2
Else
	_nLin2 -= 2
Endif
_lEnt1 := _lEnt2 := .F.

MSCBLINEH(05,_nLin1,045,1,"B")
MSCBLINEH(55,_nLin2,095,1,"B")
  
_nLin1 -= 4
_nLin2 -= 4

MSCBSAY(05,_nLin1,"FERRAMENTAS / DISPOSITIVOS:"    	           	, "N", "2", "1",.F.)
_nLin1 -= 4
For A:=1 To Len(_aMold1)
	MSCBSAY(28,_nLin1,_aMold1[A][2]   		           	, "N", "2", "1",.F.)
	_nLin1 -= 4
	
	_lEnt1 := .T.
Next A

MSCBSAY(55,_nLin2,"FERRAMENTAS / DISPOSITIVOS:"    	           	, "N", "2", "1",.F.)
_nLin2 -= 4
For A:=1 To Len(_aMold2)
	MSCBSAY(78,_nLin2,_aMold2[A][2]   		           	, "N", "2", "1",.F.)
	_nLin2 -= 4
	
	_lEnt2 := .T.
Next A

_nLin1 -= 2
_nLin2 -= 2

MSCBLINEH(05,_nLin1,045,1,"B")
MSCBLINEH(55,_nLin2,095,1,"B")
  
_nLin1 -= 4
_nLin2 -= 4
  
MSCBSAY(05,_nLin1,"QUANTIDADE:"  		            , "N", "2", "1",.F.)
_nLin1 -= 3
MSCBBOX(05,_nLin1-16,44.9,_nLin1,1,"B")

MSCBSAY(55,_nLin2,"QUANTIDADE:"  		            , "N", "2", "1",.F.)
_nLin2 -= 3
MSCBBOX(55,_nLin2-16,095,_nlin2,1,"B")

MSCBEND()

MSCBClosePrinter()

Return
