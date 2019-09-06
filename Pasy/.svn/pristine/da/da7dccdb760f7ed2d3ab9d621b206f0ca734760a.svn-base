#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSGRAPHI.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0205   ³ Autor ³ Fabiano da Silva      ³ Data ³ 10.03.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carga máquina                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0205()

Local nSerie      := 0
Local nSerie2      := 0
Local nSerie3      := 0
Local nSerie4      := 0
Local oGraphic
LOCAL oDlg        := NIL

Private oBold       := Nil
Private oBold2      := Nil
//Private Serie1    := space(20)
//Private Serie2    := space(20)
//Private Serie3    := space(20)
Private aVet1     := {}
Private aVet2     := {}
Private aVet3     := {}
Private aVet4     := {}
Private aVeta     := {}
Private aVetb     := {}
Private aVetc     := {}
Private aVetd     := {}

Private oGraOk    := Nil
Private cTitulo   := "Geração de Graficos"
Private _cNome    := ""
Private _cRecu    := ""
Private _nConta   := 0
Private _nCont    := 0
Private _cCont    := ""
PRIVATE oPrn      := NIL
PRIVATE oFont     := NIL
PRIVATE oFont1    := NIL
PRIVATE oFont5    := NIL
Private nCbt      := 1
Private cGrafic   := .T.
//Private lVet3 	  := .F.
//Private lVet4 	  := .F.
Private _lVet     := .T.
Private _cGrPren

AtuSX1()

Private _cDescPa := ""
_cLocPad   := _cQtCav := ""
_cQtPPS    := _cPPS   := ""
_nSdoAcab  := 0
_nMedida   := 0
_cComposto := _cMolde := _cInserto := ""
_nOpc      := 0

DEFINE FONT oFont NAME "Arial" SIZE 0,10 OF oPrn BOLD
DEFINE FONT oFont1 NAME "Arial" SIZE 0,13 OF oPrn BOLD
DEFINE FONT oFont2 NAME "Arial" SIZE 0,10 OF oPrn BOLD

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

@ 002,010 TO 060,157 LABEL "" OF oDlg PIXEL

@ 10,18 SAY "Rotina criado para Gerar Carga Máquina    "     OF oDlg PIXEL Size 150,010 FONT oFont1 COLOR CLR_BLUE
@ 18,18 SAY "com dados necessarios para controle PCP.  "     OF oDlg PIXEL Size 150,010 FONT oFont1 COLOR CLR_BLUE
@ 26,18 SAY "Conforme Relacionamento com a Estrutura.  "     OF oDlg PIXEL Size 150,010 FONT oFont1 COLOR CLR_BLUE
@ 34,18 SAY "Programa PA0205 (TABELA) CARGAMAQ.DBF     "     OF oDlg PIXEL Size 150,010 FONT oFont2 COLOR CLR_RED

@ 70,020 BUTTON "Parametros" SIZE 036,012 ACTION ( Pergunte("PA0205"))	OF oDlg PIXEL
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

_cArqNovo := "\SPOOL\CARGAMAQ.DBF"
dbSelectArea("TRB")

Copy all to &_cArqNovo
dbCloseArea()

TMP->(dbCloseArea())

If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\SPOOL\CARGAMAQ.DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return



Static Function Proc1(_lFim)

Pergunte("PA0205",.F.)

///////////////////////////////////////////
////// GRUPO DE PERGUNTAS /////////////////
///// MV_PAR01 - Emissao De  ?         ////
///// MV_PAR02 - Emissao Ate ?         ////
///// MV_PAR03 - Grupo De              ////
///// MV_PAR04 - Grupo Ate           . ////
///// MV_PAR05 - Produto De ?          ////
///// MV_PAR06 - produto Ate ?         ////
///// MV_PAR07 - Cliente De ?          ////
///// MV_PAR08 - Cliente Ate ?         ////
///// MV_PAR09 - Loja    De ?          ////
///// MV_PAR10 - Loja    Ate ?         ////
///// MV_PAR11 - Data Entrega De  ?    ////
///// MV_PAR12 - Data Entrega Ate ?    ////
///// MV_PAR13 - Pedido de        ?    ////
///// MV_PAR14 - Pedido Ate       ?    ////
///// MV_PAR15 - Em Aberto , Todos     ////
///// MV_PAR16 - Quais Pedidos    ?    ////
///// MV_PAR17 - % REJEITO    ?        ////
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
AADD(aStru,{"CICLO"       , "N" , 07, 2 })
AADD(aStru,{"PRENSAD"     , "N" , 12, 2 })
AADD(aStru,{"PORCENT"     , "N" , 12, 2 })
AADD(aStru,{"ARREDON"     , "N" , 12, 2 })
AADD(aStru,{"MINUTOS"     , "N" , 12, 2 })
AADD(aStru,{"HORAS"       , "N" , 12, 2 })
//AADD(aStru,{"DIAS"        , "N" , 12, 2 })
AADD(aStru,{"PORC_10"     , "N" , 12, 2 })
AADD(aStru,{"QTDPROD"     , "N" , 12, 0 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "GRPRENS+DTOS(DTENTR)"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")


aStru := {}
AADD(aStru,{"PRODUTO"     , "C" , 15, 0 })
AADD(aStru,{"COMPOSTO"    , "C" , 45, 0 })
AADD(aStru,{"MOLDE"       , "C" , 45, 0 })
AADD(aStru,{"INSERTO"     , "C" , 45, 0 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "PRODUTO"

dbUseArea(.T.,,_cArqTrb,"TMP",.F.,.F.)

dbSelectArea("TMP")
IndRegua("TMP",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

_cPed := "("
For Ax:= 1 To Len(MV_PAR16)
	If Substr(MV_PAR16,AX,1) != "*"
		If _cPed == "("
			_cPed += "'"+Substr(MV_PAR16,AX,1)
		Else
			_cPed += "','"+Substr(MV_PAR16,AX,1)
		Endif
	Endif
Next AX

_cPed += "')"

_cQ := " SELECT * FROM SC6010 C6 INNER JOIN SC5010 C5 ON C6_NUM=C5_NUM "
_cQ += " INNER JOIN SB1010 B1 ON C6_PRODUTO=B1_COD INNER JOIN SF4010 F4 ON C6_TES=F4_CODIGO  "
_cQ += " WHERE B1.D_E_L_E_T_ = '' AND C5.D_E_L_E_T_ = '' AND C6.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' "
_cQ += " AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQ += " AND B1_GRUPO   BETWEEN '"+MV_PAR03+"'       AND '"+MV_PAR04+"' "
_cQ += " AND B1_COD     BETWEEN '"+MV_PAR05+"'       AND '"+MV_PAR06+"' AND F4_DUPLIC = 'S' "
_cQ += " AND C6_CLI     BETWEEN '"+MV_PAR07+"'       AND '"+MV_PAR08+"' AND C6_BLQ = '' "
_cQ += " AND C6_LOJA    BETWEEN '"+MV_PAR09+"'       AND '"+MV_PAR10+"' AND C5_TIPO = 'N' "
_cQ += " AND C6_ENTREG  BETWEEN '"+DTOS(MV_PAR11)+"' AND '"+DTOS(MV_PAR12)+"' "
_cQ += " AND C6_NUM     BETWEEN '"+MV_PAR13+"'       AND '"+MV_PAR14+"' "
If MV_PAR15 == 1
	_cQ += " AND C6_QTDVEN > C6_QTDENT "
Endif
_cQ += " AND C6_PEDAMOS IN "+_cPed+" "
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
	
	_nSdoAcab  := 0
	
	SG1->(dbSetOrder(1))
	If SG1->(dbSeek(xFilial("SG1")+ZC6->C6_PRODUTO))
		_cProd   := SG1->G1_COD
		nNivel   := 2
		_nQtAnt  := ZC6->C6_QTDVEN
		
		SB1->(dbSeek(xFilial("SB1")+_cProd))
		
		_cDescPa   := SB1->B1_DESC
		_cLocPad   := SB1->B1_LOCPAD
		_nMedida   := SB1->B1_AREAPEC
		_cQtCav    := SB1->B1_CAV
		_cComposto := _cMolde := _cInserto := ""
		
		_cQtPPS    := _cPPS   := _cPrensa := _cGrPre := ""
		If TMP->(!dbSeek(_cProd))
			NECES(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
			TMP->(RecLock("TMP",.T.))
			TMP->PRODUTO  := _cProd
			TMP->MOLDE    := _cMolde
			TMP->(MsUNlock())
		Else
			_cComposto := TMP->COMPOSTO
			_cMolde    := TMP->MOLDE
			_cInserto  := TMP->INSERTO
		Endif
	Endif
	
	_nSdoPa := 0
	SB2->(dbSetOrder(1))
	If SB2->(dbSeek(xFilial("SB2")+ZC6->C6_PRODUTO + _cLocPad))
		_nSdoPa := SB2->B2_QATU
	Endif
	
	SA1->(dbSetOrder(1))
	SA1->(dbseek(xFilial("SA1")+ZC6->C6_CLI+ZC6->C6_LOJA))
	
	_cUltNf   := ""
	_dDtUltNf := CTOD("")
	_nQtUltNf := 0
	
	SD2->(dbSetOrder(8))
	If SD2->(dbSeek(xFilial("SD2")+ZC6->C6_NUM + ZC6->C6_ITEM))
		_cUltNf   := SD2->D2_DOC
		_dDtUltNf := SD2->D2_EMISSAO
		_nQtUltNf := SD2->D2_QUANT
	Endif
	
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
	_cCiclo := SB1->B1_CICLO
	
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
	
	_nPorc := ((MV_PAR17 /100)+1)
	
	TRB->GRPRENS  := _cGrPre
	TRB->PRENSA   := _cPrensa
	TRB->ITSIMU   := _nPSimul
	TRB->CICLO    := _cCiclo
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
	TRB->MINUTOS  := TRB->ARREDON * TRB->CICLO
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
	
	TRB->PORC_10  := _nVlor
	TRB->QTDPROD  := _nVlor
	TRB->(MsUNlock())
	
	ZC6->(dbSkip())
EndDo

ZC6->(dbCloseArea())

_nCont  := 0
_cGrup1 := _cGrupo := ""
_lFirst := .T.
_lGo    := .F.  // Condição para mudar a prensa do grupo 0001
_lVet   := .T.

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
	
	If TRB->GRPRENS = '0008'
		_lPare := .T.
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


	If _cRecu != TRB->GRPRENS
		//	If _cRecu != _cGrPren
		SZM->(dbSetOrder(1))
		If SZM->(dbSeek(xFilial("SZM")+_cGrPren))
			
			If SZM->ZM_GRAFICO != "1"
				TRB->(dbSkip())
				Loop
			Endif
		Endif
		
		If !_lFirst
			_nConta ++
			_cCont := StrZero(_nConta,4)
			If !Empty(_cGrPren)
				GeraMsdi()
				If _lEnt
					_cNome := _cPrensa1
					aVet1  := ACLONE(aVeta)
					aVet2  := ACLONE(aVetb)
					aVet3  := ACLONE(aVetc)
					aVet4  := ACLONE(aVetd)
					GeraMsdi()
				Endif
			Else
				_lVet := .T.
			Endif
		Endif
	Endif
	
	If _lVet
		GeraVet()
		_lVet := .F.
	Endif
	                    
	
	_cNome := _cPrensa
	_dData := TRB->DTENTR
	_cRefe := LEFT(MESEXTENSO(_dData),3)+"/"+Right(StrZero(YEAR(_dData),4),2)
	
	For Z := 1 To Len(aVet1)
		
		If _cRefe = aVet1[Z][2]
			
			If _lGo .And. (aVet1[Z][4] >= aVet1[Z][5])
				
				aVeta[Z][4] += TRB->HORAS
				aVeta[Z][3] := Val(STR(((aVeta[Z][4]) / _nItSim1)))
				
			Else
				
				aVet1[Z][4] += TRB->HORAS
				_nVal := Val(STR(((aVet1[Z][4]) / _nItSim)))
				
				If _nVal > aVet1[Z][5] .And. TRB->GRPRENS = '0001'
					_nVal1 := aVet1[Z][5]
					_nVal2 := _nVal - aVet1[Z][5]
					_lGo   := .T.
					
					aVet1[Z][3] := _nVal1
					
					aVeta[Z][4] += (_nVal2 / 100) * aVet1[Z][4]
					aVeta[Z][3] := Val(STR(((aVeta[Z][4]) / _nItSim1)))
				Else
					_lGo   := .F.
					aVet1[Z][3] := _nVal
				Endif
			Endif
		Endif                                              
		
	Next Z
	
	_lFirst := .F.
	_cRecu  := TRB->GRPRENS
	
	TRB->(dbSkip())
EndDo

If !_lFirst
	_nConta ++
	_cCont := StrZero(_nConta,4)
	If !Empty(_cGrPren)
		GeraMsdi()
	Endif
Endif

Imprime()
Apaga()

Return


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



Static Function GeraMsdi()

DEFINE MSDIALOG oGraOk FROM 0,0 TO 510,760 TITLE cTitulo PIXEL

DEFINE FONT oBold  NAME "Arial" SIZE 0, -12 BOLD
DEFINE FONT oBold2 NAME "Arial" SIZE 0, -16 BOLD

@ 030, 005 MSGRAPHIC oGraphic 		SIZE 360, 200 	OF oGraOk
@ 230, 255 BUTTON "&3D"            	SIZE 30,14 		OF oGraOk PIXEL ACTION oGraphic:l3D := !oGraphic:l3D
@ 230, 285 BUTTON "[&Max] [Min]"   	SIZE 30,14 		OF oGraOk PIXEL ACTION oGraphic:lAxisVisib := !oGraphic:lAxisVisib
@ 230, 335 BUTTON "+"        		SIZE 18,14 		OF oGraOk PIXEL ACTION oGraphic:ZoomIn()
@ 230, 350 BUTTON "-"        		SIZE 18,14 		OF oGraOk PIXEL ACTION oGraphic:ZoomOut()

ACTIVATE MSDIALOG oGraOk CENTER ON INIT MyConBar(oGraOk,{||oGraOk:End()},oGraOk,oGraphic)

_lVet := .T.

Return


STATIC FUNCTION MyConBar(oObj,bObj,oFlx,oGraphic)

LOCAL oBar, lOk, lVolta, lLoop,oDBG10,oDBG02,oBtOk,oNada,oBtcl,oBtcn

DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP    OF oObj

oBar:bRClicked:={||AllwaysTrue()}

cGrafic   := .t.
GrafGera(oFlx,oGraphic)

oGraphic:SaveToBMP(_cCont+'.BMP','\GRAFICO\')

oGraOk:End()

RETURN NIL



Static Function GRAFGERA(oFlx,oGraphic)

Local nIndTask := 0
Local nIndTask2:= 0
Local nMax     := 1

If cGrafic
	
	oGraphic:lAxisVisib := .T. // Mostra os eixos
	oGraphic:SetMargins( 15, 10, 10, 10 )
	oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )
	oGraphic:SetTitle(DTOC(Date()),_cNome, CLR_BLACK,A_RIGHTJUS, GRP_TITLE )
	oGraphic:SetLegenProp( GRP_SCRTOP, CLR_YELLOW, GRP_SERIES, .F.)
	
	Store .F. To vet1,vet2,vet3,vet4
	
	For _n := 1 to len(aVet1)
		If aVet1[_n][1]
			vet1=.t.
		Endif
	Next _n
	
	For _n := 1 to len(aVet2)
		If aVet2[_n][1]
			vet2=.t.
		endif
	Next _n
	
	For _n := 1 to len(aVet3)
		If aVet3[_n][1]
			vet3=.t.
		endif
	Next _n
	
	For _n := 1 to len(aVet4)
		If aVet4[_n][1]
			vet4=.t.
		Endif
	Next _n
	
	
	If vet1
		
		nMax := len(aVet1)
		nSerie := oGraphic:CreateSerie(1)
		//nSerie := oGraphic:CreateSerie(nCbt)
		//xcor=CLR_HRED
		xcor=CLR_HRED
		CorL3='BR_VERMELHO'
		
		If nSerie <> GRP_CREATE_ERR
			If nCbt == GRP_PIE
				nMax := 1
			Endif
			For _n := 1 to nMax
				if aVet1[_n][1]
					oGraphic:Add(nSerie,Round(aVet1[_n][3],2),aVet1[_n][2],xcor)
				else
					oGraphic:Add(nSerie,0,aVet1[_n][2],xcor)
				endif
			Next _n
		Endif
	Endif
	
	If vet2
		
		nMax := len(aVet2)
		nSerie2 := oGraphic:CreateSerie(1)
		xcor=CLR_HBLUE
		CorL3='BR_AZUL'
		
		If nSerie2 <> GRP_CREATE_ERR
			If nCbt == GRP_PIE
				nMax := 1
			Endif
			For _n := 1 to nMax
				if aVet2[_n][1]
					oGraphic:Add(nSerie2,aVet2[_n][3],aVet2[_n][2],xcor)
				else
					oGraphic:Add(nSerie2,0,aVet2[_n][2],xcor)
				endif
			Next _n
		Endif
	Endif
	
	If vet3
		
		nMax := len(aVet3)
		nSerie3 := oGraphic:CreateSerie(1)
		xcor=CLR_GREEN
		CorL3='BR_VERDE'
		
		If nSerie3 <> GRP_CREATE_ERR
			If nCbt == GRP_PIE
				nMax := 1
			Endif
			For _n := 1 to nMax
				if aVet3[_n][1]
					oGraphic:Add(nSerie3,aVet3[_n][3],aVet3[_n][2],xcor)
				else
					oGraphic:Add(nSerie3,0,aVet3[_n][2],xcor)
				endif
			Next _n
		Endif
	Endif
	
	If vet4
		
		nMax := len(aVet4)
		nSerie4 := oGraphic:CreateSerie(1)
		xcor=CLR_YELLOW
		CorL3='BR_AMARELO'
		
		If nSerie4 <> GRP_CREATE_ERR
			If nCbt == GRP_PIE
				nMax := 1
			Endif
			For _n := 1 to nMax
				if aVet4[_n][1]
					oGraphic:Add(nSerie4,aVet4[_n][3],aVet4[_n][2],xcor)
				else
					oGraphic:Add(nSerie4,0,aVet4[_n][2],xcor)
				endif
			Next _n
		Endif
	Endif
	oGraphic:l3D := !oGraphic:l3D
	oGraphic:REFRESH()
	cGrafic:=.f.	

Endif

Return


Static function Geravet() //Criação dos 12 meses que aparecerão no gráfico

aVet1  := {}
aVet2  := {}
aVet3  := {}
aVet4  := {}

aVeta  := {}
aVetb  := {}
aVetc  := {}
aVetd  := {}

_cDtRef := dtoc(firstday(MV_PAR11))
_nMes   := Month(cTod(_cDtRef))
_nAno   := Year(cTod(_cDtRef))

For F:= 1 to 12
	
	If F =  1
		_cRef := Left(MESEXTENSO(MV_PAR11),3) + "/" + Right(STRZERO(Year(MV_PAR11),4),2)
	Else
		
		If _nMes > 11
			_nAno   := _nAno + 1
			_nMes   := 01
		Else
			_nMes   := _nMes+1
			_nAno   := _nAno
		Endif
		
		_cDtRef := "01/"+StrZero(_nMes,2)+"/"+Right(StrZero(_nAno,4),2)
		_cRef   := Left(MESEXTENSO(cTod(_cDtRef)),3) + "/" + Right(STRZERO(Year(cTod(_cDtRef)),4),2)
		
	Endif
	
	//	lVet3 := lVet4 := .F.
	
	If TRB->GRPRENS = "0001"
		
		_cGrPren := "0001A"
		_cGrPr1  := "0001B"
		
		SZN->(dbSetOrder(1))
		If SZN->(dbSeek(xFilial("SZN")+StrZero(_nAno,4)+StrZero(_nMes,2)+_cGrPr1))
			Aadd(aVeta,{.t.,_cRef,0			,0,SZN->ZN_HORAS})
			Aadd(aVetb,{.t.,_cRef,SZN->ZN_TURNO1	,0,SZN->ZN_HORAS})
			If SZN->ZN_TURNO2 > 0
				Aadd(aVetc,{.t.,_cRef,SZN->ZN_TURNO2	,0,SZN->ZN_HORAS})
			Endif
			If 	SZN->ZN_TURNO3 > 0
				Aadd(aVetd,{.t.,_cRef,SZN->ZN_TURNO3	,0,SZN->ZN_HORAS})
			Endif
		Endif
		
	Endif
	
	SZN->(dbSetOrder(1))
	If SZN->(dbSeek(xFilial("SZN")+StrZero(_nAno,4)+StrZero(_nMes,2)+_cGrPren))
		Aadd(aVet1,{.t.,_cRef,0			,0,SZN->ZN_HORAS})
		Aadd(aVet2,{.t.,_cRef,SZN->ZN_TURNO1	,0,SZN->ZN_HORAS})
		If SZN->ZN_TURNO2 > 0
			Aadd(aVet3,{.t.,_cRef,SZN->ZN_TURNO2	,0,SZN->ZN_HORAS})
			//			lVet3 := .T.
		Endif
		If 	SZN->ZN_TURNO3 > 0
			Aadd(aVet4,{.t.,_cRef,SZN->ZN_TURNO3	,0,SZN->ZN_HORAS})
			//			lVet4 := .T.
		Endif
	Endif
	
Next F

Return


Static Function Imprime()

_lEntr   := .F.
_nImp    := 1

_cDir   := "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\GRAFICO\*.BMP"

_aArqTxt := ARRAY(ADIR(_cDir))
ADIR("\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\GRAFICO\*.BMP",_aArqTxt)

_aArqTxt := aSort(_aArqTxt)

ProcRegua(Len(_aArqTxt))

For I:= 1 to Len(_aArqTxt)
	
	IncProc()
	
	_cArq3     := "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\GRAFICO\"+Alltrim(_aArqTxt[i])
	
	If I = 1
		oprn	:=TMSPrinter():New("Impressão de gráficos")
		oPrn:SetPortrait()
		_lEntr   := .T.
	Endif
	
	If _nImp = 1
		oPrn:StartPage()
		Cabec(_nCont)
		oPrn:SayBitmap(0095,0300,"\GRAFICO\"+Alltrim(_aArqTxt[I]),1900,1300)
		oPrn:Say(1410,0765, "_____"		,oFont5,,CLR_HRED)
		oPrn:Say(1425,0860, "HORAS"		,oFont5,,CLR_HRED)

		oPrn:Say(1410,1065, "_____"		,oFont5,,CLR_HBLUE)
		oPrn:Say(1425,1160, "TURNO 01"	,oFont5,,CLR_HBLUE)

		oPrn:Say(1410,1365, "_____"		,oFont5,,CLR_GREEN)
		oPrn:Say(1425,1460, "TURNO 02"	,oFont5,,CLR_GREEN)

		oPrn:Say(1410,1665, "_____"		,oFont5,,CLR_YELLOW)
		oPrn:Say(1425,1760, "TURNO 03"	,oFont5,,CLR_YELLOW)
	Endif
	
	If _nImp = 2
		oPrn:SayBitmap(1500,0300,"\GRAFICO\"+Alltrim(_aArqTxt[I]),1900,1300)

		oPrn:Say(2860,0765, "_____"		,oFont5,,CLR_HRED)
		oPrn:Say(2875,0860, "HORAS"		,oFont5,,CLR_HRED)

		oPrn:Say(2860,1065, "_____"		,oFont5,,CLR_HBLUE)
		oPrn:Say(2875,1160, "TURNO 01"	,oFont5,,CLR_HBLUE)

		oPrn:Say(2860,1365, "_____"		,oFont5,,CLR_GREEN)
		oPrn:Say(2875,1460, "TURNO 02"	,oFont5,,CLR_GREEN)

		oPrn:Say(2860,1665, "_____"		,oFont5,,CLR_YELLOW)
		oPrn:Say(2875,1760, "TURNO 03"	,oFont5,,CLR_YELLOW)

		oPrn:EndPage()
		_nImp := 1
	Else
		_nImp ++
	Endif
	
Next I

If _lEntr
	Ms_Flush()
	oPrn:EndPage()
	oPrn:End()
	oPrn:Preview()
Endif

Return


Static function Apaga()

_cDir   := "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\GRAFICO\*.BMP"

_aArqTxt := ARRAY(ADIR(_cDir))
ADIR("\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\GRAFICO\*.BMP",_aArqTxt)

_aArqTxt := aSort(_aArqTxt)

ProcRegua(Len(_aArqTxt))

For I:= 1 to Len(_aArqTxt)
	
	IncProc()
	
	_cArq3     := "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\GRAFICO\"+Alltrim(_aArqTxt[i])
	
	FErase(_cArq3)
	
Next I

Return


STATIC FUNCTION Cabec() //Cabeçalho

oPen	:= TPen():New(10,100,CLR_HRED,oPrn)

Define brush oBr color CLR_HRED

/*
oPrn:Box(1500,0080,3000,2250, oPen)

oPrn:Line(1580,0080,1580,2250) // Horizontal
oPrn:Line(1660,0080,1660,2250)
oPrn:Line(1740,0080,1740,2250)
oPrn:Line(1820,0080,1820,2250)
oPrn:Line(1900,0080,1900,2250)
oPrn:Line(1980,0080,1980,2250)
oPrn:Line(2060,0080,2060,2250)
oPrn:Line(2140,0080,2140,2250)
oPrn:Line(2220,0080,2220,2250)
oPrn:Line(2300,0080,2300,2250)
oPrn:Line(2380,0080,2380,2250)
oPrn:Line(2460,0080,2460,2250)
oPrn:Line(2540,0080,2540,2250)
oPrn:Line(2620,0080,2620,2250)
oPrn:Line(2700,0080,2700,2250)
oPrn:Line(2780,0080,2780,2250)
oPrn:Line(2860,0080,2860,2250)
oPrn:Line(2940,0080,2940,2250)

oPrn:Line(1500,0500,2950,0500) //Vertical
oPrn:Line(1500,1500,2950,1500) //Vertical
oPrn:Line(1500,2000,2950,2000) //Vertical
*/
_nCont ++

//Rodapé
oPrn:Line(2950,0080,2950,2250)
oPrn:Say(2955,0090,"PA0205.PRW",oFont)
oPrn:Say(2955,2050,"Página "+STRZERO(_nCont,3),oFont)

Return()


Static Function AtuSX1()

cPerg := "PA0205"

//    	   Grupo/Ordem/Pergunta               /perg_spa /perg_eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01           /Def01    	/defspa1/defeng1/Cnt01/Var02/Def02/Defspa2/defeng2/Cnt02/Var03/Def03/defspa3/defeng3/Cnt03/Var04/Def04/defspa4/defeng4/Cnt04/Var05/Def05/deefspa5/defeng5/Cnt05/F3
U_CRIASX1(cPerg,"01","Emissao De            ?",""       ,""      ,"mv_ch1","D" ,08     ,0      ,0     ,"G",""       	 ,"MV_PAR01",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"02","Emissao Ate           ?",""       ,""      ,"mv_ch2","D" ,08     ,0      ,0     ,"G",""       	 ,"MV_PAR02",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"03","Grupo De              ?",""       ,""      ,"mv_ch3","C" ,04     ,0      ,0     ,"G",""       	 ,"MV_PAR03",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SBM")
U_CRIASX1(cPerg,"04","Grupo Ate             ?",""       ,""      ,"mv_ch4","C" ,04     ,0      ,0     ,"G",""       	 ,"MV_PAR04",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SBM")
U_CRIASX1(cPerg,"05","Produto De            ?",""       ,""      ,"mv_ch5","C" ,15     ,0      ,0     ,"G",""       	 ,"MV_PAR05",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
U_CRIASX1(cPerg,"06","Produto Ate           ?",""       ,""      ,"mv_ch6","C" ,15     ,0      ,0     ,"G",""       	 ,"MV_PAR06",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"SB1")
U_CRIASX1(cPerg,"07","Cliente De            ?",""       ,""      ,"mv_ch7","C" ,06     ,0      ,0     ,"G",""       	 ,"MV_PAR07",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CLI")
U_CRIASX1(cPerg,"08","Cliente Ate           ?",""       ,""      ,"mv_ch8","C" ,06     ,0      ,0     ,"G",""       	 ,"MV_PAR08",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"CLI")
U_CRIASX1(cPerg,"09","Loja De               ?",""       ,""      ,"mv_ch9","C" ,02     ,0      ,0     ,"G",""       	 ,"MV_PAR09",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"10","Loja Ate              ?",""       ,""      ,"mv_ch0","C" ,02     ,0      ,0     ,"G",""        	 ,"MV_PAR10",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"11","Data Entrega De       ?",""       ,""      ,"mv_cha","D" ,08     ,0      ,0     ,"G",""        	 ,"MV_PAR11",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"12","Data Entrega Ate      ?",""       ,""      ,"mv_chb","D" ,08     ,0      ,0     ,"G",""        	 ,"MV_PAR12",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"13","Pedido De             ?",""       ,""      ,"mv_chc","C" ,06     ,0      ,0     ,"G",""        	 ,"MV_PAR13",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"14","Pedido Ate            ?",""       ,""      ,"mv_chd","C" ,06     ,0      ,0     ,"G",""        	 ,"MV_PAR14",""        	,""     ,""     ,""   ,""   ,""     ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"15","Situacao Pedido  		?",""       ,""      ,"mv_che","N" ,01     ,0      ,0     ,"C",""        	 ,"MV_PAR15","Em Aberto",""     ,""     ,""   ,""   ,"Todos",""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"16","Quais Pedidos  		?",""       ,""      ,"mv_chf","C" ,06     ,0      ,0     ,"G","U_FTIPOPED()","MV_PAR16",""     	,""     ,""     ,""   ,""   ,"" 	,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")
U_CRIASX1(cPerg,"17","Porcentagem Rejeito	?",""       ,""      ,"mv_chg","N" ,05     ,2      ,0     ,"G",""       	 ,"MV_PAR17",""     	,""     ,""     ,""   ,""   ,"" 	,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""      ,""     ,""   ,"")

Return
