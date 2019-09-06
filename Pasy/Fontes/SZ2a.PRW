#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SZ2A	     º Autor ³ Fabiano da Silva  º Data ³  27/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo						                              º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SZ2A()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Produto X Cliente"
Local cPict          := ""
Local titulo       	 := "Produto X Cliente"
Local nLin         	 := 80
Local Cabec1       	 := ""
Local Cabec2         := ""
Local imprime        := .T.
Private aOrd         := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132 
Private tamanho      := "M"
Private nomeprog     := "SZ2A"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "PA0049"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "SZ2A"
Private cString      := "SZ2"
Private lRodape		 :=.T.

dbSelectArea("SZ2")
dbSetOrder(1)

pergunte(cPerg,.F.)

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

cabec1:= ""
cabec2:= ""

aStru := {}
AADD(aStru,{"PRODUTO"  , "C" , 15, 0 })
AADD(aStru,{"PRODCLI"  , "C" , 15, 0 })
AADD(aStru,{"CLIENTE"  , "C" ,  6, 0 })
AADD(aStru,{"QUANT"    , "N" , 12, 2 })
AADD(aStru,{"UNIT"     , "N" , 12, 4 })
AADD(aStru,{"TOTAL"    , "N" , 12, 4 })
AADD(aStru,{"TES"      , "C" ,  3, 0 })
AADD(aStru,{"NOTA"     , "C" ,  6, 0 })
AADD(aStru,{"DTFAT"    , "D" ,  8, 0 })
AADD(aStru,{"PRCSZ2"   , "N" , 12, 4 })
AADD(aStru,{"DTSZ2"    , "D" ,  8, 0 })

cArqLOG := CriaTrab(aStru,.T.)
cIndLOG := "PRODCLI"
dbUseArea(.T.,,cArqLOG,"TRB",.F.,.F.)

dbSelectArea("TRB")
IndRegua("TRB",cArqLog,cIndLog,,,"Criando Trabalho...")

_cQuery := " SELECT * FROM "+RetSqlName("SD2")+" D2"
_cQuery += " WHERE D2.D_E_L_E_T_ = '' "
_cQuery += " AND D2_CLIENTE = '000008' AND D2_EMISSAO > '20071130' "
_cQuery += " ORDER BY D2_PROCLI "

TCQUERY _cQuery New ALIAS "ZD2A"      

TCsetField("ZD2A","D2_EMISSAO","D")
TCsetField("ZD2A","D2_QUANT","N",12,2)
TCsetField("ZD2A","D2_PRCVEN","N",12,4)
TCsetField("ZD2A","D2_TOTAL","N",12,4)

ZD2A->(dbGotop())

ProcRegua(ZD2A->(U_CONTREG()))

While !Eof()
	
	IncProc()
					
	dbSelectArea("SZ2")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ2")+ZD2A->D2_CLIENTE+ZD2A->D2_LOJA+ZD2A->D2_COD+ZD2A->D2_PROCLI+"1")

		_dDataRef := SZ2->Z2_DTREF01
		_nValor   := SZ2->Z2_PRECO01

		For i := 2 to 12
			If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= _dDataRef
				_dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
				_nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
			Endif
		Next i

		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->PRODUTO	:= ZD2A->D2_COD
		TRB->PRODCLI	:= ZD2A->D2_PROCLI
		TRB->CLIENTE	:= ZD2A->D2_CLIENTE
		TRB->QUANT		:= ZD2A->D2_QUANT
		TRB->UNIT		:= ZD2A->D2_PRCVEN
		TRB->TOTAL		:= ZD2A->D2_TOTAL
		TRB->TES		:= ZD2A->D2_TES
		TRB->NOTA		:= ZD2A->D2_DOC
		TRB->DTFAT		:= ZD2A->D2_EMISSAO
		TRB->PRCSZ2		:= _nValor
		TRB->DTSZ2		:= _dDataRef
		MsUnlock()
	Endif
	                                                                                                        
	dbSelectArea("ZD2A")	
	dbSkip()
EndDo

_cArqNovo := "\RELATO\SZ2.DBF"
dbSelectArea("TRB")
Copy all to &_cArqNovo

dbCloseArea()

dbSelectArea("ZD2A")
dbCloseArea()

If !ApOleClient( 'MsExcel' )
	MsgStop('MsExcel nao instalado')
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( "F:\AP8\DADOS\RELATO\SZ2.DBF" )
oExcelApp:SetVisible(.T.)

Return
