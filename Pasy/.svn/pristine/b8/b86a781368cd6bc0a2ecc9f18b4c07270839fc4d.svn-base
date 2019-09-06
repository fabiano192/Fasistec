#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Pa0057   บ Autor ณ Alexandro Da Silva บ Data ณ  21/03/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ INDICADOR DE PRODUCOES                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Sigapcp                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PA0057()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private _nHrTrab := _nQtPro := 	_nQtPer := _nQtMet := _nTotMP := _nQtMp := 0

Private cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2       := "de acordo com os parametros informados pelo usuario."
Private cDesc3       := "de Indicador de Producao.
Private cPict        := ""
Private titulo       := "Indicadores de Producao"
Private nLin         := 80

Private Cabec1       := "Codigo Produto  Ord. Producao Data     Cliente Lj Turno  Prensa Prensista       Operador  Acab. Qtde Produzida    Qtde Refugo"
Private Cabec2       := ""
Private imprime      := .T.
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "PA0057"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "PA0057"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PA0057"
Private cString      := "SD3"

dbSelectArea("SD3")
dbSetOrder(1)

pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)  

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo              := If(aReturn[4]==1,15,18)

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| GeraTrb(@_lFim) }
Private _cTitulo01 := 'Processando '
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )


_bAcao01   := {|_lFim| VerHora(@_lFim) }
_cTitulo01 := 'Processando '
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

If mv_par19 == 1 // Analitico
	_bAcao01   := {|_lFim| ImpAnal(@_lFim) }
	
	_cTitulo01 := 'Imprimindo '
	RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
Else
	_bAcao01   := {|_lFim| ImpSint(@_lFim) }
	
	_cTitulo01 := 'Imprimindo '
	RptStatus( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
	_cArqNew := "\CRYSTAL\PA0057.DBF"

	dbSelectArea("TMP")
	COPY ALL TO &_cArqNew
	
	dbCloseArea()

	Private cSeqRel := ""     
	_cMod   := cModulo
	cModulo := "EEC"
	_lRet 	:= E_ARQCRW()

	AVGCRW32("PA0057.RPT","Indicador de Producao")

	cModulo := _cMod
Endif

dbSelectArea("TRB")
dbCloseArea()

dbSelectArea("TRB2")
dbCloseArea()

Return


Static Function GeraTRb(_lFim)


////////////////////////////////////////////
////////////////////////////////////////////
/////                                  /////
/////  MV_PAR01  : Data De ?           /////
/////  MV_PAR02  : Data Ate?           /////
/////  MV_PAR03  : Produto De?         /////
/////  MV_PAR04  : Produto Ate?        /////
/////  MV_PAR05  : Almoxarifado De?    /////
/////  MV_PAR06  : Almoxarifado Ate?   /////
/////  MV_PAR07  : O.Producao De ?     /////
/////  MV_PAR08  : O.Producao Ate?     /////
/////  MV_PAR09  : C.CUSTO    De ?     /////
/////  MV_PAR10  : C.Custo    Ate?     /////
/////  MV_PAR11  : Grupo De      ?     /////
/////  MV_PAR12  : Grupo Ate     ?     /////
/////  MV_PAR13  : M.Prima De    ?     /////
/////  MV_PAR14  : M.Prima Ate   ?     /////
/////  MV_PAR15  : Operador De   ?     /////
/////  MV_PAR16  : Operador Ate  ?     /////
/////  MV_PAR17  : Maquina  De   ?     /////
/////  MV_PAR18  : Maquina  Ate  ?     /////
/////  MV_PAR19  : Analitico/Sintetico /////
/////  MV_PAR20  : Objetivo Produtiv?  /////
/////  MV_PAR21  : Objetivo Aproveirt: /////
/////                                  /////
////////////////////////////////////////////

aStru := {}
AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
AADD(aStru,{"ORDPROD"  , "C" , 13, 0 })
AADD(aStru,{"ALMOX"    , "C" , 02, 0 })
AADD(aStru,{"DTPROD"   , "D" ,  8, 0 })
AADD(aStru,{"QTDPROD"  , "N" , 14, 2 })
AADD(aStru,{"QTDREF"   , "N" , 14, 2 })
AADD(aStru,{"QTMP"     , "N" , 14, 2 })
AADD(aStru,{"QTAREA"   , "N" , 14, 2 })
AADD(aStru,{"QTHORAS"  , "N" , 14, 2 })

cArq    := CriaTrab(aStru,.T.)
cInd    := "PRODUTO+ALMOX+Dtos(DTPROD)+ORDPROD"

dbUseArea(.T.,,cArq,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArq,cInd,,,"Criando Trabalho...")

aStru2 := {}
AADD(aStru2,{"CODFUNC"  , "C" , 06, 0 })
AADD(aStru2,{"NOMEFUNC" , "C" , 30, 0 })
AADD(aStru2,{"QTHORA"   , "N" , 14, 0 })

cArq2   := CriaTrab(aStru2,.T.)
cInd2   := "CODFUNC"

dbUseArea(.T.,,cArq2,"TRB2",.F.,.F.)

dbSelectArea("TRB2")
IndRegua("TRB2",cArq2,cInd2,,,"Criando Trabalho...")

dbSelectArea("SD3")
dbSetOrder(6)
dbSeek(xFilial("SD3")+Dtos(MV_PAR01),.T.)

ProcRegua(RecCount())

While !Eof() .And. SD3->D3_EMISSAO <= MV_PAR02 .And. !_lFim
	
	IncProc()
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	If  SD3->D3_COD      < MV_PAR03 .Or. SD3->D3_COD     > MV_PAR04 .Or.;
		SD3->D3_LOCAL    < MV_PAR05 .Or. SD3->D3_LOCAL   > MV_PAR06 .Or.;
		SD3->D3_OP       < MV_PAR07 .Or. SD3->D3_OP      > MV_PAR08 .Or.;
		SD3->D3_GRUPO    < MV_PAR11 .Or. SD3->D3_GRUPO   > MV_PAR12 .Or.;
		SD3->D3_OPERACA  < MV_PAR15 .Or. SD3->D3_OPERACA > MV_PAR16 .Or.;
		SD3->D3_RECURSO  < MV_PAR17 .Or. SD3->D3_RECURSO > MV_PAR18 .Or.;
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif
	
	If SD3->D3_ESTORNO == "S" .Or. Substr(SD3->D3_CF,1,2) != "PR"
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif
	
	If SD3->D3_TIPO != "PA"
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SD3->D3_COD)
	
	_aAliSB12 := GetArea()
	_nTotMP   := 0
	dbSelectArea("SG1")
	dbSetOrder(1)
	If dbSeek(xFilial("SG1")+SD3->D3_COD)
		
		_cProd   := SG1->G1_COD
		nNivel   := 2
		
		VERESTR(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
	Endif
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SD3->D3_COD)
	
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->PRODUTO  := SD3->D3_COD
	TRB->ALMOX    := SD3->D3_LOCAL
	TRB->ORDPROD  := SD3->D3_OP
	TRB->DTPROD   := SD3->D3_EMISSAO
	TRB->QTDPROD  := SD3->D3_QUANT
	TRB->QTDREF   := SD3->D3_PERDA
	TRB->QTAREA   := SD3->D3_QUANT * SB1->B1_AREAPEC
	TRB->QTMP     := _nTotMP
	MsUnlock()
	
	_nQtPro += SD3->D3_QUANT
	_nQtPer += SD3->D3_PERDA
	_nQtMet += SD3->D3_QUANT * SB1->B1_AREAPEC
	_nQtMp  += _nTotMP
	
	dbSelectArea("SD3")
	dbSkip()
EndDo


Return


Static Function VERESTR(_cProd,_nQtPai,nNivel,_nQtBase,_cOpc,_cRev)

Local _nReg,nQuantItem := 0
Local _nRegTrb := 0
dbSelectArea("SG1")
dbSetOrder(1)
While !Eof() .And. SG1->G1_FILIAL + SG1->G1_COD == xFilial("SG1") + _cProd
	
	_nReg := Recno()
	
	nQuantItem := ExplEstr(_nQtPai,,_cOpc,_cRev)
	dbSelectArea("SG1")
	dbSetOrder(1)
	
	dbSelectArea("SB1")
	_aAliSB1 := GetArea()
	dbSeek(xFilial("SB1")+SG1->G1_COMP)
	
	If SB1->B1_COD  < MV_PAR13 .Or. SB1->B1_COD  > MV_PAR14
		dbSelectARea("SB1")
		dbSkip()
		Loop
	Endif
	
	If SB1->B1_TIPO == "MP" //.And. ALLTRIM(SB1->B1_GRUPO) $ "MPVZ"
		_nTOTMP += nQuantItem * SD3->D3_QUANT
	Endif
	
	RestArea(_aAliSB1)
	
	dbSelectArea("SG1")
	dbSetOrder(1)
	dbSeek(xFilial("SG1")+SG1->G1_COMP)
	IF Found()
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+SG1->G1_COD)
		VERESTR(SG1->G1_COD,nQuantItem,nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
	EndIf
	
	dbSelectArea("SG1")
	dbGoto(_nReg)
	
	dbSkip()
EndDo

Return


Static Function VerHora(_lFim)

_cPer := GetMv("MV_FOLMES")

_cPerPar := STRZERO(YEAR(MV_PAR01),4)+STRZERO(MONTH(MV_PAR01),2)


_nHrTrab := 0

dbSelectArea("SRD")
dbOrderNickName("INDSRD1")
dbSeek(xFilial("SRD")+_cPerPar+MV_PAR09,.T.)

ProcRegua(LastRec())

_nHrTrab := 0
While !Eof() .And. _cPerPar == SRD->RD_DATARQ .And. SRD->RD_CC <= MV_PAR10
	
	IncProc()
	
	If !SRD->RD_PD $ "102/103/104"
		dbSelectArea("SRD")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("TRB2")
	If dbSeek(SRD->RD_MAT)
		RecLock("TRB2",.F.)
		TRB2->QTHORA += SRD->RD_HORAS
		MsUnlock()
	Else
		dbSelectArea("SRA")
		dbSetOrder(1)
		dbSeek(xFilial("SRA")+SRD->RD_MAT)
		
		dbSelectArea("TRB2")
		RecLock("TRB2",.T.)
		TRB2->CODFUNC  := SRD->RD_MAT
		TRB2->NOMEFUNC := SRA->RA_NOME
		TRB2->QTHORA  := SRD->RD_HORAS
		MsUnlock()
	Endif
	
	_nHrTrab += SRD->RD_HORAS
	
	dbSelectArea("SRD")
	dbSkip()
EndDo


Return



Static Function ImpAnal(_lFim)


/*

Produto         O.Producao    Data       Qtde Em Pc     Qtde EM M2     Qt.Perda
999999999999999 9999999999999 99999999 999999999999 99999999999999 999999999999
0               15            30       39           52             67

*/

Private Cabec1 := "Produto         O.Producao    Data       Qtde Em Pc     Qtde EM M2     Qt.Perda"

Private titulo       := "Indicadores de Producao Periodo "+Dtoc(MV_PAR01)+ " Ate "+Dtoc(MV_PAR02)

_nQtdProd  := _nQtdRef := _nQtArea  := 0

nLin := 80

dbSelectArea("TRB")
dbGotop()

SetRegua(LastRec())

While !Eof() .And. !_lFim
	
	IncRegua()
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	If nLin > 57
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@nLin, 000 PSAY TRB->PRODUTO
	@nLin, 015 PSAY TRB->ORDPROD
	@nLin, 030 PSAY TRB->DTPROD
	@nLin, 039 PSAY TRB->QTDPROD Picture Tm(TRB->QTDPROD,14)
	@nLin, 052 PSAY TRB->QTAREA  Picture Tm(TRB->QTAREA,12,4)
	@nLin, 067 PSAY TRB->QTDREF  Picture Tm(TRB->QTAREA,14)
	
	_nQtdProd += TRB->QTDPROD
	_nQtdRef  += TRB->QTDREF
	_nQtArea  += TRB->QTAREA
	
	nLin++
	
	dbSelectArea("TRB")
	dbSkip()
EndDo

nLin ++

If nLin > 57
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

@nLin, 000 PSAY "TOTAL GERAL ----- > "
@nLin, 039 PSAY _nQtdProd             Picture TM(_nQtdProd,14)
@nLin, 052 PSAY _nQtdRef              Picture TM(_nQtdRef,12,4)
@nLin, 067 PSAY _nQtArea              Picture TM(_nQtArea,14)

/*
Codigo  Nome do Funcionario               Qtde Horas Trabalhadas
999999  9999999999999999999999999999999           99999999999999
0       8                                         50
*/

Cabec1:= "Codigo  Nome do Funcionario               Qtde Horas Trabalhadas"

nLin := 80

_nToHora := 0
dbSelectArea("TRB2")
dbGotop()

SetRegua(LastRec())

While !Eof() .And. !_lFim
	
	IncRegua()
	
	If _lFim
		Alert("Cancelado Pelo Usuario!!!!")
		Return
	Endif
	
	If nLin > 57
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@nLin, 000 PSAY TRB2->CODFUNC
	@nLin, 008 PSAY TRB2->NOMEFUNC
	@nLin, 050 PSAY TRB2->QTHORA  Picture Tm(TRB2->QTHORA,14)
	
	_nToHora += TRB2->QTHORA
	
	nLin++
	
	dbSelectArea("TRB2")
	dbSkip()
EndDo

nLin ++

If nLin > 57
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

@nLin, 000 PSAY "TOTAL GERAL ----- > "
@nLin, 050 PSAY _nToHora              Picture TM(_nToHora,14)

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Static Function ImpSint(_lFim)   // Sintetico


aStru := {}                                         

AADD(aStru,{"PERIO1"   , "D" ,  8, 0 })
AADD(aStru,{"PERIO2"   , "D" ,  8, 0 })
AADD(aStru,{"OBJET1"   , "C" , 50, 0 })
AADD(aStru,{"QTPROD"   , "N" , 14, 2 })
AADD(aStru,{"QTMET2"   , "N" , 14, 2 })
AADD(aStru,{"QTHRTR"   , "N" , 14, 2 })
AADD(aStru,{"RESUL1"   , "N" , 14, 2 })             
AADD(aStru,{"OBJET2"   , "C" , 50, 0 })
AADD(aStru,{"QTMATP"   , "N" , 14, 2 })
AADD(aStru,{"RESUL2"   , "N" , 14, 2 })

cArq    := CriaTrab(aStru,.T.)
cInd    := "QTPROD"

dbUseArea(.T.,,cArq,"TMP",.F.,.F.)

dbSelectArea("TMP")
IndRegua("TMP",cArq,cInd,,,"Criando Trabalho...")

_nResul1 :=  _nQtMet / _nHrTrab
_nResul2 :=  _nQtPro / _nQtMp
dbSelectArea("TMP")
RecLock("TMP",.T.)
TMP->PERIO1  := MV_PAR01
TMP->PERIO2  := MV_PAR02
TMP->OBJET1  := Transform(MV_PAR20,"@E 999,999.99")+" M2 / HORA HOMEM"
TMP->QTPROD  := _nQtPro
TMP->QTMET2  := _nQtMet
TMP->QTHRTR  := _nHrTrab
TMP->RESUL1  := _nResul1
TMP->OBJET2  := Transform(MV_PAR21,"@E 999,999.99")+" %	"
TMP->QTMATP  := _nQtMp
TMP->RESUL2  := _nResul2
MsUnlock()


/*                              

Private titulo       := "Indicadores de Producao Periodo "+Dtoc(MV_PAR01)+ " Ate "+Dtoc(MV_PAR02)

QTDE EM PECAS      QTDE EM M2     QTDE HORAS TRABALHADAS  RESULTADO PECA / HORA HOMEM
99999999999999 99999999999999    99999999999999999999999  999999999999999999999
0              15                33                       58



Private Cabec1 := ""//"QTDE EM PECAS      QTDE EM M2     QTDE HORAS TRABALHADAS  RESULTADO PECA / HORA"

_nQtdProd  := _nQtdRef := 0


If nLin > 57
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 11
Endif

@nLin, 000 PSAY "INDICADOR DE PRODUTIVIDADE (M2 DE PECAS PRODUZ. / HORA HOMEM TRABALHADA)"
nlin += 2
@nLin, 000 PSAY "OBJETIVO : "+Transform(MV_PAR20,"@E 999,999.99")+" M2 / HORA HOMEM"
nlin += 3
@nLin, 000 PSAY "QTDE EM PECAS      QTDE EM M2     QTDE HORAS TRABALHADAS  RESULTADO PECA / HORA HOMEM"
nLin += 3


_nResult :=  _nQtMet / _nHrTrab
@nLin, 000 PSAY _nQtPro                 Picture TM(_nQtPro,14)
@nLin, 015 PSAY _nQtMet                 Picture TM(_nQtMet,14)
@nLin, 033 PSAY _nHrTrab                Picture TM(_nHrTrab,23)
@nLin, 058 PSAY _nResult                Picture TM(_nResult,14)

nLin+=5                                                                                          
                                                                                
/*
QTDE EM PECAS      QTDE EM M2       QTDE M.PRIMA ALOCADA                RESULTADO 
99999999999999 99999999999999    99999999999999999999999           99999999999999       
0              15                33                                67    

@nLin, 000 PSAY "INDICADOR DE APROVEITAMENTO (M2 DE PECAS PRODUZ. / M2 M.PRIMA ALOCADA)X 100"
nlin += 2
@nLin, 000 PSAY "OBJETIVO : "+Transform(MV_PAR21,"@E 999,999.99")+" %	"
nlin += 3
@nLin, 000 PSAY "QTDE EM PECAS      QTDE EM M2       QTDE M.PRIMA ALOCADA                RESULTADO"
nLin += 3


_nResult :=  _nQtPro / _nQtMp
@nLin, 000 PSAY _nQtPro                 Picture TM(_nQtPro,14)
@nLin, 015 PSAY _nQtMet                 Picture TM(_nQtMet,14)

If nLin > 57
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()
  */
Return
