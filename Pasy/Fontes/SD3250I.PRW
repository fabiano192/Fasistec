#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SD3250I   ºAutor  ³Alexandro da Silva  º Data ³  11/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função Utilizada para incluir os movimentos de Perda       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaEst                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SD3250I()

_aAliOri := GETAREA()
_aAliSB1 := SB1->(GETAREA())
_aAliSB2 := SB2->(GETAREA())
_aAliSC2 := SC2->(GetArea())
_aAliSD1 := SD1->(GETAREA())
_aAliSD3 := SD3->(GETAREA())
_aAliSDA := SDA->(GETAREA())
_aAliSDB := SDB->(GETAREA())
_aAliSF5 := SF5->(GetArea())
_aAliSX3 := SX3->(GetArea())
_aAliSX5 := SX5->(GetArea())

If SD3->D3_TM == '101'
	U_PA0228()//Imprime Etiqueta
Endif

// ATUALIZA MOVIMENTO DE DISTRIBUIÇÃO

SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+SD3->D3_COD))

If SB1->B1_LOCALIZ == "S"
	GERALOC()
Endif

dbSelectArea("SD1")
dbOrderNickName("INDSD13")
If dbSeek(xFilial("SD1")+SD3->D3_OP+SD3->D3_COD)
	_lEnvia    := .F.
	_lFim      := .F.
	_cMsg01    := ''
	_lAborta01 := .T.
	_bAcao01   := {|_lFim| 	EnvEm(@_lFim) }
	_cTitulo01 := 'Enviando E-mail !!!!'
	Processa( _bAcao01, _cTitulo01, _cMsg01, _lAborta01 )
	
	dbSelectArea("TRB")
	dbCloseArea()
	
Endif

RestArea(_aAliSB1)
RestArea(_aAliSB2)
RestArea(_aAliSD1)
RestArea(_aAliSD3)
RestArea(_aAliSDA)
RestArea(_aAliSDB)
RestArea(_aAliOri)

If SD3->D3_PERDA == 0
	Return
Endif

If SC2->C2_QUANT == SC2->C2_QUJE + SC2->C2_PERDA
	dbSelectARea("SC2")
	RecLock("SC2",.F.)
	SC2->C2_DATRF := dDataBase
	MsUnlock()
Endif

dbSelectArea("SF5")
dbSetOrder(1)
If dbSeek(xfilial("SF5")+SD3->D3_TM)
	If SF5->F5_TIPO != "P"
		RestArea(_aAliSF5)
		RestArea(_aAliSC2)
		RestArea(_aAliOri)
		Return
	Endif
Endif

SetPrvt("NOPCX,NUSADO,AHEADER,ACOLS,_cConta,_cDescCta,_dAno")
SetPrvt("DDATA,NLINGETD,CTITULO,AC,AR,ACGD")
SetPrvt("CLINHAOK,CTUDOOK,LRETMOD2,")

Private oGetDad
nOpcx:=3

dbSelectArea("Sx3")
dbSetOrder(1)
dbSeek("SBC")
nUsado:=0
aHeader:={}
While !Eof() .And. (x3_arquivo == "SBC")
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And.(Alltrim(x3_campo) $ "BC_MOTIVO/BC_QUANT/BC_NSEDEST/BC_APONTAD")
		nUsado:=nUsado+1
		If RTrim(X3_CAMPO) == "BC_MOTIVO"
			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal, 'U_LIN01()',;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )
			//		ElseIf RTrim(X3_CAMPO) == "BC_QUANT"
			//			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
			//			x3_tamanho, x3_decimal, x3_valid,;
			//			x3_usado, x3_tipo, x3_arquivo, x3_context } )
		ElseIf RTrim(X3_CAMPO) == "BC_QUANT"
			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal, ".T.",x3_usado, x3_tipo, x3_arquivo, x3_context } )
		ElseIf RTrim(X3_CAMPO) == "BC_APONTAD"
			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal, 'U_LINHA01()',;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )
		Else
			AADD(aHeader,{ 'Descricao Motivo da Perda', x3_campo, x3_picture,;
			x3_tamanho, x3_decimal, '',;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )
		Endif
	Endif
	dbSkip()
End

aCols:=Array(1,nUsado+1)
dbSelectArea("Sx3")
dbSeek("SBC")
nUsado:=0
While !Eof() .And. (x3_arquivo == "SBC")
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And.(Alltrim(x3_campo) $ "BC_MOTIVO/BC_QUANT/BC_NSEDEST/BC_APONTAD")
		nUsado:=nUsado+1
		IF nOpcx == 3
			IF x3_tipo == "C"
				aCOLS[1][nUsado] := SPACE(x3_tamanho)
			Elseif x3_tipo == "N"
				aCOLS[1][nUsado] := 0
			Elseif x3_tipo == "D"
				aCOLS[1][nUsado] := dDataBase
			Elseif x3_tipo == "M"
				aCOLS[1][nUsado] := ""
			Else
				aCOLS[1][nUsado] := .F.
			Endif
		Endif
	Endif
	dbSkip()
End
aCOLS[1][nUsado+1] := .F.

Private _cOp        := SD3->D3_OP
Private _cProduto   := SD3->D3_COD
Private _cQtde      := SD3->D3_PERDA
Private _cDocPerda  := SD3->D3_NUMSEQ

nLinGetD:=0

cTitulo:="Apontamento de Perda"
//+--------------------------------------------------------------+
//¦ Array com descricao dos campos do Cabecalho do Modelo 2      ¦
//+--------------------------------------------------------------+
aC:={}
AADD(aC,{"_cQtde"        ,{15,01}    ,"Perda: "          ,"@E 9,999.99","","",.F.})
AADD(aC,{"_cProduto"     ,{15,70}    ,"Produto: "          ,"@E","","SB1",.F.})
AADD(aC,{"_cOP"	         ,{15,220}   ,"O.P. :"	           ,"@E","","SC2",.F.})

aR:={}

aCGD  := {33,10,100,315}
aCord := {120,150,350,815}
/*
1 -  Linha Superior
2 -  Coluna Esquerda
3 -  Linha Inferior
4 -  Coluna Direita
*/
//cLinhaOk:="U_VERLINHA()"
cLinhaOk  :="AllWaysTrue()"
cTudoOk   :="U_VERLINHA()"
//cTudoOk :="AllWaysTrue()"

lRetMod2 := .F.

While !lRetMod2
	lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,aCord)
	_lParar := .T.
EndDo

If lRetMod2
	GravPerda()
Endif

RestArea(_aAliSB1)
RestArea(_aAliSD3)
RestArea(_aAliSX3)
RestArea(_aAliOri)

Return


User Function VerLinha()

Private  _nPMotivo := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="BC_MOTIVO"})
Private  _nPQuant  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="BC_QUANT"})
Private  _nPApont  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="BC_APONTAD"})

_nQuant := 0

For I:= 1 to Len(Acols)
	_cFim := (Len(aHeader)+1)
	If aCols[I,_cFim]
		I := I
	Else
		
		_nQuant += aCols[I,_nPQuant]
		
	Endif
Next I

_lRet := .T.

If _nQuant != SD3->D3_PERDA
	aCols[N,_nPQuant] := 0
	_lRet := .F.
Endif

Return(_lRet)


Static Function GravPerda()

Private  _nPMotivo := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="BC_MOTIVO"})
Private  _nPQuant  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="BC_QUANT"})
Private  _nPApont  := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="BC_APONTAD"})

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+ _cProduto )

_dEmissao := SD3->D3_EMISSAO

For I:= 1 to Len(Acols)
	_cFim := (Len(aHeader)+1)
	If aCols[I,_cFim]
		I := I
	Else
		If !Empty(aCols[I,_nPMotivo]) .And. !Empty(aCols[I,_nPQuant])
			dbSelectArea("SBC")
			RecLock("SBC",.T.)
			SBC->BC_FILIAL   := xFilial("SBC")
			SBC->BC_OP       := _cOp
			SBC->BC_PRODUTO  := _cProduto
			SBC->BC_LOCORIG  := SB1->B1_LOCPAD
			SBC->BC_TIPO     := "R"
			SBC->BC_MOTIVO   := aCols[I,_nPMotivo]
			SBC->BC_QUANT    := aCols[I,_nPQuant]
			SBC->BC_APONTAD  := aCols[I,_nPApont]
			SBC->BC_CODDEST  := _cProduto
			SBC->BC_LOCAL    := "80"
			SBC->BC_QTDDEST  := aCols[I,_nPQuant]
			SBC->BC_DATA     := _dEmissao
			_cNumSeq1        := SOMA1(GetMV("MV_DOCSEQ"))
			PUTMV("MV_DOCSEQ",_cNumSeq1)
			SBC->BC_NUMSEQ   := _cNumSeq1
			_cNumSeq2        := SOMA1(GetMV("MV_DOCSEQ"))
			PUTMV("MV_DOCSEQ",_cNumSeq2)
			SBC->BC_SEQSD3   := _cNumSeq2
			MsUnlock()
			
			dbSelectArea("SD3")
			dbSetOrder(2)
			dbgoBottom()
			
			_cDoc := StrZero(Val(SD3->D3_DOC)+1,6)
			
			dbSelectArea("SD3")
			RecLock("SD3",.T.)
			SD3->D3_FILIAL   := xFilial("SD3")
			SD3->D3_TM       := "499"
			SD3->D3_COD      := _cProduto
			SD3->D3_UM       := SB1->B1_UM
			SD3->D3_QUANT    := aCols[I,_nPQuant]
			SD3->D3_CF       := "DE1"
			SD3->D3_OP       := _cOp
			SD3->D3_LOCAL    := "80"
			SD3->D3_DOC      := NextNumero("SD3",2,"D3_DOC",.T.)
			SD3->D3_EMISSAO  := _dEmissao
			SD3->D3_GRUPO    := SB1->B1_GRUPO
			SD3->D3_NUMSEQ   := _cNumSeq2
			SD3->D3_TIPO     := SB1->B1_TIPO
			SD3->D3_USUARIO  := "SD3250I"
			SD3->D3_CHAVE    := "E0"
			SD3->D3_CHAVPER  := _cDocPerda
			MsUnLock()
			
			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek(xFilial("SB2")+_cProduto + "80")
				dbSelectArea("SB2")
				RecLock("SB2",.F.)
				SB2->B2_QATU += aCols[I,_nPQuant]
				SB2->B2_VATU1 := SB2->B2_QATU * SB2->B2_CM1
				MsUnlock()
			Else
				CriaSB2(_cProduto,"80")
				dbSelectArea("SB2")
				RecLock("SB2",.F.)
				SB2->B2_QATU += aCols[I,_nPQuant]
				SB2->B2_VATU1 := SB2->B2_QATU * SB2->B2_CM1
				MsUnlock()
			Endif
			
		Endif
	Endif
	
Next I


Return



User Function LIN01()

Private  _nPos00   := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="BC_NSEDEST"})

If !ExistCpo("SX5","43"+M->BC_MOTIVO)
	Return(.f.)
Endif

aCols[N,_nPos00]:= TABELA("43",M->BC_MOTIVO)

oGetDad:= CallMod2Obj()
oGetDad:oBrowse:bEditCol := { || ALLWAYSTRUE()}

Return(.t.)


Static Function EnvEm(_lFim)

aStru := {}
AADD(aStru,{"DEPTO"    , "C" , 02, 0 }) // 03 C.Q.
AADD(aStru,{"NUMERO"   , "C" , 06, 0 })
AADD(aStru,{"USUARIO"  , "C" , 15, 0 })
AADD(aStru,{"ENTRADA"  , "D" , 08, 0 })
AADD(aStru,{"ITEM"     , "C" , 04, 0 })
AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
AADD(aStru,{"DESPROD"  , "C" , 60, 0 })
AADD(aStru,{"OP"       , "C" , 13, 0 })
AADD(aStru,{"LOTE"     , "C" , 06, 0 })
AADD(aStru,{"QTDE"     , "N" , 14, 2 })
AADD(aStru,{"VALOR"    , "N" , 14, 2 })

_cArqTrb := CriaTrab(aStru,.T.)
_cIndTrb := "DEPTO+PRODUTO"

dbUseArea(.T.,,_cArqTrb,"TRB",.F.,.F.)
dbSelectArea("TRB")
IndRegua("TRB",_cArqTrb,_cIndTrb,,,"Criando Trabalho...")

_nTotal := 0
_lEnvia := .F.

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+SD3->D3_COD)

dbSelectArea("TRB")
RecLock("TRB",.T.)
TRB->DEPTO   := "01"
TRB->NUMERO  := SD3->D3_DOC
TRB->ENTRADA := SD3->D3_EMISSAO
TRB->USUARIO := SD3->D3_USUARIO
TRB->ITEM    := "0001"
TRB->PRODUTO := SD3->D3_COD
TRB->OP      := SD3->D3_OP
TRB->DESPROD := SB1->B1_DESC
TRB->LOTE    := SD3->D3_LOTECTL
TRB->QTDE    := SD3->D3_QUANT
TRB->VALOR   := SD3->D3_CUSTO1
MsUnlock()

ENVEM2()
ENVEM3()

Return


Static Function ENVEM2()

dbSelectArea("TRB")
dbSeek("01")

Private _lRet

nOpcao := 0

ConOut("Enviando E-Mail para C.Q.:")

oProcess := TWFProcess():New( "ENVEM1", "Producao " )
aCond    :={}
_nTotal  := 0

oProcess:NewTask( "Integracao", "\WORKFLOW\WF0001.HTM" )
oProcess:bReturn  := ""
oProcess:bTimeOut := ""
oHTML := oProcess:oHTML

dbSelectArea("TRB")

_nPerIpi  := 0
nValIPI   := 0
nTotal    := 0

oProcess:cSubject := "Producao PCP "+Dtoc(dDataBase)+" Hora : "+Substr(Time(),1,5)

oHtml:ValByName( "NUMERO" , TRB->NUMERO)
oHtml:ValByName( "ENTRADA", DTOC(TRB->ENTRADA))
oHtml:ValByName( "USUARIO", TRB->USUARIO)

AADD( (oHtml:ValByName( "TB.ITEM"     )), TRB->ITEM)
AADD( (oHtml:ValByName( "TB.PRODUTO"  )), TRB->PRODUTO)
AADD( (oHtml:ValByName( "TB.DESPROD"  )), TRB->DESPROD)
AADD( (oHtml:ValByName( "TB.OP"       )), TRB->OP)
AADD( (oHtml:ValByName( "TB.LOTE"     )), TRB->LOTE)
AADD( (oHtml:ValByName( "TB.QTDE"     )), TRANSFORM( TRB->QTDE,   '@E 999,999,999.99' ))
AADD( (oHtml:ValByName( "TB.VALOR"    )), TRANSFORM( TRB->VALOR,  '@E 999,999,999.99' ))

oProcess:fDesc := "Producao PCP"

_nTotal += TRB->VALOR

oHtml:ValByName( "VALTOTAL", TRANSFORM( _nTotal,  '@E 999,999,999.99' ))

If Alltrim(SB1->B1_GRUPO) $ "PIC"
	_cTo := GETMV("MV_WEMLAB1")
Else
	_cTo := GETMV("MV_WEMCQ1")
Endif
_cCc := ""

oProcess:cTo := _cTo
oProcess:cCC := _cCC

oProcess:Start()
RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10001','Envio Email para C.Q. iniciado!' )

oProcess:Finish()

Return


Static Function ENVEM3()

ConOut("Processo Finalizado" )

oProcess := TWFProcess():New( "ENVEM2", "Compras " )

oProcess:NewTask( "Integracao", "\WORKFLOW\WF0001.HTM" )
oProcess:bReturn  := ""
oProcess:bTimeOut := ""
oHTML := oProcess:oHTML

oProcess:cSubject := "Processo Encerrado"
oProcess:fDesc := "Processo Encerrado"

_cTo := GETMV("MV_WEMPCP2")
oProcess:cTo := _cTo

_cCC := ""
oProcess:cCC := _cCC

oProcess:Start()
RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'10003','Finalizado Integracao' )

oProcess:Free()
oProcess:Finish()

Return


Static Function GERALOC()

_cLocCQ  := GETMV("PA_LOCCQ")
_cNumSer := CriaVar("DB_NUMSERI")
_cItem   := "0001"

SDA->(dbSetOrder(1))
If SDA->(dbSeek(xFilial("SDA")+SD3->D3_COD + SD3->D3_LOCAL + SD3->D3_NUMSEQ + SD3->D3_DOC ))
	CriaSDB(SDA->DA_PRODUTO,SDA->DA_LOCAL,SD3->D3_QUANT,_cLocCQ,_cNumSer,SDA->DA_DOC,SDA->DA_SERIE,SDA->DA_CLIFOR,SDA->DA_LOJA,SDA->DA_TIPONF,SDA->DA_ORIGEM,SD3->D3_EMISSAO,SDA->DA_LOTECTL,SDA->DA_NUMLOTE,SDA->DA_NUMSEQ,"499","D",_cItem,.F.,0,,0)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Baixa saldo classificar do arquivo de saldos em estoque (SB2)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SB2->(dbSetOrder(1))
	If SB2->(dbSeek(xFilial("SB2")+SD3->D3_COD + SD3->D3_LOCAL))
		SB2->(RecLock("SB2",.F.))
		SB2->B2_QACLASS := SB2->B2_QACLASS - SDB->DB_QUANT
		SB2->(MsUnlock())
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Baixa saldo do arquivo de Saldos a classificar   (SDA)       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SDA->(RecLock("SDA",.F.))
	SDA->DA_SALDO   := SDA->DA_SALDO   - SDB->DB_QUANT
	SDA->DA_QTSEGUM := SDA->DA_QTSEGUM - SDB->DB_QTSEGUM
	SDA->DA_EMPENHO := SDA->DA_EMPENHO - SDB->DB_EMPENHO
	SDA->DA_EMP2    := SDA->DA_EMP2    - SDB->DB_EMP2
	SDA->(MsUnlock())
	
	GRAVASBF("SDB")
Endif

Return