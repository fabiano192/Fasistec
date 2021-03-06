#INCLUDE "rwmake.ch"
#include "EECRDM.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PA0049a     � Autor � Fabiano da Silva  � Data �  27/12/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo						                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Sigafat                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PA0049a()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
                                     



Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Produto X Cliente"
Local cPict          := ""
Local titulo       	 := "Produto X Cliente"
Local nLin         	 := 80

Local Cabec1       	 := "Produto Pasy   Produto Cliente    Cliente   Loja    Preco Data"
Local Cabec2         := "teste   teste"
Local imprime        := .T.
Private CSEQREL      
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

Private cPictPreco  := "9,999.9999"
Private cPictQtde   := "9,999,999.99"

Private cString      := "SZ2"
Private lRodape		 :=.T.
dbSelectArea("SZ2")
dbSetOrder(1)
_cMod   := cModulo
cModulo := "EEC"


pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| IMPREL(Cabec1,Cabec2,Titulo,nLin) },Titulo)
cModulo := _cMod
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �IMPREL    � Autor � AP6 IDE            � Data �  27/12/04   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

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


_lAbri := E_ARQCRW()	

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
	
	_dDataRef := SZ2->Z2_DTREF01
	_nValor   := SZ2->Z2_PRECO01
	For i := 2 to 12
		If &("SZ2->Z2_DTREF"+StrZero(i,2)) >= _dDataRef
			_dDataRef := &("SZ2->Z2_DTREF"+StrZero(i,2))
			_nValor   := &("SZ2->Z2_PRECO"+StrZero(i,2))
		Endif
	Next i
	                   
	DETAIL_P->(dbAppend())
	DETAIL_P->AVG_CHAVE  := "PA0049A"
    DETAIL_P->AVG_C01_20 := AllTrim(SZ2->Z2_PRODUTO)
    DETAIL_P->AVG_C02_20 := AllTrim(SZ2->Z2_CODCLI)
	DETAIL_P->AVG_C03_20 := AllTrim(SZ2->Z2_CLIENTE)
	DETAIL_P->AVG_C04_20 := AllTrim(SZ2->Z2_LOJA)
	DETAIL_P->AVG_C05_20 := ALLTRIM(Transf(_nValor,cPictPreco))
	DETAIL_P->AVG_C06_20 := ALLTRIM(DTOC(_dDataRef))
 	DETAIL_P->(dbUnlock())                               
	DETAIL_P->(DBCOMMIT())
                               
	DETAIL_P->(dbSetOrder(0))      
	DETAIL_P->(DbGoTop())
	Do While ! DETAIL_P->(Eof())
    	DETAIL_H->(DbAppend())
    	AvReplace("DETAIL_P","DETAIL_H")
    	DETAIL_P->(DbSkip())
	EndDo
                      
	DETAIL_H->(DBCOMMIT())
	dbSelectArea("SZ2")         
	dbSkip() 
EndDo

_cRpt := "PA0049A.RPT"           
AvgCrw32(_cRpt,"Tabela de Preco",CSEQREL)

Return
