#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSGRAPHI.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0214   ³ Autor ³ Fabiano da Silva      ³ Data ³ 26.07.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carga máquina                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0214()

LOCAL oDlg        := NIL
Private cTitulo   := "Carga Maquina"
Private _cNome    := ""
Private _cRecu    := ""
Private _nConta   := 0
Private _nCont    := 0
Private _cCont    := ""
PRIVATE oPrn      := NIL
PRIVATE oFont     := NIL
PRIVATE oFont1    := NIL
PRIVATE oFont5    := NIL
Private _cGrPren

AtuSX1()

_cLocPad   := _cQtCav := ""
_cQtPPS    := _cPPS   := ""
_nSdoAcab  := 0
_nMedida   := 0
_cMolde :=  ""
_nOpc      := 0

DEFINE FONT oFont1 NAME "Arial" SIZE 0,13 OF oPrn BOLD
DEFINE FONT oFont2 NAME "Arial" SIZE 0,10 OF oPrn BOLD

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

@ 002,010 TO 060,157 LABEL "" OF oDlg PIXEL

@ 10,18 SAY "Rotina criado para Gerar Carga Máquina    "     OF oDlg PIXEL Size 150,010 FONT oFont1 COLOR CLR_BLUE
@ 18,18 SAY "com dados necessarios para controle PCP.  "     OF oDlg PIXEL Size 150,010 FONT oFont1 COLOR CLR_BLUE
@ 26,18 SAY "Conforme Relacionamento com a Estrutura.  "     OF oDlg PIXEL Size 150,010 FONT oFont1 COLOR CLR_BLUE
@ 34,18 SAY "Programa PA0214 (TABELA) PA0214.DBF       "     OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_RED

@ 70,020 BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("PA0214"))	OF oDlg PIXEL
@ 70,090 BUTTON "OK" 		 SIZE 036,012 ACTION (Proces(),oDlg:End()) 	OF oDlg PIXEL
@ 70,160 BUTTON "Sair"       SIZE 036,012 ACTION ( oDlg:End()) 			OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return


Static Function Proces()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| Proc1(@_lFim) }
Private _cTitulo01 := 'Processando Dados'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cArqNovo := "\SPOOL\PA0214.DBF"
dbSelectArea("TRB")

Copy all to &_cArqNovo
dbCloseArea()

TMP->(dbCloseArea())

If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\SPOOL\PA0214.DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return



Static Function Proc1(_lFim)

Pergunte("PA0214",.F.)

///////////////////////////////////////////
////// GRUPO DE PERGUNTAS /////////////////
///// MV_PAR01 - ENTREGA De  ?         ////
///// MV_PAR02 - ENTREGA Ate ?         ////
///////////////////////////////////////////

Private _nNiv := 0
Private _lGravou := .F.

aStru := {}
AADD(aStru,{"EMISSAO"     , "D" , 08, 0 })
AADD(aStru,{"CLIENTE"     , "C" , 06, 0 })
AADD(aStru,{"NOMECLI"     , "C" , 40, 0 })
AADD(aStru,{"LOJA"        , "C" , 02, 0 })
AADD(aStru,{"PRODUTO"     , "C" , 15, 0 })
AADD(aStru,{"NOMPROD"     , "C" , 50, 0 })
AADD(aStru,{"DTENTR"      , "D" , 08, 0 })
AADD(aStru,{"PRODCLI"     , "C" , 15, 0 })
AADD(aStru,{"MOLDE"       , "C" , 45, 0 })
AADD(aStru,{"QTCAVID"     , "C" , 03, 0 })
AADD(aStru,{"PEDIDO"      , "C" , 06, 0 })
AADD(aStru,{"ITEMPV"      , "C" , 02, 0 })
AADD(aStru,{"TIPOPV"      , "C" , 20, 0 })
AADD(aStru,{"QTDPED"      , "N" , 12, 2 })
AADD(aStru,{"QTDENT"      , "N" , 12, 2 })
AADD(aStru,{"QTDSDO"      , "N" , 12, 2 })
AADD(aStru,{"PRUNIT"      , "N" , 12, 2 })
AADD(aStru,{"PPS"	      , "C" , 15, 0 })
AADD(aStru,{"CAV_PPS"     , "C" , 03, 0 })
AADD(aStru,{"GRPRENS"     , "C" , 06, 0 })
AADD(aStru,{"PRENSA"      , "C" , 25, 0 })
AADD(aStru,{"ITSIMU"      , "N" , 10, 2 })
AADD(aStru,{"CICLO"       , "N" , 06, 2 })
AADD(aStru,{"PRENSAD"     , "N" , 12, 2 })
AADD(aStru,{"PORCENT"     , "N" , 12, 2 })
AADD(aStru,{"ARREDON"     , "N" , 12, 2 })
AADD(aStru,{"MINUTOS"     , "N" , 12, 2 })
AADD(aStru,{"HORAS"       , "N" , 12, 2 })
AADD(aStru,{"QTDPROD"     , "N" , 12, 0 })
AADD(aStru,{"LOCALPR"     , "C" , 02, 0 })
AADD(aStru,{"DTINICI"     , "D" , 08, 0 })
AADD(aStru,{"DTFINAL"     , "D" , 08, 0 })
AADD(aStru,{"HRINICI"     , "C" , 10, 0 })
AADD(aStru,{"HRFINAL"     , "C" , 10, 0 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "GRPRENS+DTOS(DTENTR)+PRODUTO+PEDIDO+ITEMPV
//_cIndTrb := "GRPRENS+DTOS(DTENTR)+PRODUTO+PEDIDO+ITEMPV

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

aStru := {}
AADD(aStru,{"PRODUTO"     , "C" , 15, 0 })
AADD(aStru,{"MOLDE"       , "C" , 45, 0 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "PRODUTO"

dbUseArea(.T.,,_cArqTrb,"TMP",.F.,.F.)

dbSelectArea("TMP")
IndRegua("TMP",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

aStru := {}
AADD(aStru,{"GRPRENS"     , "C" , 06, 0 })
AADD(aStru,{"LOCALPR"     , "C" , 02, 0 })
//AADD(aStru,{"PRODUTO"     , "C" , 15, 0 })
AADD(aStru,{"DTINICI"     , "D" , 08, 0 })
AADD(aStru,{"DTFINAL"     , "D" , 08, 0 })
AADD(aStru,{"HRINICI"     , "C" , 10, 0 })
AADD(aStru,{"HRFINAL"     , "C" , 10, 0 })

_cArqTrb  := CriaTrab(aStru,.T.)
//_cArqTrbA := Left(_cArqTrb,7)+"A"

_cIndTrb  := "GRPRENS+dtos(DTINICI)+LOCALPR+DTOS(DTFINAL)+HRFINAL"
//_cIndTrbA := "GRPRENS+PRODUTO+DTOS(DTFINAL)+HRFINAL"

dbUseArea(.T.,,_cArqTrb,"TMP2",.F.,.F.)

dbSelectArea("TMP2")

IndRegua("TMP2",_cArqTrb ,_cIndTrb ,,,"Criando Trabalho...")
//IndRegua("TMP2",_cArqTrb ,_cIndTrbA,,,"Criando Trabalho...")


_cPed := "("
For Ax:= 1 To Len(MV_PAR01)
	If Substr(MV_PAR01,AX,1) != "*"
		If _cPed == "("
			_cPed += "'"+Substr(MV_PAR01,AX,1)
		Else
			_cPed += "','"+Substr(MV_PAR01,AX,1)
		Endif
	Endif
Next AX

_cPed += "')"

_cQ := " SELECT * FROM "+RetsqlName("SC6")+" C6  "
_cQ += " INNER JOIN "+RetsqlName("SC5")+" C5 ON C6_NUM=C5_NUM "
_cQ += " INNER JOIN "+RetSqlName("SB1")+" B1 ON C6_PRODUTO=B1_COD "
_cQ += " INNER JOIN "+RetSqlName("SF4")+" F4 ON C6_TES=F4_CODIGO "
_cQ += " WHERE B1.D_E_L_E_T_ = '' AND C5.D_E_L_E_T_ = '' AND C6.D_E_L_E_T_ = '' "
_cQ += " AND C6_QTDVEN > C6_QTDENT "
_cQ += " AND C6_PEDAMOS IN "+_cPed+" "
_cQ += " AND C5_TIPO = 'N' AND B1_TIPO = 'PA' AND F4_ESTOQUE = 'S' "
_cQ += " AND C6_ENTREG < '20100901' "
_cQ += " ORDER BY C6_ENTREG+C6_PRODUTO "

TCQUERY _cQ NEW ALIAS "ZC6"

TCSETFIELD("ZC6","C6_ENTREG","D")
TCSETFIELD("ZC6","C5_EMISSAO","D")

ZC6->(dbGotop())
ProcRegua(ZC6->(U_CONTREG()))

While ZC6->(!Eof()) .And. !_lFim
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	IncProc()
	
	SB1->(dbSeek(xFilial("SB1")+ZC6->C6_PRODUTO))
	
	SG1->(dbSetOrder(1))
	If SG1->(dbSeek(xFilial("SG1")+ZC6->C6_PRODUTO))
		_cProd   := SG1->G1_COD
		nNivel   := 2
		_nQtAnt  := ZC6->C6_QTDVEN
		
		SB1->(dbSeek(xFilial("SB1")+_cProd))
		
		_cLocPad   := SB1->B1_LOCPAD
		_cQtCav    := SB1->B1_CAV
		_cQtPPS    := _cPPS   := _cPrensa := _cGrPre := _cMolde := ""
		
		If TMP->(!dbSeek(_cProd))
			NECES(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
			TMP->(RecLock("TMP",.T.))
			TMP->PRODUTO  := _cProd
			TMP->MOLDE    := _cMolde
			TMP->(MsUNlock())
		Else
			_cMolde    := TMP->MOLDE
		Endif
	Endif
	
	SA1->(dbSetOrder(1))
	SA1->(dbseek(xFilial("SA1")+ZC6->C6_CLI+ZC6->C6_LOJA))
	
	TRB->(RecLock("TRB",.T.))
	TRB->EMISSAO  := ZC6->C5_EMISSAO
	TRB->CLIENTE  := ZC6->C6_CLI
	TRB->LOJA     := ZC6->C6_LOJA
	TRB->NOMECLI  := SA1->A1_NOME
	TRB->PRODUTO  := ZC6->C6_PRODUTO
	TRB->NOMPROD  := ZC6->B1_DESC
	TRB->PRODCLI  := ZC6->C6_CPROCLI
	TRB->DTENTR   := ZC6->C6_ENTREG
	TRB->MOLDE    := _cMolde
	TRB->QTCAVID  := _cQtCav
	TRB->PEDIDO   := ZC6->C6_NUM
	TRB->ITEMPV   := ZC6->C6_ITEM
	_cDesTipo := ""
	If ZC6->C6_PEDAMOS == "N"
		_cDesTipo := "NORMAL"
	ElseIf ZC6->C6_PEDAMOS == "A"
		_cDesTipo := "AMOSTRA"
	ElseIf ZC6->C6_PEDAMOS == "D"
		_cDesTipo := "DESPES.ACESS."
	ElseIf ZC6->C6_PEDAMOS == "M"
		_cDesTipo := "AQUIS.MAT."
	ElseIf ZC6->C6_PEDAMOS == "Z"
		_cDesTipo := "PREVISAO"
	ElseIf ZC6->C6_PEDAMOS == "I"
		_cDesTipo := "INDUSTRIALIZ."
	Endif
	TRB->TIPOPV   := _cDesTipo
	TRB->QTDPED   := ZC6->C6_QTDVEN
	TRB->QTDENT   := ZC6->C6_QTDENT
	TRB->QTDSDO   := ZC6->C6_QTDVEN - ZC6->C6_QTDENT
	TRB->PRUNIT   := ZC6->C6_PRCVEN
	TRB->PPS   	  := _cPPS
	TRB->CAV_PPS  := _cQtPPS
	
	aAreaSB1:=SB1->(GetArea())
	
	If !Empty(TRB->PPS)
		_cProdu := TRB->PPS
		_cCav   := TRB->CAV_PPS
	Else
		_cProdu := ZC6->C6_PRODUTO
		_cCav   := TRB->QTCAVID
	Endif
	
	SB1->(dbSeek(xFilial("SB1")+_cProdu))
	_nCiclo := SB1->B1_CICLO
	
	_cPrensa := ""
	_cGrPre  := ""
	_nPSimul := 0
	SZM->(dbSetOrder(1))
	If SZM->(dbSeek(xFilial("SZM")+SB1->B1_GRPRENS))
		_cGrPre  := SB1->B1_GRPRENS
		_cPrensa := SZM->ZM_DESCRIC
		_nPSimul := SZM->ZM_QTPCSIM
	Endif
	
	RestArea(aAreaSB1)
	
	_nPorc := ((MV_PAR02 / 100)+1)
	
	TRB->GRPRENS  := _cGrPre
	TRB->PRENSA   := _cPrensa
	TRB->ITSIMU   := _nPSimul
	TRB->CICLO    := _nCiclo
	TRB->PRENSAD  := (ZC6->C6_QTDVEN - ZC6->C6_QTDENT) / val(_cCav)
	TRB->PORCENT  := TRB->PRENSAD * _nPorc
	
	_nPos1   := AT(".",STR(TRB->PORCENT))
	_nInt    := Val(Substr(STR(TRB->PORCENT),1,_nPos1))
	_nDec    := Val(Substr(STR(TRB->PORCENT),_nPos1+1,2))
	If _nDec > 0
		_nInt ++
	Else
		_nInt := TRB->PORCENT
	Endif
	
	TRB->ARREDON  := _nInt
	_nMin := TRB->ARREDON * TRB->CICLO
	TRB->MINUTOS  := _nMin
	TRB->HORAS    := TRB->MINUTOS / 60
	
	//	TRB->DIAS     := TRB->HORAS / 8.8
	If !Empty(TRB->PPS)
		_nVlor := ((ZC6->C6_QTDVEN - ZC6->C6_QTDENT) / val(TRB->CAV_PPS)) * _nPorc
	Else
		_nVlor := (ZC6->C6_QTDVEN - ZC6->C6_QTDENT) * _nPorc
	Endif
	
	_nPos2   := AT(".",Str(_nVlor))
	_nDeci1  := Val(Substr(Str(_nVlor),_nPos2+1,1))
	
	_nVlor := If(_nDeci1 > 0 .And. _nDeci1 < 6,Int(_nVlor+1),Int(_nVlor))
	
	TRB->QTDPROD  := _nVlor
	
	
	TRB->(MsUNlock())
	
	PA214A(_cGrPre,_nPSimul,ZC6->C6_PRODUTO,ZC6->C6_ENTREG,_nMin,ZC6->C6_NUM,ZC6->C6_ITEM)
	
	ZC6->(dbSkip())
EndDo

ZC6->(dbCloseArea())


TRB->(dbGotop())
ProcRegua(TRB->(U_CONTREG()))

While TRB->(!Eof()) .And. !_lFim
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	IncProc()
	
	If Empty(TRB->GRPRENS)
		TRB->(dbSkip())
		Loop
	Endif
	
	_lEnt := .F.
	If TRB->GRPRENS = '0001'
		_cGrPren := '0001A'
		_cPrensa := 'BOMBA 08/12/13/14'
		_nItSim  := 6
		
		_cGrPren1 := '0001B'
		_cPrensa1 := 'BOMBA 23/24/25'
		_nItSim1  := 3
		
		_lEnt    := .T.
	Else
		_cGrPren := TRB->GRPRENS
		_cPrensa := TRB->PRENSA
		_nItSim  := TRB->ITSIMU
	Endif
	
	TRB->(dbSkip())
	
EndDo

Return (Nil)



Static Function NECES(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev)

Local _nReg := 0
Local _nRegTrb := 0

SG1->(dbSetOrder(1))

While SG1->(!Eof()) .And. SG1->G1_COD == _cProd  .And. !_lFim
	
	_nReg := SG1->(Recno())
	
	nQuantItem := ExplEstr(_nQtPai,,_cOpc,_cRev)
	dbSelectArea("SG1")
	dbSetOrder(1)
	
	If nQuantItem > 0
		
		aAreaSB1:=SB1->(GetArea())
		SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))
		
		_nRegTRb := SB1->(Recno())
		
		If SB1->B1_GRUPO $ "FRVC/FRVI/FRVT"   // Molde de Vulcanização / Ferramenta
			_cMolde    += ALLTRIM(SG1->G1_COMP)+ " "
		ElseIf SB1->B1_GRUPO = 'PIVZ'
			_cPPS      := SB1->B1_COD
			_cQtPPS    := StrZero(INT(1 / SG1->G1_QUANT),3)
		Endif
		
		RestArea(aAreaSB1)
		
		SG1->(dbSetOrder(1))
		If SG1->(dbSeek(xFilial("SG1")+SG1->G1_COMP))
			SB1->(dbSeek(xFilial("SB1")+SG1->G1_COD))
			NECES(SG1->G1_COD,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
		EndIf
		
		SG1->(dbGoto(_nReg))
	Endif
	SG1->(dbSkip())
EndDo

Return



Static Function PA214A(_cGrPre,_nPSimul,_cCodPro,_dDtEnt,_nMin,_cPed,_cItPed)

If SZM->(dbSeek(xFilial("SZM")+_cGrPre))
	_nItSim  := SZM->ZM_QTPCSIM
	_cTemPro := Str(Int(_nMin / 60))+":"+Str(_nMin - (Int(_nMin / 60) * 60))+":00" // Tempo de produção em Horas

	_nDias := (Int(Val(_cTemPro) / 24) + 1)
	
	_dDtInic := _dDtEnt - _nDias
	If _dDtInic < dDataBase
	 	_dDtInic := dDataBase
	Endif
	
	_cHrInic := &("SZM->ZM_"+Alltrim(Str(Dow(_dDtInic)))+"HRINIC")
	_cHrFim  := &("SZM->ZM_"+Alltrim(Str(Dow(_dDtInic)))+"HRFIM")
	_cHrDesc := &("SZM->ZM_"+Alltrim(Str(Dow(_dDtInic)))+"HRDESC")

	_cHrDia := SubHoras(SubHoras(_cHrFim,_cHrInic),_cHrDesc)
	
	If TRB->(dbSeek(_cGrPre+dTos(_dDtEnt)+_cCodPro+_cPed+_cItPed))

		TMP->(dbSetOrder(1))
		If !TMP2->(dbSeek(_cGrPre))
			
			_dDtFim   := _dDtInic + _nDias
			_nHrFinal := Q_SOMAHORA(_cHrInic,_cTemPro)
			
			If Val(_nHrFinal) > 10 .And. Val(_nHrFinal) < 12
				_nHrFinal := Q_SOMAHORA(_nHrFinal,"00:15")
			ElseIf _nHrFinal > 12 .And. _nHrFinal < 15
				_nHrFinal := Q_SOMAHORA(_nHrFinal,"01:15")
			ElseIf _nHrFinal > 15 .And. _nHrFinal < 19
				_nHrFinal := Q_SOMAHORA(_nHrFinal,"01:30")
			ElseIf _nHrFinal > 19
				_nHrFinal := Q_SOMAHORA(_nHrFinal,"02:30")
			Endif
				
			TMP2->(RecLock("TMP2",.T.))
			TMP2->GRPRENS	:= _cGrPre
//			TMP2->PRODUTO	:= TRB->PRODUTO
			TMP2->LOCALPR	:= '1'
			TMP2->DTINICI	:= _dDtInic
			TMP2->DTFINAL	:= _dDtFim
			TMP2->HRINICI	:= _cHrInic
			TMP2->HRFINAL	:= _nHrFinal
			TMP2->(MsUnLock())					
			
		Else
			
			_cGrupo := TMP2->GRPRENS
			
			While TMP2->(!EOF()) .And. _cGrupo == TMP2->GRPRENS
				
				_cLocal := TMP2->LOCAPR
				_dDtIni := TMP2->DTINICI
				_dDtFim := TMP2->DTFINAL
				_nHrIni := TMP2->HRINICI
				_nHrFin := TMP2->HRFINAL
				
				If Val(_cLocal) < _nItSim
					_cLocal := Str(Val(_cLocal)+1)
					_lInic := .F.
				Else
					_cLocal := '1'
					_lInic := .T.
				Endif

				If TMP2->DTINICI = TMP2->DTFINAL .AND. TMP2->HRFINAL < _cHrFim
					
					TMP2->(RecLock("TMP2",.T.))
					TMP2->GRPRENS	:= _cGrPre
					TMP2->LOCALPR	:= _cLocal
					TMP2->DTINICI	:= _dDtFim
					TMP2->HRINICI	:= _nHrFin
					
					
					//colocar aqui o desconto das horas
					_cHRRest2 := SUBHORAS(_cHrFim,_nHrFin)
				
					If SOMAHORAS(_cTemPro,_nHrFin) < _cHRRest // Se Tempo de produção for <= Total de Horas do dia
						
						TMP2->DTFINAL	:= _dDtFim
						TMP2->HRFINAL	:= SOMAHORAS(_nHrFin,_cTemPro) 
						TMP2->(MsUnLock())
					Else
						       
						_cHr1    := SUBHORAS(SOMAHORAS(_cTemPro,_nHrFin),_nHrFinal)
						_nPos1   := AT(".",STR(_cHr1))
						_cHr2    := Int(_cHr2) * 60 // Minutos
						_nDec    := Val(Substr(STR(_cHr1),_nPos1+1,2))
						_nMinut  := _cHr2 + _nDec

						 // colocar os minutos

						TMP2->DTFINAL	:= _dDtIni + _nDtFi1
//						TMP2->HRFINAL	:= 
						TMP2->(MsUnLock())
						
					Endif
					
				Else
					
					
				Endif
				
				TMP2->(dbSkip())
			EndDo
			
		
		Endif
		
		TRB->(RecLock("TRB",.F.))
		TRB->DTINICI  := TMP2->DTINICI
		TRB->DTFINAL  := TMP2->DTFINAL
		TRB->HRINICI  := TMP2->HRINICI
		TRB->HRFINAL  := TMP2->HRFINAL
		TRB->LOCALPR  := TMP2->LOCALPR
		TRB->(MsUnLock())
		
	Endif
	
Endif

Return


Static Function AtuSX1()

cPerg := "PA0214"

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01           /Def01    	/defspa1/defeng1/Cnt01/Var02/Def02/Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Quais Pedidos  		?",""       ,""      ,"mv_ch1","C" ,06     ,0      ,0     ,"G","U_FTIPOPED()","MV_PAR01",""     	,""     ,""     ,""   ,""   ,"" 	,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Porcentagem Rejeito	?",""       ,""      ,"mv_ch2","N" ,05     ,2      ,0     ,"G",""       	 ,"MV_PAR02",""     	,""     ,""     ,""   ,""   ,"" 	,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"03","Refaz Programacao  	?",""       ,""      ,"mv_ch3","N" ,01     ,0      ,0     ,"C",""       	 ,"MV_PAR03","Sim"     	,""     ,""     ,""   ,""   ,"Nao" 	,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return
