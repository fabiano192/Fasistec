#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPA0049     บ Autor ณ Fabiano da Silva  บ Data ณ  27/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo						                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Sigafat                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PA0049


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Produto X Cliente"
Local cPict          := ""
Local titulo       	 := "Produto X Cliente"
Local nLin         	 := 80

Local Cabec1       	 := "Produto Pasy   Produto Cliente    Cliente   Loja    Preco Data"
Local Cabec2         := "teste   teste"
Local imprime        := .T.
Private aOrd         := {"Por Prod.Pasy","Por Prod.Cliente"}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80 
Private tamanho      := "P"
Private nomeprog     := "PA0049" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "PA0049"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PA0049" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := "SZ2"
Private lRodape		 :=.T.
dbSelectArea("SZ2")
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

RptStatus({|| IMPREL(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return


Static Function IMPREL(Cabec1,Cabec2,Titulo,nLin)

///////////////////////////////////////////
///////////////////////////////////////////
/// MV_PAR01	:	CLIENTE DE          ///
/// MV_PAR02	:	CLIENTE ATE         ///
///	MV_PAR03	:	LOJA DE             ///
/// MV_PAR04	:	LOJA ATE            ///
/// MV_PAR05	:	PRODUTO PASY DE     ///
/// MV_PAR06	:   PRODUTO PASY ATE    ///
/// MV_PAR07	:   PRODUTO CLIENTE DE  ///
/// MV_PAR08	:   PRODUTO CLIENTE ATE ///
///////////////////////////////////////////
///////////////////////////////////////////

/*
Prod.Pasy       Prod.Cliente    Cliente Lj        Preco Data Ref. Dt.Base Econ.   
999999999999999 999999999999999 999999  99 999999999999 999999999 9999999999999   
0               16              32      40 43           56        66                     
*/


cabec1:= "Prod.Pasy       Prod.Cliente    Cliente Lj        Preco Data Ref. Dt.Base Econ.   "
cabec2:= ""

nOrdem := aReturn[8]

dbSelectArea(cString)
IF nOrdem == 1
	dbSetOrder(1)
Else
	dbSetOrder(3)
Endif

dbSeek(xfilial("SZ2")+MV_PAR01+MV_PAR03,.T.)

SetRegua(RecCount())

While !EOF() .And. SZ2->Z2_CLIENTE <= MV_PAR02
	
	IncProc()
	
	IncRegua()
	
	If	SZ2->Z2_Loja    < MV_PAR03 .OR.;
		SZ2->Z2_Loja    > MV_PAR04 .OR.;
		SZ2->Z2_Produto < MV_PAR05 .OR.;
		SZ2->Z2_Produto > MV_PAR06 .OR.;
		SZ2->Z2_Codcli  < MV_PAR07 .OR.;
		SZ2->Z2_Codcli  > MV_PAR08
		dbSkip()
		Loop
	Endif
	                       
	If SZ2->Z2_ATIVO == "2"
		dbSkip()
		Loop
	Endif
		
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 57 
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	_dDataRef := SZ2->Z2_DTREF01
	_nValor   := SZ2->Z2_PRECO01 
	_dDataBas := SZ2->Z2_DTBAS01
	For i := 2 to 12
		If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= _dDataRef
			_dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
			_dDatabAS := &("SZ2->Z2_DTBAS"+StrZero(i,2))
			_nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
		Endif
	Next i
	                                                                                     
	@nLin,00 PSAY SZ2->Z2_PRODUTO
	@nLin,16 PSAY SZ2->Z2_CODCLI
	@nlin,32 PSAY SZ2->Z2_CLIENTE
	@nlin,40 PSAY SZ2->Z2_LOJA
	@nlin,43 PSAY _nValor           Picture TM(_nValor,12,4)
	@nlin,56 PSAY _dDataRef
	@nlin,66 PSAY _dDataBas
	nLin ++
	
	dbSkip()
EndDo

IF lRodape
	roda(cbcont,cbtxt,tamanho)
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

Return
