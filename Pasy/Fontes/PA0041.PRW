#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPA0041    บ Autor ณ Alexandro da Silva บ Data ณ  04/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio de Consumo Mensal                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Sigacom                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PA0041()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := "Relat๓rio de Consumo Mensal "
Private cPict          := ""
Private titulo         := "Relat๓rio de Consumo Mensal "
Private nLin           := 80

Private Cabec1         := ""
Private Cabec2         := ""
Private imprime        := .T.
Private aOrd           := {"Por Fornecedor","Por Grupo"}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "PA0041"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "PA0041"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PA0041"

Private cString := "SD1"

dbSelectArea("SD1")
dbSetOrder(1)


pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

_nOrd  :=  aReturn[8]


If _nOrd == 1
	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| ProcFor(@_lFim) }
	Private _cTitulo01 := 'Processando Por Fornecedor'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
Else
	Private _lFim      := .F.
	Private _cMsg01    := ''
	Private _lAborta01 := .T.
	Private _bAcao01   := {|_lFim| ProcGr(@_lFim) }
	Private _cTitulo01 := 'Processando Por Grupo'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
Endif


//dbSelectArea("TRB")
//dbCloseArea()


Return


Static Function PROCFOR()

aStru := {}
AADD(aStru,{"PRODUTO",  "C" ,15, 0 })
AADD(aStru,{"DESCPRO",  "C" ,30, 0 })
AADD(aStru,{"CODFOR" ,  "C" ,06, 0 })
AADD(aStru,{"LOJA"   ,  "C" ,02, 0 })
AADD(aStru,{"NOMFOR" ,  "C" ,30, 0 })
AADD(aStru,{"UM"     ,  "C" , 2, 0 })
AADD(aStru,{"QUANT"  ,  "N" ,12, 2 })
AADD(aStru,{"VALOR"  ,  "N" ,14, 2 })

cArqTRB := CriaTrab(aStru,.T.)
cIndTRB := "CODFOR+LOJA+PRODUTO"

dbUseArea(.T.,,cArqTRB,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",cArqTRB,cIndTRB,,,"Criando Trabalho...")

///////////////////////////////////////
////// Grupo de Perguntas PA0041 //////
////// MV_PAR01     Data De      //////
////// MV_PAR02     Data Ate     //////
////// MV_PAR03     TIPO DE      //////
////// MV_PAR04     TIPO ATE     //////
////// MV_PAR05     GRUPO DE     //////
////// MV_PAR06     GRUPO ATE    //////
////// MV_PAR07     PRODUTO DE   //////
////// MV_PAR08     PRODUTO ATE  //////
////// MV_PAR09     Gera Duplicata //////
////////////////////////////////////////

dbSelectArea("SD1")
dbSetOrder(6)
dbSeek(xFiliAL("SD1")+DTOS(MV_PAR01),.T.)

ProcRegua(LastRec())

While !Eof() .And. !_lFim .And. SD1->D1_DTDIGIT <= MV_PAR02
	
	If _lFim
		Alert("Cancelado pelo Usuario!!!")
	Endif
	
	IncProc()

	If SD1->D1_TIPO $ "B/D"
		dbSelectArea("SD1")
		dbSkip()
		Loop
	Endif                   
	
	dbSelectArea("SF4")
	dbSetOrder(1)
	If dbSeek(xFilial("SF4")+SD1->D1_TES)
		If MV_PAR09 == 1 .And. SF4->F4_DUPLIC != "S"
			dbSelectArea("SD1")
			dbSkip()
			Loop
		Endif                                      
		
		If MV_PAR09 == 2 .And. SF4->F4_DUPLIC == "S"
			dbSelectArea("SD1")
			dbSkip()
			Loop
		Endif                                      		
	Endif

	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SD1->D1_COD)
	
	If SB1->B1_TIPO    < MV_PAR03 .Or. SB1->B1_TIPO  > MV_PAR04 .Or. ;
		SB1->B1_GRUPO  < MV_PAR05 .Or. SB1->B1_GRUPO > MV_PAR06 .Or. ;
		SD1->D1_COD    < MV_PAR07 .Or. SD1->D1_COD   > MV_PAR08
		dbSelectArea("SD1")
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+SD1->D1_FORNECE + SD1->D1_LOJA)
	
	dbSelectArea("TRB")
	If !dbSeek(SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD)
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->PRODUTO := SD1->D1_COD
		TRB->DESCPRO := Substr(SB1->B1_DESC,1,30)
		TRB->CODFOR  := SD1->D1_FORNECE
		TRB->LOJA    := SD1->D1_LOJA
		TRB->NOMFOR  := Substr(SA2->A2_NOME,1,30)
		TRB->UM      := SB1->B1_UM
		TRB->QUANT   := SD1->D1_QUANT
		TRB->VALOR   := SD1->D1_TOTAL
		MsUnlock()
	Else
		dbSelectArea("TRB")
		RecLock("TRB",.F.)
		TRB->QUANT   += SD1->D1_QUANT
		TRB->VALOR   += SD1->D1_TOTAL
		MsUnlock()	
	Endif
	
	dbSelectArea("SD1")
	dbSkip()
EndDo

/*
Produto         Descricao                      UM     Quantidade          Valor
999999999999999 999999999999999999999999999999 99 99999999999999 99999999999999
0               16                             47 50             65
*/

Cabec1  := "Produto         Descricao                      UM     Quantidade          Valor"
Cabec2  := ""
_nTotQt := 0
_nTotVl := 0

dbSelectARea("TRB")
dbGotop()

ProcRegua(LastRec())

While !Eof() .And. !_lFim
	
	_cCodFor  := TRB->CODFOR
	
	If nLin > 65
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	_cNomFor := TRB->NOMFOR
	
	@nLin,00 PSAY TRB->CODFOR+" "+TRB->LOJA+" - "+TRB->NOMFOR
	nLin+= 2
	
	_nQt  := 0
	_nVl  := 0
	
	While !Eof() .And. _cCodFor  == TRB->CODFOR
		
		IncProc("Imprimindo")
		
		If nLin > 65
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
			@nLin,00 PSAY TRB->CODFOR+" "+TRB->LOJA+" - "+TRB->NOMFOR
			nLin+=2
		Endif
		
		@nLin,00 PSAY TRB->PRODUTO
		@nLin,16 PSAY Substr(TRB->DESCPRO,1,30)
		@nLin,47 PSAY TRB->UM
		@nLin,50 PSAY TRB->QUANT             PICTURE TM(TRB->QUANT,14)
		@nLin,65 PSAY TRB->VALOR             PICTURE TM(TRB->VALOR,14)
		
		nLin++
		
		_nQt += TRB->QUANT
		_nVl += TRB->VALOR
		
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	nLin++
	
	If nLin > 65
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@nLin,00 PSAY "TOTAL DO FORNECEDOR --> "+Substr(_cNomFor,1,20)
	@nLin,50 PSAY _nQt                       PICTURE TM(_nQt,14)
	@nLin,65 PSAY _nVl                       PICTURE TM(_nVl,14)
	
	nLin+=2
	
	_nTotQt += _nQt
	_nTotVl += _nVl
	
	dbSelectArea("TRB")
EndDo

nLin+= 2

@nLin,00 PSAY "TOTAL GERAL ----> "
@nLin,50 PSAY _nTotQt                       PICTURE TM(_nTotQt,14)
@nLin,65 PSAY _nTotVl                       PICTURE TM(_nTotVl,14)

_cArqNovo := "\RELATO\PA0041.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo


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


dbSelectArea("TRB")
dbCloseArea()

FErase(cArqTrb+".DBF")



Return



Static Function PROCGR()

aStru := {}
AADD(aStru,{"PRODUTO",  "C" ,15, 0 })
AADD(aStru,{"DESCPRO",  "C" ,30, 0 })
AADD(aStru,{"GRUPO"  ,  "C" ,04, 0 })
AADD(aStru,{"DESGR"  ,  "C" ,30, 0 })
AADD(aStru,{"UM"     ,  "C" , 2, 0 })
AADD(aStru,{"QUANT"  ,  "N" ,12, 2 })
AADD(aStru,{"VALOR"  ,  "N" ,14, 2 })

cArqTRB := CriaTrab(aStru,.T.)
cIndTRB := "GRUPO+PRODUTO"

dbUseArea(.T.,,cArqTRB,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",cArqTRB,cIndTRB,,,"Criando Trabalho...")

///////////////////////////////////////
////// Grupo de Perguntas PA0041 //////
////// MV_PAR01     Data De      //////
////// MV_PAR02     Data Ate     //////
////// MV_PAR03     TIPO DE      //////
////// MV_PAR04     TIPO ATE     //////
////// MV_PAR05     GRUPO DE     //////
////// MV_PAR06     GRUPO ATE    //////
////// MV_PAR07     PRODUTO DE   //////
////// MV_PAR08     PRODUTO ATE  //////
/////                            //////
///////////////////////////////////////

dbSelectArea("SD1")
dbSetOrder(6)
dbSeek(xFiliAL("SD1")+DTOS(MV_PAR01),.T.)

ProcRegua(LastRec())

While !Eof() .And. !_lFim .And. SD1->D1_DTDIGIT <= MV_PAR02
	
	If _lFim
		Alert("Cancelado pelo Usuario!!!")
	Endif
	
	IncProc()

	If SD1->D1_TIPO $ "B/D"
		dbSelectArea("SD1")
		dbSkip()
		Loop
	Endif                   
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SD1->D1_COD)
	
	If SB1->B1_TIPO   < MV_PAR03 .Or. SB1->B1_TIPO  > MV_PAR04 .Or. ;
		SB1->B1_GRUPO < MV_PAR05 .Or. SB1->B1_GRUPO > MV_PAR06 .Or. ;
		SD1->D1_COD   < MV_PAR07 .Or. SD1->D1_COD   > MV_PAR08
		dbSelectArea("SD1")
		dbSkip()
		Loop
	Endif

	dbSelectArea("SF4")
	dbSetOrder(1)
	If dbSeek(xFilial("SF4")+SD1->D1_TES)
		If MV_PAR09 == 1 .And. SF4->F4_DUPLIC != "S"
			dbSelectArea("SD1")
			dbSkip()
			Loop
		Endif                                      
		
		If MV_PAR09 == 2 .And. SF4->F4_DUPLIC == "S"
			dbSelectArea("SD1")
			dbSkip()
			Loop
		Endif                                      		
	Endif
	
	_cDesGr := ""
	dbSelectArea("SBM")
	dbSetOrder(1)
	If dbSeek(xFilial("SBM")+SB1->B1_GRUPO)
	   _cDesGr := SBM->BM_DESC
	Endif
	
	dbSelectArea("TRB")
	If !dbSeek(SB1->B1_GRUPO+SD1->D1_COD)
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->PRODUTO := SD1->D1_COD
		TRB->DESCPRO := SB1->B1_DESC
		TRB->UM      := SB1->B1_UM
		TRB->GRUPO   := SB1->B1_GRUPO
		TRB->DESGR   := _cDesGr
		TRB->QUANT   := SD1->D1_QUANT
		TRB->VALOR   := SD1->D1_TOTAL
		MsUnlock()
    Else
		dbSelectArea("TRB")
		RecLock("TRB",.F.)
		TRB->QUANT   += SD1->D1_QUANT
		TRB->VALOR   += SD1->D1_TOTAL
		MsUnlock()
    
	Endif
	
	dbSelectArea("SD1")
	dbSkip()
EndDo


/*
Grupo           Descricao do Grupo             UM     Quantidade          Valor
999999999999999 999999999999999999999999999999 99 99999999999999 99999999999999
0               16                             47 50             65
*/


Cabec1  := "Grupo           Descricao do Grupo             UM     Quantidade          Valor"
Cabec2  := ""
_nTotQt := 0
_nTotVl := 0

dbSelectARea("TRB")
dbGotop()

ProcRegua(LastRec())

While !Eof() .And. !_lFim
	
	_cGrupo  := TRB->GRUPO
	
	If nLin > 65
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	_cDesGR  := TRB->DESGR
	
	@nLin,00 PSAY _cGrupo+" - "+_cDesGR
	
	nLin+=2
	
	_nQt  := 0
	_nVl  := 0
	
	While !Eof() .And. _cGrupo  == TRB->GRUPO
		
		IncProc("Imprimindo")
		
		If nLin > 65
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
			@nLin,00 PSAY _cGrupo+" - "+_cDesGR
			nLin+=2
		Endif
		
		@nLin,00 PSAY TRB->PRODUTO
		@nLin,16 PSAY SUBSTR(TRB->DESCPRO,1,30)
		@nLin,47 PSAY TRB->UM
		@nLin,50 PSAY TRB->QUANT             PICTURE TM(TRB->QUANT,14)
		@nLin,65 PSAY TRB->VALOR             PICTURE TM(TRB->VALOR,14)
		
		nLin++
		
		_nQt += TRB->QUANT
		_nVl += TRB->VALOR
		
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	nLin+=2
		
	If nLin > 65
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@nLin,00 PSAY "TOTAL DO GRUPO --> "+Substr(_cDesGr,1,20)
	@nLin,50 PSAY _nQt                       PICTURE TM(_nQt,14)
	@nLin,65 PSAY _nVl                       PICTURE TM(_nVl,14)

	nLin+=2
	_nTotQt += _nQt
	_nTotVl += _nVl
	
	dbSelectArea("TRB")
EndDo

nLin+= 2

@nLin,00 PSAY "TOTAL GERAL ----> "
@nLin,50 PSAY _nTotQt                       PICTURE TM(_nTotQt,14)
@nLin,65 PSAY _nTotVl                       PICTURE TM(_nTotVl,14)

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

dbSelectArea("TRB")
dbCloseArea()

FErase(cArqTrb+".DBF")


Return