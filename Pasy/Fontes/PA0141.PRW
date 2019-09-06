#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PA0141            ³ Autor ³ Fabiano da Silva    ³ Data ³ 24.09.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gerando Tabela Provisoria p/ vENDAS com mp                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaEst                                                                                                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PA0141()

_aAliOri := GetArea()
Private _cDescPa := ""
_lPAV    := .F.
_lPAC    := .f.
_lPAM    := .f.

_nOpc := 0
@ 150,1 TO 380,450 DIALOG oDlg TITLE OemToAnsi("Gerando Tabela de Vendas")
@ 02,10 TO 080,220
@ 10,18 SAY "Rotina criado para Gerar tabela de Vendas "     SIZE 160,7
@ 18,18 SAY "dos produtos conforme solicitacao.        "     SIZE 160,7
@ 26,18 SAY "Conforme Relacionamento com a Estrutura.  "     SIZE 160,7
@ 34,18 SAY "Programa PA0141.PRW (Tabela PA0141.DBF)  "     SIZE 160,7

@ 85,128 BMPBUTTON TYPE 5 ACTION Pergunte("PA0141")
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

_cArqNovo := "\SPOOL\PA0141.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo

dbCloseArea()

If ! ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "\\SERVER2\ERP\PROTHEUS11\PROTHEUS_DATA\SPOOL\PA0141.DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

//MsgInfo("Arquivo Processado Com Sucesso!!!!","INFO")


Return



Static Function Proc1(_lFim)

LOCAL nX
LOCAL nCotacao,_nValUni,_nValTot
LOCAL cPicQuant	:=PesqPictQt("G1_QUANT",13)
LOCAL cPicUnit 	:=PesqPict("SB1","B1_CUSTD",18)
LOCAL cPicTot 		:=PesqPict("SB1","B1_CUSTD",19)
LOCAL cMoeda1,cMoeda2
LOCAL cRodaTxt 	:= ""
LOCAL nCntImpr  	:= 0,nReg
LOCAL cCondFiltr,lRet
LOCAL cProdFim 	:=""
//LOCAL cString  		:= "SB1"

Pergunte("PA0141",.F.)

///////////////////////////////////////////
////// GRUPO DE PERGUNTAS /////////////////
///// MV_PAR01 - Produto De  ?         ////
///// MV_PAR02 - Produto Ate  ?         ////
///// MV_PAR03 - Emissao De  ?         ////
///// MV_PAR04 - Emissao De  ?         ////
///// MV_PAR05 - Emissao De  ?         ////
///// MV_PAR06 - Emissao De  ?         ////
///// MV_PAR07 - Emissao Ate ?         ////
///// MV_PAR08 - Grupo De              ////
///// MV_PAR09 - Grupo Ate           . ////
///// MV_PAR10 - Produto De ?          ////
///// MV_PAR11 - produto Ate ?         ////
///// MV_PAR12 - Cliente De ?          ////
///// MV_PAR13 - Cliente Ate ?         ////
///////////////////////////////////////////

Private _nNiv := 0
Private _lGravou := .F.

aStru := {}
AADD(aStru,{"EMISSAO"     , "D" , 08, 0 })
AADD(aStru,{"CLIENTE"     , "C" , 06, 0 })
AADD(aStru,{"NOMECLI"     , "C" , 40, 0 })
AADD(aStru,{"LOJA"        , "C" , 02, 0 })
AADD(aStru,{"PRODUTO"     , "C" , 15, 0 })
AADD(aStru,{"PRODCLI"     , "C" , 15, 0 })
AADD(aStru,{"COMP"        , "C" , 15, 0 })
AADD(aStru,{"DESCPA"      , "C" , 40, 0 })
AADD(aStru,{"DESCMP"      , "C" , 40, 0 })
AADD(aStru,{"QTESTR"      , "N" , 14, 4 })
AADD(aStru,{"QTDVENPA"    , "N" , 12, 2 })
AADD(aStru,{"VLVENDPA"    , "N" , 12, 2 })
AADD(aStru,{"QTDVENMP"    , "N" , 12, 2 })
AADD(aStru,{"PRCPROD"     , "N" , 14, 2 })
AADD(aStru,{"VLVENDMP"    , "N" , 12, 2 })
_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "DTOS(EMISSAO)+CLIENTE+LOJA+PRODUTO+COMP"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")   

dbSelectArea("SD2")
dbSetOrder(5)
dbSeek(xFilial("SD2")+Dtos(MV_PAR10),.T.)

ProcRegua(LastRec())
                                                     
_cPar11 := MV_PAR11
_cPar01 := MV_PAR01
_cPar02 := MV_PAR02
_cPar12 := MV_PAR12
_cPar13 := MV_PAR13

While !Eof() .And. SD2->D2_EMISSAO <= _cPAR11
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif

	IncProc()

	If 	SD2->D2_COD     < _cPAR01 .Or. SD2->D2_COD      > _cPAR02 .Or.;
		SD2->D2_CLIENTE < _cPAR12 .Or. SD2->D2_CLIENTE  > _cPAR13 .Or.;
		SD2->D2_TIPO != "N"
		dbSelectArea("SD2")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SF4")
	dbSetOrder(1)
	If dbSeek(xFilial("SF4")+SD2->D2_TES)
		If SF4->F4_DUPLIC != "S"
			dbSelectArea("SD2")
			dbSkip()
			Loop
		Endif
	Endif
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbseek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
	
	_lGravou := .F.
	_lGrupo  := .F.
	_lPAV    := .F.
	_lPAC    := .f.
	_lPAM    := .f.
	dbSelectArea("SG1")
	dbSetOrder(1)
	If dbSeek(xFilial("SG1")+SD2->D2_COD)
		
		_cProd   := SG1->G1_COD
		nNivel   := 2
		
		_nQtAnt :=  SD2->D2_QUANT
		_nSdoIni2 := 0
		
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+_cProd)
		_cDescPa := SB1->B1_DESC

		If ALLTRIM(SB1->B1_GRUPO) == "PAM"
     		_lPAM := .T.
		ElseIf ALLTRIM(SB1->B1_GRUPO) == "PAV"
			_lPAV := .T.
		ElseIf ALLTRIM(SB1->B1_GRUPO) == "PAC"
			_lPAC := .T.
		Endif
		
		NECES(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
	Endif
	
	dbSelectArea("SD2")
	dbSkip()
	
EndDo


Static Function NECES(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev)

Local _nReg := 0
Local _nRegTrb := 0

dbSelectArea("SG1")
dbSetOrder(1)

While !Eof() .And. SG1->G1_FILIAL + SG1->G1_COD == xFilial("SG1") + _cProd
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	_nReg := Recno()
	
	nQuantItem := ExplEstr(_nQtPai,,_cOpc,_cRev)
	dbSelectArea("SG1")
	dbSetOrder(1)
	
	If nQuantItem > 0
		
		_nNiv++
			                                                			
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+SG1->G1_COMP)
		_cDescMP := SB1->B1_DESC       
				
		If _lPAM .And. ALLTRIM(SB1->B1_GRUPO) == "PIC"
			dbSelectArea("TRB")
			If !dbSeek(DTOS(SD2->D2_EMISSAO)+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SG1->G1_COMP)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PRODCLI  := SD2->D2_PROCLI
				TRB->NOMECLI  := SA1->A1_NOME
				TRB->EMISSAO  := SD2->D2_EMISSAO
				TRB->CLIENTE  := SD2->D2_CLIENTE
				TRB->LOJA     := SD2->D2_LOJA
				TRB->PRODUTO  := SD2->D2_COD
				TRB->COMP     := SG1->G1_COMP
				TRB->DESCPA   := _cDescPa
				TRB->DESCMP   := _cDescMP
				TRB->QTESTR   := nQuantItem
				If !_lGravou
					TRB->QTDVENPA := SD2->D2_QUANT
					TRB->VLVENDPA := SD2->D2_TOTAL
				Endif
				TRB->QTDVENMP :=  SD2->D2_QUANT * nQuantItem
//				TRB->VLVENDMP := (SD2->D2_QUANT * nQuantItem )* SB1->B1_UPRC
				MsUNlock()
			Else
				dbSelectArea("TRB")
				RecLock("TRB",.F.)
				If !_lGravou
					TRB->QTDVENPA += SD2->D2_QUANT
					TRB->VLVENDPA += SD2->D2_TOTAL
				Endif
				TRB->QTDVENMP += (SD2->D2_QUANT * nQuantItem)
				MsUNlock()
			Endif

			PA141A()		

		Endif
				
		If _lPAV .And. Substr(SB1->B1_COD,1,2) == "LP"
			dbSelectArea("TRB")
			If !dbSeek(DTOS(SD2->D2_EMISSAO)+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SG1->G1_COMP)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PRODCLI  := SD2->D2_PROCLI
				TRB->NOMECLI  := SA1->A1_NOME
				TRB->EMISSAO  := SD2->D2_EMISSAO
				TRB->CLIENTE  := SD2->D2_CLIENTE
				TRB->LOJA     := SD2->D2_LOJA
				TRB->PRODUTO  := SD2->D2_COD
				TRB->COMP     := SG1->G1_COMP
				TRB->DESCPA   := _cDescPa
				TRB->DESCMP   := _cDescMP
				TRB->QTESTR   := nQuantItem
				If !_lGravou
					TRB->QTDVENPA := SD2->D2_QUANT
					TRB->VLVENDPA := SD2->D2_TOTAL
				Endif
				TRB->QTDVENMP :=  SD2->D2_QUANT * nQuantItem
//				TRB->VLVENDMP := (SD2->D2_QUANT * nQuantItem )* SB1->B1_UPRC
				MsUNlock()
			Else
				dbSelectArea("TRB")
				RecLock("TRB",.F.)
				If !_lGravou
					TRB->QTDVENPA += SD2->D2_QUANT
					TRB->VLVENDPA += SD2->D2_TOTAL
				Endif
				TRB->QTDVENMP += (SD2->D2_QUANT * nQuantItem)
//				TRB->VLVENDMP += (SD2->D2_QUANT * nQuantItem)* SB1->B1_UPRC
				MsUNlock()
			Endif

			PA141A()		
	
		Endif
		
		If _lPAC .And. Substr(SB1->B1_COD,1,2) == "CP"
			dbSelectArea("TRB")
			If !dbSeek(DTOS(SD2->D2_EMISSAO)+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SG1->G1_COMP)
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
				TRB->PRODCLI  := SD2->D2_PROCLI
				TRB->NOMECLI  := SA1->A1_NOME
				TRB->EMISSAO  := SD2->D2_EMISSAO
				TRB->CLIENTE  := SD2->D2_CLIENTE
				TRB->LOJA     := SD2->D2_LOJA
				TRB->PRODUTO  := SD2->D2_COD
				TRB->COMP     := SG1->G1_COMP
				TRB->DESCPA   := _cDescPa
				TRB->DESCMP   := _cDescMP
				TRB->QTESTR   := nQuantItem
				If !_lGravou
					TRB->QTDVENPA := SD2->D2_QUANT
					TRB->VLVENDPA := SD2->D2_TOTAL
				Endif
				TRB->QTDVENMP :=  SD2->D2_QUANT * nQuantItem
//				TRB->VLVENDMP := (SD2->D2_QUANT * nQuantItem )* SB1->B1_UPRC
				MsUNlock()
			Else
				dbSelectArea("TRB")
				RecLock("TRB",.F.)
				If !_lGravou
					TRB->QTDVENPA += SD2->D2_QUANT
					TRB->VLVENDPA += SD2->D2_TOTAL
				Endif
				TRB->QTDVENMP += (SD2->D2_QUANT * nQuantItem)
//				TRB->VLVENDMP += (SD2->D2_QUANT * nQuantItem)* SB1->B1_UPRC
				MsUNlock()
			Endif
	
			PA141A()		
	
		Endif			                                                
		
		dbSelectArea("SG1")
		dbSetOrder(1)
		dbSeek(xFilial("SG1")+SG1->G1_COMP)

		IF Found()
			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+SG1->G1_COD)
			NECES(SG1->G1_COD,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
		EndIf
		
		dbSelectArea("SG1")
		dbGoto(_nReg)
	Endif

	dbSkip()

EndDo

Return


Static Function PA141A()

LOCAL Tamanho
LOCAL cDesc1   := "Emite um relatorio com os calculos da planilha selecionada pa-"
LOCAL cDesc2   := "ra cada produto. Os valores calculados sao os mesmos  referen-"
LOCAL cDesc3   := "tes as formulas da planilha."
LOCAL cString    := "SB1"
LOCAL nI       := 0

LOCAL titulo   := OemToAnsi("Planilha de Formacao de Precos")
LOCAL wnrel := "PA0141"

LOCAL cRodaTxt := ""
LOCAL nCntImpr := 0,nReg
LOCAL aArray   := {} ,cCondFiltr,lRet
LOCAL nI       := 0
LOCAL cProdFim :=""

PRIVATE aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }		//###
PRIVATE nLastKey := 0 ,cPerg := "PA0141",aPar:=Array(20),aParC010:=Array(20)

PRIVATE li := 80 ,m_pag := 1,cProg:="R430"

PRIVATE nQualCusto := 1
PRIVATE aAuxCusto
PRIVATE cArqMemo := "STANDARD"
PRIVATE lDirecao := .T.
PRIVATE lConsNeg := apar[08] = 1     // Esta variavel será usada na função MC010FORMA

MTC010SX1()

PERGUNTE("MTC010", .F.)

For ni := 1 to 20
	aPar[ni] := &("mv_par"+StrZero(ni,2))
Next ni

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vetor declarado para inversao do calculo do Valor Unitario   ³
//³ Utilizado no MATC010X -> M010Forma e CalcTot                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE lDirecao := .T.                     // Direcao do calculo .T. para baixo .F. para cima

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Forca utilizacao da estrutura caso nao tenha SGG               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Select("SGG") == 0
	mv_par09:=1
EndIf

//Salvar variaveis existentes

For ni := 1 to 20
	aParC010[ni] := &("mv_par"+StrZero(ni,2))
Next ni

//Forca mesmo valor do relatorio na pergunta 09

mv_par09     		:= aPar[09]
aParC010[09] 	:= aPar[09]

cCondFiltr 			:= ".T."
                        
lRet:=PA141D(.T.,aPar)

IF !lRet
	SET DEVICE TO SCREEN
	Return Nil
ENDIF

dbSelectarea("SB1")
dbSetOrder(1)
If dbSeek(xFilial("SB1")+SD2->D2_COD)

	cProdFim:=SB1->B1_COD

	nReg := Recno()

	If &(cCondFiltr)
		aArray := MC010Forma(cString,nReg,99,apar[07],,.F.)
		PA141C(aArray[1],aArray[2],aArray[3])
		dbGoTo(nReg)
	EndIf

EndIF

For ni := 1 to 20
		&("mv_par"+StrZero(ni,2)) := aPar[ni]
Next ni

// Restaura variaveis existentes
For ni := 1 to 20
		&("mv_par"+StrZero(ni,2)) := aParc010[ni]
Next ni

RETURN


Static Function PA141C(cCusto,aArray,nPosForm)

cCusto := If(cCusto=Nil,'',AllTrim(Upper(cCusto)))

If cCusto == 'ULT PRECO'
	nDecimal := TamSX3('B1_UPRC')[2]
ElseIf 'MEDIO' $ cCusto
	nDecimal := TamSX3('B2_CM1')[2]
Else
	nDecimal := TamSX3('B1_CUSTD')[2]
EndIf

nCotacao:=1
cMoeda1:=GetMV("MV_MOEDA1")

cMoeda1:=PADC(Alltrim(cMoeda1),35)

For nX := 1 To Len(aArray)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o nivel da estrutura para ser impresso ou nao  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Val(aArray[nX,2]) > 999
		Loop
	Endif

	If If( (Len(aArray[ nX ])==12),aArray[nX,12],.T. )		
		If nX < nPosForm-1
			If aParc010[02] == 1
				_nValUni := Round(aAuxCusto[nX]/aArray[nX][05], nDecimal)
			Else
				_nValUni := NoRound(aAuxCusto[nX]/aArray[nX][05], nDecimal)
			EndIf
		EndIf                                       

		_cComp  := aArray[ nX ][4]		
		dbSelectArea("TRB")
		If dbSeek(DTOS(SD2->D2_EMISSAO)+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+_cComp)
			dbSelectArea("TRB")
			RecLock("TRB",.F.)
			TRB->PRCPROD   := _nValUni
			TRB->VLVENDMP += (SD2->D2_QUANT * nQuantItem)* _nValUni
			MsUnLock()
		Endif
	EndIf

Next nX

Return

         

Static Function PA141D(lGravado,aPar)

Local cArq := ""     
Local lRet := .T.

/*
//DEFAULT lGravado:=.F.
lGravado:=.F.

cArq:=AllTrim(If(lGravado,apar[03],&(ReadVar())))+".PDV"

If !File(cArq)
	Help(" ",1,"MR430NOPLA")
	lRet := .F.
EndIf
  */
  
Return (lRet)
