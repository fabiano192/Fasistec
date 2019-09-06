#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ PA0189   ³ Autor ³ Fabiano da Silva      ³ Data ³ 17.08.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Pedidos com Estrutura                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0189()

_aAliOri    := GetArea()
Private _cDescPa := ""
Private _lFirst  := _lFirst1  := .T.
Private _lSecond := _lSecond1 := .F.
Private _lThird  := _lThird1  := .F.

_cLocPad    := _cQtCav     := ""
_nSdoAcab   := 0
_nMedida    := 0
_cPFormad1  := _cPFormad2  := _cPFormad3  := ""
_cMateria1  := _cMateria2  := _cMateria3  := _cMolde := _cInserto := ""
_nQtdeCom1  := _nQtdeCom2  := _nQtdeCom3  := 0
_nQtdePF1   := _nQtdePF2   := _nQtdePF3   := 0

_nOpc       := 0

@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Gerando Tabela de Vendas")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina criado para Gerar tabela de Vendas "     SIZE 160,7
@ 18,18 SAY "com dados necessarios para controle PCP.  "     SIZE 160,7
@ 26,18 SAY "Conforme Relacionamento com a Estrutura.  "     SIZE 160,7
@ 34,18 SAY "Programa PA0189 (TABELA) PA0189.DBF       "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0105")
@ 85,158 BMPBUTTON TYPE 1 ACTION (_nOpc:=1,oDlg:END())
@ 85,188 BMPBUTTON TYPE 2 ACTION oDlg:END()

ACTIVATE DIALOG oDlg Centered

If _nOpc == 1
	Proces()
Endif

Return


Static Function Proces()

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| Proc1(@_lFim) }
Private _cTitulo01 := 'Processando'

Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

_cArqNovo := "\SPOOL\PA0189.DBF"
dbSelectArea("TRB")

Copy all to &_cArqNovo
dbCloseArea()

TMP->(dbCloseArea())

If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\SPOOL\PA0189.DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return



Static Function Proc1(_lFim)

Pergunte("PA0105",.F.)

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
AADD(aStru,{"MATERIAL1"   , "C" , 15, 0 })
AADD(aStru,{"QTDCOMP1"    , "N" , 12, 6 })
AADD(aStru,{"MATERIAL2"   , "C" , 15, 0 })
AADD(aStru,{"QTDCOMP2"    , "N" , 12, 6 })
AADD(aStru,{"MATERIAL3"   , "C" , 15, 0 })
AADD(aStru,{"QTDCOMP3"    , "N" , 12, 6 })
AADD(aStru,{"PRFORMAD1"   , "C" , 15, 0 })
AADD(aStru,{"QTDPF1"      , "N" , 12, 6 })
AADD(aStru,{"PRFORMAD2"   , "C" , 15, 0 })
AADD(aStru,{"QTDPF2"      , "N" , 12, 6 })
AADD(aStru,{"PRFORMAD3"   , "C" , 15, 0 })
AADD(aStru,{"QTDPF3"      , "N" , 12, 6 })
AADD(aStru,{"MOLDE"       , "C" , 45, 0 })
AADD(aStru,{"INSERTO"     , "C" , 45, 0 })
AADD(aStru,{"QTCAVID"     , "C" , 03, 0 })
AADD(aStru,{"PEDIDO"      , "C" , 06, 0 })
AADD(aStru,{"ITEMPV"      , "C" , 02, 0 })
AADD(aStru,{"TIPOPV"      , "C" , 20, 0 })
AADD(aStru,{"QTDPED"      , "N" , 12, 2 })
AADD(aStru,{"QTDENT"      , "N" , 12, 2 })
AADD(aStru,{"QTDSDO"      , "N" , 12, 2 })
AADD(aStru,{"PRUNIT"      , "N" , 12, 2 })
AADD(aStru,{"ESTACAB"     , "N" , 14, 2 })
AADD(aStru,{"ACABAM"      , "N" , 14, 2 })
AADD(aStru,{"NUMNF"       , "C" , 06, 0 })
AADD(aStru,{"DTULTNF"     , "D" , 08, 0 })
AADD(aStru,{"QTULTNF"     , "N" , 14, 2 })
AADD(aStru,{"PRENSA"      , "C" , 06, 0 })
AADD(aStru,{"MATRIZ"      , "N" , 14, 2 })
AADD(aStru,{"MEDIDA"      , "N" , 14, 2 })
AADD(aStru,{"TRAFILA"     , "C" , 06, 0 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "PRODUTO+PEDIDO"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

aStru := {}
AADD(aStru,{"PRODUTO"     , "C" , 15, 0 })
AADD(aStru,{"MATERIAL1"   , "C" , 15, 0 })
AADD(aStru,{"QTDCOMP1"    , "N" , 12, 6 })
AADD(aStru,{"MATERIAL2"   , "C" , 15, 0 })
AADD(aStru,{"QTDCOMP2"    , "N" , 12, 6 })
AADD(aStru,{"MATERIAL3"   , "C" , 15, 0 })
AADD(aStru,{"QTDCOMP3"    , "N" , 12, 6 })
AADD(aStru,{"PRFORMAD1"   , "C" , 15, 0 })
AADD(aStru,{"QTDPF1"      , "N" , 12, 6 })
AADD(aStru,{"PRFORMAD2"   , "C" , 15, 0 })
AADD(aStru,{"QTDPF2"      , "N" , 12, 6 })
AADD(aStru,{"PRFORMAD3"   , "C" , 15, 0 })
AADD(aStru,{"QTDPF3"      , "N" , 12, 6 })
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
//		If AX == 1		
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
//_cQ += " AND C6_PEDAMOS IN "+FORMATIN(alltrim(_cPed),",")+" "
_cQ += " AND C6_PEDAMOS IN "+_cPed+" "
_cQ += " ORDER BY C6_PRODUTO "

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

		_cDescPa    := SB1->B1_DESC
		_cLocPad    := SB1->B1_LOCPAD
		_nMedida    := SB1->B1_AREAPEC
		_cQtCav     := SB1->B1_CAV
		_cPFormad1 := _cPFormad2 := _cPFormad3 := ""
		_cMateria1  := _cMateria2  := _cMateria3  := _cMolde := _cInserto := ""
		_nQtdeCom1  := _nQtdeCom2  := _nQtdeCom3  := 0
		_nQtdePF1   := _nQtdePF2   := _nQtdePF3   := 0

		If TMP->(!dbSeek(_cProd))
			
			NECES(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU,.T.,.T.,.F.,.F.,.F.,.F.)
			TMP->(RecLock("TMP",.T.))
			TMP->PRODUTO   := _cProd
			TMP->MATERIAL1 := _cMateria1
			TMP->MATERIAL2 := _cMateria2
			TMP->MATERIAL3 := _cMateria3
			TMP->QTDCOMP1  := _nQtdeCom1
			TMP->QTDCOMP2  := _nQtdeCom2
			TMP->QTDCOMP3  := _nQtdeCom3
			TMP->PRFORMAD1 := _cPFormad1
			TMP->QTDPF1    := _nQtdePF1
			TMP->PRFORMAD2 := _cPFormad2
			TMP->QTDPF2    := _nQtdePF2
			TMP->PRFORMAD3 := _cPFormad3
			TMP->QTDPF3    := _nQtdePF3
			TMP->MOLDE     := _cMolde
			TMP->INSERTO   := _cInserto
			TMP->(MsUNlock())
		Else
			_cMateria1 := TMP->MATERIAL1
			_cMateria2 := TMP->MATERIAL2
			_cMateria3 := TMP->MATERIAL3
			_nQtdeCom1  := TMP->QTDCOMP1
			_nQtdeCom2  := TMP->QTDCOMP2
			_nQtdeCom3  := TMP->QTDCOMP3
			_cPFormad1 := TMP->PRFORMAD1
			_nQtdePF1   := TMP->QTDPF1
			_cPFormad2 := TMP->PRFORMAD2
			_nQtdePF2   := TMP->QTDPF2
			_cPFormad3 := TMP->PRFORMAD3
			_nQtdePF3   := TMP->QTDPF3
			_cMolde     := TMP->MOLDE
			_cInserto   := TMP->INSERTO
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
	TRB->EMISSAO   := ZC6->C5_EMISSAO
	TRB->CLIENTE   := ZC6->C6_CLI    
	TRB->LOJA      := ZC6->C6_LOJA   
	TRB->NOMECLI   := SA1->A1_NOME
	TRB->PRODUTO   := ZC6->C6_PRODUTO
	TRB->NOMPROD   := ZC6->B1_DESC
	TRB->PRODCLI   := ZC6->C6_CPROCLI
	TRB->DTENTR    := ZC6->C6_ENTREG
	TRB->MATERIAL1 := _cMateria1
	TRB->QTDCOMP1  := _nQtdeCom1
	TRB->MATERIAL2 := _cMateria2
	TRB->QTDCOMP2  := _nQtdeCom2
	TRB->MATERIAL3 := _cMateria3
	TRB->QTDCOMP3  := _nQtdeCom3
	TRB->PRFORMAD1 := _cPFormad1
	TRB->QTDPF1    := _nQtdePF1
	TRB->PRFORMAD2 := _cPFormad2
	TRB->QTDPF2    := _nQtdePF2
	TRB->PRFORMAD3 := _cPFormad3
	TRB->QTDPF3    := _nQtdePF3
	TRB->MOLDE     := _cMolde
	TRB->INSERTO   := _cInserto
	TRB->QTCAVID   := _cQtCav
	TRB->PEDIDO    := ZC6->C6_NUM
	TRB->ITEMPV    := ZC6->C6_ITEM
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
	TRB->ESTACAB  := _nSdoPa
	TRB->ACABAM   := _nSdoAcab
	TRB->NUMNF    := _cUltNf
	TRB->DTULTNF  := _dDtUltNf
	TRB->QTULTNF  := _nQtUltNf
	TRB->MEDIDA   := _nMedida
	TRB->(MsUNlock())			
	
	ZC6->(dbSkip())	
EndDo

Return


Static Function NECES(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev,_lFirst,_lFirst1,_lSecond,_lSecond1,_lThird,_lThird1)

Local _nReg    := 0
Local _nRegTrb := 0
//Local _lFirst  := _lFirst1  := .T.
//Local _lSecond := _lSecond1 := .F.
//Local _lThird  := _lThird1  := .F.

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

		_lEnt := _lEnt1 := .F.
		
		If SB1->B1_GRUPO $ "PIC /MPVZ/MPC "   		// Material Utilizado
			If _lFirst .And. !_lEnt
				_cMateria1 := SG1->G1_COMP
				_nQtdeCom1 := SG1->G1_QUANT
				_lSecond   := .T.
				_lFirst    := .F.
				_lEnt	   := .T.
			Endif
			If _lSecond .And. !_lEnt
				_cMateria2 := SG1->G1_COMP
				_nQtdeCom2 := SG1->G1_QUANT
				_lSecond   := .F.
				_lThird    := .T.
				_lEnt	   := .T.
			Endif
			If _lThird  .And. !_lEnt
				_cMateria3 := SG1->G1_COMP
				_nQtdeCom3 := SG1->G1_QUANT
				_lThird    := .F.
				_lEnt	   := .T.				
			Endif
		ElseIf SB1->B1_GRUPO $ "FRVC/FRVI/FRVT"   	// Molde de Vulcanização / Ferramenta
			_cMolde    += ALLTRIM(SG1->G1_COMP)+ " "
		ElseIf SB1->B1_GRUPO $ "MPIM/PIPM"   		// PRE FORMADO / INSERTO  METALICO
			_cInserto  += ALLTRIM(SG1->G1_COMP)+ " "
		ElseIf SB1->B1_GRUPO $ "PIPF"   		// PRE FORMADO
			If _lFirst1 .And. !_lEnt1
				_cPFormad1 := SG1->G1_COMP
				_nQtdePF1   := SG1->G1_QUANT
				_lSecond1   := .T.
				_lFirst1    := .F.
				_lEnt1      := .T.
			Endif
			If _lSecond1  .And. !_lEnt1
				_cPFormad2 := SG1->G1_COMP
				_nQtdePF2   := SG1->G1_QUANT
				_lSecond1   := .F.
				_lThird1    := .T.
				_lEnt1      := .T.
			Endif
			If _lThird1 .And. !_lEnt1
				_cPFormad3 := SG1->G1_COMP
				_nQtdePF3   := SG1->G1_QUANT
				_lThird1    := .F.
				_lEnt1      := .T.
			Endif
		Endif

	 	If SB1->B1_LOCPAD == "20"
			SB2->(dbSetOrder(1))
			If SB2->(dbSeek(xFilial("SB2")+SG1->G1_COMP + SB1->B1_LOCPAD))
				_nSdoAcab += SB2->B2_QATU
			Endif
		Endif
	 		
		RestArea(aAreaSB1)
		
		SG1->(dbSetOrder(1))
		If SG1->(dbSeek(xFilial("SG1")+SG1->G1_COMP))
			SB1->(dbSeek(xFilial("SB1")+SG1->G1_COD))
			NECES(SG1->G1_COD,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU,_lFirst,_lFirst1,_lSecond,_lSecond1,_lThird,_lThird1)
		EndIf
		
		SG1->(dbGoto(_nReg))
	Endif
	SG1->(dbSkip())
EndDo

Return