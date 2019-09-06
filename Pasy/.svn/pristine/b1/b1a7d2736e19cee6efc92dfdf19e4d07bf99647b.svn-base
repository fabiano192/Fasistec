#include "rwmake.ch"

User Function PA0073()

SetPrvt("_cAliOri,_nOrdOri,_nRecOri,_aStrREt,_cArqRet")

_cAliOri := Alias()
_nOrdOri := IndexOrd()
_nRecOri := Recno()
_lBx     := .F.
    
If !Pergunte("PA0073",.T.)
	Return               	
Endif	                 

Private _lFim      := .F.
Private _cMsg01    := ''
Private _lAborta01 := .T.
Private _bAcao01   := {|_lFim| PA0073A(@_lFim) }
Private _cTitulo01 := 'Processando Movimentacao Interna'
Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )

MSGINFO("Alteracao Efetuada com Sucesso !!! ")

Return



Static Function PA0073A(_lFim)

dbSelectArea("SD3")
dbSetOrder(6)
dbSeek(xFilial("SD3")+Dtos(MV_PAR01),.T.)

ProcRegua(LastRec())

While !Eof() .And. !_lFim .And.  SD3->D3_EMISSAO <= MV_PAR02
	
	IncProc()
	
	If SD3->D3_CF != "PR0" .Or. SD3->D3_TIPO != "PA" 
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif
	
	If  SD3->D3_ESTORNO == "S"
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif

	If SD3->D3_OP  < MV_PAR03 .Or. SD3->D3_OP  > MV_PAR04 .Or.;
	   SD3->D3_COD < MV_PAR05 .Or. SD3->D3_COD > MV_PAR06
		dbSelectArea("SD3")
		dbSkip()
		Loop
	Endif
		
	_aAliSD3  := SD3->(GetArea())
	_cOp      := SD3->D3_OP
	_dEmissao := SD3->D3_EMISSAO
	_cNumSeq  := SD3->D3_NUMSEQ
	_cDoc     := SD3->D3_DOC
	_cIdent   := SD3->D3_IDENT
	_nPerda   := SD3->D3_PERDA 	                                        
	                               
	If SD3->D3_TIPO == "PA" .And. SD3->D3_CF == "PR0"
		dbSelectArea("SG1")
		dbSetOrder(1)
		If dbSeek(xFilial("SG1")+SD3->D3_COD)
		
			_cProd    := SG1->G1_COD
			nNivel    := 2
		
			_nQtAnt   :=  SD3->D3_QUANT
			_nSdoIni2 := 0
		
			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+_cProd)
		
			NECES(_cProd,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,IF(SB1->B1_QB==0,1,SB1->B1_QB),SB1->B1_OPC,SB1->B1_REVATU)
		Endif
	Endif
	
	dbSelectArea("SD3")
	RestArea(_aAliSD3)
	
	dbSelectArea("SD3")
	dbSkip()
EndDo


ReTurn


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
			
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+SG1->G1_COMP)
		_cDescMP := SB1->B1_DESC
		
		If SB1->B1_LOCPAD == "20"
			
			dbSelectArea("SD3")
			dbSetorder(7)
			If !dbSeek(xFilial("SD3")+SG1->G1_COMP + SB1->B1_LOCPAD + DTOS(_dEmissao) + _cNumSeq)
				dbSelectArea("SD3")
				RecLock("SD3",.T.)
				SD3->D3_FILIAL  := xFilial("SD3")
				SD3->D3_COD     := SG1->G1_COMP
				SD3->D3_TM      := "999"
				SD3->D3_UM      := SB1->B1_UM
				SD3->D3_QUANT   := _nQtAnt + _nPerda
				SD3->D3_CF      := "RE1"
				SD3->D3_OP      := _cOp
				SD3->D3_LOCAL   := "20"
				SD3->D3_DOC     := _cDoc
				SD3->D3_GRUPO   := SB1->B1_GRUPO
				SD3->D3_EMISSAO := _dEmissao
				SD3->D3_NUMSEQ  := _cNumSeq
				SD3->D3_TIPO    := SB1->B1_TIPO
				SD3->D3_USUARIO := "PA0073"
				SD3->D3_IDENT   := _cIdent
				SD3->D3_CHAVE   := "E0"
				MsUNlock()
			Endif
		Endif
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
	dbSkip()
EndDo

Return